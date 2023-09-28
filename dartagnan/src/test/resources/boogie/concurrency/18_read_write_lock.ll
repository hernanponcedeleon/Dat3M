; ModuleID = '/home/ponce/git/Dat3M/output/18_read_write_lock.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/18_read_write_lock.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"18_read_write_lock.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@w = dso_local global i32 0, align 4, !dbg !0
@r = dso_local global i32 0, align 4, !dbg !5
@x = dso_local global i32 0, align 4, !dbg !9
@y = dso_local global i32 0, align 4, !dbg !11

; Function Attrs: noinline nounwind uwtable
define dso_local void @assume_abort_if_not(i32 noundef %0) #0 !dbg !21 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !25, metadata !DIExpression()), !dbg !26
  %.not = icmp eq i32 %0, 0, !dbg !27
  br i1 %.not, label %2, label %3, !dbg !29

2:                                                ; preds = %1
  call void @abort() #6, !dbg !30
  unreachable, !dbg !30

3:                                                ; preds = %1
  ret void, !dbg !32
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn
declare void @abort() #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !33 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.1, i64 0, i64 0), i32 noundef 7, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #7, !dbg !36
  unreachable, !dbg !36
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_w() #0 !dbg !39 {
  %1 = load i32, i32* @w, align 4, !dbg !40
  %2 = icmp eq i32 %1, 0, !dbg !41
  %3 = zext i1 %2 to i32, !dbg !41
  call void @assume_abort_if_not(i32 noundef %3), !dbg !42
  %4 = load i32, i32* @r, align 4, !dbg !43
  %5 = icmp eq i32 %4, 0, !dbg !44
  %6 = zext i1 %5 to i32, !dbg !44
  call void @assume_abort_if_not(i32 noundef %6), !dbg !45
  store i32 1, i32* @w, align 4, !dbg !46
  ret void, !dbg !47
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thr1(i8* noundef %0) #0 !dbg !48 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !52, metadata !DIExpression()), !dbg !53
  call void @__VERIFIER_atomic_w(), !dbg !54
  store i32 3, i32* @x, align 4, !dbg !55
  call void @__VERIFIER_atomic_begin() #8, !dbg !56
  store i32 0, i32* @w, align 4, !dbg !57
  call void @__VERIFIER_atomic_end() #8, !dbg !58
  ret i8* null, !dbg !59
}

declare void @__VERIFIER_atomic_begin() #4

declare void @__VERIFIER_atomic_end() #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_r() #0 !dbg !60 {
  %1 = load i32, i32* @w, align 4, !dbg !61
  %2 = icmp eq i32 %1, 0, !dbg !62
  %3 = zext i1 %2 to i32, !dbg !62
  call void @assume_abort_if_not(i32 noundef %3), !dbg !63
  %4 = load i32, i32* @r, align 4, !dbg !64
  %5 = add nsw i32 %4, 1, !dbg !65
  store i32 %5, i32* @r, align 4, !dbg !66
  ret void, !dbg !67
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thr2(i8* noundef %0) #0 !dbg !68 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !69, metadata !DIExpression()), !dbg !70
  call void @__VERIFIER_atomic_r(), !dbg !71
  call void @__VERIFIER_atomic_begin() #8, !dbg !72
  %2 = load i32, i32* @x, align 4, !dbg !73
  call void @llvm.dbg.value(metadata i32 %2, metadata !74, metadata !DIExpression()), !dbg !70
  call void @__VERIFIER_atomic_end() #8, !dbg !75
  call void @__VERIFIER_atomic_begin() #8, !dbg !76
  store i32 %2, i32* @y, align 4, !dbg !77
  call void @__VERIFIER_atomic_end() #8, !dbg !78
  call void @__VERIFIER_atomic_begin() #8, !dbg !79
  %3 = load i32, i32* @y, align 4, !dbg !80
  call void @llvm.dbg.value(metadata i32 %3, metadata !81, metadata !DIExpression()), !dbg !70
  call void @__VERIFIER_atomic_end() #8, !dbg !82
  call void @__VERIFIER_atomic_begin() #8, !dbg !83
  %4 = load i32, i32* @x, align 4, !dbg !84
  call void @llvm.dbg.value(metadata i32 %4, metadata !85, metadata !DIExpression()), !dbg !70
  call void @__VERIFIER_atomic_end() #8, !dbg !86
  %5 = icmp eq i32 %3, %4, !dbg !87
  br i1 %5, label %7, label %6, !dbg !90

