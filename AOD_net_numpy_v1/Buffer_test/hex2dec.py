from tqdm import tqdm

def hex2dec(hex_num):
    """十六进制补码转十进制有符号数"""
    # print(f"hex_num:{hex_num}")
    dec_num = int(hex_num,16)
    if dec_num > 0x7f:#若十进制数大于127则-256
        dec_num -= 0x100
    # print(f"dec_num:{dec_num}")
    return dec_num

def dec_txt_gen(hex_file_path,dec_file_path):
    """读取十六进制txt文件转为十进制txt文件"""
    lines_hex = []
    with open(hex_file_path, 'r') as f:
        lines = f.readlines()
        # print(lines)
        for line in lines:
            line = line.strip()
            # print(type(line))#str
            num_hex = [line[i:i+2] for i in range(0, len(line), 2)]
            lines_hex.append(num_hex)
        # print(lines_hex)

    with open(dec_file_path, 'w+') as f:
        for line in lines_hex:
            # print(f"line:{line}")
            for num in line:
                # print(f"num:{num}")
                f.write(str(hex2dec(str(num))))
                f.write(",")
            f.write("\n")


if __name__ == "__main__":
    #要测试的文件名称定义
    file_name = "result.txt"
    #文件路径定义
    Python_hex_path = "./Buffer_test/Python_hex/" + file_name
    Python_dec_path = "./Buffer_test/Python_dec/" + file_name
    # Verilog_hex_path = "./Buffer_test/Verilog_hex/outdoor/" + file_name
    # Verilog_dec_path = "./Buffer_test/Verilog_dec/outdoor/"+ file_name
    # Verilog_hex_path = "./Buffer_test/Verilog_hex/indoor/" + file_name
    # Verilog_dec_path = "./Buffer_test/Verilog_dec/indoor/"+ file_name
    Verilog_hex_path = "./Buffer_test/Verilog_hex/" + file_name
    Verilog_dec_path = "./Buffer_test/Verilog_dec/"+ file_name
    pynq_dma_out_hex = "./Buffer_test/pynq_dma_out_hex/" + file_name
    pynq_dma_out_dec = "./Buffer_test/pynq_dma_out_dec/" + file_name
    result_path = "./Buffer_test/result/result_" + file_name

    dec_txt_gen(Verilog_hex_path,Verilog_dec_path)
    # dec_txt_gen(Python_hex_path,Python_dec_path)

