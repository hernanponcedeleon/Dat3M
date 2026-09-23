; ModuleID = 'pthread_barrier.c'
source_filename = "pthread_barrier.c"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-w64-windows-gnu"

%struct.anon = type { ptr, i32 }

@s = dso_local global { ptr, i32, [4 x i8] } { ptr null, i32 42, [4 x i8] zeroinitializer }, align 8, !dbg !0
@.str = private unnamed_addr constant [55 x i8] c"status == 0 || status == PTHREAD_BARRIER_SERIAL_THREAD\00", align 1, !dbg !11
@.str.1 = private unnamed_addr constant [18 x i8] c"pthread_barrier.c\00", align 1, !dbg !17
@serial = dso_local global i32 0, align 4, !dbg !54
@data = dso_local global [3 x i32] zeroinitializer, align 4, !dbg !49
@.str.2 = private unnamed_addr constant [49 x i8] c"data[(i + 1) % 3] == 1 && data[(i + 2) % 3] == 1\00", align 1, !dbg !22
@.str.3 = private unnamed_addr constant [49 x i8] c"data[(i + 1) % 3] == 2 && data[(i + 2) % 3] == 2\00", align 1, !dbg !27
@.str.4 = private unnamed_addr constant [47 x i8] c"pthread_barrier_init(&s.barrier, NULL, 3) == 0\00", align 1, !dbg !29
@.str.5 = private unnamed_addr constant [14 x i8] c"s.guard == 42\00", align 1, !dbg !34
@.str.6 = private unnamed_addr constant [12 x i8] c"serial == 3\00", align 1, !dbg !39
@.str.7 = private unnamed_addr constant [41 x i8] c"pthread_barrier_destroy(&s.barrier) == 0\00", align 1, !dbg !44

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @wait_barrier() #0 !dbg !72 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
    #dbg_declare(ptr %1, !76, !DIExpression(), !77)
  %4 = call i32 @pthread_barrier_wait(ptr noundef @s), !dbg !78
  store i32 %4, ptr %1, align 4, !dbg !77
  %5 = load i32, ptr %1, align 4, !dbg !79
  %6 = icmp eq i32 %5, 0, !dbg !79
  br i1 %6, label %12, label %7, !dbg !79

7:                                                ; preds = %0
  %8 = load i32, ptr %1, align 4, !dbg !79
  %9 = icmp eq i32 %8, 1, !dbg !79
  br i1 %9, label %12, label %10, !dbg !79

10:                                               ; preds = %7
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 16) #3, !dbg !79
  unreachable, !dbg !79

11:                                               ; No predecessors!
  br label %12, !dbg !79

12:                                               ; preds = %11, %7, %0
  %13 = phi i1 [ true, %7 ], [ true, %0 ], [ false, %11 ]
  %14 = zext i1 %13 to i32, !dbg !79
  %15 = load i32, ptr %1, align 4, !dbg !80
  %16 = icmp eq i32 %15, 1, !dbg !82
  br i1 %16, label %17, label %21, !dbg !82

17:                                               ; preds = %12
  store i32 1, ptr %2, align 4, !dbg !83
  %18 = load i32, ptr %2, align 4, !dbg !83
  %19 = atomicrmw add ptr @serial, i32 %18 seq_cst, align 4, !dbg !83
  store i32 %19, ptr %3, align 4, !dbg !83
  %20 = load i32, ptr %3, align 4, !dbg !83
  br label %21, !dbg !85

21:                                               ; preds = %17, %12
  ret void, !dbg !86
}

declare dso_local i32 @pthread_barrier_wait(ptr noundef) #1

; Function Attrs: noreturn
declare dllimport void @_assert(ptr noundef, ptr noundef, i32 noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !87 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !90, !DIExpression(), !91)
    #dbg_declare(ptr %3, !92, !DIExpression(), !93)
  %4 = load ptr, ptr %2, align 8, !dbg !94
  %5 = ptrtoint ptr %4 to i64, !dbg !95
  %6 = trunc i64 %5 to i32, !dbg !96
  store i32 %6, ptr %3, align 4, !dbg !93
  %7 = load i32, ptr %3, align 4, !dbg !97
  %8 = sext i32 %7 to i64, !dbg !98
  %9 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %8, !dbg !98
  store i32 1, ptr %9, align 4, !dbg !99
  call void @wait_barrier(), !dbg !100
  %10 = load i32, ptr %3, align 4, !dbg !101
  %11 = add nsw i32 %10, 1, !dbg !101
  %12 = srem i32 %11, 3, !dbg !101
  %13 = sext i32 %12 to i64, !dbg !101
  %14 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %13, !dbg !101
  %15 = load i32, ptr %14, align 4, !dbg !101
  %16 = icmp eq i32 %15, 1, !dbg !101
  br i1 %16, label %17, label %25, !dbg !101

