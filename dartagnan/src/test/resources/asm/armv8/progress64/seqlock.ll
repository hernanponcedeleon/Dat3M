; ModuleID = 'src/p64_rwsync.c'
source_filename = "src/p64_rwsync.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.shared_data_t = type { i32, i32 }

@sync = global i32 0, align 4
@data = global %struct.shared_data_t zeroinitializer, align 4
@.str = private unnamed_addr constant [24 x i8] c"Reader: x = %d, y = %d\0A\00", align 1
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"p64_rwsync.c\00", align 1
@.str.2 = private unnamed_addr constant [27 x i8] c"data.x == 2 && data.y == 2\00", align 1
@.str.3 = private unnamed_addr constant [30 x i8] c"Final values: x = %d, y = %d\0A\00", align 1
@__func__.wait_for_no_writer = private unnamed_addr constant [19 x i8] c"wait_for_no_writer\00", align 1
@.str.4 = private unnamed_addr constant [25 x i8] c"(l & RWSYNC_WRITER) == 0\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @p64_rwsync_init(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  store i32 0, ptr %3, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @p64_rwsync_acquire_rd(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = call i32 @wait_for_no_writer(ptr noundef %3, i32 noundef 2)
  ret i32 %4
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @wait_for_no_writer(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %7 = load ptr, ptr %3, align 8
  %8 = load i32, ptr %4, align 4
  switch i32 %8, label %9 [
    i32 1, label %11
    i32 2, label %11
    i32 5, label %13
  ]

9:                                                ; preds = %2
  %10 = load atomic i32, ptr %7 monotonic, align 4
  store i32 %10, ptr %6, align 4
  br label %15

11:                                               ; preds = %2, %2
  %12 = load atomic i32, ptr %7 acquire, align 4
  store i32 %12, ptr %6, align 4
  br label %15

13:                                               ; preds = %2
  %14 = load atomic i32, ptr %7 seq_cst, align 4
  store i32 %14, ptr %6, align 4
  br label %15

15:                                               ; preds = %13, %11, %9
  %16 = load i32, ptr %6, align 4
  store i32 %16, ptr %5, align 4
  %17 = and i32 %16, 1
  %18 = icmp ne i32 %17, 0
  %19 = xor i1 %18, true
  %20 = xor i1 %19, true
  %21 = zext i1 %20 to i32
  %22 = sext i32 %21 to i64
  %23 = icmp ne i64 %22, 0
  br i1 %23, label %24, label %33

24:                                               ; preds = %15
  br label %25

25:                                               ; preds = %31, %24
  %26 = load ptr, ptr %3, align 8
  %27 = load i32, ptr %4, align 4
  %28 = call i32 @ldx32(ptr noundef %26, i32 noundef %27)
  store i32 %28, ptr %5, align 4
  %29 = and i32 %28, 1
  %30 = icmp ne i32 %29, 0
  br i1 %30, label %31, label %32

31:                                               ; preds = %25
  call void @wfe()
  br label %25, !llvm.loop !6

32:                                               ; preds = %25
  br label %33

33:                                               ; preds = %32, %15
  %34 = load i32, ptr %5, align 4
  %35 = and i32 %34, 1
  %36 = icmp eq i32 %35, 0
  %37 = xor i1 %36, true
  %38 = zext i1 %37 to i32
  %39 = sext i32 %38 to i64
  %40 = icmp ne i64 %39, 0
  br i1 %40, label %41, label %43

41:                                               ; preds = %33
  call void @__assert_rtn(ptr noundef @__func__.wait_for_no_writer, ptr noundef @.str.1, i32 noundef 48, ptr noundef @.str.4) #5
  unreachable

42:                                               ; No predecessors!
  br label %44

43:                                               ; preds = %33
  br label %44

44:                                               ; preds = %43, %42
  %45 = load i32, ptr %5, align 4
  ret i32 %45
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define zeroext i1 @p64_rwsync_release_rd(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  fence acquire
  %6 = load ptr, ptr %3, align 8
  %7 = load atomic i32, ptr %6 monotonic, align 4
  store i32 %7, ptr %5, align 4
  %8 = load i32, ptr %5, align 4
  %9 = load i32, ptr %4, align 4
  %10 = icmp eq i32 %8, %9
  ret i1 %10
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @p64_rwsync_acquire_wr(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  br label %6

6:                                                ; preds = %19, %1
  %7 = load ptr, ptr %2, align 8
  %8 = call i32 @wait_for_no_writer(ptr noundef %7, i32 noundef 0)
  store i32 %8, ptr %3, align 4
  br label %9

9:                                                ; preds = %6
  %10 = load ptr, ptr %2, align 8
  %11 = load i32, ptr %3, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %4, align 4
  %13 = load i32, ptr %3, align 4
  %14 = load i32, ptr %4, align 4
  %15 = cmpxchg weak ptr %10, i32 %13, i32 %14 acquire monotonic, align 4
  %16 = extractvalue { i32, i1 } %15, 0
  %17 = extractvalue { i32, i1 } %15, 1
  br i1 %17, label %19, label %18

18:                                               ; preds = %9
  store i32 %16, ptr %3, align 4
  br label %19

19:                                               ; preds = %18, %9
  %20 = zext i1 %17 to i8
  store i8 %20, ptr %5, align 1
  %21 = load i8, ptr %5, align 1
  %22 = trunc i8 %21 to i1
  %23 = xor i1 %22, true
  br i1 %23, label %6, label %24, !llvm.loop !8

24:                                               ; preds = %19
  fence release
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @p64_rwsync_release_wr(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8
  %6 = load i32, ptr %5, align 4
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  %8 = and i32 %7, 1
  %9 = icmp ne i32 %8, 0
  %10 = xor i1 %9, true
  %11 = xor i1 %10, true
  %12 = zext i1 %11 to i32
  %13 = sext i32 %12 to i64
  %14 = icmp eq i64 %13, 0
  br i1 %14, label %15, label %16

15:                                               ; preds = %1
  br label %21

16:                                               ; preds = %1
  %17 = load ptr, ptr %2, align 8
  %18 = load i32, ptr %3, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %4, align 4
  %20 = load i32, ptr %4, align 4
  store atomic i32 %20, ptr %17 release, align 4
  br label %21

21:                                               ; preds = %16, %15
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @p64_rwsync_read(ptr noundef %0, ptr noundef %1, ptr noundef %2, i64 noundef %3) #0 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i64, align 8
  %9 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store ptr %2, ptr %7, align 8
  store i64 %3, ptr %8, align 8
  br label %10

10:                                               ; preds = %16, %4
  %11 = load ptr, ptr %5, align 8
  %12 = call i32 @p64_rwsync_acquire_rd(ptr noundef %11)
  store i32 %12, ptr %9, align 4
  %13 = load ptr, ptr %6, align 8
  %14 = load ptr, ptr %7, align 8
  %15 = load i64, ptr %8, align 8
  call void @atomic_memcpy(ptr noundef %13, ptr noundef %14, i64 noundef %15)
  br label %16

16:                                               ; preds = %10
  %17 = load ptr, ptr %5, align 8
  %18 = load i32, ptr %9, align 4
  %19 = call zeroext i1 @p64_rwsync_release_rd(ptr noundef %17, i32 noundef %18)
  %20 = xor i1 %19, true
  br i1 %20, label %10, label %21, !llvm.loop !9

21:                                               ; preds = %16
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @atomic_memcpy(ptr noundef %0, ptr noundef %1, i64 noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca i64, align 8
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i64, align 8
  %15 = alloca i16, align 2
  %16 = alloca i16, align 2
  %17 = alloca i16, align 2
  %18 = alloca i64, align 8
  %19 = alloca i8, align 1
  %20 = alloca i8, align 1
  %21 = alloca i8, align 1
  %22 = alloca i64, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store i64 %2, ptr %6, align 8
  br label %23

23:                                               ; preds = %26, %3
  %24 = load i64, ptr %6, align 8
  %25 = icmp uge i64 %24, 8
  br i1 %25, label %26, label %40

26:                                               ; preds = %23
  %27 = load ptr, ptr %5, align 8
  %28 = load atomic i64, ptr %27 monotonic, align 8
  store i64 %28, ptr %8, align 8
  %29 = load i64, ptr %8, align 8
  store i64 %29, ptr %7, align 8
  %30 = load ptr, ptr %5, align 8
  %31 = getelementptr inbounds i8, ptr %30, i64 8
  store ptr %31, ptr %5, align 8
  %32 = load ptr, ptr %4, align 8
  %33 = load i64, ptr %7, align 8
  store i64 %33, ptr %9, align 8
  %34 = load i64, ptr %9, align 8
  store atomic i64 %34, ptr %32 monotonic, align 8
  %35 = load ptr, ptr %4, align 8
  %36 = getelementptr inbounds i8, ptr %35, i64 8
  store ptr %36, ptr %4, align 8
  %37 = load i64, ptr %6, align 8
  %38 = sub i64 %37, 8
  store i64 %38, ptr %6, align 8
  store i64 %38, ptr %10, align 8
  %39 = load i64, ptr %10, align 8
  br label %23, !llvm.loop !10

40:                                               ; preds = %23
  %41 = load i64, ptr %6, align 8
  %42 = icmp uge i64 %41, 4
  br i1 %42, label %43, label %57

43:                                               ; preds = %40
  %44 = load ptr, ptr %5, align 8
  %45 = load atomic i32, ptr %44 monotonic, align 4
  store i32 %45, ptr %12, align 4
  %46 = load i32, ptr %12, align 4
  store i32 %46, ptr %11, align 4
  %47 = load ptr, ptr %5, align 8
  %48 = getelementptr inbounds i8, ptr %47, i64 4
  store ptr %48, ptr %5, align 8
  %49 = load ptr, ptr %4, align 8
  %50 = load i32, ptr %11, align 4
  store i32 %50, ptr %13, align 4
  %51 = load i32, ptr %13, align 4
  store atomic i32 %51, ptr %49 monotonic, align 4
  %52 = load ptr, ptr %4, align 8
  %53 = getelementptr inbounds i8, ptr %52, i64 4
  store ptr %53, ptr %4, align 8
  %54 = load i64, ptr %6, align 8
  %55 = sub i64 %54, 4
  store i64 %55, ptr %6, align 8
  store i64 %55, ptr %14, align 8
  %56 = load i64, ptr %14, align 8
  br label %57

57:                                               ; preds = %43, %40
  %58 = load i64, ptr %6, align 8
  %59 = icmp uge i64 %58, 2
  br i1 %59, label %60, label %74

60:                                               ; preds = %57
  %61 = load ptr, ptr %5, align 8
  %62 = load atomic i16, ptr %61 monotonic, align 2
  store i16 %62, ptr %16, align 2
  %63 = load i16, ptr %16, align 2
  store i16 %63, ptr %15, align 2
  %64 = load ptr, ptr %5, align 8
  %65 = getelementptr inbounds i8, ptr %64, i64 2
  store ptr %65, ptr %5, align 8
  %66 = load ptr, ptr %4, align 8
  %67 = load i16, ptr %15, align 2
  store i16 %67, ptr %17, align 2
  %68 = load i16, ptr %17, align 2
  store atomic i16 %68, ptr %66 monotonic, align 2
  %69 = load ptr, ptr %4, align 8
  %70 = getelementptr inbounds i8, ptr %69, i64 2
  store ptr %70, ptr %4, align 8
  %71 = load i64, ptr %6, align 8
  %72 = sub i64 %71, 2
  store i64 %72, ptr %6, align 8
  store i64 %72, ptr %18, align 8
  %73 = load i64, ptr %18, align 8
  br label %74

74:                                               ; preds = %60, %57
  %75 = load i64, ptr %6, align 8
  %76 = icmp uge i64 %75, 1
  br i1 %76, label %77, label %91

77:                                               ; preds = %74
  %78 = load ptr, ptr %5, align 8
  %79 = load atomic i8, ptr %78 monotonic, align 1
  store i8 %79, ptr %20, align 1
  %80 = load i8, ptr %20, align 1
  store i8 %80, ptr %19, align 1
  %81 = load ptr, ptr %5, align 8
  %82 = getelementptr inbounds i8, ptr %81, i64 1
  store ptr %82, ptr %5, align 8
  %83 = load ptr, ptr %4, align 8
  %84 = load i8, ptr %19, align 1
  store i8 %84, ptr %21, align 1
  %85 = load i8, ptr %21, align 1
  store atomic i8 %85, ptr %83 monotonic, align 1
  %86 = load ptr, ptr %4, align 8
  %87 = getelementptr inbounds i8, ptr %86, i64 1
  store ptr %87, ptr %4, align 8
  %88 = load i64, ptr %6, align 8
  %89 = sub i64 %88, 1
  store i64 %89, ptr %6, align 8
  store i64 %89, ptr %22, align 8
  %90 = load i64, ptr %22, align 8
  br label %91

91:                                               ; preds = %77, %74
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @p64_rwsync_write(ptr noundef %0, ptr noundef %1, ptr noundef %2, i64 noundef %3) #0 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i64, align 8
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store ptr %2, ptr %7, align 8
  store i64 %3, ptr %8, align 8
  %9 = load ptr, ptr %5, align 8
  call void @p64_rwsync_acquire_wr(ptr noundef %9)
  %10 = load ptr, ptr %7, align 8
  %11 = load ptr, ptr %6, align 8
  %12 = load i64, ptr %8, align 8
  call void @atomic_memcpy(ptr noundef %10, ptr noundef %11, i64 noundef %12)
  %13 = load ptr, ptr %5, align 8
  call void @p64_rwsync_release_wr(ptr noundef %13)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @writer(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  call void @p64_rwsync_acquire_wr(ptr noundef @sync)
  %4 = load i32, ptr @data, align 4
  %5 = add nsw i32 %4, 1
  store i32 %5, ptr @data, align 4
  %6 = load i32, ptr getelementptr inbounds (%struct.shared_data_t, ptr @data, i32 0, i32 1), align 4
  %7 = add nsw i32 %6, 1
  store i32 %7, ptr getelementptr inbounds (%struct.shared_data_t, ptr @data, i32 0, i32 1), align 4
  call void @p64_rwsync_release_wr(ptr noundef @sync)
  ret ptr null
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @reader(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca %struct.shared_data_t, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  call void @p64_rwsync_read(ptr noundef @sync, ptr noundef %3, ptr noundef @data, i64 noundef 8)
  %5 = getelementptr inbounds %struct.shared_data_t, ptr %3, i32 0, i32 0
  %6 = load i32, ptr %5, align 4
  %7 = getelementptr inbounds %struct.shared_data_t, ptr %3, i32 0, i32 1
  %8 = load i32, ptr %7, align 4
  %9 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %6, i32 noundef %8)
  ret ptr null
}

declare i32 @printf(ptr noundef, ...) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 8
  %3 = alloca [2 x ptr], align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @p64_rwsync_init(ptr noundef @sync)
  store i32 0, ptr @data, align 4
  store i32 0, ptr getelementptr inbounds (%struct.shared_data_t, ptr @data, i32 0, i32 1), align 4
  store i32 0, ptr %4, align 4
  br label %8

8:                                                ; preds = %19, %0
  %9 = load i32, ptr %4, align 4
  %10 = icmp slt i32 %9, 2
  br i1 %10, label %11, label %22

11:                                               ; preds = %8
  %12 = load i32, ptr %4, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %13
  %15 = call i32 @pthread_create(ptr noundef %14, ptr noundef null, ptr noundef @writer, ptr noundef null)
  %16 = icmp ne i32 %15, 0
  br i1 %16, label %17, label %18

17:                                               ; preds = %11
  call void @exit(i32 noundef 1) #6
  unreachable

18:                                               ; preds = %11
  br label %19

19:                                               ; preds = %18
  %20 = load i32, ptr %4, align 4
  %21 = add nsw i32 %20, 1
  store i32 %21, ptr %4, align 4
  br label %8, !llvm.loop !11

22:                                               ; preds = %8
  store i32 0, ptr %5, align 4
  br label %23

23:                                               ; preds = %34, %22
  %24 = load i32, ptr %5, align 4
  %25 = icmp slt i32 %24, 2
  br i1 %25, label %26, label %37

26:                                               ; preds = %23
  %27 = load i32, ptr %5, align 4
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds [2 x ptr], ptr %3, i64 0, i64 %28
  %30 = call i32 @pthread_create(ptr noundef %29, ptr noundef null, ptr noundef @reader, ptr noundef null)
  %31 = icmp ne i32 %30, 0
  br i1 %31, label %32, label %33

32:                                               ; preds = %26
  call void @exit(i32 noundef 1) #6
  unreachable

33:                                               ; preds = %26
  br label %34

34:                                               ; preds = %33
  %35 = load i32, ptr %5, align 4
  %36 = add nsw i32 %35, 1
  store i32 %36, ptr %5, align 4
  br label %23, !llvm.loop !12

37:                                               ; preds = %23
  store i32 0, ptr %6, align 4
  br label %38

38:                                               ; preds = %50, %37
  %39 = load i32, ptr %6, align 4
  %40 = icmp slt i32 %39, 2
  br i1 %40, label %41, label %53

41:                                               ; preds = %38
  %42 = load i32, ptr %6, align 4
  %43 = sext i32 %42 to i64
  %44 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %43
  %45 = load ptr, ptr %44, align 8
  %46 = call i32 @"\01_pthread_join"(ptr noundef %45, ptr noundef null)
  %47 = icmp ne i32 %46, 0
  br i1 %47, label %48, label %49

48:                                               ; preds = %41
  call void @exit(i32 noundef 1) #6
  unreachable

49:                                               ; preds = %41
  br label %50

50:                                               ; preds = %49
  %51 = load i32, ptr %6, align 4
  %52 = add nsw i32 %51, 1
  store i32 %52, ptr %6, align 4
  br label %38, !llvm.loop !13

53:                                               ; preds = %38
  store i32 0, ptr %7, align 4
  br label %54

54:                                               ; preds = %66, %53
  %55 = load i32, ptr %7, align 4
  %56 = icmp slt i32 %55, 2
  br i1 %56, label %57, label %69

57:                                               ; preds = %54
  %58 = load i32, ptr %7, align 4
  %59 = sext i32 %58 to i64
  %60 = getelementptr inbounds [2 x ptr], ptr %3, i64 0, i64 %59
  %61 = load ptr, ptr %60, align 8
  %62 = call i32 @"\01_pthread_join"(ptr noundef %61, ptr noundef null)
  %63 = icmp ne i32 %62, 0
  br i1 %63, label %64, label %65

64:                                               ; preds = %57
  call void @exit(i32 noundef 1) #6
  unreachable

65:                                               ; preds = %57
  br label %66

66:                                               ; preds = %65
  %67 = load i32, ptr %7, align 4
  %68 = add nsw i32 %67, 1
  store i32 %68, ptr %7, align 4
  br label %54, !llvm.loop !14

69:                                               ; preds = %54
  %70 = load i32, ptr @data, align 4
  %71 = icmp eq i32 %70, 2
  br i1 %71, label %72, label %75

72:                                               ; preds = %69
  %73 = load i32, ptr getelementptr inbounds (%struct.shared_data_t, ptr @data, i32 0, i32 1), align 4
  %74 = icmp eq i32 %73, 2
  br label %75

75:                                               ; preds = %72, %69
  %76 = phi i1 [ false, %69 ], [ %74, %72 ]
  %77 = xor i1 %76, true
  %78 = zext i1 %77 to i32
  %79 = sext i32 %78 to i64
  %80 = icmp ne i64 %79, 0
  br i1 %80, label %81, label %83

81:                                               ; preds = %75
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str.1, i32 noundef 227, ptr noundef @.str.2) #5
  unreachable

82:                                               ; No predecessors!
  br label %84

83:                                               ; preds = %75
  br label %84

84:                                               ; preds = %83, %82
  %85 = load i32, ptr @data, align 4
  %86 = load i32, ptr getelementptr inbounds (%struct.shared_data_t, ptr @data, i32 0, i32 1), align 4
  %87 = call i32 (ptr, ...) @printf(ptr noundef @.str.3, i32 noundef %85, i32 noundef %86)
  ret i32 0
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #2

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ldx32(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %6 = load i32, ptr %4, align 4
  %7 = icmp eq i32 %6, 2
  br i1 %7, label %8, label %11

8:                                                ; preds = %2
  %9 = load ptr, ptr %3, align 8
  %10 = call i32 asm sideeffect "ldaxr ${0:w}, [$1]", "=&r,r,~{memory}"(ptr %9) #7, !srcloc !15
  store i32 %10, ptr %5, align 4
  br label %19

11:                                               ; preds = %2
  %12 = load i32, ptr %4, align 4
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %14, label %17

14:                                               ; preds = %11
  %15 = load ptr, ptr %3, align 8
  %16 = call i32 asm sideeffect "ldxr ${0:w}, [$1]", "=&r,r,~{memory}"(ptr %15) #7, !srcloc !16
  store i32 %16, ptr %5, align 4
  br label %18

17:                                               ; preds = %11
  call void @abort() #8
  unreachable

18:                                               ; preds = %14
  br label %19

19:                                               ; preds = %18, %8
  %20 = load i32, ptr %5, align 4
  ret i32 %20
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @wfe() #0 {
  call void asm sideeffect "wfe", "~{memory}"() #7, !srcloc !17
  ret void
}

; Function Attrs: cold noreturn nounwind
declare void @abort() #4

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #4 = { cold noreturn nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #5 = { cold noreturn }
attributes #6 = { noreturn }
attributes #7 = { nounwind }
attributes #8 = { cold noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 0]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Homebrew clang version 19.1.7"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = distinct !{!12, !7}
!13 = distinct !{!13, !7}
!14 = distinct !{!14, !7}
!15 = !{i64 1208267}
!16 = !{i64 1208437}
!17 = !{i64 973250}
