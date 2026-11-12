; ModuleID = 'benchmarks/mem-safety/memory-bounds-single-heap.c'
source_filename = "benchmarks/mem-safety/memory-bounds-single-heap.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !9 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !14, !DIExpression(), !16)
  %3 = call ptr @malloc(i64 noundef 16) #2, !dbg !17
  store ptr %3, ptr %2, align 8, !dbg !16
  %4 = load ptr, ptr %2, align 8, !dbg !18
  %5 = icmp eq ptr %4, null, !dbg !20
  br i1 %5, label %6, label %7, !dbg !20

6:                                                ; preds = %0
  store i32 0, ptr %1, align 4, !dbg !21
  br label %10, !dbg !21

7:                                                ; preds = %0
  %8 = load ptr, ptr %2, align 8, !dbg !22
  %9 = getelementptr inbounds i32, ptr %8, i64 4, !dbg !22
  store i32 1, ptr %9, align 4, !dbg !23
  store i32 0, ptr %1, align 4, !dbg !24
  br label %10, !dbg !24

10:                                               ; preds = %7, %6
  %11 = load i32, ptr %1, align 4, !dbg !25
  ret i32 %11, !dbg !25
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
!1 = !DIFile(filename: "benchmarks/mem-safety/memory-bounds-single-heap.c", directory: ".", checksumkind: CSK_MD5, checksum: "b551f744736bfb9b735d5d81abd6d526")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 8, !"PIC Level", i32 2}
!5 = !{i32 7, !"PIE Level", i32 2}
!6 = !{i32 7, !"uwtable", i32 2}
!7 = !{i32 7, !"frame-pointer", i32 2}
!8 = !{!"Homebrew clang version 23.1.3"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 19, type: !10, scopeLine: 19, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !13)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !{}
!14 = !DILocalVariable(name: "p", scope: !9, file: !1, line: 20, type: !15)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!16 = !DILocation(line: 20, column: 10, scope: !9)
!17 = !DILocation(line: 20, column: 14, scope: !9)
!18 = !DILocation(line: 21, column: 9, scope: !19)
!19 = distinct !DILexicalBlock(scope: !9, file: !1, line: 21, column: 9)
!20 = !DILocation(line: 21, column: 11, scope: !19)
!21 = !DILocation(line: 21, column: 17, scope: !19)
!22 = !DILocation(line: 22, column: 5, scope: !9)
!23 = !DILocation(line: 22, column: 14, scope: !9)
!24 = !DILocation(line: 23, column: 5, scope: !9)
!25 = !DILocation(line: 24, column: 1, scope: !9)
