; ModuleID = 'test/spinlock/rec_mcslock.c'
source_filename = "test/spinlock/rec_mcslock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.rec_mcslock_s = type { %struct.mcslock_s, %struct.vatomic32_s, i32, [120 x i8] }
%struct.mcslock_s = type { %struct.vatomicptr_s, [120 x i8] }
%struct.vatomicptr_s = type { ptr }
%struct.vatomic32_s = type { i32 }
%struct.mcs_node_s = type { %struct.vatomicptr_s, %struct.vatomic32_s, [116 x i8] }

@g_cs_x = internal global i32 0, align 4
@g_cs_y = internal global i32 0, align 4
@__func__.check = private unnamed_addr constant [6 x i8] c"check\00", align 1
@.str = private unnamed_addr constant [7 x i8] c"lock.h\00", align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 0 + 1)\00", align 1
@lock = global %struct.rec_mcslock_s { %struct.mcslock_s { %struct.vatomicptr_s zeroinitializer, [120 x i8] undef }, %struct.vatomic32_s { i32 -1 }, i32 0, [120 x i8] undef }, align 128
@nodes = global [3 x %struct.mcs_node_s] zeroinitializer, align 128
@.str.3 = private unnamed_addr constant [23 x i8] c"this value is reserved\00", align 1
@__func__.rec_mcslock_acquire = private unnamed_addr constant [20 x i8] c"rec_mcslock_acquire\00", align 1
@.str.4 = private unnamed_addr constant [14 x i8] c"rec_mcslock.h\00", align 1
@.str.5 = private unnamed_addr constant [46 x i8] c"id != 4294967295U && \22this value is reserved\22\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @init() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @post() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @fini() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @cs() #0 {
  %1 = load i32, ptr @g_cs_x, align 4
  %2 = add i32 %1, 1
  store i32 %2, ptr @g_cs_x, align 4
  %3 = load i32, ptr @g_cs_y, align 4
  %4 = add i32 %3, 1
  store i32 %4, ptr @g_cs_y, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @check() #0 {
  %1 = load i32, ptr @g_cs_x, align 4
  %2 = load i32, ptr @g_cs_y, align 4
  %3 = icmp eq i32 %1, %2
  %4 = xor i1 %3, true
  %5 = zext i1 %4 to i32
  %6 = sext i32 %5 to i64
  %7 = icmp ne i64 %6, 0
  br i1 %7, label %8, label %10

8:                                                ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.check, ptr noundef @.str, i32 noundef 117, ptr noundef @.str.1) #3
  unreachable

9:                                                ; No predecessors!
  br label %11

10:                                               ; preds = %0
  br label %11

11:                                               ; preds = %10, %9
  %12 = load i32, ptr @g_cs_x, align 4
  %13 = icmp eq i32 %12, 4
  %14 = xor i1 %13, true
  %15 = zext i1 %14 to i32
  %16 = sext i32 %15 to i64
  %17 = icmp ne i64 %16, 0
  br i1 %17, label %18, label %20

18:                                               ; preds = %11
  call void @__assert_rtn(ptr noundef @__func__.check, ptr noundef @.str, i32 noundef 118, ptr noundef @.str.2) #3
  unreachable

19:                                               ; No predecessors!
  br label %21

20:                                               ; preds = %11
  br label %21

21:                                               ; preds = %20, %19
  ret void
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  call void @init()
  call void @verification_loop_bound(i32 noundef 4)
  store i64 0, ptr %3, align 8
  br label %5

5:                                                ; preds = %14, %0
  %6 = load i64, ptr %3, align 8
  %7 = icmp ult i64 %6, 3
  br i1 %7, label %8, label %17

8:                                                ; preds = %5
  %9 = load i64, ptr %3, align 8
  %10 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %9
  %11 = load i64, ptr %3, align 8
  %12 = inttoptr i64 %11 to ptr
  %13 = call i32 @pthread_create(ptr noundef %10, ptr noundef null, ptr noundef @run, ptr noundef %12)
  br label %14

14:                                               ; preds = %8
  %15 = load i64, ptr %3, align 8
  %16 = add i64 %15, 1
  store i64 %16, ptr %3, align 8
  br label %5, !llvm.loop !5

17:                                               ; preds = %5
  call void @post()
  call void @verification_loop_bound(i32 noundef 4)
  store i64 0, ptr %4, align 8
  br label %18

