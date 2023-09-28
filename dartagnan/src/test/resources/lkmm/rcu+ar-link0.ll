; ModuleID = '/home/ponce/git/Dat3M/output/rcu+ar-link0.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/rcu+ar-link0.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !26
@r_y = dso_local global i32 0, align 4, !dbg !32
@s = dso_local global i32 0, align 4, !dbg !34
@r_s = dso_local global i32 0, align 4, !dbg !46
@w = dso_local global i32 0, align 4, !dbg !36
@z = dso_local global i32 0, align 4, !dbg !38
@a = dso_local global i32 0, align 4, !dbg !40
@r_a = dso_local global i32 0, align 4, !dbg !48
@b = dso_local global i32 0, align 4, !dbg !42
@r_b = dso_local global i32 0, align 4, !dbg !50
@c = dso_local global i32 0, align 4, !dbg !44
@r_c = dso_local global i32 0, align 4, !dbg !52
@.str = private unnamed_addr constant [60 x i8] c"!(r_y == 1 && r_s == 1 && r_a == 1 && r_b == 1 && r_c == 1)\00", align 1
@.str.1 = private unnamed_addr constant [53 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/rcu+ar-link0.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@r_x = dso_local global i32 0, align 4, !dbg !30

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P0(i8* noundef %0) #0 !dbg !62 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !66, metadata !DIExpression()), !dbg !67
  call void @__LKMM_FENCE(i32 noundef 7) #5, !dbg !68
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !69
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1) #5, !dbg !70
  store i32 %2, i32* @r_y, align 4, !dbg !71
  call void @__LKMM_FENCE(i32 noundef 8) #5, !dbg !72
  ret i8* null, !dbg !73
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_FENCE(i32 noundef) #2

declare void @__LKMM_STORE(i8* noundef, i32 noundef, i32 noundef) #2

declare i32 @__LKMM_LOAD(i8* noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P1(i8* noundef %0) #0 !dbg !74 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !75, metadata !DIExpression()), !dbg !76
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1) #5, !dbg !77
  %3 = icmp eq i32 %2, 1, !dbg !79
  br i1 %3, label %4, label %5, !dbg !80

4:                                                ; preds = %1
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @s to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !81
  br label %5, !dbg !81

