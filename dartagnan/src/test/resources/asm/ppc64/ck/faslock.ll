; ModuleID = 'tests/faslock.c'
source_filename = "tests/faslock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_spinlock_fas = type { i32 }

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !20
@lock = global %struct.ck_spinlock_fas zeroinitializer, align 4, !dbg !40
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !23
@.str = private unnamed_addr constant [10 x i8] c"faslock.c\00", align 1, !dbg !30
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
  %10 = call zeroext i1 @ck_spinlock_fas_trylock(ptr noundef @lock), !dbg !73
  %11 = zext i1 %10 to i8, !dbg !72
  store i8 %11, ptr %4, align 1, !dbg !72
  %12 = load i8, ptr %4, align 1, !dbg !74
  %13 = trunc i8 %12 to i1, !dbg !74
  %14 = zext i1 %13 to i32, !dbg !74
  call void @__VERIFIER_assume(i32 noundef %14), !dbg !75
  br label %16, !dbg !76

15:                                               ; preds = %1
  call void @ck_spinlock_fas_lock(ptr noundef @lock), !dbg !77
  br label %16

16:                                               ; preds = %15, %9
  %17 = load i32, ptr @x, align 4, !dbg !79
  %18 = add nsw i32 %17, 1, !dbg !79
  store i32 %18, ptr @x, align 4, !dbg !79
  %19 = load i32, ptr @y, align 4, !dbg !80
  %20 = add nsw i32 %19, 1, !dbg !80
  store i32 %20, ptr @y, align 4, !dbg !80
  call void @ck_spinlock_fas_unlock(ptr noundef @lock), !dbg !81
  ret ptr null, !dbg !82
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_spinlock_fas_trylock(ptr noundef %0) #0 !dbg !83 {
  %2 = alloca ptr, align 8
  %3 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !91
  %5 = getelementptr inbounds %struct.ck_spinlock_fas, ptr %4, i32 0, i32 0, !dbg !92
  %6 = call i32 @ck_pr_fas_uint(ptr noundef %5, i32 noundef 1), !dbg !93
  %7 = icmp ne i32 %6, 0, !dbg !93
  %8 = zext i1 %7 to i8, !dbg !94
  store i8 %8, ptr %3, align 1, !dbg !94
  call void @ck_pr_fence_lock(), !dbg !95
  %9 = load i8, ptr %3, align 1, !dbg !96
  %10 = trunc i8 %9 to i1, !dbg !96
  %11 = xor i1 %10, true, !dbg !97
  ret i1 %11, !dbg !98
}

