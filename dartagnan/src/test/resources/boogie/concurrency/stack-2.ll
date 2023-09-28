; ModuleID = '/home/ponce/git/Dat3M/output/stack-2.ll'
source_filename = "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread/stack-2.i"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, %union.anon }
%union.anon = type { %struct.__pthread_internal_slist }
%struct.__pthread_internal_slist = type { %struct.__pthread_internal_slist* }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [32 x i8] }

@.str = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"stack-2.c\00", align 1
@__PRETTY_FUNCTION__.reach_error = private unnamed_addr constant [19 x i8] c"void reach_error()\00", align 1
@flag = dso_local global i8 0, align 1, !dbg !0
@top = internal global i32 0, align 4, !dbg !50
@.str.2 = private unnamed_addr constant [16 x i8] c"stack overflow\0A\00", align 1
@.str.3 = private unnamed_addr constant [17 x i8] c"stack underflow\0A\00", align 1
@m = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !14
@arr = internal global [5 x i32] zeroinitializer, align 16, !dbg !7
@str = private unnamed_addr constant [15 x i8] c"stack overflow\00", align 1
@str.1 = private unnamed_addr constant [16 x i8] c"stack underflow\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @reach_error() #0 !dbg !61 {
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.1, i64 0, i64 0), i32 noundef 3, i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @__PRETTY_FUNCTION__.reach_error, i64 0, i64 0)) #8, !dbg !65
  unreachable, !dbg !65
}

; Function Attrs: nocallback noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @assume_abort_if_not(i32 noundef %0) #0 !dbg !68 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !71, metadata !DIExpression()), !dbg !72
  %.not = icmp eq i32 %0, 0, !dbg !73
  br i1 %.not, label %2, label %3, !dbg !75

2:                                                ; preds = %1
  call void @abort() #9, !dbg !76
  unreachable, !dbg !76

3:                                                ; preds = %1
  ret void, !dbg !78
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: noreturn
declare void @abort() #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @error() #0 !dbg !79 {
  call void @llvm.dbg.label(metadata !80), !dbg !81
  call void @reach_error(), !dbg !82
  call void @abort() #9, !dbg !84
  unreachable, !dbg !84
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @inc_top() #0 !dbg !85 {
  %1 = load i32, i32* @top, align 4, !dbg !86
  %2 = add nsw i32 %1, 1, !dbg !86
  store i32 %2, i32* @top, align 4, !dbg !86
  ret void, !dbg !87
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @dec_top() #0 !dbg !88 {
  %1 = load i32, i32* @top, align 4, !dbg !89
  %2 = add nsw i32 %1, -1, !dbg !89
  store i32 %2, i32* @top, align 4, !dbg !89
  ret void, !dbg !90
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @get_top() #0 !dbg !91 {
  %1 = load i32, i32* @top, align 4, !dbg !94
  ret i32 %1, !dbg !95
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @stack_empty() #0 !dbg !96 {
  %1 = load i32, i32* @top, align 4, !dbg !97
  %2 = icmp eq i32 %1, 0, !dbg !98
  %3 = zext i1 %2 to i32, !dbg !99
  ret i32 %3, !dbg !100
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @push(i32* noundef %0, i32 noundef %1) #0 !dbg !101 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !105, metadata !DIExpression()), !dbg !106
  call void @llvm.dbg.value(metadata i32 %1, metadata !107, metadata !DIExpression()), !dbg !106
  %3 = load i32, i32* @top, align 4, !dbg !108
  %4 = icmp eq i32 %3, 5, !dbg !110
  br i1 %4, label %5, label %6, !dbg !111

5:                                                ; preds = %2
  %puts = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @str, i64 0, i64 0)), !dbg !112
  br label %10, !dbg !114

6:                                                ; preds = %2
  %7 = call i32 @get_top(), !dbg !115
  %8 = sext i32 %7 to i64, !dbg !117
  %9 = getelementptr inbounds i32, i32* %0, i64 %8, !dbg !117
  store i32 %1, i32* %9, align 4, !dbg !118
  call void @inc_top(), !dbg !119
  br label %10, !dbg !120

