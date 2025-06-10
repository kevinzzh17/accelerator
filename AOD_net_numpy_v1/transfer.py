# with open('./test/conv1_in.txt', 'r') as file_in, open('./output.txt', 'w') as file_out:
#     lines = file_in.readlines()
    
#     for line in lines:
#         # 去除行尾的换行符
#         line = line.rstrip('\n')
        
#         # 将每隔两个数据加一个空格
#         new_line = ' '
#         for i, char in enumerate(line):
#             new_line += char
#             if (i + 1) % 2 == 0 and (i + 1) < len(line):
#                 new_line += ' '
        
#         # 写入处理后的文本到输出文件
#         file_out.write(new_line + ' ')

# with open('./test/txt_hex/in/conv1_in.txt', 'r') as file_in, open('conv1_in.txt', 'w') as file_out:
#     lines = file_in.readlines()
    
#     for line in lines:
#         # 去除行尾的换行符
#         line = line.rstrip('\n')
#         newline1,newline2,newline3 = line
#         # 写入处理后的文本到输出文件
#         file_out.write(newline)

# 打开原始文件和目标文件
# with open('./test/txt_hex/in/conv1_in.txt', 'r') as input_file, open('conv1_in.txt', 'w') as output_file:
#     # 读取原始文件的每一行
#     for line in input_file:
#         # 去掉行尾的换行符
#         line = line.strip()
#         # 分割6位十六进制数并写入新文件
#         # print(len(line))
#         for i in range(0, len(line), 2):# (0,6,2)代表0到6，间隔2
#             output_file.write(line[i:i+2] + '\n')

# 打开txt文件
# with open('./test/txt_hex/in/conv1_in.txt', 'r') as file:
#     hex_data = file.read().split()  # 从文件中读取并分割十六进制字符串

# hex_list = []

# # 将十六进制字符串格式化为0x开头的形式并添加到列表中
# for hex_string in hex_data:
#     formatted_hex = f'0x00{hex_string}'
#     hex_list.append(formatted_hex)

# print(hex_list)
# 定义要转换的十进制数列表
decimal_numbers = [16, 255, 4096, 65535, 1024, 0]

# 转换成十六进制数并格式化
hex_numbers = [f"{i:06X}" for i in decimal_numbers]

# 写入文件
with open('hex_output.txt', 'w') as file:
    for hex_num in hex_numbers:
        file.write(hex_num.lstrip('0x') + '\n')

# def hex_to_ascii(hex_string):
#     ascii_string = bytes.fromhex(hex_string).decode('utf-8')
#     return ascii_string
#     # except Exception as e:
#     #     print(f"Error converting hex to ASCII: {str(e)}")
#     #     return None

# def process_file(input_file, output_file):
#     # try:
#     with open(input_file, 'r') as file_in, open(output_file, 'w') as file_out:
#         for line in file_in:
#             # print(line)
#             hex_string = line.rstrip('/n')
#             # print(hex_string)
#             ascii_string = hex_to_ascii(hex_string)
#             if ascii_string is not None:
#                 file_out.write(ascii_string)
#     print(f"Conversion completed. Output written to {output_file}")
#     # except Exception as e:
#     #     print(f"Error processing file: {str(e)}")

# input_file = './test/conv1_in.txt'  # 替换为你的输入文件名
# output_file = './output1.txt'  # 替换为你的输出文件名

# process_file(input_file, output_file)
       





# # 打开文本文件并指定编码为utf-8，你可以根据文件实际编码进行调整
# with open('./output.txt', 'r', encoding='utf-8') as file_in:
#     # 读取文件内容
#     text = file_in.read()

# # 将文本转换为ASCII码
# ascii_codes = [ord(char) for char in text]

# # 将ASCII码写入输出文件
# with open('output1.txt', 'w') as file_out:
#     for code in ascii_codes:
#         file_out.write(str(code) + '\n')

# print("File converted to ASCII and saved as 'output.txt'")





# hex_string = "48656c6c6f2c20576f726c64"  # 16进制字符串
# ascii_string = bytes.fromhex(hex_string).decode('utf-8')
# print(ascii_string)
