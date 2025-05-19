; ModuleID = 'benchmarks/lkmm/C-atomic-op-return-simple-02-2.c'
source_filename = "benchmarks/lkmm/C-atomic-op-return-simple-02-2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@r0_0 = dso_local global i32 0, align 4, !dbg !60
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !54
@r1_0 = dso_local global i32 0, align 4, !dbg !62
@r0_1 = dso_local global i32 0, align 4, !dbg !64
@r1_1 = dso_local global i32 0, align 4, !dbg !66
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !37
@.str = private unnamed_addr constant [33 x i8] c"C-atomic-op-return-simple-02-2.c\00", align 1, !dbg !44
@.str.1 = private unnamed_addr constant [100 x i8] c"!(r0_0 == 1 && r1_0 == 0 && r0_1 == 1 && r1_1 == 0 && atomic_read(&x) == 1 && atomic_read(&y) == 1)\00", align 1, !dbg !49

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !76 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !80, !DIExpression(), !81)
  %3 = call i64 @__LKMM_atomic_op_return(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0, i32 noundef 0), !dbg !82
  %4 = trunc i64 %3 to i32, !dbg !82
  store i32 %4, ptr @r0_0, align 4, !dbg !83
  %5 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !84
  %6 = trunc i64 %5 to i32, !dbg !84
  store i32 %6, ptr @r1_0, align 4, !dbg !85
  ret ptr null, !dbg !86
}

declare i64 @__LKMM_atomic_op_return(ptr noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !87 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !88, !DIExpression(), !89)
  %3 = call i64 @__LKMM_atomic_op_return(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 0, i32 noundef 0), !dbg !90
  %4 = trunc i64 %3 to i32, !dbg !90
  store i32 %4, ptr @r0_1, align 4, !dbg !91
  %5 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !92
  %6 = trunc i64 %5 to i32, !dbg !92
  store i32 %6, ptr @r1_1, align 4, !dbg !93
  ret ptr null, !dbg !94
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !95 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !98, !DIExpression(), !121)
    #dbg_declare(ptr %3, !122, !DIExpression(), !123)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !124
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !125
  %6 = load ptr, ptr %2, align 8, !dbg !126
  %7 = call i32 @_pthread_join(ptr noundef %6, ptr noundef null), !dbg !127
  %8 = load ptr, ptr %3, align 8, !dbg !128
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !129
  %10 = load i32, ptr @r0_0, align 4, !dbg !130
  %11 = icmp eq i32 %10, 1, !dbg !130
  br i1 %11, label %12, label %29, !dbg !130

12:                                               ; preds = %0
  %13 = load i32, ptr @r1_0, align 4, !dbg !130
  %14 = icmp eq i32 %13, 0, !dbg !130
  br i1 %14, label %15, label %29, !dbg !130

15:                                               ; preds = %12
  %16 = load i32, ptr @r0_1, align 4, !dbg !130
  %17 = icmp eq i32 %16, 1, !dbg !130
  br i1 %17, label %18, label %29, !dbg !130

18:                                               ; preds = %15
  %19 = load i32, ptr @r1_1, align 4, !dbg !130
  %20 = icmp eq i32 %19, 0, !dbg !130
  br i1 %20, label %21, label %29, !dbg !130

21:                                               ; preds = %18
  %22 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !130
  %23 = trunc i64 %22 to i32, !dbg !130
  %24 = icmp eq i32 %23, 1, !dbg !130
  br i1 %24, label %25, label %29, !dbg !130

25:                                               ; preds = %21
  %26 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !130
  %27 = trunc i64 %26 to i32, !dbg !130
  %28 = icmp eq i32 %27, 1, !dbg !130
  br label %29

29:                                               ; preds = %25, %21, %18, %15, %12, %0
  %30 = phi i1 [ false, %21 ], [ false, %18 ], [ false, %15 ], [ false, %12 ], [ false, %0 ], [ %28, %25 ], !dbg !131
  %31 = xor i1 %30, true, !dbg !130
  %32 = xor i1 %31, true, !dbg !130
  %33 = zext i1 %32 to i32, !dbg !130
  %34 = sext i32 %33 to i64, !dbg !130
  %35 = icmp ne i64 %34, 0, !dbg !130
  br i1 %35, label %36, label %38, !dbg !130

36:                                               ; preds = %29
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 39, ptr noundef @.str.1) #3, !dbg !130
  unreachable, !dbg !130

37:                                               ; No predecessors!
  br label %39, !dbg !130

38:                                               ; preds = %29
  br label %39, !dbg !130

