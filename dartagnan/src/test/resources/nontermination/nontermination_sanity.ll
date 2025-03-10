; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_sanity.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_sanity.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@x = global i32 0, align 4, !dbg !0

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !18 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !22, metadata !DIExpression()), !dbg !23
  store i32 0, i32* %2, align 4, !dbg !23
  br label %3, !dbg !24

3:                                                ; preds = %0, %3
  %4 = load i32, i32* @x, align 4, !dbg !25
  %5 = add nsw i32 %4, 1, !dbg !25
  store i32 %5, i32* @x, align 4, !dbg !25
  br label %3, !dbg !24, !llvm.loop !27
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!7, !8, !9, !10, !11, !12, !13, !14, !15, !16}
!llvm.ident = !{!17}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !5, line: 12, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_sanity.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!0}
!5 = !DIFile(filename: "benchmarks/nontermination/nontermination_sanity.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !{i32 7, !"Dwarf Version", i32 4}
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = !{i32 1, !"wchar_size", i32 4}
!10 = !{i32 1, !"branch-target-enforcement", i32 0}
!11 = !{i32 1, !"sign-return-address", i32 0}
!12 = !{i32 1, !"sign-return-address-all", i32 0}
!13 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!14 = !{i32 7, !"PIC Level", i32 2}
!15 = !{i32 7, !"uwtable", i32 1}
!16 = !{i32 7, !"frame-pointer", i32 1}
!17 = !{!"Homebrew clang version 14.0.6"}
!18 = distinct !DISubprogram(name: "main", scope: !5, file: !5, line: 14, type: !19, scopeLine: 15, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !21)
!19 = !DISubroutineType(types: !20)
!20 = !{!6}
!21 = !{}
!22 = !DILocalVariable(name: "i", scope: !18, file: !5, line: 16, type: !6)
!23 = !DILocation(line: 16, column: 9, scope: !18)
!24 = !DILocation(line: 17, column: 5, scope: !18)
!25 = !DILocation(line: 19, column: 10, scope: !26)
!26 = distinct !DILexicalBlock(scope: !18, file: !5, line: 17, column: 14)
!27 = distinct !{!27, !24, !28}
!28 = !DILocation(line: 20, column: 5, scope: !18)
