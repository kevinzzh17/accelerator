import numpy as np
import matplotlib.pyplot as plt
import cv2

# txt_path = "./conv5_out.txt"
# conv1_in_path = "./test/txt_hex/in/conv1_in.txt"
# array = []
# with open(conv1_in_path,'r') as file:
#     lines = file.readlines()
#     for line in lines:
#         line = line.strip()
#         # line = hex(int(line,16))[2:].zfill(6)
#         line = int(line,16)
#         array.append(line)
#     array[:] = np.array(array)
# # print (array)

# array = [hex(num)[2:].zfill(6) for num in array]
# # print(array)P
# new_array = []
# for j in range(3):
#     for string in array:
#         new_sublist = int(string[2*j:2*j+2], 16)
#         # 将新的子列表添加到二维列表中
#         new_array.append(new_sublist)

# new_array = np.array(new_array).reshape(3, 480, 640)
# # print(new_array)
# new_array = (new_array+128).transpose(1,2,0)
# # plt.imshow(new_array)
# # 使用NumPy将一维数据转换为二维张量
# # array = np.array(array)
# # array = array.reshape(height, width)
# # print(array)
# # with open(txt_path,'w') as f:
# #     for i,j in array:
# #         line = hex(i)[2:].zfill(6)
# haze_img_int8 = (new_array-128).transpose(2,0,1).astype(np.uint8)
# # print(haze_img_int8)
# # print (haze_img_int8[0]*(16^2) + haze_img_int8[1] *16 +haze_img_int8[2])
# haze_img_int8 = np.array(haze_img_int8).reshape(3,307200)
# print(haze_img_int8)
# for i in range(3):
#     array[i] = [hex(j)[2:].zfill(2) for j in haze_img_int8[i]]
# input_buffer = []
# for j in range(640*480):
#     new_array = array[0][j] + array[1][j] + array[2][j]
#     new_array = int(new_array,16)
#     input_buffer.append(new_array)
# print(input_buffer)
# in_buffer = []
# in_buffer[:] = np.array(input_buffer)
# print(in_buffer)

img_path="./test/img/OTS_2987.jpg"#输入图片
img = cv2.imread(img_path)
frame = cv2.resize(img,(640,480))

newframe = (np.asarray(frame[:,:,[2,1,0]]))
newframe = (newframe - 128).astype(np.uint8)
newframe = newframe.reshape(307200,3)
buffer = []
# buffer = np.asarray(buffer)
for i in range(307200):
    buffer.append(newframe[i][0]*16*16*16*16 + newframe[i][1]*16*16 +newframe[i][2])
print(hex(buffer[0]))
