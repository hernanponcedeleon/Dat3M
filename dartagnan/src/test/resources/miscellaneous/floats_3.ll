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
  %4 = alloca float, align 4
  %5 = alloca float, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata float* %2, metadata !16, metadata !DIExpression()), !dbg !18
  %6 = call float @__VERIFIER_nondet_float(), !dbg !19
  store float %6, float* %2, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata double* %3, metadata !20, metadata !DIExpression()), !dbg !22
  %7 = call double @__VERIFIER_nondet_double(), !dbg !23
  store double %7, double* %3, align 8, !dbg !22
  %8 = load float, float* %2, align 4, !dbg !24
  %9 = fcmp oeq float %8, 0.000000e+00, !dbg !26
  br i1 %9, label %10, label %34, !dbg !27

10:                                               ; preds = %0
  %11 = load float, float* %2, align 4, !dbg !28
  %12 = bitcast float %11 to i32, !dbg !28
  %13 = icmp slt i32 %12, 0, !dbg !28
  br i1 %13, label %34, label %14, !dbg !29

14:                                               ; preds = %10
  call void @llvm.dbg.declare(metadata float* %4, metadata !30, metadata !DIExpression()), !dbg !32
  %15 = load float, float* %2, align 4, !dbg !33
  %16 = fdiv float 1.000000e+00, %15, !dbg !34
  store float %16, float* %4, align 4, !dbg !32
  %17 = load float, float* %4, align 4, !dbg !35
  %18 = call float @llvm.fabs.f32(float %17) #4, !dbg !35
  %19 = fcmp oeq float %18, 0x7FF0000000000000, !dbg !35
  %20 = bitcast float %17 to i32, !dbg !35
  %21 = icmp slt i32 %20, 0, !dbg !35
  %22 = select i1 %21, i32 -1, i32 1, !dbg !35
  %23 = select i1 %19, i32 %22, i32 0, !dbg !35
  %24 = icmp ne i32 %23, 0, !dbg !35
  br i1 %24, label %25, label %26, !dbg !38

25:                                               ; preds = %14
  br label %27, !dbg !38

26:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 29, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !35
  unreachable, !dbg !35

27:                                               ; preds = %25
  %28 = load float, float* %4, align 4, !dbg !39
  %29 = bitcast float %28 to i32, !dbg !39
  %30 = icmp slt i32 %29, 0, !dbg !39
  br i1 %30, label %32, label %31, !dbg !42

31:                                               ; preds = %27
  br label %33, !dbg !42

32:                                               ; preds = %27
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 30, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !39
  unreachable, !dbg !39

33:                                               ; preds = %31
  br label %34, !dbg !43

34:                                               ; preds = %33, %10, %0
  %35 = load float, float* %2, align 4, !dbg !44
  %36 = fcmp oeq float %35, 0.000000e+00, !dbg !46
  br i1 %36, label %37, label %61, !dbg !47

37:                                               ; preds = %34
  %38 = load float, float* %2, align 4, !dbg !48
  %39 = bitcast float %38 to i32, !dbg !48
  %40 = icmp slt i32 %39, 0, !dbg !48
  br i1 %40, label %41, label %61, !dbg !49

41:                                               ; preds = %37
  call void @llvm.dbg.declare(metadata float* %5, metadata !50, metadata !DIExpression()), !dbg !52
  %42 = load float, float* %2, align 4, !dbg !53
  %43 = fdiv float 1.000000e+00, %42, !dbg !54
  store float %43, float* %5, align 4, !dbg !52
  %44 = load float, float* %5, align 4, !dbg !55
  %45 = call float @llvm.fabs.f32(float %44) #4, !dbg !55
  %46 = fcmp oeq float %45, 0x7FF0000000000000, !dbg !55
  %47 = bitcast float %44 to i32, !dbg !55
  %48 = icmp slt i32 %47, 0, !dbg !55
  %49 = select i1 %48, i32 -1, i32 1, !dbg !55
  %50 = select i1 %46, i32 %49, i32 0, !dbg !55
  %51 = icmp ne i32 %50, 0, !dbg !55
  br i1 %51, label %52, label %53, !dbg !58

52:                                               ; preds = %41
  br label %54, !dbg !58

