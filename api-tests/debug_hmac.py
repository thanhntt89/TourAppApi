import requests

endpoints = [
    '/toursapp/v1/provinces',
    '/toursapp/v1/sync/package/144',
    '/toursapp/v1/places',
]

for ep in endpoints:
    r = requests.get(
        f'https://hagiang.caremycars.com/wp-json{ep}',
        headers={'Accept': 'application/json'},
        timeout=10
    )
    cf = r.headers.get('CF-Cache-Status', '?')
    print(f'{r.status_code}  {ep}  (CF-Cache: {cf})')
