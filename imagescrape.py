import os.path
import requests
from urllib.request import urlopen
import shutil  # to save it locally

import os
print(os.getcwd())

count = 1

# AMOUNT OF PICTURES YOU WANT
amt_pics = 400

while (count < (amt_pics+1)):
    image_url = 'https://picsum.photos/100'
    filename = r'/Users/timolsson/TNM097/Dataset1/{}'.format(
        str("image") + str(count) + str(".jpg"))

    # Open the url image, set stream to True, this will return the stream content.
    r = requests.get(image_url, stream=True)

    # Check if the image was retrieved successfully
    if r.status_code == 200:
        # Set decode_content value to True, otherwise the downloaded image file's size will be zero.
        r.raw.decode_content = True

        # Open a local file with wb ( write binary ) permission.
        with open(filename, 'wb') as f:
            shutil.copyfileobj(r.raw, f)

        print('Image sucessfully Downloaded: ', filename)
    else:
        print('Image Couldn\'t be retreived')
    count = count + 1
