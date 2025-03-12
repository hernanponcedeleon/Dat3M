; ModuleID = 'test/spinlock/rec_seqlock.c'
source_filename = "test/spinlock/rec_seqlock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.rec_seqlock_s = type { %struct.seqlock_s, %struct.vatomic32_s, i32, [116 x i8] }
%struct.seqlock_s = type { %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }

@lock = global %struct.rec_seqlock_s zeroinitializer, align 128
@g_cs_x = global i32 0, align 4
@g_cs_y = global i32 0, align 4
@__func__.reader_cs = private unnamed_addr constant [10 x i8] c"reader_cs\00", align 1
@.str = private unnamed_addr constant [14 x i8] c"rec_seqlock.c\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"a == b\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"(s % 2) == 0\00", align 1
@__func__.fini = private unnamed_addr constant [5 x i8] c"fini\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"x == y\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"x == 2\00", align 1
@.str.5 = private unnamed_addr constant [23 x i8] c"this value is reserved\00", align 1
@__func__.rec_seqlock_acquire = private unnamed_addr constant [20 x i8] c"rec_seqlock_acquire\00", align 1
@.str.6 = private unnamed_addr constant [14 x i8] c"rec_seqlock.h\00", align 1
@.str.7 = private unnamed_addr constant [46 x i8] c"id != 4294967295U && \22this value is reserved\22\00", align 1
@__func__._seqlock_await_even = private unnamed_addr constant [20 x i8] c"_seqlock_await_even\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"seqlock.h\00", align 1
@.str.9 = private unnamed_addr constant [21 x i8] c"(((count)&1U) == 0U)\00", align 1
@__func__.seqlock_release = private unnamed_addr constant [16 x i8] c"seqlock_release\00", align 1
@.str.10 = private unnamed_addr constant [27 x i8] c"(cur_val & 0x1UL) == 0x1UL\00", align 1
@__func__.seqlock_rend = private unnamed_addr constant [13 x i8] c"seqlock_rend\00", align 1
@.str.11 = private unnamed_addr constant [18 x i8] c"(((sv)&1U) == 0U)\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @post() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @check() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @writer_acquire(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  br label %3

3:                                                ; preds = %1
  br label %4

