; ModuleID = '/home/ponce/git/Dat3M/output/ttas.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/ttas.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ttaslock_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@lock = dso_local global %struct.ttaslock_s zeroinitializer, align 4, !dbg !28
@shared = dso_local global i32 0, align 4, !dbg !24
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [46 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/ttas.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !45 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !49, metadata !DIExpression()), !dbg !50
  %2 = ptrtoint i8* %0 to i64, !dbg !51
  call void @llvm.dbg.value(metadata i64 %2, metadata !52, metadata !DIExpression()), !dbg !50
  call void @ttaslock_acquire(%struct.ttaslock_s* noundef @lock), !dbg !53
  %3 = trunc i64 %2 to i32, !dbg !54
  store i32 %3, i32* @shared, align 4, !dbg !55
  call void @llvm.dbg.value(metadata i32 %3, metadata !56, metadata !DIExpression()), !dbg !50
  %4 = sext i32 %3 to i64, !dbg !57
  %5 = icmp eq i64 %4, %2, !dbg !57
  br i1 %5, label %7, label %6, !dbg !60

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([46 x i8], [46 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5, !dbg !57
  unreachable, !dbg !57

7:                                                ; preds = %1
  %8 = load i32, i32* @sum, align 4, !dbg !61
  %9 = add nsw i32 %8, 1, !dbg !61
  store i32 %9, i32* @sum, align 4, !dbg !61
  call void @ttaslock_release(%struct.ttaslock_s* noundef @lock), !dbg !62
  ret i8* null, !dbg !63
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @ttaslock_acquire(%struct.ttaslock_s* noundef %0) #0 !dbg !64 {
  call void @llvm.dbg.value(metadata %struct.ttaslock_s* %0, metadata !68, metadata !DIExpression()), !dbg !69
  br label %2, !dbg !70

2:                                                ; preds = %2, %1
  call void @await_for_lock(%struct.ttaslock_s* noundef %0), !dbg !71
  %3 = call i32 @try_acquire(%struct.ttaslock_s* noundef %0), !dbg !73
  %4 = icmp ne i32 %3, 0, !dbg !73
  br i1 %4, label %2, label %5, !dbg !75, !llvm.loop !76

5:                                                ; preds = %2
  ret void, !dbg !78
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @ttaslock_release(%struct.ttaslock_s* noundef %0) #0 !dbg !79 {
  call void @llvm.dbg.value(metadata %struct.ttaslock_s* %0, metadata !80, metadata !DIExpression()), !dbg !81
  %2 = getelementptr inbounds %struct.ttaslock_s, %struct.ttaslock_s* %0, i32 0, i32 0, !dbg !82
  store atomic i32 0, i32* %2 release, align 4, !dbg !83
  ret void, !dbg !84
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !85 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !88, metadata !DIExpression()), !dbg !94
  call void @ttaslock_init(%struct.ttaslock_s* noundef @lock), !dbg !95
  call void @llvm.dbg.value(metadata i32 0, metadata !96, metadata !DIExpression()), !dbg !98
  call void @llvm.dbg.value(metadata i64 0, metadata !96, metadata !DIExpression()), !dbg !98
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !99
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #6, !dbg !101
  call void @llvm.dbg.value(metadata i64 1, metadata !96, metadata !DIExpression()), !dbg !98
  call void @llvm.dbg.value(metadata i64 1, metadata !96, metadata !DIExpression()), !dbg !98
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !99
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !101
  call void @llvm.dbg.value(metadata i64 2, metadata !96, metadata !DIExpression()), !dbg !98
  call void @llvm.dbg.value(metadata i64 2, metadata !96, metadata !DIExpression()), !dbg !98
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !99
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !101
  call void @llvm.dbg.value(metadata i64 3, metadata !96, metadata !DIExpression()), !dbg !98
  call void @llvm.dbg.value(metadata i64 3, metadata !96, metadata !DIExpression()), !dbg !98
  call void @llvm.dbg.value(metadata i32 0, metadata !102, metadata !DIExpression()), !dbg !104
  call void @llvm.dbg.value(metadata i64 0, metadata !102, metadata !DIExpression()), !dbg !104
  %8 = load i64, i64* %2, align 8, !dbg !105
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !107
  call void @llvm.dbg.value(metadata i64 1, metadata !102, metadata !DIExpression()), !dbg !104
  call void @llvm.dbg.value(metadata i64 1, metadata !102, metadata !DIExpression()), !dbg !104
  %10 = load i64, i64* %4, align 8, !dbg !105
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !107
  call void @llvm.dbg.value(metadata i64 2, metadata !102, metadata !DIExpression()), !dbg !104
  call void @llvm.dbg.value(metadata i64 2, metadata !102, metadata !DIExpression()), !dbg !104
  %12 = load i64, i64* %6, align 8, !dbg !105
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !107
  call void @llvm.dbg.value(metadata i64 3, metadata !102, metadata !DIExpression()), !dbg !104
  call void @llvm.dbg.value(metadata i64 3, metadata !102, metadata !DIExpression()), !dbg !104
  %14 = load i32, i32* @sum, align 4, !dbg !108
  %15 = icmp eq i32 %14, 3, !dbg !108
  br i1 %15, label %17, label %16, !dbg !111

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([46 x i8], [46 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !108
  unreachable, !dbg !108

17:                                               ; preds = %0
  ret i32 0, !dbg !112
}

; Function Attrs: noinline nounwind uwtable
define internal void @ttaslock_init(%struct.ttaslock_s* noundef %0) #0 !dbg !113 {
  call void @llvm.dbg.value(metadata %struct.ttaslock_s* %0, metadata !114, metadata !DIExpression()), !dbg !115
  %2 = getelementptr inbounds %struct.ttaslock_s, %struct.ttaslock_s* %0, i32 0, i32 0, !dbg !116
  store i32 0, i32* %2, align 4, !dbg !117
  ret void, !dbg !118
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @await_for_lock(%struct.ttaslock_s* noundef %0) #0 !dbg !119 {
  call void @llvm.dbg.value(metadata %struct.ttaslock_s* %0, metadata !120, metadata !DIExpression()), !dbg !121
  br label %2, !dbg !122

2:                                                ; preds = %2, %1
  %3 = getelementptr inbounds %struct.ttaslock_s, %struct.ttaslock_s* %0, i32 0, i32 0, !dbg !123
  %4 = load atomic i32, i32* %3 monotonic, align 4, !dbg !124
  %5 = icmp ne i32 %4, 0, !dbg !125
  br i1 %5, label %2, label %6, !dbg !122, !llvm.loop !126

6:                                                ; preds = %2
  ret void, !dbg !129
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @try_acquire(%struct.ttaslock_s* noundef %0) #0 !dbg !130 {
  call void @llvm.dbg.value(metadata %struct.ttaslock_s* %0, metadata !133, metadata !DIExpression()), !dbg !134
  %2 = getelementptr inbounds %struct.ttaslock_s, %struct.ttaslock_s* %0, i32 0, i32 0, !dbg !135
  %3 = atomicrmw xchg i32* %2, i32 1 acquire, align 4, !dbg !136
  ret i32 %3, !dbg !137
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
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/ttas.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "96a1559e1e638f4c9f28fd652ebca97c")
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
!26 = !DIFile(filename: "benchmarks/locks/ttas.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "96a1559e1e638f4c9f28fd652ebca97c")
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !26, line: 10, type: !30, isLocal: false, isDefinition: true)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "ttaslock_t", file: !31, line: 17, baseType: !32)
!31 = !DIFile(filename: "benchmarks/locks/ttas.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "7212eed5a37c0df69d9d1fd3a6cfde27")
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ttaslock_s", file: !31, line: 14, size: 32, elements: !33)
!33 = !{!34}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !32, file: !31, line: 15, baseType: !35, size: 32)
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
!64 = distinct !DISubprogram(name: "ttaslock_acquire", scope: !31, file: !31, line: 36, type: !65, scopeLine: 37, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!65 = !DISubroutineType(types: !66)
!66 = !{null, !67}
!67 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!68 = !DILocalVariable(name: "l", arg: 1, scope: !64, file: !31, line: 36, type: !67)
!69 = !DILocation(line: 0, scope: !64)
!70 = !DILocation(line: 38, column: 5, scope: !64)
!71 = !DILocation(line: 39, column: 9, scope: !72)
!72 = distinct !DILexicalBlock(scope: !64, file: !31, line: 38, column: 15)
!73 = !DILocation(line: 40, column: 14, scope: !74)
!74 = distinct !DILexicalBlock(scope: !72, file: !31, line: 40, column: 13)
!75 = !DILocation(line: 40, column: 13, scope: !72)
!76 = distinct !{!76, !70, !77}
!77 = !DILocation(line: 42, column: 5, scope: !64)
!78 = !DILocation(line: 41, column: 13, scope: !74)
!79 = distinct !DISubprogram(name: "ttaslock_release", scope: !31, file: !31, line: 45, type: !65, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!80 = !DILocalVariable(name: "l", arg: 1, scope: !79, file: !31, line: 45, type: !67)
!81 = !DILocation(line: 0, scope: !79)
!82 = !DILocation(line: 47, column: 31, scope: !79)
!83 = !DILocation(line: 47, column: 5, scope: !79)
!84 = !DILocation(line: 48, column: 1, scope: !79)
!85 = distinct !DISubprogram(name: "main", scope: !26, file: !26, line: 26, type: !86, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !48)
!86 = !DISubroutineType(types: !87)
!87 = !{!27}
!88 = !DILocalVariable(name: "t", scope: !85, file: !26, line: 28, type: !89)
!89 = !DICompositeType(tag: DW_TAG_array_type, baseType: !90, size: 192, elements: !92)
!90 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !91, line: 27, baseType: !22)
!91 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!92 = !{!93}
!93 = !DISubrange(count: 3)
!94 = !DILocation(line: 28, column: 15, scope: !85)
!95 = !DILocation(line: 30, column: 5, scope: !85)
!96 = !DILocalVariable(name: "i", scope: !97, file: !26, line: 32, type: !27)
!97 = distinct !DILexicalBlock(scope: !85, file: !26, line: 32, column: 5)
!98 = !DILocation(line: 0, scope: !97)
!99 = !DILocation(line: 33, column: 25, scope: !100)
!100 = distinct !DILexicalBlock(scope: !97, file: !26, line: 32, column: 5)
!101 = !DILocation(line: 33, column: 9, scope: !100)
!102 = !DILocalVariable(name: "i", scope: !103, file: !26, line: 35, type: !27)
!103 = distinct !DILexicalBlock(scope: !85, file: !26, line: 35, column: 5)
!104 = !DILocation(line: 0, scope: !103)
!105 = !DILocation(line: 36, column: 22, scope: !106)
!106 = distinct !DILexicalBlock(scope: !103, file: !26, line: 35, column: 5)
!107 = !DILocation(line: 36, column: 9, scope: !106)
!108 = !DILocation(line: 38, column: 5, scope: !109)
!109 = distinct !DILexicalBlock(scope: !110, file: !26, line: 38, column: 5)
!110 = distinct !DILexicalBlock(scope: !85, file: !26, line: 38, column: 5)
!111 = !DILocation(line: 38, column: 5, scope: !110)
!112 = !DILocation(line: 40, column: 5, scope: !85)
!113 = distinct !DISubprogram(name: "ttaslock_init", scope: !31, file: !31, line: 19, type: !65, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!114 = !DILocalVariable(name: "l", arg: 1, scope: !113, file: !31, line: 19, type: !67)
!115 = !DILocation(line: 0, scope: !113)
!116 = !DILocation(line: 21, column: 21, scope: !113)
!117 = !DILocation(line: 21, column: 5, scope: !113)
!118 = !DILocation(line: 22, column: 1, scope: !113)
!119 = distinct !DISubprogram(name: "await_for_lock", scope: !31, file: !31, line: 24, type: !65, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!120 = !DILocalVariable(name: "l", arg: 1, scope: !119, file: !31, line: 24, type: !67)
!121 = !DILocation(line: 0, scope: !119)
!122 = !DILocation(line: 26, column: 5, scope: !119)
!123 = !DILocation(line: 26, column: 37, scope: !119)
!124 = !DILocation(line: 26, column: 12, scope: !119)
!125 = !DILocation(line: 26, column: 66, scope: !119)
!126 = distinct !{!126, !122, !127, !128}
!127 = !DILocation(line: 27, column: 9, scope: !119)
!128 = !{!"llvm.loop.mustprogress"}
!129 = !DILocation(line: 28, column: 5, scope: !119)
!130 = distinct !DISubprogram(name: "try_acquire", scope: !31, file: !31, line: 31, type: !131, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!131 = !DISubroutineType(types: !132)
!132 = !{!27, !67}
!133 = !DILocalVariable(name: "l", arg: 1, scope: !130, file: !31, line: 31, type: !67)
!134 = !DILocation(line: 0, scope: !130)
!135 = !DILocation(line: 33, column: 41, scope: !130)
!136 = !DILocation(line: 33, column: 12, scope: !130)
!137 = !DILocation(line: 33, column: 5, scope: !130)
