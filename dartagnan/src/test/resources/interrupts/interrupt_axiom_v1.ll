; ModuleID = 'benchmarks/interrupts/interrupt_axiom_v1.c'
source_filename = "benchmarks/interrupts/interrupt_axiom_v1.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !18
@z = global i32 0, align 4, !dbg !23
@h = global ptr null, align 8, !dbg !25

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !58 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !62, !DIExpression(), !63)
  %6 = load atomic i32, ptr @x monotonic, align 4, !dbg !64
  store i32 %6, ptr %3, align 4, !dbg !64
  %7 = load i32, ptr %3, align 4, !dbg !64
  %8 = icmp eq i32 %7, 1, !dbg !66
  br i1 %8, label %9, label %15, !dbg !67

9:                                                ; preds = %1
  %10 = load atomic i32, ptr @y monotonic, align 4, !dbg !68
  store i32 %10, ptr %4, align 4, !dbg !68
  %11 = load i32, ptr %4, align 4, !dbg !68
  %12 = icmp eq i32 %11, 0, !dbg !69
  br i1 %12, label %13, label %15, !dbg !70

13:                                               ; preds = %9
  fence seq_cst, !dbg !71
  store i32 1, ptr %5, align 4, !dbg !73
  %14 = load i32, ptr %5, align 4, !dbg !73
  store atomic i32 %14, ptr @z monotonic, align 4, !dbg !73
  br label %15, !dbg !74

15:                                               ; preds = %13, %9, %1
  ret ptr null, !dbg !75
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_1(ptr noundef %0) #0 !dbg !76 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !77, !DIExpression(), !78)
    #dbg_declare(ptr %3, !79, !DIExpression(), !81)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !81
  %7 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !81
  %8 = load ptr, ptr %3, align 8, !dbg !81
  store ptr %8, ptr %4, align 8, !dbg !81
  %9 = load ptr, ptr %4, align 8, !dbg !81
  store i32 1, ptr %5, align 4, !dbg !82
  %10 = load i32, ptr %5, align 4, !dbg !82
  store atomic i32 %10, ptr @x monotonic, align 4, !dbg !82
  store i32 1, ptr %6, align 4, !dbg !83
  %11 = load i32, ptr %6, align 4, !dbg !83
  store atomic i32 %11, ptr @y monotonic, align 4, !dbg !83
  ret ptr null, !dbg !84
}

declare void @__VERIFIER_make_interrupt_handler() #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_2(ptr noundef %0) #0 !dbg !85 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !86, !DIExpression(), !87)
  %6 = load atomic i32, ptr @z monotonic, align 4, !dbg !88
  store i32 %6, ptr %3, align 4, !dbg !88
  %7 = load i32, ptr %3, align 4, !dbg !88
  %8 = icmp eq i32 %7, 1, !dbg !90
  br i1 %8, label %9, label %18, !dbg !91

9:                                                ; preds = %1
  %10 = load atomic i32, ptr @y monotonic, align 4, !dbg !92
  store i32 %10, ptr %4, align 4, !dbg !92
  %11 = load i32, ptr %4, align 4, !dbg !92
  %12 = icmp eq i32 %11, 1, !dbg !93
  br i1 %12, label %13, label %18, !dbg !94

13:                                               ; preds = %9
  fence seq_cst, !dbg !95
  %14 = load atomic i32, ptr @x monotonic, align 4, !dbg !97
  store i32 %14, ptr %5, align 4, !dbg !97
  %15 = load i32, ptr %5, align 4, !dbg !97
  %16 = icmp eq i32 %15, 1, !dbg !98
  %17 = zext i1 %16 to i32, !dbg !98
  call void @__VERIFIER_assert(i32 noundef %17), !dbg !99
  br label %18, !dbg !100

18:                                               ; preds = %13, %9, %1
  ret ptr null, !dbg !101
}

