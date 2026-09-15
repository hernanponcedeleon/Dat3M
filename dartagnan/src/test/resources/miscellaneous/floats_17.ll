; ModuleID = 'benchmarks/miscellaneous/floats.c'
source_filename = "benchmarks/miscellaneous/floats.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx16.0.0"

@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [9 x i8] c"floats.c\00", align 1
@.str.1 = private unnamed_addr constant [24 x i8] c"unordered_equal(d, 0.0)\00", align 1
@.str.2 = private unnamed_addr constant [28 x i8] c"unordered_less_than(d, 0.0)\00", align 1
@.str.3 = private unnamed_addr constant [34 x i8] c"unordered_less_than_equal(d, 0.0)\00", align 1
@.str.4 = private unnamed_addr constant [31 x i8] c"unordered_greater_than(d, 0.0)\00", align 1
@.str.5 = private unnamed_addr constant [37 x i8] c"unordered_greater_than_equal(d, 0.0)\00", align 1

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind readnone ssp uwtable willreturn
define i32 @unordered_equal(double noundef %0, double noundef %1) local_unnamed_addr #0 !dbg !18 {
  call void @llvm.dbg.value(metadata double %0, metadata !23, metadata !DIExpression()), !dbg !25
  call void @llvm.dbg.value(metadata double %1, metadata !24, metadata !DIExpression()), !dbg !25
  %3 = fcmp ueq double %0, %1, !dbg !26
  %4 = zext i1 %3 to i32, !dbg !26
  ret i32 %4, !dbg !27
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind readnone ssp uwtable willreturn
define i32 @unordered_less_than(double noundef %0, double noundef %1) local_unnamed_addr #0 !dbg !28 {
  call void @llvm.dbg.value(metadata double %0, metadata !30, metadata !DIExpression()), !dbg !32
  call void @llvm.dbg.value(metadata double %1, metadata !31, metadata !DIExpression()), !dbg !32
  %3 = fcmp ult double %0, %1, !dbg !33
  %4 = zext i1 %3 to i32, !dbg !33
  ret i32 %4, !dbg !34
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind readnone ssp uwtable willreturn
define i32 @unordered_less_than_equal(double noundef %0, double noundef %1) local_unnamed_addr #0 !dbg !35 {
  call void @llvm.dbg.value(metadata double %0, metadata !37, metadata !DIExpression()), !dbg !39
  call void @llvm.dbg.value(metadata double %1, metadata !38, metadata !DIExpression()), !dbg !39
  %3 = fcmp ule double %0, %1, !dbg !40
  %4 = zext i1 %3 to i32, !dbg !40
  ret i32 %4, !dbg !41
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind readnone ssp uwtable willreturn
define i32 @unordered_greater_than(double noundef %0, double noundef %1) local_unnamed_addr #0 !dbg !42 {
  call void @llvm.dbg.value(metadata double %0, metadata !44, metadata !DIExpression()), !dbg !46
  call void @llvm.dbg.value(metadata double %1, metadata !45, metadata !DIExpression()), !dbg !46
  %3 = fcmp ugt double %0, %1, !dbg !47
  %4 = zext i1 %3 to i32, !dbg !47
  ret i32 %4, !dbg !48
}

; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind readnone ssp uwtable willreturn
define i32 @unordered_greater_than_equal(double noundef %0, double noundef %1) local_unnamed_addr #0 !dbg !49 {
  call void @llvm.dbg.value(metadata double %0, metadata !51, metadata !DIExpression()), !dbg !53
  call void @llvm.dbg.value(metadata double %1, metadata !52, metadata !DIExpression()), !dbg !53
  %3 = fcmp uge double %0, %1, !dbg !54
  %4 = zext i1 %3 to i32, !dbg !54
  ret i32 %4, !dbg !55
}

; Function Attrs: nounwind ssp uwtable
define i32 @main() local_unnamed_addr #1 !dbg !56 {
  %1 = call float @__VERIFIER_nondet_float() #5, !dbg !63
  call void @llvm.dbg.value(metadata float %1, metadata !60, metadata !DIExpression()), !dbg !64
  %2 = call double @__VERIFIER_nondet_double() #5, !dbg !65
  call void @llvm.dbg.value(metadata double %2, metadata !61, metadata !DIExpression()), !dbg !64
  %3 = call double @__VERIFIER_nondet_double() #5, !dbg !66
  call void @llvm.dbg.value(metadata double %3, metadata !62, metadata !DIExpression()), !dbg !64
  call void @llvm.dbg.value(metadata double %2, metadata !67, metadata !DIExpression()), !dbg !73
  %4 = fcmp ord double %2, 0.000000e+00, !dbg !76
  br i1 %4, label %25, label %5, !dbg !77

