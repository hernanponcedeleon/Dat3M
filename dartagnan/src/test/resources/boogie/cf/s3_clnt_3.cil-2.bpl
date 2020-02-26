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

// Memory maps (2 regions)
var $M.0: ref;
var $M.1: i32;

// Memory address bounds
axiom ($GLOBALS_BOTTOM == $sub.ref(0, 47475));
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
const {:count 14} .str.1: ref;
axiom (.str.1 == $sub.ref(0, 1038));
const env_value_str: ref;
axiom (env_value_str == $sub.ref(0, 2070));
const {:count 3} .str.1.7: ref;
axiom (.str.1.7 == $sub.ref(0, 3097));
const {:count 14} .str.14: ref;
axiom (.str.14 == $sub.ref(0, 4135));
const errno_global: ref;
axiom (errno_global == $sub.ref(0, 5163));
const reach_error: ref;
axiom (reach_error == $sub.ref(0, 6195));
procedure reach_error()
{
$bb0:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 2, 44} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 2, 44} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const ssl3_connect: ref;
axiom (ssl3_connect == $sub.ref(0, 7227));
procedure ssl3_connect($i0: i32)
  returns ($r: i32)
{
  var $i1: i32;
  var $i2: i32;
  var $i3: i32;
  var $i4: i32;
  var $i5: i32;
  var $i6: i32;
  var $i7: i32;
  var $i8: i32;
  var $i9: i32;
  var $i10: i32;
  var $i11: i32;
  var $i12: i32;
  var $i13: i32;
  var $i14: i32;
  var $i15: i32;
  var $i16: i32;
  var $i17: i32;
  var $i18: i32;
  var $i19: i32;
  var $i20: i32;
  var $i21: i32;
  var $i22: i32;
  var $i23: i32;
  var $i24: i32;
  var $i25: i32;
  var $i26: i32;
  var $i27: i32;
  var $i28: i32;
  var $i29: i32;
  var $i30: i32;
  var $i31: i64;
  var $i32: i64;
  var $i33: i64;
  var $i34: i32;
  var $i35: i1;
  var $i37: i1;
  var $i38: i32;
  var $i36: i32;
  var $i39: i32;
  var $i40: i1;
  var $i41: i32;
  var $i42: i1;
  var $i43: i32;
  var $i44: i32;
  var $i45: i32;
  var $i46: i32;
  var $i47: i32;
  var $i48: i32;
  var $i49: i32;
  var $i50: i32;
  var $i51: i1;
  var $i52: i1;
  var $i54: i1;
  var $i56: i1;
  var $i58: i1;
  var $i60: i1;
  var $i61: i1;
  var $i62: i1;
  var $i63: i1;
  var $i64: i1;
  var $i65: i1;
  var $i66: i1;
  var $i67: i1;
  var $i68: i1;
  var $i69: i1;
  var $i70: i1;
  var $i71: i1;
  var $i72: i1;
  var $i73: i1;
  var $i74: i1;
  var $i75: i1;
  var $i76: i1;
  var $i77: i1;
  var $i78: i1;
  var $i79: i1;
  var $i80: i1;
  var $i81: i1;
  var $i82: i1;
  var $i83: i1;
  var $i84: i1;
  var $i85: i1;
  var $i86: i1;
  var $i87: i1;
  var $i88: i32;
  var $i53: i32;
  var $i55: i32;
  var $i57: i32;
  var $i59: i32;
  var $i89: i1;
  var $i90: i32;
  var $i91: i1;
  var $i93: i64;
  var $i94: i64;
  var $i95: i1;
  var $i97: i32;
  var $i98: i64;
  var $i99: i64;
  var $i100: i1;
  var $i101: i1;
  var $i96: i32;
  var $i102: i1;
  var $i103: i1;
  var $i104: i32;
  var $i114: i32;
  var $i115: i1;
  var $i116: i32;
  var $i117: i1;
  var $i118: i64;
  var $i119: i64;
  var $i120: i1;
  var $i121: i32;
  var $i122: i1;
  var $i124: i1;
  var $i125: i32;
  var $i123: i32;
  var $i126: i1;
  var $i127: i1;
  var $i128: i32;
  var $i129: i64;
  var $i130: i64;
  var $i131: i1;
  var $i134: i32;
  var $i135: i1;
  var $i136: i32;
  var $i137: i1;
  var $i132: i32;
  var $i133: i32;
  var $i138: i32;
  var $i139: i1;
  var $i140: i32;
  var $i141: i1;
  var $i142: i1;
  var $i143: i32;
  var $i144: i1;
  var $i145: i1;
  var $i146: i32;
  var $i147: i1;
  var $i148: i1;
  var $i149: i32;
  var $i150: i32;
  var $i151: i1;
  var $i152: i32;
  var $i153: i1;
  var $i154: i1;
  var $i155: i32;
  var $i156: i32;
  var $i157: i1;
  var $i158: i32;
  var $i159: i1;
  var $i160: i1;
  var $i161: i1;
  var $i162: i1;
  var $i163: i32;
  var $i164: i1;
  var $i165: i64;
  var $i166: i64;
  var $i167: i32;
  var $i168: i1;
  var $i169: i64;
  var $i170: i64;
  var $i171: i1;
  var $i174: i64;
  var $i175: i64;
  var $i176: i32;
  var $i172: i32;
  var $i173: i32;
  var $i177: i32;
  var $i178: i32;
  var $i179: i32;
  var $i180: i32;
  var $i181: i1;
  var $i182: i1;
  var $i183: i32;
  var $i184: i64;
  var $i185: i1;
  var $i187: i64;
  var $i188: i32;
  var $i189: i64;
  var $i190: i1;
  var $i186: i32;
  var $i191: i1;
  var $i192: i64;
  var $i193: i64;
  var $i194: i1;
  var $i195: i1;
  var $i196: i1;
  var $i105: i32;
  var $i106: i32;
  var $i107: i32;
  var $i108: i32;
  var $i109: i32;
  var $i110: i32;
  var $i111: i32;
  var $i112: i32;
  var $i113: i32;
  var $i197: i1;
  var $i198: i1;
  var $i199: i1;
  var $i200: i32;
  var $i201: i1;
  var $i202: i1;
  var $i203: i1;
  var $i92: i32;
  var $i204: i1;
$bb0:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 13, 26} true;
  assume {:verifier.code 1} true;
  call {:cexpr "ssl3_connect:arg:initial_state"} boogie_si_record_i32($i0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 13, 26} true;
  assume {:verifier.code 1} true;
  call $i1 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i1);
  call {:cexpr "s__info_callback"} boogie_si_record_i32($i1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 14, 25} true;
  assume {:verifier.code 1} true;
  call $i2 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i2);
  call {:cexpr "s__in_handshake"} boogie_si_record_i32($i2);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 18, 20} true;
  assume {:verifier.code 1} true;
  call $i3 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i3);
  call {:cexpr "s__version"} boogie_si_record_i32($i3);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 21, 17} true;
  assume {:verifier.code 1} true;
  call $i4 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i4);
  call {:cexpr "s__bbio"} boogie_si_record_i32($i4);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 22, 17} true;
  assume {:verifier.code 1} true;
  call $i5 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i5);
  call {:cexpr "s__wbio"} boogie_si_record_i32($i5);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 23, 16} true;
  assume {:verifier.code 1} true;
  call $i6 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i6);
  call {:cexpr "s__hit"} boogie_si_record_i32($i6);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 25, 25} true;
  assume {:verifier.code 1} true;
  call $i7 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i7);
  call {:cexpr "s__init_buf___0"} boogie_si_record_i32($i7);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 26, 18} true;
  assume {:verifier.code 1} true;
  call $i8 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i8);
  call {:cexpr "s__debug"} boogie_si_record_i32($i8);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 28, 31} true;
  assume {:verifier.code 1} true;
  call $i9 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i9);
  call {:cexpr "s__ctx__info_callback"} boogie_si_record_i32($i9);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 29, 49} true;
  assume {:verifier.code 1} true;
  call $i10 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i10);
  call {:cexpr "s__ctx__stats__sess_connect_renegotiate"} boogie_si_record_i32($i10);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 30, 37} true;
  assume {:verifier.code 1} true;
  call $i11 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i11);
  call {:cexpr "s__ctx__stats__sess_connect"} boogie_si_record_i32($i11);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 31, 33} true;
  assume {:verifier.code 1} true;
  call $i12 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i12);
  call {:cexpr "s__ctx__stats__sess_hit"} boogie_si_record_i32($i12);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 32, 42} true;
  assume {:verifier.code 1} true;
  call $i13 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i13);
  call {:cexpr "s__ctx__stats__sess_connect_good"} boogie_si_record_i32($i13);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 34, 22} true;
  assume {:verifier.code 1} true;
  call $i14 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i14);
  call {:cexpr "s__s3__flags"} boogie_si_record_i32($i14);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 36, 30} true;
  assume {:verifier.code 1} true;
  call $i15 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i15);
  call {:cexpr "s__s3__tmp__cert_req"} boogie_si_record_i32($i15);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 37, 37} true;
  assume {:verifier.code 1} true;
  call $i16 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i16);
  call {:cexpr "s__s3__tmp__new_compression"} boogie_si_record_i32($i16);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 38, 35} true;
  assume {:verifier.code 1} true;
  call $i17 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i17);
  call {:cexpr "s__s3__tmp__reuse_message"} boogie_si_record_i32($i17);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 39, 32} true;
  assume {:verifier.code 1} true;
  call $i18 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i18);
  call {:cexpr "s__s3__tmp__new_cipher"} boogie_si_record_i32($i18);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 40, 44} true;
  assume {:verifier.code 1} true;
  call $i19 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i19);
  call {:cexpr "s__s3__tmp__new_cipher__algorithms"} boogie_si_record_i32($i19);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 42, 41} true;
  assume {:verifier.code 1} true;
  call $i20 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i20);
  call {:cexpr "s__s3__tmp__new_compression__id"} boogie_si_record_i32($i20);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 48, 14} true;
  assume {:verifier.code 1} true;
  call $i21 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i21);
  call {:cexpr "num1"} boogie_si_record_i32($i21);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 55, 17} true;
  assume {:verifier.code 1} true;
  call $i22 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i22);
  call {:cexpr "tmp___1"} boogie_si_record_i32($i22);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 56, 17} true;
  assume {:verifier.code 1} true;
  call $i23 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i23);
  call {:cexpr "tmp___2"} boogie_si_record_i32($i23);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 57, 17} true;
  assume {:verifier.code 1} true;
  call $i24 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i24);
  call {:cexpr "tmp___3"} boogie_si_record_i32($i24);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 58, 17} true;
  assume {:verifier.code 1} true;
  call $i25 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i25);
  call {:cexpr "tmp___4"} boogie_si_record_i32($i25);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 59, 17} true;
  assume {:verifier.code 1} true;
  call $i26 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i26);
  call {:cexpr "tmp___5"} boogie_si_record_i32($i26);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 60, 17} true;
  assume {:verifier.code 1} true;
  call $i27 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i27);
  call {:cexpr "tmp___6"} boogie_si_record_i32($i27);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 61, 17} true;
  assume {:verifier.code 1} true;
  call $i28 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i28);
  call {:cexpr "tmp___7"} boogie_si_record_i32($i28);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 62, 17} true;
  assume {:verifier.code 1} true;
  call $i29 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i29);
  call {:cexpr "tmp___8"} boogie_si_record_i32($i29);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 63, 17} true;
  assume {:verifier.code 1} true;
  call $i30 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i30);
  call {:cexpr "tmp___9"} boogie_si_record_i32($i30);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 68, 31} true;
  assume {:verifier.code 1} true;
  call $i31 := __VERIFIER_nondet_ulong();
  call {:cexpr "smack:ext:__VERIFIER_nondet_ulong"} boogie_si_record_i64($i31);
  call {:cexpr "__cil_tmp58"} boogie_si_record_i64($i31);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 75, 22} true;
  assume {:verifier.code 1} true;
  call $i32 := __VERIFIER_nondet_long();
  call {:cexpr "smack:ext:__VERIFIER_nondet_long"} boogie_si_record_i64($i32);
  call {:cexpr "__cil_tmp65"} boogie_si_record_i64($i32);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 80, 22} true;
  assume {:verifier.code 1} true;
  call $i33 := __VERIFIER_nondet_long();
  call {:cexpr "smack:ext:__VERIFIER_nondet_long"} boogie_si_record_i64($i33);
  call {:cexpr "__cil_tmp70"} boogie_si_record_i64($i33);
  call {:cexpr "ssl3_connect:arg:s__state"} boogie_si_record_i32($i0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 90, 9} true;
  assume {:verifier.code 1} true;
  call $i34 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i34);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 95, 24} true;
  assume {:verifier.code 0} true;
  $i35 := $ne.i32($i1, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 95, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i35} true;
  goto $bb1, $bb2;
