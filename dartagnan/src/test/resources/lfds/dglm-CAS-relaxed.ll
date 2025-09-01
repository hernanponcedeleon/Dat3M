; ModuleID = 'dglm.c'
source_filename = "dglm.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Node = type { i32, %struct.Node* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@Head = dso_local global %struct.Node* null, align 8, !dbg !0
@Tail = dso_local global %struct.Node* null, align 8, !dbg !13
@.str = private unnamed_addr constant [13 x i8] c"tail != NULL\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"./dglm.h\00", align 1
@__PRETTY_FUNCTION__.enqueue = private unnamed_addr constant [18 x i8] c"void enqueue(int)\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"head != NULL\00", align 1
@__PRETTY_FUNCTION__.dequeue = private unnamed_addr constant [14 x i8] c"int dequeue()\00", align 1
@.str.3 = private unnamed_addr constant [11 x i8] c"r != EMPTY\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"dglm.c\00", align 1
@__PRETTY_FUNCTION__.worker = private unnamed_addr constant [21 x i8] c"void *worker(void *)\00", align 1
@data = dso_local global [3 x i32] zeroinitializer, align 4, !dbg !26
@.str.5 = private unnamed_addr constant [11 x i8] c"r == EMPTY\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@.str.6 = private unnamed_addr constant [13 x i8] c"data[i] == 1\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !39 {
  %1 = alloca %struct.Node*, align 8
  call void @llvm.dbg.declare(metadata %struct.Node** %1, metadata !43, metadata !DIExpression()), !dbg !44
  %2 = call noalias i8* @malloc(i64 noundef 16) #5, !dbg !45
  %3 = bitcast i8* %2 to %struct.Node*, !dbg !45
  store %struct.Node* %3, %struct.Node** %1, align 8, !dbg !44
  %4 = load %struct.Node*, %struct.Node** %1, align 8, !dbg !46
  %5 = getelementptr inbounds %struct.Node, %struct.Node* %4, i32 0, i32 1, !dbg !47
  store %struct.Node* null, %struct.Node** %5, align 8, !dbg !48
  %6 = load %struct.Node*, %struct.Node** %1, align 8, !dbg !49
  store %struct.Node* %6, %struct.Node** @Head, align 8, !dbg !50
  %7 = load %struct.Node*, %struct.Node** %1, align 8, !dbg !51
  store %struct.Node* %7, %struct.Node** @Tail, align 8, !dbg !52
  ret void, !dbg !53
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @enqueue(i32 noundef %0) #0 !dbg !54 {
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
  call void @llvm.dbg.declare(metadata i32* %2, metadata !57, metadata !DIExpression()), !dbg !58
  call void @llvm.dbg.declare(metadata %struct.Node** %3, metadata !59, metadata !DIExpression()), !dbg !60
  call void @llvm.dbg.declare(metadata %struct.Node** %4, metadata !61, metadata !DIExpression()), !dbg !62
  call void @llvm.dbg.declare(metadata %struct.Node** %5, metadata !63, metadata !DIExpression()), !dbg !64
  %15 = call noalias i8* @malloc(i64 noundef 16) #5, !dbg !65
  %16 = bitcast i8* %15 to %struct.Node*, !dbg !65
  store %struct.Node* %16, %struct.Node** %5, align 8, !dbg !66
  %17 = load i32, i32* %2, align 4, !dbg !67
  %18 = load %struct.Node*, %struct.Node** %5, align 8, !dbg !68
  %19 = getelementptr inbounds %struct.Node, %struct.Node* %18, i32 0, i32 0, !dbg !69
  store i32 %17, i32* %19, align 8, !dbg !70
  %20 = load %struct.Node*, %struct.Node** %5, align 8, !dbg !71
  %21 = getelementptr inbounds %struct.Node, %struct.Node* %20, i32 0, i32 1, !dbg !72
  store %struct.Node* null, %struct.Node** %21, align 8, !dbg !73
  br label %22, !dbg !74

22:                                               ; preds = %1, %95
  %23 = bitcast %struct.Node** %6 to i64*, !dbg !75
  %24 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8, !dbg !75
  store i64 %24, i64* %23, align 8, !dbg !75
  %25 = bitcast i64* %23 to %struct.Node**, !dbg !75
  %26 = load %struct.Node*, %struct.Node** %25, align 8, !dbg !75
  store %struct.Node* %26, %struct.Node** %3, align 8, !dbg !77
  %27 = load %struct.Node*, %struct.Node** %3, align 8, !dbg !78
  %28 = icmp ne %struct.Node* %27, null, !dbg !78
  br i1 %28, label %29, label %30, !dbg !81

29:                                               ; preds = %22
  br label %31, !dbg !81

30:                                               ; preds = %22
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.enqueue, i64 0, i64 0)) #6, !dbg !78
  unreachable, !dbg !78

31:                                               ; preds = %29
  %32 = load %struct.Node*, %struct.Node** %3, align 8, !dbg !82
  %33 = getelementptr inbounds %struct.Node, %struct.Node* %32, i32 0, i32 1, !dbg !83
  %34 = bitcast %struct.Node** %33 to i64*, !dbg !84
  %35 = bitcast %struct.Node** %7 to i64*, !dbg !84
  %36 = load atomic i64, i64* %34 acquire, align 8, !dbg !84
  store i64 %36, i64* %35, align 8, !dbg !84
  %37 = bitcast i64* %35 to %struct.Node**, !dbg !84
  %38 = load %struct.Node*, %struct.Node** %37, align 8, !dbg !84
  store %struct.Node* %38, %struct.Node** %4, align 8, !dbg !85
  %39 = load %struct.Node*, %struct.Node** %3, align 8, !dbg !86
  %40 = bitcast %struct.Node** %8 to i64*, !dbg !88
  %41 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8, !dbg !88
  store i64 %41, i64* %40, align 8, !dbg !88
  %42 = bitcast i64* %40 to %struct.Node**, !dbg !88
  %43 = load %struct.Node*, %struct.Node** %42, align 8, !dbg !88
  %44 = icmp eq %struct.Node* %39, %43, !dbg !89
  br i1 %44, label %45, label %95, !dbg !90

