; ModuleID = '/home/ponce/git/Dat3M/output/test-easy8.wvr.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/weaver/test-easy8.wvr.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"test-easy8.wvr.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@b = dso_local global i8 0, align 1, !dbg !0
@c = dso_local global i8 0, align 1, !dbg !5

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !17 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.1, i64 0, i64 0), i32 noundef 21, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #6, !dbg !21
  unreachable, !dbg !21
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @assume_abort_if_not(i32 noundef %0) #0 !dbg !22 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !26, metadata !DIExpression()), !dbg !27
  %.not = icmp eq i32 %0, 0, !dbg !28
  br i1 %.not, label %2, label %3, !dbg !30

2:                                                ; preds = %1
  call void @abort() #7, !dbg !31
  unreachable, !dbg !31

3:                                                ; preds = %1
  ret void, !dbg !33
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: noreturn
declare void @abort() #3

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread1() #0 !dbg !34 {
  call void @__VERIFIER_atomic_begin() #8, !dbg !38
  %1 = load i8, i8* @b, align 1, !dbg !39
  %2 = and i8 %1, 1, !dbg !39
  %.not = icmp eq i8 %2, 0, !dbg !39
  call void @llvm.dbg.value(metadata i1 %.not, metadata !40, metadata !DIExpression(DW_OP_LLVM_convert, 1, DW_ATE_unsigned, DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !41
  br i1 %.not, label %3, label %4, !dbg !42

3:                                                ; preds = %0
  store i8 0, i8* @c, align 1, !dbg !43
  br label %4, !dbg !46

4:                                                ; preds = %3, %0
  call void @__VERIFIER_atomic_end() #8, !dbg !47
  %5 = xor i8 %2, 1, !dbg !48
  %6 = zext i8 %5 to i32, !dbg !48
  call void @assume_abort_if_not(i32 noundef %6), !dbg !49
  ret i8* null, !dbg !50
}

declare void @__VERIFIER_atomic_begin() #4

declare void @__VERIFIER_atomic_end() #4

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread2() #0 !dbg !51 {
  call void @__VERIFIER_atomic_begin() #8, !dbg !52
  store i8 1, i8* @b, align 1, !dbg !53
  store i8 1, i8* @c, align 1, !dbg !54
  call void @__VERIFIER_atomic_end() #8, !dbg !55
  ret i8* null, !dbg !56
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !57 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = call zeroext i1 @__VERIFIER_nondet_bool() #8, !dbg !60
  %4 = zext i1 %3 to i8, !dbg !61
  store i8 %4, i8* @b, align 1, !dbg !61
  %5 = call zeroext i1 @__VERIFIER_nondet_bool() #8, !dbg !62
  %6 = zext i1 %5 to i8, !dbg !63
  store i8 %6, i8* @c, align 1, !dbg !63
  call void @llvm.dbg.value(metadata i64* %1, metadata !64, metadata !DIExpression(DW_OP_deref)), !dbg !67
  %7 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef bitcast (i8* ()* @thread1 to i8* (i8*)*), i8* noundef null) #8, !dbg !68
  call void @llvm.dbg.value(metadata i64* %2, metadata !69, metadata !DIExpression(DW_OP_deref)), !dbg !67
  %8 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef bitcast (i8* ()* @thread2 to i8* (i8*)*), i8* noundef null) #8, !dbg !70
  %9 = load i64, i64* %1, align 8, !dbg !71
  call void @llvm.dbg.value(metadata i64 %9, metadata !64, metadata !DIExpression()), !dbg !67
  %10 = call i32 @pthread_join(i64 noundef %9, i8** noundef null) #8, !dbg !72
  %11 = load i64, i64* %2, align 8, !dbg !73
  call void @llvm.dbg.value(metadata i64 %11, metadata !69, metadata !DIExpression()), !dbg !67
  %12 = call i32 @pthread_join(i64 noundef %11, i8** noundef null) #8, !dbg !74
  %13 = load i8, i8* @c, align 1, !dbg !75
  %14 = and i8 %13, 1, !dbg !75
  %15 = xor i8 %14, 1, !dbg !76
  %16 = zext i8 %15 to i32, !dbg !76
  call void @assume_abort_if_not(i32 noundef %16), !dbg !77
  call void @reach_error(), !dbg !78
  ret i32 0, !dbg !79
}

