; ModuleID = 'benchmarks/miscellaneous/calloc_nondet_size.c'
source_filename = "benchmarks/miscellaneous/calloc_nondet_size.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !9 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !14, !DIExpression(), !15)
  %6 = call i32 @__VERIFIER_nondet_int(), !dbg !16
  store i32 %6, ptr %2, align 4, !dbg !15
  %7 = load i32, ptr %2, align 4, !dbg !17
  %8 = icmp sgt i32 %7, 0, !dbg !18
  br i1 %8, label %9, label %12, !dbg !19

9:                                                ; preds = %0
  %10 = load i32, ptr %2, align 4, !dbg !20
  %11 = icmp sle i32 %10, 4, !dbg !21
  br label %12

12:                                               ; preds = %9, %0
  %13 = phi i1 [ false, %0 ], [ %11, %9 ], !dbg !22
  %14 = zext i1 %13 to i32, !dbg !19
  call void @__VERIFIER_assume(i32 noundef %14), !dbg !23
    #dbg_declare(ptr %3, !24, !DIExpression(), !25)
  %15 = call i32 @__VERIFIER_nondet_int(), !dbg !26
  store i32 %15, ptr %3, align 4, !dbg !25
  %16 = load i32, ptr %3, align 4, !dbg !27
  %17 = icmp sge i32 %16, 0, !dbg !28
  br i1 %17, label %18, label %22, !dbg !29

18:                                               ; preds = %12
  %19 = load i32, ptr %3, align 4, !dbg !30
  %20 = load i32, ptr %2, align 4, !dbg !31
  %21 = icmp slt i32 %19, %20, !dbg !32
  br label %22

22:                                               ; preds = %18, %12
  %23 = phi i1 [ false, %12 ], [ %21, %18 ], !dbg !22
  %24 = zext i1 %23 to i32, !dbg !29
  call void @__VERIFIER_assume(i32 noundef %24), !dbg !33
    #dbg_declare(ptr %4, !34, !DIExpression(), !36)
  %25 = load i32, ptr %2, align 4, !dbg !37
  %26 = sext i32 %25 to i64, !dbg !37
  %27 = call ptr @calloc(i64 noundef %26, i64 noundef 4) #4, !dbg !38
  store ptr %27, ptr %4, align 8, !dbg !36
    #dbg_declare(ptr %5, !39, !DIExpression(), !40)
  %28 = load i32, ptr %2, align 4, !dbg !41
  %29 = sext i32 %28 to i64, !dbg !41
  %30 = mul i64 %29, 4, !dbg !42
  %31 = call ptr @malloc(i64 noundef %30) #5, !dbg !43
  store ptr %31, ptr %5, align 8, !dbg !40
  %32 = load ptr, ptr %4, align 8, !dbg !44
  %33 = icmp eq ptr %32, null, !dbg !46
  br i1 %33, label %37, label %34, !dbg !47

34:                                               ; preds = %22
  %35 = load ptr, ptr %5, align 8, !dbg !48
  %36 = icmp eq ptr %35, null, !dbg !49
  br i1 %36, label %37, label %38, !dbg !47

37:                                               ; preds = %34, %22
  store i32 0, ptr %1, align 4, !dbg !50
  br label %64, !dbg !50

38:                                               ; preds = %34
  %39 = load ptr, ptr %4, align 8, !dbg !52
  %40 = load i32, ptr %3, align 4, !dbg !53
  %41 = sext i32 %40 to i64, !dbg !52
  %42 = getelementptr inbounds i32, ptr %39, i64 %41, !dbg !52
  %43 = load i32, ptr %42, align 4, !dbg !52
  %44 = icmp eq i32 %43, 0, !dbg !54
  %45 = zext i1 %44 to i32, !dbg !54
  call void @__VERIFIER_assert(i32 noundef %45), !dbg !55
  %46 = load ptr, ptr %4, align 8, !dbg !56
  %47 = load i32, ptr %3, align 4, !dbg !57
  %48 = sext i32 %47 to i64, !dbg !56
  %49 = getelementptr inbounds i32, ptr %46, i64 %48, !dbg !56
  store i32 1, ptr %49, align 4, !dbg !58
  %50 = load ptr, ptr %4, align 8, !dbg !59
  %51 = load i32, ptr %3, align 4, !dbg !60
  %52 = sext i32 %51 to i64, !dbg !59
  %53 = getelementptr inbounds i32, ptr %50, i64 %52, !dbg !59
  %54 = load i32, ptr %53, align 4, !dbg !59
  %55 = icmp eq i32 %54, 1, !dbg !61
  %56 = zext i1 %55 to i32, !dbg !61
  call void @__VERIFIER_assert(i32 noundef %56), !dbg !62
  %57 = load ptr, ptr %5, align 8, !dbg !63
  %58 = load i32, ptr %3, align 4, !dbg !64
  %59 = sext i32 %58 to i64, !dbg !63
  %60 = getelementptr inbounds i32, ptr %57, i64 %59, !dbg !63
  %61 = load i32, ptr %60, align 4, !dbg !63
  %62 = icmp eq i32 %61, 0, !dbg !65
  %63 = zext i1 %62 to i32, !dbg !65
  call void @__VERIFIER_assert(i32 noundef %63), !dbg !66
  store i32 0, ptr %1, align 4, !dbg !67
  br label %64, !dbg !67

