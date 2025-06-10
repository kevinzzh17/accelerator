import numpy as np

Sconcat1 = [0.002443420933559537 ]
Zconcat1 = [-128]

Sconcat2 = [0.0018187382956966758 ]
Zconcat2 = [-128]

Sconcat3 = [0.0017716849688440561 ]
Zconcat3 = [-128]

Sy1 = Sconcat1
Zy1 = Zconcat1

Sy2 = Sconcat2
Zy2 = Zconcat2

Sy3 = Sconcat3
Zy3 = Zconcat3

Sy4 = [0.004607711918652058 ]
Zy4 = [-128]

Sy5 = [0.006583539303392172 ]
Zy5 = [-128]

Sx1 = [0.003921568859368563 ]
Zx1 = [-128]

Sx2 = Sy1
Zx2 = Zy1#128

Sx3 = Sconcat1
Zx3 = Zconcat1#128

Sx4 = Sconcat2
Zx4 = Zconcat2#128

Sx5 = Sconcat3
Zx5 = Zconcat3#128

Smul_out = [0.006041365675628185 ]
Zmul_out = [-128]

Ssub_out = [0.004904167260974646 ]
Zsub_out = [127]

Sadd_out = [0.003921802155673504 ]
Zadd_out = [-128]

#将列表转化为numpy array
Sconcat1 = np.array(Sconcat1)
Zconcat1 = np.array(Zconcat1)
Sconcat2 = np.array(Sconcat2)
Zconcat2 = np.array(Zconcat2)
Sconcat3 = np.array(Sconcat3)
Zconcat3 = np.array(Zconcat3)

Sy1 = np.array(Sy1)
Zy1 = np.array(Zy1)
Sy2 = np.array(Sy2)
Zy2 = np.array(Zy2)
Sy3 = np.array(Sy3)
Zy3 = np.array(Zy3)
Sy4 = np.array(Sy4)
Zy4 = np.array(Zy4)
Sy5 = np.array(Sy5)
Zy5 = np.array(Zy5)

Sx1 = np.array(Sx1)
Zx1 = np.array(Zx1)
Sx2 = np.array(Sx2)
Zx2 = np.array(Zx2)
Sx3 = np.array(Sx3)
Zx3 = np.array(Zx3)
Sx4 = np.array(Sx4)
Zx4 = np.array(Zx4)
Sx5 = np.array(Sx5)
Zx5 = np.array(Zx5)

Smul_out = np.array(Smul_out)
Zmul_out = np.array(Zmul_out)

Ssub_out = np.array(Ssub_out)
Zsub_out = np.array(Zsub_out)

Sadd_out = np.array(Sadd_out)
Zadd_out = np.array(Zadd_out)

if __name__ == "__main__":
    print(f"Sconcat1:{Sconcat1}\n")
    print(f"Sconcat1:{Zconcat1}\n")
    print(f"Sconcat1:{Sconcat2}\n")
    print(f"Sconcat1:{Zconcat2}\n")
    print(f"Sconcat1:{Sconcat3}\n")
    print(f"Sconcat1:{Zconcat3}\n")

    print(f"Sy1:{Sy1}\n")
    print(f"Zy1:{Zy1}\n")
    print(f"Sy2:{Sy2}\n")
    print(f"Zy2:{Zy2}\n")
    print(f"Sy3:{Sy3}\n")
    print(f"Zy3:{Zy3}\n")
    print(f"Sy4:{Sy4}\n")
    print(f"Zy4:{Zy4}\n")
    print(f"Sy5:{Sy5}\n")
    print(f"Zy5:{Zy5}\n")

    print(f"Sx1:{Sx1}\n")
    print(f"Zx1:{Zx1}\n")
    print(f"Sx2:{Sx2}\n")
    print(f"Zx2:{Zx2}\n")
    print(f"Sx3:{Sx3}\n")
    print(f"Zx3:{Zx3}\n")
    print(f"Sx4:{Sx4}\n")
    print(f"Zx4:{Zx4}\n")
    print(f"Sx5:{Sx5}\n")
    print(f"Zx5:{Zx5}\n")

    print(f"Smul_out:{Smul_out}\n")
    print(f"Zmul_out:{Zmul_out}\n")

    print(f"Ssub_out:{Ssub_out}\n")
    print(f"Zsub_out:{Zsub_out}\n")

    print(f"Sadd_out:{Sadd_out}\n")
    print(f"Zadd_out:{Zadd_out}\n")