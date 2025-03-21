; ModuleID = 'tests/caslock.c'
source_filename = "tests/caslock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_spinlock_cas = type { i32 }

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !20
@lock = global %struct.ck_spinlock_cas zeroinitializer, align 4, !dbg !40
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !23
@.str = private unnamed_addr constant [10 x i8] c"caslock.c\00", align 1, !dbg !30
@.str.1 = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !35

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 !dbg !55 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8, !dbg !63
  %6 = ptrtoint ptr %5 to i64, !dbg !64
  store i64 %6, ptr %3, align 8, !dbg !62
  %7 = load i64, ptr %3, align 8, !dbg !65
  %8 = icmp eq i64 %7, 2, !dbg !67
  br i1 %8, label %9, label %15, !dbg !68

9:                                                ; preds = %1
  %10 = call zeroext i1 @ck_spinlock_cas_trylock(ptr noundef @lock), !dbg !73
  %11 = zext i1 %10 to i8, !dbg !72
  store i8 %11, ptr %4, align 1, !dbg !72
  %12 = load i8, ptr %4, align 1, !dbg !74
  %13 = trunc i8 %12 to i1, !dbg !74
  %14 = zext i1 %13 to i32, !dbg !74
  call void @__VERIFIER_assume(i32 noundef %14), !dbg !75
  br label %16, !dbg !76

15:                                               ; preds = %1
  call void @ck_spinlock_cas_lock(ptr noundef @lock), !dbg !77
  br label %16

16:                                               ; preds = %15, %9
  %17 = load i32, ptr @x, align 4, !dbg !79
  %18 = add nsw i32 %17, 1, !dbg !79
  store i32 %18, ptr @x, align 4, !dbg !79
  %19 = load i32, ptr @y, align 4, !dbg !80
  %20 = add nsw i32 %19, 1, !dbg !80
  store i32 %20, ptr @y, align 4, !dbg !80
  call void @ck_spinlock_cas_unlock(ptr noundef @lock), !dbg !81
  ret ptr null, !dbg !82
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_spinlock_cas_trylock(ptr noundef %0) #0 !dbg !83 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !91
  %5 = getelementptr inbounds %struct.ck_spinlock_cas, ptr %4, i32 0, i32 0, !dbg !92
  %6 = call i32 @ck_pr_fas_uint(ptr noundef %5, i32 noundef 1), !dbg !93
  store i32 %6, ptr %3, align 4, !dbg !94
  call void @ck_pr_fence_lock(), !dbg !95
  %7 = load i32, ptr %3, align 4, !dbg !96
  %8 = icmp ne i32 %7, 0, !dbg !97
  %9 = xor i1 %8, true, !dbg !97
  ret i1 %9, !dbg !98
}