6:                                                ; preds = %1
  call void @llvm.dbg.label(metadata !91), !dbg !93
  call void @reach_error(), !dbg !94
  call void @abort() #6, !dbg !96
  unreachable, !dbg !96

7:                                                ; preds = %1
  call void @__VERIFIER_atomic_begin() #8, !dbg !97
  %8 = load i32, i32* @r, align 4, !dbg !98
  call void @llvm.dbg.value(metadata i32 %8, metadata !99, metadata !DIExpression()), !dbg !70
  call void @__VERIFIER_atomic_end() #8, !dbg !100
  call void @__VERIFIER_atomic_begin() #8, !dbg !101
  %9 = add nsw i32 %8, -1, !dbg !102
  store i32 %9, i32* @r, align 4, !dbg !103
  call void @__VERIFIER_atomic_end() #8, !dbg !104
  ret i8* null, !dbg !105
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !106 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !109, metadata !DIExpression(DW_OP_deref)), !dbg !112
  %2 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thr1, i8* noundef null) #8, !dbg !113
  %3 = call i8* @thr2(i8* noundef null), !dbg !114
  ret i32 0, !dbg !115
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { noreturn nounwind }
attributes #7 = { nocallback noreturn nounwind }
attributes #8 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!13, !14, !15, !16, !17, !18, !19}
!llvm.ident = !{!20}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "w", scope: !2, file: !7, line: 704, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/18_read_write_lock.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "0e2d79a3e66603930f8c9e2ab55b22d7")
!4 = !{!0, !5, !9, !11}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "r", scope: !2, file: !7, line: 704, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/pthread-ext/18_read_write_lock.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "0e2d79a3e66603930f8c9e2ab55b22d7")
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !DIGlobalVariableExpression(var: !10, expr: !DIExpression())
!10 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !7, line: 704, type: !8, isLocal: false, isDefinition: true)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !7, line: 704, type: !8, isLocal: false, isDefinition: true)
!13 = !{i32 7, !"Dwarf Version", i32 5}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = !{i32 7, !"PIC Level", i32 2}
!17 = !{i32 7, !"PIE Level", i32 2}
!18 = !{i32 7, !"uwtable", i32 1}
!19 = !{i32 7, !"frame-pointer", i32 2}
!20 = !{!"Ubuntu clang version 14.0.6"}
!21 = distinct !DISubprogram(name: "assume_abort_if_not", scope: !7, file: !7, line: 2, type: !22, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!22 = !DISubroutineType(types: !23)
!23 = !{null, !8}
!24 = !{}
!25 = !DILocalVariable(name: "cond", arg: 1, scope: !21, file: !7, line: 2, type: !8)
!26 = !DILocation(line: 0, scope: !21)
!27 = !DILocation(line: 3, column: 7, scope: !28)
!28 = distinct !DILexicalBlock(scope: !21, file: !7, line: 3, column: 6)
!29 = !DILocation(line: 3, column: 6, scope: !21)
!30 = !DILocation(line: 3, column: 14, scope: !31)
!31 = distinct !DILexicalBlock(scope: !28, file: !7, line: 3, column: 13)
!32 = !DILocation(line: 4, column: 1, scope: !21)
!33 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 16, type: !34, scopeLine: 16, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!34 = !DISubroutineType(types: !35)
!35 = !{null}
!36 = !DILocation(line: 16, column: 83, scope: !37)
!37 = distinct !DILexicalBlock(scope: !38, file: !7, line: 16, column: 73)
!38 = distinct !DILexicalBlock(scope: !33, file: !7, line: 16, column: 67)
!39 = distinct !DISubprogram(name: "__VERIFIER_atomic_w", scope: !7, file: !7, line: 705, type: !34, scopeLine: 706, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!40 = !DILocation(line: 707, column: 25, scope: !39)
!41 = !DILocation(line: 707, column: 26, scope: !39)
!42 = !DILocation(line: 707, column: 5, scope: !39)
!43 = !DILocation(line: 708, column: 25, scope: !39)
!44 = !DILocation(line: 708, column: 26, scope: !39)
!45 = !DILocation(line: 708, column: 5, scope: !39)
!46 = !DILocation(line: 709, column: 7, scope: !39)
!47 = !DILocation(line: 710, column: 1, scope: !39)
!48 = distinct !DISubprogram(name: "thr1", scope: !7, file: !7, line: 711, type: !49, scopeLine: 711, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!49 = !DISubroutineType(types: !50)
!50 = !{!51, !51}
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!52 = !DILocalVariable(name: "arg", arg: 1, scope: !48, file: !7, line: 711, type: !51)
!53 = !DILocation(line: 0, scope: !48)
!54 = !DILocation(line: 712, column: 3, scope: !48)
!55 = !DILocation(line: 713, column: 5, scope: !48)
!56 = !DILocation(line: 714, column: 3, scope: !48)
!57 = !DILocation(line: 715, column: 5, scope: !48)
!58 = !DILocation(line: 716, column: 3, scope: !48)
!59 = !DILocation(line: 717, column: 3, scope: !48)
!60 = distinct !DISubprogram(name: "__VERIFIER_atomic_r", scope: !7, file: !7, line: 719, type: !34, scopeLine: 720, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!61 = !DILocation(line: 721, column: 25, scope: !60)
!62 = !DILocation(line: 721, column: 26, scope: !60)
!63 = !DILocation(line: 721, column: 5, scope: !60)
!64 = !DILocation(line: 722, column: 9, scope: !60)
!65 = !DILocation(line: 722, column: 10, scope: !60)
!66 = !DILocation(line: 722, column: 7, scope: !60)
!67 = !DILocation(line: 723, column: 1, scope: !60)
!68 = distinct !DISubprogram(name: "thr2", scope: !7, file: !7, line: 724, type: !49, scopeLine: 724, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!69 = !DILocalVariable(name: "arg", arg: 1, scope: !68, file: !7, line: 724, type: !51)
!70 = !DILocation(line: 0, scope: !68)
!71 = !DILocation(line: 725, column: 3, scope: !68)
!72 = !DILocation(line: 726, column: 3, scope: !68)
!73 = !DILocation(line: 727, column: 11, scope: !68)
!74 = !DILocalVariable(name: "l", scope: !68, file: !7, line: 727, type: !8)
!75 = !DILocation(line: 728, column: 3, scope: !68)
!76 = !DILocation(line: 729, column: 3, scope: !68)
!77 = !DILocation(line: 730, column: 5, scope: !68)
!78 = !DILocation(line: 731, column: 3, scope: !68)
!79 = !DILocation(line: 732, column: 3, scope: !68)
!80 = !DILocation(line: 733, column: 12, scope: !68)
!81 = !DILocalVariable(name: "ly", scope: !68, file: !7, line: 733, type: !8)
!82 = !DILocation(line: 734, column: 3, scope: !68)
!83 = !DILocation(line: 735, column: 3, scope: !68)
!84 = !DILocation(line: 736, column: 12, scope: !68)
!85 = !DILocalVariable(name: "lx", scope: !68, file: !7, line: 736, type: !8)
!86 = !DILocation(line: 737, column: 3, scope: !68)
!87 = !DILocation(line: 738, column: 13, scope: !88)
!88 = distinct !DILexicalBlock(scope: !89, file: !7, line: 738, column: 8)
!89 = distinct !DILexicalBlock(scope: !68, file: !7, line: 738, column: 3)
!90 = !DILocation(line: 738, column: 8, scope: !89)
!91 = !DILabel(scope: !92, name: "ERROR", file: !7, line: 738)
!92 = distinct !DILexicalBlock(scope: !88, file: !7, line: 738, column: 21)
!93 = !DILocation(line: 738, column: 23, scope: !92)
!94 = !DILocation(line: 738, column: 31, scope: !95)
!95 = distinct !DILexicalBlock(scope: !92, file: !7, line: 738, column: 30)
!96 = !DILocation(line: 738, column: 45, scope: !95)
!97 = !DILocation(line: 739, column: 3, scope: !68)
!98 = !DILocation(line: 740, column: 12, scope: !68)
!99 = !DILocalVariable(name: "lr", scope: !68, file: !7, line: 740, type: !8)
!100 = !DILocation(line: 741, column: 3, scope: !68)
!101 = !DILocation(line: 742, column: 3, scope: !68)
!102 = !DILocation(line: 743, column: 9, scope: !68)
!103 = !DILocation(line: 743, column: 5, scope: !68)
!104 = !DILocation(line: 744, column: 3, scope: !68)
!105 = !DILocation(line: 745, column: 3, scope: !68)
!106 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 747, type: !107, scopeLine: 748, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!107 = !DISubroutineType(types: !108)
!108 = !{!8}
!109 = !DILocalVariable(name: "t", scope: !106, file: !7, line: 749, type: !110)
!110 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 300, baseType: !111)
!111 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!112 = !DILocation(line: 0, scope: !106)
!113 = !DILocation(line: 750, column: 3, scope: !106)
!114 = !DILocation(line: 751, column: 3, scope: !106)
!115 = !DILocation(line: 752, column: 3, scope: !106)
