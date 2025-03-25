; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/c11_detour_disable.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/c11_detour_disable.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@y = global i32 0, align 4, !dbg !0
@h = global %struct._opaque_pthread_t* null, align 8, !dbg !28
@x = global i32 0, align 4, !dbg !18
@a = global i32 0, align 4, !dbg !24
@b = global i32 0, align 4, !dbg !26

; Function Attrs: noinline nounwind ssp uwtable
define i8* @handler(i8* noundef %0) #0 !dbg !65 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !69, metadata !DIExpression()), !dbg !70
  store i32 3, i32* %3, align 4, !dbg !71
  %4 = load i32, i32* %3, align 4, !dbg !71
  store atomic i32 %4, i32* @y seq_cst, align 4, !dbg !71
  ret i8* null, !dbg !72
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread_1(i8* noundef %0) #0 !dbg !73 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !74, metadata !DIExpression()), !dbg !75
  call void @__VERIFIER_make_interrupt_handler(), !dbg !76
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef @h, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null), !dbg !77
  call void @__VERIFIER_disable_irq(), !dbg !78
  store i32 1, i32* %3, align 4, !dbg !79
  %6 = load i32, i32* %3, align 4, !dbg !79
  store atomic i32 %6, i32* @x monotonic, align 4, !dbg !79
  %7 = load atomic i32, i32* @y monotonic, align 4, !dbg !80
  store i32 %7, i32* %4, align 4, !dbg !80
  %8 = load i32, i32* %4, align 4, !dbg !80
  store i32 %8, i32* @a, align 4, !dbg !81
  call void @__VERIFIER_enable_irq(), !dbg !82
  %9 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** @h, align 8, !dbg !83
  %10 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %9, i8** noundef null), !dbg !84
  ret i8* null, !dbg !85
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare void @__VERIFIER_disable_irq() #2

declare void @__VERIFIER_enable_irq() #2

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef, i8** noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread_2(i8* noundef %0) #0 !dbg !86 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !87, metadata !DIExpression()), !dbg !88
  %5 = load atomic i32, i32* @x monotonic, align 4, !dbg !89
  store i32 %5, i32* %3, align 4, !dbg !89
  %6 = load i32, i32* %3, align 4, !dbg !89
  store i32 %6, i32* @b, align 4, !dbg !90
  store i32 2, i32* %4, align 4, !dbg !91
  %7 = load i32, i32* %4, align 4, !dbg !91
  store atomic i32 %7, i32* @y release, align 4, !dbg !91
  ret i8* null, !dbg !92
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !93 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !96, metadata !DIExpression()), !dbg !97
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !98, metadata !DIExpression()), !dbg !99
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef null), !dbg !100
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_2, i8* noundef null), !dbg !101
  %6 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %2, align 8, !dbg !102
  %7 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %6, i8** noundef null), !dbg !103
  %8 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** %3, align 8, !dbg !104
  %9 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %8, i8** noundef null), !dbg !105
  %10 = load i32, i32* @b, align 4, !dbg !106
  %11 = icmp eq i32 %10, 1, !dbg !107
  br i1 %11, label %12, label %18, !dbg !108

12:                                               ; preds = %0
  %13 = load i32, i32* @a, align 4, !dbg !109
  %14 = icmp eq i32 %13, 3, !dbg !110
  br i1 %14, label %15, label %18, !dbg !111

15:                                               ; preds = %12
  %16 = load atomic i32, i32* @y seq_cst, align 4, !dbg !112
  %17 = icmp eq i32 %16, 3, !dbg !113
  br label %18

18:                                               ; preds = %15, %12, %0
  %19 = phi i1 [ false, %12 ], [ false, %0 ], [ %17, %15 ], !dbg !114
  %20 = xor i1 %19, true, !dbg !115
  %21 = zext i1 %20 to i32, !dbg !115
  call void @__VERIFIER_assert(i32 noundef %21), !dbg !116
  ret i32 0, !dbg !117
}

