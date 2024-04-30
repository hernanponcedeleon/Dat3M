; ModuleID = '/home/ponce/git/Dat3M/output/linuxrwlock.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/locks/linuxrwlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.rwlock_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@sum = dso_local global i32 0, align 4, !dbg !0
@mylock = dso_local global %union.rwlock_t zeroinitializer, align 4, !dbg !18
@shareddata = dso_local global i32 0, align 4, !dbg !29
@.str = private unnamed_addr constant [16 x i8] c"r == shareddata\00", align 1
@.str.1 = private unnamed_addr constant [53 x i8] c"/home/ponce/git/Dat3M/benchmarks/locks/linuxrwlock.c\00", align 1
@__PRETTY_FUNCTION__.threadR = private unnamed_addr constant [22 x i8] c"void *threadR(void *)\00", align 1
@.str.2 = private unnamed_addr constant [17 x i8] c"42 == shareddata\00", align 1
@__PRETTY_FUNCTION__.threadW = private unnamed_addr constant [22 x i8] c"void *threadW(void *)\00", align 1
@__PRETTY_FUNCTION__.threadRW = private unnamed_addr constant [23 x i8] c"void *threadRW(void *)\00", align 1
@.str.3 = private unnamed_addr constant [29 x i8] c"sum == NWTHREADS + NWTHREADS\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @threadR(i8* %0) #0 !dbg !36 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !40, metadata !DIExpression()), !dbg !41
  call void @read_lock(%union.rwlock_t* @mylock), !dbg !42
  call void @llvm.dbg.declare(metadata i32* %3, metadata !43, metadata !DIExpression()), !dbg !44
  %4 = load volatile i32, i32* @shareddata, align 4, !dbg !45
  store i32 %4, i32* %3, align 4, !dbg !44
  %5 = load i32, i32* %3, align 4, !dbg !46
  %6 = load volatile i32, i32* @shareddata, align 4, !dbg !46
  %7 = icmp eq i32 %5, %6, !dbg !46
  br i1 %7, label %8, label %9, !dbg !49

8:                                                ; preds = %1
  br label %10, !dbg !49

9:                                                ; preds = %1
  call void @__assert_fail(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 26, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @__PRETTY_FUNCTION__.threadR, i64 0, i64 0)) #5, !dbg !46
  unreachable, !dbg !46

10:                                               ; preds = %8
  call void @read_unlock(%union.rwlock_t* @mylock), !dbg !50
  ret i8* null, !dbg !51
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @read_lock(%union.rwlock_t* %0) #0 !dbg !52 {
  %2 = alloca %union.rwlock_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store %union.rwlock_t* %0, %union.rwlock_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.rwlock_t** %2, metadata !56, metadata !DIExpression()), !dbg !57
  call void @llvm.dbg.declare(metadata i32* %3, metadata !58, metadata !DIExpression()), !dbg !59
  %11 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !60
  %12 = bitcast %union.rwlock_t* %11 to i32*, !dbg !61
  store i32 1, i32* %4, align 4, !dbg !62
  %13 = load i32, i32* %4, align 4, !dbg !62
  %14 = atomicrmw sub i32* %12, i32 %13 acquire, align 4, !dbg !62
  store i32 %14, i32* %5, align 4, !dbg !62
  %15 = load i32, i32* %5, align 4, !dbg !62
  store i32 %15, i32* %3, align 4, !dbg !59
  br label %16, !dbg !63

16:                                               ; preds = %32, %1
  %17 = load i32, i32* %3, align 4, !dbg !64
  %18 = icmp sle i32 %17, 0, !dbg !65
  br i1 %18, label %19, label %38, !dbg !63

19:                                               ; preds = %16
  %20 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !66
  %21 = bitcast %union.rwlock_t* %20 to i32*, !dbg !68
  store i32 1, i32* %6, align 4, !dbg !69
  %22 = load i32, i32* %6, align 4, !dbg !69
  %23 = atomicrmw add i32* %21, i32 %22 acquire, align 4, !dbg !69
  store i32 %23, i32* %7, align 4, !dbg !69
  %24 = load i32, i32* %7, align 4, !dbg !69
  br label %25, !dbg !70

25:                                               ; preds = %31, %19
  %26 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !71
  %27 = bitcast %union.rwlock_t* %26 to i32*, !dbg !72
  %28 = load atomic i32, i32* %27 monotonic, align 4, !dbg !73
  store i32 %28, i32* %8, align 4, !dbg !73
  %29 = load i32, i32* %8, align 4, !dbg !73
  %30 = icmp sle i32 %29, 0, !dbg !74
  br i1 %30, label %31, label %32, !dbg !70

31:                                               ; preds = %25
  br label %25, !dbg !70, !llvm.loop !75

32:                                               ; preds = %25
  %33 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !78
  %34 = bitcast %union.rwlock_t* %33 to i32*, !dbg !79
  store i32 1, i32* %9, align 4, !dbg !80
  %35 = load i32, i32* %9, align 4, !dbg !80
  %36 = atomicrmw sub i32* %34, i32 %35 acquire, align 4, !dbg !80
  store i32 %36, i32* %10, align 4, !dbg !80
  %37 = load i32, i32* %10, align 4, !dbg !80
  store i32 %37, i32* %3, align 4, !dbg !81
  br label %16, !dbg !63, !llvm.loop !82

