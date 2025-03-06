; ModuleID = 'tests/mcslock.c'
source_filename = "tests/mcslock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_spinlock_mcs = type { i32, ptr }

@lock = global ptr null, align 8
@x = global i32 0, align 4
@y = global i32 0, align 4
@nodes = global ptr null, align 8
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"mcslock.c\00", align 1
@.str.1 = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8
  %6 = ptrtoint ptr %5 to i64
  store i64 %6, ptr %3, align 8
  %7 = load ptr, ptr @nodes, align 8
  %8 = load i64, ptr %3, align 8
  %9 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %7, i64 %8
  store ptr %9, ptr %4, align 8
  %10 = load ptr, ptr %4, align 8
  call void @ck_spinlock_mcs_lock(ptr noundef @lock, ptr noundef %10)
  %11 = load i32, ptr @x, align 4
  %12 = add nsw i32 %11, 1
  store i32 %12, ptr @x, align 4
  %13 = load i32, ptr @y, align 4
  %14 = add nsw i32 %13, 1
  store i32 %14, ptr @y, align 4
  %15 = load ptr, ptr %4, align 8
  call void @ck_spinlock_mcs_unlock(ptr noundef @lock, ptr noundef %15)
  ret ptr null
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_mcs_lock(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load ptr, ptr %4, align 8
  %7 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %6, i32 0, i32 0
  store i32 1, ptr %7, align 8
  %8 = load ptr, ptr %4, align 8
  %9 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %8, i32 0, i32 1
  store ptr null, ptr %9, align 8
  call void @ck_pr_fence_store_atomic()
  %10 = load ptr, ptr %3, align 8
  %11 = load ptr, ptr %4, align 8
  %12 = call ptr @ck_pr_fas_ptr(ptr noundef %10, ptr noundef %11)
  store ptr %12, ptr %5, align 8
  %13 = load ptr, ptr %5, align 8
  %14 = icmp ne ptr %13, null
  br i1 %14, label %15, label %26

15:                                               ; preds = %2
  %16 = load ptr, ptr %5, align 8
  %17 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %16, i32 0, i32 1
  %18 = load ptr, ptr %4, align 8
  call void @ck_pr_md_store_ptr(ptr noundef %17, ptr noundef %18)
  br label %19

19:                                               ; preds = %24, %15
  %20 = load ptr, ptr %4, align 8
  %21 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %20, i32 0, i32 0
  %22 = call i32 @ck_pr_md_load_uint(ptr noundef %21)
  %23 = icmp eq i32 %22, 1
  br i1 %23, label %24, label %25

24:                                               ; preds = %19
  call void @ck_pr_stall()
  br label %19, !llvm.loop !6

25:                                               ; preds = %19
  br label %26

26:                                               ; preds = %25, %2
  call void @ck_pr_fence_lock()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_mcs_unlock(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  call void @ck_pr_fence_unlock()
  %6 = load ptr, ptr %4, align 8
  %7 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %6, i32 0, i32 1
  %8 = call ptr @ck_pr_md_load_ptr(ptr noundef %7)
  store ptr %8, ptr %5, align 8
  %9 = load ptr, ptr %5, align 8
  %10 = icmp eq ptr %9, null
  br i1 %10, label %11, label %33

11:                                               ; preds = %2
  %12 = load ptr, ptr %3, align 8
  %13 = call ptr @ck_pr_md_load_ptr(ptr noundef %12)
  %14 = load ptr, ptr %4, align 8
  %15 = icmp eq ptr %13, %14
  br i1 %15, label %16, label %23

16:                                               ; preds = %11
  %17 = load ptr, ptr %3, align 8
  %18 = load ptr, ptr %4, align 8
  %19 = call zeroext i1 @ck_pr_cas_ptr(ptr noundef %17, ptr noundef %18, ptr noundef null)
  %20 = zext i1 %19 to i32
  %21 = icmp eq i32 %20, 1
  br i1 %21, label %22, label %23

22:                                               ; preds = %16
  br label %36

23:                                               ; preds = %16, %11
  br label %24

24:                                               ; preds = %31, %23
  %25 = load ptr, ptr %4, align 8
  %26 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %25, i32 0, i32 1
  %27 = call ptr @ck_pr_md_load_ptr(ptr noundef %26)
  store ptr %27, ptr %5, align 8
  %28 = load ptr, ptr %5, align 8
  %29 = icmp ne ptr %28, null
  br i1 %29, label %30, label %31

30:                                               ; preds = %24
  br label %32

31:                                               ; preds = %24
  call void @ck_pr_stall()
  br label %24

32:                                               ; preds = %30
  br label %33

33:                                               ; preds = %32, %2
  %34 = load ptr, ptr %5, align 8
  %35 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %34, i32 0, i32 0
  call void @ck_pr_md_store_uint(ptr noundef %35, i32 noundef 0)
  br label %36

36:                                               ; preds = %33, %22
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 8
  %3 = alloca [2 x i64], align 8
  %4 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  %5 = call ptr @malloc(i64 noundef 16) #5
  store ptr %5, ptr @nodes, align 8
  %6 = load ptr, ptr @nodes, align 8
  %7 = icmp eq ptr %6, null
  br i1 %7, label %8, label %9

8:                                                ; preds = %0
  call void @exit(i32 noundef 1) #6
  unreachable

9:                                                ; preds = %0
  store ptr null, ptr @lock, align 8
  store i64 0, ptr %4, align 8
  br label %10

10:                                               ; preds = %23, %9
  %11 = load i64, ptr %4, align 8
  %12 = icmp slt i64 %11, 2
  br i1 %12, label %13, label %26

13:                                               ; preds = %10
  %14 = load i64, ptr %4, align 8
  %15 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %14
  %16 = load i64, ptr %4, align 8
  %17 = getelementptr inbounds [2 x i64], ptr %3, i64 0, i64 %16
  %18 = call i32 @pthread_create(ptr noundef %15, ptr noundef null, ptr noundef @run, ptr noundef %17)
  %19 = icmp ne i32 %18, 0
  br i1 %19, label %20, label %22

20:                                               ; preds = %13
  %21 = load ptr, ptr @nodes, align 8
  call void @free(ptr noundef %21)
  call void @exit(i32 noundef 1) #6
  unreachable

22:                                               ; preds = %13
  br label %23

23:                                               ; preds = %22
  %24 = load i64, ptr %4, align 8
  %25 = add nsw i64 %24, 1
  store i64 %25, ptr %4, align 8
  br label %10, !llvm.loop !8

26:                                               ; preds = %10
  store i64 0, ptr %4, align 8
  br label %27

27:                                               ; preds = %39, %26
  %28 = load i64, ptr %4, align 8
  %29 = icmp slt i64 %28, 2
  br i1 %29, label %30, label %42

30:                                               ; preds = %27
  %31 = load i64, ptr %4, align 8
  %32 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %31
  %33 = load ptr, ptr %32, align 8
  %34 = call i32 @"\01_pthread_join"(ptr noundef %33, ptr noundef null)
  %35 = icmp ne i32 %34, 0
  br i1 %35, label %36, label %38

36:                                               ; preds = %30
  %37 = load ptr, ptr @nodes, align 8
  call void @free(ptr noundef %37)
  call void @exit(i32 noundef 1) #6
  unreachable

38:                                               ; preds = %30
  br label %39

39:                                               ; preds = %38
  %40 = load i64, ptr %4, align 8
  %41 = add nsw i64 %40, 1
  store i64 %41, ptr %4, align 8
  br label %27, !llvm.loop !9

42:                                               ; preds = %27
  %43 = load i32, ptr @x, align 4
  %44 = icmp eq i32 %43, 2
  br i1 %44, label %45, label %48

45:                                               ; preds = %42
  %46 = load i32, ptr @y, align 4
  %47 = icmp eq i32 %46, 2
  br label %48

48:                                               ; preds = %45, %42
  %49 = phi i1 [ false, %42 ], [ %47, %45 ]
  %50 = xor i1 %49, true
  %51 = zext i1 %50 to i32
  %52 = sext i32 %51 to i64
  %53 = icmp ne i64 %52, 0
  br i1 %53, label %54, label %56

54:                                               ; preds = %48
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 63, ptr noundef @.str.1) #7
  unreachable

55:                                               ; No predecessors!
  br label %57

56:                                               ; preds = %48
  br label %57

57:                                               ; preds = %56, %55
  %58 = load ptr, ptr @nodes, align 8
  call void @free(ptr noundef %58)
  ret i32 0
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #2

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare void @free(ptr noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #3

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_store_atomic() #0 {
  call void @ck_pr_fence_strict_store_atomic()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_pr_fas_ptr(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %7 = load ptr, ptr %3, align 8
  %8 = load ptr, ptr %4, align 8
  %9 = call { ptr, ptr } asm sideeffect "1:ldxr $0, [$2]\0Astxr ${1:w}, $3, [$2]\0Acbnz ${1:w}, 1b\0A", "=&r,=&r,r,r,~{memory},~{cc}"(ptr %7, ptr %8) #8, !srcloc !10
  %10 = extractvalue { ptr, ptr } %9, 0
  %11 = extractvalue { ptr, ptr } %9, 1
  store ptr %10, ptr %5, align 8
  store ptr %11, ptr %6, align 8
  %12 = load ptr, ptr %5, align 8
  ret ptr %12
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_md_store_ptr(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8
  %6 = load ptr, ptr %3, align 8
  %7 = load ptr, ptr %4, align 8
  call void asm sideeffect "str $2, [$1]", "=*m,r,r,~{memory}"(ptr elementtype(ptr) %5, ptr %6, ptr %7) #8, !srcloc !11
  ret void
}

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
define internal void @ck_pr_stall() #0 {
  call void asm sideeffect "", "~{memory}"() #8, !srcloc !13
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_lock() #0 {
  call void @ck_pr_fence_strict_lock()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_store_atomic() #0 {
  call void asm sideeffect "dmb ishst", "r,~{memory}"(i32 0) #8, !srcloc !14
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_lock() #0 {
  call void asm sideeffect "dmb ish", "r,~{memory}"(i32 0) #8, !srcloc !15
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_unlock() #0 {
  call void @ck_pr_fence_strict_unlock()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  store i64 0, ptr %3, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = call i64 asm sideeffect "ldr $0, [$1]\0A", "=r,r,~{memory}"(ptr %4) #8, !srcloc !16
  store i64 %5, ptr %3, align 8
  %6 = load i64, ptr %3, align 8
  %7 = inttoptr i64 %6 to ptr
  ret ptr %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_pr_cas_ptr(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store ptr %2, ptr %6, align 8
  %9 = load ptr, ptr %4, align 8
  %10 = load ptr, ptr %6, align 8
  %11 = load ptr, ptr %5, align 8
  %12 = call { ptr, ptr } asm sideeffect "1:ldxr $0, [$2]\0Acmp  $0, $4\0Ab.ne 2f\0Astxr ${1:w}, $3, [$2]\0Acbnz ${1:w}, 1b\0A2:", "=&r,=&r,r,r,r,~{memory},~{cc}"(ptr %9, ptr %10, ptr %11) #8, !srcloc !17
  %13 = extractvalue { ptr, ptr } %12, 0
  %14 = extractvalue { ptr, ptr } %12, 1
  store ptr %13, ptr %7, align 8
  store ptr %14, ptr %8, align 8
  %15 = load ptr, ptr %7, align 8
  %16 = load ptr, ptr %5, align 8
  %17 = icmp eq ptr %15, %16
  ret i1 %17
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
  call void asm sideeffect "str ${2:w}, [$1]", "=*m,r,r,~{memory}"(ptr elementtype(i32) %5, ptr %6, i32 %7) #8, !srcloc !18
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_unlock() #0 {
  call void asm sideeffect "dmb ish", "r,~{memory}"(i32 0) #8, !srcloc !19
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
!10 = !{i64 2147806896, i64 2147807009, i64 2147807080}
!11 = !{i64 2147765174}
!12 = !{i64 2147763390}
!13 = !{i64 264492}
!14 = !{i64 2147758196}
!15 = !{i64 2147760904}
!16 = !{i64 2147761513}
!17 = !{i64 2147783940, i64 2147784055, i64 2147784121, i64 2147784174, i64 2147784246, i64 2147784304}
!18 = !{i64 2147767077}
!19 = !{i64 2147761169}
