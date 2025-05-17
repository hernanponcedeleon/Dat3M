; ModuleID = 'benchmarks/lkmm/rcu+ar-link-short0.c'
source_filename = "benchmarks/lkmm/rcu+ar-link-short0.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@w = dso_local global [2 x i32] [i32 0, i32 1], align 4, !dbg !0
@x = dso_local global i32 0, align 4, !dbg !46
@y = dso_local global i32 0, align 4, !dbg !48
@s = dso_local global i32 0, align 4, !dbg !54
@r_s = dso_local global i32 0, align 4, !dbg !56
@r_w = dso_local global i32 0, align 4, !dbg !58
@r_y = dso_local global i32 0, align 4, !dbg !52
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@.str = private unnamed_addr constant [21 x i8] c"rcu+ar-link-short0.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [36 x i8] c"!(r_y == 0 && r_s == 1 && r_w == 1)\00", align 1, !dbg !41
@r_x = dso_local global i32 0, align 4, !dbg !50

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P0(ptr noundef %0) #0 !dbg !71 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !75, !DIExpression(), !76)
  call void @__LKMM_fence(i32 noundef 7), !dbg !77
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !78
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !79
  call void @__LKMM_fence(i32 noundef 8), !dbg !80
  ret ptr null, !dbg !81
}