5:                                                ; preds = %0
  %6 = call i32 @unordered_equal(double noundef %2, double noundef 0.000000e+00), !dbg !78
  %7 = icmp eq i32 %6, 0, !dbg !78
  br i1 %7, label %8, label %9, !dbg !78, !prof !80

8:                                                ; preds = %5
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i32 noundef 199, i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @.str.1, i64 0, i64 0)) #6, !dbg !78
  unreachable, !dbg !78

9:                                                ; preds = %5
  %10 = call i32 @unordered_less_than(double noundef %2, double noundef 0.000000e+00), !dbg !81
  %11 = icmp eq i32 %10, 0, !dbg !81
  br i1 %11, label %12, label %13, !dbg !81, !prof !80

12:                                               ; preds = %9
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i32 noundef 200, i8* noundef getelementptr inbounds ([28 x i8], [28 x i8]* @.str.2, i64 0, i64 0)) #6, !dbg !81
  unreachable, !dbg !81

13:                                               ; preds = %9
  %14 = call i32 @unordered_less_than_equal(double noundef %2, double noundef 0.000000e+00), !dbg !82
  %15 = icmp eq i32 %14, 0, !dbg !82
  br i1 %15, label %16, label %17, !dbg !82, !prof !80

16:                                               ; preds = %13
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i32 noundef 201, i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.3, i64 0, i64 0)) #6, !dbg !82
  unreachable, !dbg !82

17:                                               ; preds = %13
  %18 = call i32 @unordered_greater_than(double noundef %2, double noundef 0.000000e+00), !dbg !83
  %19 = icmp eq i32 %18, 0, !dbg !83
  br i1 %19, label %20, label %21, !dbg !83, !prof !80

20:                                               ; preds = %17
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i32 noundef 202, i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.4, i64 0, i64 0)) #6, !dbg !83
  unreachable, !dbg !83

21:                                               ; preds = %17
  %22 = call i32 @unordered_greater_than_equal(double noundef %2, double noundef 0.000000e+00), !dbg !84
  %23 = icmp eq i32 %22, 0, !dbg !84
  br i1 %23, label %24, label %25, !dbg !84, !prof !80

24:                                               ; preds = %21
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i32 noundef 203, i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @.str.5, i64 0, i64 0)) #6, !dbg !84
  unreachable, !dbg !84

25:                                               ; preds = %21, %0
  ret i32 0, !dbg !85
}

declare float @__VERIFIER_nondet_float() local_unnamed_addr #2

declare double @__VERIFIER_nondet_double() local_unnamed_addr #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(i8* noundef, i8* noundef, i32 noundef, i8* noundef) local_unnamed_addr #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #4

