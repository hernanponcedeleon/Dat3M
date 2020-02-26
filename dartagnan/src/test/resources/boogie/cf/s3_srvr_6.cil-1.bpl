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
axiom ($GLOBALS_BOTTOM == $sub.ref(0, 45411));
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
const {:count 3} .str.1.5: ref;
axiom (.str.1.5 == $sub.ref(0, 3097));
const {:count 14} .str.14: ref;
axiom (.str.14 == $sub.ref(0, 4135));
const errno_global: ref;
axiom (errno_global == $sub.ref(0, 5163));
const reach_error: ref;
axiom (reach_error == $sub.ref(0, 6195));
procedure reach_error()
{
$bb0:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 2, 44} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 2, 44} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const ssl3_accept: ref;
axiom (ssl3_accept == $sub.ref(0, 7227));
procedure ssl3_accept($i0: i32)
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
  var $i19: i64;
  var $i20: i32;
  var $i21: i32;
  var $i22: i32;
  var $i23: i32;
  var $i24: i32;
  var $i25: i32;
  var $i26: i64;
  var $i27: i32;
  var $i28: i32;
  var $i29: i32;
  var $i30: i1;
  var $i32: i1;
  var $i33: i32;
  var $i34: i1;
  var $i31: i32;
  var $i35: i32;
  var $i36: i1;
  var $i37: i32;
  var $i38: i1;
  var $i39: i1;
  var $i41: i32;
  var $i42: i32;
  var $i43: i32;
  var $i44: i32;
  var $i45: i64;
  var $i46: i32;
  var $i47: i32;
  var $i48: i32;
  var $i49: i1;
  var $i50: i1;
  var $i51: i1;
  var $i52: i1;
  var $i53: i1;
  var $i54: i1;
  var $i55: i1;
  var $i56: i1;
  var $i57: i1;
  var $i58: i1;
  var $i59: i1;
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
  var $i85: i32;
  var $i86: i1;
  var $i87: i1;
  var $i89: i32;
  var $i90: i1;
  var $i92: i1;
  var $i88: i32;
  var $i93: i1;
  var $i94: i1;
  var $i95: i1;
  var $i96: i32;
  var $i100: i32;
  var $i97: i32;
  var $i98: i32;
  var $i99: i32;
  var $i110: i32;
  var $i111: i1;
  var $i112: i32;
  var $i113: i1;
  var $i114: i32;
  var $i115: i1;
  var $i116: i32;
  var $i117: i1;
  var $i118: i32;
  var $i119: i1;
  var $i120: i1;
  var $i121: i32;
  var $i122: i64;
  var $i123: i64;
  var $i124: i1;
  var $i127: i32;
  var $i128: i1;
  var $i129: i32;
  var $i130: i1;
  var $i125: i32;
  var $i126: i32;
  var $i131: i64;
  var $i132: i64;
  var $i133: i64;
  var $i134: i1;
  var $i135: i32;
  var $i136: i1;
  var $i137: i64;
  var $i138: i1;
  var $i139: i64;
  var $i140: i1;
  var $i141: i1;
  var $i142: i64;
  var $i143: i64;
  var $i144: i1;
  var $i145: i64;
  var $i146: i64;
  var $i147: i1;
  var $i148: i32;
  var $i149: i32;
  var $i150: i1;
  var $i151: i32;
  var $i152: i1;
  var $i153: i32;
  var $i154: i1;
  var $i155: i32;
  var $i156: i32;
  var $i157: i32;
  var $i158: i32;
  var $i159: i32;
  var $i160: i32;
  var $i161: i32;
  var $i162: i1;
  var $i163: i1;
  var $i164: i32;
  var $i165: i1;
  var $i170: i64;
  var $i171: i64;
  var $i172: i1;
  var $i173: i32;
  var $i174: i1;
  var $i179: i32;
  var $i180: i1;
  var $i181: i32;
  var $i182: i1;
  var $i175: i32;
  var $i176: i32;
  var $i177: i32;
  var $i178: i32;
  var $i166: i32;
  var $i167: i32;
  var $i168: i32;
  var $i169: i32;
  var $i183: i32;
  var $i184: i32;
  var $i185: i32;
  var $i186: i32;
  var $i187: i32;
  var $i188: i1;
  var $i189: i1;
  var $i191: i1;
  var $i190: i64;
  var $i192: i32;
  var $i193: i1;
  var $i194: i32;
  var $i195: i1;
  var $i196: i1;
  var $i199: i32;
  var $i200: i1;
  var $i201: i32;
  var $i202: i1;
  var $i197: i32;
  var $i198: i32;
  var $i203: i32;
  var $i204: i1;
  var $i205: i32;
  var $i206: i1;
  var $i207: i32;
  var $i208: i1;
  var $i209: i32;
  var $i210: i1;
  var $i211: i32;
  var $i212: i1;
  var $i214: i1;
  var $i216: i1;
  var $i218: i1;
  var $i220: i1;
  var $i219: i32;
  var $i217: i32;
  var $i215: i32;
  var $i213: i32;
  var $i221: i1;
  var $i222: i1;
  var $i223: i32;
  var $i224: i1;
  var $i225: i32;
  var $i226: i1;
  var $i228: i1;
  var $i230: i1;
  var $i232: i1;
  var $i233: i32;
  var $i231: i32;
  var $i229: i32;
  var $i227: i32;
  var $i234: i1;
  var $i235: i1;
  var $i236: i32;
  var $i237: i1;
  var $i239: i1;
  var $i241: i1;
  var $i243: i1;
  var $i244: i32;
  var $i242: i32;
  var $i240: i32;
  var $i238: i32;
  var $i245: i1;
  var $i246: i1;
  var $i247: i32;
  var $i248: i1;
  var $i249: i1;
  var $i101: i32;
  var $i102: i32;
  var $i103: i32;
  var $i104: i32;
  var $i105: i64;
  var $i106: i32;
  var $i107: i32;
  var $i108: i32;
  var $i109: i32;
  var $i250: i1;
  var $i251: i1;
  var $i252: i1;
  var $i253: i32;
  var $i254: i1;
  var $i255: i1;
  var $i256: i1;
  var $i91: i32;
  var $i257: i1;
  var $i40: i32;
$bb0:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 12, 26} true;
  assume {:verifier.code 1} true;
  call {:cexpr "ssl3_accept:arg:initial_state"} boogie_si_record_i32($i0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 12, 26} true;
  assume {:verifier.code 1} true;
  call $i1 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i1);
  call {:cexpr "s__info_callback"} boogie_si_record_i32($i1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 13, 25} true;
  assume {:verifier.code 1} true;
  call $i2 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i2);
  call {:cexpr "s__in_handshake"} boogie_si_record_i32($i2);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 17, 20} true;
  assume {:verifier.code 1} true;
  call $i3 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i3);
  call {:cexpr "s__version"} boogie_si_record_i32($i3);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 20, 16} true;
  assume {:verifier.code 1} true;
  call $i4 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i4);
  call {:cexpr "s__hit"} boogie_si_record_i32($i4);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 23, 18} true;
  assume {:verifier.code 1} true;
  call $i5 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i5);
  call {:cexpr "s__debug"} boogie_si_record_i32($i5);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 25, 17} true;
  assume {:verifier.code 1} true;
  call $i6 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i6);
  call {:cexpr "s__cert"} boogie_si_record_i32($i6);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 26, 20} true;
  assume {:verifier.code 1} true;
  call $i7 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i7);
  call {:cexpr "s__options"} boogie_si_record_i32($i7);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 27, 24} true;
  assume {:verifier.code 1} true;
  call $i8 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i8);
  call {:cexpr "s__verify_mode"} boogie_si_record_i32($i8);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 28, 26} true;
  assume {:verifier.code 1} true;
  call $i9 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i9);
  call {:cexpr "s__session__peer"} boogie_si_record_i32($i9);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 29, 41} true;
  assume {:verifier.code 1} true;
  call $i10 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i10);
  call {:cexpr "s__cert__pkeys__AT0__privatekey"} boogie_si_record_i32($i10);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 30, 31} true;
  assume {:verifier.code 1} true;
  call $i11 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i11);
  call {:cexpr "s__ctx__info_callback"} boogie_si_record_i32($i11);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 31, 48} true;
  assume {:verifier.code 1} true;
  call $i12 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i12);
  call {:cexpr "s__ctx__stats__sess_accept_renegotiate"} boogie_si_record_i32($i12);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 32, 36} true;
  assume {:verifier.code 1} true;
  call $i13 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i13);
  call {:cexpr "s__ctx__stats__sess_accept"} boogie_si_record_i32($i13);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 33, 41} true;
  assume {:verifier.code 1} true;
  call $i14 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i14);
  call {:cexpr "s__ctx__stats__sess_accept_good"} boogie_si_record_i32($i14);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 35, 35} true;
  assume {:verifier.code 1} true;
  call $i15 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i15);
  call {:cexpr "s__s3__tmp__reuse_message"} boogie_si_record_i32($i15);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 37, 32} true;
  assume {:verifier.code 1} true;
  call $i16 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i16);
  call {:cexpr "s__s3__tmp__new_cipher"} boogie_si_record_i32($i16);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 38, 44} true;
  assume {:verifier.code 1} true;
  call $i17 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i17);
  call {:cexpr "s__s3__tmp__new_cipher__algorithms"} boogie_si_record_i32($i17);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 40, 47} true;
  assume {:verifier.code 1} true;
  call $i18 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i18);
  call {:cexpr "s__s3__tmp__new_cipher__algo_strength"} boogie_si_record_i32($i18);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 47, 15} true;
  assume {:verifier.code 1} true;
  call $i19 := __VERIFIER_nondet_long();
  call {:cexpr "smack:ext:__VERIFIER_nondet_long"} boogie_si_record_i64($i19);
  call {:cexpr "num1"} boogie_si_record_i64($i19);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 53, 17} true;
  assume {:verifier.code 1} true;
  call $i20 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i20);
  call {:cexpr "tmp___1"} boogie_si_record_i32($i20);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 54, 17} true;
  assume {:verifier.code 1} true;
  call $i21 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i21);
  call {:cexpr "tmp___2"} boogie_si_record_i32($i21);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 55, 17} true;
  assume {:verifier.code 1} true;
  call $i22 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i22);
  call {:cexpr "tmp___3"} boogie_si_record_i32($i22);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 56, 17} true;
  assume {:verifier.code 1} true;
  call $i23 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i23);
  call {:cexpr "tmp___4"} boogie_si_record_i32($i23);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 57, 17} true;
  assume {:verifier.code 1} true;
  call $i24 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i24);
  call {:cexpr "tmp___5"} boogie_si_record_i32($i24);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 58, 17} true;
  assume {:verifier.code 1} true;
  call $i25 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i25);
  call {:cexpr "tmp___6"} boogie_si_record_i32($i25);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 60, 18} true;
  assume {:verifier.code 1} true;
  call $i26 := __VERIFIER_nondet_long();
  call {:cexpr "smack:ext:__VERIFIER_nondet_long"} boogie_si_record_i64($i26);
  call {:cexpr "tmp___8"} boogie_si_record_i64($i26);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 61, 17} true;
  assume {:verifier.code 1} true;
  call $i27 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i27);
  call {:cexpr "tmp___9"} boogie_si_record_i32($i27);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 62, 18} true;
  assume {:verifier.code 1} true;
  call $i28 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i28);
  call {:cexpr "tmp___10"} boogie_si_record_i32($i28);
  call {:cexpr "ssl3_accept:arg:s__state"} boogie_si_record_i32($i0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 76, 9} true;
  assume {:verifier.code 1} true;
  call $i29 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i29);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 82, 24} true;
  assume {:verifier.code 0} true;
  $i30 := $ne.i32($i1, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 82, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i30} true;
  goto $bb1, $bb2;
