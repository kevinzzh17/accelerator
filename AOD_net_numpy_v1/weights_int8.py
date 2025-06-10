import numpy as np

def dequantization(x_q, s, z):
    """解量化函数"""
    # x_q - z might go outside the quantization range.
    x_q = x_q.transpose(2,3,1,0).astype(np.int32)
    # print(f"dequantization x_q.shape:{x_q.shape}")
    # print(f"dequantization s.shape:{s.shape}")
    # print(f"x_q:{x_q}")
    # print(f"s:{s}")
    x = s * (x_q - z)
    # print(f"x:{x}")
    # print(f"dequantization x.shape:{x.shape}")
    x = x.astype(np.float32).transpose(3,2,0,1)
    # print(f"x:{x}")
    # print(f"dequantization x.shape:{x.shape}")
    return x

def reshape(list_name,shape):
    array = np.array(list_name)
    array = np.reshape(array,shape)
    return array

#(Ch_out,k_h,k_w,Ch_in)
qw1_shape = (3,1,1,3)
qw2_shape = (3,3,3,3)
qw3_shape = (3,5,5,6)
qw4_shape = (3,7,7,9)
qw5_shape = (3,3,3,6)

weights_dir = './int8_parameters/weights/'

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

# #(Ch_out,K_h,K_w,Ch_in) --> (Ch_out,Ch_in,K_h,K_w)
# qw1 = qw1.transpose(0,3,2,1)
# qw2 = qw2.transpose(0,3,2,1)
# qw3 = qw3.transpose(0,3,2,1)
# qw4 = qw4.transpose(0,3,2,1)
# qw5 = qw5.transpose(0,3,2,1)
# qw6 = qw6.transpose(0,3,2,1)
# qw7 = qw7.transpose(0,3,2,1)
# qw8 = qw8.transpose(0,3,2,1)

# #(Ch_out,K_h,K_w,Ch_in) --> (K_h,K_w,Ch_in,Ch_out)
# qw1 = qw1.transpose(1,2,3,0)
# qw2 = qw2.transpose(1,2,3,0)
# qw3 = qw3.transpose(1,2,3,0)
# qw4 = qw4.transpose(1,2,3,0)
# qw5 = qw5.transpose(1,2,3,0)
# qw6 = qw6.transpose(1,2,3,0)
# qw7 = qw7.transpose(1,2,3,0)
# qw8 = qw8.transpose(1,2,3,0)


qw1 = qw1.astype(np.int8)
qw2 = qw2.astype(np.int8)
qw3 = qw3.astype(np.int8)
qw4 = qw4.astype(np.int8)
qw5 = qw5.astype(np.int8)

Sw1 = [0.006288085598498583 ,0.004491826519370079 ,0.00469192722812295 ]
Sw2 = [0.00966707430779934 ,0.003801078302785754 ,0.003929395694285631 ]
Sw3 = [0.008198302239179611 ,0.008749174885451794 ,0.031366948038339615 ]
Sw4 = [0.0154957240447402 ,0.004781006369739771 ,0.009031315334141254 ]
Sw5 = [0.0035095892380923033 ,0.00390960555523634 ,0.0036762028466910124 ]

conv_shape1 = (1,3)
conv_shape2 = (1,3)
conv_shape3 = (1,3)
conv_shape4 = (1,3)
conv_shape5 = (1,3)


Sw1 = np.array(Sw1)
Sw2 = np.array(Sw2)
Sw3 = np.array(Sw3)
Sw4 = np.array(Sw4)
Sw5 = np.array(Sw5)

Sw1 = reshape(Sw1,conv_shape1)
Sw2 = reshape(Sw2,conv_shape2)
Sw3 = reshape(Sw3,conv_shape3)
Sw4 = reshape(Sw4,conv_shape4)
Sw5 = reshape(Sw5,conv_shape5)

if __name__ == "__main__":
    #设置numpy打印策略
    np.set_printoptions(threshold=np.inf)
    # np.set_printoptions(precision=20, suppress=True, formatter={'float': '{:0.8e}'.format})
    file_path = "./int8_parameters/weights.txt"
    print(f"qw1:{qw1}")
    print(f"qw2:{qw2}")
    print(f"qw3:{qw3}")
    print(f"qw4:{qw4}")
    print(f"qw5:{qw5}")

    # print(f"qw1.shape:{qw1.shape}\t{qw1.shape[0]*qw1.shape[1]*qw1.shape[2]*qw1.shape[3]}")
    # print(f"qw2.shape:{qw2.shape}\t{qw2.shape[0]*qw2.shape[1]*qw2.shape[2]*qw2.shape[3]}")
    # print(f"qw3.shape:{qw3.shape}\t{qw3.shape[0]*qw3.shape[1]*qw3.shape[2]*qw3.shape[3]}")
    # print(f"qw4.shape:{qw4.shape}\t{qw4.shape[0]*qw4.shape[1]*qw4.shape[2]*qw4.shape[3]}")
    # print(f"qw5.shape:{qw5.shape}\t{qw5.shape[0]*qw5.shape[1]*qw5.shape[2]*qw5.shape[3]}")

    # print(f"Sw1:{Sw1}")
    # print(f"Sw1.shape:{Sw1.shape}")
    # print(f"Sw2:{Sw2}")
    # print(f"Sw3:{Sw3}")
    # print(f"Sw4:{Sw4}")
    # print(f"Sw5:{Sw5}")
    # dqw1 = dequantization(qw1, Sw1, np.array([0,0,0]))
    # print(f"dqw1:{dqw1}")
    # print(f"dqw1.shape:{dqw1.shape}")
    # dqw2 = dequantization(qw2, Sw2, np.array([0,0,0]))
    # print(f"dqw2:{dqw2}")
    # print(f"dqw2.shape:{dqw2.shape}")
    # dqw3 = dequantization(qw3, Sw3, np.array([0,0,0]))
    # print(f"dqw3:{dqw3}")
    # print(f"dqw3.shape:{dqw3.shape}")
    # dqw4 = dequantization(qw4, Sw4, np.array([0,0,0]))
    # print(f"dqw4:{dqw4}")
    # print(f"dqw4.shape:{dqw4.shape}")
    # dqw5 = dequantization(qw5, Sw5, np.array([0,0,0]))
    # print(f"dqw5:{dqw5}")
    # print(f"dqw5.shape:{dqw5.shape}")
    
    # with open(file_path,"w+")as f:
    #     f.write(f"qw1:\n{qw1}\n\n")
    #     f.write(f"qw2:\n{qw2}\n\n")
    #     f.write(f"qw3:\n{qw3}\n\n")
    #     f.write(f"qw4:\n{qw4}\n\n")
    #     f.write(f"qw5:\n{qw5}\n\n")
