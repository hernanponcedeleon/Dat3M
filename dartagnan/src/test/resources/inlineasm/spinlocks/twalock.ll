; ModuleID = '/home/stefano/huawei/libvsync/spinlock/test/twalock.c'
source_filename = "/home/stefano/huawei/libvsync/spinlock/test/twalock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.twalock_s = type { %struct.vatomic32_s, %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%struct.twa_counter_s = type { %struct.vatomic32_s }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !41
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [68 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 0 + 0)\00", align 1
@lock = dso_local global %struct.twalock_s zeroinitializer, align 4, !dbg !12
@__twa_array = dso_local global [128 x %struct.twa_counter_s] zeroinitializer, align 16, !dbg !32

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !52 {
  ret void, !dbg !56
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !57 {
  ret void, !dbg !58
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !59 {
  ret void, !dbg !60
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !61 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !62
  %2 = add i32 %1, 1, !dbg !62
  store i32 %2, i32* @g_cs_x, align 4, !dbg !62
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !63
  %4 = add i32 %3, 1, !dbg !63
  store i32 %4, i32* @g_cs_y, align 4, !dbg !63
  ret void, !dbg !64
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !65 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !66
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !66
  %3 = icmp eq i32 %1, %2, !dbg !66
  br i1 %3, label %4, label %5, !dbg !69

4:                                                ; preds = %0
  br label %6, !dbg !69

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 112, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !66
  unreachable, !dbg !66

6:                                                ; preds = %4
  %7 = load i32, i32* @g_cs_x, align 4, !dbg !70
  %8 = icmp eq i32 %7, 3, !dbg !70
  br i1 %8, label %9, label %10, !dbg !73

9:                                                ; preds = %6
  br label %11, !dbg !73

10:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 113, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !70
  unreachable, !dbg !70

11:                                               ; preds = %9
  ret void, !dbg !74
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !75 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i64]* %2, metadata !79, metadata !DIExpression()), !dbg !85
  call void @init(), !dbg !86
  call void @llvm.dbg.declare(metadata i64* %3, metadata !87, metadata !DIExpression()), !dbg !89
  store i64 0, i64* %3, align 8, !dbg !89
  br label %5, !dbg !90

5:                                                ; preds = %14, %0
  %6 = load i64, i64* %3, align 8, !dbg !91
  %7 = icmp ult i64 %6, 3, !dbg !93
  br i1 %7, label %8, label %17, !dbg !94

8:                                                ; preds = %5
  %9 = load i64, i64* %3, align 8, !dbg !95
  %10 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %9, !dbg !97
  %11 = load i64, i64* %3, align 8, !dbg !98
  %12 = inttoptr i64 %11 to i8*, !dbg !99
  %13 = call i32 @pthread_create(i64* noundef %10, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef %12) #6, !dbg !100
  br label %14, !dbg !101

14:                                               ; preds = %8
  %15 = load i64, i64* %3, align 8, !dbg !102
  %16 = add i64 %15, 1, !dbg !102
  store i64 %16, i64* %3, align 8, !dbg !102
  br label %5, !dbg !103, !llvm.loop !104

17:                                               ; preds = %5
  call void @post(), !dbg !107
  call void @llvm.dbg.declare(metadata i64* %4, metadata !108, metadata !DIExpression()), !dbg !110
  store i64 0, i64* %4, align 8, !dbg !110
  br label %18, !dbg !111

18:                                               ; preds = %26, %17
  %19 = load i64, i64* %4, align 8, !dbg !112
  %20 = icmp ult i64 %19, 3, !dbg !114
  br i1 %20, label %21, label %29, !dbg !115

21:                                               ; preds = %18
  %22 = load i64, i64* %4, align 8, !dbg !116
  %23 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %22, !dbg !118
  %24 = load i64, i64* %23, align 8, !dbg !118
  %25 = call i32 @pthread_join(i64 noundef %24, i8** noundef null), !dbg !119
  br label %26, !dbg !120

26:                                               ; preds = %21
  %27 = load i64, i64* %4, align 8, !dbg !121
  %28 = add i64 %27, 1, !dbg !121
  store i64 %28, i64* %4, align 8, !dbg !121
  br label %18, !dbg !122, !llvm.loop !123

29:                                               ; preds = %18
  call void @check(), !dbg !125
  call void @fini(), !dbg !126
  ret i32 0, !dbg !127
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !128 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !131, metadata !DIExpression()), !dbg !132
  call void @llvm.dbg.declare(metadata i32* %3, metadata !133, metadata !DIExpression()), !dbg !134
  %7 = load i8*, i8** %2, align 8, !dbg !135
  %8 = ptrtoint i8* %7 to i64, !dbg !136
  %9 = trunc i64 %8 to i32, !dbg !136
  store i32 %9, i32* %3, align 4, !dbg !134
  call void @llvm.dbg.declare(metadata i32* %4, metadata !137, metadata !DIExpression()), !dbg !139
  store i32 0, i32* %4, align 4, !dbg !139
  br label %10, !dbg !140

10:                                               ; preds = %65, %1
  %11 = load i32, i32* %4, align 4, !dbg !141
  %12 = icmp eq i32 %11, 0, !dbg !143
  br i1 %12, label %22, label %13, !dbg !144

13:                                               ; preds = %10
  %14 = load i32, i32* %4, align 4, !dbg !145
  %15 = icmp eq i32 %14, 1, !dbg !145
  br i1 %15, label %16, label %20, !dbg !145

16:                                               ; preds = %13
  %17 = load i32, i32* %3, align 4, !dbg !145
  %18 = add i32 %17, 1, !dbg !145
  %19 = icmp ult i32 %18, 1, !dbg !145
  br label %20

20:                                               ; preds = %16, %13
  %21 = phi i1 [ false, %13 ], [ %19, %16 ], !dbg !146
  br label %22, !dbg !144

22:                                               ; preds = %20, %10
  %23 = phi i1 [ true, %10 ], [ %21, %20 ]
  br i1 %23, label %24, label %68, !dbg !147

24:                                               ; preds = %22
  call void @llvm.dbg.declare(metadata i32* %5, metadata !148, metadata !DIExpression()), !dbg !151
  store i32 0, i32* %5, align 4, !dbg !151
  br label %25, !dbg !152

25:                                               ; preds = %41, %24
  %26 = load i32, i32* %5, align 4, !dbg !153
  %27 = icmp eq i32 %26, 0, !dbg !155
  br i1 %27, label %37, label %28, !dbg !156

28:                                               ; preds = %25
  %29 = load i32, i32* %5, align 4, !dbg !157
  %30 = icmp eq i32 %29, 1, !dbg !157
  br i1 %30, label %31, label %35, !dbg !157

31:                                               ; preds = %28
  %32 = load i32, i32* %3, align 4, !dbg !157
  %33 = add i32 %32, 1, !dbg !157
  %34 = icmp ult i32 %33, 1, !dbg !157
  br label %35

35:                                               ; preds = %31, %28
  %36 = phi i1 [ false, %28 ], [ %34, %31 ], !dbg !158
  br label %37, !dbg !156

37:                                               ; preds = %35, %25
  %38 = phi i1 [ true, %25 ], [ %36, %35 ]
  br i1 %38, label %39, label %44, !dbg !159

39:                                               ; preds = %37
  %40 = load i32, i32* %3, align 4, !dbg !160
  call void @acquire(i32 noundef %40), !dbg !162
  call void @cs(), !dbg !163
  br label %41, !dbg !164

41:                                               ; preds = %39
  %42 = load i32, i32* %5, align 4, !dbg !165
  %43 = add nsw i32 %42, 1, !dbg !165
  store i32 %43, i32* %5, align 4, !dbg !165
  br label %25, !dbg !166, !llvm.loop !167

44:                                               ; preds = %37
  call void @llvm.dbg.declare(metadata i32* %6, metadata !169, metadata !DIExpression()), !dbg !171
  store i32 0, i32* %6, align 4, !dbg !171
  br label %45, !dbg !172

