import { Client, Users, Teams, Databases, Query, Account } from 'node-appwrite';

/**
 * Search users with filtering and pagination
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
            log('Unauthorized access attempt');
            return res.json({ error: 'Unauthorized - Admin access required' }, 403);
        }

        log(`Admin ${adminUser.email} searching users`);

        // 2. Parse request
        const body = typeof req.body === 'string' ? JSON.parse(req.body) : req.body || {};
        const { query: searchQuery = '', limit = 50, offset = 0, filters } = body;

        // 3. Search users
        const searchQueries = [];
        if (searchQuery) {
            searchQueries.push(Query.search('name', searchQuery));
        }
        searchQueries.push(Query.limit(Math.min(limit, 100)));
        searchQueries.push(Query.offset(offset));

        const result = await users.list(searchQueries);
        log(`Found ${result.total} users`);

        // 4. Enrich with team data
        const enrichedUsers = await Promise.all(
            result.users.map(async (user) => {
                try {
                    const memberships = await users.listMemberships(user.$id);
                    return {
                        userId: user.$id,
                        name: user.name,
                        email: user.email,
                        emailVerified: user.emailVerification,
                        phone: user.phone || null,
                        teams: memberships.memberships.map(m => m.teamId),
                        createdAt: user.$createdAt,
                        metadata: {},
                    };
                } catch (err) {
                    log(`Error enriching user ${user.$id}: ${err.message}`);
                    return {
                        userId: user.$id,
                        name: user.name,
                        email: user.email,
                        emailVerified: user.emailVerification,
                        phone: user.phone || null,
                        teams: [],
                        createdAt: user.$createdAt,
                        metadata: {},
                    };
                }
            })
        );

        // 5. Apply filters
        let filteredUsers = enrichedUsers;
        if (filters?.role) {
            const roleTeamId = getRoleTeamId(filters.role);
            if (roleTeamId) {
                filteredUsers = enrichedUsers.filter(u => u.teams.includes(roleTeamId));
            }
        }

        // 6. Log audit
        try {
            await logAudit(databases, {
                action: 'SEARCH_USERS',
                performedBy: adminUser.id,
                metadata: JSON.stringify({
                    query: searchQuery,
                    resultCount: filteredUsers.length,
                }),
            });
        } catch (auditErr) {
            log(`Audit log failed: ${auditErr.message}`);
        }

        return res.json({
            users: filteredUsers,
            total: filteredUsers.length,
            hasMore: result.total > (offset + limit),
        });

    } catch (err) {
        error(`Search users error: ${err.message}`);
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

function getRoleTeamId(role) {
    const roleMap = {
        'admin': process.env.APPWRITE_TEAM_ADMINS,
        'writer': process.env.APPWRITE_TEAM_WRITERS,
        'vip': process.env.APPWRITE_TEAM_VIPS,
        'viewer': process.env.APPWRITE_TEAM_USERS,
    };
    return roleMap[role] || null;
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
    } catch (err) {
        // Fail silently if audit log collection doesn't exist yet
    }
}
