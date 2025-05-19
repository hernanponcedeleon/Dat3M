; ModuleID = 'benchmarks/lkmm/NVR-RMW+Release.c'
source_filename = "benchmarks/lkmm/NVR-RMW+Release.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !58
@__func__.run = private unnamed_addr constant [4 x i8] c"run\00", align 1, !dbg !41
@.str = private unnamed_addr constant [18 x i8] c"NVR-RMW+Release.c\00", align 1, !dbg !48
@.str.1 = private unnamed_addr constant [7 x i8] c"x == 1\00", align 1, !dbg !53

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @run(ptr noundef %0) #0 !dbg !72 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !76, !DIExpression(), !77)
    #dbg_declare(ptr %3, !78, !DIExpression(), !79)
  %4 = load ptr, ptr %2, align 8, !dbg !80
  %5 = ptrtoint ptr %4 to i64, !dbg !81
  %6 = trunc i64 %5 to i32, !dbg !82
  store i32 %6, ptr %3, align 4, !dbg !79
  %7 = load i32, ptr %3, align 4, !dbg !83
  switch i32 %7, label %26 [
    i32 0, label %8
    i32 1, label %9
    i32 2, label %10
  ], !dbg !84

8:                                                ; preds = %1
  store i32 1, ptr @x, align 4, !dbg !85
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 3, i32 noundef 3), !dbg !87
  br label %26, !dbg !88

9:                                                ; preds = %1
  call void @__LKMM_atomic_op(ptr noundef @y, i64 noundef 4, i64 noundef -3, i32 noundef 2), !dbg !89
  br label %26, !dbg !90

10:                                               ; preds = %1
  %11 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 2), !dbg !91
  %12 = trunc i64 %11 to i32, !dbg !91
  %13 = icmp eq i32 %12, 1, !dbg !93
  br i1 %13, label %14, label %25, !dbg !94

14:                                               ; preds = %10
  %15 = load i32, ptr @x, align 4, !dbg !95
  %16 = icmp eq i32 %15, 1, !dbg !95
  %17 = xor i1 %16, true, !dbg !95
  %18 = zext i1 %17 to i32, !dbg !95
  %19 = sext i32 %18 to i64, !dbg !95
  %20 = icmp ne i64 %19, 0, !dbg !95
  br i1 %20, label %21, label %23, !dbg !95

21:                                               ; preds = %14
  call void @__assert_rtn(ptr noundef @__func__.run, ptr noundef @.str, i32 noundef 28, ptr noundef @.str.1) #3, !dbg !95
  unreachable, !dbg !95

22:                                               ; No predecessors!
  br label %24, !dbg !95

23:                                               ; preds = %14
  br label %24, !dbg !95

24:                                               ; preds = %23, %22
  br label %25, !dbg !97

25:                                               ; preds = %24, %10
  br label %26, !dbg !98

