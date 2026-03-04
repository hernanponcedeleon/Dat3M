; ModuleID = '/home/drc/git/Dat3M/benchmarks/lfds/chase-lev.c'
source_filename = "/home/drc/git/Dat3M/benchmarks/lfds/chase-lev.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Deque = type { i32, i32, [10 x i32] }
%union.pthread_attr_t = type { i64, [48 x i8] }

@deq = dso_local global %struct.Deque zeroinitializer, align 4, !dbg !0
@.str = private unnamed_addr constant [14 x i8] c"data == count\00", align 1
@.str.1 = private unnamed_addr constant [48 x i8] c"/home/drc/git/Dat3M/benchmarks/lfds/chase-lev.c\00", align 1
@__PRETTY_FUNCTION__.owner = private unnamed_addr constant [20 x i8] c"void *owner(void *)\00", align 1
@thiefs = dso_local global [4 x i64] zeroinitializer, align 16, !dbg !18
@.str.2 = private unnamed_addr constant [31 x i8] c"try_pop(&deq, NUM, &data) >= 0\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @try_push(%struct.Deque* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !47 {
  %4 = alloca i32, align 4
  %5 = alloca %struct.Deque*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  store %struct.Deque* %0, %struct.Deque** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.Deque** %5, metadata !52, metadata !DIExpression()), !dbg !53
  store i32 %1, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !54, metadata !DIExpression()), !dbg !55
  store i32 %2, i32* %7, align 4
  call void @llvm.dbg.declare(metadata i32* %7, metadata !56, metadata !DIExpression()), !dbg !57
  call void @llvm.dbg.declare(metadata i32* %8, metadata !58, metadata !DIExpression()), !dbg !59
  %13 = load %struct.Deque*, %struct.Deque** %5, align 8, !dbg !60
  %14 = getelementptr inbounds %struct.Deque, %struct.Deque* %13, i32 0, i32 0, !dbg !61
  %15 = load atomic i32, i32* %14 monotonic, align 4, !dbg !62
  store i32 %15, i32* %9, align 4, !dbg !62
  %16 = load i32, i32* %9, align 4, !dbg !62
  store i32 %16, i32* %8, align 4, !dbg !59
  call void @llvm.dbg.declare(metadata i32* %10, metadata !63, metadata !DIExpression()), !dbg !64
  %17 = load %struct.Deque*, %struct.Deque** %5, align 8, !dbg !65
  %18 = getelementptr inbounds %struct.Deque, %struct.Deque* %17, i32 0, i32 1, !dbg !66
  %19 = load atomic i32, i32* %18 acquire, align 4, !dbg !67
  store i32 %19, i32* %11, align 4, !dbg !67
  %20 = load i32, i32* %11, align 4, !dbg !67
  store i32 %20, i32* %10, align 4, !dbg !64
  %21 = load i32, i32* %8, align 4, !dbg !68
  %22 = load i32, i32* %10, align 4, !dbg !70
  %23 = sub nsw i32 %21, %22, !dbg !71
  %24 = load i32, i32* %6, align 4, !dbg !72
  %25 = icmp sge i32 %23, %24, !dbg !73
  br i1 %25, label %26, label %27, !dbg !74

26:                                               ; preds = %3
  store i32 -1, i32* %4, align 4, !dbg !75
  br label %41, !dbg !75

27:                                               ; preds = %3
  %28 = load i32, i32* %7, align 4, !dbg !77
  %29 = load %struct.Deque*, %struct.Deque** %5, align 8, !dbg !78
  %30 = getelementptr inbounds %struct.Deque, %struct.Deque* %29, i32 0, i32 2, !dbg !79
  %31 = load i32, i32* %8, align 4, !dbg !80
  %32 = load i32, i32* %6, align 4, !dbg !81
  %33 = srem i32 %31, %32, !dbg !82
  %34 = sext i32 %33 to i64, !dbg !78
  %35 = getelementptr inbounds [10 x i32], [10 x i32]* %30, i64 0, i64 %34, !dbg !78
  store i32 %28, i32* %35, align 4, !dbg !83
  %36 = load %struct.Deque*, %struct.Deque** %5, align 8, !dbg !84
  %37 = getelementptr inbounds %struct.Deque, %struct.Deque* %36, i32 0, i32 0, !dbg !85
  %38 = load i32, i32* %8, align 4, !dbg !86
  %39 = add nsw i32 %38, 1, !dbg !87
  store i32 %39, i32* %12, align 4, !dbg !88
  %40 = load i32, i32* %12, align 4, !dbg !88
  store atomic i32 %40, i32* %37 release, align 4, !dbg !88
  store i32 0, i32* %4, align 4, !dbg !89
  br label %41, !dbg !89

