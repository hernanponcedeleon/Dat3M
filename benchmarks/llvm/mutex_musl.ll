; ModuleID = '/home/ponce/git/Dat3M/benchmarks/locks/mutex_musl.c'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/mutex_musl.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.mutex_t = type { i32, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@mutex = dso_local global %struct.mutex_t zeroinitializer, align 4, !dbg !25
@shared = dso_local global i32 0, align 4, !dbg !21
@.str = private unnamed_addr constant [11 x i8] c"r == index\00", align 1
@.str.1 = private unnamed_addr constant [52 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/mutex_musl.c\00", align 1
@__PRETTY_FUNCTION__.thread_n = private unnamed_addr constant [23 x i8] c"void *thread_n(void *)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@sig = internal global i32 0, align 4, !dbg !35

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @thread_n(i8* noundef %0) #0 !dbg !46 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !50, metadata !DIExpression()), !dbg !51
  call void @llvm.dbg.declare(metadata i64* %3, metadata !52, metadata !DIExpression()), !dbg !53
  %5 = load i8*, i8** %2, align 8, !dbg !54
  %6 = ptrtoint i8* %5 to i64, !dbg !55
  store i64 %6, i64* %3, align 8, !dbg !53
  call void @mutex_lock(%struct.mutex_t* noundef @mutex), !dbg !56
  %7 = load i64, i64* %3, align 8, !dbg !57
  %8 = trunc i64 %7 to i32, !dbg !57
  store i32 %8, i32* @shared, align 4, !dbg !58
  call void @llvm.dbg.declare(metadata i32* %4, metadata !59, metadata !DIExpression()), !dbg !60
  %9 = load i32, i32* @shared, align 4, !dbg !61
  store i32 %9, i32* %4, align 4, !dbg !60
  %10 = load i32, i32* %4, align 4, !dbg !62
  %11 = sext i32 %10 to i64, !dbg !62
  %12 = load i64, i64* %3, align 8, !dbg !62
  %13 = icmp eq i64 %11, %12, !dbg !62
  br i1 %13, label %14, label %15, !dbg !65

14:                                               ; preds = %1
  br label %16, !dbg !65

15:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.1, i64 0, i64 0), i32 noundef 20, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.thread_n, i64 0, i64 0)) #5, !dbg !62
  unreachable, !dbg !62

16:                                               ; preds = %14
  %17 = load i32, i32* @sum, align 4, !dbg !66
  %18 = add nsw i32 %17, 1, !dbg !66
  store i32 %18, i32* @sum, align 4, !dbg !66
  call void @mutex_unlock(%struct.mutex_t* noundef @mutex), !dbg !67
  ret i8* null, !dbg !68
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @mutex_lock(%struct.mutex_t* noundef %0) #0 !dbg !69 {
  %2 = alloca %struct.mutex_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i8, align 1
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store %struct.mutex_t* %0, %struct.mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.mutex_t** %2, metadata !73, metadata !DIExpression()), !dbg !74
  %10 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8, !dbg !75
  %11 = call i32 @mutex_lock_fastpath(%struct.mutex_t* noundef %10), !dbg !77
  %12 = icmp ne i32 %11, 0, !dbg !77
  br i1 %12, label %13, label %14, !dbg !78

13:                                               ; preds = %1
  br label %46, !dbg !79

14:                                               ; preds = %1
  br label %15, !dbg !80

15:                                               ; preds = %40, %14
  %16 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8, !dbg !81
  %17 = call i32 @mutex_lock_slowpath_check(%struct.mutex_t* noundef %16), !dbg !82
  %18 = icmp eq i32 %17, 0, !dbg !83
  br i1 %18, label %19, label %46, !dbg !80

