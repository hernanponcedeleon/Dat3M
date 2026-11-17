; ModuleID = 'pthread_barrier.c'
source_filename = "pthread_barrier.c"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-w64-windows-gnu"

%struct.anon = type { ptr, i32 }

@s = dso_local global { ptr, i32, [4 x i8] } { ptr null, i32 42, [4 x i8] zeroinitializer }, align 8, !dbg !0
@.str = private unnamed_addr constant [55 x i8] c"status == 0 || status == PTHREAD_BARRIER_SERIAL_THREAD\00", align 1, !dbg !11
@.str.1 = private unnamed_addr constant [18 x i8] c"pthread_barrier.c\00", align 1, !dbg !17
@serial = dso_local global i32 0, align 4, !dbg !59
@data = dso_local global [3 x i32] zeroinitializer, align 4, !dbg !54
@.str.2 = private unnamed_addr constant [49 x i8] c"data[(i + 1) % 3] == 1 && data[(i + 2) % 3] == 1\00", align 1, !dbg !22
@.str.3 = private unnamed_addr constant [49 x i8] c"data[(i + 1) % 3] == 2 && data[(i + 2) % 3] == 2\00", align 1, !dbg !27
@.str.4 = private unnamed_addr constant [52 x i8] c"pthread_barrier_init(&s.barrier, NULL, 0) == EINVAL\00", align 1, !dbg !29
@.str.5 = private unnamed_addr constant [47 x i8] c"pthread_barrier_init(&s.barrier, NULL, 3) == 0\00", align 1, !dbg !34
@.str.6 = private unnamed_addr constant [14 x i8] c"s.guard == 42\00", align 1, !dbg !39
@.str.7 = private unnamed_addr constant [12 x i8] c"serial == 3\00", align 1, !dbg !44
@.str.8 = private unnamed_addr constant [41 x i8] c"pthread_barrier_destroy(&s.barrier) == 0\00", align 1, !dbg !49

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @wait_barrier() #0 !dbg !77 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
    #dbg_declare(ptr %1, !81, !DIExpression(), !82)
  %4 = call i32 @pthread_barrier_wait(ptr noundef @s), !dbg !83
  store i32 %4, ptr %1, align 4, !dbg !82
  %5 = load i32, ptr %1, align 4, !dbg !84
  %6 = icmp eq i32 %5, 0, !dbg !84
  br i1 %6, label %12, label %7, !dbg !84

7:                                                ; preds = %0
  %8 = load i32, ptr %1, align 4, !dbg !84
  %9 = icmp eq i32 %8, 1, !dbg !84
  br i1 %9, label %12, label %10, !dbg !84

10:                                               ; preds = %7
  call void @_assert(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 18) #3, !dbg !84
  unreachable, !dbg !84

11:                                               ; No predecessors!
  br label %12, !dbg !84

12:                                               ; preds = %11, %7, %0
  %13 = phi i1 [ true, %7 ], [ true, %0 ], [ false, %11 ]
  %14 = zext i1 %13 to i32, !dbg !84
  %15 = load i32, ptr %1, align 4, !dbg !85
  %16 = icmp eq i32 %15, 1, !dbg !87
  br i1 %16, label %17, label %21, !dbg !87

17:                                               ; preds = %12
  store i32 1, ptr %2, align 4, !dbg !88
  %18 = load i32, ptr %2, align 4, !dbg !88
  %19 = atomicrmw add ptr @serial, i32 %18 seq_cst, align 4, !dbg !88
  store i32 %19, ptr %3, align 4, !dbg !88
  %20 = load i32, ptr %3, align 4, !dbg !88
  br label %21, !dbg !90

21:                                               ; preds = %17, %12
  ret void, !dbg !91
}

declare dso_local i32 @pthread_barrier_wait(ptr noundef) #1

