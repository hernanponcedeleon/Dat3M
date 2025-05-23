; ModuleID = '/home/ponce/git/Dat3M/output/c11_oota.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/interrupts/c11_oota.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@z = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !24
@.str = private unnamed_addr constant [52 x i8] c"atomic_load_explicit(&y, memory_order_relaxed) == 0\00", align 1
@.str.1 = private unnamed_addr constant [55 x i8] c"/home/ponce/git/Dat3M/benchmarks/interrupts/c11_oota.c\00", align 1
@__PRETTY_FUNCTION__.handler = private unnamed_addr constant [22 x i8] c"void *handler(void *)\00", align 1
@h = dso_local global i64 0, align 8, !dbg !26
@x = dso_local global i32 0, align 4, !dbg !18

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @handler(i8* noundef %0) #0 !dbg !39 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !43, metadata !DIExpression()), !dbg !44
  store atomic i32 3, i32* @z monotonic, align 4, !dbg !45
  %2 = load atomic i32, i32* @y monotonic, align 4, !dbg !46
  %3 = icmp eq i32 %2, 0, !dbg !46
  br i1 %3, label %5, label %4, !dbg !49

4:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.1, i64 0, i64 0), i32 noundef 13, i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @__PRETTY_FUNCTION__.handler, i64 0, i64 0)) #5, !dbg !46
  unreachable, !dbg !46

5:                                                ; preds = %1
  ret i8* null, !dbg !50
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !51 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !52, metadata !DIExpression()), !dbg !53
  %2 = call i32 (...) @__VERIFIER_make_interrupt_handler(), !dbg !54
  %3 = call i32 @pthread_create(i64* noundef @h, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null) #6, !dbg !55
  %4 = load atomic i32, i32* @x monotonic, align 4, !dbg !56
  %5 = icmp eq i32 %4, 1, !dbg !58
  br i1 %5, label %6, label %7, !dbg !59

6:                                                ; preds = %1
  store atomic i32 2, i32* @y monotonic, align 4, !dbg !60
  br label %7, !dbg !62

7:                                                ; preds = %6, %1
  %8 = load i64, i64* @h, align 8, !dbg !63
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !64
  ret i8* null, !dbg !65
}

declare i32 @__VERIFIER_make_interrupt_handler(...) #3

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #4

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !66 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !67, metadata !DIExpression()), !dbg !68
  %2 = load atomic i32, i32* @z monotonic, align 4, !dbg !69
  %3 = icmp eq i32 %2, 3, !dbg !71
  br i1 %3, label %4, label %5, !dbg !72

4:                                                ; preds = %1
  store atomic i32 1, i32* @x monotonic, align 4, !dbg !73
  br label %5, !dbg !75

