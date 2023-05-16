; ModuleID = 'benchmarks/safe_stack.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lfds/safe_stack.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.SafeStackItem = type { i32, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@count = dso_local global i32 0, align 4, !dbg !0
@head = dso_local global i32 0, align 4, !dbg !21
@array = dso_local global [3 x %struct.SafeStackItem] zeroinitializer, align 16, !dbg !27
@.str = private unnamed_addr constant [25 x i8] c"array[elem].value == idx\00", align 1
@.str.1 = private unnamed_addr constant [51 x i8] c"/home/ponce/git/Dat3M/benchmarks/lfds/safe_stack.c\00", align 1
@__PRETTY_FUNCTION__.thread3 = private unnamed_addr constant [22 x i8] c"void *thread3(void *)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !46 {
  store i32 3, i32* @count, align 4, !dbg !50
  store i32 0, i32* @head, align 4, !dbg !51
  call void @llvm.dbg.value(metadata i32 0, metadata !52, metadata !DIExpression()), !dbg !54
  call void @llvm.dbg.value(metadata i64 0, metadata !52, metadata !DIExpression()), !dbg !54
  store i32 1, i32* getelementptr inbounds ([3 x %struct.SafeStackItem], [3 x %struct.SafeStackItem]* @array, i64 0, i64 0, i32 1), align 4, !dbg !55
  call void @llvm.dbg.value(metadata i64 1, metadata !52, metadata !DIExpression()), !dbg !54
  call void @llvm.dbg.value(metadata i64 1, metadata !52, metadata !DIExpression()), !dbg !54
  store i32 2, i32* getelementptr inbounds ([3 x %struct.SafeStackItem], [3 x %struct.SafeStackItem]* @array, i64 0, i64 1, i32 1), align 4, !dbg !55
  call void @llvm.dbg.value(metadata i64 2, metadata !52, metadata !DIExpression()), !dbg !54
  call void @llvm.dbg.value(metadata i64 2, metadata !52, metadata !DIExpression()), !dbg !54
  store i32 -1, i32* getelementptr inbounds ([3 x %struct.SafeStackItem], [3 x %struct.SafeStackItem]* @array, i64 0, i64 2, i32 1), align 4, !dbg !57
  ret void, !dbg !58
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @pop() #0 !dbg !59 {
  br label %1, !dbg !62

1:                                                ; preds = %19, %0
  %2 = load atomic i32, i32* @count acquire, align 4, !dbg !63
  %3 = icmp sgt i32 %2, 1, !dbg !64
  br i1 %3, label %4, label %20, !dbg !62

4:                                                ; preds = %1
  %5 = load atomic i32, i32* @head acquire, align 4, !dbg !65
  call void @llvm.dbg.value(metadata i32 %5, metadata !67, metadata !DIExpression()), !dbg !68
  %6 = sext i32 %5 to i64, !dbg !69
  %7 = getelementptr inbounds [3 x %struct.SafeStackItem], [3 x %struct.SafeStackItem]* @array, i64 0, i64 %6, !dbg !69
  %8 = getelementptr inbounds %struct.SafeStackItem, %struct.SafeStackItem* %7, i32 0, i32 1, !dbg !70
  %9 = atomicrmw xchg i32* %8, i32 -1 seq_cst, align 4, !dbg !71
  call void @llvm.dbg.value(metadata i32 %9, metadata !72, metadata !DIExpression()), !dbg !68
  %10 = icmp sge i32 %9, 0, !dbg !73
  br i1 %10, label %11, label %19, !dbg !75

11:                                               ; preds = %4
  call void @llvm.dbg.value(metadata i32 %5, metadata !76, metadata !DIExpression()), !dbg !78
  %12 = cmpxchg i32* @head, i32 %5, i32 %9 seq_cst seq_cst, align 4, !dbg !79
  %13 = extractvalue { i32, i1 } %12, 1, !dbg !79
  %14 = zext i1 %13 to i8, !dbg !79
  br i1 %13, label %15, label %17, !dbg !81

15:                                               ; preds = %11
  %16 = atomicrmw sub i32* @count, i32 1 seq_cst, align 4, !dbg !82
  br label %20, !dbg !84

17:                                               ; preds = %11
  %18 = atomicrmw xchg i32* %8, i32 %9 seq_cst, align 4, !dbg !85
  br label %19, !dbg !87

19:                                               ; preds = %17, %4
  br label %1, !dbg !62, !llvm.loop !88

