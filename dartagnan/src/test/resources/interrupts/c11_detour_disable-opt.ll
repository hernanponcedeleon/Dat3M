; ModuleID = '/home/ponce/git/Dat3M/output/c11_detour_disable.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/interrupts/c11_detour_disable.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@y = dso_local global i32 0, align 4, !dbg !0
@h = dso_local global i64 0, align 8, !dbg !28
@x = dso_local global i32 0, align 4, !dbg !18
@a = dso_local global i32 0, align 4, !dbg !24
@b = dso_local global i32 0, align 4, !dbg !26
@.str = private unnamed_addr constant [30 x i8] c"!(b == 1 && a == 3 && y == 3)\00", align 1
@.str.1 = private unnamed_addr constant [65 x i8] c"/home/ponce/git/Dat3M/benchmarks/interrupts/c11_detour_disable.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @handler(i8* noundef %0) #0 !dbg !41 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !45, metadata !DIExpression()), !dbg !46
  store atomic i32 3, i32* @y seq_cst, align 4, !dbg !47
  ret i8* null, !dbg !48
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !49 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !50, metadata !DIExpression()), !dbg !51
  %2 = call i32 (...) @__VERIFIER_make_interrupt_handler(), !dbg !52
  %3 = call i32 @pthread_create(i64* noundef @h, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null) #5, !dbg !53
  %4 = call i32 (...) @__VERIFIER_disable_irq(), !dbg !54
  store atomic i32 1, i32* @x monotonic, align 4, !dbg !55
  %5 = load atomic i32, i32* @y monotonic, align 4, !dbg !56
  store i32 %5, i32* @a, align 4, !dbg !57
  %6 = call i32 (...) @__VERIFIER_enable_irq(), !dbg !58
  %7 = load i64, i64* @h, align 8, !dbg !59
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null), !dbg !60
  ret i8* null, !dbg !61
}

declare i32 @__VERIFIER_make_interrupt_handler(...) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @__VERIFIER_disable_irq(...) #2

declare i32 @__VERIFIER_enable_irq(...) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !62 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !63, metadata !DIExpression()), !dbg !64
  %2 = load atomic i32, i32* @x monotonic, align 4, !dbg !65
  store i32 %2, i32* @b, align 4, !dbg !66
  store atomic i32 2, i32* @y release, align 4, !dbg !67
  ret i8* null, !dbg !68
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !69 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !72, metadata !DIExpression()), !dbg !73
  call void @llvm.dbg.declare(metadata i64* %2, metadata !74, metadata !DIExpression()), !dbg !75
  %3 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef null) #5, !dbg !76
  %4 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_2, i8* noundef null) #5, !dbg !77
  %5 = load i64, i64* %1, align 8, !dbg !78
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef null), !dbg !79
  %7 = load i64, i64* %2, align 8, !dbg !80
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null), !dbg !81
  %9 = load i32, i32* @b, align 4, !dbg !82
  %10 = icmp eq i32 %9, 1, !dbg !82
  %11 = load i32, i32* @a, align 4, !dbg !82
  %12 = icmp eq i32 %11, 3, !dbg !82
  %or.cond = select i1 %10, i1 %12, i1 false, !dbg !82
  br i1 %or.cond, label %13, label %17, !dbg !82

13:                                               ; preds = %0
  %14 = load atomic i32, i32* @y seq_cst, align 4, !dbg !82
  %15 = icmp eq i32 %14, 3, !dbg !82
  br i1 %15, label %16, label %17, !dbg !85

16:                                               ; preds = %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.1, i64 0, i64 0), i32 noundef 48, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !82
  unreachable, !dbg !82

