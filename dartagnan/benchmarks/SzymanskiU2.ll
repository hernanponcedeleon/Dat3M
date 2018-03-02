; ModuleID = 'Szymanski.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_attr_t = type { i64, [48 x i8] }

@flag1 = global i32 0, align 4
@flag2 = global i32 0, align 4

; Function Attrs: nounwind uwtable
define i8* @thrd0(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %a = alloca i32, align 4
  %f2 = alloca i32, align 4
  store i8* %args, i8** %2, align 8
  br label %3

; <label>:3                                       ; preds = %0
  store i32 1, i32* %a, align 4
  %4 = load i32, i32* %a, align 4
  store i32 %4, i32* @flag1, align 4
  %5 = load i32, i32* @flag2, align 4
  store i32 %5, i32* %f2, align 4
  br label %6

; <label>:6                                       ; preds = %3
  %7 = load i32, i32* %f2, align 4
  %8 = icmp sge i32 %7, 3
  br i1 %8, label %9, label %11

; <label>:9                                       ; preds = %6
  %10 = load i32, i32* @flag2, align 4
  store i32 %10, i32* %f2, align 4
  br label %48

; <label>:11                                      ; preds = %48, %6
  store i32 3, i32* %a, align 4
  %12 = load i32, i32* %a, align 4
  store i32 %12, i32* @flag1, align 4
  %13 = load i32, i32* @flag2, align 4
  store i32 %13, i32* %f2, align 4
  %14 = load i32, i32* %f2, align 4
  %15 = icmp eq i32 %14, 1
  br i1 %15, label %16, label %25

; <label>:16                                      ; preds = %11
  store i32 2, i32* %a, align 4
  %17 = load i32, i32* %a, align 4
  store i32 %17, i32* @flag1, align 4
  %18 = load i32, i32* @flag2, align 4
  store i32 %18, i32* %f2, align 4
  br label %19

; <label>:19                                      ; preds = %16
  %20 = load i32, i32* %f2, align 4
  %21 = icmp ne i32 %20, 4
  br i1 %21, label %22, label %24

; <label>:22                                      ; preds = %19
  %23 = load i32, i32* @flag2, align 4
  store i32 %23, i32* %f2, align 4
  br label %53

; <label>:24                                      ; preds = %53, %19
  br label %25

; <label>:25                                      ; preds = %24, %11
  store i32 4, i32* %a, align 4
  %26 = load i32, i32* %a, align 4
  store i32 %26, i32* @flag1, align 4
  %27 = load i32, i32* @flag2, align 4
  store i32 %27, i32* %f2, align 4
  br label %28

; <label>:28                                      ; preds = %25
  %29 = load i32, i32* %f2, align 4
  %30 = icmp sge i32 %29, 2
  br i1 %30, label %31, label %33

; <label>:31                                      ; preds = %28
  %32 = load i32, i32* @flag2, align 4
  store i32 %32, i32* %f2, align 4
  br label %58

; <label>:33                                      ; preds = %58, %28
  %34 = load i32, i32* @flag2, align 4
  store i32 %34, i32* %f2, align 4
  br label %35

; <label>:35                                      ; preds = %33
  %36 = load i32, i32* %f2, align 4
  %37 = icmp sle i32 2, %36
  br i1 %37, label %38, label %41

; <label>:38                                      ; preds = %35
  %39 = load i32, i32* %f2, align 4
  %40 = icmp sle i32 %39, 3
  br label %41

; <label>:41                                      ; preds = %38, %35
  %42 = phi i1 [ false, %35 ], [ %40, %38 ]
  br i1 %42, label %43, label %45

; <label>:43                                      ; preds = %41
  %44 = load i32, i32* @flag2, align 4
  store i32 %44, i32* %f2, align 4
  br label %63

; <label>:45                                      ; preds = %69, %41
  br label %73
                                                  ; No predecessors!
  %47 = load i8*, i8** %1, align 8
  ret i8* %47

diverge:                                          ; preds = %51, %diverge
  call void @__VERIFIER_assume(i1 false)
  br label %diverge

; <label>:48                                      ; preds = %9
  %49 = load i32, i32* %f2, align 4
  %50 = icmp sge i32 %49, 3
  br i1 %50, label %51, label %11

; <label>:51                                      ; preds = %116, %48
  %52 = load i32, i32* @flag2, align 4
  store i32 %52, i32* %f2, align 4
  br label %diverge

diverge1:                                         ; preds = %56, %diverge1
  call void @__VERIFIER_assume(i1 false)
  br label %diverge1

; <label>:53                                      ; preds = %22
  %54 = load i32, i32* %f2, align 4
  %55 = icmp ne i32 %54, 4
  br i1 %55, label %56, label %24

; <label>:56                                      ; preds = %119, %53
  %57 = load i32, i32* @flag2, align 4
  store i32 %57, i32* %f2, align 4
  br label %diverge1

diverge2:                                         ; preds = %61, %diverge2
  call void @__VERIFIER_assume(i1 false)
  br label %diverge2

; <label>:58                                      ; preds = %31
  %59 = load i32, i32* %f2, align 4
  %60 = icmp sge i32 %59, 2
  br i1 %60, label %61, label %33

; <label>:61                                      ; preds = %122, %58
  %62 = load i32, i32* @flag2, align 4
  store i32 %62, i32* %f2, align 4
  br label %diverge2

diverge3:                                         ; preds = %71, %diverge3
  call void @__VERIFIER_assume(i1 false)
  br label %diverge3

; <label>:63                                      ; preds = %43
  %64 = load i32, i32* %f2, align 4
  %65 = icmp sle i32 2, %64
  br i1 %65, label %66, label %69

; <label>:66                                      ; preds = %63
  %67 = load i32, i32* %f2, align 4
  %68 = icmp sle i32 %67, 3
  br label %69

; <label>:69                                      ; preds = %66, %63
  %70 = phi i1 [ false, %63 ], [ %68, %66 ]
  br i1 %70, label %71, label %45

; <label>:71                                      ; preds = %131, %69
  %72 = load i32, i32* @flag2, align 4
  store i32 %72, i32* %f2, align 4
  br label %diverge3

diverge4:                                         ; preds = %107, %diverge4
  call void @__VERIFIER_assume(i1 false)
  br label %diverge4

; <label>:73                                      ; preds = %45
  store i32 1, i32* %a, align 4
  %74 = load i32, i32* %a, align 4
  store i32 %74, i32* @flag1, align 4
  %75 = load i32, i32* @flag2, align 4
  store i32 %75, i32* %f2, align 4
  br label %76

; <label>:76                                      ; preds = %73
  %77 = load i32, i32* %f2, align 4
  %78 = icmp sge i32 %77, 3
  br i1 %78, label %114, label %79

; <label>:79                                      ; preds = %116, %76
  store i32 3, i32* %a, align 4
  %80 = load i32, i32* %a, align 4
  store i32 %80, i32* @flag1, align 4
  %81 = load i32, i32* @flag2, align 4
  store i32 %81, i32* %f2, align 4
  %82 = load i32, i32* %f2, align 4
  %83 = icmp eq i32 %82, 1
  br i1 %83, label %84, label %91

; <label>:84                                      ; preds = %79
  store i32 2, i32* %a, align 4
  %85 = load i32, i32* %a, align 4
  store i32 %85, i32* @flag1, align 4
  %86 = load i32, i32* @flag2, align 4
  store i32 %86, i32* %f2, align 4
  br label %87

; <label>:87                                      ; preds = %84
  %88 = load i32, i32* %f2, align 4
  %89 = icmp ne i32 %88, 4
  br i1 %89, label %112, label %90

; <label>:90                                      ; preds = %119, %87
  br label %91

; <label>:91                                      ; preds = %90, %79
  store i32 4, i32* %a, align 4
  %92 = load i32, i32* %a, align 4
  store i32 %92, i32* @flag1, align 4
  %93 = load i32, i32* @flag2, align 4
  store i32 %93, i32* %f2, align 4
  br label %94

; <label>:94                                      ; preds = %91
  %95 = load i32, i32* %f2, align 4
  %96 = icmp sge i32 %95, 2
  br i1 %96, label %110, label %97

; <label>:97                                      ; preds = %122, %94
  %98 = load i32, i32* @flag2, align 4
  store i32 %98, i32* %f2, align 4
  br label %99

; <label>:99                                      ; preds = %97
  %100 = load i32, i32* %f2, align 4
  %101 = icmp sle i32 2, %100
  br i1 %101, label %102, label %105

; <label>:102                                     ; preds = %99
  %103 = load i32, i32* %f2, align 4
  %104 = icmp sle i32 %103, 3
  br label %105

; <label>:105                                     ; preds = %102, %99
  %106 = phi i1 [ false, %99 ], [ %104, %102 ]
  br i1 %106, label %108, label %107

; <label>:107                                     ; preds = %131, %105
  br label %diverge4

; <label>:108                                     ; preds = %105
  %109 = load i32, i32* @flag2, align 4
  store i32 %109, i32* %f2, align 4
  br label %125

; <label>:110                                     ; preds = %94
  %111 = load i32, i32* @flag2, align 4
  store i32 %111, i32* %f2, align 4
  br label %122

; <label>:112                                     ; preds = %87
  %113 = load i32, i32* @flag2, align 4
  store i32 %113, i32* %f2, align 4
  br label %119

; <label>:114                                     ; preds = %76
  %115 = load i32, i32* @flag2, align 4
  store i32 %115, i32* %f2, align 4
  br label %116

; <label>:116                                     ; preds = %114
  %117 = load i32, i32* %f2, align 4
  %118 = icmp sge i32 %117, 3
  br i1 %118, label %51, label %79

; <label>:119                                     ; preds = %112
  %120 = load i32, i32* %f2, align 4
  %121 = icmp ne i32 %120, 4
  br i1 %121, label %56, label %90

; <label>:122                                     ; preds = %110
  %123 = load i32, i32* %f2, align 4
  %124 = icmp sge i32 %123, 2
  br i1 %124, label %61, label %97

; <label>:125                                     ; preds = %108
  %126 = load i32, i32* %f2, align 4
  %127 = icmp sle i32 2, %126
  br i1 %127, label %128, label %131

; <label>:128                                     ; preds = %125
  %129 = load i32, i32* %f2, align 4
  %130 = icmp sle i32 %129, 3
  br label %131

; <label>:131                                     ; preds = %128, %125
  %132 = phi i1 [ false, %125 ], [ %130, %128 ]
  br i1 %132, label %71, label %107
}

