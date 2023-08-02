; ModuleID = '/home/ponce/git/Dat3M/benchmarks/lfds/ms.c'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lfds/ms.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Node = type { i32, %struct.Node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@Head = dso_local global %struct.Node* null, align 8, !dbg !0
@Tail = dso_local global %struct.Node* null, align 8, !dbg !10

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !31 {
  %1 = alloca %struct.Node*, align 8
  call void @llvm.dbg.declare(metadata %struct.Node** %1, metadata !35, metadata !DIExpression()), !dbg !36
  %2 = call i8* @malloc(i64 noundef 16), !dbg !37
  %3 = bitcast i8* %2 to %struct.Node*, !dbg !37
  store %struct.Node* %3, %struct.Node** %1, align 8, !dbg !36
  %4 = load %struct.Node*, %struct.Node** %1, align 8, !dbg !38
  %5 = getelementptr inbounds %struct.Node, %struct.Node* %4, i32 0, i32 1, !dbg !39
  store %struct.Node* null, %struct.Node** %5, align 8, !dbg !40
  %6 = load %struct.Node*, %struct.Node** %1, align 8, !dbg !41
  store %struct.Node* %6, %struct.Node** @Head, align 8, !dbg !42
  %7 = load %struct.Node*, %struct.Node** %1, align 8, !dbg !43
  store %struct.Node* %7, %struct.Node** @Tail, align 8, !dbg !44
  ret void, !dbg !45
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i8* @malloc(i64 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @enqueue(i32 noundef %0) #0 !dbg !46 {
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
  call void @llvm.dbg.declare(metadata i32* %2, metadata !49, metadata !DIExpression()), !dbg !50
  call void @llvm.dbg.declare(metadata %struct.Node** %3, metadata !51, metadata !DIExpression()), !dbg !52
  call void @llvm.dbg.declare(metadata %struct.Node** %4, metadata !53, metadata !DIExpression()), !dbg !54
  call void @llvm.dbg.declare(metadata %struct.Node** %5, metadata !55, metadata !DIExpression()), !dbg !56
  %15 = call i8* @malloc(i64 noundef 16), !dbg !57
  %16 = bitcast i8* %15 to %struct.Node*, !dbg !57
  store %struct.Node* %16, %struct.Node** %5, align 8, !dbg !58
  %17 = load i32, i32* %2, align 4, !dbg !59
  %18 = load %struct.Node*, %struct.Node** %5, align 8, !dbg !60
  %19 = getelementptr inbounds %struct.Node, %struct.Node* %18, i32 0, i32 0, !dbg !61
  store i32 %17, i32* %19, align 8, !dbg !62
  %20 = load %struct.Node*, %struct.Node** %5, align 8, !dbg !63
  %21 = getelementptr inbounds %struct.Node, %struct.Node* %20, i32 0, i32 1, !dbg !64
  store %struct.Node* null, %struct.Node** %21, align 8, !dbg !65
  br label %22, !dbg !66

22:                                               ; preds = %1, %94
  %23 = bitcast %struct.Node** %6 to i64*, !dbg !67
  %24 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8, !dbg !67
  store i64 %24, i64* %23, align 8, !dbg !67
  %25 = bitcast i64* %23 to %struct.Node**, !dbg !67
  %26 = load %struct.Node*, %struct.Node** %25, align 8, !dbg !67
  store %struct.Node* %26, %struct.Node** %3, align 8, !dbg !69
  %27 = load %struct.Node*, %struct.Node** %3, align 8, !dbg !70
  %28 = icmp ne %struct.Node* %27, null, !dbg !71
  %29 = zext i1 %28 to i32, !dbg !71
  %30 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %29), !dbg !72
  %31 = load %struct.Node*, %struct.Node** %3, align 8, !dbg !73
  %32 = getelementptr inbounds %struct.Node, %struct.Node* %31, i32 0, i32 1, !dbg !74
  %33 = bitcast %struct.Node** %32 to i64*, !dbg !75
  %34 = bitcast %struct.Node** %7 to i64*, !dbg !75
  %35 = load atomic i64, i64* %33 acquire, align 8, !dbg !75
  store i64 %35, i64* %34, align 8, !dbg !75
  %36 = bitcast i64* %34 to %struct.Node**, !dbg !75
  %37 = load %struct.Node*, %struct.Node** %36, align 8, !dbg !75
  store %struct.Node* %37, %struct.Node** %4, align 8, !dbg !76
  %38 = load %struct.Node*, %struct.Node** %3, align 8, !dbg !77
  %39 = bitcast %struct.Node** %8 to i64*, !dbg !79
  %40 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8, !dbg !79
  store i64 %40, i64* %39, align 8, !dbg !79
  %41 = bitcast i64* %39 to %struct.Node**, !dbg !79
  %42 = load %struct.Node*, %struct.Node** %41, align 8, !dbg !79
  %43 = icmp eq %struct.Node* %38, %42, !dbg !80
  br i1 %43, label %44, label %94, !dbg !81

44:                                               ; preds = %22
  %45 = load %struct.Node*, %struct.Node** %4, align 8, !dbg !82
  %46 = icmp ne %struct.Node* %45, null, !dbg !85
  br i1 %46, label %47, label %61, !dbg !86

47:                                               ; preds = %44
  %48 = load %struct.Node*, %struct.Node** %4, align 8, !dbg !87
  store %struct.Node* %48, %struct.Node** %9, align 8, !dbg !87
  %49 = bitcast %struct.Node** %3 to i64*, !dbg !87
  %50 = bitcast %struct.Node** %9 to i64*, !dbg !87
  %51 = load i64, i64* %49, align 8, !dbg !87
  %52 = load i64, i64* %50, align 8, !dbg !87
  %53 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %51, i64 %52 acq_rel monotonic, align 8, !dbg !87
  %54 = extractvalue { i64, i1 } %53, 0, !dbg !87
  %55 = extractvalue { i64, i1 } %53, 1, !dbg !87
  br i1 %55, label %57, label %56, !dbg !87

56:                                               ; preds = %47
  store i64 %54, i64* %49, align 8, !dbg !87
  br label %57, !dbg !87

57:                                               ; preds = %56, %47
  %58 = zext i1 %55 to i8, !dbg !87
  store i8 %58, i8* %10, align 1, !dbg !87
  %59 = load i8, i8* %10, align 1, !dbg !87
  %60 = trunc i8 %59 to i1, !dbg !87
  br label %93, !dbg !89

61:                                               ; preds = %44
  %62 = load %struct.Node*, %struct.Node** %3, align 8, !dbg !90
  %63 = getelementptr inbounds %struct.Node, %struct.Node* %62, i32 0, i32 1, !dbg !90
  %64 = load %struct.Node*, %struct.Node** %5, align 8, !dbg !90
  store %struct.Node* %64, %struct.Node** %11, align 8, !dbg !90
  %65 = bitcast %struct.Node** %63 to i64*, !dbg !90
  %66 = bitcast %struct.Node** %4 to i64*, !dbg !90
  %67 = bitcast %struct.Node** %11 to i64*, !dbg !90
  %68 = load i64, i64* %66, align 8, !dbg !90
  %69 = load i64, i64* %67, align 8, !dbg !90
  %70 = cmpxchg i64* %65, i64 %68, i64 %69 acq_rel monotonic, align 8, !dbg !90
  %71 = extractvalue { i64, i1 } %70, 0, !dbg !90
  %72 = extractvalue { i64, i1 } %70, 1, !dbg !90
  br i1 %72, label %74, label %73, !dbg !90

73:                                               ; preds = %61
  store i64 %71, i64* %66, align 8, !dbg !90
  br label %74, !dbg !90

74:                                               ; preds = %73, %61
  %75 = zext i1 %72 to i8, !dbg !90
  store i8 %75, i8* %12, align 1, !dbg !90
  %76 = load i8, i8* %12, align 1, !dbg !90
  %77 = trunc i8 %76 to i1, !dbg !90
  br i1 %77, label %78, label %92, !dbg !93

78:                                               ; preds = %74
  %79 = load %struct.Node*, %struct.Node** %5, align 8, !dbg !94
  store %struct.Node* %79, %struct.Node** %13, align 8, !dbg !94
  %80 = bitcast %struct.Node** %3 to i64*, !dbg !94
  %81 = bitcast %struct.Node** %13 to i64*, !dbg !94
  %82 = load i64, i64* %80, align 8, !dbg !94
  %83 = load i64, i64* %81, align 8, !dbg !94
  %84 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %82, i64 %83 acq_rel monotonic, align 8, !dbg !94
  %85 = extractvalue { i64, i1 } %84, 0, !dbg !94
  %86 = extractvalue { i64, i1 } %84, 1, !dbg !94
  br i1 %86, label %88, label %87, !dbg !94

87:                                               ; preds = %78
  store i64 %85, i64* %80, align 8, !dbg !94
  br label %88, !dbg !94

88:                                               ; preds = %87, %78
  %89 = zext i1 %86 to i8, !dbg !94
  store i8 %89, i8* %14, align 1, !dbg !94
  %90 = load i8, i8* %14, align 1, !dbg !94
  %91 = trunc i8 %90 to i1, !dbg !94
  br label %95, !dbg !96

92:                                               ; preds = %74
  br label %93

93:                                               ; preds = %92, %57
  br label %94, !dbg !97

94:                                               ; preds = %93, %22
  br label %22, !dbg !66, !llvm.loop !98

95:                                               ; preds = %88
  ret void, !dbg !100
}

declare i32 @assert(...) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @dequeue() #0 !dbg !101 {
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
  call void @llvm.dbg.declare(metadata %struct.Node** %1, metadata !104, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.declare(metadata %struct.Node** %2, metadata !106, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.declare(metadata %struct.Node** %3, metadata !108, metadata !DIExpression()), !dbg !109
  call void @llvm.dbg.declare(metadata i32* %4, metadata !110, metadata !DIExpression()), !dbg !111
  br label %13, !dbg !112

13:                                               ; preds = %0, %86
  %14 = bitcast %struct.Node** %5 to i64*, !dbg !113
  %15 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8, !dbg !113
  store i64 %15, i64* %14, align 8, !dbg !113
  %16 = bitcast i64* %14 to %struct.Node**, !dbg !113
  %17 = load %struct.Node*, %struct.Node** %16, align 8, !dbg !113
  store %struct.Node* %17, %struct.Node** %1, align 8, !dbg !115
  %18 = load %struct.Node*, %struct.Node** %1, align 8, !dbg !116
  %19 = icmp ne %struct.Node* %18, null, !dbg !117
  %20 = zext i1 %19 to i32, !dbg !117
  %21 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %20), !dbg !118
  %22 = bitcast %struct.Node** %6 to i64*, !dbg !119
  %23 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8, !dbg !119
  store i64 %23, i64* %22, align 8, !dbg !119
  %24 = bitcast i64* %22 to %struct.Node**, !dbg !119
  %25 = load %struct.Node*, %struct.Node** %24, align 8, !dbg !119
  store %struct.Node* %25, %struct.Node** %3, align 8, !dbg !120
  %26 = load %struct.Node*, %struct.Node** %3, align 8, !dbg !121
  %27 = icmp ne %struct.Node* %26, null, !dbg !122
  %28 = zext i1 %27 to i32, !dbg !122
  %29 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %28), !dbg !123
  %30 = load %struct.Node*, %struct.Node** %1, align 8, !dbg !124
  %31 = getelementptr inbounds %struct.Node, %struct.Node* %30, i32 0, i32 1, !dbg !125
  %32 = bitcast %struct.Node** %31 to i64*, !dbg !126
  %33 = bitcast %struct.Node** %7 to i64*, !dbg !126
  %34 = load atomic i64, i64* %32 acquire, align 8, !dbg !126
  store i64 %34, i64* %33, align 8, !dbg !126
  %35 = bitcast i64* %33 to %struct.Node**, !dbg !126
  %36 = load %struct.Node*, %struct.Node** %35, align 8, !dbg !126
  store %struct.Node* %36, %struct.Node** %2, align 8, !dbg !127
  %37 = load %struct.Node*, %struct.Node** %1, align 8, !dbg !128
  %38 = bitcast %struct.Node** %8 to i64*, !dbg !130
  %39 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8, !dbg !130
  store i64 %39, i64* %38, align 8, !dbg !130
  %40 = bitcast i64* %38 to %struct.Node**, !dbg !130
  %41 = load %struct.Node*, %struct.Node** %40, align 8, !dbg !130
  %42 = icmp eq %struct.Node* %37, %41, !dbg !131
  br i1 %42, label %43, label %86, !dbg !132

43:                                               ; preds = %13
  %44 = load %struct.Node*, %struct.Node** %2, align 8, !dbg !133
  %45 = icmp eq %struct.Node* %44, null, !dbg !136
  br i1 %45, label %46, label %47, !dbg !137

46:                                               ; preds = %43
  store i32 -1, i32* %4, align 4, !dbg !138
  br label %87, !dbg !140

47:                                               ; preds = %43
  %48 = load %struct.Node*, %struct.Node** %1, align 8, !dbg !141
  %49 = load %struct.Node*, %struct.Node** %3, align 8, !dbg !144
  %50 = icmp eq %struct.Node* %48, %49, !dbg !145
  br i1 %50, label %51, label %65, !dbg !146

51:                                               ; preds = %47
  %52 = load %struct.Node*, %struct.Node** %2, align 8, !dbg !147
  store %struct.Node* %52, %struct.Node** %9, align 8, !dbg !147
  %53 = bitcast %struct.Node** %3 to i64*, !dbg !147
  %54 = bitcast %struct.Node** %9 to i64*, !dbg !147
  %55 = load i64, i64* %53, align 8, !dbg !147
  %56 = load i64, i64* %54, align 8, !dbg !147
  %57 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %55, i64 %56 acq_rel monotonic, align 8, !dbg !147
  %58 = extractvalue { i64, i1 } %57, 0, !dbg !147
  %59 = extractvalue { i64, i1 } %57, 1, !dbg !147
  br i1 %59, label %61, label %60, !dbg !147

60:                                               ; preds = %51
  store i64 %58, i64* %53, align 8, !dbg !147
  br label %61, !dbg !147

61:                                               ; preds = %60, %51
  %62 = zext i1 %59 to i8, !dbg !147
  store i8 %62, i8* %10, align 1, !dbg !147
  %63 = load i8, i8* %10, align 1, !dbg !147
  %64 = trunc i8 %63 to i1, !dbg !147
  br label %84, !dbg !149

65:                                               ; preds = %47
  %66 = load %struct.Node*, %struct.Node** %2, align 8, !dbg !150
  %67 = getelementptr inbounds %struct.Node, %struct.Node* %66, i32 0, i32 0, !dbg !152
  %68 = load i32, i32* %67, align 8, !dbg !152
  store i32 %68, i32* %4, align 4, !dbg !153
  %69 = load %struct.Node*, %struct.Node** %2, align 8, !dbg !154
  store %struct.Node* %69, %struct.Node** %11, align 8, !dbg !154
  %70 = bitcast %struct.Node** %1 to i64*, !dbg !154
  %71 = bitcast %struct.Node** %11 to i64*, !dbg !154
  %72 = load i64, i64* %70, align 8, !dbg !154
  %73 = load i64, i64* %71, align 8, !dbg !154
  %74 = cmpxchg i64* bitcast (%struct.Node** @Head to i64*), i64 %72, i64 %73 acq_rel monotonic, align 8, !dbg !154
  %75 = extractvalue { i64, i1 } %74, 0, !dbg !154
  %76 = extractvalue { i64, i1 } %74, 1, !dbg !154
  br i1 %76, label %78, label %77, !dbg !154

77:                                               ; preds = %65
  store i64 %75, i64* %70, align 8, !dbg !154
  br label %78, !dbg !154

78:                                               ; preds = %77, %65
  %79 = zext i1 %76 to i8, !dbg !154
  store i8 %79, i8* %12, align 1, !dbg !154
  %80 = load i8, i8* %12, align 1, !dbg !154
  %81 = trunc i8 %80 to i1, !dbg !154
  br i1 %81, label %82, label %83, !dbg !156

82:                                               ; preds = %78
  br label %87, !dbg !157

83:                                               ; preds = %78
  br label %84

84:                                               ; preds = %83, %61
  br label %85

85:                                               ; preds = %84
  br label %86, !dbg !159

86:                                               ; preds = %85, %13
  br label %13, !dbg !112, !llvm.loop !160

87:                                               ; preds = %82, %46
  %88 = load i32, i32* %4, align 4, !dbg !162
  ret i32 %88, !dbg !163
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @worker(i8* noundef %0) #0 !dbg !164 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !168, metadata !DIExpression()), !dbg !169
  call void @llvm.dbg.declare(metadata i64* %3, metadata !170, metadata !DIExpression()), !dbg !171
  %5 = load i8*, i8** %2, align 8, !dbg !172
  %6 = ptrtoint i8* %5 to i64, !dbg !173
  store i64 %6, i64* %3, align 8, !dbg !171
  %7 = load i64, i64* %3, align 8, !dbg !174
  %8 = trunc i64 %7 to i32, !dbg !174
  call void @enqueue(i32 noundef %8), !dbg !175
  call void @llvm.dbg.declare(metadata i32* %4, metadata !176, metadata !DIExpression()), !dbg !177
  %9 = call i32 @dequeue(), !dbg !178
  store i32 %9, i32* %4, align 4, !dbg !177
  %10 = load i32, i32* %4, align 4, !dbg !179
  %11 = icmp ne i32 %10, -1, !dbg !180
  %12 = zext i1 %11 to i32, !dbg !180
  %13 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %12), !dbg !181
  ret i8* null, !dbg !182
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !183 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i64]* %2, metadata !184, metadata !DIExpression()), !dbg !191
  call void @init(), !dbg !192
  call void @llvm.dbg.declare(metadata i32* %3, metadata !193, metadata !DIExpression()), !dbg !195
  store i32 0, i32* %3, align 4, !dbg !195
  br label %6, !dbg !196

