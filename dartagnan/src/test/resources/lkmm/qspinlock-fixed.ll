; ModuleID = '/home/ponce/git/Dat3M/output/qspinlock-fixed.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/qspinlock-fixed.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !32
@.str = private unnamed_addr constant [18 x i8] c"READ_ONCE(x) == 1\00", align 1
@.str.1 = private unnamed_addr constant [56 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/qspinlock-fixed.c\00", align 1
@__PRETTY_FUNCTION__.thread_3 = private unnamed_addr constant [23 x i8] c"void *thread_3(void *)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !48 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !52, metadata !DIExpression()), !dbg !53
  call void @__LKMM_STORE(i32* noundef nonnull @x, i32 noundef 1, i32 noundef 1) #5, !dbg !54
  call void @__LKMM_STORE(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @y, i64 0, i32 0), i32 noundef 1, i32 noundef 3) #5, !dbg !55
  ret i8* null, !dbg !56
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_STORE(i32* noundef, i32 noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !57 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !58, metadata !DIExpression()), !dbg !59
  %2 = call i32 @__LKMM_ATOMIC_FETCH_OP(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @y, i64 0, i32 0), i32 noundef 2, i32 noundef 3, i32 noundef 3) #5, !dbg !60
  ret i8* null, !dbg !61
}

declare i32 @__LKMM_ATOMIC_FETCH_OP(i32* noundef, i32 noundef, i32 noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_3(i8* noundef %0) #0 !dbg !62 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !63, metadata !DIExpression()), !dbg !64
  %2 = call i32 @__LKMM_LOAD(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @y, i64 0, i32 0), i32 noundef 1) #5, !dbg !65
  %3 = and i32 %2, 1, !dbg !67
  %.not = icmp eq i32 %3, 0, !dbg !67
  br i1 %.not, label %8, label %4, !dbg !68

4:                                                ; preds = %1
  call void @__LKMM_FENCE(i32 noundef 6) #5, !dbg !69
  %5 = call i32 @__LKMM_LOAD(i32* noundef nonnull @x, i32 noundef 1) #5, !dbg !71
  %6 = icmp eq i32 %5, 1, !dbg !71
  br i1 %6, label %8, label %7, !dbg !74

7:                                                ; preds = %4
  call void @__assert_fail(i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([56 x i8], [56 x i8]* @.str.1, i64 0, i64 0), i32 noundef 26, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_3, i64 0, i64 0)) #6, !dbg !71
  unreachable, !dbg !71

8:                                                ; preds = %4, %1
  ret i8* null, !dbg !75
}

declare i32 @__LKMM_LOAD(i32* noundef, i32 noundef) #2

