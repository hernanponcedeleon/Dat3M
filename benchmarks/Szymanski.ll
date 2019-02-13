; ModuleID = 'Szymanski.c'
source_filename = "Szymanski.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@flag1 = global i32 0, align 4
@flag2 = global i32 0, align 4
@.str = private unnamed_addr constant [13 x i8] c"x==0 && y==0\00", align 1
@.str.1 = private unnamed_addr constant [12 x i8] c"Szymanski.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [23 x i8] c"int main(int, char **)\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define i8* @thrd0(i8*) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %3, align 8
  br label %5

; <label>:5:                                      ; preds = %1, %43
  store i32 1, i32* @flag1, align 4
  %6 = load i32, i32* @flag2, align 4
  store i32 %6, i32* %4, align 4
  br label %7

; <label>:7:                                      ; preds = %10, %5
  %8 = load i32, i32* %4, align 4
  %9 = icmp sge i32 %8, 3
  br i1 %9, label %10, label %12

; <label>:10:                                     ; preds = %7
  %11 = load i32, i32* @flag2, align 4
  store i32 %11, i32* %4, align 4
  br label %7

; <label>:12:                                     ; preds = %7
  store i32 3, i32* @flag1, align 4
  %13 = load i32, i32* @flag2, align 4
  store i32 %13, i32* %4, align 4
  %14 = load i32, i32* %4, align 4
  %15 = icmp eq i32 %14, 1
  br i1 %15, label %16, label %24

; <label>:16:                                     ; preds = %12
  store i32 2, i32* @flag1, align 4
  %17 = load i32, i32* @flag2, align 4
  store i32 %17, i32* %4, align 4
  br label %18

; <label>:18:                                     ; preds = %21, %16
  %19 = load i32, i32* %4, align 4
  %20 = icmp ne i32 %19, 4
  br i1 %20, label %21, label %23

; <label>:21:                                     ; preds = %18
  %22 = load i32, i32* @flag2, align 4
  store i32 %22, i32* %4, align 4
  br label %18

; <label>:23:                                     ; preds = %18
  br label %24

; <label>:24:                                     ; preds = %23, %12
  store i32 4, i32* @flag1, align 4
  %25 = load i32, i32* @flag2, align 4
  store i32 %25, i32* %4, align 4
  br label %26

; <label>:26:                                     ; preds = %29, %24
  %27 = load i32, i32* %4, align 4
  %28 = icmp sge i32 %27, 2
  br i1 %28, label %29, label %31

; <label>:29:                                     ; preds = %26
  %30 = load i32, i32* @flag2, align 4
  store i32 %30, i32* %4, align 4
  br label %26

; <label>:31:                                     ; preds = %26
  %32 = load i32, i32* @flag2, align 4
  store i32 %32, i32* %4, align 4
  br label %33

; <label>:33:                                     ; preds = %41, %31
  %34 = load i32, i32* %4, align 4
  %35 = icmp sle i32 2, %34
  br i1 %35, label %36, label %39

; <label>:36:                                     ; preds = %33
  %37 = load i32, i32* %4, align 4
  %38 = icmp sle i32 %37, 3
  br label %39

; <label>:39:                                     ; preds = %36, %33
  %40 = phi i1 [ false, %33 ], [ %38, %36 ]
  br i1 %40, label %41, label %43

; <label>:41:                                     ; preds = %39
  %42 = load i32, i32* @flag2, align 4
  store i32 %42, i32* %4, align 4
  br label %33

; <label>:43:                                     ; preds = %39
  br label %5
                                                  ; No predecessors!
  %45 = load i8*, i8** %2, align 8
  ret i8* %45
}

; Function Attrs: noinline nounwind optnone uwtable
define i8* @thrd1(i8*) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %3, align 8
  br label %5

; <label>:5:                                      ; preds = %1, %43
  store i32 1, i32* @flag2, align 4
  %6 = load i32, i32* @flag1, align 4
  store i32 %6, i32* %4, align 4
  br label %7

