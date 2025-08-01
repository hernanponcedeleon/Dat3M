; ModuleID = 'benchmarks/lfds/ms.c'
source_filename = "benchmarks/lfds/ms.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Node = type { i32, %struct.Node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@Head = dso_local global %struct.Node* null, align 8
@Tail = dso_local global %struct.Node* null, align 8
@.str = private unnamed_addr constant [13 x i8] c"tail != NULL\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"benchmarks/lfds/ms.h\00", align 1
@__PRETTY_FUNCTION__.enqueue = private unnamed_addr constant [18 x i8] c"void enqueue(int)\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"head != NULL\00", align 1
@__PRETTY_FUNCTION__.dequeue = private unnamed_addr constant [14 x i8] c"int dequeue()\00", align 1
@.str.3 = private unnamed_addr constant [11 x i8] c"r != EMPTY\00", align 1
@.str.4 = private unnamed_addr constant [21 x i8] c"benchmarks/lfds/ms.c\00", align 1
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1
@.str.5 = private unnamed_addr constant [11 x i8] c"r == EMPTY\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @init() #0 {
  %1 = alloca %struct.Node*, align 8
  %2 = call noalias i8* @malloc(i64 noundef 16) #4
  %3 = bitcast i8* %2 to %struct.Node*
  store %struct.Node* %3, %struct.Node** %1, align 8
  %4 = load %struct.Node*, %struct.Node** %1, align 8
  %5 = getelementptr inbounds %struct.Node, %struct.Node* %4, i32 0, i32 1
  store %struct.Node* null, %struct.Node** %5, align 8
  %6 = load %struct.Node*, %struct.Node** %1, align 8
  store %struct.Node* %6, %struct.Node** @Head, align 8
  %7 = load %struct.Node*, %struct.Node** %1, align 8
  store %struct.Node* %7, %struct.Node** @Tail, align 8
  ret void
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @enqueue(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.Node*, align 8
  %4 = alloca %struct.Node*, align 8
  %5 = alloca %struct.Node*, align 8
  %6 = alloca %struct.Node*, align 8
  %7 = alloca %struct.Node*, align 8
  %8 = alloca %struct.Node*, align 8
  %9 = alloca %struct.Node*, align 8
  %10 = alloca i8, align 1
  %11 = alloca %struct.Node*, align 8
  %12 = alloca i8, align 1
  %13 = alloca %struct.Node*, align 8
  %14 = alloca i8, align 1
  store i32 %0, i32* %2, align 4
  %15 = call noalias i8* @malloc(i64 noundef 16) #4
  %16 = bitcast i8* %15 to %struct.Node*
  store %struct.Node* %16, %struct.Node** %5, align 8
  %17 = load i32, i32* %2, align 4
  %18 = load %struct.Node*, %struct.Node** %5, align 8
  %19 = getelementptr inbounds %struct.Node, %struct.Node* %18, i32 0, i32 0
  store i32 %17, i32* %19, align 8
  %20 = load %struct.Node*, %struct.Node** %5, align 8
  %21 = getelementptr inbounds %struct.Node, %struct.Node* %20, i32 0, i32 1
  store %struct.Node* null, %struct.Node** %21, align 8
  br label %22

22:                                               ; preds = %1, %95
  %23 = bitcast %struct.Node** %6 to i64*
  %24 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8
  store i64 %24, i64* %23, align 8
  %25 = bitcast i64* %23 to %struct.Node**
  %26 = load %struct.Node*, %struct.Node** %25, align 8
  store %struct.Node* %26, %struct.Node** %3, align 8
  %27 = load %struct.Node*, %struct.Node** %3, align 8
  %28 = icmp ne %struct.Node* %27, null
  br i1 %28, label %29, label %30

29:                                               ; preds = %22
  br label %31

30:                                               ; preds = %22
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.enqueue, i64 0, i64 0)) #5
  unreachable

