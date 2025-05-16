; ModuleID = 'benchmarks/lkmm/qspinlock-liveness.c'
source_filename = "benchmarks/lkmm/qspinlock-liveness.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.atomic_t = type { i32 }

@x = global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !35
@z = global i32 0, align 4, !dbg !37

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_1(ptr noundef %0) #0 !dbg !50 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !54, !DIExpression(), !55)
    #dbg_declare(ptr %3, !56, !DIExpression(), !57)
  %4 = call i64 @__LKMM_atomic_fetch_op(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 4, i32 noundef 0), !dbg !58
  %5 = trunc i64 %4 to i32, !dbg !58
  store i32 %5, ptr %3, align 4, !dbg !57
  ret ptr null, !dbg !59
}

declare i64 @__LKMM_atomic_fetch_op(ptr noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_2(ptr noundef %0) #0 !dbg !60 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !61, !DIExpression(), !62)
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !63
    #dbg_declare(ptr %3, !64, !DIExpression(), !65)
  %5 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !66
  %6 = trunc i64 %5 to i32, !dbg !66
  store i32 %6, ptr %3, align 4, !dbg !65
  call void @__LKMM_fence(i32 noundef 5), !dbg !67
    #dbg_declare(ptr %4, !68, !DIExpression(), !69)
  %7 = load i32, ptr %3, align 4, !dbg !70
  %8 = sext i32 %7 to i64, !dbg !70
  %9 = call i64 @__LKMM_cmpxchg(ptr noundef @x, i64 noundef 4, i64 noundef %8, i64 noundef 42, i32 noundef 0, i32 noundef 0), !dbg !70
  %10 = trunc i64 %9 to i32, !dbg !70
  store i32 %10, ptr %4, align 4, !dbg !69
  call void @__LKMM_store(ptr noundef @z, i64 noundef 4, i64 noundef 1, i32 noundef 1), !dbg !71
  ret ptr null, !dbg !72
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

declare i64 @__LKMM_cmpxchg(ptr noundef, i64 noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_3(ptr noundef %0) #0 !dbg !73 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !74, !DIExpression(), !75)
  call void @__LKMM_store(ptr noundef @z, i64 noundef 4, i64 noundef 2, i32 noundef 1), !dbg !76
    #dbg_declare(ptr %3, !77, !DIExpression(), !78)
  %5 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 1), !dbg !79
  %6 = trunc i64 %5 to i32, !dbg !79
  store i32 %6, ptr %3, align 4, !dbg !78
  call void @__LKMM_fence(i32 noundef 5), !dbg !80
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 0, i32 noundef 1), !dbg !81
    #dbg_declare(ptr %4, !82, !DIExpression(), !83)
  %7 = load i32, ptr %3, align 4, !dbg !84
  %8 = sext i32 %7 to i64, !dbg !84
  %9 = call i64 @__LKMM_cmpxchg(ptr noundef @x, i64 noundef 4, i64 noundef %8, i64 noundef 24, i32 noundef 0, i32 noundef 0), !dbg !84
  %10 = trunc i64 %9 to i32, !dbg !84
  store i32 %10, ptr %4, align 4, !dbg !83
  br label %11, !dbg !85

11:                                               ; preds = %21, %1
  %12 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 1), !dbg !86
  %13 = trunc i64 %12 to i32, !dbg !86
  %14 = icmp eq i32 %13, 1, !dbg !87
  br i1 %14, label %15, label %19, !dbg !88

15:                                               ; preds = %11
  %16 = call i64 @__LKMM_load(ptr noundef @z, i64 noundef 4, i32 noundef 1), !dbg !89
  %17 = trunc i64 %16 to i32, !dbg !89
  %18 = icmp eq i32 %17, 2, !dbg !90
  br label %19

19:                                               ; preds = %15, %11
  %20 = phi i1 [ false, %11 ], [ %18, %15 ], !dbg !91
  br i1 %20, label %21, label %22, !dbg !85

21:                                               ; preds = %19
  br label %11, !dbg !85, !llvm.loop !92

