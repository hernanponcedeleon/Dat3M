// Basic types
type i1 = int;
type i5 = int;
type i6 = int;
type i8 = int;
type i16 = int;
type i24 = int;
type i32 = int;
type i40 = int;
type i48 = int;
type i56 = int;
type i64 = int;
type i80 = int;
type i88 = int;
type i96 = int;
type i128 = int;
type i160 = int;
type i256 = int;
type ref = i64;
type float;

// Basic constants
const $0: i32;
axiom ($0 == 0);
const $1: i32;
axiom ($1 == 1);
const $0.ref: ref;
axiom ($0.ref == 0);
const $1.ref: ref;
axiom ($1.ref == 1);
const $1024.ref: ref;
axiom ($1024.ref == 1024);
// Memory model constants
const $GLOBALS_BOTTOM: ref;
const $EXTERNS_BOTTOM: ref;
const $MALLOC_TOP: ref;

// Memory maps (40 regions)
var $M.0: i32;
var $M.1: i32;
var $M.2: i32;
var $M.3: i32;
var $M.4: i8;
var $M.5: i8;
var $M.6: i8;
var $M.7: i8;
var $M.8: i8;
var $M.9: i8;
var $M.10: i8;
var $M.11: i8;
var $M.12: i32;
var $M.13: i32;
var $M.14: i8;
var $M.15: i8;
var $M.16: i8;
var $M.17: i32;
var $M.18: i8;
var $M.19: i8;
var $M.20: ref;
var $M.21: i32;
var $M.22: i8;
var $M.23: i8;
var $M.24: i8;
var $M.25: i32;
var $M.26: i8;
var $M.27: i8;
var $M.28: i8;
var $M.29: i8;
var $M.30: i8;
var $M.31: i8;
var $M.32: i32;
var $M.33: i8;
var $M.34: i32;
var $M.35: i8;
var $M.36: i8;
var $M.37: ref;
var $M.38: ref;
var $M.39: i32;

// Memory address bounds
axiom ($GLOBALS_BOTTOM == $sub.ref(0, 91632));
axiom ($EXTERNS_BOTTOM == $add.ref($GLOBALS_BOTTOM, $sub.ref(0, 32768)));
axiom ($MALLOC_TOP == 9223372036854775807);
function {:inline} $isExternal(p: ref) returns (bool) { $slt.ref.bool(p, $EXTERNS_BOTTOM) }

// SMT bit-vector/integer conversion
function {:builtin "(_ int2bv 64)"} $int2bv.64(i: i64) returns (bv64);
function {:builtin "bv2nat"} $bv2int.64(i: bv64) returns (i64);

