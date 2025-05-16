; ModuleID = 'benchmarks/lkmm/LB+poacquireonce+pooncerelease.c'
source_filename = "benchmarks/lkmm/LB+poacquireonce+pooncerelease.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4, !dbg !0
@r0 = global i32 0, align 4, !dbg !48
@y = global i32 0, align 4, !dbg !46
@r1 = global i32 0, align 4, !dbg !50
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [33 x i8] c"LB+poacquireonce+pooncerelease.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [22 x i8] c"!(r0 == 1 && r1 == 1)\00", align 1, !dbg !41

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_1(ptr noundef %0) #0 !dbg !59 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !63, !DIExpression(), !64)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !65
  %4 = trunc i64 %3 to i32, !dbg !65
  store i32 %4, ptr @r0, align 4, !dbg !66
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 3), !dbg !67
  ret ptr null, !dbg !68
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_2(ptr noundef %0) #0 !dbg !69 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !70, !DIExpression(), !71)
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 2), !dbg !72
  %4 = trunc i64 %3 to i32, !dbg !72
  store i32 %4, ptr @r1, align 4, !dbg !73
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !74
  ret ptr null, !dbg !75
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !76 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !79, !DIExpression(), !103)
    #dbg_declare(ptr %3, !104, !DIExpression(), !105)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !106
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !107
  %6 = load ptr, ptr %2, align 8, !dbg !108
  %7 = call i32 @"\01_pthread_join"(ptr noundef %6, ptr noundef null), !dbg !109
  %8 = load ptr, ptr %3, align 8, !dbg !110
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !111
  %10 = load i32, ptr @r0, align 4, !dbg !112
  %11 = icmp eq i32 %10, 1, !dbg !112
  br i1 %11, label %12, label %15, !dbg !112

12:                                               ; preds = %0
  %13 = load i32, ptr @r1, align 4, !dbg !112
  %14 = icmp eq i32 %13, 1, !dbg !112
  br label %15

15:                                               ; preds = %12, %0
  %16 = phi i1 [ false, %0 ], [ %14, %12 ], !dbg !113
  %17 = xor i1 %16, true, !dbg !112
  %18 = xor i1 %17, true, !dbg !112
  %19 = zext i1 %18 to i32, !dbg !112
  %20 = sext i32 %19 to i64, !dbg !112
  %21 = icmp ne i64 %20, 0, !dbg !112
  br i1 %21, label %22, label %24, !dbg !112

22:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 35, ptr noundef @.str.1) #3, !dbg !112
  unreachable, !dbg !112

23:                                               ; No predecessors!
  br label %25, !dbg !112

24:                                               ; preds = %15
  br label %25, !dbg !112

25:                                               ; preds = %24, %23
  ret i32 0, !dbg !114
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
!llvm.module.flags = !{!52, !53, !54, !55, !56, !57}
!llvm.ident = !{!58}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/lkmm/LB+poacquireonce+pooncerelease.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "273f0308996bdd503c288ed473fb0e4c")
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
!23 = !{!24, !25, !27}
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !26)
!26 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = !{!29, !36, !41, !0, !46, !48, !50}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 35, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !34)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{!35}
!35 = !DISubrange(count: 5)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 35, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 264, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 33)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 35, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 176, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 22)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !24, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 9, type: !24, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !3, line: 9, type: !24, isLocal: false, isDefinition: true)
!52 = !{i32 7, !"Dwarf Version", i32 5}
!53 = !{i32 2, !"Debug Info Version", i32 3}
!54 = !{i32 1, !"wchar_size", i32 4}
!55 = !{i32 8, !"PIC Level", i32 2}
!56 = !{i32 7, !"uwtable", i32 1}
!57 = !{i32 7, !"frame-pointer", i32 1}
!58 = !{!"Homebrew clang version 19.1.7"}
!59 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 11, type: !60, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!60 = !DISubroutineType(types: !61)
!61 = !{!27, !27}
!62 = !{}
!63 = !DILocalVariable(name: "unused", arg: 1, scope: !59, file: !3, line: 11, type: !27)
!64 = !DILocation(line: 11, column: 22, scope: !59)
!65 = !DILocation(line: 13, column: 7, scope: !59)
!66 = !DILocation(line: 13, column: 5, scope: !59)
!67 = !DILocation(line: 14, column: 2, scope: !59)
!68 = !DILocation(line: 15, column: 2, scope: !59)
!69 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 18, type: !60, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!70 = !DILocalVariable(name: "unused", arg: 1, scope: !69, file: !3, line: 18, type: !27)
!71 = !DILocation(line: 18, column: 22, scope: !69)
!72 = !DILocation(line: 20, column: 7, scope: !69)
!73 = !DILocation(line: 20, column: 5, scope: !69)
!74 = !DILocation(line: 21, column: 2, scope: !69)
!75 = !DILocation(line: 22, column: 2, scope: !69)
!76 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 25, type: !77, scopeLine: 26, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !62)
!77 = !DISubroutineType(types: !78)
!78 = !{!24}
!79 = !DILocalVariable(name: "t1", scope: !76, file: !3, line: 27, type: !80)
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !81, line: 31, baseType: !82)
!81 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !83, line: 118, baseType: !84)
!83 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !85, size: 64)
!85 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !83, line: 103, size: 65536, elements: !86)
!86 = !{!87, !89, !99}
!87 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !85, file: !83, line: 104, baseType: !88, size: 64)
!88 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !85, file: !83, line: 105, baseType: !90, size: 64, offset: 64)
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !91, size: 64)
!91 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !83, line: 57, size: 192, elements: !92)
!92 = !{!93, !97, !98}
!93 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !91, file: !83, line: 58, baseType: !94, size: 64)
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!95 = !DISubroutineType(types: !96)
!96 = !{null, !27}
!97 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !91, file: !83, line: 59, baseType: !27, size: 64, offset: 64)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !91, file: !83, line: 60, baseType: !90, size: 64, offset: 128)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !85, file: !83, line: 106, baseType: !100, size: 65408, offset: 128)
!100 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !101)
!101 = !{!102}
!102 = !DISubrange(count: 8176)
!103 = !DILocation(line: 27, column: 12, scope: !76)
!104 = !DILocalVariable(name: "t2", scope: !76, file: !3, line: 27, type: !80)
!105 = !DILocation(line: 27, column: 16, scope: !76)
!106 = !DILocation(line: 29, column: 2, scope: !76)
!107 = !DILocation(line: 30, column: 2, scope: !76)
!108 = !DILocation(line: 32, column: 15, scope: !76)
!109 = !DILocation(line: 32, column: 2, scope: !76)
!110 = !DILocation(line: 33, column: 15, scope: !76)
!111 = !DILocation(line: 33, column: 2, scope: !76)
!112 = !DILocation(line: 35, column: 2, scope: !76)
!113 = !DILocation(line: 0, scope: !76)
!114 = !DILocation(line: 37, column: 2, scope: !76)
