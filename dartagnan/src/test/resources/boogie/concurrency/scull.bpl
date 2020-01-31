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

// Memory maps (11 regions)
var $M.0: i32;
var $M.1: i32;
var $M.2: i32;
var $M.3: i32;
var $M.4: i32;
var $M.5: i32;
var $M.6: i32;
var $M.7: [ref] i8;
var $M.8: i32;
var $M.9: ref;
var $M.10: i32;

// Memory address bounds
axiom ($GLOBALS_BOTTOM == $sub.ref(0, 72261));
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
const lock: ref;
axiom (lock == $sub.ref(0, 1088));
const scull_quantum: ref;
axiom (scull_quantum == $sub.ref(0, 2116));
const scull_qset: ref;
axiom (scull_qset == $sub.ref(0, 3144));
const dev_qset: ref;
axiom (dev_qset == $sub.ref(0, 4172));
const dev_size: ref;
axiom (dev_size == $sub.ref(0, 5200));
const dev_quantum: ref;
axiom (dev_quantum == $sub.ref(0, 6228));
const dev_data: ref;
axiom (dev_data == $sub.ref(0, 7256));
const __X__: ref;
axiom (__X__ == $sub.ref(0, 8284));
const i: ref;
axiom (i == $sub.ref(0, 9312));
const env_value_str: ref;
axiom (env_value_str == $sub.ref(0, 10344));
const {:count 3} .str.1.5: ref;
axiom (.str.1.5 == $sub.ref(0, 11371));
const {:count 14} .str.14: ref;
axiom (.str.14 == $sub.ref(0, 12409));
const errno_global: ref;
axiom (errno_global == $sub.ref(0, 13437));
const down_interruptible: ref;
axiom (down_interruptible == $sub.ref(0, 14469));
procedure down_interruptible()
  returns ($r: i32)
{
  var $i0: i32;
$bb0:
  assume {:sourceloc "./output/scull_tmp.c", 93, 3} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/scull_tmp.c", 93, 3} true;
  assume {:verifier.code 0} true;
  call $i0 := pthread_mutex_lock(lock);
  assume {:sourceloc "./output/scull_tmp.c", 94, 3} true;
  assume {:verifier.code 0} true;
  $r := 0;
  $exn := false;
  return;
}
const pthread_mutex_lock: ref;
axiom (pthread_mutex_lock == $sub.ref(0, 15501));
procedure pthread_mutex_lock($p0: ref)
  returns ($r: i32);
const up: ref;
axiom (up == $sub.ref(0, 16533));
procedure up()
{
  var $i0: i32;
$bb0:
  assume {:sourceloc "./output/scull_tmp.c", 98, 3} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/scull_tmp.c", 98, 3} true;
  assume {:verifier.code 0} true;
  call $i0 := pthread_mutex_unlock(lock);
  assume {:sourceloc "./output/scull_tmp.c", 99, 3} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const pthread_mutex_unlock: ref;
axiom (pthread_mutex_unlock == $sub.ref(0, 17565));
procedure pthread_mutex_unlock($p0: ref)
  returns ($r: i32);
const copy_to_user: ref;
axiom (copy_to_user == $sub.ref(0, 18597));
procedure copy_to_user($i0: i32, $i1: i32, $i2: i32)
  returns ($r: i32)
{
  var $i3: i32;
$bb0:
  assume {:sourceloc "./output/scull_tmp.c", 106, 10} true;
  assume {:verifier.code 0} true;
  call {:cexpr "copy_to_user:arg:to"} boogie_si_record_i32($i0);
  call {:cexpr "copy_to_user:arg:from"} boogie_si_record_i32($i1);
  call {:cexpr "copy_to_user:arg:n"} boogie_si_record_i32($i2);
  call {:cexpr "copy_to_user:arg:to"} boogie_si_record_i32($i1);
  assume {:sourceloc "./output/scull_tmp.c", 106, 10} true;
  assume {:verifier.code 0} true;
  call $i3 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i3);
  assume {:sourceloc "./output/scull_tmp.c", 106, 3} true;
  assume {:verifier.code 0} true;
  $r := $i3;
  $exn := false;
  return;
}
const llvm.dbg.declare: ref;
axiom (llvm.dbg.declare == $sub.ref(0, 19629));
procedure llvm.dbg.declare($p0: ref, $p1: ref, $p2: ref);
const copy_from_user: ref;
axiom (copy_from_user == $sub.ref(0, 20661));
procedure copy_from_user($i0: i32, $i1: i32, $i2: i32)
  returns ($r: i32)
{
  var $i3: i32;
$bb0:
  assume {:sourceloc "./output/scull_tmp.c", 111, 10} true;
  assume {:verifier.code 0} true;
  call {:cexpr "copy_from_user:arg:to"} boogie_si_record_i32($i0);
  call {:cexpr "copy_from_user:arg:from"} boogie_si_record_i32($i1);
  call {:cexpr "copy_from_user:arg:n"} boogie_si_record_i32($i2);
  call {:cexpr "copy_from_user:arg:to"} boogie_si_record_i32($i1);
  assume {:sourceloc "./output/scull_tmp.c", 111, 10} true;
  assume {:verifier.code 0} true;
  call $i3 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i3);
  assume {:sourceloc "./output/scull_tmp.c", 111, 3} true;
  assume {:verifier.code 0} true;
  $r := $i3;
  $exn := false;
  return;
}
const scull_trim: ref;
axiom (scull_trim == $sub.ref(0, 21693));
procedure scull_trim($i0: i32)
  returns ($r: i32)
{
  var $i1: i32;
  var $i2: i32;
$bb0:
  assume {:sourceloc "./output/scull_tmp.c", 161, 12} true;
  assume {:verifier.code 0} true;
  call {:cexpr "scull_trim:arg:dev"} boogie_si_record_i32($i0);
  assume {:sourceloc "./output/scull_tmp.c", 161, 12} true;
  assume {:verifier.code 0} true;
  $M.0 := 0;
  call {:cexpr "dev_size"} boogie_si_record_i32(0);
  assume {:sourceloc "./output/scull_tmp.c", 162, 17} true;
  assume {:verifier.code 0} true;
  $i1 := $M.1;
  assume {:sourceloc "./output/scull_tmp.c", 162, 15} true;
  assume {:verifier.code 0} true;
  $M.2 := $i1;
  call {:cexpr "dev_quantum"} boogie_si_record_i32($i1);
  assume {:sourceloc "./output/scull_tmp.c", 163, 14} true;
  assume {:verifier.code 0} true;
  $i2 := $M.3;
  assume {:sourceloc "./output/scull_tmp.c", 163, 12} true;
  assume {:verifier.code 0} true;
  $M.4 := $i2;
  call {:cexpr "dev_qset"} boogie_si_record_i32($i2);
  assume {:sourceloc "./output/scull_tmp.c", 164, 12} true;
  assume {:verifier.code 0} true;
  $M.5 := 0;
  call {:cexpr "dev_data"} boogie_si_record_i32(0);
  assume {:sourceloc "./output/scull_tmp.c", 165, 3} true;
  assume {:verifier.code 0} true;
  $r := 0;
  $exn := false;
  return;
}
const scull_open: ref;
axiom (scull_open == $sub.ref(0, 22725));
procedure scull_open($i0: i32, $i1: i32, $i2: i32)
  returns ($r: i32)
{
  var $i3: i32;
  var $i4: i1;
  var $i6: i32;
  var $i7: i32;
  var $i8: i1;
  var $i5: i32;
$bb0:
  assume {:sourceloc "./output/scull_tmp.c", 180, 7} true;
  assume {:verifier.code 0} true;
  call {:cexpr "scull_open:arg:tid"} boogie_si_record_i32($i0);
  call {:cexpr "scull_open:arg:i"} boogie_si_record_i32($i1);
  call {:cexpr "scull_open:arg:filp"} boogie_si_record_i32($i2);
  call {:cexpr "scull_open:arg:dev"} boogie_si_record_i32($i1);
  call {:cexpr "scull_open:arg:filp"} boogie_si_record_i32($i1);
  assume {:sourceloc "./output/scull_tmp.c", 180, 7} true;
  assume {:verifier.code 0} true;
  call $i3 := down_interruptible();
  assume {:sourceloc "./output/scull_tmp.c", 180, 7} true;
  assume {:verifier.code 0} true;
  $i4 := $ne.i32($i3, 0);
  assume {:sourceloc "./output/scull_tmp.c", 180, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i4} true;
  goto $bb1, $bb2;
$bb1:
  assume ($i4 == 1);
  assume {:sourceloc "./output/scull_tmp.c", 181, 5} true;
  assume {:verifier.code 0} true;
  $i5 := $sub.i32(0, 512);
  goto $bb3;
$bb2:
  assume !(($i4 == 1));
  assume {:sourceloc "./output/scull_tmp.c", 183, 9} true;
  assume {:verifier.code 0} true;
  $M.6 := 2;
  call {:cexpr "__X__"} boogie_si_record_i32(2);
  assume {:sourceloc "./output/scull_tmp.c", 184, 3} true;
  assume {:verifier.code 0} true;
  call $i6 := scull_trim($i1);
  assume {:sourceloc "./output/scull_tmp.c", 185, 3} true;
  assume {:verifier.code 0} true;
  $i7 := $M.6;
  assume {:sourceloc "./output/scull_tmp.c", 185, 3} true;
  assume {:verifier.code 0} true;
  $i8 := $sge.i32($i7, 2);
  assume {:sourceloc "./output/scull_tmp.c", 185, 3} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i8} true;
  goto $bb4, $bb5;
