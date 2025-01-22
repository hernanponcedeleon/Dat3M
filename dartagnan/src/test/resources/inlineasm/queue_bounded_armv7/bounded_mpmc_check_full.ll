; ModuleID = 'test/queue/bounded_mpmc_check_full.c'
source_filename = "test/queue/bounded_mpmc_check_full.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.bounded_mpmc_s = type { %struct.vatomic32_s, %struct.vatomic32_s, %struct.vatomic32_s, %struct.vatomic32_s, ptr, i32 }
%struct.vatomic32_s = type { i32 }
%struct.xbo_s = type { i32, i32, i32, i32 }
%struct.run_info_t = type { ptr, i64, i8, ptr }

@g_val = global [4 x i64] zeroinitializer, align 8
@g_queue = global %struct.bounded_mpmc_s zeroinitializer, align 8
@g_buf = global [4 x ptr] zeroinitializer, align 8
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [26 x i8] c"bounded_mpmc_check_full.c\00", align 1
@.str.1 = private unnamed_addr constant [24 x i8] c"ret == QUEUE_BOUNDED_OK\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"(dequeued % 10U) == 1\00", align 1
@.str.3 = private unnamed_addr constant [26 x i8] c"dequeued <= (2 * 10U + 1)\00", align 1
@.str.4 = private unnamed_addr constant [26 x i8] c"ret == QUEUE_BOUNDED_FULL\00", align 1
@.str.5 = private unnamed_addr constant [15 x i8] c"buffer is NULL\00", align 1
@__func__.bounded_mpmc_init = private unnamed_addr constant [18 x i8] c"bounded_mpmc_init\00", align 1
@.str.6 = private unnamed_addr constant [15 x i8] c"bounded_mpmc.h\00", align 1
@.str.7 = private unnamed_addr constant [22 x i8] c"b && \22buffer is NULL\22\00", align 1
@.str.8 = private unnamed_addr constant [19 x i8] c"buffer with 0 size\00", align 1
@.str.9 = private unnamed_addr constant [31 x i8] c"s != 0 && \22buffer with 0 size\22\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @sched_yield() #0 {
  ret i32 0
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @writer(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca %struct.xbo_s, align 4
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  %7 = load ptr, ptr %2, align 8
  %8 = ptrtoint ptr %7 to i64
  store i64 %8, ptr %3, align 8
  call void @xbo_init(ptr noundef %4, i32 noundef 0, i32 noundef 100, i32 noundef 2)
  store i64 0, ptr %5, align 8
  br label %9

9:                                                ; preds = %31, %1
  %10 = load i64, ptr %5, align 8
  %11 = icmp ult i64 %10, 2
  br i1 %11, label %12, label %34

12:                                               ; preds = %9
  %13 = load i64, ptr %3, align 8
  %14 = mul i64 %13, 2
  %15 = load i64, ptr %5, align 8
  %16 = add i64 %14, %15
  store i64 %16, ptr %6, align 8
  %17 = load i64, ptr %3, align 8
  %18 = mul i64 %17, 10
  %19 = load i64, ptr %5, align 8
  %20 = add i64 %18, %19
  %21 = add i64 %20, 1
  %22 = load i64, ptr %6, align 8
  %23 = getelementptr inbounds [4 x i64], ptr @g_val, i64 0, i64 %22
  store i64 %21, ptr %23, align 8
  br label %24

24:                                               ; preds = %29, %12
  %25 = load i64, ptr %6, align 8
  %26 = getelementptr inbounds [4 x i64], ptr @g_val, i64 0, i64 %25
  %27 = call i32 @bounded_mpmc_enq(ptr noundef @g_queue, ptr noundef %26)
  %28 = icmp ne i32 %27, 0
  br i1 %28, label %29, label %30

29:                                               ; preds = %24
  call void @xbo_backoff(ptr noundef %4, ptr noundef @xbo_nop, ptr noundef @sched_yield)
  br label %24, !llvm.loop !6

30:                                               ; preds = %24
  call void @xbo_reset(ptr noundef %4)
  br label %31

31:                                               ; preds = %30
  %32 = load i64, ptr %5, align 8
  %33 = add i64 %32, 1
  store i64 %33, ptr %5, align 8
  br label %9, !llvm.loop !8

34:                                               ; preds = %9
  ret ptr null
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @xbo_init(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) #0 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store i32 %1, ptr %6, align 4
  store i32 %2, ptr %7, align 4
  store i32 %3, ptr %8, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @bounded_mpmc_enq(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  %8 = load ptr, ptr %4, align 8
  %9 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %8, i32 0, i32 0
  %10 = call i32 @vatomic32_read_acq(ptr noundef %9)
  store i32 %10, ptr %6, align 4
  %11 = load i32, ptr %6, align 4
  %12 = load ptr, ptr %4, align 8
  %13 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %12, i32 0, i32 3
  %14 = call i32 @vatomic32_read_rlx(ptr noundef %13)
  %15 = sub i32 %11, %14
  %16 = load ptr, ptr %4, align 8
  %17 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %16, i32 0, i32 5
  %18 = load i32, ptr %17, align 8
  %19 = icmp eq i32 %15, %18
  br i1 %19, label %20, label %21

20:                                               ; preds = %2
  store i32 1, ptr %3, align 4
  br label %51

21:                                               ; preds = %2
  %22 = load i32, ptr %6, align 4
  %23 = add i32 %22, 1
  store i32 %23, ptr %7, align 4
  %24 = load ptr, ptr %4, align 8
  %25 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %24, i32 0, i32 0
  %26 = load i32, ptr %6, align 4
  %27 = load i32, ptr %7, align 4
  %28 = call i32 @vatomic32_cmpxchg_rel(ptr noundef %25, i32 noundef %26, i32 noundef %27)
  %29 = load i32, ptr %6, align 4
  %30 = icmp ne i32 %28, %29
  br i1 %30, label %31, label %32

31:                                               ; preds = %21
  store i32 3, ptr %3, align 4
  br label %51

32:                                               ; preds = %21
  %33 = load ptr, ptr %5, align 8
  %34 = load ptr, ptr %4, align 8
  %35 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %34, i32 0, i32 4
  %36 = load ptr, ptr %35, align 8
  %37 = load i32, ptr %6, align 4
  %38 = load ptr, ptr %4, align 8
  %39 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %38, i32 0, i32 5
  %40 = load i32, ptr %39, align 8
  %41 = urem i32 %37, %40
  %42 = zext i32 %41 to i64
  %43 = getelementptr inbounds ptr, ptr %36, i64 %42
  store ptr %33, ptr %43, align 8
  %44 = load ptr, ptr %4, align 8
  %45 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %44, i32 0, i32 1
  %46 = load i32, ptr %6, align 4
  %47 = call i32 @vatomic32_await_eq_acq(ptr noundef %45, i32 noundef %46)
  %48 = load ptr, ptr %4, align 8
  %49 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %48, i32 0, i32 1
  %50 = load i32, ptr %7, align 4
  call void @vatomic32_write_rel(ptr noundef %49, i32 noundef %50)
  store i32 0, ptr %3, align 4
  br label %51

51:                                               ; preds = %32, %31, %20
  %52 = load i32, ptr %3, align 4
  ret i32 %52
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @xbo_backoff(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store ptr %2, ptr %6, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @xbo_nop() #0 {
  %1 = alloca i32, align 4
  store volatile i32 0, ptr %1, align 4
  %2 = load volatile i32, ptr %1, align 4
  ret i32 %2
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @xbo_reset(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  %4 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  store i32 0, ptr %2, align 4
  call void @bounded_mpmc_init(ptr noundef @g_queue, ptr noundef @g_buf, i32 noundef 4)
  call void @launch_threads(i64 noundef 2, ptr noundef @writer)
  store ptr null, ptr %3, align 8
  %5 = call i32 @bounded_mpmc_deq(ptr noundef @g_queue, ptr noundef %3)
  store i32 %5, ptr %2, align 4
  %6 = load i32, ptr %2, align 4
  %7 = icmp eq i32 %6, 0
  %8 = xor i1 %7, true
  %9 = zext i1 %8 to i32
  %10 = sext i32 %9 to i64
  %11 = icmp ne i64 %10, 0
  br i1 %11, label %12, label %14

12:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 74, ptr noundef @.str.1) #4
  unreachable

13:                                               ; No predecessors!
  br label %15

14:                                               ; preds = %0
  br label %15

15:                                               ; preds = %14, %13
  %16 = load ptr, ptr %3, align 8
  %17 = load i64, ptr %16, align 8
  store i64 %17, ptr %4, align 8
  %18 = load i64, ptr %4, align 8
  %19 = urem i64 %18, 10
  %20 = icmp eq i64 %19, 1
  %21 = xor i1 %20, true
  %22 = zext i1 %21 to i32
  %23 = sext i32 %22 to i64
  %24 = icmp ne i64 %23, 0
  br i1 %24, label %25, label %27

25:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 79, ptr noundef @.str.2) #4
  unreachable

26:                                               ; No predecessors!
  br label %28

27:                                               ; preds = %15
  br label %28

28:                                               ; preds = %27, %26
  %29 = load i64, ptr %4, align 8
  %30 = icmp ule i64 %29, 21
  %31 = xor i1 %30, true
  %32 = zext i1 %31 to i32
  %33 = sext i32 %32 to i64
  %34 = icmp ne i64 %33, 0
  br i1 %34, label %35, label %37

35:                                               ; preds = %28
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 80, ptr noundef @.str.3) #4
  unreachable

36:                                               ; No predecessors!
  br label %38

37:                                               ; preds = %28
  br label %38

38:                                               ; preds = %37, %36
  %39 = call i32 @bounded_mpmc_enq(ptr noundef @g_queue, ptr noundef %3)
  store i32 %39, ptr %2, align 4
  %40 = load i32, ptr %2, align 4
  %41 = icmp eq i32 %40, 0
  %42 = xor i1 %41, true
  %43 = zext i1 %42 to i32
  %44 = sext i32 %43 to i64
  %45 = icmp ne i64 %44, 0
  br i1 %45, label %46, label %48

46:                                               ; preds = %38
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 84, ptr noundef @.str.1) #4
  unreachable

