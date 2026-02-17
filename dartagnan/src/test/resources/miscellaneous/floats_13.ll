; ModuleID = '/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [11 x i8] c"ff == 0.0f\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !12 {
  %1 = alloca i32, align 4
  %2 = alloca float, align 4
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca float, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata float* %2, metadata !18, metadata !DIExpression()), !dbg !19
  %6 = call float @__VERIFIER_nondet_float(), !dbg !20
  store float %6, float* %2, align 4, !dbg !19
  call void @llvm.dbg.declare(metadata double* %3, metadata !21, metadata !DIExpression()), !dbg !23
  %7 = call double @__VERIFIER_nondet_double(), !dbg !24
  store double %7, double* %3, align 8, !dbg !23
  call void @llvm.dbg.declare(metadata double* %4, metadata !25, metadata !DIExpression()), !dbg !26
  %8 = call double @__VERIFIER_nondet_double(), !dbg !27
  store double %8, double* %4, align 8, !dbg !26
  call void @llvm.dbg.declare(metadata float* %5, metadata !28, metadata !DIExpression()), !dbg !30
  store float 0.000000e+00, float* %5, align 4, !dbg !30
  %9 = load float, float* %5, align 4, !dbg !31
  %10 = fcmp oeq float %9, 0.000000e+00, !dbg !31
  br i1 %10, label %11, label %12, !dbg !34

11:                                               ; preds = %0
  br label %13, !dbg !34

12:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 134, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4, !dbg !31
  unreachable, !dbg !31

13:                                               ; preds = %11
  ret i32 0, !dbg !35
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
!llvm.module.flags = !{!4, !5, !6, !7, !8, !9, !10}
!llvm.ident = !{!11}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/drc/git/Dat3M/benchmarks/miscellaneous/floats.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "655be55c9424586b3c1ea9b9681db180")
!2 = !{!3}
!3 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!4 = !{i32 7, !"Dwarf Version", i32 5}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = !{i32 7, !"PIC Level", i32 2}
!8 = !{i32 7, !"PIE Level", i32 2}
!9 = !{i32 7, !"uwtable", i32 1}
!10 = !{i32 7, !"frame-pointer", i32 2}
!11 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!12 = distinct !DISubprogram(name: "main", scope: !13, file: !13, line: 11, type: !14, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !17)
!13 = !DIFile(filename: "benchmarks/miscellaneous/floats.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "655be55c9424586b3c1ea9b9681db180")
!14 = !DISubroutineType(types: !15)
!15 = !{!16}
!16 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!17 = !{}
!18 = !DILocalVariable(name: "f", scope: !12, file: !13, line: 12, type: !3)
!19 = !DILocation(line: 12, column: 12, scope: !12)
!20 = !DILocation(line: 12, column: 16, scope: !12)
!21 = !DILocalVariable(name: "d", scope: !12, file: !13, line: 13, type: !22)
!22 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!23 = !DILocation(line: 13, column: 12, scope: !12)
!24 = !DILocation(line: 13, column: 16, scope: !12)
!25 = !DILocalVariable(name: "d2", scope: !12, file: !13, line: 14, type: !22)
!26 = !DILocation(line: 14, column: 12, scope: !12)
!27 = !DILocation(line: 14, column: 17, scope: !12)
!28 = !DILocalVariable(name: "ff", scope: !29, file: !13, line: 133, type: !3)
!29 = distinct !DILexicalBlock(scope: !12, file: !13, line: 132, column: 5)
!30 = !DILocation(line: 133, column: 15, scope: !29)
!31 = !DILocation(line: 134, column: 9, scope: !32)
!32 = distinct !DILexicalBlock(scope: !33, file: !13, line: 134, column: 9)
!33 = distinct !DILexicalBlock(scope: !29, file: !13, line: 134, column: 9)
!34 = !DILocation(line: 134, column: 9, scope: !33)
!35 = !DILocation(line: 179, column: 5, scope: !12)
