# Tasklist: Data Lifecycle & Archiving System

> **Priority:** High — prevent DB bloat in production  
> **Estimated tables affected:** ta_content_events, ta_api_logs, ta_error_logs  
> **New table:** ta_content_stats_daily  
> **New files:** 2 PHP classes + 1 admin page  

---

## Phase 1: DB Schema

### Task 1.1 — Add `wp_ta_content_stats_daily` table
**File:** `includes/class-ta-activator.php`

Add CREATE TABLE to `$sql` string in `create_tables()`:
```sql
CREATE TABLE {$wpdb->prefix}ta_content_stats_daily (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    date           DATE NOT NULL,
    content_type   VARCHAR(20) NOT NULL,
    content_id     INT NOT NULL,
    event_type     VARCHAR(30) NOT NULL,
    event_count    INT DEFAULT 0,
    unique_users   INT DEFAULT 0,
    avg_duration   DECIMAL(8,2) DEFAULT 0,
    avg_scroll     DECIMAL(5,2) DEFAULT 0,
    avg_completion DECIMAL(5,2) DEFAULT 0,
    UNIQUE KEY unique_daily (date, content_type, content_id, event_type),
    INDEX idx_date (date),
    INDEX idx_content (content_type, content_id)
) $charset;
```

### Task 1.2 — Add to uninstall.php
Add `'ta_content_stats_daily'` to `$tables` array.

### Task 1.3 — Add upgrade() step
In `TA_Activator::upgrade()`, bump version check to create the new table on existing installs.

---

## Phase 2: Archiver Class

### Task 2.1 — Create `includes/class-ta-data-archiver.php`

**Constants / defaults:**
```php
const CRON_HOOK = 'ta_data_archive_run';
const ARCHIVE_DIR = WP_CONTENT_DIR . '/uploads/toursapp-archives/';
const DEFAULTS = [
    'content_events_days' => 90,
    'api_logs_days'       => 30,
    'error_logs_days'     => 90,
    'auto_export'         => 1,
    'keep_files'          => 12,
];
```

**Methods to implement:**

| Method | Description |
|--------|-------------|
| `schedule()` | Register WP-Cron daily event |
| `unschedule()` | Remove cron on settings disable |
| `add_cron_interval($schedules)` | Add `daily_2am` schedule |
| `run()` | Main entry: calls aggregate → export → purge → cleanup |
| `aggregate_content_events()` | INSERT INTO ta_content_stats_daily using GROUP BY on old records |
| `export_table($table, $cutoff_date, $filename)` | Write records to CSV file in ARCHIVE_DIR |
| `purge_old_records()` | DELETE records beyond retention from 3 tables |
| `cleanup_archive_files()` | Delete oldest files when count > keep_files |
| `ensure_archive_dir()` | Create dir + .htaccess if not exists |
| `get_stats()` | Return table row counts, oldest record, archive files list |
| `dry_run()` | Return what WOULD be exported/purged without executing |
| `get(string $key)` | Read setting from wp_options with default |

**Aggregate SQL (idempotent — safe to re-run):**
```sql
INSERT INTO {$p}ta_content_stats_daily
    (date, content_type, content_id, event_type,
     event_count, unique_users, avg_duration, avg_scroll, avg_completion)
SELECT
    DATE(created_at), content_type, content_id, event_type,
    COUNT(*), COUNT(DISTINCT device_uuid),
    COALESCE(AVG(NULLIF(duration_sec, 0)), 0),
    COALESCE(AVG(NULLIF(scroll_depth, 0)), 0),
    COALESCE(AVG(NULLIF(completion_pct, 0)), 0)
FROM {$p}ta_content_events
WHERE created_at < %s
GROUP BY DATE(created_at), content_type, content_id, event_type
ON DUPLICATE KEY UPDATE
    event_count  = event_count  + VALUES(event_count),
    unique_users = GREATEST(unique_users, VALUES(unique_users)),
    avg_duration = (avg_duration + VALUES(avg_duration)) / 2,
    avg_scroll   = (avg_scroll   + VALUES(avg_scroll))   / 2,
    avg_completion = (avg_completion + VALUES(avg_completion)) / 2
```

**Archive directory security:**
```
uploads/toursapp-archives/
├── .htaccess          (deny all direct access)
├── index.php          (empty, prevents directory listing)
├── ta-events-2026-05.csv
├── ta-api-2026-05.csv
├── ta-errors-2026-05.csv
└── ta-events-2026-06.csv
```

### Task 2.2 — Wire into `toursapp-api.php`

```php
require_once TA_PLUGIN_DIR . 'includes/class-ta-data-archiver.php';
// In __construct():
add_filter('cron_schedules', ['TA_Data_Archiver', 'add_cron_interval']);
add_action(TA_Data_Archiver::CRON_HOOK, ['TA_Data_Archiver', 'run']);
```

