; ModuleID = 'benchmarks/mem-safety/ilp32-malloc-not-executed.c'
source_filename = "benchmarks/mem-safety/ilp32-malloc-not-executed.c"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@g = dso_local global ptr null, align 4, !dbg !0

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !17 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 4
  store i32 0, ptr %1, align 4
  %3 = call i32 @__VERIFIER_nondet_int(), !dbg !22
  %4 = icmp ne i32 %3, 0, !dbg !22
  br i1 %4, label %5, label %7, !dbg !22

5:                                                ; preds = %0
  %6 = call ptr @malloc(i32 noundef 2147483647) #3, !dbg !24
  store ptr %6, ptr @g, align 4, !dbg !26
  br label %14, !dbg !27

7:                                                ; preds = %0
    #dbg_declare(ptr %2, !28, !DIExpression(), !30)
  %8 = call ptr @malloc(i32 noundef 2147483647) #3, !dbg !31
  store ptr %8, ptr %2, align 4, !dbg !30
  %9 = load ptr, ptr %2, align 4, !dbg !32
  %10 = icmp ne ptr %9, null, !dbg !34
  br i1 %10, label %11, label %13, !dbg !34

11:                                               ; preds = %7
  %12 = load ptr, ptr %2, align 4, !dbg !35
  store i8 1, ptr %12, align 1, !dbg !37
  br label %13, !dbg !38

13:                                               ; preds = %11, %7
  br label %14

14:                                               ; preds = %13, %5
  ret i32 0, !dbg !39
}

declare i32 @__VERIFIER_nondet_int() #1

; Function Attrs: allocsize(0)
declare ptr @malloc(i32 noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { allocsize(0) }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g", scope: !2, file: !3, line: 19, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/mem-safety/ilp32-malloc-not-executed.c", directory: ".", checksumkind: CSK_MD5, checksum: "638d60bd6cdf3ee2f454283366641bd4")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!6 = !{!0}
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 32)
!8 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!9 = !{i32 1, !"NumRegisterParameters", i32 0}
!10 = !{i32 7, !"Dwarf Version", i32 5}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 8, !"PIC Level", i32 2}
!13 = !{i32 7, !"PIE Level", i32 2}
!14 = !{i32 7, !"uwtable", i32 2}
!15 = !{i32 7, !"frame-pointer", i32 2}
!16 = !{!"Homebrew clang version 23.1.3"}
!17 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 21, type: !18, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !21)
!18 = !DISubroutineType(types: !19)
!19 = !{!20}
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !{}
!22 = !DILocation(line: 22, column: 9, scope: !23)
!23 = distinct !DILexicalBlock(scope: !17, file: !3, line: 22, column: 9)
!24 = !DILocation(line: 23, column: 13, scope: !25)
!25 = distinct !DILexicalBlock(scope: !23, file: !3, line: 22, column: 34)
!26 = !DILocation(line: 23, column: 11, scope: !25)
!27 = !DILocation(line: 24, column: 5, scope: !25)
!28 = !DILocalVariable(name: "p", scope: !29, file: !3, line: 25, type: !7)
!29 = distinct !DILexicalBlock(scope: !23, file: !3, line: 24, column: 12)
!30 = !DILocation(line: 25, column: 15, scope: !29)
!31 = !DILocation(line: 25, column: 19, scope: !29)
!32 = !DILocation(line: 29, column: 13, scope: !33)
!33 = distinct !DILexicalBlock(scope: !29, file: !3, line: 29, column: 13)
!34 = !DILocation(line: 29, column: 15, scope: !33)
!35 = !DILocation(line: 30, column: 14, scope: !36)
!36 = distinct !DILexicalBlock(scope: !33, file: !3, line: 29, column: 24)
!37 = !DILocation(line: 30, column: 16, scope: !36)
!38 = !DILocation(line: 31, column: 9, scope: !36)
!39 = !DILocation(line: 33, column: 5, scope: !17)
