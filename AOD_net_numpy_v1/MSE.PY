import numpy as np

img_py_path = "./Buffer_test/Python_hex/conv5_out.txt"
img_dma_path = "./Buffer_test/pynq_dma_out_hex/conv5_out.txt"

def MSE(mat1,mat2):
    return np.sum(np.abs(mat1-mat2))/mat1.size #定义MSE函数用来衡量
def hex_to_decimal(hex_string):
    decimal_list = []
    for i in range(0, len(hex_string), 2):
        decimal_list.append(int(hex_string[i:i+2], 16))
    return decimal_list
img_py = []
img_dma = []

with open(img_py_path, 'r') as file:
    for line in file:
        hex_string = line.strip()
        decimal_list = hex_to_decimal(hex_string)
        img_py.append(decimal_list)
    img_py = np.array(img_py)
with open(img_dma_path, 'r') as file:
    for line in file:
        hex_string = line.strip()
        decimal_list = hex_to_decimal(hex_string)
        img_dma.append(decimal_list)
    img_dma = np.array(img_dma)
# print(img_dma)
# print(img_py)
# print(img_dma.size)
print(MSE(img_py,img_dma))