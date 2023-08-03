; ModuleID = 'wsq.ll'
source_filename = "benchmarks/lfds/wsq.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.WorkStealQueue = type { %union.pthread_mutex_t, i32, i32, i32, i32, [16 x %struct.Obj*], i32 }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%struct.Obj = type { i32 }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@.str = private unnamed_addr constant [14 x i8] c"r->field == 1\00", align 1
@.str.1 = private unnamed_addr constant [22 x i8] c"benchmarks/lfds/wsq.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [18 x i8] c"void check(Obj *)\00", align 1
@q = dso_local global %struct.WorkStealQueue zeroinitializer, align 8
@.str.2 = private unnamed_addr constant [20 x i8] c"newsize < q.MaxSize\00", align 1
@__PRETTY_FUNCTION__.syncPush = private unnamed_addr constant [21 x i8] c"void syncPush(Obj *)\00", align 1
@.str.3 = private unnamed_addr constant [15 x i8] c"count < q.mask\00", align 1
@items = dso_local global [4 x %struct.Obj] zeroinitializer, align 16

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @init_Obj(%struct.Obj* noundef %0) #0 {
  %2 = alloca %struct.Obj*, align 8
  store %struct.Obj* %0, %struct.Obj** %2, align 8
  %3 = load %struct.Obj*, %struct.Obj** %2, align 8
  %4 = getelementptr inbounds %struct.Obj, %struct.Obj* %3, i32 0, i32 0
  store i32 0, i32* %4, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @operation(%struct.Obj* noundef %0) #0 {
  %2 = alloca %struct.Obj*, align 8
  store %struct.Obj* %0, %struct.Obj** %2, align 8
  %3 = load %struct.Obj*, %struct.Obj** %2, align 8
  %4 = getelementptr inbounds %struct.Obj, %struct.Obj* %3, i32 0, i32 0
  %5 = load i32, i32* %4, align 4
  %6 = add nsw i32 %5, 1
  store i32 %6, i32* %4, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @check(%struct.Obj* noundef %0) #0 {
  %2 = alloca %struct.Obj*, align 8
  store %struct.Obj* %0, %struct.Obj** %2, align 8
  %3 = load %struct.Obj*, %struct.Obj** %2, align 8
  %4 = getelementptr inbounds %struct.Obj, %struct.Obj* %3, i32 0, i32 0
  %5 = load i32, i32* %4, align 4
  %6 = icmp eq i32 %5, 1
  br i1 %6, label %7, label %8

7:                                                ; preds = %1
  br label %9

8:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1, i64 0, i64 0), i32 noundef 37, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #4
  unreachable

9:                                                ; preds = %7
  ret void
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @readV(i32* noundef %0) #0 {
  %2 = alloca i32*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store i32* %0, i32** %2, align 8
  store i32 0, i32* %3, align 4
  %6 = load i32*, i32** %2, align 8
  store i32 0, i32* %4, align 4
  %7 = load i32, i32* %3, align 4
  %8 = load i32, i32* %4, align 4
  %9 = cmpxchg i32* %6, i32 %7, i32 %8 seq_cst seq_cst, align 4
  %10 = extractvalue { i32, i1 } %9, 0
  %11 = extractvalue { i32, i1 } %9, 1
  br i1 %11, label %13, label %12

12:                                               ; preds = %1
  store i32 %10, i32* %3, align 4
  br label %13

13:                                               ; preds = %12, %1
  %14 = zext i1 %11 to i8
  store i8 %14, i8* %5, align 1
  %15 = load i8, i8* %5, align 1
  %16 = trunc i8 %15 to i1
  %17 = load i32, i32* %3, align 4
  ret i32 %17
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @writeV(i32* noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  store i32 %1, i32* %4, align 4
  %7 = load i32*, i32** %3, align 8
  %8 = load i32, i32* %4, align 4
  store i32 %8, i32* %5, align 4
  %9 = load i32, i32* %5, align 4
  %10 = atomicrmw xchg i32* %7, i32 %9 seq_cst, align 4
  store i32 %10, i32* %6, align 4
  %11 = load i32, i32* %6, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @init_WSQ(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  store i32 1048576, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 1), align 8
  store i32 1024, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 2), align 4
  %3 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0), %union.pthread_mutexattr_t* noundef null) #5
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef 0)
  %4 = load i32, i32* %2, align 4
  %5 = sub nsw i32 %4, 1
  store i32 %5, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef 0)
  ret void
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @destroy_WSQ() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local zeroext i1 @steal(%struct.Obj** noundef %0) #0 {
  %2 = alloca %struct.Obj**, align 8
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.Obj** %0, %struct.Obj*** %2, align 8
  %6 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #5
  %7 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3))
  store i32 %7, i32* %4, align 4
  %8 = load i32, i32* %4, align 4
  %9 = add nsw i32 %8, 1
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef %9)
  %10 = load i32, i32* %4, align 4
  %11 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4))
  %12 = icmp slt i32 %10, %11
  br i1 %12, label %13, label %22

