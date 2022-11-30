/*
 * Copyright (C) 2022. Huawei Technologies Co., Ltd.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the MIT License.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the MIT License for more details.
 */

#ifndef ATOMIC_REPLACE_INTERFACE_H
#define ATOMIC_REPLACE_INTERFACE_H

enum my_rmw_op : unsigned {
  op_xchg = 0,
  op_add,
  op_sub,
  op_and,
  op_or,
  op_xor
};

#endif /* ATOMIC_REPLACE_INTERFACE_H */
