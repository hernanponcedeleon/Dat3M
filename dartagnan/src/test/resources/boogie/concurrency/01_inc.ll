; ModuleID = '/home/ponce/git/Dat3M/output/01_inc.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/01_inc.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [62 x i8] c"/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/01_inc.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@m = dso_local global i32 0, align 4, !dbg !0
@value = dso_local global i32 0, align 4, !dbg !5

; Function Attrs: noinline nounwind uwtable
define dso_local void @assume_abort_if_not(i32 noundef %0) #0 !dbg !18 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !23, metadata !DIExpression()), !dbg !24
  %2 = icmp ne i32 %0, 0, !dbg !25
  br i1 %2, label %4, label %3, !dbg !27

3:                                                ; preds = %1
  call void @abort() #6, !dbg !28
  unreachable, !dbg !28

4:                                                ; preds = %1
  ret void, !dbg !30
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn
declare void @abort() #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !31 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([62 x i8], [62 x i8]* @.str.1, i64 0, i64 0), i32 noundef 7, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #7, !dbg !34
  unreachable, !dbg !34
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_acquire() #0 !dbg !37 {
  %1 = load volatile i32, i32* @m, align 4, !dbg !38
  %2 = icmp eq i32 %1, 0, !dbg !38
  %3 = zext i1 %2 to i32, !dbg !38
  call void @assume_abort_if_not(i32 noundef %3), !dbg !38
  store volatile i32 1, i32* @m, align 4, !dbg !39
  ret void, !dbg !40
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_release() #0 !dbg !41 {
  %1 = load volatile i32, i32* @m, align 4, !dbg !42
  %2 = icmp eq i32 %1, 1, !dbg !42
  %3 = zext i1 %2 to i32, !dbg !42
  call void @assume_abort_if_not(i32 noundef %3), !dbg !42
  store volatile i32 0, i32* @m, align 4, !dbg !43
  ret void, !dbg !44
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thr1(i8* noundef %0) #0 !dbg !45 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !49, metadata !DIExpression()), !dbg !50
  call void @llvm.dbg.value(metadata i32 0, metadata !51, metadata !DIExpression()), !dbg !50
  call void @__VERIFIER_atomic_acquire(), !dbg !52
  %2 = load volatile i32, i32* @value, align 4, !dbg !53
  %3 = icmp eq i32 %2, -1, !dbg !55
  br i1 %3, label %4, label %5, !dbg !56

4:                                                ; preds = %1
  call void @__VERIFIER_atomic_release(), !dbg !57
  br label %13, !dbg !59

5:                                                ; preds = %1
  %6 = load volatile i32, i32* @value, align 4, !dbg !60
  call void @llvm.dbg.value(metadata i32 %6, metadata !51, metadata !DIExpression()), !dbg !50
  %7 = add i32 %6, 1, !dbg !62
  store volatile i32 %7, i32* @value, align 4, !dbg !63
  call void @__VERIFIER_atomic_release(), !dbg !64
  call void @__VERIFIER_atomic_begin(), !dbg !65
  %8 = load volatile i32, i32* @value, align 4, !dbg !66
  %9 = icmp ugt i32 %8, %6, !dbg !66
  br i1 %9, label %12, label %10, !dbg !69

10:                                               ; preds = %5
  br label %11, !dbg !66

11:                                               ; preds = %10
  call void @llvm.dbg.label(metadata !70), !dbg !72
  call void @reach_error(), !dbg !73
  call void @abort() #6, !dbg !73
  unreachable, !dbg !73

12:                                               ; preds = %5
  call void @__VERIFIER_atomic_end(), !dbg !75
  br label %13, !dbg !76

13:                                               ; preds = %12, %4
  ret i8* null, !dbg !77
}

declare void @__VERIFIER_atomic_begin() #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

