; ModuleID = 'benchmarks/lkmm/C-atomic-op-return-simple-02-2.c'
source_filename = "benchmarks/lkmm/C-atomic-op-return-simple-02-2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@r0_0 = dso_local global i32 0, align 4, !dbg !58
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !52
@r1_0 = dso_local global i32 0, align 4, !dbg !60
@r0_1 = dso_local global i32 0, align 4, !dbg !62
@r1_1 = dso_local global i32 0, align 4, !dbg !64
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !35
@.str = private unnamed_addr constant [33 x i8] c"C-atomic-op-return-simple-02-2.c\00", align 1, !dbg !42
@.str.1 = private unnamed_addr constant [100 x i8] c"!(r0_0 == 1 && r1_0 == 0 && r0_1 == 1 && r1_1 == 0 && atomic_read(&x) == 1 && atomic_read(&y) == 1)\00", align 1, !dbg !47

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !74 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !78, !DIExpression(), !79)
  %3 = call i64 @__LKMM_atomic_op_return(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0, i32 noundef 0), !dbg !80
  %4 = trunc i64 %3 to i32, !dbg !80
  store i32 %4, ptr @r0_0, align 4, !dbg !81
  %5 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !82
  %6 = trunc i64 %5 to i32, !dbg !82
  store i32 %6, ptr @r1_0, align 4, !dbg !83
  ret ptr null, !dbg !84
}

declare i64 @__LKMM_atomic_op_return(ptr noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !85 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !86, !DIExpression(), !87)
  %3 = call i64 @__LKMM_atomic_op_return(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 0, i32 noundef 0), !dbg !88
  %4 = trunc i64 %3 to i32, !dbg !88
  store i32 %4, ptr @r0_1, align 4, !dbg !89
  %5 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !90
  %6 = trunc i64 %5 to i32, !dbg !90
  store i32 %6, ptr @r1_1, align 4, !dbg !91
  ret ptr null, !dbg !92
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !93 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !96, !DIExpression(), !120)
    #dbg_declare(ptr %3, !121, !DIExpression(), !122)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !123
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !124
  %6 = load ptr, ptr %2, align 8, !dbg !125
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !126
  %8 = load ptr, ptr %3, align 8, !dbg !127
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !128
  %10 = load i32, ptr @r0_0, align 4, !dbg !129
  %11 = icmp eq i32 %10, 1, !dbg !129
  br i1 %11, label %12, label %29, !dbg !129

12:                                               ; preds = %0
  %13 = load i32, ptr @r1_0, align 4, !dbg !129
  %14 = icmp eq i32 %13, 0, !dbg !129
  br i1 %14, label %15, label %29, !dbg !129

15:                                               ; preds = %12
  %16 = load i32, ptr @r0_1, align 4, !dbg !129
  %17 = icmp eq i32 %16, 1, !dbg !129
  br i1 %17, label %18, label %29, !dbg !129

18:                                               ; preds = %15
  %19 = load i32, ptr @r1_1, align 4, !dbg !129
  %20 = icmp eq i32 %19, 0, !dbg !129
  br i1 %20, label %21, label %29, !dbg !129

21:                                               ; preds = %18
  %22 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !129
  %23 = trunc i64 %22 to i32, !dbg !129
  %24 = icmp eq i32 %23, 1, !dbg !129
  br i1 %24, label %25, label %29, !dbg !129

25:                                               ; preds = %21
  %26 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !129
  %27 = trunc i64 %26 to i32, !dbg !129
  %28 = icmp eq i32 %27, 1, !dbg !129
  br label %29

29:                                               ; preds = %25, %21, %18, %15, %12, %0
  %30 = phi i1 [ false, %21 ], [ false, %18 ], [ false, %15 ], [ false, %12 ], [ false, %0 ], [ %28, %25 ], !dbg !130
  %31 = xor i1 %30, true, !dbg !129
  %32 = xor i1 %31, true, !dbg !129
  %33 = zext i1 %32 to i32, !dbg !129
  %34 = sext i32 %33 to i64, !dbg !129
  %35 = icmp ne i64 %34, 0, !dbg !129
  br i1 %35, label %36, label %38, !dbg !129

36:                                               ; preds = %29
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 39, ptr noundef @.str.1) #3, !dbg !129
  unreachable, !dbg !129

37:                                               ; No predecessors!
  br label %39, !dbg !129

38:                                               ; preds = %29
  br label %39, !dbg !129