declare void @__LKMM_FENCE(i32 noundef) #2

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !76 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !79, metadata !DIExpression(DW_OP_deref)), !dbg !83
  %4 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #5, !dbg !84
  call void @llvm.dbg.value(metadata i64* %2, metadata !86, metadata !DIExpression(DW_OP_deref)), !dbg !83
  %5 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #5, !dbg !87
  call void @llvm.dbg.value(metadata i64* %3, metadata !89, metadata !DIExpression(DW_OP_deref)), !dbg !83
  %6 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_3, i8* noundef null) #5, !dbg !90
  %7 = load i64, i64* %1, align 8, !dbg !92
  call void @llvm.dbg.value(metadata i64 %7, metadata !79, metadata !DIExpression()), !dbg !83
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #5, !dbg !94
  %9 = load i64, i64* %2, align 8, !dbg !95
  call void @llvm.dbg.value(metadata i64 %9, metadata !86, metadata !DIExpression()), !dbg !83
  %10 = call i32 @pthread_join(i64 noundef %9, i8** noundef null) #5, !dbg !97
  %11 = load i64, i64* %3, align 8, !dbg !98
  call void @llvm.dbg.value(metadata i64 %11, metadata !89, metadata !DIExpression()), !dbg !83
  %12 = call i32 @pthread_join(i64 noundef %11, i8** noundef null) #5, !dbg !100
  ret i32 0, !dbg !101
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #4

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!40, !41, !42, !43, !44, !45, !46}
!llvm.ident = !{!47}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !34, line: 6, type: !39, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !31, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/qspinlock-fixed.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "9c8891057a60b4f7e8d1f9870de01dac")
!4 = !{!5, !23}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "f05598c4633ab3767f78c4bb572c0073")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_once", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "mb", value: 4)
!14 = !DIEnumerator(name: "wmb", value: 5)
!15 = !DIEnumerator(name: "rmb", value: 6)
!16 = !DIEnumerator(name: "rcu_lock", value: 7)
!17 = !DIEnumerator(name: "rcu_unlock", value: 8)
!18 = !DIEnumerator(name: "rcu_sync", value: 9)
!19 = !DIEnumerator(name: "before_atomic", value: 10)
!20 = !DIEnumerator(name: "after_atomic", value: 11)
!21 = !DIEnumerator(name: "after_spinlock", value: 12)
!22 = !DIEnumerator(name: "barrier", value: 13)
!23 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "operation", file: !6, line: 20, baseType: !7, size: 32, elements: !24)
!24 = !{!25, !26, !27, !28}
!25 = !DIEnumerator(name: "op_add", value: 0)
!26 = !DIEnumerator(name: "op_sub", value: 1)
!27 = !DIEnumerator(name: "op_and", value: 2)
!28 = !DIEnumerator(name: "op_or", value: 3)
!29 = !{!30}
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!31 = !{!0, !32}
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !34, line: 7, type: !35, isLocal: false, isDefinition: true)
!34 = !DIFile(filename: "benchmarks/lkmm/qspinlock-fixed.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "9c8891057a60b4f7e8d1f9870de01dac")
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 95, baseType: !36)
!36 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 93, size: 32, elements: !37)
!37 = !{!38}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !36, file: !6, line: 94, baseType: !39, size: 32)
!39 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!40 = !{i32 7, !"Dwarf Version", i32 5}
!41 = !{i32 2, !"Debug Info Version", i32 3}
!42 = !{i32 1, !"wchar_size", i32 4}
!43 = !{i32 7, !"PIC Level", i32 2}
!44 = !{i32 7, !"PIE Level", i32 2}
!45 = !{i32 7, !"uwtable", i32 1}
!46 = !{i32 7, !"frame-pointer", i32 2}
!47 = !{!"Ubuntu clang version 14.0.6"}
!48 = distinct !DISubprogram(name: "thread_1", scope: !34, file: !34, line: 9, type: !49, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!49 = !DISubroutineType(types: !50)
!50 = !{!30, !30}
!51 = !{}
!52 = !DILocalVariable(name: "unused", arg: 1, scope: !48, file: !34, line: 9, type: !30)
!53 = !DILocation(line: 0, scope: !48)
!54 = !DILocation(line: 11, column: 2, scope: !48)
!55 = !DILocation(line: 12, column: 2, scope: !48)
!56 = !DILocation(line: 13, column: 2, scope: !48)
!57 = distinct !DISubprogram(name: "thread_2", scope: !34, file: !34, line: 16, type: !49, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!58 = !DILocalVariable(name: "unused", arg: 1, scope: !57, file: !34, line: 16, type: !30)
!59 = !DILocation(line: 0, scope: !57)
!60 = !DILocation(line: 18, column: 2, scope: !57)
!61 = !DILocation(line: 19, column: 2, scope: !57)
!62 = distinct !DISubprogram(name: "thread_3", scope: !34, file: !34, line: 22, type: !49, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!63 = !DILocalVariable(name: "unused", arg: 1, scope: !62, file: !34, line: 22, type: !30)
!64 = !DILocation(line: 0, scope: !62)
!65 = !DILocation(line: 24, column: 7, scope: !66)
!66 = distinct !DILexicalBlock(scope: !62, file: !34, line: 24, column: 7)
!67 = !DILocation(line: 24, column: 23, scope: !66)
!68 = !DILocation(line: 24, column: 7, scope: !62)
!69 = !DILocation(line: 25, column: 4, scope: !70)
!70 = distinct !DILexicalBlock(scope: !66, file: !34, line: 24, column: 28)
!71 = !DILocation(line: 26, column: 4, scope: !72)
!72 = distinct !DILexicalBlock(scope: !73, file: !34, line: 26, column: 4)
!73 = distinct !DILexicalBlock(scope: !70, file: !34, line: 26, column: 4)
!74 = !DILocation(line: 26, column: 4, scope: !73)
!75 = !DILocation(line: 28, column: 2, scope: !62)
!76 = distinct !DISubprogram(name: "main", scope: !34, file: !34, line: 31, type: !77, scopeLine: 32, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!77 = !DISubroutineType(types: !78)
!78 = !{!39}
!79 = !DILocalVariable(name: "t1", scope: !76, file: !34, line: 33, type: !80)
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !81, line: 27, baseType: !82)
!81 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!82 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!83 = !DILocation(line: 0, scope: !76)
!84 = !DILocation(line: 35, column: 6, scope: !85)
!85 = distinct !DILexicalBlock(scope: !76, file: !34, line: 35, column: 6)
!86 = !DILocalVariable(name: "t2", scope: !76, file: !34, line: 33, type: !80)
!87 = !DILocation(line: 36, column: 6, scope: !88)
!88 = distinct !DILexicalBlock(scope: !76, file: !34, line: 36, column: 6)
!89 = !DILocalVariable(name: "t3", scope: !76, file: !34, line: 33, type: !80)
!90 = !DILocation(line: 37, column: 6, scope: !91)
!91 = distinct !DILexicalBlock(scope: !76, file: !34, line: 37, column: 6)
!92 = !DILocation(line: 39, column: 19, scope: !93)
!93 = distinct !DILexicalBlock(scope: !76, file: !34, line: 39, column: 6)
!94 = !DILocation(line: 39, column: 6, scope: !93)
!95 = !DILocation(line: 40, column: 19, scope: !96)
!96 = distinct !DILexicalBlock(scope: !76, file: !34, line: 40, column: 6)
!97 = !DILocation(line: 40, column: 6, scope: !96)
!98 = !DILocation(line: 41, column: 19, scope: !99)
!99 = distinct !DILexicalBlock(scope: !76, file: !34, line: 41, column: 6)
!100 = !DILocation(line: 41, column: 6, scope: !99)
!101 = !DILocation(line: 43, column: 2, scope: !76)
