; ModuleID = '/home/ponce/git/Dat3M/output/45_monabsex1_vs.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/45_monabsex1_vs.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"45_monabsex1_vs.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@s = dso_local global i32 0, align 4, !dbg !0

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !15 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.1, i64 0, i64 0), i32 noundef 6, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !19
  unreachable, !dbg !19
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thr1(i8* noundef %0) #0 !dbg !22 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !26, metadata !DIExpression()), !dbg !27
  %2 = call i32 @__VERIFIER_nondet_int() #7, !dbg !28
  call void @llvm.dbg.value(metadata i32 %2, metadata !29, metadata !DIExpression()), !dbg !27
  call void @llvm.dbg.value(metadata i32 4, metadata !29, metadata !DIExpression()), !dbg !27
  call void @__VERIFIER_atomic_begin() #7, !dbg !30
  store i32 4, i32* @s, align 4, !dbg !31
  call void @__VERIFIER_atomic_end() #7, !dbg !32
  call void @__VERIFIER_atomic_begin() #7, !dbg !33
  %3 = load i32, i32* @s, align 4, !dbg !34
  %4 = icmp eq i32 %3, 4, !dbg !37
  br i1 %4, label %6, label %5, !dbg !38

5:                                                ; preds = %1
  call void @llvm.dbg.label(metadata !39), !dbg !41
  call void @reach_error(), !dbg !42
  call void @abort() #8, !dbg !44
  unreachable, !dbg !44

6:                                                ; preds = %1
  call void @__VERIFIER_atomic_end() #7, !dbg !45
  ret i8* null, !dbg !46
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

declare i32 @__VERIFIER_nondet_int() #3

declare void @__VERIFIER_atomic_begin() #3

declare void @__VERIFIER_atomic_end() #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: noreturn
declare void @abort() #4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !47 {
  %1 = alloca i64, align 8
  %2 = call i32 @__VERIFIER_nondet_int() #7, !dbg !50
  store i32 %2, i32* @s, align 4, !dbg !51
  br label %3, !dbg !52

3:                                                ; preds = %3, %0
  call void @llvm.dbg.value(metadata i64* %1, metadata !53, metadata !DIExpression(DW_OP_deref)), !dbg !56
  %4 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thr1, i8* noundef null) #7, !dbg !57
  br label %3, !dbg !52, !llvm.loop !58
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
!llvm.module.flags = !{!7, !8, !9, !10, !11, !12, !13}
!llvm.ident = !{!14}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !5, line: 701, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/45_monabsex1_vs.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "1c7b97d82de0e996ea13b7c937d5d700")
!4 = !{!0}
!5 = !DIFile(filename: "../sv-benchmarks/c/pthread-ext/45_monabsex1_vs.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "1c7b97d82de0e996ea13b7c937d5d700")
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !{i32 7, !"Dwarf Version", i32 5}
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = !{i32 1, !"wchar_size", i32 4}
!10 = !{i32 7, !"PIC Level", i32 2}
!11 = !{i32 7, !"PIE Level", i32 2}
!12 = !{i32 7, !"uwtable", i32 1}
!13 = !{i32 7, !"frame-pointer", i32 2}
!14 = !{!"Ubuntu clang version 14.0.6"}
!15 = distinct !DISubprogram(name: "reach_error", scope: !5, file: !5, line: 15, type: !16, scopeLine: 15, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !18)
!16 = !DISubroutineType(types: !17)
!17 = !{null}
!18 = !{}
!19 = !DILocation(line: 15, column: 83, scope: !20)
!20 = distinct !DILexicalBlock(scope: !21, file: !5, line: 15, column: 73)
!21 = distinct !DILexicalBlock(scope: !15, file: !5, line: 15, column: 67)
!22 = distinct !DISubprogram(name: "thr1", scope: !5, file: !5, line: 702, type: !23, scopeLine: 703, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !18)
!23 = !DISubroutineType(types: !24)
!24 = !{!25, !25}
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!26 = !DILocalVariable(name: "arg", arg: 1, scope: !22, file: !5, line: 702, type: !25)
!27 = !DILocation(line: 0, scope: !22)
!28 = !DILocation(line: 704, column: 13, scope: !22)
!29 = !DILocalVariable(name: "l", scope: !22, file: !5, line: 704, type: !6)
!30 = !DILocation(line: 706, column: 5, scope: !22)
!31 = !DILocation(line: 707, column: 7, scope: !22)
!32 = !DILocation(line: 708, column: 5, scope: !22)
!33 = !DILocation(line: 709, column: 5, scope: !22)
!34 = !DILocation(line: 710, column: 12, scope: !35)
!35 = distinct !DILexicalBlock(scope: !36, file: !5, line: 710, column: 10)
!36 = distinct !DILexicalBlock(scope: !22, file: !5, line: 710, column: 5)
!37 = !DILocation(line: 710, column: 14, scope: !35)
!38 = !DILocation(line: 710, column: 10, scope: !36)
!39 = !DILabel(scope: !40, name: "ERROR", file: !5, line: 710)
!40 = distinct !DILexicalBlock(scope: !35, file: !5, line: 710, column: 21)
!41 = !DILocation(line: 710, column: 23, scope: !40)
!42 = !DILocation(line: 710, column: 31, scope: !43)
!43 = distinct !DILexicalBlock(scope: !40, file: !5, line: 710, column: 30)
!44 = !DILocation(line: 710, column: 45, scope: !43)
!45 = !DILocation(line: 711, column: 5, scope: !22)
!46 = !DILocation(line: 712, column: 5, scope: !22)
!47 = distinct !DISubprogram(name: "main", scope: !5, file: !5, line: 714, type: !48, scopeLine: 715, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !18)
!48 = !DISubroutineType(types: !49)
!49 = !{!6}
!50 = !DILocation(line: 716, column: 7, scope: !47)
!51 = !DILocation(line: 716, column: 5, scope: !47)
!52 = !DILocation(line: 718, column: 3, scope: !47)
!53 = !DILocalVariable(name: "t", scope: !47, file: !5, line: 717, type: !54)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !5, line: 297, baseType: !55)
!55 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!56 = !DILocation(line: 0, scope: !47)
!57 = !DILocation(line: 718, column: 12, scope: !47)
!58 = distinct !{!58, !52, !59}
!59 = !DILocation(line: 718, column: 41, scope: !47)
