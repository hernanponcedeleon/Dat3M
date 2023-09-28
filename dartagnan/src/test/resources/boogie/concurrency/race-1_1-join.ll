; ModuleID = '/home/ponce/git/Dat3M/output/race-1_1-join.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/ldv-races/race-1_1-join.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, %union.anon }
%union.anon = type { %struct.__pthread_internal_slist }
%struct.__pthread_internal_slist = type { %struct.__pthread_internal_slist* }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [16 x i8] c"race-1_1-join.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !0
@pdev = dso_local global i32 0, align 4, !dbg !12
@t1 = dso_local global i64 0, align 8, !dbg !7

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !57 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.1, i64 0, i64 0), i32 noundef 8, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !61
  unreachable, !dbg !61
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @ldv_assert(i32 noundef %0) #0 !dbg !64 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !67, metadata !DIExpression()), !dbg !68
  %.not = icmp eq i32 %0, 0, !dbg !69
  br i1 %.not, label %2, label %3, !dbg !71

2:                                                ; preds = %1
  call void @llvm.dbg.label(metadata !72), !dbg !74
  call void @reach_error(), !dbg !75
  call void @abort() #6, !dbg !77
  unreachable, !dbg !77

3:                                                ; preds = %1
  ret void, !dbg !78
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: nocallback noreturn nounwind
declare void @abort() #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread1(i8* noundef %0) #0 !dbg !79 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !82, metadata !DIExpression()), !dbg !83
  %2 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @mutex) #7, !dbg !84
  store i32 6, i32* @pdev, align 4, !dbg !85
  call void @ldv_assert(i32 noundef 1), !dbg !86
  %3 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @mutex) #7, !dbg !87
  ret i8* null, !dbg !88
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @module_init() #0 !dbg !89 {
  %1 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef nonnull @mutex, %union.pthread_mutexattr_t* noundef null) #8, !dbg !92
  store i32 1, i32* @pdev, align 4, !dbg !93
  call void @ldv_assert(i32 noundef 1), !dbg !94
  %2 = call i32 @__VERIFIER_nondet_int() #7, !dbg !95
  %.not = icmp eq i32 %2, 0, !dbg !95
  br i1 %.not, label %5, label %3, !dbg !97

3:                                                ; preds = %0
  %4 = call i32 @pthread_create(i64* noundef nonnull @t1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread1, i8* noundef null) #7, !dbg !98
  br label %7, !dbg !100

5:                                                ; preds = %0
  store i32 3, i32* @pdev, align 4, !dbg !101
  call void @ldv_assert(i32 noundef 1), !dbg !102
  %6 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef nonnull @mutex) #8, !dbg !103
  br label %7, !dbg !104

7:                                                ; preds = %5, %3
  %.0 = phi i32 [ 0, %3 ], [ -1, %5 ], !dbg !105
  ret i32 %.0, !dbg !106
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #4