$bb1:
  assume ($i35 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 97, 3} true;
  assume {:verifier.code 0} true;
  $i36 := $i1;
  goto $bb3;
$bb2:
  assume !(($i35 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 98, 31} true;
  assume {:verifier.code 0} true;
  $i37 := $ne.i32($i9, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 98, 9} true;
  assume {:verifier.code 0} true;
  $i38 := 0;
  assume {:branchcond $i37} true;
  goto $bb4, $bb5;
$bb3:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 103, 15} true;
  assume {:verifier.code 0} true;
  $i39 := $add.i32($i22, 12288);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 103, 15} true;
  assume {:verifier.code 0} true;
  $i40 := $ne.i32($i39, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 103, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i40} true;
  goto $bb7, $bb8;
$bb4:
  assume ($i37 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 100, 5} true;
  assume {:verifier.code 0} true;
  $i38 := $i9;
  goto $bb6;
$bb5:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 98, 9} true;
  assume {:verifier.code 0} true;
  assume !(($i37 == 1));
  goto $bb6;
$bb6:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  $i36 := $i38;
  goto $bb3;
$bb7:
  assume ($i40 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 104, 17} true;
  assume {:verifier.code 0} true;
  $i41 := $add.i32($i23, 16384);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 104, 17} true;
  assume {:verifier.code 0} true;
  $i42 := $ne.i32($i41, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 104, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i42} true;
  goto $bb10, $bb11;
$bb8:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 103, 7} true;
  assume {:verifier.code 0} true;
  assume !(($i40 == 1));
  goto $bb9;
$bb9:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 109, 3} true;
  assume {:verifier.code 0} true;
  $i43, $i44, $i45, $i46, $i47, $i48, $i49, $i50 := $i11, $i10, $i14, $u0, $i7, $i21, 0, $i0;
  goto $bb13;
$bb10:
  assume ($i42 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 106, 5} true;
  assume {:verifier.code 0} true;
  goto $bb12;
$bb11:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 104, 9} true;
  assume {:verifier.code 0} true;
  assume !(($i42 == 1));
  goto $bb12;
$bb12:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 107, 3} true;
  assume {:verifier.code 0} true;
  goto $bb9;
$bb13:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 34, 7} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 48, 7} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 89, 13} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 109, 13} true;
  assume {:verifier.code 0} true;
  goto $bb14;
$bb14:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 112, 18} true;
  assume {:verifier.code 0} true;
  $i51 := $eq.i32($i50, 12292);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 112, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i51} true;
  goto $bb15, $bb16;
$bb15:
  assume ($i51 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 113, 7} true;
  assume {:verifier.code 0} true;
  goto $bb17;
$bb16:
  assume !(($i51 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 115, 20} true;
  assume {:verifier.code 0} true;
  $i52 := $eq.i32($i50, 16384);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 115, 11} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i52} true;
  goto $bb18, $bb19;
$bb17:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 216, 113} true;
  assume {:verifier.code 0} true;
  $i88 := $add.i32($i44, 1);
  call {:cexpr "s__ctx__stats__sess_connect_renegotiate"} boogie_si_record_i32($i88);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 216, 73} true;
  assume {:verifier.code 0} true;
  $i53 := $i88;
  goto $bb20;
$bb18:
  assume ($i52 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 116, 9} true;
  assume {:verifier.code 0} true;
  $i53 := $i44;
  goto $bb20;
$bb19:
  assume !(($i52 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 118, 22} true;
  assume {:verifier.code 0} true;
  $i54 := $eq.i32($i50, 4096);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 118, 13} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i54} true;
  goto $bb21, $bb22;
$bb20:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 216, 73} true;
  assume {:verifier.code 0} true;
  $i55 := $i53;
  goto $bb23;
$bb21:
  assume ($i54 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 119, 11} true;
  assume {:verifier.code 0} true;
  $i55 := $i44;
  goto $bb23;
$bb22:
  assume !(($i54 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 121, 24} true;
  assume {:verifier.code 0} true;
  $i56 := $eq.i32($i50, 20480);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 121, 15} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i56} true;
  goto $bb24, $bb25;
$bb23:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 216, 73} true;
  assume {:verifier.code 0} true;
  $i57 := $i55;
  goto $bb26;
$bb24:
  assume ($i56 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 122, 13} true;
  assume {:verifier.code 0} true;
  $i57 := $i44;
  goto $bb26;
$bb25:
  assume !(($i56 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 124, 26} true;
  assume {:verifier.code 0} true;
  $i58 := $eq.i32($i50, 4099);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 124, 17} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i58} true;
  goto $bb27, $bb28;
$bb26:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 216, 73} true;
  assume {:verifier.code 0} true;
  $i59 := $i57;
  goto $bb29;
$bb27:
  assume ($i58 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 125, 15} true;
  assume {:verifier.code 0} true;
  $i59 := $i44;
  goto $bb29;
$bb28:
  assume !(($i58 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 127, 28} true;
  assume {:verifier.code 0} true;
  $i60 := $eq.i32($i50, 4368);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 127, 19} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i60} true;
  goto $bb30, $bb31;
$bb29:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 222, 80} true;
  assume {:verifier.code 0} true;
  $i89 := $ne.i32($i36, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 222, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i89} true;
  goto $bb118, $bb119;
$bb30:
  assume ($i60 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 128, 17} true;
  assume {:verifier.code 0} true;
  goto $bb32;
$bb31:
  assume !(($i60 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 130, 30} true;
  assume {:verifier.code 0} true;
  $i61 := $eq.i32($i50, 4369);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 130, 21} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i61} true;
  goto $bb33, $bb34;
$bb32:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 266, 73} true;
  assume {:verifier.code 0} true;
  goto $bb35;
$bb33:
  assume ($i61 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 131, 19} true;
  assume {:verifier.code 0} true;
  goto $bb35;
$bb34:
  assume !(($i61 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 133, 32} true;
  assume {:verifier.code 0} true;
  $i62 := $eq.i32($i50, 4384);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 133, 23} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i62} true;
  goto $bb36, $bb37;
$bb35:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 270, 79} true;
  assume {:verifier.code 1} true;
  call $i114 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i114);
  call {:cexpr "ret"} boogie_si_record_i32($i114);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 271, 87} true;
  assume {:verifier.code 0} true;
  $i115 := $eq.i32($i49, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 271, 77} true;
  assume {:verifier.code 0} true;
  $i116 := $i49;
  assume {:branchcond $i115} true;
  goto $bb136, $bb137;
$bb36:
  assume ($i62 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 134, 21} true;
  assume {:verifier.code 0} true;
  goto $bb38;
$bb37:
  assume !(($i62 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 136, 34} true;
  assume {:verifier.code 0} true;
  $i63 := $eq.i32($i50, 4385);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 136, 25} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i63} true;
  goto $bb39, $bb40;
$bb38:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 286, 73} true;
  assume {:verifier.code 0} true;
  goto $bb41;
