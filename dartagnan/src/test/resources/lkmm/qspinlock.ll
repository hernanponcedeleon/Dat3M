; ModuleID = 'benchmarks/lkmm/qspinlock.c'
source_filename = "benchmarks/lkmm/qspinlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !52
@__func__.thread_3 = private unnamed_addr constant [9 x i8] c"thread_3\00", align 1, !dbg !35
@.str = private unnamed_addr constant [12 x i8] c"qspinlock.c\00", align 1, !dbg !42
@.str.1 = private unnamed_addr constant [18 x i8] c"READ_ONCE(x) == 1\00", align 1, !dbg !47

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !66 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !70, !DIExpression(), !71)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !72
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 3), !dbg !73
  ret ptr null, !dbg !74
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !75 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !76, !DIExpression(), !77)
  %3 = call i64 @__LKMM_atomic_fetch_op(ptr noundef @y, i64 noundef 4, i64 noundef 2, i32 noundef 0, i32 noundef 3), !dbg !78
  %4 = trunc i64 %3 to i32, !dbg !78
  ret ptr null, !dbg !79
}

declare i64 @__LKMM_atomic_fetch_op(ptr noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_3(ptr noundef %0) #0 !dbg !80 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !81, !DIExpression(), !82)
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !83
  %4 = trunc i64 %3 to i32, !dbg !83
  %5 = and i32 %4, 1, !dbg !85
  %6 = icmp ne i32 %5, 0, !dbg !85
  br i1 %6, label %7, label %19, !dbg !86

7:                                                ; preds = %1
  call void @__LKMM_fence(i32 noundef 6), !dbg !87
  %8 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !89
  %9 = trunc i64 %8 to i32, !dbg !89
  %10 = icmp eq i32 %9, 1, !dbg !89
  %11 = xor i1 %10, true, !dbg !89
  %12 = zext i1 %11 to i32, !dbg !89
  %13 = sext i32 %12 to i64, !dbg !89
  %14 = icmp ne i64 %13, 0, !dbg !89
  br i1 %14, label %15, label %17, !dbg !89

15:                                               ; preds = %7
  call void @__assert_rtn(ptr noundef @__func__.thread_3, ptr noundef @.str, i32 noundef 26, ptr noundef @.str.1) #3, !dbg !89
  unreachable, !dbg !89

16:                                               ; No predecessors!
  br label %18, !dbg !89

17:                                               ; preds = %7
  br label %18, !dbg !89

18:                                               ; preds = %17, %16
  br label %19, !dbg !90

19:                                               ; preds = %18, %1
  ret ptr null, !dbg !91
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !92 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !95, !DIExpression(), !119)
    #dbg_declare(ptr %3, !120, !DIExpression(), !121)
    #dbg_declare(ptr %4, !122, !DIExpression(), !123)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !124
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !125
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @thread_3, ptr noundef null), !dbg !126
  %8 = load ptr, ptr %2, align 8, !dbg !127
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !128
  %10 = load ptr, ptr %3, align 8, !dbg !129
  %11 = call i32 @_pthread_join(ptr noundef %10, ptr noundef null), !dbg !130
  %12 = load ptr, ptr %4, align 8, !dbg !131
  %13 = call i32 @_pthread_join(ptr noundef %12, ptr noundef null), !dbg !132
  ret i32 0, !dbg !133
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @_pthread_join(ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!58, !59, !60, !61, !62, !63, !64}
!llvm.ident = !{!65}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !33, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !34, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/qspinlock.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "c600e4091a20e0f808017d68911496eb")
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
!29 = !{!30, !32, !33}
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 28, baseType: !31)
!31 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!33 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!34 = !{!35, !42, !47, !0, !52}
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !37, isLocal: true, isDefinition: true)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 72, elements: !40)
!38 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !39)
!39 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!40 = !{!41}
!41 = !DISubrange(count: 9)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 96, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 12)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !49, isLocal: true, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 144, elements: !50)
!50 = !{!51}
!51 = !DISubrange(count: 18)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !54, isLocal: false, isDefinition: true)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 109, baseType: !55)
!55 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 107, size: 32, elements: !56)
!56 = !{!57}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !55, file: !6, line: 108, baseType: !33, size: 32)
!58 = !{i32 7, !"Dwarf Version", i32 5}
!59 = !{i32 2, !"Debug Info Version", i32 3}
!60 = !{i32 1, !"wchar_size", i32 4}
!61 = !{i32 8, !"PIC Level", i32 2}
!62 = !{i32 7, !"PIE Level", i32 2}
!63 = !{i32 7, !"uwtable", i32 2}
!64 = !{i32 7, !"frame-pointer", i32 2}
!65 = !{!"Homebrew clang version 19.1.7"}
!66 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !67, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !69)
!67 = !DISubroutineType(types: !68)
!68 = !{!32, !32}
!69 = !{}
!70 = !DILocalVariable(name: "unused", arg: 1, scope: !66, file: !3, line: 9, type: !32)
!71 = !DILocation(line: 9, column: 22, scope: !66)
!72 = !DILocation(line: 11, column: 2, scope: !66)
!73 = !DILocation(line: 12, column: 2, scope: !66)
!74 = !DILocation(line: 13, column: 2, scope: !66)
!75 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 16, type: !67, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !69)
!76 = !DILocalVariable(name: "unused", arg: 1, scope: !75, file: !3, line: 16, type: !32)
!77 = !DILocation(line: 16, column: 22, scope: !75)
!78 = !DILocation(line: 18, column: 2, scope: !75)
!79 = !DILocation(line: 19, column: 2, scope: !75)
!80 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 22, type: !67, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !69)
!81 = !DILocalVariable(name: "unused", arg: 1, scope: !80, file: !3, line: 22, type: !32)
!82 = !DILocation(line: 22, column: 22, scope: !80)
!83 = !DILocation(line: 24, column: 7, scope: !84)
!84 = distinct !DILexicalBlock(scope: !80, file: !3, line: 24, column: 7)
!85 = !DILocation(line: 24, column: 23, scope: !84)
!86 = !DILocation(line: 24, column: 7, scope: !80)
!87 = !DILocation(line: 25, column: 4, scope: !88)
!88 = distinct !DILexicalBlock(scope: !84, file: !3, line: 24, column: 28)
!89 = !DILocation(line: 26, column: 4, scope: !88)
!90 = !DILocation(line: 27, column: 3, scope: !88)
!91 = !DILocation(line: 28, column: 2, scope: !80)
!92 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 31, type: !93, scopeLine: 32, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !69)
!93 = !DISubroutineType(types: !94)
!94 = !{!33}
!95 = !DILocalVariable(name: "t1", scope: !92, file: !3, line: 33, type: !96)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !97, line: 31, baseType: !98)
!97 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!98 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !99, line: 118, baseType: !100)
!99 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!100 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!101 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !99, line: 103, size: 65536, elements: !102)
!102 = !{!103, !105, !115}
!103 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !101, file: !99, line: 104, baseType: !104, size: 64)
!104 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !101, file: !99, line: 105, baseType: !106, size: 64, offset: 64)
!106 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !107, size: 64)
!107 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !99, line: 57, size: 192, elements: !108)
!108 = !{!109, !113, !114}
!109 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !107, file: !99, line: 58, baseType: !110, size: 64)
!110 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !111, size: 64)
!111 = !DISubroutineType(types: !112)
!112 = !{null, !32}
!113 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !107, file: !99, line: 59, baseType: !32, size: 64, offset: 64)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !107, file: !99, line: 60, baseType: !106, size: 64, offset: 128)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !101, file: !99, line: 106, baseType: !116, size: 65408, offset: 128)
!116 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 65408, elements: !117)
!117 = !{!118}
!118 = !DISubrange(count: 8176)
!119 = !DILocation(line: 33, column: 12, scope: !92)
!120 = !DILocalVariable(name: "t2", scope: !92, file: !3, line: 33, type: !96)
!121 = !DILocation(line: 33, column: 16, scope: !92)
!122 = !DILocalVariable(name: "t3", scope: !92, file: !3, line: 33, type: !96)
!123 = !DILocation(line: 33, column: 20, scope: !92)
!124 = !DILocation(line: 35, column: 2, scope: !92)
!125 = !DILocation(line: 36, column: 2, scope: !92)
!126 = !DILocation(line: 37, column: 2, scope: !92)
!127 = !DILocation(line: 39, column: 15, scope: !92)
!128 = !DILocation(line: 39, column: 2, scope: !92)
!129 = !DILocation(line: 40, column: 15, scope: !92)
!130 = !DILocation(line: 40, column: 2, scope: !92)
!131 = !DILocation(line: 41, column: 15, scope: !92)
!132 = !DILocation(line: 41, column: 2, scope: !92)
!133 = !DILocation(line: 43, column: 2, scope: !92)
