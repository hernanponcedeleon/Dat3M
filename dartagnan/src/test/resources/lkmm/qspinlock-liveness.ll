; ModuleID = 'benchmarks/lkmm/qspinlock-liveness.c'
source_filename = "benchmarks/lkmm/qspinlock-liveness.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !35
@z = dso_local global i32 0, align 4, !dbg !37

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !51 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !55, !DIExpression(), !56)
    #dbg_declare(ptr %3, !57, !DIExpression(), !58)
  %4 = call i64 @__LKMM_atomic_fetch_op(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 4, i32 noundef 0), !dbg !59
  %5 = trunc i64 %4 to i32, !dbg !59
  store i32 %5, ptr %3, align 4, !dbg !58
  ret ptr null, !dbg !60
}

declare i64 @__LKMM_atomic_fetch_op(ptr noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !61 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !62, !DIExpression(), !63)
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !64
    #dbg_declare(ptr %3, !65, !DIExpression(), !66)
  %5 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !67
  %6 = trunc i64 %5 to i32, !dbg !67
  store i32 %6, ptr %3, align 4, !dbg !66
  call void @__LKMM_fence(i32 noundef 5), !dbg !68
    #dbg_declare(ptr %4, !69, !DIExpression(), !70)
  %7 = load i32, ptr %3, align 4, !dbg !71
  %8 = sext i32 %7 to i64, !dbg !71
  %9 = call i64 @__LKMM_cmpxchg(ptr noundef @x, i64 noundef 4, i64 noundef %8, i64 noundef 42, i32 noundef 0, i32 noundef 0), !dbg !71
  %10 = trunc i64 %9 to i32, !dbg !71
  store i32 %10, ptr %4, align 4, !dbg !70
  call void @__LKMM_store(ptr noundef @z, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !72
  ret ptr null, !dbg !73
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

declare i64 @__LKMM_cmpxchg(ptr noundef, i64 noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_3(ptr noundef %0) #0 !dbg !74 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !75, !DIExpression(), !76)
  call void @__LKMM_store(ptr noundef @z, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !77
    #dbg_declare(ptr %3, !78, !DIExpression(), !79)
  %5 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !80
  %6 = trunc i64 %5 to i32, !dbg !80
  store i32 %6, ptr %3, align 4, !dbg !79
  call void @__LKMM_fence(i32 noundef 5), !dbg !81
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 0, i32 noundef 1), !dbg !82
    #dbg_declare(ptr %4, !83, !DIExpression(), !84)
  %7 = load i32, ptr %3, align 4, !dbg !85
  %8 = sext i32 %7 to i64, !dbg !85
  %9 = call i64 @__LKMM_cmpxchg(ptr noundef @x, i64 noundef 4, i64 noundef %8, i64 noundef 24, i32 noundef 0, i32 noundef 0), !dbg !85
  %10 = trunc i64 %9 to i32, !dbg !85
  store i32 %10, ptr %4, align 4, !dbg !84
  br label %11, !dbg !86

11:                                               ; preds = %21, %1
  %12 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !87
  %13 = trunc i64 %12 to i32, !dbg !87
  %14 = icmp eq i32 %13, 1, !dbg !88
  br i1 %14, label %15, label %19, !dbg !89

15:                                               ; preds = %11
  %16 = call i64 @__LKMM_load(ptr noundef @z, i64 noundef 4, i32 noundef 1), !dbg !90
  %17 = trunc i64 %16 to i32, !dbg !90
  %18 = icmp eq i32 %17, 2, !dbg !91
  br label %19

19:                                               ; preds = %15, %11
  %20 = phi i1 [ false, %11 ], [ %18, %15 ], !dbg !92
  br i1 %20, label %21, label %22, !dbg !86

21:                                               ; preds = %19
  br label %11, !dbg !86, !llvm.loop !93

22:                                               ; preds = %19
  ret ptr null, !dbg !96
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !97 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !100, !DIExpression(), !125)
    #dbg_declare(ptr %3, !126, !DIExpression(), !127)
    #dbg_declare(ptr %4, !128, !DIExpression(), !129)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !130
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !131
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @thread_3, ptr noundef null), !dbg !132
  ret i32 0, !dbg !133
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!43, !44, !45, !46, !47, !48, !49}
!llvm.ident = !{!50}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !39, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !34, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/qspinlock-liveness.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "62cffcfdbbfe2e2b84cb01226603616c")
!4 = !{!5, !23}
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
!23 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_operation", file: !6, line: 20, baseType: !7, size: 32, elements: !24)
!24 = !{!25, !26, !27, !28}
!25 = !DIEnumerator(name: "__LKMM_op_add", value: 0)
!26 = !DIEnumerator(name: "__LKMM_op_sub", value: 1)
!27 = !DIEnumerator(name: "__LKMM_op_and", value: 2)
!28 = !DIEnumerator(name: "__LKMM_op_or", value: 3)
!29 = !{!30, !31, !33}
!30 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !32)
!32 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!34 = !{!35, !37, !0}
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 6, type: !30, isLocal: false, isDefinition: true)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !3, line: 6, type: !30, isLocal: false, isDefinition: true)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 109, baseType: !40)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 107, size: 32, elements: !41)
!41 = !{!42}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !40, file: !6, line: 108, baseType: !30, size: 32)
!43 = !{i32 7, !"Dwarf Version", i32 5}
!44 = !{i32 2, !"Debug Info Version", i32 3}
!45 = !{i32 1, !"wchar_size", i32 4}
!46 = !{i32 8, !"PIC Level", i32 2}
!47 = !{i32 7, !"PIE Level", i32 2}
!48 = !{i32 7, !"uwtable", i32 2}
!49 = !{i32 7, !"frame-pointer", i32 2}
!50 = !{!"Homebrew clang version 19.1.7"}
!51 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !52, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!52 = !DISubroutineType(types: !53)
!53 = !{!33, !33}
!54 = !{}
!55 = !DILocalVariable(name: "unused", arg: 1, scope: !51, file: !3, line: 9, type: !33)
!56 = !DILocation(line: 9, column: 22, scope: !51)
!57 = !DILocalVariable(name: "r0", scope: !51, file: !3, line: 12, type: !30)
!58 = !DILocation(line: 12, column: 9, scope: !51)
!59 = !DILocation(line: 12, column: 14, scope: !51)
!60 = !DILocation(line: 13, column: 5, scope: !51)
!61 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 16, type: !52, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!62 = !DILocalVariable(name: "unused", arg: 1, scope: !61, file: !3, line: 16, type: !33)
!63 = !DILocation(line: 16, column: 22, scope: !61)
!64 = !DILocation(line: 19, column: 5, scope: !61)
!65 = !DILocalVariable(name: "r0", scope: !61, file: !3, line: 21, type: !30)
!66 = !DILocation(line: 21, column: 9, scope: !61)
!67 = !DILocation(line: 21, column: 14, scope: !61)
!68 = !DILocation(line: 23, column: 5, scope: !61)
!69 = !DILocalVariable(name: "r1", scope: !61, file: !3, line: 25, type: !30)
!70 = !DILocation(line: 25, column: 9, scope: !61)
!71 = !DILocation(line: 25, column: 14, scope: !61)
!72 = !DILocation(line: 27, column: 5, scope: !61)
!73 = !DILocation(line: 28, column: 5, scope: !61)
!74 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 31, type: !52, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!75 = !DILocalVariable(name: "unused", arg: 1, scope: !74, file: !3, line: 31, type: !33)
!76 = !DILocation(line: 31, column: 22, scope: !74)
!77 = !DILocation(line: 34, column: 5, scope: !74)
!78 = !DILocalVariable(name: "r0", scope: !74, file: !3, line: 36, type: !30)
!79 = !DILocation(line: 36, column: 9, scope: !74)
!80 = !DILocation(line: 36, column: 14, scope: !74)
!81 = !DILocation(line: 38, column: 5, scope: !74)
!82 = !DILocation(line: 40, column: 5, scope: !74)
!83 = !DILocalVariable(name: "r1", scope: !74, file: !3, line: 42, type: !30)
!84 = !DILocation(line: 42, column: 9, scope: !74)
!85 = !DILocation(line: 42, column: 14, scope: !74)
!86 = !DILocation(line: 44, column: 5, scope: !74)
!87 = !DILocation(line: 44, column: 11, scope: !74)
!88 = !DILocation(line: 44, column: 24, scope: !74)
!89 = !DILocation(line: 44, column: 29, scope: !74)
!90 = !DILocation(line: 44, column: 33, scope: !74)
!91 = !DILocation(line: 44, column: 46, scope: !74)
!92 = !DILocation(line: 0, scope: !74)
!93 = distinct !{!93, !86, !94, !95}
!94 = !DILocation(line: 44, column: 54, scope: !74)
!95 = !{!"llvm.loop.mustprogress"}
!96 = !DILocation(line: 45, column: 5, scope: !74)
!97 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 48, type: !98, scopeLine: 49, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !54)
!98 = !DISubroutineType(types: !99)
!99 = !{!30}
!100 = !DILocalVariable(name: "t1", scope: !97, file: !3, line: 50, type: !101)
!101 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !102, line: 31, baseType: !103)
!102 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !104, line: 118, baseType: !105)
!104 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!105 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !106, size: 64)
!106 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !104, line: 103, size: 65536, elements: !107)
!107 = !{!108, !110, !120}
!108 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !106, file: !104, line: 104, baseType: !109, size: 64)
!109 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !106, file: !104, line: 105, baseType: !111, size: 64, offset: 64)
!111 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!112 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !104, line: 57, size: 192, elements: !113)
!113 = !{!114, !118, !119}
!114 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !112, file: !104, line: 58, baseType: !115, size: 64)
!115 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !116, size: 64)
!116 = !DISubroutineType(types: !117)
!117 = !{null, !33}
!118 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !112, file: !104, line: 59, baseType: !33, size: 64, offset: 64)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !112, file: !104, line: 60, baseType: !111, size: 64, offset: 128)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !106, file: !104, line: 106, baseType: !121, size: 65408, offset: 128)
!121 = !DICompositeType(tag: DW_TAG_array_type, baseType: !122, size: 65408, elements: !123)
!122 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!123 = !{!124}
!124 = !DISubrange(count: 8176)
!125 = !DILocation(line: 50, column: 12, scope: !97)
!126 = !DILocalVariable(name: "t2", scope: !97, file: !3, line: 50, type: !101)
!127 = !DILocation(line: 50, column: 16, scope: !97)
!128 = !DILocalVariable(name: "t3", scope: !97, file: !3, line: 50, type: !101)
!129 = !DILocation(line: 50, column: 20, scope: !97)
!130 = !DILocation(line: 52, column: 2, scope: !97)
!131 = !DILocation(line: 53, column: 2, scope: !97)
!132 = !DILocation(line: 54, column: 2, scope: !97)
!133 = !DILocation(line: 56, column: 2, scope: !97)