; Function Attrs: noreturn
declare dllimport void @_assert(ptr noundef, ptr noundef, i32 noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !92 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !95, !DIExpression(), !96)
    #dbg_declare(ptr %3, !97, !DIExpression(), !98)
  %4 = load ptr, ptr %2, align 8, !dbg !99
  %5 = ptrtoint ptr %4 to i64, !dbg !100
  %6 = trunc i64 %5 to i32, !dbg !101
  store i32 %6, ptr %3, align 4, !dbg !98
  %7 = load i32, ptr %3, align 4, !dbg !102
  %8 = sext i32 %7 to i64, !dbg !103
  %9 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %8, !dbg !103
  store i32 1, ptr %9, align 4, !dbg !104
  call void @wait_barrier(), !dbg !105
  %10 = load i32, ptr %3, align 4, !dbg !106
  %11 = add nsw i32 %10, 1, !dbg !106
  %12 = srem i32 %11, 3, !dbg !106
  %13 = sext i32 %12 to i64, !dbg !106
  %14 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %13, !dbg !106
  %15 = load i32, ptr %14, align 4, !dbg !106
  %16 = icmp eq i32 %15, 1, !dbg !106
  br i1 %16, label %17, label %25, !dbg !106

17:                                               ; preds = %1
  %18 = load i32, ptr %3, align 4, !dbg !106
  %19 = add nsw i32 %18, 2, !dbg !106
  %20 = srem i32 %19, 3, !dbg !106
  %21 = sext i32 %20 to i64, !dbg !106
  %22 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %21, !dbg !106
  %23 = load i32, ptr %22, align 4, !dbg !106
  %24 = icmp eq i32 %23, 1, !dbg !106
  br i1 %24, label %27, label %25, !dbg !106

25:                                               ; preds = %17, %1
  call void @_assert(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 29) #3, !dbg !106
  unreachable, !dbg !106

26:                                               ; No predecessors!
  br label %27, !dbg !106

27:                                               ; preds = %26, %17
  %28 = phi i1 [ true, %17 ], [ false, %26 ]
  %29 = zext i1 %28 to i32, !dbg !106
  call void @wait_barrier(), !dbg !107
  %30 = load i32, ptr %3, align 4, !dbg !108
  %31 = sext i32 %30 to i64, !dbg !109
  %32 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %31, !dbg !109
  store i32 2, ptr %32, align 4, !dbg !110
  call void @wait_barrier(), !dbg !111
  %33 = load i32, ptr %3, align 4, !dbg !112
  %34 = add nsw i32 %33, 1, !dbg !112
  %35 = srem i32 %34, 3, !dbg !112
  %36 = sext i32 %35 to i64, !dbg !112
  %37 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %36, !dbg !112
  %38 = load i32, ptr %37, align 4, !dbg !112
  %39 = icmp eq i32 %38, 2, !dbg !112
  br i1 %39, label %40, label %48, !dbg !112

40:                                               ; preds = %27
  %41 = load i32, ptr %3, align 4, !dbg !112
  %42 = add nsw i32 %41, 2, !dbg !112
  %43 = srem i32 %42, 3, !dbg !112
  %44 = sext i32 %43 to i64, !dbg !112
  %45 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %44, !dbg !112
  %46 = load i32, ptr %45, align 4, !dbg !112
  %47 = icmp eq i32 %46, 2, !dbg !112
  br i1 %47, label %50, label %48, !dbg !112

48:                                               ; preds = %40, %27
  call void @_assert(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 33) #3, !dbg !112
  unreachable, !dbg !112

49:                                               ; No predecessors!
  br label %50, !dbg !112

50:                                               ; preds = %49, %40
  %51 = phi i1 [ true, %40 ], [ false, %49 ]
  %52 = zext i1 %51 to i32, !dbg !112
  ret ptr null, !dbg !113
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !114 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !117, !DIExpression(), !121)
    #dbg_declare(ptr %3, !122, !DIExpression(), !123)
    #dbg_declare(ptr %4, !124, !DIExpression(), !125)
  %5 = call i32 @pthread_barrier_init(ptr noundef @s, ptr noundef null, i32 noundef 0), !dbg !126
  %6 = icmp eq i32 %5, 22, !dbg !126
  br i1 %6, label %9, label %7, !dbg !126

