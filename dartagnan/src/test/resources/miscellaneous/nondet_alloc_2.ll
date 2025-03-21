; ModuleID = '/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/nondet_alloc_2.c'
source_filename = "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/nondet_alloc_2.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [17 x i8] c"nondet_alloc_2.c\00", align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"array != array_2\00", align 1
@.str.2 = private unnamed_addr constant [25 x i8] c"((size_t)array) % 8 == 0\00", align 1
@.str.3 = private unnamed_addr constant [27 x i8] c"((size_t)array_2) % 8 == 0\00", align 1

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 !dbg !19 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i64, align 8
  %4 = alloca i32*, align 8
  %5 = alloca i32*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !25, metadata !DIExpression()), !dbg !26
  %6 = call i32 @__VERIFIER_nondet_int(), !dbg !27
  store i32 %6, i32* %2, align 4, !dbg !26
  %7 = load i32, i32* %2, align 4, !dbg !28
  %8 = icmp sgt i32 %7, 0, !dbg !29
  %9 = zext i1 %8 to i32, !dbg !29
  call void @__VERIFIER_assume(i32 noundef %9), !dbg !30
  call void @llvm.dbg.declare(metadata i64* %3, metadata !31, metadata !DIExpression()), !dbg !32
  %10 = load i32, i32* %2, align 4, !dbg !33
  %11 = sext i32 %10 to i64, !dbg !34
  store i64 %11, i64* %3, align 8, !dbg !32
  call void @llvm.dbg.declare(metadata i32** %4, metadata !35, metadata !DIExpression()), !dbg !37
  %12 = load i64, i64* %3, align 8, !dbg !38
  %13 = mul i64 %12, 4, !dbg !39
  %14 = call i8* @malloc(i64 noundef %13) #5, !dbg !40
  %15 = bitcast i8* %14 to i32*, !dbg !40
  store i32* %15, i32** %4, align 8, !dbg !37
  call void @llvm.dbg.declare(metadata i32** %5, metadata !41, metadata !DIExpression()), !dbg !42
  %16 = load i64, i64* %3, align 8, !dbg !43
  %17 = mul i64 %16, 4, !dbg !44
  %18 = call i8* @malloc(i64 noundef %17) #5, !dbg !45
  %19 = bitcast i8* %18 to i32*, !dbg !45
  store i32* %19, i32** %5, align 8, !dbg !42
  %20 = load i32*, i32** %4, align 8, !dbg !46
  %21 = load i32*, i32** %5, align 8, !dbg !46
  %22 = icmp ne i32* %20, %21, !dbg !46
  %23 = xor i1 %22, true, !dbg !46
  %24 = zext i1 %23 to i32, !dbg !46
  %25 = sext i32 %24 to i64, !dbg !46
  %26 = icmp ne i64 %25, 0, !dbg !46
  br i1 %26, label %27, label %29, !dbg !46

27:                                               ; preds = %0
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i32 noundef 14, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.1, i64 0, i64 0)) #6, !dbg !46
  unreachable, !dbg !46

28:                                               ; No predecessors!
  br label %30, !dbg !46

29:                                               ; preds = %0
  br label %30, !dbg !46

30:                                               ; preds = %29, %28
  %31 = load i32*, i32** %4, align 8, !dbg !47
  %32 = ptrtoint i32* %31 to i64, !dbg !47
  %33 = urem i64 %32, 8, !dbg !47
  %34 = icmp eq i64 %33, 0, !dbg !47
  %35 = xor i1 %34, true, !dbg !47
  %36 = zext i1 %35 to i32, !dbg !47
  %37 = sext i32 %36 to i64, !dbg !47
  %38 = icmp ne i64 %37, 0, !dbg !47
  br i1 %38, label %39, label %41, !dbg !47

39:                                               ; preds = %30
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i32 noundef 15, i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.2, i64 0, i64 0)) #6, !dbg !47
  unreachable, !dbg !47

40:                                               ; No predecessors!
  br label %42, !dbg !47