// Integer arithmetic operations
function {:inline} $add.i1(i1: i1, i2: i1) returns (i1) { (i1 + i2) }
function {:inline} $add.i5(i1: i5, i2: i5) returns (i5) { (i1 + i2) }
function {:inline} $add.i6(i1: i6, i2: i6) returns (i6) { (i1 + i2) }
function {:inline} $add.i8(i1: i8, i2: i8) returns (i8) { (i1 + i2) }
function {:inline} $add.i16(i1: i16, i2: i16) returns (i16) { (i1 + i2) }
function {:inline} $add.i24(i1: i24, i2: i24) returns (i24) { (i1 + i2) }
function {:inline} $add.i32(i1: i32, i2: i32) returns (i32) { (i1 + i2) }
function {:inline} $add.i40(i1: i40, i2: i40) returns (i40) { (i1 + i2) }
function {:inline} $add.i48(i1: i48, i2: i48) returns (i48) { (i1 + i2) }
function {:inline} $add.i56(i1: i56, i2: i56) returns (i56) { (i1 + i2) }
function {:inline} $add.i64(i1: i64, i2: i64) returns (i64) { (i1 + i2) }
function {:inline} $add.i80(i1: i80, i2: i80) returns (i80) { (i1 + i2) }
function {:inline} $add.i88(i1: i88, i2: i88) returns (i88) { (i1 + i2) }
function {:inline} $add.i96(i1: i96, i2: i96) returns (i96) { (i1 + i2) }
function {:inline} $add.i128(i1: i128, i2: i128) returns (i128) { (i1 + i2) }
function {:inline} $add.i160(i1: i160, i2: i160) returns (i160) { (i1 + i2) }
function {:inline} $add.i256(i1: i256, i2: i256) returns (i256) { (i1 + i2) }
function {:inline} $sub.i1(i1: i1, i2: i1) returns (i1) { (i1 - i2) }
function {:inline} $sub.i5(i1: i5, i2: i5) returns (i5) { (i1 - i2) }
function {:inline} $sub.i6(i1: i6, i2: i6) returns (i6) { (i1 - i2) }
function {:inline} $sub.i8(i1: i8, i2: i8) returns (i8) { (i1 - i2) }
function {:inline} $sub.i16(i1: i16, i2: i16) returns (i16) { (i1 - i2) }
function {:inline} $sub.i24(i1: i24, i2: i24) returns (i24) { (i1 - i2) }
function {:inline} $sub.i32(i1: i32, i2: i32) returns (i32) { (i1 - i2) }
function {:inline} $sub.i40(i1: i40, i2: i40) returns (i40) { (i1 - i2) }
function {:inline} $sub.i48(i1: i48, i2: i48) returns (i48) { (i1 - i2) }
function {:inline} $sub.i56(i1: i56, i2: i56) returns (i56) { (i1 - i2) }
function {:inline} $sub.i64(i1: i64, i2: i64) returns (i64) { (i1 - i2) }
function {:inline} $sub.i80(i1: i80, i2: i80) returns (i80) { (i1 - i2) }
function {:inline} $sub.i88(i1: i88, i2: i88) returns (i88) { (i1 - i2) }
function {:inline} $sub.i96(i1: i96, i2: i96) returns (i96) { (i1 - i2) }
function {:inline} $sub.i128(i1: i128, i2: i128) returns (i128) { (i1 - i2) }
function {:inline} $sub.i160(i1: i160, i2: i160) returns (i160) { (i1 - i2) }
function {:inline} $sub.i256(i1: i256, i2: i256) returns (i256) { (i1 - i2) }
function {:inline} $mul.i1(i1: i1, i2: i1) returns (i1) { (i1 * i2) }
function {:inline} $mul.i5(i1: i5, i2: i5) returns (i5) { (i1 * i2) }
function {:inline} $mul.i6(i1: i6, i2: i6) returns (i6) { (i1 * i2) }
function {:inline} $mul.i8(i1: i8, i2: i8) returns (i8) { (i1 * i2) }
function {:inline} $mul.i16(i1: i16, i2: i16) returns (i16) { (i1 * i2) }
function {:inline} $mul.i24(i1: i24, i2: i24) returns (i24) { (i1 * i2) }
function {:inline} $mul.i32(i1: i32, i2: i32) returns (i32) { (i1 * i2) }
function {:inline} $mul.i40(i1: i40, i2: i40) returns (i40) { (i1 * i2) }
function {:inline} $mul.i48(i1: i48, i2: i48) returns (i48) { (i1 * i2) }
function {:inline} $mul.i56(i1: i56, i2: i56) returns (i56) { (i1 * i2) }
function {:inline} $mul.i64(i1: i64, i2: i64) returns (i64) { (i1 * i2) }
function {:inline} $mul.i80(i1: i80, i2: i80) returns (i80) { (i1 * i2) }
function {:inline} $mul.i88(i1: i88, i2: i88) returns (i88) { (i1 * i2) }
function {:inline} $mul.i96(i1: i96, i2: i96) returns (i96) { (i1 * i2) }
function {:inline} $mul.i128(i1: i128, i2: i128) returns (i128) { (i1 * i2) }
function {:inline} $mul.i160(i1: i160, i2: i160) returns (i160) { (i1 * i2) }
function {:inline} $mul.i256(i1: i256, i2: i256) returns (i256) { (i1 * i2) }
function {:builtin "div"} $sdiv.i1(i1: i1, i2: i1) returns (i1);
function {:builtin "div"} $sdiv.i5(i1: i5, i2: i5) returns (i5);
function {:builtin "div"} $sdiv.i6(i1: i6, i2: i6) returns (i6);
function {:builtin "div"} $sdiv.i8(i1: i8, i2: i8) returns (i8);
function {:builtin "div"} $sdiv.i16(i1: i16, i2: i16) returns (i16);
function {:builtin "div"} $sdiv.i24(i1: i24, i2: i24) returns (i24);
function {:builtin "div"} $sdiv.i32(i1: i32, i2: i32) returns (i32);
function {:builtin "div"} $sdiv.i40(i1: i40, i2: i40) returns (i40);
function {:builtin "div"} $sdiv.i48(i1: i48, i2: i48) returns (i48);
function {:builtin "div"} $sdiv.i56(i1: i56, i2: i56) returns (i56);
function {:builtin "div"} $sdiv.i64(i1: i64, i2: i64) returns (i64);
function {:builtin "div"} $sdiv.i80(i1: i80, i2: i80) returns (i80);
function {:builtin "div"} $sdiv.i88(i1: i88, i2: i88) returns (i88);
function {:builtin "div"} $sdiv.i96(i1: i96, i2: i96) returns (i96);
function {:builtin "div"} $sdiv.i128(i1: i128, i2: i128) returns (i128);
function {:builtin "div"} $sdiv.i160(i1: i160, i2: i160) returns (i160);
function {:builtin "div"} $sdiv.i256(i1: i256, i2: i256) returns (i256);
function {:builtin "mod"} $smod.i1(i1: i1, i2: i1) returns (i1);
function {:builtin "mod"} $smod.i5(i1: i5, i2: i5) returns (i5);
function {:builtin "mod"} $smod.i6(i1: i6, i2: i6) returns (i6);
function {:builtin "mod"} $smod.i8(i1: i8, i2: i8) returns (i8);
function {:builtin "mod"} $smod.i16(i1: i16, i2: i16) returns (i16);
function {:builtin "mod"} $smod.i24(i1: i24, i2: i24) returns (i24);
function {:builtin "mod"} $smod.i32(i1: i32, i2: i32) returns (i32);
function {:builtin "mod"} $smod.i40(i1: i40, i2: i40) returns (i40);
function {:builtin "mod"} $smod.i48(i1: i48, i2: i48) returns (i48);
function {:builtin "mod"} $smod.i56(i1: i56, i2: i56) returns (i56);
function {:builtin "mod"} $smod.i64(i1: i64, i2: i64) returns (i64);
function {:builtin "mod"} $smod.i80(i1: i80, i2: i80) returns (i80);
function {:builtin "mod"} $smod.i88(i1: i88, i2: i88) returns (i88);
function {:builtin "mod"} $smod.i96(i1: i96, i2: i96) returns (i96);
function {:builtin "mod"} $smod.i128(i1: i128, i2: i128) returns (i128);
function {:builtin "mod"} $smod.i160(i1: i160, i2: i160) returns (i160);
function {:builtin "mod"} $smod.i256(i1: i256, i2: i256) returns (i256);
function {:builtin "div"} $udiv.i1(i1: i1, i2: i1) returns (i1);
function {:builtin "div"} $udiv.i5(i1: i5, i2: i5) returns (i5);
function {:builtin "div"} $udiv.i6(i1: i6, i2: i6) returns (i6);
function {:builtin "div"} $udiv.i8(i1: i8, i2: i8) returns (i8);
function {:builtin "div"} $udiv.i16(i1: i16, i2: i16) returns (i16);
function {:builtin "div"} $udiv.i24(i1: i24, i2: i24) returns (i24);
function {:builtin "div"} $udiv.i32(i1: i32, i2: i32) returns (i32);
function {:builtin "div"} $udiv.i40(i1: i40, i2: i40) returns (i40);
function {:builtin "div"} $udiv.i48(i1: i48, i2: i48) returns (i48);
function {:builtin "div"} $udiv.i56(i1: i56, i2: i56) returns (i56);
function {:builtin "div"} $udiv.i64(i1: i64, i2: i64) returns (i64);
function {:builtin "div"} $udiv.i80(i1: i80, i2: i80) returns (i80);
function {:builtin "div"} $udiv.i88(i1: i88, i2: i88) returns (i88);
function {:builtin "div"} $udiv.i96(i1: i96, i2: i96) returns (i96);
function {:builtin "div"} $udiv.i128(i1: i128, i2: i128) returns (i128);
function {:builtin "div"} $udiv.i160(i1: i160, i2: i160) returns (i160);
function {:builtin "div"} $udiv.i256(i1: i256, i2: i256) returns (i256);
function {:inline} $srem.i1(i1: i1, i2: i1) returns (i1) { (if ($ne.i1.bool($smod.i1(i1, i2), 0) && $slt.i1.bool(i1, 0)) then $sub.i1($smod.i1(i1, i2), $smax.i1(i2, $sub.i1(0, i2))) else $smod.i1(i1, i2)) }
function {:inline} $srem.i5(i1: i5, i2: i5) returns (i5) { (if ($ne.i5.bool($smod.i5(i1, i2), 0) && $slt.i5.bool(i1, 0)) then $sub.i5($smod.i5(i1, i2), $smax.i5(i2, $sub.i5(0, i2))) else $smod.i5(i1, i2)) }
function {:inline} $srem.i6(i1: i6, i2: i6) returns (i6) { (if ($ne.i6.bool($smod.i6(i1, i2), 0) && $slt.i6.bool(i1, 0)) then $sub.i6($smod.i6(i1, i2), $smax.i6(i2, $sub.i6(0, i2))) else $smod.i6(i1, i2)) }
function {:inline} $srem.i8(i1: i8, i2: i8) returns (i8) { (if ($ne.i8.bool($smod.i8(i1, i2), 0) && $slt.i8.bool(i1, 0)) then $sub.i8($smod.i8(i1, i2), $smax.i8(i2, $sub.i8(0, i2))) else $smod.i8(i1, i2)) }
function {:inline} $srem.i16(i1: i16, i2: i16) returns (i16) { (if ($ne.i16.bool($smod.i16(i1, i2), 0) && $slt.i16.bool(i1, 0)) then $sub.i16($smod.i16(i1, i2), $smax.i16(i2, $sub.i16(0, i2))) else $smod.i16(i1, i2)) }
function {:inline} $srem.i24(i1: i24, i2: i24) returns (i24) { (if ($ne.i24.bool($smod.i24(i1, i2), 0) && $slt.i24.bool(i1, 0)) then $sub.i24($smod.i24(i1, i2), $smax.i24(i2, $sub.i24(0, i2))) else $smod.i24(i1, i2)) }
function {:inline} $srem.i32(i1: i32, i2: i32) returns (i32) { (if ($ne.i32.bool($smod.i32(i1, i2), 0) && $slt.i32.bool(i1, 0)) then $sub.i32($smod.i32(i1, i2), $smax.i32(i2, $sub.i32(0, i2))) else $smod.i32(i1, i2)) }
function {:inline} $srem.i40(i1: i40, i2: i40) returns (i40) { (if ($ne.i40.bool($smod.i40(i1, i2), 0) && $slt.i40.bool(i1, 0)) then $sub.i40($smod.i40(i1, i2), $smax.i40(i2, $sub.i40(0, i2))) else $smod.i40(i1, i2)) }
function {:inline} $srem.i48(i1: i48, i2: i48) returns (i48) { (if ($ne.i48.bool($smod.i48(i1, i2), 0) && $slt.i48.bool(i1, 0)) then $sub.i48($smod.i48(i1, i2), $smax.i48(i2, $sub.i48(0, i2))) else $smod.i48(i1, i2)) }
function {:inline} $srem.i56(i1: i56, i2: i56) returns (i56) { (if ($ne.i56.bool($smod.i56(i1, i2), 0) && $slt.i56.bool(i1, 0)) then $sub.i56($smod.i56(i1, i2), $smax.i56(i2, $sub.i56(0, i2))) else $smod.i56(i1, i2)) }
function {:inline} $srem.i64(i1: i64, i2: i64) returns (i64) { (if ($ne.i64.bool($smod.i64(i1, i2), 0) && $slt.i64.bool(i1, 0)) then $sub.i64($smod.i64(i1, i2), $smax.i64(i2, $sub.i64(0, i2))) else $smod.i64(i1, i2)) }
function {:inline} $srem.i80(i1: i80, i2: i80) returns (i80) { (if ($ne.i80.bool($smod.i80(i1, i2), 0) && $slt.i80.bool(i1, 0)) then $sub.i80($smod.i80(i1, i2), $smax.i80(i2, $sub.i80(0, i2))) else $smod.i80(i1, i2)) }
function {:inline} $srem.i88(i1: i88, i2: i88) returns (i88) { (if ($ne.i88.bool($smod.i88(i1, i2), 0) && $slt.i88.bool(i1, 0)) then $sub.i88($smod.i88(i1, i2), $smax.i88(i2, $sub.i88(0, i2))) else $smod.i88(i1, i2)) }
function {:inline} $srem.i96(i1: i96, i2: i96) returns (i96) { (if ($ne.i96.bool($smod.i96(i1, i2), 0) && $slt.i96.bool(i1, 0)) then $sub.i96($smod.i96(i1, i2), $smax.i96(i2, $sub.i96(0, i2))) else $smod.i96(i1, i2)) }
function {:inline} $srem.i128(i1: i128, i2: i128) returns (i128) { (if ($ne.i128.bool($smod.i128(i1, i2), 0) && $slt.i128.bool(i1, 0)) then $sub.i128($smod.i128(i1, i2), $smax.i128(i2, $sub.i128(0, i2))) else $smod.i128(i1, i2)) }
function {:inline} $srem.i160(i1: i160, i2: i160) returns (i160) { (if ($ne.i160.bool($smod.i160(i1, i2), 0) && $slt.i160.bool(i1, 0)) then $sub.i160($smod.i160(i1, i2), $smax.i160(i2, $sub.i160(0, i2))) else $smod.i160(i1, i2)) }
function {:inline} $srem.i256(i1: i256, i2: i256) returns (i256) { (if ($ne.i256.bool($smod.i256(i1, i2), 0) && $slt.i256.bool(i1, 0)) then $sub.i256($smod.i256(i1, i2), $smax.i256(i2, $sub.i256(0, i2))) else $smod.i256(i1, i2)) }
function {:inline} $urem.i1(i1: i1, i2: i1) returns (i1) { $smod.i1(i1, i2) }
function {:inline} $urem.i5(i1: i5, i2: i5) returns (i5) { $smod.i5(i1, i2) }
function {:inline} $urem.i6(i1: i6, i2: i6) returns (i6) { $smod.i6(i1, i2) }
function {:inline} $urem.i8(i1: i8, i2: i8) returns (i8) { $smod.i8(i1, i2) }
function {:inline} $urem.i16(i1: i16, i2: i16) returns (i16) { $smod.i16(i1, i2) }
function {:inline} $urem.i24(i1: i24, i2: i24) returns (i24) { $smod.i24(i1, i2) }
function {:inline} $urem.i32(i1: i32, i2: i32) returns (i32) { $smod.i32(i1, i2) }
function {:inline} $urem.i40(i1: i40, i2: i40) returns (i40) { $smod.i40(i1, i2) }
function {:inline} $urem.i48(i1: i48, i2: i48) returns (i48) { $smod.i48(i1, i2) }
function {:inline} $urem.i56(i1: i56, i2: i56) returns (i56) { $smod.i56(i1, i2) }
function {:inline} $urem.i64(i1: i64, i2: i64) returns (i64) { $smod.i64(i1, i2) }
function {:inline} $urem.i80(i1: i80, i2: i80) returns (i80) { $smod.i80(i1, i2) }
function {:inline} $urem.i88(i1: i88, i2: i88) returns (i88) { $smod.i88(i1, i2) }
function {:inline} $urem.i96(i1: i96, i2: i96) returns (i96) { $smod.i96(i1, i2) }
function {:inline} $urem.i128(i1: i128, i2: i128) returns (i128) { $smod.i128(i1, i2) }
function {:inline} $urem.i160(i1: i160, i2: i160) returns (i160) { $smod.i160(i1, i2) }
function {:inline} $urem.i256(i1: i256, i2: i256) returns (i256) { $smod.i256(i1, i2) }
function $shl.i1(i1: i1, i2: i1) returns (i1);
function $shl.i5(i1: i5, i2: i5) returns (i5);
function $shl.i6(i1: i6, i2: i6) returns (i6);
function $shl.i8(i1: i8, i2: i8) returns (i8);
function $shl.i16(i1: i16, i2: i16) returns (i16);
function $shl.i24(i1: i24, i2: i24) returns (i24);
function $shl.i32(i1: i32, i2: i32) returns (i32);
function $shl.i40(i1: i40, i2: i40) returns (i40);
function $shl.i48(i1: i48, i2: i48) returns (i48);
function $shl.i56(i1: i56, i2: i56) returns (i56);
function $shl.i64(i1: i64, i2: i64) returns (i64);
function $shl.i80(i1: i80, i2: i80) returns (i80);
function $shl.i88(i1: i88, i2: i88) returns (i88);
function $shl.i96(i1: i96, i2: i96) returns (i96);
function $shl.i128(i1: i128, i2: i128) returns (i128);
function $shl.i160(i1: i160, i2: i160) returns (i160);
function $shl.i256(i1: i256, i2: i256) returns (i256);
function $lshr.i1(i1: i1, i2: i1) returns (i1);
function $lshr.i5(i1: i5, i2: i5) returns (i5);
function $lshr.i6(i1: i6, i2: i6) returns (i6);
function $lshr.i8(i1: i8, i2: i8) returns (i8);
function $lshr.i16(i1: i16, i2: i16) returns (i16);
function $lshr.i24(i1: i24, i2: i24) returns (i24);
function $lshr.i32(i1: i32, i2: i32) returns (i32);
function $lshr.i40(i1: i40, i2: i40) returns (i40);
function $lshr.i48(i1: i48, i2: i48) returns (i48);
function $lshr.i56(i1: i56, i2: i56) returns (i56);
function $lshr.i64(i1: i64, i2: i64) returns (i64);
function $lshr.i80(i1: i80, i2: i80) returns (i80);
function $lshr.i88(i1: i88, i2: i88) returns (i88);
function $lshr.i96(i1: i96, i2: i96) returns (i96);
function $lshr.i128(i1: i128, i2: i128) returns (i128);
function $lshr.i160(i1: i160, i2: i160) returns (i160);
function $lshr.i256(i1: i256, i2: i256) returns (i256);
function $ashr.i1(i1: i1, i2: i1) returns (i1);
function $ashr.i5(i1: i5, i2: i5) returns (i5);
function $ashr.i6(i1: i6, i2: i6) returns (i6);
function $ashr.i8(i1: i8, i2: i8) returns (i8);
function $ashr.i16(i1: i16, i2: i16) returns (i16);
function $ashr.i24(i1: i24, i2: i24) returns (i24);
function $ashr.i32(i1: i32, i2: i32) returns (i32);
function $ashr.i40(i1: i40, i2: i40) returns (i40);
function $ashr.i48(i1: i48, i2: i48) returns (i48);
function $ashr.i56(i1: i56, i2: i56) returns (i56);
function $ashr.i64(i1: i64, i2: i64) returns (i64);
function $ashr.i80(i1: i80, i2: i80) returns (i80);
function $ashr.i88(i1: i88, i2: i88) returns (i88);
function $ashr.i96(i1: i96, i2: i96) returns (i96);
function $ashr.i128(i1: i128, i2: i128) returns (i128);
function $ashr.i160(i1: i160, i2: i160) returns (i160);
function $ashr.i256(i1: i256, i2: i256) returns (i256);
function $and.i1(i1: i1, i2: i1) returns (i1);
function $and.i5(i1: i5, i2: i5) returns (i5);
function $and.i6(i1: i6, i2: i6) returns (i6);
function $and.i8(i1: i8, i2: i8) returns (i8);
function $and.i16(i1: i16, i2: i16) returns (i16);
function $and.i24(i1: i24, i2: i24) returns (i24);
function $and.i32(i1: i32, i2: i32) returns (i32);
function $and.i40(i1: i40, i2: i40) returns (i40);
function $and.i48(i1: i48, i2: i48) returns (i48);
function $and.i56(i1: i56, i2: i56) returns (i56);
function $and.i64(i1: i64, i2: i64) returns (i64);
function $and.i80(i1: i80, i2: i80) returns (i80);
function $and.i88(i1: i88, i2: i88) returns (i88);
function $and.i96(i1: i96, i2: i96) returns (i96);
function $and.i128(i1: i128, i2: i128) returns (i128);
function $and.i160(i1: i160, i2: i160) returns (i160);
function $and.i256(i1: i256, i2: i256) returns (i256);
function $or.i1(i1: i1, i2: i1) returns (i1);
function $or.i5(i1: i5, i2: i5) returns (i5);
function $or.i6(i1: i6, i2: i6) returns (i6);
function $or.i8(i1: i8, i2: i8) returns (i8);
function $or.i16(i1: i16, i2: i16) returns (i16);
function $or.i24(i1: i24, i2: i24) returns (i24);
function $or.i32(i1: i32, i2: i32) returns (i32);
function $or.i40(i1: i40, i2: i40) returns (i40);
function $or.i48(i1: i48, i2: i48) returns (i48);
function $or.i56(i1: i56, i2: i56) returns (i56);
function $or.i64(i1: i64, i2: i64) returns (i64);
function $or.i80(i1: i80, i2: i80) returns (i80);
function $or.i88(i1: i88, i2: i88) returns (i88);
function $or.i96(i1: i96, i2: i96) returns (i96);
function $or.i128(i1: i128, i2: i128) returns (i128);
function $or.i160(i1: i160, i2: i160) returns (i160);
function $or.i256(i1: i256, i2: i256) returns (i256);
function $xor.i1(i1: i1, i2: i1) returns (i1);
function $xor.i5(i1: i5, i2: i5) returns (i5);
function $xor.i6(i1: i6, i2: i6) returns (i6);
function $xor.i8(i1: i8, i2: i8) returns (i8);
function $xor.i16(i1: i16, i2: i16) returns (i16);
function $xor.i24(i1: i24, i2: i24) returns (i24);
function $xor.i32(i1: i32, i2: i32) returns (i32);
function $xor.i40(i1: i40, i2: i40) returns (i40);
function $xor.i48(i1: i48, i2: i48) returns (i48);
function $xor.i56(i1: i56, i2: i56) returns (i56);
function $xor.i64(i1: i64, i2: i64) returns (i64);
function $xor.i80(i1: i80, i2: i80) returns (i80);
function $xor.i88(i1: i88, i2: i88) returns (i88);
function $xor.i96(i1: i96, i2: i96) returns (i96);
function $xor.i128(i1: i128, i2: i128) returns (i128);
function $xor.i160(i1: i160, i2: i160) returns (i160);
function $xor.i256(i1: i256, i2: i256) returns (i256);
function $nand.i1(i1: i1, i2: i1) returns (i1);
function $nand.i5(i1: i5, i2: i5) returns (i5);
function $nand.i6(i1: i6, i2: i6) returns (i6);
function $nand.i8(i1: i8, i2: i8) returns (i8);
function $nand.i16(i1: i16, i2: i16) returns (i16);
function $nand.i24(i1: i24, i2: i24) returns (i24);
function $nand.i32(i1: i32, i2: i32) returns (i32);
function $nand.i40(i1: i40, i2: i40) returns (i40);
function $nand.i48(i1: i48, i2: i48) returns (i48);
function $nand.i56(i1: i56, i2: i56) returns (i56);
function $nand.i64(i1: i64, i2: i64) returns (i64);
function $nand.i80(i1: i80, i2: i80) returns (i80);
function $nand.i88(i1: i88, i2: i88) returns (i88);
function $nand.i96(i1: i96, i2: i96) returns (i96);
function $nand.i128(i1: i128, i2: i128) returns (i128);
function $nand.i160(i1: i160, i2: i160) returns (i160);
function $nand.i256(i1: i256, i2: i256) returns (i256);
function $not.i1(i: i1) returns (i1);
function $not.i5(i: i5) returns (i5);
function $not.i6(i: i6) returns (i6);
function $not.i8(i: i8) returns (i8);
function $not.i16(i: i16) returns (i16);
function $not.i24(i: i24) returns (i24);
function $not.i32(i: i32) returns (i32);
function $not.i40(i: i40) returns (i40);
function $not.i48(i: i48) returns (i48);
function $not.i56(i: i56) returns (i56);
function $not.i64(i: i64) returns (i64);
function $not.i80(i: i80) returns (i80);
function $not.i88(i: i88) returns (i88);
function $not.i96(i: i96) returns (i96);
function $not.i128(i: i128) returns (i128);
function $not.i160(i: i160) returns (i160);
function $not.i256(i: i256) returns (i256);
function {:inline} $smin.i1(i1: i1, i2: i1) returns (i1) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i5(i1: i5, i2: i5) returns (i5) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i6(i1: i6, i2: i6) returns (i6) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i8(i1: i8, i2: i8) returns (i8) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i16(i1: i16, i2: i16) returns (i16) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i24(i1: i24, i2: i24) returns (i24) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i32(i1: i32, i2: i32) returns (i32) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i40(i1: i40, i2: i40) returns (i40) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i48(i1: i48, i2: i48) returns (i48) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i56(i1: i56, i2: i56) returns (i56) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i64(i1: i64, i2: i64) returns (i64) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i80(i1: i80, i2: i80) returns (i80) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i88(i1: i88, i2: i88) returns (i88) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i96(i1: i96, i2: i96) returns (i96) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i128(i1: i128, i2: i128) returns (i128) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i160(i1: i160, i2: i160) returns (i160) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smin.i256(i1: i256, i2: i256) returns (i256) { (if (i1 < i2) then i1 else i2) }
function {:inline} $smax.i1(i1: i1, i2: i1) returns (i1) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i5(i1: i5, i2: i5) returns (i5) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i6(i1: i6, i2: i6) returns (i6) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i8(i1: i8, i2: i8) returns (i8) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i16(i1: i16, i2: i16) returns (i16) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i24(i1: i24, i2: i24) returns (i24) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i32(i1: i32, i2: i32) returns (i32) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i40(i1: i40, i2: i40) returns (i40) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i48(i1: i48, i2: i48) returns (i48) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i56(i1: i56, i2: i56) returns (i56) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i64(i1: i64, i2: i64) returns (i64) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i80(i1: i80, i2: i80) returns (i80) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i88(i1: i88, i2: i88) returns (i88) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i96(i1: i96, i2: i96) returns (i96) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i128(i1: i128, i2: i128) returns (i128) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i160(i1: i160, i2: i160) returns (i160) { (if (i2 < i1) then i1 else i2) }
function {:inline} $smax.i256(i1: i256, i2: i256) returns (i256) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umin.i1(i1: i1, i2: i1) returns (i1) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i5(i1: i5, i2: i5) returns (i5) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i6(i1: i6, i2: i6) returns (i6) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i8(i1: i8, i2: i8) returns (i8) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i16(i1: i16, i2: i16) returns (i16) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i24(i1: i24, i2: i24) returns (i24) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i32(i1: i32, i2: i32) returns (i32) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i40(i1: i40, i2: i40) returns (i40) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i48(i1: i48, i2: i48) returns (i48) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i56(i1: i56, i2: i56) returns (i56) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i64(i1: i64, i2: i64) returns (i64) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i80(i1: i80, i2: i80) returns (i80) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i88(i1: i88, i2: i88) returns (i88) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i96(i1: i96, i2: i96) returns (i96) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i128(i1: i128, i2: i128) returns (i128) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i160(i1: i160, i2: i160) returns (i160) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umin.i256(i1: i256, i2: i256) returns (i256) { (if (i1 < i2) then i1 else i2) }
function {:inline} $umax.i1(i1: i1, i2: i1) returns (i1) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i5(i1: i5, i2: i5) returns (i5) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i6(i1: i6, i2: i6) returns (i6) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i8(i1: i8, i2: i8) returns (i8) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i16(i1: i16, i2: i16) returns (i16) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i24(i1: i24, i2: i24) returns (i24) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i32(i1: i32, i2: i32) returns (i32) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i40(i1: i40, i2: i40) returns (i40) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i48(i1: i48, i2: i48) returns (i48) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i56(i1: i56, i2: i56) returns (i56) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i64(i1: i64, i2: i64) returns (i64) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i80(i1: i80, i2: i80) returns (i80) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i88(i1: i88, i2: i88) returns (i88) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i96(i1: i96, i2: i96) returns (i96) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i128(i1: i128, i2: i128) returns (i128) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i160(i1: i160, i2: i160) returns (i160) { (if (i2 < i1) then i1 else i2) }
function {:inline} $umax.i256(i1: i256, i2: i256) returns (i256) { (if (i2 < i1) then i1 else i2) }
axiom ($and.i1(0, 0) == 0);
axiom ($or.i1(0, 0) == 0);
axiom ($xor.i1(0, 0) == 0);
axiom ($and.i1(0, 1) == 0);
axiom ($or.i1(0, 1) == 1);
axiom ($xor.i1(0, 1) == 1);
axiom ($and.i1(1, 0) == 0);
axiom ($or.i1(1, 0) == 1);
axiom ($xor.i1(1, 0) == 1);
axiom ($and.i1(1, 1) == 1);
axiom ($or.i1(1, 1) == 1);
axiom ($xor.i1(1, 1) == 0);
axiom ($and.i32(32, 16) == 0);
// Integer predicates
function {:inline} $ule.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i1(i1: i1, i2: i1) returns (i1) { (if $ule.i1.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i5(i1: i5, i2: i5) returns (i1) { (if $ule.i5.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i6(i1: i6, i2: i6) returns (i1) { (if $ule.i6.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i8(i1: i8, i2: i8) returns (i1) { (if $ule.i8.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i16(i1: i16, i2: i16) returns (i1) { (if $ule.i16.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i24(i1: i24, i2: i24) returns (i1) { (if $ule.i24.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i32(i1: i32, i2: i32) returns (i1) { (if $ule.i32.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i40(i1: i40, i2: i40) returns (i1) { (if $ule.i40.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i48(i1: i48, i2: i48) returns (i1) { (if $ule.i48.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i56(i1: i56, i2: i56) returns (i1) { (if $ule.i56.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i64(i1: i64, i2: i64) returns (i1) { (if $ule.i64.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i80(i1: i80, i2: i80) returns (i1) { (if $ule.i80.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i88(i1: i88, i2: i88) returns (i1) { (if $ule.i88.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i96(i1: i96, i2: i96) returns (i1) { (if $ule.i96.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i128(i1: i128, i2: i128) returns (i1) { (if $ule.i128.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i160(i1: i160, i2: i160) returns (i1) { (if $ule.i160.bool(i1, i2) then 1 else 0) }
function {:inline} $ule.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i256(i1: i256, i2: i256) returns (i1) { (if $ule.i256.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 < i2) }
function {:inline} $ult.i1(i1: i1, i2: i1) returns (i1) { (if $ult.i1.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 < i2) }
function {:inline} $ult.i5(i1: i5, i2: i5) returns (i1) { (if $ult.i5.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 < i2) }
function {:inline} $ult.i6(i1: i6, i2: i6) returns (i1) { (if $ult.i6.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 < i2) }
function {:inline} $ult.i8(i1: i8, i2: i8) returns (i1) { (if $ult.i8.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 < i2) }
function {:inline} $ult.i16(i1: i16, i2: i16) returns (i1) { (if $ult.i16.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 < i2) }
function {:inline} $ult.i24(i1: i24, i2: i24) returns (i1) { (if $ult.i24.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 < i2) }
function {:inline} $ult.i32(i1: i32, i2: i32) returns (i1) { (if $ult.i32.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 < i2) }
function {:inline} $ult.i40(i1: i40, i2: i40) returns (i1) { (if $ult.i40.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 < i2) }
function {:inline} $ult.i48(i1: i48, i2: i48) returns (i1) { (if $ult.i48.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 < i2) }
function {:inline} $ult.i56(i1: i56, i2: i56) returns (i1) { (if $ult.i56.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 < i2) }
function {:inline} $ult.i64(i1: i64, i2: i64) returns (i1) { (if $ult.i64.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 < i2) }
function {:inline} $ult.i80(i1: i80, i2: i80) returns (i1) { (if $ult.i80.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 < i2) }
function {:inline} $ult.i88(i1: i88, i2: i88) returns (i1) { (if $ult.i88.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 < i2) }
function {:inline} $ult.i96(i1: i96, i2: i96) returns (i1) { (if $ult.i96.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 < i2) }
function {:inline} $ult.i128(i1: i128, i2: i128) returns (i1) { (if $ult.i128.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 < i2) }
function {:inline} $ult.i160(i1: i160, i2: i160) returns (i1) { (if $ult.i160.bool(i1, i2) then 1 else 0) }
function {:inline} $ult.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 < i2) }
function {:inline} $ult.i256(i1: i256, i2: i256) returns (i1) { (if $ult.i256.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i1(i1: i1, i2: i1) returns (i1) { (if $uge.i1.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i5(i1: i5, i2: i5) returns (i1) { (if $uge.i5.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i6(i1: i6, i2: i6) returns (i1) { (if $uge.i6.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i8(i1: i8, i2: i8) returns (i1) { (if $uge.i8.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i16(i1: i16, i2: i16) returns (i1) { (if $uge.i16.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i24(i1: i24, i2: i24) returns (i1) { (if $uge.i24.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i32(i1: i32, i2: i32) returns (i1) { (if $uge.i32.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i40(i1: i40, i2: i40) returns (i1) { (if $uge.i40.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i48(i1: i48, i2: i48) returns (i1) { (if $uge.i48.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i56(i1: i56, i2: i56) returns (i1) { (if $uge.i56.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i64(i1: i64, i2: i64) returns (i1) { (if $uge.i64.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i80(i1: i80, i2: i80) returns (i1) { (if $uge.i80.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i88(i1: i88, i2: i88) returns (i1) { (if $uge.i88.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i96(i1: i96, i2: i96) returns (i1) { (if $uge.i96.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i128(i1: i128, i2: i128) returns (i1) { (if $uge.i128.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i160(i1: i160, i2: i160) returns (i1) { (if $uge.i160.bool(i1, i2) then 1 else 0) }
function {:inline} $uge.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i256(i1: i256, i2: i256) returns (i1) { (if $uge.i256.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i1(i1: i1, i2: i1) returns (i1) { (if $ugt.i1.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i5(i1: i5, i2: i5) returns (i1) { (if $ugt.i5.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i6(i1: i6, i2: i6) returns (i1) { (if $ugt.i6.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i8(i1: i8, i2: i8) returns (i1) { (if $ugt.i8.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i16(i1: i16, i2: i16) returns (i1) { (if $ugt.i16.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i24(i1: i24, i2: i24) returns (i1) { (if $ugt.i24.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i32(i1: i32, i2: i32) returns (i1) { (if $ugt.i32.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i40(i1: i40, i2: i40) returns (i1) { (if $ugt.i40.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i48(i1: i48, i2: i48) returns (i1) { (if $ugt.i48.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i56(i1: i56, i2: i56) returns (i1) { (if $ugt.i56.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i64(i1: i64, i2: i64) returns (i1) { (if $ugt.i64.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i80(i1: i80, i2: i80) returns (i1) { (if $ugt.i80.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i88(i1: i88, i2: i88) returns (i1) { (if $ugt.i88.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i96(i1: i96, i2: i96) returns (i1) { (if $ugt.i96.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i128(i1: i128, i2: i128) returns (i1) { (if $ugt.i128.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i160(i1: i160, i2: i160) returns (i1) { (if $ugt.i160.bool(i1, i2) then 1 else 0) }
function {:inline} $ugt.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i256(i1: i256, i2: i256) returns (i1) { (if $ugt.i256.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i1(i1: i1, i2: i1) returns (i1) { (if $sle.i1.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i5(i1: i5, i2: i5) returns (i1) { (if $sle.i5.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i6(i1: i6, i2: i6) returns (i1) { (if $sle.i6.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i8(i1: i8, i2: i8) returns (i1) { (if $sle.i8.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i16(i1: i16, i2: i16) returns (i1) { (if $sle.i16.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i24(i1: i24, i2: i24) returns (i1) { (if $sle.i24.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i32(i1: i32, i2: i32) returns (i1) { (if $sle.i32.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i40(i1: i40, i2: i40) returns (i1) { (if $sle.i40.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i48(i1: i48, i2: i48) returns (i1) { (if $sle.i48.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i56(i1: i56, i2: i56) returns (i1) { (if $sle.i56.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i64(i1: i64, i2: i64) returns (i1) { (if $sle.i64.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i80(i1: i80, i2: i80) returns (i1) { (if $sle.i80.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i88(i1: i88, i2: i88) returns (i1) { (if $sle.i88.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i96(i1: i96, i2: i96) returns (i1) { (if $sle.i96.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i128(i1: i128, i2: i128) returns (i1) { (if $sle.i128.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i160(i1: i160, i2: i160) returns (i1) { (if $sle.i160.bool(i1, i2) then 1 else 0) }
function {:inline} $sle.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i256(i1: i256, i2: i256) returns (i1) { (if $sle.i256.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 < i2) }
function {:inline} $slt.i1(i1: i1, i2: i1) returns (i1) { (if $slt.i1.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 < i2) }
function {:inline} $slt.i5(i1: i5, i2: i5) returns (i1) { (if $slt.i5.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 < i2) }
function {:inline} $slt.i6(i1: i6, i2: i6) returns (i1) { (if $slt.i6.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 < i2) }
function {:inline} $slt.i8(i1: i8, i2: i8) returns (i1) { (if $slt.i8.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 < i2) }
function {:inline} $slt.i16(i1: i16, i2: i16) returns (i1) { (if $slt.i16.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 < i2) }
function {:inline} $slt.i24(i1: i24, i2: i24) returns (i1) { (if $slt.i24.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 < i2) }
function {:inline} $slt.i32(i1: i32, i2: i32) returns (i1) { (if $slt.i32.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 < i2) }
function {:inline} $slt.i40(i1: i40, i2: i40) returns (i1) { (if $slt.i40.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 < i2) }
function {:inline} $slt.i48(i1: i48, i2: i48) returns (i1) { (if $slt.i48.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 < i2) }
function {:inline} $slt.i56(i1: i56, i2: i56) returns (i1) { (if $slt.i56.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 < i2) }
function {:inline} $slt.i64(i1: i64, i2: i64) returns (i1) { (if $slt.i64.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 < i2) }
function {:inline} $slt.i80(i1: i80, i2: i80) returns (i1) { (if $slt.i80.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 < i2) }
function {:inline} $slt.i88(i1: i88, i2: i88) returns (i1) { (if $slt.i88.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 < i2) }
function {:inline} $slt.i96(i1: i96, i2: i96) returns (i1) { (if $slt.i96.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 < i2) }
function {:inline} $slt.i128(i1: i128, i2: i128) returns (i1) { (if $slt.i128.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 < i2) }
function {:inline} $slt.i160(i1: i160, i2: i160) returns (i1) { (if $slt.i160.bool(i1, i2) then 1 else 0) }
function {:inline} $slt.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 < i2) }
function {:inline} $slt.i256(i1: i256, i2: i256) returns (i1) { (if $slt.i256.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i1(i1: i1, i2: i1) returns (i1) { (if $sge.i1.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i5(i1: i5, i2: i5) returns (i1) { (if $sge.i5.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i6(i1: i6, i2: i6) returns (i1) { (if $sge.i6.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i8(i1: i8, i2: i8) returns (i1) { (if $sge.i8.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i16(i1: i16, i2: i16) returns (i1) { (if $sge.i16.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i24(i1: i24, i2: i24) returns (i1) { (if $sge.i24.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i32(i1: i32, i2: i32) returns (i1) { (if $sge.i32.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i40(i1: i40, i2: i40) returns (i1) { (if $sge.i40.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i48(i1: i48, i2: i48) returns (i1) { (if $sge.i48.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i56(i1: i56, i2: i56) returns (i1) { (if $sge.i56.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i64(i1: i64, i2: i64) returns (i1) { (if $sge.i64.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i80(i1: i80, i2: i80) returns (i1) { (if $sge.i80.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i88(i1: i88, i2: i88) returns (i1) { (if $sge.i88.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i96(i1: i96, i2: i96) returns (i1) { (if $sge.i96.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i128(i1: i128, i2: i128) returns (i1) { (if $sge.i128.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i160(i1: i160, i2: i160) returns (i1) { (if $sge.i160.bool(i1, i2) then 1 else 0) }
function {:inline} $sge.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i256(i1: i256, i2: i256) returns (i1) { (if $sge.i256.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i1(i1: i1, i2: i1) returns (i1) { (if $sgt.i1.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i5(i1: i5, i2: i5) returns (i1) { (if $sgt.i5.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i6(i1: i6, i2: i6) returns (i1) { (if $sgt.i6.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i8(i1: i8, i2: i8) returns (i1) { (if $sgt.i8.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i16(i1: i16, i2: i16) returns (i1) { (if $sgt.i16.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i24(i1: i24, i2: i24) returns (i1) { (if $sgt.i24.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i32(i1: i32, i2: i32) returns (i1) { (if $sgt.i32.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i40(i1: i40, i2: i40) returns (i1) { (if $sgt.i40.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i48(i1: i48, i2: i48) returns (i1) { (if $sgt.i48.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i56(i1: i56, i2: i56) returns (i1) { (if $sgt.i56.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i64(i1: i64, i2: i64) returns (i1) { (if $sgt.i64.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i80(i1: i80, i2: i80) returns (i1) { (if $sgt.i80.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i88(i1: i88, i2: i88) returns (i1) { (if $sgt.i88.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i96(i1: i96, i2: i96) returns (i1) { (if $sgt.i96.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i128(i1: i128, i2: i128) returns (i1) { (if $sgt.i128.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i160(i1: i160, i2: i160) returns (i1) { (if $sgt.i160.bool(i1, i2) then 1 else 0) }
function {:inline} $sgt.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i256(i1: i256, i2: i256) returns (i1) { (if $sgt.i256.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 == i2) }
function {:inline} $eq.i1(i1: i1, i2: i1) returns (i1) { (if $eq.i1.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 == i2) }
function {:inline} $eq.i5(i1: i5, i2: i5) returns (i1) { (if $eq.i5.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 == i2) }
function {:inline} $eq.i6(i1: i6, i2: i6) returns (i1) { (if $eq.i6.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 == i2) }
function {:inline} $eq.i8(i1: i8, i2: i8) returns (i1) { (if $eq.i8.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 == i2) }
function {:inline} $eq.i16(i1: i16, i2: i16) returns (i1) { (if $eq.i16.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 == i2) }
function {:inline} $eq.i24(i1: i24, i2: i24) returns (i1) { (if $eq.i24.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 == i2) }
function {:inline} $eq.i32(i1: i32, i2: i32) returns (i1) { (if $eq.i32.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 == i2) }
function {:inline} $eq.i40(i1: i40, i2: i40) returns (i1) { (if $eq.i40.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 == i2) }
function {:inline} $eq.i48(i1: i48, i2: i48) returns (i1) { (if $eq.i48.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 == i2) }
function {:inline} $eq.i56(i1: i56, i2: i56) returns (i1) { (if $eq.i56.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 == i2) }
function {:inline} $eq.i64(i1: i64, i2: i64) returns (i1) { (if $eq.i64.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 == i2) }
function {:inline} $eq.i80(i1: i80, i2: i80) returns (i1) { (if $eq.i80.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 == i2) }
function {:inline} $eq.i88(i1: i88, i2: i88) returns (i1) { (if $eq.i88.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 == i2) }
function {:inline} $eq.i96(i1: i96, i2: i96) returns (i1) { (if $eq.i96.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 == i2) }
function {:inline} $eq.i128(i1: i128, i2: i128) returns (i1) { (if $eq.i128.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 == i2) }
function {:inline} $eq.i160(i1: i160, i2: i160) returns (i1) { (if $eq.i160.bool(i1, i2) then 1 else 0) }
function {:inline} $eq.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 == i2) }
function {:inline} $eq.i256(i1: i256, i2: i256) returns (i1) { (if $eq.i256.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 != i2) }
function {:inline} $ne.i1(i1: i1, i2: i1) returns (i1) { (if $ne.i1.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 != i2) }
function {:inline} $ne.i5(i1: i5, i2: i5) returns (i1) { (if $ne.i5.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 != i2) }
function {:inline} $ne.i6(i1: i6, i2: i6) returns (i1) { (if $ne.i6.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 != i2) }
function {:inline} $ne.i8(i1: i8, i2: i8) returns (i1) { (if $ne.i8.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 != i2) }
function {:inline} $ne.i16(i1: i16, i2: i16) returns (i1) { (if $ne.i16.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 != i2) }
function {:inline} $ne.i24(i1: i24, i2: i24) returns (i1) { (if $ne.i24.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 != i2) }
function {:inline} $ne.i32(i1: i32, i2: i32) returns (i1) { (if $ne.i32.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 != i2) }
function {:inline} $ne.i40(i1: i40, i2: i40) returns (i1) { (if $ne.i40.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 != i2) }
function {:inline} $ne.i48(i1: i48, i2: i48) returns (i1) { (if $ne.i48.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 != i2) }
function {:inline} $ne.i56(i1: i56, i2: i56) returns (i1) { (if $ne.i56.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 != i2) }
function {:inline} $ne.i64(i1: i64, i2: i64) returns (i1) { (if $ne.i64.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 != i2) }
function {:inline} $ne.i80(i1: i80, i2: i80) returns (i1) { (if $ne.i80.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 != i2) }
function {:inline} $ne.i88(i1: i88, i2: i88) returns (i1) { (if $ne.i88.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 != i2) }
function {:inline} $ne.i96(i1: i96, i2: i96) returns (i1) { (if $ne.i96.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 != i2) }
function {:inline} $ne.i128(i1: i128, i2: i128) returns (i1) { (if $ne.i128.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 != i2) }
function {:inline} $ne.i160(i1: i160, i2: i160) returns (i1) { (if $ne.i160.bool(i1, i2) then 1 else 0) }
function {:inline} $ne.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 != i2) }
function {:inline} $ne.i256(i1: i256, i2: i256) returns (i1) { (if $ne.i256.bool(i1, i2) then 1 else 0) }
// Integer load/store operations
function {:inline} $load.i1(M: [ref] i1, p: ref) returns (i1) { M[p] }
function {:inline} $store.i1(M: [ref] i1, p: ref, i: i1) returns ([ref] i1) { M[p := i] }
function {:inline} $load.i5(M: [ref] i5, p: ref) returns (i5) { M[p] }
function {:inline} $store.i5(M: [ref] i5, p: ref, i: i5) returns ([ref] i5) { M[p := i] }
function {:inline} $load.i6(M: [ref] i6, p: ref) returns (i6) { M[p] }
function {:inline} $store.i6(M: [ref] i6, p: ref, i: i6) returns ([ref] i6) { M[p := i] }
function {:inline} $load.i8(M: [ref] i8, p: ref) returns (i8) { M[p] }
function {:inline} $store.i8(M: [ref] i8, p: ref, i: i8) returns ([ref] i8) { M[p := i] }
function {:inline} $load.i16(M: [ref] i16, p: ref) returns (i16) { M[p] }
function {:inline} $store.i16(M: [ref] i16, p: ref, i: i16) returns ([ref] i16) { M[p := i] }
function {:inline} $load.i24(M: [ref] i24, p: ref) returns (i24) { M[p] }
function {:inline} $store.i24(M: [ref] i24, p: ref, i: i24) returns ([ref] i24) { M[p := i] }
function {:inline} $load.i32(M: [ref] i32, p: ref) returns (i32) { M[p] }
function {:inline} $store.i32(M: [ref] i32, p: ref, i: i32) returns ([ref] i32) { M[p := i] }
function {:inline} $load.i40(M: [ref] i40, p: ref) returns (i40) { M[p] }
function {:inline} $store.i40(M: [ref] i40, p: ref, i: i40) returns ([ref] i40) { M[p := i] }
function {:inline} $load.i48(M: [ref] i48, p: ref) returns (i48) { M[p] }
function {:inline} $store.i48(M: [ref] i48, p: ref, i: i48) returns ([ref] i48) { M[p := i] }
function {:inline} $load.i56(M: [ref] i56, p: ref) returns (i56) { M[p] }
function {:inline} $store.i56(M: [ref] i56, p: ref, i: i56) returns ([ref] i56) { M[p := i] }
function {:inline} $load.i64(M: [ref] i64, p: ref) returns (i64) { M[p] }
function {:inline} $store.i64(M: [ref] i64, p: ref, i: i64) returns ([ref] i64) { M[p := i] }
function {:inline} $load.i80(M: [ref] i80, p: ref) returns (i80) { M[p] }
function {:inline} $store.i80(M: [ref] i80, p: ref, i: i80) returns ([ref] i80) { M[p := i] }
function {:inline} $load.i88(M: [ref] i88, p: ref) returns (i88) { M[p] }
function {:inline} $store.i88(M: [ref] i88, p: ref, i: i88) returns ([ref] i88) { M[p := i] }
function {:inline} $load.i96(M: [ref] i96, p: ref) returns (i96) { M[p] }
function {:inline} $store.i96(M: [ref] i96, p: ref, i: i96) returns ([ref] i96) { M[p := i] }
function {:inline} $load.i128(M: [ref] i128, p: ref) returns (i128) { M[p] }
function {:inline} $store.i128(M: [ref] i128, p: ref, i: i128) returns ([ref] i128) { M[p := i] }
function {:inline} $load.i160(M: [ref] i160, p: ref) returns (i160) { M[p] }
function {:inline} $store.i160(M: [ref] i160, p: ref, i: i160) returns ([ref] i160) { M[p := i] }
function {:inline} $load.i256(M: [ref] i256, p: ref) returns (i256) { M[p] }
function {:inline} $store.i256(M: [ref] i256, p: ref, i: i256) returns ([ref] i256) { M[p := i] }
// Conversion between integer types
function {:inline} $trunc.i5.i1(i: i5) returns (i1) { i }
function {:inline} $trunc.i6.i1(i: i6) returns (i1) { i }
function {:inline} $trunc.i8.i1(i: i8) returns (i1) { i }
function {:inline} $trunc.i16.i1(i: i16) returns (i1) { i }
function {:inline} $trunc.i24.i1(i: i24) returns (i1) { i }
function {:inline} $trunc.i32.i1(i: i32) returns (i1) { i }
function {:inline} $trunc.i40.i1(i: i40) returns (i1) { i }
function {:inline} $trunc.i48.i1(i: i48) returns (i1) { i }
function {:inline} $trunc.i56.i1(i: i56) returns (i1) { i }
function {:inline} $trunc.i64.i1(i: i64) returns (i1) { i }
function {:inline} $trunc.i80.i1(i: i80) returns (i1) { i }
function {:inline} $trunc.i88.i1(i: i88) returns (i1) { i }
function {:inline} $trunc.i96.i1(i: i96) returns (i1) { i }
function {:inline} $trunc.i128.i1(i: i128) returns (i1) { i }
function {:inline} $trunc.i160.i1(i: i160) returns (i1) { i }
function {:inline} $trunc.i256.i1(i: i256) returns (i1) { i }
function {:inline} $trunc.i6.i5(i: i6) returns (i5) { i }
function {:inline} $trunc.i8.i5(i: i8) returns (i5) { i }
function {:inline} $trunc.i16.i5(i: i16) returns (i5) { i }
function {:inline} $trunc.i24.i5(i: i24) returns (i5) { i }
function {:inline} $trunc.i32.i5(i: i32) returns (i5) { i }
function {:inline} $trunc.i40.i5(i: i40) returns (i5) { i }
function {:inline} $trunc.i48.i5(i: i48) returns (i5) { i }
function {:inline} $trunc.i56.i5(i: i56) returns (i5) { i }
function {:inline} $trunc.i64.i5(i: i64) returns (i5) { i }
function {:inline} $trunc.i80.i5(i: i80) returns (i5) { i }
function {:inline} $trunc.i88.i5(i: i88) returns (i5) { i }
function {:inline} $trunc.i96.i5(i: i96) returns (i5) { i }
function {:inline} $trunc.i128.i5(i: i128) returns (i5) { i }
function {:inline} $trunc.i160.i5(i: i160) returns (i5) { i }
function {:inline} $trunc.i256.i5(i: i256) returns (i5) { i }
function {:inline} $trunc.i8.i6(i: i8) returns (i6) { i }
function {:inline} $trunc.i16.i6(i: i16) returns (i6) { i }
function {:inline} $trunc.i24.i6(i: i24) returns (i6) { i }
function {:inline} $trunc.i32.i6(i: i32) returns (i6) { i }
function {:inline} $trunc.i40.i6(i: i40) returns (i6) { i }
function {:inline} $trunc.i48.i6(i: i48) returns (i6) { i }
function {:inline} $trunc.i56.i6(i: i56) returns (i6) { i }
function {:inline} $trunc.i64.i6(i: i64) returns (i6) { i }
function {:inline} $trunc.i80.i6(i: i80) returns (i6) { i }
function {:inline} $trunc.i88.i6(i: i88) returns (i6) { i }
function {:inline} $trunc.i96.i6(i: i96) returns (i6) { i }
function {:inline} $trunc.i128.i6(i: i128) returns (i6) { i }
function {:inline} $trunc.i160.i6(i: i160) returns (i6) { i }
function {:inline} $trunc.i256.i6(i: i256) returns (i6) { i }
function {:inline} $trunc.i16.i8(i: i16) returns (i8) { i }
function {:inline} $trunc.i24.i8(i: i24) returns (i8) { i }
function {:inline} $trunc.i32.i8(i: i32) returns (i8) { i }
function {:inline} $trunc.i40.i8(i: i40) returns (i8) { i }
function {:inline} $trunc.i48.i8(i: i48) returns (i8) { i }
function {:inline} $trunc.i56.i8(i: i56) returns (i8) { i }
function {:inline} $trunc.i64.i8(i: i64) returns (i8) { i }
function {:inline} $trunc.i80.i8(i: i80) returns (i8) { i }
function {:inline} $trunc.i88.i8(i: i88) returns (i8) { i }
function {:inline} $trunc.i96.i8(i: i96) returns (i8) { i }
function {:inline} $trunc.i128.i8(i: i128) returns (i8) { i }
function {:inline} $trunc.i160.i8(i: i160) returns (i8) { i }
function {:inline} $trunc.i256.i8(i: i256) returns (i8) { i }
function {:inline} $trunc.i24.i16(i: i24) returns (i16) { i }
function {:inline} $trunc.i32.i16(i: i32) returns (i16) { i }
function {:inline} $trunc.i40.i16(i: i40) returns (i16) { i }
function {:inline} $trunc.i48.i16(i: i48) returns (i16) { i }
function {:inline} $trunc.i56.i16(i: i56) returns (i16) { i }
function {:inline} $trunc.i64.i16(i: i64) returns (i16) { i }
function {:inline} $trunc.i80.i16(i: i80) returns (i16) { i }
function {:inline} $trunc.i88.i16(i: i88) returns (i16) { i }
function {:inline} $trunc.i96.i16(i: i96) returns (i16) { i }
function {:inline} $trunc.i128.i16(i: i128) returns (i16) { i }
function {:inline} $trunc.i160.i16(i: i160) returns (i16) { i }
function {:inline} $trunc.i256.i16(i: i256) returns (i16) { i }
function {:inline} $trunc.i32.i24(i: i32) returns (i24) { i }
function {:inline} $trunc.i40.i24(i: i40) returns (i24) { i }
function {:inline} $trunc.i48.i24(i: i48) returns (i24) { i }
function {:inline} $trunc.i56.i24(i: i56) returns (i24) { i }
function {:inline} $trunc.i64.i24(i: i64) returns (i24) { i }
function {:inline} $trunc.i80.i24(i: i80) returns (i24) { i }
function {:inline} $trunc.i88.i24(i: i88) returns (i24) { i }
function {:inline} $trunc.i96.i24(i: i96) returns (i24) { i }
function {:inline} $trunc.i128.i24(i: i128) returns (i24) { i }
function {:inline} $trunc.i160.i24(i: i160) returns (i24) { i }
function {:inline} $trunc.i256.i24(i: i256) returns (i24) { i }
function {:inline} $trunc.i40.i32(i: i40) returns (i32) { i }
function {:inline} $trunc.i48.i32(i: i48) returns (i32) { i }
function {:inline} $trunc.i56.i32(i: i56) returns (i32) { i }
function {:inline} $trunc.i64.i32(i: i64) returns (i32) { i }
function {:inline} $trunc.i80.i32(i: i80) returns (i32) { i }
function {:inline} $trunc.i88.i32(i: i88) returns (i32) { i }
function {:inline} $trunc.i96.i32(i: i96) returns (i32) { i }
function {:inline} $trunc.i128.i32(i: i128) returns (i32) { i }
function {:inline} $trunc.i160.i32(i: i160) returns (i32) { i }
function {:inline} $trunc.i256.i32(i: i256) returns (i32) { i }
function {:inline} $trunc.i48.i40(i: i48) returns (i40) { i }
function {:inline} $trunc.i56.i40(i: i56) returns (i40) { i }
function {:inline} $trunc.i64.i40(i: i64) returns (i40) { i }
function {:inline} $trunc.i80.i40(i: i80) returns (i40) { i }
function {:inline} $trunc.i88.i40(i: i88) returns (i40) { i }
function {:inline} $trunc.i96.i40(i: i96) returns (i40) { i }
function {:inline} $trunc.i128.i40(i: i128) returns (i40) { i }
function {:inline} $trunc.i160.i40(i: i160) returns (i40) { i }
function {:inline} $trunc.i256.i40(i: i256) returns (i40) { i }
function {:inline} $trunc.i56.i48(i: i56) returns (i48) { i }
function {:inline} $trunc.i64.i48(i: i64) returns (i48) { i }
function {:inline} $trunc.i80.i48(i: i80) returns (i48) { i }
function {:inline} $trunc.i88.i48(i: i88) returns (i48) { i }
function {:inline} $trunc.i96.i48(i: i96) returns (i48) { i }
function {:inline} $trunc.i128.i48(i: i128) returns (i48) { i }
function {:inline} $trunc.i160.i48(i: i160) returns (i48) { i }
function {:inline} $trunc.i256.i48(i: i256) returns (i48) { i }
function {:inline} $trunc.i64.i56(i: i64) returns (i56) { i }
function {:inline} $trunc.i80.i56(i: i80) returns (i56) { i }
function {:inline} $trunc.i88.i56(i: i88) returns (i56) { i }
function {:inline} $trunc.i96.i56(i: i96) returns (i56) { i }
function {:inline} $trunc.i128.i56(i: i128) returns (i56) { i }
function {:inline} $trunc.i160.i56(i: i160) returns (i56) { i }
function {:inline} $trunc.i256.i56(i: i256) returns (i56) { i }
function {:inline} $trunc.i80.i64(i: i80) returns (i64) { i }
function {:inline} $trunc.i88.i64(i: i88) returns (i64) { i }
function {:inline} $trunc.i96.i64(i: i96) returns (i64) { i }
function {:inline} $trunc.i128.i64(i: i128) returns (i64) { i }
function {:inline} $trunc.i160.i64(i: i160) returns (i64) { i }
function {:inline} $trunc.i256.i64(i: i256) returns (i64) { i }
function {:inline} $trunc.i88.i80(i: i88) returns (i80) { i }
function {:inline} $trunc.i96.i80(i: i96) returns (i80) { i }
function {:inline} $trunc.i128.i80(i: i128) returns (i80) { i }
function {:inline} $trunc.i160.i80(i: i160) returns (i80) { i }
function {:inline} $trunc.i256.i80(i: i256) returns (i80) { i }
function {:inline} $trunc.i96.i88(i: i96) returns (i88) { i }
function {:inline} $trunc.i128.i88(i: i128) returns (i88) { i }
function {:inline} $trunc.i160.i88(i: i160) returns (i88) { i }
function {:inline} $trunc.i256.i88(i: i256) returns (i88) { i }
function {:inline} $trunc.i128.i96(i: i128) returns (i96) { i }
function {:inline} $trunc.i160.i96(i: i160) returns (i96) { i }
function {:inline} $trunc.i256.i96(i: i256) returns (i96) { i }
function {:inline} $trunc.i160.i128(i: i160) returns (i128) { i }
function {:inline} $trunc.i256.i128(i: i256) returns (i128) { i }
function {:inline} $trunc.i256.i160(i: i256) returns (i160) { i }
function {:inline} $sext.i1.i5(i: i1) returns (i5) { i }
function {:inline} $sext.i1.i6(i: i1) returns (i6) { i }
function {:inline} $sext.i1.i8(i: i1) returns (i8) { i }
function {:inline} $sext.i1.i16(i: i1) returns (i16) { i }
function {:inline} $sext.i1.i24(i: i1) returns (i24) { i }
function {:inline} $sext.i1.i32(i: i1) returns (i32) { i }
function {:inline} $sext.i1.i40(i: i1) returns (i40) { i }
function {:inline} $sext.i1.i48(i: i1) returns (i48) { i }
function {:inline} $sext.i1.i56(i: i1) returns (i56) { i }
function {:inline} $sext.i1.i64(i: i1) returns (i64) { i }
function {:inline} $sext.i1.i80(i: i1) returns (i80) { i }
function {:inline} $sext.i1.i88(i: i1) returns (i88) { i }
function {:inline} $sext.i1.i96(i: i1) returns (i96) { i }
function {:inline} $sext.i1.i128(i: i1) returns (i128) { i }
function {:inline} $sext.i1.i160(i: i1) returns (i160) { i }
function {:inline} $sext.i1.i256(i: i1) returns (i256) { i }
function {:inline} $sext.i5.i6(i: i5) returns (i6) { i }
function {:inline} $sext.i5.i8(i: i5) returns (i8) { i }
function {:inline} $sext.i5.i16(i: i5) returns (i16) { i }
function {:inline} $sext.i5.i24(i: i5) returns (i24) { i }
function {:inline} $sext.i5.i32(i: i5) returns (i32) { i }
function {:inline} $sext.i5.i40(i: i5) returns (i40) { i }
function {:inline} $sext.i5.i48(i: i5) returns (i48) { i }
function {:inline} $sext.i5.i56(i: i5) returns (i56) { i }
function {:inline} $sext.i5.i64(i: i5) returns (i64) { i }
function {:inline} $sext.i5.i80(i: i5) returns (i80) { i }
function {:inline} $sext.i5.i88(i: i5) returns (i88) { i }
function {:inline} $sext.i5.i96(i: i5) returns (i96) { i }
function {:inline} $sext.i5.i128(i: i5) returns (i128) { i }
function {:inline} $sext.i5.i160(i: i5) returns (i160) { i }
function {:inline} $sext.i5.i256(i: i5) returns (i256) { i }
function {:inline} $sext.i6.i8(i: i6) returns (i8) { i }
function {:inline} $sext.i6.i16(i: i6) returns (i16) { i }
function {:inline} $sext.i6.i24(i: i6) returns (i24) { i }
function {:inline} $sext.i6.i32(i: i6) returns (i32) { i }
function {:inline} $sext.i6.i40(i: i6) returns (i40) { i }
function {:inline} $sext.i6.i48(i: i6) returns (i48) { i }
function {:inline} $sext.i6.i56(i: i6) returns (i56) { i }
function {:inline} $sext.i6.i64(i: i6) returns (i64) { i }
function {:inline} $sext.i6.i80(i: i6) returns (i80) { i }
function {:inline} $sext.i6.i88(i: i6) returns (i88) { i }
function {:inline} $sext.i6.i96(i: i6) returns (i96) { i }
function {:inline} $sext.i6.i128(i: i6) returns (i128) { i }
function {:inline} $sext.i6.i160(i: i6) returns (i160) { i }
function {:inline} $sext.i6.i256(i: i6) returns (i256) { i }
function {:inline} $sext.i8.i16(i: i8) returns (i16) { i }
function {:inline} $sext.i8.i24(i: i8) returns (i24) { i }
function {:inline} $sext.i8.i32(i: i8) returns (i32) { i }
function {:inline} $sext.i8.i40(i: i8) returns (i40) { i }
function {:inline} $sext.i8.i48(i: i8) returns (i48) { i }
function {:inline} $sext.i8.i56(i: i8) returns (i56) { i }
function {:inline} $sext.i8.i64(i: i8) returns (i64) { i }
function {:inline} $sext.i8.i80(i: i8) returns (i80) { i }
function {:inline} $sext.i8.i88(i: i8) returns (i88) { i }
function {:inline} $sext.i8.i96(i: i8) returns (i96) { i }
function {:inline} $sext.i8.i128(i: i8) returns (i128) { i }
function {:inline} $sext.i8.i160(i: i8) returns (i160) { i }
function {:inline} $sext.i8.i256(i: i8) returns (i256) { i }
function {:inline} $sext.i16.i24(i: i16) returns (i24) { i }
function {:inline} $sext.i16.i32(i: i16) returns (i32) { i }
function {:inline} $sext.i16.i40(i: i16) returns (i40) { i }
function {:inline} $sext.i16.i48(i: i16) returns (i48) { i }
function {:inline} $sext.i16.i56(i: i16) returns (i56) { i }
function {:inline} $sext.i16.i64(i: i16) returns (i64) { i }
function {:inline} $sext.i16.i80(i: i16) returns (i80) { i }
function {:inline} $sext.i16.i88(i: i16) returns (i88) { i }
function {:inline} $sext.i16.i96(i: i16) returns (i96) { i }
function {:inline} $sext.i16.i128(i: i16) returns (i128) { i }
function {:inline} $sext.i16.i160(i: i16) returns (i160) { i }
function {:inline} $sext.i16.i256(i: i16) returns (i256) { i }
function {:inline} $sext.i24.i32(i: i24) returns (i32) { i }
function {:inline} $sext.i24.i40(i: i24) returns (i40) { i }
function {:inline} $sext.i24.i48(i: i24) returns (i48) { i }
function {:inline} $sext.i24.i56(i: i24) returns (i56) { i }
function {:inline} $sext.i24.i64(i: i24) returns (i64) { i }
function {:inline} $sext.i24.i80(i: i24) returns (i80) { i }
function {:inline} $sext.i24.i88(i: i24) returns (i88) { i }
function {:inline} $sext.i24.i96(i: i24) returns (i96) { i }
function {:inline} $sext.i24.i128(i: i24) returns (i128) { i }
function {:inline} $sext.i24.i160(i: i24) returns (i160) { i }
function {:inline} $sext.i24.i256(i: i24) returns (i256) { i }
function {:inline} $sext.i32.i40(i: i32) returns (i40) { i }
function {:inline} $sext.i32.i48(i: i32) returns (i48) { i }
function {:inline} $sext.i32.i56(i: i32) returns (i56) { i }
function {:inline} $sext.i32.i64(i: i32) returns (i64) { i }
function {:inline} $sext.i32.i80(i: i32) returns (i80) { i }
function {:inline} $sext.i32.i88(i: i32) returns (i88) { i }
function {:inline} $sext.i32.i96(i: i32) returns (i96) { i }
function {:inline} $sext.i32.i128(i: i32) returns (i128) { i }
function {:inline} $sext.i32.i160(i: i32) returns (i160) { i }
function {:inline} $sext.i32.i256(i: i32) returns (i256) { i }
function {:inline} $sext.i40.i48(i: i40) returns (i48) { i }
function {:inline} $sext.i40.i56(i: i40) returns (i56) { i }
function {:inline} $sext.i40.i64(i: i40) returns (i64) { i }
function {:inline} $sext.i40.i80(i: i40) returns (i80) { i }
function {:inline} $sext.i40.i88(i: i40) returns (i88) { i }
function {:inline} $sext.i40.i96(i: i40) returns (i96) { i }
function {:inline} $sext.i40.i128(i: i40) returns (i128) { i }
function {:inline} $sext.i40.i160(i: i40) returns (i160) { i }
function {:inline} $sext.i40.i256(i: i40) returns (i256) { i }
function {:inline} $sext.i48.i56(i: i48) returns (i56) { i }
function {:inline} $sext.i48.i64(i: i48) returns (i64) { i }
function {:inline} $sext.i48.i80(i: i48) returns (i80) { i }
function {:inline} $sext.i48.i88(i: i48) returns (i88) { i }
function {:inline} $sext.i48.i96(i: i48) returns (i96) { i }
function {:inline} $sext.i48.i128(i: i48) returns (i128) { i }
function {:inline} $sext.i48.i160(i: i48) returns (i160) { i }
function {:inline} $sext.i48.i256(i: i48) returns (i256) { i }
function {:inline} $sext.i56.i64(i: i56) returns (i64) { i }
function {:inline} $sext.i56.i80(i: i56) returns (i80) { i }
function {:inline} $sext.i56.i88(i: i56) returns (i88) { i }
function {:inline} $sext.i56.i96(i: i56) returns (i96) { i }
function {:inline} $sext.i56.i128(i: i56) returns (i128) { i }
function {:inline} $sext.i56.i160(i: i56) returns (i160) { i }
function {:inline} $sext.i56.i256(i: i56) returns (i256) { i }
function {:inline} $sext.i64.i80(i: i64) returns (i80) { i }
function {:inline} $sext.i64.i88(i: i64) returns (i88) { i }
function {:inline} $sext.i64.i96(i: i64) returns (i96) { i }
function {:inline} $sext.i64.i128(i: i64) returns (i128) { i }
function {:inline} $sext.i64.i160(i: i64) returns (i160) { i }
function {:inline} $sext.i64.i256(i: i64) returns (i256) { i }
function {:inline} $sext.i80.i88(i: i80) returns (i88) { i }
function {:inline} $sext.i80.i96(i: i80) returns (i96) { i }
function {:inline} $sext.i80.i128(i: i80) returns (i128) { i }
function {:inline} $sext.i80.i160(i: i80) returns (i160) { i }
function {:inline} $sext.i80.i256(i: i80) returns (i256) { i }
function {:inline} $sext.i88.i96(i: i88) returns (i96) { i }
function {:inline} $sext.i88.i128(i: i88) returns (i128) { i }
function {:inline} $sext.i88.i160(i: i88) returns (i160) { i }
function {:inline} $sext.i88.i256(i: i88) returns (i256) { i }
function {:inline} $sext.i96.i128(i: i96) returns (i128) { i }
function {:inline} $sext.i96.i160(i: i96) returns (i160) { i }
function {:inline} $sext.i96.i256(i: i96) returns (i256) { i }
function {:inline} $sext.i128.i160(i: i128) returns (i160) { i }
function {:inline} $sext.i128.i256(i: i128) returns (i256) { i }
function {:inline} $sext.i160.i256(i: i160) returns (i256) { i }
function {:inline} $zext.i1.i5(i: i1) returns (i5) { i }
function {:inline} $zext.i1.i6(i: i1) returns (i6) { i }
function {:inline} $zext.i1.i8(i: i1) returns (i8) { i }
function {:inline} $zext.i1.i16(i: i1) returns (i16) { i }
function {:inline} $zext.i1.i24(i: i1) returns (i24) { i }
function {:inline} $zext.i1.i32(i: i1) returns (i32) { i }
function {:inline} $zext.i1.i40(i: i1) returns (i40) { i }
function {:inline} $zext.i1.i48(i: i1) returns (i48) { i }
function {:inline} $zext.i1.i56(i: i1) returns (i56) { i }
function {:inline} $zext.i1.i64(i: i1) returns (i64) { i }
function {:inline} $zext.i1.i80(i: i1) returns (i80) { i }
function {:inline} $zext.i1.i88(i: i1) returns (i88) { i }
function {:inline} $zext.i1.i96(i: i1) returns (i96) { i }
function {:inline} $zext.i1.i128(i: i1) returns (i128) { i }
function {:inline} $zext.i1.i160(i: i1) returns (i160) { i }
function {:inline} $zext.i1.i256(i: i1) returns (i256) { i }
function {:inline} $zext.i5.i6(i: i5) returns (i6) { i }
function {:inline} $zext.i5.i8(i: i5) returns (i8) { i }
function {:inline} $zext.i5.i16(i: i5) returns (i16) { i }
function {:inline} $zext.i5.i24(i: i5) returns (i24) { i }
function {:inline} $zext.i5.i32(i: i5) returns (i32) { i }
function {:inline} $zext.i5.i40(i: i5) returns (i40) { i }
function {:inline} $zext.i5.i48(i: i5) returns (i48) { i }
function {:inline} $zext.i5.i56(i: i5) returns (i56) { i }
function {:inline} $zext.i5.i64(i: i5) returns (i64) { i }
function {:inline} $zext.i5.i80(i: i5) returns (i80) { i }
function {:inline} $zext.i5.i88(i: i5) returns (i88) { i }
function {:inline} $zext.i5.i96(i: i5) returns (i96) { i }
function {:inline} $zext.i5.i128(i: i5) returns (i128) { i }
function {:inline} $zext.i5.i160(i: i5) returns (i160) { i }
function {:inline} $zext.i5.i256(i: i5) returns (i256) { i }
function {:inline} $zext.i6.i8(i: i6) returns (i8) { i }
function {:inline} $zext.i6.i16(i: i6) returns (i16) { i }
function {:inline} $zext.i6.i24(i: i6) returns (i24) { i }
function {:inline} $zext.i6.i32(i: i6) returns (i32) { i }
function {:inline} $zext.i6.i40(i: i6) returns (i40) { i }
function {:inline} $zext.i6.i48(i: i6) returns (i48) { i }
function {:inline} $zext.i6.i56(i: i6) returns (i56) { i }
function {:inline} $zext.i6.i64(i: i6) returns (i64) { i }
function {:inline} $zext.i6.i80(i: i6) returns (i80) { i }
function {:inline} $zext.i6.i88(i: i6) returns (i88) { i }
function {:inline} $zext.i6.i96(i: i6) returns (i96) { i }
function {:inline} $zext.i6.i128(i: i6) returns (i128) { i }
function {:inline} $zext.i6.i160(i: i6) returns (i160) { i }
function {:inline} $zext.i6.i256(i: i6) returns (i256) { i }
function {:inline} $zext.i8.i16(i: i8) returns (i16) { i }
function {:inline} $zext.i8.i24(i: i8) returns (i24) { i }
function {:inline} $zext.i8.i32(i: i8) returns (i32) { i }
function {:inline} $zext.i8.i40(i: i8) returns (i40) { i }
function {:inline} $zext.i8.i48(i: i8) returns (i48) { i }
function {:inline} $zext.i8.i56(i: i8) returns (i56) { i }
function {:inline} $zext.i8.i64(i: i8) returns (i64) { i }
function {:inline} $zext.i8.i80(i: i8) returns (i80) { i }
function {:inline} $zext.i8.i88(i: i8) returns (i88) { i }
function {:inline} $zext.i8.i96(i: i8) returns (i96) { i }
function {:inline} $zext.i8.i128(i: i8) returns (i128) { i }
function {:inline} $zext.i8.i160(i: i8) returns (i160) { i }
function {:inline} $zext.i8.i256(i: i8) returns (i256) { i }
function {:inline} $zext.i16.i24(i: i16) returns (i24) { i }
function {:inline} $zext.i16.i32(i: i16) returns (i32) { i }
function {:inline} $zext.i16.i40(i: i16) returns (i40) { i }
function {:inline} $zext.i16.i48(i: i16) returns (i48) { i }
function {:inline} $zext.i16.i56(i: i16) returns (i56) { i }
function {:inline} $zext.i16.i64(i: i16) returns (i64) { i }
function {:inline} $zext.i16.i80(i: i16) returns (i80) { i }
function {:inline} $zext.i16.i88(i: i16) returns (i88) { i }
function {:inline} $zext.i16.i96(i: i16) returns (i96) { i }
function {:inline} $zext.i16.i128(i: i16) returns (i128) { i }
function {:inline} $zext.i16.i160(i: i16) returns (i160) { i }
function {:inline} $zext.i16.i256(i: i16) returns (i256) { i }
function {:inline} $zext.i24.i32(i: i24) returns (i32) { i }
function {:inline} $zext.i24.i40(i: i24) returns (i40) { i }
function {:inline} $zext.i24.i48(i: i24) returns (i48) { i }
function {:inline} $zext.i24.i56(i: i24) returns (i56) { i }
function {:inline} $zext.i24.i64(i: i24) returns (i64) { i }
function {:inline} $zext.i24.i80(i: i24) returns (i80) { i }
function {:inline} $zext.i24.i88(i: i24) returns (i88) { i }
function {:inline} $zext.i24.i96(i: i24) returns (i96) { i }
function {:inline} $zext.i24.i128(i: i24) returns (i128) { i }
function {:inline} $zext.i24.i160(i: i24) returns (i160) { i }
function {:inline} $zext.i24.i256(i: i24) returns (i256) { i }
function {:inline} $zext.i32.i40(i: i32) returns (i40) { i }
function {:inline} $zext.i32.i48(i: i32) returns (i48) { i }
function {:inline} $zext.i32.i56(i: i32) returns (i56) { i }
function {:inline} $zext.i32.i64(i: i32) returns (i64) { i }
function {:inline} $zext.i32.i80(i: i32) returns (i80) { i }
function {:inline} $zext.i32.i88(i: i32) returns (i88) { i }
function {:inline} $zext.i32.i96(i: i32) returns (i96) { i }
function {:inline} $zext.i32.i128(i: i32) returns (i128) { i }
function {:inline} $zext.i32.i160(i: i32) returns (i160) { i }
function {:inline} $zext.i32.i256(i: i32) returns (i256) { i }
function {:inline} $zext.i40.i48(i: i40) returns (i48) { i }
function {:inline} $zext.i40.i56(i: i40) returns (i56) { i }
function {:inline} $zext.i40.i64(i: i40) returns (i64) { i }
function {:inline} $zext.i40.i80(i: i40) returns (i80) { i }
function {:inline} $zext.i40.i88(i: i40) returns (i88) { i }
function {:inline} $zext.i40.i96(i: i40) returns (i96) { i }
function {:inline} $zext.i40.i128(i: i40) returns (i128) { i }
function {:inline} $zext.i40.i160(i: i40) returns (i160) { i }
function {:inline} $zext.i40.i256(i: i40) returns (i256) { i }
function {:inline} $zext.i48.i56(i: i48) returns (i56) { i }
function {:inline} $zext.i48.i64(i: i48) returns (i64) { i }
function {:inline} $zext.i48.i80(i: i48) returns (i80) { i }
function {:inline} $zext.i48.i88(i: i48) returns (i88) { i }
function {:inline} $zext.i48.i96(i: i48) returns (i96) { i }
function {:inline} $zext.i48.i128(i: i48) returns (i128) { i }
function {:inline} $zext.i48.i160(i: i48) returns (i160) { i }
function {:inline} $zext.i48.i256(i: i48) returns (i256) { i }
function {:inline} $zext.i56.i64(i: i56) returns (i64) { i }
function {:inline} $zext.i56.i80(i: i56) returns (i80) { i }
function {:inline} $zext.i56.i88(i: i56) returns (i88) { i }
function {:inline} $zext.i56.i96(i: i56) returns (i96) { i }
function {:inline} $zext.i56.i128(i: i56) returns (i128) { i }
function {:inline} $zext.i56.i160(i: i56) returns (i160) { i }
function {:inline} $zext.i56.i256(i: i56) returns (i256) { i }
function {:inline} $zext.i64.i80(i: i64) returns (i80) { i }
function {:inline} $zext.i64.i88(i: i64) returns (i88) { i }
function {:inline} $zext.i64.i96(i: i64) returns (i96) { i }
function {:inline} $zext.i64.i128(i: i64) returns (i128) { i }
function {:inline} $zext.i64.i160(i: i64) returns (i160) { i }
function {:inline} $zext.i64.i256(i: i64) returns (i256) { i }
function {:inline} $zext.i80.i88(i: i80) returns (i88) { i }
function {:inline} $zext.i80.i96(i: i80) returns (i96) { i }
function {:inline} $zext.i80.i128(i: i80) returns (i128) { i }
function {:inline} $zext.i80.i160(i: i80) returns (i160) { i }
function {:inline} $zext.i80.i256(i: i80) returns (i256) { i }
function {:inline} $zext.i88.i96(i: i88) returns (i96) { i }
function {:inline} $zext.i88.i128(i: i88) returns (i128) { i }
function {:inline} $zext.i88.i160(i: i88) returns (i160) { i }
function {:inline} $zext.i88.i256(i: i88) returns (i256) { i }
function {:inline} $zext.i96.i128(i: i96) returns (i128) { i }
function {:inline} $zext.i96.i160(i: i96) returns (i160) { i }
function {:inline} $zext.i96.i256(i: i96) returns (i256) { i }
function {:inline} $zext.i128.i160(i: i128) returns (i160) { i }
function {:inline} $zext.i128.i256(i: i128) returns (i256) { i }
function {:inline} $zext.i160.i256(i: i160) returns (i256) { i }
function $extractvalue.i1(p: ref, i: int) returns (i1);
function $extractvalue.i5(p: ref, i: int) returns (i5);
function $extractvalue.i6(p: ref, i: int) returns (i6);
function $extractvalue.i8(p: ref, i: int) returns (i8);
function $extractvalue.i16(p: ref, i: int) returns (i16);
function $extractvalue.i24(p: ref, i: int) returns (i24);
function $extractvalue.i32(p: ref, i: int) returns (i32);
function $extractvalue.i40(p: ref, i: int) returns (i40);
function $extractvalue.i48(p: ref, i: int) returns (i48);
function $extractvalue.i56(p: ref, i: int) returns (i56);
function $extractvalue.i64(p: ref, i: int) returns (i64);
function $extractvalue.i80(p: ref, i: int) returns (i80);
function $extractvalue.i88(p: ref, i: int) returns (i88);
function $extractvalue.i96(p: ref, i: int) returns (i96);
function $extractvalue.i128(p: ref, i: int) returns (i128);
function $extractvalue.i160(p: ref, i: int) returns (i160);
function $extractvalue.i256(p: ref, i: int) returns (i256);
// Pointer arithmetic operations
function {:inline} $add.ref(p1: ref, p2: ref) returns (ref) { $add.i64(p1, p2) }
function {:inline} $sub.ref(p1: ref, p2: ref) returns (ref) { $sub.i64(p1, p2) }
function {:inline} $mul.ref(p1: ref, p2: ref) returns (ref) { $mul.i64(p1, p2) }

// Pointer predicates
function {:inline} $eq.ref(p1: ref, p2: ref) returns (i1) { (if $eq.i64.bool(p1, p2) then 1 else 0) }
function {:inline} $eq.ref.bool(p1: ref, p2: ref) returns (bool) { $eq.i64.bool(p1, p2) }
function {:inline} $ne.ref(p1: ref, p2: ref) returns (i1) { (if $ne.i64.bool(p1, p2) then 1 else 0) }
function {:inline} $ne.ref.bool(p1: ref, p2: ref) returns (bool) { $ne.i64.bool(p1, p2) }
function {:inline} $ugt.ref(p1: ref, p2: ref) returns (i1) { (if $ugt.i64.bool(p1, p2) then 1 else 0) }
function {:inline} $ugt.ref.bool(p1: ref, p2: ref) returns (bool) { $ugt.i64.bool(p1, p2) }
function {:inline} $uge.ref(p1: ref, p2: ref) returns (i1) { (if $uge.i64.bool(p1, p2) then 1 else 0) }
function {:inline} $uge.ref.bool(p1: ref, p2: ref) returns (bool) { $uge.i64.bool(p1, p2) }
function {:inline} $ult.ref(p1: ref, p2: ref) returns (i1) { (if $ult.i64.bool(p1, p2) then 1 else 0) }
function {:inline} $ult.ref.bool(p1: ref, p2: ref) returns (bool) { $ult.i64.bool(p1, p2) }
function {:inline} $ule.ref(p1: ref, p2: ref) returns (i1) { (if $ule.i64.bool(p1, p2) then 1 else 0) }
function {:inline} $ule.ref.bool(p1: ref, p2: ref) returns (bool) { $ule.i64.bool(p1, p2) }
function {:inline} $sgt.ref(p1: ref, p2: ref) returns (i1) { (if $sgt.i64.bool(p1, p2) then 1 else 0) }
function {:inline} $sgt.ref.bool(p1: ref, p2: ref) returns (bool) { $sgt.i64.bool(p1, p2) }
function {:inline} $sge.ref(p1: ref, p2: ref) returns (i1) { (if $sge.i64.bool(p1, p2) then 1 else 0) }
function {:inline} $sge.ref.bool(p1: ref, p2: ref) returns (bool) { $sge.i64.bool(p1, p2) }
function {:inline} $slt.ref(p1: ref, p2: ref) returns (i1) { (if $slt.i64.bool(p1, p2) then 1 else 0) }
function {:inline} $slt.ref.bool(p1: ref, p2: ref) returns (bool) { $slt.i64.bool(p1, p2) }
function {:inline} $sle.ref(p1: ref, p2: ref) returns (i1) { (if $sle.i64.bool(p1, p2) then 1 else 0) }
function {:inline} $sle.ref.bool(p1: ref, p2: ref) returns (bool) { $sle.i64.bool(p1, p2) }

// Pointer load/store operations
function {:inline} $load.ref(M: [ref] ref, p: ref) returns (ref) { M[p] }
function {:inline} $store.ref(M: [ref] ref, p: ref, i: ref) returns ([ref] ref) { M[p := i] }

// Pointer conversion
function {:inline} $bitcast.ref.ref(p: ref) returns (ref) { p }
function $extractvalue.ref(p: ref, i: int) returns (ref);
// Pointer-number conversion
function {:inline} $p2i.ref.i8(p: ref) returns (i8) { $trunc.i64.i8(p) }
function {:inline} $i2p.i8.ref(i: i8) returns (ref) { $zext.i8.i64(i) }
function {:inline} $p2i.ref.i16(p: ref) returns (i16) { $trunc.i64.i16(p) }
function {:inline} $i2p.i16.ref(i: i16) returns (ref) { $zext.i16.i64(i) }
function {:inline} $p2i.ref.i32(p: ref) returns (i32) { $trunc.i64.i32(p) }
function {:inline} $i2p.i32.ref(i: i32) returns (ref) { $zext.i32.i64(i) }
function {:inline} $p2i.ref.i64(p: ref) returns (i64) { p }
function {:inline} $i2p.i64.ref(i: i64) returns (ref) { i }

function $fp(ipart: int, fpart: int, epart: int) returns (float);
// Floating-point arithmetic operations
function $abs.float(f: float) returns (float);
function $round.float(f: float) returns (float);
function $sqrt.float(f: float) returns (float);
function $fadd.float(f1: float, f2: float) returns (float);
function $fsub.float(f1: float, f2: float) returns (float);
function $fmul.float(f1: float, f2: float) returns (float);
function $fdiv.float(f1: float, f2: float) returns (float);
function $frem.float(f1: float, f2: float) returns (float);
function $min.float(f1: float, f2: float) returns (float);
function $max.float(f1: float, f2: float) returns (float);
function $fma.float(f1: float, f2: float, f3: float) returns (float);
// Floating-point predicates
function $foeq.float.bool(f1: float, f2: float) returns (bool);
function $fole.float.bool(f1: float, f2: float) returns (bool);
function $folt.float.bool(f1: float, f2: float) returns (bool);
function $foge.float.bool(f1: float, f2: float) returns (bool);
function $fogt.float.bool(f1: float, f2: float) returns (bool);
function $fone.float.bool(f1: float, f2: float) returns (bool);
function $ford.float.bool(f1: float, f2: float) returns (bool);
function $fueq.float.bool(f1: float, f2: float) returns (bool);
function $fugt.float.bool(f1: float, f2: float) returns (bool);
function $fuge.float.bool(f1: float, f2: float) returns (bool);
function $fult.float.bool(f1: float, f2: float) returns (bool);
function $fule.float.bool(f1: float, f2: float) returns (bool);
function $fune.float.bool(f1: float, f2: float) returns (bool);
function $funo.float.bool(f1: float, f2: float) returns (bool);
function $ffalse.float.bool(f1: float, f2: float) returns (bool);
function $ftrue.float.bool(f1: float, f2: float) returns (bool);
// Floating-point/integer conversion
function $bitcast.float.i8(f: float) returns (i8);
function $bitcast.float.i16(f: float) returns (i16);
function $bitcast.float.i32(f: float) returns (i32);
function $bitcast.float.i64(f: float) returns (i64);
function $bitcast.float.i80(f: float) returns (i80);
function $bitcast.i8.float(i: i8) returns (float);
function $bitcast.i16.float(i: i16) returns (float);
function $bitcast.i32.float(i: i32) returns (float);
function $bitcast.i64.float(i: i64) returns (float);
function $bitcast.i80.float(i: i80) returns (float);
function $fp2si.float.i1(f: float) returns (i1);
function $fp2si.float.i5(f: float) returns (i5);
function $fp2si.float.i6(f: float) returns (i6);
function $fp2si.float.i8(f: float) returns (i8);
function $fp2si.float.i16(f: float) returns (i16);
function $fp2si.float.i24(f: float) returns (i24);
function $fp2si.float.i32(f: float) returns (i32);
function $fp2si.float.i40(f: float) returns (i40);
function $fp2si.float.i48(f: float) returns (i48);
function $fp2si.float.i56(f: float) returns (i56);
function $fp2si.float.i64(f: float) returns (i64);
function $fp2si.float.i80(f: float) returns (i80);
function $fp2si.float.i88(f: float) returns (i88);
function $fp2si.float.i96(f: float) returns (i96);
function $fp2si.float.i128(f: float) returns (i128);
function $fp2si.float.i160(f: float) returns (i160);
function $fp2si.float.i256(f: float) returns (i256);
function $fp2ui.float.i1(f: float) returns (i1);
function $fp2ui.float.i5(f: float) returns (i5);
function $fp2ui.float.i6(f: float) returns (i6);
function $fp2ui.float.i8(f: float) returns (i8);
function $fp2ui.float.i16(f: float) returns (i16);
function $fp2ui.float.i24(f: float) returns (i24);
function $fp2ui.float.i32(f: float) returns (i32);
function $fp2ui.float.i40(f: float) returns (i40);
function $fp2ui.float.i48(f: float) returns (i48);
function $fp2ui.float.i56(f: float) returns (i56);
function $fp2ui.float.i64(f: float) returns (i64);
function $fp2ui.float.i80(f: float) returns (i80);
function $fp2ui.float.i88(f: float) returns (i88);
function $fp2ui.float.i96(f: float) returns (i96);
function $fp2ui.float.i128(f: float) returns (i128);
function $fp2ui.float.i160(f: float) returns (i160);
function $fp2ui.float.i256(f: float) returns (i256);
function $si2fp.i1.float(i: i1) returns (float);
function $si2fp.i5.float(i: i5) returns (float);
function $si2fp.i6.float(i: i6) returns (float);
function $si2fp.i8.float(i: i8) returns (float);
function $si2fp.i16.float(i: i16) returns (float);
function $si2fp.i24.float(i: i24) returns (float);
function $si2fp.i32.float(i: i32) returns (float);
function $si2fp.i40.float(i: i40) returns (float);
function $si2fp.i48.float(i: i48) returns (float);
function $si2fp.i56.float(i: i56) returns (float);
function $si2fp.i64.float(i: i64) returns (float);
function $si2fp.i80.float(i: i80) returns (float);
function $si2fp.i88.float(i: i88) returns (float);
function $si2fp.i96.float(i: i96) returns (float);
function $si2fp.i128.float(i: i128) returns (float);
function $si2fp.i160.float(i: i160) returns (float);
function $si2fp.i256.float(i: i256) returns (float);
function $ui2fp.i1.float(i: i1) returns (float);
function $ui2fp.i5.float(i: i5) returns (float);
function $ui2fp.i6.float(i: i6) returns (float);
function $ui2fp.i8.float(i: i8) returns (float);
function $ui2fp.i16.float(i: i16) returns (float);
function $ui2fp.i24.float(i: i24) returns (float);
function $ui2fp.i32.float(i: i32) returns (float);
function $ui2fp.i40.float(i: i40) returns (float);
function $ui2fp.i48.float(i: i48) returns (float);
function $ui2fp.i56.float(i: i56) returns (float);
function $ui2fp.i64.float(i: i64) returns (float);
function $ui2fp.i80.float(i: i80) returns (float);
function $ui2fp.i88.float(i: i88) returns (float);
function $ui2fp.i96.float(i: i96) returns (float);
function $ui2fp.i128.float(i: i128) returns (float);
function $ui2fp.i160.float(i: i160) returns (float);
function $ui2fp.i256.float(i: i256) returns (float);
// Floating-point conversion
function $fpext.float.float(f: float) returns (float);
function $fptrunc.float.float(f: float) returns (float);
// Floating-point load/store operations
function {:inline} $load.float(M: [ref] float, p: ref) returns (float) { M[p] }
function {:inline} $store.float(M: [ref] float, p: ref, f: float) returns ([ref] float) { M[p := f] }
function {:inline} $load.unsafe.float(M: [ref] i8, p: ref) returns (float) { $bitcast.i8.float(M[p]) }
function {:inline} $store.unsafe.float(M: [ref] i8, p: ref, f: float) returns ([ref] i8) { M[p := $bitcast.float.i8(f)] }
function $extractvalue.float(p: ref, i: int) returns (float);
const __unbuffered_cnt: ref;
axiom (__unbuffered_cnt == $sub.ref(0, 1028));
const __unbuffered_p0_EAX: ref;
axiom (__unbuffered_p0_EAX == $sub.ref(0, 2056));
const __unbuffered_p1_EAX: ref;
axiom (__unbuffered_p1_EAX == $sub.ref(0, 3084));
const x: ref;
axiom (x == $sub.ref(0, 4112));
const y: ref;
axiom (y == $sub.ref(0, 5140));
const x$w_buff0: ref;
axiom (x$w_buff0 == $sub.ref(0, 6168));
const x$w_buff1: ref;
axiom (x$w_buff1 == $sub.ref(0, 7196));
const x$w_buff0_used: ref;
axiom (x$w_buff0_used == $sub.ref(0, 8221));
const x$w_buff1_used: ref;
axiom (x$w_buff1_used == $sub.ref(0, 9246));
const x$r_buff0_thd0: ref;
axiom (x$r_buff0_thd0 == $sub.ref(0, 10271));
const x$r_buff1_thd0: ref;
axiom (x$r_buff1_thd0 == $sub.ref(0, 11296));
const x$r_buff0_thd1: ref;
axiom (x$r_buff0_thd1 == $sub.ref(0, 12321));
const x$r_buff1_thd1: ref;
axiom (x$r_buff1_thd1 == $sub.ref(0, 13346));
const x$r_buff0_thd2: ref;
axiom (x$r_buff0_thd2 == $sub.ref(0, 14371));
const x$r_buff1_thd2: ref;
axiom (x$r_buff1_thd2 == $sub.ref(0, 15396));
const weak$$choice0: ref;
axiom (weak$$choice0 == $sub.ref(0, 16421));
const weak$$choice2: ref;
axiom (weak$$choice2 == $sub.ref(0, 17446));
const x$flush_delayed: ref;
axiom (x$flush_delayed == $sub.ref(0, 18471));
const x$mem_tmp: ref;
axiom (x$mem_tmp == $sub.ref(0, 19499));
const weak$$choice1: ref;
axiom (weak$$choice1 == $sub.ref(0, 20524));
const __unbuffered_p1_EAX$read_delayed: ref;
axiom (__unbuffered_p1_EAX$read_delayed == $sub.ref(0, 21549));
const __unbuffered_p1_EAX$read_delayed_var: ref;
axiom (__unbuffered_p1_EAX$read_delayed_var == $sub.ref(0, 22581));
const main$tmp_guard0: ref;
axiom (main$tmp_guard0 == $sub.ref(0, 23606));
const main$tmp_guard1: ref;
axiom (main$tmp_guard1 == $sub.ref(0, 24631));
const __unbuffered_p1_EAX$flush_delayed: ref;
axiom (__unbuffered_p1_EAX$flush_delayed == $sub.ref(0, 25656));
const __unbuffered_p1_EAX$mem_tmp: ref;
axiom (__unbuffered_p1_EAX$mem_tmp == $sub.ref(0, 26684));
const __unbuffered_p1_EAX$r_buff0_thd0: ref;
axiom (__unbuffered_p1_EAX$r_buff0_thd0 == $sub.ref(0, 27709));
const __unbuffered_p1_EAX$r_buff0_thd1: ref;
axiom (__unbuffered_p1_EAX$r_buff0_thd1 == $sub.ref(0, 28734));
const __unbuffered_p1_EAX$r_buff0_thd2: ref;
axiom (__unbuffered_p1_EAX$r_buff0_thd2 == $sub.ref(0, 29759));
const __unbuffered_p1_EAX$r_buff1_thd0: ref;
axiom (__unbuffered_p1_EAX$r_buff1_thd0 == $sub.ref(0, 30784));
const __unbuffered_p1_EAX$r_buff1_thd1: ref;
axiom (__unbuffered_p1_EAX$r_buff1_thd1 == $sub.ref(0, 31809));
const __unbuffered_p1_EAX$r_buff1_thd2: ref;
axiom (__unbuffered_p1_EAX$r_buff1_thd2 == $sub.ref(0, 32834));
const __unbuffered_p1_EAX$w_buff0: ref;
axiom (__unbuffered_p1_EAX$w_buff0 == $sub.ref(0, 33862));
const __unbuffered_p1_EAX$w_buff0_used: ref;
axiom (__unbuffered_p1_EAX$w_buff0_used == $sub.ref(0, 34887));
const __unbuffered_p1_EAX$w_buff1: ref;
axiom (__unbuffered_p1_EAX$w_buff1 == $sub.ref(0, 35915));
const __unbuffered_p1_EAX$w_buff1_used: ref;
axiom (__unbuffered_p1_EAX$w_buff1_used == $sub.ref(0, 36940));
const x$read_delayed: ref;
axiom (x$read_delayed == $sub.ref(0, 37965));
const x$read_delayed_var: ref;
axiom (x$read_delayed_var == $sub.ref(0, 38997));
const {:count 14} .str.1: ref;
axiom (.str.1 == $sub.ref(0, 40035));
const env_value_str: ref;
axiom (env_value_str == $sub.ref(0, 41067));
const {:count 3} .str.1.3: ref;
axiom (.str.1.3 == $sub.ref(0, 42094));
const {:count 14} .str.14: ref;
axiom (.str.14 == $sub.ref(0, 43132));
const errno_global: ref;
axiom (errno_global == $sub.ref(0, 44160));
const assume_abort_if_not: ref;
axiom (assume_abort_if_not == $sub.ref(0, 45192));
procedure assume_abort_if_not($i0: i32)
{
  var $i1: i1;
$bb0:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 3, 7} true;
  assume {:verifier.code 0} true;
  call {:cexpr "assume_abort_if_not:arg:cond"} boogie_si_record_i32($i0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 3, 7} true;
  assume {:verifier.code 0} true;
  $i1 := $ne.i32($i0, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 3, 6} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i1} true;
  goto $bb1, $bb2;
$bb1:
  assume ($i1 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 4, 1} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
$bb2:
  assume !(($i1 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 3, 14} true;
  assume {:verifier.code 0} true;
  call abort();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 3, 14} true;
  assume {:verifier.code 0} true;
  assume false;
}
const llvm.dbg.declare: ref;
axiom (llvm.dbg.declare == $sub.ref(0, 46224));
procedure llvm.dbg.declare($p0: ref, $p1: ref, $p2: ref);
const abort: ref;
axiom (abort == $sub.ref(0, 47256));
procedure abort();
const reach_error: ref;
axiom (reach_error == $sub.ref(0, 48288));
procedure reach_error()
{
$bb0:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 7, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 7, 20} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const __VERIFIER_assert: ref;
axiom (__VERIFIER_assert == $sub.ref(0, 49320));
procedure __VERIFIER_assert($i0: i32)
{
  var $i1: i1;
$bb0:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 8, 47} true;
  assume {:verifier.code 0} true;
  call {:cexpr "__VERIFIER_assert:arg:expression"} boogie_si_record_i32($i0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 8, 47} true;
  assume {:verifier.code 0} true;
  $i1 := $ne.i32($i0, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 8, 46} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i1} true;
  goto $bb1, $bb2;
$bb1:
  assume ($i1 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 8, 96} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
$bb2:
  assume !(($i1 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 8, 59} true;
  assume {:verifier.code 0} true;
  goto $bb3;
$bb3:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 8, 69} true;
  assume {:verifier.code 0} true;
  call reach_error();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 8, 83} true;
  assume {:verifier.code 0} true;
  call abort();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 8, 83} true;
  assume {:verifier.code 0} true;
  assume false;
}
const P0: ref;
axiom (P0 == $sub.ref(0, 50352));
procedure P0($p0: ref)
  returns ($r: ref)
{
  var $i1: i32;
  var $i2: i32;
  var $i3: i8;
  var $i4: i1;
  var $i5: i8;
  var $i6: i8;
  var $i7: i1;
  var $i9: i8;
  var $i10: i1;
  var $i8: i1;
  var $i11: i1;
  var $i12: i32;
  var $i13: i8;
  var $i14: i1;
  var $i15: i8;
  var $i16: i8;
  var $i17: i1;
  var $i18: i8;
  var $i19: i8;
  var $i20: i1;
  var $i21: i8;
  var $i22: i8;
  var $i23: i1;
  var $i24: i8;
  var $i25: i1;
  var $i26: i32;
  var $i28: i8;
  var $i29: i1;
  var $i30: i8;
  var $i31: i1;
  var $i32: i32;
  var $i34: i32;
  var $i33: i32;
  var $i27: i32;
  var $i35: i8;
  var $i36: i1;
  var $i37: i8;
  var $i38: i1;
  var $i40: i8;
  var $i41: i1;
  var $i42: i32;
  var $i39: i32;
  var $i43: i1;
  var $i44: i8;
  var $i45: i8;
  var $i46: i1;
  var $i47: i8;
  var $i48: i1;
  var $i49: i8;
  var $i50: i1;
  var $i51: i8;
  var $i52: i1;
  var $i54: i8;
  var $i55: i1;
  var $i56: i32;
  var $i53: i32;
  var $i57: i1;
  var $i58: i8;
  var $i59: i8;
  var $i60: i1;
  var $i61: i8;
  var $i62: i1;
  var $i64: i8;
  var $i65: i1;
  var $i66: i32;
  var $i63: i32;
  var $i67: i1;
  var $i68: i8;
  var $i69: i8;
  var $i70: i1;
  var $i71: i8;
  var $i72: i1;
  var $i73: i8;
  var $i74: i1;
  var $i75: i8;
  var $i76: i1;
  var $i78: i8;
  var $i79: i1;
  var $i80: i32;
  var $i77: i32;
  var $i81: i1;
  var $i82: i8;
  var $i83: i32;
  var $i84: i32;
$bb0:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 184, 3} true;
  assume {:verifier.code 1} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 184, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_begin();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 185, 25} true;
  assume {:verifier.code 0} true;
  $i1 := $M.0;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 185, 23} true;
  assume {:verifier.code 0} true;
  $M.1 := $i1;
  call {:cexpr "__unbuffered_p0_EAX"} boogie_si_record_i32($i1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 186, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_end();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 187, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_begin();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 188, 15} true;
  assume {:verifier.code 0} true;
  $i2 := $M.2;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 188, 13} true;
  assume {:verifier.code 0} true;
  $M.3 := $i2;
  call {:cexpr "x$w_buff1"} boogie_si_record_i32($i2);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 189, 13} true;
  assume {:verifier.code 0} true;
  $M.2 := 1;
  call {:cexpr "x$w_buff0"} boogie_si_record_i32(1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 190, 20} true;
  assume {:verifier.code 0} true;
  $i3 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 190, 20} true;
  assume {:verifier.code 0} true;
  $i4 := $trunc.i8.i1($i3);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 190, 18} true;
  assume {:verifier.code 0} true;
  $i5 := $zext.i1.i8($i4);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 190, 18} true;
  assume {:verifier.code 0} true;
  $M.5 := $i5;
  call {:cexpr "x$w_buff1_used"} boogie_si_record_i8($i5);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 191, 18} true;
  assume {:verifier.code 0} true;
  $M.4 := 1;
  call {:cexpr "x$w_buff0_used"} boogie_si_record_i8(1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 192, 23} true;
  assume {:verifier.code 0} true;
  $i6 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 192, 23} true;
  assume {:verifier.code 0} true;
  $i7 := $trunc.i8.i1($i6);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 192, 38} true;
  assume {:verifier.code 0} true;
  $i8 := 0;
  assume {:branchcond $i7} true;
  goto $bb1, $bb2;
$bb1:
  assume ($i7 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 192, 41} true;
  assume {:verifier.code 1} true;
  $i9 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 192, 41} true;
  assume {:verifier.code 1} true;
  $i10 := $trunc.i8.i1($i9);
  assume {:verifier.code 0} true;
  $i8 := $i10;
  goto $bb3;
$bb2:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 192, 38} true;
  assume {:verifier.code 0} true;
  assume !(($i7 == 1));
  goto $bb3;
$bb3:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 0, 0} true;
  assume {:verifier.code 1} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 192, 21} true;
  assume {:verifier.code 1} true;
  $i11 := $xor.i1($i8, 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 192, 21} true;
  assume {:verifier.code 1} true;
  $i12 := $zext.i1.i32($i11);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 192, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assert($i12);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 193, 20} true;
  assume {:verifier.code 0} true;
  $i13 := $M.6;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 193, 20} true;
  assume {:verifier.code 0} true;
  $i14 := $trunc.i8.i1($i13);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 193, 18} true;
  assume {:verifier.code 0} true;
  $i15 := $zext.i1.i8($i14);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 193, 18} true;
  assume {:verifier.code 0} true;
  $M.7 := $i15;
  call {:cexpr "x$r_buff1_thd0"} boogie_si_record_i8($i15);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 194, 20} true;
  assume {:verifier.code 0} true;
  $i16 := $M.8;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 194, 20} true;
  assume {:verifier.code 0} true;
  $i17 := $trunc.i8.i1($i16);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 194, 18} true;
  assume {:verifier.code 0} true;
  $i18 := $zext.i1.i8($i17);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 194, 18} true;
  assume {:verifier.code 0} true;
  $M.9 := $i18;
  call {:cexpr "x$r_buff1_thd1"} boogie_si_record_i8($i18);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 195, 20} true;
  assume {:verifier.code 0} true;
  $i19 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 195, 20} true;
  assume {:verifier.code 0} true;
  $i20 := $trunc.i8.i1($i19);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 195, 18} true;
  assume {:verifier.code 0} true;
  $i21 := $zext.i1.i8($i20);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 195, 18} true;
  assume {:verifier.code 0} true;
  $M.11 := $i21;
  call {:cexpr "x$r_buff1_thd2"} boogie_si_record_i8($i21);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 196, 18} true;
  assume {:verifier.code 0} true;
  $M.8 := 1;
  call {:cexpr "x$r_buff0_thd1"} boogie_si_record_i8(1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 197, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_end();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 198, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_begin();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 7} true;
  assume {:verifier.code 0} true;
  $i22 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 7} true;
  assume {:verifier.code 0} true;
  $i23 := $trunc.i8.i1($i22);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 22} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i23} true;
  goto $bb4, $bb5;
$bb4:
  assume ($i23 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 25} true;
  assume {:verifier.code 0} true;
  $i24 := $M.8;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 25} true;
  assume {:verifier.code 0} true;
  $i25 := $trunc.i8.i1($i24);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i25} true;
  goto $bb7, $bb8;
$bb5:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 22} true;
  assume {:verifier.code 0} true;
  assume !(($i23 == 1));
  goto $bb6;
$bb6:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 55} true;
  assume {:verifier.code 0} true;
  $i28 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 55} true;
  assume {:verifier.code 0} true;
  $i29 := $trunc.i8.i1($i28);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 70} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i29} true;
  goto $bb10, $bb11;
$bb7:
  assume ($i25 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 42} true;
  assume {:verifier.code 0} true;
  $i26 := $M.2;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 7} true;
  assume {:verifier.code 0} true;
  $i27 := $i26;
  goto $bb9;
$bb8:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 7} true;
  assume {:verifier.code 0} true;
  assume !(($i25 == 1));
  goto $bb6;
$bb9:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 7} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 5} true;
  assume {:verifier.code 0} true;
  $M.12 := $i27;
  call {:cexpr "x"} boogie_si_record_i32($i27);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 20} true;
  assume {:verifier.code 0} true;
  $i35 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 20} true;
  assume {:verifier.code 0} true;
  $i36 := $trunc.i8.i1($i35);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 35} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i36} true;
  goto $bb16, $bb17;
$bb10:
  assume ($i29 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 73} true;
  assume {:verifier.code 0} true;
  $i30 := $M.9;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 73} true;
  assume {:verifier.code 0} true;
  $i31 := $trunc.i8.i1($i30);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 55} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i31} true;
  goto $bb13, $bb14;
$bb11:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 70} true;
  assume {:verifier.code 0} true;
  assume !(($i29 == 1));
  goto $bb12;
$bb12:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 102} true;
  assume {:verifier.code 0} true;
  $i34 := $M.12;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 55} true;
  assume {:verifier.code 0} true;
  $i33 := $i34;
  goto $bb15;
$bb13:
  assume ($i31 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 90} true;
  assume {:verifier.code 0} true;
  $i32 := $M.3;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 55} true;
  assume {:verifier.code 0} true;
  $i33 := $i32;
  goto $bb15;
$bb14:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 55} true;
  assume {:verifier.code 0} true;
  assume !(($i31 == 1));
  goto $bb12;
$bb15:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 55} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 199, 7} true;
  assume {:verifier.code 0} true;
  $i27 := $i33;
  goto $bb9;
$bb16:
  assume ($i36 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 38} true;
  assume {:verifier.code 0} true;
  $i37 := $M.8;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 38} true;
  assume {:verifier.code 0} true;
  $i38 := $trunc.i8.i1($i37);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i38} true;
  goto $bb19, $bb20;
$bb17:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 35} true;
  assume {:verifier.code 0} true;
  assume !(($i36 == 1));
  goto $bb18;
$bb18:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 63} true;
  assume {:verifier.code 0} true;
  $i40 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 63} true;
  assume {:verifier.code 0} true;
  $i41 := $trunc.i8.i1($i40);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 63} true;
  assume {:verifier.code 0} true;
  $i42 := $zext.i1.i32($i41);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 20} true;
  assume {:verifier.code 0} true;
  $i39 := $i42;
  goto $bb21;
$bb19:
  assume ($i38 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 20} true;
  assume {:verifier.code 0} true;
  $i39 := 0;
  goto $bb21;
$bb20:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 20} true;
  assume {:verifier.code 0} true;
  assume !(($i38 == 1));
  goto $bb18;
$bb21:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 20} true;
  assume {:verifier.code 0} true;
  $i43 := $ne.i32($i39, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 18} true;
  assume {:verifier.code 0} true;
  $i44 := $zext.i1.i8($i43);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 200, 18} true;
  assume {:verifier.code 0} true;
  $M.4 := $i44;
  call {:cexpr "x$w_buff0_used"} boogie_si_record_i8($i44);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 20} true;
  assume {:verifier.code 0} true;
  $i45 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 20} true;
  assume {:verifier.code 0} true;
  $i46 := $trunc.i8.i1($i45);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 35} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i46} true;
  goto $bb22, $bb23;
$bb22:
  assume ($i46 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 38} true;
  assume {:verifier.code 0} true;
  $i47 := $M.8;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 38} true;
  assume {:verifier.code 0} true;
  $i48 := $trunc.i8.i1($i47);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 53} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i48} true;
  goto $bb25, $bb27;
$bb23:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 35} true;
  assume {:verifier.code 0} true;
  assume !(($i46 == 1));
  goto $bb24;
$bb24:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 56} true;
  assume {:verifier.code 0} true;
  $i49 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 56} true;
  assume {:verifier.code 0} true;
  $i50 := $trunc.i8.i1($i49);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 71} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i50} true;
  goto $bb28, $bb29;
$bb25:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 53} true;
  assume {:verifier.code 0} true;
  assume ($i48 == 1);
  goto $bb26;
$bb26:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 20} true;
  assume {:verifier.code 0} true;
  $i53 := 0;
  goto $bb33;
$bb27:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 53} true;
  assume {:verifier.code 0} true;
  assume !(($i48 == 1));
  goto $bb24;
$bb28:
  assume ($i50 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 74} true;
  assume {:verifier.code 0} true;
  $i51 := $M.9;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 74} true;
  assume {:verifier.code 0} true;
  $i52 := $trunc.i8.i1($i51);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i52} true;
  goto $bb31, $bb32;
$bb29:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 71} true;
  assume {:verifier.code 0} true;
  assume !(($i50 == 1));
  goto $bb30;
$bb30:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 99} true;
  assume {:verifier.code 0} true;
  $i54 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 99} true;
  assume {:verifier.code 0} true;
  $i55 := $trunc.i8.i1($i54);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 99} true;
  assume {:verifier.code 0} true;
  $i56 := $zext.i1.i32($i55);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 20} true;
  assume {:verifier.code 0} true;
  $i53 := $i56;
  goto $bb33;
$bb31:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 20} true;
  assume {:verifier.code 0} true;
  assume ($i52 == 1);
  goto $bb26;
$bb32:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 20} true;
  assume {:verifier.code 0} true;
  assume !(($i52 == 1));
  goto $bb30;
$bb33:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 20} true;
  assume {:verifier.code 0} true;
  $i57 := $ne.i32($i53, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 18} true;
  assume {:verifier.code 0} true;
  $i58 := $zext.i1.i8($i57);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 201, 18} true;
  assume {:verifier.code 0} true;
  $M.5 := $i58;
  call {:cexpr "x$w_buff1_used"} boogie_si_record_i8($i58);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 20} true;
  assume {:verifier.code 0} true;
  $i59 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 20} true;
  assume {:verifier.code 0} true;
  $i60 := $trunc.i8.i1($i59);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 35} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i60} true;
  goto $bb34, $bb35;
$bb34:
  assume ($i60 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 38} true;
  assume {:verifier.code 0} true;
  $i61 := $M.8;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 38} true;
  assume {:verifier.code 0} true;
  $i62 := $trunc.i8.i1($i61);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i62} true;
  goto $bb37, $bb38;
$bb35:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 35} true;
  assume {:verifier.code 0} true;
  assume !(($i60 == 1));
  goto $bb36;
$bb36:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 63} true;
  assume {:verifier.code 0} true;
  $i64 := $M.8;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 63} true;
  assume {:verifier.code 0} true;
  $i65 := $trunc.i8.i1($i64);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 63} true;
  assume {:verifier.code 0} true;
  $i66 := $zext.i1.i32($i65);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 20} true;
  assume {:verifier.code 0} true;
  $i63 := $i66;
  goto $bb39;
$bb37:
  assume ($i62 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 20} true;
  assume {:verifier.code 0} true;
  $i63 := 0;
  goto $bb39;
$bb38:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 20} true;
  assume {:verifier.code 0} true;
  assume !(($i62 == 1));
  goto $bb36;
$bb39:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 20} true;
  assume {:verifier.code 0} true;
  $i67 := $ne.i32($i63, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 18} true;
  assume {:verifier.code 0} true;
  $i68 := $zext.i1.i8($i67);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 202, 18} true;
  assume {:verifier.code 0} true;
  $M.8 := $i68;
  call {:cexpr "x$r_buff0_thd1"} boogie_si_record_i8($i68);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 20} true;
  assume {:verifier.code 0} true;
  $i69 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 20} true;
  assume {:verifier.code 0} true;
  $i70 := $trunc.i8.i1($i69);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 35} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i70} true;
  goto $bb40, $bb41;
$bb40:
  assume ($i70 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 38} true;
  assume {:verifier.code 0} true;
  $i71 := $M.8;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 38} true;
  assume {:verifier.code 0} true;
  $i72 := $trunc.i8.i1($i71);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 53} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i72} true;
  goto $bb43, $bb45;
$bb41:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 35} true;
  assume {:verifier.code 0} true;
  assume !(($i70 == 1));
  goto $bb42;
$bb42:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 56} true;
  assume {:verifier.code 0} true;
  $i73 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 56} true;
  assume {:verifier.code 0} true;
  $i74 := $trunc.i8.i1($i73);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 71} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i74} true;
  goto $bb46, $bb47;
$bb43:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 53} true;
  assume {:verifier.code 0} true;
  assume ($i72 == 1);
  goto $bb44;
$bb44:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 20} true;
  assume {:verifier.code 0} true;
  $i77 := 0;
  goto $bb51;
$bb45:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 53} true;
  assume {:verifier.code 0} true;
  assume !(($i72 == 1));
  goto $bb42;
$bb46:
  assume ($i74 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 74} true;
  assume {:verifier.code 0} true;
  $i75 := $M.9;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 74} true;
  assume {:verifier.code 0} true;
  $i76 := $trunc.i8.i1($i75);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i76} true;
  goto $bb49, $bb50;
$bb47:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 71} true;
  assume {:verifier.code 0} true;
  assume !(($i74 == 1));
  goto $bb48;
$bb48:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 99} true;
  assume {:verifier.code 0} true;
  $i78 := $M.9;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 99} true;
  assume {:verifier.code 0} true;
  $i79 := $trunc.i8.i1($i78);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 99} true;
  assume {:verifier.code 0} true;
  $i80 := $zext.i1.i32($i79);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 20} true;
  assume {:verifier.code 0} true;
  $i77 := $i80;
  goto $bb51;
$bb49:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 20} true;
  assume {:verifier.code 0} true;
  assume ($i76 == 1);
  goto $bb44;
$bb50:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 20} true;
  assume {:verifier.code 0} true;
  assume !(($i76 == 1));
  goto $bb48;
$bb51:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 20} true;
  assume {:verifier.code 0} true;
  $i81 := $ne.i32($i77, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 18} true;
  assume {:verifier.code 0} true;
  $i82 := $zext.i1.i8($i81);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 203, 18} true;
  assume {:verifier.code 0} true;
  $M.9 := $i82;
  call {:cexpr "x$r_buff1_thd1"} boogie_si_record_i8($i82);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 204, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_end();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 205, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_begin();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 206, 22} true;
  assume {:verifier.code 0} true;
  $i83 := $M.13;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 206, 39} true;
  assume {:verifier.code 0} true;
  $i84 := $add.i32($i83, 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 206, 20} true;
  assume {:verifier.code 0} true;
  $M.13 := $i84;
  call {:cexpr "__unbuffered_cnt"} boogie_si_record_i32($i84);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 207, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_end();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 208, 3} true;
  assume {:verifier.code 0} true;
  $r := $0.ref;
  $exn := false;
  return;
}
const __VERIFIER_atomic_begin: ref;
axiom (__VERIFIER_atomic_begin == $sub.ref(0, 51384));
procedure __VERIFIER_atomic_begin();
const __VERIFIER_atomic_end: ref;
axiom (__VERIFIER_atomic_end == $sub.ref(0, 52416));
procedure __VERIFIER_atomic_end();
const P1: ref;
axiom (P1 == $sub.ref(0, 53448));
procedure P1($p0: ref)
  returns ($r: ref)
{
  var $i1: i1;
  var $i2: i8;
  var $i3: i1;
  var $i4: i8;
  var $i5: i8;
  var $i6: i1;
  var $i7: i8;
  var $i8: i32;
  var $i9: i1;
  var $i10: i8;
  var $i11: i8;
  var $i12: i1;
  var $i13: i32;
  var $i15: i8;
  var $i16: i1;
  var $i17: i8;
  var $i18: i1;
  var $i19: i32;
  var $i21: i8;
  var $i22: i1;
  var $i23: i8;
  var $i24: i1;
  var $i25: i8;
  var $i26: i1;
  var $i27: i8;
  var $i28: i1;
  var $i29: i8;
  var $i30: i1;
  var $i31: i32;
  var $i33: i8;
  var $i34: i1;
  var $i35: i32;
  var $i37: i32;
  var $i36: i32;
  var $i32: i32;
  var $i39: i8;
  var $i40: i1;
  var $i41: i8;
  var $i42: i1;
  var $i43: i8;
  var $i44: i1;
  var $i45: i8;
  var $i46: i1;
  var $i47: i8;
  var $i48: i1;
  var $i49: i32;
  var $i51: i32;
  var $i50: i32;
  var $i53: i8;
  var $i54: i1;
  var $i55: i32;
  var $i57: i32;
  var $i56: i32;
  var $i52: i32;
  var $i38: i32;
  var $i20: i32;
  var $i14: i32;
  var $i58: i8;
  var $i59: i1;
  var $i60: i32;
  var $i62: i8;
  var $i63: i1;
  var $i64: i32;
  var $i66: i8;
  var $i67: i1;
  var $i68: i8;
  var $i69: i1;
  var $i70: i32;
  var $i72: i8;
  var $i73: i1;
  var $i74: i8;
  var $i75: i1;
  var $i76: i8;
  var $i77: i1;
  var $i78: i8;
  var $i79: i1;
  var $i80: i32;
  var $i82: i8;
  var $i83: i1;
  var $i84: i8;
  var $i85: i1;
  var $i86: i8;
  var $i87: i1;
  var $i88: i8;
  var $i89: i1;
  var $i90: i32;
  var $i92: i32;
  var $i91: i32;
  var $i81: i32;
  var $i71: i32;
  var $i65: i32;
  var $i61: i32;
  var $i93: i8;
  var $i94: i1;
  var $i95: i32;
  var $i97: i8;
  var $i98: i1;
  var $i99: i32;
  var $i101: i8;
  var $i102: i1;
  var $i103: i8;
  var $i104: i1;
  var $i105: i32;
  var $i107: i8;
  var $i108: i1;
  var $i109: i8;
  var $i110: i1;
  var $i111: i8;
  var $i112: i1;
  var $i113: i8;
  var $i114: i1;
  var $i115: i32;
  var $i117: i8;
  var $i118: i1;
  var $i119: i8;
  var $i120: i1;
  var $i121: i8;
  var $i122: i1;
  var $i123: i8;
  var $i124: i1;
  var $i125: i32;
  var $i127: i32;
  var $i126: i32;
  var $i116: i32;
  var $i106: i32;
  var $i100: i32;
  var $i96: i32;
  var $i128: i8;
  var $i129: i1;
  var $i130: i8;
  var $i131: i1;
  var $i132: i32;
  var $i134: i8;
  var $i135: i1;
  var $i136: i8;
  var $i137: i1;
  var $i138: i32;
  var $i140: i8;
  var $i141: i1;
  var $i142: i8;
  var $i143: i1;
  var $i145: i8;
  var $i146: i1;
  var $i147: i8;
  var $i148: i1;
  var $i149: i8;
  var $i150: i1;
  var $i151: i8;
  var $i152: i1;
  var $i153: i8;
  var $i154: i1;
  var $i156: i8;
  var $i157: i1;
  var $i158: i1;
  var $i155: i1;
  var $i159: i32;
  var $i161: i8;
  var $i162: i1;
  var $i163: i8;
  var $i164: i1;
  var $i165: i8;
  var $i166: i1;
  var $i167: i8;
  var $i168: i1;
  var $i169: i8;
  var $i170: i1;
  var $i171: i32;
  var $i173: i8;
  var $i174: i1;
  var $i175: i32;
  var $i172: i32;
  var $i160: i32;
  var $i144: i32;
  var $i139: i32;
  var $i133: i32;
  var $i176: i1;
  var $i177: i8;
  var $i178: i8;
  var $i179: i1;
  var $i180: i8;
  var $i181: i1;
  var $i182: i32;
  var $i184: i8;
  var $i185: i1;
  var $i186: i8;
  var $i187: i1;
  var $i188: i32;
  var $i190: i8;
  var $i191: i1;
  var $i192: i8;
  var $i193: i1;
  var $i195: i8;
  var $i196: i1;
  var $i197: i8;
  var $i198: i1;
  var $i199: i8;
  var $i200: i1;
  var $i201: i8;
  var $i202: i1;
  var $i203: i8;
  var $i204: i1;
  var $i205: i32;
  var $i207: i8;
  var $i208: i1;
  var $i210: i8;
  var $i211: i1;
  var $i212: i8;
  var $i213: i1;
  var $i214: i8;
  var $i215: i1;
  var $i216: i1;
  var $i209: i1;
  var $i217: i32;
  var $i206: i32;
  var $i194: i32;
  var $i189: i32;
  var $i183: i32;
  var $i218: i1;
  var $i219: i8;
  var $i220: i8;
  var $i221: i1;
  var $i222: i8;
  var $i223: i1;
  var $i224: i32;
  var $i226: i8;
  var $i227: i1;
  var $i228: i8;
  var $i229: i1;
  var $i230: i32;
  var $i232: i8;
  var $i233: i1;
  var $i234: i8;
  var $i235: i1;
  var $i237: i8;
  var $i238: i1;
  var $i239: i8;
  var $i240: i1;
  var $i241: i8;
  var $i242: i1;
  var $i243: i8;
  var $i244: i1;
  var $i245: i8;
  var $i246: i1;
  var $i247: i32;
  var $i249: i8;
  var $i250: i1;
  var $i252: i8;
  var $i253: i1;
  var $i254: i8;
  var $i255: i1;
  var $i256: i8;
  var $i257: i1;
  var $i258: i1;
  var $i251: i1;
  var $i259: i32;
  var $i248: i32;
  var $i236: i32;
  var $i231: i32;
  var $i225: i32;
  var $i260: i1;
  var $i261: i8;
  var $i262: i8;
  var $i263: i1;
  var $i264: i8;
  var $i265: i1;
  var $i266: i32;
  var $i268: i8;
  var $i269: i1;
  var $i270: i8;
  var $i271: i1;
  var $i272: i32;
  var $i274: i8;
  var $i275: i1;
  var $i276: i8;
  var $i277: i1;
  var $i279: i8;
  var $i280: i1;
  var $i281: i8;
  var $i282: i1;
  var $i283: i8;
  var $i284: i1;
  var $i285: i8;
  var $i286: i1;
  var $i287: i8;
  var $i288: i1;
  var $i289: i8;
  var $i290: i1;
  var $i291: i32;
  var $i292: i32;
  var $i294: i8;
  var $i295: i1;
  var $i297: i8;
  var $i298: i1;
  var $i299: i8;
  var $i300: i1;
  var $i301: i8;
  var $i302: i1;
  var $i303: i1;
  var $i296: i1;
  var $i304: i32;
  var $i293: i32;
  var $i278: i32;
  var $i273: i32;
  var $i267: i32;
  var $i305: i1;
  var $i306: i8;
  var $i307: i32;
  var $i308: i8;
  var $i309: i1;
  var $i310: i32;
  var $i312: i32;
  var $i311: i32;
  var $i313: i8;
  var $i314: i1;
  var $i315: i8;
  var $i316: i1;
  var $i317: i32;
  var $i319: i8;
  var $i320: i1;
  var $i321: i8;
  var $i322: i1;
  var $i323: i32;
  var $i325: i32;
  var $i324: i32;
  var $i318: i32;
  var $i326: i8;
  var $i327: i1;
  var $i328: i8;
  var $i329: i1;
  var $i331: i8;
  var $i332: i1;
  var $i333: i32;
  var $i330: i32;
  var $i334: i1;
  var $i335: i8;
  var $i336: i8;
  var $i337: i1;
  var $i338: i8;
  var $i339: i1;
  var $i340: i8;
  var $i341: i1;
  var $i342: i8;
  var $i343: i1;
  var $i345: i8;
  var $i346: i1;
  var $i347: i32;
  var $i344: i32;
  var $i348: i1;
  var $i349: i8;
  var $i350: i8;
  var $i351: i1;
  var $i352: i8;
  var $i353: i1;
  var $i355: i8;
  var $i356: i1;
  var $i357: i32;
  var $i354: i32;
  var $i358: i1;
  var $i359: i8;
  var $i360: i8;
  var $i361: i1;
  var $i362: i8;
  var $i363: i1;
  var $i364: i8;
  var $i365: i1;
  var $i366: i8;
  var $i367: i1;
  var $i369: i8;
  var $i370: i1;
  var $i371: i32;
  var $i368: i32;
  var $i372: i1;
  var $i373: i8;
  var $i374: i32;
  var $i375: i32;
$bb0:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 215, 3} true;
  assume {:verifier.code 1} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 215, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_begin();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 216, 19} true;
  assume {:verifier.code 1} true;
  call $i1 := __VERIFIER_nondet_bool();
  call {:cexpr "smack:ext:__VERIFIER_nondet_bool"} boogie_si_record_i1($i1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 216, 17} true;
  assume {:verifier.code 0} true;
  $i2 := $zext.i1.i8($i1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 216, 17} true;
  assume {:verifier.code 0} true;
  $M.14 := $i2;
  call {:cexpr "weak$$choice0"} boogie_si_record_i8($i2);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 217, 19} true;
  assume {:verifier.code 1} true;
  call $i3 := __VERIFIER_nondet_bool();
  call {:cexpr "smack:ext:__VERIFIER_nondet_bool"} boogie_si_record_i1($i3);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 217, 17} true;
  assume {:verifier.code 0} true;
  $i4 := $zext.i1.i8($i3);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 217, 17} true;
  assume {:verifier.code 0} true;
  $M.15 := $i4;
  call {:cexpr "weak$$choice2"} boogie_si_record_i8($i4);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 218, 21} true;
  assume {:verifier.code 0} true;
  $i5 := $M.15;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 218, 21} true;
  assume {:verifier.code 0} true;
  $i6 := $trunc.i8.i1($i5);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 218, 19} true;
  assume {:verifier.code 0} true;
  $i7 := $zext.i1.i8($i6);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 218, 19} true;
  assume {:verifier.code 0} true;
  $M.16 := $i7;
  call {:cexpr "x$flush_delayed"} boogie_si_record_i8($i7);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 219, 15} true;
  assume {:verifier.code 0} true;
  $i8 := $M.12;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 219, 13} true;
  assume {:verifier.code 0} true;
  $M.17 := $i8;
  call {:cexpr "x$mem_tmp"} boogie_si_record_i32($i8);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 220, 19} true;
  assume {:verifier.code 1} true;
  call $i9 := __VERIFIER_nondet_bool();
  call {:cexpr "smack:ext:__VERIFIER_nondet_bool"} boogie_si_record_i1($i9);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 220, 17} true;
  assume {:verifier.code 0} true;
  $i10 := $zext.i1.i8($i9);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 220, 17} true;
  assume {:verifier.code 0} true;
  $M.18 := $i10;
  call {:cexpr "weak$$choice1"} boogie_si_record_i8($i10);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 8} true;
  assume {:verifier.code 0} true;
  $i11 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 8} true;
  assume {:verifier.code 0} true;
  $i12 := $trunc.i8.i1($i11);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i12} true;
  goto $bb1, $bb2;
$bb1:
  assume ($i12 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 30} true;
  assume {:verifier.code 0} true;
  $i15 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 30} true;
  assume {:verifier.code 0} true;
  $i16 := $trunc.i8.i1($i15);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 45} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i16} true;
  goto $bb4, $bb5;
$bb2:
  assume !(($i12 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 25} true;
  assume {:verifier.code 0} true;
  $i13 := $M.12;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 7} true;
  assume {:verifier.code 0} true;
  $i14 := $i13;
  goto $bb3;
$bb3:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 7} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 5} true;
  assume {:verifier.code 0} true;
  $M.12 := $i14;
  call {:cexpr "x"} boogie_si_record_i32($i14);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 15} true;
  assume {:verifier.code 0} true;
  $i58 := $M.15;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 15} true;
  assume {:verifier.code 0} true;
  $i59 := $trunc.i8.i1($i58);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 15} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i59} true;
  goto $bb42, $bb43;
$bb4:
  assume ($i16 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 48} true;
  assume {:verifier.code 0} true;
  $i17 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 48} true;
  assume {:verifier.code 0} true;
  $i18 := $trunc.i8.i1($i17);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 30} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i18} true;
  goto $bb7, $bb8;
$bb5:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 45} true;
  assume {:verifier.code 0} true;
  assume !(($i16 == 1));
  goto $bb6;
$bb6:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 78} true;
  assume {:verifier.code 0} true;
  $i21 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 78} true;
  assume {:verifier.code 0} true;
  $i22 := $trunc.i8.i1($i21);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 93} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i22} true;
  goto $bb10, $bb11;
$bb7:
  assume ($i18 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 65} true;
  assume {:verifier.code 0} true;
  $i19 := $M.2;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 30} true;
  assume {:verifier.code 0} true;
  $i20 := $i19;
  goto $bb9;
$bb8:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 30} true;
  assume {:verifier.code 0} true;
  assume !(($i18 == 1));
  goto $bb6;
$bb9:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 30} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 7} true;
  assume {:verifier.code 0} true;
  $i14 := $i20;
  goto $bb3;
$bb10:
  assume ($i22 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 97} true;
  assume {:verifier.code 0} true;
  $i23 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 97} true;
  assume {:verifier.code 0} true;
  $i24 := $trunc.i8.i1($i23);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 112} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i24} true;
  goto $bb13, $bb14;
$bb11:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 93} true;
  assume {:verifier.code 0} true;
  assume !(($i22 == 1));
  goto $bb12;
