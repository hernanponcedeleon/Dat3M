; ModuleID = 'benchmarks/lkmm/qspinlock.c'
source_filename = "benchmarks/lkmm/qspinlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !54
@__func__.thread_3 = private unnamed_addr constant [9 x i8] c"thread_3\00", align 1, !dbg !37
@.str = private unnamed_addr constant [12 x i8] c"qspinlock.c\00", align 1, !dbg !44
@.str.1 = private unnamed_addr constant [18 x i8] c"READ_ONCE(x) == 1\00", align 1, !dbg !49

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !68 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !72, !DIExpression(), !73)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !74
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 3), !dbg !75
  ret ptr null, !dbg !76
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !77 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !78, !DIExpression(), !79)
  %3 = call i64 @__LKMM_atomic_fetch_op(ptr noundef @y, i64 noundef 4, i64 noundef 2, i32 noundef 0, i32 noundef 3), !dbg !80
  %4 = trunc i64 %3 to i32, !dbg !80
  ret ptr null, !dbg !81
}

declare i64 @__LKMM_atomic_fetch_op(ptr noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_3(ptr noundef %0) #0 !dbg !82 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !83, !DIExpression(), !84)
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !85
  %4 = trunc i64 %3 to i32, !dbg !85
  %5 = and i32 %4, 1, !dbg !87
  %6 = icmp ne i32 %5, 0, !dbg !87
  br i1 %6, label %7, label %19, !dbg !88

7:                                                ; preds = %1
  call void @__LKMM_fence(i32 noundef 6), !dbg !89
  %8 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !91
  %9 = trunc i64 %8 to i32, !dbg !91
  %10 = icmp eq i32 %9, 1, !dbg !91
  %11 = xor i1 %10, true, !dbg !91
  %12 = zext i1 %11 to i32, !dbg !91
  %13 = sext i32 %12 to i64, !dbg !91
  %14 = icmp ne i64 %13, 0, !dbg !91
  br i1 %14, label %15, label %17, !dbg !91

15:                                               ; preds = %7
  call void @__assert_rtn(ptr noundef @__func__.thread_3, ptr noundef @.str, i32 noundef 26, ptr noundef @.str.1) #3, !dbg !91
  unreachable, !dbg !91

16:                                               ; No predecessors!
  br label %18, !dbg !91

17:                                               ; preds = %7
  br label %18, !dbg !91

18:                                               ; preds = %17, %16
  br label %19, !dbg !92

19:                                               ; preds = %18, %1
  ret ptr null, !dbg !93
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !94 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !97, !DIExpression(), !120)
    #dbg_declare(ptr %3, !121, !DIExpression(), !122)
    #dbg_declare(ptr %4, !123, !DIExpression(), !124)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !125
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !126
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @thread_3, ptr noundef null), !dbg !127
  %8 = load ptr, ptr %2, align 8, !dbg !128
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !129
  %10 = load ptr, ptr %3, align 8, !dbg !130
  %11 = call i32 @_pthread_join(ptr noundef %10, ptr noundef null), !dbg !131
  %12 = load ptr, ptr %4, align 8, !dbg !132
  %13 = call i32 @_pthread_join(ptr noundef %12, ptr noundef null), !dbg !133
  ret i32 0, !dbg !134
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @_pthread_join(ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!60, !61, !62, !63, !64, !65, !66}
!llvm.ident = !{!67}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !35, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !36, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/qspinlock.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "c600e4091a20e0f808017d68911496eb")
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
!29 = !{!30, !34, !35}
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !31)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !32, line: 32, baseType: !33)
!32 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!33 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!35 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!36 = !{!37, !44, !49, !0, !54}
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 72, elements: !42)
!40 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !41)
!41 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!42 = !{!43}
!43 = !DISubrange(count: 9)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !46, isLocal: true, isDefinition: true)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 96, elements: !47)
!47 = !{!48}
!48 = !DISubrange(count: 12)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !51, isLocal: true, isDefinition: true)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 144, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 18)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !56, isLocal: false, isDefinition: true)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 109, baseType: !57)
!57 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 107, size: 32, elements: !58)
!58 = !{!59}
!59 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !57, file: !6, line: 108, baseType: !35, size: 32)
!60 = !{i32 7, !"Dwarf Version", i32 5}
!61 = !{i32 2, !"Debug Info Version", i32 3}
!62 = !{i32 1, !"wchar_size", i32 4}
!63 = !{i32 8, !"PIC Level", i32 2}
!64 = !{i32 7, !"PIE Level", i32 2}
!65 = !{i32 7, !"uwtable", i32 2}
!66 = !{i32 7, !"frame-pointer", i32 2}
!67 = !{!"Homebrew clang version 19.1.7"}
!68 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !69, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!69 = !DISubroutineType(types: !70)
!70 = !{!34, !34}
!71 = !{}
!72 = !DILocalVariable(name: "unused", arg: 1, scope: !68, file: !3, line: 9, type: !34)
!73 = !DILocation(line: 9, column: 22, scope: !68)
!74 = !DILocation(line: 11, column: 2, scope: !68)
!75 = !DILocation(line: 12, column: 2, scope: !68)
!76 = !DILocation(line: 13, column: 2, scope: !68)
!77 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 16, type: !69, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!78 = !DILocalVariable(name: "unused", arg: 1, scope: !77, file: !3, line: 16, type: !34)
!79 = !DILocation(line: 16, column: 22, scope: !77)
!80 = !DILocation(line: 18, column: 2, scope: !77)
!81 = !DILocation(line: 19, column: 2, scope: !77)
!82 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 22, type: !69, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!83 = !DILocalVariable(name: "unused", arg: 1, scope: !82, file: !3, line: 22, type: !34)
!84 = !DILocation(line: 22, column: 22, scope: !82)
!85 = !DILocation(line: 24, column: 7, scope: !86)
!86 = distinct !DILexicalBlock(scope: !82, file: !3, line: 24, column: 7)
!87 = !DILocation(line: 24, column: 23, scope: !86)
!88 = !DILocation(line: 24, column: 7, scope: !82)
!89 = !DILocation(line: 25, column: 4, scope: !90)
!90 = distinct !DILexicalBlock(scope: !86, file: !3, line: 24, column: 28)
!91 = !DILocation(line: 26, column: 4, scope: !90)
!92 = !DILocation(line: 27, column: 3, scope: !90)
!93 = !DILocation(line: 28, column: 2, scope: !82)
!94 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 31, type: !95, scopeLine: 32, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!95 = !DISubroutineType(types: !96)
!96 = !{!35}
!97 = !DILocalVariable(name: "t1", scope: !94, file: !3, line: 33, type: !98)
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
!117 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 65408, elements: !118)
!118 = !{!119}
!119 = !DISubrange(count: 8176)
!120 = !DILocation(line: 33, column: 12, scope: !94)
!121 = !DILocalVariable(name: "t2", scope: !94, file: !3, line: 33, type: !98)
!122 = !DILocation(line: 33, column: 16, scope: !94)
!123 = !DILocalVariable(name: "t3", scope: !94, file: !3, line: 33, type: !98)
!124 = !DILocation(line: 33, column: 20, scope: !94)
!125 = !DILocation(line: 35, column: 2, scope: !94)
!126 = !DILocation(line: 36, column: 2, scope: !94)
!127 = !DILocation(line: 37, column: 2, scope: !94)
!128 = !DILocation(line: 39, column: 15, scope: !94)
!129 = !DILocation(line: 39, column: 2, scope: !94)
!130 = !DILocation(line: 40, column: 15, scope: !94)
!131 = !DILocation(line: 40, column: 2, scope: !94)
!132 = !DILocation(line: 41, column: 15, scope: !94)
!133 = !DILocation(line: 41, column: 2, scope: !94)
!134 = !DILocation(line: 43, column: 2, scope: !94)
