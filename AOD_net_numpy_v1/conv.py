import numpy as np
from utils import im2col,quantization_matrix_multiplication_int8,quantization_matrix_multiplication_int8_img,quantization_matrix_multiplication_int8_z
from utils import quantization_matrix_multiplication_int8_int,quantization_matrix_multiplication_int8_fused
import time

def conv2d(input, weight, bias, filter_shape, stride=1, padding='SAME'):
    """filter_shape=(output_channel,input_channel,filter_size)
                      输出通道数      输入通道数     卷积核大小"""
    output_channel = filter_shape[0]   # 输出通道数
    input_channel = filter_shape[1]    # 输入通道数
    filter_size = filter_shape[2]  # 卷积核大小
    # 第一步边缘填充
    if padding == "VALID":
        x = input
    if padding == "SAME":
        p = filter_size // 2
        x = np.lib.pad(input, ((0,0),(0,0),(p,p),(p,p)), "constant")
    # 第二步处理输入的宽高不能恰好的被卷积核的大小和选定的步长所整除
    x_fit = (x.shape[2] - filter_size) % stride
    y_fit = (x.shape[3] - filter_size) % stride

    if stride > 1:
        if x_fit != 0:
            x = x[:, :, 0:x.shape[2] - x_fit, :]
        if y_fit != 0:
            x = x[:, :, :, 0:x.shape[3] - y_fit]
    
    N, _, H, W = x.shape
    O ,C ,K, K= weight.shape
    weight_cols = weight.reshape(O, -1).T
    # print(f"weight_cols.shape:{weight_cols.shape}")
    # print(f"weight_cols:{weight_cols}")
    x_cols = im2col(x, filter_size, filter_size, stride)
    # print(f"x_cols.shape:{x_cols.shape}")
    # print(f"x_cols:{x_cols}")
    # print(f"bias.shape:{bias.shape}")
    # print(f"bias:{bias}")
    result = np.dot(x_cols, weight_cols) + bias
    output_H, output_W = (H-filter_size)//stride + 1, (W-filter_size)//stride + 1
    result = result.reshape((N, result.shape[0]//N, -1)).reshape((N, output_H, output_W, O))
    #(NHWC)-->(NCHW)
    return result.transpose((0, 3, 1, 2))


def Q_conv2d(Qx,Qw,Qb,Sx,Sw,Sb,Sy,Zy,filter_shape,stride=1,padding='SAME'):
    output_channel = filter_shape[0]   # 输出通道数
    input_channel = filter_shape[1]    # 输入通道数
    filter_size = filter_shape[2]  # 卷积核大小
    # 第一步边缘填充
    if padding == "VALID":
        x = Qx
    if padding == "SAME":
        p = filter_size // 2
        x = np.lib.pad(Qx, ((0,0),(0,0),(p,p),(p,p)), "constant")
    # 第二步处理输入的宽高不能恰好的被卷积核的大小和选定的步长所整除
    x_fit = (x.shape[2] - filter_size) % stride
    y_fit = (x.shape[3] - filter_size) % stride

    if stride > 1:
        if x_fit != 0:
            x = x[:, :, 0:x.shape[2] - x_fit, :]
        if y_fit != 0:
            x = x[:, :, :, 0:x.shape[3] - y_fit]
    
    N, _, H, W = x.shape
    O ,C ,K, K = Qw.shape
    Qw_cols = Qw.reshape(O, -1).T
    # print(f"Qw_cols.shape:{Qw_cols.shape}")
    # print(f"Qw_cols:{Qw_cols}")
    Qx_cols = im2col(x, filter_size, filter_size, stride)
    # print(f"Qx_cols.shape:{Qx_cols.shape}")
    # print(f"Qx_cols:{Qx_cols}")
    result = quantization_matrix_multiplication_int8(Qx_cols,Qw_cols,Qb,Sx,Sw,Sb,Sy,Zy)
    output_H, output_W = (H-filter_size)//stride + 1, (W-filter_size)//stride + 1
    result = result.reshape((N, result.shape[0]//N, -1)).reshape((N, output_H, output_W, O))
    return result.transpose((0, 3, 1, 2))


def Q_conv2d_img(Qx,Qw,Qb,Sx,Zx,Sw,Sb,Sy,Zy,filter_shape,stride=1,padding='SAME'):
    """第一层输入图片的卷积计算函数"""
    output_channel = filter_shape[0]   # 输出通道数
    input_channel = filter_shape[1]    # 输入通道数
    filter_size = filter_shape[2]  # 卷积核大小
    # 第一步边缘填充
    if padding == "VALID":
        x = Qx
    if padding == "SAME":
        p = filter_size // 2
        x = np.lib.pad(Qx, ((0,0),(0,0),(p,p),(p,p)), "constant")
    # 第二步处理输入的宽高不能恰好的被卷积核的大小和选定的步长所整除
    x_fit = (x.shape[2] - filter_size) % stride
    y_fit = (x.shape[3] - filter_size) % stride

    if stride > 1:
        if x_fit != 0:
            x = x[:, :, 0:x.shape[2] - x_fit, :]
        if y_fit != 0:
            x = x[:, :, :, 0:x.shape[3] - y_fit]
    
    N, _, H, W = x.shape
    O ,C ,K, K = Qw.shape
    Qw_cols = Qw.reshape(O, -1).T
    # print(f"Qw_cols.shape:{Qw_cols.shape}")
    # print(f"Qw_cols:{Qw_cols}")
    Qx_cols = im2col(x, filter_size, filter_size, stride)
    # print(f"Qx_cols.shape:{Qx_cols.shape}")
    # print(f"Qx_cols:{Qx_cols}")
    result = quantization_matrix_multiplication_int8_img(Qx_cols,Qw_cols,Qb,Sx,Zx,Sw,Sb,Sy,Zy)
    output_H, output_W = (H-filter_size)//stride + 1, (W-filter_size)//stride + 1
    result = result.reshape((N, result.shape[0]//N, -1)).reshape((N, output_H, output_W, O))
    return result.transpose((0, 3, 1, 2))

def Q_conv2d_fused(Qx,Qw,Qb,Sx,Zx,Sw,Sb,Sy,Zy,filter_shape,stride=1,padding='SAME',const_num = 0):
    """第一层输入图片的卷积计算函数"""
    output_channel = filter_shape[0]   # 输出通道数
    input_channel = filter_shape[1]    # 输入通道数
    filter_size = filter_shape[2]  # 卷积核大小
    # 第一步边缘填充
    if padding == "VALID":
        x = Qx
    if padding == "SAME":
        p = filter_size // 2
        x = np.lib.pad(Qx, ((0,0),(0,0),(p,p),(p,p)), "constant", constant_values= const_num)
    # 第二步处理输入的宽高不能恰好的被卷积核的大小和选定的步长所整除
    x_fit = (x.shape[2] - filter_size) % stride
    y_fit = (x.shape[3] - filter_size) % stride

    if stride > 1:
        if x_fit != 0:
            x = x[:, :, 0:x.shape[2] - x_fit, :]
        if y_fit != 0:
            x = x[:, :, :, 0:x.shape[3] - y_fit]
    
    N, _, H, W = x.shape
    O ,C ,K, K = Qw.shape
    Qw_cols = Qw.reshape(O, -1).T
    # print(f"Qw_cols.shape:{Qw_cols.shape}")
    # print(f"Qw_cols:{Qw_cols}")
    Qx_cols = im2col(x, filter_size, filter_size, stride)
    # print(f"Qx_cols.shape:{Qx_cols.shape}")
    # print(f"Qx_cols:{Qx_cols}")
    # start_time = time.time()
    result,time_gap = quantization_matrix_multiplication_int8_fused(Qx_cols,Qw_cols,Qb,Sx,Zx,Sw,Sb,Sy,Zy)
    # end_time = time.time()
    output_H, output_W = (H-filter_size)//stride + 1, (W-filter_size)//stride + 1
    result = result.reshape((N, result.shape[0]//N, -1)).reshape((N, output_H, output_W, O))
    # time_gap = end_time - start_time
    return result.transpose((0, 3, 1, 2))

def Q_conv2d_int(Qx,Qw,Qb,A,B,Zx,Zy,filter_shape,stride=1,padding='SAME'):
    """第一层输入图片的卷积计算函数"""
    output_channel = filter_shape[0]   # 输出通道数
    input_channel = filter_shape[1]    # 输入通道数
    filter_size = filter_shape[2]  # 卷积核大小
    # 第一步边缘填充
    if padding == "VALID":
        x = Qx
    if padding == "SAME":
        p = filter_size // 2
        x = np.lib.pad(Qx, ((0,0),(0,0),(p,p),(p,p)), "constant")
    # 第二步处理输入的宽高不能恰好的被卷积核的大小和选定的步长所整除
    x_fit = (x.shape[2] - filter_size) % stride
    y_fit = (x.shape[3] - filter_size) % stride

    if stride > 1:
        if x_fit != 0:
            x = x[:, :, 0:x.shape[2] - x_fit, :]
        if y_fit != 0:
            x = x[:, :, :, 0:x.shape[3] - y_fit]
    
    N, _, H, W = x.shape
    O ,C ,K, K = Qw.shape
    Qw_cols = Qw.reshape(O, -1).T
    # print(f"Qw_cols.shape:{Qw_cols.shape}")
    # print(f"Qw_cols:{Qw_cols}")
    Qx_cols = im2col(x, filter_size, filter_size, stride)
    # print(f"Qx_cols.shape:{Qx_cols.shape}")
    # print(f"Qx_cols:{Qx_cols}")
    result = quantization_matrix_multiplication_int8_int(Qx_cols,Qw_cols,Qb,A,B,Zx,Zy)
    output_H, output_W = (H-filter_size)//stride + 1, (W-filter_size)//stride + 1
    result = result.reshape((N, result.shape[0]//N, -1)).reshape((N, output_H, output_W, O))
    return result.transpose((0, 3, 1, 2))


def Q_conv2d_z(Qx,Qw,Qb,Sx,Zx,Sw,Zw,Sb,Zb,Sy,Zy,filter_shape,stride=1,padding='SAME'):
    output_channel = filter_shape[0]   # 输出通道数
    input_channel = filter_shape[1]    # 输入通道数
    filter_size = filter_shape[2]  # 卷积核大小
    # 第一步边缘填充
    if padding == "VALID":
        x = Qx
    if padding == "SAME":
        p = filter_size // 2
        x = np.lib.pad(Qx, ((0,0),(0,0),(p,p),(p,p)), "constant")
    # 第二步处理输入的宽高不能恰好的被卷积核的大小和选定的步长所整除
    x_fit = (x.shape[2] - filter_size) % stride
    y_fit = (x.shape[3] - filter_size) % stride

    if stride > 1:
        if x_fit != 0:
            x = x[:, :, 0:x.shape[2] - x_fit, :]
        if y_fit != 0:
            x = x[:, :, :, 0:x.shape[3] - y_fit]
    
    N, _, H, W = x.shape
    O ,C ,K, K = Qw.shape
    Qw_cols = Qw.reshape(O, -1).T
    Qx_cols = im2col(x, filter_size, filter_size, stride)
    result = quantization_matrix_multiplication_int8_z(Qx_cols,Qw_cols,Qb,Sx,Zx,Sw,Zw,Sb,Zb,Sy,Zy)
    #X_q, W_q, b_q, s_X, z_X, s_W, z_W,s_b, z_b, s_Y, z_Y
    output_H, output_W = (H-filter_size)//stride + 1, (W-filter_size)//stride + 1
    result = result.reshape((N, result.shape[0]//N, -1)).reshape((N, output_H, output_W, O))
    return result.transpose((0, 3, 1, 2))



if __name__ == "__main__":
    filter_shape = (6,3,5,5)
    stride=1
    padding='SAME'

    inputs = np.random.randn(1,3,640,480)
    weight = np.random.randn(6,3,5,5)
    bias = np.random.randn(1,6)

    conv = conv2d(inputs,weight,bias,filter_shape=filter_shape,stride=stride,padding=padding)

    print(f"inputs:\n{inputs}")
    print(f"weight:\n{weight}")
    print(f"bias:\n{bias}")
    print(f"conv:\n{conv}")
    # print(f"conv_ref:\n{conv_ref}")
    print(f"inputs.shape:\n{inputs.shape}")
    print(f"weight.shape:\n{weight.shape}")
    print(f"bias.shape:\n{bias.shape}")
    print(f"conv.shape:\n{conv.shape}")
    # print(f"conv_ref.shape:\n{conv_ref.shape}")

    # conv_ref = np.convolve()

