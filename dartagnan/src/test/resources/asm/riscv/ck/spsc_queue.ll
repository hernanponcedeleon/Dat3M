; ModuleID = 'tests/queues/spsc.c'
source_filename = "tests/queues/spsc.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_fifo_spsc = type { %struct.ck_spinlock_fas, ptr, [52 x i8], %struct.ck_spinlock_fas, ptr, ptr, ptr }
%struct.ck_spinlock_fas = type { i32 }
%struct.point_s = type { i32, i32 }
%struct.ck_fifo_spsc_entry = type { ptr, ptr }

@__stderrp = external global ptr, align 8
@.str = private unnamed_addr constant [36 x i8] c"Producer: Memory allocation failed\0A\00", align 1
@.str.1 = private unnamed_addr constant [35 x i8] c"Producer: Entry allocation failed\0A\00", align 1
@queue = global %struct.ck_fifo_spsc zeroinitializer, align 8
@.str.2 = private unnamed_addr constant [35 x i8] c"Producer: Enqueued point (%u, %u)\0A\00", align 1
@.str.3 = private unnamed_addr constant [51 x i8] c"Producer: Entry allocation failed for NULL signal\0A\00", align 1
@.str.4 = private unnamed_addr constant [20 x i8] c"NULL point received\00", align 1
@__func__.consumer = private unnamed_addr constant [9 x i8] c"consumer\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c"spsc.c\00", align 1
@.str.6 = private unnamed_addr constant [39 x i8] c"point != NULL && \22NULL point received\22\00", align 1
@.str.7 = private unnamed_addr constant [21 x i8] c"point->x == point->y\00", align 1
@.str.8 = private unnamed_addr constant [14 x i8] c"point->y == 1\00", align 1
@.str.9 = private unnamed_addr constant [35 x i8] c"Consumer: Dequeued point (%u, %u)\0A\00", align 1
@.str.10 = private unnamed_addr constant [44 x i8] c"Consumer: Processed all elements, exiting.\0A\00", align 1
@.str.11 = private unnamed_addr constant [45 x i8] c"Error: Initial FIFO entry allocation failed\0A\00", align 1
@.str.12 = private unnamed_addr constant [24 x i8] c"Error creating threads\0A\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @producer(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  store i32 0, ptr %3, align 4
  br label %7

7:                                                ; preds = %39, %1
  %8 = load i32, ptr %3, align 4
  %9 = icmp slt i32 %8, 3
  br i1 %9, label %10, label %42

10:                                               ; preds = %7
  %11 = call ptr @malloc(i64 noundef 8) #6
  store ptr %11, ptr %4, align 8
  %12 = load ptr, ptr %4, align 8
  %13 = icmp eq ptr %12, null
  br i1 %13, label %14, label %17

14:                                               ; preds = %10
  %15 = load ptr, ptr @__stderrp, align 8
  %16 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %15, ptr noundef @.str) #7
  call void @exit(i32 noundef 1) #8
  unreachable

17:                                               ; preds = %10
  %18 = load ptr, ptr %4, align 8
  %19 = getelementptr inbounds %struct.point_s, ptr %18, i32 0, i32 0
  store i32 1, ptr %19, align 4
  %20 = load ptr, ptr %4, align 8
  %21 = getelementptr inbounds %struct.point_s, ptr %20, i32 0, i32 1
  store i32 1, ptr %21, align 4
  %22 = call ptr @malloc(i64 noundef 16) #6
  store ptr %22, ptr %5, align 8
  %23 = load ptr, ptr %5, align 8
  %24 = icmp eq ptr %23, null
  br i1 %24, label %25, label %29

25:                                               ; preds = %17
  %26 = load ptr, ptr @__stderrp, align 8
  %27 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %26, ptr noundef @.str.1) #7
  %28 = load ptr, ptr %4, align 8
  call void @free(ptr noundef %28)
  call void @exit(i32 noundef 1) #8
  unreachable

29:                                               ; preds = %17
  %30 = load ptr, ptr %5, align 8
  %31 = load ptr, ptr %4, align 8
  call void @ck_fifo_spsc_enqueue(ptr noundef @queue, ptr noundef %30, ptr noundef %31)
  %32 = load ptr, ptr %4, align 8
  %33 = getelementptr inbounds %struct.point_s, ptr %32, i32 0, i32 0
  %34 = load i32, ptr %33, align 4
  %35 = load ptr, ptr %4, align 8
  %36 = getelementptr inbounds %struct.point_s, ptr %35, i32 0, i32 1
  %37 = load i32, ptr %36, align 4
  %38 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef %34, i32 noundef %37)
  br label %39

