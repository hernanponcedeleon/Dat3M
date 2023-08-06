; ModuleID = '/home/ponce/git/Dat3M/output/mutex.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/mutex.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@mutex = dso_local global i32 0, align 4, !dbg !28
@shared = dso_local global i32 0, align 4, !dbg !24
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [47 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/mutex.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@sig = internal global i32 0, align 4, !dbg !34

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !45 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !49, metadata !DIExpression()), !dbg !50
  %2 = ptrtoint i8* %0 to i64, !dbg !51
  call void @llvm.dbg.value(metadata i64 %2, metadata !52, metadata !DIExpression()), !dbg !50
  call void @mutex_lock(i32* noundef @mutex), !dbg !53
  %3 = trunc i64 %2 to i32, !dbg !54
  store i32 %3, i32* @shared, align 4, !dbg !55
  call void @llvm.dbg.value(metadata i32 %3, metadata !56, metadata !DIExpression()), !dbg !50
  %4 = sext i32 %3 to i64, !dbg !57
  %5 = icmp eq i64 %4, %2, !dbg !57
  br i1 %5, label %7, label %6, !dbg !60

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5, !dbg !57
  unreachable, !dbg !57

7:                                                ; preds = %1
  %8 = load i32, i32* @sum, align 4, !dbg !61
  %9 = add nsw i32 %8, 1, !dbg !61
  store i32 %9, i32* @sum, align 4, !dbg !61
  call void @mutex_unlock(i32* noundef @mutex), !dbg !62
  ret i8* null, !dbg !63
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @mutex_lock(i32* noundef %0) #0 !dbg !64 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !68, metadata !DIExpression()), !dbg !69
  %2 = call i32 @mutex_lock_fastpath(i32* noundef %0), !dbg !70
  %3 = icmp ne i32 %2, 0, !dbg !70
  br i1 %3, label %10, label %4, !dbg !72

4:                                                ; preds = %4, %1
  call void @llvm.dbg.value(metadata i32 1, metadata !73, metadata !DIExpression()), !dbg !75
  %5 = cmpxchg i32* %0, i32 1, i32 2 monotonic monotonic, align 4, !dbg !76
  %6 = extractvalue { i32, i1 } %5, 1, !dbg !76
  %7 = zext i1 %6 to i8, !dbg !76
  call void @__futex_wait(i32* noundef %0, i32 noundef 2), !dbg !77
  %8 = call i32 @mutex_lock_try_acquire(i32* noundef %0), !dbg !78
  %9 = icmp ne i32 %8, 0, !dbg !78
  br i1 %9, label %10, label %4, !dbg !80, !llvm.loop !81

10:                                               ; preds = %4, %1
  ret void, !dbg !84
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @mutex_unlock(i32* noundef %0) #0 !dbg !85 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !86, metadata !DIExpression()), !dbg !87
  %2 = call i32 @mutex_unlock_fastpath(i32* noundef %0), !dbg !88
  %3 = icmp ne i32 %2, 0, !dbg !88
  br i1 %3, label %5, label %4, !dbg !90

4:                                                ; preds = %1
  store atomic i32 0, i32* %0 release, align 4, !dbg !91
  call void @__futex_wake(i32* noundef %0, i32 noundef 1), !dbg !92
  br label %5, !dbg !93