22:                                               ; preds = %19
  ret ptr null, !dbg !95
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !96 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !99, !DIExpression(), !124)
    #dbg_declare(ptr %3, !125, !DIExpression(), !126)
    #dbg_declare(ptr %4, !127, !DIExpression(), !128)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !129
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !130
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @thread_3, ptr noundef null), !dbg !131
  ret i32 0, !dbg !132
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!43, !44, !45, !46, !47, !48}
!llvm.ident = !{!49}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !39, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !34, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/lkmm/qspinlock-liveness.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "62cffcfdbbfe2e2b84cb01226603616c")
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
!34 = !{!35, !37, !0}
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 6, type: !30, isLocal: false, isDefinition: true)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !3, line: 6, type: !30, isLocal: false, isDefinition: true)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 109, baseType: !40)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 107, size: 32, elements: !41)
!41 = !{!42}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !40, file: !6, line: 108, baseType: !30, size: 32)
!43 = !{i32 7, !"Dwarf Version", i32 5}
!44 = !{i32 2, !"Debug Info Version", i32 3}
!45 = !{i32 1, !"wchar_size", i32 4}
!46 = !{i32 8, !"PIC Level", i32 2}
!47 = !{i32 7, !"uwtable", i32 1}
!48 = !{i32 7, !"frame-pointer", i32 1}
!49 = !{!"Homebrew clang version 19.1.7"}
!50 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !51, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!51 = !DISubroutineType(types: !52)
!52 = !{!33, !33}
!53 = !{}
!54 = !DILocalVariable(name: "unused", arg: 1, scope: !50, file: !3, line: 9, type: !33)
!55 = !DILocation(line: 9, column: 22, scope: !50)
!56 = !DILocalVariable(name: "r0", scope: !50, file: !3, line: 12, type: !30)
!57 = !DILocation(line: 12, column: 9, scope: !50)
!58 = !DILocation(line: 12, column: 14, scope: !50)
!59 = !DILocation(line: 13, column: 5, scope: !50)
!60 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 16, type: !51, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!61 = !DILocalVariable(name: "unused", arg: 1, scope: !60, file: !3, line: 16, type: !33)
!62 = !DILocation(line: 16, column: 22, scope: !60)
!63 = !DILocation(line: 19, column: 5, scope: !60)
!64 = !DILocalVariable(name: "r0", scope: !60, file: !3, line: 21, type: !30)
!65 = !DILocation(line: 21, column: 9, scope: !60)
!66 = !DILocation(line: 21, column: 14, scope: !60)
!67 = !DILocation(line: 23, column: 5, scope: !60)
!68 = !DILocalVariable(name: "r1", scope: !60, file: !3, line: 25, type: !30)
!69 = !DILocation(line: 25, column: 9, scope: !60)
!70 = !DILocation(line: 25, column: 14, scope: !60)
!71 = !DILocation(line: 27, column: 5, scope: !60)
!72 = !DILocation(line: 28, column: 5, scope: !60)
!73 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 31, type: !51, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!74 = !DILocalVariable(name: "unused", arg: 1, scope: !73, file: !3, line: 31, type: !33)
!75 = !DILocation(line: 31, column: 22, scope: !73)
!76 = !DILocation(line: 34, column: 5, scope: !73)
!77 = !DILocalVariable(name: "r0", scope: !73, file: !3, line: 36, type: !30)
!78 = !DILocation(line: 36, column: 9, scope: !73)
!79 = !DILocation(line: 36, column: 14, scope: !73)
!80 = !DILocation(line: 38, column: 5, scope: !73)
!81 = !DILocation(line: 40, column: 5, scope: !73)
!82 = !DILocalVariable(name: "r1", scope: !73, file: !3, line: 42, type: !30)
!83 = !DILocation(line: 42, column: 9, scope: !73)
!84 = !DILocation(line: 42, column: 14, scope: !73)
!85 = !DILocation(line: 44, column: 5, scope: !73)
!86 = !DILocation(line: 44, column: 11, scope: !73)
!87 = !DILocation(line: 44, column: 24, scope: !73)
!88 = !DILocation(line: 44, column: 29, scope: !73)
!89 = !DILocation(line: 44, column: 33, scope: !73)
!90 = !DILocation(line: 44, column: 46, scope: !73)
!91 = !DILocation(line: 0, scope: !73)
!92 = distinct !{!92, !85, !93, !94}
!93 = !DILocation(line: 44, column: 54, scope: !73)
!94 = !{!"llvm.loop.mustprogress"}
!95 = !DILocation(line: 45, column: 5, scope: !73)
!96 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 48, type: !97, scopeLine: 49, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!97 = !DISubroutineType(types: !98)
!98 = !{!30}
!99 = !DILocalVariable(name: "t1", scope: !96, file: !3, line: 50, type: !100)
!100 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !101, line: 31, baseType: !102)
!101 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !103, line: 118, baseType: !104)
!103 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!104 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !105, size: 64)
!105 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !103, line: 103, size: 65536, elements: !106)
!106 = !{!107, !109, !119}
!107 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !105, file: !103, line: 104, baseType: !108, size: 64)
!108 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !105, file: !103, line: 105, baseType: !110, size: 64, offset: 64)
!110 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !111, size: 64)
!111 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !103, line: 57, size: 192, elements: !112)
!112 = !{!113, !117, !118}
!113 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !111, file: !103, line: 58, baseType: !114, size: 64)
!114 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !115, size: 64)
!115 = !DISubroutineType(types: !116)
!116 = !{null, !33}
!117 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !111, file: !103, line: 59, baseType: !33, size: 64, offset: 64)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !111, file: !103, line: 60, baseType: !110, size: 64, offset: 128)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !105, file: !103, line: 106, baseType: !120, size: 65408, offset: 128)
!120 = !DICompositeType(tag: DW_TAG_array_type, baseType: !121, size: 65408, elements: !122)
!121 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!122 = !{!123}
!123 = !DISubrange(count: 8176)
!124 = !DILocation(line: 50, column: 12, scope: !96)
!125 = !DILocalVariable(name: "t2", scope: !96, file: !3, line: 50, type: !100)
!126 = !DILocation(line: 50, column: 16, scope: !96)
!127 = !DILocalVariable(name: "t3", scope: !96, file: !3, line: 50, type: !100)
!128 = !DILocation(line: 50, column: 20, scope: !96)
!129 = !DILocation(line: 52, column: 2, scope: !96)
!130 = !DILocation(line: 53, column: 2, scope: !96)
!131 = !DILocation(line: 54, column: 2, scope: !96)
!132 = !DILocation(line: 56, column: 2, scope: !96)
