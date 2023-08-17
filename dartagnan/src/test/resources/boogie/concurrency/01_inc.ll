; ModuleID = '/home/ponce/git/Dat3M/output/01_inc.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/01_inc.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"01_inc.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@m = dso_local global i32 0, align 4, !dbg !0
@value = dso_local global i32 0, align 4, !dbg !5

; Function Attrs: noinline nounwind uwtable
define dso_local void @assume_abort_if_not(i32 noundef %0) #0 !dbg !18 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !23, metadata !DIExpression()), !dbg !24
  %.not = icmp eq i32 %0, 0, !dbg !25
  br i1 %.not, label %2, label %3, !dbg !27

2:                                                ; preds = %1
  call void @abort() #6, !dbg !28
  unreachable, !dbg !28

3:                                                ; preds = %1
  ret void, !dbg !30
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn
declare void @abort() #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !31 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0), i32 noundef 7, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #7, !dbg !34
  unreachable, !dbg !34
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_acquire() #0 !dbg !37 {
  %1 = load volatile i32, i32* @m, align 4, !dbg !38
  %2 = icmp eq i32 %1, 0, !dbg !39
  %3 = zext i1 %2 to i32, !dbg !39
  call void @assume_abort_if_not(i32 noundef %3), !dbg !40
  store volatile i32 1, i32* @m, align 4, !dbg !41
  ret void, !dbg !42
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_release() #0 !dbg !43 {
  %1 = load volatile i32, i32* @m, align 4, !dbg !44
  %2 = icmp eq i32 %1, 1, !dbg !45
  %3 = zext i1 %2 to i32, !dbg !45
  call void @assume_abort_if_not(i32 noundef %3), !dbg !46
  store volatile i32 0, i32* @m, align 4, !dbg !47
  ret void, !dbg !48
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thr1(i8* noundef %0) #0 !dbg !49 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !53, metadata !DIExpression()), !dbg !54
  call void @llvm.dbg.value(metadata i32 0, metadata !55, metadata !DIExpression()), !dbg !54
  call void @__VERIFIER_atomic_acquire(), !dbg !56
  %2 = load volatile i32, i32* @value, align 4, !dbg !57
  %3 = icmp eq i32 %2, -1, !dbg !59
  br i1 %3, label %4, label %5, !dbg !60

4:                                                ; preds = %1
  call void @__VERIFIER_atomic_release(), !dbg !61
  br label %12, !dbg !63

5:                                                ; preds = %1
  %6 = load volatile i32, i32* @value, align 4, !dbg !64
  call void @llvm.dbg.value(metadata i32 %6, metadata !55, metadata !DIExpression()), !dbg !54
  %7 = add i32 %6, 1, !dbg !66
  store volatile i32 %7, i32* @value, align 4, !dbg !67
  call void @__VERIFIER_atomic_release(), !dbg !68
  call void @__VERIFIER_atomic_begin() #8, !dbg !69
  %8 = load volatile i32, i32* @value, align 4, !dbg !70
  %9 = icmp ugt i32 %8, %6, !dbg !73
  br i1 %9, label %11, label %10, !dbg !74

10:                                               ; preds = %5
  call void @llvm.dbg.label(metadata !75), !dbg !77
  call void @reach_error(), !dbg !78
  call void @abort() #6, !dbg !80
  unreachable, !dbg !80

11:                                               ; preds = %5
  call void @__VERIFIER_atomic_end() #8, !dbg !81
  br label %12, !dbg !82

12:                                               ; preds = %11, %4
  ret i8* null, !dbg !83
}

declare void @__VERIFIER_atomic_begin() #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

declare void @__VERIFIER_atomic_end() #4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !84 {
  %1 = alloca i64, align 8
  br label %2, !dbg !87

