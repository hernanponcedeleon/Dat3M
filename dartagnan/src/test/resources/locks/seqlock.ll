; ModuleID = '/home/ponce/git/Dat3M/output/seqlock.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/seqlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.seqlock_s = type { i32, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@lock = dso_local global %struct.seqlock_s zeroinitializer, align 4, !dbg !0
@t = dso_local global [6 x i64] zeroinitializer, align 16, !dbg !18
@.str = private unnamed_addr constant [9 x i8] c"r2 >= r1\00", align 1
@.str.1 = private unnamed_addr constant [49 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/seqlock.c\00", align 1
@__PRETTY_FUNCTION__.reader = private unnamed_addr constant [21 x i8] c"void *reader(void *)\00", align 1
@.str.2 = private unnamed_addr constant [65 x i8] c"atomic_load_explicit(&l->data, memory_order_relaxed) == new_data\00", align 1
@.str.3 = private unnamed_addr constant [49 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/seqlock.h\00", align 1
@__PRETTY_FUNCTION__.write = private unnamed_addr constant [36 x i8] c"void write(struct seqlock_s *, int)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @writer3(i8* noundef %0) #0 !dbg !44 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !48, metadata !DIExpression()), !dbg !49
  call void @write(%struct.seqlock_s* noundef @lock, i32 noundef 3), !dbg !50
  ret i8* null, !dbg !51
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @write(%struct.seqlock_s* noundef %0, i32 noundef %1) #0 !dbg !52 {
  call void @llvm.dbg.value(metadata %struct.seqlock_s* %0, metadata !56, metadata !DIExpression()), !dbg !57
  call void @llvm.dbg.value(metadata i32 %1, metadata !58, metadata !DIExpression()), !dbg !57
  br label %3, !dbg !59

3:                                                ; preds = %.backedge, %2
  %4 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %0, i32 0, i32 0, !dbg !60
  %5 = load atomic i32, i32* %4 acquire, align 4, !dbg !62
  call void @llvm.dbg.value(metadata i32 %5, metadata !63, metadata !DIExpression()), !dbg !64
  %6 = srem i32 %5, 2, !dbg !65
  %7 = icmp eq i32 %6, 1, !dbg !67
  br i1 %7, label %.backedge, label %8, !dbg !68

.backedge:                                        ; preds = %8, %3
  br label %3, !dbg !60, !llvm.loop !69

8:                                                ; preds = %3
  %9 = add nsw i32 %5, 1, !dbg !71
  %10 = cmpxchg i32* %4, i32 %5, i32 %9 monotonic monotonic, align 4, !dbg !73
  %11 = extractvalue { i32, i1 } %10, 1, !dbg !73
  %12 = zext i1 %11 to i8, !dbg !73
  br i1 %11, label %13, label %.backedge, !dbg !74

13:                                               ; preds = %8
  %14 = bitcast %struct.seqlock_s* %0 to i32*, !dbg !59
  %15 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %0, i32 0, i32 1, !dbg !75
  store atomic i32 %1, i32* %15 release, align 4, !dbg !76
  %16 = load atomic i32, i32* %15 monotonic, align 4, !dbg !77
  %17 = icmp eq i32 %16, %1, !dbg !77
  br i1 %17, label %19, label %18, !dbg !80

18:                                               ; preds = %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([49 x i8], [49 x i8]* @.str.3, i64 0, i64 0), i32 noundef 50, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.write, i64 0, i64 0)) #4, !dbg !77
  unreachable, !dbg !77

19:                                               ; preds = %13
  %20 = atomicrmw add i32* %14, i32 1 release, align 4, !dbg !81
  ret void, !dbg !82
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @writer2(i8* noundef %0) #0 !dbg !83 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !84, metadata !DIExpression()), !dbg !85
  call void @write(%struct.seqlock_s* noundef @lock, i32 noundef 2), !dbg !86
  %2 = call i32 @pthread_create(i64* noundef getelementptr inbounds ([6 x i64], [6 x i64]* @t, i64 0, i64 5), %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer3, i8* noundef null) #5, !dbg !87
  ret i8* null, !dbg !88
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @writer1(i8* noundef %0) #0 !dbg !89 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !90, metadata !DIExpression()), !dbg !91
  call void @write(%struct.seqlock_s* noundef @lock, i32 noundef 1), !dbg !92
  %2 = call i32 @pthread_create(i64* noundef getelementptr inbounds ([6 x i64], [6 x i64]* @t, i64 0, i64 4), %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer2, i8* noundef null) #5, !dbg !93
  ret i8* null, !dbg !94
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @reader(i8* noundef %0) #0 !dbg !95 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !96, metadata !DIExpression()), !dbg !97
  %2 = call i32 @read(%struct.seqlock_s* noundef @lock), !dbg !98
  call void @llvm.dbg.value(metadata i32 %2, metadata !99, metadata !DIExpression()), !dbg !97
  %3 = call i32 @read(%struct.seqlock_s* noundef @lock), !dbg !100
  call void @llvm.dbg.value(metadata i32 %3, metadata !101, metadata !DIExpression()), !dbg !97
  %4 = icmp sge i32 %3, %2, !dbg !102
  br i1 %4, label %6, label %5, !dbg !105

5:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([49 x i8], [49 x i8]* @.str.1, i64 0, i64 0), i32 noundef 33, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.reader, i64 0, i64 0)) #4, !dbg !102
  unreachable, !dbg !102

6:                                                ; preds = %1
  ret i8* null, !dbg !106
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @read(%struct.seqlock_s* noundef %0) #0 !dbg !107 {
  call void @llvm.dbg.value(metadata %struct.seqlock_s* %0, metadata !110, metadata !DIExpression()), !dbg !111
  %2 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %0, i32 0, i32 1, !dbg !112
  br label %3, !dbg !114

3:                                                ; preds = %.backedge, %1
  %4 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %0, i32 0, i32 0, !dbg !115
  %5 = load atomic i32, i32* %4 acquire, align 4, !dbg !116
  call void @llvm.dbg.value(metadata i32 %5, metadata !117, metadata !DIExpression()), !dbg !118
  %6 = srem i32 %5, 2, !dbg !119
  %7 = icmp eq i32 %6, 1, !dbg !121
  br i1 %7, label %.backedge, label %8, !dbg !122

.backedge:                                        ; preds = %8, %3
  br label %3, !dbg !115, !llvm.loop !123

8:                                                ; preds = %3
  %9 = load atomic i32, i32* %2 acquire, align 4, !dbg !125
  call void @llvm.dbg.value(metadata i32 %9, metadata !126, metadata !DIExpression()), !dbg !118
  %10 = load atomic i32, i32* %4 monotonic, align 4, !dbg !127
  %11 = icmp eq i32 %10, %5, !dbg !129
  br i1 %11, label %12, label %.backedge, !dbg !130

12:                                               ; preds = %8
  ret i32 %9, !dbg !131
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !133 {
  call void @seqlock_init(%struct.seqlock_s* noundef @lock), !dbg !136
  call void @llvm.dbg.value(metadata i32 0, metadata !137, metadata !DIExpression()), !dbg !139
  call void @llvm.dbg.value(metadata i64 0, metadata !137, metadata !DIExpression()), !dbg !139
  %1 = call i32 @pthread_create(i64* noundef getelementptr inbounds ([6 x i64], [6 x i64]* @t, i64 0, i64 0), %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef null) #5, !dbg !140
  call void @llvm.dbg.value(metadata i64 1, metadata !137, metadata !DIExpression()), !dbg !139
  call void @llvm.dbg.value(metadata i64 1, metadata !137, metadata !DIExpression()), !dbg !139
  %2 = call i32 @pthread_create(i64* noundef getelementptr inbounds ([6 x i64], [6 x i64]* @t, i64 0, i64 1), %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef null) #5, !dbg !140
  call void @llvm.dbg.value(metadata i64 2, metadata !137, metadata !DIExpression()), !dbg !139
  call void @llvm.dbg.value(metadata i64 2, metadata !137, metadata !DIExpression()), !dbg !139
  %3 = call i32 @pthread_create(i64* noundef getelementptr inbounds ([6 x i64], [6 x i64]* @t, i64 0, i64 2), %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef null) #5, !dbg !140
  call void @llvm.dbg.value(metadata i64 3, metadata !137, metadata !DIExpression()), !dbg !139
  call void @llvm.dbg.value(metadata i64 3, metadata !137, metadata !DIExpression()), !dbg !139
  %4 = call i32 @pthread_create(i64* noundef getelementptr inbounds ([6 x i64], [6 x i64]* @t, i64 0, i64 3), %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer1, i8* noundef null) #5, !dbg !142
  ret i32 0, !dbg !143
}

