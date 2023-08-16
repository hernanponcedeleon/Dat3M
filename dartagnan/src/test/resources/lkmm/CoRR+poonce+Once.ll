; ModuleID = '/home/ponce/git/Dat3M/output/CoRR+poonce+Once.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/CoRR+poonce+Once.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@r0 = dso_local global i32 0, align 4, !dbg !26
@r1 = dso_local global i32 0, align 4, !dbg !30
@.str = private unnamed_addr constant [22 x i8] c"!(r0 == 1 && r1 == 0)\00", align 1
@.str.1 = private unnamed_addr constant [57 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/CoRR+poonce+Once.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !40 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !44, metadata !DIExpression()), !dbg !45
  call void @__LKMM_STORE(i32* noundef nonnull @x, i32 noundef 1, i32 noundef 1) #5, !dbg !46
  ret i8* null, !dbg !47
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_STORE(i32* noundef, i32 noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !48 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !49, metadata !DIExpression()), !dbg !50
  %2 = call i32 @__LKMM_LOAD(i32* noundef nonnull @x, i32 noundef 1) #5, !dbg !51
  store i32 %2, i32* @r0, align 4, !dbg !52
  %3 = call i32 @__LKMM_LOAD(i32* noundef nonnull @x, i32 noundef 1) #5, !dbg !53
  store i32 %3, i32* @r1, align 4, !dbg !54
  ret i8* null, !dbg !55
}

declare i32 @__LKMM_LOAD(i32* noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !56 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !59, metadata !DIExpression(DW_OP_deref)), !dbg !63
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #5, !dbg !64
  call void @llvm.dbg.value(metadata i64* %2, metadata !65, metadata !DIExpression(DW_OP_deref)), !dbg !63
  %4 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #5, !dbg !66
  %5 = load i64, i64* %1, align 8, !dbg !67
  call void @llvm.dbg.value(metadata i64 %5, metadata !59, metadata !DIExpression()), !dbg !63
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef null) #5, !dbg !68
  %7 = load i64, i64* %2, align 8, !dbg !69
  call void @llvm.dbg.value(metadata i64 %7, metadata !65, metadata !DIExpression()), !dbg !63
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #5, !dbg !70
  %9 = load i32, i32* @r0, align 4, !dbg !71
  %10 = icmp eq i32 %9, 1, !dbg !71
  %11 = load i32, i32* @r1, align 4, !dbg !71
  %12 = icmp eq i32 %11, 0, !dbg !71
  %or.cond = select i1 %10, i1 %12, i1 false, !dbg !71
  br i1 %or.cond, label %13, label %14, !dbg !71

13:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.1, i64 0, i64 0), i32 noundef 33, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !71
  unreachable, !dbg !71

14:                                               ; preds = %0
  ret i32 0, !dbg !74
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
!llvm.module.flags = !{!32, !33, !34, !35, !36, !37, !38}
!llvm.ident = !{!39}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !28, line: 6, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/CoRR+poonce+Once.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "973bb56baa7a0c404651e434a54de408")
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
!25 = !{!0, !26, !30}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/lkmm/CoRR+poonce+Once.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "973bb56baa7a0c404651e434a54de408")
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!32 = !{i32 7, !"Dwarf Version", i32 5}
!33 = !{i32 2, !"Debug Info Version", i32 3}
!34 = !{i32 1, !"wchar_size", i32 4}
!35 = !{i32 7, !"PIC Level", i32 2}
!36 = !{i32 7, !"PIE Level", i32 2}
!37 = !{i32 7, !"uwtable", i32 1}
!38 = !{i32 7, !"frame-pointer", i32 2}
!39 = !{!"Ubuntu clang version 14.0.6"}
!40 = distinct !DISubprogram(name: "thread_1", scope: !28, file: !28, line: 10, type: !41, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!41 = !DISubroutineType(types: !42)
!42 = !{!24, !24}
!43 = !{}
!44 = !DILocalVariable(name: "unused", arg: 1, scope: !40, file: !28, line: 10, type: !24)
!45 = !DILocation(line: 0, scope: !40)
!46 = !DILocation(line: 12, column: 2, scope: !40)
!47 = !DILocation(line: 13, column: 2, scope: !40)
!48 = distinct !DISubprogram(name: "thread_2", scope: !28, file: !28, line: 16, type: !41, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!49 = !DILocalVariable(name: "unused", arg: 1, scope: !48, file: !28, line: 16, type: !24)
!50 = !DILocation(line: 0, scope: !48)
!51 = !DILocation(line: 18, column: 7, scope: !48)
!52 = !DILocation(line: 18, column: 5, scope: !48)
!53 = !DILocation(line: 19, column: 7, scope: !48)
!54 = !DILocation(line: 19, column: 5, scope: !48)
!55 = !DILocation(line: 20, column: 2, scope: !48)
!56 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 23, type: !57, scopeLine: 24, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!57 = !DISubroutineType(types: !58)
!58 = !{!29}
!59 = !DILocalVariable(name: "t1", scope: !56, file: !28, line: 25, type: !60)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !61, line: 27, baseType: !62)
!61 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!62 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!63 = !DILocation(line: 0, scope: !56)
!64 = !DILocation(line: 27, column: 2, scope: !56)
!65 = !DILocalVariable(name: "t2", scope: !56, file: !28, line: 25, type: !60)
!66 = !DILocation(line: 28, column: 2, scope: !56)
!67 = !DILocation(line: 30, column: 15, scope: !56)
!68 = !DILocation(line: 30, column: 2, scope: !56)
!69 = !DILocation(line: 31, column: 15, scope: !56)
!70 = !DILocation(line: 31, column: 2, scope: !56)
!71 = !DILocation(line: 33, column: 2, scope: !72)
!72 = distinct !DILexicalBlock(scope: !73, file: !28, line: 33, column: 2)
!73 = distinct !DILexicalBlock(scope: !56, file: !28, line: 33, column: 2)
!74 = !DILocation(line: 35, column: 2, scope: !56)
