; ModuleID = '/home/ponce/git/Dat3M/output/paper-E3.8-alt.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/imm/paper-E3.8-alt.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !18
@a = dso_local global i32 0, align 4, !dbg !24
@b = dso_local global i32 0, align 4, !dbg !26
@c = dso_local global i32 0, align 4, !dbg !28
@d = dso_local global i32 0, align 4, !dbg !30
@.str = private unnamed_addr constant [40 x i8] c"!(a == 1 && b == 0 && c == 1 && d == 0)\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/ponce/git/Dat3M/benchmarks/imm/paper-E3.8-alt.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !40 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !44, metadata !DIExpression()), !dbg !45
  %2 = load atomic i32, i32* @x acquire, align 4, !dbg !46
  call void @llvm.dbg.value(metadata i32 %2, metadata !47, metadata !DIExpression()), !dbg !45
  %3 = load atomic i32, i32* @y acquire, align 4, !dbg !48
  call void @llvm.dbg.value(metadata i32 %3, metadata !49, metadata !DIExpression()), !dbg !45
  fence seq_cst, !dbg !50
  store i32 %2, i32* @a, align 4, !dbg !51
  store i32 %3, i32* @b, align 4, !dbg !52
  ret i8* null, !dbg !53
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !54 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !55, metadata !DIExpression()), !dbg !56
  store atomic i32 1, i32* @x release, align 4, !dbg !57
  ret i8* null, !dbg !58
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_3(i8* noundef %0) #0 !dbg !59 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !60, metadata !DIExpression()), !dbg !61
  store atomic i32 1, i32* @y release, align 4, !dbg !62
  ret i8* null, !dbg !63
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_4(i8* noundef %0) #0 !dbg !64 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !65, metadata !DIExpression()), !dbg !66
  %2 = load atomic i32, i32* @y acquire, align 4, !dbg !67
  call void @llvm.dbg.value(metadata i32 %2, metadata !68, metadata !DIExpression()), !dbg !66
  %3 = load atomic i32, i32* @x acquire, align 4, !dbg !69
  call void @llvm.dbg.value(metadata i32 %3, metadata !70, metadata !DIExpression()), !dbg !66
  fence seq_cst, !dbg !71
  store i32 %2, i32* @c, align 4, !dbg !72
  store i32 %3, i32* @d, align 4, !dbg !73
  ret i8* null, !dbg !74
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !75 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !78, metadata !DIExpression(DW_OP_deref)), !dbg !82
  %5 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #5, !dbg !83
  call void @llvm.dbg.value(metadata i64* %2, metadata !84, metadata !DIExpression(DW_OP_deref)), !dbg !82
  %6 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #5, !dbg !85
  call void @llvm.dbg.value(metadata i64* %3, metadata !86, metadata !DIExpression(DW_OP_deref)), !dbg !82
  %7 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_3, i8* noundef null) #5, !dbg !87
  call void @llvm.dbg.value(metadata i64* %4, metadata !88, metadata !DIExpression(DW_OP_deref)), !dbg !82
  %8 = call i32 @pthread_create(i64* noundef nonnull %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_4, i8* noundef null) #5, !dbg !89
  %9 = load i64, i64* %1, align 8, !dbg !90
  call void @llvm.dbg.value(metadata i64 %9, metadata !78, metadata !DIExpression()), !dbg !82
  %10 = call i32 @pthread_join(i64 noundef %9, i8** noundef null) #5, !dbg !91
  %11 = load i64, i64* %2, align 8, !dbg !92
  call void @llvm.dbg.value(metadata i64 %11, metadata !84, metadata !DIExpression()), !dbg !82
  %12 = call i32 @pthread_join(i64 noundef %11, i8** noundef null) #5, !dbg !93
  %13 = load i64, i64* %3, align 8, !dbg !94
  call void @llvm.dbg.value(metadata i64 %13, metadata !86, metadata !DIExpression()), !dbg !82
  %14 = call i32 @pthread_join(i64 noundef %13, i8** noundef null) #5, !dbg !95
  %15 = load i64, i64* %4, align 8, !dbg !96
  call void @llvm.dbg.value(metadata i64 %15, metadata !88, metadata !DIExpression()), !dbg !82
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null) #5, !dbg !97
  %17 = load i32, i32* @a, align 4, !dbg !98
  %18 = icmp eq i32 %17, 1, !dbg !98
  %19 = load i32, i32* @b, align 4, !dbg !98
  %20 = icmp eq i32 %19, 0, !dbg !98
  %or.cond = select i1 %18, i1 %20, i1 false, !dbg !98
  %21 = load i32, i32* @c, align 4, !dbg !98
  %22 = icmp eq i32 %21, 1, !dbg !98
  %or.cond3 = select i1 %or.cond, i1 %22, i1 false, !dbg !98
  %23 = load i32, i32* @d, align 4, !dbg !98
  %24 = icmp eq i32 %23, 0, !dbg !98
  %or.cond5 = select i1 %or.cond3, i1 %24, i1 false, !dbg !98
  br i1 %or.cond5, label %25, label %26, !dbg !98

25:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 56, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !98
  unreachable, !dbg !98