declare void @__VERIFIER_assert(i32 noundef) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!54, !55, !56, !57, !58, !59, !60, !61, !62, !63}
!llvm.ident = !{!64}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !20, line: 7, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/c11_detour_disable.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 56, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/opt/homebrew/Cellar/llvm@14/14.0.6/lib/clang/14.0.6/include/stdatomic.h", directory: "")
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
!17 = !{!18, !0, !24, !26, !28}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !20, line: 7, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/interrupts/c11_detour_disable.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !20, line: 10, type: !30, isLocal: false, isDefinition: true)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !31, line: 31, baseType: !32)
!31 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !33, line: 118, baseType: !34)
!33 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !33, line: 103, size: 65536, elements: !36)
!36 = !{!37, !39, !49}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !35, file: !33, line: 104, baseType: !38, size: 64)
!38 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !35, file: !33, line: 105, baseType: !40, size: 64, offset: 64)
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!41 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !33, line: 57, size: 192, elements: !42)
!42 = !{!43, !47, !48}
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !41, file: !33, line: 58, baseType: !44, size: 64)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!45 = !DISubroutineType(types: !46)
!46 = !{null, !16}
!47 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !41, file: !33, line: 59, baseType: !16, size: 64, offset: 64)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !41, file: !33, line: 60, baseType: !40, size: 64, offset: 128)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !35, file: !33, line: 106, baseType: !50, size: 65408, offset: 128)
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !51, size: 65408, elements: !52)
!51 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!52 = !{!53}
!53 = !DISubrange(count: 8176)
!54 = !{i32 7, !"Dwarf Version", i32 4}
!55 = !{i32 2, !"Debug Info Version", i32 3}
!56 = !{i32 1, !"wchar_size", i32 4}
!57 = !{i32 1, !"branch-target-enforcement", i32 0}
!58 = !{i32 1, !"sign-return-address", i32 0}
!59 = !{i32 1, !"sign-return-address-all", i32 0}
!60 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!61 = !{i32 7, !"PIC Level", i32 2}
!62 = !{i32 7, !"uwtable", i32 1}
!63 = !{i32 7, !"frame-pointer", i32 1}
!64 = !{!"Homebrew clang version 14.0.6"}
!65 = distinct !DISubprogram(name: "handler", scope: !20, file: !20, line: 11, type: !66, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!66 = !DISubroutineType(types: !67)
!67 = !{!16, !16}
!68 = !{}
!69 = !DILocalVariable(name: "arg", arg: 1, scope: !65, file: !20, line: 11, type: !16)
!70 = !DILocation(line: 11, column: 21, scope: !65)
!71 = !DILocation(line: 13, column: 5, scope: !65)
!72 = !DILocation(line: 14, column: 5, scope: !65)
!73 = distinct !DISubprogram(name: "thread_1", scope: !20, file: !20, line: 17, type: !66, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!74 = !DILocalVariable(name: "arg", arg: 1, scope: !73, file: !20, line: 17, type: !16)
!75 = !DILocation(line: 17, column: 22, scope: !73)
!76 = !DILocation(line: 19, column: 5, scope: !73)
!77 = !DILocation(line: 20, column: 5, scope: !73)
!78 = !DILocation(line: 22, column: 5, scope: !73)
!79 = !DILocation(line: 23, column: 5, scope: !73)
!80 = !DILocation(line: 24, column: 9, scope: !73)
!81 = !DILocation(line: 24, column: 7, scope: !73)
!82 = !DILocation(line: 25, column: 5, scope: !73)
!83 = !DILocation(line: 27, column: 18, scope: !73)
!84 = !DILocation(line: 27, column: 5, scope: !73)
!85 = !DILocation(line: 29, column: 5, scope: !73)
!86 = distinct !DISubprogram(name: "thread_2", scope: !20, file: !20, line: 32, type: !66, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!87 = !DILocalVariable(name: "arg", arg: 1, scope: !86, file: !20, line: 32, type: !16)
!88 = !DILocation(line: 32, column: 22, scope: !86)
!89 = !DILocation(line: 34, column: 9, scope: !86)
!90 = !DILocation(line: 34, column: 7, scope: !86)
!91 = !DILocation(line: 35, column: 5, scope: !86)
!92 = !DILocation(line: 36, column: 5, scope: !86)
!93 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 39, type: !94, scopeLine: 40, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!94 = !DISubroutineType(types: !95)
!95 = !{!23}
!96 = !DILocalVariable(name: "t1", scope: !93, file: !20, line: 41, type: !30)
!97 = !DILocation(line: 41, column: 15, scope: !93)
!98 = !DILocalVariable(name: "t2", scope: !93, file: !20, line: 41, type: !30)
!99 = !DILocation(line: 41, column: 19, scope: !93)
!100 = !DILocation(line: 43, column: 5, scope: !93)
!101 = !DILocation(line: 44, column: 5, scope: !93)
!102 = !DILocation(line: 45, column: 18, scope: !93)
!103 = !DILocation(line: 45, column: 5, scope: !93)
!104 = !DILocation(line: 46, column: 18, scope: !93)
!105 = !DILocation(line: 46, column: 5, scope: !93)
!106 = !DILocation(line: 48, column: 25, scope: !93)
!107 = !DILocation(line: 48, column: 27, scope: !93)
!108 = !DILocation(line: 48, column: 32, scope: !93)
!109 = !DILocation(line: 48, column: 35, scope: !93)
!110 = !DILocation(line: 48, column: 37, scope: !93)
!111 = !DILocation(line: 48, column: 42, scope: !93)
!112 = !DILocation(line: 48, column: 45, scope: !93)
!113 = !DILocation(line: 48, column: 47, scope: !93)
!114 = !DILocation(line: 0, scope: !93)
!115 = !DILocation(line: 48, column: 23, scope: !93)
!116 = !DILocation(line: 48, column: 5, scope: !93)
!117 = !DILocation(line: 50, column: 5, scope: !93)
