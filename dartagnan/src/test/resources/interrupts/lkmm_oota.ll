; ModuleID = 'benchmarks/interrupts/lkmm_oota.c'
source_filename = "benchmarks/interrupts/lkmm_oota.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@z = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !29
@x = global i32 0, align 4, !dbg !26
@h = global ptr null, align 8, !dbg !31

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !64 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !68, !DIExpression(), !69)
  call void @__LKMM_STORE(ptr noundef @z, i32 noundef 3, i32 noundef 1), !dbg !70
  %3 = call i32 @__LKMM_LOAD(ptr noundef @y, i32 noundef 1), !dbg !71
  %4 = icmp eq i32 %3, 0, !dbg !72
  %5 = zext i1 %4 to i32, !dbg !72
  call void @__VERIFIER_assert(i32 noundef %5), !dbg !73
  ret ptr null, !dbg !74
}

declare void @__LKMM_STORE(ptr noundef, i32 noundef, i32 noundef) #1

declare void @__VERIFIER_assert(i32 noundef) #1

declare i32 @__LKMM_LOAD(ptr noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_1(ptr noundef %0) #0 !dbg !75 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !76, !DIExpression(), !77)
    #dbg_declare(ptr %3, !78, !DIExpression(), !80)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !80
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !80
  %6 = load ptr, ptr %3, align 8, !dbg !80
  store ptr %6, ptr %4, align 8, !dbg !80
  %7 = load ptr, ptr %4, align 8, !dbg !80
  %8 = call i32 @__LKMM_LOAD(ptr noundef @x, i32 noundef 1), !dbg !81
  %9 = icmp eq i32 %8, 1, !dbg !83
  br i1 %9, label %10, label %11, !dbg !84

10:                                               ; preds = %1
  call void @__LKMM_STORE(ptr noundef @y, i32 noundef 2, i32 noundef 1), !dbg !85
  br label %11, !dbg !87

11:                                               ; preds = %10, %1
  ret ptr null, !dbg !88
}

declare void @__VERIFIER_make_interrupt_handler() #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_2(ptr noundef %0) #0 !dbg !89 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !90, !DIExpression(), !91)
  %3 = call i32 @__LKMM_LOAD(ptr noundef @z, i32 noundef 1), !dbg !92
  %4 = icmp eq i32 %3, 3, !dbg !94
  br i1 %4, label %5, label %6, !dbg !95

5:                                                ; preds = %1
  call void @__LKMM_STORE(ptr noundef @x, i32 noundef 1, i32 noundef 1), !dbg !96
  br label %6, !dbg !98

