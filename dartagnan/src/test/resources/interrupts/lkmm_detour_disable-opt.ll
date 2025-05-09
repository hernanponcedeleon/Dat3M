; ModuleID = '/home/ponce/git/Dat3M/output/lkmm_detour_disable.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/interrupts/lkmm_detour_disable.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@y = dso_local global i32 0, align 4, !dbg !0
@h = dso_local global i64 0, align 8, !dbg !34
@x = dso_local global i32 0, align 4, !dbg !26
@a = dso_local global i32 0, align 4, !dbg !30
@b = dso_local global i32 0, align 4, !dbg !32
@.str = private unnamed_addr constant [30 x i8] c"!(b == 1 && a == 3 && y == 3)\00", align 1
@.str.1 = private unnamed_addr constant [66 x i8] c"/home/ponce/git/Dat3M/benchmarks/interrupts/lkmm_detour_disable.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @handler(i8* noundef %0) #0 !dbg !47 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !51, metadata !DIExpression()), !dbg !52
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @y to i8*), i32 noundef 3, i32 noundef 1), !dbg !53
  ret i8* null, !dbg !54
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @__LKMM_STORE(i8* noundef, i32 noundef, i32 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_1(i8* noundef %0) #0 !dbg !55 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !56, metadata !DIExpression()), !dbg !57
  %2 = call i32 (...) @__VERIFIER_make_interrupt_handler(), !dbg !58
  %3 = call i32 @pthread_create(i64* noundef @h, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @handler, i8* noundef null) #5, !dbg !59
  %4 = call i32 (...) @__VERIFIER_disable_irq(), !dbg !60
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1, i32 noundef 1), !dbg !61
  %5 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @y to i8*), i32 noundef 1), !dbg !62
  store i32 %5, i32* @a, align 4, !dbg !63
  %6 = call i32 (...) @__VERIFIER_enable_irq(), !dbg !64
  %7 = load i64, i64* @h, align 8, !dbg !65
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null), !dbg !66
  ret i8* null, !dbg !67
}

declare i32 @__VERIFIER_make_interrupt_handler(...) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @__VERIFIER_disable_irq(...) #2

declare i32 @__LKMM_LOAD(i8* noundef, i32 noundef) #2

declare i32 @__VERIFIER_enable_irq(...) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_2(i8* noundef %0) #0 !dbg !68 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !69, metadata !DIExpression()), !dbg !70
  %2 = call i32 @__LKMM_LOAD(i8* noundef bitcast (i32* @x to i8*), i32 noundef 1), !dbg !71
  store i32 %2, i32* @b, align 4, !dbg !72
  call void @__LKMM_STORE(i8* noundef bitcast (i32* @y to i8*), i32 noundef 2, i32 noundef 3), !dbg !73
  ret i8* null, !dbg !74
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !75 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !78, metadata !DIExpression()), !dbg !79
  call void @llvm.dbg.declare(metadata i64* %2, metadata !80, metadata !DIExpression()), !dbg !81
  %3 = call i32 @pthread_create(i64* noundef %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_1, i8* noundef null) #5, !dbg !82
  %4 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_2, i8* noundef null) #5, !dbg !83
  %5 = load i64, i64* %1, align 8, !dbg !84
  %6 = call i32 @pthread_join(i64 noundef %5, i8** noundef null), !dbg !85
  %7 = load i64, i64* %2, align 8, !dbg !86
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null), !dbg !87
  %9 = load i32, i32* @b, align 4, !dbg !88
  %10 = icmp eq i32 %9, 1, !dbg !88
  %11 = load i32, i32* @a, align 4, !dbg !88
  %12 = icmp eq i32 %11, 3, !dbg !88
  %or.cond = select i1 %10, i1 %12, i1 false, !dbg !88
  %13 = load i32, i32* @y, align 4, !dbg !88
  %14 = icmp eq i32 %13, 3, !dbg !88
  %or.cond3 = select i1 %or.cond, i1 %14, i1 false, !dbg !88
  br i1 %or.cond3, label %15, label %16, !dbg !88

15:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @.str.1, i64 0, i64 0), i32 noundef 47, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !88
  unreachable, !dbg !88

