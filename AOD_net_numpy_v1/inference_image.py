# @author: Kevin Cheung 
import onnxruntime as ort
import numpy as np
# import cv2 
from PIL import Image
# import win32gui
# import time
from skimage.metrics import peak_signal_noise_ratio as psnr
from skimage.metrics import structural_similarity as ssim
from skimage.metrics import mean_squared_error as mse
from tqdm import tqdm
import os

device_name = 'cuda:0' # or 'cpu'
print(ort.get_device())

if device_name == 'cpu':
    providers = ['CPUExecutionProvider']
elif device_name == 'cuda:0':
    providers = ['CUDAExecutionProvider', 'CPUExecutionProvider']
# Create inference session
model_path = "INT8_model\pruning_AOD_model_INT8.onnx"
onnx_model = ort.InferenceSession(model_path, providers=providers)


def image_preprocess(image_new):
    img = image_new.resize((640, 480))
    image = np.array(img).astype(np.float32)/255.0
    image = np.expand_dims(image, axis=0)
    image = np.transpose(image, (0, 3, 1, 2))
    return image

def image_postprocess(output_data):
    output_image = np.squeeze(output_data, axis=(0,1))
    # print(output_image.shape)
    output_image = np.transpose(output_image, (1, 2, 0))
    output_image = output_image * 255.0
    output_image = output_image.astype(np.uint8)
    return output_image

def image_haze_removel(input_image):
    hazy_image = image_preprocess(input_image)
    onnx_input = {onnx_model.get_inputs()[0].name: hazy_image}
    outputs = onnx_model.run(None, onnx_input)
    dehaze_image = image_postprocess(outputs)
    return dehaze_image

# image_name = "OTS_2987.jpg"
# input_image_path = "query_hazy_images/" + image_name
# haze_free_image_path = "original_image/" + image_name
# input_image = Image.open(input_image_path)

# output_image = image_haze_removel(input_image)
# # print(output_image)
# haze_free_image = Image.open(haze_free_image_path)
# haze_free_image = haze_free_image.resize((640, 480))
# haze_free_image = np.asarray(haze_free_image)
# # print(type(haze_free_image))
# print(output_image.shape)
# print(haze_free_image.shape)
# print(psnr(haze_free_image,output_image,data_range=255))
# print(ssim(haze_free_image,output_image,channel_axis=2,data_range=255))

# haze_img = Image.fromarray(np.uint8(output_image))
# haze_img.show()

img_indoor_path = '../Dehaze/test/indoor/gt/'
img_indoor_hazy_path = '../Dehaze/test/indoor/hazy/'
img_outdoor_path = '../Dehaze/test/outdoor/gt/'
img_outdoor_hazy_path = '../Dehaze/test/outdoor/hazy/'

path_free = img_indoor_path
path_haze = img_indoor_hazy_path

jpg_files = [f for f in os.listdir(path_free) if f.endswith(".jpg")]
psnr_all = 0
ssim_all = 0
mse_all = 0

for image_name in tqdm(jpg_files):

    input_image = Image.open(path_haze + image_name)
    haze_free_image = Image.open(path_free + image_name)

    output_image = image_haze_removel(input_image)
    haze_free_image = haze_free_image.resize((640,480))
    haze_free_image = np.asarray(haze_free_image).astype(np.uint8)

    # print(output_image.shape)
    # print(haze_free_image.shape)
    img_psnr = psnr(haze_free_image,output_image,data_range=255)
    img_ssim = ssim(haze_free_image,output_image,channel_axis=2,data_range=255,multichannel=True)
    img_mse = mse(haze_free_image,output_image)
    
    psnr_all = psnr_all + img_psnr
    ssim_all = ssim_all + img_ssim
    mse_all = mse_all + img_mse

    # print("psnr:{}".format(img_psnr))
    # print("ssim:{}".format(img_ssim))

psnr_average = psnr_all/50.0 
ssim_average = ssim_all/50.0
mse_average = mse_all/50.0

print("the average psnr:{}".format(psnr_average))
print("the average ssim:{}".format(ssim_average))
print("the average mse:{}".format(mse_average))