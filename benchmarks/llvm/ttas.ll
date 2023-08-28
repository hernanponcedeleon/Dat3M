; ModuleID = 'benchmarks/ttas.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/ttas.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ttaslock_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@lock = dso_local global %struct.ttaslock_s zeroinitializer, align 4, !dbg !25
@shared = dso_local global i32 0, align 4, !dbg !21
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [46 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/ttas.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !42 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !46, metadata !DIExpression()), !dbg !47
  %2 = ptrtoint i8* %0 to i64, !dbg !48
  call void @llvm.dbg.value(metadata i64 %2, metadata !49, metadata !DIExpression()), !dbg !47
  call void @ttaslock_acquire(%struct.ttaslock_s* noundef @lock), !dbg !50
  %3 = trunc i64 %2 to i32, !dbg !51
  store i32 %3, i32* @shared, align 4, !dbg !52
  call void @llvm.dbg.value(metadata i32 %3, metadata !53, metadata !DIExpression()), !dbg !47
  %4 = sext i32 %3 to i64, !dbg !54
  %5 = icmp eq i64 %4, %2, !dbg !54
  br i1 %5, label %7, label %6, !dbg !57

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([46 x i8], [46 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5, !dbg !54
  unreachable, !dbg !54

7:                                                ; preds = %1
  %8 = load i32, i32* @sum, align 4, !dbg !58
  %9 = add nsw i32 %8, 1, !dbg !58
  store i32 %9, i32* @sum, align 4, !dbg !58
  call void @ttaslock_release(%struct.ttaslock_s* noundef @lock), !dbg !59
  ret i8* null, !dbg !60
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @ttaslock_acquire(%struct.ttaslock_s* noundef %0) #0 !dbg !61 {
  call void @llvm.dbg.value(metadata %struct.ttaslock_s* %0, metadata !65, metadata !DIExpression()), !dbg !66
  br label %2, !dbg !67

2:                                                ; preds = %2, %1
  call void @await_for_lock(%struct.ttaslock_s* noundef %0), !dbg !68
  %3 = call i32 @try_acquire(%struct.ttaslock_s* noundef %0), !dbg !70
  %4 = icmp ne i32 %3, 0, !dbg !70
  br i1 %4, label %2, label %5, !dbg !72, !llvm.loop !73

5:                                                ; preds = %2
  ret void, !dbg !75
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @ttaslock_release(%struct.ttaslock_s* noundef %0) #0 !dbg !76 {
  call void @llvm.dbg.value(metadata %struct.ttaslock_s* %0, metadata !77, metadata !DIExpression()), !dbg !78
  %2 = getelementptr inbounds %struct.ttaslock_s, %struct.ttaslock_s* %0, i32 0, i32 0, !dbg !79
  store atomic i32 0, i32* %2 release, align 4, !dbg !80
  ret void, !dbg !81
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !82 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !85, metadata !DIExpression()), !dbg !92
  call void @ttaslock_init(%struct.ttaslock_s* noundef @lock), !dbg !93
  call void @llvm.dbg.value(metadata i32 0, metadata !94, metadata !DIExpression()), !dbg !96
  call void @llvm.dbg.value(metadata i64 0, metadata !94, metadata !DIExpression()), !dbg !96
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !97
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #6, !dbg !99
  call void @llvm.dbg.value(metadata i64 1, metadata !94, metadata !DIExpression()), !dbg !96
  call void @llvm.dbg.value(metadata i64 1, metadata !94, metadata !DIExpression()), !dbg !96
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !97
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !99
  call void @llvm.dbg.value(metadata i64 2, metadata !94, metadata !DIExpression()), !dbg !96
  call void @llvm.dbg.value(metadata i64 2, metadata !94, metadata !DIExpression()), !dbg !96
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !97
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !99
  call void @llvm.dbg.value(metadata i64 3, metadata !94, metadata !DIExpression()), !dbg !96
  call void @llvm.dbg.value(metadata i64 3, metadata !94, metadata !DIExpression()), !dbg !96
  call void @llvm.dbg.value(metadata i32 0, metadata !100, metadata !DIExpression()), !dbg !102
  call void @llvm.dbg.value(metadata i64 0, metadata !100, metadata !DIExpression()), !dbg !102
  %8 = load i64, i64* %2, align 8, !dbg !103
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !105
  call void @llvm.dbg.value(metadata i64 1, metadata !100, metadata !DIExpression()), !dbg !102
  call void @llvm.dbg.value(metadata i64 1, metadata !100, metadata !DIExpression()), !dbg !102
  %10 = load i64, i64* %4, align 8, !dbg !103
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !105
  call void @llvm.dbg.value(metadata i64 2, metadata !100, metadata !DIExpression()), !dbg !102
  call void @llvm.dbg.value(metadata i64 2, metadata !100, metadata !DIExpression()), !dbg !102
  %12 = load i64, i64* %6, align 8, !dbg !103
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !105
  call void @llvm.dbg.value(metadata i64 3, metadata !100, metadata !DIExpression()), !dbg !102
  call void @llvm.dbg.value(metadata i64 3, metadata !100, metadata !DIExpression()), !dbg !102
  %14 = load i32, i32* @sum, align 4, !dbg !106
  %15 = icmp eq i32 %14, 3, !dbg !106
  br i1 %15, label %17, label %16, !dbg !109

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([46 x i8], [46 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !106
  unreachable, !dbg !106

17:                                               ; preds = %0
  ret i32 0, !dbg !110
}

; Function Attrs: noinline nounwind uwtable
define internal void @ttaslock_init(%struct.ttaslock_s* noundef %0) #0 !dbg !111 {
  call void @llvm.dbg.value(metadata %struct.ttaslock_s* %0, metadata !112, metadata !DIExpression()), !dbg !113
  %2 = getelementptr inbounds %struct.ttaslock_s, %struct.ttaslock_s* %0, i32 0, i32 0, !dbg !114
  store i32 0, i32* %2, align 4, !dbg !115
  ret void, !dbg !116
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @await_for_lock(%struct.ttaslock_s* noundef %0) #0 !dbg !117 {
  call void @llvm.dbg.value(metadata %struct.ttaslock_s* %0, metadata !118, metadata !DIExpression()), !dbg !119
  br label %2, !dbg !120

2:                                                ; preds = %2, %1
  %3 = getelementptr inbounds %struct.ttaslock_s, %struct.ttaslock_s* %0, i32 0, i32 0, !dbg !121
  %4 = load atomic i32, i32* %3 monotonic, align 4, !dbg !122
  %5 = icmp ne i32 %4, 0, !dbg !123
  br i1 %5, label %2, label %6, !dbg !120, !llvm.loop !124

6:                                                ; preds = %2
  ret void, !dbg !127
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @try_acquire(%struct.ttaslock_s* noundef %0) #0 !dbg !128 {
  call void @llvm.dbg.value(metadata %struct.ttaslock_s* %0, metadata !131, metadata !DIExpression()), !dbg !132
  %2 = getelementptr inbounds %struct.ttaslock_s, %struct.ttaslock_s* %0, i32 0, i32 0, !dbg !133
  %3 = atomicrmw xchg i32* %2, i32 1 acquire, align 4, !dbg !134
  ret i32 %3, !dbg !135
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
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/ttas.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "7587f4158040adbe16951d13277eb9d8")
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
!23 = !DIFile(filename: "benchmarks/locks/ttas.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "7587f4158040adbe16951d13277eb9d8")
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !23, line: 10, type: !27, isLocal: false, isDefinition: true)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "ttaslock_t", file: !28, line: 17, baseType: !29)
!28 = !DIFile(filename: "benchmarks/locks/ttas.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "7212eed5a37c0df69d9d1fd3a6cfde27")
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ttaslock_s", file: !28, line: 14, size: 32, elements: !30)
!30 = !{!31}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !29, file: !28, line: 15, baseType: !32, size: 32)
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
!61 = distinct !DISubprogram(name: "ttaslock_acquire", scope: !28, file: !28, line: 36, type: !62, scopeLine: 37, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!62 = !DISubroutineType(types: !63)
!63 = !{null, !64}
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!65 = !DILocalVariable(name: "l", arg: 1, scope: !61, file: !28, line: 36, type: !64)
!66 = !DILocation(line: 0, scope: !61)
!67 = !DILocation(line: 38, column: 5, scope: !61)
!68 = !DILocation(line: 39, column: 9, scope: !69)
!69 = distinct !DILexicalBlock(scope: !61, file: !28, line: 38, column: 15)
!70 = !DILocation(line: 40, column: 14, scope: !71)
!71 = distinct !DILexicalBlock(scope: !69, file: !28, line: 40, column: 13)
!72 = !DILocation(line: 40, column: 13, scope: !69)
!73 = distinct !{!73, !67, !74}
!74 = !DILocation(line: 42, column: 5, scope: !61)
!75 = !DILocation(line: 41, column: 13, scope: !71)
!76 = distinct !DISubprogram(name: "ttaslock_release", scope: !28, file: !28, line: 45, type: !62, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!77 = !DILocalVariable(name: "l", arg: 1, scope: !76, file: !28, line: 45, type: !64)
!78 = !DILocation(line: 0, scope: !76)
!79 = !DILocation(line: 47, column: 31, scope: !76)
!80 = !DILocation(line: 47, column: 5, scope: !76)
!81 = !DILocation(line: 48, column: 1, scope: !76)
!82 = distinct !DISubprogram(name: "main", scope: !23, file: !23, line: 26, type: !83, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!83 = !DISubroutineType(types: !84)
!84 = !{!24}
!85 = !DILocalVariable(name: "t", scope: !82, file: !23, line: 28, type: !86)
!86 = !DICompositeType(tag: DW_TAG_array_type, baseType: !87, size: 192, elements: !90)
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !88, line: 27, baseType: !89)
!88 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!89 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!90 = !{!91}
!91 = !DISubrange(count: 3)
!92 = !DILocation(line: 28, column: 15, scope: !82)
!93 = !DILocation(line: 30, column: 5, scope: !82)
!94 = !DILocalVariable(name: "i", scope: !95, file: !23, line: 32, type: !24)
!95 = distinct !DILexicalBlock(scope: !82, file: !23, line: 32, column: 5)
!96 = !DILocation(line: 0, scope: !95)
!97 = !DILocation(line: 33, column: 25, scope: !98)
!98 = distinct !DILexicalBlock(scope: !95, file: !23, line: 32, column: 5)
!99 = !DILocation(line: 33, column: 9, scope: !98)
!100 = !DILocalVariable(name: "i", scope: !101, file: !23, line: 35, type: !24)
!101 = distinct !DILexicalBlock(scope: !82, file: !23, line: 35, column: 5)
!102 = !DILocation(line: 0, scope: !101)
!103 = !DILocation(line: 36, column: 22, scope: !104)
!104 = distinct !DILexicalBlock(scope: !101, file: !23, line: 35, column: 5)
!105 = !DILocation(line: 36, column: 9, scope: !104)
!106 = !DILocation(line: 38, column: 5, scope: !107)
!107 = distinct !DILexicalBlock(scope: !108, file: !23, line: 38, column: 5)
!108 = distinct !DILexicalBlock(scope: !82, file: !23, line: 38, column: 5)
!109 = !DILocation(line: 38, column: 5, scope: !108)
!110 = !DILocation(line: 40, column: 5, scope: !82)
!111 = distinct !DISubprogram(name: "ttaslock_init", scope: !28, file: !28, line: 19, type: !62, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!112 = !DILocalVariable(name: "l", arg: 1, scope: !111, file: !28, line: 19, type: !64)
!113 = !DILocation(line: 0, scope: !111)
!114 = !DILocation(line: 21, column: 21, scope: !111)
!115 = !DILocation(line: 21, column: 5, scope: !111)
!116 = !DILocation(line: 22, column: 1, scope: !111)
!117 = distinct !DISubprogram(name: "await_for_lock", scope: !28, file: !28, line: 24, type: !62, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!118 = !DILocalVariable(name: "l", arg: 1, scope: !117, file: !28, line: 24, type: !64)
!119 = !DILocation(line: 0, scope: !117)
!120 = !DILocation(line: 26, column: 5, scope: !117)
!121 = !DILocation(line: 26, column: 37, scope: !117)
!122 = !DILocation(line: 26, column: 12, scope: !117)
!123 = !DILocation(line: 26, column: 66, scope: !117)
!124 = distinct !{!124, !120, !125, !126}
!125 = !DILocation(line: 27, column: 9, scope: !117)
!126 = !{!"llvm.loop.mustprogress"}
!127 = !DILocation(line: 28, column: 5, scope: !117)
!128 = distinct !DISubprogram(name: "try_acquire", scope: !28, file: !28, line: 31, type: !129, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!129 = !DISubroutineType(types: !130)
!130 = !{!24, !64}
!131 = !DILocalVariable(name: "l", arg: 1, scope: !128, file: !28, line: 31, type: !64)
!132 = !DILocation(line: 0, scope: !128)
!133 = !DILocation(line: 33, column: 41, scope: !128)
!134 = !DILocation(line: 33, column: 12, scope: !128)
!135 = !DILocation(line: 33, column: 5, scope: !128)
