# 12 — Phân tích chi phí / Cost Analysis

> **"Tour Guide trong túi"** — A talking diary for Ha Giang

---

[<< 11 DevOps & Tooling](11-devops-and-tooling.md) | **12 Cost Analysis** | [00 Overview >>](00-overview.md)

| # | Tài liệu | Link |
|---|----------|------|
| 00 | Tổng quan | [00-overview.md](00-overview.md) |
| 01 | Vấn đề & Giải pháp | [01-problem-and-solution.md](01-problem-and-solution.md) |
| 02 | Tech Stack | [02-tech-stack.md](02-tech-stack.md) |
| 03 | Kiến trúc hệ thống | [03-system-architecture.md](03-system-architecture.md) |
| 04 | Database Design | [04-database-design.md](04-database-design.md) |
| 05 | Mobile App Architecture | [05-mobile-app-architecture.md](05-mobile-app-architecture.md) |
| 06 | Backend Services | [06-backend-services.md](06-backend-services.md) |
| 07 | Maps & Location | [07-maps-and-location.md](07-maps-and-location.md) |
| 08 | AI Integration | [08-ai-integration.md](08-ai-integration.md) |
| 09 | Cấu trúc dự án | [09-project-structure.md](09-project-structure.md) |
| 10 | Lộ trình | [10-phase-roadmap.md](10-phase-roadmap.md) |
| 11 | DevOps & Tooling | [11-devops-and-tooling.md](11-devops-and-tooling.md) |
| 12 | **Chi phí (đang xem)** | — |

---

## 1. Phase 1 — Chi phí $0/tháng (Supabase Free Tier)

### 1.1 Supabase Free Tier vs Projected Usage

| Resource | Free Tier Limit | Projected Usage (Phase 1) | % Used | Status |
|----------|-----------------|---------------------------|--------|--------|
| **Database** | 500 MB | ~100 MB | 20% | An toàn |
| **Storage** | 1 GB | ~700 MB (audio files) | 70% | Cần theo dõi |
| **Bandwidth (egress)** | 5 GB/tháng | ~3-4 GB/tháng | 60-80% | Cần theo dõi |
| **Edge Functions** | 500K invocations/tháng | ~100K | 20% | An toàn |
| **Edge Function runtime** | 2M giây/tháng | ~200K giây | 10% | An toàn |
| **Auth MAU** | 50,000 | 0 (Phase 1 không có auth) | 0% | N/A |
| **Realtime connections** | 200 concurrent | ~20-50 | 10-25% | An toàn |
| **File uploads** | 50 MB/file | ~5 MB/file (audio) | 10% | An toàn |

### 1.2 Database Usage Estimate

| Bảng | Rows (ước tính) | Size/row | Total |
|------|-----------------|----------|-------|
| `locations` | 50-100 | ~2 KB | ~200 KB |
| `routes` | 10-20 | ~3 KB | ~60 KB |
| `route_stops` | 100-200 | ~500 B | ~100 KB |
| `services` | 200-500 | ~1 KB | ~500 KB |
| `articles` | 30-50 | ~5 KB (rich text) | ~250 KB |
| `audio_tracks` | 200-400 | ~500 B (metadata) | ~200 KB |
| `analytics_events` | ~100K/tháng | ~200 B | ~20 MB/tháng |
| **Indexes + overhead** | — | — | ~30 MB |
| **Tổng năm đầu** | — | — | **~100 MB** |

### 1.3 Storage Usage Estimate

| Loại | Số lượng | Size/item | Total |
|------|----------|-----------|-------|
| **Audio files** (AAC 64kbps mono) | 200-400 files | ~2.4 MB/5min | ~600 MB |
| **Images** (optimized) | 500-1000 | ~100 KB | ~100 MB |
| **Tổng** | — | — | **~700 MB** |

### 1.4 Bandwidth Estimate

```
Giả định: 500 active users/tháng, mỗi user dùng ~3 sessions

Mỗi session:
- API calls (JSON): ~100 KB
- Audio streaming: ~5 MB (2 tracks × 2.5 MB)
- Images: ~2 MB (20 images × 100 KB)
= ~7 MB/session

500 users × 3 sessions × 7 MB = ~10.5 GB/tháng

NHƯNG: Với offline caching + download packs
- Lần đầu: ~7 MB/session
- Lần sau (cached): ~500 KB/session (chỉ API sync)

Realistic estimate: ~3-4 GB/tháng (60% returning users dùng cache)
```