$bb39:
  assume ($i63 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 137, 23} true;
  assume {:verifier.code 0} true;
  goto $bb41;
$bb40:
  assume !(($i63 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 139, 36} true;
  assume {:verifier.code 0} true;
  $i64 := $eq.i32($i50, 4400);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 139, 27} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i64} true;
  goto $bb42, $bb43;
$bb41:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 289, 79} true;
  assume {:verifier.code 1} true;
  call $i121 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i121);
  call {:cexpr "ret"} boogie_si_record_i32($i121);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 290, 87} true;
  assume {:verifier.code 0} true;
  $i122 := $eq.i32($i49, 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 290, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i122} true;
  goto $bb144, $bb145;
$bb42:
  assume ($i64 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 140, 25} true;
  assume {:verifier.code 0} true;
  goto $bb44;
$bb43:
  assume !(($i64 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 142, 38} true;
  assume {:verifier.code 0} true;
  $i65 := $eq.i32($i50, 4401);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 142, 29} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i65} true;
  goto $bb45, $bb46;
$bb44:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 306, 73} true;
  assume {:verifier.code 0} true;
  goto $bb47;
$bb45:
  assume ($i65 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 143, 27} true;
  assume {:verifier.code 0} true;
  goto $bb47;
$bb46:
  assume !(($i65 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 145, 40} true;
  assume {:verifier.code 0} true;
  $i66 := $eq.i32($i50, 4416);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 145, 31} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i66} true;
  goto $bb48, $bb49;
$bb47:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 310, 87} true;
  assume {:verifier.code 0} true;
  $i129 := $sext.i32.i64($i19);
  call {:cexpr "__cil_tmp64"} boogie_si_record_i64($i129);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 311, 89} true;
  assume {:verifier.code 0} true;
  $i130 := $add.i64($i129, 256);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 311, 89} true;
  assume {:verifier.code 0} true;
  $i131 := $ne.i64($i130, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 311, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i131} true;
  goto $bb155, $bb156;
$bb48:
  assume ($i66 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 146, 29} true;
  assume {:verifier.code 0} true;
  goto $bb50;
$bb49:
  assume !(($i66 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 148, 42} true;
  assume {:verifier.code 0} true;
  $i67 := $eq.i32($i50, 4417);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 148, 33} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i67} true;
  goto $bb51, $bb52;
$bb50:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 325, 73} true;
  assume {:verifier.code 0} true;
  goto $bb53;
$bb51:
  assume ($i67 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 149, 31} true;
  assume {:verifier.code 0} true;
  goto $bb53;
$bb52:
  assume !(($i67 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 151, 44} true;
  assume {:verifier.code 0} true;
  $i68 := $eq.i32($i50, 4432);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 151, 35} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i68} true;
  goto $bb54, $bb55;
$bb53:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 328, 79} true;
  assume {:verifier.code 1} true;
  call $i138 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i138);
  call {:cexpr "ret"} boogie_si_record_i32($i138);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 329, 87} true;
  assume {:verifier.code 0} true;
  $i139 := $eq.i32($i49, 3);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 329, 77} true;
  assume {:verifier.code 0} true;
  $i140 := $i49;
  assume {:branchcond $i139} true;
  goto $bb163, $bb164;
$bb54:
  assume ($i68 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 152, 33} true;
  assume {:verifier.code 0} true;
  goto $bb56;
$bb55:
  assume !(($i68 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 154, 46} true;
  assume {:verifier.code 0} true;
  $i69 := $eq.i32($i50, 4433);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 154, 37} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i69} true;
  goto $bb57, $bb58;
$bb56:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 341, 73} true;
  assume {:verifier.code 0} true;
  goto $bb59;
$bb57:
  assume ($i69 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 155, 35} true;
  assume {:verifier.code 0} true;
  goto $bb59;
$bb58:
  assume !(($i69 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 157, 48} true;
  assume {:verifier.code 0} true;
  $i70 := $eq.i32($i50, 4448);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 157, 39} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i70} true;
  goto $bb60, $bb61;
$bb59:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 344, 79} true;
  assume {:verifier.code 1} true;
  call $i143 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i143);
  call {:cexpr "ret"} boogie_si_record_i32($i143);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 345, 87} true;
  assume {:verifier.code 0} true;
  $i144 := $eq.i32($i49, 4);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 345, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i144} true;
  goto $bb170, $bb171;
$bb60:
  assume ($i70 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 158, 37} true;
  assume {:verifier.code 0} true;
  goto $bb62;
$bb61:
  assume !(($i70 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 160, 50} true;
  assume {:verifier.code 0} true;
  $i71 := $eq.i32($i50, 4449);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 160, 41} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i71} true;
  goto $bb63, $bb64;
$bb62:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 353, 73} true;
  assume {:verifier.code 0} true;
  goto $bb65;
$bb63:
  assume ($i71 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 161, 39} true;
  assume {:verifier.code 0} true;
  goto $bb65;
$bb64:
  assume !(($i71 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 163, 52} true;
  assume {:verifier.code 0} true;
  $i72 := $eq.i32($i50, 4464);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 163, 43} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i72} true;
  goto $bb66, $bb67;
$bb65:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 356, 79} true;
  assume {:verifier.code 1} true;
  call $i146 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i146);
  call {:cexpr "ret"} boogie_si_record_i32($i146);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 357, 81} true;
  assume {:verifier.code 0} true;
  $i147 := $sle.i32($i146, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 357, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i147} true;
  goto $bb175, $bb176;
$bb66:
  assume ($i72 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 164, 41} true;
  assume {:verifier.code 0} true;
  goto $bb68;
$bb67:
  assume !(($i72 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 166, 54} true;
  assume {:verifier.code 0} true;
  $i73 := $eq.i32($i50, 4465);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 166, 45} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i73} true;
  goto $bb69, $bb70;
$bb68:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 366, 73} true;
  assume {:verifier.code 0} true;
  goto $bb71;
$bb69:
  assume ($i73 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 167, 43} true;
  assume {:verifier.code 0} true;
  goto $bb71;
$bb70:
  assume !(($i73 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 169, 56} true;
  assume {:verifier.code 0} true;
  $i74 := $eq.i32($i50, 4466);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 169, 47} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i74} true;
  goto $bb72, $bb73;
$bb71:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 366, 73} true;
  assume {:verifier.code 0} true;
  goto $bb74;
$bb72:
  assume ($i74 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 170, 45} true;
  assume {:verifier.code 0} true;
  goto $bb74;
$bb73:
  assume !(($i74 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 172, 58} true;
  assume {:verifier.code 0} true;
  $i75 := $eq.i32($i50, 4467);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 172, 49} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i75} true;
  goto $bb75, $bb76;
$bb74:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 366, 73} true;
  assume {:verifier.code 0} true;
  goto $bb77;
$bb75:
  assume ($i75 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 173, 47} true;
  assume {:verifier.code 0} true;
  goto $bb77;
$bb76:
  assume !(($i75 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 175, 60} true;
  assume {:verifier.code 0} true;
  $i76 := $eq.i32($i50, 4480);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 175, 51} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i76} true;
  goto $bb78, $bb79;
$bb77:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 371, 79} true;
  assume {:verifier.code 1} true;
  call $i150 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i150);
  call {:cexpr "ret"} boogie_si_record_i32($i150);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 372, 81} true;
  assume {:verifier.code 0} true;
  $i151 := $sle.i32($i150, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 372, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i151} true;
  goto $bb180, $bb181;
$bb78:
  assume ($i76 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 176, 49} true;
  assume {:verifier.code 0} true;
  goto $bb80;
$bb79:
  assume !(($i76 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 178, 62} true;
  assume {:verifier.code 0} true;
  $i77 := $eq.i32($i50, 4481);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 178, 53} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i77} true;
  goto $bb81, $bb82;
$bb80:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 377, 73} true;
  assume {:verifier.code 0} true;
  goto $bb83;
$bb81:
  assume ($i77 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 179, 51} true;
  assume {:verifier.code 0} true;
  goto $bb83;
$bb82:
  assume !(($i77 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 181, 64} true;
  assume {:verifier.code 0} true;
  $i78 := $eq.i32($i50, 4496);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 181, 55} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i78} true;
  goto $bb84, $bb85;
$bb83:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 380, 79} true;
  assume {:verifier.code 1} true;
  call $i152 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i152);
  call {:cexpr "ret"} boogie_si_record_i32($i152);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 381, 81} true;
  assume {:verifier.code 0} true;
  $i153 := $sle.i32($i152, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 381, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i153} true;
  goto $bb182, $bb183;
$bb84:
  assume ($i78 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 182, 53} true;
  assume {:verifier.code 0} true;
  goto $bb86;
$bb85:
  assume !(($i78 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 184, 66} true;
  assume {:verifier.code 0} true;
  $i79 := $eq.i32($i50, 4497);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 184, 57} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i79} true;
  goto $bb87, $bb88;
$bb86:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 392, 73} true;
  assume {:verifier.code 0} true;
  goto $bb89;
$bb87:
  assume ($i79 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 185, 55} true;
  assume {:verifier.code 0} true;
  goto $bb89;
$bb88:
  assume !(($i79 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 187, 68} true;
  assume {:verifier.code 0} true;
  $i80 := $eq.i32($i50, 4512);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 187, 59} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i80} true;
  goto $bb90, $bb91;
$bb89:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 395, 79} true;
  assume {:verifier.code 1} true;
  call $i156 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i156);
  call {:cexpr "ret"} boogie_si_record_i32($i156);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 396, 81} true;
  assume {:verifier.code 0} true;
  $i157 := $sle.i32($i156, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 396, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i157} true;
  goto $bb187, $bb188;
$bb90:
  assume ($i80 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 188, 57} true;
  assume {:verifier.code 0} true;
  goto $bb92;
$bb91:
  assume !(($i80 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 190, 70} true;
  assume {:verifier.code 0} true;
  $i81 := $eq.i32($i50, 4513);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 190, 61} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i81} true;
  goto $bb93, $bb94;
