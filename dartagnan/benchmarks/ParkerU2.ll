; ModuleID = 'Parker.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@cond = global i32 0, align 4
@parkCounter = global i32 0, align 4

; Function Attrs: nounwind uwtable
define i8* @thrd0(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %c = alloca i32, align 4
  %counter = alloca i32, align 4
  %a = alloca i32, align 4
  store i8* %args, i8** %1, align 8
  %2 = load i32, i32* @cond, align 4
  store i32 %2, i32* %c, align 4
  br label %3

; <label>:3                                       ; preds = %0
  %4 = load i32, i32* %c, align 4
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %6, label %10

; <label>:6                                       ; preds = %3
  %7 = load i32, i32* @parkCounter, align 4
  store i32 %7, i32* %counter, align 4
  store i32 0, i32* %a, align 4
  %8 = load i32, i32* %a, align 4
  store i32 %8, i32* @parkCounter, align 4
  %9 = load i32, i32* @cond, align 4
  store i32 %9, i32* %c, align 4
  br label %11

; <label>:10                                      ; preds = %11, %3
  ret i8* null

diverge:                                          ; preds = %14, %diverge
  call void @__VERIFIER_assume(i1 false)
  br label %diverge

; <label>:11                                      ; preds = %6
  %12 = load i32, i32* %c, align 4
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %14, label %10

; <label>:14                                      ; preds = %11
  %15 = load i32, i32* @parkCounter, align 4
  store i32 %15, i32* %counter, align 4
  store i32 0, i32* %a, align 4
  %16 = load i32, i32* %a, align 4
  store i32 %16, i32* @parkCounter, align 4
  %17 = load i32, i32* @cond, align 4
  store i32 %17, i32* %c, align 4
  br label %diverge
}

; Function Attrs: nounwind uwtable
define i8* @thrd1(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %b = alloca i32, align 4
  store i8* %args, i8** %1, align 8
  store i32 1, i32* %b, align 4
  %2 = load i32, i32* %b, align 4
  store i32 %2, i32* @cond, align 4
  %3 = load i32, i32* %b, align 4
  store i32 %3, i32* @parkCounter, align 4
  ret i8* null
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
