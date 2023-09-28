; ModuleID = '/home/ponce/git/Dat3M/output/paper-E3.9.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/imm/paper-E3.9.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@y = dso_local global i32 0, align 4, !dbg !0
@z = dso_local global i32 0, align 4, !dbg !24
@a = dso_local global i32 0, align 4, !dbg !26
@b = dso_local global i32 0, align 4, !dbg !28
@x = dso_local global i32 0, align 4, !dbg !18
@d = dso_local global i32 0, align 4, !dbg !32
@.str = private unnamed_addr constant [30 x i8] c"!(a == 1 && b == 0 && d == 1)\00", align 1
@.str.1 = private unnamed_addr constant [50 x i8] c"/home/ponce/git/Dat3M/benchmarks/imm/paper-E3.9.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@c = dso_local global i32 0, align 4, !dbg !30

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !42 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !46, metadata !DIExpression()), !dbg !47
  %2 = load atomic i32, i32* @y monotonic, align 4, !dbg !48
  call void @llvm.dbg.value(metadata i32 %2, metadata !49, metadata !DIExpression()), !dbg !47
  fence seq_cst, !dbg !50
  %3 = load atomic i32, i32* @z monotonic, align 4, !dbg !51
  call void @llvm.dbg.value(metadata i32 %3, metadata !52, metadata !DIExpression()), !dbg !47
  fence seq_cst, !dbg !53
  store i32 %2, i32* @a, align 4, !dbg !54
  store i32 %3, i32* @b, align 4, !dbg !55
  ret i8* null, !dbg !56
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !57 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !58, metadata !DIExpression()), !dbg !59
  store atomic i32 1, i32* @z monotonic, align 4, !dbg !60
  fence seq_cst, !dbg !61
  store atomic i32 1, i32* @x monotonic, align 4, !dbg !62
  ret i8* null, !dbg !63
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_3(i8* noundef %0) #0 !dbg !64 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !65, metadata !DIExpression()), !dbg !66
  %2 = load atomic i32, i32* @x monotonic, align 4, !dbg !67
  call void @llvm.dbg.value(metadata i32 %2, metadata !68, metadata !DIExpression()), !dbg !66
  %.not = icmp eq i32 %2, 0, !dbg !69
  br i1 %.not, label %4, label %3, !dbg !71

3:                                                ; preds = %1
  store atomic i32 1, i32* @y monotonic, align 4, !dbg !72
  br label %4, !dbg !74

4:                                                ; preds = %3, %1
  fence seq_cst, !dbg !75
  store i32 %2, i32* @d, align 4, !dbg !76
  ret i8* null, !dbg !77
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !78 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !81, metadata !DIExpression(DW_OP_deref)), !dbg !85
  %4 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #5, !dbg !86
  call void @llvm.dbg.value(metadata i64* %2, metadata !87, metadata !DIExpression(DW_OP_deref)), !dbg !85
  %5 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #5, !dbg !88
  call void @llvm.dbg.value(metadata i64* %3, metadata !89, metadata !DIExpression(DW_OP_deref)), !dbg !85
  %6 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_3, i8* noundef null) #5, !dbg !90
  %7 = load i64, i64* %1, align 8, !dbg !91
  call void @llvm.dbg.value(metadata i64 %7, metadata !81, metadata !DIExpression()), !dbg !85
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #5, !dbg !92
  %9 = load i64, i64* %2, align 8, !dbg !93
  call void @llvm.dbg.value(metadata i64 %9, metadata !87, metadata !DIExpression()), !dbg !85
  %10 = call i32 @pthread_join(i64 noundef %9, i8** noundef null) #5, !dbg !94
  %11 = load i64, i64* %3, align 8, !dbg !95
  call void @llvm.dbg.value(metadata i64 %11, metadata !89, metadata !DIExpression()), !dbg !85
  %12 = call i32 @pthread_join(i64 noundef %11, i8** noundef null) #5, !dbg !96
  %13 = load i32, i32* @a, align 4, !dbg !97
  %14 = icmp eq i32 %13, 1, !dbg !97
  %15 = load i32, i32* @b, align 4, !dbg !97
  %16 = icmp eq i32 %15, 0, !dbg !97
  %or.cond = select i1 %14, i1 %16, i1 false, !dbg !97
  %17 = load i32, i32* @d, align 4, !dbg !97
  %18 = icmp eq i32 %17, 1, !dbg !97
  %or.cond3 = select i1 %or.cond, i1 %18, i1 false, !dbg !97
  br i1 %or.cond3, label %19, label %20, !dbg !97

19:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @.str.1, i64 0, i64 0), i32 noundef 52, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !97
  unreachable, !dbg !97

