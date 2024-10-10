; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/nondet_alloc.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/nondet_alloc.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [15 x i8] c"nondet_alloc.c\00", align 1
@.str.1 = private unnamed_addr constant [38 x i8] c"sum < (MAX_SIZE * (MAX_SIZE - 1)) / 2\00", align 1

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !13 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !19, metadata !DIExpression()), !dbg !20
  %7 = call i32 @__VERIFIER_nondet_int(), !dbg !21
  store i32 %7, i32* %2, align 4, !dbg !20
  %8 = load i32, i32* %2, align 4, !dbg !22
  %9 = icmp sgt i32 %8, 0, !dbg !23
  br i1 %9, label %10, label %13, !dbg !24

10:                                               ; preds = %0
  %11 = load i32, i32* %2, align 4, !dbg !25
  %12 = icmp sle i32 %11, 10, !dbg !26
  br label %13

13:                                               ; preds = %10, %0
  %14 = phi i1 [ false, %0 ], [ %12, %10 ], !dbg !27
  %15 = zext i1 %14 to i32, !dbg !24
  call void @__VERIFIER_assume(i32 noundef %15), !dbg !28
  call void @llvm.dbg.declare(metadata i32** %3, metadata !29, metadata !DIExpression()), !dbg !31
  %16 = load i32, i32* %2, align 4, !dbg !32
  %17 = sext i32 %16 to i64, !dbg !32
  %18 = mul i64 %17, 4, !dbg !33
  %19 = call i8* @malloc(i64 noundef %18), !dbg !34
  %20 = bitcast i8* %19 to i32*, !dbg !34
  store i32* %20, i32** %3, align 8, !dbg !31
  call void @__VERIFIER_loop_bound(i32 noundef 11), !dbg !35
  call void @llvm.dbg.declare(metadata i32* %4, metadata !36, metadata !DIExpression()), !dbg !38
  store i32 0, i32* %4, align 4, !dbg !38
  br label %21, !dbg !39

21:                                               ; preds = %31, %13
  %22 = load i32, i32* %4, align 4, !dbg !40
  %23 = load i32, i32* %2, align 4, !dbg !42
  %24 = icmp slt i32 %22, %23, !dbg !43
  br i1 %24, label %25, label %34, !dbg !44

25:                                               ; preds = %21
  %26 = load i32, i32* %4, align 4, !dbg !45
  %27 = load i32*, i32** %3, align 8, !dbg !47
  %28 = load i32, i32* %4, align 4, !dbg !48
  %29 = sext i32 %28 to i64, !dbg !47
  %30 = getelementptr inbounds i32, i32* %27, i64 %29, !dbg !47
  store i32 %26, i32* %30, align 4, !dbg !49
  br label %31, !dbg !50

31:                                               ; preds = %25
  %32 = load i32, i32* %4, align 4, !dbg !51
  %33 = add nsw i32 %32, 1, !dbg !51
  store i32 %33, i32* %4, align 4, !dbg !51
  br label %21, !dbg !52, !llvm.loop !53

34:                                               ; preds = %21
  call void @llvm.dbg.declare(metadata i32* %5, metadata !56, metadata !DIExpression()), !dbg !57
  store i32 0, i32* %5, align 4, !dbg !57
  call void @__VERIFIER_loop_bound(i32 noundef 11), !dbg !58
  call void @llvm.dbg.declare(metadata i32* %6, metadata !59, metadata !DIExpression()), !dbg !61
  store i32 0, i32* %6, align 4, !dbg !61
  br label %35, !dbg !62

35:                                               ; preds = %47, %34
  %36 = load i32, i32* %6, align 4, !dbg !63
  %37 = load i32, i32* %2, align 4, !dbg !65
  %38 = icmp slt i32 %36, %37, !dbg !66
  br i1 %38, label %39, label %50, !dbg !67

39:                                               ; preds = %35
  %40 = load i32*, i32** %3, align 8, !dbg !68
  %41 = load i32, i32* %6, align 4, !dbg !70
  %42 = sext i32 %41 to i64, !dbg !68
  %43 = getelementptr inbounds i32, i32* %40, i64 %42, !dbg !68
  %44 = load i32, i32* %43, align 4, !dbg !68
  %45 = load i32, i32* %5, align 4, !dbg !71
  %46 = add nsw i32 %45, %44, !dbg !71
  store i32 %46, i32* %5, align 4, !dbg !71
  br label %47, !dbg !72

47:                                               ; preds = %39
  %48 = load i32, i32* %6, align 4, !dbg !73
  %49 = add nsw i32 %48, 1, !dbg !73
  store i32 %49, i32* %6, align 4, !dbg !73
  br label %35, !dbg !74, !llvm.loop !75

50:                                               ; preds = %35
  %51 = load i32, i32* %5, align 4, !dbg !77
  %52 = icmp slt i32 %51, 45, !dbg !77
  %53 = xor i1 %52, true, !dbg !77
  %54 = zext i1 %53 to i32, !dbg !77
  %55 = sext i32 %54 to i64, !dbg !77
  %56 = icmp ne i64 %55, 0, !dbg !77
  br i1 %56, label %57, label %59, !dbg !77

57:                                               ; preds = %50
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0), i32 noundef 26, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !77
  unreachable, !dbg !77

58:                                               ; No predecessors!
  br label %60, !dbg !77

59:                                               ; preds = %50
  br label %60, !dbg !77

60:                                               ; preds = %59, %58
  %61 = load i32, i32* %1, align 4, !dbg !78
  ret i32 %61, !dbg !78
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @__VERIFIER_nondet_int() #2

