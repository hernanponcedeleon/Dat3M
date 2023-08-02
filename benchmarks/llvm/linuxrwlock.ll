; ModuleID = '/home/ponce/git/Dat3M/benchmarks/locks/linuxrwlock.c'
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
define dso_local i8* @threadR(i8* noundef %0) #0 !dbg !40 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !44, metadata !DIExpression()), !dbg !45
  call void @read_lock(%union.rwlock_t* noundef @mylock), !dbg !46
  call void @llvm.dbg.declare(metadata i32* %3, metadata !47, metadata !DIExpression()), !dbg !48
  %4 = load volatile i32, i32* @shareddata, align 4, !dbg !49
  store i32 %4, i32* %3, align 4, !dbg !48
  %5 = load i32, i32* %3, align 4, !dbg !50
  %6 = load volatile i32, i32* @shareddata, align 4, !dbg !50
  %7 = icmp eq i32 %5, %6, !dbg !50
  br i1 %7, label %8, label %9, !dbg !53

8:                                                ; preds = %1
  br label %10, !dbg !53

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 noundef 26, i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @__PRETTY_FUNCTION__.threadR, i64 0, i64 0)) #5, !dbg !50
  unreachable, !dbg !50

10:                                               ; preds = %8
  call void @read_unlock(%union.rwlock_t* noundef @mylock), !dbg !54
  ret i8* null, !dbg !55
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @read_lock(%union.rwlock_t* noundef %0) #0 !dbg !56 {
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
  call void @llvm.dbg.declare(metadata %union.rwlock_t** %2, metadata !60, metadata !DIExpression()), !dbg !61
  call void @llvm.dbg.declare(metadata i32* %3, metadata !62, metadata !DIExpression()), !dbg !63
  %11 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !64
  %12 = bitcast %union.rwlock_t* %11 to i32*, !dbg !65
  store i32 1, i32* %4, align 4, !dbg !66
  %13 = load i32, i32* %4, align 4, !dbg !66
  %14 = atomicrmw sub i32* %12, i32 %13 acquire, align 4, !dbg !66
  store i32 %14, i32* %5, align 4, !dbg !66
  %15 = load i32, i32* %5, align 4, !dbg !66
  store i32 %15, i32* %3, align 4, !dbg !63
  br label %16, !dbg !67

16:                                               ; preds = %32, %1
  %17 = load i32, i32* %3, align 4, !dbg !68
  %18 = icmp sle i32 %17, 0, !dbg !69
  br i1 %18, label %19, label %38, !dbg !67

19:                                               ; preds = %16
  %20 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !70
  %21 = bitcast %union.rwlock_t* %20 to i32*, !dbg !72
  store i32 1, i32* %6, align 4, !dbg !73
  %22 = load i32, i32* %6, align 4, !dbg !73
  %23 = atomicrmw add i32* %21, i32 %22 monotonic, align 4, !dbg !73
  store i32 %23, i32* %7, align 4, !dbg !73
  %24 = load i32, i32* %7, align 4, !dbg !73
  br label %25, !dbg !74

25:                                               ; preds = %31, %19
  %26 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !75
  %27 = bitcast %union.rwlock_t* %26 to i32*, !dbg !76
  %28 = load atomic i32, i32* %27 monotonic, align 4, !dbg !77
  store i32 %28, i32* %8, align 4, !dbg !77
  %29 = load i32, i32* %8, align 4, !dbg !77
  %30 = icmp sle i32 %29, 0, !dbg !78
  br i1 %30, label %31, label %32, !dbg !74

31:                                               ; preds = %25
  br label %25, !dbg !74, !llvm.loop !79

32:                                               ; preds = %25
  %33 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !82
  %34 = bitcast %union.rwlock_t* %33 to i32*, !dbg !83
  store i32 1, i32* %9, align 4, !dbg !84
  %35 = load i32, i32* %9, align 4, !dbg !84
  %36 = atomicrmw sub i32* %34, i32 %35 acquire, align 4, !dbg !84
  store i32 %36, i32* %10, align 4, !dbg !84
  %37 = load i32, i32* %10, align 4, !dbg !84
  store i32 %37, i32* %3, align 4, !dbg !85
  br label %16, !dbg !67, !llvm.loop !86

38:                                               ; preds = %16
  ret void, !dbg !88
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @read_unlock(%union.rwlock_t* noundef %0) #0 !dbg !89 {
  %2 = alloca %union.rwlock_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %union.rwlock_t* %0, %union.rwlock_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.rwlock_t** %2, metadata !90, metadata !DIExpression()), !dbg !91
  %5 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !92
  %6 = bitcast %union.rwlock_t* %5 to i32*, !dbg !93
  store i32 1, i32* %3, align 4, !dbg !94
  %7 = load i32, i32* %3, align 4, !dbg !94
  %8 = atomicrmw add i32* %6, i32 %7 release, align 4, !dbg !94
  store i32 %8, i32* %4, align 4, !dbg !94
  %9 = load i32, i32* %4, align 4, !dbg !94
  ret void, !dbg !95
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @threadW(i8* noundef %0) #0 !dbg !96 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !97, metadata !DIExpression()), !dbg !98
  call void @write_lock(%union.rwlock_t* noundef @mylock), !dbg !99
  store volatile i32 42, i32* @shareddata, align 4, !dbg !100
  %3 = load volatile i32, i32* @shareddata, align 4, !dbg !101
  %4 = icmp eq i32 42, %3, !dbg !101
  br i1 %4, label %5, label %6, !dbg !104

