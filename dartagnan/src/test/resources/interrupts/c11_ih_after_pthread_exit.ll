; ModuleID = 'benchmarks/interrupts/c11_ih_after_pthread_exit.c'
source_filename = "benchmarks/interrupts/c11_ih_after_pthread_exit.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4, !dbg !0

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !28 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !32, !DIExpression(), !33)
  store i32 1, ptr %3, align 4, !dbg !34
  %4 = load i32, ptr %3, align 4, !dbg !34
  store atomic i32 %4, ptr @x monotonic, align 4, !dbg !34
  ret ptr null, !dbg !35
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread1(ptr noundef %0) #0 !dbg !36 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !37, !DIExpression(), !38)
    #dbg_declare(ptr %3, !39, !DIExpression(), !65)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !65
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !65
  %6 = load ptr, ptr %3, align 8, !dbg !65
  store ptr %6, ptr %4, align 8, !dbg !65
  %7 = load ptr, ptr %4, align 8, !dbg !65
  ret ptr null, !dbg !66
}

declare void @__VERIFIER_make_interrupt_handler() #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !67 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !70, !DIExpression(), !71)
  %5 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread1, ptr noundef null), !dbg !72
  %6 = load ptr, ptr %2, align 8, !dbg !73
  %7 = call i32 @"\01_pthread_join"(ptr noundef %6, ptr noundef null), !dbg !74
    #dbg_declare(ptr %3, !75, !DIExpression(), !76)
  %8 = load atomic i32, ptr @x monotonic, align 4, !dbg !77
  store i32 %8, ptr %4, align 4, !dbg !77
  %9 = load i32, ptr %4, align 4, !dbg !77
  store i32 %9, ptr %3, align 4, !dbg !76
  %10 = load i32, ptr %3, align 4, !dbg !78
  %11 = icmp eq i32 %10, 1, !dbg !79
  %12 = zext i1 %11 to i32, !dbg !79
  call void @__VERIFIER_assert(i32 noundef %12), !dbg !80
  ret i32 0, !dbg !81
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

declare void @__VERIFIER_assert(i32 noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!21, !22, !23, !24, !25, !26}
!llvm.ident = !{!27}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 8, type: !18, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/interrupts/c11_ih_after_pthread_exit.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "49029626953e16f9061c70cda3e4789c")
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
!17 = !{!0}
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 104, baseType: !19)
!19 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !20)
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !{i32 7, !"Dwarf Version", i32 5}
!22 = !{i32 2, !"Debug Info Version", i32 3}
!23 = !{i32 1, !"wchar_size", i32 4}
!24 = !{i32 8, !"PIC Level", i32 2}
!25 = !{i32 7, !"uwtable", i32 1}
!26 = !{i32 7, !"frame-pointer", i32 1}
!27 = !{!"Homebrew clang version 19.1.7"}
!28 = distinct !DISubprogram(name: "handler", scope: !3, file: !3, line: 10, type: !29, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !31)
!29 = !DISubroutineType(types: !30)
!30 = !{!16, !16}
!31 = !{}
!32 = !DILocalVariable(name: "arg", arg: 1, scope: !28, file: !3, line: 10, type: !16)
!33 = !DILocation(line: 10, column: 21, scope: !28)
!34 = !DILocation(line: 12, column: 5, scope: !28)
!35 = !DILocation(line: 13, column: 5, scope: !28)
!36 = distinct !DISubprogram(name: "thread1", scope: !3, file: !3, line: 16, type: !29, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !31)
!37 = !DILocalVariable(name: "arg", arg: 1, scope: !36, file: !3, line: 16, type: !16)
!38 = !DILocation(line: 16, column: 21, scope: !36)
!39 = !DILocalVariable(name: "h", scope: !40, file: !3, line: 18, type: !41)
!40 = distinct !DILexicalBlock(scope: !36, file: !3, line: 18, column: 5)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !42, line: 31, baseType: !43)
!42 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !44, line: 118, baseType: !45)
!44 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!46 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !44, line: 103, size: 65536, elements: !47)
!47 = !{!48, !50, !60}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !46, file: !44, line: 104, baseType: !49, size: 64)
!49 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !46, file: !44, line: 105, baseType: !51, size: 64, offset: 64)
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 64)
!52 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !44, line: 57, size: 192, elements: !53)
!53 = !{!54, !58, !59}
!54 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !52, file: !44, line: 58, baseType: !55, size: 64)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = !DISubroutineType(types: !57)
!57 = !{null, !16}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !52, file: !44, line: 59, baseType: !16, size: 64, offset: 64)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !52, file: !44, line: 60, baseType: !51, size: 64, offset: 128)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !46, file: !44, line: 106, baseType: !61, size: 65408, offset: 128)
!61 = !DICompositeType(tag: DW_TAG_array_type, baseType: !62, size: 65408, elements: !63)
!62 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!63 = !{!64}
!64 = !DISubrange(count: 8176)
!65 = !DILocation(line: 18, column: 5, scope: !40)
!66 = !DILocation(line: 20, column: 5, scope: !36)
!67 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 23, type: !68, scopeLine: 24, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !31)
!68 = !DISubroutineType(types: !69)
!69 = !{!20}
!70 = !DILocalVariable(name: "t1", scope: !67, file: !3, line: 25, type: !41)
!71 = !DILocation(line: 25, column: 15, scope: !67)
!72 = !DILocation(line: 26, column: 5, scope: !67)
!73 = !DILocation(line: 27, column: 18, scope: !67)
!74 = !DILocation(line: 27, column: 5, scope: !67)
!75 = !DILocalVariable(name: "x0", scope: !67, file: !3, line: 28, type: !20)
!76 = !DILocation(line: 28, column: 9, scope: !67)
!77 = !DILocation(line: 28, column: 14, scope: !67)
!78 = !DILocation(line: 29, column: 23, scope: !67)
!79 = !DILocation(line: 29, column: 26, scope: !67)
!80 = !DILocation(line: 29, column: 5, scope: !67)
!81 = !DILocation(line: 30, column: 5, scope: !67)