17:                                               ; preds = %1
  %18 = load i32, ptr %3, align 4, !dbg !101
  %19 = add nsw i32 %18, 2, !dbg !101
  %20 = srem i32 %19, 3, !dbg !101
  %21 = sext i32 %20 to i64, !dbg !101
  %22 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %21, !dbg !101
  %23 = load i32, ptr %22, align 4, !dbg !101
  %24 = icmp eq i32 %23, 1, !dbg !101
  br i1 %24, label %27, label %25, !dbg !101

25:                                               ; preds = %17, %1
  call void @_assert(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 27) #3, !dbg !101
  unreachable, !dbg !101

26:                                               ; No predecessors!
  br label %27, !dbg !101

27:                                               ; preds = %26, %17
  %28 = phi i1 [ true, %17 ], [ false, %26 ]
  %29 = zext i1 %28 to i32, !dbg !101
  call void @wait_barrier(), !dbg !102
  %30 = load i32, ptr %3, align 4, !dbg !103
  %31 = sext i32 %30 to i64, !dbg !104
  %32 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %31, !dbg !104
  store i32 2, ptr %32, align 4, !dbg !105
  call void @wait_barrier(), !dbg !106
  %33 = load i32, ptr %3, align 4, !dbg !107
  %34 = add nsw i32 %33, 1, !dbg !107
  %35 = srem i32 %34, 3, !dbg !107
  %36 = sext i32 %35 to i64, !dbg !107
  %37 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %36, !dbg !107
  %38 = load i32, ptr %37, align 4, !dbg !107
  %39 = icmp eq i32 %38, 2, !dbg !107
  br i1 %39, label %40, label %48, !dbg !107

40:                                               ; preds = %27
  %41 = load i32, ptr %3, align 4, !dbg !107
  %42 = add nsw i32 %41, 2, !dbg !107
  %43 = srem i32 %42, 3, !dbg !107
  %44 = sext i32 %43 to i64, !dbg !107
  %45 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %44, !dbg !107
  %46 = load i32, ptr %45, align 4, !dbg !107
  %47 = icmp eq i32 %46, 2, !dbg !107
  br i1 %47, label %50, label %48, !dbg !107

48:                                               ; preds = %40, %27
  call void @_assert(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 31) #3, !dbg !107
  unreachable, !dbg !107

49:                                               ; No predecessors!
  br label %50, !dbg !107

50:                                               ; preds = %49, %40
  %51 = phi i1 [ true, %40 ], [ false, %49 ]
  %52 = zext i1 %51 to i32, !dbg !107
  ret ptr null, !dbg !108
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !109 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !112, !DIExpression(), !116)
    #dbg_declare(ptr %3, !117, !DIExpression(), !118)
    #dbg_declare(ptr %4, !119, !DIExpression(), !120)
  %5 = call i32 @pthread_barrier_init(ptr noundef @s, ptr noundef null, i32 noundef 3), !dbg !121
  %6 = icmp eq i32 %5, 0, !dbg !121
  br i1 %6, label %9, label %7, !dbg !121

7:                                                ; preds = %0
  call void @_assert(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 38) #3, !dbg !121
  unreachable, !dbg !121

8:                                                ; No predecessors!
  br label %9, !dbg !121

9:                                                ; preds = %8, %0
  %10 = phi i1 [ true, %0 ], [ false, %8 ]
  %11 = zext i1 %10 to i32, !dbg !121
  %12 = load i32, ptr getelementptr inbounds nuw (%struct.anon, ptr @s, i32 0, i32 1), align 8, !dbg !122
  %13 = icmp eq i32 %12, 42, !dbg !122
  br i1 %13, label %16, label %14, !dbg !122

14:                                               ; preds = %9
  call void @_assert(ptr noundef @.str.5, ptr noundef @.str.1, i32 noundef 39) #3, !dbg !122
  unreachable, !dbg !122

15:                                               ; No predecessors!
  br label %16, !dbg !122

