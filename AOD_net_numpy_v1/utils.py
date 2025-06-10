import numpy as np
import time
def quantization(x, s, z, alpha_q, beta_q):
    """量化函数"""
    x_q = np.round(1 / s * x + z, decimals=0)
    x_q = np.clip(x_q, a_min=alpha_q, a_max=beta_q)
    return x_q

def quantization_int8(x, s, z):
    """有符号INT8量化函数"""
    x_q = quantization(x, s, z, alpha_q=-128, beta_q=127)
    x_q = x_q.astype(np.int8)
    return x_q

def quantization_int32(x, s, z):
    """有符号INT32量化函数"""
    x_q = quantization(x, s, z, alpha_q=-2147483648, beta_q=2147483647)
    x_q = x_q.astype(np.int32)
    return x_q


def dequantization_weights(x_q, s, z):
    """解量化函数"""
    # x_q - z might go outside the quantization range.
    x_q = x_q.transpose(2,3,1,0).astype(np.int32)
    x = s * (x_q - z)
    x = x.astype(np.float32).transpose(3,2,0,1)
    return x

def dequantization(x_q, s, z):
    """解量化函数"""
    # x_q - z might go outside the quantization range.
    x_q = x_q.astype(np.int32)
    x = s * (x_q - z)
    x = x.astype(np.float32)
    return x

def generate_quantization_constants(alpha, beta, alpha_q, beta_q):
    """scale、zero_point产生函数"""
    # Affine quantization mapping
    s = (beta - alpha) / (beta_q - alpha_q)
    z = int((beta * alpha_q - alpha * beta_q) / (beta - alpha))
    return s, z

def generate_quantization_int8_constants(alpha, beta):
    """
    alpha:整个tensor的最小值
    beta:整个tensor的最大值
    """
    b = 8
    alpha_q = -2**(b - 1)
    beta_q = 2**(b - 1) - 1
    s, z = generate_quantization_constants(alpha=alpha,
                                           beta=beta,
                                           alpha_q=alpha_q,
                                           beta_q=beta_q)
    return s, z

def generate_quantization_int32_constants(alpha, beta):
    """
    alpha:整个tensor的最小值
    beta:整个tensor的最大值
    """
    b = 32
    alpha_q = -2**(b - 1)
    beta_q = 2**(b - 1) - 1
    s, z = generate_quantization_constants(alpha=alpha,
                                           beta=beta,
                                           alpha_q=alpha_q,
                                           beta_q=beta_q)
    return s, z


def quantization_matrix_multiplication_int8(Qx,Qw,Qb,Sx,Sw,Sb,Sy,Zy):
    """量化后矩阵乘法函数
    输入x、输出w为对称量化 因此Zx=Zw=0"""
    Qy = (Sx*Sw/Sy)*(np.matmul(Qx.astype(np.int32),Qw.astype(np.int32)))+(Sb/Sy)*(Qb.astype(np.int32))+Zy
    Qy = np.round(Qy,decimals=0)
    Qy = Qy.astype(np.int32)
    # print(f"Qy.dtype:{Qy.dtype}")
    # print(f"Qy:{Qy}")
    # print(f"Qy.dtype:{Qy.dtype}")
    return Qy

def quantization_matrix_multiplication_int8_img(Qx,Qw,Qb,Sx,Zx,Sw,Sb,Sy,Zy):
    """量化后矩阵乘法函数
    输入x、输出w为对称量化 因此Zx=Zw=0"""
    Qy = (Sx*Sw/Sy)*(np.matmul(Qx.astype(np.int32),Qw.astype(np.int32))- Zx * np.sum(Qw.astype(np.int32), axis=0, keepdims=True)) +(Sb/Sy)*(Qb.astype(np.int32))+Zy
    Qy = np.round(Qy,decimals=0)
    Qy = Qy.astype(np.int32)
    # print(f"Qy.dtype:{Qy.dtype}")
    # print(f"Qy:{Qy}")
    # print(f"Qy.dtype:{Qy.dtype}")
    return Qy

def quantization_matrix_multiplication_int8_fused(Qx,Qw,Qb,Sx,Zx,Sw,Sb,Sy,Zy):
    """量化后矩阵乘法函数
    输入x、输出w为对称量化 因此Zx=Zw=0"""
    N = 16
    M = np.round((Sx*Sw/Sy)*(2**N)).astype(np.int16)
    start = time.time()
    B = np.round((Sx*Sw/Sy)*(- Zx * np.sum(Qw.astype(np.int32), axis=0, keepdims=True)) +(Sb/Sy)*(Qb.astype(np.int32))+Zy).astype(np.int16)
    end = time.time()
    gap = end-start
    # print(f"M:{M}")
    # print(f"B:{B}")
    # Qy = M*(np.matmul(Qx.astype(np.int32),Qw.astype(np.int32)))/(2**N) + B
    Qy = (M*(np.matmul(Qx.astype(np.int32),Qw.astype(np.int32)))>>N) + B
    Qy = np.round(Qy,decimals=0)
    # Qy = np.trunc(Qy)
    Qy = Qy.astype(np.int32)
    # print(f"Qy.dtype:{Qy.dtype}")
    # print(f"Qy:{Qy}")
    # print(f"Qy.dtype:{Qy.dtype}")
    return Qy,gap

