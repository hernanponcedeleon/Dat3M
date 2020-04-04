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

// Memory maps (3 regions)
var $M.0: [ref] i8;
var $M.1: ref;
var $M.2: i32;

// Memory address bounds
axiom ($GLOBALS_BOTTOM == $sub.ref(0, 58835));
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
const gl_list: ref;
axiom (gl_list == $sub.ref(0, 1040));
const {:count 14} .str.1: ref;
axiom (.str.1 == $sub.ref(0, 2078));
const env_value_str: ref;
axiom (env_value_str == $sub.ref(0, 3110));
const {:count 3} .str.1.3: ref;
axiom (.str.1.3 == $sub.ref(0, 4137));
const {:count 14} .str.14: ref;
axiom (.str.14 == $sub.ref(0, 5175));
const errno_global: ref;
axiom (errno_global == $sub.ref(0, 6203));
const reach_error: ref;
axiom (reach_error == $sub.ref(0, 7235));
procedure reach_error()
{
$bb0:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 2, 44} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 2, 44} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const main: ref;
axiom (main == $sub.ref(0, 8267));
procedure main()
  returns ($r: i32)
{
$bb0:
  call $initialize();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 829, 3} true;
  assume {:verifier.code 0} true;
  call {:cexpr "smack:entry:main"} boogie_si_record_ref(main);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 829, 3} true;
  assume {:verifier.code 0} true;
  call gl_read();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 831, 3} true;
  assume {:verifier.code 0} true;
  call inspect(gl_list);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 832, 3} true;
  assume {:verifier.code 0} true;
  call gl_sort();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 834, 3} true;
  assume {:verifier.code 0} true;
  call inspect(gl_list);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 835, 3} true;
  assume {:verifier.code 0} true;
  call gl_destroy();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 837, 3} true;
  assume {:verifier.code 0} true;
  $r := 0;
  $exn := false;
  return;
}
const gl_read: ref;
axiom (gl_read == $sub.ref(0, 9299));
procedure gl_read()
{
  var $i0: i32;
  var $i1: i32;
  var $i2: i1;
$bb0:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 670, 3} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 670, 3} true;
  assume {:verifier.code 0} true;
  goto $bb1;
$bb1:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 670, 13} true;
  assume {:verifier.code 0} true;
  goto $bb2;
$bb2:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 673, 11} true;
  assume {:verifier.code 1} true;
  call $i0 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i0);
  call {:cexpr "tmp"} boogie_si_record_i32($i0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 674, 5} true;
  assume {:verifier.code 0} true;
  call gl_insert($i0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 675, 15} true;
  assume {:verifier.code 1} true;
  call $i1 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i1);
  call {:cexpr "tmp___0"} boogie_si_record_i32($i1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 677, 9} true;
  assume {:verifier.code 0} true;
  $i2 := $ne.i32($i1, 0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 677, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i2} true;
  goto $bb3, $bb4;
$bb3:
  assume ($i2 == 1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 678, 5} true;
  assume {:verifier.code 0} true;
  goto $bb5;
$bb4:
  assume !(($i2 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 679, 7} true;
  assume {:verifier.code 0} true;
  goto $bb6;
$bb5:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 670, 3} true;
  assume {:verifier.code 0} true;
  goto $bb1;
$bb6:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 684, 3} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const inspect: ref;
axiom (inspect == $sub.ref(0, 10331));
procedure inspect($p0: ref)
{
  var $i1: i1;
  var $i2: i32;
  var $p3: ref;
  var $p4: ref;
  var $i5: i32;
  var $i6: i1;
  var $i7: i32;
  var $i8: i1;
  var $i9: i32;
  var $i10: i32;
  var $i11: i32;
  var $i12: i64;
  var $p13: ref;
  var $p14: ref;
  var $i15: i32;
  var $i16: i1;
  var $i17: i32;
  var $i18: i1;
  var $i19: i32;
  var $i20: i32;
  var $i21: i64;
  var $p22: ref;
  var $p23: ref;
  var $i24: i1;
  var $i25: i32;
  var $p26: ref;
  var $p27: ref;
  var $i28: i32;
  var $i29: i1;
  var $i30: i32;
  var $i31: i1;
  var $i32: i32;
  var $i33: i32;
  var $i34: i32;
  var $i35: i64;
  var $p36: ref;
  var $p37: ref;
  var $i38: i32;
  var $i39: i1;
  var $i40: i32;
  var $i41: i1;
  var $i42: i32;
  var $i43: i32;
  var $i44: i64;
  var $p45: ref;
  var $i46: i64;
  var $p47: ref;
  var $i48: i64;
  var $p49: ref;
  var $p50: ref;
  var $i51: i1;
  var $i52: i32;
  var $i53: i32;
  var $i54: i64;
  var $p55: ref;
  var $i56: i32;
  var $i57: i32;
  var $i58: i32;
  var $i59: i64;
  var $p60: ref;
  var $p61: ref;
  var $i62: i32;
  var $i63: i1;
  var $i64: i32;
  var $i65: i1;
  var $i66: i32;
  var $i67: i32;
  var $i68: i64;
  var $p69: ref;
  var $i70: i32;
  var $i71: i32;
  var $i72: i32;
  var $i73: i64;
  var $p74: ref;
  var $p75: ref;
  var $i76: i32;
  var $i77: i1;
  var $i78: i32;
  var $i79: i1;
  var $i80: i32;
  var $i81: i32;
  var $i82: i64;
  var $p83: ref;
  var $i84: i32;
  var $i85: i32;
  var $i86: i32;
  var $i87: i64;
  var $p88: ref;
  var $p89: ref;
  var $i90: i32;
  var $i91: i1;
  var $i92: i32;
  var $i93: i1;
  var $i94: i32;
  var $i95: i32;
  var $i96: i64;
  var $p97: ref;
  var $i98: i32;
  var $i99: i32;
  var $i100: i32;
  var $i101: i64;
  var $p102: ref;
  var $p103: ref;
  var $i104: i32;
  var $i105: i1;
  var $i106: i32;
  var $i107: i1;
  var $p108: ref;
  var $i109: i32;
  var $i110: i32;
  var $i111: i1;
  var $i112: i32;
  var $i113: i1;
  var $i114: i32;
  var $i115: i32;
  var $i116: i64;
  var $p117: ref;
  var $p118: ref;
  var $i119: i32;
  var $i120: i32;
  var $i121: i1;
  var $i122: i32;
  var $i123: i1;
  var $p124: ref;
  var $p125: ref;
  var $i126: i32;
  var $i127: i32;
  var $i128: i1;
  var $i129: i32;
  var $i130: i1;
  var $i131: i32;
  var $i132: i32;
  var $i133: i64;
  var $p134: ref;
  var $p135: ref;
  var $i136: i32;
  var $i137: i32;
  var $i138: i64;
  var $p139: ref;
  var $p140: ref;
  var $i141: i32;
  var $i142: i32;
  var $i143: i1;
  var $i144: i32;
  var $i145: i1;
  var $i146: i32;
  var $i147: i32;
  var $i148: i64;
  var $p149: ref;
  var $p150: ref;
  var $p151: ref;
  var $p152: ref;
  var $i153: i32;
  var $i154: i32;
  var $i155: i1;
  var $i156: i32;
  var $i157: i1;
  var $p158: ref;
  var $p159: ref;
  var $p160: ref;
  var $i161: i32;
  var $i162: i32;
  var $i163: i32;
  var $i164: i64;
  var $p165: ref;
  var $i166: i32;
  var $i167: i1;
  var $p168: ref;
  var $p169: ref;
  var $i170: i32;
  var $i171: i32;
  var $i172: i32;
  var $i173: i64;
  var $p174: ref;
  var $i175: i64;
  var $p176: ref;
  var $i177: i64;
  var $p178: ref;
  var $p179: ref;
  var $i180: i32;
  var $i181: i1;
  var $i182: i32;
  var $i183: i1;
$bb0:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 169, 3} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 169, 3} true;
  assume {:verifier.code 0} true;
  goto $bb1;
$bb1:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 169, 13} true;
  assume {:verifier.code 0} true;
  goto $bb2;
$bb2:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 171, 11} true;
  assume {:verifier.code 0} true;
  $i1 := $ne.ref($p0, $0.ref);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 171, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i1} true;
  goto $bb3, $bb4;
$bb3:
  assume ($i1 == 1);
  assume {:verifier.code 0} true;
  goto $bb5;
$bb4:
  assume !(($i1 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 173, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 175, 5} true;
  assume {:verifier.code 0} true;
  goto $bb5;
$bb5:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 177, 5} true;
  assume {:verifier.code 0} true;
  goto $bb6;
$bb6:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 182, 3} true;
  assume {:verifier.code 0} true;
  goto $bb7;
$bb7:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 182, 13} true;
  assume {:verifier.code 0} true;
  goto $bb8;
