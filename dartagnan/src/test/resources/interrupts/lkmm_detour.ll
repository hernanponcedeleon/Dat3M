; ModuleID = 'benchmarks/interrupts/lkmm_detour.c'
source_filename = "benchmarks/interrupts/lkmm_detour.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@y = global i32 0, align 4, !dbg !0
@x = global i32 0, align 4, !dbg !26
@a = global i32 0, align 4, !dbg !29
@b = global i32 0, align 4, !dbg !31
@h = global ptr null, align 8, !dbg !33

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !66 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !70, !DIExpression(), !71)
  call void @__LKMM_STORE(ptr noundef @y, i32 noundef 3, i32 noundef 1), !dbg !72
  ret ptr null, !dbg !73
}

declare void @__LKMM_STORE(ptr noundef, i32 noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_1(ptr noundef %0) #0 !dbg !74 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !75, !DIExpression(), !76)
    #dbg_declare(ptr %3, !77, !DIExpression(), !79)
  call void @__VERIFIER_make_interrupt_handler(), !dbg !79
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !79
  %6 = load ptr, ptr %3, align 8, !dbg !79
  store ptr %6, ptr %4, align 8, !dbg !79
  %7 = load ptr, ptr %4, align 8, !dbg !79
  call void @__LKMM_STORE(ptr noundef @x, i32 noundef 1, i32 noundef 1), !dbg !80
  %8 = call i32 @__LKMM_LOAD(ptr noundef @y, i32 noundef 1), !dbg !81
  store i32 %8, ptr @a, align 4, !dbg !82
  ret ptr null, !dbg !83
}

declare void @__VERIFIER_make_interrupt_handler() #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @__LKMM_LOAD(ptr noundef, i32 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_2(ptr noundef %0) #0 !dbg !84 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !85, !DIExpression(), !86)
  %3 = call i32 @__LKMM_LOAD(ptr noundef @x, i32 noundef 1), !dbg !87
  store i32 %3, ptr @b, align 4, !dbg !88
  call void @__LKMM_STORE(ptr noundef @y, i32 noundef 2, i32 noundef 3), !dbg !89
  ret ptr null, !dbg !90
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !91 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !94, !DIExpression(), !95)
    #dbg_declare(ptr %3, !96, !DIExpression(), !97)
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !98
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !99
  %6 = load ptr, ptr %2, align 8, !dbg !100
  %7 = call i32 @"\01_pthread_join"(ptr noundef %6, ptr noundef null), !dbg !101
  %8 = load ptr, ptr %3, align 8, !dbg !102
  %9 = call i32 @"\01_pthread_join"(ptr noundef %8, ptr noundef null), !dbg !103
  %10 = load i32, ptr @b, align 4, !dbg !104
  %11 = icmp eq i32 %10, 1, !dbg !105
  br i1 %11, label %12, label %18, !dbg !106

12:                                               ; preds = %0
  %13 = load i32, ptr @a, align 4, !dbg !107
  %14 = icmp eq i32 %13, 3, !dbg !108
  br i1 %14, label %15, label %18, !dbg !109

15:                                               ; preds = %12
  %16 = load i32, ptr @y, align 4, !dbg !110
  %17 = icmp eq i32 %16, 3, !dbg !111
  br label %18

18:                                               ; preds = %15, %12, %0
  %19 = phi i1 [ false, %12 ], [ false, %0 ], [ %17, %15 ], !dbg !112
  %20 = xor i1 %19, true, !dbg !113
  %21 = zext i1 %20 to i32, !dbg !113
  call void @__VERIFIER_assert(i32 noundef %21), !dbg !114
  ret i32 0, !dbg !115
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

