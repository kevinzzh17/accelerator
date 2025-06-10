import numpy as np

def concat(x1,x2):
    """返回x1在前,x2在后的numpy array"""
    return np.concatenate([x1,x2],axis=1)

def concat3(x1,x2,x3):
    """返回x1在前,x2在后的numpy array"""
    return np.concatenate([x1,x2,x3],axis=1)

if __name__ == "__main__":
    x1 = np.random.randint(-127,128,(1,3,64,48))
    x2 = np.random.randint(-127,128,(1,3,64,48))
    concat1 = concat(x1=x1,x2=x2)
    print(f"x1:\n{x1}")
    print(f"x2:\n{x2}")
    print(f"concat1:\n{concat1}")
    
