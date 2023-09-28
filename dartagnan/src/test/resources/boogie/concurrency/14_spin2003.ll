; ModuleID = '/home/ponce/git/Dat3M/output/14_spin2003.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/14_spin2003.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [67 x i8] c"/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/14_spin2003.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@x = dso_local global i32 1, align 4, !dbg !0
@m = dso_local global i32 0, align 4, !dbg !5

; Function Attrs: noinline nounwind uwtable
define dso_local void @assume_abort_if_not(i32 noundef %0) #0 !dbg !17 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !21, metadata !DIExpression()), !dbg !22
  %2 = icmp ne i32 %0, 0, !dbg !23
  br i1 %2, label %4, label %3, !dbg !25

3:                                                ; preds = %1
  call void @abort() #5, !dbg !26
  unreachable, !dbg !26

4:                                                ; preds = %1
  ret void, !dbg !28
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn
declare void @abort() #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !29 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([67 x i8], [67 x i8]* @.str.1, i64 0, i64 0), i32 noundef 7, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !32
  unreachable, !dbg !32
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_acquire() #0 !dbg !35 {
  %1 = load i32, i32* @m, align 4, !dbg !36
  %2 = icmp eq i32 %1, 0, !dbg !36
  %3 = zext i1 %2 to i32, !dbg !36
  call void @assume_abort_if_not(i32 noundef %3), !dbg !36
  store i32 1, i32* @m, align 4, !dbg !37
  ret void, !dbg !38
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_release() #0 !dbg !39 {
  %1 = load i32, i32* @m, align 4, !dbg !40
  %2 = icmp eq i32 %1, 1, !dbg !40
  %3 = zext i1 %2 to i32, !dbg !40
  call void @assume_abort_if_not(i32 noundef %3), !dbg !40
  store i32 0, i32* @m, align 4, !dbg !41
  ret void, !dbg !42
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thr1(i8* noundef %0) #0 !dbg !43 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !47, metadata !DIExpression()), !dbg !48
  call void @__VERIFIER_atomic_acquire(), !dbg !49
  store i32 0, i32* @x, align 4, !dbg !50
  store i32 1, i32* @x, align 4, !dbg !51
  %2 = load i32, i32* @x, align 4, !dbg !52
  %3 = icmp sge i32 %2, 1, !dbg !52
  br i1 %3, label %6, label %4, !dbg !55

4:                                                ; preds = %1
  br label %5, !dbg !52

5:                                                ; preds = %4
  call void @llvm.dbg.label(metadata !56), !dbg !58
  call void @reach_error(), !dbg !59
  call void @abort() #5, !dbg !59
  unreachable, !dbg !59