10:                                               ; preds = %6, %5
  %.0 = phi i32 [ -1, %5 ], [ 0, %6 ], !dbg !106
  ret i32 %.0, !dbg !121
}

declare i32 @printf(i8* noundef, ...) #4

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @pop(i32* noundef %0) #0 !dbg !122 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !125, metadata !DIExpression()), !dbg !126
  %2 = call i32 @get_top(), !dbg !127
  %3 = icmp eq i32 %2, 0, !dbg !129
  br i1 %3, label %4, label %5, !dbg !130

4:                                                ; preds = %1
  %puts = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @str.1, i64 0, i64 0)), !dbg !131
  br label %10, !dbg !133

5:                                                ; preds = %1
  call void @dec_top(), !dbg !134
  %6 = call i32 @get_top(), !dbg !136
  %7 = sext i32 %6 to i64, !dbg !137
  %8 = getelementptr inbounds i32, i32* %0, i64 %7, !dbg !137
  %9 = load i32, i32* %8, align 4, !dbg !137
  br label %10, !dbg !138

10:                                               ; preds = %5, %4
  %.0 = phi i32 [ -2, %4 ], [ %9, %5 ], !dbg !139
  ret i32 %.0, !dbg !140
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @t1(i8* noundef %0) #0 !dbg !141 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !144, metadata !DIExpression()), !dbg !145
  call void @llvm.dbg.value(metadata i32 0, metadata !146, metadata !DIExpression()), !dbg !145
  call void @llvm.dbg.value(metadata i32 0, metadata !146, metadata !DIExpression()), !dbg !145
  %2 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !147
  %3 = call i32 (...) @__VERIFIER_nondet_uint() #10, !dbg !151
  call void @llvm.dbg.value(metadata i32 %3, metadata !152, metadata !DIExpression()), !dbg !145
  %4 = icmp ult i32 %3, 5, !dbg !153
  %5 = zext i1 %4 to i32, !dbg !153
  call void @assume_abort_if_not(i32 noundef %5), !dbg !154
  %6 = call i32 @push(i32* noundef getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 0), i32 noundef %3), !dbg !155
  %7 = icmp eq i32 %6, -1, !dbg !157
  br i1 %7, label %8, label %9, !dbg !158

8:                                                ; preds = %1
  call void @error(), !dbg !159
  br label %9, !dbg !159

9:                                                ; preds = %8, %1
  store i8 1, i8* @flag, align 1, !dbg !160
  %10 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !161
  call void @llvm.dbg.value(metadata i32 1, metadata !146, metadata !DIExpression()), !dbg !145
  call void @llvm.dbg.value(metadata i32 1, metadata !146, metadata !DIExpression()), !dbg !145
  %11 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !147
  %12 = call i32 (...) @__VERIFIER_nondet_uint() #10, !dbg !151
  call void @llvm.dbg.value(metadata i32 %12, metadata !152, metadata !DIExpression()), !dbg !145
  %13 = icmp ult i32 %12, 5, !dbg !153
  %14 = zext i1 %13 to i32, !dbg !153
  call void @assume_abort_if_not(i32 noundef %14), !dbg !154
  %15 = call i32 @push(i32* noundef getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 0), i32 noundef %12), !dbg !155
  %16 = icmp eq i32 %15, -1, !dbg !157
  br i1 %16, label %17, label %18, !dbg !158

17:                                               ; preds = %9
  call void @error(), !dbg !159
  br label %18, !dbg !159

