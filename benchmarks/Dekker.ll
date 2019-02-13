; ModuleID = 'benchmarks/Dekker.c'
source_filename = "benchmarks/Dekker.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@flag0 = global i32 0, align 4
@flag1 = global i32 0, align 4
@turn = global i32 0, align 4
@.str = private unnamed_addr constant [13 x i8] c"x==0 && y==0\00", align 1
@.str.1 = private unnamed_addr constant [20 x i8] c"benchmarks/Dekker.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [23 x i8] c"int main(int, char **)\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define i8* @thrd0(i8*) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i8* %0, i8** %3, align 8
  br label %6

; <label>:6:                                      ; preds = %1, %24
  store i32 1, i32* @flag0, align 4
  %7 = load i32, i32* @flag1, align 4
  store i32 %7, i32* %4, align 4
  br label %8

; <label>:8:                                      ; preds = %23, %6
  %9 = load i32, i32* %4, align 4
  %10 = icmp eq i32 %9, 1
  br i1 %10, label %11, label %24

; <label>:11:                                     ; preds = %8
  %12 = load i32, i32* @turn, align 4
  store i32 %12, i32* %5, align 4
  %13 = load i32, i32* %5, align 4
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %15, label %23

; <label>:15:                                     ; preds = %11
  store i32 0, i32* @flag0, align 4
  %16 = load i32, i32* @turn, align 4
  store i32 %16, i32* %5, align 4
  br label %17

; <label>:17:                                     ; preds = %20, %15
  %18 = load i32, i32* %5, align 4
  %19 = icmp ne i32 %18, 0
  br i1 %19, label %20, label %22

; <label>:20:                                     ; preds = %17
  %21 = load i32, i32* @turn, align 4
  store i32 %21, i32* %5, align 4
  br label %17

; <label>:22:                                     ; preds = %17
  store i32 1, i32* @flag0, align 4
  br label %23

; <label>:23:                                     ; preds = %22, %11
  br label %8

; <label>:24:                                     ; preds = %8
  br label %6
                                                  ; No predecessors!
  %26 = load i8*, i8** %2, align 8
  ret i8* %26
}

; Function Attrs: noinline nounwind optnone uwtable
define i8* @thrd1(i8*) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i8* %0, i8** %3, align 8
  br label %6

; <label>:6:                                      ; preds = %1, %24
  store i32 1, i32* @flag1, align 4
  %7 = load i32, i32* @flag0, align 4
  store i32 %7, i32* %4, align 4
  br label %8

; <label>:8:                                      ; preds = %23, %6
  %9 = load i32, i32* %4, align 4
  %10 = icmp eq i32 %9, 1
  br i1 %10, label %11, label %24

; <label>:11:                                     ; preds = %8
  %12 = load i32, i32* @turn, align 4
  store i32 %12, i32* %5, align 4
  %13 = load i32, i32* %5, align 4
  %14 = icmp ne i32 %13, 1
  br i1 %14, label %15, label %23

; <label>:15:                                     ; preds = %11
  store i32 0, i32* @flag1, align 4
  %16 = load i32, i32* @turn, align 4
  store i32 %16, i32* %5, align 4
  br label %17

; <label>:17:                                     ; preds = %20, %15
  %18 = load i32, i32* %5, align 4
  %19 = icmp ne i32 %18, 1
  br i1 %19, label %20, label %22

; <label>:20:                                     ; preds = %17
  %21 = load i32, i32* @turn, align 4
  store i32 %21, i32* %5, align 4
  br label %17

; <label>:22:                                     ; preds = %17
  store i32 1, i32* @flag1, align 4
  br label %23

; <label>:23:                                     ; preds = %22, %11
  br label %8

; <label>:24:                                     ; preds = %8
  br label %6
                                                  ; No predecessors!
  %26 = load i8*, i8** %2, align 8
  ret i8* %26
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
  call void @__assert_fail(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.1, i32 0, i32 0), i32 55, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.main, i32 0, i32 0)) #5
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
