# API Integration Notes

The application communicates with a remote restaurant backend through Dio and the centralized `ApiHelper`.

## Authentication

```text
POST /api/Account/login
POST /api/Account/register
POST /api/Account/forgot-password
GET  /api/Account/profile
```

Successful authentication stores the returned token and role locally. The token is then sent as a bearer token for subsequent requests.

## Branches

```text
GET    /api/Branch/all
POST   /api/Branch/create
PUT    /api/Branch/update/{id}
DELETE /api/Branch/delete/{id}
```

## Branch Schedules

```text
GET /api/BranchSchedule/all/{branchId}
GET /api/BranchSchedule/schedule-day/{branchId}/{date}
```

## Request Pipeline

```text
Screen
  ↓
ApiCubit
  ↓
ApiHelper
  ↓
Dio
  ↓
Backend API
```

## Error Handling

API operations emit an error state when a request fails or returns an unexpected status code. UI layers can listen to these states and present appropriate feedback to the user.

> **Production note:** The current API base URL is configured directly in the API helper. A future version should move it to environment-specific configuration.
