def generate_coe_file(data, filename):
    with open(filename, 'w') as file:
        file.write('memory_initialization_radix=16;\n')
        file.write('memory_initialization_vector=\n')
        for i, value in enumerate(data):
            file.write('{:02X}'.format(value))
            if i != len(data) - 1:
                file.write(',\n')
            else:
                file.write(';\n')

# 示例数据
data = [0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE, 0xF0]

# 生成coe文件
generate_coe_file(data, 'output.coe')