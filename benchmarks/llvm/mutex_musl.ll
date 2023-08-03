; ModuleID = 'output/mutex_musl.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/mutex_musl.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.mutex_t = type { i32, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@mutex = dso_local global %struct.mutex_t zeroinitializer, align 4, !dbg !25
@shared = dso_local global i32 0, align 4, !dbg !21
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [52 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/mutex_musl.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@sig = internal global i32 0, align 4, !dbg !35

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !46 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !50, metadata !DIExpression()), !dbg !51
  %2 = ptrtoint i8* %0 to i64, !dbg !52
  call void @llvm.dbg.value(metadata i64 %2, metadata !53, metadata !DIExpression()), !dbg !51
  call void @mutex_lock(%struct.mutex_t* noundef @mutex), !dbg !54
  %3 = trunc i64 %2 to i32, !dbg !55
  store i32 %3, i32* @shared, align 4, !dbg !56
  call void @llvm.dbg.value(metadata i32 %3, metadata !57, metadata !DIExpression()), !dbg !51
  %4 = sext i32 %3 to i64, !dbg !58
  %5 = icmp eq i64 %4, %2, !dbg !58
  br i1 %5, label %7, label %6, !dbg !61

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5, !dbg !58
  unreachable, !dbg !58

7:                                                ; preds = %1
  %8 = load i32, i32* @sum, align 4, !dbg !62
  %9 = add nsw i32 %8, 1, !dbg !62
  store i32 %9, i32* @sum, align 4, !dbg !62
  call void @mutex_unlock(%struct.mutex_t* noundef @mutex), !dbg !63
  ret i8* null, !dbg !64
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @mutex_lock(%struct.mutex_t* noundef %0) #0 !dbg !65 {
  call void @llvm.dbg.value(metadata %struct.mutex_t* %0, metadata !69, metadata !DIExpression()), !dbg !70
  %2 = call i32 @mutex_lock_fastpath(%struct.mutex_t* noundef %0), !dbg !71
  %3 = icmp ne i32 %2, 0, !dbg !71
  br i1 %3, label %.loopexit, label %4, !dbg !73

4:                                                ; preds = %1, %15
  %5 = call i32 @mutex_lock_slowpath_check(%struct.mutex_t* noundef %0), !dbg !74
  %6 = icmp eq i32 %5, 0, !dbg !75
  br i1 %6, label %7, label %.loopexit, !dbg !76

7:                                                ; preds = %4
  %8 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 1, !dbg !77
  %9 = atomicrmw add i32* %8, i32 1 monotonic, align 4, !dbg !79
  call void @llvm.dbg.value(metadata i32 1, metadata !80, metadata !DIExpression()), !dbg !81
  %10 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 0, !dbg !82
  %11 = cmpxchg i32* %10, i32 1, i32 2 monotonic monotonic, align 4, !dbg !84
  %12 = extractvalue { i32, i1 } %11, 1, !dbg !84
  %13 = zext i1 %12 to i8, !dbg !84
  br i1 %12, label %15, label %14, !dbg !85

14:                                               ; preds = %7
  call void @__futex_wait(i32* noundef %10, i32 noundef 2), !dbg !86
  br label %15, !dbg !86

15:                                               ; preds = %14, %7
  %16 = atomicrmw sub i32* %8, i32 1 monotonic, align 4, !dbg !87
  br label %4, !dbg !76, !llvm.loop !88

.loopexit:                                        ; preds = %4, %1
  ret void, !dbg !91
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @mutex_unlock(%struct.mutex_t* noundef %0) #0 !dbg !92 {
  call void @llvm.dbg.value(metadata %struct.mutex_t* %0, metadata !93, metadata !DIExpression()), !dbg !94
  %2 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 0, !dbg !95
  %3 = atomicrmw xchg i32* %2, i32 0 release, align 4, !dbg !96
  call void @llvm.dbg.value(metadata i32 %3, metadata !97, metadata !DIExpression()), !dbg !94
  %4 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 1, !dbg !98
  %5 = load atomic i32, i32* %4 monotonic, align 4, !dbg !100
  %6 = icmp sgt i32 %5, 0, !dbg !101
  %7 = icmp ne i32 %3, 1
  %or.cond = select i1 %6, i1 true, i1 %7, !dbg !102
  br i1 %or.cond, label %8, label %9, !dbg !102

8:                                                ; preds = %1
  call void @__futex_wake(i32* noundef %2, i32 noundef 1), !dbg !103
  br label %9, !dbg !103

