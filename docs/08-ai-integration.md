[< 07 — Maps & Location](07-maps-and-location.md) | [09 — Project Structure >](09-project-structure.md)

---

# 08 — AI Integration

Ke hoach tich hop AI cho ToursApp — bao gom **Phase 2** (AI Content Pipeline: TTS + Translation) va **Phase 5** (AI Chatbot RAG + Trip Planner).

---

## Phase 2 — AI Content Pipeline

### 1. Van de

Tao noi dung audio guide cho 200+ dia diem, moi dia diem 4 ngon ngu:

```
200 dia diem × 4 ngon ngu = 800 audio files
```

Neu thu cong (thue nguoi doc + dich):
- Chi phi: ~$5-10/file × 800 = **$4,000-8,000**
- Thoi gian: 2-3 thang
- Kho cap nhat khi noi dung thay doi

### 2. Giai phap: AI TTS + AI Translation Pipeline

```
Viet script tieng Viet (con nguoi)
    ↓
AI dich sang en/ko/zh (GPT-4o-mini)
    ↓
OpenAI TTS tao audio 4 ngon ngu
    ↓
Human review (kiem tra chat luong)
    ↓
Publish len Supabase Storage
```

### 3. Chi tiet tung buoc

#### 3.1 Buoc 1 — Viet Script Tieng Viet (Con nguoi)

Content writer viet script huong dan cho tung dia diem:

```
Dia diem: Dinh deo Ma Pi Leng
Thoi luong: ~3 phut (~500 tu)

"Ban dang dung tai dinh deo Ma Pi Leng — mot trong tu dai dinh deo
huyen thoai cua Viet Nam. O do cao 1,500 met, day la noi co the
ngam toan canh he vuc Tu San voi dong song Nho Que uon luon
phia duoi. Deo duoc xay dung tu nam 1959 den 1965 boi hang
ngan thanh nien xung phong..."
```

#### 3.2 Buoc 2 — AI Translation (GPT-4o-mini)

```typescript
// Edge Function hoac admin tool
async function translateContent(
  vietnameseText: string,
  targetLanguage: string
): Promise<string> {
  const response = await openai.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [
      {
        role: "system",
        content: `You are a professional tourism translator.
        Translate the following Vietnamese tourism content to ${targetLanguage}.
        Keep proper nouns in their original form (e.g., "Ma Pi Leng", "Nho Que").
        Maintain the engaging, informative tone of a travel audio guide.
        Keep the same paragraph structure.`
      },
      {
        role: "user",
        content: vietnameseText
      }
    ],
    temperature: 0.3,  // Thap de dich chinh xac
    max_tokens: 2000,
  });

  return response.choices[0].message.content;
}
```

**Chinh sach dich**:
- Giu nguyen ten rieng tieng Viet: Ma Pi Leng, Nho Que, Lung Cu
- Dich y nghia, khong dich tu tung tu
- Giu giong dieu audio guide (than thien, hap dan)
- Doi voi tieng Han/Trung: them phien am ten rieng khi can

#### 3.3 Buoc 3 — OpenAI TTS Generate Audio

**OpenAI TTS API**:

| Model | Chat luong | Toc do | Gia |
|-------|-----------|--------|-----|
| `tts-1` | Tieu chuan | Nhanh | $0.015 / 1,000 ky tu |
| `tts-1-hd` | Cao | Cham hon | $0.030 / 1,000 ky tu |

**Voices** (6 lua chon):

| Voice | Mo ta | Phu hop cho |
|-------|-------|-------------|
| `alloy` | Trung tinh, am | Huong dan chung |
| `echo` | Nam, tram | Lich su, van hoa |
| `fable` | Giong ke chuyen | Truyen thuyet, dan gian |
| `nova` | Nu, tre trung | Du lich, kham pha |
| `onyx` | Nam, sang trong | Gioi thieu chinh thuc |
| `shimmer` | Nu, am ap | Thien nhien, trai nghiem |

**Recommendation**: Dung `nova` cho tieng Anh, `alloy` cho tieng Viet. Chon voice phu hop voi ngon ngu va noi dung.

