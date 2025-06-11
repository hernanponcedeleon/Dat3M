; ModuleID = 'benchmarks/miscellaneous/memtoreg_merging_pointers.c'
source_filename = "benchmarks/miscellaneous/memtoreg_merging_pointers.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !0
@.str = private unnamed_addr constant [28 x i8] c"memtoreg_merging_pointers.c\00", align 1, !dbg !8
@.str.1 = private unnamed_addr constant [8 x i8] c"*i == 1\00", align 1, !dbg !13

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !28 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x i32], align 4
  %3 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !33, !DIExpression(), !37)
    #dbg_declare(ptr %3, !38, !DIExpression(), !40)
  %4 = call i32 @__VERIFIER_nondet_int(), !dbg !41
  %5 = icmp ne i32 %4, 0, !dbg !41
  br i1 %5, label %6, label %8, !dbg !43

6:                                                ; preds = %0
  %7 = getelementptr inbounds [2 x i32], ptr %2, i64 0, i64 0, !dbg !44
  store ptr %7, ptr %3, align 8, !dbg !45
  br label %10, !dbg !46

8:                                                ; preds = %0
  %9 = getelementptr inbounds [2 x i32], ptr %2, i64 0, i64 1, !dbg !47
  store ptr %9, ptr %3, align 8, !dbg !48
  br label %10

10:                                               ; preds = %8, %6
  %11 = load ptr, ptr %3, align 8, !dbg !49
  store i32 1, ptr %11, align 4, !dbg !50
  %12 = load ptr, ptr %3, align 8, !dbg !51
  %13 = load i32, ptr %12, align 4, !dbg !51
  %14 = icmp eq i32 %13, 1, !dbg !51
  %15 = xor i1 %14, true, !dbg !51
  %16 = zext i1 %15 to i32, !dbg !51
  %17 = sext i32 %16 to i64, !dbg !51
  %18 = icmp ne i64 %17, 0, !dbg !51
  br i1 %18, label %19, label %21, !dbg !51

19:                                               ; preds = %10
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 16, ptr noundef @.str.1) #3, !dbg !51
  unreachable, !dbg !51

20:                                               ; No predecessors!
  br label %22, !dbg !51

21:                                               ; preds = %10
  br label %22, !dbg !51

22:                                               ; preds = %21, %20
  ret i32 0, !dbg !52
}

declare i32 @__VERIFIER_nondet_int() #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn }

!llvm.dbg.cu = !{!18}
!llvm.module.flags = !{!20, !21, !22, !23, !24, !25, !26}
!llvm.ident = !{!27}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 16, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/miscellaneous/memtoreg_merging_pointers.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "0906b8cb3847999c8715ea2e910ca5d2")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 40, elements: !6)
!4 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !5)
!5 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!6 = !{!7}
!7 = !DISubrange(count: 5)
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(scope: null, file: !2, line: 16, type: !10, isLocal: true, isDefinition: true)
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 224, elements: !11)
!11 = !{!12}
!12 = !DISubrange(count: 28)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !2, line: 16, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 64, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 8)
!18 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !19, splitDebugInlining: false, nameTableKind: None)
!19 = !{!0, !8, !13}
!20 = !{i32 7, !"Dwarf Version", i32 5}
!21 = !{i32 2, !"Debug Info Version", i32 3}
!22 = !{i32 1, !"wchar_size", i32 4}
!23 = !{i32 8, !"PIC Level", i32 2}
!24 = !{i32 7, !"PIE Level", i32 2}
!25 = !{i32 7, !"uwtable", i32 2}
!26 = !{i32 7, !"frame-pointer", i32 2}
!27 = !{!"Homebrew clang version 19.1.7"}
!28 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 7, type: !29, scopeLine: 8, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !32)
!29 = !DISubroutineType(types: !30)
!30 = !{!31}
!31 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!32 = !{}
!33 = !DILocalVariable(name: "a", scope: !28, file: !2, line: 9, type: !34)
!34 = !DICompositeType(tag: DW_TAG_array_type, baseType: !31, size: 64, elements: !35)
!35 = !{!36}
!36 = !DISubrange(count: 2)
!37 = !DILocation(line: 9, column: 9, scope: !28)
!38 = !DILocalVariable(name: "i", scope: !28, file: !2, line: 10, type: !39)
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!40 = !DILocation(line: 10, column: 10, scope: !28)
!41 = !DILocation(line: 11, column: 9, scope: !42)
!42 = distinct !DILexicalBlock(scope: !28, file: !2, line: 11, column: 9)
!43 = !DILocation(line: 11, column: 9, scope: !28)
!44 = !DILocation(line: 12, column: 14, scope: !42)
!45 = !DILocation(line: 12, column: 11, scope: !42)
!46 = !DILocation(line: 12, column: 9, scope: !42)
!47 = !DILocation(line: 14, column: 14, scope: !42)
!48 = !DILocation(line: 14, column: 11, scope: !42)
!49 = !DILocation(line: 15, column: 6, scope: !28)
!50 = !DILocation(line: 15, column: 8, scope: !28)
!51 = !DILocation(line: 16, column: 5, scope: !28)
!52 = !DILocation(line: 17, column: 5, scope: !28)
