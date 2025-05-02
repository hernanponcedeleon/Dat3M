; ModuleID = 'benchmarks/interrupts/lkmm_ih_after_pthread_exit.c'
source_filename = "benchmarks/interrupts/lkmm_ih_after_pthread_exit.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4, !dbg !0

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !34 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !38, !DIExpression(), !39)
  call void @__LKMM_STORE(ptr noundef @x, i32 noundef 1, i32 noundef 1), !dbg !40
  ret ptr null, !dbg !41
}

declare void @__LKMM_STORE(ptr noundef, i32 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread1(ptr noundef %0) #0 !dbg !42 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !43, !DIExpression(), !44)
    #dbg_declare(ptr %3, !45, !DIExpression(), !71)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !71
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !71
  %6 = load ptr, ptr %3, align 8, !dbg !71
  store ptr %6, ptr %4, align 8, !dbg !71
  %7 = load ptr, ptr %4, align 8, !dbg !71
  ret ptr null, !dbg !72
}

declare void @__VERIFIER_make_interrupt_handler() #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !73 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !76, !DIExpression(), !77)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread1, ptr noundef null), !dbg !78
  %5 = load ptr, ptr %2, align 8, !dbg !79
  %6 = call i32 @"\01_pthread_join"(ptr noundef %5, ptr noundef null), !dbg !80
    #dbg_declare(ptr %3, !81, !DIExpression(), !82)
  %7 = call i32 @__LKMM_LOAD(ptr noundef @x, i32 noundef 1), !dbg !83
  store i32 %7, ptr %3, align 4, !dbg !82
  %8 = load i32, ptr %3, align 4, !dbg !84
  %9 = icmp eq i32 %8, 1, !dbg !85
  %10 = zext i1 %9 to i32, !dbg !85
  call void @__VERIFIER_assert(i32 noundef %10), !dbg !86
  ret i32 0, !dbg !87
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

declare i32 @__LKMM_LOAD(ptr noundef, i32 noundef) #1

declare void @__VERIFIER_assert(i32 noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!27, !28, !29, !30, !31, !32}
!llvm.ident = !{!33}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 8, type: !26, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/interrupts/lkmm_ih_after_pthread_exit.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "06d9152fd701da9f01c119a78167eabc")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f219e5a4f2482585588927d06bb5e5c6")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_once", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "mb", value: 4)
!14 = !DIEnumerator(name: "wmb", value: 5)
!15 = !DIEnumerator(name: "rmb", value: 6)
!16 = !DIEnumerator(name: "rcu_lock", value: 7)
!17 = !DIEnumerator(name: "rcu_unlock", value: 8)
!18 = !DIEnumerator(name: "rcu_sync", value: 9)
!19 = !DIEnumerator(name: "before_atomic", value: 10)
!20 = !DIEnumerator(name: "after_atomic", value: 11)
!21 = !DIEnumerator(name: "after_spinlock", value: 12)
!22 = !DIEnumerator(name: "barrier", value: 13)
!23 = !{!24}
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!25 = !{!0}
!26 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!27 = !{i32 7, !"Dwarf Version", i32 5}
!28 = !{i32 2, !"Debug Info Version", i32 3}
!29 = !{i32 1, !"wchar_size", i32 4}
!30 = !{i32 8, !"PIC Level", i32 2}
!31 = !{i32 7, !"uwtable", i32 1}
!32 = !{i32 7, !"frame-pointer", i32 1}
!33 = !{!"Homebrew clang version 19.1.7"}
!34 = distinct !DISubprogram(name: "handler", scope: !3, file: !3, line: 10, type: !35, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !37)
!35 = !DISubroutineType(types: !36)
!36 = !{!24, !24}
!37 = !{}
!38 = !DILocalVariable(name: "arg", arg: 1, scope: !34, file: !3, line: 10, type: !24)
!39 = !DILocation(line: 10, column: 21, scope: !34)
!40 = !DILocation(line: 12, column: 5, scope: !34)
!41 = !DILocation(line: 13, column: 5, scope: !34)
!42 = distinct !DISubprogram(name: "thread1", scope: !3, file: !3, line: 16, type: !35, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !37)
!43 = !DILocalVariable(name: "arg", arg: 1, scope: !42, file: !3, line: 16, type: !24)
!44 = !DILocation(line: 16, column: 21, scope: !42)
!45 = !DILocalVariable(name: "h", scope: !46, file: !3, line: 18, type: !47)
!46 = distinct !DILexicalBlock(scope: !42, file: !3, line: 18, column: 5)
!47 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !48, line: 31, baseType: !49)
!48 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !50, line: 118, baseType: !51)
!50 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 64)
!52 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !50, line: 103, size: 65536, elements: !53)
!53 = !{!54, !56, !66}
!54 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !52, file: !50, line: 104, baseType: !55, size: 64)
!55 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !52, file: !50, line: 105, baseType: !57, size: 64, offset: 64)
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!58 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !50, line: 57, size: 192, elements: !59)
!59 = !{!60, !64, !65}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !58, file: !50, line: 58, baseType: !61, size: 64)
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = !DISubroutineType(types: !63)
!63 = !{null, !24}
!64 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !58, file: !50, line: 59, baseType: !24, size: 64, offset: 64)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !58, file: !50, line: 60, baseType: !57, size: 64, offset: 128)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !52, file: !50, line: 106, baseType: !67, size: 65408, offset: 128)
!67 = !DICompositeType(tag: DW_TAG_array_type, baseType: !68, size: 65408, elements: !69)
!68 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!69 = !{!70}
!70 = !DISubrange(count: 8176)
!71 = !DILocation(line: 18, column: 5, scope: !46)
!72 = !DILocation(line: 20, column: 5, scope: !42)
!73 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 23, type: !74, scopeLine: 24, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !37)
!74 = !DISubroutineType(types: !75)
!75 = !{!26}
!76 = !DILocalVariable(name: "t1", scope: !73, file: !3, line: 25, type: !47)
!77 = !DILocation(line: 25, column: 15, scope: !73)
!78 = !DILocation(line: 26, column: 5, scope: !73)
!79 = !DILocation(line: 27, column: 18, scope: !73)
!80 = !DILocation(line: 27, column: 5, scope: !73)
!81 = !DILocalVariable(name: "x0", scope: !73, file: !3, line: 28, type: !26)
!82 = !DILocation(line: 28, column: 9, scope: !73)
!83 = !DILocation(line: 28, column: 14, scope: !73)
!84 = !DILocation(line: 29, column: 23, scope: !73)
!85 = !DILocation(line: 29, column: 26, scope: !73)
!86 = !DILocation(line: 29, column: 5, scope: !73)
!87 = !DILocation(line: 30, column: 5, scope: !73)
