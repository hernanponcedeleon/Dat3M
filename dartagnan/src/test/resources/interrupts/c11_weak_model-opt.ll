; ModuleID = '/home/ponce/git/Dat3M/output/c11_weak_model.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/interrupts/c11_weak_model.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@r1 = dso_local global i32 0, align 4, !dbg !32
@y = dso_local global i32 0, align 4, !dbg !18
@r2 = dso_local global i32 0, align 4, !dbg !34
@h = dso_local global i64 0, align 8, !dbg !44
@b1 = dso_local global i32 0, align 4, !dbg !28
@a1 = dso_local global i32 0, align 4, !dbg !24
@b2 = dso_local global i32 0, align 4, !dbg !30
@a2 = dso_local global i32 0, align 4, !dbg !26
@t1 = dso_local global i32 0, align 4, !dbg !36
@u1 = dso_local global i32 0, align 4, !dbg !38
@t2 = dso_local global i32 0, align 4, !dbg !40
@u2 = dso_local global i32 0, align 4, !dbg !42
@.str = private unnamed_addr constant [29 x i8] c"! reorder_bx || ! reorder_ya\00", align 1
@.str.1 = private unnamed_addr constant [61 x i8] c"/home/ponce/git/Dat3M/benchmarks/interrupts/c11_weak_model.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @handler(i8* noundef %0) #0 !dbg !57 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !61, metadata !DIExpression()), !dbg !62
  %2 = load atomic i32, i32* @x monotonic, align 4, !dbg !63
  store i32 %2, i32* @r1, align 4, !dbg !64
  fence seq_cst, !dbg !65
  %3 = load atomic i32, i32* @y monotonic, align 4, !dbg !66
  store i32 %3, i32* @r2, align 4, !dbg !67
  ret i8* null, !dbg !68
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !69 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !70, metadata !DIExpression()), !dbg !71
  %2 = call i32 (...) @__VERIFIER_make_interrupt_handler(), !dbg !72
  %3 = call i32 @pthread_create(i64* noundef @h, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null) #5, !dbg !73
  store atomic i32 1, i32* @b1 monotonic, align 4, !dbg !74
  store atomic i32 1, i32* @x monotonic, align 4, !dbg !75
  store atomic i32 1, i32* @a1 monotonic, align 4, !dbg !76
  store atomic i32 1, i32* @b2 monotonic, align 4, !dbg !77
  store atomic i32 1, i32* @y monotonic, align 4, !dbg !78
  store atomic i32 1, i32* @a2 monotonic, align 4, !dbg !79
  %4 = load i64, i64* @h, align 8, !dbg !80
  %5 = call i32 @pthread_join(i64 noundef %4, i8** noundef null), !dbg !81
  ret i8* null, !dbg !82
}

declare i32 @__VERIFIER_make_interrupt_handler(...) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !83 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !84, metadata !DIExpression()), !dbg !85
  %2 = load atomic i32, i32* @a1 monotonic, align 4, !dbg !86
  store i32 %2, i32* @t1, align 4, !dbg !87
  %3 = load atomic i32, i32* @b1 monotonic, align 4, !dbg !88
  store i32 %3, i32* @u1, align 4, !dbg !89
  fence seq_cst, !dbg !90
  %4 = load atomic i32, i32* @a2 monotonic, align 4, !dbg !91
  store i32 %4, i32* @t2, align 4, !dbg !92
  %5 = load atomic i32, i32* @b2 monotonic, align 4, !dbg !93
  store i32 %5, i32* @u2, align 4, !dbg !94
  ret i8* null, !dbg !95
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !96 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !99, metadata !DIExpression()), !dbg !100
  call void @llvm.dbg.declare(metadata i64* %2, metadata !101, metadata !DIExpression()), !dbg !102
  %3 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef null) #5, !dbg !103
  %4 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_2, i8* noundef null) #5, !dbg !104
  %5 = load i64, i64* %1, align 8, !dbg !105
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef null), !dbg !106
  %7 = load i64, i64* %2, align 8, !dbg !107
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null), !dbg !108
  %9 = load i32, i32* @t1, align 4, !dbg !109
  %10 = icmp eq i32 %9, 1, !dbg !110
  %11 = load i32, i32* @t2, align 4, !dbg !111
  %12 = icmp eq i32 %11, 0, !dbg !111
  %13 = select i1 %10, i1 %12, i1 false, !dbg !111
  %14 = zext i1 %13 to i8, !dbg !112
  call void @llvm.dbg.value(metadata i8 %14, metadata !113, metadata !DIExpression()), !dbg !115
  %15 = load i32, i32* @u1, align 4, !dbg !116
  %16 = icmp eq i32 %15, 1, !dbg !117
  %17 = load i32, i32* @u2, align 4, !dbg !118
  %18 = icmp eq i32 %17, 0, !dbg !118
  %19 = select i1 %16, i1 %18, i1 false, !dbg !118
  %20 = zext i1 %19 to i8, !dbg !119
  call void @llvm.dbg.value(metadata i8 %20, metadata !120, metadata !DIExpression()), !dbg !115
  %21 = load i32, i32* @r1, align 4, !dbg !121
  %22 = icmp eq i32 %21, 1, !dbg !123
  %23 = load i32, i32* @r2, align 4
  %24 = icmp eq i32 %23, 0
  %or.cond = select i1 %22, i1 %24, i1 false, !dbg !124
  br i1 %or.cond, label %25, label %27, !dbg !124

