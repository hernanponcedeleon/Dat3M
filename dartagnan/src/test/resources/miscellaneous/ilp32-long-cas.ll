; ModuleID = 'benchmarks/miscellaneous/ilp32-long-cas.c'
source_filename = "benchmarks/miscellaneous/ilp32-long-cas.c"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@x = dso_local global i64 0, align 8, !dbg !0
@.str = private unnamed_addr constant [50 x i8] c"atomic_compare_exchange_strong(&x, &expected, 42)\00", align 1, !dbg !5
@.str.1 = private unnamed_addr constant [42 x i8] c"benchmarks/miscellaneous/ilp32-long-cas.c\00", align 1, !dbg !11
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !16

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !35 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 4
  %4 = alloca i8, align 1
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !40, !DIExpression(), !41)
  store i64 0, ptr %2, align 8, !dbg !41
  store i64 42, ptr %3, align 4, !dbg !42
  %5 = load i64, ptr %2, align 8, !dbg !42
  %6 = load i64, ptr %3, align 4, !dbg !42
  %7 = cmpxchg ptr @x, i64 %5, i64 %6 seq_cst seq_cst, align 8, !dbg !42
  %8 = extractvalue { i64, i1 } %7, 0, !dbg !42
  %9 = extractvalue { i64, i1 } %7, 1, !dbg !42
  br i1 %9, label %11, label %10, !dbg !42

10:                                               ; preds = %0
  store i64 %8, ptr %2, align 8, !dbg !42
  br label %11, !dbg !42

11:                                               ; preds = %10, %0
  %12 = zext i1 %9 to i8, !dbg !42
  store i8 %12, ptr %4, align 1, !dbg !42
  %13 = load i8, ptr %4, align 1, !dbg !42
  %14 = trunc i8 %13 to i1, !dbg !42
  br i1 %14, label %16, label %15, !dbg !45

15:                                               ; preds = %11
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 13, ptr noundef @__func__.main), !dbg !45
  br label %16, !dbg !45

16:                                               ; preds = %15, %11
  ret i32 0, !dbg !46
}

declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!26, !27, !28, !29, !30, !31, !32, !33}
!llvm.ident = !{!34}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 9, type: !22, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/miscellaneous/ilp32-long-cas.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "7e8c35e976eb9aa2004ffd6e390d45e8")
!4 = !{!5, !11, !16, !0}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !7, isLocal: true, isDefinition: true)
!7 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 400, elements: !9)
!8 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!9 = !{!10}
!10 = !DISubrange(count: 50)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !13, isLocal: true, isDefinition: true)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 336, elements: !14)
!14 = !{!15}
!15 = !DISubrange(count: 42)
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !18, isLocal: true, isDefinition: true)
!18 = !DICompositeType(tag: DW_TAG_array_type, baseType: !19, size: 40, elements: !20)
!19 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !8)
!20 = !{!21}
!21 = !DISubrange(count: 5)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_llong", file: !23, line: 7, baseType: !24)
!23 = !DIFile(filename: "local/include/stdatomic.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "ca5476aa07a793b787899ad8391d1e81")
!24 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !25)
!25 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!26 = !{i32 1, !"NumRegisterParameters", i32 0}
!27 = !{i32 7, !"Dwarf Version", i32 5}
!28 = !{i32 2, !"Debug Info Version", i32 3}
!29 = !{i32 1, !"wchar_size", i32 4}
!30 = !{i32 8, !"PIC Level", i32 2}
!31 = !{i32 7, !"PIE Level", i32 2}
!32 = !{i32 7, !"uwtable", i32 2}
!33 = !{i32 7, !"frame-pointer", i32 2}
!34 = !{!"Homebrew clang version 22.1.8"}
!35 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 11, type: !36, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !39)
!36 = !DISubroutineType(types: !37)
!37 = !{!38}
!38 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!39 = !{}
!40 = !DILocalVariable(name: "expected", scope: !35, file: !3, line: 12, type: !25)
!41 = !DILocation(line: 12, column: 15, scope: !35)
!42 = !DILocation(line: 13, column: 12, scope: !43)
!43 = distinct !DILexicalBlock(scope: !44, file: !3, line: 13, column: 5)
!44 = distinct !DILexicalBlock(scope: !35, file: !3, line: 13, column: 5)
!45 = !DILocation(line: 13, column: 5, scope: !43)
!46 = !DILocation(line: 14, column: 5, scope: !35)
