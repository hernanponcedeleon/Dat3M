; ModuleID = 'benchmarks/miscellaneous/main-args.c'
source_filename = "benchmarks/miscellaneous/main-args.c"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [12 x i8] c"main-args.c\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [12 x i8] c"reach_error\00", align 1, !dbg !12
@.src = private unnamed_addr constant [37 x i8] c"benchmarks/miscellaneous/main-args.c\00", align 1
@0 = private unnamed_addr constant { i16, i16, [9 x i8] } { i16 -1, i16 0, [9 x i8] c"'char *'\00" }
@1 = private unnamed_addr global { { ptr, i32, i32 }, ptr, i8, i8 } { { ptr, i32, i32 } { ptr @.src, i32 18, i32 19 }, ptr @0, i8 1, i8 0 }
@2 = private unnamed_addr global { { ptr, i32, i32 }, ptr, i8, i8 } { { ptr, i32, i32 } { ptr @.src, i32 19, i32 19 }, ptr @0, i8 1, i8 0 }
@3 = private unnamed_addr global { { ptr, i32, i32 }, ptr, i8, i8 } { { ptr, i32, i32 } { ptr @.src, i32 25, i32 9 }, ptr @0, i8 1, i8 0 }

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !24 {
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 13, ptr noundef @.str.2), !dbg !27
  ret void, !dbg !28
}

declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main(i32 noundef %0, ptr noundef %1) #0 !dbg !29 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  %7 = alloca ptr, align 4
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
    #dbg_declare(ptr %4, !36, !DIExpression(), !37)
  store ptr %1, ptr %5, align 4
    #dbg_declare(ptr %5, !38, !DIExpression(), !39)
  %8 = load i32, ptr %4, align 4, !dbg !40
  %9 = icmp eq i32 %8, 3, !dbg !42
  br i1 %9, label %10, label %30, !dbg !42

10:                                               ; preds = %2
    #dbg_declare(ptr %6, !43, !DIExpression(), !45)
  %11 = load ptr, ptr %5, align 4, !dbg !46
  %12 = getelementptr inbounds ptr, ptr %11, i32 1, !dbg !46
  %13 = icmp ne ptr %12, null, !dbg !46, !nosanitize !35
  br i1 %13, label %16, label %14, !dbg !46, !prof !47, !nosanitize !35

14:                                               ; preds = %10
  %15 = ptrtoint ptr %12 to i32, !dbg !46, !nosanitize !35
  call void @__ubsan_handle_type_mismatch_v1(ptr @1, i32 %15) #3, !dbg !46, !nosanitize !35
  br label %16, !dbg !46, !nosanitize !35

16:                                               ; preds = %14, %10
  %17 = load ptr, ptr %12, align 4, !dbg !46
  store ptr %17, ptr %6, align 4, !dbg !45
    #dbg_declare(ptr %7, !48, !DIExpression(), !49)
  %18 = load ptr, ptr %5, align 4, !dbg !50
  %19 = getelementptr inbounds ptr, ptr %18, i32 2, !dbg !50
  %20 = icmp ne ptr %19, null, !dbg !50, !nosanitize !35
  br i1 %20, label %23, label %21, !dbg !50, !prof !47, !nosanitize !35

21:                                               ; preds = %16
  %22 = ptrtoint ptr %19 to i32, !dbg !50, !nosanitize !35
  call void @__ubsan_handle_type_mismatch_v1(ptr @2, i32 %22) #3, !dbg !50, !nosanitize !35
  br label %23, !dbg !50, !nosanitize !35

23:                                               ; preds = %21, %16
  %24 = load ptr, ptr %19, align 4, !dbg !50
  store ptr %24, ptr %7, align 4, !dbg !49
  %25 = load ptr, ptr %6, align 4, !dbg !51
  %26 = load ptr, ptr %7, align 4, !dbg !53
  %27 = icmp eq ptr %25, %26, !dbg !54
  br i1 %27, label %28, label %29, !dbg !54

28:                                               ; preds = %23
  store i32 1, ptr %3, align 4, !dbg !55
  br label %41, !dbg !55

29:                                               ; preds = %23
  br label %30, !dbg !57

30:                                               ; preds = %29, %2
  %31 = load ptr, ptr %5, align 4, !dbg !58
  %32 = getelementptr inbounds ptr, ptr %31, i32 0, !dbg !58
  %33 = icmp ne ptr %32, null, !dbg !58, !nosanitize !35
  br i1 %33, label %36, label %34, !dbg !58, !prof !47, !nosanitize !35

34:                                               ; preds = %30
  %35 = ptrtoint ptr %32 to i32, !dbg !58, !nosanitize !35
  call void @__ubsan_handle_type_mismatch_v1(ptr @3, i32 %35) #3, !dbg !58, !nosanitize !35
  br label %36, !dbg !58, !nosanitize !35