---

## 2. Storage Optimization Strategy

### 2.1 Audio Optimization

| Setting | Value | Lý do |
|---------|-------|-------|
| **Format** | AAC (`.m4a`) | Tốt nhất cho mobile, hardware decode |
| **Bitrate** | 64 kbps | Đủ chất lượng cho voice/narration |
| **Channels** | Mono | Audio guide không cần stereo |
| **Sample rate** | 44.1 kHz | Standard |
| **File size** | ~2.4 MB / 5 phút | 480 KB/phút |

```
So sánh format:
┌─────────────┬──────────┬────────────┬──────────────┐
│ Format      │ Bitrate  │ 5 min size │ Quality      │
├─────────────┼──────────┼────────────┼──────────────┤
│ MP3 128kbps │ 128 kbps │ 4.8 MB     │ Tốt          │
│ MP3 64kbps  │ 64 kbps  │ 2.4 MB     │ Chấp nhận    │
│ AAC 64kbps  │ 64 kbps  │ 2.4 MB     │ Tốt (chọn)   │ ← Recommended
│ AAC 48kbps  │ 48 kbps  │ 1.8 MB     │ OK cho voice │
│ Opus 48kbps │ 48 kbps  │ 1.8 MB     │ Tốt nhất     │
│ WAV         │ 1411 kbps│ 52.9 MB    │ Không nén    │
└─────────────┴──────────┴────────────┴──────────────┘
```

### 2.2 Image Optimization với Cloudflare R2

| Service | Free Tier | Cost sau free | Dùng cho |
|---------|-----------|---------------|----------|
| **Cloudflare R2** | 10 GB storage, **0 egress** | $0.015/GB storage | Ảnh locations, articles, services |
| **Supabase Storage** | 1 GB, 5 GB egress | $0.021/GB egress | Audio files (cần signed URLs) |

**Strategy**:
- Ảnh → Cloudflare R2 (0 egress cost, CDN global)
- Audio → Supabase Storage (cần auth/signed URLs cho premium content)

```
Image Pipeline:
Original (JPEG/PNG, 2-5 MB)
    ↓ Cloudflare Image Resizing (free 100K/tháng)
┌───────────────────────────────────────┐
│ Thumbnail:  200x200,  WebP, ~15 KB   │  → List views
│ Medium:     800x600,  WebP, ~80 KB   │  → Detail screens
│ Large:      1600x1200, WebP, ~200 KB │  → Full screen gallery
└───────────────────────────────────────┘
```

### 2.3 Map Tile Caching

| Strategy | Chi tiết |
|----------|----------|
| **Online** | OpenStreetMap tiles (free, fair use policy) |
| **Offline** | Pre-cache tiles cho khu vực Hà Giang (zoom 8-16) |
| **Size estimate** | ~50-100 MB cho toàn bộ Hà Giang |
| **Package** | `flutter_map_tile_caching` |
| **Policy** | Cache 30 ngày, auto-refresh khi online |

---

## 3. Scaling Trigger Points

### 3.1 Khi nào cần upgrade?

| Trigger | Metric | Action | Chi phí mới |
|---------|--------|--------|-------------|
| DB > 400 MB | Supabase Dashboard | Dọn analytics events cũ hoặc upgrade Pro | $25/tháng (Pro) |
| Storage > 800 MB | Supabase Dashboard | Chuyển ảnh sang R2, hoặc upgrade Pro | $0 (R2) hoặc $25/tháng |
| Egress > 4 GB/tháng | Supabase Dashboard | Tối ưu caching, hoặc upgrade Pro | $25/tháng (250 GB egress) |
| Edge Functions > 400K | Supabase Dashboard | Optimize calls, batch requests | $25/tháng |
| Users > 1000 MAU | Analytics | Chuẩn bị Phase 2 upgrade plan | — |
| Audio files > 500 | Content team | Nén thêm (48kbps) hoặc upgrade storage | — |
| Concurrent users > 100 | Sentry perf | Evaluate scaling needs | — |