declare void @__VERIFIER_assume(i32 noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_cas_lock(ptr noundef %0) #0 !dbg !99 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  br label %3, !dbg !104

3:                                                ; preds = %16, %1
  %4 = load ptr, ptr %2, align 8, !dbg !105
  %5 = getelementptr inbounds %struct.ck_spinlock_cas, ptr %4, i32 0, i32 0, !dbg !106
  %6 = call zeroext i1 @ck_pr_cas_uint(ptr noundef %5, i32 noundef 0, i32 noundef 1), !dbg !107
  %7 = zext i1 %6 to i32, !dbg !107
  %8 = icmp eq i32 %7, 0, !dbg !108
  br i1 %8, label %9, label %17, !dbg !104

9:                                                ; preds = %3
  br label %10, !dbg !109

10:                                               ; preds = %15, %9
  %11 = load ptr, ptr %2, align 8, !dbg !111
  %12 = getelementptr inbounds %struct.ck_spinlock_cas, ptr %11, i32 0, i32 0, !dbg !111
  %13 = call i32 @ck_pr_md_load_uint(ptr noundef %12), !dbg !111
  %14 = icmp eq i32 %13, 1, !dbg !112
  br i1 %14, label %15, label %16, !dbg !109

15:                                               ; preds = %10
  call void @ck_pr_stall(), !dbg !113
  br label %10, !dbg !109, !llvm.loop !114

16:                                               ; preds = %10
  br label %3, !dbg !104, !llvm.loop !117

17:                                               ; preds = %3
  call void @ck_pr_fence_lock(), !dbg !119
  ret void, !dbg !120
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_cas_unlock(ptr noundef %0) #0 !dbg !121 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @ck_pr_fence_unlock(), !dbg !124
  %3 = load ptr, ptr %2, align 8, !dbg !125
  %4 = getelementptr inbounds %struct.ck_spinlock_cas, ptr %3, i32 0, i32 0, !dbg !125
  call void @ck_pr_md_store_uint(ptr noundef %4, i32 noundef 0), !dbg !125
  ret void, !dbg !126
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !127 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @ck_spinlock_cas_init(ptr noundef @lock), !dbg !159
  store i32 0, ptr %3, align 4, !dbg !160
  br label %4, !dbg !162

4:                                                ; preds = %18, %0
  %5 = load i32, ptr %3, align 4, !dbg !163
  %6 = icmp slt i32 %5, 3, !dbg !165
  br i1 %6, label %7, label %21, !dbg !166

7:                                                ; preds = %4
  %8 = load i32, ptr %3, align 4, !dbg !167
  %9 = sext i32 %8 to i64, !dbg !170
  %10 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %9, !dbg !170
  %11 = load i32, ptr %3, align 4, !dbg !171
  %12 = sext i32 %11 to i64, !dbg !172
  %13 = inttoptr i64 %12 to ptr, !dbg !173
  %14 = call i32 @pthread_create(ptr noundef %10, ptr noundef null, ptr noundef @run, ptr noundef %13), !dbg !174
  %15 = icmp ne i32 %14, 0, !dbg !175
  br i1 %15, label %16, label %17, !dbg !176

16:                                               ; preds = %7
  call void @exit(i32 noundef 1) #4, !dbg !177
  unreachable, !dbg !177

17:                                               ; preds = %7
  br label %18, !dbg !179

18:                                               ; preds = %17
  %19 = load i32, ptr %3, align 4, !dbg !180
  %20 = add nsw i32 %19, 1, !dbg !180
  store i32 %20, ptr %3, align 4, !dbg !180
  br label %4, !dbg !181, !llvm.loop !182

21:                                               ; preds = %4
  store i32 0, ptr %3, align 4, !dbg !184
  br label %22, !dbg !186

22:                                               ; preds = %34, %21
  %23 = load i32, ptr %3, align 4, !dbg !187
  %24 = icmp slt i32 %23, 3, !dbg !189
  br i1 %24, label %25, label %37, !dbg !190

25:                                               ; preds = %22
  %26 = load i32, ptr %3, align 4, !dbg !191
  %27 = sext i32 %26 to i64, !dbg !194
  %28 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %27, !dbg !194
  %29 = load ptr, ptr %28, align 8, !dbg !194
  %30 = call i32 @"\01_pthread_join"(ptr noundef %29, ptr noundef null), !dbg !195
  %31 = icmp ne i32 %30, 0, !dbg !196
  br i1 %31, label %32, label %33, !dbg !197

32:                                               ; preds = %25
  call void @exit(i32 noundef 1) #4, !dbg !198
  unreachable, !dbg !198

33:                                               ; preds = %25
  br label %34, !dbg !200

34:                                               ; preds = %33
  %35 = load i32, ptr %3, align 4, !dbg !201
  %36 = add nsw i32 %35, 1, !dbg !201
  store i32 %36, ptr %3, align 4, !dbg !201
  br label %22, !dbg !202, !llvm.loop !203

37:                                               ; preds = %22
  %38 = load i32, ptr @x, align 4, !dbg !205
  %39 = icmp eq i32 %38, 3, !dbg !205
  br i1 %39, label %40, label %43, !dbg !205

40:                                               ; preds = %37
  %41 = load i32, ptr @y, align 4, !dbg !205
  %42 = icmp eq i32 %41, 3, !dbg !205
  br label %43

43:                                               ; preds = %40, %37
  %44 = phi i1 [ false, %37 ], [ %42, %40 ], !dbg !206
  %45 = xor i1 %44, true, !dbg !205
  %46 = zext i1 %45 to i32, !dbg !205
  %47 = sext i32 %46 to i64, !dbg !205
  %48 = icmp ne i64 %47, 0, !dbg !205
  br i1 %48, label %49, label %51, !dbg !205

49:                                               ; preds = %43
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 59, ptr noundef @.str.1) #5, !dbg !205
  unreachable, !dbg !205

