; ModuleID = 'benchmarks/mutex.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/mutex.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@mutex = dso_local global i32 0, align 4, !dbg !25
@shared = dso_local global i32 0, align 4, !dbg !21
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [47 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/mutex.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@sig = internal global i32 0, align 4, !dbg !31

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !42 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !46, metadata !DIExpression()), !dbg !47
  %2 = ptrtoint i8* %0 to i64, !dbg !48
  call void @llvm.dbg.value(metadata i64 %2, metadata !49, metadata !DIExpression()), !dbg !47
  call void @mutex_lock(i32* noundef @mutex), !dbg !50
  %3 = trunc i64 %2 to i32, !dbg !51
  store i32 %3, i32* @shared, align 4, !dbg !52
  call void @llvm.dbg.value(metadata i32 %3, metadata !53, metadata !DIExpression()), !dbg !47
  %4 = sext i32 %3 to i64, !dbg !54
  %5 = icmp eq i64 %4, %2, !dbg !54
  br i1 %5, label %7, label %6, !dbg !57

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5, !dbg !54
  unreachable, !dbg !54

7:                                                ; preds = %1
  %8 = load i32, i32* @sum, align 4, !dbg !58
  %9 = add nsw i32 %8, 1, !dbg !58
  store i32 %9, i32* @sum, align 4, !dbg !58
  call void @mutex_unlock(i32* noundef @mutex), !dbg !59
  ret i8* null, !dbg !60
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @mutex_lock(i32* noundef %0) #0 !dbg !61 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !65, metadata !DIExpression()), !dbg !66
  %2 = call i32 @mutex_lock_fastpath(i32* noundef %0), !dbg !67
  %3 = icmp ne i32 %2, 0, !dbg !67
  br i1 %3, label %10, label %4, !dbg !69

4:                                                ; preds = %4, %1
  call void @llvm.dbg.value(metadata i32 1, metadata !70, metadata !DIExpression()), !dbg !72
  %5 = cmpxchg i32* %0, i32 1, i32 2 monotonic monotonic, align 4, !dbg !73
  %6 = extractvalue { i32, i1 } %5, 1, !dbg !73
  %7 = zext i1 %6 to i8, !dbg !73
  call void @__futex_wait(i32* noundef %0, i32 noundef 2), !dbg !74
  %8 = call i32 @mutex_lock_try_acquire(i32* noundef %0), !dbg !75
  %9 = icmp ne i32 %8, 0, !dbg !75
  br i1 %9, label %10, label %4, !dbg !77, !llvm.loop !78

10:                                               ; preds = %4, %1
  ret void, !dbg !81
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @mutex_unlock(i32* noundef %0) #0 !dbg !82 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !83, metadata !DIExpression()), !dbg !84
  %2 = call i32 @mutex_unlock_fastpath(i32* noundef %0), !dbg !85
  %3 = icmp ne i32 %2, 0, !dbg !85
  br i1 %3, label %5, label %4, !dbg !87

4:                                                ; preds = %1
  store atomic i32 0, i32* %0 release, align 4, !dbg !88
  call void @__futex_wake(i32* noundef %0, i32 noundef 1), !dbg !89
  br label %5, !dbg !90

