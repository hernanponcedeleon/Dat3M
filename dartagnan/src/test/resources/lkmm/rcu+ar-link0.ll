; ModuleID = 'benchmarks/lkmm/rcu+ar-link0.c'
source_filename = "benchmarks/lkmm/rcu+ar-link0.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !46
@r_y = global i32 0, align 4, !dbg !50
@s = global i32 0, align 4, !dbg !52
@r_s = global i32 0, align 4, !dbg !64
@w = global i32 0, align 4, !dbg !54
@z = global i32 0, align 4, !dbg !56
@a = global i32 0, align 4, !dbg !58
@r_a = global i32 0, align 4, !dbg !66
@b = global i32 0, align 4, !dbg !60
@r_b = global i32 0, align 4, !dbg !68
@c = global i32 0, align 4, !dbg !62
@r_c = global i32 0, align 4, !dbg !70
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [15 x i8] c"rcu+ar-link0.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [60 x i8] c"!(r_y == 1 && r_s == 1 && r_a == 1 && r_b == 1 && r_c == 1)\00", align 1, !dbg !41
@r_x = global i32 0, align 4, !dbg !48

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @P0(ptr noundef %0) #0 !dbg !79 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !83, !DIExpression(), !84)
  call void @__LKMM_fence(i32 noundef 7), !dbg !85
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !86
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !87
  %4 = trunc i64 %3 to i32, !dbg !87
  store i32 %4, ptr @r_y, align 4, !dbg !88
  call void @__LKMM_fence(i32 noundef 8), !dbg !89
  ret ptr null, !dbg !90
}