; Function Attrs: nounwind uwtable
define i8* @thrd1(i8* %args) #0 {
  %1 = alloca i8*, align 8
  %2 = alloca i8*, align 8
  %a = alloca i32, align 4
  %f1 = alloca i32, align 4
  store i8* %args, i8** %2, align 8
  br label %3

; <label>:3                                       ; preds = %0
  store i32 1, i32* %a, align 4
  %4 = load i32, i32* %a, align 4
  store i32 %4, i32* @flag2, align 4
  %5 = load i32, i32* @flag1, align 4
  store i32 %5, i32* %f1, align 4
  br label %6

; <label>:6                                       ; preds = %3
  %7 = load i32, i32* %f1, align 4
  %8 = icmp sge i32 %7, 3
  br i1 %8, label %9, label %11

; <label>:9                                       ; preds = %6
  %10 = load i32, i32* @flag1, align 4
  store i32 %10, i32* %f1, align 4
  br label %48

; <label>:11                                      ; preds = %48, %6
  store i32 3, i32* %a, align 4
  %12 = load i32, i32* %a, align 4
  store i32 %12, i32* @flag2, align 4
  %13 = load i32, i32* @flag1, align 4
  store i32 %13, i32* %f1, align 4
  %14 = load i32, i32* %f1, align 4
  %15 = icmp eq i32 %14, 1
  br i1 %15, label %16, label %25

