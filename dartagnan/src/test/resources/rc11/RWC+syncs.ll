; ModuleID = '/home/ponce/git/Dat3M/output/RWC+syncs.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/rc11/RWC+syncs.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !18
@a = dso_local global i32 0, align 4, !dbg !24
@b = dso_local global i32 0, align 4, !dbg !26
@c = dso_local global i32 0, align 4, !dbg !28
@.str = private unnamed_addr constant [30 x i8] c"!(a == 1 && b == 0 && c == 0)\00", align 1
@.str.1 = private unnamed_addr constant [50 x i8] c"/home/ponce/git/Dat3M/benchmarks/rc11/RWC+syncs.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !38 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !42, metadata !DIExpression()), !dbg !43
  store atomic i32 1, i32* @x monotonic, align 4, !dbg !44
  ret i8* null, !dbg !45
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !46 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !47, metadata !DIExpression()), !dbg !48
  %2 = load atomic i32, i32* @x monotonic, align 4, !dbg !49
  call void @llvm.dbg.value(metadata i32 %2, metadata !50, metadata !DIExpression()), !dbg !48
  fence seq_cst, !dbg !51
  %3 = load atomic i32, i32* @y monotonic, align 4, !dbg !52
  call void @llvm.dbg.value(metadata i32 %3, metadata !53, metadata !DIExpression()), !dbg !48
  fence seq_cst, !dbg !54
  store i32 %2, i32* @a, align 4, !dbg !55
  store i32 %3, i32* @b, align 4, !dbg !56
  ret i8* null, !dbg !57
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_3(i8* noundef %0) #0 !dbg !58 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !59, metadata !DIExpression()), !dbg !60
  store atomic i32 1, i32* @y monotonic, align 4, !dbg !61
  fence seq_cst, !dbg !62
  %2 = load atomic i32, i32* @x monotonic, align 4, !dbg !63
  call void @llvm.dbg.value(metadata i32 %2, metadata !64, metadata !DIExpression()), !dbg !60
  fence seq_cst, !dbg !65
  store i32 %2, i32* @c, align 4, !dbg !66
  ret i8* null, !dbg !67
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !68 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.value(metadata i64* %1, metadata !71, metadata !DIExpression(DW_OP_deref)), !dbg !75
  %4 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_1, i8* noundef null) #5, !dbg !76
  call void @llvm.dbg.value(metadata i64* %2, metadata !77, metadata !DIExpression(DW_OP_deref)), !dbg !75
  %5 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_2, i8* noundef null) #5, !dbg !78
  call void @llvm.dbg.value(metadata i64* %3, metadata !79, metadata !DIExpression(DW_OP_deref)), !dbg !75
  %6 = call i32 @pthread_create(i64* noundef nonnull %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @thread_3, i8* noundef null) #5, !dbg !80
  %7 = load i64, i64* %1, align 8, !dbg !81
  call void @llvm.dbg.value(metadata i64 %7, metadata !71, metadata !DIExpression()), !dbg !75
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null) #5, !dbg !82
  %9 = load i64, i64* %2, align 8, !dbg !83
  call void @llvm.dbg.value(metadata i64 %9, metadata !77, metadata !DIExpression()), !dbg !75
  %10 = call i32 @pthread_join(i64 noundef %9, i8** noundef null) #5, !dbg !84
  %11 = load i64, i64* %3, align 8, !dbg !85
  call void @llvm.dbg.value(metadata i64 %11, metadata !79, metadata !DIExpression()), !dbg !75
  %12 = call i32 @pthread_join(i64 noundef %11, i8** noundef null) #5, !dbg !86
  %13 = load i32, i32* @a, align 4, !dbg !87
  %14 = icmp eq i32 %13, 1, !dbg !87
  %15 = load i32, i32* @b, align 4, !dbg !87
  %16 = icmp eq i32 %15, 0, !dbg !87
  %or.cond = select i1 %14, i1 %16, i1 false, !dbg !87
  %17 = load i32, i32* @c, align 4, !dbg !87
  %18 = icmp eq i32 %17, 0, !dbg !87
  %or.cond3 = select i1 %or.cond, i1 %18, i1 false, !dbg !87
  br i1 %or.cond3, label %19, label %20, !dbg !87

19:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @.str.1, i64 0, i64 0), i32 noundef 49, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !87
  unreachable, !dbg !87

