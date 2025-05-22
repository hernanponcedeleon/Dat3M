; ModuleID = 'benchmarks/lkmm/qspinlock-liveness.c'
source_filename = "benchmarks/lkmm/qspinlock-liveness.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }

@x = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !36
@z = dso_local global i32 0, align 4, !dbg !38

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_1(ptr noundef %0) #0 !dbg !52 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !56, !DIExpression(), !57)
    #dbg_declare(ptr %3, !58, !DIExpression(), !59)
  %4 = call i64 @__LKMM_atomic_fetch_op(ptr noundef @x, i64 noundef 4, i64 noundef 2, i32 noundef 3, i32 noundef 0), !dbg !60
  %5 = trunc i64 %4 to i32, !dbg !60
  store i32 %5, ptr %3, align 4, !dbg !59
  ret ptr null, !dbg !61
}

declare i64 @__LKMM_atomic_fetch_op(ptr noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_2(ptr noundef %0) #0 !dbg !62 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !63, !DIExpression(), !64)
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !65
    #dbg_declare(ptr %3, !66, !DIExpression(), !67)
  %5 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !68
  %6 = trunc i64 %5 to i32, !dbg !68
  store i32 %6, ptr %3, align 4, !dbg !67
  call void @__LKMM_fence(i32 noundef 4), !dbg !69
    #dbg_declare(ptr %4, !70, !DIExpression(), !71)
  %7 = load i32, ptr %3, align 4, !dbg !72
  %8 = sext i32 %7 to i64, !dbg !72
  %9 = call i64 @__LKMM_cmpxchg(ptr noundef @x, i64 noundef 4, i64 noundef %8, i64 noundef 42, i32 noundef 0, i32 noundef 0), !dbg !72
  %10 = trunc i64 %9 to i32, !dbg !72
  store i32 %10, ptr %4, align 4, !dbg !71
  call void @__LKMM_store(ptr noundef @z, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !73
  ret ptr null, !dbg !74
}

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #1

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #1

declare void @__LKMM_fence(i32 noundef) #1

declare i64 @__LKMM_cmpxchg(ptr noundef, i64 noundef, i64 noundef, i64 noundef, i32 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_3(ptr noundef %0) #0 !dbg !75 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !76, !DIExpression(), !77)
  call void @__LKMM_store(ptr noundef @z, i64 noundef 4, i64 noundef 2, i32 noundef 0), !dbg !78
    #dbg_declare(ptr %3, !79, !DIExpression(), !80)
  %5 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !81
  %6 = trunc i64 %5 to i32, !dbg !81
  store i32 %6, ptr %3, align 4, !dbg !80
  call void @__LKMM_fence(i32 noundef 4), !dbg !82
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 0, i32 noundef 0), !dbg !83
    #dbg_declare(ptr %4, !84, !DIExpression(), !85)
  %7 = load i32, ptr %3, align 4, !dbg !86
  %8 = sext i32 %7 to i64, !dbg !86
  %9 = call i64 @__LKMM_cmpxchg(ptr noundef @x, i64 noundef 4, i64 noundef %8, i64 noundef 24, i32 noundef 0, i32 noundef 0), !dbg !86
  %10 = trunc i64 %9 to i32, !dbg !86
  store i32 %10, ptr %4, align 4, !dbg !85
  br label %11, !dbg !87

11:                                               ; preds = %21, %1
  %12 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 0), !dbg !88
  %13 = trunc i64 %12 to i32, !dbg !88
  %14 = icmp eq i32 %13, 1, !dbg !89
  br i1 %14, label %15, label %19, !dbg !90

15:                                               ; preds = %11
  %16 = call i64 @__LKMM_load(ptr noundef @z, i64 noundef 4, i32 noundef 0), !dbg !91
  %17 = trunc i64 %16 to i32, !dbg !91
  %18 = icmp eq i32 %17, 2, !dbg !92
  br label %19

19:                                               ; preds = %15, %11
  %20 = phi i1 [ false, %11 ], [ %18, %15 ], !dbg !93
  br i1 %20, label %21, label %22, !dbg !87

21:                                               ; preds = %19
  br label %11, !dbg !87, !llvm.loop !94

