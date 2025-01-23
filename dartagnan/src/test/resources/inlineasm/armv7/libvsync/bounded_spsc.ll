; ModuleID = 'test/queue/bounded_spsc.c'
source_filename = "test/queue/bounded_spsc.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.bounded_spsc_t = type { ptr, %struct.vatomic32_s, %struct.vatomic32_s, i32 }
%struct.vatomic32_s = type { i32 }
%struct.point_s = type { i32, i32 }
%struct.run_info_t = type { ptr, i64, i8, ptr }

@g_points = global [3 x ptr] zeroinitializer, align 8
@g_queue = global %struct.bounded_spsc_t zeroinitializer, align 8
@__func__.run = private unnamed_addr constant [4 x i8] c"run\00", align 1
@.str = private unnamed_addr constant [15 x i8] c"bounded_spsc.c\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"point->x == point->y\00", align 1
@.str.2 = private unnamed_addr constant [14 x i8] c"point->x == 1\00", align 1
@.str.3 = private unnamed_addr constant [21 x i8] c"0 && \22dequeued NULL\22\00", align 1
@g_buf = global [2 x ptr] zeroinitializer, align 8
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str.4 = private unnamed_addr constant [25 x i8] c"0 && \22allocation failed\22\00", align 1
@g_cs_x = global %struct.vatomic32_s zeroinitializer, align 4
@.str.5 = private unnamed_addr constant [10 x i8] c"q == NULL\00", align 1
@__func__.bounded_spsc_enq = private unnamed_addr constant [17 x i8] c"bounded_spsc_enq\00", align 1
@.str.6 = private unnamed_addr constant [15 x i8] c"bounded_spsc.h\00", align 1
@.str.7 = private unnamed_addr constant [17 x i8] c"q && \22q == NULL\22\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"v == NULL\00", align 1
@.str.9 = private unnamed_addr constant [17 x i8] c"v && \22v == NULL\22\00", align 1
@__func__.bounded_spsc_deq = private unnamed_addr constant [17 x i8] c"bounded_spsc_deq\00", align 1
@.str.10 = private unnamed_addr constant [15 x i8] c"buffer is NULL\00", align 1
@__func__.bounded_spsc_init = private unnamed_addr constant [18 x i8] c"bounded_spsc_init\00", align 1
@.str.11 = private unnamed_addr constant [22 x i8] c"b && \22buffer is NULL\22\00", align 1
@.str.12 = private unnamed_addr constant [19 x i8] c"buffer with 0 size\00", align 1
@.str.13 = private unnamed_addr constant [31 x i8] c"s != 0 && \22buffer with 0 size\22\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %9 = load ptr, ptr %2, align 8
  %10 = ptrtoint ptr %9 to i64
  store i64 %10, ptr %3, align 8
  %11 = load i64, ptr %3, align 8
  %12 = icmp eq i64 %11, 0
  br i1 %12, label %13, label %41

13:                                               ; preds = %1
  store i64 0, ptr %4, align 8
  br label %14

14:                                               ; preds = %37, %13
  %15 = load i64, ptr %4, align 8
  %16 = icmp ult i64 %15, 3
  br i1 %16, label %17, label %40

17:                                               ; preds = %14
  %18 = load i64, ptr %4, align 8
  %19 = getelementptr inbounds [3 x ptr], ptr @g_points, i64 0, i64 %18
  %20 = load ptr, ptr %19, align 8
  store ptr %20, ptr %5, align 8
  %21 = load ptr, ptr %5, align 8
  %22 = getelementptr inbounds %struct.point_s, ptr %21, i32 0, i32 0
  store i32 1, ptr %22, align 4
  %23 = load ptr, ptr %5, align 8
  %24 = getelementptr inbounds %struct.point_s, ptr %23, i32 0, i32 1
  store i32 1, ptr %24, align 4
  call void @verification_loop_begin()
  br label %25

25:                                               ; preds = %35, %17
  call void @verification_spin_start()
  %26 = load ptr, ptr %5, align 8
  %27 = call i32 @bounded_spsc_enq(ptr noundef @g_queue, ptr noundef %26)
  %28 = icmp ne i32 %27, 0
  br i1 %28, label %29, label %30

29:                                               ; preds = %25
  br label %31

30:                                               ; preds = %25
  call void @verification_spin_end(i32 noundef 1)
  br label %31

