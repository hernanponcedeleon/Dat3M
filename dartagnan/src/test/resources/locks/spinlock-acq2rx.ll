; ModuleID = '/home/ponce/git/Dat3M/output/spinlock.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/spinlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.spinlock_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@lock = dso_local global %struct.spinlock_s zeroinitializer, align 4, !dbg !28
@shared = dso_local global i32 0, align 4, !dbg !24
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [50 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/spinlock.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !45 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !49, metadata !DIExpression()), !dbg !50
  %2 = ptrtoint i8* %0 to i64, !dbg !51
  call void @llvm.dbg.value(metadata i64 %2, metadata !52, metadata !DIExpression()), !dbg !50
  call void @spinlock_acquire(%struct.spinlock_s* noundef @lock), !dbg !53
  %3 = trunc i64 %2 to i32, !dbg !54
  store i32 %3, i32* @shared, align 4, !dbg !55
  call void @llvm.dbg.value(metadata i32 %3, metadata !56, metadata !DIExpression()), !dbg !50
  %4 = sext i32 %3 to i64, !dbg !57
  %5 = icmp eq i64 %4, %2, !dbg !57
  br i1 %5, label %7, label %6, !dbg !60

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5, !dbg !57
  unreachable, !dbg !57

7:                                                ; preds = %1
  %8 = load i32, i32* @sum, align 4, !dbg !61
  %9 = add nsw i32 %8, 1, !dbg !61
  store i32 %9, i32* @sum, align 4, !dbg !61
  call void @spinlock_release(%struct.spinlock_s* noundef @lock), !dbg !62
  ret i8* null, !dbg !63
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @spinlock_acquire(%struct.spinlock_s* noundef %0) #0 !dbg !64 {
  call void @llvm.dbg.value(metadata %struct.spinlock_s* %0, metadata !68, metadata !DIExpression()), !dbg !69
  br label %2, !dbg !70

2:                                                ; preds = %2, %1
  call void @await_for_lock(%struct.spinlock_s* noundef %0), !dbg !71
  %3 = call i32 @try_get_lock(%struct.spinlock_s* noundef %0), !dbg !73
  %4 = icmp ne i32 %3, 0, !dbg !74
  %5 = xor i1 %4, true, !dbg !74
  br i1 %5, label %2, label %6, !dbg !75, !llvm.loop !76

6:                                                ; preds = %2
  ret void, !dbg !79
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @spinlock_release(%struct.spinlock_s* noundef %0) #0 !dbg !80 {
  call void @llvm.dbg.value(metadata %struct.spinlock_s* %0, metadata !81, metadata !DIExpression()), !dbg !82
  %2 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %0, i32 0, i32 0, !dbg !83
  store atomic i32 0, i32* %2 release, align 4, !dbg !84
  ret void, !dbg !85
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !86 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !89, metadata !DIExpression()), !dbg !95
  call void @spinlock_init(%struct.spinlock_s* noundef @lock), !dbg !96
  call void @llvm.dbg.value(metadata i32 0, metadata !97, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata i64 0, metadata !97, metadata !DIExpression()), !dbg !99
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !100
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #6, !dbg !102
  call void @llvm.dbg.value(metadata i64 1, metadata !97, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata i64 1, metadata !97, metadata !DIExpression()), !dbg !99
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !100
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !102
  call void @llvm.dbg.value(metadata i64 2, metadata !97, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata i64 2, metadata !97, metadata !DIExpression()), !dbg !99
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !100
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !102
  call void @llvm.dbg.value(metadata i64 3, metadata !97, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata i64 3, metadata !97, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata i32 0, metadata !103, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i64 0, metadata !103, metadata !DIExpression()), !dbg !105
  %8 = load i64, i64* %2, align 8, !dbg !106
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !108
  call void @llvm.dbg.value(metadata i64 1, metadata !103, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i64 1, metadata !103, metadata !DIExpression()), !dbg !105
  %10 = load i64, i64* %4, align 8, !dbg !106
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !108
  call void @llvm.dbg.value(metadata i64 2, metadata !103, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i64 2, metadata !103, metadata !DIExpression()), !dbg !105
  %12 = load i64, i64* %6, align 8, !dbg !106
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !108
  call void @llvm.dbg.value(metadata i64 3, metadata !103, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i64 3, metadata !103, metadata !DIExpression()), !dbg !105
  %14 = load i32, i32* @sum, align 4, !dbg !109
  %15 = icmp eq i32 %14, 3, !dbg !109
  br i1 %15, label %17, label %16, !dbg !112

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !109
  unreachable, !dbg !109