22:                                               ; preds = %19
  ret ptr null, !dbg !97
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !98 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !101, !DIExpression(), !125)
    #dbg_declare(ptr %3, !126, !DIExpression(), !127)
    #dbg_declare(ptr %4, !128, !DIExpression(), !129)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !130
  %6 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !131
  %7 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @thread_3, ptr noundef null), !dbg !132
  ret i32 0, !dbg !133
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!44, !45, !46, !47, !48, !49, !50}
!llvm.ident = !{!51}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !40, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !28, globals: !35, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/lkmm/qspinlock-liveness.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "62cffcfdbbfe2e2b84cb01226603616c")
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
!35 = !{!36, !38, !0}
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 6, type: !29, isLocal: false, isDefinition: true)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !3, line: 6, type: !29, isLocal: false, isDefinition: true)
!40 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 108, baseType: !41)
!41 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 106, size: 32, elements: !42)
!42 = !{!43}
!43 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !41, file: !6, line: 107, baseType: !29, size: 32)
!44 = !{i32 7, !"Dwarf Version", i32 5}
!45 = !{i32 2, !"Debug Info Version", i32 3}
!46 = !{i32 1, !"wchar_size", i32 4}
!47 = !{i32 8, !"PIC Level", i32 2}
!48 = !{i32 7, !"PIE Level", i32 2}
!49 = !{i32 7, !"uwtable", i32 2}
!50 = !{i32 7, !"frame-pointer", i32 2}
!51 = !{!"Homebrew clang version 19.1.7"}
!52 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 9, type: !53, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!53 = !DISubroutineType(types: !54)
!54 = !{!34, !34}
!55 = !{}
!56 = !DILocalVariable(name: "unused", arg: 1, scope: !52, file: !3, line: 9, type: !34)
!57 = !DILocation(line: 9, column: 22, scope: !52)
!58 = !DILocalVariable(name: "r0", scope: !52, file: !3, line: 12, type: !29)
!59 = !DILocation(line: 12, column: 9, scope: !52)
!60 = !DILocation(line: 12, column: 14, scope: !52)
!61 = !DILocation(line: 13, column: 5, scope: !52)
!62 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 16, type: !53, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!63 = !DILocalVariable(name: "unused", arg: 1, scope: !62, file: !3, line: 16, type: !34)
!64 = !DILocation(line: 16, column: 22, scope: !62)
!65 = !DILocation(line: 19, column: 5, scope: !62)
!66 = !DILocalVariable(name: "r0", scope: !62, file: !3, line: 21, type: !29)
!67 = !DILocation(line: 21, column: 9, scope: !62)
!68 = !DILocation(line: 21, column: 14, scope: !62)
!69 = !DILocation(line: 23, column: 5, scope: !62)
!70 = !DILocalVariable(name: "r1", scope: !62, file: !3, line: 25, type: !29)
!71 = !DILocation(line: 25, column: 9, scope: !62)
!72 = !DILocation(line: 25, column: 14, scope: !62)
!73 = !DILocation(line: 27, column: 5, scope: !62)
!74 = !DILocation(line: 28, column: 5, scope: !62)
!75 = distinct !DISubprogram(name: "thread_3", scope: !3, file: !3, line: 31, type: !53, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!76 = !DILocalVariable(name: "unused", arg: 1, scope: !75, file: !3, line: 31, type: !34)
!77 = !DILocation(line: 31, column: 22, scope: !75)
!78 = !DILocation(line: 34, column: 5, scope: !75)
!79 = !DILocalVariable(name: "r0", scope: !75, file: !3, line: 36, type: !29)
!80 = !DILocation(line: 36, column: 9, scope: !75)
!81 = !DILocation(line: 36, column: 14, scope: !75)
!82 = !DILocation(line: 38, column: 5, scope: !75)
!83 = !DILocation(line: 40, column: 5, scope: !75)
!84 = !DILocalVariable(name: "r1", scope: !75, file: !3, line: 42, type: !29)
!85 = !DILocation(line: 42, column: 9, scope: !75)
!86 = !DILocation(line: 42, column: 14, scope: !75)
!87 = !DILocation(line: 44, column: 5, scope: !75)
!88 = !DILocation(line: 44, column: 11, scope: !75)
!89 = !DILocation(line: 44, column: 24, scope: !75)
!90 = !DILocation(line: 44, column: 29, scope: !75)
!91 = !DILocation(line: 44, column: 33, scope: !75)
!92 = !DILocation(line: 44, column: 46, scope: !75)
!93 = !DILocation(line: 0, scope: !75)
!94 = distinct !{!94, !87, !95, !96}
!95 = !DILocation(line: 44, column: 54, scope: !75)
!96 = !{!"llvm.loop.mustprogress"}
!97 = !DILocation(line: 45, column: 5, scope: !75)
!98 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 48, type: !99, scopeLine: 49, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!99 = !DISubroutineType(types: !100)
!100 = !{!29}
!101 = !DILocalVariable(name: "t1", scope: !98, file: !3, line: 50, type: !102)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !103, line: 31, baseType: !104)
!103 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!104 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !105, line: 118, baseType: !106)
!105 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!106 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !107, size: 64)
!107 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !105, line: 103, size: 65536, elements: !108)
!108 = !{!109, !110, !120}
!109 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !107, file: !105, line: 104, baseType: !33, size: 64)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !107, file: !105, line: 105, baseType: !111, size: 64, offset: 64)
!111 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!112 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !105, line: 57, size: 192, elements: !113)
!113 = !{!114, !118, !119}
!114 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !112, file: !105, line: 58, baseType: !115, size: 64)
!115 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !116, size: 64)
!116 = !DISubroutineType(types: !117)
!117 = !{null, !34}
!118 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !112, file: !105, line: 59, baseType: !34, size: 64, offset: 64)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !112, file: !105, line: 60, baseType: !111, size: 64, offset: 128)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !107, file: !105, line: 106, baseType: !121, size: 65408, offset: 128)
!121 = !DICompositeType(tag: DW_TAG_array_type, baseType: !122, size: 65408, elements: !123)
!122 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!123 = !{!124}
!124 = !DISubrange(count: 8176)
!125 = !DILocation(line: 50, column: 12, scope: !98)
!126 = !DILocalVariable(name: "t2", scope: !98, file: !3, line: 50, type: !102)
!127 = !DILocation(line: 50, column: 16, scope: !98)
!128 = !DILocalVariable(name: "t3", scope: !98, file: !3, line: 50, type: !102)
!129 = !DILocation(line: 50, column: 20, scope: !98)
!130 = !DILocation(line: 52, column: 2, scope: !98)
!131 = !DILocation(line: 53, column: 2, scope: !98)
!132 = !DILocation(line: 54, column: 2, scope: !98)
!133 = !DILocation(line: 56, column: 2, scope: !98)
