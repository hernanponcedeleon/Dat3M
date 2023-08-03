; ModuleID = 'ticket_awnsb_mutex.ll'
source_filename = "benchmarks/locks/ticket_awnsb_mutex.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.awnsb_node_t.0 = type { i32 }
%struct.ticket_awnsb_mutex_t = type { i32, [8 x i8], i32, [8 x i8], i32, %struct.awnsb_node_t** }
%struct.awnsb_node_t = type opaque
%union.pthread_attr_t = type { i64, [48 x i8] }

@tlNode = internal thread_local global %struct.awnsb_node_t.0 zeroinitializer, align 4
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
  %13 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %14 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %13, i32 0, i32 4
  %15 = load i32, i32* %14, align 8
  %16 = sext i32 %15 to i64
  %17 = mul i64 %16, 8
  %18 = call noalias i8* @malloc(i64 noundef %17) #4
  %19 = bitcast i8* %18 to %struct.awnsb_node_t.0**
  %20 = bitcast %struct.awnsb_node_t.0** %19 to %struct.awnsb_node_t**
  %21 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %22 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %21, i32 0, i32 5
  store %struct.awnsb_node_t** %20, %struct.awnsb_node_t*** %22, align 8
  call void @__VERIFIER_loop_bound(i32 noundef 4)
  store i32 0, i32* %5, align 4
  br label %23

23:                                               ; preds = %37, %2
  %24 = load i32, i32* %5, align 4
  %25 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %26 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %25, i32 0, i32 4
  %27 = load i32, i32* %26, align 8
  %28 = icmp slt i32 %24, %27
  br i1 %28, label %29, label %40

29:                                               ; preds = %23
  %30 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %31 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %30, i32 0, i32 5
  %32 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %31, align 8
  %33 = load i32, i32* %5, align 4
  %34 = sext i32 %33 to i64
  %35 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %32, i64 %34
  %36 = bitcast %struct.awnsb_node_t** %35 to i64*
  store atomic i64 0, i64* %36 seq_cst, align 8
  br label %37

37:                                               ; preds = %29
  %38 = load i32, i32* %5, align 4
  %39 = add nsw i32 %38, 1
  store i32 %39, i32* %5, align 4
  br label %23, !llvm.loop !6

40:                                               ; preds = %23
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
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca %struct.awnsb_node_t.0*, align 8
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
  %24 = sext i32 %23 to i64
  store i64 %24, i64* %3, align 8
  %25 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %26 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %25, i32 0, i32 2
  %27 = load atomic i32, i32* %26 acquire, align 4
  store i32 %27, i32* %6, align 4
  %28 = load i32, i32* %6, align 4
  %29 = sext i32 %28 to i64
  %30 = load i64, i64* %3, align 8
  %31 = icmp eq i64 %29, %30
  br i1 %31, label %32, label %33

32:                                               ; preds = %1
  br label %136

33:                                               ; preds = %1
  br label %34

34:                                               ; preds = %52, %33
  %35 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %36 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %35, i32 0, i32 2
  %37 = load atomic i32, i32* %36 monotonic, align 4
  store i32 %37, i32* %7, align 4
  %38 = load i32, i32* %7, align 4
  %39 = sext i32 %38 to i64
  %40 = load i64, i64* %3, align 8
  %41 = sub nsw i64 %40, 1
  %42 = icmp sge i64 %39, %41
  br i1 %42, label %43, label %53

43:                                               ; preds = %34
  %44 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %45 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %44, i32 0, i32 2
  %46 = load atomic i32, i32* %45 acquire, align 4
  store i32 %46, i32* %8, align 4
  %47 = load i32, i32* %8, align 4
  %48 = sext i32 %47 to i64
  %49 = load i64, i64* %3, align 8
  %50 = icmp eq i64 %48, %49
  br i1 %50, label %51, label %52

51:                                               ; preds = %43
  br label %136

52:                                               ; preds = %43
  br label %34, !llvm.loop !8

53:                                               ; preds = %34
  br label %54