$bb1:
  assume ($i30 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 84, 3} true;
  assume {:verifier.code 0} true;
  $i31 := $i1;
  goto $bb3;
$bb2:
  assume !(($i30 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 85, 31} true;
  assume {:verifier.code 0} true;
  $i32 := $ne.i32($i11, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 85, 9} true;
  assume {:verifier.code 0} true;
  $i33 := 0;
  assume {:branchcond $i32} true;
  goto $bb4, $bb5;
$bb3:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 93, 15} true;
  assume {:verifier.code 0} true;
  $i35 := $add.i32($i20, 12288);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 93, 15} true;
  assume {:verifier.code 0} true;
  $i36 := $ne.i32($i35, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 93, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i36} true;
  goto $bb10, $bb11;
$bb4:
  assume ($i32 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 87, 5} true;
  assume {:verifier.code 0} true;
  $i33 := $i11;
  goto $bb6;
$bb5:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 85, 9} true;
  assume {:verifier.code 0} true;
  assume !(($i32 == 1));
  goto $bb6;
$bb6:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 88, 12} true;
  assume {:verifier.code 0} true;
  $i34 := $ne.i32($i33, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 88, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i34} true;
  goto $bb7, $bb8;
$bb7:
  assume ($i34 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 89, 8} true;
  assume {:verifier.code 0} true;
  goto $bb9;
$bb8:
  assume !(($i34 == 1));
  assume {:verifier.code 0} true;
  $i31 := $i33;
  goto $bb3;
$bb9:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 671, 11} true;
  assume {:verifier.code 0} true;
  call reach_error();
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 671, 25} true;
  assume {:verifier.code 0} true;
  call abort();
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 671, 25} true;
  assume {:verifier.code 0} true;
  assume false;
$bb10:
  assume ($i36 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 94, 17} true;
  assume {:verifier.code 0} true;
  $i37 := $add.i32($i21, 16384);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 94, 17} true;
  assume {:verifier.code 0} true;
  $i38 := $ne.i32($i37, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 94, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i38} true;
  goto $bb13, $bb14;
$bb11:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 93, 7} true;
  assume {:verifier.code 0} true;
  assume !(($i36 == 1));
  goto $bb12;
$bb12:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 98, 15} true;
  assume {:verifier.code 0} true;
  $i39 := $eq.i32($i6, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 98, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i39} true;
  goto $bb16, $bb17;
$bb13:
  assume ($i38 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 96, 5} true;
  assume {:verifier.code 0} true;
  goto $bb15;
$bb14:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 94, 9} true;
  assume {:verifier.code 0} true;
  assume !(($i38 == 1));
  goto $bb15;
$bb15:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 97, 3} true;
  assume {:verifier.code 0} true;
  goto $bb12;
$bb16:
  assume ($i39 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 99, 5} true;
  assume {:verifier.code 0} true;
  $i40 := $sub.i32(0, 1);
  goto $bb18;
$bb17:
  assume !(($i39 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 102, 3} true;
  assume {:verifier.code 0} true;
  $i41, $i42, $i43, $i44, $i45, $i46, $i47, $i48 := $i12, $i13, $u0, 1, $i19, 0, $i0, 0;
  goto $bb19;
$bb18:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 674, 1} true;
  assume {:verifier.code 0} true;
  $r := $i40;
  $exn := false;
  return;
$bb19:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 31, 7} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 47, 8} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 81, 19} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 75, 13} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 102, 13} true;
  assume {:verifier.code 0} true;
  goto $bb20;
$bb20:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 105, 18} true;
  assume {:verifier.code 0} true;
  $i49 := $eq.i32($i47, 12292);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 105, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i49} true;
  goto $bb21, $bb22;
$bb21:
  assume ($i49 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 106, 7} true;
  assume {:verifier.code 0} true;
  goto $bb23;
$bb22:
  assume !(($i49 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 108, 20} true;
  assume {:verifier.code 0} true;
  $i50 := $eq.i32($i47, 16384);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 108, 11} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i50} true;
  goto $bb24, $bb25;
$bb23:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 213, 77} true;
  assume {:verifier.code 0} true;
  goto $bb26;
$bb24:
  assume ($i50 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 109, 9} true;
  assume {:verifier.code 0} true;
  goto $bb26;
$bb25:
  assume !(($i50 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 111, 22} true;
  assume {:verifier.code 0} true;
  $i51 := $eq.i32($i47, 8192);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 111, 13} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i51} true;
  goto $bb27, $bb28;
$bb26:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 213, 77} true;
  assume {:verifier.code 0} true;
  goto $bb29;
$bb27:
  assume ($i51 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 112, 11} true;
  assume {:verifier.code 0} true;
  goto $bb29;
$bb28:
  assume !(($i51 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 114, 24} true;
  assume {:verifier.code 0} true;
  $i52 := $eq.i32($i47, 24576);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 114, 15} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i52} true;
  goto $bb30, $bb31;
$bb29:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 213, 77} true;
  assume {:verifier.code 0} true;
  goto $bb32;
$bb30:
  assume ($i52 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 115, 13} true;
  assume {:verifier.code 0} true;
  goto $bb32;
$bb31:
  assume !(($i52 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 117, 26} true;
  assume {:verifier.code 0} true;
  $i53 := $eq.i32($i47, 8195);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 117, 17} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i53} true;
  goto $bb33, $bb34;
$bb32:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 213, 77} true;
  assume {:verifier.code 0} true;
  goto $bb35;
$bb33:
  assume ($i53 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 118, 15} true;
  assume {:verifier.code 0} true;
  goto $bb35;
$bb34:
  assume !(($i53 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 120, 28} true;
  assume {:verifier.code 0} true;
  $i54 := $eq.i32($i47, 8480);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 120, 19} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i54} true;
  goto $bb36, $bb37;
$bb35:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 219, 84} true;
  assume {:verifier.code 0} true;
  $i84 := $ne.i32($i31, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 219, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i84} true;
  goto $bb130, $bb131;
$bb36:
  assume ($i54 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 121, 17} true;
  assume {:verifier.code 0} true;
  goto $bb38;
$bb37:
  assume !(($i54 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 123, 30} true;
  assume {:verifier.code 0} true;
  $i55 := $eq.i32($i47, 8481);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 123, 21} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i55} true;
  goto $bb39, $bb40;
$bb38:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 257, 77} true;
  assume {:verifier.code 0} true;
  goto $bb41;
$bb39:
  assume ($i55 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 124, 19} true;
  assume {:verifier.code 0} true;
  goto $bb41;
$bb40:
  assume !(($i55 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 126, 32} true;
  assume {:verifier.code 0} true;
  $i56 := $eq.i32($i47, 8482);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 126, 23} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i56} true;
  goto $bb42, $bb43;
$bb41:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 261, 83} true;
  assume {:verifier.code 1} true;
  call $i110 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i110);
  call {:cexpr "ret"} boogie_si_record_i32($i110);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 262, 85} true;
  assume {:verifier.code 0} true;
  $i111 := $sle.i32($i110, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 262, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i111} true;
  goto $bb151, $bb152;
$bb42:
  assume ($i56 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 127, 21} true;
  assume {:verifier.code 0} true;
  goto $bb44;
$bb43:
  assume !(($i56 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 129, 34} true;
  assume {:verifier.code 0} true;
  $i57 := $eq.i32($i47, 8464);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 129, 25} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i57} true;
  goto $bb45, $bb46;
$bb44:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 271, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i41, $i42, $i43, $i44, $i45, 0, $i46, 3, $i48;
  goto $bb150;
$bb45:
  assume ($i57 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 130, 23} true;
  assume {:verifier.code 0} true;
  goto $bb47;