31:                                               ; preds = %30, %29
  %32 = phi i32 [ 1, %29 ], [ 0, %30 ]
  %33 = icmp ne i32 %32, 0
  br i1 %33, label %34, label %36

34:                                               ; preds = %31
  br label %35

35:                                               ; preds = %34
  call void @verification_spin_end(i32 noundef 0)
  br label %25, !llvm.loop !6

36:                                               ; preds = %31
  br label %37

37:                                               ; preds = %36
  %38 = load i64, ptr %4, align 8
  %39 = add i64 %38, 1
  store i64 %39, ptr %4, align 8
  br label %14, !llvm.loop !8

40:                                               ; preds = %14
  br label %95

41:                                               ; preds = %1
  store i32 0, ptr %6, align 4
  br label %42

42:                                               ; preds = %91, %41
  %43 = load i32, ptr %6, align 4
  %44 = icmp slt i32 %43, 3
  br i1 %44, label %45, label %94

45:                                               ; preds = %42
  store ptr null, ptr %7, align 8
  call void @verification_loop_begin()
  br label %46

46:                                               ; preds = %55, %45
  call void @verification_spin_start()
  %47 = call i32 @bounded_spsc_deq(ptr noundef @g_queue, ptr noundef %7)
  %48 = icmp ne i32 %47, 0
  br i1 %48, label %49, label %50

49:                                               ; preds = %46
  br label %51

50:                                               ; preds = %46
  call void @verification_spin_end(i32 noundef 1)
  br label %51

51:                                               ; preds = %50, %49
  %52 = phi i32 [ 1, %49 ], [ 0, %50 ]
  %53 = icmp ne i32 %52, 0
  br i1 %53, label %54, label %56

54:                                               ; preds = %51
  br label %55

55:                                               ; preds = %54
  call void @verification_spin_end(i32 noundef 0)
  br label %46, !llvm.loop !9

56:                                               ; preds = %51
  %57 = load ptr, ptr %7, align 8
  store ptr %57, ptr %8, align 8
  %58 = load ptr, ptr %8, align 8
  %59 = icmp ne ptr %58, null
  br i1 %59, label %60, label %89

60:                                               ; preds = %56
  %61 = load ptr, ptr %8, align 8
  %62 = getelementptr inbounds %struct.point_s, ptr %61, i32 0, i32 0
  %63 = load i32, ptr %62, align 4
  %64 = load ptr, ptr %8, align 8
  %65 = getelementptr inbounds %struct.point_s, ptr %64, i32 0, i32 1
  %66 = load i32, ptr %65, align 4
  %67 = icmp eq i32 %63, %66
  %68 = xor i1 %67, true
  %69 = zext i1 %68 to i32
  %70 = sext i32 %69 to i64
  %71 = icmp ne i64 %70, 0
  br i1 %71, label %72, label %74

72:                                               ; preds = %60
  call void @__assert_rtn(ptr noundef @__func__.run, ptr noundef @.str, i32 noundef 49, ptr noundef @.str.1) #4
  unreachable

73:                                               ; No predecessors!
  br label %75

74:                                               ; preds = %60
  br label %75

75:                                               ; preds = %74, %73
  %76 = load ptr, ptr %8, align 8
  %77 = getelementptr inbounds %struct.point_s, ptr %76, i32 0, i32 0
  %78 = load i32, ptr %77, align 4
  %79 = icmp eq i32 %78, 1
  %80 = xor i1 %79, true
  %81 = zext i1 %80 to i32
  %82 = sext i32 %81 to i64
  %83 = icmp ne i64 %82, 0
  br i1 %83, label %84, label %86

84:                                               ; preds = %75
  call void @__assert_rtn(ptr noundef @__func__.run, ptr noundef @.str, i32 noundef 50, ptr noundef @.str.2) #4
  unreachable

85:                                               ; No predecessors!
  br label %87

86:                                               ; preds = %75
  br label %87

87:                                               ; preds = %86, %85
  %88 = load ptr, ptr %8, align 8
  call void @free(ptr noundef %88)
  br label %90

89:                                               ; preds = %56
  call void @__assert_rtn(ptr noundef @__func__.run, ptr noundef @.str, i32 noundef 53, ptr noundef @.str.3) #4
  unreachable

