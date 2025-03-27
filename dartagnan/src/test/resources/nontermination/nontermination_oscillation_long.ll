; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_oscillation_long.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_oscillation_long.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@x = global i32 0, align 4, !dbg !0

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !21 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = call i32 bitcast (i32 (...)* @__VERIFIER_loop_bound to i32 (i32)*)(i32 noundef 11), !dbg !25
  br label %3, !dbg !26

3:                                                ; preds = %6, %0
  %4 = load atomic i32, i32* @x seq_cst, align 4, !dbg !27
  %5 = icmp slt i32 %4, 10, !dbg !28
  br i1 %5, label %6, label %10, !dbg !26

6:                                                ; preds = %3
  %7 = load atomic i32, i32* @x seq_cst, align 4, !dbg !29
  %8 = add nsw i32 %7, 1, !dbg !31
  %9 = srem i32 %8, 10, !dbg !32
  store atomic i32 %9, i32* @x seq_cst, align 4, !dbg !33
  br label %3, !dbg !26, !llvm.loop !34

10:                                               ; preds = %3
  ret i32 0, !dbg !37
}

declare i32 @__VERIFIER_loop_bound(...) #1

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!10, !11, !12, !13, !14, !15, !16, !17, !18, !19}
!llvm.ident = !{!20}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !5, line: 11, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/nontermination_oscillation_long.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!0}
!5 = !DIFile(filename: "benchmarks/nontermination/nontermination_oscillation_long.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !7, line: 92, baseType: !8)
!7 = !DIFile(filename: "/opt/homebrew/Cellar/llvm@14/14.0.6/lib/clang/14.0.6/include/stdatomic.h", directory: "")
!8 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !9)
!9 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!10 = !{i32 7, !"Dwarf Version", i32 4}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = !{i32 1, !"branch-target-enforcement", i32 0}
!14 = !{i32 1, !"sign-return-address", i32 0}
!15 = !{i32 1, !"sign-return-address-all", i32 0}
!16 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!17 = !{i32 7, !"PIC Level", i32 2}
!18 = !{i32 7, !"uwtable", i32 1}
!19 = !{i32 7, !"frame-pointer", i32 1}
!20 = !{!"Homebrew clang version 14.0.6"}
!21 = distinct !DISubprogram(name: "main", scope: !5, file: !5, line: 13, type: !22, scopeLine: 14, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!22 = !DISubroutineType(types: !23)
!23 = !{!9}
!24 = !{}
!25 = !DILocation(line: 15, column: 5, scope: !21)
!26 = !DILocation(line: 16, column: 5, scope: !21)
!27 = !DILocation(line: 16, column: 12, scope: !21)
!28 = !DILocation(line: 16, column: 14, scope: !21)
!29 = !DILocation(line: 17, column: 14, scope: !30)
!30 = distinct !DILexicalBlock(scope: !21, file: !5, line: 16, column: 19)
!31 = !DILocation(line: 17, column: 16, scope: !30)
!32 = !DILocation(line: 17, column: 21, scope: !30)
!33 = !DILocation(line: 17, column: 11, scope: !30)
!34 = distinct !{!34, !26, !35, !36}
!35 = !DILocation(line: 18, column: 5, scope: !21)
!36 = !{!"llvm.loop.mustprogress"}
!37 = !DILocation(line: 19, column: 5, scope: !21)
