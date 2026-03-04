; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [11 x i8] c"isinf(inv)\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.2 = private unnamed_addr constant [14 x i8] c"!signbit(inv)\00", align 1
@.str.3 = private unnamed_addr constant [13 x i8] c"signbit(inv)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !10 {
  %1 = alloca i32, align 4
  %2 = alloca float, align 4
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca float, align 4
  %6 = alloca float, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata float* %2, metadata !16, metadata !DIExpression()), !dbg !18
  %7 = call float @__VERIFIER_nondet_float(), !dbg !19
  store float %7, float* %2, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata double* %3, metadata !20, metadata !DIExpression()), !dbg !22
  %8 = call double @__VERIFIER_nondet_double(), !dbg !23
  store double %8, double* %3, align 8, !dbg !22
  call void @llvm.dbg.declare(metadata double* %4, metadata !24, metadata !DIExpression()), !dbg !25
  %9 = call double @__VERIFIER_nondet_double(), !dbg !26
  store double %9, double* %4, align 8, !dbg !25
  %10 = load float, float* %2, align 4, !dbg !27
  %11 = fcmp oeq float %10, 0.000000e+00, !dbg !29
  br i1 %11, label %12, label %36, !dbg !30

12:                                               ; preds = %0
  %13 = load float, float* %2, align 4, !dbg !31
  %14 = bitcast float %13 to i32, !dbg !31
  %15 = icmp slt i32 %14, 0, !dbg !31
  br i1 %15, label %36, label %16, !dbg !32

16:                                               ; preds = %12
  call void @llvm.dbg.declare(metadata float* %5, metadata !33, metadata !DIExpression()), !dbg !35
  %17 = load float, float* %2, align 4, !dbg !36
  %18 = fdiv float 1.000000e+00, %17, !dbg !37
  store float %18, float* %5, align 4, !dbg !35
  %19 = load float, float* %5, align 4, !dbg !38
  %20 = call float @llvm.fabs.f32(float %19) #4, !dbg !38
  %21 = fcmp oeq float %20, 0x7FF0000000000000, !dbg !38
  %22 = bitcast float %19 to i32, !dbg !38
  %23 = icmp slt i32 %22, 0, !dbg !38
  %24 = select i1 %23, i32 -1, i32 1, !dbg !38
  %25 = select i1 %21, i32 %24, i32 0, !dbg !38
  %26 = icmp ne i32 %25, 0, !dbg !38
  br i1 %26, label %27, label %28, !dbg !41

27:                                               ; preds = %16
  br label %29, !dbg !41

28:                                               ; preds = %16
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 30, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !38
  unreachable, !dbg !38

29:                                               ; preds = %27
  %30 = load float, float* %5, align 4, !dbg !42
  %31 = bitcast float %30 to i32, !dbg !42
  %32 = icmp slt i32 %31, 0, !dbg !42
  br i1 %32, label %34, label %33, !dbg !45

33:                                               ; preds = %29
  br label %35, !dbg !45

34:                                               ; preds = %29
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 31, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !42
  unreachable, !dbg !42

35:                                               ; preds = %33
  br label %36, !dbg !46

36:                                               ; preds = %35, %12, %0
  %37 = load float, float* %2, align 4, !dbg !47
  %38 = fcmp oeq float %37, 0.000000e+00, !dbg !49
  br i1 %38, label %39, label %63, !dbg !50

39:                                               ; preds = %36
  %40 = load float, float* %2, align 4, !dbg !51
  %41 = bitcast float %40 to i32, !dbg !51
  %42 = icmp slt i32 %41, 0, !dbg !51
  br i1 %42, label %43, label %63, !dbg !52

43:                                               ; preds = %39
  call void @llvm.dbg.declare(metadata float* %6, metadata !53, metadata !DIExpression()), !dbg !55
  %44 = load float, float* %2, align 4, !dbg !56
  %45 = fdiv float 1.000000e+00, %44, !dbg !57
  store float %45, float* %6, align 4, !dbg !55
  %46 = load float, float* %6, align 4, !dbg !58
  %47 = call float @llvm.fabs.f32(float %46) #4, !dbg !58
  %48 = fcmp oeq float %47, 0x7FF0000000000000, !dbg !58
  %49 = bitcast float %46 to i32, !dbg !58
  %50 = icmp slt i32 %49, 0, !dbg !58
  %51 = select i1 %50, i32 -1, i32 1, !dbg !58
  %52 = select i1 %48, i32 %51, i32 0, !dbg !58
  %53 = icmp ne i32 %52, 0, !dbg !58
  br i1 %53, label %54, label %55, !dbg !61