$bb8:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 185, 18} true;
  assume {:verifier.code 0} true;
  $i2 := $p2i.ref.i32($p0);
  call {:cexpr "__cil_tmp3"} boogie_si_record_i32($i2);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 186, 18} true;
  assume {:verifier.code 0} true;
  $p3 := $bitcast.ref.ref($p0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 186, 18} true;
  assume {:verifier.code 0} true;
  $p4 := $load.ref($M.0, $p3);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 187, 18} true;
  assume {:verifier.code 0} true;
  $i5 := $p2i.ref.i32($p4);
  call {:cexpr "__cil_tmp5"} boogie_si_record_i32($i5);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 188, 29} true;
  assume {:verifier.code 0} true;
  $i6 := $ne.i32($i5, $i2);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 188, 29} true;
  assume {:verifier.code 0} true;
  $i7 := $zext.i1.i32($i6);
  call {:cexpr "__cil_tmp6"} boogie_si_record_i32($i7);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 189, 11} true;
  assume {:verifier.code 0} true;
  $i8 := $ne.i32($i7, 0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 189, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i8} true;
  goto $bb9, $bb10;
$bb9:
  assume ($i8 == 1);
  assume {:verifier.code 0} true;
  goto $bb11;
$bb10:
  assume !(($i8 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 191, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 193, 5} true;
  assume {:verifier.code 0} true;
  goto $bb11;
$bb11:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 196, 5} true;
  assume {:verifier.code 0} true;
  goto $bb12;
$bb12:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 201, 3} true;
  assume {:verifier.code 0} true;
  goto $bb13;
$bb13:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 201, 13} true;
  assume {:verifier.code 0} true;
  goto $bb14;
$bb14:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 204, 18} true;
  assume {:verifier.code 0} true;
  $i9 := $p2i.ref.i32($p0);
  call {:cexpr "__cil_tmp7"} boogie_si_record_i32($i9);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 205, 18} true;
  assume {:verifier.code 0} true;
  $i10 := $p2i.ref.i32($p0);
  call {:cexpr "__cil_tmp8"} boogie_si_record_i32($i10);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 206, 29} true;
  assume {:verifier.code 0} true;
  $i11 := $add.i32($i10, 4);
  call {:cexpr "__cil_tmp9"} boogie_si_record_i32($i11);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 207, 21} true;
  assume {:verifier.code 0} true;
  $i12 := $zext.i32.i64($i11);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 207, 21} true;
  assume {:verifier.code 0} true;
  $p13 := $i2p.i64.ref($i12);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 207, 19} true;
  assume {:verifier.code 0} true;
  $p14 := $load.ref($M.0, $p13);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 208, 19} true;
  assume {:verifier.code 0} true;
  $i15 := $p2i.ref.i32($p14);
  call {:cexpr "__cil_tmp11"} boogie_si_record_i32($i15);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 209, 31} true;
  assume {:verifier.code 0} true;
  $i16 := $ne.i32($i15, $i9);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 209, 31} true;
  assume {:verifier.code 0} true;
  $i17 := $zext.i1.i32($i16);
  call {:cexpr "__cil_tmp12"} boogie_si_record_i32($i17);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 210, 11} true;
  assume {:verifier.code 0} true;
  $i18 := $ne.i32($i17, 0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 210, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i18} true;
  goto $bb15, $bb16;
$bb15:
  assume ($i18 == 1);
  assume {:verifier.code 0} true;
  goto $bb17;
$bb16:
  assume !(($i18 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 212, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 214, 5} true;
  assume {:verifier.code 0} true;
  goto $bb17;
$bb17:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 217, 5} true;
  assume {:verifier.code 0} true;
  goto $bb18;
$bb18:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 221, 17} true;
  assume {:verifier.code 0} true;
  $i19 := $p2i.ref.i32($p0);
  call {:cexpr "__cil_tmp13"} boogie_si_record_i32($i19);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 222, 29} true;
  assume {:verifier.code 0} true;
  $i20 := $add.i32($i19, 4);
  call {:cexpr "__cil_tmp14"} boogie_si_record_i32($i20);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 223, 19} true;
  assume {:verifier.code 0} true;
  $i21 := $zext.i32.i64($i20);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 223, 19} true;
  assume {:verifier.code 0} true;
  $p22 := $i2p.i64.ref($i21);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 223, 17} true;
  assume {:verifier.code 0} true;
  $p23 := $load.ref($M.0, $p22);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 226, 3} true;
  assume {:verifier.code 0} true;
  goto $bb19;
$bb19:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 226, 13} true;
  assume {:verifier.code 0} true;
  goto $bb20;
$bb20:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 228, 11} true;
  assume {:verifier.code 0} true;
  $i24 := $ne.ref($p23, $0.ref);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 228, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i24} true;
  goto $bb21, $bb22;
$bb21:
  assume ($i24 == 1);
  assume {:verifier.code 0} true;
  goto $bb23;
$bb22:
  assume !(($i24 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 230, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 232, 5} true;
  assume {:verifier.code 0} true;
  goto $bb23;
$bb23:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 234, 5} true;
  assume {:verifier.code 0} true;
  goto $bb24;
$bb24:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 239, 3} true;
  assume {:verifier.code 0} true;
  goto $bb25;
$bb25:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 239, 13} true;
  assume {:verifier.code 0} true;
  goto $bb26;
$bb26:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 242, 19} true;
  assume {:verifier.code 0} true;
  $i25 := $p2i.ref.i32($p23);
  call {:cexpr "__cil_tmp16"} boogie_si_record_i32($i25);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 243, 19} true;
  assume {:verifier.code 0} true;
  $p26 := $bitcast.ref.ref($p23);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 243, 19} true;
  assume {:verifier.code 0} true;
  $p27 := $load.ref($M.0, $p26);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 244, 19} true;
  assume {:verifier.code 0} true;
  $i28 := $p2i.ref.i32($p27);
  call {:cexpr "__cil_tmp18"} boogie_si_record_i32($i28);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 245, 31} true;
  assume {:verifier.code 0} true;
  $i29 := $ne.i32($i28, $i25);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 245, 31} true;
  assume {:verifier.code 0} true;
  $i30 := $zext.i1.i32($i29);
  call {:cexpr "__cil_tmp19"} boogie_si_record_i32($i30);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 246, 11} true;
  assume {:verifier.code 0} true;
  $i31 := $ne.i32($i30, 0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 246, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i31} true;
  goto $bb27, $bb28;
$bb27:
  assume ($i31 == 1);
  assume {:verifier.code 0} true;
  goto $bb29;
$bb28:
  assume !(($i31 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 248, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 250, 5} true;
  assume {:verifier.code 0} true;
  goto $bb29;
$bb29:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 253, 5} true;
  assume {:verifier.code 0} true;
  goto $bb30;
$bb30:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 258, 3} true;
  assume {:verifier.code 0} true;
  goto $bb31;
$bb31:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 258, 13} true;
  assume {:verifier.code 0} true;
  goto $bb32;
$bb32:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 261, 19} true;
  assume {:verifier.code 0} true;
  $i32 := $p2i.ref.i32($p23);
  call {:cexpr "__cil_tmp20"} boogie_si_record_i32($i32);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 262, 19} true;
  assume {:verifier.code 0} true;
  $i33 := $p2i.ref.i32($p23);
  call {:cexpr "__cil_tmp21"} boogie_si_record_i32($i33);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 263, 31} true;
  assume {:verifier.code 0} true;
  $i34 := $add.i32($i33, 4);
  call {:cexpr "__cil_tmp22"} boogie_si_record_i32($i34);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 264, 21} true;
  assume {:verifier.code 0} true;
  $i35 := $zext.i32.i64($i34);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 264, 21} true;
  assume {:verifier.code 0} true;
  $p36 := $i2p.i64.ref($i35);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 264, 19} true;
  assume {:verifier.code 0} true;
  $p37 := $load.ref($M.0, $p36);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 265, 19} true;
  assume {:verifier.code 0} true;
  $i38 := $p2i.ref.i32($p37);
  call {:cexpr "__cil_tmp24"} boogie_si_record_i32($i38);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 266, 31} true;
  assume {:verifier.code 0} true;
  $i39 := $ne.i32($i38, $i32);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 266, 31} true;
  assume {:verifier.code 0} true;
  $i40 := $zext.i1.i32($i39);
  call {:cexpr "__cil_tmp25"} boogie_si_record_i32($i40);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 267, 11} true;
  assume {:verifier.code 0} true;
  $i41 := $ne.i32($i40, 0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 267, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i41} true;
  goto $bb33, $bb34;
$bb33:
  assume ($i41 == 1);
  assume {:verifier.code 0} true;
  goto $bb35;
$bb34:
  assume !(($i41 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 269, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 271, 5} true;
  assume {:verifier.code 0} true;
  goto $bb35;
$bb35:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 274, 5} true;
  assume {:verifier.code 0} true;
  goto $bb36;
$bb36:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 279, 17} true;
  assume {:verifier.code 0} true;
  $i42 := $p2i.ref.i32($0.ref);
  call {:cexpr "__cil_tmp27"} boogie_si_record_i32($i42);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 280, 29} true;
  assume {:verifier.code 0} true;
  $i43 := $add.i32($i42, 4);
  call {:cexpr "__cil_tmp28"} boogie_si_record_i32($i43);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 281, 17} true;
  assume {:verifier.code 0} true;
  $i44 := $zext.i32.i64($i43);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 281, 17} true;
  assume {:verifier.code 0} true;
  $p45 := $i2p.i64.ref($i44);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 282, 17} true;
  assume {:verifier.code 0} true;
  $i46 := $p2i.ref.i64($p45);
  call {:cexpr "__cil_tmp30"} boogie_si_record_i64($i46);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 283, 17} true;
  assume {:verifier.code 0} true;
  $p47 := $bitcast.ref.ref($p23);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 284, 29} true;
  assume {:verifier.code 0} true;
  $i48 := $sub.i64(0, $i46);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 284, 29} true;
  assume {:verifier.code 0} true;
  $p49 := $add.ref($p47, $mul.ref($i48, 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 285, 17} true;
  assume {:verifier.code 0} true;
  $p50 := $bitcast.ref.ref($p49);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 288, 3} true;
  assume {:verifier.code 0} true;
  goto $bb37;