41:                                               ; preds = %27, %26
  %42 = load i32, i32* %4, align 4, !dbg !90
  ret i32 %42, !dbg !90
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @try_pop(%struct.Deque* noundef %0, i32 noundef %1, i32* noundef %2) #0 !dbg !91 {
  %4 = alloca i32, align 4
  %5 = alloca %struct.Deque*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i8, align 1
  %15 = alloca i32, align 4
  %16 = alloca i8, align 1
  %17 = alloca i32, align 4
  store %struct.Deque* %0, %struct.Deque** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.Deque** %5, metadata !95, metadata !DIExpression()), !dbg !96
  store i32 %1, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !97, metadata !DIExpression()), !dbg !98
  store i32* %2, i32** %7, align 8
  call void @llvm.dbg.declare(metadata i32** %7, metadata !99, metadata !DIExpression()), !dbg !100
  call void @llvm.dbg.declare(metadata i32* %8, metadata !101, metadata !DIExpression()), !dbg !102
  %18 = load %struct.Deque*, %struct.Deque** %5, align 8, !dbg !103
  %19 = getelementptr inbounds %struct.Deque, %struct.Deque* %18, i32 0, i32 0, !dbg !104
  %20 = load atomic i32, i32* %19 monotonic, align 4, !dbg !105
  store i32 %20, i32* %9, align 4, !dbg !105
  %21 = load i32, i32* %9, align 4, !dbg !105
  store i32 %21, i32* %8, align 4, !dbg !102
  %22 = load %struct.Deque*, %struct.Deque** %5, align 8, !dbg !106
  %23 = getelementptr inbounds %struct.Deque, %struct.Deque* %22, i32 0, i32 0, !dbg !107
  %24 = load i32, i32* %8, align 4, !dbg !108
  %25 = sub nsw i32 %24, 1, !dbg !109
  store i32 %25, i32* %10, align 4, !dbg !110
  %26 = load i32, i32* %10, align 4, !dbg !110
  store atomic i32 %26, i32* %23 monotonic, align 4, !dbg !110
  fence seq_cst, !dbg !111
  call void @llvm.dbg.declare(metadata i32* %11, metadata !112, metadata !DIExpression()), !dbg !113
  %27 = load %struct.Deque*, %struct.Deque** %5, align 8, !dbg !114
  %28 = getelementptr inbounds %struct.Deque, %struct.Deque* %27, i32 0, i32 1, !dbg !115
  %29 = load atomic i32, i32* %28 monotonic, align 4, !dbg !116
  store i32 %29, i32* %12, align 4, !dbg !116
  %30 = load i32, i32* %12, align 4, !dbg !116
  store i32 %30, i32* %11, align 4, !dbg !113
  %31 = load i32, i32* %8, align 4, !dbg !117
  %32 = load i32, i32* %11, align 4, !dbg !119
  %33 = sub nsw i32 %31, %32, !dbg !120
  %34 = icmp sle i32 %33, 0, !dbg !121
  br i1 %34, label %35, label %40, !dbg !122

35:                                               ; preds = %3
  %36 = load %struct.Deque*, %struct.Deque** %5, align 8, !dbg !123
  %37 = getelementptr inbounds %struct.Deque, %struct.Deque* %36, i32 0, i32 0, !dbg !125
  %38 = load i32, i32* %8, align 4, !dbg !126
  store i32 %38, i32* %13, align 4, !dbg !127
  %39 = load i32, i32* %13, align 4, !dbg !127
  store atomic i32 %39, i32* %37 monotonic, align 4, !dbg !127
  store i32 -1, i32* %4, align 4, !dbg !128
  br label %80, !dbg !128

40:                                               ; preds = %3
  %41 = load %struct.Deque*, %struct.Deque** %5, align 8, !dbg !129
  %42 = getelementptr inbounds %struct.Deque, %struct.Deque* %41, i32 0, i32 2, !dbg !130
  %43 = load i32, i32* %8, align 4, !dbg !131
  %44 = sub nsw i32 %43, 1, !dbg !132
  %45 = load i32, i32* %6, align 4, !dbg !133
  %46 = srem i32 %44, %45, !dbg !134
  %47 = sext i32 %46 to i64, !dbg !129
  %48 = getelementptr inbounds [10 x i32], [10 x i32]* %42, i64 0, i64 %47, !dbg !129
  %49 = load i32, i32* %48, align 4, !dbg !129
  %50 = load i32*, i32** %7, align 8, !dbg !135
  store i32 %49, i32* %50, align 4, !dbg !136
  %51 = load i32, i32* %8, align 4, !dbg !137
  %52 = load i32, i32* %11, align 4, !dbg !139
  %53 = sub nsw i32 %51, %52, !dbg !140
  %54 = icmp sgt i32 %53, 1, !dbg !141
  br i1 %54, label %55, label %56, !dbg !142

55:                                               ; preds = %40
  store i32 0, i32* %4, align 4, !dbg !143
  br label %80, !dbg !143

56:                                               ; preds = %40
  call void @llvm.dbg.declare(metadata i8* %14, metadata !145, metadata !DIExpression()), !dbg !147
  %57 = load %struct.Deque*, %struct.Deque** %5, align 8, !dbg !148
  %58 = getelementptr inbounds %struct.Deque, %struct.Deque* %57, i32 0, i32 1, !dbg !149
  %59 = load i32, i32* %11, align 4, !dbg !150
  %60 = add nsw i32 %59, 1, !dbg !151
  store i32 %60, i32* %15, align 4, !dbg !152
  %61 = load i32, i32* %11, align 4, !dbg !152
  %62 = load i32, i32* %15, align 4, !dbg !152
  %63 = cmpxchg i32* %58, i32 %61, i32 %62 monotonic monotonic, align 4, !dbg !152
  %64 = extractvalue { i32, i1 } %63, 0, !dbg !152
  %65 = extractvalue { i32, i1 } %63, 1, !dbg !152
  br i1 %65, label %67, label %66, !dbg !152