6:                                                ; preds = %5, %1
  ret ptr null, !dbg !99
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !100 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !103, !DIExpression(), !104)
    #dbg_declare(ptr %3, !105, !DIExpression(), !106)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !107
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !108
  ret i32 0, !dbg !109
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!57, !58, !59, !60, !61, !62}
!llvm.ident = !{!63}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !3, line: 7, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/interrupts/lkmm_oota.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "2f9ce9a08c7efd50c14ecd16fdadd35f")
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
!25 = !{!26, !29, !0, !31}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !28, isLocal: false, isDefinition: true)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !28, isLocal: false, isDefinition: true)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !3, line: 9, type: !33, isLocal: false, isDefinition: true)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !34, line: 31, baseType: !35)
!34 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !36, line: 118, baseType: !37)
!36 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!38 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !36, line: 103, size: 65536, elements: !39)
!39 = !{!40, !42, !52}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !38, file: !36, line: 104, baseType: !41, size: 64)
!41 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !38, file: !36, line: 105, baseType: !43, size: 64, offset: 64)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!44 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !36, line: 57, size: 192, elements: !45)
!45 = !{!46, !50, !51}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !44, file: !36, line: 58, baseType: !47, size: 64)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!48 = !DISubroutineType(types: !49)
!49 = !{null, !24}
!50 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !44, file: !36, line: 59, baseType: !24, size: 64, offset: 64)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !44, file: !36, line: 60, baseType: !43, size: 64, offset: 128)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !38, file: !36, line: 106, baseType: !53, size: 65408, offset: 128)
!53 = !DICompositeType(tag: DW_TAG_array_type, baseType: !54, size: 65408, elements: !55)
!54 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!55 = !{!56}
!56 = !DISubrange(count: 8176)
!57 = !{i32 7, !"Dwarf Version", i32 5}
!58 = !{i32 2, !"Debug Info Version", i32 3}
!59 = !{i32 1, !"wchar_size", i32 4}
!60 = !{i32 8, !"PIC Level", i32 2}
!61 = !{i32 7, !"uwtable", i32 1}
!62 = !{i32 7, !"frame-pointer", i32 1}
!63 = !{!"Homebrew clang version 19.1.7"}
!64 = distinct !DISubprogram(name: "handler", scope: !3, file: !3, line: 10, type: !65, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!65 = !DISubroutineType(types: !66)
!66 = !{!24, !24}
!67 = !{}
!68 = !DILocalVariable(name: "arg", arg: 1, scope: !64, file: !3, line: 10, type: !24)
!69 = !DILocation(line: 10, column: 21, scope: !64)
!70 = !DILocation(line: 12, column: 5, scope: !64)
!71 = !DILocation(line: 13, column: 23, scope: !64)
!72 = !DILocation(line: 13, column: 36, scope: !64)
!73 = !DILocation(line: 13, column: 5, scope: !64)
!74 = !DILocation(line: 14, column: 5, scope: !64)
!75 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 17, type: !65, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!76 = !DILocalVariable(name: "arg", arg: 1, scope: !75, file: !3, line: 17, type: !24)
!77 = !DILocation(line: 17, column: 22, scope: !75)
!78 = !DILocalVariable(name: "h", scope: !79, file: !3, line: 19, type: !33)
!79 = distinct !DILexicalBlock(scope: !75, file: !3, line: 19, column: 5)
!80 = !DILocation(line: 19, column: 5, scope: !79)
!81 = !DILocation(line: 21, column: 8, scope: !82)
!82 = distinct !DILexicalBlock(scope: !75, file: !3, line: 21, column: 8)
!83 = !DILocation(line: 21, column: 21, scope: !82)
!84 = !DILocation(line: 21, column: 8, scope: !75)
!85 = !DILocation(line: 22, column: 9, scope: !86)
!86 = distinct !DILexicalBlock(scope: !82, file: !3, line: 21, column: 27)
!87 = !DILocation(line: 23, column: 5, scope: !86)
!88 = !DILocation(line: 25, column: 5, scope: !75)
!89 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 28, type: !65, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!90 = !DILocalVariable(name: "arg", arg: 1, scope: !89, file: !3, line: 28, type: !24)
!91 = !DILocation(line: 28, column: 22, scope: !89)
!92 = !DILocation(line: 30, column: 8, scope: !93)
!93 = distinct !DILexicalBlock(scope: !89, file: !3, line: 30, column: 8)
!94 = !DILocation(line: 30, column: 21, scope: !93)
!95 = !DILocation(line: 30, column: 8, scope: !89)
!96 = !DILocation(line: 31, column: 9, scope: !97)
!97 = distinct !DILexicalBlock(scope: !93, file: !3, line: 30, column: 27)
!98 = !DILocation(line: 32, column: 5, scope: !97)
!99 = !DILocation(line: 33, column: 5, scope: !89)
!100 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 36, type: !101, scopeLine: 37, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!101 = !DISubroutineType(types: !102)
!102 = !{!28}
!103 = !DILocalVariable(name: "t1", scope: !100, file: !3, line: 38, type: !33)
!104 = !DILocation(line: 38, column: 15, scope: !100)
!105 = !DILocalVariable(name: "t2", scope: !100, file: !3, line: 38, type: !33)
!106 = !DILocation(line: 38, column: 19, scope: !100)
!107 = !DILocation(line: 40, column: 5, scope: !100)
!108 = !DILocation(line: 41, column: 5, scope: !100)
!109 = !DILocation(line: 43, column: 5, scope: !100)
