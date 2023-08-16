; ModuleID = '/home/ponce/git/Dat3M/output/C-atomic-op-return-simple-02-2.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lkmm/C-atomic-op-return-simple-02-2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.atomic_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !0
@r0_0 = dso_local global i32 0, align 4, !dbg !40
@y = dso_local global %struct.atomic_t zeroinitializer, align 4, !dbg !32
@r1_0 = dso_local global i32 0, align 4, !dbg !42
@r0_1 = dso_local global i32 0, align 4, !dbg !44
@r1_1 = dso_local global i32 0, align 4, !dbg !46
@.str = private unnamed_addr constant [94 x i8] c"!(r0_0 == 1 && r1_0 == 0 && r0_1 == 1 && r1_1 == 0 && READ_ONCE(x) == 1 && READ_ONCE(y) == 1)\00", align 1
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/ponce/git/Dat3M/benchmarks/lkmm/C-atomic-op-return-simple-02-2.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !56 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !60, metadata !DIExpression()), !dbg !61
  %2 = call i32 @__LKMM_ATOMIC_OP_RETURN(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @x, i64 0, i32 0), i32 noundef 1, i32 noundef 0, i32 noundef 0) #5, !dbg !62
  store i32 %2, i32* @r0_0, align 4, !dbg !63
  %3 = call i32 @__LKMM_LOAD(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @y, i64 0, i32 0), i32 noundef 1) #5, !dbg !64
  store i32 %3, i32* @r1_0, align 4, !dbg !65
  ret i8* undef, !dbg !66
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @__LKMM_ATOMIC_OP_RETURN(i32* noundef, i32 noundef, i32 noundef, i32 noundef) #2

declare i32 @__LKMM_LOAD(i32* noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !67 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !68, metadata !DIExpression()), !dbg !69
  %2 = call i32 @__LKMM_ATOMIC_OP_RETURN(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @y, i64 0, i32 0), i32 noundef 1, i32 noundef 0, i32 noundef 0) #5, !dbg !70
  store i32 %2, i32* @r0_1, align 4, !dbg !71
  %3 = call i32 @__LKMM_LOAD(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @x, i64 0, i32 0), i32 noundef 1) #5, !dbg !72
  store i32 %3, i32* @r1_1, align 4, !dbg !73
  ret i8* undef, !dbg !74
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !75 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !78, metadata !DIExpression(DW_OP_deref)), !dbg !82
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #5, !dbg !83
  call void @llvm.dbg.value(metadata i64* %2, metadata !84, metadata !DIExpression(DW_OP_deref)), !dbg !82
  %4 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #5, !dbg !85
  %5 = load i64, i64* %1, align 8, !dbg !86
  call void @llvm.dbg.value(metadata i64 %5, metadata !78, metadata !DIExpression()), !dbg !82
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef null) #5, !dbg !87
  %7 = load i64, i64* %2, align 8, !dbg !88
  call void @llvm.dbg.value(metadata i64 %7, metadata !84, metadata !DIExpression()), !dbg !82
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #5, !dbg !89
  %9 = load i32, i32* @r0_0, align 4, !dbg !90
  %10 = icmp eq i32 %9, 1, !dbg !90
  %11 = load i32, i32* @r1_0, align 4, !dbg !90
  %12 = icmp eq i32 %11, 0, !dbg !90
  %or.cond = select i1 %10, i1 %12, i1 false, !dbg !90
  %13 = load i32, i32* @r0_1, align 4, !dbg !90
  %14 = icmp eq i32 %13, 1, !dbg !90
  %or.cond3 = select i1 %or.cond, i1 %14, i1 false, !dbg !90
  %15 = load i32, i32* @r1_1, align 4, !dbg !90
  %16 = icmp eq i32 %15, 0, !dbg !90
  %or.cond5 = select i1 %or.cond3, i1 %16, i1 false, !dbg !90
  br i1 %or.cond5, label %17, label %24, !dbg !90

17:                                               ; preds = %0
  %18 = call i32 @__LKMM_LOAD(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @x, i64 0, i32 0), i32 noundef 1) #5, !dbg !90
  %19 = icmp eq i32 %18, 1, !dbg !90
  br i1 %19, label %20, label %24, !dbg !90

20:                                               ; preds = %17
  %21 = call i32 @__LKMM_LOAD(i32* noundef getelementptr inbounds (%struct.atomic_t, %struct.atomic_t* @y, i64 0, i32 0), i32 noundef 1) #5, !dbg !90
  %22 = icmp eq i32 %21, 1, !dbg !90
  br i1 %22, label %23, label %24, !dbg !93