### 3.2 Supabase Plan Comparison

| Feature | Free | Pro ($25/tháng) | Team ($599/tháng) |
|---------|------|-----------------|-------------------|
| Database | 500 MB | 8 GB | 16 GB |
| Storage | 1 GB | 100 GB | 100 GB |
| Bandwidth | 5 GB | 250 GB | 250 GB |
| Edge Functions | 500K | 2M | 2M |
| Auth MAU | 50K | 100K | 100K |
| Support | Community | Email | Priority |

**Dự kiến upgrade Supabase Pro**: Khi DAU > 200 hoặc storage > 800 MB (ước tính tháng 4-6 sau launch).

---

## 4. Chi phí theo Phase

### 4.1 Bảng tổng hợp chi phí

| Phase | Supabase | Cloudflare R2 | AI (OpenAI) | App Store | Sentry | Codemagic | **Tổng/tháng** |
|-------|----------|---------------|-------------|-----------|--------|-----------|----------------|
| **1** | $0 (free) | $0 (free) | $0 | — | $0 (free) | $0 (free tier) | **$0/tháng** |
| **2** | $0-25 | $0 | $10-25 | — | $0 | $0 | **$10-50/tháng** |
| **3** | $25 (Pro) | $0 | $10-25 | — | $0-26 | $0-40 | **$35-90/tháng** |
| **4** | $25 | $0-5 | $15-30 | — | $26 | $40 | **$106-126/tháng** |
| **5** | $25 | $0-5 | $50-100 | — | $26 | $40 | **$141-196/tháng** |

### 4.2 One-time Costs (Chi phí một lần)

| Mục | Chi phí | Ghi chú |
|-----|---------|---------|
| **Google Play Developer** | $25 (one-time) | Lifetime access |
| **Apple Developer Program** | $99/năm | Bắt buộc cho iOS |
| **Domain name** | ~$12/năm | toursapp.vn hoặc tương tự |
| **SSL Certificate** | $0 | Cloudflare free SSL |
| **Supabase custom domain** | $0 (Pro plan) | Included trong Pro |

### 4.3 Year 1 Total Cost Estimate

```
One-time:
  Google Play:      $25
  Apple Developer:  $99
  Domain:           $12
  ─────────────────────
  Subtotal:         $136

Monthly (average, phased):
  Months 1-2:   $0/mo × 2  =   $0    (Phase 1)
  Months 3-4:   $25/mo × 2 =  $50    (Phase 2)
  Months 5-7:   $60/mo × 3 = $180    (Phase 3)
  Months 8-9:   $115/mo × 2 = $230   (Phase 4)
  Months 10-12: $170/mo × 3 = $510   (Phase 5)
  ─────────────────────────────────
  Subtotal:                  $970

Year 1 Total Estimate: ~$1,106
```

---

## 5. App Store Fees

### 5.1 Google Play

| Mục | Chi phí |
|-----|---------|
| Developer registration | $25 (one-time, lifetime) |
| Transaction fee | 15% (first $1M/year), 30% after |
| In-app purchase fee | 15% (subscriptions after year 1) |

### 5.2 Apple App Store

| Mục | Chi phí |
|-----|---------|
| Developer Program | $99/year |
| Transaction fee | 15% (small business < $1M), 30% otherwise |
| In-app purchase fee | 15% (subscriptions after year 1) |

### 5.3 Net Revenue per $1 User Payment

```
User trả $5/tháng subscription:

Google Play:
  $5.00 - 15% fee = $4.25 net (year 1)
  $5.00 - 15% fee = $4.25 net (year 2+, subscriptions)

Apple App Store:
  $5.00 - 30% fee = $3.50 net (year 1)
  $5.00 - 15% fee = $4.25 net (year 2+, subscriptions)

Average (50/50 split):
  Year 1: ($4.25 + $3.50) / 2 = $3.88 net per $5 subscription
  Year 2+: ($4.25 + $4.25) / 2 = $4.25 net per $5 subscription
```

---

## 6. AI Costs (Phase 2+)

### 6.1 OpenAI TTS (Text-to-Speech)

