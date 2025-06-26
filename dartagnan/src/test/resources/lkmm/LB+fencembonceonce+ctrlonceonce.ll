; ModuleID = 'benchmarks/lkmm/LB+fencembonceonce+ctrlonceonce.c'
source_filename = "benchmarks/lkmm/LB+fencembonceonce+ctrlonceonce.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@r0 = dso_local global i32 0, align 4, !dbg !0
@x = dso_local global i32 0, align 4, !dbg !47
@y = dso_local global i32 0, align 4, !dbg !49
@r1 = dso_local global i32 0, align 4, !dbg !51
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !30
@.str = private unnamed_addr constant [34 x i8] c"LB+fencembonceonce+ctrlonceonce.c\00", align 1, !dbg !37
@.str.1 = private unnamed_addr constant [44 x i8] c"!(READ_ONCE(r0) == 1 && READ_ONCE(r1) == 1)\00", align 1, !dbg !42

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !61 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !65, !DIExpression(), !66)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !67
  %4 = trunc i64 %3 to i32, !dbg !67
  %5 = sext i32 %4 to i64, !dbg !67
  call void @__LKMM_store(ptr noundef @r0, i64 noundef 4, i64 noundef %5, i32 noundef 0), !dbg !67
  %6 = call i64 @__LKMM_load(ptr noundef @r0, i64 noundef 4, i32 noundef 0), !dbg !68
  %7 = trunc i64 %6 to i32, !dbg !68
  %8 = icmp ne i32 %7, 0, !dbg !68
  br i1 %8, label %9, label %10, !dbg !70

9:                                                ; preds = %1
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !71
  br label %10, !dbg !71

10:                                               ; preds = %9, %1
  ret ptr null, !dbg !72
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !73 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !74, !DIExpression(), !75)
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 0), !dbg !76
  %4 = trunc i64 %3 to i32, !dbg !76
  %5 = sext i32 %4 to i64, !dbg !76
  call void @__LKMM_store(ptr noundef @r1, i64 noundef 4, i64 noundef %5, i32 noundef 0), !dbg !76
  call void @__LKMM_fence(i32 noundef 3), !dbg !77
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !78
  ret ptr null, !dbg !79
}

declare void @__LKMM_fence(i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !80 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !83, !DIExpression(), !106)
    #dbg_declare(ptr %3, !107, !DIExpression(), !108)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !109
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !110
  %6 = load ptr, ptr %2, align 8, !dbg !111
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !112
  %8 = load ptr, ptr %3, align 8, !dbg !113
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !114
  %10 = call i64 @__LKMM_load(ptr noundef @r0, i64 noundef 4, i32 noundef 0), !dbg !115
  %11 = trunc i64 %10 to i32, !dbg !115
  %12 = icmp eq i32 %11, 1, !dbg !115
  br i1 %12, label %13, label %17, !dbg !115

13:                                               ; preds = %0
  %14 = call i64 @__LKMM_load(ptr noundef @r1, i64 noundef 4, i32 noundef 0), !dbg !115
  %15 = trunc i64 %14 to i32, !dbg !115
  %16 = icmp eq i32 %15, 1, !dbg !115
  br label %17

17:                                               ; preds = %13, %0
  %18 = phi i1 [ false, %0 ], [ %16, %13 ], !dbg !116
  %19 = xor i1 %18, true, !dbg !115
  %20 = xor i1 %19, true, !dbg !115
  %21 = zext i1 %20 to i32, !dbg !115
  %22 = sext i32 %21 to i64, !dbg !115
  %23 = icmp ne i64 %22, 0, !dbg !115
  br i1 %23, label %24, label %26, !dbg !115

24:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 37, ptr noundef @.str.1) #3, !dbg !115
  unreachable, !dbg !115

25:                                               ; No predecessors!
  br label %27, !dbg !115

26:                                               ; preds = %17
  br label %27, !dbg !115

