from typing import List, Tuple, Union
import numpy as np
from loguru import logger

from weights_int8 import qw1,Sw1,qw2,Sw2,qw3,Sw3,qw4,Sw4,qw5,Sw5
from bias_int8 import qb1,Sb1,qb2,Sb2,qb3,Sb3,qb4,Sb4,qb5,Sb5
from inout_int8 import Sconcat1,Zconcat1,Sconcat2,Zconcat2,Sconcat3,Zconcat3,Smul_out,Zmul_out,Ssub_out,Zsub_out,Sadd_out,Zadd_out
from inout_int8 import Sy1,Zy1,Sy2,Zy2,Sy3,Zy3,Sy4,Zy4,Sy5,Zy5
from inout_int8 import Sx1,Zx1,Sx2,Zx2,Sx3,Zx3,Sx4,Zx4,Sx5,Zx5

def compute_mul_shift(s1: float, s2: float, s3: float) -> Tuple[float]:
    """
    Function to compute multiplier and shift parameters proposed in paper:
        Quantization and Training of Neural Networks for Efficient Integer-Arithmetic-Only Inference
    The details of the concrete meaning of multiplier and shift can be found the above reference.
    """
    assert isinstance(s1, float) and isinstance(s2, float) \
           and isinstance(s3, float)
    if s3 == 0:
        s3 = 10e-7  # eps for safe division.
    re_scale = 1 / (s1 * s2 / s3)
    shift_list = list(range(1, 23))

    m_s_list = []
    for shift in shift_list:
        mul = np.round((2 ** shift) * re_scale)
        err = np.abs(mul / (2 ** shift) - re_scale)
        m_s_list.append([mul, shift, err])

    mul_range_safe = False
    final_list = []
    for item in m_s_list:
        print(item)
        if 100 <= item[0] <= 512:
            mul_range_safe = True
            final_list.append(item)
    if mul_range_safe is False:
        logger.warning("Multiplier is out of numeric range - "
                       "[s1: {:>.3f}, s2: {:>.3f}, s3: {:>.3f}]".format(s1, s2, s3))
        err_res = np.asarray(m_s_list).astype(np.float32)
    else:
        err_res = np.asarray(final_list).astype(np.float32)
    idx = err_res[:, 2].argmin()
    mul, shift = float(err_res[idx][0]), float(err_res[idx][1])
    return mul, shift

M, N = compute_mul_shift(float(Sy3),float(1.0),float(Sconcat2))

print(M,N)