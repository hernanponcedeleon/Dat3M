; ModuleID = 'test/thread/once.c'
source_filename = "test/thread/once.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.vatomic32_s = type { i32 }
%struct.run_info_t = type { ptr, i64, i8, ptr }

@g_once = global %struct.vatomic32_s zeroinitializer, align 4
@g_winner = global i64 0, align 8
@__func__.__once_verification_cb = private unnamed_addr constant [23 x i8] c"__once_verification_cb\00", align 1
@.str = private unnamed_addr constant [7 x i8] c"once.c\00", align 1
@.str.1 = private unnamed_addr constant [14 x i8] c"g_winner != 0\00", align 1
@__func__.run = private unnamed_addr constant [4 x i8] c"run\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"tid != 0\00", align 1
@.str.3 = private unnamed_addr constant [30 x i8] c"tid == (vsize_t)(vuintptr_t)r\00", align 1
@.str.4 = private unnamed_addr constant [16 x i8] c"g_winner == tid\00", align 1
@.str.5 = private unnamed_addr constant [16 x i8] c"g_winner != tid\00", align 1
@sig = internal global %struct.vatomic32_s zeroinitializer, align 4

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @__once_verification_cb(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = ptrtoint ptr %3 to i64
  store i64 %4, ptr @g_winner, align 8
  %5 = load i64, ptr @g_winner, align 8
  %6 = icmp ne i64 %5, 0
  %7 = xor i1 %6, true
  %8 = zext i1 %7 to i32
  %9 = sext i32 %8 to i64
  %10 = icmp ne i64 %9, 0
  br i1 %10, label %11, label %13

11:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.__once_verification_cb, ptr noundef @.str, i32 noundef 16, ptr noundef @.str.1) #4
  unreachable

12:                                               ; No predecessors!
  br label %14

13:                                               ; preds = %1
  br label %14

14:                                               ; preds = %13, %12
  %15 = load ptr, ptr %2, align 8
  ret ptr %15
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8
  %6 = ptrtoint ptr %5 to i64
  %7 = add i64 %6, 1
  store i64 %7, ptr %3, align 8
  %8 = load i64, ptr %3, align 8
  %9 = icmp ne i64 %8, 0
  %10 = xor i1 %9, true
  %11 = zext i1 %10 to i32
  %12 = sext i32 %11 to i64
  %13 = icmp ne i64 %12, 0
  br i1 %13, label %14, label %16

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.run, ptr noundef @.str, i32 noundef 24, ptr noundef @.str.2) #4
  unreachable

15:                                               ; No predecessors!
  br label %17

16:                                               ; preds = %1
  br label %17

17:                                               ; preds = %16, %15
  %18 = load i64, ptr %3, align 8
  %19 = inttoptr i64 %18 to ptr
  %20 = call ptr @vonce_call(ptr noundef @g_once, ptr noundef @__once_verification_cb, ptr noundef %19)
  store ptr %20, ptr %4, align 8
  %21 = load ptr, ptr %4, align 8
  %22 = icmp ne ptr %21, null
  br i1 %22, label %23, label %47

23:                                               ; preds = %17
  %24 = load i64, ptr %3, align 8
  %25 = load ptr, ptr %4, align 8
  %26 = ptrtoint ptr %25 to i64
  %27 = icmp eq i64 %24, %26
  %28 = xor i1 %27, true
  %29 = zext i1 %28 to i32
  %30 = sext i32 %29 to i64
  %31 = icmp ne i64 %30, 0
  br i1 %31, label %32, label %34

32:                                               ; preds = %23
  call void @__assert_rtn(ptr noundef @__func__.run, ptr noundef @.str, i32 noundef 28, ptr noundef @.str.3) #4
  unreachable

33:                                               ; No predecessors!
  br label %35

34:                                               ; preds = %23
  br label %35

35:                                               ; preds = %34, %33
  %36 = load i64, ptr @g_winner, align 8
  %37 = load i64, ptr %3, align 8
  %38 = icmp eq i64 %36, %37
  %39 = xor i1 %38, true
  %40 = zext i1 %39 to i32
  %41 = sext i32 %40 to i64
  %42 = icmp ne i64 %41, 0
  br i1 %42, label %43, label %45

43:                                               ; preds = %35
  call void @__assert_rtn(ptr noundef @__func__.run, ptr noundef @.str, i32 noundef 29, ptr noundef @.str.4) #4
  unreachable