38:                                               ; preds = %16
  ret void, !dbg !84
}

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #2

; Function Attrs: noinline nounwind uwtable
define internal void @read_unlock(%union.rwlock_t* %0) #0 !dbg !85 {
  %2 = alloca %union.rwlock_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %union.rwlock_t* %0, %union.rwlock_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.rwlock_t** %2, metadata !86, metadata !DIExpression()), !dbg !87
  %5 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !88
  %6 = bitcast %union.rwlock_t* %5 to i32*, !dbg !89
  store i32 1, i32* %3, align 4, !dbg !90
  %7 = load i32, i32* %3, align 4, !dbg !90
  %8 = atomicrmw add i32* %6, i32 %7 release, align 4, !dbg !90
  store i32 %8, i32* %4, align 4, !dbg !90
  %9 = load i32, i32* %4, align 4, !dbg !90
  ret void, !dbg !91
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @threadW(i8* %0) #0 !dbg !92 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !93, metadata !DIExpression()), !dbg !94
  call void @write_lock(%union.rwlock_t* @mylock), !dbg !95
  store volatile i32 42, i32* @shareddata, align 4, !dbg !96
  %3 = load volatile i32, i32* @shareddata, align 4, !dbg !97
  %4 = icmp eq i32 42, %3, !dbg !97
  br i1 %4, label %5, label %6, !dbg !100

5:                                                ; preds = %1
  br label %7, !dbg !100

6:                                                ; preds = %1
  call void @__assert_fail(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 36, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @__PRETTY_FUNCTION__.threadW, i64 0, i64 0)) #5, !dbg !97
  unreachable, !dbg !97

7:                                                ; preds = %5
  %8 = load i32, i32* @sum, align 4, !dbg !101
  %9 = add nsw i32 %8, 1, !dbg !101
  store i32 %9, i32* @sum, align 4, !dbg !101
  call void @write_unlock(%union.rwlock_t* @mylock), !dbg !102
  ret i8* null, !dbg !103
}

; Function Attrs: noinline nounwind uwtable
define internal void @write_lock(%union.rwlock_t* %0) #0 !dbg !104 {
  %2 = alloca %union.rwlock_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store %union.rwlock_t* %0, %union.rwlock_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.rwlock_t** %2, metadata !105, metadata !DIExpression()), !dbg !106
  call void @llvm.dbg.declare(metadata i32* %3, metadata !107, metadata !DIExpression()), !dbg !108
  %11 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !109
  %12 = bitcast %union.rwlock_t* %11 to i32*, !dbg !110
  store i32 1048576, i32* %4, align 4, !dbg !111
  %13 = load i32, i32* %4, align 4, !dbg !111
  %14 = atomicrmw sub i32* %12, i32 %13 acquire, align 4, !dbg !111
  store i32 %14, i32* %5, align 4, !dbg !111
  %15 = load i32, i32* %5, align 4, !dbg !111
  store i32 %15, i32* %3, align 4, !dbg !108
  br label %16, !dbg !112

16:                                               ; preds = %32, %1
  %17 = load i32, i32* %3, align 4, !dbg !113
  %18 = icmp ne i32 %17, 1048576, !dbg !114
  br i1 %18, label %19, label %38, !dbg !112

19:                                               ; preds = %16
  %20 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !115
  %21 = bitcast %union.rwlock_t* %20 to i32*, !dbg !117
  store i32 1048576, i32* %6, align 4, !dbg !118
  %22 = load i32, i32* %6, align 4, !dbg !118
  %23 = atomicrmw add i32* %21, i32 %22 acquire, align 4, !dbg !118
  store i32 %23, i32* %7, align 4, !dbg !118
  %24 = load i32, i32* %7, align 4, !dbg !118
  br label %25, !dbg !119

25:                                               ; preds = %31, %19
  %26 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !120
  %27 = bitcast %union.rwlock_t* %26 to i32*, !dbg !121
  %28 = load atomic i32, i32* %27 monotonic, align 4, !dbg !122
  store i32 %28, i32* %8, align 4, !dbg !122
  %29 = load i32, i32* %8, align 4, !dbg !122
  %30 = icmp ne i32 %29, 1048576, !dbg !123
  br i1 %30, label %31, label %32, !dbg !119

31:                                               ; preds = %25
  br label %25, !dbg !119, !llvm.loop !124

32:                                               ; preds = %25
  %33 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !126
  %34 = bitcast %union.rwlock_t* %33 to i32*, !dbg !127
  store i32 1048576, i32* %9, align 4, !dbg !128
  %35 = load i32, i32* %9, align 4, !dbg !128
  %36 = atomicrmw sub i32* %34, i32 %35 acquire, align 4, !dbg !128
  store i32 %36, i32* %10, align 4, !dbg !128
  %37 = load i32, i32* %10, align 4, !dbg !128
  store i32 %37, i32* %3, align 4, !dbg !129
  br label %16, !dbg !112, !llvm.loop !130

