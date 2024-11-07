; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_complex.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_complex.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

%struct._opaque_pthread_t = type { i64, %struct.__darwin_pthread_handler_rec*, [8176 x i8] }
%struct.__darwin_pthread_handler_rec = type { void (i8*)*, i8*, %struct.__darwin_pthread_handler_rec* }
%struct._opaque_pthread_attr_t = type { i64, [56 x i8] }

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !7
@z = global i32 0, align 4, !dbg !12

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread(i8* noundef %0) #0 !dbg !25 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !29, metadata !DIExpression()), !dbg !30
  br label %4, !dbg !31

4:                                                ; preds = %7, %1
  %5 = load volatile i32, i32* @y, align 4, !dbg !32
  %6 = icmp ne i32 %5, 1, !dbg !33
  br i1 %6, label %7, label %8, !dbg !31

7:                                                ; preds = %4
  store volatile i32 1, i32* @x, align 4, !dbg !34
  store volatile i32 0, i32* @x, align 4, !dbg !36
  store volatile i32 1, i32* @y, align 4, !dbg !37
  br label %4, !dbg !31, !llvm.loop !38

8:                                                ; preds = %4
  %9 = load i8*, i8** %2, align 8, !dbg !41
  ret i8* %9, !dbg !41
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread2(i8* noundef %0) #0 !dbg !42 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !43, metadata !DIExpression()), !dbg !44
  br label %5, !dbg !45

5:                                                ; preds = %25, %1
  %6 = load volatile i32, i32* @x, align 4, !dbg !46
  %7 = icmp eq i32 %6, 1, !dbg !47
  br i1 %7, label %8, label %14, !dbg !48

8:                                                ; preds = %5
  %9 = load volatile i32, i32* @y, align 4, !dbg !49
  %10 = icmp ne i32 %9, 0, !dbg !50
  br i1 %10, label %11, label %14, !dbg !51

11:                                               ; preds = %8
  %12 = load volatile i32, i32* @z, align 4, !dbg !52
  %13 = icmp ne i32 %12, 3, !dbg !53
  br label %14

14:                                               ; preds = %11, %8, %5
  %15 = phi i1 [ false, %8 ], [ false, %5 ], [ %13, %11 ], !dbg !54
  br i1 %15, label %16, label %26, !dbg !45

16:                                               ; preds = %14
  call void @llvm.dbg.declare(metadata i32* %4, metadata !55, metadata !DIExpression()), !dbg !58
  store i32 0, i32* %4, align 4, !dbg !58
  br label %17, !dbg !59

17:                                               ; preds = %22, %16
  %18 = load i32, i32* %4, align 4, !dbg !60
  %19 = icmp slt i32 %18, 4, !dbg !62
  br i1 %19, label %20, label %25, !dbg !63

20:                                               ; preds = %17
  %21 = load i32, i32* %4, align 4, !dbg !64
  store volatile i32 %21, i32* @z, align 4, !dbg !66
  br label %22, !dbg !67

22:                                               ; preds = %20
  %23 = load i32, i32* %4, align 4, !dbg !68
  %24 = add nsw i32 %23, 1, !dbg !68
  store i32 %24, i32* %4, align 4, !dbg !68
  br label %17, !dbg !69, !llvm.loop !70

25:                                               ; preds = %17
  br label %5, !dbg !45, !llvm.loop !72

26:                                               ; preds = %14
  %27 = load i8*, i8** %2, align 8, !dbg !74
  ret i8* %27, !dbg !74
}

; Function Attrs: noinline nounwind ssp uwtable
define i8* @thread3(i8* noundef %0) #0 !dbg !75 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !76, metadata !DIExpression()), !dbg !77
  br label %4, !dbg !78

4:                                                ; preds = %7, %1
  %5 = load volatile i32, i32* @z, align 4, !dbg !79
  %6 = icmp eq i32 %5, 1, !dbg !80
  br i1 %6, label %7, label %8, !dbg !78

7:                                                ; preds = %4
  store volatile i32 0, i32* @y, align 4, !dbg !81
  store volatile i32 0, i32* @z, align 4, !dbg !83
  br label %4, !dbg !78, !llvm.loop !84

