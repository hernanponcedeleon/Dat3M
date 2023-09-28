; ModuleID = '/home/ponce/git/Dat3M/output/LB+deps.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/rc11/LB+deps.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !18
@a = dso_local global i32 0, align 4, !dbg !24
@b = dso_local global i32 0, align 4, !dbg !26
@.str = private unnamed_addr constant [20 x i8] c"!(a == 1 && b == 1)\00", align 1
@.str.1 = private unnamed_addr constant [48 x i8] c"/home/ponce/git/Dat3M/benchmarks/rc11/LB+deps.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !36 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !40, metadata !DIExpression()), !dbg !41
  %2 = load atomic i32, i32* @x monotonic, align 4, !dbg !42
  call void @llvm.dbg.value(metadata i32 %2, metadata !43, metadata !DIExpression()), !dbg !41
  %.not = icmp eq i32 %2, 0, !dbg !44
  br i1 %.not, label %4, label %3, !dbg !46

3:                                                ; preds = %1
  store atomic i32 %2, i32* @y monotonic, align 4, !dbg !47
  br label %4, !dbg !49

4:                                                ; preds = %3, %1
  fence seq_cst, !dbg !50
  store i32 %2, i32* @a, align 4, !dbg !51
  ret i8* null, !dbg !52
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !53 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !54, metadata !DIExpression()), !dbg !55
  %2 = load atomic i32, i32* @y monotonic, align 4, !dbg !56
  call void @llvm.dbg.value(metadata i32 %2, metadata !57, metadata !DIExpression()), !dbg !55
  %.not = icmp eq i32 %2, 0, !dbg !58
  br i1 %.not, label %4, label %3, !dbg !60

3:                                                ; preds = %1
  store atomic i32 %2, i32* @x monotonic, align 4, !dbg !61
  br label %4, !dbg !63

4:                                                ; preds = %3, %1
  fence seq_cst, !dbg !64
  store i32 %2, i32* @b, align 4, !dbg !65
  ret i8* null, !dbg !66
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !67 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !70, metadata !DIExpression(DW_OP_deref)), !dbg !74
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #5, !dbg !75
  call void @llvm.dbg.value(metadata i64* %2, metadata !76, metadata !DIExpression(DW_OP_deref)), !dbg !74
  %4 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #5, !dbg !77
  %5 = load i64, i64* %1, align 8, !dbg !78
  call void @llvm.dbg.value(metadata i64 %5, metadata !70, metadata !DIExpression()), !dbg !74
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef null) #5, !dbg !79
  %7 = load i64, i64* %2, align 8, !dbg !80
  call void @llvm.dbg.value(metadata i64 %7, metadata !76, metadata !DIExpression()), !dbg !74
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #5, !dbg !81
  %9 = load i32, i32* @a, align 4, !dbg !82
  %10 = icmp eq i32 %9, 1, !dbg !82
  %11 = load i32, i32* @b, align 4, !dbg !82
  %12 = icmp eq i32 %11, 1, !dbg !82
  %or.cond = select i1 %10, i1 %12, i1 false, !dbg !82
  br i1 %or.cond, label %13, label %14, !dbg !82

13:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.1, i64 0, i64 0), i32 noundef 42, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !82
  unreachable, !dbg !82