36:                                               ; preds = %34, %30
  %37 = load ptr, ptr %32, align 4, !dbg !58
  %38 = icmp eq ptr %37, null, !dbg !60
  br i1 %38, label %39, label %40, !dbg !60

39:                                               ; preds = %36
  call void @reach_error(), !dbg !61
  br label %40, !dbg !61

40:                                               ; preds = %39, %36
  store i32 0, ptr %3, align 4, !dbg !62
  br label %41, !dbg !62

41:                                               ; preds = %40, %28
  %42 = load i32, ptr %3, align 4, !dbg !63
  ret i32 %42, !dbg !63
}

; Function Attrs: uwtable
declare void @__ubsan_handle_type_mismatch_v1(ptr, i32) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { uwtable }
attributes #3 = { nomerge nounwind }

!llvm.dbg.cu = !{!14}
!llvm.module.flags = !{!16, !17, !18, !19, !20, !21, !22}
!llvm.ident = !{!23}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 14, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/miscellaneous/main-args.c", directory: ".", checksumkind: CSK_MD5, checksum: "a248eabb6f4feafb4fbd240ee5f4bb9b")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 16, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 2)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 14, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 96, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 12)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 14, type: !9, isLocal: true, isDefinition: true)
!14 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !15, splitDebugInlining: false, nameTableKind: None)
!15 = !{!0, !7, !12}
!16 = !{i32 1, !"NumRegisterParameters", i32 0}
!17 = !{i32 7, !"Dwarf Version", i32 5}
!18 = !{i32 2, !"Debug Info Version", i32 3}
!19 = !{i32 8, !"PIC Level", i32 2}
!20 = !{i32 7, !"PIE Level", i32 2}
!21 = !{i32 7, !"uwtable", i32 2}
!22 = !{i32 7, !"frame-pointer", i32 2}
!23 = !{!"Homebrew clang version 23.1.3"}
!24 = distinct !DISubprogram(name: "reach_error", scope: !2, file: !2, line: 14, type: !25, scopeLine: 14, spFlags: DISPFlagDefinition, unit: !14)
!25 = !DISubroutineType(types: !26)
!26 = !{null}
!27 = !DILocation(line: 14, column: 22, scope: !24)
!28 = !DILocation(line: 14, column: 76, scope: !24)
!29 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 16, type: !30, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !14, retainedNodes: !35)
!30 = !DISubroutineType(types: !31)
!31 = !{!32, !32, !33}
!32 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 32)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 32)
!35 = !{}
!36 = !DILocalVariable(name: "argc", arg: 1, scope: !29, file: !2, line: 16, type: !32)
!37 = !DILocation(line: 16, column: 14, scope: !29)
!38 = !DILocalVariable(name: "argv", arg: 2, scope: !29, file: !2, line: 16, type: !33)
!39 = !DILocation(line: 16, column: 26, scope: !29)
!40 = !DILocation(line: 17, column: 9, scope: !41)
!41 = distinct !DILexicalBlock(scope: !29, file: !2, line: 17, column: 9)
!42 = !DILocation(line: 17, column: 14, scope: !41)
!43 = !DILocalVariable(name: "a", scope: !44, file: !2, line: 18, type: !34)
!44 = distinct !DILexicalBlock(scope: !41, file: !2, line: 17, column: 20)
!45 = !DILocation(line: 18, column: 15, scope: !44)
!46 = !DILocation(line: 18, column: 19, scope: !44)
!47 = !{!"branch_weights", i32 1048575, i32 1}
!48 = !DILocalVariable(name: "b", scope: !44, file: !2, line: 19, type: !34)
!49 = !DILocation(line: 19, column: 15, scope: !44)
!50 = !DILocation(line: 19, column: 19, scope: !44)
!51 = !DILocation(line: 20, column: 13, scope: !52)
!52 = distinct !DILexicalBlock(scope: !44, file: !2, line: 20, column: 13)
!53 = !DILocation(line: 20, column: 18, scope: !52)
!54 = !DILocation(line: 20, column: 15, scope: !52)
!55 = !DILocation(line: 21, column: 13, scope: !56)
!56 = distinct !DILexicalBlock(scope: !52, file: !2, line: 20, column: 21)
!57 = !DILocation(line: 23, column: 5, scope: !44)
!58 = !DILocation(line: 25, column: 9, scope: !59)
!59 = distinct !DILexicalBlock(scope: !29, file: !2, line: 25, column: 9)
!60 = !DILocation(line: 25, column: 17, scope: !59)
!61 = !DILocation(line: 25, column: 23, scope: !59)
!62 = !DILocation(line: 31, column: 5, scope: !29)
!63 = !DILocation(line: 32, column: 1, scope: !29)