$bb37:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 288, 13} true;
  assume {:verifier.code 0} true;
  goto $bb38;
$bb38:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 290, 11} true;
  assume {:verifier.code 0} true;
  $i51 := $ne.ref($p50, $0.ref);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 290, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i51} true;
  goto $bb39, $bb40;
$bb39:
  assume ($i51 == 1);
  assume {:verifier.code 0} true;
  goto $bb41;
$bb40:
  assume !(($i51 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 292, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 294, 5} true;
  assume {:verifier.code 0} true;
  goto $bb41;
$bb41:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 296, 5} true;
  assume {:verifier.code 0} true;
  goto $bb42;
$bb42:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 301, 3} true;
  assume {:verifier.code 0} true;
  goto $bb43;
$bb43:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 301, 13} true;
  assume {:verifier.code 0} true;
  goto $bb44;
$bb44:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 304, 19} true;
  assume {:verifier.code 0} true;
  $i52 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp34"} boogie_si_record_i32($i52);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 305, 31} true;
  assume {:verifier.code 0} true;
  $i53 := $add.i32($i52, 12);
  call {:cexpr "__cil_tmp35"} boogie_si_record_i32($i53);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 306, 19} true;
  assume {:verifier.code 0} true;
  $i54 := $zext.i32.i64($i53);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 306, 19} true;
  assume {:verifier.code 0} true;
  $p55 := $i2p.i64.ref($i54);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 307, 19} true;
  assume {:verifier.code 0} true;
  $i56 := $p2i.ref.i32($p55);
  call {:cexpr "__cil_tmp37"} boogie_si_record_i32($i56);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 308, 19} true;
  assume {:verifier.code 0} true;
  $i57 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp38"} boogie_si_record_i32($i57);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 309, 31} true;
  assume {:verifier.code 0} true;
  $i58 := $add.i32($i57, 12);
  call {:cexpr "__cil_tmp39"} boogie_si_record_i32($i58);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 310, 21} true;
  assume {:verifier.code 0} true;
  $i59 := $zext.i32.i64($i58);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 310, 21} true;
  assume {:verifier.code 0} true;
  $p60 := $i2p.i64.ref($i59);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 310, 19} true;
  assume {:verifier.code 0} true;
  $p61 := $load.ref($M.0, $p60);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 311, 19} true;
  assume {:verifier.code 0} true;
  $i62 := $p2i.ref.i32($p61);
  call {:cexpr "__cil_tmp41"} boogie_si_record_i32($i62);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 312, 31} true;
  assume {:verifier.code 0} true;
  $i63 := $eq.i32($i62, $i56);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 312, 31} true;
  assume {:verifier.code 0} true;
  $i64 := $zext.i1.i32($i63);
  call {:cexpr "__cil_tmp42"} boogie_si_record_i32($i64);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 313, 11} true;
  assume {:verifier.code 0} true;
  $i65 := $ne.i32($i64, 0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 313, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i65} true;
  goto $bb45, $bb46;
$bb45:
  assume ($i65 == 1);
  assume {:verifier.code 0} true;
  goto $bb47;
$bb46:
  assume !(($i65 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 315, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 317, 5} true;
  assume {:verifier.code 0} true;
  goto $bb47;
$bb47:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 320, 5} true;
  assume {:verifier.code 0} true;
  goto $bb48;
$bb48:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 325, 3} true;
  assume {:verifier.code 0} true;
  goto $bb49;
$bb49:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 325, 13} true;
  assume {:verifier.code 0} true;
  goto $bb50;
$bb50:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 328, 19} true;
  assume {:verifier.code 0} true;
  $i66 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp43"} boogie_si_record_i32($i66);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 329, 31} true;
  assume {:verifier.code 0} true;
  $i67 := $add.i32($i66, 12);
  call {:cexpr "__cil_tmp44"} boogie_si_record_i32($i67);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 330, 19} true;
  assume {:verifier.code 0} true;
  $i68 := $zext.i32.i64($i67);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 330, 19} true;
  assume {:verifier.code 0} true;
  $p69 := $i2p.i64.ref($i68);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 331, 19} true;
  assume {:verifier.code 0} true;
  $i70 := $p2i.ref.i32($p69);
  call {:cexpr "__cil_tmp46"} boogie_si_record_i32($i70);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 333, 19} true;
  assume {:verifier.code 0} true;
  $i71 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp48"} boogie_si_record_i32($i71);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 334, 31} true;
  assume {:verifier.code 0} true;
  $i72 := $add.i32($i71, 16);
  call {:cexpr "__cil_tmp49"} boogie_si_record_i32($i72);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 335, 21} true;
  assume {:verifier.code 0} true;
  $i73 := $zext.i32.i64($i72);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 335, 21} true;
  assume {:verifier.code 0} true;
  $p74 := $i2p.i64.ref($i73);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 335, 19} true;
  assume {:verifier.code 0} true;
  $p75 := $load.ref($M.0, $p74);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 336, 19} true;
  assume {:verifier.code 0} true;
  $i76 := $p2i.ref.i32($p75);
  call {:cexpr "__cil_tmp51"} boogie_si_record_i32($i76);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 337, 31} true;
  assume {:verifier.code 0} true;
  $i77 := $eq.i32($i76, $i70);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 337, 31} true;
  assume {:verifier.code 0} true;
  $i78 := $zext.i1.i32($i77);
  call {:cexpr "__cil_tmp52"} boogie_si_record_i32($i78);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 338, 11} true;
  assume {:verifier.code 0} true;
  $i79 := $ne.i32($i78, 0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 338, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i79} true;
  goto $bb51, $bb52;
$bb51:
  assume ($i79 == 1);
  assume {:verifier.code 0} true;
  goto $bb53;
$bb52:
  assume !(($i79 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 340, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 342, 5} true;
  assume {:verifier.code 0} true;
  goto $bb53;
$bb53:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 345, 5} true;
  assume {:verifier.code 0} true;
  goto $bb54;
$bb54:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 350, 3} true;
  assume {:verifier.code 0} true;
  goto $bb55;
$bb55:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 350, 13} true;
  assume {:verifier.code 0} true;
  goto $bb56;
$bb56:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 353, 19} true;
  assume {:verifier.code 0} true;
  $i80 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp53"} boogie_si_record_i32($i80);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 354, 31} true;
  assume {:verifier.code 0} true;
  $i81 := $add.i32($i80, 4);
  call {:cexpr "__cil_tmp54"} boogie_si_record_i32($i81);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 355, 19} true;
  assume {:verifier.code 0} true;
  $i82 := $zext.i32.i64($i81);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 355, 19} true;
  assume {:verifier.code 0} true;
  $p83 := $i2p.i64.ref($i82);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 356, 19} true;
  assume {:verifier.code 0} true;
  $i84 := $p2i.ref.i32($p83);
  call {:cexpr "__cil_tmp56"} boogie_si_record_i32($i84);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 357, 19} true;
  assume {:verifier.code 0} true;
  $i85 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp57"} boogie_si_record_i32($i85);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 358, 31} true;
  assume {:verifier.code 0} true;
  $i86 := $add.i32($i85, 12);
  call {:cexpr "__cil_tmp58"} boogie_si_record_i32($i86);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 359, 21} true;
  assume {:verifier.code 0} true;
  $i87 := $zext.i32.i64($i86);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 359, 21} true;
  assume {:verifier.code 0} true;
  $p88 := $i2p.i64.ref($i87);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 359, 19} true;
  assume {:verifier.code 0} true;
  $p89 := $load.ref($M.0, $p88);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 360, 19} true;
  assume {:verifier.code 0} true;
  $i90 := $p2i.ref.i32($p89);
  call {:cexpr "__cil_tmp60"} boogie_si_record_i32($i90);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 361, 31} true;
  assume {:verifier.code 0} true;
  $i91 := $ne.i32($i90, $i84);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 361, 31} true;
  assume {:verifier.code 0} true;
  $i92 := $zext.i1.i32($i91);
  call {:cexpr "__cil_tmp61"} boogie_si_record_i32($i92);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 362, 11} true;
  assume {:verifier.code 0} true;
  $i93 := $ne.i32($i92, 0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 362, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i93} true;
  goto $bb57, $bb58;
$bb57:
  assume ($i93 == 1);
  assume {:verifier.code 0} true;
  goto $bb59;
$bb58:
  assume !(($i93 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 364, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 366, 5} true;
  assume {:verifier.code 0} true;
  goto $bb59;
$bb59:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 369, 5} true;
  assume {:verifier.code 0} true;
  goto $bb60;
$bb60:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 374, 3} true;
  assume {:verifier.code 0} true;
  goto $bb61;
$bb61:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 374, 13} true;
  assume {:verifier.code 0} true;
  goto $bb62;
