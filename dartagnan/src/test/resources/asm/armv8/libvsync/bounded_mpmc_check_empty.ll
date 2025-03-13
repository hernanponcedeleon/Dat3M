; ModuleID = 'test/queue/bounded_mpmc_check_empty.c'
source_filename = "test/queue/bounded_mpmc_check_empty.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.bounded_mpmc_s = type { %struct.vatomic32_s, %struct.vatomic32_s, %struct.vatomic32_s, %struct.vatomic32_s, ptr, i32 }
%struct.vatomic32_s = type { i32 }
%struct.xbo_s = type { i32, i32, i32, i32 }

@g_val = global [4 x i64] zeroinitializer, align 8
@g_queue = global %struct.bounded_mpmc_s zeroinitializer, align 8
@g_cs_x = global %struct.vatomic32_s zeroinitializer, align 4
@__func__.reader = private unnamed_addr constant [7 x i8] c"reader\00", align 1
@.str = private unnamed_addr constant [27 x i8] c"bounded_mpmc_check_empty.c\00", align 1
@.str.1 = private unnamed_addr constant [14 x i8] c"idx < (2 * 2)\00", align 1
@g_ret = global [4 x i64] zeroinitializer, align 8
@.str.2 = private unnamed_addr constant [16 x i8] c"g_ret[idx] != 0\00", align 1
@g_buf = global [4 x ptr] zeroinitializer, align 8
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str.3 = private unnamed_addr constant [17 x i8] c"found == (2 * 2)\00", align 1
@.str.4 = private unnamed_addr constant [13 x i8] c"x == (2 * 2)\00", align 1
@.str.5 = private unnamed_addr constant [27 x i8] c"ret == QUEUE_BOUNDED_EMPTY\00", align 1
@.str.6 = private unnamed_addr constant [15 x i8] c"buffer is NULL\00", align 1
@__func__.bounded_mpmc_init = private unnamed_addr constant [18 x i8] c"bounded_mpmc_init\00", align 1
@.str.7 = private unnamed_addr constant [15 x i8] c"bounded_mpmc.h\00", align 1
@.str.8 = private unnamed_addr constant [22 x i8] c"b && \22buffer is NULL\22\00", align 1
@.str.9 = private unnamed_addr constant [19 x i8] c"buffer with 0 size\00", align 1
@.str.10 = private unnamed_addr constant [31 x i8] c"s != 0 && \22buffer with 0 size\22\00", align 1

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
  call void @verification_ignore()
  br label %24, !llvm.loop !5

30:                                               ; preds = %24
  call void @xbo_reset(ptr noundef %4)
  br label %31

