; ModuleID = '/home/ponce/git/Dat3M/output/C-WWC+o-branch-o+o-branch-o.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/C-WWC+o-branch-o+o-branch-o.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@r1_0 = dso_local global i32 0, align 4, !dbg !34
@r3_0 = dso_local global i32 0, align 4, !dbg !36
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !26
@r2_1 = dso_local global i32 0, align 4, !dbg !38
@r4_1 = dso_local global i32 0, align 4, !dbg !40
@.str = private unnamed_addr constant [47 x i8] c"!(r1_0 == 2 && r2_1 == 1 && READ_ONCE(x) == 2)\00", align 1
@.str.1 = private unnamed_addr constant [68 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/C-WWC+o-branch-o+o-branch-o.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !50 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !54, metadata !DIExpression()), !dbg !55
  %2 = call i32 @__LKMM_LOAD(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @x, i64 0, i32 0), i32 noundef 1) #5, !dbg !56
  store i32 %2, i32* @r1_0, align 4, !dbg !57
  %3 = icmp ne i32 %2, 0, !dbg !58
  %4 = zext i1 %3 to i32, !dbg !58
  store i32 %4, i32* @r3_0, align 4, !dbg !59
  br i1 %3, label %5, label %6, !dbg !60

5:                                                ; preds = %1
  call void @__LKMM_STORE(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @y, i64 0, i32 0), i32 noundef 1, i32 noundef 1) #5, !dbg !61
  br label %6, !dbg !64

6:                                                ; preds = %5, %1
  ret i8* undef, !dbg !65
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @__LKMM_LOAD(i32* noundef, i32 noundef) #2

declare void @__LKMM_STORE(i32* noundef, i32 noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !66 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !67, metadata !DIExpression()), !dbg !68
  %2 = call i32 @__LKMM_LOAD(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @y, i64 0, i32 0), i32 noundef 1) #5, !dbg !69
  store i32 %2, i32* @r2_1, align 4, !dbg !70
  %3 = icmp ne i32 %2, 0, !dbg !71
  %4 = zext i1 %3 to i32, !dbg !71
  store i32 %4, i32* @r4_1, align 4, !dbg !72
  br i1 %3, label %5, label %6, !dbg !73

5:                                                ; preds = %1
  call void @__LKMM_STORE(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @x, i64 0, i32 0), i32 noundef 1, i32 noundef 1) #5, !dbg !74
  br label %6, !dbg !77

6:                                                ; preds = %5, %1
  ret i8* undef, !dbg !78
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_3(i8* noundef %0) #0 !dbg !79 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !80, metadata !DIExpression()), !dbg !81
  call void @__LKMM_STORE(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @x, i64 0, i32 0), i32 noundef 2, i32 noundef 1) #5, !dbg !82
  ret i8* undef, !dbg !83
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !84 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !87, metadata !DIExpression(DW_OP_deref)), !dbg !91
  %4 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #5, !dbg !92
  call void @llvm.dbg.value(metadata i64* %2, metadata !93, metadata !DIExpression(DW_OP_deref)), !dbg !91
  %5 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #5, !dbg !94
  call void @llvm.dbg.value(metadata i64* %3, metadata !95, metadata !DIExpression(DW_OP_deref)), !dbg !91
  %6 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_3, i8* noundef null) #5, !dbg !96
  %7 = load i64, i64* %1, align 8, !dbg !97
  call void @llvm.dbg.value(metadata i64 %7, metadata !87, metadata !DIExpression()), !dbg !91
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #5, !dbg !98
  %9 = load i64, i64* %2, align 8, !dbg !99
  call void @llvm.dbg.value(metadata i64 %9, metadata !93, metadata !DIExpression()), !dbg !91
  %10 = call i32 @pthread_join(i64 noundef %9, i8** noundef null) #5, !dbg !100
  %11 = load i64, i64* %3, align 8, !dbg !101
  call void @llvm.dbg.value(metadata i64 %11, metadata !95, metadata !DIExpression()), !dbg !91
  %12 = call i32 @pthread_join(i64 noundef %11, i8** noundef null) #5, !dbg !102
  %13 = load i32, i32* @r1_0, align 4, !dbg !103
  %14 = icmp eq i32 %13, 2, !dbg !103
  %15 = load i32, i32* @r2_1, align 4, !dbg !103
  %16 = icmp eq i32 %15, 1, !dbg !103
  %or.cond = select i1 %14, i1 %16, i1 false, !dbg !103
  br i1 %or.cond, label %17, label %21, !dbg !103

17:                                               ; preds = %0
  %18 = call i32 @__LKMM_LOAD(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @x, i64 0, i32 0), i32 noundef 1) #5, !dbg !103
  %19 = icmp eq i32 %18, 2, !dbg !103
  br i1 %19, label %20, label %21, !dbg !106