27:                                               ; preds = %26, %25
  ret i32 0, !dbg !117
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
!llvm.module.flags = !{!53, !54, !55, !56, !57, !58, !59}
!llvm.ident = !{!60}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 9, type: !27, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !22, globals: !29, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/LB+fencembonceonce+ctrlonceonce.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "e04735b1ad6e052c08fd1ecbe5dcff13")
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
!29 = !{!30, !37, !42, !47, !49, !0, !51}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 37, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 40, elements: !35)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!34 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!35 = !{!36}
!36 = !DISubrange(count: 5)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 37, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 272, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 34)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 37, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 352, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 44)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !27, isLocal: false, isDefinition: true)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !27, isLocal: false, isDefinition: true)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !3, line: 9, type: !27, isLocal: false, isDefinition: true)
!53 = !{i32 7, !"Dwarf Version", i32 5}
!54 = !{i32 2, !"Debug Info Version", i32 3}
!55 = !{i32 1, !"wchar_size", i32 4}
!56 = !{i32 8, !"PIC Level", i32 2}
!57 = !{i32 7, !"PIE Level", i32 2}
!58 = !{i32 7, !"uwtable", i32 2}
!59 = !{i32 7, !"frame-pointer", i32 2}
!60 = !{!"Homebrew clang version 19.1.7"}
!61 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 11, type: !62, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!62 = !DISubroutineType(types: !63)
!63 = !{!28, !28}
!64 = !{}
!65 = !DILocalVariable(name: "unused", arg: 1, scope: !61, file: !3, line: 11, type: !28)
!66 = !DILocation(line: 11, column: 22, scope: !61)
!67 = !DILocation(line: 13, column: 2, scope: !61)
!68 = !DILocation(line: 14, column: 6, scope: !69)
!69 = distinct !DILexicalBlock(scope: !61, file: !3, line: 14, column: 6)
!70 = !DILocation(line: 14, column: 6, scope: !61)
!71 = !DILocation(line: 15, column: 3, scope: !69)
!72 = !DILocation(line: 16, column: 2, scope: !61)
!73 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 19, type: !62, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!74 = !DILocalVariable(name: "unused", arg: 1, scope: !73, file: !3, line: 19, type: !28)
!75 = !DILocation(line: 19, column: 22, scope: !73)
!76 = !DILocation(line: 21, column: 2, scope: !73)
!77 = !DILocation(line: 22, column: 2, scope: !73)
!78 = !DILocation(line: 23, column: 2, scope: !73)
!79 = !DILocation(line: 24, column: 2, scope: !73)
!80 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 27, type: !81, scopeLine: 28, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!81 = !DISubroutineType(types: !82)
!82 = !{!27}
!83 = !DILocalVariable(name: "t1", scope: !80, file: !3, line: 29, type: !84)
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !85, line: 31, baseType: !86)
!85 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !87, line: 118, baseType: !88)
!87 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!88 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !89, size: 64)
!89 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !87, line: 103, size: 65536, elements: !90)
!90 = !{!91, !92, !102}
!91 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !89, file: !87, line: 104, baseType: !26, size: 64)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !89, file: !87, line: 105, baseType: !93, size: 64, offset: 64)
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !87, line: 57, size: 192, elements: !95)
!95 = !{!96, !100, !101}
!96 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !94, file: !87, line: 58, baseType: !97, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!98 = !DISubroutineType(types: !99)
!99 = !{null, !28}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !94, file: !87, line: 59, baseType: !28, size: 64, offset: 64)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !94, file: !87, line: 60, baseType: !93, size: 64, offset: 128)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !89, file: !87, line: 106, baseType: !103, size: 65408, offset: 128)
!103 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 65408, elements: !104)
!104 = !{!105}
!105 = !DISubrange(count: 8176)
!106 = !DILocation(line: 29, column: 12, scope: !80)
!107 = !DILocalVariable(name: "t2", scope: !80, file: !3, line: 29, type: !84)
!108 = !DILocation(line: 29, column: 16, scope: !80)
!109 = !DILocation(line: 31, column: 2, scope: !80)
!110 = !DILocation(line: 32, column: 2, scope: !80)
!111 = !DILocation(line: 34, column: 15, scope: !80)
!112 = !DILocation(line: 34, column: 2, scope: !80)
!113 = !DILocation(line: 35, column: 15, scope: !80)
!114 = !DILocation(line: 35, column: 2, scope: !80)
!115 = !DILocation(line: 37, column: 2, scope: !80)
!116 = !DILocation(line: 0, scope: !80)
!117 = !DILocation(line: 39, column: 2, scope: !80)
