; ModuleID = '/home/ponce/git/Dat3M/output/14_spin2003.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/14_spin2003.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [14 x i8] c"14_spin2003.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@x = dso_local global i32 1, align 4, !dbg !0
@m = dso_local global i32 0, align 4, !dbg !5

; Function Attrs: noinline nounwind uwtable
define dso_local void @assume_abort_if_not(i32 noundef %0) #0 !dbg !17 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !21, metadata !DIExpression()), !dbg !22
  %.not = icmp eq i32 %0, 0, !dbg !23
  br i1 %.not, label %2, label %3, !dbg !25

2:                                                ; preds = %1
  call void @abort() #5, !dbg !26
  unreachable, !dbg !26

3:                                                ; preds = %1
  ret void, !dbg !28
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn
declare void @abort() #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !29 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str.1, i64 0, i64 0), i32 noundef 7, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !32
  unreachable, !dbg !32
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_acquire() #0 !dbg !35 {
  %1 = load i32, i32* @m, align 4, !dbg !36
  %2 = icmp eq i32 %1, 0, !dbg !37
  %3 = zext i1 %2 to i32, !dbg !37
  call void @assume_abort_if_not(i32 noundef %3), !dbg !38
  store i32 1, i32* @m, align 4, !dbg !39
  ret void, !dbg !40
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_release() #0 !dbg !41 {
  %1 = load i32, i32* @m, align 4, !dbg !42
  %2 = icmp eq i32 %1, 1, !dbg !43
  %3 = zext i1 %2 to i32, !dbg !43
  call void @assume_abort_if_not(i32 noundef %3), !dbg !44
  store i32 0, i32* @m, align 4, !dbg !45
  ret void, !dbg !46
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thr1(i8* noundef %0) #0 !dbg !47 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !51, metadata !DIExpression()), !dbg !52
  call void @__VERIFIER_atomic_acquire(), !dbg !53
  store i32 1, i32* @x, align 4, !dbg !54
  call void @__VERIFIER_atomic_release(), !dbg !55
  ret i8* null, !dbg !56
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !57 {
  %1 = alloca i64, align 8
  br label %2, !dbg !60

2:                                                ; preds = %2, %0
  call void @llvm.dbg.value(metadata i64* %1, metadata !61, metadata !DIExpression(DW_OP_deref)), !dbg !64
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thr1, i8* noundef null) #7, !dbg !65
  br label %2, !dbg !60, !llvm.loop !66
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nocallback noreturn nounwind }
attributes #7 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !7, line: 688, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/14_spin2003.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "719ab447206421a7530e99cfaa87fa7f")
!4 = !{!0, !5}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "m", scope: !2, file: !7, line: 688, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/pthread-ext/14_spin2003.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "719ab447206421a7530e99cfaa87fa7f")
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
!29 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 16, type: !30, scopeLine: 16, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!30 = !DISubroutineType(types: !31)
!31 = !{null}
!32 = !DILocation(line: 16, column: 83, scope: !33)
!33 = distinct !DILexicalBlock(scope: !34, file: !7, line: 16, column: 73)
!34 = distinct !DILexicalBlock(scope: !29, file: !7, line: 16, column: 67)
!35 = distinct !DISubprogram(name: "__VERIFIER_atomic_acquire", scope: !7, file: !7, line: 689, type: !30, scopeLine: 690, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!36 = !DILocation(line: 691, column: 22, scope: !35)
!37 = !DILocation(line: 691, column: 23, scope: !35)
!38 = !DILocation(line: 691, column: 2, scope: !35)
!39 = !DILocation(line: 692, column: 4, scope: !35)
!40 = !DILocation(line: 693, column: 1, scope: !35)
!41 = distinct !DISubprogram(name: "__VERIFIER_atomic_release", scope: !7, file: !7, line: 694, type: !30, scopeLine: 695, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!42 = !DILocation(line: 696, column: 22, scope: !41)
!43 = !DILocation(line: 696, column: 23, scope: !41)
!44 = !DILocation(line: 696, column: 2, scope: !41)
!45 = !DILocation(line: 697, column: 4, scope: !41)
!46 = !DILocation(line: 698, column: 1, scope: !41)
!47 = distinct !DISubprogram(name: "thr1", scope: !7, file: !7, line: 699, type: !48, scopeLine: 699, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!48 = !DISubroutineType(types: !49)
!49 = !{!50, !50}
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!51 = !DILocalVariable(name: "arg", arg: 1, scope: !47, file: !7, line: 699, type: !50)
!52 = !DILocation(line: 0, scope: !47)
!53 = !DILocation(line: 700, column: 3, scope: !47)
!54 = !DILocation(line: 702, column: 5, scope: !47)
!55 = !DILocation(line: 704, column: 3, scope: !47)
!56 = !DILocation(line: 705, column: 3, scope: !47)
!57 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 707, type: !58, scopeLine: 708, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!58 = !DISubroutineType(types: !59)
!59 = !{!8}
!60 = !DILocation(line: 710, column: 3, scope: !57)
!61 = !DILocalVariable(name: "t", scope: !57, file: !7, line: 709, type: !62)
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 284, baseType: !63)
!63 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!64 = !DILocation(line: 0, scope: !57)
!65 = !DILocation(line: 710, column: 12, scope: !57)
!66 = distinct !{!66, !60, !67}
!67 = !DILocation(line: 710, column: 41, scope: !57)
