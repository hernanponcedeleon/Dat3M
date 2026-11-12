; ModuleID = 'benchmarks/mem-safety/memory-bounds-uninit-pointer.c'
source_filename = "benchmarks/mem-safety/memory-bounds-uninit-pointer.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !9 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !14, !DIExpression(), !17)
  %4 = call ptr @malloc(i64 noundef 8) #2, !dbg !18
  store ptr %4, ptr %2, align 8, !dbg !17
  %5 = load ptr, ptr %2, align 8, !dbg !19
  %6 = icmp eq ptr %5, null, !dbg !21
  br i1 %6, label %7, label %8, !dbg !21

7:                                                ; preds = %0
  store i32 0, ptr %1, align 4, !dbg !22
  br label %16, !dbg !22

8:                                                ; preds = %0
    #dbg_declare(ptr %3, !23, !DIExpression(), !24)
  %9 = load ptr, ptr %2, align 8, !dbg !25
  %10 = load ptr, ptr %9, align 8, !dbg !26
  store ptr %10, ptr %3, align 8, !dbg !24
  %11 = load ptr, ptr %3, align 8, !dbg !27
  %12 = icmp eq ptr %11, null, !dbg !29
  br i1 %12, label %13, label %14, !dbg !29

13:                                               ; preds = %8
  store i32 0, ptr %1, align 4, !dbg !30
  br label %16, !dbg !30

14:                                               ; preds = %8
  %15 = load ptr, ptr %3, align 8, !dbg !31
  store i32 1, ptr %15, align 4, !dbg !32
  store i32 0, ptr %1, align 4, !dbg !33
  br label %16, !dbg !33

16:                                               ; preds = %14, %13, %7
  %17 = load i32, ptr %1, align 4, !dbg !34
  ret i32 %17, !dbg !34
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { allocsize(0) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "benchmarks/mem-safety/memory-bounds-uninit-pointer.c", directory: ".", checksumkind: CSK_MD5, checksum: "d7da1934b7b7470e2dc234e28ac8677b")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 8, !"PIC Level", i32 2}
!5 = !{i32 7, !"PIE Level", i32 2}
!6 = !{i32 7, !"uwtable", i32 2}
!7 = !{i32 7, !"frame-pointer", i32 2}
!8 = !{!"Homebrew clang version 23.1.3"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 11, type: !10, scopeLine: 11, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !13)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !{}
!14 = !DILocalVariable(name: "pp", scope: !9, file: !1, line: 12, type: !15)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!17 = !DILocation(line: 12, column: 11, scope: !9)
!18 = !DILocation(line: 12, column: 16, scope: !9)
!19 = !DILocation(line: 13, column: 9, scope: !20)
!20 = distinct !DILexicalBlock(scope: !9, file: !1, line: 13, column: 9)
!21 = !DILocation(line: 13, column: 12, scope: !20)
!22 = !DILocation(line: 13, column: 18, scope: !20)
!23 = !DILocalVariable(name: "p", scope: !9, file: !1, line: 14, type: !16)
!24 = !DILocation(line: 14, column: 10, scope: !9)
!25 = !DILocation(line: 14, column: 15, scope: !9)
!26 = !DILocation(line: 14, column: 14, scope: !9)
!27 = !DILocation(line: 15, column: 9, scope: !28)
!28 = distinct !DILexicalBlock(scope: !9, file: !1, line: 15, column: 9)
!29 = !DILocation(line: 15, column: 11, scope: !28)
!30 = !DILocation(line: 15, column: 17, scope: !28)
!31 = !DILocation(line: 16, column: 6, scope: !9)
!32 = !DILocation(line: 16, column: 8, scope: !9)
!33 = !DILocation(line: 17, column: 5, scope: !9)
!34 = !DILocation(line: 18, column: 1, scope: !9)