6:                                                ; preds = %1
  call void @__VERIFIER_atomic_release(), !dbg !61
  ret i8* null, !dbg !62
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !63 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !66, metadata !DIExpression()), !dbg !70
  call void @llvm.dbg.declare(metadata i64* %2, metadata !71, metadata !DIExpression()), !dbg !72
  call void @llvm.dbg.declare(metadata i64* %3, metadata !73, metadata !DIExpression()), !dbg !74
  %4 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thr1, i8* noundef null) #7, !dbg !75
  %5 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thr1, i8* noundef null) #7, !dbg !76
  %6 = call i32 @pthread_create(i64* noundef %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thr1, i8* noundef null) #7, !dbg !77
  ret i32 0, !dbg !78
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn }
attributes #6 = { noreturn nounwind }
attributes #7 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !7, line: 15, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/14_spin2003.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "716dd3845d1694da1f6dcf5656d21180")
!4 = !{!0, !5}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "m", scope: !2, file: !7, line: 15, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/pthread-ext/14_spin2003.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "716dd3845d1694da1f6dcf5656d21180")
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 7, !"PIC Level", i32 2}
!13 = !{i32 7, !"PIE Level", i32 2}
!14 = !{i32 7, !"uwtable", i32 1}
!15 = !{i32 7, !"frame-pointer", i32 2}
!16 = !{!"Ubuntu clang version 14.0.6"}
!17 = distinct !DISubprogram(name: "assume_abort_if_not", scope: !7, file: !7, line: 2, type: !18, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!18 = !DISubroutineType(types: !19)
!19 = !{null, !8}
!20 = !{}
!21 = !DILocalVariable(name: "cond", arg: 1, scope: !17, file: !7, line: 2, type: !8)
!22 = !DILocation(line: 0, scope: !17)
!23 = !DILocation(line: 3, column: 7, scope: !24)
!24 = distinct !DILexicalBlock(scope: !17, file: !7, line: 3, column: 6)
!25 = !DILocation(line: 3, column: 6, scope: !17)
!26 = !DILocation(line: 3, column: 14, scope: !27)
!27 = distinct !DILexicalBlock(scope: !24, file: !7, line: 3, column: 13)
!28 = !DILocation(line: 4, column: 1, scope: !17)
!29 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 7, type: !30, scopeLine: 7, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!30 = !DISubroutineType(types: !31)
!31 = !{null}
!32 = !DILocation(line: 7, column: 22, scope: !33)
!33 = distinct !DILexicalBlock(scope: !34, file: !7, line: 7, column: 22)
!34 = distinct !DILexicalBlock(scope: !29, file: !7, line: 7, column: 22)
!35 = distinct !DISubprogram(name: "__VERIFIER_atomic_acquire", scope: !7, file: !7, line: 17, type: !30, scopeLine: 18, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!36 = !DILocation(line: 19, column: 2, scope: !35)
!37 = !DILocation(line: 20, column: 4, scope: !35)
!38 = !DILocation(line: 21, column: 1, scope: !35)
!39 = distinct !DISubprogram(name: "__VERIFIER_atomic_release", scope: !7, file: !7, line: 23, type: !30, scopeLine: 24, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!40 = !DILocation(line: 25, column: 2, scope: !39)
!41 = !DILocation(line: 26, column: 4, scope: !39)
!42 = !DILocation(line: 27, column: 1, scope: !39)
!43 = distinct !DISubprogram(name: "thr1", scope: !7, file: !7, line: 29, type: !44, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!44 = !DISubroutineType(types: !45)
!45 = !{!46, !46}
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!47 = !DILocalVariable(name: "arg", arg: 1, scope: !43, file: !7, line: 29, type: !46)
!48 = !DILocation(line: 0, scope: !43)
!49 = !DILocation(line: 30, column: 3, scope: !43)
!50 = !DILocation(line: 31, column: 5, scope: !43)
!51 = !DILocation(line: 32, column: 5, scope: !43)
!52 = !DILocation(line: 33, column: 3, scope: !53)
!53 = distinct !DILexicalBlock(scope: !54, file: !7, line: 33, column: 3)
!54 = distinct !DILexicalBlock(scope: !43, file: !7, line: 33, column: 3)
!55 = !DILocation(line: 33, column: 3, scope: !54)
!56 = !DILabel(scope: !57, name: "ERROR", file: !7, line: 33)
!57 = distinct !DILexicalBlock(scope: !53, file: !7, line: 33, column: 3)
!58 = !DILocation(line: 33, column: 3, scope: !57)
!59 = !DILocation(line: 33, column: 3, scope: !60)
!60 = distinct !DILexicalBlock(scope: !57, file: !7, line: 33, column: 3)
!61 = !DILocation(line: 34, column: 3, scope: !43)
!62 = !DILocation(line: 36, column: 3, scope: !43)
!63 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 39, type: !64, scopeLine: 40, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!64 = !DISubroutineType(types: !65)
!65 = !{!8}
!66 = !DILocalVariable(name: "t1", scope: !63, file: !7, line: 41, type: !67)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !68, line: 27, baseType: !69)
!68 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!69 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!70 = !DILocation(line: 41, column: 13, scope: !63)
!71 = !DILocalVariable(name: "t2", scope: !63, file: !7, line: 41, type: !67)
!72 = !DILocation(line: 41, column: 17, scope: !63)
!73 = !DILocalVariable(name: "t3", scope: !63, file: !7, line: 41, type: !67)
!74 = !DILocation(line: 41, column: 21, scope: !63)
!75 = !DILocation(line: 43, column: 3, scope: !63)
!76 = !DILocation(line: 44, column: 3, scope: !63)
!77 = !DILocation(line: 45, column: 3, scope: !63)
!78 = !DILocation(line: 46, column: 1, scope: !63)
