; ModuleID = 'benchmarks/lkmm/rcu+ar-link-short0.c'
source_filename = "benchmarks/lkmm/rcu+ar-link-short0.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@w = global [2 x i32] [i32 0, i32 1], align 4, !dbg !0
@x = global i32 0, align 4, !dbg !46
@y = global i32 0, align 4, !dbg !48
@s = global i32 0, align 4, !dbg !54
@r_s = global i32 0, align 4, !dbg !56
@r_w = global i32 0, align 4, !dbg !58
@r_y = global i32 0, align 4, !dbg !52
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [21 x i8] c"rcu+ar-link-short0.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [36 x i8] c"!(r_y == 0 && r_s == 1 && r_w == 1)\00", align 1, !dbg !41
@r_x = global i32 0, align 4, !dbg !50

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @P0(ptr noundef %0) #0 !dbg !70 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !74, !DIExpression(), !75)
  call void @__LKMM_fence(i32 noundef 7), !dbg !76
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !77
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !78
  call void @__LKMM_fence(i32 noundef 8), !dbg !79
  ret ptr null, !dbg !80
}

declare void @__LKMM_fence(i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @P1(ptr noundef %0) #0 !dbg !81 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !82, !DIExpression(), !83)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !84
  %4 = trunc i64 %3 to i32, !dbg !84
  %5 = icmp eq i32 %4, 1, !dbg !86
  br i1 %5, label %6, label %7, !dbg !87

6:                                                ; preds = %1
  call void @__LKMM_store(ptr noundef @s, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !88
  br label %7, !dbg !88

7:                                                ; preds = %6, %1
  ret ptr null, !dbg !89
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @P2(ptr noundef %0) #0 !dbg !90 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !91, !DIExpression(), !92)
  %3 = call i64 @__LKMM_load(ptr noundef @s, i64 noundef 4, i32 noundef 1), !dbg !93
  %4 = trunc i64 %3 to i32, !dbg !93
  store i32 %4, ptr @r_s, align 4, !dbg !94
  %5 = load i32, ptr @r_s, align 4, !dbg !95
  %6 = sext i32 %5 to i64, !dbg !95
  %7 = getelementptr inbounds [2 x i32], ptr @w, i64 0, i64 %6, !dbg !95
  %8 = call i64 @__LKMM_load(ptr noundef %7, i64 noundef 4, i32 noundef 1), !dbg !95
  %9 = trunc i64 %8 to i32, !dbg !95
  store i32 %9, ptr @r_w, align 4, !dbg !96
  ret ptr null, !dbg !97
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @P3(ptr noundef %0) #0 !dbg !98 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !99, !DIExpression(), !100)
  call void @__LKMM_store(ptr noundef getelementptr inbounds ([2 x i32], ptr @w, i64 0, i64 1), i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !101
  call void @__LKMM_fence(i32 noundef 9), !dbg !102
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !103
  %4 = trunc i64 %3 to i32, !dbg !103
  store i32 %4, ptr @r_y, align 4, !dbg !104
  ret ptr null, !dbg !105
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !106 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !109, !DIExpression(), !133)
    #dbg_declare(ptr %3, !134, !DIExpression(), !135)
    #dbg_declare(ptr %4, !136, !DIExpression(), !137)
    #dbg_declare(ptr %5, !138, !DIExpression(), !139)
  %6 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @P0, ptr noundef null), !dbg !140
  %7 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @P1, ptr noundef null), !dbg !141
  %8 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @P2, ptr noundef null), !dbg !142
  %9 = call i32 @pthread_create(ptr noundef %5, ptr noundef null, ptr noundef @P3, ptr noundef null), !dbg !143
  %10 = load ptr, ptr %2, align 8, !dbg !144
  %11 = call i32 @"\01_pthread_join"(ptr noundef %10, ptr noundef null), !dbg !145
  %12 = load ptr, ptr %3, align 8, !dbg !146
  %13 = call i32 @"\01_pthread_join"(ptr noundef %12, ptr noundef null), !dbg !147
  %14 = load ptr, ptr %4, align 8, !dbg !148
  %15 = call i32 @"\01_pthread_join"(ptr noundef %14, ptr noundef null), !dbg !149
  %16 = load ptr, ptr %5, align 8, !dbg !150
  %17 = call i32 @"\01_pthread_join"(ptr noundef %16, ptr noundef null), !dbg !151
  %18 = load i32, ptr @r_y, align 4, !dbg !152
  %19 = icmp eq i32 %18, 0, !dbg !152
  br i1 %19, label %20, label %26, !dbg !152

