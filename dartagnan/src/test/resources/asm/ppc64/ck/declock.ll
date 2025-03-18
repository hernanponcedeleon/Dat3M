; ModuleID = 'tests/declock.c'
source_filename = "tests/declock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_spinlock_dec = type { i32 }

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !20
@lock = global %struct.ck_spinlock_dec zeroinitializer, align 4, !dbg !40
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !23
@.str = private unnamed_addr constant [10 x i8] c"declock.c\00", align 1, !dbg !30
@.str.1 = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !35
@nodes = global ptr null, align 8, !dbg !47

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 !dbg !58 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8, !dbg !66
  %6 = ptrtoint ptr %5 to i64, !dbg !67
  store i64 %6, ptr %3, align 8, !dbg !65
  %7 = load i64, ptr %3, align 8, !dbg !68
  %8 = icmp eq i64 %7, 1, !dbg !70
  br i1 %8, label %9, label %15, !dbg !71

9:                                                ; preds = %1
  %10 = call zeroext i1 @ck_spinlock_dec_trylock(ptr noundef @lock), !dbg !76
  %11 = zext i1 %10 to i8, !dbg !75
  store i8 %11, ptr %4, align 1, !dbg !75
  %12 = load i8, ptr %4, align 1, !dbg !77
  %13 = trunc i8 %12 to i1, !dbg !77
  %14 = zext i1 %13 to i32, !dbg !77
  call void @__VERIFIER_assume(i32 noundef %14), !dbg !78
  br label %16, !dbg !79

15:                                               ; preds = %1
  call void @ck_spinlock_dec_lock(ptr noundef @lock), !dbg !80
  br label %16

16:                                               ; preds = %15, %9
  %17 = load i32, ptr @x, align 4, !dbg !82
  %18 = add nsw i32 %17, 1, !dbg !82
  store i32 %18, ptr @x, align 4, !dbg !82
  %19 = load i32, ptr @y, align 4, !dbg !83
  %20 = add nsw i32 %19, 1, !dbg !83
  store i32 %20, ptr @y, align 4, !dbg !83
  call void @ck_spinlock_dec_unlock(ptr noundef @lock), !dbg !84
  ret ptr null, !dbg !85
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_spinlock_dec_trylock(ptr noundef %0) #0 !dbg !86 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !94
  %5 = getelementptr inbounds %struct.ck_spinlock_dec, ptr %4, i32 0, i32 0, !dbg !95
  %6 = call i32 @ck_pr_fas_uint(ptr noundef %5, i32 noundef 0), !dbg !96
  store i32 %6, ptr %3, align 4, !dbg !97
  call void @ck_pr_fence_lock(), !dbg !98
  %7 = load i32, ptr %3, align 4, !dbg !99
  %8 = icmp eq i32 %7, 1, !dbg !100
  ret i1 %8, !dbg !101
}

