; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_complex.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_complex.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !7
@z = global i32 0, align 4, !dbg !14

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread(i8* noundef %0) #0 !dbg !27 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !31, metadata !DIExpression()), !dbg !32
  br label %3, !dbg !33

3:                                                ; preds = %6, %1
  %4 = load atomic i32, i32* @y seq_cst, align 4, !dbg !34
  %5 = icmp ne i32 %4, 1, !dbg !35
  br i1 %5, label %6, label %7, !dbg !33

6:                                                ; preds = %3
  store atomic i32 1, i32* @x seq_cst, align 4, !dbg !36
  store atomic i32 0, i32* @x seq_cst, align 4, !dbg !38
  store atomic i32 1, i32* @y seq_cst, align 4, !dbg !39
  br label %3, !dbg !33, !llvm.loop !40

7:                                                ; preds = %3
  ret i8* null, !dbg !43
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread2(i8* noundef %0) #0 !dbg !44 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !45, metadata !DIExpression()), !dbg !46
  br label %4, !dbg !47

4:                                                ; preds = %24, %1
  %5 = load atomic i32, i32* @x seq_cst, align 4, !dbg !48
  %6 = icmp eq i32 %5, 1, !dbg !49
  br i1 %6, label %7, label %13, !dbg !50

7:                                                ; preds = %4
  %8 = load atomic i32, i32* @y seq_cst, align 4, !dbg !51
  %9 = icmp ne i32 %8, 0, !dbg !52
  br i1 %9, label %10, label %13, !dbg !53

10:                                               ; preds = %7
  %11 = load atomic i32, i32* @z seq_cst, align 4, !dbg !54
  %12 = icmp ne i32 %11, 3, !dbg !55
  br label %13

13:                                               ; preds = %10, %7, %4
  %14 = phi i1 [ false, %7 ], [ false, %4 ], [ %12, %10 ], !dbg !56
  br i1 %14, label %15, label %25, !dbg !47

15:                                               ; preds = %13
  call void @llvm.dbg.declare(metadata i32* %3, metadata !57, metadata !DIExpression()), !dbg !60
  store i32 0, i32* %3, align 4, !dbg !60
  br label %16, !dbg !61

16:                                               ; preds = %21, %15
  %17 = load i32, i32* %3, align 4, !dbg !62
  %18 = icmp slt i32 %17, 4, !dbg !64
  br i1 %18, label %19, label %24, !dbg !65

19:                                               ; preds = %16
  %20 = load i32, i32* %3, align 4, !dbg !66
  store atomic i32 %20, i32* @z seq_cst, align 4, !dbg !68
  br label %21, !dbg !69

21:                                               ; preds = %19
  %22 = load i32, i32* %3, align 4, !dbg !70
  %23 = add nsw i32 %22, 1, !dbg !70
  store i32 %23, i32* %3, align 4, !dbg !70
  br label %16, !dbg !71, !llvm.loop !72

24:                                               ; preds = %16
  br label %4, !dbg !47, !llvm.loop !74

25:                                               ; preds = %13
  ret i8* null, !dbg !76
}

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread3(i8* noundef %0) #0 !dbg !77 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !78, metadata !DIExpression()), !dbg !79
  br label %3, !dbg !80

3:                                                ; preds = %6, %1
  %4 = load atomic i32, i32* @z seq_cst, align 4, !dbg !81
  %5 = icmp eq i32 %4, 1, !dbg !82
  br i1 %5, label %6, label %7, !dbg !80

6:                                                ; preds = %3
  store atomic i32 0, i32* @y seq_cst, align 4, !dbg !83
  store atomic i32 0, i32* @z seq_cst, align 4, !dbg !85
  br label %3, !dbg !80, !llvm.loop !86

