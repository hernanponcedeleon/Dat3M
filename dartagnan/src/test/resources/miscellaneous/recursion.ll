; ModuleID = 'local/recursion.ll'
source_filename = "benchmarks/c/miscellaneous/recursion.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx13.0.0"

@x = global i32 0, align 4
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [12 x i8] c"recursion.c\00", align 1
@.str.1 = private unnamed_addr constant [12 x i8] c"result == 2\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @fibonacci(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %3 = load i32, ptr %2, align 4
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %5, label %6

5:                                                ; preds = %1
  br label %20

6:                                                ; preds = %1
  %7 = load i32, ptr %2, align 4
  %8 = icmp eq i32 %7, 1
  br i1 %8, label %9, label %10

9:                                                ; preds = %6
  br label %18

10:                                               ; preds = %6
  %11 = load i32, ptr %2, align 4
  %12 = sub nsw i32 %11, 1
  %13 = call i32 @fib(i32 noundef %12)
  %14 = load i32, ptr %2, align 4
  %15 = sub nsw i32 %14, 2
  %16 = call i32 @fibonacci(i32 noundef %15)
  %17 = add nsw i32 %13, %16
  br label %18

18:                                               ; preds = %10, %9
  %19 = phi i32 [ 1, %9 ], [ %17, %10 ]
  br label %20

20:                                               ; preds = %18, %5
  %21 = phi i32 [ 1, %5 ], [ %19, %18 ]
  ret i32 %21
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @fib(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %3 = load i32, ptr %2, align 4
  %4 = call i32 @fibonacci(i32 noundef %3)
  ret i32 %4
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @ackermann(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  store i32 %1, ptr %4, align 4
  %5 = load i32, ptr %3, align 4
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %10

7:                                                ; preds = %2
  %8 = load i32, ptr %4, align 4
  %9 = add nsw i32 %8, 1
  br label %27

10:                                               ; preds = %2
  %11 = load i32, ptr %4, align 4
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %13, label %17

13:                                               ; preds = %10
  %14 = load i32, ptr %3, align 4
  %15 = sub nsw i32 %14, 1
  %16 = call i32 @ack(i32 noundef %15, i32 noundef 1)
  br label %25

17:                                               ; preds = %10
  %18 = load i32, ptr %3, align 4
  %19 = sub nsw i32 %18, 1
  %20 = load i32, ptr %3, align 4
  %21 = load i32, ptr %4, align 4
  %22 = sub nsw i32 %21, 1
  %23 = call i32 @ack(i32 noundef %20, i32 noundef %22)
  %24 = call i32 @ack(i32 noundef %19, i32 noundef %23)
  br label %25

25:                                               ; preds = %17, %13
  %26 = phi i32 [ %16, %13 ], [ %24, %17 ]
  br label %27

27:                                               ; preds = %25, %7
  %28 = phi i32 [ %9, %7 ], [ %26, %25 ]
  ret i32 %28
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @ack(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  store i32 %1, ptr %4, align 4
  %5 = load i32, ptr %3, align 4
  %6 = load i32, ptr %4, align 4
  %7 = call i32 @ackermann(i32 noundef %5, i32 noundef %6)
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @fun(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %3 = load i32, ptr %2, align 4
  %4 = call i32 @fibonacci(i32 noundef %3)
  ret i32 %4
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define ptr @worker(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %7 = load ptr, ptr %2, align 8
  %8 = load atomic i32, ptr @x monotonic, align 4
  store i32 %8, ptr %4, align 4
  %9 = load i32, ptr %4, align 4
  store i32 %9, ptr %3, align 4
  %10 = load i32, ptr %3, align 4
  %11 = call i32 @fun(i32 noundef %10)
  store i32 %11, ptr %5, align 4
  %12 = load i32, ptr %5, align 4
  store i32 %12, ptr %6, align 4
  %13 = load i32, ptr %6, align 4
  store atomic i32 %13, ptr @x monotonic, align 4
  ret ptr null
}

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store i32 2, ptr @x, align 4
  %9 = call i32 @pthread_create(ptr noundef %2, ptr noundef null, ptr noundef @worker, ptr noundef null)
  %10 = load atomic i32, ptr @x monotonic, align 4
  store i32 %10, ptr %4, align 4
  %11 = load i32, ptr %4, align 4
  store i32 %11, ptr %3, align 4
  %12 = load i32, ptr %3, align 4
  %13 = call i32 @fun(i32 noundef %12)
  store i32 %13, ptr %5, align 4
  %14 = load i32, ptr %5, align 4
  store i32 %14, ptr %6, align 4
  %15 = load i32, ptr %6, align 4
  store atomic i32 %15, ptr @x monotonic, align 4
  %16 = load atomic i32, ptr @x monotonic, align 4
  store i32 %16, ptr %8, align 4
  %17 = load i32, ptr %8, align 4
  store i32 %17, ptr %7, align 4
  %18 = load ptr, ptr %2, align 8
  %19 = call i32 @"\01_pthread_join"(ptr noundef %18, ptr noundef null)
  %20 = load i32, ptr %7, align 4
  %21 = icmp eq i32 %20, 2
  %22 = xor i1 %21, true
  %23 = zext i1 %22 to i32
  %24 = sext i32 %23 to i64
  %25 = icmp ne i64 %24, 0
  br i1 %25, label %26, label %28

26:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 66, ptr noundef @.str.1) #3
  unreachable

27:                                               ; No predecessors!
  br label %29

28:                                               ; preds = %0
  br label %29

29:                                               ; preds = %28, %27
  ret i32 0
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #2 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.5a,+zcm,+zcz" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{i32 7, !"frame-pointer", i32 1}
!4 = !{!"Homebrew clang version 15.0.7"}
