本文件为硬件系统的软件版本，主要需要使用的文件为AOD_Net_INT8_tb_mem2.ipynb，该文件为软件每一层输出的具体数据，用于软硬验证。
其余文件如AOD_Net_INT8.ipynb为本网络的量化版本，也就是最终部署的版本，该文件主要对比量化前后的去雾效果对比。
AOD_Net_INT8_infer2.ipynb是表现清楚整个网络的推理过程。
本文件中还给出了软硬对比的部分，存在于Buffer_test文件夹中，仅需运行Verilfy_buffer.py(实际使用还需修改内部部分参数，如文件地址等)
本文件夹中还有不少bias，weight的py文件，这些文件为训练出的网络的权重参数，方便被导入进ipynb文件中进行模仿推理。