45:                                               ; preds = %61, %44
  %46 = load i32, i32* %6, align 4, !dbg !173
  %47 = icmp eq i32 %46, 0, !dbg !175
  br i1 %47, label %57, label %48, !dbg !176

48:                                               ; preds = %45
  %49 = load i32, i32* %6, align 4, !dbg !177
  %50 = icmp eq i32 %49, 1, !dbg !177
  br i1 %50, label %51, label %55, !dbg !177

51:                                               ; preds = %48
  %52 = load i32, i32* %3, align 4, !dbg !177
  %53 = add i32 %52, 1, !dbg !177
  %54 = icmp ult i32 %53, 1, !dbg !177
  br label %55

55:                                               ; preds = %51, %48
  %56 = phi i1 [ false, %48 ], [ %54, %51 ], !dbg !178
  br label %57, !dbg !176

57:                                               ; preds = %55, %45
  %58 = phi i1 [ true, %45 ], [ %56, %55 ]
  br i1 %58, label %59, label %64, !dbg !179

59:                                               ; preds = %57
  %60 = load i32, i32* %3, align 4, !dbg !180
  call void @release(i32 noundef %60), !dbg !182
  br label %61, !dbg !183

61:                                               ; preds = %59
  %62 = load i32, i32* %6, align 4, !dbg !184
  %63 = add nsw i32 %62, 1, !dbg !184
  store i32 %63, i32* %6, align 4, !dbg !184
  br label %45, !dbg !185, !llvm.loop !186

64:                                               ; preds = %57
  br label %65, !dbg !188

65:                                               ; preds = %64
  %66 = load i32, i32* %4, align 4, !dbg !189
  %67 = add nsw i32 %66, 1, !dbg !189
  store i32 %67, i32* %4, align 4, !dbg !189
  br label %10, !dbg !190, !llvm.loop !191

68:                                               ; preds = %22
  ret i8* null, !dbg !193
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !194 {
  %2 = alloca i32, align 4
  %3 = alloca i8, align 1
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !197, metadata !DIExpression()), !dbg !198
  %4 = load i32, i32* %2, align 4, !dbg !199
  %5 = icmp eq i32 %4, 2, !dbg !201
  br i1 %5, label %6, label %11, !dbg !202

6:                                                ; preds = %1
  call void @llvm.dbg.declare(metadata i8* %3, metadata !203, metadata !DIExpression()), !dbg !207
  %7 = call zeroext i1 @twalock_tryacquire(%struct.twalock_s* noundef @lock), !dbg !208
  %8 = zext i1 %7 to i8, !dbg !207
  store i8 %8, i8* %3, align 1, !dbg !207
  %9 = load i8, i8* %3, align 1, !dbg !209
  %10 = trunc i8 %9 to i1, !dbg !209
  call void @verification_assume(i1 noundef zeroext %10), !dbg !210
  br label %12, !dbg !211

11:                                               ; preds = %1
  call void @twalock_acquire(%struct.twalock_s* noundef @lock), !dbg !212
  br label %12

12:                                               ; preds = %11, %6
  ret void, !dbg !214
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @twalock_tryacquire(%struct.twalock_s* noundef %0) #0 !dbg !215 {
  %2 = alloca %struct.twalock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.twalock_s* %0, %struct.twalock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.twalock_s** %2, metadata !219, metadata !DIExpression()), !dbg !220
  call void @llvm.dbg.declare(metadata i32* %3, metadata !221, metadata !DIExpression()), !dbg !222
  %4 = load %struct.twalock_s*, %struct.twalock_s** %2, align 8, !dbg !223
  %5 = getelementptr inbounds %struct.twalock_s, %struct.twalock_s* %4, i32 0, i32 1, !dbg !224
  %6 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %5), !dbg !225
  store i32 %6, i32* %3, align 4, !dbg !222
  %7 = load %struct.twalock_s*, %struct.twalock_s** %2, align 8, !dbg !226
  %8 = getelementptr inbounds %struct.twalock_s, %struct.twalock_s* %7, i32 0, i32 0, !dbg !227
  %9 = load i32, i32* %3, align 4, !dbg !228
  %10 = load i32, i32* %3, align 4, !dbg !229
  %11 = add i32 %10, 1, !dbg !230
  %12 = call i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %8, i32 noundef %9, i32 noundef %11), !dbg !231
  %13 = load i32, i32* %3, align 4, !dbg !232
  %14 = icmp eq i32 %12, %13, !dbg !233
  ret i1 %14, !dbg !234
}

; Function Attrs: noinline nounwind uwtable
define internal void @verification_assume(i1 noundef zeroext %0) #0 !dbg !235 {
  %2 = alloca i8, align 1
  %3 = zext i1 %0 to i8
  store i8 %3, i8* %2, align 1
  call void @llvm.dbg.declare(metadata i8* %2, metadata !239, metadata !DIExpression()), !dbg !240
  %4 = load i8, i8* %2, align 1, !dbg !241
  %5 = trunc i8 %4 to i1, !dbg !241
  %6 = zext i1 %5 to i32, !dbg !241
  %7 = call i32 (i32, ...) bitcast (i32 (...)* @__VERIFIER_assume to i32 (i32, ...)*)(i32 noundef %6), !dbg !242
  ret void, !dbg !243
}

; Function Attrs: noinline nounwind uwtable
define internal void @twalock_acquire(%struct.twalock_s* noundef %0) #0 !dbg !244 {
  %2 = alloca %struct.twalock_s*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %struct.twalock_s* %0, %struct.twalock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.twalock_s** %2, metadata !247, metadata !DIExpression()), !dbg !248
  call void @llvm.dbg.declare(metadata i32* %3, metadata !249, metadata !DIExpression()), !dbg !250
  %5 = load %struct.twalock_s*, %struct.twalock_s** %2, align 8, !dbg !251
  %6 = getelementptr inbounds %struct.twalock_s, %struct.twalock_s* %5, i32 0, i32 0, !dbg !252
  %7 = call i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %6), !dbg !253
  store i32 %7, i32* %3, align 4, !dbg !250
  call void @llvm.dbg.declare(metadata i32* %4, metadata !254, metadata !DIExpression()), !dbg !255
  %8 = load i32, i32* %3, align 4, !dbg !256
  %9 = load %struct.twalock_s*, %struct.twalock_s** %2, align 8, !dbg !256
  %10 = getelementptr inbounds %struct.twalock_s, %struct.twalock_s* %9, i32 0, i32 1, !dbg !256
  %11 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %10), !dbg !256
  %12 = sub i32 %8, %11, !dbg !256
  store i32 %12, i32* %4, align 4, !dbg !255
  %13 = load i32, i32* %4, align 4, !dbg !257
  %14 = icmp eq i32 %13, 0, !dbg !259
  br i1 %14, label %15, label %16, !dbg !260

15:                                               ; preds = %1
  br label %27, !dbg !261

16:                                               ; preds = %1
  %17 = load i32, i32* %4, align 4, !dbg !263
  %18 = icmp ugt i32 %17, 1, !dbg !265
  br i1 %18, label %19, label %22, !dbg !266

19:                                               ; preds = %16
  %20 = load %struct.twalock_s*, %struct.twalock_s** %2, align 8, !dbg !267
  %21 = load i32, i32* %3, align 4, !dbg !269
  call void @_twalock_acquire_slowpath(%struct.twalock_s* noundef %20, i32 noundef %21), !dbg !270
  br label %22, !dbg !271

22:                                               ; preds = %19, %16
  %23 = load %struct.twalock_s*, %struct.twalock_s** %2, align 8, !dbg !272
  %24 = getelementptr inbounds %struct.twalock_s, %struct.twalock_s* %23, i32 0, i32 1, !dbg !273
  %25 = load i32, i32* %3, align 4, !dbg !274
  %26 = call i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %24, i32 noundef %25), !dbg !275
  br label %27, !dbg !276

