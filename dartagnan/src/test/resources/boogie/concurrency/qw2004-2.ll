; ModuleID = '/home/ponce/git/Dat3M/output/qw2004-2.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-lit/qw2004-2.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"assert.h\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@stoppingFlag = dso_local global i32 0, align 4, !dbg !0
@pendingIo = dso_local global i32 0, align 4, !dbg !5
@stoppingEvent = dso_local global i32 0, align 4, !dbg !10
@stopped = dso_local global i32 0, align 4, !dbg !12

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !22 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0), i32 noundef 6, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !26
  unreachable, !dbg !26
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @assume_abort_if_not(i32 noundef %0) #0 !dbg !29 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !32, metadata !DIExpression()), !dbg !33
  %.not = icmp eq i32 %0, 0, !dbg !34
  br i1 %.not, label %2, label %3, !dbg !36

2:                                                ; preds = %1
  call void @abort() #7, !dbg !37
  unreachable, !dbg !37

3:                                                ; preds = %1
  ret void, !dbg !39
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: noreturn
declare void @abort() #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_assert(i32 noundef %0) #0 !dbg !40 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !41, metadata !DIExpression()), !dbg !42
  %.not = icmp eq i32 %0, 0, !dbg !43
  br i1 %.not, label %2, label %3, !dbg !45

2:                                                ; preds = %1
  call void @llvm.dbg.label(metadata !46), !dbg !48
  call void @reach_error(), !dbg !49
  call void @abort() #7, !dbg !51
  unreachable, !dbg !51

3:                                                ; preds = %1
  ret void, !dbg !52
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @BCSP_IoIncrement() #0 !dbg !53 {
  call void (...) @__VERIFIER_atomic_begin() #8, !dbg !56
  %1 = load volatile i32, i32* @stoppingFlag, align 4, !dbg !57
  call void @llvm.dbg.value(metadata i32 %1, metadata !58, metadata !DIExpression()), !dbg !59
  call void (...) @__VERIFIER_atomic_end() #8, !dbg !60
  %.not = icmp eq i32 %1, 0, !dbg !61
  br i1 %.not, label %2, label %5, !dbg !63

2:                                                ; preds = %0
  call void (...) @__VERIFIER_atomic_begin() #8, !dbg !64
  %3 = load volatile i32, i32* @pendingIo, align 4, !dbg !66
  call void @llvm.dbg.value(metadata i32 %3, metadata !67, metadata !DIExpression()), !dbg !68
  call void (...) @__VERIFIER_atomic_end() #8, !dbg !69
  call void (...) @__VERIFIER_atomic_begin() #8, !dbg !70
  %4 = add nsw i32 %3, 1, !dbg !71
  store volatile i32 %4, i32* @pendingIo, align 4, !dbg !72
  call void (...) @__VERIFIER_atomic_end() #8, !dbg !73
  br label %5, !dbg !74

5:                                                ; preds = %0, %2
  %.0 = phi i32 [ 0, %2 ], [ -1, %0 ], !dbg !59
  ret i32 %.0, !dbg !75
}

declare void @__VERIFIER_atomic_begin(...) #4

declare void @__VERIFIER_atomic_end(...) #4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @dec() #0 !dbg !76 {
  call void (...) @__VERIFIER_atomic_begin() #8, !dbg !77
  %1 = load volatile i32, i32* @pendingIo, align 4, !dbg !78
  %2 = add nsw i32 %1, -1, !dbg !78
  store volatile i32 %2, i32* @pendingIo, align 4, !dbg !78
  %3 = load volatile i32, i32* @pendingIo, align 4, !dbg !79
  call void @llvm.dbg.value(metadata i32 %3, metadata !80, metadata !DIExpression()), !dbg !81
  call void (...) @__VERIFIER_atomic_end() #8, !dbg !82
  ret i32 %3, !dbg !83
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @BCSP_IoDecrement() #0 !dbg !84 {
  %1 = call i32 @dec(), !dbg !85
  call void @llvm.dbg.value(metadata i32 %1, metadata !86, metadata !DIExpression()), !dbg !87
  %2 = icmp eq i32 %1, 0, !dbg !88
  br i1 %2, label %3, label %4, !dbg !90

3:                                                ; preds = %0
  call void (...) @__VERIFIER_atomic_begin() #8, !dbg !91
  store volatile i32 1, i32* @stoppingEvent, align 4, !dbg !93
  call void (...) @__VERIFIER_atomic_end() #8, !dbg !94
  br label %4, !dbg !95

