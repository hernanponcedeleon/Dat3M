; ModuleID = 'benchmarks/lkmm/rcu+ar-link20.c'
source_filename = "benchmarks/lkmm/rcu+ar-link20.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !47
@r0 = dso_local global i32 0, align 4, !dbg !53
@s = dso_local global i32 0, align 4, !dbg !51
@r2 = dso_local global i32 0, align 4, !dbg !55
@a = dso_local global i32 0, align 4, !dbg !49
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !30
@.str = private unnamed_addr constant [16 x i8] c"rcu+ar-link20.c\00", align 1, !dbg !37
@.str.1 = private unnamed_addr constant [42 x i8] c"!(r0 == 1 && r2 == 1 && a == 1 && x == 1)\00", align 1, !dbg !42
@r6 = dso_local global i32 0, align 4, !dbg !57

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P0(ptr noundef %0) #0 !dbg !67 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !71, !DIExpression(), !72)
  call void @__LKMM_fence(i32 noundef 6), !dbg !73
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 0), !dbg !74
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 0), !dbg !75
  %4 = trunc i64 %3 to i32, !dbg !75
  store i32 %4, ptr @r0, align 4, !dbg !76
  call void @__LKMM_fence(i32 noundef 7), !dbg !77
  ret ptr null, !dbg !78
}

declare void @__LKMM_fence(i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P1(ptr noundef %0) #0 !dbg !79 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !80, !DIExpression(), !81)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !82
  call void @__LKMM_fence(i32 noundef 3), !dbg !83
  call void @__LKMM_store(ptr noundef @s, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !84
  ret ptr null, !dbg !85
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P2(ptr noundef %0) #0 !dbg !86 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !87, !DIExpression(), !88)
    #dbg_declare(ptr %3, !89, !DIExpression(), !90)
  %4 = call i64 @__LKMM_load(ptr noundef @s, i64 noundef 4, i32 noundef 0), !dbg !91
  %5 = trunc i64 %4 to i32, !dbg !91
  store i32 %5, ptr %3, align 4, !dbg !90
  %6 = load i32, ptr %3, align 4, !dbg !92
  %7 = icmp ne i32 %6, 0, !dbg !92
  br i1 %7, label %8, label %10, !dbg !94

8:                                                ; preds = %1
  %9 = load i32, ptr %3, align 4, !dbg !95
  store i32 %9, ptr @r2, align 4, !dbg !97
  call void @__LKMM_store(ptr noundef @a, i64 noundef 4, i64 noundef 2, i32 noundef 0), !dbg !98
  br label %10, !dbg !99

10:                                               ; preds = %8, %1
  ret ptr null, !dbg !100
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P3(ptr noundef %0) #0 !dbg !101 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !102, !DIExpression(), !103)
  call void @__LKMM_store(ptr noundef @a, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !104
  call void @__LKMM_fence(i32 noundef 8), !dbg !105
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !106
  ret ptr null, !dbg !107
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !108 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !111, !DIExpression(), !134)
    #dbg_declare(ptr %3, !135, !DIExpression(), !136)
    #dbg_declare(ptr %4, !137, !DIExpression(), !138)
    #dbg_declare(ptr %5, !139, !DIExpression(), !140)
  %6 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @P0, ptr noundef null), !dbg !141
  %7 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @P1, ptr noundef null), !dbg !142
  %8 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @P2, ptr noundef null), !dbg !143
  %9 = call i32 @pthread_create(ptr noundef %5, ptr noundef null, ptr noundef @P3, ptr noundef null), !dbg !144
  %10 = load ptr, ptr %2, align 8, !dbg !145
  %11 = call i32 @_pthread_join(ptr noundef %10, ptr noundef null), !dbg !146
  %12 = load ptr, ptr %3, align 8, !dbg !147
  %13 = call i32 @_pthread_join(ptr noundef %12, ptr noundef null), !dbg !148
  %14 = load ptr, ptr %4, align 8, !dbg !149
  %15 = call i32 @_pthread_join(ptr noundef %14, ptr noundef null), !dbg !150
  %16 = load ptr, ptr %5, align 8, !dbg !151
  %17 = call i32 @_pthread_join(ptr noundef %16, ptr noundef null), !dbg !152
  %18 = load i32, ptr @r0, align 4, !dbg !153
  %19 = icmp eq i32 %18, 1, !dbg !153
  br i1 %19, label %20, label %29, !dbg !153

20:                                               ; preds = %0
  %21 = load i32, ptr @r2, align 4, !dbg !153
  %22 = icmp eq i32 %21, 1, !dbg !153
  br i1 %22, label %23, label %29, !dbg !153

23:                                               ; preds = %20
  %24 = load i32, ptr @a, align 4, !dbg !153
  %25 = icmp eq i32 %24, 1, !dbg !153
  br i1 %25, label %26, label %29, !dbg !153