45:                                               ; preds = %31
  %46 = load %struct.Node*, %struct.Node** %4, align 8, !dbg !91
  %47 = icmp eq %struct.Node* %46, null, !dbg !94
  br i1 %47, label %48, label %80, !dbg !95

48:                                               ; preds = %45
  %49 = load %struct.Node*, %struct.Node** %3, align 8, !dbg !96
  %50 = getelementptr inbounds %struct.Node, %struct.Node* %49, i32 0, i32 1, !dbg !96
  %51 = load %struct.Node*, %struct.Node** %5, align 8, !dbg !96
  store %struct.Node* %51, %struct.Node** %9, align 8, !dbg !96
  %52 = bitcast %struct.Node** %50 to i64*, !dbg !96
  %53 = bitcast %struct.Node** %4 to i64*, !dbg !96
  %54 = bitcast %struct.Node** %9 to i64*, !dbg !96
  %55 = load i64, i64* %53, align 8, !dbg !96
  %56 = load i64, i64* %54, align 8, !dbg !96
  %57 = cmpxchg i64* %52, i64 %55, i64 %56 monotonic monotonic, align 8, !dbg !96
  %58 = extractvalue { i64, i1 } %57, 0, !dbg !96
  %59 = extractvalue { i64, i1 } %57, 1, !dbg !96
  br i1 %59, label %61, label %60, !dbg !96

60:                                               ; preds = %48
  store i64 %58, i64* %53, align 8, !dbg !96
  br label %61, !dbg !96

61:                                               ; preds = %60, %48
  %62 = zext i1 %59 to i8, !dbg !96
  store i8 %62, i8* %10, align 1, !dbg !96
  %63 = load i8, i8* %10, align 1, !dbg !96
  %64 = trunc i8 %63 to i1, !dbg !96
  br i1 %64, label %65, label %79, !dbg !99

65:                                               ; preds = %61
  %66 = load %struct.Node*, %struct.Node** %5, align 8, !dbg !100
  store %struct.Node* %66, %struct.Node** %11, align 8, !dbg !100
  %67 = bitcast %struct.Node** %3 to i64*, !dbg !100
  %68 = bitcast %struct.Node** %11 to i64*, !dbg !100
  %69 = load i64, i64* %67, align 8, !dbg !100
  %70 = load i64, i64* %68, align 8, !dbg !100
  %71 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %69, i64 %70 monotonic monotonic, align 8, !dbg !100
  %72 = extractvalue { i64, i1 } %71, 0, !dbg !100
  %73 = extractvalue { i64, i1 } %71, 1, !dbg !100
  br i1 %73, label %75, label %74, !dbg !100

74:                                               ; preds = %65
  store i64 %72, i64* %67, align 8, !dbg !100
  br label %75, !dbg !100

75:                                               ; preds = %74, %65
  %76 = zext i1 %73 to i8, !dbg !100
  store i8 %76, i8* %12, align 1, !dbg !100
  %77 = load i8, i8* %12, align 1, !dbg !100
  %78 = trunc i8 %77 to i1, !dbg !100
  br label %96, !dbg !102

79:                                               ; preds = %61
  br label %94, !dbg !103

80:                                               ; preds = %45
  %81 = load %struct.Node*, %struct.Node** %4, align 8, !dbg !104
  store %struct.Node* %81, %struct.Node** %13, align 8, !dbg !104
  %82 = bitcast %struct.Node** %3 to i64*, !dbg !104
  %83 = bitcast %struct.Node** %13 to i64*, !dbg !104
  %84 = load i64, i64* %82, align 8, !dbg !104
  %85 = load i64, i64* %83, align 8, !dbg !104
  %86 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %84, i64 %85 monotonic monotonic, align 8, !dbg !104
  %87 = extractvalue { i64, i1 } %86, 0, !dbg !104
  %88 = extractvalue { i64, i1 } %86, 1, !dbg !104
  br i1 %88, label %90, label %89, !dbg !104

89:                                               ; preds = %80
  store i64 %87, i64* %82, align 8, !dbg !104
  br label %90, !dbg !104

90:                                               ; preds = %89, %80
  %91 = zext i1 %88 to i8, !dbg !104
  store i8 %91, i8* %14, align 1, !dbg !104
  %92 = load i8, i8* %14, align 1, !dbg !104
  %93 = trunc i8 %92 to i1, !dbg !104
  br label %94

94:                                               ; preds = %90, %79
  br label %95, !dbg !106

95:                                               ; preds = %94, %31
  br label %22, !dbg !74, !llvm.loop !107