16:                                               ; preds = %15, %9
  %17 = phi i1 [ true, %9 ], [ false, %15 ]
  %18 = zext i1 %17 to i32, !dbg !122
  %19 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @worker, ptr noundef null), !dbg !123
  %20 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @worker, ptr noundef inttoptr (i64 1 to ptr)), !dbg !124
  %21 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @worker, ptr noundef inttoptr (i64 2 to ptr)), !dbg !125
  %22 = load i64, ptr %2, align 8, !dbg !126
  %23 = call i32 @pthread_join(i64 noundef %22, ptr noundef null), !dbg !127
  %24 = load i64, ptr %3, align 8, !dbg !128
  %25 = call i32 @pthread_join(i64 noundef %24, ptr noundef null), !dbg !129
  %26 = load i64, ptr %4, align 8, !dbg !130
  %27 = call i32 @pthread_join(i64 noundef %26, ptr noundef null), !dbg !131
  %28 = load atomic i32, ptr @serial seq_cst, align 4, !dbg !132
  %29 = icmp eq i32 %28, 3, !dbg !132
  br i1 %29, label %32, label %30, !dbg !132

30:                                               ; preds = %16
  call void @_assert(ptr noundef @.str.6, ptr noundef @.str.1, i32 noundef 46) #3, !dbg !132
  unreachable, !dbg !132

31:                                               ; No predecessors!
  br label %32, !dbg !132

32:                                               ; preds = %31, %16
  %33 = phi i1 [ true, %16 ], [ false, %31 ]
  %34 = zext i1 %33 to i32, !dbg !132
  %35 = call i32 @pthread_barrier_destroy(ptr noundef @s), !dbg !133
  %36 = icmp eq i32 %35, 0, !dbg !133
  br i1 %36, label %39, label %37, !dbg !133

37:                                               ; preds = %32
  call void @_assert(ptr noundef @.str.7, ptr noundef @.str.1, i32 noundef 47) #3, !dbg !133
  unreachable, !dbg !133

38:                                               ; No predecessors!
  br label %39, !dbg !133

39:                                               ; preds = %38, %32
  %40 = phi i1 [ true, %32 ], [ false, %38 ]
  %41 = zext i1 %40 to i32, !dbg !133
  ret i32 0, !dbg !134
}

declare dso_local i32 @pthread_barrier_init(ptr noundef, ptr noundef, i32 noundef) #1

declare dso_local i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare dso_local i32 @pthread_join(i64 noundef, ptr noundef) #1

declare dso_local i32 @pthread_barrier_destroy(ptr noundef) #1