declare void @__VERIFIER_assert(i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !102 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !105, !DIExpression(), !106)
    #dbg_declare(ptr %3, !107, !DIExpression(), !108)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !109
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !110
  ret i32 0, !dbg !111
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!51, !52, !53, !54, !55, !56}
!llvm.ident = !{!57}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !20, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/interrupts/interrupt_axiom_v1.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "053404ce98410939ead64dfd7c6de72c")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 68, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: ".local/universal/llvm-19.1.7/lib/clang/19/include/stdatomic.h", directory: "/Users/r", checksumkind: CSK_MD5, checksum: "f17199a988fe91afffaf0f943ef87096")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !{!0, !18, !23, !25}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !20, isLocal: false, isDefinition: true)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 104, baseType: !21)
!21 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !22)
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !3, line: 7, type: !20, isLocal: false, isDefinition: true)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !3, line: 9, type: !27, isLocal: false, isDefinition: true)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !28, line: 31, baseType: !29)
!28 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !30, line: 118, baseType: !31)
!30 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !30, line: 103, size: 65536, elements: !33)
!33 = !{!34, !36, !46}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !32, file: !30, line: 104, baseType: !35, size: 64)
!35 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !32, file: !30, line: 105, baseType: !37, size: 64, offset: 64)
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!38 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !30, line: 57, size: 192, elements: !39)
!39 = !{!40, !44, !45}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !38, file: !30, line: 58, baseType: !41, size: 64)
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = !DISubroutineType(types: !43)
!43 = !{null, !16}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !38, file: !30, line: 59, baseType: !16, size: 64, offset: 64)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !38, file: !30, line: 60, baseType: !37, size: 64, offset: 128)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !32, file: !30, line: 106, baseType: !47, size: 65408, offset: 128)
!47 = !DICompositeType(tag: DW_TAG_array_type, baseType: !48, size: 65408, elements: !49)
!48 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!49 = !{!50}
!50 = !DISubrange(count: 8176)
!51 = !{i32 7, !"Dwarf Version", i32 5}
!52 = !{i32 2, !"Debug Info Version", i32 3}
!53 = !{i32 1, !"wchar_size", i32 4}
!54 = !{i32 8, !"PIC Level", i32 2}
!55 = !{i32 7, !"uwtable", i32 1}
!56 = !{i32 7, !"frame-pointer", i32 1}
!57 = !{!"Homebrew clang version 19.1.7"}
!58 = distinct !DISubprogram(name: "handler", scope: !3, file: !3, line: 10, type: !59, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!59 = !DISubroutineType(types: !60)
!60 = !{!16, !16}
!61 = !{}
!62 = !DILocalVariable(name: "arg", arg: 1, scope: !58, file: !3, line: 10, type: !16)
!63 = !DILocation(line: 10, column: 21, scope: !58)
!64 = !DILocation(line: 12, column: 8, scope: !65)
!65 = distinct !DILexicalBlock(scope: !58, file: !3, line: 12, column: 8)
!66 = !DILocation(line: 12, column: 55, scope: !65)
!67 = !DILocation(line: 12, column: 60, scope: !65)
!68 = !DILocation(line: 12, column: 63, scope: !65)
!69 = !DILocation(line: 12, column: 110, scope: !65)
!70 = !DILocation(line: 12, column: 8, scope: !58)
!71 = !DILocation(line: 13, column: 9, scope: !72)
!72 = distinct !DILexicalBlock(scope: !65, file: !3, line: 12, column: 116)
!73 = !DILocation(line: 14, column: 9, scope: !72)
!74 = !DILocation(line: 15, column: 5, scope: !72)
!75 = !DILocation(line: 16, column: 5, scope: !58)
!76 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 19, type: !59, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!77 = !DILocalVariable(name: "arg", arg: 1, scope: !76, file: !3, line: 19, type: !16)
!78 = !DILocation(line: 19, column: 22, scope: !76)
!79 = !DILocalVariable(name: "h", scope: !80, file: !3, line: 21, type: !27)
!80 = distinct !DILexicalBlock(scope: !76, file: !3, line: 21, column: 5)
!81 = !DILocation(line: 21, column: 5, scope: !80)
!82 = !DILocation(line: 23, column: 5, scope: !76)
!83 = !DILocation(line: 24, column: 5, scope: !76)
!84 = !DILocation(line: 26, column: 5, scope: !76)
!85 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 29, type: !59, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!86 = !DILocalVariable(name: "arg", arg: 1, scope: !85, file: !3, line: 29, type: !16)
!87 = !DILocation(line: 29, column: 22, scope: !85)
!88 = !DILocation(line: 31, column: 8, scope: !89)
!89 = distinct !DILexicalBlock(scope: !85, file: !3, line: 31, column: 8)
!90 = !DILocation(line: 31, column: 55, scope: !89)
!91 = !DILocation(line: 31, column: 60, scope: !89)
!92 = !DILocation(line: 31, column: 63, scope: !89)
!93 = !DILocation(line: 31, column: 110, scope: !89)
!94 = !DILocation(line: 31, column: 8, scope: !85)
!95 = !DILocation(line: 32, column: 9, scope: !96)
!96 = distinct !DILexicalBlock(scope: !89, file: !3, line: 31, column: 116)
!97 = !DILocation(line: 33, column: 27, scope: !96)
!98 = !DILocation(line: 33, column: 74, scope: !96)
!99 = !DILocation(line: 33, column: 9, scope: !96)
!100 = !DILocation(line: 34, column: 5, scope: !96)
!101 = !DILocation(line: 35, column: 5, scope: !85)
!102 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 38, type: !103, scopeLine: 39, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!103 = !DISubroutineType(types: !104)
!104 = !{!22}
!105 = !DILocalVariable(name: "t1", scope: !102, file: !3, line: 40, type: !27)
!106 = !DILocation(line: 40, column: 15, scope: !102)
!107 = !DILocalVariable(name: "t2", scope: !102, file: !3, line: 40, type: !27)
!108 = !DILocation(line: 40, column: 19, scope: !102)
!109 = !DILocation(line: 41, column: 5, scope: !102)
!110 = !DILocation(line: 42, column: 5, scope: !102)
!111 = !DILocation(line: 44, column: 5, scope: !102)
