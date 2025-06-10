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
        
if __name__ == "__main__":
    #随机产生weights和inputs
    weights_R = np.random.randint(low=-128,high=127,size=(3,3),dtype=np.int8)
    inputs_R = np.random.randint(low=-128,high=127,size=(3,3),dtype=np.int8)
    weights_G = np.random.randint(low=-128,high=127,size=(3,3),dtype=np.int8)
    inputs_G = np.random.randint(low=-128,high=127,size=(3,3),dtype=np.int8)
    weights_B = np.random.randint(low=-128,high=127,size=(3,3),dtype=np.int8)
    inputs_B = np.random.randint(low=-128,high=127,size=(3,3),dtype=np.int8)
    # bias = np.random.randint(low=-32768,high=32767,dtype=np.int16)
    bias = -1264
    M0 = 2580

    #转化为list方便遍历
    weights_R = weights_R.tolist()
    inputs_R = inputs_R.tolist()
    weights_G = weights_G.tolist()
    inputs_G = inputs_G.tolist()
    weights_B = weights_B.tolist()
    inputs_B = inputs_B.tolist()

    #遍历list将元素转换为二进制
    weights_R_bin,inputs_R_bin = [],[]
    weights_G_bin,inputs_G_bin = [],[]
    weights_B_bin,inputs_B_bin = [],[]

    for i in weights_R:
        for j in i:
            weights_R_bin.append(intToBin(j))

    for i in inputs_R:
        for j in i:
            inputs_R_bin.append(intToBin(j))

    for i in weights_G:
        for j in i:
            weights_G_bin.append(intToBin(j))

    for i in inputs_G:
        for j in i:
            inputs_G_bin.append(intToBin(j))

    for i in weights_B:
        for j in i:
            weights_B_bin.append(intToBin(j))

    for i in inputs_B:
        for j in i:
            inputs_B_bin.append(intToBin(j))

    #计算MAC结果
    sum_R = 0
    for i in range(3):
        for j in range(3):
            tmp = weights_R[i][j]*inputs_R[i][j]
            print(f"{weights_R[i][j]}*{inputs_R[i][j]} = {tmp}")
            sum_R += tmp

    sum_G = 0
    for i in range(3):
        for j in range(3):
            tmp = weights_G[i][j]*inputs_G[i][j]
            print(f"{weights_G[i][j]}*{inputs_G[i][j]} = {tmp}")
            sum_G += tmp

    sum_B = 0
    for i in range(3):
        for j in range(3):
            tmp = weights_B[i][j]*inputs_B[i][j]
            print(f"{weights_B[i][j]}*{inputs_B[i][j]} = {tmp}")
            sum_B += tmp
    
    print()
    print(f"//{weights_R[0][0]} {weights_R[0][1]} {weights_R[0][2]} {weights_R[1][0]} {weights_R[1][1]} {weights_R[1][2]} {weights_R[2][0]} {weights_R[2][1]} {weights_R[2][2]}")
    print(f"Weight_R = 72'b{weights_R_bin[0]}_{weights_R_bin[1]}_{weights_R_bin[2]}_{weights_R_bin[3]}_{weights_R_bin[4]}_{weights_R_bin[5]}_{weights_R_bin[6]}_{weights_R_bin[7]}_{weights_R_bin[8]};")
    print(f"//{inputs_R[0][0]} {inputs_R[0][1]} {inputs_R[0][2]} {inputs_R[1][0]} {inputs_R[1][1]} {inputs_R[1][2]} {inputs_R[2][0]} {inputs_R[2][1]} {inputs_R[2][2]}")
    print(f"Input_R = 72'b{inputs_R_bin[0]}_{inputs_R_bin[1]}_{inputs_R_bin[2]}_{inputs_R_bin[3]}_{inputs_R_bin[4]}_{inputs_R_bin[5]}_{inputs_R_bin[6]}_{inputs_R_bin[7]}_{inputs_R_bin[8]};")
    print(f"//sum_R:{sum_R}")
    
    print(f"//{weights_G[0][0]} {weights_G[0][1]} {weights_G[0][2]} {weights_G[1][0]} {weights_G[1][1]} {weights_G[1][2]} {weights_G[2][0]} {weights_G[2][1]} {weights_G[2][2]}")
    print(f"Weight_G = 72'b{weights_G_bin[0]}_{weights_G_bin[1]}_{weights_G_bin[2]}_{weights_G_bin[3]}_{weights_G_bin[4]}_{weights_G_bin[5]}_{weights_G_bin[6]}_{weights_G_bin[7]}_{weights_G_bin[8]};")
    print(f"//{inputs_G[0][0]} {inputs_G[0][1]} {inputs_G[0][2]} {inputs_G[1][0]} {inputs_G[1][1]} {inputs_G[1][2]} {inputs_G[2][0]} {inputs_G[2][1]} {inputs_G[2][2]}")
    print(f"Input_G = 72'b{inputs_G_bin[0]}_{inputs_G_bin[1]}_{inputs_G_bin[2]}_{inputs_G_bin[3]}_{inputs_G_bin[4]}_{inputs_G_bin[5]}_{inputs_G_bin[6]}_{inputs_G_bin[7]}_{inputs_G_bin[8]};")
    print(f"//sum_G:{sum_G}")

    print(f"//{weights_B[0][0]} {weights_B[0][1]} {weights_B[0][2]} {weights_B[1][0]} {weights_B[1][1]} {weights_B[1][2]} {weights_B[2][0]} {weights_B[2][1]} {weights_B[2][2]}")
    print(f"Weight_B = 72'b{weights_B_bin[0]}_{weights_B_bin[1]}_{weights_B_bin[2]}_{weights_B_bin[3]}_{weights_B_bin[4]}_{weights_B_bin[5]}_{weights_B_bin[6]}_{weights_B_bin[7]}_{weights_B_bin[8]};")
    print(f"//{inputs_B[0][0]} {inputs_B[0][1]} {inputs_B[0][2]} {inputs_B[1][0]} {inputs_B[1][1]} {inputs_B[1][2]} {inputs_B[2][0]} {inputs_B[2][1]} {inputs_B[2][2]}")
    print(f"Input_B = 72'b{inputs_B_bin[0]}_{inputs_B_bin[1]}_{inputs_B_bin[2]}_{inputs_B_bin[3]}_{inputs_B_bin[4]}_{inputs_B_bin[5]}_{inputs_B_bin[6]}_{inputs_B_bin[7]}_{inputs_B_bin[8]};")
    print(f"//sum_B:{sum_B}")

    if(bias>0):
        print(f"Bias = 16'd{bias};")
    else:
        print(f"Bias = -16'd{-bias};")
    Output1_0 = sum_R+sum_G+sum_B
    Output1_1 = Output1_0*M0
    Output1_2 = Output1_1>>16
    print(f"//sum_R+sum_G+sum_B= {Output1_0}")
    print(f"//(sum_R+sum_G+sum_B)*M0= {Output1_1}")
    print(f"//((sum_R+sum_G+sum_B)*M0)>>16+bias= {Output1_2+bias}")
    
    