$bb46:
  assume !(($i57 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 132, 36} true;
  assume {:verifier.code 0} true;
  $i58 := $eq.i32($i47, 8465);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 132, 27} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i58} true;
  goto $bb48, $bb49;
$bb47:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 271, 77} true;
  assume {:verifier.code 0} true;
  goto $bb50;
$bb48:
  assume ($i58 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 133, 25} true;
  assume {:verifier.code 0} true;
  goto $bb50;
$bb49:
  assume !(($i58 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 135, 38} true;
  assume {:verifier.code 0} true;
  $i59 := $eq.i32($i47, 8466);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 135, 29} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i59} true;
  goto $bb51, $bb52;
$bb50:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 271, 77} true;
  assume {:verifier.code 0} true;
  goto $bb53;
$bb51:
  assume ($i59 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 136, 27} true;
  assume {:verifier.code 0} true;
  goto $bb53;
$bb52:
  assume !(($i59 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 138, 40} true;
  assume {:verifier.code 0} true;
  $i60 := $eq.i32($i47, 8496);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 138, 31} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i60} true;
  goto $bb54, $bb55;
$bb53:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 276, 83} true;
  assume {:verifier.code 1} true;
  call $i112 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i112);
  call {:cexpr "ret"} boogie_si_record_i32($i112);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 277, 91} true;
  assume {:verifier.code 0} true;
  $i113 := $eq.i32($i48, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 277, 81} true;
  assume {:verifier.code 0} true;
  $i114 := $i48;
  assume {:branchcond $i113} true;
  goto $bb153, $bb154;
$bb54:
  assume ($i60 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 139, 29} true;
  assume {:verifier.code 0} true;
  goto $bb56;
$bb55:
  assume !(($i60 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 141, 42} true;
  assume {:verifier.code 0} true;
  $i61 := $eq.i32($i47, 8497);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 141, 33} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i61} true;
  goto $bb57, $bb58;
$bb56:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 286, 77} true;
  assume {:verifier.code 0} true;
  goto $bb59;
$bb57:
  assume ($i61 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 142, 31} true;
  assume {:verifier.code 0} true;
  goto $bb59;
$bb58:
  assume !(($i61 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 144, 44} true;
  assume {:verifier.code 0} true;
  $i62 := $eq.i32($i47, 8512);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 144, 35} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i62} true;
  goto $bb60, $bb61;
$bb59:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 289, 83} true;
  assume {:verifier.code 1} true;
  call $i116 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i116);
  call {:cexpr "ret"} boogie_si_record_i32($i116);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 290, 91} true;
  assume {:verifier.code 0} true;
  $i117 := $eq.i32($i48, 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 290, 81} true;
  assume {:verifier.code 0} true;
  $i118 := $i48;
  assume {:branchcond $i117} true;
  goto $bb158, $bb159;
$bb60:
  assume ($i62 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 145, 33} true;
  assume {:verifier.code 0} true;
  goto $bb62;
$bb61:
  assume !(($i62 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 147, 46} true;
  assume {:verifier.code 0} true;
  $i63 := $eq.i32($i47, 8513);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 147, 37} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i63} true;
  goto $bb63, $bb64;
$bb62:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 302, 77} true;
  assume {:verifier.code 0} true;
  goto $bb65;
$bb63:
  assume ($i63 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 148, 35} true;
  assume {:verifier.code 0} true;
  goto $bb65;
$bb64:
  assume !(($i63 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 150, 48} true;
  assume {:verifier.code 0} true;
  $i64 := $eq.i32($i47, 8528);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 150, 39} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i64} true;
  goto $bb66, $bb67;
$bb65:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 306, 91} true;
  assume {:verifier.code 0} true;
  $i122 := $sext.i32.i64($i17);
  call {:cexpr "__cil_tmp56"} boogie_si_record_i64($i122);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 307, 93} true;
  assume {:verifier.code 0} true;
  $i123 := $add.i64($i122, 256);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 307, 93} true;
  assume {:verifier.code 0} true;
  $i124 := $ne.i64($i123, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 307, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i124} true;
  goto $bb166, $bb167;
$bb66:
  assume ($i64 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 151, 37} true;
  assume {:verifier.code 0} true;
  goto $bb68;
$bb67:
  assume !(($i64 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 153, 50} true;
  assume {:verifier.code 0} true;
  $i65 := $eq.i32($i47, 8529);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 153, 41} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i65} true;
  goto $bb69, $bb70;
$bb68:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 321, 77} true;
  assume {:verifier.code 0} true;
  goto $bb71;
$bb69:
  assume ($i65 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 154, 39} true;
  assume {:verifier.code 0} true;
  goto $bb71;
$bb70:
  assume !(($i65 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 156, 52} true;
  assume {:verifier.code 0} true;
  $i66 := $eq.i32($i47, 8544);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 156, 43} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i66} true;
  goto $bb72, $bb73;
$bb71:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 324, 81} true;
  assume {:verifier.code 0} true;
  $i131 := $sext.i32.i64($i17);
  call {:cexpr "l"} boogie_si_record_i64($i131);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 326, 91} true;
  assume {:verifier.code 0} true;
  $i132 := $sext.i32.i64($i7);
  call {:cexpr "__cil_tmp57"} boogie_si_record_i64($i132);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 327, 93} true;
  assume {:verifier.code 0} true;
  $i133 := $add.i64($i132, 2097152);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 327, 93} true;
  assume {:verifier.code 0} true;
  $i134 := $ne.i64($i133, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 327, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i134} true;
  goto $bb174, $bb175;
$bb72:
  assume ($i66 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 157, 41} true;
  assume {:verifier.code 0} true;
  goto $bb74;
$bb73:
  assume !(($i66 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 159, 54} true;
  assume {:verifier.code 0} true;
  $i67 := $eq.i32($i47, 8545);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 159, 45} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i67} true;
  goto $bb75, $bb76;
$bb74:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 381, 77} true;
  assume {:verifier.code 0} true;
  goto $bb77;
$bb75:
  assume ($i67 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 160, 43} true;
  assume {:verifier.code 0} true;
  goto $bb77;
$bb76:
  assume !(($i67 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 162, 56} true;
  assume {:verifier.code 0} true;
  $i68 := $eq.i32($i47, 8560);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 162, 47} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i68} true;
  goto $bb78, $bb79;
$bb77:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 384, 96} true;
  assume {:verifier.code 0} true;
  $i161 := $add.i32($i8, 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 384, 96} true;
  assume {:verifier.code 0} true;
  $i162 := $ne.i32($i161, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 384, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i162} true;
  goto $bb204, $bb205;
$bb78:
  assume ($i68 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 163, 45} true;
  assume {:verifier.code 0} true;
  goto $bb80;
$bb79:
  assume !(($i68 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 165, 58} true;
  assume {:verifier.code 0} true;
  $i69 := $eq.i32($i47, 8561);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 165, 49} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i69} true;
  goto $bb81, $bb82;
$bb80:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 426, 77} true;
  assume {:verifier.code 0} true;
  goto $bb83;
$bb81:
  assume ($i69 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 166, 47} true;
  assume {:verifier.code 0} true;
  goto $bb83;
$bb82:
  assume !(($i69 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 168, 60} true;
  assume {:verifier.code 0} true;
  $i70 := $eq.i32($i47, 8448);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 168, 51} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i70} true;
  goto $bb84, $bb85;
$bb83:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 429, 83} true;
  assume {:verifier.code 1} true;
  call $i187 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i187);
  call {:cexpr "ret"} boogie_si_record_i32($i187);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 430, 85} true;
  assume {:verifier.code 0} true;
  $i188 := $sle.i32($i187, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 430, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i188} true;
  goto $bb226, $bb227;
$bb84:
  assume ($i70 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 169, 49} true;
  assume {:verifier.code 0} true;
  goto $bb86;
$bb85:
  assume !(($i70 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 171, 62} true;
  assume {:verifier.code 0} true;
  $i71 := $eq.i32($i47, 8576);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 171, 53} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i71} true;
  goto $bb87, $bb88;
$bb86:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 438, 86} true;
  assume {:verifier.code 0} true;
  $i189 := $sgt.i64($i45, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 438, 81} true;
  assume {:verifier.code 0} true;
  $i190 := $i45;
  assume {:branchcond $i189} true;
  goto $bb228, $bb229;
$bb87:
  assume ($i71 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 172, 51} true;
  assume {:verifier.code 0} true;
  goto $bb89;
$bb88:
  assume !(($i71 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 174, 64} true;
  assume {:verifier.code 0} true;
  $i72 := $eq.i32($i47, 8577);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 174, 55} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i72} true;
  goto $bb90, $bb91;
$bb89:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 448, 77} true;
  assume {:verifier.code 0} true;
  goto $bb92;
$bb90:
  assume ($i72 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 175, 53} true;
  assume {:verifier.code 0} true;
  goto $bb92;
$bb91:
  assume !(($i72 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 177, 66} true;
  assume {:verifier.code 0} true;
  $i73 := $eq.i32($i47, 8592);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 177, 57} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i73} true;
  goto $bb93, $bb94;
$bb92:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 451, 83} true;
  assume {:verifier.code 1} true;
  call $i192 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i192);
  call {:cexpr "ret"} boogie_si_record_i32($i192);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 452, 91} true;
  assume {:verifier.code 0} true;
  $i193 := $eq.i32($i48, 5);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 452, 81} true;
  assume {:verifier.code 0} true;
  $i194 := $i48;
  assume {:branchcond $i193} true;
  goto $bb233, $bb234;
$bb93:
  assume ($i73 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 178, 55} true;
  assume {:verifier.code 0} true;
  goto $bb95;
$bb94:
  assume !(($i73 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 180, 68} true;
  assume {:verifier.code 0} true;
  $i74 := $eq.i32($i47, 8593);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 180, 59} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i74} true;
  goto $bb96, $bb97;