5:                                                ; preds = %1
  br label %7, !dbg !104

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 noundef 36, i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @__PRETTY_FUNCTION__.threadW, i64 0, i64 0)) #5, !dbg !101
  unreachable, !dbg !101

7:                                                ; preds = %5
  %8 = load i32, i32* @sum, align 4, !dbg !105
  %9 = add nsw i32 %8, 1, !dbg !105
  store i32 %9, i32* @sum, align 4, !dbg !105
  call void @write_unlock(%union.rwlock_t* noundef @mylock), !dbg !106
  ret i8* null, !dbg !107
}

; Function Attrs: noinline nounwind uwtable
define internal void @write_lock(%union.rwlock_t* noundef %0) #0 !dbg !108 {
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
  call void @llvm.dbg.declare(metadata %union.rwlock_t** %2, metadata !109, metadata !DIExpression()), !dbg !110
  call void @llvm.dbg.declare(metadata i32* %3, metadata !111, metadata !DIExpression()), !dbg !112
  %11 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !113
  %12 = bitcast %union.rwlock_t* %11 to i32*, !dbg !114
  store i32 1048576, i32* %4, align 4, !dbg !115
  %13 = load i32, i32* %4, align 4, !dbg !115
  %14 = atomicrmw sub i32* %12, i32 %13 acquire, align 4, !dbg !115
  store i32 %14, i32* %5, align 4, !dbg !115
  %15 = load i32, i32* %5, align 4, !dbg !115
  store i32 %15, i32* %3, align 4, !dbg !112
  br label %16, !dbg !116

16:                                               ; preds = %32, %1
  %17 = load i32, i32* %3, align 4, !dbg !117
  %18 = icmp ne i32 %17, 1048576, !dbg !118
  br i1 %18, label %19, label %38, !dbg !116

19:                                               ; preds = %16
  %20 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !119
  %21 = bitcast %union.rwlock_t* %20 to i32*, !dbg !121
  store i32 1048576, i32* %6, align 4, !dbg !122
  %22 = load i32, i32* %6, align 4, !dbg !122
  %23 = atomicrmw add i32* %21, i32 %22 monotonic, align 4, !dbg !122
  store i32 %23, i32* %7, align 4, !dbg !122
  %24 = load i32, i32* %7, align 4, !dbg !122
  br label %25, !dbg !123

25:                                               ; preds = %31, %19
  %26 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !124
  %27 = bitcast %union.rwlock_t* %26 to i32*, !dbg !125
  %28 = load atomic i32, i32* %27 monotonic, align 4, !dbg !126
  store i32 %28, i32* %8, align 4, !dbg !126
  %29 = load i32, i32* %8, align 4, !dbg !126
  %30 = icmp ne i32 %29, 1048576, !dbg !127
  br i1 %30, label %31, label %32, !dbg !123

31:                                               ; preds = %25
  br label %25, !dbg !123, !llvm.loop !128

32:                                               ; preds = %25
  %33 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !130
  %34 = bitcast %union.rwlock_t* %33 to i32*, !dbg !131
  store i32 1048576, i32* %9, align 4, !dbg !132
  %35 = load i32, i32* %9, align 4, !dbg !132
  %36 = atomicrmw sub i32* %34, i32 %35 acquire, align 4, !dbg !132
  store i32 %36, i32* %10, align 4, !dbg !132
  %37 = load i32, i32* %10, align 4, !dbg !132
  store i32 %37, i32* %3, align 4, !dbg !133
  br label %16, !dbg !116, !llvm.loop !134

38:                                               ; preds = %16
  ret void, !dbg !136
}

