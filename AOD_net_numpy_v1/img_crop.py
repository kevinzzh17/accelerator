from PIL import Image
import numpy as np
import os
from tqdm import tqdm

path = "test_image_FP32/"
# path = "test_image_INT8/"
# path = "test_image/"

jpg_files = [f for f in os.listdir(path) if f.endswith(".jpg")]
for image_name in tqdm(jpg_files):
    img = Image.open(path + image_name)
    width, height = img.size
    top = height/3
    bottom = top*2
    left = 0
    right = width
    cropped_image = img.crop((left, top, right, bottom))
    # cropped_image.show()
    cropped_image.save(path + image_name)