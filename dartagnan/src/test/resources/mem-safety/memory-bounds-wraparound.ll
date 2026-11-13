; ModuleID = 'benchmarks/mem-safety/memory-bounds-wraparound.c'
source_filename = "benchmarks/mem-safety/memory-bounds-wraparound.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local global [4 x i32] zeroinitializer, align 16, !dbg !0

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !18 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !22, !DIExpression(), !24)
  store ptr @a, ptr %2, align 8, !dbg !24
    #dbg_declare(ptr %3, !25, !DIExpression(), !26)
  %4 = call i64 @__VERIFIER_nondet_ulong(), !dbg !27
  store i64 %4, ptr %3, align 8, !dbg !26
  %5 = load ptr, ptr %2, align 8, !dbg !28
  %6 = load i64, ptr %3, align 8, !dbg !30
  %7 = getelementptr inbounds nuw i32, ptr %5, i64 %6, !dbg !31
  %8 = ptrtoint ptr %7 to i64, !dbg !32
  %9 = load ptr, ptr %2, align 8, !dbg !33
  %10 = getelementptr inbounds i32, ptr %9, i64 3, !dbg !34
  %11 = ptrtoint ptr %10 to i64, !dbg !35
  %12 = icmp ne i64 %8, %11, !dbg !36
  br i1 %12, label %13, label %14, !dbg !36

13:                                               ; preds = %0
  call void @abort() #3, !dbg !37
  unreachable, !dbg !37

14:                                               ; preds = %0
  %15 = load ptr, ptr %2, align 8, !dbg !38
  %16 = load i64, ptr %3, align 8, !dbg !39
  %17 = getelementptr inbounds nuw i32, ptr %15, i64 %16, !dbg !38
  store i32 1, ptr %17, align 4, !dbg !40
  ret i32 0, !dbg !41
}

declare i64 @__VERIFIER_nondet_ulong() #1

; Function Attrs: noreturn nounwind
declare void @abort() #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!11, !12, !13, !14, !15, !16}
!llvm.ident = !{!17}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 15, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/mem-safety/memory-bounds-wraparound.c", directory: ".", checksumkind: CSK_MD5, checksum: "c393654abb8c7015a7bf34b67b39d2e0")
!4 = !{!5}
!5 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!6 = !{!0}
!7 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 128, elements: !9)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !{!10}
!10 = !DISubrange(count: 4)
!11 = !{i32 7, !"Dwarf Version", i32 5}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 8, !"PIC Level", i32 2}
!14 = !{i32 7, !"PIE Level", i32 2}
!15 = !{i32 7, !"uwtable", i32 2}
!16 = !{i32 7, !"frame-pointer", i32 2}
!17 = !{!"Homebrew clang version 23.1.3"}
!18 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 17, type: !19, scopeLine: 17, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !21)
!19 = !DISubroutineType(types: !20)
!20 = !{!8}
!21 = !{}
!22 = !DILocalVariable(name: "p", scope: !18, file: !3, line: 18, type: !23)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!24 = !DILocation(line: 18, column: 10, scope: !18)
!25 = !DILocalVariable(name: "i", scope: !18, file: !3, line: 19, type: !5)
!26 = !DILocation(line: 19, column: 19, scope: !18)
!27 = !DILocation(line: 19, column: 23, scope: !18)
!28 = !DILocation(line: 23, column: 25, scope: !29)
!29 = distinct !DILexicalBlock(scope: !18, file: !3, line: 23, column: 9)
!30 = !DILocation(line: 23, column: 29, scope: !29)
!31 = !DILocation(line: 23, column: 27, scope: !29)
!32 = !DILocation(line: 23, column: 9, scope: !29)
!33 = !DILocation(line: 23, column: 51, scope: !29)
!34 = !DILocation(line: 23, column: 53, scope: !29)
!35 = !DILocation(line: 23, column: 35, scope: !29)
!36 = !DILocation(line: 23, column: 32, scope: !29)
!37 = !DILocation(line: 23, column: 59, scope: !29)
!38 = !DILocation(line: 25, column: 5, scope: !18)
!39 = !DILocation(line: 25, column: 7, scope: !18)
!40 = !DILocation(line: 25, column: 10, scope: !18)
!41 = !DILocation(line: 26, column: 5, scope: !18)