```typescript
// Goi OpenAI TTS
const response = await fetch("https://api.openai.com/v1/audio/speech", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${apiKey}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    model: "tts-1",         // hoac "tts-1-hd"
    voice: "nova",
    input: translatedText,
    response_format: "mp3",
    speed: 1.0,             // 0.25 - 4.0
  }),
});

const audioBuffer = await response.arrayBuffer();
// Upload len Supabase Storage
```

#### 3.4 Buoc 4 — Human Review

Truoc khi publish, content team kiem tra:

- [ ] Noi dung dich chinh xac
- [ ] Phat am ten rieng dung
- [ ] Giong doc tu nhien
- [ ] Thoi luong phu hop (2-5 phut)
- [ ] Khong co loi ngu phap
- [ ] Am thanh ro rang, khong noise

**Quy trinh**:
```
Status: draft → ai_generated → review → approved → published
                                  ↓
                              rejected → sua lai → ai_generated (lap lai)
```

#### 3.5 Edge Function: ai-tts

Xem chi tiet implementation trong [doc 06 — Backend Services, muc 4.5](06-backend-services.md).

### 4. Chi phi uoc tinh (Phase 2)

#### 4.1 Translation Cost

```
200 dia diem × 500 ky tu trung binh = 100,000 ky tu tieng Viet
Dich sang 3 ngon ngu: 100,000 × 3 = 300,000 ky tu input

GPT-4o-mini pricing: $0.15 / 1M input tokens, $0.60 / 1M output tokens
~300,000 ky tu ≈ ~100K tokens input, ~100K tokens output

Chi phi dich: ~$0.015 + ~$0.06 = ~$0.08
Lam tron (voi retries, system prompts): ~$2
```

#### 4.2 TTS Cost

```
200 dia diem × 4 ngon ngu = 800 audio files
800 files × 500 ky tu trung binh = 400,000 ky tu

tts-1: $0.015 / 1,000 ky tu
Chi phi: 400,000 / 1,000 × $0.015 = $6

tts-1-hd: $0.030 / 1,000 ky tu
Chi phi: 400,000 / 1,000 × $0.030 = $12
```

#### 4.3 Tong chi phi Phase 2

| Hang muc | Chi phi |
|----------|---------|
| Translation (GPT-4o-mini) | ~$2 |
| TTS tieu chuan (tts-1) | ~$6 |
| TTS chat luong cao (tts-1-hd) | ~$12 |
| **Tong (tieu chuan)** | **~$8** |
| **Tong (chat luong cao)** | **~$14** |

So sanh: Thu cong ~$4,000-8,000 vs AI ~$8-14. **Tiet kiem 99.8%**.

#### 4.4 Quality Control: A/B Test AI vs Human Voice

- Tao 5-10 audio bang ca AI va nguoi thuc
- Cho nguoi dung thu nghiem (beta testers) nghe ca 2
- Do luong: hoan thanh rate, feedback rating, thoi gian nghe
- Quyet dinh dua tren ket qua A/B test

---

## Phase 5 — AI Chatbot (RAG)

### 5. Kien truc RAG (Retrieval-Augmented Generation)

```
Nguoi dung hoi: "Nen di Ma Pi Leng vao thang may?"
    ↓
Edge Function: ai-chat
    ↓
1. Embed query → text-embedding-3-small
    ↓
2. pgvector similarity search (top 5 chunks)
    ↓  Tim thay: [Ma Pi Leng description, Best time to visit,
    ↓   Weather data, Road conditions, Tourist tips]
    ↓
3. Compose prompt voi context
    ↓
4. GPT-4o-mini generate response
    ↓
5. Stream response ve client
    ↓
"Ma Pi Leng dep nhat tu thang 9 den thang 11, khi lua chin
vang hai ben duong va troi trong xanh. Tranh thang 7-8 vi
mua lon, duong tron. Nen di buoi sang som (6-8h) de tranh
suong mu va co anh sang dep nhat cho chup anh..."
```

### 6. Embedding Pipeline

#### 6.1 Content → Chunks → Embeddings

