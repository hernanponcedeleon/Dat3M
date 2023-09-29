; ModuleID = '/home/ponce/git/Dat3M/output/lkmm_oota.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/interrupts/lkmm_oota.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@z = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !30
@.str = private unnamed_addr constant [18 x i8] c"READ_ONCE(y) == 0\00", align 1
@.str.1 = private unnamed_addr constant [56 x i8] c"/home/ponce/git/Dat3M/benchmarks/interrupts/lkmm_oota.c\00", align 1
@__PRETTY_FUNCTION__.handler = private unnamed_addr constant [22 x i8] c"void *handler(void *)\00", align 1
@h = dso_local global i64 0, align 8, !dbg !32
@x = dso_local global i32 0, align 4, !dbg !26

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @handler(i8* noundef %0) #0 !dbg !45 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !49, metadata !DIExpression()), !dbg !50
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @z to i8*), i32 noundef 3, i32 noundef 1), !dbg !51
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1), !dbg !52
  %3 = icmp eq i32 %2, 0, !dbg !52
  br i1 %3, label %5, label %4, !dbg !55

4:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([56 x i8], [56 x i8]* @.str.1, i64 0, i64 0), i32 noundef 13, i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @__PRETTY_FUNCTION__.handler, i64 0, i64 0)) #5, !dbg !52
  unreachable, !dbg !52

5:                                                ; preds = %1
  ret i8* null, !dbg !56
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_STORE(i8* noundef, i32 noundef, i32 noundef) #2

declare i32 @__LKMM_LOAD(i8* noundef, i32 noundef) #2

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !57 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !58, metadata !DIExpression()), !dbg !59
  %2 = call i32 (...) @__VERIFIER_make_interrupt_handler(), !dbg !60
  %3 = call i32 @pthread_create(i64* noundef @h, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null) #6, !dbg !61
  %4 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1), !dbg !62
  %5 = icmp eq i32 %4, 1, !dbg !64
  br i1 %5, label %6, label %7, !dbg !65

6:                                                ; preds = %1
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @y to i8*), i32 noundef 2, i32 noundef 1), !dbg !66
  br label %7, !dbg !68

7:                                                ; preds = %6, %1
  %8 = load i64, i64* @h, align 8, !dbg !69
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !70
  ret i8* null, !dbg !71
}

declare i32 @__VERIFIER_make_interrupt_handler(...) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #4

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !72 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !73, metadata !DIExpression()), !dbg !74
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @z to i8*), i32 noundef 1), !dbg !75
  %3 = icmp eq i32 %2, 3, !dbg !77
  br i1 %3, label %4, label %5, !dbg !78

4:                                                ; preds = %1
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1, i32 noundef 1), !dbg !79
  br label %5, !dbg !81

