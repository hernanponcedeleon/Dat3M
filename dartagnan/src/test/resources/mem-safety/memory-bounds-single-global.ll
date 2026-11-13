; ModuleID = 'benchmarks/mem-safety/memory-bounds-single-global.c'
source_filename = "benchmarks/mem-safety/memory-bounds-single-global.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local global [4 x i32] zeroinitializer, align 16, !dbg !0

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !16 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !20, !DIExpression(), !21)
  %4 = call i32 @__VERIFIER_nondet_int(), !dbg !22
  store i32 %4, ptr %2, align 4, !dbg !21
  %5 = load i32, ptr %2, align 4, !dbg !23
  %6 = icmp slt i32 %5, 0, !dbg !25
  br i1 %6, label %10, label %7, !dbg !26

7:                                                ; preds = %0
  %8 = load i32, ptr %2, align 4, !dbg !27
  %9 = icmp sgt i32 %8, 3, !dbg !28
  br i1 %9, label %10, label %11, !dbg !26

10:                                               ; preds = %7, %0
  store i32 0, ptr %1, align 4, !dbg !29
  br label %16, !dbg !29

11:                                               ; preds = %7
    #dbg_declare(ptr %3, !30, !DIExpression(), !32)
  store ptr @a, ptr %3, align 8, !dbg !32
  %12 = load ptr, ptr %3, align 8, !dbg !33
  %13 = load i32, ptr %2, align 4, !dbg !34
  %14 = sext i32 %13 to i64, !dbg !33
  %15 = getelementptr inbounds i32, ptr %12, i64 %14, !dbg !33
  store i32 1, ptr %15, align 4, !dbg !35
  store i32 0, ptr %1, align 4, !dbg !36
  br label %16, !dbg !36

16:                                               ; preds = %11, %10
  %17 = load i32, ptr %1, align 4, !dbg !37
  ret i32 %17, !dbg !37
}

declare i32 @__VERIFIER_nondet_int() #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14}
!llvm.ident = !{!15}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 19, type: !5, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/mem-safety/memory-bounds-single-global.c", directory: ".", checksumkind: CSK_MD5, checksum: "ab17c77da1530cf7e7bbc14d7a547bd0")
!4 = !{!0}
!5 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 128, elements: !7)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !{!8}
!8 = !DISubrange(count: 4)
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 8, !"PIC Level", i32 2}
!12 = !{i32 7, !"PIE Level", i32 2}
!13 = !{i32 7, !"uwtable", i32 2}
!14 = !{i32 7, !"frame-pointer", i32 2}
!15 = !{!"Homebrew clang version 23.1.3"}
!16 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 21, type: !17, scopeLine: 21, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !19)
!17 = !DISubroutineType(types: !18)
!18 = !{!6}
!19 = !{}
!20 = !DILocalVariable(name: "i", scope: !16, file: !3, line: 22, type: !6)
!21 = !DILocation(line: 22, column: 9, scope: !16)
!22 = !DILocation(line: 22, column: 13, scope: !16)
!23 = !DILocation(line: 23, column: 9, scope: !24)
!24 = distinct !DILexicalBlock(scope: !16, file: !3, line: 23, column: 9)
!25 = !DILocation(line: 23, column: 11, scope: !24)
!26 = !DILocation(line: 23, column: 15, scope: !24)
!27 = !DILocation(line: 23, column: 18, scope: !24)
!28 = !DILocation(line: 23, column: 20, scope: !24)
!29 = !DILocation(line: 23, column: 29, scope: !24)
!30 = !DILocalVariable(name: "p", scope: !16, file: !3, line: 24, type: !31)
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!32 = !DILocation(line: 24, column: 10, scope: !16)
!33 = !DILocation(line: 25, column: 5, scope: !16)
!34 = !DILocation(line: 25, column: 7, scope: !16)
!35 = !DILocation(line: 25, column: 10, scope: !16)
!36 = !DILocation(line: 26, column: 5, scope: !16)
!37 = !DILocation(line: 27, column: 1, scope: !16)