5:                                                ; preds = %4, %1
  ret i8* null, !dbg !82
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P2(i8* noundef %0) #0 !dbg !83 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !84, metadata !DIExpression()), !dbg !85
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @s to i8*), i32 noundef 1) #5, !dbg !86
  store i32 %2, i32* @r_s, align 4, !dbg !87
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @w to i8*), i32 noundef 1, i32 noundef 3) #5, !dbg !88
  %3 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @z to i8*), i32 noundef 1) #5, !dbg !89
  call void @llvm.dbg.value(metadata i32 %3, metadata !90, metadata !DIExpression()), !dbg !85
  %4 = add nsw i32 %3, 1, !dbg !91
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @a to i8*), i32 noundef %4, i32 noundef 1) #5, !dbg !91
  ret i8* null, !dbg !92
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P3(i8* noundef %0) #0 !dbg !93 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !94, metadata !DIExpression()), !dbg !95
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @a to i8*), i32 noundef 1) #5, !dbg !96
  store i32 %2, i32* @r_a, align 4, !dbg !97
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @b to i8*), i32 noundef %2, i32 noundef 1) #5, !dbg !98
  ret i8* null, !dbg !99
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P4(i8* noundef %0) #0 !dbg !100 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !101, metadata !DIExpression()), !dbg !102
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @b to i8*), i32 noundef 1) #5, !dbg !103
  store i32 %2, i32* @r_b, align 4, !dbg !104
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @c to i8*), i32 noundef 1, i32 noundef 3) #5, !dbg !105
  ret i8* null, !dbg !106
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P5(i8* noundef %0) #0 !dbg !107 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !108, metadata !DIExpression()), !dbg !109
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @c to i8*), i32 noundef 1) #5, !dbg !110
  store i32 %2, i32* @r_c, align 4, !dbg !111
  call void @__LKMM_FENCE(i32 noundef 9) #5, !dbg !112
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !113
  ret i8* null, !dbg !114
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !115 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !118, metadata !DIExpression(DW_OP_deref)), !dbg !122
  %7 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P0, i8* noundef null) #5, !dbg !123
  call void @llvm.dbg.value(metadata i64* %2, metadata !124, metadata !DIExpression(DW_OP_deref)), !dbg !122
  %8 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P1, i8* noundef null) #5, !dbg !125
  call void @llvm.dbg.value(metadata i64* %3, metadata !126, metadata !DIExpression(DW_OP_deref)), !dbg !122
  %9 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P2, i8* noundef null) #5, !dbg !127
  call void @llvm.dbg.value(metadata i64* %4, metadata !128, metadata !DIExpression(DW_OP_deref)), !dbg !122
  %10 = call i32 @pthread_create(i64* noundef nonnull %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P3, i8* noundef null) #5, !dbg !129
  call void @llvm.dbg.value(metadata i64* %5, metadata !130, metadata !DIExpression(DW_OP_deref)), !dbg !122
  %11 = call i32 @pthread_create(i64* noundef nonnull %5, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P4, i8* noundef null) #5, !dbg !131
  call void @llvm.dbg.value(metadata i64* %6, metadata !132, metadata !DIExpression(DW_OP_deref)), !dbg !122
  %12 = call i32 @pthread_create(i64* noundef nonnull %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P5, i8* noundef null) #5, !dbg !133
  %13 = load i64, i64* %1, align 8, !dbg !134
  call void @llvm.dbg.value(metadata i64 %13, metadata !118, metadata !DIExpression()), !dbg !122
  %14 = call i32 @pthread_join(i64 noundef %13, i8** noundef null) #5, !dbg !135
  %15 = load i64, i64* %2, align 8, !dbg !136
  call void @llvm.dbg.value(metadata i64 %15, metadata !124, metadata !DIExpression()), !dbg !122
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null) #5, !dbg !137
  %17 = load i64, i64* %3, align 8, !dbg !138
  call void @llvm.dbg.value(metadata i64 %17, metadata !126, metadata !DIExpression()), !dbg !122
  %18 = call i32 @pthread_join(i64 noundef %17, i8** noundef null) #5, !dbg !139
  %19 = load i64, i64* %4, align 8, !dbg !140
  call void @llvm.dbg.value(metadata i64 %19, metadata !128, metadata !DIExpression()), !dbg !122
  %20 = call i32 @pthread_join(i64 noundef %19, i8** noundef null) #5, !dbg !141
  %21 = load i64, i64* %5, align 8, !dbg !142
  call void @llvm.dbg.value(metadata i64 %21, metadata !130, metadata !DIExpression()), !dbg !122
  %22 = call i32 @pthread_join(i64 noundef %21, i8** noundef null) #5, !dbg !143
  %23 = load i64, i64* %6, align 8, !dbg !144
  call void @llvm.dbg.value(metadata i64 %23, metadata !132, metadata !DIExpression()), !dbg !122
  %24 = call i32 @pthread_join(i64 noundef %23, i8** noundef null) #5, !dbg !145
  %25 = load i32, i32* @r_y, align 4, !dbg !146
  %26 = icmp eq i32 %25, 1, !dbg !146
  %27 = load i32, i32* @r_s, align 4, !dbg !146
  %28 = icmp eq i32 %27, 1, !dbg !146
  %or.cond = select i1 %26, i1 %28, i1 false, !dbg !146
  %29 = load i32, i32* @r_a, align 4, !dbg !146
  %30 = icmp eq i32 %29, 1, !dbg !146
  %or.cond3 = select i1 %or.cond, i1 %30, i1 false, !dbg !146
  %31 = load i32, i32* @r_b, align 4, !dbg !146
  %32 = icmp eq i32 %31, 1, !dbg !146
  %or.cond5 = select i1 %or.cond3, i1 %32, i1 false, !dbg !146
  %33 = load i32, i32* @r_c, align 4, !dbg !146
  %34 = icmp eq i32 %33, 1, !dbg !146
  %or.cond7 = select i1 %or.cond5, i1 %34, i1 false, !dbg !146
  br i1 %or.cond7, label %35, label %36, !dbg !146

35:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 noundef 105, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !146
  unreachable, !dbg !146