23:                                               ; preds = %20
  call void @__assert_fail(i8* noundef getelementptr inbounds ([94 x i8], [94 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i64 0, i64 0), i32 noundef 37, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !90
  unreachable, !dbg !90

24:                                               ; preds = %0, %17, %20
  ret i32 0, !dbg !94
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
!llvm.module.flags = !{!48, !49, !50, !51, !52, !53, !54}
!llvm.ident = !{!55}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !34, line: 6, type: !35, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !29, globals: !31, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lkmm/C-atomic-op-return-simple-02-2.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "35a79abdba3e7f5445158fe23aeb1eb4")
!4 = !{!5, !23}
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
!23 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "operation", file: !6, line: 20, baseType: !7, size: 32, elements: !24)
!24 = !{!25, !26, !27, !28}
!25 = !DIEnumerator(name: "op_add", value: 0)
!26 = !DIEnumerator(name: "op_sub", value: 1)
!27 = !DIEnumerator(name: "op_and", value: 2)
!28 = !DIEnumerator(name: "op_or", value: 3)
!29 = !{!30}
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!31 = !{!0, !32, !40, !42, !44, !46}
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !34, line: 7, type: !35, isLocal: false, isDefinition: true)
!34 = !DIFile(filename: "benchmarks/lkmm/C-atomic-op-return-simple-02-2.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "35a79abdba3e7f5445158fe23aeb1eb4")
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !6, line: 95, baseType: !36)
!36 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 93, size: 32, elements: !37)
!37 = !{!38}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !36, file: !6, line: 94, baseType: !39, size: 32)
!39 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "r0_0", scope: !2, file: !34, line: 9, type: !39, isLocal: false, isDefinition: true)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "r1_0", scope: !2, file: !34, line: 10, type: !39, isLocal: false, isDefinition: true)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "r0_1", scope: !2, file: !34, line: 12, type: !39, isLocal: false, isDefinition: true)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "r1_1", scope: !2, file: !34, line: 13, type: !39, isLocal: false, isDefinition: true)
!48 = !{i32 7, !"Dwarf Version", i32 5}
!49 = !{i32 2, !"Debug Info Version", i32 3}
!50 = !{i32 1, !"wchar_size", i32 4}
!51 = !{i32 7, !"PIC Level", i32 2}
!52 = !{i32 7, !"PIE Level", i32 2}
!53 = !{i32 7, !"uwtable", i32 1}
!54 = !{i32 7, !"frame-pointer", i32 2}
!55 = !{!"Ubuntu clang version 14.0.6"}
!56 = distinct !DISubprogram(name: "thread_1", scope: !34, file: !34, line: 15, type: !57, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !59)
!57 = !DISubroutineType(types: !58)
!58 = !{!30, !30}
!59 = !{}
!60 = !DILocalVariable(name: "unused", arg: 1, scope: !56, file: !34, line: 15, type: !30)
!61 = !DILocation(line: 0, scope: !56)
!62 = !DILocation(line: 17, column: 10, scope: !56)
!63 = !DILocation(line: 17, column: 8, scope: !56)
!64 = !DILocation(line: 18, column: 10, scope: !56)
!65 = !DILocation(line: 18, column: 8, scope: !56)
!66 = !DILocation(line: 19, column: 1, scope: !56)
!67 = distinct !DISubprogram(name: "thread_2", scope: !34, file: !34, line: 21, type: !57, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !59)
!68 = !DILocalVariable(name: "unused", arg: 1, scope: !67, file: !34, line: 21, type: !30)
!69 = !DILocation(line: 0, scope: !67)
!70 = !DILocation(line: 23, column: 10, scope: !67)
!71 = !DILocation(line: 23, column: 8, scope: !67)
!72 = !DILocation(line: 24, column: 10, scope: !67)
!73 = !DILocation(line: 24, column: 8, scope: !67)
!74 = !DILocation(line: 25, column: 1, scope: !67)
!75 = distinct !DISubprogram(name: "main", scope: !34, file: !34, line: 27, type: !76, scopeLine: 28, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !59)
!76 = !DISubroutineType(types: !77)
!77 = !{!39}
!78 = !DILocalVariable(name: "t1", scope: !75, file: !34, line: 29, type: !79)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !80, line: 27, baseType: !81)
!80 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!81 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!82 = !DILocation(line: 0, scope: !75)
!83 = !DILocation(line: 31, column: 2, scope: !75)
!84 = !DILocalVariable(name: "t2", scope: !75, file: !34, line: 29, type: !79)
!85 = !DILocation(line: 32, column: 2, scope: !75)
!86 = !DILocation(line: 34, column: 15, scope: !75)
!87 = !DILocation(line: 34, column: 2, scope: !75)
!88 = !DILocation(line: 35, column: 15, scope: !75)
!89 = !DILocation(line: 35, column: 2, scope: !75)
!90 = !DILocation(line: 37, column: 2, scope: !91)
!91 = distinct !DILexicalBlock(scope: !92, file: !34, line: 37, column: 2)
!92 = distinct !DILexicalBlock(scope: !75, file: !34, line: 37, column: 2)
!93 = !DILocation(line: 37, column: 2, scope: !92)
!94 = !DILocation(line: 39, column: 2, scope: !75)