39:                                               ; preds = %38, %37
  ret i32 0, !dbg !132
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
!llvm.module.flags = !{!68, !69, !70, !71, !72, !73, !74}
!llvm.ident = !{!75}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !56, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !36, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/C-atomic-op-return-simple-02-2.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f54fd217313dd14571d84f0acd77daab")
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
!36 = !{!37, !44, !49, !0, !54, !60, !62, !64, !66}
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 40, elements: !42)
!40 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !41)
!41 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!42 = !{!43}
!43 = !DISubrange(count: 5)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !46, isLocal: true, isDefinition: true)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 264, elements: !47)
!47 = !{!48}
!48 = !DISubrange(count: 33)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !51, isLocal: true, isDefinition: true)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 800, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 100)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !56, isLocal: false, isDefinition: true)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 109, baseType: !57)
!57 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 107, size: 32, elements: !58)
!58 = !{!59}
!59 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !57, file: !6, line: 108, baseType: !30, size: 32)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "r0_0", scope: !2, file: !3, line: 9, type: !30, isLocal: false, isDefinition: true)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "r1_0", scope: !2, file: !3, line: 10, type: !30, isLocal: false, isDefinition: true)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "r0_1", scope: !2, file: !3, line: 12, type: !30, isLocal: false, isDefinition: true)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "r1_1", scope: !2, file: !3, line: 13, type: !30, isLocal: false, isDefinition: true)
!68 = !{i32 7, !"Dwarf Version", i32 5}
!69 = !{i32 2, !"Debug Info Version", i32 3}
!70 = !{i32 1, !"wchar_size", i32 4}
!71 = !{i32 8, !"PIC Level", i32 2}
!72 = !{i32 7, !"PIE Level", i32 2}
!73 = !{i32 7, !"uwtable", i32 2}
!74 = !{i32 7, !"frame-pointer", i32 2}
!75 = !{!"Homebrew clang version 19.1.7"}
!76 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 15, type: !77, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !79)
!77 = !DISubroutineType(types: !78)
!78 = !{!35, !35}
!79 = !{}
!80 = !DILocalVariable(name: "unused", arg: 1, scope: !76, file: !3, line: 15, type: !35)
!81 = !DILocation(line: 15, column: 22, scope: !76)
!82 = !DILocation(line: 17, column: 10, scope: !76)
!83 = !DILocation(line: 17, column: 8, scope: !76)
!84 = !DILocation(line: 18, column: 10, scope: !76)
!85 = !DILocation(line: 18, column: 8, scope: !76)
!86 = !DILocation(line: 19, column: 3, scope: !76)
!87 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 22, type: !77, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !79)
!88 = !DILocalVariable(name: "unused", arg: 1, scope: !87, file: !3, line: 22, type: !35)
!89 = !DILocation(line: 22, column: 22, scope: !87)
!90 = !DILocation(line: 24, column: 10, scope: !87)
!91 = !DILocation(line: 24, column: 8, scope: !87)
!92 = !DILocation(line: 25, column: 10, scope: !87)
!93 = !DILocation(line: 25, column: 8, scope: !87)
!94 = !DILocation(line: 26, column: 3, scope: !87)
!95 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 29, type: !96, scopeLine: 30, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !79)
!96 = !DISubroutineType(types: !97)
!97 = !{!30}
!98 = !DILocalVariable(name: "t1", scope: !95, file: !3, line: 31, type: !99)
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !100, line: 31, baseType: !101)
!100 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!101 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !102, line: 118, baseType: !103)
!102 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!103 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!104 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !102, line: 103, size: 65536, elements: !105)
!105 = !{!106, !107, !117}
!106 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !104, file: !102, line: 104, baseType: !34, size: 64)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !104, file: !102, line: 105, baseType: !108, size: 64, offset: 64)
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!109 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !102, line: 57, size: 192, elements: !110)
!110 = !{!111, !115, !116}
!111 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !109, file: !102, line: 58, baseType: !112, size: 64)
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!113 = !DISubroutineType(types: !114)
!114 = !{null, !35}
!115 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !109, file: !102, line: 59, baseType: !35, size: 64, offset: 64)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !109, file: !102, line: 60, baseType: !108, size: 64, offset: 128)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !104, file: !102, line: 106, baseType: !118, size: 65408, offset: 128)
!118 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 65408, elements: !119)
!119 = !{!120}
!120 = !DISubrange(count: 8176)
!121 = !DILocation(line: 31, column: 12, scope: !95)
!122 = !DILocalVariable(name: "t2", scope: !95, file: !3, line: 31, type: !99)
!123 = !DILocation(line: 31, column: 16, scope: !95)
!124 = !DILocation(line: 33, column: 2, scope: !95)
!125 = !DILocation(line: 34, column: 2, scope: !95)
!126 = !DILocation(line: 36, column: 15, scope: !95)
!127 = !DILocation(line: 36, column: 2, scope: !95)
!128 = !DILocation(line: 37, column: 15, scope: !95)
!129 = !DILocation(line: 37, column: 2, scope: !95)
!130 = !DILocation(line: 39, column: 2, scope: !95)
!131 = !DILocation(line: 0, scope: !95)
!132 = !DILocation(line: 41, column: 2, scope: !95)
