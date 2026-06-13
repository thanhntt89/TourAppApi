# User Journeys (Custom)

> **Auth:** All require `X-Device-UUID` header 🔒

Custom journeys created by users (distinct from preset journeys in `/journeys`).

---

## GET /user/journeys

List all custom journeys for this device.

---

## POST /user/journeys

Create a new custom journey.

### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `name` | ✓ | string | Journey name |
| `stops` | | array | Array of stop objects |

### Free Plan Limit

Returns `403 journey_limit_reached` when the device already has 5 or more journeys and has not unlocked `unlimited_journeys`.

Error response includes:
```json
{
  "success": false,
  "error": {
    "code": "journey_limit_reached",
    "message": "...",
    "details": {
      "limit": 5,
      "current": 5,
      "feature": "unlimited_journeys"
    }
  }
}
```

Use `details.feature` to show the correct upgrade prompt in Flutter.

---

## PUT /user/journeys/{id}

Update a custom journey and its stops.

### Params

| Param | Type | Notes |
|-------|------|-------|
| `name` | string | New name |
| `stops` | array | Full replacement of stops array |

---

## DELETE /user/journeys/{id}

Delete a custom journey. Only the owning device can delete.

### Errors

| Code | HTTP | Description |
|------|------|-------------|
| `journey_not_found` | 404 | Journey does not exist or belongs to another device |
