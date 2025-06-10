import cv2,math
# import numba
import numpy as np
from tqdm import tqdm
# def add_fog(frame):
#     foggy_frame = np.copy(frame)
#     height, width, _ = frame.shape
#     fog_density = 0.2  # 雾的密度，可以根据需要调整

#     for y in range(height):
#         for x in range(width):
#             fog = np.random.uniform(0, 255)
#             foggy_frame[y, x] = np.clip(frame[y, x] * (1 - fog_density) + fog_density * fog, 0, 255)

#     return foggy_frame

device_name = 'cuda:0' # or 'cpu'
video_name = "day.mp4"
video_path = "../Dehaze/video/" + video_name
fogy_video_path = "./video_haze/fogy_" + video_name
# @numba.jit(nopython=True)
def AddHaze3(frame):
	img_f = frame
	(row, col, chs) = frame.shape
	A = 0.5  # 亮度
	beta = 0.08  # 雾的浓度
	size = math.sqrt(max(row, col))  # 雾化尺寸
	center = (row // 2, col // 2)  # 雾化中心
	for j in tqdm(range(row)):
		for l in range(col):
			d = -0.04 * math.sqrt((j - center[0]) ** 2 + (l - center[1]) ** 2) + size
			td = math.exp(-beta * d)
			img_f[j][l][:] = img_f[j][l][:] * td + A * (1 - td)
	return img_f

# 打开输入视频文件
cap = cv2.VideoCapture(video_path)

# 获取视频的帧率、宽度和高度
fps = cap.get(cv2.CAP_PROP_FPS)
width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

# 创建VideoWriter对象，指定输出视频的编解码器和帧率
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
out = cv2.VideoWriter(fogy_video_path, fourcc, fps, (1936*2+10, 1088))

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break
    (row, col, chs) = frame.shape
    # 在每一帧上应用加雾处理
    foggy_frame = AddHaze3(frame)
    result_out = np.zeros((row,col*2+10,3), dtype=np.uint8)
    # 在中间添加分界标志
    result_out[:, col:col+10,:] = 255  # 红色分界标志
    result_out[:,:col,:] = frame
    result_out[:,col+10:,:] = foggy_frame  
    # cv2.putText(result_out, f"FPS: {fps_new}", (10, 30), font, 1, (0, 255, 0), 2, cv2.LINE_AA)
    out.write(result_out)
    # cv2.imshow("frame", result_out)

# 释放资源
cap.release()
out.release()
cv2.destroyAllWindows()