; ModuleID = 'linuxrwlock.ll'
source_filename = "benchmarks/locks/linuxrwlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.rwlock_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4
@mylock = dso_local global %union.rwlock_t zeroinitializer, align 4
@shareddata = dso_local global i32 0, align 4
@.str = private unnamed_addr constant [16 x i8] c"r == shareddata\00", align 1
@.str.1 = private unnamed_addr constant [31 x i8] c"benchmarks/locks/linuxrwlock.c\00", align 1
@__PRETTY_FUNCTION__.threadR = private unnamed_addr constant [22 x i8] c"void *threadR(void *)\00", align 1
@.str.2 = private unnamed_addr constant [17 x i8] c"42 == shareddata\00", align 1
@__PRETTY_FUNCTION__.threadW = private unnamed_addr constant [22 x i8] c"void *threadW(void *)\00", align 1
@__PRETTY_FUNCTION__.threadRW = private unnamed_addr constant [23 x i8] c"void *threadRW(void *)\00", align 1
@.str.3 = private unnamed_addr constant [29 x i8] c"sum == NWTHREADS + NWTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @threadR(i8* noundef %0) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @read_lock(%union.rwlock_t* noundef @mylock)
  %4 = load volatile i32, i32* @shareddata, align 4
  store i32 %4, i32* %3, align 4
  %5 = load i32, i32* %3, align 4
  %6 = load volatile i32, i32* @shareddata, align 4
  %7 = icmp eq i32 %5, %6
  br i1 %7, label %8, label %9

8:                                                ; preds = %1
  br label %10

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.1, i64 0, i64 0), i32 noundef 26, i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @__PRETTY_FUNCTION__.threadR, i64 0, i64 0)) #4
  unreachable

10:                                               ; preds = %8
  call void @read_unlock(%union.rwlock_t* noundef @mylock)
  ret i8* null
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @read_lock(%union.rwlock_t* noundef %0) #0 {
  %2 = alloca %union.rwlock_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store %union.rwlock_t* %0, %union.rwlock_t** %2, align 8
  %11 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8
  %12 = bitcast %union.rwlock_t* %11 to i32*
  store i32 1, i32* %4, align 4
  %13 = load i32, i32* %4, align 4
  %14 = atomicrmw sub i32* %12, i32 %13 acquire, align 4
  store i32 %14, i32* %5, align 4
  %15 = load i32, i32* %5, align 4
  store i32 %15, i32* %3, align 4
  br label %16

16:                                               ; preds = %32, %1
  %17 = load i32, i32* %3, align 4
  %18 = icmp sle i32 %17, 0
  br i1 %18, label %19, label %38

19:                                               ; preds = %16
  %20 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8
  %21 = bitcast %union.rwlock_t* %20 to i32*
  store i32 1, i32* %6, align 4
  %22 = load i32, i32* %6, align 4
  %23 = atomicrmw add i32* %21, i32 %22 monotonic, align 4
  store i32 %23, i32* %7, align 4
  %24 = load i32, i32* %7, align 4
  br label %25

25:                                               ; preds = %31, %19
  %26 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8
  %27 = bitcast %union.rwlock_t* %26 to i32*
  %28 = load atomic i32, i32* %27 monotonic, align 4
  store i32 %28, i32* %8, align 4
  %29 = load i32, i32* %8, align 4
  %30 = icmp sle i32 %29, 0
  br i1 %30, label %31, label %32

31:                                               ; preds = %25
  br label %25, !llvm.loop !6

32:                                               ; preds = %25
  %33 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8
  %34 = bitcast %union.rwlock_t* %33 to i32*
  store i32 1, i32* %9, align 4
  %35 = load i32, i32* %9, align 4
  %36 = atomicrmw sub i32* %34, i32 %35 acquire, align 4
  store i32 %36, i32* %10, align 4
  %37 = load i32, i32* %10, align 4
  store i32 %37, i32* %3, align 4
  br label %16, !llvm.loop !8

38:                                               ; preds = %16
  ret void
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal void @read_unlock(%union.rwlock_t* noundef %0) #0 {
  %2 = alloca %union.rwlock_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %union.rwlock_t* %0, %union.rwlock_t** %2, align 8
  %5 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8
  %6 = bitcast %union.rwlock_t* %5 to i32*
  store i32 1, i32* %3, align 4
  %7 = load i32, i32* %3, align 4
  %8 = atomicrmw add i32* %6, i32 %7 release, align 4
  store i32 %8, i32* %4, align 4
  %9 = load i32, i32* %4, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @threadW(i8* noundef %0) #0 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @write_lock(%union.rwlock_t* noundef @mylock)
  store volatile i32 42, i32* @shareddata, align 4
  %3 = load volatile i32, i32* @shareddata, align 4
  %4 = icmp eq i32 42, %3
  br i1 %4, label %5, label %6

5:                                                ; preds = %1
  br label %7

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.1, i64 0, i64 0), i32 noundef 36, i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @__PRETTY_FUNCTION__.threadW, i64 0, i64 0)) #4
  unreachable

