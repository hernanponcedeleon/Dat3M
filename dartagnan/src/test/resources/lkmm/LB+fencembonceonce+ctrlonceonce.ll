; ModuleID = 'benchmarks/lkmm/LB+fencembonceonce+ctrlonceonce.c'
source_filename = "benchmarks/lkmm/LB+fencembonceonce+ctrlonceonce.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@r0 = dso_local global i32 0, align 4, !dbg !0
@x = dso_local global i32 0, align 4, !dbg !48
@y = dso_local global i32 0, align 4, !dbg !50
@r1 = dso_local global i32 0, align 4, !dbg !52
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !31
@.str = private unnamed_addr constant [34 x i8] c"LB+fencembonceonce+ctrlonceonce.c\00", align 1, !dbg !38
@.str.1 = private unnamed_addr constant [44 x i8] c"!(READ_ONCE(r0) == 1 && READ_ONCE(r1) == 1)\00", align 1, !dbg !43

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !62 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !66, !DIExpression(), !67)
  %3 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !68
  %4 = trunc i64 %3 to i32, !dbg !68
  %5 = sext i32 %4 to i64, !dbg !68
  call void @__LKMM_store(ptr noundef @r0, i64 noundef 4, i64 noundef %5, i32 noundef 1), !dbg !68
  %6 = call i64 @__LKMM_load(ptr noundef @r0, i64 noundef 4, i32 noundef 1), !dbg !69
  %7 = trunc i64 %6 to i32, !dbg !69
  %8 = icmp ne i32 %7, 0, !dbg !69
  br i1 %8, label %9, label %10, !dbg !71

9:                                                ; preds = %1
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !72
  br label %10, !dbg !72

10:                                               ; preds = %9, %1
  ret ptr null, !dbg !73
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !74 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !75, !DIExpression(), !76)
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !77
  %4 = trunc i64 %3 to i32, !dbg !77
  %5 = sext i32 %4 to i64, !dbg !77
  call void @__LKMM_store(ptr noundef @r1, i64 noundef 4, i64 noundef %5, i32 noundef 1), !dbg !77
  call void @__LKMM_fence(i32 noundef 4), !dbg !78
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !79
  ret ptr null, !dbg !80
}

declare void @__LKMM_fence(i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !81 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !84, !DIExpression(), !107)
    #dbg_declare(ptr %3, !108, !DIExpression(), !109)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !110
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !111
  %6 = load ptr, ptr %2, align 8, !dbg !112
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !113
  %8 = load ptr, ptr %3, align 8, !dbg !114
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !115
  %10 = call i64 @__LKMM_load(ptr noundef @r0, i64 noundef 4, i32 noundef 1), !dbg !116
  %11 = trunc i64 %10 to i32, !dbg !116
  %12 = icmp eq i32 %11, 1, !dbg !116
  br i1 %12, label %13, label %17, !dbg !116

13:                                               ; preds = %0
  %14 = call i64 @__LKMM_load(ptr noundef @r1, i64 noundef 4, i32 noundef 1), !dbg !116
  %15 = trunc i64 %14 to i32, !dbg !116
  %16 = icmp eq i32 %15, 1, !dbg !116
  br label %17

17:                                               ; preds = %13, %0
  %18 = phi i1 [ false, %0 ], [ %16, %13 ], !dbg !117
  %19 = xor i1 %18, true, !dbg !116
  %20 = xor i1 %19, true, !dbg !116
  %21 = zext i1 %20 to i32, !dbg !116
  %22 = sext i32 %21 to i64, !dbg !116
  %23 = icmp ne i64 %22, 0, !dbg !116
  br i1 %23, label %24, label %26, !dbg !116

24:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 37, ptr noundef @.str.1) #3, !dbg !116
  unreachable, !dbg !116

25:                                               ; No predecessors!
  br label %27, !dbg !116

26:                                               ; preds = %17
  br label %27, !dbg !116

