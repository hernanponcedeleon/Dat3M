; ModuleID = 'benchmarks/lfds/dglm.c'
source_filename = "benchmarks/lfds/dglm.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Node = type { i32, %struct.Node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@Head = dso_local global %struct.Node* null, align 8
@Tail = dso_local global %struct.Node* null, align 8
@.str = private unnamed_addr constant [13 x i8] c"tail != NULL\00", align 1
@.str.1 = private unnamed_addr constant [23 x i8] c"benchmarks/lfds/dglm.h\00", align 1
@__PRETTY_FUNCTION__.enqueue = private unnamed_addr constant [18 x i8] c"void enqueue(int)\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"head != NULL\00", align 1
@__PRETTY_FUNCTION__.dequeue = private unnamed_addr constant [14 x i8] c"int dequeue()\00", align 1
@.str.3 = private unnamed_addr constant [11 x i8] c"r != EMPTY\00", align 1
@.str.4 = private unnamed_addr constant [23 x i8] c"benchmarks/lfds/dglm.c\00", align 1
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1
@data = dso_local global [3 x i32] zeroinitializer, align 4
@.str.5 = private unnamed_addr constant [11 x i8] c"r == EMPTY\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@.str.6 = private unnamed_addr constant [13 x i8] c"data[i] == 1\00", align 1

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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.enqueue, i64 0, i64 0)) #5
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
  %47 = icmp eq %struct.Node* %46, null
  br i1 %47, label %48, label %80

48:                                               ; preds = %45
  %49 = load %struct.Node*, %struct.Node** %3, align 8
  %50 = getelementptr inbounds %struct.Node, %struct.Node* %49, i32 0, i32 1
  %51 = load %struct.Node*, %struct.Node** %5, align 8
  store %struct.Node* %51, %struct.Node** %9, align 8
  %52 = bitcast %struct.Node** %50 to i64*
  %53 = bitcast %struct.Node** %4 to i64*
  %54 = bitcast %struct.Node** %9 to i64*
  %55 = load i64, i64* %53, align 8
  %56 = load i64, i64* %54, align 8
  %57 = cmpxchg i64* %52, i64 %55, i64 %56 monotonic monotonic, align 8
  %58 = extractvalue { i64, i1 } %57, 0
  %59 = extractvalue { i64, i1 } %57, 1
  br i1 %59, label %61, label %60

60:                                               ; preds = %48
  store i64 %58, i64* %53, align 8
  br label %61

61:                                               ; preds = %60, %48
  %62 = zext i1 %59 to i8
  store i8 %62, i8* %10, align 1
  %63 = load i8, i8* %10, align 1
  %64 = trunc i8 %63 to i1
  br i1 %64, label %65, label %79

65:                                               ; preds = %61
  %66 = load %struct.Node*, %struct.Node** %5, align 8
  store %struct.Node* %66, %struct.Node** %11, align 8
  %67 = bitcast %struct.Node** %3 to i64*
  %68 = bitcast %struct.Node** %11 to i64*
  %69 = load i64, i64* %67, align 8
  %70 = load i64, i64* %68, align 8
  %71 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %69, i64 %70 monotonic monotonic, align 8
  %72 = extractvalue { i64, i1 } %71, 0
  %73 = extractvalue { i64, i1 } %71, 1
  br i1 %73, label %75, label %74

74:                                               ; preds = %65
  store i64 %72, i64* %67, align 8
  br label %75

75:                                               ; preds = %74, %65
  %76 = zext i1 %73 to i8
  store i8 %76, i8* %12, align 1
  %77 = load i8, i8* %12, align 1
  %78 = trunc i8 %77 to i1
  br label %96

79:                                               ; preds = %61
  br label %94

80:                                               ; preds = %45
  %81 = load %struct.Node*, %struct.Node** %4, align 8
  store %struct.Node* %81, %struct.Node** %13, align 8
  %82 = bitcast %struct.Node** %3 to i64*
  %83 = bitcast %struct.Node** %13 to i64*
  %84 = load i64, i64* %82, align 8
  %85 = load i64, i64* %83, align 8
  %86 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %84, i64 %85 monotonic monotonic, align 8
  %87 = extractvalue { i64, i1 } %86, 0
  %88 = extractvalue { i64, i1 } %86, 1
  br i1 %88, label %90, label %89

89:                                               ; preds = %80
  store i64 %87, i64* %82, align 8
  br label %90

90:                                               ; preds = %89, %80
  %91 = zext i1 %88 to i8
  store i8 %91, i8* %14, align 1
  %92 = load i8, i8* %14, align 1
  %93 = trunc i8 %92 to i1
  br label %94

94:                                               ; preds = %90, %79
  br label %95

