; ModuleID = 'benchmarks/lkmm/rcu+ar-link20.c'
source_filename = "benchmarks/lkmm/rcu+ar-link20.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !48
@r0 = dso_local global i32 0, align 4, !dbg !54
@s = dso_local global i32 0, align 4, !dbg !52
@r2 = dso_local global i32 0, align 4, !dbg !56
@a = dso_local global i32 0, align 4, !dbg !50
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !31
@.str = private unnamed_addr constant [16 x i8] c"rcu+ar-link20.c\00", align 1, !dbg !38
@.str.1 = private unnamed_addr constant [42 x i8] c"!(r0 == 1 && r2 == 1 && a == 1 && x == 1)\00", align 1, !dbg !43
@r6 = dso_local global i32 0, align 4, !dbg !58

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P0(ptr noundef %0) #0 !dbg !68 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !72, !DIExpression(), !73)
  call void @__LKMM_fence(i32 noundef 7), !dbg !74
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !75
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !76
  %4 = trunc i64 %3 to i32, !dbg !76
  store i32 %4, ptr @r0, align 4, !dbg !77
  call void @__LKMM_fence(i32 noundef 8), !dbg !78
  ret ptr null, !dbg !79
}

declare void @__LKMM_fence(i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P1(ptr noundef %0) #0 !dbg !80 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !81, !DIExpression(), !82)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !83
  call void @__LKMM_fence(i32 noundef 4), !dbg !84
  call void @__LKMM_store(ptr noundef @s, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !85
  ret ptr null, !dbg !86
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P2(ptr noundef %0) #0 !dbg !87 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !88, !DIExpression(), !89)
    #dbg_declare(ptr %3, !90, !DIExpression(), !91)
  %4 = call i64 @__LKMM_load(ptr noundef @s, i64 noundef 4, i32 noundef 1), !dbg !92
  %5 = trunc i64 %4 to i32, !dbg !92
  store i32 %5, ptr %3, align 4, !dbg !91
  %6 = load i32, ptr %3, align 4, !dbg !93
  %7 = icmp ne i32 %6, 0, !dbg !93
  br i1 %7, label %8, label %10, !dbg !95

8:                                                ; preds = %1
  %9 = load i32, ptr %3, align 4, !dbg !96
  store i32 %9, ptr @r2, align 4, !dbg !98
  call void @__LKMM_store(ptr noundef @a, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !99
  br label %10, !dbg !100

10:                                               ; preds = %8, %1
  ret ptr null, !dbg !101
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P3(ptr noundef %0) #0 !dbg !102 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !103, !DIExpression(), !104)
  call void @__LKMM_store(ptr noundef @a, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !105
  call void @__LKMM_fence(i32 noundef 9), !dbg !106
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !107
  ret ptr null, !dbg !108
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !109 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !112, !DIExpression(), !135)
    #dbg_declare(ptr %3, !136, !DIExpression(), !137)
    #dbg_declare(ptr %4, !138, !DIExpression(), !139)
    #dbg_declare(ptr %5, !140, !DIExpression(), !141)
  %6 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @P0, ptr noundef null), !dbg !142
  %7 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @P1, ptr noundef null), !dbg !143
  %8 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @P2, ptr noundef null), !dbg !144
  %9 = call i32 @pthread_create(ptr noundef %5, ptr noundef null, ptr noundef @P3, ptr noundef null), !dbg !145
  %10 = load ptr, ptr %2, align 8, !dbg !146
  %11 = call i32 @_pthread_join(ptr noundef %10, ptr noundef null), !dbg !147
  %12 = load ptr, ptr %3, align 8, !dbg !148
  %13 = call i32 @_pthread_join(ptr noundef %12, ptr noundef null), !dbg !149
  %14 = load ptr, ptr %4, align 8, !dbg !150
  %15 = call i32 @_pthread_join(ptr noundef %14, ptr noundef null), !dbg !151
  %16 = load ptr, ptr %5, align 8, !dbg !152
  %17 = call i32 @_pthread_join(ptr noundef %16, ptr noundef null), !dbg !153
  %18 = load i32, ptr @r0, align 4, !dbg !154
  %19 = icmp eq i32 %18, 1, !dbg !154
  br i1 %19, label %20, label %29, !dbg !154

20:                                               ; preds = %0
  %21 = load i32, ptr @r2, align 4, !dbg !154
  %22 = icmp eq i32 %21, 1, !dbg !154
  br i1 %22, label %23, label %29, !dbg !154

