; ModuleID = '/home/ponce/git/Dat3M/output/clh_mutex.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/clh_mutex.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.clh_mutex_t = type { %struct.clh_mutex_node_*, [64 x i32], %struct.clh_mutex_node_* }
%struct.clh_mutex_node_ = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@lock = dso_local global %struct.clh_mutex_t zeroinitializer, align 8, !dbg !36
@shared = dso_local global i32 0, align 4, !dbg !33
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [51 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/clh_mutex.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @clh_mutex_init(%struct.clh_mutex_t* noundef %0) #0 !dbg !56 {
  call void @llvm.dbg.value(metadata %struct.clh_mutex_t* %0, metadata !61, metadata !DIExpression()), !dbg !62
  %2 = call %struct.clh_mutex_node_* @clh_mutex_create_node(i32 noundef 0), !dbg !63
  call void @llvm.dbg.value(metadata %struct.clh_mutex_node_* %2, metadata !64, metadata !DIExpression()), !dbg !62
  %3 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %0, i32 0, i32 0, !dbg !65
  store %struct.clh_mutex_node_* %2, %struct.clh_mutex_node_** %3, align 8, !dbg !66
  %4 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %0, i32 0, i32 2, !dbg !67
  store %struct.clh_mutex_node_* %2, %struct.clh_mutex_node_** %4, align 8, !dbg !68
  ret void, !dbg !69
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal %struct.clh_mutex_node_* @clh_mutex_create_node(i32 noundef %0) #0 !dbg !70 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !73, metadata !DIExpression()), !dbg !74
  %2 = call noalias i8* @malloc(i64 noundef 4) #5, !dbg !75
  %3 = bitcast i8* %2 to %struct.clh_mutex_node_*, !dbg !76
  call void @llvm.dbg.value(metadata %struct.clh_mutex_node_* %3, metadata !77, metadata !DIExpression()), !dbg !74
  %4 = getelementptr inbounds %struct.clh_mutex_node_, %struct.clh_mutex_node_* %3, i32 0, i32 0, !dbg !78
  store i32 %0, i32* %4, align 4, !dbg !79
  ret %struct.clh_mutex_node_* %3, !dbg !80
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @clh_mutex_destroy(%struct.clh_mutex_t* noundef %0) #0 !dbg !81 {
  call void @llvm.dbg.value(metadata %struct.clh_mutex_t* %0, metadata !82, metadata !DIExpression()), !dbg !83
  %2 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %0, i32 0, i32 2, !dbg !84
  %3 = bitcast %struct.clh_mutex_node_** %2 to i64*, !dbg !84
  %4 = load atomic i64, i64* %3 seq_cst, align 8, !dbg !84
  %5 = inttoptr i64 %4 to %struct.clh_mutex_node_*, !dbg !84
  %6 = bitcast %struct.clh_mutex_node_* %5 to i8*, !dbg !84
  call void @free(i8* noundef %6) #5, !dbg !85
  ret void, !dbg !86
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @clh_mutex_lock(%struct.clh_mutex_t* noundef %0) #0 !dbg !87 {
  call void @llvm.dbg.value(metadata %struct.clh_mutex_t* %0, metadata !88, metadata !DIExpression()), !dbg !89
  %2 = call %struct.clh_mutex_node_* @clh_mutex_create_node(i32 noundef 1), !dbg !90
  call void @llvm.dbg.value(metadata %struct.clh_mutex_node_* %2, metadata !91, metadata !DIExpression()), !dbg !89
  %3 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %0, i32 0, i32 2, !dbg !92
  %4 = bitcast %struct.clh_mutex_node_** %3 to i64*, !dbg !92
  %5 = ptrtoint %struct.clh_mutex_node_* %2 to i64, !dbg !92
  %6 = atomicrmw xchg i64* %4, i64 %5 seq_cst, align 8, !dbg !92
  %7 = inttoptr i64 %6 to %struct.clh_mutex_node_*, !dbg !92
  call void @llvm.dbg.value(metadata %struct.clh_mutex_node_* %7, metadata !93, metadata !DIExpression()), !dbg !89
  %8 = getelementptr inbounds %struct.clh_mutex_node_, %struct.clh_mutex_node_* %7, i32 0, i32 0, !dbg !94
  %9 = load atomic i32, i32* %8 monotonic, align 4, !dbg !95
  call void @llvm.dbg.value(metadata i32 %9, metadata !96, metadata !DIExpression()), !dbg !89
  %10 = icmp ne i32 %9, 0, !dbg !97
  br i1 %10, label %11, label %15, !dbg !99

11:                                               ; preds = %1, %13
  %.0 = phi i32 [ %14, %13 ], [ %9, %1 ], !dbg !89
  call void @llvm.dbg.value(metadata i32 %.0, metadata !96, metadata !DIExpression()), !dbg !89
  %12 = icmp ne i32 %.0, 0, !dbg !100
  br i1 %12, label %13, label %15, !dbg !100

13:                                               ; preds = %11
  %14 = load atomic i32, i32* %8 acquire, align 4, !dbg !102
  call void @llvm.dbg.value(metadata i32 %14, metadata !96, metadata !DIExpression()), !dbg !89
  br label %11, !dbg !100, !llvm.loop !104

15:                                               ; preds = %11, %1
  %16 = bitcast %struct.clh_mutex_node_* %7 to i8*, !dbg !107
  call void @free(i8* noundef %16) #5, !dbg !108
  %17 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %0, i32 0, i32 0, !dbg !109
  store %struct.clh_mutex_node_* %2, %struct.clh_mutex_node_** %17, align 8, !dbg !110
  ret void, !dbg !111
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @clh_mutex_unlock(%struct.clh_mutex_t* noundef %0) #0 !dbg !112 {
  call void @llvm.dbg.value(metadata %struct.clh_mutex_t* %0, metadata !113, metadata !DIExpression()), !dbg !114
  %2 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %0, i32 0, i32 0, !dbg !115
  %3 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %2, align 8, !dbg !115
  %4 = icmp eq %struct.clh_mutex_node_* %3, null, !dbg !117
  br i1 %4, label %7, label %5, !dbg !118

5:                                                ; preds = %1
  %6 = getelementptr inbounds %struct.clh_mutex_node_, %struct.clh_mutex_node_* %3, i32 0, i32 0, !dbg !119
  store atomic i32 0, i32* %6 release, align 4, !dbg !120
  br label %7, !dbg !121

7:                                                ; preds = %1, %5
  ret void, !dbg !121
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !122 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !125, metadata !DIExpression()), !dbg !126
  %2 = ptrtoint i8* %0 to i64, !dbg !127
  call void @llvm.dbg.value(metadata i64 %2, metadata !128, metadata !DIExpression()), !dbg !126
  call void @clh_mutex_lock(%struct.clh_mutex_t* noundef @lock), !dbg !129
  %3 = trunc i64 %2 to i32, !dbg !130
  store i32 %3, i32* @shared, align 4, !dbg !131
  call void @llvm.dbg.value(metadata i32 %3, metadata !132, metadata !DIExpression()), !dbg !126
  %4 = sext i32 %3 to i64, !dbg !133
  %5 = icmp eq i64 %4, %2, !dbg !133
  br i1 %5, label %7, label %6, !dbg !136

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #6, !dbg !133
  unreachable, !dbg !133