$bb92:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 402, 73} true;
  assume {:verifier.code 0} true;
  goto $bb95;
$bb93:
  assume ($i81 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 191, 59} true;
  assume {:verifier.code 0} true;
  goto $bb95;
$bb94:
  assume !(($i81 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 193, 72} true;
  assume {:verifier.code 0} true;
  $i82 := $eq.i32($i50, 4528);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 193, 63} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i82} true;
  goto $bb96, $bb97;
$bb95:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 405, 79} true;
  assume {:verifier.code 1} true;
  call $i158 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i158);
  call {:cexpr "ret"} boogie_si_record_i32($i158);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 406, 81} true;
  assume {:verifier.code 0} true;
  $i159 := $sle.i32($i158, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 406, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i159} true;
  goto $bb189, $bb190;
$bb96:
  assume ($i82 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 194, 61} true;
  assume {:verifier.code 0} true;
  goto $bb98;
$bb97:
  assume !(($i82 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 196, 74} true;
  assume {:verifier.code 0} true;
  $i83 := $eq.i32($i50, 4529);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 196, 65} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i83} true;
  goto $bb99, $bb100;
$bb98:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 425, 73} true;
  assume {:verifier.code 0} true;
  goto $bb101;
$bb99:
  assume ($i83 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 197, 63} true;
  assume {:verifier.code 0} true;
  goto $bb101;
$bb100:
  assume !(($i83 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 199, 76} true;
  assume {:verifier.code 0} true;
  $i84 := $eq.i32($i50, 4560);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 199, 67} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i84} true;
  goto $bb102, $bb103;
$bb101:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 428, 79} true;
  assume {:verifier.code 1} true;
  call $i163 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i163);
  call {:cexpr "ret"} boogie_si_record_i32($i163);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 429, 81} true;
  assume {:verifier.code 0} true;
  $i164 := $sle.i32($i163, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 429, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i164} true;
  goto $bb198, $bb199;
$bb102:
  assume ($i84 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 200, 65} true;
  assume {:verifier.code 0} true;
  goto $bb104;
$bb103:
  assume !(($i84 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 202, 78} true;
  assume {:verifier.code 0} true;
  $i85 := $eq.i32($i50, 4561);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 202, 69} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i85} true;
  goto $bb105, $bb106;
$bb104:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 452, 73} true;
  assume {:verifier.code 0} true;
  goto $bb107;
$bb105:
  assume ($i85 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 203, 67} true;
  assume {:verifier.code 0} true;
  goto $bb107;
$bb106:
  assume !(($i85 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 205, 80} true;
  assume {:verifier.code 0} true;
  $i86 := $eq.i32($i50, 4352);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 205, 71} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i86} true;
  goto $bb108, $bb109;
$bb107:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 455, 79} true;
  assume {:verifier.code 1} true;
  call $i180 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i180);
  call {:cexpr "ret"} boogie_si_record_i32($i180);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 456, 81} true;
  assume {:verifier.code 0} true;
  $i181 := $sle.i32($i180, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 456, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i181} true;
  goto $bb206, $bb207;
$bb108:
  assume ($i86 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 206, 69} true;
  assume {:verifier.code 0} true;
  goto $bb110;
$bb109:
  assume !(($i86 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 208, 82} true;
  assume {:verifier.code 0} true;
  $i87 := $eq.i32($i50, 3);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 208, 73} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i87} true;
  goto $bb111, $bb112;
$bb110:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 468, 87} true;
  assume {:verifier.code 0} true;
  $i184 := $sext.i32.i64($i48);
  call {:cexpr "__cil_tmp70"} boogie_si_record_i64($i184);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 469, 89} true;
  assume {:verifier.code 0} true;
  $i185 := $sgt.i64($i184, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 469, 77} true;
  assume {:verifier.code 0} true;
  $i186 := $i48;
  assume {:branchcond $i185} true;
  goto $bb211, $bb212;
$bb111:
  assume ($i87 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 209, 71} true;
  assume {:verifier.code 0} true;
  goto $bb113;
$bb112:
  assume !(($i87 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 211, 71} true;
  assume {:verifier.code 0} true;
  goto $bb114;
$bb113:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 486, 93} true;
  assume {:verifier.code 0} true;
  $i191 := $ne.i32($i47, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 486, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i191} true;
  goto $bb216, $bb217;
$bb114:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 509, 73} true;
  assume {:verifier.code 0} true;
  $i92 := $sub.i32(0, 1);
  goto $bb123;
$bb115:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 212, 75} true;
  assume {:verifier.code 0} true;
  assume {:branchcond 0} true;
  goto $bb116, $bb117;
$bb116:
  assume (0 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 212, 78} true;
  assume {:verifier.code 0} true;
  goto $bb17;
$bb117:
  assume !((0 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 510, 78} true;
  assume {:verifier.code 0} true;
  $i105, $i106, $i107, $i108, $i109, $i110, $i111, $i112, $i113 := $u0, $u0, $u0, $u0, $u0, $u0, $u0, $u0, $u0;
  goto $bb135;
$bb118:
  assume ($i89 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 224, 73} true;
  assume {:verifier.code 0} true;
  goto $bb120;
$bb119:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 222, 77} true;
  assume {:verifier.code 0} true;
  assume !(($i89 == 1));
  goto $bb120;
$bb120:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 226, 98} true;
  assume {:verifier.code 0} true;
  $i90 := $add.i32($i3, 65280);
  call {:cexpr "__cil_tmp55"} boogie_si_record_i32($i90);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 227, 89} true;
  assume {:verifier.code 0} true;
  $i91 := $ne.i32($i90, 768);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 227, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i91} true;
  goto $bb121, $bb122;
$bb121:
  assume ($i91 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 229, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $sub.i32(0, 1);
  goto $bb123;
$bb122:
  assume !(($i91 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 235, 87} true;
  assume {:verifier.code 0} true;
  $i93 := $p2i.ref.i64($0.ref);
  call {:cexpr "__cil_tmp57"} boogie_si_record_i64($i93);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 236, 87} true;
  assume {:verifier.code 0} true;
  $i94 := $sext.i32.i64($i47);
  call {:cexpr "__cil_tmp58"} boogie_si_record_i64($i94);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 237, 89} true;
  assume {:verifier.code 0} true;
  $i95 := $eq.i64($i94, $i93);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 237, 77} true;
  assume {:verifier.code 0} true;
  $i96 := $i47;
  assume {:branchcond $i95} true;
  goto $bb124, $bb125;
$bb123:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 570, 10} true;
  assume {:verifier.code 0} true;
  $i204 := $ne.i32($i36, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 570, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i204} true;
  goto $bb280, $bb281;
$bb124:
  assume ($i95 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 238, 81} true;
  assume {:verifier.code 1} true;
  call $i97 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i97);
  call {:cexpr "buf"} boogie_si_record_i32($i97);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 241, 89} true;
  assume {:verifier.code 0} true;
  $i98 := $p2i.ref.i64($0.ref);
  call {:cexpr "__cil_tmp60"} boogie_si_record_i64($i98);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 242, 89} true;
  assume {:verifier.code 0} true;
  $i99 := $sext.i32.i64($i97);
  call {:cexpr "__cil_tmp61"} boogie_si_record_i64($i99);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 243, 91} true;
  assume {:verifier.code 0} true;
  $i100 := $eq.i64($i99, $i98);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 243, 79} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i100} true;
  goto $bb127, $bb128;
$bb125:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 237, 77} true;
  assume {:verifier.code 0} true;
  assume !(($i95 == 1));
  goto $bb126;
$bb126:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 255, 79} true;
  assume {:verifier.code 0} true;
  $i102 := $ne.i32($i25, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 255, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i102} true;
  goto $bb131, $bb132;
$bb127:
  assume ($i100 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 245, 77} true;
  assume {:verifier.code 0} true;
  $i92 := $sub.i32(0, 1);
  goto $bb123;
$bb128:
  assume !(($i100 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 248, 81} true;
  assume {:verifier.code 0} true;
  $i101 := $ne.i32($i24, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 248, 79} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i101} true;
  goto $bb129, $bb130;
$bb129:
  assume ($i101 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 253, 73} true;
  assume {:verifier.code 0} true;
  $i96 := $i97;
  goto $bb126;
$bb130:
  assume !(($i101 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 250, 77} true;
  assume {:verifier.code 0} true;
  $i92 := $sub.i32(0, 1);
  goto $bb123;
$bb131:
  assume ($i102 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 259, 79} true;
  assume {:verifier.code 0} true;
  $i103 := $ne.i32($i26, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 259, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i103} true;
  goto $bb133, $bb134;
$bb132:
  assume !(($i102 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 257, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $sub.i32(0, 1);
  goto $bb123;
$bb133:
  assume ($i103 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 264, 101} true;
  assume {:verifier.code 0} true;
  $i104 := $add.i32($i43, 1);
  call {:cexpr "s__ctx__stats__sess_connect"} boogie_si_record_i32($i104);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 266, 73} true;
  assume {:verifier.code 0} true;
  $i105, $i106, $i107, $i108, $i109, $i110, $i111, $i112, $i113 := $i104, $i59, $i45, $i46, $i96, $i48, 0, $i49, 4368;
  goto $bb135;
$bb134:
  assume !(($i103 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 261, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $sub.i32(0, 1);
  goto $bb123;
$bb135:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  goto $bb228;
$bb136:
  assume ($i115 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 273, 73} true;
  assume {:verifier.code 0} true;
  $i116 := 1;
  goto $bb138;
$bb137:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 271, 77} true;
  assume {:verifier.code 0} true;
  assume !(($i115 == 1));
  goto $bb138;
$bb138:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 274, 81} true;
  assume {:verifier.code 0} true;
  $i117 := $sle.i32($i114, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 274, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i117} true;
  goto $bb139, $bb140;
$bb139:
  assume ($i117 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 275, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $i114;
  goto $bb123;
$bb140:
  assume !(($i117 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 280, 87} true;
  assume {:verifier.code 0} true;
  $i118 := $sext.i32.i64($i5);
  call {:cexpr "__cil_tmp62"} boogie_si_record_i64($i118);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 281, 87} true;
  assume {:verifier.code 0} true;
  $i119 := $sext.i32.i64($i4);
  call {:cexpr "__cil_tmp63"} boogie_si_record_i64($i119);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 282, 89} true;
  assume {:verifier.code 0} true;
  $i120 := $ne.i64($i119, $i118);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 282, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i120} true;
  goto $bb141, $bb142;
$bb141:
  assume ($i120 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 284, 73} true;
  assume {:verifier.code 0} true;
  goto $bb143;
$bb142:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 282, 77} true;
  assume {:verifier.code 0} true;
  assume !(($i120 == 1));
  goto $bb143;