23:                                               ; preds = %20
  %24 = load i32, ptr @a, align 4, !dbg !154
  %25 = icmp eq i32 %24, 1, !dbg !154
  br i1 %25, label %26, label %29, !dbg !154

26:                                               ; preds = %23
  %27 = load i32, ptr @x, align 4, !dbg !154
  %28 = icmp eq i32 %27, 1, !dbg !154
  br label %29

29:                                               ; preds = %26, %23, %20, %0
  %30 = phi i1 [ false, %23 ], [ false, %20 ], [ false, %0 ], [ %28, %26 ], !dbg !155
  %31 = xor i1 %30, true, !dbg !154
  %32 = xor i1 %31, true, !dbg !154
  %33 = zext i1 %32 to i32, !dbg !154
  %34 = sext i32 %33 to i64, !dbg !154
  %35 = icmp ne i64 %34, 0, !dbg !154
  br i1 %35, label %36, label %38, !dbg !154

36:                                               ; preds = %29
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 68, ptr noundef @.str.1) #3, !dbg !154
  unreachable, !dbg !154

37:                                               ; No predecessors!
  br label %39, !dbg !154

38:                                               ; preds = %29
  br label %39, !dbg !154

39:                                               ; preds = %38, %37
  ret i32 0, !dbg !156
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @_pthread_join(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!60, !61, !62, !63, !64, !65, !66}
!llvm.ident = !{!67}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !30, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/rcu+ar-link20.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "04db98ea4c002dca60e5a54977930ea2")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "09faa2df2f4b7a5b710a8844ff483434")
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
!23 = !{!24, !28, !29}
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !26, line: 32, baseType: !27)
!26 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!27 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!30 = !{!31, !38, !43, !0, !48, !50, !52, !54, !56, !58}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 68, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 40, elements: !36)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!35 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!36 = !{!37}
!37 = !DISubrange(count: 5)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 68, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 128, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 16)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 68, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 336, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 42)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 8, type: !28, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 9, type: !28, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 10, type: !28, isLocal: false, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 12, type: !28, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "r2", scope: !2, file: !3, line: 13, type: !28, isLocal: false, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "r6", scope: !2, file: !3, line: 14, type: !28, isLocal: false, isDefinition: true)
!60 = !{i32 7, !"Dwarf Version", i32 5}
!61 = !{i32 2, !"Debug Info Version", i32 3}
!62 = !{i32 1, !"wchar_size", i32 4}
!63 = !{i32 8, !"PIC Level", i32 2}
!64 = !{i32 7, !"PIE Level", i32 2}
!65 = !{i32 7, !"uwtable", i32 2}
!66 = !{i32 7, !"frame-pointer", i32 2}
!67 = !{!"Homebrew clang version 19.1.7"}
!68 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 16, type: !69, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!69 = !DISubroutineType(types: !70)
!70 = !{!29, !29}
!71 = !{}
!72 = !DILocalVariable(name: "unused", arg: 1, scope: !68, file: !3, line: 16, type: !29)
!73 = !DILocation(line: 16, column: 16, scope: !68)
!74 = !DILocation(line: 18, column: 2, scope: !68)
!75 = !DILocation(line: 19, column: 2, scope: !68)
!76 = !DILocation(line: 20, column: 7, scope: !68)
!77 = !DILocation(line: 20, column: 5, scope: !68)
!78 = !DILocation(line: 21, column: 2, scope: !68)
!79 = !DILocation(line: 22, column: 2, scope: !68)
!80 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 25, type: !69, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!81 = !DILocalVariable(name: "unused", arg: 1, scope: !80, file: !3, line: 25, type: !29)
!82 = !DILocation(line: 25, column: 16, scope: !80)
!83 = !DILocation(line: 27, column: 2, scope: !80)
!84 = !DILocation(line: 28, column: 2, scope: !80)
!85 = !DILocation(line: 29, column: 2, scope: !80)
!86 = !DILocation(line: 30, column: 2, scope: !80)
!87 = distinct !DISubprogram(name: "P2", scope: !3, file: !3, line: 33, type: !69, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!88 = !DILocalVariable(name: "unused", arg: 1, scope: !87, file: !3, line: 33, type: !29)
!89 = !DILocation(line: 33, column: 16, scope: !87)
!90 = !DILocalVariable(name: "r", scope: !87, file: !3, line: 35, type: !28)
!91 = !DILocation(line: 35, column: 6, scope: !87)
!92 = !DILocation(line: 35, column: 10, scope: !87)
!93 = !DILocation(line: 36, column: 6, scope: !94)
!94 = distinct !DILexicalBlock(scope: !87, file: !3, line: 36, column: 6)
!95 = !DILocation(line: 36, column: 6, scope: !87)
!96 = !DILocation(line: 37, column: 8, scope: !97)
!97 = distinct !DILexicalBlock(scope: !94, file: !3, line: 36, column: 9)
!98 = !DILocation(line: 37, column: 6, scope: !97)
!99 = !DILocation(line: 38, column: 3, scope: !97)
!100 = !DILocation(line: 39, column: 2, scope: !97)
!101 = !DILocation(line: 40, column: 2, scope: !87)
!102 = distinct !DISubprogram(name: "P3", scope: !3, file: !3, line: 43, type: !69, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!103 = !DILocalVariable(name: "unused", arg: 1, scope: !102, file: !3, line: 43, type: !29)
!104 = !DILocation(line: 43, column: 16, scope: !102)
!105 = !DILocation(line: 45, column: 2, scope: !102)
!106 = !DILocation(line: 46, column: 2, scope: !102)
!107 = !DILocation(line: 47, column: 2, scope: !102)
!108 = !DILocation(line: 48, column: 2, scope: !102)
!109 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 51, type: !110, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!110 = !DISubroutineType(types: !111)
!111 = !{!28}
!112 = !DILocalVariable(name: "t0", scope: !109, file: !3, line: 56, type: !113)
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !114, line: 31, baseType: !115)
!114 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!115 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !116, line: 118, baseType: !117)
!116 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!117 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !118, size: 64)
!118 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !116, line: 103, size: 65536, elements: !119)
!119 = !{!120, !121, !131}
!120 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !118, file: !116, line: 104, baseType: !27, size: 64)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !118, file: !116, line: 105, baseType: !122, size: 64, offset: 64)
!122 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !123, size: 64)
!123 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !116, line: 57, size: 192, elements: !124)
!124 = !{!125, !129, !130}
!125 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !123, file: !116, line: 58, baseType: !126, size: 64)
!126 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !127, size: 64)
!127 = !DISubroutineType(types: !128)
!128 = !{null, !29}
!129 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !123, file: !116, line: 59, baseType: !29, size: 64, offset: 64)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !123, file: !116, line: 60, baseType: !122, size: 64, offset: 128)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !118, file: !116, line: 106, baseType: !132, size: 65408, offset: 128)
!132 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 65408, elements: !133)
!133 = !{!134}
!134 = !DISubrange(count: 8176)
!135 = !DILocation(line: 56, column: 12, scope: !109)
!136 = !DILocalVariable(name: "t1", scope: !109, file: !3, line: 56, type: !113)
!137 = !DILocation(line: 56, column: 16, scope: !109)
!138 = !DILocalVariable(name: "t2", scope: !109, file: !3, line: 56, type: !113)
!139 = !DILocation(line: 56, column: 20, scope: !109)
!140 = !DILocalVariable(name: "t3", scope: !109, file: !3, line: 56, type: !113)
!141 = !DILocation(line: 56, column: 24, scope: !109)
!142 = !DILocation(line: 58, column: 2, scope: !109)
!143 = !DILocation(line: 59, column: 2, scope: !109)
!144 = !DILocation(line: 60, column: 2, scope: !109)
!145 = !DILocation(line: 61, column: 2, scope: !109)
!146 = !DILocation(line: 63, column: 15, scope: !109)
!147 = !DILocation(line: 63, column: 2, scope: !109)
!148 = !DILocation(line: 64, column: 15, scope: !109)
!149 = !DILocation(line: 64, column: 2, scope: !109)
!150 = !DILocation(line: 65, column: 15, scope: !109)
!151 = !DILocation(line: 65, column: 2, scope: !109)
!152 = !DILocation(line: 66, column: 15, scope: !109)
!153 = !DILocation(line: 66, column: 2, scope: !109)
!154 = !DILocation(line: 68, column: 2, scope: !109)
!155 = !DILocation(line: 0, scope: !109)
!156 = !DILocation(line: 70, column: 2, scope: !109)