declare void @__VERIFIER_assert(i32 noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!59, !60, !61, !62, !63, !64}
!llvm.ident = !{!65}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 7, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/")
!3 = !DIFile(filename: "benchmarks/interrupts/lkmm_detour.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "1573d4431eb1a96d79ddfa36739c024c")
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
!25 = !{!26, !0, !29, !31, !33}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 7, type: !28, isLocal: false, isDefinition: true)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 7, type: !28, isLocal: false, isDefinition: true)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 7, type: !28, isLocal: false, isDefinition: true)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !3, line: 9, type: !35, isLocal: false, isDefinition: true)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !36, line: 31, baseType: !37)
!36 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !38, line: 118, baseType: !39)
!38 = !DIFile(filename: "/usr/local/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !38, line: 103, size: 65536, elements: !41)
!41 = !{!42, !44, !54}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !40, file: !38, line: 104, baseType: !43, size: 64)
!43 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !40, file: !38, line: 105, baseType: !45, size: 64, offset: 64)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!46 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !38, line: 57, size: 192, elements: !47)
!47 = !{!48, !52, !53}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !46, file: !38, line: 58, baseType: !49, size: 64)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!50 = !DISubroutineType(types: !51)
!51 = !{null, !24}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !46, file: !38, line: 59, baseType: !24, size: 64, offset: 64)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !46, file: !38, line: 60, baseType: !45, size: 64, offset: 128)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !40, file: !38, line: 106, baseType: !55, size: 65408, offset: 128)
!55 = !DICompositeType(tag: DW_TAG_array_type, baseType: !56, size: 65408, elements: !57)
!56 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!57 = !{!58}
!58 = !DISubrange(count: 8176)
!59 = !{i32 7, !"Dwarf Version", i32 5}
!60 = !{i32 2, !"Debug Info Version", i32 3}
!61 = !{i32 1, !"wchar_size", i32 4}
!62 = !{i32 8, !"PIC Level", i32 2}
!63 = !{i32 7, !"uwtable", i32 1}
!64 = !{i32 7, !"frame-pointer", i32 1}
!65 = !{!"Homebrew clang version 19.1.7"}
!66 = distinct !DISubprogram(name: "handler", scope: !3, file: !3, line: 10, type: !67, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !69)
!67 = !DISubroutineType(types: !68)
!68 = !{!24, !24}
!69 = !{}
!70 = !DILocalVariable(name: "arg", arg: 1, scope: !66, file: !3, line: 10, type: !24)
!71 = !DILocation(line: 10, column: 21, scope: !66)
!72 = !DILocation(line: 12, column: 5, scope: !66)
!73 = !DILocation(line: 13, column: 5, scope: !66)
!74 = distinct !DISubprogram(name: "thread_1", scope: !3, file: !3, line: 16, type: !67, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !69)
!75 = !DILocalVariable(name: "arg", arg: 1, scope: !74, file: !3, line: 16, type: !24)
!76 = !DILocation(line: 16, column: 22, scope: !74)
!77 = !DILocalVariable(name: "h", scope: !78, file: !3, line: 18, type: !35)
!78 = distinct !DILexicalBlock(scope: !74, file: !3, line: 18, column: 5)
!79 = !DILocation(line: 18, column: 5, scope: !78)
!80 = !DILocation(line: 20, column: 5, scope: !74)
!81 = !DILocation(line: 21, column: 9, scope: !74)
!82 = !DILocation(line: 21, column: 7, scope: !74)
!83 = !DILocation(line: 23, column: 5, scope: !74)
!84 = distinct !DISubprogram(name: "thread_2", scope: !3, file: !3, line: 26, type: !67, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !69)
!85 = !DILocalVariable(name: "arg", arg: 1, scope: !84, file: !3, line: 26, type: !24)
!86 = !DILocation(line: 26, column: 22, scope: !84)
!87 = !DILocation(line: 28, column: 9, scope: !84)
!88 = !DILocation(line: 28, column: 7, scope: !84)
!89 = !DILocation(line: 29, column: 5, scope: !84)
!90 = !DILocation(line: 30, column: 5, scope: !84)
!91 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 33, type: !92, scopeLine: 34, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !69)
!92 = !DISubroutineType(types: !93)
!93 = !{!28}
!94 = !DILocalVariable(name: "t1", scope: !91, file: !3, line: 35, type: !35)
!95 = !DILocation(line: 35, column: 15, scope: !91)
!96 = !DILocalVariable(name: "t2", scope: !91, file: !3, line: 35, type: !35)
!97 = !DILocation(line: 35, column: 19, scope: !91)
!98 = !DILocation(line: 37, column: 5, scope: !91)
!99 = !DILocation(line: 38, column: 5, scope: !91)
!100 = !DILocation(line: 39, column: 18, scope: !91)
!101 = !DILocation(line: 39, column: 5, scope: !91)
!102 = !DILocation(line: 40, column: 18, scope: !91)
!103 = !DILocation(line: 40, column: 5, scope: !91)
!104 = !DILocation(line: 42, column: 25, scope: !91)
!105 = !DILocation(line: 42, column: 27, scope: !91)
!106 = !DILocation(line: 42, column: 32, scope: !91)
!107 = !DILocation(line: 42, column: 35, scope: !91)
!108 = !DILocation(line: 42, column: 37, scope: !91)
!109 = !DILocation(line: 42, column: 42, scope: !91)
!110 = !DILocation(line: 42, column: 45, scope: !91)
!111 = !DILocation(line: 42, column: 47, scope: !91)
!112 = !DILocation(line: 0, scope: !91)
!113 = !DILocation(line: 42, column: 23, scope: !91)
!114 = !DILocation(line: 42, column: 5, scope: !91)
!115 = !DILocation(line: 44, column: 5, scope: !91)