declare void @__VERIFIER_assume(i32 noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_dec_lock(ptr noundef %0) #0 !dbg !102 {
  %2 = alloca ptr, align 8
  %3 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  br label %4, !dbg !109

4:                                                ; preds = %19, %1
  %5 = load ptr, ptr %2, align 8, !dbg !110
  %6 = getelementptr inbounds %struct.ck_spinlock_dec, ptr %5, i32 0, i32 0, !dbg !114
  call void @ck_pr_dec_uint_zero(ptr noundef %6, ptr noundef %3), !dbg !115
  %7 = load i8, ptr %3, align 1, !dbg !116
  %8 = trunc i8 %7 to i1, !dbg !116
  %9 = zext i1 %8 to i32, !dbg !116
  %10 = icmp eq i32 %9, 1, !dbg !118
  br i1 %10, label %11, label %12, !dbg !119

11:                                               ; preds = %4
  br label %20, !dbg !120

12:                                               ; preds = %4
  br label %13, !dbg !121

13:                                               ; preds = %18, %12
  %14 = load ptr, ptr %2, align 8, !dbg !122
  %15 = getelementptr inbounds %struct.ck_spinlock_dec, ptr %14, i32 0, i32 0, !dbg !122
  %16 = call i32 @ck_pr_md_load_uint(ptr noundef %15), !dbg !122
  %17 = icmp ne i32 %16, 1, !dbg !123
  br i1 %17, label %18, label %19, !dbg !121

18:                                               ; preds = %13
  call void @ck_pr_stall(), !dbg !124
  br label %13, !dbg !121, !llvm.loop !125

19:                                               ; preds = %13
  br label %4, !dbg !128, !llvm.loop !129

20:                                               ; preds = %11
  call void @ck_pr_fence_lock(), !dbg !132
  ret void, !dbg !133
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_dec_unlock(ptr noundef %0) #0 !dbg !134 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @ck_pr_fence_unlock(), !dbg !137
  %3 = load ptr, ptr %2, align 8, !dbg !138
  %4 = getelementptr inbounds %struct.ck_spinlock_dec, ptr %3, i32 0, i32 0, !dbg !138
  call void @ck_pr_md_store_uint(ptr noundef %4, i32 noundef 1), !dbg !138
  ret void, !dbg !139
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !140 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @ck_spinlock_dec_init(ptr noundef @lock), !dbg !172
  store i32 0, ptr %3, align 4, !dbg !173
  br label %4, !dbg !175

4:                                                ; preds = %18, %0
  %5 = load i32, ptr %3, align 4, !dbg !176
  %6 = icmp slt i32 %5, 2, !dbg !178
  br i1 %6, label %7, label %21, !dbg !179

7:                                                ; preds = %4
  %8 = load i32, ptr %3, align 4, !dbg !180
  %9 = sext i32 %8 to i64, !dbg !183
  %10 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %9, !dbg !183
  %11 = load i32, ptr %3, align 4, !dbg !184
  %12 = sext i32 %11 to i64, !dbg !185
  %13 = inttoptr i64 %12 to ptr, !dbg !186
  %14 = call i32 @pthread_create(ptr noundef %10, ptr noundef null, ptr noundef @run, ptr noundef %13), !dbg !187
  %15 = icmp ne i32 %14, 0, !dbg !188
  br i1 %15, label %16, label %17, !dbg !189

16:                                               ; preds = %7
  call void @exit(i32 noundef 1) #4, !dbg !190
  unreachable, !dbg !190

17:                                               ; preds = %7
  br label %18, !dbg !192

18:                                               ; preds = %17
  %19 = load i32, ptr %3, align 4, !dbg !193
  %20 = add nsw i32 %19, 1, !dbg !193
  store i32 %20, ptr %3, align 4, !dbg !193
  br label %4, !dbg !194, !llvm.loop !195

21:                                               ; preds = %4
  store i32 0, ptr %3, align 4, !dbg !197
  br label %22, !dbg !199

22:                                               ; preds = %34, %21
  %23 = load i32, ptr %3, align 4, !dbg !200
  %24 = icmp slt i32 %23, 2, !dbg !202
  br i1 %24, label %25, label %37, !dbg !203

25:                                               ; preds = %22
  %26 = load i32, ptr %3, align 4, !dbg !204
  %27 = sext i32 %26 to i64, !dbg !207
  %28 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %27, !dbg !207
  %29 = load ptr, ptr %28, align 8, !dbg !207
  %30 = call i32 @"\01_pthread_join"(ptr noundef %29, ptr noundef null), !dbg !208
  %31 = icmp ne i32 %30, 0, !dbg !209
  br i1 %31, label %32, label %33, !dbg !210

32:                                               ; preds = %25
  call void @exit(i32 noundef 1) #4, !dbg !211
  unreachable, !dbg !211

33:                                               ; preds = %25
  br label %34, !dbg !213

34:                                               ; preds = %33
  %35 = load i32, ptr %3, align 4, !dbg !214
  %36 = add nsw i32 %35, 1, !dbg !214
  store i32 %36, ptr %3, align 4, !dbg !214
  br label %22, !dbg !215, !llvm.loop !216

37:                                               ; preds = %22
  %38 = load i32, ptr @x, align 4, !dbg !218
  %39 = icmp eq i32 %38, 2, !dbg !218
  br i1 %39, label %40, label %43, !dbg !218

40:                                               ; preds = %37
  %41 = load i32, ptr @y, align 4, !dbg !218
  %42 = icmp eq i32 %41, 2, !dbg !218
  br label %43

43:                                               ; preds = %40, %37
  %44 = phi i1 [ false, %37 ], [ %42, %40 ], !dbg !219
  %45 = xor i1 %44, true, !dbg !218
  %46 = zext i1 %45 to i32, !dbg !218
  %47 = sext i32 %46 to i64, !dbg !218
  %48 = icmp ne i64 %47, 0, !dbg !218
  br i1 %48, label %49, label %51, !dbg !218

49:                                               ; preds = %43
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 59, ptr noundef @.str.1) #5, !dbg !218
  unreachable, !dbg !218

