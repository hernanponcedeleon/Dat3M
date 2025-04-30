; ModuleID = 'benchmarks/interrupts/c11_detour_disable.c'
source_filename = "benchmarks/interrupts/c11_detour_disable.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@y = global i32 0, align 4, !dbg !0
@x = global i32 0, align 4, !dbg !18
@a = global i32 0, align 4, !dbg !23
@b = global i32 0, align 4, !dbg !25
@h = global ptr null, align 8, !dbg !27

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !60 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !64, !DIExpression(), !65)
  store i32 3, ptr %3, align 4, !dbg !66
  %4 = load i32, ptr %3, align 4, !dbg !66
  store atomic i32 %4, ptr @y seq_cst, align 4, !dbg !66
  ret ptr null, !dbg !67
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_1(ptr noundef %0) #0 !dbg !68 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !69, !DIExpression(), !70)
    #dbg_declare(ptr %3, !71, !DIExpression(), !73)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !73
  %7 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !73
  %8 = load ptr, ptr %3, align 8, !dbg !73
  store ptr %8, ptr %4, align 8, !dbg !73
  %9 = load ptr, ptr %4, align 8, !dbg !73
  call void @__VERIFIER_disable_irq(), !dbg !74
  store i32 1, ptr %5, align 4, !dbg !75
  %10 = load i32, ptr %5, align 4, !dbg !75
  store atomic i32 %10, ptr @x monotonic, align 4, !dbg !75
  %11 = load atomic i32, ptr @y monotonic, align 4, !dbg !76
  store i32 %11, ptr %6, align 4, !dbg !76
  %12 = load i32, ptr %6, align 4, !dbg !76
  store i32 %12, ptr @a, align 4, !dbg !77
  call void @__VERIFIER_enable_irq(), !dbg !78
  ret ptr null, !dbg !79
}

declare void @__VERIFIER_make_interrupt_handler() #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare void @__VERIFIER_disable_irq() #1

declare void @__VERIFIER_enable_irq() #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_2(ptr noundef %0) #0 !dbg !80 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !81, !DIExpression(), !82)
  %5 = load atomic i32, ptr @x monotonic, align 4, !dbg !83
  store i32 %5, ptr %3, align 4, !dbg !83
  %6 = load i32, ptr %3, align 4, !dbg !83
  store i32 %6, ptr @b, align 4, !dbg !84
  store i32 2, ptr %4, align 4, !dbg !85
  %7 = load i32, ptr %4, align 4, !dbg !85
  store atomic i32 %7, ptr @y release, align 4, !dbg !85
  ret ptr null, !dbg !86
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !87 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !90, !DIExpression(), !91)
    #dbg_declare(ptr %3, !92, !DIExpression(), !93)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !94
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !95
  %6 = load ptr, ptr %2, align 8, !dbg !96
  %7 = call i32 @"\01_pthread_join"(ptr noundef %6, ptr noundef null), !dbg !97
  %8 = load ptr, ptr %3, align 8, !dbg !98
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !99
  %10 = load i32, ptr @b, align 4, !dbg !100
  %11 = icmp eq i32 %10, 1, !dbg !101
  br i1 %11, label %12, label %18, !dbg !102

12:                                               ; preds = %0
  %13 = load i32, ptr @a, align 4, !dbg !103
  %14 = icmp eq i32 %13, 3, !dbg !104
  br i1 %14, label %15, label %18, !dbg !105

15:                                               ; preds = %12
  %16 = load atomic i32, ptr @y seq_cst, align 4, !dbg !106
  %17 = icmp eq i32 %16, 3, !dbg !107
  br label %18

18:                                               ; preds = %15, %12, %0
  %19 = phi i1 [ false, %12 ], [ false, %0 ], [ %17, %15 ], !dbg !108
  %20 = xor i1 %19, true, !dbg !109
  %21 = zext i1 %20 to i32, !dbg !109
  call void @__VERIFIER_assert(i32 noundef %21), !dbg !110
  ret i32 0, !dbg !111
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