95:                                               ; preds = %94, %31
  br label %22

96:                                               ; preds = %75
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
  %9 = alloca i8, align 1
  %10 = alloca %struct.Node*, align 8
  %11 = alloca %struct.Node*, align 8
  %12 = alloca i8, align 1
  br label %13

13:                                               ; preds = %0, %89
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i32 noundef 61, i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__PRETTY_FUNCTION__.dequeue, i64 0, i64 0)) #5
  unreachable

22:                                               ; preds = %20
  %23 = load %struct.Node*, %struct.Node** %1, align 8
  %24 = getelementptr inbounds %struct.Node, %struct.Node* %23, i32 0, i32 1
  %25 = bitcast %struct.Node** %24 to i64*
  %26 = bitcast %struct.Node** %6 to i64*
  %27 = load atomic i64, i64* %25 acquire, align 8
  store i64 %27, i64* %26, align 8
  %28 = bitcast i64* %26 to %struct.Node**
  %29 = load %struct.Node*, %struct.Node** %28, align 8
  store %struct.Node* %29, %struct.Node** %2, align 8
  %30 = load %struct.Node*, %struct.Node** %1, align 8
  %31 = bitcast %struct.Node** %7 to i64*
  %32 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8
  store i64 %32, i64* %31, align 8
  %33 = bitcast i64* %31 to %struct.Node**
  %34 = load %struct.Node*, %struct.Node** %33, align 8
  %35 = icmp eq %struct.Node* %30, %34
  br i1 %35, label %36, label %89

36:                                               ; preds = %22
  %37 = load %struct.Node*, %struct.Node** %2, align 8
  %38 = icmp eq %struct.Node* %37, null
  br i1 %38, label %39, label %40

39:                                               ; preds = %36
  store i32 -1, i32* %4, align 4
  br label %90

40:                                               ; preds = %36
  %41 = load %struct.Node*, %struct.Node** %2, align 8
  %42 = getelementptr inbounds %struct.Node, %struct.Node* %41, i32 0, i32 0
  %43 = load i32, i32* %42, align 8
  store i32 %43, i32* %4, align 4
  %44 = load %struct.Node*, %struct.Node** %2, align 8
  store %struct.Node* %44, %struct.Node** %8, align 8
  %45 = bitcast %struct.Node** %1 to i64*
  %46 = bitcast %struct.Node** %8 to i64*
  %47 = load i64, i64* %45, align 8
  %48 = load i64, i64* %46, align 8
  %49 = cmpxchg i64* bitcast (%struct.Node** @Head to i64*), i64 %47, i64 %48 monotonic monotonic, align 8
  %50 = extractvalue { i64, i1 } %49, 0
  %51 = extractvalue { i64, i1 } %49, 1
  br i1 %51, label %53, label %52

52:                                               ; preds = %40
  store i64 %50, i64* %45, align 8
  br label %53

53:                                               ; preds = %52, %40
  %54 = zext i1 %51 to i8
  store i8 %54, i8* %9, align 1
  %55 = load i8, i8* %9, align 1
  %56 = trunc i8 %55 to i1
  br i1 %56, label %57, label %87

57:                                               ; preds = %53
  %58 = bitcast %struct.Node** %10 to i64*
  %59 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8
  store i64 %59, i64* %58, align 8
  %60 = bitcast i64* %58 to %struct.Node**
  %61 = load %struct.Node*, %struct.Node** %60, align 8
  store %struct.Node* %61, %struct.Node** %3, align 8
  %62 = load %struct.Node*, %struct.Node** %3, align 8
  %63 = icmp ne %struct.Node* %62, null
  br i1 %63, label %64, label %65

64:                                               ; preds = %57
  br label %66

65:                                               ; preds = %57
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i32 noundef 73, i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__PRETTY_FUNCTION__.dequeue, i64 0, i64 0)) #5
  unreachable

66:                                               ; preds = %64
  %67 = load %struct.Node*, %struct.Node** %1, align 8
  %68 = load %struct.Node*, %struct.Node** %3, align 8
  %69 = icmp eq %struct.Node* %67, %68
  br i1 %69, label %70, label %84

70:                                               ; preds = %66
  %71 = load %struct.Node*, %struct.Node** %2, align 8
  store %struct.Node* %71, %struct.Node** %11, align 8
  %72 = bitcast %struct.Node** %3 to i64*
  %73 = bitcast %struct.Node** %11 to i64*
  %74 = load i64, i64* %72, align 8
  %75 = load i64, i64* %73, align 8
  %76 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %74, i64 %75 monotonic monotonic, align 8
  %77 = extractvalue { i64, i1 } %76, 0
  %78 = extractvalue { i64, i1 } %76, 1
  br i1 %78, label %80, label %79