20:                                               ; preds = %17
  call void @__assert_fail(i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 50, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !103
  unreachable, !dbg !103

21:                                               ; preds = %0, %17
  ret i32 0, !dbg !107
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

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
!llvm.module.flags = !{!42, !43, !44, !45, !46, !47, !48}
!llvm.ident = !{!49}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !28, line: 6, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/C-WWC+o-branch-o+o-branch-o.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "7b3249141ee3b3ebbd8464920a466ae8")
!4 = !{!5}
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
!23 = !{!24}
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!25 = !{!0, !26, !34, !36, !38, !40}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/lkmm/C-WWC+o-branch-o+o-branch-o.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "7b3249141ee3b3ebbd8464920a466ae8")
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 95, baseType: !30)
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 93, size: 32, elements: !31)
!31 = !{!32}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !30, file: !6, line: 94, baseType: !33, size: 32)
!33 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "r1_0", scope: !2, file: !28, line: 9, type: !33, isLocal: false, isDefinition: true)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "r3_0", scope: !2, file: !28, line: 10, type: !33, isLocal: false, isDefinition: true)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "r2_1", scope: !2, file: !28, line: 12, type: !33, isLocal: false, isDefinition: true)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "r4_1", scope: !2, file: !28, line: 13, type: !33, isLocal: false, isDefinition: true)
!42 = !{i32 7, !"Dwarf Version", i32 5}
!43 = !{i32 2, !"Debug Info Version", i32 3}
!44 = !{i32 1, !"wchar_size", i32 4}
!45 = !{i32 7, !"PIC Level", i32 2}
!46 = !{i32 7, !"PIE Level", i32 2}
!47 = !{i32 7, !"uwtable", i32 1}
!48 = !{i32 7, !"frame-pointer", i32 2}
!49 = !{!"Ubuntu clang version 14.0.6"}
!50 = distinct !DISubprogram(name: "thread_1", scope: !28, file: !28, line: 15, type: !51, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!51 = !DISubroutineType(types: !52)
!52 = !{!24, !24}
!53 = !{}
!54 = !DILocalVariable(name: "unused", arg: 1, scope: !50, file: !28, line: 15, type: !24)
!55 = !DILocation(line: 0, scope: !50)
!56 = !DILocation(line: 17, column: 9, scope: !50)
!57 = !DILocation(line: 17, column: 7, scope: !50)
!58 = !DILocation(line: 18, column: 15, scope: !50)
!59 = !DILocation(line: 18, column: 7, scope: !50)
!60 = !DILocation(line: 19, column: 6, scope: !50)
!61 = !DILocation(line: 20, column: 3, scope: !62)
!62 = distinct !DILexicalBlock(scope: !63, file: !28, line: 19, column: 12)
!63 = distinct !DILexicalBlock(scope: !50, file: !28, line: 19, column: 6)
!64 = !DILocation(line: 21, column: 2, scope: !62)
!65 = !DILocation(line: 22, column: 1, scope: !50)
!66 = distinct !DISubprogram(name: "thread_2", scope: !28, file: !28, line: 24, type: !51, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!67 = !DILocalVariable(name: "unused", arg: 1, scope: !66, file: !28, line: 24, type: !24)
!68 = !DILocation(line: 0, scope: !66)
!69 = !DILocation(line: 26, column: 9, scope: !66)
!70 = !DILocation(line: 26, column: 7, scope: !66)
!71 = !DILocation(line: 27, column: 15, scope: !66)
!72 = !DILocation(line: 27, column: 7, scope: !66)
!73 = !DILocation(line: 28, column: 6, scope: !66)
!74 = !DILocation(line: 29, column: 3, scope: !75)
!75 = distinct !DILexicalBlock(scope: !76, file: !28, line: 28, column: 12)
!76 = distinct !DILexicalBlock(scope: !66, file: !28, line: 28, column: 6)
!77 = !DILocation(line: 30, column: 2, scope: !75)
!78 = !DILocation(line: 31, column: 1, scope: !66)
!79 = distinct !DISubprogram(name: "thread_3", scope: !28, file: !28, line: 33, type: !51, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!80 = !DILocalVariable(name: "unused", arg: 1, scope: !79, file: !28, line: 33, type: !24)
!81 = !DILocation(line: 0, scope: !79)
!82 = !DILocation(line: 35, column: 2, scope: !79)
!83 = !DILocation(line: 36, column: 1, scope: !79)
!84 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 38, type: !85, scopeLine: 39, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!85 = !DISubroutineType(types: !86)
!86 = !{!33}
!87 = !DILocalVariable(name: "t1", scope: !84, file: !28, line: 40, type: !88)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !89, line: 27, baseType: !90)
!89 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!90 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!91 = !DILocation(line: 0, scope: !84)
!92 = !DILocation(line: 42, column: 2, scope: !84)
!93 = !DILocalVariable(name: "t2", scope: !84, file: !28, line: 40, type: !88)
!94 = !DILocation(line: 43, column: 2, scope: !84)
!95 = !DILocalVariable(name: "t3", scope: !84, file: !28, line: 40, type: !88)
!96 = !DILocation(line: 44, column: 2, scope: !84)
!97 = !DILocation(line: 46, column: 15, scope: !84)
!98 = !DILocation(line: 46, column: 2, scope: !84)
!99 = !DILocation(line: 47, column: 15, scope: !84)
!100 = !DILocation(line: 47, column: 2, scope: !84)
!101 = !DILocation(line: 48, column: 15, scope: !84)
!102 = !DILocation(line: 48, column: 2, scope: !84)
!103 = !DILocation(line: 50, column: 2, scope: !104)
!104 = distinct !DILexicalBlock(scope: !105, file: !28, line: 50, column: 2)
!105 = distinct !DILexicalBlock(scope: !84, file: !28, line: 50, column: 2)
!106 = !DILocation(line: 50, column: 2, scope: !105)
!107 = !DILocation(line: 52, column: 2, scope: !84)
