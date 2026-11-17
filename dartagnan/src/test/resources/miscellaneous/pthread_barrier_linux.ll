; ModuleID = 'pthread_barrier.c'
source_filename = "pthread_barrier.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_barrier_t = type { i64, [24 x i8] }
%struct.anon = type { %union.pthread_barrier_t, i32 }

@s = dso_local global { %union.pthread_barrier_t, i32, [4 x i8] } { %union.pthread_barrier_t zeroinitializer, i32 42, [4 x i8] zeroinitializer }, align 8, !dbg !0
@.str = private unnamed_addr constant [55 x i8] c"status == 0 || status == PTHREAD_BARRIER_SERIAL_THREAD\00", align 1, !dbg !12
@.str.1 = private unnamed_addr constant [18 x i8] c"pthread_barrier.c\00", align 1, !dbg !18
@__PRETTY_FUNCTION__.wait_barrier = private unnamed_addr constant [20 x i8] c"void wait_barrier()\00", align 1, !dbg !23
@serial = dso_local global i32 0, align 4, !dbg !81
@data = dso_local global [3 x i32] zeroinitializer, align 4, !dbg !76
@.str.2 = private unnamed_addr constant [49 x i8] c"data[(i + 1) % 3] == 1 && data[(i + 2) % 3] == 1\00", align 1, !dbg !29
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1, !dbg !34
@.str.3 = private unnamed_addr constant [49 x i8] c"data[(i + 1) % 3] == 2 && data[(i + 2) % 3] == 2\00", align 1, !dbg !39
@.str.4 = private unnamed_addr constant [52 x i8] c"pthread_barrier_init(&s.barrier, NULL, 0) == EINVAL\00", align 1, !dbg !41
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1, !dbg !46
@.str.5 = private unnamed_addr constant [72 x i8] c"pthread_barrier_init(&s.barrier, NULL, (unsigned)INT_MAX + 1) == EINVAL\00", align 1, !dbg !51
@.str.6 = private unnamed_addr constant [47 x i8] c"pthread_barrier_init(&s.barrier, NULL, 3) == 0\00", align 1, !dbg !56
@.str.7 = private unnamed_addr constant [14 x i8] c"s.guard == 42\00", align 1, !dbg !61
@.str.8 = private unnamed_addr constant [12 x i8] c"serial == 3\00", align 1, !dbg !66
@.str.9 = private unnamed_addr constant [41 x i8] c"pthread_barrier_destroy(&s.barrier) == 0\00", align 1, !dbg !71

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @wait_barrier() #0 !dbg !107 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
    #dbg_declare(ptr %1, !111, !DIExpression(), !112)
  %4 = call i32 @pthread_barrier_wait(ptr noundef @s) #4, !dbg !113
  store i32 %4, ptr %1, align 4, !dbg !112
  %5 = load i32, ptr %1, align 4, !dbg !114
  %6 = icmp eq i32 %5, 0, !dbg !114
  br i1 %6, label %10, label %7, !dbg !114

7:                                                ; preds = %0
  %8 = load i32, ptr %1, align 4, !dbg !114
  %9 = icmp eq i32 %8, -1, !dbg !114
  br i1 %9, label %10, label %11, !dbg !114

10:                                               ; preds = %7, %0
  br label %12, !dbg !114

11:                                               ; preds = %7
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 18, ptr noundef @__PRETTY_FUNCTION__.wait_barrier) #5, !dbg !114
  unreachable, !dbg !114

12:                                               ; preds = %10
  %13 = load i32, ptr %1, align 4, !dbg !117
  %14 = icmp eq i32 %13, -1, !dbg !119
  br i1 %14, label %15, label %19, !dbg !119

15:                                               ; preds = %12
  store i32 1, ptr %2, align 4, !dbg !120
  %16 = load i32, ptr %2, align 4, !dbg !120
  %17 = atomicrmw add ptr @serial, i32 %16 seq_cst, align 4, !dbg !120
  store i32 %17, ptr %3, align 4, !dbg !120
  %18 = load i32, ptr %3, align 4, !dbg !120
  br label %19, !dbg !122

19:                                               ; preds = %15, %12
  ret void, !dbg !123
}