$bb3:
  assume {:sourceloc "./output/scull_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/scull_tmp.c", 188, 1} true;
  assume {:verifier.code 0} true;
  $r := $i5;
  $exn := false;
  return;
$bb4:
  assume ($i8 == 1);
  assume {:sourceloc "./output/scull_tmp.c", 186, 3} true;
  assume {:verifier.code 0} true;
  call up();
  assume {:sourceloc "./output/scull_tmp.c", 187, 3} true;
  assume {:verifier.code 0} true;
  $i5 := 0;
  goto $bb3;
$bb5:
  assume !(($i8 == 1));
  assume {:sourceloc "./output/scull_tmp.c", 185, 3} true;
  assume {:verifier.code 0} true;
  goto $bb6;
$bb6:
  assume {:sourceloc "./output/scull_tmp.c", 185, 3} true;
  assume {:verifier.code 0} true;
  call __VERIFIER_error();
  assume {:sourceloc "./output/scull_tmp.c", 185, 3} true;
  assume {:verifier.code 0} true;
  assume false;
}
const scull_follow: ref;
axiom (scull_follow == $sub.ref(0, 23757));
procedure scull_follow($i0: i32, $i1: i32)
  returns ($r: i32)
{
  var $i2: i32;
$bb0:
  assume {:sourceloc "./output/scull_tmp.c", 196, 10} true;
  assume {:verifier.code 0} true;
  call {:cexpr "scull_follow:arg:dev"} boogie_si_record_i32($i0);
  call {:cexpr "scull_follow:arg:n"} boogie_si_record_i32($i1);
  assume {:sourceloc "./output/scull_tmp.c", 196, 10} true;
  assume {:verifier.code 0} true;
  call $i2 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i2);
  assume {:sourceloc "./output/scull_tmp.c", 196, 3} true;
  assume {:verifier.code 0} true;
  $r := $i2;
  $exn := false;
  return;
}
const scull_read: ref;
axiom (scull_read == $sub.ref(0, 24789));
procedure scull_read($i0: i32, $i1: i32, $i2: i32, $i3: i32, $i4: i32)
  returns ($r: i32)
{
  var $i5: i32;
  var $i6: i32;
  var $i7: i32;
  var $i8: i32;
  var $i9: i1;
  var $i11: i32;
  var $i12: i1;
  var $i14: i32;
  var $i15: i32;
  var $i16: i1;
  var $i18: i32;
  var $i19: i32;
  var $i17: i32;
  var $i20: i32;
  var $i21: i32;
  var $i22: i32;
  var $i23: i32;
  var $i24: i1;
  var $i26: i32;
  var $i25: i32;
  var $i27: i32;
  var $i28: i32;
  var $i29: i32;
  var $i30: i32;
  var $i31: i1;
  var $i32: i32;
  var $i33: i1;
  var $i13: i32;
  var $i10: i32;
$bb0:
  assume {:sourceloc "./output/scull_tmp.c", 208, 17} true;
  assume {:verifier.code 0} true;
  call {:cexpr "scull_read:arg:tid"} boogie_si_record_i32($i0);
  call {:cexpr "scull_read:arg:filp"} boogie_si_record_i32($i1);
  call {:cexpr "scull_read:arg:buf"} boogie_si_record_i32($i2);
  call {:cexpr "scull_read:arg:count"} boogie_si_record_i32($i3);
  call {:cexpr "scull_read:arg:f_pos"} boogie_si_record_i32($i4);
  call {:cexpr "scull_read:arg:dev"} boogie_si_record_i32($i1);
  assume {:sourceloc "./output/scull_tmp.c", 208, 17} true;
  assume {:verifier.code 0} true;
  $i5 := $M.2;
  call {:cexpr "quantum"} boogie_si_record_i32($i5);
  assume {:sourceloc "./output/scull_tmp.c", 208, 37} true;
  assume {:verifier.code 0} true;
  $i6 := $M.4;
  call {:cexpr "qset"} boogie_si_record_i32($i6);
  assume {:sourceloc "./output/scull_tmp.c", 209, 26} true;
  assume {:verifier.code 0} true;
  $i7 := $mul.i32($i5, $i6);
  call {:cexpr "itemsize"} boogie_si_record_i32($i7);
  assume {:sourceloc "./output/scull_tmp.c", 213, 7} true;
  assume {:verifier.code 0} true;
  call $i8 := down_interruptible();
  assume {:sourceloc "./output/scull_tmp.c", 213, 7} true;
  assume {:verifier.code 0} true;
  $i9 := $ne.i32($i8, 0);
  assume {:sourceloc "./output/scull_tmp.c", 213, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i9} true;
  goto $bb1, $bb2;
$bb1:
  assume ($i9 == 1);
  assume {:sourceloc "./output/scull_tmp.c", 214, 5} true;
  assume {:verifier.code 0} true;
  $i10 := $sub.i32(0, 512);
  goto $bb3;
$bb2:
  assume !(($i9 == 1));
  assume {:sourceloc "./output/scull_tmp.c", 216, 9} true;
  assume {:verifier.code 0} true;
  $M.6 := 0;
  call {:cexpr "__X__"} boogie_si_record_i32(0);
  assume {:sourceloc "./output/scull_tmp.c", 218, 16} true;
  assume {:verifier.code 0} true;
  $i11 := $M.0;
  assume {:sourceloc "./output/scull_tmp.c", 218, 13} true;
  assume {:verifier.code 0} true;
  $i12 := $sge.i32($i4, $i11);
  assume {:sourceloc "./output/scull_tmp.c", 218, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i12} true;
  goto $bb4, $bb5;
$bb3:
  assume {:sourceloc "./output/scull_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/scull_tmp.c", 247, 1} true;
  assume {:verifier.code 0} true;
  $r := $i10;
  $exn := false;
  return;
$bb4:
  assume ($i12 == 1);
  assume {:sourceloc "./output/scull_tmp.c", 219, 5} true;
  assume {:verifier.code 0} true;
  $i13 := 0;
  goto $bb6;
$bb5:
  assume !(($i12 == 1));
  assume {:sourceloc "./output/scull_tmp.c", 220, 12} true;
  assume {:verifier.code 0} true;
  $i14 := $add.i32($i4, $i3);
  assume {:sourceloc "./output/scull_tmp.c", 220, 22} true;
  assume {:verifier.code 0} true;
  $i15 := $M.0;
  assume {:sourceloc "./output/scull_tmp.c", 220, 19} true;
  assume {:verifier.code 0} true;
  $i16 := $sge.i32($i14, $i15);
  assume {:sourceloc "./output/scull_tmp.c", 220, 7} true;
  assume {:verifier.code 0} true;
  $i17 := $i3;
  assume {:branchcond $i16} true;
  goto $bb7, $bb8;
$bb6:
  assume {:sourceloc "./output/scull_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/scull_tmp.c", 245, 3} true;
  assume {:verifier.code 0} true;
  call up();
  assume {:sourceloc "./output/scull_tmp.c", 246, 3} true;
  assume {:verifier.code 0} true;
  $i10 := $i13;
  goto $bb3;
$bb7:
  assume ($i16 == 1);
  assume {:sourceloc "./output/scull_tmp.c", 221, 13} true;
  assume {:verifier.code 0} true;
  $i18 := $M.0;
  assume {:sourceloc "./output/scull_tmp.c", 221, 22} true;
  assume {:verifier.code 0} true;
  $i19 := $sub.i32($i18, $i4);
  call {:cexpr "count"} boogie_si_record_i32($i19);
  assume {:sourceloc "./output/scull_tmp.c", 221, 5} true;
  assume {:verifier.code 0} true;
  $i17 := $i19;
  goto $bb9;
$bb8:
  assume {:sourceloc "./output/scull_tmp.c", 220, 7} true;
  assume {:verifier.code 0} true;
  assume !(($i16 == 1));
  goto $bb9;
$bb9:
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/scull_tmp.c", 224, 16} true;
  assume {:verifier.code 0} true;
  $i20 := $sdiv.i32($i4, $i7);
  call {:cexpr "item"} boogie_si_record_i32($i20);
  call {:cexpr "scull_read:arg:rest"} boogie_si_record_i32($i4);
  assume {:sourceloc "./output/scull_tmp.c", 226, 17} true;
  assume {:verifier.code 0} true;
  $i21 := $sdiv.i32($i4, $i5);
  call {:cexpr "s_pos"} boogie_si_record_i32($i21);
  call {:cexpr "scull_read:arg:q_pos"} boogie_si_record_i32($i4);
  assume {:sourceloc "./output/scull_tmp.c", 229, 11} true;
  assume {:verifier.code 0} true;
  call $i22 := scull_follow($i1, $i20);
  call {:cexpr "dptr"} boogie_si_record_i32($i22);
  assume {:sourceloc "./output/scull_tmp.c", 232, 24} true;
  assume {:verifier.code 0} true;
  $i23 := $sub.i32($i5, $i4);
  assume {:sourceloc "./output/scull_tmp.c", 232, 14} true;
  assume {:verifier.code 0} true;
  $i24 := $sgt.i32($i17, $i23);
  assume {:sourceloc "./output/scull_tmp.c", 232, 8} true;
  assume {:verifier.code 0} true;
  $i25 := $i17;
  assume {:branchcond $i24} true;
  goto $bb10, $bb11;
$bb10:
  assume ($i24 == 1);
  assume {:sourceloc "./output/scull_tmp.c", 233, 22} true;
  assume {:verifier.code 0} true;
  $i26 := $sub.i32($i5, $i4);
  call {:cexpr "count"} boogie_si_record_i32($i26);
  assume {:sourceloc "./output/scull_tmp.c", 233, 6} true;
  assume {:verifier.code 0} true;
  $i25 := $i26;
  goto $bb12;
$bb11:
  assume {:sourceloc "./output/scull_tmp.c", 232, 8} true;
  assume {:verifier.code 0} true;
  assume !(($i24 == 1));
  goto $bb12;
$bb12:
  assume {:sourceloc "./output/scull_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/scull_tmp.c", 235, 25} true;
  assume {:verifier.code 0} true;
  $i27 := $M.5;
  assume {:sourceloc "./output/scull_tmp.c", 235, 34} true;
  assume {:verifier.code 0} true;
  $i28 := $add.i32($i27, $i21);
  assume {:sourceloc "./output/scull_tmp.c", 235, 42} true;
  assume {:verifier.code 0} true;
  $i29 := $add.i32($i28, $i4);
  assume {:sourceloc "./output/scull_tmp.c", 235, 7} true;
  assume {:verifier.code 0} true;
  call $i30 := copy_to_user($i2, $i29, $i25);
  assume {:sourceloc "./output/scull_tmp.c", 235, 7} true;
  assume {:verifier.code 0} true;
  $i31 := $ne.i32($i30, 0);
  assume {:sourceloc "./output/scull_tmp.c", 235, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i31} true;
  goto $bb13, $bb14;
$bb13:
  assume ($i31 == 1);
  assume {:sourceloc "./output/scull_tmp.c", 237, 5} true;
  assume {:verifier.code 0} true;
  $i13 := $sub.i32(0, 2);
  goto $bb6;
$bb14:
  assume !(($i31 == 1));
  assume {:sourceloc "./output/scull_tmp.c", 242, 3} true;
  assume {:verifier.code 0} true;
  $i32 := $M.6;
  assume {:sourceloc "./output/scull_tmp.c", 242, 3} true;
  assume {:verifier.code 0} true;
  $i33 := $sle.i32($i32, 0);
  assume {:sourceloc "./output/scull_tmp.c", 242, 3} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i33} true;
  goto $bb15, $bb16;
