; ModuleID = 'benchmarks/lkmm/NVR-RMW+Release.c'
source_filename = "benchmarks/lkmm/NVR-RMW+Release.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.atomic_t = type { i32 }

@x = global i32 0, align 4, !dbg !0
@y = global %struct.atomic_t zeroinitializer, align 4, !dbg !57
@__func__.run = private unnamed_addr constant [4 x i8] c"run\00", align 1, !dbg !40
@.str = private unnamed_addr constant [18 x i8] c"NVR-RMW+Release.c\00", align 1, !dbg !47
@.str.1 = private unnamed_addr constant [7 x i8] c"x == 1\00", align 1, !dbg !52

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 !dbg !70 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !74, !DIExpression(), !75)
    #dbg_declare(ptr %3, !76, !DIExpression(), !77)
  %4 = load ptr, ptr %2, align 8, !dbg !78
  %5 = ptrtoint ptr %4 to i64, !dbg !79
  %6 = trunc i64 %5 to i32, !dbg !80
  store i32 %6, ptr %3, align 4, !dbg !77
  %7 = load i32, ptr %3, align 4, !dbg !81
  switch i32 %7, label %26 [
    i32 0, label %8
    i32 1, label %9
    i32 2, label %10
  ], !dbg !82

8:                                                ; preds = %1
  store i32 1, ptr @x, align 4, !dbg !83
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 3, i32 noundef 3), !dbg !85
  br label %26, !dbg !86

9:                                                ; preds = %1
  call void @__LKMM_atomic_op(ptr noundef @y, i64 noundef 4, i64 noundef -3, i32 noundef 2), !dbg !87
  br label %26, !dbg !88

10:                                               ; preds = %1
  %11 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 2), !dbg !89
  %12 = trunc i64 %11 to i32, !dbg !89
  %13 = icmp eq i32 %12, 1, !dbg !91
  br i1 %13, label %14, label %25, !dbg !92

14:                                               ; preds = %10
  %15 = load i32, ptr @x, align 4, !dbg !93
  %16 = icmp eq i32 %15, 1, !dbg !93
  %17 = xor i1 %16, true, !dbg !93
  %18 = zext i1 %17 to i32, !dbg !93
  %19 = sext i32 %18 to i64, !dbg !93
  %20 = icmp ne i64 %19, 0, !dbg !93
  br i1 %20, label %21, label %23, !dbg !93

21:                                               ; preds = %14
  call void @__assert_rtn(ptr noundef @__func__.run, ptr noundef @.str, i32 noundef 28, ptr noundef @.str.1) #3, !dbg !93
  unreachable, !dbg !93

22:                                               ; No predecessors!
  br label %24, !dbg !93

23:                                               ; preds = %14
  br label %24, !dbg !93

24:                                               ; preds = %23, %22
  br label %25, !dbg !95

25:                                               ; preds = %24, %10
  br label %26, !dbg !96

