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
axiom ($GLOBALS_BOTTOM == $sub.ref(0, 42309));
axiom ($EXTERNS_BOTTOM == $add.ref($GLOBALS_BOTTOM, $sub.ref(0, 32768)));
axiom ($MALLOC_TOP == 9223372036854775807);
function $isExternal(p: ref) returns (bool) { $slt.ref.bool(p, $EXTERNS_BOTTOM) }

// SMT bit-vector/integer conversion
function {:builtin "(_ int2bv 64)"} $int2bv.64(i: i64) returns (bv64);
function {:builtin "bv2int"} $bv2int.64(i: bv64) returns (i64);

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
function {:builtin "rem"} $srem.i1(i1: i1, i2: i1) returns (i1);
function {:builtin "rem"} $srem.i5(i1: i5, i2: i5) returns (i5);
function {:builtin "rem"} $srem.i6(i1: i6, i2: i6) returns (i6);
function {:builtin "rem"} $srem.i8(i1: i8, i2: i8) returns (i8);
function {:builtin "rem"} $srem.i16(i1: i16, i2: i16) returns (i16);
function {:builtin "rem"} $srem.i24(i1: i24, i2: i24) returns (i24);
function {:builtin "rem"} $srem.i32(i1: i32, i2: i32) returns (i32);
function {:builtin "rem"} $srem.i40(i1: i40, i2: i40) returns (i40);
function {:builtin "rem"} $srem.i48(i1: i48, i2: i48) returns (i48);
function {:builtin "rem"} $srem.i56(i1: i56, i2: i56) returns (i56);
function {:builtin "rem"} $srem.i64(i1: i64, i2: i64) returns (i64);
function {:builtin "rem"} $srem.i80(i1: i80, i2: i80) returns (i80);
function {:builtin "rem"} $srem.i88(i1: i88, i2: i88) returns (i88);
function {:builtin "rem"} $srem.i96(i1: i96, i2: i96) returns (i96);
function {:builtin "rem"} $srem.i128(i1: i128, i2: i128) returns (i128);
function {:builtin "rem"} $srem.i160(i1: i160, i2: i160) returns (i160);
function {:builtin "rem"} $srem.i256(i1: i256, i2: i256) returns (i256);
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
function {:builtin "rem"} $urem.i1(i1: i1, i2: i1) returns (i1);
function {:builtin "rem"} $urem.i5(i1: i5, i2: i5) returns (i5);
function {:builtin "rem"} $urem.i6(i1: i6, i2: i6) returns (i6);
function {:builtin "rem"} $urem.i8(i1: i8, i2: i8) returns (i8);
function {:builtin "rem"} $urem.i16(i1: i16, i2: i16) returns (i16);
function {:builtin "rem"} $urem.i24(i1: i24, i2: i24) returns (i24);
function {:builtin "rem"} $urem.i32(i1: i32, i2: i32) returns (i32);
function {:builtin "rem"} $urem.i40(i1: i40, i2: i40) returns (i40);
function {:builtin "rem"} $urem.i48(i1: i48, i2: i48) returns (i48);
function {:builtin "rem"} $urem.i56(i1: i56, i2: i56) returns (i56);
function {:builtin "rem"} $urem.i64(i1: i64, i2: i64) returns (i64);
function {:builtin "rem"} $urem.i80(i1: i80, i2: i80) returns (i80);
function {:builtin "rem"} $urem.i88(i1: i88, i2: i88) returns (i88);
function {:builtin "rem"} $urem.i96(i1: i96, i2: i96) returns (i96);
function {:builtin "rem"} $urem.i128(i1: i128, i2: i128) returns (i128);
function {:builtin "rem"} $urem.i160(i1: i160, i2: i160) returns (i160);
function {:builtin "rem"} $urem.i256(i1: i256, i2: i256) returns (i256);
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
function {:inline} $smin.i1(i1: i1, i2: i1) returns (i1) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i5(i1: i5, i2: i5) returns (i5) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i6(i1: i6, i2: i6) returns (i6) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i8(i1: i8, i2: i8) returns (i8) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i16(i1: i16, i2: i16) returns (i16) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i24(i1: i24, i2: i24) returns (i24) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i32(i1: i32, i2: i32) returns (i32) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i40(i1: i40, i2: i40) returns (i40) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i48(i1: i48, i2: i48) returns (i48) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i56(i1: i56, i2: i56) returns (i56) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i64(i1: i64, i2: i64) returns (i64) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i80(i1: i80, i2: i80) returns (i80) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i88(i1: i88, i2: i88) returns (i88) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i96(i1: i96, i2: i96) returns (i96) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i128(i1: i128, i2: i128) returns (i128) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i160(i1: i160, i2: i160) returns (i160) { if (i1 < i2) then i1 else i2 }
function {:inline} $smin.i256(i1: i256, i2: i256) returns (i256) { if (i1 < i2) then i1 else i2 }
function {:inline} $smax.i1(i1: i1, i2: i1) returns (i1) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i5(i1: i5, i2: i5) returns (i5) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i6(i1: i6, i2: i6) returns (i6) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i8(i1: i8, i2: i8) returns (i8) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i16(i1: i16, i2: i16) returns (i16) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i24(i1: i24, i2: i24) returns (i24) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i32(i1: i32, i2: i32) returns (i32) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i40(i1: i40, i2: i40) returns (i40) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i48(i1: i48, i2: i48) returns (i48) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i56(i1: i56, i2: i56) returns (i56) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i64(i1: i64, i2: i64) returns (i64) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i80(i1: i80, i2: i80) returns (i80) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i88(i1: i88, i2: i88) returns (i88) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i96(i1: i96, i2: i96) returns (i96) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i128(i1: i128, i2: i128) returns (i128) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i160(i1: i160, i2: i160) returns (i160) { if (i2 < i1) then i1 else i2 }
function {:inline} $smax.i256(i1: i256, i2: i256) returns (i256) { if (i2 < i1) then i1 else i2 }
function {:inline} $umin.i1(i1: i1, i2: i1) returns (i1) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i5(i1: i5, i2: i5) returns (i5) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i6(i1: i6, i2: i6) returns (i6) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i8(i1: i8, i2: i8) returns (i8) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i16(i1: i16, i2: i16) returns (i16) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i24(i1: i24, i2: i24) returns (i24) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i32(i1: i32, i2: i32) returns (i32) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i40(i1: i40, i2: i40) returns (i40) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i48(i1: i48, i2: i48) returns (i48) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i56(i1: i56, i2: i56) returns (i56) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i64(i1: i64, i2: i64) returns (i64) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i80(i1: i80, i2: i80) returns (i80) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i88(i1: i88, i2: i88) returns (i88) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i96(i1: i96, i2: i96) returns (i96) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i128(i1: i128, i2: i128) returns (i128) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i160(i1: i160, i2: i160) returns (i160) { if (i1 < i2) then i1 else i2 }
function {:inline} $umin.i256(i1: i256, i2: i256) returns (i256) { if (i1 < i2) then i1 else i2 }
function {:inline} $umax.i1(i1: i1, i2: i1) returns (i1) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i5(i1: i5, i2: i5) returns (i5) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i6(i1: i6, i2: i6) returns (i6) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i8(i1: i8, i2: i8) returns (i8) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i16(i1: i16, i2: i16) returns (i16) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i24(i1: i24, i2: i24) returns (i24) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i32(i1: i32, i2: i32) returns (i32) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i40(i1: i40, i2: i40) returns (i40) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i48(i1: i48, i2: i48) returns (i48) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i56(i1: i56, i2: i56) returns (i56) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i64(i1: i64, i2: i64) returns (i64) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i80(i1: i80, i2: i80) returns (i80) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i88(i1: i88, i2: i88) returns (i88) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i96(i1: i96, i2: i96) returns (i96) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i128(i1: i128, i2: i128) returns (i128) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i160(i1: i160, i2: i160) returns (i160) { if (i2 < i1) then i1 else i2 }
function {:inline} $umax.i256(i1: i256, i2: i256) returns (i256) { if (i2 < i1) then i1 else i2 }
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
function {:inline} $ule.i1(i1: i1, i2: i1) returns (i1) { if $ule.i1.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i5(i1: i5, i2: i5) returns (i1) { if $ule.i5.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i6(i1: i6, i2: i6) returns (i1) { if $ule.i6.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i8(i1: i8, i2: i8) returns (i1) { if $ule.i8.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i16(i1: i16, i2: i16) returns (i1) { if $ule.i16.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i24(i1: i24, i2: i24) returns (i1) { if $ule.i24.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i32(i1: i32, i2: i32) returns (i1) { if $ule.i32.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i40(i1: i40, i2: i40) returns (i1) { if $ule.i40.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i48(i1: i48, i2: i48) returns (i1) { if $ule.i48.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i56(i1: i56, i2: i56) returns (i1) { if $ule.i56.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i64(i1: i64, i2: i64) returns (i1) { if $ule.i64.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i80(i1: i80, i2: i80) returns (i1) { if $ule.i80.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i88(i1: i88, i2: i88) returns (i1) { if $ule.i88.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i96(i1: i96, i2: i96) returns (i1) { if $ule.i96.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i128(i1: i128, i2: i128) returns (i1) { if $ule.i128.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i160(i1: i160, i2: i160) returns (i1) { if $ule.i160.bool(i1, i2) then 1 else 0 }
function {:inline} $ule.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 <= i2) }
function {:inline} $ule.i256(i1: i256, i2: i256) returns (i1) { if $ule.i256.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 < i2) }
function {:inline} $ult.i1(i1: i1, i2: i1) returns (i1) { if $ult.i1.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 < i2) }
function {:inline} $ult.i5(i1: i5, i2: i5) returns (i1) { if $ult.i5.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 < i2) }
function {:inline} $ult.i6(i1: i6, i2: i6) returns (i1) { if $ult.i6.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 < i2) }
function {:inline} $ult.i8(i1: i8, i2: i8) returns (i1) { if $ult.i8.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 < i2) }
function {:inline} $ult.i16(i1: i16, i2: i16) returns (i1) { if $ult.i16.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 < i2) }
function {:inline} $ult.i24(i1: i24, i2: i24) returns (i1) { if $ult.i24.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 < i2) }
function {:inline} $ult.i32(i1: i32, i2: i32) returns (i1) { if $ult.i32.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 < i2) }
function {:inline} $ult.i40(i1: i40, i2: i40) returns (i1) { if $ult.i40.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 < i2) }
function {:inline} $ult.i48(i1: i48, i2: i48) returns (i1) { if $ult.i48.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 < i2) }
function {:inline} $ult.i56(i1: i56, i2: i56) returns (i1) { if $ult.i56.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 < i2) }
function {:inline} $ult.i64(i1: i64, i2: i64) returns (i1) { if $ult.i64.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 < i2) }
function {:inline} $ult.i80(i1: i80, i2: i80) returns (i1) { if $ult.i80.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 < i2) }
function {:inline} $ult.i88(i1: i88, i2: i88) returns (i1) { if $ult.i88.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 < i2) }
function {:inline} $ult.i96(i1: i96, i2: i96) returns (i1) { if $ult.i96.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 < i2) }
function {:inline} $ult.i128(i1: i128, i2: i128) returns (i1) { if $ult.i128.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 < i2) }
function {:inline} $ult.i160(i1: i160, i2: i160) returns (i1) { if $ult.i160.bool(i1, i2) then 1 else 0 }
function {:inline} $ult.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 < i2) }
function {:inline} $ult.i256(i1: i256, i2: i256) returns (i1) { if $ult.i256.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i1(i1: i1, i2: i1) returns (i1) { if $uge.i1.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i5(i1: i5, i2: i5) returns (i1) { if $uge.i5.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i6(i1: i6, i2: i6) returns (i1) { if $uge.i6.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i8(i1: i8, i2: i8) returns (i1) { if $uge.i8.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i16(i1: i16, i2: i16) returns (i1) { if $uge.i16.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i24(i1: i24, i2: i24) returns (i1) { if $uge.i24.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i32(i1: i32, i2: i32) returns (i1) { if $uge.i32.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i40(i1: i40, i2: i40) returns (i1) { if $uge.i40.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i48(i1: i48, i2: i48) returns (i1) { if $uge.i48.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i56(i1: i56, i2: i56) returns (i1) { if $uge.i56.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i64(i1: i64, i2: i64) returns (i1) { if $uge.i64.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i80(i1: i80, i2: i80) returns (i1) { if $uge.i80.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i88(i1: i88, i2: i88) returns (i1) { if $uge.i88.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i96(i1: i96, i2: i96) returns (i1) { if $uge.i96.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i128(i1: i128, i2: i128) returns (i1) { if $uge.i128.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i160(i1: i160, i2: i160) returns (i1) { if $uge.i160.bool(i1, i2) then 1 else 0 }
function {:inline} $uge.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 >= i2) }
function {:inline} $uge.i256(i1: i256, i2: i256) returns (i1) { if $uge.i256.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i1(i1: i1, i2: i1) returns (i1) { if $ugt.i1.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i5(i1: i5, i2: i5) returns (i1) { if $ugt.i5.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i6(i1: i6, i2: i6) returns (i1) { if $ugt.i6.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i8(i1: i8, i2: i8) returns (i1) { if $ugt.i8.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i16(i1: i16, i2: i16) returns (i1) { if $ugt.i16.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i24(i1: i24, i2: i24) returns (i1) { if $ugt.i24.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i32(i1: i32, i2: i32) returns (i1) { if $ugt.i32.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i40(i1: i40, i2: i40) returns (i1) { if $ugt.i40.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i48(i1: i48, i2: i48) returns (i1) { if $ugt.i48.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i56(i1: i56, i2: i56) returns (i1) { if $ugt.i56.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i64(i1: i64, i2: i64) returns (i1) { if $ugt.i64.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i80(i1: i80, i2: i80) returns (i1) { if $ugt.i80.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i88(i1: i88, i2: i88) returns (i1) { if $ugt.i88.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i96(i1: i96, i2: i96) returns (i1) { if $ugt.i96.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i128(i1: i128, i2: i128) returns (i1) { if $ugt.i128.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i160(i1: i160, i2: i160) returns (i1) { if $ugt.i160.bool(i1, i2) then 1 else 0 }
function {:inline} $ugt.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 > i2) }
function {:inline} $ugt.i256(i1: i256, i2: i256) returns (i1) { if $ugt.i256.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i1(i1: i1, i2: i1) returns (i1) { if $sle.i1.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i5(i1: i5, i2: i5) returns (i1) { if $sle.i5.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i6(i1: i6, i2: i6) returns (i1) { if $sle.i6.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i8(i1: i8, i2: i8) returns (i1) { if $sle.i8.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i16(i1: i16, i2: i16) returns (i1) { if $sle.i16.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i24(i1: i24, i2: i24) returns (i1) { if $sle.i24.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i32(i1: i32, i2: i32) returns (i1) { if $sle.i32.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i40(i1: i40, i2: i40) returns (i1) { if $sle.i40.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i48(i1: i48, i2: i48) returns (i1) { if $sle.i48.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i56(i1: i56, i2: i56) returns (i1) { if $sle.i56.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i64(i1: i64, i2: i64) returns (i1) { if $sle.i64.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i80(i1: i80, i2: i80) returns (i1) { if $sle.i80.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i88(i1: i88, i2: i88) returns (i1) { if $sle.i88.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i96(i1: i96, i2: i96) returns (i1) { if $sle.i96.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i128(i1: i128, i2: i128) returns (i1) { if $sle.i128.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i160(i1: i160, i2: i160) returns (i1) { if $sle.i160.bool(i1, i2) then 1 else 0 }
function {:inline} $sle.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 <= i2) }
function {:inline} $sle.i256(i1: i256, i2: i256) returns (i1) { if $sle.i256.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 < i2) }
function {:inline} $slt.i1(i1: i1, i2: i1) returns (i1) { if $slt.i1.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 < i2) }
function {:inline} $slt.i5(i1: i5, i2: i5) returns (i1) { if $slt.i5.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 < i2) }
function {:inline} $slt.i6(i1: i6, i2: i6) returns (i1) { if $slt.i6.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 < i2) }
function {:inline} $slt.i8(i1: i8, i2: i8) returns (i1) { if $slt.i8.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 < i2) }
function {:inline} $slt.i16(i1: i16, i2: i16) returns (i1) { if $slt.i16.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 < i2) }
function {:inline} $slt.i24(i1: i24, i2: i24) returns (i1) { if $slt.i24.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 < i2) }
function {:inline} $slt.i32(i1: i32, i2: i32) returns (i1) { if $slt.i32.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 < i2) }
function {:inline} $slt.i40(i1: i40, i2: i40) returns (i1) { if $slt.i40.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 < i2) }
function {:inline} $slt.i48(i1: i48, i2: i48) returns (i1) { if $slt.i48.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 < i2) }
function {:inline} $slt.i56(i1: i56, i2: i56) returns (i1) { if $slt.i56.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 < i2) }
function {:inline} $slt.i64(i1: i64, i2: i64) returns (i1) { if $slt.i64.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 < i2) }
function {:inline} $slt.i80(i1: i80, i2: i80) returns (i1) { if $slt.i80.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 < i2) }
function {:inline} $slt.i88(i1: i88, i2: i88) returns (i1) { if $slt.i88.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 < i2) }
function {:inline} $slt.i96(i1: i96, i2: i96) returns (i1) { if $slt.i96.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 < i2) }
function {:inline} $slt.i128(i1: i128, i2: i128) returns (i1) { if $slt.i128.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 < i2) }
function {:inline} $slt.i160(i1: i160, i2: i160) returns (i1) { if $slt.i160.bool(i1, i2) then 1 else 0 }
function {:inline} $slt.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 < i2) }
function {:inline} $slt.i256(i1: i256, i2: i256) returns (i1) { if $slt.i256.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i1(i1: i1, i2: i1) returns (i1) { if $sge.i1.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i5(i1: i5, i2: i5) returns (i1) { if $sge.i5.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i6(i1: i6, i2: i6) returns (i1) { if $sge.i6.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i8(i1: i8, i2: i8) returns (i1) { if $sge.i8.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i16(i1: i16, i2: i16) returns (i1) { if $sge.i16.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i24(i1: i24, i2: i24) returns (i1) { if $sge.i24.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i32(i1: i32, i2: i32) returns (i1) { if $sge.i32.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i40(i1: i40, i2: i40) returns (i1) { if $sge.i40.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i48(i1: i48, i2: i48) returns (i1) { if $sge.i48.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i56(i1: i56, i2: i56) returns (i1) { if $sge.i56.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i64(i1: i64, i2: i64) returns (i1) { if $sge.i64.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i80(i1: i80, i2: i80) returns (i1) { if $sge.i80.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i88(i1: i88, i2: i88) returns (i1) { if $sge.i88.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i96(i1: i96, i2: i96) returns (i1) { if $sge.i96.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i128(i1: i128, i2: i128) returns (i1) { if $sge.i128.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i160(i1: i160, i2: i160) returns (i1) { if $sge.i160.bool(i1, i2) then 1 else 0 }
function {:inline} $sge.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 >= i2) }
function {:inline} $sge.i256(i1: i256, i2: i256) returns (i1) { if $sge.i256.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i1(i1: i1, i2: i1) returns (i1) { if $sgt.i1.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i5(i1: i5, i2: i5) returns (i1) { if $sgt.i5.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i6(i1: i6, i2: i6) returns (i1) { if $sgt.i6.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i8(i1: i8, i2: i8) returns (i1) { if $sgt.i8.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i16(i1: i16, i2: i16) returns (i1) { if $sgt.i16.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i24(i1: i24, i2: i24) returns (i1) { if $sgt.i24.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i32(i1: i32, i2: i32) returns (i1) { if $sgt.i32.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i40(i1: i40, i2: i40) returns (i1) { if $sgt.i40.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i48(i1: i48, i2: i48) returns (i1) { if $sgt.i48.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i56(i1: i56, i2: i56) returns (i1) { if $sgt.i56.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i64(i1: i64, i2: i64) returns (i1) { if $sgt.i64.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i80(i1: i80, i2: i80) returns (i1) { if $sgt.i80.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i88(i1: i88, i2: i88) returns (i1) { if $sgt.i88.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i96(i1: i96, i2: i96) returns (i1) { if $sgt.i96.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i128(i1: i128, i2: i128) returns (i1) { if $sgt.i128.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i160(i1: i160, i2: i160) returns (i1) { if $sgt.i160.bool(i1, i2) then 1 else 0 }
function {:inline} $sgt.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 > i2) }
function {:inline} $sgt.i256(i1: i256, i2: i256) returns (i1) { if $sgt.i256.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 == i2) }
function {:inline} $eq.i1(i1: i1, i2: i1) returns (i1) { if $eq.i1.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 == i2) }
function {:inline} $eq.i5(i1: i5, i2: i5) returns (i1) { if $eq.i5.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 == i2) }
function {:inline} $eq.i6(i1: i6, i2: i6) returns (i1) { if $eq.i6.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 == i2) }
function {:inline} $eq.i8(i1: i8, i2: i8) returns (i1) { if $eq.i8.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 == i2) }
function {:inline} $eq.i16(i1: i16, i2: i16) returns (i1) { if $eq.i16.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 == i2) }
function {:inline} $eq.i24(i1: i24, i2: i24) returns (i1) { if $eq.i24.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 == i2) }
function {:inline} $eq.i32(i1: i32, i2: i32) returns (i1) { if $eq.i32.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 == i2) }
function {:inline} $eq.i40(i1: i40, i2: i40) returns (i1) { if $eq.i40.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 == i2) }
function {:inline} $eq.i48(i1: i48, i2: i48) returns (i1) { if $eq.i48.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 == i2) }
function {:inline} $eq.i56(i1: i56, i2: i56) returns (i1) { if $eq.i56.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 == i2) }
function {:inline} $eq.i64(i1: i64, i2: i64) returns (i1) { if $eq.i64.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 == i2) }
function {:inline} $eq.i80(i1: i80, i2: i80) returns (i1) { if $eq.i80.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 == i2) }
function {:inline} $eq.i88(i1: i88, i2: i88) returns (i1) { if $eq.i88.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 == i2) }
function {:inline} $eq.i96(i1: i96, i2: i96) returns (i1) { if $eq.i96.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 == i2) }
function {:inline} $eq.i128(i1: i128, i2: i128) returns (i1) { if $eq.i128.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 == i2) }
function {:inline} $eq.i160(i1: i160, i2: i160) returns (i1) { if $eq.i160.bool(i1, i2) then 1 else 0 }
function {:inline} $eq.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 == i2) }
function {:inline} $eq.i256(i1: i256, i2: i256) returns (i1) { if $eq.i256.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i1.bool(i1: i1, i2: i1) returns (bool) { (i1 != i2) }
function {:inline} $ne.i1(i1: i1, i2: i1) returns (i1) { if $ne.i1.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i5.bool(i1: i5, i2: i5) returns (bool) { (i1 != i2) }
function {:inline} $ne.i5(i1: i5, i2: i5) returns (i1) { if $ne.i5.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i6.bool(i1: i6, i2: i6) returns (bool) { (i1 != i2) }
function {:inline} $ne.i6(i1: i6, i2: i6) returns (i1) { if $ne.i6.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i8.bool(i1: i8, i2: i8) returns (bool) { (i1 != i2) }
function {:inline} $ne.i8(i1: i8, i2: i8) returns (i1) { if $ne.i8.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i16.bool(i1: i16, i2: i16) returns (bool) { (i1 != i2) }
function {:inline} $ne.i16(i1: i16, i2: i16) returns (i1) { if $ne.i16.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i24.bool(i1: i24, i2: i24) returns (bool) { (i1 != i2) }
function {:inline} $ne.i24(i1: i24, i2: i24) returns (i1) { if $ne.i24.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i32.bool(i1: i32, i2: i32) returns (bool) { (i1 != i2) }
function {:inline} $ne.i32(i1: i32, i2: i32) returns (i1) { if $ne.i32.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i40.bool(i1: i40, i2: i40) returns (bool) { (i1 != i2) }
function {:inline} $ne.i40(i1: i40, i2: i40) returns (i1) { if $ne.i40.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i48.bool(i1: i48, i2: i48) returns (bool) { (i1 != i2) }
function {:inline} $ne.i48(i1: i48, i2: i48) returns (i1) { if $ne.i48.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i56.bool(i1: i56, i2: i56) returns (bool) { (i1 != i2) }
function {:inline} $ne.i56(i1: i56, i2: i56) returns (i1) { if $ne.i56.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i64.bool(i1: i64, i2: i64) returns (bool) { (i1 != i2) }
function {:inline} $ne.i64(i1: i64, i2: i64) returns (i1) { if $ne.i64.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i80.bool(i1: i80, i2: i80) returns (bool) { (i1 != i2) }
function {:inline} $ne.i80(i1: i80, i2: i80) returns (i1) { if $ne.i80.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i88.bool(i1: i88, i2: i88) returns (bool) { (i1 != i2) }
function {:inline} $ne.i88(i1: i88, i2: i88) returns (i1) { if $ne.i88.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i96.bool(i1: i96, i2: i96) returns (bool) { (i1 != i2) }
function {:inline} $ne.i96(i1: i96, i2: i96) returns (i1) { if $ne.i96.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i128.bool(i1: i128, i2: i128) returns (bool) { (i1 != i2) }
function {:inline} $ne.i128(i1: i128, i2: i128) returns (i1) { if $ne.i128.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i160.bool(i1: i160, i2: i160) returns (bool) { (i1 != i2) }
function {:inline} $ne.i160(i1: i160, i2: i160) returns (i1) { if $ne.i160.bool(i1, i2) then 1 else 0 }
function {:inline} $ne.i256.bool(i1: i256, i2: i256) returns (bool) { (i1 != i2) }
function {:inline} $ne.i256(i1: i256, i2: i256) returns (i1) { if $ne.i256.bool(i1, i2) then 1 else 0 }
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
const env_value_str: ref;
axiom (env_value_str == $sub.ref(0, 1032));
const {:count 3} .str.1.5: ref;
axiom (.str.1.5 == $sub.ref(0, 2059));
const {:count 14} .str.14: ref;
axiom (.str.14 == $sub.ref(0, 3097));
const errno_global: ref;
axiom (errno_global == $sub.ref(0, 4125));
const __VERIFIER_assert: ref;
axiom (__VERIFIER_assert == $sub.ref(0, 5157));
procedure __VERIFIER_assert($i0: i32)
{
  var $i1: i1;
$bb0:
  assume {:sourceloc "./output/dijkstra_tmp.c", 10, 10} true;
  assume {:verifier.code 0} true;
  call {:cexpr "__VERIFIER_assert:arg:cond"} boogie_si_record_i32($i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 10, 10} true;
  assume {:verifier.code 0} true;
  $i1 := $ne.i32($i0, 0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 10, 9} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i1} true;
  goto $bb1, $bb2;
$bb1:
  assume ($i1 == 1);
  assume {:sourceloc "./output/dijkstra_tmp.c", 14, 5} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
$bb2:
  assume !(($i1 == 1));
  assume {:sourceloc "./output/dijkstra_tmp.c", 10, 18} true;
  assume {:verifier.code 0} true;
  goto $bb3;
$bb3:
  assume {:sourceloc "./output/dijkstra_tmp.c", 12, 9} true;
  assume {:verifier.code 0} true;
  call __VERIFIER_error();
  assume {:sourceloc "./output/dijkstra_tmp.c", 12, 9} true;
  assume {:verifier.code 0} true;
  assume false;
}
const main: ref;
axiom (main == $sub.ref(0, 6189));
procedure main()
  returns ($r: i32)
{
  var $i0: i32;
  var $i1: i32;
  var $i2: i1;
  var $i3: i32;
  var $i4: i32;
  var $i5: i32;
  var $i6: i32;
  var $i7: i32;
  var $i8: i32;
  var $i9: i32;
  var $i10: i1;
  var $i11: i32;
  var $i12: i32;
  var $i13: i32;
  var $i14: i32;
  var $i15: i32;
  var $i16: i1;
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
  var $i31: i32;
  var $i32: i32;
  var $i33: i32;
  var $i34: i32;
  var $i35: i32;
  var $i36: i32;
  var $i37: i32;
  var $i38: i32;
  var $i39: i32;
  var $i40: i32;
  var $i41: i32;
  var $i42: i32;
  var $i43: i1;
  var $i44: i32;
  var $i45: i32;
  var $i46: i32;
  var $i47: i32;
  var $i48: i32;
  var $i49: i32;
  var $i50: i32;
  var $i51: i32;
  var $i52: i32;
  var $i53: i32;
  var $i54: i32;
  var $i55: i32;
  var $i56: i32;
  var $i57: i32;
  var $i58: i32;
  var $i59: i32;
  var $i60: i32;
  var $i61: i32;
  var $i62: i32;
  var $i63: i32;
  var $i64: i32;
  var $i65: i32;
  var $i66: i32;
  var $i67: i32;
  var $i68: i32;
  var $i69: i32;
  var $i70: i32;
  var $i71: i32;
  var $i72: i32;
  var $i73: i32;
  var $i74: i32;
  var $i75: i32;
  var $i76: i1;
  var $i77: i32;
  var $i78: i32;
  var $i79: i32;
  var $i80: i32;
  var $i81: i32;
  var $i82: i32;
  var $i83: i32;
  var $i84: i32;
  var $i85: i32;
  var $i86: i32;
  var $i87: i32;
  var $i88: i32;
  var $i89: i32;
  var $i90: i32;
  var $i91: i32;
  var $i92: i32;
  var $i93: i32;
  var $i94: i32;
  var $i95: i32;
  var $i96: i32;
  var $i97: i32;
  var $i98: i32;
  var $i99: i1;
  var $i100: i32;
  var $i101: i32;
  var $i102: i32;
  var $i103: i32;
  var $i104: i32;
  var $i105: i32;
  var $i106: i1;
  var $i107: i32;
  var $i108: i1;
  var $i109: i32;
  var $i110: i32;
  var $i111: i32;
  var $i112: i1;
  var $i115: i32;
  var $i116: i32;
  var $i113: i32;
  var $i114: i32;
  var $i117: i32;
  var $i118: i32;
  var $i119: i32;
  var $i120: i32;
  var $i121: i32;
  var $i122: i32;
  var $i123: i32;
  var $i124: i32;
  var $i125: i32;
  var $i126: i32;
  var $i127: i32;
  var $i128: i32;
  var $i129: i32;
  var $i130: i32;
  var $i131: i32;
  var $i132: i32;
  var $i133: i32;
  var $i134: i1;
  var $i135: i32;
  var $i136: i32;
  var $i137: i32;
  var $i138: i32;
  var $i139: i1;
  var $i140: i32;
  var $i141: i32;
  var $i142: i32;
  var $i143: i32;
  var $i144: i32;
  var $i145: i32;
  var $i146: i32;
  var $i147: i32;
  var $i148: i32;
  var $i149: i32;
  var $i150: i32;
  var $i151: i32;
  var $i152: i32;
  var $i153: i32;
  var $i154: i32;
  var $i155: i32;
  var $i156: i1;
  var $i157: i32;
$bb0:
  call $initialize();
  assume {:sourceloc "./output/dijkstra_tmp.c", 20, 9} true;
  assume {:verifier.code 1} true;
  call {:cexpr "smack:entry:main"} boogie_si_record_ref(main);
  assume {:sourceloc "./output/dijkstra_tmp.c", 20, 9} true;
  assume {:verifier.code 1} true;
  call $i0 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i0);
  call {:cexpr "n"} boogie_si_record_i32($i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 26, 5} true;
  assume {:verifier.code 0} true;
  $i1 := 1;
  goto $bb1;
$bb1:
  assume {:sourceloc "./output/dijkstra_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/dijkstra_tmp.c", 27, 17} true;
  assume {:verifier.code 0} true;
  $i2 := $sle.i32($i1, $i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 27, 13} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i2} true;
  goto $bb2, $bb3;
$bb2:
  assume ($i2 == 1);
  assume {:sourceloc "./output/dijkstra_tmp.c", 30, 15} true;
  assume {:verifier.code 0} true;
  $i3 := $mul.i32(4, $i1);
  call {:cexpr "q"} boogie_si_record_i32($i3);
  assume {:sourceloc "./output/dijkstra_tmp.c", 26, 5} true;
  assume {:verifier.code 0} true;
  $i1 := $i3;
  goto $bb1;
$bb3:
  assume !(($i2 == 1));
  assume {:sourceloc "./output/dijkstra_tmp.c", 28, 13} true;
  assume {:verifier.code 0} true;
  goto $bb4;
$bb4:
  assume {:sourceloc "./output/dijkstra_tmp.c", 34, 5} true;
  assume {:verifier.code 0} true;
  $i4, $i5, $i6, $i7 := $i1, 0, $i0, 0;
  goto $bb5;
$bb5:
  assume {:sourceloc "./output/dijkstra_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/dijkstra_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/dijkstra_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/dijkstra_tmp.c", 0, 0} true;
  assume {:verifier.code 1} true;
  assume {:sourceloc "./output/dijkstra_tmp.c", 35, 33} true;
  assume {:verifier.code 1} true;
  $i8 := $mul.i32(2, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 35, 37} true;
  assume {:verifier.code 1} true;
  $i9 := $add.i32($i8, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 35, 29} true;
  assume {:verifier.code 1} true;
  $i10 := $slt.i32($i6, $i9);
  assume {:sourceloc "./output/dijkstra_tmp.c", 35, 29} true;
  assume {:verifier.code 1} true;
  $i11 := $zext.i1.i32($i10);
  assume {:sourceloc "./output/dijkstra_tmp.c", 35, 9} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assert($i11);
  assume {:sourceloc "./output/dijkstra_tmp.c", 36, 28} true;
  assume {:verifier.code 1} true;
  $i12 := $mul.i32($i5, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 36, 34} true;
  assume {:verifier.code 1} true;
  $i13 := $mul.i32($i6, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 36, 31} true;
  assume {:verifier.code 1} true;
  $i14 := $add.i32($i12, $i13);
  assume {:sourceloc "./output/dijkstra_tmp.c", 36, 41} true;
  assume {:verifier.code 1} true;
  $i15 := $mul.i32($i0, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 36, 37} true;
  assume {:verifier.code 1} true;
  $i16 := $eq.i32($i14, $i15);
  assume {:sourceloc "./output/dijkstra_tmp.c", 36, 37} true;
  assume {:verifier.code 1} true;
  $i17 := $zext.i1.i32($i16);
  assume {:sourceloc "./output/dijkstra_tmp.c", 36, 9} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assert($i17);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 29} true;
  assume {:verifier.code 1} true;
  $i18 := $mul.i32($i7, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 33} true;
  assume {:verifier.code 1} true;
  $i19 := $mul.i32($i18, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 42} true;
  assume {:verifier.code 1} true;
  $i20 := $mul.i32(12, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 46} true;
  assume {:verifier.code 1} true;
  $i21 := $mul.i32($i20, $i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 50} true;
  assume {:verifier.code 1} true;
  $i22 := $mul.i32($i21, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 37} true;
  assume {:verifier.code 1} true;
  $i23 := $sub.i32($i19, $i22);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 59} true;
  assume {:verifier.code 1} true;
  $i24 := $mul.i32(16, $i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 63} true;
  assume {:verifier.code 1} true;
  $i25 := $mul.i32($i24, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 67} true;
  assume {:verifier.code 1} true;
  $i26 := $mul.i32($i25, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 54} true;
  assume {:verifier.code 1} true;
  $i27 := $add.i32($i23, $i26);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 75} true;
  assume {:verifier.code 1} true;
  $i28 := $mul.i32($i7, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 79} true;
  assume {:verifier.code 1} true;
  $i29 := $mul.i32($i28, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 71} true;
  assume {:verifier.code 1} true;
  $i30 := $sub.i32($i27, $i29);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 87} true;
  assume {:verifier.code 1} true;
  $i31 := $mul.i32(4, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 91} true;
  assume {:verifier.code 1} true;
  $i32 := $mul.i32($i31, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 95} true;
  assume {:verifier.code 1} true;
  $i33 := $mul.i32($i32, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 83} true;
  assume {:verifier.code 1} true;
  $i34 := $sub.i32($i30, $i33);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 104} true;
  assume {:verifier.code 1} true;
  $i35 := $mul.i32(12, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 108} true;
  assume {:verifier.code 1} true;
  $i36 := $mul.i32($i35, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 112} true;
  assume {:verifier.code 1} true;
  $i37 := $mul.i32($i36, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 99} true;
  assume {:verifier.code 1} true;
  $i38 := $add.i32($i34, $i37);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 121} true;
  assume {:verifier.code 1} true;
  $i39 := $mul.i32(16, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 125} true;
  assume {:verifier.code 1} true;
  $i40 := $mul.i32($i39, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 129} true;
  assume {:verifier.code 1} true;
  $i41 := $mul.i32($i40, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 116} true;
  assume {:verifier.code 1} true;
  $i42 := $sub.i32($i38, $i41);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 133} true;
  assume {:verifier.code 1} true;
  $i43 := $eq.i32($i42, 0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 133} true;
  assume {:verifier.code 1} true;
  $i44 := $zext.i1.i32($i43);
  assume {:sourceloc "./output/dijkstra_tmp.c", 37, 9} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assert($i44);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 29} true;
  assume {:verifier.code 1} true;
  $i45 := $mul.i32($i7, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 33} true;
  assume {:verifier.code 1} true;
  $i46 := $mul.i32($i45, $i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 41} true;
  assume {:verifier.code 1} true;
  $i47 := $mul.i32(4, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 45} true;
  assume {:verifier.code 1} true;
  $i48 := $mul.i32($i47, $i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 49} true;
  assume {:verifier.code 1} true;
  $i49 := $mul.i32($i48, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 37} true;
  assume {:verifier.code 1} true;
  $i50 := $sub.i32($i46, $i49);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 62} true;
  assume {:verifier.code 1} true;
  $i51 := $mul.i32($i0, $i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 57} true;
  assume {:verifier.code 1} true;
  $i52 := $mul.i32(4, $i51);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 67} true;
  assume {:verifier.code 1} true;
  $i53 := $mul.i32($i52, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 53} true;
  assume {:verifier.code 1} true;
  $i54 := $add.i32($i50, $i53);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 75} true;
  assume {:verifier.code 1} true;
  $i55 := $mul.i32($i0, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 79} true;
  assume {:verifier.code 1} true;
  $i56 := $mul.i32($i55, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 71} true;
  assume {:verifier.code 1} true;
  $i57 := $sub.i32($i54, $i56);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 87} true;
  assume {:verifier.code 1} true;
  $i58 := $mul.i32($i7, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 91} true;
  assume {:verifier.code 1} true;
  $i59 := $mul.i32($i58, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 83} true;
  assume {:verifier.code 1} true;
  $i60 := $sub.i32($i57, $i59);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 99} true;
  assume {:verifier.code 1} true;
  $i61 := $mul.i32(4, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 103} true;
  assume {:verifier.code 1} true;
  $i62 := $mul.i32($i61, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 107} true;
  assume {:verifier.code 1} true;
  $i63 := $mul.i32($i62, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 95} true;
  assume {:verifier.code 1} true;
  $i64 := $add.i32($i60, $i63);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 115} true;
  assume {:verifier.code 1} true;
  $i65 := $mul.i32(8, $i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 119} true;
  assume {:verifier.code 1} true;
  $i66 := $mul.i32($i65, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 123} true;
  assume {:verifier.code 1} true;
  $i67 := $mul.i32($i66, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 111} true;
  assume {:verifier.code 1} true;
  $i68 := $sub.i32($i64, $i67);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 131} true;
  assume {:verifier.code 1} true;
  $i69 := $mul.i32($i4, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 135} true;
  assume {:verifier.code 1} true;
  $i70 := $mul.i32($i69, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 127} true;
  assume {:verifier.code 1} true;
  $i71 := $add.i32($i68, $i70);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 143} true;
  assume {:verifier.code 1} true;
  $i72 := $mul.i32(4, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 147} true;
  assume {:verifier.code 1} true;
  $i73 := $mul.i32($i72, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 151} true;
  assume {:verifier.code 1} true;
  $i74 := $mul.i32($i73, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 139} true;
  assume {:verifier.code 1} true;
  $i75 := $add.i32($i71, $i74);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 155} true;
  assume {:verifier.code 1} true;
  $i76 := $eq.i32($i75, 0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 155} true;
  assume {:verifier.code 1} true;
  $i77 := $zext.i1.i32($i76);
  assume {:sourceloc "./output/dijkstra_tmp.c", 38, 9} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assert($i77);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 29} true;
  assume {:verifier.code 1} true;
  $i78 := $mul.i32($i7, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 33} true;
  assume {:verifier.code 1} true;
  $i79 := $mul.i32($i78, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 41} true;
  assume {:verifier.code 1} true;
  $i80 := $mul.i32(4, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 45} true;
  assume {:verifier.code 1} true;
  $i81 := $mul.i32($i80, $i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 49} true;
  assume {:verifier.code 1} true;
  $i82 := $mul.i32($i81, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 37} true;
  assume {:verifier.code 1} true;
  $i83 := $sub.i32($i79, $i82);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 57} true;
  assume {:verifier.code 1} true;
  $i84 := $mul.i32(4, $i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 61} true;
  assume {:verifier.code 1} true;
  $i85 := $mul.i32($i84, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 65} true;
  assume {:verifier.code 1} true;
  $i86 := $mul.i32($i85, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 53} true;
  assume {:verifier.code 1} true;
  $i87 := $add.i32($i83, $i86);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 73} true;
  assume {:verifier.code 1} true;
  $i88 := $mul.i32($i5, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 77} true;
  assume {:verifier.code 1} true;
  $i89 := $mul.i32($i88, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 69} true;
  assume {:verifier.code 1} true;
  $i90 := $sub.i32($i87, $i89);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 85} true;
  assume {:verifier.code 1} true;
  $i91 := $mul.i32(4, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 89} true;
  assume {:verifier.code 1} true;
  $i92 := $mul.i32($i91, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 93} true;
  assume {:verifier.code 1} true;
  $i93 := $mul.i32($i92, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 81} true;
  assume {:verifier.code 1} true;
  $i94 := $add.i32($i90, $i93);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 101} true;
  assume {:verifier.code 1} true;
  $i95 := $mul.i32(4, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 105} true;
  assume {:verifier.code 1} true;
  $i96 := $mul.i32($i95, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 109} true;
  assume {:verifier.code 1} true;
  $i97 := $mul.i32($i96, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 97} true;
  assume {:verifier.code 1} true;
  $i98 := $sub.i32($i94, $i97);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 113} true;
  assume {:verifier.code 1} true;
  $i99 := $eq.i32($i98, 0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 113} true;
  assume {:verifier.code 1} true;
  $i100 := $zext.i1.i32($i99);
  assume {:sourceloc "./output/dijkstra_tmp.c", 39, 9} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assert($i100);
  assume {:sourceloc "./output/dijkstra_tmp.c", 40, 29} true;
  assume {:verifier.code 1} true;
  $i101 := $mul.i32($i5, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 40, 37} true;
  assume {:verifier.code 1} true;
  $i102 := $mul.i32($i0, $i4);
  assume {:sourceloc "./output/dijkstra_tmp.c", 40, 33} true;
  assume {:verifier.code 1} true;
  $i103 := $sub.i32($i101, $i102);
  assume {:sourceloc "./output/dijkstra_tmp.c", 40, 45} true;
  assume {:verifier.code 1} true;
  $i104 := $mul.i32($i4, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 40, 41} true;
  assume {:verifier.code 1} true;
  $i105 := $add.i32($i103, $i104);
  assume {:sourceloc "./output/dijkstra_tmp.c", 40, 49} true;
  assume {:verifier.code 1} true;
  $i106 := $eq.i32($i105, 0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 40, 49} true;
  assume {:verifier.code 1} true;
  $i107 := $zext.i1.i32($i106);
  assume {:sourceloc "./output/dijkstra_tmp.c", 40, 9} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assert($i107);
  assume {:sourceloc "./output/dijkstra_tmp.c", 42, 17} true;
  assume {:verifier.code 0} true;
  $i108 := $ne.i32($i4, 1);
  assume {:sourceloc "./output/dijkstra_tmp.c", 42, 13} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i108} true;
  goto $bb6, $bb7;
$bb6:
  assume ($i108 == 1);
  assume {:sourceloc "./output/dijkstra_tmp.c", 45, 15} true;
  assume {:verifier.code 0} true;
  $i109 := $sdiv.i32($i4, 4);
  call {:cexpr "q"} boogie_si_record_i32($i109);
  assume {:sourceloc "./output/dijkstra_tmp.c", 46, 15} true;
  assume {:verifier.code 0} true;
  $i110 := $add.i32($i5, $i109);
  call {:cexpr "h"} boogie_si_record_i32($i110);
  assume {:sourceloc "./output/dijkstra_tmp.c", 47, 15} true;
  assume {:verifier.code 0} true;
  $i111 := $sdiv.i32($i5, 2);
  call {:cexpr "p"} boogie_si_record_i32($i111);
  assume {:sourceloc "./output/dijkstra_tmp.c", 48, 15} true;
  assume {:verifier.code 0} true;
  $i112 := $sge.i32($i6, $i110);
  assume {:sourceloc "./output/dijkstra_tmp.c", 48, 13} true;
  assume {:verifier.code 0} true;
  $i113, $i114 := $i111, $i6;
  assume {:branchcond $i112} true;
  goto $bb9, $bb10;
$bb7:
  assume !(($i108 == 1));
  assume {:sourceloc "./output/dijkstra_tmp.c", 43, 13} true;
  assume {:verifier.code 0} true;
  goto $bb8;
$bb8:
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 24} true;
  assume {:verifier.code 1} true;
  $i117 := $mul.i32($i7, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 26} true;
  assume {:verifier.code 1} true;
  $i118 := $mul.i32($i117, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 33} true;
  assume {:verifier.code 1} true;
  $i119 := $mul.i32(12, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 35} true;
  assume {:verifier.code 1} true;
  $i120 := $mul.i32($i119, $i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 29} true;
  assume {:verifier.code 1} true;
  $i121 := $sub.i32($i118, $i120);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 42} true;
  assume {:verifier.code 1} true;
  $i122 := $mul.i32(16, $i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 44} true;
  assume {:verifier.code 1} true;
  $i123 := $mul.i32($i122, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 38} true;
  assume {:verifier.code 1} true;
  $i124 := $add.i32($i121, $i123);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 51} true;
  assume {:verifier.code 1} true;
  $i125 := $mul.i32(12, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 53} true;
  assume {:verifier.code 1} true;
  $i126 := $mul.i32($i125, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 47} true;
  assume {:verifier.code 1} true;
  $i127 := $add.i32($i124, $i126);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 60} true;
  assume {:verifier.code 1} true;
  $i128 := $mul.i32(16, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 62} true;
  assume {:verifier.code 1} true;
  $i129 := $mul.i32($i128, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 56} true;
  assume {:verifier.code 1} true;
  $i130 := $sub.i32($i127, $i129);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 65} true;
  assume {:verifier.code 1} true;
  $i131 := $sub.i32($i130, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 72} true;
  assume {:verifier.code 1} true;
  $i132 := $mul.i32(4, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 69} true;
  assume {:verifier.code 1} true;
  $i133 := $sub.i32($i131, $i132);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 75} true;
  assume {:verifier.code 1} true;
  $i134 := $eq.i32($i133, 0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 75} true;
  assume {:verifier.code 1} true;
  $i135 := $zext.i1.i32($i134);
  assume {:sourceloc "./output/dijkstra_tmp.c", 53, 5} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assert($i135);
  assume {:sourceloc "./output/dijkstra_tmp.c", 54, 24} true;
  assume {:verifier.code 1} true;
  $i136 := $mul.i32($i5, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 54, 27} true;
  assume {:verifier.code 1} true;
  $i137 := $sub.i32($i136, $i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 54, 31} true;
  assume {:verifier.code 1} true;
  $i138 := $add.i32($i137, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 54, 35} true;
  assume {:verifier.code 1} true;
  $i139 := $eq.i32($i138, 0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 54, 35} true;
  assume {:verifier.code 1} true;
  $i140 := $zext.i1.i32($i139);
  assume {:sourceloc "./output/dijkstra_tmp.c", 54, 5} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assert($i140);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 24} true;
  assume {:verifier.code 1} true;
  $i141 := $mul.i32($i7, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 26} true;
  assume {:verifier.code 1} true;
  $i142 := $mul.i32($i141, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 32} true;
  assume {:verifier.code 1} true;
  $i143 := $mul.i32(4, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 34} true;
  assume {:verifier.code 1} true;
  $i144 := $mul.i32($i143, $i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 29} true;
  assume {:verifier.code 1} true;
  $i145 := $sub.i32($i142, $i144);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 40} true;
  assume {:verifier.code 1} true;
  $i146 := $mul.i32(4, $i0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 42} true;
  assume {:verifier.code 1} true;
  $i147 := $mul.i32($i146, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 37} true;
  assume {:verifier.code 1} true;
  $i148 := $add.i32($i145, $i147);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 48} true;
  assume {:verifier.code 1} true;
  $i149 := $mul.i32(4, $i7);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 50} true;
  assume {:verifier.code 1} true;
  $i150 := $mul.i32($i149, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 45} true;
  assume {:verifier.code 1} true;
  $i151 := $add.i32($i148, $i150);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 56} true;
  assume {:verifier.code 1} true;
  $i152 := $mul.i32(4, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 58} true;
  assume {:verifier.code 1} true;
  $i153 := $mul.i32($i152, $i6);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 53} true;
  assume {:verifier.code 1} true;
  $i154 := $sub.i32($i151, $i153);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 61} true;
  assume {:verifier.code 1} true;
  $i155 := $sub.i32($i154, $i5);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 65} true;
  assume {:verifier.code 1} true;
  $i156 := $eq.i32($i155, 0);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 65} true;
  assume {:verifier.code 1} true;
  $i157 := $zext.i1.i32($i156);
  assume {:sourceloc "./output/dijkstra_tmp.c", 55, 5} true;
  assume {:verifier.code 1} true;
  call __VERIFIER_assert($i157);
  assume {:sourceloc "./output/dijkstra_tmp.c", 56, 5} true;
  assume {:verifier.code 0} true;
  $r := 0;
  $exn := false;
  return;
$bb9:
  assume ($i112 == 1);
  assume {:sourceloc "./output/dijkstra_tmp.c", 49, 19} true;
  assume {:verifier.code 0} true;
  $i115 := $add.i32($i111, $i109);
  call {:cexpr "p"} boogie_si_record_i32($i115);
  assume {:sourceloc "./output/dijkstra_tmp.c", 50, 19} true;
  assume {:verifier.code 0} true;
  $i116 := $sub.i32($i6, $i110);
  call {:cexpr "r"} boogie_si_record_i32($i116);
  assume {:sourceloc "./output/dijkstra_tmp.c", 51, 9} true;
  assume {:verifier.code 0} true;
  $i113, $i114 := $i115, $i116;
  goto $bb11;
$bb10:
  assume {:sourceloc "./output/dijkstra_tmp.c", 48, 13} true;
  assume {:verifier.code 0} true;
  assume !(($i112 == 1));
  goto $bb11;
$bb11:
  assume {:sourceloc "./output/dijkstra_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/dijkstra_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/dijkstra_tmp.c", 34, 5} true;
  assume {:verifier.code 0} true;
  $i4, $i5, $i6, $i7 := $i109, $i113, $i114, $i110;
  goto $bb5;
}
const __VERIFIER_assume: ref;
axiom (__VERIFIER_assume == $sub.ref(0, 7221));
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
axiom (__SMACK_code == $sub.ref(0, 8253));
procedure __SMACK_code.ref.i32($p0: ref, p.1: i32);
procedure __SMACK_code.ref($p0: ref);
const __SMACK_dummy: ref;
axiom (__SMACK_dummy == $sub.ref(0, 9285));
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
const __VERIFIER_error: ref;
axiom (__VERIFIER_error == $sub.ref(0, 10317));
procedure __VERIFIER_error()
{
$bb0:
  assume {:sourceloc "./lib/smack.c", 52, 3} true;
  assume {:verifier.code 1} true;
  assume {:sourceloc "./lib/smack.c", 52, 3} true;
  assume {:verifier.code 1} true;
  assert false;
  assume {:sourceloc "./lib/smack.c", 59, 1} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const __SMACK_check_overflow: ref;
axiom (__SMACK_check_overflow == $sub.ref(0, 11349));
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
axiom (__SMACK_nondet_char == $sub.ref(0, 12381));
procedure __SMACK_nondet_char()
  returns ($r: i8);
const __SMACK_nondet_signed_char: ref;
axiom (__SMACK_nondet_signed_char == $sub.ref(0, 13413));
procedure __SMACK_nondet_signed_char()
  returns ($r: i8);
const __SMACK_nondet_unsigned_char: ref;
axiom (__SMACK_nondet_unsigned_char == $sub.ref(0, 14445));
procedure __SMACK_nondet_unsigned_char()
  returns ($r: i8);
const __SMACK_nondet_short: ref;
axiom (__SMACK_nondet_short == $sub.ref(0, 15477));
procedure __SMACK_nondet_short()
  returns ($r: i16);
const __SMACK_nondet_signed_short: ref;
axiom (__SMACK_nondet_signed_short == $sub.ref(0, 16509));
procedure __SMACK_nondet_signed_short()
  returns ($r: i16);
const __SMACK_nondet_signed_short_int: ref;
axiom (__SMACK_nondet_signed_short_int == $sub.ref(0, 17541));
procedure __SMACK_nondet_signed_short_int()
  returns ($r: i16);
const __SMACK_nondet_unsigned_short: ref;
axiom (__SMACK_nondet_unsigned_short == $sub.ref(0, 18573));
procedure __SMACK_nondet_unsigned_short()
  returns ($r: i16);
const __SMACK_nondet_unsigned_short_int: ref;
axiom (__SMACK_nondet_unsigned_short_int == $sub.ref(0, 19605));
procedure __SMACK_nondet_unsigned_short_int()
  returns ($r: i16);
const __VERIFIER_nondet_int: ref;
axiom (__VERIFIER_nondet_int == $sub.ref(0, 20637));
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
axiom (__SMACK_nondet_int == $sub.ref(0, 21669));
procedure __SMACK_nondet_int()
  returns ($r: i32);
const __SMACK_nondet_signed_int: ref;
axiom (__SMACK_nondet_signed_int == $sub.ref(0, 22701));
procedure __SMACK_nondet_signed_int()
  returns ($r: i32);
const __SMACK_nondet_unsigned: ref;
axiom (__SMACK_nondet_unsigned == $sub.ref(0, 23733));
procedure __SMACK_nondet_unsigned()
  returns ($r: i32);
const __SMACK_nondet_unsigned_int: ref;
axiom (__SMACK_nondet_unsigned_int == $sub.ref(0, 24765));
procedure __SMACK_nondet_unsigned_int()
  returns ($r: i32);
const __SMACK_nondet_long: ref;
axiom (__SMACK_nondet_long == $sub.ref(0, 25797));
procedure __SMACK_nondet_long()
  returns ($r: i64);
const __SMACK_nondet_long_int: ref;
axiom (__SMACK_nondet_long_int == $sub.ref(0, 26829));
procedure __SMACK_nondet_long_int()
  returns ($r: i64);
const __SMACK_nondet_signed_long: ref;
axiom (__SMACK_nondet_signed_long == $sub.ref(0, 27861));
procedure __SMACK_nondet_signed_long()
  returns ($r: i64);
const __SMACK_nondet_signed_long_int: ref;
axiom (__SMACK_nondet_signed_long_int == $sub.ref(0, 28893));
procedure __SMACK_nondet_signed_long_int()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long: ref;
axiom (__SMACK_nondet_unsigned_long == $sub.ref(0, 29925));
procedure __SMACK_nondet_unsigned_long()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_int: ref;
axiom (__SMACK_nondet_unsigned_long_int == $sub.ref(0, 30957));
procedure __SMACK_nondet_unsigned_long_int()
  returns ($r: i64);
const __SMACK_nondet_long_long: ref;
axiom (__SMACK_nondet_long_long == $sub.ref(0, 31989));
procedure __SMACK_nondet_long_long()
  returns ($r: i64);
const __SMACK_nondet_long_long_int: ref;
axiom (__SMACK_nondet_long_long_int == $sub.ref(0, 33021));
procedure __SMACK_nondet_long_long_int()
  returns ($r: i64);
const __SMACK_nondet_signed_long_long: ref;
axiom (__SMACK_nondet_signed_long_long == $sub.ref(0, 34053));
procedure __SMACK_nondet_signed_long_long()
  returns ($r: i64);
const __SMACK_nondet_signed_long_long_int: ref;
axiom (__SMACK_nondet_signed_long_long_int == $sub.ref(0, 35085));
procedure __SMACK_nondet_signed_long_long_int()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_long: ref;
axiom (__SMACK_nondet_unsigned_long_long == $sub.ref(0, 36117));
procedure __SMACK_nondet_unsigned_long_long()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_long_int: ref;
axiom (__SMACK_nondet_unsigned_long_long_int == $sub.ref(0, 37149));
procedure __SMACK_nondet_unsigned_long_long_int()
  returns ($r: i64);
const __SMACK_decls: ref;
axiom (__SMACK_decls == $sub.ref(0, 38181));
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
axiom (__SMACK_top_decl == $sub.ref(0, 39213));
procedure __SMACK_top_decl.ref($p0: ref);
const __SMACK_init_func_memory_model: ref;
axiom (__SMACK_init_func_memory_model == $sub.ref(0, 40245));
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
axiom (llvm.dbg.value == $sub.ref(0, 41277));
procedure llvm.dbg.value($p0: ref, $p1: ref, $p2: ref);
const __SMACK_static_init: ref;
axiom (__SMACK_static_init == $sub.ref(0, 42309));
procedure __SMACK_static_init()
{
$bb0:
  $M.0 := .str.1.5;
  $M.1 := 0;
  call {:cexpr "errno_global"} boogie_si_record_i32(0);
  $exn := false;
  return;
}
procedure boogie_si_record_i32(x: i32);
procedure boogie_si_record_ref(x: ref);
procedure $initialize()
{
  call __SMACK_static_init();
  call __SMACK_init_func_memory_model();
  return;
}
