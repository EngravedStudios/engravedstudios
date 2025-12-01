# Admin User-Management System - Deployment Guide

## Prerequisites Checklist

Before deploying, ensure you have:

- [x] Appwrite CLI installed (`npm install -g appwrite-cli`)
- [x] Admin team created in Appwrite Console
- [x] API key with correct scopes created
- [x] Environment variables configured in `.env`

## Step 1: Create Appwrite Collections

### 1.1 Create `audit_logs` Collection

1. Go to Appwrite Console → Databases → `noted`
2. Click "Create Collection"
3. Name: `audit_logs`
4. Collection ID: `audit_logs`

**Attributes:**
```
action (String, required, 128) - Action performed
performedBy (String, required, 36) - Admin user ID
targetUserId (String, optional, 36) - Affected user ID
metadata (String, optional, 1000) - JSON metadata
timestamp (DateTime, required) - When action occurred
```

**Indexes:**
```
performedBy_index (key: performedBy, type: ascending)
timestamp_index (key: timestamp, type: descending)
action_index (key: action, type: ascending)
```

**Permissions:**
```
Read: team:APPWRITE_TEAM_ADMINS
Create: team:APPWRITE_TEAM_ADMINS
Update: team:APPWRITE_TEAM_ADMINS
Delete: team:APPWRITE_TEAM_ADMINS
```

### 1.2 Create `user_metadata` Collection

1. Go to Appwrite Console → Databases → `noted`
2. Click "Create Collection"
3. Name: `user_metadata`
4. Collection ID: `user_metadata`

**Attributes:**
```
userId (String, required, 36) - User ID (use as document ID)
lastLogin (DateTime, optional) - Last login timestamp
postsCreated (Integer, optional, default: 0) - Number of posts
customRole (String, optional, 64) - Custom role label
notes (String, optional, 500) - Admin notes
```

**Permissions:**
```
Read: team:APPWRITE_TEAM_ADMINS
Create: team:APPWRITE_TEAM_ADMINS
Update: team:APPWRITE_TEAM_ADMINS
Delete: team:APPWRITE_TEAM_ADMINS
```

## Step 2: Deploy Appwrite Functions

### 2.1 Install Dependencies for Each Function

```bash
cd functions/searchUsers
npm init -y
npm install node-appwrite

cd ../getUserDetails
npm init -y
npm install node-appwrite

cd ../updateUserRoles
npm init -y
npm install node-appwrite

cd ../deleteUser
npm init -y
npm install node-appwrite

cd ../..
```

### 2.2 Deploy Functions via Appwrite CLI

```bash
# Login to Appwrite
appwrite login

# Deploy all functions
appwrite deploy function \
  --function-id searchUsers \
  --name "Search Users" \
  --runtime node-18.0 \
  --entrypoint src/main.js \
  --code functions/searchUsers

appwrite deploy function \
  --function-id getUserDetails \
  --name "Get User Details" \
  --runtime node-18.0 \
  --entrypoint src/main.js \
  --code functions/getUserDetails

appwrite deploy function \
  --function-id updateUserRoles \
  --name "Update User Roles" \
  --runtime node-18.0 \
  --entrypoint src/main.js \
  --code functions/updateUserRoles

appwrite deploy function \
  --function-id deleteUser \
  --name "Delete User" \
  --runtime node-18.0 \
  --entrypoint src/main.js \
  --code functions/deleteUser
```

### 2.3 Configure Function Environment Variables

For each function, set environment variables in Appwrite Console:

```
APPWRITE_ENDPOINT=https://fra.cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=692360ef002dcc7a0255
APPWRITE_DATABASE_ID=noted
APPWRITE_API_KEY=standard_e6d6d2db...
APPWRITE_TEAM_ADMINS=692ca7080009958e8ca4
APPWRITE_TEAM_WRITERS=692ca6f90025a66aa7ab
APPWRITE_TEAM_VIPS=692ca6e6003c8b692771
APPWRITE_TEAM_USERS=692ca6d1001b3450cceb
```