20:                                               ; preds = %0
  ret i32 0, !dbg !90
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
!llvm.module.flags = !{!30, !31, !32, !33, !34, !35, !36}
!llvm.ident = !{!37}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !20, line: 6, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/rc11/RWC+syncs.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "c33d6c6340f3c537c38bbf020e9d0f36")
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
!17 = !{!0, !18, !24, !26, !28}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !20, line: 6, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/rc11/RWC+syncs.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "c33d6c6340f3c537c38bbf020e9d0f36")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!30 = !{i32 7, !"Dwarf Version", i32 5}
!31 = !{i32 2, !"Debug Info Version", i32 3}
!32 = !{i32 1, !"wchar_size", i32 4}
!33 = !{i32 7, !"PIC Level", i32 2}
!34 = !{i32 7, !"PIE Level", i32 2}
!35 = !{i32 7, !"uwtable", i32 1}
!36 = !{i32 7, !"frame-pointer", i32 2}
!37 = !{!"Ubuntu clang version 14.0.6"}
!38 = distinct !DISubprogram(name: "thread_1", scope: !20, file: !20, line: 10, type: !39, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !41)
!39 = !DISubroutineType(types: !40)
!40 = !{!16, !16}
!41 = !{}
!42 = !DILocalVariable(name: "unused", arg: 1, scope: !38, file: !20, line: 10, type: !16)
!43 = !DILocation(line: 0, scope: !38)
!44 = !DILocation(line: 12, column: 2, scope: !38)
!45 = !DILocation(line: 13, column: 2, scope: !38)
!46 = distinct !DISubprogram(name: "thread_2", scope: !20, file: !20, line: 16, type: !39, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !41)
!47 = !DILocalVariable(name: "unused", arg: 1, scope: !46, file: !20, line: 16, type: !16)
!48 = !DILocation(line: 0, scope: !46)
!49 = !DILocation(line: 18, column: 11, scope: !46)
!50 = !DILocalVariable(name: "r0", scope: !46, file: !20, line: 18, type: !23)
!51 = !DILocation(line: 19, column: 2, scope: !46)
!52 = !DILocation(line: 20, column: 11, scope: !46)
!53 = !DILocalVariable(name: "r1", scope: !46, file: !20, line: 20, type: !23)
!54 = !DILocation(line: 21, column: 2, scope: !46)
!55 = !DILocation(line: 22, column: 4, scope: !46)
!56 = !DILocation(line: 23, column: 4, scope: !46)
!57 = !DILocation(line: 24, column: 2, scope: !46)
!58 = distinct !DISubprogram(name: "thread_3", scope: !20, file: !20, line: 27, type: !39, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !41)
!59 = !DILocalVariable(name: "unused", arg: 1, scope: !58, file: !20, line: 27, type: !16)
!60 = !DILocation(line: 0, scope: !58)
!61 = !DILocation(line: 29, column: 2, scope: !58)
!62 = !DILocation(line: 30, column: 2, scope: !58)
!63 = !DILocation(line: 31, column: 11, scope: !58)
!64 = !DILocalVariable(name: "r0", scope: !58, file: !20, line: 31, type: !23)
!65 = !DILocation(line: 32, column: 2, scope: !58)
!66 = !DILocation(line: 33, column: 4, scope: !58)
!67 = !DILocation(line: 34, column: 2, scope: !58)
!68 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 37, type: !69, scopeLine: 38, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !41)
!69 = !DISubroutineType(types: !70)
!70 = !{!23}
!71 = !DILocalVariable(name: "t1", scope: !68, file: !20, line: 39, type: !72)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !73, line: 27, baseType: !74)
!73 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!74 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!75 = !DILocation(line: 0, scope: !68)
!76 = !DILocation(line: 41, column: 2, scope: !68)
!77 = !DILocalVariable(name: "t2", scope: !68, file: !20, line: 39, type: !72)
!78 = !DILocation(line: 42, column: 2, scope: !68)
!79 = !DILocalVariable(name: "t3", scope: !68, file: !20, line: 39, type: !72)
!80 = !DILocation(line: 43, column: 2, scope: !68)
!81 = !DILocation(line: 45, column: 15, scope: !68)
!82 = !DILocation(line: 45, column: 2, scope: !68)
!83 = !DILocation(line: 46, column: 15, scope: !68)
!84 = !DILocation(line: 46, column: 2, scope: !68)
!85 = !DILocation(line: 47, column: 15, scope: !68)
!86 = !DILocation(line: 47, column: 2, scope: !68)
!87 = !DILocation(line: 49, column: 2, scope: !88)
!88 = distinct !DILexicalBlock(scope: !89, file: !20, line: 49, column: 2)
!89 = distinct !DILexicalBlock(scope: !68, file: !20, line: 49, column: 2)
!90 = !DILocation(line: 51, column: 2, scope: !68)
