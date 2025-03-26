; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_oota.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_oota.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@z = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !30
@h = global %struct._opaque_pthread_t* null, align 8, !dbg !32
@x = global i32 0, align 4, !dbg !26

; Function Attrs: noinline nounwind ssp uwtable
define i8* @handler(i8* noundef %0) #0 !dbg !69 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !73, metadata !DIExpression()), !dbg !74
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @z to i8*), i32 noundef 3, i32 noundef 1), !dbg !75
  %3 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1), !dbg !76
  %4 = icmp eq i32 %3, 0, !dbg !77
  %5 = zext i1 %4 to i32, !dbg !77
  call void @__VERIFIER_assert(i32 noundef %5), !dbg !78
  ret i8* null, !dbg !79
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_STORE(i8* noundef, i32 noundef, i32 noundef) #2

declare void @__VERIFIER_assert(i32 noundef) #2

declare i32 @__LKMM_LOAD(i8* noundef, i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread_1(i8* noundef %0) #0 !dbg !80 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !81, metadata !DIExpression()), !dbg !82
  call void @__VERIFIER_make_interrupt_handler(), !dbg !83
  %3 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef @h, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null), !dbg !84
  %4 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1), !dbg !85
  %5 = icmp eq i32 %4, 1, !dbg !87
  br i1 %5, label %6, label %7, !dbg !88

6:                                                ; preds = %1
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @y to i8*), i32 noundef 2, i32 noundef 1), !dbg !89
  br label %7, !dbg !91

7:                                                ; preds = %6, %1
  %8 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** @h, align 8, !dbg !92
  %9 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %8, i8** noundef null), !dbg !93
  ret i8* null, !dbg !94
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef, i8** noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread_2(i8* noundef %0) #0 !dbg !95 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !96, metadata !DIExpression()), !dbg !97
  %3 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @z to i8*), i32 noundef 1), !dbg !98
  %4 = icmp eq i32 %3, 3, !dbg !100
  br i1 %4, label %5, label %6, !dbg !101

5:                                                ; preds = %1
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1, i32 noundef 1), !dbg !102
  br label %6, !dbg !104

