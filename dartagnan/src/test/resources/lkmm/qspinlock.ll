; ModuleID = 'benchmarks/lkmm/qspinlock.c'
source_filename = "benchmarks/lkmm/qspinlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !53
@__func__.thread_3 = private unnamed_addr constant [9 x i8] c"thread_3\00", align 1, !dbg !36
@.str = private unnamed_addr constant [12 x i8] c"qspinlock.c\00", align 1, !dbg !43
@.str.1 = private unnamed_addr constant [18 x i8] c"READ_ONCE(x) == 1\00", align 1, !dbg !48

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !67 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !71, !DIExpression(), !72)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !73
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 2), !dbg !74
  ret ptr null, !dbg !75
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !76 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !77, !DIExpression(), !78)
  %3 = call i64 @__LKMM_atomic_fetch_op(ptr noundef @y, i64 noundef 4, i64 noundef 2, i32 noundef 0, i32 noundef 3), !dbg !79
  %4 = trunc i64 %3 to i32, !dbg !79
  ret ptr null, !dbg !80
}

declare i64 @__LKMM_atomic_fetch_op(ptr noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_3(ptr noundef %0) #0 !dbg !81 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !82, !DIExpression(), !83)
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 0), !dbg !84
  %4 = trunc i64 %3 to i32, !dbg !84
  %5 = and i32 %4, 1, !dbg !86
  %6 = icmp ne i32 %5, 0, !dbg !86
  br i1 %6, label %7, label %19, !dbg !87

7:                                                ; preds = %1
  call void @__LKMM_fence(i32 noundef 5), !dbg !88
  %8 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !90
  %9 = trunc i64 %8 to i32, !dbg !90
  %10 = icmp eq i32 %9, 1, !dbg !90
  %11 = xor i1 %10, true, !dbg !90
  %12 = zext i1 %11 to i32, !dbg !90
  %13 = sext i32 %12 to i64, !dbg !90
  %14 = icmp ne i64 %13, 0, !dbg !90
  br i1 %14, label %15, label %17, !dbg !90

15:                                               ; preds = %7
  call void @__assert_rtn(ptr noundef @__func__.thread_3, ptr noundef @.str, i32 noundef 26, ptr noundef @.str.1) #3, !dbg !90
  unreachable, !dbg !90

16:                                               ; No predecessors!
  br label %18, !dbg !90

17:                                               ; preds = %7
  br label %18, !dbg !90

18:                                               ; preds = %17, %16
  br label %19, !dbg !91

