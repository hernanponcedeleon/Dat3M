; ModuleID = 'benchmarks/lkmm/rcu+ar-link-short0.c'
source_filename = "benchmarks/lkmm/rcu+ar-link-short0.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@w = dso_local global [2 x i32] [i32 0, i32 1], align 4, !dbg !0
@x = dso_local global i32 0, align 4, !dbg !48
@y = dso_local global i32 0, align 4, !dbg !50
@s = dso_local global i32 0, align 4, !dbg !56
@r_s = dso_local global i32 0, align 4, !dbg !58
@r_w = dso_local global i32 0, align 4, !dbg !60
@r_y = dso_local global i32 0, align 4, !dbg !54
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !31
@.str = private unnamed_addr constant [21 x i8] c"rcu+ar-link-short0.c\00", align 1, !dbg !38
@.str.1 = private unnamed_addr constant [36 x i8] c"!(r_y == 0 && r_s == 1 && r_w == 1)\00", align 1, !dbg !43
@r_x = dso_local global i32 0, align 4, !dbg !52

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P0(ptr noundef %0) #0 !dbg !73 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !77, !DIExpression(), !78)
  call void @__LKMM_fence(i32 noundef 7), !dbg !79
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !80
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !81
  call void @__LKMM_fence(i32 noundef 8), !dbg !82
  ret ptr null, !dbg !83
}

