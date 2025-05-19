; ModuleID = 'benchmarks/lkmm/C-WWC+o-branch-o+o-branch-o.c'
source_filename = "benchmarks/lkmm/C-WWC+o-branch-o+o-branch-o.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@r1_0 = dso_local global i32 0, align 4, !dbg !54
@r3_0 = dso_local global i32 0, align 4, !dbg !56
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !48
@r2_1 = dso_local global i32 0, align 4, !dbg !58
@r4_1 = dso_local global i32 0, align 4, !dbg !60
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !31
@.str = private unnamed_addr constant [30 x i8] c"C-WWC+o-branch-o+o-branch-o.c\00", align 1, !dbg !38
@.str.1 = private unnamed_addr constant [50 x i8] c"!(r1_0 == 2 && r2_1 == 1 && atomic_read(&x) == 2)\00", align 1, !dbg !43

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !70 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !74, !DIExpression(), !75)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !76
  %4 = trunc i64 %3 to i32, !dbg !76
  store i32 %4, ptr @r1_0, align 4, !dbg !77
  %5 = load i32, ptr @r1_0, align 4, !dbg !78
  %6 = icmp ne i32 %5, 0, !dbg !79
  %7 = zext i1 %6 to i32, !dbg !79
  store i32 %7, ptr @r3_0, align 4, !dbg !80
  %8 = load i32, ptr @r3_0, align 4, !dbg !81
  %9 = icmp ne i32 %8, 0, !dbg !81
  br i1 %9, label %10, label %11, !dbg !83

10:                                               ; preds = %1
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !84
  br label %11, !dbg !86

11:                                               ; preds = %10, %1
  ret ptr null, !dbg !87
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !88 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !89, !DIExpression(), !90)
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !91
  %4 = trunc i64 %3 to i32, !dbg !91
  store i32 %4, ptr @r2_1, align 4, !dbg !92
  %5 = load i32, ptr @r2_1, align 4, !dbg !93
  %6 = icmp ne i32 %5, 0, !dbg !94
  %7 = zext i1 %6 to i32, !dbg !94
  store i32 %7, ptr @r4_1, align 4, !dbg !95
  %8 = load i32, ptr @r4_1, align 4, !dbg !96
  %9 = icmp ne i32 %8, 0, !dbg !96
  br i1 %9, label %10, label %11, !dbg !98

10:                                               ; preds = %1
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !99
  br label %11, !dbg !101

11:                                               ; preds = %10, %1
  ret ptr null, !dbg !102
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_3(ptr noundef %0) #0 !dbg !103 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !104, !DIExpression(), !105)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !106
  ret ptr null, !dbg !107
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !108 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !111, !DIExpression(), !134)
    #dbg_declare(ptr %3, !135, !DIExpression(), !136)
    #dbg_declare(ptr %4, !137, !DIExpression(), !138)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !139
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !140
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @thread_3, ptr noundef null), !dbg !141
  %8 = load ptr, ptr %2, align 8, !dbg !142
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !143
  %10 = load ptr, ptr %3, align 8, !dbg !144
  %11 = call i32 @_pthread_join(ptr noundef %10, ptr noundef null), !dbg !145
  %12 = load ptr, ptr %4, align 8, !dbg !146
  %13 = call i32 @_pthread_join(ptr noundef %12, ptr noundef null), !dbg !147
  %14 = load i32, ptr @r1_0, align 4, !dbg !148
  %15 = icmp eq i32 %14, 2, !dbg !148
  br i1 %15, label %16, label %23, !dbg !148

16:                                               ; preds = %0
  %17 = load i32, ptr @r2_1, align 4, !dbg !148
  %18 = icmp eq i32 %17, 1, !dbg !148
  br i1 %18, label %19, label %23, !dbg !148

19:                                               ; preds = %16
  %20 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !148
  %21 = trunc i64 %20 to i32, !dbg !148
  %22 = icmp eq i32 %21, 2, !dbg !148
  br label %23

