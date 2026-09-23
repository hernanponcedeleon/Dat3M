; ModuleID = 'pthread_barrier_excess.c'
source_filename = "pthread_barrier_excess.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_barrier_t = type { i64, [24 x i8] }

@barrier = dso_local global %union.pthread_barrier_t zeroinitializer, align 8, !dbg !0
@passed = dso_local global i32 0, align 4, !dbg !24
@.str = private unnamed_addr constant [33 x i8] c"atomic_fetch_add(&passed, 1) < 2\00", align 1, !dbg !7
@.str.1 = private unnamed_addr constant [25 x i8] c"pthread_barrier_excess.c\00", align 1, !dbg !13
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1, !dbg !18

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !48 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !52, !DIExpression(), !53)
  %5 = call i32 @pthread_barrier_wait(ptr noundef @barrier) #3, !dbg !54
  store i32 1, ptr %3, align 4, !dbg !55
  %6 = load i32, ptr %3, align 4, !dbg !55
  %7 = atomicrmw add ptr @passed, i32 %6 seq_cst, align 4, !dbg !55
  store i32 %7, ptr %4, align 4, !dbg !55
  %8 = load i32, ptr %4, align 4, !dbg !55
  %9 = icmp slt i32 %8, 2, !dbg !55
  br i1 %9, label %10, label %11, !dbg !55

10:                                               ; preds = %1
  br label %12, !dbg !55

11:                                               ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 13, ptr noundef @__PRETTY_FUNCTION__.worker) #4, !dbg !55
  unreachable, !dbg !55

12:                                               ; preds = %10
  ret ptr null, !dbg !58
}

; Function Attrs: nounwind
declare i32 @pthread_barrier_wait(ptr noundef) #1

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !59 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !62, !DIExpression(), !65)
    #dbg_declare(ptr %3, !66, !DIExpression(), !67)
    #dbg_declare(ptr %4, !68, !DIExpression(), !69)
  %5 = call i32 @pthread_barrier_init(ptr noundef @barrier, ptr noundef null, i32 noundef 2) #3, !dbg !70
  %6 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @worker, ptr noundef null) #3, !dbg !71
  %7 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @worker, ptr noundef null) #3, !dbg !72
  %8 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @worker, ptr noundef null) #3, !dbg !73
  ret i32 0, !dbg !74
}

; Function Attrs: nounwind
declare i32 @pthread_barrier_init(ptr noundef, ptr noundef, i32 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }
attributes #4 = { cold noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!40, !41, !42, !43, !44, !45, !46}
!llvm.ident = !{!47}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "barrier", scope: !2, file: !3, line: 7, type: !30, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_barrier_excess.c", directory: "/tmp/ll", checksumkind: CSK_MD5, checksum: "3f3e199073fad1bd3e99ed47fcb72f43")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!7, !13, !18, !0, !24}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 264, elements: !11)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = !{!12}
!12 = !DISubrange(count: 33)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 200, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 25)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 13, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 168, elements: !22)
!21 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!22 = !{!23}
!23 = !DISubrange(count: 21)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "passed", scope: !2, file: !3, line: 8, type: !26, isLocal: false, isDefinition: true)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !27, line: 104, baseType: !28)
!27 = !DIFile(filename: "/usr/lib/llvm-21/lib/clang/21/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "f17199a988fe91afffaf0f943ef87096")
!28 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !29)
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_barrier_t", file: !31, line: 112, baseType: !32)
!31 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "cbf5435bd7bfed052b1a09633f314dde")
!32 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !31, line: 108, size: 256, elements: !33)
!33 = !{!34, !38}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !32, file: !31, line: 110, baseType: !35, size: 256)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 256, elements: !36)
!36 = !{!37}
!37 = !DISubrange(count: 32)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !32, file: !31, line: 111, baseType: !39, size: 64)
!39 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!40 = !{i32 7, !"Dwarf Version", i32 5}
!41 = !{i32 2, !"Debug Info Version", i32 3}
!42 = !{i32 1, !"wchar_size", i32 4}
!43 = !{i32 8, !"PIC Level", i32 2}
!44 = !{i32 7, !"PIE Level", i32 2}
!45 = !{i32 7, !"uwtable", i32 2}
!46 = !{i32 7, !"frame-pointer", i32 2}
!47 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!48 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 10, type: !49, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!49 = !DISubroutineType(types: !50)
!50 = !{!5, !5}
!51 = !{}
!52 = !DILocalVariable(name: "arg", arg: 1, scope: !48, file: !3, line: 10, type: !5)
!53 = !DILocation(line: 10, column: 20, scope: !48)
!54 = !DILocation(line: 12, column: 5, scope: !48)
!55 = !DILocation(line: 13, column: 5, scope: !56)
!56 = distinct !DILexicalBlock(scope: !57, file: !3, line: 13, column: 5)
!57 = distinct !DILexicalBlock(scope: !48, file: !3, line: 13, column: 5)
!58 = !DILocation(line: 14, column: 5, scope: !48)
!59 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 17, type: !60, scopeLine: 18, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!60 = !DISubroutineType(types: !61)
!61 = !{!29}
!62 = !DILocalVariable(name: "t0", scope: !59, file: !3, line: 19, type: !63)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !31, line: 27, baseType: !64)
!64 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!65 = !DILocation(line: 19, column: 15, scope: !59)
!66 = !DILocalVariable(name: "t1", scope: !59, file: !3, line: 19, type: !63)
!67 = !DILocation(line: 19, column: 19, scope: !59)
!68 = !DILocalVariable(name: "t2", scope: !59, file: !3, line: 19, type: !63)
!69 = !DILocation(line: 19, column: 23, scope: !59)
!70 = !DILocation(line: 20, column: 5, scope: !59)
!71 = !DILocation(line: 21, column: 5, scope: !59)
!72 = !DILocation(line: 22, column: 5, scope: !59)
!73 = !DILocation(line: 23, column: 5, scope: !59)
!74 = !DILocation(line: 24, column: 5, scope: !59)
