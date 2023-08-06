; ModuleID = '/home/ponce/git/Dat3M/output/mutex_musl.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/mutex_musl.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.mutex_t = type { i32, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@mutex = dso_local global %struct.mutex_t zeroinitializer, align 4, !dbg !28
@shared = dso_local global i32 0, align 4, !dbg !24
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [52 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/mutex_musl.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@sig = internal global i32 0, align 4, !dbg !38

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !49 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !53, metadata !DIExpression()), !dbg !54
  %2 = ptrtoint i8* %0 to i64, !dbg !55
  call void @llvm.dbg.value(metadata i64 %2, metadata !56, metadata !DIExpression()), !dbg !54
  call void @mutex_lock(%struct.mutex_t* noundef @mutex), !dbg !57
  %3 = trunc i64 %2 to i32, !dbg !58
  store i32 %3, i32* @shared, align 4, !dbg !59
  call void @llvm.dbg.value(metadata i32 %3, metadata !60, metadata !DIExpression()), !dbg !54
  %4 = sext i32 %3 to i64, !dbg !61
  %5 = icmp eq i64 %4, %2, !dbg !61
  br i1 %5, label %7, label %6, !dbg !64

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5, !dbg !61
  unreachable, !dbg !61

7:                                                ; preds = %1
  %8 = load i32, i32* @sum, align 4, !dbg !65
  %9 = add nsw i32 %8, 1, !dbg !65
  store i32 %9, i32* @sum, align 4, !dbg !65
  call void @mutex_unlock(%struct.mutex_t* noundef @mutex), !dbg !66
  ret i8* null, !dbg !67
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @mutex_lock(%struct.mutex_t* noundef %0) #0 !dbg !68 {
  call void @llvm.dbg.value(metadata %struct.mutex_t* %0, metadata !72, metadata !DIExpression()), !dbg !73
  %2 = call i32 @mutex_lock_fastpath(%struct.mutex_t* noundef %0), !dbg !74
  %3 = icmp ne i32 %2, 0, !dbg !74
  br i1 %3, label %.loopexit, label %4, !dbg !76

4:                                                ; preds = %1, %15
  %5 = call i32 @mutex_lock_slowpath_check(%struct.mutex_t* noundef %0), !dbg !77
  %6 = icmp eq i32 %5, 0, !dbg !78
  br i1 %6, label %7, label %.loopexit, !dbg !79

7:                                                ; preds = %4
  %8 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 1, !dbg !80
  %9 = atomicrmw add i32* %8, i32 1 monotonic, align 4, !dbg !82
  call void @llvm.dbg.value(metadata i32 1, metadata !83, metadata !DIExpression()), !dbg !84
  %10 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 0, !dbg !85
  %11 = cmpxchg i32* %10, i32 1, i32 2 monotonic monotonic, align 4, !dbg !87
  %12 = extractvalue { i32, i1 } %11, 1, !dbg !87
  %13 = zext i1 %12 to i8, !dbg !87
  br i1 %12, label %15, label %14, !dbg !88

14:                                               ; preds = %7
  call void @__futex_wait(i32* noundef %10, i32 noundef 2), !dbg !89
  br label %15, !dbg !89

15:                                               ; preds = %14, %7
  %16 = atomicrmw sub i32* %8, i32 1 monotonic, align 4, !dbg !90
  br label %4, !dbg !79, !llvm.loop !91

.loopexit:                                        ; preds = %4, %1
  ret void, !dbg !94
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @mutex_unlock(%struct.mutex_t* noundef %0) #0 !dbg !95 {
  call void @llvm.dbg.value(metadata %struct.mutex_t* %0, metadata !96, metadata !DIExpression()), !dbg !97
  %2 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 0, !dbg !98
  %3 = atomicrmw xchg i32* %2, i32 0 release, align 4, !dbg !99
  call void @llvm.dbg.value(metadata i32 %3, metadata !100, metadata !DIExpression()), !dbg !97
  %4 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 1, !dbg !101
  %5 = load atomic i32, i32* %4 monotonic, align 4, !dbg !103
  %6 = icmp sgt i32 %5, 0, !dbg !104
  %7 = icmp ne i32 %3, 1
  %or.cond = select i1 %6, i1 true, i1 %7, !dbg !105
  br i1 %or.cond, label %8, label %9, !dbg !105

8:                                                ; preds = %1
  call void @__futex_wake(i32* noundef %2, i32 noundef 1), !dbg !106
  br label %9, !dbg !106