38:                                               ; preds = %16
  ret void, !dbg !132
}

; Function Attrs: noinline nounwind uwtable
define internal void @write_unlock(%union.rwlock_t* %0) #0 !dbg !133 {
  %2 = alloca %union.rwlock_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %union.rwlock_t* %0, %union.rwlock_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.rwlock_t** %2, metadata !134, metadata !DIExpression()), !dbg !135
  %5 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !136
  %6 = bitcast %union.rwlock_t* %5 to i32*, !dbg !137
  store i32 1048576, i32* %3, align 4, !dbg !138
  %7 = load i32, i32* %3, align 4, !dbg !138
  %8 = atomicrmw add i32* %6, i32 %7 release, align 4, !dbg !138
  store i32 %8, i32* %4, align 4, !dbg !138
  %9 = load i32, i32* %4, align 4, !dbg !138
  ret void, !dbg !139
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @threadRW(i8* %0) #0 !dbg !140 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !141, metadata !DIExpression()), !dbg !142
  call void @read_lock(%union.rwlock_t* @mylock), !dbg !143
  call void @llvm.dbg.declare(metadata i32* %3, metadata !144, metadata !DIExpression()), !dbg !145
  %4 = load volatile i32, i32* @shareddata, align 4, !dbg !146
  store i32 %4, i32* %3, align 4, !dbg !145
  %5 = load i32, i32* %3, align 4, !dbg !147
  %6 = load volatile i32, i32* @shareddata, align 4, !dbg !147
  %7 = icmp eq i32 %5, %6, !dbg !147
  br i1 %7, label %8, label %9, !dbg !150

8:                                                ; preds = %1
  br label %10, !dbg !150

9:                                                ; preds = %1
  call void @__assert_fail(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 47, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.threadRW, i64 0, i64 0)) #5, !dbg !147
  unreachable, !dbg !147

10:                                               ; preds = %8
  call void @read_unlock(%union.rwlock_t* @mylock), !dbg !151
  call void @write_lock(%union.rwlock_t* @mylock), !dbg !152
  store volatile i32 42, i32* @shareddata, align 4, !dbg !153
  %11 = load volatile i32, i32* @shareddata, align 4, !dbg !154
  %12 = icmp eq i32 42, %11, !dbg !154
  br i1 %12, label %13, label %14, !dbg !157

13:                                               ; preds = %10
  br label %15, !dbg !157

14:                                               ; preds = %10
  call void @__assert_fail(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 52, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.threadRW, i64 0, i64 0)) #5, !dbg !154
  unreachable, !dbg !154

15:                                               ; preds = %13
  %16 = load i32, i32* @sum, align 4, !dbg !158
  %17 = add nsw i32 %16, 1, !dbg !158
  store i32 %17, i32* @sum, align 4, !dbg !158
  call void @write_unlock(%union.rwlock_t* @mylock), !dbg !159
  ret i8* null, !dbg !160
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !161 {
  %1 = alloca i32, align 4
  %2 = alloca [1 x i64], align 8
  %3 = alloca [1 x i64], align 8
  %4 = alloca [1 x i64], align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [1 x i64]* %2, metadata !164, metadata !DIExpression()), !dbg !171
  call void @llvm.dbg.declare(metadata [1 x i64]* %3, metadata !172, metadata !DIExpression()), !dbg !173
  call void @llvm.dbg.declare(metadata [1 x i64]* %4, metadata !174, metadata !DIExpression()), !dbg !175
  store i32 1048576, i32* getelementptr inbounds (%union.rwlock_t, %union.rwlock_t* @mylock, i32 0, i32 0), align 4, !dbg !176
  call void @llvm.dbg.declare(metadata i32* %5, metadata !177, metadata !DIExpression()), !dbg !179
  store i32 0, i32* %5, align 4, !dbg !179
  br label %11, !dbg !180

11:                                               ; preds = %19, %0
  %12 = load i32, i32* %5, align 4, !dbg !181
  %13 = icmp slt i32 %12, 1, !dbg !183
  br i1 %13, label %14, label %22, !dbg !184

14:                                               ; preds = %11
  %15 = load i32, i32* %5, align 4, !dbg !185
  %16 = sext i32 %15 to i64, !dbg !186
  %17 = getelementptr inbounds [1 x i64], [1 x i64]* %2, i64 0, i64 %16, !dbg !186
  %18 = call i32 @pthread_create(i64* %17, %union.pthread_attr_t* null, i8* (i8*)* @threadR, i8* null) #6, !dbg !187
  br label %19, !dbg !187

19:                                               ; preds = %14
  %20 = load i32, i32* %5, align 4, !dbg !188
  %21 = add nsw i32 %20, 1, !dbg !188
  store i32 %21, i32* %5, align 4, !dbg !188
  br label %11, !dbg !189, !llvm.loop !190

22:                                               ; preds = %11
  call void @llvm.dbg.declare(metadata i32* %6, metadata !192, metadata !DIExpression()), !dbg !194
  store i32 0, i32* %6, align 4, !dbg !194
  br label %23, !dbg !195

