; ModuleID = 'tests/caslock.c'
source_filename = "tests/caslock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_spinlock_cas = type { i32 }

@x = global i32 0, align 4
@y = global i32 0, align 4
@lock = global %struct.ck_spinlock_cas zeroinitializer, align 4
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"caslock.c\00", align 1
@.str.1 = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8
  %6 = ptrtoint ptr %5 to i64
  store i64 %6, ptr %3, align 8
  %7 = load i64, ptr %3, align 8
  %8 = icmp eq i64 %7, 2
  br i1 %8, label %9, label %15

9:                                                ; preds = %1
  %10 = call zeroext i1 @ck_spinlock_cas_trylock(ptr noundef @lock)
  %11 = zext i1 %10 to i8
  store i8 %11, ptr %4, align 1
  %12 = load i8, ptr %4, align 1
  %13 = trunc i8 %12 to i1
  %14 = zext i1 %13 to i32
  call void @__VERIFIER_assume(i32 noundef %14)
  br label %16

15:                                               ; preds = %1
  call void @ck_spinlock_cas_lock(ptr noundef @lock)
  br label %16

16:                                               ; preds = %15, %9
  %17 = load i32, ptr @x, align 4
  %18 = add nsw i32 %17, 1
  store i32 %18, ptr @x, align 4
  %19 = load i32, ptr @y, align 4
  %20 = add nsw i32 %19, 1
  store i32 %20, ptr @y, align 4
  call void @ck_spinlock_cas_unlock(ptr noundef @lock)
  ret ptr null
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_spinlock_cas_trylock(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.ck_spinlock_cas, ptr %4, i32 0, i32 0
  %6 = call i32 @ck_pr_fas_uint(ptr noundef %5, i32 noundef 1)
  store i32 %6, ptr %3, align 4
  call void @ck_pr_fence_lock()
  %7 = load i32, ptr %3, align 4
  %8 = icmp ne i32 %7, 0
  %9 = xor i1 %8, true
  ret i1 %9
}

