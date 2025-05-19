; ModuleID = 'benchmarks/lkmm/qspinlock-liveness.c'
source_filename = "benchmarks/lkmm/qspinlock-liveness.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !37
@z = dso_local global i32 0, align 4, !dbg !39

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !53 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !57, !DIExpression(), !58)
    #dbg_declare(ptr %3, !59, !DIExpression(), !60)
  %4 = call i64 @__LKMM_atomic_fetch_op(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 4, i32 noundef 0), !dbg !61
  %5 = trunc i64 %4 to i32, !dbg !61
  store i32 %5, ptr %3, align 4, !dbg !60
  ret ptr null, !dbg !62
}

declare i64 @__LKMM_atomic_fetch_op(ptr noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !63 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !64, !DIExpression(), !65)
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !66
    #dbg_declare(ptr %3, !67, !DIExpression(), !68)
  %5 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !69
  %6 = trunc i64 %5 to i32, !dbg !69
  store i32 %6, ptr %3, align 4, !dbg !68
  call void @__LKMM_fence(i32 noundef 5), !dbg !70
    #dbg_declare(ptr %4, !71, !DIExpression(), !72)
  %7 = load i32, ptr %3, align 4, !dbg !73
  %8 = sext i32 %7 to i64, !dbg !73
  %9 = call i64 @__LKMM_cmpxchg(ptr noundef @x, i64 noundef 4, i64 noundef %8, i64 noundef 42, i32 noundef 0, i32 noundef 0), !dbg !73
  %10 = trunc i64 %9 to i32, !dbg !73
  store i32 %10, ptr %4, align 4, !dbg !72
  call void @__LKMM_store(ptr noundef @z, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !74
  ret ptr null, !dbg !75
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

declare i64 @__LKMM_cmpxchg(ptr noundef, i64 noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_3(ptr noundef %0) #0 !dbg !76 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !77, !DIExpression(), !78)
  call void @__LKMM_store(ptr noundef @z, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !79
    #dbg_declare(ptr %3, !80, !DIExpression(), !81)
  %5 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !82
  %6 = trunc i64 %5 to i32, !dbg !82
  store i32 %6, ptr %3, align 4, !dbg !81
  call void @__LKMM_fence(i32 noundef 5), !dbg !83
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 0, i32 noundef 1), !dbg !84
    #dbg_declare(ptr %4, !85, !DIExpression(), !86)
  %7 = load i32, ptr %3, align 4, !dbg !87
  %8 = sext i32 %7 to i64, !dbg !87
  %9 = call i64 @__LKMM_cmpxchg(ptr noundef @x, i64 noundef 4, i64 noundef %8, i64 noundef 24, i32 noundef 0, i32 noundef 0), !dbg !87
  %10 = trunc i64 %9 to i32, !dbg !87
  store i32 %10, ptr %4, align 4, !dbg !86
  br label %11, !dbg !88

11:                                               ; preds = %21, %1
  %12 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !89
  %13 = trunc i64 %12 to i32, !dbg !89
  %14 = icmp eq i32 %13, 1, !dbg !90
  br i1 %14, label %15, label %19, !dbg !91

15:                                               ; preds = %11
  %16 = call i64 @__LKMM_load(ptr noundef @z, i64 noundef 4, i32 noundef 1), !dbg !92
  %17 = trunc i64 %16 to i32, !dbg !92
  %18 = icmp eq i32 %17, 2, !dbg !93
  br label %19

19:                                               ; preds = %15, %11
  %20 = phi i1 [ false, %11 ], [ %18, %15 ], !dbg !94
  br i1 %20, label %21, label %22, !dbg !88

21:                                               ; preds = %19
  br label %11, !dbg !88, !llvm.loop !95

22:                                               ; preds = %19
  ret ptr null, !dbg !98
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !99 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !102, !DIExpression(), !126)
    #dbg_declare(ptr %3, !127, !DIExpression(), !128)
    #dbg_declare(ptr %4, !129, !DIExpression(), !130)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !131
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !132
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @thread_3, ptr noundef null), !dbg !133
  ret i32 0, !dbg !134
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!45, !46, !47, !48, !49, !50, !51}
!llvm.ident = !{!52}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !41, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !36, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/qspinlock-liveness.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "62cffcfdbbfe2e2b84cb01226603616c")
!4 = !{!5, !23}
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
!23 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_operation", file: !6, line: 20, baseType: !7, size: 32, elements: !24)
!24 = !{!25, !26, !27, !28}
!25 = !DIEnumerator(name: "__LKMM_op_add", value: 0)
!26 = !DIEnumerator(name: "__LKMM_op_sub", value: 1)
!27 = !DIEnumerator(name: "__LKMM_op_and", value: 2)
!28 = !DIEnumerator(name: "__LKMM_op_or", value: 3)
!29 = !{!30, !31, !35}
!30 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !32)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !33, line: 32, baseType: !34)
!33 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!34 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!36 = !{!37, !39, !0}
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 6, type: !30, isLocal: false, isDefinition: true)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !3, line: 6, type: !30, isLocal: false, isDefinition: true)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 109, baseType: !42)
!42 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 107, size: 32, elements: !43)
!43 = !{!44}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !42, file: !6, line: 108, baseType: !30, size: 32)
!45 = !{i32 7, !"Dwarf Version", i32 5}
!46 = !{i32 2, !"Debug Info Version", i32 3}
!47 = !{i32 1, !"wchar_size", i32 4}
!48 = !{i32 8, !"PIC Level", i32 2}
!49 = !{i32 7, !"PIE Level", i32 2}
!50 = !{i32 7, !"uwtable", i32 2}
!51 = !{i32 7, !"frame-pointer", i32 2}
!52 = !{!"Homebrew clang version 19.1.7"}
!53 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !54, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!54 = !DISubroutineType(types: !55)
!55 = !{!35, !35}
!56 = !{}
!57 = !DILocalVariable(name: "unused", arg: 1, scope: !53, file: !3, line: 9, type: !35)
!58 = !DILocation(line: 9, column: 22, scope: !53)
!59 = !DILocalVariable(name: "r0", scope: !53, file: !3, line: 12, type: !30)
!60 = !DILocation(line: 12, column: 9, scope: !53)
!61 = !DILocation(line: 12, column: 14, scope: !53)
!62 = !DILocation(line: 13, column: 5, scope: !53)
!63 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 16, type: !54, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!64 = !DILocalVariable(name: "unused", arg: 1, scope: !63, file: !3, line: 16, type: !35)
!65 = !DILocation(line: 16, column: 22, scope: !63)
!66 = !DILocation(line: 19, column: 5, scope: !63)
!67 = !DILocalVariable(name: "r0", scope: !63, file: !3, line: 21, type: !30)
!68 = !DILocation(line: 21, column: 9, scope: !63)
!69 = !DILocation(line: 21, column: 14, scope: !63)
!70 = !DILocation(line: 23, column: 5, scope: !63)
!71 = !DILocalVariable(name: "r1", scope: !63, file: !3, line: 25, type: !30)
!72 = !DILocation(line: 25, column: 9, scope: !63)
!73 = !DILocation(line: 25, column: 14, scope: !63)
!74 = !DILocation(line: 27, column: 5, scope: !63)
!75 = !DILocation(line: 28, column: 5, scope: !63)
!76 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 31, type: !54, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!77 = !DILocalVariable(name: "unused", arg: 1, scope: !76, file: !3, line: 31, type: !35)
!78 = !DILocation(line: 31, column: 22, scope: !76)
!79 = !DILocation(line: 34, column: 5, scope: !76)
!80 = !DILocalVariable(name: "r0", scope: !76, file: !3, line: 36, type: !30)
!81 = !DILocation(line: 36, column: 9, scope: !76)
!82 = !DILocation(line: 36, column: 14, scope: !76)
!83 = !DILocation(line: 38, column: 5, scope: !76)
!84 = !DILocation(line: 40, column: 5, scope: !76)
!85 = !DILocalVariable(name: "r1", scope: !76, file: !3, line: 42, type: !30)
!86 = !DILocation(line: 42, column: 9, scope: !76)
!87 = !DILocation(line: 42, column: 14, scope: !76)
!88 = !DILocation(line: 44, column: 5, scope: !76)
!89 = !DILocation(line: 44, column: 11, scope: !76)
!90 = !DILocation(line: 44, column: 24, scope: !76)
!91 = !DILocation(line: 44, column: 29, scope: !76)
!92 = !DILocation(line: 44, column: 33, scope: !76)
!93 = !DILocation(line: 44, column: 46, scope: !76)
!94 = !DILocation(line: 0, scope: !76)
!95 = distinct !{!95, !88, !96, !97}
!96 = !DILocation(line: 44, column: 54, scope: !76)
!97 = !{!"llvm.loop.mustprogress"}
!98 = !DILocation(line: 45, column: 5, scope: !76)
!99 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 48, type: !100, scopeLine: 49, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!100 = !DISubroutineType(types: !101)
!101 = !{!30}
!102 = !DILocalVariable(name: "t1", scope: !99, file: !3, line: 50, type: !103)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !104, line: 31, baseType: !105)
!104 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !106, line: 118, baseType: !107)
!106 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !108, size: 64)
!108 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !106, line: 103, size: 65536, elements: !109)
!109 = !{!110, !111, !121}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !108, file: !106, line: 104, baseType: !34, size: 64)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !108, file: !106, line: 105, baseType: !112, size: 64, offset: 64)
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!113 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !106, line: 57, size: 192, elements: !114)
!114 = !{!115, !119, !120}
!115 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !113, file: !106, line: 58, baseType: !116, size: 64)
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = !DISubroutineType(types: !118)
!118 = !{null, !35}
!119 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !113, file: !106, line: 59, baseType: !35, size: 64, offset: 64)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !113, file: !106, line: 60, baseType: !112, size: 64, offset: 128)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !108, file: !106, line: 106, baseType: !122, size: 65408, offset: 128)
!122 = !DICompositeType(tag: DW_TAG_array_type, baseType: !123, size: 65408, elements: !124)
!123 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!124 = !{!125}
!125 = !DISubrange(count: 8176)
!126 = !DILocation(line: 50, column: 12, scope: !99)
!127 = !DILocalVariable(name: "t2", scope: !99, file: !3, line: 50, type: !103)
!128 = !DILocation(line: 50, column: 16, scope: !99)
!129 = !DILocalVariable(name: "t3", scope: !99, file: !3, line: 50, type: !103)
!130 = !DILocation(line: 50, column: 20, scope: !99)
!131 = !DILocation(line: 52, column: 2, scope: !99)
!132 = !DILocation(line: 53, column: 2, scope: !99)
!133 = !DILocation(line: 54, column: 2, scope: !99)
!134 = !DILocation(line: 56, column: 2, scope: !99)