20:                                               ; preds = %0
  %21 = load i32, ptr @r_s, align 4, !dbg !152
  %22 = icmp eq i32 %21, 1, !dbg !152
  br i1 %22, label %23, label %26, !dbg !152

23:                                               ; preds = %20
  %24 = load i32, ptr @r_w, align 4, !dbg !152
  %25 = icmp eq i32 %24, 1, !dbg !152
  br label %26

26:                                               ; preds = %23, %20, %0
  %27 = phi i1 [ false, %20 ], [ false, %0 ], [ %25, %23 ], !dbg !153
  %28 = xor i1 %27, true, !dbg !152
  %29 = xor i1 %28, true, !dbg !152
  %30 = zext i1 %29 to i32, !dbg !152
  %31 = sext i32 %30 to i64, !dbg !152
  %32 = icmp ne i64 %31, 0, !dbg !152
  br i1 %32, label %33, label %35, !dbg !152

33:                                               ; preds = %26
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 82, ptr noundef @.str.1) #3, !dbg !152
  unreachable, !dbg !152

34:                                               ; No predecessors!
  br label %36, !dbg !152

35:                                               ; preds = %26
  br label %36, !dbg !152

36:                                               ; preds = %35, %34
  ret i32 0, !dbg !154
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
!llvm.module.flags = !{!63, !64, !65, !66, !67, !68}
!llvm.ident = !{!69}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "w", scope: !2, file: !3, line: 29, type: !60, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/lkmm/rcu+ar-link-short0.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "75fba3f93246ceba8ebd1225e5ca1dff")
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
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !{!0, !29, !36, !41, !46, !48, !50, !52, !54, !56, !58}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 82, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !34)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{!35}
!35 = !DISubrange(count: 5)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 82, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 168, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 21)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 82, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 288, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 36)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 21, type: !27, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 22, type: !27, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "r_x", scope: !2, file: !3, line: 24, type: !27, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "r_y", scope: !2, file: !3, line: 25, type: !27, isLocal: false, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 28, type: !27, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "r_s", scope: !2, file: !3, line: 31, type: !27, isLocal: false, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "r_w", scope: !2, file: !3, line: 32, type: !27, isLocal: false, isDefinition: true)
!60 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 64, elements: !61)
!61 = !{!62}
!62 = !DISubrange(count: 2)
!63 = !{i32 7, !"Dwarf Version", i32 5}
!64 = !{i32 2, !"Debug Info Version", i32 3}
!65 = !{i32 1, !"wchar_size", i32 4}
!66 = !{i32 8, !"PIC Level", i32 2}
!67 = !{i32 7, !"uwtable", i32 1}
!68 = !{i32 7, !"frame-pointer", i32 1}
!69 = !{!"Homebrew clang version 19.1.7"}
!70 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 34, type: !71, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !73)
!71 = !DISubroutineType(types: !72)
!72 = !{!26, !26}
!73 = !{}
!74 = !DILocalVariable(name: "unused", arg: 1, scope: !70, file: !3, line: 34, type: !26)
!75 = !DILocation(line: 34, column: 16, scope: !70)
!76 = !DILocation(line: 36, column: 2, scope: !70)
!77 = !DILocation(line: 37, column: 2, scope: !70)
!78 = !DILocation(line: 38, column: 2, scope: !70)
!79 = !DILocation(line: 39, column: 2, scope: !70)
!80 = !DILocation(line: 40, column: 2, scope: !70)
!81 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 43, type: !71, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !73)
!82 = !DILocalVariable(name: "unused", arg: 1, scope: !81, file: !3, line: 43, type: !26)
!83 = !DILocation(line: 43, column: 16, scope: !81)
!84 = !DILocation(line: 45, column: 6, scope: !85)
!85 = distinct !DILexicalBlock(scope: !81, file: !3, line: 45, column: 6)
!86 = !DILocation(line: 45, column: 19, scope: !85)
!87 = !DILocation(line: 45, column: 6, scope: !81)
!88 = !DILocation(line: 46, column: 3, scope: !85)
!89 = !DILocation(line: 47, column: 2, scope: !81)
!90 = distinct !DISubprogram(name: "P2", scope: !3, file: !3, line: 50, type: !71, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !73)
!91 = !DILocalVariable(name: "unused", arg: 1, scope: !90, file: !3, line: 50, type: !26)
!92 = !DILocation(line: 50, column: 16, scope: !90)
!93 = !DILocation(line: 52, column: 8, scope: !90)
!94 = !DILocation(line: 52, column: 6, scope: !90)
!95 = !DILocation(line: 53, column: 8, scope: !90)
!96 = !DILocation(line: 53, column: 6, scope: !90)
!97 = !DILocation(line: 54, column: 2, scope: !90)
!98 = distinct !DISubprogram(name: "P3", scope: !3, file: !3, line: 57, type: !71, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !73)
!99 = !DILocalVariable(name: "unused", arg: 1, scope: !98, file: !3, line: 57, type: !26)
!100 = !DILocation(line: 57, column: 16, scope: !98)
!101 = !DILocation(line: 59, column: 2, scope: !98)
!102 = !DILocation(line: 60, column: 2, scope: !98)
!103 = !DILocation(line: 61, column: 8, scope: !98)
!104 = !DILocation(line: 61, column: 6, scope: !98)
!105 = !DILocation(line: 62, column: 2, scope: !98)
!106 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 65, type: !107, scopeLine: 66, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !73)
!107 = !DISubroutineType(types: !108)
!108 = !{!27}
!109 = !DILocalVariable(name: "t0", scope: !106, file: !3, line: 70, type: !110)
!110 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !111, line: 31, baseType: !112)
!111 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!112 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !113, line: 118, baseType: !114)
!113 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!114 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !115, size: 64)
!115 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !113, line: 103, size: 65536, elements: !116)
!116 = !{!117, !119, !129}
!117 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !115, file: !113, line: 104, baseType: !118, size: 64)
!118 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !115, file: !113, line: 105, baseType: !120, size: 64, offset: 64)
!120 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !121, size: 64)
!121 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !113, line: 57, size: 192, elements: !122)
!122 = !{!123, !127, !128}
!123 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !121, file: !113, line: 58, baseType: !124, size: 64)
!124 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !125, size: 64)
!125 = !DISubroutineType(types: !126)
!126 = !{null, !26}
!127 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !121, file: !113, line: 59, baseType: !26, size: 64, offset: 64)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !121, file: !113, line: 60, baseType: !120, size: 64, offset: 128)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !115, file: !113, line: 106, baseType: !130, size: 65408, offset: 128)
!130 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !131)
!131 = !{!132}
!132 = !DISubrange(count: 8176)
!133 = !DILocation(line: 70, column: 12, scope: !106)
!134 = !DILocalVariable(name: "t1", scope: !106, file: !3, line: 70, type: !110)
!135 = !DILocation(line: 70, column: 16, scope: !106)
!136 = !DILocalVariable(name: "t2", scope: !106, file: !3, line: 70, type: !110)
!137 = !DILocation(line: 70, column: 20, scope: !106)
!138 = !DILocalVariable(name: "t3", scope: !106, file: !3, line: 70, type: !110)
!139 = !DILocation(line: 70, column: 24, scope: !106)
!140 = !DILocation(line: 72, column: 2, scope: !106)
!141 = !DILocation(line: 73, column: 2, scope: !106)
!142 = !DILocation(line: 74, column: 2, scope: !106)
!143 = !DILocation(line: 75, column: 2, scope: !106)
!144 = !DILocation(line: 77, column: 15, scope: !106)
!145 = !DILocation(line: 77, column: 2, scope: !106)
!146 = !DILocation(line: 78, column: 15, scope: !106)
!147 = !DILocation(line: 78, column: 2, scope: !106)
!148 = !DILocation(line: 79, column: 15, scope: !106)
!149 = !DILocation(line: 79, column: 2, scope: !106)
!150 = !DILocation(line: 80, column: 15, scope: !106)
!151 = !DILocation(line: 80, column: 2, scope: !106)
!152 = !DILocation(line: 82, column: 2, scope: !106)
!153 = !DILocation(line: 0, scope: !106)
!154 = !DILocation(line: 84, column: 2, scope: !106)
