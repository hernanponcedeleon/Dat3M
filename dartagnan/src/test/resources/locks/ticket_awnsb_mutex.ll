; ModuleID = 'benchmarks/locks/ticket_awnsb_mutex.c'
source_filename = "benchmarks/locks/ticket_awnsb_mutex.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.awnsb_node_t = type { i32 }
%struct.ticket_awnsb_mutex_t = type { i32, [8 x i8], i32, [8 x i8], i32, %struct.awnsb_node_t** }
%union.pthread_attr_t = type { i64, [48 x i8] }

@tlNode = internal thread_local global %struct.awnsb_node_t zeroinitializer, align 4
@sum = dso_local global i32 0, align 4
@lock = dso_local global %struct.ticket_awnsb_mutex_t zeroinitializer, align 8
@shared = dso_local global i32 0, align 4
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [38 x i8] c"benchmarks/locks/ticket_awnsb_mutex.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @ticket_awnsb_mutex_init(%struct.ticket_awnsb_mutex_t* noundef %0, i32 noundef %1) #0 {
  %3 = alloca %struct.ticket_awnsb_mutex_t*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.ticket_awnsb_mutex_t* %0, %struct.ticket_awnsb_mutex_t** %3, align 8
  store i32 %1, i32* %4, align 4
  %6 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %7 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %6, i32 0, i32 0
  store i32 0, i32* %7, align 4
  %8 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %9 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %8, i32 0, i32 2
  store i32 0, i32* %9, align 4
  %10 = load i32, i32* %4, align 4
  %11 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %12 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %11, i32 0, i32 4
  store i32 %10, i32* %12, align 8
  %13 = load i32, i32* %4, align 4
  %14 = sext i32 %13 to i64
  %15 = mul i64 %14, 8
  %16 = call noalias i8* @malloc(i64 noundef %15) #4
  %17 = bitcast i8* %16 to %struct.awnsb_node_t**
  %18 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %19 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %18, i32 0, i32 5
  store %struct.awnsb_node_t** %17, %struct.awnsb_node_t*** %19, align 8
  call void @__VERIFIER_loop_bound(i32 noundef 4)
  store i32 0, i32* %5, align 4
  br label %20

20:                                               ; preds = %33, %2
  %21 = load i32, i32* %5, align 4
  %22 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %23 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %22, i32 0, i32 4
  %24 = load i32, i32* %23, align 8
  %25 = icmp slt i32 %21, %24
  br i1 %25, label %26, label %36

26:                                               ; preds = %20
  %27 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %28 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %27, i32 0, i32 5
  %29 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %28, align 8
  %30 = load i32, i32* %5, align 4
  %31 = sext i32 %30 to i64
  %32 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %29, i64 %31
  store %struct.awnsb_node_t* null, %struct.awnsb_node_t** %32, align 8
  br label %33

33:                                               ; preds = %26
  %34 = load i32, i32* %5, align 4
  %35 = add nsw i32 %34, 1
  store i32 %35, i32* %5, align 4
  br label %20, !llvm.loop !6

36:                                               ; preds = %20
  ret void
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #1