7:                                                ; preds = %0
  call void @_assert(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 40) #3, !dbg !126
  unreachable, !dbg !126

8:                                                ; No predecessors!
  br label %9, !dbg !126

9:                                                ; preds = %8, %0
  %10 = phi i1 [ true, %0 ], [ false, %8 ]
  %11 = zext i1 %10 to i32, !dbg !126
  %12 = call i32 @pthread_barrier_init(ptr noundef @s, ptr noundef null, i32 noundef 3), !dbg !127
  %13 = icmp eq i32 %12, 0, !dbg !127
  br i1 %13, label %16, label %14, !dbg !127

14:                                               ; preds = %9
  call void @_assert(ptr noundef @.str.5, ptr noundef @.str.1, i32 noundef 44) #3, !dbg !127
  unreachable, !dbg !127

15:                                               ; No predecessors!
  br label %16, !dbg !127

16:                                               ; preds = %15, %9
  %17 = phi i1 [ true, %9 ], [ false, %15 ]
  %18 = zext i1 %17 to i32, !dbg !127
  %19 = load i32, ptr getelementptr inbounds nuw (%struct.anon, ptr @s, i32 0, i32 1), align 8, !dbg !128
  %20 = icmp eq i32 %19, 42, !dbg !128
  br i1 %20, label %23, label %21, !dbg !128

21:                                               ; preds = %16
  call void @_assert(ptr noundef @.str.6, ptr noundef @.str.1, i32 noundef 45) #3, !dbg !128
  unreachable, !dbg !128

22:                                               ; No predecessors!
  br label %23, !dbg !128

23:                                               ; preds = %22, %16
  %24 = phi i1 [ true, %16 ], [ false, %22 ]
  %25 = zext i1 %24 to i32, !dbg !128
  %26 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @worker, ptr noundef null), !dbg !129
  %27 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @worker, ptr noundef inttoptr (i64 1 to ptr)), !dbg !130
  %28 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @worker, ptr noundef inttoptr (i64 2 to ptr)), !dbg !131
  %29 = load i64, ptr %2, align 8, !dbg !132
  %30 = call i32 @pthread_join(i64 noundef %29, ptr noundef null), !dbg !133
  %31 = load i64, ptr %3, align 8, !dbg !134
  %32 = call i32 @pthread_join(i64 noundef %31, ptr noundef null), !dbg !135
  %33 = load i64, ptr %4, align 8, !dbg !136
  %34 = call i32 @pthread_join(i64 noundef %33, ptr noundef null), !dbg !137
  %35 = load atomic i32, ptr @serial seq_cst, align 4, !dbg !138
  %36 = icmp eq i32 %35, 3, !dbg !138
  br i1 %36, label %39, label %37, !dbg !138

37:                                               ; preds = %23
  call void @_assert(ptr noundef @.str.7, ptr noundef @.str.1, i32 noundef 52) #3, !dbg !138
  unreachable, !dbg !138

38:                                               ; No predecessors!
  br label %39, !dbg !138

39:                                               ; preds = %38, %23
  %40 = phi i1 [ true, %23 ], [ false, %38 ]
  %41 = zext i1 %40 to i32, !dbg !138
  %42 = call i32 @pthread_barrier_destroy(ptr noundef @s), !dbg !139
  %43 = icmp eq i32 %42, 0, !dbg !139
  br i1 %43, label %46, label %44, !dbg !139

44:                                               ; preds = %39
  call void @_assert(ptr noundef @.str.8, ptr noundef @.str.1, i32 noundef 53) #3, !dbg !139
  unreachable, !dbg !139

