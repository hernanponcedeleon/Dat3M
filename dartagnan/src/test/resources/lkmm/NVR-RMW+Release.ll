; ModuleID = 'benchmarks/lkmm/NVR-RMW+Release.c'
source_filename = "benchmarks/lkmm/NVR-RMW+Release.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !57
@__func__.run = private unnamed_addr constant [4 x i8] c"run\00", align 1, !dbg !40
@.str = private unnamed_addr constant [18 x i8] c"NVR-RMW+Release.c\00", align 1, !dbg !47
@.str.1 = private unnamed_addr constant [7 x i8] c"x == 1\00", align 1, !dbg !52

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @run(ptr noundef %0) #0 !dbg !71 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !75, !DIExpression(), !76)
    #dbg_declare(ptr %3, !77, !DIExpression(), !78)
  %4 = load ptr, ptr %2, align 8, !dbg !79
  %5 = ptrtoint ptr %4 to i64, !dbg !80
  %6 = trunc i64 %5 to i32, !dbg !81
  store i32 %6, ptr %3, align 4, !dbg !78
  %7 = load i32, ptr %3, align 4, !dbg !82
  switch i32 %7, label %26 [
    i32 0, label %8
    i32 1, label %9
    i32 2, label %10
  ], !dbg !83

8:                                                ; preds = %1
  store i32 1, ptr @x, align 4, !dbg !84
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 3, i32 noundef 2), !dbg !86
  br label %26, !dbg !87

9:                                                ; preds = %1
  call void @__LKMM_atomic_op(ptr noundef @y, i64 noundef 4, i64 noundef -3, i32 noundef 2), !dbg !88
  br label %26, !dbg !89

10:                                               ; preds = %1
  %11 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !90
  %12 = trunc i64 %11 to i32, !dbg !90
  %13 = icmp eq i32 %12, 1, !dbg !92
  br i1 %13, label %14, label %25, !dbg !93

14:                                               ; preds = %10
  %15 = load i32, ptr @x, align 4, !dbg !94
  %16 = icmp eq i32 %15, 1, !dbg !94
  %17 = xor i1 %16, true, !dbg !94
  %18 = zext i1 %17 to i32, !dbg !94
  %19 = sext i32 %18 to i64, !dbg !94
  %20 = icmp ne i64 %19, 0, !dbg !94
  br i1 %20, label %21, label %23, !dbg !94

21:                                               ; preds = %14
  call void @__assert_rtn(ptr noundef @__func__.run, ptr noundef @.str, i32 noundef 28, ptr noundef @.str.1) #3, !dbg !94
  unreachable, !dbg !94

22:                                               ; No predecessors!
  br label %24, !dbg !94

23:                                               ; preds = %14
  br label %24, !dbg !94

24:                                               ; preds = %23, %22
  br label %25, !dbg !96

25:                                               ; preds = %24, %10
  br label %26, !dbg !97