; Function Attrs: nounwind
declare i32 @pthread_barrier_wait(ptr noundef) #1

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @worker(ptr noundef %0) #0 !dbg !124 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !127, !DIExpression(), !128)
    #dbg_declare(ptr %3, !129, !DIExpression(), !130)
  %4 = load ptr, ptr %2, align 8, !dbg !131
  %5 = ptrtoint ptr %4 to i64, !dbg !132
  %6 = trunc i64 %5 to i32, !dbg !133
  store i32 %6, ptr %3, align 4, !dbg !130
  %7 = load i32, ptr %3, align 4, !dbg !134
  %8 = sext i32 %7 to i64, !dbg !135
  %9 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %8, !dbg !135
  store i32 1, ptr %9, align 4, !dbg !136
  call void @wait_barrier(), !dbg !137
  %10 = load i32, ptr %3, align 4, !dbg !138
  %11 = add nsw i32 %10, 1, !dbg !138
  %12 = srem i32 %11, 3, !dbg !138
  %13 = sext i32 %12 to i64, !dbg !138
  %14 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %13, !dbg !138
  %15 = load i32, ptr %14, align 4, !dbg !138
  %16 = icmp eq i32 %15, 1, !dbg !138
  br i1 %16, label %17, label %26, !dbg !138

17:                                               ; preds = %1
  %18 = load i32, ptr %3, align 4, !dbg !138
  %19 = add nsw i32 %18, 2, !dbg !138
  %20 = srem i32 %19, 3, !dbg !138
  %21 = sext i32 %20 to i64, !dbg !138
  %22 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %21, !dbg !138
  %23 = load i32, ptr %22, align 4, !dbg !138
  %24 = icmp eq i32 %23, 1, !dbg !138
  br i1 %24, label %25, label %26, !dbg !138

25:                                               ; preds = %17
  br label %27, !dbg !138

26:                                               ; preds = %17, %1
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 29, ptr noundef @__PRETTY_FUNCTION__.worker) #5, !dbg !138
  unreachable, !dbg !138

27:                                               ; preds = %25
  call void @wait_barrier(), !dbg !141
  %28 = load i32, ptr %3, align 4, !dbg !142
  %29 = sext i32 %28 to i64, !dbg !143
  %30 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %29, !dbg !143
  store i32 2, ptr %30, align 4, !dbg !144
  call void @wait_barrier(), !dbg !145
  %31 = load i32, ptr %3, align 4, !dbg !146
  %32 = add nsw i32 %31, 1, !dbg !146
  %33 = srem i32 %32, 3, !dbg !146
  %34 = sext i32 %33 to i64, !dbg !146
  %35 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %34, !dbg !146
  %36 = load i32, ptr %35, align 4, !dbg !146
  %37 = icmp eq i32 %36, 2, !dbg !146
  br i1 %37, label %38, label %47, !dbg !146

38:                                               ; preds = %27
  %39 = load i32, ptr %3, align 4, !dbg !146
  %40 = add nsw i32 %39, 2, !dbg !146
  %41 = srem i32 %40, 3, !dbg !146
  %42 = sext i32 %41 to i64, !dbg !146
  %43 = getelementptr inbounds [3 x i32], ptr @data, i64 0, i64 %42, !dbg !146
  %44 = load i32, ptr %43, align 4, !dbg !146
  %45 = icmp eq i32 %44, 2, !dbg !146
  br i1 %45, label %46, label %47, !dbg !146

46:                                               ; preds = %38
  br label %48, !dbg !146

47:                                               ; preds = %38, %27
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 33, ptr noundef @__PRETTY_FUNCTION__.worker) #5, !dbg !146
  unreachable, !dbg !146

48:                                               ; preds = %46
  ret ptr null, !dbg !149
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !150 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !153, !DIExpression(), !156)
    #dbg_declare(ptr %3, !157, !DIExpression(), !158)
    #dbg_declare(ptr %4, !159, !DIExpression(), !160)
  %5 = call i32 @pthread_barrier_init(ptr noundef @s, ptr noundef null, i32 noundef 0) #4, !dbg !161
  %6 = icmp eq i32 %5, 22, !dbg !161
  br i1 %6, label %7, label %8, !dbg !161

7:                                                ; preds = %0
  br label %9, !dbg !161

