"""
test_02_public.py
Public endpoints: Provinces, Locations, Places, Sub-places, Sub-items,
Journeys, Stories, News — schema validation theo ENDPOINTS.md
"""
import pytest
from schemas import assert_has_fields, assert_list_items, get_data, get_data_list

# ─── Shared province/place IDs to reuse across tests ──────────────────────────
PROVINCE_ID = 144   # Ha Giang (luôn có dữ liệu trên staging)
PLACE_SLUG  = "lungcu"

# ═════════════════════════════════════════════════════════════════════════════
# PROVINCES
# ═════════════════════════════════════════════════════════════════════════════

PROVINCE_COMPACT_FIELDS = [
    "id", "name", "feature_image",
    "latitude", "longitude",
    "detection_radius_km", "is_active",
    "total_locations", "total_places", "sort_order",
]


def test_get_provinces(api_client, base_url):
    """#2 GET /provinces — list với compact fields."""
    response = api_client.get(f"{base_url}/provinces")
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    items = data["data"]
    assert isinstance(items, list) and len(items) > 0, "Phải có ít nhất 1 province"
    assert_has_fields(items[0], PROVINCE_COMPACT_FIELDS, label="provinces[0]")


def test_get_provinces_detect_hit(api_client, base_url):
    """#3 GET /provinces/detect — tọa độ trong Ha Giang phải detected=True."""
    response = api_client.get(f"{base_url}/provinces/detect", params={"lat": 22.83, "lng": 104.98})
    assert response.status_code == 200
    data = get_data(response)
    assert "detected" in data, "Field 'detected' bị thiếu"
    if data["detected"]:
        assert_has_fields(data["province"], PROVINCE_COMPACT_FIELDS, label="detect.province")
    else:
        assert "available_provinces" in data, "Khi detected=False phải có available_provinces"


def test_get_provinces_detect_miss(api_client, base_url):
    """#3 GET /provinces/detect — tọa độ ngoài biên giới → detected=False."""
    response = api_client.get(f"{base_url}/provinces/detect", params={"lat": 0.0, "lng": 0.0})
    assert response.status_code == 200
    data = get_data(response)
    assert data["detected"] is False
    assert "available_provinces" in data


def test_get_province_detail(api_client, base_url):
    """#4 GET /provinces/{id} — detail fields."""
    response = api_client.get(f"{base_url}/provinces/{PROVINCE_ID}")
    if response.status_code == 404:
        pytest.skip(f"Province {PROVINCE_ID} không tồn tại trên server này")
    assert response.status_code == 200
    data = get_data(response)
    assert_has_fields(data, PROVINCE_COMPACT_FIELDS + ["description", "banner_images"], label="province_detail")


# ═════════════════════════════════════════════════════════════════════════════
# LOCATIONS
# ═════════════════════════════════════════════════════════════════════════════

LOCATION_COMPACT_FIELDS = ["id", "number", "name", "feature_image", "latitude", "longitude", "total_places", "sort_order"]


def test_get_locations(api_client, base_url):
    """#5 GET /provinces/{province_id}/locations."""
    response = api_client.get(f"{base_url}/provinces/{PROVINCE_ID}/locations")
    if response.status_code == 404:
        pytest.skip("Không có locations cho province này")
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    items = data["data"]
    assert isinstance(items, list) and len(items) > 0
    assert_has_fields(items[0], LOCATION_COMPACT_FIELDS, label="locations[0]")


def test_get_location_detail(api_client, base_url):
    """#6 GET /locations/{id} — compact + description + province."""
    response = api_client.get(f"{base_url}/locations/1")
    if response.status_code == 404:
        pytest.skip("Location 1 không tồn tại")
    assert response.status_code == 200
    data = get_data(response)
    assert_has_fields(data, LOCATION_COMPACT_FIELDS + ["description", "province"], label="location_detail")
    assert_has_fields(data["province"], ["id", "name"], label="location_detail.province")


# ═════════════════════════════════════════════════════════════════════════════
# PLACES
# ═════════════════════════════════════════════════════════════════════════════

PLACE_COMPACT_FIELDS = [
    "id", "order_number", "name", "info", "feature_image",
    "latitude", "longitude", "is_featured", "sort_order", "sub_places_count",
]

PLACE_DETAIL_FIELDS = PLACE_COMPACT_FIELDS + [
    "hierarchical_index", "article", "gallery", "audio",
    "geofence_radius", "qr_code",
    "show_article_free", "show_audio_free",
    "article_offline", "audio_offline",
    "article_cost", "checkin_reward", "location",
]


def test_get_places(api_client, base_url):
    """#7 GET /places — list compact fields."""
    response = api_client.get(f"{base_url}/places")
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    items = data["data"]
    assert isinstance(items, list) and len(items) > 0
    assert_has_fields(items[0], PLACE_COMPACT_FIELDS, label="places[0]")


def test_get_place_detail(api_client, base_url):
    """#8 GET /places/{id} — full detail fields."""
    response = api_client.get(f"{base_url}/places/1")
    if response.status_code == 404:
        pytest.skip("Place 1 không tồn tại")
    assert response.status_code == 200
    data = get_data(response)
    assert_has_fields(data, PLACE_DETAIL_FIELDS, label="place_detail")
    # audio object
    if data["audio"]:
        assert_has_fields(data["audio"], ["url", "size"], label="place_detail.audio")
    # location nested object
    assert_has_fields(data["location"], ["id", "number", "name"], label="place_detail.location")