$bb12:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 216} true;
  assume {:verifier.code 0} true;
  $i39 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 216} true;
  assume {:verifier.code 0} true;
  $i40 := $trunc.i8.i1($i39);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 231} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i40} true;
  goto $bb26, $bb27;
$bb13:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 112} true;
  assume {:verifier.code 0} true;
  assume ($i24 == 1);
  goto $bb12;
$bb14:
  assume !(($i24 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 115} true;
  assume {:verifier.code 0} true;
  $i25 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 115} true;
  assume {:verifier.code 0} true;
  $i26 := $trunc.i8.i1($i25);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 130} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i26} true;
  goto $bb15, $bb16;
$bb15:
  assume ($i26 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 134} true;
  assume {:verifier.code 0} true;
  $i27 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 134} true;
  assume {:verifier.code 0} true;
  $i28 := $trunc.i8.i1($i27);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 78} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i28} true;
  goto $bb17, $bb18;
$bb16:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 130} true;
  assume {:verifier.code 0} true;
  assume !(($i26 == 1));
  goto $bb12;
$bb17:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 78} true;
  assume {:verifier.code 0} true;
  assume ($i28 == 1);
  goto $bb12;
$bb18:
  assume !(($i28 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 152} true;
  assume {:verifier.code 0} true;
  $i29 := $M.14;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 152} true;
  assume {:verifier.code 0} true;
  $i30 := $trunc.i8.i1($i29);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 152} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i30} true;
  goto $bb19, $bb20;
