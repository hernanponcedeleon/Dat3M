; ModuleID = 'clhlock.c'
source_filename = "clhlock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_spinlock_clh = type { i32, ptr }

@x = global i32 0, align 4
@y = global i32 0, align 4
@nodes = global ptr null, align 8
@.str = private unnamed_addr constant [39 x i8] c"Thread %d: attempting to acquire lock\0A\00", align 1
@lock = global ptr null, align 8
@.str.1 = private unnamed_addr constant [26 x i8] c"Thread %d: acquired lock\0A\00", align 1
@.str.2 = private unnamed_addr constant [27 x i8] c"Thread %d: x = %d, y = %d\0A\00", align 1
@.str.3 = private unnamed_addr constant [26 x i8] c"Thread %d: released lock\0A\00", align 1
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"clhlock.c\00", align 1
@.str.5 = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1
@.str.6 = private unnamed_addr constant [61 x i8] c"All threads finished with x = %d, y = %d, and NTHREADS = %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8
  %6 = ptrtoint ptr %5 to i64
  %7 = trunc i64 %6 to i32
  store i32 %7, ptr %3, align 4
  %8 = load ptr, ptr @nodes, align 8
  %9 = load i32, ptr %3, align 4
  %10 = sext i32 %9 to i64
  %11 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %8, i64 %10
  store ptr %11, ptr %4, align 8
  %12 = load i32, ptr %3, align 4
  %13 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %12)
  %14 = load ptr, ptr %4, align 8
  call void @ck_spinlock_clh_lock(ptr noundef @lock, ptr noundef %14)
  %15 = load i32, ptr %3, align 4
  %16 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %15)
  %17 = load i32, ptr @x, align 4
  %18 = add nsw i32 %17, 1
  store i32 %18, ptr @x, align 4
  %19 = load i32, ptr @y, align 4
  %20 = add nsw i32 %19, 1
  store i32 %20, ptr @y, align 4
  %21 = load i32, ptr %3, align 4
  %22 = load i32, ptr @x, align 4
  %23 = load i32, ptr @y, align 4
  %24 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef %21, i32 noundef %22, i32 noundef %23)
  call void @ck_spinlock_clh_unlock(ptr noundef %4)
  %25 = load i32, ptr %3, align 4
  %26 = call i32 (ptr, ...) @printf(ptr noundef @.str.3, i32 noundef %25)
  ret ptr null
}

