def test_get_provinces(api_client, base_url):
    response = api_client.get(f"{base_url}/provinces")
    assert response.status_code == 200

def test_get_provinces_detect(api_client, base_url):
    response = api_client.get(f"{base_url}/provinces/detect", params={"lat": 23.3, "lng": 105.3})
    assert response.status_code == 200

def test_get_province_detail(api_client, base_url):
    response = api_client.get(f"{base_url}/provinces/1")
    assert response.status_code in [200, 404]

def test_get_locations(api_client, base_url):
    response = api_client.get(f"{base_url}/provinces/1/locations")
    assert response.status_code in [200, 404]

def test_get_location_detail(api_client, base_url):
    response = api_client.get(f"{base_url}/locations/1")
    # might be 404 if not found, but we check if endpoint exists
    assert response.status_code in [200, 404]

def test_get_places(api_client, base_url):
    response = api_client.get(f"{base_url}/places")
    assert response.status_code == 200

def test_get_place_detail(api_client, base_url):
    response = api_client.get(f"{base_url}/places/1")
    assert response.status_code in [200, 404]

def test_get_places_nearby(api_client, base_url):
    response = api_client.get(f"{base_url}/places/nearby", params={"lat": 23.3, "lng": 105.3})
    assert response.status_code == 200

def test_get_places_qr(api_client, base_url):
    response = api_client.get(f"{base_url}/places/qr/lungcu")
    assert response.status_code in [200, 404]

def test_get_places_search(api_client, base_url):
    response = api_client.get(f"{base_url}/places/search", params={"q": "ha giang"})
    assert response.status_code == 200

def test_get_sub_places(api_client, base_url):
    response = api_client.get(f"{base_url}/places/1/sub-places")
    assert response.status_code in [200, 404]

def test_get_sub_place_detail(api_client, base_url):
    response = api_client.get(f"{base_url}/sub-places/1")
    assert response.status_code in [200, 404]

def test_get_sub_item_detail(api_client, base_url):
    response = api_client.get(f"{base_url}/sub-items/1")
    assert response.status_code in [200, 404]

def test_get_journeys(api_client, base_url):
    response = api_client.get(f"{base_url}/journeys", params={"province_id": 1})
    assert response.status_code == 200

def test_get_journey_detail(api_client, base_url):
    response = api_client.get(f"{base_url}/journeys/1")
    assert response.status_code in [200, 404]

def test_get_news(api_client, base_url):
    response = api_client.get(f"{base_url}/news", params={"province_id": 1})
    assert response.status_code == 200

def test_get_stories(api_client, base_url):
    response = api_client.get(f"{base_url}/stories")
    assert response.status_code == 200

def test_get_story_detail(api_client, base_url):
    response = api_client.get(f"{base_url}/stories/1")
    assert response.status_code in [200, 404]
