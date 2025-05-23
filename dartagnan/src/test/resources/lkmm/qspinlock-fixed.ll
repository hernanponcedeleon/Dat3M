; ModuleID = 'benchmarks/lkmm/qspinlock-fixed.c'
source_filename = "benchmarks/lkmm/qspinlock-fixed.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !50
@__func__.thread_3 = private unnamed_addr constant [9 x i8] c"thread_3\00", align 1, !dbg !36
@.str = private unnamed_addr constant [18 x i8] c"qspinlock-fixed.c\00", align 1, !dbg !43
@.str.1 = private unnamed_addr constant [18 x i8] c"READ_ONCE(x) == 1\00", align 1, !dbg !48

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !64 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !68, !DIExpression(), !69)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !70
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 2), !dbg !71
  ret ptr null, !dbg !72
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !73 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !74, !DIExpression(), !75)
  %3 = call i64 @__LKMM_atomic_fetch_op(ptr noundef @y, i64 noundef 4, i64 noundef 2, i32 noundef 2, i32 noundef 3), !dbg !76
  %4 = trunc i64 %3 to i32, !dbg !76
  ret ptr null, !dbg !77
}

declare i64 @__LKMM_atomic_fetch_op(ptr noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_3(ptr noundef %0) #0 !dbg !78 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !79, !DIExpression(), !80)
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 0), !dbg !81
  %4 = trunc i64 %3 to i32, !dbg !81
  %5 = and i32 %4, 1, !dbg !83
  %6 = icmp ne i32 %5, 0, !dbg !83
  br i1 %6, label %7, label %19, !dbg !84

7:                                                ; preds = %1
  call void @__LKMM_fence(i32 noundef 5), !dbg !85
  %8 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !87
  %9 = trunc i64 %8 to i32, !dbg !87
  %10 = icmp eq i32 %9, 1, !dbg !87
  %11 = xor i1 %10, true, !dbg !87
  %12 = zext i1 %11 to i32, !dbg !87
  %13 = sext i32 %12 to i64, !dbg !87
  %14 = icmp ne i64 %13, 0, !dbg !87
  br i1 %14, label %15, label %17, !dbg !87

15:                                               ; preds = %7
  call void @__assert_rtn(ptr noundef @__func__.thread_3, ptr noundef @.str, i32 noundef 26, ptr noundef @.str.1) #3, !dbg !87
  unreachable, !dbg !87

16:                                               ; No predecessors!
  br label %18, !dbg !87

17:                                               ; preds = %7
  br label %18, !dbg !87

18:                                               ; preds = %17, %16
  br label %19, !dbg !88

