import numpy as np
# from utils import reshape
def reshape(list_name,shape):
    array = np.array(list_name)
    array = np.reshape(array,shape)
    return array


# b_conv1 = [0.3512551 ,0.18615687,0.43568993]
b_conv1 = [0.1610761 ,0.21122928,0.29886976]
# b_conv2 = [0.06817713,0.05108311,0.09773736]
b_conv2 = [ 0.04634528, 0.04899548,-0.01521309]
# b_conv3 = [0.07577064,0.10503208,0.03593681]
b_conv3 = [0.09685231,0.15863183,0.05249532]
# b_conv4 = [0.28162605,0.15481253,0.22511676]
b_conv4 = [0.31464612,0.15018652,0.28873178]
# b_conv5 = [0.44499227,0.41770437,0.42385918]
b_conv5 = [0.4440959 ,0.42114776,0.39904293]

# b_conv1 = np.array(b_conv1)
# b_conv2 = np.array(b_conv2)
# b_conv3 = np.array(b_conv3)
# b_conv4 = np.array(b_conv4)
# b_conv5 = np.array(b_conv5)

b_conv_shape1 = (1,3)
b_conv_shape2 = (1,3)
b_conv_shape3 = (1,3)
b_conv_shape4 = (1,3)
b_conv_shape5 = (1,3)

b_conv1 = reshape(b_conv1,shape=b_conv_shape1)
b_conv2 = reshape(b_conv2,shape=b_conv_shape2)
b_conv3 = reshape(b_conv3,shape=b_conv_shape3)
b_conv4 = reshape(b_conv4,shape=b_conv_shape4)
b_conv5 = reshape(b_conv5,shape=b_conv_shape5)


if __name__ == "__main__":
    
    print(b_conv1)
    print(b_conv2)
    print(b_conv3)
    print(b_conv4)
    print(b_conv5)

    print(b_conv1.shape)
    print(b_conv2.shape)
    print(b_conv3.shape)
    print(b_conv4.shape)
    print(b_conv5.shape)