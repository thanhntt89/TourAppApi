"""
test_05_comments.py
Comments, Ratings, Upload Photo — schema validation.
#20-26 theo ENDPOINTS.md
"""
import pytest
from schemas import assert_has_fields, get_data

CONTENT_TYPE = "place"
CONTENT_ID = 1   # place_id có dữ liệu trên staging

# ═════════════════════════════════════════════════════════════════════════════
# COMMENTS — #20-23
# ═════════════════════════════════════════════════════════════════════════════

COMMENT_FIELDS = ["id", "comment_text", "created_at", "device_uuid"]


def test_get_comments(api_client, base_url):
    """#20 GET /content/{type}/{id}/comments — public, list comments."""
    response = api_client.get(f"{base_url}/content/{CONTENT_TYPE}/{CONTENT_ID}/comments")
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        body = response.json()
        assert body["success"] is True
        items = body["data"]
        assert isinstance(items, list)
        if items:
            assert_has_fields(items[0], COMMENT_FIELDS, label="comments[0]")


def test_post_comment(auth_client, base_url):
    """#21 POST /content/{type}/{id}/comments — tạo comment mới."""
    response = auth_client.post(
        f"{base_url}/content/{CONTENT_TYPE}/{CONTENT_ID}/comments",
        json={"comment_text": "Auto test comment — schema validation"},
    )
    assert response.status_code in [200, 201, 400, 404]
    if response.status_code in [200, 201]:
        data = get_data(response)
        # API trả comment_id + status (pending/approved) khi comment được submit
        assert_has_fields(data, ["comment_id", "status"], label="post_comment")
        assert data["status"] in ["pending", "approved"]


def test_put_comment(auth_client, base_url):
    """#22 PUT /content/{type}/{id}/comments/{cid} — edit comment."""
    response = auth_client.put(
        f"{base_url}/content/{CONTENT_TYPE}/{CONTENT_ID}/comments/1",
        json={"comment_text": "Updated comment text"},
    )
    assert response.status_code in [200, 400, 403, 404]


def test_delete_comment(auth_client, base_url):
    """#23 DELETE /content/{type}/{id}/comments/{cid}."""
    response = auth_client.delete(
        f"{base_url}/content/{CONTENT_TYPE}/{CONTENT_ID}/comments/1",
    )
    assert response.status_code in [200, 403, 404]


# ═════════════════════════════════════════════════════════════════════════════
# RATING — #24-25
# ═════════════════════════════════════════════════════════════════════════════

RATING_FIELDS = ["average", "total", "distribution"]
# NOTE: your_rating chỉ xuất hiện khi gọi có X-Device-UUID header


def test_get_rating(api_client, base_url):
    """#24 GET /content/{type}/{id}/rating — public, schema validation."""
    response = api_client.get(f"{base_url}/content/{CONTENT_TYPE}/{CONTENT_ID}/rating")
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, RATING_FIELDS, label="get_rating")
        assert isinstance(data["average"], (int, float))
        assert isinstance(data["total"], int)
        assert isinstance(data["distribution"], dict)
        # distribution phải có keys 1-5
        for star in ["1", "2", "3", "4", "5"]:
            assert star in data["distribution"], f"distribution thiếu key '{star}'"
        # your_rating không có khi không gửi UUID (có thể không có field này)


def test_get_rating_with_auth(auth_client, base_url):
    """#24 GET /content/{type}/{id}/rating với auth — your_rating có thể là số hoặc null."""
    response = auth_client.get(f"{base_url}/content/{CONTENT_TYPE}/{CONTENT_ID}/rating")
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, RATING_FIELDS, label="get_rating_auth")
        assert data["your_rating"] is None or isinstance(data["your_rating"], int)


def test_post_rating(auth_client, base_url):
    """#25 POST /content/{type}/{id}/rating — submit rating 1-5."""
    response = auth_client.post(
        f"{base_url}/content/{CONTENT_TYPE}/{CONTENT_ID}/rating",
        json={"rating": 5},
    )
    assert response.status_code in [200, 400, 404]


def test_post_rating_invalid(auth_client, base_url):
    """#25 POST /content/{type}/{id}/rating — rating ngoài 1-5 → 400."""
    response = auth_client.post(
        f"{base_url}/content/{CONTENT_TYPE}/{CONTENT_ID}/rating",
        json={"rating": 99},
    )
    assert response.status_code == 400, "Rating 99 phải bị reject với 400"


# ═════════════════════════════════════════════════════════════════════════════
# UPLOAD PHOTO — #26
# ═════════════════════════════════════════════════════════════════════════════

def test_upload_photo_no_file(auth_client, base_url):
    """#26 POST /user/upload-photo — không có file → 400."""
    response = auth_client.post(f"{base_url}/user/upload-photo")
    assert response.status_code == 400, "Upload không có file phải là 400"


def test_upload_photo_schema(auth_client, base_url):
    """#26 POST /user/upload-photo — nếu có file, response: photo_id + url."""
    # Tạo fake 1x1 pixel PNG (valid binary)
    import base64
    tiny_png = base64.b64decode(
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=="
    )
    response = auth_client.post(
        f"{base_url}/user/upload-photo",
        files={"photo": ("test.png", tiny_png, "image/png")},
        headers={k: v for k, v in auth_client.headers.items() if k != "Content-Type"},
    )
    assert response.status_code in [200, 400]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, ["photo_id", "url"], label="upload_photo")
