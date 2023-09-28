; ModuleID = '/home/ponce/git/Dat3M/output/triangular-1.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread/triangular-1.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [15 x i8] c"triangular-1.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@i = dso_local global i32 3, align 4, !dbg !0
@j = dso_local global i32 6, align 4, !dbg !7

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !19 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.1, i64 0, i64 0), i32 noundef 8, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !23
  unreachable, !dbg !23
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @t1(i8* noundef %0) #0 !dbg !26 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !29, metadata !DIExpression()), !dbg !30
  call void @llvm.dbg.value(metadata i32 0, metadata !31, metadata !DIExpression()), !dbg !33
  call void @llvm.dbg.value(metadata i32 0, metadata !31, metadata !DIExpression()), !dbg !33
  call void (...) @__VERIFIER_atomic_begin() #7, !dbg !34
  %2 = load i32, i32* @j, align 4, !dbg !37
  %3 = add nsw i32 %2, 1, !dbg !38
  store i32 %3, i32* @i, align 4, !dbg !39
  call void (...) @__VERIFIER_atomic_end() #7, !dbg !40
  call void @llvm.dbg.value(metadata i32 1, metadata !31, metadata !DIExpression()), !dbg !33
  call void @llvm.dbg.value(metadata i32 1, metadata !31, metadata !DIExpression()), !dbg !33
  call void (...) @__VERIFIER_atomic_begin() #7, !dbg !34
  %4 = load i32, i32* @j, align 4, !dbg !37
  %5 = add nsw i32 %4, 1, !dbg !38
  store i32 %5, i32* @i, align 4, !dbg !39
  call void (...) @__VERIFIER_atomic_end() #7, !dbg !40
  call void @llvm.dbg.value(metadata i32 2, metadata !31, metadata !DIExpression()), !dbg !33
  call void @llvm.dbg.value(metadata i32 2, metadata !31, metadata !DIExpression()), !dbg !33
  call void (...) @__VERIFIER_atomic_begin() #7, !dbg !34
  %6 = load i32, i32* @j, align 4, !dbg !37
  %7 = add nsw i32 %6, 1, !dbg !38
  store i32 %7, i32* @i, align 4, !dbg !39
  call void (...) @__VERIFIER_atomic_end() #7, !dbg !40
  call void @llvm.dbg.value(metadata i32 3, metadata !31, metadata !DIExpression()), !dbg !33
  call void @llvm.dbg.value(metadata i32 3, metadata !31, metadata !DIExpression()), !dbg !33
  call void (...) @__VERIFIER_atomic_begin() #7, !dbg !34
  %8 = load i32, i32* @j, align 4, !dbg !37
  %9 = add nsw i32 %8, 1, !dbg !38
  store i32 %9, i32* @i, align 4, !dbg !39
  call void (...) @__VERIFIER_atomic_end() #7, !dbg !40
  call void @llvm.dbg.value(metadata i32 4, metadata !31, metadata !DIExpression()), !dbg !33
  call void @llvm.dbg.value(metadata i32 4, metadata !31, metadata !DIExpression()), !dbg !33
  call void (...) @__VERIFIER_atomic_begin() #7, !dbg !34
  %10 = load i32, i32* @j, align 4, !dbg !37
  %11 = add nsw i32 %10, 1, !dbg !38
  store i32 %11, i32* @i, align 4, !dbg !39
  call void (...) @__VERIFIER_atomic_end() #7, !dbg !40
  call void @llvm.dbg.value(metadata i32 5, metadata !31, metadata !DIExpression()), !dbg !33
  call void @llvm.dbg.value(metadata i32 5, metadata !31, metadata !DIExpression()), !dbg !33
  call void @pthread_exit(i8* noundef null) #8, !dbg !41
  unreachable, !dbg !41
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

declare void @__VERIFIER_atomic_begin(...) #3

declare void @__VERIFIER_atomic_end(...) #3

