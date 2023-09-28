; ModuleID = 'output/clh_mutex.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/clh_mutex.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.clh_mutex_t = type { %struct.clh_mutex_node_*, [64 x i32], %struct.clh_mutex_node_* }
%struct.clh_mutex_node_ = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@lock = dso_local global %struct.clh_mutex_t zeroinitializer, align 8, !dbg !33
@shared = dso_local global i32 0, align 4, !dbg !30
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [51 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/clh_mutex.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @clh_mutex_init(%struct.clh_mutex_t* noundef %0) #0 !dbg !53 {
  call void @llvm.dbg.value(metadata %struct.clh_mutex_t* %0, metadata !58, metadata !DIExpression()), !dbg !59
  %2 = call %struct.clh_mutex_node_* @clh_mutex_create_node(i32 noundef 0), !dbg !60
  call void @llvm.dbg.value(metadata %struct.clh_mutex_node_* %2, metadata !61, metadata !DIExpression()), !dbg !59
  %3 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %0, i32 0, i32 0, !dbg !62
  store %struct.clh_mutex_node_* %2, %struct.clh_mutex_node_** %3, align 8, !dbg !63
  %4 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %0, i32 0, i32 2, !dbg !64
  store %struct.clh_mutex_node_* %2, %struct.clh_mutex_node_** %4, align 8, !dbg !65
  ret void, !dbg !66
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal %struct.clh_mutex_node_* @clh_mutex_create_node(i32 noundef %0) #0 !dbg !67 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !70, metadata !DIExpression()), !dbg !71
  %2 = call noalias i8* @malloc(i64 noundef 4) #5, !dbg !72
  %3 = bitcast i8* %2 to %struct.clh_mutex_node_*, !dbg !73
  call void @llvm.dbg.value(metadata %struct.clh_mutex_node_* %3, metadata !74, metadata !DIExpression()), !dbg !71
  %4 = getelementptr inbounds %struct.clh_mutex_node_, %struct.clh_mutex_node_* %3, i32 0, i32 0, !dbg !75
  store i32 %0, i32* %4, align 4, !dbg !76
  ret %struct.clh_mutex_node_* %3, !dbg !77
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @clh_mutex_destroy(%struct.clh_mutex_t* noundef %0) #0 !dbg !78 {
  call void @llvm.dbg.value(metadata %struct.clh_mutex_t* %0, metadata !79, metadata !DIExpression()), !dbg !80
  %2 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %0, i32 0, i32 2, !dbg !81
  %3 = bitcast %struct.clh_mutex_node_** %2 to i64*, !dbg !81
  %4 = load atomic i64, i64* %3 seq_cst, align 8, !dbg !81
  %5 = inttoptr i64 %4 to %struct.clh_mutex_node_*, !dbg !81
  %6 = bitcast %struct.clh_mutex_node_* %5 to i8*, !dbg !81
  call void @free(i8* noundef %6) #5, !dbg !82
  ret void, !dbg !83
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @clh_mutex_lock(%struct.clh_mutex_t* noundef %0) #0 !dbg !84 {
  call void @llvm.dbg.value(metadata %struct.clh_mutex_t* %0, metadata !85, metadata !DIExpression()), !dbg !86
  %2 = call %struct.clh_mutex_node_* @clh_mutex_create_node(i32 noundef 1), !dbg !87
  call void @llvm.dbg.value(metadata %struct.clh_mutex_node_* %2, metadata !88, metadata !DIExpression()), !dbg !86
  %3 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %0, i32 0, i32 2, !dbg !89
  %4 = bitcast %struct.clh_mutex_node_** %3 to i64*, !dbg !89
  %5 = ptrtoint %struct.clh_mutex_node_* %2 to i64, !dbg !89
  %6 = atomicrmw xchg i64* %4, i64 %5 seq_cst, align 8, !dbg !89
  %7 = inttoptr i64 %6 to %struct.clh_mutex_node_*, !dbg !89
  call void @llvm.dbg.value(metadata %struct.clh_mutex_node_* %7, metadata !90, metadata !DIExpression()), !dbg !86
  %8 = getelementptr inbounds %struct.clh_mutex_node_, %struct.clh_mutex_node_* %7, i32 0, i32 0, !dbg !91
  %9 = load atomic i32, i32* %8 acquire, align 4, !dbg !92
  call void @llvm.dbg.value(metadata i32 %9, metadata !93, metadata !DIExpression()), !dbg !86
  %10 = icmp ne i32 %9, 0, !dbg !94
  br i1 %10, label %11, label %15, !dbg !96

11:                                               ; preds = %1, %13
  %.0 = phi i32 [ %14, %13 ], [ %9, %1 ], !dbg !86
  call void @llvm.dbg.value(metadata i32 %.0, metadata !93, metadata !DIExpression()), !dbg !86
  %12 = icmp ne i32 %.0, 0, !dbg !97
  br i1 %12, label %13, label %15, !dbg !97

13:                                               ; preds = %11
  %14 = load atomic i32, i32* %8 acquire, align 4, !dbg !99
  call void @llvm.dbg.value(metadata i32 %14, metadata !93, metadata !DIExpression()), !dbg !86
  br label %11, !dbg !97, !llvm.loop !101

15:                                               ; preds = %11, %1
  %16 = bitcast %struct.clh_mutex_node_* %7 to i8*, !dbg !104
  call void @free(i8* noundef %16) #5, !dbg !105
  %17 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %0, i32 0, i32 0, !dbg !106
  store %struct.clh_mutex_node_* %2, %struct.clh_mutex_node_** %17, align 8, !dbg !107
  ret void, !dbg !108
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @clh_mutex_unlock(%struct.clh_mutex_t* noundef %0) #0 !dbg !109 {
  call void @llvm.dbg.value(metadata %struct.clh_mutex_t* %0, metadata !110, metadata !DIExpression()), !dbg !111
  %2 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %0, i32 0, i32 0, !dbg !112
  %3 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %2, align 8, !dbg !112
  %4 = icmp eq %struct.clh_mutex_node_* %3, null, !dbg !114
  br i1 %4, label %7, label %5, !dbg !115

5:                                                ; preds = %1
  %6 = getelementptr inbounds %struct.clh_mutex_node_, %struct.clh_mutex_node_* %3, i32 0, i32 0, !dbg !116
  store atomic i32 0, i32* %6 release, align 4, !dbg !117
  br label %7, !dbg !118

7:                                                ; preds = %1, %5
  ret void, !dbg !118
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !119 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !122, metadata !DIExpression()), !dbg !123
  %2 = ptrtoint i8* %0 to i64, !dbg !124
  call void @llvm.dbg.value(metadata i64 %2, metadata !125, metadata !DIExpression()), !dbg !123
  call void @clh_mutex_lock(%struct.clh_mutex_t* noundef @lock), !dbg !126
  %3 = trunc i64 %2 to i32, !dbg !127
  store i32 %3, i32* @shared, align 4, !dbg !128
  call void @llvm.dbg.value(metadata i32 %3, metadata !129, metadata !DIExpression()), !dbg !123
  %4 = sext i32 %3 to i64, !dbg !130
  %5 = icmp eq i64 %4, %2, !dbg !130
  br i1 %5, label %7, label %6, !dbg !133

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #6, !dbg !130
  unreachable, !dbg !130