; <label>:16                                      ; preds = %11
  store i32 2, i32* %a, align 4
  %17 = load i32, i32* %a, align 4
  store i32 %17, i32* @flag2, align 4
  %18 = load i32, i32* @flag1, align 4
  store i32 %18, i32* %f1, align 4
  br label %19

; <label>:19                                      ; preds = %16
  %20 = load i32, i32* %f1, align 4
  %21 = icmp ne i32 %20, 4
  br i1 %21, label %22, label %24

; <label>:22                                      ; preds = %19
  %23 = load i32, i32* @flag1, align 4
  store i32 %23, i32* %f1, align 4
  br label %53

; <label>:24                                      ; preds = %53, %19
  br label %25

; <label>:25                                      ; preds = %24, %11
  store i32 4, i32* %a, align 4
  %26 = load i32, i32* %a, align 4
  store i32 %26, i32* @flag2, align 4
  %27 = load i32, i32* @flag1, align 4
  store i32 %27, i32* %f1, align 4
  br label %28

; <label>:28                                      ; preds = %25
  %29 = load i32, i32* %f1, align 4
  %30 = icmp sge i32 %29, 2
  br i1 %30, label %31, label %33

; <label>:31                                      ; preds = %28
  %32 = load i32, i32* @flag1, align 4
  store i32 %32, i32* %f1, align 4
  br label %58