27:                                               ; preds = %22, %15
  ret void, !dbg !276
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !277 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !278, metadata !DIExpression()), !dbg !279
  br label %3, !dbg !280

3:                                                ; preds = %1
  br label %4, !dbg !281

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !283
  br label %6, !dbg !283

6:                                                ; preds = %4
  br label %7, !dbg !285

7:                                                ; preds = %6
  br label %8, !dbg !283

8:                                                ; preds = %7
  br label %9, !dbg !281

9:                                                ; preds = %8
  call void @twalock_release(%struct.twalock_s* noundef @lock), !dbg !287
  ret void, !dbg !288
}

; Function Attrs: noinline nounwind uwtable
define internal void @twalock_release(%struct.twalock_s* noundef %0) #0 !dbg !289 {
  %2 = alloca %struct.twalock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.twalock_s* %0, %struct.twalock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.twalock_s** %2, metadata !290, metadata !DIExpression()), !dbg !291
  call void @llvm.dbg.declare(metadata i32* %3, metadata !292, metadata !DIExpression()), !dbg !293
  %4 = load %struct.twalock_s*, %struct.twalock_s** %2, align 8, !dbg !294
  %5 = getelementptr inbounds %struct.twalock_s, %struct.twalock_s* %4, i32 0, i32 1, !dbg !295
  %6 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %5), !dbg !296
  %7 = add i32 %6, 1, !dbg !297
  store i32 %7, i32* %3, align 4, !dbg !293
  %8 = load %struct.twalock_s*, %struct.twalock_s** %2, align 8, !dbg !298
  %9 = getelementptr inbounds %struct.twalock_s, %struct.twalock_s* %8, i32 0, i32 1, !dbg !299
  %10 = load i32, i32* %3, align 4, !dbg !300
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %9, i32 noundef %10), !dbg !301
  %11 = load i32, i32* %3, align 4, !dbg !302
  %12 = add i32 %11, 1, !dbg !302
  %13 = urem i32 %12, 128, !dbg !302
  %14 = zext i32 %13 to i64, !dbg !302
  %15 = getelementptr inbounds [128 x %struct.twa_counter_s], [128 x %struct.twa_counter_s]* @__twa_array, i64 0, i64 %14, !dbg !302
  %16 = getelementptr inbounds %struct.twa_counter_s, %struct.twa_counter_s* %15, i32 0, i32 0, !dbg !302
  call void @vatomic32_inc_rel(%struct.vatomic32_s* noundef %16), !dbg !303
  ret void, !dbg !304
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !305 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !311, metadata !DIExpression()), !dbg !312
  call void @llvm.dbg.declare(metadata i32* %3, metadata !313, metadata !DIExpression()), !dbg !314
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !315
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !316
  %6 = load i32, i32* %5, align 4, !dbg !316
  %7 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !317, !srcloc !318
  store i32 %7, i32* %3, align 4, !dbg !317
  %8 = load i32, i32* %3, align 4, !dbg !319
  ret i32 %8, !dbg !320
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !321 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !326, metadata !DIExpression()), !dbg !327
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !328, metadata !DIExpression()), !dbg !329
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !330, metadata !DIExpression()), !dbg !331
  call void @llvm.dbg.declare(metadata i32* %7, metadata !332, metadata !DIExpression()), !dbg !333
  call void @llvm.dbg.declare(metadata i32* %8, metadata !334, metadata !DIExpression()), !dbg !335
  %9 = load i32, i32* %6, align 4, !dbg !336
  %10 = load i32, i32* %5, align 4, !dbg !337
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !338
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !339
  %13 = load i32, i32* %12, align 4, !dbg !339
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !340, !srcloc !341
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !340
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !340
  store i32 %15, i32* %7, align 4, !dbg !340
  store i32 %16, i32* %8, align 4, !dbg !340
  %17 = load i32, i32* %7, align 4, !dbg !342
  ret i32 %17, !dbg !343
}

declare i32 @__VERIFIER_assume(...) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !344 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !348, metadata !DIExpression()), !dbg !349
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !350
  %4 = call i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !351
  ret i32 %4, !dbg !352
}

; Function Attrs: noinline nounwind uwtable
define internal void @_twalock_acquire_slowpath(%struct.twalock_s* noundef %0, i32 noundef %1) #0 !dbg !353 {
  %3 = alloca %struct.twalock_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.twalock_s* %0, %struct.twalock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.twalock_s** %3, metadata !356, metadata !DIExpression()), !dbg !357
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !358, metadata !DIExpression()), !dbg !359
  call void @llvm.dbg.declare(metadata i32* %5, metadata !360, metadata !DIExpression()), !dbg !361
  %9 = load i32, i32* %4, align 4, !dbg !362
  %10 = urem i32 %9, 128, !dbg !362
  store i32 %10, i32* %5, align 4, !dbg !361
  call void @llvm.dbg.declare(metadata i32* %6, metadata !363, metadata !DIExpression()), !dbg !364
  %11 = load i32, i32* %5, align 4, !dbg !365
  %12 = zext i32 %11 to i64, !dbg !365
  %13 = getelementptr inbounds [128 x %struct.twa_counter_s], [128 x %struct.twa_counter_s]* @__twa_array, i64 0, i64 %12, !dbg !365
  %14 = getelementptr inbounds %struct.twa_counter_s, %struct.twa_counter_s* %13, i32 0, i32 0, !dbg !365
  %15 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %14), !dbg !366
  store i32 %15, i32* %6, align 4, !dbg !364
  call void @llvm.dbg.declare(metadata i32* %7, metadata !367, metadata !DIExpression()), !dbg !368
  %16 = load %struct.twalock_s*, %struct.twalock_s** %3, align 8, !dbg !369
  %17 = getelementptr inbounds %struct.twalock_s, %struct.twalock_s* %16, i32 0, i32 1, !dbg !370
  %18 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %17), !dbg !371
  store i32 %18, i32* %7, align 4, !dbg !368
  call void @llvm.dbg.declare(metadata i32* %8, metadata !372, metadata !DIExpression()), !dbg !373
  %19 = load i32, i32* %4, align 4, !dbg !374
  %20 = load i32, i32* %7, align 4, !dbg !374
  %21 = sub i32 %19, %20, !dbg !374
  store i32 %21, i32* %8, align 4, !dbg !373
  br label %22, !dbg !375

22:                                               ; preds = %25, %2
  %23 = load i32, i32* %8, align 4, !dbg !376
  %24 = icmp ugt i32 %23, 1, !dbg !377
  br i1 %24, label %25, label %37, !dbg !375

25:                                               ; preds = %22
  %26 = load i32, i32* %5, align 4, !dbg !378
  %27 = zext i32 %26 to i64, !dbg !378
  %28 = getelementptr inbounds [128 x %struct.twa_counter_s], [128 x %struct.twa_counter_s]* @__twa_array, i64 0, i64 %27, !dbg !378
  %29 = getelementptr inbounds %struct.twa_counter_s, %struct.twa_counter_s* %28, i32 0, i32 0, !dbg !378
  %30 = load i32, i32* %6, align 4, !dbg !380
  %31 = call i32 @vatomic32_await_neq_acq(%struct.vatomic32_s* noundef %29, i32 noundef %30), !dbg !381
  store i32 %31, i32* %6, align 4, !dbg !382
  %32 = load i32, i32* %4, align 4, !dbg !383
  %33 = load %struct.twalock_s*, %struct.twalock_s** %3, align 8, !dbg !383
  %34 = getelementptr inbounds %struct.twalock_s, %struct.twalock_s* %33, i32 0, i32 1, !dbg !383
  %35 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %34), !dbg !383
  %36 = sub i32 %32, %35, !dbg !383
  store i32 %36, i32* %8, align 4, !dbg !384
  br label %22, !dbg !375, !llvm.loop !385

