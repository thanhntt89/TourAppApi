def test_sync_check_no_auth(api_client, base_url):
    params = {"province_id": 144, "since": "2020-01-01T00:00:00Z"}
    response = api_client.get(f"{base_url}/sync/check", params=params)
    assert response.status_code == 401

def test_sync_check_with_auth(auth_client, base_url):
    params = {"province_id": 144, "since": "2020-01-01T00:00:00Z"}
    response = auth_client.get(f"{base_url}/sync/check", params=params)
    assert response.status_code in [200, 404]

def test_sync_package_no_auth(api_client, base_url):
    response = api_client.get(f"{base_url}/sync/package/144")
    assert response.status_code == 401

def test_sync_package_with_auth(auth_client, base_url):
    response = auth_client.get(f"{base_url}/sync/package/144")
    assert response.status_code in [200, 404]

def test_sync_media_no_auth(api_client, base_url):
    response = api_client.get(f"{base_url}/sync/media/144", params={"type": "all"})
    assert response.status_code == 401

def test_sync_media_with_auth(auth_client, base_url):
    response = auth_client.get(f"{base_url}/sync/media/144", params={"type": "all"})
    assert response.status_code in [200, 404]