declare i32 @__VERIFIER_nondet_int() #5

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @module_exit() #0 !dbg !107 {
  %1 = alloca i8*, align 8
  %2 = load i64, i64* @t1, align 8, !dbg !108
  call void @llvm.dbg.value(metadata i8** %1, metadata !109, metadata !DIExpression(DW_OP_deref)), !dbg !110
  %3 = call i32 @pthread_join(i64 noundef %2, i8** noundef nonnull %1) #7, !dbg !111
  %4 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef nonnull @mutex) #8, !dbg !112
  store i32 5, i32* @pdev, align 4, !dbg !113
  call void @ldv_assert(i32 noundef 1), !dbg !114
  ret void, !dbg !115
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #5

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !116 {
  %1 = call i32 @module_init(), !dbg !117
  %.not = icmp eq i32 %1, 0, !dbg !119
  br i1 %.not, label %2, label %3, !dbg !120

2:                                                ; preds = %0
  call void @module_exit(), !dbg !121
  br label %3, !dbg !121

3:                                                ; preds = %0, %2
  call void @llvm.dbg.label(metadata !122), !dbg !123
  ret i32 0, !dbg !124
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nocallback nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback noreturn nounwind }
attributes #7 = { nounwind }
attributes #8 = { nocallback nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!49, !50, !51, !52, !53, !54, !55}
!llvm.ident = !{!56}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !9, line: 1695, type: !15, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/ldv-races/race-1_1-join.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "3ec92c6041cdc7eb4712e02b7a96c7f8")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !0, !12}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "t1", scope: !2, file: !9, line: 1694, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "../sv-benchmarks/c/ldv-races/race-1_1-join.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "3ec92c6041cdc7eb4712e02b7a96c7f8")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !9, line: 268, baseType: !11)
!11 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "pdev", scope: !2, file: !9, line: 1696, type: !14, isLocal: false, isDefinition: true)
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !9, line: 292, baseType: !16)
!16 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !9, line: 287, size: 256, elements: !17)
!17 = !{!18, !42, !47}
!18 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !16, file: !9, line: 289, baseType: !19, size: 256)
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !9, line: 227, size: 256, elements: !20)
!20 = !{!21, !22, !24, !25, !26, !27}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !19, file: !9, line: 229, baseType: !14, size: 32)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !19, file: !9, line: 230, baseType: !23, size: 32, offset: 32)
!23 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !19, file: !9, line: 231, baseType: !14, size: 32, offset: 64)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !19, file: !9, line: 232, baseType: !14, size: 32, offset: 96)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !19, file: !9, line: 234, baseType: !23, size: 32, offset: 128)
!27 = !DIDerivedType(tag: DW_TAG_member, scope: !19, file: !9, line: 235, baseType: !28, size: 64, offset: 192)
!28 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !19, file: !9, line: 235, size: 64, elements: !29)
!29 = !{!30, !36}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "__elision_data", scope: !28, file: !9, line: 237, baseType: !31, size: 32)
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !28, file: !9, line: 237, size: 32, elements: !32)
!32 = !{!33, !35}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "__espins", scope: !31, file: !9, line: 237, baseType: !34, size: 16)
!34 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "__eelision", scope: !31, file: !9, line: 237, baseType: !34, size: 16, offset: 16)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !28, file: !9, line: 238, baseType: !37, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_slist_t", file: !9, line: 226, baseType: !38)
!38 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_slist", file: !9, line: 223, size: 64, elements: !39)
!39 = !{!40}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !38, file: !9, line: 225, baseType: !41, size: 64)
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !16, file: !9, line: 290, baseType: !43, size: 192)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !44, size: 192, elements: !45)
!44 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!45 = !{!46}
!46 = !DISubrange(count: 24)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !16, file: !9, line: 291, baseType: !48, size: 64)
!48 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!49 = !{i32 7, !"Dwarf Version", i32 5}
!50 = !{i32 2, !"Debug Info Version", i32 3}
!51 = !{i32 1, !"wchar_size", i32 4}
!52 = !{i32 7, !"PIC Level", i32 2}
!53 = !{i32 7, !"PIE Level", i32 2}
!54 = !{i32 7, !"uwtable", i32 1}
!55 = !{i32 7, !"frame-pointer", i32 2}
!56 = !{!"Ubuntu clang version 14.0.6"}
!57 = distinct !DISubprogram(name: "reach_error", scope: !9, file: !9, line: 1691, type: !58, scopeLine: 1691, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!58 = !DISubroutineType(types: !59)
!59 = !{null}
!60 = !{}
!61 = !DILocation(line: 1691, column: 83, scope: !62)
!62 = distinct !DILexicalBlock(scope: !63, file: !9, line: 1691, column: 73)
!63 = distinct !DILexicalBlock(scope: !57, file: !9, line: 1691, column: 67)
!64 = distinct !DISubprogram(name: "ldv_assert", scope: !9, file: !9, line: 1693, type: !65, scopeLine: 1693, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!65 = !DISubroutineType(types: !66)
!66 = !{null, !14}
!67 = !DILocalVariable(name: "expression", arg: 1, scope: !64, file: !9, line: 1693, type: !14)
!68 = !DILocation(line: 0, scope: !64)
!69 = !DILocation(line: 1693, column: 40, scope: !70)
!70 = distinct !DILexicalBlock(scope: !64, file: !9, line: 1693, column: 39)
!71 = !DILocation(line: 1693, column: 39, scope: !64)
!72 = !DILabel(scope: !73, name: "ERROR", file: !9, line: 1693)
!73 = distinct !DILexicalBlock(scope: !70, file: !9, line: 1693, column: 52)
!74 = !DILocation(line: 1693, column: 54, scope: !73)
!75 = !DILocation(line: 1693, column: 62, scope: !76)
!76 = distinct !DILexicalBlock(scope: !73, file: !9, line: 1693, column: 61)
!77 = !DILocation(line: 1693, column: 76, scope: !76)
!78 = !DILocation(line: 1693, column: 88, scope: !64)
!79 = distinct !DISubprogram(name: "thread1", scope: !9, file: !9, line: 1697, type: !80, scopeLine: 1697, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!80 = !DISubroutineType(types: !81)
!81 = !{!5, !5}
!82 = !DILocalVariable(name: "arg", arg: 1, scope: !79, file: !9, line: 1697, type: !5)
!83 = !DILocation(line: 0, scope: !79)
!84 = !DILocation(line: 1698, column: 4, scope: !79)
!85 = !DILocation(line: 1699, column: 9, scope: !79)
!86 = !DILocation(line: 1700, column: 4, scope: !79)
!87 = !DILocation(line: 1701, column: 4, scope: !79)
!88 = !DILocation(line: 1702, column: 4, scope: !79)
!89 = distinct !DISubprogram(name: "module_init", scope: !9, file: !9, line: 1704, type: !90, scopeLine: 1704, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!90 = !DISubroutineType(types: !91)
!91 = !{!14}
!92 = !DILocation(line: 1705, column: 4, scope: !89)
!93 = !DILocation(line: 1706, column: 9, scope: !89)
!94 = !DILocation(line: 1707, column: 4, scope: !89)
!95 = !DILocation(line: 1708, column: 7, scope: !96)
!96 = distinct !DILexicalBlock(scope: !89, file: !9, line: 1708, column: 7)
!97 = !DILocation(line: 1708, column: 7, scope: !89)
!98 = !DILocation(line: 1709, column: 7, scope: !99)
!99 = distinct !DILexicalBlock(scope: !96, file: !9, line: 1708, column: 32)
!100 = !DILocation(line: 1710, column: 7, scope: !99)
!101 = !DILocation(line: 1712, column: 9, scope: !89)
!102 = !DILocation(line: 1713, column: 4, scope: !89)
!103 = !DILocation(line: 1714, column: 4, scope: !89)
!104 = !DILocation(line: 1715, column: 4, scope: !89)
!105 = !DILocation(line: 0, scope: !89)
!106 = !DILocation(line: 1716, column: 1, scope: !89)
!107 = distinct !DISubprogram(name: "module_exit", scope: !9, file: !9, line: 1717, type: !58, scopeLine: 1717, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!108 = !DILocation(line: 1719, column: 17, scope: !107)
!109 = !DILocalVariable(name: "status", scope: !107, file: !9, line: 1718, type: !5)
!110 = !DILocation(line: 0, scope: !107)
!111 = !DILocation(line: 1719, column: 4, scope: !107)
!112 = !DILocation(line: 1720, column: 4, scope: !107)
!113 = !DILocation(line: 1721, column: 9, scope: !107)
!114 = !DILocation(line: 1722, column: 4, scope: !107)
!115 = !DILocation(line: 1723, column: 1, scope: !107)
!116 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 1724, type: !90, scopeLine: 1724, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!117 = !DILocation(line: 1725, column: 8, scope: !118)
!118 = distinct !DILexicalBlock(scope: !116, file: !9, line: 1725, column: 8)
!119 = !DILocation(line: 1725, column: 21, scope: !118)
!120 = !DILocation(line: 1725, column: 8, scope: !116)
!121 = !DILocation(line: 1726, column: 5, scope: !116)
!122 = !DILabel(scope: !116, name: "module_exit", file: !9, line: 1727)
!123 = !DILocation(line: 1727, column: 1, scope: !116)
!124 = !DILocation(line: 1728, column: 5, scope: !116)
