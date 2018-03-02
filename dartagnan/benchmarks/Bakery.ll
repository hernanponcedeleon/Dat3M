; ModuleID = 'Bakery.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@c0 = global i32 0, align 4
@c1 = global i32 0, align 4
@n0 = global i32 0, align 4
@n1 = global i32 0, align 4

; Function Attrs: nounwind uwtable
define i8* @thrd0(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %a0 = alloca i32, align 4
  %r0 = alloca i32, align 4
  %r1 = alloca i32, align 4
  %a1 = alloca i32, align 4
  %chk = alloca i32, align 4
  store i8* %args, i8** %2, align 8
  br label %3

; <label>:3                                       ; preds = %0, %29
  store i32 1, i32* %a0, align 4
  %4 = load i32, i32* %a0, align 4
  store i32 %4, i32* @c0, align 4
  %5 = load i32, i32* @n1, align 4
  store i32 %5, i32* %r0, align 4
  %6 = load i32, i32* %r0, align 4
  %7 = add nsw i32 %6, 1
  store i32 %7, i32* %r1, align 4
  %8 = load i32, i32* %r1, align 4
  store i32 %8, i32* @n0, align 4
  store i32 0, i32* %a1, align 4
  %9 = load i32, i32* %a1, align 4
  store i32 %9, i32* @c0, align 4
  %10 = load i32, i32* @c1, align 4
  store i32 %10, i32* %chk, align 4
  br label %11

; <label>:11                                      ; preds = %14, %3
  %12 = load i32, i32* %chk, align 4
  %13 = icmp ne i32 %12, 0
  br i1 %13, label %14, label %16

; <label>:14                                      ; preds = %11
  %15 = load i32, i32* @c1, align 4
  store i32 %15, i32* %chk, align 4
  br label %11

; <label>:16                                      ; preds = %11
  %17 = load i32, i32* @n1, align 4
  store i32 %17, i32* %r0, align 4
  br label %18

; <label>:18                                      ; preds = %27, %16
  %19 = load i32, i32* %r0, align 4
  %20 = icmp ne i32 %19, 0
  br i1 %20, label %21, label %25

; <label>:21                                      ; preds = %18
  %22 = load i32, i32* %r0, align 4
  %23 = load i32, i32* %r1, align 4
  %24 = icmp slt i32 %22, %23
  br label %25

; <label>:25                                      ; preds = %21, %18
  %26 = phi i1 [ false, %18 ], [ %24, %21 ]
  br i1 %26, label %27, label %29

; <label>:27                                      ; preds = %25
  %28 = load i32, i32* @n1, align 4
  store i32 %28, i32* %r0, align 4
  br label %18

; <label>:29                                      ; preds = %25
  br label %3
                                                  ; No predecessors!
  %31 = load i8*, i8** %1, align 8
  ret i8* %31
}

; Function Attrs: nounwind uwtable
define i8* @thrd1(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %b0 = alloca i32, align 4
  %q0 = alloca i32, align 4
  %q1 = alloca i32, align 4
  %b1 = alloca i32, align 4
  %chk = alloca i32, align 4
  store i8* %args, i8** %2, align 8
  br label %3

; <label>:3                                       ; preds = %0, %29
  store i32 1, i32* %b0, align 4
  %4 = load i32, i32* %b0, align 4
  store i32 %4, i32* @c1, align 4
  %5 = load i32, i32* @n0, align 4
  store i32 %5, i32* %q0, align 4
  %6 = load i32, i32* %q0, align 4
  %7 = add nsw i32 %6, 1
  store i32 %7, i32* %q1, align 4
  %8 = load i32, i32* %q1, align 4
  store i32 %8, i32* @n1, align 4
  store i32 0, i32* %b1, align 4
  %9 = load i32, i32* %b1, align 4
  store i32 %9, i32* @c1, align 4
  %10 = load i32, i32* @c0, align 4
  store i32 %10, i32* %chk, align 4
  br label %11

; <label>:11                                      ; preds = %14, %3
  %12 = load i32, i32* %chk, align 4
  %13 = icmp ne i32 %12, 0
  br i1 %13, label %14, label %16

; <label>:14                                      ; preds = %11
  %15 = load i32, i32* @c0, align 4
  store i32 %15, i32* %chk, align 4
  br label %11

; <label>:16                                      ; preds = %11
  %17 = load i32, i32* @n0, align 4
  store i32 %17, i32* %q0, align 4
  br label %18

; <label>:18                                      ; preds = %27, %16
  %19 = load i32, i32* %q0, align 4
  %20 = icmp ne i32 %19, 0
  br i1 %20, label %21, label %25

; <label>:21                                      ; preds = %18
  %22 = load i32, i32* %q0, align 4
  %23 = load i32, i32* %q1, align 4
  %24 = icmp slt i32 %22, %23
  br label %25

; <label>:25                                      ; preds = %21, %18
  %26 = phi i1 [ false, %18 ], [ %24, %21 ]
  br i1 %26, label %27, label %29

; <label>:27                                      ; preds = %25
  %28 = load i32, i32* @n0, align 4
  store i32 %28, i32* %q0, align 4
  br label %18

; <label>:29                                      ; preds = %25
  br label %3
                                                  ; No predecessors!
  %31 = load i8*, i8** %1, align 8
  ret i8* %31
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
