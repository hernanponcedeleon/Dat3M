; ModuleID = '/home/ponce/git/Dat3M/output/nondet_loop.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/nondet_loop.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [63 x i8] c"/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/nondet_loop.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !10 {
  call void @llvm.dbg.value(metadata i32 0, metadata !16, metadata !DIExpression()), !dbg !17
  call void @__VERIFIER_loop_bound(i32 noundef 3) #4, !dbg !18
  br label %1, !dbg !19

1:                                                ; preds = %2, %0
  %.0 = phi i32 [ 0, %0 ], [ %.1, %2 ], !dbg !17
  call void @llvm.dbg.value(metadata i32 %.0, metadata !16, metadata !DIExpression()), !dbg !17
  %.not = icmp eq i32 %.0, 5, !dbg !20
  br i1 %.not, label %5, label %2, !dbg !19

2:                                                ; preds = %1
  %3 = call i32 @__VERIFIER_nondet_int() #4, !dbg !21
  %4 = icmp eq i32 %3, 0, !dbg !24
  %.1.v = select i1 %4, i32 2, i32 3, !dbg !25
  %.1 = add nuw nsw i32 %.0, %.1.v, !dbg !25
  call void @llvm.dbg.value(metadata i32 %.1, metadata !16, metadata !DIExpression()), !dbg !17
  br label %1, !dbg !19, !llvm.loop !26

5:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 16, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !29
  unreachable, !dbg !29
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__VERIFIER_loop_bound(i32 noundef) #2

declare i32 @__VERIFIER_nondet_int() #2

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { noreturn nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/nondet_loop.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "8d566d65a8593a16b6f5f84fe428c0db")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Ubuntu clang version 14.0.6"}
!10 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 5, type: !12, scopeLine: 6, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!11 = !DIFile(filename: "benchmarks/c/miscellaneous/nondet_loop.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "8d566d65a8593a16b6f5f84fe428c0db")
!12 = !DISubroutineType(types: !13)
!13 = !{!14}
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !{}
!16 = !DILocalVariable(name: "x", scope: !10, file: !11, line: 7, type: !14)
!17 = !DILocation(line: 0, scope: !10)
!18 = !DILocation(line: 8, column: 5, scope: !10)
!19 = !DILocation(line: 9, column: 5, scope: !10)
!20 = !DILocation(line: 9, column: 14, scope: !10)
!21 = !DILocation(line: 10, column: 13, scope: !22)
!22 = distinct !DILexicalBlock(scope: !23, file: !11, line: 10, column: 13)
!23 = distinct !DILexicalBlock(scope: !10, file: !11, line: 9, column: 20)
!24 = !DILocation(line: 10, column: 37, scope: !22)
!25 = !DILocation(line: 10, column: 13, scope: !23)
!26 = distinct !{!26, !19, !27, !28}
!27 = !DILocation(line: 15, column: 5, scope: !10)
!28 = !{!"llvm.loop.mustprogress"}
!29 = !DILocation(line: 16, column: 5, scope: !30)
!30 = distinct !DILexicalBlock(scope: !31, file: !11, line: 16, column: 5)
!31 = distinct !DILexicalBlock(scope: !10, file: !11, line: 16, column: 5)
