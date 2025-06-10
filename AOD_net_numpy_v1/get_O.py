"""计算量自动计算脚本"""

def print_O(input_size,weight_size,output_size):
    (Hi,Wi) = input_size
    (Co,Ci,Kh,Kw) = weight_size
    (Ho,Wo) = output_size
    conv_mul = Ho*Wo*Co*Kh*Kw*Ci
    conv_add = Ho*Wo*Co*(Kh*Kw-1)*Ci+Co-1
    bias_add = Ho*Wo*Co*Co
    print(f"Conv mul:\t{Ho}*{Wo}*{Co}*({Kh}*{Kw})*{Ci}={conv_mul}")
    print(f"Conv add:\t{Ho}*{Wo}*{Co}*({Kh}*{Kw}-1)*{Ci}+({Co}-1)={conv_add}")
    print(f"Bias add:\t{Ho}*{Wo}*{Co}*{Co}={bias_add}")
    return conv_mul,conv_add,bias_add
    
if __name__ == "__main__":
    input_size = (480,640)
    output_size = (480,640)
    # weights = [
    #     (3,3,1,1),
    #     (3,3,3,3),
    #     (3,3,5,5),
    #     (6,6,7,7),
    #     (6,6,3,3),
    #     (6,6,3,3),
    #     (6,12,3,3),
    #     (3,15,3,3)
    # ]
    weights = [
        (8,3,1,1),
        (8,8,3,3),
        (8,8,5,5),
        (16,16,7,7),
        (16,16,3,3),
        (16,16,3,3),
        (32,32,3,3),
        (3,56,3,3)
    ]
    conv_mul_sum,conv_add_sum,bias_add_sum = 0,0,0
    i = 1
    for weight in weights:
        print(i)
        conv_mul,conv_add,bias_add = print_O(input_size,weight,output_size)
        conv_mul_sum += conv_mul
        conv_add_sum += conv_add
        bias_add_sum += bias_add
        i += 1
    print(f"Total conv_mul =\t{conv_mul_sum}")
    print(f"Total conv_add =\t{conv_add_sum}")
    print(f"Total bias_add =\t{bias_add_sum}")