66:                                               ; preds = %56
  store i32 %64, i32* %11, align 4, !dbg !152
  br label %67, !dbg !152

67:                                               ; preds = %66, %56
  %68 = zext i1 %65 to i8, !dbg !152
  store i8 %68, i8* %16, align 1, !dbg !152
  %69 = load i8, i8* %16, align 1, !dbg !152
  %70 = trunc i8 %69 to i1, !dbg !152
  %71 = zext i1 %70 to i8, !dbg !147
  store i8 %71, i8* %14, align 1, !dbg !147
  %72 = load %struct.Deque*, %struct.Deque** %5, align 8, !dbg !153
  %73 = getelementptr inbounds %struct.Deque, %struct.Deque* %72, i32 0, i32 0, !dbg !154
  %74 = load i32, i32* %8, align 4, !dbg !155
  store i32 %74, i32* %17, align 4, !dbg !156
  %75 = load i32, i32* %17, align 4, !dbg !156
  store atomic i32 %75, i32* %73 monotonic, align 4, !dbg !156
  %76 = load i8, i8* %14, align 1, !dbg !157
  %77 = trunc i8 %76 to i1, !dbg !157
  %78 = zext i1 %77 to i64, !dbg !157
  %79 = select i1 %77, i32 0, i32 -2, !dbg !157
  store i32 %79, i32* %4, align 4, !dbg !158
  br label %80, !dbg !158

80:                                               ; preds = %67, %55, %35
  %81 = load i32, i32* %4, align 4, !dbg !159
  ret i32 %81, !dbg !159
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @try_steal(%struct.Deque* noundef %0, i32 noundef %1, i32* noundef %2) #0 !dbg !160 {
  %4 = alloca i32, align 4
  %5 = alloca %struct.Deque*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i8, align 1
  %13 = alloca i32, align 4
  %14 = alloca i8, align 1
  store %struct.Deque* %0, %struct.Deque** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.Deque** %5, metadata !161, metadata !DIExpression()), !dbg !162
  store i32 %1, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !163, metadata !DIExpression()), !dbg !164
  store i32* %2, i32** %7, align 8
  call void @llvm.dbg.declare(metadata i32** %7, metadata !165, metadata !DIExpression()), !dbg !166
  call void @llvm.dbg.declare(metadata i32* %8, metadata !167, metadata !DIExpression()), !dbg !168
  %15 = load %struct.Deque*, %struct.Deque** %5, align 8, !dbg !169
  %16 = getelementptr inbounds %struct.Deque, %struct.Deque* %15, i32 0, i32 1, !dbg !170
  %17 = load atomic i32, i32* %16 monotonic, align 4, !dbg !171
  store i32 %17, i32* %9, align 4, !dbg !171
  %18 = load i32, i32* %9, align 4, !dbg !171
  store i32 %18, i32* %8, align 4, !dbg !168
  fence seq_cst, !dbg !172
  call void @llvm.dbg.declare(metadata i32* %10, metadata !173, metadata !DIExpression()), !dbg !174
  %19 = load %struct.Deque*, %struct.Deque** %5, align 8, !dbg !175
  %20 = getelementptr inbounds %struct.Deque, %struct.Deque* %19, i32 0, i32 0, !dbg !176
  %21 = load atomic i32, i32* %20 monotonic, align 4, !dbg !177
  store i32 %21, i32* %11, align 4, !dbg !177
  %22 = load i32, i32* %11, align 4, !dbg !177
  store i32 %22, i32* %10, align 4, !dbg !174
  %23 = load i32, i32* %10, align 4, !dbg !178
  %24 = load i32, i32* %8, align 4, !dbg !180
  %25 = sub nsw i32 %23, %24, !dbg !181
  %26 = icmp sle i32 %25, 0, !dbg !182
  br i1 %26, label %27, label %28, !dbg !183

27:                                               ; preds = %3
  store i32 -1, i32* %4, align 4, !dbg !184
  br label %57, !dbg !184

28:                                               ; preds = %3
  %29 = load %struct.Deque*, %struct.Deque** %5, align 8, !dbg !186
  %30 = getelementptr inbounds %struct.Deque, %struct.Deque* %29, i32 0, i32 2, !dbg !187
  %31 = load i32, i32* %8, align 4, !dbg !188
  %32 = load i32, i32* %6, align 4, !dbg !189
  %33 = srem i32 %31, %32, !dbg !190
  %34 = sext i32 %33 to i64, !dbg !186
  %35 = getelementptr inbounds [10 x i32], [10 x i32]* %30, i64 0, i64 %34, !dbg !186
  %36 = load i32, i32* %35, align 4, !dbg !186
  %37 = load i32*, i32** %7, align 8, !dbg !191
  store i32 %36, i32* %37, align 4, !dbg !192
  call void @llvm.dbg.declare(metadata i8* %12, metadata !193, metadata !DIExpression()), !dbg !194
  %38 = load %struct.Deque*, %struct.Deque** %5, align 8, !dbg !195
  %39 = getelementptr inbounds %struct.Deque, %struct.Deque* %38, i32 0, i32 1, !dbg !196
  %40 = load i32, i32* %8, align 4, !dbg !197
  %41 = add nsw i32 %40, 1, !dbg !198
  store i32 %41, i32* %13, align 4, !dbg !199
  %42 = load i32, i32* %8, align 4, !dbg !199
  %43 = load i32, i32* %13, align 4, !dbg !199
  %44 = cmpxchg i32* %39, i32 %42, i32 %43 monotonic monotonic, align 4, !dbg !199
  %45 = extractvalue { i32, i1 } %44, 0, !dbg !199
  %46 = extractvalue { i32, i1 } %44, 1, !dbg !199
  br i1 %46, label %48, label %47, !dbg !199

