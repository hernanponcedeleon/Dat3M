; ModuleID = 'tests/anderson.c'
source_filename = "tests/anderson.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_spinlock_anderson = type { ptr, i32, i32, i32, [44 x i8], i32 }
%struct.ck_spinlock_anderson_thread = type { i32, i32 }

@x = global i32 0, align 4
@y = global i32 0, align 4
@lock = global %struct.ck_spinlock_anderson zeroinitializer, align 8
@slots = global ptr null, align 8
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [11 x i8] c"anderson.c\00", align 1
@.str.1 = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @ck_spinlock_anderson_lock(ptr noundef @lock, ptr noundef %3)
  %4 = load i32, ptr @x, align 4
  %5 = add nsw i32 %4, 1
  store i32 %5, ptr @x, align 4
  %6 = load i32, ptr @y, align 4
  %7 = add nsw i32 %6, 1
  store i32 %7, ptr @y, align 4
  %8 = load ptr, ptr %3, align 8
  call void @ck_spinlock_anderson_unlock(ptr noundef @lock, ptr noundef %8)
  ret ptr null
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_anderson_lock(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %8 = load ptr, ptr %3, align 8
  %9 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %8, i32 0, i32 1
  %10 = load i32, ptr %9, align 8
  store i32 %10, ptr %7, align 4
  %11 = load ptr, ptr %3, align 8
  %12 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %11, i32 0, i32 2
  %13 = load i32, ptr %12, align 4
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %15, label %42

15:                                               ; preds = %2
  %16 = load ptr, ptr %3, align 8
  %17 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %16, i32 0, i32 5
  %18 = call i32 @ck_pr_md_load_uint(ptr noundef %17)
  store i32 %18, ptr %5, align 4
  br label %19

19:                                               ; preds = %30, %15
  %20 = load i32, ptr %5, align 4
  %21 = icmp eq i32 %20, -1
  br i1 %21, label %22, label %26

22:                                               ; preds = %19
  %23 = load ptr, ptr %3, align 8
  %24 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %23, i32 0, i32 2
  %25 = load i32, ptr %24, align 4
  store i32 %25, ptr %6, align 4
  br label %29

26:                                               ; preds = %19
  %27 = load i32, ptr %5, align 4
  %28 = add i32 %27, 1
  store i32 %28, ptr %6, align 4
  br label %29

29:                                               ; preds = %26, %22
  br label %30

30:                                               ; preds = %29
  %31 = load ptr, ptr %3, align 8
  %32 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %31, i32 0, i32 5
  %33 = load i32, ptr %5, align 4
  %34 = load i32, ptr %6, align 4
  %35 = call zeroext i1 @ck_pr_cas_uint_value(ptr noundef %32, i32 noundef %33, i32 noundef %34, ptr noundef %5)
  %36 = zext i1 %35 to i32
  %37 = icmp eq i32 %36, 0
  br i1 %37, label %19, label %38, !llvm.loop !6

38:                                               ; preds = %30
  %39 = load i32, ptr %7, align 4
  %40 = load i32, ptr %5, align 4
  %41 = urem i32 %40, %39
  store i32 %41, ptr %5, align 4
  br label %51

42:                                               ; preds = %2
  %43 = load ptr, ptr %3, align 8
  %44 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %43, i32 0, i32 5
  %45 = call i32 @ck_pr_faa_uint(ptr noundef %44, i32 noundef 1)
  store i32 %45, ptr %5, align 4
  %46 = load ptr, ptr %3, align 8
  %47 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %46, i32 0, i32 3
  %48 = load i32, ptr %47, align 8
  %49 = load i32, ptr %5, align 4
  %50 = and i32 %49, %48
  store i32 %50, ptr %5, align 4
  br label %51

51:                                               ; preds = %42, %38
  call void @ck_pr_fence_load()
  br label %52

52:                                               ; preds = %62, %51
  %53 = load ptr, ptr %3, align 8
  %54 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %53, i32 0, i32 0
  %55 = load ptr, ptr %54, align 8
  %56 = load i32, ptr %5, align 4
  %57 = zext i32 %56 to i64
  %58 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %55, i64 %57
  %59 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %58, i32 0, i32 0
  %60 = call i32 @ck_pr_md_load_uint(ptr noundef %59)
  %61 = icmp eq i32 %60, 1
  br i1 %61, label %62, label %63

62:                                               ; preds = %52
  call void @ck_pr_stall()
  br label %52, !llvm.loop !8

63:                                               ; preds = %52
  %64 = load ptr, ptr %3, align 8
  %65 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %64, i32 0, i32 0
  %66 = load ptr, ptr %65, align 8
  %67 = load i32, ptr %5, align 4
  %68 = zext i32 %67 to i64
  %69 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %66, i64 %68
  %70 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %69, i32 0, i32 0
  call void @ck_pr_md_store_uint(ptr noundef %70, i32 noundef 1)
  call void @ck_pr_fence_lock()
  %71 = load ptr, ptr %3, align 8
  %72 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %71, i32 0, i32 0
  %73 = load ptr, ptr %72, align 8
  %74 = load i32, ptr %5, align 4
  %75 = zext i32 %74 to i64
  %76 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %73, i64 %75
  %77 = load ptr, ptr %4, align 8
  store ptr %76, ptr %77, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_anderson_unlock(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  call void @ck_pr_fence_unlock()
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %6, i32 0, i32 2
  %8 = load i32, ptr %7, align 4
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %19

10:                                               ; preds = %2
  %11 = load ptr, ptr %4, align 8
  %12 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %11, i32 0, i32 1
  %13 = load i32, ptr %12, align 4
  %14 = add i32 %13, 1
  %15 = load ptr, ptr %3, align 8
  %16 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %15, i32 0, i32 3
  %17 = load i32, ptr %16, align 8
  %18 = and i32 %14, %17
  store i32 %18, ptr %5, align 4
  br label %28

19:                                               ; preds = %2
  %20 = load ptr, ptr %4, align 8
  %21 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %20, i32 0, i32 1
  %22 = load i32, ptr %21, align 4
  %23 = add i32 %22, 1
  %24 = load ptr, ptr %3, align 8
  %25 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %24, i32 0, i32 1
  %26 = load i32, ptr %25, align 8
  %27 = urem i32 %23, %26
  store i32 %27, ptr %5, align 4
  br label %28

28:                                               ; preds = %19, %10
  %29 = load ptr, ptr %3, align 8
  %30 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %29, i32 0, i32 0
  %31 = load ptr, ptr %30, align 8
  %32 = load i32, ptr %5, align 4
  %33 = zext i32 %32 to i64
  %34 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %31, i64 %33
  %35 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %34, i32 0, i32 0
  call void @ck_pr_md_store_uint(ptr noundef %35, i32 noundef 0)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %4 = call ptr @malloc(i64 noundef 24) #5
  store ptr %4, ptr @slots, align 8
  %5 = load ptr, ptr @slots, align 8
  %6 = icmp eq ptr %5, null
  br i1 %6, label %7, label %8

7:                                                ; preds = %0
  call void @exit(i32 noundef 1) #6
  unreachable

8:                                                ; preds = %0
  %9 = load ptr, ptr @slots, align 8
  call void @ck_spinlock_anderson_init(ptr noundef @lock, ptr noundef %9, i32 noundef 3)
  store i32 0, ptr %3, align 4
  br label %10

10:                                               ; preds = %21, %8
  %11 = load i32, ptr %3, align 4
  %12 = icmp slt i32 %11, 3
  br i1 %12, label %13, label %24

13:                                               ; preds = %10
  %14 = load i32, ptr %3, align 4
  %15 = sext i32 %14 to i64
  %16 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %15
  %17 = call i32 @pthread_create(ptr noundef %16, ptr noundef null, ptr noundef @run, ptr noundef null)
  %18 = icmp ne i32 %17, 0
  br i1 %18, label %19, label %20

19:                                               ; preds = %13
  call void @exit(i32 noundef 1) #6
  unreachable

20:                                               ; preds = %13
  br label %21

21:                                               ; preds = %20
  %22 = load i32, ptr %3, align 4
  %23 = add nsw i32 %22, 1
  store i32 %23, ptr %3, align 4
  br label %10, !llvm.loop !9

24:                                               ; preds = %10
  store i32 0, ptr %3, align 4
  br label %25

25:                                               ; preds = %37, %24
  %26 = load i32, ptr %3, align 4
  %27 = icmp slt i32 %26, 3
  br i1 %27, label %28, label %40

28:                                               ; preds = %25
  %29 = load i32, ptr %3, align 4
  %30 = sext i32 %29 to i64
  %31 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %30
  %32 = load ptr, ptr %31, align 8
  %33 = call i32 @"\01_pthread_join"(ptr noundef %32, ptr noundef null)
  %34 = icmp ne i32 %33, 0
  br i1 %34, label %35, label %36

35:                                               ; preds = %28
  call void @exit(i32 noundef 1) #6
  unreachable

36:                                               ; preds = %28
  br label %37

37:                                               ; preds = %36
  %38 = load i32, ptr %3, align 4
  %39 = add nsw i32 %38, 1
  store i32 %39, ptr %3, align 4
  br label %25, !llvm.loop !10

40:                                               ; preds = %25
  %41 = load i32, ptr @x, align 4
  %42 = icmp eq i32 %41, 3
  br i1 %42, label %43, label %46

43:                                               ; preds = %40
  %44 = load i32, ptr @y, align 4
  %45 = icmp eq i32 %44, 3
  br label %46

46:                                               ; preds = %43, %40
  %47 = phi i1 [ false, %40 ], [ %45, %43 ]
  %48 = xor i1 %47, true
  %49 = zext i1 %48 to i32
  %50 = sext i32 %49 to i64
  %51 = icmp ne i64 %50, 0
  br i1 %51, label %52, label %54

52:                                               ; preds = %46
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 48, ptr noundef @.str.1) #7
  unreachable

53:                                               ; No predecessors!
  br label %55

54:                                               ; preds = %46
  br label %55

55:                                               ; preds = %54, %53
  %56 = load ptr, ptr @slots, align 8
  call void @free(ptr noundef %56)
  ret i32 0
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_anderson_init(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store i32 %2, ptr %6, align 4
  %8 = load ptr, ptr %5, align 8
  %9 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %8, i64 0
  %10 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %9, i32 0, i32 0
  store i32 0, ptr %10, align 4
  %11 = load ptr, ptr %5, align 8
  %12 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %11, i64 0
  %13 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %12, i32 0, i32 1
  store i32 0, ptr %13, align 4
  store i32 1, ptr %7, align 4
  br label %14

14:                                               ; preds = %30, %3
  %15 = load i32, ptr %7, align 4
  %16 = load i32, ptr %6, align 4
  %17 = icmp ult i32 %15, %16
  br i1 %17, label %18, label %33

18:                                               ; preds = %14
  %19 = load ptr, ptr %5, align 8
  %20 = load i32, ptr %7, align 4
  %21 = zext i32 %20 to i64
  %22 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %19, i64 %21
  %23 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %22, i32 0, i32 0
  store i32 1, ptr %23, align 4
  %24 = load i32, ptr %7, align 4
  %25 = load ptr, ptr %5, align 8
  %26 = load i32, ptr %7, align 4
  %27 = zext i32 %26 to i64
  %28 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %25, i64 %27
  %29 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %28, i32 0, i32 1
  store i32 %24, ptr %29, align 4
  br label %30

30:                                               ; preds = %18
  %31 = load i32, ptr %7, align 4
  %32 = add i32 %31, 1
  store i32 %32, ptr %7, align 4
  br label %14, !llvm.loop !11

33:                                               ; preds = %14
  %34 = load ptr, ptr %5, align 8
  %35 = load ptr, ptr %4, align 8
  %36 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %35, i32 0, i32 0
  store ptr %34, ptr %36, align 8
  %37 = load i32, ptr %6, align 4
  %38 = load ptr, ptr %4, align 8
  %39 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %38, i32 0, i32 1
  store i32 %37, ptr %39, align 8
  %40 = load i32, ptr %6, align 4
  %41 = sub i32 %40, 1
  %42 = load ptr, ptr %4, align 8
  %43 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %42, i32 0, i32 3
  store i32 %41, ptr %43, align 8
  %44 = load ptr, ptr %4, align 8
  %45 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %44, i32 0, i32 5
  store i32 0, ptr %45, align 8
  %46 = load i32, ptr %6, align 4
  %47 = load i32, ptr %6, align 4
  %48 = sub i32 %47, 1
  %49 = and i32 %46, %48
  %50 = icmp ne i32 %49, 0
  br i1 %50, label %51, label %57

51:                                               ; preds = %33
  %52 = load i32, ptr %6, align 4
  %53 = urem i32 -1, %52
  %54 = add i32 %53, 1
  %55 = load ptr, ptr %4, align 8
  %56 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %55, i32 0, i32 2
  store i32 %54, ptr %56, align 4
  br label %60

57:                                               ; preds = %33
  %58 = load ptr, ptr %4, align 8
  %59 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %58, i32 0, i32 2
  store i32 0, ptr %59, align 4
  br label %60

60:                                               ; preds = %57, %51
  call void @ck_pr_barrier()
  ret void
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #3

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

declare void @free(ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_md_load_uint(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  store i64 0, ptr %3, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = call i64 asm sideeffect "ldr ${0:w}, [$1]\0A", "=r,r,~{memory}"(ptr %4) #8, !srcloc !12
  store i64 %5, ptr %3, align 8
  %6 = load i64, ptr %3, align 8
  %7 = trunc i64 %6 to i32
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_pr_cas_uint_value(ptr noundef %0, i32 noundef %1, i32 noundef %2, ptr noundef %3) #0 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store i32 %1, ptr %6, align 4
  store i32 %2, ptr %7, align 4
  store ptr %3, ptr %8, align 8
  %11 = load ptr, ptr %5, align 8
  %12 = load i32, ptr %7, align 4
  %13 = load i32, ptr %6, align 4
  %14 = call { i32, i32 } asm sideeffect "1:\0Aldxr ${0:w}, [$2]\0Acmp  ${0:w}, ${4:w}\0Ab.ne 2f\0Astxr ${1:w}, ${3:w}, [$2]\0Acbnz ${1:w}, 1b\0A2:", "=&r,=&r,r,r,r,~{memory},~{cc}"(ptr %11, i32 %12, i32 %13) #8, !srcloc !13
  %15 = extractvalue { i32, i32 } %14, 0
  %16 = extractvalue { i32, i32 } %14, 1
  store i32 %15, ptr %9, align 4
  store i32 %16, ptr %10, align 4
  %17 = load i32, ptr %9, align 4
  %18 = load ptr, ptr %8, align 8
  store i32 %17, ptr %18, align 4
  %19 = load i32, ptr %9, align 4
  %20 = load i32, ptr %6, align 4
  %21 = icmp eq i32 %19, %20
  ret i1 %21
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_faa_uint(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %8 = load ptr, ptr %3, align 8
  %9 = load i32, ptr %4, align 4
  %10 = call { i32, i32, i32 } asm sideeffect "1:ldxr ${0:w}, [$3]\0Aadd ${1:w}, ${4:w}, ${0:w}\0Astxr ${2:w}, ${1:w}, [$3]\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,r,r,~{memory},~{cc}"(ptr %8, i32 %9) #8, !srcloc !14
  %11 = extractvalue { i32, i32, i32 } %10, 0
  %12 = extractvalue { i32, i32, i32 } %10, 1
  %13 = extractvalue { i32, i32, i32 } %10, 2
  store i32 %11, ptr %5, align 4
  store i32 %12, ptr %6, align 4
  store i32 %13, ptr %7, align 4
  %14 = load i32, ptr %5, align 4
  ret i32 %14
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_load() #0 {
  call void @ck_pr_fence_strict_load()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_stall() #0 {
  call void asm sideeffect "", "~{memory}"() #8, !srcloc !15
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8
  %6 = load ptr, ptr %3, align 8
  %7 = load i32, ptr %4, align 4
  call void asm sideeffect "str ${2:w}, [$1]", "=*m,r,r,~{memory}"(ptr elementtype(i32) %5, ptr %6, i32 %7) #8, !srcloc !16
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_lock() #0 {
  call void @ck_pr_fence_strict_lock()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_load() #0 {
  call void asm sideeffect "dmb ishld", "r,~{memory}"(i32 0) #8, !srcloc !17
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_lock() #0 {
  call void asm sideeffect "dmb ish", "r,~{memory}"(i32 0) #8, !srcloc !18
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_unlock() #0 {
  call void @ck_pr_fence_strict_unlock()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_unlock() #0 {
  call void asm sideeffect "dmb ish", "r,~{memory}"(i32 0) #8, !srcloc !19
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_barrier() #0 {
  call void asm sideeffect "", "~{memory}"() #8, !srcloc !20
  ret void
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #4 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #5 = { allocsize(0) }
attributes #6 = { noreturn }
attributes #7 = { cold noreturn }
attributes #8 = { nounwind }

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
!12 = !{i64 2147763329}
!13 = !{i64 2147791815, i64 2147791865, i64 2147791932, i64 2147791998, i64 2147792051, i64 2147792123, i64 2147792181}
!14 = !{i64 2147886967, i64 2147887079, i64 2147887141, i64 2147887209}
!15 = !{i64 264431}
!16 = !{i64 2147767016}
!17 = !{i64 2147759231}
!18 = !{i64 2147760843}
!19 = !{i64 2147761108}
!20 = !{i64 418277}