79:                                               ; preds = %70
  store i64 %77, i64* %72, align 8
  br label %80

80:                                               ; preds = %79, %70
  %81 = zext i1 %78 to i8
  store i8 %81, i8* %12, align 1
  %82 = load i8, i8* %12, align 1
  %83 = trunc i8 %82 to i1
  br label %84

84:                                               ; preds = %80, %66
  %85 = load %struct.Node*, %struct.Node** %1, align 8
  %86 = bitcast %struct.Node* %85 to i8*
  call void @free(i8* noundef %86) #4
  br label %90

87:                                               ; preds = %53
  br label %88

88:                                               ; preds = %87
  br label %89

89:                                               ; preds = %88, %22
  br label %13

90:                                               ; preds = %84, %39
  %91 = load i32, i32* %4, align 4
  ret i32 %91
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.4, i64 0, i64 0), i32 noundef 18, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.worker, i64 0, i64 0)) #5
  unreachable

14:                                               ; preds = %12
  %15 = load i32, i32* %4, align 4
  %16 = sext i32 %15 to i64
  %17 = getelementptr inbounds [3 x i32], [3 x i32]* @data, i64 0, i64 %16
  store i32 1, i32* %17, align 4
  ret i8* null
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @init()
  store i32 0, i32* %3, align 4
  br label %7

7:                                                ; preds = %18, %0
  %8 = load i32, i32* %3, align 4
  %9 = icmp slt i32 %8, 3
  br i1 %9, label %10, label %21

10:                                               ; preds = %7
  %11 = load i32, i32* %3, align 4
  %12 = sext i32 %11 to i64
  %13 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %12
  %14 = load i32, i32* %3, align 4
  %15 = sext i32 %14 to i64
  %16 = inttoptr i64 %15 to i8*
  %17 = call i32 @pthread_create(i64* noundef %13, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef %16) #4
  br label %18

18:                                               ; preds = %10
  %19 = load i32, i32* %3, align 4
  %20 = add nsw i32 %19, 1
  store i32 %20, i32* %3, align 4
  br label %7, !llvm.loop !6

21:                                               ; preds = %7
  store i32 0, i32* %4, align 4
  br label %22

22:                                               ; preds = %31, %21
  %23 = load i32, i32* %4, align 4
  %24 = icmp slt i32 %23, 3
  br i1 %24, label %25, label %34

25:                                               ; preds = %22
  %26 = load i32, i32* %4, align 4
  %27 = sext i32 %26 to i64
  %28 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %27
  %29 = load i64, i64* %28, align 8
  %30 = call i32 @pthread_join(i64 noundef %29, i8** noundef null)
  br label %31

31:                                               ; preds = %25
  %32 = load i32, i32* %4, align 4
  %33 = add nsw i32 %32, 1
  store i32 %33, i32* %4, align 4
  br label %22, !llvm.loop !8

34:                                               ; preds = %22
  %35 = call i32 @dequeue()
  store i32 %35, i32* %5, align 4
  %36 = load i32, i32* %5, align 4
  %37 = icmp eq i32 %36, -1
  br i1 %37, label %38, label %39

38:                                               ; preds = %34
  br label %40

39:                                               ; preds = %34
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.4, i64 0, i64 0), i32 noundef 37, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5
  unreachable

40:                                               ; preds = %38
  %41 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) seq_cst, align 8
  %42 = inttoptr i64 %41 to %struct.Node*
  %43 = bitcast %struct.Node* %42 to i8*
  call void @free(i8* noundef %43) #4
  store i32 0, i32* %6, align 4
  br label %44

44:                                               ; preds = %56, %40
  %45 = load i32, i32* %6, align 4
  %46 = icmp slt i32 %45, 3
  br i1 %46, label %47, label %59

47:                                               ; preds = %44
  %48 = load i32, i32* %6, align 4
  %49 = sext i32 %48 to i64
  %50 = getelementptr inbounds [3 x i32], [3 x i32]* @data, i64 0, i64 %49
  %51 = load i32, i32* %50, align 4
  %52 = icmp eq i32 %51, 1
  br i1 %52, label %53, label %54

53:                                               ; preds = %47
  br label %55

54:                                               ; preds = %47
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.4, i64 0, i64 0), i32 noundef 41, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5
  unreachable

55:                                               ; preds = %53
  br label %56

56:                                               ; preds = %55
  %57 = load i32, i32* %6, align 4
  %58 = add nsw i32 %57, 1
  store i32 %58, i32* %6, align 4
  br label %44, !llvm.loop !9

59:                                               ; preds = %44
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
