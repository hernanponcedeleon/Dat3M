; ModuleID = '/home/ponce/git/Dat3M/output/2+2W+onces+locked.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/2+2W+onces+locked.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.spinlock = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@lock_x = dso_local global %struct.spinlock zeroinitializer, align 4, !dbg !0
@x = dso_local global i32 0, align 4, !dbg !26
@lock_y = dso_local global %struct.spinlock zeroinitializer, align 4, !dbg !32
@y = dso_local global i32 0, align 4, !dbg !30
@.str = private unnamed_addr constant [38 x i8] c"!(READ_ONCE(x)==2 && READ_ONCE(y)==2)\00", align 1
@.str.1 = private unnamed_addr constant [58 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/2+2W+onces+locked.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !46 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !50, metadata !DIExpression()), !dbg !51
  %2 = call i32 @__LKMM_SPIN_LOCK(i32* noundef getelementptr inbounds (%struct.spinlock, %struct.spinlock* @lock_x, i64 0, i32 0)) #5, !dbg !52
  call void @__LKMM_STORE(i32* noundef nonnull @x, i32 noundef 2, i32 noundef 1) #5, !dbg !53
  %3 = call i32 @__LKMM_SPIN_UNLOCK(i32* noundef getelementptr inbounds (%struct.spinlock, %struct.spinlock* @lock_x, i64 0, i32 0)) #5, !dbg !54
  %4 = call i32 @__LKMM_SPIN_LOCK(i32* noundef getelementptr inbounds (%struct.spinlock, %struct.spinlock* @lock_y, i64 0, i32 0)) #5, !dbg !55
  call void @__LKMM_STORE(i32* noundef nonnull @y, i32 noundef 1, i32 noundef 1) #5, !dbg !56
  %5 = call i32 @__LKMM_SPIN_UNLOCK(i32* noundef getelementptr inbounds (%struct.spinlock, %struct.spinlock* @lock_y, i64 0, i32 0)) #5, !dbg !57
  ret i8* null, !dbg !58
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @__LKMM_SPIN_LOCK(i32* noundef) #2

declare void @__LKMM_STORE(i32* noundef, i32 noundef, i32 noundef) #2

declare i32 @__LKMM_SPIN_UNLOCK(i32* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !59 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !60, metadata !DIExpression()), !dbg !61
  %2 = call i32 @__LKMM_SPIN_LOCK(i32* noundef getelementptr inbounds (%struct.spinlock, %struct.spinlock* @lock_y, i64 0, i32 0)) #5, !dbg !62
  call void @__LKMM_STORE(i32* noundef nonnull @y, i32 noundef 2, i32 noundef 1) #5, !dbg !63
  %3 = call i32 @__LKMM_SPIN_UNLOCK(i32* noundef getelementptr inbounds (%struct.spinlock, %struct.spinlock* @lock_y, i64 0, i32 0)) #5, !dbg !64
  %4 = call i32 @__LKMM_SPIN_LOCK(i32* noundef getelementptr inbounds (%struct.spinlock, %struct.spinlock* @lock_x, i64 0, i32 0)) #5, !dbg !65
  call void @__LKMM_STORE(i32* noundef nonnull @x, i32 noundef 1, i32 noundef 1) #5, !dbg !66
  %5 = call i32 @__LKMM_SPIN_UNLOCK(i32* noundef getelementptr inbounds (%struct.spinlock, %struct.spinlock* @lock_x, i64 0, i32 0)) #5, !dbg !67
  ret i8* null, !dbg !68
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !69 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !72, metadata !DIExpression(DW_OP_deref)), !dbg !76
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #5, !dbg !77
  call void @llvm.dbg.value(metadata i64* %2, metadata !78, metadata !DIExpression(DW_OP_deref)), !dbg !76
  %4 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #5, !dbg !79
  %5 = load i64, i64* %1, align 8, !dbg !80
  call void @llvm.dbg.value(metadata i64 %5, metadata !72, metadata !DIExpression()), !dbg !76
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef null) #5, !dbg !81
  %7 = load i64, i64* %2, align 8, !dbg !82
  call void @llvm.dbg.value(metadata i64 %7, metadata !78, metadata !DIExpression()), !dbg !76
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #5, !dbg !83
  %9 = call i32 @__LKMM_LOAD(i32* noundef nonnull @x, i32 noundef 1) #5, !dbg !84
  %10 = icmp eq i32 %9, 2, !dbg !84
  br i1 %10, label %11, label %15, !dbg !84

11:                                               ; preds = %0
  %12 = call i32 @__LKMM_LOAD(i32* noundef nonnull @y, i32 noundef 1) #5, !dbg !84
  %13 = icmp eq i32 %12, 2, !dbg !84
  br i1 %13, label %14, label %15, !dbg !87

14:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([58 x i8], [58 x i8]* @.str.1, i64 0, i64 0), i32 noundef 41, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !84
  unreachable, !dbg !84

15:                                               ; preds = %0, %11
  ret i32 0, !dbg !88
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

declare i32 @__LKMM_LOAD(i32* noundef, i32 noundef) #2

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
!llvm.module.flags = !{!38, !39, !40, !41, !42, !43, !44}
!llvm.ident = !{!45}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "lock_x", scope: !2, file: !28, line: 7, type: !34, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/2+2W+onces+locked.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "06899129241a51c8f91baae86bd7c164")
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
!25 = !{!26, !30, !0, !32}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !28, line: 6, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/lkmm/2+2W+onces+locked.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "06899129241a51c8f91baae86bd7c164")
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !28, line: 6, type: !29, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "lock_y", scope: !2, file: !28, line: 7, type: !34, isLocal: false, isDefinition: true)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "spinlock_t", file: !6, line: 280, baseType: !35)
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "spinlock", file: !6, line: 278, size: 32, elements: !36)
!36 = !{!37}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "unused", scope: !35, file: !6, line: 279, baseType: !29, size: 32)
!38 = !{i32 7, !"Dwarf Version", i32 5}
!39 = !{i32 2, !"Debug Info Version", i32 3}
!40 = !{i32 1, !"wchar_size", i32 4}
!41 = !{i32 7, !"PIC Level", i32 2}
!42 = !{i32 7, !"PIE Level", i32 2}
!43 = !{i32 7, !"uwtable", i32 1}
!44 = !{i32 7, !"frame-pointer", i32 2}
!45 = !{!"Ubuntu clang version 14.0.6"}
!46 = distinct !DISubprogram(name: "thread_1", scope: !28, file: !28, line: 9, type: !47, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!47 = !DISubroutineType(types: !48)
!48 = !{!24, !24}
!49 = !{}
!50 = !DILocalVariable(name: "arg", arg: 1, scope: !46, file: !28, line: 9, type: !24)
!51 = !DILocation(line: 0, scope: !46)
!52 = !DILocation(line: 11, column: 2, scope: !46)
!53 = !DILocation(line: 12, column: 2, scope: !46)
!54 = !DILocation(line: 13, column: 2, scope: !46)
!55 = !DILocation(line: 14, column: 2, scope: !46)
!56 = !DILocation(line: 15, column: 2, scope: !46)
!57 = !DILocation(line: 16, column: 2, scope: !46)
!58 = !DILocation(line: 17, column: 2, scope: !46)
!59 = distinct !DISubprogram(name: "thread_2", scope: !28, file: !28, line: 20, type: !47, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!60 = !DILocalVariable(name: "arg", arg: 1, scope: !59, file: !28, line: 20, type: !24)
!61 = !DILocation(line: 0, scope: !59)
!62 = !DILocation(line: 22, column: 2, scope: !59)
!63 = !DILocation(line: 23, column: 2, scope: !59)
!64 = !DILocation(line: 24, column: 2, scope: !59)
!65 = !DILocation(line: 25, column: 2, scope: !59)
!66 = !DILocation(line: 26, column: 2, scope: !59)
!67 = !DILocation(line: 27, column: 2, scope: !59)
!68 = !DILocation(line: 28, column: 2, scope: !59)
!69 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 31, type: !70, scopeLine: 32, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!70 = !DISubroutineType(types: !71)
!71 = !{!29}
!72 = !DILocalVariable(name: "t1", scope: !69, file: !28, line: 33, type: !73)
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !74, line: 27, baseType: !75)
!74 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!75 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!76 = !DILocation(line: 0, scope: !69)
!77 = !DILocation(line: 35, column: 2, scope: !69)
!78 = !DILocalVariable(name: "t2", scope: !69, file: !28, line: 33, type: !73)
!79 = !DILocation(line: 36, column: 2, scope: !69)
!80 = !DILocation(line: 38, column: 15, scope: !69)
!81 = !DILocation(line: 38, column: 2, scope: !69)
!82 = !DILocation(line: 39, column: 15, scope: !69)
!83 = !DILocation(line: 39, column: 2, scope: !69)
!84 = !DILocation(line: 41, column: 2, scope: !85)
!85 = distinct !DILexicalBlock(scope: !86, file: !28, line: 41, column: 2)
!86 = distinct !DILexicalBlock(scope: !69, file: !28, line: 41, column: 2)
!87 = !DILocation(line: 41, column: 2, scope: !86)
!88 = !DILocation(line: 43, column: 2, scope: !69)
