; ModuleID = 'benchmarks/Lamport.c'
source_filename = "benchmarks/Lamport.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = global i32 0, align 4
@y = global i32 0, align 4
@b1 = global i32 0, align 4
@b2 = global i32 0, align 4
@b3 = global i32 0, align 4
@.str = private unnamed_addr constant [21 x i8] c"x==0 && y==0 && z==0\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"benchmarks/Lamport.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [23 x i8] c"int main(int, char **)\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define i8* @thrd0(i8*) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i8* %0, i8** %3, align 8
  br label %6

; <label>:6:                                      ; preds = %1, %16
  store i32 1, i32* @b1, align 4
  store i32 1, i32* @x, align 4
  %7 = load i32, i32* @y, align 4
  store i32 %7, i32* %4, align 4
  %8 = load i32, i32* %4, align 4
  %9 = icmp ne i32 %8, 0
  br i1 %9, label %10, label %11

; <label>:10:                                     ; preds = %6
  store i32 0, i32* @b1, align 4
  br label %11

; <label>:11:                                     ; preds = %10, %6
  store i32 1, i32* @y, align 4
  %12 = load i32, i32* @x, align 4
  store i32 %12, i32* %5, align 4
  %13 = load i32, i32* %5, align 4
  %14 = icmp ne i32 %13, 1
  br i1 %14, label %15, label %16

; <label>:15:                                     ; preds = %11
  store i32 0, i32* @b1, align 4
  br label %16

; <label>:16:                                     ; preds = %15, %11
  br label %6
                                                  ; No predecessors!
  %18 = load i8*, i8** %2, align 8
  ret i8* %18
}

; Function Attrs: noinline nounwind optnone uwtable
define i8* @thrd1(i8*) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i8* %0, i8** %3, align 8
  br label %6

; <label>:6:                                      ; preds = %1, %16
  store i32 1, i32* @b2, align 4
  store i32 2, i32* @x, align 4
  %7 = load i32, i32* @y, align 4
  store i32 %7, i32* %4, align 4
  %8 = load i32, i32* %4, align 4
  %9 = icmp ne i32 %8, 0
  br i1 %9, label %10, label %11

; <label>:10:                                     ; preds = %6
  store i32 0, i32* @b2, align 4
  br label %11

; <label>:11:                                     ; preds = %10, %6
  store i32 2, i32* @y, align 4
  %12 = load i32, i32* @x, align 4
  store i32 %12, i32* %5, align 4
  %13 = load i32, i32* %5, align 4
  %14 = icmp ne i32 %13, 2
  br i1 %14, label %15, label %16

; <label>:15:                                     ; preds = %11
  store i32 0, i32* @b2, align 4
  br label %16

; <label>:16:                                     ; preds = %15, %11
  br label %6
                                                  ; No predecessors!
  %18 = load i8*, i8** %2, align 8
  ret i8* %18
}

; Function Attrs: noinline nounwind optnone uwtable
define i8* @thrd2(i8*) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i8* %0, i8** %3, align 8
  br label %6

; <label>:6:                                      ; preds = %1, %16
  store i32 1, i32* @b3, align 4
  store i32 3, i32* @x, align 4
  %7 = load i32, i32* @y, align 4
  store i32 %7, i32* %4, align 4
  %8 = load i32, i32* %4, align 4
  %9 = icmp ne i32 %8, 0
  br i1 %9, label %10, label %11

; <label>:10:                                     ; preds = %6
  store i32 0, i32* @b3, align 4
  br label %11

; <label>:11:                                     ; preds = %10, %6
  store i32 3, i32* @y, align 4
  %12 = load i32, i32* @x, align 4
  store i32 %12, i32* %5, align 4
  %13 = load i32, i32* %5, align 4
  %14 = icmp ne i32 %13, 3
  br i1 %14, label %15, label %16

; <label>:15:                                     ; preds = %11
  store i32 0, i32* @b3, align 4
  br label %16

; <label>:16:                                     ; preds = %15, %11
  br label %6
                                                  ; No predecessors!
  %18 = load i8*, i8** %2, align 8
  ret i8* %18
}

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main(i32, i8**) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  %12 = call i32 @pthread_create(i64* %6, %union.pthread_attr_t* null, i8* (i8*)* @thrd0, i8* null) #4
  %13 = call i32 @pthread_create(i64* %7, %union.pthread_attr_t* null, i8* (i8*)* @thrd1, i8* null) #4
  %14 = call i32 @pthread_create(i64* %8, %union.pthread_attr_t* null, i8* (i8*)* @thrd2, i8* null) #4
  %15 = load i64, i64* %6, align 8
  %16 = call i32 @pthread_join(i64 %15, i8** null)
  store i32 %16, i32* %9, align 4
  %17 = load i64, i64* %7, align 8
  %18 = call i32 @pthread_join(i64 %17, i8** null)
  store i32 %18, i32* %10, align 4
  %19 = load i64, i64* %8, align 8
  %20 = call i32 @pthread_join(i64 %19, i8** null)
  store i32 %20, i32* %11, align 4
  %21 = load i32, i32* %9, align 4
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %23, label %30

; <label>:23:                                     ; preds = %2
  %24 = load i32, i32* %10, align 4
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %26, label %30

; <label>:26:                                     ; preds = %23
  %27 = load i32, i32* %11, align 4
  %28 = icmp eq i32 %27, 0
  br i1 %28, label %29, label %30

; <label>:29:                                     ; preds = %26
  br label %31

; <label>:30:                                     ; preds = %26, %23, %2
  call void @__assert_fail(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.1, i32 0, i32 0), i32 71, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.main, i32 0, i32 0)) #5
  unreachable

; <label>:31:                                     ; preds = %29
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*) #1

declare i32 @pthread_join(i64, i8**) #2

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8*, i8*, i32, i8*) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }
attributes #5 = { noreturn nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
