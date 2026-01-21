; ModuleID = 'benchmarks/mixed/memtrack2-pass.c'
source_filename = "benchmarks/mixed/memtrack2-pass.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@m_global = dso_local global ptr null, align 8, !dbg !0

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !20 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
  %3 = call ptr @malloc(i64 noundef 4) #2, !dbg !24
  store volatile ptr %3, ptr @m_global, align 8, !dbg !25
    #dbg_declare(ptr %2, !26, !DIExpression(), !27)
  %4 = load volatile ptr, ptr @m_global, align 8, !dbg !28
  store ptr %4, ptr %2, align 8, !dbg !27
  store volatile i8 0, ptr @m_global, align 8, !dbg !29
  %5 = load ptr, ptr %2, align 8, !dbg !30
  store volatile ptr %5, ptr @m_global, align 8, !dbg !31
  ret i32 0, !dbg !32
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { allocsize(0) }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!12, !13, !14, !15, !16, !17, !18}
!llvm.ident = !{!19}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "m_global", scope: !2, file: !3, line: 2, type: !11, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !10, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/mixed/memtrack2-pass.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "5da2855695665b5c3081aeb3ab66b9ee")
!4 = !{!5, !7}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !9)
!9 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!10 = !{!0}
!11 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !5)
!12 = !{i32 7, !"Dwarf Version", i32 5}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{i32 1, !"wchar_size", i32 4}
!15 = !{i32 8, !"PIC Level", i32 2}
!16 = !{i32 7, !"PIE Level", i32 2}
!17 = !{i32 7, !"uwtable", i32 2}
!18 = !{i32 7, !"frame-pointer", i32 2}
!19 = !{!"Homebrew clang version 19.1.7"}
!20 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 3, type: !21, scopeLine: 4, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!21 = !DISubroutineType(types: !22)
!22 = !{!6}
!23 = !{}
!24 = !DILocation(line: 5, column: 21, scope: !20)
!25 = !DILocation(line: 5, column: 12, scope: !20)
!26 = !DILocalVariable(name: "temp", scope: !20, file: !3, line: 6, type: !5)
!27 = !DILocation(line: 6, column: 8, scope: !20)
!28 = !DILocation(line: 6, column: 15, scope: !20)
!29 = !DILocation(line: 7, column: 33, scope: !20)
!30 = !DILocation(line: 8, column: 14, scope: !20)
!31 = !DILocation(line: 8, column: 12, scope: !20)
!32 = !DILocation(line: 9, column: 3, scope: !20)