```typescript
// supabase/functions/sync-embeddings/index.ts
async function syncEmbeddings(entityType: string, entityId: string) {
  // 1. Lay noi dung
  const { data: entity } = await supabase
    .from(entityType)
    .select('*')
    .eq('id', entityId)
    .single();

  // 2. Tao text tu cac fields
  const fullText = [
    entity.name,
    entity.description,
    entity.short_description,
    entity.best_time_to_visit,
    entity.tips,
    entity.history,
  ].filter(Boolean).join('\n\n');

  // 3. Chunk text (~500 tokens moi chunk)
  const chunks = chunkText(fullText, {
    maxTokens: 500,
    overlap: 50,  // Overlap de giu context
  });

  // 4. Embed tung chunk
  const embeddings = await Promise.all(
    chunks.map(async (chunk, index) => {
      const response = await openai.embeddings.create({
        model: "text-embedding-3-small",
        input: chunk,
      });

      return {
        entity_type: entityType,
        entity_id: entityId,
        chunk_index: index,
        content: chunk,
        title: entity.name,
        embedding: response.data[0].embedding,
        token_count: response.usage.total_tokens,
      };
    })
  );

  // 5. Upsert vao content_embeddings table
  // Xoa embeddings cu cua entity nay truoc
  await supabase
    .from('content_embeddings')
    .delete()
    .eq('entity_id', entityId)
    .eq('entity_type', entityType);

  await supabase
    .from('content_embeddings')
    .insert(embeddings);
}
```

#### 6.2 Chunking Strategy

```typescript
function chunkText(text: string, options: {
  maxTokens: number;
  overlap: number;
}): string[] {
  const sentences = text.split(/[.!?]\s+/);
  const chunks: string[] = [];
  let currentChunk = '';
  let currentTokens = 0;

  for (const sentence of sentences) {
    const sentenceTokens = estimateTokens(sentence);

    if (currentTokens + sentenceTokens > options.maxTokens && currentChunk) {
      chunks.push(currentChunk.trim());

      // Overlap: giu lai vai cau cuoi
      const overlapSentences = currentChunk.split(/[.!?]\s+/).slice(-2);
      currentChunk = overlapSentences.join('. ') + '. ';
      currentTokens = estimateTokens(currentChunk);
    }

    currentChunk += sentence + '. ';
    currentTokens += sentenceTokens;
  }

  if (currentChunk.trim()) {
    chunks.push(currentChunk.trim());
  }

  return chunks;
}
```

#### 6.3 pgvector Search Function

```sql
-- HNSW index cho fast cosine similarity
CREATE INDEX ON content_embeddings
  USING hnsw (embedding vector_cosine_ops)
  WITH (m = 16, ef_construction = 64);

-- Search function
CREATE OR REPLACE FUNCTION match_content(
  query_embedding VECTOR(1536),
  match_threshold FLOAT DEFAULT 0.7,
  match_count INT DEFAULT 5
)
RETURNS TABLE (
  entity_type TEXT,
  entity_id UUID,
  title TEXT,
  content TEXT,
  similarity FLOAT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    ce.entity_type,
    ce.entity_id,
    ce.title,
    ce.content,
    1 - (ce.embedding <=> query_embedding) AS similarity
  FROM content_embeddings ce
  WHERE 1 - (ce.embedding <=> query_embedding) > match_threshold
  ORDER BY ce.embedding <=> query_embedding
  LIMIT match_count;
END;
$$ LANGUAGE plpgsql;
```

**HNSW Index**:
- `m = 16`: so ket noi moi node (cao hon = chinh xac hon nhung ton memory)
- `ef_construction = 64`: chat luong xay dung index
- Cosine similarity: phu hop cho text embeddings
- Toc do query: < 10ms cho 100K vectors

### 7. Chatbot Capabilities

#### 7.1 Cac loai cau hoi ho tro

| Loai | Vi du | Data source |
|------|-------|-------------|
| **Thong tin dia diem** | "Ma Pi Leng co gi dac biet?" | locations table + embeddings |
| **Goi y tuyen duong** | "Nen di 3 ngay thi di dau?" | routes + locations |
| **Thiet bi** | "Can chuan bi gi khi di Ha Giang?" | articles (tips) |
| **Thoi tiet** | "Thang 10 thoi tiet the nao?" | articles + location metadata |
| **Khach san** | "Homestay o Dong Van gia bao nhieu?" | service_providers |
| **Khan cap** | "So dien thoai cuu ho?" | articles (emergency) |
| **Van hoa** | "Nguoi H'mong co phong tuc gi?" | articles (culture) |
| **Am thuc** | "Mon an noi tieng Ha Giang?" | articles (food) |