$bb19:
  assume ($i30 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 168} true;
  assume {:verifier.code 0} true;
  $i31 := $M.12;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 152} true;
  assume {:verifier.code 0} true;
  $i32 := $i31;
  goto $bb21;
$bb20:
  assume !(($i30 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 173} true;
  assume {:verifier.code 0} true;
  $i33 := $M.18;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 173} true;
  assume {:verifier.code 0} true;
  $i34 := $trunc.i8.i1($i33);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 173} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i34} true;
  goto $bb22, $bb23;
$bb21:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 152} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 78} true;
  assume {:verifier.code 0} true;
  $i38 := $i32;
  goto $bb25;
$bb22:
  assume ($i34 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 189} true;
  assume {:verifier.code 0} true;
  $i35 := $M.2;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 173} true;
  assume {:verifier.code 0} true;
  $i36 := $i35;
  goto $bb24;
$bb23:
  assume !(($i34 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 201} true;
  assume {:verifier.code 0} true;
  $i37 := $M.3;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 173} true;
  assume {:verifier.code 0} true;
  $i36 := $i37;
  goto $bb24;
$bb24:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 173} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 152} true;
  assume {:verifier.code 0} true;
  $i32 := $i36;
  goto $bb21;
$bb25:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 78} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 30} true;
  assume {:verifier.code 0} true;
  $i20 := $i38;
  goto $bb9;