13:                                               ; preds = %1
  %14 = load i32, i32* %4, align 4
  %15 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8
  %16 = and i32 %14, %15
  store i32 %16, i32* %5, align 4
  %17 = load i32, i32* %5, align 4
  %18 = sext i32 %17 to i64
  %19 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %18
  %20 = load %struct.Obj*, %struct.Obj** %19, align 8
  %21 = load %struct.Obj**, %struct.Obj*** %2, align 8
  store %struct.Obj* %20, %struct.Obj** %21, align 8
  store i8 1, i8* %3, align 1
  br label %24

22:                                               ; preds = %1
  %23 = load i32, i32* %4, align 4
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef %23)
  store i8 0, i8* %3, align 1
  br label %24

24:                                               ; preds = %22, %13
  %25 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #5
  %26 = load i8, i8* %3, align 1
  %27 = trunc i8 %26 to i1
  ret i1 %27
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local zeroext i1 @syncPop(%struct.Obj** noundef %0) #0 {
  %2 = alloca %struct.Obj**, align 8
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.Obj** %0, %struct.Obj*** %2, align 8
  %6 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #5
  %7 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4))
  %8 = sub nsw i32 %7, 1
  store i32 %8, i32* %4, align 4
  %9 = load i32, i32* %4, align 4
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %9)
  %10 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3))
  %11 = load i32, i32* %4, align 4
  %12 = icmp sle i32 %10, %11
  br i1 %12, label %13, label %22

13:                                               ; preds = %1
  %14 = load i32, i32* %4, align 4
  %15 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8
  %16 = and i32 %14, %15
  store i32 %16, i32* %5, align 4
  %17 = load i32, i32* %5, align 4
  %18 = sext i32 %17 to i64
  %19 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %18
  %20 = load %struct.Obj*, %struct.Obj** %19, align 8
  %21 = load %struct.Obj**, %struct.Obj*** %2, align 8
  store %struct.Obj* %20, %struct.Obj** %21, align 8
  store i8 1, i8* %3, align 1
  br label %25

22:                                               ; preds = %1
  %23 = load i32, i32* %4, align 4
  %24 = add nsw i32 %23, 1
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %24)
  store i8 0, i8* %3, align 1
  br label %25

25:                                               ; preds = %22, %13
  %26 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3))
  %27 = load i32, i32* %4, align 4
  %28 = icmp sgt i32 %26, %27
  br i1 %28, label %29, label %30

29:                                               ; preds = %25
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef 0)
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef 0)
  store i8 0, i8* %3, align 1
  br label %30

30:                                               ; preds = %29, %25
  %31 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #5
  %32 = load i8, i8* %3, align 1
  %33 = trunc i8 %32 to i1
  ret i1 %33
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local zeroext i1 @pop(%struct.Obj** noundef %0) #0 {
  %2 = alloca i1, align 1
  %3 = alloca %struct.Obj**, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.Obj** %0, %struct.Obj*** %3, align 8
  %6 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4))
  %7 = sub nsw i32 %6, 1
  store i32 %7, i32* %4, align 4
  %8 = load i32, i32* %4, align 4
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %8)
  %9 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3))
  %10 = load i32, i32* %4, align 4
  %11 = icmp sle i32 %9, %10
  br i1 %11, label %12, label %21

12:                                               ; preds = %1
  %13 = load i32, i32* %4, align 4
  %14 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8
  %15 = and i32 %13, %14
  store i32 %15, i32* %5, align 4
  %16 = load i32, i32* %5, align 4
  %17 = sext i32 %16 to i64
  %18 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %17
  %19 = load %struct.Obj*, %struct.Obj** %18, align 8
  %20 = load %struct.Obj**, %struct.Obj*** %3, align 8
  store %struct.Obj* %19, %struct.Obj** %20, align 8
  store i1 true, i1* %2, align 1
  br label %26

21:                                               ; preds = %1
  %22 = load i32, i32* %4, align 4
  %23 = add nsw i32 %22, 1
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %23)
  %24 = load %struct.Obj**, %struct.Obj*** %3, align 8
  %25 = call zeroext i1 @syncPop(%struct.Obj** noundef %24)
  store i1 %25, i1* %2, align 1
  br label %26