declare void @__VERIFIER_assume(i32 noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_fas_lock(ptr noundef %0) #0 !dbg !99 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  br label %3, !dbg !104

3:                                                ; preds = %20, %1
  %4 = load ptr, ptr %2, align 8, !dbg !105
  %5 = getelementptr inbounds %struct.ck_spinlock_fas, ptr %4, i32 0, i32 0, !dbg !105
  %6 = call i32 @ck_pr_fas_uint(ptr noundef %5, i32 noundef 1), !dbg !105
  %7 = icmp eq i32 %6, 1, !dbg !105
  %8 = xor i1 %7, true, !dbg !105
  %9 = xor i1 %8, true, !dbg !105
  %10 = zext i1 %9 to i32, !dbg !105
  %11 = sext i32 %10 to i64, !dbg !105
  %12 = icmp ne i64 %11, 0, !dbg !104
  br i1 %12, label %13, label %21, !dbg !104

13:                                               ; preds = %3
  br label %14, !dbg !106

14:                                               ; preds = %15, %13
  call void @ck_pr_stall(), !dbg !108
  br label %15, !dbg !110

15:                                               ; preds = %14
  %16 = load ptr, ptr %2, align 8, !dbg !111
  %17 = getelementptr inbounds %struct.ck_spinlock_fas, ptr %16, i32 0, i32 0, !dbg !111
  %18 = call i32 @ck_pr_md_load_uint(ptr noundef %17), !dbg !111
  %19 = icmp eq i32 %18, 1, !dbg !112
  br i1 %19, label %14, label %20, !dbg !110, !llvm.loop !113

20:                                               ; preds = %15
  br label %3, !dbg !104, !llvm.loop !116

21:                                               ; preds = %3
  call void @ck_pr_fence_lock(), !dbg !118
  ret void, !dbg !119
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_fas_unlock(ptr noundef %0) #0 !dbg !120 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @ck_pr_fence_unlock(), !dbg !123
  %3 = load ptr, ptr %2, align 8, !dbg !124
  %4 = getelementptr inbounds %struct.ck_spinlock_fas, ptr %3, i32 0, i32 0, !dbg !124
  call void @ck_pr_md_store_uint(ptr noundef %4, i32 noundef 0), !dbg !124
  ret void, !dbg !125
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !126 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca [3 x i32], align 4
  %4 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @ck_spinlock_fas_init(ptr noundef @lock), !dbg !161
  store i32 0, ptr %4, align 4, !dbg !162
  br label %5, !dbg !164

5:                                                ; preds = %19, %0
  %6 = load i32, ptr %4, align 4, !dbg !165
  %7 = icmp slt i32 %6, 3, !dbg !167
  br i1 %7, label %8, label %22, !dbg !168

8:                                                ; preds = %5
  %9 = load i32, ptr %4, align 4, !dbg !169
  %10 = sext i32 %9 to i64, !dbg !172
  %11 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %10, !dbg !172
  %12 = load i32, ptr %4, align 4, !dbg !173
  %13 = sext i32 %12 to i64, !dbg !174
  %14 = inttoptr i64 %13 to ptr, !dbg !175
  %15 = call i32 @pthread_create(ptr noundef %11, ptr noundef null, ptr noundef @run, ptr noundef %14), !dbg !176
  %16 = icmp ne i32 %15, 0, !dbg !177
  br i1 %16, label %17, label %18, !dbg !178

17:                                               ; preds = %8
  call void @exit(i32 noundef 1) #4, !dbg !179
  unreachable, !dbg !179

18:                                               ; preds = %8
  br label %19, !dbg !181

19:                                               ; preds = %18
  %20 = load i32, ptr %4, align 4, !dbg !182
  %21 = add nsw i32 %20, 1, !dbg !182
  store i32 %21, ptr %4, align 4, !dbg !182
  br label %5, !dbg !183, !llvm.loop !184

22:                                               ; preds = %5
  store i32 0, ptr %4, align 4, !dbg !186
  br label %23, !dbg !188

23:                                               ; preds = %35, %22
  %24 = load i32, ptr %4, align 4, !dbg !189
  %25 = icmp slt i32 %24, 3, !dbg !191
  br i1 %25, label %26, label %38, !dbg !192

26:                                               ; preds = %23
  %27 = load i32, ptr %4, align 4, !dbg !193
  %28 = sext i32 %27 to i64, !dbg !196
  %29 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %28, !dbg !196
  %30 = load ptr, ptr %29, align 8, !dbg !196
  %31 = call i32 @"\01_pthread_join"(ptr noundef %30, ptr noundef null), !dbg !197
  %32 = icmp ne i32 %31, 0, !dbg !198
  br i1 %32, label %33, label %34, !dbg !199

33:                                               ; preds = %26
  call void @exit(i32 noundef 1) #4, !dbg !200
  unreachable, !dbg !200

34:                                               ; preds = %26
  br label %35, !dbg !202

35:                                               ; preds = %34
  %36 = load i32, ptr %4, align 4, !dbg !203
  %37 = add nsw i32 %36, 1, !dbg !203
  store i32 %37, ptr %4, align 4, !dbg !203
  br label %23, !dbg !204, !llvm.loop !205

38:                                               ; preds = %23
  %39 = load i32, ptr @x, align 4, !dbg !207
  %40 = icmp eq i32 %39, 3, !dbg !207
  br i1 %40, label %41, label %44, !dbg !207

41:                                               ; preds = %38
  %42 = load i32, ptr @y, align 4, !dbg !207
  %43 = icmp eq i32 %42, 3, !dbg !207
  br label %44

44:                                               ; preds = %41, %38
  %45 = phi i1 [ false, %38 ], [ %43, %41 ], !dbg !208
  %46 = xor i1 %45, true, !dbg !207
  %47 = zext i1 %46 to i32, !dbg !207
  %48 = sext i32 %47 to i64, !dbg !207
  %49 = icmp ne i64 %48, 0, !dbg !207
  br i1 %49, label %50, label %52, !dbg !207

50:                                               ; preds = %44
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 53, ptr noundef @.str.1) #5, !dbg !207
  unreachable, !dbg !207

