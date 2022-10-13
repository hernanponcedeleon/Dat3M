; ModuleID = 'benchmarks/locks/ttas-5.c'
source_filename = "benchmarks/locks/ttas-5.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ttaslock_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4
@lock = dso_local global %struct.ttaslock_s zeroinitializer, align 4
@shared = dso_local global i32 0, align 4
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [26 x i8] c"benchmarks/locks/ttas-5.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"sum == 5\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  %5 = load i8*, i8** %2, align 8
  %6 = ptrtoint i8* %5 to i64
  store i64 %6, i64* %3, align 8
  call void @ttaslock_acquire(%struct.ttaslock_s* noundef @lock)
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.1, i64 0, i64 0), i32 noundef 76, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #4
  unreachable

16:                                               ; preds = %14
  %17 = load i32, i32* @sum, align 4
  %18 = add nsw i32 %17, 1
  store i32 %18, i32* @sum, align 4
  call void @ttaslock_release(%struct.ttaslock_s* noundef @lock)
  ret i8* null
}

; Function Attrs: noinline nounwind uwtable
define internal void @ttaslock_acquire(%struct.ttaslock_s* noundef %0) #0 {
  %2 = alloca %struct.ttaslock_s*, align 8
  store %struct.ttaslock_s* %0, %struct.ttaslock_s** %2, align 8
  br label %3

3:                                                ; preds = %1, %9
  %4 = load %struct.ttaslock_s*, %struct.ttaslock_s** %2, align 8
  call void @await_for_lock(%struct.ttaslock_s* noundef %4)
  %5 = load %struct.ttaslock_s*, %struct.ttaslock_s** %2, align 8
  %6 = call i32 @try_acquire(%struct.ttaslock_s* noundef %5)
  %7 = icmp ne i32 %6, 0
  br i1 %7, label %9, label %8

8:                                                ; preds = %3
  ret void

9:                                                ; preds = %3
  br label %3
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define internal void @ttaslock_release(%struct.ttaslock_s* noundef %0) #0 {
  %2 = alloca %struct.ttaslock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.ttaslock_s* %0, %struct.ttaslock_s** %2, align 8
  %4 = load %struct.ttaslock_s*, %struct.ttaslock_s** %2, align 8
  %5 = getelementptr inbounds %struct.ttaslock_s, %struct.ttaslock_s* %4, i32 0, i32 0
  store i32 0, i32* %3, align 4
  %6 = load i32, i32* %3, align 4
  store atomic i32 %6, i32* %5 release, align 4
  ret void
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @ttaslock_init(%struct.ttaslock_s* noundef @lock)
  %7 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef null) #5
  %8 = call i32 @pthread_create(i64* noundef %3, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 1 to i8*)) #5
  %9 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 2 to i8*)) #5
  %10 = call i32 @pthread_create(i64* noundef %5, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 3 to i8*)) #5
  %11 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef inttoptr (i64 4 to i8*)) #5
  %12 = load i64, i64* %2, align 8
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null)
  %14 = load i64, i64* %3, align 8
  %15 = call i32 @pthread_join(i64 noundef %14, i8** noundef null)
  %16 = load i64, i64* %4, align 8
  %17 = call i32 @pthread_join(i64 noundef %16, i8** noundef null)
  %18 = load i64, i64* %5, align 8
  %19 = call i32 @pthread_join(i64 noundef %18, i8** noundef null)
  %20 = load i64, i64* %6, align 8
  %21 = call i32 @pthread_join(i64 noundef %20, i8** noundef null)
  %22 = load i32, i32* @sum, align 4
  %23 = icmp eq i32 %22, 5
  br i1 %23, label %24, label %25

24:                                               ; preds = %0
  br label %26

25:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.1, i64 0, i64 0), i32 noundef 102, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4
  unreachable

26:                                               ; preds = %24
  ret i32 0
}

; Function Attrs: noinline nounwind uwtable
define internal void @ttaslock_init(%struct.ttaslock_s* noundef %0) #0 {
  %2 = alloca %struct.ttaslock_s*, align 8
  store %struct.ttaslock_s* %0, %struct.ttaslock_s** %2, align 8
  %3 = load %struct.ttaslock_s*, %struct.ttaslock_s** %2, align 8
  %4 = getelementptr inbounds %struct.ttaslock_s, %struct.ttaslock_s* %3, i32 0, i32 0
  store i32 0, i32* %4, align 4
  ret void
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @await_for_lock(%struct.ttaslock_s* noundef %0) #0 {
  %2 = alloca %struct.ttaslock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.ttaslock_s* %0, %struct.ttaslock_s** %2, align 8
  br label %4

4:                                                ; preds = %10, %1
  %5 = load %struct.ttaslock_s*, %struct.ttaslock_s** %2, align 8
  %6 = getelementptr inbounds %struct.ttaslock_s, %struct.ttaslock_s* %5, i32 0, i32 0
  %7 = load atomic i32, i32* %6 monotonic, align 4
  store i32 %7, i32* %3, align 4
  %8 = load i32, i32* %3, align 4
  %9 = icmp ne i32 %8, 0
  br i1 %9, label %10, label %11

10:                                               ; preds = %4
  br label %4, !llvm.loop !6

11:                                               ; preds = %4
  ret void
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @try_acquire(%struct.ttaslock_s* noundef %0) #0 {
  %2 = alloca %struct.ttaslock_s*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %struct.ttaslock_s* %0, %struct.ttaslock_s** %2, align 8
  %5 = load %struct.ttaslock_s*, %struct.ttaslock_s** %2, align 8
  %6 = getelementptr inbounds %struct.ttaslock_s, %struct.ttaslock_s* %5, i32 0, i32 0
  store i32 1, i32* %3, align 4
  %7 = load i32, i32* %3, align 4
  %8 = atomicrmw xchg i32* %6, i32 %7 acquire, align 4
  store i32 %8, i32* %4, align 4
  %9 = load i32, i32* %4, align 4
  ret i32 %9
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
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
!5 = !{!"Ubuntu clang version 14.0.6-++20220827082222+f28c006a5895-1~exp1~20220827202233.158"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