23:                                               ; preds = %31, %22
  %24 = load i32, i32* %6, align 4, !dbg !196
  %25 = icmp slt i32 %24, 1, !dbg !198
  br i1 %25, label %26, label %34, !dbg !199

26:                                               ; preds = %23
  %27 = load i32, i32* %6, align 4, !dbg !200
  %28 = sext i32 %27 to i64, !dbg !201
  %29 = getelementptr inbounds [1 x i64], [1 x i64]* %3, i64 0, i64 %28, !dbg !201
  %30 = call i32 @pthread_create(i64* %29, %union.pthread_attr_t* null, i8* (i8*)* @threadW, i8* null) #6, !dbg !202
  br label %31, !dbg !202

31:                                               ; preds = %26
  %32 = load i32, i32* %6, align 4, !dbg !203
  %33 = add nsw i32 %32, 1, !dbg !203
  store i32 %33, i32* %6, align 4, !dbg !203
  br label %23, !dbg !204, !llvm.loop !205

34:                                               ; preds = %23
  call void @llvm.dbg.declare(metadata i32* %7, metadata !207, metadata !DIExpression()), !dbg !209
  store i32 0, i32* %7, align 4, !dbg !209
  br label %35, !dbg !210

35:                                               ; preds = %43, %34
  %36 = load i32, i32* %7, align 4, !dbg !211
  %37 = icmp slt i32 %36, 1, !dbg !213
  br i1 %37, label %38, label %46, !dbg !214

38:                                               ; preds = %35
  %39 = load i32, i32* %7, align 4, !dbg !215
  %40 = sext i32 %39 to i64, !dbg !216
  %41 = getelementptr inbounds [1 x i64], [1 x i64]* %4, i64 0, i64 %40, !dbg !216
  %42 = call i32 @pthread_create(i64* %41, %union.pthread_attr_t* null, i8* (i8*)* @threadRW, i8* null) #6, !dbg !217
  br label %43, !dbg !217

43:                                               ; preds = %38
  %44 = load i32, i32* %7, align 4, !dbg !218
  %45 = add nsw i32 %44, 1, !dbg !218
  store i32 %45, i32* %7, align 4, !dbg !218
  br label %35, !dbg !219, !llvm.loop !220

46:                                               ; preds = %35
  call void @llvm.dbg.declare(metadata i32* %8, metadata !222, metadata !DIExpression()), !dbg !224
  store i32 0, i32* %8, align 4, !dbg !224
  br label %47, !dbg !225

47:                                               ; preds = %56, %46
  %48 = load i32, i32* %8, align 4, !dbg !226
  %49 = icmp slt i32 %48, 1, !dbg !228
  br i1 %49, label %50, label %59, !dbg !229

50:                                               ; preds = %47
  %51 = load i32, i32* %8, align 4, !dbg !230
  %52 = sext i32 %51 to i64, !dbg !231
  %53 = getelementptr inbounds [1 x i64], [1 x i64]* %2, i64 0, i64 %52, !dbg !231
  %54 = load i64, i64* %53, align 8, !dbg !231
  %55 = call i32 @pthread_join(i64 %54, i8** null), !dbg !232
  br label %56, !dbg !232

56:                                               ; preds = %50
  %57 = load i32, i32* %8, align 4, !dbg !233
  %58 = add nsw i32 %57, 1, !dbg !233
  store i32 %58, i32* %8, align 4, !dbg !233
  br label %47, !dbg !234, !llvm.loop !235

59:                                               ; preds = %47
  call void @llvm.dbg.declare(metadata i32* %9, metadata !237, metadata !DIExpression()), !dbg !239
  store i32 0, i32* %9, align 4, !dbg !239
  br label %60, !dbg !240

60:                                               ; preds = %69, %59
  %61 = load i32, i32* %9, align 4, !dbg !241
  %62 = icmp slt i32 %61, 1, !dbg !243
  br i1 %62, label %63, label %72, !dbg !244

63:                                               ; preds = %60
  %64 = load i32, i32* %9, align 4, !dbg !245
  %65 = sext i32 %64 to i64, !dbg !246
  %66 = getelementptr inbounds [1 x i64], [1 x i64]* %3, i64 0, i64 %65, !dbg !246
  %67 = load i64, i64* %66, align 8, !dbg !246
  %68 = call i32 @pthread_join(i64 %67, i8** null), !dbg !247
  br label %69, !dbg !247

69:                                               ; preds = %63
  %70 = load i32, i32* %9, align 4, !dbg !248
  %71 = add nsw i32 %70, 1, !dbg !248
  store i32 %71, i32* %9, align 4, !dbg !248
  br label %60, !dbg !249, !llvm.loop !250

72:                                               ; preds = %60
  call void @llvm.dbg.declare(metadata i32* %10, metadata !252, metadata !DIExpression()), !dbg !254
  store i32 0, i32* %10, align 4, !dbg !254
  br label %73, !dbg !255