50:                                               ; No predecessors!
  br label %52, !dbg !218

51:                                               ; preds = %43
  br label %52, !dbg !218

52:                                               ; preds = %51, %50
  ret i32 0, !dbg !220
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_dec_init(ptr noundef %0) #0 !dbg !221 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8, !dbg !224
  %4 = getelementptr inbounds %struct.ck_spinlock_dec, ptr %3, i32 0, i32 0, !dbg !225
  store i32 1, ptr %4, align 4, !dbg !226
  call void @ck_pr_barrier(), !dbg !227
  ret void, !dbg !228
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #2

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_fas_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !229 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %6 = load ptr, ptr %3, align 8, !dbg !234
  %7 = load i32, ptr %4, align 4, !dbg !234
  %8 = call i32 asm sideeffect "1:;lwarx $0, 0, $1;stwcx. $2, 0, $1;bne- 1b;", "=&r,r,r,~{memory},~{cc}"(ptr %6, i32 %7) #6, !dbg !234, !srcloc !237
  store i32 %8, ptr %5, align 4, !dbg !234
  %9 = load i32, ptr %5, align 4, !dbg !234
  ret i32 %9, !dbg !234
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_lock() #0 !dbg !238 {
  call void @ck_pr_fence_strict_lock(), !dbg !242
  ret void, !dbg !242
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_lock() #0 !dbg !243 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !244, !srcloc !245
  ret void, !dbg !244
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_dec_uint_zero(ptr noundef %0, ptr noundef %1) #0 !dbg !246 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8, !dbg !251
  %6 = call zeroext i1 @ck_pr_dec_uint_is_zero(ptr noundef %5), !dbg !251
  %7 = load ptr, ptr %4, align 8, !dbg !251
  %8 = zext i1 %6 to i8, !dbg !251
  store i8 %8, ptr %7, align 1, !dbg !251
  ret void, !dbg !251
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !253 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !257
  %5 = call i32 asm sideeffect "lwz $0, $1", "=r,*m,~{memory}"(ptr elementtype(i32) %4) #6, !dbg !257, !srcloc !259
  store i32 %5, ptr %3, align 4, !dbg !257
  %6 = load i32, ptr %3, align 4, !dbg !257
  ret i32 %6, !dbg !257
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_stall() #0 !dbg !260 {
  call void asm sideeffect "or 1, 1, 1;or 2, 2, 2;", "~{memory}"() #6, !dbg !261, !srcloc !262
  ret void, !dbg !263
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_pr_dec_uint_is_zero(ptr noundef %0) #0 !dbg !264 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8, !dbg !268
  %6 = call i32 @ck_pr_md_load_uint(ptr noundef %5), !dbg !268
  store i32 %6, ptr %4, align 4, !dbg !268
  %7 = load i32, ptr %4, align 4, !dbg !268
  store i32 %7, ptr %3, align 4, !dbg !268
  br label %8, !dbg !268

8:                                                ; preds = %16, %1
  %9 = load ptr, ptr %2, align 8, !dbg !268
  %10 = load i32, ptr %3, align 4, !dbg !268
  %11 = load i32, ptr %3, align 4, !dbg !268
  %12 = sub i32 %11, 1, !dbg !268
  %13 = call zeroext i1 @ck_pr_cas_uint_value(ptr noundef %9, i32 noundef %10, i32 noundef %12, ptr noundef %3), !dbg !268
  %14 = zext i1 %13 to i32, !dbg !268
  %15 = icmp eq i32 %14, 0, !dbg !268
  br i1 %15, label %16, label %17, !dbg !268

16:                                               ; preds = %8
  call void @ck_pr_stall(), !dbg !268
  br label %8, !dbg !268, !llvm.loop !271

