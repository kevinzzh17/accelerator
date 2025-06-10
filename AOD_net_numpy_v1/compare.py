import matplotlib.pyplot as plt
import numpy as np
from PIL import Image
import cv2
from skimage.metrics import structural_similarity as ssim
from skimage.metrics import peak_signal_noise_ratio as psnr
from skimage.metrics import mean_squared_error as mse
import time
from tqdm import tqdm
import os
path_PYNQ_old = "test_image_PYNQ/"
path_PYNQ_new = "test_image_PYNQ_now/"

# png_files = [f for f in os.listdir(path_PYNQ_old) if f.endswith(".png")]
# mse_all = 0
# for image_name in tqdm(png_files):
#     img_fp32 = Image.open(path_PYNQ_old + image_name)
#     img_int8 = Image.open(path_PYNQ_new + image_name)

#     img_fp32 = np.asarray(img_fp32)
#     img_int8 = np.asarray(img_int8)

#     img_mse = mse(img_fp32,img_int8)/ (640*480)
#     mse_all = img_mse + mse_all
img1 = Image.open(path_PYNQ_old + "1400.png")
img2 = Image.open(path_PYNQ_new + "1400.png")
img1 = np.asarray(img1)
img2 = np.asarray(img2)
img_mse = mse(img1,img2)/ (640*480)
# mse_average = mse_all/500.0
print("the average mse:{}".format(img_mse))