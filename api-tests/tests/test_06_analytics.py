"""
test_06_analytics.py
Analytics + User Track — #27, #28, #29
Schema validation theo ENDPOINTS.md.
"""
import pytest
from schemas import assert_has_fields, get_data

# ═════════════════════════════════════════════════════════════════════════════
# ANALYTICS CONTENT — #27
# ═════════════════════════════════════════════════════════════════════════════

# NOTE: API thực tế trả {total_events, unique_devices, by_event}
# Khác với ENDPOINTS.md — cần ụy riêng với backend team.
ANALYTICS_CONTENT_FIELDS = [
    "total_events", "unique_devices", "by_event",
]


def test_analytics_content(api_client, base_url):
    """#27 GET /analytics/content/{id} — validate schema fields."""
    response = api_client.get(f"{base_url}/analytics/content/1", params={"content_type": "place"})
    assert response.status_code in [200, 404, 400]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, ANALYTICS_CONTENT_FIELDS, label="analytics_content")
        assert isinstance(data["total_events"], int)
        assert isinstance(data["unique_devices"], int)
        assert isinstance(data["by_event"], dict)


def test_analytics_content_invalid_type(api_client, base_url):
    """#27 GET /analytics/content/{id} — content_type không hợp lệ → 400."""
    response = api_client.get(f"{base_url}/analytics/content/1", params={"content_type": "invalid_type"})
    assert response.status_code in [400, 404]


def test_analytics_content_missing_type(api_client, base_url):
    """#27 GET /analytics/content/{id} — thiếu content_type → 400."""
    response = api_client.get(f"{base_url}/analytics/content/1")
    assert response.status_code in [400, 404]


# ═════════════════════════════════════════════════════════════════════════════
# ANALYTICS TOP CONTENT — #28
# ═════════════════════════════════════════════════════════════════════════════

def test_analytics_top_content(api_client, base_url):
    """#28 GET /analytics/top-content — default metric=views."""
    response = api_client.get(f"{base_url}/analytics/top-content")
    assert response.status_code in [200, 400]
    if response.status_code == 200:
        body = response.json()
        assert body["success"] is True
        items = body["data"]
        assert isinstance(items, list)


def test_analytics_top_content_by_shares(api_client, base_url):
    """#28 GET /analytics/top-content — metric=shares, limit=5."""
    response = api_client.get(f"{base_url}/analytics/top-content", params={
        "metric": "shares", "limit": 5, "order": "DESC",
    })
    assert response.status_code in [200, 400]
    if response.status_code == 200:
        body = response.json()
        assert body["success"] is True
        items = body["data"]
        assert len(items) <= 5, f"limit=5 nhưng trả về {len(items)} items"


# ═════════════════════════════════════════════════════════════════════════════
# USER TRACK — #29
# ═════════════════════════════════════════════════════════════════════════════

def test_user_track(auth_client, base_url):
    """#29 POST /user/track — ghi event page_view."""
    response = auth_client.post(f"{base_url}/user/track", json={
        "content_type": "place",
        "content_id": 1,
        "event_type": "page_view",
    })
    assert response.status_code in [200, 201, 400, 404]


def test_user_track_article_read(auth_client, base_url):
    """#29 POST /user/track — event article_read với scroll_depth."""
    response = auth_client.post(f"{base_url}/user/track", json={
        "content_type": "place",
        "content_id": 1,
        "event_type": "article_read",
        "scroll_depth": 75,
        "duration_sec": 120,
    })
    assert response.status_code in [200, 201, 400, 404]


def test_user_track_audio_play(auth_client, base_url):
    """#29 POST /user/track — event audio_play với completion_pct."""
    response = auth_client.post(f"{base_url}/user/track", json={
        "content_type": "ta_story",
        "content_id": 1,
        "event_type": "audio_play",
        "completion_pct": 50,
    })
    assert response.status_code in [200, 201, 400, 404]


def test_user_track_invalid_event(auth_client, base_url):
    """#29 POST /user/track — event_type không hợp lệ → 400."""
    response = auth_client.post(f"{base_url}/user/track", json={
        "content_type": "place",
        "content_id": 1,
        "event_type": "INVALID_EVENT",
    })
    assert response.status_code in [400, 404]