| Model | Quality | Giá | Ước tính |
|-------|---------|-----|----------|
| `tts-1` | Standard | $15 / 1M characters | Đủ tốt cho production |
| `tts-1-hd` | HD | $30 / 1M characters | Không cần thiết |

```
Ước tính TTS cost cho 50 locations × 4 ngôn ngữ:

Mỗi location description: ~1,000 characters
50 locations × 4 languages × 1,000 chars = 200,000 characters
200,000 / 1,000,000 × $15 = $3.00

→ Chi phí TTS cho toàn bộ content: ~$3-5 (one-time per content update)
```

### 6.2 OpenAI Translation (GPT-4o-mini)

| Model | Input | Output | Ước tính |
|-------|-------|--------|----------|
| `gpt-4o-mini` | $0.15 / 1M tokens | $0.60 / 1M tokens | Rất rẻ |

```
Ước tính translation cost:

50 locations × 500 words/location = 25,000 words
25,000 words ≈ 35,000 tokens (input)
Output (3 languages): 35,000 × 3 = 105,000 tokens

Input cost: 35,000 / 1,000,000 × $0.15 = $0.005
Output cost: 105,000 / 1,000,000 × $0.60 = $0.063
Total: $0.07

→ Chi phí translation: ~$0.10 per batch (negligible)
```

### 6.3 OpenAI Embeddings (Phase 5 — Chatbot)

| Model | Giá | Dimensions |
|-------|-----|------------|
| `text-embedding-3-small` | $0.02 / 1M tokens | 1536 |
| `text-embedding-3-large` | $0.13 / 1M tokens | 3072 |

```
Ước tính embedding cost:

Knowledge base: ~100 documents × 500 tokens = 50,000 tokens
50,000 / 1,000,000 × $0.02 = $0.001 (one-time)

User queries: ~1,000 queries/tháng × 50 tokens = 50,000 tokens
50,000 / 1,000,000 × $0.02 = $0.001/tháng

→ Embedding cost: ~$0.01/tháng (negligible)
```

### 6.4 OpenAI Chat (Phase 5 — Chatbot)

| Model | Input | Output | Ước tính |
|-------|-------|--------|----------|
| `gpt-4o-mini` | $0.15 / 1M tokens | $0.60 / 1M tokens | Primary |
| `gpt-4o` | $2.50 / 1M tokens | $10 / 1M tokens | Fallback cho complex |

```
Ước tính chat cost:

1,000 chat sessions/tháng
Mỗi session: ~2,000 input tokens (context + query) + ~500 output tokens

Input: 1,000 × 2,000 = 2,000,000 tokens → $0.30
Output: 1,000 × 500 = 500,000 tokens → $0.30
Total: $0.60/tháng (gpt-4o-mini)

Scaling to 10,000 sessions: ~$6/tháng
Scaling to 50,000 sessions: ~$30/tháng
```

### 6.5 AI Cost Summary (Monthly)

| Service | Phase 2 | Phase 3 | Phase 4 | Phase 5 |
|---------|---------|---------|---------|---------|
| TTS (new content) | $2-5 | $2-5 | $2-5 | $2-5 |
| Translation | < $1 | < $1 | < $1 | < $1 |
| Embeddings | — | — | — | < $1 |
| Chat (RAG) | — | — | — | $5-30 |
| **AI Total** | **$3-6** | **$3-6** | **$3-6** | **$8-36** |

---

## 7. Mô hình Freemium / Freemium Model Economics

### 7.1 Tier Comparison

| Feature | Free | Premium |
|---------|------|---------|
| Bản đồ + locations list | Full access | Full access |
| Audio guide | **5 locations** | **Tất cả locations** |
| Trip recording | **3 trips** | **Unlimited** |
| Articles / tin tức | Full access | Full access |
| Nearby services | Full access | Full access |
| Routes navigation | Full access | Full access |
| QR scanner | Full access | Full access |
| Offline download | **1 pack** | **Unlimited packs** |
| AI Chatbot [Ph5] | **5 messages/ngày** | **Unlimited** |
| Trip export [Ph3] | Watermark | **No watermark** |
| Ad-free | Ads hiển thị | **Không quảng cáo** |
| Priority support | Community | **Email support** |

