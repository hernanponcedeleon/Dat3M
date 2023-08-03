; ModuleID = 'chase-lev.ll'
source_filename = "benchmarks/lfds/chase-lev.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Deque = type { i32, i32, [10 x i32] }
%union.pthread_attr_t = type { i64, [48 x i8] }

@deq = dso_local global %struct.Deque zeroinitializer, align 4
@.str = private unnamed_addr constant [14 x i8] c"data == count\00", align 1
@.str.1 = private unnamed_addr constant [28 x i8] c"benchmarks/lfds/chase-lev.c\00", align 1
@__PRETTY_FUNCTION__.owner = private unnamed_addr constant [20 x i8] c"void *owner(void *)\00", align 1
@thiefs = dso_local global [4 x i64] zeroinitializer, align 16
@.str.2 = private unnamed_addr constant [31 x i8] c"try_pop(&deq, NUM, &data) >= 0\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @try_push(%struct.Deque* noundef %0, i32 noundef %1, i32 noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca %struct.Deque*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  store %struct.Deque* %0, %struct.Deque** %5, align 8
  store i32 %1, i32* %6, align 4
  store i32 %2, i32* %7, align 4
  %13 = load %struct.Deque*, %struct.Deque** %5, align 8
  %14 = getelementptr inbounds %struct.Deque, %struct.Deque* %13, i32 0, i32 0
  %15 = load atomic i32, i32* %14 monotonic, align 4
  store i32 %15, i32* %9, align 4
  %16 = load i32, i32* %9, align 4
  store i32 %16, i32* %8, align 4
  %17 = load %struct.Deque*, %struct.Deque** %5, align 8
  %18 = getelementptr inbounds %struct.Deque, %struct.Deque* %17, i32 0, i32 1
  %19 = load atomic i32, i32* %18 acquire, align 4
  store i32 %19, i32* %11, align 4
  %20 = load i32, i32* %11, align 4
  store i32 %20, i32* %10, align 4
  %21 = load i32, i32* %8, align 4
  %22 = load i32, i32* %10, align 4
  %23 = sub nsw i32 %21, %22
  %24 = load i32, i32* %6, align 4
  %25 = icmp sge i32 %23, %24
  br i1 %25, label %26, label %27

26:                                               ; preds = %3
  store i32 -1, i32* %4, align 4
  br label %41

27:                                               ; preds = %3
  %28 = load i32, i32* %7, align 4
  %29 = load %struct.Deque*, %struct.Deque** %5, align 8
  %30 = getelementptr inbounds %struct.Deque, %struct.Deque* %29, i32 0, i32 2
  %31 = load i32, i32* %8, align 4
  %32 = load i32, i32* %6, align 4
  %33 = srem i32 %31, %32
  %34 = sext i32 %33 to i64
  %35 = getelementptr inbounds [10 x i32], [10 x i32]* %30, i64 0, i64 %34
  store i32 %28, i32* %35, align 4
  %36 = load %struct.Deque*, %struct.Deque** %5, align 8
  %37 = getelementptr inbounds %struct.Deque, %struct.Deque* %36, i32 0, i32 0
  %38 = load i32, i32* %8, align 4
  %39 = add nsw i32 %38, 1
  store i32 %39, i32* %12, align 4
  %40 = load i32, i32* %12, align 4
  store atomic i32 %40, i32* %37 release, align 4
  store i32 0, i32* %4, align 4
  br label %41

