; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [27 x i8] c"fmax(d, d2) == fmax(d, d2)\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.2 = private unnamed_addr constant [45 x i8] c"signbit(fmax(d, d2)) == signbit(fmax(d, d2))\00", align 1
@.str.3 = private unnamed_addr constant [27 x i8] c"fmax(d, d2) == fmax(d2, d)\00", align 1

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
  call void @llvm.dbg.declare(metadata double* %4, metadata !24, metadata !DIExpression()), !dbg !25
  %7 = call double @__VERIFIER_nondet_double(), !dbg !26
  store double %7, double* %4, align 8, !dbg !25
  %8 = load double, double* %3, align 8, !dbg !27
  %9 = fcmp uno double %8, %8, !dbg !27
  br i1 %9, label %50, label %10, !dbg !29

10:                                               ; preds = %0
  %11 = load double, double* %4, align 8, !dbg !30
  %12 = fcmp uno double %11, %11, !dbg !30
  br i1 %12, label %50, label %13, !dbg !31

13:                                               ; preds = %10
  %14 = load double, double* %3, align 8, !dbg !32
  %15 = load double, double* %4, align 8, !dbg !32
  %16 = call double @llvm.maxnum.f64(double %14, double %15), !dbg !32
  %17 = load double, double* %3, align 8, !dbg !32
  %18 = load double, double* %4, align 8, !dbg !32
  %19 = call double @llvm.maxnum.f64(double %17, double %18), !dbg !32
  %20 = fcmp oeq double %16, %19, !dbg !32
  br i1 %20, label %21, label %22, !dbg !36

21:                                               ; preds = %13
  br label %23, !dbg !36

22:                                               ; preds = %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 165, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !32
  unreachable, !dbg !32

23:                                               ; preds = %21
  %24 = load double, double* %3, align 8, !dbg !37
  %25 = load double, double* %4, align 8, !dbg !37
  %26 = call double @llvm.maxnum.f64(double %24, double %25), !dbg !37
  %27 = bitcast double %26 to i64, !dbg !37
  %28 = icmp slt i64 %27, 0, !dbg !37
  %29 = zext i1 %28 to i32, !dbg !37
  %30 = load double, double* %3, align 8, !dbg !37
  %31 = load double, double* %4, align 8, !dbg !37
  %32 = call double @llvm.maxnum.f64(double %30, double %31), !dbg !37
  %33 = bitcast double %32 to i64, !dbg !37
  %34 = icmp slt i64 %33, 0, !dbg !37
  %35 = zext i1 %34 to i32, !dbg !37
  %36 = icmp eq i32 %29, %35, !dbg !37
  br i1 %36, label %37, label %38, !dbg !40

37:                                               ; preds = %23
  br label %39, !dbg !40

38:                                               ; preds = %23
  call void @__assert_fail(i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 166, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !37
  unreachable, !dbg !37

39:                                               ; preds = %37
  %40 = load double, double* %3, align 8, !dbg !41
  %41 = load double, double* %4, align 8, !dbg !41
  %42 = call double @llvm.maxnum.f64(double %40, double %41), !dbg !41
  %43 = load double, double* %4, align 8, !dbg !41
  %44 = load double, double* %3, align 8, !dbg !41
  %45 = call double @llvm.maxnum.f64(double %43, double %44), !dbg !41
  %46 = fcmp oeq double %42, %45, !dbg !41
  br i1 %46, label %47, label %48, !dbg !44

47:                                               ; preds = %39
  br label %49, !dbg !44

48:                                               ; preds = %39
  call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 168, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !41
  unreachable, !dbg !41

49:                                               ; preds = %47
  br label %50, !dbg !45

50:                                               ; preds = %49, %10, %0
  ret i32 0, !dbg !46
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare float @__VERIFIER_nondet_float() #2

declare double @__VERIFIER_nondet_double() #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.maxnum.f64(double, double) #1

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
!27 = !DILocation(line: 164, column: 10, scope: !28)
!28 = distinct !DILexicalBlock(scope: !10, file: !11, line: 164, column: 9)
!29 = !DILocation(line: 164, column: 19, scope: !28)
!30 = !DILocation(line: 164, column: 23, scope: !28)
!31 = !DILocation(line: 164, column: 9, scope: !10)
!32 = !DILocation(line: 165, column: 9, scope: !33)
!33 = distinct !DILexicalBlock(scope: !34, file: !11, line: 165, column: 9)
!34 = distinct !DILexicalBlock(scope: !35, file: !11, line: 165, column: 9)
!35 = distinct !DILexicalBlock(scope: !28, file: !11, line: 164, column: 34)
!36 = !DILocation(line: 165, column: 9, scope: !34)
!37 = !DILocation(line: 166, column: 9, scope: !38)
!38 = distinct !DILexicalBlock(scope: !39, file: !11, line: 166, column: 9)
!39 = distinct !DILexicalBlock(scope: !35, file: !11, line: 166, column: 9)
!40 = !DILocation(line: 166, column: 9, scope: !39)
!41 = !DILocation(line: 168, column: 9, scope: !42)
!42 = distinct !DILexicalBlock(scope: !43, file: !11, line: 168, column: 9)
!43 = distinct !DILexicalBlock(scope: !35, file: !11, line: 168, column: 9)
!44 = !DILocation(line: 168, column: 9, scope: !43)
!45 = !DILocation(line: 172, column: 5, scope: !35)
!46 = !DILocation(line: 179, column: 5, scope: !10)
