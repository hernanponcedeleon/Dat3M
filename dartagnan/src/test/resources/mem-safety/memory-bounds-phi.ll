; ModuleID = 'benchmarks/mem-safety/memory-bounds-phi.c'
source_filename = "benchmarks/mem-safety/memory-bounds-phi.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !9 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !14, !DIExpression(), !16)
  %5 = call ptr @malloc(i64 noundef 16) #3, !dbg !17
  store ptr %5, ptr %2, align 8, !dbg !16
    #dbg_declare(ptr %3, !18, !DIExpression(), !19)
  %6 = call ptr @malloc(i64 noundef 16) #3, !dbg !20
  store ptr %6, ptr %3, align 8, !dbg !19
  %7 = load ptr, ptr %2, align 8, !dbg !21
  %8 = icmp eq ptr %7, null, !dbg !23
  br i1 %8, label %12, label %9, !dbg !24

9:                                                ; preds = %0
  %10 = load ptr, ptr %3, align 8, !dbg !25
  %11 = icmp eq ptr %10, null, !dbg !26
  br i1 %11, label %12, label %13, !dbg !24

12:                                               ; preds = %9, %0
  store i32 0, ptr %1, align 4, !dbg !27
  br label %23, !dbg !27

13:                                               ; preds = %9
    #dbg_declare(ptr %4, !28, !DIExpression(), !29)
  %14 = call i32 @__VERIFIER_nondet_int(), !dbg !30
  %15 = icmp ne i32 %14, 0, !dbg !30
  br i1 %15, label %16, label %18, !dbg !30

16:                                               ; preds = %13
  %17 = load ptr, ptr %2, align 8, !dbg !32
  store ptr %17, ptr %4, align 8, !dbg !34
  br label %20, !dbg !35

18:                                               ; preds = %13
  %19 = load ptr, ptr %3, align 8, !dbg !36
  store ptr %19, ptr %4, align 8, !dbg !38
  br label %20

20:                                               ; preds = %18, %16
  %21 = load ptr, ptr %4, align 8, !dbg !39
  %22 = getelementptr inbounds i32, ptr %21, i64 3, !dbg !39
  store i32 1, ptr %22, align 4, !dbg !40
  store i32 0, ptr %1, align 4, !dbg !41
  br label %23, !dbg !41

23:                                               ; preds = %20, %12
  %24 = load i32, ptr %1, align 4, !dbg !42
  ret i32 %24, !dbg !42
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

declare i32 @__VERIFIER_nondet_int() #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { allocsize(0) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "benchmarks/mem-safety/memory-bounds-phi.c", directory: ".", checksumkind: CSK_MD5, checksum: "c54dbb4d2e02e634a67db62d9d67db6b")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 8, !"PIC Level", i32 2}
!5 = !{i32 7, !"PIE Level", i32 2}
!6 = !{i32 7, !"uwtable", i32 2}
!7 = !{i32 7, !"frame-pointer", i32 2}
!8 = !{!"Homebrew clang version 23.1.3"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 21, type: !10, scopeLine: 21, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !13)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !{}
!14 = !DILocalVariable(name: "a", scope: !9, file: !1, line: 22, type: !15)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!16 = !DILocation(line: 22, column: 10, scope: !9)
!17 = !DILocation(line: 22, column: 14, scope: !9)
!18 = !DILocalVariable(name: "b", scope: !9, file: !1, line: 23, type: !15)
!19 = !DILocation(line: 23, column: 10, scope: !9)
!20 = !DILocation(line: 23, column: 14, scope: !9)
!21 = !DILocation(line: 24, column: 9, scope: !22)
!22 = distinct !DILexicalBlock(scope: !9, file: !1, line: 24, column: 9)
!23 = !DILocation(line: 24, column: 11, scope: !22)
!24 = !DILocation(line: 24, column: 16, scope: !22)
!25 = !DILocation(line: 24, column: 19, scope: !22)
!26 = !DILocation(line: 24, column: 21, scope: !22)
!27 = !DILocation(line: 24, column: 27, scope: !22)
!28 = !DILocalVariable(name: "p", scope: !9, file: !1, line: 25, type: !15)
!29 = !DILocation(line: 25, column: 10, scope: !9)
!30 = !DILocation(line: 26, column: 9, scope: !31)
!31 = distinct !DILexicalBlock(scope: !9, file: !1, line: 26, column: 9)
!32 = !DILocation(line: 27, column: 13, scope: !33)
!33 = distinct !DILexicalBlock(scope: !31, file: !1, line: 26, column: 34)
!34 = !DILocation(line: 27, column: 11, scope: !33)
!35 = !DILocation(line: 28, column: 5, scope: !33)
!36 = !DILocation(line: 29, column: 13, scope: !37)
!37 = distinct !DILexicalBlock(scope: !31, file: !1, line: 28, column: 12)
!38 = !DILocation(line: 29, column: 11, scope: !37)
!39 = !DILocation(line: 31, column: 5, scope: !9)
!40 = !DILocation(line: 31, column: 14, scope: !9)
!41 = !DILocation(line: 32, column: 5, scope: !9)
!42 = !DILocation(line: 33, column: 1, scope: !9)
