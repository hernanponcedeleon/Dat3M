; ModuleID = 'benchmarks/lkmm/C-atomic-op-return-simple-02-2.c'
source_filename = "benchmarks/lkmm/C-atomic-op-return-simple-02-2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@r0_0 = dso_local global i32 0, align 4, !dbg !59
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !53
@r1_0 = dso_local global i32 0, align 4, !dbg !61
@r0_1 = dso_local global i32 0, align 4, !dbg !63
@r1_1 = dso_local global i32 0, align 4, !dbg !65
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !36
@.str = private unnamed_addr constant [33 x i8] c"C-atomic-op-return-simple-02-2.c\00", align 1, !dbg !43
@.str.1 = private unnamed_addr constant [100 x i8] c"!(r0_0 == 1 && r1_0 == 0 && r0_1 == 1 && r1_1 == 0 && atomic_read(&x) == 1 && atomic_read(&y) == 1)\00", align 1, !dbg !48

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !75 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !79, !DIExpression(), !80)
  %3 = call i64 @__LKMM_atomic_op_return(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0, i32 noundef 0), !dbg !81
  %4 = trunc i64 %3 to i32, !dbg !81
  store i32 %4, ptr @r0_0, align 4, !dbg !82
  %5 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 0), !dbg !83
  %6 = trunc i64 %5 to i32, !dbg !83
  store i32 %6, ptr @r1_0, align 4, !dbg !84
  ret ptr null, !dbg !85
}

declare i64 @__LKMM_atomic_op_return(ptr noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !86 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !87, !DIExpression(), !88)
  %3 = call i64 @__LKMM_atomic_op_return(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 0, i32 noundef 0), !dbg !89
  %4 = trunc i64 %3 to i32, !dbg !89
  store i32 %4, ptr @r0_1, align 4, !dbg !90
  %5 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !91
  %6 = trunc i64 %5 to i32, !dbg !91
  store i32 %6, ptr @r1_1, align 4, !dbg !92
  ret ptr null, !dbg !93
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !94 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !97, !DIExpression(), !120)
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
  %22 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !129
  %23 = trunc i64 %22 to i32, !dbg !129
  %24 = icmp eq i32 %23, 1, !dbg !129
  br i1 %24, label %25, label %29, !dbg !129