$bb143:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 286, 73} true;
  assume {:verifier.code 0} true;
  $i105, $i106, $i107, $i108, $i109, $i110, $i111, $i112, $i113 := $i43, $i44, $i45, $i46, $i47, $i48, 0, $i116, 4384;
  goto $bb135;
$bb144:
  assume ($i122 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 292, 73} true;
  assume {:verifier.code 0} true;
  $i123 := 2;
  goto $bb146;
$bb145:
  assume !(($i122 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 293, 89} true;
  assume {:verifier.code 0} true;
  $i124 := $eq.i32($i49, 4);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 293, 79} true;
  assume {:verifier.code 0} true;
  $i125 := $i49;
  assume {:branchcond $i124} true;
  goto $bb147, $bb148;
$bb146:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 297, 81} true;
  assume {:verifier.code 0} true;
  $i126 := $sle.i32($i121, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 297, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i126} true;
  goto $bb150, $bb151;
$bb147:
  assume ($i124 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 295, 75} true;
  assume {:verifier.code 0} true;
  $i125 := 5;
  goto $bb149;
$bb148:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 293, 79} true;
  assume {:verifier.code 0} true;
  assume !(($i124 == 1));
  goto $bb149;
$bb149:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  $i123 := $i125;
  goto $bb146;
$bb150:
  assume ($i126 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 298, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $i121;
  goto $bb123;
$bb151:
  assume !(($i126 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 300, 77} true;
  assume {:verifier.code 0} true;
  $i127 := $ne.i32($i6, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 300, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i127} true;
  goto $bb152, $bb153;
$bb152:
  assume ($i127 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 302, 73} true;
  assume {:verifier.code 0} true;
  $i128 := 4560;
  goto $bb154;
$bb153:
  assume !(($i127 == 1));
  assume {:verifier.code 0} true;
  $i128 := 4400;
  goto $bb154;
$bb154:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 306, 73} true;
  assume {:verifier.code 0} true;
  $i105, $i106, $i107, $i108, $i109, $i110, $i111, $i112, $i113 := $i43, $i44, $i45, $i46, $i47, $i48, 0, $i123, $i128;
  goto $bb135;
$bb155:
  assume ($i131 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 313, 73} true;
  assume {:verifier.code 0} true;
  $i132, $i133 := 1, $i49;
  goto $bb157;
$bb156:
  assume !(($i131 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 314, 81} true;
  assume {:verifier.code 1} true;
  call $i134 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i134);
  call {:cexpr "ret"} boogie_si_record_i32($i134);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 315, 89} true;
  assume {:verifier.code 0} true;
  $i135 := $eq.i32($i49, 2);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 315, 79} true;
  assume {:verifier.code 0} true;
  $i136 := $i49;
  assume {:branchcond $i135} true;
  goto $bb158, $bb159;
$bb157:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 325, 73} true;
  assume {:verifier.code 0} true;
  $i105, $i106, $i107, $i108, $i109, $i110, $i111, $i112, $i113 := $i43, $i44, $i45, $i46, $i47, $i48, $i132, $i133, 4416;
  goto $bb135;
$bb158:
  assume ($i135 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 317, 75} true;
  assume {:verifier.code 0} true;
  $i136 := 3;
  goto $bb160;
$bb159:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 315, 79} true;
  assume {:verifier.code 0} true;
  assume !(($i135 == 1));
  goto $bb160;
$bb160:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 318, 83} true;
  assume {:verifier.code 0} true;
  $i137 := $sle.i32($i134, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 318, 79} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i137} true;
  goto $bb161, $bb162;
$bb161:
  assume ($i137 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 319, 77} true;
  assume {:verifier.code 0} true;
  $i92 := $i134;
  goto $bb123;
$bb162:
  assume !(($i137 == 1));
  assume {:verifier.code 0} true;
  $i132, $i133 := 0, $i136;
  goto $bb157;
$bb163:
  assume ($i139 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 331, 73} true;
  assume {:verifier.code 0} true;
  $i140 := 4;
  goto $bb165;
$bb164:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 329, 77} true;
  assume {:verifier.code 0} true;
  assume !(($i139 == 1));
  goto $bb165;
$bb165:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 332, 81} true;
  assume {:verifier.code 0} true;
  $i141 := $sle.i32($i138, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 332, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i141} true;
  goto $bb166, $bb167;
