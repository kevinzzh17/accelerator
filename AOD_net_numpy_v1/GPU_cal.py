import onnxruntime as ort
import numpy as np
from PIL import Image
import time
import cv2

device_name = 'cuda:0' # or 'cpu'
image_name = "OTS_2987.jpg"
image_path = "query_hazy_images/" + image_name
model_path = "INT8_model\pruning_AOD_model_INT8.onnx"
defogy_image_path = "./image_defoge/defogy_" + image_name
print(ort.get_device())

if device_name == 'cpu':
    providers = ['CPUExecutionProvider']
elif device_name == 'cuda:0':
    providers = ['CUDAExecutionProvider', 'CPUExecutionProvider']
# Create inference session
onnx_model = ort.InferenceSession(model_path, providers=providers)

def preprocess(image_new):
    img = image_new.resize((640, 480))
    image = np.array(img).astype(np.float32)/255.0
    image = np.expand_dims(image, axis=0)
    image = np.transpose(image, (0, 3, 1, 2))
    return image , img

def postprocess(output_data):
    output_image = np.squeeze(output_data, axis=(0,1))
    # print(output_image.shape)
    output_image = np.transpose(output_image, (1, 2, 0))
    output_image = output_image * 255.0
    output_image = output_image.astype(np.uint8)
    return output_image

def inference_image(image_path):
    frame = Image.open(image_path)
    cv2.namedWindow("frame", 0)
    processed_frame , img = preprocess(frame)
    # print(processed_frame.shape)
    onnx_input = {onnx_model.get_inputs()[0].name: processed_frame}
    # Test model on input data
    # # 预热GPU
    # # 创建一个随机输入张量
    # input_tensor = np.random.random_sample(input_shape).astype(np.float32)
    # # print(input_tensor.shape)
    # input_tensor = np.expand_dims(input_tensor,axis=0)
    # input_name = {onnx_model.get_inputs()[0].name: input_tensor}
    # _ = onnx_model.run(None, input_name)
    
    start_time = time.time()
    outputs = onnx_model.run(None, onnx_input)
    end_time = time.time()
    result = postprocess(outputs)
    result = result[:,:,[2,1,0]] 
    result_out = np.zeros((480,1290,3), dtype=np.uint8)
    # 在中间添加分界标志
    result_out[:, 640:650,:] = 255  # 红色分界标志
    result_out[:,:640,:] = img
    result_out[:,:640,:] = result_out[:,:640,[2,1,0]] 
    result_out[:,650:,:] = result  
    # print(result)
    # cv2.putText(result_out, font , 1, (0, 255, 0), 2, cv2.LINE_AA)
    cv2.imwrite(defogy_image_path, result_out)
    inference_time = end_time - start_time
    print("inference_time:",inference_time)
    fps = 1/inference_time
    print("FPS:",fps)

inference_image(image_path)