declare void @__VERIFIER_loop_bound(i32 noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @ticket_awnsb_mutex_destroy(%struct.ticket_awnsb_mutex_t* noundef %0) #0 {
  %2 = alloca %struct.ticket_awnsb_mutex_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %struct.ticket_awnsb_mutex_t* %0, %struct.ticket_awnsb_mutex_t** %2, align 8
  %5 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %6 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %5, i32 0, i32 0
  store i32 0, i32* %3, align 4
  %7 = load i32, i32* %3, align 4
  store atomic i32 %7, i32* %6 seq_cst, align 8
  %8 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %9 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %8, i32 0, i32 2
  store i32 0, i32* %4, align 4
  %10 = load i32, i32* %4, align 4
  store atomic i32 %10, i32* %9 seq_cst, align 4
  %11 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %12 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %11, i32 0, i32 5
  %13 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %12, align 8
  %14 = bitcast %struct.awnsb_node_t** %13 to i8*
  call void @free(i8* noundef %14) #4
  ret void
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @ticket_awnsb_mutex_lock(%struct.ticket_awnsb_mutex_t* noundef %0) #0 {
  %2 = alloca %struct.ticket_awnsb_mutex_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca %struct.awnsb_node_t*, align 8
  %11 = alloca i32, align 4
  %12 = alloca %struct.awnsb_node_t*, align 8
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  store %struct.ticket_awnsb_mutex_t* %0, %struct.ticket_awnsb_mutex_t** %2, align 8
  %19 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %20 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %19, i32 0, i32 0
  store i32 1, i32* %4, align 4
  %21 = load i32, i32* %4, align 4
  %22 = atomicrmw add i32* %20, i32 %21 monotonic, align 4
  store i32 %22, i32* %5, align 4
  %23 = load i32, i32* %5, align 4
  store i32 %23, i32* %3, align 4
  %24 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %25 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %24, i32 0, i32 2
  %26 = load atomic i32, i32* %25 acquire, align 4
  store i32 %26, i32* %6, align 4
  %27 = load i32, i32* %6, align 4
  %28 = load i32, i32* %3, align 4
  %29 = icmp eq i32 %27, %28
  br i1 %29, label %30, label %31

30:                                               ; preds = %1
  br label %123

31:                                               ; preds = %1
  br label %32

32:                                               ; preds = %48, %31
  %33 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %34 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %33, i32 0, i32 2
  %35 = load atomic i32, i32* %34 monotonic, align 4
  store i32 %35, i32* %7, align 4
  %36 = load i32, i32* %7, align 4
  %37 = load i32, i32* %3, align 4
  %38 = sub nsw i32 %37, 1
  %39 = icmp sge i32 %36, %38
  br i1 %39, label %40, label %49

40:                                               ; preds = %32
  %41 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %42 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %41, i32 0, i32 2
  %43 = load atomic i32, i32* %42 acquire, align 4
  store i32 %43, i32* %8, align 4
  %44 = load i32, i32* %8, align 4
  %45 = load i32, i32* %3, align 4
  %46 = icmp eq i32 %44, %45
  br i1 %46, label %47, label %48

47:                                               ; preds = %40
  br label %123

48:                                               ; preds = %40
  br label %32, !llvm.loop !8

49:                                               ; preds = %32
  br label %50

50:                                               ; preds = %62, %49
  %51 = load i32, i32* %3, align 4
  %52 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %53 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %52, i32 0, i32 2
  %54 = load atomic i32, i32* %53 monotonic, align 4
  store i32 %54, i32* %9, align 4
  %55 = load i32, i32* %9, align 4
  %56 = sub nsw i32 %51, %55
  %57 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %58 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %57, i32 0, i32 4
  %59 = load i32, i32* %58, align 8
  %60 = sub nsw i32 %59, 1
  %61 = icmp sge i32 %56, %60
  br i1 %61, label %62, label %63

62:                                               ; preds = %50
  br label %50, !llvm.loop !9

63:                                               ; preds = %50
  store %struct.awnsb_node_t* @tlNode, %struct.awnsb_node_t** %10, align 8
  %64 = load %struct.awnsb_node_t*, %struct.awnsb_node_t** %10, align 8
  %65 = getelementptr inbounds %struct.awnsb_node_t, %struct.awnsb_node_t* %64, i32 0, i32 0
  store i32 0, i32* %11, align 4
  %66 = load i32, i32* %11, align 4
  store atomic i32 %66, i32* %65 monotonic, align 4
  %67 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %68 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %67, i32 0, i32 5
  %69 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %68, align 8
  %70 = load i32, i32* %3, align 4
  %71 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %72 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %71, i32 0, i32 4
  %73 = load i32, i32* %72, align 8
  %74 = srem i32 %70, %73
  %75 = sext i32 %74 to i64
  %76 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %69, i64 %75
  %77 = load %struct.awnsb_node_t*, %struct.awnsb_node_t** %10, align 8
  store %struct.awnsb_node_t* %77, %struct.awnsb_node_t** %12, align 8
  %78 = bitcast %struct.awnsb_node_t** %76 to i64*
  %79 = bitcast %struct.awnsb_node_t** %12 to i64*
  %80 = load i64, i64* %79, align 8
  store atomic i64 %80, i64* %78 release, align 8
  %81 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %82 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %81, i32 0, i32 2
  %83 = load atomic i32, i32* %82 monotonic, align 4
  store i32 %83, i32* %13, align 4
  %84 = load i32, i32* %13, align 4
  %85 = load i32, i32* %3, align 4
  %86 = sub nsw i32 %85, 1
  %87 = icmp slt i32 %84, %86
  br i1 %87, label %88, label %102

88:                                               ; preds = %63
  br label %89

89:                                               ; preds = %96, %88
  %90 = load %struct.awnsb_node_t*, %struct.awnsb_node_t** %10, align 8
  %91 = getelementptr inbounds %struct.awnsb_node_t, %struct.awnsb_node_t* %90, i32 0, i32 0
  %92 = load atomic i32, i32* %91 monotonic, align 4
  store i32 %92, i32* %14, align 4
  %93 = load i32, i32* %14, align 4
  %94 = icmp ne i32 %93, 0
  %95 = xor i1 %94, true
  br i1 %95, label %96, label %97

96:                                               ; preds = %89
  br label %89, !llvm.loop !10

97:                                               ; preds = %89
  %98 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %99 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %98, i32 0, i32 2
  %100 = load i32, i32* %3, align 4
  store i32 %100, i32* %15, align 4
  %101 = load i32, i32* %15, align 4
  store atomic i32 %101, i32* %99 monotonic, align 4
  br label %123

102:                                              ; preds = %63
  br label %103

103:                                              ; preds = %121, %102
  %104 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %105 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %104, i32 0, i32 2
  %106 = load atomic i32, i32* %105 acquire, align 4
  store i32 %106, i32* %16, align 4
  %107 = load i32, i32* %16, align 4
  %108 = load i32, i32* %3, align 4
  %109 = icmp ne i32 %107, %108
  br i1 %109, label %110, label %122

110:                                              ; preds = %103
  %111 = load %struct.awnsb_node_t*, %struct.awnsb_node_t** %10, align 8
  %112 = getelementptr inbounds %struct.awnsb_node_t, %struct.awnsb_node_t* %111, i32 0, i32 0
  %113 = load atomic i32, i32* %112 acquire, align 4
  store i32 %113, i32* %17, align 4
  %114 = load i32, i32* %17, align 4
  %115 = icmp ne i32 %114, 0
  br i1 %115, label %116, label %121

116:                                              ; preds = %110
  %117 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %118 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %117, i32 0, i32 2
  %119 = load i32, i32* %3, align 4
  store i32 %119, i32* %18, align 4
  %120 = load i32, i32* %18, align 4
  store atomic i32 %120, i32* %118 monotonic, align 4
  br label %123

121:                                              ; preds = %110
  br label %103, !llvm.loop !11

122:                                              ; preds = %103
  br label %123

123:                                              ; preds = %30, %47, %116, %122, %97
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @ticket_awnsb_mutex_unlock(%struct.ticket_awnsb_mutex_t* noundef %0) #0 {
  %2 = alloca %struct.ticket_awnsb_mutex_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca %struct.awnsb_node_t*, align 8
  %6 = alloca %struct.awnsb_node_t*, align 8
  %7 = alloca %struct.awnsb_node_t*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store %struct.ticket_awnsb_mutex_t* %0, %struct.ticket_awnsb_mutex_t** %2, align 8
  %10 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %11 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %10, i32 0, i32 2
  %12 = load atomic i32, i32* %11 monotonic, align 4
  store i32 %12, i32* %4, align 4
  %13 = load i32, i32* %4, align 4
  store i32 %13, i32* %3, align 4
  %14 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %15 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %14, i32 0, i32 5
  %16 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %15, align 8
  %17 = load i32, i32* %3, align 4
  %18 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %19 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %18, i32 0, i32 4
  %20 = load i32, i32* %19, align 8
  %21 = srem i32 %17, %20
  %22 = sext i32 %21 to i64
  %23 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %16, i64 %22
  store %struct.awnsb_node_t* null, %struct.awnsb_node_t** %5, align 8
  %24 = bitcast %struct.awnsb_node_t** %23 to i64*
  %25 = bitcast %struct.awnsb_node_t** %5 to i64*
  %26 = load i64, i64* %25, align 8
  store atomic i64 %26, i64* %24 monotonic, align 8
  %27 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %28 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %27, i32 0, i32 5
  %29 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %28, align 8
  %30 = load i32, i32* %3, align 4
  %31 = add nsw i32 %30, 1
  %32 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %33 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %32, i32 0, i32 4
  %34 = load i32, i32* %33, align 8
  %35 = srem i32 %31, %34
  %36 = sext i32 %35 to i64
  %37 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %29, i64 %36
  %38 = bitcast %struct.awnsb_node_t** %37 to i64*
  %39 = bitcast %struct.awnsb_node_t** %7 to i64*
  %40 = load atomic i64, i64* %38 acquire, align 8
  store i64 %40, i64* %39, align 8
  %41 = bitcast i64* %39 to %struct.awnsb_node_t**
  %42 = load %struct.awnsb_node_t*, %struct.awnsb_node_t** %41, align 8
  store %struct.awnsb_node_t* %42, %struct.awnsb_node_t** %6, align 8
  %43 = load %struct.awnsb_node_t*, %struct.awnsb_node_t** %6, align 8
  %44 = icmp ne %struct.awnsb_node_t* %43, null
  br i1 %44, label %45, label %49

45:                                               ; preds = %1
  %46 = load %struct.awnsb_node_t*, %struct.awnsb_node_t** %6, align 8
  %47 = getelementptr inbounds %struct.awnsb_node_t, %struct.awnsb_node_t* %46, i32 0, i32 0
  store i32 1, i32* %8, align 4
  %48 = load i32, i32* %8, align 4
  store atomic i32 %48, i32* %47 release, align 4
  br label %55

49:                                               ; preds = %1
  %50 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %51 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %50, i32 0, i32 2
  %52 = load i32, i32* %3, align 4
  %53 = add nsw i32 %52, 1
  store i32 %53, i32* %9, align 4
  %54 = load i32, i32* %9, align 4
  store atomic i32 %54, i32* %51 release, align 4
  br label %55

55:                                               ; preds = %49, %45
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ticket_awnsb_mutex_trylock(%struct.ticket_awnsb_mutex_t* noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.ticket_awnsb_mutex_t*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i8, align 1
  store %struct.ticket_awnsb_mutex_t* %0, %struct.ticket_awnsb_mutex_t** %3, align 8
  %10 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %11 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %10, i32 0, i32 2
  %12 = load atomic i32, i32* %11 seq_cst, align 4
  store i32 %12, i32* %5, align 4
  %13 = load i32, i32* %5, align 4
  store i32 %13, i32* %4, align 4
  %14 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %15 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %14, i32 0, i32 0
  %16 = load atomic i32, i32* %15 monotonic, align 8
  store i32 %16, i32* %7, align 4
  %17 = load i32, i32* %7, align 4
  store i32 %17, i32* %6, align 4
  %18 = load i32, i32* %4, align 4
  %19 = load i32, i32* %6, align 4
  %20 = icmp ne i32 %18, %19
  br i1 %20, label %21, label %22

21:                                               ; preds = %1
  store i32 16, i32* %2, align 4
  br label %41

22:                                               ; preds = %1
  %23 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %24 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %23, i32 0, i32 0
  %25 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %26 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %25, i32 0, i32 0
  %27 = load atomic i32, i32* %26 seq_cst, align 4
  %28 = add nsw i32 %27, 1
  store i32 %28, i32* %8, align 4
  %29 = load i32, i32* %6, align 4
  %30 = load i32, i32* %8, align 4
  %31 = cmpxchg i32* %24, i32 %29, i32 %30 seq_cst seq_cst, align 4
  %32 = extractvalue { i32, i1 } %31, 0
  %33 = extractvalue { i32, i1 } %31, 1
  br i1 %33, label %35, label %34

34:                                               ; preds = %22
  store i32 %32, i32* %6, align 4
  br label %35

35:                                               ; preds = %34, %22
  %36 = zext i1 %33 to i8
  store i8 %36, i8* %9, align 1
  %37 = load i8, i8* %9, align 1
  %38 = trunc i8 %37 to i1
  br i1 %38, label %40, label %39

39:                                               ; preds = %35
  store i32 16, i32* %2, align 4
  br label %41

40:                                               ; preds = %35
  store i32 0, i32* %2, align 4
  br label %41

41:                                               ; preds = %40, %39, %21
  %42 = load i32, i32* %2, align 4
  ret i32 %42
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  %5 = load i8*, i8** %2, align 8
  %6 = ptrtoint i8* %5 to i64
  store i64 %6, i64* %3, align 8
  call void @ticket_awnsb_mutex_lock(%struct.ticket_awnsb_mutex_t* noundef @lock)
  %7 = load i64, i64* %3, align 8
  %8 = trunc i64 %7 to i32
  store i32 %8, i32* @shared, align 4
  %9 = load i32, i32* @shared, align 4
  store i32 %9, i32* %4, align 4
  %10 = load i32, i32* %4, align 4
  %11 = sext i32 %10 to i64
  %12 = load i64, i64* %3, align 8
  %13 = icmp eq i64 %11, %12
  br i1 %13, label %14, label %15

14:                                               ; preds = %1
  br label %16

15:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5
  unreachable

16:                                               ; preds = %14
  %17 = load i32, i32* @sum, align 4
  %18 = add nsw i32 %17, 1
  store i32 %18, i32* @sum, align 4
  call void @ticket_awnsb_mutex_unlock(%struct.ticket_awnsb_mutex_t* noundef @lock)
  ret i8* null
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @ticket_awnsb_mutex_init(%struct.ticket_awnsb_mutex_t* noundef @lock, i32 noundef 3)
  store i32 0, i32* %3, align 4
  br label %5

5:                                                ; preds = %16, %0
  %6 = load i32, i32* %3, align 4
  %7 = icmp slt i32 %6, 3
  br i1 %7, label %8, label %19

8:                                                ; preds = %5
  %9 = load i32, i32* %3, align 4
  %10 = sext i32 %9 to i64
  %11 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %10
  %12 = load i32, i32* %3, align 4
  %13 = sext i32 %12 to i64
  %14 = inttoptr i64 %13 to i8*
  %15 = call i32 @pthread_create(i64* noundef %11, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef %14) #4
  br label %16

16:                                               ; preds = %8
  %17 = load i32, i32* %3, align 4
  %18 = add nsw i32 %17, 1
  store i32 %18, i32* %3, align 4
  br label %5, !llvm.loop !12

19:                                               ; preds = %5
  store i32 0, i32* %4, align 4
  br label %20

20:                                               ; preds = %29, %19
  %21 = load i32, i32* %4, align 4
  %22 = icmp slt i32 %21, 3
  br i1 %22, label %23, label %32

23:                                               ; preds = %20
  %24 = load i32, i32* %4, align 4
  %25 = sext i32 %24 to i64
  %26 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %25
  %27 = load i64, i64* %26, align 8
  %28 = call i32 @pthread_join(i64 noundef %27, i8** noundef null)
  br label %29

29:                                               ; preds = %23
  %30 = load i32, i32* %4, align 4
  %31 = add nsw i32 %30, 1
  store i32 %31, i32* %4, align 4
  br label %20, !llvm.loop !13

32:                                               ; preds = %20
  %33 = load i32, i32* @sum, align 4
  %34 = icmp eq i32 %33, 3
  br i1 %34, label %35, label %36

35:                                               ; preds = %32
  br label %37

36:                                               ; preds = %32
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5
  unreachable

37:                                               ; preds = %35
  call void @ticket_awnsb_mutex_destroy(%struct.ticket_awnsb_mutex_t* noundef @lock)
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #1

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
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
!11 = distinct !{!11, !7}
!12 = distinct !{!12, !7}
!13 = distinct !{!13, !7}