23:                                               ; preds = %19, %16, %0
  %24 = phi i1 [ false, %16 ], [ false, %0 ], [ %22, %19 ], !dbg !149
  %25 = xor i1 %24, true, !dbg !148
  %26 = xor i1 %25, true, !dbg !148
  %27 = zext i1 %26 to i32, !dbg !148
  %28 = sext i32 %27 to i64, !dbg !148
  %29 = icmp ne i64 %28, 0, !dbg !148
  br i1 %29, label %30, label %32, !dbg !148

30:                                               ; preds = %23
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 53, ptr noundef @.str.1) #3, !dbg !148
  unreachable, !dbg !148

31:                                               ; No predecessors!
  br label %33, !dbg !148

32:                                               ; preds = %23
  br label %33, !dbg !148

33:                                               ; preds = %32, %31
  ret i32 0, !dbg !150
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
!llvm.module.flags = !{!62, !63, !64, !65, !66, !67, !68}
!llvm.ident = !{!69}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !50, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !30, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/C-WWC+o-branch-o+o-branch-o.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "16822ca6ae1b393a6d3981b1314a6e62")
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
!23 = !{!24, !25, !29}
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !26)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !27, line: 32, baseType: !28)
!27 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!28 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!30 = !{!31, !38, !43, !0, !48, !54, !56, !58, !60}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 53, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 40, elements: !36)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!35 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!36 = !{!37}
!37 = !DISubrange(count: 5)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 53, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 240, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 30)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 53, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 400, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 50)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !50, isLocal: false, isDefinition: true)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 109, baseType: !51)
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 107, size: 32, elements: !52)
!52 = !{!53}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !51, file: !6, line: 108, baseType: !24, size: 32)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "r1_0", scope: !2, file: !3, line: 9, type: !24, isLocal: false, isDefinition: true)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "r3_0", scope: !2, file: !3, line: 10, type: !24, isLocal: false, isDefinition: true)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "r2_1", scope: !2, file: !3, line: 12, type: !24, isLocal: false, isDefinition: true)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "r4_1", scope: !2, file: !3, line: 13, type: !24, isLocal: false, isDefinition: true)
!62 = !{i32 7, !"Dwarf Version", i32 5}
!63 = !{i32 2, !"Debug Info Version", i32 3}
!64 = !{i32 1, !"wchar_size", i32 4}
!65 = !{i32 8, !"PIC Level", i32 2}
!66 = !{i32 7, !"PIE Level", i32 2}
!67 = !{i32 7, !"uwtable", i32 2}
!68 = !{i32 7, !"frame-pointer", i32 2}
!69 = !{!"Homebrew clang version 19.1.7"}
!70 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 15, type: !71, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !73)
!71 = !DISubroutineType(types: !72)
!72 = !{!29, !29}
!73 = !{}
!74 = !DILocalVariable(name: "unused", arg: 1, scope: !70, file: !3, line: 15, type: !29)
!75 = !DILocation(line: 15, column: 22, scope: !70)
!76 = !DILocation(line: 17, column: 9, scope: !70)
!77 = !DILocation(line: 17, column: 7, scope: !70)
!78 = !DILocation(line: 18, column: 10, scope: !70)
!79 = !DILocation(line: 18, column: 15, scope: !70)
!80 = !DILocation(line: 18, column: 7, scope: !70)
!81 = !DILocation(line: 19, column: 6, scope: !82)
!82 = distinct !DILexicalBlock(scope: !70, file: !3, line: 19, column: 6)
!83 = !DILocation(line: 19, column: 6, scope: !70)
!84 = !DILocation(line: 20, column: 3, scope: !85)
!85 = distinct !DILexicalBlock(scope: !82, file: !3, line: 19, column: 12)
!86 = !DILocation(line: 21, column: 2, scope: !85)
!87 = !DILocation(line: 22, column: 5, scope: !70)
!88 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 25, type: !71, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !73)
!89 = !DILocalVariable(name: "unused", arg: 1, scope: !88, file: !3, line: 25, type: !29)
!90 = !DILocation(line: 25, column: 22, scope: !88)
!91 = !DILocation(line: 27, column: 9, scope: !88)
!92 = !DILocation(line: 27, column: 7, scope: !88)
!93 = !DILocation(line: 28, column: 10, scope: !88)
!94 = !DILocation(line: 28, column: 15, scope: !88)
!95 = !DILocation(line: 28, column: 7, scope: !88)
!96 = !DILocation(line: 29, column: 6, scope: !97)
!97 = distinct !DILexicalBlock(scope: !88, file: !3, line: 29, column: 6)
!98 = !DILocation(line: 29, column: 6, scope: !88)
!99 = !DILocation(line: 30, column: 3, scope: !100)
!100 = distinct !DILexicalBlock(scope: !97, file: !3, line: 29, column: 12)
!101 = !DILocation(line: 31, column: 2, scope: !100)
!102 = !DILocation(line: 32, column: 5, scope: !88)
!103 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 35, type: !71, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !73)
!104 = !DILocalVariable(name: "unused", arg: 1, scope: !103, file: !3, line: 35, type: !29)
!105 = !DILocation(line: 35, column: 22, scope: !103)
!106 = !DILocation(line: 37, column: 2, scope: !103)
!107 = !DILocation(line: 38, column: 5, scope: !103)
!108 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 41, type: !109, scopeLine: 42, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !73)
!109 = !DISubroutineType(types: !110)
!110 = !{!24}
!111 = !DILocalVariable(name: "t1", scope: !108, file: !3, line: 43, type: !112)
!112 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !113, line: 31, baseType: !114)
!113 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!114 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !115, line: 118, baseType: !116)
!115 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !115, line: 103, size: 65536, elements: !118)
!118 = !{!119, !120, !130}
!119 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !117, file: !115, line: 104, baseType: !28, size: 64)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !117, file: !115, line: 105, baseType: !121, size: 64, offset: 64)
!121 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !122, size: 64)
!122 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !115, line: 57, size: 192, elements: !123)
!123 = !{!124, !128, !129}
!124 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !122, file: !115, line: 58, baseType: !125, size: 64)
!125 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !126, size: 64)
!126 = !DISubroutineType(types: !127)
!127 = !{null, !29}
!128 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !122, file: !115, line: 59, baseType: !29, size: 64, offset: 64)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !122, file: !115, line: 60, baseType: !121, size: 64, offset: 128)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !117, file: !115, line: 106, baseType: !131, size: 65408, offset: 128)
!131 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 65408, elements: !132)
!132 = !{!133}
!133 = !DISubrange(count: 8176)
!134 = !DILocation(line: 43, column: 12, scope: !108)
!135 = !DILocalVariable(name: "t2", scope: !108, file: !3, line: 43, type: !112)
!136 = !DILocation(line: 43, column: 16, scope: !108)
!137 = !DILocalVariable(name: "t3", scope: !108, file: !3, line: 43, type: !112)
!138 = !DILocation(line: 43, column: 20, scope: !108)
!139 = !DILocation(line: 45, column: 2, scope: !108)
!140 = !DILocation(line: 46, column: 2, scope: !108)
!141 = !DILocation(line: 47, column: 2, scope: !108)
!142 = !DILocation(line: 49, column: 15, scope: !108)
!143 = !DILocation(line: 49, column: 2, scope: !108)
!144 = !DILocation(line: 50, column: 15, scope: !108)
!145 = !DILocation(line: 50, column: 2, scope: !108)
!146 = !DILocation(line: 51, column: 15, scope: !108)
!147 = !DILocation(line: 51, column: 2, scope: !108)
!148 = !DILocation(line: 53, column: 2, scope: !108)
!149 = !DILocation(line: 0, scope: !108)
!150 = !DILocation(line: 55, column: 2, scope: !108)