$bb26:
  assume ($i40 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 234} true;
  assume {:verifier.code 0} true;
  $i41 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 234} true;
  assume {:verifier.code 0} true;
  $i42 := $trunc.i8.i1($i41);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 249} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i42} true;
  goto $bb29, $bb30;
$bb27:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 231} true;
  assume {:verifier.code 0} true;
  assume !(($i40 == 1));
  goto $bb28;
$bb28:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 331} true;
  assume {:verifier.code 0} true;
  $i53 := $M.14;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 331} true;
  assume {:verifier.code 0} true;
  $i54 := $trunc.i8.i1($i53);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 331} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i54} true;
  goto $bb39, $bb40;
$bb29:
  assume ($i42 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 252} true;
  assume {:verifier.code 0} true;
  $i43 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 252} true;
  assume {:verifier.code 0} true;
  $i44 := $trunc.i8.i1($i43);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 267} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i44} true;
  goto $bb31, $bb32;
$bb30:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 249} true;
  assume {:verifier.code 0} true;
  assume !(($i42 == 1));
  goto $bb28;
$bb31:
  assume ($i44 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 271} true;
  assume {:verifier.code 0} true;
  $i45 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 271} true;
  assume {:verifier.code 0} true;
  $i46 := $trunc.i8.i1($i45);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 216} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i46} true;
  goto $bb33, $bb34;
$bb32:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 267} true;
  assume {:verifier.code 0} true;
  assume !(($i44 == 1));
  goto $bb28;
$bb33:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 216} true;
  assume {:verifier.code 0} true;
  assume ($i46 == 1);
  goto $bb28;
$bb34:
  assume !(($i46 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 289} true;
  assume {:verifier.code 0} true;
  $i47 := $M.14;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 289} true;
  assume {:verifier.code 0} true;
  $i48 := $trunc.i8.i1($i47);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 289} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i48} true;
  goto $bb35, $bb36;
$bb35:
  assume ($i48 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 305} true;
  assume {:verifier.code 0} true;
  $i49 := $M.3;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 289} true;
  assume {:verifier.code 0} true;
  $i50 := $i49;
  goto $bb37;
$bb36:
  assume !(($i48 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 317} true;
  assume {:verifier.code 0} true;
  $i51 := $M.2;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 289} true;
  assume {:verifier.code 0} true;
  $i50 := $i51;
  goto $bb37;
$bb37:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 289} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 216} true;
  assume {:verifier.code 0} true;
  $i52 := $i50;
  goto $bb38;
$bb38:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 216} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 78} true;
  assume {:verifier.code 0} true;
  $i38 := $i52;
  goto $bb25;
$bb39:
  assume ($i54 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 347} true;
  assume {:verifier.code 0} true;
  $i55 := $M.2;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 331} true;
  assume {:verifier.code 0} true;
  $i56 := $i55;
  goto $bb41;
$bb40:
  assume !(($i54 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 359} true;
  assume {:verifier.code 0} true;
  $i57 := $M.12;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 331} true;
  assume {:verifier.code 0} true;
  $i56 := $i57;
  goto $bb41;
$bb41:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 331} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 221, 216} true;
  assume {:verifier.code 0} true;
  $i52 := $i56;
  goto $bb38;
$bb42:
  assume ($i59 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 31} true;
  assume {:verifier.code 0} true;
  $i60 := $M.2;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 15} true;
  assume {:verifier.code 0} true;
  $i61 := $i60;
  goto $bb44;
$bb43:
  assume !(($i59 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 45} true;
  assume {:verifier.code 0} true;
  $i62 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 45} true;
  assume {:verifier.code 0} true;
  $i63 := $trunc.i8.i1($i62);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 44} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i63} true;
  goto $bb45, $bb46;
$bb44:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 15} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 13} true;
  assume {:verifier.code 0} true;
  $M.2 := $i61;
  call {:cexpr "x$w_buff0"} boogie_si_record_i32($i61);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 15} true;
  assume {:verifier.code 0} true;
  $i93 := $M.15;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 15} true;
  assume {:verifier.code 0} true;
  $i94 := $trunc.i8.i1($i93);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 15} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i94} true;
  goto $bb74, $bb75;
$bb45:
  assume ($i63 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 75} true;
  assume {:verifier.code 0} true;
  $i66 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 75} true;
  assume {:verifier.code 0} true;
  $i67 := $trunc.i8.i1($i66);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 90} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i67} true;
  goto $bb48, $bb49;
$bb46:
  assume !(($i63 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 62} true;
  assume {:verifier.code 0} true;
  $i64 := $M.2;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 44} true;
  assume {:verifier.code 0} true;
  $i65 := $i64;
  goto $bb47;
$bb47:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 44} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 15} true;
  assume {:verifier.code 0} true;
  $i61 := $i65;
  goto $bb44;
$bb48:
  assume ($i67 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 93} true;
  assume {:verifier.code 0} true;
  $i68 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 93} true;
  assume {:verifier.code 0} true;
  $i69 := $trunc.i8.i1($i68);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 75} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i69} true;
  goto $bb51, $bb52;
$bb49:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 90} true;
  assume {:verifier.code 0} true;
  assume !(($i67 == 1));
  goto $bb50;
$bb50:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 123} true;
  assume {:verifier.code 0} true;
  $i72 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 123} true;
  assume {:verifier.code 0} true;
  $i73 := $trunc.i8.i1($i72);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 138} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i73} true;
  goto $bb54, $bb55;
$bb51:
  assume ($i69 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 110} true;
  assume {:verifier.code 0} true;
  $i70 := $M.2;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 75} true;
  assume {:verifier.code 0} true;
  $i71 := $i70;
  goto $bb53;
$bb52:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 75} true;
  assume {:verifier.code 0} true;
  assume !(($i69 == 1));
  goto $bb50;
$bb53:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 75} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 44} true;
  assume {:verifier.code 0} true;
  $i65 := $i71;
  goto $bb47;
$bb54:
  assume ($i73 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 142} true;
  assume {:verifier.code 0} true;
  $i74 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 142} true;
  assume {:verifier.code 0} true;
  $i75 := $trunc.i8.i1($i74);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 157} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i75} true;
  goto $bb57, $bb58;
$bb55:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 138} true;
  assume {:verifier.code 0} true;
  assume !(($i73 == 1));
  goto $bb56;
$bb56:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 209} true;
  assume {:verifier.code 0} true;
  $i82 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 209} true;
  assume {:verifier.code 0} true;
  $i83 := $trunc.i8.i1($i82);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 224} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i83} true;
  goto $bb64, $bb65;
$bb57:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 157} true;
  assume {:verifier.code 0} true;
  assume ($i75 == 1);
  goto $bb56;
$bb58:
  assume !(($i75 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 160} true;
  assume {:verifier.code 0} true;
  $i76 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 160} true;
  assume {:verifier.code 0} true;
  $i77 := $trunc.i8.i1($i76);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 175} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i77} true;
  goto $bb59, $bb60;
$bb59:
  assume ($i77 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 179} true;
  assume {:verifier.code 0} true;
  $i78 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 179} true;
  assume {:verifier.code 0} true;
  $i79 := $trunc.i8.i1($i78);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 123} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i79} true;
  goto $bb61, $bb62;
$bb60:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 175} true;
  assume {:verifier.code 0} true;
  assume !(($i77 == 1));
  goto $bb56;
$bb61:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 123} true;
  assume {:verifier.code 0} true;
  assume ($i79 == 1);
  goto $bb56;
$bb62:
  assume !(($i79 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 196} true;
  assume {:verifier.code 0} true;
  $i80 := $M.2;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 123} true;
  assume {:verifier.code 0} true;
  $i81 := $i80;
  goto $bb63;
$bb63:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 123} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 75} true;
  assume {:verifier.code 0} true;
  $i71 := $i81;
  goto $bb53;
$bb64:
  assume ($i83 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 227} true;
  assume {:verifier.code 0} true;
  $i84 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 227} true;
  assume {:verifier.code 0} true;
  $i85 := $trunc.i8.i1($i84);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 242} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i85} true;
  goto $bb67, $bb68;
$bb65:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 224} true;
  assume {:verifier.code 0} true;
  assume !(($i83 == 1));
  goto $bb66;
$bb66:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 293} true;
  assume {:verifier.code 0} true;
  $i92 := $M.2;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 209} true;
  assume {:verifier.code 0} true;
  $i91 := $i92;
  goto $bb73;