26:                                               ; preds = %23
  %27 = load i32, ptr @x, align 4, !dbg !153
  %28 = icmp eq i32 %27, 1, !dbg !153
  br label %29

29:                                               ; preds = %26, %23, %20, %0
  %30 = phi i1 [ false, %23 ], [ false, %20 ], [ false, %0 ], [ %28, %26 ], !dbg !154
  %31 = xor i1 %30, true, !dbg !153
  %32 = xor i1 %31, true, !dbg !153
  %33 = zext i1 %32 to i32, !dbg !153
  %34 = sext i32 %33 to i64, !dbg !153
  %35 = icmp ne i64 %34, 0, !dbg !153
  br i1 %35, label %36, label %38, !dbg !153

36:                                               ; preds = %29
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 68, ptr noundef @.str.1) #3, !dbg !153
  unreachable, !dbg !153

37:                                               ; No predecessors!
  br label %39, !dbg !153

38:                                               ; preds = %29
  br label %39, !dbg !153

39:                                               ; preds = %38, %37
  ret i32 0, !dbg !155
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
!llvm.module.flags = !{!59, !60, !61, !62, !63, !64, !65}
!llvm.ident = !{!66}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !27, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !22, globals: !29, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/rcu+ar-link20.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "04db98ea4c002dca60e5a54977930ea2")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "26457005f8f39b3952d279119fb45118")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21}
!9 = !DIEnumerator(name: "__LKMM_once", value: 0)
!10 = !DIEnumerator(name: "__LKMM_acquire", value: 1)
!11 = !DIEnumerator(name: "__LKMM_release", value: 2)
!12 = !DIEnumerator(name: "__LKMM_mb", value: 3)
!13 = !DIEnumerator(name: "__LKMM_wmb", value: 4)
!14 = !DIEnumerator(name: "__LKMM_rmb", value: 5)
!15 = !DIEnumerator(name: "__LKMM_rcu_lock", value: 6)
!16 = !DIEnumerator(name: "__LKMM_rcu_unlock", value: 7)
!17 = !DIEnumerator(name: "__LKMM_rcu_sync", value: 8)
!18 = !DIEnumerator(name: "__LKMM_before_atomic", value: 9)
!19 = !DIEnumerator(name: "__LKMM_after_atomic", value: 10)
!20 = !DIEnumerator(name: "__LKMM_after_spinlock", value: 11)
!21 = !DIEnumerator(name: "__LKMM_barrier", value: 12)
!22 = !{!23, !27, !28}
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 27, baseType: !24)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !25, line: 32, baseType: !26)
!25 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!26 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!29 = !{!30, !37, !42, !0, !47, !49, !51, !53, !55, !57}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 68, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 40, elements: !35)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!34 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!35 = !{!36}
!36 = !DISubrange(count: 5)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 68, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 128, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 16)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 68, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 336, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 42)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 8, type: !27, isLocal: false, isDefinition: true)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 9, type: !27, isLocal: false, isDefinition: true)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 10, type: !27, isLocal: false, isDefinition: true)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 12, type: !27, isLocal: false, isDefinition: true)
!55 = !DIGlobalVariableExpression(var: !56, expr: !DIExpression())
!56 = distinct !DIGlobalVariable(name: "r2", scope: !2, file: !3, line: 13, type: !27, isLocal: false, isDefinition: true)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "r6", scope: !2, file: !3, line: 14, type: !27, isLocal: false, isDefinition: true)
!59 = !{i32 7, !"Dwarf Version", i32 5}
!60 = !{i32 2, !"Debug Info Version", i32 3}
!61 = !{i32 1, !"wchar_size", i32 4}
!62 = !{i32 8, !"PIC Level", i32 2}
!63 = !{i32 7, !"PIE Level", i32 2}
!64 = !{i32 7, !"uwtable", i32 2}
!65 = !{i32 7, !"frame-pointer", i32 2}
!66 = !{!"Homebrew clang version 19.1.7"}
!67 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 16, type: !68, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!68 = !DISubroutineType(types: !69)
!69 = !{!28, !28}
!70 = !{}
!71 = !DILocalVariable(name: "unused", arg: 1, scope: !67, file: !3, line: 16, type: !28)
!72 = !DILocation(line: 16, column: 16, scope: !67)
!73 = !DILocation(line: 18, column: 2, scope: !67)
!74 = !DILocation(line: 19, column: 2, scope: !67)
!75 = !DILocation(line: 20, column: 7, scope: !67)
!76 = !DILocation(line: 20, column: 5, scope: !67)
!77 = !DILocation(line: 21, column: 2, scope: !67)
!78 = !DILocation(line: 22, column: 2, scope: !67)
!79 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 25, type: !68, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!80 = !DILocalVariable(name: "unused", arg: 1, scope: !79, file: !3, line: 25, type: !28)
!81 = !DILocation(line: 25, column: 16, scope: !79)
!82 = !DILocation(line: 27, column: 2, scope: !79)
!83 = !DILocation(line: 28, column: 2, scope: !79)
!84 = !DILocation(line: 29, column: 2, scope: !79)
!85 = !DILocation(line: 30, column: 2, scope: !79)
!86 = distinct !DISubprogram(name: "P2", scope: !3, file: !3, line: 33, type: !68, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!87 = !DILocalVariable(name: "unused", arg: 1, scope: !86, file: !3, line: 33, type: !28)
!88 = !DILocation(line: 33, column: 16, scope: !86)
!89 = !DILocalVariable(name: "r", scope: !86, file: !3, line: 35, type: !27)
!90 = !DILocation(line: 35, column: 6, scope: !86)
!91 = !DILocation(line: 35, column: 10, scope: !86)
!92 = !DILocation(line: 36, column: 6, scope: !93)
!93 = distinct !DILexicalBlock(scope: !86, file: !3, line: 36, column: 6)
!94 = !DILocation(line: 36, column: 6, scope: !86)
!95 = !DILocation(line: 37, column: 8, scope: !96)
!96 = distinct !DILexicalBlock(scope: !93, file: !3, line: 36, column: 9)
!97 = !DILocation(line: 37, column: 6, scope: !96)
!98 = !DILocation(line: 38, column: 3, scope: !96)
!99 = !DILocation(line: 39, column: 2, scope: !96)
!100 = !DILocation(line: 40, column: 2, scope: !86)
!101 = distinct !DISubprogram(name: "P3", scope: !3, file: !3, line: 43, type: !68, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!102 = !DILocalVariable(name: "unused", arg: 1, scope: !101, file: !3, line: 43, type: !28)
!103 = !DILocation(line: 43, column: 16, scope: !101)
!104 = !DILocation(line: 45, column: 2, scope: !101)
!105 = !DILocation(line: 46, column: 2, scope: !101)
!106 = !DILocation(line: 47, column: 2, scope: !101)
!107 = !DILocation(line: 48, column: 2, scope: !101)
!108 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 51, type: !109, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!109 = !DISubroutineType(types: !110)
!110 = !{!27}
!111 = !DILocalVariable(name: "t0", scope: !108, file: !3, line: 56, type: !112)
!112 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !113, line: 31, baseType: !114)
!113 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!114 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !115, line: 118, baseType: !116)
!115 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !115, line: 103, size: 65536, elements: !118)
!118 = !{!119, !120, !130}
!119 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !117, file: !115, line: 104, baseType: !26, size: 64)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !117, file: !115, line: 105, baseType: !121, size: 64, offset: 64)
!121 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !122, size: 64)
!122 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !115, line: 57, size: 192, elements: !123)
!123 = !{!124, !128, !129}
!124 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !122, file: !115, line: 58, baseType: !125, size: 64)
!125 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !126, size: 64)
!126 = !DISubroutineType(types: !127)
!127 = !{null, !28}
!128 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !122, file: !115, line: 59, baseType: !28, size: 64, offset: 64)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !122, file: !115, line: 60, baseType: !121, size: 64, offset: 128)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !117, file: !115, line: 106, baseType: !131, size: 65408, offset: 128)
!131 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 65408, elements: !132)
!132 = !{!133}
!133 = !DISubrange(count: 8176)
!134 = !DILocation(line: 56, column: 12, scope: !108)
!135 = !DILocalVariable(name: "t1", scope: !108, file: !3, line: 56, type: !112)
!136 = !DILocation(line: 56, column: 16, scope: !108)
!137 = !DILocalVariable(name: "t2", scope: !108, file: !3, line: 56, type: !112)
!138 = !DILocation(line: 56, column: 20, scope: !108)
!139 = !DILocalVariable(name: "t3", scope: !108, file: !3, line: 56, type: !112)
!140 = !DILocation(line: 56, column: 24, scope: !108)
!141 = !DILocation(line: 58, column: 2, scope: !108)
!142 = !DILocation(line: 59, column: 2, scope: !108)
!143 = !DILocation(line: 60, column: 2, scope: !108)
!144 = !DILocation(line: 61, column: 2, scope: !108)
!145 = !DILocation(line: 63, column: 15, scope: !108)
!146 = !DILocation(line: 63, column: 2, scope: !108)
!147 = !DILocation(line: 64, column: 15, scope: !108)
!148 = !DILocation(line: 64, column: 2, scope: !108)
!149 = !DILocation(line: 65, column: 15, scope: !108)
!150 = !DILocation(line: 65, column: 2, scope: !108)
!151 = !DILocation(line: 66, column: 15, scope: !108)
!152 = !DILocation(line: 66, column: 2, scope: !108)
!153 = !DILocation(line: 68, column: 2, scope: !108)
!154 = !DILocation(line: 0, scope: !108)
!155 = !DILocation(line: 70, column: 2, scope: !108)