$bb15:
  assume ($i33 == 1);
  assume {:sourceloc "./output/scull_tmp.c", 242, 3} true;
  assume {:verifier.code 0} true;
  $i13 := $i25;
  goto $bb6;
$bb16:
  assume !(($i33 == 1));
  assume {:sourceloc "./output/scull_tmp.c", 242, 3} true;
  assume {:verifier.code 0} true;
  goto $bb17;
$bb17:
  assume {:sourceloc "./output/scull_tmp.c", 242, 3} true;
  assume {:verifier.code 0} true;
  call __VERIFIER_error();
  assume {:sourceloc "./output/scull_tmp.c", 242, 3} true;
  assume {:verifier.code 0} true;
  assume false;
}
const scull_write: ref;
axiom (scull_write == $sub.ref(0, 25821));
procedure scull_write($i0: i32, $i1: i32, $i2: i32, $i3: i32, $i4: i32)
  returns ($r: i32)
{
  var $i5: i32;
  var $i6: i32;
  var $i7: i32;
  var $i8: i32;
  var $i9: i1;
  var $i11: i32;
  var $i12: i32;
  var $i13: i32;
  var $i14: i1;
  var $i16: i32;
  var $i17: i1;
  var $i19: i32;
  var $i18: i32;
  var $i20: i32;
  var $i21: i32;
  var $i22: i32;
  var $i23: i32;
  var $i24: i1;
  var $i25: i32;
  var $i26: i32;
  var $i27: i1;
  var $i28: i32;
  var $i29: i1;
  var $i15: i32;
  var $i10: i32;
$bb0:
  assume {:sourceloc "./output/scull_tmp.c", 254, 17} true;
  assume {:verifier.code 0} true;
  call {:cexpr "scull_write:arg:tid"} boogie_si_record_i32($i0);
  call {:cexpr "scull_write:arg:filp"} boogie_si_record_i32($i1);
  call {:cexpr "scull_write:arg:buf"} boogie_si_record_i32($i2);
  call {:cexpr "scull_write:arg:count"} boogie_si_record_i32($i3);
  call {:cexpr "scull_write:arg:f_pos"} boogie_si_record_i32($i4);
  call {:cexpr "scull_write:arg:dev"} boogie_si_record_i32($i1);
  assume {:sourceloc "./output/scull_tmp.c", 254, 17} true;
  assume {:verifier.code 0} true;
  $i5 := $M.2;
  call {:cexpr "quantum"} boogie_si_record_i32($i5);
  assume {:sourceloc "./output/scull_tmp.c", 254, 37} true;
  assume {:verifier.code 0} true;
  $i6 := $M.4;
  call {:cexpr "qset"} boogie_si_record_i32($i6);
  assume {:sourceloc "./output/scull_tmp.c", 255, 26} true;
  assume {:verifier.code 0} true;
  $i7 := $mul.i32($i5, $i6);
  call {:cexpr "itemsize"} boogie_si_record_i32($i7);
  assume {:sourceloc "./output/scull_tmp.c", 259, 7} true;
  assume {:verifier.code 0} true;
  call $i8 := down_interruptible();
  assume {:sourceloc "./output/scull_tmp.c", 259, 7} true;
  assume {:verifier.code 0} true;
  $i9 := $ne.i32($i8, 0);
  assume {:sourceloc "./output/scull_tmp.c", 259, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i9} true;
  goto $bb1, $bb2;
$bb1:
  assume ($i9 == 1);
  assume {:sourceloc "./output/scull_tmp.c", 260, 5} true;
  assume {:verifier.code 0} true;
  $i10 := $sub.i32(0, 512);
  goto $bb3;
$bb2:
  assume !(($i9 == 1));
  assume {:sourceloc "./output/scull_tmp.c", 263, 16} true;
  assume {:verifier.code 0} true;
  $i11 := $sdiv.i32($i4, $i7);
  call {:cexpr "item"} boogie_si_record_i32($i11);
  call {:cexpr "scull_write:arg:rest"} boogie_si_record_i32($i4);
  assume {:sourceloc "./output/scull_tmp.c", 265, 16} true;
  assume {:verifier.code 0} true;
  $i12 := $sdiv.i32($i4, $i5);
  call {:cexpr "s_pos"} boogie_si_record_i32($i12);
  call {:cexpr "scull_write:arg:q_pos"} boogie_si_record_i32($i4);
  assume {:sourceloc "./output/scull_tmp.c", 268, 10} true;
  assume {:verifier.code 0} true;
  call $i13 := scull_follow($i1, $i11);
  call {:cexpr "dptr"} boogie_si_record_i32($i13);
  assume {:sourceloc "./output/scull_tmp.c", 269, 12} true;
  assume {:verifier.code 0} true;
  $i14 := $eq.i32($i13, 0);
  assume {:sourceloc "./output/scull_tmp.c", 269, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i14} true;
  goto $bb4, $bb5;
$bb3:
  assume {:sourceloc "./output/scull_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/scull_tmp.c", 294, 1} true;
  assume {:verifier.code 0} true;
  $r := $i10;
  $exn := false;
  return;
$bb4:
  assume ($i14 == 1);
  assume {:sourceloc "./output/scull_tmp.c", 270, 5} true;
  assume {:verifier.code 0} true;
  $i15 := $sub.i32(0, 4);
  goto $bb6;
$bb5:
  assume !(($i14 == 1));
  assume {:sourceloc "./output/scull_tmp.c", 273, 23} true;
  assume {:verifier.code 0} true;
  $i16 := $sub.i32($i5, $i4);
  assume {:sourceloc "./output/scull_tmp.c", 273, 13} true;
  assume {:verifier.code 0} true;
  $i17 := $sgt.i32($i3, $i16);
  assume {:sourceloc "./output/scull_tmp.c", 273, 7} true;
  assume {:verifier.code 0} true;
  $i18 := $i3;
  assume {:branchcond $i17} true;
  goto $bb7, $bb8;
$bb6:
  assume {:sourceloc "./output/scull_tmp.c", 0, 0} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/scull_tmp.c", 292, 3} true;
  assume {:verifier.code 0} true;
  call up();
  assume {:sourceloc "./output/scull_tmp.c", 293, 3} true;
  assume {:verifier.code 0} true;
  $i10 := $i15;
  goto $bb3;
$bb7:
  assume ($i17 == 1);
  assume {:sourceloc "./output/scull_tmp.c", 274, 21} true;
  assume {:verifier.code 0} true;
  $i19 := $sub.i32($i5, $i4);
  call {:cexpr "count"} boogie_si_record_i32($i19);
  assume {:sourceloc "./output/scull_tmp.c", 274, 5} true;
  assume {:verifier.code 0} true;
  $i18 := $i19;
  goto $bb9;
$bb8:
  assume {:sourceloc "./output/scull_tmp.c", 273, 7} true;
  assume {:verifier.code 0} true;
  assume !(($i17 == 1));
  goto $bb9;
$bb9:
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/scull_tmp.c", 276, 9} true;
  assume {:verifier.code 0} true;
  $M.6 := 1;
  call {:cexpr "__X__"} boogie_si_record_i32(1);
  assume {:sourceloc "./output/scull_tmp.c", 278, 22} true;
  assume {:verifier.code 0} true;
  $i20 := $M.5;
  assume {:sourceloc "./output/scull_tmp.c", 278, 30} true;
  assume {:verifier.code 0} true;
  $i21 := $add.i32($i20, $i12);
  assume {:sourceloc "./output/scull_tmp.c", 278, 36} true;
  assume {:verifier.code 0} true;
  $i22 := $add.i32($i21, $i4);
  assume {:sourceloc "./output/scull_tmp.c", 278, 7} true;
  assume {:verifier.code 0} true;
  call $i23 := copy_from_user($i22, $i2, $i18);
  assume {:sourceloc "./output/scull_tmp.c", 278, 7} true;
  assume {:verifier.code 0} true;
  $i24 := $ne.i32($i23, 0);
  assume {:sourceloc "./output/scull_tmp.c", 278, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i24} true;
  goto $bb10, $bb11;
$bb10:
  assume ($i24 == 1);
  assume {:sourceloc "./output/scull_tmp.c", 280, 5} true;
  assume {:verifier.code 0} true;
  $i15 := $sub.i32(0, 2);
  goto $bb6;
$bb11:
  assume !(($i24 == 1));
  assume {:sourceloc "./output/scull_tmp.c", 282, 9} true;
  assume {:verifier.code 0} true;
  $i25 := $add.i32($i4, $i18);
  call {:cexpr "f_pos"} boogie_si_record_i32($i25);
  assume {:sourceloc "./output/scull_tmp.c", 286, 7} true;
  assume {:verifier.code 0} true;
  $i26 := $M.0;
  assume {:sourceloc "./output/scull_tmp.c", 286, 16} true;
  assume {:verifier.code 0} true;
  $i27 := $slt.i32($i26, $i25);
  assume {:sourceloc "./output/scull_tmp.c", 286, 7} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i27} true;
  goto $bb12, $bb13;
