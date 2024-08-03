; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/jumpIntoLoop.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/jumpIntoLoop.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@x = global i32 0, align 4, !dbg !0
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [15 x i8] c"jumpIntoLoop.c\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"(jumpIntoLoop && x == 5) || (!jumpIntoLoop && x == 4)\00", align 1

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !21 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !25, metadata !DIExpression()), !dbg !26
  store i32 0, i32* %2, align 4, !dbg !26
  call void @llvm.dbg.declare(metadata i32* %3, metadata !27, metadata !DIExpression()), !dbg !28
  %4 = call zeroext i1 @__VERIFIER_nondet_bool(), !dbg !29
  %5 = zext i1 %4 to i32, !dbg !29
  store i32 %5, i32* %3, align 4, !dbg !28
  %6 = load i32, i32* %3, align 4, !dbg !30
  %7 = icmp ne i32 %6, 0, !dbg !30
  br i1 %7, label %8, label %9, !dbg !32

8:                                                ; preds = %0
  br label %14, !dbg !33

9:                                                ; preds = %0
  call void @__VERIFIER_loop_bound(i32 noundef 6), !dbg !34
  store i32 1, i32* %2, align 4, !dbg !35
  br label %10, !dbg !37

10:                                               ; preds = %17, %9
  %11 = load i32, i32* %2, align 4, !dbg !38
  %12 = icmp slt i32 %11, 5, !dbg !40
  br i1 %12, label %13, label %20, !dbg !41

13:                                               ; preds = %10
  br label %14, !dbg !42

14:                                               ; preds = %13, %8
  call void @llvm.dbg.label(metadata !43), !dbg !45
  %15 = load volatile i32, i32* @x, align 4, !dbg !46
  %16 = add nsw i32 %15, 1, !dbg !46
  store volatile i32 %16, i32* @x, align 4, !dbg !46
  br label %17, !dbg !47

17:                                               ; preds = %14
  %18 = load i32, i32* %2, align 4, !dbg !48
  %19 = add nsw i32 %18, 1, !dbg !48
  store i32 %19, i32* %2, align 4, !dbg !48
  br label %10, !dbg !49, !llvm.loop !50

20:                                               ; preds = %10
  %21 = load i32, i32* %3, align 4, !dbg !53
  %22 = icmp ne i32 %21, 0, !dbg !53
  br i1 %22, label %23, label %26, !dbg !53

23:                                               ; preds = %20
  %24 = load volatile i32, i32* @x, align 4, !dbg !53
  %25 = icmp eq i32 %24, 5, !dbg !53
  br i1 %25, label %34, label %26, !dbg !53

26:                                               ; preds = %23, %20
  %27 = load i32, i32* %3, align 4, !dbg !53
  %28 = icmp ne i32 %27, 0, !dbg !53
  br i1 %28, label %32, label %29, !dbg !53

29:                                               ; preds = %26
  %30 = load volatile i32, i32* @x, align 4, !dbg !53
  %31 = icmp eq i32 %30, 4, !dbg !53
  br label %32

32:                                               ; preds = %29, %26
  %33 = phi i1 [ false, %26 ], [ %31, %29 ], !dbg !54
  br label %34, !dbg !53

34:                                               ; preds = %32, %23
  %35 = phi i1 [ true, %23 ], [ %33, %32 ]
  %36 = xor i1 %35, true, !dbg !53
  %37 = zext i1 %36 to i32, !dbg !53
  %38 = sext i32 %37 to i64, !dbg !53
  %39 = icmp ne i64 %38, 0, !dbg !53
  br i1 %39, label %40, label %42, !dbg !53

40:                                               ; preds = %34
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0), i32 noundef 19, i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !53
  unreachable, !dbg !53

41:                                               ; No predecessors!
  br label %43, !dbg !53

42:                                               ; preds = %34
  br label %43, !dbg !53

43:                                               ; preds = %42, %41
  ret i32 0, !dbg !55
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare zeroext i1 @__VERIFIER_nondet_bool() #2

declare void @__VERIFIER_loop_bound(i32 noundef) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!10, !11, !12, !13, !14, !15, !16, !17, !18, !19}
!llvm.ident = !{!20}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !5, line: 5, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!3 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/jumpIntoLoop.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!4 = !{!0}
!5 = !DIFile(filename: "benchmarks/miscellaneous/jumpIntoLoop.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!6 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !7)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !8, line: 30, baseType: !9)
!8 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_types/_int32_t.h", directory: "")
!9 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!10 = !{i32 7, !"Dwarf Version", i32 4}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = !{i32 1, !"branch-target-enforcement", i32 0}
!14 = !{i32 1, !"sign-return-address", i32 0}
!15 = !{i32 1, !"sign-return-address-all", i32 0}
!16 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!17 = !{i32 7, !"PIC Level", i32 2}
!18 = !{i32 7, !"uwtable", i32 1}
!19 = !{i32 7, !"frame-pointer", i32 1}
!20 = !{!"Homebrew clang version 14.0.6"}
!21 = distinct !DISubprogram(name: "main", scope: !5, file: !5, line: 7, type: !22, scopeLine: 8, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !24)
!22 = !DISubroutineType(types: !23)
!23 = !{!9}
!24 = !{}
!25 = !DILocalVariable(name: "i", scope: !21, file: !5, line: 9, type: !9)
!26 = !DILocation(line: 9, column: 9, scope: !21)
!27 = !DILocalVariable(name: "jumpIntoLoop", scope: !21, file: !5, line: 10, type: !9)
!28 = !DILocation(line: 10, column: 9, scope: !21)
!29 = !DILocation(line: 10, column: 24, scope: !21)
!30 = !DILocation(line: 11, column: 9, scope: !31)
!31 = distinct !DILexicalBlock(scope: !21, file: !5, line: 11, column: 9)
!32 = !DILocation(line: 11, column: 9, scope: !21)
!33 = !DILocation(line: 11, column: 23, scope: !31)
!34 = !DILocation(line: 13, column: 5, scope: !21)
!35 = !DILocation(line: 14, column: 12, scope: !36)
!36 = distinct !DILexicalBlock(scope: !21, file: !5, line: 14, column: 5)
!37 = !DILocation(line: 14, column: 10, scope: !36)
!38 = !DILocation(line: 14, column: 17, scope: !39)
!39 = distinct !DILexicalBlock(scope: !36, file: !5, line: 14, column: 5)
!40 = !DILocation(line: 14, column: 19, scope: !39)
!41 = !DILocation(line: 14, column: 5, scope: !36)
!42 = !DILocation(line: 14, column: 29, scope: !39)
!43 = !DILabel(scope: !44, name: "L", file: !5, line: 15)
!44 = distinct !DILexicalBlock(scope: !39, file: !5, line: 14, column: 29)
!45 = !DILocation(line: 15, column: 1, scope: !44)
!46 = !DILocation(line: 16, column: 10, scope: !44)
!47 = !DILocation(line: 17, column: 5, scope: !44)
!48 = !DILocation(line: 14, column: 25, scope: !39)
!49 = !DILocation(line: 14, column: 5, scope: !39)
!50 = distinct !{!50, !41, !51, !52}
!51 = !DILocation(line: 17, column: 5, scope: !36)
!52 = !{!"llvm.loop.mustprogress"}
!53 = !DILocation(line: 19, column: 5, scope: !21)
!54 = !DILocation(line: 0, scope: !21)
!55 = !DILocation(line: 20, column: 5, scope: !21)