27:                                               ; preds = %26, %25
  ret i32 0, !dbg !118
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
!llvm.module.flags = !{!54, !55, !56, !57, !58, !59, !60}
!llvm.ident = !{!61}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !3, line: 9, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !30, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/LB+fencembonceonce+ctrlonceonce.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "e04735b1ad6e052c08fd1ecbe5dcff13")
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
!30 = !{!31, !38, !43, !48, !50, !0, !52}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(scope: null, file: !3, line: 37, type: !33, isLocal: true, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 40, elements: !36)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!35 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!36 = !{!37}
!37 = !DISubrange(count: 5)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 37, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 272, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 34)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 37, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 352, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 44)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !28, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !28, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !3, line: 9, type: !28, isLocal: false, isDefinition: true)
!54 = !{i32 7, !"Dwarf Version", i32 5}
!55 = !{i32 2, !"Debug Info Version", i32 3}
!56 = !{i32 1, !"wchar_size", i32 4}
!57 = !{i32 8, !"PIC Level", i32 2}
!58 = !{i32 7, !"PIE Level", i32 2}
!59 = !{i32 7, !"uwtable", i32 2}
!60 = !{i32 7, !"frame-pointer", i32 2}
!61 = !{!"Homebrew clang version 19.1.7"}
!62 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 11, type: !63, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!63 = !DISubroutineType(types: !64)
!64 = !{!29, !29}
!65 = !{}
!66 = !DILocalVariable(name: "unused", arg: 1, scope: !62, file: !3, line: 11, type: !29)
!67 = !DILocation(line: 11, column: 22, scope: !62)
!68 = !DILocation(line: 13, column: 2, scope: !62)
!69 = !DILocation(line: 14, column: 6, scope: !70)
!70 = distinct !DILexicalBlock(scope: !62, file: !3, line: 14, column: 6)
!71 = !DILocation(line: 14, column: 6, scope: !62)
!72 = !DILocation(line: 15, column: 3, scope: !70)
!73 = !DILocation(line: 16, column: 2, scope: !62)
!74 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 19, type: !63, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!75 = !DILocalVariable(name: "unused", arg: 1, scope: !74, file: !3, line: 19, type: !29)
!76 = !DILocation(line: 19, column: 22, scope: !74)
!77 = !DILocation(line: 21, column: 2, scope: !74)
!78 = !DILocation(line: 22, column: 2, scope: !74)
!79 = !DILocation(line: 23, column: 2, scope: !74)
!80 = !DILocation(line: 24, column: 2, scope: !74)
!81 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 27, type: !82, scopeLine: 28, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!82 = !DISubroutineType(types: !83)
!83 = !{!28}
!84 = !DILocalVariable(name: "t1", scope: !81, file: !3, line: 29, type: !85)
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !86, line: 31, baseType: !87)
!86 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !88, line: 118, baseType: !89)
!88 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !90, size: 64)
!90 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !88, line: 103, size: 65536, elements: !91)
!91 = !{!92, !93, !103}
!92 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !90, file: !88, line: 104, baseType: !27, size: 64)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !90, file: !88, line: 105, baseType: !94, size: 64, offset: 64)
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!95 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !88, line: 57, size: 192, elements: !96)
!96 = !{!97, !101, !102}
!97 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !95, file: !88, line: 58, baseType: !98, size: 64)
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!99 = !DISubroutineType(types: !100)
!100 = !{null, !29}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !95, file: !88, line: 59, baseType: !29, size: 64, offset: 64)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !95, file: !88, line: 60, baseType: !94, size: 64, offset: 128)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !90, file: !88, line: 106, baseType: !104, size: 65408, offset: 128)
!104 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 65408, elements: !105)
!105 = !{!106}
!106 = !DISubrange(count: 8176)
!107 = !DILocation(line: 29, column: 12, scope: !81)
!108 = !DILocalVariable(name: "t2", scope: !81, file: !3, line: 29, type: !85)
!109 = !DILocation(line: 29, column: 16, scope: !81)
!110 = !DILocation(line: 31, column: 2, scope: !81)
!111 = !DILocation(line: 32, column: 2, scope: !81)
!112 = !DILocation(line: 34, column: 15, scope: !81)
!113 = !DILocation(line: 34, column: 2, scope: !81)
!114 = !DILocation(line: 35, column: 15, scope: !81)
!115 = !DILocation(line: 35, column: 2, scope: !81)
!116 = !DILocation(line: 37, column: 2, scope: !81)
!117 = !DILocation(line: 0, scope: !81)
!118 = !DILocation(line: 39, column: 2, scope: !81)
