; ModuleID = 'benchmarks/lfds/treiber.c'
source_filename = "benchmarks/lfds/treiber.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.anon = type { %struct.Node* }
%struct.Node = type { i32, %struct.Node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@retired_count = dso_local global i32 0, align 4
@TOP = dso_local global %struct.anon zeroinitializer, align 8
@retired = dso_local global [10 x %struct.Node*] zeroinitializer, align 16
@.str = private unnamed_addr constant [11 x i8] c"r != EMPTY\00", align 1
@.str.1 = private unnamed_addr constant [26 x i8] c"benchmarks/lfds/treiber.c\00", align 1
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1
@.str.2 = private unnamed_addr constant [11 x i8] c"r == EMPTY\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @init() #0 {
  store %struct.Node* null, %struct.Node** getelementptr inbounds (%struct.anon, %struct.anon* @TOP, i32 0, i32 0), align 8
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @push(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.Node*, align 8
  %4 = alloca %struct.Node*, align 8
  %5 = alloca %struct.Node*, align 8
  %6 = alloca %struct.Node*, align 8
  %7 = alloca %struct.Node*, align 8
  %8 = alloca i8, align 1
  store i32 %0, i32* %2, align 4
  %9 = call noalias i8* @malloc(i64 noundef 16) #4
  %10 = bitcast i8* %9 to %struct.Node*
  store %struct.Node* %10, %struct.Node** %3, align 8
  %11 = load i32, i32* %2, align 4
  %12 = load %struct.Node*, %struct.Node** %3, align 8
  %13 = getelementptr inbounds %struct.Node, %struct.Node* %12, i32 0, i32 0
  store i32 %11, i32* %13, align 8
  br label %14

14:                                               ; preds = %1, %39
  %15 = bitcast %struct.Node** %5 to i64*
  %16 = load atomic i64, i64* bitcast (%struct.anon* @TOP to i64*) acquire, align 8
  store i64 %16, i64* %15, align 8
  %17 = bitcast i64* %15 to %struct.Node**
  %18 = load %struct.Node*, %struct.Node** %17, align 8
  store %struct.Node* %18, %struct.Node** %4, align 8
  %19 = load %struct.Node*, %struct.Node** %3, align 8
  %20 = getelementptr inbounds %struct.Node, %struct.Node* %19, i32 0, i32 1
  %21 = load %struct.Node*, %struct.Node** %4, align 8
  store %struct.Node* %21, %struct.Node** %6, align 8
  %22 = bitcast %struct.Node** %20 to i64*
  %23 = bitcast %struct.Node** %6 to i64*
  %24 = load i64, i64* %23, align 8
  store atomic i64 %24, i64* %22 monotonic, align 8
  %25 = load %struct.Node*, %struct.Node** %3, align 8
  store %struct.Node* %25, %struct.Node** %7, align 8
  %26 = bitcast %struct.Node** %4 to i64*
  %27 = bitcast %struct.Node** %7 to i64*
  %28 = load i64, i64* %26, align 8
  %29 = load i64, i64* %27, align 8
  %30 = cmpxchg i64* bitcast (%struct.anon* @TOP to i64*), i64 %28, i64 %29 acq_rel monotonic, align 8
  %31 = extractvalue { i64, i1 } %30, 0
  %32 = extractvalue { i64, i1 } %30, 1
  br i1 %32, label %34, label %33

33:                                               ; preds = %14
  store i64 %31, i64* %26, align 8
  br label %34

34:                                               ; preds = %33, %14
  %35 = zext i1 %32 to i8
  store i8 %35, i8* %8, align 1
  %36 = load i8, i8* %8, align 1
  %37 = trunc i8 %36 to i1
  br i1 %37, label %38, label %39

38:                                               ; preds = %34
  br label %40

39:                                               ; preds = %34
  br label %14

40:                                               ; preds = %38
  ret void
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @pop() #0 {
  %1 = alloca i32, align 4
  %2 = alloca %struct.Node*, align 8
  %3 = alloca %struct.Node*, align 8
  %4 = alloca %struct.Node*, align 8
  %5 = alloca %struct.Node*, align 8
  %6 = alloca %struct.Node*, align 8
  %7 = alloca i8, align 1
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  br label %10

10:                                               ; preds = %0, %47
  %11 = bitcast %struct.Node** %4 to i64*
  %12 = load atomic i64, i64* bitcast (%struct.anon* @TOP to i64*) acquire, align 8
  store i64 %12, i64* %11, align 8
  %13 = bitcast i64* %11 to %struct.Node**
  %14 = load %struct.Node*, %struct.Node** %13, align 8
  store %struct.Node* %14, %struct.Node** %2, align 8
  %15 = load %struct.Node*, %struct.Node** %2, align 8
  %16 = icmp eq %struct.Node* %15, null
  br i1 %16, label %17, label %18

17:                                               ; preds = %10
  store i32 -1, i32* %1, align 4
  br label %52

18:                                               ; preds = %10
  %19 = load %struct.Node*, %struct.Node** %2, align 8
  %20 = getelementptr inbounds %struct.Node, %struct.Node* %19, i32 0, i32 1
  %21 = bitcast %struct.Node** %20 to i64*
  %22 = bitcast %struct.Node** %5 to i64*
  %23 = load atomic i64, i64* %21 acquire, align 8
  store i64 %23, i64* %22, align 8
  %24 = bitcast i64* %22 to %struct.Node**
  %25 = load %struct.Node*, %struct.Node** %24, align 8
  store %struct.Node* %25, %struct.Node** %3, align 8
  %26 = load %struct.Node*, %struct.Node** %3, align 8
  store %struct.Node* %26, %struct.Node** %6, align 8
  %27 = bitcast %struct.Node** %2 to i64*
  %28 = bitcast %struct.Node** %6 to i64*
  %29 = load i64, i64* %27, align 8
  %30 = load i64, i64* %28, align 8
  %31 = cmpxchg i64* bitcast (%struct.anon* @TOP to i64*), i64 %29, i64 %30 acq_rel monotonic, align 8
  %32 = extractvalue { i64, i1 } %31, 0
  %33 = extractvalue { i64, i1 } %31, 1
  br i1 %33, label %35, label %34

34:                                               ; preds = %18
  store i64 %32, i64* %27, align 8
  br label %35

35:                                               ; preds = %34, %18
  %36 = zext i1 %33 to i8
  store i8 %36, i8* %7, align 1
  %37 = load i8, i8* %7, align 1
  %38 = trunc i8 %37 to i1
  br i1 %38, label %39, label %46

39:                                               ; preds = %35
  %40 = load %struct.Node*, %struct.Node** %2, align 8
  store i32 1, i32* %8, align 4
  %41 = load i32, i32* %8, align 4
  %42 = atomicrmw add i32* @retired_count, i32 %41 seq_cst, align 4
  store i32 %42, i32* %9, align 4
  %43 = load i32, i32* %9, align 4
  %44 = sext i32 %43 to i64
  %45 = getelementptr inbounds [10 x %struct.Node*], [10 x %struct.Node*]* @retired, i64 0, i64 %44
  store %struct.Node* %40, %struct.Node** %45, align 8
  br label %48

46:                                               ; preds = %35
  br label %47

47:                                               ; preds = %46
  br label %10

48:                                               ; preds = %39
  %49 = load %struct.Node*, %struct.Node** %2, align 8
  %50 = getelementptr inbounds %struct.Node, %struct.Node* %49, i32 0, i32 0
  %51 = load i32, i32* %50, align 8
  store i32 %51, i32* %1, align 4
  br label %52

52:                                               ; preds = %48, %17
  %53 = load i32, i32* %1, align 4
  ret i32 %53
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @free_all_retired() #0 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  br label %2

2:                                                ; preds = %12, %0
  %3 = load i32, i32* %1, align 4
  %4 = load atomic i32, i32* @retired_count seq_cst, align 4
  %5 = icmp slt i32 %3, %4
  br i1 %5, label %6, label %15

6:                                                ; preds = %2
  %7 = load i32, i32* %1, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [10 x %struct.Node*], [10 x %struct.Node*]* @retired, i64 0, i64 %8
  %10 = load %struct.Node*, %struct.Node** %9, align 8
  %11 = bitcast %struct.Node* %10 to i8*
  call void @free(i8* noundef %11) #4
  br label %12

12:                                               ; preds = %6
  %13 = load i32, i32* %1, align 4
  %14 = add nsw i32 %13, 1
  store i32 %14, i32* %1, align 4
  br label %2, !llvm.loop !6

15:                                               ; preds = %2
  store atomic i32 0, i32* @retired_count seq_cst, align 4
  ret void
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @worker(i8* noundef %0) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  %5 = load i8*, i8** %2, align 8
  %6 = ptrtoint i8* %5 to i64
  store i64 %6, i64* %3, align 8
  %7 = load i64, i64* %3, align 8
  %8 = trunc i64 %7 to i32
  call void @push(i32 noundef %8)
  %9 = call i32 @pop()
  store i32 %9, i32* %4, align 4
  %10 = load i32, i32* %4, align 4
  %11 = icmp ne i32 %10, -1
  br i1 %11, label %12, label %13

12:                                               ; preds = %1
  br label %14

13:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.1, i64 0, i64 0), i32 noundef 17, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.worker, i64 0, i64 0)) #5
  unreachable

