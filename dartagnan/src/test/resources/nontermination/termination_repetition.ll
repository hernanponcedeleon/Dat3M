; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/termination_repetition.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/termination_repetition.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@x = global i32 0, align 4, !dbg !0
@flag = global i32 0, align 4, !dbg !5

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !23 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = call i32 bitcast (i32 (...)* @__VERIFIER_loop_bound to i32 (i32)*)(i32 noundef 3), !dbg !27
  br label %3, !dbg !28

3:                                                ; preds = %0, %13
  %4 = load atomic i32, i32* @flag seq_cst, align 4, !dbg !29
  %5 = icmp ne i32 %4, 0, !dbg !29
  br i1 %5, label %7, label %6, !dbg !32

6:                                                ; preds = %3
  store atomic i32 1, i32* @flag seq_cst, align 4, !dbg !33
  br label %13, !dbg !35

7:                                                ; preds = %3
  %8 = atomicrmw add i32* @x, i32 1 seq_cst, align 4, !dbg !36
  %9 = add i32 %8, 1, !dbg !36
  %10 = icmp eq i32 %9, 2, !dbg !39
  br i1 %10, label %11, label %12, !dbg !40

11:                                               ; preds = %7
  br label %14, !dbg !41

12:                                               ; preds = %7
  store atomic i32 0, i32* @flag seq_cst, align 4, !dbg !43
  br label %13

13:                                               ; preds = %12, %6
  br label %3, !dbg !28, !llvm.loop !44

14:                                               ; preds = %11
  ret i32 0, !dbg !46
}

declare i32 @__VERIFIER_loop_bound(...) #1

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14, !15, !16, !17, !18, !19, !20, !21}
!llvm.ident = !{!22}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !7, line: 13, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/nontermination/termination_repetition.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!0, !5}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "flag", scope: !2, file: !7, line: 14, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "benchmarks/nontermination/termination_repetition.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !9, line: 92, baseType: !10)
!9 = !DIFile(filename: "/opt/homebrew/Cellar/llvm@14/14.0.6/lib/clang/14.0.6/include/stdatomic.h", directory: "")
!10 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !11)
!11 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!12 = !{i32 7, !"Dwarf Version", i32 4}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{i32 1, !"wchar_size", i32 4}
!15 = !{i32 1, !"branch-target-enforcement", i32 0}
!16 = !{i32 1, !"sign-return-address", i32 0}
!17 = !{i32 1, !"sign-return-address-all", i32 0}
!18 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!19 = !{i32 7, !"PIC Level", i32 2}
!20 = !{i32 7, !"uwtable", i32 1}
!21 = !{i32 7, !"frame-pointer", i32 1}
!22 = !{!"Homebrew clang version 14.0.6"}
!23 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 16, type: !24, scopeLine: 17, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !26)
!24 = !DISubroutineType(types: !25)
!25 = !{!11}
!26 = !{}
!27 = !DILocation(line: 18, column: 5, scope: !23)
!28 = !DILocation(line: 19, column: 5, scope: !23)
!29 = !DILocation(line: 20, column: 14, scope: !30)
!30 = distinct !DILexicalBlock(scope: !31, file: !7, line: 20, column: 13)
!31 = distinct !DILexicalBlock(scope: !23, file: !7, line: 19, column: 14)
!32 = !DILocation(line: 20, column: 13, scope: !31)
!33 = !DILocation(line: 21, column: 18, scope: !34)
!34 = distinct !DILexicalBlock(scope: !30, file: !7, line: 20, column: 20)
!35 = !DILocation(line: 22, column: 9, scope: !34)
!36 = !DILocation(line: 23, column: 18, scope: !37)
!37 = distinct !DILexicalBlock(scope: !38, file: !7, line: 23, column: 17)
!38 = distinct !DILexicalBlock(scope: !30, file: !7, line: 22, column: 16)
!39 = !DILocation(line: 23, column: 23, scope: !37)
!40 = !DILocation(line: 23, column: 17, scope: !38)
!41 = !DILocation(line: 23, column: 31, scope: !42)
!42 = distinct !DILexicalBlock(scope: !37, file: !7, line: 23, column: 29)
!43 = !DILocation(line: 24, column: 18, scope: !38)
!44 = distinct !{!44, !28, !45}
!45 = !DILocation(line: 26, column: 5, scope: !23)
!46 = !DILocation(line: 27, column: 5, scope: !23)
