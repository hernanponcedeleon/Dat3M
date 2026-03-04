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
  %9 = alloca double, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata float* %2, metadata !16, metadata !DIExpression()), !dbg !18
  %10 = call float @__VERIFIER_nondet_float(), !dbg !19
  store float %10, float* %2, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata double* %3, metadata !20, metadata !DIExpression()), !dbg !22
  %11 = call double @__VERIFIER_nondet_double(), !dbg !23
  store double %11, double* %3, align 8, !dbg !22
  call void @llvm.dbg.declare(metadata double* %4, metadata !24, metadata !DIExpression()), !dbg !25
  %12 = call double @__VERIFIER_nondet_double(), !dbg !26
  store double %12, double* %4, align 8, !dbg !25
  call void @llvm.dbg.declare(metadata double* %5, metadata !27, metadata !DIExpression()), !dbg !29
  store double 1.000000e+308, double* %5, align 8, !dbg !29
  call void @llvm.dbg.declare(metadata double* %6, metadata !30, metadata !DIExpression()), !dbg !31
  store double -1.000000e+308, double* %6, align 8, !dbg !31
  call void @llvm.dbg.declare(metadata double* %7, metadata !32, metadata !DIExpression()), !dbg !33
  store double 1.000000e+00, double* %7, align 8, !dbg !33
  call void @llvm.dbg.declare(metadata double* %8, metadata !34, metadata !DIExpression()), !dbg !35
  %13 = load double, double* %5, align 8, !dbg !36
  %14 = load double, double* %6, align 8, !dbg !37
  %15 = fadd double %13, %14, !dbg !38
  %16 = load double, double* %7, align 8, !dbg !39
  %17 = fadd double %15, %16, !dbg !40
  store double %17, double* %8, align 8, !dbg !35
  call void @llvm.dbg.declare(metadata double* %9, metadata !41, metadata !DIExpression()), !dbg !42
  %18 = load double, double* %5, align 8, !dbg !43
  %19 = load double, double* %6, align 8, !dbg !44
  %20 = load double, double* %7, align 8, !dbg !45
  %21 = fadd double %19, %20, !dbg !46
  %22 = fadd double %18, %21, !dbg !47
  store double %22, double* %9, align 8, !dbg !42
  %23 = load double, double* %8, align 8, !dbg !48
  %24 = load double, double* %9, align 8, !dbg !48
  %25 = fcmp une double %23, %24, !dbg !48
  br i1 %25, label %26, label %27, !dbg !51

26:                                               ; preds = %0
  br label %28, !dbg !51

27:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 115, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !48
  unreachable, !dbg !48

28:                                               ; preds = %26
  ret i32 0, !dbg !52
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
!27 = !DILocalVariable(name: "a", scope: !28, file: !11, line: 110, type: !21)
!28 = distinct !DILexicalBlock(scope: !10, file: !11, line: 109, column: 5)
!29 = !DILocation(line: 110, column: 16, scope: !28)
!30 = !DILocalVariable(name: "b", scope: !28, file: !11, line: 111, type: !21)
!31 = !DILocation(line: 111, column: 16, scope: !28)
!32 = !DILocalVariable(name: "c", scope: !28, file: !11, line: 112, type: !21)
!33 = !DILocation(line: 112, column: 16, scope: !28)
!34 = !DILocalVariable(name: "r1", scope: !28, file: !11, line: 113, type: !21)
!35 = !DILocation(line: 113, column: 16, scope: !28)
!36 = !DILocation(line: 113, column: 22, scope: !28)
!37 = !DILocation(line: 113, column: 26, scope: !28)
!38 = !DILocation(line: 113, column: 24, scope: !28)
!39 = !DILocation(line: 113, column: 31, scope: !28)
!40 = !DILocation(line: 113, column: 29, scope: !28)
!41 = !DILocalVariable(name: "r2", scope: !28, file: !11, line: 114, type: !21)
!42 = !DILocation(line: 114, column: 16, scope: !28)
!43 = !DILocation(line: 114, column: 21, scope: !28)
!44 = !DILocation(line: 114, column: 26, scope: !28)
!45 = !DILocation(line: 114, column: 30, scope: !28)
!46 = !DILocation(line: 114, column: 28, scope: !28)
!47 = !DILocation(line: 114, column: 23, scope: !28)
!48 = !DILocation(line: 115, column: 9, scope: !49)
!49 = distinct !DILexicalBlock(scope: !50, file: !11, line: 115, column: 9)
!50 = distinct !DILexicalBlock(scope: !28, file: !11, line: 115, column: 9)
!51 = !DILocation(line: 115, column: 9, scope: !50)
!52 = !DILocation(line: 179, column: 5, scope: !10)