declare void @__LKMM_fence(i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P1(ptr noundef %0) #0 !dbg !82 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !83, !DIExpression(), !84)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !85
  %4 = trunc i64 %3 to i32, !dbg !85
  %5 = icmp eq i32 %4, 1, !dbg !87
  br i1 %5, label %6, label %7, !dbg !88

6:                                                ; preds = %1
  call void @__LKMM_store(ptr noundef @s, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !89
  br label %7, !dbg !89

7:                                                ; preds = %6, %1
  ret ptr null, !dbg !90
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P2(ptr noundef %0) #0 !dbg !91 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !92, !DIExpression(), !93)
  %3 = call i64 @__LKMM_load(ptr noundef @s, i64 noundef 4, i32 noundef 1), !dbg !94
  %4 = trunc i64 %3 to i32, !dbg !94
  store i32 %4, ptr @r_s, align 4, !dbg !95
  %5 = load i32, ptr @r_s, align 4, !dbg !96
  %6 = sext i32 %5 to i64, !dbg !96
  %7 = getelementptr inbounds [2 x i32], ptr @w, i64 0, i64 %6, !dbg !96
  %8 = call i64 @__LKMM_load(ptr noundef %7, i64 noundef 4, i32 noundef 1), !dbg !96
  %9 = trunc i64 %8 to i32, !dbg !96
  store i32 %9, ptr @r_w, align 4, !dbg !97
  ret ptr null, !dbg !98
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @P3(ptr noundef %0) #0 !dbg !99 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !100, !DIExpression(), !101)
  call void @__LKMM_store(ptr noundef getelementptr inbounds ([2 x i32], ptr @w, i64 0, i64 1), i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !102
  call void @__LKMM_fence(i32 noundef 9), !dbg !103
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !104
  %4 = trunc i64 %3 to i32, !dbg !104
  store i32 %4, ptr @r_y, align 4, !dbg !105
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
  %18 = load i32, ptr @r_y, align 4, !dbg !153
  %19 = icmp eq i32 %18, 0, !dbg !153
  br i1 %19, label %20, label %26, !dbg !153

20:                                               ; preds = %0
  %21 = load i32, ptr @r_s, align 4, !dbg !153
  %22 = icmp eq i32 %21, 1, !dbg !153
  br i1 %22, label %23, label %26, !dbg !153

23:                                               ; preds = %20
  %24 = load i32, ptr @r_w, align 4, !dbg !153
  %25 = icmp eq i32 %24, 1, !dbg !153
  br label %26

26:                                               ; preds = %23, %20, %0
  %27 = phi i1 [ false, %20 ], [ false, %0 ], [ %25, %23 ], !dbg !154
  %28 = xor i1 %27, true, !dbg !153
  %29 = xor i1 %28, true, !dbg !153
  %30 = zext i1 %29 to i32, !dbg !153
  %31 = sext i32 %30 to i64, !dbg !153
  %32 = icmp ne i64 %31, 0, !dbg !153
  br i1 %32, label %33, label %35, !dbg !153

33:                                               ; preds = %26
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 82, ptr noundef @.str.1) #3, !dbg !153
  unreachable, !dbg !153

34:                                               ; No predecessors!
  br label %36, !dbg !153

35:                                               ; preds = %26
  br label %36, !dbg !153

36:                                               ; preds = %35, %34
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
!llvm.module.flags = !{!63, !64, !65, !66, !67, !68, !69}
!llvm.ident = !{!70}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "w", scope: !2, file: !3, line: 29, type: !60, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: None)
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
!67 = !{i32 7, !"PIE Level", i32 2}
!68 = !{i32 7, !"uwtable", i32 2}
!69 = !{i32 7, !"frame-pointer", i32 2}
!70 = !{!"Homebrew clang version 19.1.7"}
!71 = distinct !DISubprogram(name: "P0", scope: !3, file: !3, line: 34, type: !72, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!72 = !DISubroutineType(types: !73)
!73 = !{!26, !26}
!74 = !{}
!75 = !DILocalVariable(name: "unused", arg: 1, scope: !71, file: !3, line: 34, type: !26)
!76 = !DILocation(line: 34, column: 16, scope: !71)
!77 = !DILocation(line: 36, column: 2, scope: !71)
!78 = !DILocation(line: 37, column: 2, scope: !71)
!79 = !DILocation(line: 38, column: 2, scope: !71)
!80 = !DILocation(line: 39, column: 2, scope: !71)
!81 = !DILocation(line: 40, column: 2, scope: !71)
!82 = distinct !DISubprogram(name: "P1", scope: !3, file: !3, line: 43, type: !72, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!83 = !DILocalVariable(name: "unused", arg: 1, scope: !82, file: !3, line: 43, type: !26)
!84 = !DILocation(line: 43, column: 16, scope: !82)
!85 = !DILocation(line: 45, column: 6, scope: !86)
!86 = distinct !DILexicalBlock(scope: !82, file: !3, line: 45, column: 6)
!87 = !DILocation(line: 45, column: 19, scope: !86)
!88 = !DILocation(line: 45, column: 6, scope: !82)
!89 = !DILocation(line: 46, column: 3, scope: !86)
!90 = !DILocation(line: 47, column: 2, scope: !82)
!91 = distinct !DISubprogram(name: "P2", scope: !3, file: !3, line: 50, type: !72, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!92 = !DILocalVariable(name: "unused", arg: 1, scope: !91, file: !3, line: 50, type: !26)
!93 = !DILocation(line: 50, column: 16, scope: !91)
!94 = !DILocation(line: 52, column: 8, scope: !91)
!95 = !DILocation(line: 52, column: 6, scope: !91)
!96 = !DILocation(line: 53, column: 8, scope: !91)
!97 = !DILocation(line: 53, column: 6, scope: !91)
!98 = !DILocation(line: 54, column: 2, scope: !91)
!99 = distinct !DISubprogram(name: "P3", scope: !3, file: !3, line: 57, type: !72, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!100 = !DILocalVariable(name: "unused", arg: 1, scope: !99, file: !3, line: 57, type: !26)
!101 = !DILocation(line: 57, column: 16, scope: !99)
!102 = !DILocation(line: 59, column: 2, scope: !99)
!103 = !DILocation(line: 60, column: 2, scope: !99)
!104 = !DILocation(line: 61, column: 8, scope: !99)
!105 = !DILocation(line: 61, column: 6, scope: !99)
!106 = !DILocation(line: 62, column: 2, scope: !99)
!107 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 65, type: !108, scopeLine: 66, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!108 = !DISubroutineType(types: !109)
!109 = !{!27}
!110 = !DILocalVariable(name: "t0", scope: !107, file: !3, line: 70, type: !111)
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
!127 = !{null, !26}
!128 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !122, file: !114, line: 59, baseType: !26, size: 64, offset: 64)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !122, file: !114, line: 60, baseType: !121, size: 64, offset: 128)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !116, file: !114, line: 106, baseType: !131, size: 65408, offset: 128)
!131 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !132)
!132 = !{!133}
!133 = !DISubrange(count: 8176)
!134 = !DILocation(line: 70, column: 12, scope: !107)
!135 = !DILocalVariable(name: "t1", scope: !107, file: !3, line: 70, type: !111)
!136 = !DILocation(line: 70, column: 16, scope: !107)
!137 = !DILocalVariable(name: "t2", scope: !107, file: !3, line: 70, type: !111)
!138 = !DILocation(line: 70, column: 20, scope: !107)
!139 = !DILocalVariable(name: "t3", scope: !107, file: !3, line: 70, type: !111)
!140 = !DILocation(line: 70, column: 24, scope: !107)
!141 = !DILocation(line: 72, column: 2, scope: !107)
!142 = !DILocation(line: 73, column: 2, scope: !107)
!143 = !DILocation(line: 74, column: 2, scope: !107)
!144 = !DILocation(line: 75, column: 2, scope: !107)
!145 = !DILocation(line: 77, column: 15, scope: !107)
!146 = !DILocation(line: 77, column: 2, scope: !107)
!147 = !DILocation(line: 78, column: 15, scope: !107)
!148 = !DILocation(line: 78, column: 2, scope: !107)
!149 = !DILocation(line: 79, column: 15, scope: !107)
!150 = !DILocation(line: 79, column: 2, scope: !107)
!151 = !DILocation(line: 80, column: 15, scope: !107)
!152 = !DILocation(line: 80, column: 2, scope: !107)
!153 = !DILocation(line: 82, column: 2, scope: !107)
!154 = !DILocation(line: 0, scope: !107)
!155 = !DILocation(line: 84, column: 2, scope: !107)