17:                                               ; preds = %0, %13
  ret i32 0, !dbg !86
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!33, !34, !35, !36, !37, !38, !39}
!llvm.ident = !{!40}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !20, line: 7, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/interrupts/c11_detour_disable.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "577894e706b5b839ee9d450e0afedc09")
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
!17 = !{!18, !0, !24, !26, !28}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !20, line: 7, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/interrupts/c11_detour_disable.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "577894e706b5b839ee9d450e0afedc09")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !23)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !20, line: 10, type: !30, isLocal: false, isDefinition: true)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !31, line: 27, baseType: !32)
!31 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!32 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!33 = !{i32 7, !"Dwarf Version", i32 5}
!34 = !{i32 2, !"Debug Info Version", i32 3}
!35 = !{i32 1, !"wchar_size", i32 4}
!36 = !{i32 7, !"PIC Level", i32 2}
!37 = !{i32 7, !"PIE Level", i32 2}
!38 = !{i32 7, !"uwtable", i32 1}
!39 = !{i32 7, !"frame-pointer", i32 2}
!40 = !{!"Ubuntu clang version 14.0.6"}
!41 = distinct !DISubprogram(name: "handler", scope: !20, file: !20, line: 11, type: !42, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !44)
!42 = !DISubroutineType(types: !43)
!43 = !{!16, !16}
!44 = !{}
!45 = !DILocalVariable(name: "arg", arg: 1, scope: !41, file: !20, line: 11, type: !16)
!46 = !DILocation(line: 0, scope: !41)
!47 = !DILocation(line: 13, column: 5, scope: !41)
!48 = !DILocation(line: 14, column: 5, scope: !41)
!49 = distinct !DISubprogram(name: "thread_1", scope: !20, file: !20, line: 17, type: !42, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !44)
!50 = !DILocalVariable(name: "arg", arg: 1, scope: !49, file: !20, line: 17, type: !16)
!51 = !DILocation(line: 0, scope: !49)
!52 = !DILocation(line: 19, column: 5, scope: !49)
!53 = !DILocation(line: 20, column: 5, scope: !49)
!54 = !DILocation(line: 22, column: 5, scope: !49)
!55 = !DILocation(line: 23, column: 5, scope: !49)
!56 = !DILocation(line: 24, column: 9, scope: !49)
!57 = !DILocation(line: 24, column: 7, scope: !49)
!58 = !DILocation(line: 25, column: 5, scope: !49)
!59 = !DILocation(line: 27, column: 18, scope: !49)
!60 = !DILocation(line: 27, column: 5, scope: !49)
!61 = !DILocation(line: 29, column: 5, scope: !49)
!62 = distinct !DISubprogram(name: "thread_2", scope: !20, file: !20, line: 32, type: !42, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !44)
!63 = !DILocalVariable(name: "arg", arg: 1, scope: !62, file: !20, line: 32, type: !16)
!64 = !DILocation(line: 0, scope: !62)
!65 = !DILocation(line: 34, column: 9, scope: !62)
!66 = !DILocation(line: 34, column: 7, scope: !62)
!67 = !DILocation(line: 35, column: 5, scope: !62)
!68 = !DILocation(line: 36, column: 5, scope: !62)
!69 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 39, type: !70, scopeLine: 40, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !44)
!70 = !DISubroutineType(types: !71)
!71 = !{!23}
!72 = !DILocalVariable(name: "t1", scope: !69, file: !20, line: 41, type: !30)
!73 = !DILocation(line: 41, column: 15, scope: !69)
!74 = !DILocalVariable(name: "t2", scope: !69, file: !20, line: 41, type: !30)
!75 = !DILocation(line: 41, column: 19, scope: !69)
!76 = !DILocation(line: 43, column: 5, scope: !69)
!77 = !DILocation(line: 44, column: 5, scope: !69)
!78 = !DILocation(line: 45, column: 18, scope: !69)
!79 = !DILocation(line: 45, column: 5, scope: !69)
!80 = !DILocation(line: 46, column: 18, scope: !69)
!81 = !DILocation(line: 46, column: 5, scope: !69)
!82 = !DILocation(line: 48, column: 5, scope: !83)
!83 = distinct !DILexicalBlock(scope: !84, file: !20, line: 48, column: 5)
!84 = distinct !DILexicalBlock(scope: !69, file: !20, line: 48, column: 5)
!85 = !DILocation(line: 48, column: 5, scope: !84)
!86 = !DILocation(line: 50, column: 5, scope: !69)
