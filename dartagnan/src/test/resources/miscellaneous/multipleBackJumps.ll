; ModuleID = '/home/ponce/git/Dat3M/output/multipleBackJumps.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/multipleBackJumps.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !7 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !12, metadata !DIExpression()), !dbg !13
  %3 = call i32 @__VERIFIER_nondet_int(), !dbg !14
  store i32 %3, i32* %2, align 4, !dbg !13
  br label %4, !dbg !15

4:                                                ; preds = %14, %11, %0
  call void @llvm.dbg.label(metadata !16), !dbg !17
  %5 = load i32, i32* %2, align 4, !dbg !18
  %6 = icmp eq i32 %5, 0, !dbg !20
  br i1 %6, label %7, label %8, !dbg !21

7:                                                ; preds = %4
  ret i32 0, !dbg !22

8:                                                ; preds = %4
  %9 = load i32, i32* %2, align 4, !dbg !24
  %10 = icmp slt i32 %9, 0, !dbg !26
  br i1 %10, label %11, label %14, !dbg !27

11:                                               ; preds = %8
  %12 = load i32, i32* %2, align 4, !dbg !28
  %13 = add nsw i32 %12, 1, !dbg !28
  store i32 %13, i32* %2, align 4, !dbg !28
  br label %4, !dbg !30

14:                                               ; preds = %8
  %15 = load i32, i32* %2, align 4, !dbg !31
  %16 = add nsw i32 %15, -1, !dbg !31
  store i32 %16, i32* %2, align 4, !dbg !31
  br label %4, !dbg !33
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @__VERIFIER_nondet_int() #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

attributes #0 = { noinline nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 12.0.0-3ubuntu1~20.04.5", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/multipleBackJumps.c", directory: "/home/ponce/git/Dat3M")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"}
!7 = distinct !DISubprogram(name: "main", scope: !8, file: !8, line: 5, type: !9, scopeLine: 6, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DIFile(filename: "benchmarks/c/miscellaneous/multipleBackJumps.c", directory: "/home/ponce/git/Dat3M")
!9 = !DISubroutineType(types: !10)
!10 = !{!11}
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !DILocalVariable(name: "x", scope: !7, file: !8, line: 7, type: !11)
!13 = !DILocation(line: 7, column: 9, scope: !7)
!14 = !DILocation(line: 7, column: 13, scope: !7)
!15 = !DILocation(line: 7, column: 5, scope: !7)
!16 = !DILabel(scope: !7, name: "head", file: !8, line: 8)
!17 = !DILocation(line: 8, column: 1, scope: !7)
!18 = !DILocation(line: 9, column: 8, scope: !19)
!19 = distinct !DILexicalBlock(scope: !7, file: !8, line: 9, column: 8)
!20 = !DILocation(line: 9, column: 10, scope: !19)
!21 = !DILocation(line: 9, column: 8, scope: !7)
!22 = !DILocation(line: 10, column: 6, scope: !23)
!23 = distinct !DILexicalBlock(scope: !19, file: !8, line: 9, column: 16)
!24 = !DILocation(line: 12, column: 8, scope: !25)
!25 = distinct !DILexicalBlock(scope: !7, file: !8, line: 12, column: 8)
!26 = !DILocation(line: 12, column: 10, scope: !25)
!27 = !DILocation(line: 12, column: 8, scope: !7)
!28 = !DILocation(line: 13, column: 10, scope: !29)
!29 = distinct !DILexicalBlock(scope: !25, file: !8, line: 12, column: 15)
!30 = !DILocation(line: 14, column: 9, scope: !29)
!31 = !DILocation(line: 16, column: 10, scope: !32)
!32 = distinct !DILexicalBlock(scope: !25, file: !8, line: 15, column: 12)
!33 = !DILocation(line: 17, column: 9, scope: !32)
