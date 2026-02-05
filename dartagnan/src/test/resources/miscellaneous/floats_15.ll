; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [9 x i8] c"x == 1.0\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"isnan(x)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !10 {
  %1 = alloca i32, align 4
  %2 = alloca float, align 4
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata float* %2, metadata !16, metadata !DIExpression()), !dbg !18
  %6 = call float @__VERIFIER_nondet_float(), !dbg !19
  store float %6, float* %2, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata double* %3, metadata !20, metadata !DIExpression()), !dbg !22
  %7 = call double @__VERIFIER_nondet_double(), !dbg !23
  store double %7, double* %3, align 8, !dbg !22
  %8 = load double, double* %3, align 8, !dbg !24
  %9 = fcmp uno double %8, %8, !dbg !24
  br i1 %9, label %31, label %10, !dbg !26

10:                                               ; preds = %0
  %11 = load double, double* %3, align 8, !dbg !27
  %12 = call double @llvm.fabs.f64(double %11) #4, !dbg !27
  %13 = fcmp oeq double %12, 0x7FF0000000000000, !dbg !27
  %14 = bitcast double %11 to i64, !dbg !27
  %15 = icmp slt i64 %14, 0, !dbg !27
  %16 = select i1 %15, i32 -1, i32 1, !dbg !27
  %17 = select i1 %13, i32 %16, i32 0, !dbg !27
  %18 = icmp ne i32 %17, 0, !dbg !27
  br i1 %18, label %31, label %19, !dbg !28

19:                                               ; preds = %10
  %20 = load double, double* %3, align 8, !dbg !29
  %21 = fcmp une double %20, 0.000000e+00, !dbg !30
  br i1 %21, label %22, label %31, !dbg !31

22:                                               ; preds = %19
  call void @llvm.dbg.declare(metadata double* %4, metadata !32, metadata !DIExpression()), !dbg !34
  %23 = load double, double* %3, align 8, !dbg !35
  %24 = load double, double* %3, align 8, !dbg !36
  %25 = fdiv double %23, %24, !dbg !37
  store double %25, double* %4, align 8, !dbg !34
  %26 = load double, double* %4, align 8, !dbg !38
  %27 = fcmp oeq double %26, 1.000000e+00, !dbg !38
  br i1 %27, label %28, label %29, !dbg !41

28:                                               ; preds = %22
  br label %30, !dbg !41

29:                                               ; preds = %22
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 154, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !38
  unreachable, !dbg !38

30:                                               ; preds = %28
  br label %31, !dbg !42

31:                                               ; preds = %30, %19, %10, %0
  %32 = load double, double* %3, align 8, !dbg !43
  %33 = fcmp oeq double %32, 0.000000e+00, !dbg !45
  br i1 %33, label %34, label %43, !dbg !46

34:                                               ; preds = %31
  call void @llvm.dbg.declare(metadata double* %5, metadata !47, metadata !DIExpression()), !dbg !49
  %35 = load double, double* %3, align 8, !dbg !50
  %36 = load double, double* %3, align 8, !dbg !51
  %37 = fdiv double %35, %36, !dbg !52
  store double %37, double* %5, align 8, !dbg !49
  %38 = load double, double* %5, align 8, !dbg !53
  %39 = fcmp uno double %38, %38, !dbg !53
  br i1 %39, label %40, label %41, !dbg !56

40:                                               ; preds = %34
  br label %42, !dbg !56

41:                                               ; preds = %34
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 158, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !53
  unreachable, !dbg !53

42:                                               ; preds = %40
  br label %43, !dbg !57

43:                                               ; preds = %42, %31
  ret i32 0, !dbg !58
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare float @__VERIFIER_nondet_float() #2

declare double @__VERIFIER_nondet_double() #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fabs.f64(double) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { readnone }
attributes #5 = { noreturn nounwind }

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
!24 = !DILocation(line: 152, column: 10, scope: !25)
!25 = distinct !DILexicalBlock(scope: !10, file: !11, line: 152, column: 9)
!26 = !DILocation(line: 152, column: 19, scope: !25)
!27 = !DILocation(line: 152, column: 23, scope: !25)
!28 = !DILocation(line: 152, column: 32, scope: !25)
!29 = !DILocation(line: 152, column: 35, scope: !25)
!30 = !DILocation(line: 152, column: 37, scope: !25)
!31 = !DILocation(line: 152, column: 9, scope: !10)
!32 = !DILocalVariable(name: "x", scope: !33, file: !11, line: 153, type: !21)
!33 = distinct !DILexicalBlock(scope: !25, file: !11, line: 152, column: 45)
!34 = !DILocation(line: 153, column: 16, scope: !33)
!35 = !DILocation(line: 153, column: 20, scope: !33)
!36 = !DILocation(line: 153, column: 24, scope: !33)
!37 = !DILocation(line: 153, column: 22, scope: !33)
!38 = !DILocation(line: 154, column: 9, scope: !39)
!39 = distinct !DILexicalBlock(scope: !40, file: !11, line: 154, column: 9)
!40 = distinct !DILexicalBlock(scope: !33, file: !11, line: 154, column: 9)
!41 = !DILocation(line: 154, column: 9, scope: !40)
!42 = !DILocation(line: 155, column: 5, scope: !33)
!43 = !DILocation(line: 156, column: 9, scope: !44)
!44 = distinct !DILexicalBlock(scope: !10, file: !11, line: 156, column: 9)
!45 = !DILocation(line: 156, column: 11, scope: !44)
!46 = !DILocation(line: 156, column: 9, scope: !10)
!47 = !DILocalVariable(name: "x", scope: !48, file: !11, line: 157, type: !21)
!48 = distinct !DILexicalBlock(scope: !44, file: !11, line: 156, column: 19)
!49 = !DILocation(line: 157, column: 16, scope: !48)
!50 = !DILocation(line: 157, column: 20, scope: !48)
!51 = !DILocation(line: 157, column: 24, scope: !48)
!52 = !DILocation(line: 157, column: 22, scope: !48)
!53 = !DILocation(line: 158, column: 9, scope: !54)
!54 = distinct !DILexicalBlock(scope: !55, file: !11, line: 158, column: 9)
!55 = distinct !DILexicalBlock(scope: !48, file: !11, line: 158, column: 9)
!56 = !DILocation(line: 158, column: 9, scope: !55)
!57 = !DILocation(line: 159, column: 5, scope: !48)
!58 = !DILocation(line: 165, column: 5, scope: !10)
