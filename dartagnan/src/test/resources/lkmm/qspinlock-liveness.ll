; ModuleID = '/home/ponce/git/Dat3M/output/qspinlock-liveness.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/qspinlock-liveness.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !32
@z = dso_local global i32 0, align 4, !dbg !36

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !50 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !54, metadata !DIExpression()), !dbg !55
  %2 = call i32 @__LKMM_ATOMIC_FETCH_OP(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @x, i64 0, i32 0), i32 noundef 2, i32 noundef 4, i32 noundef 0) #4, !dbg !56
  call void @llvm.dbg.value(metadata i32 %2, metadata !57, metadata !DIExpression()), !dbg !55
  ret i8* null, !dbg !58
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @__LKMM_ATOMIC_FETCH_OP(i32* noundef, i32 noundef, i32 noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !59 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !60, metadata !DIExpression()), !dbg !61
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1, i32 noundef 1) #4, !dbg !62
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (%struct.atomic_t* @x to i8*), i32 noundef 1) #4, !dbg !63
  call void @llvm.dbg.value(metadata i32 %2, metadata !64, metadata !DIExpression()), !dbg !61
  call void @__LKMM_FENCE(i32 noundef 5) #4, !dbg !65
  %3 = call i32 @__LKMM_CMPXCHG(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @x, i64 0, i32 0), i32 noundef %2, i32 noundef 42, i32 noundef 0, i32 noundef 0) #4, !dbg !66
  call void @llvm.dbg.value(metadata i32 %3, metadata !67, metadata !DIExpression()), !dbg !61
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @z to i8*), i32 noundef 1, i32 noundef 1) #4, !dbg !68
  ret i8* null, !dbg !69
}

declare void @__LKMM_STORE(i8* noundef, i32 noundef, i32 noundef) #2

declare i32 @__LKMM_LOAD(i8* noundef, i32 noundef) #2

declare void @__LKMM_FENCE(i32 noundef) #2

declare i32 @__LKMM_CMPXCHG(i32* noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_3(i8* noundef %0) #0 !dbg !70 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !71, metadata !DIExpression()), !dbg !72
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @z to i8*), i32 noundef 2, i32 noundef 1) #4, !dbg !73
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (%struct.atomic_t* @x to i8*), i32 noundef 1) #4, !dbg !74
  call void @llvm.dbg.value(metadata i32 %2, metadata !75, metadata !DIExpression()), !dbg !72
  call void @__LKMM_FENCE(i32 noundef 5) #4, !dbg !76
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @y to i8*), i32 noundef 0, i32 noundef 1) #4, !dbg !77
  %3 = call i32 @__LKMM_CMPXCHG(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @x, i64 0, i32 0), i32 noundef %2, i32 noundef 24, i32 noundef 0, i32 noundef 0) #4, !dbg !78
  call void @llvm.dbg.value(metadata i32 %3, metadata !79, metadata !DIExpression()), !dbg !72
  br label %4, !dbg !80

4:                                                ; preds = %7, %1
  %5 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1) #4, !dbg !81
  %6 = icmp eq i32 %5, 1, !dbg !82
  br i1 %6, label %7, label %.critedge, !dbg !83

7:                                                ; preds = %4
  %8 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @z to i8*), i32 noundef 1) #4, !dbg !84
  %9 = icmp eq i32 %8, 2, !dbg !85
  br i1 %9, label %4, label %.critedge, !dbg !80, !llvm.loop !86