64:                                               ; preds = %38, %37
  %65 = load i32, ptr %1, align 4, !dbg !68
  ret i32 %65, !dbg !68
}

declare i32 @__VERIFIER_nondet_int() #1

declare void @__VERIFIER_assume(i32 noundef) #1

; Function Attrs: allocsize(0,1)
declare ptr @calloc(i64 noundef, i64 noundef) #2

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #3

declare void @__VERIFIER_assert(i32 noundef) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { allocsize(0,1) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { allocsize(0,1) }
attributes #5 = { allocsize(0) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "Homebrew clang version 23.1.3", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "benchmarks/miscellaneous/calloc_nondet_size.c", directory: ".", checksumkind: CSK_MD5, checksum: "0c8414e8a73abba451052126e404ca96")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 8, !"PIC Level", i32 2}
!5 = !{i32 7, !"PIE Level", i32 2}
!6 = !{i32 7, !"uwtable", i32 2}
!7 = !{i32 7, !"frame-pointer", i32 2}
!8 = !{!"Homebrew clang version 23.1.3"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 15, type: !10, scopeLine: 16, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !13)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !{}
!14 = !DILocalVariable(name: "n", scope: !9, file: !1, line: 17, type: !12)
!15 = !DILocation(line: 17, column: 9, scope: !9)
!16 = !DILocation(line: 17, column: 13, scope: !9)
!17 = !DILocation(line: 18, column: 23, scope: !9)
!18 = !DILocation(line: 18, column: 25, scope: !9)
!19 = !DILocation(line: 18, column: 29, scope: !9)
!20 = !DILocation(line: 18, column: 32, scope: !9)
!21 = !DILocation(line: 18, column: 34, scope: !9)
!22 = !DILocation(line: 0, scope: !9)
!23 = !DILocation(line: 18, column: 5, scope: !9)
!24 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 19, type: !12)
!25 = !DILocation(line: 19, column: 9, scope: !9)
!26 = !DILocation(line: 19, column: 13, scope: !9)
!27 = !DILocation(line: 20, column: 23, scope: !9)
!28 = !DILocation(line: 20, column: 25, scope: !9)
!29 = !DILocation(line: 20, column: 30, scope: !9)
!30 = !DILocation(line: 20, column: 33, scope: !9)
!31 = !DILocation(line: 20, column: 37, scope: !9)
!32 = !DILocation(line: 20, column: 35, scope: !9)
!33 = !DILocation(line: 20, column: 5, scope: !9)
!34 = !DILocalVariable(name: "a", scope: !9, file: !1, line: 22, type: !35)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!36 = !DILocation(line: 22, column: 10, scope: !9)
!37 = !DILocation(line: 22, column: 21, scope: !9)
!38 = !DILocation(line: 22, column: 14, scope: !9)
!39 = !DILocalVariable(name: "b", scope: !9, file: !1, line: 23, type: !35)
!40 = !DILocation(line: 23, column: 10, scope: !9)
!41 = !DILocation(line: 23, column: 21, scope: !9)
!42 = !DILocation(line: 23, column: 23, scope: !9)
!43 = !DILocation(line: 23, column: 14, scope: !9)
!44 = !DILocation(line: 24, column: 9, scope: !45)
!45 = distinct !DILexicalBlock(scope: !9, file: !1, line: 24, column: 9)
!46 = !DILocation(line: 24, column: 11, scope: !45)
!47 = !DILocation(line: 24, column: 16, scope: !45)
!48 = !DILocation(line: 24, column: 19, scope: !45)
!49 = !DILocation(line: 24, column: 21, scope: !45)
!50 = !DILocation(line: 25, column: 9, scope: !51)
!51 = distinct !DILexicalBlock(scope: !45, file: !1, line: 24, column: 27)
!52 = !DILocation(line: 28, column: 23, scope: !9)
!53 = !DILocation(line: 28, column: 25, scope: !9)
!54 = !DILocation(line: 28, column: 28, scope: !9)
!55 = !DILocation(line: 28, column: 5, scope: !9)
!56 = !DILocation(line: 29, column: 5, scope: !9)
!57 = !DILocation(line: 29, column: 7, scope: !9)
!58 = !DILocation(line: 29, column: 10, scope: !9)
!59 = !DILocation(line: 30, column: 23, scope: !9)
!60 = !DILocation(line: 30, column: 25, scope: !9)
!61 = !DILocation(line: 30, column: 28, scope: !9)
!62 = !DILocation(line: 30, column: 5, scope: !9)
!63 = !DILocation(line: 32, column: 23, scope: !9)
!64 = !DILocation(line: 32, column: 25, scope: !9)
!65 = !DILocation(line: 32, column: 28, scope: !9)
!66 = !DILocation(line: 32, column: 5, scope: !9)
!67 = !DILocation(line: 34, column: 5, scope: !9)
!68 = !DILocation(line: 35, column: 1, scope: !9)