$bb67:
  assume ($i85 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 245} true;
  assume {:verifier.code 0} true;
  $i86 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 245} true;
  assume {:verifier.code 0} true;
  $i87 := $trunc.i8.i1($i86);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 260} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i87} true;
  goto $bb69, $bb70;
$bb68:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 242} true;
  assume {:verifier.code 0} true;
  assume !(($i85 == 1));
  goto $bb66;
$bb69:
  assume ($i87 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 264} true;
  assume {:verifier.code 0} true;
  $i88 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 264} true;
  assume {:verifier.code 0} true;
  $i89 := $trunc.i8.i1($i88);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 209} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i89} true;
  goto $bb71, $bb72;
$bb70:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 260} true;
  assume {:verifier.code 0} true;
  assume !(($i87 == 1));
  goto $bb66;
$bb71:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 209} true;
  assume {:verifier.code 0} true;
  assume ($i89 == 1);
  goto $bb66;
$bb72:
  assume !(($i89 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 281} true;
  assume {:verifier.code 0} true;
  $i90 := $M.2;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 209} true;
  assume {:verifier.code 0} true;
  $i91 := $i90;
  goto $bb73;
$bb73:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 209} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 222, 123} true;
  assume {:verifier.code 0} true;
  $i81 := $i91;
  goto $bb63;
$bb74:
  assume ($i94 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 31} true;
  assume {:verifier.code 0} true;
  $i95 := $M.3;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 15} true;
  assume {:verifier.code 0} true;
  $i96 := $i95;
  goto $bb76;
$bb75:
  assume !(($i94 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 45} true;
  assume {:verifier.code 0} true;
  $i97 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 45} true;
  assume {:verifier.code 0} true;
  $i98 := $trunc.i8.i1($i97);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 44} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i98} true;
  goto $bb77, $bb78;
$bb76:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 15} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 13} true;
  assume {:verifier.code 0} true;
  $M.3 := $i96;
  call {:cexpr "x$w_buff1"} boogie_si_record_i32($i96);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 20} true;
  assume {:verifier.code 0} true;
  $i128 := $M.15;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 20} true;
  assume {:verifier.code 0} true;
  $i129 := $trunc.i8.i1($i128);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i129} true;
  goto $bb106, $bb107;
$bb77:
  assume ($i98 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 75} true;
  assume {:verifier.code 0} true;
  $i101 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 75} true;
  assume {:verifier.code 0} true;
  $i102 := $trunc.i8.i1($i101);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 90} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i102} true;
  goto $bb80, $bb81;
$bb78:
  assume !(($i98 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 62} true;
  assume {:verifier.code 0} true;
  $i99 := $M.3;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 44} true;
  assume {:verifier.code 0} true;
  $i100 := $i99;
  goto $bb79;
$bb79:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 44} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 15} true;
  assume {:verifier.code 0} true;
  $i96 := $i100;
  goto $bb76;
$bb80:
  assume ($i102 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 93} true;
  assume {:verifier.code 0} true;
  $i103 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 93} true;
  assume {:verifier.code 0} true;
  $i104 := $trunc.i8.i1($i103);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 75} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i104} true;
  goto $bb83, $bb84;
$bb81:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 90} true;
  assume {:verifier.code 0} true;
  assume !(($i102 == 1));
  goto $bb82;
$bb82:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 123} true;
  assume {:verifier.code 0} true;
  $i107 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 123} true;
  assume {:verifier.code 0} true;
  $i108 := $trunc.i8.i1($i107);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 138} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i108} true;
  goto $bb86, $bb87;
$bb83:
  assume ($i104 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 110} true;
  assume {:verifier.code 0} true;
  $i105 := $M.3;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 75} true;
  assume {:verifier.code 0} true;
  $i106 := $i105;
  goto $bb85;
$bb84:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 75} true;
  assume {:verifier.code 0} true;
  assume !(($i104 == 1));
  goto $bb82;
$bb85:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 75} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 44} true;
  assume {:verifier.code 0} true;
  $i100 := $i106;
  goto $bb79;
$bb86:
  assume ($i108 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 142} true;
  assume {:verifier.code 0} true;
  $i109 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 142} true;
  assume {:verifier.code 0} true;
  $i110 := $trunc.i8.i1($i109);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 157} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i110} true;
  goto $bb89, $bb90;
$bb87:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 138} true;
  assume {:verifier.code 0} true;
  assume !(($i108 == 1));
  goto $bb88;
$bb88:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 209} true;
  assume {:verifier.code 0} true;
  $i117 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 209} true;
  assume {:verifier.code 0} true;
  $i118 := $trunc.i8.i1($i117);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 224} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i118} true;
  goto $bb96, $bb97;
$bb89:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 157} true;
  assume {:verifier.code 0} true;
  assume ($i110 == 1);
  goto $bb88;
$bb90:
  assume !(($i110 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 160} true;
  assume {:verifier.code 0} true;
  $i111 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 160} true;
  assume {:verifier.code 0} true;
  $i112 := $trunc.i8.i1($i111);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 175} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i112} true;
  goto $bb91, $bb92;
$bb91:
  assume ($i112 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 179} true;
  assume {:verifier.code 0} true;
  $i113 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 179} true;
  assume {:verifier.code 0} true;
  $i114 := $trunc.i8.i1($i113);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 123} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i114} true;
  goto $bb93, $bb94;
$bb92:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 175} true;
  assume {:verifier.code 0} true;
  assume !(($i112 == 1));
  goto $bb88;
$bb93:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 123} true;
  assume {:verifier.code 0} true;
  assume ($i114 == 1);
  goto $bb88;
$bb94:
  assume !(($i114 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 196} true;
  assume {:verifier.code 0} true;
  $i115 := $M.3;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 123} true;
  assume {:verifier.code 0} true;
  $i116 := $i115;
  goto $bb95;
$bb95:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 123} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 75} true;
  assume {:verifier.code 0} true;
  $i106 := $i116;
  goto $bb85;
$bb96:
  assume ($i118 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 227} true;
  assume {:verifier.code 0} true;
  $i119 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 227} true;
  assume {:verifier.code 0} true;
  $i120 := $trunc.i8.i1($i119);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 242} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i120} true;
  goto $bb99, $bb100;
$bb97:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 224} true;
  assume {:verifier.code 0} true;
  assume !(($i118 == 1));
  goto $bb98;
$bb98:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 293} true;
  assume {:verifier.code 0} true;
  $i127 := $M.3;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 209} true;
  assume {:verifier.code 0} true;
  $i126 := $i127;
  goto $bb105;
$bb99:
  assume ($i120 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 245} true;
  assume {:verifier.code 0} true;
  $i121 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 245} true;
  assume {:verifier.code 0} true;
  $i122 := $trunc.i8.i1($i121);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 260} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i122} true;
  goto $bb101, $bb102;
$bb100:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 242} true;
  assume {:verifier.code 0} true;
  assume !(($i120 == 1));
  goto $bb98;
$bb101:
  assume ($i122 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 264} true;
  assume {:verifier.code 0} true;
  $i123 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 264} true;
  assume {:verifier.code 0} true;
  $i124 := $trunc.i8.i1($i123);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 209} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i124} true;
  goto $bb103, $bb104;
$bb102:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 260} true;
  assume {:verifier.code 0} true;
  assume !(($i122 == 1));
  goto $bb98;
$bb103:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 209} true;
  assume {:verifier.code 0} true;
  assume ($i124 == 1);
  goto $bb98;
$bb104:
  assume !(($i124 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 281} true;
  assume {:verifier.code 0} true;
  $i125 := $M.3;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 209} true;
  assume {:verifier.code 0} true;
  $i126 := $i125;
  goto $bb105;
$bb105:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 209} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 223, 123} true;
  assume {:verifier.code 0} true;
  $i116 := $i126;
  goto $bb95;
$bb106:
  assume ($i129 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 36} true;
  assume {:verifier.code 0} true;
  $i130 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 36} true;
  assume {:verifier.code 0} true;
  $i131 := $trunc.i8.i1($i130);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 36} true;
  assume {:verifier.code 0} true;
  $i132 := $zext.i1.i32($i131);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 20} true;
  assume {:verifier.code 0} true;
  $i133 := $i132;
  goto $bb108;
$bb107:
  assume !(($i129 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 55} true;
  assume {:verifier.code 0} true;
  $i134 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 55} true;
  assume {:verifier.code 0} true;
  $i135 := $trunc.i8.i1($i134);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 54} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i135} true;
  goto $bb109, $bb110;
$bb108:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 20} true;
  assume {:verifier.code 0} true;
  $i176 := $ne.i32($i133, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 18} true;
  assume {:verifier.code 0} true;
  $i177 := $zext.i1.i8($i176);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 18} true;
  assume {:verifier.code 0} true;
  $M.4 := $i177;
  call {:cexpr "x$w_buff0_used"} boogie_si_record_i8($i177);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 20} true;
  assume {:verifier.code 0} true;
  $i178 := $M.15;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 20} true;
  assume {:verifier.code 0} true;
  $i179 := $trunc.i8.i1($i178);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i179} true;
  goto $bb141, $bb142;
$bb109:
  assume ($i135 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 90} true;
  assume {:verifier.code 0} true;
  $i140 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 90} true;
  assume {:verifier.code 0} true;
  $i141 := $trunc.i8.i1($i140);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 105} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i141} true;
  goto $bb112, $bb113;
$bb110:
  assume !(($i135 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 72} true;
  assume {:verifier.code 0} true;
  $i136 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 72} true;
  assume {:verifier.code 0} true;
  $i137 := $trunc.i8.i1($i136);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 72} true;
  assume {:verifier.code 0} true;
  $i138 := $zext.i1.i32($i137);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 54} true;
  assume {:verifier.code 0} true;
  $i139 := $i138;
  goto $bb111;
$bb111:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 54} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 20} true;
  assume {:verifier.code 0} true;
  $i133 := $i139;
  goto $bb108;
$bb112:
  assume ($i141 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 108} true;
  assume {:verifier.code 0} true;
  $i142 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 108} true;
  assume {:verifier.code 0} true;
  $i143 := $trunc.i8.i1($i142);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 90} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i143} true;
  goto $bb115, $bb116;
$bb113:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 105} true;
  assume {:verifier.code 0} true;
  assume !(($i141 == 1));
  goto $bb114;
$bb114:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 134} true;
  assume {:verifier.code 0} true;
  $i145 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 134} true;
  assume {:verifier.code 0} true;
  $i146 := $trunc.i8.i1($i145);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 149} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i146} true;
  goto $bb118, $bb119;
$bb115:
  assume ($i143 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 90} true;
  assume {:verifier.code 0} true;
  $i144 := 0;
  goto $bb117;
$bb116:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 90} true;
  assume {:verifier.code 0} true;
  assume !(($i143 == 1));
  goto $bb114;
$bb117:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 90} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 54} true;
  assume {:verifier.code 0} true;
  $i139 := $i144;
  goto $bb111;
$bb118:
  assume ($i146 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 153} true;
  assume {:verifier.code 0} true;
  $i147 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 153} true;
  assume {:verifier.code 0} true;
  $i148 := $trunc.i8.i1($i147);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 168} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i148} true;
  goto $bb121, $bb122;
$bb119:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 149} true;
  assume {:verifier.code 0} true;
  assume !(($i146 == 1));
  goto $bb120;
$bb120:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 242} true;
  assume {:verifier.code 0} true;
  $i161 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 242} true;
  assume {:verifier.code 0} true;
  $i162 := $trunc.i8.i1($i161);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 257} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i162} true;
  goto $bb131, $bb132;
$bb121:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 168} true;
  assume {:verifier.code 0} true;
  assume ($i148 == 1);
  goto $bb120;
$bb122:
  assume !(($i148 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 171} true;
  assume {:verifier.code 0} true;
  $i149 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 171} true;
  assume {:verifier.code 0} true;
  $i150 := $trunc.i8.i1($i149);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 186} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i150} true;
  goto $bb123, $bb124;
$bb123:
  assume ($i150 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 190} true;
  assume {:verifier.code 0} true;
  $i151 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 190} true;
  assume {:verifier.code 0} true;
  $i152 := $trunc.i8.i1($i151);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 134} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i152} true;
  goto $bb125, $bb126;
$bb124:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 186} true;
  assume {:verifier.code 0} true;
  assume !(($i150 == 1));
  goto $bb120;
$bb125:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 134} true;
  assume {:verifier.code 0} true;
  assume ($i152 == 1);
  goto $bb120;
$bb126:
  assume !(($i152 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 207} true;
  assume {:verifier.code 0} true;
  $i153 := $M.14;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 207} true;
  assume {:verifier.code 0} true;
  $i154 := $trunc.i8.i1($i153);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 221} true;
  assume {:verifier.code 0} true;
  $i155 := 1;
  assume {:branchcond $i154} true;
  goto $bb127, $bb129;
$bb127:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 221} true;
  assume {:verifier.code 0} true;
  assume ($i154 == 1);
  goto $bb128;
$bb128:
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 221} true;
  assume {:verifier.code 0} true;
  $i159 := $zext.i1.i32($i155);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 134} true;
  assume {:verifier.code 0} true;
  $i160 := $i159;
  goto $bb130;
$bb129:
  assume !(($i154 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 225} true;
  assume {:verifier.code 0} true;
  $i156 := $M.18;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 225} true;
  assume {:verifier.code 0} true;
  $i157 := $trunc.i8.i1($i156);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 224} true;
  assume {:verifier.code 0} true;
  $i158 := $xor.i1($i157, 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 221} true;
  assume {:verifier.code 0} true;
  $i155 := $i158;
  goto $bb128;
$bb130:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 134} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 90} true;
  assume {:verifier.code 0} true;
  $i144 := $i160;
  goto $bb117;
$bb131:
  assume ($i162 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 260} true;
  assume {:verifier.code 0} true;
  $i163 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 260} true;
  assume {:verifier.code 0} true;
  $i164 := $trunc.i8.i1($i163);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 275} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i164} true;
  goto $bb134, $bb135;
$bb132:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 257} true;
  assume {:verifier.code 0} true;
  assume !(($i162 == 1));
  goto $bb133;
$bb133:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 330} true;
  assume {:verifier.code 0} true;
  $i173 := $M.14;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 330} true;
  assume {:verifier.code 0} true;
  $i174 := $trunc.i8.i1($i173);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 330} true;
  assume {:verifier.code 0} true;
  $i175 := $zext.i1.i32($i174);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 242} true;
  assume {:verifier.code 0} true;
  $i172 := $i175;
  goto $bb140;
$bb134:
  assume ($i164 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 278} true;
  assume {:verifier.code 0} true;
  $i165 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 278} true;
  assume {:verifier.code 0} true;
  $i166 := $trunc.i8.i1($i165);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 293} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i166} true;
  goto $bb136, $bb137;
$bb135:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 275} true;
  assume {:verifier.code 0} true;
  assume !(($i164 == 1));
  goto $bb133;
$bb136:
  assume ($i166 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 297} true;
  assume {:verifier.code 0} true;
  $i167 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 297} true;
  assume {:verifier.code 0} true;
  $i168 := $trunc.i8.i1($i167);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 242} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i168} true;
  goto $bb138, $bb139;
$bb137:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 293} true;
  assume {:verifier.code 0} true;
  assume !(($i166 == 1));
  goto $bb133;
$bb138:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 242} true;
  assume {:verifier.code 0} true;
  assume ($i168 == 1);
  goto $bb133;
$bb139:
  assume !(($i168 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 314} true;
  assume {:verifier.code 0} true;
  $i169 := $M.14;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 314} true;
  assume {:verifier.code 0} true;
  $i170 := $trunc.i8.i1($i169);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 314} true;
  assume {:verifier.code 0} true;
  $i171 := $zext.i1.i32($i170);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 242} true;
  assume {:verifier.code 0} true;
  $i172 := $i171;
  goto $bb140;
$bb140:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 242} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 224, 134} true;
  assume {:verifier.code 0} true;
  $i160 := $i172;
  goto $bb130;
$bb141:
  assume ($i179 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 36} true;
  assume {:verifier.code 0} true;
  $i180 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 36} true;
  assume {:verifier.code 0} true;
  $i181 := $trunc.i8.i1($i180);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 36} true;
  assume {:verifier.code 0} true;
  $i182 := $zext.i1.i32($i181);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 20} true;
  assume {:verifier.code 0} true;
  $i183 := $i182;
  goto $bb143;
$bb142:
  assume !(($i179 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 55} true;
  assume {:verifier.code 0} true;
  $i184 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 55} true;
  assume {:verifier.code 0} true;
  $i185 := $trunc.i8.i1($i184);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 54} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i185} true;
  goto $bb144, $bb145;
$bb143:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 20} true;
  assume {:verifier.code 0} true;
  $i218 := $ne.i32($i183, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 18} true;
  assume {:verifier.code 0} true;
  $i219 := $zext.i1.i8($i218);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 18} true;
  assume {:verifier.code 0} true;
  $M.5 := $i219;
  call {:cexpr "x$w_buff1_used"} boogie_si_record_i8($i219);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 20} true;
  assume {:verifier.code 0} true;
  $i220 := $M.15;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 20} true;
  assume {:verifier.code 0} true;
  $i221 := $trunc.i8.i1($i220);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i221} true;
  goto $bb170, $bb171;
$bb144:
  assume ($i185 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 90} true;
  assume {:verifier.code 0} true;
  $i190 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 90} true;
  assume {:verifier.code 0} true;
  $i191 := $trunc.i8.i1($i190);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 105} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i191} true;
  goto $bb147, $bb148;
$bb145:
  assume !(($i185 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 72} true;
  assume {:verifier.code 0} true;
  $i186 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 72} true;
  assume {:verifier.code 0} true;
  $i187 := $trunc.i8.i1($i186);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 72} true;
  assume {:verifier.code 0} true;
  $i188 := $zext.i1.i32($i187);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 54} true;
  assume {:verifier.code 0} true;
  $i189 := $i188;
  goto $bb146;
$bb146:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 54} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 20} true;
  assume {:verifier.code 0} true;
  $i183 := $i189;
  goto $bb143;
$bb147:
  assume ($i191 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 108} true;
  assume {:verifier.code 0} true;
  $i192 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 108} true;
  assume {:verifier.code 0} true;
  $i193 := $trunc.i8.i1($i192);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 90} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i193} true;
  goto $bb150, $bb151;
$bb148:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 105} true;
  assume {:verifier.code 0} true;
  assume !(($i191 == 1));
  goto $bb149;
$bb149:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 134} true;
  assume {:verifier.code 0} true;
  $i195 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 134} true;
  assume {:verifier.code 0} true;
  $i196 := $trunc.i8.i1($i195);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 149} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i196} true;
  goto $bb153, $bb154;
$bb150:
  assume ($i193 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 90} true;
  assume {:verifier.code 0} true;
  $i194 := 0;
  goto $bb152;
$bb151:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 90} true;
  assume {:verifier.code 0} true;
  assume !(($i193 == 1));
  goto $bb149;
$bb152:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 90} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 54} true;
  assume {:verifier.code 0} true;
  $i189 := $i194;
  goto $bb146;
$bb153:
  assume ($i196 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 153} true;
  assume {:verifier.code 0} true;
  $i197 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 153} true;
  assume {:verifier.code 0} true;
  $i198 := $trunc.i8.i1($i197);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 168} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i198} true;
  goto $bb156, $bb157;
$bb154:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 149} true;
  assume {:verifier.code 0} true;
  assume !(($i196 == 1));
  goto $bb155;
$bb155:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 224} true;
  assume {:verifier.code 0} true;
  $i207 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 224} true;
  assume {:verifier.code 0} true;
  $i208 := $trunc.i8.i1($i207);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 239} true;
  assume {:verifier.code 0} true;
  $i209 := 0;
  assume {:branchcond $i208} true;
  goto $bb163, $bb164;
$bb156:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 168} true;
  assume {:verifier.code 0} true;
  assume ($i198 == 1);
  goto $bb155;
$bb157:
  assume !(($i198 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 171} true;
  assume {:verifier.code 0} true;
  $i199 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 171} true;
  assume {:verifier.code 0} true;
  $i200 := $trunc.i8.i1($i199);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 186} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i200} true;
  goto $bb158, $bb159;
$bb158:
  assume ($i200 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 190} true;
  assume {:verifier.code 0} true;
  $i201 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 190} true;
  assume {:verifier.code 0} true;
  $i202 := $trunc.i8.i1($i201);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 134} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i202} true;
  goto $bb160, $bb161;
$bb159:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 186} true;
  assume {:verifier.code 0} true;
  assume !(($i200 == 1));
  goto $bb155;
$bb160:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 134} true;
  assume {:verifier.code 0} true;
  assume ($i202 == 1);
  goto $bb155;
$bb161:
  assume !(($i202 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 207} true;
  assume {:verifier.code 0} true;
  $i203 := $M.14;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 207} true;
  assume {:verifier.code 0} true;
  $i204 := $trunc.i8.i1($i203);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 207} true;
  assume {:verifier.code 0} true;
  $i205 := $zext.i1.i32($i204);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 134} true;
  assume {:verifier.code 0} true;
  $i206 := $i205;
  goto $bb162;
$bb162:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 134} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 90} true;
  assume {:verifier.code 0} true;
  $i194 := $i206;
  goto $bb152;
$bb163:
  assume ($i208 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 242} true;
  assume {:verifier.code 0} true;
  $i210 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 242} true;
  assume {:verifier.code 0} true;
  $i211 := $trunc.i8.i1($i210);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 257} true;
  assume {:verifier.code 0} true;
  $i209 := 0;
  assume {:branchcond $i211} true;
  goto $bb166, $bb167;
$bb164:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 239} true;
  assume {:verifier.code 0} true;
  assume !(($i208 == 1));
  goto $bb165;
$bb165:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 224} true;
  assume {:verifier.code 0} true;
  $i217 := (if ($i209 == 1) then 0 else 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 134} true;
  assume {:verifier.code 0} true;
  $i206 := $i217;
  goto $bb162;
$bb166:
  assume ($i211 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 260} true;
  assume {:verifier.code 0} true;
  $i212 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 260} true;
  assume {:verifier.code 0} true;
  $i213 := $trunc.i8.i1($i212);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 275} true;
  assume {:verifier.code 0} true;
  $i209 := 0;
  assume {:branchcond $i213} true;
  goto $bb168, $bb169;
$bb167:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 257} true;
  assume {:verifier.code 0} true;
  assume !(($i211 == 1));
  goto $bb165;
$bb168:
  assume ($i213 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 279} true;
  assume {:verifier.code 0} true;
  $i214 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 279} true;
  assume {:verifier.code 0} true;
  $i215 := $trunc.i8.i1($i214);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 278} true;
  assume {:verifier.code 0} true;
  $i216 := $xor.i1($i215, 1);
  assume {:verifier.code 0} true;
  $i209 := $i216;
  goto $bb165;
$bb169:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 225, 275} true;
  assume {:verifier.code 0} true;
  assume !(($i213 == 1));
  goto $bb165;
$bb170:
  assume ($i221 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 36} true;
  assume {:verifier.code 0} true;
  $i222 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 36} true;
  assume {:verifier.code 0} true;
  $i223 := $trunc.i8.i1($i222);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 36} true;
  assume {:verifier.code 0} true;
  $i224 := $zext.i1.i32($i223);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 20} true;
  assume {:verifier.code 0} true;
  $i225 := $i224;
  goto $bb172;
$bb171:
  assume !(($i221 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 55} true;
  assume {:verifier.code 0} true;
  $i226 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 55} true;
  assume {:verifier.code 0} true;
  $i227 := $trunc.i8.i1($i226);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 54} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i227} true;
  goto $bb173, $bb174;
$bb172:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 20} true;
  assume {:verifier.code 0} true;
  $i260 := $ne.i32($i225, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 18} true;
  assume {:verifier.code 0} true;
  $i261 := $zext.i1.i8($i260);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 18} true;
  assume {:verifier.code 0} true;
  $M.10 := $i261;
  call {:cexpr "x$r_buff0_thd2"} boogie_si_record_i8($i261);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 20} true;
  assume {:verifier.code 0} true;
  $i262 := $M.15;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 20} true;
  assume {:verifier.code 0} true;
  $i263 := $trunc.i8.i1($i262);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i263} true;
  goto $bb199, $bb200;
$bb173:
  assume ($i227 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 90} true;
  assume {:verifier.code 0} true;
  $i232 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 90} true;
  assume {:verifier.code 0} true;
  $i233 := $trunc.i8.i1($i232);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 105} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i233} true;
  goto $bb176, $bb177;
$bb174:
  assume !(($i227 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 72} true;
  assume {:verifier.code 0} true;
  $i228 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 72} true;
  assume {:verifier.code 0} true;
  $i229 := $trunc.i8.i1($i228);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 72} true;
  assume {:verifier.code 0} true;
  $i230 := $zext.i1.i32($i229);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 54} true;
  assume {:verifier.code 0} true;
  $i231 := $i230;
  goto $bb175;
$bb175:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 54} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 20} true;
  assume {:verifier.code 0} true;
  $i225 := $i231;
  goto $bb172;
$bb176:
  assume ($i233 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 108} true;
  assume {:verifier.code 0} true;
  $i234 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 108} true;
  assume {:verifier.code 0} true;
  $i235 := $trunc.i8.i1($i234);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 90} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i235} true;
  goto $bb179, $bb180;
$bb177:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 105} true;
  assume {:verifier.code 0} true;
  assume !(($i233 == 1));
  goto $bb178;
$bb178:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 134} true;
  assume {:verifier.code 0} true;
  $i237 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 134} true;
  assume {:verifier.code 0} true;
  $i238 := $trunc.i8.i1($i237);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 149} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i238} true;
  goto $bb182, $bb183;
$bb179:
  assume ($i235 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 90} true;
  assume {:verifier.code 0} true;
  $i236 := 0;
  goto $bb181;
$bb180:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 90} true;
  assume {:verifier.code 0} true;
  assume !(($i235 == 1));
  goto $bb178;
$bb181:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 90} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 54} true;
  assume {:verifier.code 0} true;
  $i231 := $i236;
  goto $bb175;
$bb182:
  assume ($i238 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 153} true;
  assume {:verifier.code 0} true;
  $i239 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 153} true;
  assume {:verifier.code 0} true;
  $i240 := $trunc.i8.i1($i239);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 168} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i240} true;
  goto $bb185, $bb186;
$bb183:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 149} true;
  assume {:verifier.code 0} true;
  assume !(($i238 == 1));
  goto $bb184;
$bb184:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 225} true;
  assume {:verifier.code 0} true;
  $i249 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 225} true;
  assume {:verifier.code 0} true;
  $i250 := $trunc.i8.i1($i249);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 240} true;
  assume {:verifier.code 0} true;
  $i251 := 0;
  assume {:branchcond $i250} true;
  goto $bb192, $bb193;
$bb185:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 168} true;
  assume {:verifier.code 0} true;
  assume ($i240 == 1);
  goto $bb184;
$bb186:
  assume !(($i240 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 171} true;
  assume {:verifier.code 0} true;
  $i241 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 171} true;
  assume {:verifier.code 0} true;
  $i242 := $trunc.i8.i1($i241);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 186} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i242} true;
  goto $bb187, $bb188;
$bb187:
  assume ($i242 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 190} true;
  assume {:verifier.code 0} true;
  $i243 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 190} true;
  assume {:verifier.code 0} true;
  $i244 := $trunc.i8.i1($i243);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 134} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i244} true;
  goto $bb189, $bb190;
$bb188:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 186} true;
  assume {:verifier.code 0} true;
  assume !(($i242 == 1));
  goto $bb184;
$bb189:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 134} true;
  assume {:verifier.code 0} true;
  assume ($i244 == 1);
  goto $bb184;
$bb190:
  assume !(($i244 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 207} true;
  assume {:verifier.code 0} true;
  $i245 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 207} true;
  assume {:verifier.code 0} true;
  $i246 := $trunc.i8.i1($i245);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 207} true;
  assume {:verifier.code 0} true;
  $i247 := $zext.i1.i32($i246);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 134} true;
  assume {:verifier.code 0} true;
  $i248 := $i247;
  goto $bb191;
$bb191:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 134} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 90} true;
  assume {:verifier.code 0} true;
  $i236 := $i248;
  goto $bb181;
$bb192:
  assume ($i250 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 243} true;
  assume {:verifier.code 0} true;
  $i252 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 243} true;
  assume {:verifier.code 0} true;
  $i253 := $trunc.i8.i1($i252);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 258} true;
  assume {:verifier.code 0} true;
  $i251 := 0;
  assume {:branchcond $i253} true;
  goto $bb195, $bb196;
$bb193:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 240} true;
  assume {:verifier.code 0} true;
  assume !(($i250 == 1));
  goto $bb194;
$bb194:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 225} true;
  assume {:verifier.code 0} true;
  $i259 := (if ($i251 == 1) then 0 else 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 134} true;
  assume {:verifier.code 0} true;
  $i248 := $i259;
  goto $bb191;
$bb195:
  assume ($i253 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 261} true;
  assume {:verifier.code 0} true;
  $i254 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 261} true;
  assume {:verifier.code 0} true;
  $i255 := $trunc.i8.i1($i254);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 276} true;
  assume {:verifier.code 0} true;
  $i251 := 0;
  assume {:branchcond $i255} true;
  goto $bb197, $bb198;
$bb196:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 258} true;
  assume {:verifier.code 0} true;
  assume !(($i253 == 1));
  goto $bb194;
$bb197:
  assume ($i255 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 280} true;
  assume {:verifier.code 0} true;
  $i256 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 280} true;
  assume {:verifier.code 0} true;
  $i257 := $trunc.i8.i1($i256);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 279} true;
  assume {:verifier.code 0} true;
  $i258 := $xor.i1($i257, 1);
  assume {:verifier.code 0} true;
  $i251 := $i258;
  goto $bb194;
$bb198:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 226, 276} true;
  assume {:verifier.code 0} true;
  assume !(($i255 == 1));
  goto $bb194;