19:                                               ; preds = %15
  %20 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8, !dbg !84
  %21 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %20, i32 0, i32 1, !dbg !86
  store i32 1, i32* %3, align 4, !dbg !87
  %22 = load i32, i32* %3, align 4, !dbg !87
  %23 = atomicrmw add i32* %21, i32 %22 monotonic, align 4, !dbg !87
  store i32 %23, i32* %4, align 4, !dbg !87
  %24 = load i32, i32* %4, align 4, !dbg !87
  call void @llvm.dbg.declare(metadata i32* %5, metadata !88, metadata !DIExpression()), !dbg !89
  store i32 1, i32* %5, align 4, !dbg !89
  %25 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8, !dbg !90
  %26 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %25, i32 0, i32 0, !dbg !92
  store i32 2, i32* %6, align 4, !dbg !93
  %27 = load i32, i32* %5, align 4, !dbg !93
  %28 = load i32, i32* %6, align 4, !dbg !93
  %29 = cmpxchg i32* %26, i32 %27, i32 %28 monotonic monotonic, align 4, !dbg !93
  %30 = extractvalue { i32, i1 } %29, 0, !dbg !93
  %31 = extractvalue { i32, i1 } %29, 1, !dbg !93
  br i1 %31, label %33, label %32, !dbg !93

32:                                               ; preds = %19
  store i32 %30, i32* %5, align 4, !dbg !93
  br label %33, !dbg !93

33:                                               ; preds = %32, %19
  %34 = zext i1 %31 to i8, !dbg !93
  store i8 %34, i8* %7, align 1, !dbg !93
  %35 = load i8, i8* %7, align 1, !dbg !93
  %36 = trunc i8 %35 to i1, !dbg !93
  br i1 %36, label %40, label %37, !dbg !94

37:                                               ; preds = %33
  %38 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8, !dbg !95
  %39 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %38, i32 0, i32 0, !dbg !96
  call void @__futex_wait(i32* noundef %39, i32 noundef 2), !dbg !97
  br label %40, !dbg !97

40:                                               ; preds = %37, %33
  %41 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8, !dbg !98
  %42 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %41, i32 0, i32 1, !dbg !99
  store i32 1, i32* %8, align 4, !dbg !100
  %43 = load i32, i32* %8, align 4, !dbg !100
  %44 = atomicrmw sub i32* %42, i32 %43 monotonic, align 4, !dbg !100
  store i32 %44, i32* %9, align 4, !dbg !100
  %45 = load i32, i32* %9, align 4, !dbg !100
  br label %15, !dbg !80, !llvm.loop !101

46:                                               ; preds = %13, %15
  ret void, !dbg !104
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @mutex_unlock(%struct.mutex_t* noundef %0) #0 !dbg !105 {
  %2 = alloca %struct.mutex_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.mutex_t* %0, %struct.mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.mutex_t** %2, metadata !106, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.declare(metadata i32* %3, metadata !108, metadata !DIExpression()), !dbg !109
  %7 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8, !dbg !110
  %8 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %7, i32 0, i32 0, !dbg !111
  store i32 0, i32* %4, align 4, !dbg !112
  %9 = load i32, i32* %4, align 4, !dbg !112
  %10 = atomicrmw xchg i32* %8, i32 %9 release, align 4, !dbg !112
  store i32 %10, i32* %5, align 4, !dbg !112
  %11 = load i32, i32* %5, align 4, !dbg !112
  store i32 %11, i32* %3, align 4, !dbg !109
  %12 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8, !dbg !113
  %13 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %12, i32 0, i32 1, !dbg !115
  %14 = load atomic i32, i32* %13 monotonic, align 4, !dbg !116
  store i32 %14, i32* %6, align 4, !dbg !116
  %15 = load i32, i32* %6, align 4, !dbg !116
  %16 = icmp sgt i32 %15, 0, !dbg !117
  br i1 %16, label %20, label %17, !dbg !118

17:                                               ; preds = %1
  %18 = load i32, i32* %3, align 4, !dbg !119
  %19 = icmp ne i32 %18, 1, !dbg !120
  br i1 %19, label %20, label %23, !dbg !121

20:                                               ; preds = %17, %1
  %21 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8, !dbg !122
  %22 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %21, i32 0, i32 0, !dbg !123
  call void @__futex_wake(i32* noundef %22, i32 noundef 1), !dbg !124
  br label %23, !dbg !124

