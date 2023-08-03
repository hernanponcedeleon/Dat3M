; ModuleID = 'cna.ll'
source_filename = "benchmarks/locks/cna.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.cna_lock_t = type { %struct.cna_node* }
%struct.cna_node = type { i64, i32, %struct.cna_node*, %struct.cna_node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@shared = dso_local global i32 0, align 4
@sum = dso_local global i32 0, align 4
@tindex = dso_local thread_local global i64 0, align 8
@lock = dso_local global %struct.cna_lock_t zeroinitializer, align 8
@node = dso_local global [3 x %struct.cna_node] zeroinitializer, align 16
@.str = private unnamed_addr constant [12 x i8] c"r == tindex\00", align 1
@.str.1 = private unnamed_addr constant [23 x i8] c"benchmarks/locks/cna.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @current_numa_node() #0 {
  %1 = call i32 (...) @__VERIFIER_nondet_uint()
  ret i32 %1
}

declare i32 @__VERIFIER_nondet_uint(...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local zeroext i1 @keep_lock_local() #0 {
  %1 = call i32 (...) @__VERIFIER_nondet_bool()
  %2 = icmp ne i32 %1, 0
  ret i1 %2
}

declare i32 @__VERIFIER_nondet_bool(...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local %struct.cna_node* @find_successor(%struct.cna_node* noundef %0) #0 {
  %2 = alloca %struct.cna_node*, align 8
  %3 = alloca %struct.cna_node*, align 8
  %4 = alloca %struct.cna_node*, align 8
  %5 = alloca %struct.cna_node*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca %struct.cna_node*, align 8
  %10 = alloca %struct.cna_node*, align 8
  %11 = alloca %struct.cna_node*, align 8
  %12 = alloca %struct.cna_node*, align 8
  %13 = alloca i32, align 4
  %14 = alloca i64, align 8
  %15 = alloca %struct.cna_node*, align 8
  %16 = alloca i64, align 8
  %17 = alloca %struct.cna_node*, align 8
  %18 = alloca %struct.cna_node*, align 8
  %19 = alloca %struct.cna_node*, align 8
  %20 = alloca i64, align 8
  %21 = alloca %struct.cna_node*, align 8
  %22 = alloca %struct.cna_node*, align 8
  %23 = alloca i64, align 8
  %24 = alloca %struct.cna_node*, align 8
  %25 = alloca %struct.cna_node*, align 8
  store %struct.cna_node* %0, %struct.cna_node** %3, align 8
  %26 = load %struct.cna_node*, %struct.cna_node** %3, align 8
  %27 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %26, i32 0, i32 3
  %28 = bitcast %struct.cna_node** %27 to i64*
  %29 = bitcast %struct.cna_node** %5 to i64*
  %30 = load atomic i64, i64* %28 monotonic, align 8
  store i64 %30, i64* %29, align 8
  %31 = bitcast i64* %29 to %struct.cna_node**
  %32 = load %struct.cna_node*, %struct.cna_node** %31, align 8
  store %struct.cna_node* %32, %struct.cna_node** %4, align 8
  %33 = load %struct.cna_node*, %struct.cna_node** %3, align 8
  %34 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %33, i32 0, i32 1
  %35 = load atomic i32, i32* %34 monotonic, align 8
  store i32 %35, i32* %7, align 4
  %36 = load i32, i32* %7, align 4
  store i32 %36, i32* %6, align 4
  %37 = load i32, i32* %6, align 4
  %38 = icmp eq i32 %37, -1
  br i1 %38, label %39, label %41

39:                                               ; preds = %1
  %40 = call i32 @current_numa_node()
  store i32 %40, i32* %6, align 4
  br label %41

41:                                               ; preds = %39, %1
  %42 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %43 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %42, i32 0, i32 1
  %44 = load atomic i32, i32* %43 monotonic, align 8
  store i32 %44, i32* %8, align 4
  %45 = load i32, i32* %8, align 4
  %46 = load i32, i32* %6, align 4
  %47 = icmp eq i32 %45, %46
  br i1 %47, label %48, label %50

48:                                               ; preds = %41
  %49 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  store %struct.cna_node* %49, %struct.cna_node** %2, align 8
  br label %129

50:                                               ; preds = %41
  %51 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  store %struct.cna_node* %51, %struct.cna_node** %9, align 8
  %52 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  store %struct.cna_node* %52, %struct.cna_node** %10, align 8
  %53 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %54 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %53, i32 0, i32 3
  %55 = bitcast %struct.cna_node** %54 to i64*
  %56 = bitcast %struct.cna_node** %12 to i64*
  %57 = load atomic i64, i64* %55 acquire, align 8
  store i64 %57, i64* %56, align 8
  %58 = bitcast i64* %56 to %struct.cna_node**
  %59 = load %struct.cna_node*, %struct.cna_node** %58, align 8
  store %struct.cna_node* %59, %struct.cna_node** %11, align 8
  br label %60

60:                                               ; preds = %119, %50
  %61 = load %struct.cna_node*, %struct.cna_node** %11, align 8
  %62 = icmp ne %struct.cna_node* %61, null
  br i1 %62, label %63, label %128

63:                                               ; preds = %60
  %64 = load %struct.cna_node*, %struct.cna_node** %11, align 8
  %65 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %64, i32 0, i32 1
  %66 = load atomic i32, i32* %65 monotonic, align 8
  store i32 %66, i32* %13, align 4
  %67 = load i32, i32* %13, align 4
  %68 = load i32, i32* %6, align 4
  %69 = icmp eq i32 %67, %68
  br i1 %69, label %70, label %119

70:                                               ; preds = %63
  %71 = load %struct.cna_node*, %struct.cna_node** %3, align 8
  %72 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %71, i32 0, i32 0
  %73 = load atomic i64, i64* %72 monotonic, align 8
  store i64 %73, i64* %14, align 8
  %74 = load i64, i64* %14, align 8
  %75 = icmp ugt i64 %74, 1
  br i1 %75, label %76, label %95

76:                                               ; preds = %70
  %77 = load %struct.cna_node*, %struct.cna_node** %3, align 8
  %78 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %77, i32 0, i32 0
  %79 = load atomic i64, i64* %78 monotonic, align 8
  store i64 %79, i64* %16, align 8
  %80 = load i64, i64* %16, align 8
  %81 = inttoptr i64 %80 to %struct.cna_node*
  store %struct.cna_node* %81, %struct.cna_node** %15, align 8
  %82 = load %struct.cna_node*, %struct.cna_node** %15, align 8
  %83 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %82, i32 0, i32 2
  %84 = bitcast %struct.cna_node** %83 to i64*
  %85 = bitcast %struct.cna_node** %18 to i64*
  %86 = load atomic i64, i64* %84 monotonic, align 8
  store i64 %86, i64* %85, align 8
  %87 = bitcast i64* %85 to %struct.cna_node**
  %88 = load %struct.cna_node*, %struct.cna_node** %87, align 8
  store %struct.cna_node* %88, %struct.cna_node** %17, align 8
  %89 = load %struct.cna_node*, %struct.cna_node** %17, align 8
  %90 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %89, i32 0, i32 3
  %91 = load %struct.cna_node*, %struct.cna_node** %9, align 8
  store %struct.cna_node* %91, %struct.cna_node** %19, align 8
  %92 = bitcast %struct.cna_node** %90 to i64*
  %93 = bitcast %struct.cna_node** %19 to i64*
  %94 = load i64, i64* %93, align 8
  store atomic i64 %94, i64* %92 monotonic, align 8
  br label %101

95:                                               ; preds = %70
  %96 = load %struct.cna_node*, %struct.cna_node** %3, align 8
  %97 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %96, i32 0, i32 0
  %98 = load %struct.cna_node*, %struct.cna_node** %9, align 8
  %99 = ptrtoint %struct.cna_node* %98 to i64
  store i64 %99, i64* %20, align 8
  %100 = load i64, i64* %20, align 8
  store atomic i64 %100, i64* %97 monotonic, align 8
  br label %101

101:                                              ; preds = %95, %76
  %102 = load %struct.cna_node*, %struct.cna_node** %10, align 8
  %103 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %102, i32 0, i32 3
  store %struct.cna_node* null, %struct.cna_node** %21, align 8
  %104 = bitcast %struct.cna_node** %103 to i64*
  %105 = bitcast %struct.cna_node** %21 to i64*
  %106 = load i64, i64* %105, align 8
  store atomic i64 %106, i64* %104 monotonic, align 8
  %107 = load %struct.cna_node*, %struct.cna_node** %3, align 8
  %108 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %107, i32 0, i32 0
  %109 = load atomic i64, i64* %108 monotonic, align 8
  store i64 %109, i64* %23, align 8
  %110 = load i64, i64* %23, align 8
  %111 = inttoptr i64 %110 to %struct.cna_node*
  store %struct.cna_node* %111, %struct.cna_node** %22, align 8
  %112 = load %struct.cna_node*, %struct.cna_node** %22, align 8
  %113 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %112, i32 0, i32 2
  %114 = load %struct.cna_node*, %struct.cna_node** %10, align 8
  store %struct.cna_node* %114, %struct.cna_node** %24, align 8
  %115 = bitcast %struct.cna_node** %113 to i64*
  %116 = bitcast %struct.cna_node** %24 to i64*
  %117 = load i64, i64* %116, align 8
  store atomic i64 %117, i64* %115 monotonic, align 8
  %118 = load %struct.cna_node*, %struct.cna_node** %11, align 8
  store %struct.cna_node* %118, %struct.cna_node** %2, align 8
  br label %129

119:                                              ; preds = %63
  %120 = load %struct.cna_node*, %struct.cna_node** %11, align 8
  store %struct.cna_node* %120, %struct.cna_node** %10, align 8
  %121 = load %struct.cna_node*, %struct.cna_node** %11, align 8
  %122 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %121, i32 0, i32 3
  %123 = bitcast %struct.cna_node** %122 to i64*
  %124 = bitcast %struct.cna_node** %25 to i64*
  %125 = load atomic i64, i64* %123 acquire, align 8
  store i64 %125, i64* %124, align 8
  %126 = bitcast i64* %124 to %struct.cna_node**
  %127 = load %struct.cna_node*, %struct.cna_node** %126, align 8
  store %struct.cna_node* %127, %struct.cna_node** %11, align 8
  br label %60, !llvm.loop !6

128:                                              ; preds = %60
  store %struct.cna_node* null, %struct.cna_node** %2, align 8
  br label %129

129:                                              ; preds = %128, %101, %48
  %130 = load %struct.cna_node*, %struct.cna_node** %2, align 8
  ret %struct.cna_node* %130
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  %4 = load i8*, i8** %2, align 8
  %5 = ptrtoint i8* %4 to i64
  store i64 %5, i64* @tindex, align 8
  %6 = load i64, i64* @tindex, align 8
  %7 = getelementptr inbounds [3 x %struct.cna_node], [3 x %struct.cna_node]* @node, i64 0, i64 %6
  call void @cna_lock(%struct.cna_lock_t* noundef @lock, %struct.cna_node* noundef %7)
  %8 = load i64, i64* @tindex, align 8
  %9 = trunc i64 %8 to i32
  store i32 %9, i32* @shared, align 4
  %10 = load i32, i32* @shared, align 4
  store i32 %10, i32* %3, align 4
  %11 = load i32, i32* %3, align 4
  %12 = sext i32 %11 to i64
  %13 = load i64, i64* @tindex, align 8
  %14 = icmp eq i64 %12, %13
  br i1 %14, label %15, label %16

15:                                               ; preds = %1
  br label %17

16:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i32 noundef 22, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #4
  unreachable

17:                                               ; preds = %15
  %18 = load i32, i32* @sum, align 4
  %19 = add nsw i32 %18, 1
  store i32 %19, i32* @sum, align 4
  %20 = load i64, i64* @tindex, align 8
  %21 = getelementptr inbounds [3 x %struct.cna_node], [3 x %struct.cna_node]* @node, i64 0, i64 %20
  call void @cna_unlock(%struct.cna_lock_t* noundef @lock, %struct.cna_node* noundef %21)
  ret i8* null
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @cna_lock(%struct.cna_lock_t* noundef %0, %struct.cna_node* noundef %1) #0 {
  %3 = alloca %struct.cna_lock_t*, align 8
  %4 = alloca %struct.cna_node*, align 8
  %5 = alloca %struct.cna_node*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  %8 = alloca %struct.cna_node*, align 8
  %9 = alloca %struct.cna_node*, align 8
  %10 = alloca %struct.cna_node*, align 8
  %11 = alloca i64, align 8
  %12 = alloca i32, align 4
  %13 = alloca %struct.cna_node*, align 8
  %14 = alloca i32, align 4
  %15 = alloca i64, align 8
  store %struct.cna_lock_t* %0, %struct.cna_lock_t** %3, align 8
  store %struct.cna_node* %1, %struct.cna_node** %4, align 8
  %16 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %17 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %16, i32 0, i32 3
  store %struct.cna_node* null, %struct.cna_node** %5, align 8
  %18 = bitcast %struct.cna_node** %17 to i64*
  %19 = bitcast %struct.cna_node** %5 to i64*
  %20 = load i64, i64* %19, align 8
  store atomic i64 %20, i64* %18 monotonic, align 8
  %21 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %22 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %21, i32 0, i32 1
  store i32 -1, i32* %6, align 4
  %23 = load i32, i32* %6, align 4
  store atomic i32 %23, i32* %22 monotonic, align 8
  %24 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %25 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %24, i32 0, i32 0
  store i64 0, i64* %7, align 8
  %26 = load i64, i64* %7, align 8
  store atomic i64 %26, i64* %25 monotonic, align 8
  %27 = load %struct.cna_lock_t*, %struct.cna_lock_t** %3, align 8
  %28 = getelementptr inbounds %struct.cna_lock_t, %struct.cna_lock_t* %27, i32 0, i32 0
  %29 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  store %struct.cna_node* %29, %struct.cna_node** %9, align 8
  %30 = bitcast %struct.cna_node** %28 to i64*
  %31 = bitcast %struct.cna_node** %9 to i64*
  %32 = bitcast %struct.cna_node** %10 to i64*
  %33 = load i64, i64* %31, align 8
  %34 = atomicrmw xchg i64* %30, i64 %33 seq_cst, align 8
  store i64 %34, i64* %32, align 8
  %35 = bitcast i64* %32 to %struct.cna_node**
  %36 = load %struct.cna_node*, %struct.cna_node** %35, align 8
  store %struct.cna_node* %36, %struct.cna_node** %8, align 8
  %37 = load %struct.cna_node*, %struct.cna_node** %8, align 8
  %38 = icmp ne %struct.cna_node* %37, null
  br i1 %38, label %43, label %39

39:                                               ; preds = %2
  %40 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %41 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %40, i32 0, i32 0
  store i64 1, i64* %11, align 8
  %42 = load i64, i64* %11, align 8
  store atomic i64 %42, i64* %41 monotonic, align 8
  br label %69

43:                                               ; preds = %2
  %44 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %45 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %44, i32 0, i32 1
  %46 = call i32 @current_numa_node()
  store i32 %46, i32* %12, align 4
  %47 = load i32, i32* %12, align 4
  store atomic i32 %47, i32* %45 monotonic, align 8
  %48 = load %struct.cna_node*, %struct.cna_node** %8, align 8
  %49 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %48, i32 0, i32 3
  %50 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  store %struct.cna_node* %50, %struct.cna_node** %13, align 8
  %51 = bitcast %struct.cna_node** %49 to i64*
  %52 = bitcast %struct.cna_node** %13 to i64*
  %53 = load i64, i64* %52, align 8
  store atomic i64 %53, i64* %51 release, align 8
  call void @__VERIFIER_loop_begin()
  store i32 0, i32* %14, align 4
  br label %54

54:                                               ; preds = %68, %43
  call void @__VERIFIER_spin_start()
  %55 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %56 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %55, i32 0, i32 0
  %57 = load atomic i64, i64* %56 acquire, align 8
  store i64 %57, i64* %15, align 8
  %58 = load i64, i64* %15, align 8
  %59 = icmp ne i64 %58, 0
  %60 = xor i1 %59, true
  %61 = zext i1 %60 to i32
  store i32 %61, i32* %14, align 4
  %62 = load i32, i32* %14, align 4
  %63 = icmp ne i32 %62, 0
  %64 = xor i1 %63, true
  %65 = zext i1 %64 to i32
  call void @__VERIFIER_spin_end(i32 noundef %65)
  %66 = load i32, i32* %14, align 4
  %67 = icmp ne i32 %66, 0
  br i1 %67, label %68, label %69

68:                                               ; preds = %54
  br label %54, !llvm.loop !8

69:                                               ; preds = %54, %39
  ret void
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define internal void @cna_unlock(%struct.cna_lock_t* noundef %0, %struct.cna_node* noundef %1) #0 {
  %3 = alloca %struct.cna_lock_t*, align 8
  %4 = alloca %struct.cna_node*, align 8
  %5 = alloca %struct.cna_node*, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.cna_node*, align 8
  %8 = alloca %struct.cna_node*, align 8
  %9 = alloca i8, align 1
  %10 = alloca %struct.cna_node*, align 8
  %11 = alloca i64, align 8
  %12 = alloca %struct.cna_node*, align 8
  %13 = alloca %struct.cna_node*, align 8
  %14 = alloca %struct.cna_node*, align 8
  %15 = alloca i8, align 1
  %16 = alloca i64, align 8
  %17 = alloca i32, align 4
  %18 = alloca %struct.cna_node*, align 8
  %19 = alloca %struct.cna_node*, align 8
  %20 = alloca i64, align 8
  %21 = alloca i64, align 8
  %22 = alloca i64, align 8
  %23 = alloca i64, align 8
  %24 = alloca %struct.cna_node*, align 8
  %25 = alloca %struct.cna_node*, align 8
  %26 = alloca %struct.cna_node*, align 8
  %27 = alloca i64, align 8
  %28 = alloca %struct.cna_node*, align 8
  %29 = alloca i64, align 8
  store %struct.cna_lock_t* %0, %struct.cna_lock_t** %3, align 8
  store %struct.cna_node* %1, %struct.cna_node** %4, align 8
  %30 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %31 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %30, i32 0, i32 3
  %32 = bitcast %struct.cna_node** %31 to i64*
  %33 = bitcast %struct.cna_node** %5 to i64*
  %34 = load atomic i64, i64* %32 acquire, align 8
  store i64 %34, i64* %33, align 8
  %35 = bitcast i64* %33 to %struct.cna_node**
  %36 = load %struct.cna_node*, %struct.cna_node** %35, align 8
  %37 = icmp ne %struct.cna_node* %36, null
  br i1 %37, label %116, label %38

38:                                               ; preds = %2
  %39 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %40 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %39, i32 0, i32 0
  %41 = load atomic i64, i64* %40 monotonic, align 8
  store i64 %41, i64* %6, align 8
  %42 = load i64, i64* %6, align 8
  %43 = icmp eq i64 %42, 1
  br i1 %43, label %44, label %63

44:                                               ; preds = %38
  %45 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  store %struct.cna_node* %45, %struct.cna_node** %7, align 8
  %46 = load %struct.cna_lock_t*, %struct.cna_lock_t** %3, align 8
  %47 = getelementptr inbounds %struct.cna_lock_t, %struct.cna_lock_t* %46, i32 0, i32 0
  store %struct.cna_node* null, %struct.cna_node** %8, align 8
  %48 = bitcast %struct.cna_node** %47 to i64*
  %49 = bitcast %struct.cna_node** %7 to i64*
  %50 = bitcast %struct.cna_node** %8 to i64*
  %51 = load i64, i64* %49, align 8
  %52 = load i64, i64* %50, align 8
  %53 = cmpxchg i64* %48, i64 %51, i64 %52 seq_cst seq_cst, align 8
  %54 = extractvalue { i64, i1 } %53, 0
  %55 = extractvalue { i64, i1 } %53, 1
  br i1 %55, label %57, label %56

56:                                               ; preds = %44
  store i64 %54, i64* %49, align 8
  br label %57

57:                                               ; preds = %56, %44
  %58 = zext i1 %55 to i8
  store i8 %58, i8* %9, align 1
  %59 = load i8, i8* %9, align 1
  %60 = trunc i8 %59 to i1
  br i1 %60, label %61, label %62

61:                                               ; preds = %57
  br label %175

62:                                               ; preds = %57
  br label %97

63:                                               ; preds = %38
  %64 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %65 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %64, i32 0, i32 0
  %66 = load atomic i64, i64* %65 monotonic, align 8
  store i64 %66, i64* %11, align 8
  %67 = load i64, i64* %11, align 8
  %68 = inttoptr i64 %67 to %struct.cna_node*
  store %struct.cna_node* %68, %struct.cna_node** %10, align 8
  %69 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  store %struct.cna_node* %69, %struct.cna_node** %12, align 8
  %70 = load %struct.cna_lock_t*, %struct.cna_lock_t** %3, align 8
  %71 = getelementptr inbounds %struct.cna_lock_t, %struct.cna_lock_t* %70, i32 0, i32 0
  %72 = load %struct.cna_node*, %struct.cna_node** %10, align 8
  %73 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %72, i32 0, i32 2
  %74 = bitcast %struct.cna_node** %73 to i64*
  %75 = bitcast %struct.cna_node** %14 to i64*
  %76 = load atomic i64, i64* %74 monotonic, align 8
  store i64 %76, i64* %75, align 8
  %77 = bitcast i64* %75 to %struct.cna_node**
  %78 = load %struct.cna_node*, %struct.cna_node** %77, align 8
  store %struct.cna_node* %78, %struct.cna_node** %13, align 8
  %79 = bitcast %struct.cna_node** %71 to i64*
  %80 = bitcast %struct.cna_node** %12 to i64*
  %81 = bitcast %struct.cna_node** %13 to i64*
  %82 = load i64, i64* %80, align 8
  %83 = load i64, i64* %81, align 8
  %84 = cmpxchg i64* %79, i64 %82, i64 %83 seq_cst seq_cst, align 8
  %85 = extractvalue { i64, i1 } %84, 0
  %86 = extractvalue { i64, i1 } %84, 1
  br i1 %86, label %88, label %87

87:                                               ; preds = %63
  store i64 %85, i64* %80, align 8
  br label %88

88:                                               ; preds = %87, %63
  %89 = zext i1 %86 to i8
  store i8 %89, i8* %15, align 1
  %90 = load i8, i8* %15, align 1
  %91 = trunc i8 %90 to i1
  br i1 %91, label %92, label %96

92:                                               ; preds = %88
  %93 = load %struct.cna_node*, %struct.cna_node** %10, align 8
  %94 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %93, i32 0, i32 0
  store i64 1, i64* %16, align 8
  %95 = load i64, i64* %16, align 8
  store atomic i64 %95, i64* %94 release, align 8
  br label %175

96:                                               ; preds = %88
  br label %97

97:                                               ; preds = %96, %62
  call void @__VERIFIER_loop_begin()
  store i32 0, i32* %17, align 4
  br label %98

98:                                               ; preds = %114, %97
  call void @__VERIFIER_spin_start()
  %99 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %100 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %99, i32 0, i32 3
  %101 = bitcast %struct.cna_node** %100 to i64*
  %102 = bitcast %struct.cna_node** %18 to i64*
  %103 = load atomic i64, i64* %101 monotonic, align 8
  store i64 %103, i64* %102, align 8
  %104 = bitcast i64* %102 to %struct.cna_node**
  %105 = load %struct.cna_node*, %struct.cna_node** %104, align 8
  %106 = icmp eq %struct.cna_node* %105, null
  %107 = zext i1 %106 to i32
  store i32 %107, i32* %17, align 4
  %108 = load i32, i32* %17, align 4
  %109 = icmp ne i32 %108, 0
  %110 = xor i1 %109, true
  %111 = zext i1 %110 to i32
  call void @__VERIFIER_spin_end(i32 noundef %111)
  %112 = load i32, i32* %17, align 4
  %113 = icmp ne i32 %112, 0
  br i1 %113, label %114, label %115

114:                                              ; preds = %98
  br label %98, !llvm.loop !9

115:                                              ; preds = %98
  br label %116

116:                                              ; preds = %115, %2
  store %struct.cna_node* null, %struct.cna_node** %19, align 8
  %117 = call zeroext i1 @keep_lock_local()
  br i1 %117, label %118, label %130

118:                                              ; preds = %116
  %119 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %120 = call %struct.cna_node* @find_successor(%struct.cna_node* noundef %119)
  store %struct.cna_node* %120, %struct.cna_node** %19, align 8
  %121 = icmp ne %struct.cna_node* %120, null
  br i1 %121, label %122, label %130

122:                                              ; preds = %118
  %123 = load %struct.cna_node*, %struct.cna_node** %19, align 8
  %124 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %123, i32 0, i32 0
  %125 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %126 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %125, i32 0, i32 0
  %127 = load atomic i64, i64* %126 monotonic, align 8
  store i64 %127, i64* %21, align 8
  %128 = load i64, i64* %21, align 8
  store i64 %128, i64* %20, align 8
  %129 = load i64, i64* %20, align 8
  store atomic i64 %129, i64* %124 release, align 8
  br label %175

130:                                              ; preds = %118, %116
  %131 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %132 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %131, i32 0, i32 0
  %133 = load atomic i64, i64* %132 monotonic, align 8
  store i64 %133, i64* %22, align 8
  %134 = load i64, i64* %22, align 8
  %135 = icmp ugt i64 %134, 1
  br i1 %135, label %136, label %163

136:                                              ; preds = %130
  %137 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %138 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %137, i32 0, i32 0
  %139 = load atomic i64, i64* %138 monotonic, align 8
  store i64 %139, i64* %23, align 8
  %140 = load i64, i64* %23, align 8
  %141 = inttoptr i64 %140 to %struct.cna_node*
  store %struct.cna_node* %141, %struct.cna_node** %19, align 8
  %142 = load %struct.cna_node*, %struct.cna_node** %19, align 8
  %143 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %142, i32 0, i32 2
  %144 = bitcast %struct.cna_node** %143 to i64*
  %145 = bitcast %struct.cna_node** %24 to i64*
  %146 = load atomic i64, i64* %144 monotonic, align 8
  store i64 %146, i64* %145, align 8
  %147 = bitcast i64* %145 to %struct.cna_node**
  %148 = load %struct.cna_node*, %struct.cna_node** %147, align 8
  %149 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %148, i32 0, i32 3
  %150 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %151 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %150, i32 0, i32 3
  %152 = bitcast %struct.cna_node** %151 to i64*
  %153 = bitcast %struct.cna_node** %26 to i64*
  %154 = load atomic i64, i64* %152 monotonic, align 8
  store i64 %154, i64* %153, align 8
  %155 = bitcast i64* %153 to %struct.cna_node**
  %156 = load %struct.cna_node*, %struct.cna_node** %155, align 8
  store %struct.cna_node* %156, %struct.cna_node** %25, align 8
  %157 = bitcast %struct.cna_node** %149 to i64*
  %158 = bitcast %struct.cna_node** %25 to i64*
  %159 = load i64, i64* %158, align 8
  store atomic i64 %159, i64* %157 monotonic, align 8
  %160 = load %struct.cna_node*, %struct.cna_node** %19, align 8
  %161 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %160, i32 0, i32 0
  store i64 1, i64* %27, align 8
  %162 = load i64, i64* %27, align 8
  store atomic i64 %162, i64* %161 release, align 8
  br label %174

163:                                              ; preds = %130
  %164 = load %struct.cna_node*, %struct.cna_node** %4, align 8
  %165 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %164, i32 0, i32 3
  %166 = bitcast %struct.cna_node** %165 to i64*
  %167 = bitcast %struct.cna_node** %28 to i64*
  %168 = load atomic i64, i64* %166 monotonic, align 8
  store i64 %168, i64* %167, align 8
  %169 = bitcast i64* %167 to %struct.cna_node**
  %170 = load %struct.cna_node*, %struct.cna_node** %169, align 8
  store %struct.cna_node* %170, %struct.cna_node** %19, align 8
  %171 = load %struct.cna_node*, %struct.cna_node** %19, align 8
  %172 = getelementptr inbounds %struct.cna_node, %struct.cna_node* %171, i32 0, i32 0
  store i64 1, i64* %29, align 8
  %173 = load i64, i64* %29, align 8
  store atomic i64 %173, i64* %172 release, align 8
  br label %174

174:                                              ; preds = %163, %136
  br label %175

175:                                              ; preds = %174, %122, %92, %61
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
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
  %15 = call i32 @pthread_create(i64* noundef %11, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef %14) #5
  br label %16

16:                                               ; preds = %8
  %17 = load i32, i32* %3, align 4
  %18 = add nsw i32 %17, 1
  store i32 %18, i32* %3, align 4
  br label %5, !llvm.loop !10

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
  br label %20, !llvm.loop !11

32:                                               ; preds = %20
  %33 = load i32, i32* @sum, align 4
  %34 = icmp eq i32 %33, 3
  br i1 %34, label %35, label %36

35:                                               ; preds = %32
  br label %37

36:                                               ; preds = %32
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #4
  unreachable

37:                                               ; preds = %35
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #1

declare void @__VERIFIER_loop_begin() #1

declare void @__VERIFIER_spin_start() #1

declare void @__VERIFIER_spin_end(i32 noundef) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind }
attributes #5 = { nounwind }

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