7:                                                ; preds = %3
  ret i8* null, !dbg !88
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !89 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  %4 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !92, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !118, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %4, metadata !120, metadata !DIExpression()), !dbg !121
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef null), !dbg !122
  %6 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread2, i8* noundef null), !dbg !123
  %7 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %4, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread3, i8* noundef null), !dbg !124
  ret i32 0, !dbg !125
}

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!16, !17, !18, !19, !20, !21, !22, !23, !24, !25}
!llvm.ident = !{!26}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !9, line: 10, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_complex.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !14}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !9, line: 11, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "benchmarks/nontermination/nontermination_complex.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !11, line: 92, baseType: !12)
!11 = !DIFile(filename: "/opt/homebrew/Cellar/llvm@14/14.0.6/lib/clang/14.0.6/include/stdatomic.h", directory: "")
!12 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !13)
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !9, line: 12, type: !10, isLocal: false, isDefinition: true)
!16 = !{i32 7, !"Dwarf Version", i32 4}
!17 = !{i32 2, !"Debug Info Version", i32 3}
!18 = !{i32 1, !"wchar_size", i32 4}
!19 = !{i32 1, !"branch-target-enforcement", i32 0}
!20 = !{i32 1, !"sign-return-address", i32 0}
!21 = !{i32 1, !"sign-return-address-all", i32 0}
!22 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!23 = !{i32 7, !"PIC Level", i32 2}
!24 = !{i32 7, !"uwtable", i32 1}
!25 = !{i32 7, !"frame-pointer", i32 1}
!26 = !{!"Homebrew clang version 14.0.6"}
!27 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 14, type: !28, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !30)
!28 = !DISubroutineType(types: !29)
!29 = !{!5, !5}
!30 = !{}
!31 = !DILocalVariable(name: "unused", arg: 1, scope: !27, file: !9, line: 14, type: !5)
!32 = !DILocation(line: 14, column: 20, scope: !27)
!33 = !DILocation(line: 16, column: 5, scope: !27)
!34 = !DILocation(line: 16, column: 11, scope: !27)
!35 = !DILocation(line: 16, column: 13, scope: !27)
!36 = !DILocation(line: 17, column: 11, scope: !37)
!37 = distinct !DILexicalBlock(scope: !27, file: !9, line: 16, column: 19)
!38 = !DILocation(line: 18, column: 11, scope: !37)
!39 = !DILocation(line: 19, column: 11, scope: !37)
!40 = distinct !{!40, !33, !41, !42}
!41 = !DILocation(line: 20, column: 5, scope: !27)
!42 = !{!"llvm.loop.mustprogress"}
!43 = !DILocation(line: 21, column: 5, scope: !27)
!44 = distinct !DISubprogram(name: "thread2", scope: !9, file: !9, line: 24, type: !28, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !30)
!45 = !DILocalVariable(name: "unused", arg: 1, scope: !44, file: !9, line: 24, type: !5)
!46 = !DILocation(line: 24, column: 21, scope: !44)
!47 = !DILocation(line: 25, column: 5, scope: !44)
!48 = !DILocation(line: 25, column: 12, scope: !44)
!49 = !DILocation(line: 25, column: 14, scope: !44)
!50 = !DILocation(line: 25, column: 19, scope: !44)
!51 = !DILocation(line: 25, column: 22, scope: !44)
!52 = !DILocation(line: 25, column: 24, scope: !44)
!53 = !DILocation(line: 25, column: 29, scope: !44)
!54 = !DILocation(line: 25, column: 32, scope: !44)
!55 = !DILocation(line: 25, column: 34, scope: !44)
!56 = !DILocation(line: 0, scope: !44)
!57 = !DILocalVariable(name: "i", scope: !58, file: !9, line: 26, type: !13)
!58 = distinct !DILexicalBlock(scope: !59, file: !9, line: 26, column: 9)
!59 = distinct !DILexicalBlock(scope: !44, file: !9, line: 25, column: 40)
!60 = !DILocation(line: 26, column: 18, scope: !58)
!61 = !DILocation(line: 26, column: 14, scope: !58)
!62 = !DILocation(line: 26, column: 25, scope: !63)
!63 = distinct !DILexicalBlock(scope: !58, file: !9, line: 26, column: 9)
!64 = !DILocation(line: 26, column: 27, scope: !63)
!65 = !DILocation(line: 26, column: 9, scope: !58)
!66 = !DILocation(line: 27, column: 17, scope: !67)
!67 = distinct !DILexicalBlock(scope: !63, file: !9, line: 26, column: 37)
!68 = !DILocation(line: 27, column: 15, scope: !67)
!69 = !DILocation(line: 28, column: 9, scope: !67)
!70 = !DILocation(line: 26, column: 33, scope: !63)
!71 = !DILocation(line: 26, column: 9, scope: !63)
!72 = distinct !{!72, !65, !73, !42}
!73 = !DILocation(line: 28, column: 9, scope: !58)
!74 = distinct !{!74, !47, !75, !42}
!75 = !DILocation(line: 29, column: 5, scope: !44)
!76 = !DILocation(line: 30, column: 5, scope: !44)
!77 = distinct !DISubprogram(name: "thread3", scope: !9, file: !9, line: 33, type: !28, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !30)
!78 = !DILocalVariable(name: "unused", arg: 1, scope: !77, file: !9, line: 33, type: !5)
!79 = !DILocation(line: 33, column: 21, scope: !77)
!80 = !DILocation(line: 34, column: 5, scope: !77)
!81 = !DILocation(line: 34, column: 12, scope: !77)
!82 = !DILocation(line: 34, column: 14, scope: !77)
!83 = !DILocation(line: 35, column: 11, scope: !84)
!84 = distinct !DILexicalBlock(scope: !77, file: !9, line: 34, column: 20)
!85 = !DILocation(line: 36, column: 11, scope: !84)
!86 = distinct !{!86, !80, !87, !42}
!87 = !DILocation(line: 37, column: 5, scope: !77)
!88 = !DILocation(line: 38, column: 5, scope: !77)
!89 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 41, type: !90, scopeLine: 42, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !30)
!90 = !DISubroutineType(types: !91)
!91 = !{!13}
!92 = !DILocalVariable(name: "t1", scope: !89, file: !9, line: 43, type: !93)
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !94, line: 31, baseType: !95)
!94 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!95 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !96, line: 118, baseType: !97)
!96 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!98 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !96, line: 103, size: 65536, elements: !99)
!99 = !{!100, !102, !112}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !98, file: !96, line: 104, baseType: !101, size: 64)
!101 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !98, file: !96, line: 105, baseType: !103, size: 64, offset: 64)
!103 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!104 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !96, line: 57, size: 192, elements: !105)
!105 = !{!106, !110, !111}
!106 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !104, file: !96, line: 58, baseType: !107, size: 64)
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !108, size: 64)
!108 = !DISubroutineType(types: !109)
!109 = !{null, !5}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !104, file: !96, line: 59, baseType: !5, size: 64, offset: 64)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !104, file: !96, line: 60, baseType: !103, size: 64, offset: 128)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !98, file: !96, line: 106, baseType: !113, size: 65408, offset: 128)
!113 = !DICompositeType(tag: DW_TAG_array_type, baseType: !114, size: 65408, elements: !115)
!114 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!115 = !{!116}
!116 = !DISubrange(count: 8176)
!117 = !DILocation(line: 43, column: 15, scope: !89)
!118 = !DILocalVariable(name: "t2", scope: !89, file: !9, line: 43, type: !93)
!119 = !DILocation(line: 43, column: 19, scope: !89)
!120 = !DILocalVariable(name: "t3", scope: !89, file: !9, line: 43, type: !93)
!121 = !DILocation(line: 43, column: 23, scope: !89)
!122 = !DILocation(line: 44, column: 5, scope: !89)
!123 = !DILocation(line: 45, column: 5, scope: !89)
!124 = !DILocation(line: 46, column: 5, scope: !89)
!125 = !DILocation(line: 48, column: 5, scope: !89)
