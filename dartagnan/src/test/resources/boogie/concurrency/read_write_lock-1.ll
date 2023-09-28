; ModuleID = '/home/ponce/git/Dat3M/output/read_write_lock-1.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-atomic/read_write_lock-1.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [20 x i8] c"read_write_lock-1.c\00", align 1
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
define dso_local void @__VERIFIER_atomic_release_read_lock() #0 !dbg !54 {
  %1 = load i32, i32* @r, align 4, !dbg !55
  %2 = add nsw i32 %1, -1, !dbg !56
  store i32 %2, i32* @r, align 4, !dbg !57
  ret void, !dbg !58
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @writer(i8* noundef %0) #0 !dbg !59 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !63, metadata !DIExpression()), !dbg !64
  call void @__VERIFIER_atomic_take_write_lock(), !dbg !65
  store i32 3, i32* @x, align 4, !dbg !66
  call void @__VERIFIER_atomic_begin() #8, !dbg !67
  store i32 0, i32* @w, align 4, !dbg !68
  call void @__VERIFIER_atomic_end() #8, !dbg !69
  ret i8* null, !dbg !70
}

declare void @__VERIFIER_atomic_begin() #4

declare void @__VERIFIER_atomic_end() #4

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @reader(i8* noundef %0) #0 !dbg !71 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !72, metadata !DIExpression()), !dbg !73
  call void @__VERIFIER_atomic_take_read_lock(), !dbg !74
  call void @__VERIFIER_atomic_begin() #8, !dbg !75
  %2 = load i32, i32* @x, align 4, !dbg !76
  call void @llvm.dbg.value(metadata i32 %2, metadata !77, metadata !DIExpression()), !dbg !73
  call void @__VERIFIER_atomic_end() #8, !dbg !78
  call void @__VERIFIER_atomic_begin() #8, !dbg !79
  store i32 %2, i32* @y, align 4, !dbg !80
  call void @__VERIFIER_atomic_end() #8, !dbg !81
  call void @__VERIFIER_atomic_begin() #8, !dbg !82
  %3 = load i32, i32* @y, align 4, !dbg !83
  call void @llvm.dbg.value(metadata i32 %3, metadata !84, metadata !DIExpression()), !dbg !73
  call void @__VERIFIER_atomic_end() #8, !dbg !85
  call void @__VERIFIER_atomic_begin() #8, !dbg !86
  %4 = load i32, i32* @x, align 4, !dbg !87
  call void @llvm.dbg.value(metadata i32 %4, metadata !88, metadata !DIExpression()), !dbg !73
  call void @__VERIFIER_atomic_end() #8, !dbg !89
  %5 = icmp eq i32 %3, %4, !dbg !90
  br i1 %5, label %7, label %6, !dbg !92

6:                                                ; preds = %1
  call void @llvm.dbg.label(metadata !93), !dbg !94
  call void @reach_error(), !dbg !95
  br label %7, !dbg !95

