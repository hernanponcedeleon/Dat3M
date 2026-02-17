; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [18 x i8] c"fabs(x) < DBL_MIN\00", align 1
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
  call void @llvm.dbg.declare(metadata double* %4, metadata !24, metadata !DIExpression()), !dbg !25
  %8 = call double @__VERIFIER_nondet_double(), !dbg !26
  store double %8, double* %4, align 8, !dbg !25
  %9 = load double, double* %3, align 8, !dbg !27
  %10 = call double @llvm.fabs.f64(double %9), !dbg !29
  %11 = fcmp ole double %10, 0x10000000000000, !dbg !30
  br i1 %11, label %12, label %21, !dbg !31

12:                                               ; preds = %0
  call void @llvm.dbg.declare(metadata double* %5, metadata !32, metadata !DIExpression()), !dbg !34
  %13 = load double, double* %3, align 8, !dbg !35
  %14 = fdiv double %13, 2.000000e+00, !dbg !36
  store double %14, double* %5, align 8, !dbg !34
  %15 = load double, double* %5, align 8, !dbg !37
  %16 = call double @llvm.fabs.f64(double %15), !dbg !37
  %17 = fcmp olt double %16, 0x10000000000000, !dbg !37
  br i1 %17, label %18, label %19, !dbg !40

18:                                               ; preds = %12
  br label %20, !dbg !40

19:                                               ; preds = %12
  call void @__assert_fail(i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 54, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !37
  unreachable, !dbg !37

20:                                               ; preds = %18
  br label %21, !dbg !41

21:                                               ; preds = %20, %0
  ret i32 0, !dbg !42
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
!27 = !DILocation(line: 52, column: 14, scope: !28)
!28 = distinct !DILexicalBlock(scope: !10, file: !11, line: 52, column: 9)
!29 = !DILocation(line: 52, column: 9, scope: !28)
!30 = !DILocation(line: 52, column: 17, scope: !28)
!31 = !DILocation(line: 52, column: 9, scope: !10)
!32 = !DILocalVariable(name: "x", scope: !33, file: !11, line: 53, type: !21)
!33 = distinct !DILexicalBlock(scope: !28, file: !11, line: 52, column: 29)
!34 = !DILocation(line: 53, column: 16, scope: !33)
!35 = !DILocation(line: 53, column: 20, scope: !33)
!36 = !DILocation(line: 53, column: 22, scope: !33)
!37 = !DILocation(line: 54, column: 9, scope: !38)
!38 = distinct !DILexicalBlock(scope: !39, file: !11, line: 54, column: 9)
!39 = distinct !DILexicalBlock(scope: !33, file: !11, line: 54, column: 9)
!40 = !DILocation(line: 54, column: 9, scope: !39)
!41 = !DILocation(line: 58, column: 5, scope: !33)
!42 = !DILocation(line: 179, column: 5, scope: !10)