$bb62:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 377, 19} true;
  assume {:verifier.code 0} true;
  $i94 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp62"} boogie_si_record_i32($i94);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 378, 31} true;
  assume {:verifier.code 0} true;
  $i95 := $add.i32($i94, 4);
  call {:cexpr "__cil_tmp63"} boogie_si_record_i32($i95);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 379, 19} true;
  assume {:verifier.code 0} true;
  $i96 := $zext.i32.i64($i95);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 379, 19} true;
  assume {:verifier.code 0} true;
  $p97 := $i2p.i64.ref($i96);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 380, 19} true;
  assume {:verifier.code 0} true;
  $i98 := $p2i.ref.i32($p97);
  call {:cexpr "__cil_tmp65"} boogie_si_record_i32($i98);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 382, 19} true;
  assume {:verifier.code 0} true;
  $i99 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp67"} boogie_si_record_i32($i99);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 383, 31} true;
  assume {:verifier.code 0} true;
  $i100 := $add.i32($i99, 16);
  call {:cexpr "__cil_tmp68"} boogie_si_record_i32($i100);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 384, 21} true;
  assume {:verifier.code 0} true;
  $i101 := $zext.i32.i64($i100);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 384, 21} true;
  assume {:verifier.code 0} true;
  $p102 := $i2p.i64.ref($i101);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 384, 19} true;
  assume {:verifier.code 0} true;
  $p103 := $load.ref($M.0, $p102);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 385, 19} true;
  assume {:verifier.code 0} true;
  $i104 := $p2i.ref.i32($p103);
  call {:cexpr "__cil_tmp70"} boogie_si_record_i32($i104);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 386, 31} true;
  assume {:verifier.code 0} true;
  $i105 := $ne.i32($i104, $i98);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 386, 31} true;
  assume {:verifier.code 0} true;
  $i106 := $zext.i1.i32($i105);
  call {:cexpr "__cil_tmp71"} boogie_si_record_i32($i106);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 387, 11} true;
  assume {:verifier.code 0} true;
  $i107 := $ne.i32($i106, 0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 387, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i107} true;
  goto $bb63, $bb64;
$bb63:
  assume ($i107 == 1);
  assume {:verifier.code 0} true;
  goto $bb65;
$bb64:
  assume !(($i107 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 389, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 391, 5} true;
  assume {:verifier.code 0} true;
  goto $bb65;
$bb65:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 394, 5} true;
  assume {:verifier.code 0} true;
  goto $bb66;
$bb66:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 399, 3} true;
  assume {:verifier.code 0} true;
  goto $bb67;
$bb67:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 399, 13} true;
  assume {:verifier.code 0} true;
  goto $bb68;
$bb68:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 402, 19} true;
  assume {:verifier.code 0} true;
  $p108 := $bitcast.ref.ref($p23);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 403, 19} true;
  assume {:verifier.code 0} true;
  $i109 := $p2i.ref.i32($p108);
  call {:cexpr "__cil_tmp73"} boogie_si_record_i32($i109);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 404, 19} true;
  assume {:verifier.code 0} true;
  $i110 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp74"} boogie_si_record_i32($i110);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 405, 31} true;
  assume {:verifier.code 0} true;
  $i111 := $ne.i32($i110, $i109);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 405, 31} true;
  assume {:verifier.code 0} true;
  $i112 := $zext.i1.i32($i111);
  call {:cexpr "__cil_tmp75"} boogie_si_record_i32($i112);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 406, 11} true;
  assume {:verifier.code 0} true;
  $i113 := $ne.i32($i112, 0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 406, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i113} true;
  goto $bb69, $bb70;
$bb69:
  assume ($i113 == 1);
  assume {:verifier.code 0} true;
  goto $bb71;
$bb70:
  assume !(($i113 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 408, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 410, 5} true;
  assume {:verifier.code 0} true;
  goto $bb71;
$bb71:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 413, 5} true;
  assume {:verifier.code 0} true;
  goto $bb72;
$bb72:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 418, 3} true;
  assume {:verifier.code 0} true;
  goto $bb73;
$bb73:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 418, 13} true;
  assume {:verifier.code 0} true;
  goto $bb74;
$bb74:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 421, 19} true;
  assume {:verifier.code 0} true;
  $i114 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp76"} boogie_si_record_i32($i114);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 422, 31} true;
  assume {:verifier.code 0} true;
  $i115 := $add.i32($i114, 4);
  call {:cexpr "__cil_tmp77"} boogie_si_record_i32($i115);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 423, 19} true;
  assume {:verifier.code 0} true;
  $i116 := $zext.i32.i64($i115);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 423, 19} true;
  assume {:verifier.code 0} true;
  $p117 := $i2p.i64.ref($i116);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 424, 19} true;
  assume {:verifier.code 0} true;
  $p118 := $bitcast.ref.ref($p117);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 425, 19} true;
  assume {:verifier.code 0} true;
  $i119 := $p2i.ref.i32($p118);
  call {:cexpr "__cil_tmp80"} boogie_si_record_i32($i119);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 426, 19} true;
  assume {:verifier.code 0} true;
  $i120 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp81"} boogie_si_record_i32($i120);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 427, 31} true;
  assume {:verifier.code 0} true;
  $i121 := $ne.i32($i120, $i119);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 427, 31} true;
  assume {:verifier.code 0} true;
  $i122 := $zext.i1.i32($i121);
  call {:cexpr "__cil_tmp82"} boogie_si_record_i32($i122);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 428, 11} true;
  assume {:verifier.code 0} true;
  $i123 := $ne.i32($i122, 0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 428, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i123} true;
  goto $bb75, $bb76;
$bb75:
  assume ($i123 == 1);
  assume {:verifier.code 0} true;
  goto $bb77;
$bb76:
  assume !(($i123 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 430, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 432, 5} true;
  assume {:verifier.code 0} true;
  goto $bb77;
$bb77:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 435, 5} true;
  assume {:verifier.code 0} true;
  goto $bb78;
$bb78:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 440, 3} true;
  assume {:verifier.code 0} true;
  goto $bb79;
$bb79:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 440, 13} true;
  assume {:verifier.code 0} true;
  goto $bb80;
$bb80:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 443, 19} true;
  assume {:verifier.code 0} true;
  $p124 := $bitcast.ref.ref($p50);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 444, 19} true;
  assume {:verifier.code 0} true;
  $p125 := $bitcast.ref.ref($p124);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 445, 19} true;
  assume {:verifier.code 0} true;
  $i126 := $p2i.ref.i32($p125);
  call {:cexpr "__cil_tmp85"} boogie_si_record_i32($i126);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 446, 19} true;
  assume {:verifier.code 0} true;
  $i127 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp86"} boogie_si_record_i32($i127);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 447, 31} true;
  assume {:verifier.code 0} true;
  $i128 := $eq.i32($i127, $i126);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 447, 31} true;
  assume {:verifier.code 0} true;
  $i129 := $zext.i1.i32($i128);
  call {:cexpr "__cil_tmp87"} boogie_si_record_i32($i129);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 448, 11} true;
  assume {:verifier.code 0} true;
  $i130 := $ne.i32($i129, 0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 448, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i130} true;
  goto $bb81, $bb82;
$bb81:
  assume ($i130 == 1);
  assume {:verifier.code 0} true;
  goto $bb83;
$bb82:
  assume !(($i130 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 450, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 452, 5} true;
  assume {:verifier.code 0} true;
  goto $bb83;
$bb83:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 455, 5} true;
  assume {:verifier.code 0} true;
  goto $bb84;
$bb84:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 460, 3} true;
  assume {:verifier.code 0} true;
  goto $bb85;
$bb85:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 460, 13} true;
  assume {:verifier.code 0} true;
  goto $bb86;
$bb86:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 463, 19} true;
  assume {:verifier.code 0} true;
  $i131 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp88"} boogie_si_record_i32($i131);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 464, 31} true;
  assume {:verifier.code 0} true;
  $i132 := $add.i32($i131, 4);
  call {:cexpr "__cil_tmp89"} boogie_si_record_i32($i132);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 465, 21} true;
  assume {:verifier.code 0} true;
  $i133 := $zext.i32.i64($i132);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 465, 21} true;
  assume {:verifier.code 0} true;
  $p134 := $i2p.i64.ref($i133);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 465, 19} true;
  assume {:verifier.code 0} true;
  $p135 := $load.ref($M.0, $p134);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 466, 19} true;
  assume {:verifier.code 0} true;
  $i136 := $p2i.ref.i32($p135);
  call {:cexpr "__cil_tmp91"} boogie_si_record_i32($i136);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 467, 31} true;
  assume {:verifier.code 0} true;
  $i137 := $add.i32($i136, 4);
  call {:cexpr "__cil_tmp92"} boogie_si_record_i32($i137);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 468, 21} true;
  assume {:verifier.code 0} true;
  $i138 := $zext.i32.i64($i137);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 468, 21} true;
  assume {:verifier.code 0} true;
  $p139 := $i2p.i64.ref($i138);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 468, 19} true;
  assume {:verifier.code 0} true;
  $p140 := $load.ref($M.0, $p139);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 469, 19} true;
  assume {:verifier.code 0} true;
  $i141 := $p2i.ref.i32($p140);
  call {:cexpr "__cil_tmp94"} boogie_si_record_i32($i141);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 470, 19} true;
  assume {:verifier.code 0} true;
  $i142 := $p2i.ref.i32($p23);
  call {:cexpr "__cil_tmp95"} boogie_si_record_i32($i142);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 471, 31} true;
  assume {:verifier.code 0} true;
  $i143 := $eq.i32($i142, $i141);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 471, 31} true;
  assume {:verifier.code 0} true;
  $i144 := $zext.i1.i32($i143);
  call {:cexpr "__cil_tmp96"} boogie_si_record_i32($i144);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 472, 11} true;
  assume {:verifier.code 0} true;
  $i145 := $ne.i32($i144, 0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 472, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i145} true;
  goto $bb87, $bb88;
