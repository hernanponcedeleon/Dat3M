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
  %6 = alloca double, align 8
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
  %10 = load double, double* %3, align 8, !dbg !27
  %11 = fcmp uno double %10, %10, !dbg !27
  br i1 %11, label %33, label %12, !dbg !29

12:                                               ; preds = %0
  %13 = load double, double* %3, align 8, !dbg !30
  %14 = call double @llvm.fabs.f64(double %13) #4, !dbg !30
  %15 = fcmp oeq double %14, 0x7FF0000000000000, !dbg !30
  %16 = bitcast double %13 to i64, !dbg !30
  %17 = icmp slt i64 %16, 0, !dbg !30
  %18 = select i1 %17, i32 -1, i32 1, !dbg !30
  %19 = select i1 %15, i32 %18, i32 0, !dbg !30
  %20 = icmp ne i32 %19, 0, !dbg !30
  br i1 %20, label %33, label %21, !dbg !31

21:                                               ; preds = %12
  %22 = load double, double* %3, align 8, !dbg !32
  %23 = fcmp une double %22, 0.000000e+00, !dbg !33
  br i1 %23, label %24, label %33, !dbg !34

24:                                               ; preds = %21
  call void @llvm.dbg.declare(metadata double* %5, metadata !35, metadata !DIExpression()), !dbg !37
  %25 = load double, double* %3, align 8, !dbg !38
  %26 = load double, double* %3, align 8, !dbg !39
  %27 = fdiv double %25, %26, !dbg !40
  store double %27, double* %5, align 8, !dbg !37
  %28 = load double, double* %5, align 8, !dbg !41
  %29 = fcmp oeq double %28, 1.000000e+00, !dbg !41
  br i1 %29, label %30, label %31, !dbg !44

30:                                               ; preds = %24
  br label %32, !dbg !44

31:                                               ; preds = %24
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 141, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !41
  unreachable, !dbg !41

32:                                               ; preds = %30
  br label %33, !dbg !45

33:                                               ; preds = %32, %21, %12, %0
  %34 = load double, double* %3, align 8, !dbg !46
  %35 = fcmp oeq double %34, 0.000000e+00, !dbg !48
  br i1 %35, label %36, label %45, !dbg !49

36:                                               ; preds = %33
  call void @llvm.dbg.declare(metadata double* %6, metadata !50, metadata !DIExpression()), !dbg !52
  %37 = load double, double* %3, align 8, !dbg !53
  %38 = load double, double* %3, align 8, !dbg !54
  %39 = fdiv double %37, %38, !dbg !55
  store double %39, double* %6, align 8, !dbg !52
  %40 = load double, double* %6, align 8, !dbg !56
  %41 = fcmp uno double %40, %40, !dbg !56
  br i1 %41, label %42, label %43, !dbg !59

42:                                               ; preds = %36
  br label %44, !dbg !59

43:                                               ; preds = %36
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 145, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !56
  unreachable, !dbg !56

44:                                               ; preds = %42
  br label %45, !dbg !60

45:                                               ; preds = %44, %33
  ret i32 0, !dbg !61
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
!27 = !DILocation(line: 139, column: 10, scope: !28)
!28 = distinct !DILexicalBlock(scope: !10, file: !11, line: 139, column: 9)
!29 = !DILocation(line: 139, column: 19, scope: !28)
!30 = !DILocation(line: 139, column: 23, scope: !28)
!31 = !DILocation(line: 139, column: 32, scope: !28)
!32 = !DILocation(line: 139, column: 35, scope: !28)
!33 = !DILocation(line: 139, column: 37, scope: !28)
!34 = !DILocation(line: 139, column: 9, scope: !10)
!35 = !DILocalVariable(name: "x", scope: !36, file: !11, line: 140, type: !21)
!36 = distinct !DILexicalBlock(scope: !28, file: !11, line: 139, column: 45)
!37 = !DILocation(line: 140, column: 16, scope: !36)
!38 = !DILocation(line: 140, column: 20, scope: !36)
!39 = !DILocation(line: 140, column: 24, scope: !36)
!40 = !DILocation(line: 140, column: 22, scope: !36)
!41 = !DILocation(line: 141, column: 9, scope: !42)
!42 = distinct !DILexicalBlock(scope: !43, file: !11, line: 141, column: 9)
!43 = distinct !DILexicalBlock(scope: !36, file: !11, line: 141, column: 9)
!44 = !DILocation(line: 141, column: 9, scope: !43)
!45 = !DILocation(line: 142, column: 5, scope: !36)
!46 = !DILocation(line: 143, column: 9, scope: !47)
!47 = distinct !DILexicalBlock(scope: !10, file: !11, line: 143, column: 9)
!48 = !DILocation(line: 143, column: 11, scope: !47)
!49 = !DILocation(line: 143, column: 9, scope: !10)
!50 = !DILocalVariable(name: "x", scope: !51, file: !11, line: 144, type: !21)
!51 = distinct !DILexicalBlock(scope: !47, file: !11, line: 143, column: 19)
!52 = !DILocation(line: 144, column: 16, scope: !51)
!53 = !DILocation(line: 144, column: 20, scope: !51)
!54 = !DILocation(line: 144, column: 24, scope: !51)
!55 = !DILocation(line: 144, column: 22, scope: !51)
!56 = !DILocation(line: 145, column: 9, scope: !57)
!57 = distinct !DILexicalBlock(scope: !58, file: !11, line: 145, column: 9)
!58 = distinct !DILexicalBlock(scope: !51, file: !11, line: 145, column: 9)
!59 = !DILocation(line: 145, column: 9, scope: !58)
!60 = !DILocation(line: 146, column: 5, scope: !51)
!61 = !DILocation(line: 179, column: 5, scope: !10)