6:                                                ; preds = %17, %0
  %7 = load i32, i32* %3, align 4, !dbg !197
  %8 = icmp slt i32 %7, 3, !dbg !199
  br i1 %8, label %9, label %20, !dbg !200

9:                                                ; preds = %6
  %10 = load i32, i32* %3, align 4, !dbg !201
  %11 = sext i32 %10 to i64, !dbg !202
  %12 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %11, !dbg !202
  %13 = load i32, i32* %3, align 4, !dbg !203
  %14 = sext i32 %13 to i64, !dbg !204
  %15 = inttoptr i64 %14 to i8*, !dbg !204
  %16 = call i32 @pthread_create(i64* noundef %12, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef %15) #4, !dbg !205
  br label %17, !dbg !205

17:                                               ; preds = %9
  %18 = load i32, i32* %3, align 4, !dbg !206
  %19 = add nsw i32 %18, 1, !dbg !206
  store i32 %19, i32* %3, align 4, !dbg !206
  br label %6, !dbg !207, !llvm.loop !208

20:                                               ; preds = %6
  call void @llvm.dbg.declare(metadata i32* %4, metadata !211, metadata !DIExpression()), !dbg !213
  store i32 0, i32* %4, align 4, !dbg !213
  br label %21, !dbg !214

21:                                               ; preds = %30, %20
  %22 = load i32, i32* %4, align 4, !dbg !215
  %23 = icmp slt i32 %22, 3, !dbg !217
  br i1 %23, label %24, label %33, !dbg !218

