; ModuleID = 'output/spinlock.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/spinlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.spinlock_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@lock = dso_local global %struct.spinlock_s zeroinitializer, align 4, !dbg !25
@shared = dso_local global i32 0, align 4, !dbg !21
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [50 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/spinlock.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !42 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !46, metadata !DIExpression()), !dbg !47
  %2 = ptrtoint i8* %0 to i64, !dbg !48
  call void @llvm.dbg.value(metadata i64 %2, metadata !49, metadata !DIExpression()), !dbg !47
  call void @spinlock_acquire(%struct.spinlock_s* noundef @lock), !dbg !50
  %3 = trunc i64 %2 to i32, !dbg !51
  store i32 %3, i32* @shared, align 4, !dbg !52
  call void @llvm.dbg.value(metadata i32 %3, metadata !53, metadata !DIExpression()), !dbg !47
  %4 = sext i32 %3 to i64, !dbg !54
  %5 = icmp eq i64 %4, %2, !dbg !54
  br i1 %5, label %7, label %6, !dbg !57

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5, !dbg !54
  unreachable, !dbg !54

7:                                                ; preds = %1
  %8 = load i32, i32* @sum, align 4, !dbg !58
  %9 = add nsw i32 %8, 1, !dbg !58
  store i32 %9, i32* @sum, align 4, !dbg !58
  call void @spinlock_release(%struct.spinlock_s* noundef @lock), !dbg !59
  ret i8* null, !dbg !60
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @spinlock_acquire(%struct.spinlock_s* noundef %0) #0 !dbg !61 {
  call void @llvm.dbg.value(metadata %struct.spinlock_s* %0, metadata !65, metadata !DIExpression()), !dbg !66
  br label %2, !dbg !67

2:                                                ; preds = %2, %1
  call void @await_for_lock(%struct.spinlock_s* noundef %0), !dbg !68
  %3 = call i32 @try_get_lock(%struct.spinlock_s* noundef %0), !dbg !70
  %4 = icmp ne i32 %3, 0, !dbg !71
  %5 = xor i1 %4, true, !dbg !71
  br i1 %5, label %2, label %6, !dbg !72, !llvm.loop !73

6:                                                ; preds = %2
  ret void, !dbg !76
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @spinlock_release(%struct.spinlock_s* noundef %0) #0 !dbg !77 {
  call void @llvm.dbg.value(metadata %struct.spinlock_s* %0, metadata !78, metadata !DIExpression()), !dbg !79
  %2 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %0, i32 0, i32 0, !dbg !80
  store atomic i32 0, i32* %2 release, align 4, !dbg !81
  ret void, !dbg !82
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !83 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !86, metadata !DIExpression()), !dbg !93
  call void @spinlock_init(%struct.spinlock_s* noundef @lock), !dbg !94
  call void @llvm.dbg.value(metadata i32 0, metadata !95, metadata !DIExpression()), !dbg !97
  call void @llvm.dbg.value(metadata i64 0, metadata !95, metadata !DIExpression()), !dbg !97
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !98
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #6, !dbg !100
  call void @llvm.dbg.value(metadata i64 1, metadata !95, metadata !DIExpression()), !dbg !97
  call void @llvm.dbg.value(metadata i64 1, metadata !95, metadata !DIExpression()), !dbg !97
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !98
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !100
  call void @llvm.dbg.value(metadata i64 2, metadata !95, metadata !DIExpression()), !dbg !97
  call void @llvm.dbg.value(metadata i64 2, metadata !95, metadata !DIExpression()), !dbg !97
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !98
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !100
  call void @llvm.dbg.value(metadata i64 3, metadata !95, metadata !DIExpression()), !dbg !97
  call void @llvm.dbg.value(metadata i64 3, metadata !95, metadata !DIExpression()), !dbg !97
  call void @llvm.dbg.value(metadata i32 0, metadata !101, metadata !DIExpression()), !dbg !103
  call void @llvm.dbg.value(metadata i64 0, metadata !101, metadata !DIExpression()), !dbg !103
  %8 = load i64, i64* %2, align 8, !dbg !104
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !106
  call void @llvm.dbg.value(metadata i64 1, metadata !101, metadata !DIExpression()), !dbg !103
  call void @llvm.dbg.value(metadata i64 1, metadata !101, metadata !DIExpression()), !dbg !103
  %10 = load i64, i64* %4, align 8, !dbg !104
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !106
  call void @llvm.dbg.value(metadata i64 2, metadata !101, metadata !DIExpression()), !dbg !103
  call void @llvm.dbg.value(metadata i64 2, metadata !101, metadata !DIExpression()), !dbg !103
  %12 = load i64, i64* %6, align 8, !dbg !104
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !106
  call void @llvm.dbg.value(metadata i64 3, metadata !101, metadata !DIExpression()), !dbg !103
  call void @llvm.dbg.value(metadata i64 3, metadata !101, metadata !DIExpression()), !dbg !103
  %14 = load i32, i32* @sum, align 4, !dbg !107
  %15 = icmp eq i32 %14, 3, !dbg !107
  br i1 %15, label %17, label %16, !dbg !110

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !107
  unreachable, !dbg !107

