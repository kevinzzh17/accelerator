import numpy as np

def reshape(list_name,shape):
    array = np.array(list_name)
    array = np.reshape(array,shape)
    return array

def intToBin(number,index=8,feature=True):
    """index为该数据位宽,number为待转换数据,
    feature为True则进行十进制转二进制，为False则进行二进制转十进制。"""
    if (feature==True):#十进制转换为二进制
        if(number>=0):
            b=bin(number)
            b = '0' * (index+2 - len(b)) + b
        else:
            b=2**(index)+number
            b=bin(b)
            b = '1' * (index+2 - len(b)) + b    #注意这里算出来的结果是补码
        b=b.replace("0b",'')
        b=b.replace('-','')
        return b

    elif(feature==False):#二进制转换为十进制
        i=int(str(number),2)
        if(i>=2**(index-1)):#如果是负数
            i=-(2**index-i)
            return i
        else:
            return i

bias_dir = './int8_parameters/bias/'

qb1 = np.load(bias_dir+'bias1.npy')
qb2 = np.load(bias_dir+'bias2.npy')
qb3 = np.load(bias_dir+'bias3.npy')
qb4 = np.load(bias_dir+'bias4.npy')
qb5 = np.load(bias_dir+'bias5.npy')
qb6 = np.load(bias_dir+'bias6.npy')
qb7 = np.load(bias_dir+'bias7.npy')
qb8 = np.load(bias_dir+'bias8.npy')

b_conv_shape1 = (1,3)
b_conv_shape2 = (1,3)
b_conv_shape3 = (1,3)
b_conv_shape4 = (1,6)
b_conv_shape5 = (1,6)
b_conv_shape6 = (1,6)
b_conv_shape7 = (1,6)
b_conv_shape8 = (1,3)

qb1 = reshape(qb1,shape=b_conv_shape1)
qb2 = reshape(qb2,shape=b_conv_shape2)
qb3 = reshape(qb3,shape=b_conv_shape3)
qb4 = reshape(qb4,shape=b_conv_shape4)
qb5 = reshape(qb5,shape=b_conv_shape5)
qb6 = reshape(qb6,shape=b_conv_shape6)
qb7 = reshape(qb7,shape=b_conv_shape7)
qb8 = reshape(qb8,shape=b_conv_shape8)

qb1 = qb1.astype(np.int8)
qb2 = qb2.astype(np.int8)
qb3 = qb3.astype(np.int8)
qb4 = qb4.astype(np.int8)
qb5 = qb5.astype(np.int8)
qb6 = qb6.astype(np.int8)
qb7 = qb7.astype(np.int8)
qb8 = qb8.astype(np.int8)

print(qb1)
print(qb2)
print(qb3)
print(qb4)
print(qb5)
print(qb6)
print(qb7)
print(qb8)

qb1 = qb1.tolist()
qb2 = qb2.tolist()
qb3 = qb3.tolist()
qb4 = qb4.tolist()
qb5 = qb5.tolist()
qb6 = qb6.tolist()
qb7 = qb7.tolist()
qb8 = qb8.tolist()

bin_qb1 = []
bin_qb2 = []
bin_qb3 = []
bin_qb4 = []
bin_qb5 = []
bin_qb6 = []
bin_qb7 = []
bin_qb8 = []

for i in qb1:
    for j in i:
        bin_qb1.append(intToBin(j))
for i in qb2:
    for j in i:
        bin_qb2.append(intToBin(j))
for i in qb3:
    for j in i:
        bin_qb3.append(intToBin(j))
for i in qb4:
    for j in i:
        bin_qb4.append(intToBin(j))
for i in qb5:
    for j in i:
        bin_qb5.append(intToBin(j))
for i in qb6:
    for j in i:
        bin_qb6.append(intToBin(j))
for i in qb7:
    for j in i:
        bin_qb7.append(intToBin(j))
for i in qb8:
    for j in i:
        bin_qb8.append(intToBin(j))

print(bin_qb1)
print(bin_qb2)
print(bin_qb3)
print(bin_qb4)
print(bin_qb5)
print(bin_qb6)
print(bin_qb7)
print(bin_qb8)

file_path = './dec2bin/bin_bias.txt'
with open(file_path,'w+') as f:
    f.write("Bias1:\n")
    f.write(str(bin_qb1))
    f.write("\nBias2:\n")
    f.write(str(bin_qb2))
    f.write("\nBias3:\n")
    f.write(str(bin_qb3))
    f.write("\nBias4:\n")
    f.write(str(bin_qb4))
    f.write("\nBias5:\n")
    f.write(str(bin_qb5))
    f.write("\nBias6:\n")
    f.write(str(bin_qb6))
    f.write("\nBias7:\n")
    f.write(str(bin_qb7))
    f.write("\nBias8:\n")
    f.write(str(bin_qb8))

file_path = './dec2bin/dec_bias.txt'
with open(file_path,'w+') as f:
    f.write("Bias1:\n")
    f.write(str(qb1))
    f.write("\nBias2:\n")
    f.write(str(qb2))
    f.write("\nBias3:\n")
    f.write(str(qb3))
    f.write("\nBias4:\n")
    f.write(str(qb4))
    f.write("\nBias5:\n")
    f.write(str(qb5))
    f.write("\nBias6:\n")
    f.write(str(qb6))
    f.write("\nBias7:\n")
    f.write(str(qb7))
    f.write("\nBias8:\n")
    f.write(str(qb8))