41:                                               ; preds = %27, %26
  %42 = load i32, i32* %4, align 4
  ret i32 %42
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @try_pop(%struct.Deque* noundef %0, i32 noundef %1, i32* noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca %struct.Deque*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i8, align 1
  %15 = alloca i32, align 4
  %16 = alloca i8, align 1
  %17 = alloca i32, align 4
  store %struct.Deque* %0, %struct.Deque** %5, align 8
  store i32 %1, i32* %6, align 4
  store i32* %2, i32** %7, align 8
  %18 = load %struct.Deque*, %struct.Deque** %5, align 8
  %19 = getelementptr inbounds %struct.Deque, %struct.Deque* %18, i32 0, i32 0
  %20 = load atomic i32, i32* %19 monotonic, align 4
  store i32 %20, i32* %9, align 4
  %21 = load i32, i32* %9, align 4
  store i32 %21, i32* %8, align 4
  %22 = load %struct.Deque*, %struct.Deque** %5, align 8
  %23 = getelementptr inbounds %struct.Deque, %struct.Deque* %22, i32 0, i32 0
  %24 = load i32, i32* %8, align 4
  %25 = sub nsw i32 %24, 1
  store i32 %25, i32* %10, align 4
  %26 = load i32, i32* %10, align 4
  store atomic i32 %26, i32* %23 monotonic, align 4
  fence seq_cst
  %27 = load %struct.Deque*, %struct.Deque** %5, align 8
  %28 = getelementptr inbounds %struct.Deque, %struct.Deque* %27, i32 0, i32 1
  %29 = load atomic i32, i32* %28 monotonic, align 4
  store i32 %29, i32* %12, align 4
  %30 = load i32, i32* %12, align 4
  store i32 %30, i32* %11, align 4
  %31 = load i32, i32* %8, align 4
  %32 = load i32, i32* %11, align 4
  %33 = sub nsw i32 %31, %32
  %34 = icmp sle i32 %33, 0
  br i1 %34, label %35, label %40

35:                                               ; preds = %3
  %36 = load %struct.Deque*, %struct.Deque** %5, align 8
  %37 = getelementptr inbounds %struct.Deque, %struct.Deque* %36, i32 0, i32 0
  %38 = load i32, i32* %8, align 4
  store i32 %38, i32* %13, align 4
  %39 = load i32, i32* %13, align 4
  store atomic i32 %39, i32* %37 monotonic, align 4
  store i32 -1, i32* %4, align 4
  br label %80

40:                                               ; preds = %3
  %41 = load %struct.Deque*, %struct.Deque** %5, align 8
  %42 = getelementptr inbounds %struct.Deque, %struct.Deque* %41, i32 0, i32 2
  %43 = load i32, i32* %8, align 4
  %44 = sub nsw i32 %43, 1
  %45 = load i32, i32* %6, align 4
  %46 = srem i32 %44, %45
  %47 = sext i32 %46 to i64
  %48 = getelementptr inbounds [10 x i32], [10 x i32]* %42, i64 0, i64 %47
  %49 = load i32, i32* %48, align 4
  %50 = load i32*, i32** %7, align 8
  store i32 %49, i32* %50, align 4
  %51 = load i32, i32* %8, align 4
  %52 = load i32, i32* %11, align 4
  %53 = sub nsw i32 %51, %52
  %54 = icmp sgt i32 %53, 1
  br i1 %54, label %55, label %56

55:                                               ; preds = %40
  store i32 0, i32* %4, align 4
  br label %80

56:                                               ; preds = %40
  %57 = load %struct.Deque*, %struct.Deque** %5, align 8
  %58 = getelementptr inbounds %struct.Deque, %struct.Deque* %57, i32 0, i32 1
  %59 = load i32, i32* %11, align 4
  %60 = add nsw i32 %59, 1
  store i32 %60, i32* %15, align 4
  %61 = load i32, i32* %11, align 4
  %62 = load i32, i32* %15, align 4
  %63 = cmpxchg i32* %58, i32 %61, i32 %62 monotonic monotonic, align 4
  %64 = extractvalue { i32, i1 } %63, 0
  %65 = extractvalue { i32, i1 } %63, 1
  br i1 %65, label %67, label %66

66:                                               ; preds = %56
  store i32 %64, i32* %11, align 4
  br label %67

67:                                               ; preds = %66, %56
  %68 = zext i1 %65 to i8
  store i8 %68, i8* %16, align 1
  %69 = load i8, i8* %16, align 1
  %70 = trunc i8 %69 to i1
  %71 = zext i1 %70 to i8
  store i8 %71, i8* %14, align 1
  %72 = load %struct.Deque*, %struct.Deque** %5, align 8
  %73 = getelementptr inbounds %struct.Deque, %struct.Deque* %72, i32 0, i32 0
  %74 = load i32, i32* %8, align 4
  store i32 %74, i32* %17, align 4
  %75 = load i32, i32* %17, align 4
  store atomic i32 %75, i32* %73 monotonic, align 4
  %76 = load i8, i8* %14, align 1
  %77 = trunc i8 %76 to i1
  %78 = zext i1 %77 to i64
  %79 = select i1 %77, i32 0, i32 -2
  store i32 %79, i32* %4, align 4
  br label %80

80:                                               ; preds = %67, %55, %35
  %81 = load i32, i32* %4, align 4
  ret i32 %81
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @try_steal(%struct.Deque* noundef %0, i32 noundef %1, i32* noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca %struct.Deque*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i8, align 1
  %13 = alloca i32, align 4
  %14 = alloca i8, align 1
  store %struct.Deque* %0, %struct.Deque** %5, align 8
  store i32 %1, i32* %6, align 4
  store i32* %2, i32** %7, align 8
  %15 = load %struct.Deque*, %struct.Deque** %5, align 8
  %16 = getelementptr inbounds %struct.Deque, %struct.Deque* %15, i32 0, i32 1
  %17 = load atomic i32, i32* %16 monotonic, align 4
  store i32 %17, i32* %9, align 4
  %18 = load i32, i32* %9, align 4
  store i32 %18, i32* %8, align 4
  fence seq_cst
  %19 = load %struct.Deque*, %struct.Deque** %5, align 8
  %20 = getelementptr inbounds %struct.Deque, %struct.Deque* %19, i32 0, i32 0
  %21 = load atomic i32, i32* %20 monotonic, align 4
  store i32 %21, i32* %11, align 4
  %22 = load i32, i32* %11, align 4
  store i32 %22, i32* %10, align 4
  %23 = load i32, i32* %10, align 4
  %24 = load i32, i32* %8, align 4
  %25 = sub nsw i32 %23, %24
  %26 = icmp sle i32 %25, 0
  br i1 %26, label %27, label %28

27:                                               ; preds = %3
  store i32 -1, i32* %4, align 4
  br label %57

28:                                               ; preds = %3
  %29 = load %struct.Deque*, %struct.Deque** %5, align 8
  %30 = getelementptr inbounds %struct.Deque, %struct.Deque* %29, i32 0, i32 2
  %31 = load i32, i32* %8, align 4
  %32 = load i32, i32* %6, align 4
  %33 = srem i32 %31, %32
  %34 = sext i32 %33 to i64
  %35 = getelementptr inbounds [10 x i32], [10 x i32]* %30, i64 0, i64 %34
  %36 = load i32, i32* %35, align 4
  %37 = load i32*, i32** %7, align 8
  store i32 %36, i32* %37, align 4
  %38 = load %struct.Deque*, %struct.Deque** %5, align 8
  %39 = getelementptr inbounds %struct.Deque, %struct.Deque* %38, i32 0, i32 1
  %40 = load i32, i32* %8, align 4
  %41 = add nsw i32 %40, 1
  store i32 %41, i32* %13, align 4
  %42 = load i32, i32* %8, align 4
  %43 = load i32, i32* %13, align 4
  %44 = cmpxchg i32* %39, i32 %42, i32 %43 monotonic monotonic, align 4
  %45 = extractvalue { i32, i1 } %44, 0
  %46 = extractvalue { i32, i1 } %44, 1
  br i1 %46, label %48, label %47

47:                                               ; preds = %28
  store i32 %45, i32* %8, align 4
  br label %48

48:                                               ; preds = %47, %28
  %49 = zext i1 %46 to i8
  store i8 %49, i8* %14, align 1
  %50 = load i8, i8* %14, align 1
  %51 = trunc i8 %50 to i1
  %52 = zext i1 %51 to i8
  store i8 %52, i8* %12, align 1
  %53 = load i8, i8* %12, align 1
  %54 = trunc i8 %53 to i1
  %55 = zext i1 %54 to i64
  %56 = select i1 %54, i32 0, i32 -2
  store i32 %56, i32* %4, align 4
  br label %57

57:                                               ; preds = %48, %27
  %58 = load i32, i32* %4, align 4
  ret i32 %58
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @thief(i8* noundef %0) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  %4 = call i32 @try_steal(%struct.Deque* noundef @deq, i32 noundef 10, i32* noundef %3)
  ret i8* null
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @owner(i8* noundef %0) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  store i32 0, i32* %3, align 4
  %7 = load i32, i32* %3, align 4
  %8 = add nsw i32 %7, 1
  store i32 %8, i32* %3, align 4
  %9 = load i32, i32* %3, align 4
  %10 = call i32 @try_push(%struct.Deque* noundef @deq, i32 noundef 10, i32 noundef %9)
  %11 = call i32 @try_pop(%struct.Deque* noundef @deq, i32 noundef 10, i32* noundef %4)
  %12 = load i32, i32* %4, align 4
  %13 = load i32, i32* %3, align 4
  %14 = icmp eq i32 %12, %13
  br i1 %14, label %15, label %16

15:                                               ; preds = %1
  br label %17

16:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([28 x i8], [28 x i8]* @.str.1, i64 0, i64 0), i32 noundef 37, i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @__PRETTY_FUNCTION__.owner, i64 0, i64 0)) #3
  unreachable

