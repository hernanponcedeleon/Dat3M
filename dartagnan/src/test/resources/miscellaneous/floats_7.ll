; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"isnan(d + 1.0)\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.2 = private unnamed_addr constant [15 x i8] c"isnan(d * 2.0)\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"!(d == d)\00", align 1
@.str.4 = private unnamed_addr constant [11 x i8] c"!(d < 0.0)\00", align 1
@.str.5 = private unnamed_addr constant [11 x i8] c"!(d > 0.0)\00", align 1

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
  %6 = load double, double* %3, align 8, !dbg !24
  %7 = fcmp uno double %6, %6, !dbg !24
  br i1 %7, label %8, label %37, !dbg !26

8:                                                ; preds = %0
  %9 = load double, double* %3, align 8, !dbg !27
  %10 = fadd double %9, 1.000000e+00, !dbg !27
  %11 = fcmp uno double %10, %10, !dbg !27
  br i1 %11, label %12, label %13, !dbg !31

12:                                               ; preds = %8
  br label %14, !dbg !31

13:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 76, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !27
  unreachable, !dbg !27

14:                                               ; preds = %12
  %15 = load double, double* %3, align 8, !dbg !32
  %16 = fmul double %15, 2.000000e+00, !dbg !32
  %17 = fcmp uno double %16, %16, !dbg !32
  br i1 %17, label %18, label %19, !dbg !35

18:                                               ; preds = %14
  br label %20, !dbg !35

19:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 77, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !32
  unreachable, !dbg !32

20:                                               ; preds = %18
  %21 = load double, double* %3, align 8, !dbg !36
  %22 = load double, double* %3, align 8, !dbg !36
  %23 = fcmp oeq double %21, %22, !dbg !36
  br i1 %23, label %25, label %24, !dbg !39

24:                                               ; preds = %20
  br label %26, !dbg !39

25:                                               ; preds = %20
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 78, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !36
  unreachable, !dbg !36

26:                                               ; preds = %24
  %27 = load double, double* %3, align 8, !dbg !40
  %28 = fcmp olt double %27, 0.000000e+00, !dbg !40
  br i1 %28, label %30, label %29, !dbg !43

29:                                               ; preds = %26
  br label %31, !dbg !43

30:                                               ; preds = %26
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 79, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !40
  unreachable, !dbg !40

31:                                               ; preds = %29
  %32 = load double, double* %3, align 8, !dbg !44
  %33 = fcmp ogt double %32, 0.000000e+00, !dbg !44
  br i1 %33, label %35, label %34, !dbg !47

34:                                               ; preds = %31
  br label %36, !dbg !47

35:                                               ; preds = %31
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 80, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !44
  unreachable, !dbg !44

36:                                               ; preds = %34
  br label %37, !dbg !48

37:                                               ; preds = %36, %0
  ret i32 0, !dbg !49
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
!24 = !DILocation(line: 75, column: 9, scope: !25)
!25 = distinct !DILexicalBlock(scope: !10, file: !11, line: 75, column: 9)
!26 = !DILocation(line: 75, column: 9, scope: !10)
!27 = !DILocation(line: 76, column: 9, scope: !28)
!28 = distinct !DILexicalBlock(scope: !29, file: !11, line: 76, column: 9)
!29 = distinct !DILexicalBlock(scope: !30, file: !11, line: 76, column: 9)
!30 = distinct !DILexicalBlock(scope: !25, file: !11, line: 75, column: 19)
!31 = !DILocation(line: 76, column: 9, scope: !29)
!32 = !DILocation(line: 77, column: 9, scope: !33)
!33 = distinct !DILexicalBlock(scope: !34, file: !11, line: 77, column: 9)
!34 = distinct !DILexicalBlock(scope: !30, file: !11, line: 77, column: 9)
!35 = !DILocation(line: 77, column: 9, scope: !34)
!36 = !DILocation(line: 78, column: 9, scope: !37)
!37 = distinct !DILexicalBlock(scope: !38, file: !11, line: 78, column: 9)
!38 = distinct !DILexicalBlock(scope: !30, file: !11, line: 78, column: 9)
!39 = !DILocation(line: 78, column: 9, scope: !38)
!40 = !DILocation(line: 79, column: 9, scope: !41)
!41 = distinct !DILexicalBlock(scope: !42, file: !11, line: 79, column: 9)
!42 = distinct !DILexicalBlock(scope: !30, file: !11, line: 79, column: 9)
!43 = !DILocation(line: 79, column: 9, scope: !42)
!44 = !DILocation(line: 80, column: 9, scope: !45)
!45 = distinct !DILexicalBlock(scope: !46, file: !11, line: 80, column: 9)
!46 = distinct !DILexicalBlock(scope: !30, file: !11, line: 80, column: 9)
!47 = !DILocation(line: 80, column: 9, scope: !46)
!48 = !DILocation(line: 81, column: 5, scope: !30)
!49 = !DILocation(line: 165, column: 5, scope: !10)