$bb199:
  assume ($i263 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 36} true;
  assume {:verifier.code 0} true;
  $i264 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 36} true;
  assume {:verifier.code 0} true;
  $i265 := $trunc.i8.i1($i264);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 36} true;
  assume {:verifier.code 0} true;
  $i266 := $zext.i1.i32($i265);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 20} true;
  assume {:verifier.code 0} true;
  $i267 := $i266;
  goto $bb201;
$bb200:
  assume !(($i263 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 55} true;
  assume {:verifier.code 0} true;
  $i268 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 55} true;
  assume {:verifier.code 0} true;
  $i269 := $trunc.i8.i1($i268);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 54} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i269} true;
  goto $bb202, $bb203;
$bb201:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 20} true;
  assume {:verifier.code 0} true;
  $i305 := $ne.i32($i267, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 18} true;
  assume {:verifier.code 0} true;
  $i306 := $zext.i1.i8($i305);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 18} true;
  assume {:verifier.code 0} true;
  $M.11 := $i306;
  call {:cexpr "x$r_buff1_thd2"} boogie_si_record_i8($i306);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 228, 36} true;
  assume {:verifier.code 0} true;
  $M.19 := 1;
  call {:cexpr "__unbuffered_p1_EAX$read_delayed"} boogie_si_record_i8(1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 229, 40} true;
  assume {:verifier.code 0} true;
  $M.20 := x;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 230, 25} true;
  assume {:verifier.code 0} true;
  $i307 := $M.12;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 230, 23} true;
  assume {:verifier.code 0} true;
  $M.21 := $i307;
  call {:cexpr "__unbuffered_p1_EAX"} boogie_si_record_i32($i307);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 231, 7} true;
  assume {:verifier.code 0} true;
  $i308 := $M.16;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 231, 7} true;
  assume {:verifier.code 0} true;
  $i309 := $trunc.i8.i1($i308);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 231, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i309} true;
  goto $bb231, $bb232;
$bb202:
  assume ($i269 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 90} true;
  assume {:verifier.code 0} true;
  $i274 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 90} true;
  assume {:verifier.code 0} true;
  $i275 := $trunc.i8.i1($i274);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 105} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i275} true;
  goto $bb205, $bb206;
$bb203:
  assume !(($i269 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 72} true;
  assume {:verifier.code 0} true;
  $i270 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 72} true;
  assume {:verifier.code 0} true;
  $i271 := $trunc.i8.i1($i270);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 72} true;
  assume {:verifier.code 0} true;
  $i272 := $zext.i1.i32($i271);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 54} true;
  assume {:verifier.code 0} true;
  $i273 := $i272;
  goto $bb204;
$bb204:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 54} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 20} true;
  assume {:verifier.code 0} true;
  $i267 := $i273;
  goto $bb201;
$bb205:
  assume ($i275 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 108} true;
  assume {:verifier.code 0} true;
  $i276 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 108} true;
  assume {:verifier.code 0} true;
  $i277 := $trunc.i8.i1($i276);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 90} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i277} true;
  goto $bb208, $bb209;
$bb206:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 105} true;
  assume {:verifier.code 0} true;
  assume !(($i275 == 1));
  goto $bb207;
$bb207:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 134} true;
  assume {:verifier.code 0} true;
  $i279 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 134} true;
  assume {:verifier.code 0} true;
  $i280 := $trunc.i8.i1($i279);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 149} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i280} true;
  goto $bb211, $bb212;
$bb208:
  assume ($i277 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 90} true;
  assume {:verifier.code 0} true;
  $i278 := 0;
  goto $bb210;
$bb209:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 90} true;
  assume {:verifier.code 0} true;
  assume !(($i277 == 1));
  goto $bb207;
$bb210:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 90} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 54} true;
  assume {:verifier.code 0} true;
  $i273 := $i278;
  goto $bb204;
$bb211:
  assume ($i280 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 153} true;
  assume {:verifier.code 0} true;
  $i281 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 153} true;
  assume {:verifier.code 0} true;
  $i282 := $trunc.i8.i1($i281);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 168} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i282} true;
  goto $bb214, $bb215;
$bb212:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 149} true;
  assume {:verifier.code 0} true;
  assume !(($i280 == 1));
  goto $bb213;
$bb213:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 251} true;
  assume {:verifier.code 0} true;
  $i294 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 251} true;
  assume {:verifier.code 0} true;
  $i295 := $trunc.i8.i1($i294);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 266} true;
  assume {:verifier.code 0} true;
  $i296 := 0;
  assume {:branchcond $i295} true;
  goto $bb224, $bb225;
$bb214:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 168} true;
  assume {:verifier.code 0} true;
  assume ($i282 == 1);
  goto $bb213;
$bb215:
  assume !(($i282 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 171} true;
  assume {:verifier.code 0} true;
  $i283 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 171} true;
  assume {:verifier.code 0} true;
  $i284 := $trunc.i8.i1($i283);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 186} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i284} true;
  goto $bb216, $bb217;
$bb216:
  assume ($i284 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 190} true;
  assume {:verifier.code 0} true;
  $i285 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 190} true;
  assume {:verifier.code 0} true;
  $i286 := $trunc.i8.i1($i285);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 134} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i286} true;
  goto $bb218, $bb219;
$bb217:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 186} true;
  assume {:verifier.code 0} true;
  assume !(($i284 == 1));
  goto $bb213;
$bb218:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 134} true;
  assume {:verifier.code 0} true;
  assume ($i286 == 1);
  goto $bb213;
$bb219:
  assume !(($i286 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 208} true;
  assume {:verifier.code 0} true;
  $i287 := $M.14;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 208} true;
  assume {:verifier.code 0} true;
  $i288 := $trunc.i8.i1($i287);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 208} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i288} true;
  goto $bb220, $bb221;
$bb220:
  assume ($i288 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 224} true;
  assume {:verifier.code 0} true;
  $i289 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 224} true;
  assume {:verifier.code 0} true;
  $i290 := $trunc.i8.i1($i289);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 224} true;
  assume {:verifier.code 0} true;
  $i291 := $zext.i1.i32($i290);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 208} true;
  assume {:verifier.code 0} true;
  $i292 := $i291;
  goto $bb222;
$bb221:
  assume !(($i288 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 208} true;
  assume {:verifier.code 0} true;
  $i292 := 0;
  goto $bb222;
$bb222:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 208} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 134} true;
  assume {:verifier.code 0} true;
  $i293 := $i292;
  goto $bb223;
$bb223:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 134} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 90} true;
  assume {:verifier.code 0} true;
  $i278 := $i293;
  goto $bb210;
$bb224:
  assume ($i295 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 269} true;
  assume {:verifier.code 0} true;
  $i297 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 269} true;
  assume {:verifier.code 0} true;
  $i298 := $trunc.i8.i1($i297);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 284} true;
  assume {:verifier.code 0} true;
  $i296 := 0;
  assume {:branchcond $i298} true;
  goto $bb227, $bb228;
$bb225:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 266} true;
  assume {:verifier.code 0} true;
  assume !(($i295 == 1));
  goto $bb226;
$bb226:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 251} true;
  assume {:verifier.code 0} true;
  $i304 := (if ($i296 == 1) then 0 else 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 134} true;
  assume {:verifier.code 0} true;
  $i293 := $i304;
  goto $bb223;
$bb227:
  assume ($i298 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 287} true;
  assume {:verifier.code 0} true;
  $i299 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 287} true;
  assume {:verifier.code 0} true;
  $i300 := $trunc.i8.i1($i299);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 302} true;
  assume {:verifier.code 0} true;
  $i296 := 0;
  assume {:branchcond $i300} true;
  goto $bb229, $bb230;
$bb228:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 284} true;
  assume {:verifier.code 0} true;
  assume !(($i298 == 1));
  goto $bb226;
$bb229:
  assume ($i300 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 306} true;
  assume {:verifier.code 0} true;
  $i301 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 306} true;
  assume {:verifier.code 0} true;
  $i302 := $trunc.i8.i1($i301);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 305} true;
  assume {:verifier.code 0} true;
  $i303 := $xor.i1($i302, 1);
  assume {:verifier.code 0} true;
  $i296 := $i303;
  goto $bb226;
$bb230:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 227, 302} true;
  assume {:verifier.code 0} true;
  assume !(($i300 == 1));
  goto $bb226;
$bb231:
  assume ($i309 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 231, 25} true;
  assume {:verifier.code 0} true;
  $i310 := $M.17;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 231, 7} true;
  assume {:verifier.code 0} true;
  $i311 := $i310;
  goto $bb233;
$bb232:
  assume !(($i309 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 231, 37} true;
  assume {:verifier.code 0} true;
  $i312 := $M.12;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 231, 7} true;
  assume {:verifier.code 0} true;
  $i311 := $i312;
  goto $bb233;
$bb233:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 231, 7} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 231, 5} true;
  assume {:verifier.code 0} true;
  $M.12 := $i311;
  call {:cexpr "x"} boogie_si_record_i32($i311);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 232, 19} true;
  assume {:verifier.code 0} true;
  $M.16 := 0;
  call {:cexpr "x$flush_delayed"} boogie_si_record_i8(0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 233, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_end();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 234, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_begin();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 235, 5} true;
  assume {:verifier.code 0} true;
  $M.0 := 1;
  call {:cexpr "y"} boogie_si_record_i32(1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 236, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_end();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 237, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_begin();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 7} true;
  assume {:verifier.code 0} true;
  $i313 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 7} true;
  assume {:verifier.code 0} true;
  $i314 := $trunc.i8.i1($i313);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 22} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i314} true;
  goto $bb234, $bb235;
$bb234:
  assume ($i314 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 25} true;
  assume {:verifier.code 0} true;
  $i315 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 25} true;
  assume {:verifier.code 0} true;
  $i316 := $trunc.i8.i1($i315);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i316} true;
  goto $bb237, $bb238;
$bb235:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 22} true;
  assume {:verifier.code 0} true;
  assume !(($i314 == 1));
  goto $bb236;
$bb236:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 55} true;
  assume {:verifier.code 0} true;
  $i319 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 55} true;
  assume {:verifier.code 0} true;
  $i320 := $trunc.i8.i1($i319);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 70} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i320} true;
  goto $bb240, $bb241;
$bb237:
  assume ($i316 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 42} true;
  assume {:verifier.code 0} true;
  $i317 := $M.2;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 7} true;
  assume {:verifier.code 0} true;
  $i318 := $i317;
  goto $bb239;
$bb238:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 7} true;
  assume {:verifier.code 0} true;
  assume !(($i316 == 1));
  goto $bb236;
$bb239:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 7} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 5} true;
  assume {:verifier.code 0} true;
  $M.12 := $i318;
  call {:cexpr "x"} boogie_si_record_i32($i318);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 20} true;
  assume {:verifier.code 0} true;
  $i326 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 20} true;
  assume {:verifier.code 0} true;
  $i327 := $trunc.i8.i1($i326);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 35} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i327} true;
  goto $bb246, $bb247;
$bb240:
  assume ($i320 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 73} true;
  assume {:verifier.code 0} true;
  $i321 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 73} true;
  assume {:verifier.code 0} true;
  $i322 := $trunc.i8.i1($i321);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 55} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i322} true;
  goto $bb243, $bb244;
$bb241:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 70} true;
  assume {:verifier.code 0} true;
  assume !(($i320 == 1));
  goto $bb242;
$bb242:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 102} true;
  assume {:verifier.code 0} true;
  $i325 := $M.12;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 55} true;
  assume {:verifier.code 0} true;
  $i324 := $i325;
  goto $bb245;
$bb243:
  assume ($i322 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 90} true;
  assume {:verifier.code 0} true;
  $i323 := $M.3;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 55} true;
  assume {:verifier.code 0} true;
  $i324 := $i323;
  goto $bb245;
$bb244:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 55} true;
  assume {:verifier.code 0} true;
  assume !(($i322 == 1));
  goto $bb242;
$bb245:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 55} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 238, 7} true;
  assume {:verifier.code 0} true;
  $i318 := $i324;
  goto $bb239;
$bb246:
  assume ($i327 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 38} true;
  assume {:verifier.code 0} true;
  $i328 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 38} true;
  assume {:verifier.code 0} true;
  $i329 := $trunc.i8.i1($i328);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i329} true;
  goto $bb249, $bb250;
$bb247:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 35} true;
  assume {:verifier.code 0} true;
  assume !(($i327 == 1));
  goto $bb248;
$bb248:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 63} true;
  assume {:verifier.code 0} true;
  $i331 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 63} true;
  assume {:verifier.code 0} true;
  $i332 := $trunc.i8.i1($i331);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 63} true;
  assume {:verifier.code 0} true;
  $i333 := $zext.i1.i32($i332);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 20} true;
  assume {:verifier.code 0} true;
  $i330 := $i333;
  goto $bb251;
$bb249:
  assume ($i329 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 20} true;
  assume {:verifier.code 0} true;
  $i330 := 0;
  goto $bb251;
$bb250:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 20} true;
  assume {:verifier.code 0} true;
  assume !(($i329 == 1));
  goto $bb248;
$bb251:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 20} true;
  assume {:verifier.code 0} true;
  $i334 := $ne.i32($i330, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 18} true;
  assume {:verifier.code 0} true;
  $i335 := $zext.i1.i8($i334);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 239, 18} true;
  assume {:verifier.code 0} true;
  $M.4 := $i335;
  call {:cexpr "x$w_buff0_used"} boogie_si_record_i8($i335);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 20} true;
  assume {:verifier.code 0} true;
  $i336 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 20} true;
  assume {:verifier.code 0} true;
  $i337 := $trunc.i8.i1($i336);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 35} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i337} true;
  goto $bb252, $bb253;
$bb252:
  assume ($i337 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 38} true;
  assume {:verifier.code 0} true;
  $i338 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 38} true;
  assume {:verifier.code 0} true;
  $i339 := $trunc.i8.i1($i338);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 53} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i339} true;
  goto $bb255, $bb257;
$bb253:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 35} true;
  assume {:verifier.code 0} true;
  assume !(($i337 == 1));
  goto $bb254;
$bb254:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 56} true;
  assume {:verifier.code 0} true;
  $i340 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 56} true;
  assume {:verifier.code 0} true;
  $i341 := $trunc.i8.i1($i340);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 71} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i341} true;
  goto $bb258, $bb259;
$bb255:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 53} true;
  assume {:verifier.code 0} true;
  assume ($i339 == 1);
  goto $bb256;
$bb256:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 20} true;
  assume {:verifier.code 0} true;
  $i344 := 0;
  goto $bb263;
$bb257:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 53} true;
  assume {:verifier.code 0} true;
  assume !(($i339 == 1));
  goto $bb254;
$bb258:
  assume ($i341 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 74} true;
  assume {:verifier.code 0} true;
  $i342 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 74} true;
  assume {:verifier.code 0} true;
  $i343 := $trunc.i8.i1($i342);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i343} true;
  goto $bb261, $bb262;
$bb259:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 71} true;
  assume {:verifier.code 0} true;
  assume !(($i341 == 1));
  goto $bb260;
$bb260:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 99} true;
  assume {:verifier.code 0} true;
  $i345 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 99} true;
  assume {:verifier.code 0} true;
  $i346 := $trunc.i8.i1($i345);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 99} true;
  assume {:verifier.code 0} true;
  $i347 := $zext.i1.i32($i346);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 20} true;
  assume {:verifier.code 0} true;
  $i344 := $i347;
  goto $bb263;
$bb261:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 20} true;
  assume {:verifier.code 0} true;
  assume ($i343 == 1);
  goto $bb256;
$bb262:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 20} true;
  assume {:verifier.code 0} true;
  assume !(($i343 == 1));
  goto $bb260;
$bb263:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 20} true;
  assume {:verifier.code 0} true;
  $i348 := $ne.i32($i344, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 18} true;
  assume {:verifier.code 0} true;
  $i349 := $zext.i1.i8($i348);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 240, 18} true;
  assume {:verifier.code 0} true;
  $M.5 := $i349;
  call {:cexpr "x$w_buff1_used"} boogie_si_record_i8($i349);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 20} true;
  assume {:verifier.code 0} true;
  $i350 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 20} true;
  assume {:verifier.code 0} true;
  $i351 := $trunc.i8.i1($i350);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 35} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i351} true;
  goto $bb264, $bb265;
$bb264:
  assume ($i351 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 38} true;
  assume {:verifier.code 0} true;
  $i352 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 38} true;
  assume {:verifier.code 0} true;
  $i353 := $trunc.i8.i1($i352);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i353} true;
  goto $bb267, $bb268;
$bb265:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 35} true;
  assume {:verifier.code 0} true;
  assume !(($i351 == 1));
  goto $bb266;
$bb266:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 63} true;
  assume {:verifier.code 0} true;
  $i355 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 63} true;
  assume {:verifier.code 0} true;
  $i356 := $trunc.i8.i1($i355);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 63} true;
  assume {:verifier.code 0} true;
  $i357 := $zext.i1.i32($i356);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 20} true;
  assume {:verifier.code 0} true;
  $i354 := $i357;
  goto $bb269;
$bb267:
  assume ($i353 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 20} true;
  assume {:verifier.code 0} true;
  $i354 := 0;
  goto $bb269;
$bb268:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 20} true;
  assume {:verifier.code 0} true;
  assume !(($i353 == 1));
  goto $bb266;
$bb269:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 20} true;
  assume {:verifier.code 0} true;
  $i358 := $ne.i32($i354, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 18} true;
  assume {:verifier.code 0} true;
  $i359 := $zext.i1.i8($i358);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 241, 18} true;
  assume {:verifier.code 0} true;
  $M.10 := $i359;
  call {:cexpr "x$r_buff0_thd2"} boogie_si_record_i8($i359);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 20} true;
  assume {:verifier.code 0} true;
  $i360 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 20} true;
  assume {:verifier.code 0} true;
  $i361 := $trunc.i8.i1($i360);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 35} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i361} true;
  goto $bb270, $bb271;
$bb270:
  assume ($i361 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 38} true;
  assume {:verifier.code 0} true;
  $i362 := $M.10;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 38} true;
  assume {:verifier.code 0} true;
  $i363 := $trunc.i8.i1($i362);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 53} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i363} true;
  goto $bb273, $bb275;
$bb271:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 35} true;
  assume {:verifier.code 0} true;
  assume !(($i361 == 1));
  goto $bb272;
$bb272:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 56} true;
  assume {:verifier.code 0} true;
  $i364 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 56} true;
  assume {:verifier.code 0} true;
  $i365 := $trunc.i8.i1($i364);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 71} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i365} true;
  goto $bb276, $bb277;
$bb273:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 53} true;
  assume {:verifier.code 0} true;
  assume ($i363 == 1);
  goto $bb274;
$bb274:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 20} true;
  assume {:verifier.code 0} true;
  $i368 := 0;
  goto $bb281;
$bb275:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 53} true;
  assume {:verifier.code 0} true;
  assume !(($i363 == 1));
  goto $bb272;
$bb276:
  assume ($i365 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 74} true;
  assume {:verifier.code 0} true;
  $i366 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 74} true;
  assume {:verifier.code 0} true;
  $i367 := $trunc.i8.i1($i366);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i367} true;
  goto $bb279, $bb280;
$bb277:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 71} true;
  assume {:verifier.code 0} true;
  assume !(($i365 == 1));
  goto $bb278;
$bb278:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 99} true;
  assume {:verifier.code 0} true;
  $i369 := $M.11;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 99} true;
  assume {:verifier.code 0} true;
  $i370 := $trunc.i8.i1($i369);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 99} true;
  assume {:verifier.code 0} true;
  $i371 := $zext.i1.i32($i370);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 20} true;
  assume {:verifier.code 0} true;
  $i368 := $i371;
  goto $bb281;
$bb279:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 20} true;
  assume {:verifier.code 0} true;
  assume ($i367 == 1);
  goto $bb274;
$bb280:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 20} true;
  assume {:verifier.code 0} true;
  assume !(($i367 == 1));
  goto $bb278;
$bb281:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 20} true;
  assume {:verifier.code 0} true;
  $i372 := $ne.i32($i368, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 18} true;
  assume {:verifier.code 0} true;
  $i373 := $zext.i1.i8($i372);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 242, 18} true;
  assume {:verifier.code 0} true;
  $M.11 := $i373;
  call {:cexpr "x$r_buff1_thd2"} boogie_si_record_i8($i373);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 243, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_end();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 244, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_begin();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 245, 22} true;
  assume {:verifier.code 0} true;
  $i374 := $M.13;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 245, 39} true;
  assume {:verifier.code 0} true;
  $i375 := $add.i32($i374, 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 245, 20} true;
  assume {:verifier.code 0} true;
  $M.13 := $i375;
  call {:cexpr "__unbuffered_cnt"} boogie_si_record_i32($i375);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 246, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_end();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 247, 3} true;
  assume {:verifier.code 0} true;
  $r := $0.ref;
  $exn := false;
  return;
}
const main: ref;
axiom (main == $sub.ref(0, 54480));
procedure main()
  returns ($r: i32)
{
  var $p0: ref;
  var $p1: ref;
  var $i2: i32;
  var $i3: i32;
  var $i4: i32;
  var $i5: i1;
  var $i6: i8;
  var $i7: i8;
  var $i8: i1;
  var $i9: i32;
  var $i10: i8;
  var $i11: i1;
  var $i12: i8;
  var $i13: i1;
  var $i14: i32;
  var $i16: i8;
  var $i17: i1;
  var $i18: i8;
  var $i19: i1;
  var $i20: i32;
  var $i22: i32;
  var $i21: i32;
  var $i15: i32;
  var $i23: i8;
  var $i24: i1;
  var $i25: i8;
  var $i26: i1;
  var $i28: i8;
  var $i29: i1;
  var $i30: i32;
  var $i27: i32;
  var $i31: i1;
  var $i32: i8;
  var $i33: i8;
  var $i34: i1;
  var $i35: i8;
  var $i36: i1;
  var $i37: i8;
  var $i38: i1;
  var $i39: i8;
  var $i40: i1;
  var $i42: i8;
  var $i43: i1;
  var $i44: i32;
  var $i41: i32;
  var $i45: i1;
  var $i46: i8;
  var $i47: i8;
  var $i48: i1;
  var $i49: i8;
  var $i50: i1;
  var $i52: i8;
  var $i53: i1;
  var $i54: i32;
  var $i51: i32;
  var $i55: i1;
  var $i56: i8;
  var $i57: i8;
  var $i58: i1;
  var $i59: i8;
  var $i60: i1;
  var $i61: i8;
  var $i62: i1;
  var $i63: i8;
  var $i64: i1;
  var $i66: i8;
  var $i67: i1;
  var $i68: i32;
  var $i65: i32;
  var $i69: i1;
  var $i70: i8;
  var $i71: i1;
  var $i72: i8;
  var $i73: i8;
  var $i74: i1;
  var $i75: i8;
  var $i76: i1;
  var $p77: ref;
  var $i78: i32;
  var $i80: i32;
  var $i79: i32;
  var $i82: i32;
  var $i81: i32;
  var $i83: i32;
  var $i84: i1;
  var $i86: i32;
  var $i87: i1;
  var $i85: i1;
  var $i88: i1;
  var $i89: i8;
  var $i90: i8;
  var $i91: i1;
  var $i92: i32;
$bb0:
  call $initialize();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 276, 3} true;
  assume {:verifier.code 0} true;
  call {:cexpr "smack:entry:main"} boogie_si_record_ref(main);
  assume {:verifier.code 0} true;
  call $p0 := $alloc($mul.ref(8, $zext.i32.i64(1)));
  assume {:verifier.code 0} true;
  call $p1 := $alloc($mul.ref(8, $zext.i32.i64(1)));
  assume true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 276, 3} true;
  assume {:verifier.code 0} true;
  call $i2 := pthread_create($p0, $0.ref, P0, $0.ref);
  assume true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 278, 3} true;
  assume {:verifier.code 0} true;
  call $i3 := pthread_create($p1, $0.ref, P1, $0.ref);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 279, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_begin();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 280, 21} true;
  assume {:verifier.code 0} true;
  $i4 := $M.13;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 280, 38} true;
  assume {:verifier.code 0} true;
  $i5 := $eq.i32($i4, 2);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 280, 19} true;
  assume {:verifier.code 0} true;
  $i6 := $zext.i1.i8($i5);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 280, 19} true;
  assume {:verifier.code 0} true;
  $M.22 := $i6;
  call {:cexpr "main$tmp_guard0"} boogie_si_record_i8($i6);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 281, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_end();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 282, 23} true;
  assume {:verifier.code 0} true;
  $i7 := $M.22;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 282, 23} true;
  assume {:verifier.code 0} true;
  $i8 := $trunc.i8.i1($i7);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 282, 23} true;
  assume {:verifier.code 0} true;
  $i9 := $zext.i1.i32($i8);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 282, 3} true;
  assume {:verifier.code 0} true;
  call assume_abort_if_not($i9);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 283, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_begin();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 7} true;
  assume {:verifier.code 0} true;
  $i10 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 7} true;
  assume {:verifier.code 0} true;
  $i11 := $trunc.i8.i1($i10);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 22} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i11} true;
  goto $bb1, $bb2;
$bb1:
  assume ($i11 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 25} true;
  assume {:verifier.code 0} true;
  $i12 := $M.6;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 25} true;
  assume {:verifier.code 0} true;
  $i13 := $trunc.i8.i1($i12);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i13} true;
  goto $bb4, $bb5;
$bb2:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 22} true;
  assume {:verifier.code 0} true;
  assume !(($i11 == 1));
  goto $bb3;
$bb3:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 55} true;
  assume {:verifier.code 0} true;
  $i16 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 55} true;
  assume {:verifier.code 0} true;
  $i17 := $trunc.i8.i1($i16);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 70} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i17} true;
  goto $bb7, $bb8;
$bb4:
  assume ($i13 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 42} true;
  assume {:verifier.code 0} true;
  $i14 := $M.2;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 7} true;
  assume {:verifier.code 0} true;
  $i15 := $i14;
  goto $bb6;
$bb5:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 7} true;
  assume {:verifier.code 0} true;
  assume !(($i13 == 1));
  goto $bb3;
$bb6:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 7} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 5} true;
  assume {:verifier.code 0} true;
  $M.12 := $i15;
  call {:cexpr "x"} boogie_si_record_i32($i15);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 20} true;
  assume {:verifier.code 0} true;
  $i23 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 20} true;
  assume {:verifier.code 0} true;
  $i24 := $trunc.i8.i1($i23);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 35} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i24} true;
  goto $bb13, $bb14;
$bb7:
  assume ($i17 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 73} true;
  assume {:verifier.code 0} true;
  $i18 := $M.7;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 73} true;
  assume {:verifier.code 0} true;
  $i19 := $trunc.i8.i1($i18);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 55} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i19} true;
  goto $bb10, $bb11;
$bb8:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 70} true;
  assume {:verifier.code 0} true;
  assume !(($i17 == 1));
  goto $bb9;
$bb9:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 102} true;
  assume {:verifier.code 0} true;
  $i22 := $M.12;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 55} true;
  assume {:verifier.code 0} true;
  $i21 := $i22;
  goto $bb12;
$bb10:
  assume ($i19 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 90} true;
  assume {:verifier.code 0} true;
  $i20 := $M.3;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 55} true;
  assume {:verifier.code 0} true;
  $i21 := $i20;
  goto $bb12;
$bb11:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 55} true;
  assume {:verifier.code 0} true;
  assume !(($i19 == 1));
  goto $bb9;
$bb12:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 55} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 284, 7} true;
  assume {:verifier.code 0} true;
  $i15 := $i21;
  goto $bb6;
$bb13:
  assume ($i24 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 38} true;
  assume {:verifier.code 0} true;
  $i25 := $M.6;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 38} true;
  assume {:verifier.code 0} true;
  $i26 := $trunc.i8.i1($i25);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i26} true;
  goto $bb16, $bb17;
$bb14:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 35} true;
  assume {:verifier.code 0} true;
  assume !(($i24 == 1));
  goto $bb15;
$bb15:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 63} true;
  assume {:verifier.code 0} true;
  $i28 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 63} true;
  assume {:verifier.code 0} true;
  $i29 := $trunc.i8.i1($i28);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 63} true;
  assume {:verifier.code 0} true;
  $i30 := $zext.i1.i32($i29);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 20} true;
  assume {:verifier.code 0} true;
  $i27 := $i30;
  goto $bb18;
$bb16:
  assume ($i26 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 20} true;
  assume {:verifier.code 0} true;
  $i27 := 0;
  goto $bb18;
$bb17:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 20} true;
  assume {:verifier.code 0} true;
  assume !(($i26 == 1));
  goto $bb15;
$bb18:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 20} true;
  assume {:verifier.code 0} true;
  $i31 := $ne.i32($i27, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 18} true;
  assume {:verifier.code 0} true;
  $i32 := $zext.i1.i8($i31);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 285, 18} true;
  assume {:verifier.code 0} true;
  $M.4 := $i32;
  call {:cexpr "x$w_buff0_used"} boogie_si_record_i8($i32);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 20} true;
  assume {:verifier.code 0} true;
  $i33 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 20} true;
  assume {:verifier.code 0} true;
  $i34 := $trunc.i8.i1($i33);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 35} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i34} true;
  goto $bb19, $bb20;
$bb19:
  assume ($i34 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 38} true;
  assume {:verifier.code 0} true;
  $i35 := $M.6;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 38} true;
  assume {:verifier.code 0} true;
  $i36 := $trunc.i8.i1($i35);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 53} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i36} true;
  goto $bb22, $bb24;
$bb20:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 35} true;
  assume {:verifier.code 0} true;
  assume !(($i34 == 1));
  goto $bb21;