50:                                               ; No predecessors!
  br label %52, !dbg !205

51:                                               ; preds = %43
  br label %52, !dbg !205

52:                                               ; preds = %51, %50
  ret i32 0, !dbg !207
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_cas_init(ptr noundef %0) #0 !dbg !208 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8, !dbg !211
  %4 = getelementptr inbounds %struct.ck_spinlock_cas, ptr %3, i32 0, i32 0, !dbg !212
  store i32 0, ptr %4, align 4, !dbg !213
  call void @ck_pr_barrier(), !dbg !214
  ret void, !dbg !215
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #2

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_fas_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !216 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %6 = load ptr, ptr %3, align 8, !dbg !221
  %7 = load i32, ptr %4, align 4, !dbg !221
  %8 = call i32 asm sideeffect "1:;lwarx $0, 0, $1;stwcx. $2, 0, $1;bne- 1b;", "=&r,r,r,~{memory},~{cc}"(ptr %6, i32 %7) #6, !dbg !221, !srcloc !224
  store i32 %8, ptr %5, align 4, !dbg !221
  %9 = load i32, ptr %5, align 4, !dbg !221
  ret i32 %9, !dbg !221
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_lock() #0 !dbg !225 {
  call void @ck_pr_fence_strict_lock(), !dbg !229
  ret void, !dbg !229
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_lock() #0 !dbg !230 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !231, !srcloc !232
  ret void, !dbg !231
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_pr_cas_uint(ptr noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !233 {
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store i32 %1, ptr %5, align 4
  store i32 %2, ptr %6, align 4
  %8 = load ptr, ptr %4, align 8, !dbg !237
  %9 = load i32, ptr %6, align 4, !dbg !237
  %10 = load i32, ptr %5, align 4, !dbg !237
  %11 = call i32 asm sideeffect "1:;lwarx $0, 0, $1;cmpw  0, $0, $3;bne-  2f;stwcx. $2, 0, $1;bne-  1b;2:", "=&r,r,r,r,~{memory},~{cc}"(ptr %8, i32 %9, i32 %10) #6, !dbg !237, !srcloc !241
  store i32 %11, ptr %7, align 4, !dbg !237
  %12 = load i32, ptr %7, align 4, !dbg !237
  %13 = load i32, ptr %5, align 4, !dbg !237
  %14 = icmp eq i32 %12, %13, !dbg !237
  ret i1 %14, !dbg !237
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !242 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !246
  %5 = call i32 asm sideeffect "lwz $0, $1", "=r,*m,~{memory}"(ptr elementtype(i32) %4) #6, !dbg !246, !srcloc !248
  store i32 %5, ptr %3, align 4, !dbg !246
  %6 = load i32, ptr %3, align 4, !dbg !246
  ret i32 %6, !dbg !246
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_stall() #0 !dbg !249 {
  call void asm sideeffect "or 1, 1, 1;or 2, 2, 2;", "~{memory}"() #6, !dbg !250, !srcloc !251
  ret void, !dbg !252
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_unlock() #0 !dbg !253 {
  call void @ck_pr_fence_strict_unlock(), !dbg !254
  ret void, !dbg !254
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !255 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8, !dbg !259
  %6 = load i32, ptr %4, align 4, !dbg !259
  call void asm sideeffect "stw $1, $0", "=*m,r,~{memory}"(ptr elementtype(i32) %5, i32 %6) #6, !dbg !259, !srcloc !261
  ret void, !dbg !259
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_unlock() #0 !dbg !262 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !263, !srcloc !264
  ret void, !dbg !263
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_barrier() #0 !dbg !265 {
  call void asm sideeffect "", "~{memory}"() #6, !dbg !267, !srcloc !268
  ret void, !dbg !269
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #4 = { noreturn }
attributes #5 = { cold noreturn }
attributes #6 = { nounwind }

!llvm.module.flags = !{!47, !48, !49, !50, !51, !52, !53}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!54}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 15, type: !22, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !19, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "tests/caslock.c", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "eaf093b9cc44413a628cfc72d3a4aa19")
!4 = !{!5, !10, !11, !15, !18}
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
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!17 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!19 = !{!0, !20, !23, !30, !35, !40}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 15, type: !22, isLocal: false, isDefinition: true)
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
!41 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 14, type: !42, isLocal: false, isDefinition: true)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_cas_t", file: !43, line: 44, baseType: !44)
!43 = !DIFile(filename: "include/spinlock/cas.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "ce076f374c67b364c8434ea638760107")
!44 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_cas", file: !43, line: 41, size: 32, elements: !45)
!45 = !{!46}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !44, file: !43, line: 42, baseType: !17, size: 32)
!47 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 0]}
!48 = !{i32 7, !"Dwarf Version", i32 5}
!49 = !{i32 2, !"Debug Info Version", i32 3}
!50 = !{i32 1, !"wchar_size", i32 4}
!51 = !{i32 8, !"PIC Level", i32 2}
!52 = !{i32 7, !"uwtable", i32 1}
!53 = !{i32 7, !"frame-pointer", i32 1}
!54 = !{!"Homebrew clang version 19.1.7"}
!55 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 17, type: !56, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!56 = !DISubroutineType(types: !57)
!57 = !{!10, !10}
!58 = !{}
!59 = !DILocalVariable(name: "arg", arg: 1, scope: !55, file: !3, line: 17, type: !10)
!60 = !DILocation(line: 17, column: 17, scope: !55)
!61 = !DILocalVariable(name: "tid", scope: !55, file: !3, line: 20, type: !5)
!62 = !DILocation(line: 20, column: 14, scope: !55)
!63 = !DILocation(line: 20, column: 32, scope: !55)
!64 = !DILocation(line: 20, column: 21, scope: !55)
!65 = !DILocation(line: 24, column: 9, scope: !66)
!66 = distinct !DILexicalBlock(scope: !55, file: !3, line: 24, column: 9)
!67 = !DILocation(line: 24, column: 13, scope: !66)
!68 = !DILocation(line: 24, column: 9, scope: !55)
!69 = !DILocalVariable(name: "acquired", scope: !70, file: !3, line: 26, type: !71)
!70 = distinct !DILexicalBlock(scope: !66, file: !3, line: 25, column: 5)
!71 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!72 = !DILocation(line: 26, column: 14, scope: !70)
!73 = !DILocation(line: 26, column: 25, scope: !70)
!74 = !DILocation(line: 27, column: 27, scope: !70)
!75 = !DILocation(line: 27, column: 9, scope: !70)
!76 = !DILocation(line: 28, column: 5, scope: !70)
!77 = !DILocation(line: 31, column: 9, scope: !78)
!78 = distinct !DILexicalBlock(scope: !66, file: !3, line: 30, column: 5)
!79 = !DILocation(line: 34, column: 6, scope: !55)
!80 = !DILocation(line: 35, column: 6, scope: !55)
!81 = !DILocation(line: 36, column: 5, scope: !55)
!82 = !DILocation(line: 37, column: 5, scope: !55)
!83 = distinct !DISubprogram(name: "ck_spinlock_cas_trylock", scope: !43, file: !43, line: 58, type: !84, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!84 = !DISubroutineType(types: !85)
!85 = !{!71, !86}
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!87 = !DILocalVariable(name: "lock", arg: 1, scope: !83, file: !43, line: 58, type: !86)
!88 = !DILocation(line: 58, column: 49, scope: !83)
!89 = !DILocalVariable(name: "value", scope: !83, file: !43, line: 60, type: !17)
!90 = !DILocation(line: 60, column: 15, scope: !83)
!91 = !DILocation(line: 62, column: 26, scope: !83)
!92 = !DILocation(line: 62, column: 32, scope: !83)
!93 = !DILocation(line: 62, column: 10, scope: !83)
!94 = !DILocation(line: 62, column: 8, scope: !83)
!95 = !DILocation(line: 63, column: 2, scope: !83)
!96 = !DILocation(line: 64, column: 10, scope: !83)
!97 = !DILocation(line: 64, column: 9, scope: !83)
!98 = !DILocation(line: 64, column: 2, scope: !83)
!99 = distinct !DISubprogram(name: "ck_spinlock_cas_lock", scope: !43, file: !43, line: 77, type: !100, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!100 = !DISubroutineType(types: !101)
!101 = !{null, !86}
!102 = !DILocalVariable(name: "lock", arg: 1, scope: !99, file: !43, line: 77, type: !86)
!103 = !DILocation(line: 77, column: 46, scope: !99)
!104 = !DILocation(line: 80, column: 2, scope: !99)
!105 = !DILocation(line: 80, column: 25, scope: !99)
!106 = !DILocation(line: 80, column: 31, scope: !99)
!107 = !DILocation(line: 80, column: 9, scope: !99)
!108 = !DILocation(line: 80, column: 51, scope: !99)
!109 = !DILocation(line: 81, column: 3, scope: !110)
!110 = distinct !DILexicalBlock(scope: !99, file: !43, line: 80, column: 61)
!111 = !DILocation(line: 81, column: 10, scope: !110)
!112 = !DILocation(line: 81, column: 40, scope: !110)
!113 = !DILocation(line: 82, column: 4, scope: !110)
!114 = distinct !{!114, !109, !115, !116}
!115 = !DILocation(line: 82, column: 16, scope: !110)
!116 = !{!"llvm.loop.mustprogress"}
!117 = distinct !{!117, !104, !118, !116}
!118 = !DILocation(line: 83, column: 2, scope: !99)
!119 = !DILocation(line: 85, column: 2, scope: !99)
!120 = !DILocation(line: 86, column: 2, scope: !99)
!121 = distinct !DISubprogram(name: "ck_spinlock_cas_unlock", scope: !43, file: !43, line: 102, type: !100, scopeLine: 103, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!122 = !DILocalVariable(name: "lock", arg: 1, scope: !121, file: !43, line: 102, type: !86)
!123 = !DILocation(line: 102, column: 48, scope: !121)
!124 = !DILocation(line: 106, column: 2, scope: !121)
!125 = !DILocation(line: 107, column: 2, scope: !121)
!126 = !DILocation(line: 108, column: 2, scope: !121)
!127 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 40, type: !128, scopeLine: 41, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!128 = !DISubroutineType(types: !129)
!129 = !{!22}
!130 = !DILocalVariable(name: "threads", scope: !127, file: !3, line: 42, type: !131)
!131 = !DICompositeType(tag: DW_TAG_array_type, baseType: !132, size: 192, elements: !154)
!132 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !133, line: 31, baseType: !134)
!133 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!134 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !135, line: 118, baseType: !136)
!135 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!136 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !137, size: 64)
!137 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !135, line: 103, size: 65536, elements: !138)
!138 = !{!139, !140, !150}
!139 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !137, file: !135, line: 104, baseType: !9, size: 64)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !137, file: !135, line: 105, baseType: !141, size: 64, offset: 64)
!141 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !142, size: 64)
!142 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !135, line: 57, size: 192, elements: !143)
!143 = !{!144, !148, !149}
!144 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !142, file: !135, line: 58, baseType: !145, size: 64)
!145 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !146, size: 64)
!146 = !DISubroutineType(types: !147)
!147 = !{null, !10}
!148 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !142, file: !135, line: 59, baseType: !10, size: 64, offset: 64)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !142, file: !135, line: 60, baseType: !141, size: 64, offset: 128)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !137, file: !135, line: 106, baseType: !151, size: 65408, offset: 128)
!151 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 65408, elements: !152)
!152 = !{!153}
!153 = !DISubrange(count: 8176)
!154 = !{!155}
!155 = !DISubrange(count: 3)
!156 = !DILocation(line: 42, column: 15, scope: !127)
!157 = !DILocalVariable(name: "i", scope: !127, file: !3, line: 43, type: !22)
!158 = !DILocation(line: 43, column: 9, scope: !127)
!159 = !DILocation(line: 44, column: 5, scope: !127)
!160 = !DILocation(line: 45, column: 12, scope: !161)
!161 = distinct !DILexicalBlock(scope: !127, file: !3, line: 45, column: 5)
!162 = !DILocation(line: 45, column: 10, scope: !161)
!163 = !DILocation(line: 45, column: 17, scope: !164)
!164 = distinct !DILexicalBlock(scope: !161, file: !3, line: 45, column: 5)
!165 = !DILocation(line: 45, column: 19, scope: !164)
!166 = !DILocation(line: 45, column: 5, scope: !161)
!167 = !DILocation(line: 47, column: 37, scope: !168)
!168 = distinct !DILexicalBlock(scope: !169, file: !3, line: 47, column: 13)
!169 = distinct !DILexicalBlock(scope: !164, file: !3, line: 46, column: 5)
!170 = !DILocation(line: 47, column: 29, scope: !168)
!171 = !DILocation(line: 47, column: 69, scope: !168)
!172 = !DILocation(line: 47, column: 60, scope: !168)
!173 = !DILocation(line: 47, column: 52, scope: !168)
!174 = !DILocation(line: 47, column: 13, scope: !168)
!175 = !DILocation(line: 47, column: 72, scope: !168)
!176 = !DILocation(line: 47, column: 13, scope: !169)
!177 = !DILocation(line: 49, column: 13, scope: !178)
!178 = distinct !DILexicalBlock(scope: !168, file: !3, line: 48, column: 9)
!179 = !DILocation(line: 51, column: 5, scope: !169)
!180 = !DILocation(line: 45, column: 32, scope: !164)
!181 = !DILocation(line: 45, column: 5, scope: !164)
!182 = distinct !{!182, !166, !183, !116}
!183 = !DILocation(line: 51, column: 5, scope: !161)
!184 = !DILocation(line: 52, column: 12, scope: !185)
!185 = distinct !DILexicalBlock(scope: !127, file: !3, line: 52, column: 5)
!186 = !DILocation(line: 52, column: 10, scope: !185)
!187 = !DILocation(line: 52, column: 17, scope: !188)
!188 = distinct !DILexicalBlock(scope: !185, file: !3, line: 52, column: 5)
!189 = !DILocation(line: 52, column: 19, scope: !188)
!190 = !DILocation(line: 52, column: 5, scope: !185)
!191 = !DILocation(line: 54, column: 34, scope: !192)
!192 = distinct !DILexicalBlock(scope: !193, file: !3, line: 54, column: 13)
!193 = distinct !DILexicalBlock(scope: !188, file: !3, line: 53, column: 5)
!194 = !DILocation(line: 54, column: 26, scope: !192)
!195 = !DILocation(line: 54, column: 13, scope: !192)
!196 = !DILocation(line: 54, column: 44, scope: !192)
!197 = !DILocation(line: 54, column: 13, scope: !193)
!198 = !DILocation(line: 56, column: 13, scope: !199)
!199 = distinct !DILexicalBlock(scope: !192, file: !3, line: 55, column: 9)
!200 = !DILocation(line: 58, column: 5, scope: !193)
!201 = !DILocation(line: 52, column: 32, scope: !188)
!202 = !DILocation(line: 52, column: 5, scope: !188)
!203 = distinct !{!203, !190, !204, !116}
!204 = !DILocation(line: 58, column: 5, scope: !185)
!205 = !DILocation(line: 59, column: 5, scope: !127)
!206 = !DILocation(line: 0, scope: !127)
!207 = !DILocation(line: 60, column: 5, scope: !127)
!208 = distinct !DISubprogram(name: "ck_spinlock_cas_init", scope: !43, file: !43, line: 49, type: !100, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!209 = !DILocalVariable(name: "lock", arg: 1, scope: !208, file: !43, line: 49, type: !86)
!210 = !DILocation(line: 49, column: 46, scope: !208)
!211 = !DILocation(line: 52, column: 2, scope: !208)
!212 = !DILocation(line: 52, column: 8, scope: !208)
!213 = !DILocation(line: 52, column: 14, scope: !208)
!214 = !DILocation(line: 53, column: 2, scope: !208)
!215 = !DILocation(line: 54, column: 2, scope: !208)
!216 = distinct !DISubprogram(name: "ck_pr_fas_uint", scope: !217, file: !217, line: 308, type: !218, scopeLine: 308, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!217 = !DIFile(filename: "include/gcc/ppc64/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "1c5aecf7376064f28c732d8a93471464")
!218 = !DISubroutineType(types: !219)
!219 = !{!17, !18, !17}
!220 = !DILocalVariable(name: "target", arg: 1, scope: !216, file: !217, line: 308, type: !18)
!221 = !DILocation(line: 308, column: 1, scope: !216)
!222 = !DILocalVariable(name: "v", arg: 2, scope: !216, file: !217, line: 308, type: !17)
!223 = !DILocalVariable(name: "previous", scope: !216, file: !217, line: 308, type: !17)
!224 = !{i64 2147776967}
!225 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !226, file: !226, line: 118, type: !227, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!226 = !DIFile(filename: "include/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "cffbc3bc631aa31cdde49d8ca6470a32")
!227 = !DISubroutineType(types: !228)
!228 = !{null}
!229 = !DILocation(line: 118, column: 1, scope: !225)
!230 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !217, file: !217, line: 88, type: !227, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!231 = !DILocation(line: 88, column: 1, scope: !230)
!232 = !{i64 2147763169}
!233 = distinct !DISubprogram(name: "ck_pr_cas_uint", scope: !217, file: !217, line: 280, type: !234, scopeLine: 280, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!234 = !DISubroutineType(types: !235)
!235 = !{!71, !18, !17, !17}
!236 = !DILocalVariable(name: "target", arg: 1, scope: !233, file: !217, line: 280, type: !18)
!237 = !DILocation(line: 280, column: 1, scope: !233)
!238 = !DILocalVariable(name: "compare", arg: 2, scope: !233, file: !217, line: 280, type: !17)
!239 = !DILocalVariable(name: "set", arg: 3, scope: !233, file: !217, line: 280, type: !17)
!240 = !DILocalVariable(name: "previous", scope: !233, file: !217, line: 280, type: !17)
!241 = !{i64 2147772880}
!242 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !217, file: !217, line: 113, type: !243, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!243 = !DISubroutineType(types: !244)
!244 = !{!17, !15}
!245 = !DILocalVariable(name: "target", arg: 1, scope: !242, file: !217, line: 113, type: !15)
!246 = !DILocation(line: 113, column: 1, scope: !242)
!247 = !DILocalVariable(name: "r", scope: !242, file: !217, line: 113, type: !17)
!248 = !{i64 2147765704}
!249 = distinct !DISubprogram(name: "ck_pr_stall", scope: !217, file: !217, line: 56, type: !227, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!250 = !DILocation(line: 59, column: 2, scope: !249)
!251 = !{i64 264737}
!252 = !DILocation(line: 61, column: 2, scope: !249)
!253 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !226, file: !226, line: 119, type: !227, scopeLine: 119, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!254 = !DILocation(line: 119, column: 1, scope: !253)
!255 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !217, file: !217, line: 143, type: !256, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!256 = !DISubroutineType(types: !257)
!257 = !{null, !18, !17}
!258 = !DILocalVariable(name: "target", arg: 1, scope: !255, file: !217, line: 143, type: !18)
!259 = !DILocation(line: 143, column: 1, scope: !255)
!260 = !DILocalVariable(name: "v", arg: 2, scope: !255, file: !217, line: 143, type: !17)
!261 = !{i64 2147769351}
!262 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !217, file: !217, line: 89, type: !227, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!263 = !DILocation(line: 89, column: 1, scope: !262)
!264 = !{i64 2147763366}
!265 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !266, file: !266, line: 37, type: !227, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!266 = !DIFile(filename: "include/gcc/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!267 = !DILocation(line: 40, column: 2, scope: !265)
!268 = !{i64 320438}
!269 = !DILocation(line: 41, column: 2, scope: !265)
