; ModuleID = '/home/ponce/git/Dat3M/output/46_monabsex2_vs.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/46_monabsex2_vs.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/46_monabsex2_vs.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@s = dso_local global i8 0, align 1, !dbg !0
@l = dso_local global i8 0, align 1, !dbg !5

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !17 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i64 0, i64 0), i32 noundef 3, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !21
  unreachable, !dbg !21
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thr1(i8* noundef %0) #0 !dbg !24 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !28, metadata !DIExpression()), !dbg !29
  call void @__VERIFIER_atomic_begin(), !dbg !30
  %2 = load i8, i8* @l, align 1, !dbg !31
  %3 = trunc i8 %2 to i1, !dbg !31
  br i1 %3, label %4, label %9, !dbg !31

4:                                                ; preds = %1
  %5 = load i8, i8* @s, align 1, !dbg !31
  %6 = trunc i8 %5 to i1, !dbg !31
  br i1 %6, label %9, label %7, !dbg !34

7:                                                ; preds = %4
  br label %8, !dbg !31

8:                                                ; preds = %7
  call void @llvm.dbg.label(metadata !35), !dbg !37
  call void @reach_error(), !dbg !38
  call void @abort() #7, !dbg !38
  unreachable, !dbg !38

9:                                                ; preds = %4, %1
  call void @__VERIFIER_atomic_end(), !dbg !40
  call void @__VERIFIER_atomic_begin(), !dbg !41
  %10 = load i8, i8* @s, align 1, !dbg !42
  %11 = trunc i8 %10 to i1, !dbg !42
  br i1 %11, label %13, label %12, !dbg !43

12:                                               ; preds = %9
  br label %13, !dbg !43

13:                                               ; preds = %12, %9
  %14 = phi i1 [ true, %9 ], [ true, %12 ]
  %15 = zext i1 %14 to i8, !dbg !44
  store i8 %15, i8* @s, align 1, !dbg !44
  call void @__VERIFIER_atomic_end(), !dbg !45
  call void @__VERIFIER_atomic_begin(), !dbg !46
  store i8 1, i8* @l, align 1, !dbg !47
  call void @__VERIFIER_atomic_end(), !dbg !48
  ret i8* null, !dbg !49
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

declare void @__VERIFIER_atomic_begin() #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: noreturn
declare void @abort() #4

declare void @__VERIFIER_atomic_end() #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !50 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !54, metadata !DIExpression()), !dbg !58
  call void @llvm.dbg.declare(metadata i64* %2, metadata !59, metadata !DIExpression()), !dbg !60
  call void @llvm.dbg.declare(metadata i64* %3, metadata !61, metadata !DIExpression()), !dbg !62
  %4 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thr1, i8* noundef null) #8, !dbg !63
  %5 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thr1, i8* noundef null) #8, !dbg !64
  %6 = call i32 @pthread_create(i64* noundef %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thr1, i8* noundef null) #8, !dbg !65
  ret i32 0, !dbg !66
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { noreturn nounwind }
attributes #7 = { noreturn }
attributes #8 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !7, line: 12, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/46_monabsex2_vs.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "687c7b80a2993fd812c3274fa0a05697")
!4 = !{!0, !5}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "l", scope: !2, file: !7, line: 13, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/pthread-ext/46_monabsex2_vs.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "687c7b80a2993fd812c3274fa0a05697")
!8 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 7, !"PIC Level", i32 2}
!13 = !{i32 7, !"PIE Level", i32 2}
!14 = !{i32 7, !"uwtable", i32 1}
!15 = !{i32 7, !"frame-pointer", i32 2}
!16 = !{!"Ubuntu clang version 14.0.6"}
!17 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 3, type: !18, scopeLine: 3, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!18 = !DISubroutineType(types: !19)
!19 = !{null}
!20 = !{}
!21 = !DILocation(line: 3, column: 22, scope: !22)
!22 = distinct !DILexicalBlock(scope: !23, file: !7, line: 3, column: 22)
!23 = distinct !DILexicalBlock(scope: !17, file: !7, line: 3, column: 22)
!24 = distinct !DISubprogram(name: "thr1", scope: !7, file: !7, line: 15, type: !25, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!25 = !DISubroutineType(types: !26)
!26 = !{!27, !27}
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = !DILocalVariable(name: "arg", arg: 1, scope: !24, file: !7, line: 15, type: !27)
!29 = !DILocation(line: 0, scope: !24)
!30 = !DILocation(line: 17, column: 5, scope: !24)
!31 = !DILocation(line: 18, column: 5, scope: !32)
!32 = distinct !DILexicalBlock(scope: !33, file: !7, line: 18, column: 5)
!33 = distinct !DILexicalBlock(scope: !24, file: !7, line: 18, column: 5)
!34 = !DILocation(line: 18, column: 5, scope: !33)
!35 = !DILabel(scope: !36, name: "ERROR", file: !7, line: 18)
!36 = distinct !DILexicalBlock(scope: !32, file: !7, line: 18, column: 5)
!37 = !DILocation(line: 18, column: 5, scope: !36)
!38 = !DILocation(line: 18, column: 5, scope: !39)
!39 = distinct !DILexicalBlock(scope: !36, file: !7, line: 18, column: 5)
!40 = !DILocation(line: 19, column: 5, scope: !24)
!41 = !DILocation(line: 20, column: 5, scope: !24)
!42 = !DILocation(line: 21, column: 9, scope: !24)
!43 = !DILocation(line: 21, column: 11, scope: !24)
!44 = !DILocation(line: 21, column: 7, scope: !24)
!45 = !DILocation(line: 22, column: 5, scope: !24)
!46 = !DILocation(line: 23, column: 5, scope: !24)
!47 = !DILocation(line: 24, column: 7, scope: !24)
!48 = !DILocation(line: 25, column: 5, scope: !24)
!49 = !DILocation(line: 27, column: 5, scope: !24)
!50 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 30, type: !51, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!51 = !DISubroutineType(types: !52)
!52 = !{!53}
!53 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!54 = !DILocalVariable(name: "t1", scope: !50, file: !7, line: 32, type: !55)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !56, line: 27, baseType: !57)
!56 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!57 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!58 = !DILocation(line: 32, column: 13, scope: !50)
!59 = !DILocalVariable(name: "t2", scope: !50, file: !7, line: 32, type: !55)
!60 = !DILocation(line: 32, column: 17, scope: !50)
!61 = !DILocalVariable(name: "t3", scope: !50, file: !7, line: 32, type: !55)
!62 = !DILocation(line: 32, column: 21, scope: !50)
!63 = !DILocation(line: 34, column: 3, scope: !50)
!64 = !DILocation(line: 35, column: 3, scope: !50)
!65 = !DILocation(line: 36, column: 3, scope: !50)
!66 = !DILocation(line: 37, column: 1, scope: !50)
