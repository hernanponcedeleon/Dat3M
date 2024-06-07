; ModuleID = '/home/ponce/git/Dat3M/output/staticLoops.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/staticLoops.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global i32 0, align 4, !dbg !0
@.str = private unnamed_addr constant [12 x i8] c"x == 3*INCS\00", align 1
@.str.1 = private unnamed_addr constant [63 x i8] c"/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/staticLoops.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !17 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !20, metadata !DIExpression()), !dbg !22
  store i32 0, i32* %2, align 4, !dbg !22
  br label %5, !dbg !23

5:                                                ; preds = %11, %0
  %6 = load i32, i32* %2, align 4, !dbg !24
  %7 = icmp slt i32 %6, 3, !dbg !26
  br i1 %7, label %8, label %14, !dbg !27

8:                                                ; preds = %5
  %9 = load volatile i32, i32* @x, align 4, !dbg !28
  %10 = add nsw i32 %9, 1, !dbg !28
  store volatile i32 %10, i32* @x, align 4, !dbg !28
  br label %11, !dbg !29

11:                                               ; preds = %8
  %12 = load i32, i32* %2, align 4, !dbg !30
  %13 = add nsw i32 %12, 1, !dbg !30
  store i32 %13, i32* %2, align 4, !dbg !30
  br label %5, !dbg !31, !llvm.loop !32

14:                                               ; preds = %5
  call void @llvm.dbg.declare(metadata i32* %3, metadata !35, metadata !DIExpression()), !dbg !37
  store i32 -1, i32* %3, align 4, !dbg !37
  br label %15, !dbg !38

15:                                               ; preds = %21, %14
  %16 = load i32, i32* %3, align 4, !dbg !39
  %17 = icmp slt i32 %16, 2, !dbg !41
  br i1 %17, label %18, label %24, !dbg !42

18:                                               ; preds = %15
  %19 = load volatile i32, i32* @x, align 4, !dbg !43
  %20 = add nsw i32 %19, 1, !dbg !43
  store volatile i32 %20, i32* @x, align 4, !dbg !43
  br label %21, !dbg !44

21:                                               ; preds = %18
  %22 = load i32, i32* %3, align 4, !dbg !45
  %23 = add nsw i32 %22, 1, !dbg !45
  store i32 %23, i32* %3, align 4, !dbg !45
  br label %15, !dbg !46, !llvm.loop !47

24:                                               ; preds = %15
  call void @llvm.dbg.declare(metadata i32* %4, metadata !49, metadata !DIExpression()), !dbg !51
  store i32 1, i32* %4, align 4, !dbg !51
  br label %25, !dbg !52

25:                                               ; preds = %31, %24
  %26 = load i32, i32* %4, align 4, !dbg !53
  %27 = icmp slt i32 %26, 4, !dbg !55
  br i1 %27, label %28, label %34, !dbg !56

28:                                               ; preds = %25
  %29 = load volatile i32, i32* @x, align 4, !dbg !57
  %30 = add nsw i32 %29, 1, !dbg !57
  store volatile i32 %30, i32* @x, align 4, !dbg !57
  br label %31, !dbg !58

31:                                               ; preds = %28
  %32 = load i32, i32* %4, align 4, !dbg !59
  %33 = add nsw i32 %32, 1, !dbg !59
  store i32 %33, i32* %4, align 4, !dbg !59
  br label %25, !dbg !60, !llvm.loop !61

34:                                               ; preds = %25
  %35 = load volatile i32, i32* @x, align 4, !dbg !63
  %36 = icmp eq i32 %35, 9, !dbg !63
  br i1 %36, label %37, label %38, !dbg !66

37:                                               ; preds = %34
  br label %39, !dbg !66

