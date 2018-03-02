; ModuleID = 'Szymanski.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@flag1 = global i32 0, align 4
@flag2 = global i32 0, align 4

; Function Attrs: nounwind uwtable
define i8* @thrd0(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %a = alloca i32, align 4
  %f2 = alloca i32, align 4
  store i8* %args, i8** %2, align 8
  br label %3

; <label>:3                                       ; preds = %0, %45
  store i32 1, i32* %a, align 4
  %4 = load i32, i32* %a, align 4
  store i32 %4, i32* @flag1, align 4
  %5 = load i32, i32* @flag2, align 4
  store i32 %5, i32* %f2, align 4
  br label %6

; <label>:6                                       ; preds = %9, %3
  %7 = load i32, i32* %f2, align 4
  %8 = icmp sge i32 %7, 3
  br i1 %8, label %9, label %11

; <label>:9                                       ; preds = %6
  %10 = load i32, i32* @flag2, align 4
  store i32 %10, i32* %f2, align 4
  br label %6

; <label>:11                                      ; preds = %6
  store i32 3, i32* %a, align 4
  %12 = load i32, i32* %a, align 4
  store i32 %12, i32* @flag1, align 4
  %13 = load i32, i32* @flag2, align 4
  store i32 %13, i32* %f2, align 4
  %14 = load i32, i32* %f2, align 4
  %15 = icmp eq i32 %14, 1
  br i1 %15, label %16, label %25

; <label>:16                                      ; preds = %11
  store i32 2, i32* %a, align 4
  %17 = load i32, i32* %a, align 4
  store i32 %17, i32* @flag1, align 4
  %18 = load i32, i32* @flag2, align 4
  store i32 %18, i32* %f2, align 4
  br label %19

; <label>:19                                      ; preds = %22, %16
  %20 = load i32, i32* %f2, align 4
  %21 = icmp ne i32 %20, 4
  br i1 %21, label %22, label %24

; <label>:22                                      ; preds = %19
  %23 = load i32, i32* @flag2, align 4
  store i32 %23, i32* %f2, align 4
  br label %19

; <label>:24                                      ; preds = %19
  br label %25

; <label>:25                                      ; preds = %24, %11
  store i32 4, i32* %a, align 4
  %26 = load i32, i32* %a, align 4
  store i32 %26, i32* @flag1, align 4
  %27 = load i32, i32* @flag2, align 4
  store i32 %27, i32* %f2, align 4
  br label %28

; <label>:28                                      ; preds = %31, %25
  %29 = load i32, i32* %f2, align 4
  %30 = icmp sge i32 %29, 2
  br i1 %30, label %31, label %33

; <label>:31                                      ; preds = %28
  %32 = load i32, i32* @flag2, align 4
  store i32 %32, i32* %f2, align 4
  br label %28

; <label>:33                                      ; preds = %28
  %34 = load i32, i32* @flag2, align 4
  store i32 %34, i32* %f2, align 4
  br label %35

; <label>:35                                      ; preds = %43, %33
  %36 = load i32, i32* %f2, align 4
  %37 = icmp sle i32 2, %36
  br i1 %37, label %38, label %41

; <label>:38                                      ; preds = %35
  %39 = load i32, i32* %f2, align 4
  %40 = icmp sle i32 %39, 3
  br label %41

; <label>:41                                      ; preds = %38, %35
  %42 = phi i1 [ false, %35 ], [ %40, %38 ]
  br i1 %42, label %43, label %45

; <label>:43                                      ; preds = %41
  %44 = load i32, i32* @flag2, align 4
  store i32 %44, i32* %f2, align 4
  br label %35

; <label>:45                                      ; preds = %41
  br label %3
                                                  ; No predecessors!
  %47 = load i8*, i8** %1, align 8
  ret i8* %47
}

