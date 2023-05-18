; ModuleID = 'benchmarks/ticketlock.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/ticketlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ticketlock_s = type { i32, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@lock = dso_local global %struct.ticketlock_s zeroinitializer, align 4, !dbg !25
@shared = dso_local global i32 0, align 4, !dbg !21
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [52 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/ticketlock.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !43 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !47, metadata !DIExpression()), !dbg !48
  %2 = ptrtoint i8* %0 to i64, !dbg !49
  call void @llvm.dbg.value(metadata i64 %2, metadata !50, metadata !DIExpression()), !dbg !48
  call void @ticketlock_acquire(%struct.ticketlock_s* noundef @lock), !dbg !51
  %3 = trunc i64 %2 to i32, !dbg !52
  store i32 %3, i32* @shared, align 4, !dbg !53
  call void @llvm.dbg.value(metadata i32 %3, metadata !54, metadata !DIExpression()), !dbg !48
  %4 = sext i32 %3 to i64, !dbg !55
  %5 = icmp eq i64 %4, %2, !dbg !55
  br i1 %5, label %7, label %6, !dbg !58

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5, !dbg !55
  unreachable, !dbg !55

7:                                                ; preds = %1
  %8 = load i32, i32* @sum, align 4, !dbg !59
  %9 = add nsw i32 %8, 1, !dbg !59
  store i32 %9, i32* @sum, align 4, !dbg !59
  call void @ticketlock_release(%struct.ticketlock_s* noundef @lock), !dbg !60
  ret i8* null, !dbg !61
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @ticketlock_acquire(%struct.ticketlock_s* noundef %0) #0 !dbg !62 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !66, metadata !DIExpression()), !dbg !67
  %2 = call i32 @get_next_ticket(%struct.ticketlock_s* noundef %0), !dbg !68
  call void @llvm.dbg.value(metadata i32 %2, metadata !69, metadata !DIExpression()), !dbg !67
  call void @await_for_ticket(%struct.ticketlock_s* noundef %0, i32 noundef %2), !dbg !70
  ret void, !dbg !71
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @ticketlock_release(%struct.ticketlock_s* noundef %0) #0 !dbg !72 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !73, metadata !DIExpression()), !dbg !74
  %2 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 1, !dbg !75
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !76
  call void @llvm.dbg.value(metadata i32 %3, metadata !77, metadata !DIExpression()), !dbg !74
  %4 = add nsw i32 %3, 1, !dbg !78
  store atomic i32 %4, i32* %2 release, align 4, !dbg !79
  ret void, !dbg !80
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !81 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !84, metadata !DIExpression()), !dbg !91
  call void @ticketlock_init(%struct.ticketlock_s* noundef @lock), !dbg !92
  call void @llvm.dbg.value(metadata i32 0, metadata !93, metadata !DIExpression()), !dbg !95
  call void @llvm.dbg.value(metadata i64 0, metadata !93, metadata !DIExpression()), !dbg !95
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !96
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #6, !dbg !98
  call void @llvm.dbg.value(metadata i64 1, metadata !93, metadata !DIExpression()), !dbg !95
  call void @llvm.dbg.value(metadata i64 1, metadata !93, metadata !DIExpression()), !dbg !95
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !96
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !98
  call void @llvm.dbg.value(metadata i64 2, metadata !93, metadata !DIExpression()), !dbg !95
  call void @llvm.dbg.value(metadata i64 2, metadata !93, metadata !DIExpression()), !dbg !95
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !96
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #6, !dbg !98
  call void @llvm.dbg.value(metadata i64 3, metadata !93, metadata !DIExpression()), !dbg !95
  call void @llvm.dbg.value(metadata i64 3, metadata !93, metadata !DIExpression()), !dbg !95
  call void @llvm.dbg.value(metadata i32 0, metadata !99, metadata !DIExpression()), !dbg !101
  call void @llvm.dbg.value(metadata i64 0, metadata !99, metadata !DIExpression()), !dbg !101
  %8 = load i64, i64* %2, align 8, !dbg !102
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !104
  call void @llvm.dbg.value(metadata i64 1, metadata !99, metadata !DIExpression()), !dbg !101
  call void @llvm.dbg.value(metadata i64 1, metadata !99, metadata !DIExpression()), !dbg !101
  %10 = load i64, i64* %4, align 8, !dbg !102
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !104
  call void @llvm.dbg.value(metadata i64 2, metadata !99, metadata !DIExpression()), !dbg !101
  call void @llvm.dbg.value(metadata i64 2, metadata !99, metadata !DIExpression()), !dbg !101
  %12 = load i64, i64* %6, align 8, !dbg !102
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !104
  call void @llvm.dbg.value(metadata i64 3, metadata !99, metadata !DIExpression()), !dbg !101
  call void @llvm.dbg.value(metadata i64 3, metadata !99, metadata !DIExpression()), !dbg !101
  %14 = load i32, i32* @sum, align 4, !dbg !105
  %15 = icmp eq i32 %14, 3, !dbg !105
  br i1 %15, label %17, label %16, !dbg !108

16:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !105
  unreachable, !dbg !105

17:                                               ; preds = %0
  ret i32 0, !dbg !109
}

; Function Attrs: noinline nounwind uwtable
define internal void @ticketlock_init(%struct.ticketlock_s* noundef %0) #0 !dbg !110 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !111, metadata !DIExpression()), !dbg !112
  %2 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 0, !dbg !113
  store i32 0, i32* %2, align 4, !dbg !114
  %3 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 1, !dbg !115
  store i32 0, i32* %3, align 4, !dbg !116
  ret void, !dbg !117
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @get_next_ticket(%struct.ticketlock_s* noundef %0) #0 !dbg !118 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !121, metadata !DIExpression()), !dbg !122
  %2 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 0, !dbg !123
  %3 = atomicrmw add i32* %2, i32 1 monotonic, align 4, !dbg !124
  ret i32 %3, !dbg !125
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_for_ticket(%struct.ticketlock_s* noundef %0, i32 noundef %1) #0 !dbg !126 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !129, metadata !DIExpression()), !dbg !130
  call void @llvm.dbg.value(metadata i32 %1, metadata !131, metadata !DIExpression()), !dbg !130
  br label %3, !dbg !132

3:                                                ; preds = %3, %2
  %4 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 1, !dbg !133
  %5 = load atomic i32, i32* %4 acquire, align 4, !dbg !134
  %6 = icmp ne i32 %5, %1, !dbg !135
  br i1 %6, label %3, label %7, !dbg !132, !llvm.loop !136