26:                                               ; preds = %0
  ret i32 0, !dbg !101
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
!llvm.module.flags = !{!32, !33, !34, !35, !36, !37, !38}
!llvm.ident = !{!39}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !20, line: 6, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/imm/paper-E3.8-alt.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "06810654a93cc67931a7a3c0a090a0d2")
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
!17 = !{!0, !18, !24, !26, !28, !30}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !20, line: 6, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/imm/paper-E3.8-alt.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "06810654a93cc67931a7a3c0a090a0d2")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "d", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!32 = !{i32 7, !"Dwarf Version", i32 5}
!33 = !{i32 2, !"Debug Info Version", i32 3}
!34 = !{i32 1, !"wchar_size", i32 4}
!35 = !{i32 7, !"PIC Level", i32 2}
!36 = !{i32 7, !"PIE Level", i32 2}
!37 = !{i32 7, !"uwtable", i32 1}
!38 = !{i32 7, !"frame-pointer", i32 2}
!39 = !{!"Ubuntu clang version 14.0.6"}
!40 = distinct !DISubprogram(name: "thread_1", scope: !20, file: !20, line: 10, type: !41, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!41 = !DISubroutineType(types: !42)
!42 = !{!16, !16}
!43 = !{}
!44 = !DILocalVariable(name: "unused", arg: 1, scope: !40, file: !20, line: 10, type: !16)
!45 = !DILocation(line: 0, scope: !40)
!46 = !DILocation(line: 12, column: 11, scope: !40)
!47 = !DILocalVariable(name: "r0", scope: !40, file: !20, line: 12, type: !23)
!48 = !DILocation(line: 13, column: 11, scope: !40)
!49 = !DILocalVariable(name: "r1", scope: !40, file: !20, line: 13, type: !23)
!50 = !DILocation(line: 14, column: 2, scope: !40)
!51 = !DILocation(line: 15, column: 4, scope: !40)
!52 = !DILocation(line: 16, column: 4, scope: !40)
!53 = !DILocation(line: 17, column: 2, scope: !40)
!54 = distinct !DISubprogram(name: "thread_2", scope: !20, file: !20, line: 20, type: !41, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!55 = !DILocalVariable(name: "unused", arg: 1, scope: !54, file: !20, line: 20, type: !16)
!56 = !DILocation(line: 0, scope: !54)
!57 = !DILocation(line: 22, column: 2, scope: !54)
!58 = !DILocation(line: 23, column: 2, scope: !54)
!59 = distinct !DISubprogram(name: "thread_3", scope: !20, file: !20, line: 26, type: !41, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!60 = !DILocalVariable(name: "unused", arg: 1, scope: !59, file: !20, line: 26, type: !16)
!61 = !DILocation(line: 0, scope: !59)
!62 = !DILocation(line: 28, column: 2, scope: !59)
!63 = !DILocation(line: 29, column: 2, scope: !59)
!64 = distinct !DISubprogram(name: "thread_4", scope: !20, file: !20, line: 32, type: !41, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!65 = !DILocalVariable(name: "unused", arg: 1, scope: !64, file: !20, line: 32, type: !16)
!66 = !DILocation(line: 0, scope: !64)
!67 = !DILocation(line: 34, column: 11, scope: !64)
!68 = !DILocalVariable(name: "r0", scope: !64, file: !20, line: 34, type: !23)
!69 = !DILocation(line: 35, column: 11, scope: !64)
!70 = !DILocalVariable(name: "r1", scope: !64, file: !20, line: 35, type: !23)
!71 = !DILocation(line: 36, column: 2, scope: !64)
!72 = !DILocation(line: 37, column: 4, scope: !64)
!73 = !DILocation(line: 38, column: 4, scope: !64)
!74 = !DILocation(line: 39, column: 2, scope: !64)
!75 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 42, type: !76, scopeLine: 43, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!76 = !DISubroutineType(types: !77)
!77 = !{!23}
!78 = !DILocalVariable(name: "t1", scope: !75, file: !20, line: 44, type: !79)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !80, line: 27, baseType: !81)
!80 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!81 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!82 = !DILocation(line: 0, scope: !75)
!83 = !DILocation(line: 46, column: 2, scope: !75)
!84 = !DILocalVariable(name: "t2", scope: !75, file: !20, line: 44, type: !79)
!85 = !DILocation(line: 47, column: 2, scope: !75)
!86 = !DILocalVariable(name: "t3", scope: !75, file: !20, line: 44, type: !79)
!87 = !DILocation(line: 48, column: 2, scope: !75)
!88 = !DILocalVariable(name: "t4", scope: !75, file: !20, line: 44, type: !79)
!89 = !DILocation(line: 49, column: 2, scope: !75)
!90 = !DILocation(line: 51, column: 15, scope: !75)
!91 = !DILocation(line: 51, column: 2, scope: !75)
!92 = !DILocation(line: 52, column: 15, scope: !75)
!93 = !DILocation(line: 52, column: 2, scope: !75)
!94 = !DILocation(line: 53, column: 15, scope: !75)
!95 = !DILocation(line: 53, column: 2, scope: !75)
!96 = !DILocation(line: 54, column: 15, scope: !75)
!97 = !DILocation(line: 54, column: 2, scope: !75)
!98 = !DILocation(line: 56, column: 2, scope: !99)
!99 = distinct !DILexicalBlock(scope: !100, file: !20, line: 56, column: 2)
!100 = distinct !DILexicalBlock(scope: !75, file: !20, line: 56, column: 2)
!101 = !DILocation(line: 58, column: 2, scope: !75)
