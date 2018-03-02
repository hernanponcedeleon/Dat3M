; ModuleID = 'Burns.ll'
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

; <label>:3                                       ; preds = %0
  store i32 1, i32* %a, align 4
  %4 = load i32, i32* %a, align 4
  store i32 %4, i32* @x, align 4
  %5 = load i32, i32* @y, align 4
  store i32 %5, i32* %chk, align 4
  br label %6

; <label>:6                                       ; preds = %3
  %7 = load i32, i32* %chk, align 4
  %8 = icmp ne i32 %7, 0
  br i1 %8, label %9, label %11

; <label>:9                                       ; preds = %6
  %10 = load i32, i32* @y, align 4
  store i32 %10, i32* %chk, align 4
  br label %14

; <label>:11                                      ; preds = %14, %6
  br label %19
                                                  ; No predecessors!
  %13 = load i8*, i8** %1, align 8
  ret i8* %13

diverge:                                          ; preds = %17, %diverge
  call void @__VERIFIER_assume(i1 false)
  br label %diverge

; <label>:14                                      ; preds = %9
  %15 = load i32, i32* %chk, align 4
  %16 = icmp ne i32 %15, 0
  br i1 %16, label %17, label %11

; <label>:17                                      ; preds = %28, %14
  %18 = load i32, i32* @y, align 4
  store i32 %18, i32* %chk, align 4
  br label %diverge

diverge1:                                         ; preds = %25, %diverge1
  call void @__VERIFIER_assume(i1 false)
  br label %diverge1

; <label>:19                                      ; preds = %11
  store i32 1, i32* %a, align 4
  %20 = load i32, i32* %a, align 4
  store i32 %20, i32* @x, align 4
  %21 = load i32, i32* @y, align 4
  store i32 %21, i32* %chk, align 4
  br label %22

; <label>:22                                      ; preds = %19
  %23 = load i32, i32* %chk, align 4
  %24 = icmp ne i32 %23, 0
  br i1 %24, label %26, label %25

; <label>:25                                      ; preds = %28, %22
  br label %diverge1

; <label>:26                                      ; preds = %22
  %27 = load i32, i32* @y, align 4
  store i32 %27, i32* %chk, align 4
  br label %28

; <label>:28                                      ; preds = %26
  %29 = load i32, i32* %chk, align 4
  %30 = icmp ne i32 %29, 0
  br i1 %30, label %17, label %25
}

; Function Attrs: nounwind uwtable
define i8* @thrd1(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %chk = alloca i32, align 4
  %b = alloca i32, align 4
  store i8* %args, i8** %2, align 8
  br label %3

; <label>:3                                       ; preds = %0
  %4 = load i32, i32* @x, align 4
  store i32 %4, i32* %chk, align 4
  br label %5

; <label>:5                                       ; preds = %3
  %6 = load i32, i32* %chk, align 4
  %7 = icmp ne i32 %6, 0
  br i1 %7, label %8, label %10

; <label>:8                                       ; preds = %5
  %9 = load i32, i32* @x, align 4
  store i32 %9, i32* %chk, align 4
  br label %15

; <label>:10                                      ; preds = %15, %5
  store i32 1, i32* %b, align 4
  %11 = load i32, i32* %b, align 4
  store i32 %11, i32* @y, align 4
  %12 = load i32, i32* @x, align 4
  store i32 %12, i32* %chk, align 4
  br label %20
                                                  ; No predecessors!
  %14 = load i8*, i8** %1, align 8
  ret i8* %14

diverge:                                          ; preds = %18, %diverge
  call void @__VERIFIER_assume(i1 false)
  br label %diverge

; <label>:15                                      ; preds = %8
  %16 = load i32, i32* %chk, align 4
  %17 = icmp ne i32 %16, 0
  br i1 %17, label %18, label %10

; <label>:18                                      ; preds = %30, %15
  %19 = load i32, i32* @x, align 4
  store i32 %19, i32* %chk, align 4
  br label %diverge

diverge1:                                         ; preds = %25, %diverge1
  call void @__VERIFIER_assume(i1 false)
  br label %diverge1

; <label>:20                                      ; preds = %10
  %21 = load i32, i32* @x, align 4
  store i32 %21, i32* %chk, align 4
  br label %22

; <label>:22                                      ; preds = %20
  %23 = load i32, i32* %chk, align 4
  %24 = icmp ne i32 %23, 0
  br i1 %24, label %28, label %25

; <label>:25                                      ; preds = %30, %22
  store i32 1, i32* %b, align 4
  %26 = load i32, i32* %b, align 4
  store i32 %26, i32* @y, align 4
  %27 = load i32, i32* @x, align 4
  store i32 %27, i32* %chk, align 4
  br label %diverge1

; <label>:28                                      ; preds = %22
  %29 = load i32, i32* @x, align 4
  store i32 %29, i32* %chk, align 4
  br label %30

; <label>:30                                      ; preds = %28
  %31 = load i32, i32* %chk, align 4
  %32 = icmp ne i32 %31, 0
  br i1 %32, label %18, label %25
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
  call void @__assert_fail(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.1, i32 0, i32 0), i32 42, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.main, i32 0, i32 0)) #6
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