36:                                               ; preds = %0
  ret i32 0, !dbg !149
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
!llvm.module.flags = !{!54, !55, !56, !57, !58, !59, !60}
!llvm.ident = !{!61}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !28, line: 16, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/rcu+ar-link0.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "6b13efe8b5bb64ba02860a374c43853f")
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
!25 = !{!0, !26, !30, !32, !34, !36, !38, !40, !42, !44, !46, !48, !50, !52}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !28, line: 17, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/lkmm/rcu+ar-link0.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "6b13efe8b5bb64ba02860a374c43853f")
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "r_x", scope: !2, file: !28, line: 19, type: !29, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "r_y", scope: !2, file: !28, line: 20, type: !29, isLocal: false, isDefinition: true)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !28, line: 23, type: !29, isLocal: false, isDefinition: true)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "w", scope: !2, file: !28, line: 24, type: !29, isLocal: false, isDefinition: true)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !28, line: 25, type: !29, isLocal: false, isDefinition: true)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !28, line: 27, type: !29, isLocal: false, isDefinition: true)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !28, line: 28, type: !29, isLocal: false, isDefinition: true)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !28, line: 29, type: !29, isLocal: false, isDefinition: true)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "r_s", scope: !2, file: !28, line: 31, type: !29, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "r_a", scope: !2, file: !28, line: 32, type: !29, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "r_b", scope: !2, file: !28, line: 33, type: !29, isLocal: false, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "r_c", scope: !2, file: !28, line: 34, type: !29, isLocal: false, isDefinition: true)
!54 = !{i32 7, !"Dwarf Version", i32 5}
!55 = !{i32 2, !"Debug Info Version", i32 3}
!56 = !{i32 1, !"wchar_size", i32 4}
!57 = !{i32 7, !"PIC Level", i32 2}
!58 = !{i32 7, !"PIE Level", i32 2}
!59 = !{i32 7, !"uwtable", i32 1}
!60 = !{i32 7, !"frame-pointer", i32 2}
!61 = !{!"Ubuntu clang version 14.0.6"}
!62 = distinct !DISubprogram(name: "P0", scope: !28, file: !28, line: 36, type: !63, scopeLine: 37, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!63 = !DISubroutineType(types: !64)
!64 = !{!24, !24}
!65 = !{}
!66 = !DILocalVariable(name: "unused", arg: 1, scope: !62, file: !28, line: 36, type: !24)
!67 = !DILocation(line: 0, scope: !62)
!68 = !DILocation(line: 38, column: 2, scope: !62)
!69 = !DILocation(line: 39, column: 2, scope: !62)
!70 = !DILocation(line: 40, column: 8, scope: !62)
!71 = !DILocation(line: 40, column: 6, scope: !62)
!72 = !DILocation(line: 41, column: 2, scope: !62)
!73 = !DILocation(line: 42, column: 2, scope: !62)
!74 = distinct !DISubprogram(name: "P1", scope: !28, file: !28, line: 45, type: !63, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!75 = !DILocalVariable(name: "unused", arg: 1, scope: !74, file: !28, line: 45, type: !24)
!76 = !DILocation(line: 0, scope: !74)
!77 = !DILocation(line: 47, column: 6, scope: !78)
!78 = distinct !DILexicalBlock(scope: !74, file: !28, line: 47, column: 6)
!79 = !DILocation(line: 47, column: 19, scope: !78)
!80 = !DILocation(line: 47, column: 6, scope: !74)
!81 = !DILocation(line: 48, column: 3, scope: !78)
!82 = !DILocation(line: 49, column: 2, scope: !74)
!83 = distinct !DISubprogram(name: "P2", scope: !28, file: !28, line: 52, type: !63, scopeLine: 53, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!84 = !DILocalVariable(name: "unused", arg: 1, scope: !83, file: !28, line: 52, type: !24)
!85 = !DILocation(line: 0, scope: !83)
!86 = !DILocation(line: 54, column: 8, scope: !83)
!87 = !DILocation(line: 54, column: 6, scope: !83)
!88 = !DILocation(line: 55, column: 2, scope: !83)
!89 = !DILocation(line: 57, column: 10, scope: !83)
!90 = !DILocalVariable(name: "r", scope: !83, file: !28, line: 57, type: !29)
!91 = !DILocation(line: 58, column: 2, scope: !83)
!92 = !DILocation(line: 59, column: 2, scope: !83)
!93 = distinct !DISubprogram(name: "P3", scope: !28, file: !28, line: 62, type: !63, scopeLine: 63, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!94 = !DILocalVariable(name: "unused", arg: 1, scope: !93, file: !28, line: 62, type: !24)
!95 = !DILocation(line: 0, scope: !93)
!96 = !DILocation(line: 64, column: 8, scope: !93)
!97 = !DILocation(line: 64, column: 6, scope: !93)
!98 = !DILocation(line: 65, column: 2, scope: !93)
!99 = !DILocation(line: 66, column: 2, scope: !93)
!100 = distinct !DISubprogram(name: "P4", scope: !28, file: !28, line: 69, type: !63, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!101 = !DILocalVariable(name: "unused", arg: 1, scope: !100, file: !28, line: 69, type: !24)
!102 = !DILocation(line: 0, scope: !100)
!103 = !DILocation(line: 71, column: 8, scope: !100)
!104 = !DILocation(line: 71, column: 6, scope: !100)
!105 = !DILocation(line: 72, column: 2, scope: !100)
!106 = !DILocation(line: 73, column: 2, scope: !100)
!107 = distinct !DISubprogram(name: "P5", scope: !28, file: !28, line: 76, type: !63, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!108 = !DILocalVariable(name: "unused", arg: 1, scope: !107, file: !28, line: 76, type: !24)
!109 = !DILocation(line: 0, scope: !107)
!110 = !DILocation(line: 78, column: 8, scope: !107)
!111 = !DILocation(line: 78, column: 6, scope: !107)
!112 = !DILocation(line: 79, column: 2, scope: !107)
!113 = !DILocation(line: 80, column: 2, scope: !107)
!114 = !DILocation(line: 81, column: 2, scope: !107)
!115 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 84, type: !116, scopeLine: 85, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !65)
!116 = !DISubroutineType(types: !117)
!117 = !{!29}
!118 = !DILocalVariable(name: "t0", scope: !115, file: !28, line: 89, type: !119)
!119 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !120, line: 27, baseType: !121)
!120 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!121 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!122 = !DILocation(line: 0, scope: !115)
!123 = !DILocation(line: 91, column: 2, scope: !115)
!124 = !DILocalVariable(name: "t1", scope: !115, file: !28, line: 89, type: !119)
!125 = !DILocation(line: 92, column: 2, scope: !115)
!126 = !DILocalVariable(name: "t2", scope: !115, file: !28, line: 89, type: !119)
!127 = !DILocation(line: 93, column: 2, scope: !115)
!128 = !DILocalVariable(name: "t3", scope: !115, file: !28, line: 89, type: !119)
!129 = !DILocation(line: 94, column: 2, scope: !115)
!130 = !DILocalVariable(name: "t4", scope: !115, file: !28, line: 89, type: !119)
!131 = !DILocation(line: 95, column: 2, scope: !115)
!132 = !DILocalVariable(name: "t5", scope: !115, file: !28, line: 89, type: !119)
!133 = !DILocation(line: 96, column: 2, scope: !115)
!134 = !DILocation(line: 98, column: 15, scope: !115)
!135 = !DILocation(line: 98, column: 2, scope: !115)
!136 = !DILocation(line: 99, column: 15, scope: !115)
!137 = !DILocation(line: 99, column: 2, scope: !115)
!138 = !DILocation(line: 100, column: 15, scope: !115)
!139 = !DILocation(line: 100, column: 2, scope: !115)
!140 = !DILocation(line: 101, column: 15, scope: !115)
!141 = !DILocation(line: 101, column: 2, scope: !115)
!142 = !DILocation(line: 102, column: 15, scope: !115)
!143 = !DILocation(line: 102, column: 2, scope: !115)
!144 = !DILocation(line: 103, column: 15, scope: !115)
!145 = !DILocation(line: 103, column: 2, scope: !115)
!146 = !DILocation(line: 105, column: 2, scope: !147)
!147 = distinct !DILexicalBlock(scope: !148, file: !28, line: 105, column: 2)
!148 = distinct !DILexicalBlock(scope: !115, file: !28, line: 105, column: 2)
!149 = !DILocation(line: 107, column: 2, scope: !115)
