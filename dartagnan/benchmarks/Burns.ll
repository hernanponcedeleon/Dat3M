; ModuleID = 'Burns.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@x = global i32 0, align 4
@y = global i32 0, align 4
@.str = private unnamed_addr constant [13 x i8] c"x==0 && y==0\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"Burns.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [23 x i8] c"int main(int, char **)\00", align 1

; Function Attrs: nounwind uwtable
define i8* @thrd0(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %a = alloca i32, align 4
  %chk = alloca i32, align 4
  store i8* %args, i8** %2, align 8
  br label %3

; <label>:3                                       ; preds = %0, %11
  store i32 1, i32* %a, align 4
  %4 = load i32, i32* %a, align 4
  store i32 %4, i32* @x, align 4
  %5 = load i32, i32* @y, align 4
  store i32 %5, i32* %chk, align 4
  br label %6

; <label>:6                                       ; preds = %9, %3
  %7 = load i32, i32* %chk, align 4
  %8 = icmp ne i32 %7, 0
  br i1 %8, label %9, label %11

; <label>:9                                       ; preds = %6
  %10 = load i32, i32* @y, align 4
  store i32 %10, i32* %chk, align 4
  br label %6

; <label>:11                                      ; preds = %6
  br label %3
                                                  ; No predecessors!
  %13 = load i8*, i8** %1, align 8
  ret i8* %13
}

; Function Attrs: nounwind uwtable
define i8* @thrd1(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %chk = alloca i32, align 4
  %b = alloca i32, align 4
  store i8* %args, i8** %2, align 8
  br label %3

; <label>:3                                       ; preds = %0, %10
  %4 = load i32, i32* @x, align 4
  store i32 %4, i32* %chk, align 4
  br label %5

; <label>:5                                       ; preds = %8, %3
  %6 = load i32, i32* %chk, align 4
  %7 = icmp ne i32 %6, 0
  br i1 %7, label %8, label %10

; <label>:8                                       ; preds = %5
  %9 = load i32, i32* @x, align 4
  store i32 %9, i32* %chk, align 4
  br label %5

; <label>:10                                      ; preds = %5
  store i32 1, i32* %b, align 4
  %11 = load i32, i32* %b, align 4
  store i32 %11, i32* @y, align 4
  %12 = load i32, i32* @x, align 4
  store i32 %12, i32* %chk, align 4
  br label %3
                                                  ; No predecessors!
  %14 = load i8*, i8** %1, align 8
  ret i8* %14
}

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8**, align 8
  %t0 = alloca i64, align 8
  %t1 = alloca i64, align 8
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  store i32 0, i32* %1, align 4
  store i32 %argc, i32* %2, align 4
  store i8** %argv, i8*** %3, align 8
  %4 = call i32 @pthread_create(i64* %t0, %union.pthread_attr_t* null, i8* (i8*)* @thrd0, i8* null) #4
  %5 = call i32 @pthread_create(i64* %t1, %union.pthread_attr_t* null, i8* (i8*)* @thrd1, i8* null) #4
  %6 = load i64, i64* %t0, align 8
  %7 = call i32 @pthread_join(i64 %6, i8** null)
  store i32 %7, i32* %x, align 4
  %8 = load i64, i64* %t1, align 8
  %9 = call i32 @pthread_join(i64 %8, i8** null)
  store i32 %9, i32* %y, align 4
  %10 = load i32, i32* %x, align 4
  %11 = icmp eq i32 %10, 0
  br i1 %11, label %12, label %16

; <label>:12                                      ; preds = %0
  %13 = load i32, i32* %y, align 4
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %15, label %16

; <label>:15                                      ; preds = %12
  br label %18

; <label>:16                                      ; preds = %12, %0
  call void @__assert_fail(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.1, i32 0, i32 0), i32 42, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.main, i32 0, i32 0)) #5
  unreachable
                                                  ; No predecessors!
  br label %18

; <label>:18                                      ; preds = %17, %15
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