5:                                                ; preds = %1, %4
  ret void, !dbg !93
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !94 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !97, metadata !DIExpression()), !dbg !103
  call void @mutex_init(i32* noundef @mutex), !dbg !104
  call void @llvm.dbg.value(metadata i32 0, metadata !105, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.value(metadata i64 0, metadata !105, metadata !DIExpression()), !dbg !107
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !108
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #6, !dbg !110
  call void @llvm.dbg.value(metadata i64 1, metadata !105, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.value(metadata i64 1, metadata !105, metadata !DIExpression()), !dbg !107
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !108
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !110
  call void @llvm.dbg.value(metadata i64 2, metadata !105, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.value(metadata i64 2, metadata !105, metadata !DIExpression()), !dbg !107
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !108
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !110
  call void @llvm.dbg.value(metadata i64 3, metadata !105, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.value(metadata i64 3, metadata !105, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.value(metadata i32 0, metadata !111, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.value(metadata i64 0, metadata !111, metadata !DIExpression()), !dbg !113
  %8 = load i64, i64* %2, align 8, !dbg !114
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !116
  call void @llvm.dbg.value(metadata i64 1, metadata !111, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.value(metadata i64 1, metadata !111, metadata !DIExpression()), !dbg !113
  %10 = load i64, i64* %4, align 8, !dbg !114
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !116
  call void @llvm.dbg.value(metadata i64 2, metadata !111, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.value(metadata i64 2, metadata !111, metadata !DIExpression()), !dbg !113
  %12 = load i64, i64* %6, align 8, !dbg !114
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !116
  call void @llvm.dbg.value(metadata i64 3, metadata !111, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.value(metadata i64 3, metadata !111, metadata !DIExpression()), !dbg !113
  %14 = load i32, i32* @sum, align 4, !dbg !117
  %15 = icmp eq i32 %14, 3, !dbg !117
  br i1 %15, label %17, label %16, !dbg !120

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !117
  unreachable, !dbg !117

17:                                               ; preds = %0
  ret i32 0, !dbg !121
}

; Function Attrs: noinline nounwind uwtable
define internal void @mutex_init(i32* noundef %0) #0 !dbg !122 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !123, metadata !DIExpression()), !dbg !124
  store i32 0, i32* %0, align 4, !dbg !125
  ret void, !dbg !126
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @mutex_lock_fastpath(i32* noundef %0) #0 !dbg !127 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !130, metadata !DIExpression()), !dbg !131
  call void @llvm.dbg.value(metadata i32 0, metadata !132, metadata !DIExpression()), !dbg !131
  %2 = cmpxchg i32* %0, i32 0, i32 1 acquire acquire, align 4, !dbg !133
  %3 = extractvalue { i32, i1 } %2, 1, !dbg !133
  %4 = zext i1 %3 to i8, !dbg !133
  %5 = zext i1 %3 to i32, !dbg !133
  ret i32 %5, !dbg !134
}

; Function Attrs: noinline nounwind uwtable
define internal void @__futex_wait(i32* noundef %0, i32 noundef %1) #0 !dbg !135 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !139, metadata !DIExpression()), !dbg !140
  call void @llvm.dbg.value(metadata i32 %1, metadata !141, metadata !DIExpression()), !dbg !140
  %3 = load atomic i32, i32* @sig acquire, align 4, !dbg !142
  call void @llvm.dbg.value(metadata i32 %3, metadata !143, metadata !DIExpression()), !dbg !140
  %4 = load atomic i32, i32* %0 acquire, align 4, !dbg !144
  %5 = icmp ne i32 %4, %1, !dbg !146
  br i1 %5, label %.loopexit, label %6, !dbg !147

6:                                                ; preds = %6, %2
  %7 = load atomic i32, i32* @sig acquire, align 4, !dbg !148
  %8 = icmp eq i32 %7, %3, !dbg !149
  br i1 %8, label %6, label %.loopexit, !dbg !150, !llvm.loop !151

.loopexit:                                        ; preds = %6, %2
  ret void, !dbg !154
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @mutex_lock_try_acquire(i32* noundef %0) #0 !dbg !155 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !156, metadata !DIExpression()), !dbg !157
  call void @llvm.dbg.value(metadata i32 0, metadata !158, metadata !DIExpression()), !dbg !157
  %2 = cmpxchg i32* %0, i32 0, i32 2 acquire acquire, align 4, !dbg !159
  %3 = extractvalue { i32, i1 } %2, 1, !dbg !159
  %4 = zext i1 %3 to i8, !dbg !159
  %5 = zext i1 %3 to i32, !dbg !159
  ret i32 %5, !dbg !160
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @mutex_unlock_fastpath(i32* noundef %0) #0 !dbg !161 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !162, metadata !DIExpression()), !dbg !163
  call void @llvm.dbg.value(metadata i32 1, metadata !164, metadata !DIExpression()), !dbg !163
  %2 = cmpxchg i32* %0, i32 1, i32 0 release monotonic, align 4, !dbg !165
  %3 = extractvalue { i32, i1 } %2, 1, !dbg !165
  %4 = zext i1 %3 to i8, !dbg !165
  %5 = zext i1 %3 to i32, !dbg !165
  ret i32 %5, !dbg !166
}

; Function Attrs: noinline nounwind uwtable
define internal void @__futex_wake(i32* noundef %0, i32 noundef %1) #0 !dbg !167 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !168, metadata !DIExpression()), !dbg !169
  call void @llvm.dbg.value(metadata i32 %1, metadata !170, metadata !DIExpression()), !dbg !169
  %3 = atomicrmw add i32* @sig, i32 1 release, align 4, !dbg !171
  ret void, !dbg !172
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
!llvm.module.flags = !{!37, !38, !39, !40, !41, !42, !43}
!llvm.ident = !{!44}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !26, line: 11, type: !27, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !23, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "22debaaf328dcd08f10164ee2a61a019")
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
!23 = !{!0, !24, !28, !34}
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !26, line: 9, type: !27, isLocal: false, isDefinition: true)
!26 = !DIFile(filename: "benchmarks/locks/mutex.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "22debaaf328dcd08f10164ee2a61a019")
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !26, line: 10, type: !30, isLocal: false, isDefinition: true)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "mutex_t", file: !31, line: 16, baseType: !32)
!31 = !DIFile(filename: "benchmarks/locks/mutex.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "38ec3b6ce739789a23bba4a8c8425857")
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !33)
!33 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !27)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "sig", scope: !2, file: !36, line: 15, type: !32, isLocal: true, isDefinition: true)
!36 = !DIFile(filename: "benchmarks/locks/futex.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "cb5dc9517b2fd37660598e8a5b273f61")
!37 = !{i32 7, !"Dwarf Version", i32 5}
!38 = !{i32 2, !"Debug Info Version", i32 3}
!39 = !{i32 1, !"wchar_size", i32 4}
!40 = !{i32 7, !"PIC Level", i32 2}
!41 = !{i32 7, !"PIE Level", i32 2}
!42 = !{i32 7, !"uwtable", i32 1}
!43 = !{i32 7, !"frame-pointer", i32 2}
!44 = !{!"Ubuntu clang version 14.0.6"}
!45 = distinct !DISubprogram(name: "thread_n", scope: !26, file: !26, line: 13, type: !46, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !48)
!46 = !DISubroutineType(types: !47)
!47 = !{!19, !19}
!48 = !{}
!49 = !DILocalVariable(name: "arg", arg: 1, scope: !45, file: !26, line: 13, type: !19)
!50 = !DILocation(line: 0, scope: !45)
!51 = !DILocation(line: 15, column: 23, scope: !45)
!52 = !DILocalVariable(name: "index", scope: !45, file: !26, line: 15, type: !16)
!53 = !DILocation(line: 17, column: 5, scope: !45)
!54 = !DILocation(line: 18, column: 14, scope: !45)
!55 = !DILocation(line: 18, column: 12, scope: !45)
!56 = !DILocalVariable(name: "r", scope: !45, file: !26, line: 19, type: !27)
!57 = !DILocation(line: 20, column: 5, scope: !58)
!58 = distinct !DILexicalBlock(scope: !59, file: !26, line: 20, column: 5)
!59 = distinct !DILexicalBlock(scope: !45, file: !26, line: 20, column: 5)
!60 = !DILocation(line: 20, column: 5, scope: !59)
!61 = !DILocation(line: 21, column: 8, scope: !45)
!62 = !DILocation(line: 22, column: 5, scope: !45)
!63 = !DILocation(line: 23, column: 5, scope: !45)
!64 = distinct !DISubprogram(name: "mutex_lock", scope: !31, file: !31, line: 39, type: !65, scopeLine: 40, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!65 = !DISubroutineType(types: !66)
!66 = !{null, !67}
!67 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!68 = !DILocalVariable(name: "m", arg: 1, scope: !64, file: !31, line: 39, type: !67)
!69 = !DILocation(line: 0, scope: !64)
!70 = !DILocation(line: 41, column: 9, scope: !71)
!71 = distinct !DILexicalBlock(scope: !64, file: !31, line: 41, column: 9)
!72 = !DILocation(line: 41, column: 9, scope: !64)
!73 = !DILocalVariable(name: "r", scope: !74, file: !31, line: 45, type: !27)
!74 = distinct !DILexicalBlock(scope: !64, file: !31, line: 44, column: 15)
!75 = !DILocation(line: 0, scope: !74)
!76 = !DILocation(line: 46, column: 9, scope: !74)
!77 = !DILocation(line: 49, column: 9, scope: !74)
!78 = !DILocation(line: 50, column: 13, scope: !79)
!79 = distinct !DILexicalBlock(scope: !74, file: !31, line: 50, column: 13)
!80 = !DILocation(line: 50, column: 13, scope: !74)
!81 = distinct !{!81, !82, !83}
!82 = !DILocation(line: 44, column: 5, scope: !64)
!83 = !DILocation(line: 52, column: 5, scope: !64)
!84 = !DILocation(line: 53, column: 1, scope: !64)
!85 = distinct !DISubprogram(name: "mutex_unlock", scope: !31, file: !31, line: 63, type: !65, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!86 = !DILocalVariable(name: "m", arg: 1, scope: !85, file: !31, line: 63, type: !67)
!87 = !DILocation(line: 0, scope: !85)
!88 = !DILocation(line: 65, column: 9, scope: !89)
!89 = distinct !DILexicalBlock(scope: !85, file: !31, line: 65, column: 9)
!90 = !DILocation(line: 65, column: 9, scope: !85)
!91 = !DILocation(line: 68, column: 5, scope: !85)
!92 = !DILocation(line: 69, column: 5, scope: !85)
!93 = !DILocation(line: 70, column: 1, scope: !85)
!94 = distinct !DISubprogram(name: "main", scope: !26, file: !26, line: 26, type: !95, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !48)
!95 = !DISubroutineType(types: !96)
!96 = !{!27}
!97 = !DILocalVariable(name: "t", scope: !94, file: !26, line: 28, type: !98)
!98 = !DICompositeType(tag: DW_TAG_array_type, baseType: !99, size: 192, elements: !101)
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !100, line: 27, baseType: !22)
!100 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!101 = !{!102}
!102 = !DISubrange(count: 3)
!103 = !DILocation(line: 28, column: 15, scope: !94)
!104 = !DILocation(line: 30, column: 5, scope: !94)
!105 = !DILocalVariable(name: "i", scope: !106, file: !26, line: 32, type: !27)
!106 = distinct !DILexicalBlock(scope: !94, file: !26, line: 32, column: 5)
!107 = !DILocation(line: 0, scope: !106)
!108 = !DILocation(line: 33, column: 25, scope: !109)
!109 = distinct !DILexicalBlock(scope: !106, file: !26, line: 32, column: 5)
!110 = !DILocation(line: 33, column: 9, scope: !109)
!111 = !DILocalVariable(name: "i", scope: !112, file: !26, line: 35, type: !27)
!112 = distinct !DILexicalBlock(scope: !94, file: !26, line: 35, column: 5)
!113 = !DILocation(line: 0, scope: !112)
!114 = !DILocation(line: 36, column: 22, scope: !115)
!115 = distinct !DILexicalBlock(scope: !112, file: !26, line: 35, column: 5)
!116 = !DILocation(line: 36, column: 9, scope: !115)
!117 = !DILocation(line: 38, column: 5, scope: !118)
!118 = distinct !DILexicalBlock(scope: !119, file: !26, line: 38, column: 5)
!119 = distinct !DILexicalBlock(scope: !94, file: !26, line: 38, column: 5)
!120 = !DILocation(line: 38, column: 5, scope: !119)
!121 = !DILocation(line: 40, column: 5, scope: !94)
!122 = distinct !DISubprogram(name: "mutex_init", scope: !31, file: !31, line: 18, type: !65, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!123 = !DILocalVariable(name: "m", arg: 1, scope: !122, file: !31, line: 18, type: !67)
!124 = !DILocation(line: 0, scope: !122)
!125 = !DILocation(line: 20, column: 5, scope: !122)
!126 = !DILocation(line: 21, column: 1, scope: !122)
!127 = distinct !DISubprogram(name: "mutex_lock_fastpath", scope: !31, file: !31, line: 23, type: !128, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!128 = !DISubroutineType(types: !129)
!129 = !{!27, !67}
!130 = !DILocalVariable(name: "m", arg: 1, scope: !127, file: !31, line: 23, type: !67)
!131 = !DILocation(line: 0, scope: !127)
!132 = !DILocalVariable(name: "r", scope: !127, file: !31, line: 25, type: !27)
!133 = !DILocation(line: 26, column: 12, scope: !127)
!134 = !DILocation(line: 26, column: 5, scope: !127)
!135 = distinct !DISubprogram(name: "__futex_wait", scope: !36, file: !36, line: 17, type: !136, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!136 = !DISubroutineType(types: !137)
!137 = !{null, !138, !27}
!138 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!139 = !DILocalVariable(name: "m", arg: 1, scope: !135, file: !36, line: 17, type: !138)
!140 = !DILocation(line: 0, scope: !135)
!141 = !DILocalVariable(name: "v", arg: 2, scope: !135, file: !36, line: 17, type: !27)
!142 = !DILocation(line: 19, column: 13, scope: !135)
!143 = !DILocalVariable(name: "s", scope: !135, file: !36, line: 19, type: !27)
!144 = !DILocation(line: 20, column: 9, scope: !145)
!145 = distinct !DILexicalBlock(scope: !135, file: !36, line: 20, column: 9)
!146 = !DILocation(line: 20, column: 42, scope: !145)
!147 = !DILocation(line: 20, column: 9, scope: !135)
!148 = !DILocation(line: 23, column: 12, scope: !135)
!149 = !DILocation(line: 23, column: 48, scope: !135)
!150 = !DILocation(line: 23, column: 5, scope: !135)
!151 = distinct !{!151, !150, !152, !153}
!152 = !DILocation(line: 24, column: 9, scope: !135)
!153 = !{!"llvm.loop.mustprogress"}
!154 = !DILocation(line: 25, column: 1, scope: !135)
!155 = distinct !DISubprogram(name: "mutex_lock_try_acquire", scope: !31, file: !31, line: 31, type: !128, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!156 = !DILocalVariable(name: "m", arg: 1, scope: !155, file: !31, line: 31, type: !67)
!157 = !DILocation(line: 0, scope: !155)
!158 = !DILocalVariable(name: "r", scope: !155, file: !31, line: 33, type: !27)
!159 = !DILocation(line: 34, column: 12, scope: !155)
!160 = !DILocation(line: 34, column: 5, scope: !155)
!161 = distinct !DISubprogram(name: "mutex_unlock_fastpath", scope: !31, file: !31, line: 55, type: !128, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!162 = !DILocalVariable(name: "m", arg: 1, scope: !161, file: !31, line: 55, type: !67)
!163 = !DILocation(line: 0, scope: !161)
!164 = !DILocalVariable(name: "r", scope: !161, file: !31, line: 57, type: !27)
!165 = !DILocation(line: 58, column: 12, scope: !161)
!166 = !DILocation(line: 58, column: 5, scope: !161)
!167 = distinct !DISubprogram(name: "__futex_wake", scope: !36, file: !36, line: 27, type: !136, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!168 = !DILocalVariable(name: "m", arg: 1, scope: !167, file: !36, line: 27, type: !138)
!169 = !DILocation(line: 0, scope: !167)
!170 = !DILocalVariable(name: "v", arg: 2, scope: !167, file: !36, line: 27, type: !27)
!171 = !DILocation(line: 29, column: 5, scope: !167)
!172 = !DILocation(line: 30, column: 1, scope: !167)