$bb12:
  assume ($i27 == 1);
  assume {:sourceloc "./output/scull_tmp.c", 287, 14} true;
  assume {:verifier.code 0} true;
  $M.0 := $i25;
  call {:cexpr "dev_size"} boogie_si_record_i32($i25);
  assume {:sourceloc "./output/scull_tmp.c", 287, 5} true;
  assume {:verifier.code 0} true;
  goto $bb14;
$bb13:
  assume {:sourceloc "./output/scull_tmp.c", 286, 7} true;
  assume {:verifier.code 0} true;
  assume !(($i27 == 1));
  goto $bb14;
$bb14:
  assume {:sourceloc "./output/scull_tmp.c", 289, 3} true;
  assume {:verifier.code 0} true;
  $i28 := $M.6;
  assume {:sourceloc "./output/scull_tmp.c", 289, 3} true;
  assume {:verifier.code 0} true;
  $i29 := $eq.i32($i28, 1);
  assume {:sourceloc "./output/scull_tmp.c", 289, 3} true;
  assume {:verifier.code 0} true;
  assume {:branchcond $i29} true;
  goto $bb15, $bb16;
$bb15:
  assume ($i29 == 1);
  assume {:sourceloc "./output/scull_tmp.c", 289, 3} true;
  assume {:verifier.code 0} true;
  $i15 := $i18;
  goto $bb6;