; Function Attrs: nounwind
declare void @__VERIFIER_assume(i1) #4

; Function Attrs: nounwind readonly uwtable
define i32 @strcmp(i8* %p1, i8* %p2) #5 {
entry:
  br label %head

head:                                             ; preds = %body, %entry
  %s1 = phi i8* [ %p1, %entry ], [ %s1next, %body ]
  %s2 = phi i8* [ %p2, %entry ], [ %s2next, %body ]
  %a = load i8, i8* %s1, align 1
  %b = load i8, i8* %s2, align 1
  %a0 = icmp eq i8 %a, 0
  br i1 %a0, label %exit, label %body

body:                                             ; preds = %head
  %s1next = getelementptr inbounds i8, i8* %s1, i64 1
  %s2next = getelementptr inbounds i8, i8* %s2, i64 1
  %abeq = icmp eq i8 %a, %b
  br i1 %abeq, label %head, label %exit

exit:                                             ; preds = %body, %head
  %a32 = zext i8 %a to i32
  %b32 = zext i8 %b to i32
  %rv = sub nsw i32 %a32, %b32
  ret i32 %rv
}

define i8* @memset(i8* %s, i32 %_c, i64 %_n) {
entry:
  %c = trunc i32 %_c to i8
  br label %head

head:                                             ; preds = %body, %entry
  %n = phi i64 [ %_n, %entry ], [ %nnext, %body ]
  %ncmp = icmp sgt i64 %n, 0
  br i1 %ncmp, label %body, label %exit

body:                                             ; preds = %head
  %nnext = sub i64 %n, 1
  %scur = getelementptr i8, i8* %s, i64 %nnext
  store i8 %c, i8* %scur
  br label %head

exit:                                             ; preds = %head
  ret i8* %s
}

define i32 @puts(i8* %s) {
entry:
  br label %head

head:                                             ; preds = %body, %entry
  %i = phi i32 [ 0, %entry ], [ %inext, %body ]
  %si = getelementptr i8, i8* %s, i32 %i
  %c = load i8, i8* %si
  %cc = icmp eq i8 %c, 0
  br i1 %cc, label %exit, label %body

body:                                             ; preds = %head
  %ca = zext i8 %c to i32
  %0 = call i32 @putchar(i32 %ca)
  %inext = add i32 %i, 1
  br label %head

exit:                                             ; preds = %head
  %1 = call i32 @putchar(i32 10)
  ret i32 1
}

declare i32 @putchar(i32)

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }
attributes #5 = { nounwind readonly uwtable }
attributes #6 = { noreturn nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.8.0-2ubuntu4 (tags/RELEASE_380/final)"}