54:                                               ; preds = %68, %53
  %55 = load i64, i64* %3, align 8
  %56 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %57 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %56, i32 0, i32 2
  %58 = load atomic i32, i32* %57 monotonic, align 4
  store i32 %58, i32* %9, align 4
  %59 = load i32, i32* %9, align 4
  %60 = sext i32 %59 to i64
  %61 = sub nsw i64 %55, %60
  %62 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %63 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %62, i32 0, i32 4
  %64 = load i32, i32* %63, align 8
  %65 = sub nsw i32 %64, 1
  %66 = sext i32 %65 to i64
  %67 = icmp sge i64 %61, %66
  br i1 %67, label %68, label %69

68:                                               ; preds = %54
  br label %54, !llvm.loop !9

69:                                               ; preds = %54
  store %struct.awnsb_node_t.0* @tlNode, %struct.awnsb_node_t.0** %10, align 8
  %70 = load %struct.awnsb_node_t.0*, %struct.awnsb_node_t.0** %10, align 8
  %71 = getelementptr inbounds %struct.awnsb_node_t.0, %struct.awnsb_node_t.0* %70, i32 0, i32 0
  store i32 0, i32* %11, align 4
  %72 = load i32, i32* %11, align 4
  store atomic i32 %72, i32* %71 monotonic, align 4
  %73 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %74 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %73, i32 0, i32 5
  %75 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %74, align 8
  %76 = load i64, i64* %3, align 8
  %77 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %78 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %77, i32 0, i32 4
  %79 = load i32, i32* %78, align 8
  %80 = sext i32 %79 to i64
  %81 = srem i64 %76, %80
  %82 = trunc i64 %81 to i32
  %83 = sext i32 %82 to i64
  %84 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %75, i64 %83
  %85 = load %struct.awnsb_node_t.0*, %struct.awnsb_node_t.0** %10, align 8
  %86 = bitcast %struct.awnsb_node_t.0* %85 to %struct.awnsb_node_t*
  store %struct.awnsb_node_t* %86, %struct.awnsb_node_t** %12, align 8
  %87 = bitcast %struct.awnsb_node_t** %84 to i64*
  %88 = bitcast %struct.awnsb_node_t** %12 to i64*
  %89 = load i64, i64* %88, align 8
  store atomic i64 %89, i64* %87 release, align 8
  %90 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %91 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %90, i32 0, i32 2
  %92 = load atomic i32, i32* %91 monotonic, align 4
  store i32 %92, i32* %13, align 4
  %93 = load i32, i32* %13, align 4
  %94 = sext i32 %93 to i64
  %95 = load i64, i64* %3, align 8
  %96 = sub nsw i64 %95, 1
  %97 = icmp slt i64 %94, %96
  br i1 %97, label %98, label %113

98:                                               ; preds = %69
  br label %99

99:                                               ; preds = %106, %98
  %100 = load %struct.awnsb_node_t.0*, %struct.awnsb_node_t.0** %10, align 8
  %101 = getelementptr inbounds %struct.awnsb_node_t.0, %struct.awnsb_node_t.0* %100, i32 0, i32 0
  %102 = load atomic i32, i32* %101 monotonic, align 4
  store i32 %102, i32* %14, align 4
  %103 = load i32, i32* %14, align 4
  %104 = icmp ne i32 %103, 0
  %105 = xor i1 %104, true
  br i1 %105, label %106, label %107

106:                                              ; preds = %99
  br label %99, !llvm.loop !10

107:                                              ; preds = %99
  %108 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %109 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %108, i32 0, i32 2
  %110 = load i64, i64* %3, align 8
  %111 = trunc i64 %110 to i32
  store i32 %111, i32* %15, align 4
  %112 = load i32, i32* %15, align 4
  store atomic i32 %112, i32* %109 monotonic, align 4
  br label %136

113:                                              ; preds = %69
  br label %114

114:                                              ; preds = %134, %113
  %115 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %116 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %115, i32 0, i32 2
  %117 = load atomic i32, i32* %116 acquire, align 4
  store i32 %117, i32* %16, align 4
  %118 = load i32, i32* %16, align 4
  %119 = sext i32 %118 to i64
  %120 = load i64, i64* %3, align 8
  %121 = icmp ne i64 %119, %120
  br i1 %121, label %122, label %135

