; ModuleID = '/home/ponce/git/Dat3M/output/paper-E3.3.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/imm/paper-E3.3.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !18
@a = dso_local global i32 0, align 4, !dbg !24
@b = dso_local global i32 0, align 4, !dbg !26
@.str = private unnamed_addr constant [20 x i8] c"!(a == 1 && b == 1)\00", align 1
@.str.1 = private unnamed_addr constant [50 x i8] c"/home/ponce/git/Dat3M/benchmarks/imm/paper-E3.3.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !36 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !40, metadata !DIExpression()), !dbg !41
  %2 = load atomic i32, i32* @x monotonic, align 4, !dbg !42
  call void @llvm.dbg.value(metadata i32 %2, metadata !43, metadata !DIExpression()), !dbg !41
  store atomic i32 1, i32* @y release, align 4, !dbg !44
  fence seq_cst, !dbg !45
  store i32 %2, i32* @a, align 4, !dbg !46
  ret i8* null, !dbg !47
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !48 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !49, metadata !DIExpression()), !dbg !50
  %2 = load atomic i32, i32* @y monotonic, align 4, !dbg !51
  call void @llvm.dbg.value(metadata i32 %2, metadata !52, metadata !DIExpression()), !dbg !50
  store atomic i32 1, i32* @x release, align 4, !dbg !53
  fence seq_cst, !dbg !54
  store i32 %2, i32* @b, align 4, !dbg !55
  ret i8* null, !dbg !56
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !57 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !60, metadata !DIExpression(DW_OP_deref)), !dbg !64
  %3 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #5, !dbg !65
  call void @llvm.dbg.value(metadata i64* %2, metadata !66, metadata !DIExpression(DW_OP_deref)), !dbg !64
  %4 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #5, !dbg !67
  %5 = load i64, i64* %1, align 8, !dbg !68
  call void @llvm.dbg.value(metadata i64 %5, metadata !60, metadata !DIExpression()), !dbg !64
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef null) #5, !dbg !69
  %7 = load i64, i64* %2, align 8, !dbg !70
  call void @llvm.dbg.value(metadata i64 %7, metadata !66, metadata !DIExpression()), !dbg !64
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #5, !dbg !71
  %9 = load i32, i32* @a, align 4, !dbg !72
  %10 = icmp eq i32 %9, 1, !dbg !72
  %11 = load i32, i32* @b, align 4, !dbg !72
  %12 = icmp eq i32 %11, 1, !dbg !72
  %or.cond = select i1 %10, i1 %12, i1 false, !dbg !72
  br i1 %or.cond, label %13, label %14, !dbg !72

13:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !72
  unreachable, !dbg !72

14:                                               ; preds = %0
  ret i32 0, !dbg !75
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
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/imm/paper-E3.3.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "83446c7f9cd2f34fe6322f8c427f2c5b")
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
!20 = !DIFile(filename: "benchmarks/imm/paper-E3.3.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "83446c7f9cd2f34fe6322f8c427f2c5b")
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
!44 = !DILocation(line: 13, column: 2, scope: !36)
!45 = !DILocation(line: 14, column: 2, scope: !36)
!46 = !DILocation(line: 15, column: 4, scope: !36)
!47 = !DILocation(line: 16, column: 2, scope: !36)
!48 = distinct !DISubprogram(name: "thread_2", scope: !20, file: !20, line: 19, type: !37, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !39)
!49 = !DILocalVariable(name: "unused", arg: 1, scope: !48, file: !20, line: 19, type: !16)
!50 = !DILocation(line: 0, scope: !48)
!51 = !DILocation(line: 21, column: 11, scope: !48)
!52 = !DILocalVariable(name: "r0", scope: !48, file: !20, line: 21, type: !23)
!53 = !DILocation(line: 22, column: 2, scope: !48)
!54 = !DILocation(line: 23, column: 2, scope: !48)
!55 = !DILocation(line: 24, column: 4, scope: !48)
!56 = !DILocation(line: 25, column: 2, scope: !48)
!57 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 28, type: !58, scopeLine: 29, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !39)
!58 = !DISubroutineType(types: !59)
!59 = !{!23}
!60 = !DILocalVariable(name: "t1", scope: !57, file: !20, line: 30, type: !61)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !62, line: 27, baseType: !63)
!62 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!63 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!64 = !DILocation(line: 0, scope: !57)
!65 = !DILocation(line: 32, column: 2, scope: !57)
!66 = !DILocalVariable(name: "t2", scope: !57, file: !20, line: 30, type: !61)
!67 = !DILocation(line: 33, column: 2, scope: !57)
!68 = !DILocation(line: 35, column: 15, scope: !57)
!69 = !DILocation(line: 35, column: 2, scope: !57)
!70 = !DILocation(line: 36, column: 15, scope: !57)
!71 = !DILocation(line: 36, column: 2, scope: !57)
!72 = !DILocation(line: 38, column: 2, scope: !73)
!73 = distinct !DILexicalBlock(scope: !74, file: !20, line: 38, column: 2)
!74 = distinct !DILexicalBlock(scope: !57, file: !20, line: 38, column: 2)
!75 = !DILocation(line: 40, column: 2, scope: !57)