54:                                               ; preds = %43
  br label %56, !dbg !61

55:                                               ; preds = %43
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 35, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !58
  unreachable, !dbg !58

56:                                               ; preds = %54
  %57 = load float, float* %6, align 4, !dbg !62
  %58 = bitcast float %57 to i32, !dbg !62
  %59 = icmp slt i32 %58, 0, !dbg !62
  br i1 %59, label %60, label %61, !dbg !65

60:                                               ; preds = %56
  br label %62, !dbg !65

61:                                               ; preds = %56
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 36, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !62
  unreachable, !dbg !62

62:                                               ; preds = %60
  br label %63, !dbg !66

63:                                               ; preds = %62, %39, %36
  ret i32 0, !dbg !67
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare float @__VERIFIER_nondet_float() #2

declare double @__VERIFIER_nondet_double() #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare float @llvm.fabs.f32(float) #1

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
!27 = !DILocation(line: 28, column: 9, scope: !28)
!28 = distinct !DILexicalBlock(scope: !10, file: !11, line: 28, column: 9)
!29 = !DILocation(line: 28, column: 11, scope: !28)
!30 = !DILocation(line: 28, column: 19, scope: !28)
!31 = !DILocation(line: 28, column: 23, scope: !28)
!32 = !DILocation(line: 28, column: 9, scope: !10)
!33 = !DILocalVariable(name: "inv", scope: !34, file: !11, line: 29, type: !17)
!34 = distinct !DILexicalBlock(scope: !28, file: !11, line: 28, column: 35)
!35 = !DILocation(line: 29, column: 15, scope: !34)
!36 = !DILocation(line: 29, column: 28, scope: !34)
!37 = !DILocation(line: 29, column: 26, scope: !34)
!38 = !DILocation(line: 30, column: 9, scope: !39)
!39 = distinct !DILexicalBlock(scope: !40, file: !11, line: 30, column: 9)
!40 = distinct !DILexicalBlock(scope: !34, file: !11, line: 30, column: 9)
!41 = !DILocation(line: 30, column: 9, scope: !40)
!42 = !DILocation(line: 31, column: 9, scope: !43)
!43 = distinct !DILexicalBlock(scope: !44, file: !11, line: 31, column: 9)
!44 = distinct !DILexicalBlock(scope: !34, file: !11, line: 31, column: 9)
!45 = !DILocation(line: 31, column: 9, scope: !44)
!46 = !DILocation(line: 32, column: 5, scope: !34)
!47 = !DILocation(line: 33, column: 9, scope: !48)
!48 = distinct !DILexicalBlock(scope: !10, file: !11, line: 33, column: 9)
!49 = !DILocation(line: 33, column: 11, scope: !48)
!50 = !DILocation(line: 33, column: 19, scope: !48)
!51 = !DILocation(line: 33, column: 22, scope: !48)
!52 = !DILocation(line: 33, column: 9, scope: !10)
!53 = !DILocalVariable(name: "inv", scope: !54, file: !11, line: 34, type: !17)
!54 = distinct !DILexicalBlock(scope: !48, file: !11, line: 33, column: 34)
!55 = !DILocation(line: 34, column: 15, scope: !54)
!56 = !DILocation(line: 34, column: 28, scope: !54)
!57 = !DILocation(line: 34, column: 26, scope: !54)
!58 = !DILocation(line: 35, column: 9, scope: !59)
!59 = distinct !DILexicalBlock(scope: !60, file: !11, line: 35, column: 9)
!60 = distinct !DILexicalBlock(scope: !54, file: !11, line: 35, column: 9)
!61 = !DILocation(line: 35, column: 9, scope: !60)
!62 = !DILocation(line: 36, column: 9, scope: !63)
!63 = distinct !DILexicalBlock(scope: !64, file: !11, line: 36, column: 9)
!64 = distinct !DILexicalBlock(scope: !54, file: !11, line: 36, column: 9)
!65 = !DILocation(line: 36, column: 9, scope: !64)
!66 = !DILocation(line: 37, column: 5, scope: !54)
!67 = !DILocation(line: 179, column: 5, scope: !10)