24:                                               ; preds = %21
  %25 = load i32, i32* %4, align 4, !dbg !219
  %26 = sext i32 %25 to i64, !dbg !220
  %27 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %26, !dbg !220
  %28 = load i64, i64* %27, align 8, !dbg !220
  %29 = call i32 @pthread_join(i64 noundef %28, i8** noundef null), !dbg !221
  br label %30, !dbg !221

30:                                               ; preds = %24
  %31 = load i32, i32* %4, align 4, !dbg !222
  %32 = add nsw i32 %31, 1, !dbg !222
  store i32 %32, i32* %4, align 4, !dbg !222
  br label %21, !dbg !223, !llvm.loop !224

33:                                               ; preds = %21
  call void @llvm.dbg.declare(metadata i32* %5, metadata !226, metadata !DIExpression()), !dbg !227
  %34 = call i32 @dequeue(), !dbg !228
  store i32 %34, i32* %5, align 4, !dbg !227
  %35 = load i32, i32* %5, align 4, !dbg !229
  %36 = icmp eq i32 %35, -1, !dbg !230
  %37 = zext i1 %36 to i32, !dbg !230
  %38 = call i32 (i32, ...) bitcast (i32 (...)* @assert to i32 (i32, ...)*)(i32 noundef %37), !dbg !231
  ret i32 0, !dbg !232
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #2

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!23, !24, !25, !26, !27, !28, !29}
!llvm.ident = !{!30}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "Head", scope: !2, file: !12, line: 17, type: !13, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !9, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lfds/ms.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "d23562d2138b1dedd8c3cc53b77c5c63")
!4 = !{!5, !6}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !7, line: 87, baseType: !8)
!7 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!8 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!9 = !{!10, !0}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "Tail", scope: !2, file: !12, line: 16, type: !13, isLocal: false, isDefinition: true)
!12 = !DIFile(filename: "benchmarks/lfds/ms.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "99ecdb5ca305fa4819f6b59868786edc")
!13 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !14)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "Node", file: !12, line: 14, baseType: !16)
!16 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Node", file: !12, line: 11, size: 128, elements: !17)
!17 = !{!18, !20}
!18 = !DIDerivedType(tag: DW_TAG_member, name: "val", scope: !16, file: !12, line: 12, baseType: !19, size: 32)
!19 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !16, file: !12, line: 13, baseType: !21, size: 64, offset: 64)
!21 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!23 = !{i32 7, !"Dwarf Version", i32 5}
!24 = !{i32 2, !"Debug Info Version", i32 3}
!25 = !{i32 1, !"wchar_size", i32 4}
!26 = !{i32 7, !"PIC Level", i32 2}
!27 = !{i32 7, !"PIE Level", i32 2}
!28 = !{i32 7, !"uwtable", i32 1}
!29 = !{i32 7, !"frame-pointer", i32 2}
!30 = !{!"Ubuntu clang version 14.0.6"}
!31 = distinct !DISubprogram(name: "init", scope: !12, file: !12, line: 20, type: !32, scopeLine: 20, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!32 = !DISubroutineType(types: !33)
!33 = !{null}
!34 = !{}
!35 = !DILocalVariable(name: "node", scope: !31, file: !12, line: 21, type: !14)
!36 = !DILocation(line: 21, column: 8, scope: !31)
!37 = !DILocation(line: 21, column: 15, scope: !31)
!38 = !DILocation(line: 22, column: 15, scope: !31)
!39 = !DILocation(line: 22, column: 21, scope: !31)
!40 = !DILocation(line: 22, column: 2, scope: !31)
!41 = !DILocation(line: 23, column: 21, scope: !31)
!42 = !DILocation(line: 23, column: 2, scope: !31)
!43 = !DILocation(line: 24, column: 21, scope: !31)
!44 = !DILocation(line: 24, column: 2, scope: !31)
!45 = !DILocation(line: 25, column: 1, scope: !31)
!46 = distinct !DISubprogram(name: "enqueue", scope: !12, file: !12, line: 27, type: !47, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!47 = !DISubroutineType(types: !48)
!48 = !{null, !19}
!49 = !DILocalVariable(name: "value", arg: 1, scope: !46, file: !12, line: 27, type: !19)
!50 = !DILocation(line: 27, column: 18, scope: !46)
!51 = !DILocalVariable(name: "tail", scope: !46, file: !12, line: 28, type: !14)
!52 = !DILocation(line: 28, column: 8, scope: !46)
!53 = !DILocalVariable(name: "next", scope: !46, file: !12, line: 28, type: !14)
!54 = !DILocation(line: 28, column: 15, scope: !46)
!55 = !DILocalVariable(name: "node", scope: !46, file: !12, line: 28, type: !14)
!56 = !DILocation(line: 28, column: 22, scope: !46)
!57 = !DILocation(line: 30, column: 12, scope: !46)
!58 = !DILocation(line: 30, column: 10, scope: !46)
!59 = !DILocation(line: 31, column: 14, scope: !46)
!60 = !DILocation(line: 31, column: 2, scope: !46)
!61 = !DILocation(line: 31, column: 8, scope: !46)
!62 = !DILocation(line: 31, column: 12, scope: !46)
!63 = !DILocation(line: 32, column: 15, scope: !46)
!64 = !DILocation(line: 32, column: 21, scope: !46)
!65 = !DILocation(line: 32, column: 2, scope: !46)
!66 = !DILocation(line: 34, column: 2, scope: !46)
!67 = !DILocation(line: 35, column: 10, scope: !68)
!68 = distinct !DILexicalBlock(scope: !46, file: !12, line: 34, column: 12)
!69 = !DILocation(line: 35, column: 8, scope: !68)
!70 = !DILocation(line: 36, column: 10, scope: !68)
!71 = !DILocation(line: 36, column: 15, scope: !68)
!72 = !DILocation(line: 36, column: 3, scope: !68)
!73 = !DILocation(line: 37, column: 32, scope: !68)
!74 = !DILocation(line: 37, column: 38, scope: !68)
!75 = !DILocation(line: 37, column: 10, scope: !68)
!76 = !DILocation(line: 37, column: 8, scope: !68)
!77 = !DILocation(line: 39, column: 7, scope: !78)
!78 = distinct !DILexicalBlock(scope: !68, file: !12, line: 39, column: 7)
!79 = !DILocation(line: 39, column: 15, scope: !78)
!80 = !DILocation(line: 39, column: 12, scope: !78)
!81 = !DILocation(line: 39, column: 7, scope: !68)
!82 = !DILocation(line: 40, column: 8, scope: !83)
!83 = distinct !DILexicalBlock(scope: !84, file: !12, line: 40, column: 8)
!84 = distinct !DILexicalBlock(scope: !78, file: !12, line: 39, column: 62)
!85 = !DILocation(line: 40, column: 13, scope: !83)
!86 = !DILocation(line: 40, column: 8, scope: !84)
!87 = !DILocation(line: 41, column: 5, scope: !88)
!88 = distinct !DILexicalBlock(scope: !83, file: !12, line: 40, column: 22)
!89 = !DILocation(line: 42, column: 4, scope: !88)
!90 = !DILocation(line: 43, column: 9, scope: !91)
!91 = distinct !DILexicalBlock(scope: !92, file: !12, line: 43, column: 9)
!92 = distinct !DILexicalBlock(scope: !83, file: !12, line: 42, column: 11)
!93 = !DILocation(line: 43, column: 9, scope: !92)
!94 = !DILocation(line: 44, column: 9, scope: !95)
!95 = distinct !DILexicalBlock(scope: !91, file: !12, line: 43, column: 40)
!96 = !DILocation(line: 45, column: 6, scope: !95)
!97 = !DILocation(line: 48, column: 3, scope: !84)
!98 = distinct !{!98, !66, !99}
!99 = !DILocation(line: 49, column: 2, scope: !46)
!100 = !DILocation(line: 50, column: 1, scope: !46)
!101 = distinct !DISubprogram(name: "dequeue", scope: !12, file: !12, line: 52, type: !102, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!102 = !DISubroutineType(types: !103)
!103 = !{!19}
!104 = !DILocalVariable(name: "head", scope: !101, file: !12, line: 53, type: !14)
!105 = !DILocation(line: 53, column: 8, scope: !101)
!106 = !DILocalVariable(name: "next", scope: !101, file: !12, line: 53, type: !14)
!107 = !DILocation(line: 53, column: 15, scope: !101)
!108 = !DILocalVariable(name: "tail", scope: !101, file: !12, line: 53, type: !14)
!109 = !DILocation(line: 53, column: 22, scope: !101)
!110 = !DILocalVariable(name: "result", scope: !101, file: !12, line: 54, type: !19)
!111 = !DILocation(line: 54, column: 6, scope: !101)
!112 = !DILocation(line: 56, column: 2, scope: !101)
!113 = !DILocation(line: 57, column: 10, scope: !114)
!114 = distinct !DILexicalBlock(scope: !101, file: !12, line: 56, column: 12)
!115 = !DILocation(line: 57, column: 8, scope: !114)
!116 = !DILocation(line: 58, column: 10, scope: !114)
!117 = !DILocation(line: 58, column: 15, scope: !114)
!118 = !DILocation(line: 58, column: 3, scope: !114)
!119 = !DILocation(line: 59, column: 10, scope: !114)
!120 = !DILocation(line: 59, column: 8, scope: !114)
!121 = !DILocation(line: 60, column: 10, scope: !114)
!122 = !DILocation(line: 60, column: 15, scope: !114)
!123 = !DILocation(line: 60, column: 3, scope: !114)
!124 = !DILocation(line: 61, column: 32, scope: !114)
!125 = !DILocation(line: 61, column: 38, scope: !114)
!126 = !DILocation(line: 61, column: 10, scope: !114)
!127 = !DILocation(line: 61, column: 8, scope: !114)
!128 = !DILocation(line: 63, column: 7, scope: !129)
!129 = distinct !DILexicalBlock(scope: !114, file: !12, line: 63, column: 7)
!130 = !DILocation(line: 63, column: 15, scope: !129)
!131 = !DILocation(line: 63, column: 12, scope: !129)
!132 = !DILocation(line: 63, column: 7, scope: !114)
!133 = !DILocation(line: 64, column: 8, scope: !134)
!134 = distinct !DILexicalBlock(scope: !135, file: !12, line: 64, column: 8)
!135 = distinct !DILexicalBlock(scope: !129, file: !12, line: 63, column: 62)
!136 = !DILocation(line: 64, column: 13, scope: !134)
!137 = !DILocation(line: 64, column: 8, scope: !135)
!138 = !DILocation(line: 65, column: 12, scope: !139)
!139 = distinct !DILexicalBlock(scope: !134, file: !12, line: 64, column: 22)
!140 = !DILocation(line: 66, column: 5, scope: !139)
!141 = !DILocation(line: 68, column: 9, scope: !142)
!142 = distinct !DILexicalBlock(scope: !143, file: !12, line: 68, column: 9)
!143 = distinct !DILexicalBlock(scope: !134, file: !12, line: 67, column: 11)
!144 = !DILocation(line: 68, column: 17, scope: !142)
!145 = !DILocation(line: 68, column: 14, scope: !142)
!146 = !DILocation(line: 68, column: 9, scope: !143)
!147 = !DILocation(line: 69, column: 6, scope: !148)
!148 = distinct !DILexicalBlock(scope: !142, file: !12, line: 68, column: 23)
!149 = !DILocation(line: 70, column: 5, scope: !148)
!150 = !DILocation(line: 71, column: 15, scope: !151)
!151 = distinct !DILexicalBlock(scope: !142, file: !12, line: 70, column: 12)
!152 = !DILocation(line: 71, column: 21, scope: !151)
!153 = !DILocation(line: 71, column: 13, scope: !151)
!154 = !DILocation(line: 72, column: 10, scope: !155)
!155 = distinct !DILexicalBlock(scope: !151, file: !12, line: 72, column: 10)
!156 = !DILocation(line: 72, column: 10, scope: !151)
!157 = !DILocation(line: 74, column: 25, scope: !158)
!158 = distinct !DILexicalBlock(scope: !155, file: !12, line: 72, column: 35)
!159 = !DILocation(line: 78, column: 3, scope: !135)
!160 = distinct !{!160, !112, !161}
!161 = !DILocation(line: 79, column: 2, scope: !101)
!162 = !DILocation(line: 81, column: 9, scope: !101)
!163 = !DILocation(line: 81, column: 2, scope: !101)
!164 = distinct !DISubprogram(name: "worker", scope: !165, file: !165, line: 8, type: !166, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!165 = !DIFile(filename: "benchmarks/lfds/ms.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "d23562d2138b1dedd8c3cc53b77c5c63")
!166 = !DISubroutineType(types: !167)
!167 = !{!5, !5}
!168 = !DILocalVariable(name: "arg", arg: 1, scope: !164, file: !165, line: 8, type: !5)
!169 = !DILocation(line: 8, column: 20, scope: !164)
!170 = !DILocalVariable(name: "index", scope: !164, file: !165, line: 11, type: !6)
!171 = !DILocation(line: 11, column: 14, scope: !164)
!172 = !DILocation(line: 11, column: 34, scope: !164)
!173 = !DILocation(line: 11, column: 23, scope: !164)
!174 = !DILocation(line: 13, column: 10, scope: !164)
!175 = !DILocation(line: 13, column: 2, scope: !164)
!176 = !DILocalVariable(name: "r", scope: !164, file: !165, line: 14, type: !19)
!177 = !DILocation(line: 14, column: 9, scope: !164)
!178 = !DILocation(line: 14, column: 13, scope: !164)
!179 = !DILocation(line: 16, column: 9, scope: !164)
!180 = !DILocation(line: 16, column: 11, scope: !164)
!181 = !DILocation(line: 16, column: 2, scope: !164)
!182 = !DILocation(line: 18, column: 2, scope: !164)
!183 = distinct !DISubprogram(name: "main", scope: !165, file: !165, line: 21, type: !102, scopeLine: 22, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !34)
!184 = !DILocalVariable(name: "t", scope: !183, file: !165, line: 23, type: !185)
!185 = !DICompositeType(tag: DW_TAG_array_type, baseType: !186, size: 192, elements: !189)
!186 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !187, line: 27, baseType: !188)
!187 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!188 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!189 = !{!190}
!190 = !DISubrange(count: 3)
!191 = !DILocation(line: 23, column: 15, scope: !183)
!192 = !DILocation(line: 25, column: 5, scope: !183)
!193 = !DILocalVariable(name: "i", scope: !194, file: !165, line: 27, type: !19)
!194 = distinct !DILexicalBlock(scope: !183, file: !165, line: 27, column: 5)
!195 = !DILocation(line: 27, column: 14, scope: !194)
!196 = !DILocation(line: 27, column: 10, scope: !194)
!197 = !DILocation(line: 27, column: 21, scope: !198)
!198 = distinct !DILexicalBlock(scope: !194, file: !165, line: 27, column: 5)
!199 = !DILocation(line: 27, column: 23, scope: !198)
!200 = !DILocation(line: 27, column: 5, scope: !194)
!201 = !DILocation(line: 28, column: 27, scope: !198)
!202 = !DILocation(line: 28, column: 25, scope: !198)
!203 = !DILocation(line: 28, column: 50, scope: !198)
!204 = !DILocation(line: 28, column: 42, scope: !198)
!205 = !DILocation(line: 28, column: 9, scope: !198)
!206 = !DILocation(line: 27, column: 36, scope: !198)
!207 = !DILocation(line: 27, column: 5, scope: !198)
!208 = distinct !{!208, !200, !209, !210}
!209 = !DILocation(line: 28, column: 51, scope: !194)
!210 = !{!"llvm.loop.mustprogress"}
!211 = !DILocalVariable(name: "i", scope: !212, file: !165, line: 30, type: !19)
!212 = distinct !DILexicalBlock(scope: !183, file: !165, line: 30, column: 5)
!213 = !DILocation(line: 30, column: 14, scope: !212)
!214 = !DILocation(line: 30, column: 10, scope: !212)
!215 = !DILocation(line: 30, column: 21, scope: !216)
!216 = distinct !DILexicalBlock(scope: !212, file: !165, line: 30, column: 5)
!217 = !DILocation(line: 30, column: 23, scope: !216)
!218 = !DILocation(line: 30, column: 5, scope: !212)
!219 = !DILocation(line: 31, column: 24, scope: !216)
!220 = !DILocation(line: 31, column: 22, scope: !216)
!221 = !DILocation(line: 31, column: 9, scope: !216)
!222 = !DILocation(line: 30, column: 36, scope: !216)
!223 = !DILocation(line: 30, column: 5, scope: !216)
!224 = distinct !{!224, !218, !225, !210}
!225 = !DILocation(line: 31, column: 29, scope: !212)
!226 = !DILocalVariable(name: "r", scope: !183, file: !165, line: 33, type: !19)
!227 = !DILocation(line: 33, column: 9, scope: !183)
!228 = !DILocation(line: 33, column: 13, scope: !183)
!229 = !DILocation(line: 34, column: 12, scope: !183)
!230 = !DILocation(line: 34, column: 14, scope: !183)
!231 = !DILocation(line: 34, column: 5, scope: !183)
!232 = !DILocation(line: 36, column: 5, scope: !183)