declare void @__LKMM_fence(i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @P1(ptr noundef %0) #0 !dbg !91 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !92, !DIExpression(), !93)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !94
  %4 = trunc i64 %3 to i32, !dbg !94
  %5 = icmp eq i32 %4, 1, !dbg !96
  br i1 %5, label %6, label %7, !dbg !97

6:                                                ; preds = %1
  call void @__LKMM_store(ptr noundef @s, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !98
  br label %7, !dbg !98

7:                                                ; preds = %6, %1
  ret ptr null, !dbg !99
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @P2(ptr noundef %0) #0 !dbg !100 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !101, !DIExpression(), !102)
  %4 = call i64 @__LKMM_load(ptr noundef @s, i64 noundef 4, i32 noundef 1), !dbg !103
  %5 = trunc i64 %4 to i32, !dbg !103
  store i32 %5, ptr @r_s, align 4, !dbg !104
  call void @__LKMM_store(ptr noundef @w, i64 noundef 4, i64 noundef 1, i32 noundef 3), !dbg !105
    #dbg_declare(ptr %3, !106, !DIExpression(), !107)
  %6 = call i64 @__LKMM_load(ptr noundef @z, i64 noundef 4, i32 noundef 1), !dbg !108
  %7 = trunc i64 %6 to i32, !dbg !108
  store i32 %7, ptr %3, align 4, !dbg !107
  %8 = load i32, ptr %3, align 4, !dbg !109
  %9 = add nsw i32 %8, 1, !dbg !109
  %10 = sext i32 %9 to i64, !dbg !109
  call void @__LKMM_store(ptr noundef @a, i64 noundef 4, i64 noundef %10, i32 noundef 1), !dbg !109
  ret ptr null, !dbg !110
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @P3(ptr noundef %0) #0 !dbg !111 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !112, !DIExpression(), !113)
  %3 = call i64 @__LKMM_load(ptr noundef @a, i64 noundef 4, i32 noundef 1), !dbg !114
  %4 = trunc i64 %3 to i32, !dbg !114
  store i32 %4, ptr @r_a, align 4, !dbg !115
  %5 = load i32, ptr @r_a, align 4, !dbg !116
  %6 = sext i32 %5 to i64, !dbg !116
  call void @__LKMM_store(ptr noundef @b, i64 noundef 4, i64 noundef %6, i32 noundef 1), !dbg !116
  ret ptr null, !dbg !117
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @P4(ptr noundef %0) #0 !dbg !118 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !119, !DIExpression(), !120)
  %3 = call i64 @__LKMM_load(ptr noundef @b, i64 noundef 4, i32 noundef 1), !dbg !121
  %4 = trunc i64 %3 to i32, !dbg !121
  store i32 %4, ptr @r_b, align 4, !dbg !122
  call void @__LKMM_store(ptr noundef @c, i64 noundef 4, i64 noundef 1, i32 noundef 3), !dbg !123
  ret ptr null, !dbg !124
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @P5(ptr noundef %0) #0 !dbg !125 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !126, !DIExpression(), !127)
  %3 = call i64 @__LKMM_load(ptr noundef @c, i64 noundef 4, i32 noundef 1), !dbg !128
  %4 = trunc i64 %3 to i32, !dbg !128
  store i32 %4, ptr @r_c, align 4, !dbg !129
  call void @__LKMM_fence(i32 noundef 9), !dbg !130
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !131
  ret ptr null, !dbg !132
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !133 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !136, !DIExpression(), !160)
    #dbg_declare(ptr %3, !161, !DIExpression(), !162)
    #dbg_declare(ptr %4, !163, !DIExpression(), !164)
    #dbg_declare(ptr %5, !165, !DIExpression(), !166)
    #dbg_declare(ptr %6, !167, !DIExpression(), !168)
    #dbg_declare(ptr %7, !169, !DIExpression(), !170)
  %8 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @P0, ptr noundef null), !dbg !171
  %9 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @P1, ptr noundef null), !dbg !172
  %10 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @P2, ptr noundef null), !dbg !173
  %11 = call i32 @pthread_create(ptr noundef %5, ptr noundef null, ptr noundef @P3, ptr noundef null), !dbg !174
  %12 = call i32 @pthread_create(ptr noundef %6, ptr noundef null, ptr noundef @P4, ptr noundef null), !dbg !175
  %13 = call i32 @pthread_create(ptr noundef %7, ptr noundef null, ptr noundef @P5, ptr noundef null), !dbg !176
  %14 = load ptr, ptr %2, align 8, !dbg !177
  %15 = call i32 @"\01_pthread_join"(ptr noundef %14, ptr noundef null), !dbg !178
  %16 = load ptr, ptr %3, align 8, !dbg !179
  %17 = call i32 @"\01_pthread_join"(ptr noundef %16, ptr noundef null), !dbg !180
  %18 = load ptr, ptr %4, align 8, !dbg !181
  %19 = call i32 @"\01_pthread_join"(ptr noundef %18, ptr noundef null), !dbg !182
  %20 = load ptr, ptr %5, align 8, !dbg !183
  %21 = call i32 @"\01_pthread_join"(ptr noundef %20, ptr noundef null), !dbg !184
  %22 = load ptr, ptr %6, align 8, !dbg !185
  %23 = call i32 @"\01_pthread_join"(ptr noundef %22, ptr noundef null), !dbg !186
  %24 = load ptr, ptr %7, align 8, !dbg !187
  %25 = call i32 @"\01_pthread_join"(ptr noundef %24, ptr noundef null), !dbg !188
  %26 = load i32, ptr @r_y, align 4, !dbg !189
  %27 = icmp eq i32 %26, 1, !dbg !189
  br i1 %27, label %28, label %40, !dbg !189

28:                                               ; preds = %0
  %29 = load i32, ptr @r_s, align 4, !dbg !189
  %30 = icmp eq i32 %29, 1, !dbg !189
  br i1 %30, label %31, label %40, !dbg !189

31:                                               ; preds = %28
  %32 = load i32, ptr @r_a, align 4, !dbg !189
  %33 = icmp eq i32 %32, 1, !dbg !189
  br i1 %33, label %34, label %40, !dbg !189

34:                                               ; preds = %31
  %35 = load i32, ptr @r_b, align 4, !dbg !189
  %36 = icmp eq i32 %35, 1, !dbg !189
  br i1 %36, label %37, label %40, !dbg !189

