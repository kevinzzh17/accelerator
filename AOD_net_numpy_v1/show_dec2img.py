from PIL import Image
from tqdm import tqdm  # 导入tqdm
import numpy as np
import os

txt_type = "indoor/"
# txt_type = "outdoor/"
Verilog_dec_path = "./Buffer_test/Verilog_dec/"
Python_dec_path = "./Buffer_test/Python_dec/"
# Verilog_dec_path = "./Buffer_test/Verilog_dec/" + txt_type
img_path = "./test_image_BILD/" + txt_type
txt_files = [f for f in os.listdir(Verilog_dec_path) if f.endswith(".txt")]
# 图像大小
width, height = 1920, 1080
# for file_name in tqdm(txt_files):
#     prefix = file_name.split(".")[0]
#     image = Image.new("RGB", (width, height))
#     data = np.fromfile(Verilog_dec_path + file_name, np.uint8,sep=",")
#     print(data.shape)
    # data = data.reshape(height,width,3)
    # data = data + 128
    # 显示图像
    # image = Image.fromarray(data)
    # image.save(img_path + prefix + ".png", "PNG")
    # image.show()
# Verilog_hex_path = "./Buffer_test/Python_hex/day.txt"
# data = []
# with open(Verilog_hex_path,'r') as f:
#     file = f.readlines()
#     print(type(file))
#     # data = np.loadtxt(Verilog_hex_path, np.uint8)
#     for hex in file:
#         # print(hex)
#         num = int(hex,16)
#         data.append(num)
#     data = np.uint8(data)
#     data = data.reshape(1088,1936)

# print(data)
# image = Image.fromarray(data)
# image.show()
file_name = "result.txt"
# image = Image.new("RGB", (width, height))
data = np.fromfile(Verilog_dec_path + file_name, np.uint8,sep=",")
# new = np.zeros(height,width,3)
print(data.shape)
# data = data[0:1159680]
# data = data.reshape(1280,302,3)
# # # data = data[0:height-2,:,:]
# # # print(data)
# image = Image.fromarray(data)
# image.show()

