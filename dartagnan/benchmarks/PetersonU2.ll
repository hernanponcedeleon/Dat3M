; ModuleID = 'Peterson.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@flag0 = global i32 0, align 4
@flag1 = global i32 0, align 4
@turn = global i32 0, align 4

; Function Attrs: nounwind uwtable
define i8* @thrd0(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %a = alloca i32, align 4
  %f1 = alloca i32, align 4
  %t0 = alloca i32, align 4
  store i8* %args, i8** %1, align 8
  store i32 1, i32* %a, align 4
  %2 = load i32, i32* %a, align 4
  store i32 %2, i32* @flag0, align 4
  %3 = load i32, i32* %a, align 4
  store i32 %3, i32* @turn, align 4
  %4 = load i32, i32* @flag1, align 4
  store i32 %4, i32* %f1, align 4
  %5 = load i32, i32* @turn, align 4
  store i32 %5, i32* %t0, align 4
  br label %6

; <label>:6                                       ; preds = %0
  %7 = load i32, i32* %f1, align 4
  %8 = icmp eq i32 %7, 1
  br i1 %8, label %9, label %12

; <label>:9                                       ; preds = %6
  %10 = load i32, i32* %t0, align 4
  %11 = icmp eq i32 %10, 1
  br label %12

; <label>:12                                      ; preds = %9, %6
  %13 = phi i1 [ false, %6 ], [ %11, %9 ]
  br i1 %13, label %14, label %17

; <label>:14                                      ; preds = %12
  %15 = load i32, i32* @flag1, align 4
  store i32 %15, i32* %f1, align 4
  %16 = load i32, i32* @turn, align 4
  store i32 %16, i32* %t0, align 4
  br label %18

; <label>:17                                      ; preds = %24, %12
  ret i8* null

diverge:                                          ; preds = %26, %diverge
  call void @__VERIFIER_assume(i1 false)
  br label %diverge

; <label>:18                                      ; preds = %14
  %19 = load i32, i32* %f1, align 4
  %20 = icmp eq i32 %19, 1
  br i1 %20, label %21, label %24

; <label>:21                                      ; preds = %18
  %22 = load i32, i32* %t0, align 4
  %23 = icmp eq i32 %22, 1
  br label %24

; <label>:24                                      ; preds = %21, %18
  %25 = phi i1 [ false, %18 ], [ %23, %21 ]
  br i1 %25, label %26, label %17

; <label>:26                                      ; preds = %24
  %27 = load i32, i32* @flag1, align 4
  store i32 %27, i32* %f1, align 4
  %28 = load i32, i32* @turn, align 4
  store i32 %28, i32* %t0, align 4
  br label %diverge
}

; Function Attrs: nounwind uwtable
define i8* @thrd1(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %b = alloca i32, align 4
  %c = alloca i32, align 4
  %f0 = alloca i32, align 4
  %t1 = alloca i32, align 4
  store i8* %args, i8** %1, align 8
  store i32 1, i32* %b, align 4
  store i32 0, i32* %c, align 4
  %2 = load i32, i32* %b, align 4
  store i32 %2, i32* @flag1, align 4
  %3 = load i32, i32* %c, align 4
  store i32 %3, i32* @turn, align 4
  %4 = load i32, i32* @flag0, align 4
  store i32 %4, i32* %f0, align 4
  %5 = load i32, i32* @turn, align 4
  store i32 %5, i32* %t1, align 4
  br label %6

; <label>:6                                       ; preds = %0
  %7 = load i32, i32* %f0, align 4
  %8 = icmp eq i32 %7, 1
  br i1 %8, label %9, label %12

; <label>:9                                       ; preds = %6
  %10 = load i32, i32* %t1, align 4
  %11 = icmp eq i32 %10, 0
  br label %12

; <label>:12                                      ; preds = %9, %6
  %13 = phi i1 [ false, %6 ], [ %11, %9 ]
  br i1 %13, label %14, label %17

; <label>:14                                      ; preds = %12
  %15 = load i32, i32* @flag0, align 4
  store i32 %15, i32* %f0, align 4
  %16 = load i32, i32* @turn, align 4
  store i32 %16, i32* %t1, align 4
  br label %18

; <label>:17                                      ; preds = %24, %12
  ret i8* null

diverge:                                          ; preds = %26, %diverge
  call void @__VERIFIER_assume(i1 false)
  br label %diverge

; <label>:18                                      ; preds = %14
  %19 = load i32, i32* %f0, align 4
  %20 = icmp eq i32 %19, 1
  br i1 %20, label %21, label %24

; <label>:21                                      ; preds = %18
  %22 = load i32, i32* %t1, align 4
  %23 = icmp eq i32 %22, 0
  br label %24

; <label>:24                                      ; preds = %21, %18
  %25 = phi i1 [ false, %18 ], [ %23, %21 ]
  br i1 %25, label %26, label %17

; <label>:26                                      ; preds = %24
  %27 = load i32, i32* @flag0, align 4
  store i32 %27, i32* %f0, align 4
  %28 = load i32, i32* @turn, align 4
  store i32 %28, i32* %t1, align 4
  br label %diverge
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

; Function Attrs: nounwind
declare void @__VERIFIER_assume(i1) #3

; Function Attrs: nounwind readonly uwtable
define i32 @strcmp(i8* %p1, i8* %p2) #4 {
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
attributes #3 = { nounwind }
attributes #4 = { nounwind readonly uwtable }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.8.0-2ubuntu4 (tags/RELEASE_380/final)"}