; Function Attrs: noinline nounwind uwtable
define internal void @write_unlock(%union.rwlock_t* noundef %0) #0 !dbg !137 {
  %2 = alloca %union.rwlock_t*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %union.rwlock_t* %0, %union.rwlock_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.rwlock_t** %2, metadata !138, metadata !DIExpression()), !dbg !139
  %5 = load %union.rwlock_t*, %union.rwlock_t** %2, align 8, !dbg !140
  %6 = bitcast %union.rwlock_t* %5 to i32*, !dbg !141
  store i32 1048576, i32* %3, align 4, !dbg !142
  %7 = load i32, i32* %3, align 4, !dbg !142
  %8 = atomicrmw add i32* %6, i32 %7 release, align 4, !dbg !142
  store i32 %8, i32* %4, align 4, !dbg !142
  %9 = load i32, i32* %4, align 4, !dbg !142
  ret void, !dbg !143
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @threadRW(i8* noundef %0) #0 !dbg !144 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !145, metadata !DIExpression()), !dbg !146
  call void @read_lock(%union.rwlock_t* noundef @mylock), !dbg !147
  call void @llvm.dbg.declare(metadata i32* %3, metadata !148, metadata !DIExpression()), !dbg !149
  %4 = load volatile i32, i32* @shareddata, align 4, !dbg !150
  store i32 %4, i32* %3, align 4, !dbg !149
  %5 = load i32, i32* %3, align 4, !dbg !151
  %6 = load volatile i32, i32* @shareddata, align 4, !dbg !151
  %7 = icmp eq i32 %5, %6, !dbg !151
  br i1 %7, label %8, label %9, !dbg !154

8:                                                ; preds = %1
  br label %10, !dbg !154

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 noundef 47, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.threadRW, i64 0, i64 0)) #5, !dbg !151
  unreachable, !dbg !151

10:                                               ; preds = %8
  call void @read_unlock(%union.rwlock_t* noundef @mylock), !dbg !155
  call void @write_lock(%union.rwlock_t* noundef @mylock), !dbg !156
  store volatile i32 42, i32* @shareddata, align 4, !dbg !157
  %11 = load volatile i32, i32* @shareddata, align 4, !dbg !158
  %12 = icmp eq i32 42, %11, !dbg !158
  br i1 %12, label %13, label %14, !dbg !161

13:                                               ; preds = %10
  br label %15, !dbg !161

14:                                               ; preds = %10
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 noundef 52, i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.threadRW, i64 0, i64 0)) #5, !dbg !158
  unreachable, !dbg !158