18:                                               ; preds = %17, %9
  store i8 1, i8* @flag, align 1, !dbg !160
  %19 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !161
  call void @llvm.dbg.value(metadata i32 2, metadata !146, metadata !DIExpression()), !dbg !145
  call void @llvm.dbg.value(metadata i32 2, metadata !146, metadata !DIExpression()), !dbg !145
  %20 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !147
  %21 = call i32 (...) @__VERIFIER_nondet_uint() #10, !dbg !151
  call void @llvm.dbg.value(metadata i32 %21, metadata !152, metadata !DIExpression()), !dbg !145
  %22 = icmp ult i32 %21, 5, !dbg !153
  %23 = zext i1 %22 to i32, !dbg !153
  call void @assume_abort_if_not(i32 noundef %23), !dbg !154
  %24 = call i32 @push(i32* noundef getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 0), i32 noundef %21), !dbg !155
  %25 = icmp eq i32 %24, -1, !dbg !157
  br i1 %25, label %26, label %27, !dbg !158

26:                                               ; preds = %18
  call void @error(), !dbg !159
  br label %27, !dbg !159

27:                                               ; preds = %26, %18
  store i8 1, i8* @flag, align 1, !dbg !160
  %28 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !161
  call void @llvm.dbg.value(metadata i32 3, metadata !146, metadata !DIExpression()), !dbg !145
  call void @llvm.dbg.value(metadata i32 3, metadata !146, metadata !DIExpression()), !dbg !145
  %29 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !147
  %30 = call i32 (...) @__VERIFIER_nondet_uint() #10, !dbg !151
  call void @llvm.dbg.value(metadata i32 %30, metadata !152, metadata !DIExpression()), !dbg !145
  %31 = icmp ult i32 %30, 5, !dbg !153
  %32 = zext i1 %31 to i32, !dbg !153
  call void @assume_abort_if_not(i32 noundef %32), !dbg !154
  %33 = call i32 @push(i32* noundef getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 0), i32 noundef %30), !dbg !155
  %34 = icmp eq i32 %33, -1, !dbg !157
  br i1 %34, label %35, label %36, !dbg !158

35:                                               ; preds = %27
  call void @error(), !dbg !159
  br label %36, !dbg !159

36:                                               ; preds = %35, %27
  store i8 1, i8* @flag, align 1, !dbg !160
  %37 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !161
  call void @llvm.dbg.value(metadata i32 4, metadata !146, metadata !DIExpression()), !dbg !145
  call void @llvm.dbg.value(metadata i32 4, metadata !146, metadata !DIExpression()), !dbg !145
  %38 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !147
  %39 = call i32 (...) @__VERIFIER_nondet_uint() #10, !dbg !151
  call void @llvm.dbg.value(metadata i32 %39, metadata !152, metadata !DIExpression()), !dbg !145
  %40 = icmp ult i32 %39, 5, !dbg !153
  %41 = zext i1 %40 to i32, !dbg !153
  call void @assume_abort_if_not(i32 noundef %41), !dbg !154
  %42 = call i32 @push(i32* noundef getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 0), i32 noundef %39), !dbg !155
  %43 = icmp eq i32 %42, -1, !dbg !157
  br i1 %43, label %44, label %45, !dbg !158

44:                                               ; preds = %36
  call void @error(), !dbg !159
  br label %45, !dbg !159

45:                                               ; preds = %44, %36
  store i8 1, i8* @flag, align 1, !dbg !160
  %46 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !161
  call void @llvm.dbg.value(metadata i32 5, metadata !146, metadata !DIExpression()), !dbg !145
  call void @llvm.dbg.value(metadata i32 5, metadata !146, metadata !DIExpression()), !dbg !145
  ret i8* null, !dbg !162
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #5

declare i32 @__VERIFIER_nondet_uint(...) #4

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #5

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @t2(i8* noundef %0) #0 !dbg !163 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !164, metadata !DIExpression()), !dbg !165
  call void @llvm.dbg.value(metadata i32 0, metadata !166, metadata !DIExpression()), !dbg !165
  call void @llvm.dbg.value(metadata i32 0, metadata !166, metadata !DIExpression()), !dbg !165
  %2 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !167
  %3 = load i8, i8* @flag, align 1, !dbg !171
  %4 = and i8 %3, 1, !dbg !171
  %.not = icmp eq i8 %4, 0, !dbg !171
  br i1 %.not, label %8, label %5, !dbg !173