17:                                               ; preds = %0
  ret i32 0, !dbg !113
}

; Function Attrs: noinline nounwind uwtable
define internal void @spinlock_init(%struct.spinlock_s* noundef %0) #0 !dbg !114 {
  call void @llvm.dbg.value(metadata %struct.spinlock_s* %0, metadata !115, metadata !DIExpression()), !dbg !116
  %2 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %0, i32 0, i32 0, !dbg !117
  store i32 0, i32* %2, align 4, !dbg !118
  ret void, !dbg !119
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @await_for_lock(%struct.spinlock_s* noundef %0) #0 !dbg !120 {
  call void @llvm.dbg.value(metadata %struct.spinlock_s* %0, metadata !121, metadata !DIExpression()), !dbg !122
  br label %2, !dbg !123

2:                                                ; preds = %2, %1
  %3 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %0, i32 0, i32 0, !dbg !124
  %4 = load atomic i32, i32* %3 monotonic, align 4, !dbg !125
  %5 = icmp ne i32 %4, 0, !dbg !126
  br i1 %5, label %2, label %6, !dbg !123, !llvm.loop !127

6:                                                ; preds = %2
  ret void, !dbg !129
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @try_get_lock(%struct.spinlock_s* noundef %0) #0 !dbg !130 {
  call void @llvm.dbg.value(metadata %struct.spinlock_s* %0, metadata !133, metadata !DIExpression()), !dbg !134
  call void @llvm.dbg.value(metadata i32 0, metadata !135, metadata !DIExpression()), !dbg !134
  %2 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %0, i32 0, i32 0, !dbg !136
  %3 = cmpxchg i32* %2, i32 0, i32 1 monotonic monotonic, align 4, !dbg !137
  %4 = extractvalue { i32, i1 } %3, 1, !dbg !137
  %5 = zext i1 %4 to i8, !dbg !137
  %6 = zext i1 %4 to i32, !dbg !137
  ret i32 %6, !dbg !138
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
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/spinlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "9111cb07fd40644b9707eb76d95b6df4")
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
!23 = !{!0, !24, !28}
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !26, line: 9, type: !27, isLocal: false, isDefinition: true)
!26 = !DIFile(filename: "benchmarks/locks/spinlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "9111cb07fd40644b9707eb76d95b6df4")
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !26, line: 10, type: !30, isLocal: false, isDefinition: true)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "spinlock_t", file: !31, line: 18, baseType: !32)
!31 = !DIFile(filename: "benchmarks/locks/spinlock.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "6a0cf149af91d1c9faaa85e0d115268c")
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "spinlock_s", file: !31, line: 14, size: 32, elements: !33)
!33 = !{!34}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !32, file: !31, line: 15, baseType: !35, size: 32)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !36)
!36 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !27)
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
!64 = distinct !DISubprogram(name: "spinlock_acquire", scope: !31, file: !31, line: 40, type: !65, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!65 = !DISubroutineType(types: !66)
!66 = !{null, !67}
!67 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!68 = !DILocalVariable(name: "l", arg: 1, scope: !64, file: !31, line: 40, type: !67)
!69 = !DILocation(line: 0, scope: !64)
!70 = !DILocation(line: 42, column: 5, scope: !64)
!71 = !DILocation(line: 43, column: 9, scope: !72)
!72 = distinct !DILexicalBlock(scope: !64, file: !31, line: 42, column: 8)
!73 = !DILocation(line: 44, column: 14, scope: !64)
!74 = !DILocation(line: 44, column: 13, scope: !64)
!75 = !DILocation(line: 44, column: 5, scope: !72)
!76 = distinct !{!76, !70, !77, !78}
!77 = !DILocation(line: 44, column: 29, scope: !64)
!78 = !{!"llvm.loop.mustprogress"}
!79 = !DILocation(line: 45, column: 5, scope: !64)
!80 = distinct !DISubprogram(name: "spinlock_release", scope: !31, file: !31, line: 53, type: !65, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!81 = !DILocalVariable(name: "l", arg: 1, scope: !80, file: !31, line: 53, type: !67)
!82 = !DILocation(line: 0, scope: !80)
!83 = !DILocation(line: 55, column: 31, scope: !80)
!84 = !DILocation(line: 55, column: 5, scope: !80)
!85 = !DILocation(line: 56, column: 1, scope: !80)
!86 = distinct !DISubprogram(name: "main", scope: !26, file: !26, line: 26, type: !87, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !48)
!87 = !DISubroutineType(types: !88)
!88 = !{!27}
!89 = !DILocalVariable(name: "t", scope: !86, file: !26, line: 28, type: !90)
!90 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 192, elements: !93)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !92, line: 27, baseType: !22)
!92 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!93 = !{!94}
!94 = !DISubrange(count: 3)
!95 = !DILocation(line: 28, column: 15, scope: !86)
!96 = !DILocation(line: 30, column: 5, scope: !86)
!97 = !DILocalVariable(name: "i", scope: !98, file: !26, line: 32, type: !27)
!98 = distinct !DILexicalBlock(scope: !86, file: !26, line: 32, column: 5)
!99 = !DILocation(line: 0, scope: !98)
!100 = !DILocation(line: 33, column: 25, scope: !101)
!101 = distinct !DILexicalBlock(scope: !98, file: !26, line: 32, column: 5)
!102 = !DILocation(line: 33, column: 9, scope: !101)
!103 = !DILocalVariable(name: "i", scope: !104, file: !26, line: 35, type: !27)
!104 = distinct !DILexicalBlock(scope: !86, file: !26, line: 35, column: 5)
!105 = !DILocation(line: 0, scope: !104)
!106 = !DILocation(line: 36, column: 22, scope: !107)
!107 = distinct !DILexicalBlock(scope: !104, file: !26, line: 35, column: 5)
!108 = !DILocation(line: 36, column: 9, scope: !107)
!109 = !DILocation(line: 38, column: 5, scope: !110)
!110 = distinct !DILexicalBlock(scope: !111, file: !26, line: 38, column: 5)
!111 = distinct !DILexicalBlock(scope: !86, file: !26, line: 38, column: 5)
!112 = !DILocation(line: 38, column: 5, scope: !111)
!113 = !DILocation(line: 40, column: 5, scope: !86)
!114 = distinct !DISubprogram(name: "spinlock_init", scope: !31, file: !31, line: 20, type: !65, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!115 = !DILocalVariable(name: "l", arg: 1, scope: !114, file: !31, line: 20, type: !67)
!116 = !DILocation(line: 0, scope: !114)
!117 = !DILocation(line: 22, column: 21, scope: !114)
!118 = !DILocation(line: 22, column: 5, scope: !114)
!119 = !DILocation(line: 23, column: 1, scope: !114)
!120 = distinct !DISubprogram(name: "await_for_lock", scope: !31, file: !31, line: 25, type: !65, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!121 = !DILocalVariable(name: "l", arg: 1, scope: !120, file: !31, line: 25, type: !67)
!122 = !DILocation(line: 0, scope: !120)
!123 = !DILocation(line: 27, column: 5, scope: !120)
!124 = !DILocation(line: 27, column: 37, scope: !120)
!125 = !DILocation(line: 27, column: 12, scope: !120)
!126 = !DILocation(line: 27, column: 65, scope: !120)
!127 = distinct !{!127, !123, !128, !78}
!128 = !DILocation(line: 28, column: 9, scope: !120)
!129 = !DILocation(line: 29, column: 5, scope: !120)
!130 = distinct !DISubprogram(name: "try_get_lock", scope: !31, file: !31, line: 32, type: !131, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!131 = !DISubroutineType(types: !132)
!132 = !{!27, !67}
!133 = !DILocalVariable(name: "l", arg: 1, scope: !130, file: !31, line: 32, type: !67)
!134 = !DILocation(line: 0, scope: !130)
!135 = !DILocalVariable(name: "val", scope: !130, file: !31, line: 34, type: !27)
!136 = !DILocation(line: 35, column: 56, scope: !130)
!137 = !DILocation(line: 35, column: 12, scope: !130)
!138 = !DILocation(line: 35, column: 5, scope: !130)
