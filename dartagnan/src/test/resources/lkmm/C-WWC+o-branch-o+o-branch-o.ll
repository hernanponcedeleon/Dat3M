; ModuleID = 'benchmarks/lkmm/C-WWC+o-branch-o+o-branch-o.c'
source_filename = "benchmarks/lkmm/C-WWC+o-branch-o+o-branch-o.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@r1_0 = dso_local global i32 0, align 4, !dbg !53
@r3_0 = dso_local global i32 0, align 4, !dbg !55
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !47
@r2_1 = dso_local global i32 0, align 4, !dbg !57
@r4_1 = dso_local global i32 0, align 4, !dbg !59
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !30
@.str = private unnamed_addr constant [30 x i8] c"C-WWC+o-branch-o+o-branch-o.c\00", align 1, !dbg !37
@.str.1 = private unnamed_addr constant [50 x i8] c"!(r1_0 == 2 && r2_1 == 1 && atomic_read(&x) == 2)\00", align 1, !dbg !42

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !69 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !73, !DIExpression(), !74)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !75
  %4 = trunc i64 %3 to i32, !dbg !75
  store i32 %4, ptr @r1_0, align 4, !dbg !76
  %5 = load i32, ptr @r1_0, align 4, !dbg !77
  %6 = icmp ne i32 %5, 0, !dbg !78
  %7 = zext i1 %6 to i32, !dbg !78
  store i32 %7, ptr @r3_0, align 4, !dbg !79
  %8 = load i32, ptr @r3_0, align 4, !dbg !80
  %9 = icmp ne i32 %8, 0, !dbg !80
  br i1 %9, label %10, label %11, !dbg !82

10:                                               ; preds = %1
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !83
  br label %11, !dbg !85

11:                                               ; preds = %10, %1
  ret ptr null, !dbg !86
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !87 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !88, !DIExpression(), !89)
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 0), !dbg !90
  %4 = trunc i64 %3 to i32, !dbg !90
  store i32 %4, ptr @r2_1, align 4, !dbg !91
  %5 = load i32, ptr @r2_1, align 4, !dbg !92
  %6 = icmp ne i32 %5, 0, !dbg !93
  %7 = zext i1 %6 to i32, !dbg !93
  store i32 %7, ptr @r4_1, align 4, !dbg !94
  %8 = load i32, ptr @r4_1, align 4, !dbg !95
  %9 = icmp ne i32 %8, 0, !dbg !95
  br i1 %9, label %10, label %11, !dbg !97

10:                                               ; preds = %1
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !98
  br label %11, !dbg !100

11:                                               ; preds = %10, %1
  ret ptr null, !dbg !101
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_3(ptr noundef %0) #0 !dbg !102 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !103, !DIExpression(), !104)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 0), !dbg !105
  ret ptr null, !dbg !106
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !107 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !110, !DIExpression(), !133)
    #dbg_declare(ptr %3, !134, !DIExpression(), !135)
    #dbg_declare(ptr %4, !136, !DIExpression(), !137)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !138
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !139
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @thread_3, ptr noundef null), !dbg !140
  %8 = load ptr, ptr %2, align 8, !dbg !141
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !142
  %10 = load ptr, ptr %3, align 8, !dbg !143
  %11 = call i32 @_pthread_join(ptr noundef %10, ptr noundef null), !dbg !144
  %12 = load ptr, ptr %4, align 8, !dbg !145
  %13 = call i32 @_pthread_join(ptr noundef %12, ptr noundef null), !dbg !146
  %14 = load i32, ptr @r1_0, align 4, !dbg !147
  %15 = icmp eq i32 %14, 2, !dbg !147
  br i1 %15, label %16, label %23, !dbg !147

16:                                               ; preds = %0
  %17 = load i32, ptr @r2_1, align 4, !dbg !147
  %18 = icmp eq i32 %17, 1, !dbg !147
  br i1 %18, label %19, label %23, !dbg !147

19:                                               ; preds = %16
  %20 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !147
  %21 = trunc i64 %20 to i32, !dbg !147
  %22 = icmp eq i32 %21, 2, !dbg !147
  br label %23

