; ModuleID = '/home/ponce/git/Dat3M/output/lkmm_with_barrier.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/interrupts/lkmm_with_barrier.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.A = type { i32, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@cnt = dso_local global i32 0, align 4, !dbg !0
@as = dso_local global [10 x %struct.A] zeroinitializer, align 16, !dbg !29
@.str = private unnamed_addr constant [19 x i8] c"as[i].a == as[i].b\00", align 1
@.str.1 = private unnamed_addr constant [64 x i8] c"/home/ponce/git/Dat3M/benchmarks/interrupts/lkmm_with_barrier.c\00", align 1
@__PRETTY_FUNCTION__.handler = private unnamed_addr constant [22 x i8] c"void *handler(void *)\00", align 1
@h = dso_local global i64 0, align 8, !dbg !41
@__PRETTY_FUNCTION__.run = private unnamed_addr constant [18 x i8] c"void *run(void *)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @handler(i8* noundef %0) #0 !dbg !54 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !58, metadata !DIExpression()), !dbg !59
  %2 = ptrtoint i8* %0 to i64, !dbg !60
  %3 = trunc i64 %2 to i32, !dbg !61
  call void @llvm.dbg.value(metadata i32 %3, metadata !62, metadata !DIExpression()), !dbg !59
  %4 = load i32, i32* @cnt, align 4, !dbg !63
  %5 = add nsw i32 %4, 1, !dbg !63
  store i32 %5, i32* @cnt, align 4, !dbg !63
  call void @llvm.dbg.value(metadata i32 %4, metadata !64, metadata !DIExpression()), !dbg !59
  call void @__LKMM_FENCE(i32 noundef 13), !dbg !65
  %6 = sext i32 %4 to i64, !dbg !66
  %7 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %6, !dbg !66
  %8 = getelementptr inbounds %struct.A, %struct.A* %7, i32 0, i32 0, !dbg !67
  store volatile i32 %3, i32* %8, align 8, !dbg !68
  %9 = getelementptr inbounds %struct.A, %struct.A* %7, i32 0, i32 1, !dbg !69
  store volatile i32 %3, i32* %9, align 4, !dbg !70
  %10 = load volatile i32, i32* %8, align 8, !dbg !71
  %11 = load volatile i32, i32* %9, align 4, !dbg !71
  %12 = icmp eq i32 %10, %11, !dbg !71
  br i1 %12, label %14, label %13, !dbg !74

13:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([64 x i8], [64 x i8]* @.str.1, i64 0, i64 0), i32 noundef 23, i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @__PRETTY_FUNCTION__.handler, i64 0, i64 0)) #5, !dbg !71
  unreachable, !dbg !71

14:                                               ; preds = %1
  ret i8* null, !dbg !75
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_FENCE(i32 noundef) #2

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !76 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !77, metadata !DIExpression()), !dbg !78
  %2 = call i32 (...) @__VERIFIER_make_interrupt_handler(), !dbg !79
  %3 = call i32 @pthread_create(i64* noundef @h, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null) #6, !dbg !80
  %4 = ptrtoint i8* %0 to i64, !dbg !81
  %5 = trunc i64 %4 to i32, !dbg !82
  call void @llvm.dbg.value(metadata i32 %5, metadata !83, metadata !DIExpression()), !dbg !78
  %6 = load i32, i32* @cnt, align 4, !dbg !84
  %7 = add nsw i32 %6, 1, !dbg !84
  store i32 %7, i32* @cnt, align 4, !dbg !84
  call void @llvm.dbg.value(metadata i32 %6, metadata !85, metadata !DIExpression()), !dbg !78
  call void @__LKMM_FENCE(i32 noundef 13), !dbg !86
  %8 = sext i32 %6 to i64, !dbg !87
  %9 = getelementptr inbounds [10 x %struct.A], [10 x %struct.A]* @as, i64 0, i64 %8, !dbg !87
  %10 = getelementptr inbounds %struct.A, %struct.A* %9, i32 0, i32 0, !dbg !88
  store volatile i32 %5, i32* %10, align 8, !dbg !89
  %11 = getelementptr inbounds %struct.A, %struct.A* %9, i32 0, i32 1, !dbg !90
  store volatile i32 %5, i32* %11, align 4, !dbg !91
  %12 = load volatile i32, i32* %10, align 8, !dbg !92
  %13 = load volatile i32, i32* %11, align 4, !dbg !92
  %14 = icmp eq i32 %12, %13, !dbg !92
  br i1 %14, label %16, label %15, !dbg !95

15:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([64 x i8], [64 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !92
  unreachable, !dbg !92

16:                                               ; preds = %1
  %17 = load i64, i64* @h, align 8, !dbg !96
  %18 = call i32 @pthread_join(i64 noundef %17, i8** noundef null), !dbg !97
  ret i8* null, !dbg !98
}

declare i32 @__VERIFIER_make_interrupt_handler(...) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #4

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !99 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !102, metadata !DIExpression()), !dbg !103
  %2 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef inttoptr (i64 1 to i8*)) #6, !dbg !104
  ret i32 0, !dbg !105
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!46, !47, !48, !49, !50, !51, !52}
!llvm.ident = !{!53}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "cnt", scope: !2, file: !31, line: 13, type: !37, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !28, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/interrupts/lkmm_with_barrier.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "5a7b863b73f17281194923457d79d9ea")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 3, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/lkmm.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "f219e5a4f2482585588927d06bb5e5c6")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_once", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "mb", value: 4)
!14 = !DIEnumerator(name: "wmb", value: 5)
!15 = !DIEnumerator(name: "rmb", value: 6)
!16 = !DIEnumerator(name: "rcu_lock", value: 7)
!17 = !DIEnumerator(name: "rcu_unlock", value: 8)
!18 = !DIEnumerator(name: "rcu_sync", value: 9)
!19 = !DIEnumerator(name: "before_atomic", value: 10)
!20 = !DIEnumerator(name: "after_atomic", value: 11)
!21 = !DIEnumerator(name: "after_spinlock", value: 12)
!22 = !DIEnumerator(name: "barrier", value: 13)
!23 = !{!24, !27}
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !25, line: 87, baseType: !26)
!25 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!26 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = !{!0, !29, !41}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "as", scope: !2, file: !31, line: 12, type: !32, isLocal: false, isDefinition: true)
!31 = !DIFile(filename: "benchmarks/interrupts/lkmm_with_barrier.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "5a7b863b73f17281194923457d79d9ea")
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 640, elements: !39)
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "A", file: !31, line: 11, size: 64, elements: !34)
!34 = !{!35, !38}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !33, file: !31, line: 11, baseType: !36, size: 32)
!36 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !37)
!37 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !33, file: !31, line: 11, baseType: !36, size: 32, offset: 32)
!39 = !{!40}
!40 = !DISubrange(count: 10)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !31, line: 15, type: !43, isLocal: false, isDefinition: true)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !44, line: 27, baseType: !45)
!44 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!45 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!46 = !{i32 7, !"Dwarf Version", i32 5}
!47 = !{i32 2, !"Debug Info Version", i32 3}
!48 = !{i32 1, !"wchar_size", i32 4}
!49 = !{i32 7, !"PIC Level", i32 2}
!50 = !{i32 7, !"PIE Level", i32 2}
!51 = !{i32 7, !"uwtable", i32 1}
!52 = !{i32 7, !"frame-pointer", i32 2}
!53 = !{!"Ubuntu clang version 14.0.6"}
!54 = distinct !DISubprogram(name: "handler", scope: !31, file: !31, line: 16, type: !55, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!55 = !DISubroutineType(types: !56)
!56 = !{!27, !27}
!57 = !{}
!58 = !DILocalVariable(name: "arg", arg: 1, scope: !54, file: !31, line: 16, type: !27)
!59 = !DILocation(line: 0, scope: !54)
!60 = !DILocation(line: 18, column: 19, scope: !54)
!61 = !DILocation(line: 18, column: 18, scope: !54)
!62 = !DILocalVariable(name: "tindex", scope: !54, file: !31, line: 18, type: !37)
!63 = !DILocation(line: 19, column: 16, scope: !54)
!64 = !DILocalVariable(name: "i", scope: !54, file: !31, line: 19, type: !37)
!65 = !DILocation(line: 20, column: 5, scope: !54)
!66 = !DILocation(line: 21, column: 5, scope: !54)
!67 = !DILocation(line: 21, column: 11, scope: !54)
!68 = !DILocation(line: 21, column: 13, scope: !54)
!69 = !DILocation(line: 22, column: 11, scope: !54)
!70 = !DILocation(line: 22, column: 13, scope: !54)
!71 = !DILocation(line: 23, column: 5, scope: !72)
!72 = distinct !DILexicalBlock(scope: !73, file: !31, line: 23, column: 5)
!73 = distinct !DILexicalBlock(scope: !54, file: !31, line: 23, column: 5)
!74 = !DILocation(line: 23, column: 5, scope: !73)
!75 = !DILocation(line: 25, column: 5, scope: !54)
!76 = distinct !DISubprogram(name: "run", scope: !31, file: !31, line: 28, type: !55, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!77 = !DILocalVariable(name: "arg", arg: 1, scope: !76, file: !31, line: 28, type: !27)
!78 = !DILocation(line: 0, scope: !76)
!79 = !DILocation(line: 30, column: 5, scope: !76)
!80 = !DILocation(line: 31, column: 5, scope: !76)
!81 = !DILocation(line: 33, column: 19, scope: !76)
!82 = !DILocation(line: 33, column: 18, scope: !76)
!83 = !DILocalVariable(name: "tindex", scope: !76, file: !31, line: 33, type: !37)
!84 = !DILocation(line: 34, column: 16, scope: !76)
!85 = !DILocalVariable(name: "i", scope: !76, file: !31, line: 34, type: !37)
!86 = !DILocation(line: 35, column: 5, scope: !76)
!87 = !DILocation(line: 36, column: 5, scope: !76)
!88 = !DILocation(line: 36, column: 11, scope: !76)
!89 = !DILocation(line: 36, column: 13, scope: !76)
!90 = !DILocation(line: 37, column: 11, scope: !76)
!91 = !DILocation(line: 37, column: 13, scope: !76)
!92 = !DILocation(line: 38, column: 5, scope: !93)
!93 = distinct !DILexicalBlock(scope: !94, file: !31, line: 38, column: 5)
!94 = distinct !DILexicalBlock(scope: !76, file: !31, line: 38, column: 5)
!95 = !DILocation(line: 38, column: 5, scope: !94)
!96 = !DILocation(line: 40, column: 18, scope: !76)
!97 = !DILocation(line: 40, column: 5, scope: !76)
!98 = !DILocation(line: 42, column: 5, scope: !76)
!99 = distinct !DISubprogram(name: "main", scope: !31, file: !31, line: 45, type: !100, scopeLine: 46, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!100 = !DISubroutineType(types: !101)
!101 = !{!37}
!102 = !DILocalVariable(name: "t", scope: !99, file: !31, line: 47, type: !43)
!103 = !DILocation(line: 47, column: 15, scope: !99)
!104 = !DILocation(line: 48, column: 5, scope: !99)
!105 = !DILocation(line: 50, column: 5, scope: !99)
