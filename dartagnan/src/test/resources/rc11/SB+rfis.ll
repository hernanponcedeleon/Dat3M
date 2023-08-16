; ModuleID = '/home/ponce/git/Dat3M/output/SB+rfis.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/rc11/SB+rfis.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !18
@a = dso_local global i32 0, align 4, !dbg !24
@b = dso_local global i32 0, align 4, !dbg !26
@c = dso_local global i32 0, align 4, !dbg !28
@d = dso_local global i32 0, align 4, !dbg !30
@.str = private unnamed_addr constant [40 x i8] c"!(a == 1 && b == 0 && c == 1 && d == 0)\00", align 1
@.str.1 = private unnamed_addr constant [48 x i8] c"/home/ponce/git/Dat3M/benchmarks/rc11/SB+rfis.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !40 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !44, metadata !DIExpression()), !dbg !45
  store atomic i32 1, i32* @x release, align 4, !dbg !46
  %2 = load atomic i32, i32* @x seq_cst, align 4, !dbg !47
  call void @llvm.dbg.value(metadata i32 %2, metadata !48, metadata !DIExpression()), !dbg !45
  %3 = load atomic i32, i32* @y seq_cst, align 4, !dbg !49
  call void @llvm.dbg.value(metadata i32 %3, metadata !50, metadata !DIExpression()), !dbg !45
  fence seq_cst, !dbg !51
  store i32 %2, i32* @a, align 4, !dbg !52
  store i32 %3, i32* @b, align 4, !dbg !53
  ret i8* null, !dbg !54
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !55 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !56, metadata !DIExpression()), !dbg !57
  store atomic i32 1, i32* @y release, align 4, !dbg !58
  %2 = load atomic i32, i32* @y seq_cst, align 4, !dbg !59
  call void @llvm.dbg.value(metadata i32 %2, metadata !60, metadata !DIExpression()), !dbg !57
  %3 = load atomic i32, i32* @x seq_cst, align 4, !dbg !61
  call void @llvm.dbg.value(metadata i32 %3, metadata !62, metadata !DIExpression()), !dbg !57
  fence seq_cst, !dbg !63
  store i32 %2, i32* @c, align 4, !dbg !64
  store i32 %3, i32* @d, align 4, !dbg !65
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
  %12 = icmp eq i32 %11, 0, !dbg !82
  %or.cond = select i1 %10, i1 %12, i1 false, !dbg !82
  %13 = load i32, i32* @c, align 4, !dbg !82
  %14 = icmp eq i32 %13, 1, !dbg !82
  %or.cond3 = select i1 %or.cond, i1 %14, i1 false, !dbg !82
  %15 = load i32, i32* @d, align 4, !dbg !82
  %16 = icmp eq i32 %15, 0, !dbg !82
  %or.cond5 = select i1 %or.cond3, i1 %16, i1 false, !dbg !82
  br i1 %or.cond5, label %17, label %18, !dbg !82

17:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.1, i64 0, i64 0), i32 noundef 42, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !82
  unreachable, !dbg !82

18:                                               ; preds = %0
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
!llvm.module.flags = !{!32, !33, !34, !35, !36, !37, !38}
!llvm.ident = !{!39}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !20, line: 6, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/rc11/SB+rfis.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "20bd765e7ed0e49f08b53e2660b8d281")
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
!17 = !{!0, !18, !24, !26, !28, !30}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !20, line: 6, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/rc11/SB+rfis.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "20bd765e7ed0e49f08b53e2660b8d281")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "d", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!32 = !{i32 7, !"Dwarf Version", i32 5}
!33 = !{i32 2, !"Debug Info Version", i32 3}
!34 = !{i32 1, !"wchar_size", i32 4}
!35 = !{i32 7, !"PIC Level", i32 2}
!36 = !{i32 7, !"PIE Level", i32 2}
!37 = !{i32 7, !"uwtable", i32 1}
!38 = !{i32 7, !"frame-pointer", i32 2}
!39 = !{!"Ubuntu clang version 14.0.6"}
!40 = distinct !DISubprogram(name: "thread_1", scope: !20, file: !20, line: 10, type: !41, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!41 = !DISubroutineType(types: !42)
!42 = !{!16, !16}
!43 = !{}
!44 = !DILocalVariable(name: "unused", arg: 1, scope: !40, file: !20, line: 10, type: !16)
!45 = !DILocation(line: 0, scope: !40)
!46 = !DILocation(line: 12, column: 2, scope: !40)
!47 = !DILocation(line: 13, column: 11, scope: !40)
!48 = !DILocalVariable(name: "r0", scope: !40, file: !20, line: 13, type: !23)
!49 = !DILocation(line: 14, column: 11, scope: !40)
!50 = !DILocalVariable(name: "r1", scope: !40, file: !20, line: 14, type: !23)
!51 = !DILocation(line: 15, column: 2, scope: !40)
!52 = !DILocation(line: 16, column: 4, scope: !40)
!53 = !DILocation(line: 17, column: 4, scope: !40)
!54 = !DILocation(line: 18, column: 2, scope: !40)
!55 = distinct !DISubprogram(name: "thread_2", scope: !20, file: !20, line: 21, type: !41, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!56 = !DILocalVariable(name: "unused", arg: 1, scope: !55, file: !20, line: 21, type: !16)
!57 = !DILocation(line: 0, scope: !55)
!58 = !DILocation(line: 23, column: 2, scope: !55)
!59 = !DILocation(line: 24, column: 11, scope: !55)
!60 = !DILocalVariable(name: "r0", scope: !55, file: !20, line: 24, type: !23)
!61 = !DILocation(line: 25, column: 11, scope: !55)
!62 = !DILocalVariable(name: "r1", scope: !55, file: !20, line: 25, type: !23)
!63 = !DILocation(line: 26, column: 2, scope: !55)
!64 = !DILocation(line: 27, column: 4, scope: !55)
!65 = !DILocation(line: 28, column: 4, scope: !55)
!66 = !DILocation(line: 29, column: 2, scope: !55)
!67 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 32, type: !68, scopeLine: 33, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
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
