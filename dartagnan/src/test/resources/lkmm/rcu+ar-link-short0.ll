; ModuleID = '/home/ponce/git/Dat3M/output/rcu+ar-link-short0.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/rcu+ar-link-short0.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@w = dso_local global [2 x i32] [i32 0, i32 1], align 4, !dbg !0
@x = dso_local global i32 0, align 4, !dbg !26
@y = dso_local global i32 0, align 4, !dbg !30
@s = dso_local global i32 0, align 4, !dbg !36
@r_s = dso_local global i32 0, align 4, !dbg !38
@r_w = dso_local global i32 0, align 4, !dbg !40
@r_y = dso_local global i32 0, align 4, !dbg !34
@.str = private unnamed_addr constant [36 x i8] c"!(r_y == 0 && r_s == 1 && r_w == 1)\00", align 1
@.str.1 = private unnamed_addr constant [59 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/rcu+ar-link-short0.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@r_x = dso_local global i32 0, align 4, !dbg !32

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P0(i8* noundef %0) #0 !dbg !53 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !57, metadata !DIExpression()), !dbg !58
  call void @__LKMM_FENCE(i32 noundef 7) #5, !dbg !59
  call void @__LKMM_STORE(i32* noundef nonnull @x, i32 noundef 1, i32 noundef 1) #5, !dbg !60
  call void @__LKMM_STORE(i32* noundef nonnull @y, i32 noundef 1, i32 noundef 1) #5, !dbg !61
  call void @__LKMM_FENCE(i32 noundef 8) #5, !dbg !62
  ret i8* null, !dbg !63
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_FENCE(i32 noundef) #2

declare void @__LKMM_STORE(i32* noundef, i32 noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P1(i8* noundef %0) #0 !dbg !64 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !65, metadata !DIExpression()), !dbg !66
  %2 = call i32 @__LKMM_LOAD(i32* noundef nonnull @x, i32 noundef 1) #5, !dbg !67
  %3 = icmp eq i32 %2, 1, !dbg !69
  br i1 %3, label %4, label %5, !dbg !70

4:                                                ; preds = %1
  call void @__LKMM_STORE(i32* noundef nonnull @s, i32 noundef 1, i32 noundef 1) #5, !dbg !71
  br label %5, !dbg !71

5:                                                ; preds = %4, %1
  ret i8* null, !dbg !72
}

declare i32 @__LKMM_LOAD(i32* noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P2(i8* noundef %0) #0 !dbg !73 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !74, metadata !DIExpression()), !dbg !75
  %2 = call i32 @__LKMM_LOAD(i32* noundef nonnull @s, i32 noundef 1) #5, !dbg !76
  store i32 %2, i32* @r_s, align 4, !dbg !77
  %3 = sext i32 %2 to i64, !dbg !78
  %4 = getelementptr inbounds [2 x i32], [2 x i32]* @w, i64 0, i64 %3, !dbg !78
  %5 = call i32 @__LKMM_LOAD(i32* noundef nonnull %4, i32 noundef 1) #5, !dbg !78
  store i32 %5, i32* @r_w, align 4, !dbg !79
  ret i8* null, !dbg !80
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P3(i8* noundef %0) #0 !dbg !81 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !82, metadata !DIExpression()), !dbg !83
  call void @__LKMM_STORE(i32* noundef getelementptr inbounds ([2 x i32], [2 x i32]* @w, i64 0, i64 1), i32 noundef 2, i32 noundef 1) #5, !dbg !84
  call void @__LKMM_FENCE(i32 noundef 9) #5, !dbg !85
  %2 = call i32 @__LKMM_LOAD(i32* noundef nonnull @y, i32 noundef 1) #5, !dbg !86
  store i32 %2, i32* @r_y, align 4, !dbg !87
  ret i8* null, !dbg !88
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !89 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !92, metadata !DIExpression(DW_OP_deref)), !dbg !96
  %5 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P0, i8* noundef null) #5, !dbg !97
  call void @llvm.dbg.value(metadata i64* %2, metadata !98, metadata !DIExpression(DW_OP_deref)), !dbg !96
  %6 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P1, i8* noundef null) #5, !dbg !99
  call void @llvm.dbg.value(metadata i64* %3, metadata !100, metadata !DIExpression(DW_OP_deref)), !dbg !96
  %7 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P2, i8* noundef null) #5, !dbg !101
  call void @llvm.dbg.value(metadata i64* %4, metadata !102, metadata !DIExpression(DW_OP_deref)), !dbg !96
  %8 = call i32 @pthread_create(i64* noundef nonnull %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P3, i8* noundef null) #5, !dbg !103
  %9 = load i64, i64* %1, align 8, !dbg !104
  call void @llvm.dbg.value(metadata i64 %9, metadata !92, metadata !DIExpression()), !dbg !96
  %10 = call i32 @pthread_join(i64 noundef %9, i8** noundef null) #5, !dbg !105
  %11 = load i64, i64* %2, align 8, !dbg !106
  call void @llvm.dbg.value(metadata i64 %11, metadata !98, metadata !DIExpression()), !dbg !96
  %12 = call i32 @pthread_join(i64 noundef %11, i8** noundef null) #5, !dbg !107
  %13 = load i64, i64* %3, align 8, !dbg !108
  call void @llvm.dbg.value(metadata i64 %13, metadata !100, metadata !DIExpression()), !dbg !96
  %14 = call i32 @pthread_join(i64 noundef %13, i8** noundef null) #5, !dbg !109
  %15 = load i64, i64* %4, align 8, !dbg !110
  call void @llvm.dbg.value(metadata i64 %15, metadata !102, metadata !DIExpression()), !dbg !96
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null) #5, !dbg !111
  %17 = load i32, i32* @r_y, align 4, !dbg !112
  %18 = icmp eq i32 %17, 0, !dbg !112
  %19 = load i32, i32* @r_s, align 4, !dbg !112
  %20 = icmp eq i32 %19, 1, !dbg !112
  %or.cond = select i1 %18, i1 %20, i1 false, !dbg !112
  %21 = load i32, i32* @r_w, align 4, !dbg !112
  %22 = icmp eq i32 %21, 1, !dbg !112
  %or.cond3 = select i1 %or.cond, i1 %22, i1 false, !dbg !112
  br i1 %or.cond3, label %23, label %24, !dbg !112

23:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([59 x i8], [59 x i8]* @.str.1, i64 0, i64 0), i32 noundef 82, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !112
  unreachable, !dbg !112

24:                                               ; preds = %0
  ret i32 0, !dbg !115
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
!llvm.module.flags = !{!45, !46, !47, !48, !49, !50, !51}
!llvm.ident = !{!52}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "w", scope: !2, file: !28, line: 29, type: !42, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/rcu+ar-link-short0.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "75fba3f93246ceba8ebd1225e5ca1dff")
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
!25 = !{!0, !26, !30, !32, !34, !36, !38, !40}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !28, line: 21, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/lkmm/rcu+ar-link-short0.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "75fba3f93246ceba8ebd1225e5ca1dff")
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !28, line: 22, type: !29, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "r_x", scope: !2, file: !28, line: 24, type: !29, isLocal: false, isDefinition: true)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "r_y", scope: !2, file: !28, line: 25, type: !29, isLocal: false, isDefinition: true)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !28, line: 28, type: !29, isLocal: false, isDefinition: true)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "r_s", scope: !2, file: !28, line: 31, type: !29, isLocal: false, isDefinition: true)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "r_w", scope: !2, file: !28, line: 32, type: !29, isLocal: false, isDefinition: true)
!42 = !DICompositeType(tag: DW_TAG_array_type, baseType: !29, size: 64, elements: !43)
!43 = !{!44}
!44 = !DISubrange(count: 2)
!45 = !{i32 7, !"Dwarf Version", i32 5}
!46 = !{i32 2, !"Debug Info Version", i32 3}
!47 = !{i32 1, !"wchar_size", i32 4}
!48 = !{i32 7, !"PIC Level", i32 2}
!49 = !{i32 7, !"PIE Level", i32 2}
!50 = !{i32 7, !"uwtable", i32 1}
!51 = !{i32 7, !"frame-pointer", i32 2}
!52 = !{!"Ubuntu clang version 14.0.6"}
!53 = distinct !DISubprogram(name: "P0", scope: !28, file: !28, line: 34, type: !54, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!54 = !DISubroutineType(types: !55)
!55 = !{!24, !24}
!56 = !{}
!57 = !DILocalVariable(name: "unused", arg: 1, scope: !53, file: !28, line: 34, type: !24)
!58 = !DILocation(line: 0, scope: !53)
!59 = !DILocation(line: 36, column: 2, scope: !53)
!60 = !DILocation(line: 37, column: 2, scope: !53)
!61 = !DILocation(line: 38, column: 2, scope: !53)
!62 = !DILocation(line: 39, column: 2, scope: !53)
!63 = !DILocation(line: 40, column: 2, scope: !53)
!64 = distinct !DISubprogram(name: "P1", scope: !28, file: !28, line: 43, type: !54, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!65 = !DILocalVariable(name: "unused", arg: 1, scope: !64, file: !28, line: 43, type: !24)
!66 = !DILocation(line: 0, scope: !64)
!67 = !DILocation(line: 45, column: 6, scope: !68)
!68 = distinct !DILexicalBlock(scope: !64, file: !28, line: 45, column: 6)
!69 = !DILocation(line: 45, column: 19, scope: !68)
!70 = !DILocation(line: 45, column: 6, scope: !64)
!71 = !DILocation(line: 46, column: 3, scope: !68)
!72 = !DILocation(line: 47, column: 2, scope: !64)
!73 = distinct !DISubprogram(name: "P2", scope: !28, file: !28, line: 50, type: !54, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!74 = !DILocalVariable(name: "unused", arg: 1, scope: !73, file: !28, line: 50, type: !24)
!75 = !DILocation(line: 0, scope: !73)
!76 = !DILocation(line: 52, column: 8, scope: !73)
!77 = !DILocation(line: 52, column: 6, scope: !73)
!78 = !DILocation(line: 53, column: 8, scope: !73)
!79 = !DILocation(line: 53, column: 6, scope: !73)
!80 = !DILocation(line: 54, column: 2, scope: !73)
!81 = distinct !DISubprogram(name: "P3", scope: !28, file: !28, line: 57, type: !54, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!82 = !DILocalVariable(name: "unused", arg: 1, scope: !81, file: !28, line: 57, type: !24)
!83 = !DILocation(line: 0, scope: !81)
!84 = !DILocation(line: 59, column: 2, scope: !81)
!85 = !DILocation(line: 60, column: 2, scope: !81)
!86 = !DILocation(line: 61, column: 8, scope: !81)
!87 = !DILocation(line: 61, column: 6, scope: !81)
!88 = !DILocation(line: 62, column: 2, scope: !81)
!89 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 65, type: !90, scopeLine: 66, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!90 = !DISubroutineType(types: !91)
!91 = !{!29}
!92 = !DILocalVariable(name: "t0", scope: !89, file: !28, line: 70, type: !93)
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !94, line: 27, baseType: !95)
!94 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!95 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!96 = !DILocation(line: 0, scope: !89)
!97 = !DILocation(line: 72, column: 2, scope: !89)
!98 = !DILocalVariable(name: "t1", scope: !89, file: !28, line: 70, type: !93)
!99 = !DILocation(line: 73, column: 2, scope: !89)
!100 = !DILocalVariable(name: "t2", scope: !89, file: !28, line: 70, type: !93)
!101 = !DILocation(line: 74, column: 2, scope: !89)
!102 = !DILocalVariable(name: "t3", scope: !89, file: !28, line: 70, type: !93)
!103 = !DILocation(line: 75, column: 2, scope: !89)
!104 = !DILocation(line: 77, column: 15, scope: !89)
!105 = !DILocation(line: 77, column: 2, scope: !89)
!106 = !DILocation(line: 78, column: 15, scope: !89)
!107 = !DILocation(line: 78, column: 2, scope: !89)
!108 = !DILocation(line: 79, column: 15, scope: !89)
!109 = !DILocation(line: 79, column: 2, scope: !89)
!110 = !DILocation(line: 80, column: 15, scope: !89)
!111 = !DILocation(line: 80, column: 2, scope: !89)
!112 = !DILocation(line: 82, column: 2, scope: !113)
!113 = distinct !DILexicalBlock(scope: !114, file: !28, line: 82, column: 2)
!114 = distinct !DILexicalBlock(scope: !89, file: !28, line: 82, column: 2)
!115 = !DILocation(line: 84, column: 2, scope: !89)