5:                                                ; preds = %1
  %6 = call i32 @pop(i32* noundef getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 0)), !dbg !174
  %.not9 = icmp eq i32 %6, -2, !dbg !177
  br i1 %.not9, label %7, label %8, !dbg !178

7:                                                ; preds = %5
  call void @error(), !dbg !179
  br label %8, !dbg !179

8:                                                ; preds = %5, %7, %1
  %9 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !180
  call void @llvm.dbg.value(metadata i32 1, metadata !166, metadata !DIExpression()), !dbg !165
  call void @llvm.dbg.value(metadata i32 1, metadata !166, metadata !DIExpression()), !dbg !165
  %10 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !167
  %11 = load i8, i8* @flag, align 1, !dbg !171
  %12 = and i8 %11, 1, !dbg !171
  %.not1 = icmp eq i8 %12, 0, !dbg !171
  br i1 %.not1, label %16, label %13, !dbg !173

13:                                               ; preds = %8
  %14 = call i32 @pop(i32* noundef getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 0)), !dbg !174
  %.not8 = icmp eq i32 %14, -2, !dbg !177
  br i1 %.not8, label %15, label %16, !dbg !178

15:                                               ; preds = %13
  call void @error(), !dbg !179
  br label %16, !dbg !179

16:                                               ; preds = %13, %15, %8
  %17 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !180
  call void @llvm.dbg.value(metadata i32 2, metadata !166, metadata !DIExpression()), !dbg !165
  call void @llvm.dbg.value(metadata i32 2, metadata !166, metadata !DIExpression()), !dbg !165
  %18 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !167
  %19 = load i8, i8* @flag, align 1, !dbg !171
  %20 = and i8 %19, 1, !dbg !171
  %.not2 = icmp eq i8 %20, 0, !dbg !171
  br i1 %.not2, label %24, label %21, !dbg !173

21:                                               ; preds = %16
  %22 = call i32 @pop(i32* noundef getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 0)), !dbg !174
  %.not7 = icmp eq i32 %22, -2, !dbg !177
  br i1 %.not7, label %23, label %24, !dbg !178

23:                                               ; preds = %21
  call void @error(), !dbg !179
  br label %24, !dbg !179

24:                                               ; preds = %21, %23, %16
  %25 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !180
  call void @llvm.dbg.value(metadata i32 3, metadata !166, metadata !DIExpression()), !dbg !165
  call void @llvm.dbg.value(metadata i32 3, metadata !166, metadata !DIExpression()), !dbg !165
  %26 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !167
  %27 = load i8, i8* @flag, align 1, !dbg !171
  %28 = and i8 %27, 1, !dbg !171
  %.not3 = icmp eq i8 %28, 0, !dbg !171
  br i1 %.not3, label %32, label %29, !dbg !173

29:                                               ; preds = %24
  %30 = call i32 @pop(i32* noundef getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 0)), !dbg !174
  %.not6 = icmp eq i32 %30, -2, !dbg !177
  br i1 %.not6, label %31, label %32, !dbg !178

31:                                               ; preds = %29
  call void @error(), !dbg !179
  br label %32, !dbg !179

32:                                               ; preds = %29, %31, %24
  %33 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !180
  call void @llvm.dbg.value(metadata i32 4, metadata !166, metadata !DIExpression()), !dbg !165
  call void @llvm.dbg.value(metadata i32 4, metadata !166, metadata !DIExpression()), !dbg !165
  %34 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !167
  %35 = load i8, i8* @flag, align 1, !dbg !171
  %36 = and i8 %35, 1, !dbg !171
  %.not4 = icmp eq i8 %36, 0, !dbg !171
  br i1 %.not4, label %40, label %37, !dbg !173

37:                                               ; preds = %32
  %38 = call i32 @pop(i32* noundef getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 0)), !dbg !174
  %.not5 = icmp eq i32 %38, -2, !dbg !177
  br i1 %.not5, label %39, label %40, !dbg !178

