import onnxruntime as ort
import numpy as np
import cv2 
from PIL import Image
# import win32gui
import time

device_name = 'cuda:0' # or 'cpu'
video_name = "day.mp4"
video_path = "../Dehaze/video/" + video_name
model_path = "INT8_model\pruning_AOD_model_INT8.onnx"
defogy_video_path = "./video_defoge/defogy_" + video_name
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

def inference_video(video_path):
    cap = cv2.VideoCapture(video_path)
    frame_count = 0 # 用于计算帧数的变量
    font = cv2.FONT_HERSHEY_SIMPLEX  # 定义字体
    cv2.namedWindow("frame", 0)
    fps_best = 0
    fps_average = 0
    fps_all = 0
    counter = 0
    fps_low = 30
    start_time = time.time() #定义当前时间
    # fps = cap.get(cv2.CAP_PROP_FPS)
    # wait = int(1 / fps * 750)
    # 设置输出视频的参数
    # fourcc = cv2.VideoWriter_fourcc(*'mp4v')  # 其中*'MP4V'和 'M', 'P', '4', 'V'等效
    # out = cv2.VideoWriter(defogy_video_path, fourcc, 30.0, (1290, 480))
    # 预热GPU
    # 获取模型的输入形状
    input_shape = onnx_model.get_inputs()[0].shape[1:]
    # print(input_shape)
    # 创建一个随机输入张量
    input_tensor = np.random.random_sample(input_shape).astype(np.float32)
    # print(input_tensor.shape)
    input_tensor = np.expand_dims(input_tensor,axis=0)
    input_name = {onnx_model.get_inputs()[0].name: input_tensor}
    _ = onnx_model.run(None, input_name)

    while cap.isOpened():
        frame_count = 0
        ret, frame = cap.read()
        if not ret:
            break
        frame = Image.fromarray(frame)
        # print(frame)
        # 对视频帧进行预处理
        processed_frame, img = preprocess(frame)
        # Test model on input data
        onnx_input = {onnx_model.get_inputs()[0].name: processed_frame}

        start_time = time.time() #定义当前时间
        outputs = onnx_model.run(None, onnx_input)
        inferance_time = time.time() - start_time   ###该部分为测量模型推理时间

        # print(outputs)
        # 处理推理结果
        result = postprocess(outputs)
        result_out = np.zeros((480,1290,3), dtype=np.uint8)
        # 在中间添加分界标志
        result_out[:, 640:650,:] = 255  # 红色分界标志
        result_out[:,:640,:] = img
        result_out[:,650:,:] = result  
        frame_count = 1   
        counter += 1
        # inferance_time = time.time() - start_time
        fps_new = int(frame_count / inferance_time)
        fps_all += fps_new 
        cv2.putText(result_out, f"FPS: {fps_new}", (10, 30), font, 1, (0, 255, 0), 2, cv2.LINE_AA)
        # out.write(result_out)
        cv2.imshow("frame", result_out)
        if fps_new <fps_best:
            fps_best = fps_best
        else: 
            fps_best = fps_new
        if fps_new <fps_low:
            fps_low = fps_new
        else: 
            fps_low = fps_low
        start_time = time.time()
        frame_count = 0
        # waitKey指定每帧显示时长，单位为毫秒
        # if cv2.waitKey(wait) & 0xFF == ord('q') or not win32gui.FindWindow(None, 'frame'):
        #     break
        if cv2.waitKey(1) == ord('q'):
            break

    fps_average = fps_all/counter
    print("the highest fps:", fps_best)
    print("the lowest fps:", fps_low)
    print("the average fps:",fps_average)

    cap.release()
    # out.release()
    cv2.destroyAllWindows()

inference_video(video_path)