$bb16:
  assume !(($i29 == 1));
  assume {:sourceloc "./output/scull_tmp.c", 289, 3} true;
  assume {:verifier.code 0} true;
  goto $bb17;
$bb17:
  assume {:sourceloc "./output/scull_tmp.c", 289, 3} true;
  assume {:verifier.code 0} true;
  call __VERIFIER_error();
  assume {:sourceloc "./output/scull_tmp.c", 289, 3} true;
  assume {:verifier.code 0} true;
  assume false;
}
const scull_cleanup_module: ref;
axiom (scull_cleanup_module == $sub.ref(0, 26853));
procedure scull_cleanup_module()
{
  var $i0: i32;
  var $i1: i32;
$bb0:
  assume {:sourceloc "./output/scull_tmp.c", 418, 17} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/scull_tmp.c", 418, 17} true;
  assume {:verifier.code 0} true;
  call $i0 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i0);
  call {:cexpr "dev"} boogie_si_record_i32($i0);
  assume {:sourceloc "./output/scull_tmp.c", 419, 3} true;
  assume {:verifier.code 0} true;
  call $i1 := scull_trim($i0);
  assume {:sourceloc "./output/scull_tmp.c", 421, 1} true;
  assume {:verifier.code 0} true;
  $exn := false;
  return;
}
const scull_init_module: ref;
axiom (scull_init_module == $sub.ref(0, 27885));
procedure scull_init_module()
  returns ($r: i32)
{
$bb0:
  assume {:sourceloc "./output/scull_tmp.c", 426, 3} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/scull_tmp.c", 426, 3} true;
  assume {:verifier.code 0} true;
  goto $bb1;
$bb1:
  assume {:sourceloc "./output/scull_tmp.c", 431, 1} true;
  assume {:verifier.code 0} true;
  $r := 0;
  $exn := false;
  return;
$bb2:
  assume {:sourceloc "./output/scull_tmp.c", 429, 3} true;
  assume {:verifier.code 0} true;
  call scull_cleanup_module();
  assume {:sourceloc "./output/scull_tmp.c", 430, 3} true;
  assume {:verifier.code 0} true;
  $M.7 := $store.i32($M.7, $u0, 0);
  assume {:sourceloc "./output/scull_tmp.c", 430, 3} true;
  assume {:verifier.code 0} true;
  goto $bb1;
}
const loader: ref;
axiom (loader == $sub.ref(0, 28917));
procedure loader($p0: ref)
  returns ($r: ref)
{
  var $i1: i32;
$bb0:
  assume {:sourceloc "./output/scull_tmp.c", 438, 3} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/scull_tmp.c", 438, 3} true;
  assume {:verifier.code 0} true;
  call $i1 := scull_init_module();
  assume {:sourceloc "./output/scull_tmp.c", 439, 3} true;
  assume {:verifier.code 0} true;
  call scull_cleanup_module();
  assume {:sourceloc "./output/scull_tmp.c", 440, 3} true;
  assume {:verifier.code 0} true;
  $r := $0.ref;
  $exn := false;
  return;
}
const thread1: ref;
axiom (thread1 == $sub.ref(0, 29949));
procedure thread1($p0: ref)
  returns ($r: ref)
{
  var $i1: i32;
  var $i2: i32;
  var $i3: i32;
  var $i4: i32;
  var $i5: i32;
$bb0:
  assume {:sourceloc "./output/scull_tmp.c", 444, 13} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/scull_tmp.c", 444, 13} true;
  assume {:verifier.code 0} true;
  call $i1 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i1);
  call {:cexpr "filp"} boogie_si_record_i32($i1);
  assume {:sourceloc "./output/scull_tmp.c", 445, 12} true;
  assume {:verifier.code 0} true;
  call $i2 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i2);
  call {:cexpr "buf"} boogie_si_record_i32($i2);
  assume {:sourceloc "./output/scull_tmp.c", 448, 20} true;
  assume {:verifier.code 0} true;
  $i3 := $M.8;
  assume {:sourceloc "./output/scull_tmp.c", 448, 3} true;
  assume {:verifier.code 0} true;
  call $i4 := scull_open(1, $i3, $i1);
  assume {:sourceloc "./output/scull_tmp.c", 449, 3} true;
  assume {:verifier.code 0} true;
  call $i5 := scull_read(1, $i1, $i2, 10, 0);
  assume {:sourceloc "./output/scull_tmp.c", 451, 3} true;
  assume {:verifier.code 0} true;
  $r := $0.ref;
  $exn := false;
  return;
}
const thread2: ref;
axiom (thread2 == $sub.ref(0, 30981));
procedure thread2($p0: ref)
  returns ($r: ref)
{
  var $i1: i32;
  var $i2: i32;
  var $i3: i32;
  var $i4: i32;
  var $i5: i32;
$bb0:
  assume {:sourceloc "./output/scull_tmp.c", 455, 13} true;
  assume {:verifier.code 0} true;
  assume {:sourceloc "./output/scull_tmp.c", 455, 13} true;
  assume {:verifier.code 0} true;
  call $i1 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i1);
  call {:cexpr "filp"} boogie_si_record_i32($i1);
  assume {:sourceloc "./output/scull_tmp.c", 456, 12} true;
  assume {:verifier.code 0} true;
  call $i2 := __VERIFIER_nondet_int();
  call {:cexpr "smack:ext:__VERIFIER_nondet_int"} boogie_si_record_i32($i2);
  call {:cexpr "buf"} boogie_si_record_i32($i2);
  assume {:sourceloc "./output/scull_tmp.c", 459, 20} true;
  assume {:verifier.code 0} true;
  $i3 := $M.8;
  assume {:sourceloc "./output/scull_tmp.c", 459, 3} true;
  assume {:verifier.code 0} true;
  call $i4 := scull_open(2, $i3, $i1);
  assume {:sourceloc "./output/scull_tmp.c", 460, 3} true;
  assume {:verifier.code 0} true;
  call $i5 := scull_write(2, $i1, $i2, 10, 0);
  assume {:sourceloc "./output/scull_tmp.c", 462, 3} true;
  assume {:verifier.code 0} true;
  $r := $0.ref;
  $exn := false;
  return;
}
const main: ref;
axiom (main == $sub.ref(0, 32013));
procedure main()
  returns ($r: i32)
{
  var $p0: ref;
  var $p1: ref;
  var $p2: ref;
  var $i3: i32;
  var $i4: i32;
  var $i5: i32;
  var $i6: i32;
  var $p7: ref;
  var $i8: i32;
  var $p9: ref;
  var $i10: i32;
  var $p11: ref;
  var $i12: i32;
  var $i13: i32;
$bb0:
  call $initialize();
  assume {:sourceloc "./output/scull_tmp.c", 467, 3} true;
  assume {:verifier.code 0} true;
  call {:cexpr "smack:entry:main"} boogie_si_record_ref(main);
  assume {:verifier.code 0} true;
  call $p0 := $alloc($mul.ref(8, $zext.i32.i64(1)));
  assume {:verifier.code 0} true;
  call $p1 := $alloc($mul.ref(8, $zext.i32.i64(1)));
  assume {:verifier.code 0} true;
  call $p2 := $alloc($mul.ref(8, $zext.i32.i64(1)));
  assume true;
  assume true;
  assume true;
  assume {:sourceloc "./output/scull_tmp.c", 467, 3} true;
  assume {:verifier.code 0} true;
  call $i3 := pthread_mutex_init(lock, $0.ref);
  assume {:sourceloc "./output/scull_tmp.c", 468, 3} true;
  assume {:verifier.code 0} true;
  call $i4 := pthread_create($p0, $0.ref, loader, $0.ref);
  assume {:sourceloc "./output/scull_tmp.c", 469, 3} true;
  assume {:verifier.code 0} true;
  call $i5 := pthread_create($p1, $0.ref, thread1, $0.ref);
  assume {:sourceloc "./output/scull_tmp.c", 470, 3} true;
  assume {:verifier.code 0} true;
  call $i6 := pthread_create($p2, $0.ref, thread2, $0.ref);
  assume {:sourceloc "./output/scull_tmp.c", 471, 16} true;
  assume {:verifier.code 0} true;
  $p7 := $load.ref($M.7, $p0);
  assume {:sourceloc "./output/scull_tmp.c", 471, 3} true;
  assume {:verifier.code 0} true;
  call $i8 := __pthread_join($p7, $0.ref);
  assume {:sourceloc "./output/scull_tmp.c", 472, 16} true;
  assume {:verifier.code 0} true;
  $p9 := $load.ref($M.7, $p1);
  assume {:sourceloc "./output/scull_tmp.c", 472, 3} true;
  assume {:verifier.code 0} true;
  call $i10 := __pthread_join($p9, $0.ref);
  assume {:sourceloc "./output/scull_tmp.c", 473, 16} true;
  assume {:verifier.code 0} true;
  $p11 := $load.ref($M.7, $p2);
  assume {:sourceloc "./output/scull_tmp.c", 473, 3} true;
  assume {:verifier.code 0} true;
  call $i12 := __pthread_join($p11, $0.ref);
  assume {:sourceloc "./output/scull_tmp.c", 474, 3} true;
  assume {:verifier.code 0} true;
  call $i13 := pthread_mutex_destroy(lock);
  assume {:sourceloc "./output/scull_tmp.c", 475, 3} true;
  assume {:verifier.code 0} true;
  $r := 0;
  $exn := false;
  return;
}
const pthread_mutex_init: ref;
axiom (pthread_mutex_init == $sub.ref(0, 33045));
procedure pthread_mutex_init($p0: ref, $p1: ref)
  returns ($r: i32);