; <label>:7:                                      ; preds = %10, %5
  %8 = load i32, i32* %4, align 4
  %9 = icmp sge i32 %8, 3
  br i1 %9, label %10, label %12

; <label>:10:                                     ; preds = %7
  %11 = load i32, i32* @flag1, align 4
  store i32 %11, i32* %4, align 4
  br label %7

; <label>:12:                                     ; preds = %7
  store i32 3, i32* @flag2, align 4
  %13 = load i32, i32* @flag1, align 4
  store i32 %13, i32* %4, align 4
  %14 = load i32, i32* %4, align 4
  %15 = icmp eq i32 %14, 1
  br i1 %15, label %16, label %24

; <label>:16:                                     ; preds = %12
  store i32 2, i32* @flag2, align 4
  %17 = load i32, i32* @flag1, align 4
  store i32 %17, i32* %4, align 4
  br label %18

; <label>:18:                                     ; preds = %21, %16
  %19 = load i32, i32* %4, align 4
  %20 = icmp ne i32 %19, 4
  br i1 %20, label %21, label %23

; <label>:21:                                     ; preds = %18
  %22 = load i32, i32* @flag1, align 4
  store i32 %22, i32* %4, align 4
  br label %18

; <label>:23:                                     ; preds = %18
  br label %24

; <label>:24:                                     ; preds = %23, %12
  store i32 4, i32* @flag2, align 4
  %25 = load i32, i32* @flag1, align 4
  store i32 %25, i32* %4, align 4
  br label %26

; <label>:26:                                     ; preds = %29, %24
  %27 = load i32, i32* %4, align 4
  %28 = icmp sge i32 %27, 2
  br i1 %28, label %29, label %31

; <label>:29:                                     ; preds = %26
  %30 = load i32, i32* @flag1, align 4
  store i32 %30, i32* %4, align 4
  br label %26

; <label>:31:                                     ; preds = %26
  %32 = load i32, i32* @flag1, align 4
  store i32 %32, i32* %4, align 4
  br label %33

; <label>:33:                                     ; preds = %41, %31
  %34 = load i32, i32* %4, align 4
  %35 = icmp sle i32 2, %34
  br i1 %35, label %36, label %39

; <label>:36:                                     ; preds = %33
  %37 = load i32, i32* %4, align 4
  %38 = icmp sle i32 %37, 3
  br label %39

; <label>:39:                                     ; preds = %36, %33
  %40 = phi i1 [ false, %33 ], [ %38, %36 ]
  br i1 %40, label %41, label %43

; <label>:41:                                     ; preds = %39
  %42 = load i32, i32* @flag1, align 4
  store i32 %42, i32* %4, align 4
  br label %33

; <label>:43:                                     ; preds = %39
  br label %5
                                                  ; No predecessors!
  %45 = load i8*, i8** %2, align 8
  ret i8* %45
}

; Function Attrs: noinline nounwind optnone uwtable
define i32 @main(i32, i8**) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  %10 = call i32 @pthread_create(i64* %6, %union.pthread_attr_t* null, i8* (i8*)* @thrd0, i8* null) #4
  %11 = call i32 @pthread_create(i64* %7, %union.pthread_attr_t* null, i8* (i8*)* @thrd1, i8* null) #4
  %12 = load i64, i64* %6, align 8
  %13 = call i32 @pthread_join(i64 %12, i8** null)
  store i32 %13, i32* %8, align 4
  %14 = load i64, i64* %7, align 8
  %15 = call i32 @pthread_join(i64 %14, i8** null)
  store i32 %15, i32* %9, align 4
  %16 = load i32, i32* %8, align 4
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %18, label %22

; <label>:18:                                     ; preds = %2
  %19 = load i32, i32* %9, align 4
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %21, label %22

; <label>:21:                                     ; preds = %18
  br label %23

; <label>:22:                                     ; preds = %18, %2
  call void @__assert_fail(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.1, i32 0, i32 0), i32 75, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.main, i32 0, i32 0)) #5
  unreachable

; <label>:23:                                     ; preds = %21
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