39:                                               ; preds = %29
  %40 = load i32, ptr %3, align 4
  %41 = add nsw i32 %40, 1
  store i32 %41, ptr %3, align 4
  br label %7, !llvm.loop !6

42:                                               ; preds = %7
  %43 = call ptr @malloc(i64 noundef 16) #6
  store ptr %43, ptr %6, align 8
  %44 = load ptr, ptr %6, align 8
  %45 = icmp eq ptr %44, null
  br i1 %45, label %46, label %49

46:                                               ; preds = %42
  %47 = load ptr, ptr @__stderrp, align 8
  %48 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %47, ptr noundef @.str.3) #7
  call void @exit(i32 noundef 1) #8
  unreachable

49:                                               ; preds = %42
  %50 = load ptr, ptr %6, align 8
  call void @ck_fifo_spsc_enqueue(ptr noundef @queue, ptr noundef %50, ptr noundef null)
  ret ptr null
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: nounwind
declare i32 @fprintf(ptr noundef, ptr noundef, ...) #2

; Function Attrs: noreturn
declare void @exit(i32 noundef) #3

declare void @free(ptr noundef) #4

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_fifo_spsc_enqueue(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store ptr %2, ptr %6, align 8
  %7 = load ptr, ptr %6, align 8
  %8 = load ptr, ptr %5, align 8
  %9 = getelementptr inbounds %struct.ck_fifo_spsc_entry, ptr %8, i32 0, i32 0
  store ptr %7, ptr %9, align 8
  %10 = load ptr, ptr %5, align 8
  %11 = getelementptr inbounds %struct.ck_fifo_spsc_entry, ptr %10, i32 0, i32 1
  store ptr null, ptr %11, align 8
  call void @ck_pr_fence_store()
  %12 = load ptr, ptr %4, align 8
  %13 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %12, i32 0, i32 4
  %14 = load ptr, ptr %13, align 8
  %15 = getelementptr inbounds %struct.ck_fifo_spsc_entry, ptr %14, i32 0, i32 1
  %16 = load ptr, ptr %5, align 8
  call void @ck_pr_md_store_ptr(ptr noundef %15, ptr noundef %16)
  %17 = load ptr, ptr %5, align 8
  %18 = load ptr, ptr %4, align 8
  %19 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %18, i32 0, i32 4
  store ptr %17, ptr %19, align 8
  ret void
}

declare i32 @printf(ptr noundef, ...) #4

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @consumer(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  store i32 0, ptr %4, align 4
  br label %6

6:                                                ; preds = %63, %1
  %7 = load i32, ptr %4, align 4
  %8 = icmp slt i32 %7, 3
  br i1 %8, label %9, label %66

9:                                                ; preds = %6
  %10 = call zeroext i1 @ck_fifo_spsc_dequeue(ptr noundef @queue, ptr noundef %3)
  %11 = zext i1 %10 to i8
  store i8 %11, ptr %5, align 1
  %12 = load i8, ptr %5, align 1
  %13 = trunc i8 %12 to i1
  %14 = zext i1 %13 to i32
  call void @__VERIFIER_assume(i32 noundef %14)
  %15 = load ptr, ptr %3, align 8
  %16 = icmp ne ptr %15, null
  br i1 %16, label %17, label %18

17:                                               ; preds = %9
  br label %18

18:                                               ; preds = %17, %9
  %19 = phi i1 [ false, %9 ], [ true, %17 ]
  %20 = xor i1 %19, true
  %21 = zext i1 %20 to i32
  %22 = sext i32 %21 to i64
  %23 = icmp ne i64 %22, 0
  br i1 %23, label %24, label %26

24:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.consumer, ptr noundef @.str.5, i32 noundef 76, ptr noundef @.str.6) #9
  unreachable

25:                                               ; No predecessors!
  br label %27

26:                                               ; preds = %18
  br label %27

27:                                               ; preds = %26, %25
  %28 = load ptr, ptr %3, align 8
  %29 = getelementptr inbounds %struct.point_s, ptr %28, i32 0, i32 0
  %30 = load i32, ptr %29, align 4
  %31 = load ptr, ptr %3, align 8
  %32 = getelementptr inbounds %struct.point_s, ptr %31, i32 0, i32 1
  %33 = load i32, ptr %32, align 4
  %34 = icmp eq i32 %30, %33
  %35 = xor i1 %34, true
  %36 = zext i1 %35 to i32
  %37 = sext i32 %36 to i64
  %38 = icmp ne i64 %37, 0
  br i1 %38, label %39, label %41