; Function Attrs: nounwind uwtable
define i8* @thrd1(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %a = alloca i32, align 4
  %f1 = alloca i32, align 4
  store i8* %args, i8** %2, align 8
  br label %3

; <label>:3                                       ; preds = %0, %45
  store i32 1, i32* %a, align 4
  %4 = load i32, i32* %a, align 4
  store i32 %4, i32* @flag2, align 4
  %5 = load i32, i32* @flag1, align 4
  store i32 %5, i32* %f1, align 4
  br label %6

; <label>:6                                       ; preds = %9, %3
  %7 = load i32, i32* %f1, align 4
  %8 = icmp sge i32 %7, 3
  br i1 %8, label %9, label %11

; <label>:9                                       ; preds = %6
  %10 = load i32, i32* @flag1, align 4
  store i32 %10, i32* %f1, align 4
  br label %6

; <label>:11                                      ; preds = %6
  store i32 3, i32* %a, align 4
  %12 = load i32, i32* %a, align 4
  store i32 %12, i32* @flag2, align 4
  %13 = load i32, i32* @flag1, align 4
  store i32 %13, i32* %f1, align 4
  %14 = load i32, i32* %f1, align 4
  %15 = icmp eq i32 %14, 1
  br i1 %15, label %16, label %25

; <label>:16                                      ; preds = %11
  store i32 2, i32* %a, align 4
  %17 = load i32, i32* %a, align 4
  store i32 %17, i32* @flag2, align 4
  %18 = load i32, i32* @flag1, align 4
  store i32 %18, i32* %f1, align 4
  br label %19

; <label>:19                                      ; preds = %22, %16
  %20 = load i32, i32* %f1, align 4
  %21 = icmp ne i32 %20, 4
  br i1 %21, label %22, label %24

; <label>:22                                      ; preds = %19
  %23 = load i32, i32* @flag1, align 4
  store i32 %23, i32* %f1, align 4
  br label %19

; <label>:24                                      ; preds = %19
  br label %25

; <label>:25                                      ; preds = %24, %11
  store i32 4, i32* %a, align 4
  %26 = load i32, i32* %a, align 4
  store i32 %26, i32* @flag2, align 4
  %27 = load i32, i32* @flag1, align 4
  store i32 %27, i32* %f1, align 4
  br label %28

; <label>:28                                      ; preds = %31, %25
  %29 = load i32, i32* %f1, align 4
  %30 = icmp sge i32 %29, 2
  br i1 %30, label %31, label %33

; <label>:31                                      ; preds = %28
  %32 = load i32, i32* @flag1, align 4
  store i32 %32, i32* %f1, align 4
  br label %28

; <label>:33                                      ; preds = %28
  %34 = load i32, i32* @flag1, align 4
  store i32 %34, i32* %f1, align 4
  br label %35

; <label>:35                                      ; preds = %43, %33
  %36 = load i32, i32* %f1, align 4
  %37 = icmp sle i32 2, %36
  br i1 %37, label %38, label %41

; <label>:38                                      ; preds = %35
  %39 = load i32, i32* %f1, align 4
  %40 = icmp sle i32 %39, 3
  br label %41

; <label>:41                                      ; preds = %38, %35
  %42 = phi i1 [ false, %35 ], [ %40, %38 ]
  br i1 %42, label %43, label %45

; <label>:43                                      ; preds = %41
  %44 = load i32, i32* @flag1, align 4
  store i32 %44, i32* %f1, align 4
  br label %35

; <label>:45                                      ; preds = %41
  br label %3
                                                  ; No predecessors!
  %47 = load i8*, i8** %1, align 8
  ret i8* %47
}

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8**, align 8
  %t0 = alloca i64, align 8
  %t1 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  store i32 %argc, i32* %2, align 4
  store i8** %argv, i8*** %3, align 8
  %4 = call i32 @pthread_create(i64* %t0, %union.pthread_attr_t* null, i8* (i8*)* @thrd0, i8* null) #3
  %5 = call i32 @pthread_create(i64* %t1, %union.pthread_attr_t* null, i8* (i8*)* @thrd1, i8* null) #3
  %6 = load i64, i64* %t0, align 8
  %7 = call i32 @pthread_join(i64 %6, i8** null)
  %8 = load i64, i64* %t1, align 8
  %9 = call i32 @pthread_join(i64 %8, i8** null)
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*) #1

declare i32 @pthread_join(i64, i8**) #2

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.8.0-2ubuntu4 (tags/RELEASE_380/final)"}