37:                                               ; preds = %34
  %38 = load i32, ptr @r_c, align 4, !dbg !189
  %39 = icmp eq i32 %38, 1, !dbg !189
  br label %40

40:                                               ; preds = %37, %34, %31, %28, %0
  %41 = phi i1 [ false, %34 ], [ false, %31 ], [ false, %28 ], [ false, %0 ], [ %39, %37 ], !dbg !190
  %42 = xor i1 %41, true, !dbg !189
  %43 = xor i1 %42, true, !dbg !189
  %44 = zext i1 %43 to i32, !dbg !189
  %45 = sext i32 %44 to i64, !dbg !189
  %46 = icmp ne i64 %45, 0, !dbg !189
  br i1 %46, label %47, label %49, !dbg !189

47:                                               ; preds = %40
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 105, ptr noundef @.str.1) #3, !dbg !189
  unreachable, !dbg !189

48:                                               ; No predecessors!
  br label %50, !dbg !189

49:                                               ; preds = %40
  br label %50, !dbg !189

50:                                               ; preds = %49, %48
  ret i32 0, !dbg !191
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!72, !73, !74, !75, !76, !77}
!llvm.ident = !{!78}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 16, type: !26, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/lkmm/rcu+ar-link0.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6b13efe8b5bb64ba02860a374c43853f")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "27b8121cb2c90fe5c99c4b3e89c9755e")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22}
!9 = !DIEnumerator(name: "__LKMM_relaxed", value: 0)
!10 = !DIEnumerator(name: "__LKMM_once", value: 1)
!11 = !DIEnumerator(name: "__LKMM_acquire", value: 2)
!12 = !DIEnumerator(name: "__LKMM_release", value: 3)
!13 = !DIEnumerator(name: "__LKMM_mb", value: 4)
!14 = !DIEnumerator(name: "__LKMM_wmb", value: 5)
!15 = !DIEnumerator(name: "__LKMM_rmb", value: 6)
!16 = !DIEnumerator(name: "__LKMM_rcu_lock", value: 7)
!17 = !DIEnumerator(name: "__LKMM_rcu_unlock", value: 8)
!18 = !DIEnumerator(name: "__LKMM_rcu_sync", value: 9)
!19 = !DIEnumerator(name: "__LKMM_before_atomic", value: 10)
!20 = !DIEnumerator(name: "__LKMM_after_atomic", value: 11)
!21 = !DIEnumerator(name: "__LKMM_after_spinlock", value: 12)
!22 = !DIEnumerator(name: "__LKMM_barrier", value: 13)
!23 = !{!24, !26, !27}
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !25)
!25 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!26 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = !{!29, !36, !41, !0, !46, !48, !50, !52, !54, !56, !58, !60, !62, !64, !66, !68, !70}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 105, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !34)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{!35}
!35 = !DISubrange(count: 5)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 105, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 120, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 15)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 105, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 480, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 60)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 17, type: !26, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "r_x", scope: !2, file: !3, line: 19, type: !26, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "r_y", scope: !2, file: !3, line: 20, type: !26, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 23, type: !26, isLocal: false, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "w", scope: !2, file: !3, line: 24, type: !26, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !3, line: 25, type: !26, isLocal: false, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 27, type: !26, isLocal: false, isDefinition: true)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 28, type: !26, isLocal: false, isDefinition: true)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 29, type: !26, isLocal: false, isDefinition: true)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "r_s", scope: !2, file: !3, line: 31, type: !26, isLocal: false, isDefinition: true)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "r_a", scope: !2, file: !3, line: 32, type: !26, isLocal: false, isDefinition: true)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "r_b", scope: !2, file: !3, line: 33, type: !26, isLocal: false, isDefinition: true)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "r_c", scope: !2, file: !3, line: 34, type: !26, isLocal: false, isDefinition: true)
!72 = !{i32 7, !"Dwarf Version", i32 5}
!73 = !{i32 2, !"Debug Info Version", i32 3}
!74 = !{i32 1, !"wchar_size", i32 4}
!75 = !{i32 8, !"PIC Level", i32 2}
!76 = !{i32 7, !"uwtable", i32 1}
!77 = !{i32 7, !"frame-pointer", i32 1}
!78 = !{!"Homebrew clang version 19.1.7"}
!79 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 36, type: !80, scopeLine: 37, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !82)
!80 = !DISubroutineType(types: !81)
!81 = !{!27, !27}
!82 = !{}
!83 = !DILocalVariable(name: "unused", arg: 1, scope: !79, file: !3, line: 36, type: !27)
!84 = !DILocation(line: 36, column: 16, scope: !79)
!85 = !DILocation(line: 38, column: 2, scope: !79)
!86 = !DILocation(line: 39, column: 2, scope: !79)
!87 = !DILocation(line: 40, column: 8, scope: !79)
!88 = !DILocation(line: 40, column: 6, scope: !79)
!89 = !DILocation(line: 41, column: 2, scope: !79)
!90 = !DILocation(line: 42, column: 2, scope: !79)
!91 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 45, type: !80, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !82)
!92 = !DILocalVariable(name: "unused", arg: 1, scope: !91, file: !3, line: 45, type: !27)
!93 = !DILocation(line: 45, column: 16, scope: !91)
!94 = !DILocation(line: 47, column: 6, scope: !95)
!95 = distinct !DILexicalBlock(scope: !91, file: !3, line: 47, column: 6)
!96 = !DILocation(line: 47, column: 19, scope: !95)
!97 = !DILocation(line: 47, column: 6, scope: !91)
!98 = !DILocation(line: 48, column: 3, scope: !95)
!99 = !DILocation(line: 49, column: 2, scope: !91)
!100 = distinct !DISubprogram(name: "P2", scope: !3, file: !3, line: 52, type: !80, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !82)
!101 = !DILocalVariable(name: "unused", arg: 1, scope: !100, file: !3, line: 52, type: !27)
!102 = !DILocation(line: 52, column: 16, scope: !100)
!103 = !DILocation(line: 54, column: 8, scope: !100)
!104 = !DILocation(line: 54, column: 6, scope: !100)
!105 = !DILocation(line: 55, column: 2, scope: !100)
!106 = !DILocalVariable(name: "r", scope: !100, file: !3, line: 57, type: !26)
!107 = !DILocation(line: 57, column: 6, scope: !100)
!108 = !DILocation(line: 57, column: 10, scope: !100)
!109 = !DILocation(line: 58, column: 2, scope: !100)
!110 = !DILocation(line: 59, column: 2, scope: !100)
!111 = distinct !DISubprogram(name: "P3", scope: !3, file: !3, line: 62, type: !80, scopeLine: 63, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !82)
!112 = !DILocalVariable(name: "unused", arg: 1, scope: !111, file: !3, line: 62, type: !27)
!113 = !DILocation(line: 62, column: 16, scope: !111)
!114 = !DILocation(line: 64, column: 8, scope: !111)
!115 = !DILocation(line: 64, column: 6, scope: !111)
!116 = !DILocation(line: 65, column: 2, scope: !111)
!117 = !DILocation(line: 66, column: 2, scope: !111)
!118 = distinct !DISubprogram(name: "P4", scope: !3, file: !3, line: 69, type: !80, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !82)
!119 = !DILocalVariable(name: "unused", arg: 1, scope: !118, file: !3, line: 69, type: !27)
!120 = !DILocation(line: 69, column: 16, scope: !118)
!121 = !DILocation(line: 71, column: 8, scope: !118)
!122 = !DILocation(line: 71, column: 6, scope: !118)
!123 = !DILocation(line: 72, column: 2, scope: !118)
!124 = !DILocation(line: 73, column: 2, scope: !118)
!125 = distinct !DISubprogram(name: "P5", scope: !3, file: !3, line: 76, type: !80, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !82)
!126 = !DILocalVariable(name: "unused", arg: 1, scope: !125, file: !3, line: 76, type: !27)
!127 = !DILocation(line: 76, column: 16, scope: !125)
!128 = !DILocation(line: 78, column: 8, scope: !125)
!129 = !DILocation(line: 78, column: 6, scope: !125)
!130 = !DILocation(line: 79, column: 2, scope: !125)
!131 = !DILocation(line: 80, column: 2, scope: !125)
!132 = !DILocation(line: 81, column: 2, scope: !125)
!133 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 84, type: !134, scopeLine: 85, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !82)
!134 = !DISubroutineType(types: !135)
!135 = !{!26}
!136 = !DILocalVariable(name: "t0", scope: !133, file: !3, line: 89, type: !137)
!137 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !138, line: 31, baseType: !139)
!138 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!139 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !140, line: 118, baseType: !141)
!140 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!141 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !142, size: 64)
!142 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !140, line: 103, size: 65536, elements: !143)
!143 = !{!144, !146, !156}
!144 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !142, file: !140, line: 104, baseType: !145, size: 64)
!145 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !142, file: !140, line: 105, baseType: !147, size: 64, offset: 64)
!147 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !148, size: 64)
!148 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !140, line: 57, size: 192, elements: !149)
!149 = !{!150, !154, !155}
!150 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !148, file: !140, line: 58, baseType: !151, size: 64)
!151 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !152, size: 64)
!152 = !DISubroutineType(types: !153)
!153 = !{null, !27}
!154 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !148, file: !140, line: 59, baseType: !27, size: 64, offset: 64)
!155 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !148, file: !140, line: 60, baseType: !147, size: 64, offset: 128)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !142, file: !140, line: 106, baseType: !157, size: 65408, offset: 128)
!157 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !158)
!158 = !{!159}
!159 = !DISubrange(count: 8176)
!160 = !DILocation(line: 89, column: 12, scope: !133)
!161 = !DILocalVariable(name: "t1", scope: !133, file: !3, line: 89, type: !137)
!162 = !DILocation(line: 89, column: 16, scope: !133)
!163 = !DILocalVariable(name: "t2", scope: !133, file: !3, line: 89, type: !137)
!164 = !DILocation(line: 89, column: 20, scope: !133)
!165 = !DILocalVariable(name: "t3", scope: !133, file: !3, line: 89, type: !137)
!166 = !DILocation(line: 89, column: 24, scope: !133)
!167 = !DILocalVariable(name: "t4", scope: !133, file: !3, line: 89, type: !137)
!168 = !DILocation(line: 89, column: 28, scope: !133)
!169 = !DILocalVariable(name: "t5", scope: !133, file: !3, line: 89, type: !137)
!170 = !DILocation(line: 89, column: 32, scope: !133)
!171 = !DILocation(line: 91, column: 2, scope: !133)
!172 = !DILocation(line: 92, column: 2, scope: !133)
!173 = !DILocation(line: 93, column: 2, scope: !133)
!174 = !DILocation(line: 94, column: 2, scope: !133)
!175 = !DILocation(line: 95, column: 2, scope: !133)
!176 = !DILocation(line: 96, column: 2, scope: !133)
!177 = !DILocation(line: 98, column: 15, scope: !133)
!178 = !DILocation(line: 98, column: 2, scope: !133)
!179 = !DILocation(line: 99, column: 15, scope: !133)
!180 = !DILocation(line: 99, column: 2, scope: !133)
!181 = !DILocation(line: 100, column: 15, scope: !133)
!182 = !DILocation(line: 100, column: 2, scope: !133)
!183 = !DILocation(line: 101, column: 15, scope: !133)
!184 = !DILocation(line: 101, column: 2, scope: !133)
!185 = !DILocation(line: 102, column: 15, scope: !133)
!186 = !DILocation(line: 102, column: 2, scope: !133)
!187 = !DILocation(line: 103, column: 15, scope: !133)
!188 = !DILocation(line: 103, column: 2, scope: !133)
!189 = !DILocation(line: 105, column: 2, scope: !133)
!190 = !DILocation(line: 0, scope: !133)
!191 = !DILocation(line: 107, column: 2, scope: !133)