47:                                               ; No predecessors!
  br label %49

48:                                               ; preds = %38
  br label %49

49:                                               ; preds = %48, %47
  %50 = call i32 @bounded_mpmc_enq(ptr noundef @g_queue, ptr noundef %3)
  store i32 %50, ptr %2, align 4
  %51 = load i32, ptr %2, align 4
  %52 = icmp eq i32 %51, 1
  %53 = xor i1 %52, true
  %54 = zext i1 %53 to i32
  %55 = sext i32 %54 to i64
  %56 = icmp ne i64 %55, 0
  br i1 %56, label %57, label %59

57:                                               ; preds = %49
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 88, ptr noundef @.str.4) #4
  unreachable

58:                                               ; No predecessors!
  br label %60

59:                                               ; preds = %49
  br label %60

60:                                               ; preds = %59, %58
  br label %61

61:                                               ; preds = %60
  br label %62

62:                                               ; preds = %61
  %63 = load i32, ptr %2, align 4
  br label %64

64:                                               ; preds = %62
  %65 = load i64, ptr %4, align 8
  br label %66

66:                                               ; preds = %64
  br label %67

67:                                               ; preds = %66
  br label %68

68:                                               ; preds = %67
  br label %69

69:                                               ; preds = %68
  br label %70

70:                                               ; preds = %69
  ret i32 0
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @bounded_mpmc_init(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store i32 %2, ptr %6, align 4
  %7 = load ptr, ptr %5, align 8
  %8 = icmp ne ptr %7, null
  br i1 %8, label %9, label %10

9:                                                ; preds = %3
  br label %10

10:                                               ; preds = %9, %3
  %11 = phi i1 [ false, %3 ], [ true, %9 ]
  %12 = xor i1 %11, true
  %13 = zext i1 %12 to i32
  %14 = sext i32 %13 to i64
  %15 = icmp ne i64 %14, 0
  br i1 %15, label %16, label %18

16:                                               ; preds = %10
  call void @__assert_rtn(ptr noundef @__func__.bounded_mpmc_init, ptr noundef @.str.6, i32 noundef 52, ptr noundef @.str.7) #4
  unreachable

17:                                               ; No predecessors!
  br label %19

18:                                               ; preds = %10
  br label %19

19:                                               ; preds = %18, %17
  %20 = load i32, ptr %6, align 4
  %21 = icmp ne i32 %20, 0
  br i1 %21, label %22, label %23

22:                                               ; preds = %19
  br label %23

23:                                               ; preds = %22, %19
  %24 = phi i1 [ false, %19 ], [ true, %22 ]
  %25 = xor i1 %24, true
  %26 = zext i1 %25 to i32
  %27 = sext i32 %26 to i64
  %28 = icmp ne i64 %27, 0
  br i1 %28, label %29, label %31

29:                                               ; preds = %23
  call void @__assert_rtn(ptr noundef @__func__.bounded_mpmc_init, ptr noundef @.str.6, i32 noundef 53, ptr noundef @.str.9) #4
  unreachable

30:                                               ; No predecessors!
  br label %32

31:                                               ; preds = %23
  br label %32

32:                                               ; preds = %31, %30
  %33 = load ptr, ptr %5, align 8
  %34 = load ptr, ptr %4, align 8
  %35 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %34, i32 0, i32 4
  store ptr %33, ptr %35, align 8
  %36 = load i32, ptr %6, align 4
  %37 = load ptr, ptr %4, align 8
  %38 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %37, i32 0, i32 5
  store i32 %36, ptr %38, align 8
  %39 = load ptr, ptr %4, align 8
  %40 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %39, i32 0, i32 2
  call void @vatomic32_init(ptr noundef %40, i32 noundef 0)
  %41 = load ptr, ptr %4, align 8
  %42 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %41, i32 0, i32 3
  call void @vatomic32_init(ptr noundef %42, i32 noundef 0)
  %43 = load ptr, ptr %4, align 8
  %44 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %43, i32 0, i32 0
  call void @vatomic32_init(ptr noundef %44, i32 noundef 0)
  %45 = load ptr, ptr %4, align 8
  %46 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %45, i32 0, i32 1
  call void @vatomic32_init(ptr noundef %46, i32 noundef 0)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @launch_threads(i64 noundef %0, ptr noundef %1) #0 {
  %3 = alloca i64, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store i64 %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load i64, ptr %3, align 8
  %7 = mul i64 32, %6
  %8 = call ptr @malloc(i64 noundef %7) #5
  store ptr %8, ptr %5, align 8
  %9 = load ptr, ptr %5, align 8
  %10 = load i64, ptr %3, align 8
  %11 = load ptr, ptr %4, align 8
  call void @create_threads(ptr noundef %9, i64 noundef %10, ptr noundef %11, i1 noundef zeroext true)
  %12 = load ptr, ptr %5, align 8
  %13 = load i64, ptr %3, align 8
  call void @await_threads(ptr noundef %12, i64 noundef %13)
  %14 = load ptr, ptr %5, align 8
  call void @free(ptr noundef %14)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @bounded_mpmc_deq(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  %8 = load ptr, ptr %4, align 8
  %9 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %8, i32 0, i32 2
  %10 = call i32 @vatomic32_read_acq(ptr noundef %9)
  store i32 %10, ptr %6, align 4
  %11 = load i32, ptr %6, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %7, align 4
  %13 = load i32, ptr %6, align 4
  %14 = load ptr, ptr %4, align 8
  %15 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %14, i32 0, i32 1
  %16 = call i32 @vatomic32_read_acq(ptr noundef %15)
  %17 = icmp eq i32 %13, %16
  br i1 %17, label %18, label %19

18:                                               ; preds = %2
  store i32 2, ptr %3, align 4
  br label %48

19:                                               ; preds = %2
  %20 = load ptr, ptr %4, align 8
  %21 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %20, i32 0, i32 2
  %22 = load i32, ptr %6, align 4
  %23 = load i32, ptr %7, align 4
  %24 = call i32 @vatomic32_cmpxchg_rel(ptr noundef %21, i32 noundef %22, i32 noundef %23)
  %25 = load i32, ptr %6, align 4
  %26 = icmp ne i32 %24, %25
  br i1 %26, label %27, label %28

27:                                               ; preds = %19
  store i32 3, ptr %3, align 4
  br label %48

28:                                               ; preds = %19
  %29 = load ptr, ptr %4, align 8
  %30 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %29, i32 0, i32 4
  %31 = load ptr, ptr %30, align 8
  %32 = load i32, ptr %6, align 4
  %33 = load ptr, ptr %4, align 8
  %34 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %33, i32 0, i32 5
  %35 = load i32, ptr %34, align 8
  %36 = urem i32 %32, %35
  %37 = zext i32 %36 to i64
  %38 = getelementptr inbounds ptr, ptr %31, i64 %37
  %39 = load ptr, ptr %38, align 8
  %40 = load ptr, ptr %5, align 8
  store ptr %39, ptr %40, align 8
  %41 = load ptr, ptr %4, align 8
  %42 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %41, i32 0, i32 3
  %43 = load i32, ptr %6, align 4
  %44 = call i32 @vatomic32_await_eq_rlx(ptr noundef %42, i32 noundef %43)
  %45 = load ptr, ptr %4, align 8
  %46 = getelementptr inbounds %struct.bounded_mpmc_s, ptr %45, i32 0, i32 3
  %47 = load i32, ptr %7, align 4
  call void @vatomic32_write_rel(ptr noundef %46, i32 noundef %47)
  store i32 0, ptr %3, align 4
  br label %48

48:                                               ; preds = %28, %27, %18
  %49 = load i32, ptr %3, align 4
  ret i32 %49
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_read_acq(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomic32_s, ptr %4, i32 0, i32 0
  %6 = call i32 asm sideeffect "ldr $0, $1 \0Admb ish\0A", "=&r,*Q,~{memory}"(ptr elementtype(i32) %5) #6, !srcloc !9
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_read_rlx(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomic32_s, ptr %4, i32 0, i32 0
  %6 = call i32 asm sideeffect "ldr $0, $1 \0A\0A", "=&r,*Q,~{memory}"(ptr elementtype(i32) %5) #6, !srcloc !10
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_cmpxchg_rel(ptr noundef %0, i32 noundef %1, i32 noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store i32 %1, ptr %5, align 4
  store i32 %2, ptr %6, align 4
  %9 = load i32, ptr %6, align 4
  %10 = load i32, ptr %5, align 4
  %11 = load ptr, ptr %4, align 8
  %12 = getelementptr inbounds %struct.vatomic32_s, ptr %11, i32 0, i32 0
  %13 = call { i32, i32 } asm sideeffect "dmb ish \0A1:\0Aldrex $0, $4\0Acmp $0, $3\0Abne 2f\0Astrex $1, $2, $4\0Acmp $1, #0 \0Abne 1b\0A2:\0A \0A", "=&r,=&r,r,r,*Q,~{memory},~{cc}"(i32 %9, i32 %10, ptr elementtype(i32) %12) #6, !srcloc !11
  %14 = extractvalue { i32, i32 } %13, 0
  %15 = extractvalue { i32, i32 } %13, 1
  store i32 %14, ptr %7, align 4
  store i32 %15, ptr %8, align 4
  %16 = load i32, ptr %7, align 4
  ret i32 %16
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_await_eq_acq(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %7 = load i32, ptr %4, align 4
  store i32 %7, ptr %5, align 4
  store i32 0, ptr %6, align 4
  call void @verification_loop_begin()
  br label %8

8:                                                ; preds = %22, %2
  call void @verification_spin_start()
  %9 = load ptr, ptr %3, align 8
  %10 = call i32 @vatomic32_read_acq(ptr noundef %9)
  store i32 %10, ptr %6, align 4
  %11 = load i32, ptr %4, align 4
  %12 = icmp ne i32 %10, %11
  br i1 %12, label %13, label %14

13:                                               ; preds = %8
  br label %15

14:                                               ; preds = %8
  call void @verification_spin_end(i32 noundef 1)
  br label %15

15:                                               ; preds = %14, %13
  %16 = phi i32 [ 1, %13 ], [ 0, %14 ]
  %17 = icmp ne i32 %16, 0
  br i1 %17, label %18, label %23

18:                                               ; preds = %15
  br label %19

19:                                               ; preds = %18
  br label %20

20:                                               ; preds = %19
  %21 = load i32, ptr %6, align 4
  store i32 %21, ptr %5, align 4
  br label %22

22:                                               ; preds = %20
  call void @verification_spin_end(i32 noundef 0)
  br label %8, !llvm.loop !12

23:                                               ; preds = %15
  %24 = load i32, ptr %5, align 4
  ret i32 %24
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomic32_write_rel(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load i32, ptr %4, align 4
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct.vatomic32_s, ptr %6, i32 0, i32 0
  call void asm sideeffect "dmb ish \0Astr $0, $1\0A \0A", "r,*Q,~{memory}"(i32 %5, ptr elementtype(i32) %7) #6, !srcloc !13
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @verification_loop_begin() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @verification_spin_start() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @verification_spin_end(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomic32_init(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8
  %6 = load i32, ptr %4, align 4
  call void @vatomic32_write(ptr noundef %5, i32 noundef %6)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomic32_write(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load i32, ptr %4, align 4
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct.vatomic32_s, ptr %6, i32 0, i32 0
  call void asm sideeffect "dmb ish \0Astr $0, $1\0Admb ish \0A", "r,*Q,~{memory}"(i32 %5, ptr elementtype(i32) %7) #6, !srcloc !14
  ret void
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @create_threads(ptr noundef %0, i64 noundef %1, ptr noundef %2, i1 noundef zeroext %3) #0 {
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store ptr %0, ptr %5, align 8
  store i64 %1, ptr %6, align 8
  store ptr %2, ptr %7, align 8
  %10 = zext i1 %3 to i8
  store i8 %10, ptr %8, align 1
  store i64 0, ptr %9, align 8
  store i64 0, ptr %9, align 8
  br label %11

11:                                               ; preds = %41, %4
  %12 = load i64, ptr %9, align 8
  %13 = load i64, ptr %6, align 8
  %14 = icmp ult i64 %12, %13
  br i1 %14, label %15, label %44

15:                                               ; preds = %11
  %16 = load i64, ptr %9, align 8
  %17 = load ptr, ptr %5, align 8
  %18 = load i64, ptr %9, align 8
  %19 = getelementptr inbounds %struct.run_info_t, ptr %17, i64 %18
  %20 = getelementptr inbounds %struct.run_info_t, ptr %19, i32 0, i32 1
  store i64 %16, ptr %20, align 8
  %21 = load ptr, ptr %7, align 8
  %22 = load ptr, ptr %5, align 8
  %23 = load i64, ptr %9, align 8
  %24 = getelementptr inbounds %struct.run_info_t, ptr %22, i64 %23
  %25 = getelementptr inbounds %struct.run_info_t, ptr %24, i32 0, i32 3
  store ptr %21, ptr %25, align 8
  %26 = load i8, ptr %8, align 1
  %27 = trunc i8 %26 to i1
  %28 = load ptr, ptr %5, align 8
  %29 = load i64, ptr %9, align 8
  %30 = getelementptr inbounds %struct.run_info_t, ptr %28, i64 %29
  %31 = getelementptr inbounds %struct.run_info_t, ptr %30, i32 0, i32 2
  %32 = zext i1 %27 to i8
  store i8 %32, ptr %31, align 8
  %33 = load ptr, ptr %5, align 8
  %34 = load i64, ptr %9, align 8
  %35 = getelementptr inbounds %struct.run_info_t, ptr %33, i64 %34
  %36 = getelementptr inbounds %struct.run_info_t, ptr %35, i32 0, i32 0
  %37 = load ptr, ptr %5, align 8
  %38 = load i64, ptr %9, align 8
  %39 = getelementptr inbounds %struct.run_info_t, ptr %37, i64 %38
  %40 = call i32 @pthread_create(ptr noundef %36, ptr noundef null, ptr noundef @common_run, ptr noundef %39)
  br label %41

41:                                               ; preds = %15
  %42 = load i64, ptr %9, align 8
  %43 = add i64 %42, 1
  store i64 %43, ptr %9, align 8
  br label %11, !llvm.loop !15

44:                                               ; preds = %11
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @await_threads(ptr noundef %0, i64 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store ptr %0, ptr %3, align 8
  store i64 %1, ptr %4, align 8
  store i64 0, ptr %5, align 8
  store i64 0, ptr %5, align 8
  br label %6

6:                                                ; preds = %17, %2
  %7 = load i64, ptr %5, align 8
  %8 = load i64, ptr %4, align 8
  %9 = icmp ult i64 %7, %8
  br i1 %9, label %10, label %20

10:                                               ; preds = %6
  %11 = load ptr, ptr %3, align 8
  %12 = load i64, ptr %5, align 8
  %13 = getelementptr inbounds %struct.run_info_t, ptr %11, i64 %12
  %14 = getelementptr inbounds %struct.run_info_t, ptr %13, i32 0, i32 0
  %15 = load ptr, ptr %14, align 8
  %16 = call i32 @"\01_pthread_join"(ptr noundef %15, ptr noundef null)
  br label %17

17:                                               ; preds = %10
  %18 = load i64, ptr %5, align 8
  %19 = add i64 %18, 1
  store i64 %19, ptr %5, align 8
  br label %6, !llvm.loop !16

20:                                               ; preds = %6
  ret void
}

declare void @free(ptr noundef) #3

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @common_run(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  store ptr %4, ptr %3, align 8
  %5 = load ptr, ptr %3, align 8
  %6 = getelementptr inbounds %struct.run_info_t, ptr %5, i32 0, i32 2
  %7 = load i8, ptr %6, align 8
  %8 = trunc i8 %7 to i1
  br i1 %8, label %9, label %13

9:                                                ; preds = %1
  %10 = load ptr, ptr %3, align 8
  %11 = getelementptr inbounds %struct.run_info_t, ptr %10, i32 0, i32 1
  %12 = load i64, ptr %11, align 8
  call void @set_cpu_affinity(i64 noundef %12)
  br label %13

13:                                               ; preds = %9, %1
  %14 = load ptr, ptr %3, align 8
  %15 = getelementptr inbounds %struct.run_info_t, ptr %14, i32 0, i32 3
  %16 = load ptr, ptr %15, align 8
  %17 = load ptr, ptr %3, align 8
  %18 = getelementptr inbounds %struct.run_info_t, ptr %17, i32 0, i32 1
  %19 = load i64, ptr %18, align 8
  %20 = inttoptr i64 %19 to ptr
  %21 = call ptr %16(ptr noundef %20)
  ret ptr %21
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @set_cpu_affinity(i64 noundef %0) #0 {
  %2 = alloca i64, align 8
  store i64 %0, ptr %2, align 8
  br label %3

3:                                                ; preds = %1
  br label %4

4:                                                ; preds = %3
  %5 = load i64, ptr %2, align 8
  br label %6

6:                                                ; preds = %4
  br label %7

7:                                                ; preds = %6
  br label %8

8:                                                ; preds = %7
  br label %9

9:                                                ; preds = %8
  ret void
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_await_eq_rlx(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %7 = load i32, ptr %4, align 4
  store i32 %7, ptr %5, align 4
  store i32 0, ptr %6, align 4
  call void @verification_loop_begin()
  br label %8

8:                                                ; preds = %22, %2
  call void @verification_spin_start()
  %9 = load ptr, ptr %3, align 8
  %10 = call i32 @vatomic32_read_rlx(ptr noundef %9)
  store i32 %10, ptr %6, align 4
  %11 = load i32, ptr %4, align 4
  %12 = icmp ne i32 %10, %11
  br i1 %12, label %13, label %14

13:                                               ; preds = %8
  br label %15

14:                                               ; preds = %8
  call void @verification_spin_end(i32 noundef 1)
  br label %15

15:                                               ; preds = %14, %13
  %16 = phi i32 [ 1, %13 ], [ 0, %14 ]
  %17 = icmp ne i32 %16, 0
  br i1 %17, label %18, label %23

18:                                               ; preds = %15
  br label %19

19:                                               ; preds = %18
  br label %20

20:                                               ; preds = %19
  %21 = load i32, ptr %6, align 4
  store i32 %21, ptr %5, align 4
  br label %22

22:                                               ; preds = %20
  call void @verification_spin_end(i32 noundef 0)
  br label %8, !llvm.loop !17

23:                                               ; preds = %15
  %24 = load i32, ptr %5, align 4
  ret i32 %24
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #4 = { cold noreturn }
attributes #5 = { allocsize(0) }
attributes #6 = { nounwind }

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
!9 = !{i64 1185131, i64 1185160}
!10 = !{i64 1185624, i64 1185653}
!11 = !{i64 1203708, i64 1203730, i64 1203745, i64 1203777, i64 1203810, i64 1203829, i64 1203869, i64 1203897, i64 1203916, i64 1203931}
!12 = distinct !{!12, !7}
!13 = !{i64 1189478, i64 1189500, i64 1189527}
!14 = !{i64 1188996, i64 1189018, i64 1189045}
!15 = distinct !{!15, !7}
!16 = distinct !{!16, !7}
!17 = distinct !{!17, !7}