---

## Phase 3: Admin Archive Page

### Task 3.1 — Create `includes/class-ta-archive-page.php`

**Menu:** Submenu under "ToursApp API" → "Archive"

**Page sections:**

**Section 1: Status Dashboard**
```
┌─────────────────────────────────────────────────┐
│ Table               Rows        Oldest Record    │
│ ta_content_events   1,245,320   2025-08-14       │
│ ta_api_logs         3,891,044   2025-06-01       │
│ ta_error_logs       12,441      2025-09-01       │
│                                                  │
│ Archive files: 8 files · 45 MB total             │
│ Next cron: in 6 hours (daily at 2 AM)            │
└─────────────────────────────────────────────────┘
```

**Section 2: Settings Form**
- Content events retention: [___] days
- API logs retention: [___] days
- Error logs retention: [___] days
- Auto-export before purge: [toggle]
- Keep N archive file sets: [___]
- Save + schedule/unschedule cron accordingly

**Section 3: Archive Files List**
```
Filename                    Size    Date         Actions
ta-events-2026-05.csv      2.1 MB  2026-06-01  [⬇ Download] [🗑 Delete]
ta-api-2026-05.csv         8.4 MB  2026-06-01  [⬇ Download] [🗑 Delete]
ta-errors-2026-05.csv      0.3 MB  2026-06-01  [⬇ Download] [🗑 Delete]
```

**Section 4: Manual Controls**
- `[ Archive Now ]` — run full archive process immediately
- `[ Dry Run ]` — show what would be exported/deleted, no actual changes

### Task 3.2 — Wire into admin menu

In `toursapp-api.php __construct()` is_admin block:
```php
add_action('admin_menu', ['TA_Archive_Page', 'register_menu']);
// AJAX handlers for download, delete, manual archive:
add_action('wp_ajax_ta_archive_now',       ['TA_Archive_Page', 'ajax_archive_now']);
add_action('wp_ajax_ta_archive_dry_run',   ['TA_Archive_Page', 'ajax_dry_run']);
add_action('wp_ajax_ta_archive_delete',    ['TA_Archive_Page', 'ajax_delete_file']);
add_action('wp_ajax_ta_archive_download',  ['TA_Archive_Page', 'ajax_download_file']);
```

---

## Phase 4: Analytics Fallback

### Task 4.1 — Update `TA_Analytics::top_content()`
**File:** `includes/class-ta-analytics.php`

When querying content events, if the requested `$since` period is older than the retention cutoff, fall back to `ta_content_stats_daily` instead of `ta_content_events`.

```php
public static function top_content(...) {
    $cutoff = date('Y-m-d', strtotime('-' . TA_Data_Archiver::get('content_events_days') . ' days'));
    
    if (strtotime($since) < strtotime($cutoff)) {
        // Use aggregated daily stats table
        return self::top_content_from_stats($metric, $content_type, $limit, $since);
    }
    // Use raw events (existing query)
    return self::top_content_from_raw(...);
}
```

### Task 4.2 — Add `top_content_from_stats()` method
Query from `ta_content_stats_daily` with same interface as the raw query.

---

## Phase 5: Documentation & Testing

### Task 5.1 — Update docs/04-database-design.md
Add full schema for `ta_content_stats_daily` with notes on archiving lifecycle.

### Task 5.2 — Update docs/06-backend-services.md
Add Data Archiving section with configuration reference and operational guide.

### Task 5.3 — Test scenarios
- [ ] Cron fires at scheduled time
- [ ] Aggregate runs correctly with ON DUPLICATE KEY
- [ ] CSV export creates file with correct data
- [ ] Purge removes exactly the right records
- [ ] Archive file count limited to keep_files setting
- [ ] Download works through admin AJAX
- [ ] Analytics tab still shows data after raw purge (using daily stats)
- [ ] Dry run shows accurate preview
- [ ] Re-running archive is idempotent (no duplicate aggregation)

---

## Implementation Order

```
Task 1.1 → 1.2 → 1.3   (DB schema — prerequisite for everything)
Task 2.1 → 2.2          (archiver class — core logic)
Task 3.1 → 3.2          (admin UI — settings + controls)
Task 4.1 → 4.2          (analytics fallback — user-facing impact)
Task 5.1 → 5.2 → 5.3   (docs + testing)
```

**Estimated files to create/modify:**

| Action | File |
|--------|------|
| Modify | `includes/class-ta-activator.php` |
| Modify | `uninstall.php` |
| Modify | `toursapp-api.php` |
| Modify | `includes/class-ta-analytics.php` |
| Modify | `docs/04-database-design.md` |
| Modify | `docs/06-backend-services.md` |
| **Create** | `includes/class-ta-data-archiver.php` |
| **Create** | `includes/class-ta-archive-page.php` |
