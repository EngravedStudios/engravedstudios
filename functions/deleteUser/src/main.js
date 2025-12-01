import { Client, Users, Teams, Databases, Query, Account } from 'node-appwrite';

/**
 * Delete a user
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

        // 3. Prevent self-deletion
        if (userId === adminUser.id) {
            return res.json({ error: 'Cannot delete your own account' }, 400);
        }

        log(`Admin ${adminUser.email} deleting user ${userId}`);

        // 4. Get user for audit log
        const user = await users.get(userId);

        // 5. Delete user (automatically removes from teams)
        await users.delete(userId);
        log(`User ${userId} deleted successfully`);

        // 6. Log audit
        try {
            await logAudit(databases, {
                action: 'DELETE_USER',
                performedBy: adminUser.id,
                targetUserId: userId,
                metadata: JSON.stringify({
                    deletedUserEmail: user.email,
                    deletedUserName: user.name,
                }),
            });
        } catch (auditErr) {
            log(`Audit log failed: ${auditErr.message}`);
        }

        return res.json({
            success: true,
            deletedUserId: userId,
        });

    } catch (err) {
        error(`Delete user error: ${err.message}`);
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