7:                                                ; preds = %6, %1
  call void @__VERIFIER_atomic_release_read_lock(), !dbg !96
  ret i8* null, !dbg !97
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !98 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !101, metadata !DIExpression(DW_OP_deref)), !dbg !104
  %5 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @writer, i8* noundef null) #8, !dbg !105
  call void @llvm.dbg.value(metadata i64* %2, metadata !106, metadata !DIExpression(DW_OP_deref)), !dbg !104
  %6 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @reader, i8* noundef null) #8, !dbg !107
  call void @llvm.dbg.value(metadata i64* %3, metadata !108, metadata !DIExpression(DW_OP_deref)), !dbg !104
  %7 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @writer, i8* noundef null) #8, !dbg !109
  call void @llvm.dbg.value(metadata i64* %4, metadata !110, metadata !DIExpression(DW_OP_deref)), !dbg !104
  %8 = call i32 @pthread_create(i64* noundef nonnull %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @reader, i8* noundef null) #8, !dbg !111
  %9 = load i64, i64* %1, align 8, !dbg !112
  call void @llvm.dbg.value(metadata i64 %9, metadata !101, metadata !DIExpression()), !dbg !104
  %10 = call i32 @pthread_join(i64 noundef %9, i8** noundef null) #8, !dbg !113
  %11 = load i64, i64* %2, align 8, !dbg !114
  call void @llvm.dbg.value(metadata i64 %11, metadata !106, metadata !DIExpression()), !dbg !104
  %12 = call i32 @pthread_join(i64 noundef %11, i8** noundef null) #8, !dbg !115
  %13 = load i64, i64* %3, align 8, !dbg !116
  call void @llvm.dbg.value(metadata i64 %13, metadata !108, metadata !DIExpression()), !dbg !104
  %14 = call i32 @pthread_join(i64 noundef %13, i8** noundef null) #8, !dbg !117
  %15 = load i64, i64* %4, align 8, !dbg !118
  call void @llvm.dbg.value(metadata i64 %15, metadata !110, metadata !DIExpression()), !dbg !104
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null) #8, !dbg !119
  ret i32 0, !dbg !120
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
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-atomic/read_write_lock-1.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "af3e6d6789953091e3d49f6204dad06e")
!4 = !{!0, !5, !9, !11}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "r", scope: !2, file: !7, line: 704, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/pthread-atomic/read_write_lock-1.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "af3e6d6789953091e3d49f6204dad06e")
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
!54 = distinct !DISubprogram(name: "__VERIFIER_atomic_release_read_lock", scope: !7, file: !7, line: 713, type: !34, scopeLine: 713, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!55 = !DILocation(line: 714, column: 7, scope: !54)
!56 = !DILocation(line: 714, column: 8, scope: !54)
!57 = !DILocation(line: 714, column: 5, scope: !54)
!58 = !DILocation(line: 715, column: 1, scope: !54)
!59 = distinct !DISubprogram(name: "writer", scope: !7, file: !7, line: 716, type: !60, scopeLine: 716, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!60 = !DISubroutineType(types: !61)
!61 = !{!62, !62}
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!63 = !DILocalVariable(name: "arg", arg: 1, scope: !59, file: !7, line: 716, type: !62)
!64 = !DILocation(line: 0, scope: !59)
!65 = !DILocation(line: 717, column: 3, scope: !59)
!66 = !DILocation(line: 718, column: 5, scope: !59)
!67 = !DILocation(line: 719, column: 3, scope: !59)
!68 = !DILocation(line: 720, column: 5, scope: !59)
!69 = !DILocation(line: 721, column: 3, scope: !59)
!70 = !DILocation(line: 722, column: 3, scope: !59)
!71 = distinct !DISubprogram(name: "reader", scope: !7, file: !7, line: 724, type: !60, scopeLine: 724, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!72 = !DILocalVariable(name: "arg", arg: 1, scope: !71, file: !7, line: 724, type: !62)
!73 = !DILocation(line: 0, scope: !71)
!74 = !DILocation(line: 726, column: 3, scope: !71)
!75 = !DILocation(line: 727, column: 3, scope: !71)
!76 = !DILocation(line: 728, column: 7, scope: !71)
!77 = !DILocalVariable(name: "l", scope: !71, file: !7, line: 725, type: !8)
!78 = !DILocation(line: 729, column: 3, scope: !71)
!79 = !DILocation(line: 730, column: 3, scope: !71)
!80 = !DILocation(line: 731, column: 5, scope: !71)
!81 = !DILocation(line: 732, column: 3, scope: !71)
!82 = !DILocation(line: 733, column: 3, scope: !71)
!83 = !DILocation(line: 734, column: 12, scope: !71)
!84 = !DILocalVariable(name: "ly", scope: !71, file: !7, line: 734, type: !8)
!85 = !DILocation(line: 735, column: 3, scope: !71)
!86 = !DILocation(line: 736, column: 3, scope: !71)
!87 = !DILocation(line: 737, column: 12, scope: !71)
!88 = !DILocalVariable(name: "lx", scope: !71, file: !7, line: 737, type: !8)
!89 = !DILocation(line: 738, column: 3, scope: !71)
!90 = !DILocation(line: 739, column: 12, scope: !91)
!91 = distinct !DILexicalBlock(scope: !71, file: !7, line: 739, column: 7)
!92 = !DILocation(line: 739, column: 7, scope: !71)
!93 = !DILabel(scope: !91, name: "ERROR", file: !7, line: 739)
!94 = !DILocation(line: 739, column: 20, scope: !91)
!95 = !DILocation(line: 739, column: 27, scope: !91)
!96 = !DILocation(line: 740, column: 3, scope: !71)
!97 = !DILocation(line: 741, column: 3, scope: !71)
!98 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 743, type: !99, scopeLine: 743, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!99 = !DISubroutineType(types: !100)
!100 = !{!8}
!101 = !DILocalVariable(name: "t1", scope: !98, file: !7, line: 744, type: !102)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 300, baseType: !103)
!103 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!104 = !DILocation(line: 0, scope: !98)
!105 = !DILocation(line: 745, column: 3, scope: !98)
!106 = !DILocalVariable(name: "t2", scope: !98, file: !7, line: 744, type: !102)
!107 = !DILocation(line: 746, column: 3, scope: !98)
!108 = !DILocalVariable(name: "t3", scope: !98, file: !7, line: 744, type: !102)
!109 = !DILocation(line: 747, column: 3, scope: !98)
!110 = !DILocalVariable(name: "t4", scope: !98, file: !7, line: 744, type: !102)
!111 = !DILocation(line: 748, column: 3, scope: !98)
!112 = !DILocation(line: 749, column: 16, scope: !98)
!113 = !DILocation(line: 749, column: 3, scope: !98)
!114 = !DILocation(line: 750, column: 16, scope: !98)
!115 = !DILocation(line: 750, column: 3, scope: !98)
!116 = !DILocation(line: 751, column: 16, scope: !98)
!117 = !DILocation(line: 751, column: 3, scope: !98)
!118 = !DILocation(line: 752, column: 16, scope: !98)
!119 = !DILocation(line: 752, column: 3, scope: !98)
!120 = !DILocation(line: 753, column: 3, scope: !98)
