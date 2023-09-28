; ModuleID = '/home/ponce/git/Dat3M/output/rcu-MP.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/rcu-MP.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !26
@.str = private unnamed_addr constant [24 x i8] c"!(r_y == 1 && r_x == 0)\00", align 1
@.str.1 = private unnamed_addr constant [47 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/rcu-MP.c\00", align 1
@__PRETTY_FUNCTION__.P1 = private unnamed_addr constant [17 x i8] c"void *P1(void *)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P0(i8* noundef %0) #0 !dbg !38 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !42, metadata !DIExpression()), !dbg !43
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !44
  call void @__LKMM_FENCE(i32 noundef 9) #5, !dbg !45
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1, i32 noundef 1) #5, !dbg !46
  ret i8* null, !dbg !47
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_STORE(i8* noundef, i32 noundef, i32 noundef) #2

declare void @__LKMM_FENCE(i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @P1(i8* noundef %0) #0 !dbg !48 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !49, metadata !DIExpression()), !dbg !50
  call void @__LKMM_FENCE(i32 noundef 7) #5, !dbg !51
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1) #5, !dbg !52
  call void @llvm.dbg.value(metadata i32 %2, metadata !53, metadata !DIExpression()), !dbg !50
  %3 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1) #5, !dbg !54
  call void @llvm.dbg.value(metadata i32 %3, metadata !55, metadata !DIExpression()), !dbg !50
  call void @__LKMM_FENCE(i32 noundef 8) #5, !dbg !56
  %4 = icmp eq i32 %2, 1, !dbg !57
  %5 = icmp eq i32 %3, 0, !dbg !57
  %or.cond = select i1 %4, i1 %5, i1 false, !dbg !57
  br i1 %or.cond, label %6, label %7, !dbg !57

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @.str.1, i64 0, i64 0), i32 noundef 24, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.P1, i64 0, i64 0)) #6, !dbg !57
  unreachable, !dbg !57

7:                                                ; preds = %1
  ret i8* null, !dbg !60
}

declare i32 @__LKMM_LOAD(i8* noundef, i32 noundef) #2

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !61 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !64, metadata !DIExpression(DW_OP_deref)), !dbg !68
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P0, i8* noundef null) #5, !dbg !69
  call void @llvm.dbg.value(metadata i64* %2, metadata !70, metadata !DIExpression(DW_OP_deref)), !dbg !68
  %4 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @P1, i8* noundef null) #5, !dbg !71
  ret i32 0, !dbg !72
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #4

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
!llvm.module.flags = !{!30, !31, !32, !33, !34, !35, !36}
!llvm.ident = !{!37}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/rcu-MP.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "ee7d341ab9b618f6b5d9b52d690bd6c4")
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
!25 = !{!0, !26}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !28, line: 8, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/lkmm/rcu-MP.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "ee7d341ab9b618f6b5d9b52d690bd6c4")
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !{i32 7, !"Dwarf Version", i32 5}
!31 = !{i32 2, !"Debug Info Version", i32 3}
!32 = !{i32 1, !"wchar_size", i32 4}
!33 = !{i32 7, !"PIC Level", i32 2}
!34 = !{i32 7, !"PIE Level", i32 2}
!35 = !{i32 7, !"uwtable", i32 1}
!36 = !{i32 7, !"frame-pointer", i32 2}
!37 = !{!"Ubuntu clang version 14.0.6"}
!38 = distinct !DISubprogram(name: "P0", scope: !28, file: !28, line: 10, type: !39, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !41)
!39 = !DISubroutineType(types: !40)
!40 = !{!24, !24}
!41 = !{}
!42 = !DILocalVariable(name: "arg", arg: 1, scope: !38, file: !28, line: 10, type: !24)
!43 = !DILocation(line: 0, scope: !38)
!44 = !DILocation(line: 12, column: 2, scope: !38)
!45 = !DILocation(line: 13, column: 2, scope: !38)
!46 = !DILocation(line: 14, column: 2, scope: !38)
!47 = !DILocation(line: 15, column: 2, scope: !38)
!48 = distinct !DISubprogram(name: "P1", scope: !28, file: !28, line: 18, type: !39, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !41)
!49 = !DILocalVariable(name: "arg", arg: 1, scope: !48, file: !28, line: 18, type: !24)
!50 = !DILocation(line: 0, scope: !48)
!51 = !DILocation(line: 20, column: 2, scope: !48)
!52 = !DILocation(line: 21, column: 12, scope: !48)
!53 = !DILocalVariable(name: "r_y", scope: !48, file: !28, line: 21, type: !29)
!54 = !DILocation(line: 22, column: 12, scope: !48)
!55 = !DILocalVariable(name: "r_x", scope: !48, file: !28, line: 22, type: !29)
!56 = !DILocation(line: 23, column: 2, scope: !48)
!57 = !DILocation(line: 24, column: 5, scope: !58)
!58 = distinct !DILexicalBlock(scope: !59, file: !28, line: 24, column: 5)
!59 = distinct !DILexicalBlock(scope: !48, file: !28, line: 24, column: 5)
!60 = !DILocation(line: 25, column: 2, scope: !48)
!61 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 29, type: !62, scopeLine: 30, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !41)
!62 = !DISubroutineType(types: !63)
!63 = !{!29}
!64 = !DILocalVariable(name: "t1", scope: !61, file: !28, line: 34, type: !65)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !66, line: 27, baseType: !67)
!66 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!67 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!68 = !DILocation(line: 0, scope: !61)
!69 = !DILocation(line: 36, column: 2, scope: !61)
!70 = !DILocalVariable(name: "t2", scope: !61, file: !28, line: 34, type: !65)
!71 = !DILocation(line: 37, column: 2, scope: !61)
!72 = !DILocation(line: 39, column: 2, scope: !61)