.critedge:                                        ; preds = %4, %7
  ret i8* null, !dbg !89
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !90 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !93, metadata !DIExpression(DW_OP_deref)), !dbg !97
  %4 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #4, !dbg !98
  call void @llvm.dbg.value(metadata i64* %2, metadata !99, metadata !DIExpression(DW_OP_deref)), !dbg !97
  %5 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #4, !dbg !100
  call void @llvm.dbg.value(metadata i64* %3, metadata !101, metadata !DIExpression(DW_OP_deref)), !dbg !97
  %6 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_3, i8* noundef null) #4, !dbg !102
  ret i32 0, !dbg !103
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!42, !43, !44, !45, !46, !47, !48}
!llvm.ident = !{!49}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !34, line: 7, type: !38, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !31, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/qspinlock-liveness.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "62cffcfdbbfe2e2b84cb01226603616c")
!4 = !{!5, !23}
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
!23 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "operation", file: !6, line: 20, baseType: !7, size: 32, elements: !24)
!24 = !{!25, !26, !27, !28}
!25 = !DIEnumerator(name: "op_add", value: 0)
!26 = !DIEnumerator(name: "op_sub", value: 1)
!27 = !DIEnumerator(name: "op_and", value: 2)
!28 = !DIEnumerator(name: "op_or", value: 3)
!29 = !{!30}
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!31 = !{!32, !36, !0}
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !34, line: 6, type: !35, isLocal: false, isDefinition: true)
!34 = !DIFile(filename: "benchmarks/lkmm/qspinlock-liveness.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "62cffcfdbbfe2e2b84cb01226603616c")
!35 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !34, line: 6, type: !35, isLocal: false, isDefinition: true)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 95, baseType: !39)
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 93, size: 32, elements: !40)
!40 = !{!41}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !39, file: !6, line: 94, baseType: !35, size: 32)
!42 = !{i32 7, !"Dwarf Version", i32 5}
!43 = !{i32 2, !"Debug Info Version", i32 3}
!44 = !{i32 1, !"wchar_size", i32 4}
!45 = !{i32 7, !"PIC Level", i32 2}
!46 = !{i32 7, !"PIE Level", i32 2}
!47 = !{i32 7, !"uwtable", i32 1}
!48 = !{i32 7, !"frame-pointer", i32 2}
!49 = !{!"Ubuntu clang version 14.0.6"}
!50 = distinct !DISubprogram(name: "thread_1", scope: !34, file: !34, line: 9, type: !51, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!51 = !DISubroutineType(types: !52)
!52 = !{!30, !30}
!53 = !{}
!54 = !DILocalVariable(name: "unused", arg: 1, scope: !50, file: !34, line: 9, type: !30)
!55 = !DILocation(line: 0, scope: !50)
!56 = !DILocation(line: 12, column: 14, scope: !50)
!57 = !DILocalVariable(name: "r0", scope: !50, file: !34, line: 12, type: !35)
!58 = !DILocation(line: 13, column: 5, scope: !50)
!59 = distinct !DISubprogram(name: "thread_2", scope: !34, file: !34, line: 16, type: !51, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!60 = !DILocalVariable(name: "unused", arg: 1, scope: !59, file: !34, line: 16, type: !30)
!61 = !DILocation(line: 0, scope: !59)
!62 = !DILocation(line: 19, column: 5, scope: !59)
!63 = !DILocation(line: 21, column: 14, scope: !59)
!64 = !DILocalVariable(name: "r0", scope: !59, file: !34, line: 21, type: !35)
!65 = !DILocation(line: 23, column: 5, scope: !59)
!66 = !DILocation(line: 25, column: 14, scope: !59)
!67 = !DILocalVariable(name: "r1", scope: !59, file: !34, line: 25, type: !35)
!68 = !DILocation(line: 27, column: 5, scope: !59)
!69 = !DILocation(line: 28, column: 5, scope: !59)
!70 = distinct !DISubprogram(name: "thread_3", scope: !34, file: !34, line: 31, type: !51, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!71 = !DILocalVariable(name: "unused", arg: 1, scope: !70, file: !34, line: 31, type: !30)
!72 = !DILocation(line: 0, scope: !70)
!73 = !DILocation(line: 34, column: 5, scope: !70)
!74 = !DILocation(line: 36, column: 14, scope: !70)
!75 = !DILocalVariable(name: "r0", scope: !70, file: !34, line: 36, type: !35)
!76 = !DILocation(line: 38, column: 5, scope: !70)
!77 = !DILocation(line: 40, column: 5, scope: !70)
!78 = !DILocation(line: 42, column: 14, scope: !70)
!79 = !DILocalVariable(name: "r1", scope: !70, file: !34, line: 42, type: !35)
!80 = !DILocation(line: 44, column: 5, scope: !70)
!81 = !DILocation(line: 44, column: 11, scope: !70)
!82 = !DILocation(line: 44, column: 24, scope: !70)
!83 = !DILocation(line: 44, column: 29, scope: !70)
!84 = !DILocation(line: 44, column: 33, scope: !70)
!85 = !DILocation(line: 44, column: 46, scope: !70)
!86 = distinct !{!86, !80, !87, !88}
!87 = !DILocation(line: 44, column: 54, scope: !70)
!88 = !{!"llvm.loop.mustprogress"}
!89 = !DILocation(line: 45, column: 5, scope: !70)
!90 = distinct !DISubprogram(name: "main", scope: !34, file: !34, line: 48, type: !91, scopeLine: 49, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !53)
!91 = !DISubroutineType(types: !92)
!92 = !{!35}
!93 = !DILocalVariable(name: "t1", scope: !90, file: !34, line: 50, type: !94)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !95, line: 27, baseType: !96)
!95 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!96 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!97 = !DILocation(line: 0, scope: !90)
!98 = !DILocation(line: 52, column: 2, scope: !90)
!99 = !DILocalVariable(name: "t2", scope: !90, file: !34, line: 50, type: !94)
!100 = !DILocation(line: 53, column: 2, scope: !90)
!101 = !DILocalVariable(name: "t3", scope: !90, file: !34, line: 50, type: !94)
!102 = !DILocation(line: 54, column: 2, scope: !90)
!103 = !DILocation(line: 56, column: 2, scope: !90)