26:                                               ; preds = %1, %25, %9, %8
  ret ptr null, !dbg !97
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_atomic_op(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !98 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !101, !DIExpression(), !124)
    #dbg_declare(ptr %3, !125, !DIExpression(), !126)
    #dbg_declare(ptr %4, !127, !DIExpression(), !128)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @run, ptr noundef null), !dbg !129
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @run, ptr noundef inttoptr (i64 1 to ptr)), !dbg !130
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @run, ptr noundef inttoptr (i64 2 to ptr)), !dbg !131
  %8 = load ptr, ptr %2, align 8, !dbg !132
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !133
  %10 = load ptr, ptr %3, align 8, !dbg !134
  %11 = call i32 @"\01_pthread_join"(ptr noundef %10, ptr noundef null), !dbg !135
  %12 = load ptr, ptr %4, align 8, !dbg !136
  %13 = call i32 @"\01_pthread_join"(ptr noundef %12, ptr noundef null), !dbg !137
  ret i32 0, !dbg !138
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!63, !64, !65, !66, !67, !68}
!llvm.ident = !{!69}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 5, type: !37, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !39, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/lkmm/NVR-RMW+Release.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "288212c519a14c4a96e909a8b480bc52")
!4 = !{!5, !23}
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
!23 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_operation", file: !6, line: 20, baseType: !7, size: 32, elements: !24)
!24 = !{!25, !26, !27, !28}
!25 = !DIEnumerator(name: "__LKMM_op_add", value: 0)
!26 = !DIEnumerator(name: "__LKMM_op_sub", value: 1)
!27 = !DIEnumerator(name: "__LKMM_op_and", value: 2)
!28 = !DIEnumerator(name: "__LKMM_op_or", value: 3)
!29 = !{!30, !35, !37, !38}
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !31, line: 32, baseType: !32)
!31 = !DIFile(filename: "/usr/local/include/sys/_types/_intptr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e478ba47270923b1cca6659f19f02db1")
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_intptr_t", file: !33, line: 40, baseType: !34)
!33 = !DIFile(filename: "/usr/local/include/arm/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "b270144f57ae258d0ce80b8f87be068c")
!34 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !36)
!36 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!37 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!39 = !{!40, !47, !52, !0, !57}
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(scope: null, file: !3, line: 28, type: !42, isLocal: true, isDefinition: true)
!42 = !DICompositeType(tag: DW_TAG_array_type, baseType: !43, size: 32, elements: !45)
!43 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !44)
!44 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!45 = !{!46}
!46 = !DISubrange(count: 4)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(scope: null, file: !3, line: 28, type: !49, isLocal: true, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !44, size: 144, elements: !50)
!50 = !{!51}
!51 = !DISubrange(count: 18)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(scope: null, file: !3, line: 28, type: !54, isLocal: true, isDefinition: true)
!54 = !DICompositeType(tag: DW_TAG_array_type, baseType: !44, size: 56, elements: !55)
!55 = !{!56}
!56 = !DISubrange(count: 7)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 6, type: !59, isLocal: false, isDefinition: true)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 109, baseType: !60)
!60 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 107, size: 32, elements: !61)
!61 = !{!62}
!62 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !60, file: !6, line: 108, baseType: !37, size: 32)
!63 = !{i32 7, !"Dwarf Version", i32 5}
!64 = !{i32 2, !"Debug Info Version", i32 3}
!65 = !{i32 1, !"wchar_size", i32 4}
!66 = !{i32 8, !"PIC Level", i32 2}
!67 = !{i32 7, !"uwtable", i32 1}
!68 = !{i32 7, !"frame-pointer", i32 1}
!69 = !{!"Homebrew clang version 19.1.7"}
!70 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 15, type: !71, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !73)
!71 = !DISubroutineType(types: !72)
!72 = !{!38, !38}
!73 = !{}
!74 = !DILocalVariable(name: "arg", arg: 1, scope: !70, file: !3, line: 15, type: !38)
!75 = !DILocation(line: 15, column: 17, scope: !70)
!76 = !DILocalVariable(name: "tid", scope: !70, file: !3, line: 17, type: !37)
!77 = !DILocation(line: 17, column: 9, scope: !70)
!78 = !DILocation(line: 17, column: 27, scope: !70)
!79 = !DILocation(line: 17, column: 16, scope: !70)
!80 = !DILocation(line: 17, column: 15, scope: !70)
!81 = !DILocation(line: 18, column: 13, scope: !70)
!82 = !DILocation(line: 18, column: 5, scope: !70)
!83 = !DILocation(line: 20, column: 11, scope: !84)
!84 = distinct !DILexicalBlock(scope: !70, file: !3, line: 18, column: 18)
!85 = !DILocation(line: 21, column: 9, scope: !84)
!86 = !DILocation(line: 22, column: 9, scope: !84)
!87 = !DILocation(line: 24, column: 9, scope: !84)
!88 = !DILocation(line: 25, column: 9, scope: !84)
!89 = !DILocation(line: 27, column: 13, scope: !90)
!90 = distinct !DILexicalBlock(scope: !84, file: !3, line: 27, column: 13)
!91 = !DILocation(line: 27, column: 42, scope: !90)
!92 = !DILocation(line: 27, column: 13, scope: !84)
!93 = !DILocation(line: 28, column: 13, scope: !94)
!94 = distinct !DILexicalBlock(scope: !90, file: !3, line: 27, column: 50)
!95 = !DILocation(line: 29, column: 9, scope: !94)
!96 = !DILocation(line: 30, column: 9, scope: !84)
!97 = !DILocation(line: 32, column: 5, scope: !70)
!98 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 34, type: !99, scopeLine: 35, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !73)
!99 = !DISubroutineType(types: !100)
!100 = !{!37}
!101 = !DILocalVariable(name: "t0", scope: !98, file: !3, line: 36, type: !102)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !103, line: 31, baseType: !104)
!103 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!104 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !105, line: 118, baseType: !106)
!105 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!106 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !107, size: 64)
!107 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !105, line: 103, size: 65536, elements: !108)
!108 = !{!109, !110, !120}
!109 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !107, file: !105, line: 104, baseType: !34, size: 64)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !107, file: !105, line: 105, baseType: !111, size: 64, offset: 64)
!111 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!112 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !105, line: 57, size: 192, elements: !113)
!113 = !{!114, !118, !119}
!114 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !112, file: !105, line: 58, baseType: !115, size: 64)
!115 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !116, size: 64)
!116 = !DISubroutineType(types: !117)
!117 = !{null, !38}
!118 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !112, file: !105, line: 59, baseType: !38, size: 64, offset: 64)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !112, file: !105, line: 60, baseType: !111, size: 64, offset: 128)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !107, file: !105, line: 106, baseType: !121, size: 65408, offset: 128)
!121 = !DICompositeType(tag: DW_TAG_array_type, baseType: !44, size: 65408, elements: !122)
!122 = !{!123}
!123 = !DISubrange(count: 8176)
!124 = !DILocation(line: 36, column: 15, scope: !98)
!125 = !DILocalVariable(name: "t1", scope: !98, file: !3, line: 36, type: !102)
!126 = !DILocation(line: 36, column: 19, scope: !98)
!127 = !DILocalVariable(name: "t2", scope: !98, file: !3, line: 36, type: !102)
!128 = !DILocation(line: 36, column: 23, scope: !98)
!129 = !DILocation(line: 37, column: 5, scope: !98)
!130 = !DILocation(line: 38, column: 5, scope: !98)
!131 = !DILocation(line: 39, column: 5, scope: !98)
!132 = !DILocation(line: 41, column: 18, scope: !98)
!133 = !DILocation(line: 41, column: 5, scope: !98)
!134 = !DILocation(line: 42, column: 18, scope: !98)
!135 = !DILocation(line: 42, column: 5, scope: !98)
!136 = !DILocation(line: 43, column: 18, scope: !98)
!137 = !DILocation(line: 43, column: 5, scope: !98)
!138 = !DILocation(line: 45, column: 5, scope: !98)
