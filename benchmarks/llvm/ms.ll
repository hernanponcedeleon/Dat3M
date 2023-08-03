; ModuleID = 'ms.ll'
source_filename = "benchmarks/lfds/ms.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Node = type { i32, %struct.Node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@Head = dso_local global %struct.Node* null, align 8
@Tail = dso_local global %struct.Node* null, align 8

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @init() #0 {
  %1 = alloca %struct.Node*, align 8
  %2 = call i8* @malloc(i64 noundef 16)
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

declare i8* @malloc(i64 noundef) #1

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
  %15 = call i8* @malloc(i64 noundef 16)
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

22:                                               ; preds = %94, %1
  %23 = bitcast %struct.Node** %6 to i64*
  %24 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8
  store i64 %24, i64* %23, align 8
  %25 = bitcast i64* %23 to %struct.Node**
  %26 = load %struct.Node*, %struct.Node** %25, align 8
  store %struct.Node* %26, %struct.Node** %3, align 8
  %27 = load %struct.Node*, %struct.Node** %3, align 8
  %28 = icmp ne %struct.Node* %27, null
  %29 = zext i1 %28 to i32
  %30 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %29)
  %31 = load %struct.Node*, %struct.Node** %3, align 8
  %32 = getelementptr inbounds %struct.Node, %struct.Node* %31, i32 0, i32 1
  %33 = bitcast %struct.Node** %32 to i64*
  %34 = bitcast %struct.Node** %7 to i64*
  %35 = load atomic i64, i64* %33 acquire, align 8
  store i64 %35, i64* %34, align 8
  %36 = bitcast i64* %34 to %struct.Node**
  %37 = load %struct.Node*, %struct.Node** %36, align 8
  store %struct.Node* %37, %struct.Node** %4, align 8
  %38 = load %struct.Node*, %struct.Node** %3, align 8
  %39 = bitcast %struct.Node** %8 to i64*
  %40 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8
  store i64 %40, i64* %39, align 8
  %41 = bitcast i64* %39 to %struct.Node**
  %42 = load %struct.Node*, %struct.Node** %41, align 8
  %43 = icmp eq %struct.Node* %38, %42
  br i1 %43, label %44, label %94

44:                                               ; preds = %22
  %45 = load %struct.Node*, %struct.Node** %4, align 8
  %46 = icmp ne %struct.Node* %45, null
  br i1 %46, label %47, label %61

47:                                               ; preds = %44
  %48 = load %struct.Node*, %struct.Node** %4, align 8
  store %struct.Node* %48, %struct.Node** %9, align 8
  %49 = bitcast %struct.Node** %3 to i64*
  %50 = bitcast %struct.Node** %9 to i64*
  %51 = load i64, i64* %49, align 8
  %52 = load i64, i64* %50, align 8
  %53 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %51, i64 %52 acq_rel monotonic, align 8
  %54 = extractvalue { i64, i1 } %53, 0
  %55 = extractvalue { i64, i1 } %53, 1
  br i1 %55, label %57, label %56

56:                                               ; preds = %47
  store i64 %54, i64* %49, align 8
  br label %57

57:                                               ; preds = %56, %47
  %58 = zext i1 %55 to i8
  store i8 %58, i8* %10, align 1
  %59 = load i8, i8* %10, align 1
  %60 = trunc i8 %59 to i1
  br label %93

61:                                               ; preds = %44
  %62 = load %struct.Node*, %struct.Node** %3, align 8
  %63 = getelementptr inbounds %struct.Node, %struct.Node* %62, i32 0, i32 1
  %64 = load %struct.Node*, %struct.Node** %5, align 8
  store %struct.Node* %64, %struct.Node** %11, align 8
  %65 = bitcast %struct.Node** %63 to i64*
  %66 = bitcast %struct.Node** %4 to i64*
  %67 = bitcast %struct.Node** %11 to i64*
  %68 = load i64, i64* %66, align 8
  %69 = load i64, i64* %67, align 8
  %70 = cmpxchg i64* %65, i64 %68, i64 %69 acq_rel monotonic, align 8
  %71 = extractvalue { i64, i1 } %70, 0
  %72 = extractvalue { i64, i1 } %70, 1
  br i1 %72, label %74, label %73

73:                                               ; preds = %61
  store i64 %71, i64* %66, align 8
  br label %74

74:                                               ; preds = %73, %61
  %75 = zext i1 %72 to i8
  store i8 %75, i8* %12, align 1
  %76 = load i8, i8* %12, align 1
  %77 = trunc i8 %76 to i1
  br i1 %77, label %78, label %92

78:                                               ; preds = %74
  %79 = load %struct.Node*, %struct.Node** %5, align 8
  store %struct.Node* %79, %struct.Node** %13, align 8
  %80 = bitcast %struct.Node** %3 to i64*
  %81 = bitcast %struct.Node** %13 to i64*
  %82 = load i64, i64* %80, align 8
  %83 = load i64, i64* %81, align 8
  %84 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %82, i64 %83 acq_rel monotonic, align 8
  %85 = extractvalue { i64, i1 } %84, 0
  %86 = extractvalue { i64, i1 } %84, 1
  br i1 %86, label %88, label %87

87:                                               ; preds = %78
  store i64 %85, i64* %80, align 8
  br label %88

88:                                               ; preds = %87, %78
  %89 = zext i1 %86 to i8
  store i8 %89, i8* %14, align 1
  %90 = load i8, i8* %14, align 1
  %91 = trunc i8 %90 to i1
  br label %95

92:                                               ; preds = %74
  br label %93

93:                                               ; preds = %92, %57
  br label %94