### 7.2 Pricing Strategy

| Gói | Giá | Target |
|-----|-----|--------|
| **Free** | $0 | Mọi du khách — tạo viral, reviews |
| **Single Tour** | $2-3 /tour | Tourist đi 1 chuyến — mua 1 lần |
| **Monthly Premium** | $4.99 /tháng | Du khách thường xuyên |
| **Yearly Premium** | $39.99 /năm (~$3.33/tháng) | Travel enthusiast |

### 7.3 Conversion Funnel Assumptions

```
Downloads/tháng:     1,000
Active users:          500 (50% retention)
Try premium:           100 (20% trial)
Convert to paid:        30 (30% conversion = 6% of active)

Revenue scenarios:
- Conservative (3%):  500 × 3% = 15 premium × $5 = $75/tháng
- Moderate (6%):      500 × 6% = 30 premium × $5 = $150/tháng
- Optimistic (10%):   500 × 10% = 50 premium × $5 = $250/tháng
```

### 7.4 Break-even Analysis

```
Monthly costs (Phase 4, mature): ~$115/tháng

Break-even với $5/tháng subscription:
  Net revenue per user: $3.88 (after store fees)
  Break-even users: $115 / $3.88 = 30 premium users

Break-even với $3/single tour:
  Net revenue per purchase: $2.33
  Break-even purchases: $115 / $2.33 = 50 purchases/tháng

→ Cần 30 premium subscribers HOẶC 50 tour purchases/tháng để break-even
→ Với 500 MAU, cần 6% conversion rate
```

---

## 8. Revenue Streams

### 8.1 Tổng quan các nguồn thu

| Stream | Phase | Revenue Model | Ước tính/tháng |
|--------|-------|---------------|----------------|
| **Premium subscriptions** | Phase 4 | $4.99/tháng hoặc $39.99/năm | $75-250 |
| **Single tour purchase** | Phase 4 | $2-3/tour | $50-150 |
| **Featured provider listings** | Phase 4 | $10-30/tháng per provider | $50-150 |
| **Banner ads** | Phase 4 | CPM $1-3 (niche travel) | $20-50 |
| **Sponsored content** | Phase 4 | $50-200/bài | $50-200 |

### 8.2 Provider Dashboard Revenue

```
Targeted providers cho Hà Giang:
- Homestays:    ~100 (target 20 paid listings)
- Nhà hàng:     ~80 (target 15 paid listings)
- Dịch vụ xe:   ~30 (target 5 paid listings)
- Tour guides:  ~50 (target 10 paid listings)

Pricing tiers cho providers:
  Basic listing:    Free (tên + địa chỉ + SĐT)
  Featured:         $15/tháng (ưu tiên hiển thị + ảnh + mô tả)
  Premium:          $30/tháng (featured + banner + analytics + booking link)

Revenue estimate: 50 paid providers × $15-30 = $750-1,500/tháng
(Phase 4+, khi có đủ user base)
```

### 8.3 Ad Revenue Estimate

```
Native ads (giữa danh sách, không intrusive):
  500 MAU × 3 sessions × 10 screens = 15,000 impressions/tháng
  CPM: $2 (travel niche Vietnam)
  Revenue: 15 × $2 = $30/tháng

Scaling:
  5,000 MAU: ~$300/tháng
  10,000 MAU: ~$600/tháng
```

---

## 9. So sánh chi phí: Tech Stack này vs Truyền thống

### 9.1 Our Stack (Flutter + Supabase)

| Mục | Year 1 | Year 2 |
|-----|--------|--------|
| Supabase (Free → Pro) | $150 | $300 |
| Cloudflare R2 | $0 | $0-60 |
| AI costs | $50 | $200 |
| App Store fees | $136 | $99 |
| Sentry | $0-156 | $312 |
| Codemagic | $0-240 | $480 |
| **Total** | **~$536** | **~$1,451** |

### 9.2 Traditional Stack (VPS + Custom Backend + Native Apps)