26:                                               ; preds = %21, %12
  %27 = load i1, i1* %2, align 1
  ret i1 %27
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @syncPush(%struct.Obj* noundef %0) #0 {
  %2 = alloca %struct.Obj*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca [16 x %struct.Obj*], align 16
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store %struct.Obj* %0, %struct.Obj** %2, align 8
  %11 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #5
  %12 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3))
  store i32 %12, i32* %3, align 4
  %13 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4))
  %14 = load i32, i32* %3, align 4
  %15 = sub nsw i32 %13, %14
  store i32 %15, i32* %4, align 4
  %16 = load i32, i32* %3, align 4
  %17 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8
  %18 = and i32 %16, %17
  store i32 %18, i32* %3, align 4
  %19 = load i32, i32* %3, align 4
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef %19)
  %20 = load i32, i32* %3, align 4
  %21 = load i32, i32* %4, align 4
  %22 = add nsw i32 %20, %21
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %22)
  %23 = load i32, i32* %4, align 4
  %24 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8
  %25 = icmp sge i32 %23, %24
  br i1 %25, label %26, label %83

26:                                               ; preds = %1
  %27 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8
  %28 = icmp eq i32 %27, 0
  br i1 %28, label %29, label %31

29:                                               ; preds = %26
  %30 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 2), align 4
  br label %35

31:                                               ; preds = %26
  %32 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8
  %33 = add nsw i32 %32, 1
  %34 = mul nsw i32 2, %33
  br label %35

35:                                               ; preds = %31, %29
  %36 = phi i32 [ %30, %29 ], [ %34, %31 ]
  store i32 %36, i32* %5, align 4
  %37 = load i32, i32* %5, align 4
  %38 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 1), align 8
  %39 = icmp slt i32 %37, %38
  br i1 %39, label %40, label %41

40:                                               ; preds = %35
  br label %42

41:                                               ; preds = %35
  call void @__assert_fail(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1, i64 0, i64 0), i32 noundef 204, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.syncPush, i64 0, i64 0)) #4
  unreachable

42:                                               ; preds = %40
  store i32 0, i32* %7, align 4
  br label %43

43:                                               ; preds = %60, %42
  %44 = load i32, i32* %7, align 4
  %45 = load i32, i32* %4, align 4
  %46 = icmp slt i32 %44, %45
  br i1 %46, label %47, label %63

47:                                               ; preds = %43
  %48 = load i32, i32* %3, align 4
  %49 = load i32, i32* %7, align 4
  %50 = add nsw i32 %48, %49
  %51 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8
  %52 = and i32 %50, %51
  store i32 %52, i32* %8, align 4
  %53 = load i32, i32* %8, align 4
  %54 = sext i32 %53 to i64
  %55 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %54
  %56 = load %struct.Obj*, %struct.Obj** %55, align 8
  %57 = load i32, i32* %7, align 4
  %58 = sext i32 %57 to i64
  %59 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* %6, i64 0, i64 %58
  store %struct.Obj* %56, %struct.Obj** %59, align 8
  br label %60

60:                                               ; preds = %47
  %61 = load i32, i32* %7, align 4
  %62 = add nsw i32 %61, 1
  store i32 %62, i32* %7, align 4
  br label %43, !llvm.loop !6

63:                                               ; preds = %43
  store i32 0, i32* %7, align 4
  br label %64

64:                                               ; preds = %76, %63
  %65 = load i32, i32* %7, align 4
  %66 = load i32, i32* %5, align 4
  %67 = icmp slt i32 %65, %66
  br i1 %67, label %68, label %79

68:                                               ; preds = %64
  %69 = load i32, i32* %7, align 4
  %70 = sext i32 %69 to i64
  %71 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* %6, i64 0, i64 %70
  %72 = load %struct.Obj*, %struct.Obj** %71, align 8
  %73 = load i32, i32* %7, align 4
  %74 = sext i32 %73 to i64
  %75 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %74
  store %struct.Obj* %72, %struct.Obj** %75, align 8
  br label %76

76:                                               ; preds = %68
  %77 = load i32, i32* %7, align 4
  %78 = add nsw i32 %77, 1
  store i32 %78, i32* %7, align 4
  br label %64, !llvm.loop !8

79:                                               ; preds = %64
  %80 = load i32, i32* %5, align 4
  %81 = sub nsw i32 %80, 1
  store i32 %81, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef 0)
  %82 = load i32, i32* %4, align 4
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %82)
  br label %83