4:                                                ; preds = %3
  %5 = load i32, ptr %2, align 4
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

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @writer_release(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  br label %3

3:                                                ; preds = %1
  br label %4

4:                                                ; preds = %3
  %5 = load i32, ptr %2, align 4
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

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @reader_acquire(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  br label %3

3:                                                ; preds = %1
  br label %4

4:                                                ; preds = %3
  %5 = load i32, ptr %2, align 4
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

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @reader_release(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  br label %3

3:                                                ; preds = %1
  br label %4

4:                                                ; preds = %3
  %5 = load i32, ptr %2, align 4
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

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [4 x ptr], align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  call void @init()
  call void @verification_loop_bound(i32 noundef 3)
  store i64 0, ptr %3, align 8
  br label %6

6:                                                ; preds = %15, %0
  %7 = load i64, ptr %3, align 8
  %8 = icmp ult i64 %7, 2
  br i1 %8, label %9, label %18

9:                                                ; preds = %6
  %10 = load i64, ptr %3, align 8
  %11 = getelementptr inbounds [4 x ptr], ptr %2, i64 0, i64 %10
  %12 = load i64, ptr %3, align 8
  %13 = inttoptr i64 %12 to ptr
  %14 = call i32 @pthread_create(ptr noundef %11, ptr noundef null, ptr noundef @writer, ptr noundef %13)
  br label %15

15:                                               ; preds = %9
  %16 = load i64, ptr %3, align 8
  %17 = add i64 %16, 1
  store i64 %17, ptr %3, align 8
  br label %6, !llvm.loop !5

18:                                               ; preds = %6
  call void @verification_loop_bound(i32 noundef 5)
  store i64 2, ptr %4, align 8
  br label %19

19:                                               ; preds = %28, %18
  %20 = load i64, ptr %4, align 8
  %21 = icmp ult i64 %20, 4
  br i1 %21, label %22, label %31

22:                                               ; preds = %19
  %23 = load i64, ptr %4, align 8
  %24 = getelementptr inbounds [4 x ptr], ptr %2, i64 0, i64 %23
  %25 = load i64, ptr %4, align 8
  %26 = inttoptr i64 %25 to ptr
  %27 = call i32 @pthread_create(ptr noundef %24, ptr noundef null, ptr noundef @reader, ptr noundef %26)
  br label %28

28:                                               ; preds = %22
  %29 = load i64, ptr %4, align 8
  %30 = add i64 %29, 1
  store i64 %30, ptr %4, align 8
  br label %19, !llvm.loop !7

31:                                               ; preds = %19
  call void @post()
  call void @verification_loop_bound(i32 noundef 5)
  store i64 0, ptr %5, align 8
  br label %32

32:                                               ; preds = %40, %31
  %33 = load i64, ptr %5, align 8
  %34 = icmp ult i64 %33, 4
  br i1 %34, label %35, label %43

35:                                               ; preds = %32
  %36 = load i64, ptr %5, align 8
  %37 = getelementptr inbounds [4 x ptr], ptr %2, i64 0, i64 %36
  %38 = load ptr, ptr %37, align 8
  %39 = call i32 @"\01_pthread_join"(ptr noundef %38, ptr noundef null)
  br label %40

40:                                               ; preds = %35
  %41 = load i64, ptr %5, align 8
  %42 = add i64 %41, 1
  store i64 %42, ptr %5, align 8
  br label %32, !llvm.loop !8

43:                                               ; preds = %32
  call void @check()
  call void @fini()
  ret i32 0
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @init() #0 {
  call void @rec_seqlock_init(ptr noundef @lock)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @verification_loop_bound(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  br label %3

3:                                                ; preds = %1
  br label %4

4:                                                ; preds = %3
  %5 = load i32, ptr %2, align 4
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

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @writer(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = ptrtoint ptr %4 to i64
  %6 = trunc i64 %5 to i32
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  call void @writer_acquire(i32 noundef %7)
  %8 = load i32, ptr %3, align 4
  call void @writer_cs(i32 noundef %8)
  %9 = load i32, ptr %3, align 4
  call void @writer_release(i32 noundef %9)
  ret ptr null
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @reader(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = ptrtoint ptr %4 to i64
  %6 = trunc i64 %5 to i32
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  call void @reader_acquire(i32 noundef %7)
  %8 = load i32, ptr %3, align 4
  call void @reader_cs(i32 noundef %8)
  %9 = load i32, ptr %3, align 4
  call void @reader_release(i32 noundef %9)
  ret ptr null
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @fini() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = load i32, ptr @g_cs_x, align 4
  store i32 %3, ptr %1, align 4
  %4 = load i32, ptr @g_cs_y, align 4
  store i32 %4, ptr %2, align 4
  %5 = load i32, ptr %1, align 4
  %6 = load i32, ptr %2, align 4
  %7 = icmp eq i32 %5, %6
  %8 = xor i1 %7, true
  %9 = zext i1 %8 to i32
  %10 = sext i32 %9 to i64
  %11 = icmp ne i64 %10, 0
  br i1 %11, label %12, label %14

12:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.fini, ptr noundef @.str, i32 noundef 80, ptr noundef @.str.3) #3
  unreachable

13:                                               ; No predecessors!
  br label %15

14:                                               ; preds = %0
  br label %15

15:                                               ; preds = %14, %13
  %16 = load i32, ptr %1, align 4
  %17 = icmp eq i32 %16, 2
  %18 = xor i1 %17, true
  %19 = zext i1 %18 to i32
  %20 = sext i32 %19 to i64
  %21 = icmp ne i64 %20, 0
  br i1 %21, label %22, label %24

22:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.fini, ptr noundef @.str, i32 noundef 81, ptr noundef @.str.4) #3
  unreachable

23:                                               ; No predecessors!
  br label %25

24:                                               ; preds = %15
  br label %25

25:                                               ; preds = %24, %23
  br label %26

26:                                               ; preds = %25
  br label %27

27:                                               ; preds = %26
  %28 = load i32, ptr %1, align 4
  br label %29

29:                                               ; preds = %27
  %30 = load i32, ptr %2, align 4
  br label %31

31:                                               ; preds = %29
  br label %32

32:                                               ; preds = %31
  br label %33

33:                                               ; preds = %32
  br label %34

34:                                               ; preds = %33
  br label %35

35:                                               ; preds = %34
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @writer_cs(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i64, align 8
  store i32 %0, ptr %2, align 4
  store i64 0, ptr %3, align 8
  call void @verification_loop_bound(i32 noundef 3)
  store i64 0, ptr %3, align 8
  br label %4

4:                                                ; preds = %9, %1
  %5 = load i64, ptr %3, align 8
  %6 = icmp ult i64 %5, 2
  br i1 %6, label %7, label %12

7:                                                ; preds = %4
  %8 = load i32, ptr %2, align 4
  call void @rec_seqlock_acquire(ptr noundef @lock, i32 noundef %8)
  br label %9

9:                                                ; preds = %7
  %10 = load i64, ptr %3, align 8
  %11 = add i64 %10, 1
  store i64 %11, ptr %3, align 8
  br label %4, !llvm.loop !9

12:                                               ; preds = %4
  %13 = load i32, ptr @g_cs_x, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr @g_cs_x, align 4
  %15 = load i32, ptr @g_cs_y, align 4
  %16 = add i32 %15, 1
  store i32 %16, ptr @g_cs_y, align 4
  call void @verification_loop_bound(i32 noundef 3)
  store i64 0, ptr %3, align 8
  br label %17

17:                                               ; preds = %21, %12
  %18 = load i64, ptr %3, align 8
  %19 = icmp ult i64 %18, 2
  br i1 %19, label %20, label %24

20:                                               ; preds = %17
  call void @rec_seqlock_release(ptr noundef @lock)
  br label %21

21:                                               ; preds = %20
  %22 = load i64, ptr %3, align 8
  %23 = add i64 %22, 1
  store i64 %23, ptr %3, align 8
  br label %17, !llvm.loop !10

24:                                               ; preds = %17
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @rec_seqlock_acquire(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load i32, ptr %4, align 4
  %6 = icmp ne i32 %5, -1
  br i1 %6, label %7, label %8

7:                                                ; preds = %2
  br label %8

8:                                                ; preds = %7, %2
  %9 = phi i1 [ false, %2 ], [ true, %7 ]
  %10 = xor i1 %9, true
  %11 = zext i1 %10 to i32
  %12 = sext i32 %11 to i64
  %13 = icmp ne i64 %12, 0
  br i1 %13, label %14, label %16

14:                                               ; preds = %8
  call void @__assert_rtn(ptr noundef @__func__.rec_seqlock_acquire, ptr noundef @.str.6, i32 noundef 33, ptr noundef @.str.7) #3
  unreachable

15:                                               ; No predecessors!
  br label %17

16:                                               ; preds = %8
  br label %17

17:                                               ; preds = %16, %15
  %18 = load ptr, ptr %3, align 8
  %19 = getelementptr inbounds %struct.rec_seqlock_s, ptr %18, i32 0, i32 1
  %20 = call i32 @vatomic32_read_rlx(ptr noundef %19)
  %21 = load i32, ptr %4, align 4
  %22 = icmp eq i32 %20, %21
  br i1 %22, label %23, label %28

23:                                               ; preds = %17
  %24 = load ptr, ptr %3, align 8
  %25 = getelementptr inbounds %struct.rec_seqlock_s, ptr %24, i32 0, i32 2
  %26 = load i32, ptr %25, align 8
  %27 = add i32 %26, 1
  store i32 %27, ptr %25, align 8
  br label %34

28:                                               ; preds = %17
  %29 = load ptr, ptr %3, align 8
  %30 = getelementptr inbounds %struct.rec_seqlock_s, ptr %29, i32 0, i32 0
  call void @seqlock_acquire(ptr noundef %30)
  %31 = load ptr, ptr %3, align 8
  %32 = getelementptr inbounds %struct.rec_seqlock_s, ptr %31, i32 0, i32 1
  %33 = load i32, ptr %4, align 4
  call void @vatomic32_write_rlx(ptr noundef %32, i32 noundef %33)
  br label %34

34:                                               ; preds = %28, %23
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @rec_seqlock_release(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct.rec_seqlock_s, ptr %3, i32 0, i32 2
  %5 = load i32, ptr %4, align 8
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %12

7:                                                ; preds = %1
  %8 = load ptr, ptr %2, align 8
  %9 = getelementptr inbounds %struct.rec_seqlock_s, ptr %8, i32 0, i32 1
  call void @vatomic32_write_rlx(ptr noundef %9, i32 noundef -1)
  %10 = load ptr, ptr %2, align 8
  %11 = getelementptr inbounds %struct.rec_seqlock_s, ptr %10, i32 0, i32 0
  call void @seqlock_release(ptr noundef %11)
  br label %17

12:                                               ; preds = %1
  %13 = load ptr, ptr %2, align 8
  %14 = getelementptr inbounds %struct.rec_seqlock_s, ptr %13, i32 0, i32 2
  %15 = load i32, ptr %14, align 8
  %16 = add i32 %15, -1
  store i32 %16, ptr %14, align 8
  br label %17

17:                                               ; preds = %12, %7
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @reader_cs(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  store i32 0, ptr %3, align 4
  store i32 0, ptr %4, align 4
  store i32 0, ptr %5, align 4
  br label %6

6:                                                ; preds = %10, %1
  %7 = call i32 @rec_seqlock_rbegin(ptr noundef @lock)
  store i32 %7, ptr %5, align 4
  %8 = load i32, ptr @g_cs_x, align 4
  store i32 %8, ptr %3, align 4
  %9 = load i32, ptr @g_cs_y, align 4
  store i32 %9, ptr %4, align 4
  br label %10

10:                                               ; preds = %6
  %11 = load i32, ptr %5, align 4
  %12 = call zeroext i1 @rec_seqlock_rend(ptr noundef @lock, i32 noundef %11)
  %13 = xor i1 %12, true
  br i1 %13, label %6, label %14, !llvm.loop !11

14:                                               ; preds = %10
  %15 = load i32, ptr %3, align 4
  %16 = load i32, ptr %4, align 4
  %17 = icmp eq i32 %15, %16
  %18 = xor i1 %17, true
  %19 = zext i1 %18 to i32
  %20 = sext i32 %19 to i64
  %21 = icmp ne i64 %20, 0
  br i1 %21, label %22, label %24

22:                                               ; preds = %14
  call void @__assert_rtn(ptr noundef @__func__.reader_cs, ptr noundef @.str, i32 noundef 64, ptr noundef @.str.1) #3
  unreachable

23:                                               ; No predecessors!
  br label %25

24:                                               ; preds = %14
  br label %25

25:                                               ; preds = %24, %23
  %26 = load i32, ptr %5, align 4
  %27 = urem i32 %26, 2
  %28 = icmp eq i32 %27, 0
  %29 = xor i1 %28, true
  %30 = zext i1 %29 to i32
  %31 = sext i32 %30 to i64
  %32 = icmp ne i64 %31, 0
  br i1 %32, label %33, label %35

33:                                               ; preds = %25
  call void @__assert_rtn(ptr noundef @__func__.reader_cs, ptr noundef @.str, i32 noundef 65, ptr noundef @.str.2) #3
  unreachable

34:                                               ; No predecessors!
  br label %36

35:                                               ; preds = %25
  br label %36

36:                                               ; preds = %35, %34
  br label %37

37:                                               ; preds = %36
  br label %38

38:                                               ; preds = %37
  %39 = load i32, ptr %2, align 4
  br label %40

40:                                               ; preds = %38
  %41 = load i32, ptr %3, align 4
  br label %42

42:                                               ; preds = %40
  %43 = load i32, ptr %4, align 4
  br label %44

44:                                               ; preds = %42
  br label %45

45:                                               ; preds = %44
  br label %46

46:                                               ; preds = %45
  br label %47

47:                                               ; preds = %46
  br label %48

48:                                               ; preds = %47
  br label %49

49:                                               ; preds = %48
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @rec_seqlock_rbegin(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct.rec_seqlock_s, ptr %3, i32 0, i32 0
  %5 = call i32 @seqlock_rbegin(ptr noundef %4)
  ret i32 %5
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @rec_seqlock_rend(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8
  %6 = getelementptr inbounds %struct.rec_seqlock_s, ptr %5, i32 0, i32 0
  %7 = load i32, ptr %4, align 4
  %8 = call zeroext i1 @seqlock_rend(ptr noundef %6, i32 noundef %7)
  ret i1 %8
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @rec_seqlock_init(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct.rec_seqlock_s, ptr %3, i32 0, i32 0
  call void @seqlock_init(ptr noundef %4)
  %5 = load ptr, ptr %2, align 8
  %6 = getelementptr inbounds %struct.rec_seqlock_s, ptr %5, i32 0, i32 1
  call void @vatomic32_init(ptr noundef %6, i32 noundef -1)
  %7 = load ptr, ptr %2, align 8
  %8 = getelementptr inbounds %struct.rec_seqlock_s, ptr %7, i32 0, i32 2
  store i32 0, ptr %8, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_read_rlx(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomic32_s, ptr %4, i32 0, i32 0
  %6 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,*Q,~{memory}"(ptr elementtype(i32) %5) #4, !srcloc !12
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @seqlock_acquire(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  store i32 0, ptr %3, align 4
  store i32 0, ptr %4, align 4
  br label %5

5:                                                ; preds = %19, %1
  %6 = load ptr, ptr %2, align 8
  %7 = call i32 @_seqlock_await_even(ptr noundef %6)
  store i32 %7, ptr %3, align 4
  %8 = load ptr, ptr %2, align 8
  %9 = getelementptr inbounds %struct.seqlock_s, ptr %8, i32 0, i32 0
  %10 = load i32, ptr %3, align 4
  %11 = load i32, ptr %3, align 4
  %12 = add i32 %11, 1
  %13 = call i32 @vatomic32_cmpxchg_acq(ptr noundef %9, i32 noundef %10, i32 noundef %12)
  store i32 %13, ptr %4, align 4
  %14 = load i32, ptr %4, align 4
  %15 = load i32, ptr %3, align 4
  %16 = icmp eq i32 %14, %15
  br i1 %16, label %17, label %18

17:                                               ; preds = %5
  br label %20

18:                                               ; preds = %5
  br label %19

19:                                               ; preds = %18
  br i1 true, label %5, label %20

20:                                               ; preds = %19, %17
  call void @vatomic_fence_rel()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomic32_write_rlx(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load i32, ptr %4, align 4
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct.vatomic32_s, ptr %6, i32 0, i32 0
  call void asm sideeffect "str ${0:w}, $1", "r,*Q,~{memory}"(i32 %5, ptr elementtype(i32) %7) #4, !srcloc !13
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @_seqlock_await_even(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.seqlock_s, ptr %4, i32 0, i32 0
  %6 = call i32 @vatomic32_read_acq(ptr noundef %5)
  store i32 %6, ptr %3, align 4
  br label %7

7:                                                ; preds = %11, %1
  %8 = load i32, ptr %3, align 4
  %9 = and i32 %8, 1
  %10 = icmp eq i32 %9, 1
  br i1 %10, label %11, label %16

11:                                               ; preds = %7
  %12 = load ptr, ptr %2, align 8
  %13 = getelementptr inbounds %struct.seqlock_s, ptr %12, i32 0, i32 0
  %14 = load i32, ptr %3, align 4
  %15 = call i32 @vatomic32_await_neq_acq(ptr noundef %13, i32 noundef %14)
  store i32 %15, ptr %3, align 4
  br label %7, !llvm.loop !14

16:                                               ; preds = %7
  %17 = load i32, ptr %3, align 4
  %18 = and i32 %17, 1
  %19 = icmp eq i32 %18, 0
  %20 = xor i1 %19, true
  %21 = zext i1 %20 to i32
  %22 = sext i32 %21 to i64
  %23 = icmp ne i64 %22, 0
  br i1 %23, label %24, label %26

24:                                               ; preds = %16
  call void @__assert_rtn(ptr noundef @__func__._seqlock_await_even, ptr noundef @.str.8, i32 noundef 54, ptr noundef @.str.9) #3
  unreachable

25:                                               ; No predecessors!
  br label %27

26:                                               ; preds = %16
  br label %27

27:                                               ; preds = %26, %25
  %28 = load i32, ptr %3, align 4
  ret i32 %28
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_cmpxchg_acq(ptr noundef %0, i32 noundef %1, i32 noundef %2) #0 {
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
  %13 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldaxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,*Q,~{memory},~{cc}"(i32 %9, i32 %10, ptr elementtype(i32) %12) #4, !srcloc !15
  %14 = extractvalue { i32, i32 } %13, 0
  %15 = extractvalue { i32, i32 } %13, 1
  store i32 %14, ptr %7, align 4
  store i32 %15, ptr %8, align 4
  %16 = load i32, ptr %7, align 4
  ret i32 %16
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomic_fence_rel() #0 {
  call void asm sideeffect "dmb ish", "~{memory}"() #4, !srcloc !16
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_read_acq(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomic32_s, ptr %4, i32 0, i32 0
  %6 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,*Q,~{memory}"(ptr elementtype(i32) %5) #4, !srcloc !17
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_await_neq_acq(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %6 = load i32, ptr %4, align 4
  %7 = load ptr, ptr %3, align 8
  %8 = getelementptr inbounds %struct.vatomic32_s, ptr %7, i32 0, i32 0
  %9 = call i32 asm sideeffect "1:\0Aldar ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.eq 1b\0A", "=&r,r,*Q,~{memory},~{cc}"(i32 %6, ptr elementtype(i32) %8) #4, !srcloc !18
  store i32 %9, ptr %5, align 4
  %10 = load i32, ptr %5, align 4
  ret i32 %10
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @seqlock_release(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.seqlock_s, ptr %4, i32 0, i32 0
  %6 = call i32 @vatomic32_read_rlx(ptr noundef %5)
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  %8 = zext i32 %7 to i64
  %9 = and i64 %8, 1
  %10 = icmp eq i64 %9, 1
  %11 = xor i1 %10, true
  %12 = zext i1 %11 to i32
  %13 = sext i32 %12 to i64
  %14 = icmp ne i64 %13, 0
  br i1 %14, label %15, label %17

15:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.seqlock_release, ptr noundef @.str.8, i32 noundef 118, ptr noundef @.str.10) #3
  unreachable

16:                                               ; No predecessors!
  br label %18

17:                                               ; preds = %1
  br label %18

18:                                               ; preds = %17, %16
  %19 = load ptr, ptr %2, align 8
  %20 = getelementptr inbounds %struct.seqlock_s, ptr %19, i32 0, i32 0
  %21 = load i32, ptr %3, align 4
  %22 = add i32 %21, 1
  call void @vatomic32_write_rel(ptr noundef %20, i32 noundef %22)
  ret void
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

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @seqlock_rbegin(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = call i32 @_seqlock_await_even(ptr noundef %3)
  ret i32 %4
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @seqlock_rend(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load i32, ptr %4, align 4
  %6 = and i32 %5, 1
  %7 = icmp eq i32 %6, 0
  %8 = xor i1 %7, true
  %9 = zext i1 %8 to i32
  %10 = sext i32 %9 to i64
  %11 = icmp ne i64 %10, 0
  br i1 %11, label %12, label %14

12:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.seqlock_rend, ptr noundef @.str.8, i32 noundef 156, ptr noundef @.str.11) #3
  unreachable

13:                                               ; No predecessors!
  br label %15

14:                                               ; preds = %2
  br label %15

15:                                               ; preds = %14, %13
  call void @vatomic_fence_acq()
  %16 = load ptr, ptr %3, align 8
  %17 = getelementptr inbounds %struct.seqlock_s, ptr %16, i32 0, i32 0
  %18 = call i32 @vatomic32_read_rlx(ptr noundef %17)
  %19 = load i32, ptr %4, align 4
  %20 = icmp eq i32 %18, %19
  ret i1 %20
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomic_fence_acq() #0 {
  call void asm sideeffect "dmb ishld", "~{memory}"() #4, !srcloc !20
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @seqlock_init(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct.seqlock_s, ptr %3, i32 0, i32 0
  call void @vatomic32_write_rlx(ptr noundef %4, i32 noundef 0)
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
  call void asm sideeffect "stlr ${0:w}, $1", "r,*Q,~{memory}"(i32 %5, ptr elementtype(i32) %7) #4, !srcloc !21
  ret void
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
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
!9 = distinct !{!9, !6}
!10 = distinct !{!10, !6}
!11 = distinct !{!11, !6}
!12 = !{i64 921493}
!13 = !{i64 925877}
!14 = distinct !{!14, !6}
!15 = !{i64 986392, i64 986426, i64 986441, i64 986474, i64 986508, i64 986528, i64 986570, i64 986599}
!16 = !{i64 919954}
!17 = !{i64 920991}
!18 = !{i64 937185, i64 937201, i64 937232, i64 937265}
!19 = !{i64 925407}
!20 = !{i64 919796}
!21 = !{i64 924937}