7:                                                ; preds = %1
  %8 = load i32, i32* @sum, align 4, !dbg !137
  %9 = add nsw i32 %8, 1, !dbg !137
  store i32 %9, i32* @sum, align 4, !dbg !137
  call void @clh_mutex_unlock(%struct.clh_mutex_t* noundef @lock), !dbg !138
  ret i8* null, !dbg !139
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !140 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !143, metadata !DIExpression()), !dbg !149
  call void @clh_mutex_init(%struct.clh_mutex_t* noundef @lock), !dbg !150
  call void @llvm.dbg.value(metadata i32 0, metadata !151, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.value(metadata i64 0, metadata !151, metadata !DIExpression()), !dbg !153
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !154
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #5, !dbg !156
  call void @llvm.dbg.value(metadata i64 1, metadata !151, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.value(metadata i64 1, metadata !151, metadata !DIExpression()), !dbg !153
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !154
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #5, !dbg !156
  call void @llvm.dbg.value(metadata i64 2, metadata !151, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.value(metadata i64 2, metadata !151, metadata !DIExpression()), !dbg !153
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !154
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #5, !dbg !156
  call void @llvm.dbg.value(metadata i64 3, metadata !151, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.value(metadata i64 3, metadata !151, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.value(metadata i32 0, metadata !157, metadata !DIExpression()), !dbg !159
  call void @llvm.dbg.value(metadata i64 0, metadata !157, metadata !DIExpression()), !dbg !159
  %8 = load i64, i64* %2, align 8, !dbg !160
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !162
  call void @llvm.dbg.value(metadata i64 1, metadata !157, metadata !DIExpression()), !dbg !159
  call void @llvm.dbg.value(metadata i64 1, metadata !157, metadata !DIExpression()), !dbg !159
  %10 = load i64, i64* %4, align 8, !dbg !160
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !162
  call void @llvm.dbg.value(metadata i64 2, metadata !157, metadata !DIExpression()), !dbg !159
  call void @llvm.dbg.value(metadata i64 2, metadata !157, metadata !DIExpression()), !dbg !159
  %12 = load i64, i64* %6, align 8, !dbg !160
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !162
  call void @llvm.dbg.value(metadata i64 3, metadata !157, metadata !DIExpression()), !dbg !159
  call void @llvm.dbg.value(metadata i64 3, metadata !157, metadata !DIExpression()), !dbg !159
  %14 = load i32, i32* @sum, align 4, !dbg !163
  %15 = icmp eq i32 %14, 3, !dbg !163
  br i1 %15, label %17, label %16, !dbg !166

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !163
  unreachable, !dbg !163

17:                                               ; preds = %0
  ret i32 0, !dbg !167
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
!llvm.module.flags = !{!48, !49, !50, !51, !52, !53, !54}
!llvm.ident = !{!55}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !35, line: 11, type: !31, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !32, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/clh_mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "3ad3285fca566d9de137b5cd10f9f38c")
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
!15 = !{!16, !17, !20, !23}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !18, line: 87, baseType: !19)
!18 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!19 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !21, line: 46, baseType: !22)
!21 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!22 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "clh_mutex_node_t", file: !25, line: 74, baseType: !26)
!25 = !DIFile(filename: "benchmarks/locks/clh_mutex.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "d88c40a0440b1421c9a593b20ac5ab10")
!26 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "clh_mutex_node_", file: !25, line: 76, size: 32, elements: !27)
!27 = !{!28}
!28 = !DIDerivedType(tag: DW_TAG_member, name: "succ_must_wait", scope: !26, file: !25, line: 78, baseType: !29, size: 32)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !30)
!30 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !31)
!31 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!32 = !{!0, !33, !36}
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !35, line: 9, type: !31, isLocal: false, isDefinition: true)
!35 = !DIFile(filename: "benchmarks/locks/clh_mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "3ad3285fca566d9de137b5cd10f9f38c")
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !35, line: 10, type: !38, isLocal: false, isDefinition: true)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "clh_mutex_t", file: !25, line: 86, baseType: !39)
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !25, line: 81, size: 2176, elements: !40)
!40 = !{!41, !42, !46}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "mynode", scope: !39, file: !25, line: 83, baseType: !23, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "padding", scope: !39, file: !25, line: 84, baseType: !43, size: 2048, offset: 64)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !31, size: 2048, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 64)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !39, file: !25, line: 85, baseType: !47, size: 64, offset: 2112)
!47 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!48 = !{i32 7, !"Dwarf Version", i32 5}
!49 = !{i32 2, !"Debug Info Version", i32 3}
!50 = !{i32 1, !"wchar_size", i32 4}
!51 = !{i32 7, !"PIC Level", i32 2}
!52 = !{i32 7, !"PIE Level", i32 2}
!53 = !{i32 7, !"uwtable", i32 1}
!54 = !{i32 7, !"frame-pointer", i32 2}
!55 = !{!"Ubuntu clang version 14.0.6"}
!56 = distinct !DISubprogram(name: "clh_mutex_init", scope: !25, file: !25, line: 101, type: !57, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!57 = !DISubroutineType(types: !58)
!58 = !{null, !59}
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!60 = !{}
!61 = !DILocalVariable(name: "self", arg: 1, scope: !56, file: !25, line: 101, type: !59)
!62 = !DILocation(line: 0, scope: !56)
!63 = !DILocation(line: 104, column: 31, scope: !56)
!64 = !DILocalVariable(name: "node", scope: !56, file: !25, line: 104, type: !23)
!65 = !DILocation(line: 105, column: 11, scope: !56)
!66 = !DILocation(line: 105, column: 18, scope: !56)
!67 = !DILocation(line: 106, column: 24, scope: !56)
!68 = !DILocation(line: 106, column: 5, scope: !56)
!69 = !DILocation(line: 107, column: 1, scope: !56)
!70 = distinct !DISubprogram(name: "clh_mutex_create_node", scope: !25, file: !25, line: 88, type: !71, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!71 = !DISubroutineType(types: !72)
!72 = !{!23, !31}
!73 = !DILocalVariable(name: "islocked", arg: 1, scope: !70, file: !25, line: 88, type: !31)
!74 = !DILocation(line: 0, scope: !70)
!75 = !DILocation(line: 90, column: 55, scope: !70)
!76 = !DILocation(line: 90, column: 35, scope: !70)
!77 = !DILocalVariable(name: "new_node", scope: !70, file: !25, line: 90, type: !23)
!78 = !DILocation(line: 91, column: 28, scope: !70)
!79 = !DILocation(line: 91, column: 5, scope: !70)
!80 = !DILocation(line: 92, column: 5, scope: !70)
!81 = distinct !DISubprogram(name: "clh_mutex_destroy", scope: !25, file: !25, line: 117, type: !57, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!82 = !DILocalVariable(name: "self", arg: 1, scope: !81, file: !25, line: 117, type: !59)
!83 = !DILocation(line: 0, scope: !81)
!84 = !DILocation(line: 119, column: 10, scope: !81)
!85 = !DILocation(line: 119, column: 5, scope: !81)
!86 = !DILocation(line: 120, column: 1, scope: !81)
!87 = distinct !DISubprogram(name: "clh_mutex_lock", scope: !25, file: !25, line: 129, type: !57, scopeLine: 130, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!88 = !DILocalVariable(name: "self", arg: 1, scope: !87, file: !25, line: 129, type: !59)
!89 = !DILocation(line: 0, scope: !87)
!90 = !DILocation(line: 132, column: 32, scope: !87)
!91 = !DILocalVariable(name: "mynode", scope: !87, file: !25, line: 132, type: !23)
!92 = !DILocation(line: 133, column: 30, scope: !87)
!93 = !DILocalVariable(name: "prev", scope: !87, file: !25, line: 133, type: !23)
!94 = !DILocation(line: 138, column: 53, scope: !87)
!95 = !DILocation(line: 138, column: 25, scope: !87)
!96 = !DILocalVariable(name: "prev_islocked", scope: !87, file: !25, line: 138, type: !31)
!97 = !DILocation(line: 142, column: 9, scope: !98)
!98 = distinct !DILexicalBlock(scope: !87, file: !25, line: 142, column: 9)
!99 = !DILocation(line: 142, column: 9, scope: !87)
!100 = !DILocation(line: 143, column: 9, scope: !101)
!101 = distinct !DILexicalBlock(scope: !98, file: !25, line: 142, column: 24)
!102 = !DILocation(line: 144, column: 29, scope: !103)
!103 = distinct !DILexicalBlock(scope: !101, file: !25, line: 143, column: 31)
!104 = distinct !{!104, !100, !105, !106}
!105 = !DILocation(line: 145, column: 9, scope: !101)
!106 = !{!"llvm.loop.mustprogress"}
!107 = !DILocation(line: 149, column: 10, scope: !87)
!108 = !DILocation(line: 149, column: 5, scope: !87)
!109 = !DILocation(line: 153, column: 11, scope: !87)
!110 = !DILocation(line: 153, column: 18, scope: !87)
!111 = !DILocation(line: 154, column: 1, scope: !87)
!112 = distinct !DISubprogram(name: "clh_mutex_unlock", scope: !25, file: !25, line: 163, type: !57, scopeLine: 164, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!113 = !DILocalVariable(name: "self", arg: 1, scope: !112, file: !25, line: 163, type: !59)
!114 = !DILocation(line: 0, scope: !112)
!115 = !DILocation(line: 168, column: 15, scope: !116)
!116 = distinct !DILexicalBlock(scope: !112, file: !25, line: 168, column: 9)
!117 = !DILocation(line: 168, column: 22, scope: !116)
!118 = !DILocation(line: 168, column: 9, scope: !112)
!119 = !DILocation(line: 172, column: 42, scope: !112)
!120 = !DILocation(line: 172, column: 5, scope: !112)
!121 = !DILocation(line: 173, column: 1, scope: !112)
!122 = distinct !DISubprogram(name: "thread_n", scope: !35, file: !35, line: 13, type: !123, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!123 = !DISubroutineType(types: !124)
!124 = !{!16, !16}
!125 = !DILocalVariable(name: "arg", arg: 1, scope: !122, file: !35, line: 13, type: !16)
!126 = !DILocation(line: 0, scope: !122)
!127 = !DILocation(line: 15, column: 23, scope: !122)
!128 = !DILocalVariable(name: "index", scope: !122, file: !35, line: 15, type: !17)
!129 = !DILocation(line: 17, column: 5, scope: !122)
!130 = !DILocation(line: 18, column: 14, scope: !122)
!131 = !DILocation(line: 18, column: 12, scope: !122)
!132 = !DILocalVariable(name: "r", scope: !122, file: !35, line: 19, type: !31)
!133 = !DILocation(line: 20, column: 5, scope: !134)
!134 = distinct !DILexicalBlock(scope: !135, file: !35, line: 20, column: 5)
!135 = distinct !DILexicalBlock(scope: !122, file: !35, line: 20, column: 5)
!136 = !DILocation(line: 20, column: 5, scope: !135)
!137 = !DILocation(line: 21, column: 8, scope: !122)
!138 = !DILocation(line: 22, column: 5, scope: !122)
!139 = !DILocation(line: 23, column: 5, scope: !122)
!140 = distinct !DISubprogram(name: "main", scope: !35, file: !35, line: 26, type: !141, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!141 = !DISubroutineType(types: !142)
!142 = !{!31}
!143 = !DILocalVariable(name: "t", scope: !140, file: !35, line: 28, type: !144)
!144 = !DICompositeType(tag: DW_TAG_array_type, baseType: !145, size: 192, elements: !147)
!145 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !146, line: 27, baseType: !22)
!146 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!147 = !{!148}
!148 = !DISubrange(count: 3)
!149 = !DILocation(line: 28, column: 15, scope: !140)
!150 = !DILocation(line: 30, column: 5, scope: !140)
!151 = !DILocalVariable(name: "i", scope: !152, file: !35, line: 32, type: !31)
!152 = distinct !DILexicalBlock(scope: !140, file: !35, line: 32, column: 5)
!153 = !DILocation(line: 0, scope: !152)
!154 = !DILocation(line: 33, column: 25, scope: !155)
!155 = distinct !DILexicalBlock(scope: !152, file: !35, line: 32, column: 5)
!156 = !DILocation(line: 33, column: 9, scope: !155)
!157 = !DILocalVariable(name: "i", scope: !158, file: !35, line: 35, type: !31)
!158 = distinct !DILexicalBlock(scope: !140, file: !35, line: 35, column: 5)
!159 = !DILocation(line: 0, scope: !158)
!160 = !DILocation(line: 36, column: 22, scope: !161)
!161 = distinct !DILexicalBlock(scope: !158, file: !35, line: 35, column: 5)
!162 = !DILocation(line: 36, column: 9, scope: !161)
!163 = !DILocation(line: 38, column: 5, scope: !164)
!164 = distinct !DILexicalBlock(scope: !165, file: !35, line: 38, column: 5)
!165 = distinct !DILexicalBlock(scope: !140, file: !35, line: 38, column: 5)
!166 = !DILocation(line: 38, column: 5, scope: !165)
!167 = !DILocation(line: 40, column: 5, scope: !140)
