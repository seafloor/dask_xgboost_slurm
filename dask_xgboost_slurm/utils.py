import numpy as np
from itertools import compress


def parse_bool(bool_arg):
    bool_arg = bool_arg.lower()
    if bool_arg == 'false':
        bool_arg = False
    elif bool_arg == 'true':
        bool_arg = True
    else:
        raise ValueError(f'Arg {bool_arg} not recognised. Must be in ["True", "False"].')

    return bool_arg


def set_numpy_dtype(dtype_str):
    dtype_options = [np.float16, np.float32, np.float64]
    dtype_numpy = list(compress(dtype_options, [dtype_str.lower() == s for s in ('float16', 'float32', 'float64')]))
    if len(dtype_numpy) != 1:
        raise ValueError(f'NumPy dtypes selected as {dtype_numpy}')

    return dtype_numpy[0]
