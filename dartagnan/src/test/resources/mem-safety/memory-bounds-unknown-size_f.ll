; ModuleID = 'benchmarks/mem-safety/memory-bounds-unknown-size.c'
source_filename = "benchmarks/mem-safety/memory-bounds-unknown-size.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !9 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !14, !DIExpression(), !15)
  %4 = call i32 @__VERIFIER_nondet_int(), !dbg !16
  store i32 %4, ptr %2, align 4, !dbg !15
  %5 = load i32, ptr %2, align 4, !dbg !17
  %6 = icmp sle i32 %5, 0, !dbg !19
  br i1 %6, label %10, label %7, !dbg !20

7:                                                ; preds = %0
  %8 = load i32, ptr %2, align 4, !dbg !21
  %9 = icmp sgt i32 %8, 8, !dbg !22
  br i1 %9, label %10, label %11, !dbg !20

10:                                               ; preds = %7, %0
  store i32 0, ptr %1, align 4, !dbg !23
  br label %25, !dbg !23

11:                                               ; preds = %7
    #dbg_declare(ptr %3, !24, !DIExpression(), !26)
  %12 = load i32, ptr %2, align 4, !dbg !27
  %13 = sext i32 %12 to i64, !dbg !27
  %14 = mul i64 %13, 4, !dbg !28
  %15 = call ptr @malloc(i64 noundef %14) #3, !dbg !29
  store ptr %15, ptr %3, align 8, !dbg !26
  %16 = load ptr, ptr %3, align 8, !dbg !30
  %17 = icmp eq ptr %16, null, !dbg !32
  br i1 %17, label %18, label %19, !dbg !32

18:                                               ; preds = %11
  store i32 0, ptr %1, align 4, !dbg !33
  br label %25, !dbg !33

19:                                               ; preds = %11
  %20 = load ptr, ptr %3, align 8, !dbg !34
  %21 = load i32, ptr %2, align 4, !dbg !35
  %22 = sub nsw i32 %21, 0, !dbg !36
  %23 = sext i32 %22 to i64, !dbg !34
  %24 = getelementptr inbounds i32, ptr %20, i64 %23, !dbg !34
  store i32 1, ptr %24, align 4, !dbg !37
  store i32 0, ptr %1, align 4, !dbg !38
  br label %25, !dbg !38

25:                                               ; preds = %19, %18, %10
  %26 = load i32, ptr %1, align 4, !dbg !39
  ret i32 %26, !dbg !39
}

declare i32 @__VERIFIER_nondet_int() #1

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { allocsize(0) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "benchmarks/mem-safety/memory-bounds-unknown-size.c", directory: ".", checksumkind: CSK_MD5, checksum: "da8ecfc2190162a8d32d3977df8041db")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 8, !"PIC Level", i32 2}
!5 = !{i32 7, !"PIE Level", i32 2}
!6 = !{i32 7, !"uwtable", i32 2}
!7 = !{i32 7, !"frame-pointer", i32 2}
!8 = !{!"Homebrew clang version 23.1.3"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 20, type: !10, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !13)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !{}
!14 = !DILocalVariable(name: "n", scope: !9, file: !1, line: 21, type: !12)
!15 = !DILocation(line: 21, column: 9, scope: !9)
!16 = !DILocation(line: 21, column: 13, scope: !9)
!17 = !DILocation(line: 22, column: 9, scope: !18)
!18 = distinct !DILexicalBlock(scope: !9, file: !1, line: 22, column: 9)
!19 = !DILocation(line: 22, column: 11, scope: !18)
!20 = !DILocation(line: 22, column: 16, scope: !18)
!21 = !DILocation(line: 22, column: 19, scope: !18)
!22 = !DILocation(line: 22, column: 21, scope: !18)
!23 = !DILocation(line: 22, column: 26, scope: !18)
!24 = !DILocalVariable(name: "p", scope: !9, file: !1, line: 23, type: !25)
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!26 = !DILocation(line: 23, column: 10, scope: !9)
!27 = !DILocation(line: 23, column: 21, scope: !9)
!28 = !DILocation(line: 23, column: 23, scope: !9)
!29 = !DILocation(line: 23, column: 14, scope: !9)
!30 = !DILocation(line: 24, column: 9, scope: !31)
!31 = distinct !DILexicalBlock(scope: !9, file: !1, line: 24, column: 9)
!32 = !DILocation(line: 24, column: 11, scope: !31)
!33 = !DILocation(line: 24, column: 17, scope: !31)
!34 = !DILocation(line: 25, column: 5, scope: !9)
!35 = !DILocation(line: 25, column: 7, scope: !9)
!36 = !DILocation(line: 25, column: 9, scope: !9)
!37 = !DILocation(line: 25, column: 19, scope: !9)
!38 = !DILocation(line: 26, column: 5, scope: !9)
!39 = !DILocation(line: 27, column: 1, scope: !9)