declare void @__VERIFIER_assume(i32 noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_cas_lock(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  br label %3

3:                                                ; preds = %16, %1
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.ck_spinlock_cas, ptr %4, i32 0, i32 0
  %6 = call zeroext i1 @ck_pr_cas_uint(ptr noundef %5, i32 noundef 0, i32 noundef 1)
  %7 = zext i1 %6 to i32
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %17

9:                                                ; preds = %3
  br label %10

10:                                               ; preds = %15, %9
  %11 = load ptr, ptr %2, align 8
  %12 = getelementptr inbounds %struct.ck_spinlock_cas, ptr %11, i32 0, i32 0
  %13 = call i32 @ck_pr_md_load_uint(ptr noundef %12)
  %14 = icmp eq i32 %13, 1
  br i1 %14, label %15, label %16

15:                                               ; preds = %10
  call void @ck_pr_stall()
  br label %10, !llvm.loop !6

16:                                               ; preds = %10
  br label %3, !llvm.loop !8

17:                                               ; preds = %3
  call void @ck_pr_fence_lock()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_cas_unlock(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @ck_pr_fence_unlock()
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct.ck_spinlock_cas, ptr %3, i32 0, i32 0
  call void @ck_pr_md_store_uint(ptr noundef %4, i32 noundef 0)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca [3 x i32], align 4
  %4 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @ck_spinlock_cas_init(ptr noundef @lock)
  store i32 0, ptr %4, align 4
  br label %5

5:                                                ; preds = %19, %0
  %6 = load i32, ptr %4, align 4
  %7 = icmp slt i32 %6, 3
  br i1 %7, label %8, label %22

8:                                                ; preds = %5
  %9 = load i32, ptr %4, align 4
  %10 = sext i32 %9 to i64
  %11 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %10
  %12 = load i32, ptr %4, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds [3 x i32], ptr %3, i64 0, i64 %13
  %15 = call i32 @pthread_create(ptr noundef %11, ptr noundef null, ptr noundef @run, ptr noundef %14)
  %16 = icmp ne i32 %15, 0
  br i1 %16, label %17, label %18

17:                                               ; preds = %8
  call void @exit(i32 noundef 1) #4
  unreachable

18:                                               ; preds = %8
  br label %19

19:                                               ; preds = %18
  %20 = load i32, ptr %4, align 4
  %21 = add nsw i32 %20, 1
  store i32 %21, ptr %4, align 4
  br label %5, !llvm.loop !9

22:                                               ; preds = %5
  store i32 0, ptr %4, align 4
  br label %23

23:                                               ; preds = %35, %22
  %24 = load i32, ptr %4, align 4
  %25 = icmp slt i32 %24, 3
  br i1 %25, label %26, label %38

26:                                               ; preds = %23
  %27 = load i32, ptr %4, align 4
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %28
  %30 = load ptr, ptr %29, align 8
  %31 = call i32 @"\01_pthread_join"(ptr noundef %30, ptr noundef null)
  %32 = icmp ne i32 %31, 0
  br i1 %32, label %33, label %34

33:                                               ; preds = %26
  call void @exit(i32 noundef 1) #4
  unreachable

34:                                               ; preds = %26
  br label %35

35:                                               ; preds = %34
  %36 = load i32, ptr %4, align 4
  %37 = add nsw i32 %36, 1
  store i32 %37, ptr %4, align 4
  br label %23, !llvm.loop !10

38:                                               ; preds = %23
  %39 = load i32, ptr @x, align 4
  %40 = icmp eq i32 %39, 3
  br i1 %40, label %41, label %44

41:                                               ; preds = %38
  %42 = load i32, ptr @y, align 4
  %43 = icmp eq i32 %42, 3
  br label %44

44:                                               ; preds = %41, %38
  %45 = phi i1 [ false, %38 ], [ %43, %41 ]
  %46 = xor i1 %45, true
  %47 = zext i1 %46 to i32
  %48 = sext i32 %47 to i64
  %49 = icmp ne i64 %48, 0
  br i1 %49, label %50, label %52

49:                                               ; preds = %43
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 59, ptr noundef @.str.1) #5
  unreachable

51:                                               ; No predecessors!
  br label %53

52:                                               ; preds = %44
  br label %53

52:                                               ; preds = %51, %50
  ret i32 0
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_cas_init(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct.ck_spinlock_cas, ptr %3, i32 0, i32 0
  store i32 0, ptr %4, align 4
  call void @ck_pr_barrier()
  ret void
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #2

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_fas_uint(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %7 = load ptr, ptr %3, align 8
  %8 = load i32, ptr %4, align 4
  %9 = call { i32, i32 } asm sideeffect "1:ldxr ${0:w}, [$2]\0Astxr ${1:w}, ${3:w}, [$2]\0Acbnz ${1:w}, 1b\0A", "=&r,=&r,r,r,~{memory},~{cc}"(ptr %7, i32 %8) #6, !srcloc !11
  %10 = extractvalue { i32, i32 } %9, 0
  %11 = extractvalue { i32, i32 } %9, 1
  store i32 %10, ptr %5, align 4
  store i32 %11, ptr %6, align 4
  %12 = load i32, ptr %5, align 4
  ret i32 %12
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_lock() #0 {
  call void @ck_pr_fence_strict_lock()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_lock() #0 {
  call void asm sideeffect "dmb ish", "r,~{memory}"(i32 0) #6, !srcloc !12
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_pr_cas_uint(ptr noundef %0, i32 noundef %1, i32 noundef %2) #0 {
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
  %11 = load i32, ptr %5, align 4
  %12 = call { i32, i32 } asm sideeffect "1:ldxr ${0:w}, [$2]\0Acmp  ${0:w}, ${4:w}\0Ab.ne 2f\0Astxr ${1:w}, ${3:w}, [$2]\0Acbnz ${1:w}, 1b\0A2:", "=&r,=&r,r,r,r,~{memory},~{cc}"(ptr %9, i32 %10, i32 %11) #6, !srcloc !13
  %13 = extractvalue { i32, i32 } %12, 0
  %14 = extractvalue { i32, i32 } %12, 1
  store i32 %13, ptr %7, align 4
  store i32 %14, ptr %8, align 4
  %15 = load i32, ptr %7, align 4
  %16 = load i32, ptr %5, align 4
  %17 = icmp eq i32 %15, %16
  ret i1 %17
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_md_load_uint(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  store i64 0, ptr %3, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = call i64 asm sideeffect "ldr ${0:w}, [$1]\0A", "=r,r,~{memory}"(ptr %4) #6, !srcloc !14
  store i64 %5, ptr %3, align 8
  %6 = load i64, ptr %3, align 8
  %7 = trunc i64 %6 to i32
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_stall() #0 {
  call void asm sideeffect "", "~{memory}"() #6, !srcloc !15
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_unlock() #0 {
  call void @ck_pr_fence_strict_unlock()
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
  call void asm sideeffect "str ${2:w}, [$1]", "=*m,r,r,~{memory}"(ptr elementtype(i32) %5, ptr %6, i32 %7) #6, !srcloc !16
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_unlock() #0 {
  call void asm sideeffect "dmb ish", "r,~{memory}"(i32 0) #6, !srcloc !17
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_barrier() #0 {
  call void asm sideeffect "", "~{memory}"() #6, !srcloc !18
  ret void
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #4 = { noreturn }
attributes #5 = { cold noreturn }
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
!11 = !{i64 2147808633, i64 2147808746, i64 2147808817}
!12 = !{i64 2147760974}
!13 = !{i64 2147792952, i64 2147793067, i64 2147793133, i64 2147793186, i64 2147793258, i64 2147793316}
!14 = !{i64 2147763460}
!15 = !{i64 264562}
!16 = !{i64 2147767147}
!17 = !{i64 2147761239}
!18 = !{i64 418408}
