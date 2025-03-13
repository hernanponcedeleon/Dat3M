; ModuleID = 'tests/spsc_queue.c'
source_filename = "tests/spsc_queue.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_fifo_spsc = type { %struct.ck_spinlock_fas, ptr, [52 x i8], %struct.ck_spinlock_fas, ptr, ptr, ptr }
%struct.ck_spinlock_fas = type { i32 }
%struct.point_s = type { i32, i32 }
%struct.ck_fifo_spsc_entry = type { ptr, ptr }

@queue = global %struct.ck_fifo_spsc zeroinitializer, align 8
@.str = private unnamed_addr constant [20 x i8] c"NULL point received\00", align 1
@__func__.consumer = private unnamed_addr constant [9 x i8] c"consumer\00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"spsc_queue.c\00", align 1
@.str.2 = private unnamed_addr constant [39 x i8] c"point != NULL && \22NULL point received\22\00", align 1
@.str.3 = private unnamed_addr constant [21 x i8] c"point->x == point->y\00", align 1
@.str.4 = private unnamed_addr constant [14 x i8] c"point->y == 1\00", align 1

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

7:                                                ; preds = %28, %1
  %8 = load i32, ptr %3, align 4
  %9 = icmp slt i32 %8, 3
  br i1 %9, label %10, label %31

10:                                               ; preds = %7
  %11 = call ptr @malloc(i64 noundef 8) #5
  store ptr %11, ptr %4, align 8
  %12 = load ptr, ptr %4, align 8
  %13 = icmp eq ptr %12, null
  br i1 %13, label %14, label %15

14:                                               ; preds = %10
  call void @exit(i32 noundef 1) #6
  unreachable

15:                                               ; preds = %10
  %16 = load ptr, ptr %4, align 8
  %17 = getelementptr inbounds %struct.point_s, ptr %16, i32 0, i32 0
  store i32 1, ptr %17, align 4
  %18 = load ptr, ptr %4, align 8
  %19 = getelementptr inbounds %struct.point_s, ptr %18, i32 0, i32 1
  store i32 1, ptr %19, align 4
  %20 = call ptr @malloc(i64 noundef 16) #5
  store ptr %20, ptr %5, align 8
  %21 = load ptr, ptr %5, align 8
  %22 = icmp eq ptr %21, null
  br i1 %22, label %23, label %25

23:                                               ; preds = %15
  %24 = load ptr, ptr %4, align 8
  call void @free(ptr noundef %24)
  call void @exit(i32 noundef 1) #6
  unreachable

25:                                               ; preds = %15
  %26 = load ptr, ptr %5, align 8
  %27 = load ptr, ptr %4, align 8
  call void @ck_fifo_spsc_enqueue(ptr noundef @queue, ptr noundef %26, ptr noundef %27)
  br label %28

28:                                               ; preds = %25
  %29 = load i32, ptr %3, align 4
  %30 = add nsw i32 %29, 1
  store i32 %30, ptr %3, align 4
  br label %7, !llvm.loop !6

31:                                               ; preds = %7
  %32 = call ptr @malloc(i64 noundef 16) #5
  store ptr %32, ptr %6, align 8
  %33 = load ptr, ptr %6, align 8
  %34 = icmp eq ptr %33, null
  br i1 %34, label %35, label %36

35:                                               ; preds = %31
  call void @exit(i32 noundef 1) #6
  unreachable

36:                                               ; preds = %31
  %37 = load ptr, ptr %6, align 8
  call void @ck_fifo_spsc_enqueue(ptr noundef @queue, ptr noundef %37, ptr noundef null)
  ret ptr null
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #2

declare void @free(ptr noundef) #3

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

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @consumer(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  store i32 0, ptr %4, align 4
  br label %6

6:                                                ; preds = %56, %1
  %7 = load i32, ptr %4, align 4
  %8 = icmp slt i32 %7, 3
  br i1 %8, label %9, label %59

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
  call void @__assert_rtn(ptr noundef @__func__.consumer, ptr noundef @.str.1, i32 noundef 63, ptr noundef @.str.2) #7
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
  call void @__assert_rtn(ptr noundef @__func__.consumer, ptr noundef @.str.1, i32 noundef 64, ptr noundef @.str.3) #7
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
  call void @__assert_rtn(ptr noundef @__func__.consumer, ptr noundef @.str.1, i32 noundef 65, ptr noundef @.str.4) #7
  unreachable

52:                                               ; No predecessors!
  br label %54

53:                                               ; preds = %42
  br label %54

54:                                               ; preds = %53, %52
  %55 = load ptr, ptr %3, align 8
  call void @free(ptr noundef %55)
  br label %56

56:                                               ; preds = %54
  %57 = load i32, ptr %4, align 4
  %58 = add nsw i32 %57, 1
  store i32 %58, ptr %4, align 4
  br label %6, !llvm.loop !8

59:                                               ; preds = %6
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

declare void @__VERIFIER_assume(i32 noundef) #3

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
  %6 = call ptr @malloc(i64 noundef 16) #5
  store ptr %6, ptr %3, align 8
  %7 = load ptr, ptr %3, align 8
  %8 = icmp eq ptr %7, null
  br i1 %8, label %9, label %10

9:                                                ; preds = %0
  call void @exit(i32 noundef 1) #6
  unreachable

10:                                               ; preds = %0
  %11 = load ptr, ptr %3, align 8
  call void @ck_fifo_spsc_init(ptr noundef @queue, ptr noundef %11)
  %12 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 0
  %13 = call i32 @pthread_create(ptr noundef %12, ptr noundef null, ptr noundef @producer, ptr noundef null)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %19, label %15

15:                                               ; preds = %10
  %16 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 1
  %17 = call i32 @pthread_create(ptr noundef %16, ptr noundef null, ptr noundef @consumer, ptr noundef null)
  %18 = icmp ne i32 %17, 0
  br i1 %18, label %19, label %20

19:                                               ; preds = %15, %10
  call void @exit(i32 noundef 1) #6
  unreachable

20:                                               ; preds = %15
  store i32 0, ptr %4, align 4
  br label %21

21:                                               ; preds = %30, %20
  %22 = load i32, ptr %4, align 4
  %23 = icmp slt i32 %22, 2
  br i1 %23, label %24, label %33

24:                                               ; preds = %21
  %25 = load i32, ptr %4, align 4
  %26 = sext i32 %25 to i64
  %27 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %26
  %28 = load ptr, ptr %27, align 8
  %29 = call i32 @"\01_pthread_join"(ptr noundef %28, ptr noundef null)
  br label %30

30:                                               ; preds = %24
  %31 = load i32, ptr %4, align 4
  %32 = add nsw i32 %31, 1
  store i32 %32, ptr %4, align 4
  br label %21, !llvm.loop !9

33:                                               ; preds = %21
  call void @ck_fifo_spsc_deinit(ptr noundef @queue, ptr noundef %5)
  %34 = load ptr, ptr %5, align 8
  call void @free(ptr noundef %34)
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

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #3

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
  call void asm sideeffect "str $1, [$0]", "r,r,~{memory}"(ptr %5, ptr %6) #8, !srcloc !10
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_store() #0 {
  call void asm sideeffect "dmb st", "r,~{memory}"(i32 0) #8, !srcloc !11
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  store i64 0, ptr %3, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = call i64 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #8, !srcloc !12
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
  call void asm sideeffect "", "~{memory}"() #8, !srcloc !13
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
!10 = !{i64 2148685959}
!11 = !{i64 2148676191}
!12 = !{i64 2148678871}
!13 = !{i64 1339196}
