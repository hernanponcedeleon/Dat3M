; ModuleID = 'Bakery.ll'
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

; <label>:3                                       ; preds = %0
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

; <label>:11                                      ; preds = %3
  %12 = load i32, i32* %chk, align 4
  %13 = icmp ne i32 %12, 0
  br i1 %13, label %14, label %16

; <label>:14                                      ; preds = %11
  %15 = load i32, i32* @c1, align 4
  store i32 %15, i32* %chk, align 4
  br label %32

; <label>:16                                      ; preds = %32, %11
  %17 = load i32, i32* @n1, align 4
  store i32 %17, i32* %r0, align 4
  br label %18

; <label>:18                                      ; preds = %16
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
  br label %37

; <label>:29                                      ; preds = %44, %25
  br label %48
                                                  ; No predecessors!
  %31 = load i8*, i8** %1, align 8
  ret i8* %31

diverge:                                          ; preds = %35, %diverge
  call void @__VERIFIER_assume(i1 false)
  br label %diverge

; <label>:32                                      ; preds = %14
  %33 = load i32, i32* %chk, align 4
  %34 = icmp ne i32 %33, 0
  br i1 %34, label %35, label %16

; <label>:35                                      ; preds = %75, %32
  %36 = load i32, i32* @c1, align 4
  store i32 %36, i32* %chk, align 4
  br label %diverge

diverge1:                                         ; preds = %46, %diverge1
  call void @__VERIFIER_assume(i1 false)
  br label %diverge1

; <label>:37                                      ; preds = %27
  %38 = load i32, i32* %r0, align 4
  %39 = icmp ne i32 %38, 0
  br i1 %39, label %40, label %44

; <label>:40                                      ; preds = %37
  %41 = load i32, i32* %r0, align 4
  %42 = load i32, i32* %r1, align 4
  %43 = icmp slt i32 %41, %42
  br label %44

; <label>:44                                      ; preds = %40, %37
  %45 = phi i1 [ false, %37 ], [ %43, %40 ]
  br i1 %45, label %46, label %29

; <label>:46                                      ; preds = %85, %44
  %47 = load i32, i32* @n1, align 4
  store i32 %47, i32* %r0, align 4
  br label %diverge1

diverge2:                                         ; preds = %70, %diverge2
  call void @__VERIFIER_assume(i1 false)
  br label %diverge2

; <label>:48                                      ; preds = %29
  store i32 1, i32* %a0, align 4
  %49 = load i32, i32* %a0, align 4
  store i32 %49, i32* @c0, align 4
  %50 = load i32, i32* @n1, align 4
  store i32 %50, i32* %r0, align 4
  %51 = load i32, i32* %r0, align 4
  %52 = add nsw i32 %51, 1
  store i32 %52, i32* %r1, align 4
  %53 = load i32, i32* %r1, align 4
  store i32 %53, i32* @n0, align 4
  store i32 0, i32* %a1, align 4
  %54 = load i32, i32* %a1, align 4
  store i32 %54, i32* @c0, align 4
  %55 = load i32, i32* @c1, align 4
  store i32 %55, i32* %chk, align 4
  br label %56

; <label>:56                                      ; preds = %48
  %57 = load i32, i32* %chk, align 4
  %58 = icmp ne i32 %57, 0
  br i1 %58, label %73, label %59

; <label>:59                                      ; preds = %75, %56
  %60 = load i32, i32* @n1, align 4
  store i32 %60, i32* %r0, align 4
  br label %61

; <label>:61                                      ; preds = %59
  %62 = load i32, i32* %r0, align 4
  %63 = icmp ne i32 %62, 0
  br i1 %63, label %64, label %68

; <label>:64                                      ; preds = %61
  %65 = load i32, i32* %r0, align 4
  %66 = load i32, i32* %r1, align 4
  %67 = icmp slt i32 %65, %66
  br label %68

; <label>:68                                      ; preds = %64, %61
  %69 = phi i1 [ false, %61 ], [ %67, %64 ]
  br i1 %69, label %71, label %70

; <label>:70                                      ; preds = %85, %68
  br label %diverge2

; <label>:71                                      ; preds = %68
  %72 = load i32, i32* @n1, align 4
  store i32 %72, i32* %r0, align 4
  br label %78

; <label>:73                                      ; preds = %56
  %74 = load i32, i32* @c1, align 4
  store i32 %74, i32* %chk, align 4
  br label %75

; <label>:75                                      ; preds = %73
  %76 = load i32, i32* %chk, align 4
  %77 = icmp ne i32 %76, 0
  br i1 %77, label %35, label %59

; <label>:78                                      ; preds = %71
  %79 = load i32, i32* %r0, align 4
  %80 = icmp ne i32 %79, 0
  br i1 %80, label %81, label %85

; <label>:81                                      ; preds = %78
  %82 = load i32, i32* %r0, align 4
  %83 = load i32, i32* %r1, align 4
  %84 = icmp slt i32 %82, %83
  br label %85

; <label>:85                                      ; preds = %81, %78
  %86 = phi i1 [ false, %78 ], [ %84, %81 ]
  br i1 %86, label %46, label %70
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