7:                                                ; preds = %5
  %8 = load i32, i32* @sum, align 4
  %9 = add nsw i32 %8, 1
  store i32 %9, i32* @sum, align 4
  call void @write_unlock(%union.rwlock_t* noundef @mylock)
  ret i8* null
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @write_lock(%union.rwlock_t* noundef %0) #0 {
  %2 = alloca %union.rwlock_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store %union.rwlock_t* %0, %union.rwlock_t** %2, align 8
  %11 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8
  %12 = bitcast %union.rwlock_t* %11 to i32*
  store i32 1048576, i32* %4, align 4
  %13 = load i32, i32* %4, align 4
  %14 = atomicrmw sub i32* %12, i32 %13 acquire, align 4
  store i32 %14, i32* %5, align 4
  %15 = load i32, i32* %5, align 4
  store i32 %15, i32* %3, align 4
  br label %16

16:                                               ; preds = %32, %1
  %17 = load i32, i32* %3, align 4
  %18 = icmp ne i32 %17, 1048576
  br i1 %18, label %19, label %38

19:                                               ; preds = %16
  %20 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8
  %21 = bitcast %union.rwlock_t* %20 to i32*
  store i32 1048576, i32* %6, align 4
  %22 = load i32, i32* %6, align 4
  %23 = atomicrmw add i32* %21, i32 %22 monotonic, align 4
  store i32 %23, i32* %7, align 4
  %24 = load i32, i32* %7, align 4
  br label %25

25:                                               ; preds = %31, %19
  %26 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8
  %27 = bitcast %union.rwlock_t* %26 to i32*
  %28 = load atomic i32, i32* %27 monotonic, align 4
  store i32 %28, i32* %8, align 4
  %29 = load i32, i32* %8, align 4
  %30 = icmp ne i32 %29, 1048576
  br i1 %30, label %31, label %32

31:                                               ; preds = %25
  br label %25, !llvm.loop !9

32:                                               ; preds = %25
  %33 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8
  %34 = bitcast %union.rwlock_t* %33 to i32*
  store i32 1048576, i32* %9, align 4
  %35 = load i32, i32* %9, align 4
  %36 = atomicrmw sub i32* %34, i32 %35 acquire, align 4
  store i32 %36, i32* %10, align 4
  %37 = load i32, i32* %10, align 4
  store i32 %37, i32* %3, align 4
  br label %16, !llvm.loop !10

38:                                               ; preds = %16
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @write_unlock(%union.rwlock_t* noundef %0) #0 {
  %2 = alloca %union.rwlock_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %union.rwlock_t* %0, %union.rwlock_t** %2, align 8
  %5 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8
  %6 = bitcast %union.rwlock_t* %5 to i32*
  store i32 1048576, i32* %3, align 4
  %7 = load i32, i32* %3, align 4
  %8 = atomicrmw add i32* %6, i32 %7 release, align 4
  store i32 %8, i32* %4, align 4
  %9 = load i32, i32* %4, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @threadRW(i8* noundef %0) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @read_lock(%union.rwlock_t* noundef @mylock)
  %4 = load volatile i32, i32* @shareddata, align 4
  store i32 %4, i32* %3, align 4
  %5 = load i32, i32* %3, align 4
  %6 = load volatile i32, i32* @shareddata, align 4
  %7 = icmp eq i32 %5, %6
  br i1 %7, label %8, label %9

8:                                                ; preds = %1
  br label %10

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.1, i64 0, i64 0), i32 noundef 47, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.threadRW, i64 0, i64 0)) #4
  unreachable

10:                                               ; preds = %8
  call void @read_unlock(%union.rwlock_t* noundef @mylock)
  call void @write_lock(%union.rwlock_t* noundef @mylock)
  store volatile i32 42, i32* @shareddata, align 4
  %11 = load volatile i32, i32* @shareddata, align 4
  %12 = icmp eq i32 42, %11
  br i1 %12, label %13, label %14

13:                                               ; preds = %10
  br label %15

14:                                               ; preds = %10
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.1, i64 0, i64 0), i32 noundef 52, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.threadRW, i64 0, i64 0)) #4
  unreachable

15:                                               ; preds = %13
  %16 = load i32, i32* @sum, align 4
  %17 = add nsw i32 %16, 1
  store i32 %17, i32* @sum, align 4
  call void @write_unlock(%union.rwlock_t* noundef @mylock)
  ret i8* null
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [1 x i64], align 8
  %3 = alloca [1 x i64], align 8
  %4 = alloca [1 x i64], align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  store i32 1048576, i32* getelementptr inbounds (%union.rwlock_t, %union.rwlock_t* @mylock, i32 0, i32 0), align 4
  store i32 0, i32* %5, align 4
  br label %11

11:                                               ; preds = %19, %0
  %12 = load i32, i32* %5, align 4
  %13 = icmp slt i32 %12, 1
  br i1 %13, label %14, label %22