122:                                              ; preds = %114
  %123 = load %struct.awnsb_node_t.0*, %struct.awnsb_node_t.0** %10, align 8
  %124 = getelementptr inbounds %struct.awnsb_node_t.0, %struct.awnsb_node_t.0* %123, i32 0, i32 0
  %125 = load atomic i32, i32* %124 acquire, align 4
  store i32 %125, i32* %17, align 4
  %126 = load i32, i32* %17, align 4
  %127 = icmp ne i32 %126, 0
  br i1 %127, label %128, label %134

128:                                              ; preds = %122
  %129 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %130 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %129, i32 0, i32 2
  %131 = load i64, i64* %3, align 8
  %132 = trunc i64 %131 to i32
  store i32 %132, i32* %18, align 4
  %133 = load i32, i32* %18, align 4
  store atomic i32 %133, i32* %130 monotonic, align 4
  br label %136

134:                                              ; preds = %122
  br label %114, !llvm.loop !11

135:                                              ; preds = %114
  br label %136

136:                                              ; preds = %135, %128, %107, %51, %32
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @ticket_awnsb_mutex_unlock(%struct.ticket_awnsb_mutex_t* noundef %0) #0 {
  %2 = alloca %struct.ticket_awnsb_mutex_t*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  %5 = alloca %struct.awnsb_node_t*, align 8
  %6 = alloca %struct.awnsb_node_t.0*, align 8
  %7 = alloca %struct.awnsb_node_t*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store %struct.ticket_awnsb_mutex_t* %0, %struct.ticket_awnsb_mutex_t** %2, align 8
  %10 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %11 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %10, i32 0, i32 2
  %12 = load atomic i32, i32* %11 monotonic, align 4
  store i32 %12, i32* %4, align 4
  %13 = load i32, i32* %4, align 4
  %14 = sext i32 %13 to i64
  store i64 %14, i64* %3, align 8
  %15 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %16 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %15, i32 0, i32 5
  %17 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %16, align 8
  %18 = load i64, i64* %3, align 8
  %19 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %20 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %19, i32 0, i32 4
  %21 = load i32, i32* %20, align 8
  %22 = sext i32 %21 to i64
  %23 = srem i64 %18, %22
  %24 = trunc i64 %23 to i32
  %25 = sext i32 %24 to i64
  %26 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %17, i64 %25
  store %struct.awnsb_node_t* null, %struct.awnsb_node_t** %5, align 8
  %27 = bitcast %struct.awnsb_node_t** %26 to i64*
  %28 = bitcast %struct.awnsb_node_t** %5 to i64*
  %29 = load i64, i64* %28, align 8
  store atomic i64 %29, i64* %27 monotonic, align 8
  %30 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %31 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %30, i32 0, i32 5
  %32 = load %struct.awnsb_node_t**, %struct.awnsb_node_t*** %31, align 8
  %33 = load i64, i64* %3, align 8
  %34 = add nsw i64 %33, 1
  %35 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %36 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %35, i32 0, i32 4
  %37 = load i32, i32* %36, align 8
  %38 = sext i32 %37 to i64
  %39 = srem i64 %34, %38
  %40 = trunc i64 %39 to i32
  %41 = sext i32 %40 to i64
  %42 = getelementptr inbounds %struct.awnsb_node_t*, %struct.awnsb_node_t** %32, i64 %41
  %43 = bitcast %struct.awnsb_node_t** %42 to i64*
  %44 = bitcast %struct.awnsb_node_t** %7 to i64*
  %45 = load atomic i64, i64* %43 acquire, align 8
  store i64 %45, i64* %44, align 8
  %46 = bitcast i64* %44 to %struct.awnsb_node_t**
  %47 = load %struct.awnsb_node_t*, %struct.awnsb_node_t** %46, align 8
  %48 = bitcast %struct.awnsb_node_t* %47 to %struct.awnsb_node_t.0*
  store %struct.awnsb_node_t.0* %48, %struct.awnsb_node_t.0** %6, align 8
  %49 = load %struct.awnsb_node_t.0*, %struct.awnsb_node_t.0** %6, align 8
  %50 = icmp ne %struct.awnsb_node_t.0* %49, null
  br i1 %50, label %51, label %55

