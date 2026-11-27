; ModuleID = 'benchmarks/miscellaneous/calloc_huge_size.c'
source_filename = "benchmarks/miscellaneous/calloc_huge_size.c"
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
  %6 = icmp sle i32 0, %5, !dbg !18
  br i1 %6, label %7, label %10, !dbg !19

7:                                                ; preds = %0
  %8 = load i32, ptr %2, align 4, !dbg !20
  %9 = icmp slt i32 %8, 4, !dbg !21
  br label %10

10:                                               ; preds = %7, %0
  %11 = phi i1 [ false, %0 ], [ %9, %7 ], !dbg !22
  %12 = zext i1 %11 to i32, !dbg !19
  call void @__VERIFIER_assume(i32 noundef %12), !dbg !23
    #dbg_declare(ptr %3, !24, !DIExpression(), !27)
  %13 = call ptr @calloc(i64 noundef 1099511627776, i64 noundef 1) #3, !dbg !28
  store ptr %13, ptr %3, align 8, !dbg !27
  %14 = load ptr, ptr %3, align 8, !dbg !29
  %15 = icmp eq ptr %14, null, !dbg !31
  br i1 %15, label %16, label %17, !dbg !31

16:                                               ; preds = %10
  store i32 0, ptr %1, align 4, !dbg !32
  br label %26, !dbg !32

17:                                               ; preds = %10
  %18 = load ptr, ptr %3, align 8, !dbg !34
  %19 = load i32, ptr %2, align 4, !dbg !35
  %20 = sext i32 %19 to i64, !dbg !34
  %21 = getelementptr inbounds i8, ptr %18, i64 %20, !dbg !34
  %22 = load i8, ptr %21, align 1, !dbg !34
  %23 = sext i8 %22 to i32, !dbg !34
  %24 = icmp ne i32 %23, 0, !dbg !36
  %25 = zext i1 %24 to i32, !dbg !36
  call void @__VERIFIER_assert(i32 noundef %25), !dbg !37
  store i32 0, ptr %1, align 4, !dbg !38
  br label %26, !dbg !38

26:                                               ; preds = %17, %16
  %27 = load i32, ptr %1, align 4, !dbg !39
  ret i32 %27, !dbg !39
}

declare i32 @__VERIFIER_nondet_int() #1

declare void @__VERIFIER_assume(i32 noundef) #1

; Function Attrs: allocsize(0,1)
declare ptr @calloc(i64 noundef, i64 noundef) #2

declare void @__VERIFIER_assert(i32 noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { allocsize(0,1) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { allocsize(0,1) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "benchmarks/miscellaneous/calloc_huge_size.c", directory: "/private/tmp/claude-501/-Users-hponcedeleon-git-agent-1-Dat3M/fc305c8d-57d3-4ea0-9fd6-8c627a6b7650/scratchpad/regr2", checksumkind: CSK_MD5, checksum: "e80f4a7e7737f95351dc17207ddc2c5e")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 8, !"PIC Level", i32 2}
!5 = !{i32 7, !"PIE Level", i32 2}
!6 = !{i32 7, !"uwtable", i32 2}
!7 = !{i32 7, !"frame-pointer", i32 2}
!8 = !{!"Homebrew clang version 23.1.0"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 14, type: !10, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !13)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !{}
!14 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 15, type: !12)
!15 = !DILocation(line: 15, column: 9, scope: !9)
!16 = !DILocation(line: 15, column: 13, scope: !9)
!17 = !DILocation(line: 16, column: 28, scope: !9)
!18 = !DILocation(line: 16, column: 25, scope: !9)
!19 = !DILocation(line: 16, column: 30, scope: !9)
!20 = !DILocation(line: 16, column: 33, scope: !9)
!21 = !DILocation(line: 16, column: 35, scope: !9)
!22 = !DILocation(line: 0, scope: !9)
!23 = !DILocation(line: 16, column: 5, scope: !9)
!24 = !DILocalVariable(name: "p", scope: !9, file: !1, line: 18, type: !25)
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!26 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!27 = !DILocation(line: 18, column: 11, scope: !9)
!28 = !DILocation(line: 18, column: 15, scope: !9)
!29 = !DILocation(line: 19, column: 9, scope: !30)
!30 = distinct !DILexicalBlock(scope: !9, file: !1, line: 19, column: 9)
!31 = !DILocation(line: 19, column: 11, scope: !30)
!32 = !DILocation(line: 20, column: 9, scope: !33)
!33 = distinct !DILexicalBlock(scope: !30, file: !1, line: 19, column: 17)
!34 = !DILocation(line: 23, column: 23, scope: !9)
!35 = !DILocation(line: 23, column: 25, scope: !9)
!36 = !DILocation(line: 23, column: 28, scope: !9)
!37 = !DILocation(line: 23, column: 5, scope: !9)
!38 = !DILocation(line: 27, column: 5, scope: !9)
!39 = !DILocation(line: 28, column: 1, scope: !9)