const pthread_create: ref;
axiom (pthread_create == $sub.ref(0, 34077));
procedure pthread_create($p0: ref, $p1: ref, $p2: ref, $p3: ref)
  returns ($r: i32);
const __pthread_join: ref;
axiom (__pthread_join == $sub.ref(0, 35109));
procedure __pthread_join($p0: ref, $p1: ref)
  returns ($r: i32);
const pthread_mutex_destroy: ref;
axiom (pthread_mutex_destroy == $sub.ref(0, 36141));
procedure pthread_mutex_destroy($p0: ref)
  returns ($r: i32);
const __VERIFIER_assume: ref;
axiom (__VERIFIER_assume == $sub.ref(0, 37173));
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
axiom (__SMACK_code == $sub.ref(0, 38205));
procedure __SMACK_code.ref.i32($p0: ref, p.1: i32);
procedure __SMACK_code.ref($p0: ref);
const __SMACK_dummy: ref;
axiom (__SMACK_dummy == $sub.ref(0, 39237));
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
axiom (__VERIFIER_error == $sub.ref(0, 40269));
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
axiom (__SMACK_check_overflow == $sub.ref(0, 41301));
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
axiom (__SMACK_nondet_char == $sub.ref(0, 42333));
procedure __SMACK_nondet_char()
  returns ($r: i8);