def quantization_matrix_multiplication_int8_int(Qx,Qw,Qb,A,B,Zx,Zy):
    """量化后矩阵乘法函数
    输入x、输出w为对称量化 因此Zx=Zw=0"""
    N = 16
    Qy = A*(np.matmul(Qx.astype(np.int32),Qw.astype(np.int32))/(2**N) - Zx * np.sum(Qw.astype(np.int32), axis=0, keepdims=True)) +B*(Qb.astype(np.int32))/(2**N)+Zy
    Qy = np.round(Qy,decimals=0)
    Qy = Qy.astype(np.int32)
    # print(f"Qy.dtype:{Qy.dtype}")
    # print(f"Qy:{Qy}")
    # print(f"Qy.dtype:{Qy.dtype}")
    return Qy

def quantization_matrix_multiplication_int8_z(X_q, W_q, s_X, z_X, s_W, z_W, s_Y, z_Y):
    """
    量化后矩阵乘法函数
    """
    p = W_q.shape[0]
    # Y_q_simulated is FP32
    Y_q_simulated = z_Y +((s_X*s_W/s_Y)*(np.matmul(X_q.astype(np.int32), W_q.astype(np.int32)) -
         z_W * np.sum(X_q.astype(np.int32), axis=1, keepdims=True) - 
         z_X * np.sum(W_q.astype(np.int32), axis=0, keepdims=True) + p*z_X*z_W))
    Y_q_simulated = np.round(Y_q_simulated, decimals=0)
    Y_q_simulated = Y_q_simulated.astype(np.int32)
    # Y_q_simulated = np.clip(Y_q_simulated, a_min=-128, a_max=127)
    # Y_q_simulated = Y_q_simulated.astype(np.int8)

    return Y_q_simulated

# def quantization_matrix_multiplication_int8_z(X_q, W_q, b_q, s_X, z_X, s_W, z_W,s_b, z_b, s_Y, z_Y):
#     """
#     量化后矩阵乘法函数
#     """
#     p = W_q.shape[0]
#     # Y_q_simulated is FP32
#     Y_q_simulated = (z_Y + (s_b/s_Y* (b_q.astype(np.int32) - z_b))+(
#         (s_X*s_W/s_Y)*(np.matmul(X_q.astype(np.int32), W_q.astype(np.int32)) -
#          z_W * np.sum(X_q.astype(np.int32), axis=1, keepdims=True) - 
#          z_X * np.sum(W_q.astype(np.int32), axis=0, keepdims=True) + p*z_X*z_W)))
#     Y_q_simulated = np.round(Y_q_simulated, decimals=0)
#     Y_q_simulated = Y_q_simulated.astype(np.int32)
#     # Y_q_simulated = np.clip(Y_q_simulated, a_min=-128, a_max=127)
#     # Y_q_simulated = Y_q_simulated.astype(np.int8)

#     return Y_q_simulated


def im2col(input_data, filter_h, filter_w, stride=1, pad=0):
    """
    Parameters
    ----------
    input_data : 由(数据量, 通道, 高, 长)的4维数组构成的输入数据
    filter_h : 卷积核的高
    filter_w : 卷积核的长
    stride : 步幅
    pad : 填充

    Returns
    -------
    col : 2维数组
    """
    # 输入数据的形状
    # N：批数目，C：通道数，H：输入数据高，W：输入数据长
    N, C, H, W = input_data.shape  
    out_h = (H + 2*pad - filter_h)//stride + 1  # 输出数据的高
    out_w = (W + 2*pad - filter_w)//stride + 1  # 输出数据的长
    # 填充 H,W
    img = np.pad(input_data, [(0,0), (0,0), (pad, pad), (pad, pad)], 'constant')
    # (N, C, filter_h, filter_w, out_h, out_w)的0矩阵
    col = np.zeros((N, C, filter_h, filter_w, out_h, out_w))
    
    for y in range(filter_h):
        y_max = y + stride*out_h
        for x in range(filter_w):
            x_max = x + stride*out_w
            col[:, :, y, x, :, :] = img[:, :, y:y_max:stride, x:x_max:stride]
    # 按(0, 4, 5, 1, 2, 3)顺序，交换col的列，然后改变形状
    col = col.transpose(0, 4, 5, 1, 2, 3).reshape(N*out_h*out_w, -1)
    return col