declare zeroext i1 @__VERIFIER_nondet_bool() #4

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback noreturn nounwind }
attributes #7 = { noreturn nounwind }
attributes #8 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !7, line: 38, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/weaver/test-easy8.wvr.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "8fc3b3400d57c79944f3a0b109b816e4")
!4 = !{!0, !5}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !7, line: 38, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "../sv-benchmarks/c/weaver/test-easy8.wvr.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "8fc3b3400d57c79944f3a0b109b816e4")
!8 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 7, !"PIC Level", i32 2}
!13 = !{i32 7, !"PIE Level", i32 2}
!14 = !{i32 7, !"uwtable", i32 1}
!15 = !{i32 7, !"frame-pointer", i32 2}
!16 = !{!"Ubuntu clang version 14.0.6"}
!17 = distinct !DISubprogram(name: "reach_error", scope: !7, file: !7, line: 21, type: !18, scopeLine: 21, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!18 = !DISubroutineType(types: !19)
!19 = !{null}
!20 = !{}
!21 = !DILocation(line: 21, column: 22, scope: !17)
!22 = distinct !DISubprogram(name: "assume_abort_if_not", scope: !7, file: !7, line: 34, type: !23, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!23 = !DISubroutineType(types: !24)
!24 = !{null, !25}
!25 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!26 = !DILocalVariable(name: "cond", arg: 1, scope: !22, file: !7, line: 34, type: !25)
!27 = !DILocation(line: 0, scope: !22)
!28 = !DILocation(line: 35, column: 7, scope: !29)
!29 = distinct !DILexicalBlock(scope: !22, file: !7, line: 35, column: 6)
!30 = !DILocation(line: 35, column: 6, scope: !22)
!31 = !DILocation(line: 35, column: 14, scope: !32)
!32 = distinct !DILexicalBlock(scope: !29, file: !7, line: 35, column: 13)
!33 = !DILocation(line: 36, column: 1, scope: !22)
!34 = distinct !DISubprogram(name: "thread1", scope: !7, file: !7, line: 40, type: !35, scopeLine: 40, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!35 = !DISubroutineType(types: !36)
!36 = !{!37}
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!38 = !DILocation(line: 42, column: 3, scope: !34)
!39 = !DILocation(line: 43, column: 23, scope: !34)
!40 = !DILocalVariable(name: "assumption", scope: !34, file: !7, line: 43, type: !8)
!41 = !DILocation(line: 0, scope: !34)
!42 = !DILocation(line: 44, column: 6, scope: !34)
!43 = !DILocation(line: 45, column: 7, scope: !44)
!44 = distinct !DILexicalBlock(scope: !45, file: !7, line: 44, column: 18)
!45 = distinct !DILexicalBlock(scope: !34, file: !7, line: 44, column: 6)
!46 = !DILocation(line: 46, column: 3, scope: !44)
!47 = !DILocation(line: 47, column: 3, scope: !34)
!48 = !DILocation(line: 48, column: 23, scope: !34)
!49 = !DILocation(line: 48, column: 3, scope: !34)
!50 = !DILocation(line: 50, column: 3, scope: !34)
!51 = distinct !DISubprogram(name: "thread2", scope: !7, file: !7, line: 53, type: !35, scopeLine: 53, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!52 = !DILocation(line: 54, column: 3, scope: !51)
!53 = !DILocation(line: 55, column: 5, scope: !51)
!54 = !DILocation(line: 56, column: 5, scope: !51)
!55 = !DILocation(line: 57, column: 3, scope: !51)
!56 = !DILocation(line: 59, column: 3, scope: !51)
!57 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 62, type: !58, scopeLine: 62, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !20)
!58 = !DISubroutineType(types: !59)
!59 = !{!25}
!60 = !DILocation(line: 65, column: 7, scope: !57)
!61 = !DILocation(line: 65, column: 5, scope: !57)
!62 = !DILocation(line: 66, column: 7, scope: !57)
!63 = !DILocation(line: 66, column: 5, scope: !57)
!64 = !DILocalVariable(name: "t1", scope: !57, file: !7, line: 63, type: !65)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !7, line: 9, baseType: !66)
!66 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!67 = !DILocation(line: 0, scope: !57)
!68 = !DILocation(line: 69, column: 3, scope: !57)
!69 = !DILocalVariable(name: "t2", scope: !57, file: !7, line: 63, type: !65)
!70 = !DILocation(line: 70, column: 3, scope: !57)
!71 = !DILocation(line: 71, column: 16, scope: !57)
!72 = !DILocation(line: 71, column: 3, scope: !57)
!73 = !DILocation(line: 72, column: 16, scope: !57)
!74 = !DILocation(line: 72, column: 3, scope: !57)
!75 = !DILocation(line: 74, column: 24, scope: !57)
!76 = !DILocation(line: 74, column: 23, scope: !57)
!77 = !DILocation(line: 74, column: 3, scope: !57)
!78 = !DILocation(line: 75, column: 3, scope: !57)
!79 = !DILocation(line: 77, column: 3, scope: !57)