$bb21:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 56} true;
  assume {:verifier.code 0} true;
  $i37 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 56} true;
  assume {:verifier.code 0} true;
  $i38 := $trunc.i8.i1($i37);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 71} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i38} true;
  goto $bb25, $bb26;
$bb22:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 53} true;
  assume {:verifier.code 0} true;
  assume ($i36 == 1);
  goto $bb23;
$bb23:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 20} true;
  assume {:verifier.code 0} true;
  $i41 := 0;
  goto $bb30;
$bb24:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 53} true;
  assume {:verifier.code 0} true;
  assume !(($i36 == 1));
  goto $bb21;
$bb25:
  assume ($i38 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 74} true;
  assume {:verifier.code 0} true;
  $i39 := $M.7;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 74} true;
  assume {:verifier.code 0} true;
  $i40 := $trunc.i8.i1($i39);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i40} true;
  goto $bb28, $bb29;
$bb26:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 71} true;
  assume {:verifier.code 0} true;
  assume !(($i38 == 1));
  goto $bb27;
$bb27:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 99} true;
  assume {:verifier.code 0} true;
  $i42 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 99} true;
  assume {:verifier.code 0} true;
  $i43 := $trunc.i8.i1($i42);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 99} true;
  assume {:verifier.code 0} true;
  $i44 := $zext.i1.i32($i43);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 20} true;
  assume {:verifier.code 0} true;
  $i41 := $i44;
  goto $bb30;
$bb28:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 20} true;
  assume {:verifier.code 0} true;
  assume ($i40 == 1);
  goto $bb23;
$bb29:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 20} true;
  assume {:verifier.code 0} true;
  assume !(($i40 == 1));
  goto $bb27;
$bb30:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 20} true;
  assume {:verifier.code 0} true;
  $i45 := $ne.i32($i41, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 18} true;
  assume {:verifier.code 0} true;
  $i46 := $zext.i1.i8($i45);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 286, 18} true;
  assume {:verifier.code 0} true;
  $M.5 := $i46;
  call {:cexpr "x$w_buff1_used"} boogie_si_record_i8($i46);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 20} true;
  assume {:verifier.code 0} true;
  $i47 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 20} true;
  assume {:verifier.code 0} true;
  $i48 := $trunc.i8.i1($i47);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 35} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i48} true;
  goto $bb31, $bb32;
$bb31:
  assume ($i48 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 38} true;
  assume {:verifier.code 0} true;
  $i49 := $M.6;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 38} true;
  assume {:verifier.code 0} true;
  $i50 := $trunc.i8.i1($i49);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i50} true;
  goto $bb34, $bb35;
$bb32:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 35} true;
  assume {:verifier.code 0} true;
  assume !(($i48 == 1));
  goto $bb33;
$bb33:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 63} true;
  assume {:verifier.code 0} true;
  $i52 := $M.6;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 63} true;
  assume {:verifier.code 0} true;
  $i53 := $trunc.i8.i1($i52);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 63} true;
  assume {:verifier.code 0} true;
  $i54 := $zext.i1.i32($i53);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 20} true;
  assume {:verifier.code 0} true;
  $i51 := $i54;
  goto $bb36;
$bb34:
  assume ($i50 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 20} true;
  assume {:verifier.code 0} true;
  $i51 := 0;
  goto $bb36;
$bb35:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 20} true;
  assume {:verifier.code 0} true;
  assume !(($i50 == 1));
  goto $bb33;
$bb36:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 20} true;
  assume {:verifier.code 0} true;
  $i55 := $ne.i32($i51, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 18} true;
  assume {:verifier.code 0} true;
  $i56 := $zext.i1.i8($i55);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 287, 18} true;
  assume {:verifier.code 0} true;
  $M.6 := $i56;
  call {:cexpr "x$r_buff0_thd0"} boogie_si_record_i8($i56);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 20} true;
  assume {:verifier.code 0} true;
  $i57 := $M.4;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 20} true;
  assume {:verifier.code 0} true;
  $i58 := $trunc.i8.i1($i57);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 35} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i58} true;
  goto $bb37, $bb38;
$bb37:
  assume ($i58 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 38} true;
  assume {:verifier.code 0} true;
  $i59 := $M.6;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 38} true;
  assume {:verifier.code 0} true;
  $i60 := $trunc.i8.i1($i59);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 53} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i60} true;
  goto $bb40, $bb42;
$bb38:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 35} true;
  assume {:verifier.code 0} true;
  assume !(($i58 == 1));
  goto $bb39;
$bb39:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 56} true;
  assume {:verifier.code 0} true;
  $i61 := $M.5;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 56} true;
  assume {:verifier.code 0} true;
  $i62 := $trunc.i8.i1($i61);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 71} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i62} true;
  goto $bb43, $bb44;
$bb40:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 53} true;
  assume {:verifier.code 0} true;
  assume ($i60 == 1);
  goto $bb41;
$bb41:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 20} true;
  assume {:verifier.code 0} true;
  $i65 := 0;
  goto $bb48;
$bb42:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 53} true;
  assume {:verifier.code 0} true;
  assume !(($i60 == 1));
  goto $bb39;
$bb43:
  assume ($i62 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 74} true;
  assume {:verifier.code 0} true;
  $i63 := $M.7;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 74} true;
  assume {:verifier.code 0} true;
  $i64 := $trunc.i8.i1($i63);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 20} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i64} true;
  goto $bb46, $bb47;
$bb44:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 71} true;
  assume {:verifier.code 0} true;
  assume !(($i62 == 1));
  goto $bb45;
$bb45:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 99} true;
  assume {:verifier.code 0} true;
  $i66 := $M.7;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 99} true;
  assume {:verifier.code 0} true;
  $i67 := $trunc.i8.i1($i66);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 99} true;
  assume {:verifier.code 0} true;
  $i68 := $zext.i1.i32($i67);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 20} true;
  assume {:verifier.code 0} true;
  $i65 := $i68;
  goto $bb48;
$bb46:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 20} true;
  assume {:verifier.code 0} true;
  assume ($i64 == 1);
  goto $bb41;
$bb47:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 20} true;
  assume {:verifier.code 0} true;
  assume !(($i64 == 1));
  goto $bb45;
$bb48:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 20} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 20} true;
  assume {:verifier.code 0} true;
  $i69 := $ne.i32($i65, 0);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 18} true;
  assume {:verifier.code 0} true;
  $i70 := $zext.i1.i8($i69);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 288, 18} true;
  assume {:verifier.code 0} true;
  $M.7 := $i70;
  call {:cexpr "x$r_buff1_thd0"} boogie_si_record_i8($i70);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 289, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_end();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 290, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_begin();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 293, 19} true;
  assume {:verifier.code 1} true;
  call $i71 := __VERIFIER_nondet_bool();
  call {:cexpr "smack:ext:__VERIFIER_nondet_bool"} boogie_si_record_i1($i71);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 293, 17} true;
  assume {:verifier.code 0} true;
  $i72 := $zext.i1.i8($i71);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 293, 17} true;
  assume {:verifier.code 0} true;
  $M.18 := $i72;
  call {:cexpr "weak$$choice1"} boogie_si_record_i8($i72);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 25} true;
  assume {:verifier.code 0} true;
  $i73 := $M.19;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 25} true;
  assume {:verifier.code 0} true;
  $i74 := $trunc.i8.i1($i73);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 25} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i74} true;
  goto $bb49, $bb50;
$bb49:
  assume ($i74 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 61} true;
  assume {:verifier.code 0} true;
  $i75 := $M.18;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 61} true;
  assume {:verifier.code 0} true;
  $i76 := $trunc.i8.i1($i75);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 61} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i76} true;
  goto $bb51, $bb52;
$bb50:
  assume !(($i74 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 140} true;
  assume {:verifier.code 0} true;
  $i82 := $M.21;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 25} true;
  assume {:verifier.code 0} true;
  $i81 := $i82;
  goto $bb54;
$bb51:
  assume ($i76 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 78} true;
  assume {:verifier.code 0} true;
  $p77 := $M.20;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 77} true;
  assume {:verifier.code 0} true;
  $i78 := $M.12;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 61} true;
  assume {:verifier.code 0} true;
  $i79 := $i78;
  goto $bb53;
$bb52:
  assume !(($i76 == 1));
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 117} true;
  assume {:verifier.code 0} true;
  $i80 := $M.21;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 61} true;
  assume {:verifier.code 0} true;
  $i79 := $i80;
  goto $bb53;
$bb53:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 61} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 25} true;
  assume {:verifier.code 0} true;
  $i81 := $i79;
  goto $bb54;
$bb54:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 25} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 296, 23} true;
  assume {:verifier.code 0} true;
  $M.21 := $i81;
  call {:cexpr "__unbuffered_p1_EAX"} boogie_si_record_i32($i81);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 299, 23} true;
  assume {:verifier.code 0} true;
  $i83 := $M.1;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 299, 43} true;
  assume {:verifier.code 0} true;
  $i84 := $eq.i32($i83, 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 299, 48} true;
  assume {:verifier.code 0} true;
  $i85 := 0;
  assume {:branchcond $i84} true;
  goto $bb55, $bb56;
$bb55:
  assume ($i84 == 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 299, 51} true;
  assume {:verifier.code 0} true;
  $i86 := $M.21;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 299, 71} true;
  assume {:verifier.code 0} true;
  $i87 := $eq.i32($i86, 1);
  assume {:verifier.code 0} true;
  $i85 := $i87;
  goto $bb57;
$bb56:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 299, 48} true;
  assume {:verifier.code 0} true;
  assume !(($i84 == 1));
  goto $bb57;
$bb57:
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 299, 21} true;
  assume {:verifier.code 0} true;
  $i88 := $xor.i1($i85, 1);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 299, 19} true;
  assume {:verifier.code 0} true;
  $i89 := $zext.i1.i8($i88);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 299, 19} true;
  assume {:verifier.code 0} true;
  $M.23 := $i89;
  call {:cexpr "main$tmp_guard1"} boogie_si_record_i8($i89);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 300, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_atomic_end();
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 303, 21} true;
  assume {:verifier.code 1} true;
  $i90 := $M.23;
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 303, 21} true;
  assume {:verifier.code 1} true;
  $i91 := $trunc.i8.i1($i90);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 303, 21} true;
  assume {:verifier.code 1} true;
  $i92 := $zext.i1.i32($i91);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 303, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assert($i92);
  assume {:sourceloc "./output/thin000_power.opt_tmp.c", 304, 3} true;
  assume {:verifier.code 0} true;
  $r := 0;
  $exn := false;
  return;
}
const pthread_create: ref;
axiom (pthread_create == $sub.ref(0, 55512));
procedure pthread_create($p0: ref, $p1: ref, $p2: ref, $p3: ref)
  returns ($r: i32);
const __VERIFIER_assume: ref;
axiom (__VERIFIER_assume == $sub.ref(0, 56544));
procedure __VERIFIER_assume($i0: i32)
{
$bb0:
  assume {:sourceloc "./lib/smack.c", 258, 29} true;
  assume {:verifier.code 1} true;
  call {:cexpr "__VERIFIER_assume:arg:x"} boogie_si_record_i32($i0);
  assume {:sourceloc "./lib/smack.c", 258, 29} true;
  assume {:verifier.code 1} true;
  assume true;
  assume {:sourceloc "./lib/smack.c", 38, 3} true;
  assume {:verifier.code 1} true;
  assume $i0 != $0;
  assume {:sourceloc "./lib/smack.c", 39, 1} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const __SMACK_code: ref;
axiom (__SMACK_code == $sub.ref(0, 57576));
procedure __SMACK_code.ref.i32($p0: ref, p.1: i32);
procedure __SMACK_code.ref($p0: ref);
const __SMACK_dummy: ref;
axiom (__SMACK_dummy == $sub.ref(0, 58608));
procedure __SMACK_dummy($i0: i32)
{
$bb0:
  assume {:sourceloc "./lib/smack.c", 258, 29} true;
  assume {:verifier.code 1} true;
  call {:cexpr "__SMACK_dummy:arg:v"} boogie_si_record_i32($i0);
  assume {:sourceloc "./lib/smack.c", 258, 29} true;
  assume {:verifier.code 1} true;
  assume true;
  assume {:sourceloc "./lib/smack.c", 258, 59} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const __SMACK_check_overflow: ref;
axiom (__SMACK_check_overflow == $sub.ref(0, 59640));
procedure __SMACK_check_overflow($i0: i32)
{
$bb0:
  assume {:sourceloc "./lib/smack.c", 258, 29} true;
  assume {:verifier.code 1} true;
  call {:cexpr "__SMACK_check_overflow:arg:flag"} boogie_si_record_i32($i0);
  assume {:sourceloc "./lib/smack.c", 258, 29} true;
  assume {:verifier.code 1} true;
  assume true;
  assume {:sourceloc "./lib/smack.c", 63, 3} true;
  assume {:verifier.code 1} true;
  assert {:overflow} $i0 == $0;
  assume {:sourceloc "./lib/smack.c", 64, 1} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const __SMACK_nondet_char: ref;
axiom (__SMACK_nondet_char == $sub.ref(0, 60672));
procedure __SMACK_nondet_char()
  returns ($r: i8);
const __SMACK_nondet_signed_char: ref;
axiom (__SMACK_nondet_signed_char == $sub.ref(0, 61704));
procedure __SMACK_nondet_signed_char()
  returns ($r: i8);
const __SMACK_nondet_unsigned_char: ref;
axiom (__SMACK_nondet_unsigned_char == $sub.ref(0, 62736));
procedure __SMACK_nondet_unsigned_char()
  returns ($r: i8);
const __SMACK_nondet_short: ref;
axiom (__SMACK_nondet_short == $sub.ref(0, 63768));
procedure __SMACK_nondet_short()
  returns ($r: i16);
const __SMACK_nondet_signed_short: ref;
axiom (__SMACK_nondet_signed_short == $sub.ref(0, 64800));
procedure __SMACK_nondet_signed_short()
  returns ($r: i16);
const __SMACK_nondet_signed_short_int: ref;
axiom (__SMACK_nondet_signed_short_int == $sub.ref(0, 65832));
procedure __SMACK_nondet_signed_short_int()
  returns ($r: i16);
const __SMACK_nondet_unsigned_short: ref;
axiom (__SMACK_nondet_unsigned_short == $sub.ref(0, 66864));
procedure __SMACK_nondet_unsigned_short()
  returns ($r: i16);
const __SMACK_nondet_unsigned_short_int: ref;
axiom (__SMACK_nondet_unsigned_short_int == $sub.ref(0, 67896));
procedure __SMACK_nondet_unsigned_short_int()
  returns ($r: i16);
const __VERIFIER_nondet_int: ref;
axiom (__VERIFIER_nondet_int == $sub.ref(0, 68928));
procedure __VERIFIER_nondet_int()
  returns ($r: i32)
{
  var $i0: i32;
  var $i1: i1;
  var $i3: i1;
  var $i2: i1;
  var $i4: i32;
$bb0:
  assume {:sourceloc "./lib/smack.c", 115, 11} true;
  assume {:verifier.code 1} true;
  assume {:sourceloc "./lib/smack.c", 115, 11} true;
  assume {:verifier.code 1} true;
  call $i0 := __SMACK_nondet_int();
  call {:cexpr "smack:ext:__SMACK_nondet_int"} boogie_si_record_i32($i0);
  call {:cexpr "x"} boogie_si_record_i32($i0);
  assume {:sourceloc "./lib/smack.c", 116, 23} true;
  assume {:verifier.code 0} true;
  $i1 := $sge.i32($i0, $sub.i32(0, 2147483648));
  assume {:sourceloc "./lib/smack.c", 116, 34} true;
  assume {:verifier.code 0} true;
  $i2 := 0;
  assume {:branchcond $i1} true;
  goto $bb1, $bb2;
$bb1:
  assume ($i1 == 1);
  assume {:sourceloc "./lib/smack.c", 116, 39} true;
  assume {:verifier.code 1} true;
  $i3 := $sle.i32($i0, 2147483647);
  assume {:verifier.code 0} true;
  $i2 := $i3;
  goto $bb3;
$bb2:
  assume {:sourceloc "./lib/smack.c", 116, 34} true;
  assume {:verifier.code 0} true;
  assume !(($i1 == 1));
  goto $bb3;
$bb3:
  assume {:sourceloc "./lib/smack.c", 0, 0} true;
  assume {:verifier.code 1} true;
  assume {:sourceloc "./lib/smack.c", 116, 34} true;
  assume {:verifier.code 1} true;
  $i4 := $zext.i1.i32($i2);
  assume {:sourceloc "./lib/smack.c", 116, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assume($i4);
  assume {:sourceloc "./lib/smack.c", 117, 3} true;
  assume {:verifier.code 0} true;
  $r := $i0;
  $exn := false;
  return;
}
const __SMACK_nondet_int: ref;
axiom (__SMACK_nondet_int == $sub.ref(0, 69960));
procedure __SMACK_nondet_int()
  returns ($r: i32);
const __SMACK_nondet_signed_int: ref;
axiom (__SMACK_nondet_signed_int == $sub.ref(0, 70992));
procedure __SMACK_nondet_signed_int()
  returns ($r: i32);
const __SMACK_nondet_unsigned: ref;
axiom (__SMACK_nondet_unsigned == $sub.ref(0, 72024));
procedure __SMACK_nondet_unsigned()
  returns ($r: i32);
const __SMACK_nondet_unsigned_int: ref;
axiom (__SMACK_nondet_unsigned_int == $sub.ref(0, 73056));
procedure __SMACK_nondet_unsigned_int()
  returns ($r: i32);
const __SMACK_nondet_long: ref;
axiom (__SMACK_nondet_long == $sub.ref(0, 74088));
procedure __SMACK_nondet_long()
  returns ($r: i64);
const __SMACK_nondet_long_int: ref;
axiom (__SMACK_nondet_long_int == $sub.ref(0, 75120));
procedure __SMACK_nondet_long_int()
  returns ($r: i64);
const __SMACK_nondet_signed_long: ref;
axiom (__SMACK_nondet_signed_long == $sub.ref(0, 76152));
procedure __SMACK_nondet_signed_long()
  returns ($r: i64);
const __SMACK_nondet_signed_long_int: ref;
axiom (__SMACK_nondet_signed_long_int == $sub.ref(0, 77184));
procedure __SMACK_nondet_signed_long_int()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long: ref;
axiom (__SMACK_nondet_unsigned_long == $sub.ref(0, 78216));
procedure __SMACK_nondet_unsigned_long()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_int: ref;
axiom (__SMACK_nondet_unsigned_long_int == $sub.ref(0, 79248));
procedure __SMACK_nondet_unsigned_long_int()
  returns ($r: i64);
const __SMACK_nondet_long_long: ref;
axiom (__SMACK_nondet_long_long == $sub.ref(0, 80280));
procedure __SMACK_nondet_long_long()
  returns ($r: i64);
const __SMACK_nondet_long_long_int: ref;
axiom (__SMACK_nondet_long_long_int == $sub.ref(0, 81312));
procedure __SMACK_nondet_long_long_int()
  returns ($r: i64);
const __SMACK_nondet_signed_long_long: ref;
axiom (__SMACK_nondet_signed_long_long == $sub.ref(0, 82344));
procedure __SMACK_nondet_signed_long_long()
  returns ($r: i64);
const __SMACK_nondet_signed_long_long_int: ref;
axiom (__SMACK_nondet_signed_long_long_int == $sub.ref(0, 83376));
procedure __SMACK_nondet_signed_long_long_int()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_long: ref;
axiom (__SMACK_nondet_unsigned_long_long == $sub.ref(0, 84408));
procedure __SMACK_nondet_unsigned_long_long()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_long_int: ref;
axiom (__SMACK_nondet_unsigned_long_long_int == $sub.ref(0, 85440));
procedure __SMACK_nondet_unsigned_long_long_int()
  returns ($r: i64);
const __VERIFIER_nondet_bool: ref;
axiom (__VERIFIER_nondet_bool == $sub.ref(0, 86472));
procedure __VERIFIER_nondet_bool()
  returns ($r: i1)
{
  var $i0: i32;
  var $i1: i1;
  var $i2: i8;
  var $i3: i1;
  var $i4: i32;
  var $i5: i1;
  var $i7: i1;
  var $i8: i32;
  var $i9: i1;
  var $i6: i1;
  var $i10: i32;
  var $i11: i1;
$bb0:
  assume {:sourceloc "./lib/smack.c", 231, 20} true;
  assume {:verifier.code 1} true;
  assume {:sourceloc "./lib/smack.c", 231, 20} true;
  assume {:verifier.code 1} true;
  call $i0 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i0);
  assume {:sourceloc "./lib/smack.c", 231, 13} true;
  assume {:verifier.code 0} true;
  $i1 := $ne.i32($i0, 0);
  assume {:sourceloc "./lib/smack.c", 231, 9} true;
  assume {:verifier.code 0} true;
  $i2 := $zext.i1.i8($i1);
  call {:cexpr "x"} boogie_si_record_i8($i2);
  assume {:sourceloc "./lib/smack.c", 232, 21} true;
  assume {:verifier.code 0} true;
  $i3 := $trunc.i8.i1($i2);
  assume {:sourceloc "./lib/smack.c", 232, 21} true;
  assume {:verifier.code 0} true;
  $i4 := $zext.i1.i32($i3);
  assume {:sourceloc "./lib/smack.c", 232, 23} true;
  assume {:verifier.code 0} true;
  $i5 := $eq.i32($i4, 0);
  assume {:sourceloc "./lib/smack.c", 232, 28} true;
  assume {:verifier.code 0} true;
  $i6 := 1;
  assume {:branchcond $i5} true;
  goto $bb1, $bb3;
$bb1:
  assume {:sourceloc "./lib/smack.c", 232, 28} true;
  assume {:verifier.code 0} true;
  assume ($i5 == 1);
  goto $bb2;
$bb2:
  assume {:verifier.code 1} true;
  assume {:sourceloc "./lib/smack.c", 232, 28} true;
  assume {:verifier.code 1} true;
  $i10 := $zext.i1.i32($i6);
  assume {:sourceloc "./lib/smack.c", 232, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assume($i10);
  assume {:sourceloc "./lib/smack.c", 233, 10} true;
  assume {:verifier.code 0} true;
  $i11 := $trunc.i8.i1($i2);
  assume {:sourceloc "./lib/smack.c", 233, 3} true;
  assume {:verifier.code 0} true;
  $r := $i11;
  $exn := false;
  return;
$bb3:
  assume !(($i5 == 1));
  assume {:sourceloc "./lib/smack.c", 232, 31} true;
  assume {:verifier.code 1} true;
  $i7 := $trunc.i8.i1($i2);
  assume {:sourceloc "./lib/smack.c", 232, 31} true;
  assume {:verifier.code 1} true;
  $i8 := $zext.i1.i32($i7);
  assume {:sourceloc "./lib/smack.c", 232, 33} true;
  assume {:verifier.code 1} true;
  $i9 := $eq.i32($i8, 1);
  assume {:sourceloc "./lib/smack.c", 232, 28} true;
  assume {:verifier.code 0} true;
  $i6 := $i9;
  goto $bb2;
}
const __SMACK_decls: ref;
axiom (__SMACK_decls == $sub.ref(0, 87504));
type $mop;
procedure boogie_si_record_mop(m: $mop);
const $MOP: $mop;
var $exn: bool;
var $exnv: int;
procedure $alloc(n: ref) returns (p: ref)
{
  call p := $$alloc(n);
}

procedure $malloc(n: ref) returns (p: ref)
{
  call p := $$alloc(n);
}

var $CurrAddr:ref;

procedure {:inline 1} $$alloc(n: ref) returns (p: ref);
modifies $CurrAddr;
ensures $sle.ref.bool($0.ref, n);
ensures $slt.ref.bool($0.ref, n) ==> $sge.ref.bool($sub.ref($CurrAddr, n), old($CurrAddr)) && p == old($CurrAddr);
ensures $sgt.ref.bool($CurrAddr, $0.ref) && $slt.ref.bool($CurrAddr, $MALLOC_TOP);
ensures $eq.ref.bool(n, $0.ref) ==> old($CurrAddr) == $CurrAddr && p == $0.ref;

procedure $free(p: ref);

const __SMACK_top_decl: ref;
axiom (__SMACK_top_decl == $sub.ref(0, 88536));
procedure __SMACK_top_decl.ref($p0: ref);
const __SMACK_init_func_memory_model: ref;
axiom (__SMACK_init_func_memory_model == $sub.ref(0, 89568));
procedure __SMACK_init_func_memory_model()
{
$bb0:
  assume {:sourceloc "./lib/smack.c", 526, 1} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./lib/smack.c", 526, 1} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const llvm.dbg.value: ref;
axiom (llvm.dbg.value == $sub.ref(0, 90600));
procedure llvm.dbg.value($p0: ref, $p1: ref, $p2: ref);
const __SMACK_static_init: ref;
axiom (__SMACK_static_init == $sub.ref(0, 91632));
procedure __SMACK_static_init()
{
$bb0:
  $M.13 := 0;
  call {:cexpr "__unbuffered_cnt"} boogie_si_record_i32(0);
  $M.1 := 0;
  call {:cexpr "__unbuffered_p0_EAX"} boogie_si_record_i32(0);
  $M.21 := 0;
  call {:cexpr "__unbuffered_p1_EAX"} boogie_si_record_i32(0);
  $M.12 := 0;
  call {:cexpr "x"} boogie_si_record_i32(0);
  $M.0 := 0;
  call {:cexpr "y"} boogie_si_record_i32(0);
  $M.2 := 0;
  call {:cexpr "x$w_buff0"} boogie_si_record_i32(0);
  $M.3 := 0;
  call {:cexpr "x$w_buff1"} boogie_si_record_i32(0);
  $M.4 := 0;
  call {:cexpr "x$w_buff0_used"} boogie_si_record_i8(0);
  $M.5 := 0;
  call {:cexpr "x$w_buff1_used"} boogie_si_record_i8(0);
  $M.6 := 0;
  call {:cexpr "x$r_buff0_thd0"} boogie_si_record_i8(0);
  $M.7 := 0;
  call {:cexpr "x$r_buff1_thd0"} boogie_si_record_i8(0);
  $M.8 := 0;
  call {:cexpr "x$r_buff0_thd1"} boogie_si_record_i8(0);
  $M.9 := 0;
  call {:cexpr "x$r_buff1_thd1"} boogie_si_record_i8(0);
  $M.10 := 0;
  call {:cexpr "x$r_buff0_thd2"} boogie_si_record_i8(0);
  $M.11 := 0;
  call {:cexpr "x$r_buff1_thd2"} boogie_si_record_i8(0);
  $M.14 := 0;
  call {:cexpr "weak$$choice0"} boogie_si_record_i8(0);
  $M.15 := 0;
  call {:cexpr "weak$$choice2"} boogie_si_record_i8(0);
  $M.16 := 0;
  call {:cexpr "x$flush_delayed"} boogie_si_record_i8(0);
  $M.17 := 0;
  call {:cexpr "x$mem_tmp"} boogie_si_record_i32(0);
  $M.18 := 0;
  call {:cexpr "weak$$choice1"} boogie_si_record_i8(0);
  $M.19 := 0;
  call {:cexpr "__unbuffered_p1_EAX$read_delayed"} boogie_si_record_i8(0);
  $M.20 := $0.ref;
  $M.22 := 0;
  call {:cexpr "main$tmp_guard0"} boogie_si_record_i8(0);
  $M.23 := 0;
  call {:cexpr "main$tmp_guard1"} boogie_si_record_i8(0);
  $M.24 := 0;
  call {:cexpr "__unbuffered_p1_EAX$flush_delayed"} boogie_si_record_i8(0);
  $M.25 := 0;
  call {:cexpr "__unbuffered_p1_EAX$mem_tmp"} boogie_si_record_i32(0);
  $M.26 := 0;
  call {:cexpr "__unbuffered_p1_EAX$r_buff0_thd0"} boogie_si_record_i8(0);
  $M.27 := 0;
  call {:cexpr "__unbuffered_p1_EAX$r_buff0_thd1"} boogie_si_record_i8(0);
  $M.28 := 0;
  call {:cexpr "__unbuffered_p1_EAX$r_buff0_thd2"} boogie_si_record_i8(0);
  $M.29 := 0;
  call {:cexpr "__unbuffered_p1_EAX$r_buff1_thd0"} boogie_si_record_i8(0);
  $M.30 := 0;
  call {:cexpr "__unbuffered_p1_EAX$r_buff1_thd1"} boogie_si_record_i8(0);
  $M.31 := 0;
  call {:cexpr "__unbuffered_p1_EAX$r_buff1_thd2"} boogie_si_record_i8(0);
  $M.32 := 0;
  call {:cexpr "__unbuffered_p1_EAX$w_buff0"} boogie_si_record_i32(0);
  $M.33 := 0;
  call {:cexpr "__unbuffered_p1_EAX$w_buff0_used"} boogie_si_record_i8(0);
  $M.34 := 0;
  call {:cexpr "__unbuffered_p1_EAX$w_buff1"} boogie_si_record_i32(0);
  $M.35 := 0;
  call {:cexpr "__unbuffered_p1_EAX$w_buff1_used"} boogie_si_record_i8(0);
  $M.36 := 0;
  call {:cexpr "x$read_delayed"} boogie_si_record_i8(0);
  $M.37 := $0.ref;
  $M.38 := .str.1.3;
  $M.39 := 0;
  call {:cexpr "errno_global"} boogie_si_record_i32(0);
  $exn := false;
  return;
}
procedure boogie_si_record_i1(x: i1);
procedure boogie_si_record_i32(x: i32);
procedure boogie_si_record_i8(x: i8);
procedure boogie_si_record_ref(x: ref);
procedure $initialize()
{
  call __SMACK_static_init();
  call __SMACK_init_func_memory_model();
  return;
}