$bb87:
  assume ($i145 == 1);
  assume {:verifier.code 0} true;
  goto $bb89;
$bb88:
  assume !(($i145 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 474, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 476, 5} true;
  assume {:verifier.code 0} true;
  goto $bb89;
$bb89:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 479, 5} true;
  assume {:verifier.code 0} true;
  goto $bb90;
$bb90:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 484, 3} true;
  assume {:verifier.code 0} true;
  goto $bb91;
$bb91:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 484, 13} true;
  assume {:verifier.code 0} true;
  goto $bb92;
$bb92:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 488, 19} true;
  assume {:verifier.code 0} true;
  $i146 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp98"} boogie_si_record_i32($i146);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 489, 31} true;
  assume {:verifier.code 0} true;
  $i147 := $add.i32($i146, 8);
  call {:cexpr "__cil_tmp99"} boogie_si_record_i32($i147);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 490, 22} true;
  assume {:verifier.code 0} true;
  $i148 := $zext.i32.i64($i147);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 490, 22} true;
  assume {:verifier.code 0} true;
  $p149 := $i2p.i64.ref($i148);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 490, 20} true;
  assume {:verifier.code 0} true;
  $p150 := $load.ref($M.0, $p149);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 491, 20} true;
  assume {:verifier.code 0} true;
  $p151 := $bitcast.ref.ref($p150);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 491, 20} true;
  assume {:verifier.code 0} true;
  $p152 := $load.ref($M.0, $p151);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 492, 20} true;
  assume {:verifier.code 0} true;
  $i153 := $p2i.ref.i32($p152);
  call {:cexpr "__cil_tmp102"} boogie_si_record_i32($i153);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 493, 20} true;
  assume {:verifier.code 0} true;
  $i154 := $p2i.ref.i32($p23);
  call {:cexpr "__cil_tmp103"} boogie_si_record_i32($i154);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 494, 33} true;
  assume {:verifier.code 0} true;
  $i155 := $eq.i32($i154, $i153);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 494, 33} true;
  assume {:verifier.code 0} true;
  $i156 := $zext.i1.i32($i155);
  call {:cexpr "__cil_tmp104"} boogie_si_record_i32($i156);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 495, 11} true;
  assume {:verifier.code 0} true;
  $i157 := $ne.i32($i156, 0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 495, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i157} true;
  goto $bb93, $bb94;
$bb93:
  assume ($i157 == 1);
  assume {:verifier.code 0} true;
  goto $bb95;
$bb94:
  assume !(($i157 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 497, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 499, 5} true;
  assume {:verifier.code 0} true;
  goto $bb95;
$bb95:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 502, 5} true;
  assume {:verifier.code 0} true;
  goto $bb96;
$bb96:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 506, 18} true;
  assume {:verifier.code 0} true;
  $p158 := $bitcast.ref.ref($p23);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 506, 18} true;
  assume {:verifier.code 0} true;
  $p159 := $load.ref($M.0, $p158);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 509, 3} true;
  assume {:verifier.code 0} true;
  $p160 := $p159;
  goto $bb97;
$bb97:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 509, 13} true;
  assume {:verifier.code 0} true;
  goto $bb98;
$bb98:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 512, 20} true;
  assume {:verifier.code 0} true;
  $i161 := $p2i.ref.i32($p160);
  call {:cexpr "__cil_tmp106"} boogie_si_record_i32($i161);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 513, 20} true;
  assume {:verifier.code 0} true;
  $i162 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp107"} boogie_si_record_i32($i162);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 514, 33} true;
  assume {:verifier.code 0} true;
  $i163 := $add.i32($i162, 4);
  call {:cexpr "__cil_tmp108"} boogie_si_record_i32($i163);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 515, 20} true;
  assume {:verifier.code 0} true;
  $i164 := $zext.i32.i64($i163);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 515, 20} true;
  assume {:verifier.code 0} true;
  $p165 := $i2p.i64.ref($i164);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 516, 20} true;
  assume {:verifier.code 0} true;
  $i166 := $p2i.ref.i32($p165);
  call {:cexpr "__cil_tmp110"} boogie_si_record_i32($i166);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 517, 22} true;
  assume {:verifier.code 0} true;
  $i167 := $ne.i32($i166, $i161);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 517, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i167} true;
  goto $bb99, $bb100;
$bb99:
  assume ($i167 == 1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 518, 5} true;
  assume {:verifier.code 0} true;
  goto $bb101;
$bb100:
  assume !(($i167 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 519, 7} true;
  assume {:verifier.code 0} true;
  goto $bb102;
$bb101:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 522, 20} true;
  assume {:verifier.code 0} true;
  $p168 := $bitcast.ref.ref($p160);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 522, 20} true;
  assume {:verifier.code 0} true;
  $p169 := $load.ref($M.0, $p168);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 509, 3} true;
  assume {:verifier.code 0} true;
  $p160 := $p169;
  goto $bb97;
$bb102:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 528, 3} true;
  assume {:verifier.code 0} true;
  goto $bb103;
$bb103:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 528, 13} true;
  assume {:verifier.code 0} true;
  goto $bb104;
$bb104:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 531, 20} true;
  assume {:verifier.code 0} true;
  $i170 := $p2i.ref.i32($p50);
  call {:cexpr "__cil_tmp112"} boogie_si_record_i32($i170);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 533, 20} true;
  assume {:verifier.code 0} true;
  $i171 := $p2i.ref.i32($0.ref);
  call {:cexpr "__cil_tmp114"} boogie_si_record_i32($i171);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 534, 33} true;
  assume {:verifier.code 0} true;
  $i172 := $add.i32($i171, 4);
  call {:cexpr "__cil_tmp115"} boogie_si_record_i32($i172);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 535, 20} true;
  assume {:verifier.code 0} true;
  $i173 := $zext.i32.i64($i172);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 535, 20} true;
  assume {:verifier.code 0} true;
  $p174 := $i2p.i64.ref($i173);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 536, 20} true;
  assume {:verifier.code 0} true;
  $i175 := $p2i.ref.i64($p174);
  call {:cexpr "__cil_tmp117"} boogie_si_record_i64($i175);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 537, 20} true;
  assume {:verifier.code 0} true;
  $p176 := $bitcast.ref.ref($p160);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 538, 33} true;
  assume {:verifier.code 0} true;
  $i177 := $sub.i64(0, $i175);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 538, 33} true;
  assume {:verifier.code 0} true;
  $p178 := $add.ref($p176, $mul.ref($i177, 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 539, 20} true;
  assume {:verifier.code 0} true;
  $p179 := $bitcast.ref.ref($p178);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 540, 20} true;
  assume {:verifier.code 0} true;
  $i180 := $p2i.ref.i32($p179);
  call {:cexpr "__cil_tmp121"} boogie_si_record_i32($i180);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 541, 33} true;
  assume {:verifier.code 0} true;
  $i181 := $eq.i32($i180, $i170);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 541, 33} true;
  assume {:verifier.code 0} true;
  $i182 := $zext.i1.i32($i181);
  call {:cexpr "__cil_tmp122"} boogie_si_record_i32($i182);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 542, 11} true;
  assume {:verifier.code 0} true;
  $i183 := $ne.i32($i182, 0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 542, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i183} true;
  goto $bb105, $bb106;
$bb105:
  assume ($i183 == 1);
  assume {:verifier.code 0} true;
  goto $bb107;
$bb106:
  assume !(($i183 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 544, 7} true;
  assume {:verifier.code 0} true;
  call fail();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 546, 5} true;
  assume {:verifier.code 0} true;
  goto $bb107;
$bb107:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 549, 5} true;
  assume {:verifier.code 0} true;
  goto $bb108;
$bb108:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 553, 3} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const gl_sort: ref;
axiom (gl_sort == $sub.ref(0, 11363));
procedure gl_sort()
{
  var $i0: i1;
  var $i1: i8;
  var $i2: i1;
$bb0:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 809, 3} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 809, 3} true;
  assume {:verifier.code 0} true;
  goto $bb1;
$bb1:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 809, 13} true;
  assume {:verifier.code 0} true;
  goto $bb2;
$bb2:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 812, 11} true;
  assume {:verifier.code 0} true;
  call $i0 := gl_sort_pass();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 812, 9} true;
  assume {:verifier.code 0} true;
  $i1 := $zext.i1.i8($i0);
  call {:cexpr "tmp"} boogie_si_record_i8($i1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 814, 9} true;
  assume {:verifier.code 0} true;
  $i2 := $trunc.i8.i1($i1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 814, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i2} true;
  goto $bb3, $bb4;
$bb3:
  assume ($i2 == 1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 815, 5} true;
  assume {:verifier.code 0} true;
  goto $bb5;
$bb4:
  assume !(($i2 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 816, 7} true;
  assume {:verifier.code 0} true;
  goto $bb6;
$bb5:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 809, 3} true;
  assume {:verifier.code 0} true;
  goto $bb1;