14:                                               ; preds = %12
  ret i8* null
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @init()
  store i32 0, i32* %3, align 4
  br label %6

6:                                                ; preds = %17, %0
  %7 = load i32, i32* %3, align 4
  %8 = icmp slt i32 %7, 3
  br i1 %8, label %9, label %20

9:                                                ; preds = %6
  %10 = load i32, i32* %3, align 4
  %11 = sext i32 %10 to i64
  %12 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %11
  %13 = load i32, i32* %3, align 4
  %14 = sext i32 %13 to i64
  %15 = inttoptr i64 %14 to i8*
  %16 = call i32 @pthread_create(i64* noundef %12, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef %15) #4
  br label %17

17:                                               ; preds = %9
  %18 = load i32, i32* %3, align 4
  %19 = add nsw i32 %18, 1
  store i32 %19, i32* %3, align 4
  br label %6, !llvm.loop !8

20:                                               ; preds = %6
  store i32 0, i32* %4, align 4
  br label %21

21:                                               ; preds = %30, %20
  %22 = load i32, i32* %4, align 4
  %23 = icmp slt i32 %22, 3
  br i1 %23, label %24, label %33

24:                                               ; preds = %21
  %25 = load i32, i32* %4, align 4
  %26 = sext i32 %25 to i64
  %27 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %26
  %28 = load i64, i64* %27, align 8
  %29 = call i32 @pthread_join(i64 noundef %28, i8** noundef null)
  br label %30

30:                                               ; preds = %24
  %31 = load i32, i32* %4, align 4
  %32 = add nsw i32 %31, 1
  store i32 %32, i32* %4, align 4
  br label %21, !llvm.loop !9

33:                                               ; preds = %21
  %34 = call i32 @pop()
  store i32 %34, i32* %5, align 4
  %35 = load i32, i32* %5, align 4
  %36 = icmp eq i32 %35, -1
  br i1 %36, label %37, label %38

37:                                               ; preds = %33
  br label %39

38:                                               ; preds = %33
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.1, i64 0, i64 0), i32 noundef 35, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5
  unreachable

39:                                               ; preds = %37
  call void @free_all_retired()
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #1

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