20:                                               ; preds = %0
  ret i32 0, !dbg !100
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!34, !35, !36, !37, !38, !39, !40}
!llvm.ident = !{!41}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !20, line: 6, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/imm/paper-E3.9.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "0135264016ee827212d1a45f1540a9e9")
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
!17 = !{!18, !0, !24, !26, !28, !30, !32}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !20, line: 6, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/imm/paper-E3.9.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "0135264016ee827212d1a45f1540a9e9")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !20, line: 6, type: !21, isLocal: false, isDefinition: true)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "d", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!34 = !{i32 7, !"Dwarf Version", i32 5}
!35 = !{i32 2, !"Debug Info Version", i32 3}
!36 = !{i32 1, !"wchar_size", i32 4}
!37 = !{i32 7, !"PIC Level", i32 2}
!38 = !{i32 7, !"PIE Level", i32 2}
!39 = !{i32 7, !"uwtable", i32 1}
!40 = !{i32 7, !"frame-pointer", i32 2}
!41 = !{!"Ubuntu clang version 14.0.6"}
!42 = distinct !DISubprogram(name: "thread_1", scope: !20, file: !20, line: 10, type: !43, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!43 = !DISubroutineType(types: !44)
!44 = !{!16, !16}
!45 = !{}
!46 = !DILocalVariable(name: "unused", arg: 1, scope: !42, file: !20, line: 10, type: !16)
!47 = !DILocation(line: 0, scope: !42)
!48 = !DILocation(line: 12, column: 11, scope: !42)
!49 = !DILocalVariable(name: "r0", scope: !42, file: !20, line: 12, type: !23)
!50 = !DILocation(line: 13, column: 2, scope: !42)
!51 = !DILocation(line: 14, column: 11, scope: !42)
!52 = !DILocalVariable(name: "r1", scope: !42, file: !20, line: 14, type: !23)
!53 = !DILocation(line: 15, column: 2, scope: !42)
!54 = !DILocation(line: 16, column: 4, scope: !42)
!55 = !DILocation(line: 17, column: 4, scope: !42)
!56 = !DILocation(line: 18, column: 2, scope: !42)
!57 = distinct !DISubprogram(name: "thread_2", scope: !20, file: !20, line: 21, type: !43, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!58 = !DILocalVariable(name: "unused", arg: 1, scope: !57, file: !20, line: 21, type: !16)
!59 = !DILocation(line: 0, scope: !57)
!60 = !DILocation(line: 23, column: 2, scope: !57)
!61 = !DILocation(line: 24, column: 2, scope: !57)
!62 = !DILocation(line: 25, column: 2, scope: !57)
!63 = !DILocation(line: 26, column: 2, scope: !57)
!64 = distinct !DISubprogram(name: "thread_3", scope: !20, file: !20, line: 29, type: !43, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!65 = !DILocalVariable(name: "unused", arg: 1, scope: !64, file: !20, line: 29, type: !16)
!66 = !DILocation(line: 0, scope: !64)
!67 = !DILocation(line: 31, column: 11, scope: !64)
!68 = !DILocalVariable(name: "r0", scope: !64, file: !20, line: 31, type: !23)
!69 = !DILocation(line: 32, column: 9, scope: !70)
!70 = distinct !DILexicalBlock(scope: !64, file: !20, line: 32, column: 6)
!71 = !DILocation(line: 32, column: 6, scope: !64)
!72 = !DILocation(line: 33, column: 3, scope: !73)
!73 = distinct !DILexicalBlock(scope: !70, file: !20, line: 32, column: 15)
!74 = !DILocation(line: 34, column: 2, scope: !73)
!75 = !DILocation(line: 35, column: 2, scope: !64)
!76 = !DILocation(line: 36, column: 4, scope: !64)
!77 = !DILocation(line: 37, column: 2, scope: !64)
!78 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 40, type: !79, scopeLine: 41, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!79 = !DISubroutineType(types: !80)
!80 = !{!23}
!81 = !DILocalVariable(name: "t1", scope: !78, file: !20, line: 42, type: !82)
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !83, line: 27, baseType: !84)
!83 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!84 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!85 = !DILocation(line: 0, scope: !78)
!86 = !DILocation(line: 44, column: 2, scope: !78)
!87 = !DILocalVariable(name: "t2", scope: !78, file: !20, line: 42, type: !82)
!88 = !DILocation(line: 45, column: 2, scope: !78)
!89 = !DILocalVariable(name: "t3", scope: !78, file: !20, line: 42, type: !82)
!90 = !DILocation(line: 46, column: 2, scope: !78)
!91 = !DILocation(line: 48, column: 15, scope: !78)
!92 = !DILocation(line: 48, column: 2, scope: !78)
!93 = !DILocation(line: 49, column: 15, scope: !78)
!94 = !DILocation(line: 49, column: 2, scope: !78)
!95 = !DILocation(line: 50, column: 15, scope: !78)
!96 = !DILocation(line: 50, column: 2, scope: !78)
!97 = !DILocation(line: 52, column: 2, scope: !98)
!98 = distinct !DILexicalBlock(scope: !99, file: !20, line: 52, column: 2)
!99 = distinct !DILexicalBlock(scope: !78, file: !20, line: 52, column: 2)
!100 = !DILocation(line: 54, column: 2, scope: !78)