96:                                               ; preds = %75
  ret void, !dbg !109
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @dequeue() #0 !dbg !110 {
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
  call void @llvm.dbg.declare(metadata %struct.Node** %1, metadata !113, metadata !DIExpression()), !dbg !114
  call void @llvm.dbg.declare(metadata %struct.Node** %2, metadata !115, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.declare(metadata %struct.Node** %3, metadata !117, metadata !DIExpression()), !dbg !118
  call void @llvm.dbg.declare(metadata i32* %4, metadata !119, metadata !DIExpression()), !dbg !120
  br label %13, !dbg !121

13:                                               ; preds = %0, %89
  %14 = bitcast %struct.Node** %5 to i64*, !dbg !122
  %15 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8, !dbg !122
  store i64 %15, i64* %14, align 8, !dbg !122
  %16 = bitcast i64* %14 to %struct.Node**, !dbg !122
  %17 = load %struct.Node*, %struct.Node** %16, align 8, !dbg !122
  store %struct.Node* %17, %struct.Node** %1, align 8, !dbg !124
  %18 = load %struct.Node*, %struct.Node** %1, align 8, !dbg !125
  %19 = icmp ne %struct.Node* %18, null, !dbg !125
  br i1 %19, label %20, label %21, !dbg !128

20:                                               ; preds = %13
  br label %22, !dbg !128

21:                                               ; preds = %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0), i32 noundef 61, i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__PRETTY_FUNCTION__.dequeue, i64 0, i64 0)) #6, !dbg !125
  unreachable, !dbg !125

22:                                               ; preds = %20
  %23 = load %struct.Node*, %struct.Node** %1, align 8, !dbg !129
  %24 = getelementptr inbounds %struct.Node, %struct.Node* %23, i32 0, i32 1, !dbg !130
  %25 = bitcast %struct.Node** %24 to i64*, !dbg !131
  %26 = bitcast %struct.Node** %6 to i64*, !dbg !131
  %27 = load atomic i64, i64* %25 acquire, align 8, !dbg !131
  store i64 %27, i64* %26, align 8, !dbg !131
  %28 = bitcast i64* %26 to %struct.Node**, !dbg !131
  %29 = load %struct.Node*, %struct.Node** %28, align 8, !dbg !131
  store %struct.Node* %29, %struct.Node** %2, align 8, !dbg !132
  %30 = load %struct.Node*, %struct.Node** %1, align 8, !dbg !133
  %31 = bitcast %struct.Node** %7 to i64*, !dbg !135
  %32 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) acquire, align 8, !dbg !135
  store i64 %32, i64* %31, align 8, !dbg !135
  %33 = bitcast i64* %31 to %struct.Node**, !dbg !135
  %34 = load %struct.Node*, %struct.Node** %33, align 8, !dbg !135
  %35 = icmp eq %struct.Node* %30, %34, !dbg !136
  br i1 %35, label %36, label %89, !dbg !137

36:                                               ; preds = %22
  %37 = load %struct.Node*, %struct.Node** %2, align 8, !dbg !138
  %38 = icmp eq %struct.Node* %37, null, !dbg !141
  br i1 %38, label %39, label %40, !dbg !142

39:                                               ; preds = %36
  store i32 -1, i32* %4, align 4, !dbg !143
  br label %90, !dbg !145

40:                                               ; preds = %36
  %41 = load %struct.Node*, %struct.Node** %2, align 8, !dbg !146
  %42 = getelementptr inbounds %struct.Node, %struct.Node* %41, i32 0, i32 0, !dbg !148
  %43 = load i32, i32* %42, align 8, !dbg !148
  store i32 %43, i32* %4, align 4, !dbg !149
  %44 = load %struct.Node*, %struct.Node** %2, align 8, !dbg !150
  store %struct.Node* %44, %struct.Node** %8, align 8, !dbg !150
  %45 = bitcast %struct.Node** %1 to i64*, !dbg !150
  %46 = bitcast %struct.Node** %8 to i64*, !dbg !150
  %47 = load i64, i64* %45, align 8, !dbg !150
  %48 = load i64, i64* %46, align 8, !dbg !150
  %49 = cmpxchg i64* bitcast (%struct.Node** @Head to i64*), i64 %47, i64 %48 monotonic monotonic, align 8, !dbg !150
  %50 = extractvalue { i64, i1 } %49, 0, !dbg !150
  %51 = extractvalue { i64, i1 } %49, 1, !dbg !150
  br i1 %51, label %53, label %52, !dbg !150

52:                                               ; preds = %40
  store i64 %50, i64* %45, align 8, !dbg !150
  br label %53, !dbg !150

53:                                               ; preds = %52, %40
  %54 = zext i1 %51 to i8, !dbg !150
  store i8 %54, i8* %9, align 1, !dbg !150
  %55 = load i8, i8* %9, align 1, !dbg !150
  %56 = trunc i8 %55 to i1, !dbg !150
  br i1 %56, label %57, label %87, !dbg !152

57:                                               ; preds = %53
  %58 = bitcast %struct.Node** %10 to i64*, !dbg !153
  %59 = load atomic i64, i64* bitcast (%struct.Node** @Tail to i64*) acquire, align 8, !dbg !153
  store i64 %59, i64* %58, align 8, !dbg !153
  %60 = bitcast i64* %58 to %struct.Node**, !dbg !153
  %61 = load %struct.Node*, %struct.Node** %60, align 8, !dbg !153
  store %struct.Node* %61, %struct.Node** %3, align 8, !dbg !155
  %62 = load %struct.Node*, %struct.Node** %3, align 8, !dbg !156
  %63 = icmp ne %struct.Node* %62, null, !dbg !156
  br i1 %63, label %64, label %65, !dbg !159

64:                                               ; preds = %57
  br label %66, !dbg !159

65:                                               ; preds = %57
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0), i32 noundef 73, i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @__PRETTY_FUNCTION__.dequeue, i64 0, i64 0)) #6, !dbg !156
  unreachable, !dbg !156