$bb166:
  assume ($i141 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 333, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $i138;
  goto $bb123;
$bb167:
  assume !(($i141 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 337, 79} true;
  assume {:verifier.code 0} true;
  $i142 := $ne.i32($i27, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 337, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i142} true;
  goto $bb168, $bb169;
$bb168:
  assume ($i142 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 341, 73} true;
  assume {:verifier.code 0} true;
  $i105, $i106, $i107, $i108, $i109, $i110, $i111, $i112, $i113 := $i43, $i44, $i45, $i46, $i47, $i48, 0, $i140, 4432;
  goto $bb135;
$bb169:
  assume !(($i142 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 339, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $sub.i32(0, 1);
  goto $bb123;
$bb170:
  assume ($i144 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 346, 75} true;
  assume {:verifier.code 0} true;
  goto $bb172;
$bb171:
  assume !(($i144 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 348, 81} true;
  assume {:verifier.code 0} true;
  $i145 := $sle.i32($i143, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 348, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i145} true;
  goto $bb173, $bb174;
$bb172:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 574, 11} true;
  assume {:verifier.code 0} true;
  call reach_error();
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 574, 25} true;
  assume {:verifier.code 0} true;
  call abort();
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 574, 25} true;
  assume {:verifier.code 0} true;
  assume false;
$bb173:
  assume ($i145 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 349, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $i143;
  goto $bb123;
$bb174:
  assume !(($i145 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 353, 73} true;
  assume {:verifier.code 0} true;
  $i105, $i106, $i107, $i108, $i109, $i110, $i111, $i112, $i113 := $i43, $i44, $i45, $i46, $i47, $i48, 0, $i49, 4448;
  goto $bb135;
$bb175:
  assume ($i147 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 358, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $i146;
  goto $bb123;
$bb176:
  assume !(($i147 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 360, 77} true;
  assume {:verifier.code 0} true;
  $i148 := $ne.i32($i15, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 360, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i148} true;
  goto $bb177, $bb178;
$bb177:
  assume ($i148 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 362, 73} true;
  assume {:verifier.code 0} true;
  $i149 := 4464;
  goto $bb179;
$bb178:
  assume !(($i148 == 1));
  assume {:verifier.code 0} true;
  $i149 := 4480;
  goto $bb179;
$bb179:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 366, 73} true;
  assume {:verifier.code 0} true;
  $i105, $i106, $i107, $i108, $i109, $i110, $i111, $i112, $i113 := $i43, $i44, $i45, $i46, $i47, $i48, 0, $i49, $i149;
  goto $bb135;
$bb180:
  assume ($i151 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 373, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $i150;
  goto $bb123;
$bb181:
  assume !(($i151 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 377, 73} true;
  assume {:verifier.code 0} true;
  $i105, $i106, $i107, $i108, $i109, $i110, $i111, $i112, $i113 := $i43, $i44, $i45, $i46, $i47, $i48, 0, $i49, 4480;
  goto $bb135;
$bb182:
  assume ($i153 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 382, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $i152;
  goto $bb123;
$bb183:
  assume !(($i153 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 385, 98} true;
  assume {:verifier.code 0} true;
  $i154 := $eq.i32($i15, 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 385, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i154} true;
  goto $bb184, $bb185;
$bb184:
  assume ($i154 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 387, 73} true;
  assume {:verifier.code 0} true;
  $i155 := 4496;
  goto $bb186;
$bb185:
  assume !(($i154 == 1));
  assume {:verifier.code 0} true;
  $i155 := 4512;
  goto $bb186;
$bb186:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 392, 73} true;
  assume {:verifier.code 0} true;
  $i105, $i106, $i107, $i108, $i109, $i110, $i111, $i112, $i113 := $i43, $i44, $i45, $i46, $i47, $i48, 0, $i49, $i155;
  goto $bb135;
$bb187:
  assume ($i157 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 397, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $i156;
  goto $bb123;
$bb188:
  assume !(($i157 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 402, 73} true;
  assume {:verifier.code 0} true;
  $i105, $i106, $i107, $i108, $i109, $i110, $i111, $i112, $i113 := $i43, $i44, $i45, $i46, $i47, $i48, 0, $i49, 4512;
  goto $bb135;
$bb189:
  assume ($i159 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 407, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $i158;
  goto $bb123;
$bb190:
  assume !(($i159 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 412, 105} true;
  assume {:verifier.code 0} true;
  $i160 := $eq.i32($i16, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 412, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i160} true;
  goto $bb191, $bb192;
$bb191:
  assume ($i160 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 414, 73} true;
  assume {:verifier.code 0} true;
  goto $bb193;
$bb192:
  assume !(($i160 == 1));
  assume {:verifier.code 0} true;
  goto $bb193;
$bb193:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 417, 79} true;
  assume {:verifier.code 0} true;
  $i161 := $ne.i32($i28, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 417, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i161} true;
  goto $bb194, $bb195;
$bb194:
  assume ($i161 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 421, 79} true;
  assume {:verifier.code 0} true;
  $i162 := $ne.i32($i29, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 421, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i162} true;
  goto $bb196, $bb197;
$bb195:
  assume !(($i161 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 419, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $sub.i32(0, 1);
  goto $bb123;
$bb196:
  assume ($i162 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 425, 73} true;
  assume {:verifier.code 0} true;
  $i105, $i106, $i107, $i108, $i109, $i110, $i111, $i112, $i113 := $i43, $i44, $i45, $i46, $i47, $i48, 0, $i49, 4528;
  goto $bb135;
$bb197:
  assume !(($i162 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 423, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $sub.i32(0, 1);
  goto $bb123;
$bb198:
  assume ($i164 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 430, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $i163;
  goto $bb123;
$bb199:
  assume !(($i164 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 433, 87} true;
  assume {:verifier.code 0} true;
  $i165 := $sext.i32.i64($i45);
  call {:cexpr "__cil_tmp65"} boogie_si_record_i64($i165);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 434, 99} true;
  assume {:verifier.code 0} true;
  $i166 := $sub.i64($i165, 5);
  call {:cexpr "__cil_tmp66"} boogie_si_record_i64($i166);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 435, 88} true;
  assume {:verifier.code 0} true;
  $i167 := $trunc.i64.i32($i166);
  call {:cexpr "s__s3__flags"} boogie_si_record_i32($i167);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 436, 77} true;
  assume {:verifier.code 0} true;
  $i168 := $ne.i32($i6, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 436, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i168} true;
  goto $bb200, $bb201;
$bb200:
  assume ($i168 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 439, 89} true;
  assume {:verifier.code 0} true;
  $i169 := $sext.i32.i64($i167);
  call {:cexpr "__cil_tmp67"} boogie_si_record_i64($i169);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 440, 91} true;
  assume {:verifier.code 0} true;
  $i170 := $add.i64($i169, 2);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 440, 91} true;
  assume {:verifier.code 0} true;
  $i171 := $ne.i64($i170, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 440, 79} true;
  assume {:verifier.code 0} true;
  $i172, $i173 := $i167, 4352;
  assume {:branchcond $i171} true;
  goto $bb202, $bb203;
$bb201:
  assume !(($i168 == 1));
  assume {:verifier.code 0} true;
  $i177, $i178, $i179 := $i167, 4560, 4352;
  goto $bb205;
$bb202:
  assume ($i171 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 442, 91} true;
  assume {:verifier.code 0} true;
  $i174 := $sext.i32.i64($i167);
  call {:cexpr "__cil_tmp68"} boogie_si_record_i64($i174);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 443, 103} true;
  assume {:verifier.code 0} true;
  $i175 := $mul.i64($i174, 4);
  call {:cexpr "__cil_tmp69"} boogie_si_record_i64($i175);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 444, 92} true;
  assume {:verifier.code 0} true;
  $i176 := $trunc.i64.i32($i175);
  call {:cexpr "s__s3__flags"} boogie_si_record_i32($i176);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 446, 75} true;
  assume {:verifier.code 0} true;
  $i172, $i173 := $i176, 3;
  goto $bb204;
$bb203:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 440, 79} true;
  assume {:verifier.code 0} true;
  assume !(($i171 == 1));
  goto $bb204;
$bb204:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 448, 73} true;
  assume {:verifier.code 0} true;
  $i177, $i178, $i179 := $i172, 3, $i173;
  goto $bb205;
$bb205:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 452, 73} true;
  assume {:verifier.code 0} true;
  $i105, $i106, $i107, $i108, $i109, $i110, $i111, $i112, $i113 := $i43, $i44, $i177, $i178, $i47, $i48, 0, $i49, $i179;
  goto $bb135;
$bb206:
  assume ($i181 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 457, 75} true;
  assume {:verifier.code 0} true;
  $i92 := $i180;
  goto $bb123;
$bb207:
  assume !(($i181 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 459, 77} true;
  assume {:verifier.code 0} true;
  $i182 := $ne.i32($i6, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 459, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i182} true;
  goto $bb208, $bb209;
$bb208:
  assume ($i182 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 461, 73} true;
  assume {:verifier.code 0} true;
  $i183 := 4512;
  goto $bb210;
$bb209:
  assume !(($i182 == 1));
  assume {:verifier.code 0} true;
  $i183 := 3;
  goto $bb210;
$bb210:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 465, 73} true;
  assume {:verifier.code 0} true;
  $i105, $i106, $i107, $i108, $i109, $i110, $i111, $i112, $i113 := $i43, $i44, $i45, $i46, $i47, $i48, 0, $i49, $i183;
  goto $bb135;
$bb211:
  assume ($i185 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 471, 89} true;
  assume {:verifier.code 0} true;
  $i187 := $sext.i32.i64($i30);
  call {:cexpr "__cil_tmp71"} boogie_si_record_i64($i187);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 472, 82} true;
  assume {:verifier.code 0} true;
  $i188 := $trunc.i64.i32($i187);
  call {:cexpr "num1"} boogie_si_record_i32($i188);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 474, 89} true;
  assume {:verifier.code 0} true;
  $i189 := $sext.i32.i64($i188);
  call {:cexpr "__cil_tmp72"} boogie_si_record_i64($i189);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 475, 91} true;
  assume {:verifier.code 0} true;
  $i190 := $sle.i64($i189, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 475, 79} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i190} true;
  goto $bb214, $bb215;
$bb212:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 469, 77} true;
  assume {:verifier.code 0} true;
  assume !(($i185 == 1));
  goto $bb213;
$bb213:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 484, 73} true;
  assume {:verifier.code 0} true;
  $i105, $i106, $i107, $i108, $i109, $i110, $i111, $i112, $i113 := $i43, $i44, $i45, $i46, $i47, $i186, 0, $i49, $i46;
  goto $bb135;
$bb214:
  assume ($i190 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 477, 77} true;
  assume {:verifier.code 0} true;
  $i92 := $sub.i32(0, 1);
  goto $bb123;
$bb215:
  assume !(($i190 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 481, 73} true;
  assume {:verifier.code 0} true;
  $i186 := $i188;
  goto $bb213;
$bb216:
  assume ($i191 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 488, 73} true;
  assume {:verifier.code 0} true;
  goto $bb218;
$bb217:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 486, 77} true;
  assume {:verifier.code 0} true;
  assume !(($i191 == 1));
  goto $bb218;
$bb218:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 490, 87} true;
  assume {:verifier.code 0} true;
  $i192 := $sext.i32.i64($i45);
  call {:cexpr "__cil_tmp73"} boogie_si_record_i64($i192);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 491, 99} true;
  assume {:verifier.code 0} true;
  $i193 := $add.i64($i192, 4);
  call {:cexpr "__cil_tmp74"} boogie_si_record_i64($i193);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 492, 79} true;
  assume {:verifier.code 0} true;
  $i194 := $ne.i64($i193, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 492, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i194} true;
  goto $bb219, $bb221;
$bb219:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 492, 77} true;
  assume {:verifier.code 0} true;
  assume ($i194 == 1);
  goto $bb220;
$bb220:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 498, 77} true;
  assume {:verifier.code 0} true;
  $i195 := $ne.i32($i6, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 498, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i195} true;
  goto $bb222, $bb223;
$bb221:
  assume !(($i194 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 494, 73} true;
  assume {:verifier.code 0} true;
  goto $bb220;
$bb222:
  assume ($i195 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 500, 73} true;
  assume {:verifier.code 0} true;
  goto $bb224;
$bb223:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 498, 77} true;
  assume {:verifier.code 0} true;
  assume !(($i195 == 1));
  goto $bb224;
$bb224:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 503, 80} true;
  assume {:verifier.code 0} true;
  $i196 := $ne.i32($i36, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 503, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i196} true;
  goto $bb225, $bb226;
$bb225:
  assume ($i196 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 505, 73} true;
  assume {:verifier.code 0} true;
  goto $bb227;
$bb226:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 503, 77} true;
  assume {:verifier.code 0} true;
  assume !(($i196 == 1));
  goto $bb227;
$bb227:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 506, 73} true;
  assume {:verifier.code 0} true;
  $i92 := 1;
  goto $bb123;
$bb228:
  assume {:verifier.code 0} true;
  goto $bb229;
$bb229:
  assume {:verifier.code 0} true;
  goto $bb230;
$bb230:
  assume {:verifier.code 0} true;
  goto $bb231;
$bb231:
  assume {:verifier.code 0} true;
  goto $bb232;
$bb232:
  assume {:verifier.code 0} true;
  goto $bb233;
$bb233:
  assume {:verifier.code 0} true;
  goto $bb234;
$bb234:
  assume {:verifier.code 0} true;
  goto $bb235;
$bb235:
  assume {:verifier.code 0} true;
  goto $bb236;
$bb236:
  assume {:verifier.code 0} true;
  goto $bb237;
$bb237:
  assume {:verifier.code 0} true;
  goto $bb238;
$bb238:
  assume {:verifier.code 0} true;
  goto $bb239;
$bb239:
  assume {:verifier.code 0} true;
  goto $bb240;
$bb240:
  assume {:verifier.code 0} true;
  goto $bb241;
$bb241:
  assume {:verifier.code 0} true;
  goto $bb242;
$bb242:
  assume {:verifier.code 0} true;
  goto $bb243;
$bb243:
  assume {:verifier.code 0} true;
  goto $bb244;
$bb244:
  assume {:verifier.code 0} true;
  goto $bb245;
$bb245:
  assume {:verifier.code 0} true;
  goto $bb246;
$bb246:
  assume {:verifier.code 0} true;
  goto $bb247;
$bb247:
  assume {:verifier.code 0} true;
  goto $bb248;
$bb248:
  assume {:verifier.code 0} true;
  goto $bb249;
