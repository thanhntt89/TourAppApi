# Plugin Structure & Reference

---

## File Structure

```
toursapp-api/
├── toursapp-api.php                        Main plugin, CPT registration, hooks, cron
├── uninstall.php                           Full DB cleanup (15 tables) on WP Admin delete
├── assets/
│   ├── gallery-meta.css + .js             Media gallery picker (multi-image, drag-reorder)
│   ├── audio-url.js                       Audio URL input + Browse button + inline preview player
│   ├── news-icon.js                       Auto-fill icon when news type dropdown changes
│   └── journey-stops.css + .js           Journey stops table UI (single/multi-province mode)
└── includes/
    ├── class-ta-api.php                   Route registry + strict mode + endpoint on/off filters
    ├── class-ta-api-logger.php            Async API request logging + detailed error capture
    ├── class-ta-admin.php                 WP Admin: API settings, endpoint toggles, CSV export, plugin updater
    ├── class-ta-auth.php                  Device UUID authentication
    ├── class-ta-activator.php             DB table creation (dbDelta) + schema upgrade routine
    ├── class-ta-fields.php                ACF field group import (8 CPTs, language tabs)
    ├── class-ta-feature-access.php        Feature gate: free/paid/achievement unlock system
    ├── class-ta-gallery-meta.php          Gallery + audio meta boxes + asset enqueue routing
    ├── class-ta-journey-stops-meta.php    Journey stops table UI meta box (province filtering)
    ├── class-ta-geo.php                   Haversine distance / geofence math
    ├── class-ta-localize.php              i18n helpers (get_field_localized, format_image, format_gallery, get_audio_localized)
    ├── class-ta-analytics.php             All analytics query methods (content, API, users, retention, economy)
    ├── class-ta-analytics-page.php        Analytics dashboard: 7 tabs + CSV export via admin-post
    ├── class-ta-log-viewer.php            API Log Viewer: filter, search, error detail expand, clear old logs
    ├── class-ta-monitor.php               System health monitor: threshold checks + email/Telegram alerts + WP-Cron
    ├── class-ta-monitor-page.php          Monitor settings page: thresholds, alert channels, test button
    ├── models/                            (8 model classes — device, wallet, checkin, journey, engagement, comment, rating, download)
    └── endpoints/                         (18 endpoint classes — includes features endpoint)
```

---

## WP Admin Menu

```
ToursApp API  (main menu)
├── ToursApp API      → API Settings (strict mode, endpoint toggles, export)
├── Analytics         → 7-tab dashboard: Overview / Content / API / Users / Retention / Feedback / Economy
├── API Logs          → Searchable log viewer with error detail expand
├── Monitor           → System health + alert thresholds + email/Telegram config
└── Update Plugin     → Safe plugin update via zip upload (no reinstall needed)
```

---

## API Request Logging

Every request in namespace `toursapp/v1` is logged asynchronously to `wp_ta_api_logs` (PHP shutdown hook — zero response time impact).

**Logged:** endpoint, method, status_code, response_ms, device_uuid, ip_address, created_at

Use for: identifying slowest endpoints, most-used routes, traffic patterns, abuse detection.

---

## Changing API Version

Edit one constant in `toursapp-api.php`:

```php
define('TA_API_NAMESPACE', 'toursapp/v1');  // → toursapp/v2
```

All 40+ endpoints update automatically.

---

## Future: User Account Support

Current identity: `device_uuid` (per-device, anonymous). All tables already use `device_uuid` as primary identity key, making the upgrade path straightforward.

To add Gmail/Apple Sign-In later:

```sql
-- Link devices to accounts
ALTER TABLE wp_ta_devices ADD COLUMN user_id BIGINT NULL;

-- New user accounts table
CREATE TABLE wp_ta_users (
  id           BIGINT AUTO_INCREMENT PRIMARY KEY,
  email        VARCHAR(255) UNIQUE NOT NULL,
  provider     VARCHAR(10) NOT NULL,  -- google | apple
  provider_id  VARCHAR(255) NOT NULL,
  display_name VARCHAR(255),
  avatar_url   VARCHAR(500),
  created_at   DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

Multiple devices linking to one user → wallet, history, comments automatically merged via JOIN on `device_uuid → user_id`. No API changes required.