attributes #0 = { noinline nounwind optnone uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noreturn "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!65, !66, !67, !68, !69, !70}
!llvm.ident = !{!71}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 9, type: !59, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !10, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_barrier.c", directory: "/tmp/ll")
!4 = !{!5, !6, !9}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !7, line: 62, baseType: !8)
!7 = !DIFile(filename: "/usr/x86_64-w64-mingw32/include/corecrt.h", directory: "")
!8 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!10 = !{!0, !11, !17, !22, !27, !29, !34, !39, !44, !49, !54}
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(scope: null, file: !3, line: 16, type: !13, isLocal: true, isDefinition: true)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 440, elements: !15)
!14 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!15 = !{!16}
!16 = !DISubrange(count: 55)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(scope: null, file: !3, line: 16, type: !19, isLocal: true, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 144, elements: !20)
!20 = !{!21}
!21 = !DISubrange(count: 18)
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(scope: null, file: !3, line: 27, type: !24, isLocal: true, isDefinition: true)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 392, elements: !25)
!25 = !{!26}
!26 = !DISubrange(count: 49)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(scope: null, file: !3, line: 31, type: !24, isLocal: true, isDefinition: true)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 38, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 376, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 47)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 112, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: 14)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(scope: null, file: !3, line: 46, type: !41, isLocal: true, isDefinition: true)
!41 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 96, elements: !42)
!42 = !{!43}
!43 = !DISubrange(count: 12)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(scope: null, file: !3, line: 47, type: !46, isLocal: true, isDefinition: true)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 328, elements: !47)
!47 = !{!48}
!48 = !DISubrange(count: 41)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !3, line: 10, type: !51, isLocal: false, isDefinition: true)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 96, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 3)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "serial", scope: !2, file: !3, line: 11, type: !56, isLocal: false, isDefinition: true)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !57, line: 104, baseType: !58)
!57 = !DIFile(filename: "/usr/lib/llvm-21/lib/clang/21/include/stdatomic.h", directory: "")
!58 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !5)
!59 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 9, size: 128, elements: !60)
!60 = !{!61, !64}
!61 = !DIDerivedType(tag: DW_TAG_member, name: "barrier", scope: !59, file: !3, line: 9, baseType: !62, size: 64)
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_barrier_t", file: !63, line: 233, baseType: !9)
!63 = !DIFile(filename: "/usr/x86_64-w64-mingw32/include/pthread.h", directory: "")
!64 = !DIDerivedType(tag: DW_TAG_member, name: "guard", scope: !59, file: !3, line: 9, baseType: !5, size: 32, offset: 64)
!65 = !{i32 7, !"Dwarf Version", i32 4}
!66 = !{i32 2, !"Debug Info Version", i32 3}
!67 = !{i32 1, !"wchar_size", i32 2}
!68 = !{i32 8, !"PIC Level", i32 2}
!69 = !{i32 7, !"uwtable", i32 2}
!70 = !{i32 1, !"MaxTLSAlign", i32 65536}
!71 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!72 = distinct !DISubprogram(name: "wait_barrier", scope: !3, file: !3, line: 13, type: !73, scopeLine: 14, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!73 = !DISubroutineType(types: !74)
!74 = !{null}
!75 = !{}
!76 = !DILocalVariable(name: "status", scope: !72, file: !3, line: 15, type: !5)
!77 = !DILocation(line: 15, column: 9, scope: !72)
!78 = !DILocation(line: 15, column: 18, scope: !72)
!79 = !DILocation(line: 16, column: 5, scope: !72)
!80 = !DILocation(line: 17, column: 9, scope: !81)
!81 = distinct !DILexicalBlock(scope: !72, file: !3, line: 17, column: 9)
!82 = !DILocation(line: 17, column: 16, scope: !81)
!83 = !DILocation(line: 18, column: 9, scope: !84)
!84 = distinct !DILexicalBlock(scope: !81, file: !3, line: 17, column: 50)
!85 = !DILocation(line: 19, column: 5, scope: !84)
!86 = !DILocation(line: 20, column: 1, scope: !72)
!87 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 22, type: !88, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!88 = !DISubroutineType(types: !89)
!89 = !{!9, !9}
!90 = !DILocalVariable(name: "arg", arg: 1, scope: !87, file: !3, line: 22, type: !9)
!91 = !DILocation(line: 22, column: 20, scope: !87)
!92 = !DILocalVariable(name: "i", scope: !87, file: !3, line: 24, type: !5)
!93 = !DILocation(line: 24, column: 9, scope: !87)
!94 = !DILocation(line: 24, column: 28, scope: !87)
!95 = !DILocation(line: 24, column: 18, scope: !87)
!96 = !DILocation(line: 24, column: 13, scope: !87)
!97 = !DILocation(line: 25, column: 10, scope: !87)
!98 = !DILocation(line: 25, column: 5, scope: !87)
!99 = !DILocation(line: 25, column: 13, scope: !87)
!100 = !DILocation(line: 26, column: 5, scope: !87)
!101 = !DILocation(line: 27, column: 5, scope: !87)
!102 = !DILocation(line: 28, column: 5, scope: !87)
!103 = !DILocation(line: 29, column: 10, scope: !87)
!104 = !DILocation(line: 29, column: 5, scope: !87)
!105 = !DILocation(line: 29, column: 13, scope: !87)
!106 = !DILocation(line: 30, column: 5, scope: !87)
!107 = !DILocation(line: 31, column: 5, scope: !87)
!108 = !DILocation(line: 32, column: 5, scope: !87)
!109 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 35, type: !110, scopeLine: 36, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !75)
!110 = !DISubroutineType(types: !111)
!111 = !{!5}
!112 = !DILocalVariable(name: "t0", scope: !109, file: !3, line: 37, type: !113)
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !63, line: 176, baseType: !114)
!114 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !7, line: 75, baseType: !115)
!115 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!116 = !DILocation(line: 37, column: 15, scope: !109)
!117 = !DILocalVariable(name: "t1", scope: !109, file: !3, line: 37, type: !113)
!118 = !DILocation(line: 37, column: 19, scope: !109)
!119 = !DILocalVariable(name: "t2", scope: !109, file: !3, line: 37, type: !113)
!120 = !DILocation(line: 37, column: 23, scope: !109)
!121 = !DILocation(line: 38, column: 5, scope: !109)
!122 = !DILocation(line: 39, column: 5, scope: !109)
!123 = !DILocation(line: 40, column: 5, scope: !109)
!124 = !DILocation(line: 41, column: 5, scope: !109)
!125 = !DILocation(line: 42, column: 5, scope: !109)
!126 = !DILocation(line: 43, column: 18, scope: !109)
!127 = !DILocation(line: 43, column: 5, scope: !109)
!128 = !DILocation(line: 44, column: 18, scope: !109)
!129 = !DILocation(line: 44, column: 5, scope: !109)
!130 = !DILocation(line: 45, column: 18, scope: !109)
!131 = !DILocation(line: 45, column: 5, scope: !109)
!132 = !DILocation(line: 46, column: 5, scope: !109)
!133 = !DILocation(line: 47, column: 5, scope: !109)
!134 = !DILocation(line: 48, column: 5, scope: !109)
