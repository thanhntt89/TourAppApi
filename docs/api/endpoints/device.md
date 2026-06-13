# Device

> **Auth:** Public (no header required)

---

## POST /device/register

Register or update a device. Call on first launch and on every app update.

### Request Params

| Param | Required | Type | Notes |
|-------|----------|------|-------|
| `device_uuid` | ✓ | string | Persistent UUID generated on device |
| `device_name` | | string | e.g. "Samsung Galaxy S24" |
| `platform` | | string | `android` \| `ios` |
| `app_version` | | string | e.g. "1.2.0" |
| `lang` | | string | Preferred content language (`vi`, `en`, ...) |
| `push_token` | | string | FCM / APNs token for push notifications |
| `referral_code` | | string | Invitation code from another user |

### Response

```json
{
  "success": true,
  "data": {
    "is_new": true,
    "wallet_balance": 0,
    "referral_code": "ABC123"
  }
}
```

| Field | Description |
|-------|-------------|
| `is_new` | `true` on first registration, `false` on subsequent calls |
| `wallet_balance` | Current Buckwheat Flowers balance |
| `referral_code` | This device's shareable referral code |

### Notes

- Re-calling with the same UUID updates `device_name`, `app_version`, `push_token`, `lang` — no duplicate created
- `referral_code` in request is only processed once (first registration)
- Stored in `wp_ta_devices`