const __SMACK_nondet_signed_char: ref;
axiom (__SMACK_nondet_signed_char == $sub.ref(0, 43365));
procedure __SMACK_nondet_signed_char()
  returns ($r: i8);
const __SMACK_nondet_unsigned_char: ref;
axiom (__SMACK_nondet_unsigned_char == $sub.ref(0, 44397));
procedure __SMACK_nondet_unsigned_char()
  returns ($r: i8);
const __SMACK_nondet_short: ref;
axiom (__SMACK_nondet_short == $sub.ref(0, 45429));
procedure __SMACK_nondet_short()
  returns ($r: i16);
const __SMACK_nondet_signed_short: ref;
axiom (__SMACK_nondet_signed_short == $sub.ref(0, 46461));
procedure __SMACK_nondet_signed_short()
  returns ($r: i16);
const __SMACK_nondet_signed_short_int: ref;
axiom (__SMACK_nondet_signed_short_int == $sub.ref(0, 47493));
procedure __SMACK_nondet_signed_short_int()
  returns ($r: i16);
const __SMACK_nondet_unsigned_short: ref;
axiom (__SMACK_nondet_unsigned_short == $sub.ref(0, 48525));
procedure __SMACK_nondet_unsigned_short()
  returns ($r: i16);
const __SMACK_nondet_unsigned_short_int: ref;
axiom (__SMACK_nondet_unsigned_short_int == $sub.ref(0, 49557));
procedure __SMACK_nondet_unsigned_short_int()
  returns ($r: i16);