39:                                               ; preds = %27
  call void @__assert_rtn(ptr noundef @__func__.consumer, ptr noundef @.str.5, i32 noundef 77, ptr noundef @.str.7) #9
  unreachable

40:                                               ; No predecessors!
  br label %42

41:                                               ; preds = %27
  br label %42

42:                                               ; preds = %41, %40
  %43 = load ptr, ptr %3, align 8
  %44 = getelementptr inbounds %struct.point_s, ptr %43, i32 0, i32 1
  %45 = load i32, ptr %44, align 4
  %46 = icmp eq i32 %45, 1
  %47 = xor i1 %46, true
  %48 = zext i1 %47 to i32
  %49 = sext i32 %48 to i64
  %50 = icmp ne i64 %49, 0
  br i1 %50, label %51, label %53

51:                                               ; preds = %42
  call void @__assert_rtn(ptr noundef @__func__.consumer, ptr noundef @.str.5, i32 noundef 78, ptr noundef @.str.8) #9
  unreachable

52:                                               ; No predecessors!
  br label %54

53:                                               ; preds = %42
  br label %54

54:                                               ; preds = %53, %52
  %55 = load ptr, ptr %3, align 8
  %56 = getelementptr inbounds %struct.point_s, ptr %55, i32 0, i32 0
  %57 = load i32, ptr %56, align 4
  %58 = load ptr, ptr %3, align 8
  %59 = getelementptr inbounds %struct.point_s, ptr %58, i32 0, i32 1
  %60 = load i32, ptr %59, align 4
  %61 = call i32 (ptr, ...) @printf(ptr noundef @.str.9, i32 noundef %57, i32 noundef %60)
  %62 = load ptr, ptr %3, align 8
  call void @free(ptr noundef %62)
  br label %63

63:                                               ; preds = %54
  %64 = load i32, ptr %4, align 4
  %65 = add nsw i32 %64, 1
  store i32 %65, ptr %4, align 4
  br label %6, !llvm.loop !8

66:                                               ; preds = %6
  %67 = call i32 (ptr, ...) @printf(ptr noundef @.str.10)
  ret ptr null
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_fifo_spsc_dequeue(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca i1, align 1
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  %7 = load ptr, ptr %4, align 8
  %8 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %7, i32 0, i32 1
  %9 = load ptr, ptr %8, align 8
  %10 = getelementptr inbounds %struct.ck_fifo_spsc_entry, ptr %9, i32 0, i32 1
  %11 = call ptr @ck_pr_md_load_ptr(ptr noundef %10)
  store ptr %11, ptr %6, align 8
  %12 = load ptr, ptr %6, align 8
  %13 = icmp eq ptr %12, null
  br i1 %13, label %14, label %15

14:                                               ; preds = %2
  store i1 false, ptr %3, align 1
  br label %23

15:                                               ; preds = %2
  %16 = load ptr, ptr %5, align 8
  %17 = load ptr, ptr %6, align 8
  %18 = getelementptr inbounds %struct.ck_fifo_spsc_entry, ptr %17, i32 0, i32 0
  %19 = load ptr, ptr %18, align 8
  call void @ck_pr_md_store_ptr(ptr noundef %16, ptr noundef %19)
  call void @ck_pr_fence_store()
  %20 = load ptr, ptr %4, align 8
  %21 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %20, i32 0, i32 1
  %22 = load ptr, ptr %6, align 8
  call void @ck_pr_md_store_ptr(ptr noundef %21, ptr noundef %22)
  store i1 true, ptr %3, align 1
  br label %23

23:                                               ; preds = %15, %14
  %24 = load i1, ptr %3, align 1
  ret i1 %24
}

declare void @__VERIFIER_assume(i32 noundef) #4

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #5

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
  %6 = call ptr @malloc(i64 noundef 16) #6
  store ptr %6, ptr %3, align 8
  %7 = load ptr, ptr %3, align 8
  %8 = icmp eq ptr %7, null
  br i1 %8, label %9, label %12

9:                                                ; preds = %0
  %10 = load ptr, ptr @__stderrp, align 8
  %11 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %10, ptr noundef @.str.11) #7
  call void @exit(i32 noundef 1) #8
  unreachable

12:                                               ; preds = %0
  %13 = load ptr, ptr %3, align 8
  call void @ck_fifo_spsc_init(ptr noundef @queue, ptr noundef %13)
  %14 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 0
  %15 = call i32 @pthread_create(ptr noundef %14, ptr noundef null, ptr noundef @producer, ptr noundef null)
  %16 = icmp ne i32 %15, 0
  br i1 %16, label %21, label %17