7:                                                ; preds = %1
  %8 = load i32, i32* @sum, align 4, !dbg !134
  %9 = add nsw i32 %8, 1, !dbg !134
  store i32 %9, i32* @sum, align 4, !dbg !134
  call void @clh_mutex_unlock(%struct.clh_mutex_t* noundef @lock), !dbg !135
  ret i8* null, !dbg !136
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !137 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !140, metadata !DIExpression()), !dbg !147
  call void @clh_mutex_init(%struct.clh_mutex_t* noundef @lock), !dbg !148
  call void @llvm.dbg.value(metadata i32 0, metadata !149, metadata !DIExpression()), !dbg !151
  call void @llvm.dbg.value(metadata i64 0, metadata !149, metadata !DIExpression()), !dbg !151
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !152
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #5, !dbg !154
  call void @llvm.dbg.value(metadata i64 1, metadata !149, metadata !DIExpression()), !dbg !151
  call void @llvm.dbg.value(metadata i64 1, metadata !149, metadata !DIExpression()), !dbg !151
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !152
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #5, !dbg !154
  call void @llvm.dbg.value(metadata i64 2, metadata !149, metadata !DIExpression()), !dbg !151
  call void @llvm.dbg.value(metadata i64 2, metadata !149, metadata !DIExpression()), !dbg !151
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !152
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #5, !dbg !154
  call void @llvm.dbg.value(metadata i64 3, metadata !149, metadata !DIExpression()), !dbg !151
  call void @llvm.dbg.value(metadata i64 3, metadata !149, metadata !DIExpression()), !dbg !151
  call void @llvm.dbg.value(metadata i32 0, metadata !155, metadata !DIExpression()), !dbg !157
  call void @llvm.dbg.value(metadata i64 0, metadata !155, metadata !DIExpression()), !dbg !157
  %8 = load i64, i64* %2, align 8, !dbg !158
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !160
  call void @llvm.dbg.value(metadata i64 1, metadata !155, metadata !DIExpression()), !dbg !157
  call void @llvm.dbg.value(metadata i64 1, metadata !155, metadata !DIExpression()), !dbg !157
  %10 = load i64, i64* %4, align 8, !dbg !158
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !160
  call void @llvm.dbg.value(metadata i64 2, metadata !155, metadata !DIExpression()), !dbg !157
  call void @llvm.dbg.value(metadata i64 2, metadata !155, metadata !DIExpression()), !dbg !157
  %12 = load i64, i64* %6, align 8, !dbg !158
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !160
  call void @llvm.dbg.value(metadata i64 3, metadata !155, metadata !DIExpression()), !dbg !157
  call void @llvm.dbg.value(metadata i64 3, metadata !155, metadata !DIExpression()), !dbg !157
  %14 = load i32, i32* @sum, align 4, !dbg !161
  %15 = icmp eq i32 %14, 3, !dbg !161
  br i1 %15, label %17, label %16, !dbg !164

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !161
  unreachable, !dbg !161

