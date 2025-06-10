import cv2
import numpy as np
from PIL import Image
# 读取图片
from tqdm import tqdm  # 导入tqdm
import os
# 图像大小
img_indoor_path = '../Dehaze/test/indoor/gt/'
img_indoor_hazy_path = '../Dehaze/test/indoor/hazy/'
img_outdoor_path = '../Dehaze/test/outdoor/gt/'
img_outdoor_hazy_path = '../Dehaze/test/outdoor/hazy/'

path_free = img_outdoor_path
path_haze = img_outdoor_hazy_path
txt_path = "./Buffer_test/Python_dec/indoor/"
# txt_path = "./Buffer_test/Python_dec/outdoor/"
jpg_files = [f for f in os.listdir(path_free) if f.endswith(".jpg")]
psnr_all = 0
ssim_all = 0
mse_all = 0
for image_name in tqdm(jpg_files):
    prefix = image_name.split(".")[0]
    input_image = Image.open(path_haze + image_name)
    input_image = input_image.resize((640,480))
    input_image = np.asarray(input_image).astype(np.uint8)
    data = input_image.flatten()
    # print(data.shape)
    # 保存数据到txt文件
    np.savetxt(txt_path +'indoor.txt', data, fmt='%d')
    # np.savetxt(txt_path + prefix +'.txt', data, fmt='%d')