declare i32 @printf(ptr noundef, ...) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_clh_lock(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load ptr, ptr %4, align 8
  %7 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %6, i32 0, i32 0
  store i32 1, ptr %7, align 8
  call void @ck_pr_fence_store_atomic()
  %8 = load ptr, ptr %3, align 8
  %9 = load ptr, ptr %4, align 8
  %10 = call ptr @ck_pr_fas_ptr(ptr noundef %8, ptr noundef %9)
  store ptr %10, ptr %5, align 8
  %11 = load ptr, ptr %5, align 8
  %12 = load ptr, ptr %4, align 8
  %13 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %12, i32 0, i32 1
  store ptr %11, ptr %13, align 8
  call void @ck_pr_fence_load()
  br label %14

14:                                               ; preds = %19, %2
  %15 = load ptr, ptr %5, align 8
  %16 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %15, i32 0, i32 0
  %17 = call i32 @ck_pr_md_load_uint(ptr noundef %16)
  %18 = icmp eq i32 %17, 1
  br i1 %18, label %19, label %20

19:                                               ; preds = %14
  call void @ck_pr_stall()
  br label %14, !llvm.loop !5

20:                                               ; preds = %14
  call void @ck_pr_fence_lock()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_clh_unlock(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds ptr, ptr %4, i64 0
  %6 = load ptr, ptr %5, align 8
  %7 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %6, i32 0, i32 1
  %8 = load ptr, ptr %7, align 8
  store ptr %8, ptr %3, align 8
  call void @ck_pr_fence_unlock()
  %9 = load ptr, ptr %2, align 8
  %10 = load ptr, ptr %9, align 8
  %11 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %10, i32 0, i32 0
  call void @ck_pr_md_store_uint(ptr noundef %11, i32 noundef 0)
  %12 = load ptr, ptr %3, align 8
  %13 = load ptr, ptr %2, align 8
  store ptr %12, ptr %13, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i32, align 4
  %4 = alloca %struct.ck_spinlock_clh, align 8
  %5 = alloca %struct.ck_spinlock_clh, align 8
  store i32 0, ptr %1, align 4
  call void @ck_spinlock_clh_init(ptr noundef @lock, ptr noundef %4)
  %6 = call ptr @malloc(i64 noundef 48) #5
  store ptr %6, ptr @nodes, align 8
  store i32 0, ptr %3, align 4
  br label %7

7:                                                ; preds = %15, %0
  %8 = load i32, ptr %3, align 4
  %9 = icmp slt i32 %8, 3
  br i1 %9, label %10, label %18

10:                                               ; preds = %7
  %11 = load ptr, ptr @nodes, align 8
  %12 = load i32, ptr %3, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %11, i64 %13
  call void @ck_spinlock_clh_init(ptr noundef %14, ptr noundef %5)
  br label %15

15:                                               ; preds = %10
  %16 = load i32, ptr %3, align 4
  %17 = add nsw i32 %16, 1
  store i32 %17, ptr %3, align 4
  br label %7, !llvm.loop !7

18:                                               ; preds = %7
  store i32 0, ptr %3, align 4
  br label %19

19:                                               ; preds = %33, %18
  %20 = load i32, ptr %3, align 4
  %21 = icmp slt i32 %20, 3
  br i1 %21, label %22, label %36

22:                                               ; preds = %19
  %23 = load i32, ptr %3, align 4
  %24 = sext i32 %23 to i64
  %25 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %24
  %26 = load i32, ptr %3, align 4
  %27 = sext i32 %26 to i64
  %28 = inttoptr i64 %27 to ptr
  %29 = call i32 @pthread_create(ptr noundef %25, ptr noundef null, ptr noundef @run, ptr noundef %28)
  %30 = icmp ne i32 %29, 0
  br i1 %30, label %31, label %32

31:                                               ; preds = %22
  call void @exit(i32 noundef 1) #6
  unreachable

32:                                               ; preds = %22
  br label %33

33:                                               ; preds = %32
  %34 = load i32, ptr %3, align 4
  %35 = add nsw i32 %34, 1
  store i32 %35, ptr %3, align 4
  br label %19, !llvm.loop !8

36:                                               ; preds = %19
  store i32 0, ptr %3, align 4
  br label %37

37:                                               ; preds = %49, %36
  %38 = load i32, ptr %3, align 4
  %39 = icmp slt i32 %38, 3
  br i1 %39, label %40, label %52

40:                                               ; preds = %37
  %41 = load i32, ptr %3, align 4
  %42 = sext i32 %41 to i64
  %43 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %42
  %44 = load ptr, ptr %43, align 8
  %45 = call i32 @"\01_pthread_join"(ptr noundef %44, ptr noundef null)
  %46 = icmp ne i32 %45, 0
  br i1 %46, label %47, label %48

47:                                               ; preds = %40
  call void @exit(i32 noundef 1) #6
  unreachable

48:                                               ; preds = %40
  br label %49

49:                                               ; preds = %48
  %50 = load i32, ptr %3, align 4
  %51 = add nsw i32 %50, 1
  store i32 %51, ptr %3, align 4
  br label %37, !llvm.loop !9

52:                                               ; preds = %37
  %53 = load i32, ptr @x, align 4
  %54 = icmp eq i32 %53, 3
  br i1 %54, label %55, label %58

55:                                               ; preds = %52
  %56 = load i32, ptr @y, align 4
  %57 = icmp eq i32 %56, 3
  br label %58

58:                                               ; preds = %55, %52
  %59 = phi i1 [ false, %52 ], [ %57, %55 ]
  %60 = xor i1 %59, true
  %61 = zext i1 %60 to i32
  %62 = sext i32 %61 to i64
  %63 = icmp ne i64 %62, 0
  br i1 %63, label %64, label %66

64:                                               ; preds = %58
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str.4, i32 noundef 63, ptr noundef @.str.5) #7
  unreachable

65:                                               ; No predecessors!
  br label %67

66:                                               ; preds = %58
  br label %67

67:                                               ; preds = %66, %65
  %68 = load i32, ptr @x, align 4
  %69 = load i32, ptr @y, align 4
  %70 = call i32 (ptr, ...) @printf(ptr noundef @.str.6, i32 noundef %68, i32 noundef %69, i32 noundef 3)
  %71 = load ptr, ptr @nodes, align 8
  call void @free(ptr noundef %71)
  ret i32 0
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_clh_init(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %4, align 8
  %6 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %5, i32 0, i32 1
  store ptr null, ptr %6, align 8
  %7 = load ptr, ptr %4, align 8
  %8 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %7, i32 0, i32 0
  store i32 0, ptr %8, align 8
  %9 = load ptr, ptr %4, align 8
  %10 = load ptr, ptr %3, align 8
  store ptr %9, ptr %10, align 8
  call void @ck_pr_barrier()
  ret void
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #2

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

declare void @free(ptr noundef) #1

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
define internal void @ck_pr_fence_load() #0 {
  call void @ck_pr_fence_strict_load()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_md_load_uint(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  store i64 0, ptr %3, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = call i64 asm sideeffect "ldr ${0:w}, [$1]\0A", "=r,r,~{memory}"(ptr %4) #8, !srcloc !11
  store i64 %5, ptr %3, align 8
  %6 = load i64, ptr %3, align 8
  %7 = trunc i64 %6 to i32
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_stall() #0 {
  call void asm sideeffect "", "~{memory}"() #8, !srcloc !12
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_lock() #0 {
  call void @ck_pr_fence_strict_lock()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_store_atomic() #0 {
  call void asm sideeffect "dmb ishst", "r,~{memory}"(i32 0) #8, !srcloc !13
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_load() #0 {
  call void asm sideeffect "dmb ishld", "r,~{memory}"(i32 0) #8, !srcloc !14
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
define internal void @ck_pr_fence_strict_unlock() #0 {
  call void asm sideeffect "dmb ish", "r,~{memory}"(i32 0) #8, !srcloc !17
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_barrier() #0 {
  call void asm sideeffect "", "~{memory}"() #8, !srcloc !18
  ret void
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #4 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #5 = { allocsize(0) }
attributes #6 = { noreturn }
attributes #7 = { cold noreturn }
attributes #8 = { nounwind }

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
!10 = !{i64 2147803330, i64 2147803443, i64 2147803514}
!11 = !{i64 2147759824}
!12 = !{i64 260926}
!13 = !{i64 2147754630}
!14 = !{i64 2147755726}
!15 = !{i64 2147757338}
!16 = !{i64 2147763511}
!17 = !{i64 2147757603}
!18 = !{i64 414772}
