def test_analytics_content(api_client, base_url):
    response = api_client.get(f"{base_url}/analytics/content/1", params={"content_type": "place"})
    assert response.status_code in [200, 404, 400]

def test_analytics_top_content(api_client, base_url):
    response = api_client.get(f"{base_url}/analytics/top-content")
    assert response.status_code in [200, 404, 400]

def test_user_track(auth_client, base_url):
    payload = {
        "content_type": "place",
        "content_id": 1,
        "event_type": "page_view"
    }
    response = auth_client.post(f"{base_url}/user/track", json=payload)
    assert response.status_code in [200, 201, 400, 404]