17:                                               ; preds = %15
  store i32 0, i32* %5, align 4
  br label %18

18:                                               ; preds = %24, %17
  %19 = load i32, i32* %5, align 4
  %20 = icmp sle i32 %19, 4
  br i1 %20, label %21, label %27

21:                                               ; preds = %18
  %22 = load i32, i32* %3, align 4
  %23 = call i32 @try_push(%struct.Deque* noundef @deq, i32 noundef 10, i32 noundef %22)
  br label %24

24:                                               ; preds = %21
  %25 = load i32, i32* %5, align 4
  %26 = add nsw i32 %25, 1
  store i32 %26, i32* %5, align 4
  br label %18, !llvm.loop !6

27:                                               ; preds = %18
  store i32 0, i32* %6, align 4
  br label %28

28:                                               ; preds = %36, %27
  %29 = load i32, i32* %6, align 4
  %30 = icmp slt i32 %29, 4
  br i1 %30, label %31, label %39

31:                                               ; preds = %28
  %32 = load i32, i32* %6, align 4
  %33 = sext i32 %32 to i64
  %34 = getelementptr inbounds [4 x i64], [4 x i64]* @thiefs, i64 0, i64 %33
  %35 = call i32 @pthread_create(i64* noundef %34, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thief, i8* noundef null) #4
  br label %36

36:                                               ; preds = %31
  %37 = load i32, i32* %6, align 4
  %38 = add nsw i32 %37, 1
  store i32 %38, i32* %6, align 4
  br label %28, !llvm.loop !8

39:                                               ; preds = %28
  %40 = call i32 @try_pop(%struct.Deque* noundef @deq, i32 noundef 10, i32* noundef %4)
  %41 = icmp sge i32 %40, 0
  br i1 %41, label %42, label %43

42:                                               ; preds = %39
  br label %44

43:                                               ; preds = %39
  call void @__assert_fail(i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([28 x i8], [28 x i8]* @.str.1, i64 0, i64 0), i32 noundef 46, i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @__PRETTY_FUNCTION__.owner, i64 0, i64 0)) #3
  unreachable

44:                                               ; preds = %42
  ret i8* null
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @owner, i8* noundef null) #4
  ret i32 0
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind }
attributes #4 = { nounwind }

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