$bb6:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 821, 3} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const gl_destroy: ref;
axiom (gl_destroy == $sub.ref(0, 12395));
procedure gl_destroy()
{
  var $p0: ref;
  var $p1: ref;
  var $i2: i32;
  var $i3: i1;
  var $p4: ref;
  var $p5: ref;
  var $p6: ref;
  var $i7: i32;
  var $i8: i32;
  var $i9: i64;
  var $p10: ref;
  var $i11: i64;
  var $p12: ref;
  var $i13: i64;
  var $p14: ref;
  var $p15: ref;
  var $p16: ref;
$bb0:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 704, 3} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 704, 3} true;
  assume {:verifier.code 0} true;
  goto $bb1;
$bb1:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 704, 13} true;
  assume {:verifier.code 0} true;
  goto $bb2;
$bb2:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 707, 12} true;
  assume {:verifier.code 0} true;
  $p0 := $bitcast.ref.ref(gl_list);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 707, 12} true;
  assume {:verifier.code 0} true;
  $p1 := $load.ref($M.0, $p0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 709, 18} true;
  assume {:verifier.code 0} true;
  $i2 := $p2i.ref.i32($p1);
  call {:cexpr "__cil_tmp3"} boogie_si_record_i32($i2);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 711, 20} true;
  assume {:verifier.code 0} true;
  $i3 := $ne.i32($p2i.ref.i32(gl_list), $i2);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 711, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i3} true;
  goto $bb3, $bb4;
$bb3:
  assume ($i3 == 1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 712, 5} true;
  assume {:verifier.code 0} true;
  goto $bb5;
$bb4:
  assume !(($i3 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 713, 7} true;
  assume {:verifier.code 0} true;
  goto $bb6;
$bb5:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 718, 42} true;
  assume {:verifier.code 0} true;
  $p4 := $bitcast.ref.ref($p1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 718, 42} true;
  assume {:verifier.code 0} true;
  $p5 := $load.ref($M.0, $p4);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 718, 5} true;
  assume {:verifier.code 0} true;
  $p6 := $bitcast.ref.ref(gl_list);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 718, 40} true;
  assume {:verifier.code 0} true;
  $M.0 := $store.ref($M.0, $p6, $p5);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 720, 18} true;
  assume {:verifier.code 0} true;
  $i7 := $p2i.ref.i32($0.ref);
  call {:cexpr "__cil_tmp7"} boogie_si_record_i32($i7);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 721, 29} true;
  assume {:verifier.code 0} true;
  $i8 := $add.i32($i7, 4);
  call {:cexpr "__cil_tmp8"} boogie_si_record_i32($i8);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 722, 18} true;
  assume {:verifier.code 0} true;
  $i9 := $zext.i32.i64($i8);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 722, 18} true;
  assume {:verifier.code 0} true;
  $p10 := $i2p.i64.ref($i9);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 723, 19} true;
  assume {:verifier.code 0} true;
  $i11 := $p2i.ref.i64($p10);
  call {:cexpr "__cil_tmp10"} boogie_si_record_i64($i11);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 724, 19} true;
  assume {:verifier.code 0} true;
  $p12 := $bitcast.ref.ref($p1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 725, 31} true;
  assume {:verifier.code 0} true;
  $i13 := $sub.i64(0, $i11);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 725, 31} true;
  assume {:verifier.code 0} true;
  $p14 := $add.ref($p12, $mul.ref($i13, 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 726, 19} true;
  assume {:verifier.code 0} true;
  $p15 := $bitcast.ref.ref($p14);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 727, 19} true;
  assume {:verifier.code 0} true;
  $p16 := $bitcast.ref.ref($p15);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 728, 5} true;
  assume {:verifier.code 0} true;
  call free_($p16);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 704, 3} true;
  assume {:verifier.code 0} true;
  goto $bb1;
$bb6:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 733, 3} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const free_: ref;
axiom (free_ == $sub.ref(0, 13427));
procedure free_($p0: ref)
{
  call $free($p0);
}
const gl_sort_pass: ref;
axiom (gl_sort_pass == $sub.ref(0, 14459));
procedure gl_sort_pass()
  returns ($r: i1)
{
  var $p0: ref;
  var $p1: ref;
  var $p2: ref;
  var $i3: i8;
  var $p4: ref;
  var $p5: ref;
  var $p6: ref;
  var $i7: i32;
  var $i8: i1;
  var $i9: i32;
  var $i10: i32;
  var $i11: i1;
  var $i12: i1;
$bb0:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 771, 10} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 771, 10} true;
  assume {:verifier.code 0} true;
  $p0 := $bitcast.ref.ref(gl_list);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 771, 10} true;
  assume {:verifier.code 0} true;
  $p1 := $load.ref($M.0, $p0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 773, 3} true;
  assume {:verifier.code 0} true;
  $p2, $i3 := $p1, 0;
  goto $bb1;
$bb1:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 771, 8} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 773, 13} true;
  assume {:verifier.code 0} true;
  $p4 := $p2;
  goto $bb2;
$bb2:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 775, 12} true;
  assume {:verifier.code 0} true;
  $p5 := $bitcast.ref.ref($p4);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 775, 12} true;
  assume {:verifier.code 0} true;
  $p6 := $load.ref($M.0, $p5);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 777, 18} true;
  assume {:verifier.code 0} true;
  $i7 := $p2i.ref.i32($p6);
  call {:cexpr "__cil_tmp9"} boogie_si_record_i32($i7);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 779, 21} true;
  assume {:verifier.code 0} true;
  $i8 := $ne.i32($p2i.ref.i32(gl_list), $i7);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 779, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i8} true;
  goto $bb3, $bb4;
$bb3:
  assume ($i8 == 1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 780, 5} true;
  assume {:verifier.code 0} true;
  goto $bb5;
$bb4:
  assume !(($i8 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 781, 7} true;
  assume {:verifier.code 0} true;
  goto $bb6;
$bb5:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 785, 11} true;
  assume {:verifier.code 0} true;
  call $i9 := val_from_node($p4);
  call {:cexpr "tmp"} boogie_si_record_i32($i9);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 787, 15} true;
  assume {:verifier.code 0} true;
  call $i10 := val_from_node($p6);
  call {:cexpr "tmp___0"} boogie_si_record_i32($i10);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 790, 14} true;
  assume {:verifier.code 0} true;
  $i11 := $sle.i32($i9, $i10);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 790, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i11} true;
  goto $bb7, $bb8;
$bb6:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 802, 11} true;
  assume {:verifier.code 0} true;
  $i12 := $trunc.i8.i1($i3);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 802, 3} true;
  assume {:verifier.code 0} true;
  $r := $i12;
  $exn := false;
  return;
$bb7:
  assume ($i11 == 1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 792, 7} true;
  assume {:verifier.code 0} true;
  $p4 := $p6;
  goto $bb2;
$bb8:
  assume !(($i11 == 1));
  assume {:verifier.code 0} true;
  goto $bb9;
$bb9:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 797, 5} true;
  assume {:verifier.code 0} true;
  call list_move($p4, $p6);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 773, 3} true;
  assume {:verifier.code 0} true;
  $p2, $i3 := $p4, 1;
  goto $bb1;
}
const val_from_node: ref;
axiom (val_from_node == $sub.ref(0, 15491));
procedure val_from_node($p0: ref)
  returns ($r: i32)
{
  var $i1: i32;
  var $i2: i32;
  var $i3: i64;
  var $p4: ref;
  var $i5: i64;
  var $p6: ref;
  var $i7: i64;
  var $p8: ref;
  var $p9: ref;
  var $p10: ref;
  var $i11: i32;
$bb0:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 747, 16} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 747, 16} true;
  assume {:verifier.code 0} true;
  $i1 := $p2i.ref.i32($0.ref);
  call {:cexpr "__cil_tmp4"} boogie_si_record_i32($i1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 748, 27} true;
  assume {:verifier.code 0} true;
  $i2 := $add.i32($i1, 4);
  call {:cexpr "__cil_tmp5"} boogie_si_record_i32($i2);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 749, 16} true;
  assume {:verifier.code 0} true;
  $i3 := $zext.i32.i64($i2);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 749, 16} true;
  assume {:verifier.code 0} true;
  $p4 := $i2p.i64.ref($i3);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 750, 16} true;
  assume {:verifier.code 0} true;
  $i5 := $p2i.ref.i64($p4);
  call {:cexpr "__cil_tmp7"} boogie_si_record_i64($i5);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 751, 16} true;
  assume {:verifier.code 0} true;
  $p6 := $bitcast.ref.ref($p0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 752, 27} true;
  assume {:verifier.code 0} true;
  $i7 := $sub.i64(0, $i5);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 752, 27} true;
  assume {:verifier.code 0} true;
  $p8 := $add.ref($p6, $mul.ref($i7, 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 753, 11} true;
  assume {:verifier.code 0} true;
  $p9 := $bitcast.ref.ref($p8);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 754, 11} true;
  assume {:verifier.code 0} true;
  $p10 := $bitcast.ref.ref($p9);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 754, 11} true;
  assume {:verifier.code 0} true;
  $i11 := $load.i32($M.0, $p10);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 754, 3} true;
  assume {:verifier.code 0} true;
  $r := $i11;
  $exn := false;
  return;
}
const list_move: ref;
axiom (list_move == $sub.ref(0, 16523));
procedure list_move($p0: ref, $p1: ref)
{
  var $i2: i32;
  var $i3: i32;
  var $i4: i64;
  var $p5: ref;
  var $p6: ref;
  var $p7: ref;
  var $p8: ref;
$bb0:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 601, 16} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 601, 16} true;
  assume {:verifier.code 0} true;
  $i2 := $p2i.ref.i32($p0);
  call {:cexpr "__cil_tmp3"} boogie_si_record_i32($i2);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 602, 27} true;
  assume {:verifier.code 0} true;
  $i3 := $add.i32($i2, 4);
  call {:cexpr "__cil_tmp4"} boogie_si_record_i32($i3);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 603, 18} true;
  assume {:verifier.code 0} true;
  $i4 := $zext.i32.i64($i3);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 603, 18} true;
  assume {:verifier.code 0} true;
  $p5 := $i2p.i64.ref($i4);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 603, 16} true;
  assume {:verifier.code 0} true;
  $p6 := $load.ref($M.0, $p5);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 604, 16} true;
  assume {:verifier.code 0} true;
  $p7 := $bitcast.ref.ref($p0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 604, 16} true;
  assume {:verifier.code 0} true;
  $p8 := $load.ref($M.0, $p7);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 605, 3} true;
  assume {:verifier.code 0} true;
  call __list_del($p6, $p8);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 606, 3} true;
  assume {:verifier.code 0} true;
  call list_add($p0, $p1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 608, 3} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const __list_del: ref;
