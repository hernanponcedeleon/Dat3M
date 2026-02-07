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
  br i1 %9, label %10, label %50, !dbg !27

10:                                               ; preds = %0
  call void @llvm.dbg.declare(metadata float* %4, metadata !28, metadata !DIExpression()), !dbg !30
  %11 = load float, float* %2, align 4, !dbg !31
  %12 = load float, float* %2, align 4, !dbg !32
  %13 = fadd float %11, %12, !dbg !33
  store float %13, float* %4, align 4, !dbg !30
  %14 = load float, float* %4, align 4, !dbg !34
  %15 = fcmp oeq float %14, 0.000000e+00, !dbg !34
  br i1 %15, label %16, label %17, !dbg !37

16:                                               ; preds = %10
  br label %18, !dbg !37

17:                                               ; preds = %10
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 87, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !34
  unreachable, !dbg !34

18:                                               ; preds = %16
  %19 = load float, float* %4, align 4, !dbg !38
  %20 = bitcast float %19 to i32, !dbg !38
  %21 = icmp slt i32 %20, 0, !dbg !38
  %22 = zext i1 %21 to i32, !dbg !38
  %23 = load float, float* %2, align 4, !dbg !38
  %24 = bitcast float %23 to i32, !dbg !38
  %25 = icmp slt i32 %24, 0, !dbg !38
  %26 = zext i1 %25 to i32, !dbg !38
  %27 = icmp eq i32 %22, %26, !dbg !38
  br i1 %27, label %28, label %29, !dbg !41

28:                                               ; preds = %18
  br label %30, !dbg !41

29:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 88, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !38
  unreachable, !dbg !38

30:                                               ; preds = %28
  call void @llvm.dbg.declare(metadata float* %5, metadata !42, metadata !DIExpression()), !dbg !43
  %31 = load float, float* %2, align 4, !dbg !44
  %32 = fmul float %31, 1.000000e+00, !dbg !45
  store float %32, float* %5, align 4, !dbg !43
  %33 = load float, float* %5, align 4, !dbg !46
  %34 = fcmp oeq float %33, 0.000000e+00, !dbg !46
  br i1 %34, label %35, label %36, !dbg !49

35:                                               ; preds = %30
  br label %37, !dbg !49

36:                                               ; preds = %30
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 91, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !46
  unreachable, !dbg !46

37:                                               ; preds = %35
  %38 = load float, float* %5, align 4, !dbg !50
  %39 = bitcast float %38 to i32, !dbg !50
  %40 = icmp slt i32 %39, 0, !dbg !50
  %41 = zext i1 %40 to i32, !dbg !50
  %42 = load float, float* %2, align 4, !dbg !50
  %43 = bitcast float %42 to i32, !dbg !50
  %44 = icmp slt i32 %43, 0, !dbg !50
  %45 = zext i1 %44 to i32, !dbg !50
  %46 = icmp eq i32 %41, %45, !dbg !50
  br i1 %46, label %47, label %48, !dbg !53

47:                                               ; preds = %37
  br label %49, !dbg !53

48:                                               ; preds = %37
  call void @__assert_fail(i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 92, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !50
  unreachable, !dbg !50

49:                                               ; preds = %47
  br label %50, !dbg !54

50:                                               ; preds = %49, %0
  ret i32 0, !dbg !55
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
!24 = !DILocation(line: 85, column: 9, scope: !25)
!25 = distinct !DILexicalBlock(scope: !10, file: !11, line: 85, column: 9)
!26 = !DILocation(line: 85, column: 11, scope: !25)
!27 = !DILocation(line: 85, column: 9, scope: !10)
!28 = !DILocalVariable(name: "z1", scope: !29, file: !11, line: 86, type: !17)
!29 = distinct !DILexicalBlock(scope: !25, file: !11, line: 85, column: 20)
!30 = !DILocation(line: 86, column: 15, scope: !29)
!31 = !DILocation(line: 86, column: 20, scope: !29)
!32 = !DILocation(line: 86, column: 24, scope: !29)
!33 = !DILocation(line: 86, column: 22, scope: !29)
!34 = !DILocation(line: 87, column: 9, scope: !35)
!35 = distinct !DILexicalBlock(scope: !36, file: !11, line: 87, column: 9)
!36 = distinct !DILexicalBlock(scope: !29, file: !11, line: 87, column: 9)
!37 = !DILocation(line: 87, column: 9, scope: !36)
!38 = !DILocation(line: 88, column: 9, scope: !39)
!39 = distinct !DILexicalBlock(scope: !40, file: !11, line: 88, column: 9)
!40 = distinct !DILexicalBlock(scope: !29, file: !11, line: 88, column: 9)
!41 = !DILocation(line: 88, column: 9, scope: !40)
!42 = !DILocalVariable(name: "z2", scope: !29, file: !11, line: 90, type: !17)
!43 = !DILocation(line: 90, column: 15, scope: !29)
!44 = !DILocation(line: 90, column: 20, scope: !29)
!45 = !DILocation(line: 90, column: 22, scope: !29)
!46 = !DILocation(line: 91, column: 9, scope: !47)
!47 = distinct !DILexicalBlock(scope: !48, file: !11, line: 91, column: 9)
!48 = distinct !DILexicalBlock(scope: !29, file: !11, line: 91, column: 9)
!49 = !DILocation(line: 91, column: 9, scope: !48)
!50 = !DILocation(line: 92, column: 9, scope: !51)
!51 = distinct !DILexicalBlock(scope: !52, file: !11, line: 92, column: 9)
!52 = distinct !DILexicalBlock(scope: !29, file: !11, line: 92, column: 9)
!53 = !DILocation(line: 92, column: 9, scope: !52)
!54 = !DILocation(line: 93, column: 5, scope: !29)
!55 = !DILocation(line: 165, column: 5, scope: !10)