26:                                               ; preds = %1, %25, %9, %8
  ret ptr null, !dbg !99
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_atomic_op(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !100 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !103, !DIExpression(), !126)
    #dbg_declare(ptr %3, !127, !DIExpression(), !128)
    #dbg_declare(ptr %4, !129, !DIExpression(), !130)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @run, ptr noundef null), !dbg !131
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @run, ptr noundef inttoptr (i64 1 to ptr)), !dbg !132
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @run, ptr noundef inttoptr (i64 2 to ptr)), !dbg !133
  %8 = load ptr, ptr %2, align 8, !dbg !134
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !135
  %10 = load ptr, ptr %3, align 8, !dbg !136
  %11 = call i32 @_pthread_join(ptr noundef %10, ptr noundef null), !dbg !137
  %12 = load ptr, ptr %4, align 8, !dbg !138
  %13 = call i32 @_pthread_join(ptr noundef %12, ptr noundef null), !dbg !139
  ret i32 0, !dbg !140
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @_pthread_join(ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!64, !65, !66, !67, !68, !69, !70}
!llvm.ident = !{!71}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 5, type: !38, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !40, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/NVR-RMW+Release.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "288212c519a14c4a96e909a8b480bc52")
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
!29 = !{!30, !35, !38, !39}
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !31, line: 32, baseType: !32)
!31 = !DIFile(filename: "/usr/local/include/sys/_types/_intptr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e478ba47270923b1cca6659f19f02db1")
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_intptr_t", file: !33, line: 64, baseType: !34)
!33 = !DIFile(filename: "/usr/local/include/i386/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "eb9e401b3b97107c79f668bcc91916e5")
!34 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !36)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !37, line: 32, baseType: !34)
!37 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!38 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!40 = !{!41, !48, !53, !0, !58}
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 28, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !44, size: 32, elements: !46)
!44 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !45)
!45 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!46 = !{!47}
!47 = !DISubrange(count: 4)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(scope: null, file: !3, line: 28, type: !50, isLocal: true, isDefinition: true)
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 144, elements: !51)
!51 = !{!52}
!52 = !DISubrange(count: 18)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(scope: null, file: !3, line: 28, type: !55, isLocal: true, isDefinition: true)
!55 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 56, elements: !56)
!56 = !{!57}
!57 = !DISubrange(count: 7)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 6, type: !60, isLocal: false, isDefinition: true)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 109, baseType: !61)
!61 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 107, size: 32, elements: !62)
!62 = !{!63}
!63 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !61, file: !6, line: 108, baseType: !38, size: 32)
!64 = !{i32 7, !"Dwarf Version", i32 5}
!65 = !{i32 2, !"Debug Info Version", i32 3}
!66 = !{i32 1, !"wchar_size", i32 4}
!67 = !{i32 8, !"PIC Level", i32 2}
!68 = !{i32 7, !"PIE Level", i32 2}
!69 = !{i32 7, !"uwtable", i32 2}
!70 = !{i32 7, !"frame-pointer", i32 2}
!71 = !{!"Homebrew clang version 19.1.7"}
!72 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 15, type: !73, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!73 = !DISubroutineType(types: !74)
!74 = !{!39, !39}
!75 = !{}
!76 = !DILocalVariable(name: "arg", arg: 1, scope: !72, file: !3, line: 15, type: !39)
!77 = !DILocation(line: 15, column: 17, scope: !72)
!78 = !DILocalVariable(name: "tid", scope: !72, file: !3, line: 17, type: !38)
!79 = !DILocation(line: 17, column: 9, scope: !72)
!80 = !DILocation(line: 17, column: 27, scope: !72)
!81 = !DILocation(line: 17, column: 16, scope: !72)
!82 = !DILocation(line: 17, column: 15, scope: !72)
!83 = !DILocation(line: 18, column: 13, scope: !72)
!84 = !DILocation(line: 18, column: 5, scope: !72)
!85 = !DILocation(line: 20, column: 11, scope: !86)
!86 = distinct !DILexicalBlock(scope: !72, file: !3, line: 18, column: 18)
!87 = !DILocation(line: 21, column: 9, scope: !86)
!88 = !DILocation(line: 22, column: 9, scope: !86)
!89 = !DILocation(line: 24, column: 9, scope: !86)
!90 = !DILocation(line: 25, column: 9, scope: !86)
!91 = !DILocation(line: 27, column: 13, scope: !92)
!92 = distinct !DILexicalBlock(scope: !86, file: !3, line: 27, column: 13)
!93 = !DILocation(line: 27, column: 42, scope: !92)
!94 = !DILocation(line: 27, column: 13, scope: !86)
!95 = !DILocation(line: 28, column: 13, scope: !96)
!96 = distinct !DILexicalBlock(scope: !92, file: !3, line: 27, column: 50)
!97 = !DILocation(line: 29, column: 9, scope: !96)
!98 = !DILocation(line: 30, column: 9, scope: !86)
!99 = !DILocation(line: 32, column: 5, scope: !72)
!100 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 34, type: !101, scopeLine: 35, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!101 = !DISubroutineType(types: !102)
!102 = !{!38}
!103 = !DILocalVariable(name: "t0", scope: !100, file: !3, line: 36, type: !104)
!104 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !105, line: 31, baseType: !106)
!105 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!106 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !107, line: 118, baseType: !108)
!107 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!109 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !107, line: 103, size: 65536, elements: !110)
!110 = !{!111, !112, !122}
!111 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !109, file: !107, line: 104, baseType: !34, size: 64)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !109, file: !107, line: 105, baseType: !113, size: 64, offset: 64)
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!114 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !107, line: 57, size: 192, elements: !115)
!115 = !{!116, !120, !121}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !114, file: !107, line: 58, baseType: !117, size: 64)
!117 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !118, size: 64)
!118 = !DISubroutineType(types: !119)
!119 = !{null, !39}
!120 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !114, file: !107, line: 59, baseType: !39, size: 64, offset: 64)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !114, file: !107, line: 60, baseType: !113, size: 64, offset: 128)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !109, file: !107, line: 106, baseType: !123, size: 65408, offset: 128)
!123 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 65408, elements: !124)
!124 = !{!125}
!125 = !DISubrange(count: 8176)
!126 = !DILocation(line: 36, column: 15, scope: !100)
!127 = !DILocalVariable(name: "t1", scope: !100, file: !3, line: 36, type: !104)
!128 = !DILocation(line: 36, column: 19, scope: !100)
!129 = !DILocalVariable(name: "t2", scope: !100, file: !3, line: 36, type: !104)
!130 = !DILocation(line: 36, column: 23, scope: !100)
!131 = !DILocation(line: 37, column: 5, scope: !100)
!132 = !DILocation(line: 38, column: 5, scope: !100)
!133 = !DILocation(line: 39, column: 5, scope: !100)
!134 = !DILocation(line: 41, column: 18, scope: !100)
!135 = !DILocation(line: 41, column: 5, scope: !100)
!136 = !DILocation(line: 42, column: 18, scope: !100)
!137 = !DILocation(line: 42, column: 5, scope: !100)
!138 = !DILocation(line: 43, column: 18, scope: !100)
!139 = !DILocation(line: 43, column: 5, scope: !100)
!140 = !DILocation(line: 45, column: 5, scope: !100)
