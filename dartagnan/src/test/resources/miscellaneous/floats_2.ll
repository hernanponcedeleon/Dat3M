; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [16 x i8] c"isinf(f + 1.0f)\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.2 = private unnamed_addr constant [15 x i8] c"isinf(d + 1.0)\00", align 1

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
  %7 = call float @llvm.fabs.f32(float %6) #4, !dbg !24
  %8 = fcmp oeq float %7, 0x7FF0000000000000, !dbg !24
  %9 = bitcast float %6 to i32, !dbg !24
  %10 = icmp slt i32 %9, 0, !dbg !24
  %11 = select i1 %10, i32 -1, i32 1, !dbg !24
  %12 = select i1 %8, i32 %11, i32 0, !dbg !24
  %13 = icmp ne i32 %12, 0, !dbg !24
  br i1 %13, label %14, label %27, !dbg !26

14:                                               ; preds = %0
  %15 = load float, float* %2, align 4, !dbg !27
  %16 = fadd float %15, 1.000000e+00, !dbg !27
  %17 = call float @llvm.fabs.f32(float %16) #4, !dbg !27
  %18 = fcmp oeq float %17, 0x7FF0000000000000, !dbg !27
  %19 = bitcast float %16 to i32, !dbg !27
  %20 = icmp slt i32 %19, 0, !dbg !27
  %21 = select i1 %20, i32 -1, i32 1, !dbg !27
  %22 = select i1 %18, i32 %21, i32 0, !dbg !27
  %23 = icmp ne i32 %22, 0, !dbg !27
  br i1 %23, label %24, label %25, !dbg !30

24:                                               ; preds = %14
  br label %26, !dbg !30

25:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 25, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !27
  unreachable, !dbg !27

26:                                               ; preds = %24
  br label %27, !dbg !31

27:                                               ; preds = %26, %0
  %28 = load double, double* %3, align 8, !dbg !32
  %29 = call double @llvm.fabs.f64(double %28) #4, !dbg !32
  %30 = fcmp oeq double %29, 0x7FF0000000000000, !dbg !32
  %31 = bitcast double %28 to i64, !dbg !32
  %32 = icmp slt i64 %31, 0, !dbg !32
  %33 = select i1 %32, i32 -1, i32 1, !dbg !32
  %34 = select i1 %30, i32 %33, i32 0, !dbg !32
  %35 = icmp ne i32 %34, 0, !dbg !32
  br i1 %35, label %36, label %49, !dbg !34

36:                                               ; preds = %27
  %37 = load double, double* %3, align 8, !dbg !35
  %38 = fadd double %37, 1.000000e+00, !dbg !35
  %39 = call double @llvm.fabs.f64(double %38) #4, !dbg !35
  %40 = fcmp oeq double %39, 0x7FF0000000000000, !dbg !35
  %41 = bitcast double %38 to i64, !dbg !35
  %42 = icmp slt i64 %41, 0, !dbg !35
  %43 = select i1 %42, i32 -1, i32 1, !dbg !35
  %44 = select i1 %40, i32 %43, i32 0, !dbg !35
  %45 = icmp ne i32 %44, 0, !dbg !35
  br i1 %45, label %46, label %47, !dbg !38

46:                                               ; preds = %36
  br label %48, !dbg !38

47:                                               ; preds = %36
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 26, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !35
  unreachable, !dbg !35

48:                                               ; preds = %46
  br label %49, !dbg !39

49:                                               ; preds = %48, %27
  ret i32 0, !dbg !40
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare float @__VERIFIER_nondet_float() #2

declare double @__VERIFIER_nondet_double() #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare float @llvm.fabs.f32(float) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fabs.f64(double) #1

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
!24 = !DILocation(line: 25, column: 9, scope: !25)
!25 = distinct !DILexicalBlock(scope: !10, file: !11, line: 25, column: 9)
!26 = !DILocation(line: 25, column: 9, scope: !10)
!27 = !DILocation(line: 25, column: 19, scope: !28)
!28 = distinct !DILexicalBlock(scope: !29, file: !11, line: 25, column: 19)
!29 = distinct !DILexicalBlock(scope: !25, file: !11, line: 25, column: 19)
!30 = !DILocation(line: 25, column: 19, scope: !29)
!31 = !DILocation(line: 25, column: 19, scope: !25)
!32 = !DILocation(line: 26, column: 9, scope: !33)
!33 = distinct !DILexicalBlock(scope: !10, file: !11, line: 26, column: 9)
!34 = !DILocation(line: 26, column: 9, scope: !10)
!35 = !DILocation(line: 26, column: 19, scope: !36)
!36 = distinct !DILexicalBlock(scope: !37, file: !11, line: 26, column: 19)
!37 = distinct !DILexicalBlock(scope: !33, file: !11, line: 26, column: 19)
!38 = !DILocation(line: 26, column: 19, scope: !37)
!39 = !DILocation(line: 26, column: 19, scope: !33)
!40 = !DILocation(line: 165, column: 5, scope: !10)