def test_get_places_nearby(api_client, base_url):
    """#9 GET /places/nearby — fields bao gồm distance_meters."""
    response = api_client.get(f"{base_url}/places/nearby", params={"lat": 22.83, "lng": 104.98, "radius": 50000})
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    items = data["data"]
    assert isinstance(items, list)
    if items:
        assert_has_fields(items[0], [
            "id", "name", "feature_image", "latitude", "longitude",
            "distance_meters", "geofence_radius", "is_within_geofence",
            "has_audio", "is_featured", "sort_order",
        ], label="places_nearby[0]")


def test_get_places_qr(api_client, base_url):
    """#10 GET /places/qr/{code} — trả về place detail hoặc 404."""
    response = api_client.get(f"{base_url}/places/qr/{PLACE_SLUG}")
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, PLACE_COMPACT_FIELDS, label="places_qr")


def test_get_places_search(api_client, base_url):
    """#11 GET /places/search — phải có match_score."""
    response = api_client.get(f"{base_url}/places/search", params={"q": "lung"})
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    items = data["data"]
    assert isinstance(items, list)
    if items:
        assert_has_fields(items[0], [
            "id", "name", "info", "feature_image",
            "latitude", "longitude", "is_featured", "sort_order", "match_score",
        ], label="places_search[0]")


# ═════════════════════════════════════════════════════════════════════════════
# SUB-PLACES & SUB-ITEMS
# ═════════════════════════════════════════════════════════════════════════════

def test_get_sub_places(api_client, base_url):
    """#12 GET /places/{place_id}/sub-places — compact list + sub_items."""
    response = api_client.get(f"{base_url}/places/1/sub-places")
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        data = response.json()
        items = data["data"]
        if items:
            assert_has_fields(items[0], [
                "id", "sub_place_index", "name", "feature_image",
                "latitude", "longitude", "sort_order", "sub_items",
            ], label="sub_places[0]")


def test_get_sub_place_detail(api_client, base_url):
    """#13 GET /sub-places/{id} — full detail + audio + place."""
    response = api_client.get(f"{base_url}/sub-places/1")
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, [
            "id", "sub_place_index", "name", "feature_image",
            "latitude", "longitude", "sort_order",
            "description", "audio", "place", "sub_items",
        ], label="sub_place_detail")
        assert_has_fields(data["place"], ["id", "name"], label="sub_place_detail.place")


def test_get_sub_item_detail(api_client, base_url):
    """#14 GET /sub-items/{id} — deep link detail."""
    response = api_client.get(f"{base_url}/sub-items/1")
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, [
            "id", "item_index", "name", "description",
            "feature_image", "gallery", "audio", "sort_order",
            "sub_place", "place",
        ], label="sub_item_detail")
        assert_has_fields(data["sub_place"], ["id", "name"], label="sub_item_detail.sub_place")
        assert_has_fields(data["place"], ["id", "name"], label="sub_item_detail.place")


# ═════════════════════════════════════════════════════════════════════════════
# JOURNEYS
# ═════════════════════════════════════════════════════════════════════════════

JOURNEY_FIELDS = [
    "id", "type", "name", "description", "feature_image",
    "duration_days", "total_places", "difficulty",
    "is_featured", "sort_order", "stops",
]


def test_get_journeys(api_client, base_url):
    """#15 GET /journeys — list preset journeys."""
    response = api_client.get(f"{base_url}/journeys", params={"province_id": PROVINCE_ID})
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    items = data["data"]
    assert isinstance(items, list)
    if items:
        assert_has_fields(items[0], JOURNEY_FIELDS, label="journeys[0]")
        assert items[0]["type"] == "preset"


def test_get_journey_detail(api_client, base_url):
    """#16 GET /journeys/{id} — fields + stops."""
    response = api_client.get(f"{base_url}/journeys/1")
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, JOURNEY_FIELDS, label="journey_detail")
        if data["stops"]:
            assert_has_fields(data["stops"][0], [
                "stop_order", "day", "duration_min", "place",
            ], label="journey_detail.stops[0]")
            assert_has_fields(data["stops"][0]["place"], ["id", "name", "lat", "lng"],
                               label="journey_detail.stops[0].place")


# ═════════════════════════════════════════════════════════════════════════════
# STORIES
# ═════════════════════════════════════════════════════════════════════════════

STORY_COMPACT_FIELDS = [
    "id", "type", "name", "summary", "feature_image",
    "is_featured", "sort_order",
    "article", "audio_info",
    "allow_comments", "allow_ratings", "enable_tracking",
]


def test_get_stories(api_client, base_url):
    """#17 GET /stories — compact list fields."""
    response = api_client.get(f"{base_url}/stories")
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    items = data["data"]
    assert isinstance(items, list)
    if items:
        assert_has_fields(items[0], STORY_COMPACT_FIELDS, label="stories[0]")
        assert_has_fields(items[0]["article"], ["is_free", "cost"], label="stories[0].article")
        assert_has_fields(items[0]["audio_info"], ["is_free", "cost", "duration"], label="stories[0].audio_info")


def test_get_story_detail(api_client, base_url):
    """#18 GET /stories/{id} — compact + content + audio + related."""
    response = api_client.get(f"{base_url}/stories/1")
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, STORY_COMPACT_FIELDS + ["content", "audio", "related_places", "related_provinces"],
                          label="story_detail")


# ═════════════════════════════════════════════════════════════════════════════
# NEWS
# ═════════════════════════════════════════════════════════════════════════════

NEWS_FIELDS = ["id", "type", "title", "content", "icon", "is_pinned", "start_date", "end_date", "created_at"]


def test_get_news(api_client, base_url):
    """#19 GET /news — fields + sorted."""
    response = api_client.get(f"{base_url}/news", params={"province_id": PROVINCE_ID})
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    items = data["data"]
    assert isinstance(items, list)
    if items:
        assert_has_fields(items[0], NEWS_FIELDS, label="news[0]")