9:                                                ; preds = %1, %8
  ret void, !dbg !104
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !105 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !108, metadata !DIExpression()), !dbg !115
  call void @mutex_init(%struct.mutex_t* noundef @mutex), !dbg !116
  call void @llvm.dbg.value(metadata i32 0, metadata !117, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.value(metadata i64 0, metadata !117, metadata !DIExpression()), !dbg !119
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !120
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #6, !dbg !122
  call void @llvm.dbg.value(metadata i64 1, metadata !117, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.value(metadata i64 1, metadata !117, metadata !DIExpression()), !dbg !119
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !120
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !122
  call void @llvm.dbg.value(metadata i64 2, metadata !117, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.value(metadata i64 2, metadata !117, metadata !DIExpression()), !dbg !119
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !120
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !122
  call void @llvm.dbg.value(metadata i64 3, metadata !117, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.value(metadata i64 3, metadata !117, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.value(metadata i32 0, metadata !123, metadata !DIExpression()), !dbg !125
  call void @llvm.dbg.value(metadata i64 0, metadata !123, metadata !DIExpression()), !dbg !125
  %8 = load i64, i64* %2, align 8, !dbg !126
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !128
  call void @llvm.dbg.value(metadata i64 1, metadata !123, metadata !DIExpression()), !dbg !125
  call void @llvm.dbg.value(metadata i64 1, metadata !123, metadata !DIExpression()), !dbg !125
  %10 = load i64, i64* %4, align 8, !dbg !126
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !128
  call void @llvm.dbg.value(metadata i64 2, metadata !123, metadata !DIExpression()), !dbg !125
  call void @llvm.dbg.value(metadata i64 2, metadata !123, metadata !DIExpression()), !dbg !125
  %12 = load i64, i64* %6, align 8, !dbg !126
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !128
  call void @llvm.dbg.value(metadata i64 3, metadata !123, metadata !DIExpression()), !dbg !125
  call void @llvm.dbg.value(metadata i64 3, metadata !123, metadata !DIExpression()), !dbg !125
  %14 = load i32, i32* @sum, align 4, !dbg !129
  %15 = icmp eq i32 %14, 3, !dbg !129
  br i1 %15, label %17, label %16, !dbg !132

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !129
  unreachable, !dbg !129

17:                                               ; preds = %0
  ret i32 0, !dbg !133
}

; Function Attrs: noinline nounwind uwtable
define internal void @mutex_init(%struct.mutex_t* noundef %0) #0 !dbg !134 {
  call void @llvm.dbg.value(metadata %struct.mutex_t* %0, metadata !135, metadata !DIExpression()), !dbg !136
  %2 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 0, !dbg !137
  store i32 0, i32* %2, align 4, !dbg !138
  %3 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 1, !dbg !139
  store i32 0, i32* %3, align 4, !dbg !140
  ret void, !dbg !141
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @mutex_lock_fastpath(%struct.mutex_t* noundef %0) #0 !dbg !142 {
  call void @llvm.dbg.value(metadata %struct.mutex_t* %0, metadata !145, metadata !DIExpression()), !dbg !146
  call void @llvm.dbg.value(metadata i32 0, metadata !147, metadata !DIExpression()), !dbg !146
  %2 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 0, !dbg !148
  %3 = cmpxchg i32* %2, i32 0, i32 1 acquire acquire, align 4, !dbg !149
  %4 = extractvalue { i32, i1 } %3, 1, !dbg !149
  %5 = zext i1 %4 to i8, !dbg !149
  %6 = zext i1 %4 to i32, !dbg !149
  ret i32 %6, !dbg !150
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @mutex_lock_slowpath_check(%struct.mutex_t* noundef %0) #0 !dbg !151 {
  call void @llvm.dbg.value(metadata %struct.mutex_t* %0, metadata !152, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.value(metadata i32 0, metadata !154, metadata !DIExpression()), !dbg !153
  %2 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 0, !dbg !155
  %3 = cmpxchg i32* %2, i32 0, i32 1 acquire acquire, align 4, !dbg !156
  %4 = extractvalue { i32, i1 } %3, 1, !dbg !156
  %5 = zext i1 %4 to i8, !dbg !156
  %6 = zext i1 %4 to i32, !dbg !156
  ret i32 %6, !dbg !157
}

; Function Attrs: noinline nounwind uwtable
define internal void @__futex_wait(i32* noundef %0, i32 noundef %1) #0 !dbg !158 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !162, metadata !DIExpression()), !dbg !163
  call void @llvm.dbg.value(metadata i32 %1, metadata !164, metadata !DIExpression()), !dbg !163
  %3 = load atomic i32, i32* @sig acquire, align 4, !dbg !165
  call void @llvm.dbg.value(metadata i32 %3, metadata !166, metadata !DIExpression()), !dbg !163
  %4 = load atomic i32, i32* %0 acquire, align 4, !dbg !167
  %5 = icmp ne i32 %4, %1, !dbg !169
  br i1 %5, label %.loopexit, label %6, !dbg !170

6:                                                ; preds = %6, %2
  %7 = load atomic i32, i32* @sig acquire, align 4, !dbg !171
  %8 = icmp eq i32 %7, %3, !dbg !172
  br i1 %8, label %6, label %.loopexit, !dbg !173, !llvm.loop !174

.loopexit:                                        ; preds = %6, %2
  ret void, !dbg !176
}

; Function Attrs: noinline nounwind uwtable
define internal void @__futex_wake(i32* noundef %0, i32 noundef %1) #0 !dbg !177 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !178, metadata !DIExpression()), !dbg !179
  call void @llvm.dbg.value(metadata i32 %1, metadata !180, metadata !DIExpression()), !dbg !179
  %3 = atomicrmw add i32* @sig, i32 1 release, align 4, !dbg !181
  ret void, !dbg !182
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!38, !39, !40, !41, !42, !43, !44}
!llvm.ident = !{!45}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !23, line: 11, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !20, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/mutex_musl.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "93828a87b35043c4e125bbdd528f6f52")
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
!15 = !{!16, !19}
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !17, line: 87, baseType: !18)
!17 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!18 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!20 = !{!0, !21, !25, !35}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !23, line: 9, type: !24, isLocal: false, isDefinition: true)
!23 = !DIFile(filename: "benchmarks/locks/mutex_musl.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "93828a87b35043c4e125bbdd528f6f52")
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !23, line: 10, type: !27, isLocal: false, isDefinition: true)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "mutex_t", file: !28, line: 19, baseType: !29)
!28 = !DIFile(filename: "benchmarks/locks/mutex_musl.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "5e2bc1f81a3862bf4303eecab164593d")
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !28, line: 16, size: 64, elements: !30)
!30 = !{!31, !34}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !29, file: !28, line: 17, baseType: !32, size: 32)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !33)
!33 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !24)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "waiters", scope: !29, file: !28, line: 18, baseType: !32, size: 32, offset: 32)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "sig", scope: !2, file: !37, line: 15, type: !32, isLocal: true, isDefinition: true)
!37 = !DIFile(filename: "benchmarks/locks/futex.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "cb5dc9517b2fd37660598e8a5b273f61")
!38 = !{i32 7, !"Dwarf Version", i32 5}
!39 = !{i32 2, !"Debug Info Version", i32 3}
!40 = !{i32 1, !"wchar_size", i32 4}
!41 = !{i32 7, !"PIC Level", i32 2}
!42 = !{i32 7, !"PIE Level", i32 2}
!43 = !{i32 7, !"uwtable", i32 1}
!44 = !{i32 7, !"frame-pointer", i32 2}
!45 = !{!"Ubuntu clang version 14.0.6"}
!46 = distinct !DISubprogram(name: "thread_n", scope: !23, file: !23, line: 13, type: !47, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!47 = !DISubroutineType(types: !48)
!48 = !{!19, !19}
!49 = !{}
!50 = !DILocalVariable(name: "arg", arg: 1, scope: !46, file: !23, line: 13, type: !19)
!51 = !DILocation(line: 0, scope: !46)
!52 = !DILocation(line: 15, column: 23, scope: !46)
!53 = !DILocalVariable(name: "index", scope: !46, file: !23, line: 15, type: !16)
!54 = !DILocation(line: 17, column: 5, scope: !46)
!55 = !DILocation(line: 18, column: 14, scope: !46)
!56 = !DILocation(line: 18, column: 12, scope: !46)
!57 = !DILocalVariable(name: "r", scope: !46, file: !23, line: 19, type: !24)
!58 = !DILocation(line: 20, column: 5, scope: !59)
!59 = distinct !DILexicalBlock(scope: !60, file: !23, line: 20, column: 5)
!60 = distinct !DILexicalBlock(scope: !46, file: !23, line: 20, column: 5)
!61 = !DILocation(line: 20, column: 5, scope: !60)
!62 = !DILocation(line: 21, column: 8, scope: !46)
!63 = !DILocation(line: 22, column: 5, scope: !46)
!64 = !DILocation(line: 23, column: 5, scope: !46)
!65 = distinct !DISubprogram(name: "mutex_lock", scope: !28, file: !28, line: 43, type: !66, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!66 = !DISubroutineType(types: !67)
!67 = !{null, !68}
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!69 = !DILocalVariable(name: "m", arg: 1, scope: !65, file: !28, line: 43, type: !68)
!70 = !DILocation(line: 0, scope: !65)
!71 = !DILocation(line: 46, column: 9, scope: !72)
!72 = distinct !DILexicalBlock(scope: !65, file: !28, line: 46, column: 9)
!73 = !DILocation(line: 46, column: 9, scope: !65)
!74 = !DILocation(line: 49, column: 12, scope: !65)
!75 = !DILocation(line: 49, column: 41, scope: !65)
!76 = !DILocation(line: 49, column: 5, scope: !65)
!77 = !DILocation(line: 50, column: 39, scope: !78)
!78 = distinct !DILexicalBlock(scope: !65, file: !28, line: 49, column: 47)
!79 = !DILocation(line: 50, column: 9, scope: !78)
!80 = !DILocalVariable(name: "r", scope: !78, file: !28, line: 51, type: !24)
!81 = !DILocation(line: 0, scope: !78)
!82 = !DILocation(line: 52, column: 58, scope: !83)
!83 = distinct !DILexicalBlock(scope: !78, file: !28, line: 52, column: 13)
!84 = !DILocation(line: 52, column: 14, scope: !83)
!85 = !DILocation(line: 52, column: 13, scope: !78)
!86 = !DILocation(line: 55, column: 9, scope: !83)
!87 = !DILocation(line: 56, column: 9, scope: !78)
!88 = distinct !{!88, !76, !89, !90}
!89 = !DILocation(line: 57, column: 5, scope: !65)
!90 = !{!"llvm.loop.mustprogress"}
!91 = !DILocation(line: 58, column: 1, scope: !65)
!92 = distinct !DISubprogram(name: "mutex_unlock", scope: !28, file: !28, line: 60, type: !66, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!93 = !DILocalVariable(name: "m", arg: 1, scope: !92, file: !28, line: 60, type: !68)
!94 = !DILocation(line: 0, scope: !92)
!95 = !DILocation(line: 62, column: 44, scope: !92)
!96 = !DILocation(line: 62, column: 15, scope: !92)
!97 = !DILocalVariable(name: "old", scope: !92, file: !28, line: 62, type: !24)
!98 = !DILocation(line: 63, column: 34, scope: !99)
!99 = distinct !DILexicalBlock(scope: !92, file: !28, line: 63, column: 9)
!100 = !DILocation(line: 63, column: 9, scope: !99)
!101 = !DILocation(line: 63, column: 65, scope: !99)
!102 = !DILocation(line: 63, column: 69, scope: !99)
!103 = !DILocation(line: 64, column: 9, scope: !99)
!104 = !DILocation(line: 65, column: 1, scope: !92)
!105 = distinct !DISubprogram(name: "main", scope: !23, file: !23, line: 26, type: !106, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!106 = !DISubroutineType(types: !107)
!107 = !{!24}
!108 = !DILocalVariable(name: "t", scope: !105, file: !23, line: 28, type: !109)
!109 = !DICompositeType(tag: DW_TAG_array_type, baseType: !110, size: 192, elements: !113)
!110 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !111, line: 27, baseType: !112)
!111 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!112 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!113 = !{!114}
!114 = !DISubrange(count: 3)
!115 = !DILocation(line: 28, column: 15, scope: !105)
!116 = !DILocation(line: 30, column: 5, scope: !105)
!117 = !DILocalVariable(name: "i", scope: !118, file: !23, line: 32, type: !24)
!118 = distinct !DILexicalBlock(scope: !105, file: !23, line: 32, column: 5)
!119 = !DILocation(line: 0, scope: !118)
!120 = !DILocation(line: 33, column: 25, scope: !121)
!121 = distinct !DILexicalBlock(scope: !118, file: !23, line: 32, column: 5)
!122 = !DILocation(line: 33, column: 9, scope: !121)
!123 = !DILocalVariable(name: "i", scope: !124, file: !23, line: 35, type: !24)
!124 = distinct !DILexicalBlock(scope: !105, file: !23, line: 35, column: 5)
!125 = !DILocation(line: 0, scope: !124)
!126 = !DILocation(line: 36, column: 22, scope: !127)
!127 = distinct !DILexicalBlock(scope: !124, file: !23, line: 35, column: 5)
!128 = !DILocation(line: 36, column: 9, scope: !127)
!129 = !DILocation(line: 38, column: 5, scope: !130)
!130 = distinct !DILexicalBlock(scope: !131, file: !23, line: 38, column: 5)
!131 = distinct !DILexicalBlock(scope: !105, file: !23, line: 38, column: 5)
!132 = !DILocation(line: 38, column: 5, scope: !131)
!133 = !DILocation(line: 40, column: 5, scope: !105)
!134 = distinct !DISubprogram(name: "mutex_init", scope: !28, file: !28, line: 21, type: !66, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!135 = !DILocalVariable(name: "m", arg: 1, scope: !134, file: !28, line: 21, type: !68)
!136 = !DILocation(line: 0, scope: !134)
!137 = !DILocation(line: 23, column: 21, scope: !134)
!138 = !DILocation(line: 23, column: 5, scope: !134)
!139 = !DILocation(line: 24, column: 21, scope: !134)
!140 = !DILocation(line: 24, column: 5, scope: !134)
!141 = !DILocation(line: 25, column: 1, scope: !134)
!142 = distinct !DISubprogram(name: "mutex_lock_fastpath", scope: !28, file: !28, line: 27, type: !143, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!143 = !DISubroutineType(types: !144)
!144 = !{!24, !68}
!145 = !DILocalVariable(name: "m", arg: 1, scope: !142, file: !28, line: 27, type: !68)
!146 = !DILocation(line: 0, scope: !142)
!147 = !DILocalVariable(name: "r", scope: !142, file: !28, line: 29, type: !24)
!148 = !DILocation(line: 30, column: 56, scope: !142)
!149 = !DILocation(line: 30, column: 12, scope: !142)
!150 = !DILocation(line: 30, column: 5, scope: !142)
!151 = distinct !DISubprogram(name: "mutex_lock_slowpath_check", scope: !28, file: !28, line: 35, type: !143, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!152 = !DILocalVariable(name: "m", arg: 1, scope: !151, file: !28, line: 35, type: !68)
!153 = !DILocation(line: 0, scope: !151)
!154 = !DILocalVariable(name: "r", scope: !151, file: !28, line: 37, type: !24)
!155 = !DILocation(line: 38, column: 56, scope: !151)
!156 = !DILocation(line: 38, column: 12, scope: !151)
!157 = !DILocation(line: 38, column: 5, scope: !151)
!158 = distinct !DISubprogram(name: "__futex_wait", scope: !37, file: !37, line: 17, type: !159, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!159 = !DISubroutineType(types: !160)
!160 = !{null, !161, !24}
!161 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!162 = !DILocalVariable(name: "m", arg: 1, scope: !158, file: !37, line: 17, type: !161)
!163 = !DILocation(line: 0, scope: !158)
!164 = !DILocalVariable(name: "v", arg: 2, scope: !158, file: !37, line: 17, type: !24)
!165 = !DILocation(line: 19, column: 13, scope: !158)
!166 = !DILocalVariable(name: "s", scope: !158, file: !37, line: 19, type: !24)
!167 = !DILocation(line: 20, column: 9, scope: !168)
!168 = distinct !DILexicalBlock(scope: !158, file: !37, line: 20, column: 9)
!169 = !DILocation(line: 20, column: 42, scope: !168)
!170 = !DILocation(line: 20, column: 9, scope: !158)
!171 = !DILocation(line: 23, column: 12, scope: !158)
!172 = !DILocation(line: 23, column: 48, scope: !158)
!173 = !DILocation(line: 23, column: 5, scope: !158)
!174 = distinct !{!174, !173, !175, !90}
!175 = !DILocation(line: 24, column: 9, scope: !158)
!176 = !DILocation(line: 25, column: 1, scope: !158)
!177 = distinct !DISubprogram(name: "__futex_wake", scope: !37, file: !37, line: 27, type: !159, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!178 = !DILocalVariable(name: "m", arg: 1, scope: !177, file: !37, line: 27, type: !161)
!179 = !DILocation(line: 0, scope: !177)
!180 = !DILocalVariable(name: "v", arg: 2, scope: !177, file: !37, line: 27, type: !24)
!181 = !DILocation(line: 29, column: 5, scope: !177)
!182 = !DILocation(line: 30, column: 1, scope: !177)
