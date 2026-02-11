; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [9 x i8] c"isinf(x)\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1

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
  %9 = call double @llvm.fabs.f64(double %8), !dbg !26
  %10 = fcmp ogt double %9, 0x7FDFFFFFFFFFFFFF, !dbg !27
  br i1 %10, label %11, label %26, !dbg !28

11:                                               ; preds = %0
  call void @llvm.dbg.declare(metadata double* %4, metadata !29, metadata !DIExpression()), !dbg !31
  %12 = load double, double* %3, align 8, !dbg !32
  %13 = load double, double* %3, align 8, !dbg !33
  %14 = fadd double %12, %13, !dbg !34
  store double %14, double* %4, align 8, !dbg !31
  %15 = load double, double* %4, align 8, !dbg !35
  %16 = call double @llvm.fabs.f64(double %15) #4, !dbg !35
  %17 = fcmp oeq double %16, 0x7FF0000000000000, !dbg !35
  %18 = bitcast double %15 to i64, !dbg !35
  %19 = icmp slt i64 %18, 0, !dbg !35
  %20 = select i1 %19, i32 -1, i32 1, !dbg !35
  %21 = select i1 %17, i32 %20, i32 0, !dbg !35
  %22 = icmp ne i32 %21, 0, !dbg !35
  br i1 %22, label %23, label %24, !dbg !38

23:                                               ; preds = %11
  br label %25, !dbg !38

24:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 45, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !35
  unreachable, !dbg !35

25:                                               ; preds = %23
  br label %26, !dbg !39

26:                                               ; preds = %25, %0
  %27 = load double, double* %3, align 8, !dbg !40
  %28 = call double @llvm.fabs.f64(double %27), !dbg !42
  %29 = fcmp ogt double %28, 0x7FEFFFFFFFFFFFFF, !dbg !43
  br i1 %29, label %30, label %44, !dbg !44

30:                                               ; preds = %26
  call void @llvm.dbg.declare(metadata double* %5, metadata !45, metadata !DIExpression()), !dbg !47
  %31 = load double, double* %3, align 8, !dbg !48
  %32 = fadd double %31, 1.000000e+00, !dbg !49
  store double %32, double* %5, align 8, !dbg !47
  %33 = load double, double* %5, align 8, !dbg !50
  %34 = call double @llvm.fabs.f64(double %33) #4, !dbg !50
  %35 = fcmp oeq double %34, 0x7FF0000000000000, !dbg !50
  %36 = bitcast double %33 to i64, !dbg !50
  %37 = icmp slt i64 %36, 0, !dbg !50
  %38 = select i1 %37, i32 -1, i32 1, !dbg !50
  %39 = select i1 %35, i32 %38, i32 0, !dbg !50
  %40 = icmp ne i32 %39, 0, !dbg !50
  br i1 %40, label %41, label %42, !dbg !53

41:                                               ; preds = %30
  br label %43, !dbg !53

42:                                               ; preds = %30
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 49, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !50
  unreachable, !dbg !50

43:                                               ; preds = %41
  br label %44, !dbg !54

44:                                               ; preds = %43, %26
  ret i32 0, !dbg !55
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
!24 = !DILocation(line: 43, column: 14, scope: !25)
!25 = distinct !DILexicalBlock(scope: !10, file: !11, line: 43, column: 9)
!26 = !DILocation(line: 43, column: 9, scope: !25)
!27 = !DILocation(line: 43, column: 17, scope: !25)
!28 = !DILocation(line: 43, column: 9, scope: !10)
!29 = !DILocalVariable(name: "x", scope: !30, file: !11, line: 44, type: !21)
!30 = distinct !DILexicalBlock(scope: !25, file: !11, line: 43, column: 34)
!31 = !DILocation(line: 44, column: 16, scope: !30)
!32 = !DILocation(line: 44, column: 20, scope: !30)
!33 = !DILocation(line: 44, column: 24, scope: !30)
!34 = !DILocation(line: 44, column: 22, scope: !30)
!35 = !DILocation(line: 45, column: 9, scope: !36)
!36 = distinct !DILexicalBlock(scope: !37, file: !11, line: 45, column: 9)
!37 = distinct !DILexicalBlock(scope: !30, file: !11, line: 45, column: 9)
!38 = !DILocation(line: 45, column: 9, scope: !37)
!39 = !DILocation(line: 46, column: 5, scope: !30)
!40 = !DILocation(line: 47, column: 14, scope: !41)
!41 = distinct !DILexicalBlock(scope: !10, file: !11, line: 47, column: 9)
!42 = !DILocation(line: 47, column: 9, scope: !41)
!43 = !DILocation(line: 47, column: 17, scope: !41)
!44 = !DILocation(line: 47, column: 9, scope: !10)
!45 = !DILocalVariable(name: "x", scope: !46, file: !11, line: 48, type: !21)
!46 = distinct !DILexicalBlock(scope: !41, file: !11, line: 47, column: 34)
!47 = !DILocation(line: 48, column: 16, scope: !46)
!48 = !DILocation(line: 48, column: 20, scope: !46)
!49 = !DILocation(line: 48, column: 22, scope: !46)
!50 = !DILocation(line: 49, column: 9, scope: !51)
!51 = distinct !DILexicalBlock(scope: !52, file: !11, line: 49, column: 9)
!52 = distinct !DILexicalBlock(scope: !46, file: !11, line: 49, column: 9)
!53 = !DILocation(line: 49, column: 9, scope: !52)
!54 = !DILocation(line: 50, column: 5, scope: !46)
!55 = !DILocation(line: 165, column: 5, scope: !10)