$bb95:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 471, 77} true;
  assume {:verifier.code 0} true;
  goto $bb98;
$bb96:
  assume ($i74 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 181, 57} true;
  assume {:verifier.code 0} true;
  goto $bb98;
$bb97:
  assume !(($i74 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 183, 70} true;
  assume {:verifier.code 0} true;
  $i75 := $eq.i32($i47, 8608);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 183, 61} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i75} true;
  goto $bb99, $bb100;
$bb98:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 474, 83} true;
  assume {:verifier.code 1} true;
  call $i203 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i203);
  call {:cexpr "ret"} boogie_si_record_i32($i203);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 475, 91} true;
  assume {:verifier.code 0} true;
  $i204 := $eq.i32($i48, 7);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 475, 81} true;
  assume {:verifier.code 0} true;
  $i205 := $i48;
  assume {:branchcond $i204} true;
  goto $bb246, $bb247;
$bb99:
  assume ($i75 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 184, 59} true;
  assume {:verifier.code 0} true;
  goto $bb101;
$bb100:
  assume !(($i75 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 186, 72} true;
  assume {:verifier.code 0} true;
  $i76 := $eq.i32($i47, 8609);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 186, 63} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i76} true;
  goto $bb102, $bb103;
$bb101:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 483, 77} true;
  assume {:verifier.code 0} true;
  goto $bb104;
$bb102:
  assume ($i76 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 187, 61} true;
  assume {:verifier.code 0} true;
  goto $bb104;
$bb103:
  assume !(($i76 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 189, 74} true;
  assume {:verifier.code 0} true;
  $i77 := $eq.i32($i47, 8640);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 189, 65} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i77} true;
  goto $bb105, $bb106;
$bb104:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 486, 83} true;
  assume {:verifier.code 1} true;
  call $i207 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i207);
  call {:cexpr "ret"} boogie_si_record_i32($i207);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 487, 91} true;
  assume {:verifier.code 0} true;
  $i208 := $eq.i32($i48, 8);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 487, 81} true;
  assume {:verifier.code 0} true;
  $i209 := $i48;
  assume {:branchcond $i208} true;
  goto $bb251, $bb252;
$bb105:
  assume ($i77 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 190, 63} true;
  assume {:verifier.code 0} true;
  goto $bb107;
$bb106:
  assume !(($i77 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 192, 76} true;
  assume {:verifier.code 0} true;
  $i78 := $eq.i32($i47, 8641);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 192, 67} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i78} true;
  goto $bb108, $bb109;
$bb107:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 495, 77} true;
  assume {:verifier.code 0} true;
  goto $bb110;
$bb108:
  assume ($i78 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 193, 65} true;
  assume {:verifier.code 0} true;
  goto $bb110;
$bb109:
  assume !(($i78 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 195, 78} true;
  assume {:verifier.code 0} true;
  $i79 := $eq.i32($i47, 8656);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 195, 69} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i79} true;
  goto $bb111, $bb112;
$bb110:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 498, 83} true;
  assume {:verifier.code 1} true;
  call $i211 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i211);
  call {:cexpr "ret"} boogie_si_record_i32($i211);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 499, 91} true;
  assume {:verifier.code 0} true;
  $i212 := $eq.i32($i48, 9);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 499, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i212} true;
  goto $bb256, $bb257;
$bb111:
  assume ($i79 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 196, 67} true;
  assume {:verifier.code 0} true;
  goto $bb113;
$bb112:
  assume !(($i79 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 198, 80} true;
  assume {:verifier.code 0} true;
  $i80 := $eq.i32($i47, 8657);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 198, 71} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i80} true;
  goto $bb114, $bb115;
$bb113:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 527, 77} true;
  assume {:verifier.code 0} true;
  goto $bb116;
$bb114:
  assume ($i80 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 199, 69} true;
  assume {:verifier.code 0} true;
  goto $bb116;
$bb115:
  assume !(($i80 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 201, 82} true;
  assume {:verifier.code 0} true;
  $i81 := $eq.i32($i47, 8672);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 201, 73} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i81} true;
  goto $bb117, $bb118;
$bb116:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 531, 83} true;
  assume {:verifier.code 0} true;
  $i224 := $ne.i32($i27, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 531, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i224} true;
  goto $bb275, $bb276;
$bb117:
  assume ($i81 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 202, 71} true;
  assume {:verifier.code 0} true;
  goto $bb119;
$bb118:
  assume !(($i81 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 204, 84} true;
  assume {:verifier.code 0} true;
  $i82 := $eq.i32($i47, 8673);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 204, 75} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i82} true;
  goto $bb120, $bb121;
$bb119:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 560, 77} true;
  assume {:verifier.code 0} true;
  goto $bb122;
$bb120:
  assume ($i82 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 205, 73} true;
  assume {:verifier.code 0} true;
  goto $bb122;
$bb121:
  assume !(($i82 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 207, 86} true;
  assume {:verifier.code 0} true;
  $i83 := $eq.i32($i47, 3);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 207, 77} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i83} true;
  goto $bb123, $bb124;
$bb122:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 563, 83} true;
  assume {:verifier.code 1} true;
  call $i236 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i236);
  call {:cexpr "ret"} boogie_si_record_i32($i236);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 564, 91} true;
  assume {:verifier.code 0} true;
  $i237 := $eq.i32($i48, 11);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 564, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i237} true;
  goto $bb293, $bb294;
$bb123:
  assume ($i83 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 208, 75} true;
  assume {:verifier.code 0} true;
  goto $bb125;
$bb124:
  assume !(($i83 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 210, 75} true;
  assume {:verifier.code 0} true;
  goto $bb126;
$bb125:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 593, 81} true;
  assume {:verifier.code 0} true;
  $i248 := $ne.i32($i46, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 593, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i248} true;
  goto $bb310, $bb311;
$bb126:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 604, 77} true;
  assume {:verifier.code 0} true;
  $i91 := $sub.i32(0, 1);
  goto $bb140;
$bb127:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 211, 79} true;
  assume {:verifier.code 0} true;
  assume {:branchcond 0} true;
  goto $bb128, $bb129;
$bb128:
  assume (0 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 211, 82} true;
  assume {:verifier.code 0} true;
  goto $bb23;
$bb129:
  assume !((0 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 605, 82} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $u0, $u0, $u0, $u0, $u1, $u0, $u0, $u0, $u0;
  goto $bb150;
$bb130:
  assume ($i84 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 221, 77} true;
  assume {:verifier.code 0} true;
  goto $bb132;
$bb131:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 219, 81} true;
  assume {:verifier.code 0} true;
  assume !(($i84 == 1));
  goto $bb132;
$bb132:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 223, 102} true;
  assume {:verifier.code 0} true;
  $i85 := $mul.i32($i3, 8);
  call {:cexpr "__cil_tmp55"} boogie_si_record_i32($i85);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 224, 93} true;
  assume {:verifier.code 0} true;
  $i86 := $ne.i32($i85, 3);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 224, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i86} true;
  goto $bb133, $bb134;
$bb133:
  assume ($i86 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 225, 79} true;
  assume {:verifier.code 0} true;
  $i40 := $sub.i32(0, 1);
  goto $bb18;
$bb134:
  assume !(($i86 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 229, 97} true;
  assume {:verifier.code 0} true;
  $i87 := $eq.i32($i44, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 229, 81} true;
  assume {:verifier.code 0} true;
  $i88 := $i44;
  assume {:branchcond $i87} true;
  goto $bb135, $bb136;
$bb135:
  assume ($i87 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 230, 85} true;
  assume {:verifier.code 1} true;
  call $i89 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i89);
  call {:cexpr "buf"} boogie_si_record_i32($i89);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 231, 87} true;
  assume {:verifier.code 0} true;
  $i90 := $eq.i32($i89, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 231, 83} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i90} true;
  goto $bb138, $bb139;
$bb136:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 229, 81} true;
  assume {:verifier.code 0} true;
  assume !(($i87 == 1));
  goto $bb137;
$bb137:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 241, 83} true;
  assume {:verifier.code 0} true;
  $i93 := $ne.i32($i23, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 241, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i93} true;
  goto $bb143, $bb144;
$bb138:
  assume ($i90 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 233, 81} true;
  assume {:verifier.code 0} true;
  $i91 := $sub.i32(0, 1);
  goto $bb140;
$bb139:
  assume !(($i90 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 235, 85} true;
  assume {:verifier.code 0} true;
  $i92 := $ne.i32($i22, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 235, 83} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i92} true;
  goto $bb141, $bb142;
$bb140:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 667, 10} true;
  assume {:verifier.code 0} true;
  $i257 := $ne.i32($i31, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 667, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i257} true;
  goto $bb370, $bb371;
$bb141:
  assume ($i92 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 240, 77} true;
  assume {:verifier.code 0} true;
  $i88 := $i89;
  goto $bb137;
$bb142:
  assume !(($i92 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 237, 81} true;
  assume {:verifier.code 0} true;
  $i91 := $sub.i32(0, 1);
  goto $bb140;
$bb143:
  assume ($i93 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 246, 90} true;
  assume {:verifier.code 0} true;
  $i94 := $ne.i32($i47, 12292);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 246, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i94} true;
  goto $bb145, $bb146;
$bb144:
  assume !(($i93 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 243, 79} true;
  assume {:verifier.code 0} true;
  $i91 := $sub.i32(0, 1);
  goto $bb140;
$bb145:
  assume ($i94 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 247, 85} true;
  assume {:verifier.code 0} true;
  $i95 := $ne.i32($i24, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 247, 83} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i95} true;
  goto $bb147, $bb148;