; <label>:33                                      ; preds = %58, %28
  %34 = load i32, i32* @flag1, align 4
  store i32 %34, i32* %f1, align 4
  br label %35

; <label>:35                                      ; preds = %33
  %36 = load i32, i32* %f1, align 4
  %37 = icmp sle i32 2, %36
  br i1 %37, label %38, label %41

; <label>:38                                      ; preds = %35
  %39 = load i32, i32* %f1, align 4
  %40 = icmp sle i32 %39, 3
  br label %41

; <label>:41                                      ; preds = %38, %35
  %42 = phi i1 [ false, %35 ], [ %40, %38 ]
  br i1 %42, label %43, label %45

; <label>:43                                      ; preds = %41
  %44 = load i32, i32* @flag1, align 4
  store i32 %44, i32* %f1, align 4
  br label %63

; <label>:45                                      ; preds = %69, %41
  br label %73
                                                  ; No predecessors!
  %47 = load i8*, i8** %1, align 8
  ret i8* %47

diverge:                                          ; preds = %51, %diverge
  call void @__VERIFIER_assume(i1 false)
  br label %diverge

; <label>:48                                      ; preds = %9
  %49 = load i32, i32* %f1, align 4
  %50 = icmp sge i32 %49, 3
  br i1 %50, label %51, label %11

; <label>:51                                      ; preds = %116, %48
  %52 = load i32, i32* @flag1, align 4
  store i32 %52, i32* %f1, align 4
  br label %diverge

diverge1:                                         ; preds = %56, %diverge1
  call void @__VERIFIER_assume(i1 false)
  br label %diverge1

; <label>:53                                      ; preds = %22
  %54 = load i32, i32* %f1, align 4
  %55 = icmp ne i32 %54, 4
  br i1 %55, label %56, label %24

; <label>:56                                      ; preds = %119, %53
  %57 = load i32, i32* @flag1, align 4
  store i32 %57, i32* %f1, align 4
  br label %diverge1

diverge2:                                         ; preds = %61, %diverge2
  call void @__VERIFIER_assume(i1 false)
  br label %diverge2

; <label>:58                                      ; preds = %31
  %59 = load i32, i32* %f1, align 4
  %60 = icmp sge i32 %59, 2
  br i1 %60, label %61, label %33

; <label>:61                                      ; preds = %122, %58
  %62 = load i32, i32* @flag1, align 4
  store i32 %62, i32* %f1, align 4
  br label %diverge2

diverge3:                                         ; preds = %71, %diverge3
  call void @__VERIFIER_assume(i1 false)
  br label %diverge3

; <label>:63                                      ; preds = %43
  %64 = load i32, i32* %f1, align 4
  %65 = icmp sle i32 2, %64
  br i1 %65, label %66, label %69

; <label>:66                                      ; preds = %63
  %67 = load i32, i32* %f1, align 4
  %68 = icmp sle i32 %67, 3
  br label %69

; <label>:69                                      ; preds = %66, %63
  %70 = phi i1 [ false, %63 ], [ %68, %66 ]
  br i1 %70, label %71, label %45

; <label>:71                                      ; preds = %131, %69
  %72 = load i32, i32* @flag1, align 4
  store i32 %72, i32* %f1, align 4
  br label %diverge3

diverge4:                                         ; preds = %107, %diverge4
  call void @__VERIFIER_assume(i1 false)
  br label %diverge4

