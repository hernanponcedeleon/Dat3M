; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [11 x i8] c"isinf(inv)\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"signbit(inv)\00", align 1

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
  br i1 %9, label %10, label %28, !dbg !27

10:                                               ; preds = %0
  %11 = load float, float* %2, align 4, !dbg !28
  %12 = bitcast float %11 to i32, !dbg !28
  %13 = icmp slt i32 %12, 0, !dbg !28
  br i1 %13, label %28, label %14, !dbg !29

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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 32, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !35
  unreachable, !dbg !35

27:                                               ; preds = %25
  br label %28, !dbg !39

28:                                               ; preds = %27, %10, %0
  %29 = load float, float* %2, align 4, !dbg !40
  %30 = fcmp oeq float %29, 0.000000e+00, !dbg !42
  br i1 %30, label %31, label %55, !dbg !43

31:                                               ; preds = %28
  %32 = load float, float* %2, align 4, !dbg !44
  %33 = bitcast float %32 to i32, !dbg !44
  %34 = icmp slt i32 %33, 0, !dbg !44
  br i1 %34, label %35, label %55, !dbg !45

35:                                               ; preds = %31
  call void @llvm.dbg.declare(metadata float* %5, metadata !46, metadata !DIExpression()), !dbg !48
  %36 = load float, float* %2, align 4, !dbg !49
  %37 = fdiv float 1.000000e+00, %36, !dbg !50
  store float %37, float* %5, align 4, !dbg !48
  %38 = load float, float* %5, align 4, !dbg !51
  %39 = call float @llvm.fabs.f32(float %38) #4, !dbg !51
  %40 = fcmp oeq float %39, 0x7FF0000000000000, !dbg !51
  %41 = bitcast float %38 to i32, !dbg !51
  %42 = icmp slt i32 %41, 0, !dbg !51
  %43 = select i1 %42, i32 -1, i32 1, !dbg !51
  %44 = select i1 %40, i32 %43, i32 0, !dbg !51
  %45 = icmp ne i32 %44, 0, !dbg !51
  br i1 %45, label %46, label %47, !dbg !54

46:                                               ; preds = %35
  br label %48, !dbg !54

47:                                               ; preds = %35
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 37, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !51
  unreachable, !dbg !51

48:                                               ; preds = %46
  %49 = load float, float* %5, align 4, !dbg !55
  %50 = bitcast float %49 to i32, !dbg !55
  %51 = icmp slt i32 %50, 0, !dbg !55
  br i1 %51, label %52, label %53, !dbg !58

52:                                               ; preds = %48
  br label %54, !dbg !58

53:                                               ; preds = %48
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !55
  unreachable, !dbg !55

54:                                               ; preds = %52
  br label %55, !dbg !59

55:                                               ; preds = %54, %31, %28
  ret i32 0, !dbg !60
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
!24 = !DILocation(line: 30, column: 9, scope: !25)
!25 = distinct !DILexicalBlock(scope: !10, file: !11, line: 30, column: 9)
!26 = !DILocation(line: 30, column: 11, scope: !25)
!27 = !DILocation(line: 30, column: 19, scope: !25)
!28 = !DILocation(line: 30, column: 23, scope: !25)
!29 = !DILocation(line: 30, column: 9, scope: !10)
!30 = !DILocalVariable(name: "inv", scope: !31, file: !11, line: 31, type: !17)
!31 = distinct !DILexicalBlock(scope: !25, file: !11, line: 30, column: 35)
!32 = !DILocation(line: 31, column: 15, scope: !31)
!33 = !DILocation(line: 31, column: 28, scope: !31)
!34 = !DILocation(line: 31, column: 26, scope: !31)
!35 = !DILocation(line: 32, column: 9, scope: !36)
!36 = distinct !DILexicalBlock(scope: !37, file: !11, line: 32, column: 9)
!37 = distinct !DILexicalBlock(scope: !31, file: !11, line: 32, column: 9)
!38 = !DILocation(line: 32, column: 9, scope: !37)
!39 = !DILocation(line: 34, column: 5, scope: !31)
!40 = !DILocation(line: 35, column: 9, scope: !41)
!41 = distinct !DILexicalBlock(scope: !10, file: !11, line: 35, column: 9)
!42 = !DILocation(line: 35, column: 11, scope: !41)
!43 = !DILocation(line: 35, column: 19, scope: !41)
!44 = !DILocation(line: 35, column: 22, scope: !41)
!45 = !DILocation(line: 35, column: 9, scope: !10)
!46 = !DILocalVariable(name: "inv", scope: !47, file: !11, line: 36, type: !17)
!47 = distinct !DILexicalBlock(scope: !41, file: !11, line: 35, column: 34)
!48 = !DILocation(line: 36, column: 15, scope: !47)
!49 = !DILocation(line: 36, column: 28, scope: !47)
!50 = !DILocation(line: 36, column: 26, scope: !47)
!51 = !DILocation(line: 37, column: 9, scope: !52)
!52 = distinct !DILexicalBlock(scope: !53, file: !11, line: 37, column: 9)
!53 = distinct !DILexicalBlock(scope: !47, file: !11, line: 37, column: 9)
!54 = !DILocation(line: 37, column: 9, scope: !53)
!55 = !DILocation(line: 38, column: 9, scope: !56)
!56 = distinct !DILexicalBlock(scope: !57, file: !11, line: 38, column: 9)
!57 = distinct !DILexicalBlock(scope: !47, file: !11, line: 38, column: 9)
!58 = !DILocation(line: 38, column: 9, scope: !57)
!59 = !DILocation(line: 39, column: 5, scope: !47)
!60 = !DILocation(line: 165, column: 5, scope: !10)
