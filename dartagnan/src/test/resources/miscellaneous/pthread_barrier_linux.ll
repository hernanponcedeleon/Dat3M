; ModuleID = 'pthread_barrier.c'
source_filename = "pthread_barrier.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_barrier_t = type { i64, [24 x i8] }
%struct.anon = type { %union.pthread_barrier_t, i32 }

@s = dso_local global { %union.pthread_barrier_t, i32, [4 x i8] } { %union.pthread_barrier_t zeroinitializer, i32 42, [4 x i8] zeroinitializer }, align 8, !dbg !0
@.str = private unnamed_addr constant [55 x i8] c"status == 0 || status == PTHREAD_BARRIER_SERIAL_THREAD\00", align 1, !dbg !11
@.str.1 = private unnamed_addr constant [18 x i8] c"pthread_barrier.c\00", align 1, !dbg !17
@__PRETTY_FUNCTION__.wait_barrier = private unnamed_addr constant [20 x i8] c"void wait_barrier()\00", align 1, !dbg !22
@serial = dso_local global i32 0, align 4, !dbg !70
@data = dso_local global [3 x i32] zeroinitializer, align 4, !dbg !65
@.str.2 = private unnamed_addr constant [49 x i8] c"data[(i + 1) % 3] == 1 && data[(i + 2) % 3] == 1\00", align 1, !dbg !28
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1, !dbg !33
@.str.3 = private unnamed_addr constant [49 x i8] c"data[(i + 1) % 3] == 2 && data[(i + 2) % 3] == 2\00", align 1, !dbg !38
@.str.4 = private unnamed_addr constant [47 x i8] c"pthread_barrier_init(&s.barrier, NULL, 3) == 0\00", align 1, !dbg !40
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1, !dbg !45
@.str.5 = private unnamed_addr constant [14 x i8] c"s.guard == 42\00", align 1, !dbg !50
@.str.6 = private unnamed_addr constant [12 x i8] c"serial == 3\00", align 1, !dbg !55
@.str.7 = private unnamed_addr constant [41 x i8] c"pthread_barrier_destroy(&s.barrier) == 0\00", align 1, !dbg !60

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @wait_barrier() #0 !dbg !96 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
    #dbg_declare(ptr %1, !100, !DIExpression(), !101)
  %4 = call i32 @pthread_barrier_wait(ptr noundef @s) #4, !dbg !102
  store i32 %4, ptr %1, align 4, !dbg !101
  %5 = load i32, ptr %1, align 4, !dbg !103
  %6 = icmp eq i32 %5, 0, !dbg !103
  br i1 %6, label %10, label %7, !dbg !103

7:                                                ; preds = %0
  %8 = load i32, ptr %1, align 4, !dbg !103
  %9 = icmp eq i32 %8, -1, !dbg !103
  br i1 %9, label %10, label %11, !dbg !103

10:                                               ; preds = %7, %0
  br label %12, !dbg !103

11:                                               ; preds = %7
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 16, ptr noundef @__PRETTY_FUNCTION__.wait_barrier) #5, !dbg !103
  unreachable, !dbg !103

12:                                               ; preds = %10
  %13 = load i32, ptr %1, align 4, !dbg !106
  %14 = icmp eq i32 %13, -1, !dbg !108
  br i1 %14, label %15, label %19, !dbg !108

15:                                               ; preds = %12
  store i32 1, ptr %2, align 4, !dbg !109
  %16 = load i32, ptr %2, align 4, !dbg !109
  %17 = atomicrmw add ptr @serial, i32 %16 seq_cst, align 4, !dbg !109
  store i32 %17, ptr %3, align 4, !dbg !109
  %18 = load i32, ptr %3, align 4, !dbg !109
  br label %19, !dbg !111

19:                                               ; preds = %15, %12
  ret void, !dbg !112
}

