; ModuleID = '/home/ponce/git/Dat3M/output/read_write_lock-2.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-atomic/read_write_lock-2.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [20 x i8] c"read_write_lock-2.c\00", align 1
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.1, i64 0, i64 0), i32 noundef 7, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #7, !dbg !36
  unreachable, !dbg !36
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_take_write_lock() #0 !dbg !39 {
  %1 = load i32, i32* @w, align 4, !dbg !40
  %2 = icmp eq i32 %1, 0, !dbg !41
  %3 = load i32, i32* @r, align 4, !dbg !42
  %4 = icmp eq i32 %3, 0, !dbg !42
  %5 = select i1 %2, i1 %4, i1 false, !dbg !42
  %6 = zext i1 %5 to i32, !dbg !42
  call void @assume_abort_if_not(i32 noundef %6), !dbg !43
  store i32 1, i32* @w, align 4, !dbg !44
  ret void, !dbg !45
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_take_read_lock() #0 !dbg !46 {
  %1 = load i32, i32* @w, align 4, !dbg !47
  %2 = icmp eq i32 %1, 0, !dbg !48
  %3 = zext i1 %2 to i32, !dbg !48
  call void @assume_abort_if_not(i32 noundef %3), !dbg !49
  %4 = load i32, i32* @r, align 4, !dbg !50
  %5 = add nsw i32 %4, 1, !dbg !51
  store i32 %5, i32* @r, align 4, !dbg !52
  ret void, !dbg !53
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @writer(i8* noundef %0) #0 !dbg !54 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !58, metadata !DIExpression()), !dbg !59
  call void @__VERIFIER_atomic_take_write_lock(), !dbg !60
  call void @__VERIFIER_atomic_begin() #8, !dbg !61
  store i32 3, i32* @x, align 4, !dbg !62
  call void @__VERIFIER_atomic_end() #8, !dbg !63
  call void @__VERIFIER_atomic_begin() #8, !dbg !64
  store i32 0, i32* @w, align 4, !dbg !65
  call void @__VERIFIER_atomic_end() #8, !dbg !66
  ret i8* null, !dbg !67
}

declare void @__VERIFIER_atomic_begin() #4

declare void @__VERIFIER_atomic_end() #4

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @reader(i8* noundef %0) #0 !dbg !68 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !69, metadata !DIExpression()), !dbg !70
  call void @__VERIFIER_atomic_take_read_lock(), !dbg !71
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
  br i1 %5, label %7, label %6, !dbg !89

6:                                                ; preds = %1
  call void @llvm.dbg.label(metadata !90), !dbg !91
  call void @reach_error(), !dbg !92
  br label %7, !dbg !92

