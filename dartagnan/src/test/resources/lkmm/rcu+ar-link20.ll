; ModuleID = '/home/ponce/git/Dat3M/output/rcu+ar-link20.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/rcu+ar-link20.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !26
@r0 = dso_local global i32 0, align 4, !dbg !34
@s = dso_local global i32 0, align 4, !dbg !32
@r2 = dso_local global i32 0, align 4, !dbg !36
@a = dso_local global i32 0, align 4, !dbg !30
@.str = private unnamed_addr constant [42 x i8] c"!(r0 == 1 && r2 == 1 && a == 1 && x == 1)\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/rcu+ar-link20.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@r6 = dso_local global i32 0, align 4, !dbg !38

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P0(i8* noundef %0) #0 !dbg !48 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !52, metadata !DIExpression()), !dbg !53
  call void @__LKMM_FENCE(i32 noundef 7) #5, !dbg !54
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x to i8*), i32 noundef 2, i32 noundef 1) #5, !dbg !55
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1) #5, !dbg !56
  store i32 %2, i32* @r0, align 4, !dbg !57
  call void @__LKMM_FENCE(i32 noundef 8) #5, !dbg !58
  ret i8* null, !dbg !59
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_FENCE(i32 noundef) #2

declare void @__LKMM_STORE(i8* noundef, i32 noundef, i32 noundef) #2

declare i32 @__LKMM_LOAD(i8* noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P1(i8* noundef %0) #0 !dbg !60 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !61, metadata !DIExpression()), !dbg !62
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !63
  call void @__LKMM_FENCE(i32 noundef 4) #5, !dbg !64
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @s to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !65
  ret i8* null, !dbg !66
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P2(i8* noundef %0) #0 !dbg !67 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !68, metadata !DIExpression()), !dbg !69
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @s to i8*), i32 noundef 1) #5, !dbg !70
  call void @llvm.dbg.value(metadata i32 %2, metadata !71, metadata !DIExpression()), !dbg !69
  %.not = icmp eq i32 %2, 0, !dbg !72
  br i1 %.not, label %4, label %3, !dbg !74

3:                                                ; preds = %1
  store i32 %2, i32* @r2, align 4, !dbg !75
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @a to i8*), i32 noundef 2, i32 noundef 1) #5, !dbg !77
  br label %4, !dbg !78

4:                                                ; preds = %3, %1
  ret i8* null, !dbg !79
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P3(i8* noundef %0) #0 !dbg !80 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !81, metadata !DIExpression()), !dbg !82
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @a to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !83
  call void @__LKMM_FENCE(i32 noundef 9) #5, !dbg !84
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !85
  ret i8* null, !dbg !86
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !87 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !90, metadata !DIExpression(DW_OP_deref)), !dbg !94
  %5 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P0, i8* noundef null) #5, !dbg !95
  call void @llvm.dbg.value(metadata i64* %2, metadata !96, metadata !DIExpression(DW_OP_deref)), !dbg !94
  %6 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P1, i8* noundef null) #5, !dbg !97
  call void @llvm.dbg.value(metadata i64* %3, metadata !98, metadata !DIExpression(DW_OP_deref)), !dbg !94
  %7 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P2, i8* noundef null) #5, !dbg !99
  call void @llvm.dbg.value(metadata i64* %4, metadata !100, metadata !DIExpression(DW_OP_deref)), !dbg !94
  %8 = call i32 @pthread_create(i64* noundef nonnull %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P3, i8* noundef null) #5, !dbg !101
  %9 = load i64, i64* %1, align 8, !dbg !102
  call void @llvm.dbg.value(metadata i64 %9, metadata !90, metadata !DIExpression()), !dbg !94
  %10 = call i32 @pthread_join(i64 noundef %9, i8** noundef null) #5, !dbg !103
  %11 = load i64, i64* %2, align 8, !dbg !104
  call void @llvm.dbg.value(metadata i64 %11, metadata !96, metadata !DIExpression()), !dbg !94
  %12 = call i32 @pthread_join(i64 noundef %11, i8** noundef null) #5, !dbg !105
  %13 = load i64, i64* %3, align 8, !dbg !106
  call void @llvm.dbg.value(metadata i64 %13, metadata !98, metadata !DIExpression()), !dbg !94
  %14 = call i32 @pthread_join(i64 noundef %13, i8** noundef null) #5, !dbg !107
  %15 = load i64, i64* %4, align 8, !dbg !108
  call void @llvm.dbg.value(metadata i64 %15, metadata !100, metadata !DIExpression()), !dbg !94
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null) #5, !dbg !109
  %17 = load i32, i32* @r0, align 4, !dbg !110
  %18 = icmp eq i32 %17, 1, !dbg !110
  %19 = load i32, i32* @r2, align 4, !dbg !110
  %20 = icmp eq i32 %19, 1, !dbg !110
  %or.cond = select i1 %18, i1 %20, i1 false, !dbg !110
  %21 = load i32, i32* @a, align 4, !dbg !110
  %22 = icmp eq i32 %21, 1, !dbg !110
  %or.cond3 = select i1 %or.cond, i1 %22, i1 false, !dbg !110
  %23 = load i32, i32* @x, align 4, !dbg !110
  %24 = icmp eq i32 %23, 1, !dbg !110
  %or.cond5 = select i1 %or.cond3, i1 %24, i1 false, !dbg !110
  br i1 %or.cond5, label %25, label %26, !dbg !110

25:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([42 x i8], [42 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 68, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !110
  unreachable, !dbg !110

26:                                               ; preds = %0
  ret i32 0, !dbg !113
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
!llvm.module.flags = !{!40, !41, !42, !43, !44, !45, !46}
!llvm.ident = !{!47}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/rcu+ar-link20.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "04db98ea4c002dca60e5a54977930ea2")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "f219e5a4f2482585588927d06bb5e5c6")
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
!25 = !{!0, !26, !30, !32, !34, !36, !38}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/lkmm/rcu+ar-link20.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "04db98ea4c002dca60e5a54977930ea2")
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !28, line: 9, type: !29, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !28, line: 10, type: !29, isLocal: false, isDefinition: true)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !28, line: 12, type: !29, isLocal: false, isDefinition: true)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "r2", scope: !2, file: !28, line: 13, type: !29, isLocal: false, isDefinition: true)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "r6", scope: !2, file: !28, line: 14, type: !29, isLocal: false, isDefinition: true)
!40 = !{i32 7, !"Dwarf Version", i32 5}
!41 = !{i32 2, !"Debug Info Version", i32 3}
!42 = !{i32 1, !"wchar_size", i32 4}
!43 = !{i32 7, !"PIC Level", i32 2}
!44 = !{i32 7, !"PIE Level", i32 2}
!45 = !{i32 7, !"uwtable", i32 1}
!46 = !{i32 7, !"frame-pointer", i32 2}
!47 = !{!"Ubuntu clang version 14.0.6"}
!48 = distinct !DISubprogram(name: "P0", scope: !28, file: !28, line: 16, type: !49, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!49 = !DISubroutineType(types: !50)
!50 = !{!24, !24}
!51 = !{}
!52 = !DILocalVariable(name: "unused", arg: 1, scope: !48, file: !28, line: 16, type: !24)
!53 = !DILocation(line: 0, scope: !48)
!54 = !DILocation(line: 18, column: 2, scope: !48)
!55 = !DILocation(line: 19, column: 2, scope: !48)
!56 = !DILocation(line: 20, column: 7, scope: !48)
!57 = !DILocation(line: 20, column: 5, scope: !48)
!58 = !DILocation(line: 21, column: 2, scope: !48)
!59 = !DILocation(line: 22, column: 2, scope: !48)
!60 = distinct !DISubprogram(name: "P1", scope: !28, file: !28, line: 25, type: !49, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!61 = !DILocalVariable(name: "unused", arg: 1, scope: !60, file: !28, line: 25, type: !24)
!62 = !DILocation(line: 0, scope: !60)
!63 = !DILocation(line: 27, column: 2, scope: !60)
!64 = !DILocation(line: 28, column: 2, scope: !60)
!65 = !DILocation(line: 29, column: 2, scope: !60)
!66 = !DILocation(line: 30, column: 2, scope: !60)
!67 = distinct !DISubprogram(name: "P2", scope: !28, file: !28, line: 33, type: !49, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!68 = !DILocalVariable(name: "unused", arg: 1, scope: !67, file: !28, line: 33, type: !24)
!69 = !DILocation(line: 0, scope: !67)
!70 = !DILocation(line: 35, column: 10, scope: !67)
!71 = !DILocalVariable(name: "r", scope: !67, file: !28, line: 35, type: !29)
!72 = !DILocation(line: 36, column: 6, scope: !73)
!73 = distinct !DILexicalBlock(scope: !67, file: !28, line: 36, column: 6)
!74 = !DILocation(line: 36, column: 6, scope: !67)
!75 = !DILocation(line: 37, column: 6, scope: !76)
!76 = distinct !DILexicalBlock(scope: !73, file: !28, line: 36, column: 9)
!77 = !DILocation(line: 38, column: 3, scope: !76)
!78 = !DILocation(line: 39, column: 2, scope: !76)
!79 = !DILocation(line: 40, column: 2, scope: !67)
!80 = distinct !DISubprogram(name: "P3", scope: !28, file: !28, line: 43, type: !49, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!81 = !DILocalVariable(name: "unused", arg: 1, scope: !80, file: !28, line: 43, type: !24)
!82 = !DILocation(line: 0, scope: !80)
!83 = !DILocation(line: 45, column: 2, scope: !80)
!84 = !DILocation(line: 46, column: 2, scope: !80)
!85 = !DILocation(line: 47, column: 2, scope: !80)
!86 = !DILocation(line: 48, column: 2, scope: !80)
!87 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 51, type: !88, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!88 = !DISubroutineType(types: !89)
!89 = !{!29}
!90 = !DILocalVariable(name: "t0", scope: !87, file: !28, line: 56, type: !91)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !92, line: 27, baseType: !93)
!92 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!93 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!94 = !DILocation(line: 0, scope: !87)
!95 = !DILocation(line: 58, column: 2, scope: !87)
!96 = !DILocalVariable(name: "t1", scope: !87, file: !28, line: 56, type: !91)
!97 = !DILocation(line: 59, column: 2, scope: !87)
!98 = !DILocalVariable(name: "t2", scope: !87, file: !28, line: 56, type: !91)
!99 = !DILocation(line: 60, column: 2, scope: !87)
!100 = !DILocalVariable(name: "t3", scope: !87, file: !28, line: 56, type: !91)
!101 = !DILocation(line: 61, column: 2, scope: !87)
!102 = !DILocation(line: 63, column: 15, scope: !87)
!103 = !DILocation(line: 63, column: 2, scope: !87)
!104 = !DILocation(line: 64, column: 15, scope: !87)
!105 = !DILocation(line: 64, column: 2, scope: !87)
!106 = !DILocation(line: 65, column: 15, scope: !87)
!107 = !DILocation(line: 65, column: 2, scope: !87)
!108 = !DILocation(line: 66, column: 15, scope: !87)
!109 = !DILocation(line: 66, column: 2, scope: !87)
!110 = !DILocation(line: 68, column: 2, scope: !111)
!111 = distinct !DILexicalBlock(scope: !112, file: !28, line: 68, column: 2)
!112 = distinct !DILexicalBlock(scope: !87, file: !28, line: 68, column: 2)
!113 = !DILocation(line: 70, column: 2, scope: !87)
