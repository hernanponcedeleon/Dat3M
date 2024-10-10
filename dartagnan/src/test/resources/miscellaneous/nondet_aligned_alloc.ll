; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/nondet_aligned_alloc.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/nondet_aligned_alloc.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [23 x i8] c"nondet_aligned_alloc.c\00", align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"array != array_2\00", align 1
@.str.2 = private unnamed_addr constant [25 x i8] c"((size_t)array) % 8 == 0\00", align 1
@.str.3 = private unnamed_addr constant [31 x i8] c"((size_t)array_2) % align == 0\00", align 1

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !19 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i32*, align 8
  %7 = alloca i32*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !25, metadata !DIExpression()), !dbg !26
  %8 = call i32 @__VERIFIER_nondet_int(), !dbg !27
  store i32 %8, i32* %2, align 4, !dbg !26
  call void @llvm.dbg.declare(metadata i32* %3, metadata !28, metadata !DIExpression()), !dbg !29
  %9 = call i32 @__VERIFIER_nondet_int(), !dbg !30
  store i32 %9, i32* %3, align 4, !dbg !29
  %10 = load i32, i32* %2, align 4, !dbg !31
  %11 = icmp sgt i32 %10, 0, !dbg !32
  %12 = zext i1 %11 to i32, !dbg !32
  call void @__VERIFIER_assume(i32 noundef %12), !dbg !33
  %13 = load i32, i32* %3, align 4, !dbg !34
  %14 = icmp sgt i32 %13, 0, !dbg !35
  %15 = zext i1 %14 to i32, !dbg !35
  call void @__VERIFIER_assume(i32 noundef %15), !dbg !36
  call void @llvm.dbg.declare(metadata i64* %4, metadata !37, metadata !DIExpression()), !dbg !38
  %16 = load i32, i32* %2, align 4, !dbg !39
  %17 = sext i32 %16 to i64, !dbg !40
  store i64 %17, i64* %4, align 8, !dbg !38
  call void @llvm.dbg.declare(metadata i64* %5, metadata !41, metadata !DIExpression()), !dbg !42
  %18 = load i32, i32* %3, align 4, !dbg !43
  %19 = sext i32 %18 to i64, !dbg !44
  store i64 %19, i64* %5, align 8, !dbg !42
  call void @llvm.dbg.declare(metadata i32** %6, metadata !45, metadata !DIExpression()), !dbg !47
  %20 = call i8* @malloc(i64 noundef 168) #7, !dbg !48
  %21 = bitcast i8* %20 to i32*, !dbg !48
  store i32* %21, i32** %6, align 8, !dbg !47
  call void @llvm.dbg.declare(metadata i32** %7, metadata !49, metadata !DIExpression()), !dbg !50
  %22 = load i64, i64* %5, align 8, !dbg !51
  %23 = load i64, i64* %4, align 8, !dbg !52
  %24 = mul i64 %23, 4, !dbg !53
  %25 = call i8* @aligned_alloc(i64 noundef %22, i64 noundef %24) #8, !dbg !54
  call void @llvm.assume(i1 true) [ "align"(i8* %25, i64 %22) ], !dbg !54
  %26 = bitcast i8* %25 to i32*, !dbg !54
  store i32* %26, i32** %7, align 8, !dbg !50
  %27 = load i32*, i32** %6, align 8, !dbg !55
  %28 = load i32*, i32** %7, align 8, !dbg !55
  %29 = icmp ne i32* %27, %28, !dbg !55
  %30 = xor i1 %29, true, !dbg !55
  %31 = zext i1 %30 to i32, !dbg !55
  %32 = sext i32 %31 to i64, !dbg !55
  %33 = icmp ne i64 %32, 0, !dbg !55
  br i1 %33, label %34, label %36, !dbg !55

34:                                               ; preds = %0
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.1, i64 0, i64 0)) #9, !dbg !55
  unreachable, !dbg !55

35:                                               ; No predecessors!
  br label %37, !dbg !55

36:                                               ; preds = %0
  br label %37, !dbg !55

37:                                               ; preds = %36, %35
  %38 = load i32*, i32** %6, align 8, !dbg !56
  %39 = ptrtoint i32* %38 to i64, !dbg !56
  %40 = urem i64 %39, 8, !dbg !56
  %41 = icmp eq i64 %40, 0, !dbg !56
  %42 = xor i1 %41, true, !dbg !56
  %43 = zext i1 %42 to i32, !dbg !56
  %44 = sext i32 %43 to i64, !dbg !56
  %45 = icmp ne i64 %44, 0, !dbg !56
  br i1 %45, label %46, label %48, !dbg !56

46:                                               ; preds = %37
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i64 0, i64 0), i32 noundef 21, i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.2, i64 0, i64 0)) #9, !dbg !56
  unreachable, !dbg !56

47:                                               ; No predecessors!
  br label %49, !dbg !56

48:                                               ; preds = %37
  br label %49, !dbg !56

