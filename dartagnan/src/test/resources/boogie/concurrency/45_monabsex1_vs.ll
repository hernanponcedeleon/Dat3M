; ModuleID = '/home/ponce/git/Dat3M/output/45_monabsex1_vs.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/45_monabsex1_vs.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/45_monabsex1_vs.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@s = dso_local global i32 0, align 4, !dbg !0

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !15 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i64 0, i64 0), i32 noundef 6, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !19
  unreachable, !dbg !19
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thr1(i8* noundef %0) #0 !dbg !22 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !26, metadata !DIExpression()), !dbg !27
  %2 = call i32 @__VERIFIER_nondet_int(), !dbg !28
  call void @llvm.dbg.value(metadata i32 %2, metadata !29, metadata !DIExpression()), !dbg !27
  call void @llvm.dbg.value(metadata i32 4, metadata !29, metadata !DIExpression()), !dbg !27
  call void @__VERIFIER_atomic_begin(), !dbg !30
  store i32 4, i32* @s, align 4, !dbg !31
  call void @__VERIFIER_atomic_end(), !dbg !32
  call void @__VERIFIER_atomic_begin(), !dbg !33
  %3 = load i32, i32* @s, align 4, !dbg !34
  %4 = icmp eq i32 %3, 4, !dbg !34
  br i1 %4, label %7, label %5, !dbg !37

5:                                                ; preds = %1
  br label %6, !dbg !34

6:                                                ; preds = %5
  call void @llvm.dbg.label(metadata !38), !dbg !40
  call void @reach_error(), !dbg !41
  call void @abort() #7, !dbg !41
  unreachable, !dbg !41

7:                                                ; preds = %1
  call void @__VERIFIER_atomic_end(), !dbg !43
  ret i8* null, !dbg !44
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

declare i32 @__VERIFIER_nondet_int() #3

declare void @__VERIFIER_atomic_begin() #3

declare void @__VERIFIER_atomic_end() #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: noreturn
declare void @abort() #4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !45 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = call i32 @__VERIFIER_nondet_int(), !dbg !48
  store i32 %4, i32* @s, align 4, !dbg !49
  call void @llvm.dbg.declare(metadata i64* %1, metadata !50, metadata !DIExpression()), !dbg !54
  call void @llvm.dbg.declare(metadata i64* %2, metadata !55, metadata !DIExpression()), !dbg !56
  call void @llvm.dbg.declare(metadata i64* %3, metadata !57, metadata !DIExpression()), !dbg !58
  %5 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thr1, i8* noundef null) #8, !dbg !59
  %6 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thr1, i8* noundef null) #8, !dbg !60
  %7 = call i32 @pthread_create(i64* noundef %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thr1, i8* noundef null) #8, !dbg !61
  ret i32 0, !dbg !62
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
!llvm.module.flags = !{!7, !8, !9, !10, !11, !12, !13}
!llvm.ident = !{!14}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !5, line: 13, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/45_monabsex1_vs.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "c69a7082766191deaffc5b8c78f945e6")
!4 = !{!0}
!5 = !DIFile(filename: "../sv-benchmarks/c/pthread-ext/45_monabsex1_vs.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "c69a7082766191deaffc5b8c78f945e6")
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !{i32 7, !"Dwarf Version", i32 5}
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = !{i32 1, !"wchar_size", i32 4}
!10 = !{i32 7, !"PIC Level", i32 2}
!11 = !{i32 7, !"PIE Level", i32 2}
!12 = !{i32 7, !"uwtable", i32 1}
!13 = !{i32 7, !"frame-pointer", i32 2}
!14 = !{!"Ubuntu clang version 14.0.6"}
!15 = distinct !DISubprogram(name: "reach_error", scope: !5, file: !5, line: 6, type: !16, scopeLine: 6, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !18)
!16 = !DISubroutineType(types: !17)
!17 = !{null}
!18 = !{}
!19 = !DILocation(line: 6, column: 22, scope: !20)
!20 = distinct !DILexicalBlock(scope: !21, file: !5, line: 6, column: 22)
!21 = distinct !DILexicalBlock(scope: !15, file: !5, line: 6, column: 22)
!22 = distinct !DISubprogram(name: "thr1", scope: !5, file: !5, line: 15, type: !23, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !18)
!23 = !DISubroutineType(types: !24)
!24 = !{!25, !25}
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!26 = !DILocalVariable(name: "arg", arg: 1, scope: !22, file: !5, line: 15, type: !25)
!27 = !DILocation(line: 0, scope: !22)
!28 = !DILocation(line: 17, column: 13, scope: !22)
!29 = !DILocalVariable(name: "l", scope: !22, file: !5, line: 17, type: !6)
!30 = !DILocation(line: 19, column: 5, scope: !22)
!31 = !DILocation(line: 20, column: 7, scope: !22)
!32 = !DILocation(line: 21, column: 5, scope: !22)
!33 = !DILocation(line: 22, column: 5, scope: !22)
!34 = !DILocation(line: 23, column: 5, scope: !35)
!35 = distinct !DILexicalBlock(scope: !36, file: !5, line: 23, column: 5)
!36 = distinct !DILexicalBlock(scope: !22, file: !5, line: 23, column: 5)
!37 = !DILocation(line: 23, column: 5, scope: !36)
!38 = !DILabel(scope: !39, name: "ERROR", file: !5, line: 23)
!39 = distinct !DILexicalBlock(scope: !35, file: !5, line: 23, column: 5)
!40 = !DILocation(line: 23, column: 5, scope: !39)
!41 = !DILocation(line: 23, column: 5, scope: !42)
!42 = distinct !DILexicalBlock(scope: !39, file: !5, line: 23, column: 5)
!43 = !DILocation(line: 24, column: 5, scope: !22)
!44 = !DILocation(line: 26, column: 5, scope: !22)
!45 = distinct !DISubprogram(name: "main", scope: !5, file: !5, line: 29, type: !46, scopeLine: 30, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !18)
!46 = !DISubroutineType(types: !47)
!47 = !{!6}
!48 = !DILocation(line: 31, column: 7, scope: !45)
!49 = !DILocation(line: 31, column: 5, scope: !45)
!50 = !DILocalVariable(name: "t1", scope: !45, file: !5, line: 33, type: !51)
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !52, line: 27, baseType: !53)
!52 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!53 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!54 = !DILocation(line: 33, column: 13, scope: !45)
!55 = !DILocalVariable(name: "t2", scope: !45, file: !5, line: 33, type: !51)
!56 = !DILocation(line: 33, column: 17, scope: !45)
!57 = !DILocalVariable(name: "t3", scope: !45, file: !5, line: 33, type: !51)
!58 = !DILocation(line: 33, column: 21, scope: !45)
!59 = !DILocation(line: 35, column: 3, scope: !45)
!60 = !DILocation(line: 36, column: 3, scope: !45)
!61 = !DILocation(line: 37, column: 3, scope: !45)
!62 = !DILocation(line: 38, column: 1, scope: !45)