axiom (__list_del == $sub.ref(0, 17555));
procedure __list_del($p0: ref, $p1: ref)
{
  var $i2: i32;
  var $i3: i32;
  var $i4: i64;
  var $p5: ref;
  var $p6: ref;
$bb0:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 577, 16} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 577, 16} true;
  assume {:verifier.code 0} true;
  $i2 := $p2i.ref.i32($p1);
  call {:cexpr "__cil_tmp3"} boogie_si_record_i32($i2);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 578, 27} true;
  assume {:verifier.code 0} true;
  $i3 := $add.i32($i2, 4);
  call {:cexpr "__cil_tmp4"} boogie_si_record_i32($i3);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 579, 5} true;
  assume {:verifier.code 0} true;
  $i4 := $zext.i32.i64($i3);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 579, 5} true;
  assume {:verifier.code 0} true;
  $p5 := $i2p.i64.ref($i4);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 579, 38} true;
  assume {:verifier.code 0} true;
  $M.0 := $store.ref($M.0, $p5, $p0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 580, 3} true;
  assume {:verifier.code 0} true;
  $p6 := $bitcast.ref.ref($p0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 580, 32} true;
  assume {:verifier.code 0} true;
  $M.0 := $store.ref($M.0, $p6, $p1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 581, 3} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const list_add: ref;
axiom (list_add == $sub.ref(0, 18587));
procedure list_add($p0: ref, $p1: ref)
{
  var $p2: ref;
  var $p3: ref;
$bb0:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 588, 16} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 588, 16} true;
  assume {:verifier.code 0} true;
  $p2 := $bitcast.ref.ref($p1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 588, 16} true;
  assume {:verifier.code 0} true;
  $p3 := $load.ref($M.0, $p2);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 589, 3} true;
  assume {:verifier.code 0} true;
  call __list_add($p0, $p1, $p3);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 591, 3} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const __list_add: ref;
axiom (__list_add == $sub.ref(0, 19619));
procedure __list_add($p0: ref, $p1: ref, $p2: ref)
{
  var $i3: i32;
  var $i4: i32;
  var $i5: i64;
  var $p6: ref;
  var $p7: ref;
  var $i8: i32;
  var $i9: i32;
  var $i10: i64;
  var $p11: ref;
  var $p12: ref;
$bb0:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 562, 16} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 562, 16} true;
  assume {:verifier.code 0} true;
  $i3 := $p2i.ref.i32($p2);
  call {:cexpr "__cil_tmp4"} boogie_si_record_i32($i3);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 563, 27} true;
  assume {:verifier.code 0} true;
  $i4 := $add.i32($i3, 4);
  call {:cexpr "__cil_tmp5"} boogie_si_record_i32($i4);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 564, 5} true;
  assume {:verifier.code 0} true;
  $i5 := $zext.i32.i64($i4);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 564, 5} true;
  assume {:verifier.code 0} true;
  $p6 := $i2p.i64.ref($i5);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 564, 38} true;
  assume {:verifier.code 0} true;
  $M.0 := $store.ref($M.0, $p6, $p0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 565, 3} true;
  assume {:verifier.code 0} true;
  $p7 := $bitcast.ref.ref($p0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 565, 31} true;
  assume {:verifier.code 0} true;
  $M.0 := $store.ref($M.0, $p7, $p2);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 566, 16} true;
  assume {:verifier.code 0} true;
  $i8 := $p2i.ref.i32($p0);
  call {:cexpr "__cil_tmp6"} boogie_si_record_i32($i8);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 567, 27} true;
  assume {:verifier.code 0} true;
  $i9 := $add.i32($i8, 4);
  call {:cexpr "__cil_tmp7"} boogie_si_record_i32($i9);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 568, 5} true;
  assume {:verifier.code 0} true;
  $i10 := $zext.i32.i64($i9);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 568, 5} true;
  assume {:verifier.code 0} true;
  $p11 := $i2p.i64.ref($i10);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 568, 38} true;
  assume {:verifier.code 0} true;
  $M.0 := $store.ref($M.0, $p11, $p1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 569, 3} true;
  assume {:verifier.code 0} true;
  $p12 := $bitcast.ref.ref($p1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 569, 32} true;
  assume {:verifier.code 0} true;
  $M.0 := $store.ref($M.0, $p12, $p0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 570, 3} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const fail: ref;
axiom (fail == $sub.ref(0, 20651));
procedure fail()
{
$bb0:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 35, 3} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 35, 3} true;
  assume {:verifier.code 0} true;
  goto $bb1;
$bb1:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 36, 11} true;
  assume {:verifier.code 0} true;
  call reach_error();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 36, 25} true;
  assume {:verifier.code 0} true;
  call abort();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 36, 25} true;
  assume {:verifier.code 0} true;
  assume false;
$bb2:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 39, 1} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const abort: ref;
axiom (abort == $sub.ref(0, 21683));
procedure abort();
const gl_insert: ref;
axiom (gl_insert == $sub.ref(0, 22715));
procedure gl_insert($i0: i32)
{
  var $p1: ref;
  var $p2: ref;
  var $i3: i1;
  var $p4: ref;
  var $i5: i32;
  var $i6: i32;
  var $i7: i64;
  var $p8: ref;
  var $i9: i32;
  var $i10: i32;
  var $i11: i32;
  var $i12: i32;
  var $i13: i64;
  var $p14: ref;
  var $i15: i64;
  var $p16: ref;
  var $i17: i32;
  var $i18: i32;
  var $i19: i32;
  var $i20: i32;
  var $i21: i64;
  var $p22: ref;
  var $i23: i64;
  var $p24: ref;
$bb0:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 629, 9} true;
  assume {:verifier.code 0} true;
  call {:cexpr "gl_insert:arg:value"} boogie_si_record_i32($i0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 629, 9} true;
  assume {:verifier.code 0} true;
  call $p1 := malloc(20);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 630, 10} true;
  assume {:verifier.code 0} true;
  $p2 := $bitcast.ref.ref($p1);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 632, 9} true;
  assume {:verifier.code 0} true;
  $i3 := $ne.ref($p2, $0.ref);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 632, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i3} true;
  goto $bb1, $bb2;
$bb1:
  assume ($i3 == 1);
  assume {:verifier.code 0} true;
  goto $bb3;
$bb2:
  assume !(($i3 == 1));
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 634, 5} true;
  assume {:verifier.code 0} true;
  call abort();
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 634, 5} true;
  assume {:verifier.code 0} true;
  assume false;
$bb3:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 639, 3} true;
  assume {:verifier.code 0} true;
  $p4 := $bitcast.ref.ref($p2);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 639, 18} true;
  assume {:verifier.code 0} true;
  $M.0 := $store.i32($M.0, $p4, $i0);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 640, 16} true;
  assume {:verifier.code 0} true;
  $i5 := $p2i.ref.i32($p2);
  call {:cexpr "__cil_tmp5"} boogie_si_record_i32($i5);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 641, 27} true;
  assume {:verifier.code 0} true;
  $i6 := $add.i32($i5, 4);
  call {:cexpr "__cil_tmp6"} boogie_si_record_i32($i6);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 642, 16} true;
  assume {:verifier.code 0} true;
  $i7 := $zext.i32.i64($i6);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 642, 16} true;
  assume {:verifier.code 0} true;
  $p8 := $i2p.i64.ref($i7);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 643, 3} true;
  assume {:verifier.code 0} true;
  call list_add($p8, gl_list);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 646, 3} true;
  assume {:verifier.code 0} true;
  goto $bb4;
$bb4:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 646, 13} true;
  assume {:verifier.code 0} true;
  goto $bb5;