8:                                                ; preds = %4
  %9 = load i8*, i8** %2, align 8, !dbg !86
  ret i8* %9, !dbg !86
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !87 {
  %1 = alloca i32, align 4
  %2 = alloca %struct._opaque_pthread_t*, align 8
  %3 = alloca %struct._opaque_pthread_t*, align 8
  %4 = alloca %struct._opaque_pthread_t*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %2, metadata !90, metadata !DIExpression()), !dbg !115
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %3, metadata !116, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.declare(metadata %struct._opaque_pthread_t** %4, metadata !118, metadata !DIExpression()), !dbg !119
  %5 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %2, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread, i8* noundef null), !dbg !120
  %6 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %3, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread2, i8* noundef null), !dbg !121
  %7 = call i32 @pthread_create(%struct._opaque_pthread_t** noundef %4, %struct._opaque_pthread_attr_t* noundef null, i8* (i8*)* noundef @thread3, i8* noundef null), !dbg !122
  ret i32 0, !dbg !123
}

declare i32 @pthread_create(%struct._opaque_pthread_t** noundef, %struct._opaque_pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!14, !15, !16, !17, !18, !19, !20, !21, !22, !23}
!llvm.ident = !{!24}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !9, line: 9, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_complex.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !12}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !9, line: 10, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "benchmarks/nontermination/nontermination_complex.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!10 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !11)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !9, line: 11, type: !10, isLocal: false, isDefinition: true)
!14 = !{i32 7, !"Dwarf Version", i32 4}
!15 = !{i32 2, !"Debug Info Version", i32 3}
!16 = !{i32 1, !"wchar_size", i32 4}
!17 = !{i32 1, !"branch-target-enforcement", i32 0}
!18 = !{i32 1, !"sign-return-address", i32 0}
!19 = !{i32 1, !"sign-return-address-all", i32 0}
!20 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!21 = !{i32 7, !"PIC Level", i32 2}
!22 = !{i32 7, !"uwtable", i32 1}
!23 = !{i32 7, !"frame-pointer", i32 1}
!24 = !{!"Homebrew clang version 14.0.6"}
!25 = distinct !DISubprogram(name: "thread", scope: !9, file: !9, line: 13, type: !26, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!26 = !DISubroutineType(types: !27)
!27 = !{!5, !5}
!28 = !{}
!29 = !DILocalVariable(name: "unused", arg: 1, scope: !25, file: !9, line: 13, type: !5)
!30 = !DILocation(line: 13, column: 20, scope: !25)
!31 = !DILocation(line: 15, column: 5, scope: !25)
!32 = !DILocation(line: 15, column: 11, scope: !25)
!33 = !DILocation(line: 15, column: 13, scope: !25)
!34 = !DILocation(line: 16, column: 11, scope: !35)
!35 = distinct !DILexicalBlock(scope: !25, file: !9, line: 15, column: 19)
!36 = !DILocation(line: 17, column: 11, scope: !35)
!37 = !DILocation(line: 18, column: 11, scope: !35)
!38 = distinct !{!38, !31, !39, !40}
!39 = !DILocation(line: 19, column: 5, scope: !25)
!40 = !{!"llvm.loop.mustprogress"}
!41 = !DILocation(line: 20, column: 1, scope: !25)
!42 = distinct !DISubprogram(name: "thread2", scope: !9, file: !9, line: 22, type: !26, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!43 = !DILocalVariable(name: "unused", arg: 1, scope: !42, file: !9, line: 22, type: !5)
!44 = !DILocation(line: 22, column: 21, scope: !42)
!45 = !DILocation(line: 23, column: 5, scope: !42)
!46 = !DILocation(line: 23, column: 12, scope: !42)
!47 = !DILocation(line: 23, column: 14, scope: !42)
!48 = !DILocation(line: 23, column: 19, scope: !42)
!49 = !DILocation(line: 23, column: 22, scope: !42)
!50 = !DILocation(line: 23, column: 24, scope: !42)
!51 = !DILocation(line: 23, column: 29, scope: !42)
!52 = !DILocation(line: 23, column: 32, scope: !42)
!53 = !DILocation(line: 23, column: 34, scope: !42)
!54 = !DILocation(line: 0, scope: !42)
!55 = !DILocalVariable(name: "i", scope: !56, file: !9, line: 24, type: !11)
!56 = distinct !DILexicalBlock(scope: !57, file: !9, line: 24, column: 9)
!57 = distinct !DILexicalBlock(scope: !42, file: !9, line: 23, column: 40)
!58 = !DILocation(line: 24, column: 18, scope: !56)
!59 = !DILocation(line: 24, column: 14, scope: !56)
!60 = !DILocation(line: 24, column: 25, scope: !61)
!61 = distinct !DILexicalBlock(scope: !56, file: !9, line: 24, column: 9)
!62 = !DILocation(line: 24, column: 27, scope: !61)
!63 = !DILocation(line: 24, column: 9, scope: !56)
!64 = !DILocation(line: 25, column: 17, scope: !65)
!65 = distinct !DILexicalBlock(scope: !61, file: !9, line: 24, column: 37)
!66 = !DILocation(line: 25, column: 15, scope: !65)
!67 = !DILocation(line: 26, column: 9, scope: !65)
!68 = !DILocation(line: 24, column: 33, scope: !61)
!69 = !DILocation(line: 24, column: 9, scope: !61)
!70 = distinct !{!70, !63, !71, !40}
!71 = !DILocation(line: 26, column: 9, scope: !56)
!72 = distinct !{!72, !45, !73, !40}
!73 = !DILocation(line: 27, column: 5, scope: !42)
!74 = !DILocation(line: 28, column: 1, scope: !42)
!75 = distinct !DISubprogram(name: "thread3", scope: !9, file: !9, line: 30, type: !26, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!76 = !DILocalVariable(name: "unused", arg: 1, scope: !75, file: !9, line: 30, type: !5)
!77 = !DILocation(line: 30, column: 21, scope: !75)
!78 = !DILocation(line: 31, column: 5, scope: !75)
!79 = !DILocation(line: 31, column: 12, scope: !75)
!80 = !DILocation(line: 31, column: 14, scope: !75)
!81 = !DILocation(line: 32, column: 11, scope: !82)
!82 = distinct !DILexicalBlock(scope: !75, file: !9, line: 31, column: 20)
!83 = !DILocation(line: 33, column: 11, scope: !82)
!84 = distinct !{!84, !78, !85, !40}
!85 = !DILocation(line: 34, column: 5, scope: !75)
!86 = !DILocation(line: 36, column: 1, scope: !75)
!87 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 38, type: !88, scopeLine: 39, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !28)
!88 = !DISubroutineType(types: !89)
!89 = !{!11}
!90 = !DILocalVariable(name: "t1", scope: !87, file: !9, line: 40, type: !91)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !92, line: 31, baseType: !93)
!92 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "")
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !94, line: 118, baseType: !95)
!94 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "")
!95 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !96, size: 64)
!96 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !94, line: 103, size: 65536, elements: !97)
!97 = !{!98, !100, !110}
!98 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !96, file: !94, line: 104, baseType: !99, size: 64)
!99 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !96, file: !94, line: 105, baseType: !101, size: 64, offset: 64)
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !102, size: 64)
!102 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !94, line: 57, size: 192, elements: !103)
!103 = !{!104, !108, !109}
!104 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !102, file: !94, line: 58, baseType: !105, size: 64)
!105 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !106, size: 64)
!106 = !DISubroutineType(types: !107)
!107 = !{null, !5}
!108 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !102, file: !94, line: 59, baseType: !5, size: 64, offset: 64)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !102, file: !94, line: 60, baseType: !101, size: 64, offset: 128)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !96, file: !94, line: 106, baseType: !111, size: 65408, offset: 128)
!111 = !DICompositeType(tag: DW_TAG_array_type, baseType: !112, size: 65408, elements: !113)
!112 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!113 = !{!114}
!114 = !DISubrange(count: 8176)
!115 = !DILocation(line: 40, column: 15, scope: !87)
!116 = !DILocalVariable(name: "t2", scope: !87, file: !9, line: 40, type: !91)
!117 = !DILocation(line: 40, column: 19, scope: !87)
!118 = !DILocalVariable(name: "t3", scope: !87, file: !9, line: 40, type: !91)
!119 = !DILocation(line: 40, column: 23, scope: !87)
!120 = !DILocation(line: 41, column: 5, scope: !87)
!121 = !DILocation(line: 42, column: 5, scope: !87)
!122 = !DILocation(line: 43, column: 5, scope: !87)
!123 = !DILocation(line: 45, column: 5, scope: !87)