23:                                               ; preds = %20, %17
  ret void, !dbg !125
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !126 {
  %1 = alloca i32, align 4
  %2 = alloca [4 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [4 x i64]* %2, metadata !129, metadata !DIExpression()), !dbg !136
  call void @mutex_init(%struct.mutex_t* noundef @mutex), !dbg !137
  call void @llvm.dbg.declare(metadata i32* %3, metadata !138, metadata !DIExpression()), !dbg !140
  store i32 0, i32* %3, align 4, !dbg !140
  br label %5, !dbg !141

5:                                                ; preds = %16, %0
  %6 = load i32, i32* %3, align 4, !dbg !142
  %7 = icmp slt i32 %6, 4, !dbg !144
  br i1 %7, label %8, label %19, !dbg !145

8:                                                ; preds = %5
  %9 = load i32, i32* %3, align 4, !dbg !146
  %10 = sext i32 %9 to i64, !dbg !147
  %11 = getelementptr inbounds [4 x i64], [4 x i64]* %2, i64 0, i64 %10, !dbg !147
  %12 = load i32, i32* %3, align 4, !dbg !148
  %13 = sext i32 %12 to i64, !dbg !149
  %14 = inttoptr i64 %13 to i8*, !dbg !149
  %15 = call i32 @pthread_create(i64* noundef %11, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @thread_n, i8* noundef %14) #6, !dbg !150
  br label %16, !dbg !150

16:                                               ; preds = %8
  %17 = load i32, i32* %3, align 4, !dbg !151
  %18 = add nsw i32 %17, 1, !dbg !151
  store i32 %18, i32* %3, align 4, !dbg !151
  br label %5, !dbg !152, !llvm.loop !153

19:                                               ; preds = %5
  call void @llvm.dbg.declare(metadata i32* %4, metadata !155, metadata !DIExpression()), !dbg !157
  store i32 0, i32* %4, align 4, !dbg !157
  br label %20, !dbg !158

20:                                               ; preds = %29, %19
  %21 = load i32, i32* %4, align 4, !dbg !159
  %22 = icmp slt i32 %21, 4, !dbg !161
  br i1 %22, label %23, label %32, !dbg !162

23:                                               ; preds = %20
  %24 = load i32, i32* %4, align 4, !dbg !163
  %25 = sext i32 %24 to i64, !dbg !164
  %26 = getelementptr inbounds [4 x i64], [4 x i64]* %2, i64 0, i64 %25, !dbg !164
  %27 = load i64, i64* %26, align 8, !dbg !164
  %28 = call i32 @pthread_join(i64 noundef %27, i8** noundef null), !dbg !165
  br label %29, !dbg !165

29:                                               ; preds = %23
  %30 = load i32, i32* %4, align 4, !dbg !166
  %31 = add nsw i32 %30, 1, !dbg !166
  store i32 %31, i32* %4, align 4, !dbg !166
  br label %20, !dbg !167, !llvm.loop !168

32:                                               ; preds = %20
  %33 = load i32, i32* @sum, align 4, !dbg !170
  %34 = icmp eq i32 %33, 4, !dbg !170
  br i1 %34, label %35, label %36, !dbg !173

35:                                               ; preds = %32
  br label %37, !dbg !173

36:                                               ; preds = %32
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !170
  unreachable, !dbg !170

37:                                               ; preds = %35
  ret i32 0, !dbg !174
}

; Function Attrs: noinline nounwind uwtable
define internal void @mutex_init(%struct.mutex_t* noundef %0) #0 !dbg !175 {
  %2 = alloca %struct.mutex_t*, align 8
  store %struct.mutex_t* %0, %struct.mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.mutex_t** %2, metadata !176, metadata !DIExpression()), !dbg !177
  %3 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8, !dbg !178
  %4 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %3, i32 0, i32 0, !dbg !179
  store i32 0, i32* %4, align 4, !dbg !180
  %5 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8, !dbg !181
  %6 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %5, i32 0, i32 1, !dbg !182
  store i32 0, i32* %6, align 4, !dbg !183
  ret void, !dbg !184
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @mutex_lock_fastpath(%struct.mutex_t* noundef %0) #0 !dbg !185 {
  %2 = alloca %struct.mutex_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store %struct.mutex_t* %0, %struct.mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.mutex_t** %2, metadata !188, metadata !DIExpression()), !dbg !189
  call void @llvm.dbg.declare(metadata i32* %3, metadata !190, metadata !DIExpression()), !dbg !191
  store i32 0, i32* %3, align 4, !dbg !191
  %6 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8, !dbg !192
  %7 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %6, i32 0, i32 0, !dbg !193
  store i32 1, i32* %4, align 4, !dbg !194
  %8 = load i32, i32* %3, align 4, !dbg !194
  %9 = load i32, i32* %4, align 4, !dbg !194
  %10 = cmpxchg i32* %7, i32 %8, i32 %9 acquire acquire, align 4, !dbg !194
  %11 = extractvalue { i32, i1 } %10, 0, !dbg !194
  %12 = extractvalue { i32, i1 } %10, 1, !dbg !194
  br i1 %12, label %14, label %13, !dbg !194

