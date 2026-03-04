; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [11 x i8] c"z1 == 0.0f\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.2 = private unnamed_addr constant [26 x i8] c"signbit(z1) == signbit(f)\00", align 1
@.str.3 = private unnamed_addr constant [11 x i8] c"z2 == 0.0f\00", align 1
@.str.4 = private unnamed_addr constant [26 x i8] c"signbit(z2) == signbit(f)\00", align 1

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
  br i1 %11, label %12, label %52, !dbg !30

12:                                               ; preds = %0
  call void @llvm.dbg.declare(metadata float* %5, metadata !31, metadata !DIExpression()), !dbg !33
  %13 = load float, float* %2, align 4, !dbg !34
  %14 = load float, float* %2, align 4, !dbg !35
  %15 = fadd float %13, %14, !dbg !36
  store float %15, float* %5, align 4, !dbg !33
  %16 = load float, float* %5, align 4, !dbg !37
  %17 = fcmp oeq float %16, 0.000000e+00, !dbg !37
  br i1 %17, label %18, label %19, !dbg !40

18:                                               ; preds = %12
  br label %20, !dbg !40

19:                                               ; preds = %12
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 85, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !37
  unreachable, !dbg !37

20:                                               ; preds = %18
  %21 = load float, float* %5, align 4, !dbg !41
  %22 = bitcast float %21 to i32, !dbg !41
  %23 = icmp slt i32 %22, 0, !dbg !41
  %24 = zext i1 %23 to i32, !dbg !41
  %25 = load float, float* %2, align 4, !dbg !41
  %26 = bitcast float %25 to i32, !dbg !41
  %27 = icmp slt i32 %26, 0, !dbg !41
  %28 = zext i1 %27 to i32, !dbg !41
  %29 = icmp eq i32 %24, %28, !dbg !41
  br i1 %29, label %30, label %31, !dbg !44

30:                                               ; preds = %20
  br label %32, !dbg !44

31:                                               ; preds = %20
  call void @__assert_fail(i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 86, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !41
  unreachable, !dbg !41

32:                                               ; preds = %30
  call void @llvm.dbg.declare(metadata float* %6, metadata !45, metadata !DIExpression()), !dbg !46
  %33 = load float, float* %2, align 4, !dbg !47
  %34 = fmul float %33, 1.000000e+00, !dbg !48
  store float %34, float* %6, align 4, !dbg !46
  %35 = load float, float* %6, align 4, !dbg !49
  %36 = fcmp oeq float %35, 0.000000e+00, !dbg !49
  br i1 %36, label %37, label %38, !dbg !52

37:                                               ; preds = %32
  br label %39, !dbg !52

38:                                               ; preds = %32
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 89, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !49
  unreachable, !dbg !49

39:                                               ; preds = %37
  %40 = load float, float* %6, align 4, !dbg !53
  %41 = bitcast float %40 to i32, !dbg !53
  %42 = icmp slt i32 %41, 0, !dbg !53
  %43 = zext i1 %42 to i32, !dbg !53
  %44 = load float, float* %2, align 4, !dbg !53
  %45 = bitcast float %44 to i32, !dbg !53
  %46 = icmp slt i32 %45, 0, !dbg !53
  %47 = zext i1 %46 to i32, !dbg !53
  %48 = icmp eq i32 %43, %47, !dbg !53
  br i1 %48, label %49, label %50, !dbg !56

49:                                               ; preds = %39
  br label %51, !dbg !56

50:                                               ; preds = %39
  call void @__assert_fail(i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 90, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !53
  unreachable, !dbg !53

51:                                               ; preds = %49
  br label %52, !dbg !57

52:                                               ; preds = %51, %0
  ret i32 0, !dbg !58
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
!27 = !DILocation(line: 83, column: 9, scope: !28)
!28 = distinct !DILexicalBlock(scope: !10, file: !11, line: 83, column: 9)
!29 = !DILocation(line: 83, column: 11, scope: !28)
!30 = !DILocation(line: 83, column: 9, scope: !10)
!31 = !DILocalVariable(name: "z1", scope: !32, file: !11, line: 84, type: !17)
!32 = distinct !DILexicalBlock(scope: !28, file: !11, line: 83, column: 20)
!33 = !DILocation(line: 84, column: 15, scope: !32)
!34 = !DILocation(line: 84, column: 20, scope: !32)
!35 = !DILocation(line: 84, column: 24, scope: !32)
!36 = !DILocation(line: 84, column: 22, scope: !32)
!37 = !DILocation(line: 85, column: 9, scope: !38)
!38 = distinct !DILexicalBlock(scope: !39, file: !11, line: 85, column: 9)
!39 = distinct !DILexicalBlock(scope: !32, file: !11, line: 85, column: 9)
!40 = !DILocation(line: 85, column: 9, scope: !39)
!41 = !DILocation(line: 86, column: 9, scope: !42)
!42 = distinct !DILexicalBlock(scope: !43, file: !11, line: 86, column: 9)
!43 = distinct !DILexicalBlock(scope: !32, file: !11, line: 86, column: 9)
!44 = !DILocation(line: 86, column: 9, scope: !43)
!45 = !DILocalVariable(name: "z2", scope: !32, file: !11, line: 88, type: !17)
!46 = !DILocation(line: 88, column: 15, scope: !32)
!47 = !DILocation(line: 88, column: 20, scope: !32)
!48 = !DILocation(line: 88, column: 22, scope: !32)
!49 = !DILocation(line: 89, column: 9, scope: !50)
!50 = distinct !DILexicalBlock(scope: !51, file: !11, line: 89, column: 9)
!51 = distinct !DILexicalBlock(scope: !32, file: !11, line: 89, column: 9)
!52 = !DILocation(line: 89, column: 9, scope: !51)
!53 = !DILocation(line: 90, column: 9, scope: !54)
!54 = distinct !DILexicalBlock(scope: !55, file: !11, line: 90, column: 9)
!55 = distinct !DILexicalBlock(scope: !32, file: !11, line: 90, column: 9)
!56 = !DILocation(line: 90, column: 9, scope: !55)
!57 = !DILocation(line: 91, column: 5, scope: !32)
!58 = !DILocation(line: 179, column: 5, scope: !10)