declare void @__VERIFIER_assume(i32 noundef) #2

declare i8* @malloc(i64 noundef) #2

declare void @__VERIFIER_loop_bound(i32 noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #4 = { cold noreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8, !9, !10, !11}
!llvm.ident = !{!12}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!1 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/nondet_alloc.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!2 = !{i32 7, !"Dwarf Version", i32 4}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 1, !"branch-target-enforcement", i32 0}
!6 = !{i32 1, !"sign-return-address", i32 0}
!7 = !{i32 1, !"sign-return-address-all", i32 0}
!8 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!9 = !{i32 7, !"PIC Level", i32 2}
!10 = !{i32 7, !"uwtable", i32 1}
!11 = !{i32 7, !"frame-pointer", i32 1}
!12 = !{!"Homebrew clang version 14.0.6"}
!13 = distinct !DISubprogram(name: "main", scope: !14, file: !14, line: 8, type: !15, scopeLine: 9, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !18)
!14 = !DIFile(filename: "benchmarks/miscellaneous/nondet_alloc.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!15 = !DISubroutineType(types: !16)
!16 = !{!17}
!17 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!18 = !{}
!19 = !DILocalVariable(name: "size", scope: !13, file: !14, line: 10, type: !17)
!20 = !DILocation(line: 10, column: 9, scope: !13)
!21 = !DILocation(line: 10, column: 16, scope: !13)
!22 = !DILocation(line: 11, column: 23, scope: !13)
!23 = !DILocation(line: 11, column: 28, scope: !13)
!24 = !DILocation(line: 11, column: 32, scope: !13)
!25 = !DILocation(line: 11, column: 35, scope: !13)
!26 = !DILocation(line: 11, column: 40, scope: !13)
!27 = !DILocation(line: 0, scope: !13)
!28 = !DILocation(line: 11, column: 5, scope: !13)
!29 = !DILocalVariable(name: "array", scope: !13, file: !14, line: 12, type: !30)
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!31 = !DILocation(line: 12, column: 10, scope: !13)
!32 = !DILocation(line: 12, column: 25, scope: !13)
!33 = !DILocation(line: 12, column: 30, scope: !13)
!34 = !DILocation(line: 12, column: 18, scope: !13)
!35 = !DILocation(line: 14, column: 5, scope: !13)
!36 = !DILocalVariable(name: "i", scope: !37, file: !14, line: 15, type: !17)
!37 = distinct !DILexicalBlock(scope: !13, file: !14, line: 15, column: 5)
!38 = !DILocation(line: 15, column: 14, scope: !37)
!39 = !DILocation(line: 15, column: 10, scope: !37)
!40 = !DILocation(line: 15, column: 21, scope: !41)
!41 = distinct !DILexicalBlock(scope: !37, file: !14, line: 15, column: 5)
!42 = !DILocation(line: 15, column: 25, scope: !41)
!43 = !DILocation(line: 15, column: 23, scope: !41)
!44 = !DILocation(line: 15, column: 5, scope: !37)
!45 = !DILocation(line: 16, column: 20, scope: !46)
!46 = distinct !DILexicalBlock(scope: !41, file: !14, line: 15, column: 36)
!47 = !DILocation(line: 16, column: 9, scope: !46)
!48 = !DILocation(line: 16, column: 15, scope: !46)
!49 = !DILocation(line: 16, column: 18, scope: !46)
!50 = !DILocation(line: 17, column: 5, scope: !46)
!51 = !DILocation(line: 15, column: 32, scope: !41)
!52 = !DILocation(line: 15, column: 5, scope: !41)
!53 = distinct !{!53, !44, !54, !55}
!54 = !DILocation(line: 17, column: 5, scope: !37)
!55 = !{!"llvm.loop.mustprogress"}
!56 = !DILocalVariable(name: "sum", scope: !13, file: !14, line: 19, type: !17)
!57 = !DILocation(line: 19, column: 9, scope: !13)
!58 = !DILocation(line: 20, column: 5, scope: !13)
!59 = !DILocalVariable(name: "i", scope: !60, file: !14, line: 21, type: !17)
!60 = distinct !DILexicalBlock(scope: !13, file: !14, line: 21, column: 5)
!61 = !DILocation(line: 21, column: 14, scope: !60)
!62 = !DILocation(line: 21, column: 10, scope: !60)
!63 = !DILocation(line: 21, column: 21, scope: !64)
!64 = distinct !DILexicalBlock(scope: !60, file: !14, line: 21, column: 5)
!65 = !DILocation(line: 21, column: 25, scope: !64)
!66 = !DILocation(line: 21, column: 23, scope: !64)
!67 = !DILocation(line: 21, column: 5, scope: !60)
!68 = !DILocation(line: 22, column: 16, scope: !69)
!69 = distinct !DILexicalBlock(scope: !64, file: !14, line: 21, column: 36)
!70 = !DILocation(line: 22, column: 22, scope: !69)
!71 = !DILocation(line: 22, column: 13, scope: !69)
!72 = !DILocation(line: 23, column: 5, scope: !69)
!73 = !DILocation(line: 21, column: 32, scope: !64)
!74 = !DILocation(line: 21, column: 5, scope: !64)
!75 = distinct !{!75, !67, !76, !55}
!76 = !DILocation(line: 23, column: 5, scope: !60)
!77 = !DILocation(line: 26, column: 5, scope: !13)
!78 = !DILocation(line: 27, column: 1, scope: !13)