$bb146:
  assume !(($i94 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 254, 118} true;
  assume {:verifier.code 0} true;
  $i100 := $add.i32($i41, 1);
  call {:cexpr "s__ctx__stats__sess_accept_renegotiate"} boogie_si_record_i32($i100);
  assume {:verifier.code 0} true;
  $i97, $i98, $i99 := $i100, $i42, 8480;
  goto $bb149;
$bb147:
  assume ($i95 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 252, 106} true;
  assume {:verifier.code 0} true;
  $i96 := $add.i32($i42, 1);
  call {:cexpr "s__ctx__stats__sess_accept"} boogie_si_record_i32($i96);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 253, 77} true;
  assume {:verifier.code 0} true;
  $i97, $i98, $i99 := $i41, $i96, 8464;
  goto $bb149;
$bb148:
  assume !(($i95 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 249, 81} true;
  assume {:verifier.code 0} true;
  $i91 := $sub.i32(0, 1);
  goto $bb140;
$bb149:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 257, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i97, $i98, $i43, $i88, $i45, 0, $i46, $i99, $i48;
  goto $bb150;
$bb150:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 31, 7} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  goto $bb316;
$bb151:
  assume ($i111 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 263, 79} true;
  assume {:verifier.code 0} true;
  $i91 := $i110;
  goto $bb140;
$bb152:
  assume !(($i111 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 268, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i41, $i42, 8482, $i44, $i45, 0, $i46, 8448, $i48;
  goto $bb150;
$bb153:
  assume ($i113 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 279, 77} true;
  assume {:verifier.code 0} true;
  $i114 := 1;
  goto $bb155;
$bb154:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 277, 81} true;
  assume {:verifier.code 0} true;
  assume !(($i113 == 1));
  goto $bb155;
$bb155:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 280, 85} true;
  assume {:verifier.code 0} true;
  $i115 := $sle.i32($i112, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 280, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i115} true;
  goto $bb156, $bb157;
$bb156:
  assume ($i115 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 281, 79} true;
  assume {:verifier.code 0} true;
  $i91 := $i112;
  goto $bb140;
$bb157:
  assume !(($i115 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 286, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i41, $i42, $i43, $i44, $i45, 0, 1, 8496, $i114;
  goto $bb150;
$bb158:
  assume ($i117 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 292, 77} true;
  assume {:verifier.code 0} true;
  $i118 := 2;
  goto $bb160;
$bb159:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 290, 81} true;
  assume {:verifier.code 0} true;
  assume !(($i117 == 1));
  goto $bb160;
$bb160:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 293, 85} true;
  assume {:verifier.code 0} true;
  $i119 := $sle.i32($i116, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 293, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i119} true;
  goto $bb161, $bb162;
$bb161:
  assume ($i119 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 294, 79} true;
  assume {:verifier.code 0} true;
  $i91 := $i116;
  goto $bb140;
$bb162:
  assume !(($i119 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 296, 81} true;
  assume {:verifier.code 0} true;
  $i120 := $ne.i32($i4, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 296, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i120} true;
  goto $bb163, $bb164;
$bb163:
  assume ($i120 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 298, 77} true;
  assume {:verifier.code 0} true;
  $i121 := 8656;
  goto $bb165;
$bb164:
  assume !(($i120 == 1));
  assume {:verifier.code 0} true;
  $i121 := 8512;
  goto $bb165;
$bb165:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 302, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i41, $i42, $i43, $i44, $i45, 0, $i46, $i121, $i118;
  goto $bb150;
$bb166:
  assume ($i124 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 309, 77} true;
  assume {:verifier.code 0} true;
  $i125, $i126 := 1, $i48;
  goto $bb168;
$bb167:
  assume !(($i124 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 310, 85} true;
  assume {:verifier.code 1} true;
  call $i127 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i127);
  call {:cexpr "ret"} boogie_si_record_i32($i127);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 311, 93} true;
  assume {:verifier.code 0} true;
  $i128 := $eq.i32($i48, 2);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 311, 83} true;
  assume {:verifier.code 0} true;
  $i129 := $i48;
  assume {:branchcond $i128} true;
  goto $bb169, $bb170;
$bb168:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 321, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i41, $i42, $i43, $i44, $i45, $i125, $i46, 8528, $i126;
  goto $bb150;
$bb169:
  assume ($i128 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 313, 79} true;
  assume {:verifier.code 0} true;
  $i129 := 3;
  goto $bb171;
$bb170:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 311, 83} true;
  assume {:verifier.code 0} true;
  assume !(($i128 == 1));
  goto $bb171;
$bb171:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 314, 87} true;
  assume {:verifier.code 0} true;
  $i130 := $sle.i32($i127, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 314, 83} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i130} true;
  goto $bb172, $bb173;
$bb172:
  assume ($i130 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 315, 81} true;
  assume {:verifier.code 0} true;
  $i91 := $i127;
  goto $bb140;
$bb173:
  assume !(($i130 == 1));
  assume {:verifier.code 0} true;
  $i125, $i126 := 0, $i129;
  goto $bb168;
$bb174:
  assume ($i134 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 329, 77} true;
  assume {:verifier.code 0} true;
  $i135 := 1;
  goto $bb176;
$bb175:
  assume !(($i134 == 1));
  assume {:verifier.code 0} true;
  $i135 := 0;
  goto $bb176;
$bb176:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 333, 81} true;
  assume {:verifier.code 0} true;
  $i136 := $ne.i32($i135, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 333, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i136} true;
  goto $bb177, $bb178;
$bb177:
  assume ($i136 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 334, 79} true;
  assume {:verifier.code 0} true;
  goto $bb179;
$bb178:
  assume !(($i136 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 336, 85} true;
  assume {:verifier.code 0} true;
  $i137 := $add.i64($i131, 30);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 336, 85} true;
  assume {:verifier.code 0} true;
  $i138 := $ne.i64($i137, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 336, 83} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i138} true;
  goto $bb180, $bb181;
$bb179:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 358, 95} true;
  assume {:verifier.code 1} true;
  call $i151 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i151);
  call {:cexpr "ret"} boogie_si_record_i32($i151);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 359, 103} true;
  assume {:verifier.code 0} true;
  $i152 := $eq.i32($i48, 3);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 359, 93} true;
  assume {:verifier.code 0} true;
  $i153 := $i48;
  assume {:branchcond $i152} true;
  goto $bb193, $bb194;
$bb180:
  assume ($i138 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 337, 81} true;
  assume {:verifier.code 0} true;
  goto $bb179;
$bb181:
  assume !(($i138 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 339, 87} true;
  assume {:verifier.code 0} true;
  $i139 := $add.i64($i131, 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 339, 87} true;
  assume {:verifier.code 0} true;
  $i140 := $ne.i64($i139, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 339, 85} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i140} true;
  goto $bb182, $bb183;
$bb182:
  assume ($i140 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 340, 119} true;
  assume {:verifier.code 0} true;
  $i141 := $eq.i32($i10, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 340, 87} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i141} true;
  goto $bb184, $bb185;
$bb183:
  assume !(($i140 == 1));
  assume {:verifier.code 0} true;
  $i159, $i160 := 1, $i48;
  goto $bb201;
$bb184:
  assume ($i141 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 341, 85} true;
  assume {:verifier.code 0} true;
  goto $bb179;
$bb185:
  assume !(($i141 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 344, 99} true;
  assume {:verifier.code 0} true;
  $i142 := $sext.i32.i64($i18);
  call {:cexpr "__cil_tmp58"} boogie_si_record_i64($i142);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 345, 101} true;
  assume {:verifier.code 0} true;
  $i143 := $add.i64($i142, 2);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 345, 101} true;
  assume {:verifier.code 0} true;
  $i144 := $ne.i64($i143, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 345, 89} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i144} true;
  goto $bb186, $bb187;
$bb186:
  assume ($i144 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 347, 101} true;
  assume {:verifier.code 0} true;
  $i145 := $sext.i32.i64($i18);
  call {:cexpr "__cil_tmp59"} boogie_si_record_i64($i145);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 348, 103} true;
  assume {:verifier.code 0} true;
  $i146 := $add.i64($i145, 4);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 348, 103} true;
  assume {:verifier.code 0} true;
  $i147 := $ne.i64($i146, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 348, 91} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i147} true;
  goto $bb188, $bb189;
$bb187:
  assume !(($i144 == 1));
  assume {:verifier.code 0} true;
  $i157, $i158 := 1, $i48;
  goto $bb199;
$bb188:
  assume ($i147 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 350, 87} true;
  assume {:verifier.code 0} true;
  $i148 := 512;
  goto $bb190;
$bb189:
  assume !(($i147 == 1));
  assume {:verifier.code 0} true;
  $i148 := 1024;
  goto $bb190;
$bb190:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 355, 109} true;
  assume {:verifier.code 0} true;
  $i149 := $mul.i32($i25, 8);
  call {:cexpr "__cil_tmp60"} boogie_si_record_i32($i149);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 356, 103} true;
  assume {:verifier.code 0} true;
  $i150 := $sgt.i32($i149, $i148);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 356, 91} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i150} true;
  goto $bb191, $bb192;
$bb191:
  assume ($i150 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 356, 114} true;
  assume {:verifier.code 0} true;
  goto $bb179;
$bb192:
  assume !(($i150 == 1));
  assume {:verifier.code 0} true;
  $i155, $i156 := 1, $i48;
  goto $bb198;
$bb193:
  assume ($i152 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 361, 89} true;
  assume {:verifier.code 0} true;
  $i153 := 4;
  goto $bb195;
$bb194:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 359, 93} true;
  assume {:verifier.code 0} true;
  assume !(($i152 == 1));
  goto $bb195;
$bb195:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 362, 97} true;
  assume {:verifier.code 0} true;
  $i154 := $sle.i32($i151, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 362, 93} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i154} true;
  goto $bb196, $bb197;