49:                                               ; preds = %48, %47
  %50 = load i32*, i32** %7, align 8, !dbg !57
  %51 = ptrtoint i32* %50 to i64, !dbg !57
  %52 = load i64, i64* %5, align 8, !dbg !57
  %53 = urem i64 %51, %52, !dbg !57
  %54 = icmp eq i64 %53, 0, !dbg !57
  %55 = xor i1 %54, true, !dbg !57
  %56 = zext i1 %55 to i32, !dbg !57
  %57 = sext i32 %56 to i64, !dbg !57
  %58 = icmp ne i64 %57, 0, !dbg !57
  br i1 %58, label %59, label %61, !dbg !57

59:                                               ; preds = %49
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i64 0, i64 0), i32 noundef 22, i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.3, i64 0, i64 0)) #9, !dbg !57
  unreachable, !dbg !57

60:                                               ; No predecessors!
  br label %62, !dbg !57

61:                                               ; preds = %49
  br label %62, !dbg !57

62:                                               ; preds = %61, %60
  %63 = load i32, i32* %1, align 4, !dbg !58
  ret i32 %63, !dbg !58
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @__VERIFIER_nondet_int() #2

declare void @__VERIFIER_assume(i32 noundef) #2

; Function Attrs: allocsize(0)
declare i8* @malloc(i64 noundef) #3

; Function Attrs: allocsize(1)
declare i8* @aligned_alloc(i64 noundef, i64 noundef) #4

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.assume(i1 noundef) #5

; Function Attrs: cold noreturn
declare void @__assert_rtn(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #6

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #3 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #4 = { allocsize(1) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #5 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #6 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #7 = { allocsize(0) }
attributes #8 = { allocsize(1) }
attributes #9 = { cold noreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!8, !9, !10, !11, !12, !13, !14, !15, !16, !17}
!llvm.ident = !{!18}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!1 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/nondet_aligned_alloc.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!2 = !{!3}
!3 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !4, line: 31, baseType: !5)
!4 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/sys/_types/_size_t.h", directory: "")
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_size_t", file: !6, line: 70, baseType: !7)
!6 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk/usr/include/arm/_types.h", directory: "")
!7 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!8 = !{i32 7, !"Dwarf Version", i32 4}
!9 = !{i32 2, !"Debug Info Version", i32 3}
!10 = !{i32 1, !"wchar_size", i32 4}
!11 = !{i32 1, !"branch-target-enforcement", i32 0}
!12 = !{i32 1, !"sign-return-address", i32 0}
!13 = !{i32 1, !"sign-return-address-all", i32 0}
!14 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!15 = !{i32 7, !"PIC Level", i32 2}
!16 = !{i32 7, !"uwtable", i32 1}
!17 = !{i32 7, !"frame-pointer", i32 1}
!18 = !{!"Homebrew clang version 14.0.6"}
!19 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 6, type: !21, scopeLine: 7, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !24)
!20 = !DIFile(filename: "benchmarks/miscellaneous/nondet_aligned_alloc.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!21 = !DISubroutineType(types: !22)
!22 = !{!23}
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !{}
!25 = !DILocalVariable(name: "size_int", scope: !19, file: !20, line: 8, type: !23)
!26 = !DILocation(line: 8, column: 9, scope: !19)
!27 = !DILocation(line: 8, column: 20, scope: !19)
!28 = !DILocalVariable(name: "align_int", scope: !19, file: !20, line: 9, type: !23)
!29 = !DILocation(line: 9, column: 9, scope: !19)
!30 = !DILocation(line: 9, column: 21, scope: !19)
!31 = !DILocation(line: 10, column: 23, scope: !19)
!32 = !DILocation(line: 10, column: 32, scope: !19)
!33 = !DILocation(line: 10, column: 5, scope: !19)
!34 = !DILocation(line: 11, column: 23, scope: !19)
!35 = !DILocation(line: 11, column: 33, scope: !19)
!36 = !DILocation(line: 11, column: 5, scope: !19)
!37 = !DILocalVariable(name: "size", scope: !19, file: !20, line: 12, type: !3)
!38 = !DILocation(line: 12, column: 12, scope: !19)
!39 = !DILocation(line: 12, column: 27, scope: !19)
!40 = !DILocation(line: 12, column: 19, scope: !19)
!41 = !DILocalVariable(name: "align", scope: !19, file: !20, line: 13, type: !3)
!42 = !DILocation(line: 13, column: 12, scope: !19)
!43 = !DILocation(line: 13, column: 28, scope: !19)
!44 = !DILocation(line: 13, column: 20, scope: !19)
!45 = !DILocalVariable(name: "array", scope: !19, file: !20, line: 14, type: !46)
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!47 = !DILocation(line: 14, column: 10, scope: !19)
!48 = !DILocation(line: 14, column: 18, scope: !19)
!49 = !DILocalVariable(name: "array_2", scope: !19, file: !20, line: 15, type: !46)
!50 = !DILocation(line: 15, column: 10, scope: !19)
!51 = !DILocation(line: 15, column: 34, scope: !19)
!52 = !DILocation(line: 15, column: 41, scope: !19)
!53 = !DILocation(line: 15, column: 46, scope: !19)
!54 = !DILocation(line: 15, column: 20, scope: !19)
!55 = !DILocation(line: 20, column: 5, scope: !19)
!56 = !DILocation(line: 21, column: 5, scope: !19)
!57 = !DILocation(line: 22, column: 5, scope: !19)
!58 = !DILocation(line: 23, column: 1, scope: !19)