19:                                               ; preds = %18, %1
  ret ptr null, !dbg !89
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !90 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !93, !DIExpression(), !116)
    #dbg_declare(ptr %3, !117, !DIExpression(), !118)
    #dbg_declare(ptr %4, !119, !DIExpression(), !120)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !121
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !122
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @thread_3, ptr noundef null), !dbg !123
  %8 = load ptr, ptr %2, align 8, !dbg !124
  %9 = call i32 @_pthread_join(ptr noundef %8, ptr noundef null), !dbg !125
  %10 = load ptr, ptr %3, align 8, !dbg !126
  %11 = call i32 @_pthread_join(ptr noundef %10, ptr noundef null), !dbg !127
  %12 = load ptr, ptr %4, align 8, !dbg !128
  %13 = call i32 @_pthread_join(ptr noundef %12, ptr noundef null), !dbg !129
  ret i32 0, !dbg !130
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @_pthread_join(ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!56, !57, !58, !59, !60, !61, !62}
!llvm.ident = !{!63}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !34, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !28, globals: !35, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/qspinlock-fixed.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "e1f25ad8da1f6f799a5136ed5427fdb3")
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
!35 = !{!36, !43, !48, !0, !50}
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 72, elements: !41)
!39 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !40)
!40 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!41 = !{!42}
!42 = !DISubrange(count: 9)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !45, isLocal: true, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 144, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 18)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(scope: null, file: !3, line: 26, type: !45, isLocal: true, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !52, isLocal: false, isDefinition: true)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 108, baseType: !53)
!53 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 106, size: 32, elements: !54)
!54 = !{!55}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !53, file: !6, line: 107, baseType: !34, size: 32)
!56 = !{i32 7, !"Dwarf Version", i32 5}
!57 = !{i32 2, !"Debug Info Version", i32 3}
!58 = !{i32 1, !"wchar_size", i32 4}
!59 = !{i32 8, !"PIC Level", i32 2}
!60 = !{i32 7, !"PIE Level", i32 2}
!61 = !{i32 7, !"uwtable", i32 2}
!62 = !{i32 7, !"frame-pointer", i32 2}
!63 = !{!"Homebrew clang version 19.1.7"}
!64 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !65, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!65 = !DISubroutineType(types: !66)
!66 = !{!33, !33}
!67 = !{}
!68 = !DILocalVariable(name: "unused", arg: 1, scope: !64, file: !3, line: 9, type: !33)
!69 = !DILocation(line: 9, column: 22, scope: !64)
!70 = !DILocation(line: 11, column: 2, scope: !64)
!71 = !DILocation(line: 12, column: 2, scope: !64)
!72 = !DILocation(line: 13, column: 2, scope: !64)
!73 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 16, type: !65, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!74 = !DILocalVariable(name: "unused", arg: 1, scope: !73, file: !3, line: 16, type: !33)
!75 = !DILocation(line: 16, column: 22, scope: !73)
!76 = !DILocation(line: 18, column: 2, scope: !73)
!77 = !DILocation(line: 19, column: 2, scope: !73)
!78 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 22, type: !65, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!79 = !DILocalVariable(name: "unused", arg: 1, scope: !78, file: !3, line: 22, type: !33)
!80 = !DILocation(line: 22, column: 22, scope: !78)
!81 = !DILocation(line: 24, column: 7, scope: !82)
!82 = distinct !DILexicalBlock(scope: !78, file: !3, line: 24, column: 7)
!83 = !DILocation(line: 24, column: 23, scope: !82)
!84 = !DILocation(line: 24, column: 7, scope: !78)
!85 = !DILocation(line: 25, column: 4, scope: !86)
!86 = distinct !DILexicalBlock(scope: !82, file: !3, line: 24, column: 28)
!87 = !DILocation(line: 26, column: 4, scope: !86)
!88 = !DILocation(line: 27, column: 3, scope: !86)
!89 = !DILocation(line: 28, column: 2, scope: !78)
!90 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 31, type: !91, scopeLine: 32, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!91 = !DISubroutineType(types: !92)
!92 = !{!34}
!93 = !DILocalVariable(name: "t1", scope: !90, file: !3, line: 33, type: !94)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !95, line: 31, baseType: !96)
!95 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !97, line: 118, baseType: !98)
!97 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!99 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !97, line: 103, size: 65536, elements: !100)
!100 = !{!101, !102, !112}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !99, file: !97, line: 104, baseType: !32, size: 64)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !99, file: !97, line: 105, baseType: !103, size: 64, offset: 64)
!103 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!104 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !97, line: 57, size: 192, elements: !105)
!105 = !{!106, !110, !111}
!106 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !104, file: !97, line: 58, baseType: !107, size: 64)
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !108, size: 64)
!108 = !DISubroutineType(types: !109)
!109 = !{null, !33}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !104, file: !97, line: 59, baseType: !33, size: 64, offset: 64)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !104, file: !97, line: 60, baseType: !103, size: 64, offset: 128)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !99, file: !97, line: 106, baseType: !113, size: 65408, offset: 128)
!113 = !DICompositeType(tag: DW_TAG_array_type, baseType: !40, size: 65408, elements: !114)
!114 = !{!115}
!115 = !DISubrange(count: 8176)
!116 = !DILocation(line: 33, column: 12, scope: !90)
!117 = !DILocalVariable(name: "t2", scope: !90, file: !3, line: 33, type: !94)
!118 = !DILocation(line: 33, column: 16, scope: !90)
!119 = !DILocalVariable(name: "t3", scope: !90, file: !3, line: 33, type: !94)
!120 = !DILocation(line: 33, column: 20, scope: !90)
!121 = !DILocation(line: 35, column: 2, scope: !90)
!122 = !DILocation(line: 36, column: 2, scope: !90)
!123 = !DILocation(line: 37, column: 2, scope: !90)
!124 = !DILocation(line: 39, column: 15, scope: !90)
!125 = !DILocation(line: 39, column: 2, scope: !90)
!126 = !DILocation(line: 40, column: 15, scope: !90)
!127 = !DILocation(line: 40, column: 2, scope: !90)
!128 = !DILocation(line: 41, column: 15, scope: !90)
!129 = !DILocation(line: 41, column: 2, scope: !90)
!130 = !DILocation(line: 43, column: 2, scope: !90)
