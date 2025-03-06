; ModuleID = 'tests/clhlock.c'
source_filename = "tests/clhlock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_spinlock_clh = type { i32, ptr }

@x = global i32 0, align 4
@y = global i32 0, align 4
@nodes = global ptr null, align 8
@lock = global ptr null, align 8
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"clhlock.c\00", align 1
@.str.1 = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1

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
  %12 = load ptr, ptr %4, align 8
  call void @ck_spinlock_clh_lock(ptr noundef @lock, ptr noundef %12)
  %13 = load i32, ptr @x, align 4
  %14 = add nsw i32 %13, 1
  store i32 %14, ptr @x, align 4
  %15 = load i32, ptr @y, align 4
  %16 = add nsw i32 %15, 1
  store i32 %16, ptr @y, align 4
  call void @ck_spinlock_clh_unlock(ptr noundef %4)
  ret ptr null
}

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
  br label %14, !llvm.loop !6

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
  %3 = alloca [3 x i64], align 8
  %4 = alloca i64, align 8
  %5 = alloca %struct.ck_spinlock_clh, align 8
  %6 = alloca %struct.ck_spinlock_clh, align 8
  store i32 0, ptr %1, align 4
  call void @ck_spinlock_clh_init(ptr noundef @lock, ptr noundef %5)
  %7 = call ptr @malloc(i64 noundef 48) #5
  store ptr %7, ptr @nodes, align 8
  store i64 0, ptr %4, align 8
  br label %8

8:                                                ; preds = %15, %0
  %9 = load i64, ptr %4, align 8
  %10 = icmp slt i64 %9, 3
  br i1 %10, label %11, label %18

11:                                               ; preds = %8
  %12 = load ptr, ptr @nodes, align 8
  %13 = load i64, ptr %4, align 8
  %14 = getelementptr inbounds %struct.ck_spinlock_clh, ptr %12, i64 %13
  call void @ck_spinlock_clh_init(ptr noundef %14, ptr noundef %6)
  br label %15

15:                                               ; preds = %11
  %16 = load i64, ptr %4, align 8
  %17 = add nsw i64 %16, 1
  store i64 %17, ptr %4, align 8
  br label %8, !llvm.loop !8

18:                                               ; preds = %8
  store i64 0, ptr %4, align 8
  br label %19

19:                                               ; preds = %31, %18
  %20 = load i64, ptr %4, align 8
  %21 = icmp slt i64 %20, 3
  br i1 %21, label %22, label %34

22:                                               ; preds = %19
  %23 = load i64, ptr %4, align 8
  %24 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %23
  %25 = load i64, ptr %4, align 8
  %26 = getelementptr inbounds [3 x i64], ptr %3, i64 0, i64 %25
  %27 = call i32 @pthread_create(ptr noundef %24, ptr noundef null, ptr noundef @run, ptr noundef %26)
  %28 = icmp ne i32 %27, 0
  br i1 %28, label %29, label %30

29:                                               ; preds = %22
  call void @exit(i32 noundef 1) #6
  unreachable

30:                                               ; preds = %22
  br label %31

31:                                               ; preds = %30
  %32 = load i64, ptr %4, align 8
  %33 = add nsw i64 %32, 1
  store i64 %33, ptr %4, align 8
  br label %19, !llvm.loop !9

34:                                               ; preds = %19
  store i64 0, ptr %4, align 8
  br label %35

35:                                               ; preds = %46, %34
  %36 = load i64, ptr %4, align 8
  %37 = icmp slt i64 %36, 3
  br i1 %37, label %38, label %49

38:                                               ; preds = %35
  %39 = load i64, ptr %4, align 8
  %40 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %39
  %41 = load ptr, ptr %40, align 8
  %42 = call i32 @"\01_pthread_join"(ptr noundef %41, ptr noundef null)
  %43 = icmp ne i32 %42, 0
  br i1 %43, label %44, label %45

44:                                               ; preds = %38
  call void @exit(i32 noundef 1) #6
  unreachable

45:                                               ; preds = %38
  br label %46

46:                                               ; preds = %45
  %47 = load i64, ptr %4, align 8
  %48 = add nsw i64 %47, 1
  store i64 %48, ptr %4, align 8
  br label %35, !llvm.loop !10

49:                                               ; preds = %35
  %50 = load i32, ptr @x, align 4
  %51 = icmp eq i32 %50, 3
  br i1 %51, label %52, label %55

52:                                               ; preds = %49
  %53 = load i32, ptr @y, align 4
  %54 = icmp eq i32 %53, 3
  br label %55

55:                                               ; preds = %52, %49
  %56 = phi i1 [ false, %49 ], [ %54, %52 ]
  %57 = xor i1 %56, true
  %58 = zext i1 %57 to i32
  %59 = sext i32 %58 to i64
  %60 = icmp ne i64 %59, 0
  br i1 %60, label %61, label %63

61:                                               ; preds = %55
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 56, ptr noundef @.str.1) #7
  unreachable

62:                                               ; No predecessors!
  br label %64

63:                                               ; preds = %55
  br label %64

64:                                               ; preds = %63, %62
  %65 = load ptr, ptr @nodes, align 8
  call void @free(ptr noundef %65)
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
declare ptr @malloc(i64 noundef) #1

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noreturn
declare void @exit(i32 noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

declare void @free(ptr noundef) #2

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
  %9 = call { ptr, ptr } asm sideeffect "1:ldxr $0, [$2]\0Astxr ${1:w}, $3, [$2]\0Acbnz ${1:w}, 1b\0A", "=&r,=&r,r,r,~{memory},~{cc}"(ptr %7, ptr %8) #8, !srcloc !11
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
define internal void @ck_pr_fence_strict_load() #0 {
  call void asm sideeffect "dmb ishld", "r,~{memory}"(i32 0) #8, !srcloc !15
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_lock() #0 {
  call void asm sideeffect "dmb ish", "r,~{memory}"(i32 0) #8, !srcloc !16
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
  call void asm sideeffect "str ${2:w}, [$1]", "=*m,r,r,~{memory}"(ptr elementtype(i32) %5, ptr %6, i32 %7) #8, !srcloc !17
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_unlock() #0 {
  call void asm sideeffect "dmb ish", "r,~{memory}"(i32 0) #8, !srcloc !18
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_barrier() #0 {
  call void asm sideeffect "", "~{memory}"() #8, !srcloc !19
  ret void
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
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
!11 = !{i64 2147806950, i64 2147807063, i64 2147807134}
!12 = !{i64 2147763444}
!13 = !{i64 264546}
!14 = !{i64 2147758250}
!15 = !{i64 2147759346}
!16 = !{i64 2147760958}
!17 = !{i64 2147767131}
!18 = !{i64 2147761223}
!19 = !{i64 418392}
