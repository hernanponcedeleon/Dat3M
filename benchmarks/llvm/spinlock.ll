; ModuleID = 'spinlock.ll'
source_filename = "benchmarks/locks/spinlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.spinlock_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4
@lock = dso_local global %struct.spinlock_s zeroinitializer, align 4
@shared = dso_local global i32 0, align 4
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [28 x i8] c"benchmarks/locks/spinlock.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  %5 = load i8*, i8** %2, align 8
  %6 = ptrtoint i8* %5 to i64
  store i64 %6, i64* %3, align 8
  call void @spinlock_acquire(%struct.spinlock_s* noundef @lock)
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([28 x i8], [28 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #4
  unreachable

16:                                               ; preds = %14
  %17 = load i32, i32* @sum, align 4
  %18 = add nsw i32 %17, 1
  store i32 %18, i32* @sum, align 4
  call void @spinlock_release(%struct.spinlock_s* noundef @lock)
  ret i8* null
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @spinlock_acquire(%struct.spinlock_s* noundef %0) #0 {
  %2 = alloca %struct.spinlock_s*, align 8
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  br label %3

3:                                                ; preds = %5, %1
  %4 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8
  call void @await_for_lock(%struct.spinlock_s* noundef %4)
  br label %5

5:                                                ; preds = %3
  %6 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8
  %7 = call i32 @try_get_lock(%struct.spinlock_s* noundef %6)
  %8 = icmp ne i32 %7, 0
  %9 = xor i1 %8, true
  br i1 %9, label %3, label %10, !llvm.loop !6

10:                                               ; preds = %5
  ret void
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal void @spinlock_release(%struct.spinlock_s* noundef %0) #0 {
  %2 = alloca %struct.spinlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  %4 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8
  %5 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %4, i32 0, i32 0
  store i32 0, i32* %3, align 4
  %6 = load i32, i32* %3, align 4
  store atomic i32 %6, i32* %5 release, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @spinlock_init(%struct.spinlock_s* noundef @lock)
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([28 x i8], [28 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4
  unreachable

37:                                               ; preds = %35
  ret i32 0
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @spinlock_init(%struct.spinlock_s* noundef %0) #0 {
  %2 = alloca %struct.spinlock_s*, align 8
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  %3 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8
  %4 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %3, i32 0, i32 0
  store i32 0, i32* %4, align 4
  ret void
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define internal void @await_for_lock(%struct.spinlock_s* noundef %0) #0 {
  %2 = alloca %struct.spinlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  br label %4

4:                                                ; preds = %10, %1
  %5 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8
  %6 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %5, i32 0, i32 0
  %7 = load atomic i32, i32* %6 monotonic, align 4
  store i32 %7, i32* %3, align 4
  %8 = load i32, i32* %3, align 4
  %9 = icmp ne i32 %8, 0
  br i1 %9, label %10, label %11

10:                                               ; preds = %4
  br label %4, !llvm.loop !10

11:                                               ; preds = %4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @try_get_lock(%struct.spinlock_s* noundef %0) #0 {
  %2 = alloca %struct.spinlock_s*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store %struct.spinlock_s* %0, %struct.spinlock_s** %2, align 8
  store i32 0, i32* %3, align 4
  %6 = load %struct.spinlock_s*, %struct.spinlock_s** %2, align 8
  %7 = getelementptr inbounds %struct.spinlock_s, %struct.spinlock_s* %6, i32 0, i32 0
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
