[< 05 — Mobile App Architecture](05-mobile-app-architecture.md) | [07 — Maps & Location >](07-maps-and-location.md)

---

# 06 — Backend Services (Supabase)

Cau hinh va su dung **Supabase Cloud** lam backend cho ToursApp — bao gom PostgreSQL, PostgREST API, Edge Functions, Storage va Realtime.

---

## 1. Supabase Project Setup

### 1.1 Cac buoc thiet lap

1. **Tao project** tai [supabase.com](https://supabase.com) — chon region `Southeast Asia (Singapore)`
2. **Lay credentials**:
   - `SUPABASE_URL`: `https://<project-ref>.supabase.co`
   - `SUPABASE_ANON_KEY`: public key cho mobile client (an toan voi RLS)
   - `SUPABASE_SERVICE_ROLE_KEY`: admin key cho Web Admin (KHONG BAO GIO dung trong mobile)
3. **Enable extensions**:
   ```sql
   CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
   CREATE EXTENSION IF NOT EXISTS "earthdistance" CASCADE; -- cube + earthdistance
   CREATE EXTENSION IF NOT EXISTS "pgvector";              -- Phase 5
   ```
4. **Tao database schema**: chay migration files (xem doc 04)
5. **Cau hinh Storage buckets** (muc 7 ben duoi)
6. **Deploy Edge Functions**: `supabase functions deploy <function-name>`

### 1.2 Environment Variables (Edge Functions)

```bash
# .env.local (Edge Functions secrets)
OPENAI_API_KEY=sk-xxx          # Phase 2 + Phase 5
SENTRY_DSN=https://xxx@sentry.io/yyy
APP_URL=https://hagiangtour.app
```

---

## 2. PostgREST Auto-Generated API

Supabase tu dong tao REST API tu PostgreSQL schema. Mobile client dung `supabase-flutter` SDK.

### 2.1 Query Locations (co filtering, pagination, nested selects)

```dart
// Lay danh sach dia diem published, co audio guides
final response = await supabase
    .from('locations')
    .select('''
      id, name, slug, description, short_description,
      latitude, longitude, altitude_meters,
      featured_image_url, gallery_image_urls,
      visit_duration_minutes, best_time_to_visit,
      difficulty_level, entrance_fee_vnd,
      status, sort_order,
      audio_guides (
        id, language, title, duration_seconds,
        audio_url, transcript
      ),
      categories (
        id, name, icon
      )
    ''')
    .eq('status', 'published')
    .order('sort_order', ascending: true)
    .range(0, 19);  // Pagination: 20 items
```

### 2.2 Query Articles

```dart
// Bai viet theo category, ho tro tim kiem
final response = await supabase
    .from('articles')
    .select('id, title, slug, excerpt, cover_image_url, published_at, author')
    .eq('status', 'published')
    .eq('language', currentLanguage)  // 'vi', 'en', 'ko', 'zh'
    .ilike('title', '%$searchQuery%')
    .order('published_at', ascending: false)
    .range(offset, offset + limit - 1);
```

### 2.3 Query Providers (Dich vu dia phuong)

```dart
// Nha cung cap dich vu theo loai
final response = await supabase
    .from('service_providers')
    .select('''
      id, name, type, description,
      latitude, longitude, address, phone,
      price_range, rating, photo_urls,
      operating_hours, amenities,
      is_verified
    ''')
    .eq('status', 'active')
    .eq('type', 'homestay')  // homestay, restaurant, motorbike, guide
    .order('rating', ascending: false);
```

### 2.4 Nested Select cho Route + Stops

```dart
final response = await supabase
    .from('routes')
    .select('''
      id, name, description,
      total_distance_km, estimated_duration_hours,
      difficulty_level, route_type,
      route_stops (
        stop_order, location_id, notes,
        distance_from_previous_km,
        locations (
          id, name, latitude, longitude,
          featured_image_url,
          audio_guides (id, language, audio_url, duration_seconds)
        )
      )
    ''')
    .eq('id', routeId)
    .single();
```

---

## 3. Row Level Security (RLS)

### 3.1 Phase 1 — Anonymous Read Only

Tat ca du lieu published duoc doc cong khai, khong can dang nhap:

```sql
-- Locations: ai cung doc duoc neu published
ALTER TABLE locations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read published locations"
  ON locations FOR SELECT
  USING (status = 'published');

-- Audio guides: doc duoc neu location da published
CREATE POLICY "Public read audio guides"
  ON audio_guides FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM locations
      WHERE locations.id = audio_guides.location_id
      AND locations.status = 'published'
    )
  );

-- Articles: doc duoc neu published
CREATE POLICY "Public read published articles"
  ON articles FOR SELECT
  USING (status = 'published');

-- Service providers: doc duoc neu active
CREATE POLICY "Public read active providers"
  ON service_providers FOR SELECT
  USING (status = 'active');

-- Routes: doc duoc neu published
CREATE POLICY "Public read published routes"
  ON routes FOR SELECT
  USING (status = 'published');

CREATE POLICY "Public read route stops"
  ON route_stops FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM routes
      WHERE routes.id = route_stops.route_id
      AND routes.status = 'published'
    )
  );
```

### 3.2 Phase 3+ — Authenticated Write

Khi co tinh nang user account (Travel Journal, Reviews):

```sql
-- User trips: chi chu so huu doc/ghi
CREATE POLICY "Users manage own trips"
  ON user_trips FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Reviews: ai cung doc, chi owner ghi
CREATE POLICY "Public read reviews"
  ON reviews FOR SELECT
  USING (true);

CREATE POLICY "Users manage own reviews"
  ON reviews FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users update own reviews"
  ON reviews FOR UPDATE
  USING (auth.uid() = user_id);

-- User photos: chi owner upload
CREATE POLICY "Users manage own photos"
  ON user_photos FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
```

### 3.3 Admin Access

Web Admin dung `service_role` key de bypass RLS:

```dart
// ONLY in Flutter Web Admin — KHONG BAO GIO trong mobile app
final adminClient = SupabaseClient(
  supabaseUrl,
  serviceRoleKey,  // Full access, bypass RLS
);
```

**QUAN TRONG**: `service_role` key chi duoc dung phia server hoac trong Web Admin deploy noi bo. Khong bao gio embed trong mobile app binary.

---

## 4. Edge Functions (Deno Runtime)

Cac serverless functions viet bang TypeScript, chay tren Deno runtime.

### 4.1 nearby-locations

Tim dia diem gan vi tri nguoi dung su dung PostgreSQL `earthdistance` extension.

```typescript
// supabase/functions/nearby-locations/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {
  const { lat, lon, radius_km = 10, limit = 20 } = await req.json();

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
  );

  // earthdistance: tinh khoang cach giua 2 diem (met)
  const { data, error } = await supabase.rpc("nearby_locations", {
    user_lat: lat,
    user_lon: lon,
    radius_meters: radius_km * 1000,
    max_results: limit,
  });

  return new Response(JSON.stringify({ data, error }), {
    headers: { "Content-Type": "application/json" },
  });
});
```

**SQL function**:
```sql
CREATE OR REPLACE FUNCTION nearby_locations(
  user_lat DOUBLE PRECISION,
  user_lon DOUBLE PRECISION,
  radius_meters DOUBLE PRECISION DEFAULT 10000,
  max_results INT DEFAULT 20
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  distance_meters DOUBLE PRECISION,
  featured_image_url TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    l.id, l.name, l.latitude, l.longitude,
    earth_distance(
      ll_to_earth(user_lat, user_lon),
      ll_to_earth(l.latitude, l.longitude)
    ) AS distance_meters,
    l.featured_image_url
  FROM locations l
  WHERE l.status = 'published'
    AND earth_distance(
      ll_to_earth(user_lat, user_lon),
      ll_to_earth(l.latitude, l.longitude)
    ) <= radius_meters
  ORDER BY distance_meters ASC
  LIMIT max_results;
END;
$$ LANGUAGE plpgsql;
```

**Input/Output**:

| Field | Type | Mo ta |
|-------|------|-------|
| `lat` | `float` | Vi do nguoi dung |
| `lon` | `float` | Kinh do nguoi dung |
| `radius_km` | `float` (default: 10) | Ban kinh tim kiem (km) |
| `limit` | `int` (default: 20) | So luong ket qua toi da |
| **Output** | `Array<Location>` | Sap xep theo khoang cach tang dan |

### 4.2 optimize-route

Toi uu thu tu diem dung trong tuyen duong (Nearest-Neighbor TSP heuristic).

```typescript
// supabase/functions/optimize-route/index.ts
serve(async (req) => {
  const { location_ids, start_lat, start_lon } = await req.json();

  // 1. Lay toa do cac dia diem
  const { data: locations } = await supabase
    .from("locations")
    .select("id, latitude, longitude, name")
    .in("id", location_ids);

  // 2. Nearest-neighbor TSP
  const optimized = nearestNeighborTSP(
    { lat: start_lat, lon: start_lon },
    locations
  );

  // 3. Tinh tong khoang cach
  const totalDistanceKm = calculateTotalDistance(optimized);

  return new Response(JSON.stringify({
    optimized_order: optimized.map(l => l.id),
    locations: optimized,
    total_distance_km: totalDistanceKm,
    estimated_duration_hours: totalDistanceKm / 30, // trung binh 30km/h duong nui
  }));
});
```

**Input**:
```json
{
  "location_ids": ["uuid-1", "uuid-2", "uuid-3", "uuid-4"],
  "start_lat": 23.2735,
  "start_lon": 105.2542
}
```

**Output**:
```json
{
  "optimized_order": ["uuid-2", "uuid-4", "uuid-1", "uuid-3"],
  "locations": [
    {"id": "uuid-2", "name": "Dinh Ma Pi Leng", "lat": ..., "lon": ...},
    ...
  ],
  "total_distance_km": 87.3,
  "estimated_duration_hours": 2.9
}
```

### 4.3 generate-qr

Tao QR code cho dia diem, luu vao Storage.

```typescript
// supabase/functions/generate-qr/index.ts
import QRCode from "https://esm.sh/qrcode@1.5.3";

serve(async (req) => {
  const { location_id } = await req.json();

  // 1. Tao URL
  const url = `https://hagiangtour.app/location/${location_id}`;

  // 2. Generate QR code PNG buffer
  const qrBuffer = await QRCode.toBuffer(url, {
    width: 512,
    margin: 2,
    color: { dark: "#1a1a2e", light: "#ffffff" },
  });

  // 3. Upload vao Storage
  const filePath = `qr-codes/${location_id}.png`;
  await supabase.storage
    .from("images")
    .upload(filePath, qrBuffer, {
      contentType: "image/png",
      upsert: true,
    });

  // 4. Lay public URL
  const { data: { publicUrl } } = supabase.storage
    .from("images")
    .getPublicUrl(filePath);

  // 5. Update location record
  await supabase
    .from("locations")
    .update({ qr_code_url: publicUrl })
    .eq("id", location_id);

  return new Response(JSON.stringify({ url: publicUrl }));
});
```

### 4.4 track-analytics

Thu thap su kien analytics nhe (khong dung service ben ngoai).

```typescript
// supabase/functions/track-analytics/index.ts
serve(async (req) => {
  const events = await req.json(); // Array of events

  // Batch insert vao bang analytics_events
  const { error } = await supabase
    .from("analytics_events")
    .insert(events.map((e: any) => ({
      event_type: e.type,       // 'page_view', 'audio_play', 'qr_scan', 'download'
      entity_type: e.entity,    // 'location', 'route', 'article'
      entity_id: e.entity_id,
      metadata: e.metadata,     // JSON: {language, duration, source, ...}
      device_id: e.device_id,   // anonymous device fingerprint
      created_at: new Date().toISOString(),
    })));

  return new Response(JSON.stringify({ success: !error }));
});
```

**Event types**:

| Event | Mo ta | Metadata |
|-------|-------|----------|
| `page_view` | Xem man hinh | `{screen, language}` |
| `audio_play` | Phat audio guide | `{location_id, language, duration_seconds}` |
| `audio_complete` | Nghe het audio | `{location_id, language}` |
| `qr_scan` | Quet QR code | `{location_id, source: 'camera'}` |
| `download_start` | Bat dau tai offline | `{region_id, type}` |
| `search` | Tim kiem | `{query, results_count}` |

### 4.5 ai-tts (Phase 2)

Chuyen van ban thanh audio bang OpenAI TTS API.

```typescript
// supabase/functions/ai-tts/index.ts
serve(async (req) => {
  const { text, language, voice, location_id } = await req.json();

  // 1. Goi OpenAI TTS API
  const ttsResponse = await fetch("https://api.openai.com/v1/audio/speech", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${Deno.env.get("OPENAI_API_KEY")}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "tts-1",           // hoac "tts-1-hd" cho chat luong cao
      voice: voice || "nova",   // alloy, echo, fable, onyx, nova, shimmer
      input: text,
      response_format: "mp3",
    }),
  });

  const audioBuffer = await ttsResponse.arrayBuffer();

  // 2. Upload vao Storage
  const filePath = `audio-guides/${location_id}/${language}.mp3`;
  await supabase.storage
    .from("audio-guides")
    .upload(filePath, audioBuffer, {
      contentType: "audio/mpeg",
      upsert: true,
    });

  // 3. Lay public URL va update audio_guides table
  const { data: { publicUrl } } = supabase.storage
    .from("audio-guides")
    .getPublicUrl(filePath);

  await supabase
    .from("audio_guides")
    .upsert({
      location_id,
      language,
      audio_url: publicUrl,
      duration_seconds: estimateDuration(text),
      generated_by: "openai-tts",
      status: "review",  // Can human review truoc khi publish
    });

  return new Response(JSON.stringify({ audio_url: publicUrl }));
});
```

### 4.6 ai-chat (Phase 5)

RAG pipeline: embed query → pgvector search → GPT response.

```typescript
// supabase/functions/ai-chat/index.ts
serve(async (req) => {
  const { message, conversation_history, language } = await req.json();

  // 1. Embed user query
  const embeddingResponse = await fetch(
    "https://api.openai.com/v1/embeddings",
    {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${Deno.env.get("OPENAI_API_KEY")}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "text-embedding-3-small",
        input: message,
      }),
    }
  );

  const { data } = await embeddingResponse.json();
  const queryEmbedding = data[0].embedding;

  // 2. pgvector similarity search — top 5 chunks
  const { data: chunks } = await supabase.rpc("match_content", {
    query_embedding: queryEmbedding,
    match_threshold: 0.7,
    match_count: 5,
  });

  // 3. Compose context
  const context = chunks.map((c: any) =>
    `[${c.entity_type}: ${c.title}]\n${c.content}`
  ).join("\n\n");

  // 4. GPT response
  const chatResponse = await fetch(
    "https://api.openai.com/v1/chat/completions",
    {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${Deno.env.get("OPENAI_API_KEY")}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "gpt-4o-mini",
        messages: [
          {
            role: "system",
            content: `Ban la huong dan vien du lich Ha Giang. Tra loi bang ${language}.
            Su dung thong tin sau:\n\n${context}`,
          },
          ...conversation_history,
          { role: "user", content: message },
        ],
        max_tokens: 500,
        temperature: 0.7,
        stream: true,
      }),
    }
  );

  // 5. Stream response back
  return new Response(chatResponse.body, {
    headers: { "Content-Type": "text/event-stream" },
  });
});
```

---

## 5. Storage Buckets

### 5.1 Bucket Configuration

| Bucket | Mo ta | Public | Max file size |
|--------|-------|--------|---------------|
| `audio-guides` | MP3 files audio huong dan | Yes | 50 MB |
| `images` | Anh dia diem, QR codes | Yes | 10 MB |
| `banners` | Banner quang cao, su kien | Yes | 5 MB |
| `offline-packs` | Goi data offline (zip) | Yes | 200 MB |
| `user-photos` | Anh nguoi dung (Phase 3) | No | 10 MB |
| `trip-exports` | PDF export chuyen di (Phase 3) | No | 20 MB |

### 5.2 Storage Policies

```sql
-- Public read cho audio-guides, images, banners
CREATE POLICY "Public read audio" ON storage.objects
  FOR SELECT USING (bucket_id = 'audio-guides');