31:                                               ; preds = %29
  %32 = load %struct.Node*, %struct.Node** %3, align 8
  %33 = getelementptr inbounds %struct.Node, %struct.Node* %32, i32 0, i32 1
  %34 = bitcast %struct.Node** %33 to i64*
  %35 = bitcast %struct.Node** %7 to i64*
  %36 = load atomic i64, i64* %34 acquire, align 8
  store i64 %36, i64* %35, align 8
  %37 = bitcast i64* %35 to %struct.Node**
  %38 = load %struct.Node*, %struct.Node** %37, align 8
  store %struct.Node* %38, %struct.Node** %4, align 8
  %39 = load %struct.Node*, %struct.Node** %3, align 8
  %40 = bitcast %struct.Node** %8 to i64*
  %41 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8
  store i64 %41, i64* %40, align 8
  %42 = bitcast i64* %40 to %struct.Node**
  %43 = load %struct.Node*, %struct.Node** %42, align 8
  %44 = icmp eq %struct.Node* %39, %43
  br i1 %44, label %45, label %95

45:                                               ; preds = %31
  %46 = load %struct.Node*, %struct.Node** %4, align 8
  %47 = icmp ne %struct.Node* %46, null
  br i1 %47, label %48, label %62

48:                                               ; preds = %45
  %49 = load %struct.Node*, %struct.Node** %4, align 8
  store %struct.Node* %49, %struct.Node** %9, align 8
  %50 = bitcast %struct.Node** %3 to i64*
  %51 = bitcast %struct.Node** %9 to i64*
  %52 = load i64, i64* %50, align 8
  %53 = load i64, i64* %51, align 8
  %54 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %52, i64 %53 monotonic monotonic, align 8
  %55 = extractvalue { i64, i1 } %54, 0
  %56 = extractvalue { i64, i1 } %54, 1
  br i1 %56, label %58, label %57

57:                                               ; preds = %48
  store i64 %55, i64* %50, align 8
  br label %58

58:                                               ; preds = %57, %48
  %59 = zext i1 %56 to i8
  store i8 %59, i8* %10, align 1
  %60 = load i8, i8* %10, align 1
  %61 = trunc i8 %60 to i1
  br label %94

62:                                               ; preds = %45
  %63 = load %struct.Node*, %struct.Node** %3, align 8
  %64 = getelementptr inbounds %struct.Node, %struct.Node* %63, i32 0, i32 1
  %65 = load %struct.Node*, %struct.Node** %5, align 8
  store %struct.Node* %65, %struct.Node** %11, align 8
  %66 = bitcast %struct.Node** %64 to i64*
  %67 = bitcast %struct.Node** %4 to i64*
  %68 = bitcast %struct.Node** %11 to i64*
  %69 = load i64, i64* %67, align 8
  %70 = load i64, i64* %68, align 8
  %71 = cmpxchg i64* %66, i64 %69, i64 %70 monotonic monotonic, align 8
  %72 = extractvalue { i64, i1 } %71, 0
  %73 = extractvalue { i64, i1 } %71, 1
  br i1 %73, label %75, label %74

74:                                               ; preds = %62
  store i64 %72, i64* %67, align 8
  br label %75

75:                                               ; preds = %74, %62
  %76 = zext i1 %73 to i8
  store i8 %76, i8* %12, align 1
  %77 = load i8, i8* %12, align 1
  %78 = trunc i8 %77 to i1
  br i1 %78, label %79, label %93

79:                                               ; preds = %75
  %80 = load %struct.Node*, %struct.Node** %5, align 8
  store %struct.Node* %80, %struct.Node** %13, align 8
  %81 = bitcast %struct.Node** %3 to i64*
  %82 = bitcast %struct.Node** %13 to i64*
  %83 = load i64, i64* %81, align 8
  %84 = load i64, i64* %82, align 8
  %85 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %83, i64 %84 monotonic monotonic, align 8
  %86 = extractvalue { i64, i1 } %85, 0
  %87 = extractvalue { i64, i1 } %85, 1
  br i1 %87, label %89, label %88

88:                                               ; preds = %79
  store i64 %86, i64* %81, align 8
  br label %89