23:                                               ; preds = %19, %16, %0
  %24 = phi i1 [ false, %16 ], [ false, %0 ], [ %22, %19 ], !dbg !148
  %25 = xor i1 %24, true, !dbg !147
  %26 = xor i1 %25, true, !dbg !147
  %27 = zext i1 %26 to i32, !dbg !147
  %28 = sext i32 %27 to i64, !dbg !147
  %29 = icmp ne i64 %28, 0, !dbg !147
  br i1 %29, label %30, label %32, !dbg !147

30:                                               ; preds = %23
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 53, ptr noundef @.str.1) #3, !dbg !147
  unreachable, !dbg !147

31:                                               ; No predecessors!
  br label %33, !dbg !147

32:                                               ; preds = %23
  br label %33, !dbg !147

33:                                               ; preds = %32, %31
  ret i32 0, !dbg !149
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
!llvm.module.flags = !{!61, !62, !63, !64, !65, !66, !67}
!llvm.ident = !{!68}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !49, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !22, globals: !29, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/C-WWC+o-branch-o+o-branch-o.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "16822ca6ae1b393a6d3981b1314a6e62")
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
!22 = !{!23, !24, !28}
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 27, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !26, line: 32, baseType: !27)
!26 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!27 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!29 = !{!30, !37, !42, !0, !47, !53, !55, !57, !59}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 53, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 40, elements: !35)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!34 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!35 = !{!36}
!36 = !DISubrange(count: 5)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 53, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 240, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 30)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 53, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 400, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 50)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !49, isLocal: false, isDefinition: true)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 108, baseType: !50)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 106, size: 32, elements: !51)
!51 = !{!52}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !50, file: !6, line: 107, baseType: !23, size: 32)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "r1_0", scope: !2, file: !3, line: 9, type: !23, isLocal: false, isDefinition: true)
!55 = !DIGlobalVariableExpression(var: !56, expr: !DIExpression())
!56 = distinct !DIGlobalVariable(name: "r3_0", scope: !2, file: !3, line: 10, type: !23, isLocal: false, isDefinition: true)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "r2_1", scope: !2, file: !3, line: 12, type: !23, isLocal: false, isDefinition: true)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "r4_1", scope: !2, file: !3, line: 13, type: !23, isLocal: false, isDefinition: true)
!61 = !{i32 7, !"Dwarf Version", i32 5}
!62 = !{i32 2, !"Debug Info Version", i32 3}
!63 = !{i32 1, !"wchar_size", i32 4}
!64 = !{i32 8, !"PIC Level", i32 2}
!65 = !{i32 7, !"PIE Level", i32 2}
!66 = !{i32 7, !"uwtable", i32 2}
!67 = !{i32 7, !"frame-pointer", i32 2}
!68 = !{!"Homebrew clang version 19.1.7"}
!69 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 15, type: !70, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!70 = !DISubroutineType(types: !71)
!71 = !{!28, !28}
!72 = !{}
!73 = !DILocalVariable(name: "unused", arg: 1, scope: !69, file: !3, line: 15, type: !28)
!74 = !DILocation(line: 15, column: 22, scope: !69)
!75 = !DILocation(line: 17, column: 9, scope: !69)
!76 = !DILocation(line: 17, column: 7, scope: !69)
!77 = !DILocation(line: 18, column: 10, scope: !69)
!78 = !DILocation(line: 18, column: 15, scope: !69)
!79 = !DILocation(line: 18, column: 7, scope: !69)
!80 = !DILocation(line: 19, column: 6, scope: !81)
!81 = distinct !DILexicalBlock(scope: !69, file: !3, line: 19, column: 6)
!82 = !DILocation(line: 19, column: 6, scope: !69)
!83 = !DILocation(line: 20, column: 3, scope: !84)
!84 = distinct !DILexicalBlock(scope: !81, file: !3, line: 19, column: 12)
!85 = !DILocation(line: 21, column: 2, scope: !84)
!86 = !DILocation(line: 22, column: 5, scope: !69)
!87 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 25, type: !70, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!88 = !DILocalVariable(name: "unused", arg: 1, scope: !87, file: !3, line: 25, type: !28)
!89 = !DILocation(line: 25, column: 22, scope: !87)
!90 = !DILocation(line: 27, column: 9, scope: !87)
!91 = !DILocation(line: 27, column: 7, scope: !87)
!92 = !DILocation(line: 28, column: 10, scope: !87)
!93 = !DILocation(line: 28, column: 15, scope: !87)
!94 = !DILocation(line: 28, column: 7, scope: !87)
!95 = !DILocation(line: 29, column: 6, scope: !96)
!96 = distinct !DILexicalBlock(scope: !87, file: !3, line: 29, column: 6)
!97 = !DILocation(line: 29, column: 6, scope: !87)
!98 = !DILocation(line: 30, column: 3, scope: !99)
!99 = distinct !DILexicalBlock(scope: !96, file: !3, line: 29, column: 12)
!100 = !DILocation(line: 31, column: 2, scope: !99)
!101 = !DILocation(line: 32, column: 5, scope: !87)
!102 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 35, type: !70, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!103 = !DILocalVariable(name: "unused", arg: 1, scope: !102, file: !3, line: 35, type: !28)
!104 = !DILocation(line: 35, column: 22, scope: !102)
!105 = !DILocation(line: 37, column: 2, scope: !102)
!106 = !DILocation(line: 38, column: 5, scope: !102)
!107 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 41, type: !108, scopeLine: 42, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!108 = !DISubroutineType(types: !109)
!109 = !{!23}
!110 = !DILocalVariable(name: "t1", scope: !107, file: !3, line: 43, type: !111)
!111 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !112, line: 31, baseType: !113)
!112 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !114, line: 118, baseType: !115)
!114 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!115 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !116, size: 64)
!116 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !114, line: 103, size: 65536, elements: !117)
!117 = !{!118, !119, !129}
!118 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !116, file: !114, line: 104, baseType: !27, size: 64)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !116, file: !114, line: 105, baseType: !120, size: 64, offset: 64)
!120 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !121, size: 64)
!121 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !114, line: 57, size: 192, elements: !122)
!122 = !{!123, !127, !128}
!123 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !121, file: !114, line: 58, baseType: !124, size: 64)
!124 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !125, size: 64)
!125 = !DISubroutineType(types: !126)
!126 = !{null, !28}
!127 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !121, file: !114, line: 59, baseType: !28, size: 64, offset: 64)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !121, file: !114, line: 60, baseType: !120, size: 64, offset: 128)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !116, file: !114, line: 106, baseType: !130, size: 65408, offset: 128)
!130 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 65408, elements: !131)
!131 = !{!132}
!132 = !DISubrange(count: 8176)
!133 = !DILocation(line: 43, column: 12, scope: !107)
!134 = !DILocalVariable(name: "t2", scope: !107, file: !3, line: 43, type: !111)
!135 = !DILocation(line: 43, column: 16, scope: !107)
!136 = !DILocalVariable(name: "t3", scope: !107, file: !3, line: 43, type: !111)
!137 = !DILocation(line: 43, column: 20, scope: !107)
!138 = !DILocation(line: 45, column: 2, scope: !107)
!139 = !DILocation(line: 46, column: 2, scope: !107)
!140 = !DILocation(line: 47, column: 2, scope: !107)
!141 = !DILocation(line: 49, column: 15, scope: !107)
!142 = !DILocation(line: 49, column: 2, scope: !107)
!143 = !DILocation(line: 50, column: 15, scope: !107)
!144 = !DILocation(line: 50, column: 2, scope: !107)
!145 = !DILocation(line: 51, column: 15, scope: !107)
!146 = !DILocation(line: 51, column: 2, scope: !107)
!147 = !DILocation(line: 53, column: 2, scope: !107)
!148 = !DILocation(line: 0, scope: !107)
!149 = !DILocation(line: 55, column: 2, scope: !107)