4:                                                ; preds = %3, %0
  ret void, !dbg !96
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @BCSP_PnpAdd(i8* noundef %0) #0 !dbg !97 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !101, metadata !DIExpression()), !dbg !102
  %2 = call i32 @BCSP_IoIncrement(), !dbg !103
  call void @llvm.dbg.value(metadata i32 %2, metadata !104, metadata !DIExpression()), !dbg !102
  %3 = icmp eq i32 %2, 0, !dbg !105
  br i1 %3, label %4, label %7, !dbg !107

4:                                                ; preds = %1
  %5 = load volatile i32, i32* @stopped, align 4, !dbg !108
  %.not = icmp eq i32 %5, 0, !dbg !110
  %6 = zext i1 %.not to i32, !dbg !110
  call void @__VERIFIER_assert(i32 noundef %6), !dbg !111
  br label %7, !dbg !112

7:                                                ; preds = %4, %1
  call void @BCSP_IoDecrement(), !dbg !113
  ret i8* null, !dbg !114
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @BCSP_PnpStop(i8* noundef %0) #0 !dbg !115 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !116, metadata !DIExpression()), !dbg !117
  call void (...) @__VERIFIER_atomic_begin() #8, !dbg !118
  store volatile i32 1, i32* @stoppingFlag, align 4, !dbg !119
  call void (...) @__VERIFIER_atomic_end() #8, !dbg !120
  call void @BCSP_IoDecrement(), !dbg !121
  call void (...) @__VERIFIER_atomic_begin() #8, !dbg !122
  %2 = load volatile i32, i32* @stoppingEvent, align 4, !dbg !123
  call void @llvm.dbg.value(metadata i32 %2, metadata !124, metadata !DIExpression()), !dbg !117
  call void (...) @__VERIFIER_atomic_end() #8, !dbg !125
  call void @assume_abort_if_not(i32 noundef %2), !dbg !126
  store volatile i32 1, i32* @stopped, align 4, !dbg !127
  ret i8* null, !dbg !128
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !129 {
  %1 = alloca i64, align 8
  store volatile i32 1, i32* @pendingIo, align 4, !dbg !130
  store volatile i32 0, i32* @stoppingFlag, align 4, !dbg !131
  store volatile i32 0, i32* @stoppingEvent, align 4, !dbg !132
  store volatile i32 0, i32* @stopped, align 4, !dbg !133
  call void @llvm.dbg.value(metadata i64* %1, metadata !134, metadata !DIExpression(DW_OP_deref)), !dbg !137
  %2 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @BCSP_PnpStop, i8* noundef null) #8, !dbg !138
  %3 = call i8* @BCSP_PnpAdd(i8* noundef null), !dbg !139
  ret i32 0, !dbg !140
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback noreturn nounwind }
attributes #7 = { noreturn nounwind }
attributes #8 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!14, !15, !16, !17, !18, !19, !20}
!llvm.ident = !{!21}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "stoppingFlag", scope: !2, file: !7, line: 697, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-lit/qw2004-2.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "0a7d965f0459b1582797c8474c185bb0")
!4 = !{!0, !5, !10, !12}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "pendingIo", scope: !2, file: !7, line: 698, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/pthread-lit/qw2004-2.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "0a7d965f0459b1582797c8474c185bb0")
!8 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !9)
!9 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "stoppingEvent", scope: !2, file: !7, line: 699, type: !8, isLocal: false, isDefinition: true)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "stopped", scope: !2, file: !7, line: 700, type: !8, isLocal: false, isDefinition: true)
!14 = !{i32 7, !"Dwarf Version", i32 5}
!15 = !{i32 2, !"Debug Info Version", i32 3}
!16 = !{i32 1, !"wchar_size", i32 4}
!17 = !{i32 7, !"PIC Level", i32 2}
!18 = !{i32 7, !"PIE Level", i32 2}
!19 = !{i32 7, !"uwtable", i32 1}
!20 = !{i32 7, !"frame-pointer", i32 2}
!21 = !{!"Ubuntu clang version 14.0.6"}
!22 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 683, type: !23, scopeLine: 683, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!23 = !DISubroutineType(types: !24)
!24 = !{null}
!25 = !{}
!26 = !DILocation(line: 683, column: 83, scope: !27)
!27 = distinct !DILexicalBlock(scope: !28, file: !7, line: 683, column: 73)
!28 = distinct !DILexicalBlock(scope: !22, file: !7, line: 683, column: 67)
!29 = distinct !DISubprogram(name: "assume_abort_if_not", scope: !7, file: !7, line: 685, type: !30, scopeLine: 685, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!30 = !DISubroutineType(types: !31)
!31 = !{null, !9}
!32 = !DILocalVariable(name: "cond", arg: 1, scope: !29, file: !7, line: 685, type: !9)
!33 = !DILocation(line: 0, scope: !29)
!34 = !DILocation(line: 686, column: 7, scope: !35)
!35 = distinct !DILexicalBlock(scope: !29, file: !7, line: 686, column: 6)
!36 = !DILocation(line: 686, column: 6, scope: !29)
!37 = !DILocation(line: 686, column: 14, scope: !38)
!38 = distinct !DILexicalBlock(scope: !35, file: !7, line: 686, column: 13)
!39 = !DILocation(line: 687, column: 1, scope: !29)
!40 = distinct !DISubprogram(name: "__VERIFIER_assert", scope: !7, file: !7, line: 688, type: !30, scopeLine: 688, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!41 = !DILocalVariable(name: "cond", arg: 1, scope: !40, file: !7, line: 688, type: !9)
!42 = !DILocation(line: 0, scope: !40)
!43 = !DILocation(line: 689, column: 8, scope: !44)
!44 = distinct !DILexicalBlock(scope: !40, file: !7, line: 689, column: 7)
!45 = !DILocation(line: 689, column: 7, scope: !40)
!46 = !DILabel(scope: !47, name: "ERROR", file: !7, line: 690)
!47 = distinct !DILexicalBlock(scope: !44, file: !7, line: 689, column: 16)
!48 = !DILocation(line: 690, column: 5, scope: !47)
!49 = !DILocation(line: 690, column: 13, scope: !50)
!50 = distinct !DILexicalBlock(scope: !47, file: !7, line: 690, column: 12)
!51 = !DILocation(line: 690, column: 27, scope: !50)
!52 = !DILocation(line: 692, column: 3, scope: !40)
!53 = distinct !DISubprogram(name: "BCSP_IoIncrement", scope: !7, file: !7, line: 701, type: !54, scopeLine: 701, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!54 = !DISubroutineType(types: !55)
!55 = !{!9}
!56 = !DILocation(line: 702, column: 5, scope: !53)
!57 = !DILocation(line: 703, column: 15, scope: !53)
!58 = !DILocalVariable(name: "lsf", scope: !53, file: !7, line: 703, type: !9)
!59 = !DILocation(line: 0, scope: !53)
!60 = !DILocation(line: 704, column: 5, scope: !53)
!61 = !DILocation(line: 705, column: 9, scope: !62)
!62 = distinct !DILexicalBlock(scope: !53, file: !7, line: 705, column: 9)
!63 = !DILocation(line: 705, column: 9, scope: !53)
!64 = !DILocation(line: 708, column: 9, scope: !65)
!65 = distinct !DILexicalBlock(scope: !62, file: !7, line: 707, column: 12)
!66 = !DILocation(line: 709, column: 18, scope: !65)
!67 = !DILocalVariable(name: "lp", scope: !65, file: !7, line: 709, type: !9)
!68 = !DILocation(line: 0, scope: !65)
!69 = !DILocation(line: 710, column: 9, scope: !65)
!70 = !DILocation(line: 711, column: 9, scope: !65)
!71 = !DILocation(line: 712, column: 24, scope: !65)
!72 = !DILocation(line: 712, column: 19, scope: !65)
!73 = !DILocation(line: 713, column: 9, scope: !65)
!74 = !DILocation(line: 715, column: 5, scope: !53)
!75 = !DILocation(line: 716, column: 1, scope: !53)
!76 = distinct !DISubprogram(name: "dec", scope: !7, file: !7, line: 717, type: !54, scopeLine: 717, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!77 = !DILocation(line: 718, column: 5, scope: !76)
!78 = !DILocation(line: 719, column: 14, scope: !76)
!79 = !DILocation(line: 720, column: 15, scope: !76)
!80 = !DILocalVariable(name: "tmp", scope: !76, file: !7, line: 720, type: !9)
!81 = !DILocation(line: 0, scope: !76)
!82 = !DILocation(line: 721, column: 5, scope: !76)
!83 = !DILocation(line: 722, column: 5, scope: !76)
!84 = distinct !DISubprogram(name: "BCSP_IoDecrement", scope: !7, file: !7, line: 724, type: !23, scopeLine: 724, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!85 = !DILocation(line: 726, column: 15, scope: !84)
!86 = !DILocalVariable(name: "pending", scope: !84, file: !7, line: 725, type: !9)
!87 = !DILocation(line: 0, scope: !84)
!88 = !DILocation(line: 727, column: 17, scope: !89)
!89 = distinct !DILexicalBlock(scope: !84, file: !7, line: 727, column: 9)
!90 = !DILocation(line: 727, column: 9, scope: !84)
!91 = !DILocation(line: 728, column: 9, scope: !92)
!92 = distinct !DILexicalBlock(scope: !89, file: !7, line: 727, column: 23)
!93 = !DILocation(line: 729, column: 23, scope: !92)
!94 = !DILocation(line: 730, column: 9, scope: !92)
!95 = !DILocation(line: 731, column: 5, scope: !92)
!96 = !DILocation(line: 732, column: 1, scope: !84)
!97 = distinct !DISubprogram(name: "BCSP_PnpAdd", scope: !7, file: !7, line: 733, type: !98, scopeLine: 733, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!98 = !DISubroutineType(types: !99)
!99 = !{!100, !100}
!100 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!101 = !DILocalVariable(name: "arg", arg: 1, scope: !97, file: !7, line: 733, type: !100)
!102 = !DILocation(line: 0, scope: !97)
!103 = !DILocation(line: 735, column: 14, scope: !97)
!104 = !DILocalVariable(name: "status", scope: !97, file: !7, line: 734, type: !9)
!105 = !DILocation(line: 736, column: 16, scope: !106)
!106 = distinct !DILexicalBlock(scope: !97, file: !7, line: 736, column: 9)
!107 = !DILocation(line: 736, column: 9, scope: !97)
!108 = !DILocation(line: 737, column: 21, scope: !109)
!109 = distinct !DILexicalBlock(scope: !106, file: !7, line: 736, column: 22)
!110 = !DILocation(line: 737, column: 20, scope: !109)
!111 = !DILocation(line: 737, column: 2, scope: !109)
!112 = !DILocation(line: 738, column: 5, scope: !109)
!113 = !DILocation(line: 739, column: 5, scope: !97)
!114 = !DILocation(line: 740, column: 5, scope: !97)
!115 = distinct !DISubprogram(name: "BCSP_PnpStop", scope: !7, file: !7, line: 742, type: !98, scopeLine: 742, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!116 = !DILocalVariable(name: "arg", arg: 1, scope: !115, file: !7, line: 742, type: !100)
!117 = !DILocation(line: 0, scope: !115)
!118 = !DILocation(line: 743, column: 5, scope: !115)
!119 = !DILocation(line: 744, column: 18, scope: !115)
!120 = !DILocation(line: 745, column: 5, scope: !115)
!121 = !DILocation(line: 746, column: 5, scope: !115)
!122 = !DILocation(line: 747, column: 5, scope: !115)
!123 = !DILocation(line: 748, column: 15, scope: !115)
!124 = !DILocalVariable(name: "lse", scope: !115, file: !7, line: 748, type: !9)
!125 = !DILocation(line: 749, column: 5, scope: !115)
!126 = !DILocation(line: 750, column: 5, scope: !115)
!127 = !DILocation(line: 751, column: 13, scope: !115)
!128 = !DILocation(line: 752, column: 5, scope: !115)
!129 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 754, type: !54, scopeLine: 754, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!130 = !DILocation(line: 756, column: 15, scope: !129)
!131 = !DILocation(line: 757, column: 18, scope: !129)
!132 = !DILocation(line: 758, column: 19, scope: !129)
!133 = !DILocation(line: 759, column: 13, scope: !129)
!134 = !DILocalVariable(name: "t", scope: !129, file: !7, line: 755, type: !135)
!135 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 268, baseType: !136)
!136 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!137 = !DILocation(line: 0, scope: !129)
!138 = !DILocation(line: 760, column: 5, scope: !129)
!139 = !DILocation(line: 761, column: 5, scope: !129)
!140 = !DILocation(line: 762, column: 5, scope: !129)