47:                                               ; preds = %28
  store i32 %45, i32* %8, align 4, !dbg !199
  br label %48, !dbg !199

48:                                               ; preds = %47, %28
  %49 = zext i1 %46 to i8, !dbg !199
  store i8 %49, i8* %14, align 1, !dbg !199
  %50 = load i8, i8* %14, align 1, !dbg !199
  %51 = trunc i8 %50 to i1, !dbg !199
  %52 = zext i1 %51 to i8, !dbg !194
  store i8 %52, i8* %12, align 1, !dbg !194
  %53 = load i8, i8* %12, align 1, !dbg !200
  %54 = trunc i8 %53 to i1, !dbg !200
  %55 = zext i1 %54 to i64, !dbg !200
  %56 = select i1 %54, i32 0, i32 -2, !dbg !200
  store i32 %56, i32* %4, align 4, !dbg !201
  br label %57, !dbg !201

57:                                               ; preds = %48, %27
  %58 = load i32, i32* %4, align 4, !dbg !202
  ret i32 %58, !dbg !202
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thief(i8* noundef %0) #0 !dbg !203 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !206, metadata !DIExpression()), !dbg !207
  call void @llvm.dbg.declare(metadata i32* %3, metadata !208, metadata !DIExpression()), !dbg !209
  %4 = call i32 @try_steal(%struct.Deque* noundef @deq, i32 noundef 10, i32* noundef %3), !dbg !210
  ret i8* null, !dbg !211
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @owner(i8* noundef %0) #0 !dbg !212 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !213, metadata !DIExpression()), !dbg !214
  call void @llvm.dbg.declare(metadata i32* %3, metadata !215, metadata !DIExpression()), !dbg !216
  store i32 0, i32* %3, align 4, !dbg !216
  call void @llvm.dbg.declare(metadata i32* %4, metadata !217, metadata !DIExpression()), !dbg !218
  %8 = load i32, i32* %3, align 4, !dbg !219
  %9 = add nsw i32 %8, 1, !dbg !219
  store i32 %9, i32* %3, align 4, !dbg !219
  %10 = load i32, i32* %3, align 4, !dbg !220
  %11 = call i32 @try_push(%struct.Deque* noundef @deq, i32 noundef 10, i32 noundef %10), !dbg !221
  call void @llvm.dbg.declare(metadata i64* %5, metadata !222, metadata !DIExpression()), !dbg !223
  %12 = call i32 @pthread_create(i64* noundef %5, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thief, i8* noundef null) #4, !dbg !224
  %13 = call i32 @try_pop(%struct.Deque* noundef @deq, i32 noundef 10, i32* noundef %4), !dbg !225
  %14 = icmp ne i32 %13, -1, !dbg !227
  br i1 %14, label %15, label %22, !dbg !228

15:                                               ; preds = %1
  %16 = load i32, i32* %4, align 4, !dbg !229
  %17 = load i32, i32* %3, align 4, !dbg !229
  %18 = icmp eq i32 %16, %17, !dbg !229
  br i1 %18, label %19, label %20, !dbg !232

19:                                               ; preds = %15
  br label %21, !dbg !232

20:                                               ; preds = %15
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.1, i64 0, i64 0), i32 noundef 37, i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @__PRETTY_FUNCTION__.owner, i64 0, i64 0)) #5, !dbg !229
  unreachable, !dbg !229

21:                                               ; preds = %19
  br label %22, !dbg !233

22:                                               ; preds = %21, %1
  call void @llvm.dbg.declare(metadata i32* %6, metadata !234, metadata !DIExpression()), !dbg !236
  store i32 0, i32* %6, align 4, !dbg !236
  br label %23, !dbg !237

23:                                               ; preds = %29, %22
  %24 = load i32, i32* %6, align 4, !dbg !238
  %25 = icmp sle i32 %24, 4, !dbg !240
  br i1 %25, label %26, label %32, !dbg !241

26:                                               ; preds = %23
  %27 = load i32, i32* %3, align 4, !dbg !242
  %28 = call i32 @try_push(%struct.Deque* noundef @deq, i32 noundef 10, i32 noundef %27), !dbg !243
  br label %29, !dbg !243

29:                                               ; preds = %26
  %30 = load i32, i32* %6, align 4, !dbg !244
  %31 = add nsw i32 %30, 1, !dbg !244
  store i32 %31, i32* %6, align 4, !dbg !244
  br label %23, !dbg !245, !llvm.loop !246

