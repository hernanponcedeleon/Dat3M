; ModuleID = 'mutex_musl.ll'
source_filename = "benchmarks/locks/mutex_musl.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.mutex_t = type { i32, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4
@mutex = dso_local global %struct.mutex_t zeroinitializer, align 4
@shared = dso_local global i32 0, align 4
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [30 x i8] c"benchmarks/locks/mutex_musl.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@sig = internal global i32 0, align 4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  %5 = load i8*, i8** %2, align 8
  %6 = ptrtoint i8* %5 to i64
  store i64 %6, i64* %3, align 8
  call void @mutex_lock(%struct.mutex_t* noundef @mutex)
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #4
  unreachable

16:                                               ; preds = %14
  %17 = load i32, i32* @sum, align 4
  %18 = add nsw i32 %17, 1
  store i32 %18, i32* @sum, align 4
  call void @mutex_unlock(%struct.mutex_t* noundef @mutex)
  ret i8* null
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @mutex_lock(%struct.mutex_t* noundef %0) #0 {
  %2 = alloca %struct.mutex_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i8, align 1
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store %struct.mutex_t* %0, %struct.mutex_t** %2, align 8
  %10 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8
  %11 = call i32 @mutex_lock_fastpath(%struct.mutex_t* noundef %10)
  %12 = icmp ne i32 %11, 0
  br i1 %12, label %13, label %14

13:                                               ; preds = %1
  br label %46

14:                                               ; preds = %1
  br label %15

15:                                               ; preds = %40, %14
  %16 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8
  %17 = call i32 @mutex_lock_slowpath_check(%struct.mutex_t* noundef %16)
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %19, label %46

19:                                               ; preds = %15
  %20 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8
  %21 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %20, i32 0, i32 1
  store i32 1, i32* %3, align 4
  %22 = load i32, i32* %3, align 4
  %23 = atomicrmw add i32* %21, i32 %22 monotonic, align 4
  store i32 %23, i32* %4, align 4
  %24 = load i32, i32* %4, align 4
  store i32 1, i32* %5, align 4
  %25 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8
  %26 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %25, i32 0, i32 0
  store i32 2, i32* %6, align 4
  %27 = load i32, i32* %5, align 4
  %28 = load i32, i32* %6, align 4
  %29 = cmpxchg i32* %26, i32 %27, i32 %28 monotonic monotonic, align 4
  %30 = extractvalue { i32, i1 } %29, 0
  %31 = extractvalue { i32, i1 } %29, 1
  br i1 %31, label %33, label %32

32:                                               ; preds = %19
  store i32 %30, i32* %5, align 4
  br label %33

33:                                               ; preds = %32, %19
  %34 = zext i1 %31 to i8
  store i8 %34, i8* %7, align 1
  %35 = load i8, i8* %7, align 1
  %36 = trunc i8 %35 to i1
  br i1 %36, label %40, label %37

37:                                               ; preds = %33
  %38 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8
  %39 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %38, i32 0, i32 0
  call void @__futex_wait(i32* noundef %39, i32 noundef 2)
  br label %40

40:                                               ; preds = %37, %33
  %41 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8
  %42 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %41, i32 0, i32 1
  store i32 1, i32* %8, align 4
  %43 = load i32, i32* %8, align 4
  %44 = atomicrmw sub i32* %42, i32 %43 monotonic, align 4
  store i32 %44, i32* %9, align 4
  %45 = load i32, i32* %9, align 4
  br label %15, !llvm.loop !6

46:                                               ; preds = %15, %13
  ret void
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal void @mutex_unlock(%struct.mutex_t* noundef %0) #0 {
  %2 = alloca %struct.mutex_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.mutex_t* %0, %struct.mutex_t** %2, align 8
  %7 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8
  %8 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %7, i32 0, i32 0
  store i32 0, i32* %4, align 4
  %9 = load i32, i32* %4, align 4
  %10 = atomicrmw xchg i32* %8, i32 %9 release, align 4
  store i32 %10, i32* %5, align 4
  %11 = load i32, i32* %5, align 4
  store i32 %11, i32* %3, align 4
  %12 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8
  %13 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %12, i32 0, i32 1
  %14 = load atomic i32, i32* %13 monotonic, align 4
  store i32 %14, i32* %6, align 4
  %15 = load i32, i32* %6, align 4
  %16 = icmp sgt i32 %15, 0
  br i1 %16, label %20, label %17

17:                                               ; preds = %1
  %18 = load i32, i32* %3, align 4
  %19 = icmp ne i32 %18, 1
  br i1 %19, label %20, label %23

