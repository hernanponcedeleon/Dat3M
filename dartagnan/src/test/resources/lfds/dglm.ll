; ModuleID = 'benchmarks/lfds/dglm.c'
source_filename = "benchmarks/lfds/dglm.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Node = type { i32, %struct.Node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@retired_count = dso_local global i32 0, align 4
@Head = dso_local global %struct.Node* null, align 8
@Tail = dso_local global %struct.Node* null, align 8
@.str = private unnamed_addr constant [13 x i8] c"tail != NULL\00", align 1
@.str.1 = private unnamed_addr constant [23 x i8] c"benchmarks/lfds/dglm.h\00", align 1
@__PRETTY_FUNCTION__.enqueue = private unnamed_addr constant [18 x i8] c"void enqueue(int)\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"head != NULL\00", align 1
@__PRETTY_FUNCTION__.dequeue = private unnamed_addr constant [14 x i8] c"int dequeue()\00", align 1
@retired = dso_local global [10 x %struct.Node*] zeroinitializer, align 16
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i32 noundef 42, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.enqueue, i64 0, i64 0)) #5
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
  %57 = cmpxchg i64* %52, i64 %55, i64 %56 acq_rel monotonic, align 8
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
  %71 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %69, i64 %70 acq_rel monotonic, align 8
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
  %86 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %84, i64 %85 acq_rel monotonic, align 8
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
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  br label %15

15:                                               ; preds = %0, %95
  %16 = bitcast %struct.Node** %5 to i64*
  %17 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8
  store i64 %17, i64* %16, align 8
  %18 = bitcast i64* %16 to %struct.Node**
  %19 = load %struct.Node*, %struct.Node** %18, align 8
  store %struct.Node* %19, %struct.Node** %1, align 8
  %20 = load %struct.Node*, %struct.Node** %1, align 8
  %21 = icmp ne %struct.Node* %20, null
  br i1 %21, label %22, label %23

22:                                               ; preds = %15
  br label %24

23:                                               ; preds = %15
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i32 noundef 65, i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__PRETTY_FUNCTION__.dequeue, i64 0, i64 0)) #5
  unreachable

24:                                               ; preds = %22
  %25 = load %struct.Node*, %struct.Node** %1, align 8
  %26 = getelementptr inbounds %struct.Node, %struct.Node* %25, i32 0, i32 1
  %27 = bitcast %struct.Node** %26 to i64*
  %28 = bitcast %struct.Node** %6 to i64*
  %29 = load atomic i64, i64* %27 acquire, align 8
  store i64 %29, i64* %28, align 8
  %30 = bitcast i64* %28 to %struct.Node**
  %31 = load %struct.Node*, %struct.Node** %30, align 8
  store %struct.Node* %31, %struct.Node** %2, align 8
  %32 = load %struct.Node*, %struct.Node** %1, align 8
  %33 = bitcast %struct.Node** %7 to i64*
  %34 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8
  store i64 %34, i64* %33, align 8
  %35 = bitcast i64* %33 to %struct.Node**
  %36 = load %struct.Node*, %struct.Node** %35, align 8
  %37 = icmp eq %struct.Node* %32, %36
  br i1 %37, label %38, label %95

38:                                               ; preds = %24
  %39 = load %struct.Node*, %struct.Node** %2, align 8
  %40 = icmp eq %struct.Node* %39, null
  br i1 %40, label %41, label %42

41:                                               ; preds = %38
  store i32 -1, i32* %4, align 4
  br label %96

42:                                               ; preds = %38
  %43 = load %struct.Node*, %struct.Node** %2, align 8
  %44 = getelementptr inbounds %struct.Node, %struct.Node* %43, i32 0, i32 0
  %45 = load i32, i32* %44, align 8
  store i32 %45, i32* %4, align 4
  %46 = load %struct.Node*, %struct.Node** %2, align 8
  store %struct.Node* %46, %struct.Node** %8, align 8
  %47 = bitcast %struct.Node** %1 to i64*
  %48 = bitcast %struct.Node** %8 to i64*
  %49 = load i64, i64* %47, align 8
  %50 = load i64, i64* %48, align 8
  %51 = cmpxchg i64* bitcast (%struct.Node** @Head to i64*), i64 %49, i64 %50 acq_rel monotonic, align 8
  %52 = extractvalue { i64, i1 } %51, 0
  %53 = extractvalue { i64, i1 } %51, 1
  br i1 %53, label %55, label %54