25:                                               ; preds = %21
  %26 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 0), !dbg !129
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
!llvm.module.flags = !{!67, !68, !69, !70, !71, !72, !73}
!llvm.ident = !{!74}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !55, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !28, globals: !35, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/C-atomic-op-return-simple-02-2.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f54fd217313dd14571d84f0acd77daab")
!4 = !{!5, !22}
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
!22 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_operation", file: !6, line: 19, baseType: !7, size: 32, elements: !23)
!23 = !{!24, !25, !26, !27}
!24 = !DIEnumerator(name: "__LKMM_op_add", value: 0)
!25 = !DIEnumerator(name: "__LKMM_op_sub", value: 1)
!26 = !DIEnumerator(name: "__LKMM_op_and", value: 2)
!27 = !DIEnumerator(name: "__LKMM_op_or", value: 3)
!28 = !{!29, !30, !34}
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 27, baseType: !31)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !32, line: 32, baseType: !33)
!32 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!33 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!35 = !{!36, !43, !48, !0, !53, !59, !61, !63, !65}
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 40, elements: !41)
!39 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !40)
!40 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!41 = !{!42}
!42 = !DISubrange(count: 5)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 264, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 33)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !50, isLocal: true, isDefinition: true)
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 800, elements: !51)
!51 = !{!52}
!52 = !DISubrange(count: 100)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !55, isLocal: false, isDefinition: true)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 108, baseType: !56)
!56 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 106, size: 32, elements: !57)
!57 = !{!58}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !56, file: !6, line: 107, baseType: !29, size: 32)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "r0_0", scope: !2, file: !3, line: 9, type: !29, isLocal: false, isDefinition: true)
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(name: "r1_0", scope: !2, file: !3, line: 10, type: !29, isLocal: false, isDefinition: true)
!63 = !DIGlobalVariableExpression(var: !64, expr: !DIExpression())
!64 = distinct !DIGlobalVariable(name: "r0_1", scope: !2, file: !3, line: 12, type: !29, isLocal: false, isDefinition: true)
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(name: "r1_1", scope: !2, file: !3, line: 13, type: !29, isLocal: false, isDefinition: true)
!67 = !{i32 7, !"Dwarf Version", i32 5}
!68 = !{i32 2, !"Debug Info Version", i32 3}
!69 = !{i32 1, !"wchar_size", i32 4}
!70 = !{i32 8, !"PIC Level", i32 2}
!71 = !{i32 7, !"PIE Level", i32 2}
!72 = !{i32 7, !"uwtable", i32 2}
!73 = !{i32 7, !"frame-pointer", i32 2}
!74 = !{!"Homebrew clang version 19.1.7"}
!75 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 15, type: !76, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !78)
!76 = !DISubroutineType(types: !77)
!77 = !{!34, !34}
!78 = !{}
!79 = !DILocalVariable(name: "unused", arg: 1, scope: !75, file: !3, line: 15, type: !34)
!80 = !DILocation(line: 15, column: 22, scope: !75)
!81 = !DILocation(line: 17, column: 10, scope: !75)
!82 = !DILocation(line: 17, column: 8, scope: !75)
!83 = !DILocation(line: 18, column: 10, scope: !75)
!84 = !DILocation(line: 18, column: 8, scope: !75)
!85 = !DILocation(line: 19, column: 3, scope: !75)
!86 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 22, type: !76, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !78)
!87 = !DILocalVariable(name: "unused", arg: 1, scope: !86, file: !3, line: 22, type: !34)
!88 = !DILocation(line: 22, column: 22, scope: !86)
!89 = !DILocation(line: 24, column: 10, scope: !86)
!90 = !DILocation(line: 24, column: 8, scope: !86)
!91 = !DILocation(line: 25, column: 10, scope: !86)
!92 = !DILocation(line: 25, column: 8, scope: !86)
!93 = !DILocation(line: 26, column: 3, scope: !86)
!94 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 29, type: !95, scopeLine: 30, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !78)
!95 = !DISubroutineType(types: !96)
!96 = !{!29}
!97 = !DILocalVariable(name: "t1", scope: !94, file: !3, line: 31, type: !98)
!98 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !99, line: 31, baseType: !100)
!99 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!100 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !101, line: 118, baseType: !102)
!101 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!102 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!103 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !101, line: 103, size: 65536, elements: !104)
!104 = !{!105, !106, !116}
!105 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !103, file: !101, line: 104, baseType: !33, size: 64)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !103, file: !101, line: 105, baseType: !107, size: 64, offset: 64)
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !108, size: 64)
!108 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !101, line: 57, size: 192, elements: !109)
!109 = !{!110, !114, !115}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !108, file: !101, line: 58, baseType: !111, size: 64)
!111 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!112 = !DISubroutineType(types: !113)
!113 = !{null, !34}
!114 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !108, file: !101, line: 59, baseType: !34, size: 64, offset: 64)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !108, file: !101, line: 60, baseType: !107, size: 64, offset: 128)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !103, file: !101, line: 106, baseType: !117, size: 65408, offset: 128)
!117 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 65408, elements: !118)
!118 = !{!119}
!119 = !DISubrange(count: 8176)
!120 = !DILocation(line: 31, column: 12, scope: !94)
!121 = !DILocalVariable(name: "t2", scope: !94, file: !3, line: 31, type: !98)
!122 = !DILocation(line: 31, column: 16, scope: !94)
!123 = !DILocation(line: 33, column: 2, scope: !94)
!124 = !DILocation(line: 34, column: 2, scope: !94)
!125 = !DILocation(line: 36, column: 15, scope: !94)
!126 = !DILocation(line: 36, column: 2, scope: !94)
!127 = !DILocation(line: 37, column: 15, scope: !94)
!128 = !DILocation(line: 37, column: 2, scope: !94)
!129 = !DILocation(line: 39, column: 2, scope: !94)
!130 = !DILocation(line: 0, scope: !94)
!131 = !DILocation(line: 41, column: 2, scope: !94)