; Function Attrs: noreturn
declare void @pthread_exit(i8* noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @t2(i8* noundef %0) #0 !dbg !42 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !43, metadata !DIExpression()), !dbg !44
  call void @llvm.dbg.value(metadata i32 0, metadata !45, metadata !DIExpression()), !dbg !47
  call void @llvm.dbg.value(metadata i32 0, metadata !45, metadata !DIExpression()), !dbg !47
  call void (...) @__VERIFIER_atomic_begin() #7, !dbg !48
  %2 = load i32, i32* @i, align 4, !dbg !51
  %3 = add nsw i32 %2, 1, !dbg !52
  store i32 %3, i32* @j, align 4, !dbg !53
  call void (...) @__VERIFIER_atomic_end() #7, !dbg !54
  call void @llvm.dbg.value(metadata i32 1, metadata !45, metadata !DIExpression()), !dbg !47
  call void @llvm.dbg.value(metadata i32 1, metadata !45, metadata !DIExpression()), !dbg !47
  call void (...) @__VERIFIER_atomic_begin() #7, !dbg !48
  %4 = load i32, i32* @i, align 4, !dbg !51
  %5 = add nsw i32 %4, 1, !dbg !52
  store i32 %5, i32* @j, align 4, !dbg !53
  call void (...) @__VERIFIER_atomic_end() #7, !dbg !54
  call void @llvm.dbg.value(metadata i32 2, metadata !45, metadata !DIExpression()), !dbg !47
  call void @llvm.dbg.value(metadata i32 2, metadata !45, metadata !DIExpression()), !dbg !47
  call void (...) @__VERIFIER_atomic_begin() #7, !dbg !48
  %6 = load i32, i32* @i, align 4, !dbg !51
  %7 = add nsw i32 %6, 1, !dbg !52
  store i32 %7, i32* @j, align 4, !dbg !53
  call void (...) @__VERIFIER_atomic_end() #7, !dbg !54
  call void @llvm.dbg.value(metadata i32 3, metadata !45, metadata !DIExpression()), !dbg !47
  call void @llvm.dbg.value(metadata i32 3, metadata !45, metadata !DIExpression()), !dbg !47
  call void (...) @__VERIFIER_atomic_begin() #7, !dbg !48
  %8 = load i32, i32* @i, align 4, !dbg !51
  %9 = add nsw i32 %8, 1, !dbg !52
  store i32 %9, i32* @j, align 4, !dbg !53
  call void (...) @__VERIFIER_atomic_end() #7, !dbg !54
  call void @llvm.dbg.value(metadata i32 4, metadata !45, metadata !DIExpression()), !dbg !47
  call void @llvm.dbg.value(metadata i32 4, metadata !45, metadata !DIExpression()), !dbg !47
  call void (...) @__VERIFIER_atomic_begin() #7, !dbg !48
  %10 = load i32, i32* @i, align 4, !dbg !51
  %11 = add nsw i32 %10, 1, !dbg !52
  store i32 %11, i32* @j, align 4, !dbg !53
  call void (...) @__VERIFIER_atomic_end() #7, !dbg !54
  call void @llvm.dbg.value(metadata i32 5, metadata !45, metadata !DIExpression()), !dbg !47
  call void @llvm.dbg.value(metadata i32 5, metadata !45, metadata !DIExpression()), !dbg !47
  call void @pthread_exit(i8* noundef null) #8, !dbg !55
  unreachable, !dbg !55
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main(i32 noundef %0, i8** noundef %1) #0 !dbg !56 {
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i32 %0, metadata !62, metadata !DIExpression()), !dbg !63
  call void @llvm.dbg.value(metadata i8** %1, metadata !64, metadata !DIExpression()), !dbg !63
  call void @llvm.dbg.value(metadata i64* %3, metadata !65, metadata !DIExpression(DW_OP_deref)), !dbg !63
  %5 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @t1, i8* noundef null) #7, !dbg !68
  call void @llvm.dbg.value(metadata i64* %4, metadata !69, metadata !DIExpression(DW_OP_deref)), !dbg !63
  %6 = call i32 @pthread_create(i64* noundef nonnull %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @t2, i8* noundef null) #7, !dbg !70
  call void (...) @__VERIFIER_atomic_begin() #7, !dbg !71
  %7 = load i32, i32* @i, align 4, !dbg !72
  %8 = icmp sgt i32 %7, 16, !dbg !73
  call void @llvm.dbg.value(metadata i1 %8, metadata !74, metadata !DIExpression(DW_OP_LLVM_convert, 1, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !63
  call void (...) @__VERIFIER_atomic_end() #7, !dbg !75
  call void (...) @__VERIFIER_atomic_begin() #7, !dbg !76
  %9 = load i32, i32* @j, align 4, !dbg !77
  %10 = icmp sgt i32 %9, 16, !dbg !78
  call void @llvm.dbg.value(metadata i1 %10, metadata !79, metadata !DIExpression(DW_OP_LLVM_convert, 1, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !63
  call void (...) @__VERIFIER_atomic_end() #7, !dbg !80
  %brmerge = select i1 %8, i1 true, i1 %10, !dbg !81
  br i1 %brmerge, label %11, label %12, !dbg !81

11:                                               ; preds = %2
  call void @llvm.dbg.label(metadata !83), !dbg !85
  call void @reach_error(), !dbg !86
  call void @abort() #8, !dbg !88
  unreachable, !dbg !88

12:                                               ; preds = %2
  ret i32 0, !dbg !89
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: noreturn
declare void @abort() #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback noreturn nounwind }
attributes #7 = { nounwind }
attributes #8 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!11, !12, !13, !14, !15, !16, !17}
!llvm.ident = !{!18}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "i", scope: !2, file: !9, line: 694, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread/triangular-1.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "2d570b92520c1a8a2a2f7b83279e4e9a")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "j", scope: !2, file: !9, line: 694, type: !10, isLocal: false, isDefinition: true)
!9 = !DIFile(filename: "../sv-benchmarks/c/pthread/triangular-1.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "2d570b92520c1a8a2a2f7b83279e4e9a")
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !{i32 7, !"Dwarf Version", i32 5}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 1, !"wchar_size", i32 4}
!14 = !{i32 7, !"PIC Level", i32 2}
!15 = !{i32 7, !"PIE Level", i32 2}
!16 = !{i32 7, !"uwtable", i32 1}
!17 = !{i32 7, !"frame-pointer", i32 2}
!18 = !{!"Ubuntu clang version 14.0.6"}
!19 = distinct !DISubprogram(name: "reach_error", scope: !9, file: !9, line: 693, type: !20, scopeLine: 693, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!20 = !DISubroutineType(types: !21)
!21 = !{null}
!22 = !{}
!23 = !DILocation(line: 693, column: 83, scope: !24)
!24 = distinct !DILexicalBlock(scope: !25, file: !9, line: 693, column: 73)
!25 = distinct !DILexicalBlock(scope: !19, file: !9, line: 693, column: 67)
!26 = distinct !DISubprogram(name: "t1", scope: !9, file: !9, line: 695, type: !27, scopeLine: 695, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!27 = !DISubroutineType(types: !28)
!28 = !{!5, !5}
!29 = !DILocalVariable(name: "arg", arg: 1, scope: !26, file: !9, line: 695, type: !5)
!30 = !DILocation(line: 0, scope: !26)
!31 = !DILocalVariable(name: "k", scope: !32, file: !9, line: 696, type: !10)
!32 = distinct !DILexicalBlock(scope: !26, file: !9, line: 696, column: 3)
!33 = !DILocation(line: 0, scope: !32)
!34 = !DILocation(line: 697, column: 5, scope: !35)
!35 = distinct !DILexicalBlock(scope: !36, file: !9, line: 696, column: 31)
!36 = distinct !DILexicalBlock(scope: !32, file: !9, line: 696, column: 3)
!37 = !DILocation(line: 698, column: 9, scope: !35)
!38 = !DILocation(line: 698, column: 11, scope: !35)
!39 = !DILocation(line: 698, column: 7, scope: !35)
!40 = !DILocation(line: 699, column: 5, scope: !35)
!41 = !DILocation(line: 701, column: 3, scope: !26)
!42 = distinct !DISubprogram(name: "t2", scope: !9, file: !9, line: 703, type: !27, scopeLine: 703, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!43 = !DILocalVariable(name: "arg", arg: 1, scope: !42, file: !9, line: 703, type: !5)
!44 = !DILocation(line: 0, scope: !42)
!45 = !DILocalVariable(name: "k", scope: !46, file: !9, line: 704, type: !10)
!46 = distinct !DILexicalBlock(scope: !42, file: !9, line: 704, column: 3)
!47 = !DILocation(line: 0, scope: !46)
!48 = !DILocation(line: 705, column: 5, scope: !49)
!49 = distinct !DILexicalBlock(scope: !50, file: !9, line: 704, column: 31)
!50 = distinct !DILexicalBlock(scope: !46, file: !9, line: 704, column: 3)
!51 = !DILocation(line: 706, column: 9, scope: !49)
!52 = !DILocation(line: 706, column: 11, scope: !49)
!53 = !DILocation(line: 706, column: 7, scope: !49)
!54 = !DILocation(line: 707, column: 5, scope: !49)
!55 = !DILocation(line: 709, column: 3, scope: !42)
!56 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 711, type: !57, scopeLine: 711, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !22)
!57 = !DISubroutineType(types: !58)
!58 = !{!10, !10, !59}
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!61 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!62 = !DILocalVariable(name: "argc", arg: 1, scope: !56, file: !9, line: 711, type: !10)
!63 = !DILocation(line: 0, scope: !56)
!64 = !DILocalVariable(name: "argv", arg: 2, scope: !56, file: !9, line: 711, type: !59)
!65 = !DILocalVariable(name: "id1", scope: !56, file: !9, line: 712, type: !66)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !9, line: 276, baseType: !67)
!67 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!68 = !DILocation(line: 713, column: 3, scope: !56)
!69 = !DILocalVariable(name: "id2", scope: !56, file: !9, line: 712, type: !66)
!70 = !DILocation(line: 714, column: 3, scope: !56)
!71 = !DILocation(line: 715, column: 3, scope: !56)
!72 = !DILocation(line: 716, column: 15, scope: !56)
!73 = !DILocation(line: 716, column: 17, scope: !56)
!74 = !DILocalVariable(name: "condI", scope: !56, file: !9, line: 716, type: !10)
!75 = !DILocation(line: 717, column: 3, scope: !56)
!76 = !DILocation(line: 718, column: 3, scope: !56)
!77 = !DILocation(line: 719, column: 15, scope: !56)
!78 = !DILocation(line: 719, column: 17, scope: !56)
!79 = !DILocalVariable(name: "condJ", scope: !56, file: !9, line: 719, type: !10)
!80 = !DILocation(line: 720, column: 3, scope: !56)
!81 = !DILocation(line: 721, column: 13, scope: !82)
!82 = distinct !DILexicalBlock(scope: !56, file: !9, line: 721, column: 7)
!83 = !DILabel(scope: !84, name: "ERROR", file: !9, line: 722)
!84 = distinct !DILexicalBlock(scope: !82, file: !9, line: 721, column: 23)
!85 = !DILocation(line: 722, column: 5, scope: !84)
!86 = !DILocation(line: 722, column: 13, scope: !87)
!87 = distinct !DILexicalBlock(scope: !84, file: !9, line: 722, column: 12)
!88 = !DILocation(line: 722, column: 27, scope: !87)
!89 = !DILocation(line: 724, column: 3, scope: !56)
