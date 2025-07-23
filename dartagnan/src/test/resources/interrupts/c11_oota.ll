; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/c11_oota.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/c11_oota.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@z = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !24
@h = global %struct._opaque_pthread_t* null, align 8, !dbg !26
@x = global i32 0, align 4, !dbg !18

; Function Attrs: noinline nounwind ssp uwtable
define i8* @handler(i8* noundef %0) #0 !dbg !63 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !67, metadata !DIExpression()), !dbg !68
  store i32 3, i32* %3, align 4, !dbg !69
  %5 = load i32, i32* %3, align 4, !dbg !69
  store atomic i32 %5, i32* @z monotonic, align 4, !dbg !69
  %6 = load atomic i32, i32* @y monotonic, align 4, !dbg !70
  store i32 %6, i32* %4, align 4, !dbg !70
  %7 = load i32, i32* %4, align 4, !dbg !70
  %8 = icmp eq i32 %7, 0, !dbg !71
  %9 = zext i1 %8 to i32, !dbg !71
  call void @__VERIFIER_assert(i32 noundef %9), !dbg !72
  ret i8* null, !dbg !73
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__VERIFIER_assert(i32 noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread_1(i8* noundef %0) #0 !dbg !74 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !75, metadata !DIExpression()), !dbg !76
  call void @__VERIFIER_make_interrupt_handler(), !dbg !77
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef @h, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null), !dbg !78
  %6 = load atomic i32, i32* @x monotonic, align 4, !dbg !79
  store i32 %6, i32* %3, align 4, !dbg !79
  %7 = load i32, i32* %3, align 4, !dbg !79
  %8 = icmp eq i32 %7, 1, !dbg !81
  br i1 %8, label %9, label %11, !dbg !82

9:                                                ; preds = %1
  store i32 2, i32* %4, align 4, !dbg !83
  %10 = load i32, i32* %4, align 4, !dbg !83
  store atomic i32 %10, i32* @y monotonic, align 4, !dbg !83
  br label %11, !dbg !85

11:                                               ; preds = %9, %1
  %12 = load %struct._opaque_pthread_t*, %struct._opaque_pthread_t** @h, align 8, !dbg !86
  %13 = call i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef %12, i8** noundef null), !dbg !87
  ret i8* null, !dbg !88
}

declare void @__VERIFIER_make_interrupt_handler() #2

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @"\01_pthread_join"(%struct._opaque_pthread_t* noundef, i8** noundef) #2

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread_2(i8* noundef %0) #0 !dbg !89 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !90, metadata !DIExpression()), !dbg !91
  %5 = load atomic i32, i32* @z monotonic, align 4, !dbg !92
  store i32 %5, i32* %3, align 4, !dbg !92
  %6 = load i32, i32* %3, align 4, !dbg !92
  %7 = icmp eq i32 %6, 3, !dbg !94
  br i1 %7, label %8, label %10, !dbg !95

8:                                                ; preds = %1
  store i32 1, i32* %4, align 4, !dbg !96
  %9 = load i32, i32* %4, align 4, !dbg !96
  store atomic i32 %9, i32* @x monotonic, align 4, !dbg !96
  br label %10, !dbg !98