#### 7.2 Ngon ngu ho tro

- **Tieng Viet**: Day du, tu nhien
- **English**: Day du
- **Tieng Han**: Co ban (Phase 5.1), day du (Phase 5.2)
- **Tieng Trung**: Co ban (Phase 5.1), day du (Phase 5.2)

System prompt tu dong chuyen ngon ngu dua tren `contentLanguage` cua nguoi dung.

#### 7.3 Conversation History

```dart
class ChatMessage {
  final String role;     // 'user' hoac 'assistant'
  final String content;
  final DateTime timestamp;
  final List<String>? sourceLocationIds;  // Dia diem duoc tham chieu
}

// Giu toi da 10 messages trong conversation history
// De GPT hieu context cuoc hoi thoai
```

### 8. Voice Input

Speech-to-text chay tren device (khong can server):

```dart
class VoiceInputService {
  final SpeechToText _speech = SpeechToText();

  Future<String?> listen({required String locale}) async {
    if (!await _speech.initialize()) return null;

    String result = '';

    await _speech.listen(
      onResult: (speechResult) {
        result = speechResult.recognizedWords;
      },
      localeId: locale,  // 'vi_VN', 'en_US', 'ko_KR', 'zh_CN'
      listenMode: ListenMode.dictation,
    );

    // Doi nguoi dung noi xong
    await Future.delayed(const Duration(seconds: 5));
    await _speech.stop();

    return result;
  }
}
```

**Flow**:
```
Bam nut microphone
    → speech_to_text (on-device)
    → Text
    → Gui len ai-chat Edge Function
    → Nhan response
    → Hien thi (+ optional TTS doc lai)
```

### 9. AI Trip Planner (Phase 5)

#### 9.1 Input

```dart
class TripPlanRequest {
  final int numberOfDays;        // 2-7 ngay
  final List<String> interests;  // ['nature', 'culture', 'food', 'adventure']
  final String fitnessLevel;     // 'easy', 'moderate', 'challenging'
  final String startLocation;    // 'ha_giang_city'
  final String? budget;          // 'budget', 'moderate', 'luxury'
  final List<String>? mustVisit; // Dia diem bat buoc
}
```

#### 9.2 AI Generate Itinerary

```typescript
// Edge Function: plan-trip
const systemPrompt = `You are a Ha Giang travel expert.
Create a detailed day-by-day itinerary based on user preferences.
Use ONLY locations from the provided database.
Include: wake time, travel time between stops, activities, meals, accommodation.
Consider road conditions and distances.`;

const context = `Available locations:\n${locationsData}\n
Available routes:\n${routesData}\n
Available services:\n${servicesData}`;

const response = await openai.chat.completions.create({
  model: "gpt-4o-mini",
  messages: [
    { role: "system", content: systemPrompt },
    { role: "user", content: `${context}\n\nPlan: ${JSON.stringify(request)}` },
  ],
  response_format: { type: "json_object" },
  temperature: 0.7,
});
```

#### 9.3 Output

```json
{
  "title": "3 Ngay Kham Pha Cao Nguyen Da",
  "summary": "Hanh trinh trai nghiem van hoa H'mong va canh quan hung vi...",
  "days": [
    {
      "day": 1,
      "title": "Ha Giang - Quan Ba - Yen Minh",
      "distance_km": 95,
      "driving_hours": 3.5,
      "stops": [
        {
          "time": "07:00",
          "location_id": "uuid-1",
          "name": "Cong Troi Quan Ba",
          "duration_minutes": 45,
          "activity": "Ngam nui doi Quan Ba, chup anh",
          "audio_guide": true
        },
        {
          "time": "12:00",
          "type": "meal",
          "name": "Com trua tai Yen Minh",
          "provider_id": "uuid-2"
        }
      ],
      "accommodation": {
        "provider_id": "uuid-3",
        "name": "Homestay Yen Minh",
        "price_range": "200,000 - 400,000 VND"
      }
    }
  ],
  "total_distance_km": 350,
  "estimated_budget": {
    "accommodation": "1,200,000 VND",
    "food": "600,000 VND",
    "fuel": "300,000 VND",
    "activities": "200,000 VND",
    "total": "2,300,000 VND"
  },
  "packing_list": ["Ao am", "Ao mua", "Kem chong nang", "..."],
  "warnings": ["Duong deo quanh co, can than lai xe"]
}
```

