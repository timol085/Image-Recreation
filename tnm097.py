import shutil
import cv2
import requests

d = 0

for i in range(1, 100):
    url = 'https://picsum.photos/200'
    response = requests.get(url, stream=True)
    with open('img.png', 'wb') as out_file:
        f = shutil.copyfileobj(response.raw, out_file)
    del response
    filename = "images/file_%d.jpg" % d
    cv2.imwrite(filename, f)
    d += 1
