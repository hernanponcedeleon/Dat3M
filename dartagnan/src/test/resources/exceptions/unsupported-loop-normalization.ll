; ModuleID = '/home/drc/git/Dat3M/output/unsupported-loop-normalization.ll'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/unsupported-loop-normalization.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"x == 6\00", align 1
@.str.1 = private unnamed_addr constant [78 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/unsupported-loop-normalization.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !10 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !16, metadata !DIExpression()), !dbg !18
  %3 = call i32 @__VERIFIER_nondet_uint(), !dbg !19
  store i32 %3, i32* %2, align 4, !dbg !18
  br label %4, !dbg !20

4:                                                ; preds = %0
  call void @llvm.dbg.label(metadata !21), !dbg !22
  %5 = load i32, i32* %2, align 4, !dbg !23
  %6 = icmp uge i32 %5, 1, !dbg !25
  br i1 %6, label %7, label %8, !dbg !26

7:                                                ; preds = %4
  store i32 4, i32* %2, align 4, !dbg !27
  br label %9, !dbg !29

8:                                                ; preds = %4
  br label %34, !dbg !30

9:                                                ; preds = %37, %7
  call void @llvm.dbg.label(metadata !32), !dbg !33
  %10 = load i32, i32* %2, align 4, !dbg !34
  %11 = icmp ugt i32 %10, 3, !dbg !36
  br i1 %11, label %12, label %13, !dbg !37

12:                                               ; preds = %9
  br label %14, !dbg !38

13:                                               ; preds = %9
  br label %21, !dbg !40

14:                                               ; preds = %24, %12
  call void @llvm.dbg.label(metadata !42), !dbg !43
  %15 = load i32, i32* %2, align 4, !dbg !44
  %16 = add i32 %15, 1, !dbg !44
  store i32 %16, i32* %2, align 4, !dbg !44
  %17 = load i32, i32* %2, align 4, !dbg !45
  %18 = icmp ugt i32 %17, 5, !dbg !47
  br i1 %18, label %19, label %20, !dbg !48

19:                                               ; preds = %14
  br label %39, !dbg !49

20:                                               ; preds = %14
  br label %21, !dbg !51

21:                                               ; preds = %20, %13
  call void @llvm.dbg.label(metadata !53), !dbg !54
  %22 = load i32, i32* %2, align 4, !dbg !55
  %23 = icmp ult i32 %22, 4, !dbg !57
  br i1 %23, label %24, label %25, !dbg !58

24:                                               ; preds = %21
  br label %14, !dbg !59

25:                                               ; preds = %21
  br label %26, !dbg !61

26:                                               ; preds = %25
  call void @llvm.dbg.label(metadata !63), !dbg !64
  %27 = load i32, i32* %2, align 4, !dbg !65
  %28 = icmp ult i32 %27, 3, !dbg !67
  br i1 %28, label %29, label %30, !dbg !68

29:                                               ; preds = %26
  br label %34, !dbg !69

30:                                               ; preds = %26
  br label %31, !dbg !71

31:                                               ; preds = %38, %30
  call void @llvm.dbg.label(metadata !73), !dbg !74
  %32 = load i32, i32* %2, align 4, !dbg !75
  %33 = add i32 %32, 1, !dbg !75
  store i32 %33, i32* %2, align 4, !dbg !75
  br label %34, !dbg !76

34:                                               ; preds = %31, %29, %8
  call void @llvm.dbg.label(metadata !77), !dbg !78
  %35 = load i32, i32* %2, align 4, !dbg !79
  %36 = icmp ugt i32 %35, 2, !dbg !81
  br i1 %36, label %37, label %38, !dbg !82

37:                                               ; preds = %34
  br label %9, !dbg !83

38:                                               ; preds = %34
  br label %31, !dbg !85

39:                                               ; preds = %19
  call void @llvm.dbg.label(metadata !87), !dbg !88
  %40 = load i32, i32* %2, align 4, !dbg !89
  %41 = icmp eq i32 %40, 6, !dbg !89
  br i1 %41, label %42, label %43, !dbg !92

42:                                               ; preds = %39
  br label %44, !dbg !92

43:                                               ; preds = %39
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 57, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !89
  unreachable, !dbg !89