| Mục | Year 1 | Year 2 |
|-----|--------|--------|
| VPS hosting (DigitalOcean) | $600-1,200 | $600-1,200 |
| Database (managed PostgreSQL) | $180-600 | $180-600 |
| CDN (Cloudflare/AWS) | $0-120 | $120-360 |
| SSL Certificate | $0-50 | $0-50 |
| Backend dev time (2x more) | +200h × $30 = $6,000 | — |
| iOS + Android separate dev | +300h × $30 = $9,000 | — |
| Server maintenance | ~$100/tháng = $1,200 | $1,200 |
| App Store fees | $136 | $99 |
| **Total** | **~$17,236** | **~$2,449** |

### 9.3 Savings Comparison

```
Year 1 savings: $17,236 - $536 = $16,700 (96.9% less)
Year 2 savings: $2,449 - $1,451 = $998 (40.7% less)

Lý do chênh lệch lớn:
1. Flutter = 1 codebase thay vì 2 (iOS + Android)
2. Supabase = no server maintenance, free tier rất mạnh
3. Serverless = pay per use, không cần VPS 24/7
4. Cloudflare R2 = free egress (CDN included)
5. Open source map tiles = không phí Google Maps API
```

---

## 10. Dự phóng tài chính 12 tháng / 12-Month Financial Projection

### 10.1 Conservative Scenario

| Tháng | MAU | Premium Users | MRR | Costs/mo | Margin |
|-------|-----|---------------|-----|----------|--------|
| 1 | 50 | 0 | $0 | $0 | $0 |
| 2 | 100 | 0 | $0 | $0 | $0 |
| 3 | 200 | 0 | $0 | $15 | -$15 |
| 4 | 350 | 0 | $0 | $25 | -$25 |
| 5 | 500 | 5 | $19 | $40 | -$21 |
| 6 | 700 | 10 | $39 | $50 | -$11 |
| 7 | 900 | 20 | $78 | $60 | +$18 |
| 8 | 1,200 | 35 | $136 | $80 | +$56 |
| 9 | 1,500 | 50 | $194 | $100 | +$94 |
| 10 | 1,800 | 65 | $252 | $130 | +$122 |
| 11 | 2,000 | 80 | $310 | $150 | +$160 |
| 12 | 2,500 | 100 | $388 | $170 | +$218 |

```
Year 1 Summary (Conservative):
  Total Revenue:  $1,416
  Total Costs:    $820 (monthly) + $136 (one-time) = $956
  Net Profit:     +$460
  Break-even:     Tháng 7
  Year-end MRR:   $388
```

### 10.2 Moderate Scenario

| Tháng | MAU | Premium Users | Provider Revenue | MRR | Costs/mo | Margin |
|-------|-----|---------------|------------------|-----|----------|--------|
| 1 | 100 | 0 | $0 | $0 | $0 | $0 |
| 2 | 250 | 0 | $0 | $0 | $0 | $0 |
| 3 | 500 | 0 | $0 | $0 | $20 | -$20 |
| 4 | 800 | 0 | $0 | $0 | $30 | -$30 |
| 5 | 1,200 | 15 | $0 | $58 | $50 | +$8 |
| 6 | 1,800 | 30 | $0 | $116 | $60 | +$56 |
| 7 | 2,500 | 50 | $100 | $294 | $80 | +$214 |
| 8 | 3,500 | 80 | $200 | $510 | $100 | +$410 |
| 9 | 4,500 | 120 | $300 | $766 | $120 | +$646 |
| 10 | 5,500 | 160 | $400 | $1,021 | $150 | +$871 |
| 11 | 6,500 | 200 | $500 | $1,276 | $170 | +$1,106 |
| 12 | 8,000 | 250 | $600 | $1,570 | $190 | +$1,380 |

```
Year 1 Summary (Moderate):
  Total Revenue:  $5,611
  Total Costs:    $970 (monthly) + $136 (one-time) = $1,106
  Net Profit:     +$4,505
  Break-even:     Tháng 5
  Year-end MRR:   $1,570
```

### 10.3 Optimistic Scenario