39:                                               ; preds = %38, %37
  ret i32 0, !dbg !131
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
!llvm.module.flags = !{!66, !67, !68, !69, !70, !71, !72}
!llvm.ident = !{!73}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !54, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !34, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/C-atomic-op-return-simple-02-2.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f54fd217313dd14571d84f0acd77daab")
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
!34 = !{!35, !42, !47, !0, !52, !58, !60, !62, !64}
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !37, isLocal: true, isDefinition: true)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 40, elements: !40)
!38 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !39)
!39 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!40 = !{!41}
!41 = !DISubrange(count: 5)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 264, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 33)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !49, isLocal: true, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 800, elements: !50)
!50 = !{!51}
!51 = !DISubrange(count: 100)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !54, isLocal: false, isDefinition: true)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 109, baseType: !55)
!55 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 107, size: 32, elements: !56)
!56 = !{!57}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !55, file: !6, line: 108, baseType: !30, size: 32)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "r0_0", scope: !2, file: !3, line: 9, type: !30, isLocal: false, isDefinition: true)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "r1_0", scope: !2, file: !3, line: 10, type: !30, isLocal: false, isDefinition: true)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "r0_1", scope: !2, file: !3, line: 12, type: !30, isLocal: false, isDefinition: true)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "r1_1", scope: !2, file: !3, line: 13, type: !30, isLocal: false, isDefinition: true)
!66 = !{i32 7, !"Dwarf Version", i32 5}
!67 = !{i32 2, !"Debug Info Version", i32 3}
!68 = !{i32 1, !"wchar_size", i32 4}
!69 = !{i32 8, !"PIC Level", i32 2}
!70 = !{i32 7, !"PIE Level", i32 2}
!71 = !{i32 7, !"uwtable", i32 2}
!72 = !{i32 7, !"frame-pointer", i32 2}
!73 = !{!"Homebrew clang version 19.1.7"}
!74 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 15, type: !75, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !77)
!75 = !DISubroutineType(types: !76)
!76 = !{!33, !33}
!77 = !{}
!78 = !DILocalVariable(name: "unused", arg: 1, scope: !74, file: !3, line: 15, type: !33)
!79 = !DILocation(line: 15, column: 22, scope: !74)
!80 = !DILocation(line: 17, column: 10, scope: !74)
!81 = !DILocation(line: 17, column: 8, scope: !74)
!82 = !DILocation(line: 18, column: 10, scope: !74)
!83 = !DILocation(line: 18, column: 8, scope: !74)
!84 = !DILocation(line: 19, column: 3, scope: !74)
!85 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 22, type: !75, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !77)
!86 = !DILocalVariable(name: "unused", arg: 1, scope: !85, file: !3, line: 22, type: !33)
!87 = !DILocation(line: 22, column: 22, scope: !85)
!88 = !DILocation(line: 24, column: 10, scope: !85)
!89 = !DILocation(line: 24, column: 8, scope: !85)
!90 = !DILocation(line: 25, column: 10, scope: !85)
!91 = !DILocation(line: 25, column: 8, scope: !85)
!92 = !DILocation(line: 26, column: 3, scope: !85)
!93 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 29, type: !94, scopeLine: 30, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !77)
!94 = !DISubroutineType(types: !95)
!95 = !{!30}
!96 = !DILocalVariable(name: "t1", scope: !93, file: !3, line: 31, type: !97)
!97 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !98, line: 31, baseType: !99)
!98 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !100, line: 118, baseType: !101)
!100 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !102, size: 64)
!102 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !100, line: 103, size: 65536, elements: !103)
!103 = !{!104, !106, !116}
!104 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !102, file: !100, line: 104, baseType: !105, size: 64)
!105 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !102, file: !100, line: 105, baseType: !107, size: 64, offset: 64)
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !108, size: 64)
!108 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !100, line: 57, size: 192, elements: !109)
!109 = !{!110, !114, !115}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !108, file: !100, line: 58, baseType: !111, size: 64)
!111 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!112 = !DISubroutineType(types: !113)
!113 = !{null, !33}
!114 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !108, file: !100, line: 59, baseType: !33, size: 64, offset: 64)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !108, file: !100, line: 60, baseType: !107, size: 64, offset: 128)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !102, file: !100, line: 106, baseType: !117, size: 65408, offset: 128)
!117 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 65408, elements: !118)
!118 = !{!119}
!119 = !DISubrange(count: 8176)
!120 = !DILocation(line: 31, column: 12, scope: !93)
!121 = !DILocalVariable(name: "t2", scope: !93, file: !3, line: 31, type: !97)
!122 = !DILocation(line: 31, column: 16, scope: !93)
!123 = !DILocation(line: 33, column: 2, scope: !93)
!124 = !DILocation(line: 34, column: 2, scope: !93)
!125 = !DILocation(line: 36, column: 15, scope: !93)
!126 = !DILocation(line: 36, column: 2, scope: !93)
!127 = !DILocation(line: 37, column: 15, scope: !93)
!128 = !DILocation(line: 37, column: 2, scope: !93)
!129 = !DILocation(line: 39, column: 2, scope: !93)
!130 = !DILocation(line: 0, scope: !93)
!131 = !DILocation(line: 41, column: 2, scope: !93)
