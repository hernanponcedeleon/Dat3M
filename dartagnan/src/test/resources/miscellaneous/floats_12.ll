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
  %4 = alloca double, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata float* %2, metadata !16, metadata !DIExpression()), !dbg !18
  %5 = call float @__VERIFIER_nondet_float(), !dbg !19
  store float %5, float* %2, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata double* %3, metadata !20, metadata !DIExpression()), !dbg !22
  %6 = call double @__VERIFIER_nondet_double(), !dbg !23
  store double %6, double* %3, align 8, !dbg !22
  call void @llvm.dbg.declare(metadata double* %4, metadata !24, metadata !DIExpression()), !dbg !25
  %7 = call double @__VERIFIER_nondet_double(), !dbg !26
  store double %7, double* %4, align 8, !dbg !25
  %8 = load float, float* %2, align 4, !dbg !27
  %9 = fcmp uno float %8, %8, !dbg !27
  br i1 %9, label %23, label %10, !dbg !29

10:                                               ; preds = %0
  %11 = load float, float* %2, align 4, !dbg !30
  %12 = load float, float* %2, align 4, !dbg !30
  %13 = fcmp olt float %11, %12, !dbg !30
  br i1 %13, label %15, label %14, !dbg !34

14:                                               ; preds = %10
  br label %16, !dbg !34

15:                                               ; preds = %10
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 121, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !30
  unreachable, !dbg !30

16:                                               ; preds = %14
  %17 = load float, float* %2, align 4, !dbg !35
  %18 = load float, float* %2, align 4, !dbg !35
  %19 = fcmp ogt float %17, %18, !dbg !35
  br i1 %19, label %21, label %20, !dbg !38

20:                                               ; preds = %16
  br label %22, !dbg !38

21:                                               ; preds = %16
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 122, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !35
  unreachable, !dbg !35

22:                                               ; preds = %20
  br label %23, !dbg !39

23:                                               ; preds = %22, %0
  %24 = load float, float* %2, align 4, !dbg !40
  %25 = fcmp uno float %24, %24, !dbg !40
  br i1 %25, label %26, label %43, !dbg !42

26:                                               ; preds = %23
  %27 = load float, float* %2, align 4, !dbg !43
  %28 = load float, float* %2, align 4, !dbg !43
  %29 = fcmp oeq float %27, %28, !dbg !43
  br i1 %29, label %31, label %30, !dbg !47

30:                                               ; preds = %26
  br label %32, !dbg !47

31:                                               ; preds = %26
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 125, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !43
  unreachable, !dbg !43

32:                                               ; preds = %30
  %33 = load float, float* %2, align 4, !dbg !48
  %34 = fcmp olt float %33, 1.000000e+00, !dbg !48
  br i1 %34, label %36, label %35, !dbg !51

35:                                               ; preds = %32
  br label %37, !dbg !51

36:                                               ; preds = %32
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 126, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !48
  unreachable, !dbg !48

37:                                               ; preds = %35
  %38 = load float, float* %2, align 4, !dbg !52
  %39 = fcmp ogt float %38, 1.000000e+00, !dbg !52
  br i1 %39, label %41, label %40, !dbg !55

40:                                               ; preds = %37
  br label %42, !dbg !55

41:                                               ; preds = %37
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 127, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !52
  unreachable, !dbg !52

42:                                               ; preds = %40
  br label %43, !dbg !56

43:                                               ; preds = %42, %23
  ret i32 0, !dbg !57
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
!1 = !DIFile(filename: "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "655be55c9424586b3c1ea9b9681db180")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!10 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 11, type: !12, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!11 = !DIFile(filename: "benchmarks/miscellaneous/floats.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "655be55c9424586b3c1ea9b9681db180")
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
!24 = !DILocalVariable(name: "d2", scope: !10, file: !11, line: 14, type: !21)
!25 = !DILocation(line: 14, column: 12, scope: !10)
!26 = !DILocation(line: 14, column: 17, scope: !10)
!27 = !DILocation(line: 120, column: 10, scope: !28)
!28 = distinct !DILexicalBlock(scope: !10, file: !11, line: 120, column: 9)
!29 = !DILocation(line: 120, column: 9, scope: !10)
!30 = !DILocation(line: 121, column: 9, scope: !31)
!31 = distinct !DILexicalBlock(scope: !32, file: !11, line: 121, column: 9)
!32 = distinct !DILexicalBlock(scope: !33, file: !11, line: 121, column: 9)
!33 = distinct !DILexicalBlock(scope: !28, file: !11, line: 120, column: 20)
!34 = !DILocation(line: 121, column: 9, scope: !32)
!35 = !DILocation(line: 122, column: 9, scope: !36)
!36 = distinct !DILexicalBlock(scope: !37, file: !11, line: 122, column: 9)
!37 = distinct !DILexicalBlock(scope: !33, file: !11, line: 122, column: 9)
!38 = !DILocation(line: 122, column: 9, scope: !37)
!39 = !DILocation(line: 123, column: 5, scope: !33)
!40 = !DILocation(line: 124, column: 9, scope: !41)
!41 = distinct !DILexicalBlock(scope: !10, file: !11, line: 124, column: 9)
!42 = !DILocation(line: 124, column: 9, scope: !10)
!43 = !DILocation(line: 125, column: 9, scope: !44)
!44 = distinct !DILexicalBlock(scope: !45, file: !11, line: 125, column: 9)
!45 = distinct !DILexicalBlock(scope: !46, file: !11, line: 125, column: 9)
!46 = distinct !DILexicalBlock(scope: !41, file: !11, line: 124, column: 19)
!47 = !DILocation(line: 125, column: 9, scope: !45)
!48 = !DILocation(line: 126, column: 9, scope: !49)
!49 = distinct !DILexicalBlock(scope: !50, file: !11, line: 126, column: 9)
!50 = distinct !DILexicalBlock(scope: !46, file: !11, line: 126, column: 9)
!51 = !DILocation(line: 126, column: 9, scope: !50)
!52 = !DILocation(line: 127, column: 9, scope: !53)
!53 = distinct !DILexicalBlock(scope: !54, file: !11, line: 127, column: 9)
!54 = distinct !DILexicalBlock(scope: !46, file: !11, line: 127, column: 9)
!55 = !DILocation(line: 127, column: 9, scope: !54)
!56 = !DILocation(line: 128, column: 5, scope: !46)
!57 = !DILocation(line: 179, column: 5, scope: !10)