83:                                               ; preds = %79, %1
  %84 = load i32, i32* %4, align 4
  %85 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8
  %86 = icmp slt i32 %84, %85
  br i1 %86, label %87, label %88

87:                                               ; preds = %83
  br label %89

88:                                               ; preds = %83
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1, i64 0, i64 0), i32 noundef 221, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.syncPush, i64 0, i64 0)) #4
  unreachable

89:                                               ; preds = %87
  %90 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4))
  store i32 %90, i32* %9, align 4
  %91 = load i32, i32* %9, align 4
  %92 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8
  %93 = and i32 %91, %92
  store i32 %93, i32* %10, align 4
  %94 = load %struct.Obj*, %struct.Obj** %2, align 8
  %95 = load i32, i32* %10, align 4
  %96 = sext i32 %95 to i64
  %97 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %96
  store %struct.Obj* %94, %struct.Obj** %97, align 8
  %98 = load i32, i32* %9, align 4
  %99 = add nsw i32 %98, 1
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %99)
  %100 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #5
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @push(%struct.Obj* noundef %0) #0 {
  %2 = alloca %struct.Obj*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %struct.Obj* %0, %struct.Obj** %2, align 8
  %5 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4))
  store i32 %5, i32* %3, align 4
  %6 = load i32, i32* %3, align 4
  %7 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3))
  %8 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8
  %9 = add nsw i32 %7, %8
  %10 = icmp slt i32 %6, %9
  br i1 %10, label %11, label %25

11:                                               ; preds = %1
  %12 = load i32, i32* %3, align 4
  %13 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 1), align 8
  %14 = icmp slt i32 %12, %13
  br i1 %14, label %15, label %25

15:                                               ; preds = %11
  %16 = load i32, i32* %3, align 4
  %17 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8
  %18 = and i32 %16, %17
  store i32 %18, i32* %4, align 4
  %19 = load %struct.Obj*, %struct.Obj** %2, align 8
  %20 = load i32, i32* %4, align 4
  %21 = sext i32 %20 to i64
  %22 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %21
  store %struct.Obj* %19, %struct.Obj** %22, align 8
  %23 = load i32, i32* %3, align 4
  %24 = add nsw i32 %23, 1
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %24)
  br label %27

25:                                               ; preds = %11, %1
  %26 = load %struct.Obj*, %struct.Obj** %2, align 8
  call void @syncPush(%struct.Obj* noundef %26)
  br label %27

27:                                               ; preds = %25, %15
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @stealer(i8* noundef %0) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.Obj*, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  store i32 0, i32* %4, align 4
  br label %5

5:                                                ; preds = %13, %1
  %6 = load i32, i32* %4, align 4
  %7 = icmp slt i32 %6, 1
  br i1 %7, label %8, label %16

8:                                                ; preds = %5
  %9 = call zeroext i1 @steal(%struct.Obj** noundef %3)
  br i1 %9, label %10, label %12

10:                                               ; preds = %8
  %11 = load %struct.Obj*, %struct.Obj** %3, align 8
  call void @operation(%struct.Obj* noundef %11)
  br label %12

12:                                               ; preds = %10, %8
  br label %13

13:                                               ; preds = %12
  %14 = load i32, i32* %4, align 4
  %15 = add nsw i32 %14, 1
  store i32 %15, i32* %4, align 4
  br label %5, !llvm.loop !9

16:                                               ; preds = %5
  ret i8* null
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca %struct.Obj*, align 8
  %7 = alloca i32, align 4
  %8 = alloca %struct.Obj*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @init_WSQ(i32 noundef 2)
  store i32 0, i32* %3, align 4
  br label %11

11:                                               ; preds = %18, %0
  %12 = load i32, i32* %3, align 4
  %13 = icmp slt i32 %12, 4
  br i1 %13, label %14, label %21

