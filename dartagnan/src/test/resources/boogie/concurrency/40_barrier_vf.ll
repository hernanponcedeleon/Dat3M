; ModuleID = '/home/ponce/git/Dat3M/output/40_barrier_vf.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/40_barrier_vf.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [16 x i8] c"40_barrier_vf.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@count = dso_local global i32 0, align 4, !dbg !0
@MTX = dso_local global i8 0, align 1, !dbg !5
@COND = dso_local global i8 0, align 1, !dbg !9

; Function Attrs: noinline nounwind uwtable
define dso_local void @assume_abort_if_not(i32 noundef %0) #0 !dbg !21 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !26, metadata !DIExpression()), !dbg !27
  %.not = icmp eq i32 %0, 0, !dbg !28
  br i1 %.not, label %2, label %3, !dbg !30

2:                                                ; preds = %1
  call void @abort() #6, !dbg !31
  unreachable, !dbg !31

3:                                                ; preds = %1
  ret void, !dbg !33
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn
declare void @abort() #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !34 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.1, i64 0, i64 0), i32 noundef 7, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #7, !dbg !37
  unreachable, !dbg !37
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_acquire() #0 !dbg !40 {
  %1 = load i8, i8* @MTX, align 1, !dbg !41
  %2 = and i8 %1, 1, !dbg !41
  %3 = xor i8 %2, 1, !dbg !42
  %4 = zext i8 %3 to i32, !dbg !42
  call void @assume_abort_if_not(i32 noundef %4), !dbg !43
  store i8 1, i8* @MTX, align 1, !dbg !44
  ret void, !dbg !45
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @__VERIFIER_atomic_release() #0 !dbg !46 {
  %1 = load i8, i8* @MTX, align 1, !dbg !47
  %2 = and i8 %1, 1, !dbg !47
  %3 = zext i8 %2 to i32, !dbg !47
  call void @assume_abort_if_not(i32 noundef %3), !dbg !48
  store i8 0, i8* @MTX, align 1, !dbg !49
  ret void, !dbg !50
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @Barrier2() #0 !dbg !51 {
  call void @__VERIFIER_atomic_acquire(), !dbg !52
  %1 = load volatile i32, i32* @count, align 4, !dbg !53
  %2 = add i32 %1, 1, !dbg !53
  store volatile i32 %2, i32* @count, align 4, !dbg !53
  %3 = load volatile i32, i32* @count, align 4, !dbg !54
  %4 = icmp eq i32 %3, 3, !dbg !56
  br i1 %4, label %5, label %6, !dbg !57

5:                                                ; preds = %0
  call void @__VERIFIER_atomic_begin() #8, !dbg !58
  store i8 1, i8* @COND, align 1, !dbg !61
  call void @__VERIFIER_atomic_end() #8, !dbg !62
  store volatile i32 0, i32* @count, align 4, !dbg !63
  br label %10, !dbg !64

6:                                                ; preds = %0
  call void @__VERIFIER_atomic_release(), !dbg !65
  call void @__VERIFIER_atomic_begin() #8, !dbg !67
  %7 = load i8, i8* @COND, align 1, !dbg !68
  %8 = and i8 %7, 1, !dbg !68
  %9 = zext i8 %8 to i32, !dbg !68
  call void @assume_abort_if_not(i32 noundef %9), !dbg !69
  call void @__VERIFIER_atomic_end() #8, !dbg !70
  call void @__VERIFIER_atomic_begin() #8, !dbg !71
  store i8 0, i8* @COND, align 1, !dbg !72
  call void @__VERIFIER_atomic_end() #8, !dbg !73
  call void @__VERIFIER_atomic_acquire(), !dbg !74
  br label %10

10:                                               ; preds = %6, %5
  call void @__VERIFIER_atomic_release(), !dbg !75
  ret void, !dbg !76
}

declare void @__VERIFIER_atomic_begin() #4