20:                                               ; preds = %1, %15
  %.0 = phi i32 [ %5, %15 ], [ -1, %1 ], !dbg !91
  ret i32 %.0, !dbg !92
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @push(i32 noundef %0) #0 !dbg !93 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !96, metadata !DIExpression()), !dbg !97
  %2 = load atomic i32, i32* @head acquire, align 4, !dbg !98
  call void @llvm.dbg.value(metadata i32 %2, metadata !99, metadata !DIExpression()), !dbg !97
  br label %3, !dbg !100

3:                                                ; preds = %3, %1
  %.0 = phi i32 [ %2, %1 ], [ %.1, %3 ], !dbg !101
  call void @llvm.dbg.value(metadata i32 %.0, metadata !99, metadata !DIExpression()), !dbg !97
  %4 = sext i32 %0 to i64, !dbg !102
  %5 = getelementptr inbounds [3 x %struct.SafeStackItem], [3 x %struct.SafeStackItem]* @array, i64 0, i64 %4, !dbg !102
  %6 = getelementptr inbounds %struct.SafeStackItem, %struct.SafeStackItem* %5, i32 0, i32 1, !dbg !104
  store atomic i32 %.0, i32* %6 release, align 4, !dbg !105
  %7 = cmpxchg i32* @head, i32 %.0, i32 %0 seq_cst seq_cst, align 4, !dbg !106
  %8 = extractvalue { i32, i1 } %7, 0, !dbg !106
  %9 = extractvalue { i32, i1 } %7, 1, !dbg !106
  %.1 = select i1 %9, i32 %.0, i32 %8, !dbg !106
  call void @llvm.dbg.value(metadata i32 %.1, metadata !99, metadata !DIExpression()), !dbg !97
  %10 = zext i1 %9 to i8, !dbg !106
  %11 = zext i1 %9 to i32, !dbg !106
  %12 = icmp eq i32 %11, 0, !dbg !107
  br i1 %12, label %3, label %13, !dbg !108, !llvm.loop !109

13:                                               ; preds = %3
  %14 = atomicrmw add i32* @count, i32 1 seq_cst, align 4, !dbg !111
  ret void, !dbg !112
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread3(i8* noundef %0) #0 !dbg !113 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !117, metadata !DIExpression()), !dbg !118
  call void @llvm.dbg.value(metadata i64 %6, metadata !119, metadata !DIExpression()), !dbg !118
  br label %2, !dbg !120

2:                                                ; preds = %2, %1
  %3 = call i32 @pop(), !dbg !121
  call void @llvm.dbg.value(metadata i32 %3, metadata !122, metadata !DIExpression()), !dbg !118
  %4 = icmp slt i32 %3, 0, !dbg !123
  br i1 %4, label %2, label %5, !dbg !120, !llvm.loop !124

5:                                                ; preds = %2
  %6 = ptrtoint i8* %0 to i64, !dbg !126
  %7 = trunc i64 %6 to i32, !dbg !127
  %8 = sext i32 %3 to i64, !dbg !128
  %9 = getelementptr inbounds [3 x %struct.SafeStackItem], [3 x %struct.SafeStackItem]* @array, i64 0, i64 %8, !dbg !128
  %10 = getelementptr inbounds %struct.SafeStackItem, %struct.SafeStackItem* %9, i32 0, i32 0, !dbg !129
  store volatile i32 %7, i32* %10, align 8, !dbg !130
  %11 = load volatile i32, i32* %10, align 8, !dbg !131
  %12 = sext i32 %11 to i64, !dbg !131
  %13 = icmp eq i64 %12, %6, !dbg !131
  br i1 %13, label %15, label %14, !dbg !134

14:                                               ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 12, i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @__PRETTY_FUNCTION__.thread3, i64 0, i64 0)) #4, !dbg !131
  unreachable, !dbg !131

15:                                               ; preds = %5
  call void @push(i32 noundef %3), !dbg !135
  br label %16, !dbg !136

16:                                               ; preds = %16, %15
  %17 = call i32 @pop(), !dbg !137
  call void @llvm.dbg.value(metadata i32 %17, metadata !122, metadata !DIExpression()), !dbg !118
  %18 = icmp slt i32 %17, 0, !dbg !138
  br i1 %18, label %16, label %19, !dbg !136, !llvm.loop !139