41:                                               ; preds = %30
  br label %42, !dbg !47

42:                                               ; preds = %41, %40
  %43 = load i32*, i32** %5, align 8, !dbg !48
  %44 = ptrtoint i32* %43 to i64, !dbg !48
  %45 = urem i64 %44, 8, !dbg !48
  %46 = icmp eq i64 %45, 0, !dbg !48
  %47 = xor i1 %46, true, !dbg !48
  %48 = zext i1 %47 to i32, !dbg !48
  %49 = sext i32 %48 to i64, !dbg !48
  %50 = icmp ne i64 %49, 0, !dbg !48
  br i1 %50, label %51, label %53, !dbg !48

51:                                               ; preds = %42
  call void @__assert_rtn(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__func__.main, i64 0, i64 0), i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i32 noundef 16, i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.3, i64 0, i64 0)) #6, !dbg !48
  unreachable, !dbg !48

52:                                               ; No predecessors!
  br label %54, !dbg !48

53:                                               ; preds = %42
  br label %54, !dbg !48

54:                                               ; preds = %53, %52
  %55 = load i32, i32* %1, align 4, !dbg !49
  ret i32 %55, !dbg !49
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @__VERIFIER_nondet_int() #2

declare void @__VERIFIER_assume(i32 noundef) #2

; Function Attrs: allocsize(0)
declare i8* @malloc(i64 noundef) #3

; Function Attrs: cold noreturn
declare void @__assert_rtn(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

attributes #0 = { noinline nounwind ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #3 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #4 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+v8.5a,+zcm,+zcz" }
attributes #5 = { allocsize(0) }
attributes #6 = { cold noreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!8, !9, !10, !11, !12, !13, !14, !15, !16, !17}
!llvm.ident = !{!18}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Homebrew clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX13.sdk", sdk: "MacOSX13.sdk")
!1 = !DIFile(filename: "/Users/thomashaas/IdeaProjects/Dat3M/benchmarks/miscellaneous/nondet_alloc_2.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
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
!20 = !DIFile(filename: "benchmarks/miscellaneous/nondet_alloc_2.c", directory: "/Users/thomashaas/IdeaProjects/Dat3M")
!21 = !DISubroutineType(types: !22)
!22 = !{!23}
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !{}
!25 = !DILocalVariable(name: "size_int", scope: !19, file: !20, line: 8, type: !23)
!26 = !DILocation(line: 8, column: 9, scope: !19)
!27 = !DILocation(line: 8, column: 20, scope: !19)
!28 = !DILocation(line: 9, column: 23, scope: !19)
!29 = !DILocation(line: 9, column: 32, scope: !19)
!30 = !DILocation(line: 9, column: 5, scope: !19)
!31 = !DILocalVariable(name: "size", scope: !19, file: !20, line: 10, type: !3)
!32 = !DILocation(line: 10, column: 12, scope: !19)
!33 = !DILocation(line: 10, column: 27, scope: !19)
!34 = !DILocation(line: 10, column: 19, scope: !19)
!35 = !DILocalVariable(name: "array", scope: !19, file: !20, line: 11, type: !36)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!37 = !DILocation(line: 11, column: 10, scope: !19)
!38 = !DILocation(line: 11, column: 25, scope: !19)
!39 = !DILocation(line: 11, column: 30, scope: !19)
!40 = !DILocation(line: 11, column: 18, scope: !19)
!41 = !DILocalVariable(name: "array_2", scope: !19, file: !20, line: 12, type: !36)
!42 = !DILocation(line: 12, column: 10, scope: !19)
!43 = !DILocation(line: 12, column: 27, scope: !19)
!44 = !DILocation(line: 12, column: 32, scope: !19)
!45 = !DILocation(line: 12, column: 20, scope: !19)
!46 = !DILocation(line: 14, column: 5, scope: !19)
!47 = !DILocation(line: 15, column: 5, scope: !19)
!48 = !DILocation(line: 16, column: 5, scope: !19)
!49 = !DILocation(line: 17, column: 1, scope: !19)
