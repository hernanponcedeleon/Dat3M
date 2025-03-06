; ModuleID = 'tests/declock.c'
source_filename = "tests/declock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_spinlock_dec = type { i32 }

@x = global i32 0, align 4
@y = global i32 0, align 4
@lock = global %struct.ck_spinlock_dec zeroinitializer, align 4
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"declock.c\00", align 1
@.str.1 = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1
@nodes = global ptr null, align 8

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
  %8 = icmp eq i64 %7, 1
  br i1 %8, label %9, label %15

9:                                                ; preds = %1
  %10 = call zeroext i1 @ck_spinlock_dec_trylock(ptr noundef @lock)
  %11 = zext i1 %10 to i8
  store i8 %11, ptr %4, align 1
  %12 = load i8, ptr %4, align 1
  %13 = trunc i8 %12 to i1
  %14 = zext i1 %13 to i32
  call void @__VERIFIER_assume(i32 noundef %14)
  br label %16

15:                                               ; preds = %1
  call void @ck_spinlock_dec_lock(ptr noundef @lock)
  br label %16

16:                                               ; preds = %15, %9
  %17 = load i32, ptr @x, align 4
  %18 = add nsw i32 %17, 1
  store i32 %18, ptr @x, align 4
  %19 = load i32, ptr @y, align 4
  %20 = add nsw i32 %19, 1
  store i32 %20, ptr @y, align 4
  call void @ck_spinlock_dec_unlock(ptr noundef @lock)
  ret ptr null
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_spinlock_dec_trylock(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.ck_spinlock_dec, ptr %4, i32 0, i32 0
  %6 = call i32 @ck_pr_fas_uint(ptr noundef %5, i32 noundef 0)
  store i32 %6, ptr %3, align 4
  call void @ck_pr_fence_lock()
  %7 = load i32, ptr %3, align 4
  %8 = icmp eq i32 %7, 1
  ret i1 %8
}

