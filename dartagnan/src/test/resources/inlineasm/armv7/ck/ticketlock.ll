; ModuleID = 'tests/ticketlock.c'
source_filename = "tests/ticketlock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_spinlock_ticket = type { i32, i32 }

@x = global i32 0, align 4
@y = global i32 0, align 4
@.str = private unnamed_addr constant [39 x i8] c"Thread %d: attempting to acquire lock\0A\00", align 1
@ticket_lock = global ptr null, align 8
@.str.1 = private unnamed_addr constant [26 x i8] c"Thread %d: acquired lock\0A\00", align 1
@.str.2 = private unnamed_addr constant [27 x i8] c"Thread %d: x = %d, y = %d\0A\00", align 1
@.str.3 = private unnamed_addr constant [26 x i8] c"Thread %d: released lock\0A\00", align 1
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str.4 = private unnamed_addr constant [13 x i8] c"ticketlock.c\00", align 1
@.str.5 = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1
@.str.6 = private unnamed_addr constant [61 x i8] c"All threads finished with x = %d, y = %d, and NTHREADS = %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = ptrtoint ptr %4 to i64
  %6 = trunc i64 %5 to i32
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  %8 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %7)
  %9 = load ptr, ptr @ticket_lock, align 8
  call void @ck_spinlock_ticket_lock(ptr noundef %9)
  %10 = load i32, ptr %3, align 4
  %11 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %10)
  %12 = load i32, ptr @x, align 4
  %13 = add nsw i32 %12, 1
  store i32 %13, ptr @x, align 4
  %14 = load i32, ptr @y, align 4
  %15 = add nsw i32 %14, 1
  store i32 %15, ptr @y, align 4
  %16 = load i32, ptr %3, align 4
  %17 = load i32, ptr @x, align 4
  %18 = load i32, ptr @y, align 4
  %19 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef %16, i32 noundef %17, i32 noundef %18)
  %20 = load ptr, ptr @ticket_lock, align 8
  call void @ck_spinlock_ticket_unlock(ptr noundef %20)
  %21 = load i32, ptr %3, align 4
  %22 = call i32 (ptr, ...) @printf(ptr noundef @.str.3, i32 noundef %21)
  ret ptr null
}

declare i32 @printf(ptr noundef, ...) #1

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

6:                                                ; preds = %20, %0
  %7 = load i32, ptr %3, align 4
  %8 = icmp slt i32 %7, 3
  br i1 %8, label %9, label %23

9:                                                ; preds = %6
  %10 = load i32, ptr %3, align 4
  %11 = sext i32 %10 to i64
  %12 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %11
  %13 = load i32, ptr %3, align 4
  %14 = sext i32 %13 to i64
  %15 = inttoptr i64 %14 to ptr
  %16 = call i32 @pthread_create(ptr noundef %12, ptr noundef null, ptr noundef @run, ptr noundef %15)
  %17 = icmp ne i32 %16, 0
  br i1 %17, label %18, label %19

18:                                               ; preds = %9
  call void @exit(i32 noundef 1) #6
  unreachable

19:                                               ; preds = %9
  br label %20

20:                                               ; preds = %19
  %21 = load i32, ptr %3, align 4
  %22 = add nsw i32 %21, 1
  store i32 %22, ptr %3, align 4
  br label %6, !llvm.loop !8

23:                                               ; preds = %6
  store i32 0, ptr %3, align 4
  br label %24

24:                                               ; preds = %36, %23
  %25 = load i32, ptr %3, align 4
  %26 = icmp slt i32 %25, 3
  br i1 %26, label %27, label %39

27:                                               ; preds = %24
  %28 = load i32, ptr %3, align 4
  %29 = sext i32 %28 to i64
  %30 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %29
  %31 = load ptr, ptr %30, align 8
  %32 = call i32 @"\01_pthread_join"(ptr noundef %31, ptr noundef null)
  %33 = icmp ne i32 %32, 0
  br i1 %33, label %34, label %35

34:                                               ; preds = %27
  call void @exit(i32 noundef 1) #6
  unreachable

35:                                               ; preds = %27
  br label %36

36:                                               ; preds = %35
  %37 = load i32, ptr %3, align 4
  %38 = add nsw i32 %37, 1
  store i32 %38, ptr %3, align 4
  br label %24, !llvm.loop !9

39:                                               ; preds = %24
  %40 = load i32, ptr @x, align 4
  %41 = icmp eq i32 %40, 3
  br i1 %41, label %42, label %45

42:                                               ; preds = %39
  %43 = load i32, ptr @y, align 4
  %44 = icmp eq i32 %43, 3
  br label %45

45:                                               ; preds = %42, %39
  %46 = phi i1 [ false, %39 ], [ %44, %42 ]
  %47 = xor i1 %46, true
  %48 = zext i1 %47 to i32
  %49 = sext i32 %48 to i64
  %50 = icmp ne i64 %49, 0
  br i1 %50, label %51, label %53

51:                                               ; preds = %45
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str.4, i32 noundef 56, ptr noundef @.str.5) #7
  unreachable

52:                                               ; No predecessors!
  br label %54

53:                                               ; preds = %45
  br label %54

54:                                               ; preds = %53, %52
  %55 = load i32, ptr @x, align 4
  %56 = load i32, ptr @y, align 4
  %57 = call i32 (ptr, ...) @printf(ptr noundef @.str.6, i32 noundef %55, i32 noundef %56, i32 noundef 3)
  %58 = load ptr, ptr @ticket_lock, align 8
  call void @free(ptr noundef %58)
  ret i32 0
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #2

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

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

declare void @free(ptr noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_faa_uint(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  store i32 0, ptr %5, align 4
  store i32 0, ptr %6, align 4
  store i32 0, ptr %7, align 4
  %8 = load i32, ptr %5, align 4
  %9 = load i32, ptr %6, align 4
  %10 = load i32, ptr %7, align 4
  %11 = load ptr, ptr %3, align 8
  %12 = load i32, ptr %4, align 4
  %13 = call { i32, i32, i32 } asm sideeffect "1:ldrex $0, [$3];add $1, $4, $0;strex $2, $1, [$3];cmp $2, #0;bne  1b;", "=&r,=&r,=&r,r,r,0,1,2,~{memory},~{cc}"(ptr %11, i32 %12, i32 %8, i32 %9, i32 %10) #8, !srcloc !10
  %14 = extractvalue { i32, i32, i32 } %13, 0
  %15 = extractvalue { i32, i32, i32 } %13, 1
  %16 = extractvalue { i32, i32, i32 } %13, 2
  store i32 %14, ptr %5, align 4
  store i32 %15, ptr %6, align 4
  store i32 %16, ptr %7, align 4
  %17 = load i32, ptr %5, align 4
  ret i32 %17
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_md_load_uint(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  store i64 0, ptr %3, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = call i64 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #8, !srcloc !11
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
  call void asm sideeffect "dmb ish", "~{memory}"() #8, !srcloc !13
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
  %6 = load i32, ptr %4, align 4
  call void asm sideeffect "str $1, [$0]", "r,r,~{memory}"(ptr %5, i32 %6) #8, !srcloc !14
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_unlock() #0 {
  call void asm sideeffect "dmb ish", "~{memory}"() #8, !srcloc !15
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_barrier() #0 {
  call void asm sideeffect "", "~{memory}"() #8, !srcloc !16
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
!10 = !{i64 2147912531}
!11 = !{i64 2147777950}
!12 = !{i64 260761}
!13 = !{i64 2147774157}
!14 = !{i64 2147784689}
!15 = !{i64 2147774376}
!16 = !{i64 436657}