19:                                               ; preds = %18, %1
  ret ptr null, !dbg !92
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !93 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !96, !DIExpression(), !119)
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
!llvm.module.flags = !{!59, !60, !61, !62, !63, !64, !65}
!llvm.ident = !{!66}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !34, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !28, globals: !35, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/qspinlock.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "c600e4091a20e0f808017d68911496eb")
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
!28 = !{!29, !33, !34}
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 27, baseType: !30)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !31, line: 32, baseType: !32)
!31 = !DIFile(filename: "/usr/local/include/_types/_intmax_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e37b9240f30f486478152ef3989b1545")
!32 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!34 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!35 = !{!36, !43, !48, !0, !53}
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 72, elements: !41)
!39 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !40)
!40 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!41 = !{!42}
!42 = !DISubrange(count: 9)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 96, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 12)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !50, isLocal: true, isDefinition: true)
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 144, elements: !51)
!51 = !{!52}
!52 = !DISubrange(count: 18)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !55, isLocal: false, isDefinition: true)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 108, baseType: !56)
!56 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 106, size: 32, elements: !57)
!57 = !{!58}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !56, file: !6, line: 107, baseType: !34, size: 32)
!59 = !{i32 7, !"Dwarf Version", i32 5}
!60 = !{i32 2, !"Debug Info Version", i32 3}
!61 = !{i32 1, !"wchar_size", i32 4}
!62 = !{i32 8, !"PIC Level", i32 2}
!63 = !{i32 7, !"PIE Level", i32 2}
!64 = !{i32 7, !"uwtable", i32 2}
!65 = !{i32 7, !"frame-pointer", i32 2}
!66 = !{!"Homebrew clang version 19.1.7"}
!67 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !68, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!68 = !DISubroutineType(types: !69)
!69 = !{!33, !33}
!70 = !{}
!71 = !DILocalVariable(name: "unused", arg: 1, scope: !67, file: !3, line: 9, type: !33)
!72 = !DILocation(line: 9, column: 22, scope: !67)
!73 = !DILocation(line: 11, column: 2, scope: !67)
!74 = !DILocation(line: 12, column: 2, scope: !67)
!75 = !DILocation(line: 13, column: 2, scope: !67)
!76 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 16, type: !68, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!77 = !DILocalVariable(name: "unused", arg: 1, scope: !76, file: !3, line: 16, type: !33)
!78 = !DILocation(line: 16, column: 22, scope: !76)
!79 = !DILocation(line: 18, column: 2, scope: !76)
!80 = !DILocation(line: 19, column: 2, scope: !76)
!81 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 22, type: !68, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!82 = !DILocalVariable(name: "unused", arg: 1, scope: !81, file: !3, line: 22, type: !33)
!83 = !DILocation(line: 22, column: 22, scope: !81)
!84 = !DILocation(line: 24, column: 7, scope: !85)
!85 = distinct !DILexicalBlock(scope: !81, file: !3, line: 24, column: 7)
!86 = !DILocation(line: 24, column: 23, scope: !85)
!87 = !DILocation(line: 24, column: 7, scope: !81)
!88 = !DILocation(line: 25, column: 4, scope: !89)
!89 = distinct !DILexicalBlock(scope: !85, file: !3, line: 24, column: 28)
!90 = !DILocation(line: 26, column: 4, scope: !89)
!91 = !DILocation(line: 27, column: 3, scope: !89)
!92 = !DILocation(line: 28, column: 2, scope: !81)
!93 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 31, type: !94, scopeLine: 32, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!94 = !DISubroutineType(types: !95)
!95 = !{!34}
!96 = !DILocalVariable(name: "t1", scope: !93, file: !3, line: 33, type: !97)
!97 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !98, line: 31, baseType: !99)
!98 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !100, line: 118, baseType: !101)
!100 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !102, size: 64)
!102 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !100, line: 103, size: 65536, elements: !103)
!103 = !{!104, !105, !115}
!104 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !102, file: !100, line: 104, baseType: !32, size: 64)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !102, file: !100, line: 105, baseType: !106, size: 64, offset: 64)
!106 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !107, size: 64)
!107 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !100, line: 57, size: 192, elements: !108)
!108 = !{!109, !113, !114}
!109 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !107, file: !100, line: 58, baseType: !110, size: 64)
!110 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !111, size: 64)
!111 = !DISubroutineType(types: !112)
!112 = !{null, !33}
!113 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !107, file: !100, line: 59, baseType: !33, size: 64, offset: 64)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !107, file: !100, line: 60, baseType: !106, size: 64, offset: 128)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !102, file: !100, line: 106, baseType: !116, size: 65408, offset: 128)
!116 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 65408, elements: !117)
!117 = !{!118}
!118 = !DISubrange(count: 8176)
!119 = !DILocation(line: 33, column: 12, scope: !93)
!120 = !DILocalVariable(name: "t2", scope: !93, file: !3, line: 33, type: !97)
!121 = !DILocation(line: 33, column: 16, scope: !93)
!122 = !DILocalVariable(name: "t3", scope: !93, file: !3, line: 33, type: !97)
!123 = !DILocation(line: 33, column: 20, scope: !93)
!124 = !DILocation(line: 35, column: 2, scope: !93)
!125 = !DILocation(line: 36, column: 2, scope: !93)
!126 = !DILocation(line: 37, column: 2, scope: !93)
!127 = !DILocation(line: 39, column: 15, scope: !93)
!128 = !DILocation(line: 39, column: 2, scope: !93)
!129 = !DILocation(line: 40, column: 15, scope: !93)
!130 = !DILocation(line: 40, column: 2, scope: !93)
!131 = !DILocation(line: 41, column: 15, scope: !93)
!132 = !DILocation(line: 41, column: 2, scope: !93)
!133 = !DILocation(line: 43, column: 2, scope: !93)