17:                                               ; preds = %12
  %18 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 1
  %19 = call i32 @pthread_create(ptr noundef %18, ptr noundef null, ptr noundef @consumer, ptr noundef null)
  %20 = icmp ne i32 %19, 0
  br i1 %20, label %21, label %24

21:                                               ; preds = %17, %12
  %22 = load ptr, ptr @__stderrp, align 8
  %23 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %22, ptr noundef @.str.12) #7
  call void @exit(i32 noundef 1) #8
  unreachable

24:                                               ; preds = %17
  store i32 0, ptr %4, align 4
  br label %25

25:                                               ; preds = %34, %24
  %26 = load i32, ptr %4, align 4
  %27 = icmp slt i32 %26, 2
  br i1 %27, label %28, label %37

28:                                               ; preds = %25
  %29 = load i32, ptr %4, align 4
  %30 = sext i32 %29 to i64
  %31 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %30
  %32 = load ptr, ptr %31, align 8
  %33 = call i32 @"\01_pthread_join"(ptr noundef %32, ptr noundef null)
  br label %34

34:                                               ; preds = %28
  %35 = load i32, ptr %4, align 4
  %36 = add nsw i32 %35, 1
  store i32 %36, ptr %4, align 4
  br label %25, !llvm.loop !9

37:                                               ; preds = %25
  call void @ck_fifo_spsc_deinit(ptr noundef @queue, ptr noundef %5)
  %38 = load ptr, ptr %5, align 8
  call void @free(ptr noundef %38)
  ret i32 0
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_fifo_spsc_init(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8
  %6 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %5, i32 0, i32 0
  call void @ck_spinlock_fas_init(ptr noundef %6)
  %7 = load ptr, ptr %3, align 8
  %8 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %7, i32 0, i32 3
  call void @ck_spinlock_fas_init(ptr noundef %8)
  %9 = load ptr, ptr %4, align 8
  %10 = getelementptr inbounds %struct.ck_fifo_spsc_entry, ptr %9, i32 0, i32 1
  store ptr null, ptr %10, align 8
  %11 = load ptr, ptr %4, align 8
  %12 = load ptr, ptr %3, align 8
  %13 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %12, i32 0, i32 6
  store ptr %11, ptr %13, align 8
  %14 = load ptr, ptr %3, align 8
  %15 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %14, i32 0, i32 5
  store ptr %11, ptr %15, align 8
  %16 = load ptr, ptr %3, align 8
  %17 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %16, i32 0, i32 4
  store ptr %11, ptr %17, align 8
  %18 = load ptr, ptr %3, align 8
  %19 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %18, i32 0, i32 1
  store ptr %11, ptr %19, align 8
  ret void
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #4

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #4

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_fifo_spsc_deinit(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8
  %6 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %5, i32 0, i32 6
  %7 = load ptr, ptr %6, align 8
  %8 = load ptr, ptr %4, align 8
  store ptr %7, ptr %8, align 8
  %9 = load ptr, ptr %3, align 8
  %10 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %9, i32 0, i32 4
  store ptr null, ptr %10, align 8
  %11 = load ptr, ptr %3, align 8
  %12 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %11, i32 0, i32 1
  store ptr null, ptr %12, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_store() #0 {
  call void @ck_pr_fence_strict_store()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_md_store_ptr(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8
  %6 = load ptr, ptr %4, align 8
  call void asm sideeffect "sd $1, 0($0)", "r,r,~{memory}"(ptr %5, ptr %6) #7, !srcloc !10
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_store() #0 {
  call void asm sideeffect "fence w,w", "~{memory}"() #7, !srcloc !11
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  store i64 0, ptr %3, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = call i64 asm sideeffect "ld $0, 0($1)\0A", "=r,r,~{memory}"(ptr %4) #7, !srcloc !12
  store i64 %5, ptr %3, align 8
  %6 = load i64, ptr %3, align 8
  %7 = inttoptr i64 %6 to ptr
  ret ptr %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_fas_init(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct.ck_spinlock_fas, ptr %3, i32 0, i32 0
  store i32 0, ptr %4, align 4
  call void @ck_pr_barrier()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_barrier() #0 {
  call void asm sideeffect "", "~{memory}"() #7, !srcloc !13
  ret void
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #4 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #5 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #6 = { allocsize(0) }
attributes #7 = { nounwind }
attributes #8 = { noreturn }
attributes #9 = { cold noreturn }

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
!10 = !{i64 2148734098}
!11 = !{i64 2148724211}
!12 = !{i64 2148727253}
!13 = !{i64 1336210}