declare void @__VERIFIER_assert(i32 noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!53, !54, !55, !56, !57, !58}
!llvm.ident = !{!59}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !20, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/interrupts/c11_detour_disable.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "9021b17a6156319830eefb1eb8810fc2")
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
!17 = !{!18, !0, !23, !25, !27}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !20, isLocal: false, isDefinition: true)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 104, baseType: !21)
!21 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !22)
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 8, type: !22, isLocal: false, isDefinition: true)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 8, type: !22, isLocal: false, isDefinition: true)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !3, line: 10, type: !29, isLocal: false, isDefinition: true)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !30, line: 31, baseType: !31)
!30 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !32, line: 118, baseType: !33)
!32 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !32, line: 103, size: 65536, elements: !35)
!35 = !{!36, !38, !48}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !34, file: !32, line: 104, baseType: !37, size: 64)
!37 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !34, file: !32, line: 105, baseType: !39, size: 64, offset: 64)
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !32, line: 57, size: 192, elements: !41)
!41 = !{!42, !46, !47}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !40, file: !32, line: 58, baseType: !43, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!44 = !DISubroutineType(types: !45)
!45 = !{null, !16}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !40, file: !32, line: 59, baseType: !16, size: 64, offset: 64)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !40, file: !32, line: 60, baseType: !39, size: 64, offset: 128)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !34, file: !32, line: 106, baseType: !49, size: 65408, offset: 128)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 65408, elements: !51)
!50 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!51 = !{!52}
!52 = !DISubrange(count: 8176)
!53 = !{i32 7, !"Dwarf Version", i32 5}
!54 = !{i32 2, !"Debug Info Version", i32 3}
!55 = !{i32 1, !"wchar_size", i32 4}
!56 = !{i32 8, !"PIC Level", i32 2}
!57 = !{i32 7, !"uwtable", i32 1}
!58 = !{i32 7, !"frame-pointer", i32 1}
!59 = !{!"Homebrew clang version 19.1.7"}
!60 = distinct !DISubprogram(name: "handler", scope: !3, file: !3, line: 11, type: !61, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!61 = !DISubroutineType(types: !62)
!62 = !{!16, !16}
!63 = !{}
!64 = !DILocalVariable(name: "arg", arg: 1, scope: !60, file: !3, line: 11, type: !16)
!65 = !DILocation(line: 11, column: 21, scope: !60)
!66 = !DILocation(line: 13, column: 5, scope: !60)
!67 = !DILocation(line: 14, column: 5, scope: !60)
!68 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 17, type: !61, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!69 = !DILocalVariable(name: "arg", arg: 1, scope: !68, file: !3, line: 17, type: !16)
!70 = !DILocation(line: 17, column: 22, scope: !68)
!71 = !DILocalVariable(name: "h", scope: !72, file: !3, line: 19, type: !29)
!72 = distinct !DILexicalBlock(scope: !68, file: !3, line: 19, column: 5)
!73 = !DILocation(line: 19, column: 5, scope: !72)
!74 = !DILocation(line: 21, column: 5, scope: !68)
!75 = !DILocation(line: 22, column: 5, scope: !68)
!76 = !DILocation(line: 23, column: 9, scope: !68)
!77 = !DILocation(line: 23, column: 7, scope: !68)
!78 = !DILocation(line: 24, column: 5, scope: !68)
!79 = !DILocation(line: 26, column: 5, scope: !68)
!80 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 29, type: !61, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!81 = !DILocalVariable(name: "arg", arg: 1, scope: !80, file: !3, line: 29, type: !16)
!82 = !DILocation(line: 29, column: 22, scope: !80)
!83 = !DILocation(line: 31, column: 9, scope: !80)
!84 = !DILocation(line: 31, column: 7, scope: !80)
!85 = !DILocation(line: 32, column: 5, scope: !80)
!86 = !DILocation(line: 33, column: 5, scope: !80)
!87 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 36, type: !88, scopeLine: 37, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!88 = !DISubroutineType(types: !89)
!89 = !{!22}
!90 = !DILocalVariable(name: "t1", scope: !87, file: !3, line: 38, type: !29)
!91 = !DILocation(line: 38, column: 15, scope: !87)
!92 = !DILocalVariable(name: "t2", scope: !87, file: !3, line: 38, type: !29)
!93 = !DILocation(line: 38, column: 19, scope: !87)
!94 = !DILocation(line: 40, column: 5, scope: !87)
!95 = !DILocation(line: 41, column: 5, scope: !87)
!96 = !DILocation(line: 42, column: 18, scope: !87)
!97 = !DILocation(line: 42, column: 5, scope: !87)
!98 = !DILocation(line: 43, column: 18, scope: !87)
!99 = !DILocation(line: 43, column: 5, scope: !87)
!100 = !DILocation(line: 45, column: 25, scope: !87)
!101 = !DILocation(line: 45, column: 27, scope: !87)
!102 = !DILocation(line: 45, column: 32, scope: !87)
!103 = !DILocation(line: 45, column: 35, scope: !87)
!104 = !DILocation(line: 45, column: 37, scope: !87)
!105 = !DILocation(line: 45, column: 42, scope: !87)
!106 = !DILocation(line: 45, column: 45, scope: !87)
!107 = !DILocation(line: 45, column: 47, scope: !87)
!108 = !DILocation(line: 0, scope: !87)
!109 = !DILocation(line: 45, column: 23, scope: !87)
!110 = !DILocation(line: 45, column: 5, scope: !87)
!111 = !DILocation(line: 47, column: 5, scope: !87)