; Function Attrs: nounwind
declare i32 @pthread_barrier_wait(ptr noundef) #1

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !113 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !116, !DIExpression(), !117)
    #dbg_declare(ptr %3, !118, !DIExpression(), !119)
  %4 = load ptr, ptr %2, align 8, !dbg !120
  %5 = ptrtoint ptr %4 to i64, !dbg !121
  %6 = trunc i64 %5 to i32, !dbg !122
  store i32 %6, ptr %3, align 4, !dbg !119
  %7 = load i32, ptr %3, align 4, !dbg !123
  %8 = sext i32 %7 to i64, !dbg !124
  %9 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %8, !dbg !124
  store i32 1, ptr %9, align 4, !dbg !125
  call void @wait_barrier(), !dbg !126
  %10 = load i32, ptr %3, align 4, !dbg !127
  %11 = add nsw i32 %10, 1, !dbg !127
  %12 = srem i32 %11, 3, !dbg !127
  %13 = sext i32 %12 to i64, !dbg !127
  %14 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %13, !dbg !127
  %15 = load i32, ptr %14, align 4, !dbg !127
  %16 = icmp eq i32 %15, 1, !dbg !127
  br i1 %16, label %17, label %26, !dbg !127

17:                                               ; preds = %1
  %18 = load i32, ptr %3, align 4, !dbg !127
  %19 = add nsw i32 %18, 2, !dbg !127
  %20 = srem i32 %19, 3, !dbg !127
  %21 = sext i32 %20 to i64, !dbg !127
  %22 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %21, !dbg !127
  %23 = load i32, ptr %22, align 4, !dbg !127
  %24 = icmp eq i32 %23, 1, !dbg !127
  br i1 %24, label %25, label %26, !dbg !127

25:                                               ; preds = %17
  br label %27, !dbg !127

26:                                               ; preds = %17, %1
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 27, ptr noundef @__PRETTY_FUNCTION__.worker) #5, !dbg !127
  unreachable, !dbg !127

27:                                               ; preds = %25
  call void @wait_barrier(), !dbg !130
  %28 = load i32, ptr %3, align 4, !dbg !131
  %29 = sext i32 %28 to i64, !dbg !132
  %30 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %29, !dbg !132
  store i32 2, ptr %30, align 4, !dbg !133
  call void @wait_barrier(), !dbg !134
  %31 = load i32, ptr %3, align 4, !dbg !135
  %32 = add nsw i32 %31, 1, !dbg !135
  %33 = srem i32 %32, 3, !dbg !135
  %34 = sext i32 %33 to i64, !dbg !135
  %35 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %34, !dbg !135
  %36 = load i32, ptr %35, align 4, !dbg !135
  %37 = icmp eq i32 %36, 2, !dbg !135
  br i1 %37, label %38, label %47, !dbg !135

38:                                               ; preds = %27
  %39 = load i32, ptr %3, align 4, !dbg !135
  %40 = add nsw i32 %39, 2, !dbg !135
  %41 = srem i32 %40, 3, !dbg !135
  %42 = sext i32 %41 to i64, !dbg !135
  %43 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %42, !dbg !135
  %44 = load i32, ptr %43, align 4, !dbg !135
  %45 = icmp eq i32 %44, 2, !dbg !135
  br i1 %45, label %46, label %47, !dbg !135

46:                                               ; preds = %38
  br label %48, !dbg !135

47:                                               ; preds = %38, %27
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 31, ptr noundef @__PRETTY_FUNCTION__.worker) #5, !dbg !135
  unreachable, !dbg !135

48:                                               ; preds = %46
  ret ptr null, !dbg !138
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !139 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !142, !DIExpression(), !145)
    #dbg_declare(ptr %3, !146, !DIExpression(), !147)
    #dbg_declare(ptr %4, !148, !DIExpression(), !149)
  %5 = call i32 @pthread_barrier_init(ptr noundef @s, ptr noundef null, i32 noundef 3) #4, !dbg !150
  %6 = icmp eq i32 %5, 0, !dbg !150
  br i1 %6, label %7, label %8, !dbg !150

7:                                                ; preds = %0
  br label %9, !dbg !150

