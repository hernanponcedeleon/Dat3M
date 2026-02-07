; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"x == d\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1

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
  br i1 %8, label %31, label %9, !dbg !26

9:                                                ; preds = %0
  %10 = load double, double* %3, align 8, !dbg !27
  %11 = call double @llvm.fabs.f64(double %10) #4, !dbg !27
  %12 = fcmp oeq double %11, 0x7FF0000000000000, !dbg !27
  %13 = bitcast double %10 to i64, !dbg !27
  %14 = icmp slt i64 %13, 0, !dbg !27
  %15 = select i1 %14, i32 -1, i32 1, !dbg !27
  %16 = select i1 %12, i32 %15, i32 0, !dbg !27
  %17 = icmp ne i32 %16, 0, !dbg !27
  br i1 %17, label %31, label %18, !dbg !28

18:                                               ; preds = %9
  %19 = load double, double* %3, align 8, !dbg !29
  %20 = call double @llvm.fabs.f64(double %19), !dbg !30
  %21 = fcmp ogt double %20, 1.000000e+100, !dbg !31
  br i1 %21, label %22, label %31, !dbg !32

22:                                               ; preds = %18
  call void @llvm.dbg.declare(metadata double* %4, metadata !33, metadata !DIExpression()), !dbg !35
  %23 = load double, double* %3, align 8, !dbg !36
  %24 = fadd double %23, 1.000000e+00, !dbg !37
  store double %24, double* %4, align 8, !dbg !35
  %25 = load double, double* %4, align 8, !dbg !38
  %26 = load double, double* %3, align 8, !dbg !38
  %27 = fcmp oeq double %25, %26, !dbg !38
  br i1 %27, label %28, label %29, !dbg !41

28:                                               ; preds = %22
  br label %30, !dbg !41

29:                                               ; preds = %22
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 110, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !38
  unreachable, !dbg !38

30:                                               ; preds = %28
  br label %31, !dbg !42

31:                                               ; preds = %30, %18, %9, %0
  ret i32 0, !dbg !43
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
!24 = !DILocation(line: 108, column: 10, scope: !25)
!25 = distinct !DILexicalBlock(scope: !10, file: !11, line: 108, column: 9)
!26 = !DILocation(line: 108, column: 19, scope: !25)
!27 = !DILocation(line: 108, column: 23, scope: !25)
!28 = !DILocation(line: 108, column: 32, scope: !25)
!29 = !DILocation(line: 108, column: 40, scope: !25)
!30 = !DILocation(line: 108, column: 35, scope: !25)
!31 = !DILocation(line: 108, column: 43, scope: !25)
!32 = !DILocation(line: 108, column: 9, scope: !10)
!33 = !DILocalVariable(name: "x", scope: !34, file: !11, line: 109, type: !21)
!34 = distinct !DILexicalBlock(scope: !25, file: !11, line: 108, column: 52)
!35 = !DILocation(line: 109, column: 16, scope: !34)
!36 = !DILocation(line: 109, column: 20, scope: !34)
!37 = !DILocation(line: 109, column: 22, scope: !34)
!38 = !DILocation(line: 110, column: 9, scope: !39)
!39 = distinct !DILexicalBlock(scope: !40, file: !11, line: 110, column: 9)
!40 = distinct !DILexicalBlock(scope: !34, file: !11, line: 110, column: 9)
!41 = !DILocation(line: 110, column: 9, scope: !40)
!42 = !DILocation(line: 111, column: 5, scope: !34)
!43 = !DILocation(line: 165, column: 5, scope: !10)