32:                                               ; preds = %23
  call void @llvm.dbg.declare(metadata i32* %7, metadata !249, metadata !DIExpression()), !dbg !251
  store i32 0, i32* %7, align 4, !dbg !251
  br label %33, !dbg !252

33:                                               ; preds = %41, %32
  %34 = load i32, i32* %7, align 4, !dbg !253
  %35 = icmp slt i32 %34, 4, !dbg !255
  br i1 %35, label %36, label %44, !dbg !256

36:                                               ; preds = %33
  %37 = load i32, i32* %7, align 4, !dbg !257
  %38 = sext i32 %37 to i64, !dbg !258
  %39 = getelementptr inbounds [4 x i64], [4 x i64]* @thiefs, i64 0, i64 %38, !dbg !258
  %40 = call i32 @pthread_create(i64* noundef %39, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thief, i8* noundef null) #4, !dbg !259
  br label %41, !dbg !259

41:                                               ; preds = %36
  %42 = load i32, i32* %7, align 4, !dbg !260
  %43 = add nsw i32 %42, 1, !dbg !260
  store i32 %43, i32* %7, align 4, !dbg !260
  br label %33, !dbg !261, !llvm.loop !262

44:                                               ; preds = %33
  %45 = call i32 @try_pop(%struct.Deque* noundef @deq, i32 noundef 10, i32* noundef %4), !dbg !264
  %46 = icmp sge i32 %45, 0, !dbg !264
  br i1 %46, label %47, label %48, !dbg !267

47:                                               ; preds = %44
  br label %49, !dbg !267

48:                                               ; preds = %44
  call void @__assert_fail(i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.1, i64 0, i64 0), i32 noundef 46, i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @__PRETTY_FUNCTION__.owner, i64 0, i64 0)) #5, !dbg !264
  unreachable, !dbg !264

