; ModuleID = 'src/p64_rwlock.c'
source_filename = "src/p64_rwlock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@x = global i32 0, align 4
@y = global i32 0, align 4
@__func__.p64_rwlock_acquire_rd = private unnamed_addr constant [22 x i8] c"p64_rwlock_acquire_rd\00", align 1
@.str = private unnamed_addr constant [13 x i8] c"p64_rwlock.c\00", align 1
@.str.1 = private unnamed_addr constant [25 x i8] c"(l & RWLOCK_WRITER) == 0\00", align 1
@__func__.p64_rwlock_acquire_wr = private unnamed_addr constant [22 x i8] c"p64_rwlock_acquire_wr\00", align 1
@.str.2 = private unnamed_addr constant [19 x i8] c"l == RWLOCK_WRITER\00", align 1
@lock = global i32 0, align 4
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str.3 = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1
@__func__.wait_for_no = private unnamed_addr constant [12 x i8] c"wait_for_no\00", align 1
@.str.4 = private unnamed_addr constant [16 x i8] c"(l & mask) == 0\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @p64_rwlock_init(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  store i32 0, ptr %3, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @p64_rwlock_acquire_rd(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  br label %6

6:                                                ; preds = %30, %1
  %7 = load ptr, ptr %2, align 8
  %8 = call i32 @wait_for_no(ptr noundef %7, i32 noundef -2147483648, i32 noundef 0)
  store i32 %8, ptr %3, align 4
  %9 = load i32, ptr %3, align 4
  %10 = and i32 %9, -2147483648
  %11 = icmp eq i32 %10, 0
  %12 = xor i1 %11, true
  %13 = zext i1 %12 to i32
  %14 = sext i32 %13 to i64
  %15 = icmp ne i64 %14, 0
  br i1 %15, label %16, label %18

16:                                               ; preds = %6
  call void @__assert_rtn(ptr noundef @__func__.p64_rwlock_acquire_rd, ptr noundef @.str, i32 noundef 60, ptr noundef @.str.1) #5
  unreachable

17:                                               ; No predecessors!
  br label %19

18:                                               ; preds = %6
  br label %19

19:                                               ; preds = %18, %17
  br label %20

20:                                               ; preds = %19
  %21 = load ptr, ptr %2, align 8
  %22 = load i32, ptr %3, align 4
  %23 = add i32 %22, 1
  store i32 %23, ptr %4, align 4
  %24 = load i32, ptr %3, align 4
  %25 = load i32, ptr %4, align 4
  %26 = cmpxchg weak ptr %21, i32 %24, i32 %25 acquire acquire, align 4
  %27 = extractvalue { i32, i1 } %26, 0
  %28 = extractvalue { i32, i1 } %26, 1
  br i1 %28, label %30, label %29

29:                                               ; preds = %20
  store i32 %27, ptr %3, align 4
  br label %30

30:                                               ; preds = %29, %20
  %31 = zext i1 %28 to i8
  store i8 %31, ptr %5, align 1
  %32 = load i8, ptr %5, align 1
  %33 = trunc i8 %32 to i1
  %34 = xor i1 %33, true
  br i1 %34, label %6, label %35, !llvm.loop !6

