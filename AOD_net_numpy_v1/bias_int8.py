import numpy as np
def reshape(list_name,shape):
    array = np.array(list_name)
    array = np.reshape(array,shape)
    return array

bias_dir = './int8_parameters/bias/'

qb1 = np.load(bias_dir+'bias1.npy')
qb2 = np.load(bias_dir+'bias2.npy')
qb3 = np.load(bias_dir+'bias3.npy')
qb4 = np.load(bias_dir+'bias4.npy')
qb5 = np.load(bias_dir+'bias5.npy')

Sb1 = [0.00002465915895299986 ,0.000017615006072446704 ,0.000018399716282146983 ]
Sb2 = [0.000023620732463314198 ,0.000009287634384236299 ,0.000009601168130757287 ]
Sb3 = [0.000020031904568895698 ,0.000021377916709752753 ,0.00007664266013307497 ]
Sb4 = [0.000028182665118947625 ,0.000008695399628777523 ,0.00001642559982428793 ]
Sb5 = [0.0000062178864936868194 ,0.000006926589321665233 ,0.000006513073458336294 ]

qb1 = np.array(qb1)
qb2 = np.array(qb2)
qb3 = np.array(qb3)
qb4 = np.array(qb4)
qb5 = np.array(qb5)

Sb1 = np.array(Sb1)
Sb2 = np.array(Sb2)
Sb3 = np.array(Sb3)
Sb4 = np.array(Sb4)
Sb5 = np.array(Sb5)

b_conv_shape1 = (1,3)
b_conv_shape2 = (1,3)
b_conv_shape3 = (1,3)
b_conv_shape4 = (1,3)
b_conv_shape5 = (1,3)

Sb1 = reshape(Sb1,shape=b_conv_shape1)
Sb2 = reshape(Sb2,shape=b_conv_shape2)
Sb3 = reshape(Sb3,shape=b_conv_shape3)
Sb4 = reshape(Sb4,shape=b_conv_shape4)
Sb5 = reshape(Sb5,shape=b_conv_shape5)

qb1 = reshape(qb1,shape=b_conv_shape1)
qb2 = reshape(qb2,shape=b_conv_shape2)
qb3 = reshape(qb3,shape=b_conv_shape3)
qb4 = reshape(qb4,shape=b_conv_shape4)
qb5 = reshape(qb5,shape=b_conv_shape5)

if __name__ =="__main__":
    #设置numpy打印策略
    np.set_printoptions(threshold=np.inf)
    file_path = "./int8_parameters/bias.txt"

    print(f"qb1:{qb1}")
    print(f"qb2:{qb2}")
    print(f"qb3:{qb3}")
    print(f"qb4:{qb4}")
    print(f"qb5:{qb5}")

    # print(f"qb1.shape:{qb1.shape}")
    # print(f"qb2.shape:{qb2.shape}")
    # print(f"qb3.shape:{qb3.shape}")
    # print(f"qb4.shape:{qb4.shape}")
    # print(f"qb5.shape:{qb5.shape}")

    # print(f"dqb1:{Sb1*qb1}")
    # print(f"dqb2:{Sb2*qb2}")
    # print(f"dqb3:{Sb3*qb3}")
    # print(f"dqb4:{Sb4*qb4}")
    # print(f"dqb5:{Sb5*qb5}")

    # with open(file_path,"w+")as f:
    #     f.write(f"qb1:\n{qb1}\n\n")
    #     f.write(f"qb2:\n{qb2}\n\n")
    #     f.write(f"qb3:\n{qb3}\n\n")
    #     f.write(f"qb4:\n{qb4}\n\n")
    #     f.write(f"qb5:\n{qb5}\n\n")