## Step 3: Test Functions

### 3.1 Get JWT Token

In your Flutter app, add temporary code to log JWT:

```dart
final jwt = await Account(client).createJWT();
print('JWT: ${jwt.jwt}');
```

### 3.2 Test with cURL

```bash
# Test searchUsers
curl -X POST https://fra.cloud.appwrite.io/v1/functions/searchUsers/executions \
  -H "X-Appwrite-Project: 692360ef002dcc7a0255" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "", "limit": 10}'

# Test getUserDetails
curl -X POST https://fra.cloud.appwrite.io/v1/functions/getUserDetails/executions \
  -H "X-Appwrite-Project: 692360ef002dcc7a0255" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"userId": "YOUR_USER_ID"}'
```

## Step 4: Flutter Integration

### 4.1 Run Code Generation

```bash
cd /Users/dohlepascal/Documents/Voit/blog
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4.2 Add Admin Navigation

Add a button to navigate to admin dashboard. Example in `settings_screen.dart`:

```dart
if (authState.valueOrNull?.role == UserRole.admin)
  ListTile(
    leading: Icon(Icons.admin_panel_settings),
    title: Text('Admin Dashboard'),
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminGuard(
          child: AdminDashboardScreen(),
        ),
      ),
    ),
  ),
```

### 4.3 Test Flutter App

```bash
flutter run -d chrome
```

## Step 5: Security Verification

### 5.1 Verify Admin Guard

1. Try accessing admin dashboard without login → Should show unauthorized
2. Try accessing as non-admin user → Should show unauthorized
3. Access as admin → Should work

### 5.2 Test Function Authorization

1. Try calling functions without JWT → Should return 403
2. Try calling with non-admin JWT → Should return 403
3. Call with admin JWT → Should work

### 5.3 Test Self-Deletion Prevention

Try deleting your own admin account → Should fail with error message

## Step 6: Production Deployment

### 6.1 Set up CI/CD (Optional)

Create `.github/workflows/deploy-functions.yml`:

``yaml
name: Deploy Appwrite Functions

on:
  push:
    branches: [main]
    paths:
      - 'functions/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install Appwrite CLI
        run: npm install -g appwrite-cli
      - name: Deploy Functions
        env:
          APPWRITE_ENDPOINT: ${{ secrets.APPWRITE_ENDPOINT }}
          APPWRITE_PROJECT_ID: ${{ secrets.APPWRITE_PROJECT_ID }}
          APPWRITE_API_KEY: ${{ secrets.APPWRITE_API_KEY }}
        run: |
          appwrite login --endpoint $APPWRITE_ENDPOINT --project $APPWRITE_PROJECT_ID
          # Deploy each function
          for dir in functions/*/; do
            appwrite deploy function --code ${dir}
          done
``

### 6.2 Monitor Logs

Check function execution logs in Appwrite Console → Functions → [Function Name] → Executions

## Troubleshooting

### Common Issues

**Issue:** "Unauthorized" error when calling functions
- **Solution:** Ensure JWT is being passed correctly and user is in admin team

**Issue:** "Document not found" in audit logs
- **Solution:** Create the `audit_logs` collection first

**Issue:** Functions timing out
- **Solution:** Increase timeout limit in function settings (Max: 900 seconds)

**Issue:** "Invalid email" when adding to team
- **Solution:** Ensure user email is verified or use correct email format

## Next Steps

1. ✅ Deploy collections
2. ✅ Deploy functions
3. ✅ Test functions
4. ✅ Integrate in Flutter
5. ✅ Security verification
6. 🔄 Production deployment
7. 📊 Monitor usage
8. 🔒 Review security periodically

## Support

- Appwrite Docs: https://appwrite.io/docs
- Appwrite Discord: https://discord.gg/appwrite
- GitHub Issues: Create in your repository
