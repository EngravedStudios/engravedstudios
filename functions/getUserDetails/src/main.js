import { Client, Users, Teams, Databases, Query, Account } from 'node-appwrite';

/**
 * Get detailed information about a specific user
 */
export default async ({ req, res, log, error }) => {
    const client = new Client()
        .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://fra.cloud.appwrite.io/v1')
        .setProject(process.env.APPWRITE_PROJECT_ID)
        .setKey(process.env.APPWRITE_API_KEY);

    const users = new Users(client);
    const databases = new Databases(client);

    try {
        // 1. Validate Admin JWT
        const adminUser = await validateAdmin(req.headers.authorization || req.headers['authorization'], client);
        if (!adminUser) {
            return res.json({ error: 'Unauthorized - Admin access required' }, 403);
        }

        // 2. Parse request
        const body = typeof req.body === 'string' ? JSON.parse(req.body) : req.body || {};
        const { userId } = body;

        if (!userId) {
            return res.json({ error: 'userId is required' }, 400);
        }

        log(`Admin ${adminUser.email} requesting details for user ${userId}`);

        // 3. Get user details
        const user = await users.get(userId);
        const memberships = await users.listMemberships(userId);

        // 4. Get metadata from custom collection (if exists)
        let metadata = {};
        try {
            const metadataDoc = await databases.getDocument(
                process.env.APPWRITE_DATABASE_ID,
                'user_metadata',
                userId
            );
            metadata = metadataDoc;
        } catch {
            // No metadata exists, that's okay
        }

        // 5. Enrich teams with names
        const teams = new Teams(client);
        const enrichedTeams = await Promise.all(
            memberships.memberships.map(async (m) => {
                try {
                    const team = await teams.get(m.teamId);
                    return {
                        teamId: m.teamId,
                        teamName: team.name,
                        roles: m.roles,
                    };
                } catch (err) {
                    log(`Error getting team ${m.teamId}: ${err.message}`);
                    return {
                        teamId: m.teamId,
                        teamName: 'Unknown',
                        roles: m.roles,
                    };
                }
            })
        );

        // 6. Log audit
        try {
            await logAudit(databases, {
                action: 'VIEW_USER_DETAILS',
                performedBy: adminUser.id,
                targetUserId: userId,
            });
        } catch (auditErr) {
            log(`Audit log failed: ${auditErr.message}`);
        }

        return res.json({
            userId: user.$id,
            name: user.name,
            email: user.email,
            emailVerified: user.emailVerification,
            phone: user.phone || null,
            teams: enrichedTeams,
            metadata,
            createdAt: user.$createdAt,
        });

    } catch (err) {
        error(`Get user details error: ${err.message}`);
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