66:                                               ; preds = %64
  %67 = load %struct.Node*, %struct.Node** %1, align 8, !dbg !160
  %68 = load %struct.Node*, %struct.Node** %3, align 8, !dbg !162
  %69 = icmp eq %struct.Node* %67, %68, !dbg !163
  br i1 %69, label %70, label %84, !dbg !164

70:                                               ; preds = %66
  %71 = load %struct.Node*, %struct.Node** %2, align 8, !dbg !165
  store %struct.Node* %71, %struct.Node** %11, align 8, !dbg !165
  %72 = bitcast %struct.Node** %3 to i64*, !dbg !165
  %73 = bitcast %struct.Node** %11 to i64*, !dbg !165
  %74 = load i64, i64* %72, align 8, !dbg !165
  %75 = load i64, i64* %73, align 8, !dbg !165
  %76 = cmpxchg i64* bitcast (%struct.Node** @Tail to i64*), i64 %74, i64 %75 monotonic monotonic, align 8, !dbg !165
  %77 = extractvalue { i64, i1 } %76, 0, !dbg !165
  %78 = extractvalue { i64, i1 } %76, 1, !dbg !165
  br i1 %78, label %80, label %79, !dbg !165

79:                                               ; preds = %70
  store i64 %77, i64* %72, align 8, !dbg !165
  br label %80, !dbg !165

80:                                               ; preds = %79, %70
  %81 = zext i1 %78 to i8, !dbg !165
  store i8 %81, i8* %12, align 1, !dbg !165
  %82 = load i8, i8* %12, align 1, !dbg !165
  %83 = trunc i8 %82 to i1, !dbg !165
  br label %84, !dbg !167

84:                                               ; preds = %80, %66
  %85 = load %struct.Node*, %struct.Node** %1, align 8, !dbg !168
  %86 = bitcast %struct.Node* %85 to i8*, !dbg !168
  call void @free(i8* noundef %86) #5, !dbg !169
  br label %90, !dbg !170

87:                                               ; preds = %53
  br label %88

88:                                               ; preds = %87
  br label %89, !dbg !171

89:                                               ; preds = %88, %22
  br label %13, !dbg !121, !llvm.loop !172

90:                                               ; preds = %84, %39
  %91 = load i32, i32* %4, align 4, !dbg !174
  ret i32 %91, !dbg !175
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @worker(i8* noundef %0) #0 !dbg !176 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !179, metadata !DIExpression()), !dbg !180
  call void @llvm.dbg.declare(metadata i64* %3, metadata !181, metadata !DIExpression()), !dbg !182
  %5 = load i8*, i8** %2, align 8, !dbg !183
  %6 = ptrtoint i8* %5 to i64, !dbg !184
  store i64 %6, i64* %3, align 8, !dbg !182
  %7 = load i64, i64* %3, align 8, !dbg !185
  %8 = trunc i64 %7 to i32, !dbg !185
  call void @enqueue(i32 noundef %8), !dbg !186
  call void @llvm.dbg.declare(metadata i32* %4, metadata !187, metadata !DIExpression()), !dbg !188
  %9 = call i32 @dequeue(), !dbg !189
  store i32 %9, i32* %4, align 4, !dbg !188
  %10 = load i32, i32* %4, align 4, !dbg !190
  %11 = icmp ne i32 %10, -1, !dbg !190
  br i1 %11, label %12, label %13, !dbg !193

12:                                               ; preds = %1
  br label %14, !dbg !193

13:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i64 0, i64 0), i32 noundef 18, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.worker, i64 0, i64 0)) #6, !dbg !190
  unreachable, !dbg !190

14:                                               ; preds = %12
  %15 = load i32, i32* %4, align 4, !dbg !194
  %16 = sext i32 %15 to i64, !dbg !195
  %17 = getelementptr inbounds [3 x i32], [3 x i32]* @data, i64 0, i64 %16, !dbg !195
  store i32 1, i32* %17, align 4, !dbg !196
  ret i8* null, !dbg !197
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !198 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i64]* %2, metadata !199, metadata !DIExpression()), !dbg !203
  call void @init(), !dbg !204
  call void @llvm.dbg.declare(metadata i32* %3, metadata !205, metadata !DIExpression()), !dbg !207
  store i32 0, i32* %3, align 4, !dbg !207
  br label %7, !dbg !208

7:                                                ; preds = %18, %0
  %8 = load i32, i32* %3, align 4, !dbg !209
  %9 = icmp slt i32 %8, 3, !dbg !211
  br i1 %9, label %10, label %21, !dbg !212

10:                                               ; preds = %7
  %11 = load i32, i32* %3, align 4, !dbg !213
  %12 = sext i32 %11 to i64, !dbg !214
  %13 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %12, !dbg !214
  %14 = load i32, i32* %3, align 4, !dbg !215
  %15 = sext i32 %14 to i64, !dbg !216
  %16 = inttoptr i64 %15 to i8*, !dbg !217
  %17 = call i32 @pthread_create(i64* noundef %13, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @worker, i8* noundef %16) #5, !dbg !218
  br label %18, !dbg !218

18:                                               ; preds = %10
  %19 = load i32, i32* %3, align 4, !dbg !219
  %20 = add nsw i32 %19, 1, !dbg !219
  store i32 %20, i32* %3, align 4, !dbg !219
  br label %7, !dbg !220, !llvm.loop !221

21:                                               ; preds = %7
  call void @llvm.dbg.declare(metadata i32* %4, metadata !224, metadata !DIExpression()), !dbg !226
  store i32 0, i32* %4, align 4, !dbg !226
  br label %22, !dbg !227

