; ModuleID = 'Dekker.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@flag0 = global i32 0, align 4
@flag1 = global i32 0, align 4
@turn = global i32 0, align 4

; Function Attrs: nounwind uwtable
define i8* @thrd0(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %f1 = alloca i32, align 4
  %t1 = alloca i32, align 4
  store i8* %args, i8** %2, align 8
  br label %3

; <label>:3                                       ; preds = %0
  store i32 1, i32* %a, align 4
  store i32 0, i32* %b, align 4
  %4 = load i32, i32* %a, align 4
  store i32 %4, i32* @flag0, align 4
  %5 = load i32, i32* @flag1, align 4
  store i32 %5, i32* %f1, align 4
  br label %6

; <label>:6                                       ; preds = %3
  %7 = load i32, i32* %f1, align 4
  %8 = icmp eq i32 %7, 1
  br i1 %8, label %9, label %24

; <label>:9                                       ; preds = %6
  %10 = load i32, i32* @turn, align 4
  store i32 %10, i32* %t1, align 4
  %11 = load i32, i32* %t1, align 4
  %12 = icmp ne i32 %11, 0
  br i1 %12, label %13, label %23

; <label>:13                                      ; preds = %9
  %14 = load i32, i32* %b, align 4
  store i32 %14, i32* @flag0, align 4
  %15 = load i32, i32* @turn, align 4
  store i32 %15, i32* %t1, align 4
  br label %16

; <label>:16                                      ; preds = %13
  %17 = load i32, i32* %t1, align 4
  %18 = icmp ne i32 %17, 0
  br i1 %18, label %19, label %21

; <label>:19                                      ; preds = %16
  %20 = load i32, i32* @turn, align 4
  store i32 %20, i32* %t1, align 4
  br label %27

; <label>:21                                      ; preds = %27, %16
  %22 = load i32, i32* %a, align 4
  store i32 %22, i32* @flag0, align 4
  br label %23

; <label>:23                                      ; preds = %21, %9
  br label %32

; <label>:24                                      ; preds = %32, %6
  br label %53
                                                  ; No predecessors!
  %26 = load i8*, i8** %1, align 8
  ret i8* %26

diverge:                                          ; preds = %30, %diverge
  call void @__VERIFIER_assume(i1 false)
  br label %diverge

; <label>:27                                      ; preds = %19
  %28 = load i32, i32* %t1, align 4
  %29 = icmp ne i32 %28, 0
  br i1 %29, label %30, label %21

; <label>:30                                      ; preds = %75, %50, %27
  %31 = load i32, i32* @turn, align 4
  store i32 %31, i32* %t1, align 4
  br label %diverge

diverge1:                                         ; preds = %47, %diverge1
  call void @__VERIFIER_assume(i1 false)
  br label %diverge1

; <label>:32                                      ; preds = %23
  %33 = load i32, i32* %f1, align 4
  %34 = icmp eq i32 %33, 1
  br i1 %34, label %35, label %24

; <label>:35                                      ; preds = %78, %32
  %36 = load i32, i32* @turn, align 4
  store i32 %36, i32* %t1, align 4
  %37 = load i32, i32* %t1, align 4
  %38 = icmp ne i32 %37, 0
  br i1 %38, label %39, label %47

; <label>:39                                      ; preds = %35
  %40 = load i32, i32* %b, align 4
  store i32 %40, i32* @flag0, align 4
  %41 = load i32, i32* @turn, align 4
  store i32 %41, i32* %t1, align 4
  br label %42

; <label>:42                                      ; preds = %39
  %43 = load i32, i32* %t1, align 4
  %44 = icmp ne i32 %43, 0
  br i1 %44, label %48, label %45

; <label>:45                                      ; preds = %50, %42
  %46 = load i32, i32* %a, align 4
  store i32 %46, i32* @flag0, align 4
  br label %47

; <label>:47                                      ; preds = %45, %35
  br label %diverge1

; <label>:48                                      ; preds = %42
  %49 = load i32, i32* @turn, align 4
  store i32 %49, i32* %t1, align 4
  br label %50

; <label>:50                                      ; preds = %48
  %51 = load i32, i32* %t1, align 4
  %52 = icmp ne i32 %51, 0
  br i1 %52, label %30, label %45

diverge2:                                         ; preds = %59, %diverge2
  call void @__VERIFIER_assume(i1 false)
  br label %diverge2

; <label>:53                                      ; preds = %24
  store i32 1, i32* %a, align 4
  store i32 0, i32* %b, align 4
  %54 = load i32, i32* %a, align 4
  store i32 %54, i32* @flag0, align 4
  %55 = load i32, i32* @flag1, align 4
  store i32 %55, i32* %f1, align 4
  br label %56

; <label>:56                                      ; preds = %53
  %57 = load i32, i32* %f1, align 4
  %58 = icmp eq i32 %57, 1
  br i1 %58, label %60, label %59

; <label>:59                                      ; preds = %78, %56
  br label %diverge2

; <label>:60                                      ; preds = %56
  %61 = load i32, i32* @turn, align 4
  store i32 %61, i32* %t1, align 4
  %62 = load i32, i32* %t1, align 4
  %63 = icmp ne i32 %62, 0
  br i1 %63, label %64, label %72

; <label>:64                                      ; preds = %60
  %65 = load i32, i32* %b, align 4
  store i32 %65, i32* @flag0, align 4
  %66 = load i32, i32* @turn, align 4
  store i32 %66, i32* %t1, align 4
  br label %67

; <label>:67                                      ; preds = %64
  %68 = load i32, i32* %t1, align 4
  %69 = icmp ne i32 %68, 0
  br i1 %69, label %73, label %70

; <label>:70                                      ; preds = %75, %67
  %71 = load i32, i32* %a, align 4
  store i32 %71, i32* @flag0, align 4
  br label %72

; <label>:72                                      ; preds = %70, %60
  br label %78

; <label>:73                                      ; preds = %67
  %74 = load i32, i32* @turn, align 4
  store i32 %74, i32* %t1, align 4
  br label %75

; <label>:75                                      ; preds = %73
  %76 = load i32, i32* %t1, align 4
  %77 = icmp ne i32 %76, 0
  br i1 %77, label %30, label %70

; <label>:78                                      ; preds = %72
  %79 = load i32, i32* %f1, align 4
  %80 = icmp eq i32 %79, 1
  br i1 %80, label %35, label %59
}

