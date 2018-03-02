; ModuleID = 'Lamport.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = global i32 0, align 4
@y = global i32 0, align 4
@b1 = global i32 0, align 4
@b2 = global i32 0, align 4
@b3 = global i32 0, align 4
@.str = private unnamed_addr constant [21 x i8] c"x==0 && y==0 && z==0\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"Lamport.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [23 x i8] c"int main(int, char **)\00", align 1

; Function Attrs: nounwind uwtable
define i8* @thrd0(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %t = alloca i32, align 4
  %f = alloca i32, align 4
  %i = alloca i32, align 4
  %y1 = alloca i32, align 4
  %x1 = alloca i32, align 4
  store i8* %args, i8** %2, align 8
  br label %3

; <label>:3                                       ; preds = %0, %18
  store i32 1, i32* %t, align 4
  store i32 0, i32* %f, align 4
  %4 = load i32, i32* %t, align 4
  store i32 %4, i32* @b1, align 4
  store i32 1, i32* %i, align 4
  %5 = load i32, i32* %i, align 4
  store i32 %5, i32* @x, align 4
  %6 = load i32, i32* @y, align 4
  store i32 %6, i32* %y1, align 4
  %7 = load i32, i32* %y1, align 4
  %8 = icmp ne i32 %7, 0
  br i1 %8, label %9, label %11

; <label>:9                                       ; preds = %3
  %10 = load i32, i32* %f, align 4
  store i32 %10, i32* @b1, align 4
  br label %11

; <label>:11                                      ; preds = %9, %3
  %12 = load i32, i32* %i, align 4
  store i32 %12, i32* @y, align 4
  %13 = load i32, i32* @x, align 4
  store i32 %13, i32* %x1, align 4
  %14 = load i32, i32* %x1, align 4
  %15 = icmp ne i32 %14, 1
  br i1 %15, label %16, label %18

; <label>:16                                      ; preds = %11
  %17 = load i32, i32* %f, align 4
  store i32 %17, i32* @b1, align 4
  br label %18

; <label>:18                                      ; preds = %16, %11
  br label %3
                                                  ; No predecessors!
  %20 = load i8*, i8** %1, align 8
  ret i8* %20
}

; Function Attrs: nounwind uwtable
define i8* @thrd1(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %t = alloca i32, align 4
  %f = alloca i32, align 4
  %i = alloca i32, align 4
  %y1 = alloca i32, align 4
  %x1 = alloca i32, align 4
  store i8* %args, i8** %2, align 8
  br label %3

; <label>:3                                       ; preds = %0, %18
  store i32 1, i32* %t, align 4
  store i32 0, i32* %f, align 4
  %4 = load i32, i32* %t, align 4
  store i32 %4, i32* @b2, align 4
  store i32 2, i32* %i, align 4
  %5 = load i32, i32* %i, align 4
  store i32 %5, i32* @x, align 4
  %6 = load i32, i32* @y, align 4
  store i32 %6, i32* %y1, align 4
  %7 = load i32, i32* %y1, align 4
  %8 = icmp ne i32 %7, 0
  br i1 %8, label %9, label %11

; <label>:9                                       ; preds = %3
  %10 = load i32, i32* %f, align 4
  store i32 %10, i32* @b2, align 4
  br label %11

; <label>:11                                      ; preds = %9, %3
  %12 = load i32, i32* %i, align 4
  store i32 %12, i32* @y, align 4
  %13 = load i32, i32* @x, align 4
  store i32 %13, i32* %x1, align 4
  %14 = load i32, i32* %x1, align 4
  %15 = icmp ne i32 %14, 2
  br i1 %15, label %16, label %18

; <label>:16                                      ; preds = %11
  %17 = load i32, i32* %f, align 4
  store i32 %17, i32* @b2, align 4
  br label %18

; <label>:18                                      ; preds = %16, %11
  br label %3
                                                  ; No predecessors!
  %20 = load i8*, i8** %1, align 8
  ret i8* %20
}