; <label>:73                                      ; preds = %45
  store i32 1, i32* %a, align 4
  %74 = load i32, i32* %a, align 4
  store i32 %74, i32* @flag2, align 4
  %75 = load i32, i32* @flag1, align 4
  store i32 %75, i32* %f1, align 4
  br label %76

; <label>:76                                      ; preds = %73
  %77 = load i32, i32* %f1, align 4
  %78 = icmp sge i32 %77, 3
  br i1 %78, label %114, label %79

; <label>:79                                      ; preds = %116, %76
  store i32 3, i32* %a, align 4
  %80 = load i32, i32* %a, align 4
  store i32 %80, i32* @flag2, align 4
  %81 = load i32, i32* @flag1, align 4
  store i32 %81, i32* %f1, align 4
  %82 = load i32, i32* %f1, align 4
  %83 = icmp eq i32 %82, 1
  br i1 %83, label %84, label %91

; <label>:84                                      ; preds = %79
  store i32 2, i32* %a, align 4
  %85 = load i32, i32* %a, align 4
  store i32 %85, i32* @flag2, align 4
  %86 = load i32, i32* @flag1, align 4
  store i32 %86, i32* %f1, align 4
  br label %87

; <label>:87                                      ; preds = %84
  %88 = load i32, i32* %f1, align 4
  %89 = icmp ne i32 %88, 4
  br i1 %89, label %112, label %90

; <label>:90                                      ; preds = %119, %87
  br label %91

; <label>:91                                      ; preds = %90, %79
  store i32 4, i32* %a, align 4
  %92 = load i32, i32* %a, align 4
  store i32 %92, i32* @flag2, align 4
  %93 = load i32, i32* @flag1, align 4
  store i32 %93, i32* %f1, align 4
  br label %94

; <label>:94                                      ; preds = %91
  %95 = load i32, i32* %f1, align 4
  %96 = icmp sge i32 %95, 2
  br i1 %96, label %110, label %97

; <label>:97                                      ; preds = %122, %94
  %98 = load i32, i32* @flag1, align 4
  store i32 %98, i32* %f1, align 4
  br label %99

; <label>:99                                      ; preds = %97
  %100 = load i32, i32* %f1, align 4
  %101 = icmp sle i32 2, %100
  br i1 %101, label %102, label %105

; <label>:102                                     ; preds = %99
  %103 = load i32, i32* %f1, align 4
  %104 = icmp sle i32 %103, 3
  br label %105

; <label>:105                                     ; preds = %102, %99
  %106 = phi i1 [ false, %99 ], [ %104, %102 ]
  br i1 %106, label %108, label %107

; <label>:107                                     ; preds = %131, %105
  br label %diverge4

; <label>:108                                     ; preds = %105
  %109 = load i32, i32* @flag1, align 4
  store i32 %109, i32* %f1, align 4
  br label %125

; <label>:110                                     ; preds = %94
  %111 = load i32, i32* @flag1, align 4
  store i32 %111, i32* %f1, align 4
  br label %122

; <label>:112                                     ; preds = %87
  %113 = load i32, i32* @flag1, align 4
  store i32 %113, i32* %f1, align 4
  br label %119

; <label>:114                                     ; preds = %76
  %115 = load i32, i32* @flag1, align 4
  store i32 %115, i32* %f1, align 4
  br label %116

; <label>:116                                     ; preds = %114
  %117 = load i32, i32* %f1, align 4
  %118 = icmp sge i32 %117, 3
  br i1 %118, label %51, label %79

; <label>:119                                     ; preds = %112
  %120 = load i32, i32* %f1, align 4
  %121 = icmp ne i32 %120, 4
  br i1 %121, label %56, label %90

; <label>:122                                     ; preds = %110
  %123 = load i32, i32* %f1, align 4
  %124 = icmp sge i32 %123, 2
  br i1 %124, label %61, label %97

; <label>:125                                     ; preds = %108
  %126 = load i32, i32* %f1, align 4
  %127 = icmp sle i32 2, %126
  br i1 %127, label %128, label %131

; <label>:128                                     ; preds = %125
  %129 = load i32, i32* %f1, align 4
  %130 = icmp sle i32 %129, 3
  br label %131

; <label>:131                                     ; preds = %128, %125
  %132 = phi i1 [ false, %125 ], [ %130, %128 ]
  br i1 %132, label %71, label %107
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