5:                                                ; preds = %1, %4
  ret void, !dbg !90
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !91 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !94, metadata !DIExpression()), !dbg !101
  call void @mutex_init(i32* noundef @mutex), !dbg !102
  call void @llvm.dbg.value(metadata i32 0, metadata !103, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i64 0, metadata !103, metadata !DIExpression()), !dbg !105
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !106
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #6, !dbg !108
  call void @llvm.dbg.value(metadata i64 1, metadata !103, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i64 1, metadata !103, metadata !DIExpression()), !dbg !105
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !106
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !108
  call void @llvm.dbg.value(metadata i64 2, metadata !103, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i64 2, metadata !103, metadata !DIExpression()), !dbg !105
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !106
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !108
  call void @llvm.dbg.value(metadata i64 3, metadata !103, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i64 3, metadata !103, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i32 0, metadata !109, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i64 0, metadata !109, metadata !DIExpression()), !dbg !111
  %8 = load i64, i64* %2, align 8, !dbg !112
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !114
  call void @llvm.dbg.value(metadata i64 1, metadata !109, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i64 1, metadata !109, metadata !DIExpression()), !dbg !111
  %10 = load i64, i64* %4, align 8, !dbg !112
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !114
  call void @llvm.dbg.value(metadata i64 2, metadata !109, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i64 2, metadata !109, metadata !DIExpression()), !dbg !111
  %12 = load i64, i64* %6, align 8, !dbg !112
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !114
  call void @llvm.dbg.value(metadata i64 3, metadata !109, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i64 3, metadata !109, metadata !DIExpression()), !dbg !111
  %14 = load i32, i32* @sum, align 4, !dbg !115
  %15 = icmp eq i32 %14, 3, !dbg !115
  br i1 %15, label %17, label %16, !dbg !118

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !115
  unreachable, !dbg !115

17:                                               ; preds = %0
  ret i32 0, !dbg !119
}

; Function Attrs: noinline nounwind uwtable
define internal void @mutex_init(i32* noundef %0) #0 !dbg !120 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !121, metadata !DIExpression()), !dbg !122
  store i32 0, i32* %0, align 4, !dbg !123
  ret void, !dbg !124
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @mutex_lock_fastpath(i32* noundef %0) #0 !dbg !125 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !128, metadata !DIExpression()), !dbg !129
  call void @llvm.dbg.value(metadata i32 0, metadata !130, metadata !DIExpression()), !dbg !129
  %2 = cmpxchg i32* %0, i32 0, i32 1 acquire acquire, align 4, !dbg !131
  %3 = extractvalue { i32, i1 } %2, 1, !dbg !131
  %4 = zext i1 %3 to i8, !dbg !131
  %5 = zext i1 %3 to i32, !dbg !131
  ret i32 %5, !dbg !132
}

; Function Attrs: noinline nounwind uwtable
define internal void @__futex_wait(i32* noundef %0, i32 noundef %1) #0 !dbg !133 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !137, metadata !DIExpression()), !dbg !138
  call void @llvm.dbg.value(metadata i32 %1, metadata !139, metadata !DIExpression()), !dbg !138
  %3 = load atomic i32, i32* @sig acquire, align 4, !dbg !140
  call void @llvm.dbg.value(metadata i32 %3, metadata !141, metadata !DIExpression()), !dbg !138
  %4 = load atomic i32, i32* %0 acquire, align 4, !dbg !142
  %5 = icmp ne i32 %4, %1, !dbg !144
  br i1 %5, label %.loopexit, label %6, !dbg !145

6:                                                ; preds = %6, %2
  %7 = load atomic i32, i32* @sig acquire, align 4, !dbg !146
  %8 = icmp eq i32 %7, %3, !dbg !147
  br i1 %8, label %6, label %.loopexit, !dbg !148, !llvm.loop !149

.loopexit:                                        ; preds = %6, %2
  ret void, !dbg !152
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @mutex_lock_try_acquire(i32* noundef %0) #0 !dbg !153 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !154, metadata !DIExpression()), !dbg !155
  call void @llvm.dbg.value(metadata i32 0, metadata !156, metadata !DIExpression()), !dbg !155
  %2 = cmpxchg i32* %0, i32 0, i32 2 acquire acquire, align 4, !dbg !157
  %3 = extractvalue { i32, i1 } %2, 1, !dbg !157
  %4 = zext i1 %3 to i8, !dbg !157
  %5 = zext i1 %3 to i32, !dbg !157
  ret i32 %5, !dbg !158
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @mutex_unlock_fastpath(i32* noundef %0) #0 !dbg !159 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !160, metadata !DIExpression()), !dbg !161
  call void @llvm.dbg.value(metadata i32 1, metadata !162, metadata !DIExpression()), !dbg !161
  %2 = cmpxchg i32* %0, i32 1, i32 0 release monotonic, align 4, !dbg !163
  %3 = extractvalue { i32, i1 } %2, 1, !dbg !163
  %4 = zext i1 %3 to i8, !dbg !163
  %5 = zext i1 %3 to i32, !dbg !163
  ret i32 %5, !dbg !164
}