; <label>:3                                       ; preds = %0
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

; <label>:11                                      ; preds = %3
  %12 = load i32, i32* %chk, align 4
  %13 = icmp ne i32 %12, 0
  br i1 %13, label %14, label %16

; <label>:14                                      ; preds = %11
  %15 = load i32, i32* @c0, align 4
  store i32 %15, i32* %chk, align 4
  br label %32

; <label>:16                                      ; preds = %32, %11
  %17 = load i32, i32* @n0, align 4
  store i32 %17, i32* %q0, align 4
  br label %18

; <label>:18                                      ; preds = %16
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
  br label %37

; <label>:29                                      ; preds = %44, %25
  br label %48
                                                  ; No predecessors!
  %31 = load i8*, i8** %1, align 8
  ret i8* %31

diverge:                                          ; preds = %35, %diverge
  call void @__VERIFIER_assume(i1 false)
  br label %diverge

; <label>:32                                      ; preds = %14
  %33 = load i32, i32* %chk, align 4
  %34 = icmp ne i32 %33, 0
  br i1 %34, label %35, label %16

; <label>:35                                      ; preds = %75, %32
  %36 = load i32, i32* @c0, align 4
  store i32 %36, i32* %chk, align 4
  br label %diverge

diverge1:                                         ; preds = %46, %diverge1
  call void @__VERIFIER_assume(i1 false)
  br label %diverge1

; <label>:37                                      ; preds = %27
  %38 = load i32, i32* %q0, align 4
  %39 = icmp ne i32 %38, 0
  br i1 %39, label %40, label %44

; <label>:40                                      ; preds = %37
  %41 = load i32, i32* %q0, align 4
  %42 = load i32, i32* %q1, align 4
  %43 = icmp slt i32 %41, %42
  br label %44

; <label>:44                                      ; preds = %40, %37
  %45 = phi i1 [ false, %37 ], [ %43, %40 ]
  br i1 %45, label %46, label %29

; <label>:46                                      ; preds = %85, %44
  %47 = load i32, i32* @n0, align 4
  store i32 %47, i32* %q0, align 4
  br label %diverge1

diverge2:                                         ; preds = %70, %diverge2
  call void @__VERIFIER_assume(i1 false)
  br label %diverge2

; <label>:48                                      ; preds = %29
  store i32 1, i32* %b0, align 4
  %49 = load i32, i32* %b0, align 4
  store i32 %49, i32* @c1, align 4
  %50 = load i32, i32* @n0, align 4
  store i32 %50, i32* %q0, align 4
  %51 = load i32, i32* %q0, align 4
  %52 = add nsw i32 %51, 1
  store i32 %52, i32* %q1, align 4
  %53 = load i32, i32* %q1, align 4
  store i32 %53, i32* @n1, align 4
  store i32 0, i32* %b1, align 4
  %54 = load i32, i32* %b1, align 4
  store i32 %54, i32* @c1, align 4
  %55 = load i32, i32* @c0, align 4
  store i32 %55, i32* %chk, align 4
  br label %56

; <label>:56                                      ; preds = %48
  %57 = load i32, i32* %chk, align 4
  %58 = icmp ne i32 %57, 0
  br i1 %58, label %73, label %59

; <label>:59                                      ; preds = %75, %56
  %60 = load i32, i32* @n0, align 4
  store i32 %60, i32* %q0, align 4
  br label %61

; <label>:61                                      ; preds = %59
  %62 = load i32, i32* %q0, align 4
  %63 = icmp ne i32 %62, 0
  br i1 %63, label %64, label %68

; <label>:64                                      ; preds = %61
  %65 = load i32, i32* %q0, align 4
  %66 = load i32, i32* %q1, align 4
  %67 = icmp slt i32 %65, %66
  br label %68

; <label>:68                                      ; preds = %64, %61
  %69 = phi i1 [ false, %61 ], [ %67, %64 ]
  br i1 %69, label %71, label %70

; <label>:70                                      ; preds = %85, %68
  br label %diverge2

; <label>:71                                      ; preds = %68
  %72 = load i32, i32* @n0, align 4
  store i32 %72, i32* %q0, align 4
  br label %78

; <label>:73                                      ; preds = %56
  %74 = load i32, i32* @c0, align 4
  store i32 %74, i32* %chk, align 4
  br label %75

; <label>:75                                      ; preds = %73
  %76 = load i32, i32* %chk, align 4
  %77 = icmp ne i32 %76, 0
  br i1 %77, label %35, label %59

; <label>:78                                      ; preds = %71
  %79 = load i32, i32* %q0, align 4
  %80 = icmp ne i32 %79, 0
  br i1 %80, label %81, label %85

; <label>:81                                      ; preds = %78
  %82 = load i32, i32* %q0, align 4
  %83 = load i32, i32* %q1, align 4
  %84 = icmp slt i32 %82, %83
  br label %85

; <label>:85                                      ; preds = %81, %78
  %86 = phi i1 [ false, %78 ], [ %84, %81 ]
  br i1 %86, label %46, label %70
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