17:                                               ; preds = %0
  ret i32 0, !dbg !111
}

; Function Attrs: noinline nounwind uwtable
define internal void @spinlock_init(%struct.spinlock_s* noundef %0) #0 !dbg !112 {
  call void @llvm.dbg.value(metadata %struct.spinlock_s* %0, metadata !113, metadata !DIExpression()), !dbg !114
  %2 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %0, i32 0, i32 0, !dbg !115
  store i32 0, i32* %2, align 4, !dbg !116
  ret void, !dbg !117
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @await_for_lock(%struct.spinlock_s* noundef %0) #0 !dbg !118 {
  call void @llvm.dbg.value(metadata %struct.spinlock_s* %0, metadata !119, metadata !DIExpression()), !dbg !120
  br label %2, !dbg !121

2:                                                ; preds = %2, %1
  %3 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %0, i32 0, i32 0, !dbg !122
  %4 = load atomic i32, i32* %3 monotonic, align 4, !dbg !123
  %5 = icmp ne i32 %4, 0, !dbg !124
  br i1 %5, label %2, label %6, !dbg !121, !llvm.loop !125

6:                                                ; preds = %2
  ret void, !dbg !127
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @try_get_lock(%struct.spinlock_s* noundef %0) #0 !dbg !128 {
  call void @llvm.dbg.value(metadata %struct.spinlock_s* %0, metadata !131, metadata !DIExpression()), !dbg !132
  call void @llvm.dbg.value(metadata i32 0, metadata !133, metadata !DIExpression()), !dbg !132
  %2 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %0, i32 0, i32 0, !dbg !134
  %3 = cmpxchg i32* %2, i32 0, i32 1 acquire acquire, align 4, !dbg !135
  %4 = extractvalue { i32, i1 } %3, 1, !dbg !135
  %5 = zext i1 %4 to i8, !dbg !135
  %6 = zext i1 %4 to i32, !dbg !135
  ret i32 %6, !dbg !136
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
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/spinlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "ffa77402b1b5b5f477e9ff7f4e14b40d")
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
!20 = !{!0, !21, !25}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !23, line: 9, type: !24, isLocal: false, isDefinition: true)
!23 = !DIFile(filename: "benchmarks/locks/spinlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "ffa77402b1b5b5f477e9ff7f4e14b40d")
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !23, line: 10, type: !27, isLocal: false, isDefinition: true)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "spinlock_t", file: !28, line: 18, baseType: !29)
!28 = !DIFile(filename: "benchmarks/locks/spinlock.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "6a0cf149af91d1c9faaa85e0d115268c")
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "spinlock_s", file: !28, line: 14, size: 32, elements: !30)
!30 = !{!31}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !29, file: !28, line: 15, baseType: !32, size: 32)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !33)
!33 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !24)
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
!61 = distinct !DISubprogram(name: "spinlock_acquire", scope: !28, file: !28, line: 40, type: !62, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!62 = !DISubroutineType(types: !63)
!63 = !{null, !64}
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!65 = !DILocalVariable(name: "l", arg: 1, scope: !61, file: !28, line: 40, type: !64)
!66 = !DILocation(line: 0, scope: !61)
!67 = !DILocation(line: 42, column: 5, scope: !61)
!68 = !DILocation(line: 43, column: 9, scope: !69)
!69 = distinct !DILexicalBlock(scope: !61, file: !28, line: 42, column: 8)
!70 = !DILocation(line: 44, column: 14, scope: !61)
!71 = !DILocation(line: 44, column: 13, scope: !61)
!72 = !DILocation(line: 44, column: 5, scope: !69)
!73 = distinct !{!73, !67, !74, !75}
!74 = !DILocation(line: 44, column: 29, scope: !61)
!75 = !{!"llvm.loop.mustprogress"}
!76 = !DILocation(line: 45, column: 5, scope: !61)
!77 = distinct !DISubprogram(name: "spinlock_release", scope: !28, file: !28, line: 53, type: !62, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!78 = !DILocalVariable(name: "l", arg: 1, scope: !77, file: !28, line: 53, type: !64)
!79 = !DILocation(line: 0, scope: !77)
!80 = !DILocation(line: 55, column: 31, scope: !77)
!81 = !DILocation(line: 55, column: 5, scope: !77)
!82 = !DILocation(line: 56, column: 1, scope: !77)
!83 = distinct !DISubprogram(name: "main", scope: !23, file: !23, line: 26, type: !84, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!84 = !DISubroutineType(types: !85)
!85 = !{!24}
!86 = !DILocalVariable(name: "t", scope: !83, file: !23, line: 28, type: !87)
!87 = !DICompositeType(tag: DW_TAG_array_type, baseType: !88, size: 192, elements: !91)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !89, line: 27, baseType: !90)
!89 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!90 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!91 = !{!92}
!92 = !DISubrange(count: 3)
!93 = !DILocation(line: 28, column: 15, scope: !83)
!94 = !DILocation(line: 30, column: 5, scope: !83)
!95 = !DILocalVariable(name: "i", scope: !96, file: !23, line: 32, type: !24)
!96 = distinct !DILexicalBlock(scope: !83, file: !23, line: 32, column: 5)
!97 = !DILocation(line: 0, scope: !96)
!98 = !DILocation(line: 33, column: 25, scope: !99)
!99 = distinct !DILexicalBlock(scope: !96, file: !23, line: 32, column: 5)
!100 = !DILocation(line: 33, column: 9, scope: !99)
!101 = !DILocalVariable(name: "i", scope: !102, file: !23, line: 35, type: !24)
!102 = distinct !DILexicalBlock(scope: !83, file: !23, line: 35, column: 5)
!103 = !DILocation(line: 0, scope: !102)
!104 = !DILocation(line: 36, column: 22, scope: !105)
!105 = distinct !DILexicalBlock(scope: !102, file: !23, line: 35, column: 5)
!106 = !DILocation(line: 36, column: 9, scope: !105)
!107 = !DILocation(line: 38, column: 5, scope: !108)
!108 = distinct !DILexicalBlock(scope: !109, file: !23, line: 38, column: 5)
!109 = distinct !DILexicalBlock(scope: !83, file: !23, line: 38, column: 5)
!110 = !DILocation(line: 38, column: 5, scope: !109)
!111 = !DILocation(line: 40, column: 5, scope: !83)
!112 = distinct !DISubprogram(name: "spinlock_init", scope: !28, file: !28, line: 20, type: !62, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!113 = !DILocalVariable(name: "l", arg: 1, scope: !112, file: !28, line: 20, type: !64)
!114 = !DILocation(line: 0, scope: !112)
!115 = !DILocation(line: 22, column: 21, scope: !112)
!116 = !DILocation(line: 22, column: 5, scope: !112)
!117 = !DILocation(line: 23, column: 1, scope: !112)
!118 = distinct !DISubprogram(name: "await_for_lock", scope: !28, file: !28, line: 25, type: !62, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!119 = !DILocalVariable(name: "l", arg: 1, scope: !118, file: !28, line: 25, type: !64)
!120 = !DILocation(line: 0, scope: !118)
!121 = !DILocation(line: 27, column: 5, scope: !118)
!122 = !DILocation(line: 27, column: 37, scope: !118)
!123 = !DILocation(line: 27, column: 12, scope: !118)
!124 = !DILocation(line: 27, column: 65, scope: !118)
!125 = distinct !{!125, !121, !126, !75}
!126 = !DILocation(line: 28, column: 9, scope: !118)
!127 = !DILocation(line: 29, column: 5, scope: !118)
!128 = distinct !DISubprogram(name: "try_get_lock", scope: !28, file: !28, line: 32, type: !129, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!129 = !DISubroutineType(types: !130)
!130 = !{!24, !64}
!131 = !DILocalVariable(name: "l", arg: 1, scope: !128, file: !28, line: 32, type: !64)
!132 = !DILocation(line: 0, scope: !128)
!133 = !DILocalVariable(name: "val", scope: !128, file: !28, line: 34, type: !24)
!134 = !DILocation(line: 35, column: 56, scope: !128)
!135 = !DILocation(line: 35, column: 12, scope: !128)
!136 = !DILocation(line: 35, column: 5, scope: !128)