51:                                               ; No predecessors!
  br label %53, !dbg !207

52:                                               ; preds = %44
  br label %53, !dbg !207

53:                                               ; preds = %52, %51
  ret i32 0, !dbg !209
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_fas_init(ptr noundef %0) #0 !dbg !210 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8, !dbg !213
  %4 = getelementptr inbounds %struct.ck_spinlock_fas, ptr %3, i32 0, i32 0, !dbg !214
  store i32 0, ptr %4, align 4, !dbg !215
  call void @ck_pr_barrier(), !dbg !216
  ret void, !dbg !217
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #2

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_fas_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !218 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %6 = load ptr, ptr %3, align 8, !dbg !223
  %7 = load i32, ptr %4, align 4, !dbg !223
  %8 = call i32 asm sideeffect "1:;lwarx $0, 0, $1;stwcx. $2, 0, $1;bne- 1b;", "=&r,r,r,~{memory},~{cc}"(ptr %6, i32 %7) #6, !dbg !223, !srcloc !226
  store i32 %8, ptr %5, align 4, !dbg !223
  %9 = load i32, ptr %5, align 4, !dbg !223
  ret i32 %9, !dbg !223
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_lock() #0 !dbg !227 {
  call void @ck_pr_fence_strict_lock(), !dbg !231
  ret void, !dbg !231
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_lock() #0 !dbg !232 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !233, !srcloc !234
  ret void, !dbg !233
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_stall() #0 !dbg !235 {
  call void asm sideeffect "or 1, 1, 1;or 2, 2, 2;", "~{memory}"() #6, !dbg !236, !srcloc !237
  ret void, !dbg !238
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !239 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !243
  %5 = call i32 asm sideeffect "lwz $0, $1", "=r,*m,~{memory}"(ptr elementtype(i32) %4) #6, !dbg !243, !srcloc !245
  store i32 %5, ptr %3, align 4, !dbg !243
  %6 = load i32, ptr %3, align 4, !dbg !243
  ret i32 %6, !dbg !243
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_unlock() #0 !dbg !246 {
  call void @ck_pr_fence_strict_unlock(), !dbg !247
  ret void, !dbg !247
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !248 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8, !dbg !252
  %6 = load i32, ptr %4, align 4, !dbg !252
  call void asm sideeffect "stw $1, $0", "=*m,r,~{memory}"(ptr elementtype(i32) %5, i32 %6) #6, !dbg !252, !srcloc !254
  ret void, !dbg !252
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_unlock() #0 !dbg !255 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !256, !srcloc !257
  ret void, !dbg !256
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_barrier() #0 !dbg !258 {
  call void asm sideeffect "", "~{memory}"() #6, !dbg !260, !srcloc !261
  ret void, !dbg !262
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
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 11, type: !22, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !19, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "tests/faslock.c", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "1e2a99fb364862612c862585639e0034")
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
!21 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 11, type: !22, isLocal: false, isDefinition: true)
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !3, line: 53, type: !25, isLocal: true, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 40, elements: !28)
!26 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !27)
!27 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!28 = !{!29}
!29 = !DISubrange(count: 5)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 53, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 80, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 10)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(scope: null, file: !3, line: 53, type: !37, isLocal: true, isDefinition: true)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 248, elements: !38)
!38 = !{!39}
!39 = !DISubrange(count: 31)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 12, type: !42, isLocal: false, isDefinition: true)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_fas_t", file: !43, line: 42, baseType: !44)
!43 = !DIFile(filename: "include/spinlock/fas.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "999805093e3ea65ae15690fa7c76e04b")
!44 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_fas", file: !43, line: 39, size: 32, elements: !45)
!45 = !{!46}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !44, file: !43, line: 40, baseType: !17, size: 32)
!47 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 0]}
!48 = !{i32 7, !"Dwarf Version", i32 5}
!49 = !{i32 2, !"Debug Info Version", i32 3}
!50 = !{i32 1, !"wchar_size", i32 4}
!51 = !{i32 8, !"PIC Level", i32 2}
!52 = !{i32 7, !"uwtable", i32 1}
!53 = !{i32 7, !"frame-pointer", i32 1}
!54 = !{!"Homebrew clang version 19.1.7"}
!55 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 14, type: !56, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!56 = !DISubroutineType(types: !57)
!57 = !{!10, !10}
!58 = !{}
!59 = !DILocalVariable(name: "arg", arg: 1, scope: !55, file: !3, line: 14, type: !10)
!60 = !DILocation(line: 14, column: 17, scope: !55)
!61 = !DILocalVariable(name: "tid", scope: !55, file: !3, line: 16, type: !5)
!62 = !DILocation(line: 16, column: 14, scope: !55)
!63 = !DILocation(line: 16, column: 32, scope: !55)
!64 = !DILocation(line: 16, column: 21, scope: !55)
!65 = !DILocation(line: 18, column: 9, scope: !66)
!66 = distinct !DILexicalBlock(scope: !55, file: !3, line: 18, column: 9)
!67 = !DILocation(line: 18, column: 13, scope: !66)
!68 = !DILocation(line: 18, column: 9, scope: !55)
!69 = !DILocalVariable(name: "acquired", scope: !70, file: !3, line: 20, type: !71)
!70 = distinct !DILexicalBlock(scope: !66, file: !3, line: 19, column: 5)
!71 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!72 = !DILocation(line: 20, column: 14, scope: !70)
!73 = !DILocation(line: 20, column: 25, scope: !70)
!74 = !DILocation(line: 21, column: 27, scope: !70)
!75 = !DILocation(line: 21, column: 9, scope: !70)
!76 = !DILocation(line: 22, column: 5, scope: !70)
!77 = !DILocation(line: 25, column: 9, scope: !78)
!78 = distinct !DILexicalBlock(scope: !66, file: !3, line: 24, column: 5)
!79 = !DILocation(line: 27, column: 6, scope: !55)
!80 = !DILocation(line: 28, column: 6, scope: !55)
!81 = !DILocation(line: 29, column: 5, scope: !55)
!82 = !DILocation(line: 30, column: 5, scope: !55)
!83 = distinct !DISubprogram(name: "ck_spinlock_fas_trylock", scope: !43, file: !43, line: 56, type: !84, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!84 = !DISubroutineType(types: !85)
!85 = !{!71, !86}
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!87 = !DILocalVariable(name: "lock", arg: 1, scope: !83, file: !43, line: 56, type: !86)
!88 = !DILocation(line: 56, column: 49, scope: !83)
!89 = !DILocalVariable(name: "value", scope: !83, file: !43, line: 58, type: !71)
!90 = !DILocation(line: 58, column: 7, scope: !83)
!91 = !DILocation(line: 60, column: 26, scope: !83)
!92 = !DILocation(line: 60, column: 32, scope: !83)
!93 = !DILocation(line: 60, column: 10, scope: !83)
!94 = !DILocation(line: 60, column: 8, scope: !83)
!95 = !DILocation(line: 61, column: 2, scope: !83)
!96 = !DILocation(line: 63, column: 10, scope: !83)
!97 = !DILocation(line: 63, column: 9, scope: !83)
!98 = !DILocation(line: 63, column: 2, scope: !83)
!99 = distinct !DISubprogram(name: "ck_spinlock_fas_lock", scope: !43, file: !43, line: 77, type: !100, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!100 = !DISubroutineType(types: !101)
!101 = !{null, !86}
!102 = !DILocalVariable(name: "lock", arg: 1, scope: !99, file: !43, line: 77, type: !86)
!103 = !DILocation(line: 77, column: 46, scope: !99)
!104 = !DILocation(line: 80, column: 9, scope: !99)
!105 = !DILocation(line: 80, column: 16, scope: !99)
!106 = !DILocation(line: 81, column: 17, scope: !107)
!107 = distinct !DILexicalBlock(scope: !99, file: !43, line: 80, column: 76)
!108 = !DILocation(line: 82, column: 25, scope: !109)
!109 = distinct !DILexicalBlock(scope: !107, file: !43, line: 81, column: 20)
!110 = !DILocation(line: 83, column: 17, scope: !109)
!111 = !DILocation(line: 83, column: 26, scope: !107)
!112 = !DILocation(line: 83, column: 56, scope: !107)
!113 = distinct !{!113, !106, !114, !115}
!114 = !DILocation(line: 83, column: 63, scope: !107)
!115 = !{!"llvm.loop.mustprogress"}
!116 = distinct !{!116, !104, !117, !115}
!117 = !DILocation(line: 84, column: 9, scope: !99)
!118 = !DILocation(line: 86, column: 2, scope: !99)
!119 = !DILocation(line: 87, column: 2, scope: !99)
!120 = distinct !DISubprogram(name: "ck_spinlock_fas_unlock", scope: !43, file: !43, line: 103, type: !100, scopeLine: 104, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!121 = !DILocalVariable(name: "lock", arg: 1, scope: !120, file: !43, line: 103, type: !86)
!122 = !DILocation(line: 103, column: 48, scope: !120)
!123 = !DILocation(line: 106, column: 2, scope: !120)
!124 = !DILocation(line: 107, column: 2, scope: !120)
!125 = !DILocation(line: 108, column: 2, scope: !120)
!126 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 33, type: !127, scopeLine: 34, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !58)
!127 = !DISubroutineType(types: !128)
!128 = !{!22}
!129 = !DILocalVariable(name: "threads", scope: !126, file: !3, line: 35, type: !130)
!130 = !DICompositeType(tag: DW_TAG_array_type, baseType: !131, size: 192, elements: !153)
!131 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !132, line: 31, baseType: !133)
!132 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!133 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !134, line: 118, baseType: !135)
!134 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!135 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !136, size: 64)
!136 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !134, line: 103, size: 65536, elements: !137)
!137 = !{!138, !139, !149}
!138 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !136, file: !134, line: 104, baseType: !9, size: 64)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !136, file: !134, line: 105, baseType: !140, size: 64, offset: 64)
!140 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !141, size: 64)
!141 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !134, line: 57, size: 192, elements: !142)
!142 = !{!143, !147, !148}
!143 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !141, file: !134, line: 58, baseType: !144, size: 64)
!144 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !145, size: 64)
!145 = !DISubroutineType(types: !146)
!146 = !{null, !10}
!147 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !141, file: !134, line: 59, baseType: !10, size: 64, offset: 64)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !141, file: !134, line: 60, baseType: !140, size: 64, offset: 128)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !136, file: !134, line: 106, baseType: !150, size: 65408, offset: 128)
!150 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 65408, elements: !151)
!151 = !{!152}
!152 = !DISubrange(count: 8176)
!153 = !{!154}
!154 = !DISubrange(count: 3)
!155 = !DILocation(line: 35, column: 15, scope: !126)
!156 = !DILocalVariable(name: "tids", scope: !126, file: !3, line: 36, type: !157)
!157 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 96, elements: !153)
!158 = !DILocation(line: 36, column: 9, scope: !126)
!159 = !DILocalVariable(name: "i", scope: !126, file: !3, line: 37, type: !22)
!160 = !DILocation(line: 37, column: 9, scope: !126)
!161 = !DILocation(line: 38, column: 5, scope: !126)
!162 = !DILocation(line: 39, column: 12, scope: !163)
!163 = distinct !DILexicalBlock(scope: !126, file: !3, line: 39, column: 5)
!164 = !DILocation(line: 39, column: 10, scope: !163)
!165 = !DILocation(line: 39, column: 17, scope: !166)
!166 = distinct !DILexicalBlock(scope: !163, file: !3, line: 39, column: 5)
!167 = !DILocation(line: 39, column: 19, scope: !166)
!168 = !DILocation(line: 39, column: 5, scope: !163)
!169 = !DILocation(line: 41, column: 37, scope: !170)
!170 = distinct !DILexicalBlock(scope: !171, file: !3, line: 41, column: 13)
!171 = distinct !DILexicalBlock(scope: !166, file: !3, line: 40, column: 5)
!172 = !DILocation(line: 41, column: 29, scope: !170)
!173 = !DILocation(line: 41, column: 68, scope: !170)
!174 = !DILocation(line: 41, column: 60, scope: !170)
!175 = !DILocation(line: 41, column: 52, scope: !170)
!176 = !DILocation(line: 41, column: 13, scope: !170)
!177 = !DILocation(line: 41, column: 71, scope: !170)
!178 = !DILocation(line: 41, column: 13, scope: !171)
!179 = !DILocation(line: 43, column: 13, scope: !180)
!180 = distinct !DILexicalBlock(scope: !170, file: !3, line: 42, column: 9)
!181 = !DILocation(line: 45, column: 5, scope: !171)
!182 = !DILocation(line: 39, column: 32, scope: !166)
!183 = !DILocation(line: 39, column: 5, scope: !166)
!184 = distinct !{!184, !168, !185, !115}
!185 = !DILocation(line: 45, column: 5, scope: !163)
!186 = !DILocation(line: 46, column: 12, scope: !187)
!187 = distinct !DILexicalBlock(scope: !126, file: !3, line: 46, column: 5)
!188 = !DILocation(line: 46, column: 10, scope: !187)
!189 = !DILocation(line: 46, column: 17, scope: !190)
!190 = distinct !DILexicalBlock(scope: !187, file: !3, line: 46, column: 5)
!191 = !DILocation(line: 46, column: 19, scope: !190)
!192 = !DILocation(line: 46, column: 5, scope: !187)
!193 = !DILocation(line: 48, column: 34, scope: !194)
!194 = distinct !DILexicalBlock(scope: !195, file: !3, line: 48, column: 13)
!195 = distinct !DILexicalBlock(scope: !190, file: !3, line: 47, column: 5)
!196 = !DILocation(line: 48, column: 26, scope: !194)
!197 = !DILocation(line: 48, column: 13, scope: !194)
!198 = !DILocation(line: 48, column: 44, scope: !194)
!199 = !DILocation(line: 48, column: 13, scope: !195)
!200 = !DILocation(line: 50, column: 13, scope: !201)
!201 = distinct !DILexicalBlock(scope: !194, file: !3, line: 49, column: 9)
!202 = !DILocation(line: 52, column: 5, scope: !195)
!203 = !DILocation(line: 46, column: 32, scope: !190)
!204 = !DILocation(line: 46, column: 5, scope: !190)
!205 = distinct !{!205, !192, !206, !115}
!206 = !DILocation(line: 52, column: 5, scope: !187)
!207 = !DILocation(line: 53, column: 5, scope: !126)
!208 = !DILocation(line: 0, scope: !126)
!209 = !DILocation(line: 54, column: 5, scope: !126)
!210 = distinct !DISubprogram(name: "ck_spinlock_fas_init", scope: !43, file: !43, line: 47, type: !100, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!211 = !DILocalVariable(name: "lock", arg: 1, scope: !210, file: !43, line: 47, type: !86)
!212 = !DILocation(line: 47, column: 46, scope: !210)
!213 = !DILocation(line: 50, column: 2, scope: !210)
!214 = !DILocation(line: 50, column: 8, scope: !210)
!215 = !DILocation(line: 50, column: 14, scope: !210)
!216 = !DILocation(line: 51, column: 2, scope: !210)
!217 = !DILocation(line: 52, column: 2, scope: !210)
!218 = distinct !DISubprogram(name: "ck_pr_fas_uint", scope: !219, file: !219, line: 308, type: !220, scopeLine: 308, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!219 = !DIFile(filename: "include/gcc/ppc64/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "1c5aecf7376064f28c732d8a93471464")
!220 = !DISubroutineType(types: !221)
!221 = !{!17, !18, !17}
!222 = !DILocalVariable(name: "target", arg: 1, scope: !218, file: !219, line: 308, type: !18)
!223 = !DILocation(line: 308, column: 1, scope: !218)
!224 = !DILocalVariable(name: "v", arg: 2, scope: !218, file: !219, line: 308, type: !17)
!225 = !DILocalVariable(name: "previous", scope: !218, file: !219, line: 308, type: !17)
!226 = !{i64 2147776784}
!227 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !228, file: !228, line: 118, type: !229, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!228 = !DIFile(filename: "include/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "cffbc3bc631aa31cdde49d8ca6470a32")
!229 = !DISubroutineType(types: !230)
!230 = !{null}
!231 = !DILocation(line: 118, column: 1, scope: !227)
!232 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !219, file: !219, line: 88, type: !229, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!233 = !DILocation(line: 88, column: 1, scope: !232)
!234 = !{i64 2147762986}
!235 = distinct !DISubprogram(name: "ck_pr_stall", scope: !219, file: !219, line: 56, type: !229, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!236 = !DILocation(line: 59, column: 2, scope: !235)
!237 = !{i64 264554}
!238 = !DILocation(line: 61, column: 2, scope: !235)
!239 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !219, file: !219, line: 113, type: !240, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!240 = !DISubroutineType(types: !241)
!241 = !{!17, !15}
!242 = !DILocalVariable(name: "target", arg: 1, scope: !239, file: !219, line: 113, type: !15)
!243 = !DILocation(line: 113, column: 1, scope: !239)
!244 = !DILocalVariable(name: "r", scope: !239, file: !219, line: 113, type: !17)
!245 = !{i64 2147765521}
!246 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !228, file: !228, line: 119, type: !229, scopeLine: 119, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!247 = !DILocation(line: 119, column: 1, scope: !246)
!248 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !219, file: !219, line: 143, type: !249, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !58)
!249 = !DISubroutineType(types: !250)
!250 = !{null, !18, !17}
!251 = !DILocalVariable(name: "target", arg: 1, scope: !248, file: !219, line: 143, type: !18)
!252 = !DILocation(line: 143, column: 1, scope: !248)
!253 = !DILocalVariable(name: "v", arg: 2, scope: !248, file: !219, line: 143, type: !17)
!254 = !{i64 2147769168}
!255 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !219, file: !219, line: 89, type: !229, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!256 = !DILocation(line: 89, column: 1, scope: !255)
!257 = !{i64 2147763183}
!258 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !259, file: !259, line: 37, type: !229, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!259 = !DIFile(filename: "include/gcc/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!260 = !DILocation(line: 40, column: 2, scope: !258)
!261 = !{i64 320255}
!262 = !DILocation(line: 41, column: 2, scope: !258)