39:                                               ; preds = %37
  call void @error(), !dbg !179
  br label %40, !dbg !179

40:                                               ; preds = %37, %39, %32
  %41 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @m) #10, !dbg !180
  call void @llvm.dbg.value(metadata i32 5, metadata !166, metadata !DIExpression()), !dbg !165
  call void @llvm.dbg.value(metadata i32 5, metadata !166, metadata !DIExpression()), !dbg !165
  ret i8* null, !dbg !181
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !182 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef nonnull @m, %union.pthread_mutexattr_t* noundef null) #11, !dbg !183
  call void @llvm.dbg.value(metadata i64* %1, metadata !184, metadata !DIExpression(DW_OP_deref)), !dbg !187
  %4 = call i32 @pthread_create(i64* noundef nonnull %1, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @t1, i8* noundef null) #10, !dbg !188
  call void @llvm.dbg.value(metadata i64* %2, metadata !189, metadata !DIExpression(DW_OP_deref)), !dbg !187
  %5 = call i32 @pthread_create(i64* noundef nonnull %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef nonnull @t2, i8* noundef null) #10, !dbg !190
  %6 = load i64, i64* %1, align 8, !dbg !191
  call void @llvm.dbg.value(metadata i64 %6, metadata !184, metadata !DIExpression()), !dbg !187
  %7 = call i32 @pthread_join(i64 noundef %6, i8** noundef null) #10, !dbg !192
  %8 = load i64, i64* %2, align 8, !dbg !193
  call void @llvm.dbg.value(metadata i64 %8, metadata !189, metadata !DIExpression()), !dbg !187
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null) #10, !dbg !194
  ret i32 0, !dbg !195
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #6

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #5

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

