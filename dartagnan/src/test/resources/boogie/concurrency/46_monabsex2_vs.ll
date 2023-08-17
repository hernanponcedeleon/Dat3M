; ModuleID = '/home/ponce/git/Dat3M/output/46_monabsex2_vs.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/46_monabsex2_vs.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"46_monabsex2_vs.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@s = dso_local global i8 0, align 1, !dbg !0
@l = dso_local global i8 0, align 1, !dbg !5

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !17 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.1, i64 0, i64 0), i32 noundef 3, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !21
  unreachable, !dbg !21
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thr1(i8* noundef %0) #0 !dbg !24 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !28, metadata !DIExpression()), !dbg !29
  call void @__VERIFIER_atomic_begin() #7, !dbg !30
  %2 = load i8, i8* @l, align 1, !dbg !31
  %3 = and i8 %2, 1, !dbg !31
  %.not = icmp eq i8 %3, 0, !dbg !31
  br i1 %.not, label %8, label %4, !dbg !34

4:                                                ; preds = %1
  %5 = load i8, i8* @s, align 1, !dbg !35
  %6 = and i8 %5, 1, !dbg !35
  %.not1 = icmp eq i8 %6, 0, !dbg !35
  br i1 %.not1, label %7, label %8, !dbg !36

7:                                                ; preds = %4
  call void @llvm.dbg.label(metadata !37), !dbg !39
  call void @reach_error(), !dbg !40
  call void @abort() #8, !dbg !42
  unreachable, !dbg !42

8:                                                ; preds = %4, %1
  call void @__VERIFIER_atomic_end() #7, !dbg !43
  call void @__VERIFIER_atomic_begin() #7, !dbg !44
  store i8 1, i8* @s, align 1, !dbg !45
  call void @__VERIFIER_atomic_end() #7, !dbg !46
  call void @__VERIFIER_atomic_begin() #7, !dbg !47
  store i8 1, i8* @l, align 1, !dbg !48
  call void @__VERIFIER_atomic_end() #7, !dbg !49
  ret i8* null, !dbg !50
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

declare void @__VERIFIER_atomic_begin() #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: noreturn
declare void @abort() #4

declare void @__VERIFIER_atomic_end() #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !51 {
  %1 = alloca i64, align 8
  br label %2, !dbg !55

2:                                                ; preds = %2, %0
  call void @llvm.dbg.value(metadata i64* %1, metadata !56, metadata !DIExpression(DW_OP_deref)), !dbg !59
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thr1, i8* noundef null) #7, !dbg !60
  br label %2, !dbg !55, !llvm.loop !61
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback noreturn nounwind }
attributes #7 = { nounwind }
attributes #8 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !7, line: 700, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/46_monabsex2_vs.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "02284faac796c86cf2aa7d20661cab49")
!4 = !{!0, !5}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "l", scope: !2, file: !7, line: 701, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/pthread-ext/46_monabsex2_vs.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "02284faac796c86cf2aa7d20661cab49")
!8 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 7, !"PIC Level", i32 2}
!13 = !{i32 7, !"PIE Level", i32 2}
!14 = !{i32 7, !"uwtable", i32 1}
!15 = !{i32 7, !"frame-pointer", i32 2}
!16 = !{!"Ubuntu clang version 14.0.6"}
!17 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 12, type: !18, scopeLine: 12, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!18 = !DISubroutineType(types: !19)
!19 = !{null}
!20 = !{}
!21 = !DILocation(line: 12, column: 83, scope: !22)
!22 = distinct !DILexicalBlock(scope: !23, file: !7, line: 12, column: 73)
!23 = distinct !DILexicalBlock(scope: !17, file: !7, line: 12, column: 67)
!24 = distinct !DISubprogram(name: "thr1", scope: !7, file: !7, line: 702, type: !25, scopeLine: 703, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!25 = !DISubroutineType(types: !26)
!26 = !{!27, !27}
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = !DILocalVariable(name: "arg", arg: 1, scope: !24, file: !7, line: 702, type: !27)
!29 = !DILocation(line: 0, scope: !24)
!30 = !DILocation(line: 704, column: 5, scope: !24)
!31 = !DILocation(line: 705, column: 13, scope: !32)
!32 = distinct !DILexicalBlock(scope: !33, file: !7, line: 705, column: 10)
!33 = distinct !DILexicalBlock(scope: !24, file: !7, line: 705, column: 5)
!34 = !DILocation(line: 705, column: 15, scope: !32)
!35 = !DILocation(line: 705, column: 18, scope: !32)
!36 = !DILocation(line: 705, column: 10, scope: !33)
!37 = !DILabel(scope: !38, name: "ERROR", file: !7, line: 705)
!38 = distinct !DILexicalBlock(scope: !32, file: !7, line: 705, column: 22)
!39 = !DILocation(line: 705, column: 24, scope: !38)
!40 = !DILocation(line: 705, column: 32, scope: !41)
!41 = distinct !DILexicalBlock(scope: !38, file: !7, line: 705, column: 31)
!42 = !DILocation(line: 705, column: 46, scope: !41)
!43 = !DILocation(line: 706, column: 5, scope: !24)
!44 = !DILocation(line: 707, column: 5, scope: !24)
!45 = !DILocation(line: 708, column: 7, scope: !24)
!46 = !DILocation(line: 709, column: 5, scope: !24)
!47 = !DILocation(line: 710, column: 5, scope: !24)
!48 = !DILocation(line: 711, column: 7, scope: !24)
!49 = !DILocation(line: 712, column: 5, scope: !24)
!50 = !DILocation(line: 713, column: 5, scope: !24)
!51 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 715, type: !52, scopeLine: 716, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!52 = !DISubroutineType(types: !53)
!53 = !{!54}
!54 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!55 = !DILocation(line: 718, column: 3, scope: !51)
!56 = !DILocalVariable(name: "t", scope: !51, file: !7, line: 717, type: !57)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 296, baseType: !58)
!58 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!59 = !DILocation(line: 0, scope: !51)
!60 = !DILocation(line: 718, column: 12, scope: !51)
!61 = distinct !{!61, !55, !62}
!62 = !DILocation(line: 718, column: 41, scope: !51)
