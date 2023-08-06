; ModuleID = '/home/ponce/git/Dat3M/output/ticketlock.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/ticketlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ticketlock_s = type { i32, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@lock = dso_local global %struct.ticketlock_s zeroinitializer, align 4, !dbg !28
@shared = dso_local global i32 0, align 4, !dbg !24
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [52 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/ticketlock.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !46 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !50, metadata !DIExpression()), !dbg !51
  %2 = ptrtoint i8* %0 to i64, !dbg !52
  call void @llvm.dbg.value(metadata i64 %2, metadata !53, metadata !DIExpression()), !dbg !51
  call void @ticketlock_acquire(%struct.ticketlock_s* noundef @lock), !dbg !54
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
  call void @ticketlock_release(%struct.ticketlock_s* noundef @lock), !dbg !63
  ret i8* null, !dbg !64
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @ticketlock_acquire(%struct.ticketlock_s* noundef %0) #0 !dbg !65 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !69, metadata !DIExpression()), !dbg !70
  %2 = call i32 @get_next_ticket(%struct.ticketlock_s* noundef %0), !dbg !71
  call void @llvm.dbg.value(metadata i32 %2, metadata !72, metadata !DIExpression()), !dbg !70
  call void @await_for_ticket(%struct.ticketlock_s* noundef %0, i32 noundef %2), !dbg !73
  ret void, !dbg !74
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @ticketlock_release(%struct.ticketlock_s* noundef %0) #0 !dbg !75 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !76, metadata !DIExpression()), !dbg !77
  %2 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 1, !dbg !78
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !79
  call void @llvm.dbg.value(metadata i32 %3, metadata !80, metadata !DIExpression()), !dbg !77
  %4 = add nsw i32 %3, 1, !dbg !81
  store atomic i32 %4, i32* %2 release, align 4, !dbg !82
  ret void, !dbg !83
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !84 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !87, metadata !DIExpression()), !dbg !93
  call void @ticketlock_init(%struct.ticketlock_s* noundef @lock), !dbg !94
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !107
  unreachable, !dbg !107

17:                                               ; preds = %0
  ret i32 0, !dbg !111
}

; Function Attrs: noinline nounwind uwtable
define internal void @ticketlock_init(%struct.ticketlock_s* noundef %0) #0 !dbg !112 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !113, metadata !DIExpression()), !dbg !114
  %2 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 0, !dbg !115
  store i32 0, i32* %2, align 4, !dbg !116
  %3 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 1, !dbg !117
  store i32 0, i32* %3, align 4, !dbg !118
  ret void, !dbg !119
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @get_next_ticket(%struct.ticketlock_s* noundef %0) #0 !dbg !120 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !123, metadata !DIExpression()), !dbg !124
  %2 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 0, !dbg !125
  %3 = atomicrmw add i32* %2, i32 1 monotonic, align 4, !dbg !126
  ret i32 %3, !dbg !127
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_for_ticket(%struct.ticketlock_s* noundef %0, i32 noundef %1) #0 !dbg !128 {
  call void @llvm.dbg.value(metadata %struct.ticketlock_s* %0, metadata !131, metadata !DIExpression()), !dbg !132
  call void @llvm.dbg.value(metadata i32 %1, metadata !133, metadata !DIExpression()), !dbg !132
  br label %3, !dbg !134

3:                                                ; preds = %3, %2
  %4 = getelementptr inbounds %struct.ticketlock_s, %struct.ticketlock_s* %0, i32 0, i32 1, !dbg !135
  %5 = load atomic i32, i32* %4 monotonic, align 4, !dbg !136
  %6 = icmp ne i32 %5, %1, !dbg !137
  br i1 %6, label %3, label %7, !dbg !134, !llvm.loop !138