10:                                               ; preds = %8, %1
  ret i8* null, !dbg !99
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !100 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !103, metadata !DIExpression()), !dbg !104
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !105, metadata !DIExpression()), !dbg !106
  %4 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef null), !dbg !107
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_2, i8* noundef null), !dbg !108
  ret i32 0, !dbg !109
}

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!52, !53, !54, !55, !56, !57, !58, !59, !60, !61}
!llvm.ident = !{!62}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !20, line: 7, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/interrupts/c11_oota.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!17 = !{!18, !24, !0, !26}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !20, line: 7, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/interrupts/c11_oota.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !20, line: 7, type: !21, isLocal: false, isDefinition: true)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !20, line: 9, type: !28, isLocal: false, isDefinition: true)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !29, line: 31, baseType: !30)
!29 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !31, line: 118, baseType: !32)
!31 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !31, line: 103, size: 65536, elements: !34)
!34 = !{!35, !37, !47}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !33, file: !31, line: 104, baseType: !36, size: 64)
!36 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !33, file: !31, line: 105, baseType: !38, size: 64, offset: 64)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !31, line: 57, size: 192, elements: !40)
!40 = !{!41, !45, !46}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !39, file: !31, line: 58, baseType: !42, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!43 = !DISubroutineType(types: !44)
!44 = !{null, !16}
!45 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !39, file: !31, line: 59, baseType: !16, size: 64, offset: 64)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !39, file: !31, line: 60, baseType: !38, size: 64, offset: 128)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !33, file: !31, line: 106, baseType: !48, size: 65408, offset: 128)
!48 = !DICompositeType(tag: DW_TAG_array_type, baseType: !49, size: 65408, elements: !50)
!49 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!50 = !{!51}
!51 = !DISubrange(count: 8176)
!52 = !{i32 7, !"Dwarf Version", i32 4}
!53 = !{i32 2, !"Debug Info Version", i32 3}
!54 = !{i32 1, !"wchar_size", i32 4}
!55 = !{i32 1, !"branch-target-enforcement", i32 0}
!56 = !{i32 1, !"sign-return-address", i32 0}
!57 = !{i32 1, !"sign-return-address-all", i32 0}
!58 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!59 = !{i32 7, !"PIC Level", i32 2}
!60 = !{i32 7, !"uwtable", i32 1}
!61 = !{i32 7, !"frame-pointer", i32 1}
!62 = !{!"Homebrew clang version 14.0.6"}
!63 = distinct !DISubprogram(name: "handler", scope: !20, file: !20, line: 10, type: !64, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!64 = !DISubroutineType(types: !65)
!65 = !{!16, !16}
!66 = !{}
!67 = !DILocalVariable(name: "arg", arg: 1, scope: !63, file: !20, line: 10, type: !16)
!68 = !DILocation(line: 10, column: 21, scope: !63)
!69 = !DILocation(line: 12, column: 5, scope: !63)
!70 = !DILocation(line: 13, column: 23, scope: !63)
!71 = !DILocation(line: 13, column: 70, scope: !63)
!72 = !DILocation(line: 13, column: 5, scope: !63)
!73 = !DILocation(line: 14, column: 5, scope: !63)
!74 = distinct !DISubprogram(name: "thread_1", scope: !20, file: !20, line: 17, type: !64, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!75 = !DILocalVariable(name: "arg", arg: 1, scope: !74, file: !20, line: 17, type: !16)
!76 = !DILocation(line: 17, column: 22, scope: !74)
!77 = !DILocation(line: 19, column: 5, scope: !74)
!78 = !DILocation(line: 20, column: 5, scope: !74)
!79 = !DILocation(line: 22, column: 8, scope: !80)
!80 = distinct !DILexicalBlock(scope: !74, file: !20, line: 22, column: 8)
!81 = !DILocation(line: 22, column: 55, scope: !80)
!82 = !DILocation(line: 22, column: 8, scope: !74)
!83 = !DILocation(line: 23, column: 9, scope: !84)
!84 = distinct !DILexicalBlock(scope: !80, file: !20, line: 22, column: 61)
!85 = !DILocation(line: 24, column: 5, scope: !84)
!86 = !DILocation(line: 26, column: 18, scope: !74)
!87 = !DILocation(line: 26, column: 5, scope: !74)
!88 = !DILocation(line: 28, column: 5, scope: !74)
!89 = distinct !DISubprogram(name: "thread_2", scope: !20, file: !20, line: 31, type: !64, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!90 = !DILocalVariable(name: "arg", arg: 1, scope: !89, file: !20, line: 31, type: !16)
!91 = !DILocation(line: 31, column: 22, scope: !89)
!92 = !DILocation(line: 33, column: 8, scope: !93)
!93 = distinct !DILexicalBlock(scope: !89, file: !20, line: 33, column: 8)
!94 = !DILocation(line: 33, column: 55, scope: !93)
!95 = !DILocation(line: 33, column: 8, scope: !89)
!96 = !DILocation(line: 34, column: 9, scope: !97)
!97 = distinct !DILexicalBlock(scope: !93, file: !20, line: 33, column: 61)
!98 = !DILocation(line: 35, column: 5, scope: !97)
!99 = !DILocation(line: 36, column: 5, scope: !89)
!100 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 39, type: !101, scopeLine: 40, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!101 = !DISubroutineType(types: !102)
!102 = !{!23}
!103 = !DILocalVariable(name: "t1", scope: !100, file: !20, line: 41, type: !28)
!104 = !DILocation(line: 41, column: 15, scope: !100)
!105 = !DILocalVariable(name: "t2", scope: !100, file: !20, line: 41, type: !28)
!106 = !DILocation(line: 41, column: 19, scope: !100)
!107 = !DILocation(line: 43, column: 5, scope: !100)
!108 = !DILocation(line: 44, column: 5, scope: !100)
!109 = !DILocation(line: 46, column: 5, scope: !100)