const __VERIFIER_nondet_int: ref;
axiom (__VERIFIER_nondet_int == $sub.ref(0, 50589));
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
axiom (__SMACK_nondet_int == $sub.ref(0, 51621));
procedure __SMACK_nondet_int()
  returns ($r: i32);
const __SMACK_nondet_signed_int: ref;
axiom (__SMACK_nondet_signed_int == $sub.ref(0, 52653));
procedure __SMACK_nondet_signed_int()
  returns ($r: i32);
const __SMACK_nondet_unsigned: ref;
axiom (__SMACK_nondet_unsigned == $sub.ref(0, 53685));
procedure __SMACK_nondet_unsigned()
  returns ($r: i32);
const __SMACK_nondet_unsigned_int: ref;
axiom (__SMACK_nondet_unsigned_int == $sub.ref(0, 54717));
procedure __SMACK_nondet_unsigned_int()
  returns ($r: i32);
const __SMACK_nondet_long: ref;
axiom (__SMACK_nondet_long == $sub.ref(0, 55749));
procedure __SMACK_nondet_long()
  returns ($r: i64);
const __SMACK_nondet_long_int: ref;
axiom (__SMACK_nondet_long_int == $sub.ref(0, 56781));
procedure __SMACK_nondet_long_int()
  returns ($r: i64);
const __SMACK_nondet_signed_long: ref;
axiom (__SMACK_nondet_signed_long == $sub.ref(0, 57813));
procedure __SMACK_nondet_signed_long()
  returns ($r: i64);
const __SMACK_nondet_signed_long_int: ref;
axiom (__SMACK_nondet_signed_long_int == $sub.ref(0, 58845));
procedure __SMACK_nondet_signed_long_int()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long: ref;
axiom (__SMACK_nondet_unsigned_long == $sub.ref(0, 59877));
procedure __SMACK_nondet_unsigned_long()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_int: ref;
axiom (__SMACK_nondet_unsigned_long_int == $sub.ref(0, 60909));
procedure __SMACK_nondet_unsigned_long_int()
  returns ($r: i64);
const __SMACK_nondet_long_long: ref;
axiom (__SMACK_nondet_long_long == $sub.ref(0, 61941));
procedure __SMACK_nondet_long_long()
  returns ($r: i64);
const __SMACK_nondet_long_long_int: ref;
axiom (__SMACK_nondet_long_long_int == $sub.ref(0, 62973));
procedure __SMACK_nondet_long_long_int()
  returns ($r: i64);
const __SMACK_nondet_signed_long_long: ref;
axiom (__SMACK_nondet_signed_long_long == $sub.ref(0, 64005));
procedure __SMACK_nondet_signed_long_long()
  returns ($r: i64);
const __SMACK_nondet_signed_long_long_int: ref;
axiom (__SMACK_nondet_signed_long_long_int == $sub.ref(0, 65037));
procedure __SMACK_nondet_signed_long_long_int()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_long: ref;
axiom (__SMACK_nondet_unsigned_long_long == $sub.ref(0, 66069));
procedure __SMACK_nondet_unsigned_long_long()
  returns ($r: i64);
const __SMACK_nondet_unsigned_long_long_int: ref;
axiom (__SMACK_nondet_unsigned_long_long_int == $sub.ref(0, 67101));
procedure __SMACK_nondet_unsigned_long_long_int()
  returns ($r: i64);
const __SMACK_decls: ref;
axiom (__SMACK_decls == $sub.ref(0, 68133));
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
axiom (__SMACK_top_decl == $sub.ref(0, 69165));
procedure __SMACK_top_decl.ref($p0: ref);
const __SMACK_init_func_memory_model: ref;
axiom (__SMACK_init_func_memory_model == $sub.ref(0, 70197));
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
axiom (llvm.dbg.value == $sub.ref(0, 71229));
procedure llvm.dbg.value($p0: ref, $p1: ref, $p2: ref);
const __SMACK_static_init: ref;
axiom (__SMACK_static_init == $sub.ref(0, 72261));
procedure __SMACK_static_init()
{
$bb0:
  $M.7 := $store.i64($M.7, lock, 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(0, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(1, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(2, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(3, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(4, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(5, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(6, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(7, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(8, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(9, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(10, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(11, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(12, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(13, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(14, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(15, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(16, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(17, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(18, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(19, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(20, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(21, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(22, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(23, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(24, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(25, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(26, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(27, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(28, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(29, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(30, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(31, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(32, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(33, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(34, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(35, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(36, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(37, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(38, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(39, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(40, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(41, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(42, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(43, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(44, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(45, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(46, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(47, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(48, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(49, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(50, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(51, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(52, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(53, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(54, 1)), 0);
  $M.7 := $store.i8($M.7, $add.ref($add.ref($add.ref(lock, $mul.ref(0, 64)), $mul.ref(8, 1)), $mul.ref(55, 1)), 0);
  $M.1 := 4000;
  call {:cexpr "scull_quantum"} boogie_si_record_i32(4000);
  $M.3 := 1000;
  call {:cexpr "scull_qset"} boogie_si_record_i32(1000);
  $M.4 := 0;
  call {:cexpr "dev_qset"} boogie_si_record_i32(0);
  $M.0 := 0;
  call {:cexpr "dev_size"} boogie_si_record_i32(0);
  $M.2 := 0;
  call {:cexpr "dev_quantum"} boogie_si_record_i32(0);
  $M.5 := 0;
  call {:cexpr "dev_data"} boogie_si_record_i32(0);
  $M.6 := 0;
  call {:cexpr "__X__"} boogie_si_record_i32(0);
  $M.8 := 0;
  call {:cexpr "i"} boogie_si_record_i32(0);
  $M.9 := .str.1.5;
  $M.10 := 0;
  call {:cexpr "errno_global"} boogie_si_record_i32(0);
  $exn := false;
  return;
}
const $u0: ref;
procedure boogie_si_record_i32(x: i32);
procedure boogie_si_record_ref(x: ref);
procedure $initialize()
{
  call __SMACK_static_init();
  call __SMACK_init_func_memory_model();
  return;
}