9:                                                ; preds = %1, %8
  ret void, !dbg !107
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !108 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !111, metadata !DIExpression()), !dbg !117
  call void @mutex_init(%struct.mutex_t* noundef @mutex), !dbg !118
  call void @llvm.dbg.value(metadata i32 0, metadata !119, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i64 0, metadata !119, metadata !DIExpression()), !dbg !121
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !122
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #6, !dbg !124
  call void @llvm.dbg.value(metadata i64 1, metadata !119, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i64 1, metadata !119, metadata !DIExpression()), !dbg !121
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !122
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !124
  call void @llvm.dbg.value(metadata i64 2, metadata !119, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i64 2, metadata !119, metadata !DIExpression()), !dbg !121
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !122
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !124
  call void @llvm.dbg.value(metadata i64 3, metadata !119, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i64 3, metadata !119, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i32 0, metadata !125, metadata !DIExpression()), !dbg !127
  call void @llvm.dbg.value(metadata i64 0, metadata !125, metadata !DIExpression()), !dbg !127
  %8 = load i64, i64* %2, align 8, !dbg !128
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !130
  call void @llvm.dbg.value(metadata i64 1, metadata !125, metadata !DIExpression()), !dbg !127
  call void @llvm.dbg.value(metadata i64 1, metadata !125, metadata !DIExpression()), !dbg !127
  %10 = load i64, i64* %4, align 8, !dbg !128
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !130
  call void @llvm.dbg.value(metadata i64 2, metadata !125, metadata !DIExpression()), !dbg !127
  call void @llvm.dbg.value(metadata i64 2, metadata !125, metadata !DIExpression()), !dbg !127
  %12 = load i64, i64* %6, align 8, !dbg !128
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !130
  call void @llvm.dbg.value(metadata i64 3, metadata !125, metadata !DIExpression()), !dbg !127
  call void @llvm.dbg.value(metadata i64 3, metadata !125, metadata !DIExpression()), !dbg !127
  %14 = load i32, i32* @sum, align 4, !dbg !131
  %15 = icmp eq i32 %14, 3, !dbg !131
  br i1 %15, label %17, label %16, !dbg !134

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !131
  unreachable, !dbg !131

17:                                               ; preds = %0
  ret i32 0, !dbg !135
}

; Function Attrs: noinline nounwind uwtable
define internal void @mutex_init(%struct.mutex_t* noundef %0) #0 !dbg !136 {
  call void @llvm.dbg.value(metadata %struct.mutex_t* %0, metadata !137, metadata !DIExpression()), !dbg !138
  %2 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 0, !dbg !139
  store i32 0, i32* %2, align 4, !dbg !140
  %3 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 1, !dbg !141
  store i32 0, i32* %3, align 4, !dbg !142
  ret void, !dbg !143
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @mutex_lock_fastpath(%struct.mutex_t* noundef %0) #0 !dbg !144 {
  call void @llvm.dbg.value(metadata %struct.mutex_t* %0, metadata !147, metadata !DIExpression()), !dbg !148
  call void @llvm.dbg.value(metadata i32 0, metadata !149, metadata !DIExpression()), !dbg !148
  %2 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 0, !dbg !150
  %3 = cmpxchg i32* %2, i32 0, i32 1 monotonic monotonic, align 4, !dbg !151
  %4 = extractvalue { i32, i1 } %3, 1, !dbg !151
  %5 = zext i1 %4 to i8, !dbg !151
  %6 = zext i1 %4 to i32, !dbg !151
  ret i32 %6, !dbg !152
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @mutex_lock_slowpath_check(%struct.mutex_t* noundef %0) #0 !dbg !153 {
  call void @llvm.dbg.value(metadata %struct.mutex_t* %0, metadata !154, metadata !DIExpression()), !dbg !155
  call void @llvm.dbg.value(metadata i32 0, metadata !156, metadata !DIExpression()), !dbg !155
  %2 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %0, i32 0, i32 0, !dbg !157
  %3 = cmpxchg i32* %2, i32 0, i32 1 acquire acquire, align 4, !dbg !158
  %4 = extractvalue { i32, i1 } %3, 1, !dbg !158
  %5 = zext i1 %4 to i8, !dbg !158
  %6 = zext i1 %4 to i32, !dbg !158
  ret i32 %6, !dbg !159
}

