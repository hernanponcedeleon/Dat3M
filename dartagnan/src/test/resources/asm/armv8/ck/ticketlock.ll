; ModuleID = 'tests/ticketlock.c'
source_filename = "tests/ticketlock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_spinlock_ticket = type { i32, i32 }

@x = global i32 0, align 4
@y = global i32 0, align 4
@ticket_lock = global ptr null, align 8
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [13 x i8] c"ticketlock.c\00", align 1
@.str.1 = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr @ticket_lock, align 8
  call void @ck_spinlock_ticket_lock(ptr noundef %3)
  %4 = load i32, ptr @x, align 4
  %5 = add nsw i32 %4, 1
  store i32 %5, ptr @x, align 4
  %6 = load i32, ptr @y, align 4
  %7 = add nsw i32 %6, 1
  store i32 %7, ptr @y, align 4
  %8 = load ptr, ptr @ticket_lock, align 8
  call void @ck_spinlock_ticket_unlock(ptr noundef %8)
  ret ptr null
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_ticket_lock(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.ck_spinlock_ticket, ptr %4, i32 0, i32 0
  %6 = call i32 @ck_pr_faa_uint(ptr noundef %5, i32 noundef 1)
  store i32 %6, ptr %3, align 4
  br label %7

7:                                                ; preds = %13, %1
  %8 = load ptr, ptr %2, align 8
  %9 = getelementptr inbounds %struct.ck_spinlock_ticket, ptr %8, i32 0, i32 1
  %10 = call i32 @ck_pr_md_load_uint(ptr noundef %9)
  %11 = load i32, ptr %3, align 4
  %12 = icmp ne i32 %10, %11
  br i1 %12, label %13, label %14

13:                                               ; preds = %7
  call void @ck_pr_stall()
  br label %7, !llvm.loop !6

14:                                               ; preds = %7
  call void @ck_pr_fence_lock()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_ticket_unlock(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @ck_pr_fence_unlock()
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.ck_spinlock_ticket, ptr %4, i32 0, i32 1
  %6 = call i32 @ck_pr_md_load_uint(ptr noundef %5)
  store i32 %6, ptr %3, align 4
  %7 = load ptr, ptr %2, align 8
  %8 = getelementptr inbounds %struct.ck_spinlock_ticket, ptr %7, i32 0, i32 1
  %9 = load i32, ptr %3, align 4
  %10 = add i32 %9, 1
  call void @ck_pr_md_store_uint(ptr noundef %8, i32 noundef %10)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %4 = call ptr @malloc(i64 noundef 8) #5
  store ptr %4, ptr @ticket_lock, align 8
  %5 = load ptr, ptr @ticket_lock, align 8
  call void @ck_spinlock_ticket_init(ptr noundef %5)
  store i32 0, ptr %3, align 4
  br label %6

6:                                                ; preds = %17, %0
  %7 = load i32, ptr %3, align 4
  %8 = icmp slt i32 %7, 3
  br i1 %8, label %9, label %20

9:                                                ; preds = %6
  %10 = load i32, ptr %3, align 4
  %11 = sext i32 %10 to i64
  %12 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %11
  %13 = call i32 @pthread_create(ptr noundef %12, ptr noundef null, ptr noundef @run, ptr noundef null)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %15, label %16

15:                                               ; preds = %9
  call void @exit(i32 noundef 1) #6
  unreachable

16:                                               ; preds = %9
  br label %17

17:                                               ; preds = %16
  %18 = load i32, ptr %3, align 4
  %19 = add nsw i32 %18, 1
  store i32 %19, ptr %3, align 4
  br label %6, !llvm.loop !8

20:                                               ; preds = %6
  store i32 0, ptr %3, align 4
  br label %21

21:                                               ; preds = %33, %20
  %22 = load i32, ptr %3, align 4
  %23 = icmp slt i32 %22, 3
  br i1 %23, label %24, label %36

24:                                               ; preds = %21
  %25 = load i32, ptr %3, align 4
  %26 = sext i32 %25 to i64
  %27 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %26
  %28 = load ptr, ptr %27, align 8
  %29 = call i32 @"\01_pthread_join"(ptr noundef %28, ptr noundef null)
  %30 = icmp ne i32 %29, 0
  br i1 %30, label %31, label %32

31:                                               ; preds = %24
  call void @exit(i32 noundef 1) #6
  unreachable

32:                                               ; preds = %24
  br label %33

33:                                               ; preds = %32
  %34 = load i32, ptr %3, align 4
  %35 = add nsw i32 %34, 1
  store i32 %35, ptr %3, align 4
  br label %21, !llvm.loop !9

36:                                               ; preds = %21
  %37 = load i32, ptr @x, align 4
  %38 = icmp eq i32 %37, 3
  br i1 %38, label %39, label %42

39:                                               ; preds = %36
  %40 = load i32, ptr @y, align 4
  %41 = icmp eq i32 %40, 3
  br label %42

42:                                               ; preds = %39, %36
  %43 = phi i1 [ false, %36 ], [ %41, %39 ]
  %44 = xor i1 %43, true
  %45 = zext i1 %44 to i32
  %46 = sext i32 %45 to i64
  %47 = icmp ne i64 %46, 0
  br i1 %47, label %48, label %50

48:                                               ; preds = %42
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 50, ptr noundef @.str.1) #7
  unreachable

49:                                               ; No predecessors!
  br label %51

50:                                               ; preds = %42
  br label %51

51:                                               ; preds = %50, %49
  %52 = load ptr, ptr @ticket_lock, align 8
  call void @free(ptr noundef %52)
  ret i32 0
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_ticket_init(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct.ck_spinlock_ticket, ptr %3, i32 0, i32 0
  store i32 0, ptr %4, align 4
  %5 = load ptr, ptr %2, align 8
  %6 = getelementptr inbounds %struct.ck_spinlock_ticket, ptr %5, i32 0, i32 1
  store i32 0, ptr %6, align 4
  call void @ck_pr_barrier()
  ret void
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noreturn
declare void @exit(i32 noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

declare void @free(ptr noundef) #2

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
  %10 = call { i32, i32, i32 } asm sideeffect "1:ldxr ${0:w}, [$3]\0Aadd ${1:w}, ${4:w}, ${0:w}\0Astxr ${2:w}, ${1:w}, [$3]\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,r,r,~{memory},~{cc}"(ptr %8, i32 %9) #8, !srcloc !10
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
define internal void @ck_pr_fence_strict_lock() #0 {
  call void asm sideeffect "dmb ish", "r,~{memory}"(i32 0) #8, !srcloc !13
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
  call void asm sideeffect "str ${2:w}, [$1]", "=*m,r,r,~{memory}"(ptr elementtype(i32) %5, ptr %6, i32 %7) #8, !srcloc !14
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_unlock() #0 {
  call void asm sideeffect "dmb ish", "r,~{memory}"(i32 0) #8, !srcloc !15
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_barrier() #0 {
  call void asm sideeffect "", "~{memory}"() #8, !srcloc !16
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
!10 = !{i64 2147886812, i64 2147886924, i64 2147886986, i64 2147887054}
!11 = !{i64 2147763174}
!12 = !{i64 264276}
!13 = !{i64 2147760688}
!14 = !{i64 2147766861}
!15 = !{i64 2147760953}
!16 = !{i64 418122}