54:                                               ; preds = %42
  store i64 %52, i64* %47, align 8
  br label %55

55:                                               ; preds = %54, %42
  %56 = zext i1 %53 to i8
  store i8 %56, i8* %9, align 1
  %57 = load i8, i8* %9, align 1
  %58 = trunc i8 %57 to i1
  br i1 %58, label %59, label %93

59:                                               ; preds = %55
  %60 = bitcast %struct.Node** %10 to i64*
  %61 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8
  store i64 %61, i64* %60, align 8
  %62 = bitcast i64* %60 to %struct.Node**
  %63 = load %struct.Node*, %struct.Node** %62, align 8
  store %struct.Node* %63, %struct.Node** %3, align 8
  %64 = load %struct.Node*, %struct.Node** %3, align 8
  %65 = icmp ne %struct.Node* %64, null
  br i1 %65, label %66, label %67

66:                                               ; preds = %59
  br label %68

67:                                               ; preds = %59
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i32 noundef 77, i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__PRETTY_FUNCTION__.dequeue, i64 0, i64 0)) #5
  unreachable

68:                                               ; preds = %66
  %69 = load %struct.Node*, %struct.Node** %1, align 8
  %70 = load %struct.Node*, %struct.Node** %3, align 8
  %71 = icmp eq %struct.Node* %69, %70
  br i1 %71, label %72, label %86

72:                                               ; preds = %68
  %73 = load %struct.Node*, %struct.Node** %2, align 8
  store %struct.Node* %73, %struct.Node** %11, align 8
  %74 = bitcast %struct.Node** %3 to i64*
  %75 = bitcast %struct.Node** %11 to i64*
  %76 = load i64, i64* %74, align 8
  %77 = load i64, i64* %75, align 8
  %78 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %76, i64 %77 acq_rel monotonic, align 8
  %79 = extractvalue { i64, i1 } %78, 0
  %80 = extractvalue { i64, i1 } %78, 1
  br i1 %80, label %82, label %81

81:                                               ; preds = %72
  store i64 %79, i64* %74, align 8
  br label %82

82:                                               ; preds = %81, %72
  %83 = zext i1 %80 to i8
  store i8 %83, i8* %12, align 1
  %84 = load i8, i8* %12, align 1
  %85 = trunc i8 %84 to i1
  br label %86

86:                                               ; preds = %82, %68
  %87 = load %struct.Node*, %struct.Node** %1, align 8
  store i32 1, i32* %13, align 4
  %88 = load i32, i32* %13, align 4
  %89 = atomicrmw add i32* @retired_count, i32 %88 seq_cst, align 4
  store i32 %89, i32* %14, align 4
  %90 = load i32, i32* %14, align 4
  %91 = sext i32 %90 to i64
  %92 = getelementptr inbounds [10 x %struct.Node*], [10 x %struct.Node*]* @retired, i64 0, i64 %91
  store %struct.Node* %87, %struct.Node** %92, align 8
  br label %96

93:                                               ; preds = %55
  br label %94

94:                                               ; preds = %93
  br label %95

95:                                               ; preds = %94, %24
  br label %15

96:                                               ; preds = %86, %41
  %97 = load i32, i32* %4, align 4
  ret i32 %97
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
  br label %7, !llvm.loop !8

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
  br label %22, !llvm.loop !9

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
  call void @free_all_retired()
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.4, i64 0, i64 0), i32 noundef 43, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5
  unreachable

55:                                               ; preds = %53
  br label %56

56:                                               ; preds = %55
  %57 = load i32, i32* %6, align 4
  %58 = add nsw i32 %57, 1
  store i32 %58, i32* %6, align 4
  br label %44, !llvm.loop !10

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
!10 = distinct !{!10, !7}