### 10. Personalized Recommendations

Dua tren hanh vi nguoi dung de goi y noi dung phu hop:

```dart
class RecommendationEngine {
  /// Thu thap tin hieu tu hanh vi
  Future<UserProfile> buildProfile(String deviceId) async {
    final viewedLocations = await _analytics.getViewedLocations(deviceId);
    final completedAudio = await _analytics.getCompletedAudio(deviceId);
    final savedRoutes = await _analytics.getSavedRoutes(deviceId);

    return UserProfile(
      preferredCategories: _inferCategories(viewedLocations),
      // Neu xem nhieu 'nature' → goi y them nature
      difficultyPreference: _inferDifficulty(completedAudio),
      // Neu nghe audio dai → co the thich challenging routes
      languagePreference: _inferLanguage(completedAudio),
      visitedLocationIds: viewedLocations.map((l) => l.id).toList(),
    );
  }

  /// Goi y dia diem chua di, phu hop so thich
  Future<List<Location>> getRecommendations(UserProfile profile) async {
    // 1. Loc dia diem chua di
    // 2. Uu tien category phu hop
    // 3. Sap xep theo relevance score
    // 4. Them yeu to "popular among similar users"
  }
}
```

### 11. Chi phi uoc tinh (Phase 5)

#### 11.1 Embeddings (One-time)

```
200 locations × 3 chunks trung binh = 600 chunks
50 articles × 5 chunks = 250 chunks
Tong: 850 chunks × 500 tokens = 425,000 tokens

text-embedding-3-small: $0.020 / 1M tokens
Chi phi: 425,000 / 1,000,000 × $0.020 = ~$0.009

Lam tron voi overhead: ~$0.05
```

#### 11.2 Chat (Daily Operation)

```
Gia dinh: 1,000 queries/ngay (giai doan scale)

Moi query:
- Embedding query: ~20 tokens → $0.0000004
- GPT-4o-mini response:
  - Input: ~2,000 tokens (system + context + history) → $0.0003
  - Output: ~300 tokens → $0.0002
  - Tong per query: ~$0.0005

1,000 queries × $0.0005 = $0.50/ngay

Thuc te (voi retries, errors): ~$0.75/ngay ≈ ~$23/thang
```

#### 11.3 Trip Planner

```
Moi trip plan:
- Input: ~3,000 tokens (locations + routes + preferences) → $0.00045
- Output: ~1,000 tokens (JSON itinerary) → $0.0006
- Tong per plan: ~$0.001

100 plans/ngay: $0.10/ngay ≈ ~$3/thang
```

#### 11.4 Tong chi phi Phase 5

| Hang muc | Chi phi | Tan suat |
|----------|---------|----------|
| Embeddings | ~$0.05 | One-time (re-run khi content thay doi) |
| Chat queries | ~$23/thang | 1,000 queries/ngay |
| Trip planner | ~$3/thang | 100 plans/ngay |
| **Tong hang thang** | **~$26/thang** | Scale linearly voi usage |

**Luu y**: Chi phi giam khi OpenAI giam gia (trend lien tuc giam). Co the switch sang model re hon khi co.

---

## Tong ket AI Strategy

| Phase | Tinh nang | Chi phi | ROI |
|-------|-----------|---------|-----|
| Phase 2 | AI TTS + Translation | ~$14 one-time | Tiet kiem $4,000-8,000 vs thu cong |
| Phase 5 | RAG Chatbot | ~$26/thang | Tang engagement, giam support |
| Phase 5 | Trip Planner | ~$3/thang | Tinh nang premium, co the monetize |
| Phase 5 | Personalization | ~$5/thang | Tang retention |

**Nguyen tac**: Bat dau voi model re nhat (GPT-4o-mini, tts-1), chi nang cap khi chat luong khong du. AI la cong cu ho tro — con nguoi van review va quyet dinh cuoi cung.