31:                                               ; preds = %30
  %32 = load i64, ptr %5, align 8
  %33 = add i64 %32, 1
  store i64 %33, ptr %5, align 8
  br label %9, !llvm.loop !7

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
define internal void @verification_ignore() #0 {
  call void @__VERIFIER_assume(i32 noundef 0)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @xbo_reset(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @reader(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca %struct.xbo_s, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %7 = load ptr, ptr %2, align 8
  %8 = ptrtoint ptr %7 to i64
  store i64 %8, ptr %3, align 8
  br label %9

9:                                                ; preds = %1
  br label %10

10:                                               ; preds = %9
  %11 = load i64, ptr %3, align 8
  br label %12

12:                                               ; preds = %10
  br label %13

13:                                               ; preds = %12
  br label %14

14:                                               ; preds = %13
  br label %15

15:                                               ; preds = %14
  call void @xbo_init(ptr noundef %4, i32 noundef 0, i32 noundef 100, i32 noundef 2)
  br label %16

16:                                               ; preds = %51, %15
  store ptr null, ptr %5, align 8
  %17 = call i32 @bounded_mpmc_deq(ptr noundef @g_queue, ptr noundef %5)
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %19, label %49

19:                                               ; preds = %16
  %20 = call i32 @vatomic32_get_inc_rlx(ptr noundef @g_cs_x)
  store i32 %20, ptr %6, align 4
  %21 = load i32, ptr %6, align 4
  %22 = icmp ult i32 %21, 4
  %23 = xor i1 %22, true
  %24 = zext i1 %23 to i32
  %25 = sext i32 %24 to i64
  %26 = icmp ne i64 %25, 0
  br i1 %26, label %27, label %29

27:                                               ; preds = %19
  call void @__assert_rtn(ptr noundef @__func__.reader, ptr noundef @.str, i32 noundef 87, ptr noundef @.str.1) #3
  unreachable

28:                                               ; No predecessors!
  br label %30

29:                                               ; preds = %19
  br label %30

30:                                               ; preds = %29, %28
  %31 = load ptr, ptr %5, align 8
  %32 = load i64, ptr %31, align 8
  %33 = load i32, ptr %6, align 4
  %34 = zext i32 %33 to i64
  %35 = getelementptr inbounds [4 x i64], ptr @g_ret, i64 0, i64 %34
  store i64 %32, ptr %35, align 8
  %36 = load i32, ptr %6, align 4
  %37 = zext i32 %36 to i64
  %38 = getelementptr inbounds [4 x i64], ptr @g_ret, i64 0, i64 %37
  %39 = load i64, ptr %38, align 8
  %40 = icmp ne i64 %39, 0
  %41 = xor i1 %40, true
  %42 = zext i1 %41 to i32
  %43 = sext i32 %42 to i64
  %44 = icmp ne i64 %43, 0
  br i1 %44, label %45, label %47

45:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.reader, ptr noundef @.str, i32 noundef 89, ptr noundef @.str.2) #3
  unreachable

46:                                               ; No predecessors!
  br label %48

47:                                               ; preds = %30
  br label %48

48:                                               ; preds = %47, %46
  br label %50

49:                                               ; preds = %16
  call void @verification_ignore()
  br label %50

50:                                               ; preds = %49, %48
  call void @xbo_reset(ptr noundef %4)
  br label %51

51:                                               ; preds = %50
  %52 = call i32 @vatomic32_read_rlx(ptr noundef @g_cs_x)
  %53 = icmp ne i32 %52, 4
  br i1 %53, label %16, label %54, !llvm.loop !8

54:                                               ; preds = %51
  ret ptr null
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

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_get_inc_rlx(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = call i32 @vatomic32_get_add_rlx(ptr noundef %3, i32 noundef 1)
  ret i32 %4
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_read_rlx(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomic32_s, ptr %4, i32 0, i32 0
  %6 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,*Q,~{memory}"(ptr elementtype(i32) %5) #4, !srcloc !9
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [4 x ptr], align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca ptr, align 8
  %11 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @bounded_mpmc_init(ptr noundef @g_queue, ptr noundef @g_buf, i32 noundef 4)
  store i64 0, ptr %3, align 8
  br label %12

12:                                               ; preds = %21, %0
  %13 = load i64, ptr %3, align 8
  %14 = icmp ult i64 %13, 2
  br i1 %14, label %15, label %24

15:                                               ; preds = %12
  %16 = load i64, ptr %3, align 8
  %17 = getelementptr inbounds [4 x ptr], ptr %2, i64 0, i64 %16
  %18 = load i64, ptr %3, align 8
  %19 = inttoptr i64 %18 to ptr
  %20 = call i32 @pthread_create(ptr noundef %17, ptr noundef null, ptr noundef @writer, ptr noundef %19)
  br label %21

21:                                               ; preds = %15
  %22 = load i64, ptr %3, align 8
  %23 = add i64 %22, 1
  store i64 %23, ptr %3, align 8
  br label %12, !llvm.loop !10

24:                                               ; preds = %12
  store i64 0, ptr %4, align 8
  br label %25

25:                                               ; preds = %35, %24
  %26 = load i64, ptr %4, align 8
  %27 = icmp ult i64 %26, 2
  br i1 %27, label %28, label %38

28:                                               ; preds = %25
  %29 = load i64, ptr %4, align 8
  %30 = add i64 2, %29
  %31 = getelementptr inbounds [4 x ptr], ptr %2, i64 0, i64 %30
  %32 = load i64, ptr %4, align 8
  %33 = inttoptr i64 %32 to ptr
  %34 = call i32 @pthread_create(ptr noundef %31, ptr noundef null, ptr noundef @reader, ptr noundef %33)
  br label %35

35:                                               ; preds = %28
  %36 = load i64, ptr %4, align 8
  %37 = add i64 %36, 1
  store i64 %37, ptr %4, align 8
  br label %25, !llvm.loop !11

38:                                               ; preds = %25
  store i64 0, ptr %5, align 8
  br label %39

39:                                               ; preds = %47, %38
  %40 = load i64, ptr %5, align 8
  %41 = icmp ult i64 %40, 4
  br i1 %41, label %42, label %50

42:                                               ; preds = %39
  %43 = load i64, ptr %5, align 8
  %44 = getelementptr inbounds [4 x ptr], ptr %2, i64 0, i64 %43
  %45 = load ptr, ptr %44, align 8
  %46 = call i32 @"\01_pthread_join"(ptr noundef %45, ptr noundef null)
  br label %47

47:                                               ; preds = %42
  %48 = load i64, ptr %5, align 8
  %49 = add i64 %48, 1
  store i64 %49, ptr %5, align 8
  br label %39, !llvm.loop !12

50:                                               ; preds = %39
  store i32 0, ptr %6, align 4
  store i32 0, ptr %7, align 4
  br label %51

51:                                               ; preds = %79, %50
  %52 = load i32, ptr %7, align 4
  %53 = icmp slt i32 %52, 4
  br i1 %53, label %54, label %82

54:                                               ; preds = %51
  store i32 0, ptr %8, align 4
  br label %55

55:                                               ; preds = %75, %54
  %56 = load i32, ptr %8, align 4
  %57 = icmp slt i32 %56, 4
  br i1 %57, label %58, label %78

58:                                               ; preds = %55
  %59 = load i32, ptr %7, align 4
  %60 = sext i32 %59 to i64
  %61 = getelementptr inbounds [4 x i64], ptr @g_val, i64 0, i64 %60
  %62 = load i64, ptr %61, align 8
  %63 = load i32, ptr %8, align 4
  %64 = sext i32 %63 to i64
  %65 = getelementptr inbounds [4 x i64], ptr @g_ret, i64 0, i64 %64
  %66 = load i64, ptr %65, align 8
  %67 = icmp eq i64 %62, %66
  br i1 %67, label %68, label %74

68:                                               ; preds = %58
  %69 = load i32, ptr %7, align 4
  %70 = sext i32 %69 to i64
  %71 = getelementptr inbounds [4 x i64], ptr @g_val, i64 0, i64 %70
  store i64 16777215, ptr %71, align 8
  %72 = load i32, ptr %6, align 4
  %73 = add nsw i32 %72, 1
  store i32 %73, ptr %6, align 4
  br label %78

74:                                               ; preds = %58
  br label %75

75:                                               ; preds = %74
  %76 = load i32, ptr %8, align 4
  %77 = add nsw i32 %76, 1
  store i32 %77, ptr %8, align 4
  br label %55, !llvm.loop !13

78:                                               ; preds = %68, %55
  br label %79

79:                                               ; preds = %78
  %80 = load i32, ptr %7, align 4
  %81 = add nsw i32 %80, 1
  store i32 %81, ptr %7, align 4
  br label %51, !llvm.loop !14

82:                                               ; preds = %51
  %83 = load i32, ptr %6, align 4
  %84 = icmp eq i32 %83, 4
  %85 = xor i1 %84, true
  %86 = zext i1 %85 to i32
  %87 = sext i32 %86 to i64
  %88 = icmp ne i64 %87, 0
  br i1 %88, label %89, label %91

89:                                               ; preds = %82
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 129, ptr noundef @.str.3) #3
  unreachable

90:                                               ; No predecessors!
  br label %92

91:                                               ; preds = %82
  br label %92

92:                                               ; preds = %91, %90
  %93 = call i32 @vatomic32_read(ptr noundef @g_cs_x)
  store i32 %93, ptr %9, align 4
  %94 = load i32, ptr %9, align 4
  %95 = icmp eq i32 %94, 4
  %96 = xor i1 %95, true
  %97 = zext i1 %96 to i32
  %98 = sext i32 %97 to i64
  %99 = icmp ne i64 %98, 0
  br i1 %99, label %100, label %102

100:                                              ; preds = %92
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 131, ptr noundef @.str.4) #3
  unreachable

101:                                              ; No predecessors!
  br label %103

102:                                              ; preds = %92
  br label %103

103:                                              ; preds = %102, %101
  store ptr null, ptr %10, align 8
  %104 = call i32 @bounded_mpmc_deq(ptr noundef @g_queue, ptr noundef %10)
  store i32 %104, ptr %11, align 4
  %105 = load i32, ptr %11, align 4
  %106 = icmp eq i32 %105, 2
  %107 = xor i1 %106, true
  %108 = zext i1 %107 to i32
  %109 = sext i32 %108 to i64
  %110 = icmp ne i64 %109, 0
  br i1 %110, label %111, label %113

111:                                              ; preds = %103
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 135, ptr noundef @.str.5) #3
  unreachable