declare void @__VERIFIER_atomic_end() #4

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thr1(i8* noundef %0) #0 !dbg !77 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !81, metadata !DIExpression()), !dbg !82
  call void @Barrier2(), !dbg !83
  call void @llvm.dbg.label(metadata !84), !dbg !88
  call void @reach_error(), !dbg !89
  call void @abort() #6, !dbg !91
  unreachable, !dbg !91
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !92 {
  %1 = alloca i64, align 8
  br label %2, !dbg !95

2:                                                ; preds = %2, %0
  call void @llvm.dbg.value(metadata i64* %1, metadata !96, metadata !DIExpression(DW_OP_deref)), !dbg !99
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thr1, i8* noundef null) #8, !dbg !100
  br label %2, !dbg !95, !llvm.loop !102
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
!llvm.module.flags = !{!13, !14, !15, !16, !17, !18, !19}
!llvm.ident = !{!20}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "count", scope: !2, file: !7, line: 704, type: !11, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread-ext/40_barrier_vf.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "84c27332a76ca8b6e0e6c52924eee06d")
!4 = !{!0, !5, !9}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "MTX", scope: !2, file: !7, line: 705, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/pthread-ext/40_barrier_vf.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "84c27332a76ca8b6e0e6c52924eee06d")
!8 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!9 = !DIGlobalVariableExpression(var: !10, expr: !DIExpression())
!10 = distinct !DIGlobalVariable(name: "COND", scope: !2, file: !7, line: 706, type: !8, isLocal: false, isDefinition: true)
!11 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !12)
!12 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!13 = !{i32 7, !"Dwarf Version", i32 5}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = !{i32 7, !"PIC Level", i32 2}
!17 = !{i32 7, !"PIE Level", i32 2}
!18 = !{i32 7, !"uwtable", i32 1}
!19 = !{i32 7, !"frame-pointer", i32 2}
!20 = !{!"Ubuntu clang version 14.0.6"}
!21 = distinct !DISubprogram(name: "assume_abort_if_not", scope: !7, file: !7, line: 2, type: !22, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!22 = !DISubroutineType(types: !23)
!23 = !{null, !24}
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !{}
!26 = !DILocalVariable(name: "cond", arg: 1, scope: !21, file: !7, line: 2, type: !24)
!27 = !DILocation(line: 0, scope: !21)
!28 = !DILocation(line: 3, column: 7, scope: !29)
!29 = distinct !DILexicalBlock(scope: !21, file: !7, line: 3, column: 6)
!30 = !DILocation(line: 3, column: 6, scope: !21)
!31 = !DILocation(line: 3, column: 14, scope: !32)
!32 = distinct !DILexicalBlock(scope: !29, file: !7, line: 3, column: 13)
!33 = !DILocation(line: 4, column: 1, scope: !21)
!34 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 16, type: !35, scopeLine: 16, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!35 = !DISubroutineType(types: !36)
!36 = !{null}
!37 = !DILocation(line: 16, column: 83, scope: !38)
!38 = distinct !DILexicalBlock(scope: !39, file: !7, line: 16, column: 73)
!39 = distinct !DILexicalBlock(scope: !34, file: !7, line: 16, column: 67)
!40 = distinct !DISubprogram(name: "__VERIFIER_atomic_acquire", scope: !7, file: !7, line: 707, type: !35, scopeLine: 708, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!41 = !DILocation(line: 709, column: 22, scope: !40)
!42 = !DILocation(line: 709, column: 25, scope: !40)
!43 = !DILocation(line: 709, column: 2, scope: !40)
!44 = !DILocation(line: 710, column: 6, scope: !40)
!45 = !DILocation(line: 711, column: 1, scope: !40)
!46 = distinct !DISubprogram(name: "__VERIFIER_atomic_release", scope: !7, file: !7, line: 712, type: !35, scopeLine: 713, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!47 = !DILocation(line: 714, column: 22, scope: !46)
!48 = !DILocation(line: 714, column: 2, scope: !46)
!49 = !DILocation(line: 715, column: 6, scope: !46)
!50 = !DILocation(line: 716, column: 1, scope: !46)
!51 = distinct !DISubprogram(name: "Barrier2", scope: !7, file: !7, line: 717, type: !35, scopeLine: 717, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!52 = !DILocation(line: 718, column: 3, scope: !51)
!53 = !DILocation(line: 719, column: 8, scope: !51)
!54 = !DILocation(line: 720, column: 7, scope: !55)
!55 = distinct !DILexicalBlock(scope: !51, file: !7, line: 720, column: 7)
!56 = !DILocation(line: 720, column: 13, scope: !55)
!57 = !DILocation(line: 720, column: 7, scope: !51)
!58 = !DILocation(line: 721, column: 7, scope: !59)
!59 = distinct !DILexicalBlock(scope: !60, file: !7, line: 721, column: 5)
!60 = distinct !DILexicalBlock(scope: !55, file: !7, line: 720, column: 19)
!61 = !DILocation(line: 721, column: 40, scope: !59)
!62 = !DILocation(line: 721, column: 46, scope: !59)
!63 = !DILocation(line: 722, column: 11, scope: !60)
!64 = !DILocation(line: 722, column: 16, scope: !60)
!65 = !DILocation(line: 724, column: 7, scope: !66)
!66 = distinct !DILexicalBlock(scope: !55, file: !7, line: 724, column: 5)
!67 = !DILocation(line: 724, column: 36, scope: !66)
!68 = !DILocation(line: 724, column: 83, scope: !66)
!69 = !DILocation(line: 724, column: 63, scope: !66)
!70 = !DILocation(line: 724, column: 90, scope: !66)
!71 = !DILocation(line: 724, column: 115, scope: !66)
!72 = !DILocation(line: 724, column: 147, scope: !66)
!73 = !DILocation(line: 724, column: 152, scope: !66)
!74 = !DILocation(line: 724, column: 177, scope: !66)
!75 = !DILocation(line: 725, column: 3, scope: !51)
!76 = !DILocation(line: 725, column: 32, scope: !51)
!77 = distinct !DISubprogram(name: "thr1", scope: !7, file: !7, line: 726, type: !78, scopeLine: 726, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!78 = !DISubroutineType(types: !79)
!79 = !{!80, !80}
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!81 = !DILocalVariable(name: "arg", arg: 1, scope: !77, file: !7, line: 726, type: !80)
!82 = !DILocation(line: 0, scope: !77)
!83 = !DILocation(line: 727, column: 3, scope: !77)
!84 = !DILabel(scope: !85, name: "ERROR", file: !7, line: 728)
!85 = distinct !DILexicalBlock(scope: !86, file: !7, line: 728, column: 14)
!86 = distinct !DILexicalBlock(scope: !87, file: !7, line: 728, column: 8)
!87 = distinct !DILexicalBlock(scope: !77, file: !7, line: 728, column: 3)
!88 = !DILocation(line: 728, column: 16, scope: !85)
!89 = !DILocation(line: 728, column: 24, scope: !90)
!90 = distinct !DILexicalBlock(scope: !85, file: !7, line: 728, column: 23)
!91 = !DILocation(line: 728, column: 38, scope: !90)
!92 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 731, type: !93, scopeLine: 731, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!93 = !DISubroutineType(types: !94)
!94 = !{!24}
!95 = !DILocation(line: 733, column: 2, scope: !92)
!96 = !DILocalVariable(name: "t", scope: !92, file: !7, line: 732, type: !97)
!97 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 300, baseType: !98)
!98 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!99 = !DILocation(line: 0, scope: !92)
!100 = !DILocation(line: 733, column: 13, scope: !101)
!101 = distinct !DILexicalBlock(scope: !92, file: !7, line: 733, column: 11)
!102 = distinct !{!102, !95, !103}
!103 = !DILocation(line: 733, column: 45, scope: !92)