26:                                               ; preds = %1, %25, %9, %8
  ret ptr null, !dbg !98
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_atomic_op(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !99 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !102, !DIExpression(), !125)
    #dbg_declare(ptr %3, !126, !DIExpression(), !127)
    #dbg_declare(ptr %4, !128, !DIExpression(), !129)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @run, ptr noundef null), !dbg !130
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @run, ptr noundef inttoptr (i64 1 to ptr)), !dbg !131
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @run, ptr noundef inttoptr (i64 2 to ptr)), !dbg !132
  %8 = load ptr, ptr %2, align 8, !dbg !133
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !134
  %10 = load ptr, ptr %3, align 8, !dbg !135
  %11 = call i32 @_pthread_join(ptr noundef %10, ptr noundef null), !dbg !136
  %12 = load ptr, ptr %4, align 8, !dbg !137
  %13 = call i32 @_pthread_join(ptr noundef %12, ptr noundef null), !dbg !138
  ret i32 0, !dbg !139
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @_pthread_join(ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!63, !64, !65, !66, !67, !68, !69}
!llvm.ident = !{!70}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 5, type: !37, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !28, globals: !39, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/NVR-RMW+Release.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "288212c519a14c4a96e909a8b480bc52")
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
!28 = !{!29, !34, !37, !38}
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !30, line: 32, baseType: !31)
!30 = !DIFile(filename: "/usr/local/include/sys/_types/_intptr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e478ba47270923b1cca6659f19f02db1")
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_intptr_t", file: !32, line: 64, baseType: !33)
!32 = !DIFile(filename: "/usr/local/include/i386/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "eb9e401b3b97107c79f668bcc91916e5")
!33 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 27, baseType: !35)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !36, line: 32, baseType: !33)
!36 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!37 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!39 = !{!40, !47, !52, !0, !57}
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(scope: null, file: !3, line: 28, type: !42, isLocal: true, isDefinition: true)
!42 = !DICompositeType(tag: DW_TAG_array_type, baseType: !43, size: 32, elements: !45)
!43 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !44)
!44 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!45 = !{!46}
!46 = !DISubrange(count: 4)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(scope: null, file: !3, line: 28, type: !49, isLocal: true, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !44, size: 144, elements: !50)
!50 = !{!51}
!51 = !DISubrange(count: 18)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(scope: null, file: !3, line: 28, type: !54, isLocal: true, isDefinition: true)
!54 = !DICompositeType(tag: DW_TAG_array_type, baseType: !44, size: 56, elements: !55)
!55 = !{!56}
!56 = !DISubrange(count: 7)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 6, type: !59, isLocal: false, isDefinition: true)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 108, baseType: !60)
!60 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 106, size: 32, elements: !61)
!61 = !{!62}
!62 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !60, file: !6, line: 107, baseType: !37, size: 32)
!63 = !{i32 7, !"Dwarf Version", i32 5}
!64 = !{i32 2, !"Debug Info Version", i32 3}
!65 = !{i32 1, !"wchar_size", i32 4}
!66 = !{i32 8, !"PIC Level", i32 2}
!67 = !{i32 7, !"PIE Level", i32 2}
!68 = !{i32 7, !"uwtable", i32 2}
!69 = !{i32 7, !"frame-pointer", i32 2}
!70 = !{!"Homebrew clang version 19.1.7"}
!71 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 15, type: !72, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!72 = !DISubroutineType(types: !73)
!73 = !{!38, !38}
!74 = !{}
!75 = !DILocalVariable(name: "arg", arg: 1, scope: !71, file: !3, line: 15, type: !38)
!76 = !DILocation(line: 15, column: 17, scope: !71)
!77 = !DILocalVariable(name: "tid", scope: !71, file: !3, line: 17, type: !37)
!78 = !DILocation(line: 17, column: 9, scope: !71)
!79 = !DILocation(line: 17, column: 27, scope: !71)
!80 = !DILocation(line: 17, column: 16, scope: !71)
!81 = !DILocation(line: 17, column: 15, scope: !71)
!82 = !DILocation(line: 18, column: 13, scope: !71)
!83 = !DILocation(line: 18, column: 5, scope: !71)
!84 = !DILocation(line: 20, column: 11, scope: !85)
!85 = distinct !DILexicalBlock(scope: !71, file: !3, line: 18, column: 18)
!86 = !DILocation(line: 21, column: 9, scope: !85)
!87 = !DILocation(line: 22, column: 9, scope: !85)
!88 = !DILocation(line: 24, column: 9, scope: !85)
!89 = !DILocation(line: 25, column: 9, scope: !85)
!90 = !DILocation(line: 27, column: 13, scope: !91)
!91 = distinct !DILexicalBlock(scope: !85, file: !3, line: 27, column: 13)
!92 = !DILocation(line: 27, column: 42, scope: !91)
!93 = !DILocation(line: 27, column: 13, scope: !85)
!94 = !DILocation(line: 28, column: 13, scope: !95)
!95 = distinct !DILexicalBlock(scope: !91, file: !3, line: 27, column: 50)
!96 = !DILocation(line: 29, column: 9, scope: !95)
!97 = !DILocation(line: 30, column: 9, scope: !85)
!98 = !DILocation(line: 32, column: 5, scope: !71)
!99 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 34, type: !100, scopeLine: 35, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !74)
!100 = !DISubroutineType(types: !101)
!101 = !{!37}
!102 = !DILocalVariable(name: "t0", scope: !99, file: !3, line: 36, type: !103)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !104, line: 31, baseType: !105)
!104 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !106, line: 118, baseType: !107)
!106 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !108, size: 64)
!108 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !106, line: 103, size: 65536, elements: !109)
!109 = !{!110, !111, !121}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !108, file: !106, line: 104, baseType: !33, size: 64)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !108, file: !106, line: 105, baseType: !112, size: 64, offset: 64)
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!113 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !106, line: 57, size: 192, elements: !114)
!114 = !{!115, !119, !120}
!115 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !113, file: !106, line: 58, baseType: !116, size: 64)
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = !DISubroutineType(types: !118)
!118 = !{null, !38}
!119 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !113, file: !106, line: 59, baseType: !38, size: 64, offset: 64)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !113, file: !106, line: 60, baseType: !112, size: 64, offset: 128)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !108, file: !106, line: 106, baseType: !122, size: 65408, offset: 128)
!122 = !DICompositeType(tag: DW_TAG_array_type, baseType: !44, size: 65408, elements: !123)
!123 = !{!124}
!124 = !DISubrange(count: 8176)
!125 = !DILocation(line: 36, column: 15, scope: !99)
!126 = !DILocalVariable(name: "t1", scope: !99, file: !3, line: 36, type: !103)
!127 = !DILocation(line: 36, column: 19, scope: !99)
!128 = !DILocalVariable(name: "t2", scope: !99, file: !3, line: 36, type: !103)
!129 = !DILocation(line: 36, column: 23, scope: !99)
!130 = !DILocation(line: 37, column: 5, scope: !99)
!131 = !DILocation(line: 38, column: 5, scope: !99)
!132 = !DILocation(line: 39, column: 5, scope: !99)
!133 = !DILocation(line: 41, column: 18, scope: !99)
!134 = !DILocation(line: 41, column: 5, scope: !99)
!135 = !DILocation(line: 42, column: 18, scope: !99)
!136 = !DILocation(line: 42, column: 5, scope: !99)
!137 = !DILocation(line: 43, column: 18, scope: !99)
!138 = !DILocation(line: 43, column: 5, scope: !99)
!139 = !DILocation(line: 45, column: 5, scope: !99)