22:                                               ; preds = %31, %21
  %23 = load i32, i32* %4, align 4, !dbg !228
  %24 = icmp slt i32 %23, 3, !dbg !230
  br i1 %24, label %25, label %34, !dbg !231

25:                                               ; preds = %22
  %26 = load i32, i32* %4, align 4, !dbg !232
  %27 = sext i32 %26 to i64, !dbg !233
  %28 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %27, !dbg !233
  %29 = load i64, i64* %28, align 8, !dbg !233
  %30 = call i32 @pthread_join(i64 noundef %29, i8** noundef null), !dbg !234
  br label %31, !dbg !234

31:                                               ; preds = %25
  %32 = load i32, i32* %4, align 4, !dbg !235
  %33 = add nsw i32 %32, 1, !dbg !235
  store i32 %33, i32* %4, align 4, !dbg !235
  br label %22, !dbg !236, !llvm.loop !237

34:                                               ; preds = %22
  call void @llvm.dbg.declare(metadata i32* %5, metadata !239, metadata !DIExpression()), !dbg !240
  %35 = call i32 @dequeue(), !dbg !241
  store i32 %35, i32* %5, align 4, !dbg !240
  %36 = load i32, i32* %5, align 4, !dbg !242
  %37 = icmp eq i32 %36, -1, !dbg !242
  br i1 %37, label %38, label %39, !dbg !245

38:                                               ; preds = %34
  br label %40, !dbg !245

39:                                               ; preds = %34
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i64 0, i64 0), i32 noundef 37, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !242
  unreachable, !dbg !242

40:                                               ; preds = %38
  %41 = load atomic i64, i64* bitcast (%struct.Node** @Head to i64*) seq_cst, align 8, !dbg !246
  %42 = inttoptr i64 %41 to %struct.Node*, !dbg !246
  %43 = bitcast %struct.Node* %42 to i8*, !dbg !246
  call void @free(i8* noundef %43) #5, !dbg !247
  call void @llvm.dbg.declare(metadata i32* %6, metadata !248, metadata !DIExpression()), !dbg !250
  store i32 0, i32* %6, align 4, !dbg !250
  br label %44, !dbg !251

44:                                               ; preds = %56, %40
  %45 = load i32, i32* %6, align 4, !dbg !252
  %46 = icmp slt i32 %45, 3, !dbg !254
  br i1 %46, label %47, label %59, !dbg !255

47:                                               ; preds = %44
  %48 = load i32, i32* %6, align 4, !dbg !256
  %49 = sext i32 %48 to i64, !dbg !256
  %50 = getelementptr inbounds [3 x i32], [3 x i32]* @data, i64 0, i64 %49, !dbg !256
  %51 = load i32, i32* %50, align 4, !dbg !256
  %52 = icmp eq i32 %51, 1, !dbg !256
  br i1 %52, label %53, label %54, !dbg !259

53:                                               ; preds = %47
  br label %55, !dbg !259

54:                                               ; preds = %47
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i64 0, i64 0), i32 noundef 41, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !256
  unreachable, !dbg !256

55:                                               ; preds = %53
  br label %56, !dbg !260

56:                                               ; preds = %55
  %57 = load i32, i32* %6, align 4, !dbg !261
  %58 = add nsw i32 %57, 1, !dbg !261
  store i32 %58, i32* %6, align 4, !dbg !261
  br label %44, !dbg !262, !llvm.loop !263