7:                                                ; preds = %3
  ret void, !dbg !139
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
!llvm.module.flags = !{!35, !36, !37, !38, !39, !40, !41}
!llvm.ident = !{!42}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !23, line: 11, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !20, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/ticketlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "7139ea8afbb4838f72cec4e085004e4c")
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
!23 = !DIFile(filename: "benchmarks/locks/ticketlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "7139ea8afbb4838f72cec4e085004e4c")
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !23, line: 10, type: !27, isLocal: false, isDefinition: true)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "ticketlock_t", file: !28, line: 18, baseType: !29)
!28 = !DIFile(filename: "benchmarks/locks/ticketlock.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "fb89b2dbfdfc5b0509f56143d6f0ba0e")
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ticketlock_s", file: !28, line: 14, size: 64, elements: !30)
!30 = !{!31, !34}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !29, file: !28, line: 15, baseType: !32, size: 32)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !33)
!33 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !24)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "owner", scope: !29, file: !28, line: 16, baseType: !32, size: 32, offset: 32)
!35 = !{i32 7, !"Dwarf Version", i32 5}
!36 = !{i32 2, !"Debug Info Version", i32 3}
!37 = !{i32 1, !"wchar_size", i32 4}
!38 = !{i32 7, !"PIC Level", i32 2}
!39 = !{i32 7, !"PIE Level", i32 2}
!40 = !{i32 7, !"uwtable", i32 1}
!41 = !{i32 7, !"frame-pointer", i32 2}
!42 = !{!"Ubuntu clang version 14.0.6"}
!43 = distinct !DISubprogram(name: "thread_n", scope: !23, file: !23, line: 13, type: !44, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !46)
!44 = !DISubroutineType(types: !45)
!45 = !{!19, !19}
!46 = !{}
!47 = !DILocalVariable(name: "arg", arg: 1, scope: !43, file: !23, line: 13, type: !19)
!48 = !DILocation(line: 0, scope: !43)
!49 = !DILocation(line: 15, column: 23, scope: !43)
!50 = !DILocalVariable(name: "index", scope: !43, file: !23, line: 15, type: !16)
!51 = !DILocation(line: 17, column: 5, scope: !43)
!52 = !DILocation(line: 18, column: 14, scope: !43)
!53 = !DILocation(line: 18, column: 12, scope: !43)
!54 = !DILocalVariable(name: "r", scope: !43, file: !23, line: 19, type: !24)
!55 = !DILocation(line: 20, column: 5, scope: !56)
!56 = distinct !DILexicalBlock(scope: !57, file: !23, line: 20, column: 5)
!57 = distinct !DILexicalBlock(scope: !43, file: !23, line: 20, column: 5)
!58 = !DILocation(line: 20, column: 5, scope: !57)
!59 = !DILocation(line: 21, column: 8, scope: !43)
!60 = !DILocation(line: 22, column: 5, scope: !43)
!61 = !DILocation(line: 23, column: 5, scope: !43)
!62 = distinct !DISubprogram(name: "ticketlock_acquire", scope: !28, file: !28, line: 37, type: !63, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!63 = !DISubroutineType(types: !64)
!64 = !{null, !65}
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!66 = !DILocalVariable(name: "l", arg: 1, scope: !62, file: !28, line: 37, type: !65)
!67 = !DILocation(line: 0, scope: !62)
!68 = !DILocation(line: 39, column: 18, scope: !62)
!69 = !DILocalVariable(name: "ticket", scope: !62, file: !28, line: 39, type: !24)
!70 = !DILocation(line: 40, column: 5, scope: !62)
!71 = !DILocation(line: 41, column: 1, scope: !62)
!72 = distinct !DISubprogram(name: "ticketlock_release", scope: !28, file: !28, line: 53, type: !63, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!73 = !DILocalVariable(name: "l", arg: 1, scope: !72, file: !28, line: 53, type: !65)
!74 = !DILocation(line: 0, scope: !72)
!75 = !DILocation(line: 55, column: 42, scope: !72)
!76 = !DILocation(line: 55, column: 17, scope: !72)
!77 = !DILocalVariable(name: "owner", scope: !72, file: !28, line: 55, type: !24)
!78 = !DILocation(line: 56, column: 44, scope: !72)
!79 = !DILocation(line: 56, column: 5, scope: !72)
!80 = !DILocation(line: 57, column: 1, scope: !72)
!81 = distinct !DISubprogram(name: "main", scope: !23, file: !23, line: 26, type: !82, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !46)
!82 = !DISubroutineType(types: !83)
!83 = !{!24}
!84 = !DILocalVariable(name: "t", scope: !81, file: !23, line: 28, type: !85)
!85 = !DICompositeType(tag: DW_TAG_array_type, baseType: !86, size: 192, elements: !89)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !87, line: 27, baseType: !88)
!87 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!88 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!89 = !{!90}
!90 = !DISubrange(count: 3)
!91 = !DILocation(line: 28, column: 15, scope: !81)
!92 = !DILocation(line: 30, column: 5, scope: !81)
!93 = !DILocalVariable(name: "i", scope: !94, file: !23, line: 32, type: !24)
!94 = distinct !DILexicalBlock(scope: !81, file: !23, line: 32, column: 5)
!95 = !DILocation(line: 0, scope: !94)
!96 = !DILocation(line: 33, column: 25, scope: !97)
!97 = distinct !DILexicalBlock(scope: !94, file: !23, line: 32, column: 5)
!98 = !DILocation(line: 33, column: 9, scope: !97)
!99 = !DILocalVariable(name: "i", scope: !100, file: !23, line: 35, type: !24)
!100 = distinct !DILexicalBlock(scope: !81, file: !23, line: 35, column: 5)
!101 = !DILocation(line: 0, scope: !100)
!102 = !DILocation(line: 36, column: 22, scope: !103)
!103 = distinct !DILexicalBlock(scope: !100, file: !23, line: 35, column: 5)
!104 = !DILocation(line: 36, column: 9, scope: !103)
!105 = !DILocation(line: 38, column: 5, scope: !106)
!106 = distinct !DILexicalBlock(scope: !107, file: !23, line: 38, column: 5)
!107 = distinct !DILexicalBlock(scope: !81, file: !23, line: 38, column: 5)
!108 = !DILocation(line: 38, column: 5, scope: !107)
!109 = !DILocation(line: 40, column: 5, scope: !81)
!110 = distinct !DISubprogram(name: "ticketlock_init", scope: !28, file: !28, line: 20, type: !63, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!111 = !DILocalVariable(name: "l", arg: 1, scope: !110, file: !28, line: 20, type: !65)
!112 = !DILocation(line: 0, scope: !110)
!113 = !DILocation(line: 22, column: 21, scope: !110)
!114 = !DILocation(line: 22, column: 5, scope: !110)
!115 = !DILocation(line: 23, column: 21, scope: !110)
!116 = !DILocation(line: 23, column: 5, scope: !110)
!117 = !DILocation(line: 24, column: 1, scope: !110)
!118 = distinct !DISubprogram(name: "get_next_ticket", scope: !28, file: !28, line: 26, type: !119, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!119 = !DISubroutineType(types: !120)
!120 = !{!24, !65}
!121 = !DILocalVariable(name: "l", arg: 1, scope: !118, file: !28, line: 26, type: !65)
!122 = !DILocation(line: 0, scope: !118)
!123 = !DILocation(line: 28, column: 42, scope: !118)
!124 = !DILocation(line: 28, column: 12, scope: !118)
!125 = !DILocation(line: 28, column: 5, scope: !118)
!126 = distinct !DISubprogram(name: "await_for_ticket", scope: !28, file: !28, line: 31, type: !127, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !46)
!127 = !DISubroutineType(types: !128)
!128 = !{null, !65, !24}
!129 = !DILocalVariable(name: "l", arg: 1, scope: !126, file: !28, line: 31, type: !65)
!130 = !DILocation(line: 0, scope: !126)
!131 = !DILocalVariable(name: "ticket", arg: 2, scope: !126, file: !28, line: 31, type: !24)
!132 = !DILocation(line: 33, column: 5, scope: !126)
!133 = !DILocation(line: 33, column: 37, scope: !126)
!134 = !DILocation(line: 33, column: 12, scope: !126)
!135 = !DILocation(line: 33, column: 53, scope: !126)
!136 = distinct !{!136, !132, !137, !138}
!137 = !DILocation(line: 34, column: 9, scope: !126)
!138 = !{!"llvm.loop.mustprogress"}
!139 = !DILocation(line: 35, column: 1, scope: !126)