8:                                                ; preds = %0
  call void @__assert_fail(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 40, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !161
  unreachable, !dbg !161

9:                                                ; preds = %7
  %10 = call i32 @pthread_barrier_init(ptr noundef @s, ptr noundef null, i32 noundef -2147483648) #4, !dbg !164
  %11 = icmp eq i32 %10, 22, !dbg !164
  br i1 %11, label %12, label %13, !dbg !164

12:                                               ; preds = %9
  br label %14, !dbg !164

13:                                               ; preds = %9
  call void @__assert_fail(ptr noundef @.str.5, ptr noundef @.str.1, i32 noundef 42, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !164
  unreachable, !dbg !164

14:                                               ; preds = %12
  %15 = call i32 @pthread_barrier_init(ptr noundef @s, ptr noundef null, i32 noundef 3) #4, !dbg !167
  %16 = icmp eq i32 %15, 0, !dbg !167
  br i1 %16, label %17, label %18, !dbg !167

17:                                               ; preds = %14
  br label %19, !dbg !167

18:                                               ; preds = %14
  call void @__assert_fail(ptr noundef @.str.6, ptr noundef @.str.1, i32 noundef 44, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !167
  unreachable, !dbg !167

19:                                               ; preds = %17
  %20 = load i32, ptr getelementptr inbounds nuw (%struct.anon, ptr @s, i32 0, i32 1), align 8, !dbg !170
  %21 = icmp eq i32 %20, 42, !dbg !170
  br i1 %21, label %22, label %23, !dbg !170

22:                                               ; preds = %19
  br label %24, !dbg !170

23:                                               ; preds = %19
  call void @__assert_fail(ptr noundef @.str.7, ptr noundef @.str.1, i32 noundef 45, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !170
  unreachable, !dbg !170

24:                                               ; preds = %22
  %25 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @worker, ptr noundef null) #4, !dbg !173
  %26 = call i32 @pthread_create(ptr noundef %3, ptr noundef null, ptr noundef @worker, ptr noundef inttoptr (i64 1 to ptr)) #4, !dbg !174
  %27 = call i32 @pthread_create(ptr noundef %4, ptr noundef null, ptr noundef @worker, ptr noundef inttoptr (i64 2 to ptr)) #4, !dbg !175
  %28 = load i64, ptr %2, align 8, !dbg !176
  %29 = call i32 @pthread_join(i64 noundef %28, ptr noundef null), !dbg !177
  %30 = load i64, ptr %3, align 8, !dbg !178
  %31 = call i32 @pthread_join(i64 noundef %30, ptr noundef null), !dbg !179
  %32 = load i64, ptr %4, align 8, !dbg !180
  %33 = call i32 @pthread_join(i64 noundef %32, ptr noundef null), !dbg !181
  %34 = load atomic i32, ptr @serial seq_cst, align 4, !dbg !182
  %35 = icmp eq i32 %34, 3, !dbg !182
  br i1 %35, label %36, label %37, !dbg !182

36:                                               ; preds = %24
  br label %38, !dbg !182

37:                                               ; preds = %24
  call void @__assert_fail(ptr noundef @.str.8, ptr noundef @.str.1, i32 noundef 52, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !182
  unreachable, !dbg !182

38:                                               ; preds = %36
  %39 = call i32 @pthread_barrier_destroy(ptr noundef @s) #4, !dbg !185
  %40 = icmp eq i32 %39, 0, !dbg !185
  br i1 %40, label %41, label %42, !dbg !185

41:                                               ; preds = %38
  br label %43, !dbg !185

42:                                               ; preds = %38
  call void @__assert_fail(ptr noundef @.str.9, ptr noundef @.str.1, i32 noundef 53, ptr noundef @__PRETTY_FUNCTION__.main) #5, !dbg !185
  unreachable, !dbg !185

43:                                               ; preds = %41
  ret i32 0, !dbg !188
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
!llvm.module.flags = !{!99, !100, !101, !102, !103, !104, !105}
!llvm.ident = !{!106}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 11, type: !86, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 21.1.8 (6ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !11, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "pthread_barrier.c", directory: "/tmp/ll", checksumkind: CSK_MD5, checksum: "675c79832ebdfb749b66fa09de6061d7")
!4 = !{!5, !6, !9, !10}
!5 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !7, line: 80, baseType: !8)
!7 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "271af118c99df098fe315fa3d1c635c4")
!8 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!10 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!11 = !{!0, !12, !18, !23, !29, !34, !39, !41, !46, !51, !56, !61, !66, !71, !76, !81}
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !3, line: 18, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 440, elements: !16)
!15 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!16 = !{!17}
!17 = !DISubrange(count: 55)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 18, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 144, elements: !21)
!21 = !{!22}
!22 = !DISubrange(count: 18)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !3, line: 18, type: !25, isLocal: true, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 160, elements: !27)
!26 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!27 = !{!28}
!28 = !DISubrange(count: 20)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 29, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 392, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 49)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !3, line: 29, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 168, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: 21)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(scope: null, file: !3, line: 33, type: !31, isLocal: true, isDefinition: true)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 40, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 416, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 52)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(scope: null, file: !3, line: 40, type: !48, isLocal: true, isDefinition: true)
!48 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 88, elements: !49)
!49 = !{!50}
!50 = !DISubrange(count: 11)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(scope: null, file: !3, line: 42, type: !53, isLocal: true, isDefinition: true)
!53 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 576, elements: !54)
!54 = !{!55}
!55 = !DISubrange(count: 72)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(scope: null, file: !3, line: 44, type: !58, isLocal: true, isDefinition: true)
!58 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 376, elements: !59)
!59 = !{!60}
!60 = !DISubrange(count: 47)
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(scope: null, file: !3, line: 45, type: !63, isLocal: true, isDefinition: true)
!63 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 112, elements: !64)
!64 = !{!65}
!65 = !DISubrange(count: 14)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(scope: null, file: !3, line: 52, type: !68, isLocal: true, isDefinition: true)
!68 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 96, elements: !69)
!69 = !{!70}
!70 = !DISubrange(count: 12)
!71 = !DIGlobalVariableExpression(var: !72, expr: !DIExpression())
!72 = distinct !DIGlobalVariable(scope: null, file: !3, line: 53, type: !73, isLocal: true, isDefinition: true)
!73 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 328, elements: !74)
!74 = !{!75}
!75 = !DISubrange(count: 41)
!76 = !DIGlobalVariableExpression(var: !77, expr: !DIExpression())
!77 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !3, line: 12, type: !78, isLocal: false, isDefinition: true)
!78 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 96, elements: !79)
!79 = !{!80}
!80 = !DISubrange(count: 3)
!81 = !DIGlobalVariableExpression(var: !82, expr: !DIExpression())
!82 = distinct !DIGlobalVariable(name: "serial", scope: !2, file: !3, line: 13, type: !83, isLocal: false, isDefinition: true)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !84, line: 104, baseType: !85)
!84 = !DIFile(filename: "/usr/lib/llvm-21/lib/clang/21/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "f17199a988fe91afffaf0f943ef87096")
!85 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !5)
!86 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 11, size: 320, elements: !87)
!87 = !{!88, !98}
!88 = !DIDerivedType(tag: DW_TAG_member, name: "barrier", scope: !86, file: !3, line: 11, baseType: !89, size: 256)
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_barrier_t", file: !90, line: 112, baseType: !91)
!90 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "cbf5435bd7bfed052b1a09633f314dde")
!91 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !90, line: 108, size: 256, elements: !92)
!92 = !{!93, !97}
!93 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !91, file: !90, line: 110, baseType: !94, size: 256)
!94 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 256, elements: !95)
!95 = !{!96}
!96 = !DISubrange(count: 32)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !91, file: !90, line: 111, baseType: !8, size: 64)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "guard", scope: !86, file: !3, line: 11, baseType: !5, size: 32, offset: 256)
!99 = !{i32 7, !"Dwarf Version", i32 5}
!100 = !{i32 2, !"Debug Info Version", i32 3}
!101 = !{i32 1, !"wchar_size", i32 4}
!102 = !{i32 8, !"PIC Level", i32 2}
!103 = !{i32 7, !"PIE Level", i32 2}
!104 = !{i32 7, !"uwtable", i32 2}
!105 = !{i32 7, !"frame-pointer", i32 2}
!106 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!107 = distinct !DISubprogram(name: "wait_barrier", scope: !3, file: !3, line: 15, type: !108, scopeLine: 16, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !110)
!108 = !DISubroutineType(types: !109)
!109 = !{null}
!110 = !{}
!111 = !DILocalVariable(name: "status", scope: !107, file: !3, line: 17, type: !5)
!112 = !DILocation(line: 17, column: 9, scope: !107)
!113 = !DILocation(line: 17, column: 18, scope: !107)
!114 = !DILocation(line: 18, column: 5, scope: !115)
!115 = distinct !DILexicalBlock(scope: !116, file: !3, line: 18, column: 5)
!116 = distinct !DILexicalBlock(scope: !107, file: !3, line: 18, column: 5)
!117 = !DILocation(line: 19, column: 9, scope: !118)
!118 = distinct !DILexicalBlock(scope: !107, file: !3, line: 19, column: 9)
!119 = !DILocation(line: 19, column: 16, scope: !118)
!120 = !DILocation(line: 20, column: 9, scope: !121)
!121 = distinct !DILexicalBlock(scope: !118, file: !3, line: 19, column: 50)
!122 = !DILocation(line: 21, column: 5, scope: !121)
!123 = !DILocation(line: 22, column: 1, scope: !107)
!124 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 24, type: !125, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !110)
!125 = !DISubroutineType(types: !126)
!126 = !{!9, !9}
!127 = !DILocalVariable(name: "arg", arg: 1, scope: !124, file: !3, line: 24, type: !9)
!128 = !DILocation(line: 24, column: 20, scope: !124)
!129 = !DILocalVariable(name: "i", scope: !124, file: !3, line: 26, type: !5)
!130 = !DILocation(line: 26, column: 9, scope: !124)
!131 = !DILocation(line: 26, column: 28, scope: !124)
!132 = !DILocation(line: 26, column: 18, scope: !124)
!133 = !DILocation(line: 26, column: 13, scope: !124)
!134 = !DILocation(line: 27, column: 10, scope: !124)
!135 = !DILocation(line: 27, column: 5, scope: !124)
!136 = !DILocation(line: 27, column: 13, scope: !124)
!137 = !DILocation(line: 28, column: 5, scope: !124)
!138 = !DILocation(line: 29, column: 5, scope: !139)
!139 = distinct !DILexicalBlock(scope: !140, file: !3, line: 29, column: 5)
!140 = distinct !DILexicalBlock(scope: !124, file: !3, line: 29, column: 5)
!141 = !DILocation(line: 30, column: 5, scope: !124)
!142 = !DILocation(line: 31, column: 10, scope: !124)
!143 = !DILocation(line: 31, column: 5, scope: !124)
!144 = !DILocation(line: 31, column: 13, scope: !124)
!145 = !DILocation(line: 32, column: 5, scope: !124)
!146 = !DILocation(line: 33, column: 5, scope: !147)
!147 = distinct !DILexicalBlock(scope: !148, file: !3, line: 33, column: 5)
!148 = distinct !DILexicalBlock(scope: !124, file: !3, line: 33, column: 5)
!149 = !DILocation(line: 34, column: 5, scope: !124)
!150 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 37, type: !151, scopeLine: 38, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !110)
!151 = !DISubroutineType(types: !152)
!152 = !{!5}
!153 = !DILocalVariable(name: "t0", scope: !150, file: !3, line: 39, type: !154)
!154 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !90, line: 27, baseType: !155)
!155 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!156 = !DILocation(line: 39, column: 15, scope: !150)
!157 = !DILocalVariable(name: "t1", scope: !150, file: !3, line: 39, type: !154)
!158 = !DILocation(line: 39, column: 19, scope: !150)
!159 = !DILocalVariable(name: "t2", scope: !150, file: !3, line: 39, type: !154)
!160 = !DILocation(line: 39, column: 23, scope: !150)
!161 = !DILocation(line: 40, column: 5, scope: !162)
!162 = distinct !DILexicalBlock(scope: !163, file: !3, line: 40, column: 5)
!163 = distinct !DILexicalBlock(scope: !150, file: !3, line: 40, column: 5)
!164 = !DILocation(line: 42, column: 5, scope: !165)
!165 = distinct !DILexicalBlock(scope: !166, file: !3, line: 42, column: 5)
!166 = distinct !DILexicalBlock(scope: !150, file: !3, line: 42, column: 5)
!167 = !DILocation(line: 44, column: 5, scope: !168)
!168 = distinct !DILexicalBlock(scope: !169, file: !3, line: 44, column: 5)
!169 = distinct !DILexicalBlock(scope: !150, file: !3, line: 44, column: 5)
!170 = !DILocation(line: 45, column: 5, scope: !171)
!171 = distinct !DILexicalBlock(scope: !172, file: !3, line: 45, column: 5)
!172 = distinct !DILexicalBlock(scope: !150, file: !3, line: 45, column: 5)
!173 = !DILocation(line: 46, column: 5, scope: !150)
!174 = !DILocation(line: 47, column: 5, scope: !150)
!175 = !DILocation(line: 48, column: 5, scope: !150)
!176 = !DILocation(line: 49, column: 18, scope: !150)
!177 = !DILocation(line: 49, column: 5, scope: !150)
!178 = !DILocation(line: 50, column: 18, scope: !150)
!179 = !DILocation(line: 50, column: 5, scope: !150)
!180 = !DILocation(line: 51, column: 18, scope: !150)
!181 = !DILocation(line: 51, column: 5, scope: !150)
!182 = !DILocation(line: 52, column: 5, scope: !183)
!183 = distinct !DILexicalBlock(scope: !184, file: !3, line: 52, column: 5)
!184 = distinct !DILexicalBlock(scope: !150, file: !3, line: 52, column: 5)
!185 = !DILocation(line: 53, column: 5, scope: !186)
!186 = distinct !DILexicalBlock(scope: !187, file: !3, line: 53, column: 5)
!187 = distinct !DILexicalBlock(scope: !150, file: !3, line: 53, column: 5)
!188 = !DILocation(line: 54, column: 5, scope: !150)