; Function Attrs: noinline nounwind uwtable
define internal void @__futex_wake(i32* noundef %0, i32 noundef %1) #0 !dbg !165 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !166, metadata !DIExpression()), !dbg !167
  call void @llvm.dbg.value(metadata i32 %1, metadata !168, metadata !DIExpression()), !dbg !167
  %3 = atomicrmw add i32* @sig, i32 1 release, align 4, !dbg !169
  ret void, !dbg !170
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
!llvm.module.flags = !{!34, !35, !36, !37, !38, !39, !40}
!llvm.ident = !{!41}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !23, line: 11, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !20, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "d4c457f7f08334cf1e71438ca1114136")
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
!20 = !{!0, !21, !25, !31}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !23, line: 9, type: !24, isLocal: false, isDefinition: true)
!23 = !DIFile(filename: "benchmarks/locks/mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "d4c457f7f08334cf1e71438ca1114136")
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !23, line: 10, type: !27, isLocal: false, isDefinition: true)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "mutex_t", file: !28, line: 16, baseType: !29)
!28 = !DIFile(filename: "benchmarks/locks/mutex.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "38ec3b6ce739789a23bba4a8c8425857")
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !30)
!30 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !24)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "sig", scope: !2, file: !33, line: 15, type: !29, isLocal: true, isDefinition: true)
!33 = !DIFile(filename: "benchmarks/locks/futex.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "cb5dc9517b2fd37660598e8a5b273f61")
!34 = !{i32 7, !"Dwarf Version", i32 5}
!35 = !{i32 2, !"Debug Info Version", i32 3}
!36 = !{i32 1, !"wchar_size", i32 4}
!37 = !{i32 7, !"PIC Level", i32 2}
!38 = !{i32 7, !"PIE Level", i32 2}
!39 = !{i32 7, !"uwtable", i32 1}
!40 = !{i32 7, !"frame-pointer", i32 2}
!41 = !{!"Ubuntu clang version 14.0.6"}
!42 = distinct !DISubprogram(name: "thread_n", scope: !23, file: !23, line: 13, type: !43, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!43 = !DISubroutineType(types: !44)
!44 = !{!19, !19}
!45 = !{}
!46 = !DILocalVariable(name: "arg", arg: 1, scope: !42, file: !23, line: 13, type: !19)
!47 = !DILocation(line: 0, scope: !42)
!48 = !DILocation(line: 15, column: 23, scope: !42)
!49 = !DILocalVariable(name: "index", scope: !42, file: !23, line: 15, type: !16)
!50 = !DILocation(line: 17, column: 5, scope: !42)
!51 = !DILocation(line: 18, column: 14, scope: !42)
!52 = !DILocation(line: 18, column: 12, scope: !42)
!53 = !DILocalVariable(name: "r", scope: !42, file: !23, line: 19, type: !24)
!54 = !DILocation(line: 20, column: 5, scope: !55)
!55 = distinct !DILexicalBlock(scope: !56, file: !23, line: 20, column: 5)
!56 = distinct !DILexicalBlock(scope: !42, file: !23, line: 20, column: 5)
!57 = !DILocation(line: 20, column: 5, scope: !56)
!58 = !DILocation(line: 21, column: 8, scope: !42)
!59 = !DILocation(line: 22, column: 5, scope: !42)
!60 = !DILocation(line: 23, column: 5, scope: !42)
!61 = distinct !DISubprogram(name: "mutex_lock", scope: !28, file: !28, line: 39, type: !62, scopeLine: 40, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!62 = !DISubroutineType(types: !63)
!63 = !{null, !64}
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!65 = !DILocalVariable(name: "m", arg: 1, scope: !61, file: !28, line: 39, type: !64)
!66 = !DILocation(line: 0, scope: !61)
!67 = !DILocation(line: 41, column: 9, scope: !68)
!68 = distinct !DILexicalBlock(scope: !61, file: !28, line: 41, column: 9)
!69 = !DILocation(line: 41, column: 9, scope: !61)
!70 = !DILocalVariable(name: "r", scope: !71, file: !28, line: 45, type: !24)
!71 = distinct !DILexicalBlock(scope: !61, file: !28, line: 44, column: 15)
!72 = !DILocation(line: 0, scope: !71)
!73 = !DILocation(line: 46, column: 9, scope: !71)
!74 = !DILocation(line: 49, column: 9, scope: !71)
!75 = !DILocation(line: 50, column: 13, scope: !76)
!76 = distinct !DILexicalBlock(scope: !71, file: !28, line: 50, column: 13)
!77 = !DILocation(line: 50, column: 13, scope: !71)
!78 = distinct !{!78, !79, !80}
!79 = !DILocation(line: 44, column: 5, scope: !61)
!80 = !DILocation(line: 52, column: 5, scope: !61)
!81 = !DILocation(line: 53, column: 1, scope: !61)
!82 = distinct !DISubprogram(name: "mutex_unlock", scope: !28, file: !28, line: 63, type: !62, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!83 = !DILocalVariable(name: "m", arg: 1, scope: !82, file: !28, line: 63, type: !64)
!84 = !DILocation(line: 0, scope: !82)
!85 = !DILocation(line: 65, column: 9, scope: !86)
!86 = distinct !DILexicalBlock(scope: !82, file: !28, line: 65, column: 9)
!87 = !DILocation(line: 65, column: 9, scope: !82)
!88 = !DILocation(line: 68, column: 5, scope: !82)
!89 = !DILocation(line: 69, column: 5, scope: !82)
!90 = !DILocation(line: 70, column: 1, scope: !82)
!91 = distinct !DISubprogram(name: "main", scope: !23, file: !23, line: 26, type: !92, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!92 = !DISubroutineType(types: !93)
!93 = !{!24}
!94 = !DILocalVariable(name: "t", scope: !91, file: !23, line: 28, type: !95)
!95 = !DICompositeType(tag: DW_TAG_array_type, baseType: !96, size: 192, elements: !99)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !97, line: 27, baseType: !98)
!97 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!98 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!99 = !{!100}
!100 = !DISubrange(count: 3)
!101 = !DILocation(line: 28, column: 15, scope: !91)
!102 = !DILocation(line: 30, column: 5, scope: !91)
!103 = !DILocalVariable(name: "i", scope: !104, file: !23, line: 32, type: !24)
!104 = distinct !DILexicalBlock(scope: !91, file: !23, line: 32, column: 5)
!105 = !DILocation(line: 0, scope: !104)
!106 = !DILocation(line: 33, column: 25, scope: !107)
!107 = distinct !DILexicalBlock(scope: !104, file: !23, line: 32, column: 5)
!108 = !DILocation(line: 33, column: 9, scope: !107)
!109 = !DILocalVariable(name: "i", scope: !110, file: !23, line: 35, type: !24)
!110 = distinct !DILexicalBlock(scope: !91, file: !23, line: 35, column: 5)
!111 = !DILocation(line: 0, scope: !110)
!112 = !DILocation(line: 36, column: 22, scope: !113)
!113 = distinct !DILexicalBlock(scope: !110, file: !23, line: 35, column: 5)
!114 = !DILocation(line: 36, column: 9, scope: !113)
!115 = !DILocation(line: 38, column: 5, scope: !116)
!116 = distinct !DILexicalBlock(scope: !117, file: !23, line: 38, column: 5)
!117 = distinct !DILexicalBlock(scope: !91, file: !23, line: 38, column: 5)
!118 = !DILocation(line: 38, column: 5, scope: !117)
!119 = !DILocation(line: 40, column: 5, scope: !91)
!120 = distinct !DISubprogram(name: "mutex_init", scope: !28, file: !28, line: 18, type: !62, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!121 = !DILocalVariable(name: "m", arg: 1, scope: !120, file: !28, line: 18, type: !64)
!122 = !DILocation(line: 0, scope: !120)
!123 = !DILocation(line: 20, column: 5, scope: !120)
!124 = !DILocation(line: 21, column: 1, scope: !120)
!125 = distinct !DISubprogram(name: "mutex_lock_fastpath", scope: !28, file: !28, line: 23, type: !126, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!126 = !DISubroutineType(types: !127)
!127 = !{!24, !64}
!128 = !DILocalVariable(name: "m", arg: 1, scope: !125, file: !28, line: 23, type: !64)
!129 = !DILocation(line: 0, scope: !125)
!130 = !DILocalVariable(name: "r", scope: !125, file: !28, line: 25, type: !24)
!131 = !DILocation(line: 26, column: 12, scope: !125)
!132 = !DILocation(line: 26, column: 5, scope: !125)
!133 = distinct !DISubprogram(name: "__futex_wait", scope: !33, file: !33, line: 17, type: !134, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!134 = !DISubroutineType(types: !135)
!135 = !{null, !136, !24}
!136 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!137 = !DILocalVariable(name: "m", arg: 1, scope: !133, file: !33, line: 17, type: !136)
!138 = !DILocation(line: 0, scope: !133)
!139 = !DILocalVariable(name: "v", arg: 2, scope: !133, file: !33, line: 17, type: !24)
!140 = !DILocation(line: 19, column: 13, scope: !133)
!141 = !DILocalVariable(name: "s", scope: !133, file: !33, line: 19, type: !24)
!142 = !DILocation(line: 20, column: 9, scope: !143)
!143 = distinct !DILexicalBlock(scope: !133, file: !33, line: 20, column: 9)
!144 = !DILocation(line: 20, column: 42, scope: !143)
!145 = !DILocation(line: 20, column: 9, scope: !133)
!146 = !DILocation(line: 23, column: 12, scope: !133)
!147 = !DILocation(line: 23, column: 48, scope: !133)
!148 = !DILocation(line: 23, column: 5, scope: !133)
!149 = distinct !{!149, !148, !150, !151}
!150 = !DILocation(line: 24, column: 9, scope: !133)
!151 = !{!"llvm.loop.mustprogress"}
!152 = !DILocation(line: 25, column: 1, scope: !133)
!153 = distinct !DISubprogram(name: "mutex_lock_try_acquire", scope: !28, file: !28, line: 31, type: !126, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!154 = !DILocalVariable(name: "m", arg: 1, scope: !153, file: !28, line: 31, type: !64)
!155 = !DILocation(line: 0, scope: !153)
!156 = !DILocalVariable(name: "r", scope: !153, file: !28, line: 33, type: !24)
!157 = !DILocation(line: 34, column: 12, scope: !153)
!158 = !DILocation(line: 34, column: 5, scope: !153)
!159 = distinct !DISubprogram(name: "mutex_unlock_fastpath", scope: !28, file: !28, line: 55, type: !126, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!160 = !DILocalVariable(name: "m", arg: 1, scope: !159, file: !28, line: 55, type: !64)
!161 = !DILocation(line: 0, scope: !159)
!162 = !DILocalVariable(name: "r", scope: !159, file: !28, line: 57, type: !24)
!163 = !DILocation(line: 58, column: 12, scope: !159)
!164 = !DILocation(line: 58, column: 5, scope: !159)
!165 = distinct !DISubprogram(name: "__futex_wake", scope: !33, file: !33, line: 27, type: !134, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!166 = !DILocalVariable(name: "m", arg: 1, scope: !165, file: !33, line: 27, type: !136)
!167 = !DILocation(line: 0, scope: !165)
!168 = !DILocalVariable(name: "v", arg: 2, scope: !165, file: !33, line: 27, type: !24)
!169 = !DILocation(line: 29, column: 5, scope: !165)
!170 = !DILocation(line: 30, column: 1, scope: !165)