37:                                               ; preds = %22
  ret void, !dbg !387
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !388 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !391, metadata !DIExpression()), !dbg !392
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !393, metadata !DIExpression()), !dbg !394
  call void @llvm.dbg.declare(metadata i32* %5, metadata !395, metadata !DIExpression()), !dbg !396
  %6 = load i32, i32* %4, align 4, !dbg !397
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !398
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !399
  %9 = load i32, i32* %8, align 4, !dbg !399
  %10 = call i32 asm sideeffect "1:\0Aldar ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.ne 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !400, !srcloc !401
  store i32 %10, i32* %5, align 4, !dbg !400
  %11 = load i32, i32* %5, align 4, !dbg !402
  ret i32 %11, !dbg !403
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !404 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !407, metadata !DIExpression()), !dbg !408
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !409, metadata !DIExpression()), !dbg !410
  call void @llvm.dbg.declare(metadata i32* %5, metadata !411, metadata !DIExpression()), !dbg !412
  call void @llvm.dbg.declare(metadata i32* %6, metadata !413, metadata !DIExpression()), !dbg !414
  call void @llvm.dbg.declare(metadata i32* %7, metadata !415, metadata !DIExpression()), !dbg !416
  %8 = load i32, i32* %4, align 4, !dbg !417
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !418
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !419
  %11 = load i32, i32* %10, align 4, !dbg !419
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #6, !dbg !417, !srcloc !420
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !417
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !417
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !417
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !417
  store i32 %13, i32* %5, align 4, !dbg !417
  store i32 %14, i32* %7, align 4, !dbg !417
  store i32 %15, i32* %6, align 4, !dbg !417
  store i32 %16, i32* %4, align 4, !dbg !417
  %17 = load i32, i32* %5, align 4, !dbg !421
  ret i32 %17, !dbg !422
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !423 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !424, metadata !DIExpression()), !dbg !425
  call void @llvm.dbg.declare(metadata i32* %3, metadata !426, metadata !DIExpression()), !dbg !427
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !428
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !429
  %6 = load i32, i32* %5, align 4, !dbg !429
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !430, !srcloc !431
  store i32 %7, i32* %3, align 4, !dbg !430
  %8 = load i32, i32* %3, align 4, !dbg !432
  ret i32 %8, !dbg !433
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_neq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !434 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !435, metadata !DIExpression()), !dbg !436
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !437, metadata !DIExpression()), !dbg !438
  call void @llvm.dbg.declare(metadata i32* %5, metadata !439, metadata !DIExpression()), !dbg !440
  %6 = load i32, i32* %4, align 4, !dbg !441
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !442
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !443
  %9 = load i32, i32* %8, align 4, !dbg !443
  %10 = call i32 asm sideeffect "1:\0Aldar ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.eq 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !444, !srcloc !445
  store i32 %10, i32* %5, align 4, !dbg !444
  %11 = load i32, i32* %5, align 4, !dbg !446
  ret i32 %11, !dbg !447
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !448 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !451, metadata !DIExpression()), !dbg !452
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !453, metadata !DIExpression()), !dbg !454
  %5 = load i32, i32* %4, align 4, !dbg !455
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !456
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !457
  %8 = load i32, i32* %7, align 4, !dbg !457
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !458, !srcloc !459
  ret void, !dbg !460
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !461 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !464, metadata !DIExpression()), !dbg !465
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !466
  %4 = call i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %3), !dbg !467
  ret void, !dbg !468
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !469 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !470, metadata !DIExpression()), !dbg !471
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !472
  %4 = call i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !473
  ret i32 %4, !dbg !474
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !475 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !476, metadata !DIExpression()), !dbg !477
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !478, metadata !DIExpression()), !dbg !479
  call void @llvm.dbg.declare(metadata i32* %5, metadata !480, metadata !DIExpression()), !dbg !481
  call void @llvm.dbg.declare(metadata i32* %6, metadata !482, metadata !DIExpression()), !dbg !483
  call void @llvm.dbg.declare(metadata i32* %7, metadata !484, metadata !DIExpression()), !dbg !485
  %8 = load i32, i32* %4, align 4, !dbg !486
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !487
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !488
  %11 = load i32, i32* %10, align 4, !dbg !488
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astlxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #6, !dbg !486, !srcloc !489
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !486
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !486
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !486
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !486
  store i32 %13, i32* %5, align 4, !dbg !486
  store i32 %14, i32* %7, align 4, !dbg !486
  store i32 %15, i32* %6, align 4, !dbg !486
  store i32 %16, i32* %4, align 4, !dbg !486
  %17 = load i32, i32* %5, align 4, !dbg !490
  ret i32 %17, !dbg !491
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!44, !45, !46, !47, !48, !49, !50}
!llvm.ident = !{!51}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !43, line: 100, type: !25, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !11, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/spinlock/test/twalock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "510cfe0090e5cf9a2b9e53bbc29232b0")
!4 = !{!5, !6}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 37, baseType: !8)
!7 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !9, line: 90, baseType: !10)
!9 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = !{!12, !32, !0, !41}
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !14, line: 5, type: !15, isLocal: false, isDefinition: true)
!14 = !DIFile(filename: "spinlock/test/twalock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "510cfe0090e5cf9a2b9e53bbc29232b0")
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "twalock_t", file: !16, line: 56, baseType: !17)
!16 = !DIFile(filename: "spinlock/include/vsync/spinlock/twalock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4fefab09fa9718a947a36d9cd2896c46")
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "twalock_s", file: !16, line: 53, size: 64, elements: !18)
!18 = !{!19, !31}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "ticket", scope: !17, file: !16, line: 54, baseType: !20, size: 32, align: 32)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !21, line: 34, baseType: !22)
!21 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!22 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !21, line: 32, size: 32, align: 32, elements: !23)
!23 = !{!24}
!24 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !22, file: !21, line: 33, baseType: !25, size: 32)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !7, line: 35, baseType: !26)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !27, line: 26, baseType: !28)
!27 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !29, line: 42, baseType: !30)
!29 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!30 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "grant", scope: !17, file: !16, line: 55, baseType: !20, size: 32, align: 32, offset: 32)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "__twa_array", scope: !2, file: !14, line: 4, type: !34, isLocal: false, isDefinition: true)
!34 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 4096, elements: !39)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "twa_counter_t", file: !16, line: 37, baseType: !36)
!36 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "twa_counter_s", file: !16, line: 35, size: 32, elements: !37)
!37 = !{!38}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "val", scope: !36, file: !16, line: 36, baseType: !20, size: 32, align: 32)
!39 = !{!40}
!40 = !DISubrange(count: 128)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !43, line: 101, type: !25, isLocal: true, isDefinition: true)
!43 = !DIFile(filename: "utils/include/test/boilerplate/lock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4187ade4a536ecfd1f9ed3ab727ca965")
!44 = !{i32 7, !"Dwarf Version", i32 5}
!45 = !{i32 2, !"Debug Info Version", i32 3}
!46 = !{i32 1, !"wchar_size", i32 4}
!47 = !{i32 7, !"PIC Level", i32 2}
!48 = !{i32 7, !"PIE Level", i32 2}
!49 = !{i32 7, !"uwtable", i32 1}
!50 = !{i32 7, !"frame-pointer", i32 2}
!51 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!52 = distinct !DISubprogram(name: "init", scope: !43, file: !43, line: 68, type: !53, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!53 = !DISubroutineType(types: !54)
!54 = !{null}
!55 = !{}
!56 = !DILocation(line: 70, column: 1, scope: !52)
!57 = distinct !DISubprogram(name: "post", scope: !43, file: !43, line: 77, type: !53, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!58 = !DILocation(line: 79, column: 1, scope: !57)
!59 = distinct !DISubprogram(name: "fini", scope: !43, file: !43, line: 86, type: !53, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!60 = !DILocation(line: 88, column: 1, scope: !59)
!61 = distinct !DISubprogram(name: "cs", scope: !43, file: !43, line: 104, type: !53, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!62 = !DILocation(line: 106, column: 11, scope: !61)
!63 = !DILocation(line: 107, column: 11, scope: !61)
!64 = !DILocation(line: 108, column: 1, scope: !61)
!65 = distinct !DISubprogram(name: "check", scope: !43, file: !43, line: 110, type: !53, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!66 = !DILocation(line: 112, column: 5, scope: !67)
!67 = distinct !DILexicalBlock(scope: !68, file: !43, line: 112, column: 5)
!68 = distinct !DILexicalBlock(scope: !65, file: !43, line: 112, column: 5)
!69 = !DILocation(line: 112, column: 5, scope: !68)
!70 = !DILocation(line: 113, column: 5, scope: !71)
!71 = distinct !DILexicalBlock(scope: !72, file: !43, line: 113, column: 5)
!72 = distinct !DILexicalBlock(scope: !65, file: !43, line: 113, column: 5)
!73 = !DILocation(line: 113, column: 5, scope: !72)
!74 = !DILocation(line: 114, column: 1, scope: !65)
!75 = distinct !DISubprogram(name: "main", scope: !43, file: !43, line: 141, type: !76, scopeLine: 142, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!76 = !DISubroutineType(types: !77)
!77 = !{!78}
!78 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!79 = !DILocalVariable(name: "t", scope: !75, file: !43, line: 143, type: !80)
!80 = !DICompositeType(tag: DW_TAG_array_type, baseType: !81, size: 192, elements: !83)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !82, line: 27, baseType: !10)
!82 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!83 = !{!84}
!84 = !DISubrange(count: 3)
!85 = !DILocation(line: 143, column: 15, scope: !75)
!86 = !DILocation(line: 150, column: 5, scope: !75)
!87 = !DILocalVariable(name: "i", scope: !88, file: !43, line: 152, type: !6)
!88 = distinct !DILexicalBlock(scope: !75, file: !43, line: 152, column: 5)
!89 = !DILocation(line: 152, column: 21, scope: !88)
!90 = !DILocation(line: 152, column: 10, scope: !88)
!91 = !DILocation(line: 152, column: 28, scope: !92)
!92 = distinct !DILexicalBlock(scope: !88, file: !43, line: 152, column: 5)
!93 = !DILocation(line: 152, column: 30, scope: !92)
!94 = !DILocation(line: 152, column: 5, scope: !88)
!95 = !DILocation(line: 153, column: 33, scope: !96)
!96 = distinct !DILexicalBlock(scope: !92, file: !43, line: 152, column: 47)
!97 = !DILocation(line: 153, column: 31, scope: !96)
!98 = !DILocation(line: 153, column: 53, scope: !96)
!99 = !DILocation(line: 153, column: 45, scope: !96)
!100 = !DILocation(line: 153, column: 15, scope: !96)
!101 = !DILocation(line: 154, column: 5, scope: !96)
!102 = !DILocation(line: 152, column: 43, scope: !92)
!103 = !DILocation(line: 152, column: 5, scope: !92)
!104 = distinct !{!104, !94, !105, !106}
!105 = !DILocation(line: 154, column: 5, scope: !88)
!106 = !{!"llvm.loop.mustprogress"}
!107 = !DILocation(line: 156, column: 5, scope: !75)
!108 = !DILocalVariable(name: "i", scope: !109, file: !43, line: 158, type: !6)
!109 = distinct !DILexicalBlock(scope: !75, file: !43, line: 158, column: 5)
!110 = !DILocation(line: 158, column: 21, scope: !109)
!111 = !DILocation(line: 158, column: 10, scope: !109)
!112 = !DILocation(line: 158, column: 28, scope: !113)
!113 = distinct !DILexicalBlock(scope: !109, file: !43, line: 158, column: 5)
!114 = !DILocation(line: 158, column: 30, scope: !113)
!115 = !DILocation(line: 158, column: 5, scope: !109)
!116 = !DILocation(line: 159, column: 30, scope: !117)
!117 = distinct !DILexicalBlock(scope: !113, file: !43, line: 158, column: 47)
!118 = !DILocation(line: 159, column: 28, scope: !117)
!119 = !DILocation(line: 159, column: 15, scope: !117)
!120 = !DILocation(line: 160, column: 5, scope: !117)
!121 = !DILocation(line: 158, column: 43, scope: !113)
!122 = !DILocation(line: 158, column: 5, scope: !113)
!123 = distinct !{!123, !115, !124, !106}
!124 = !DILocation(line: 160, column: 5, scope: !109)
!125 = !DILocation(line: 167, column: 5, scope: !75)
!126 = !DILocation(line: 168, column: 5, scope: !75)
!127 = !DILocation(line: 170, column: 5, scope: !75)
!128 = distinct !DISubprogram(name: "run", scope: !43, file: !43, line: 119, type: !129, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!129 = !DISubroutineType(types: !130)
!130 = !{!5, !5}
!131 = !DILocalVariable(name: "arg", arg: 1, scope: !128, file: !43, line: 119, type: !5)
!132 = !DILocation(line: 119, column: 11, scope: !128)
!133 = !DILocalVariable(name: "tid", scope: !128, file: !43, line: 121, type: !25)
!134 = !DILocation(line: 121, column: 15, scope: !128)
!135 = !DILocation(line: 121, column: 33, scope: !128)
!136 = !DILocation(line: 121, column: 21, scope: !128)
!137 = !DILocalVariable(name: "i", scope: !138, file: !43, line: 125, type: !78)
!138 = distinct !DILexicalBlock(scope: !128, file: !43, line: 125, column: 5)
!139 = !DILocation(line: 125, column: 14, scope: !138)
!140 = !DILocation(line: 125, column: 10, scope: !138)
!141 = !DILocation(line: 125, column: 21, scope: !142)
!142 = distinct !DILexicalBlock(scope: !138, file: !43, line: 125, column: 5)
!143 = !DILocation(line: 125, column: 23, scope: !142)
!144 = !DILocation(line: 125, column: 28, scope: !142)
!145 = !DILocation(line: 125, column: 31, scope: !142)
!146 = !DILocation(line: 0, scope: !142)
!147 = !DILocation(line: 125, column: 5, scope: !138)
!148 = !DILocalVariable(name: "j", scope: !149, file: !43, line: 129, type: !78)
!149 = distinct !DILexicalBlock(scope: !150, file: !43, line: 129, column: 9)
!150 = distinct !DILexicalBlock(scope: !142, file: !43, line: 125, column: 63)
!151 = !DILocation(line: 129, column: 18, scope: !149)
!152 = !DILocation(line: 129, column: 14, scope: !149)
!153 = !DILocation(line: 129, column: 25, scope: !154)
!154 = distinct !DILexicalBlock(scope: !149, file: !43, line: 129, column: 9)
!155 = !DILocation(line: 129, column: 27, scope: !154)
!156 = !DILocation(line: 129, column: 32, scope: !154)
!157 = !DILocation(line: 129, column: 35, scope: !154)
!158 = !DILocation(line: 0, scope: !154)
!159 = !DILocation(line: 129, column: 9, scope: !149)
!160 = !DILocation(line: 130, column: 21, scope: !161)
!161 = distinct !DILexicalBlock(scope: !154, file: !43, line: 129, column: 67)
!162 = !DILocation(line: 130, column: 13, scope: !161)
!163 = !DILocation(line: 131, column: 13, scope: !161)
!164 = !DILocation(line: 132, column: 9, scope: !161)
!165 = !DILocation(line: 129, column: 63, scope: !154)
!166 = !DILocation(line: 129, column: 9, scope: !154)
!167 = distinct !{!167, !159, !168, !106}
!168 = !DILocation(line: 132, column: 9, scope: !149)
!169 = !DILocalVariable(name: "j", scope: !170, file: !43, line: 133, type: !78)
!170 = distinct !DILexicalBlock(scope: !150, file: !43, line: 133, column: 9)
!171 = !DILocation(line: 133, column: 18, scope: !170)
!172 = !DILocation(line: 133, column: 14, scope: !170)
!173 = !DILocation(line: 133, column: 25, scope: !174)
!174 = distinct !DILexicalBlock(scope: !170, file: !43, line: 133, column: 9)
!175 = !DILocation(line: 133, column: 27, scope: !174)
!176 = !DILocation(line: 133, column: 32, scope: !174)
!177 = !DILocation(line: 133, column: 35, scope: !174)
!178 = !DILocation(line: 0, scope: !174)
!179 = !DILocation(line: 133, column: 9, scope: !170)
!180 = !DILocation(line: 134, column: 21, scope: !181)
!181 = distinct !DILexicalBlock(scope: !174, file: !43, line: 133, column: 67)
!182 = !DILocation(line: 134, column: 13, scope: !181)
!183 = !DILocation(line: 135, column: 9, scope: !181)
!184 = !DILocation(line: 133, column: 63, scope: !174)
!185 = !DILocation(line: 133, column: 9, scope: !174)
!186 = distinct !{!186, !179, !187, !106}
!187 = !DILocation(line: 135, column: 9, scope: !170)
!188 = !DILocation(line: 136, column: 5, scope: !150)
!189 = !DILocation(line: 125, column: 59, scope: !142)
!190 = !DILocation(line: 125, column: 5, scope: !142)
!191 = distinct !{!191, !147, !192, !106}
!192 = !DILocation(line: 136, column: 5, scope: !138)
!193 = !DILocation(line: 137, column: 5, scope: !128)
!194 = distinct !DISubprogram(name: "acquire", scope: !14, file: !14, line: 8, type: !195, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!195 = !DISubroutineType(types: !196)
!196 = !{null, !25}
!197 = !DILocalVariable(name: "tid", arg: 1, scope: !194, file: !14, line: 8, type: !25)
!198 = !DILocation(line: 8, column: 19, scope: !194)
!199 = !DILocation(line: 10, column: 9, scope: !200)
!200 = distinct !DILexicalBlock(scope: !194, file: !14, line: 10, column: 9)
!201 = !DILocation(line: 10, column: 13, scope: !200)
!202 = !DILocation(line: 10, column: 9, scope: !194)
!203 = !DILocalVariable(name: "acquired", scope: !204, file: !14, line: 12, type: !205)
!204 = distinct !DILexicalBlock(scope: !200, file: !14, line: 10, column: 30)
!205 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !7, line: 44, baseType: !206)
!206 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!207 = !DILocation(line: 12, column: 17, scope: !204)
!208 = !DILocation(line: 12, column: 28, scope: !204)
!209 = !DILocation(line: 13, column: 29, scope: !204)
!210 = !DILocation(line: 13, column: 9, scope: !204)
!211 = !DILocation(line: 17, column: 5, scope: !204)
!212 = !DILocation(line: 18, column: 9, scope: !213)
!213 = distinct !DILexicalBlock(scope: !200, file: !14, line: 17, column: 12)
!214 = !DILocation(line: 20, column: 1, scope: !194)
!215 = distinct !DISubprogram(name: "twalock_tryacquire", scope: !16, file: !16, line: 118, type: !216, scopeLine: 119, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!216 = !DISubroutineType(types: !217)
!217 = !{!205, !218}
!218 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!219 = !DILocalVariable(name: "l", arg: 1, scope: !215, file: !16, line: 118, type: !218)
!220 = !DILocation(line: 118, column: 31, scope: !215)
!221 = !DILocalVariable(name: "k", scope: !215, file: !16, line: 120, type: !25)
!222 = !DILocation(line: 120, column: 15, scope: !215)
!223 = !DILocation(line: 120, column: 39, scope: !215)
!224 = !DILocation(line: 120, column: 42, scope: !215)
!225 = !DILocation(line: 120, column: 19, scope: !215)
!226 = !DILocation(line: 121, column: 35, scope: !215)
!227 = !DILocation(line: 121, column: 38, scope: !215)
!228 = !DILocation(line: 121, column: 46, scope: !215)
!229 = !DILocation(line: 121, column: 49, scope: !215)
!230 = !DILocation(line: 121, column: 51, scope: !215)
!231 = !DILocation(line: 121, column: 12, scope: !215)
!232 = !DILocation(line: 121, column: 59, scope: !215)
!233 = !DILocation(line: 121, column: 56, scope: !215)
!234 = !DILocation(line: 121, column: 5, scope: !215)
!235 = distinct !DISubprogram(name: "verification_assume", scope: !236, file: !236, line: 116, type: !237, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!236 = !DIFile(filename: "include/vsync/common/verify.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "2fd10960d0c2c64c7ccf19294b1806ff")
!237 = !DISubroutineType(types: !238)
!238 = !{null, !205}
!239 = !DILocalVariable(name: "cond", arg: 1, scope: !235, file: !236, line: 116, type: !205)
!240 = !DILocation(line: 116, column: 29, scope: !235)
!241 = !DILocation(line: 118, column: 23, scope: !235)
!242 = !DILocation(line: 118, column: 5, scope: !235)
!243 = !DILocation(line: 119, column: 1, scope: !235)
!244 = distinct !DISubprogram(name: "twalock_acquire", scope: !16, file: !16, line: 84, type: !245, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!245 = !DISubroutineType(types: !246)
!246 = !{null, !218}
!247 = !DILocalVariable(name: "l", arg: 1, scope: !244, file: !16, line: 84, type: !218)
!248 = !DILocation(line: 84, column: 28, scope: !244)
!249 = !DILocalVariable(name: "tx", scope: !244, file: !16, line: 86, type: !25)
!250 = !DILocation(line: 86, column: 15, scope: !244)
!251 = !DILocation(line: 86, column: 43, scope: !244)
!252 = !DILocation(line: 86, column: 46, scope: !244)
!253 = !DILocation(line: 86, column: 20, scope: !244)
!254 = !DILocalVariable(name: "dx", scope: !244, file: !16, line: 87, type: !25)
!255 = !DILocation(line: 87, column: 15, scope: !244)
!256 = !DILocation(line: 87, column: 20, scope: !244)
!257 = !DILocation(line: 89, column: 9, scope: !258)
!258 = distinct !DILexicalBlock(scope: !244, file: !16, line: 89, column: 9)
!259 = !DILocation(line: 89, column: 12, scope: !258)
!260 = !DILocation(line: 89, column: 9, scope: !244)
!261 = !DILocation(line: 90, column: 9, scope: !262)
!262 = distinct !DILexicalBlock(scope: !258, file: !16, line: 89, column: 18)
!263 = !DILocation(line: 93, column: 9, scope: !264)
!264 = distinct !DILexicalBlock(scope: !244, file: !16, line: 93, column: 9)
!265 = !DILocation(line: 93, column: 12, scope: !264)
!266 = !DILocation(line: 93, column: 9, scope: !244)
!267 = !DILocation(line: 94, column: 35, scope: !268)
!268 = distinct !DILexicalBlock(scope: !264, file: !16, line: 93, column: 21)
!269 = !DILocation(line: 94, column: 38, scope: !268)
!270 = !DILocation(line: 94, column: 9, scope: !268)
!271 = !DILocation(line: 95, column: 5, scope: !268)
!272 = !DILocation(line: 96, column: 29, scope: !244)
!273 = !DILocation(line: 96, column: 32, scope: !244)
!274 = !DILocation(line: 96, column: 39, scope: !244)
!275 = !DILocation(line: 96, column: 5, scope: !244)
!276 = !DILocation(line: 97, column: 1, scope: !244)
!277 = distinct !DISubprogram(name: "release", scope: !14, file: !14, line: 23, type: !195, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!278 = !DILocalVariable(name: "tid", arg: 1, scope: !277, file: !14, line: 23, type: !25)
!279 = !DILocation(line: 23, column: 19, scope: !277)
!280 = !DILocation(line: 25, column: 5, scope: !277)
!281 = !DILocation(line: 25, column: 5, scope: !282)
!282 = distinct !DILexicalBlock(scope: !277, file: !14, line: 25, column: 5)
!283 = !DILocation(line: 25, column: 5, scope: !284)
!284 = distinct !DILexicalBlock(scope: !282, file: !14, line: 25, column: 5)
!285 = !DILocation(line: 25, column: 5, scope: !286)
!286 = distinct !DILexicalBlock(scope: !284, file: !14, line: 25, column: 5)
!287 = !DILocation(line: 26, column: 5, scope: !277)
!288 = !DILocation(line: 27, column: 1, scope: !277)
!289 = distinct !DISubprogram(name: "twalock_release", scope: !16, file: !16, line: 104, type: !245, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!290 = !DILocalVariable(name: "l", arg: 1, scope: !289, file: !16, line: 104, type: !218)
!291 = !DILocation(line: 104, column: 28, scope: !289)
!292 = !DILocalVariable(name: "k", scope: !289, file: !16, line: 106, type: !25)
!293 = !DILocation(line: 106, column: 15, scope: !289)
!294 = !DILocation(line: 106, column: 39, scope: !289)
!295 = !DILocation(line: 106, column: 42, scope: !289)
!296 = !DILocation(line: 106, column: 19, scope: !289)
!297 = !DILocation(line: 106, column: 49, scope: !289)
!298 = !DILocation(line: 107, column: 26, scope: !289)
!299 = !DILocation(line: 107, column: 29, scope: !289)
!300 = !DILocation(line: 107, column: 36, scope: !289)
!301 = !DILocation(line: 107, column: 5, scope: !289)
!302 = !DILocation(line: 108, column: 23, scope: !289)
!303 = !DILocation(line: 108, column: 5, scope: !289)
!304 = !DILocation(line: 109, column: 1, scope: !289)
!305 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !306, file: !306, line: 85, type: !307, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!306 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!307 = !DISubroutineType(types: !308)
!308 = !{!25, !309}
!309 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !310, size: 64)
!310 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !20)
!311 = !DILocalVariable(name: "a", arg: 1, scope: !305, file: !306, line: 85, type: !309)
!312 = !DILocation(line: 85, column: 39, scope: !305)
!313 = !DILocalVariable(name: "val", scope: !305, file: !306, line: 87, type: !25)
!314 = !DILocation(line: 87, column: 15, scope: !305)
!315 = !DILocation(line: 90, column: 32, scope: !305)
!316 = !DILocation(line: 90, column: 35, scope: !305)
!317 = !DILocation(line: 88, column: 5, scope: !305)
!318 = !{i64 400272}
!319 = !DILocation(line: 92, column: 12, scope: !305)
!320 = !DILocation(line: 92, column: 5, scope: !305)
!321 = distinct !DISubprogram(name: "vatomic32_cmpxchg_rlx", scope: !322, file: !322, line: 361, type: !323, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!322 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!323 = !DISubroutineType(types: !324)
!324 = !{!25, !325, !25, !25}
!325 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!326 = !DILocalVariable(name: "a", arg: 1, scope: !321, file: !322, line: 361, type: !325)
!327 = !DILocation(line: 361, column: 36, scope: !321)
!328 = !DILocalVariable(name: "e", arg: 2, scope: !321, file: !322, line: 361, type: !25)
!329 = !DILocation(line: 361, column: 49, scope: !321)
!330 = !DILocalVariable(name: "v", arg: 3, scope: !321, file: !322, line: 361, type: !25)
!331 = !DILocation(line: 361, column: 62, scope: !321)
!332 = !DILocalVariable(name: "oldv", scope: !321, file: !322, line: 363, type: !25)
!333 = !DILocation(line: 363, column: 15, scope: !321)
!334 = !DILocalVariable(name: "tmp", scope: !321, file: !322, line: 364, type: !25)
!335 = !DILocation(line: 364, column: 15, scope: !321)
!336 = !DILocation(line: 375, column: 22, scope: !321)
!337 = !DILocation(line: 375, column: 36, scope: !321)
!338 = !DILocation(line: 375, column: 48, scope: !321)
!339 = !DILocation(line: 375, column: 51, scope: !321)
!340 = !DILocation(line: 365, column: 5, scope: !321)
!341 = !{i64 467234, i64 467268, i64 467283, i64 467315, i64 467349, i64 467369, i64 467411, i64 467440}
!342 = !DILocation(line: 377, column: 12, scope: !321)
!343 = !DILocation(line: 377, column: 5, scope: !321)
!344 = distinct !DISubprogram(name: "vatomic32_get_inc_rlx", scope: !345, file: !345, line: 2516, type: !346, scopeLine: 2517, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!345 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!346 = !DISubroutineType(types: !347)
!347 = !{!25, !325}
!348 = !DILocalVariable(name: "a", arg: 1, scope: !344, file: !345, line: 2516, type: !325)
!349 = !DILocation(line: 2516, column: 36, scope: !344)
!350 = !DILocation(line: 2518, column: 34, scope: !344)
!351 = !DILocation(line: 2518, column: 12, scope: !344)
!352 = !DILocation(line: 2518, column: 5, scope: !344)
!353 = distinct !DISubprogram(name: "_twalock_acquire_slowpath", scope: !16, file: !16, line: 130, type: !354, scopeLine: 131, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!354 = !DISubroutineType(types: !355)
!355 = !{null, !218, !25}
!356 = !DILocalVariable(name: "l", arg: 1, scope: !353, file: !16, line: 130, type: !218)
!357 = !DILocation(line: 130, column: 38, scope: !353)
!358 = !DILocalVariable(name: "t", arg: 2, scope: !353, file: !16, line: 130, type: !25)
!359 = !DILocation(line: 130, column: 51, scope: !353)
!360 = !DILocalVariable(name: "at", scope: !353, file: !16, line: 132, type: !25)
!361 = !DILocation(line: 132, column: 15, scope: !353)
!362 = !DILocation(line: 132, column: 20, scope: !353)
!363 = !DILocalVariable(name: "u", scope: !353, file: !16, line: 133, type: !25)
!364 = !DILocation(line: 133, column: 15, scope: !353)
!365 = !DILocation(line: 133, column: 39, scope: !353)
!366 = !DILocation(line: 133, column: 20, scope: !353)
!367 = !DILocalVariable(name: "k", scope: !353, file: !16, line: 134, type: !25)
!368 = !DILocation(line: 134, column: 15, scope: !353)
!369 = !DILocation(line: 134, column: 40, scope: !353)
!370 = !DILocation(line: 134, column: 43, scope: !353)
!371 = !DILocation(line: 134, column: 20, scope: !353)
!372 = !DILocalVariable(name: "dx", scope: !353, file: !16, line: 135, type: !25)
!373 = !DILocation(line: 135, column: 15, scope: !353)
!374 = !DILocation(line: 135, column: 20, scope: !353)
!375 = !DILocation(line: 137, column: 5, scope: !353)
!376 = !DILocation(line: 137, column: 12, scope: !353)
!377 = !DILocation(line: 137, column: 15, scope: !353)
!378 = !DILocation(line: 138, column: 38, scope: !379)
!379 = distinct !DILexicalBlock(scope: !353, file: !16, line: 137, column: 24)
!380 = !DILocation(line: 138, column: 53, scope: !379)
!381 = !DILocation(line: 138, column: 14, scope: !379)
!382 = !DILocation(line: 138, column: 12, scope: !379)
!383 = !DILocation(line: 139, column: 14, scope: !379)
!384 = !DILocation(line: 139, column: 12, scope: !379)
!385 = distinct !{!385, !375, !386, !106}
!386 = !DILocation(line: 140, column: 5, scope: !353)
!387 = !DILocation(line: 141, column: 1, scope: !353)
!388 = distinct !DISubprogram(name: "vatomic32_await_eq_acq", scope: !306, file: !306, line: 604, type: !389, scopeLine: 605, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!389 = !DISubroutineType(types: !390)
!390 = !{!25, !309, !25}
!391 = !DILocalVariable(name: "a", arg: 1, scope: !388, file: !306, line: 604, type: !309)
!392 = !DILocation(line: 604, column: 43, scope: !388)
!393 = !DILocalVariable(name: "v", arg: 2, scope: !388, file: !306, line: 604, type: !25)
!394 = !DILocation(line: 604, column: 56, scope: !388)
!395 = !DILocalVariable(name: "val", scope: !388, file: !306, line: 606, type: !25)
!396 = !DILocation(line: 606, column: 15, scope: !388)
!397 = !DILocation(line: 613, column: 21, scope: !388)
!398 = !DILocation(line: 613, column: 33, scope: !388)
!399 = !DILocation(line: 613, column: 36, scope: !388)
!400 = !DILocation(line: 607, column: 5, scope: !388)
!401 = !{i64 415310, i64 415326, i64 415357, i64 415390}
!402 = !DILocation(line: 615, column: 12, scope: !388)
!403 = !DILocation(line: 615, column: 5, scope: !388)
!404 = distinct !DISubprogram(name: "vatomic32_get_add_rlx", scope: !322, file: !322, line: 1388, type: !405, scopeLine: 1389, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!405 = !DISubroutineType(types: !406)
!406 = !{!25, !325, !25}
!407 = !DILocalVariable(name: "a", arg: 1, scope: !404, file: !322, line: 1388, type: !325)
!408 = !DILocation(line: 1388, column: 36, scope: !404)
!409 = !DILocalVariable(name: "v", arg: 2, scope: !404, file: !322, line: 1388, type: !25)
!410 = !DILocation(line: 1388, column: 49, scope: !404)
!411 = !DILocalVariable(name: "oldv", scope: !404, file: !322, line: 1390, type: !25)
!412 = !DILocation(line: 1390, column: 15, scope: !404)
!413 = !DILocalVariable(name: "tmp", scope: !404, file: !322, line: 1391, type: !25)
!414 = !DILocation(line: 1391, column: 15, scope: !404)
!415 = !DILocalVariable(name: "newv", scope: !404, file: !322, line: 1392, type: !25)
!416 = !DILocation(line: 1392, column: 15, scope: !404)
!417 = !DILocation(line: 1393, column: 5, scope: !404)
!418 = !DILocation(line: 1401, column: 19, scope: !404)
!419 = !DILocation(line: 1401, column: 22, scope: !404)
!420 = !{i64 497866, i64 497900, i64 497915, i64 497947, i64 497989, i64 498030}
!421 = !DILocation(line: 1404, column: 12, scope: !404)
!422 = !DILocation(line: 1404, column: 5, scope: !404)
!423 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !306, file: !306, line: 101, type: !307, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!424 = !DILocalVariable(name: "a", arg: 1, scope: !423, file: !306, line: 101, type: !309)
!425 = !DILocation(line: 101, column: 39, scope: !423)
!426 = !DILocalVariable(name: "val", scope: !423, file: !306, line: 103, type: !25)
!427 = !DILocation(line: 103, column: 15, scope: !423)
!428 = !DILocation(line: 106, column: 32, scope: !423)
!429 = !DILocation(line: 106, column: 35, scope: !423)
!430 = !DILocation(line: 104, column: 5, scope: !423)
!431 = !{i64 400774}
!432 = !DILocation(line: 108, column: 12, scope: !423)
!433 = !DILocation(line: 108, column: 5, scope: !423)
!434 = distinct !DISubprogram(name: "vatomic32_await_neq_acq", scope: !306, file: !306, line: 648, type: !389, scopeLine: 649, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!435 = !DILocalVariable(name: "a", arg: 1, scope: !434, file: !306, line: 648, type: !309)
!436 = !DILocation(line: 648, column: 44, scope: !434)
!437 = !DILocalVariable(name: "v", arg: 2, scope: !434, file: !306, line: 648, type: !25)
!438 = !DILocation(line: 648, column: 57, scope: !434)
!439 = !DILocalVariable(name: "val", scope: !434, file: !306, line: 650, type: !25)
!440 = !DILocation(line: 650, column: 15, scope: !434)
!441 = !DILocation(line: 657, column: 21, scope: !434)
!442 = !DILocation(line: 657, column: 33, scope: !434)
!443 = !DILocation(line: 657, column: 36, scope: !434)
!444 = !DILocation(line: 651, column: 5, scope: !434)
!445 = !{i64 416466, i64 416482, i64 416513, i64 416546}
!446 = !DILocation(line: 659, column: 12, scope: !434)
!447 = !DILocation(line: 659, column: 5, scope: !434)
!448 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !306, file: !306, line: 227, type: !449, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!449 = !DISubroutineType(types: !450)
!450 = !{null, !325, !25}
!451 = !DILocalVariable(name: "a", arg: 1, scope: !448, file: !306, line: 227, type: !325)
!452 = !DILocation(line: 227, column: 34, scope: !448)
!453 = !DILocalVariable(name: "v", arg: 2, scope: !448, file: !306, line: 227, type: !25)
!454 = !DILocation(line: 227, column: 47, scope: !448)
!455 = !DILocation(line: 231, column: 32, scope: !448)
!456 = !DILocation(line: 231, column: 44, scope: !448)
!457 = !DILocation(line: 231, column: 47, scope: !448)
!458 = !DILocation(line: 229, column: 5, scope: !448)
!459 = !{i64 404688}
!460 = !DILocation(line: 233, column: 1, scope: !448)
!461 = distinct !DISubprogram(name: "vatomic32_inc_rel", scope: !345, file: !345, line: 2945, type: !462, scopeLine: 2946, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!462 = !DISubroutineType(types: !463)
!463 = !{null, !325}
!464 = !DILocalVariable(name: "a", arg: 1, scope: !461, file: !345, line: 2945, type: !325)
!465 = !DILocation(line: 2945, column: 32, scope: !461)
!466 = !DILocation(line: 2947, column: 33, scope: !461)
!467 = !DILocation(line: 2947, column: 11, scope: !461)
!468 = !DILocation(line: 2948, column: 1, scope: !461)
!469 = distinct !DISubprogram(name: "vatomic32_get_inc_rel", scope: !345, file: !345, line: 2505, type: !346, scopeLine: 2506, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!470 = !DILocalVariable(name: "a", arg: 1, scope: !469, file: !345, line: 2505, type: !325)
!471 = !DILocation(line: 2505, column: 36, scope: !469)
!472 = !DILocation(line: 2507, column: 34, scope: !469)
!473 = !DILocation(line: 2507, column: 12, scope: !469)
!474 = !DILocation(line: 2507, column: 5, scope: !469)
!475 = distinct !DISubprogram(name: "vatomic32_get_add_rel", scope: !322, file: !322, line: 1263, type: !405, scopeLine: 1264, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!476 = !DILocalVariable(name: "a", arg: 1, scope: !475, file: !322, line: 1263, type: !325)
!477 = !DILocation(line: 1263, column: 36, scope: !475)
!478 = !DILocalVariable(name: "v", arg: 2, scope: !475, file: !322, line: 1263, type: !25)
!479 = !DILocation(line: 1263, column: 49, scope: !475)
!480 = !DILocalVariable(name: "oldv", scope: !475, file: !322, line: 1265, type: !25)
!481 = !DILocation(line: 1265, column: 15, scope: !475)
!482 = !DILocalVariable(name: "tmp", scope: !475, file: !322, line: 1266, type: !25)
!483 = !DILocation(line: 1266, column: 15, scope: !475)
!484 = !DILocalVariable(name: "newv", scope: !475, file: !322, line: 1267, type: !25)
!485 = !DILocation(line: 1267, column: 15, scope: !475)
!486 = !DILocation(line: 1268, column: 5, scope: !475)
!487 = !DILocation(line: 1276, column: 19, scope: !475)
!488 = !DILocation(line: 1276, column: 22, scope: !475)
!489 = !{i64 494068, i64 494102, i64 494117, i64 494149, i64 494191, i64 494233}
!490 = !DILocation(line: 1279, column: 12, scope: !475)
!491 = !DILocation(line: 1279, column: 5, scope: !475)