7:                                                ; preds = %3
  ret void, !dbg !141
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
!1 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !26, line: 11, type: !27, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !23, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/ticketlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "ca620cfb71bea54ba929bf85fe9c1fc7")
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
!26 = !DIFile(filename: "benchmarks/locks/ticketlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "ca620cfb71bea54ba929bf85fe9c1fc7")
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !26, line: 10, type: !30, isLocal: false, isDefinition: true)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "ticketlock_t", file: !31, line: 18, baseType: !32)
!31 = !DIFile(filename: "benchmarks/locks/ticketlock.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "fb89b2dbfdfc5b0509f56143d6f0ba0e")
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ticketlock_s", file: !31, line: 14, size: 64, elements: !33)
!33 = !{!34, !37}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !32, file: !31, line: 15, baseType: !35, size: 32)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !36)
!36 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !27)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "owner", scope: !32, file: !31, line: 16, baseType: !35, size: 32, offset: 32)
!38 = !{i32 7, !"Dwarf Version", i32 5}
!39 = !{i32 2, !"Debug Info Version", i32 3}
!40 = !{i32 1, !"wchar_size", i32 4}
!41 = !{i32 7, !"PIC Level", i32 2}
!42 = !{i32 7, !"PIE Level", i32 2}
!43 = !{i32 7, !"uwtable", i32 1}
!44 = !{i32 7, !"frame-pointer", i32 2}
!45 = !{!"Ubuntu clang version 14.0.6"}
!46 = distinct !DISubprogram(name: "thread_n", scope: !26, file: !26, line: 13, type: !47, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!47 = !DISubroutineType(types: !48)
!48 = !{!19, !19}
!49 = !{}
!50 = !DILocalVariable(name: "arg", arg: 1, scope: !46, file: !26, line: 13, type: !19)
!51 = !DILocation(line: 0, scope: !46)
!52 = !DILocation(line: 15, column: 23, scope: !46)
!53 = !DILocalVariable(name: "index", scope: !46, file: !26, line: 15, type: !16)
!54 = !DILocation(line: 17, column: 5, scope: !46)
!55 = !DILocation(line: 18, column: 14, scope: !46)
!56 = !DILocation(line: 18, column: 12, scope: !46)
!57 = !DILocalVariable(name: "r", scope: !46, file: !26, line: 19, type: !27)
!58 = !DILocation(line: 20, column: 5, scope: !59)
!59 = distinct !DILexicalBlock(scope: !60, file: !26, line: 20, column: 5)
!60 = distinct !DILexicalBlock(scope: !46, file: !26, line: 20, column: 5)
!61 = !DILocation(line: 20, column: 5, scope: !60)
!62 = !DILocation(line: 21, column: 8, scope: !46)
!63 = !DILocation(line: 22, column: 5, scope: !46)
!64 = !DILocation(line: 23, column: 5, scope: !46)
!65 = distinct !DISubprogram(name: "ticketlock_acquire", scope: !31, file: !31, line: 37, type: !66, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!66 = !DISubroutineType(types: !67)
!67 = !{null, !68}
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!69 = !DILocalVariable(name: "l", arg: 1, scope: !65, file: !31, line: 37, type: !68)
!70 = !DILocation(line: 0, scope: !65)
!71 = !DILocation(line: 39, column: 18, scope: !65)
!72 = !DILocalVariable(name: "ticket", scope: !65, file: !31, line: 39, type: !27)
!73 = !DILocation(line: 40, column: 5, scope: !65)
!74 = !DILocation(line: 41, column: 1, scope: !65)
!75 = distinct !DISubprogram(name: "ticketlock_release", scope: !31, file: !31, line: 53, type: !66, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!76 = !DILocalVariable(name: "l", arg: 1, scope: !75, file: !31, line: 53, type: !68)
!77 = !DILocation(line: 0, scope: !75)
!78 = !DILocation(line: 55, column: 42, scope: !75)
!79 = !DILocation(line: 55, column: 17, scope: !75)
!80 = !DILocalVariable(name: "owner", scope: !75, file: !31, line: 55, type: !27)
!81 = !DILocation(line: 56, column: 44, scope: !75)
!82 = !DILocation(line: 56, column: 5, scope: !75)
!83 = !DILocation(line: 57, column: 1, scope: !75)
!84 = distinct !DISubprogram(name: "main", scope: !26, file: !26, line: 26, type: !85, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!85 = !DISubroutineType(types: !86)
!86 = !{!27}
!87 = !DILocalVariable(name: "t", scope: !84, file: !26, line: 28, type: !88)
!88 = !DICompositeType(tag: DW_TAG_array_type, baseType: !89, size: 192, elements: !91)
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !90, line: 27, baseType: !22)
!90 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!91 = !{!92}
!92 = !DISubrange(count: 3)
!93 = !DILocation(line: 28, column: 15, scope: !84)
!94 = !DILocation(line: 30, column: 5, scope: !84)
!95 = !DILocalVariable(name: "i", scope: !96, file: !26, line: 32, type: !27)
!96 = distinct !DILexicalBlock(scope: !84, file: !26, line: 32, column: 5)
!97 = !DILocation(line: 0, scope: !96)
!98 = !DILocation(line: 33, column: 25, scope: !99)
!99 = distinct !DILexicalBlock(scope: !96, file: !26, line: 32, column: 5)
!100 = !DILocation(line: 33, column: 9, scope: !99)
!101 = !DILocalVariable(name: "i", scope: !102, file: !26, line: 35, type: !27)
!102 = distinct !DILexicalBlock(scope: !84, file: !26, line: 35, column: 5)
!103 = !DILocation(line: 0, scope: !102)
!104 = !DILocation(line: 36, column: 22, scope: !105)
!105 = distinct !DILexicalBlock(scope: !102, file: !26, line: 35, column: 5)
!106 = !DILocation(line: 36, column: 9, scope: !105)
!107 = !DILocation(line: 38, column: 5, scope: !108)
!108 = distinct !DILexicalBlock(scope: !109, file: !26, line: 38, column: 5)
!109 = distinct !DILexicalBlock(scope: !84, file: !26, line: 38, column: 5)
!110 = !DILocation(line: 38, column: 5, scope: !109)
!111 = !DILocation(line: 40, column: 5, scope: !84)
!112 = distinct !DISubprogram(name: "ticketlock_init", scope: !31, file: !31, line: 20, type: !66, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!113 = !DILocalVariable(name: "l", arg: 1, scope: !112, file: !31, line: 20, type: !68)
!114 = !DILocation(line: 0, scope: !112)
!115 = !DILocation(line: 22, column: 21, scope: !112)
!116 = !DILocation(line: 22, column: 5, scope: !112)
!117 = !DILocation(line: 23, column: 21, scope: !112)
!118 = !DILocation(line: 23, column: 5, scope: !112)
!119 = !DILocation(line: 24, column: 1, scope: !112)
!120 = distinct !DISubprogram(name: "get_next_ticket", scope: !31, file: !31, line: 26, type: !121, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!121 = !DISubroutineType(types: !122)
!122 = !{!27, !68}
!123 = !DILocalVariable(name: "l", arg: 1, scope: !120, file: !31, line: 26, type: !68)
!124 = !DILocation(line: 0, scope: !120)
!125 = !DILocation(line: 28, column: 42, scope: !120)
!126 = !DILocation(line: 28, column: 12, scope: !120)
!127 = !DILocation(line: 28, column: 5, scope: !120)
!128 = distinct !DISubprogram(name: "await_for_ticket", scope: !31, file: !31, line: 31, type: !129, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!129 = !DISubroutineType(types: !130)
!130 = !{null, !68, !27}
!131 = !DILocalVariable(name: "l", arg: 1, scope: !128, file: !31, line: 31, type: !68)
!132 = !DILocation(line: 0, scope: !128)
!133 = !DILocalVariable(name: "ticket", arg: 2, scope: !128, file: !31, line: 31, type: !27)
!134 = !DILocation(line: 33, column: 5, scope: !128)
!135 = !DILocation(line: 33, column: 37, scope: !128)
!136 = !DILocation(line: 33, column: 12, scope: !128)
!137 = !DILocation(line: 33, column: 53, scope: !128)
!138 = distinct !{!138, !134, !139, !140}
!139 = !DILocation(line: 34, column: 9, scope: !128)
!140 = !{!"llvm.loop.mustprogress"}
!141 = !DILocation(line: 35, column: 1, scope: !128)
