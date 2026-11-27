These test suite checks that redundant storage class semantics does not affect synchronization guarantees under the new model.

The `base` test is a variation of an atomic load buffer tests with variables located in different storage classes.
The atomics have no semantics of the other variable but all instructions have semantics of a third unused storage class.
Other tests introduce accesses to a variable in the third storage class and check that the ordering of atomics is guaranteed only if they influence the location order in this third storage class.

In the `base-ordered` test, synchronization the ordering of atomics is guaranteed because they synchronize the accesses to variable `c`.
However, the ordering of atomics is not guaranteed in tests `base-unordered-1` and `base-unordered-2`.
In the first case, the accesses are to different memory locations and thus not in location order.
In the second case, the same-variable accesses are in the same thread and are thus ordered regardless of the atomics.

The remaining tests in the suite systematically test whether the atomics ordering is guaranteed depending on the accesses to the third storage class.