$bb249:
  assume {:verifier.code 0} true;
  goto $bb250;
$bb250:
  assume {:verifier.code 0} true;
  goto $bb251;
$bb251:
  assume {:verifier.code 0} true;
  goto $bb252;
$bb252:
  assume {:verifier.code 0} true;
  goto $bb253;
$bb253:
  assume {:verifier.code 0} true;
  goto $bb254;
$bb254:
  assume {:verifier.code 0} true;
  goto $bb255;
$bb255:
  assume {:verifier.code 0} true;
  goto $bb256;
$bb256:
  assume {:verifier.code 0} true;
  goto $bb257;
$bb257:
  assume {:verifier.code 0} true;
  goto $bb258;
$bb258:
  assume {:verifier.code 0} true;
  goto $bb259;
$bb259:
  assume {:verifier.code 0} true;
  goto $bb260;
$bb260:
  assume {:verifier.code 0} true;
  goto $bb261;
$bb261:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 546, 11} true;
  assume {:verifier.code 0} true;
  $i197 := $ne.i32($i17, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 546, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i197} true;
  goto $bb262, $bb264;
$bb262:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 546, 9} true;
  assume {:verifier.code 0} true;
  assume ($i197 == 1);
  goto $bb263;
$bb263:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 109, 3} true;
  assume {:verifier.code 0} true;
  $i43, $i44, $i45, $i46, $i47, $i48, $i49, $i50 := $i105, $i106, $i107, $i108, $i109, $i110, $i112, $i113;
  goto $bb13;
$bb264:
  assume !(($i197 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 547, 13} true;
  assume {:verifier.code 0} true;
  $i198 := $ne.i32($i111, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 547, 11} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i198} true;
  goto $bb265, $bb267;
$bb265:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 547, 11} true;
  assume {:verifier.code 0} true;
  assume ($i198 == 1);
  goto $bb266;
$bb266:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 562, 5} true;
  assume {:verifier.code 0} true;
  goto $bb263;
$bb267:
  assume !(($i198 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 548, 13} true;
  assume {:verifier.code 0} true;
  $i199 := $ne.i32($i8, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 548, 13} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i199} true;
  goto $bb268, $bb269;
$bb268:
  assume ($i199 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 549, 17} true;
  assume {:verifier.code 1} true;
  call $i200 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i200);
  call {:cexpr "ret"} boogie_si_record_i32($i200);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 550, 19} true;
  assume {:verifier.code 0} true;
  $i201 := $sle.i32($i200, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 550, 15} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i201} true;
  goto $bb271, $bb272;
$bb269:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 548, 13} true;
  assume {:verifier.code 0} true;
  assume !(($i199 == 1));
  goto $bb270;
$bb270:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 554, 16} true;
  assume {:verifier.code 0} true;
  $i202 := $ne.i32($i36, 0);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 554, 13} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i202} true;
  goto $bb273, $bb274;
$bb271:
  assume ($i201 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 551, 13} true;
  assume {:verifier.code 0} true;
  $i92 := $i200;
  goto $bb123;
$bb272:
  assume !(($i201 == 1));
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 553, 9} true;
  assume {:verifier.code 0} true;
  goto $bb270;
$bb273:
  assume ($i202 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 555, 24} true;
  assume {:verifier.code 0} true;
  $i203 := $ne.i32($i113, $i50);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 555, 15} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i203} true;
  goto $bb276, $bb277;
$bb274:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 554, 13} true;
  assume {:verifier.code 0} true;
  assume !(($i202 == 1));
  goto $bb275;
$bb275:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 561, 7} true;
  assume {:verifier.code 0} true;
  goto $bb266;
$bb276:
  assume ($i203 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 559, 11} true;
  assume {:verifier.code 0} true;
  goto $bb278;
$bb277:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 555, 15} true;
  assume {:verifier.code 0} true;
  assume !(($i203 == 1));
  goto $bb278;
$bb278:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 560, 9} true;
  assume {:verifier.code 0} true;
  goto $bb275;
$bb279:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 566, 3} true;
  assume {:verifier.code 0} true;
  $i92 := $u0;
  goto $bb123;
$bb280:
  assume ($i204 == 1);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 572, 3} true;
  assume {:verifier.code 0} true;
  goto $bb282;
$bb281:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 570, 7} true;
  assume {:verifier.code 0} true;
  assume !(($i204 == 1));
  goto $bb282;
$bb282:
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 573, 3} true;
  assume {:verifier.code 0} true;
  $r := $i92;
  $exn := false;
  return;
}
const abort: ref;
axiom (abort == $sub.ref(0, 8259));
procedure abort();
const main: ref;
axiom (main == $sub.ref(0, 9291));
procedure main()
  returns ($r: i32)
{
  var $i0: i32;
$bb0:
  call $initialize();
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 584, 3} true;
  assume {:verifier.code 0} true;
  call {:cexpr "smack:entry:main"} boogie_si_record_ref(main);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 584, 3} true;
  assume {:verifier.code 0} true;
  call $i0 := ssl3_connect(12292);
  assume {:sourceloc "./output/s3_clnt_3.cil-2_tmp.c", 586, 3} true;
  assume {:verifier.code 0} true;
  $r := 0;
  $exn := false;
  return;
}
const __VERIFIER_assume: ref;
axiom (__VERIFIER_assume == $sub.ref(0, 10323));
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
axiom (__SMACK_code == $sub.ref(0, 11355));
procedure __SMACK_code.ref.i32($p0: ref, p.1: i32);
procedure __SMACK_code.ref($p0: ref);
const __SMACK_dummy: ref;
axiom (__SMACK_dummy == $sub.ref(0, 12387));
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
axiom (__SMACK_check_overflow == $sub.ref(0, 13419));
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
axiom (__SMACK_nondet_char == $sub.ref(0, 14451));
procedure __SMACK_nondet_char()
  returns ($r: i8);
const __SMACK_nondet_signed_char: ref;
axiom (__SMACK_nondet_signed_char == $sub.ref(0, 15483));
procedure __SMACK_nondet_signed_char()
  returns ($r: i8);
const __SMACK_nondet_unsigned_char: ref;
axiom (__SMACK_nondet_unsigned_char == $sub.ref(0, 16515));
procedure __SMACK_nondet_unsigned_char()
  returns ($r: i8);
const __SMACK_nondet_short: ref;
axiom (__SMACK_nondet_short == $sub.ref(0, 17547));
procedure __SMACK_nondet_short()
  returns ($r: i16);
const __SMACK_nondet_signed_short: ref;
axiom (__SMACK_nondet_signed_short == $sub.ref(0, 18579));
procedure __SMACK_nondet_signed_short()
  returns ($r: i16);
const __SMACK_nondet_signed_short_int: ref;
axiom (__SMACK_nondet_signed_short_int == $sub.ref(0, 19611));
procedure __SMACK_nondet_signed_short_int()
  returns ($r: i16);
const __SMACK_nondet_unsigned_short: ref;
axiom (__SMACK_nondet_unsigned_short == $sub.ref(0, 20643));
procedure __SMACK_nondet_unsigned_short()
  returns ($r: i16);
const __SMACK_nondet_unsigned_short_int: ref;
axiom (__SMACK_nondet_unsigned_short_int == $sub.ref(0, 21675));
procedure __SMACK_nondet_unsigned_short_int()
  returns ($r: i16);
const __VERIFIER_nondet_int: ref;
axiom (__VERIFIER_nondet_int == $sub.ref(0, 22707));
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
axiom (__SMACK_nondet_int == $sub.ref(0, 23739));
procedure __SMACK_nondet_int()
  returns ($r: i32);
const __SMACK_nondet_signed_int: ref;
axiom (__SMACK_nondet_signed_int == $sub.ref(0, 24771));
procedure __SMACK_nondet_signed_int()
  returns ($r: i32);
const __SMACK_nondet_unsigned: ref;
axiom (__SMACK_nondet_unsigned == $sub.ref(0, 25803));
procedure __SMACK_nondet_unsigned()
  returns ($r: i32);
const __SMACK_nondet_unsigned_int: ref;
axiom (__SMACK_nondet_unsigned_int == $sub.ref(0, 26835));
procedure __SMACK_nondet_unsigned_int()
  returns ($r: i32);