declare void @__VERIFIER_atomic_end() #4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !78 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !81, metadata !DIExpression()), !dbg !85
  call void @llvm.dbg.declare(metadata i64* %2, metadata !86, metadata !DIExpression()), !dbg !87
  call void @llvm.dbg.declare(metadata i64* %3, metadata !88, metadata !DIExpression()), !dbg !89
  %4 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thr1, i8* noundef null) #8, !dbg !90
  %5 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thr1, i8* noundef null) #8, !dbg !91
  %6 = call i32 @pthread_create(i64* noundef %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thr1, i8* noundef null) #8, !dbg !92
  ret i32 0, !dbg !93
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { noreturn }
attributes #7 = { noreturn nounwind }
attributes #8 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!10, !11, !12, !13, !14, !15, !16}
!llvm.ident = !{!17}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "m", scope: !2, file: !7, line: 20, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/01_inc.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "7872ce806de1abc71f47425bd08cf15c")
!4 = !{!0, !5}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "value", scope: !2, file: !7, line: 20, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/pthread-ext/01_inc.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "7872ce806de1abc71f47425bd08cf15c")
!8 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !9)
!9 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!10 = !{i32 7, !"Dwarf Version", i32 5}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = !{i32 7, !"PIC Level", i32 2}
!14 = !{i32 7, !"PIE Level", i32 2}
!15 = !{i32 7, !"uwtable", i32 1}
!16 = !{i32 7, !"frame-pointer", i32 2}
!17 = !{!"Ubuntu clang version 14.0.6"}
!18 = distinct !DISubprogram(name: "assume_abort_if_not", scope: !7, file: !7, line: 2, type: !19, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!19 = !DISubroutineType(types: !20)
!20 = !{null, !21}
!21 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!22 = !{}
!23 = !DILocalVariable(name: "cond", arg: 1, scope: !18, file: !7, line: 2, type: !21)
!24 = !DILocation(line: 0, scope: !18)
!25 = !DILocation(line: 3, column: 7, scope: !26)
!26 = distinct !DILexicalBlock(scope: !18, file: !7, line: 3, column: 6)
!27 = !DILocation(line: 3, column: 6, scope: !18)
!28 = !DILocation(line: 3, column: 14, scope: !29)
!29 = distinct !DILexicalBlock(scope: !26, file: !7, line: 3, column: 13)
!30 = !DILocation(line: 4, column: 1, scope: !18)
!31 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 7, type: !32, scopeLine: 7, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!32 = !DISubroutineType(types: !33)
!33 = !{null}
!34 = !DILocation(line: 7, column: 22, scope: !35)
!35 = distinct !DILexicalBlock(scope: !36, file: !7, line: 7, column: 22)
!36 = distinct !DILexicalBlock(scope: !31, file: !7, line: 7, column: 22)
!37 = distinct !DISubprogram(name: "__VERIFIER_atomic_acquire", scope: !7, file: !7, line: 22, type: !32, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!38 = !DILocation(line: 24, column: 2, scope: !37)
!39 = !DILocation(line: 25, column: 4, scope: !37)
!40 = !DILocation(line: 26, column: 1, scope: !37)
!41 = distinct !DISubprogram(name: "__VERIFIER_atomic_release", scope: !7, file: !7, line: 28, type: !32, scopeLine: 29, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!42 = !DILocation(line: 30, column: 2, scope: !41)
!43 = !DILocation(line: 31, column: 4, scope: !41)
!44 = !DILocation(line: 32, column: 1, scope: !41)
!45 = distinct !DISubprogram(name: "thr1", scope: !7, file: !7, line: 34, type: !46, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!46 = !DISubroutineType(types: !47)
!47 = !{!48, !48}
!48 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!49 = !DILocalVariable(name: "arg", arg: 1, scope: !45, file: !7, line: 34, type: !48)
!50 = !DILocation(line: 0, scope: !45)
!51 = !DILocalVariable(name: "v", scope: !45, file: !7, line: 35, type: !9)
!52 = !DILocation(line: 37, column: 2, scope: !45)
!53 = !DILocation(line: 38, column: 5, scope: !54)
!54 = distinct !DILexicalBlock(scope: !45, file: !7, line: 38, column: 5)
!55 = !DILocation(line: 38, column: 11, scope: !54)
!56 = !DILocation(line: 38, column: 5, scope: !45)
!57 = !DILocation(line: 39, column: 3, scope: !58)
!58 = distinct !DILexicalBlock(scope: !54, file: !7, line: 38, column: 20)
!59 = !DILocation(line: 41, column: 3, scope: !58)
!60 = !DILocation(line: 44, column: 7, scope: !61)
!61 = distinct !DILexicalBlock(scope: !54, file: !7, line: 42, column: 7)
!62 = !DILocation(line: 45, column: 13, scope: !61)
!63 = !DILocation(line: 45, column: 9, scope: !61)
!64 = !DILocation(line: 46, column: 3, scope: !61)
!65 = !DILocation(line: 48, column: 9, scope: !61)
!66 = !DILocation(line: 49, column: 9, scope: !67)
!67 = distinct !DILexicalBlock(scope: !68, file: !7, line: 49, column: 9)
!68 = distinct !DILexicalBlock(scope: !61, file: !7, line: 49, column: 9)
!69 = !DILocation(line: 49, column: 9, scope: !68)
!70 = !DILabel(scope: !71, name: "ERROR", file: !7, line: 49)
!71 = distinct !DILexicalBlock(scope: !67, file: !7, line: 49, column: 9)
!72 = !DILocation(line: 49, column: 9, scope: !71)
!73 = !DILocation(line: 49, column: 9, scope: !74)
!74 = distinct !DILexicalBlock(scope: !71, file: !7, line: 49, column: 9)
!75 = !DILocation(line: 50, column: 9, scope: !61)
!76 = !DILocation(line: 52, column: 3, scope: !61)
!77 = !DILocation(line: 54, column: 1, scope: !45)
!78 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 56, type: !79, scopeLine: 56, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!79 = !DISubroutineType(types: !80)
!80 = !{!21}
!81 = !DILocalVariable(name: "t1", scope: !78, file: !7, line: 57, type: !82)
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !83, line: 27, baseType: !84)
!83 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!84 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!85 = !DILocation(line: 57, column: 13, scope: !78)
!86 = !DILocalVariable(name: "t2", scope: !78, file: !7, line: 57, type: !82)
!87 = !DILocation(line: 57, column: 17, scope: !78)
!88 = !DILocalVariable(name: "t3", scope: !78, file: !7, line: 57, type: !82)
!89 = !DILocation(line: 57, column: 21, scope: !78)
!90 = !DILocation(line: 59, column: 3, scope: !78)
!91 = !DILocation(line: 60, column: 3, scope: !78)
!92 = !DILocation(line: 61, column: 3, scope: !78)
!93 = !DILocation(line: 62, column: 1, scope: !78)