2:                                                ; preds = %2, %0
  call void @llvm.dbg.value(metadata i64* %1, metadata !88, metadata !DIExpression(DW_OP_deref)), !dbg !91
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thr1, i8* noundef null) #8, !dbg !92
  br label %2, !dbg !87, !llvm.loop !94
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { noreturn nounwind }
attributes #7 = { nocallback noreturn nounwind }
attributes #8 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!10, !11, !12, !13, !14, !15, !16}
!llvm.ident = !{!17}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "m", scope: !2, file: !7, line: 704, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/01_inc.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "6e0d0d8fba8cebc94d2bf53c4b834780")
!4 = !{!0, !5}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "value", scope: !2, file: !7, line: 704, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/pthread-ext/01_inc.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "6e0d0d8fba8cebc94d2bf53c4b834780")
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
!31 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 16, type: !32, scopeLine: 16, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!32 = !DISubroutineType(types: !33)
!33 = !{null}
!34 = !DILocation(line: 16, column: 83, scope: !35)
!35 = distinct !DILexicalBlock(scope: !36, file: !7, line: 16, column: 73)
!36 = distinct !DILexicalBlock(scope: !31, file: !7, line: 16, column: 67)
!37 = distinct !DISubprogram(name: "__VERIFIER_atomic_acquire", scope: !7, file: !7, line: 705, type: !32, scopeLine: 706, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!38 = !DILocation(line: 707, column: 22, scope: !37)
!39 = !DILocation(line: 707, column: 23, scope: !37)
!40 = !DILocation(line: 707, column: 2, scope: !37)
!41 = !DILocation(line: 708, column: 4, scope: !37)
!42 = !DILocation(line: 709, column: 1, scope: !37)
!43 = distinct !DISubprogram(name: "__VERIFIER_atomic_release", scope: !7, file: !7, line: 710, type: !32, scopeLine: 711, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!44 = !DILocation(line: 712, column: 22, scope: !43)
!45 = !DILocation(line: 712, column: 23, scope: !43)
!46 = !DILocation(line: 712, column: 2, scope: !43)
!47 = !DILocation(line: 713, column: 4, scope: !43)
!48 = !DILocation(line: 714, column: 1, scope: !43)
!49 = distinct !DISubprogram(name: "thr1", scope: !7, file: !7, line: 715, type: !50, scopeLine: 715, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!50 = !DISubroutineType(types: !51)
!51 = !{!52, !52}
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!53 = !DILocalVariable(name: "arg", arg: 1, scope: !49, file: !7, line: 715, type: !52)
!54 = !DILocation(line: 0, scope: !49)
!55 = !DILocalVariable(name: "v", scope: !49, file: !7, line: 716, type: !9)
!56 = !DILocation(line: 717, column: 2, scope: !49)
!57 = !DILocation(line: 718, column: 5, scope: !58)
!58 = distinct !DILexicalBlock(scope: !49, file: !7, line: 718, column: 5)
!59 = !DILocation(line: 718, column: 11, scope: !58)
!60 = !DILocation(line: 718, column: 5, scope: !49)
!61 = !DILocation(line: 719, column: 3, scope: !62)
!62 = distinct !DILexicalBlock(scope: !58, file: !7, line: 718, column: 20)
!63 = !DILocation(line: 720, column: 3, scope: !62)
!64 = !DILocation(line: 722, column: 7, scope: !65)
!65 = distinct !DILexicalBlock(scope: !58, file: !7, line: 721, column: 7)
!66 = !DILocation(line: 723, column: 13, scope: !65)
!67 = !DILocation(line: 723, column: 9, scope: !65)
!68 = !DILocation(line: 724, column: 3, scope: !65)
!69 = !DILocation(line: 725, column: 9, scope: !65)
!70 = !DILocation(line: 726, column: 16, scope: !71)
!71 = distinct !DILexicalBlock(scope: !72, file: !7, line: 726, column: 14)
!72 = distinct !DILexicalBlock(scope: !65, file: !7, line: 726, column: 9)
!73 = !DILocation(line: 726, column: 22, scope: !71)
!74 = !DILocation(line: 726, column: 14, scope: !72)
!75 = !DILabel(scope: !76, name: "ERROR", file: !7, line: 726)
!76 = distinct !DILexicalBlock(scope: !71, file: !7, line: 726, column: 28)
!77 = !DILocation(line: 726, column: 30, scope: !76)
!78 = !DILocation(line: 726, column: 38, scope: !79)
!79 = distinct !DILexicalBlock(scope: !76, file: !7, line: 726, column: 37)
!80 = !DILocation(line: 726, column: 52, scope: !79)
!81 = !DILocation(line: 727, column: 9, scope: !65)
!82 = !DILocation(line: 728, column: 3, scope: !65)
!83 = !DILocation(line: 730, column: 1, scope: !49)
!84 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 731, type: !85, scopeLine: 731, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!85 = !DISubroutineType(types: !86)
!86 = !{!21}
!87 = !DILocation(line: 733, column: 2, scope: !84)
!88 = !DILocalVariable(name: "t", scope: !84, file: !7, line: 732, type: !89)
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 300, baseType: !90)
!90 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!91 = !DILocation(line: 0, scope: !84)
!92 = !DILocation(line: 733, column: 13, scope: !93)
!93 = distinct !DILexicalBlock(scope: !84, file: !7, line: 733, column: 11)
!94 = distinct !{!94, !87, !95}
!95 = !DILocation(line: 733, column: 45, scope: !84)