declare void @__LKMM_fence(i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P1(ptr noundef %0) #0 !dbg !84 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !85, !DIExpression(), !86)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !87
  %4 = trunc i64 %3 to i32, !dbg !87
  %5 = icmp eq i32 %4, 1, !dbg !89
  br i1 %5, label %6, label %7, !dbg !90

6:                                                ; preds = %1
  call void @__LKMM_store(ptr noundef @s, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !91
  br label %7, !dbg !91

7:                                                ; preds = %6, %1
  ret ptr null, !dbg !92
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P2(ptr noundef %0) #0 !dbg !93 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !94, !DIExpression(), !95)
  %3 = call i64 @__LKMM_load(ptr noundef @s, i64 noundef 4, i32 noundef 1), !dbg !96
  %4 = trunc i64 %3 to i32, !dbg !96
  store i32 %4, ptr @r_s, align 4, !dbg !97
  %5 = load i32, ptr @r_s, align 4, !dbg !98
  %6 = sext i32 %5 to i64, !dbg !98
  %7 = getelementptr inbounds [2 x i32], ptr @w, i64 0, i64 %6, !dbg !98
  %8 = call i64 @__LKMM_load(ptr noundef %7, i64 noundef 4, i32 noundef 1), !dbg !98
  %9 = trunc i64 %8 to i32, !dbg !98
  store i32 %9, ptr @r_w, align 4, !dbg !99
  ret ptr null, !dbg !100
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P3(ptr noundef %0) #0 !dbg !101 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !102, !DIExpression(), !103)
  call void @__LKMM_store(ptr noundef getelementptr inbounds ([2 x i32], ptr @w, i64 0, i64 1), i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !104
  call void @__LKMM_fence(i32 noundef 9), !dbg !105
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !106
  %4 = trunc i64 %3 to i32, !dbg !106
  store i32 %4, ptr @r_y, align 4, !dbg !107
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
  %18 = load i32, ptr @r_y, align 4, !dbg !154
  %19 = icmp eq i32 %18, 0, !dbg !154
  br i1 %19, label %20, label %26, !dbg !154

20:                                               ; preds = %0
  %21 = load i32, ptr @r_s, align 4, !dbg !154
  %22 = icmp eq i32 %21, 1, !dbg !154
  br i1 %22, label %23, label %26, !dbg !154

23:                                               ; preds = %20
  %24 = load i32, ptr @r_w, align 4, !dbg !154
  %25 = icmp eq i32 %24, 1, !dbg !154
  br label %26

26:                                               ; preds = %23, %20, %0
  %27 = phi i1 [ false, %20 ], [ false, %0 ], [ %25, %23 ], !dbg !155
  %28 = xor i1 %27, true, !dbg !154
  %29 = xor i1 %28, true, !dbg !154
  %30 = zext i1 %29 to i32, !dbg !154
  %31 = sext i32 %30 to i64, !dbg !154
  %32 = icmp ne i64 %31, 0, !dbg !154
  br i1 %32, label %33, label %35, !dbg !154

33:                                               ; preds = %26
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 82, ptr noundef @.str.1) #3, !dbg !154
  unreachable, !dbg !154

34:                                               ; No predecessors!
  br label %36, !dbg !154

35:                                               ; preds = %26
  br label %36, !dbg !154

36:                                               ; preds = %35, %34
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
!llvm.module.flags = !{!65, !66, !67, !68, !69, !70, !71}
!llvm.ident = !{!72}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "w", scope: !2, file: !3, line: 29, type: !62, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !30, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/rcu+ar-link-short0.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "75fba3f93246ceba8ebd1225e5ca1dff")
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
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !{!0, !31, !38, !43, !48, !50, !52, !54, !56, !58, !60}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 82, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 40, elements: !36)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!35 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!36 = !{!37}
!37 = !DISubrange(count: 5)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 82, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 168, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 21)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 82, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 288, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 36)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 21, type: !29, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 22, type: !29, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "r_x", scope: !2, file: !3, line: 24, type: !29, isLocal: false, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "r_y", scope: !2, file: !3, line: 25, type: !29, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 28, type: !29, isLocal: false, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "r_s", scope: !2, file: !3, line: 31, type: !29, isLocal: false, isDefinition: true)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "r_w", scope: !2, file: !3, line: 32, type: !29, isLocal: false, isDefinition: true)
!62 = !DICompositeType(tag: DW_TAG_array_type, baseType: !29, size: 64, elements: !63)
!63 = !{!64}
!64 = !DISubrange(count: 2)
!65 = !{i32 7, !"Dwarf Version", i32 5}
!66 = !{i32 2, !"Debug Info Version", i32 3}
!67 = !{i32 1, !"wchar_size", i32 4}
!68 = !{i32 8, !"PIC Level", i32 2}
!69 = !{i32 7, !"PIE Level", i32 2}
!70 = !{i32 7, !"uwtable", i32 2}
!71 = !{i32 7, !"frame-pointer", i32 2}
!72 = !{!"Homebrew clang version 19.1.7"}
!73 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 34, type: !74, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !76)
!74 = !DISubroutineType(types: !75)
!75 = !{!28, !28}
!76 = !{}
!77 = !DILocalVariable(name: "unused", arg: 1, scope: !73, file: !3, line: 34, type: !28)
!78 = !DILocation(line: 34, column: 16, scope: !73)
!79 = !DILocation(line: 36, column: 2, scope: !73)
!80 = !DILocation(line: 37, column: 2, scope: !73)
!81 = !DILocation(line: 38, column: 2, scope: !73)
!82 = !DILocation(line: 39, column: 2, scope: !73)
!83 = !DILocation(line: 40, column: 2, scope: !73)
!84 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 43, type: !74, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !76)
!85 = !DILocalVariable(name: "unused", arg: 1, scope: !84, file: !3, line: 43, type: !28)
!86 = !DILocation(line: 43, column: 16, scope: !84)
!87 = !DILocation(line: 45, column: 6, scope: !88)
!88 = distinct !DILexicalBlock(scope: !84, file: !3, line: 45, column: 6)
!89 = !DILocation(line: 45, column: 19, scope: !88)
!90 = !DILocation(line: 45, column: 6, scope: !84)
!91 = !DILocation(line: 46, column: 3, scope: !88)
!92 = !DILocation(line: 47, column: 2, scope: !84)
!93 = distinct !DISubprogram(name: "P2", scope: !3, file: !3, line: 50, type: !74, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !76)
!94 = !DILocalVariable(name: "unused", arg: 1, scope: !93, file: !3, line: 50, type: !28)
!95 = !DILocation(line: 50, column: 16, scope: !93)
!96 = !DILocation(line: 52, column: 8, scope: !93)
!97 = !DILocation(line: 52, column: 6, scope: !93)
!98 = !DILocation(line: 53, column: 8, scope: !93)
!99 = !DILocation(line: 53, column: 6, scope: !93)
!100 = !DILocation(line: 54, column: 2, scope: !93)
!101 = distinct !DISubprogram(name: "P3", scope: !3, file: !3, line: 57, type: !74, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !76)
!102 = !DILocalVariable(name: "unused", arg: 1, scope: !101, file: !3, line: 57, type: !28)
!103 = !DILocation(line: 57, column: 16, scope: !101)
!104 = !DILocation(line: 59, column: 2, scope: !101)
!105 = !DILocation(line: 60, column: 2, scope: !101)
!106 = !DILocation(line: 61, column: 8, scope: !101)
!107 = !DILocation(line: 61, column: 6, scope: !101)
!108 = !DILocation(line: 62, column: 2, scope: !101)
!109 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 65, type: !110, scopeLine: 66, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !76)
!110 = !DISubroutineType(types: !111)
!111 = !{!29}
!112 = !DILocalVariable(name: "t0", scope: !109, file: !3, line: 70, type: !113)
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
!128 = !{null, !28}
!129 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !123, file: !116, line: 59, baseType: !28, size: 64, offset: 64)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !123, file: !116, line: 60, baseType: !122, size: 64, offset: 128)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !118, file: !116, line: 106, baseType: !132, size: 65408, offset: 128)
!132 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 65408, elements: !133)
!133 = !{!134}
!134 = !DISubrange(count: 8176)
!135 = !DILocation(line: 70, column: 12, scope: !109)
!136 = !DILocalVariable(name: "t1", scope: !109, file: !3, line: 70, type: !113)
!137 = !DILocation(line: 70, column: 16, scope: !109)
!138 = !DILocalVariable(name: "t2", scope: !109, file: !3, line: 70, type: !113)
!139 = !DILocation(line: 70, column: 20, scope: !109)
!140 = !DILocalVariable(name: "t3", scope: !109, file: !3, line: 70, type: !113)
!141 = !DILocation(line: 70, column: 24, scope: !109)
!142 = !DILocation(line: 72, column: 2, scope: !109)
!143 = !DILocation(line: 73, column: 2, scope: !109)
!144 = !DILocation(line: 74, column: 2, scope: !109)
!145 = !DILocation(line: 75, column: 2, scope: !109)
!146 = !DILocation(line: 77, column: 15, scope: !109)
!147 = !DILocation(line: 77, column: 2, scope: !109)
!148 = !DILocation(line: 78, column: 15, scope: !109)
!149 = !DILocation(line: 78, column: 2, scope: !109)
!150 = !DILocation(line: 79, column: 15, scope: !109)
!151 = !DILocation(line: 79, column: 2, scope: !109)
!152 = !DILocation(line: 80, column: 15, scope: !109)
!153 = !DILocation(line: 80, column: 2, scope: !109)
!154 = !DILocation(line: 82, column: 2, scope: !109)
!155 = !DILocation(line: 0, scope: !109)
!156 = !DILocation(line: 84, column: 2, scope: !109)
