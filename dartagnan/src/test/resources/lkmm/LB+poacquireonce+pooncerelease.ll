; ModuleID = '/home/ponce/git/Dat3M/output/LB+poacquireonce+pooncerelease.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/LB+poacquireonce+pooncerelease.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@r0 = dso_local global i32 0, align 4, !dbg !30
@y = dso_local global i32 0, align 4, !dbg !26
@r1 = dso_local global i32 0, align 4, !dbg !32
@.str = private unnamed_addr constant [22 x i8] c"!(r0 == 1 && r1 == 1)\00", align 1
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/LB+poacquireonce+pooncerelease.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !42 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !46, metadata !DIExpression()), !dbg !47
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1) #5, !dbg !48
  store i32 %2, i32* @r0, align 4, !dbg !49
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1, i32 noundef 3) #5, !dbg !50
  ret i8* null, !dbg !51
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @__LKMM_LOAD(i8* noundef, i32 noundef) #2

declare void @__LKMM_STORE(i8* noundef, i32 noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !52 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !53, metadata !DIExpression()), !dbg !54
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @y to i8*), i32 noundef 2) #5, !dbg !55
  store i32 %2, i32* @r1, align 4, !dbg !56
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !57
  ret i8* null, !dbg !58
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !59 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !62, metadata !DIExpression(DW_OP_deref)), !dbg !66
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #5, !dbg !67
  call void @llvm.dbg.value(metadata i64* %2, metadata !68, metadata !DIExpression(DW_OP_deref)), !dbg !66
  %4 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #5, !dbg !69
  %5 = load i64, i64* %1, align 8, !dbg !70
  call void @llvm.dbg.value(metadata i64 %5, metadata !62, metadata !DIExpression()), !dbg !66
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef null) #5, !dbg !71
  %7 = load i64, i64* %2, align 8, !dbg !72
  call void @llvm.dbg.value(metadata i64 %7, metadata !68, metadata !DIExpression()), !dbg !66
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #5, !dbg !73
  %9 = load i32, i32* @r0, align 4, !dbg !74
  %10 = icmp eq i32 %9, 1, !dbg !74
  %11 = load i32, i32* @r1, align 4, !dbg !74
  %12 = icmp eq i32 %11, 1, !dbg !74
  %or.cond = select i1 %10, i1 %12, i1 false, !dbg !74
  br i1 %or.cond, label %13, label %14, !dbg !74

13:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i64 0, i64 0), i32 noundef 35, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !74
  unreachable, !dbg !74

14:                                               ; preds = %0
  ret i32 0, !dbg !77
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
!llvm.module.flags = !{!34, !35, !36, !37, !38, !39, !40}
!llvm.ident = !{!41}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !28, line: 6, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/LB+poacquireonce+pooncerelease.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "273f0308996bdd503c288ed473fb0e4c")
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
!25 = !{!0, !26, !30, !32}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/lkmm/LB+poacquireonce+pooncerelease.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "273f0308996bdd503c288ed473fb0e4c")
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "r0", scope: !2, file: !28, line: 9, type: !29, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "r1", scope: !2, file: !28, line: 9, type: !29, isLocal: false, isDefinition: true)
!34 = !{i32 7, !"Dwarf Version", i32 5}
!35 = !{i32 2, !"Debug Info Version", i32 3}
!36 = !{i32 1, !"wchar_size", i32 4}
!37 = !{i32 7, !"PIC Level", i32 2}
!38 = !{i32 7, !"PIE Level", i32 2}
!39 = !{i32 7, !"uwtable", i32 1}
!40 = !{i32 7, !"frame-pointer", i32 2}
!41 = !{!"Ubuntu clang version 14.0.6"}
!42 = distinct !DISubprogram(name: "thread_1", scope: !28, file: !28, line: 11, type: !43, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!43 = !DISubroutineType(types: !44)
!44 = !{!24, !24}
!45 = !{}
!46 = !DILocalVariable(name: "unused", arg: 1, scope: !42, file: !28, line: 11, type: !24)
!47 = !DILocation(line: 0, scope: !42)
!48 = !DILocation(line: 13, column: 7, scope: !42)
!49 = !DILocation(line: 13, column: 5, scope: !42)
!50 = !DILocation(line: 14, column: 2, scope: !42)
!51 = !DILocation(line: 15, column: 2, scope: !42)
!52 = distinct !DISubprogram(name: "thread_2", scope: !28, file: !28, line: 18, type: !43, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!53 = !DILocalVariable(name: "unused", arg: 1, scope: !52, file: !28, line: 18, type: !24)
!54 = !DILocation(line: 0, scope: !52)
!55 = !DILocation(line: 20, column: 7, scope: !52)
!56 = !DILocation(line: 20, column: 5, scope: !52)
!57 = !DILocation(line: 21, column: 2, scope: !52)
!58 = !DILocation(line: 22, column: 2, scope: !52)
!59 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 25, type: !60, scopeLine: 26, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!60 = !DISubroutineType(types: !61)
!61 = !{!29}
!62 = !DILocalVariable(name: "t1", scope: !59, file: !28, line: 27, type: !63)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !64, line: 27, baseType: !65)
!64 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!65 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!66 = !DILocation(line: 0, scope: !59)
!67 = !DILocation(line: 29, column: 2, scope: !59)
!68 = !DILocalVariable(name: "t2", scope: !59, file: !28, line: 27, type: !63)
!69 = !DILocation(line: 30, column: 2, scope: !59)
!70 = !DILocation(line: 32, column: 15, scope: !59)
!71 = !DILocation(line: 32, column: 2, scope: !59)
!72 = !DILocation(line: 33, column: 15, scope: !59)
!73 = !DILocation(line: 33, column: 2, scope: !59)
!74 = !DILocation(line: 35, column: 2, scope: !75)
!75 = distinct !DILexicalBlock(scope: !76, file: !28, line: 35, column: 2)
!76 = distinct !DILexicalBlock(scope: !59, file: !28, line: 35, column: 2)
!77 = !DILocation(line: 37, column: 2, scope: !59)
