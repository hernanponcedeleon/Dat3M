; ModuleID = 'benchmarks/interrupts/c11_oota.c'
source_filename = "benchmarks/interrupts/c11_oota.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@z = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !23
@x = global i32 0, align 4, !dbg !18
@h = global ptr null, align 8, !dbg !25

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !58 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !62, !DIExpression(), !63)
  store i32 3, ptr %3, align 4, !dbg !64
  %5 = load i32, ptr %3, align 4, !dbg !64
  store atomic i32 %5, ptr @z monotonic, align 4, !dbg !64
  %6 = load atomic i32, ptr @y monotonic, align 4, !dbg !65
  store i32 %6, ptr %4, align 4, !dbg !65
  %7 = load i32, ptr %4, align 4, !dbg !65
  %8 = icmp eq i32 %7, 0, !dbg !66
  %9 = zext i1 %8 to i32, !dbg !66
  call void @__VERIFIER_assert(i32 noundef %9), !dbg !67
  ret ptr null, !dbg !68
}

declare void @__VERIFIER_assert(i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_1(ptr noundef %0) #0 !dbg !69 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !70, !DIExpression(), !71)
    #dbg_declare(ptr %3, !72, !DIExpression(), !74)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !74
  %7 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !74
  %8 = load ptr, ptr %3, align 8, !dbg !74
  store ptr %8, ptr %4, align 8, !dbg !74
  %9 = load ptr, ptr %4, align 8, !dbg !74
  %10 = load atomic i32, ptr @x monotonic, align 4, !dbg !75
  store i32 %10, ptr %5, align 4, !dbg !75
  %11 = load i32, ptr %5, align 4, !dbg !75
  %12 = icmp eq i32 %11, 1, !dbg !77
  br i1 %12, label %13, label %15, !dbg !78

13:                                               ; preds = %1
  store i32 2, ptr %6, align 4, !dbg !79
  %14 = load i32, ptr %6, align 4, !dbg !79
  store atomic i32 %14, ptr @y monotonic, align 4, !dbg !79
  br label %15, !dbg !81

15:                                               ; preds = %13, %1
  ret ptr null, !dbg !82
}

declare void @__VERIFIER_make_interrupt_handler() #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_2(ptr noundef %0) #0 !dbg !83 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !84, !DIExpression(), !85)
  %5 = load atomic i32, ptr @z monotonic, align 4, !dbg !86
  store i32 %5, ptr %3, align 4, !dbg !86
  %6 = load i32, ptr %3, align 4, !dbg !86
  %7 = icmp eq i32 %6, 3, !dbg !88
  br i1 %7, label %8, label %10, !dbg !89

8:                                                ; preds = %1
  store i32 1, ptr %4, align 4, !dbg !90
  %9 = load i32, ptr %4, align 4, !dbg !90
  store atomic i32 %9, ptr @x monotonic, align 4, !dbg !90
  br label %10, !dbg !92

10:                                               ; preds = %8, %1
  ret ptr null, !dbg !93
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !94 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !97, !DIExpression(), !98)
    #dbg_declare(ptr %3, !99, !DIExpression(), !100)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !101
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !102
  ret i32 0, !dbg !103
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!51, !52, !53, !54, !55, !56}
!llvm.ident = !{!57}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !3, line: 7, type: !20, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/interrupts/c11_oota.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a7b0d1c96b12bf9a10cffbb8fdb10089")
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
!17 = !{!18, !23, !0, !25}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !20, isLocal: false, isDefinition: true)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 104, baseType: !21)
!21 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !22)
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !20, isLocal: false, isDefinition: true)
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
!64 = !DILocation(line: 12, column: 5, scope: !58)
!65 = !DILocation(line: 13, column: 23, scope: !58)
!66 = !DILocation(line: 13, column: 70, scope: !58)
!67 = !DILocation(line: 13, column: 5, scope: !58)
!68 = !DILocation(line: 14, column: 5, scope: !58)
!69 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 17, type: !59, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!70 = !DILocalVariable(name: "arg", arg: 1, scope: !69, file: !3, line: 17, type: !16)
!71 = !DILocation(line: 17, column: 22, scope: !69)
!72 = !DILocalVariable(name: "h", scope: !73, file: !3, line: 19, type: !27)
!73 = distinct !DILexicalBlock(scope: !69, file: !3, line: 19, column: 5)
!74 = !DILocation(line: 19, column: 5, scope: !73)
!75 = !DILocation(line: 21, column: 8, scope: !76)
!76 = distinct !DILexicalBlock(scope: !69, file: !3, line: 21, column: 8)
!77 = !DILocation(line: 21, column: 55, scope: !76)
!78 = !DILocation(line: 21, column: 8, scope: !69)
!79 = !DILocation(line: 22, column: 9, scope: !80)
!80 = distinct !DILexicalBlock(scope: !76, file: !3, line: 21, column: 61)
!81 = !DILocation(line: 23, column: 5, scope: !80)
!82 = !DILocation(line: 25, column: 5, scope: !69)
!83 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 28, type: !59, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!84 = !DILocalVariable(name: "arg", arg: 1, scope: !83, file: !3, line: 28, type: !16)
!85 = !DILocation(line: 28, column: 22, scope: !83)
!86 = !DILocation(line: 30, column: 8, scope: !87)
!87 = distinct !DILexicalBlock(scope: !83, file: !3, line: 30, column: 8)
!88 = !DILocation(line: 30, column: 55, scope: !87)
!89 = !DILocation(line: 30, column: 8, scope: !83)
!90 = !DILocation(line: 31, column: 9, scope: !91)
!91 = distinct !DILexicalBlock(scope: !87, file: !3, line: 30, column: 61)
!92 = !DILocation(line: 32, column: 5, scope: !91)
!93 = !DILocation(line: 33, column: 5, scope: !83)
!94 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 36, type: !95, scopeLine: 37, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !61)
!95 = !DISubroutineType(types: !96)
!96 = !{!22}
!97 = !DILocalVariable(name: "t1", scope: !94, file: !3, line: 38, type: !27)
!98 = !DILocation(line: 38, column: 15, scope: !94)
!99 = !DILocalVariable(name: "t2", scope: !94, file: !3, line: 38, type: !27)
!100 = !DILocation(line: 38, column: 19, scope: !94)
!101 = !DILocation(line: 40, column: 5, scope: !94)
!102 = !DILocation(line: 41, column: 5, scope: !94)
!103 = !DILocation(line: 43, column: 5, scope: !94)