89:                                               ; preds = %88, %79
  %90 = zext i1 %87 to i8
  store i8 %90, i8* %14, align 1
  %91 = load i8, i8* %14, align 1
  %92 = trunc i8 %91 to i1
  br label %96

93:                                               ; preds = %75
  br label %94

94:                                               ; preds = %93, %58
  br label %95

95:                                               ; preds = %94, %31
  br label %22

96:                                               ; preds = %89
  ret void
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @dequeue() #0 {
  %1 = alloca %struct.Node*, align 8
  %2 = alloca %struct.Node*, align 8
  %3 = alloca %struct.Node*, align 8
  %4 = alloca i32, align 4
  %5 = alloca %struct.Node*, align 8
  %6 = alloca %struct.Node*, align 8
  %7 = alloca %struct.Node*, align 8
  %8 = alloca %struct.Node*, align 8
  %9 = alloca %struct.Node*, align 8
  %10 = alloca i8, align 1
  %11 = alloca %struct.Node*, align 8
  %12 = alloca i8, align 1
  br label %13

13:                                               ; preds = %0, %90
  %14 = bitcast %struct.Node** %5 to i64*
  %15 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8
  store i64 %15, i64* %14, align 8
  %16 = bitcast i64* %14 to %struct.Node**
  %17 = load %struct.Node*, %struct.Node** %16, align 8
  store %struct.Node* %17, %struct.Node** %1, align 8
  %18 = load %struct.Node*, %struct.Node** %1, align 8
  %19 = icmp ne %struct.Node* %18, null
  br i1 %19, label %20, label %21

20:                                               ; preds = %13
  br label %22

21:                                               ; preds = %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.1, i64 0, i64 0), i32 noundef 60, i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__PRETTY_FUNCTION__.dequeue, i64 0, i64 0)) #5
  unreachable

22:                                               ; preds = %20
  %23 = bitcast %struct.Node** %6 to i64*
  %24 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8
  store i64 %24, i64* %23, align 8
  %25 = bitcast i64* %23 to %struct.Node**
  %26 = load %struct.Node*, %struct.Node** %25, align 8
  store %struct.Node* %26, %struct.Node** %3, align 8
  %27 = load %struct.Node*, %struct.Node** %3, align 8
  %28 = icmp ne %struct.Node* %27, null
  br i1 %28, label %29, label %30

29:                                               ; preds = %22
  br label %31

30:                                               ; preds = %22
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.1, i64 0, i64 0), i32 noundef 62, i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__PRETTY_FUNCTION__.dequeue, i64 0, i64 0)) #5
  unreachable

31:                                               ; preds = %29
  %32 = load %struct.Node*, %struct.Node** %1, align 8
  %33 = getelementptr inbounds %struct.Node, %struct.Node* %32, i32 0, i32 1
  %34 = bitcast %struct.Node** %33 to i64*
  %35 = bitcast %struct.Node** %7 to i64*
  %36 = load atomic i64, i64* %34 acquire, align 8
  store i64 %36, i64* %35, align 8
  %37 = bitcast i64* %35 to %struct.Node**
  %38 = load %struct.Node*, %struct.Node** %37, align 8
  store %struct.Node* %38, %struct.Node** %2, align 8
  %39 = load %struct.Node*, %struct.Node** %1, align 8
  %40 = bitcast %struct.Node** %8 to i64*
  %41 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8
  store i64 %41, i64* %40, align 8
  %42 = bitcast i64* %40 to %struct.Node**
  %43 = load %struct.Node*, %struct.Node** %42, align 8
  %44 = icmp eq %struct.Node* %39, %43
  br i1 %44, label %45, label %90

45:                                               ; preds = %31
  %46 = load %struct.Node*, %struct.Node** %2, align 8
  %47 = icmp eq %struct.Node* %46, null
  br i1 %47, label %48, label %49

48:                                               ; preds = %45
  store i32 -1, i32* %4, align 4
  br label %91

