; ModuleID = '/home/ponce/git/Dat3M/output/CoWR+poonceonce+Once.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/CoWR+poonceonce+Once.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@r0 = dso_local global i32 0, align 4, !dbg !26
@.str = private unnamed_addr constant [32 x i8] c"!(READ_ONCE(x) == 1 && r0 == 2)\00", align 1
@.str.1 = private unnamed_addr constant [61 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/CoWR+poonceonce+Once.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !38 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !42, metadata !DIExpression()), !dbg !43
  call void @__LKMM_STORE(i32* noundef nonnull @x, i32 noundef 1, i32 noundef 1) #5, !dbg !44
  %2 = call i32 @__LKMM_LOAD(i32* noundef nonnull @x, i32 noundef 1) #5, !dbg !45
  store i32 %2, i32* @r0, align 4, !dbg !46
  ret i8* null, !dbg !47
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_STORE(i32* noundef, i32 noundef, i32 noundef) #2

declare i32 @__LKMM_LOAD(i32* noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !48 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !49, metadata !DIExpression()), !dbg !50
  call void @__LKMM_STORE(i32* noundef nonnull @x, i32 noundef 2, i32 noundef 1) #5, !dbg !51
  ret i8* null, !dbg !52
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !53 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !56, metadata !DIExpression(DW_OP_deref)), !dbg !60
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #5, !dbg !61
  call void @llvm.dbg.value(metadata i64* %2, metadata !62, metadata !DIExpression(DW_OP_deref)), !dbg !60
  %4 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #5, !dbg !63
  %5 = load i64, i64* %1, align 8, !dbg !64
  call void @llvm.dbg.value(metadata i64 %5, metadata !56, metadata !DIExpression()), !dbg !60
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef null) #5, !dbg !65
  %7 = load i64, i64* %2, align 8, !dbg !66
  call void @llvm.dbg.value(metadata i64 %7, metadata !62, metadata !DIExpression()), !dbg !60
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #5, !dbg !67
  %9 = call i32 @__LKMM_LOAD(i32* noundef nonnull @x, i32 noundef 1) #5, !dbg !68
  %10 = icmp eq i32 %9, 1, !dbg !68
  %11 = load i32, i32* @r0, align 4, !dbg !68
  %12 = icmp eq i32 %11, 2, !dbg !68
  %or.cond = select i1 %10, i1 %12, i1 false, !dbg !68
  br i1 %or.cond, label %13, label %14, !dbg !68

13:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([32 x i8], [32 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @.str.1, i64 0, i64 0), i32 noundef 32, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !68
  unreachable, !dbg !68

14:                                               ; preds = %0
  ret i32 0, !dbg !71
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
!llvm.module.flags = !{!30, !31, !32, !33, !34, !35, !36}
!llvm.ident = !{!37}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !28, line: 6, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/CoWR+poonceonce+Once.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "d522da5fecbd37dabc41d97e03f28b0d")
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
!25 = !{!0, !26}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/lkmm/CoWR+poonceonce+Once.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "d522da5fecbd37dabc41d97e03f28b0d")
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !{i32 7, !"Dwarf Version", i32 5}
!31 = !{i32 2, !"Debug Info Version", i32 3}
!32 = !{i32 1, !"wchar_size", i32 4}
!33 = !{i32 7, !"PIC Level", i32 2}
!34 = !{i32 7, !"PIE Level", i32 2}
!35 = !{i32 7, !"uwtable", i32 1}
!36 = !{i32 7, !"frame-pointer", i32 2}
!37 = !{!"Ubuntu clang version 14.0.6"}
!38 = distinct !DISubprogram(name: "thread_1", scope: !28, file: !28, line: 9, type: !39, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !41)
!39 = !DISubroutineType(types: !40)
!40 = !{!24, !24}
!41 = !{}
!42 = !DILocalVariable(name: "unused", arg: 1, scope: !38, file: !28, line: 9, type: !24)
!43 = !DILocation(line: 0, scope: !38)
!44 = !DILocation(line: 11, column: 2, scope: !38)
!45 = !DILocation(line: 12, column: 7, scope: !38)
!46 = !DILocation(line: 12, column: 5, scope: !38)
!47 = !DILocation(line: 13, column: 2, scope: !38)
!48 = distinct !DISubprogram(name: "thread_2", scope: !28, file: !28, line: 16, type: !39, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !41)
!49 = !DILocalVariable(name: "unused", arg: 1, scope: !48, file: !28, line: 16, type: !24)
!50 = !DILocation(line: 0, scope: !48)
!51 = !DILocation(line: 18, column: 2, scope: !48)
!52 = !DILocation(line: 19, column: 2, scope: !48)
!53 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 22, type: !54, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !41)
!54 = !DISubroutineType(types: !55)
!55 = !{!29}
!56 = !DILocalVariable(name: "t1", scope: !53, file: !28, line: 24, type: !57)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !58, line: 27, baseType: !59)
!58 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!59 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!60 = !DILocation(line: 0, scope: !53)
!61 = !DILocation(line: 26, column: 2, scope: !53)
!62 = !DILocalVariable(name: "t2", scope: !53, file: !28, line: 24, type: !57)
!63 = !DILocation(line: 27, column: 2, scope: !53)
!64 = !DILocation(line: 29, column: 15, scope: !53)
!65 = !DILocation(line: 29, column: 2, scope: !53)
!66 = !DILocation(line: 30, column: 15, scope: !53)
!67 = !DILocation(line: 30, column: 2, scope: !53)
!68 = !DILocation(line: 32, column: 2, scope: !69)
!69 = distinct !DILexicalBlock(scope: !70, file: !28, line: 32, column: 2)
!70 = distinct !DILexicalBlock(scope: !53, file: !28, line: 32, column: 2)
!71 = !DILocation(line: 34, column: 2, scope: !53)