8:                                                ; preds = %0
  call void @__assert_fail(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 38, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !150
  unreachable, !dbg !150

9:                                                ; preds = %7
  %10 = load i32, ptr getelementptr inbounds nuw (%struct.anon, ptr @s, i32 0, i32 1), align 8, !dbg !153
  %11 = icmp eq i32 %10, 42, !dbg !153
  br i1 %11, label %12, label %13, !dbg !153

12:                                               ; preds = %9
  br label %14, !dbg !153

13:                                               ; preds = %9
  call void @__assert_fail(ptr noundef @.str.5, ptr noundef @.str.1, i32 noundef 39, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !153
  unreachable, !dbg !153

14:                                               ; preds = %12
  %15 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @worker, ptr noundef null) #4, !dbg !156
  %16 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @worker, ptr noundef inttoptr (i64 1 to ptr)) #4, !dbg !157
  %17 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @worker, ptr noundef inttoptr (i64 2 to ptr)) #4, !dbg !158
  %18 = load i64, ptr %2, align 8, !dbg !159
  %19 = call i32 @pthread_join(i64 noundef %18, ptr noundef null), !dbg !160
  %20 = load i64, ptr %3, align 8, !dbg !161
  %21 = call i32 @pthread_join(i64 noundef %20, ptr noundef null), !dbg !162
  %22 = load i64, ptr %4, align 8, !dbg !163
  %23 = call i32 @pthread_join(i64 noundef %22, ptr noundef null), !dbg !164
  %24 = load atomic i32, ptr @serial seq_cst, align 4, !dbg !165
  %25 = icmp eq i32 %24, 3, !dbg !165
  br i1 %25, label %26, label %27, !dbg !165

26:                                               ; preds = %14
  br label %28, !dbg !165