53:                                               ; preds = %41
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 34, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !55
  unreachable, !dbg !55

54:                                               ; preds = %52
  %55 = load float, float* %5, align 4, !dbg !59
  %56 = bitcast float %55 to i32, !dbg !59
  %57 = icmp slt i32 %56, 0, !dbg !59
  br i1 %57, label %58, label %59, !dbg !62

58:                                               ; preds = %54
  br label %60, !dbg !62

59:                                               ; preds = %54
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 35, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !59
  unreachable, !dbg !59

60:                                               ; preds = %58
  br label %61, !dbg !63

61:                                               ; preds = %60, %37, %34
  ret i32 0, !dbg !64
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
!1 = !DIFile(filename: "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "6db1da13d025db5c239b1293a2d7add9")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!10 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 11, type: !12, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!11 = !DIFile(filename: "benchmarks/miscellaneous/floats.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "6db1da13d025db5c239b1293a2d7add9")
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
!24 = !DILocation(line: 27, column: 9, scope: !25)
!25 = distinct !DILexicalBlock(scope: !10, file: !11, line: 27, column: 9)
!26 = !DILocation(line: 27, column: 11, scope: !25)
!27 = !DILocation(line: 27, column: 19, scope: !25)
!28 = !DILocation(line: 27, column: 23, scope: !25)
!29 = !DILocation(line: 27, column: 9, scope: !10)
!30 = !DILocalVariable(name: "inv", scope: !31, file: !11, line: 28, type: !17)
!31 = distinct !DILexicalBlock(scope: !25, file: !11, line: 27, column: 35)
!32 = !DILocation(line: 28, column: 15, scope: !31)
!33 = !DILocation(line: 28, column: 28, scope: !31)
!34 = !DILocation(line: 28, column: 26, scope: !31)
!35 = !DILocation(line: 29, column: 9, scope: !36)
!36 = distinct !DILexicalBlock(scope: !37, file: !11, line: 29, column: 9)
!37 = distinct !DILexicalBlock(scope: !31, file: !11, line: 29, column: 9)
!38 = !DILocation(line: 29, column: 9, scope: !37)
!39 = !DILocation(line: 30, column: 9, scope: !40)
!40 = distinct !DILexicalBlock(scope: !41, file: !11, line: 30, column: 9)
!41 = distinct !DILexicalBlock(scope: !31, file: !11, line: 30, column: 9)
!42 = !DILocation(line: 30, column: 9, scope: !41)
!43 = !DILocation(line: 31, column: 5, scope: !31)
!44 = !DILocation(line: 32, column: 9, scope: !45)
!45 = distinct !DILexicalBlock(scope: !10, file: !11, line: 32, column: 9)
!46 = !DILocation(line: 32, column: 11, scope: !45)
!47 = !DILocation(line: 32, column: 19, scope: !45)
!48 = !DILocation(line: 32, column: 22, scope: !45)
!49 = !DILocation(line: 32, column: 9, scope: !10)
!50 = !DILocalVariable(name: "inv", scope: !51, file: !11, line: 33, type: !17)
!51 = distinct !DILexicalBlock(scope: !45, file: !11, line: 32, column: 34)
!52 = !DILocation(line: 33, column: 15, scope: !51)
!53 = !DILocation(line: 33, column: 28, scope: !51)
!54 = !DILocation(line: 33, column: 26, scope: !51)
!55 = !DILocation(line: 34, column: 9, scope: !56)
!56 = distinct !DILexicalBlock(scope: !57, file: !11, line: 34, column: 9)
!57 = distinct !DILexicalBlock(scope: !51, file: !11, line: 34, column: 9)
!58 = !DILocation(line: 34, column: 9, scope: !57)
!59 = !DILocation(line: 35, column: 9, scope: !60)
!60 = distinct !DILexicalBlock(scope: !61, file: !11, line: 35, column: 9)
!61 = distinct !DILexicalBlock(scope: !51, file: !11, line: 35, column: 9)
!62 = !DILocation(line: 35, column: 9, scope: !61)
!63 = !DILocation(line: 36, column: 5, scope: !51)
!64 = !DILocation(line: 155, column: 5, scope: !10)