44:                                               ; No predecessors!
  br label %46

45:                                               ; preds = %35
  br label %46

46:                                               ; preds = %45, %44
  br label %59

47:                                               ; preds = %17
  %48 = load i64, ptr @g_winner, align 8
  %49 = load i64, ptr %3, align 8
  %50 = icmp ne i64 %48, %49
  %51 = xor i1 %50, true
  %52 = zext i1 %51 to i32
  %53 = sext i32 %52 to i64
  %54 = icmp ne i64 %53, 0
  br i1 %54, label %55, label %57

55:                                               ; preds = %47
  call void @__assert_rtn(ptr noundef @__func__.run, ptr noundef @.str, i32 noundef 31, ptr noundef @.str.5) #4
  unreachable

56:                                               ; No predecessors!
  br label %58

57:                                               ; preds = %47
  br label %58

58:                                               ; preds = %57, %56
  br label %59

59:                                               ; preds = %58, %46
  ret ptr null
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @vonce_call(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store ptr %2, ptr %7, align 8
  store ptr null, ptr %8, align 8
  store i32 0, ptr %9, align 4
  %10 = load ptr, ptr %5, align 8
  %11 = call i32 @vatomic32_read_acq(ptr noundef %10)
  %12 = icmp eq i32 %11, 2
  br i1 %12, label %13, label %14

13:                                               ; preds = %3
  store ptr null, ptr %4, align 8
  br label %35

14:                                               ; preds = %3
  %15 = load ptr, ptr %5, align 8
  %16 = call i32 @vatomic32_cmpxchg_acq(ptr noundef %15, i32 noundef 0, i32 noundef 1)
  store i32 %16, ptr %9, align 4
  %17 = load i32, ptr %9, align 4
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %19, label %25

19:                                               ; preds = %14
  %20 = load ptr, ptr %7, align 8
  %21 = call ptr @__once_verification_cb(ptr noundef %20)
  store ptr %21, ptr %8, align 8
  %22 = load ptr, ptr %5, align 8
  call void @vatomic32_write_rel(ptr noundef %22, i32 noundef 2)
  %23 = load ptr, ptr %5, align 8
  call void @vfutex_wake(ptr noundef %23, i32 noundef 2147483647)
  %24 = load ptr, ptr %8, align 8
  store ptr %24, ptr %4, align 8
  br label %35

25:                                               ; preds = %14
  br label %26

26:                                               ; preds = %29, %25
  %27 = load i32, ptr %9, align 4
  %28 = icmp eq i32 %27, 1
  br i1 %28, label %29, label %33

29:                                               ; preds = %26
  %30 = load ptr, ptr %5, align 8
  call void @vfutex_wait(ptr noundef %30, i32 noundef 1)
  %31 = load ptr, ptr %5, align 8
  %32 = call i32 @vatomic32_read_acq(ptr noundef %31)
  store i32 %32, ptr %9, align 4
  br label %26, !llvm.loop !6

33:                                               ; preds = %26
  %34 = load ptr, ptr %8, align 8
  store ptr %34, ptr %4, align 8
  br label %35

35:                                               ; preds = %33, %19, %13
  %36 = load ptr, ptr %4, align 8
  ret ptr %36
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @launch_threads(i64 noundef 4, ptr noundef @run)
  ret i32 0
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
define internal i32 @vatomic32_read_acq(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomic32_s, ptr %4, i32 0, i32 0
  %6 = call i32 asm sideeffect "ldr $0, $1 \0Admb ish\0A", "=&r,*Q,~{memory}"(ptr elementtype(i32) %5) #6, !srcloc !8
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  ret i32 %7
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
  %13 = call { i32, i32 } asm sideeffect " \0A1:\0Aldrex $0, $4\0Acmp $0, $3\0Abne 2f\0Astrex $1, $2, $4\0Acmp $1, #0 \0Abne 1b\0A2:\0Admb ish \0A", "=&r,=&r,r,r,*Q,~{memory},~{cc}"(i32 %9, i32 %10, ptr elementtype(i32) %12) #6, !srcloc !9
  %14 = extractvalue { i32, i32 } %13, 0
  %15 = extractvalue { i32, i32 } %13, 1
  store i32 %14, ptr %7, align 4
  store i32 %15, ptr %8, align 4
  %16 = load i32, ptr %7, align 4
  ret i32 %16
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
  call void asm sideeffect "dmb ish \0Astr $0, $1\0A \0A", "r,*Q,~{memory}"(i32 %5, ptr elementtype(i32) %7) #6, !srcloc !10
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vfutex_wake(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  call void @vatomic32_inc_rel(ptr noundef @sig)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vfutex_wait(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %6 = call i32 @vatomic32_read_acq(ptr noundef @sig)
  store i32 %6, ptr %5, align 4
  %7 = load ptr, ptr %3, align 8
  %8 = call i32 @vatomic32_read_rlx(ptr noundef %7)
  %9 = load i32, ptr %4, align 4
  %10 = icmp ne i32 %8, %9
  br i1 %10, label %11, label %12

11:                                               ; preds = %2
  br label %15

12:                                               ; preds = %2
  %13 = load i32, ptr %5, align 4
  %14 = call i32 @vatomic32_await_neq_rlx(ptr noundef @sig, i32 noundef %13)
  br label %15

15:                                               ; preds = %12, %11
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomic32_inc_rel(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = call i32 @vatomic32_get_inc_rel(ptr noundef %3)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_get_inc_rel(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = call i32 @vatomic32_get_add_rel(ptr noundef %3, i32 noundef 1)
  ret i32 %4
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_get_add_rel(ptr noundef %0, i32 noundef %1) #0 {
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
  %11 = call { i32, i32, i32 } asm sideeffect "dmb ish \0A1:\0Aldrex $0, $4\0Aadd $1, $0, $3\0Astrex $2, $1, $4\0Acmp $2, #0\0Abne 1b\0A \0A", "=&r,=&r,=&r,r,*Q,~{memory},~{cc}"(i32 %8, ptr elementtype(i32) %10) #6, !srcloc !11
  %12 = extractvalue { i32, i32, i32 } %11, 0
  %13 = extractvalue { i32, i32, i32 } %11, 1
  %14 = extractvalue { i32, i32, i32 } %11, 2
  store i32 %12, ptr %5, align 4
  store i32 %13, ptr %6, align 4
  store i32 %14, ptr %7, align 4
  %15 = load i32, ptr %5, align 4
  ret i32 %15
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
define internal i32 @vatomic32_await_neq_rlx(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  store i32 0, ptr %5, align 4
  call void @verification_loop_begin()
  br label %6

6:                                                ; preds = %20, %2
  call void @verification_spin_start()
  %7 = load ptr, ptr %3, align 8
  %8 = call i32 @vatomic32_read_rlx(ptr noundef %7)
  store i32 %8, ptr %5, align 4
  %9 = load i32, ptr %5, align 4
  %10 = load i32, ptr %4, align 4
  %11 = icmp eq i32 %9, %10
  br i1 %11, label %12, label %13

12:                                               ; preds = %6
  br label %14

13:                                               ; preds = %6
  call void @verification_spin_end(i32 noundef 1)
  br label %14

14:                                               ; preds = %13, %12
  %15 = phi i32 [ 1, %12 ], [ 0, %13 ]
  %16 = icmp ne i32 %15, 0
  br i1 %16, label %17, label %21

17:                                               ; preds = %14
  br label %18

18:                                               ; preds = %17
  br label %19

19:                                               ; preds = %18
  br label %20

20:                                               ; preds = %19
  call void @verification_spin_end(i32 noundef 0)
  br label %6, !llvm.loop !13

21:                                               ; preds = %14
  %22 = load i32, ptr %5, align 4
  ret i32 %22
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
  br label %11, !llvm.loop !14

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
  br label %6, !llvm.loop !15

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
!8 = !{i64 1182160, i64 1182189}
!9 = !{i64 1199948, i64 1199963, i64 1199978, i64 1200010, i64 1200043, i64 1200062, i64 1200102, i64 1200130, i64 1200149, i64 1200164}
!10 = !{i64 1186507, i64 1186529, i64 1186556}
!11 = !{i64 1218784, i64 1218806, i64 1218821, i64 1218853, i64 1218892, i64 1218932, i64 1218959, i64 1218978}
!12 = !{i64 1182653, i64 1182682}
!13 = distinct !{!13, !7}
!14 = distinct !{!14, !7}
!15 = distinct !{!15, !7}