94:                                               ; preds = %93, %22
  br label %22

95:                                               ; preds = %88
  ret void
}

declare i32 @assert(...) #1

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

13:                                               ; preds = %86, %0
  %14 = bitcast %struct.Node** %5 to i64*
  %15 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8
  store i64 %15, i64* %14, align 8
  %16 = bitcast i64* %14 to %struct.Node**
  %17 = load %struct.Node*, %struct.Node** %16, align 8
  store %struct.Node* %17, %struct.Node** %1, align 8
  %18 = load %struct.Node*, %struct.Node** %1, align 8
  %19 = icmp ne %struct.Node* %18, null
  %20 = zext i1 %19 to i32
  %21 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %20)
  %22 = bitcast %struct.Node** %6 to i64*
  %23 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8
  store i64 %23, i64* %22, align 8
  %24 = bitcast i64* %22 to %struct.Node**
  %25 = load %struct.Node*, %struct.Node** %24, align 8
  store %struct.Node* %25, %struct.Node** %3, align 8
  %26 = load %struct.Node*, %struct.Node** %3, align 8
  %27 = icmp ne %struct.Node* %26, null
  %28 = zext i1 %27 to i32
  %29 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %28)
  %30 = load %struct.Node*, %struct.Node** %1, align 8
  %31 = getelementptr inbounds %struct.Node, %struct.Node* %30, i32 0, i32 1
  %32 = bitcast %struct.Node** %31 to i64*
  %33 = bitcast %struct.Node** %7 to i64*
  %34 = load atomic i64, i64* %32 acquire, align 8
  store i64 %34, i64* %33, align 8
  %35 = bitcast i64* %33 to %struct.Node**
  %36 = load %struct.Node*, %struct.Node** %35, align 8
  store %struct.Node* %36, %struct.Node** %2, align 8
  %37 = load %struct.Node*, %struct.Node** %1, align 8
  %38 = bitcast %struct.Node** %8 to i64*
  %39 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8
  store i64 %39, i64* %38, align 8
  %40 = bitcast i64* %38 to %struct.Node**
  %41 = load %struct.Node*, %struct.Node** %40, align 8
  %42 = icmp eq %struct.Node* %37, %41
  br i1 %42, label %43, label %86

43:                                               ; preds = %13
  %44 = load %struct.Node*, %struct.Node** %2, align 8
  %45 = icmp eq %struct.Node* %44, null
  br i1 %45, label %46, label %47

46:                                               ; preds = %43
  store i32 -1, i32* %4, align 4
  br label %87

47:                                               ; preds = %43
  %48 = load %struct.Node*, %struct.Node** %1, align 8
  %49 = load %struct.Node*, %struct.Node** %3, align 8
  %50 = icmp eq %struct.Node* %48, %49
  br i1 %50, label %51, label %65

51:                                               ; preds = %47
  %52 = load %struct.Node*, %struct.Node** %2, align 8
  store %struct.Node* %52, %struct.Node** %9, align 8
  %53 = bitcast %struct.Node** %3 to i64*
  %54 = bitcast %struct.Node** %9 to i64*
  %55 = load i64, i64* %53, align 8
  %56 = load i64, i64* %54, align 8
  %57 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %55, i64 %56 acq_rel monotonic, align 8
  %58 = extractvalue { i64, i1 } %57, 0
  %59 = extractvalue { i64, i1 } %57, 1
  br i1 %59, label %61, label %60

60:                                               ; preds = %51
  store i64 %58, i64* %53, align 8
  br label %61

61:                                               ; preds = %60, %51
  %62 = zext i1 %59 to i8
  store i8 %62, i8* %10, align 1
  %63 = load i8, i8* %10, align 1
  %64 = trunc i8 %63 to i1
  br label %84

65:                                               ; preds = %47
  %66 = load %struct.Node*, %struct.Node** %2, align 8
  %67 = getelementptr inbounds %struct.Node, %struct.Node* %66, i32 0, i32 0
  %68 = load i32, i32* %67, align 8
  store i32 %68, i32* %4, align 4
  %69 = load %struct.Node*, %struct.Node** %2, align 8
  store %struct.Node* %69, %struct.Node** %11, align 8
  %70 = bitcast %struct.Node** %1 to i64*
  %71 = bitcast %struct.Node** %11 to i64*
  %72 = load i64, i64* %70, align 8
  %73 = load i64, i64* %71, align 8
  %74 = cmpxchg i64* bitcast (%struct.Node** @Head to i64*), i64 %72, i64 %73 acq_rel monotonic, align 8
  %75 = extractvalue { i64, i1 } %74, 0
  %76 = extractvalue { i64, i1 } %74, 1
  br i1 %76, label %78, label %77

77:                                               ; preds = %65
  store i64 %75, i64* %70, align 8
  br label %78

78:                                               ; preds = %77, %65
  %79 = zext i1 %76 to i8
  store i8 %79, i8* %12, align 1
  %80 = load i8, i8* %12, align 1
  %81 = trunc i8 %80 to i1
  br i1 %81, label %82, label %83

82:                                               ; preds = %78
  br label %87

83:                                               ; preds = %78
  br label %84

84:                                               ; preds = %83, %61
  br label %85

85:                                               ; preds = %84
  br label %86

86:                                               ; preds = %85, %13
  br label %13

87:                                               ; preds = %82, %46
  %88 = load i32, i32* %4, align 4
  ret i32 %88
}

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
  %12 = zext i1 %11 to i32
  %13 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %12)
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
  %16 = call i32 @pthread_create(i64* noundef %12, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef %15) #3
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
  %37 = zext i1 %36 to i32
  %38 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %37)
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

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