attributes #0 = { mustprogress nofree noinline norecurse nosync nounwind readnone ssp uwtable willreturn "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #4 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #5 = { nounwind }
attributes #6 = { cold noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5, !6, !7, !8, !9, !10}
!llvm.dbg.cu = !{!11}
!llvm.ident = !{!17}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!1 = !{i32 7, !"Dwarf Version", i32 4}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{i32 1, !"branch-target-enforcement", i32 0}
!5 = !{i32 1, !"sign-return-address", i32 0}
!6 = !{i32 1, !"sign-return-address-all", i32 0}
!7 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!8 = !{i32 7, !"PIC Level", i32 2}
!9 = !{i32 7, !"uwtable", i32 1}
!10 = !{i32 7, !"frame-pointer", i32 1}
!11 = distinct !DICompileUnit(language: DW_LANG_C99, file: !12, producer: "Homebrew clang version 14.0.6", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !13, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk", sdk: "MacOSX.sdk")
!12 = !DIFile(filename: "benchmarks/miscellaneous/floats.c", directory: "/Users/hponcedeleon/git/Dat3M")
!13 = !{!14, !15, !16}
!14 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!15 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!16 = !DIBasicType(name: "long double", size: 64, encoding: DW_ATE_float)
!17 = !{!"Homebrew clang version 14.0.6"}
!18 = distinct !DISubprogram(name: "unordered_equal", scope: !12, file: !12, line: 12, type: !19, scopeLine: 12, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !11, retainedNodes: !22)
!19 = !DISubroutineType(types: !20)
!20 = !{!21, !15, !15}
!21 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!22 = !{!23, !24}
!23 = !DILocalVariable(name: "x", arg: 1, scope: !18, file: !12, line: 12, type: !15)
!24 = !DILocalVariable(name: "y", arg: 2, scope: !18, file: !12, line: 12, type: !15)
!25 = !DILocation(line: 0, scope: !18)
!26 = !DILocation(line: 13, column: 12, scope: !18)
!27 = !DILocation(line: 13, column: 5, scope: !18)
!28 = distinct !DISubprogram(name: "unordered_less_than", scope: !12, file: !12, line: 16, type: !19, scopeLine: 16, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !11, retainedNodes: !29)
!29 = !{!30, !31}
!30 = !DILocalVariable(name: "x", arg: 1, scope: !28, file: !12, line: 16, type: !15)
!31 = !DILocalVariable(name: "y", arg: 2, scope: !28, file: !12, line: 16, type: !15)
!32 = !DILocation(line: 0, scope: !28)
!33 = !DILocation(line: 17, column: 12, scope: !28)
!34 = !DILocation(line: 17, column: 5, scope: !28)
!35 = distinct !DISubprogram(name: "unordered_less_than_equal", scope: !12, file: !12, line: 20, type: !19, scopeLine: 20, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !11, retainedNodes: !36)
!36 = !{!37, !38}
!37 = !DILocalVariable(name: "x", arg: 1, scope: !35, file: !12, line: 20, type: !15)
!38 = !DILocalVariable(name: "y", arg: 2, scope: !35, file: !12, line: 20, type: !15)
!39 = !DILocation(line: 0, scope: !35)
!40 = !DILocation(line: 21, column: 12, scope: !35)
!41 = !DILocation(line: 21, column: 5, scope: !35)
!42 = distinct !DISubprogram(name: "unordered_greater_than", scope: !12, file: !12, line: 24, type: !19, scopeLine: 24, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !11, retainedNodes: !43)
!43 = !{!44, !45}
!44 = !DILocalVariable(name: "x", arg: 1, scope: !42, file: !12, line: 24, type: !15)
!45 = !DILocalVariable(name: "y", arg: 2, scope: !42, file: !12, line: 24, type: !15)
!46 = !DILocation(line: 0, scope: !42)
!47 = !DILocation(line: 25, column: 12, scope: !42)
!48 = !DILocation(line: 25, column: 5, scope: !42)
!49 = distinct !DISubprogram(name: "unordered_greater_than_equal", scope: !12, file: !12, line: 28, type: !19, scopeLine: 28, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !11, retainedNodes: !50)
!50 = !{!51, !52}
!51 = !DILocalVariable(name: "x", arg: 1, scope: !49, file: !12, line: 28, type: !15)
!52 = !DILocalVariable(name: "y", arg: 2, scope: !49, file: !12, line: 28, type: !15)
!53 = !DILocation(line: 0, scope: !49)
!54 = !DILocation(line: 29, column: 12, scope: !49)
!55 = !DILocation(line: 29, column: 5, scope: !49)
!56 = distinct !DISubprogram(name: "main", scope: !12, file: !12, line: 33, type: !57, scopeLine: 33, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !11, retainedNodes: !59)
!57 = !DISubroutineType(types: !58)
!58 = !{!21}
!59 = !{!60, !61, !62}
!60 = !DILocalVariable(name: "f", scope: !56, file: !12, line: 34, type: !14)
!61 = !DILocalVariable(name: "d", scope: !56, file: !12, line: 35, type: !15)
!62 = !DILocalVariable(name: "d2", scope: !56, file: !12, line: 36, type: !15)
!63 = !DILocation(line: 34, column: 16, scope: !56)
!64 = !DILocation(line: 0, scope: !56)
!65 = !DILocation(line: 35, column: 16, scope: !56)
!66 = !DILocation(line: 36, column: 17, scope: !56)
!67 = !DILocalVariable(name: "__x", arg: 1, scope: !68, file: !69, line: 227, type: !15)
!68 = distinct !DISubprogram(name: "__inline_isnand", scope: !69, file: !69, line: 227, type: !70, scopeLine: 227, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !11, retainedNodes: !72)
!69 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/math.h", directory: "")
!70 = !DISubroutineType(types: !71)
!71 = !{!21, !15}
!72 = !{!67}
!73 = !DILocation(line: 0, scope: !68, inlinedAt: !74)
!74 = distinct !DILocation(line: 198, column: 9, scope: !75)
!75 = distinct !DILexicalBlock(scope: !56, file: !12, line: 198, column: 9)
!76 = !DILocation(line: 228, column: 16, scope: !68, inlinedAt: !74)
!77 = !DILocation(line: 198, column: 9, scope: !75)
!78 = !DILocation(line: 199, column: 9, scope: !79)
!79 = distinct !DILexicalBlock(scope: !75, file: !12, line: 198, column: 19)
!80 = !{!"branch_weights", i32 1, i32 2000}
!81 = !DILocation(line: 200, column: 9, scope: !79)
!82 = !DILocation(line: 201, column: 9, scope: !79)
!83 = !DILocation(line: 202, column: 9, scope: !79)
!84 = !DILocation(line: 203, column: 9, scope: !79)
!85 = !DILocation(line: 210, column: 5, scope: !56)