19:                                               ; preds = %16
  %20 = sext i32 %17 to i64, !dbg !141
  %21 = getelementptr inbounds [3 x %struct.SafeStackItem], [3 x %struct.SafeStackItem]* @array, i64 0, i64 %20, !dbg !141
  %22 = getelementptr inbounds %struct.SafeStackItem, %struct.SafeStackItem* %21, i32 0, i32 0, !dbg !142
  store volatile i32 %7, i32* %22, align 8, !dbg !143
  %23 = load volatile i32, i32* %22, align 8, !dbg !144
  %24 = sext i32 %23 to i64, !dbg !144
  %25 = icmp eq i64 %24, %6, !dbg !144
  br i1 %25, label %27, label %26, !dbg !147

26:                                               ; preds = %19
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 17, i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @__PRETTY_FUNCTION__.thread3, i64 0, i64 0)) #4, !dbg !144
  unreachable, !dbg !144

27:                                               ; preds = %19
  call void @push(i32 noundef %17), !dbg !148
  ret i8* null, !dbg !149
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread1(i8* noundef %0) #0 !dbg !150 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !151, metadata !DIExpression()), !dbg !152
  call void @llvm.dbg.value(metadata i8* %0, metadata !153, metadata !DIExpression()), !dbg !152
  br label %2, !dbg !154

2:                                                ; preds = %2, %1
  %3 = call i32 @pop(), !dbg !155
  %4 = icmp slt i32 %3, 0, !dbg !156
  br i1 %4, label %2, label %5, !dbg !154, !llvm.loop !157

