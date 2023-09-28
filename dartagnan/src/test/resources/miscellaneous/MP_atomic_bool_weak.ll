; ModuleID = '/home/ponce/git/Dat3M/output/MP_atomic_bool.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/MP_atomic_bool.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@data = dso_local global i32 0, align 4, !dbg !0
@flag = dso_local global i8 0, align 1, !dbg !18
@.str = private unnamed_addr constant [56 x i8] c"atomic_load_explicit(&data, memory_order_relaxed) == 42\00", align 1
@.str.1 = private unnamed_addr constant [66 x i8] c"/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/MP_atomic_bool.c\00", align 1
@__PRETTY_FUNCTION__.consumer = private unnamed_addr constant [23 x i8] c"void *consumer(void *)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @producer(i8* noundef %0) #0 !dbg !35 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !39, metadata !DIExpression()), !dbg !40
  store atomic i32 42, i32* @data monotonic, align 4, !dbg !41
  store atomic i8 1, i8* @flag monotonic, align 1, !dbg !42
  ret i8* null, !dbg !43
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @consumer(i8* noundef %0) #0 !dbg !44 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !45, metadata !DIExpression()), !dbg !46
  br label %2, !dbg !47

2:                                                ; preds = %2, %1
  %3 = load atomic i8, i8* @flag acquire, align 1, !dbg !48
  %4 = and i8 %3, 1, !dbg !48
  %.not.not = icmp eq i8 %4, 0, !dbg !49
  br i1 %.not.not, label %2, label %5, !dbg !47, !llvm.loop !50

5:                                                ; preds = %2
  %6 = load atomic i32, i32* @data monotonic, align 4, !dbg !53
  %7 = icmp eq i32 %6, 42, !dbg !53
  br i1 %7, label %9, label %8, !dbg !56

8:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([56 x i8], [56 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @.str.1, i64 0, i64 0), i32 noundef 22, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.consumer, i64 0, i64 0)) #4, !dbg !53
  unreachable, !dbg !53

9:                                                ; preds = %5
  ret i8* null, !dbg !57
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !58 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  store i8 0, i8* @flag, align 1, !dbg !61
  call void @llvm.dbg.value(metadata i64* %1, metadata !62, metadata !DIExpression(DW_OP_deref)), !dbg !66
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @producer, i8* noundef null) #5, !dbg !67
  call void @llvm.dbg.value(metadata i64* %2, metadata !68, metadata !DIExpression(DW_OP_deref)), !dbg !66
  %4 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @consumer, i8* noundef null) #5, !dbg !69
  ret i32 0, !dbg !70
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
!llvm.module.flags = !{!27, !28, !29, !30, !31, !32, !33}
!llvm.ident = !{!34}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !20, line: 6, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/MP_atomic_bool.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "41fe78566cd8738e99e1d9b97da4dabb")
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
!17 = !{!18, !0}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "flag", scope: !2, file: !20, line: 5, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/c/miscellaneous/MP_atomic_bool.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "41fe78566cd8738e99e1d9b97da4dabb")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_bool", file: !6, line: 85, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !26)
!26 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!27 = !{i32 7, !"Dwarf Version", i32 5}
!28 = !{i32 2, !"Debug Info Version", i32 3}
!29 = !{i32 1, !"wchar_size", i32 4}
!30 = !{i32 7, !"PIC Level", i32 2}
!31 = !{i32 7, !"PIE Level", i32 2}
!32 = !{i32 7, !"uwtable", i32 1}
!33 = !{i32 7, !"frame-pointer", i32 2}
!34 = !{!"Ubuntu clang version 14.0.6"}
!35 = distinct !DISubprogram(name: "producer", scope: !20, file: !20, line: 8, type: !36, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!36 = !DISubroutineType(types: !37)
!37 = !{!16, !16}
!38 = !{}
!39 = !DILocalVariable(name: "arg", arg: 1, scope: !35, file: !20, line: 8, type: !16)
!40 = !DILocation(line: 0, scope: !35)
!41 = !DILocation(line: 10, column: 5, scope: !35)
!42 = !DILocation(line: 12, column: 5, scope: !35)
!43 = !DILocation(line: 16, column: 5, scope: !35)
!44 = distinct !DISubprogram(name: "consumer", scope: !20, file: !20, line: 19, type: !36, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!45 = !DILocalVariable(name: "arg", arg: 1, scope: !44, file: !20, line: 19, type: !16)
!46 = !DILocation(line: 0, scope: !44)
!47 = !DILocation(line: 21, column: 5, scope: !44)
!48 = !DILocation(line: 21, column: 12, scope: !44)
!49 = !DILocation(line: 21, column: 62, scope: !44)
!50 = distinct !{!50, !47, !51, !52}
!51 = !DILocation(line: 21, column: 68, scope: !44)
!52 = !{!"llvm.loop.mustprogress"}
!53 = !DILocation(line: 22, column: 5, scope: !54)
!54 = distinct !DILexicalBlock(scope: !55, file: !20, line: 22, column: 5)
!55 = distinct !DILexicalBlock(scope: !44, file: !20, line: 22, column: 5)
!56 = !DILocation(line: 22, column: 5, scope: !55)
!57 = !DILocation(line: 23, column: 5, scope: !44)
!58 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 26, type: !59, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !38)
!59 = !DISubroutineType(types: !60)
!60 = !{!26}
!61 = !DILocation(line: 28, column: 5, scope: !58)
!62 = !DILocalVariable(name: "producer_t", scope: !58, file: !20, line: 29, type: !63)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !64, line: 27, baseType: !65)
!64 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!65 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!66 = !DILocation(line: 0, scope: !58)
!67 = !DILocation(line: 30, column: 5, scope: !58)
!68 = !DILocalVariable(name: "consumer_t", scope: !58, file: !20, line: 29, type: !63)
!69 = !DILocation(line: 31, column: 5, scope: !58)
!70 = !DILocation(line: 32, column: 1, scope: !58)
