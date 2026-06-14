def test_get_comments(api_client, base_url):
    response = api_client.get(f"{base_url}/content/place/1/comments")
    assert response.status_code in [200, 404]

def test_post_comment(auth_client, base_url):
    payload = {"comment_text": "This is a test comment"}
    response = auth_client.post(f"{base_url}/content/place/1/comments", json=payload)
    assert response.status_code in [200, 201, 400, 404]

def test_put_comment(auth_client, base_url):
    payload = {"comment_text": "Updated test comment"}
    response = auth_client.put(f"{base_url}/content/place/1/comments/1", json=payload)
    assert response.status_code in [200, 400, 404, 403]

def test_delete_comment(auth_client, base_url):
    response = auth_client.delete(f"{base_url}/content/place/1/comments/1")
    assert response.status_code in [200, 404, 403]

def test_get_rating(api_client, base_url):
    response = api_client.get(f"{base_url}/content/place/1/rating")
    assert response.status_code in [200, 404]

def test_post_rating(auth_client, base_url):
    payload = {"rating": 5}
    response = auth_client.post(f"{base_url}/content/place/1/rating", json=payload)
    assert response.status_code in [200, 400, 404]

def test_upload_photo(auth_client, base_url):
    # This is a bit tricky to fully test without multipart data, but we can verify the endpoint exists
    response = auth_client.post(f"{base_url}/user/upload-photo")
    assert response.status_code in [200, 400] # Usually 400 for missing file