35:                                               ; preds = %30
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @wait_for_no(ptr noundef %0, i32 noundef %1, i32 noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store i32 %1, ptr %5, align 4
  store i32 %2, ptr %6, align 4
  %9 = load ptr, ptr %4, align 8
  %10 = load i32, ptr %6, align 4
  switch i32 %10, label %11 [
    i32 1, label %13
    i32 2, label %13
    i32 5, label %15
  ]

11:                                               ; preds = %3
  %12 = load atomic i32, ptr %9 monotonic, align 4
  store i32 %12, ptr %8, align 4
  br label %17

13:                                               ; preds = %3, %3
  %14 = load atomic i32, ptr %9 acquire, align 4
  store i32 %14, ptr %8, align 4
  br label %17

15:                                               ; preds = %3
  %16 = load atomic i32, ptr %9 seq_cst, align 4
  store i32 %16, ptr %8, align 4
  br label %17

17:                                               ; preds = %15, %13, %11
  %18 = load i32, ptr %8, align 4
  store i32 %18, ptr %7, align 4
  %19 = load i32, ptr %5, align 4
  %20 = and i32 %18, %19
  %21 = icmp ne i32 %20, 0
  br i1 %21, label %22, label %32

22:                                               ; preds = %17
  br label %23

23:                                               ; preds = %30, %22
  %24 = load ptr, ptr %4, align 8
  %25 = load i32, ptr %6, align 4
  %26 = call i32 @ldx32(ptr noundef %24, i32 noundef %25)
  store i32 %26, ptr %7, align 4
  %27 = load i32, ptr %5, align 4
  %28 = and i32 %26, %27
  %29 = icmp ne i32 %28, 0
  br i1 %29, label %30, label %31

30:                                               ; preds = %23
  call void @wfe()
  br label %23, !llvm.loop !8

31:                                               ; preds = %23
  br label %32

32:                                               ; preds = %31, %17
  %33 = load i32, ptr %7, align 4
  %34 = load i32, ptr %5, align 4
  %35 = and i32 %33, %34
  %36 = icmp eq i32 %35, 0
  %37 = xor i1 %36, true
  %38 = zext i1 %37 to i32
  %39 = sext i32 %38 to i64
  %40 = icmp ne i64 %39, 0
  br i1 %40, label %41, label %43

41:                                               ; preds = %32
  call void @__assert_rtn(ptr noundef @__func__.wait_for_no, ptr noundef @.str, i32 noundef 48, ptr noundef @.str.4) #5
  unreachable

42:                                               ; No predecessors!
  br label %44

43:                                               ; preds = %32
  br label %44

44:                                               ; preds = %43, %42
  %45 = load i32, ptr %7, align 4
  ret i32 %45
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define zeroext i1 @p64_rwlock_try_acquire_rd(ptr noundef %0) #0 {
  %2 = alloca i1, align 1
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i8, align 1
  store ptr %0, ptr %3, align 8
  br label %8

8:                                                ; preds = %27, %1
  %9 = load ptr, ptr %3, align 8
  %10 = load atomic i32, ptr %9 monotonic, align 4
  store i32 %10, ptr %5, align 4
  %11 = load i32, ptr %5, align 4
  store i32 %11, ptr %4, align 4
  %12 = load i32, ptr %4, align 4
  %13 = and i32 %12, -2147483648
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %15, label %16

15:                                               ; preds = %8
  store i1 false, ptr %2, align 1
  br label %33

16:                                               ; preds = %8
  br label %17

17:                                               ; preds = %16
  %18 = load ptr, ptr %3, align 8
  %19 = load i32, ptr %4, align 4
  %20 = add i32 %19, 1
  store i32 %20, ptr %6, align 4
  %21 = load i32, ptr %4, align 4
  %22 = load i32, ptr %6, align 4
  %23 = cmpxchg weak ptr %18, i32 %21, i32 %22 acquire acquire, align 4
  %24 = extractvalue { i32, i1 } %23, 0
  %25 = extractvalue { i32, i1 } %23, 1
  br i1 %25, label %27, label %26

26:                                               ; preds = %17
  store i32 %24, ptr %4, align 4
  br label %27

27:                                               ; preds = %26, %17
  %28 = zext i1 %25 to i8
  store i8 %28, ptr %7, align 1
  %29 = load i8, ptr %7, align 1
  %30 = trunc i8 %29 to i1
  %31 = xor i1 %30, true
  br i1 %31, label %8, label %32, !llvm.loop !9

32:                                               ; preds = %27
  store i1 true, ptr %2, align 1
  br label %33

33:                                               ; preds = %32, %15
  %34 = load i1, ptr %2, align 1
  ret i1 %34
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @p64_rwlock_release_rd(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %6 = load ptr, ptr %2, align 8
  store i32 1, ptr %4, align 4
  %7 = load i32, ptr %4, align 4
  %8 = atomicrmw sub ptr %6, i32 %7 release, align 4
  store i32 %8, ptr %5, align 4
  %9 = load i32, ptr %5, align 4
  store i32 %9, ptr %3, align 4
  %10 = load i32, ptr %3, align 4
  %11 = and i32 %10, 2147483647
  %12 = icmp eq i32 %11, 0
  %13 = xor i1 %12, true
  %14 = xor i1 %13, true
  %15 = zext i1 %14 to i32
  %16 = sext i32 %15 to i64
  %17 = icmp ne i64 %16, 0
  br i1 %17, label %18, label %19

18:                                               ; preds = %1
  br label %19

19:                                               ; preds = %18, %1
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @p64_rwlock_acquire_wr(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  br label %6

6:                                                ; preds = %30, %1
  %7 = load ptr, ptr %2, align 8
  %8 = call i32 @wait_for_no(ptr noundef %7, i32 noundef -2147483648, i32 noundef 0)
  store i32 %8, ptr %3, align 4
  %9 = load i32, ptr %3, align 4
  %10 = and i32 %9, -2147483648
  %11 = icmp eq i32 %10, 0
  %12 = xor i1 %11, true
  %13 = zext i1 %12 to i32
  %14 = sext i32 %13 to i64
  %15 = icmp ne i64 %14, 0
  br i1 %15, label %16, label %18

16:                                               ; preds = %6
  call void @__assert_rtn(ptr noundef @__func__.p64_rwlock_acquire_wr, ptr noundef @.str, i32 noundef 113, ptr noundef @.str.1) #5
  unreachable

17:                                               ; No predecessors!
  br label %19

18:                                               ; preds = %6
  br label %19

19:                                               ; preds = %18, %17
  br label %20

20:                                               ; preds = %19
  %21 = load ptr, ptr %2, align 8
  %22 = load i32, ptr %3, align 4
  %23 = or i32 %22, -2147483648
  store i32 %23, ptr %4, align 4
  %24 = load i32, ptr %3, align 4
  %25 = load i32, ptr %4, align 4
  %26 = cmpxchg weak ptr %21, i32 %24, i32 %25 acquire acquire, align 4
  %27 = extractvalue { i32, i1 } %26, 0
  %28 = extractvalue { i32, i1 } %26, 1
  br i1 %28, label %30, label %29

29:                                               ; preds = %20
  store i32 %27, ptr %3, align 4
  br label %30

30:                                               ; preds = %29, %20
  %31 = zext i1 %28 to i8
  store i8 %31, ptr %5, align 1
  %32 = load i8, ptr %5, align 1
  %33 = trunc i8 %32 to i1
  %34 = xor i1 %33, true
  br i1 %34, label %6, label %35, !llvm.loop !10

35:                                               ; preds = %30
  %36 = load ptr, ptr %2, align 8
  %37 = call i32 @wait_for_no(ptr noundef %36, i32 noundef 2147483647, i32 noundef 2)
  store i32 %37, ptr %3, align 4
  %38 = load i32, ptr %3, align 4
  %39 = icmp eq i32 %38, -2147483648
  %40 = xor i1 %39, true
  %41 = zext i1 %40 to i32
  %42 = sext i32 %41 to i64
  %43 = icmp ne i64 %42, 0
  br i1 %43, label %44, label %46

44:                                               ; preds = %35
  call void @__assert_rtn(ptr noundef @__func__.p64_rwlock_acquire_wr, ptr noundef @.str, i32 noundef 125, ptr noundef @.str.2) #5
  unreachable

45:                                               ; No predecessors!
  br label %47

46:                                               ; preds = %35
  br label %47

47:                                               ; preds = %46, %45
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define zeroext i1 @p64_rwlock_try_acquire_wr(ptr noundef %0) #0 {
  %2 = alloca i1, align 1
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i8, align 1
  store ptr %0, ptr %3, align 8
  %8 = load ptr, ptr %3, align 8
  %9 = load atomic i32, ptr %8 monotonic, align 4
  store i32 %9, ptr %5, align 4
  %10 = load i32, ptr %5, align 4
  store i32 %10, ptr %4, align 4
  %11 = load i32, ptr %4, align 4
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %13, label %26

13:                                               ; preds = %1
  %14 = load ptr, ptr %3, align 8
  store i32 -2147483648, ptr %6, align 4
  %15 = load i32, ptr %4, align 4
  %16 = load i32, ptr %6, align 4
  %17 = cmpxchg ptr %14, i32 %15, i32 %16 acquire acquire, align 4
  %18 = extractvalue { i32, i1 } %17, 0
  %19 = extractvalue { i32, i1 } %17, 1
  br i1 %19, label %21, label %20

20:                                               ; preds = %13
  store i32 %18, ptr %4, align 4
  br label %21

21:                                               ; preds = %20, %13
  %22 = zext i1 %19 to i8
  store i8 %22, ptr %7, align 1
  %23 = load i8, ptr %7, align 1
  %24 = trunc i8 %23 to i1
  br i1 %24, label %25, label %26

25:                                               ; preds = %21
  store i1 true, ptr %2, align 1
  br label %27

26:                                               ; preds = %21, %1
  store i1 false, ptr %2, align 1
  br label %27

27:                                               ; preds = %26, %25
  %28 = load i1, ptr %2, align 1
  ret i1 %28
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @p64_rwlock_release_wr(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = load i32, ptr %4, align 4
  %6 = icmp ne i32 %5, -2147483648
  %7 = xor i1 %6, true
  %8 = xor i1 %7, true
  %9 = zext i1 %8 to i32
  %10 = sext i32 %9 to i64
  %11 = icmp ne i64 %10, 0
  br i1 %11, label %12, label %13

12:                                               ; preds = %1
  br label %16

13:                                               ; preds = %1
  %14 = load ptr, ptr %2, align 8
  store i32 0, ptr %3, align 4
  %15 = load i32, ptr %3, align 4
  store atomic i32 %15, ptr %14 release, align 4
  br label %16

16:                                               ; preds = %13, %12
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  call void @p64_rwlock_acquire_wr(ptr noundef @lock)
  %4 = load i32, ptr @x, align 4
  %5 = add nsw i32 %4, 1
  store i32 %5, ptr @x, align 4
  %6 = load i32, ptr @y, align 4
  %7 = add nsw i32 %6, 1
  store i32 %7, ptr @y, align 4
  call void @p64_rwlock_release_wr(ptr noundef @lock)
  ret ptr null
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @p64_rwlock_init(ptr noundef @lock)
  store i32 0, ptr %3, align 4
  br label %4

4:                                                ; preds = %18, %0
  %5 = load i32, ptr %3, align 4
  %6 = icmp slt i32 %5, 3
  br i1 %6, label %7, label %21

7:                                                ; preds = %4
  %8 = load i32, ptr %3, align 4
  %9 = sext i32 %8 to i64
  %10 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %9
  %11 = load i32, ptr %3, align 4
  %12 = sext i32 %11 to i64
  %13 = inttoptr i64 %12 to ptr
  %14 = call i32 @pthread_create(ptr noundef %10, ptr noundef null, ptr noundef @run, ptr noundef %13)
  %15 = icmp ne i32 %14, 0
  br i1 %15, label %16, label %17

16:                                               ; preds = %7
  call void @exit(i32 noundef 1) #6
  unreachable

17:                                               ; preds = %7
  br label %18

18:                                               ; preds = %17
  %19 = load i32, ptr %3, align 4
  %20 = add nsw i32 %19, 1
  store i32 %20, ptr %3, align 4
  br label %4, !llvm.loop !11

21:                                               ; preds = %4
  store i32 0, ptr %3, align 4
  br label %22

22:                                               ; preds = %34, %21
  %23 = load i32, ptr %3, align 4
  %24 = icmp slt i32 %23, 3
  br i1 %24, label %25, label %37

25:                                               ; preds = %22
  %26 = load i32, ptr %3, align 4
  %27 = sext i32 %26 to i64
  %28 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %27
  %29 = load ptr, ptr %28, align 8
  %30 = call i32 @"\01_pthread_join"(ptr noundef %29, ptr noundef null)
  %31 = icmp ne i32 %30, 0
  br i1 %31, label %32, label %33

32:                                               ; preds = %25
  call void @exit(i32 noundef 1) #6
  unreachable

33:                                               ; preds = %25
  br label %34

34:                                               ; preds = %33
  %35 = load i32, ptr %3, align 4
  %36 = add nsw i32 %35, 1
  store i32 %36, ptr %3, align 4
  br label %22, !llvm.loop !12

37:                                               ; preds = %22
  %38 = load i32, ptr @x, align 4
  %39 = icmp eq i32 %38, 3
  br i1 %39, label %40, label %43

40:                                               ; preds = %37
  %41 = load i32, ptr @y, align 4
  %42 = icmp eq i32 %41, 3
  br label %43

43:                                               ; preds = %40, %37
  %44 = phi i1 [ false, %37 ], [ %42, %40 ]
  %45 = xor i1 %44, true
  %46 = zext i1 %45 to i32
  %47 = sext i32 %46 to i64
  %48 = icmp ne i64 %47, 0
  br i1 %48, label %49, label %51

49:                                               ; preds = %43
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 194, ptr noundef @.str.3) #5
  unreachable

50:                                               ; No predecessors!
  br label %52

51:                                               ; preds = %43
  br label %52

52:                                               ; preds = %51, %50
  ret i32 0
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noreturn
declare void @exit(i32 noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

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
  %10 = call i32 asm sideeffect "ldaxr ${0:w}, [$1]", "=&r,r,~{memory}"(ptr %9) #7, !srcloc !13
  store i32 %10, ptr %5, align 4
  br label %19

11:                                               ; preds = %2
  %12 = load i32, ptr %4, align 4
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %14, label %17

14:                                               ; preds = %11
  %15 = load ptr, ptr %3, align 8
  %16 = call i32 asm sideeffect "ldxr ${0:w}, [$1]", "=&r,r,~{memory}"(ptr %15) #7, !srcloc !14
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
  call void asm sideeffect "wfe", "~{memory}"() #7, !srcloc !15
  ret void
}

; Function Attrs: cold noreturn nounwind
declare void @abort() #4

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
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
!13 = !{i64 1114382}
!14 = !{i64 1114552}
!15 = !{i64 1085651}
