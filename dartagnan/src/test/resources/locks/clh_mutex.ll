; ModuleID = 'benchmarks/locks/clh_mutex.c'
source_filename = "benchmarks/locks/clh_mutex.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.clh_mutex_t = type { %struct.clh_mutex_node_*, [64 x i32], %struct.clh_mutex_node_* }
%struct.clh_mutex_node_ = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4
@lock = dso_local global %struct.clh_mutex_t zeroinitializer, align 8
@shared = dso_local global i32 0, align 4
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"benchmarks/locks/clh_mutex.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @clh_mutex_init(%struct.clh_mutex_t* noundef %0) #0 {
  %2 = alloca %struct.clh_mutex_t*, align 8
  %3 = alloca %struct.clh_mutex_node_*, align 8
  store %struct.clh_mutex_t* %0, %struct.clh_mutex_t** %2, align 8
  %4 = call %struct.clh_mutex_node_* @clh_mutex_create_node(i32 noundef 0)
  store %struct.clh_mutex_node_* %4, %struct.clh_mutex_node_** %3, align 8
  %5 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %3, align 8
  %6 = load %struct.clh_mutex_t*, %struct.clh_mutex_t** %2, align 8
  %7 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %6, i32 0, i32 0
  store %struct.clh_mutex_node_* %5, %struct.clh_mutex_node_** %7, align 8
  %8 = load %struct.clh_mutex_t*, %struct.clh_mutex_t** %2, align 8
  %9 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %8, i32 0, i32 2
  %10 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %3, align 8
  store %struct.clh_mutex_node_* %10, %struct.clh_mutex_node_** %9, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define internal %struct.clh_mutex_node_* @clh_mutex_create_node(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.clh_mutex_node_*, align 8
  store i32 %0, i32* %2, align 4
  %4 = call noalias i8* @malloc(i64 noundef 4) #4
  %5 = bitcast i8* %4 to %struct.clh_mutex_node_*
  store %struct.clh_mutex_node_* %5, %struct.clh_mutex_node_** %3, align 8
  %6 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %3, align 8
  %7 = getelementptr inbounds %struct.clh_mutex_node_, %struct.clh_mutex_node_* %6, i32 0, i32 0
  %8 = load i32, i32* %2, align 4
  store i32 %8, i32* %7, align 4
  %9 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %3, align 8
  ret %struct.clh_mutex_node_* %9
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @clh_mutex_destroy(%struct.clh_mutex_t* noundef %0) #0 {
  %2 = alloca %struct.clh_mutex_t*, align 8
  %3 = alloca %struct.clh_mutex_node_*, align 8
  store %struct.clh_mutex_t* %0, %struct.clh_mutex_t** %2, align 8
  %4 = load %struct.clh_mutex_t*, %struct.clh_mutex_t** %2, align 8
  %5 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %4, i32 0, i32 2
  %6 = bitcast %struct.clh_mutex_node_** %5 to i64*
  %7 = bitcast %struct.clh_mutex_node_** %3 to i64*
  %8 = load atomic i64, i64* %6 seq_cst, align 8
  store i64 %8, i64* %7, align 8
  %9 = bitcast i64* %7 to %struct.clh_mutex_node_**
  %10 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %9, align 8
  %11 = bitcast %struct.clh_mutex_node_* %10 to i8*
  call void @free(i8* noundef %11) #4
  ret void
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @clh_mutex_lock(%struct.clh_mutex_t* noundef %0) #0 {
  %2 = alloca %struct.clh_mutex_t*, align 8
  %3 = alloca %struct.clh_mutex_node_*, align 8
  %4 = alloca %struct.clh_mutex_node_*, align 8
  %5 = alloca %struct.clh_mutex_node_*, align 8
  %6 = alloca %struct.clh_mutex_node_*, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store %struct.clh_mutex_t* %0, %struct.clh_mutex_t** %2, align 8
  %10 = call %struct.clh_mutex_node_* @clh_mutex_create_node(i32 noundef 1)
  store %struct.clh_mutex_node_* %10, %struct.clh_mutex_node_** %3, align 8
  %11 = load %struct.clh_mutex_t*, %struct.clh_mutex_t** %2, align 8
  %12 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %11, i32 0, i32 2
  %13 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %3, align 8
  store %struct.clh_mutex_node_* %13, %struct.clh_mutex_node_** %5, align 8
  %14 = bitcast %struct.clh_mutex_node_** %12 to i64*
  %15 = bitcast %struct.clh_mutex_node_** %5 to i64*
  %16 = bitcast %struct.clh_mutex_node_** %6 to i64*
  %17 = load i64, i64* %15, align 8
  %18 = atomicrmw xchg i64* %14, i64 %17 seq_cst, align 8
  store i64 %18, i64* %16, align 8
  %19 = bitcast i64* %16 to %struct.clh_mutex_node_**
  %20 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %19, align 8
  store %struct.clh_mutex_node_* %20, %struct.clh_mutex_node_** %4, align 8
  %21 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %4, align 8
  %22 = getelementptr inbounds %struct.clh_mutex_node_, %struct.clh_mutex_node_* %21, i32 0, i32 0
  %23 = load atomic i32, i32* %22 acquire, align 4
  store i32 %23, i32* %8, align 4
  %24 = load i32, i32* %8, align 4
  store i32 %24, i32* %7, align 4
  %25 = load i32, i32* %7, align 4
  %26 = icmp ne i32 %25, 0
  br i1 %26, label %27, label %37

27:                                               ; preds = %1
  br label %28

28:                                               ; preds = %31, %27
  %29 = load i32, i32* %7, align 4
  %30 = icmp ne i32 %29, 0
  br i1 %30, label %31, label %36

31:                                               ; preds = %28
  %32 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %4, align 8
  %33 = getelementptr inbounds %struct.clh_mutex_node_, %struct.clh_mutex_node_* %32, i32 0, i32 0
  %34 = load atomic i32, i32* %33 acquire, align 4
  store i32 %34, i32* %9, align 4
  %35 = load i32, i32* %9, align 4
  store i32 %35, i32* %7, align 4
  br label %28, !llvm.loop !6

36:                                               ; preds = %28
  br label %37

37:                                               ; preds = %36, %1
  %38 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %4, align 8
  %39 = bitcast %struct.clh_mutex_node_* %38 to i8*
  call void @free(i8* noundef %39) #4
  %40 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %3, align 8
  %41 = load %struct.clh_mutex_t*, %struct.clh_mutex_t** %2, align 8
  %42 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %41, i32 0, i32 0
  store %struct.clh_mutex_node_* %40, %struct.clh_mutex_node_** %42, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @clh_mutex_unlock(%struct.clh_mutex_t* noundef %0) #0 {
  %2 = alloca %struct.clh_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %struct.clh_mutex_t* %0, %struct.clh_mutex_t** %2, align 8
  %4 = load %struct.clh_mutex_t*, %struct.clh_mutex_t** %2, align 8
  %5 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %4, i32 0, i32 0
  %6 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %5, align 8
  %7 = icmp eq %struct.clh_mutex_node_* %6, null
  br i1 %7, label %8, label %9

8:                                                ; preds = %1
  br label %15

9:                                                ; preds = %1
  %10 = load %struct.clh_mutex_t*, %struct.clh_mutex_t** %2, align 8
  %11 = getelementptr inbounds %struct.clh_mutex_t, %struct.clh_mutex_t* %10, i32 0, i32 0
  %12 = load %struct.clh_mutex_node_*, %struct.clh_mutex_node_** %11, align 8
  %13 = getelementptr inbounds %struct.clh_mutex_node_, %struct.clh_mutex_node_* %12, i32 0, i32 0
  store i32 0, i32* %3, align 4
  %14 = load i32, i32* %3, align 4
  store atomic i32 %14, i32* %13 release, align 4
  br label %15

15:                                               ; preds = %9, %8
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  %5 = load i8*, i8** %2, align 8
  %6 = ptrtoint i8* %5 to i64
  store i64 %6, i64* %3, align 8
  call void @clh_mutex_lock(%struct.clh_mutex_t* noundef @lock)
  %7 = load i64, i64* %3, align 8
  %8 = trunc i64 %7 to i32
  store i32 %8, i32* @shared, align 4
  %9 = load i32, i32* @shared, align 4
  store i32 %9, i32* %4, align 4
  %10 = load i32, i32* %4, align 4
  %11 = sext i32 %10 to i64
  %12 = load i64, i64* %3, align 8
  %13 = icmp eq i64 %11, %12
  br i1 %13, label %14, label %15

14:                                               ; preds = %1
  br label %16

15:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5
  unreachable

16:                                               ; preds = %14
  %17 = load i32, i32* @sum, align 4
  %18 = add nsw i32 %17, 1
  store i32 %18, i32* @sum, align 4
  call void @clh_mutex_unlock(%struct.clh_mutex_t* noundef @lock)
  ret i8* null
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @clh_mutex_init(%struct.clh_mutex_t* noundef @lock)
  store i32 0, i32* %3, align 4
  br label %5

5:                                                ; preds = %16, %0
  %6 = load i32, i32* %3, align 4
  %7 = icmp slt i32 %6, 3
  br i1 %7, label %8, label %19

8:                                                ; preds = %5
  %9 = load i32, i32* %3, align 4
  %10 = sext i32 %9 to i64
  %11 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %10
  %12 = load i32, i32* %3, align 4
  %13 = sext i32 %12 to i64
  %14 = inttoptr i64 %13 to i8*
  %15 = call i32 @pthread_create(i64* noundef %11, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef %14) #4
  br label %16

16:                                               ; preds = %8
  %17 = load i32, i32* %3, align 4
  %18 = add nsw i32 %17, 1
  store i32 %18, i32* %3, align 4
  br label %5, !llvm.loop !8

19:                                               ; preds = %5
  store i32 0, i32* %4, align 4
  br label %20

20:                                               ; preds = %29, %19
  %21 = load i32, i32* %4, align 4
  %22 = icmp slt i32 %21, 3
  br i1 %22, label %23, label %32

23:                                               ; preds = %20
  %24 = load i32, i32* %4, align 4
  %25 = sext i32 %24 to i64
  %26 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %25
  %27 = load i64, i64* %26, align 8
  %28 = call i32 @pthread_join(i64 noundef %27, i8** noundef null)
  br label %29

29:                                               ; preds = %23
  %30 = load i32, i32* %4, align 4
  %31 = add nsw i32 %30, 1
  store i32 %31, i32* %4, align 4
  br label %20, !llvm.loop !9

32:                                               ; preds = %20
  %33 = load i32, i32* @sum, align 4
  %34 = icmp eq i32 %33, 3
  br i1 %34, label %35, label %36

35:                                               ; preds = %32
  br label %37

36:                                               ; preds = %32
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5
  unreachable

37:                                               ; preds = %35
  call void @clh_mutex_destroy(%struct.clh_mutex_t* noundef @lock)
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #1

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
