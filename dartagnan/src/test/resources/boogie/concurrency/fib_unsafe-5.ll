; ModuleID = '/home/ponce/git/Dat3M/output/fib_unsafe-5.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread/fib_unsafe-5.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"fib_unsafe.h\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@p = dso_local global i32 0, align 4, !dbg !0
@i = dso_local global i32 0, align 4, !dbg !15
@j = dso_local global i32 0, align 4, !dbg !17
@q = dso_local global i32 0, align 4, !dbg !19
@cur = dso_local global i32 1, align 4, !dbg !7
@prev = dso_local global i32 0, align 4, !dbg !11
@next = dso_local global i32 0, align 4, !dbg !13
@x = dso_local global i32 0, align 4, !dbg !21

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !31 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.1, i64 0, i64 0), i32 noundef 14, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !35
  unreachable, !dbg !35
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_assert(i32 noundef %0) #0 !dbg !38 {
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
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: noreturn
declare void @abort() #3

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @t1(i8* noundef %0) #0 !dbg !53 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !56, metadata !DIExpression()), !dbg !57
  br label %2, !dbg !58

2:                                                ; preds = %4, %1
  %storemerge = phi i32 [ 0, %1 ], [ %9, %4 ], !dbg !60
  store i32 %storemerge, i32* @p, align 4, !dbg !60
  %3 = icmp slt i32 %storemerge, 5, !dbg !61
  br i1 %3, label %4, label %10, !dbg !63

4:                                                ; preds = %2
  call void @__VERIFIER_atomic_begin() #8, !dbg !64
  %5 = load i32, i32* @i, align 4, !dbg !66
  %6 = load i32, i32* @j, align 4, !dbg !67
  %7 = add nsw i32 %5, %6, !dbg !68
  store i32 %7, i32* @i, align 4, !dbg !69
  call void @__VERIFIER_atomic_end() #8, !dbg !70
  %8 = load i32, i32* @p, align 4, !dbg !71
  %9 = add nsw i32 %8, 1, !dbg !71
  br label %2, !dbg !72, !llvm.loop !73

10:                                               ; preds = %2
  ret i8* null, !dbg !76
}

declare void @__VERIFIER_atomic_begin() #4

declare void @__VERIFIER_atomic_end() #4

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @t2(i8* noundef %0) #0 !dbg !77 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !78, metadata !DIExpression()), !dbg !79
  br label %2, !dbg !80

2:                                                ; preds = %4, %1
  %storemerge = phi i32 [ 0, %1 ], [ %9, %4 ], !dbg !82
  store i32 %storemerge, i32* @q, align 4, !dbg !82
  %3 = icmp slt i32 %storemerge, 5, !dbg !83
  br i1 %3, label %4, label %10, !dbg !85

4:                                                ; preds = %2
  call void @__VERIFIER_atomic_begin() #8, !dbg !86
  %5 = load i32, i32* @j, align 4, !dbg !88
  %6 = load i32, i32* @i, align 4, !dbg !89
  %7 = add nsw i32 %5, %6, !dbg !90
  store i32 %7, i32* @j, align 4, !dbg !91
  call void @__VERIFIER_atomic_end() #8, !dbg !92
  %8 = load i32, i32* @q, align 4, !dbg !93
  %9 = add nsw i32 %8, 1, !dbg !93
  br label %2, !dbg !94, !llvm.loop !95

10:                                               ; preds = %2
  ret i8* null, !dbg !97
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @fib() #0 !dbg !98 {
  br label %1, !dbg !101

1:                                                ; preds = %3, %0
  %storemerge = phi i32 [ 0, %0 ], [ %7, %3 ], !dbg !103
  store i32 %storemerge, i32* @x, align 4, !dbg !103
  %2 = icmp ult i32 %storemerge, 12, !dbg !104
  br i1 %2, label %3, label %8, !dbg !106

3:                                                ; preds = %1
  %4 = load i32, i32* @prev, align 4, !dbg !107
  %5 = load i32, i32* @cur, align 4, !dbg !109
  %6 = add nsw i32 %4, %5, !dbg !110
  store i32 %6, i32* @next, align 4, !dbg !111
  store i32 %5, i32* @prev, align 4, !dbg !112
  store i32 %6, i32* @cur, align 4, !dbg !113
  %7 = add nuw nsw i32 %storemerge, 1, !dbg !114
  br label %1, !dbg !115, !llvm.loop !116

