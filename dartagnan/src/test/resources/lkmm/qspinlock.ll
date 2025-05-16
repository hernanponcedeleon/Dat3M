; ModuleID = 'benchmarks/lkmm/qspinlock.c'
source_filename = "benchmarks/lkmm/qspinlock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.atomic_t = type { i32 }

@x = global i32 0, align 4, !dbg !0
@y = global %struct.atomic_t zeroinitializer, align 4, !dbg !52
@__func__.thread_3 = private unnamed_addr constant [9 x i8] c"thread_3\00", align 1, !dbg !35
@.str = private unnamed_addr constant [12 x i8] c"qspinlock.c\00", align 1, !dbg !42
@.str.1 = private unnamed_addr constant [18 x i8] c"READ_ONCE(x) == 1\00", align 1, !dbg !47

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_1(ptr noundef %0) #0 !dbg !65 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !69, !DIExpression(), !70)
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !71
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 3), !dbg !72
  ret ptr null, !dbg !73
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_2(ptr noundef %0) #0 !dbg !74 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !75, !DIExpression(), !76)
  %3 = call i64 @__LKMM_atomic_fetch_op(ptr noundef @y, i64 noundef 4, i64 noundef 2, i32 noundef 0, i32 noundef 3), !dbg !77
  %4 = trunc i64 %3 to i32, !dbg !77
  ret ptr null, !dbg !78
}

