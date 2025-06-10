import requests
from PIL import Image
from io import BytesIO

url = 'https://i.imgur.com/5xQ83YR.png'
response = requests.get(url)
img = Image.open(BytesIO( response.content))
img.show()