5:                                                ; preds = %4, %1
  ret i8* null, !dbg !76
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !77 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !80, metadata !DIExpression()), !dbg !81
  call void @llvm.dbg.declare(metadata i64* %2, metadata !82, metadata !DIExpression()), !dbg !83
  %3 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef null) #6, !dbg !84
  %4 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_2, i8* noundef null) #6, !dbg !85
  ret i32 0, !dbg !86
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!31, !32, !33, !34, !35, !36, !37}
!llvm.ident = !{!38}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !20, line: 7, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/interrupts/c11_oota.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "9e30c560f3cb704ac0d36fae5b978cc5")
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
!17 = !{!18, !24, !0, !26}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !20, line: 7, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/interrupts/c11_oota.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "9e30c560f3cb704ac0d36fae5b978cc5")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !20, line: 7, type: !21, isLocal: false, isDefinition: true)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !20, line: 9, type: !28, isLocal: false, isDefinition: true)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !29, line: 27, baseType: !30)
!29 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!30 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!31 = !{i32 7, !"Dwarf Version", i32 5}
!32 = !{i32 2, !"Debug Info Version", i32 3}
!33 = !{i32 1, !"wchar_size", i32 4}
!34 = !{i32 7, !"PIC Level", i32 2}
!35 = !{i32 7, !"PIE Level", i32 2}
!36 = !{i32 7, !"uwtable", i32 1}
!37 = !{i32 7, !"frame-pointer", i32 2}
!38 = !{!"Ubuntu clang version 14.0.6"}
!39 = distinct !DISubprogram(name: "handler", scope: !20, file: !20, line: 10, type: !40, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!40 = !DISubroutineType(types: !41)
!41 = !{!16, !16}
!42 = !{}
!43 = !DILocalVariable(name: "arg", arg: 1, scope: !39, file: !20, line: 10, type: !16)
!44 = !DILocation(line: 0, scope: !39)
!45 = !DILocation(line: 12, column: 5, scope: !39)
!46 = !DILocation(line: 13, column: 5, scope: !47)
!47 = distinct !DILexicalBlock(scope: !48, file: !20, line: 13, column: 5)
!48 = distinct !DILexicalBlock(scope: !39, file: !20, line: 13, column: 5)
!49 = !DILocation(line: 13, column: 5, scope: !48)
!50 = !DILocation(line: 14, column: 5, scope: !39)
!51 = distinct !DISubprogram(name: "thread_1", scope: !20, file: !20, line: 17, type: !40, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!52 = !DILocalVariable(name: "arg", arg: 1, scope: !51, file: !20, line: 17, type: !16)
!53 = !DILocation(line: 0, scope: !51)
!54 = !DILocation(line: 19, column: 5, scope: !51)
!55 = !DILocation(line: 20, column: 5, scope: !51)
!56 = !DILocation(line: 22, column: 8, scope: !57)
!57 = distinct !DILexicalBlock(scope: !51, file: !20, line: 22, column: 8)
!58 = !DILocation(line: 22, column: 55, scope: !57)
!59 = !DILocation(line: 22, column: 8, scope: !51)
!60 = !DILocation(line: 23, column: 9, scope: !61)
!61 = distinct !DILexicalBlock(scope: !57, file: !20, line: 22, column: 61)
!62 = !DILocation(line: 24, column: 5, scope: !61)
!63 = !DILocation(line: 26, column: 18, scope: !51)
!64 = !DILocation(line: 26, column: 5, scope: !51)
!65 = !DILocation(line: 28, column: 5, scope: !51)
!66 = distinct !DISubprogram(name: "thread_2", scope: !20, file: !20, line: 31, type: !40, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!67 = !DILocalVariable(name: "arg", arg: 1, scope: !66, file: !20, line: 31, type: !16)
!68 = !DILocation(line: 0, scope: !66)
!69 = !DILocation(line: 33, column: 8, scope: !70)
!70 = distinct !DILexicalBlock(scope: !66, file: !20, line: 33, column: 8)
!71 = !DILocation(line: 33, column: 55, scope: !70)
!72 = !DILocation(line: 33, column: 8, scope: !66)
!73 = !DILocation(line: 34, column: 9, scope: !74)
!74 = distinct !DILexicalBlock(scope: !70, file: !20, line: 33, column: 61)
!75 = !DILocation(line: 35, column: 5, scope: !74)
!76 = !DILocation(line: 36, column: 5, scope: !66)
!77 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 39, type: !78, scopeLine: 40, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!78 = !DISubroutineType(types: !79)
!79 = !{!23}
!80 = !DILocalVariable(name: "t1", scope: !77, file: !20, line: 41, type: !28)
!81 = !DILocation(line: 41, column: 15, scope: !77)
!82 = !DILocalVariable(name: "t2", scope: !77, file: !20, line: 41, type: !28)
!83 = !DILocation(line: 41, column: 19, scope: !77)
!84 = !DILocation(line: 43, column: 5, scope: !77)
!85 = !DILocation(line: 44, column: 5, scope: !77)
!86 = !DILocation(line: 46, column: 5, scope: !77)