; Function Attrs: noinline nounwind uwtable
define internal void @seqlock_init(%struct.seqlock_s* noundef %0) #0 !dbg !144 {
  call void @llvm.dbg.value(metadata %struct.seqlock_s* %0, metadata !147, metadata !DIExpression()), !dbg !148
  %2 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %0, i32 0, i32 0, !dbg !149
  store i32 0, i32* %2, align 4, !dbg !150
  %3 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %0, i32 0, i32 1, !dbg !151
  store i32 0, i32* %3, align 4, !dbg !152
  ret void, !dbg !153
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!36, !37, !38, !39, !40, !41, !42}
!llvm.ident = !{!43}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !20, line: 10, type: !27, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/seqlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "42cc852e85e1b136597427a09419ff50")
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
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !{!0, !18}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "t", scope: !2, file: !20, line: 11, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/locks/seqlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "42cc852e85e1b136597427a09419ff50")
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 384, elements: !25)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !23, line: 27, baseType: !24)
!23 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!24 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!25 = !{!26}
!26 = !DISubrange(count: 6)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "seqlock_t", file: !28, line: 11, baseType: !29)
!28 = !DIFile(filename: "benchmarks/locks/seqlock.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "8c2c8f2e1512e5b9572661f3bad7f6a1")
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "seqlock_s", file: !28, line: 4, size: 64, elements: !30)
!30 = !{!31, !35}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !29, file: !28, line: 6, baseType: !32, size: 32)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !33)
!33 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !34)
!34 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !29, file: !28, line: 8, baseType: !32, size: 32, offset: 32)
!36 = !{i32 7, !"Dwarf Version", i32 5}
!37 = !{i32 2, !"Debug Info Version", i32 3}
!38 = !{i32 1, !"wchar_size", i32 4}
!39 = !{i32 7, !"PIC Level", i32 2}
!40 = !{i32 7, !"PIE Level", i32 2}
!41 = !{i32 7, !"uwtable", i32 1}
!42 = !{i32 7, !"frame-pointer", i32 2}
!43 = !{!"Ubuntu clang version 14.0.6"}
!44 = distinct !DISubprogram(name: "writer3", scope: !20, file: !20, line: 13, type: !45, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!45 = !DISubroutineType(types: !46)
!46 = !{!16, !16}
!47 = !{}
!48 = !DILocalVariable(name: "unused", arg: 1, scope: !44, file: !20, line: 13, type: !16)
!49 = !DILocation(line: 0, scope: !44)
!50 = !DILocation(line: 14, column: 5, scope: !44)
!51 = !DILocation(line: 15, column: 5, scope: !44)
!52 = distinct !DISubprogram(name: "write", scope: !28, file: !28, line: 34, type: !53, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !47)
!53 = !DISubroutineType(types: !54)
!54 = !{null, !55, !34}
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!56 = !DILocalVariable(name: "l", arg: 1, scope: !52, file: !28, line: 34, type: !55)
!57 = !DILocation(line: 0, scope: !52)
!58 = !DILocalVariable(name: "new_data", arg: 2, scope: !52, file: !28, line: 34, type: !34)
!59 = !DILocation(line: 36, column: 5, scope: !52)
!60 = !DILocation(line: 38, column: 48, scope: !61)
!61 = distinct !DILexicalBlock(scope: !52, file: !28, line: 36, column: 15)
!62 = !DILocation(line: 38, column: 23, scope: !61)
!63 = !DILocalVariable(name: "old_seq", scope: !61, file: !28, line: 38, type: !34)
!64 = !DILocation(line: 0, scope: !61)
!65 = !DILocation(line: 39, column: 21, scope: !66)
!66 = distinct !DILexicalBlock(scope: !61, file: !28, line: 39, column: 13)
!67 = !DILocation(line: 39, column: 25, scope: !66)
!68 = !DILocation(line: 39, column: 13, scope: !61)
!69 = distinct !{!69, !59, !70}
!70 = !DILocation(line: 45, column: 5, scope: !52)
!71 = !DILocation(line: 43, column: 80, scope: !72)
!72 = distinct !DILexicalBlock(scope: !61, file: !28, line: 43, column: 13)
!73 = !DILocation(line: 43, column: 13, scope: !72)
!74 = !DILocation(line: 43, column: 13, scope: !61)
!75 = !DILocation(line: 48, column: 31, scope: !52)
!76 = !DILocation(line: 48, column: 5, scope: !52)
!77 = !DILocation(line: 50, column: 5, scope: !78)
!78 = distinct !DILexicalBlock(scope: !79, file: !28, line: 50, column: 5)
!79 = distinct !DILexicalBlock(scope: !52, file: !28, line: 50, column: 5)
!80 = !DILocation(line: 50, column: 5, scope: !79)
!81 = !DILocation(line: 52, column: 5, scope: !52)
!82 = !DILocation(line: 53, column: 1, scope: !52)
!83 = distinct !DISubprogram(name: "writer2", scope: !20, file: !20, line: 18, type: !45, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!84 = !DILocalVariable(name: "unused", arg: 1, scope: !83, file: !20, line: 18, type: !16)
!85 = !DILocation(line: 0, scope: !83)
!86 = !DILocation(line: 19, column: 5, scope: !83)
!87 = !DILocation(line: 20, column: 5, scope: !83)
!88 = !DILocation(line: 21, column: 5, scope: !83)
!89 = distinct !DISubprogram(name: "writer1", scope: !20, file: !20, line: 24, type: !45, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!90 = !DILocalVariable(name: "unused", arg: 1, scope: !89, file: !20, line: 24, type: !16)
!91 = !DILocation(line: 0, scope: !89)
!92 = !DILocation(line: 25, column: 5, scope: !89)
!93 = !DILocation(line: 26, column: 5, scope: !89)
!94 = !DILocation(line: 27, column: 5, scope: !89)
!95 = distinct !DISubprogram(name: "reader", scope: !20, file: !20, line: 30, type: !45, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!96 = !DILocalVariable(name: "unused", arg: 1, scope: !95, file: !20, line: 30, type: !16)
!97 = !DILocation(line: 0, scope: !95)
!98 = !DILocation(line: 31, column: 11, scope: !95)
!99 = !DILocalVariable(name: "r1", scope: !95, file: !20, line: 31, type: !34)
!100 = !DILocation(line: 32, column: 14, scope: !95)
!101 = !DILocalVariable(name: "r2", scope: !95, file: !20, line: 32, type: !34)
!102 = !DILocation(line: 33, column: 5, scope: !103)
!103 = distinct !DILexicalBlock(scope: !104, file: !20, line: 33, column: 5)
!104 = distinct !DILexicalBlock(scope: !95, file: !20, line: 33, column: 5)
!105 = !DILocation(line: 33, column: 5, scope: !104)
!106 = !DILocation(line: 34, column: 5, scope: !95)
!107 = distinct !DISubprogram(name: "read", scope: !28, file: !28, line: 19, type: !108, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !47)
!108 = !DISubroutineType(types: !109)
!109 = !{!34, !55}
!110 = !DILocalVariable(name: "l", arg: 1, scope: !107, file: !28, line: 19, type: !55)
!111 = !DILocation(line: 0, scope: !107)
!112 = !DILocation(line: 27, column: 44, scope: !113)
!113 = distinct !DILexicalBlock(scope: !107, file: !28, line: 21, column: 15)
!114 = !DILocation(line: 21, column: 5, scope: !107)
!115 = !DILocation(line: 22, column: 48, scope: !113)
!116 = !DILocation(line: 22, column: 23, scope: !113)
!117 = !DILocalVariable(name: "old_seq", scope: !113, file: !28, line: 22, type: !34)
!118 = !DILocation(line: 0, scope: !113)
!119 = !DILocation(line: 23, column: 21, scope: !120)
!120 = distinct !DILexicalBlock(scope: !113, file: !28, line: 23, column: 13)
!121 = !DILocation(line: 23, column: 25, scope: !120)
!122 = !DILocation(line: 23, column: 13, scope: !113)
!123 = distinct !{!123, !114, !124}
!124 = !DILocation(line: 31, column: 5, scope: !107)
!125 = !DILocation(line: 27, column: 19, scope: !113)
!126 = !DILocalVariable(name: "res", scope: !113, file: !28, line: 27, type: !34)
!127 = !DILocation(line: 28, column: 13, scope: !128)
!128 = distinct !DILexicalBlock(scope: !113, file: !28, line: 28, column: 13)
!129 = !DILocation(line: 28, column: 65, scope: !128)
!130 = !DILocation(line: 28, column: 13, scope: !113)
!131 = !DILocation(line: 29, column: 13, scope: !132)
!132 = distinct !DILexicalBlock(scope: !128, file: !28, line: 28, column: 77)
!133 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 37, type: !134, scopeLine: 37, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !47)
!134 = !DISubroutineType(types: !135)
!135 = !{!34}
!136 = !DILocation(line: 39, column: 5, scope: !133)
!137 = !DILocalVariable(name: "i", scope: !138, file: !20, line: 41, type: !34)
!138 = distinct !DILexicalBlock(scope: !133, file: !20, line: 41, column: 5)
!139 = !DILocation(line: 0, scope: !138)
!140 = !DILocation(line: 42, column: 9, scope: !141)
!141 = distinct !DILexicalBlock(scope: !138, file: !20, line: 41, column: 5)
!142 = !DILocation(line: 44, column: 5, scope: !133)
!143 = !DILocation(line: 46, column: 5, scope: !133)
!144 = distinct !DISubprogram(name: "seqlock_init", scope: !28, file: !28, line: 13, type: !145, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !47)
!145 = !DISubroutineType(types: !146)
!146 = !{null, !55}
!147 = !DILocalVariable(name: "l", arg: 1, scope: !144, file: !28, line: 13, type: !55)
!148 = !DILocation(line: 0, scope: !144)
!149 = !DILocation(line: 15, column: 21, scope: !144)
!150 = !DILocation(line: 15, column: 5, scope: !144)
!151 = !DILocation(line: 16, column: 21, scope: !144)
!152 = !DILocation(line: 16, column: 5, scope: !144)
!153 = !DILocation(line: 17, column: 1, scope: !144)
