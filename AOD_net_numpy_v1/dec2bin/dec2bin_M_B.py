import numpy as np

def reshape(list_name,shape):
    array = np.array(list_name)
    array = np.reshape(array,shape)
    return array

def intToBin(number,index=16,feature=True):
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
        
M1=[[658, 575 ,406]]
M2=[[470, 361 ,535]]
M3=[[ 91,  76 ,173]]
M4=[[159,  48 , 70 , 92, 128 ,287]]
M5=[[675, 344 ,526 ,259 ,648 ,779]]
M6=[[554,  194, 1050 , 752 , 265 , 954]]
M7=[[570,  481, 1119 , 825 , 988 ,1017]]
M8=[[35 ,31 ,26]]

C1=1263
C2=339
C3=5117
C4=4698
mul=324
sub1=18900
sub2=-23859
add=21906
B_sub=88
B_add=-43

B1=[[-83 ,-91 ,-61]]
B2=[[ -96  , 10 ,-143]]
B3=[[ 218 , -89 ,-799]]
B4=[[-357 ,-315,  -75  ,386 ,-292 ,-110]]
B5=[[-557 ,-234 , 112 ,-164 ,-665 ,-604]]
B6=[[1  ,-245 , -898 , -723 , -131 ,-1919]]
B7=[[43  , 966 , -386  , 870 ,-1395 , -894]]
B8=[[ -8, -14 ,-25]]

bin_C1 = intToBin(C1)
bin_C2 = intToBin(C2)
bin_C3 = intToBin(C3)
bin_C4 = intToBin(C4)
bin_mul = intToBin(mul)
bin_sub1 = intToBin(sub1)
bin_sub2 = intToBin(sub2)
bin_add = intToBin(add)
bin_B_sub = intToBin(B_sub)
bin_B_add = intToBin(B_add)

bin_M1 = []
bin_M2 = []
bin_M3 = []
bin_M4 = []
bin_M5 = []
bin_M6 = []
bin_M7 = []
bin_M8 = []

for i in M1:
    for j in i:
        bin_M1.append(intToBin(j))
for i in M2:
    for j in i:
        bin_M2.append(intToBin(j))
for i in M3:
    for j in i:
        bin_M3.append(intToBin(j))
for i in M4:
    for j in i:
        bin_M4.append(intToBin(j))
for i in M5:
    for j in i:
        bin_M5.append(intToBin(j))
for i in M6:
    for j in i:
        bin_M6.append(intToBin(j))
for i in M7:
    for j in i:
        bin_M7.append(intToBin(j))
for i in M8:
    for j in i:
        bin_M8.append(intToBin(j))


print(bin_M1)
print(bin_M2)
print(bin_M3)
print(bin_M4)
print(bin_M5)
print(bin_M6)
print(bin_M7)
print(bin_M8)

bin_B1 = []
bin_B2 = []
bin_B3 = []
bin_B4 = []
bin_B5 = []
bin_B6 = []
bin_B7 = []
bin_B8 = []

for i in B1:
    for j in i:
        bin_B1.append(intToBin(j))
for i in B2:
    for j in i:
        bin_B2.append(intToBin(j))
for i in B3:
    for j in i:
        bin_B3.append(intToBin(j))
for i in B4:
    for j in i:
        bin_B4.append(intToBin(j))
for i in B5:
    for j in i:
        bin_B5.append(intToBin(j))
for i in B6:
    for j in i:
        bin_B6.append(intToBin(j))
for i in B7:
    for j in i:
        bin_B7.append(intToBin(j))
for i in B8:
    for j in i:
        bin_B8.append(intToBin(j))
        
print(bin_B1)
print(bin_B2)
print(bin_B3)
print(bin_B4)
print(bin_B5)
print(bin_B6)
print(bin_B7)
print(bin_B8)

file_path = './dec2bin/bin_M.txt'
with open(file_path,'w+') as f:
    f.write("M1:\n")
    f.write(str(bin_M1))
    f.write("\nM2:\n")
    f.write(str(bin_M2))
    f.write("\nM3:\n")
    f.write(str(bin_M3))
    f.write("\nM4:\n")
    f.write(str(bin_M4))
    f.write("\nM5:\n")
    f.write(str(bin_M5))
    f.write("\nM6:\n")
    f.write(str(bin_M6))
    f.write("\nM7:\n")
    f.write(str(bin_M7))
    f.write("\nM8:\n")
    f.write(str(bin_M8))

    f.write("\nC1:\n")
    f.write(str(bin_C1))
    f.write("\nC2:\n")
    f.write(str(bin_C2))
    f.write("\nC3:\n")
    f.write(str(bin_C3))
    f.write("\nC4:\n")
    f.write(str(bin_C4))

    f.write("\nmul:\n")
    f.write(str(bin_mul))
    f.write("\nsub1:\n")
    f.write(str(bin_sub1))
    f.write("\nsub2:\n")
    f.write(str(bin_sub2))
    f.write("\nadd:\n")
    f.write(str(bin_add))

file_path = './dec2bin/bin_B.txt'
with open(file_path,'w+') as f:
    f.write("B1:\n")
    f.write(str(bin_B1))
    f.write("\nB2:\n")
    f.write(str(bin_B2))
    f.write("\nB3:\n")
    f.write(str(bin_B3))
    f.write("\nB4:\n")
    f.write(str(bin_B4))
    f.write("\nB5:\n")
    f.write(str(bin_B5))
    f.write("\nB6:\n")
    f.write(str(bin_B6))
    f.write("\nB7:\n")
    f.write(str(bin_B7))
    f.write("\nB8:\n")
    f.write(str(bin_B8))

    f.write("\nB_sub:\n")
    f.write(str(bin_B_sub))
    f.write("\nB_add:\n")
    f.write(str(bin_B_add))

file_path = './dec2bin/dec_M.txt'
with open(file_path,'w+') as f:
    f.write("M1:\n")
    f.write(str(M1))
    f.write("\nM2:\n")
    f.write(str(M2))
    f.write("\nM3:\n")
    f.write(str(M3))
    f.write("\nM4:\n")
    f.write(str(M4))
    f.write("\nM5:\n")
    f.write(str(M5))
    f.write("\nM6:\n")
    f.write(str(M6))
    f.write("\nM7:\n")
    f.write(str(M7))
    f.write("\nM8:\n")
    f.write(str(M8))

    f.write("\nC1:\n")
    f.write(str(C1))
    f.write("\nC2:\n")
    f.write(str(C2))
    f.write("\nC3:\n")
    f.write(str(C3))
    f.write("\nC4:\n")
    f.write(str(C4))

    f.write("\nmul:\n")
    f.write(str(mul))
    f.write("\nsub1:\n")
    f.write(str(sub1))
    f.write("\nsub2:\n")
    f.write(str(sub2))
    f.write("\nadd:\n")
    f.write(str(add))

file_path = './dec2bin/dec_B.txt'
with open(file_path,'w+') as f:
    f.write("B1:\n")
    f.write(str(B1))
    f.write("\nB2:\n")
    f.write(str(B2))
    f.write("\nB3:\n")
    f.write(str(B3))
    f.write("\nB4:\n")
    f.write(str(B4))
    f.write("\nB5:\n")
    f.write(str(B5))
    f.write("\nB6:\n")
    f.write(str(B6))
    f.write("\nB7:\n")
    f.write(str(B7))
    f.write("\nB8:\n")
    f.write(str(B8))

    f.write("\nB_sub:\n")
    f.write(str(B_sub))
    f.write("\nB_add:\n")
    f.write(str(B_add))