73:                                               ; preds = %82, %72
  %74 = load i32, i32* %10, align 4, !dbg !256
  %75 = icmp slt i32 %74, 1, !dbg !258
  br i1 %75, label %76, label %85, !dbg !259

76:                                               ; preds = %73
  %77 = load i32, i32* %10, align 4, !dbg !260
  %78 = sext i32 %77 to i64, !dbg !261
  %79 = getelementptr inbounds [1 x i64], [1 x i64]* %4, i64 0, i64 %78, !dbg !261
  %80 = load i64, i64* %79, align 8, !dbg !261
  %81 = call i32 @pthread_join(i64 %80, i8** null), !dbg !262
  br label %82, !dbg !262

82:                                               ; preds = %76
  %83 = load i32, i32* %10, align 4, !dbg !263
  %84 = add nsw i32 %83, 1, !dbg !263
  store i32 %84, i32* %10, align 4, !dbg !263
  br label %73, !dbg !264, !llvm.loop !265

85:                                               ; preds = %73
  %86 = load i32, i32* @sum, align 4, !dbg !267
  %87 = icmp eq i32 %86, 2, !dbg !267
  br i1 %87, label %88, label %89, !dbg !270

88:                                               ; preds = %85
  br label %90, !dbg !270

89:                                               ; preds = %85
  call void @__assert_fail(i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.3, i64 0, i64 0), i8* getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 82, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !267
  unreachable, !dbg !267

90:                                               ; preds = %88
  ret i32 0, !dbg !271
}

; Function Attrs: nounwind
declare dso_local i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*) #3

declare dso_local i32 @pthread_join(i64, i8**) #4