14:                                               ; preds = %11
  %15 = load i32, i32* %3, align 4
  %16 = sext i32 %15 to i64
  %17 = getelementptr inbounds [4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 %16
  call void @init_Obj(%struct.Obj* noundef %17)
  br label %18

18:                                               ; preds = %14
  %19 = load i32, i32* %3, align 4
  %20 = add nsw i32 %19, 1
  store i32 %20, i32* %3, align 4
  br label %11, !llvm.loop !10

21:                                               ; preds = %11
  store i32 0, i32* %4, align 4
  br label %22

22:                                               ; preds = %30, %21
  %23 = load i32, i32* %4, align 4
  %24 = icmp slt i32 %23, 2
  br i1 %24, label %25, label %33

25:                                               ; preds = %22
  %26 = load i32, i32* %4, align 4
  %27 = sext i32 %26 to i64
  %28 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 %27
  %29 = call i32 @pthread_create(i64* noundef %28, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @stealer, i8* noundef null) #5
  br label %30

30:                                               ; preds = %25
  %31 = load i32, i32* %4, align 4
  %32 = add nsw i32 %31, 1
  store i32 %32, i32* %4, align 4
  br label %22, !llvm.loop !11

33:                                               ; preds = %22
  store i32 0, i32* %5, align 4
  br label %34

34:                                               ; preds = %51, %33
  %35 = load i32, i32* %5, align 4
  %36 = icmp slt i32 %35, 2
  br i1 %36, label %37, label %54

37:                                               ; preds = %34
  %38 = load i32, i32* %5, align 4
  %39 = mul nsw i32 2, %38
  %40 = sext i32 %39 to i64
  %41 = getelementptr inbounds [4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 %40
  call void @push(%struct.Obj* noundef %41)
  %42 = load i32, i32* %5, align 4
  %43 = mul nsw i32 2, %42
  %44 = add nsw i32 %43, 1
  %45 = sext i32 %44 to i64
  %46 = getelementptr inbounds [4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 %45
  call void @push(%struct.Obj* noundef %46)
  %47 = call zeroext i1 @pop(%struct.Obj** noundef %6)
  br i1 %47, label %48, label %50

48:                                               ; preds = %37
  %49 = load %struct.Obj*, %struct.Obj** %6, align 8
  call void @operation(%struct.Obj* noundef %49)
  br label %50

50:                                               ; preds = %48, %37
  br label %51

51:                                               ; preds = %50
  %52 = load i32, i32* %5, align 4
  %53 = add nsw i32 %52, 1
  store i32 %53, i32* %5, align 4
  br label %34, !llvm.loop !12

54:                                               ; preds = %34
  store i32 0, i32* %7, align 4
  br label %55

55:                                               ; preds = %63, %54
  %56 = load i32, i32* %7, align 4
  %57 = icmp slt i32 %56, 2
  br i1 %57, label %58, label %66

58:                                               ; preds = %55
  %59 = call zeroext i1 @pop(%struct.Obj** noundef %8)
  br i1 %59, label %60, label %62

60:                                               ; preds = %58
  %61 = load %struct.Obj*, %struct.Obj** %8, align 8
  call void @operation(%struct.Obj* noundef %61)
  br label %62

62:                                               ; preds = %60, %58
  br label %63

63:                                               ; preds = %62
  %64 = load i32, i32* %7, align 4
  %65 = add nsw i32 %64, 1
  store i32 %65, i32* %7, align 4
  br label %55, !llvm.loop !13

66:                                               ; preds = %55
  store i32 0, i32* %9, align 4
  br label %67

67:                                               ; preds = %76, %66
  %68 = load i32, i32* %9, align 4
  %69 = icmp slt i32 %68, 2
  br i1 %69, label %70, label %79

70:                                               ; preds = %67
  %71 = load i32, i32* %9, align 4
  %72 = sext i32 %71 to i64
  %73 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 %72
  %74 = load i64, i64* %73, align 8
  %75 = call i32 @pthread_join(i64 noundef %74, i8** noundef null)
  br label %76

76:                                               ; preds = %70
  %77 = load i32, i32* %9, align 4
  %78 = add nsw i32 %77, 1
  store i32 %78, i32* %9, align 4
  br label %67, !llvm.loop !14

79:                                               ; preds = %67
  store i32 0, i32* %10, align 4
  br label %80

80:                                               ; preds = %87, %79
  %81 = load i32, i32* %10, align 4
  %82 = icmp slt i32 %81, 4
  br i1 %82, label %83, label %90

83:                                               ; preds = %80
  %84 = load i32, i32* %10, align 4
  %85 = sext i32 %84 to i64
  %86 = getelementptr inbounds [4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 %85
  call void @check(%struct.Obj* noundef %86)
  br label %87

87:                                               ; preds = %83
  %88 = load i32, i32* %10, align 4
  %89 = add nsw i32 %88, 1
  store i32 %89, i32* %10, align 4
  br label %80, !llvm.loop !15

90:                                               ; preds = %80
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind }
attributes #5 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 14.0.6"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = distinct !{!12, !7}
!13 = distinct !{!13, !7}
!14 = distinct !{!14, !7}
!15 = distinct !{!15, !7}
