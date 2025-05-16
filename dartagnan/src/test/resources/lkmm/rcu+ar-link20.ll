; ModuleID = 'benchmarks/lkmm/rcu+ar-link20.c'
source_filename = "benchmarks/lkmm/rcu+ar-link20.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !46
@r0 = dso_local global i32 0, align 4, !dbg !52
@s = dso_local global i32 0, align 4, !dbg !50
@r2 = dso_local global i32 0, align 4, !dbg !54
@a = dso_local global i32 0, align 4, !dbg !48
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [16 x i8] c"rcu+ar-link20.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [42 x i8] c"!(r0 == 1 && r2 == 1 && a == 1 && x == 1)\00", align 1, !dbg !41
@r6 = dso_local global i32 0, align 4, !dbg !56

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P0(ptr noundef %0) #0 !dbg !66 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !70, !DIExpression(), !71)
  call void @__LKMM_fence(i32 noundef 7), !dbg !72
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !73
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !74
  %4 = trunc i64 %3 to i32, !dbg !74
  store i32 %4, ptr @r0, align 4, !dbg !75
  call void @__LKMM_fence(i32 noundef 8), !dbg !76
  ret ptr null, !dbg !77
}

declare void @__LKMM_fence(i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P1(ptr noundef %0) #0 !dbg !78 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !79, !DIExpression(), !80)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !81
  call void @__LKMM_fence(i32 noundef 4), !dbg !82
  call void @__LKMM_store(ptr noundef @s, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !83
  ret ptr null, !dbg !84
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P2(ptr noundef %0) #0 !dbg !85 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !86, !DIExpression(), !87)
    #dbg_declare(ptr %3, !88, !DIExpression(), !89)
  %4 = call i64 @__LKMM_load(ptr noundef @s, i64 noundef 4, i32 noundef 1), !dbg !90
  %5 = trunc i64 %4 to i32, !dbg !90
  store i32 %5, ptr %3, align 4, !dbg !89
  %6 = load i32, ptr %3, align 4, !dbg !91
  %7 = icmp ne i32 %6, 0, !dbg !91
  br i1 %7, label %8, label %10, !dbg !93

8:                                                ; preds = %1
  %9 = load i32, ptr %3, align 4, !dbg !94
  store i32 %9, ptr @r2, align 4, !dbg !96
  call void @__LKMM_store(ptr noundef @a, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !97
  br label %10, !dbg !98

10:                                               ; preds = %8, %1
  ret ptr null, !dbg !99
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P3(ptr noundef %0) #0 !dbg !100 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !101, !DIExpression(), !102)
  call void @__LKMM_store(ptr noundef @a, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !103
  call void @__LKMM_fence(i32 noundef 9), !dbg !104
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !105
  ret ptr null, !dbg !106
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !107 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !110, !DIExpression(), !134)
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
!llvm.module.flags = !{!58, !59, !60, !61, !62, !63, !64}
!llvm.ident = !{!65}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !26, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/rcu+ar-link20.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "04db98ea4c002dca60e5a54977930ea2")
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
!28 = !{!29, !36, !41, !0, !46, !48, !50, !52, !54, !56}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 68, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !34)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{!35}
!35 = !DISubrange(count: 5)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 68, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 128, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 16)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 68, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 336, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 42)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 8, type: !26, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 9, type: !26, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 10, type: !26, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 12, type: !26, isLocal: false, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "r2", scope: !2, file: !3, line: 13, type: !26, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "r6", scope: !2, file: !3, line: 14, type: !26, isLocal: false, isDefinition: true)
!58 = !{i32 7, !"Dwarf Version", i32 5}
!59 = !{i32 2, !"Debug Info Version", i32 3}
!60 = !{i32 1, !"wchar_size", i32 4}
!61 = !{i32 8, !"PIC Level", i32 2}
!62 = !{i32 7, !"PIE Level", i32 2}
!63 = !{i32 7, !"uwtable", i32 2}
!64 = !{i32 7, !"frame-pointer", i32 2}
!65 = !{!"Homebrew clang version 19.1.7"}
!66 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 16, type: !67, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !69)
!67 = !DISubroutineType(types: !68)
!68 = !{!27, !27}
!69 = !{}
!70 = !DILocalVariable(name: "unused", arg: 1, scope: !66, file: !3, line: 16, type: !27)
!71 = !DILocation(line: 16, column: 16, scope: !66)
!72 = !DILocation(line: 18, column: 2, scope: !66)
!73 = !DILocation(line: 19, column: 2, scope: !66)
!74 = !DILocation(line: 20, column: 7, scope: !66)
!75 = !DILocation(line: 20, column: 5, scope: !66)
!76 = !DILocation(line: 21, column: 2, scope: !66)
!77 = !DILocation(line: 22, column: 2, scope: !66)
!78 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 25, type: !67, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !69)
!79 = !DILocalVariable(name: "unused", arg: 1, scope: !78, file: !3, line: 25, type: !27)
!80 = !DILocation(line: 25, column: 16, scope: !78)
!81 = !DILocation(line: 27, column: 2, scope: !78)
!82 = !DILocation(line: 28, column: 2, scope: !78)
!83 = !DILocation(line: 29, column: 2, scope: !78)
!84 = !DILocation(line: 30, column: 2, scope: !78)
!85 = distinct !DISubprogram(name: "P2", scope: !3, file: !3, line: 33, type: !67, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !69)
!86 = !DILocalVariable(name: "unused", arg: 1, scope: !85, file: !3, line: 33, type: !27)
!87 = !DILocation(line: 33, column: 16, scope: !85)
!88 = !DILocalVariable(name: "r", scope: !85, file: !3, line: 35, type: !26)
!89 = !DILocation(line: 35, column: 6, scope: !85)
!90 = !DILocation(line: 35, column: 10, scope: !85)
!91 = !DILocation(line: 36, column: 6, scope: !92)
!92 = distinct !DILexicalBlock(scope: !85, file: !3, line: 36, column: 6)
!93 = !DILocation(line: 36, column: 6, scope: !85)
!94 = !DILocation(line: 37, column: 8, scope: !95)
!95 = distinct !DILexicalBlock(scope: !92, file: !3, line: 36, column: 9)
!96 = !DILocation(line: 37, column: 6, scope: !95)
!97 = !DILocation(line: 38, column: 3, scope: !95)
!98 = !DILocation(line: 39, column: 2, scope: !95)
!99 = !DILocation(line: 40, column: 2, scope: !85)
!100 = distinct !DISubprogram(name: "P3", scope: !3, file: !3, line: 43, type: !67, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !69)
!101 = !DILocalVariable(name: "unused", arg: 1, scope: !100, file: !3, line: 43, type: !27)
!102 = !DILocation(line: 43, column: 16, scope: !100)
!103 = !DILocation(line: 45, column: 2, scope: !100)
!104 = !DILocation(line: 46, column: 2, scope: !100)
!105 = !DILocation(line: 47, column: 2, scope: !100)
!106 = !DILocation(line: 48, column: 2, scope: !100)
!107 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 51, type: !108, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !69)
!108 = !DISubroutineType(types: !109)
!109 = !{!26}
!110 = !DILocalVariable(name: "t0", scope: !107, file: !3, line: 56, type: !111)
!111 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !112, line: 31, baseType: !113)
!112 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !114, line: 118, baseType: !115)
!114 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!115 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !116, size: 64)
!116 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !114, line: 103, size: 65536, elements: !117)
!117 = !{!118, !120, !130}
!118 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !116, file: !114, line: 104, baseType: !119, size: 64)
!119 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !116, file: !114, line: 105, baseType: !121, size: 64, offset: 64)
!121 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !122, size: 64)
!122 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !114, line: 57, size: 192, elements: !123)
!123 = !{!124, !128, !129}
!124 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !122, file: !114, line: 58, baseType: !125, size: 64)
!125 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !126, size: 64)
!126 = !DISubroutineType(types: !127)
!127 = !{null, !27}
!128 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !122, file: !114, line: 59, baseType: !27, size: 64, offset: 64)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !122, file: !114, line: 60, baseType: !121, size: 64, offset: 128)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !116, file: !114, line: 106, baseType: !131, size: 65408, offset: 128)
!131 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !132)
!132 = !{!133}
!133 = !DISubrange(count: 8176)
!134 = !DILocation(line: 56, column: 12, scope: !107)
!135 = !DILocalVariable(name: "t1", scope: !107, file: !3, line: 56, type: !111)
!136 = !DILocation(line: 56, column: 16, scope: !107)
!137 = !DILocalVariable(name: "t2", scope: !107, file: !3, line: 56, type: !111)
!138 = !DILocation(line: 56, column: 20, scope: !107)
!139 = !DILocalVariable(name: "t3", scope: !107, file: !3, line: 56, type: !111)
!140 = !DILocation(line: 56, column: 24, scope: !107)
!141 = !DILocation(line: 58, column: 2, scope: !107)
!142 = !DILocation(line: 59, column: 2, scope: !107)
!143 = !DILocation(line: 60, column: 2, scope: !107)
!144 = !DILocation(line: 61, column: 2, scope: !107)
!145 = !DILocation(line: 63, column: 15, scope: !107)
!146 = !DILocation(line: 63, column: 2, scope: !107)
!147 = !DILocation(line: 64, column: 15, scope: !107)
!148 = !DILocation(line: 64, column: 2, scope: !107)
!149 = !DILocation(line: 65, column: 15, scope: !107)
!150 = !DILocation(line: 65, column: 2, scope: !107)
!151 = !DILocation(line: 66, column: 15, scope: !107)
!152 = !DILocation(line: 66, column: 2, scope: !107)
!153 = !DILocation(line: 68, column: 2, scope: !107)
!154 = !DILocation(line: 0, scope: !107)
!155 = !DILocation(line: 70, column: 2, scope: !107)