17:                                               ; preds = %8
  %18 = load i32, ptr %3, align 4, !dbg !268
  %19 = icmp eq i32 %18, 1, !dbg !268
  ret i1 %19, !dbg !268
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_pr_cas_uint_value(ptr noundef %0, i32 noundef %1, i32 noundef %2, ptr noundef %3) #0 !dbg !272 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store i32 %1, ptr %6, align 4
  store i32 %2, ptr %7, align 4
  store ptr %3, ptr %8, align 8
  %10 = load ptr, ptr %5, align 8, !dbg !276
  %11 = load i32, ptr %7, align 4, !dbg !276
  %12 = load i32, ptr %6, align 4, !dbg !276
  %13 = call i32 asm sideeffect "1:;lwarx $0, 0, $1;cmpw  0, $0, $3;bne-  2f;stwcx. $2, 0, $1;bne-  1b;2:", "=&r,r,r,r,~{memory},~{cc}"(ptr %10, i32 %11, i32 %12) #6, !dbg !276, !srcloc !281
  store i32 %13, ptr %9, align 4, !dbg !276
  %14 = load i32, ptr %9, align 4, !dbg !276
  %15 = load ptr, ptr %8, align 8, !dbg !276
  store i32 %14, ptr %15, align 4, !dbg !276
  %16 = load i32, ptr %9, align 4, !dbg !276
  %17 = load i32, ptr %6, align 4, !dbg !276
  %18 = icmp eq i32 %16, %17, !dbg !276
  ret i1 %18, !dbg !276
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_unlock() #0 !dbg !282 {
  call void @ck_pr_fence_strict_unlock(), !dbg !283
  ret void, !dbg !283
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !284 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8, !dbg !288
  %6 = load i32, ptr %4, align 4, !dbg !288
  call void asm sideeffect "stw $1, $0", "=*m,r,~{memory}"(ptr elementtype(i32) %5, i32 %6) #6, !dbg !288, !srcloc !290
  ret void, !dbg !288
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_unlock() #0 !dbg !291 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !292, !srcloc !293
  ret void, !dbg !292
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_barrier() #0 !dbg !294 {
  call void asm sideeffect "", "~{memory}"() #6, !dbg !296, !srcloc !297
  ret void, !dbg !298
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #4 = { noreturn }
attributes #5 = { cold noreturn }
attributes #6 = { nounwind }

