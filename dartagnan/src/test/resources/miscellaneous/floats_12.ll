; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [9 x i8] c"!(f < f)\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"!(f > f)\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"!(f == f)\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"!(f < 1.0f)\00", align 1
@.str.5 = private unnamed_addr constant [12 x i8] c"!(f > 1.0f)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !10 {
  %1 = alloca i32, align 4
  %2 = alloca float, align 4
  %3 = alloca double, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata float* %2, metadata !16, metadata !DIExpression()), !dbg !18
  %4 = call float @__VERIFIER_nondet_float(), !dbg !19
  store float %4, float* %2, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata double* %3, metadata !20, metadata !DIExpression()), !dbg !22
  %5 = call double @__VERIFIER_nondet_double(), !dbg !23
  store double %5, double* %3, align 8, !dbg !22
  %6 = load float, float* %2, align 4, !dbg !24
  %7 = fcmp uno float %6, %6, !dbg !24
  br i1 %7, label %21, label %8, !dbg !26

8:                                                ; preds = %0
  %9 = load float, float* %2, align 4, !dbg !27
  %10 = load float, float* %2, align 4, !dbg !27
  %11 = fcmp olt float %9, %10, !dbg !27
  br i1 %11, label %13, label %12, !dbg !31

12:                                               ; preds = %8
  br label %14, !dbg !31

13:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 124, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !27
  unreachable, !dbg !27

14:                                               ; preds = %12
  %15 = load float, float* %2, align 4, !dbg !32
  %16 = load float, float* %2, align 4, !dbg !32
  %17 = fcmp ogt float %15, %16, !dbg !32
  br i1 %17, label %19, label %18, !dbg !35

18:                                               ; preds = %14
  br label %20, !dbg !35

19:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 125, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !32
  unreachable, !dbg !32

20:                                               ; preds = %18
  br label %21, !dbg !36

21:                                               ; preds = %20, %0
  %22 = load float, float* %2, align 4, !dbg !37
  %23 = fcmp uno float %22, %22, !dbg !37
  br i1 %23, label %24, label %41, !dbg !39

24:                                               ; preds = %21
  %25 = load float, float* %2, align 4, !dbg !40
  %26 = load float, float* %2, align 4, !dbg !40
  %27 = fcmp oeq float %25, %26, !dbg !40
  br i1 %27, label %29, label %28, !dbg !44

28:                                               ; preds = %24
  br label %30, !dbg !44

29:                                               ; preds = %24
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 128, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !40
  unreachable, !dbg !40

30:                                               ; preds = %28
  %31 = load float, float* %2, align 4, !dbg !45
  %32 = fcmp olt float %31, 1.000000e+00, !dbg !45
  br i1 %32, label %34, label %33, !dbg !48

33:                                               ; preds = %30
  br label %35, !dbg !48

34:                                               ; preds = %30
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 129, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !45
  unreachable, !dbg !45

35:                                               ; preds = %33
  %36 = load float, float* %2, align 4, !dbg !49
  %37 = fcmp ogt float %36, 1.000000e+00, !dbg !49
  br i1 %37, label %39, label %38, !dbg !52

38:                                               ; preds = %35
  br label %40, !dbg !52

39:                                               ; preds = %35
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 130, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !49
  unreachable, !dbg !49

40:                                               ; preds = %38
  br label %41, !dbg !53

41:                                               ; preds = %40, %21
  ret i32 0, !dbg !54
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare float @__VERIFIER_nondet_float() #2

declare double @__VERIFIER_nondet_double() #2

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
!1 = !DIFile(filename: "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "4723053dddf493d2cabef543d9d3ad92")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!10 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 11, type: !12, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!11 = !DIFile(filename: "benchmarks/miscellaneous/floats.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "4723053dddf493d2cabef543d9d3ad92")
!12 = !DISubroutineType(types: !13)
!13 = !{!14}
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !{}
!16 = !DILocalVariable(name: "f", scope: !10, file: !11, line: 12, type: !17)
!17 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!18 = !DILocation(line: 12, column: 12, scope: !10)
!19 = !DILocation(line: 12, column: 16, scope: !10)
!20 = !DILocalVariable(name: "d", scope: !10, file: !11, line: 13, type: !21)
!21 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!22 = !DILocation(line: 13, column: 12, scope: !10)
!23 = !DILocation(line: 13, column: 16, scope: !10)
!24 = !DILocation(line: 123, column: 10, scope: !25)
!25 = distinct !DILexicalBlock(scope: !10, file: !11, line: 123, column: 9)
!26 = !DILocation(line: 123, column: 9, scope: !10)
!27 = !DILocation(line: 124, column: 9, scope: !28)
!28 = distinct !DILexicalBlock(scope: !29, file: !11, line: 124, column: 9)
!29 = distinct !DILexicalBlock(scope: !30, file: !11, line: 124, column: 9)
!30 = distinct !DILexicalBlock(scope: !25, file: !11, line: 123, column: 20)
!31 = !DILocation(line: 124, column: 9, scope: !29)
!32 = !DILocation(line: 125, column: 9, scope: !33)
!33 = distinct !DILexicalBlock(scope: !34, file: !11, line: 125, column: 9)
!34 = distinct !DILexicalBlock(scope: !30, file: !11, line: 125, column: 9)
!35 = !DILocation(line: 125, column: 9, scope: !34)
!36 = !DILocation(line: 126, column: 5, scope: !30)
!37 = !DILocation(line: 127, column: 9, scope: !38)
!38 = distinct !DILexicalBlock(scope: !10, file: !11, line: 127, column: 9)
!39 = !DILocation(line: 127, column: 9, scope: !10)
!40 = !DILocation(line: 128, column: 9, scope: !41)
!41 = distinct !DILexicalBlock(scope: !42, file: !11, line: 128, column: 9)
!42 = distinct !DILexicalBlock(scope: !43, file: !11, line: 128, column: 9)
!43 = distinct !DILexicalBlock(scope: !38, file: !11, line: 127, column: 19)
!44 = !DILocation(line: 128, column: 9, scope: !42)
!45 = !DILocation(line: 129, column: 9, scope: !46)
!46 = distinct !DILexicalBlock(scope: !47, file: !11, line: 129, column: 9)
!47 = distinct !DILexicalBlock(scope: !43, file: !11, line: 129, column: 9)
!48 = !DILocation(line: 129, column: 9, scope: !47)
!49 = !DILocation(line: 130, column: 9, scope: !50)
!50 = distinct !DILexicalBlock(scope: !51, file: !11, line: 130, column: 9)
!51 = distinct !DILexicalBlock(scope: !43, file: !11, line: 130, column: 9)
!52 = !DILocation(line: 130, column: 9, scope: !51)
!53 = !DILocation(line: 131, column: 5, scope: !43)
!54 = !DILocation(line: 155, column: 5, scope: !10)