const __VERIFIER_nondet_long: ref;
axiom (__VERIFIER_nondet_long == $sub.ref(0, 27867));
procedure __VERIFIER_nondet_long()
  returns ($r: i64)
{
  var $i0: i64;
  var $i1: i1;
  var $i3: i1;
  var $i2: i1;
  var $i4: i32;
$bb0:
  assume {:sourceloc "./lib/smack.c", 145, 12} true;
  assume {:verifier.code 1} true;
  assume {:sourceloc "./lib/smack.c", 145, 12} true;
  assume {:verifier.code 1} true;
  call $i0 := __SMACK_nondet_long();
  call {:cexpr "smack:ext:__SMACK_nondet_long"} boogie_si_record_i64($i0);
  call {:cexpr "x"} boogie_si_record_i64($i0);
  assume {:sourceloc "./lib/smack.c", 146, 23} true;
  assume {:verifier.code 0} true;
  $i1 := $sge.i64($i0, $sub.i64(0, 9223372036854775808));
  assume {:sourceloc "./lib/smack.c", 146, 35} true;
  assume {:verifier.code 0} true;
  $i2 := 0;
  assume {:branchcond $i1} true;
  goto $bb1, $bb2;
$bb1:
  assume ($i1 == 1);
  assume {:sourceloc "./lib/smack.c", 146, 40} true;
  assume {:verifier.code 1} true;
  $i3 := $sle.i64($i0, 9223372036854775807);
  assume {:verifier.code 0} true;
  $i2 := $i3;
  goto $bb3;
$bb2:
  assume {:sourceloc "./lib/smack.c", 146, 35} true;
  assume {:verifier.code 0} true;
  assume !(($i1 == 1));
  goto $bb3;
$bb3:
  assume {:sourceloc "./lib/smack.c", 0, 0} true;
  assume {:verifier.code 1} true;
  assume {:sourceloc "./lib/smack.c", 146, 35} true;
  assume {:verifier.code 1} true;
  $i4 := $zext.i1.i32($i2);
  assume {:sourceloc "./lib/smack.c", 146, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assume($i4);
  assume {:sourceloc "./lib/smack.c", 147, 3} true;
  assume {:verifier.code 0} true;
  $r := $i0;
  $exn := false;
  return;
}
const __SMACK_nondet_long: ref;
axiom (__SMACK_nondet_long == $sub.ref(0, 28899));
procedure __SMACK_nondet_long()
  returns ($r: i64);
const __SMACK_nondet_long_int: ref;
axiom (__SMACK_nondet_long_int == $sub.ref(0, 29931));
procedure __SMACK_nondet_long_int()
  returns ($r: i64);
const __SMACK_nondet_signed_long: ref;
axiom (__SMACK_nondet_signed_long == $sub.ref(0, 30963));
procedure __SMACK_nondet_signed_long()
  returns ($r: i64);
const __SMACK_nondet_signed_long_int: ref;
axiom (__SMACK_nondet_signed_long_int == $sub.ref(0, 31995));
procedure __SMACK_nondet_signed_long_int()
  returns ($r: i64);
const __VERIFIER_nondet_unsigned_long: ref;
axiom (__VERIFIER_nondet_unsigned_long == $sub.ref(0, 33027));
procedure __VERIFIER_nondet_unsigned_long()
  returns ($r: i64)
{
  var $i0: i64;
  var $i1: i64;
  var $i2: i64;
  var $i3: i1;
  var $i5: i1;
  var $i6: i1;
  var $i4: i1;
  var $i7: i32;
  var $i8: i1;
  var $i10: i1;
  var $i9: i1;
  var $i11: i32;
$bb0:
  assume {:sourceloc "./lib/smack.c", 169, 21} true;
  assume {:verifier.code 1} true;
  assume {:sourceloc "./lib/smack.c", 169, 21} true;
  assume {:verifier.code 1} true;
  call $i0 := __SMACK_nondet_unsigned_long();
  call {:cexpr "smack:ext:__SMACK_nondet_unsigned_long"} boogie_si_record_i64($i0);
  call {:cexpr "x"} boogie_si_record_i64($i0);
  assume {:sourceloc "./lib/smack.c", 170, 23} true;
  assume {:verifier.code 1} true;
  call $i1 := __SMACK_nondet_unsigned_long();
  call {:cexpr "smack:ext:__SMACK_nondet_unsigned_long"} boogie_si_record_i64($i1);
  call {:cexpr "min"} boogie_si_record_i64($i1);
  assume {:sourceloc "./lib/smack.c", 171, 23} true;
  assume {:verifier.code 1} true;
  call $i2 := __SMACK_nondet_unsigned_long();
  call {:cexpr "smack:ext:__SMACK_nondet_unsigned_long"} boogie_si_record_i64($i2);
  call {:cexpr "max"} boogie_si_record_i64($i2);
  assume {:sourceloc "./lib/smack.c", 172, 25} true;
  assume {:verifier.code 0} true;
  $i3 := $eq.i64($i1, 0);
  assume {:sourceloc "./lib/smack.c", 172, 30} true;
  assume {:verifier.code 0} true;
  $i4 := 0;
  assume {:branchcond $i3} true;
  goto $bb1, $bb2;
$bb1:
  assume ($i3 == 1);
  assume {:sourceloc "./lib/smack.c", 172, 37} true;
  assume {:verifier.code 0} true;
  $i5 := $uge.i64($i2, 18446744073709551615);
  assume {:sourceloc "./lib/smack.c", 172, 50} true;
  assume {:verifier.code 0} true;
  $i4 := 0;
  assume {:branchcond $i5} true;
  goto $bb4, $bb5;
$bb2:
  assume {:sourceloc "./lib/smack.c", 172, 30} true;
  assume {:verifier.code 0} true;
  assume !(($i3 == 1));
  goto $bb3;
$bb3:
  assume {:sourceloc "./lib/smack.c", 0, 0} true;
  assume {:verifier.code 1} true;
  assume {:sourceloc "./lib/smack.c", 172, 50} true;
  assume {:verifier.code 1} true;
  $i7 := $zext.i1.i32($i4);
  assume {:sourceloc "./lib/smack.c", 172, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assume($i7);
  assume {:sourceloc "./lib/smack.c", 173, 23} true;
  assume {:verifier.code 0} true;
  $i8 := $uge.i64($i0, $i1);
  assume {:sourceloc "./lib/smack.c", 173, 30} true;
  assume {:verifier.code 0} true;
  $i9 := 0;
  assume {:branchcond $i8} true;
  goto $bb6, $bb7;
$bb4:
  assume ($i5 == 1);
  assume {:sourceloc "./lib/smack.c", 172, 57} true;
  assume {:verifier.code 1} true;
  $i6 := $ule.i64($i2, 18446744073709551615);
  assume {:verifier.code 0} true;
  $i4 := $i6;
  goto $bb3;
$bb5:
  assume {:sourceloc "./lib/smack.c", 172, 50} true;
  assume {:verifier.code 0} true;
  assume !(($i5 == 1));
  goto $bb3;
$bb6:
  assume ($i8 == 1);
  assume {:sourceloc "./lib/smack.c", 173, 35} true;
  assume {:verifier.code 1} true;
  $i10 := $ule.i64($i0, $i2);
  assume {:verifier.code 0} true;
  $i9 := $i10;
  goto $bb8;
$bb7:
  assume {:sourceloc "./lib/smack.c", 173, 30} true;
  assume {:verifier.code 0} true;
  assume !(($i8 == 1));
  goto $bb8;
$bb8:
  assume {:sourceloc "./lib/smack.c", 0, 0} true;
  assume {:verifier.code 1} true;
  assume {:sourceloc "./lib/smack.c", 173, 30} true;
  assume {:verifier.code 1} true;
  $i11 := $zext.i1.i32($i9);
  assume {:sourceloc "./lib/smack.c", 173, 3} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assume($i11);
  assume {:sourceloc "./lib/smack.c", 174, 3} true;
  assume {:verifier.code 0} true;
  $r := $i0;
  $exn := false;
  return;
}
const __SMACK_nondet_unsigned_long: ref;
axiom (__SMACK_nondet_unsigned_long == $sub.ref(0, 34059));
procedure __SMACK_nondet_unsigned_long()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_int: ref;
axiom (__SMACK_nondet_unsigned_long_int == $sub.ref(0, 35091));
procedure __SMACK_nondet_unsigned_long_int()
  returns ($r: i64);
const __SMACK_nondet_long_long: ref;
axiom (__SMACK_nondet_long_long == $sub.ref(0, 36123));
procedure __SMACK_nondet_long_long()
  returns ($r: i64);
const __SMACK_nondet_long_long_int: ref;
axiom (__SMACK_nondet_long_long_int == $sub.ref(0, 37155));
procedure __SMACK_nondet_long_long_int()
  returns ($r: i64);
const __SMACK_nondet_signed_long_long: ref;
axiom (__SMACK_nondet_signed_long_long == $sub.ref(0, 38187));
procedure __SMACK_nondet_signed_long_long()
  returns ($r: i64);
const __SMACK_nondet_signed_long_long_int: ref;
axiom (__SMACK_nondet_signed_long_long_int == $sub.ref(0, 39219));
procedure __SMACK_nondet_signed_long_long_int()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_long: ref;
axiom (__SMACK_nondet_unsigned_long_long == $sub.ref(0, 40251));
procedure __SMACK_nondet_unsigned_long_long()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_long_int: ref;
axiom (__SMACK_nondet_unsigned_long_long_int == $sub.ref(0, 41283));
procedure __SMACK_nondet_unsigned_long_long_int()
  returns ($r: i64);
const __VERIFIER_nondet_ulong: ref;
axiom (__VERIFIER_nondet_ulong == $sub.ref(0, 42315));
procedure __VERIFIER_nondet_ulong()
  returns ($r: i64)
{
  var $i0: i64;
$bb0:
  assume {:sourceloc "./lib/smack.c", 252, 21} true;
  assume {:verifier.code 1} true;
  assume {:sourceloc "./lib/smack.c", 252, 21} true;
  assume {:verifier.code 1} true;
  call $i0 := __VERIFIER_nondet_unsigned_long();
  call {:cexpr "smack:ext:__VERIFIER_nondet_unsigned_long"} boogie_si_record_i64($i0);
  call {:cexpr "x"} boogie_si_record_i64($i0);
  assume {:sourceloc "./lib/smack.c", 253, 3} true;
  assume {:verifier.code 0} true;
  $r := $i0;
  $exn := false;
  return;
}
const __SMACK_decls: ref;
axiom (__SMACK_decls == $sub.ref(0, 43347));
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
axiom (__SMACK_top_decl == $sub.ref(0, 44379));
procedure __SMACK_top_decl.ref($p0: ref);
const __SMACK_init_func_memory_model: ref;
axiom (__SMACK_init_func_memory_model == $sub.ref(0, 45411));
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
axiom (llvm.dbg.value == $sub.ref(0, 46443));
procedure llvm.dbg.value($p0: ref, $p1: ref, $p2: ref);
const __SMACK_static_init: ref;
axiom (__SMACK_static_init == $sub.ref(0, 47475));
procedure __SMACK_static_init()
{
$bb0:
  $M.0 := .str.1.7;
  $M.1 := 0;
  call {:cexpr "errno_global"} boogie_si_record_i32(0);
  $exn := false;
  return;
}
const $u0: i32;
procedure boogie_si_record_i32(x: i32);
procedure boogie_si_record_i64(x: i64);
procedure boogie_si_record_ref(x: ref);
procedure $initialize()
{
  call __SMACK_static_init();
  call __SMACK_init_func_memory_model();
  return;
}
