; ModuleID = 'benchmarks/mem-safety/ilp32-malloc-not-executed.c'
source_filename = "benchmarks/mem-safety/ilp32-malloc-not-executed.c"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@g = dso_local global ptr null, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !7
@.str = private unnamed_addr constant [28 x i8] c"ilp32-malloc-not-executed.c\00", align 1, !dbg !14
@.str.1 = private unnamed_addr constant [10 x i8] c"p == NULL\00", align 1, !dbg !19

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !33 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 4
  store i32 0, ptr %1, align 4
  %3 = call i32 @__VERIFIER_nondet_int(), !dbg !38
  %4 = icmp ne i32 %3, 0, !dbg !38
  br i1 %4, label %5, label %7, !dbg !38

5:                                                ; preds = %0
  %6 = call ptr @malloc(i32 noundef 2147483647) #4, !dbg !40
  store ptr %6, ptr @g, align 4, !dbg !42
  br label %21, !dbg !43

7:                                                ; preds = %0
    #dbg_declare(ptr %2, !44, !DIExpression(), !46)
  %8 = call ptr @malloc(i32 noundef 2147483647) #4, !dbg !47
  store ptr %8, ptr %2, align 4, !dbg !46
  %9 = load ptr, ptr %2, align 4, !dbg !48
  %10 = icmp eq ptr %9, null, !dbg !49
  %11 = xor i1 %10, true, !dbg !50
  br i1 %11, label %12, label %14, !dbg !50

12:                                               ; preds = %7
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 27, ptr noundef @.str.1) #5, !dbg !50
  unreachable, !dbg !50

13:                                               ; No predecessors!
  br label %15, !dbg !50

14:                                               ; preds = %7
  br label %15, !dbg !50

15:                                               ; preds = %14, %13
  %16 = load ptr, ptr %2, align 4, !dbg !51
  %17 = icmp ne ptr %16, null, !dbg !53
  br i1 %17, label %18, label %20, !dbg !53

18:                                               ; preds = %15
  %19 = load ptr, ptr %2, align 4, !dbg !54
  store i8 1, ptr %19, align 1, !dbg !56
  br label %20, !dbg !57

20:                                               ; preds = %18, %15
  br label %21

21:                                               ; preds = %20, %5
  ret i32 0, !dbg !58
}

declare i32 @__VERIFIER_nondet_int() #1

; Function Attrs: allocsize(0)
declare ptr @malloc(i32 noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { allocsize(0) }
attributes #5 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!25, !26, !27, !28, !29, !30, !31}
!llvm.ident = !{!32}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g", scope: !2, file: !3, line: 19, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/mem-safety/ilp32-malloc-not-executed.c", directory: ".", checksumkind: CSK_MD5, checksum: "638d60bd6cdf3ee2f454283366641bd4")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!6 = !{!7, !14, !19, !0}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 27, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 40, elements: !12)
!10 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!11 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!13}
!13 = !DISubrange(count: 5)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(scope: null, file: !3, line: 27, type: !16, isLocal: true, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 224, elements: !17)
!17 = !{!18}
!18 = !DISubrange(count: 28)
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(scope: null, file: !3, line: 27, type: !21, isLocal: true, isDefinition: true)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 80, elements: !22)
!22 = !{!23}
!23 = !DISubrange(count: 10)
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 32)
!25 = !{i32 1, !"NumRegisterParameters", i32 0}
!26 = !{i32 7, !"Dwarf Version", i32 5}
!27 = !{i32 2, !"Debug Info Version", i32 3}
!28 = !{i32 8, !"PIC Level", i32 2}
!29 = !{i32 7, !"PIE Level", i32 2}
!30 = !{i32 7, !"uwtable", i32 2}
!31 = !{i32 7, !"frame-pointer", i32 2}
!32 = !{!"Homebrew clang version 23.1.3"}
!33 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 21, type: !34, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !37)
!34 = !DISubroutineType(types: !35)
!35 = !{!36}
!36 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!37 = !{}
!38 = !DILocation(line: 22, column: 9, scope: !39)
!39 = distinct !DILexicalBlock(scope: !33, file: !3, line: 22, column: 9)
!40 = !DILocation(line: 23, column: 13, scope: !41)
!41 = distinct !DILexicalBlock(scope: !39, file: !3, line: 22, column: 34)
!42 = !DILocation(line: 23, column: 11, scope: !41)
!43 = !DILocation(line: 24, column: 5, scope: !41)
!44 = !DILocalVariable(name: "p", scope: !45, file: !3, line: 25, type: !24)
!45 = distinct !DILexicalBlock(scope: !39, file: !3, line: 24, column: 12)
!46 = !DILocation(line: 25, column: 15, scope: !45)
!47 = !DILocation(line: 25, column: 19, scope: !45)
!48 = !DILocation(line: 27, column: 16, scope: !45)
!49 = !DILocation(line: 27, column: 18, scope: !45)
!50 = !DILocation(line: 27, column: 9, scope: !45)
!51 = !DILocation(line: 29, column: 13, scope: !52)
!52 = distinct !DILexicalBlock(scope: !45, file: !3, line: 29, column: 13)
!53 = !DILocation(line: 29, column: 15, scope: !52)
!54 = !DILocation(line: 30, column: 14, scope: !55)
!55 = distinct !DILexicalBlock(scope: !52, file: !3, line: 29, column: 24)
!56 = !DILocation(line: 30, column: 16, scope: !55)
!57 = !DILocation(line: 31, column: 9, scope: !55)
!58 = !DILocation(line: 33, column: 5, scope: !33)