declare i64 @__LKMM_atomic_fetch_op(ptr noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_3(ptr noundef %0) #0 !dbg !79 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !80, !DIExpression(), !81)
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !82
  %4 = trunc i64 %3 to i32, !dbg !82
  %5 = and i32 %4, 1, !dbg !84
  %6 = icmp ne i32 %5, 0, !dbg !84
  br i1 %6, label %7, label %19, !dbg !85

7:                                                ; preds = %1
  call void @__LKMM_fence(i32 noundef 6), !dbg !86
  %8 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !88
  %9 = trunc i64 %8 to i32, !dbg !88
  %10 = icmp eq i32 %9, 1, !dbg !88
  %11 = xor i1 %10, true, !dbg !88
  %12 = zext i1 %11 to i32, !dbg !88
  %13 = sext i32 %12 to i64, !dbg !88
  %14 = icmp ne i64 %13, 0, !dbg !88
  br i1 %14, label %15, label %17, !dbg !88

15:                                               ; preds = %7
  call void @__assert_rtn(ptr noundef @__func__.thread_3, ptr noundef @.str, i32 noundef 26, ptr noundef @.str.1) #3, !dbg !88
  unreachable, !dbg !88

16:                                               ; No predecessors!
  br label %18, !dbg !88

17:                                               ; preds = %7
  br label %18, !dbg !88

18:                                               ; preds = %17, %16
  br label %19, !dbg !89

19:                                               ; preds = %18, %1
  ret ptr null, !dbg !90
}

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !91 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !94, !DIExpression(), !118)
    #dbg_declare(ptr %3, !119, !DIExpression(), !120)
    #dbg_declare(ptr %4, !121, !DIExpression(), !122)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !123
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !124
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @thread_3, ptr noundef null), !dbg !125
  %8 = load ptr, ptr %2, align 8, !dbg !126
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !127
  %10 = load ptr, ptr %3, align 8, !dbg !128
  %11 = call i32 @"\01_pthread_join"(ptr noundef %10, ptr noundef null), !dbg !129
  %12 = load ptr, ptr %4, align 8, !dbg !130
  %13 = call i32 @"\01_pthread_join"(ptr noundef %12, ptr noundef null), !dbg !131
  ret i32 0, !dbg !132
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!58, !59, !60, !61, !62, !63}
!llvm.ident = !{!64}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 6, type: !33, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !34, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
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
!62 = !{i32 7, !"uwtable", i32 1}
!63 = !{i32 7, !"frame-pointer", i32 1}
!64 = !{!"Homebrew clang version 19.1.7"}
!65 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !66, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!66 = !DISubroutineType(types: !67)
!67 = !{!32, !32}
!68 = !{}
!69 = !DILocalVariable(name: "unused", arg: 1, scope: !65, file: !3, line: 9, type: !32)
!70 = !DILocation(line: 9, column: 22, scope: !65)
!71 = !DILocation(line: 11, column: 2, scope: !65)
!72 = !DILocation(line: 12, column: 2, scope: !65)
!73 = !DILocation(line: 13, column: 2, scope: !65)
!74 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 16, type: !66, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!75 = !DILocalVariable(name: "unused", arg: 1, scope: !74, file: !3, line: 16, type: !32)
!76 = !DILocation(line: 16, column: 22, scope: !74)
!77 = !DILocation(line: 18, column: 2, scope: !74)
!78 = !DILocation(line: 19, column: 2, scope: !74)
!79 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 22, type: !66, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!80 = !DILocalVariable(name: "unused", arg: 1, scope: !79, file: !3, line: 22, type: !32)
!81 = !DILocation(line: 22, column: 22, scope: !79)
!82 = !DILocation(line: 24, column: 7, scope: !83)
!83 = distinct !DILexicalBlock(scope: !79, file: !3, line: 24, column: 7)
!84 = !DILocation(line: 24, column: 23, scope: !83)
!85 = !DILocation(line: 24, column: 7, scope: !79)
!86 = !DILocation(line: 25, column: 4, scope: !87)
!87 = distinct !DILexicalBlock(scope: !83, file: !3, line: 24, column: 28)
!88 = !DILocation(line: 26, column: 4, scope: !87)
!89 = !DILocation(line: 27, column: 3, scope: !87)
!90 = !DILocation(line: 28, column: 2, scope: !79)
!91 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 31, type: !92, scopeLine: 32, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!92 = !DISubroutineType(types: !93)
!93 = !{!33}
!94 = !DILocalVariable(name: "t1", scope: !91, file: !3, line: 33, type: !95)
!95 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !96, line: 31, baseType: !97)
!96 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!97 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !98, line: 118, baseType: !99)
!98 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!99 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64)
!100 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !98, line: 103, size: 65536, elements: !101)
!101 = !{!102, !104, !114}
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !100, file: !98, line: 104, baseType: !103, size: 64)
!103 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !100, file: !98, line: 105, baseType: !105, size: 64, offset: 64)
!105 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !106, size: 64)
!106 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !98, line: 57, size: 192, elements: !107)
!107 = !{!108, !112, !113}
!108 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !106, file: !98, line: 58, baseType: !109, size: 64)
!109 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !110, size: 64)
!110 = !DISubroutineType(types: !111)
!111 = !{null, !32}
!112 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !106, file: !98, line: 59, baseType: !32, size: 64, offset: 64)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !106, file: !98, line: 60, baseType: !105, size: 64, offset: 128)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !100, file: !98, line: 106, baseType: !115, size: 65408, offset: 128)
!115 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 65408, elements: !116)
!116 = !{!117}
!117 = !DISubrange(count: 8176)
!118 = !DILocation(line: 33, column: 12, scope: !91)
!119 = !DILocalVariable(name: "t2", scope: !91, file: !3, line: 33, type: !95)
!120 = !DILocation(line: 33, column: 16, scope: !91)
!121 = !DILocalVariable(name: "t3", scope: !91, file: !3, line: 33, type: !95)
!122 = !DILocation(line: 33, column: 20, scope: !91)
!123 = !DILocation(line: 35, column: 2, scope: !91)
!124 = !DILocation(line: 36, column: 2, scope: !91)
!125 = !DILocation(line: 37, column: 2, scope: !91)
!126 = !DILocation(line: 39, column: 15, scope: !91)
!127 = !DILocation(line: 39, column: 2, scope: !91)
!128 = !DILocation(line: 40, column: 15, scope: !91)
!129 = !DILocation(line: 40, column: 2, scope: !91)
!130 = !DILocation(line: 41, column: 15, scope: !91)
!131 = !DILocation(line: 41, column: 2, scope: !91)
!132 = !DILocation(line: 43, column: 2, scope: !91)
