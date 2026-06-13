# User Actions

> **Auth:** All require `X-Device-UUID` header 🔒

---

## POST /user/checkin

Check in at a place via GPS or QR code.

### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `place_id` | ✓ | integer | Place post ID |
| `method` | ✓ | string | `gps` \| `qr` |
| `latitude` | | number | Required when `method=gps` |
| `longitude` | | number | Required when `method=gps` |
| `qr_code` | | string | Required when `method=qr` |

### Business Rules

- **GPS:** validates device is within `place_geofence_radius` meters (default 300m) using Haversine formula
- **One check-in per device per place** — second check-in at same place returns `409 already_checked_in`
- Earns `place_checkin_reward` Buckwheat Flowers (default +10)

### Response

```json
{
  "success": true,
  "data": {
    "checkin_id": 42,
    "flowers_earned": 10,
    "new_balance": 50
  }
}
```

---

## POST /user/unlock

Unlock paid content (article or audio) using Buckwheat Flowers.

### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `content_type` | ✓ | string | `article` \| `audio` |
| `content_id` | ✓ | integer | Post ID of the content |

Supported content post types: `place`, `sub_place`, `ta_story`

### Response

```json
{
  "success": true,
  "data": {
    "content_type": "article",
    "content_id": 100,
    "flowers_spent": 5,
    "new_balance": 45
  }
}
```

---

## GET /user/history

Check-in history and stats for the device.

### Response

```json
{
  "success": true,
  "data": {
    "total_checkins": 12,
    "checkins": [
      {
        "place_id": 100,
        "place_name": "Cột cờ Lũng Cú",
        "method": "gps",
        "checked_in_at": "2025-06-01T10:30:00Z"
      }
    ]
  }
}
```

---

## GET /user/wallet

Wallet balance and last 10 transactions.

### Response

```json
{
  "success": true,
  "data": {
    "balance": 45,
    "transactions": [
      {
        "type": "checkin",
        "amount": 10,
        "balance_after": 50,
        "description": "Check-in: Cột cờ Lũng Cú",
        "created_at": "2025-06-01T10:30:00Z"
      }
    ]
  }
}
```

---

## POST /user/share

Record a social share event (earns +2 flowers per platform per day).

### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `platform` | ✓ | string | `facebook` \| `instagram` \| `tiktok` \| `zalo` \| `other` |
| `content_type` | | string | `place` \| `story` \| `journey` |
| `content_id` | | integer | Post ID of shared content |

---

## POST /user/referral/redeem

Redeem an invitation referral code (one-time per device, only on new accounts).

### Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `referral_code` | ✓ | string | Code from another device |

### On success

- Invitee gets +3 flowers
- Inviter gets +5 flowers

### Errors

| Code | HTTP | Description |
|------|------|-------------|
| `referral_already_used` | 409 | Device already redeemed a code |
| `referral_not_found` | 404 | Code does not exist |
| `referral_self` | 400 | Cannot use own referral code |