$bb196:
  assume ($i154 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 363, 91} true;
  assume {:verifier.code 0} true;
  $i91 := $i151;
  goto $bb140;
$bb197:
  assume !(($i154 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 365, 87} true;
  assume {:verifier.code 0} true;
  $i155, $i156 := 0, $i153;
  goto $bb198;
$bb198:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 369, 85} true;
  assume {:verifier.code 0} true;
  $i157, $i158 := $i155, $i156;
  goto $bb199;
$bb199:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  goto $bb200;
$bb200:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 374, 81} true;
  assume {:verifier.code 0} true;
  $i159, $i160 := $i157, $i158;
  goto $bb201;
$bb201:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  goto $bb202;
$bb202:
  assume {:verifier.code 0} true;
  goto $bb203;
$bb203:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 381, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i41, $i42, $i43, $i44, $i45, $i159, $i46, 8544, $i160;
  goto $bb150;
$bb204:
  assume ($i162 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 385, 100} true;
  assume {:verifier.code 0} true;
  $i163 := $ne.i32($i9, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 385, 83} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i163} true;
  goto $bb206, $bb207;
$bb205:
  assume !(($i162 == 1));
  assume {:verifier.code 0} true;
  $i183, $i184, $i185, $i186 := $i43, 1, 8560, $i48;
  goto $bb225;
$bb206:
  assume ($i163 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 386, 100} true;
  assume {:verifier.code 0} true;
  $i164 := $add.i32($i8, 4);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 386, 100} true;
  assume {:verifier.code 0} true;
  $i165 := $ne.i32($i164, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 386, 85} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i165} true;
  goto $bb208, $bb209;
$bb207:
  assume !(($i163 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 393, 86} true;
  assume {:verifier.code 0} true;
  goto $bb211;
$bb208:
  assume ($i165 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 390, 81} true;
  assume {:verifier.code 0} true;
  goto $bb210;
$bb209:
  assume !(($i165 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 391, 83} true;
  assume {:verifier.code 0} true;
  goto $bb211;
$bb210:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 393, 79} true;
  assume {:verifier.code 0} true;
  $i166, $i167, $i168, $i169 := $i43, 1, 8560, $i48;
  goto $bb212;
$bb211:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 396, 95} true;
  assume {:verifier.code 0} true;
  $i170 := $sext.i32.i64($i17);
  call {:cexpr "__cil_tmp61"} boogie_si_record_i64($i170);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 397, 97} true;
  assume {:verifier.code 0} true;
  $i171 := $add.i64($i170, 256);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 397, 97} true;
  assume {:verifier.code 0} true;
  $i172 := $ne.i64($i171, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 397, 85} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i172} true;
  goto $bb213, $bb214;
$bb212:
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 421, 77} true;
  assume {:verifier.code 0} true;
  $i183, $i184, $i185, $i186 := $i166, $i167, $i168, $i169;
  goto $bb225;
$bb213:
  assume ($i172 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 398, 102} true;
  assume {:verifier.code 0} true;
  $i173 := $add.i32($i8, 2);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 398, 102} true;
  assume {:verifier.code 0} true;
  $i174 := $ne.i32($i173, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 398, 87} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i174} true;
  goto $bb215, $bb216;
$bb214:
  assume !(($i172 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 405, 88} true;
  assume {:verifier.code 0} true;
  goto $bb217;
$bb215:
  assume ($i174 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 399, 85} true;
  assume {:verifier.code 0} true;
  goto $bb217;
$bb216:
  assume !(($i174 == 1));
  assume {:verifier.code 0} true;
  goto $bb218;
$bb217:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 408, 89} true;
  assume {:verifier.code 1} true;
  call $i179 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i179);
  call {:cexpr "ret"} boogie_si_record_i32($i179);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 409, 97} true;
  assume {:verifier.code 0} true;
  $i180 := $eq.i32($i48, 4);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 409, 87} true;
  assume {:verifier.code 0} true;
  $i181 := $i48;
  assume {:branchcond $i180} true;
  goto $bb220, $bb221;
$bb218:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 405, 81} true;
  assume {:verifier.code 0} true;
  $i175, $i176, $i177, $i178 := $i43, 1, 8560, $i48;
  goto $bb219;
$bb219:
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  $i166, $i167, $i168, $i169 := $i175, $i176, $i177, $i178;
  goto $bb212;
$bb220:
  assume ($i180 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 411, 83} true;
  assume {:verifier.code 0} true;
  $i181 := 5;
  goto $bb222;
$bb221:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 409, 87} true;
  assume {:verifier.code 0} true;
  assume !(($i180 == 1));
  goto $bb222;
$bb222:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 412, 91} true;
  assume {:verifier.code 0} true;
  $i182 := $sle.i32($i179, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 412, 87} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i182} true;
  goto $bb223, $bb224;
$bb223:
  assume ($i182 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 413, 85} true;
  assume {:verifier.code 0} true;
  $i91 := $i179;
  goto $bb140;
$bb224:
  assume !(($i182 == 1));
  assume {:verifier.code 0} true;
  $i175, $i176, $i177, $i178 := 8576, 0, 8448, $i181;
  goto $bb219;
$bb225:
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 75, 13} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 426, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i41, $i42, $i183, $i44, $i45, $i184, $i46, $i185, $i186;
  goto $bb150;
$bb226:
  assume ($i188 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 431, 79} true;
  assume {:verifier.code 0} true;
  $i91 := $i187;
  goto $bb140;
$bb227:
  assume !(($i188 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 436, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i41, $i42, 8576, $i44, $i45, 0, $i46, 8448, $i48;
  goto $bb150;
$bb228:
  assume ($i189 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 441, 88} true;
  assume {:verifier.code 0} true;
  $i191 := $sle.i64($i26, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 441, 83} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i191} true;
  goto $bb231, $bb232;
$bb229:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 438, 81} true;
  assume {:verifier.code 0} true;
  assume !(($i189 == 1));
  goto $bb230;
$bb230:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 448, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i41, $i42, $i43, $i44, $i190, 0, $i46, $i43, $i48;
  goto $bb150;
$bb231:
  assume ($i191 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 443, 81} true;
  assume {:verifier.code 0} true;
  $i91 := $sub.i32(0, 1);
  goto $bb140;
$bb232:
  assume !(($i191 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 446, 77} true;
  assume {:verifier.code 0} true;
  $i190 := $i26;
  goto $bb230;
$bb233:
  assume ($i193 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 454, 77} true;
  assume {:verifier.code 0} true;
  $i194 := 6;
  goto $bb235;
$bb234:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 452, 81} true;
  assume {:verifier.code 0} true;
  assume !(($i193 == 1));
  goto $bb235;
$bb235:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 455, 85} true;
  assume {:verifier.code 0} true;
  $i195 := $sle.i32($i192, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 455, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i195} true;
  goto $bb236, $bb237;
$bb236:
  assume ($i195 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 456, 79} true;
  assume {:verifier.code 0} true;
  $i91 := $i192;
  goto $bb140;
$bb237:
  assume !(($i195 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 458, 85} true;
  assume {:verifier.code 0} true;
  $i196 := $eq.i32($i192, 2);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 458, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i196} true;
  goto $bb238, $bb239;
$bb238:
  assume ($i196 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 460, 77} true;
  assume {:verifier.code 0} true;
  $i197, $i198 := 8466, $i194;
  goto $bb240;
$bb239:
  assume !(($i196 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 461, 85} true;
  assume {:verifier.code 1} true;
  call $i199 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i199);
  call {:cexpr "ret"} boogie_si_record_i32($i199);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 462, 93} true;
  assume {:verifier.code 0} true;
  $i200 := $eq.i32($i194, 6);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 462, 83} true;
  assume {:verifier.code 0} true;
  $i201 := $i194;
  assume {:branchcond $i200} true;
  goto $bb241, $bb242;
$bb240:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 471, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i41, $i42, $i43, $i44, $i45, 0, $i46, $i197, $i198;
  goto $bb150;
$bb241:
  assume ($i200 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 464, 79} true;
  assume {:verifier.code 0} true;
  $i201 := 7;
  goto $bb243;
$bb242:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 462, 83} true;
  assume {:verifier.code 0} true;
  assume !(($i200 == 1));
  goto $bb243;
$bb243:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 465, 87} true;
  assume {:verifier.code 0} true;
  $i202 := $sle.i32($i199, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 465, 83} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i202} true;
  goto $bb244, $bb245;
$bb244:
  assume ($i202 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 466, 81} true;
  assume {:verifier.code 0} true;
  $i91 := $i199;
  goto $bb140;
$bb245:
  assume !(($i202 == 1));
  assume {:verifier.code 0} true;
  $i197, $i198 := 8592, $i201;
  goto $bb240;
$bb246:
  assume ($i204 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 477, 77} true;
  assume {:verifier.code 0} true;
  $i205 := 8;
  goto $bb248;
$bb247:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 475, 81} true;
  assume {:verifier.code 0} true;
  assume !(($i204 == 1));
  goto $bb248;
$bb248:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 478, 85} true;
  assume {:verifier.code 0} true;
  $i206 := $sle.i32($i203, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 478, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i206} true;
  goto $bb249, $bb250;
$bb249:
  assume ($i206 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 479, 79} true;
  assume {:verifier.code 0} true;
  $i91 := $i203;
  goto $bb140;
$bb250:
  assume !(($i206 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 483, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i41, $i42, $i43, $i44, $i45, 0, $i46, 8608, $i205;
  goto $bb150;
$bb251:
  assume ($i208 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 489, 77} true;
  assume {:verifier.code 0} true;
  $i209 := 9;
  goto $bb253;
$bb252:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 487, 81} true;
  assume {:verifier.code 0} true;
  assume !(($i208 == 1));
  goto $bb253;
$bb253:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 490, 85} true;
  assume {:verifier.code 0} true;
  $i210 := $sle.i32($i207, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 490, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i210} true;
  goto $bb254, $bb255;