$bb5:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 648, 18} true;
  assume {:verifier.code 0} true;
  $i9 := $p2i.ref.i32($p2);
  call {:cexpr "__cil_tmp8"} boogie_si_record_i32($i9);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 649, 29} true;
  assume {:verifier.code 0} true;
  $i10 := $add.i32($i9, 12);
  call {:cexpr "__cil_tmp9"} boogie_si_record_i32($i10);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 650, 19} true;
  assume {:verifier.code 0} true;
  $i11 := $p2i.ref.i32($p2);
  call {:cexpr "__cil_tmp10"} boogie_si_record_i32($i11);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 651, 31} true;
  assume {:verifier.code 0} true;
  $i12 := $add.i32($i11, 12);
  call {:cexpr "__cil_tmp11"} boogie_si_record_i32($i12);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 652, 42} true;
  assume {:verifier.code 0} true;
  $i13 := $zext.i32.i64($i12);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 652, 42} true;
  assume {:verifier.code 0} true;
  $p14 := $i2p.i64.ref($i13);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 652, 7} true;
  assume {:verifier.code 0} true;
  $i15 := $zext.i32.i64($i10);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 652, 7} true;
  assume {:verifier.code 0} true;
  $p16 := $i2p.i64.ref($i15);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 652, 40} true;
  assume {:verifier.code 0} true;
  $M.0 := $store.ref($M.0, $p16, $p14);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 653, 19} true;
  assume {:verifier.code 0} true;
  $i17 := $p2i.ref.i32($p2);
  call {:cexpr "__cil_tmp12"} boogie_si_record_i32($i17);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 654, 31} true;
  assume {:verifier.code 0} true;
  $i18 := $add.i32($i17, 12);
  call {:cexpr "__cil_tmp13"} boogie_si_record_i32($i18);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 655, 19} true;
  assume {:verifier.code 0} true;
  $i19 := $p2i.ref.i32($p2);
  call {:cexpr "__cil_tmp14"} boogie_si_record_i32($i19);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 656, 31} true;
  assume {:verifier.code 0} true;
  $i20 := $add.i32($i19, 12);
  call {:cexpr "__cil_tmp15"} boogie_si_record_i32($i20);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 657, 43} true;
  assume {:verifier.code 0} true;
  $i21 := $zext.i32.i64($i20);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 657, 43} true;
  assume {:verifier.code 0} true;
  $p22 := $i2p.i64.ref($i21);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 657, 7} true;
  assume {:verifier.code 0} true;
  $i23 := $zext.i32.i64($i18);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 657, 7} true;
  assume {:verifier.code 0} true;
  $p24 := $i2p.i64.ref($i23);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 657, 41} true;
  assume {:verifier.code 0} true;
  $M.0 := $store.ref($M.0, $p24, $p22);
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 658, 5} true;
  assume {:verifier.code 0} true;
  goto $bb6;
$bb6:
  assume {:sourceloc "./output/bubble_sort-2_tmp.c", 662, 3} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const malloc: ref;
axiom (malloc == $sub.ref(0, 23747));
procedure malloc($i0: i32)
  returns ($r: ref)
{
  call $r := $malloc($zext.i32.i64($i0));
}
const __VERIFIER_assume: ref;
axiom (__VERIFIER_assume == $sub.ref(0, 24779));
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
axiom (__SMACK_code == $sub.ref(0, 25811));
procedure __SMACK_code.ref.i32($p0: ref, p.1: i32);
procedure __SMACK_code.ref($p0: ref);
const __SMACK_dummy: ref;
axiom (__SMACK_dummy == $sub.ref(0, 26843));
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
axiom (__SMACK_check_overflow == $sub.ref(0, 27875));
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
axiom (__SMACK_nondet_char == $sub.ref(0, 28907));
procedure __SMACK_nondet_char()
  returns ($r: i8);
const __SMACK_nondet_signed_char: ref;
axiom (__SMACK_nondet_signed_char == $sub.ref(0, 29939));
procedure __SMACK_nondet_signed_char()
  returns ($r: i8);
const __SMACK_nondet_unsigned_char: ref;
axiom (__SMACK_nondet_unsigned_char == $sub.ref(0, 30971));
procedure __SMACK_nondet_unsigned_char()
  returns ($r: i8);
const __SMACK_nondet_short: ref;
axiom (__SMACK_nondet_short == $sub.ref(0, 32003));
procedure __SMACK_nondet_short()
  returns ($r: i16);
const __SMACK_nondet_signed_short: ref;
axiom (__SMACK_nondet_signed_short == $sub.ref(0, 33035));
procedure __SMACK_nondet_signed_short()
  returns ($r: i16);
const __SMACK_nondet_signed_short_int: ref;
axiom (__SMACK_nondet_signed_short_int == $sub.ref(0, 34067));
procedure __SMACK_nondet_signed_short_int()
  returns ($r: i16);
const __SMACK_nondet_unsigned_short: ref;
axiom (__SMACK_nondet_unsigned_short == $sub.ref(0, 35099));
procedure __SMACK_nondet_unsigned_short()
  returns ($r: i16);
const __SMACK_nondet_unsigned_short_int: ref;
axiom (__SMACK_nondet_unsigned_short_int == $sub.ref(0, 36131));
procedure __SMACK_nondet_unsigned_short_int()
  returns ($r: i16);
const __VERIFIER_nondet_int: ref;
axiom (__VERIFIER_nondet_int == $sub.ref(0, 37163));
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
axiom (__SMACK_nondet_int == $sub.ref(0, 38195));
procedure __SMACK_nondet_int()
  returns ($r: i32);
const __SMACK_nondet_signed_int: ref;
axiom (__SMACK_nondet_signed_int == $sub.ref(0, 39227));
procedure __SMACK_nondet_signed_int()
  returns ($r: i32);
const __SMACK_nondet_unsigned: ref;
axiom (__SMACK_nondet_unsigned == $sub.ref(0, 40259));
procedure __SMACK_nondet_unsigned()
  returns ($r: i32);
const __SMACK_nondet_unsigned_int: ref;
axiom (__SMACK_nondet_unsigned_int == $sub.ref(0, 41291));
procedure __SMACK_nondet_unsigned_int()
  returns ($r: i32);
const __SMACK_nondet_long: ref;
axiom (__SMACK_nondet_long == $sub.ref(0, 42323));
procedure __SMACK_nondet_long()
  returns ($r: i64);
const __SMACK_nondet_long_int: ref;
axiom (__SMACK_nondet_long_int == $sub.ref(0, 43355));
procedure __SMACK_nondet_long_int()
  returns ($r: i64);
const __SMACK_nondet_signed_long: ref;
axiom (__SMACK_nondet_signed_long == $sub.ref(0, 44387));
procedure __SMACK_nondet_signed_long()
  returns ($r: i64);
const __SMACK_nondet_signed_long_int: ref;
axiom (__SMACK_nondet_signed_long_int == $sub.ref(0, 45419));
procedure __SMACK_nondet_signed_long_int()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long: ref;
axiom (__SMACK_nondet_unsigned_long == $sub.ref(0, 46451));
procedure __SMACK_nondet_unsigned_long()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_int: ref;
axiom (__SMACK_nondet_unsigned_long_int == $sub.ref(0, 47483));
procedure __SMACK_nondet_unsigned_long_int()
  returns ($r: i64);
const __SMACK_nondet_long_long: ref;
axiom (__SMACK_nondet_long_long == $sub.ref(0, 48515));
procedure __SMACK_nondet_long_long()
  returns ($r: i64);
const __SMACK_nondet_long_long_int: ref;
axiom (__SMACK_nondet_long_long_int == $sub.ref(0, 49547));
procedure __SMACK_nondet_long_long_int()
  returns ($r: i64);
const __SMACK_nondet_signed_long_long: ref;
axiom (__SMACK_nondet_signed_long_long == $sub.ref(0, 50579));
procedure __SMACK_nondet_signed_long_long()
  returns ($r: i64);
const __SMACK_nondet_signed_long_long_int: ref;
axiom (__SMACK_nondet_signed_long_long_int == $sub.ref(0, 51611));
procedure __SMACK_nondet_signed_long_long_int()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_long: ref;
axiom (__SMACK_nondet_unsigned_long_long == $sub.ref(0, 52643));
procedure __SMACK_nondet_unsigned_long_long()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_long_int: ref;
axiom (__SMACK_nondet_unsigned_long_long_int == $sub.ref(0, 53675));
procedure __SMACK_nondet_unsigned_long_long_int()
  returns ($r: i64);
const __SMACK_decls: ref;
axiom (__SMACK_decls == $sub.ref(0, 54707));
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
axiom (__SMACK_top_decl == $sub.ref(0, 55739));
procedure __SMACK_top_decl.ref($p0: ref);
const __SMACK_init_func_memory_model: ref;
axiom (__SMACK_init_func_memory_model == $sub.ref(0, 56771));
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
axiom (llvm.dbg.value == $sub.ref(0, 57803));
procedure llvm.dbg.value($p0: ref, $p1: ref, $p2: ref);
const __SMACK_static_init: ref;
axiom (__SMACK_static_init == $sub.ref(0, 58835));
procedure __SMACK_static_init()
{
$bb0:
  $M.0 := $store.ref($M.0, gl_list, gl_list);
  $M.0 := $store.ref($M.0, $add.ref($add.ref(gl_list, $mul.ref(0, 16)), $mul.ref(8, 1)), gl_list);
  $M.1 := .str.1.3;
  $M.2 := 0;
  call {:cexpr "errno_global"} boogie_si_record_i32(0);
  $exn := false;
  return;
}
procedure boogie_si_record_i32(x: i32);
procedure boogie_si_record_i64(x: i64);
procedure boogie_si_record_i8(x: i8);
procedure boogie_si_record_ref(x: ref);
procedure $initialize()
{
  call __SMACK_static_init();
  call __SMACK_init_func_memory_model();
  return;
}