; Function Attrs: nounwind uwtable
define i8* @thrd1(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %c = alloca i32, align 4
  %d = alloca i32, align 4
  %f2 = alloca i32, align 4
  %t2 = alloca i32, align 4
  store i8* %args, i8** %2, align 8
  br label %3

; <label>:3                                       ; preds = %0
  store i32 1, i32* %c, align 4
  store i32 0, i32* %d, align 4
  %4 = load i32, i32* %c, align 4
  store i32 %4, i32* @flag1, align 4
  %5 = load i32, i32* @flag0, align 4
  store i32 %5, i32* %f2, align 4
  br label %6

; <label>:6                                       ; preds = %3
  %7 = load i32, i32* %f2, align 4
  %8 = icmp eq i32 %7, 1
  br i1 %8, label %9, label %24

; <label>:9                                       ; preds = %6
  %10 = load i32, i32* @turn, align 4
  store i32 %10, i32* %t2, align 4
  %11 = load i32, i32* %t2, align 4
  %12 = icmp ne i32 %11, 1
  br i1 %12, label %13, label %23

; <label>:13                                      ; preds = %9
  %14 = load i32, i32* %d, align 4
  store i32 %14, i32* @flag1, align 4
  %15 = load i32, i32* @turn, align 4
  store i32 %15, i32* %t2, align 4
  br label %16

; <label>:16                                      ; preds = %13
  %17 = load i32, i32* %t2, align 4
  %18 = icmp ne i32 %17, 1
  br i1 %18, label %19, label %21

; <label>:19                                      ; preds = %16
  %20 = load i32, i32* @turn, align 4
  store i32 %20, i32* %t2, align 4
  br label %27

; <label>:21                                      ; preds = %27, %16
  %22 = load i32, i32* %c, align 4
  store i32 %22, i32* @flag1, align 4
  br label %23

; <label>:23                                      ; preds = %21, %9
  br label %32

; <label>:24                                      ; preds = %32, %6
  br label %53
                                                  ; No predecessors!
  %26 = load i8*, i8** %1, align 8
  ret i8* %26

diverge:                                          ; preds = %30, %diverge
  call void @__VERIFIER_assume(i1 false)
  br label %diverge

; <label>:27                                      ; preds = %19
  %28 = load i32, i32* %t2, align 4
  %29 = icmp ne i32 %28, 1
  br i1 %29, label %30, label %21

; <label>:30                                      ; preds = %75, %50, %27
  %31 = load i32, i32* @turn, align 4
  store i32 %31, i32* %t2, align 4
  br label %diverge

diverge1:                                         ; preds = %47, %diverge1
  call void @__VERIFIER_assume(i1 false)
  br label %diverge1

; <label>:32                                      ; preds = %23
  %33 = load i32, i32* %f2, align 4
  %34 = icmp eq i32 %33, 1
  br i1 %34, label %35, label %24

; <label>:35                                      ; preds = %78, %32
  %36 = load i32, i32* @turn, align 4
  store i32 %36, i32* %t2, align 4
  %37 = load i32, i32* %t2, align 4
  %38 = icmp ne i32 %37, 1
  br i1 %38, label %39, label %47

; <label>:39                                      ; preds = %35
  %40 = load i32, i32* %d, align 4
  store i32 %40, i32* @flag1, align 4
  %41 = load i32, i32* @turn, align 4
  store i32 %41, i32* %t2, align 4
  br label %42

; <label>:42                                      ; preds = %39
  %43 = load i32, i32* %t2, align 4
  %44 = icmp ne i32 %43, 1
  br i1 %44, label %48, label %45

; <label>:45                                      ; preds = %50, %42
  %46 = load i32, i32* %c, align 4
  store i32 %46, i32* @flag1, align 4
  br label %47

; <label>:47                                      ; preds = %45, %35
  br label %diverge1

; <label>:48                                      ; preds = %42
  %49 = load i32, i32* @turn, align 4
  store i32 %49, i32* %t2, align 4
  br label %50

; <label>:50                                      ; preds = %48
  %51 = load i32, i32* %t2, align 4
  %52 = icmp ne i32 %51, 1
  br i1 %52, label %30, label %45

diverge2:                                         ; preds = %59, %diverge2
  call void @__VERIFIER_assume(i1 false)
  br label %diverge2

; <label>:53                                      ; preds = %24
  store i32 1, i32* %c, align 4
  store i32 0, i32* %d, align 4
  %54 = load i32, i32* %c, align 4
  store i32 %54, i32* @flag1, align 4
  %55 = load i32, i32* @flag0, align 4
  store i32 %55, i32* %f2, align 4
  br label %56

; <label>:56                                      ; preds = %53
  %57 = load i32, i32* %f2, align 4
  %58 = icmp eq i32 %57, 1
  br i1 %58, label %60, label %59

; <label>:59                                      ; preds = %78, %56
  br label %diverge2

; <label>:60                                      ; preds = %56
  %61 = load i32, i32* @turn, align 4
  store i32 %61, i32* %t2, align 4
  %62 = load i32, i32* %t2, align 4
  %63 = icmp ne i32 %62, 1
  br i1 %63, label %64, label %72

; <label>:64                                      ; preds = %60
  %65 = load i32, i32* %d, align 4
  store i32 %65, i32* @flag1, align 4
  %66 = load i32, i32* @turn, align 4
  store i32 %66, i32* %t2, align 4
  br label %67

; <label>:67                                      ; preds = %64
  %68 = load i32, i32* %t2, align 4
  %69 = icmp ne i32 %68, 1
  br i1 %69, label %73, label %70

; <label>:70                                      ; preds = %75, %67
  %71 = load i32, i32* %c, align 4
  store i32 %71, i32* @flag1, align 4
  br label %72

; <label>:72                                      ; preds = %70, %60
  br label %78

; <label>:73                                      ; preds = %67
  %74 = load i32, i32* @turn, align 4
  store i32 %74, i32* %t2, align 4
  br label %75

; <label>:75                                      ; preds = %73
  %76 = load i32, i32* %t2, align 4
  %77 = icmp ne i32 %76, 1
  br i1 %77, label %30, label %70

; <label>:78                                      ; preds = %72
  %79 = load i32, i32* %f2, align 4
  %80 = icmp eq i32 %79, 1
  br i1 %80, label %35, label %59
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