$bb254:
  assume ($i210 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 491, 79} true;
  assume {:verifier.code 0} true;
  $i91 := $i207;
  goto $bb140;
$bb255:
  assume !(($i210 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 495, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i41, $i42, $i43, $i44, $i45, 0, $i46, 8640, $i209;
  goto $bb150;
$bb256:
  assume ($i212 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 501, 77} true;
  assume {:verifier.code 0} true;
  $i213 := 10;
  goto $bb258;
$bb257:
  assume !(($i212 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 502, 93} true;
  assume {:verifier.code 0} true;
  $i214 := $eq.i32($i48, 12);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 502, 83} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i214} true;
  goto $bb259, $bb260;
$bb258:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 518, 85} true;
  assume {:verifier.code 0} true;
  $i221 := $sle.i32($i211, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 518, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i221} true;
  goto $bb270, $bb271;
$bb259:
  assume ($i214 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 504, 79} true;
  assume {:verifier.code 0} true;
  $i215 := 13;
  goto $bb261;
$bb260:
  assume !(($i214 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 505, 95} true;
  assume {:verifier.code 0} true;
  $i216 := $eq.i32($i48, 15);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 505, 85} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i216} true;
  goto $bb262, $bb263;
$bb261:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  $i213 := $i215;
  goto $bb258;
$bb262:
  assume ($i216 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 507, 81} true;
  assume {:verifier.code 0} true;
  $i217 := 16;
  goto $bb264;
$bb263:
  assume !(($i216 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 508, 97} true;
  assume {:verifier.code 0} true;
  $i218 := $eq.i32($i48, 18);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 508, 87} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i218} true;
  goto $bb265, $bb266;
$bb264:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  $i215 := $i217;
  goto $bb261;
$bb265:
  assume ($i218 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 510, 83} true;
  assume {:verifier.code 0} true;
  $i219 := 19;
  goto $bb267;
$bb266:
  assume !(($i218 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 511, 99} true;
  assume {:verifier.code 0} true;
  $i220 := $eq.i32($i48, 21);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 511, 89} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i220} true;
  goto $bb268, $bb269;
$bb267:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  $i217 := $i219;
  goto $bb264;
$bb268:
  assume ($i220 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 512, 87} true;
  assume {:verifier.code 0} true;
  goto $bb9;
$bb269:
  assume !(($i220 == 1));
  assume {:verifier.code 0} true;
  $i219 := $i48;
  goto $bb267;
$bb270:
  assume ($i221 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 519, 79} true;
  assume {:verifier.code 0} true;
  $i91 := $i211;
  goto $bb140;
$bb271:
  assume !(($i221 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 521, 81} true;
  assume {:verifier.code 0} true;
  $i222 := $ne.i32($i4, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 521, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i222} true;
  goto $bb272, $bb273;
$bb272:
  assume ($i222 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 523, 77} true;
  assume {:verifier.code 0} true;
  $i223 := 3;
  goto $bb274;
$bb273:
  assume !(($i222 == 1));
  assume {:verifier.code 0} true;
  $i223 := 8656;
  goto $bb274;
$bb274:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 527, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i41, $i42, $i43, $i44, $i45, 0, $i46, $i223, $i213;
  goto $bb150;
$bb275:
  assume ($i224 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 535, 83} true;
  assume {:verifier.code 1} true;
  call $i225 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i225);
  call {:cexpr "ret"} boogie_si_record_i32($i225);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 536, 91} true;
  assume {:verifier.code 0} true;
  $i226 := $eq.i32($i48, 10);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 536, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i226} true;
  goto $bb277, $bb278;
$bb276:
  assume !(($i224 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 533, 79} true;
  assume {:verifier.code 0} true;
  $i91 := $sub.i32(0, 1);
  goto $bb140;
$bb277:
  assume ($i226 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 538, 77} true;
  assume {:verifier.code 0} true;
  $i227 := 11;
  goto $bb279;
$bb278:
  assume !(($i226 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 539, 93} true;
  assume {:verifier.code 0} true;
  $i228 := $eq.i32($i48, 13);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 539, 83} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i228} true;
  goto $bb280, $bb281;
$bb279:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 551, 85} true;
  assume {:verifier.code 0} true;
  $i234 := $sle.i32($i225, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 551, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i234} true;
  goto $bb289, $bb290;
$bb280:
  assume ($i228 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 541, 79} true;
  assume {:verifier.code 0} true;
  $i229 := 14;
  goto $bb282;
$bb281:
  assume !(($i228 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 542, 95} true;
  assume {:verifier.code 0} true;
  $i230 := $eq.i32($i48, 16);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 542, 85} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i230} true;
  goto $bb283, $bb284;
$bb282:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  $i227 := $i229;
  goto $bb279;
$bb283:
  assume ($i230 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 544, 81} true;
  assume {:verifier.code 0} true;
  $i231 := 17;
  goto $bb285;
$bb284:
  assume !(($i230 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 545, 97} true;
  assume {:verifier.code 0} true;
  $i232 := $eq.i32($i48, 19);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 545, 87} true;
  assume {:verifier.code 0} true;
  $i233 := $i48;
  assume {:branchcond $i232} true;
  goto $bb286, $bb287;
$bb285:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  $i229 := $i231;
  goto $bb282;
$bb286:
  assume ($i232 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 547, 83} true;
  assume {:verifier.code 0} true;
  $i233 := 20;
  goto $bb288;
$bb287:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 545, 87} true;
  assume {:verifier.code 0} true;
  assume !(($i232 == 1));
  goto $bb288;
$bb288:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  $i231 := $i233;
  goto $bb285;
$bb289:
  assume ($i234 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 552, 79} true;
  assume {:verifier.code 0} true;
  $i91 := $i225;
  goto $bb140;
$bb290:
  assume !(($i234 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 556, 83} true;
  assume {:verifier.code 0} true;
  $i235 := $ne.i32($i28, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 556, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i235} true;
  goto $bb291, $bb292;
$bb291:
  assume ($i235 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 560, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i41, $i42, $i43, $i44, $i45, 0, $i46, 8672, $i227;
  goto $bb150;
$bb292:
  assume !(($i235 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 558, 79} true;
  assume {:verifier.code 0} true;
  $i91 := $sub.i32(0, 1);
  goto $bb140;
$bb293:
  assume ($i237 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 566, 77} true;
  assume {:verifier.code 0} true;
  $i238 := 12;
  goto $bb295;
$bb294:
  assume !(($i237 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 567, 93} true;
  assume {:verifier.code 0} true;
  $i239 := $eq.i32($i48, 14);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 567, 83} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i239} true;
  goto $bb296, $bb297;
$bb295:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 579, 85} true;
  assume {:verifier.code 0} true;
  $i245 := $sle.i32($i236, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 579, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i245} true;
  goto $bb305, $bb306;
$bb296:
  assume ($i239 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 569, 79} true;
  assume {:verifier.code 0} true;
  $i240 := 15;
  goto $bb298;
$bb297:
  assume !(($i239 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 570, 95} true;
  assume {:verifier.code 0} true;
  $i241 := $eq.i32($i48, 17);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 570, 85} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i241} true;
  goto $bb299, $bb300;
$bb298:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  $i238 := $i240;
  goto $bb295;
$bb299:
  assume ($i241 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 572, 81} true;
  assume {:verifier.code 0} true;
  $i242 := 18;
  goto $bb301;
$bb300:
  assume !(($i241 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 573, 97} true;
  assume {:verifier.code 0} true;
  $i243 := $eq.i32($i48, 20);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 573, 87} true;
  assume {:verifier.code 0} true;
  $i244 := $i48;
  assume {:branchcond $i243} true;
  goto $bb302, $bb303;
$bb301:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  $i240 := $i242;
  goto $bb298;
$bb302:
  assume ($i243 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 575, 83} true;
  assume {:verifier.code 0} true;
  $i244 := 21;
  goto $bb304;
$bb303:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 573, 87} true;
  assume {:verifier.code 0} true;
  assume !(($i243 == 1));
  goto $bb304;
$bb304:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:verifier.code 0} true;
  $i242 := $i244;
  goto $bb301;
$bb305:
  assume ($i245 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 580, 79} true;
  assume {:verifier.code 0} true;
  $i91 := $i236;
  goto $bb140;
$bb306:
  assume !(($i245 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 583, 81} true;
  assume {:verifier.code 0} true;
  $i246 := $ne.i32($i4, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 583, 81} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i246} true;
  goto $bb307, $bb308;
$bb307:
  assume ($i246 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 585, 77} true;
  assume {:verifier.code 0} true;
  $i247 := 8640;
  goto $bb309;
$bb308:
  assume !(($i246 == 1));
  assume {:verifier.code 0} true;
  $i247 := 3;
  goto $bb309;
$bb309:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 589, 77} true;
  assume {:verifier.code 0} true;
  $i101, $i102, $i103, $i104, $i105, $i106, $i107, $i108, $i109 := $i41, $i42, $i247, $i44, $i45, 0, $i46, 8448, $i238;
  goto $bb150;
$bb310:
  assume ($i248 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 596, 86} true;
  assume {:verifier.code 0} true;
  $i249 := $ne.i32($i31, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 596, 83} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i249} true;
  goto $bb313, $bb314;
$bb311:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 593, 81} true;
  assume {:verifier.code 0} true;
  assume !(($i248 == 1));
  goto $bb312;
$bb312:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 601, 77} true;
  assume {:verifier.code 0} true;
  $i91 := 1;
  goto $bb140;
$bb313:
  assume ($i249 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 598, 79} true;
  assume {:verifier.code 0} true;
  goto $bb315;