5:                                                ; preds = %4, %1
  ret i8* null, !dbg !82
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !83 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !86, metadata !DIExpression()), !dbg !87
  call void @llvm.dbg.declare(metadata i64* %2, metadata !88, metadata !DIExpression()), !dbg !89
  %3 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef null) #6, !dbg !90
  %4 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_2, i8* noundef null) #6, !dbg !91
  ret i32 0, !dbg !92
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
!llvm.module.flags = !{!37, !38, !39, !40, !41, !42, !43}
!llvm.ident = !{!44}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/interrupts/lkmm_oota.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "046214f5cc2f6747b6f50936d730fc05")
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
!23 = !{!24}
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!25 = !{!26, !30, !0, !32}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/interrupts/lkmm_oota.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "046214f5cc2f6747b6f50936d730fc05")
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !28, line: 9, type: !34, isLocal: false, isDefinition: true)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !35, line: 27, baseType: !36)
!35 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!36 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!37 = !{i32 7, !"Dwarf Version", i32 5}
!38 = !{i32 2, !"Debug Info Version", i32 3}
!39 = !{i32 1, !"wchar_size", i32 4}
!40 = !{i32 7, !"PIC Level", i32 2}
!41 = !{i32 7, !"PIE Level", i32 2}
!42 = !{i32 7, !"uwtable", i32 1}
!43 = !{i32 7, !"frame-pointer", i32 2}
!44 = !{!"Ubuntu clang version 14.0.6"}
!45 = distinct !DISubprogram(name: "handler", scope: !28, file: !28, line: 10, type: !46, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !48)
!46 = !DISubroutineType(types: !47)
!47 = !{!24, !24}
!48 = !{}
!49 = !DILocalVariable(name: "arg", arg: 1, scope: !45, file: !28, line: 10, type: !24)
!50 = !DILocation(line: 0, scope: !45)
!51 = !DILocation(line: 12, column: 5, scope: !45)
!52 = !DILocation(line: 13, column: 5, scope: !53)
!53 = distinct !DILexicalBlock(scope: !54, file: !28, line: 13, column: 5)
!54 = distinct !DILexicalBlock(scope: !45, file: !28, line: 13, column: 5)
!55 = !DILocation(line: 13, column: 5, scope: !54)
!56 = !DILocation(line: 14, column: 5, scope: !45)
!57 = distinct !DISubprogram(name: "thread_1", scope: !28, file: !28, line: 17, type: !46, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !48)
!58 = !DILocalVariable(name: "arg", arg: 1, scope: !57, file: !28, line: 17, type: !24)
!59 = !DILocation(line: 0, scope: !57)
!60 = !DILocation(line: 19, column: 5, scope: !57)
!61 = !DILocation(line: 20, column: 5, scope: !57)
!62 = !DILocation(line: 22, column: 8, scope: !63)
!63 = distinct !DILexicalBlock(scope: !57, file: !28, line: 22, column: 8)
!64 = !DILocation(line: 22, column: 21, scope: !63)
!65 = !DILocation(line: 22, column: 8, scope: !57)
!66 = !DILocation(line: 23, column: 9, scope: !67)
!67 = distinct !DILexicalBlock(scope: !63, file: !28, line: 22, column: 27)
!68 = !DILocation(line: 24, column: 5, scope: !67)
!69 = !DILocation(line: 26, column: 18, scope: !57)
!70 = !DILocation(line: 26, column: 5, scope: !57)
!71 = !DILocation(line: 28, column: 5, scope: !57)
!72 = distinct !DISubprogram(name: "thread_2", scope: !28, file: !28, line: 31, type: !46, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !48)
!73 = !DILocalVariable(name: "arg", arg: 1, scope: !72, file: !28, line: 31, type: !24)
!74 = !DILocation(line: 0, scope: !72)
!75 = !DILocation(line: 33, column: 8, scope: !76)
!76 = distinct !DILexicalBlock(scope: !72, file: !28, line: 33, column: 8)
!77 = !DILocation(line: 33, column: 21, scope: !76)
!78 = !DILocation(line: 33, column: 8, scope: !72)
!79 = !DILocation(line: 34, column: 9, scope: !80)
!80 = distinct !DILexicalBlock(scope: !76, file: !28, line: 33, column: 27)
!81 = !DILocation(line: 35, column: 5, scope: !80)
!82 = !DILocation(line: 36, column: 5, scope: !72)
!83 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 39, type: !84, scopeLine: 40, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !48)
!84 = !DISubroutineType(types: !85)
!85 = !{!29}
!86 = !DILocalVariable(name: "t1", scope: !83, file: !28, line: 41, type: !34)
!87 = !DILocation(line: 41, column: 15, scope: !83)
!88 = !DILocalVariable(name: "t2", scope: !83, file: !28, line: 41, type: !34)
!89 = !DILocation(line: 41, column: 19, scope: !83)
!90 = !DILocation(line: 43, column: 5, scope: !83)
!91 = !DILocation(line: 44, column: 5, scope: !83)
!92 = !DILocation(line: 46, column: 5, scope: !83)