20:                                               ; preds = %17, %1
  %21 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8
  %22 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %21, i32 0, i32 0
  call void @__futex_wake(i32* noundef %22, i32 noundef 1)
  br label %23

23:                                               ; preds = %20, %17
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @mutex_init(%struct.mutex_t* noundef @mutex)
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
  %15 = call i32 @pthread_create(i64* noundef %11, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef %14) #5
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4
  unreachable

37:                                               ; preds = %35
  ret i32 0
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @mutex_init(%struct.mutex_t* noundef %0) #0 {
  %2 = alloca %struct.mutex_t*, align 8
  store %struct.mutex_t* %0, %struct.mutex_t** %2, align 8
  %3 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8
  %4 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %3, i32 0, i32 0
  store i32 0, i32* %4, align 4
  %5 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8
  %6 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %5, i32 0, i32 1
  store i32 0, i32* %6, align 4
  ret void
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @mutex_lock_fastpath(%struct.mutex_t* noundef %0) #0 {
  %2 = alloca %struct.mutex_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store %struct.mutex_t* %0, %struct.mutex_t** %2, align 8
  store i32 0, i32* %3, align 4
  %6 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8
  %7 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %6, i32 0, i32 0
  store i32 1, i32* %4, align 4
  %8 = load i32, i32* %3, align 4
  %9 = load i32, i32* %4, align 4
  %10 = cmpxchg i32* %7, i32 %8, i32 %9 acquire acquire, align 4
  %11 = extractvalue { i32, i1 } %10, 0
  %12 = extractvalue { i32, i1 } %10, 1
  br i1 %12, label %14, label %13

13:                                               ; preds = %1
  store i32 %11, i32* %3, align 4
  br label %14

14:                                               ; preds = %13, %1
  %15 = zext i1 %12 to i8
  store i8 %15, i8* %5, align 1
  %16 = load i8, i8* %5, align 1
  %17 = trunc i8 %16 to i1
  %18 = zext i1 %17 to i32
  ret i32 %18
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @mutex_lock_slowpath_check(%struct.mutex_t* noundef %0) #0 {
  %2 = alloca %struct.mutex_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store %struct.mutex_t* %0, %struct.mutex_t** %2, align 8
  store i32 0, i32* %3, align 4
  %6 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8
  %7 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %6, i32 0, i32 0
  store i32 1, i32* %4, align 4
  %8 = load i32, i32* %3, align 4
  %9 = load i32, i32* %4, align 4
  %10 = cmpxchg i32* %7, i32 %8, i32 %9 acquire acquire, align 4
  %11 = extractvalue { i32, i1 } %10, 0
  %12 = extractvalue { i32, i1 } %10, 1
  br i1 %12, label %14, label %13

13:                                               ; preds = %1
  store i32 %11, i32* %3, align 4
  br label %14

14:                                               ; preds = %13, %1
  %15 = zext i1 %12 to i8
  store i8 %15, i8* %5, align 1
  %16 = load i8, i8* %5, align 1
  %17 = trunc i8 %16 to i1
  %18 = zext i1 %17 to i32
  ret i32 %18
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @__futex_wait(i32* noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  store i32 %1, i32* %4, align 4
  %9 = load atomic i32, i32* @sig acquire, align 4
  store i32 %9, i32* %6, align 4
  %10 = load i32, i32* %6, align 4
  store i32 %10, i32* %5, align 4
  %11 = load i32*, i32** %3, align 8
  %12 = load atomic i32, i32* %11 acquire, align 4
  store i32 %12, i32* %7, align 4
  %13 = load i32, i32* %7, align 4
  %14 = load i32, i32* %4, align 4
  %15 = icmp ne i32 %13, %14
  br i1 %15, label %16, label %17

16:                                               ; preds = %2
  br label %24

17:                                               ; preds = %2
  br label %18

18:                                               ; preds = %23, %17
  %19 = load atomic i32, i32* @sig acquire, align 4
  store i32 %19, i32* %8, align 4
  %20 = load i32, i32* %8, align 4
  %21 = load i32, i32* %5, align 4
  %22 = icmp eq i32 %20, %21
  br i1 %22, label %23, label %24

23:                                               ; preds = %18
  br label %18, !llvm.loop !10

24:                                               ; preds = %18, %16
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @__futex_wake(i32* noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  store i32 %1, i32* %4, align 4
  store i32 1, i32* %5, align 4
  %7 = load i32, i32* %5, align 4
  %8 = atomicrmw add i32* @sig, i32 %7 release, align 4
  store i32 %8, i32* %6, align 4
  %9 = load i32, i32* %6, align 4
  ret void
}

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
