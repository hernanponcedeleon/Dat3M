; ModuleID = 'benchmarks/lkmm/CoRR+poonce+Once.c'
source_filename = "benchmarks/lkmm/CoRR+poonce+Once.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@r0 = dso_local global i32 0, align 4, !dbg !48
@r1 = dso_local global i32 0, align 4, !dbg !50
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !31
@.str = private unnamed_addr constant [19 x i8] c"CoRR+poonce+Once.c\00", align 1, !dbg !38
@.str.1 = private unnamed_addr constant [22 x i8] c"!(r0 == 1 && r1 == 0)\00", align 1, !dbg !43

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !60 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !64, !DIExpression(), !65)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !66
  ret ptr null, !dbg !67
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !68 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !69, !DIExpression(), !70)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !71
  %4 = trunc i64 %3 to i32, !dbg !71
  store i32 %4, ptr @r0, align 4, !dbg !72
  %5 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !73
  %6 = trunc i64 %5 to i32, !dbg !73
  store i32 %6, ptr @r1, align 4, !dbg !74
  ret ptr null, !dbg !75
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !76 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !79, !DIExpression(), !102)
    #dbg_declare(ptr %3, !103, !DIExpression(), !104)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !105
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !106
  %6 = load ptr, ptr %2, align 8, !dbg !107
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !108
  %8 = load ptr, ptr %3, align 8, !dbg !109
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !110
  %10 = load i32, ptr @r0, align 4, !dbg !111
  %11 = icmp eq i32 %10, 1, !dbg !111
  br i1 %11, label %12, label %15, !dbg !111

12:                                               ; preds = %0
  %13 = load i32, ptr @r1, align 4, !dbg !111
  %14 = icmp eq i32 %13, 0, !dbg !111
  br label %15

15:                                               ; preds = %12, %0
  %16 = phi i1 [ false, %0 ], [ %14, %12 ], !dbg !112
  %17 = xor i1 %16, true, !dbg !111
  %18 = xor i1 %17, true, !dbg !111
  %19 = zext i1 %18 to i32, !dbg !111
  %20 = sext i32 %19 to i64, !dbg !111
  %21 = icmp ne i64 %20, 0, !dbg !111
  br i1 %21, label %22, label %24, !dbg !111

22:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 33, ptr noundef @.str.1) #3, !dbg !111
  unreachable, !dbg !111

23:                                               ; No predecessors!
  br label %25, !dbg !111

24:                                               ; preds = %15
  br label %25, !dbg !111

25:                                               ; preds = %24, %23
  ret i32 0, !dbg !113
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
!llvm.module.flags = !{!52, !53, !54, !55, !56, !57, !58}
!llvm.ident = !{!59}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !30, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/CoRR+poonce+Once.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "973bb56baa7a0c404651e434a54de408")
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
!30 = !{!31, !38, !43, !0, !48, !50}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 33, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 40, elements: !36)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!35 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!36 = !{!37}
!37 = !DISubrange(count: 5)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 33, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 152, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 19)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 33, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 176, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 22)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 8, type: !29, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !3, line: 8, type: !29, isLocal: false, isDefinition: true)
!52 = !{i32 7, !"Dwarf Version", i32 5}
!53 = !{i32 2, !"Debug Info Version", i32 3}
!54 = !{i32 1, !"wchar_size", i32 4}
!55 = !{i32 8, !"PIC Level", i32 2}
!56 = !{i32 7, !"PIE Level", i32 2}
!57 = !{i32 7, !"uwtable", i32 2}
!58 = !{i32 7, !"frame-pointer", i32 2}
!59 = !{!"Homebrew clang version 19.1.7"}
!60 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 10, type: !61, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!61 = !DISubroutineType(types: !62)
!62 = !{!28, !28}
!63 = !{}
!64 = !DILocalVariable(name: "unused", arg: 1, scope: !60, file: !3, line: 10, type: !28)
!65 = !DILocation(line: 10, column: 22, scope: !60)
!66 = !DILocation(line: 12, column: 2, scope: !60)
!67 = !DILocation(line: 13, column: 2, scope: !60)
!68 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 16, type: !61, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!69 = !DILocalVariable(name: "unused", arg: 1, scope: !68, file: !3, line: 16, type: !28)
!70 = !DILocation(line: 16, column: 22, scope: !68)
!71 = !DILocation(line: 18, column: 7, scope: !68)
!72 = !DILocation(line: 18, column: 5, scope: !68)
!73 = !DILocation(line: 19, column: 7, scope: !68)
!74 = !DILocation(line: 19, column: 5, scope: !68)
!75 = !DILocation(line: 20, column: 2, scope: !68)
!76 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 23, type: !77, scopeLine: 24, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!77 = !DISubroutineType(types: !78)
!78 = !{!29}
!79 = !DILocalVariable(name: "t1", scope: !76, file: !3, line: 25, type: !80)
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !81, line: 31, baseType: !82)
!81 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !83, line: 118, baseType: !84)
!83 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !85, size: 64)
!85 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !83, line: 103, size: 65536, elements: !86)
!86 = !{!87, !88, !98}
!87 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !85, file: !83, line: 104, baseType: !27, size: 64)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !85, file: !83, line: 105, baseType: !89, size: 64, offset: 64)
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !90, size: 64)
!90 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !83, line: 57, size: 192, elements: !91)
!91 = !{!92, !96, !97}
!92 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !90, file: !83, line: 58, baseType: !93, size: 64)
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = !DISubroutineType(types: !95)
!95 = !{null, !28}
!96 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !90, file: !83, line: 59, baseType: !28, size: 64, offset: 64)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !90, file: !83, line: 60, baseType: !89, size: 64, offset: 128)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !85, file: !83, line: 106, baseType: !99, size: 65408, offset: 128)
!99 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 65408, elements: !100)
!100 = !{!101}
!101 = !DISubrange(count: 8176)
!102 = !DILocation(line: 25, column: 12, scope: !76)
!103 = !DILocalVariable(name: "t2", scope: !76, file: !3, line: 25, type: !80)
!104 = !DILocation(line: 25, column: 16, scope: !76)
!105 = !DILocation(line: 27, column: 2, scope: !76)
!106 = !DILocation(line: 28, column: 2, scope: !76)
!107 = !DILocation(line: 30, column: 15, scope: !76)
!108 = !DILocation(line: 30, column: 2, scope: !76)
!109 = !DILocation(line: 31, column: 15, scope: !76)
!110 = !DILocation(line: 31, column: 2, scope: !76)
!111 = !DILocation(line: 33, column: 2, scope: !76)
!112 = !DILocation(line: 0, scope: !76)
!113 = !DILocation(line: 35, column: 2, scope: !76)