14:                                               ; preds = %11
  %15 = load i32, i32* %5, align 4
  %16 = sext i32 %15 to i64
  %17 = getelementptr inbounds [1 x i64], [1 x i64]* %2, i64 0, i64 %16
  %18 = call i32 @pthread_create(i64* noundef %17, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @threadR, i8* noundef null) #5
  br label %19

19:                                               ; preds = %14
  %20 = load i32, i32* %5, align 4
  %21 = add nsw i32 %20, 1
  store i32 %21, i32* %5, align 4
  br label %11, !llvm.loop !11

22:                                               ; preds = %11
  store i32 0, i32* %6, align 4
  br label %23

23:                                               ; preds = %31, %22
  %24 = load i32, i32* %6, align 4
  %25 = icmp slt i32 %24, 1
  br i1 %25, label %26, label %34

26:                                               ; preds = %23
  %27 = load i32, i32* %6, align 4
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds [1 x i64], [1 x i64]* %3, i64 0, i64 %28
  %30 = call i32 @pthread_create(i64* noundef %29, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @threadW, i8* noundef null) #5
  br label %31

31:                                               ; preds = %26
  %32 = load i32, i32* %6, align 4
  %33 = add nsw i32 %32, 1
  store i32 %33, i32* %6, align 4
  br label %23, !llvm.loop !12

34:                                               ; preds = %23
  store i32 0, i32* %7, align 4
  br label %35

35:                                               ; preds = %43, %34
  %36 = load i32, i32* %7, align 4
  %37 = icmp slt i32 %36, 1
  br i1 %37, label %38, label %46

38:                                               ; preds = %35
  %39 = load i32, i32* %7, align 4
  %40 = sext i32 %39 to i64
  %41 = getelementptr inbounds [1 x i64], [1 x i64]* %4, i64 0, i64 %40
  %42 = call i32 @pthread_create(i64* noundef %41, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @threadRW, i8* noundef null) #5
  br label %43

43:                                               ; preds = %38
  %44 = load i32, i32* %7, align 4
  %45 = add nsw i32 %44, 1
  store i32 %45, i32* %7, align 4
  br label %35, !llvm.loop !13

46:                                               ; preds = %35
  store i32 0, i32* %8, align 4
  br label %47

47:                                               ; preds = %56, %46
  %48 = load i32, i32* %8, align 4
  %49 = icmp slt i32 %48, 1
  br i1 %49, label %50, label %59

50:                                               ; preds = %47
  %51 = load i32, i32* %8, align 4
  %52 = sext i32 %51 to i64
  %53 = getelementptr inbounds [1 x i64], [1 x i64]* %2, i64 0, i64 %52
  %54 = load i64, i64* %53, align 8
  %55 = call i32 @pthread_join(i64 noundef %54, i8** noundef null)
  br label %56

56:                                               ; preds = %50
  %57 = load i32, i32* %8, align 4
  %58 = add nsw i32 %57, 1
  store i32 %58, i32* %8, align 4
  br label %47, !llvm.loop !14

59:                                               ; preds = %47
  store i32 0, i32* %9, align 4
  br label %60

60:                                               ; preds = %69, %59
  %61 = load i32, i32* %9, align 4
  %62 = icmp slt i32 %61, 1
  br i1 %62, label %63, label %72

63:                                               ; preds = %60
  %64 = load i32, i32* %9, align 4
  %65 = sext i32 %64 to i64
  %66 = getelementptr inbounds [1 x i64], [1 x i64]* %3, i64 0, i64 %65
  %67 = load i64, i64* %66, align 8
  %68 = call i32 @pthread_join(i64 noundef %67, i8** noundef null)
  br label %69

69:                                               ; preds = %63
  %70 = load i32, i32* %9, align 4
  %71 = add nsw i32 %70, 1
  store i32 %71, i32* %9, align 4
  br label %60, !llvm.loop !15

72:                                               ; preds = %60
  store i32 0, i32* %10, align 4
  br label %73

73:                                               ; preds = %82, %72
  %74 = load i32, i32* %10, align 4
  %75 = icmp slt i32 %74, 1
  br i1 %75, label %76, label %85

76:                                               ; preds = %73
  %77 = load i32, i32* %10, align 4
  %78 = sext i32 %77 to i64
  %79 = getelementptr inbounds [1 x i64], [1 x i64]* %4, i64 0, i64 %78
  %80 = load i64, i64* %79, align 8
  %81 = call i32 @pthread_join(i64 noundef %80, i8** noundef null)
  br label %82

82:                                               ; preds = %76
  %83 = load i32, i32* %10, align 4
  %84 = add nsw i32 %83, 1
  store i32 %84, i32* %10, align 4
  br label %73, !llvm.loop !16

85:                                               ; preds = %73
  %86 = load i32, i32* @sum, align 4
  %87 = icmp eq i32 %86, 2
  br i1 %87, label %88, label %89

88:                                               ; preds = %85
  br label %90

89:                                               ; preds = %85
  call void @__assert_fail(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.1, i64 0, i64 0), i32 noundef 82, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4
  unreachable

90:                                               ; preds = %88
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
!16 = distinct !{!16, !7}