5:                                                ; preds = %2
  ret i8* null, !dbg !159
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !160 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !161, metadata !DIExpression()), !dbg !165
  call void @llvm.dbg.declare(metadata i64* %2, metadata !166, metadata !DIExpression()), !dbg !167
  call void @llvm.dbg.declare(metadata i64* %3, metadata !168, metadata !DIExpression()), !dbg !169
  call void @init(), !dbg !170
  %4 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread3, i8* noundef null) #5, !dbg !171
  %5 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread3, i8* noundef inttoptr (i64 1 to i8*)) #5, !dbg !172
  %6 = call i32 @pthread_create(i64* noundef %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread1, i8* noundef inttoptr (i64 2 to i8*)) #5, !dbg !173
  ret i32 0, !dbg !174
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!38, !39, !40, !41, !42, !43, !44}
!llvm.ident = !{!45}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "count", scope: !2, file: !23, line: 13, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !20, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lfds/safe_stack.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "bbdba2c3ced5207ce4ac789835b223d3")
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
!20 = !{!21, !0, !27}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "head", scope: !2, file: !23, line: 12, type: !24, isLocal: false, isDefinition: true)
!23 = !DIFile(filename: "benchmarks/lfds/safe_stack.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "1d7fc4d3ef14d21e9427d12b74b52a7a")
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !26)
!26 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "array", scope: !2, file: !23, line: 14, type: !29, isLocal: false, isDefinition: true)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 192, elements: !36)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "SafeStackItem", file: !23, line: 10, baseType: !31)
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !23, line: 7, size: 64, elements: !32)
!32 = !{!33, !35}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !31, file: !23, line: 8, baseType: !34, size: 32)
!34 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !26)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !31, file: !23, line: 9, baseType: !24, size: 32, offset: 32)
!36 = !{!37}
!37 = !DISubrange(count: 3)
!38 = !{i32 7, !"Dwarf Version", i32 5}
!39 = !{i32 2, !"Debug Info Version", i32 3}
!40 = !{i32 1, !"wchar_size", i32 4}
!41 = !{i32 7, !"PIC Level", i32 2}
!42 = !{i32 7, !"PIE Level", i32 2}
!43 = !{i32 7, !"uwtable", i32 1}
!44 = !{i32 7, !"frame-pointer", i32 2}
!45 = !{!"Ubuntu clang version 14.0.6"}
!46 = distinct !DISubprogram(name: "init", scope: !23, file: !23, line: 16, type: !47, scopeLine: 16, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!47 = !DISubroutineType(types: !48)
!48 = !{null}
!49 = !{}
!50 = !DILocation(line: 19, column: 5, scope: !46)
!51 = !DILocation(line: 20, column: 5, scope: !46)
!52 = !DILocalVariable(name: "i", scope: !53, file: !23, line: 22, type: !26)
!53 = distinct !DILexicalBlock(scope: !46, file: !23, line: 22, column: 5)
!54 = !DILocation(line: 0, scope: !53)
!55 = !DILocation(line: 23, column: 9, scope: !56)
!56 = distinct !DILexicalBlock(scope: !53, file: !23, line: 22, column: 5)
!57 = !DILocation(line: 25, column: 5, scope: !46)
!58 = !DILocation(line: 26, column: 1, scope: !46)
!59 = distinct !DISubprogram(name: "pop", scope: !23, file: !23, line: 28, type: !60, scopeLine: 28, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!60 = !DISubroutineType(types: !61)
!61 = !{!26}
!62 = !DILocation(line: 29, column: 5, scope: !59)
!63 = !DILocation(line: 29, column: 12, scope: !59)
!64 = !DILocation(line: 29, column: 63, scope: !59)
!65 = !DILocation(line: 30, column: 21, scope: !66)
!66 = distinct !DILexicalBlock(scope: !59, file: !23, line: 29, column: 68)
!67 = !DILocalVariable(name: "head1", scope: !66, file: !23, line: 30, type: !26)
!68 = !DILocation(line: 0, scope: !66)
!69 = !DILocation(line: 31, column: 47, scope: !66)
!70 = !DILocation(line: 31, column: 60, scope: !66)
!71 = !DILocation(line: 31, column: 21, scope: !66)
!72 = !DILocalVariable(name: "next1", scope: !66, file: !23, line: 31, type: !26)
!73 = !DILocation(line: 33, column: 19, scope: !74)
!74 = distinct !DILexicalBlock(scope: !66, file: !23, line: 33, column: 13)
!75 = !DILocation(line: 33, column: 13, scope: !66)
!76 = !DILocalVariable(name: "head2", scope: !77, file: !23, line: 34, type: !26)
!77 = distinct !DILexicalBlock(scope: !74, file: !23, line: 33, column: 25)
!78 = !DILocation(line: 0, scope: !77)
!79 = !DILocation(line: 35, column: 17, scope: !80)
!80 = distinct !DILexicalBlock(scope: !77, file: !23, line: 35, column: 17)
!81 = !DILocation(line: 35, column: 17, scope: !77)
!82 = !DILocation(line: 36, column: 17, scope: !83)
!83 = distinct !DILexicalBlock(scope: !80, file: !23, line: 35, column: 124)
!84 = !DILocation(line: 37, column: 17, scope: !83)
!85 = !DILocation(line: 40, column: 17, scope: !86)
!86 = distinct !DILexicalBlock(scope: !80, file: !23, line: 38, column: 20)
!87 = !DILocation(line: 42, column: 9, scope: !77)
!88 = distinct !{!88, !62, !89, !90}
!89 = !DILocation(line: 43, column: 5, scope: !59)
!90 = !{!"llvm.loop.mustprogress"}
!91 = !DILocation(line: 0, scope: !59)
!92 = !DILocation(line: 45, column: 1, scope: !59)
!93 = distinct !DISubprogram(name: "push", scope: !23, file: !23, line: 47, type: !94, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!94 = !DISubroutineType(types: !95)
!95 = !{null, !26}
!96 = !DILocalVariable(name: "index", arg: 1, scope: !93, file: !23, line: 47, type: !26)
!97 = !DILocation(line: 0, scope: !93)
!98 = !DILocation(line: 48, column: 17, scope: !93)
!99 = !DILocalVariable(name: "head1", scope: !93, file: !23, line: 48, type: !26)
!100 = !DILocation(line: 49, column: 5, scope: !93)
!101 = !DILocation(line: 48, column: 9, scope: !93)
!102 = !DILocation(line: 50, column: 32, scope: !103)
!103 = distinct !DILexicalBlock(scope: !93, file: !23, line: 49, column: 8)
!104 = !DILocation(line: 50, column: 45, scope: !103)
!105 = !DILocation(line: 50, column: 9, scope: !103)
!106 = !DILocation(line: 51, column: 14, scope: !93)
!107 = !DILocation(line: 51, column: 120, scope: !93)
!108 = !DILocation(line: 51, column: 5, scope: !103)
!109 = distinct !{!109, !100, !110, !90}
!110 = !DILocation(line: 51, column: 124, scope: !93)
!111 = !DILocation(line: 52, column: 5, scope: !93)
!112 = !DILocation(line: 53, column: 1, scope: !93)
!113 = distinct !DISubprogram(name: "thread3", scope: !114, file: !114, line: 5, type: !115, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!114 = !DIFile(filename: "benchmarks/lfds/safe_stack.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "bbdba2c3ced5207ce4ac789835b223d3")
!115 = !DISubroutineType(types: !116)
!116 = !{!19, !19}
!117 = !DILocalVariable(name: "arg", arg: 1, scope: !113, file: !114, line: 5, type: !19)
!118 = !DILocation(line: 0, scope: !113)
!119 = !DILocalVariable(name: "idx", scope: !113, file: !114, line: 7, type: !16)
!120 = !DILocation(line: 10, column: 5, scope: !113)
!121 = !DILocation(line: 10, column: 20, scope: !113)
!122 = !DILocalVariable(name: "elem", scope: !113, file: !114, line: 9, type: !26)
!123 = !DILocation(line: 10, column: 27, scope: !113)
!124 = distinct !{!124, !120, !125, !90}
!125 = !DILocation(line: 10, column: 33, scope: !113)
!126 = !DILocation(line: 7, column: 21, scope: !113)
!127 = !DILocation(line: 11, column: 25, scope: !113)
!128 = !DILocation(line: 11, column: 5, scope: !113)
!129 = !DILocation(line: 11, column: 17, scope: !113)
!130 = !DILocation(line: 11, column: 23, scope: !113)
!131 = !DILocation(line: 12, column: 5, scope: !132)
!132 = distinct !DILexicalBlock(scope: !133, file: !114, line: 12, column: 5)
!133 = distinct !DILexicalBlock(scope: !113, file: !114, line: 12, column: 5)
!134 = !DILocation(line: 12, column: 5, scope: !133)
!135 = !DILocation(line: 13, column: 5, scope: !113)
!136 = !DILocation(line: 15, column: 5, scope: !113)
!137 = !DILocation(line: 15, column: 20, scope: !113)
!138 = !DILocation(line: 15, column: 27, scope: !113)
!139 = distinct !{!139, !136, !140, !90}
!140 = !DILocation(line: 15, column: 33, scope: !113)
!141 = !DILocation(line: 16, column: 5, scope: !113)
!142 = !DILocation(line: 16, column: 17, scope: !113)
!143 = !DILocation(line: 16, column: 23, scope: !113)
!144 = !DILocation(line: 17, column: 5, scope: !145)
!145 = distinct !DILexicalBlock(scope: !146, file: !114, line: 17, column: 5)
!146 = distinct !DILexicalBlock(scope: !113, file: !114, line: 17, column: 5)
!147 = !DILocation(line: 17, column: 5, scope: !146)
!148 = !DILocation(line: 18, column: 5, scope: !113)
!149 = !DILocation(line: 19, column: 5, scope: !113)
!150 = distinct !DISubprogram(name: "thread1", scope: !114, file: !114, line: 22, type: !115, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!151 = !DILocalVariable(name: "arg", arg: 1, scope: !150, file: !114, line: 22, type: !19)
!152 = !DILocation(line: 0, scope: !150)
!153 = !DILocalVariable(name: "idx", scope: !150, file: !114, line: 24, type: !16)
!154 = !DILocation(line: 26, column: 5, scope: !150)
!155 = !DILocation(line: 26, column: 12, scope: !150)
!156 = !DILocation(line: 26, column: 18, scope: !150)
!157 = distinct !{!157, !154, !158, !90}
!158 = !DILocation(line: 26, column: 24, scope: !150)
!159 = !DILocation(line: 27, column: 5, scope: !150)
!160 = distinct !DISubprogram(name: "main", scope: !114, file: !114, line: 30, type: !60, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!161 = !DILocalVariable(name: "t0", scope: !160, file: !114, line: 32, type: !162)
!162 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !163, line: 27, baseType: !164)
!163 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!164 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!165 = !DILocation(line: 32, column: 15, scope: !160)
!166 = !DILocalVariable(name: "t1", scope: !160, file: !114, line: 32, type: !162)
!167 = !DILocation(line: 32, column: 19, scope: !160)
!168 = !DILocalVariable(name: "t2", scope: !160, file: !114, line: 32, type: !162)
!169 = !DILocation(line: 32, column: 23, scope: !160)
!170 = !DILocation(line: 34, column: 5, scope: !160)
!171 = !DILocation(line: 36, column: 5, scope: !160)
!172 = !DILocation(line: 37, column: 5, scope: !160)
!173 = !DILocation(line: 38, column: 5, scope: !160)
!174 = !DILocation(line: 40, column: 5, scope: !160)