6:                                                ; preds = %5, %1
  ret i8* null, !dbg !105
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !106 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !109, metadata !DIExpression()), !dbg !110
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !111, metadata !DIExpression()), !dbg !112
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef null), !dbg !113
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_2, i8* noundef null), !dbg !114
  ret i32 0, !dbg !115
}

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!58, !59, !60, !61, !62, !63, !64, !65, !66, !67}
!llvm.ident = !{!68}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/lkmm_oota.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!25 = !{!26, !30, !0, !32}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/interrupts/lkmm_oota.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !28, line: 9, type: !34, isLocal: false, isDefinition: true)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !35, line: 31, baseType: !36)
!35 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !37, line: 118, baseType: !38)
!37 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !37, line: 103, size: 65536, elements: !40)
!40 = !{!41, !43, !53}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !39, file: !37, line: 104, baseType: !42, size: 64)
!42 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !39, file: !37, line: 105, baseType: !44, size: 64, offset: 64)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!45 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !37, line: 57, size: 192, elements: !46)
!46 = !{!47, !51, !52}
!47 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !45, file: !37, line: 58, baseType: !48, size: 64)
!48 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!49 = !DISubroutineType(types: !50)
!50 = !{null, !24}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !45, file: !37, line: 59, baseType: !24, size: 64, offset: 64)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !45, file: !37, line: 60, baseType: !44, size: 64, offset: 128)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !39, file: !37, line: 106, baseType: !54, size: 65408, offset: 128)
!54 = !DICompositeType(tag: DW_TAG_array_type, baseType: !55, size: 65408, elements: !56)
!55 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!56 = !{!57}
!57 = !DISubrange(count: 8176)
!58 = !{i32 7, !"Dwarf Version", i32 4}
!59 = !{i32 2, !"Debug Info Version", i32 3}
!60 = !{i32 1, !"wchar_size", i32 4}
!61 = !{i32 1, !"branch-target-enforcement", i32 0}
!62 = !{i32 1, !"sign-return-address", i32 0}
!63 = !{i32 1, !"sign-return-address-all", i32 0}
!64 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!65 = !{i32 7, !"PIC Level", i32 2}
!66 = !{i32 7, !"uwtable", i32 1}
!67 = !{i32 7, !"frame-pointer", i32 1}
!68 = !{!"Homebrew clang version 14.0.6"}
!69 = distinct !DISubprogram(name: "handler", scope: !28, file: !28, line: 10, type: !70, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!70 = !DISubroutineType(types: !71)
!71 = !{!24, !24}
!72 = !{}
!73 = !DILocalVariable(name: "arg", arg: 1, scope: !69, file: !28, line: 10, type: !24)
!74 = !DILocation(line: 10, column: 21, scope: !69)
!75 = !DILocation(line: 12, column: 5, scope: !69)
!76 = !DILocation(line: 13, column: 23, scope: !69)
!77 = !DILocation(line: 13, column: 36, scope: !69)
!78 = !DILocation(line: 13, column: 5, scope: !69)
!79 = !DILocation(line: 14, column: 5, scope: !69)
!80 = distinct !DISubprogram(name: "thread_1", scope: !28, file: !28, line: 17, type: !70, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!81 = !DILocalVariable(name: "arg", arg: 1, scope: !80, file: !28, line: 17, type: !24)
!82 = !DILocation(line: 17, column: 22, scope: !80)
!83 = !DILocation(line: 19, column: 5, scope: !80)
!84 = !DILocation(line: 20, column: 5, scope: !80)
!85 = !DILocation(line: 22, column: 8, scope: !86)
!86 = distinct !DILexicalBlock(scope: !80, file: !28, line: 22, column: 8)
!87 = !DILocation(line: 22, column: 21, scope: !86)
!88 = !DILocation(line: 22, column: 8, scope: !80)
!89 = !DILocation(line: 23, column: 9, scope: !90)
!90 = distinct !DILexicalBlock(scope: !86, file: !28, line: 22, column: 27)
!91 = !DILocation(line: 24, column: 5, scope: !90)
!92 = !DILocation(line: 26, column: 18, scope: !80)
!93 = !DILocation(line: 26, column: 5, scope: !80)
!94 = !DILocation(line: 28, column: 5, scope: !80)
!95 = distinct !DISubprogram(name: "thread_2", scope: !28, file: !28, line: 31, type: !70, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!96 = !DILocalVariable(name: "arg", arg: 1, scope: !95, file: !28, line: 31, type: !24)
!97 = !DILocation(line: 31, column: 22, scope: !95)
!98 = !DILocation(line: 33, column: 8, scope: !99)
!99 = distinct !DILexicalBlock(scope: !95, file: !28, line: 33, column: 8)
!100 = !DILocation(line: 33, column: 21, scope: !99)
!101 = !DILocation(line: 33, column: 8, scope: !95)
!102 = !DILocation(line: 34, column: 9, scope: !103)
!103 = distinct !DILexicalBlock(scope: !99, file: !28, line: 33, column: 27)
!104 = !DILocation(line: 35, column: 5, scope: !103)
!105 = !DILocation(line: 36, column: 5, scope: !95)
!106 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 39, type: !107, scopeLine: 40, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !72)
!107 = !DISubroutineType(types: !108)
!108 = !{!29}
!109 = !DILocalVariable(name: "t1", scope: !106, file: !28, line: 41, type: !34)
!110 = !DILocation(line: 41, column: 15, scope: !106)
!111 = !DILocalVariable(name: "t2", scope: !106, file: !28, line: 41, type: !34)
!112 = !DILocation(line: 41, column: 19, scope: !106)
!113 = !DILocation(line: 43, column: 5, scope: !106)
!114 = !DILocation(line: 44, column: 5, scope: !106)
!115 = !DILocation(line: 46, column: 5, scope: !106)