16:                                               ; preds = %0
  ret i32 0, !dbg !91
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
!llvm.module.flags = !{!39, !40, !41, !42, !43, !44, !45}
!llvm.ident = !{!46}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !25, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/interrupts/lkmm_detour_disable.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "a4729f2f9ca4805bc3a4900a72101bb5")
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
!25 = !{!26, !0, !30, !32, !34}
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!28 = !DIFile(filename: "benchmarks/interrupts/lkmm_detour_disable.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "a4729f2f9ca4805bc3a4900a72101bb5")
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !28, line: 7, type: !29, isLocal: false, isDefinition: true)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "h", scope: !2, file: !28, line: 9, type: !36, isLocal: false, isDefinition: true)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !37, line: 27, baseType: !38)
!37 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!38 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!39 = !{i32 7, !"Dwarf Version", i32 5}
!40 = !{i32 2, !"Debug Info Version", i32 3}
!41 = !{i32 1, !"wchar_size", i32 4}
!42 = !{i32 7, !"PIC Level", i32 2}
!43 = !{i32 7, !"PIE Level", i32 2}
!44 = !{i32 7, !"uwtable", i32 1}
!45 = !{i32 7, !"frame-pointer", i32 2}
!46 = !{!"Ubuntu clang version 14.0.6"}
!47 = distinct !DISubprogram(name: "handler", scope: !28, file: !28, line: 10, type: !48, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !50)
!48 = !DISubroutineType(types: !49)
!49 = !{!24, !24}
!50 = !{}
!51 = !DILocalVariable(name: "arg", arg: 1, scope: !47, file: !28, line: 10, type: !24)
!52 = !DILocation(line: 0, scope: !47)
!53 = !DILocation(line: 12, column: 5, scope: !47)
!54 = !DILocation(line: 13, column: 5, scope: !47)
!55 = distinct !DISubprogram(name: "thread_1", scope: !28, file: !28, line: 16, type: !48, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !50)
!56 = !DILocalVariable(name: "arg", arg: 1, scope: !55, file: !28, line: 16, type: !24)
!57 = !DILocation(line: 0, scope: !55)
!58 = !DILocation(line: 18, column: 5, scope: !55)
!59 = !DILocation(line: 19, column: 5, scope: !55)
!60 = !DILocation(line: 21, column: 5, scope: !55)
!61 = !DILocation(line: 22, column: 5, scope: !55)
!62 = !DILocation(line: 23, column: 9, scope: !55)
!63 = !DILocation(line: 23, column: 7, scope: !55)
!64 = !DILocation(line: 24, column: 5, scope: !55)
!65 = !DILocation(line: 26, column: 18, scope: !55)
!66 = !DILocation(line: 26, column: 5, scope: !55)
!67 = !DILocation(line: 28, column: 5, scope: !55)
!68 = distinct !DISubprogram(name: "thread_2", scope: !28, file: !28, line: 31, type: !48, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !50)
!69 = !DILocalVariable(name: "arg", arg: 1, scope: !68, file: !28, line: 31, type: !24)
!70 = !DILocation(line: 0, scope: !68)
!71 = !DILocation(line: 33, column: 9, scope: !68)
!72 = !DILocation(line: 33, column: 7, scope: !68)
!73 = !DILocation(line: 34, column: 5, scope: !68)
!74 = !DILocation(line: 35, column: 5, scope: !68)
!75 = distinct !DISubprogram(name: "main", scope: !28, file: !28, line: 38, type: !76, scopeLine: 39, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !50)
!76 = !DISubroutineType(types: !77)
!77 = !{!29}
!78 = !DILocalVariable(name: "t1", scope: !75, file: !28, line: 40, type: !36)
!79 = !DILocation(line: 40, column: 15, scope: !75)
!80 = !DILocalVariable(name: "t2", scope: !75, file: !28, line: 40, type: !36)
!81 = !DILocation(line: 40, column: 19, scope: !75)
!82 = !DILocation(line: 42, column: 5, scope: !75)
!83 = !DILocation(line: 43, column: 5, scope: !75)
!84 = !DILocation(line: 44, column: 18, scope: !75)
!85 = !DILocation(line: 44, column: 5, scope: !75)
!86 = !DILocation(line: 45, column: 18, scope: !75)
!87 = !DILocation(line: 45, column: 5, scope: !75)
!88 = !DILocation(line: 47, column: 5, scope: !89)
!89 = distinct !DILexicalBlock(scope: !90, file: !28, line: 47, column: 5)
!90 = distinct !DILexicalBlock(scope: !75, file: !28, line: 47, column: 5)
!91 = !DILocation(line: 49, column: 5, scope: !75)