CREATE POLICY "Public read images" ON storage.objects
  FOR SELECT USING (bucket_id = 'images');

CREATE POLICY "Public read banners" ON storage.objects
  FOR SELECT USING (bucket_id = 'banners');

CREATE POLICY "Public read offline packs" ON storage.objects
  FOR SELECT USING (bucket_id = 'offline-packs');

-- Authenticated write cho user-photos (Phase 3)
CREATE POLICY "Auth users upload photos" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'user-photos'
    AND auth.role() = 'authenticated'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

CREATE POLICY "Users read own photos" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'user-photos'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );
```

### 5.3 File Path Convention

```
audio-guides/
├── {location_id}/
│   ├── vi.mp3
│   ├── en.mp3
│   ├── ko.mp3
│   └── zh.mp3

images/
├── locations/
│   ├── {location_id}/
│   │   ├── featured.jpg
│   │   ├── gallery-1.jpg
│   │   └── gallery-2.jpg
├── providers/
│   └── {provider_id}/
│       └── photo-1.jpg
├── qr-codes/
│   └── {location_id}.png
└── categories/
    └── {category_id}.svg

banners/
├── {banner_id}.jpg

user-photos/           # Phase 3
├── {user_id}/
│   └── {trip_id}/
│       └── {timestamp}.jpg
```

---

## 6. Realtime Subscriptions (Phase 3+)

### 6.1 Banner Rotation

```dart
// Subscribe to banner changes — hien thi banner moi nhat tren Home
final bannerChannel = supabase
    .channel('banners')
    .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'banners',
      callback: (payload) {
        ref.invalidate(bannersProvider); // Refresh banner list
      },
    )
    .subscribe();
