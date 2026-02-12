; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [9 x i8] c"r1 != r2\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !10 {
  %1 = alloca i32, align 4
  %2 = alloca float, align 4
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  %6 = alloca double, align 8
  %7 = alloca double, align 8
  %8 = alloca double, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata float* %2, metadata !16, metadata !DIExpression()), !dbg !18
  %9 = call float @__VERIFIER_nondet_float(), !dbg !19
  store float %9, float* %2, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata double* %3, metadata !20, metadata !DIExpression()), !dbg !22
  %10 = call double @__VERIFIER_nondet_double(), !dbg !23
  store double %10, double* %3, align 8, !dbg !22
  call void @llvm.dbg.declare(metadata double* %4, metadata !24, metadata !DIExpression()), !dbg !26
  store double 1.000000e+308, double* %4, align 8, !dbg !26
  call void @llvm.dbg.declare(metadata double* %5, metadata !27, metadata !DIExpression()), !dbg !28
  store double -1.000000e+308, double* %5, align 8, !dbg !28
  call void @llvm.dbg.declare(metadata double* %6, metadata !29, metadata !DIExpression()), !dbg !30
  store double 1.000000e+00, double* %6, align 8, !dbg !30
  call void @llvm.dbg.declare(metadata double* %7, metadata !31, metadata !DIExpression()), !dbg !32
  %11 = load double, double* %4, align 8, !dbg !33
  %12 = load double, double* %5, align 8, !dbg !34
  %13 = fadd double %11, %12, !dbg !35
  %14 = load double, double* %6, align 8, !dbg !36
  %15 = fadd double %13, %14, !dbg !37
  store double %15, double* %7, align 8, !dbg !32
  call void @llvm.dbg.declare(metadata double* %8, metadata !38, metadata !DIExpression()), !dbg !39
  %16 = load double, double* %4, align 8, !dbg !40
  %17 = load double, double* %5, align 8, !dbg !41
  %18 = load double, double* %6, align 8, !dbg !42
  %19 = fadd double %17, %18, !dbg !43
  %20 = fadd double %16, %19, !dbg !44
  store double %20, double* %8, align 8, !dbg !39
  %21 = load double, double* %7, align 8, !dbg !45
  %22 = load double, double* %8, align 8, !dbg !45
  %23 = fcmp une double %21, %22, !dbg !45
  br i1 %23, label %24, label %25, !dbg !48

24:                                               ; preds = %0
  br label %26, !dbg !48

25:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 121, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !45
  unreachable, !dbg !45

26:                                               ; preds = %24
  ret i32 0, !dbg !49
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
!24 = !DILocalVariable(name: "a", scope: !25, file: !11, line: 116, type: !21)
!25 = distinct !DILexicalBlock(scope: !10, file: !11, line: 115, column: 5)
!26 = !DILocation(line: 116, column: 16, scope: !25)
!27 = !DILocalVariable(name: "b", scope: !25, file: !11, line: 117, type: !21)
!28 = !DILocation(line: 117, column: 16, scope: !25)
!29 = !DILocalVariable(name: "c", scope: !25, file: !11, line: 118, type: !21)
!30 = !DILocation(line: 118, column: 16, scope: !25)
!31 = !DILocalVariable(name: "r1", scope: !25, file: !11, line: 119, type: !21)
!32 = !DILocation(line: 119, column: 16, scope: !25)
!33 = !DILocation(line: 119, column: 22, scope: !25)
!34 = !DILocation(line: 119, column: 26, scope: !25)
!35 = !DILocation(line: 119, column: 24, scope: !25)
!36 = !DILocation(line: 119, column: 31, scope: !25)
!37 = !DILocation(line: 119, column: 29, scope: !25)
!38 = !DILocalVariable(name: "r2", scope: !25, file: !11, line: 120, type: !21)
!39 = !DILocation(line: 120, column: 16, scope: !25)
!40 = !DILocation(line: 120, column: 21, scope: !25)
!41 = !DILocation(line: 120, column: 26, scope: !25)
!42 = !DILocation(line: 120, column: 30, scope: !25)
!43 = !DILocation(line: 120, column: 28, scope: !25)
!44 = !DILocation(line: 120, column: 23, scope: !25)
!45 = !DILocation(line: 121, column: 9, scope: !46)
!46 = distinct !DILexicalBlock(scope: !47, file: !11, line: 121, column: 9)
!47 = distinct !DILexicalBlock(scope: !25, file: !11, line: 121, column: 9)
!48 = !DILocation(line: 121, column: 9, scope: !47)
!49 = !DILocation(line: 165, column: 5, scope: !10)
