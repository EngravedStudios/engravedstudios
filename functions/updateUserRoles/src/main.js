import { Client, Users, Teams, Databases, Query, Account } from 'node-appwrite';

/**
 * Update user roles (team memberships)
 */
export default async ({ req, res, log, error }) => {
    const client = new Client()
        .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://fra.cloud.appwrite.io/v1')
        .setProject(process.env.APPWRITE_PROJECT_ID)
        .setKey(process.env.APPWRITE_API_KEY);

    const users = new Users(client);
    const teams = new Teams(client);
    const databases = new Databases(client);

    try {
        // 1. Validate Admin JWT
        const adminUser = await validateAdmin(req.headers.authorization || req.headers['authorization'], client);
        if (!adminUser) {
            return res.json({ error: 'Unauthorized - Admin access required' }, 403);
        }

        // 2. Parse request
        const body = typeof req.body === 'string' ? JSON.parse(req.body) : req.body || {};
        const { userId, addTeams = [], removeTeams = [] } = body;

        if (!userId) {
            return res.json({ error: 'userId is required' }, 400);
        }

        log(`Admin ${adminUser.email} updating roles for user ${userId}`);

        // 3. Get user to validate existence and get email
        const user = await users.get(userId);

        // 4. Remove from teams
        for (const teamId of removeTeams) {
            try {
                const memberships = await teams.listMemberships(
                    teamId,
                    [Query.equal('userId', userId)]
                );

                for (const membership of memberships.memberships) {
                    await teams.deleteMembership(teamId, membership.$id);
                    log(`Removed user ${userId} from team ${teamId}`);
                }
            } catch (err) {
                log(`Error removing from team ${teamId}: ${err.message}`);
            }
        }

        // 5. Add to teams
        for (const teamId of addTeams) {
            try {
                await teams.createMembership(
                    teamId,
                    ['member'],
                    user.email
                );
                log(`Added user ${userId} to team ${teamId}`);
            } catch (err) {
                log(`Error adding to team ${teamId}: ${err.message}`);
            }
        }

        // 6. Get updated teams
        const updatedMemberships = await users.listMemberships(userId);
        const updatedTeams = updatedMemberships.memberships.map(m => m.teamId);

        // 7. Log audit
        try {
            await logAudit(databases, {
                action: 'UPDATE_USER_ROLES',
                performedBy: adminUser.id,
                targetUserId: userId,
                metadata: JSON.stringify({
                    addedTeams: addTeams,
                    removedTeams: removeTeams,
                }),
            });
        } catch (auditErr) {
            log(`Audit log failed: ${auditErr.message}`);
        }

        return res.json({
            success: true,
            userId,
            updatedTeams,
        });

    } catch (err) {
        error(`Update user roles error: ${err.message}`);
        return res.json({ error: err.message }, 500);
    }
};

async function validateAdmin(authHeader, client) {
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return null;
    }

    const jwt = authHeader.substring(7);
    const account = new Account(client);
    account.client.setJWT(jwt);

    try {
        const user = await account.get();
        const teams = new Teams(client);
        const memberships = await teams.listMemberships(
            process.env.APPWRITE_TEAM_ADMINS,
            [Query.equal('userId', user.$id)]
        );

        return memberships.total > 0 ? { id: user.$id, email: user.email } : null;
    } catch {
        return null;
    }
}

async function logAudit(databases, data) {
    try {
        await databases.createDocument(
            process.env.APPWRITE_DATABASE_ID,
            'audit_logs',
            'unique()',
            {
                ...data,
                timestamp: new Date().toISOString(),
            }
        );
    } catch {
        // Fail silently
    }
}
