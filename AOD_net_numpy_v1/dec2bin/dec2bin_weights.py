import numpy as np

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

weights_dir = './int8_parameters/weights/'

qw1 = np.load(weights_dir+'conv1.npy')
qw2 = np.load(weights_dir+'conv2.npy')
qw3 = np.load(weights_dir+'conv3.npy')
qw4 = np.load(weights_dir+'conv4.npy')
qw5 = np.load(weights_dir+'conv5.npy')
qw6 = np.load(weights_dir+'conv6.npy')
qw7 = np.load(weights_dir+'conv7.npy')
qw8 = np.load(weights_dir+'conv8.npy')

qw1 = qw1.transpose(0,3,1,2)
qw2 = qw2.transpose(0,3,1,2)
qw3 = qw3.transpose(0,3,1,2)
qw4 = qw4.transpose(0,3,1,2)
qw5 = qw5.transpose(0,3,1,2)
qw6 = qw6.transpose(0,3,1,2)
qw7 = qw7.transpose(0,3,1,2)
qw8 = qw8.transpose(0,3,1,2)

qw1 = qw1.astype(np.int8)
qw2 = qw2.astype(np.int8)
qw3 = qw3.astype(np.int8)
qw4 = qw4.astype(np.int8)
qw5 = qw5.astype(np.int8)
qw6 = qw6.astype(np.int8)
qw7 = qw7.astype(np.int8)
qw8 = qw8.astype(np.int8)

print(qw1)
print(qw2)
print(qw3)
print(qw4)
print(qw5)
print(qw6)
print(qw7)
print(qw8)

qw1 = qw1.tolist()
qw2 = qw2.tolist()
qw3 = qw3.tolist()
qw4 = qw4.tolist()
qw5 = qw5.tolist()
qw6 = qw6.tolist()
qw7 = qw7.tolist()
qw8 = qw8.tolist()

bin_qw1 = []
bin_qw2 = []
bin_qw3 = []
bin_qw4 = []
bin_qw5 = []
bin_qw6 = []
bin_qw7 = []
bin_qw8 = []

for i in qw1:
    for j in i:
        for k in j:
            for t in k:
                bin_qw1.append(intToBin(t))
for i in qw2:
    for j in i:
        for k in j:
            for t in k:
                bin_qw2.append(intToBin(t))
for i in qw3:
    for j in i:
        for k in j:
            for t in k:
                bin_qw3.append(intToBin(t))
for i in qw4:
    for j in i:
        for k in j:
            for t in k:
                bin_qw4.append(intToBin(t))
for i in qw5:
    for j in i:
        for k in j:
            for t in k:
                bin_qw5.append(intToBin(t))
for i in qw6:
    for j in i:
        for k in j:
            for t in k:
                bin_qw6.append(intToBin(t))
for i in qw7:
    for j in i:
        for k in j:
            for t in k:
                bin_qw7.append(intToBin(t))
for i in qw8:
    for j in i:
        for k in j:
            for t in k:
                bin_qw8.append(intToBin(t))

# qw1.shape:(3, 3, 1, 1)
# qw2.shape:(3, 3, 3, 3)
# qw3.shape:(3, 3, 5, 5)
# qw4.shape:(6, 6, 7, 7)
# qw5.shape:(6, 6, 3, 3)
# qw6.shape:(6, 6, 3, 3)
# qw7.shape:(6, 12, 3, 3)
# qw8.shape:(3, 15, 3, 3)
bin_qw1 = np.array(bin_qw1)
bin_qw2 = np.array(bin_qw2)
bin_qw3 = np.array(bin_qw3)
bin_qw4 = np.array(bin_qw4)
bin_qw5 = np.array(bin_qw5)
bin_qw6 = np.array(bin_qw6)
bin_qw7 = np.array(bin_qw7)
bin_qw8 = np.array(bin_qw8)

bin_qw1 = bin_qw1.reshape(3, 3, 1, 1)
bin_qw2 = bin_qw2.reshape(3, 3, 3, 3)
bin_qw3 = bin_qw3.reshape(3, 3, 5, 5)
bin_qw4 = bin_qw4.reshape(6, 6, 7, 7)
bin_qw5 = bin_qw5.reshape(6, 6, 3, 3)
bin_qw6 = bin_qw6.reshape(6, 6, 3, 3)
bin_qw7 = bin_qw7.reshape(6, 12, 3, 3)
bin_qw8 = bin_qw8.reshape(3, 15, 3, 3)

# print(bin_qw1)
# print(bin_qw2)
# print(bin_qw3)
# print(bin_qw4)
# print(bin_qw5)
# print(bin_qw6)
# print(bin_qw7)
# print(bin_qw8)

bin_qw1 = bin_qw1.tolist()
bin_qw2 = bin_qw2.tolist()
bin_qw3 = bin_qw3.tolist()
bin_qw4 = bin_qw4.tolist()
bin_qw5 = bin_qw5.tolist()
bin_qw6 = bin_qw6.tolist()
bin_qw7 = bin_qw7.tolist()
bin_qw8 = bin_qw8.tolist()

#二进制数写入文件
file_path = './dec2bin/bin_weights.txt'
with open(file_path,'w+') as f:
    f.write("Conv1:\n")
    f.write(str(bin_qw1))
    f.write("\nConv2:\n")
    f.write(str(bin_qw2))
    f.write("\nConv3:\n")
    f.write(str(bin_qw3))
    f.write("\nConv4:\n")
    f.write(str(bin_qw4))
    f.write("\nConv5:\n")
    f.write(str(bin_qw5))
    f.write("\nConv6:\n")
    f.write(str(bin_qw6))
    f.write("\nConv7:\n")
    f.write(str(bin_qw7))
    f.write("\nConv8:\n")
    f.write(str(bin_qw8))

#十进制数写入文件
file_path = './dec2bin/dec_weights.txt'
with open(file_path,'w+') as f:
    f.write("Conv1:\n")
    f.write(str(qw1))
    f.write("\nConv2:\n")
    f.write(str(qw2))
    f.write("\nConv3:\n")
    f.write(str(qw3))
    f.write("\nConv4:\n")
    f.write(str(qw4))
    f.write("\nConv5:\n")
    f.write(str(qw5))
    f.write("\nConv6:\n")
    f.write(str(qw6))
    f.write("\nConv7:\n")
    f.write(str(qw7))
    f.write("\nConv8:\n")
    f.write(str(qw8))