; Function Attrs: nounwind uwtable
define i8* @thrd2(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %t = alloca i32, align 4
  %f = alloca i32, align 4
  %i = alloca i32, align 4
  %y1 = alloca i32, align 4
  %x1 = alloca i32, align 4
  store i8* %args, i8** %2, align 8
  br label %3

; <label>:3                                       ; preds = %0, %18
  store i32 1, i32* %t, align 4
  store i32 0, i32* %f, align 4
  %4 = load i32, i32* %t, align 4
  store i32 %4, i32* @b3, align 4
  store i32 3, i32* %i, align 4
  %5 = load i32, i32* %i, align 4
  store i32 %5, i32* @x, align 4
  %6 = load i32, i32* @y, align 4
  store i32 %6, i32* %y1, align 4
  %7 = load i32, i32* %y1, align 4
  %8 = icmp ne i32 %7, 0
  br i1 %8, label %9, label %11

; <label>:9                                       ; preds = %3
  %10 = load i32, i32* %f, align 4
  store i32 %10, i32* @b3, align 4
  br label %11

; <label>:11                                      ; preds = %9, %3
  %12 = load i32, i32* %i, align 4
  store i32 %12, i32* @y, align 4
  %13 = load i32, i32* @x, align 4
  store i32 %13, i32* %x1, align 4
  %14 = load i32, i32* %x1, align 4
  %15 = icmp ne i32 %14, 3
  br i1 %15, label %16, label %18

; <label>:16                                      ; preds = %11
  %17 = load i32, i32* %f, align 4
  store i32 %17, i32* @b3, align 4
  br label %18

; <label>:18                                      ; preds = %16, %11
  br label %3
                                                  ; No predecessors!
  %20 = load i8*, i8** %1, align 8
  ret i8* %20
}

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8**, align 8
  %t0 = alloca i64, align 8
  %t1 = alloca i64, align 8
  %t2 = alloca i64, align 8
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %z = alloca i32, align 4
  store i32 0, i32* %1, align 4
  store i32 %argc, i32* %2, align 4
  store i8** %argv, i8*** %3, align 8
  %4 = call i32 @pthread_create(i64* %t0, %union.pthread_attr_t* null, i8* (i8*)* @thrd0, i8* null) #4
  %5 = call i32 @pthread_create(i64* %t1, %union.pthread_attr_t* null, i8* (i8*)* @thrd1, i8* null) #4
  %6 = call i32 @pthread_create(i64* %t2, %union.pthread_attr_t* null, i8* (i8*)* @thrd2, i8* null) #4
  %7 = load i64, i64* %t0, align 8
  %8 = call i32 @pthread_join(i64 %7, i8** null)
  store i32 %8, i32* %x, align 4
  %9 = load i64, i64* %t1, align 8
  %10 = call i32 @pthread_join(i64 %9, i8** null)
  store i32 %10, i32* %y, align 4
  %11 = load i64, i64* %t2, align 8
  %12 = call i32 @pthread_join(i64 %11, i8** null)
  store i32 %12, i32* %z, align 4
  %13 = load i32, i32* %x, align 4
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %15, label %22

; <label>:15                                      ; preds = %0
  %16 = load i32, i32* %y, align 4
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %18, label %22

; <label>:18                                      ; preds = %15
  %19 = load i32, i32* %z, align 4
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %21, label %22

; <label>:21                                      ; preds = %18
  br label %24

; <label>:22                                      ; preds = %18, %15, %0
  call void @__assert_fail(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.1, i32 0, i32 0), i32 80, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.main, i32 0, i32 0)) #5
  unreachable
                                                  ; No predecessors!
  br label %24

; <label>:24                                      ; preds = %23, %21
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*) #1

declare i32 @pthread_join(i64, i8**) #2

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8*, i8*, i32, i8*) #3

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }
attributes #5 = { noreturn nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.8.0-2ubuntu4 (tags/RELEASE_380/final)"}