27:                                               ; preds = %14
  call void @__assert_fail(ptr noundef @.str.6, ptr noundef @.str.1, i32 noundef 46, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !165
  unreachable, !dbg !165

28:                                               ; preds = %26
  %29 = call i32 @pthread_barrier_destroy(ptr noundef @s) #4, !dbg !168
  %30 = icmp eq i32 %29, 0, !dbg !168
  br i1 %30, label %31, label %32, !dbg !168

31:                                               ; preds = %28
  br label %33, !dbg !168

32:                                               ; preds = %28
  call void @__assert_fail(ptr noundef @.str.7, ptr noundef @.str.1, i32 noundef 47, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !168
  unreachable, !dbg !168

33:                                               ; preds = %31
  ret i32 0, !dbg !171
}

; Function Attrs: nounwind
declare i32 @pthread_barrier_init(ptr noundef, ptr noundef, i32 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_barrier_destroy(ptr noundef) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { cold noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!88, !89, !90, !91, !92, !93, !94}
!llvm.ident = !{!95}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 9, type: !75, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !10, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_barrier.c", directory: "/tmp/ll", checksumkind: CSK_MD5, checksum: "de37e76d5a37dd53f34e59f3728405e2")
!4 = !{!5, !6, !9}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !7, line: 80, baseType: !8)
!7 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "271af118c99df098fe315fa3d1c635c4")
!8 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!10 = !{!0, !11, !17, !22, !28, !33, !38, !40, !45, !50, !55, !60, !65, !70}
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
!23 = distinct !DIGlobalVariable(scope: null, file: !3, line: 16, type: !24, isLocal: true, isDefinition: true)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 160, elements: !26)
!25 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !14)
!26 = !{!27}
!27 = !DISubrange(count: 20)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !3, line: 27, type: !30, isLocal: true, isDefinition: true)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 392, elements: !31)
!31 = !{!32}
!32 = !DISubrange(count: 49)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(scope: null, file: !3, line: 27, type: !35, isLocal: true, isDefinition: true)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 168, elements: !36)
!36 = !{!37}
!37 = !DISubrange(count: 21)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 31, type: !30, isLocal: true, isDefinition: true)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(scope: null, file: !3, line: 38, type: !42, isLocal: true, isDefinition: true)
!42 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 376, elements: !43)
!43 = !{!44}
!44 = !DISubrange(count: 47)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(scope: null, file: !3, line: 38, type: !47, isLocal: true, isDefinition: true)
!47 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 88, elements: !48)
!48 = !{!49}
!49 = !DISubrange(count: 11)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(scope: null, file: !3, line: 39, type: !52, isLocal: true, isDefinition: true)
!52 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 112, elements: !53)
!53 = !{!54}
!54 = !DISubrange(count: 14)
!55 = !DIGlobalVariableExpression(var: !56, expr: !DIExpression())
!56 = distinct !DIGlobalVariable(scope: null, file: !3, line: 46, type: !57, isLocal: true, isDefinition: true)
!57 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 96, elements: !58)
!58 = !{!59}
!59 = !DISubrange(count: 12)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(scope: null, file: !3, line: 47, type: !62, isLocal: true, isDefinition: true)
!62 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 328, elements: !63)
!63 = !{!64}
!64 = !DISubrange(count: 41)
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !3, line: 10, type: !67, isLocal: false, isDefinition: true)
!67 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 96, elements: !68)
!68 = !{!69}
!69 = !DISubrange(count: 3)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "serial", scope: !2, file: !3, line: 11, type: !72, isLocal: false, isDefinition: true)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !73, line: 104, baseType: !74)
!73 = !DIFile(filename: "/usr/lib/llvm-21/lib/clang/21/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "f17199a988fe91afffaf0f943ef87096")
!74 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !5)
!75 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 9, size: 320, elements: !76)
!76 = !{!77, !87}
!77 = !DIDerivedType(tag: DW_TAG_member, name: "barrier", scope: !75, file: !3, line: 9, baseType: !78, size: 256)
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_barrier_t", file: !79, line: 112, baseType: !80)
!79 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "cbf5435bd7bfed052b1a09633f314dde")
!80 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !79, line: 108, size: 256, elements: !81)
!81 = !{!82, !86}
!82 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !80, file: !79, line: 110, baseType: !83, size: 256)
!83 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 256, elements: !84)
!84 = !{!85}
!85 = !DISubrange(count: 32)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !80, file: !79, line: 111, baseType: !8, size: 64)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "guard", scope: !75, file: !3, line: 9, baseType: !5, size: 32, offset: 256)
!88 = !{i32 7, !"Dwarf Version", i32 5}
!89 = !{i32 2, !"Debug Info Version", i32 3}
!90 = !{i32 1, !"wchar_size", i32 4}
!91 = !{i32 8, !"PIC Level", i32 2}
!92 = !{i32 7, !"PIE Level", i32 2}
!93 = !{i32 7, !"uwtable", i32 2}
!94 = !{i32 7, !"frame-pointer", i32 2}
!95 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!96 = distinct !DISubprogram(name: "wait_barrier", scope: !3, file: !3, line: 13, type: !97, scopeLine: 14, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !99)
!97 = !DISubroutineType(types: !98)
!98 = !{null}
!99 = !{}
!100 = !DILocalVariable(name: "status", scope: !96, file: !3, line: 15, type: !5)
!101 = !DILocation(line: 15, column: 9, scope: !96)
!102 = !DILocation(line: 15, column: 18, scope: !96)
!103 = !DILocation(line: 16, column: 5, scope: !104)
!104 = distinct !DILexicalBlock(scope: !105, file: !3, line: 16, column: 5)
!105 = distinct !DILexicalBlock(scope: !96, file: !3, line: 16, column: 5)
!106 = !DILocation(line: 17, column: 9, scope: !107)
!107 = distinct !DILexicalBlock(scope: !96, file: !3, line: 17, column: 9)
!108 = !DILocation(line: 17, column: 16, scope: !107)
!109 = !DILocation(line: 18, column: 9, scope: !110)
!110 = distinct !DILexicalBlock(scope: !107, file: !3, line: 17, column: 50)
!111 = !DILocation(line: 19, column: 5, scope: !110)
!112 = !DILocation(line: 20, column: 1, scope: !96)
!113 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 22, type: !114, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !99)
!114 = !DISubroutineType(types: !115)
!115 = !{!9, !9}
!116 = !DILocalVariable(name: "arg", arg: 1, scope: !113, file: !3, line: 22, type: !9)
!117 = !DILocation(line: 22, column: 20, scope: !113)
!118 = !DILocalVariable(name: "i", scope: !113, file: !3, line: 24, type: !5)
!119 = !DILocation(line: 24, column: 9, scope: !113)
!120 = !DILocation(line: 24, column: 28, scope: !113)
!121 = !DILocation(line: 24, column: 18, scope: !113)
!122 = !DILocation(line: 24, column: 13, scope: !113)
!123 = !DILocation(line: 25, column: 10, scope: !113)
!124 = !DILocation(line: 25, column: 5, scope: !113)
!125 = !DILocation(line: 25, column: 13, scope: !113)
!126 = !DILocation(line: 26, column: 5, scope: !113)
!127 = !DILocation(line: 27, column: 5, scope: !128)
!128 = distinct !DILexicalBlock(scope: !129, file: !3, line: 27, column: 5)
!129 = distinct !DILexicalBlock(scope: !113, file: !3, line: 27, column: 5)
!130 = !DILocation(line: 28, column: 5, scope: !113)
!131 = !DILocation(line: 29, column: 10, scope: !113)
!132 = !DILocation(line: 29, column: 5, scope: !113)
!133 = !DILocation(line: 29, column: 13, scope: !113)
!134 = !DILocation(line: 30, column: 5, scope: !113)
!135 = !DILocation(line: 31, column: 5, scope: !136)
!136 = distinct !DILexicalBlock(scope: !137, file: !3, line: 31, column: 5)
!137 = distinct !DILexicalBlock(scope: !113, file: !3, line: 31, column: 5)
!138 = !DILocation(line: 32, column: 5, scope: !113)
!139 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 35, type: !140, scopeLine: 36, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !99)
!140 = !DISubroutineType(types: !141)
!141 = !{!5}
!142 = !DILocalVariable(name: "t0", scope: !139, file: !3, line: 37, type: !143)
!143 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !79, line: 27, baseType: !144)
!144 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!145 = !DILocation(line: 37, column: 15, scope: !139)
!146 = !DILocalVariable(name: "t1", scope: !139, file: !3, line: 37, type: !143)
!147 = !DILocation(line: 37, column: 19, scope: !139)
!148 = !DILocalVariable(name: "t2", scope: !139, file: !3, line: 37, type: !143)
!149 = !DILocation(line: 37, column: 23, scope: !139)
!150 = !DILocation(line: 38, column: 5, scope: !151)
!151 = distinct !DILexicalBlock(scope: !152, file: !3, line: 38, column: 5)
!152 = distinct !DILexicalBlock(scope: !139, file: !3, line: 38, column: 5)
!153 = !DILocation(line: 39, column: 5, scope: !154)
!154 = distinct !DILexicalBlock(scope: !155, file: !3, line: 39, column: 5)
!155 = distinct !DILexicalBlock(scope: !139, file: !3, line: 39, column: 5)
!156 = !DILocation(line: 40, column: 5, scope: !139)
!157 = !DILocation(line: 41, column: 5, scope: !139)
!158 = !DILocation(line: 42, column: 5, scope: !139)
!159 = !DILocation(line: 43, column: 18, scope: !139)
!160 = !DILocation(line: 43, column: 5, scope: !139)
!161 = !DILocation(line: 44, column: 18, scope: !139)
!162 = !DILocation(line: 44, column: 5, scope: !139)
!163 = !DILocation(line: 45, column: 18, scope: !139)
!164 = !DILocation(line: 45, column: 5, scope: !139)
!165 = !DILocation(line: 46, column: 5, scope: !166)
!166 = distinct !DILexicalBlock(scope: !167, file: !3, line: 46, column: 5)
!167 = distinct !DILexicalBlock(scope: !139, file: !3, line: 46, column: 5)
!168 = !DILocation(line: 47, column: 5, scope: !169)
!169 = distinct !DILexicalBlock(scope: !170, file: !3, line: 47, column: 5)
!170 = distinct !DILexicalBlock(scope: !139, file: !3, line: 47, column: 5)
!171 = !DILocation(line: 48, column: 5, scope: !139)
