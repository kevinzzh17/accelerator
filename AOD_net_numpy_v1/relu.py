import numpy as np


def Relu(x):
    return np.maximum(x,0)

def Q_Relu(Zr,Sr,Zx,Sx,qx):
    """
    Zr,Sr:relu的zero_point和scale
    Zx,Sx:输入特征图的zero_point和scale
    qx:量化后的输入特征图
    """
    k = Sx/Sr
    qx_clip = np.clip(qx.astype(np.int32),a_min=Zx,a_max=None)
    qr = k*(qx_clip-Zx) + Zr
    # print(f"qx_clip:{qx_clip}")
    qr = np.round(qr,decimals=0)
    # qr = np.trunc(qr)
    qr = np.clip(qr,-128,127)
    qr_int = qr.astype(np.int8)
    # print(qr - qr_int)

    return qr_int

def Q_ReLU(qy):
    return np.clip(qy,-128,127).astype(np.int8)


if __name__ == "__main__":
    x = np.random.randint(-128,127,(1,3,64,48))
    print(f"x:\n{x}")
    print(f"Relu(x):\n{Relu(x)}")

    Zr,Sr,Zx,Sx = 23,0.9164,65,0.46546
    qx = np.random.randint(-128,127,(1,3,64,48))
    print(f"qx:\n{qx}")
    print(f"Q_Relu(Zr,Sr,Zx,Sx,qx):\n{Q_Relu(Zr,Sr,Zx,Sx,qx)}")
    