45:                                               ; No predecessors!
  br label %46, !dbg !139

46:                                               ; preds = %45, %39
  %47 = phi i1 [ true, %39 ], [ false, %45 ]
  %48 = zext i1 %47 to i32, !dbg !139
  ret i32 0, !dbg !140
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
!llvm.module.flags = !{!70, !71, !72, !73, !74, !75}
!llvm.ident = !{!76}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 11, type: !64, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !10, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_barrier.c", directory: "/tmp/ll")
!4 = !{!5, !6, !9}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !7, line: 62, baseType: !8)
!7 = !DIFile(filename: "/usr/x86_64-w64-mingw32/include/corecrt.h", directory: "")
!8 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!10 = !{!0, !11, !17, !22, !27, !29, !34, !39, !44, !49, !54, !59}
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(scope: null, file: !3, line: 18, type: !13, isLocal: true, isDefinition: true)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 440, elements: !15)
!14 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!15 = !{!16}
!16 = !DISubrange(count: 55)
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(scope: null, file: !3, line: 18, type: !19, isLocal: true, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 144, elements: !20)
!20 = !{!21}
!21 = !DISubrange(count: 18)
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(scope: null, file: !3, line: 29, type: !24, isLocal: true, isDefinition: true)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 392, elements: !25)
!25 = !{!26}
!26 = !DISubrange(count: 49)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(scope: null, file: !3, line: 33, type: !24, isLocal: true, isDefinition: true)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 40, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 416, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 52)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !3, line: 44, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 376, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: 47)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(scope: null, file: !3, line: 45, type: !41, isLocal: true, isDefinition: true)
!41 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 112, elements: !42)
!42 = !{!43}
!43 = !DISubrange(count: 14)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(scope: null, file: !3, line: 52, type: !46, isLocal: true, isDefinition: true)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 96, elements: !47)
!47 = !{!48}
!48 = !DISubrange(count: 12)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(scope: null, file: !3, line: 53, type: !51, isLocal: true, isDefinition: true)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 328, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 41)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !3, line: 12, type: !56, isLocal: false, isDefinition: true)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 96, elements: !57)
!57 = !{!58}
!58 = !DISubrange(count: 3)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "serial", scope: !2, file: !3, line: 13, type: !61, isLocal: false, isDefinition: true)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !62, line: 104, baseType: !63)
!62 = !DIFile(filename: "/usr/lib/llvm-21/lib/clang/21/include/stdatomic.h", directory: "")
!63 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !5)
!64 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 11, size: 128, elements: !65)
!65 = !{!66, !69}
!66 = !DIDerivedType(tag: DW_TAG_member, name: "barrier", scope: !64, file: !3, line: 11, baseType: !67, size: 64)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_barrier_t", file: !68, line: 233, baseType: !9)
!68 = !DIFile(filename: "/usr/x86_64-w64-mingw32/include/pthread.h", directory: "")
!69 = !DIDerivedType(tag: DW_TAG_member, name: "guard", scope: !64, file: !3, line: 11, baseType: !5, size: 32, offset: 64)
!70 = !{i32 7, !"Dwarf Version", i32 4}
!71 = !{i32 2, !"Debug Info Version", i32 3}
!72 = !{i32 1, !"wchar_size", i32 2}
!73 = !{i32 8, !"PIC Level", i32 2}
!74 = !{i32 7, !"uwtable", i32 2}
!75 = !{i32 1, !"MaxTLSAlign", i32 65536}
!76 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!77 = distinct !DISubprogram(name: "wait_barrier", scope: !3, file: !3, line: 15, type: !78, scopeLine: 16, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !80)
!78 = !DISubroutineType(types: !79)
!79 = !{null}
!80 = !{}
!81 = !DILocalVariable(name: "status", scope: !77, file: !3, line: 17, type: !5)
!82 = !DILocation(line: 17, column: 9, scope: !77)
!83 = !DILocation(line: 17, column: 18, scope: !77)
!84 = !DILocation(line: 18, column: 5, scope: !77)
!85 = !DILocation(line: 19, column: 9, scope: !86)
!86 = distinct !DILexicalBlock(scope: !77, file: !3, line: 19, column: 9)
!87 = !DILocation(line: 19, column: 16, scope: !86)
!88 = !DILocation(line: 20, column: 9, scope: !89)
!89 = distinct !DILexicalBlock(scope: !86, file: !3, line: 19, column: 50)
!90 = !DILocation(line: 21, column: 5, scope: !89)
!91 = !DILocation(line: 22, column: 1, scope: !77)
!92 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 24, type: !93, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !80)
!93 = !DISubroutineType(types: !94)
!94 = !{!9, !9}
!95 = !DILocalVariable(name: "arg", arg: 1, scope: !92, file: !3, line: 24, type: !9)
!96 = !DILocation(line: 24, column: 20, scope: !92)
!97 = !DILocalVariable(name: "i", scope: !92, file: !3, line: 26, type: !5)
!98 = !DILocation(line: 26, column: 9, scope: !92)
!99 = !DILocation(line: 26, column: 28, scope: !92)
!100 = !DILocation(line: 26, column: 18, scope: !92)
!101 = !DILocation(line: 26, column: 13, scope: !92)
!102 = !DILocation(line: 27, column: 10, scope: !92)
!103 = !DILocation(line: 27, column: 5, scope: !92)
!104 = !DILocation(line: 27, column: 13, scope: !92)
!105 = !DILocation(line: 28, column: 5, scope: !92)
!106 = !DILocation(line: 29, column: 5, scope: !92)
!107 = !DILocation(line: 30, column: 5, scope: !92)
!108 = !DILocation(line: 31, column: 10, scope: !92)
!109 = !DILocation(line: 31, column: 5, scope: !92)
!110 = !DILocation(line: 31, column: 13, scope: !92)
!111 = !DILocation(line: 32, column: 5, scope: !92)
!112 = !DILocation(line: 33, column: 5, scope: !92)
!113 = !DILocation(line: 34, column: 5, scope: !92)
!114 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 37, type: !115, scopeLine: 38, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !80)
!115 = !DISubroutineType(types: !116)
!116 = !{!5}
!117 = !DILocalVariable(name: "t0", scope: !114, file: !3, line: 39, type: !118)
!118 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !68, line: 176, baseType: !119)
!119 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !7, line: 75, baseType: !120)
!120 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!121 = !DILocation(line: 39, column: 15, scope: !114)
!122 = !DILocalVariable(name: "t1", scope: !114, file: !3, line: 39, type: !118)
!123 = !DILocation(line: 39, column: 19, scope: !114)
!124 = !DILocalVariable(name: "t2", scope: !114, file: !3, line: 39, type: !118)
!125 = !DILocation(line: 39, column: 23, scope: !114)
!126 = !DILocation(line: 40, column: 5, scope: !114)
!127 = !DILocation(line: 44, column: 5, scope: !114)
!128 = !DILocation(line: 45, column: 5, scope: !114)
!129 = !DILocation(line: 46, column: 5, scope: !114)
!130 = !DILocation(line: 47, column: 5, scope: !114)
!131 = !DILocation(line: 48, column: 5, scope: !114)
!132 = !DILocation(line: 49, column: 18, scope: !114)
!133 = !DILocation(line: 49, column: 5, scope: !114)
!134 = !DILocation(line: 50, column: 18, scope: !114)
!135 = !DILocation(line: 50, column: 5, scope: !114)
!136 = !DILocation(line: 51, column: 18, scope: !114)
!137 = !DILocation(line: 51, column: 5, scope: !114)
!138 = !DILocation(line: 52, column: 5, scope: !114)
!139 = !DILocation(line: 53, column: 5, scope: !114)
!140 = !DILocation(line: 54, column: 5, scope: !114)