17:                                               ; preds = %0
  ret i32 0, !dbg !165
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!45, !46, !47, !48, !49, !50, !51}
!llvm.ident = !{!52}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !32, line: 11, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !29, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/clh_mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "51cac0d4cd603dc7c2f7485c0bafbfbf")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 56, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "de5d66a1ef2f5448cc1919ff39db92bc")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16, !17, !20}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !18, line: 87, baseType: !19)
!18 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!19 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "clh_mutex_node_t", file: !22, line: 74, baseType: !23)
!22 = !DIFile(filename: "benchmarks/locks/clh_mutex.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "d88c40a0440b1421c9a593b20ac5ab10")
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "clh_mutex_node_", file: !22, line: 76, size: 32, elements: !24)
!24 = !{!25}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "succ_must_wait", scope: !23, file: !22, line: 78, baseType: !26, size: 32)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !27)
!27 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !28)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !{!0, !30, !33}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !32, line: 9, type: !28, isLocal: false, isDefinition: true)
!32 = !DIFile(filename: "benchmarks/locks/clh_mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "51cac0d4cd603dc7c2f7485c0bafbfbf")
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !32, line: 10, type: !35, isLocal: false, isDefinition: true)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "clh_mutex_t", file: !22, line: 86, baseType: !36)
!36 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !22, line: 81, size: 2176, elements: !37)
!37 = !{!38, !39, !43}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "mynode", scope: !36, file: !22, line: 83, baseType: !20, size: 64)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "padding", scope: !36, file: !22, line: 84, baseType: !40, size: 2048, offset: 64)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 2048, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 64)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !36, file: !22, line: 85, baseType: !44, size: 64, offset: 2112)
!44 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !20)
!45 = !{i32 7, !"Dwarf Version", i32 5}
!46 = !{i32 2, !"Debug Info Version", i32 3}
!47 = !{i32 1, !"wchar_size", i32 4}
!48 = !{i32 7, !"PIC Level", i32 2}
!49 = !{i32 7, !"PIE Level", i32 2}
!50 = !{i32 7, !"uwtable", i32 1}
!51 = !{i32 7, !"frame-pointer", i32 2}
!52 = !{!"Ubuntu clang version 14.0.6"}
!53 = distinct !DISubprogram(name: "clh_mutex_init", scope: !22, file: !22, line: 101, type: !54, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!54 = !DISubroutineType(types: !55)
!55 = !{null, !56}
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!57 = !{}
!58 = !DILocalVariable(name: "self", arg: 1, scope: !53, file: !22, line: 101, type: !56)
!59 = !DILocation(line: 0, scope: !53)
!60 = !DILocation(line: 104, column: 31, scope: !53)
!61 = !DILocalVariable(name: "node", scope: !53, file: !22, line: 104, type: !20)
!62 = !DILocation(line: 105, column: 11, scope: !53)
!63 = !DILocation(line: 105, column: 18, scope: !53)
!64 = !DILocation(line: 106, column: 24, scope: !53)
!65 = !DILocation(line: 106, column: 5, scope: !53)
!66 = !DILocation(line: 107, column: 1, scope: !53)
!67 = distinct !DISubprogram(name: "clh_mutex_create_node", scope: !22, file: !22, line: 88, type: !68, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !57)
!68 = !DISubroutineType(types: !69)
!69 = !{!20, !28}
!70 = !DILocalVariable(name: "islocked", arg: 1, scope: !67, file: !22, line: 88, type: !28)
!71 = !DILocation(line: 0, scope: !67)
!72 = !DILocation(line: 90, column: 55, scope: !67)
!73 = !DILocation(line: 90, column: 35, scope: !67)
!74 = !DILocalVariable(name: "new_node", scope: !67, file: !22, line: 90, type: !20)
!75 = !DILocation(line: 91, column: 28, scope: !67)
!76 = !DILocation(line: 91, column: 5, scope: !67)
!77 = !DILocation(line: 92, column: 5, scope: !67)
!78 = distinct !DISubprogram(name: "clh_mutex_destroy", scope: !22, file: !22, line: 117, type: !54, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!79 = !DILocalVariable(name: "self", arg: 1, scope: !78, file: !22, line: 117, type: !56)
!80 = !DILocation(line: 0, scope: !78)
!81 = !DILocation(line: 119, column: 10, scope: !78)
!82 = !DILocation(line: 119, column: 5, scope: !78)
!83 = !DILocation(line: 120, column: 1, scope: !78)
!84 = distinct !DISubprogram(name: "clh_mutex_lock", scope: !22, file: !22, line: 129, type: !54, scopeLine: 130, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!85 = !DILocalVariable(name: "self", arg: 1, scope: !84, file: !22, line: 129, type: !56)
!86 = !DILocation(line: 0, scope: !84)
!87 = !DILocation(line: 132, column: 32, scope: !84)
!88 = !DILocalVariable(name: "mynode", scope: !84, file: !22, line: 132, type: !20)
!89 = !DILocation(line: 133, column: 30, scope: !84)
!90 = !DILocalVariable(name: "prev", scope: !84, file: !22, line: 133, type: !20)
!91 = !DILocation(line: 140, column: 53, scope: !84)
!92 = !DILocation(line: 140, column: 25, scope: !84)
!93 = !DILocalVariable(name: "prev_islocked", scope: !84, file: !22, line: 140, type: !28)
!94 = !DILocation(line: 142, column: 9, scope: !95)
!95 = distinct !DILexicalBlock(scope: !84, file: !22, line: 142, column: 9)
!96 = !DILocation(line: 142, column: 9, scope: !84)
!97 = !DILocation(line: 143, column: 9, scope: !98)
!98 = distinct !DILexicalBlock(scope: !95, file: !22, line: 142, column: 24)
!99 = !DILocation(line: 144, column: 29, scope: !100)
!100 = distinct !DILexicalBlock(scope: !98, file: !22, line: 143, column: 31)
!101 = distinct !{!101, !97, !102, !103}
!102 = !DILocation(line: 145, column: 9, scope: !98)
!103 = !{!"llvm.loop.mustprogress"}
!104 = !DILocation(line: 149, column: 10, scope: !84)
!105 = !DILocation(line: 149, column: 5, scope: !84)
!106 = !DILocation(line: 153, column: 11, scope: !84)
!107 = !DILocation(line: 153, column: 18, scope: !84)
!108 = !DILocation(line: 154, column: 1, scope: !84)
!109 = distinct !DISubprogram(name: "clh_mutex_unlock", scope: !22, file: !22, line: 163, type: !54, scopeLine: 164, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!110 = !DILocalVariable(name: "self", arg: 1, scope: !109, file: !22, line: 163, type: !56)
!111 = !DILocation(line: 0, scope: !109)
!112 = !DILocation(line: 168, column: 15, scope: !113)
!113 = distinct !DILexicalBlock(scope: !109, file: !22, line: 168, column: 9)
!114 = !DILocation(line: 168, column: 22, scope: !113)
!115 = !DILocation(line: 168, column: 9, scope: !109)
!116 = !DILocation(line: 172, column: 42, scope: !109)
!117 = !DILocation(line: 172, column: 5, scope: !109)
!118 = !DILocation(line: 173, column: 1, scope: !109)
!119 = distinct !DISubprogram(name: "thread_n", scope: !32, file: !32, line: 13, type: !120, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!120 = !DISubroutineType(types: !121)
!121 = !{!16, !16}
!122 = !DILocalVariable(name: "arg", arg: 1, scope: !119, file: !32, line: 13, type: !16)
!123 = !DILocation(line: 0, scope: !119)
!124 = !DILocation(line: 15, column: 23, scope: !119)
!125 = !DILocalVariable(name: "index", scope: !119, file: !32, line: 15, type: !17)
!126 = !DILocation(line: 17, column: 5, scope: !119)
!127 = !DILocation(line: 18, column: 14, scope: !119)
!128 = !DILocation(line: 18, column: 12, scope: !119)
!129 = !DILocalVariable(name: "r", scope: !119, file: !32, line: 19, type: !28)
!130 = !DILocation(line: 20, column: 5, scope: !131)
!131 = distinct !DILexicalBlock(scope: !132, file: !32, line: 20, column: 5)
!132 = distinct !DILexicalBlock(scope: !119, file: !32, line: 20, column: 5)
!133 = !DILocation(line: 20, column: 5, scope: !132)
!134 = !DILocation(line: 21, column: 8, scope: !119)
!135 = !DILocation(line: 22, column: 5, scope: !119)
!136 = !DILocation(line: 23, column: 5, scope: !119)
!137 = distinct !DISubprogram(name: "main", scope: !32, file: !32, line: 26, type: !138, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!138 = !DISubroutineType(types: !139)
!139 = !{!28}
!140 = !DILocalVariable(name: "t", scope: !137, file: !32, line: 28, type: !141)
!141 = !DICompositeType(tag: DW_TAG_array_type, baseType: !142, size: 192, elements: !145)
!142 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !143, line: 27, baseType: !144)
!143 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!144 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!145 = !{!146}
!146 = !DISubrange(count: 3)
!147 = !DILocation(line: 28, column: 15, scope: !137)
!148 = !DILocation(line: 30, column: 5, scope: !137)
!149 = !DILocalVariable(name: "i", scope: !150, file: !32, line: 32, type: !28)
!150 = distinct !DILexicalBlock(scope: !137, file: !32, line: 32, column: 5)
!151 = !DILocation(line: 0, scope: !150)
!152 = !DILocation(line: 33, column: 25, scope: !153)
!153 = distinct !DILexicalBlock(scope: !150, file: !32, line: 32, column: 5)
!154 = !DILocation(line: 33, column: 9, scope: !153)
!155 = !DILocalVariable(name: "i", scope: !156, file: !32, line: 35, type: !28)
!156 = distinct !DILexicalBlock(scope: !137, file: !32, line: 35, column: 5)
!157 = !DILocation(line: 0, scope: !156)
!158 = !DILocation(line: 36, column: 22, scope: !159)
!159 = distinct !DILexicalBlock(scope: !156, file: !32, line: 35, column: 5)
!160 = !DILocation(line: 36, column: 9, scope: !159)
!161 = !DILocation(line: 38, column: 5, scope: !162)
!162 = distinct !DILexicalBlock(scope: !163, file: !32, line: 38, column: 5)
!163 = distinct !DILexicalBlock(scope: !137, file: !32, line: 38, column: 5)
!164 = !DILocation(line: 38, column: 5, scope: !163)
!165 = !DILocation(line: 40, column: 5, scope: !137)