attributes #0 = { noinline nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!32, !33, !34}
!llvm.ident = !{!35}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !20, line: 20, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 12.0.0-3ubuntu1~20.04.5", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/linuxrwlock.c", directory: "/home/ponce/git/Dat3M")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 47, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/lib/llvm-12/lib/clang/12.0.0/include/stdatomic.h", directory: "")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2, isUnsigned: true)
!12 = !DIEnumerator(name: "memory_order_release", value: 3, isUnsigned: true)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4, isUnsigned: true)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5, isUnsigned: true)
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !{!0, !18, !29}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "mylock", scope: !2, file: !20, line: 17, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/locks/linuxrwlock.c", directory: "/home/ponce/git/Dat3M")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "rwlock_t", file: !22, line: 25, baseType: !23)
!22 = !DIFile(filename: "benchmarks/locks/linuxrwlock.h", directory: "/home/ponce/git/Dat3M")
!23 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !22, line: 23, size: 32, elements: !24)
!24 = !{!25}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !23, file: !22, line: 24, baseType: !26, size: 32)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 83, baseType: !27)
!27 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !28)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "shareddata", scope: !2, file: !20, line: 19, type: !31, isLocal: false, isDefinition: true)
!31 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !28)
!32 = !{i32 7, !"Dwarf Version", i32 4}
!33 = !{i32 2, !"Debug Info Version", i32 3}
!34 = !{i32 1, !"wchar_size", i32 4}
!35 = !{!"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"}
!36 = distinct !DISubprogram(name: "threadR", scope: !20, file: !20, line: 22, type: !37, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !39)
!37 = !DISubroutineType(types: !38)
!38 = !{!16, !16}
!39 = !{}
!40 = !DILocalVariable(name: "arg", arg: 1, scope: !36, file: !20, line: 22, type: !16)
!41 = !DILocation(line: 22, column: 21, scope: !36)
!42 = !DILocation(line: 24, column: 5, scope: !36)
!43 = !DILocalVariable(name: "r", scope: !36, file: !20, line: 25, type: !28)
!44 = !DILocation(line: 25, column: 9, scope: !36)
!45 = !DILocation(line: 25, column: 13, scope: !36)
!46 = !DILocation(line: 26, column: 5, scope: !47)
!47 = distinct !DILexicalBlock(scope: !48, file: !20, line: 26, column: 5)
!48 = distinct !DILexicalBlock(scope: !36, file: !20, line: 26, column: 5)
!49 = !DILocation(line: 26, column: 5, scope: !48)
!50 = !DILocation(line: 27, column: 5, scope: !36)
!51 = !DILocation(line: 29, column: 5, scope: !36)
!52 = distinct !DISubprogram(name: "read_lock", scope: !22, file: !22, line: 37, type: !53, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !39)
!53 = !DISubroutineType(types: !54)
!54 = !{null, !55}
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!56 = !DILocalVariable(name: "rw", arg: 1, scope: !52, file: !22, line: 37, type: !55)
!57 = !DILocation(line: 37, column: 40, scope: !52)
!58 = !DILocalVariable(name: "priorvalue", scope: !52, file: !22, line: 39, type: !28)
!59 = !DILocation(line: 39, column: 9, scope: !52)
!60 = !DILocation(line: 39, column: 49, scope: !52)
!61 = !DILocation(line: 39, column: 53, scope: !52)
!62 = !DILocation(line: 39, column: 22, scope: !52)
!63 = !DILocation(line: 40, column: 5, scope: !52)
!64 = !DILocation(line: 40, column: 12, scope: !52)
!65 = !DILocation(line: 40, column: 23, scope: !52)
!66 = !DILocation(line: 41, column: 36, scope: !67)
!67 = distinct !DILexicalBlock(scope: !52, file: !22, line: 40, column: 29)
!68 = !DILocation(line: 41, column: 40, scope: !67)
!69 = !DILocation(line: 41, column: 9, scope: !67)
!70 = !DILocation(line: 42, column: 9, scope: !67)
!71 = !DILocation(line: 42, column: 38, scope: !67)
!72 = !DILocation(line: 42, column: 42, scope: !67)
!73 = !DILocation(line: 42, column: 16, scope: !67)
!74 = !DILocation(line: 42, column: 70, scope: !67)
!75 = distinct !{!75, !70, !76, !77}
!76 = !DILocation(line: 42, column: 75, scope: !67)
!77 = !{!"llvm.loop.mustprogress"}
!78 = !DILocation(line: 43, column: 49, scope: !67)
!79 = !DILocation(line: 43, column: 53, scope: !67)
!80 = !DILocation(line: 43, column: 22, scope: !67)
!81 = !DILocation(line: 43, column: 20, scope: !67)
!82 = distinct !{!82, !63, !83, !77}
!83 = !DILocation(line: 44, column: 5, scope: !52)
!84 = !DILocation(line: 45, column: 1, scope: !52)
!85 = distinct !DISubprogram(name: "read_unlock", scope: !22, file: !22, line: 77, type: !53, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !39)
!86 = !DILocalVariable(name: "rw", arg: 1, scope: !85, file: !22, line: 77, type: !55)
!87 = !DILocation(line: 77, column: 42, scope: !85)
!88 = !DILocation(line: 79, column: 32, scope: !85)
!89 = !DILocation(line: 79, column: 36, scope: !85)
!90 = !DILocation(line: 79, column: 5, scope: !85)
!91 = !DILocation(line: 80, column: 1, scope: !85)
!92 = distinct !DISubprogram(name: "threadW", scope: !20, file: !20, line: 32, type: !37, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !39)
!93 = !DILocalVariable(name: "arg", arg: 1, scope: !92, file: !20, line: 32, type: !16)
!94 = !DILocation(line: 32, column: 21, scope: !92)
!95 = !DILocation(line: 34, column: 5, scope: !92)
!96 = !DILocation(line: 35, column: 16, scope: !92)
!97 = !DILocation(line: 36, column: 5, scope: !98)
!98 = distinct !DILexicalBlock(scope: !99, file: !20, line: 36, column: 5)
!99 = distinct !DILexicalBlock(scope: !92, file: !20, line: 36, column: 5)
!100 = !DILocation(line: 36, column: 5, scope: !99)
!101 = !DILocation(line: 37, column: 8, scope: !92)
!102 = !DILocation(line: 38, column: 5, scope: !92)
!103 = !DILocation(line: 40, column: 5, scope: !92)
!104 = distinct !DISubprogram(name: "write_lock", scope: !22, file: !22, line: 47, type: !53, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !39)
!105 = !DILocalVariable(name: "rw", arg: 1, scope: !104, file: !22, line: 47, type: !55)
!106 = !DILocation(line: 47, column: 41, scope: !104)
!107 = !DILocalVariable(name: "priorvalue", scope: !104, file: !22, line: 49, type: !28)
!108 = !DILocation(line: 49, column: 9, scope: !104)
!109 = !DILocation(line: 49, column: 49, scope: !104)
!110 = !DILocation(line: 49, column: 53, scope: !104)
!111 = !DILocation(line: 49, column: 22, scope: !104)
!112 = !DILocation(line: 50, column: 5, scope: !104)
!113 = !DILocation(line: 50, column: 12, scope: !104)
!114 = !DILocation(line: 50, column: 23, scope: !104)
!115 = !DILocation(line: 51, column: 36, scope: !116)
!116 = distinct !DILexicalBlock(scope: !104, file: !22, line: 50, column: 40)
!117 = !DILocation(line: 51, column: 40, scope: !116)
!118 = !DILocation(line: 51, column: 9, scope: !116)
!119 = !DILocation(line: 52, column: 9, scope: !116)
!120 = !DILocation(line: 52, column: 38, scope: !116)
!121 = !DILocation(line: 52, column: 42, scope: !116)
!122 = !DILocation(line: 52, column: 16, scope: !116)
!123 = !DILocation(line: 52, column: 70, scope: !116)
!124 = distinct !{!124, !119, !125, !77}
!125 = !DILocation(line: 52, column: 86, scope: !116)
!126 = !DILocation(line: 53, column: 49, scope: !116)
!127 = !DILocation(line: 53, column: 53, scope: !116)
!128 = !DILocation(line: 53, column: 22, scope: !116)
!129 = !DILocation(line: 53, column: 20, scope: !116)
!130 = distinct !{!130, !112, !131, !77}
!131 = !DILocation(line: 54, column: 5, scope: !104)
!132 = !DILocation(line: 55, column: 1, scope: !104)
!133 = distinct !DISubprogram(name: "write_unlock", scope: !22, file: !22, line: 82, type: !53, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !39)
!134 = !DILocalVariable(name: "rw", arg: 1, scope: !133, file: !22, line: 82, type: !55)
!135 = !DILocation(line: 82, column: 43, scope: !133)
!136 = !DILocation(line: 84, column: 32, scope: !133)
!137 = !DILocation(line: 84, column: 36, scope: !133)
!138 = !DILocation(line: 84, column: 5, scope: !133)
!139 = !DILocation(line: 85, column: 1, scope: !133)
!140 = distinct !DISubprogram(name: "threadRW", scope: !20, file: !20, line: 43, type: !37, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !39)
!141 = !DILocalVariable(name: "arg", arg: 1, scope: !140, file: !20, line: 43, type: !16)
!142 = !DILocation(line: 43, column: 22, scope: !140)
!143 = !DILocation(line: 45, column: 5, scope: !140)
!144 = !DILocalVariable(name: "r", scope: !140, file: !20, line: 46, type: !28)
!145 = !DILocation(line: 46, column: 9, scope: !140)
!146 = !DILocation(line: 46, column: 13, scope: !140)
!147 = !DILocation(line: 47, column: 5, scope: !148)
!148 = distinct !DILexicalBlock(scope: !149, file: !20, line: 47, column: 5)
!149 = distinct !DILexicalBlock(scope: !140, file: !20, line: 47, column: 5)
!150 = !DILocation(line: 47, column: 5, scope: !149)
!151 = !DILocation(line: 48, column: 5, scope: !140)
!152 = !DILocation(line: 50, column: 5, scope: !140)
!153 = !DILocation(line: 51, column: 16, scope: !140)
!154 = !DILocation(line: 52, column: 5, scope: !155)
!155 = distinct !DILexicalBlock(scope: !156, file: !20, line: 52, column: 5)
!156 = distinct !DILexicalBlock(scope: !140, file: !20, line: 52, column: 5)
!157 = !DILocation(line: 52, column: 5, scope: !156)
!158 = !DILocation(line: 53, column: 8, scope: !140)
!159 = !DILocation(line: 54, column: 5, scope: !140)
!160 = !DILocation(line: 56, column: 5, scope: !140)
!161 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 59, type: !162, scopeLine: 60, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !39)
!162 = !DISubroutineType(types: !163)
!163 = !{!28}
!164 = !DILocalVariable(name: "r", scope: !161, file: !20, line: 61, type: !165)
!165 = !DICompositeType(tag: DW_TAG_array_type, baseType: !166, size: 64, elements: !169)
!166 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !167, line: 27, baseType: !168)
!167 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "")
!168 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!169 = !{!170}
!170 = !DISubrange(count: 1)
!171 = !DILocation(line: 61, column: 15, scope: !161)
!172 = !DILocalVariable(name: "w", scope: !161, file: !20, line: 62, type: !165)
!173 = !DILocation(line: 62, column: 15, scope: !161)
!174 = !DILocalVariable(name: "rw", scope: !161, file: !20, line: 63, type: !165)
!175 = !DILocation(line: 63, column: 15, scope: !161)
!176 = !DILocation(line: 65, column: 5, scope: !161)
!177 = !DILocalVariable(name: "i", scope: !178, file: !20, line: 67, type: !28)
!178 = distinct !DILexicalBlock(scope: !161, file: !20, line: 67, column: 5)
!179 = !DILocation(line: 67, column: 14, scope: !178)
!180 = !DILocation(line: 67, column: 10, scope: !178)
!181 = !DILocation(line: 67, column: 21, scope: !182)
!182 = distinct !DILexicalBlock(scope: !178, file: !20, line: 67, column: 5)
!183 = !DILocation(line: 67, column: 23, scope: !182)
!184 = !DILocation(line: 67, column: 5, scope: !178)
!185 = !DILocation(line: 68, column: 27, scope: !182)
!186 = !DILocation(line: 68, column: 25, scope: !182)
!187 = !DILocation(line: 68, column: 9, scope: !182)
!188 = !DILocation(line: 67, column: 37, scope: !182)
!189 = !DILocation(line: 67, column: 5, scope: !182)
!190 = distinct !{!190, !184, !191, !77}
!191 = !DILocation(line: 68, column: 47, scope: !178)
!192 = !DILocalVariable(name: "i", scope: !193, file: !20, line: 69, type: !28)
!193 = distinct !DILexicalBlock(scope: !161, file: !20, line: 69, column: 5)
!194 = !DILocation(line: 69, column: 14, scope: !193)
!195 = !DILocation(line: 69, column: 10, scope: !193)
!196 = !DILocation(line: 69, column: 21, scope: !197)
!197 = distinct !DILexicalBlock(scope: !193, file: !20, line: 69, column: 5)
!198 = !DILocation(line: 69, column: 23, scope: !197)
!199 = !DILocation(line: 69, column: 5, scope: !193)
!200 = !DILocation(line: 70, column: 27, scope: !197)
!201 = !DILocation(line: 70, column: 25, scope: !197)
!202 = !DILocation(line: 70, column: 9, scope: !197)
!203 = !DILocation(line: 69, column: 37, scope: !197)
!204 = !DILocation(line: 69, column: 5, scope: !197)
!205 = distinct !{!205, !199, !206, !77}
!206 = !DILocation(line: 70, column: 47, scope: !193)
!207 = !DILocalVariable(name: "i", scope: !208, file: !20, line: 71, type: !28)
!208 = distinct !DILexicalBlock(scope: !161, file: !20, line: 71, column: 5)
!209 = !DILocation(line: 71, column: 14, scope: !208)
!210 = !DILocation(line: 71, column: 10, scope: !208)
!211 = !DILocation(line: 71, column: 21, scope: !212)
!212 = distinct !DILexicalBlock(scope: !208, file: !20, line: 71, column: 5)
!213 = !DILocation(line: 71, column: 23, scope: !212)
!214 = !DILocation(line: 71, column: 5, scope: !208)
!215 = !DILocation(line: 72, column: 28, scope: !212)
!216 = !DILocation(line: 72, column: 25, scope: !212)
!217 = !DILocation(line: 72, column: 9, scope: !212)
!218 = !DILocation(line: 71, column: 38, scope: !212)
!219 = !DILocation(line: 71, column: 5, scope: !212)
!220 = distinct !{!220, !214, !221, !77}
!221 = !DILocation(line: 72, column: 49, scope: !208)
!222 = !DILocalVariable(name: "i", scope: !223, file: !20, line: 74, type: !28)
!223 = distinct !DILexicalBlock(scope: !161, file: !20, line: 74, column: 5)
!224 = !DILocation(line: 74, column: 14, scope: !223)
!225 = !DILocation(line: 74, column: 10, scope: !223)
!226 = !DILocation(line: 74, column: 21, scope: !227)
!227 = distinct !DILexicalBlock(scope: !223, file: !20, line: 74, column: 5)
!228 = !DILocation(line: 74, column: 23, scope: !227)
!229 = !DILocation(line: 74, column: 5, scope: !223)
!230 = !DILocation(line: 75, column: 24, scope: !227)
!231 = !DILocation(line: 75, column: 22, scope: !227)
!232 = !DILocation(line: 75, column: 9, scope: !227)
!233 = !DILocation(line: 74, column: 37, scope: !227)
!234 = !DILocation(line: 74, column: 5, scope: !227)
!235 = distinct !{!235, !229, !236, !77}
!236 = !DILocation(line: 75, column: 29, scope: !223)
!237 = !DILocalVariable(name: "i", scope: !238, file: !20, line: 76, type: !28)
!238 = distinct !DILexicalBlock(scope: !161, file: !20, line: 76, column: 5)
!239 = !DILocation(line: 76, column: 14, scope: !238)
!240 = !DILocation(line: 76, column: 10, scope: !238)
!241 = !DILocation(line: 76, column: 21, scope: !242)
!242 = distinct !DILexicalBlock(scope: !238, file: !20, line: 76, column: 5)
!243 = !DILocation(line: 76, column: 23, scope: !242)
!244 = !DILocation(line: 76, column: 5, scope: !238)
!245 = !DILocation(line: 77, column: 24, scope: !242)
!246 = !DILocation(line: 77, column: 22, scope: !242)
!247 = !DILocation(line: 77, column: 9, scope: !242)
!248 = !DILocation(line: 76, column: 37, scope: !242)
!249 = !DILocation(line: 76, column: 5, scope: !242)
!250 = distinct !{!250, !244, !251, !77}
!251 = !DILocation(line: 77, column: 29, scope: !238)
!252 = !DILocalVariable(name: "i", scope: !253, file: !20, line: 78, type: !28)
!253 = distinct !DILexicalBlock(scope: !161, file: !20, line: 78, column: 5)
!254 = !DILocation(line: 78, column: 14, scope: !253)
!255 = !DILocation(line: 78, column: 10, scope: !253)
!256 = !DILocation(line: 78, column: 21, scope: !257)
!257 = distinct !DILexicalBlock(scope: !253, file: !20, line: 78, column: 5)
!258 = !DILocation(line: 78, column: 23, scope: !257)
!259 = !DILocation(line: 78, column: 5, scope: !253)
!260 = !DILocation(line: 79, column: 25, scope: !257)
!261 = !DILocation(line: 79, column: 22, scope: !257)
!262 = !DILocation(line: 79, column: 9, scope: !257)
!263 = !DILocation(line: 78, column: 38, scope: !257)
!264 = !DILocation(line: 78, column: 5, scope: !257)
!265 = distinct !{!265, !259, !266, !77}
!266 = !DILocation(line: 79, column: 30, scope: !253)
!267 = !DILocation(line: 82, column: 5, scope: !268)
!268 = distinct !DILexicalBlock(scope: !269, file: !20, line: 82, column: 5)
!269 = distinct !DILexicalBlock(scope: !161, file: !20, line: 82, column: 5)
!270 = !DILocation(line: 82, column: 5, scope: !269)
!271 = !DILocation(line: 84, column: 5, scope: !161)
