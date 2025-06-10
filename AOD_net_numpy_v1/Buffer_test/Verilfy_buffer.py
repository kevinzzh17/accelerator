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


def compare_files(file1, file2, file3):
    """读取python推理file1和Verilog仿真file2对比并将结果写入file3"""
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        lines1 = f1.readlines()
        lines2 = f2.readlines()
    print(f"len(lines1):{len(lines1)}")
    print(f"len(lines2):{len(lines2)}")
    cnt = 0
    error_cnt = 0
    error_cnt_over_1 = 0
    error_cnt_over_2 = 0
    with open(file3,"w+")as f:
        for (line1, line2) in tqdm(zip(lines1, lines2)):
            cnt += 1
            loss = []
            if line1 != line2:
                line1_tuple = eval(line1)
                line2_tuple = eval(line2)
                for i in range(len(line1_tuple)):
                    loss.append(line1_tuple[i]-line2_tuple[i])
                # print(loss)
                error_cnt += 1
                f.write(f"Difference found at line {cnt+1}:\n")
                f.write(f"{file1}: {line1.strip()}\n")
                f.write(f"{file2}: {line2.strip()}\n")
                f.write(f"Difference:{loss}\n\n")

                for i in loss:
                    if(i > 1):
                        error_cnt_over_1 += 1
                    if ((i > 1)&(i<=5)):
                        error_cnt_over_2 += 1
                        # f.write(f"Difference found at line {cnt+1}:\n")
                        # f.write(f"{file1}: {line1.strip()}\n")
                        # f.write(f"{file2}: {line2.strip()}\n")
                        # f.write(f"Difference:{loss}\n\n")
                        # print(f"Difference found at line {cnt+1}:")
                        # print(f"{file1}: {line1.strip()}")
                        # print(f"{file2}: {line2.strip()}")
                        # print(f"Difference:{loss}\n")
                    
    # print(f"对比完毕,{cnt}组中共有{error_cnt}处不同，其中误差超过1的有{error_cnt_over_1}项。")
    print(f"对比完毕,{cnt}组中共有{cnt*3}组数据，其中不同的有{error_cnt}组，其中误差超过1的有{error_cnt_over_1}项，其中误差超过1小于5的有{error_cnt_over_2}项。")


if __name__ == "__main__":
    #要测试的文件名称定义
    file_name = "conv5_out.txt"
    #文件路径定义
    Python_hex_path = "./Buffer_test/Python_hex/" + file_name
    Python_dec_path = "./Buffer_test/Python_dec/" + file_name
    Verilog_hex_path = "./Buffer_test/Verilog_hex/" + file_name
    Verilog_dec_path = "./Buffer_test/Verilog_dec/"+ file_name
    pynq_dma_out_hex = "./Buffer_test/pynq_dma_out_hex/" + file_name
    pynq_dma_out_dec = "./Buffer_test/pynq_dma_out_dec/" + file_name
    result_path = "./Buffer_test/result/result_" + file_name

    #将Python和Verilog的十六进制文件转为十进制文件
    dec_txt_gen(Python_hex_path,Python_dec_path)
    dec_txt_gen(Verilog_hex_path,Verilog_dec_path)
    # dec_txt_gen(pynq_dma_out_hex,pynq_dma_out_dec)
    compare_files(Python_dec_path, Verilog_dec_path, result_path)
    # compare_files(Python_dec_path, pynq_dma_out_dec, result_path)