25:                                               ; preds = %0
  %.not = xor i1 %13, true, !dbg !125
  %.not2 = xor i1 %19, true, !dbg !125
  %brmerge = select i1 %.not, i1 true, i1 %.not2, !dbg !125
  br i1 %brmerge, label %27, label %26, !dbg !125

26:                                               ; preds = %25
  call void @__assert_fail(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @.str.1, i64 0, i64 0), i32 noundef 59, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !125
  unreachable, !dbg !125

27:                                               ; preds = %25, %0
  ret i32 0, !dbg !129
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!49, !50, !51, !52, !53, !54, !55}
!llvm.ident = !{!56}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !20, line: 8, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/interrupts/c11_weak_model.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "b8b3e43c963dda47cddbcde87d0e8611")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 56, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "de5d66a1ef2f5448cc1919ff39db92bc")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !{!0, !18, !24, !26, !28, !30, !32, !34, !36, !38, !40, !42, !44}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !20, line: 8, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/interrupts/c11_weak_model.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "b8b3e43c963dda47cddbcde87d0e8611")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "a1", scope: !2, file: !20, line: 8, type: !21, isLocal: false, isDefinition: true)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "a2", scope: !2, file: !20, line: 8, type: !21, isLocal: false, isDefinition: true)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "b1", scope: !2, file: !20, line: 8, type: !21, isLocal: false, isDefinition: true)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "b2", scope: !2, file: !20, line: 8, type: !21, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !20, line: 9, type: !23, isLocal: false, isDefinition: true)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "r2", scope: !2, file: !20, line: 9, type: !23, isLocal: false, isDefinition: true)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "t1", scope: !2, file: !20, line: 9, type: !23, isLocal: false, isDefinition: true)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "u1", scope: !2, file: !20, line: 9, type: !23, isLocal: false, isDefinition: true)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "t2", scope: !2, file: !20, line: 9, type: !23, isLocal: false, isDefinition: true)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "u2", scope: !2, file: !20, line: 9, type: !23, isLocal: false, isDefinition: true)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !20, line: 11, type: !46, isLocal: false, isDefinition: true)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !47, line: 27, baseType: !48)
!47 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!48 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!49 = !{i32 7, !"Dwarf Version", i32 5}
!50 = !{i32 2, !"Debug Info Version", i32 3}
!51 = !{i32 1, !"wchar_size", i32 4}
!52 = !{i32 7, !"PIC Level", i32 2}
!53 = !{i32 7, !"PIE Level", i32 2}
!54 = !{i32 7, !"uwtable", i32 1}
!55 = !{i32 7, !"frame-pointer", i32 2}
!56 = !{!"Ubuntu clang version 14.0.6"}
!57 = distinct !DISubprogram(name: "handler", scope: !20, file: !20, line: 12, type: !58, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!58 = !DISubroutineType(types: !59)
!59 = !{!16, !16}
!60 = !{}
!61 = !DILocalVariable(name: "arg", arg: 1, scope: !57, file: !20, line: 12, type: !16)
!62 = !DILocation(line: 0, scope: !57)
!63 = !DILocation(line: 14, column: 10, scope: !57)
!64 = !DILocation(line: 14, column: 8, scope: !57)
!65 = !DILocation(line: 15, column: 5, scope: !57)
!66 = !DILocation(line: 16, column: 10, scope: !57)
!67 = !DILocation(line: 16, column: 8, scope: !57)
!68 = !DILocation(line: 17, column: 5, scope: !57)
!69 = distinct !DISubprogram(name: "thread_1", scope: !20, file: !20, line: 20, type: !58, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!70 = !DILocalVariable(name: "arg", arg: 1, scope: !69, file: !20, line: 20, type: !16)
!71 = !DILocation(line: 0, scope: !69)
!72 = !DILocation(line: 22, column: 5, scope: !69)
!73 = !DILocation(line: 23, column: 5, scope: !69)
!74 = !DILocation(line: 25, column: 5, scope: !69)
!75 = !DILocation(line: 26, column: 5, scope: !69)
!76 = !DILocation(line: 27, column: 5, scope: !69)
!77 = !DILocation(line: 28, column: 5, scope: !69)
!78 = !DILocation(line: 29, column: 5, scope: !69)
!79 = !DILocation(line: 30, column: 5, scope: !69)
!80 = !DILocation(line: 32, column: 18, scope: !69)
!81 = !DILocation(line: 32, column: 5, scope: !69)
!82 = !DILocation(line: 34, column: 5, scope: !69)
!83 = distinct !DISubprogram(name: "thread_2", scope: !20, file: !20, line: 37, type: !58, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!84 = !DILocalVariable(name: "arg", arg: 1, scope: !83, file: !20, line: 37, type: !16)
!85 = !DILocation(line: 0, scope: !83)
!86 = !DILocation(line: 39, column: 10, scope: !83)
!87 = !DILocation(line: 39, column: 8, scope: !83)
!88 = !DILocation(line: 40, column: 10, scope: !83)
!89 = !DILocation(line: 40, column: 8, scope: !83)
!90 = !DILocation(line: 41, column: 5, scope: !83)
!91 = !DILocation(line: 42, column: 10, scope: !83)
!92 = !DILocation(line: 42, column: 8, scope: !83)
!93 = !DILocation(line: 43, column: 10, scope: !83)
!94 = !DILocation(line: 43, column: 8, scope: !83)
!95 = !DILocation(line: 44, column: 5, scope: !83)
!96 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 47, type: !97, scopeLine: 48, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!97 = !DISubroutineType(types: !98)
!98 = !{!23}
!99 = !DILocalVariable(name: "thread1", scope: !96, file: !20, line: 49, type: !46)
!100 = !DILocation(line: 49, column: 15, scope: !96)
!101 = !DILocalVariable(name: "thread2", scope: !96, file: !20, line: 49, type: !46)
!102 = !DILocation(line: 49, column: 24, scope: !96)
!103 = !DILocation(line: 51, column: 5, scope: !96)
!104 = !DILocation(line: 52, column: 5, scope: !96)
!105 = !DILocation(line: 53, column: 18, scope: !96)
!106 = !DILocation(line: 53, column: 5, scope: !96)
!107 = !DILocation(line: 54, column: 18, scope: !96)
!108 = !DILocation(line: 54, column: 5, scope: !96)
!109 = !DILocation(line: 56, column: 24, scope: !96)
!110 = !DILocation(line: 56, column: 27, scope: !96)
!111 = !DILocation(line: 56, column: 32, scope: !96)
!112 = !DILocation(line: 56, column: 10, scope: !96)
!113 = !DILocalVariable(name: "reorder_bx", scope: !96, file: !20, line: 56, type: !114)
!114 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!115 = !DILocation(line: 0, scope: !96)
!116 = !DILocation(line: 57, column: 24, scope: !96)
!117 = !DILocation(line: 57, column: 27, scope: !96)
!118 = !DILocation(line: 57, column: 32, scope: !96)
!119 = !DILocation(line: 57, column: 10, scope: !96)
!120 = !DILocalVariable(name: "reorder_ya", scope: !96, file: !20, line: 57, type: !114)
!121 = !DILocation(line: 58, column: 9, scope: !122)
!122 = distinct !DILexicalBlock(scope: !96, file: !20, line: 58, column: 9)
!123 = !DILocation(line: 58, column: 12, scope: !122)
!124 = !DILocation(line: 58, column: 17, scope: !122)
!125 = !DILocation(line: 59, column: 9, scope: !126)
!126 = distinct !DILexicalBlock(scope: !127, file: !20, line: 59, column: 9)
!127 = distinct !DILexicalBlock(scope: !128, file: !20, line: 59, column: 9)
!128 = distinct !DILexicalBlock(scope: !122, file: !20, line: 58, column: 29)
!129 = !DILocation(line: 62, column: 5, scope: !96)