; Function Attrs: noinline nounwind uwtable
define internal void @__futex_wait(i32* noundef %0, i32 noundef %1) #0 !dbg !160 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !164, metadata !DIExpression()), !dbg !165
  call void @llvm.dbg.value(metadata i32 %1, metadata !166, metadata !DIExpression()), !dbg !165
  %3 = load atomic i32, i32* @sig acquire, align 4, !dbg !167
  call void @llvm.dbg.value(metadata i32 %3, metadata !168, metadata !DIExpression()), !dbg !165
  %4 = load atomic i32, i32* %0 acquire, align 4, !dbg !169
  %5 = icmp ne i32 %4, %1, !dbg !171
  br i1 %5, label %.loopexit, label %6, !dbg !172

6:                                                ; preds = %6, %2
  %7 = load atomic i32, i32* @sig acquire, align 4, !dbg !173
  %8 = icmp eq i32 %7, %3, !dbg !174
  br i1 %8, label %6, label %.loopexit, !dbg !175, !llvm.loop !176

.loopexit:                                        ; preds = %6, %2
  ret void, !dbg !178
}

; Function Attrs: noinline nounwind uwtable
define internal void @__futex_wake(i32* noundef %0, i32 noundef %1) #0 !dbg !179 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !180, metadata !DIExpression()), !dbg !181
  call void @llvm.dbg.value(metadata i32 %1, metadata !182, metadata !DIExpression()), !dbg !181
  %3 = atomicrmw add i32* @sig, i32 1 release, align 4, !dbg !183
  ret void, !dbg !184
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
!llvm.module.flags = !{!41, !42, !43, !44, !45, !46, !47}
!llvm.ident = !{!48}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !26, line: 11, type: !27, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !23, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/mutex_musl.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "9b238f64daa711a8efaa79fbfc3acf3b")
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
!15 = !{!16, !19, !20}
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !17, line: 87, baseType: !18)
!17 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!18 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !21, line: 46, baseType: !22)
!21 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!22 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!23 = !{!0, !24, !28, !38}
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !26, line: 9, type: !27, isLocal: false, isDefinition: true)
!26 = !DIFile(filename: "benchmarks/locks/mutex_musl.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "9b238f64daa711a8efaa79fbfc3acf3b")
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !26, line: 10, type: !30, isLocal: false, isDefinition: true)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "mutex_t", file: !31, line: 19, baseType: !32)
!31 = !DIFile(filename: "benchmarks/locks/mutex_musl.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "5e2bc1f81a3862bf4303eecab164593d")
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !31, line: 16, size: 64, elements: !33)
!33 = !{!34, !37}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !32, file: !31, line: 17, baseType: !35, size: 32)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !36)
!36 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !27)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "waiters", scope: !32, file: !31, line: 18, baseType: !35, size: 32, offset: 32)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "sig", scope: !2, file: !40, line: 15, type: !35, isLocal: true, isDefinition: true)
!40 = !DIFile(filename: "benchmarks/locks/futex.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "cb5dc9517b2fd37660598e8a5b273f61")
!41 = !{i32 7, !"Dwarf Version", i32 5}
!42 = !{i32 2, !"Debug Info Version", i32 3}
!43 = !{i32 1, !"wchar_size", i32 4}
!44 = !{i32 7, !"PIC Level", i32 2}
!45 = !{i32 7, !"PIE Level", i32 2}
!46 = !{i32 7, !"uwtable", i32 1}
!47 = !{i32 7, !"frame-pointer", i32 2}
!48 = !{!"Ubuntu clang version 14.0.6"}
!49 = distinct !DISubprogram(name: "thread_n", scope: !26, file: !26, line: 13, type: !50, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!50 = !DISubroutineType(types: !51)
!51 = !{!19, !19}
!52 = !{}
!53 = !DILocalVariable(name: "arg", arg: 1, scope: !49, file: !26, line: 13, type: !19)
!54 = !DILocation(line: 0, scope: !49)
!55 = !DILocation(line: 15, column: 23, scope: !49)
!56 = !DILocalVariable(name: "index", scope: !49, file: !26, line: 15, type: !16)
!57 = !DILocation(line: 17, column: 5, scope: !49)
!58 = !DILocation(line: 18, column: 14, scope: !49)
!59 = !DILocation(line: 18, column: 12, scope: !49)
!60 = !DILocalVariable(name: "r", scope: !49, file: !26, line: 19, type: !27)
!61 = !DILocation(line: 20, column: 5, scope: !62)
!62 = distinct !DILexicalBlock(scope: !63, file: !26, line: 20, column: 5)
!63 = distinct !DILexicalBlock(scope: !49, file: !26, line: 20, column: 5)
!64 = !DILocation(line: 20, column: 5, scope: !63)
!65 = !DILocation(line: 21, column: 8, scope: !49)
!66 = !DILocation(line: 22, column: 5, scope: !49)
!67 = !DILocation(line: 23, column: 5, scope: !49)
!68 = distinct !DISubprogram(name: "mutex_lock", scope: !31, file: !31, line: 43, type: !69, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!69 = !DISubroutineType(types: !70)
!70 = !{null, !71}
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!72 = !DILocalVariable(name: "m", arg: 1, scope: !68, file: !31, line: 43, type: !71)
!73 = !DILocation(line: 0, scope: !68)
!74 = !DILocation(line: 46, column: 9, scope: !75)
!75 = distinct !DILexicalBlock(scope: !68, file: !31, line: 46, column: 9)
!76 = !DILocation(line: 46, column: 9, scope: !68)
!77 = !DILocation(line: 49, column: 12, scope: !68)
!78 = !DILocation(line: 49, column: 41, scope: !68)
!79 = !DILocation(line: 49, column: 5, scope: !68)
!80 = !DILocation(line: 50, column: 39, scope: !81)
!81 = distinct !DILexicalBlock(scope: !68, file: !31, line: 49, column: 47)
!82 = !DILocation(line: 50, column: 9, scope: !81)
!83 = !DILocalVariable(name: "r", scope: !81, file: !31, line: 51, type: !27)
!84 = !DILocation(line: 0, scope: !81)
!85 = !DILocation(line: 52, column: 58, scope: !86)
!86 = distinct !DILexicalBlock(scope: !81, file: !31, line: 52, column: 13)
!87 = !DILocation(line: 52, column: 14, scope: !86)
!88 = !DILocation(line: 52, column: 13, scope: !81)
!89 = !DILocation(line: 55, column: 9, scope: !86)
!90 = !DILocation(line: 56, column: 9, scope: !81)
!91 = distinct !{!91, !79, !92, !93}
!92 = !DILocation(line: 57, column: 5, scope: !68)
!93 = !{!"llvm.loop.mustprogress"}
!94 = !DILocation(line: 58, column: 1, scope: !68)
!95 = distinct !DISubprogram(name: "mutex_unlock", scope: !31, file: !31, line: 60, type: !69, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!96 = !DILocalVariable(name: "m", arg: 1, scope: !95, file: !31, line: 60, type: !71)
!97 = !DILocation(line: 0, scope: !95)
!98 = !DILocation(line: 62, column: 44, scope: !95)
!99 = !DILocation(line: 62, column: 15, scope: !95)
!100 = !DILocalVariable(name: "old", scope: !95, file: !31, line: 62, type: !27)
!101 = !DILocation(line: 63, column: 34, scope: !102)
!102 = distinct !DILexicalBlock(scope: !95, file: !31, line: 63, column: 9)
!103 = !DILocation(line: 63, column: 9, scope: !102)
!104 = !DILocation(line: 63, column: 65, scope: !102)
!105 = !DILocation(line: 63, column: 69, scope: !102)
!106 = !DILocation(line: 64, column: 9, scope: !102)
!107 = !DILocation(line: 65, column: 1, scope: !95)
!108 = distinct !DISubprogram(name: "main", scope: !26, file: !26, line: 26, type: !109, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!109 = !DISubroutineType(types: !110)
!110 = !{!27}
!111 = !DILocalVariable(name: "t", scope: !108, file: !26, line: 28, type: !112)
!112 = !DICompositeType(tag: DW_TAG_array_type, baseType: !113, size: 192, elements: !115)
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !114, line: 27, baseType: !22)
!114 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!115 = !{!116}
!116 = !DISubrange(count: 3)
!117 = !DILocation(line: 28, column: 15, scope: !108)
!118 = !DILocation(line: 30, column: 5, scope: !108)
!119 = !DILocalVariable(name: "i", scope: !120, file: !26, line: 32, type: !27)
!120 = distinct !DILexicalBlock(scope: !108, file: !26, line: 32, column: 5)
!121 = !DILocation(line: 0, scope: !120)
!122 = !DILocation(line: 33, column: 25, scope: !123)
!123 = distinct !DILexicalBlock(scope: !120, file: !26, line: 32, column: 5)
!124 = !DILocation(line: 33, column: 9, scope: !123)
!125 = !DILocalVariable(name: "i", scope: !126, file: !26, line: 35, type: !27)
!126 = distinct !DILexicalBlock(scope: !108, file: !26, line: 35, column: 5)
!127 = !DILocation(line: 0, scope: !126)
!128 = !DILocation(line: 36, column: 22, scope: !129)
!129 = distinct !DILexicalBlock(scope: !126, file: !26, line: 35, column: 5)
!130 = !DILocation(line: 36, column: 9, scope: !129)
!131 = !DILocation(line: 38, column: 5, scope: !132)
!132 = distinct !DILexicalBlock(scope: !133, file: !26, line: 38, column: 5)
!133 = distinct !DILexicalBlock(scope: !108, file: !26, line: 38, column: 5)
!134 = !DILocation(line: 38, column: 5, scope: !133)
!135 = !DILocation(line: 40, column: 5, scope: !108)
!136 = distinct !DISubprogram(name: "mutex_init", scope: !31, file: !31, line: 21, type: !69, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!137 = !DILocalVariable(name: "m", arg: 1, scope: !136, file: !31, line: 21, type: !71)
!138 = !DILocation(line: 0, scope: !136)
!139 = !DILocation(line: 23, column: 21, scope: !136)
!140 = !DILocation(line: 23, column: 5, scope: !136)
!141 = !DILocation(line: 24, column: 21, scope: !136)
!142 = !DILocation(line: 24, column: 5, scope: !136)
!143 = !DILocation(line: 25, column: 1, scope: !136)
!144 = distinct !DISubprogram(name: "mutex_lock_fastpath", scope: !31, file: !31, line: 27, type: !145, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!145 = !DISubroutineType(types: !146)
!146 = !{!27, !71}
!147 = !DILocalVariable(name: "m", arg: 1, scope: !144, file: !31, line: 27, type: !71)
!148 = !DILocation(line: 0, scope: !144)
!149 = !DILocalVariable(name: "r", scope: !144, file: !31, line: 29, type: !27)
!150 = !DILocation(line: 30, column: 56, scope: !144)
!151 = !DILocation(line: 30, column: 12, scope: !144)
!152 = !DILocation(line: 30, column: 5, scope: !144)
!153 = distinct !DISubprogram(name: "mutex_lock_slowpath_check", scope: !31, file: !31, line: 35, type: !145, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!154 = !DILocalVariable(name: "m", arg: 1, scope: !153, file: !31, line: 35, type: !71)
!155 = !DILocation(line: 0, scope: !153)
!156 = !DILocalVariable(name: "r", scope: !153, file: !31, line: 37, type: !27)
!157 = !DILocation(line: 38, column: 56, scope: !153)
!158 = !DILocation(line: 38, column: 12, scope: !153)
!159 = !DILocation(line: 38, column: 5, scope: !153)
!160 = distinct !DISubprogram(name: "__futex_wait", scope: !40, file: !40, line: 17, type: !161, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!161 = !DISubroutineType(types: !162)
!162 = !{null, !163, !27}
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!164 = !DILocalVariable(name: "m", arg: 1, scope: !160, file: !40, line: 17, type: !163)
!165 = !DILocation(line: 0, scope: !160)
!166 = !DILocalVariable(name: "v", arg: 2, scope: !160, file: !40, line: 17, type: !27)
!167 = !DILocation(line: 19, column: 13, scope: !160)
!168 = !DILocalVariable(name: "s", scope: !160, file: !40, line: 19, type: !27)
!169 = !DILocation(line: 20, column: 9, scope: !170)
!170 = distinct !DILexicalBlock(scope: !160, file: !40, line: 20, column: 9)
!171 = !DILocation(line: 20, column: 42, scope: !170)
!172 = !DILocation(line: 20, column: 9, scope: !160)
!173 = !DILocation(line: 23, column: 12, scope: !160)
!174 = !DILocation(line: 23, column: 48, scope: !160)
!175 = !DILocation(line: 23, column: 5, scope: !160)
!176 = distinct !{!176, !175, !177, !93}
!177 = !DILocation(line: 24, column: 9, scope: !160)
!178 = !DILocation(line: 25, column: 1, scope: !160)
!179 = distinct !DISubprogram(name: "__futex_wake", scope: !40, file: !40, line: 27, type: !161, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!180 = !DILocalVariable(name: "m", arg: 1, scope: !179, file: !40, line: 27, type: !163)
!181 = !DILocation(line: 0, scope: !179)
!182 = !DILocalVariable(name: "v", arg: 2, scope: !179, file: !40, line: 27, type: !27)
!183 = !DILocation(line: 29, column: 5, scope: !179)
!184 = !DILocation(line: 30, column: 1, scope: !179)