13:                                               ; preds = %1
  store i32 %11, i32* %3, align 4, !dbg !194
  br label %14, !dbg !194

14:                                               ; preds = %13, %1
  %15 = zext i1 %12 to i8, !dbg !194
  store i8 %15, i8* %5, align 1, !dbg !194
  %16 = load i8, i8* %5, align 1, !dbg !194
  %17 = trunc i8 %16 to i1, !dbg !194
  %18 = zext i1 %17 to i32, !dbg !194
  ret i32 %18, !dbg !195
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @mutex_lock_slowpath_check(%struct.mutex_t* noundef %0) #0 !dbg !196 {
  %2 = alloca %struct.mutex_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store %struct.mutex_t* %0, %struct.mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.mutex_t** %2, metadata !197, metadata !DIExpression()), !dbg !198
  call void @llvm.dbg.declare(metadata i32* %3, metadata !199, metadata !DIExpression()), !dbg !200
  store i32 0, i32* %3, align 4, !dbg !200
  %6 = load %struct.mutex_t*, %struct.mutex_t** %2, align 8, !dbg !201
  %7 = getelementptr inbounds %struct.mutex_t, %struct.mutex_t* %6, i32 0, i32 0, !dbg !202
  store i32 1, i32* %4, align 4, !dbg !203
  %8 = load i32, i32* %3, align 4, !dbg !203
  %9 = load i32, i32* %4, align 4, !dbg !203
  %10 = cmpxchg i32* %7, i32 %8, i32 %9 acquire acquire, align 4, !dbg !203
  %11 = extractvalue { i32, i1 } %10, 0, !dbg !203
  %12 = extractvalue { i32, i1 } %10, 1, !dbg !203
  br i1 %12, label %14, label %13, !dbg !203

13:                                               ; preds = %1
  store i32 %11, i32* %3, align 4, !dbg !203
  br label %14, !dbg !203

14:                                               ; preds = %13, %1
  %15 = zext i1 %12 to i8, !dbg !203
  store i8 %15, i8* %5, align 1, !dbg !203
  %16 = load i8, i8* %5, align 1, !dbg !203
  %17 = trunc i8 %16 to i1, !dbg !203
  %18 = zext i1 %17 to i32, !dbg !203
  ret i32 %18, !dbg !204
}

; Function Attrs: noinline nounwind uwtable
define internal void @__futex_wait(i32* noundef %0, i32 noundef %1) #0 !dbg !205 {
  %3 = alloca i32*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  call void @llvm.dbg.declare(metadata i32** %3, metadata !209, metadata !DIExpression()), !dbg !210
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !211, metadata !DIExpression()), !dbg !212
  call void @llvm.dbg.declare(metadata i32* %5, metadata !213, metadata !DIExpression()), !dbg !214
  %9 = load atomic i32, i32* @sig acquire, align 4, !dbg !215
  store i32 %9, i32* %6, align 4, !dbg !215
  %10 = load i32, i32* %6, align 4, !dbg !215
  store i32 %10, i32* %5, align 4, !dbg !214
  %11 = load i32*, i32** %3, align 8, !dbg !216
  %12 = load atomic i32, i32* %11 acquire, align 4, !dbg !218
  store i32 %12, i32* %7, align 4, !dbg !218
  %13 = load i32, i32* %7, align 4, !dbg !218
  %14 = load i32, i32* %4, align 4, !dbg !219
  %15 = icmp ne i32 %13, %14, !dbg !220
  br i1 %15, label %16, label %17, !dbg !221

16:                                               ; preds = %2
  br label %24, !dbg !222

17:                                               ; preds = %2
  br label %18, !dbg !223

18:                                               ; preds = %23, %17
  %19 = load atomic i32, i32* @sig acquire, align 4, !dbg !224
  store i32 %19, i32* %8, align 4, !dbg !224
  %20 = load i32, i32* %8, align 4, !dbg !224
  %21 = load i32, i32* %5, align 4, !dbg !225
  %22 = icmp eq i32 %20, %21, !dbg !226
  br i1 %22, label %23, label %24, !dbg !223

