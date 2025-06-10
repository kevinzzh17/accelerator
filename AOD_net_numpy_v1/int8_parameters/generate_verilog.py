import numpy as np

def hex2dec(hex_num):
    """十六进制补码转十进制有符号数"""
    # print(f"hex_num:{hex_num}")
    dec_num = int(hex_num,16)
    if dec_num > 0x7f:#若十进制数大于127则-256
        dec_num -= 0x100
    # print(f"dec_num:{dec_num}")
    return dec_num


def dec2hex(decimal):
    # 将十进制数转换为二进制补码
    binary = bin(decimal & 0xFF)[2:].zfill(8) # 假设转换为8位十六进制补码

    # 将二进制补码转换为十六进制
    hex_value = hex(int(binary, 2))[2:].zfill(2)

    return hex_value


def weights_init_gen(qw,qw_shape):
    """
    qw：INT8权重
    qw_shape：(Ch_out,Ch_in,K_h,K_w)格式tuple
    """
    (Ch_out,Ch_in,K_h,K_w) = qw_shape
    cnt = 0
    for j in range(Ch_in):
        for i in range(Ch_out):
            print("W_RF[ {}] <= ".format(cnt),end='')
            print("{",end='')
            for k in range(K_h):
                for s in range(K_w):
                    num = qw[i][j][k][s]
                    print("8'h{},".format(dec2hex(num)),end='')

            print("};")
            cnt += 1



if __name__ == "__main__":
    weights_dir = './int8_parameters/weights/'
    save_path = './int8_parameters/weights_tb.txt'

    qw1 = np.load(weights_dir+'conv1.npy')
    qw2 = np.load(weights_dir+'conv2.npy')
    qw3 = np.load(weights_dir+'conv3.npy')
    qw4 = np.load(weights_dir+'conv4.npy')
    qw5 = np.load(weights_dir+'conv5.npy')

    qw1 = np.array(qw1)
    qw2 = np.array(qw2)
    qw3 = np.array(qw3)
    qw4 = np.array(qw4)
    qw5 = np.array(qw5)

    #(Ch_out,K_h,K_w,Ch_in) --> (Ch_out,Ch_in,K_h,K_w)
    qw1 = qw1.transpose(0,3,1,2)
    qw2 = qw2.transpose(0,3,1,2)
    qw3 = qw3.transpose(0,3,1,2)
    qw4 = qw4.transpose(0,3,1,2)
    qw5 = qw5.transpose(0,3,1,2)

    qw1_shape = qw1.shape
    qw2_shape = qw2.shape
    qw3_shape = qw3.shape
    qw4_shape = qw4.shape
    qw5_shape = qw5.shape

    print(f"qw1.shape:{qw1_shape}\t{qw1.shape[0]*qw1.shape[1]*qw1.shape[2]*qw1.shape[3]}")
    print(f"qw2.shape:{qw2_shape}\t{qw2.shape[0]*qw2.shape[1]*qw2.shape[2]*qw2.shape[3]}")
    print(f"qw3.shape:{qw3_shape}\t{qw3.shape[0]*qw3.shape[1]*qw3.shape[2]*qw3.shape[3]}")
    print(f"qw4.shape:{qw4_shape}\t{qw4.shape[0]*qw4.shape[1]*qw4.shape[2]*qw4.shape[3]}")
    print(f"qw5.shape:{qw5_shape}\t{qw5.shape[0]*qw5.shape[1]*qw5.shape[2]*qw5.shape[3]}")

    qw1 = qw1.tolist()
    qw2 = qw2.tolist()
    qw3 = qw3.tolist()
    qw4 = qw4.tolist()
    qw5 = qw5.tolist()

    weights_init_gen(qw1,qw1_shape)