59:                                               ; preds = %44
  ret i32 0, !dbg !265
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!31, !32, !33, !34, !35, !36, !37}
!llvm.ident = !{!38}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "Head", scope: !2, file: !15, line: 19, type: !16, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !12, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "dglm.c", directory: "/home/ubuntu/Desktop/code/tianrui/Dat3M/benchmarks/lfds", checksumkind: CSK_MD5, checksum: "4ae6501ab5c2c592a30d5a52caaa9b80")
!4 = !{!5, !6, !9}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !7, line: 87, baseType: !8)
!7 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!8 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !10, line: 46, baseType: !11)
!10 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!11 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!12 = !{!13, !0, !26}
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(name: "Tail", scope: !2, file: !15, line: 18, type: !16, isLocal: false, isDefinition: true)
!15 = !DIFile(filename: "./dglm.h", directory: "/home/ubuntu/Desktop/code/tianrui/Dat3M/benchmarks/lfds", checksumkind: CSK_MD5, checksum: "c81f98eeee5e13a9ab95151e3734648b")
!16 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !17)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "Node", file: !15, line: 16, baseType: !19)
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Node", file: !15, line: 13, size: 128, elements: !20)
!20 = !{!21, !23}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "val", scope: !19, file: !15, line: 14, baseType: !22, size: 32)
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !19, file: !15, line: 15, baseType: !24, size: 64, offset: 64)
!24 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "data", scope: !2, file: !3, line: 8, type: !28, isLocal: false, isDefinition: true)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 96, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: 3)
!31 = !{i32 7, !"Dwarf Version", i32 5}
!32 = !{i32 2, !"Debug Info Version", i32 3}
!33 = !{i32 1, !"wchar_size", i32 4}
!34 = !{i32 7, !"PIC Level", i32 2}
!35 = !{i32 7, !"PIE Level", i32 2}
!36 = !{i32 7, !"uwtable", i32 1}
!37 = !{i32 7, !"frame-pointer", i32 2}
!38 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!39 = distinct !DISubprogram(name: "init", scope: !15, file: !15, line: 22, type: !40, scopeLine: 22, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!40 = !DISubroutineType(types: !41)
!41 = !{null}
!42 = !{}
!43 = !DILocalVariable(name: "node", scope: !39, file: !15, line: 23, type: !17)
!44 = !DILocation(line: 23, column: 8, scope: !39)
!45 = !DILocation(line: 23, column: 15, scope: !39)
!46 = !DILocation(line: 24, column: 15, scope: !39)
!47 = !DILocation(line: 24, column: 21, scope: !39)
!48 = !DILocation(line: 24, column: 2, scope: !39)
!49 = !DILocation(line: 25, column: 21, scope: !39)
!50 = !DILocation(line: 25, column: 2, scope: !39)
!51 = !DILocation(line: 26, column: 21, scope: !39)
!52 = !DILocation(line: 26, column: 2, scope: !39)
!53 = !DILocation(line: 27, column: 1, scope: !39)
!54 = distinct !DISubprogram(name: "enqueue", scope: !15, file: !15, line: 29, type: !55, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!55 = !DISubroutineType(types: !56)
!56 = !{null, !22}
!57 = !DILocalVariable(name: "value", arg: 1, scope: !54, file: !15, line: 29, type: !22)
!58 = !DILocation(line: 29, column: 18, scope: !54)
!59 = !DILocalVariable(name: "tail", scope: !54, file: !15, line: 30, type: !17)
!60 = !DILocation(line: 30, column: 8, scope: !54)
!61 = !DILocalVariable(name: "next", scope: !54, file: !15, line: 30, type: !17)
!62 = !DILocation(line: 30, column: 15, scope: !54)
!63 = !DILocalVariable(name: "node", scope: !54, file: !15, line: 30, type: !17)
!64 = !DILocation(line: 30, column: 22, scope: !54)
!65 = !DILocation(line: 32, column: 12, scope: !54)
!66 = !DILocation(line: 32, column: 10, scope: !54)
!67 = !DILocation(line: 33, column: 14, scope: !54)
!68 = !DILocation(line: 33, column: 2, scope: !54)
!69 = !DILocation(line: 33, column: 8, scope: !54)
!70 = !DILocation(line: 33, column: 12, scope: !54)
!71 = !DILocation(line: 34, column: 15, scope: !54)
!72 = !DILocation(line: 34, column: 21, scope: !54)
!73 = !DILocation(line: 34, column: 2, scope: !54)
!74 = !DILocation(line: 36, column: 2, scope: !54)
!75 = !DILocation(line: 37, column: 10, scope: !76)
!76 = distinct !DILexicalBlock(scope: !54, file: !15, line: 36, column: 12)
!77 = !DILocation(line: 37, column: 8, scope: !76)
!78 = !DILocation(line: 38, column: 9, scope: !79)
!79 = distinct !DILexicalBlock(scope: !80, file: !15, line: 38, column: 9)
!80 = distinct !DILexicalBlock(scope: !76, file: !15, line: 38, column: 9)
!81 = !DILocation(line: 38, column: 9, scope: !80)
!82 = !DILocation(line: 39, column: 32, scope: !76)
!83 = !DILocation(line: 39, column: 38, scope: !76)
!84 = !DILocation(line: 39, column: 10, scope: !76)
!85 = !DILocation(line: 39, column: 8, scope: !76)
!86 = !DILocation(line: 41, column: 13, scope: !87)
!87 = distinct !DILexicalBlock(scope: !76, file: !15, line: 41, column: 13)
!88 = !DILocation(line: 41, column: 21, scope: !87)
!89 = !DILocation(line: 41, column: 18, scope: !87)
!90 = !DILocation(line: 41, column: 13, scope: !76)
!91 = !DILocation(line: 42, column: 17, scope: !92)
!92 = distinct !DILexicalBlock(scope: !93, file: !15, line: 42, column: 17)
!93 = distinct !DILexicalBlock(scope: !87, file: !15, line: 41, column: 68)
!94 = !DILocation(line: 42, column: 22, scope: !92)
!95 = !DILocation(line: 42, column: 17, scope: !93)
!96 = !DILocation(line: 43, column: 9, scope: !97)
!97 = distinct !DILexicalBlock(scope: !98, file: !15, line: 43, column: 9)
!98 = distinct !DILexicalBlock(scope: !92, file: !15, line: 42, column: 31)
!99 = !DILocation(line: 43, column: 9, scope: !98)
!100 = !DILocation(line: 44, column: 9, scope: !101)
!101 = distinct !DILexicalBlock(scope: !97, file: !15, line: 43, column: 40)
!102 = !DILocation(line: 45, column: 6, scope: !101)
!103 = !DILocation(line: 47, column: 13, scope: !98)
!104 = !DILocation(line: 48, column: 5, scope: !105)
!105 = distinct !DILexicalBlock(scope: !92, file: !15, line: 47, column: 20)
!106 = !DILocation(line: 51, column: 9, scope: !93)
!107 = distinct !{!107, !74, !108}
!108 = !DILocation(line: 52, column: 2, scope: !54)
!109 = !DILocation(line: 53, column: 1, scope: !54)
!110 = distinct !DISubprogram(name: "dequeue", scope: !15, file: !15, line: 55, type: !111, scopeLine: 55, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!111 = !DISubroutineType(types: !112)
!112 = !{!22}
!113 = !DILocalVariable(name: "head", scope: !110, file: !15, line: 56, type: !17)
!114 = !DILocation(line: 56, column: 8, scope: !110)
!115 = !DILocalVariable(name: "next", scope: !110, file: !15, line: 56, type: !17)
!116 = !DILocation(line: 56, column: 15, scope: !110)
!117 = !DILocalVariable(name: "tail", scope: !110, file: !15, line: 56, type: !17)
!118 = !DILocation(line: 56, column: 22, scope: !110)
!119 = !DILocalVariable(name: "result", scope: !110, file: !15, line: 57, type: !22)
!120 = !DILocation(line: 57, column: 6, scope: !110)
!121 = !DILocation(line: 59, column: 2, scope: !110)
!122 = !DILocation(line: 60, column: 10, scope: !123)
!123 = distinct !DILexicalBlock(scope: !110, file: !15, line: 59, column: 12)
!124 = !DILocation(line: 60, column: 8, scope: !123)
!125 = !DILocation(line: 61, column: 9, scope: !126)
!126 = distinct !DILexicalBlock(scope: !127, file: !15, line: 61, column: 9)
!127 = distinct !DILexicalBlock(scope: !123, file: !15, line: 61, column: 9)
!128 = !DILocation(line: 61, column: 9, scope: !127)
!129 = !DILocation(line: 62, column: 32, scope: !123)
!130 = !DILocation(line: 62, column: 38, scope: !123)
!131 = !DILocation(line: 62, column: 10, scope: !123)
!132 = !DILocation(line: 62, column: 8, scope: !123)
!133 = !DILocation(line: 64, column: 7, scope: !134)
!134 = distinct !DILexicalBlock(scope: !123, file: !15, line: 64, column: 7)
!135 = !DILocation(line: 64, column: 15, scope: !134)
!136 = !DILocation(line: 64, column: 12, scope: !134)
!137 = !DILocation(line: 64, column: 7, scope: !123)
!138 = !DILocation(line: 65, column: 8, scope: !139)
!139 = distinct !DILexicalBlock(scope: !140, file: !15, line: 65, column: 8)
!140 = distinct !DILexicalBlock(scope: !134, file: !15, line: 64, column: 62)
!141 = !DILocation(line: 65, column: 13, scope: !139)
!142 = !DILocation(line: 65, column: 8, scope: !140)
!143 = !DILocation(line: 66, column: 12, scope: !144)
!144 = distinct !DILexicalBlock(scope: !139, file: !15, line: 65, column: 22)
!145 = !DILocation(line: 67, column: 5, scope: !144)
!146 = !DILocation(line: 70, column: 26, scope: !147)
!147 = distinct !DILexicalBlock(scope: !139, file: !15, line: 69, column: 11)
!148 = !DILocation(line: 70, column: 32, scope: !147)
!149 = !DILocation(line: 70, column: 24, scope: !147)
!150 = !DILocation(line: 71, column: 21, scope: !151)
!151 = distinct !DILexicalBlock(scope: !147, file: !15, line: 71, column: 21)
!152 = !DILocation(line: 71, column: 21, scope: !147)
!153 = !DILocation(line: 72, column: 28, scope: !154)
!154 = distinct !DILexicalBlock(scope: !151, file: !15, line: 71, column: 46)
!155 = !DILocation(line: 72, column: 26, scope: !154)
!156 = !DILocation(line: 73, column: 21, scope: !157)
!157 = distinct !DILexicalBlock(scope: !158, file: !15, line: 73, column: 21)
!158 = distinct !DILexicalBlock(scope: !154, file: !15, line: 73, column: 21)
!159 = !DILocation(line: 73, column: 21, scope: !158)
!160 = !DILocation(line: 74, column: 25, scope: !161)
!161 = distinct !DILexicalBlock(scope: !154, file: !15, line: 74, column: 25)
!162 = !DILocation(line: 74, column: 33, scope: !161)
!163 = !DILocation(line: 74, column: 30, scope: !161)
!164 = !DILocation(line: 74, column: 25, scope: !154)
!165 = !DILocation(line: 75, column: 25, scope: !166)
!166 = distinct !DILexicalBlock(scope: !161, file: !15, line: 74, column: 39)
!167 = !DILocation(line: 76, column: 21, scope: !166)
!168 = !DILocation(line: 77, column: 26, scope: !154)
!169 = !DILocation(line: 77, column: 21, scope: !154)
!170 = !DILocation(line: 78, column: 21, scope: !154)
!171 = !DILocation(line: 81, column: 3, scope: !140)
!172 = distinct !{!172, !121, !173}
!173 = !DILocation(line: 82, column: 2, scope: !110)
!174 = !DILocation(line: 84, column: 9, scope: !110)
!175 = !DILocation(line: 84, column: 2, scope: !110)
!176 = distinct !DISubprogram(name: "worker", scope: !3, file: !3, line: 10, type: !177, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!177 = !DISubroutineType(types: !178)
!178 = !{!5, !5}
!179 = !DILocalVariable(name: "arg", arg: 1, scope: !176, file: !3, line: 10, type: !5)
!180 = !DILocation(line: 10, column: 20, scope: !176)
!181 = !DILocalVariable(name: "index", scope: !176, file: !3, line: 13, type: !6)
!182 = !DILocation(line: 13, column: 14, scope: !176)
!183 = !DILocation(line: 13, column: 34, scope: !176)
!184 = !DILocation(line: 13, column: 23, scope: !176)
!185 = !DILocation(line: 15, column: 10, scope: !176)
!186 = !DILocation(line: 15, column: 2, scope: !176)
!187 = !DILocalVariable(name: "r", scope: !176, file: !3, line: 16, type: !22)
!188 = !DILocation(line: 16, column: 9, scope: !176)
!189 = !DILocation(line: 16, column: 13, scope: !176)
!190 = !DILocation(line: 18, column: 2, scope: !191)
!191 = distinct !DILexicalBlock(scope: !192, file: !3, line: 18, column: 2)
!192 = distinct !DILexicalBlock(scope: !176, file: !3, line: 18, column: 2)
!193 = !DILocation(line: 18, column: 2, scope: !192)
!194 = !DILocation(line: 19, column: 7, scope: !176)
!195 = !DILocation(line: 19, column: 2, scope: !176)
!196 = !DILocation(line: 19, column: 10, scope: !176)
!197 = !DILocation(line: 21, column: 2, scope: !176)
!198 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 24, type: !111, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!199 = !DILocalVariable(name: "t", scope: !198, file: !3, line: 26, type: !200)
!200 = !DICompositeType(tag: DW_TAG_array_type, baseType: !201, size: 192, elements: !29)
!201 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !202, line: 27, baseType: !11)
!202 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!203 = !DILocation(line: 26, column: 15, scope: !198)
!204 = !DILocation(line: 28, column: 5, scope: !198)
!205 = !DILocalVariable(name: "i", scope: !206, file: !3, line: 30, type: !22)
!206 = distinct !DILexicalBlock(scope: !198, file: !3, line: 30, column: 5)
!207 = !DILocation(line: 30, column: 14, scope: !206)
!208 = !DILocation(line: 30, column: 10, scope: !206)
!209 = !DILocation(line: 30, column: 21, scope: !210)
!210 = distinct !DILexicalBlock(scope: !206, file: !3, line: 30, column: 5)
!211 = !DILocation(line: 30, column: 23, scope: !210)
!212 = !DILocation(line: 30, column: 5, scope: !206)
!213 = !DILocation(line: 31, column: 27, scope: !210)
!214 = !DILocation(line: 31, column: 25, scope: !210)
!215 = !DILocation(line: 31, column: 58, scope: !210)
!216 = !DILocation(line: 31, column: 50, scope: !210)
!217 = !DILocation(line: 31, column: 42, scope: !210)
!218 = !DILocation(line: 31, column: 9, scope: !210)
!219 = !DILocation(line: 30, column: 36, scope: !210)
!220 = !DILocation(line: 30, column: 5, scope: !210)
!221 = distinct !{!221, !212, !222, !223}
!222 = !DILocation(line: 31, column: 59, scope: !206)
!223 = !{!"llvm.loop.mustprogress"}
!224 = !DILocalVariable(name: "i", scope: !225, file: !3, line: 33, type: !22)
!225 = distinct !DILexicalBlock(scope: !198, file: !3, line: 33, column: 5)
!226 = !DILocation(line: 33, column: 14, scope: !225)
!227 = !DILocation(line: 33, column: 10, scope: !225)
!228 = !DILocation(line: 33, column: 21, scope: !229)
!229 = distinct !DILexicalBlock(scope: !225, file: !3, line: 33, column: 5)
!230 = !DILocation(line: 33, column: 23, scope: !229)
!231 = !DILocation(line: 33, column: 5, scope: !225)
!232 = !DILocation(line: 34, column: 24, scope: !229)
!233 = !DILocation(line: 34, column: 22, scope: !229)
!234 = !DILocation(line: 34, column: 9, scope: !229)
!235 = !DILocation(line: 33, column: 36, scope: !229)
!236 = !DILocation(line: 33, column: 5, scope: !229)
!237 = distinct !{!237, !231, !238, !223}
!238 = !DILocation(line: 34, column: 29, scope: !225)
!239 = !DILocalVariable(name: "r", scope: !198, file: !3, line: 36, type: !22)
!240 = !DILocation(line: 36, column: 9, scope: !198)
!241 = !DILocation(line: 36, column: 13, scope: !198)
!242 = !DILocation(line: 37, column: 5, scope: !243)
!243 = distinct !DILexicalBlock(scope: !244, file: !3, line: 37, column: 5)
!244 = distinct !DILexicalBlock(scope: !198, file: !3, line: 37, column: 5)
!245 = !DILocation(line: 37, column: 5, scope: !244)
!246 = !DILocation(line: 38, column: 10, scope: !198)
!247 = !DILocation(line: 38, column: 5, scope: !198)
!248 = !DILocalVariable(name: "i", scope: !249, file: !3, line: 40, type: !22)
!249 = distinct !DILexicalBlock(scope: !198, file: !3, line: 40, column: 5)
!250 = !DILocation(line: 40, column: 14, scope: !249)
!251 = !DILocation(line: 40, column: 10, scope: !249)
!252 = !DILocation(line: 40, column: 21, scope: !253)
!253 = distinct !DILexicalBlock(scope: !249, file: !3, line: 40, column: 5)
!254 = !DILocation(line: 40, column: 23, scope: !253)
!255 = !DILocation(line: 40, column: 5, scope: !249)
!256 = !DILocation(line: 41, column: 9, scope: !257)
!257 = distinct !DILexicalBlock(scope: !258, file: !3, line: 41, column: 9)
!258 = distinct !DILexicalBlock(scope: !253, file: !3, line: 41, column: 9)
!259 = !DILocation(line: 41, column: 9, scope: !258)
!260 = !DILocation(line: 41, column: 9, scope: !253)
!261 = !DILocation(line: 40, column: 36, scope: !253)
!262 = !DILocation(line: 40, column: 5, scope: !253)
!263 = distinct !{!263, !255, !264, !223}
!264 = !DILocation(line: 41, column: 9, scope: !249)
!265 = !DILocation(line: 43, column: 5, scope: !198)