14:                                               ; preds = %0
  ret i32 0, !dbg !85
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!28, !29, !30, !31, !32, !33, !34}
!llvm.ident = !{!35}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !20, line: 6, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/rc11/LB+deps.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "f9720c0718f783c18e95d580993dd4d2")
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
!17 = !{!0, !18, !24, !26}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !20, line: 6, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/rc11/LB+deps.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "f9720c0718f783c18e95d580993dd4d2")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!28 = !{i32 7, !"Dwarf Version", i32 5}
!29 = !{i32 2, !"Debug Info Version", i32 3}
!30 = !{i32 1, !"wchar_size", i32 4}
!31 = !{i32 7, !"PIC Level", i32 2}
!32 = !{i32 7, !"PIE Level", i32 2}
!33 = !{i32 7, !"uwtable", i32 1}
!34 = !{i32 7, !"frame-pointer", i32 2}
!35 = !{!"Ubuntu clang version 14.0.6"}
!36 = distinct !DISubprogram(name: "thread_1", scope: !20, file: !20, line: 10, type: !37, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !39)
!37 = !DISubroutineType(types: !38)
!38 = !{!16, !16}
!39 = !{}
!40 = !DILocalVariable(name: "unused", arg: 1, scope: !36, file: !20, line: 10, type: !16)
!41 = !DILocation(line: 0, scope: !36)
!42 = !DILocation(line: 12, column: 11, scope: !36)
!43 = !DILocalVariable(name: "r0", scope: !36, file: !20, line: 12, type: !23)
!44 = !DILocation(line: 13, column: 5, scope: !45)
!45 = distinct !DILexicalBlock(scope: !36, file: !20, line: 13, column: 5)
!46 = !DILocation(line: 13, column: 5, scope: !36)
!47 = !DILocation(line: 14, column: 3, scope: !48)
!48 = distinct !DILexicalBlock(scope: !45, file: !20, line: 13, column: 9)
!49 = !DILocation(line: 15, column: 2, scope: !48)
!50 = !DILocation(line: 16, column: 2, scope: !36)
!51 = !DILocation(line: 17, column: 4, scope: !36)
!52 = !DILocation(line: 18, column: 2, scope: !36)
!53 = distinct !DISubprogram(name: "thread_2", scope: !20, file: !20, line: 21, type: !37, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !39)
!54 = !DILocalVariable(name: "unused", arg: 1, scope: !53, file: !20, line: 21, type: !16)
!55 = !DILocation(line: 0, scope: !53)
!56 = !DILocation(line: 23, column: 11, scope: !53)
!57 = !DILocalVariable(name: "r0", scope: !53, file: !20, line: 23, type: !23)
!58 = !DILocation(line: 24, column: 5, scope: !59)
!59 = distinct !DILexicalBlock(scope: !53, file: !20, line: 24, column: 5)
!60 = !DILocation(line: 24, column: 5, scope: !53)
!61 = !DILocation(line: 25, column: 3, scope: !62)
!62 = distinct !DILexicalBlock(scope: !59, file: !20, line: 24, column: 9)
!63 = !DILocation(line: 26, column: 2, scope: !62)
!64 = !DILocation(line: 27, column: 2, scope: !53)
!65 = !DILocation(line: 28, column: 4, scope: !53)
!66 = !DILocation(line: 29, column: 2, scope: !53)
!67 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 32, type: !68, scopeLine: 33, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !39)
!68 = !DISubroutineType(types: !69)
!69 = !{!23}
!70 = !DILocalVariable(name: "t1", scope: !67, file: !20, line: 34, type: !71)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !72, line: 27, baseType: !73)
!72 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!73 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!74 = !DILocation(line: 0, scope: !67)
!75 = !DILocation(line: 36, column: 2, scope: !67)
!76 = !DILocalVariable(name: "t2", scope: !67, file: !20, line: 34, type: !71)
!77 = !DILocation(line: 37, column: 2, scope: !67)
!78 = !DILocation(line: 39, column: 15, scope: !67)
!79 = !DILocation(line: 39, column: 2, scope: !67)
!80 = !DILocation(line: 40, column: 15, scope: !67)
!81 = !DILocation(line: 40, column: 2, scope: !67)
!82 = !DILocation(line: 42, column: 2, scope: !83)
!83 = distinct !DILexicalBlock(scope: !84, file: !20, line: 42, column: 2)
!84 = distinct !DILexicalBlock(scope: !67, file: !20, line: 42, column: 2)
!85 = !DILocation(line: 44, column: 2, scope: !67)