38:                                               ; preds = %34
  call void @__assert_fail(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 19, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #3, !dbg !63
  unreachable, !dbg !63

39:                                               ; preds = %37
  ret i32 0, !dbg !67
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #2

attributes #0 = { noinline nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !6, line: 6, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 12.0.0-3ubuntu1~20.04.5", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/staticLoops.c", directory: "/home/ponce/git/Dat3M")
!4 = !{}
!5 = !{!0}
!6 = !DIFile(filename: "benchmarks/c/miscellaneous/staticLoops.c", directory: "/home/ponce/git/Dat3M")
!7 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !8)
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !9, line: 26, baseType: !10)
!9 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !11, line: 41, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !{i32 7, !"Dwarf Version", i32 4}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = !{!"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"}
!17 = distinct !DISubprogram(name: "main", scope: !6, file: !6, line: 8, type: !18, scopeLine: 9, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!18 = !DISubroutineType(types: !19)
!19 = !{!12}
!20 = !DILocalVariable(name: "i", scope: !21, file: !6, line: 10, type: !12)
!21 = distinct !DILexicalBlock(scope: !17, file: !6, line: 10, column: 5)
!22 = !DILocation(line: 10, column: 14, scope: !21)
!23 = !DILocation(line: 10, column: 10, scope: !21)
!24 = !DILocation(line: 10, column: 21, scope: !25)
!25 = distinct !DILexicalBlock(scope: !21, file: !6, line: 10, column: 5)
!26 = !DILocation(line: 10, column: 23, scope: !25)
!27 = !DILocation(line: 10, column: 5, scope: !21)
!28 = !DILocation(line: 11, column: 10, scope: !25)
!29 = !DILocation(line: 11, column: 9, scope: !25)
!30 = !DILocation(line: 10, column: 32, scope: !25)
!31 = !DILocation(line: 10, column: 5, scope: !25)
!32 = distinct !{!32, !27, !33, !34}
!33 = !DILocation(line: 11, column: 10, scope: !21)
!34 = !{!"llvm.loop.mustprogress"}
!35 = !DILocalVariable(name: "i", scope: !36, file: !6, line: 13, type: !12)
!36 = distinct !DILexicalBlock(scope: !17, file: !6, line: 13, column: 5)
!37 = !DILocation(line: 13, column: 14, scope: !36)
!38 = !DILocation(line: 13, column: 10, scope: !36)
!39 = !DILocation(line: 13, column: 22, scope: !40)
!40 = distinct !DILexicalBlock(scope: !36, file: !6, line: 13, column: 5)
!41 = !DILocation(line: 13, column: 24, scope: !40)
!42 = !DILocation(line: 13, column: 5, scope: !36)
!43 = !DILocation(line: 14, column: 10, scope: !40)
!44 = !DILocation(line: 14, column: 9, scope: !40)
!45 = !DILocation(line: 13, column: 35, scope: !40)
!46 = !DILocation(line: 13, column: 5, scope: !40)
!47 = distinct !{!47, !42, !48, !34}
!48 = !DILocation(line: 14, column: 10, scope: !36)
!49 = !DILocalVariable(name: "i", scope: !50, file: !6, line: 16, type: !12)
!50 = distinct !DILexicalBlock(scope: !17, file: !6, line: 16, column: 5)
!51 = !DILocation(line: 16, column: 14, scope: !50)
!52 = !DILocation(line: 16, column: 10, scope: !50)
!53 = !DILocation(line: 16, column: 21, scope: !54)
!54 = distinct !DILexicalBlock(scope: !50, file: !6, line: 16, column: 5)
!55 = !DILocation(line: 16, column: 23, scope: !54)
!56 = !DILocation(line: 16, column: 5, scope: !50)
!57 = !DILocation(line: 17, column: 10, scope: !54)
!58 = !DILocation(line: 17, column: 9, scope: !54)
!59 = !DILocation(line: 16, column: 34, scope: !54)
!60 = !DILocation(line: 16, column: 5, scope: !54)
!61 = distinct !{!61, !56, !62, !34}
!62 = !DILocation(line: 17, column: 10, scope: !50)
!63 = !DILocation(line: 19, column: 2, scope: !64)
!64 = distinct !DILexicalBlock(scope: !65, file: !6, line: 19, column: 2)
!65 = distinct !DILexicalBlock(scope: !17, file: !6, line: 19, column: 2)
!66 = !DILocation(line: 19, column: 2, scope: !65)
!67 = !DILocation(line: 21, column: 2, scope: !17)