$bb314:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 596, 83} true;
  assume {:verifier.code 0} true;
  assume !(($i249 == 1));
  goto $bb315;
$bb315:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 599, 77} true;
  assume {:verifier.code 0} true;
  goto $bb312;
$bb316:
  assume {:verifier.code 0} true;
  goto $bb317;
$bb317:
  assume {:verifier.code 0} true;
  goto $bb318;
$bb318:
  assume {:verifier.code 0} true;
  goto $bb319;
$bb319:
  assume {:verifier.code 0} true;
  goto $bb320;
$bb320:
  assume {:verifier.code 0} true;
  goto $bb321;
$bb321:
  assume {:verifier.code 0} true;
  goto $bb322;
$bb322:
  assume {:verifier.code 0} true;
  goto $bb323;
$bb323:
  assume {:verifier.code 0} true;
  goto $bb324;
$bb324:
  assume {:verifier.code 0} true;
  goto $bb325;
$bb325:
  assume {:verifier.code 0} true;
  goto $bb326;
$bb326:
  assume {:verifier.code 0} true;
  goto $bb327;
$bb327:
  assume {:verifier.code 0} true;
  goto $bb328;
$bb328:
  assume {:verifier.code 0} true;
  goto $bb329;
$bb329:
  assume {:verifier.code 0} true;
  goto $bb330;
$bb330:
  assume {:verifier.code 0} true;
  goto $bb331;
$bb331:
  assume {:verifier.code 0} true;
  goto $bb332;
$bb332:
  assume {:verifier.code 0} true;
  goto $bb333;
$bb333:
  assume {:verifier.code 0} true;
  goto $bb334;
$bb334:
  assume {:verifier.code 0} true;
  goto $bb335;
$bb335:
  assume {:verifier.code 0} true;
  goto $bb336;
$bb336:
  assume {:verifier.code 0} true;
  goto $bb337;
$bb337:
  assume {:verifier.code 0} true;
  goto $bb338;
$bb338:
  assume {:verifier.code 0} true;
  goto $bb339;
$bb339:
  assume {:verifier.code 0} true;
  goto $bb340;
$bb340:
  assume {:verifier.code 0} true;
  goto $bb341;
$bb341:
  assume {:verifier.code 0} true;
  goto $bb342;
$bb342:
  assume {:verifier.code 0} true;
  goto $bb343;
$bb343:
  assume {:verifier.code 0} true;
  goto $bb344;
$bb344:
  assume {:verifier.code 0} true;
  goto $bb345;
$bb345:
  assume {:verifier.code 0} true;
  goto $bb346;
$bb346:
  assume {:verifier.code 0} true;
  goto $bb347;
$bb347:
  assume {:verifier.code 0} true;
  goto $bb348;
$bb348:
  assume {:verifier.code 0} true;
  goto $bb349;
$bb349:
  assume {:verifier.code 0} true;
  goto $bb350;
$bb350:
  assume {:verifier.code 0} true;
  goto $bb351;
$bb351:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 643, 11} true;
  assume {:verifier.code 0} true;
  $i250 := $ne.i32($i15, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 643, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i250} true;
  goto $bb352, $bb354;
$bb352:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 643, 9} true;
  assume {:verifier.code 0} true;
  assume ($i250 == 1);
  goto $bb353;
$bb353:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 102, 3} true;
  assume {:verifier.code 0} true;
  $i41, $i42, $i43, $i44, $i45, $i46, $i47, $i48 := $i101, $i102, $i103, $i104, $i105, $i107, $i108, $i109;
  goto $bb19;
$bb354:
  assume !(($i250 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 644, 13} true;
  assume {:verifier.code 0} true;
  $i251 := $ne.i32($i106, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 644, 11} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i251} true;
  goto $bb355, $bb357;
$bb355:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 644, 11} true;
  assume {:verifier.code 0} true;
  assume ($i251 == 1);
  goto $bb356;
$bb356:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 659, 5} true;
  assume {:verifier.code 0} true;
  goto $bb353;
$bb357:
  assume !(($i251 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 645, 13} true;
  assume {:verifier.code 0} true;
  $i252 := $ne.i32($i5, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 645, 13} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i252} true;
  goto $bb358, $bb359;
$bb358:
  assume ($i252 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 646, 17} true;
  assume {:verifier.code 1} true;
  call $i253 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i253);
  call {:cexpr "ret"} boogie_si_record_i32($i253);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 647, 19} true;
  assume {:verifier.code 0} true;
  $i254 := $sle.i32($i253, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 647, 15} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i254} true;
  goto $bb361, $bb362;
$bb359:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 645, 13} true;
  assume {:verifier.code 0} true;
  assume !(($i252 == 1));
  goto $bb360;
$bb360:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 651, 16} true;
  assume {:verifier.code 0} true;
  $i255 := $ne.i32($i31, 0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 651, 13} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i255} true;
  goto $bb363, $bb364;
$bb361:
  assume ($i254 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 648, 13} true;
  assume {:verifier.code 0} true;
  $i91 := $i253;
  goto $bb140;
$bb362:
  assume !(($i254 == 1));
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 650, 9} true;
  assume {:verifier.code 0} true;
  goto $bb360;
$bb363:
  assume ($i255 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 652, 24} true;
  assume {:verifier.code 0} true;
  $i256 := $ne.i32($i108, $i47);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 652, 15} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i256} true;
  goto $bb366, $bb367;
$bb364:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 651, 13} true;
  assume {:verifier.code 0} true;
  assume !(($i255 == 1));
  goto $bb365;
$bb365:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 658, 7} true;
  assume {:verifier.code 0} true;
  goto $bb356;
$bb366:
  assume ($i256 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 656, 11} true;
  assume {:verifier.code 0} true;
  goto $bb368;
$bb367:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 652, 15} true;
  assume {:verifier.code 0} true;
  assume !(($i256 == 1));
  goto $bb368;
$bb368:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 657, 9} true;
  assume {:verifier.code 0} true;
  goto $bb365;
$bb369:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 663, 3} true;
  assume {:verifier.code 0} true;
  $i91 := $u0;
  goto $bb140;
$bb370:
  assume ($i257 == 1);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 669, 3} true;
  assume {:verifier.code 0} true;
  goto $bb372;
$bb371:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 667, 7} true;
  assume {:verifier.code 0} true;
  assume !(($i257 == 1));
  goto $bb372;
$bb372:
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 670, 3} true;
  assume {:verifier.code 0} true;
  $i40 := $i91;
  goto $bb18;
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
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 682, 9} true;
  assume {:verifier.code 0} true;
  call {:cexpr "smack:entry:main"} boogie_si_record_ref(main);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 682, 9} true;
  assume {:verifier.code 0} true;
  call $i0 := ssl3_accept(8464);
  call {:cexpr "tmp"} boogie_si_record_i32($i0);
  assume {:sourceloc "./output/s3_srvr_6.cil-1_tmp.c", 684, 3} true;
  assume {:verifier.code 0} true;
  $r := $i0;
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
const __SMACK_nondet_unsigned_long: ref;
axiom (__SMACK_nondet_unsigned_long == $sub.ref(0, 33027));
procedure __SMACK_nondet_unsigned_long()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_int: ref;
axiom (__SMACK_nondet_unsigned_long_int == $sub.ref(0, 34059));
procedure __SMACK_nondet_unsigned_long_int()
  returns ($r: i64);
const __SMACK_nondet_long_long: ref;
axiom (__SMACK_nondet_long_long == $sub.ref(0, 35091));
procedure __SMACK_nondet_long_long()
  returns ($r: i64);
const __SMACK_nondet_long_long_int: ref;
axiom (__SMACK_nondet_long_long_int == $sub.ref(0, 36123));
procedure __SMACK_nondet_long_long_int()
  returns ($r: i64);
const __SMACK_nondet_signed_long_long: ref;
axiom (__SMACK_nondet_signed_long_long == $sub.ref(0, 37155));
procedure __SMACK_nondet_signed_long_long()
  returns ($r: i64);
const __SMACK_nondet_signed_long_long_int: ref;
axiom (__SMACK_nondet_signed_long_long_int == $sub.ref(0, 38187));
procedure __SMACK_nondet_signed_long_long_int()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_long: ref;
axiom (__SMACK_nondet_unsigned_long_long == $sub.ref(0, 39219));
procedure __SMACK_nondet_unsigned_long_long()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_long_int: ref;
axiom (__SMACK_nondet_unsigned_long_long_int == $sub.ref(0, 40251));
procedure __SMACK_nondet_unsigned_long_long_int()
  returns ($r: i64);
const __SMACK_decls: ref;
axiom (__SMACK_decls == $sub.ref(0, 41283));
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
axiom (__SMACK_top_decl == $sub.ref(0, 42315));
procedure __SMACK_top_decl.ref($p0: ref);
const __SMACK_init_func_memory_model: ref;
axiom (__SMACK_init_func_memory_model == $sub.ref(0, 43347));
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
axiom (llvm.dbg.value == $sub.ref(0, 44379));
procedure llvm.dbg.value($p0: ref, $p1: ref, $p2: ref);
const __SMACK_static_init: ref;
axiom (__SMACK_static_init == $sub.ref(0, 45411));
procedure __SMACK_static_init()
{
$bb0:
  $M.0 := .str.1.5;
  $M.1 := 0;
  call {:cexpr "errno_global"} boogie_si_record_i32(0);
  $exn := false;
  return;
}
const $u0: i32;
const $u1: i64;
procedure boogie_si_record_i32(x: i32);
procedure boogie_si_record_i64(x: i64);
procedure boogie_si_record_ref(x: ref);
procedure $initialize()
{
  call __SMACK_static_init();
  call __SMACK_init_func_memory_model();
  return;
}