!llvm.module.flags = !{!50, !51, !52, !53, !54, !55, !56}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!57}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 12, type: !22, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !19, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "tests/declock.c", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "30fa24ff6bfc9964c8665f42f6017fd2")
!4 = !{!5, !10, !11, !15, !16, !18}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !6, line: 32, baseType: !7)
!6 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_types/_intptr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e478ba47270923b1cca6659f19f02db1")
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_intptr_t", file: !8, line: 40, baseType: !9)
!8 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/arm/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "b270144f57ae258d0ce80b8f87be068c")
!9 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !12, line: 50, baseType: !13)
!12 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_types/_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "f7981334d28e0c246f35cd24042aa2a4")
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_size_t", file: !8, line: 87, baseType: !14)
!14 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!15 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!19 = !{!0, !20, !23, !30, !35, !40, !47}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 12, type: !22, isLocal: false, isDefinition: true)
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !3, line: 59, type: !25, isLocal: true, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 40, elements: !28)
!26 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !27)
!27 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!28 = !{!29}
!29 = !DISubrange(count: 5)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 59, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 80, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 10)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(scope: null, file: !3, line: 59, type: !37, isLocal: true, isDefinition: true)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 248, elements: !38)
!38 = !{!39}
!39 = !DISubrange(count: 31)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 13, type: !42, isLocal: false, isDefinition: true)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_dec_t", file: !43, line: 46, baseType: !44)
!43 = !DIFile(filename: "include/spinlock/dec.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "ebf75fdec979dfc7f06fb0ef6eee88f9")
!44 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_dec", file: !43, line: 43, size: 32, elements: !45)
!45 = !{!46}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !44, file: !43, line: 44, baseType: !15, size: 32)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "nodes", scope: !2, file: !3, line: 14, type: !49, isLocal: false, isDefinition: true)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!50 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 0]}
!51 = !{i32 7, !"Dwarf Version", i32 5}
!52 = !{i32 2, !"Debug Info Version", i32 3}
!53 = !{i32 1, !"wchar_size", i32 4}
!54 = !{i32 8, !"PIC Level", i32 2}
!55 = !{i32 7, !"uwtable", i32 1}
!56 = !{i32 7, !"frame-pointer", i32 1}
!57 = !{!"Homebrew clang version 19.1.7"}
!58 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 16, type: !59, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!59 = !DISubroutineType(types: !60)
!60 = !{!10, !10}
!61 = !{}
!62 = !DILocalVariable(name: "arg", arg: 1, scope: !58, file: !3, line: 16, type: !10)
!63 = !DILocation(line: 16, column: 17, scope: !58)
!64 = !DILocalVariable(name: "tid", scope: !58, file: !3, line: 18, type: !5)
!65 = !DILocation(line: 18, column: 14, scope: !58)
!66 = !DILocation(line: 18, column: 31, scope: !58)
!67 = !DILocation(line: 18, column: 21, scope: !58)
!68 = !DILocation(line: 20, column: 9, scope: !69)
!69 = distinct !DILexicalBlock(scope: !58, file: !3, line: 20, column: 9)
!70 = !DILocation(line: 20, column: 13, scope: !69)
!71 = !DILocation(line: 20, column: 9, scope: !58)
!72 = !DILocalVariable(name: "acquired", scope: !73, file: !3, line: 22, type: !74)
!73 = distinct !DILexicalBlock(scope: !69, file: !3, line: 21, column: 5)
!74 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!75 = !DILocation(line: 22, column: 14, scope: !73)
!76 = !DILocation(line: 22, column: 25, scope: !73)
!77 = !DILocation(line: 23, column: 27, scope: !73)
!78 = !DILocation(line: 23, column: 9, scope: !73)
!79 = !DILocation(line: 24, column: 5, scope: !73)
!80 = !DILocation(line: 27, column: 9, scope: !81)
!81 = distinct !DILexicalBlock(scope: !69, file: !3, line: 26, column: 5)
!82 = !DILocation(line: 29, column: 6, scope: !58)
!83 = !DILocation(line: 30, column: 6, scope: !58)
!84 = !DILocation(line: 31, column: 5, scope: !58)
!85 = !DILocation(line: 33, column: 5, scope: !58)
!86 = distinct !DISubprogram(name: "ck_spinlock_dec_trylock", scope: !43, file: !43, line: 60, type: !87, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!87 = !DISubroutineType(types: !88)
!88 = !{!74, !89}
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!90 = !DILocalVariable(name: "lock", arg: 1, scope: !86, file: !43, line: 60, type: !89)
!91 = !DILocation(line: 60, column: 49, scope: !86)
!92 = !DILocalVariable(name: "value", scope: !86, file: !43, line: 62, type: !15)
!93 = !DILocation(line: 62, column: 15, scope: !86)
!94 = !DILocation(line: 64, column: 26, scope: !86)
!95 = !DILocation(line: 64, column: 32, scope: !86)
!96 = !DILocation(line: 64, column: 10, scope: !86)
!97 = !DILocation(line: 64, column: 8, scope: !86)
!98 = !DILocation(line: 65, column: 2, scope: !86)
!99 = !DILocation(line: 66, column: 9, scope: !86)
!100 = !DILocation(line: 66, column: 15, scope: !86)
!101 = !DILocation(line: 66, column: 2, scope: !86)
!102 = distinct !DISubprogram(name: "ck_spinlock_dec_lock", scope: !43, file: !43, line: 80, type: !103, scopeLine: 81, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!103 = !DISubroutineType(types: !104)
!104 = !{null, !89}
!105 = !DILocalVariable(name: "lock", arg: 1, scope: !102, file: !43, line: 80, type: !89)
!106 = !DILocation(line: 80, column: 46, scope: !102)
!107 = !DILocalVariable(name: "r", scope: !102, file: !43, line: 82, type: !74)
!108 = !DILocation(line: 82, column: 7, scope: !102)
!109 = !DILocation(line: 84, column: 2, scope: !102)
!110 = !DILocation(line: 90, column: 24, scope: !111)
!111 = distinct !DILexicalBlock(scope: !112, file: !43, line: 84, column: 11)
!112 = distinct !DILexicalBlock(scope: !113, file: !43, line: 84, column: 2)
!113 = distinct !DILexicalBlock(scope: !102, file: !43, line: 84, column: 2)
!114 = !DILocation(line: 90, column: 30, scope: !111)
!115 = !DILocation(line: 90, column: 3, scope: !111)
!116 = !DILocation(line: 91, column: 7, scope: !117)
!117 = distinct !DILexicalBlock(scope: !111, file: !43, line: 91, column: 7)
!118 = !DILocation(line: 91, column: 9, scope: !117)
!119 = !DILocation(line: 91, column: 7, scope: !111)
!120 = !DILocation(line: 92, column: 4, scope: !117)
!121 = !DILocation(line: 95, column: 3, scope: !111)
!122 = !DILocation(line: 95, column: 10, scope: !111)
!123 = !DILocation(line: 95, column: 40, scope: !111)
!124 = !DILocation(line: 96, column: 4, scope: !111)
!125 = distinct !{!125, !121, !126, !127}
!126 = !DILocation(line: 96, column: 16, scope: !111)
!127 = !{!"llvm.loop.mustprogress"}
!128 = !DILocation(line: 84, column: 2, scope: !112)
!129 = distinct !{!129, !130, !131}
!130 = !DILocation(line: 84, column: 2, scope: !113)
!131 = !DILocation(line: 97, column: 2, scope: !113)
!132 = !DILocation(line: 99, column: 2, scope: !102)
!133 = !DILocation(line: 100, column: 2, scope: !102)
!134 = distinct !DISubprogram(name: "ck_spinlock_dec_unlock", scope: !43, file: !43, line: 123, type: !103, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!135 = !DILocalVariable(name: "lock", arg: 1, scope: !134, file: !43, line: 123, type: !89)
!136 = !DILocation(line: 123, column: 48, scope: !134)
!137 = !DILocation(line: 126, column: 2, scope: !134)
!138 = !DILocation(line: 132, column: 2, scope: !134)
!139 = !DILocation(line: 133, column: 2, scope: !134)
!140 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 36, type: !141, scopeLine: 37, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!141 = !DISubroutineType(types: !142)
!142 = !{!22}
!143 = !DILocalVariable(name: "threads", scope: !140, file: !3, line: 38, type: !144)
!144 = !DICompositeType(tag: DW_TAG_array_type, baseType: !145, size: 128, elements: !167)
!145 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !146, line: 31, baseType: !147)
!146 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!147 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !148, line: 118, baseType: !149)
!148 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!149 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !150, size: 64)
!150 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !148, line: 103, size: 65536, elements: !151)
!151 = !{!152, !153, !163}
!152 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !150, file: !148, line: 104, baseType: !9, size: 64)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !150, file: !148, line: 105, baseType: !154, size: 64, offset: 64)
!154 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !155, size: 64)
!155 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !148, line: 57, size: 192, elements: !156)
!156 = !{!157, !161, !162}
!157 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !155, file: !148, line: 58, baseType: !158, size: 64)
!158 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !159, size: 64)
!159 = !DISubroutineType(types: !160)
!160 = !{null, !10}
!161 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !155, file: !148, line: 59, baseType: !10, size: 64, offset: 64)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !155, file: !148, line: 60, baseType: !154, size: 64, offset: 128)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !150, file: !148, line: 106, baseType: !164, size: 65408, offset: 128)
!164 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 65408, elements: !165)
!165 = !{!166}
!166 = !DISubrange(count: 8176)
!167 = !{!168}
!168 = !DISubrange(count: 2)
!169 = !DILocation(line: 38, column: 15, scope: !140)
!170 = !DILocalVariable(name: "i", scope: !140, file: !3, line: 39, type: !22)
!171 = !DILocation(line: 39, column: 9, scope: !140)
!172 = !DILocation(line: 41, column: 5, scope: !140)
!173 = !DILocation(line: 43, column: 12, scope: !174)
!174 = distinct !DILexicalBlock(scope: !140, file: !3, line: 43, column: 5)
!175 = !DILocation(line: 43, column: 10, scope: !174)
!176 = !DILocation(line: 43, column: 17, scope: !177)
!177 = distinct !DILexicalBlock(scope: !174, file: !3, line: 43, column: 5)
!178 = !DILocation(line: 43, column: 19, scope: !177)
!179 = !DILocation(line: 43, column: 5, scope: !174)
!180 = !DILocation(line: 45, column: 37, scope: !181)
!181 = distinct !DILexicalBlock(scope: !182, file: !3, line: 45, column: 13)
!182 = distinct !DILexicalBlock(scope: !177, file: !3, line: 44, column: 5)
!183 = !DILocation(line: 45, column: 29, scope: !181)
!184 = !DILocation(line: 45, column: 68, scope: !181)
!185 = !DILocation(line: 45, column: 60, scope: !181)
!186 = !DILocation(line: 45, column: 52, scope: !181)
!187 = !DILocation(line: 45, column: 13, scope: !181)
!188 = !DILocation(line: 45, column: 71, scope: !181)
!189 = !DILocation(line: 45, column: 13, scope: !182)
!190 = !DILocation(line: 47, column: 13, scope: !191)
!191 = distinct !DILexicalBlock(scope: !181, file: !3, line: 46, column: 9)
!192 = !DILocation(line: 49, column: 5, scope: !182)
!193 = !DILocation(line: 43, column: 32, scope: !177)
!194 = !DILocation(line: 43, column: 5, scope: !177)
!195 = distinct !{!195, !179, !196, !127}
!196 = !DILocation(line: 49, column: 5, scope: !174)
!197 = !DILocation(line: 51, column: 12, scope: !198)
!198 = distinct !DILexicalBlock(scope: !140, file: !3, line: 51, column: 5)
!199 = !DILocation(line: 51, column: 10, scope: !198)
!200 = !DILocation(line: 51, column: 17, scope: !201)
!201 = distinct !DILexicalBlock(scope: !198, file: !3, line: 51, column: 5)
!202 = !DILocation(line: 51, column: 19, scope: !201)
!203 = !DILocation(line: 51, column: 5, scope: !198)
!204 = !DILocation(line: 53, column: 34, scope: !205)
!205 = distinct !DILexicalBlock(scope: !206, file: !3, line: 53, column: 13)
!206 = distinct !DILexicalBlock(scope: !201, file: !3, line: 52, column: 5)
!207 = !DILocation(line: 53, column: 26, scope: !205)
!208 = !DILocation(line: 53, column: 13, scope: !205)
!209 = !DILocation(line: 53, column: 44, scope: !205)
!210 = !DILocation(line: 53, column: 13, scope: !206)
!211 = !DILocation(line: 55, column: 13, scope: !212)
!212 = distinct !DILexicalBlock(scope: !205, file: !3, line: 54, column: 9)
!213 = !DILocation(line: 57, column: 5, scope: !206)
!214 = !DILocation(line: 51, column: 32, scope: !201)
!215 = !DILocation(line: 51, column: 5, scope: !201)
!216 = distinct !{!216, !203, !217, !127}
!217 = !DILocation(line: 57, column: 5, scope: !198)
!218 = !DILocation(line: 59, column: 5, scope: !140)
!219 = !DILocation(line: 0, scope: !140)
!220 = !DILocation(line: 61, column: 5, scope: !140)
!221 = distinct !DISubprogram(name: "ck_spinlock_dec_init", scope: !43, file: !43, line: 51, type: !103, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!222 = !DILocalVariable(name: "lock", arg: 1, scope: !221, file: !43, line: 51, type: !89)
!223 = !DILocation(line: 51, column: 46, scope: !221)
!224 = !DILocation(line: 54, column: 2, scope: !221)
!225 = !DILocation(line: 54, column: 8, scope: !221)
!226 = !DILocation(line: 54, column: 14, scope: !221)
!227 = !DILocation(line: 55, column: 2, scope: !221)
!228 = !DILocation(line: 56, column: 2, scope: !221)
!229 = distinct !DISubprogram(name: "ck_pr_fas_uint", scope: !230, file: !230, line: 308, type: !231, scopeLine: 308, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!230 = !DIFile(filename: "include/gcc/ppc64/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "1c5aecf7376064f28c732d8a93471464")
!231 = !DISubroutineType(types: !232)
!232 = !{!15, !18, !15}
!233 = !DILocalVariable(name: "target", arg: 1, scope: !229, file: !230, line: 308, type: !18)
!234 = !DILocation(line: 308, column: 1, scope: !229)
!235 = !DILocalVariable(name: "v", arg: 2, scope: !229, file: !230, line: 308, type: !15)
!236 = !DILocalVariable(name: "previous", scope: !229, file: !230, line: 308, type: !15)
!237 = !{i64 2147776811}
!238 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !239, file: !239, line: 118, type: !240, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!239 = !DIFile(filename: "include/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "cffbc3bc631aa31cdde49d8ca6470a32")
!240 = !DISubroutineType(types: !241)
!241 = !{null}
!242 = !DILocation(line: 118, column: 1, scope: !238)
!243 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !230, file: !230, line: 88, type: !240, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!244 = !DILocation(line: 88, column: 1, scope: !243)
!245 = !{i64 2147763013}
!246 = distinct !DISubprogram(name: "ck_pr_dec_uint_zero", scope: !239, file: !239, line: 736, type: !247, scopeLine: 736, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!247 = !DISubroutineType(types: !248)
!248 = !{null, !18, !249}
!249 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!250 = !DILocalVariable(name: "target", arg: 1, scope: !246, file: !239, line: 736, type: !18)
!251 = !DILocation(line: 736, column: 1, scope: !246)
!252 = !DILocalVariable(name: "zero", arg: 2, scope: !246, file: !239, line: 736, type: !249)
!253 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !230, file: !230, line: 113, type: !254, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!254 = !DISubroutineType(types: !255)
!255 = !{!15, !16}
!256 = !DILocalVariable(name: "target", arg: 1, scope: !253, file: !230, line: 113, type: !16)
!257 = !DILocation(line: 113, column: 1, scope: !253)
!258 = !DILocalVariable(name: "r", scope: !253, file: !230, line: 113, type: !15)
!259 = !{i64 2147765548}
!260 = distinct !DISubprogram(name: "ck_pr_stall", scope: !230, file: !230, line: 56, type: !240, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!261 = !DILocation(line: 59, column: 2, scope: !260)
!262 = !{i64 264581}
!263 = !DILocation(line: 61, column: 2, scope: !260)
!264 = distinct !DISubprogram(name: "ck_pr_dec_uint_is_zero", scope: !239, file: !239, line: 736, type: !265, scopeLine: 736, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!265 = !DISubroutineType(types: !266)
!266 = !{!74, !18}
!267 = !DILocalVariable(name: "target", arg: 1, scope: !264, file: !239, line: 736, type: !18)
!268 = !DILocation(line: 736, column: 1, scope: !264)
!269 = !DILocalVariable(name: "previous", scope: !264, file: !239, line: 736, type: !15)
!270 = !DILocalVariable(name: "punt", scope: !264, file: !239, line: 736, type: !15)
!271 = distinct !{!271, !268, !268, !127}
!272 = distinct !DISubprogram(name: "ck_pr_cas_uint_value", scope: !230, file: !230, line: 280, type: !273, scopeLine: 280, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!273 = !DISubroutineType(types: !274)
!274 = !{!74, !18, !15, !15, !18}
!275 = !DILocalVariable(name: "target", arg: 1, scope: !272, file: !230, line: 280, type: !18)
!276 = !DILocation(line: 280, column: 1, scope: !272)
!277 = !DILocalVariable(name: "compare", arg: 2, scope: !272, file: !230, line: 280, type: !15)
!278 = !DILocalVariable(name: "set", arg: 3, scope: !272, file: !230, line: 280, type: !15)
!279 = !DILocalVariable(name: "value", arg: 4, scope: !272, file: !230, line: 280, type: !18)
!280 = !DILocalVariable(name: "previous", scope: !272, file: !230, line: 280, type: !15)
!281 = !{i64 2147772205}
!282 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !239, file: !239, line: 119, type: !240, scopeLine: 119, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!283 = !DILocation(line: 119, column: 1, scope: !282)
!284 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !230, file: !230, line: 143, type: !285, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !61)
!285 = !DISubroutineType(types: !286)
!286 = !{null, !18, !15}
!287 = !DILocalVariable(name: "target", arg: 1, scope: !284, file: !230, line: 143, type: !18)
!288 = !DILocation(line: 143, column: 1, scope: !284)
!289 = !DILocalVariable(name: "v", arg: 2, scope: !284, file: !230, line: 143, type: !15)
!290 = !{i64 2147769195}
!291 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !230, file: !230, line: 89, type: !240, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!292 = !DILocation(line: 89, column: 1, scope: !291)
!293 = !{i64 2147763210}
!294 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !295, file: !295, line: 37, type: !240, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!295 = !DIFile(filename: "include/gcc/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!296 = !DILocation(line: 40, column: 2, scope: !294)
!297 = !{i64 320282}
!298 = !DILocation(line: 41, column: 2, scope: !294)