| Tháng | MAU | Premium Users | Provider + Ads | MRR | Costs/mo | Margin |
|-------|-----|---------------|----------------|-----|----------|--------|
| 1 | 200 | 0 | $0 | $0 | $0 | $0 |
| 2 | 500 | 0 | $0 | $0 | $0 | $0 |
| 3 | 1,000 | 0 | $0 | $0 | $25 | -$25 |
| 4 | 2,000 | 10 | $0 | $39 | $35 | +$4 |
| 5 | 3,500 | 40 | $100 | $255 | $60 | +$195 |
| 6 | 5,000 | 80 | $250 | $560 | $80 | +$480 |
| 7 | 7,000 | 140 | $500 | $1,043 | $110 | +$933 |
| 8 | 10,000 | 220 | $800 | $1,654 | $150 | +$1,504 |
| 9 | 13,000 | 320 | $1,100 | $2,342 | $200 | +$2,142 |
| 10 | 16,000 | 450 | $1,500 | $3,247 | $250 | +$2,997 |
| 11 | 19,000 | 600 | $1,800 | $4,128 | $300 | +$3,828 |
| 12 | 22,000 | 750 | $2,000 | $4,913 | $350 | +$4,563 |

```
Year 1 Summary (Optimistic):
  Total Revenue:  $18,181
  Total Costs:    $1,560 (monthly) + $136 (one-time) = $1,696
  Net Profit:     +$16,485
  Break-even:     Tháng 4
  Year-end MRR:   $4,913
  ARR (projected): $58,956
```

### 10.4 Key Assumptions

| Giả định | Conservative | Moderate | Optimistic |
|----------|-------------|----------|------------|
| Monthly download growth | 20% | 40% | 60% |
| Retention rate | 40% | 50% | 60% |
| Free → Premium conversion | 3% | 5% | 8% |
| ARPU (premium) | $5/mo | $5/mo | $5/mo |
| Provider adoption | Slow | Moderate | Fast |
| Marketing budget | $0 (organic) | $0 (organic + QR) | Minimal $100/mo |

---

## 11. Key Financial Metrics to Track

| Metric | Công thức | Target (Month 12) |
|--------|-----------|-------------------|
| **MRR** | Sum(monthly subscription revenue) | > $300 |
| **ARPU** | Total revenue / MAU | > $0.15 |
| **CAC** | Marketing spend / New users | < $1 |
| **LTV** | ARPU × Average lifespan (months) | > $5 |
| **LTV/CAC** | LTV / CAC | > 3x |
| **Churn rate** | Lost users / Start users | < 10%/mo |
| **Gross margin** | (Revenue - Costs) / Revenue | > 60% |
| **Conversion rate** | Premium users / MAU | > 5% |

---

## 12. Tóm tắt / Summary

```
┌──────────────────────────────────────────────────────┐
│              TOURSAPP COST STRUCTURE                  │
├──────────────────────────────────────────────────────┤
│                                                      │
│  Phase 1 (MVP):           $0/tháng                   │
│  ├── Supabase Free Tier   $0                         │
│  ├── Cloudflare R2 Free   $0                         │
│  ├── OSM Map Tiles Free   $0                         │
│  └── Sentry Free Tier     $0                         │
│                                                      │
│  Year 1 Total:            ~$536 - $1,696             │
│  Year 1 Revenue:          ~$1,416 - $18,181          │
│  Break-even:              Tháng 4-7                  │
│                                                      │
│  vs Traditional Stack:    $17,236 (year 1)           │
│  Savings:                 96.9%                      │
│                                                      │
│  Key insight: Supabase free tier + Cloudflare R2     │
│  cho phép launch $0/tháng. Chỉ trả tiền khi         │
│  thực sự cần scale.                                  │
│                                                      │
└──────────────────────────────────────────────────────┘
```

**Lời khuyên**:
1. **Start free**: Tận dụng tối đa free tiers. Không chi tiền cho đến khi có users.
2. **Monitor usage**: Set alert ở 80% free tier limits.
3. **Optimize before upgrade**: Nén audio, dùng R2 cho ảnh, cache aggressively.
4. **Revenue before features**: Đừng build Phase 5 (AI Chat) trước khi có revenue từ Phase 4.
5. **Iterate pricing**: Thử nghiệm giá premium ở thị trường Việt Nam (có thể cần điều chỉnh).

---

*Quay lại: [00 — Overview](00-overview.md) — Tổng quan dự án*