15:                                               ; preds = %13
  %16 = load i32, i32* @sum, align 4, !dbg !162
  %17 = add nsw i32 %16, 1, !dbg !162
  store i32 %17, i32* @sum, align 4, !dbg !162
  call void @write_unlock(%union.rwlock_t* noundef @mylock), !dbg !163
  ret i8* null, !dbg !164
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !165 {
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
  call void @llvm.dbg.declare(metadata [1 x i64]* %2, metadata !168, metadata !DIExpression()), !dbg !175
  call void @llvm.dbg.declare(metadata [1 x i64]* %3, metadata !176, metadata !DIExpression()), !dbg !177
  call void @llvm.dbg.declare(metadata [1 x i64]* %4, metadata !178, metadata !DIExpression()), !dbg !179
  store i32 1048576, i32* getelementptr inbounds (%union.rwlock_t, %union.rwlock_t* @mylock, i32 0, i32 0), align 4, !dbg !180
  call void @llvm.dbg.declare(metadata i32* %5, metadata !181, metadata !DIExpression()), !dbg !183
  store i32 0, i32* %5, align 4, !dbg !183
  br label %11, !dbg !184

11:                                               ; preds = %19, %0
  %12 = load i32, i32* %5, align 4, !dbg !185
  %13 = icmp slt i32 %12, 1, !dbg !187
  br i1 %13, label %14, label %22, !dbg !188

14:                                               ; preds = %11
  %15 = load i32, i32* %5, align 4, !dbg !189
  %16 = sext i32 %15 to i64, !dbg !190
  %17 = getelementptr inbounds [1 x i64], [1 x i64]* %2, i64 0, i64 %16, !dbg !190
  %18 = call i32 @pthread_create(i64* noundef %17, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @threadR, i8* noundef null) #6, !dbg !191
  br label %19, !dbg !191

19:                                               ; preds = %14
  %20 = load i32, i32* %5, align 4, !dbg !192
  %21 = add nsw i32 %20, 1, !dbg !192
  store i32 %21, i32* %5, align 4, !dbg !192
  br label %11, !dbg !193, !llvm.loop !194

22:                                               ; preds = %11
  call void @llvm.dbg.declare(metadata i32* %6, metadata !196, metadata !DIExpression()), !dbg !198
  store i32 0, i32* %6, align 4, !dbg !198
  br label %23, !dbg !199

23:                                               ; preds = %31, %22
  %24 = load i32, i32* %6, align 4, !dbg !200
  %25 = icmp slt i32 %24, 1, !dbg !202
  br i1 %25, label %26, label %34, !dbg !203

26:                                               ; preds = %23
  %27 = load i32, i32* %6, align 4, !dbg !204
  %28 = sext i32 %27 to i64, !dbg !205
  %29 = getelementptr inbounds [1 x i64], [1 x i64]* %3, i64 0, i64 %28, !dbg !205
  %30 = call i32 @pthread_create(i64* noundef %29, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @threadW, i8* noundef null) #6, !dbg !206
  br label %31, !dbg !206

31:                                               ; preds = %26
  %32 = load i32, i32* %6, align 4, !dbg !207
  %33 = add nsw i32 %32, 1, !dbg !207
  store i32 %33, i32* %6, align 4, !dbg !207
  br label %23, !dbg !208, !llvm.loop !209

34:                                               ; preds = %23
  call void @llvm.dbg.declare(metadata i32* %7, metadata !211, metadata !DIExpression()), !dbg !213
  store i32 0, i32* %7, align 4, !dbg !213
  br label %35, !dbg !214

35:                                               ; preds = %43, %34
  %36 = load i32, i32* %7, align 4, !dbg !215
  %37 = icmp slt i32 %36, 1, !dbg !217
  br i1 %37, label %38, label %46, !dbg !218

38:                                               ; preds = %35
  %39 = load i32, i32* %7, align 4, !dbg !219
  %40 = sext i32 %39 to i64, !dbg !220
  %41 = getelementptr inbounds [1 x i64], [1 x i64]* %4, i64 0, i64 %40, !dbg !220
  %42 = call i32 @pthread_create(i64* noundef %41, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @threadRW, i8* noundef null) #6, !dbg !221
  br label %43, !dbg !221

43:                                               ; preds = %38
  %44 = load i32, i32* %7, align 4, !dbg !222
  %45 = add nsw i32 %44, 1, !dbg !222
  store i32 %45, i32* %7, align 4, !dbg !222
  br label %35, !dbg !223, !llvm.loop !224

46:                                               ; preds = %35
  call void @llvm.dbg.declare(metadata i32* %8, metadata !226, metadata !DIExpression()), !dbg !228
  store i32 0, i32* %8, align 4, !dbg !228
  br label %47, !dbg !229

47:                                               ; preds = %56, %46
  %48 = load i32, i32* %8, align 4, !dbg !230
  %49 = icmp slt i32 %48, 1, !dbg !232
  br i1 %49, label %50, label %59, !dbg !233

50:                                               ; preds = %47
  %51 = load i32, i32* %8, align 4, !dbg !234
  %52 = sext i32 %51 to i64, !dbg !235
  %53 = getelementptr inbounds [1 x i64], [1 x i64]* %2, i64 0, i64 %52, !dbg !235
  %54 = load i64, i64* %53, align 8, !dbg !235
  %55 = call i32 @pthread_join(i64 noundef %54, i8** noundef null), !dbg !236
  br label %56, !dbg !236

56:                                               ; preds = %50
  %57 = load i32, i32* %8, align 4, !dbg !237
  %58 = add nsw i32 %57, 1, !dbg !237
  store i32 %58, i32* %8, align 4, !dbg !237
  br label %47, !dbg !238, !llvm.loop !239

59:                                               ; preds = %47
  call void @llvm.dbg.declare(metadata i32* %9, metadata !241, metadata !DIExpression()), !dbg !243
  store i32 0, i32* %9, align 4, !dbg !243
  br label %60, !dbg !244

60:                                               ; preds = %69, %59
  %61 = load i32, i32* %9, align 4, !dbg !245
  %62 = icmp slt i32 %61, 1, !dbg !247
  br i1 %62, label %63, label %72, !dbg !248

63:                                               ; preds = %60
  %64 = load i32, i32* %9, align 4, !dbg !249
  %65 = sext i32 %64 to i64, !dbg !250
  %66 = getelementptr inbounds [1 x i64], [1 x i64]* %3, i64 0, i64 %65, !dbg !250
  %67 = load i64, i64* %66, align 8, !dbg !250
  %68 = call i32 @pthread_join(i64 noundef %67, i8** noundef null), !dbg !251
  br label %69, !dbg !251

69:                                               ; preds = %63
  %70 = load i32, i32* %9, align 4, !dbg !252
  %71 = add nsw i32 %70, 1, !dbg !252
  store i32 %71, i32* %9, align 4, !dbg !252
  br label %60, !dbg !253, !llvm.loop !254

72:                                               ; preds = %60
  call void @llvm.dbg.declare(metadata i32* %10, metadata !256, metadata !DIExpression()), !dbg !258
  store i32 0, i32* %10, align 4, !dbg !258
  br label %73, !dbg !259

73:                                               ; preds = %82, %72
  %74 = load i32, i32* %10, align 4, !dbg !260
  %75 = icmp slt i32 %74, 1, !dbg !262
  br i1 %75, label %76, label %85, !dbg !263

76:                                               ; preds = %73
  %77 = load i32, i32* %10, align 4, !dbg !264
  %78 = sext i32 %77 to i64, !dbg !265
  %79 = getelementptr inbounds [1 x i64], [1 x i64]* %4, i64 0, i64 %78, !dbg !265
  %80 = load i64, i64* %79, align 8, !dbg !265
  %81 = call i32 @pthread_join(i64 noundef %80, i8** noundef null), !dbg !266
  br label %82, !dbg !266

82:                                               ; preds = %76
  %83 = load i32, i32* %10, align 4, !dbg !267
  %84 = add nsw i32 %83, 1, !dbg !267
  store i32 %84, i32* %10, align 4, !dbg !267
  br label %73, !dbg !268, !llvm.loop !269

85:                                               ; preds = %73
  %86 = load i32, i32* @sum, align 4, !dbg !271
  %87 = icmp eq i32 %86, 2, !dbg !271
  br i1 %87, label %88, label %89, !dbg !274

88:                                               ; preds = %85
  br label %90, !dbg !274

89:                                               ; preds = %85
  call void @__assert_fail(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @.str.1, i64 0, i64 0), i32 noundef 82, i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !271
  unreachable, !dbg !271

90:                                               ; preds = %88
  ret i32 0, !dbg !275
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!32, !33, !34, !35, !36, !37, !38}
!llvm.ident = !{!39}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !20, line: 20, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/locks/linuxrwlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "82bde948e91e2195f082ea6f49ac075d")
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
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !{!0, !18, !29}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "mylock", scope: !2, file: !20, line: 17, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "benchmarks/locks/linuxrwlock.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "82bde948e91e2195f082ea6f49ac075d")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "rwlock_t", file: !22, line: 18, baseType: !23)
!22 = !DIFile(filename: "benchmarks/locks/linuxrwlock.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "1f16d6841e8abb6de3ad57078215b0e5")
!23 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !22, line: 16, size: 32, elements: !24)
!24 = !{!25}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !23, file: !22, line: 17, baseType: !26, size: 32)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !27)
!27 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !28)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "shareddata", scope: !2, file: !20, line: 19, type: !31, isLocal: false, isDefinition: true)
!31 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !28)
!32 = !{i32 7, !"Dwarf Version", i32 5}
!33 = !{i32 2, !"Debug Info Version", i32 3}
!34 = !{i32 1, !"wchar_size", i32 4}
!35 = !{i32 7, !"PIC Level", i32 2}
!36 = !{i32 7, !"PIE Level", i32 2}
!37 = !{i32 7, !"uwtable", i32 1}
!38 = !{i32 7, !"frame-pointer", i32 2}
!39 = !{!"Ubuntu clang version 14.0.6"}
!40 = distinct !DISubprogram(name: "threadR", scope: !20, file: !20, line: 22, type: !41, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!41 = !DISubroutineType(types: !42)
!42 = !{!16, !16}
!43 = !{}
!44 = !DILocalVariable(name: "arg", arg: 1, scope: !40, file: !20, line: 22, type: !16)
!45 = !DILocation(line: 22, column: 21, scope: !40)
!46 = !DILocation(line: 24, column: 5, scope: !40)
!47 = !DILocalVariable(name: "r", scope: !40, file: !20, line: 25, type: !28)
!48 = !DILocation(line: 25, column: 9, scope: !40)
!49 = !DILocation(line: 25, column: 13, scope: !40)
!50 = !DILocation(line: 26, column: 5, scope: !51)
!51 = distinct !DILexicalBlock(scope: !52, file: !20, line: 26, column: 5)
!52 = distinct !DILexicalBlock(scope: !40, file: !20, line: 26, column: 5)
!53 = !DILocation(line: 26, column: 5, scope: !52)
!54 = !DILocation(line: 27, column: 5, scope: !40)
!55 = !DILocation(line: 29, column: 5, scope: !40)
!56 = distinct !DISubprogram(name: "read_lock", scope: !22, file: !22, line: 30, type: !57, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !43)
!57 = !DISubroutineType(types: !58)
!58 = !{null, !59}
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!60 = !DILocalVariable(name: "rw", arg: 1, scope: !56, file: !22, line: 30, type: !59)
!61 = !DILocation(line: 30, column: 40, scope: !56)
!62 = !DILocalVariable(name: "priorvalue", scope: !56, file: !22, line: 32, type: !28)
!63 = !DILocation(line: 32, column: 9, scope: !56)
!64 = !DILocation(line: 32, column: 49, scope: !56)
!65 = !DILocation(line: 32, column: 53, scope: !56)
!66 = !DILocation(line: 32, column: 22, scope: !56)
!67 = !DILocation(line: 33, column: 5, scope: !56)
!68 = !DILocation(line: 33, column: 12, scope: !56)
!69 = !DILocation(line: 33, column: 23, scope: !56)
!70 = !DILocation(line: 34, column: 36, scope: !71)
!71 = distinct !DILexicalBlock(scope: !56, file: !22, line: 33, column: 29)
!72 = !DILocation(line: 34, column: 40, scope: !71)
!73 = !DILocation(line: 34, column: 9, scope: !71)
!74 = !DILocation(line: 35, column: 9, scope: !71)
!75 = !DILocation(line: 35, column: 38, scope: !71)
!76 = !DILocation(line: 35, column: 42, scope: !71)
!77 = !DILocation(line: 35, column: 16, scope: !71)
!78 = !DILocation(line: 35, column: 70, scope: !71)
!79 = distinct !{!79, !74, !80, !81}
!80 = !DILocation(line: 35, column: 75, scope: !71)
!81 = !{!"llvm.loop.mustprogress"}
!82 = !DILocation(line: 36, column: 49, scope: !71)
!83 = !DILocation(line: 36, column: 53, scope: !71)
!84 = !DILocation(line: 36, column: 22, scope: !71)
!85 = !DILocation(line: 36, column: 20, scope: !71)
!86 = distinct !{!86, !67, !87, !81}
!87 = !DILocation(line: 37, column: 5, scope: !56)
!88 = !DILocation(line: 38, column: 1, scope: !56)
!89 = distinct !DISubprogram(name: "read_unlock", scope: !22, file: !22, line: 70, type: !57, scopeLine: 71, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !43)
!90 = !DILocalVariable(name: "rw", arg: 1, scope: !89, file: !22, line: 70, type: !59)
!91 = !DILocation(line: 70, column: 42, scope: !89)
!92 = !DILocation(line: 72, column: 32, scope: !89)
!93 = !DILocation(line: 72, column: 36, scope: !89)
!94 = !DILocation(line: 72, column: 5, scope: !89)
!95 = !DILocation(line: 73, column: 1, scope: !89)
!96 = distinct !DISubprogram(name: "threadW", scope: !20, file: !20, line: 32, type: !41, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!97 = !DILocalVariable(name: "arg", arg: 1, scope: !96, file: !20, line: 32, type: !16)
!98 = !DILocation(line: 32, column: 21, scope: !96)
!99 = !DILocation(line: 34, column: 5, scope: !96)
!100 = !DILocation(line: 35, column: 16, scope: !96)
!101 = !DILocation(line: 36, column: 5, scope: !102)
!102 = distinct !DILexicalBlock(scope: !103, file: !20, line: 36, column: 5)
!103 = distinct !DILexicalBlock(scope: !96, file: !20, line: 36, column: 5)
!104 = !DILocation(line: 36, column: 5, scope: !103)
!105 = !DILocation(line: 37, column: 8, scope: !96)
!106 = !DILocation(line: 38, column: 5, scope: !96)
!107 = !DILocation(line: 40, column: 5, scope: !96)
!108 = distinct !DISubprogram(name: "write_lock", scope: !22, file: !22, line: 40, type: !57, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !43)
!109 = !DILocalVariable(name: "rw", arg: 1, scope: !108, file: !22, line: 40, type: !59)
!110 = !DILocation(line: 40, column: 41, scope: !108)
!111 = !DILocalVariable(name: "priorvalue", scope: !108, file: !22, line: 42, type: !28)
!112 = !DILocation(line: 42, column: 9, scope: !108)
!113 = !DILocation(line: 42, column: 49, scope: !108)
!114 = !DILocation(line: 42, column: 53, scope: !108)
!115 = !DILocation(line: 42, column: 22, scope: !108)
!116 = !DILocation(line: 43, column: 5, scope: !108)
!117 = !DILocation(line: 43, column: 12, scope: !108)
!118 = !DILocation(line: 43, column: 23, scope: !108)
!119 = !DILocation(line: 44, column: 36, scope: !120)
!120 = distinct !DILexicalBlock(scope: !108, file: !22, line: 43, column: 40)
!121 = !DILocation(line: 44, column: 40, scope: !120)
!122 = !DILocation(line: 44, column: 9, scope: !120)
!123 = !DILocation(line: 45, column: 9, scope: !120)
!124 = !DILocation(line: 45, column: 38, scope: !120)
!125 = !DILocation(line: 45, column: 42, scope: !120)
!126 = !DILocation(line: 45, column: 16, scope: !120)
!127 = !DILocation(line: 45, column: 70, scope: !120)
!128 = distinct !{!128, !123, !129, !81}
!129 = !DILocation(line: 45, column: 86, scope: !120)
!130 = !DILocation(line: 46, column: 49, scope: !120)
!131 = !DILocation(line: 46, column: 53, scope: !120)
!132 = !DILocation(line: 46, column: 22, scope: !120)
!133 = !DILocation(line: 46, column: 20, scope: !120)
!134 = distinct !{!134, !116, !135, !81}
!135 = !DILocation(line: 47, column: 5, scope: !108)
!136 = !DILocation(line: 48, column: 1, scope: !108)
!137 = distinct !DISubprogram(name: "write_unlock", scope: !22, file: !22, line: 75, type: !57, scopeLine: 76, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !43)
!138 = !DILocalVariable(name: "rw", arg: 1, scope: !137, file: !22, line: 75, type: !59)
!139 = !DILocation(line: 75, column: 43, scope: !137)
!140 = !DILocation(line: 77, column: 32, scope: !137)
!141 = !DILocation(line: 77, column: 36, scope: !137)
!142 = !DILocation(line: 77, column: 5, scope: !137)
!143 = !DILocation(line: 78, column: 1, scope: !137)
!144 = distinct !DISubprogram(name: "threadRW", scope: !20, file: !20, line: 43, type: !41, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!145 = !DILocalVariable(name: "arg", arg: 1, scope: !144, file: !20, line: 43, type: !16)
!146 = !DILocation(line: 43, column: 22, scope: !144)
!147 = !DILocation(line: 45, column: 5, scope: !144)
!148 = !DILocalVariable(name: "r", scope: !144, file: !20, line: 46, type: !28)
!149 = !DILocation(line: 46, column: 9, scope: !144)
!150 = !DILocation(line: 46, column: 13, scope: !144)
!151 = !DILocation(line: 47, column: 5, scope: !152)
!152 = distinct !DILexicalBlock(scope: !153, file: !20, line: 47, column: 5)
!153 = distinct !DILexicalBlock(scope: !144, file: !20, line: 47, column: 5)
!154 = !DILocation(line: 47, column: 5, scope: !153)
!155 = !DILocation(line: 48, column: 5, scope: !144)
!156 = !DILocation(line: 50, column: 5, scope: !144)
!157 = !DILocation(line: 51, column: 16, scope: !144)
!158 = !DILocation(line: 52, column: 5, scope: !159)
!159 = distinct !DILexicalBlock(scope: !160, file: !20, line: 52, column: 5)
!160 = distinct !DILexicalBlock(scope: !144, file: !20, line: 52, column: 5)
!161 = !DILocation(line: 52, column: 5, scope: !160)
!162 = !DILocation(line: 53, column: 8, scope: !144)
!163 = !DILocation(line: 54, column: 5, scope: !144)
!164 = !DILocation(line: 56, column: 5, scope: !144)
!165 = distinct !DISubprogram(name: "main", scope: !20, file: !20, line: 59, type: !166, scopeLine: 60, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !43)
!166 = !DISubroutineType(types: !167)
!167 = !{!28}
!168 = !DILocalVariable(name: "r", scope: !165, file: !20, line: 61, type: !169)
!169 = !DICompositeType(tag: DW_TAG_array_type, baseType: !170, size: 64, elements: !173)
!170 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !171, line: 27, baseType: !172)
!171 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!172 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!173 = !{!174}
!174 = !DISubrange(count: 1)
!175 = !DILocation(line: 61, column: 15, scope: !165)
!176 = !DILocalVariable(name: "w", scope: !165, file: !20, line: 62, type: !169)
!177 = !DILocation(line: 62, column: 15, scope: !165)
!178 = !DILocalVariable(name: "rw", scope: !165, file: !20, line: 63, type: !169)
!179 = !DILocation(line: 63, column: 15, scope: !165)
!180 = !DILocation(line: 65, column: 5, scope: !165)
!181 = !DILocalVariable(name: "i", scope: !182, file: !20, line: 67, type: !28)
!182 = distinct !DILexicalBlock(scope: !165, file: !20, line: 67, column: 5)
!183 = !DILocation(line: 67, column: 14, scope: !182)
!184 = !DILocation(line: 67, column: 10, scope: !182)
!185 = !DILocation(line: 67, column: 21, scope: !186)
!186 = distinct !DILexicalBlock(scope: !182, file: !20, line: 67, column: 5)
!187 = !DILocation(line: 67, column: 23, scope: !186)
!188 = !DILocation(line: 67, column: 5, scope: !182)
!189 = !DILocation(line: 68, column: 27, scope: !186)
!190 = !DILocation(line: 68, column: 25, scope: !186)
!191 = !DILocation(line: 68, column: 9, scope: !186)
!192 = !DILocation(line: 67, column: 37, scope: !186)
!193 = !DILocation(line: 67, column: 5, scope: !186)
!194 = distinct !{!194, !188, !195, !81}
!195 = !DILocation(line: 68, column: 47, scope: !182)
!196 = !DILocalVariable(name: "i", scope: !197, file: !20, line: 69, type: !28)
!197 = distinct !DILexicalBlock(scope: !165, file: !20, line: 69, column: 5)
!198 = !DILocation(line: 69, column: 14, scope: !197)
!199 = !DILocation(line: 69, column: 10, scope: !197)
!200 = !DILocation(line: 69, column: 21, scope: !201)
!201 = distinct !DILexicalBlock(scope: !197, file: !20, line: 69, column: 5)
!202 = !DILocation(line: 69, column: 23, scope: !201)
!203 = !DILocation(line: 69, column: 5, scope: !197)
!204 = !DILocation(line: 70, column: 27, scope: !201)
!205 = !DILocation(line: 70, column: 25, scope: !201)
!206 = !DILocation(line: 70, column: 9, scope: !201)
!207 = !DILocation(line: 69, column: 37, scope: !201)
!208 = !DILocation(line: 69, column: 5, scope: !201)
!209 = distinct !{!209, !203, !210, !81}
!210 = !DILocation(line: 70, column: 47, scope: !197)
!211 = !DILocalVariable(name: "i", scope: !212, file: !20, line: 71, type: !28)
!212 = distinct !DILexicalBlock(scope: !165, file: !20, line: 71, column: 5)
!213 = !DILocation(line: 71, column: 14, scope: !212)
!214 = !DILocation(line: 71, column: 10, scope: !212)
!215 = !DILocation(line: 71, column: 21, scope: !216)
!216 = distinct !DILexicalBlock(scope: !212, file: !20, line: 71, column: 5)
!217 = !DILocation(line: 71, column: 23, scope: !216)
!218 = !DILocation(line: 71, column: 5, scope: !212)
!219 = !DILocation(line: 72, column: 28, scope: !216)
!220 = !DILocation(line: 72, column: 25, scope: !216)
!221 = !DILocation(line: 72, column: 9, scope: !216)
!222 = !DILocation(line: 71, column: 38, scope: !216)
!223 = !DILocation(line: 71, column: 5, scope: !216)
!224 = distinct !{!224, !218, !225, !81}
!225 = !DILocation(line: 72, column: 49, scope: !212)
!226 = !DILocalVariable(name: "i", scope: !227, file: !20, line: 74, type: !28)
!227 = distinct !DILexicalBlock(scope: !165, file: !20, line: 74, column: 5)
!228 = !DILocation(line: 74, column: 14, scope: !227)
!229 = !DILocation(line: 74, column: 10, scope: !227)
!230 = !DILocation(line: 74, column: 21, scope: !231)
!231 = distinct !DILexicalBlock(scope: !227, file: !20, line: 74, column: 5)
!232 = !DILocation(line: 74, column: 23, scope: !231)
!233 = !DILocation(line: 74, column: 5, scope: !227)
!234 = !DILocation(line: 75, column: 24, scope: !231)
!235 = !DILocation(line: 75, column: 22, scope: !231)
!236 = !DILocation(line: 75, column: 9, scope: !231)
!237 = !DILocation(line: 74, column: 37, scope: !231)
!238 = !DILocation(line: 74, column: 5, scope: !231)
!239 = distinct !{!239, !233, !240, !81}
!240 = !DILocation(line: 75, column: 29, scope: !227)
!241 = !DILocalVariable(name: "i", scope: !242, file: !20, line: 76, type: !28)
!242 = distinct !DILexicalBlock(scope: !165, file: !20, line: 76, column: 5)
!243 = !DILocation(line: 76, column: 14, scope: !242)
!244 = !DILocation(line: 76, column: 10, scope: !242)
!245 = !DILocation(line: 76, column: 21, scope: !246)
!246 = distinct !DILexicalBlock(scope: !242, file: !20, line: 76, column: 5)
!247 = !DILocation(line: 76, column: 23, scope: !246)
!248 = !DILocation(line: 76, column: 5, scope: !242)
!249 = !DILocation(line: 77, column: 24, scope: !246)
!250 = !DILocation(line: 77, column: 22, scope: !246)
!251 = !DILocation(line: 77, column: 9, scope: !246)
!252 = !DILocation(line: 76, column: 37, scope: !246)
!253 = !DILocation(line: 76, column: 5, scope: !246)
!254 = distinct !{!254, !248, !255, !81}
!255 = !DILocation(line: 77, column: 29, scope: !242)
!256 = !DILocalVariable(name: "i", scope: !257, file: !20, line: 78, type: !28)
!257 = distinct !DILexicalBlock(scope: !165, file: !20, line: 78, column: 5)
!258 = !DILocation(line: 78, column: 14, scope: !257)
!259 = !DILocation(line: 78, column: 10, scope: !257)
!260 = !DILocation(line: 78, column: 21, scope: !261)
!261 = distinct !DILexicalBlock(scope: !257, file: !20, line: 78, column: 5)
!262 = !DILocation(line: 78, column: 23, scope: !261)
!263 = !DILocation(line: 78, column: 5, scope: !257)
!264 = !DILocation(line: 79, column: 25, scope: !261)
!265 = !DILocation(line: 79, column: 22, scope: !261)
!266 = !DILocation(line: 79, column: 9, scope: !261)
!267 = !DILocation(line: 78, column: 38, scope: !261)
!268 = !DILocation(line: 78, column: 5, scope: !261)
!269 = distinct !{!269, !263, !270, !81}
!270 = !DILocation(line: 79, column: 30, scope: !257)
!271 = !DILocation(line: 82, column: 5, scope: !272)
!272 = distinct !DILexicalBlock(scope: !273, file: !20, line: 82, column: 5)
!273 = distinct !DILexicalBlock(scope: !165, file: !20, line: 82, column: 5)
!274 = !DILocation(line: 82, column: 5, scope: !273)
!275 = !DILocation(line: 84, column: 5, scope: !165)