def q_mul_fun(qx1,Sx1,Zx1,qx2,Sx2,Zx2,Sy,Zy):
    N1 = 16
    M = np.round(Sx1*Sx2/Sy * 2**(N1)).astype(np.int16)
    # print(f"M:{M}")
    qy = np.trunc(np.trunc((M*((qx1.astype(np.int32)-Zx1)*(qx2.astype(np.int32)-Zx2)))>>N1)+Zy).astype(np.int8)
    return qy

def q_sub_fun(qx1,Sx1,Zx1,qx2,Sx2,Zx2,Sy,Zy):
    # print(f"qx1.dtype:{qx1.dtype}")
    # print(f"qx2.dtype:{qx2.dtype}")
    N3 = 14
    M1 = np.round(Sx1/Sy * 2**(N3)).astype(np.int16)
    M2 = np.round(-Sx2/Sy * 2**(N3)).astype(np.int16)
    # print(f"Sx1/Sy:{Sx1/Sy}")
    # print(f"Sx2/Sy:{Sx2/Sy}")
    B = np.round(Sx2/Sy*Zx2-Sx1/Sy*Zx1+Zy).astype(np.int16)
    # print(f"M1:{M1}")
    # print(f"M2:{M2}")
    # print(f"B:{B}")
    qy = np.trunc(np.trunc((M1*qx1.astype(np.int32)+M2*qx2.astype(np.int32))>>N3)+B).astype(np.int8)
    # qy = np.round((M1*qx1.astype(np.int32)/(2**(N3))+M2*qx2.astype(np.int32)/(2**(N3)))+B).astype(np.int8)
    return qy

def q_add_fun(qx,Sx,Zx,Sy,Zy):
    N3 = 14
    M = np.round(Sx/Sy * 2**(N3)).astype(np.int16)
    C = np.round((1-Sx*Zx)/Sy+Zy).astype(np.int16)
    # print(f"M:{M}")
    # print(f"C:{C}")
    qy = np.trunc(np.trunc((M*qx.astype(np.int32))>>N3)+C).astype(np.int8)
    return qy

def reshape(list_name,shape):
    array = np.array(list_name)
    array = np.reshape(array,shape)
    return array

def requantize(qx,Sx,Zx,Sy,Zy):
    N = 8
    M = np.round((Sx/Sy)*(2**N)).astype(np.int16)
    # print(f"M:{M}")
    # qy = M*(qx-Zx)/(2**N) + Zy
    qy = (M*(qx-Zx)>>N) + Zy
    qy = np.clip(qy, a_min=-128, a_max=127)
    # qy = np.round(qy).astype(np.int8)
    qy = np.trunc(qy).astype(np.int8)
    return qy

def requantize_1(qx,Sx,Zx,Sy,Zy):
    N = 16
    M = np.round((Sx/Sy)*(2**N)).astype(np.int32)
    qy = M*(qx-Zx)/(2**N) + Zy
    qy = np.clip(qy, a_min=-128, a_max=127)
    qy = np.round(qy).astype(np.int8)
    return qy

def MSE(mat1,mat2):
    return np.sum(np.abs(mat1-mat2))/mat1.size

if __name__ == "__main__":
    # a = [
    #     6.751524209976196289e-01 ,
    #     7.064647078514099121e-01,
    #     -1.499899774789810181e-01,
    #     -1.480513811111450195e-01,
    #     -2.390457838773727417e-01,
    #     -5.846126079559326172e-01,
    #     -5.869399309158325195e-01,
    #     -2.433290034532546997e-01,
    #     9.919576048851013184e-01
    # ]

    # shape = (1, 1, 3, 3)

    # print(reshape(a,shape))
    Sx = 0.0035222142469137907 
    Sy = 0.00252942880615592 
    Zx = -128
    Zy = -128

    np.set_printoptions(threshold=np.inf)
    qx = np.random.randint(low = -128,high = 127, size = [1,3,16,24],dtype= np.int8)
    print(f"qx:\n{qx}")
    dqx = dequantization(qx,Sx,Zx)
    print(f"dqx:\n{dqx}")

    q_concat1 = quantization_int8(dqx,Sy,Zy)
    q_concat2 = requantize(qx,Sx,Zx,Sy,Zy)
    print(f"q_concat1:\n{q_concat1}")
    print(f"q_concat2:\n{q_concat2}")
    print(f"MSE(q_concat1,q_concat2):{MSE(q_concat1,q_concat2)}")
    
-2.6330193349041414278178756016644