18:                                               ; preds = %26, %17
  %19 = load i64, ptr %4, align 8
  %20 = icmp ult i64 %19, 3
  br i1 %20, label %21, label %29

21:                                               ; preds = %18
  %22 = load i64, ptr %4, align 8
  %23 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %22
  %24 = load ptr, ptr %23, align 8
  %25 = call i32 @"\01_pthread_join"(ptr noundef %24, ptr noundef null)
  br label %26

26:                                               ; preds = %21
  %27 = load i64, ptr %4, align 8
  %28 = add i64 %27, 1
  store i64 %28, ptr %4, align 8
  br label %18, !llvm.loop !7

29:                                               ; preds = %18
  call void @check()
  call void @fini()
  ret i32 0
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

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @run(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %7 = load ptr, ptr %2, align 8
  %8 = ptrtoint ptr %7 to i64
  %9 = trunc i64 %8 to i32
  store i32 %9, ptr %3, align 4
  call void @verification_loop_bound(i32 noundef 2)
  store i32 0, ptr %4, align 4
  br label %10

10:                                               ; preds = %65, %1
  %11 = load i32, ptr %4, align 4
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %22, label %13

13:                                               ; preds = %10
  %14 = load i32, ptr %4, align 4
  %15 = icmp eq i32 %14, 1
  br i1 %15, label %16, label %20

16:                                               ; preds = %13
  %17 = load i32, ptr %3, align 4
  %18 = add i32 %17, 1
  %19 = icmp ult i32 %18, 1
  br label %20

20:                                               ; preds = %16, %13
  %21 = phi i1 [ false, %13 ], [ %19, %16 ]
  br label %22

22:                                               ; preds = %20, %10
  %23 = phi i1 [ true, %10 ], [ %21, %20 ]
  br i1 %23, label %24, label %68

24:                                               ; preds = %22
  call void @verification_loop_bound(i32 noundef 3)
  store i32 0, ptr %5, align 4
  br label %25

25:                                               ; preds = %41, %24
  %26 = load i32, ptr %5, align 4
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %37, label %28

28:                                               ; preds = %25
  %29 = load i32, ptr %5, align 4
  %30 = icmp eq i32 %29, 1
  br i1 %30, label %31, label %35

31:                                               ; preds = %28
  %32 = load i32, ptr %3, align 4
  %33 = add i32 %32, 1
  %34 = icmp ult i32 %33, 2
  br label %35

35:                                               ; preds = %31, %28
  %36 = phi i1 [ false, %28 ], [ %34, %31 ]
  br label %37

37:                                               ; preds = %35, %25
  %38 = phi i1 [ true, %25 ], [ %36, %35 ]
  br i1 %38, label %39, label %44

39:                                               ; preds = %37
  %40 = load i32, ptr %3, align 4
  call void @acquire(i32 noundef %40)
  call void @cs()
  br label %41

41:                                               ; preds = %39
  %42 = load i32, ptr %5, align 4
  %43 = add nsw i32 %42, 1
  store i32 %43, ptr %5, align 4
  br label %25, !llvm.loop !8

44:                                               ; preds = %37
  call void @verification_loop_bound(i32 noundef 3)
  store i32 0, ptr %6, align 4
  br label %45

45:                                               ; preds = %61, %44
  %46 = load i32, ptr %6, align 4
  %47 = icmp eq i32 %46, 0
  br i1 %47, label %57, label %48

48:                                               ; preds = %45
  %49 = load i32, ptr %6, align 4
  %50 = icmp eq i32 %49, 1
  br i1 %50, label %51, label %55

51:                                               ; preds = %48
  %52 = load i32, ptr %3, align 4
  %53 = add i32 %52, 1
  %54 = icmp ult i32 %53, 2
  br label %55

55:                                               ; preds = %51, %48
  %56 = phi i1 [ false, %48 ], [ %54, %51 ]
  br label %57

57:                                               ; preds = %55, %45
  %58 = phi i1 [ true, %45 ], [ %56, %55 ]
  br i1 %58, label %59, label %64

59:                                               ; preds = %57
  %60 = load i32, ptr %3, align 4
  call void @release(i32 noundef %60)
  br label %61

61:                                               ; preds = %59
  %62 = load i32, ptr %6, align 4
  %63 = add nsw i32 %62, 1
  store i32 %63, ptr %6, align 4
  br label %45, !llvm.loop !9

64:                                               ; preds = %57
  br label %65

65:                                               ; preds = %64
  %66 = load i32, ptr %4, align 4
  %67 = add nsw i32 %66, 1
  store i32 %67, ptr %4, align 4
  br label %10, !llvm.loop !10

68:                                               ; preds = %22
  ret ptr null
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @acquire(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %3 = load i32, ptr %2, align 4
  %4 = load i32, ptr %2, align 4
  %5 = zext i32 %4 to i64
  %6 = getelementptr inbounds [3 x %struct.mcs_node_s], ptr @nodes, i64 0, i64 %5
  call void @rec_mcslock_acquire(ptr noundef @lock, i32 noundef %3, ptr noundef %6)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @rec_mcslock_acquire(ptr noundef %0, i32 noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store i32 %1, ptr %5, align 4
  store ptr %2, ptr %6, align 8
  %7 = load i32, ptr %5, align 4
  %8 = icmp ne i32 %7, -1
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
  call void @__assert_rtn(ptr noundef @__func__.rec_mcslock_acquire, ptr noundef @.str.4, i32 noundef 28, ptr noundef @.str.5) #3
  unreachable

17:                                               ; No predecessors!
  br label %19

18:                                               ; preds = %10
  br label %19

19:                                               ; preds = %18, %17
  %20 = load ptr, ptr %4, align 8
  %21 = getelementptr inbounds %struct.rec_mcslock_s, ptr %20, i32 0, i32 1
  %22 = call i32 @vatomic32_read_rlx(ptr noundef %21)
  %23 = load i32, ptr %5, align 4
  %24 = icmp eq i32 %22, %23
  br i1 %24, label %25, label %30

25:                                               ; preds = %19
  %26 = load ptr, ptr %4, align 8
  %27 = getelementptr inbounds %struct.rec_mcslock_s, ptr %26, i32 0, i32 2
  %28 = load i32, ptr %27, align 4
  %29 = add i32 %28, 1
  store i32 %29, ptr %27, align 4
  br label %37

30:                                               ; preds = %19
  %31 = load ptr, ptr %4, align 8
  %32 = getelementptr inbounds %struct.rec_mcslock_s, ptr %31, i32 0, i32 0
  %33 = load ptr, ptr %6, align 8
  call void @mcslock_acquire(ptr noundef %32, ptr noundef %33)
  %34 = load ptr, ptr %4, align 8
  %35 = getelementptr inbounds %struct.rec_mcslock_s, ptr %34, i32 0, i32 1
  %36 = load i32, ptr %5, align 4
  call void @vatomic32_write_rlx(ptr noundef %35, i32 noundef %36)
  br label %37

37:                                               ; preds = %30, %25
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @release(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %3 = load i32, ptr %2, align 4
  %4 = zext i32 %3 to i64
  %5 = getelementptr inbounds [3 x %struct.mcs_node_s], ptr @nodes, i64 0, i64 %4
  call void @rec_mcslock_release(ptr noundef @lock, ptr noundef %5)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @rec_mcslock_release(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8
  %6 = getelementptr inbounds %struct.rec_mcslock_s, ptr %5, i32 0, i32 2
  %7 = load i32, ptr %6, align 4
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %15

9:                                                ; preds = %2
  %10 = load ptr, ptr %3, align 8
  %11 = getelementptr inbounds %struct.rec_mcslock_s, ptr %10, i32 0, i32 1
  call void @vatomic32_write_rlx(ptr noundef %11, i32 noundef -1)
  %12 = load ptr, ptr %3, align 8
  %13 = getelementptr inbounds %struct.rec_mcslock_s, ptr %12, i32 0, i32 0
  %14 = load ptr, ptr %4, align 8
  call void @mcslock_release(ptr noundef %13, ptr noundef %14)
  br label %20

15:                                               ; preds = %2
  %16 = load ptr, ptr %3, align 8
  %17 = getelementptr inbounds %struct.rec_mcslock_s, ptr %16, i32 0, i32 2
  %18 = load i32, ptr %17, align 4
  %19 = add i32 %18, -1
  store i32 %19, ptr %17, align 4
  br label %20

20:                                               ; preds = %15, %9
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_read_rlx(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomic32_s, ptr %4, i32 0, i32 0
  %6 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,*Q,~{memory}"(ptr elementtype(i32) %5) #4, !srcloc !11
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @mcslock_acquire(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load ptr, ptr %4, align 8
  %7 = getelementptr inbounds %struct.mcs_node_s, ptr %6, i32 0, i32 0
  call void @vatomicptr_write_rlx(ptr noundef %7, ptr noundef null)
  %8 = load ptr, ptr %4, align 8
  %9 = getelementptr inbounds %struct.mcs_node_s, ptr %8, i32 0, i32 1
  call void @vatomic32_write_rlx(ptr noundef %9, i32 noundef 1)
  %10 = load ptr, ptr %3, align 8
  %11 = getelementptr inbounds %struct.mcslock_s, ptr %10, i32 0, i32 0
  %12 = load ptr, ptr %4, align 8
  %13 = call ptr @vatomicptr_xchg(ptr noundef %11, ptr noundef %12)
  store ptr %13, ptr %5, align 8
  %14 = load ptr, ptr %5, align 8
  %15 = icmp ne ptr %14, null
  br i1 %15, label %16, label %23

16:                                               ; preds = %2
  %17 = load ptr, ptr %5, align 8
  %18 = getelementptr inbounds %struct.mcs_node_s, ptr %17, i32 0, i32 0
  %19 = load ptr, ptr %4, align 8
  call void @vatomicptr_write_rel(ptr noundef %18, ptr noundef %19)
  %20 = load ptr, ptr %4, align 8
  %21 = getelementptr inbounds %struct.mcs_node_s, ptr %20, i32 0, i32 1
  %22 = call i32 @vatomic32_await_eq_acq(ptr noundef %21, i32 noundef 0)
  br label %23

23:                                               ; preds = %16, %2
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
  call void asm sideeffect "str ${0:w}, $1", "r,*Q,~{memory}"(i32 %5, ptr elementtype(i32) %7) #4, !srcloc !12
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomicptr_write_rlx(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %4, align 8
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct.vatomicptr_s, ptr %6, i32 0, i32 0
  call void asm sideeffect "str ${0:x}, $1", "r,*Q,~{memory}"(ptr %5, ptr elementtype(ptr) %7) #4, !srcloc !13
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @vatomicptr_xchg(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %7 = load ptr, ptr %4, align 8
  %8 = load ptr, ptr %3, align 8
  %9 = getelementptr inbounds %struct.vatomicptr_s, ptr %8, i32 0, i32 0
  %10 = call { ptr, i32 } asm sideeffect "prfm pstl1strm, $3\0A1:\0Aldaxr ${0:x}, $3\0Astlxr  ${1:w}, ${2:x}, $3\0Acbnz ${1:w}, 1b\0A", "=&r,=&r,r,*Q,~{memory}"(ptr %7, ptr elementtype(ptr) %9) #4, !srcloc !14
  %11 = extractvalue { ptr, i32 } %10, 0
  %12 = extractvalue { ptr, i32 } %10, 1
  store ptr %11, ptr %5, align 8
  store i32 %12, ptr %6, align 4
  %13 = load ptr, ptr %5, align 8
  ret ptr %13
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomicptr_write_rel(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %4, align 8
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct.vatomicptr_s, ptr %6, i32 0, i32 0
  call void asm sideeffect "stlr ${0:x}, $1", "r,*Q,~{memory}"(ptr %5, ptr elementtype(ptr) %7) #4, !srcloc !15
  ret void
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
  %9 = call i32 asm sideeffect "1:\0Aldar ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.ne 1b\0A", "=&r,r,*Q,~{memory},~{cc}"(i32 %6, ptr elementtype(i32) %8) #4, !srcloc !16
  store i32 %9, ptr %5, align 4
  %10 = load i32, ptr %5, align 4
  ret i32 %10
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @mcslock_release(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load ptr, ptr %4, align 8
  %7 = getelementptr inbounds %struct.mcs_node_s, ptr %6, i32 0, i32 0
  %8 = call ptr @vatomicptr_read_rlx(ptr noundef %7)
  %9 = icmp eq ptr %8, null
  br i1 %9, label %10, label %23

10:                                               ; preds = %2
  %11 = load ptr, ptr %3, align 8
  %12 = getelementptr inbounds %struct.mcslock_s, ptr %11, i32 0, i32 0
  %13 = load ptr, ptr %4, align 8
  %14 = call ptr @vatomicptr_cmpxchg_rel(ptr noundef %12, ptr noundef %13, ptr noundef null)
  store ptr %14, ptr %5, align 8
  %15 = load ptr, ptr %5, align 8
  %16 = load ptr, ptr %4, align 8
  %17 = icmp eq ptr %15, %16
  br i1 %17, label %18, label %19

18:                                               ; preds = %10
  br label %29

19:                                               ; preds = %10
  %20 = load ptr, ptr %4, align 8
  %21 = getelementptr inbounds %struct.mcs_node_s, ptr %20, i32 0, i32 0
  %22 = call ptr @vatomicptr_await_neq_rlx(ptr noundef %21, ptr noundef null)
  br label %23

23:                                               ; preds = %19, %2
  %24 = load ptr, ptr %4, align 8
  %25 = getelementptr inbounds %struct.mcs_node_s, ptr %24, i32 0, i32 0
  %26 = call ptr @vatomicptr_read_acq(ptr noundef %25)
  store ptr %26, ptr %5, align 8
  %27 = load ptr, ptr %5, align 8
  %28 = getelementptr inbounds %struct.mcs_node_s, ptr %27, i32 0, i32 1
  call void @vatomic32_write_rel(ptr noundef %28, i32 noundef 0)
  br label %29

29:                                               ; preds = %23, %18
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @vatomicptr_read_rlx(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomicptr_s, ptr %4, i32 0, i32 0
  %6 = call ptr asm sideeffect "ldr ${0:x}, $1", "=&r,*Q,~{memory}"(ptr elementtype(ptr) %5) #4, !srcloc !17
  store ptr %6, ptr %3, align 8
  %7 = load ptr, ptr %3, align 8
  ret ptr %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @vatomicptr_cmpxchg_rel(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store ptr %2, ptr %6, align 8
  %9 = load ptr, ptr %6, align 8
  %10 = load ptr, ptr %5, align 8
  %11 = load ptr, ptr %4, align 8
  %12 = getelementptr inbounds %struct.vatomicptr_s, ptr %11, i32 0, i32 0
  %13 = call { ptr, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:x}, $4\0Acmp ${0:x}, ${3:x}\0Ab.ne 2f\0Astlxr  ${1:w}, ${2:x}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,*Q,~{memory},~{cc}"(ptr %9, ptr %10, ptr elementtype(ptr) %12) #4, !srcloc !18
  %14 = extractvalue { ptr, i32 } %13, 0
  %15 = extractvalue { ptr, i32 } %13, 1
  store ptr %14, ptr %7, align 8
  store i32 %15, ptr %8, align 4
  %16 = load ptr, ptr %7, align 8
  ret ptr %16
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @vatomicptr_await_neq_rlx(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load ptr, ptr %4, align 8
  %7 = load ptr, ptr %3, align 8
  %8 = getelementptr inbounds %struct.vatomicptr_s, ptr %7, i32 0, i32 0
  %9 = call ptr asm sideeffect "1:\0Aldr ${0:x}, $2\0Acmp ${0:x}, ${1:x}\0Ab.eq 1b\0A", "=&r,r,*Q,~{memory},~{cc}"(ptr %6, ptr elementtype(ptr) %8) #4, !srcloc !19
  store ptr %9, ptr %5, align 8
  %10 = load ptr, ptr %5, align 8
  ret ptr %10
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @vatomicptr_read_acq(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomicptr_s, ptr %4, i32 0, i32 0
  %6 = call ptr asm sideeffect "ldar ${0:x}, $1", "=&r,*Q,~{memory}"(ptr elementtype(ptr) %5) #4, !srcloc !20
  store ptr %6, ptr %3, align 8
  %7 = load ptr, ptr %3, align 8
  ret ptr %7
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
  call void asm sideeffect "stlr ${0:w}, $1", "r,*Q,~{memory}"(i32 %5, ptr elementtype(i32) %7) #4, !srcloc !21
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
!9 = distinct !{!9, !6}
!10 = distinct !{!10, !6}
!11 = !{i64 919917}
!12 = !{i64 924301}
!13 = !{i64 927090}
!14 = !{i64 981400, i64 981434, i64 981449, i64 981482, i64 981525}
!15 = !{i64 926619}
!16 = !{i64 934453, i64 934469, i64 934500, i64 934533}
!17 = !{i64 922889}
!18 = !{i64 991738, i64 991772, i64 991787, i64 991819, i64 991853, i64 991873, i64 991916, i64 991945}
!19 = !{i64 974532, i64 974548, i64 974578, i64 974611}
!20 = !{i64 922389}
!21 = !{i64 923831}