; Function Attrs: nofree nounwind
declare noundef i32 @puts(i8* nocapture noundef readonly) #7

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { nofree nounwind }
attributes #8 = { nocallback noreturn nounwind }
attributes #9 = { noreturn nounwind }
attributes #10 = { nounwind }
attributes #11 = { nocallback nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!53, !54, !55, !56, !57, !58, !59}
!llvm.ident = !{!60}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "flag", scope: !2, file: !9, line: 938, type: !52, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !6, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/../sv-benchmarks/c/pthread/stack-2.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "4cd7d85c0e1533c8b18cb50b8726236a")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{!0, !7, !14, !50}
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "arr", scope: !2, file: !9, line: 936, type: !10, isLocal: true, isDefinition: true)
!9 = !DIFile(filename: "../sv-benchmarks/c/pthread/stack-2.i", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "4cd7d85c0e1533c8b18cb50b8726236a")
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !11, size: 160, elements: !12)
!11 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!12 = !{!13}
!13 = !DISubrange(count: 5)
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "m", scope: !2, file: !9, line: 937, type: !16, isLocal: false, isDefinition: true)
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !9, line: 316, baseType: !17)
!17 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !9, line: 311, size: 256, elements: !18)
!18 = !{!19, !43, !48}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !17, file: !9, line: 313, baseType: !20, size: 256)
!20 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !9, line: 251, size: 256, elements: !21)
!21 = !{!22, !24, !25, !26, !27, !28}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !20, file: !9, line: 253, baseType: !23, size: 32)
!23 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !20, file: !9, line: 254, baseType: !11, size: 32, offset: 32)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !20, file: !9, line: 255, baseType: !23, size: 32, offset: 64)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !20, file: !9, line: 256, baseType: !23, size: 32, offset: 96)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !20, file: !9, line: 258, baseType: !11, size: 32, offset: 128)
!28 = !DIDerivedType(tag: DW_TAG_member, scope: !20, file: !9, line: 259, baseType: !29, size: 64, offset: 192)
!29 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !20, file: !9, line: 259, size: 64, elements: !30)
!30 = !{!31, !37}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "__elision_data", scope: !29, file: !9, line: 261, baseType: !32, size: 32)
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !29, file: !9, line: 261, size: 32, elements: !33)
!33 = !{!34, !36}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "__espins", scope: !32, file: !9, line: 261, baseType: !35, size: 16)
!35 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__eelision", scope: !32, file: !9, line: 261, baseType: !35, size: 16, offset: 16)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !29, file: !9, line: 262, baseType: !38, size: 64)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_slist_t", file: !9, line: 250, baseType: !39)
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_slist", file: !9, line: 247, size: 64, elements: !40)
!40 = !{!41}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !39, file: !9, line: 249, baseType: !42, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !17, file: !9, line: 314, baseType: !44, size: 192)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !45, size: 192, elements: !46)
!45 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!46 = !{!47}
!47 = !DISubrange(count: 24)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !17, file: !9, line: 315, baseType: !49, size: 64)
!49 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "top", scope: !2, file: !9, line: 935, type: !23, isLocal: true, isDefinition: true)
!52 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!53 = !{i32 7, !"Dwarf Version", i32 5}
!54 = !{i32 2, !"Debug Info Version", i32 3}
!55 = !{i32 1, !"wchar_size", i32 4}
!56 = !{i32 7, !"PIC Level", i32 2}
!57 = !{i32 7, !"PIE Level", i32 2}
!58 = !{i32 7, !"uwtable", i32 1}
!59 = !{i32 7, !"frame-pointer", i32 2}
!60 = !{!"Ubuntu clang version 14.0.6"}
!61 = distinct !DISubprogram(name: "reach_error", scope: !9, file: !9, line: 20, type: !62, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!62 = !DISubroutineType(types: !63)
!63 = !{null}
!64 = !{}
!65 = !DILocation(line: 20, column: 83, scope: !66)
!66 = distinct !DILexicalBlock(scope: !67, file: !9, line: 20, column: 73)
!67 = distinct !DILexicalBlock(scope: !61, file: !9, line: 20, column: 67)
!68 = distinct !DISubprogram(name: "assume_abort_if_not", scope: !9, file: !9, line: 22, type: !69, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!69 = !DISubroutineType(types: !70)
!70 = !{null, !23}
!71 = !DILocalVariable(name: "cond", arg: 1, scope: !68, file: !9, line: 22, type: !23)
!72 = !DILocation(line: 0, scope: !68)
!73 = !DILocation(line: 23, column: 7, scope: !74)
!74 = distinct !DILexicalBlock(scope: !68, file: !9, line: 23, column: 6)
!75 = !DILocation(line: 23, column: 6, scope: !68)
!76 = !DILocation(line: 23, column: 14, scope: !77)
!77 = distinct !DILexicalBlock(scope: !74, file: !9, line: 23, column: 13)
!78 = !DILocation(line: 24, column: 1, scope: !68)
!79 = distinct !DISubprogram(name: "error", scope: !9, file: !9, line: 939, type: !62, scopeLine: 940, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!80 = !DILabel(scope: !79, name: "ERROR", file: !9, line: 941)
!81 = !DILocation(line: 941, column: 3, scope: !79)
!82 = !DILocation(line: 941, column: 11, scope: !83)
!83 = distinct !DILexicalBlock(scope: !79, file: !9, line: 941, column: 10)
!84 = !DILocation(line: 941, column: 25, scope: !83)
!85 = distinct !DISubprogram(name: "inc_top", scope: !9, file: !9, line: 944, type: !62, scopeLine: 945, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!86 = !DILocation(line: 946, column: 6, scope: !85)
!87 = !DILocation(line: 947, column: 1, scope: !85)
!88 = distinct !DISubprogram(name: "dec_top", scope: !9, file: !9, line: 948, type: !62, scopeLine: 949, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!89 = !DILocation(line: 950, column: 6, scope: !88)
!90 = !DILocation(line: 951, column: 1, scope: !88)
!91 = distinct !DISubprogram(name: "get_top", scope: !9, file: !9, line: 952, type: !92, scopeLine: 953, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!92 = !DISubroutineType(types: !93)
!93 = !{!23}
!94 = !DILocation(line: 954, column: 10, scope: !91)
!95 = !DILocation(line: 954, column: 3, scope: !91)
!96 = distinct !DISubprogram(name: "stack_empty", scope: !9, file: !9, line: 956, type: !92, scopeLine: 957, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!97 = !DILocation(line: 958, column: 11, scope: !96)
!98 = !DILocation(line: 958, column: 14, scope: !96)
!99 = !DILocation(line: 958, column: 10, scope: !96)
!100 = !DILocation(line: 958, column: 3, scope: !96)
!101 = distinct !DISubprogram(name: "push", scope: !9, file: !9, line: 960, type: !102, scopeLine: 961, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!102 = !DISubroutineType(types: !103)
!103 = !{!23, !104, !23}
!104 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!105 = !DILocalVariable(name: "stack", arg: 1, scope: !101, file: !9, line: 960, type: !104)
!106 = !DILocation(line: 0, scope: !101)
!107 = !DILocalVariable(name: "x", arg: 2, scope: !101, file: !9, line: 960, type: !23)
!108 = !DILocation(line: 962, column: 7, scope: !109)
!109 = distinct !DILexicalBlock(scope: !101, file: !9, line: 962, column: 7)
!110 = !DILocation(line: 962, column: 10, scope: !109)
!111 = !DILocation(line: 962, column: 7, scope: !101)
!112 = !DILocation(line: 964, column: 5, scope: !113)
!113 = distinct !DILexicalBlock(scope: !109, file: !9, line: 963, column: 3)
!114 = !DILocation(line: 965, column: 5, scope: !113)
!115 = !DILocation(line: 969, column: 11, scope: !116)
!116 = distinct !DILexicalBlock(scope: !109, file: !9, line: 968, column: 3)
!117 = !DILocation(line: 969, column: 5, scope: !116)
!118 = !DILocation(line: 969, column: 22, scope: !116)
!119 = !DILocation(line: 970, column: 5, scope: !116)
!120 = !DILocation(line: 972, column: 3, scope: !101)
!121 = !DILocation(line: 973, column: 1, scope: !101)
!122 = distinct !DISubprogram(name: "pop", scope: !9, file: !9, line: 974, type: !123, scopeLine: 975, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!123 = !DISubroutineType(types: !124)
!124 = !{!23, !104}
!125 = !DILocalVariable(name: "stack", arg: 1, scope: !122, file: !9, line: 974, type: !104)
!126 = !DILocation(line: 0, scope: !122)
!127 = !DILocation(line: 976, column: 7, scope: !128)
!128 = distinct !DILexicalBlock(scope: !122, file: !9, line: 976, column: 7)
!129 = !DILocation(line: 976, column: 16, scope: !128)
!130 = !DILocation(line: 976, column: 7, scope: !122)
!131 = !DILocation(line: 978, column: 5, scope: !132)
!132 = distinct !DILexicalBlock(scope: !128, file: !9, line: 977, column: 3)
!133 = !DILocation(line: 979, column: 5, scope: !132)
!134 = !DILocation(line: 983, column: 5, scope: !135)
!135 = distinct !DILexicalBlock(scope: !128, file: !9, line: 982, column: 3)
!136 = !DILocation(line: 984, column: 18, scope: !135)
!137 = !DILocation(line: 984, column: 12, scope: !135)
!138 = !DILocation(line: 984, column: 5, scope: !135)
!139 = !DILocation(line: 0, scope: !128)
!140 = !DILocation(line: 987, column: 1, scope: !122)
!141 = distinct !DISubprogram(name: "t1", scope: !9, file: !9, line: 988, type: !142, scopeLine: 989, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!142 = !DISubroutineType(types: !143)
!143 = !{!5, !5}
!144 = !DILocalVariable(name: "arg", arg: 1, scope: !141, file: !9, line: 988, type: !5)
!145 = !DILocation(line: 0, scope: !141)
!146 = !DILocalVariable(name: "i", scope: !141, file: !9, line: 990, type: !23)
!147 = !DILocation(line: 994, column: 5, scope: !148)
!148 = distinct !DILexicalBlock(scope: !149, file: !9, line: 993, column: 3)
!149 = distinct !DILexicalBlock(scope: !150, file: !9, line: 992, column: 3)
!150 = distinct !DILexicalBlock(scope: !141, file: !9, line: 992, column: 3)
!151 = !DILocation(line: 995, column: 11, scope: !148)
!152 = !DILocalVariable(name: "tmp", scope: !141, file: !9, line: 991, type: !11)
!153 = !DILocation(line: 996, column: 29, scope: !148)
!154 = !DILocation(line: 996, column: 5, scope: !148)
!155 = !DILocation(line: 997, column: 9, scope: !156)
!156 = distinct !DILexicalBlock(scope: !148, file: !9, line: 997, column: 9)
!157 = !DILocation(line: 997, column: 22, scope: !156)
!158 = !DILocation(line: 997, column: 9, scope: !148)
!159 = !DILocation(line: 998, column: 7, scope: !156)
!160 = !DILocation(line: 999, column: 9, scope: !148)
!161 = !DILocation(line: 1000, column: 5, scope: !148)
!162 = !DILocation(line: 1002, column: 3, scope: !141)
!163 = distinct !DISubprogram(name: "t2", scope: !9, file: !9, line: 1004, type: !142, scopeLine: 1005, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!164 = !DILocalVariable(name: "arg", arg: 1, scope: !163, file: !9, line: 1004, type: !5)
!165 = !DILocation(line: 0, scope: !163)
!166 = !DILocalVariable(name: "i", scope: !163, file: !9, line: 1006, type: !23)
!167 = !DILocation(line: 1009, column: 5, scope: !168)
!168 = distinct !DILexicalBlock(scope: !169, file: !9, line: 1008, column: 3)
!169 = distinct !DILexicalBlock(scope: !170, file: !9, line: 1007, column: 3)
!170 = distinct !DILexicalBlock(scope: !163, file: !9, line: 1007, column: 3)
!171 = !DILocation(line: 1010, column: 9, scope: !172)
!172 = distinct !DILexicalBlock(scope: !168, file: !9, line: 1010, column: 9)
!173 = !DILocation(line: 1010, column: 9, scope: !168)
!174 = !DILocation(line: 1012, column: 13, scope: !175)
!175 = distinct !DILexicalBlock(scope: !176, file: !9, line: 1012, column: 11)
!176 = distinct !DILexicalBlock(scope: !172, file: !9, line: 1011, column: 5)
!177 = !DILocation(line: 1012, column: 21, scope: !175)
!178 = !DILocation(line: 1012, column: 11, scope: !176)
!179 = !DILocation(line: 1013, column: 9, scope: !175)
!180 = !DILocation(line: 1015, column: 5, scope: !168)
!181 = !DILocation(line: 1017, column: 3, scope: !163)
!182 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 1019, type: !92, scopeLine: 1020, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !64)
!183 = !DILocation(line: 1022, column: 3, scope: !182)
!184 = !DILocalVariable(name: "id1", scope: !182, file: !9, line: 1021, type: !185)
!185 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !9, line: 292, baseType: !186)
!186 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!187 = !DILocation(line: 0, scope: !182)
!188 = !DILocation(line: 1023, column: 3, scope: !182)
!189 = !DILocalVariable(name: "id2", scope: !182, file: !9, line: 1021, type: !185)
!190 = !DILocation(line: 1024, column: 3, scope: !182)
!191 = !DILocation(line: 1025, column: 16, scope: !182)
!192 = !DILocation(line: 1025, column: 3, scope: !182)
!193 = !DILocation(line: 1026, column: 16, scope: !182)
!194 = !DILocation(line: 1026, column: 3, scope: !182)
!195 = !DILocation(line: 1027, column: 3, scope: !182)