8:                                                ; preds = %1
  %9 = load i32, i32* @prev, align 4, !dbg !118
  ret i32 %9, !dbg !119
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main(i32 noundef %0, i8** noundef %1) #0 !dbg !120 {
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i32 %0, metadata !126, metadata !DIExpression()), !dbg !127
  call void @llvm.dbg.value(metadata i8** %1, metadata !128, metadata !DIExpression()), !dbg !127
  call void @__VERIFIER_atomic_begin() #8, !dbg !129
  store i32 1, i32* @i, align 4, !dbg !130
  call void @__VERIFIER_atomic_end() #8, !dbg !131
  call void @__VERIFIER_atomic_begin() #8, !dbg !132
  store i32 1, i32* @j, align 4, !dbg !133
  call void @__VERIFIER_atomic_end() #8, !dbg !134
  call void @llvm.dbg.value(metadata i64* %3, metadata !135, metadata !DIExpression(DW_OP_deref)), !dbg !127
  %5 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @t1, i8* noundef null) #8, !dbg !138
  call void @llvm.dbg.value(metadata i64* %4, metadata !139, metadata !DIExpression(DW_OP_deref)), !dbg !127
  %6 = call i32 @pthread_create(i64* noundef nonnull %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @t2, i8* noundef null) #8, !dbg !140
  %7 = call i32 @fib(), !dbg !141
  call void @llvm.dbg.value(metadata i32 %7, metadata !142, metadata !DIExpression()), !dbg !127
  call void @__VERIFIER_atomic_begin() #8, !dbg !143
  %8 = load i32, i32* @i, align 4, !dbg !144
  %9 = icmp slt i32 %8, %7, !dbg !145
  %10 = load i32, i32* @j, align 4, !dbg !146
  %11 = icmp slt i32 %10, %7, !dbg !146
  %12 = select i1 %9, i1 %11, i1 false, !dbg !146
  call void @llvm.dbg.value(metadata i1 %12, metadata !147, metadata !DIExpression(DW_OP_LLVM_convert, 1, DW_ATE_unsigned, DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !127
  call void @__VERIFIER_atomic_end() #8, !dbg !149
  %13 = zext i1 %12 to i32, !dbg !150
  call void @__VERIFIER_assert(i32 noundef %13), !dbg !151
  ret i32 0, !dbg !152
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
!llvm.module.flags = !{!23, !24, !25, !26, !27, !28, !29}
!llvm.ident = !{!30}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "p", scope: !2, file: !9, line: 685, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread/fib_unsafe-5.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "33de7436863b19ca9d8a24d14d49daa9")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !11, !13, !15, !17, !0, !19, !21}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "cur", scope: !2, file: !9, line: 702, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "../sv-benchmarks/c/pthread/fib_unsafe-5.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "33de7436863b19ca9d8a24d14d49daa9")
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "prev", scope: !2, file: !9, line: 702, type: !10, isLocal: false, isDefinition: true)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(name: "next", scope: !2, file: !9, line: 702, type: !10, isLocal: false, isDefinition: true)
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "i", scope: !2, file: !9, line: 682, type: !10, isLocal: false, isDefinition: true)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(name: "j", scope: !2, file: !9, line: 682, type: !10, isLocal: false, isDefinition: true)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(name: "q", scope: !2, file: !9, line: 685, type: !10, isLocal: false, isDefinition: true)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !9, line: 703, type: !10, isLocal: false, isDefinition: true)
!23 = !{i32 7, !"Dwarf Version", i32 5}
!24 = !{i32 2, !"Debug Info Version", i32 3}
!25 = !{i32 1, !"wchar_size", i32 4}
!26 = !{i32 7, !"PIC Level", i32 2}
!27 = !{i32 7, !"PIE Level", i32 2}
!28 = !{i32 7, !"uwtable", i32 1}
!29 = !{i32 7, !"frame-pointer", i32 2}
!30 = !{!"Ubuntu clang version 14.0.6"}
!31 = distinct !DISubprogram(name: "reach_error", scope: !9, file: !9, line: 680, type: !32, scopeLine: 680, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!32 = !DISubroutineType(types: !33)
!33 = !{null}
!34 = !{}
!35 = !DILocation(line: 680, column: 83, scope: !36)
!36 = distinct !DILexicalBlock(scope: !37, file: !9, line: 680, column: 73)
!37 = distinct !DILexicalBlock(scope: !31, file: !9, line: 680, column: 67)
!38 = distinct !DISubprogram(name: "__VERIFIER_assert", scope: !9, file: !9, line: 681, type: !39, scopeLine: 681, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!39 = !DISubroutineType(types: !40)
!40 = !{null, !10}
!41 = !DILocalVariable(name: "expression", arg: 1, scope: !38, file: !9, line: 681, type: !10)
!42 = !DILocation(line: 0, scope: !38)
!43 = !DILocation(line: 681, column: 47, scope: !44)
!44 = distinct !DILexicalBlock(scope: !38, file: !9, line: 681, column: 46)
!45 = !DILocation(line: 681, column: 46, scope: !38)
!46 = !DILabel(scope: !47, name: "ERROR", file: !9, line: 681)
!47 = distinct !DILexicalBlock(scope: !44, file: !9, line: 681, column: 59)
!48 = !DILocation(line: 681, column: 61, scope: !47)
!49 = !DILocation(line: 681, column: 69, scope: !50)
!50 = distinct !DILexicalBlock(scope: !47, file: !9, line: 681, column: 68)
!51 = !DILocation(line: 681, column: 83, scope: !50)
!52 = !DILocation(line: 681, column: 95, scope: !38)
!53 = distinct !DISubprogram(name: "t1", scope: !9, file: !9, line: 686, type: !54, scopeLine: 686, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!54 = !DISubroutineType(types: !55)
!55 = !{!5, !5}
!56 = !DILocalVariable(name: "arg", arg: 1, scope: !53, file: !9, line: 686, type: !5)
!57 = !DILocation(line: 0, scope: !53)
!58 = !DILocation(line: 687, column: 8, scope: !59)
!59 = distinct !DILexicalBlock(scope: !53, file: !9, line: 687, column: 3)
!60 = !DILocation(line: 0, scope: !59)
!61 = !DILocation(line: 687, column: 17, scope: !62)
!62 = distinct !DILexicalBlock(scope: !59, file: !9, line: 687, column: 3)
!63 = !DILocation(line: 687, column: 3, scope: !59)
!64 = !DILocation(line: 688, column: 5, scope: !65)
!65 = distinct !DILexicalBlock(scope: !62, file: !9, line: 687, column: 27)
!66 = !DILocation(line: 689, column: 9, scope: !65)
!67 = !DILocation(line: 689, column: 13, scope: !65)
!68 = !DILocation(line: 689, column: 11, scope: !65)
!69 = !DILocation(line: 689, column: 7, scope: !65)
!70 = !DILocation(line: 690, column: 5, scope: !65)
!71 = !DILocation(line: 687, column: 23, scope: !62)
!72 = !DILocation(line: 687, column: 3, scope: !62)
!73 = distinct !{!73, !63, !74, !75}
!74 = !DILocation(line: 691, column: 3, scope: !59)
!75 = !{!"llvm.loop.mustprogress"}
!76 = !DILocation(line: 692, column: 3, scope: !53)
!77 = distinct !DISubprogram(name: "t2", scope: !9, file: !9, line: 694, type: !54, scopeLine: 694, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!78 = !DILocalVariable(name: "arg", arg: 1, scope: !77, file: !9, line: 694, type: !5)
!79 = !DILocation(line: 0, scope: !77)
!80 = !DILocation(line: 695, column: 8, scope: !81)
!81 = distinct !DILexicalBlock(scope: !77, file: !9, line: 695, column: 3)
!82 = !DILocation(line: 0, scope: !81)
!83 = !DILocation(line: 695, column: 17, scope: !84)
!84 = distinct !DILexicalBlock(scope: !81, file: !9, line: 695, column: 3)
!85 = !DILocation(line: 695, column: 3, scope: !81)
!86 = !DILocation(line: 696, column: 5, scope: !87)
!87 = distinct !DILexicalBlock(scope: !84, file: !9, line: 695, column: 27)
!88 = !DILocation(line: 697, column: 9, scope: !87)
!89 = !DILocation(line: 697, column: 13, scope: !87)
!90 = !DILocation(line: 697, column: 11, scope: !87)
!91 = !DILocation(line: 697, column: 7, scope: !87)
!92 = !DILocation(line: 698, column: 5, scope: !87)
!93 = !DILocation(line: 695, column: 23, scope: !84)
!94 = !DILocation(line: 695, column: 3, scope: !84)
!95 = distinct !{!95, !85, !96, !75}
!96 = !DILocation(line: 699, column: 3, scope: !81)
!97 = !DILocation(line: 700, column: 3, scope: !77)
!98 = distinct !DISubprogram(name: "fib", scope: !9, file: !9, line: 704, type: !99, scopeLine: 704, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!99 = !DISubroutineType(types: !100)
!100 = !{!10}
!101 = !DILocation(line: 705, column: 8, scope: !102)
!102 = distinct !DILexicalBlock(scope: !98, file: !9, line: 705, column: 3)
!103 = !DILocation(line: 0, scope: !102)
!104 = !DILocation(line: 705, column: 17, scope: !105)
!105 = distinct !DILexicalBlock(scope: !102, file: !9, line: 705, column: 3)
!106 = !DILocation(line: 705, column: 3, scope: !102)
!107 = !DILocation(line: 706, column: 12, scope: !108)
!108 = distinct !DILexicalBlock(scope: !105, file: !9, line: 705, column: 28)
!109 = !DILocation(line: 706, column: 19, scope: !108)
!110 = !DILocation(line: 706, column: 17, scope: !108)
!111 = !DILocation(line: 706, column: 10, scope: !108)
!112 = !DILocation(line: 707, column: 10, scope: !108)
!113 = !DILocation(line: 708, column: 9, scope: !108)
!114 = !DILocation(line: 705, column: 24, scope: !105)
!115 = !DILocation(line: 705, column: 3, scope: !105)
!116 = distinct !{!116, !106, !117, !75}
!117 = !DILocation(line: 709, column: 3, scope: !102)
!118 = !DILocation(line: 710, column: 10, scope: !98)
!119 = !DILocation(line: 710, column: 3, scope: !98)
!120 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 712, type: !121, scopeLine: 712, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!121 = !DISubroutineType(types: !122)
!122 = !{!10, !10, !123}
!123 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !124, size: 64)
!124 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !125, size: 64)
!125 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!126 = !DILocalVariable(name: "argc", arg: 1, scope: !120, file: !9, line: 712, type: !10)
!127 = !DILocation(line: 0, scope: !120)
!128 = !DILocalVariable(name: "argv", arg: 2, scope: !120, file: !9, line: 712, type: !123)
!129 = !DILocation(line: 714, column: 3, scope: !120)
!130 = !DILocation(line: 715, column: 5, scope: !120)
!131 = !DILocation(line: 716, column: 3, scope: !120)
!132 = !DILocation(line: 717, column: 3, scope: !120)
!133 = !DILocation(line: 718, column: 5, scope: !120)
!134 = !DILocation(line: 719, column: 3, scope: !120)
!135 = !DILocalVariable(name: "id1", scope: !120, file: !9, line: 713, type: !136)
!136 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !9, line: 275, baseType: !137)
!137 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!138 = !DILocation(line: 720, column: 3, scope: !120)
!139 = !DILocalVariable(name: "id2", scope: !120, file: !9, line: 713, type: !136)
!140 = !DILocation(line: 721, column: 3, scope: !120)
!141 = !DILocation(line: 722, column: 17, scope: !120)
!142 = !DILocalVariable(name: "correct", scope: !120, file: !9, line: 722, type: !10)
!143 = !DILocation(line: 723, column: 3, scope: !120)
!144 = !DILocation(line: 724, column: 23, scope: !120)
!145 = !DILocation(line: 724, column: 25, scope: !120)
!146 = !DILocation(line: 724, column: 35, scope: !120)
!147 = !DILocalVariable(name: "assert_cond", scope: !120, file: !9, line: 724, type: !148)
!148 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!149 = !DILocation(line: 725, column: 3, scope: !120)
!150 = !DILocation(line: 726, column: 21, scope: !120)
!151 = !DILocation(line: 726, column: 3, scope: !120)
!152 = !DILocation(line: 727, column: 3, scope: !120)