23:                                               ; preds = %18
  br label %18, !dbg !223, !llvm.loop !227

24:                                               ; preds = %16, %18
  ret void, !dbg !229
}

; Function Attrs: noinline nounwind uwtable
define internal void @__futex_wake(i32* noundef %0, i32 noundef %1) #0 !dbg !230 {
  %3 = alloca i32*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  call void @llvm.dbg.declare(metadata i32** %3, metadata !231, metadata !DIExpression()), !dbg !232
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !233, metadata !DIExpression()), !dbg !234
  store i32 1, i32* %5, align 4, !dbg !235
  %7 = load i32, i32* %5, align 4, !dbg !235
  %8 = atomicrmw add i32* @sig, i32 %7 release, align 4, !dbg !235
  store i32 %8, i32* %6, align 4, !dbg !235
  %9 = load i32, i32* %6, align 4, !dbg !235
  ret void, !dbg !236
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!38, !39, !40, !41, !42, !43, !44}
!llvm.ident = !{!45}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !23, line: 11, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !20, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/mutex_musl.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "93828a87b35043c4e125bbdd528f6f52")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 56, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "de5d66a1ef2f5448cc1919ff39db92bc")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16, !19}
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !17, line: 87, baseType: !18)
!17 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "24103e292ae21916e87130b926c8d2f8")
!18 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!20 = !{!0, !21, !25, !35}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !23, line: 9, type: !24, isLocal: false, isDefinition: true)
!23 = !DIFile(filename: "benchmarks/locks/mutex_musl.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "93828a87b35043c4e125bbdd528f6f52")
!24 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "mutex", scope: !2, file: !23, line: 10, type: !27, isLocal: false, isDefinition: true)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "mutex_t", file: !28, line: 19, baseType: !29)
!28 = !DIFile(filename: "benchmarks/locks/mutex_musl.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "5e2bc1f81a3862bf4303eecab164593d")
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !28, line: 16, size: 64, elements: !30)
!30 = !{!31, !34}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !29, file: !28, line: 17, baseType: !32, size: 32)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !33)
!33 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !24)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "waiters", scope: !29, file: !28, line: 18, baseType: !32, size: 32, offset: 32)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "sig", scope: !2, file: !37, line: 15, type: !32, isLocal: true, isDefinition: true)
!37 = !DIFile(filename: "benchmarks/locks/futex.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "cb5dc9517b2fd37660598e8a5b273f61")
!38 = !{i32 7, !"Dwarf Version", i32 5}
!39 = !{i32 2, !"Debug Info Version", i32 3}
!40 = !{i32 1, !"wchar_size", i32 4}
!41 = !{i32 7, !"PIC Level", i32 2}
!42 = !{i32 7, !"PIE Level", i32 2}
!43 = !{i32 7, !"uwtable", i32 1}
!44 = !{i32 7, !"frame-pointer", i32 2}
!45 = !{!"Ubuntu clang version 14.0.6"}
!46 = distinct !DISubprogram(name: "thread_n", scope: !23, file: !23, line: 13, type: !47, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!47 = !DISubroutineType(types: !48)
!48 = !{!19, !19}
!49 = !{}
!50 = !DILocalVariable(name: "arg", arg: 1, scope: !46, file: !23, line: 13, type: !19)
!51 = !DILocation(line: 13, column: 22, scope: !46)
!52 = !DILocalVariable(name: "index", scope: !46, file: !23, line: 15, type: !16)
!53 = !DILocation(line: 15, column: 14, scope: !46)
!54 = !DILocation(line: 15, column: 34, scope: !46)
!55 = !DILocation(line: 15, column: 23, scope: !46)
!56 = !DILocation(line: 17, column: 5, scope: !46)
!57 = !DILocation(line: 18, column: 14, scope: !46)
!58 = !DILocation(line: 18, column: 12, scope: !46)
!59 = !DILocalVariable(name: "r", scope: !46, file: !23, line: 19, type: !24)
!60 = !DILocation(line: 19, column: 9, scope: !46)
!61 = !DILocation(line: 19, column: 13, scope: !46)
!62 = !DILocation(line: 20, column: 5, scope: !63)
!63 = distinct !DILexicalBlock(scope: !64, file: !23, line: 20, column: 5)
!64 = distinct !DILexicalBlock(scope: !46, file: !23, line: 20, column: 5)
!65 = !DILocation(line: 20, column: 5, scope: !64)
!66 = !DILocation(line: 21, column: 8, scope: !46)
!67 = !DILocation(line: 22, column: 5, scope: !46)
!68 = !DILocation(line: 23, column: 5, scope: !46)
!69 = distinct !DISubprogram(name: "mutex_lock", scope: !28, file: !28, line: 43, type: !70, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!70 = !DISubroutineType(types: !71)
!71 = !{null, !72}
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!73 = !DILocalVariable(name: "m", arg: 1, scope: !69, file: !28, line: 43, type: !72)
!74 = !DILocation(line: 43, column: 40, scope: !69)
!75 = !DILocation(line: 46, column: 29, scope: !76)
!76 = distinct !DILexicalBlock(scope: !69, file: !28, line: 46, column: 9)
!77 = !DILocation(line: 46, column: 9, scope: !76)
!78 = !DILocation(line: 46, column: 9, scope: !69)
!79 = !DILocation(line: 47, column: 9, scope: !76)
!80 = !DILocation(line: 49, column: 5, scope: !69)
!81 = !DILocation(line: 49, column: 38, scope: !69)
!82 = !DILocation(line: 49, column: 12, scope: !69)
!83 = !DILocation(line: 49, column: 41, scope: !69)
!84 = !DILocation(line: 50, column: 36, scope: !85)
!85 = distinct !DILexicalBlock(scope: !69, file: !28, line: 49, column: 47)
!86 = !DILocation(line: 50, column: 39, scope: !85)
!87 = !DILocation(line: 50, column: 9, scope: !85)
!88 = !DILocalVariable(name: "r", scope: !85, file: !28, line: 51, type: !24)
!89 = !DILocation(line: 51, column: 13, scope: !85)
!90 = !DILocation(line: 52, column: 55, scope: !91)
!91 = distinct !DILexicalBlock(scope: !85, file: !28, line: 52, column: 13)
!92 = !DILocation(line: 52, column: 58, scope: !91)
!93 = !DILocation(line: 52, column: 14, scope: !91)
!94 = !DILocation(line: 52, column: 13, scope: !85)
!95 = !DILocation(line: 55, column: 23, scope: !91)
!96 = !DILocation(line: 55, column: 26, scope: !91)
!97 = !DILocation(line: 55, column: 9, scope: !91)
!98 = !DILocation(line: 56, column: 36, scope: !85)
!99 = !DILocation(line: 56, column: 39, scope: !85)
!100 = !DILocation(line: 56, column: 9, scope: !85)
!101 = distinct !{!101, !80, !102, !103}
!102 = !DILocation(line: 57, column: 5, scope: !69)
!103 = !{!"llvm.loop.mustprogress"}
!104 = !DILocation(line: 58, column: 1, scope: !69)
!105 = distinct !DISubprogram(name: "mutex_unlock", scope: !28, file: !28, line: 60, type: !70, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!106 = !DILocalVariable(name: "m", arg: 1, scope: !105, file: !28, line: 60, type: !72)
!107 = !DILocation(line: 60, column: 42, scope: !105)
!108 = !DILocalVariable(name: "old", scope: !105, file: !28, line: 62, type: !24)
!109 = !DILocation(line: 62, column: 9, scope: !105)
!110 = !DILocation(line: 62, column: 41, scope: !105)
!111 = !DILocation(line: 62, column: 44, scope: !105)
!112 = !DILocation(line: 62, column: 15, scope: !105)
!113 = !DILocation(line: 63, column: 31, scope: !114)
!114 = distinct !DILexicalBlock(scope: !105, file: !28, line: 63, column: 9)
!115 = !DILocation(line: 63, column: 34, scope: !114)
!116 = !DILocation(line: 63, column: 9, scope: !114)
!117 = !DILocation(line: 63, column: 65, scope: !114)
!118 = !DILocation(line: 63, column: 69, scope: !114)
!119 = !DILocation(line: 63, column: 72, scope: !114)
!120 = !DILocation(line: 63, column: 76, scope: !114)
!121 = !DILocation(line: 63, column: 9, scope: !105)
!122 = !DILocation(line: 64, column: 23, scope: !114)
!123 = !DILocation(line: 64, column: 26, scope: !114)
!124 = !DILocation(line: 64, column: 9, scope: !114)
!125 = !DILocation(line: 65, column: 1, scope: !105)
!126 = distinct !DISubprogram(name: "main", scope: !23, file: !23, line: 26, type: !127, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!127 = !DISubroutineType(types: !128)
!128 = !{!24}
!129 = !DILocalVariable(name: "t", scope: !126, file: !23, line: 28, type: !130)
!130 = !DICompositeType(tag: DW_TAG_array_type, baseType: !131, size: 256, elements: !134)
!131 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !132, line: 27, baseType: !133)
!132 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!133 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!134 = !{!135}
!135 = !DISubrange(count: 4)
!136 = !DILocation(line: 28, column: 15, scope: !126)
!137 = !DILocation(line: 30, column: 5, scope: !126)
!138 = !DILocalVariable(name: "i", scope: !139, file: !23, line: 32, type: !24)
!139 = distinct !DILexicalBlock(scope: !126, file: !23, line: 32, column: 5)
!140 = !DILocation(line: 32, column: 14, scope: !139)
!141 = !DILocation(line: 32, column: 10, scope: !139)
!142 = !DILocation(line: 32, column: 21, scope: !143)
!143 = distinct !DILexicalBlock(scope: !139, file: !23, line: 32, column: 5)
!144 = !DILocation(line: 32, column: 23, scope: !143)
!145 = !DILocation(line: 32, column: 5, scope: !139)
!146 = !DILocation(line: 33, column: 27, scope: !143)
!147 = !DILocation(line: 33, column: 25, scope: !143)
!148 = !DILocation(line: 33, column: 52, scope: !143)
!149 = !DILocation(line: 33, column: 44, scope: !143)
!150 = !DILocation(line: 33, column: 9, scope: !143)
!151 = !DILocation(line: 32, column: 36, scope: !143)
!152 = !DILocation(line: 32, column: 5, scope: !143)
!153 = distinct !{!153, !145, !154, !103}
!154 = !DILocation(line: 33, column: 53, scope: !139)
!155 = !DILocalVariable(name: "i", scope: !156, file: !23, line: 35, type: !24)
!156 = distinct !DILexicalBlock(scope: !126, file: !23, line: 35, column: 5)
!157 = !DILocation(line: 35, column: 14, scope: !156)
!158 = !DILocation(line: 35, column: 10, scope: !156)
!159 = !DILocation(line: 35, column: 21, scope: !160)
!160 = distinct !DILexicalBlock(scope: !156, file: !23, line: 35, column: 5)
!161 = !DILocation(line: 35, column: 23, scope: !160)
!162 = !DILocation(line: 35, column: 5, scope: !156)
!163 = !DILocation(line: 36, column: 24, scope: !160)
!164 = !DILocation(line: 36, column: 22, scope: !160)
!165 = !DILocation(line: 36, column: 9, scope: !160)
!166 = !DILocation(line: 35, column: 36, scope: !160)
!167 = !DILocation(line: 35, column: 5, scope: !160)
!168 = distinct !{!168, !162, !169, !103}
!169 = !DILocation(line: 36, column: 29, scope: !156)
!170 = !DILocation(line: 38, column: 5, scope: !171)
!171 = distinct !DILexicalBlock(scope: !172, file: !23, line: 38, column: 5)
!172 = distinct !DILexicalBlock(scope: !126, file: !23, line: 38, column: 5)
!173 = !DILocation(line: 38, column: 5, scope: !172)
!174 = !DILocation(line: 40, column: 5, scope: !126)
!175 = distinct !DISubprogram(name: "mutex_init", scope: !28, file: !28, line: 21, type: !70, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!176 = !DILocalVariable(name: "m", arg: 1, scope: !175, file: !28, line: 21, type: !72)
!177 = !DILocation(line: 21, column: 40, scope: !175)
!178 = !DILocation(line: 23, column: 18, scope: !175)
!179 = !DILocation(line: 23, column: 21, scope: !175)
!180 = !DILocation(line: 23, column: 5, scope: !175)
!181 = !DILocation(line: 24, column: 18, scope: !175)
!182 = !DILocation(line: 24, column: 21, scope: !175)
!183 = !DILocation(line: 24, column: 5, scope: !175)
!184 = !DILocation(line: 25, column: 1, scope: !175)
!185 = distinct !DISubprogram(name: "mutex_lock_fastpath", scope: !28, file: !28, line: 27, type: !186, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!186 = !DISubroutineType(types: !187)
!187 = !{!24, !72}
!188 = !DILocalVariable(name: "m", arg: 1, scope: !185, file: !28, line: 27, type: !72)
!189 = !DILocation(line: 27, column: 48, scope: !185)
!190 = !DILocalVariable(name: "r", scope: !185, file: !28, line: 29, type: !24)
!191 = !DILocation(line: 29, column: 9, scope: !185)
!192 = !DILocation(line: 30, column: 53, scope: !185)
!193 = !DILocation(line: 30, column: 56, scope: !185)
!194 = !DILocation(line: 30, column: 12, scope: !185)
!195 = !DILocation(line: 30, column: 5, scope: !185)
!196 = distinct !DISubprogram(name: "mutex_lock_slowpath_check", scope: !28, file: !28, line: 35, type: !186, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!197 = !DILocalVariable(name: "m", arg: 1, scope: !196, file: !28, line: 35, type: !72)
!198 = !DILocation(line: 35, column: 54, scope: !196)
!199 = !DILocalVariable(name: "r", scope: !196, file: !28, line: 37, type: !24)
!200 = !DILocation(line: 37, column: 9, scope: !196)
!201 = !DILocation(line: 38, column: 53, scope: !196)
!202 = !DILocation(line: 38, column: 56, scope: !196)
!203 = !DILocation(line: 38, column: 12, scope: !196)
!204 = !DILocation(line: 38, column: 5, scope: !196)
!205 = distinct !DISubprogram(name: "__futex_wait", scope: !37, file: !37, line: 17, type: !206, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!206 = !DISubroutineType(types: !207)
!207 = !{null, !208, !24}
!208 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!209 = !DILocalVariable(name: "m", arg: 1, scope: !205, file: !37, line: 17, type: !208)
!210 = !DILocation(line: 17, column: 45, scope: !205)
!211 = !DILocalVariable(name: "v", arg: 2, scope: !205, file: !37, line: 17, type: !24)
!212 = !DILocation(line: 17, column: 52, scope: !205)
!213 = !DILocalVariable(name: "s", scope: !205, file: !37, line: 19, type: !24)
!214 = !DILocation(line: 19, column: 9, scope: !205)
!215 = !DILocation(line: 19, column: 13, scope: !205)
!216 = !DILocation(line: 20, column: 30, scope: !217)
!217 = distinct !DILexicalBlock(scope: !205, file: !37, line: 20, column: 9)
!218 = !DILocation(line: 20, column: 9, scope: !217)
!219 = !DILocation(line: 20, column: 45, scope: !217)
!220 = !DILocation(line: 20, column: 42, scope: !217)
!221 = !DILocation(line: 20, column: 9, scope: !205)
!222 = !DILocation(line: 21, column: 9, scope: !217)
!223 = !DILocation(line: 23, column: 5, scope: !205)
!224 = !DILocation(line: 23, column: 12, scope: !205)
!225 = !DILocation(line: 23, column: 51, scope: !205)
!226 = !DILocation(line: 23, column: 48, scope: !205)
!227 = distinct !{!227, !223, !228, !103}
!228 = !DILocation(line: 24, column: 9, scope: !205)
!229 = !DILocation(line: 25, column: 1, scope: !205)
!230 = distinct !DISubprogram(name: "__futex_wake", scope: !37, file: !37, line: 27, type: !206, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!231 = !DILocalVariable(name: "m", arg: 1, scope: !230, file: !37, line: 27, type: !208)
!232 = !DILocation(line: 27, column: 45, scope: !230)
!233 = !DILocalVariable(name: "v", arg: 2, scope: !230, file: !37, line: 27, type: !24)
!234 = !DILocation(line: 27, column: 52, scope: !230)
!235 = !DILocation(line: 29, column: 5, scope: !230)
!236 = !DILocation(line: 30, column: 1, scope: !230)