49:                                               ; preds = %45
  %50 = load %struct.Node*, %struct.Node** %1, align 8
  %51 = load %struct.Node*, %struct.Node** %3, align 8
  %52 = icmp eq %struct.Node* %50, %51
  br i1 %52, label %53, label %67

53:                                               ; preds = %49
  %54 = load %struct.Node*, %struct.Node** %2, align 8
  store %struct.Node* %54, %struct.Node** %9, align 8
  %55 = bitcast %struct.Node** %3 to i64*
  %56 = bitcast %struct.Node** %9 to i64*
  %57 = load i64, i64* %55, align 8
  %58 = load i64, i64* %56, align 8
  %59 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %57, i64 %58 monotonic monotonic, align 8
  %60 = extractvalue { i64, i1 } %59, 0
  %61 = extractvalue { i64, i1 } %59, 1
  br i1 %61, label %63, label %62

62:                                               ; preds = %53
  store i64 %60, i64* %55, align 8
  br label %63

63:                                               ; preds = %62, %53
  %64 = zext i1 %61 to i8
  store i8 %64, i8* %10, align 1
  %65 = load i8, i8* %10, align 1
  %66 = trunc i8 %65 to i1
  br label %88

67:                                               ; preds = %49
  %68 = load %struct.Node*, %struct.Node** %2, align 8
  %69 = getelementptr inbounds %struct.Node, %struct.Node* %68, i32 0, i32 0
  %70 = load i32, i32* %69, align 8
  store i32 %70, i32* %4, align 4
  %71 = load %struct.Node*, %struct.Node** %2, align 8
  store %struct.Node* %71, %struct.Node** %11, align 8
  %72 = bitcast %struct.Node** %1 to i64*
  %73 = bitcast %struct.Node** %11 to i64*
  %74 = load i64, i64* %72, align 8
  %75 = load i64, i64* %73, align 8
  %76 = cmpxchg i64* bitcast (%struct.Node** @Head to i64*), i64 %74, i64 %75 monotonic monotonic, align 8
  %77 = extractvalue { i64, i1 } %76, 0
  %78 = extractvalue { i64, i1 } %76, 1
  br i1 %78, label %80, label %79

79:                                               ; preds = %67
  store i64 %77, i64* %72, align 8
  br label %80

80:                                               ; preds = %79, %67
  %81 = zext i1 %78 to i8
  store i8 %81, i8* %12, align 1
  %82 = load i8, i8* %12, align 1
  %83 = trunc i8 %82 to i1
  br i1 %83, label %84, label %87

84:                                               ; preds = %80
  %85 = load %struct.Node*, %struct.Node** %1, align 8
  %86 = bitcast %struct.Node* %85 to i8*
  call void @free(i8* noundef %86) #4
  br label %91

87:                                               ; preds = %80
  br label %88

88:                                               ; preds = %87, %63
  br label %89

89:                                               ; preds = %88
  br label %90

90:                                               ; preds = %89, %31
  br label %13

91:                                               ; preds = %84, %48
  %92 = load i32, i32* %4, align 4
  ret i32 %92
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
  call void @enqueue(i32 noundef %8)
  %9 = call i32 @dequeue()
  store i32 %9, i32* %4, align 4
  %10 = load i32, i32* %4, align 4
  %11 = icmp ne i32 %10, -1
  br i1 %11, label %12, label %13

12:                                               ; preds = %1
  br label %14

13:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.4, i64 0, i64 0), i32 noundef 16, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.worker, i64 0, i64 0)) #5
  unreachable

14:                                               ; preds = %12
  ret i8* null
}

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
  br label %6, !llvm.loop !6

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
  br label %21, !llvm.loop !8

33:                                               ; preds = %21
  %34 = call i32 @dequeue()
  store i32 %34, i32* %5, align 4
  %35 = load i32, i32* %5, align 4
  %36 = icmp eq i32 %35, -1
  br i1 %36, label %37, label %38

37:                                               ; preds = %33
  br label %39

38:                                               ; preds = %33
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.4, i64 0, i64 0), i32 noundef 34, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5
  unreachable

39:                                               ; preds = %37
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
