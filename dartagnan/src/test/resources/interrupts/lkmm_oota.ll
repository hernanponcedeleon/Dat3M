; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_oota.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_oota.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx15.0.0"

@z = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !33
@h = global ptr null, align 8, !dbg !35
@x = global i32 0, align 4, !dbg !30

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @handler(ptr noundef %0) #0 !dbg !67 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !71, metadata !DIExpression()), !dbg !72
  call void @__LKMM_store(ptr noundef @z, i64 noundef 4, i64 noundef 3, i32 noundef 0), !dbg !73
  %3 = call i64 @__LKMM_load(ptr noundef @y, i64 noundef 4, i32 noundef 0), !dbg !74
  %4 = trunc i64 %3 to i32, !dbg !74
  %5 = icmp eq i32 %4, 0, !dbg !75
  %6 = zext i1 %5 to i32, !dbg !75
  call void @__VERIFIER_assert(i32 noundef %6), !dbg !76
  ret ptr null, !dbg !77
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_store(ptr noundef, i64 noundef, i64 noundef, i32 noundef) #2

declare void @__VERIFIER_assert(i32 noundef) #2

declare i64 @__LKMM_load(ptr noundef, i64 noundef, i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_1(ptr noundef %0) #0 !dbg !78 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !79, metadata !DIExpression()), !dbg !80
  call void @__VERIFIER_make_interrupt_handler(), !dbg !81
  %3 = call i32 @pthread_create(ptr noundef @h, ptr noundef null, ptr noundef @handler, ptr noundef null), !dbg !82
  %4 = call i64 @__LKMM_load(ptr noundef @x, i64 noundef 4, i32 noundef 0), !dbg !83
  %5 = trunc i64 %4 to i32, !dbg !83
  %6 = icmp eq i32 %5, 1, !dbg !85
  br i1 %6, label %7, label %8, !dbg !86

7:                                                ; preds = %1
  call void @__LKMM_store(ptr noundef @y, i64 noundef 4, i64 noundef 2, i32 noundef 0), !dbg !87
  br label %8, !dbg !89

8:                                                ; preds = %7, %1
  %9 = load ptr, ptr @h, align 8, !dbg !90
  %10 = call i32 @"\01_pthread_join"(ptr noundef %9, ptr noundef null), !dbg !91
  ret ptr null, !dbg !92
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_2(ptr noundef %0) #0 !dbg !93 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !94, metadata !DIExpression()), !dbg !95
  %3 = call i64 @__LKMM_load(ptr noundef @z, i64 noundef 4, i32 noundef 0), !dbg !96
  %4 = trunc i64 %3 to i32, !dbg !96
  %5 = icmp eq i32 %4, 3, !dbg !98
  br i1 %5, label %6, label %7, !dbg !99

6:                                                ; preds = %1
  call void @__LKMM_store(ptr noundef @x, i64 noundef 4, i64 noundef 1, i32 noundef 0), !dbg !100
  br label %7, !dbg !102

7:                                                ; preds = %6, %1
  ret ptr null, !dbg !103
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !104 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !107, metadata !DIExpression()), !dbg !108
  call void @llvm.dbg.declare(metadata ptr %3, metadata !109, metadata !DIExpression()), !dbg !110
  %4 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @thread_1, ptr noundef null), !dbg !111
  %5 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @thread_2, ptr noundef null), !dbg !112
  ret i32 0, !dbg !113
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!60, !61, !62, !63, !64, !65}
!llvm.ident = !{!66}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !32, line: 9, type: !27, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 16.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !22, globals: !29, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_oota.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "__LKMM_memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!22 = !{!23, !27, !28}
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "__LKMM_int_t", file: !6, line: 27, baseType: !24)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !25, line: 32, baseType: !26)
!25 = !DIFile(filename: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/_types/_intmax_t.h", directory: "")
!26 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!29 = !{!30, !33, !0, !35}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !32, line: 9, type: !27, isLocal: false, isDefinition: true)
!32 = !DIFile(filename: "benchmarks/interrupts/lkmm_oota.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !32, line: 9, type: !27, isLocal: false, isDefinition: true)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !32, line: 11, type: !37, isLocal: false, isDefinition: true)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !38, line: 31, baseType: !39)
!38 = !DIFile(filename: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !40, line: 118, baseType: !41)
!40 = !DIFile(filename: "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !40, line: 103, size: 65536, elements: !43)
!43 = !{!44, !45, !55}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !42, file: !40, line: 104, baseType: !26, size: 64)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !42, file: !40, line: 105, baseType: !46, size: 64, offset: 64)
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!47 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !40, line: 57, size: 192, elements: !48)
!48 = !{!49, !53, !54}
!49 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !47, file: !40, line: 58, baseType: !50, size: 64)
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!51 = !DISubroutineType(types: !52)
!52 = !{null, !28}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !47, file: !40, line: 59, baseType: !28, size: 64, offset: 64)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !47, file: !40, line: 60, baseType: !46, size: 64, offset: 128)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !42, file: !40, line: 106, baseType: !56, size: 65408, offset: 128)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !57, size: 65408, elements: !58)
!57 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!58 = !{!59}
!59 = !DISubrange(count: 8176)
!60 = !{i32 7, !"Dwarf Version", i32 4}
!61 = !{i32 2, !"Debug Info Version", i32 3}
!62 = !{i32 1, !"wchar_size", i32 4}
!63 = !{i32 8, !"PIC Level", i32 2}
!64 = !{i32 7, !"uwtable", i32 1}
!65 = !{i32 7, !"frame-pointer", i32 1}
!66 = !{!"Homebrew clang version 16.0.6"}
!67 = distinct !DISubprogram(name: "handler", scope: !32, file: !32, line: 12, type: !68, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!68 = !DISubroutineType(types: !69)
!69 = !{!28, !28}
!70 = !{}
!71 = !DILocalVariable(name: "arg", arg: 1, scope: !67, file: !32, line: 12, type: !28)
!72 = !DILocation(line: 12, column: 21, scope: !67)
!73 = !DILocation(line: 14, column: 5, scope: !67)
!74 = !DILocation(line: 15, column: 23, scope: !67)
!75 = !DILocation(line: 15, column: 36, scope: !67)
!76 = !DILocation(line: 15, column: 5, scope: !67)
!77 = !DILocation(line: 16, column: 5, scope: !67)
!78 = distinct !DISubprogram(name: "thread_1", scope: !32, file: !32, line: 19, type: !68, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!79 = !DILocalVariable(name: "arg", arg: 1, scope: !78, file: !32, line: 19, type: !28)
!80 = !DILocation(line: 19, column: 22, scope: !78)
!81 = !DILocation(line: 21, column: 5, scope: !78)
!82 = !DILocation(line: 22, column: 5, scope: !78)
!83 = !DILocation(line: 24, column: 8, scope: !84)
!84 = distinct !DILexicalBlock(scope: !78, file: !32, line: 24, column: 8)
!85 = !DILocation(line: 24, column: 21, scope: !84)
!86 = !DILocation(line: 24, column: 8, scope: !78)
!87 = !DILocation(line: 25, column: 9, scope: !88)
!88 = distinct !DILexicalBlock(scope: !84, file: !32, line: 24, column: 27)
!89 = !DILocation(line: 26, column: 5, scope: !88)
!90 = !DILocation(line: 28, column: 18, scope: !78)
!91 = !DILocation(line: 28, column: 5, scope: !78)
!92 = !DILocation(line: 30, column: 5, scope: !78)
!93 = distinct !DISubprogram(name: "thread_2", scope: !32, file: !32, line: 33, type: !68, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!94 = !DILocalVariable(name: "arg", arg: 1, scope: !93, file: !32, line: 33, type: !28)
!95 = !DILocation(line: 33, column: 22, scope: !93)
!96 = !DILocation(line: 35, column: 8, scope: !97)
!97 = distinct !DILexicalBlock(scope: !93, file: !32, line: 35, column: 8)
!98 = !DILocation(line: 35, column: 21, scope: !97)
!99 = !DILocation(line: 35, column: 8, scope: !93)
!100 = !DILocation(line: 36, column: 9, scope: !101)
!101 = distinct !DILexicalBlock(scope: !97, file: !32, line: 35, column: 27)
!102 = !DILocation(line: 37, column: 5, scope: !101)
!103 = !DILocation(line: 38, column: 5, scope: !93)
!104 = distinct !DISubprogram(name: "main", scope: !32, file: !32, line: 41, type: !105, scopeLine: 42, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !70)
!105 = !DISubroutineType(types: !106)
!106 = !{!27}
!107 = !DILocalVariable(name: "t1", scope: !104, file: !32, line: 43, type: !37)
!108 = !DILocation(line: 43, column: 15, scope: !104)
!109 = !DILocalVariable(name: "t2", scope: !104, file: !32, line: 43, type: !37)
!110 = !DILocation(line: 43, column: 19, scope: !104)
!111 = !DILocation(line: 45, column: 5, scope: !104)
!112 = !DILocation(line: 46, column: 5, scope: !104)
!113 = !DILocation(line: 48, column: 5, scope: !104)