declare void @__VERIFIER_assume(i32 noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_dec_lock(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  br label %4

4:                                                ; preds = %19, %1
  %5 = load ptr, ptr %2, align 8
  %6 = getelementptr inbounds %struct.ck_spinlock_dec, ptr %5, i32 0, i32 0
  call void @ck_pr_dec_uint_zero(ptr noundef %6, ptr noundef %3)
  %7 = load i8, ptr %3, align 1
  %8 = trunc i8 %7 to i1
  %9 = zext i1 %8 to i32
  %10 = icmp eq i32 %9, 1
  br i1 %10, label %11, label %12

11:                                               ; preds = %4
  br label %20

12:                                               ; preds = %4
  br label %13

13:                                               ; preds = %18, %12
  %14 = load ptr, ptr %2, align 8
  %15 = getelementptr inbounds %struct.ck_spinlock_dec, ptr %14, i32 0, i32 0
  %16 = call i32 @ck_pr_md_load_uint(ptr noundef %15)
  %17 = icmp ne i32 %16, 1
  br i1 %17, label %18, label %19

18:                                               ; preds = %13
  call void @ck_pr_stall()
  br label %13, !llvm.loop !6

19:                                               ; preds = %13
  br label %4

20:                                               ; preds = %11
  call void @ck_pr_fence_lock()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_dec_unlock(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @ck_pr_fence_unlock()
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct.ck_spinlock_dec, ptr %3, i32 0, i32 0
  call void @ck_pr_md_store_uint(ptr noundef %4, i32 noundef 1)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @ck_spinlock_dec_init(ptr noundef @lock)
  store i32 0, ptr %3, align 4
  br label %4

4:                                                ; preds = %18, %0
  %5 = load i32, ptr %3, align 4
  %6 = icmp slt i32 %5, 2
  br i1 %6, label %7, label %21

7:                                                ; preds = %4
  %8 = load i32, ptr %3, align 4
  %9 = sext i32 %8 to i64
  %10 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %9
  %11 = load i32, ptr %3, align 4
  %12 = sext i32 %11 to i64
  %13 = inttoptr i64 %12 to ptr
  %14 = call i32 @pthread_create(ptr noundef %10, ptr noundef null, ptr noundef @run, ptr noundef %13)
  %15 = icmp ne i32 %14, 0
  br i1 %15, label %16, label %17

16:                                               ; preds = %7
  call void @exit(i32 noundef 1) #4
  unreachable

17:                                               ; preds = %7
  br label %18

18:                                               ; preds = %17
  %19 = load i32, ptr %3, align 4
  %20 = add nsw i32 %19, 1
  store i32 %20, ptr %3, align 4
  br label %4, !llvm.loop !8

21:                                               ; preds = %4
  store i32 0, ptr %3, align 4
  br label %22

22:                                               ; preds = %34, %21
  %23 = load i32, ptr %3, align 4
  %24 = icmp slt i32 %23, 2
  br i1 %24, label %25, label %37

25:                                               ; preds = %22
  %26 = load i32, ptr %3, align 4
  %27 = sext i32 %26 to i64
  %28 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %27
  %29 = load ptr, ptr %28, align 8
  %30 = call i32 @"\01_pthread_join"(ptr noundef %29, ptr noundef null)
  %31 = icmp ne i32 %30, 0
  br i1 %31, label %32, label %33

32:                                               ; preds = %25
  call void @exit(i32 noundef 1) #4
  unreachable

33:                                               ; preds = %25
  br label %34

34:                                               ; preds = %33
  %35 = load i32, ptr %3, align 4
  %36 = add nsw i32 %35, 1
  store i32 %36, ptr %3, align 4
  br label %22, !llvm.loop !9

37:                                               ; preds = %22
  %38 = load i32, ptr @x, align 4
  %39 = icmp eq i32 %38, 2
  br i1 %39, label %40, label %43

40:                                               ; preds = %37
  %41 = load i32, ptr @y, align 4
  %42 = icmp eq i32 %41, 2
  br label %43

43:                                               ; preds = %40, %37
  %44 = phi i1 [ false, %37 ], [ %42, %40 ]
  %45 = xor i1 %44, true
  %46 = zext i1 %45 to i32
  %47 = sext i32 %46 to i64
  %48 = icmp ne i64 %47, 0
  br i1 %48, label %49, label %51

49:                                               ; preds = %43
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 59, ptr noundef @.str.1) #5
  unreachable

50:                                               ; No predecessors!
  br label %52

51:                                               ; preds = %43
  br label %52

52:                                               ; preds = %51, %50
  ret i32 0
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_dec_init(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct.ck_spinlock_dec, ptr %3, i32 0, i32 0
  store i32 1, ptr %4, align 4
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
  %9 = call { i32, i32 } asm sideeffect "1:ldxr ${0:w}, [$2]\0Astxr ${1:w}, ${3:w}, [$2]\0Acbnz ${1:w}, 1b\0A", "=&r,=&r,r,r,~{memory},~{cc}"(ptr %7, i32 %8) #6, !srcloc !10
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
  call void asm sideeffect "dmb ish", "r,~{memory}"(i32 0) #6, !srcloc !11
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_dec_uint_zero(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8
  %6 = call zeroext i1 @ck_pr_dec_uint_is_zero(ptr noundef %5)
  %7 = load ptr, ptr %4, align 8
  %8 = zext i1 %6 to i8
  store i8 %8, ptr %7, align 1
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_md_load_uint(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  store i64 0, ptr %3, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = call i64 asm sideeffect "ldr ${0:w}, [$1]\0A", "=r,r,~{memory}"(ptr %4) #6, !srcloc !12
  store i64 %5, ptr %3, align 8
  %6 = load i64, ptr %3, align 8
  %7 = trunc i64 %6 to i32
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_stall() #0 {
  call void asm sideeffect "", "~{memory}"() #6, !srcloc !13
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_pr_dec_uint_is_zero(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8
  %6 = call i32 @ck_pr_md_load_uint(ptr noundef %5)
  store i32 %6, ptr %4, align 4
  %7 = load i32, ptr %4, align 4
  store i32 %7, ptr %3, align 4
  br label %8

8:                                                ; preds = %16, %1
  %9 = load ptr, ptr %2, align 8
  %10 = load i32, ptr %3, align 4
  %11 = load i32, ptr %3, align 4
  %12 = sub i32 %11, 1
  %13 = call zeroext i1 @ck_pr_cas_uint_value(ptr noundef %9, i32 noundef %10, i32 noundef %12, ptr noundef %3)
  %14 = zext i1 %13 to i32
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %16, label %17

16:                                               ; preds = %8
  call void @ck_pr_stall()
  br label %8, !llvm.loop !14

17:                                               ; preds = %8
  %18 = load i32, ptr %3, align 4
  %19 = icmp eq i32 %18, 1
  ret i1 %19
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
  %14 = call { i32, i32 } asm sideeffect "1:\0Aldxr ${0:w}, [$2]\0Acmp  ${0:w}, ${4:w}\0Ab.ne 2f\0Astxr ${1:w}, ${3:w}, [$2]\0Acbnz ${1:w}, 1b\0A2:", "=&r,=&r,r,r,r,~{memory},~{cc}"(ptr %11, i32 %12, i32 %13) #6, !srcloc !15
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
!10 = !{i64 2147808477, i64 2147808590, i64 2147808661}
!11 = !{i64 2147760818}
!12 = !{i64 2147763304}
!13 = !{i64 264406}
!14 = distinct !{!14, !7}
!15 = !{i64 2147791790, i64 2147791840, i64 2147791907, i64 2147791973, i64 2147792026, i64 2147792098, i64 2147792156}
!16 = !{i64 2147766991}
!17 = !{i64 2147761083}
!18 = !{i64 418252}
