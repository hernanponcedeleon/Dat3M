; ModuleID = '/home/ponce/git/Dat3M/output/idd_dynamic.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/idd_dynamic.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !18
@z = dso_local global i32 0, align 4, !dbg !24
@.str = private unnamed_addr constant [8 x i8] c"u != 42\00", align 1
@.str.1 = private unnamed_addr constant [63 x i8] c"/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/idd_dynamic.c\00", align 1
@__PRETTY_FUNCTION__.thread_1 = private unnamed_addr constant [23 x i8] c"void *thread_1(void *)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !34 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !38, metadata !DIExpression()), !dbg !39
  %2 = load atomic i32, i32* @x monotonic, align 4, !dbg !40
  call void @llvm.dbg.value(metadata i32 %2, metadata !41, metadata !DIExpression()), !dbg !39
  %3 = load atomic i32, i32* @y monotonic, align 4, !dbg !42
  call void @llvm.dbg.value(metadata i32 %3, metadata !43, metadata !DIExpression()), !dbg !39
  call void @llvm.dbg.value(metadata i32 %3, metadata !44, metadata !DIExpression()), !dbg !39
  %4 = icmp eq i32 %2, 0, !dbg !45
  br i1 %4, label %5, label %6, !dbg !47

5:                                                ; preds = %1
  store atomic i32 4, i32* @z monotonic, align 4, !dbg !48
  call void @llvm.dbg.value(metadata i32 42, metadata !43, metadata !DIExpression()), !dbg !39
  br label %6, !dbg !50

6:                                                ; preds = %5, %1
  %.0 = phi i32 [ 42, %5 ], [ %3, %1 ], !dbg !39
  call void @llvm.dbg.value(metadata i32 %.0, metadata !43, metadata !DIExpression()), !dbg !39
  store atomic i32 %.0, i32* @x monotonic, align 4, !dbg !51
  %.not = icmp eq i32 %3, 42, !dbg !52
  br i1 %.not, label %7, label %8, !dbg !55

7:                                                ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 21, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_1, i64 0, i64 0)) #5, !dbg !52
  unreachable, !dbg !52

8:                                                ; preds = %6
  ret i8* null, !dbg !56
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !57 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !58, metadata !DIExpression()), !dbg !59
  %2 = load atomic i32, i32* @x monotonic, align 4, !dbg !60
  call void @llvm.dbg.value(metadata i32 %2, metadata !61, metadata !DIExpression()), !dbg !59
  store atomic i32 %2, i32* @y monotonic, align 4, !dbg !62
  ret i8* null, !dbg !63
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !64 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !67, metadata !DIExpression(DW_OP_deref)), !dbg !71
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #6, !dbg !72
  call void @llvm.dbg.value(metadata i64* %2, metadata !73, metadata !DIExpression(DW_OP_deref)), !dbg !71
  %4 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #6, !dbg !74
  %5 = load i64, i64* %1, align 8, !dbg !75
  call void @llvm.dbg.value(metadata i64 %5, metadata !67, metadata !DIExpression()), !dbg !71
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef null) #6, !dbg !76
  %7 = load i64, i64* %2, align 8, !dbg !77
  call void @llvm.dbg.value(metadata i64 %7, metadata !73, metadata !DIExpression()), !dbg !71
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #6, !dbg !78
  ret i32 0, !dbg !79
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

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
!llvm.module.flags = !{!26, !27, !28, !29, !30, !31, !32}
!llvm.ident = !{!33}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !20, line: 9, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/idd_dynamic.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "7919360984487f17f577d3dba51c4481")
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
!17 = !{!0, !18, !24}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !20, line: 9, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/c/miscellaneous/idd_dynamic.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "7919360984487f17f577d3dba51c4481")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !20, line: 9, type: !21, isLocal: false, isDefinition: true)
!26 = !{i32 7, !"Dwarf Version", i32 5}
!27 = !{i32 2, !"Debug Info Version", i32 3}
!28 = !{i32 1, !"wchar_size", i32 4}
!29 = !{i32 7, !"PIC Level", i32 2}
!30 = !{i32 7, !"PIE Level", i32 2}
!31 = !{i32 7, !"uwtable", i32 1}
!32 = !{i32 7, !"frame-pointer", i32 2}
!33 = !{!"Ubuntu clang version 14.0.6"}
!34 = distinct !DISubprogram(name: "thread_1", scope: !20, file: !20, line: 11, type: !35, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !37)
!35 = !DISubroutineType(types: !36)
!36 = !{!16, !16}
!37 = !{}
!38 = !DILocalVariable(name: "unused", arg: 1, scope: !34, file: !20, line: 11, type: !16)
!39 = !DILocation(line: 0, scope: !34)
!40 = !DILocation(line: 13, column: 10, scope: !34)
!41 = !DILocalVariable(name: "r", scope: !34, file: !20, line: 13, type: !23)
!42 = !DILocation(line: 14, column: 10, scope: !34)
!43 = !DILocalVariable(name: "s", scope: !34, file: !20, line: 14, type: !23)
!44 = !DILocalVariable(name: "u", scope: !34, file: !20, line: 15, type: !23)
!45 = !DILocation(line: 16, column: 8, scope: !46)
!46 = distinct !DILexicalBlock(scope: !34, file: !20, line: 16, column: 6)
!47 = !DILocation(line: 16, column: 6, scope: !34)
!48 = !DILocation(line: 17, column: 3, scope: !49)
!49 = distinct !DILexicalBlock(scope: !46, file: !20, line: 16, column: 14)
!50 = !DILocation(line: 19, column: 2, scope: !49)
!51 = !DILocation(line: 20, column: 2, scope: !34)
!52 = !DILocation(line: 21, column: 2, scope: !53)
!53 = distinct !DILexicalBlock(scope: !54, file: !20, line: 21, column: 2)
!54 = distinct !DILexicalBlock(scope: !34, file: !20, line: 21, column: 2)
!55 = !DILocation(line: 21, column: 2, scope: !54)
!56 = !DILocation(line: 22, column: 2, scope: !34)
!57 = distinct !DISubprogram(name: "thread_2", scope: !20, file: !20, line: 25, type: !35, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !37)
!58 = !DILocalVariable(name: "unused", arg: 1, scope: !57, file: !20, line: 25, type: !16)
!59 = !DILocation(line: 0, scope: !57)
!60 = !DILocation(line: 27, column: 10, scope: !57)
!61 = !DILocalVariable(name: "a", scope: !57, file: !20, line: 27, type: !23)
!62 = !DILocation(line: 28, column: 2, scope: !57)
!63 = !DILocation(line: 29, column: 2, scope: !57)
!64 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 32, type: !65, scopeLine: 33, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !37)
!65 = !DISubroutineType(types: !66)
!66 = !{!23}
!67 = !DILocalVariable(name: "t1", scope: !64, file: !20, line: 34, type: !68)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !69, line: 27, baseType: !70)
!69 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!70 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!71 = !DILocation(line: 0, scope: !64)
!72 = !DILocation(line: 36, column: 2, scope: !64)
!73 = !DILocalVariable(name: "t2", scope: !64, file: !20, line: 34, type: !68)
!74 = !DILocation(line: 37, column: 2, scope: !64)
!75 = !DILocation(line: 39, column: 15, scope: !64)
!76 = !DILocation(line: 39, column: 2, scope: !64)
!77 = !DILocation(line: 40, column: 15, scope: !64)
!78 = !DILocation(line: 40, column: 2, scope: !64)
!79 = !DILocation(line: 42, column: 2, scope: !64)