```

### 6.2 Provider Availability

```dart
// Cap nhat trang thai nha cung cap dich vu theo thoi gian thuc
final providerChannel = supabase
    .channel('providers')
    .onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'service_providers',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'type',
        value: 'homestay',
      ),
      callback: (payload) {
        // Update availability status in UI
      },
    )
    .subscribe();
```

---

## 7. Database Webhooks (Phase 5)

### 7.1 Content Change → Embedding Sync

Khi noi dung (locations, articles) thay doi, tu dong cap nhat embeddings:

```sql
-- Webhook trigger khi content thay doi
CREATE OR REPLACE FUNCTION notify_content_change()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM net.http_post(
    url := current_setting('app.settings.edge_function_url')
        || '/sync-embeddings',
    body := jsonb_build_object(
      'entity_type', TG_TABLE_NAME,
      'entity_id', NEW.id,
      'action', TG_OP
    )
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER locations_content_change
  AFTER INSERT OR UPDATE ON locations
  FOR EACH ROW EXECUTE FUNCTION notify_content_change();

CREATE TRIGGER articles_content_change
  AFTER INSERT OR UPDATE ON articles
  FOR EACH ROW EXECUTE FUNCTION notify_content_change();
```

---

## 8. Admin Access

### 8.1 Flutter Web Admin

Web Admin dung `service_role` key de quan ly noi dung:

| Chuc nang | API |
|-----------|-----|
| CRUD locations | PostgREST voi service_role (bypass RLS) |
| Upload audio/images | Storage API |
| Manage routes | PostgREST |
| Generate QR codes | Edge Function: generate-qr |
| View analytics | Query analytics_events table |
| AI TTS generation | Edge Function: ai-tts |
| Publish/unpublish | Update status field |

### 8.2 Security Rules

- `service_role` key chi ton tai trong Web Admin (Flutter Web, deploy noi bo)
- Mobile app chi dung `anon` key — moi truy cap qua RLS
- Web Admin dat sau VPN hoac IP whitelist
- Moi thao tac admin ghi log vao `admin_audit_log` table

---

## 9. Supabase Free Tier Limits va Monitoring

### 9.1 Free Tier Limits

| Resource | Free Tier | Ghi chu |
|----------|-----------|---------|
| Database | 500 MB | Du cho Phase 1 (~50 MB data) |
| Storage | 1 GB | Can nang cap som khi co nhieu audio |
| Edge Functions | 500K invocations/month | Du cho Phase 1 |
| Bandwidth | 2 GB/month | Can CDN cho audio streaming |
| Realtime | 200 concurrent connections | Du cho Phase 1-2 |

### 9.2 Khi nao can nang cap

- **Storage > 1 GB**: khi co ~100+ audio files (4 ngon ngu) → Pro plan $25/month
- **Bandwidth > 2 GB**: khi co ~500+ nguoi dung hang ngay → them Cloudflare R2 CDN
- **Database > 500 MB**: khi Phase 5 embeddings → Pro plan

### 9.3 Monitoring

- **Supabase Dashboard**: query performance, storage usage, function logs
- **pg_stat_statements**: slow query detection
- **Edge Function logs**: `supabase functions logs <name> --follow`
- **Custom monitoring**: analytics_events table cho business metrics
- **Alerts**: cau hinh webhook khi usage dat 80% limit

---

**Tong ket**: Supabase cung cap tat ca nhung gi can cho backend — API tu dong, auth, storage, realtime, serverless functions — ma khong can quan ly server. Chien luoc la: bat dau voi free tier, chi nang cap khi thuc su can.