90:                                               ; preds = %87
  br label %91

91:                                               ; preds = %90
  %92 = load i32, ptr %6, align 4
  %93 = add nsw i32 %92, 1
  store i32 %93, ptr %6, align 4
  br label %42, !llvm.loop !10

94:                                               ; preds = %42
  br label %95

95:                                               ; preds = %94, %40
  ret ptr null
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
define internal i32 @bounded_spsc_enq(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  %8 = load ptr, ptr %4, align 8
  %9 = icmp ne ptr %8, null
  br i1 %9, label %10, label %11

10:                                               ; preds = %2
  br label %11

11:                                               ; preds = %10, %2
  %12 = phi i1 [ false, %2 ], [ true, %10 ]
  %13 = xor i1 %12, true
  %14 = zext i1 %13 to i32
  %15 = sext i32 %14 to i64
  %16 = icmp ne i64 %15, 0
  br i1 %16, label %17, label %19

17:                                               ; preds = %11
  call void @__assert_rtn(ptr noundef @__func__.bounded_spsc_enq, ptr noundef @.str.6, i32 noundef 66, ptr noundef @.str.7) #4
  unreachable

18:                                               ; No predecessors!
  br label %20

19:                                               ; preds = %11
  br label %20

20:                                               ; preds = %19, %18
  %21 = load ptr, ptr %5, align 8
  %22 = icmp ne ptr %21, null
  br i1 %22, label %23, label %24

23:                                               ; preds = %20
  br label %24

24:                                               ; preds = %23, %20
  %25 = phi i1 [ false, %20 ], [ true, %23 ]
  %26 = xor i1 %25, true
  %27 = zext i1 %26 to i32
  %28 = sext i32 %27 to i64
  %29 = icmp ne i64 %28, 0
  br i1 %29, label %30, label %32

30:                                               ; preds = %24
  call void @__assert_rtn(ptr noundef @__func__.bounded_spsc_enq, ptr noundef @.str.6, i32 noundef 67, ptr noundef @.str.9) #4
  unreachable

31:                                               ; No predecessors!
  br label %33

32:                                               ; preds = %24
  br label %33

33:                                               ; preds = %32, %31
  %34 = load ptr, ptr %4, align 8
  %35 = getelementptr inbounds %struct.bounded_spsc_t, ptr %34, i32 0, i32 2
  %36 = call i32 @vatomic32_read_rlx(ptr noundef %35)
  store i32 %36, ptr %6, align 4
  %37 = load ptr, ptr %4, align 8
  %38 = getelementptr inbounds %struct.bounded_spsc_t, ptr %37, i32 0, i32 1
  %39 = call i32 @vatomic32_read_rlx(ptr noundef %38)
  store i32 %39, ptr %7, align 4
  %40 = load i32, ptr %6, align 4
  %41 = load i32, ptr %7, align 4
  %42 = sub i32 %40, %41
  %43 = load ptr, ptr %4, align 8
  %44 = getelementptr inbounds %struct.bounded_spsc_t, ptr %43, i32 0, i32 3
  %45 = load i32, ptr %44, align 8
  %46 = icmp eq i32 %42, %45
  br i1 %46, label %47, label %48

47:                                               ; preds = %33
  store i32 1, ptr %3, align 4
  br label %64

48:                                               ; preds = %33
  %49 = load ptr, ptr %5, align 8
  %50 = load ptr, ptr %4, align 8
  %51 = getelementptr inbounds %struct.bounded_spsc_t, ptr %50, i32 0, i32 0
  %52 = load ptr, ptr %51, align 8
  %53 = load i32, ptr %6, align 4
  %54 = load ptr, ptr %4, align 8
  %55 = getelementptr inbounds %struct.bounded_spsc_t, ptr %54, i32 0, i32 3
  %56 = load i32, ptr %55, align 8
  %57 = urem i32 %53, %56
  %58 = zext i32 %57 to i64
  %59 = getelementptr inbounds ptr, ptr %52, i64 %58
  store ptr %49, ptr %59, align 8
  %60 = load ptr, ptr %4, align 8
  %61 = getelementptr inbounds %struct.bounded_spsc_t, ptr %60, i32 0, i32 2
  %62 = load i32, ptr %6, align 4
  %63 = add i32 %62, 1
  call void @vatomic32_write_rel(ptr noundef %61, i32 noundef %63)
  store i32 0, ptr %3, align 4
  br label %64

64:                                               ; preds = %48, %47
  %65 = load i32, ptr %3, align 4
  ret i32 %65
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @verification_spin_end(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @bounded_spsc_deq(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  %8 = load ptr, ptr %4, align 8
  %9 = icmp ne ptr %8, null
  br i1 %9, label %10, label %11

10:                                               ; preds = %2
  br label %11

11:                                               ; preds = %10, %2
  %12 = phi i1 [ false, %2 ], [ true, %10 ]
  %13 = xor i1 %12, true
  %14 = zext i1 %13 to i32
  %15 = sext i32 %14 to i64
  %16 = icmp ne i64 %15, 0
  br i1 %16, label %17, label %19

17:                                               ; preds = %11
  call void @__assert_rtn(ptr noundef @__func__.bounded_spsc_deq, ptr noundef @.str.6, i32 noundef 94, ptr noundef @.str.7) #4
  unreachable

18:                                               ; No predecessors!
  br label %20

19:                                               ; preds = %11
  br label %20

20:                                               ; preds = %19, %18
  %21 = load ptr, ptr %5, align 8
  %22 = icmp ne ptr %21, null
  br i1 %22, label %23, label %24

23:                                               ; preds = %20
  br label %24

24:                                               ; preds = %23, %20
  %25 = phi i1 [ false, %20 ], [ true, %23 ]
  %26 = xor i1 %25, true
  %27 = zext i1 %26 to i32
  %28 = sext i32 %27 to i64
  %29 = icmp ne i64 %28, 0
  br i1 %29, label %30, label %32

30:                                               ; preds = %24
  call void @__assert_rtn(ptr noundef @__func__.bounded_spsc_deq, ptr noundef @.str.6, i32 noundef 95, ptr noundef @.str.9) #4
  unreachable

31:                                               ; No predecessors!
  br label %33

32:                                               ; preds = %24
  br label %33

33:                                               ; preds = %32, %31
  %34 = load ptr, ptr %4, align 8
  %35 = getelementptr inbounds %struct.bounded_spsc_t, ptr %34, i32 0, i32 1
  %36 = call i32 @vatomic32_read_rlx(ptr noundef %35)
  store i32 %36, ptr %6, align 4
  %37 = load ptr, ptr %4, align 8
  %38 = getelementptr inbounds %struct.bounded_spsc_t, ptr %37, i32 0, i32 2
  %39 = call i32 @vatomic32_read_acq(ptr noundef %38)
  store i32 %39, ptr %7, align 4
  %40 = load i32, ptr %7, align 4
  %41 = load i32, ptr %6, align 4
  %42 = sub i32 %40, %41
  %43 = icmp eq i32 %42, 0
  br i1 %43, label %44, label %45

44:                                               ; preds = %33
  store i32 2, ptr %3, align 4
  br label %62

45:                                               ; preds = %33
  %46 = load ptr, ptr %4, align 8
  %47 = getelementptr inbounds %struct.bounded_spsc_t, ptr %46, i32 0, i32 0
  %48 = load ptr, ptr %47, align 8
  %49 = load i32, ptr %6, align 4
  %50 = load ptr, ptr %4, align 8
  %51 = getelementptr inbounds %struct.bounded_spsc_t, ptr %50, i32 0, i32 3
  %52 = load i32, ptr %51, align 8
  %53 = urem i32 %49, %52
  %54 = zext i32 %53 to i64
  %55 = getelementptr inbounds ptr, ptr %48, i64 %54
  %56 = load ptr, ptr %55, align 8
  %57 = load ptr, ptr %5, align 8
  store ptr %56, ptr %57, align 8
  %58 = load ptr, ptr %4, align 8
  %59 = getelementptr inbounds %struct.bounded_spsc_t, ptr %58, i32 0, i32 1
  %60 = load i32, ptr %6, align 4
  %61 = add i32 %60, 1
  call void @vatomic32_write_rel(ptr noundef %59, i32 noundef %61)
  store i32 0, ptr %3, align 4
  br label %62

62:                                               ; preds = %45, %44
  %63 = load i32, ptr %3, align 4
  ret i32 %63
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

declare void @free(ptr noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  call void @bounded_spsc_init(ptr noundef @g_queue, ptr noundef @g_buf, i32 noundef 2)
  store i64 0, ptr %2, align 8
  br label %3

3:                                                ; preds = %16, %0
  %4 = load i64, ptr %2, align 8
  %5 = icmp ult i64 %4, 3
  br i1 %5, label %6, label %19

6:                                                ; preds = %3
  %7 = call ptr @malloc(i64 noundef 8) #5
  %8 = load i64, ptr %2, align 8
  %9 = getelementptr inbounds [3 x ptr], ptr @g_points, i64 0, i64 %8
  store ptr %7, ptr %9, align 8
  %10 = load i64, ptr %2, align 8
  %11 = getelementptr inbounds [3 x ptr], ptr @g_points, i64 0, i64 %10
  %12 = load ptr, ptr %11, align 8
  %13 = icmp eq ptr %12, null
  br i1 %13, label %14, label %15

14:                                               ; preds = %6
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 67, ptr noundef @.str.4) #4
  unreachable

15:                                               ; preds = %6
  br label %16

16:                                               ; preds = %15
  %17 = load i64, ptr %2, align 8
  %18 = add i64 %17, 1
  store i64 %18, ptr %2, align 8
  br label %3, !llvm.loop !11

19:                                               ; preds = %3
  call void @launch_threads(i64 noundef 2, ptr noundef @run)
  ret i32 0
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @bounded_spsc_init(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 {
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
  call void @__assert_rtn(ptr noundef @__func__.bounded_spsc_init, ptr noundef @.str.6, i32 noundef 45, ptr noundef @.str.11) #4
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
  call void @__assert_rtn(ptr noundef @__func__.bounded_spsc_init, ptr noundef @.str.6, i32 noundef 46, ptr noundef @.str.13) #4
  unreachable

30:                                               ; No predecessors!
  br label %32

31:                                               ; preds = %23
  br label %32

32:                                               ; preds = %31, %30
  %33 = load ptr, ptr %5, align 8
  %34 = load ptr, ptr %4, align 8
  %35 = getelementptr inbounds %struct.bounded_spsc_t, ptr %34, i32 0, i32 0
  store ptr %33, ptr %35, align 8
  %36 = load i32, ptr %6, align 4
  %37 = load ptr, ptr %4, align 8
  %38 = getelementptr inbounds %struct.bounded_spsc_t, ptr %37, i32 0, i32 3
  store i32 %36, ptr %38, align 8
  %39 = load ptr, ptr %4, align 8
  %40 = getelementptr inbounds %struct.bounded_spsc_t, ptr %39, i32 0, i32 1
  call void @vatomic32_init(ptr noundef %40, i32 noundef 0)
  %41 = load ptr, ptr %4, align 8
  %42 = getelementptr inbounds %struct.bounded_spsc_t, ptr %41, i32 0, i32 2
  call void @vatomic32_init(ptr noundef %42, i32 noundef 0)
  ret void
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #3

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
define internal i32 @vatomic32_read_rlx(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomic32_s, ptr %4, i32 0, i32 0
  %6 = call i32 asm sideeffect "ldr $0, $1 \0A\0A", "=&r,*Q,~{memory}"(ptr elementtype(i32) %5) #6, !srcloc !12
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  ret i32 %7
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
define internal i32 @vatomic32_read_acq(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomic32_s, ptr %4, i32 0, i32 0
  %6 = call i32 asm sideeffect "ldr $0, $1 \0Admb ish\0A", "=&r,*Q,~{memory}"(ptr elementtype(i32) %5) #6, !srcloc !14
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  ret i32 %7
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
  call void asm sideeffect "dmb ish \0Astr $0, $1\0Admb ish \0A", "r,*Q,~{memory}"(i32 %5, ptr elementtype(i32) %7) #6, !srcloc !15
  ret void
}

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
  br label %11, !llvm.loop !16

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
  br label %6, !llvm.loop !17

20:                                               ; preds = %6
  ret void
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

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

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
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
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = !{i64 1396870, i64 1396899}
!13 = !{i64 1400724, i64 1400746, i64 1400773}
!14 = !{i64 1396377, i64 1396406}
!15 = !{i64 1400242, i64 1400264, i64 1400291}
!16 = distinct !{!16, !7}
!17 = distinct !{!17, !7}