51:                                               ; preds = %1
  %52 = load %struct.awnsb_node_t.0*, %struct.awnsb_node_t.0** %6, align 8
  %53 = getelementptr inbounds %struct.awnsb_node_t.0, %struct.awnsb_node_t.0* %52, i32 0, i32 0
  store i32 1, i32* %8, align 4
  %54 = load i32, i32* %8, align 4
  store atomic i32 %54, i32* %53 release, align 4
  br label %62

55:                                               ; preds = %1
  %56 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %2, align 8
  %57 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %56, i32 0, i32 2
  %58 = load i64, i64* %3, align 8
  %59 = add nsw i64 %58, 1
  %60 = trunc i64 %59 to i32
  store i32 %60, i32* %9, align 4
  %61 = load i32, i32* %9, align 4
  store atomic i32 %61, i32* %57 release, align 4
  br label %62

62:                                               ; preds = %55, %51
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ticket_awnsb_mutex_trylock(%struct.ticket_awnsb_mutex_t* noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.ticket_awnsb_mutex_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  %6 = alloca i64, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i8, align 1
  store %struct.ticket_awnsb_mutex_t* %0, %struct.ticket_awnsb_mutex_t** %3, align 8
  %10 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %11 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %10, i32 0, i32 2
  %12 = load atomic i32, i32* %11 seq_cst, align 4
  store i32 %12, i32* %5, align 4
  %13 = load i32, i32* %5, align 4
  %14 = sext i32 %13 to i64
  store i64 %14, i64* %4, align 8
  %15 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %16 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %15, i32 0, i32 0
  %17 = load atomic i32, i32* %16 monotonic, align 8
  store i32 %17, i32* %7, align 4
  %18 = load i32, i32* %7, align 4
  %19 = sext i32 %18 to i64
  store i64 %19, i64* %6, align 8
  %20 = load i64, i64* %4, align 8
  %21 = load i64, i64* %6, align 8
  %22 = icmp ne i64 %20, %21
  br i1 %22, label %23, label %24

23:                                               ; preds = %1
  store i32 16, i32* %2, align 4
  br label %44

24:                                               ; preds = %1
  %25 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %26 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %25, i32 0, i32 0
  %27 = bitcast i64* %6 to i32*
  %28 = load %struct.ticket_awnsb_mutex_t*, %struct.ticket_awnsb_mutex_t** %3, align 8
  %29 = getelementptr inbounds %struct.ticket_awnsb_mutex_t, %struct.ticket_awnsb_mutex_t* %28, i32 0, i32 0
  %30 = load atomic i32, i32* %29 seq_cst, align 4
  %31 = add nsw i32 %30, 1
  store i32 %31, i32* %8, align 4
  %32 = load i32, i32* %27, align 8
  %33 = load i32, i32* %8, align 4
  %34 = cmpxchg i32* %26, i32 %32, i32 %33 seq_cst seq_cst, align 4
  %35 = extractvalue { i32, i1 } %34, 0
  %36 = extractvalue { i32, i1 } %34, 1
  br i1 %36, label %38, label %37

37:                                               ; preds = %24
  store i32 %35, i32* %27, align 8
  br label %38

38:                                               ; preds = %37, %24
  %39 = zext i1 %36 to i8
  store i8 %39, i8* %9, align 1
  %40 = load i8, i8* %9, align 1
  %41 = trunc i8 %40 to i1
  br i1 %41, label %43, label %42

42:                                               ; preds = %38
  store i32 16, i32* %2, align 4
  br label %44

43:                                               ; preds = %38
  store i32 0, i32* %2, align 4
  br label %44

44:                                               ; preds = %43, %42, %23
  %45 = load i32, i32* %2, align 4
  ret i32 %45
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
!5 = !{!"Ubuntu clang version 14.0.6"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = distinct !{!12, !7}
!13 = distinct !{!13, !7}
