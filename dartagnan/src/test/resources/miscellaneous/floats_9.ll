; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [20 x i8] c"fmin(d, 1.0) == 1.0\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.2 = private unnamed_addr constant [20 x i8] c"fmax(d, 1.0) == 1.0\00", align 1
@.str.3 = private unnamed_addr constant [12 x i8] c"!signbit(m)\00", align 1

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
  %7 = load double, double* %3, align 8, !dbg !24
  %8 = fcmp uno double %7, %7, !dbg !24
  br i1 %8, label %9, label %22, !dbg !26

9:                                                ; preds = %0
  %10 = load double, double* %3, align 8, !dbg !27
  %11 = call double @llvm.minnum.f64(double %10, double 1.000000e+00), !dbg !27
  %12 = fcmp oeq double %11, 1.000000e+00, !dbg !27
  br i1 %12, label %13, label %14, !dbg !31

13:                                               ; preds = %9
  br label %15, !dbg !31

14:                                               ; preds = %9
  call void @__assert_fail(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 98, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !27
  unreachable, !dbg !27

15:                                               ; preds = %13
  %16 = load double, double* %3, align 8, !dbg !32
  %17 = call double @llvm.maxnum.f64(double %16, double 1.000000e+00), !dbg !32
  %18 = fcmp oeq double %17, 1.000000e+00, !dbg !32
  br i1 %18, label %19, label %20, !dbg !35

19:                                               ; preds = %15
  br label %21, !dbg !35

20:                                               ; preds = %15
  call void @__assert_fail(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 99, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !32
  unreachable, !dbg !32

21:                                               ; preds = %19
  br label %22, !dbg !36

22:                                               ; preds = %21, %0
  %23 = load double, double* %3, align 8, !dbg !37
  %24 = fcmp oeq double %23, 0.000000e+00, !dbg !39
  br i1 %24, label %25, label %38, !dbg !40

25:                                               ; preds = %22
  %26 = load double, double* %3, align 8, !dbg !41
  %27 = bitcast double %26 to i64, !dbg !41
  %28 = icmp slt i64 %27, 0, !dbg !41
  br i1 %28, label %29, label %38, !dbg !42

29:                                               ; preds = %25
  call void @llvm.dbg.declare(metadata double* %4, metadata !43, metadata !DIExpression()), !dbg !45
  %30 = load double, double* %3, align 8, !dbg !46
  %31 = call double @llvm.maxnum.f64(double %30, double 0.000000e+00), !dbg !47
  store double %31, double* %4, align 8, !dbg !45
  %32 = load double, double* %4, align 8, !dbg !48
  %33 = bitcast double %32 to i64, !dbg !48
  %34 = icmp slt i64 %33, 0, !dbg !48
  br i1 %34, label %36, label %35, !dbg !51

35:                                               ; preds = %29
  br label %37, !dbg !51

36:                                               ; preds = %29
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 103, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !48
  unreachable, !dbg !48

37:                                               ; preds = %35
  br label %38, !dbg !52

38:                                               ; preds = %37, %25, %22
  ret i32 0, !dbg !53
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare float @__VERIFIER_nondet_float() #2

declare double @__VERIFIER_nondet_double() #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.minnum.f64(double, double) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.maxnum.f64(double, double) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "016a68962542b9f94ab88bda45b97e2a")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!10 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 14, type: !12, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!11 = !DIFile(filename: "benchmarks/miscellaneous/floats.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "016a68962542b9f94ab88bda45b97e2a")
!12 = !DISubroutineType(types: !13)
!13 = !{!14}
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !{}
!16 = !DILocalVariable(name: "f", scope: !10, file: !11, line: 15, type: !17)
!17 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!18 = !DILocation(line: 15, column: 12, scope: !10)
!19 = !DILocation(line: 15, column: 16, scope: !10)
!20 = !DILocalVariable(name: "d", scope: !10, file: !11, line: 16, type: !21)
!21 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!22 = !DILocation(line: 16, column: 12, scope: !10)
!23 = !DILocation(line: 16, column: 16, scope: !10)
!24 = !DILocation(line: 97, column: 9, scope: !25)
!25 = distinct !DILexicalBlock(scope: !10, file: !11, line: 97, column: 9)
!26 = !DILocation(line: 97, column: 9, scope: !10)
!27 = !DILocation(line: 98, column: 9, scope: !28)
!28 = distinct !DILexicalBlock(scope: !29, file: !11, line: 98, column: 9)
!29 = distinct !DILexicalBlock(scope: !30, file: !11, line: 98, column: 9)
!30 = distinct !DILexicalBlock(scope: !25, file: !11, line: 97, column: 19)
!31 = !DILocation(line: 98, column: 9, scope: !29)
!32 = !DILocation(line: 99, column: 9, scope: !33)
!33 = distinct !DILexicalBlock(scope: !34, file: !11, line: 99, column: 9)
!34 = distinct !DILexicalBlock(scope: !30, file: !11, line: 99, column: 9)
!35 = !DILocation(line: 99, column: 9, scope: !34)
!36 = !DILocation(line: 100, column: 5, scope: !30)
!37 = !DILocation(line: 101, column: 9, scope: !38)
!38 = distinct !DILexicalBlock(scope: !10, file: !11, line: 101, column: 9)
!39 = !DILocation(line: 101, column: 11, scope: !38)
!40 = !DILocation(line: 101, column: 18, scope: !38)
!41 = !DILocation(line: 101, column: 21, scope: !38)
!42 = !DILocation(line: 101, column: 9, scope: !10)
!43 = !DILocalVariable(name: "m", scope: !44, file: !11, line: 102, type: !21)
!44 = distinct !DILexicalBlock(scope: !38, file: !11, line: 101, column: 33)
!45 = !DILocation(line: 102, column: 16, scope: !44)
!46 = !DILocation(line: 102, column: 25, scope: !44)
!47 = !DILocation(line: 102, column: 20, scope: !44)
!48 = !DILocation(line: 103, column: 9, scope: !49)
!49 = distinct !DILexicalBlock(scope: !50, file: !11, line: 103, column: 9)
!50 = distinct !DILexicalBlock(scope: !44, file: !11, line: 103, column: 9)
!51 = !DILocation(line: 103, column: 9, scope: !50)
!52 = !DILocation(line: 104, column: 5, scope: !44)
!53 = !DILocation(line: 165, column: 5, scope: !10)