49:                                               ; preds = %47
  ret i8* null, !dbg !268
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !269 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i64* %2, metadata !272, metadata !DIExpression()), !dbg !273
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @owner, i8* noundef null) #4, !dbg !274
  ret i32 0, !dbg !275
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!39, !40, !41, !42, !43, !44, !45}
!llvm.ident = !{!46}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "deq", scope: !2, file: !20, line: 13, type: !27, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/Dat3M/benchmarks/lfds/chase-lev.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "75531000f33bd4ce30dd74f4f9de0c80")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 56, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "de5d66a1ef2f5448cc1919ff39db92bc")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !{!0, !18}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "thiefs", scope: !2, file: !20, line: 14, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/lfds/chase-lev.c", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "75531000f33bd4ce30dd74f4f9de0c80")
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 256, elements: !25)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !23, line: 27, baseType: !24)
!23 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!24 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!25 = !{!26}
!26 = !DISubrange(count: 4)
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Deque", file: !28, line: 8, size: 384, elements: !29)
!28 = !DIFile(filename: "benchmarks/lfds/chase-lev.h", directory: "/home/drc/git/Dat3M", checksumkind: CSK_MD5, checksum: "33b78c7cd214df37c2bba4bcdd5cab37")
!29 = !{!30, !34, !35}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "bottom", scope: !27, file: !28, line: 9, baseType: !31, size: 32)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !32)
!32 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !33)
!33 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "top", scope: !27, file: !28, line: 10, baseType: !31, size: 32, offset: 32)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "buffer", scope: !27, file: !28, line: 11, baseType: !36, size: 320, offset: 64)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 320, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: 10)
!39 = !{i32 7, !"Dwarf Version", i32 5}
!40 = !{i32 2, !"Debug Info Version", i32 3}
!41 = !{i32 1, !"wchar_size", i32 4}
!42 = !{i32 7, !"PIC Level", i32 2}
!43 = !{i32 7, !"PIE Level", i32 2}
!44 = !{i32 7, !"uwtable", i32 1}
!45 = !{i32 7, !"frame-pointer", i32 2}
!46 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!47 = distinct !DISubprogram(name: "try_push", scope: !28, file: !28, line: 16, type: !48, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!48 = !DISubroutineType(types: !49)
!49 = !{!33, !50, !33, !33}
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!51 = !{}
!52 = !DILocalVariable(name: "deq", arg: 1, scope: !47, file: !28, line: 16, type: !50)
!53 = !DILocation(line: 16, column: 28, scope: !47)
!54 = !DILocalVariable(name: "N", arg: 2, scope: !47, file: !28, line: 16, type: !33)
!55 = !DILocation(line: 16, column: 37, scope: !47)
!56 = !DILocalVariable(name: "data", arg: 3, scope: !47, file: !28, line: 16, type: !33)
!57 = !DILocation(line: 16, column: 44, scope: !47)
!58 = !DILocalVariable(name: "b", scope: !47, file: !28, line: 18, type: !33)
!59 = !DILocation(line: 18, column: 9, scope: !47)
!60 = !DILocation(line: 18, column: 35, scope: !47)
!61 = !DILocation(line: 18, column: 40, scope: !47)
!62 = !DILocation(line: 18, column: 13, scope: !47)
!63 = !DILocalVariable(name: "t", scope: !47, file: !28, line: 19, type: !33)
!64 = !DILocation(line: 19, column: 9, scope: !47)
!65 = !DILocation(line: 19, column: 35, scope: !47)
!66 = !DILocation(line: 19, column: 40, scope: !47)
!67 = !DILocation(line: 19, column: 13, scope: !47)
!68 = !DILocation(line: 21, column: 10, scope: !69)
!69 = distinct !DILexicalBlock(scope: !47, file: !28, line: 21, column: 9)
!70 = !DILocation(line: 21, column: 14, scope: !69)
!71 = !DILocation(line: 21, column: 12, scope: !69)
!72 = !DILocation(line: 21, column: 20, scope: !69)
!73 = !DILocation(line: 21, column: 17, scope: !69)
!74 = !DILocation(line: 21, column: 9, scope: !47)
!75 = !DILocation(line: 22, column: 9, scope: !76)
!76 = distinct !DILexicalBlock(scope: !69, file: !28, line: 21, column: 23)
!77 = !DILocation(line: 25, column: 26, scope: !47)
!78 = !DILocation(line: 25, column: 5, scope: !47)
!79 = !DILocation(line: 25, column: 10, scope: !47)
!80 = !DILocation(line: 25, column: 17, scope: !47)
!81 = !DILocation(line: 25, column: 21, scope: !47)
!82 = !DILocation(line: 25, column: 19, scope: !47)
!83 = !DILocation(line: 25, column: 24, scope: !47)
!84 = !DILocation(line: 26, column: 28, scope: !47)
!85 = !DILocation(line: 26, column: 33, scope: !47)
!86 = !DILocation(line: 26, column: 41, scope: !47)
!87 = !DILocation(line: 26, column: 43, scope: !47)
!88 = !DILocation(line: 26, column: 5, scope: !47)
!89 = !DILocation(line: 27, column: 5, scope: !47)
!90 = !DILocation(line: 28, column: 1, scope: !47)
!91 = distinct !DISubprogram(name: "try_pop", scope: !28, file: !28, line: 30, type: !92, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!92 = !DISubroutineType(types: !93)
!93 = !{!33, !50, !33, !94}
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!95 = !DILocalVariable(name: "deq", arg: 1, scope: !91, file: !28, line: 30, type: !50)
!96 = !DILocation(line: 30, column: 27, scope: !91)
!97 = !DILocalVariable(name: "N", arg: 2, scope: !91, file: !28, line: 30, type: !33)
!98 = !DILocation(line: 30, column: 36, scope: !91)
!99 = !DILocalVariable(name: "data", arg: 3, scope: !91, file: !28, line: 30, type: !94)
!100 = !DILocation(line: 30, column: 44, scope: !91)
!101 = !DILocalVariable(name: "b", scope: !91, file: !28, line: 32, type: !33)
!102 = !DILocation(line: 32, column: 9, scope: !91)
!103 = !DILocation(line: 32, column: 35, scope: !91)
!104 = !DILocation(line: 32, column: 40, scope: !91)
!105 = !DILocation(line: 32, column: 13, scope: !91)
!106 = !DILocation(line: 33, column: 28, scope: !91)
!107 = !DILocation(line: 33, column: 33, scope: !91)
!108 = !DILocation(line: 33, column: 41, scope: !91)
!109 = !DILocation(line: 33, column: 43, scope: !91)
!110 = !DILocation(line: 33, column: 5, scope: !91)
!111 = !DILocation(line: 35, column: 5, scope: !91)
!112 = !DILocalVariable(name: "t", scope: !91, file: !28, line: 37, type: !33)
!113 = !DILocation(line: 37, column: 9, scope: !91)
!114 = !DILocation(line: 37, column: 35, scope: !91)
!115 = !DILocation(line: 37, column: 40, scope: !91)
!116 = !DILocation(line: 37, column: 13, scope: !91)
!117 = !DILocation(line: 39, column: 10, scope: !118)
!118 = distinct !DILexicalBlock(scope: !91, file: !28, line: 39, column: 9)
!119 = !DILocation(line: 39, column: 14, scope: !118)
!120 = !DILocation(line: 39, column: 12, scope: !118)
!121 = !DILocation(line: 39, column: 17, scope: !118)
!122 = !DILocation(line: 39, column: 9, scope: !91)
!123 = !DILocation(line: 40, column: 32, scope: !124)
!124 = distinct !DILexicalBlock(scope: !118, file: !28, line: 39, column: 23)
!125 = !DILocation(line: 40, column: 37, scope: !124)
!126 = !DILocation(line: 40, column: 45, scope: !124)
!127 = !DILocation(line: 40, column: 9, scope: !124)
!128 = !DILocation(line: 41, column: 9, scope: !124)
!129 = !DILocation(line: 44, column: 13, scope: !91)
!130 = !DILocation(line: 44, column: 18, scope: !91)
!131 = !DILocation(line: 44, column: 26, scope: !91)
!132 = !DILocation(line: 44, column: 28, scope: !91)
!133 = !DILocation(line: 44, column: 35, scope: !91)
!134 = !DILocation(line: 44, column: 33, scope: !91)
!135 = !DILocation(line: 44, column: 6, scope: !91)
!136 = !DILocation(line: 44, column: 11, scope: !91)
!137 = !DILocation(line: 46, column: 10, scope: !138)
!138 = distinct !DILexicalBlock(scope: !91, file: !28, line: 46, column: 9)
!139 = !DILocation(line: 46, column: 14, scope: !138)
!140 = !DILocation(line: 46, column: 12, scope: !138)
!141 = !DILocation(line: 46, column: 17, scope: !138)
!142 = !DILocation(line: 46, column: 9, scope: !91)
!143 = !DILocation(line: 47, column: 9, scope: !144)
!144 = distinct !DILexicalBlock(scope: !138, file: !28, line: 46, column: 22)
!145 = !DILocalVariable(name: "is_successful", scope: !91, file: !28, line: 51, type: !146)
!146 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!147 = !DILocation(line: 51, column: 10, scope: !91)
!148 = !DILocation(line: 51, column: 67, scope: !91)
!149 = !DILocation(line: 51, column: 72, scope: !91)
!150 = !DILocation(line: 51, column: 81, scope: !91)
!151 = !DILocation(line: 51, column: 83, scope: !91)
!152 = !DILocation(line: 51, column: 26, scope: !91)
!153 = !DILocation(line: 54, column: 28, scope: !91)
!154 = !DILocation(line: 54, column: 33, scope: !91)
!155 = !DILocation(line: 54, column: 41, scope: !91)
!156 = !DILocation(line: 54, column: 5, scope: !91)
!157 = !DILocation(line: 55, column: 13, scope: !91)
!158 = !DILocation(line: 55, column: 5, scope: !91)
!159 = !DILocation(line: 56, column: 1, scope: !91)
!160 = distinct !DISubprogram(name: "try_steal", scope: !28, file: !28, line: 58, type: !92, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!161 = !DILocalVariable(name: "deq", arg: 1, scope: !160, file: !28, line: 58, type: !50)
!162 = !DILocation(line: 58, column: 29, scope: !160)
!163 = !DILocalVariable(name: "N", arg: 2, scope: !160, file: !28, line: 58, type: !33)
!164 = !DILocation(line: 58, column: 38, scope: !160)
!165 = !DILocalVariable(name: "data", arg: 3, scope: !160, file: !28, line: 58, type: !94)
!166 = !DILocation(line: 58, column: 46, scope: !160)
!167 = !DILocalVariable(name: "t", scope: !160, file: !28, line: 60, type: !33)
!168 = !DILocation(line: 60, column: 9, scope: !160)
!169 = !DILocation(line: 60, column: 35, scope: !160)
!170 = !DILocation(line: 60, column: 40, scope: !160)
!171 = !DILocation(line: 60, column: 13, scope: !160)
!172 = !DILocation(line: 61, column: 5, scope: !160)
!173 = !DILocalVariable(name: "b", scope: !160, file: !28, line: 62, type: !33)
!174 = !DILocation(line: 62, column: 9, scope: !160)
!175 = !DILocation(line: 62, column: 35, scope: !160)
!176 = !DILocation(line: 62, column: 40, scope: !160)
!177 = !DILocation(line: 62, column: 13, scope: !160)
!178 = !DILocation(line: 64, column: 10, scope: !179)
!179 = distinct !DILexicalBlock(scope: !160, file: !28, line: 64, column: 9)
!180 = !DILocation(line: 64, column: 14, scope: !179)
!181 = !DILocation(line: 64, column: 12, scope: !179)
!182 = !DILocation(line: 64, column: 17, scope: !179)
!183 = !DILocation(line: 64, column: 9, scope: !160)
!184 = !DILocation(line: 65, column: 9, scope: !185)
!185 = distinct !DILexicalBlock(scope: !179, file: !28, line: 64, column: 23)
!186 = !DILocation(line: 68, column: 13, scope: !160)
!187 = !DILocation(line: 68, column: 18, scope: !160)
!188 = !DILocation(line: 68, column: 25, scope: !160)
!189 = !DILocation(line: 68, column: 29, scope: !160)
!190 = !DILocation(line: 68, column: 27, scope: !160)
!191 = !DILocation(line: 68, column: 6, scope: !160)
!192 = !DILocation(line: 68, column: 11, scope: !160)
!193 = !DILocalVariable(name: "is_successful", scope: !160, file: !28, line: 70, type: !146)
!194 = !DILocation(line: 70, column: 10, scope: !160)
!195 = !DILocation(line: 70, column: 67, scope: !160)
!196 = !DILocation(line: 70, column: 72, scope: !160)
!197 = !DILocation(line: 70, column: 81, scope: !160)
!198 = !DILocation(line: 70, column: 83, scope: !160)
!199 = !DILocation(line: 70, column: 26, scope: !160)
!200 = !DILocation(line: 73, column: 13, scope: !160)
!201 = !DILocation(line: 73, column: 5, scope: !160)
!202 = !DILocation(line: 74, column: 1, scope: !160)
!203 = distinct !DISubprogram(name: "thief", scope: !20, file: !20, line: 16, type: !204, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!204 = !DISubroutineType(types: !205)
!205 = !{!16, !16}
!206 = !DILocalVariable(name: "unused", arg: 1, scope: !203, file: !20, line: 16, type: !16)
!207 = !DILocation(line: 16, column: 19, scope: !203)
!208 = !DILocalVariable(name: "data", scope: !203, file: !20, line: 18, type: !33)
!209 = !DILocation(line: 18, column: 9, scope: !203)
!210 = !DILocation(line: 19, column: 5, scope: !203)
!211 = !DILocation(line: 20, column: 5, scope: !203)
!212 = distinct !DISubprogram(name: "owner", scope: !20, file: !20, line: 23, type: !204, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!213 = !DILocalVariable(name: "unused", arg: 1, scope: !212, file: !20, line: 23, type: !16)
!214 = !DILocation(line: 23, column: 19, scope: !212)
!215 = !DILocalVariable(name: "count", scope: !212, file: !20, line: 25, type: !33)
!216 = !DILocation(line: 25, column: 9, scope: !212)
!217 = !DILocalVariable(name: "data", scope: !212, file: !20, line: 26, type: !33)
!218 = !DILocation(line: 26, column: 9, scope: !212)
!219 = !DILocation(line: 28, column: 10, scope: !212)
!220 = !DILocation(line: 29, column: 25, scope: !212)
!221 = !DILocation(line: 29, column: 5, scope: !212)
!222 = !DILocalVariable(name: "t", scope: !212, file: !20, line: 32, type: !22)
!223 = !DILocation(line: 32, column: 15, scope: !212)
!224 = !DILocation(line: 33, column: 5, scope: !212)
!225 = !DILocation(line: 36, column: 9, scope: !226)
!226 = distinct !DILexicalBlock(scope: !212, file: !20, line: 36, column: 9)
!227 = !DILocation(line: 36, column: 35, scope: !226)
!228 = !DILocation(line: 36, column: 9, scope: !212)
!229 = !DILocation(line: 37, column: 9, scope: !230)
!230 = distinct !DILexicalBlock(scope: !231, file: !20, line: 37, column: 9)
!231 = distinct !DILexicalBlock(scope: !226, file: !20, line: 37, column: 9)
!232 = !DILocation(line: 37, column: 9, scope: !231)
!233 = !DILocation(line: 37, column: 9, scope: !226)
!234 = !DILocalVariable(name: "i", scope: !235, file: !20, line: 39, type: !33)
!235 = distinct !DILexicalBlock(scope: !212, file: !20, line: 39, column: 5)
!236 = !DILocation(line: 39, column: 14, scope: !235)
!237 = !DILocation(line: 39, column: 10, scope: !235)
!238 = !DILocation(line: 39, column: 21, scope: !239)
!239 = distinct !DILexicalBlock(scope: !235, file: !20, line: 39, column: 5)
!240 = !DILocation(line: 39, column: 23, scope: !239)
!241 = !DILocation(line: 39, column: 5, scope: !235)
!242 = !DILocation(line: 40, column: 29, scope: !239)
!243 = !DILocation(line: 40, column: 9, scope: !239)
!244 = !DILocation(line: 39, column: 35, scope: !239)
!245 = !DILocation(line: 39, column: 5, scope: !239)
!246 = distinct !{!246, !241, !247, !248}
!247 = !DILocation(line: 40, column: 34, scope: !235)
!248 = !{!"llvm.loop.mustprogress"}
!249 = !DILocalVariable(name: "i", scope: !250, file: !20, line: 42, type: !33)
!250 = distinct !DILexicalBlock(scope: !212, file: !20, line: 42, column: 5)
!251 = !DILocation(line: 42, column: 14, scope: !250)
!252 = !DILocation(line: 42, column: 10, scope: !250)
!253 = !DILocation(line: 42, column: 21, scope: !254)
!254 = distinct !DILexicalBlock(scope: !250, file: !20, line: 42, column: 5)
!255 = !DILocation(line: 42, column: 23, scope: !254)
!256 = !DILocation(line: 42, column: 5, scope: !250)
!257 = !DILocation(line: 43, column: 32, scope: !254)
!258 = !DILocation(line: 43, column: 25, scope: !254)
!259 = !DILocation(line: 43, column: 9, scope: !254)
!260 = !DILocation(line: 42, column: 34, scope: !254)
!261 = !DILocation(line: 42, column: 5, scope: !254)
!262 = distinct !{!262, !256, !263, !248}
!263 = !DILocation(line: 43, column: 53, scope: !250)
!264 = !DILocation(line: 46, column: 5, scope: !265)
!265 = distinct !DILexicalBlock(scope: !266, file: !20, line: 46, column: 5)
!266 = distinct !DILexicalBlock(scope: !212, file: !20, line: 46, column: 5)
!267 = !DILocation(line: 46, column: 5, scope: !266)
!268 = !DILocation(line: 48, column: 5, scope: !212)
!269 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 51, type: !270, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!270 = !DISubroutineType(types: !271)
!271 = !{!33}
!272 = !DILocalVariable(name: "t0", scope: !269, file: !20, line: 53, type: !22)
!273 = !DILocation(line: 53, column: 12, scope: !269)
!274 = !DILocation(line: 55, column: 2, scope: !269)
!275 = !DILocation(line: 56, column: 5, scope: !269)