7:                                                ; preds = %6, %1
  call void @__VERIFIER_atomic_begin() #8, !dbg !93
  %8 = load i32, i32* @r, align 4, !dbg !94
  %9 = add nsw i32 %8, -1, !dbg !95
  call void @llvm.dbg.value(metadata i32 %9, metadata !74, metadata !DIExpression()), !dbg !70
  call void @__VERIFIER_atomic_end() #8, !dbg !96
  call void @__VERIFIER_atomic_begin() #8, !dbg !97
  store i32 %9, i32* @r, align 4, !dbg !98
  call void @__VERIFIER_atomic_end() #8, !dbg !99
  ret i8* null, !dbg !100
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !101 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !104, metadata !DIExpression(DW_OP_deref)), !dbg !107
  %5 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @writer, i8* noundef null) #8, !dbg !108
  call void @llvm.dbg.value(metadata i64* %2, metadata !109, metadata !DIExpression(DW_OP_deref)), !dbg !107
  %6 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @reader, i8* noundef null) #8, !dbg !110
  call void @llvm.dbg.value(metadata i64* %3, metadata !111, metadata !DIExpression(DW_OP_deref)), !dbg !107
  %7 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @writer, i8* noundef null) #8, !dbg !112
  call void @llvm.dbg.value(metadata i64* %4, metadata !113, metadata !DIExpression(DW_OP_deref)), !dbg !107
  %8 = call i32 @pthread_create(i64* noundef nonnull %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @reader, i8* noundef null) #8, !dbg !114
  %9 = load i64, i64* %1, align 8, !dbg !115
  call void @llvm.dbg.value(metadata i64 %9, metadata !104, metadata !DIExpression()), !dbg !107
  %10 = call i32 @pthread_join(i64 noundef %9, i8** noundef null) #8, !dbg !116
  %11 = load i64, i64* %2, align 8, !dbg !117
  call void @llvm.dbg.value(metadata i64 %11, metadata !109, metadata !DIExpression()), !dbg !107
  %12 = call i32 @pthread_join(i64 noundef %11, i8** noundef null) #8, !dbg !118
  %13 = load i64, i64* %3, align 8, !dbg !119
  call void @llvm.dbg.value(metadata i64 %13, metadata !111, metadata !DIExpression()), !dbg !107
  %14 = call i32 @pthread_join(i64 noundef %13, i8** noundef null) #8, !dbg !120
  %15 = load i64, i64* %4, align 8, !dbg !121
  call void @llvm.dbg.value(metadata i64 %15, metadata !113, metadata !DIExpression()), !dbg !107
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null) #8, !dbg !122
  ret i32 0, !dbg !123
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

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
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-atomic/read_write_lock-2.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "48a22c21b0c3fd7ee951e2128f1f2008")
!4 = !{!0, !5, !9, !11}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "r", scope: !2, file: !7, line: 704, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/pthread-atomic/read_write_lock-2.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "48a22c21b0c3fd7ee951e2128f1f2008")
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
!39 = distinct !DISubprogram(name: "__VERIFIER_atomic_take_write_lock", scope: !7, file: !7, line: 705, type: !34, scopeLine: 705, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!40 = !DILocation(line: 706, column: 23, scope: !39)
!41 = !DILocation(line: 706, column: 24, scope: !39)
!42 = !DILocation(line: 706, column: 28, scope: !39)
!43 = !DILocation(line: 706, column: 3, scope: !39)
!44 = !DILocation(line: 707, column: 5, scope: !39)
!45 = !DILocation(line: 708, column: 1, scope: !39)
!46 = distinct !DISubprogram(name: "__VERIFIER_atomic_take_read_lock", scope: !7, file: !7, line: 709, type: !34, scopeLine: 709, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!47 = !DILocation(line: 710, column: 23, scope: !46)
!48 = !DILocation(line: 710, column: 24, scope: !46)
!49 = !DILocation(line: 710, column: 3, scope: !46)
!50 = !DILocation(line: 711, column: 7, scope: !46)
!51 = !DILocation(line: 711, column: 8, scope: !46)
!52 = !DILocation(line: 711, column: 5, scope: !46)
!53 = !DILocation(line: 712, column: 1, scope: !46)
!54 = distinct !DISubprogram(name: "writer", scope: !7, file: !7, line: 713, type: !55, scopeLine: 713, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!55 = !DISubroutineType(types: !56)
!56 = !{!57, !57}
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!58 = !DILocalVariable(name: "arg", arg: 1, scope: !54, file: !7, line: 713, type: !57)
!59 = !DILocation(line: 0, scope: !54)
!60 = !DILocation(line: 714, column: 3, scope: !54)
!61 = !DILocation(line: 715, column: 3, scope: !54)
!62 = !DILocation(line: 716, column: 5, scope: !54)
!63 = !DILocation(line: 717, column: 3, scope: !54)
!64 = !DILocation(line: 718, column: 3, scope: !54)
!65 = !DILocation(line: 719, column: 5, scope: !54)
!66 = !DILocation(line: 720, column: 3, scope: !54)
!67 = !DILocation(line: 721, column: 3, scope: !54)
!68 = distinct !DISubprogram(name: "reader", scope: !7, file: !7, line: 723, type: !55, scopeLine: 723, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!69 = !DILocalVariable(name: "arg", arg: 1, scope: !68, file: !7, line: 723, type: !57)
!70 = !DILocation(line: 0, scope: !68)
!71 = !DILocation(line: 725, column: 3, scope: !68)
!72 = !DILocation(line: 726, column: 3, scope: !68)
!73 = !DILocation(line: 727, column: 7, scope: !68)
!74 = !DILocalVariable(name: "l", scope: !68, file: !7, line: 724, type: !8)
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
!87 = !DILocation(line: 738, column: 12, scope: !88)
!88 = distinct !DILexicalBlock(scope: !68, file: !7, line: 738, column: 7)
!89 = !DILocation(line: 738, column: 7, scope: !68)
!90 = !DILabel(scope: !88, name: "ERROR", file: !7, line: 738)
!91 = !DILocation(line: 738, column: 20, scope: !88)
!92 = !DILocation(line: 738, column: 27, scope: !88)
!93 = !DILocation(line: 739, column: 3, scope: !68)
!94 = !DILocation(line: 740, column: 7, scope: !68)
!95 = !DILocation(line: 740, column: 8, scope: !68)
!96 = !DILocation(line: 741, column: 3, scope: !68)
!97 = !DILocation(line: 742, column: 3, scope: !68)
!98 = !DILocation(line: 743, column: 5, scope: !68)
!99 = !DILocation(line: 744, column: 3, scope: !68)
!100 = !DILocation(line: 745, column: 3, scope: !68)
!101 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 747, type: !102, scopeLine: 747, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!102 = !DISubroutineType(types: !103)
!103 = !{!8}
!104 = !DILocalVariable(name: "t1", scope: !101, file: !7, line: 748, type: !105)
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 300, baseType: !106)
!106 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!107 = !DILocation(line: 0, scope: !101)
!108 = !DILocation(line: 749, column: 3, scope: !101)
!109 = !DILocalVariable(name: "t2", scope: !101, file: !7, line: 748, type: !105)
!110 = !DILocation(line: 750, column: 3, scope: !101)
!111 = !DILocalVariable(name: "t3", scope: !101, file: !7, line: 748, type: !105)
!112 = !DILocation(line: 751, column: 3, scope: !101)
!113 = !DILocalVariable(name: "t4", scope: !101, file: !7, line: 748, type: !105)
!114 = !DILocation(line: 752, column: 3, scope: !101)
!115 = !DILocation(line: 753, column: 16, scope: !101)
!116 = !DILocation(line: 753, column: 3, scope: !101)
!117 = !DILocation(line: 754, column: 16, scope: !101)
!118 = !DILocation(line: 754, column: 3, scope: !101)
!119 = !DILocation(line: 755, column: 16, scope: !101)
!120 = !DILocation(line: 755, column: 3, scope: !101)
!121 = !DILocation(line: 756, column: 16, scope: !101)
!122 = !DILocation(line: 756, column: 3, scope: !101)
!123 = !DILocation(line: 757, column: 3, scope: !101)