44:                                               ; preds = %42
  %45 = load i32, i32* %1, align 4, !dbg !93
  ret i32 %45, !dbg !93
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @__VERIFIER_nondet_uint() #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/drc/git/Dat3M/benchmarks/miscellaneous/unsupported-loop-normalization.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "9e7cb84fbc836969402dbe7a76c7dd09")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!10 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 4, type: !12, scopeLine: 5, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!11 = !DIFile(filename: "benchmarks/miscellaneous/unsupported-loop-normalization.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "9e7cb84fbc836969402dbe7a76c7dd09")
!12 = !DISubroutineType(types: !13)
!13 = !{!14}
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !{}
!16 = !DILocalVariable(name: "x", scope: !10, file: !11, line: 6, type: !17)
!17 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!18 = !DILocation(line: 6, column: 15, scope: !10)
!19 = !DILocation(line: 6, column: 19, scope: !10)
!20 = !DILocation(line: 6, column: 2, scope: !10)
!21 = !DILabel(scope: !10, name: "A", file: !11, line: 7)
!22 = !DILocation(line: 7, column: 1, scope: !10)
!23 = !DILocation(line: 8, column: 6, scope: !24)
!24 = distinct !DILexicalBlock(scope: !10, file: !11, line: 8, column: 6)
!25 = !DILocation(line: 8, column: 8, scope: !24)
!26 = !DILocation(line: 8, column: 6, scope: !10)
!27 = !DILocation(line: 9, column: 5, scope: !28)
!28 = distinct !DILexicalBlock(scope: !24, file: !11, line: 8, column: 14)
!29 = !DILocation(line: 10, column: 3, scope: !28)
!30 = !DILocation(line: 12, column: 3, scope: !31)
!31 = distinct !DILexicalBlock(scope: !24, file: !11, line: 11, column: 9)
!32 = !DILabel(scope: !10, name: "B", file: !11, line: 14)
!33 = !DILocation(line: 14, column: 1, scope: !10)
!34 = !DILocation(line: 16, column: 6, scope: !35)
!35 = distinct !DILexicalBlock(scope: !10, file: !11, line: 16, column: 6)
!36 = !DILocation(line: 16, column: 8, scope: !35)
!37 = !DILocation(line: 16, column: 6, scope: !10)
!38 = !DILocation(line: 17, column: 3, scope: !39)
!39 = distinct !DILexicalBlock(scope: !35, file: !11, line: 16, column: 13)
!40 = !DILocation(line: 19, column: 3, scope: !41)
!41 = distinct !DILexicalBlock(scope: !35, file: !11, line: 18, column: 9)
!42 = !DILabel(scope: !10, name: "D", file: !11, line: 21)
!43 = !DILocation(line: 21, column: 1, scope: !10)
!44 = !DILocation(line: 23, column: 3, scope: !10)
!45 = !DILocation(line: 25, column: 6, scope: !46)
!46 = distinct !DILexicalBlock(scope: !10, file: !11, line: 25, column: 6)
!47 = !DILocation(line: 25, column: 8, scope: !46)
!48 = !DILocation(line: 25, column: 6, scope: !10)
!49 = !DILocation(line: 26, column: 3, scope: !50)
!50 = distinct !DILexicalBlock(scope: !46, file: !11, line: 25, column: 13)
!51 = !DILocation(line: 28, column: 3, scope: !52)
!52 = distinct !DILexicalBlock(scope: !46, file: !11, line: 27, column: 9)
!53 = !DILabel(scope: !10, name: "E", file: !11, line: 30)
!54 = !DILocation(line: 30, column: 1, scope: !10)
!55 = !DILocation(line: 32, column: 6, scope: !56)
!56 = distinct !DILexicalBlock(scope: !10, file: !11, line: 32, column: 6)
!57 = !DILocation(line: 32, column: 8, scope: !56)
!58 = !DILocation(line: 32, column: 6, scope: !10)
!59 = !DILocation(line: 33, column: 3, scope: !60)
!60 = distinct !DILexicalBlock(scope: !56, file: !11, line: 32, column: 13)
!61 = !DILocation(line: 35, column: 3, scope: !62)
!62 = distinct !DILexicalBlock(scope: !56, file: !11, line: 34, column: 9)
!63 = !DILabel(scope: !10, name: "F", file: !11, line: 37)
!64 = !DILocation(line: 37, column: 1, scope: !10)
!65 = !DILocation(line: 39, column: 6, scope: !66)
!66 = distinct !DILexicalBlock(scope: !10, file: !11, line: 39, column: 6)
!67 = !DILocation(line: 39, column: 8, scope: !66)
!68 = !DILocation(line: 39, column: 6, scope: !10)
!69 = !DILocation(line: 40, column: 3, scope: !70)
!70 = distinct !DILexicalBlock(scope: !66, file: !11, line: 39, column: 13)
!71 = !DILocation(line: 42, column: 3, scope: !72)
!72 = distinct !DILexicalBlock(scope: !66, file: !11, line: 41, column: 9)
!73 = !DILabel(scope: !10, name: "G", file: !11, line: 44)
!74 = !DILocation(line: 44, column: 1, scope: !10)
!75 = !DILocation(line: 46, column: 3, scope: !10)
!76 = !DILocation(line: 47, column: 2, scope: !10)
!77 = !DILabel(scope: !10, name: "C", file: !11, line: 48)
!78 = !DILocation(line: 48, column: 1, scope: !10)
!79 = !DILocation(line: 50, column: 6, scope: !80)
!80 = distinct !DILexicalBlock(scope: !10, file: !11, line: 50, column: 6)
!81 = !DILocation(line: 50, column: 8, scope: !80)
!82 = !DILocation(line: 50, column: 6, scope: !10)
!83 = !DILocation(line: 51, column: 3, scope: !84)
!84 = distinct !DILexicalBlock(scope: !80, file: !11, line: 50, column: 13)
!85 = !DILocation(line: 53, column: 3, scope: !86)
!86 = distinct !DILexicalBlock(scope: !80, file: !11, line: 52, column: 9)
!87 = !DILabel(scope: !10, name: "Halt", file: !11, line: 55)
!88 = !DILocation(line: 55, column: 1, scope: !10)
!89 = !DILocation(line: 57, column: 2, scope: !90)
!90 = distinct !DILexicalBlock(scope: !91, file: !11, line: 57, column: 2)
!91 = distinct !DILexicalBlock(scope: !10, file: !11, line: 57, column: 2)
!92 = !DILocation(line: 57, column: 2, scope: !91)
!93 = !DILocation(line: 58, column: 1, scope: !10)