112:                                              ; No predecessors!
  br label %114

113:                                              ; preds = %103
  br label %114

114:                                              ; preds = %113, %112
  br label %115

115:                                              ; preds = %114
  br label %116

116:                                              ; preds = %115
  %117 = load ptr, ptr %10, align 8
  br label %118

118:                                              ; preds = %116
  %119 = load i32, ptr %11, align 4
  br label %120

120:                                              ; preds = %118
  %121 = load i32, ptr %9, align 4
  br label %122

122:                                              ; preds = %120
  br label %123

123:                                              ; preds = %122
  br label %124

124:                                              ; preds = %123
  br label %125

125:                                              ; preds = %124
  br label %126

126:                                              ; preds = %125
  br label %127

127:                                              ; preds = %126
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
  call void @__assert_rtn(ptr noundef @__func__.bounded_mpmc_init, ptr noundef @.str.7, i32 noundef 52, ptr noundef @.str.8) #3
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
  call void @__assert_rtn(ptr noundef @__func__.bounded_mpmc_init, ptr noundef @.str.7, i32 noundef 53, ptr noundef @.str.10) #3
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

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_read(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomic32_s, ptr %4, i32 0, i32 0
  %6 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,*Q,~{memory}"(ptr elementtype(i32) %5) #4, !srcloc !15
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_read_acq(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomic32_s, ptr %4, i32 0, i32 0
  %6 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,*Q,~{memory}"(ptr elementtype(i32) %5) #4, !srcloc !16
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
  %13 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astlxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,*Q,~{memory},~{cc}"(i32 %9, i32 %10, ptr elementtype(i32) %12) #4, !srcloc !17
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
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %6 = load i32, ptr %4, align 4
  %7 = load ptr, ptr %3, align 8
  %8 = getelementptr inbounds %struct.vatomic32_s, ptr %7, i32 0, i32 0
  %9 = call i32 asm sideeffect "1:\0Aldar ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.ne 1b\0A", "=&r,r,*Q,~{memory},~{cc}"(i32 %6, ptr elementtype(i32) %8) #4, !srcloc !18
  store i32 %9, ptr %5, align 4
  %10 = load i32, ptr %5, align 4
  ret i32 %10
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
  call void asm sideeffect "stlr ${0:w}, $1", "r,*Q,~{memory}"(i32 %5, ptr elementtype(i32) %7) #4, !srcloc !19
  ret void
}

declare void @__VERIFIER_assume(i32 noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_await_eq_rlx(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %6 = load i32, ptr %4, align 4
  %7 = load ptr, ptr %3, align 8
  %8 = getelementptr inbounds %struct.vatomic32_s, ptr %7, i32 0, i32 0
  %9 = call i32 asm sideeffect "1:\0Aldr ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.ne 1b\0A", "=&r,r,*Q,~{memory},~{cc}"(i32 %6, ptr elementtype(i32) %8) #4, !srcloc !20
  store i32 %9, ptr %5, align 4
  %10 = load i32, ptr %5, align 4
  ret i32 %10
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_get_add_rlx(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %8 = load i32, ptr %4, align 4
  %9 = load ptr, ptr %3, align 8
  %10 = getelementptr inbounds %struct.vatomic32_s, ptr %9, i32 0, i32 0
  %11 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,*Q,3,~{memory},~{cc}"(ptr elementtype(i32) %10, i32 %8) #4, !srcloc !21
  %12 = extractvalue { i32, i32, i32, i32 } %11, 0
  %13 = extractvalue { i32, i32, i32, i32 } %11, 1
  %14 = extractvalue { i32, i32, i32, i32 } %11, 2
  %15 = extractvalue { i32, i32, i32, i32 } %11, 3
  store i32 %12, ptr %5, align 4
  store i32 %13, ptr %7, align 4
  store i32 %14, ptr %6, align 4
  store i32 %15, ptr %4, align 4
  %16 = load i32, ptr %5, align 4
  ret i32 %16
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
  call void asm sideeffect "stlr ${0:w}, $1", "r,*Q,~{memory}"(i32 %5, ptr elementtype(i32) %7) #4, !srcloc !22
  ret void
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 1}
!3 = !{i32 7, !"frame-pointer", i32 1}
!4 = !{!"Homebrew clang version 19.1.2"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = distinct !{!7, !6}
!8 = distinct !{!8, !6}
!9 = !{i64 1186197}
!10 = distinct !{!10, !6}
!11 = distinct !{!11, !6}
!12 = distinct !{!12, !6}
!13 = distinct !{!13, !6}
!14 = distinct !{!14, !6}
!15 = !{i64 1185193}
!16 = !{i64 1185695}
!17 = !{i64 1251872, i64 1251906, i64 1251921, i64 1251953, i64 1251987, i64 1252007, i64 1252050, i64 1252079}
!18 = !{i64 1200733, i64 1200749, i64 1200780, i64 1200813}
!19 = !{i64 1190111}
!20 = !{i64 1207650, i64 1207666, i64 1207696, i64 1207729}
!21 = !{i64 1283280, i64 1283314, i64 1283329, i64 1283361, i64 1283403, i64 1283444}
!22 = !{i64 1189641}
