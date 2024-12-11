; ModuleID = '/home/stefano/huawei/libvsync/spinlock/test/rec_spinlock.c'
source_filename = "/home/stefano/huawei/libvsync/spinlock/test/rec_spinlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.rec_spinlock_s = type { %struct.caslock_s, %struct.vatomic32_s, i32 }
%struct.caslock_s = type { %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !38
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [68 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 0 + 1)\00", align 1
@lock = dso_local global %struct.rec_spinlock_s { %struct.caslock_s zeroinitializer, %struct.vatomic32_s { i32 -1 }, i32 0 }, align 4, !dbg !12
@.str.3 = private unnamed_addr constant [23 x i8] c"this value is reserved\00", align 1
@.str.4 = private unnamed_addr constant [48 x i8] c"id != (4294967295U) && \22this value is reserved\22\00", align 1
@.str.5 = private unnamed_addr constant [77 x i8] c"/home/stefano/huawei/libvsync/spinlock/include/vsync/spinlock/rec_spinlock.h\00", align 1
@__PRETTY_FUNCTION__.rec_spinlock_tryacquire = private unnamed_addr constant [61 x i8] c"vbool_t rec_spinlock_tryacquire(rec_spinlock_t *, vuint32_t)\00", align 1
@__PRETTY_FUNCTION__.rec_spinlock_acquire = private unnamed_addr constant [55 x i8] c"void rec_spinlock_acquire(rec_spinlock_t *, vuint32_t)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !49 {
  ret void, !dbg !53
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !54 {
  ret void, !dbg !55
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !56 {
  ret void, !dbg !57
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !58 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !59
  %2 = add i32 %1, 1, !dbg !59
  store i32 %2, i32* @g_cs_x, align 4, !dbg !59
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !60
  %4 = add i32 %3, 1, !dbg !60
  store i32 %4, i32* @g_cs_y, align 4, !dbg !60
  ret void, !dbg !61
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !62 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !63
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !63
  %3 = icmp eq i32 %1, %2, !dbg !63
  br i1 %3, label %4, label %5, !dbg !66

4:                                                ; preds = %0
  br label %6, !dbg !66

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 112, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !63
  unreachable, !dbg !63

6:                                                ; preds = %4
  %7 = load i32, i32* @g_cs_x, align 4, !dbg !67
  %8 = icmp eq i32 %7, 4, !dbg !67
  br i1 %8, label %9, label %10, !dbg !70

9:                                                ; preds = %6
  br label %11, !dbg !70

10:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 113, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !67
  unreachable, !dbg !67

11:                                               ; preds = %9
  ret void, !dbg !71
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !72 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i64]* %2, metadata !76, metadata !DIExpression()), !dbg !82
  call void @init(), !dbg !83
  call void @llvm.dbg.declare(metadata i64* %3, metadata !84, metadata !DIExpression()), !dbg !86
  store i64 0, i64* %3, align 8, !dbg !86
  br label %5, !dbg !87

5:                                                ; preds = %14, %0
  %6 = load i64, i64* %3, align 8, !dbg !88
  %7 = icmp ult i64 %6, 3, !dbg !90
  br i1 %7, label %8, label %17, !dbg !91

8:                                                ; preds = %5
  %9 = load i64, i64* %3, align 8, !dbg !92
  %10 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %9, !dbg !94
  %11 = load i64, i64* %3, align 8, !dbg !95
  %12 = inttoptr i64 %11 to i8*, !dbg !96
  %13 = call i32 @pthread_create(i64* noundef %10, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef %12) #6, !dbg !97
  br label %14, !dbg !98

14:                                               ; preds = %8
  %15 = load i64, i64* %3, align 8, !dbg !99
  %16 = add i64 %15, 1, !dbg !99
  store i64 %16, i64* %3, align 8, !dbg !99
  br label %5, !dbg !100, !llvm.loop !101

17:                                               ; preds = %5
  call void @post(), !dbg !104
  call void @llvm.dbg.declare(metadata i64* %4, metadata !105, metadata !DIExpression()), !dbg !107
  store i64 0, i64* %4, align 8, !dbg !107
  br label %18, !dbg !108

18:                                               ; preds = %26, %17
  %19 = load i64, i64* %4, align 8, !dbg !109
  %20 = icmp ult i64 %19, 3, !dbg !111
  br i1 %20, label %21, label %29, !dbg !112

21:                                               ; preds = %18
  %22 = load i64, i64* %4, align 8, !dbg !113
  %23 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %22, !dbg !115
  %24 = load i64, i64* %23, align 8, !dbg !115
  %25 = call i32 @pthread_join(i64 noundef %24, i8** noundef null), !dbg !116
  br label %26, !dbg !117

26:                                               ; preds = %21
  %27 = load i64, i64* %4, align 8, !dbg !118
  %28 = add i64 %27, 1, !dbg !118
  store i64 %28, i64* %4, align 8, !dbg !118
  br label %18, !dbg !119, !llvm.loop !120

29:                                               ; preds = %18
  call void @check(), !dbg !122
  call void @fini(), !dbg !123
  ret i32 0, !dbg !124
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !125 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !128, metadata !DIExpression()), !dbg !129
  call void @llvm.dbg.declare(metadata i32* %3, metadata !130, metadata !DIExpression()), !dbg !131
  %7 = load i8*, i8** %2, align 8, !dbg !132
  %8 = ptrtoint i8* %7 to i64, !dbg !133
  %9 = trunc i64 %8 to i32, !dbg !133
  store i32 %9, i32* %3, align 4, !dbg !131
  call void @llvm.dbg.declare(metadata i32* %4, metadata !134, metadata !DIExpression()), !dbg !136
  store i32 0, i32* %4, align 4, !dbg !136
  br label %10, !dbg !137

10:                                               ; preds = %65, %1
  %11 = load i32, i32* %4, align 4, !dbg !138
  %12 = icmp eq i32 %11, 0, !dbg !140
  br i1 %12, label %22, label %13, !dbg !141

13:                                               ; preds = %10
  %14 = load i32, i32* %4, align 4, !dbg !142
  %15 = icmp eq i32 %14, 1, !dbg !142
  br i1 %15, label %16, label %20, !dbg !142

16:                                               ; preds = %13
  %17 = load i32, i32* %3, align 4, !dbg !142
  %18 = add i32 %17, 1, !dbg !142
  %19 = icmp ult i32 %18, 1, !dbg !142
  br label %20

20:                                               ; preds = %16, %13
  %21 = phi i1 [ false, %13 ], [ %19, %16 ], !dbg !143
  br label %22, !dbg !141

22:                                               ; preds = %20, %10
  %23 = phi i1 [ true, %10 ], [ %21, %20 ]
  br i1 %23, label %24, label %68, !dbg !144

24:                                               ; preds = %22
  call void @llvm.dbg.declare(metadata i32* %5, metadata !145, metadata !DIExpression()), !dbg !148
  store i32 0, i32* %5, align 4, !dbg !148
  br label %25, !dbg !149

25:                                               ; preds = %41, %24
  %26 = load i32, i32* %5, align 4, !dbg !150
  %27 = icmp eq i32 %26, 0, !dbg !152
  br i1 %27, label %37, label %28, !dbg !153

28:                                               ; preds = %25
  %29 = load i32, i32* %5, align 4, !dbg !154
  %30 = icmp eq i32 %29, 1, !dbg !154
  br i1 %30, label %31, label %35, !dbg !154

31:                                               ; preds = %28
  %32 = load i32, i32* %3, align 4, !dbg !154
  %33 = add i32 %32, 1, !dbg !154
  %34 = icmp ult i32 %33, 2, !dbg !154
  br label %35

35:                                               ; preds = %31, %28
  %36 = phi i1 [ false, %28 ], [ %34, %31 ], !dbg !155
  br label %37, !dbg !153

37:                                               ; preds = %35, %25
  %38 = phi i1 [ true, %25 ], [ %36, %35 ]
  br i1 %38, label %39, label %44, !dbg !156

39:                                               ; preds = %37
  %40 = load i32, i32* %3, align 4, !dbg !157
  call void @acquire(i32 noundef %40), !dbg !159
  call void @cs(), !dbg !160
  br label %41, !dbg !161

41:                                               ; preds = %39
  %42 = load i32, i32* %5, align 4, !dbg !162
  %43 = add nsw i32 %42, 1, !dbg !162
  store i32 %43, i32* %5, align 4, !dbg !162
  br label %25, !dbg !163, !llvm.loop !164

44:                                               ; preds = %37
  call void @llvm.dbg.declare(metadata i32* %6, metadata !166, metadata !DIExpression()), !dbg !168
  store i32 0, i32* %6, align 4, !dbg !168
  br label %45, !dbg !169

45:                                               ; preds = %61, %44
  %46 = load i32, i32* %6, align 4, !dbg !170
  %47 = icmp eq i32 %46, 0, !dbg !172
  br i1 %47, label %57, label %48, !dbg !173

48:                                               ; preds = %45
  %49 = load i32, i32* %6, align 4, !dbg !174
  %50 = icmp eq i32 %49, 1, !dbg !174
  br i1 %50, label %51, label %55, !dbg !174

51:                                               ; preds = %48
  %52 = load i32, i32* %3, align 4, !dbg !174
  %53 = add i32 %52, 1, !dbg !174
  %54 = icmp ult i32 %53, 2, !dbg !174
  br label %55

55:                                               ; preds = %51, %48
  %56 = phi i1 [ false, %48 ], [ %54, %51 ], !dbg !175
  br label %57, !dbg !173

57:                                               ; preds = %55, %45
  %58 = phi i1 [ true, %45 ], [ %56, %55 ]
  br i1 %58, label %59, label %64, !dbg !176

59:                                               ; preds = %57
  %60 = load i32, i32* %3, align 4, !dbg !177
  call void @release(i32 noundef %60), !dbg !179
  br label %61, !dbg !180

61:                                               ; preds = %59
  %62 = load i32, i32* %6, align 4, !dbg !181
  %63 = add nsw i32 %62, 1, !dbg !181
  store i32 %63, i32* %6, align 4, !dbg !181
  br label %45, !dbg !182, !llvm.loop !183

64:                                               ; preds = %57
  br label %65, !dbg !185

65:                                               ; preds = %64
  %66 = load i32, i32* %4, align 4, !dbg !186
  %67 = add nsw i32 %66, 1, !dbg !186
  store i32 %67, i32* %4, align 4, !dbg !186
  br label %10, !dbg !187, !llvm.loop !188

68:                                               ; preds = %22
  ret i8* null, !dbg !190
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !191 {
  %2 = alloca i32, align 4
  %3 = alloca i8, align 1
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !194, metadata !DIExpression()), !dbg !195
  %4 = load i32, i32* %2, align 4, !dbg !196
  %5 = icmp eq i32 %4, 2, !dbg !198
  br i1 %5, label %6, label %12, !dbg !199

6:                                                ; preds = %1
  call void @llvm.dbg.declare(metadata i8* %3, metadata !200, metadata !DIExpression()), !dbg !204
  %7 = load i32, i32* %2, align 4, !dbg !205
  %8 = call zeroext i1 @rec_spinlock_tryacquire(%struct.rec_spinlock_s* noundef @lock, i32 noundef %7), !dbg !206
  %9 = zext i1 %8 to i8, !dbg !204
  store i8 %9, i8* %3, align 1, !dbg !204
  %10 = load i8, i8* %3, align 1, !dbg !207
  %11 = trunc i8 %10 to i1, !dbg !207
  call void @verification_assume(i1 noundef zeroext %11), !dbg !208
  br label %14, !dbg !209

12:                                               ; preds = %1
  %13 = load i32, i32* %2, align 4, !dbg !210
  call void @rec_spinlock_acquire(%struct.rec_spinlock_s* noundef @lock, i32 noundef %13), !dbg !212
  br label %14

14:                                               ; preds = %12, %6
  ret void, !dbg !213
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @rec_spinlock_tryacquire(%struct.rec_spinlock_s* noundef %0, i32 noundef %1) #0 !dbg !214 {
  %3 = alloca i1, align 1
  %4 = alloca %struct.rec_spinlock_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.rec_spinlock_s* %0, %struct.rec_spinlock_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.rec_spinlock_s** %4, metadata !218, metadata !DIExpression()), !dbg !219
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !220, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.declare(metadata i32* %6, metadata !221, metadata !DIExpression()), !dbg !219
  %7 = load %struct.rec_spinlock_s*, %struct.rec_spinlock_s** %4, align 8, !dbg !219
  %8 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %7, i32 0, i32 1, !dbg !219
  %9 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %8), !dbg !219
  store i32 %9, i32* %6, align 4, !dbg !219
  %10 = load i32, i32* %5, align 4, !dbg !222
  %11 = icmp ne i32 %10, -1, !dbg !222
  br i1 %11, label %12, label %14, !dbg !222

12:                                               ; preds = %2
  br i1 true, label %13, label %14, !dbg !225

13:                                               ; preds = %12
  br label %15, !dbg !225

14:                                               ; preds = %12, %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([77 x i8], [77 x i8]* @.str.5, i64 0, i64 0), i32 noundef 28, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__.rec_spinlock_tryacquire, i64 0, i64 0)) #5, !dbg !222
  unreachable, !dbg !222

15:                                               ; preds = %13
  %16 = load i32, i32* %6, align 4, !dbg !226
  %17 = load i32, i32* %5, align 4, !dbg !226
  %18 = icmp eq i32 %16, %17, !dbg !226
  br i1 %18, label %19, label %24, !dbg !219

19:                                               ; preds = %15
  %20 = load %struct.rec_spinlock_s*, %struct.rec_spinlock_s** %4, align 8, !dbg !228
  %21 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %20, i32 0, i32 2, !dbg !228
  %22 = load i32, i32* %21, align 4, !dbg !228
  %23 = add i32 %22, 1, !dbg !228
  store i32 %23, i32* %21, align 4, !dbg !228
  store i1 true, i1* %3, align 1, !dbg !228
  br label %37, !dbg !228

24:                                               ; preds = %15
  %25 = load i32, i32* %6, align 4, !dbg !230
  %26 = icmp ne i32 %25, -1, !dbg !230
  br i1 %26, label %27, label %28, !dbg !219

27:                                               ; preds = %24
  store i1 false, i1* %3, align 1, !dbg !232
  br label %37, !dbg !232

28:                                               ; preds = %24
  %29 = load %struct.rec_spinlock_s*, %struct.rec_spinlock_s** %4, align 8, !dbg !234
  %30 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %29, i32 0, i32 0, !dbg !234
  %31 = call zeroext i1 @caslock_tryacquire(%struct.caslock_s* noundef %30), !dbg !234
  br i1 %31, label %33, label %32, !dbg !219

32:                                               ; preds = %28
  store i1 false, i1* %3, align 1, !dbg !236
  br label %37, !dbg !236

33:                                               ; preds = %28
  %34 = load %struct.rec_spinlock_s*, %struct.rec_spinlock_s** %4, align 8, !dbg !219
  %35 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %34, i32 0, i32 1, !dbg !219
  %36 = load i32, i32* %5, align 4, !dbg !219
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %35, i32 noundef %36), !dbg !219
  store i1 true, i1* %3, align 1, !dbg !219
  br label %37, !dbg !219

37:                                               ; preds = %33, %32, %27, %19
  %38 = load i1, i1* %3, align 1, !dbg !219
  ret i1 %38, !dbg !219
}

; Function Attrs: noinline nounwind uwtable
define internal void @verification_assume(i1 noundef zeroext %0) #0 !dbg !238 {
  %2 = alloca i8, align 1
  %3 = zext i1 %0 to i8
  store i8 %3, i8* %2, align 1
  call void @llvm.dbg.declare(metadata i8* %2, metadata !242, metadata !DIExpression()), !dbg !243
  %4 = load i8, i8* %2, align 1, !dbg !244
  %5 = trunc i8 %4 to i1, !dbg !244
  %6 = zext i1 %5 to i32, !dbg !244
  %7 = call i32 (i32, ...) bitcast (i32 (...)* @__VERIFIER_assume to i32 (i32, ...)*)(i32 noundef %6), !dbg !245
  ret void, !dbg !246
}

; Function Attrs: noinline nounwind uwtable
define internal void @rec_spinlock_acquire(%struct.rec_spinlock_s* noundef %0, i32 noundef %1) #0 !dbg !247 {
  %3 = alloca %struct.rec_spinlock_s*, align 8
  %4 = alloca i32, align 4
  store %struct.rec_spinlock_s* %0, %struct.rec_spinlock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.rec_spinlock_s** %3, metadata !250, metadata !DIExpression()), !dbg !251
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !252, metadata !DIExpression()), !dbg !251
  %5 = load i32, i32* %4, align 4, !dbg !253
  %6 = icmp ne i32 %5, -1, !dbg !253
  br i1 %6, label %7, label %9, !dbg !253

7:                                                ; preds = %2
  br i1 true, label %8, label %9, !dbg !256

8:                                                ; preds = %7
  br label %10, !dbg !256

9:                                                ; preds = %7, %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([77 x i8], [77 x i8]* @.str.5, i64 0, i64 0), i32 noundef 28, i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @__PRETTY_FUNCTION__.rec_spinlock_acquire, i64 0, i64 0)) #5, !dbg !253
  unreachable, !dbg !253

10:                                               ; preds = %8
  %11 = load %struct.rec_spinlock_s*, %struct.rec_spinlock_s** %3, align 8, !dbg !257
  %12 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %11, i32 0, i32 1, !dbg !257
  %13 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %12), !dbg !257
  %14 = load i32, i32* %4, align 4, !dbg !257
  %15 = icmp eq i32 %13, %14, !dbg !257
  br i1 %15, label %16, label %21, !dbg !251

16:                                               ; preds = %10
  %17 = load %struct.rec_spinlock_s*, %struct.rec_spinlock_s** %3, align 8, !dbg !259
  %18 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %17, i32 0, i32 2, !dbg !259
  %19 = load i32, i32* %18, align 4, !dbg !259
  %20 = add i32 %19, 1, !dbg !259
  store i32 %20, i32* %18, align 4, !dbg !259
  br label %27, !dbg !259

21:                                               ; preds = %10
  %22 = load %struct.rec_spinlock_s*, %struct.rec_spinlock_s** %3, align 8, !dbg !251
  %23 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %22, i32 0, i32 0, !dbg !251
  call void @caslock_acquire(%struct.caslock_s* noundef %23), !dbg !251
  %24 = load %struct.rec_spinlock_s*, %struct.rec_spinlock_s** %3, align 8, !dbg !251
  %25 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %24, i32 0, i32 1, !dbg !251
  %26 = load i32, i32* %4, align 4, !dbg !251
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %25, i32 noundef %26), !dbg !251
  br label %27, !dbg !251

27:                                               ; preds = %21, %16
  ret void, !dbg !251
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !261 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !262, metadata !DIExpression()), !dbg !263
  br label %3, !dbg !264

3:                                                ; preds = %1
  br label %4, !dbg !265

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !267
  br label %6, !dbg !267

6:                                                ; preds = %4
  br label %7, !dbg !269

7:                                                ; preds = %6
  br label %8, !dbg !267

8:                                                ; preds = %7
  br label %9, !dbg !265

9:                                                ; preds = %8
  call void @rec_spinlock_release(%struct.rec_spinlock_s* noundef @lock), !dbg !271
  ret void, !dbg !272
}

; Function Attrs: noinline nounwind uwtable
define internal void @rec_spinlock_release(%struct.rec_spinlock_s* noundef %0) #0 !dbg !273 {
  %2 = alloca %struct.rec_spinlock_s*, align 8
  store %struct.rec_spinlock_s* %0, %struct.rec_spinlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rec_spinlock_s** %2, metadata !276, metadata !DIExpression()), !dbg !277
  %3 = load %struct.rec_spinlock_s*, %struct.rec_spinlock_s** %2, align 8, !dbg !278
  %4 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %3, i32 0, i32 2, !dbg !278
  %5 = load i32, i32* %4, align 4, !dbg !278
  %6 = icmp eq i32 %5, 0, !dbg !278
  br i1 %6, label %7, label %12, !dbg !277

7:                                                ; preds = %1
  %8 = load %struct.rec_spinlock_s*, %struct.rec_spinlock_s** %2, align 8, !dbg !280
  %9 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %8, i32 0, i32 1, !dbg !280
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %9, i32 noundef -1), !dbg !280
  %10 = load %struct.rec_spinlock_s*, %struct.rec_spinlock_s** %2, align 8, !dbg !280
  %11 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %10, i32 0, i32 0, !dbg !280
  call void @caslock_release(%struct.caslock_s* noundef %11), !dbg !280
  br label %17, !dbg !280

12:                                               ; preds = %1
  %13 = load %struct.rec_spinlock_s*, %struct.rec_spinlock_s** %2, align 8, !dbg !282
  %14 = getelementptr inbounds %struct.rec_spinlock_s, %struct.rec_spinlock_s* %13, i32 0, i32 2, !dbg !282
  %15 = load i32, i32* %14, align 4, !dbg !282
  %16 = add i32 %15, -1, !dbg !282
  store i32 %16, i32* %14, align 4, !dbg !282
  br label %17

17:                                               ; preds = %12, %7
  ret void, !dbg !277
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !284 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !290, metadata !DIExpression()), !dbg !291
  call void @llvm.dbg.declare(metadata i32* %3, metadata !292, metadata !DIExpression()), !dbg !293
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !294
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !295
  %6 = load i32, i32* %5, align 4, !dbg !295
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !296, !srcloc !297
  store i32 %7, i32* %3, align 4, !dbg !296
  %8 = load i32, i32* %3, align 4, !dbg !298
  ret i32 %8, !dbg !299
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @caslock_tryacquire(%struct.caslock_s* noundef %0) #0 !dbg !300 {
  %2 = alloca %struct.caslock_s*, align 8
  store %struct.caslock_s* %0, %struct.caslock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.caslock_s** %2, metadata !304, metadata !DIExpression()), !dbg !305
  %3 = load %struct.caslock_s*, %struct.caslock_s** %2, align 8, !dbg !306
  %4 = getelementptr inbounds %struct.caslock_s, %struct.caslock_s* %3, i32 0, i32 0, !dbg !307
  %5 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %4, i32 noundef 0, i32 noundef 1), !dbg !308
  %6 = icmp eq i32 %5, 0, !dbg !309
  ret i1 %6, !dbg !310
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !311 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !315, metadata !DIExpression()), !dbg !316
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !317, metadata !DIExpression()), !dbg !318
  %5 = load i32, i32* %4, align 4, !dbg !319
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !320
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !321
  %8 = load i32, i32* %7, align 4, !dbg !321
  call void asm sideeffect "str ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !322, !srcloc !323
  ret void, !dbg !324
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !325 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !329, metadata !DIExpression()), !dbg !330
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !331, metadata !DIExpression()), !dbg !332
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !333, metadata !DIExpression()), !dbg !334
  call void @llvm.dbg.declare(metadata i32* %7, metadata !335, metadata !DIExpression()), !dbg !336
  call void @llvm.dbg.declare(metadata i32* %8, metadata !337, metadata !DIExpression()), !dbg !338
  %9 = load i32, i32* %6, align 4, !dbg !339
  %10 = load i32, i32* %5, align 4, !dbg !340
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !341
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !342
  %13 = load i32, i32* %12, align 4, !dbg !342
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldaxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !343, !srcloc !344
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !343
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !343
  store i32 %15, i32* %7, align 4, !dbg !343
  store i32 %16, i32* %8, align 4, !dbg !343
  %17 = load i32, i32* %7, align 4, !dbg !345
  ret i32 %17, !dbg !346
}

declare i32 @__VERIFIER_assume(...) #4

; Function Attrs: noinline nounwind uwtable
define internal void @caslock_acquire(%struct.caslock_s* noundef %0) #0 !dbg !347 {
  %2 = alloca %struct.caslock_s*, align 8
  store %struct.caslock_s* %0, %struct.caslock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.caslock_s** %2, metadata !350, metadata !DIExpression()), !dbg !351
  %3 = load %struct.caslock_s*, %struct.caslock_s** %2, align 8, !dbg !352
  %4 = getelementptr inbounds %struct.caslock_s, %struct.caslock_s* %3, i32 0, i32 0, !dbg !353
  %5 = call i32 @vatomic32_await_eq_set_acq(%struct.vatomic32_s* noundef %4, i32 noundef 0, i32 noundef 1), !dbg !354
  ret void, !dbg !355
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_set_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !356 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !358, metadata !DIExpression()), !dbg !359
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !360, metadata !DIExpression()), !dbg !361
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !362, metadata !DIExpression()), !dbg !363
  br label %7, !dbg !364

7:                                                ; preds = %11, %3
  %8 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !365
  %9 = load i32, i32* %5, align 4, !dbg !367
  %10 = call i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %8, i32 noundef %9), !dbg !368
  br label %11, !dbg !369

11:                                               ; preds = %7
  %12 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !370
  %13 = load i32, i32* %5, align 4, !dbg !371
  %14 = load i32, i32* %6, align 4, !dbg !372
  %15 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %12, i32 noundef %13, i32 noundef %14), !dbg !373
  %16 = load i32, i32* %5, align 4, !dbg !374
  %17 = icmp ne i32 %15, %16, !dbg !375
  br i1 %17, label %7, label %18, !dbg !369, !llvm.loop !376

18:                                               ; preds = %11
  %19 = load i32, i32* %5, align 4, !dbg !378
  ret i32 %19, !dbg !379
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !380 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !383, metadata !DIExpression()), !dbg !384
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !385, metadata !DIExpression()), !dbg !386
  call void @llvm.dbg.declare(metadata i32* %5, metadata !387, metadata !DIExpression()), !dbg !388
  %6 = load i32, i32* %4, align 4, !dbg !389
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !390
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !391
  %9 = load i32, i32* %8, align 4, !dbg !391
  %10 = call i32 asm sideeffect "1:\0Aldr ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.ne 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !392, !srcloc !393
  store i32 %10, i32* %5, align 4, !dbg !392
  %11 = load i32, i32* %5, align 4, !dbg !394
  ret i32 %11, !dbg !395
}

; Function Attrs: noinline nounwind uwtable
define internal void @caslock_release(%struct.caslock_s* noundef %0) #0 !dbg !396 {
  %2 = alloca %struct.caslock_s*, align 8
  store %struct.caslock_s* %0, %struct.caslock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.caslock_s** %2, metadata !397, metadata !DIExpression()), !dbg !398
  %3 = load %struct.caslock_s*, %struct.caslock_s** %2, align 8, !dbg !399
  %4 = getelementptr inbounds %struct.caslock_s, %struct.caslock_s* %3, i32 0, i32 0, !dbg !400
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %4, i32 noundef 0), !dbg !401
  ret void, !dbg !402
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !403 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !404, metadata !DIExpression()), !dbg !405
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !406, metadata !DIExpression()), !dbg !407
  %5 = load i32, i32* %4, align 4, !dbg !408
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !409
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !410
  %8 = load i32, i32* %7, align 4, !dbg !410
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !411, !srcloc !412
  ret void, !dbg !413
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!41, !42, !43, !44, !45, !46, !47}
!llvm.ident = !{!48}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !40, line: 100, type: !30, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !11, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/spinlock/test/rec_spinlock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "e53fa8715bbe2a22e5665acf7c0c2833")
!4 = !{!5, !6}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 37, baseType: !8)
!7 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !9, line: 90, baseType: !10)
!9 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = !{!12, !0, !38}
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !14, line: 6, type: !15, isLocal: false, isDefinition: true)
!14 = !DIFile(filename: "spinlock/test/rec_spinlock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "e53fa8715bbe2a22e5665acf7c0c2833")
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "rec_spinlock_t", file: !16, line: 26, baseType: !17)
!16 = !DIFile(filename: "spinlock/include/vsync/spinlock/rec_spinlock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "62ba7c89b0796da52216c1fb04975155")
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "rec_spinlock_s", file: !16, line: 26, size: 96, elements: !18)
!18 = !{!19, !36, !37}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !17, file: !16, line: 26, baseType: !20, size: 32)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "caslock_t", file: !21, line: 22, baseType: !22)
!21 = !DIFile(filename: "spinlock/include/vsync/spinlock/caslock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "130e7907ef9e3e59ba33097973760daf")
!22 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "caslock_s", file: !21, line: 20, size: 32, elements: !23)
!23 = !{!24}
!24 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !22, file: !21, line: 21, baseType: !25, size: 32, align: 32)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !26, line: 34, baseType: !27)
!26 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !26, line: 32, size: 32, align: 32, elements: !28)
!28 = !{!29}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !27, file: !26, line: 33, baseType: !30, size: 32)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !7, line: 35, baseType: !31)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !32, line: 26, baseType: !33)
!32 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !34, line: 42, baseType: !35)
!34 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!35 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "owner", scope: !17, file: !16, line: 26, baseType: !25, size: 32, align: 32, offset: 32)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !17, file: !16, line: 26, baseType: !30, size: 32, offset: 64)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !40, line: 101, type: !30, isLocal: true, isDefinition: true)
!40 = !DIFile(filename: "utils/include/test/boilerplate/lock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4187ade4a536ecfd1f9ed3ab727ca965")
!41 = !{i32 7, !"Dwarf Version", i32 5}
!42 = !{i32 2, !"Debug Info Version", i32 3}
!43 = !{i32 1, !"wchar_size", i32 4}
!44 = !{i32 7, !"PIC Level", i32 2}
!45 = !{i32 7, !"PIE Level", i32 2}
!46 = !{i32 7, !"uwtable", i32 1}
!47 = !{i32 7, !"frame-pointer", i32 2}
!48 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!49 = distinct !DISubprogram(name: "init", scope: !40, file: !40, line: 68, type: !50, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!50 = !DISubroutineType(types: !51)
!51 = !{null}
!52 = !{}
!53 = !DILocation(line: 70, column: 1, scope: !49)
!54 = distinct !DISubprogram(name: "post", scope: !40, file: !40, line: 77, type: !50, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!55 = !DILocation(line: 79, column: 1, scope: !54)
!56 = distinct !DISubprogram(name: "fini", scope: !40, file: !40, line: 86, type: !50, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!57 = !DILocation(line: 88, column: 1, scope: !56)
!58 = distinct !DISubprogram(name: "cs", scope: !40, file: !40, line: 104, type: !50, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!59 = !DILocation(line: 106, column: 11, scope: !58)
!60 = !DILocation(line: 107, column: 11, scope: !58)
!61 = !DILocation(line: 108, column: 1, scope: !58)
!62 = distinct !DISubprogram(name: "check", scope: !40, file: !40, line: 110, type: !50, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!63 = !DILocation(line: 112, column: 5, scope: !64)
!64 = distinct !DILexicalBlock(scope: !65, file: !40, line: 112, column: 5)
!65 = distinct !DILexicalBlock(scope: !62, file: !40, line: 112, column: 5)
!66 = !DILocation(line: 112, column: 5, scope: !65)
!67 = !DILocation(line: 113, column: 5, scope: !68)
!68 = distinct !DILexicalBlock(scope: !69, file: !40, line: 113, column: 5)
!69 = distinct !DILexicalBlock(scope: !62, file: !40, line: 113, column: 5)
!70 = !DILocation(line: 113, column: 5, scope: !69)
!71 = !DILocation(line: 114, column: 1, scope: !62)
!72 = distinct !DISubprogram(name: "main", scope: !40, file: !40, line: 141, type: !73, scopeLine: 142, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!73 = !DISubroutineType(types: !74)
!74 = !{!75}
!75 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!76 = !DILocalVariable(name: "t", scope: !72, file: !40, line: 143, type: !77)
!77 = !DICompositeType(tag: DW_TAG_array_type, baseType: !78, size: 192, elements: !80)
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !79, line: 27, baseType: !10)
!79 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!80 = !{!81}
!81 = !DISubrange(count: 3)
!82 = !DILocation(line: 143, column: 15, scope: !72)
!83 = !DILocation(line: 150, column: 5, scope: !72)
!84 = !DILocalVariable(name: "i", scope: !85, file: !40, line: 152, type: !6)
!85 = distinct !DILexicalBlock(scope: !72, file: !40, line: 152, column: 5)
!86 = !DILocation(line: 152, column: 21, scope: !85)
!87 = !DILocation(line: 152, column: 10, scope: !85)
!88 = !DILocation(line: 152, column: 28, scope: !89)
!89 = distinct !DILexicalBlock(scope: !85, file: !40, line: 152, column: 5)
!90 = !DILocation(line: 152, column: 30, scope: !89)
!91 = !DILocation(line: 152, column: 5, scope: !85)
!92 = !DILocation(line: 153, column: 33, scope: !93)
!93 = distinct !DILexicalBlock(scope: !89, file: !40, line: 152, column: 47)
!94 = !DILocation(line: 153, column: 31, scope: !93)
!95 = !DILocation(line: 153, column: 53, scope: !93)
!96 = !DILocation(line: 153, column: 45, scope: !93)
!97 = !DILocation(line: 153, column: 15, scope: !93)
!98 = !DILocation(line: 154, column: 5, scope: !93)
!99 = !DILocation(line: 152, column: 43, scope: !89)
!100 = !DILocation(line: 152, column: 5, scope: !89)
!101 = distinct !{!101, !91, !102, !103}
!102 = !DILocation(line: 154, column: 5, scope: !85)
!103 = !{!"llvm.loop.mustprogress"}
!104 = !DILocation(line: 156, column: 5, scope: !72)
!105 = !DILocalVariable(name: "i", scope: !106, file: !40, line: 158, type: !6)
!106 = distinct !DILexicalBlock(scope: !72, file: !40, line: 158, column: 5)
!107 = !DILocation(line: 158, column: 21, scope: !106)
!108 = !DILocation(line: 158, column: 10, scope: !106)
!109 = !DILocation(line: 158, column: 28, scope: !110)
!110 = distinct !DILexicalBlock(scope: !106, file: !40, line: 158, column: 5)
!111 = !DILocation(line: 158, column: 30, scope: !110)
!112 = !DILocation(line: 158, column: 5, scope: !106)
!113 = !DILocation(line: 159, column: 30, scope: !114)
!114 = distinct !DILexicalBlock(scope: !110, file: !40, line: 158, column: 47)
!115 = !DILocation(line: 159, column: 28, scope: !114)
!116 = !DILocation(line: 159, column: 15, scope: !114)
!117 = !DILocation(line: 160, column: 5, scope: !114)
!118 = !DILocation(line: 158, column: 43, scope: !110)
!119 = !DILocation(line: 158, column: 5, scope: !110)
!120 = distinct !{!120, !112, !121, !103}
!121 = !DILocation(line: 160, column: 5, scope: !106)
!122 = !DILocation(line: 167, column: 5, scope: !72)
!123 = !DILocation(line: 168, column: 5, scope: !72)
!124 = !DILocation(line: 170, column: 5, scope: !72)
!125 = distinct !DISubprogram(name: "run", scope: !40, file: !40, line: 119, type: !126, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!126 = !DISubroutineType(types: !127)
!127 = !{!5, !5}
!128 = !DILocalVariable(name: "arg", arg: 1, scope: !125, file: !40, line: 119, type: !5)
!129 = !DILocation(line: 119, column: 11, scope: !125)
!130 = !DILocalVariable(name: "tid", scope: !125, file: !40, line: 121, type: !30)
!131 = !DILocation(line: 121, column: 15, scope: !125)
!132 = !DILocation(line: 121, column: 33, scope: !125)
!133 = !DILocation(line: 121, column: 21, scope: !125)
!134 = !DILocalVariable(name: "i", scope: !135, file: !40, line: 125, type: !75)
!135 = distinct !DILexicalBlock(scope: !125, file: !40, line: 125, column: 5)
!136 = !DILocation(line: 125, column: 14, scope: !135)
!137 = !DILocation(line: 125, column: 10, scope: !135)
!138 = !DILocation(line: 125, column: 21, scope: !139)
!139 = distinct !DILexicalBlock(scope: !135, file: !40, line: 125, column: 5)
!140 = !DILocation(line: 125, column: 23, scope: !139)
!141 = !DILocation(line: 125, column: 28, scope: !139)
!142 = !DILocation(line: 125, column: 31, scope: !139)
!143 = !DILocation(line: 0, scope: !139)
!144 = !DILocation(line: 125, column: 5, scope: !135)
!145 = !DILocalVariable(name: "j", scope: !146, file: !40, line: 129, type: !75)
!146 = distinct !DILexicalBlock(scope: !147, file: !40, line: 129, column: 9)
!147 = distinct !DILexicalBlock(scope: !139, file: !40, line: 125, column: 63)
!148 = !DILocation(line: 129, column: 18, scope: !146)
!149 = !DILocation(line: 129, column: 14, scope: !146)
!150 = !DILocation(line: 129, column: 25, scope: !151)
!151 = distinct !DILexicalBlock(scope: !146, file: !40, line: 129, column: 9)
!152 = !DILocation(line: 129, column: 27, scope: !151)
!153 = !DILocation(line: 129, column: 32, scope: !151)
!154 = !DILocation(line: 129, column: 35, scope: !151)
!155 = !DILocation(line: 0, scope: !151)
!156 = !DILocation(line: 129, column: 9, scope: !146)
!157 = !DILocation(line: 130, column: 21, scope: !158)
!158 = distinct !DILexicalBlock(scope: !151, file: !40, line: 129, column: 67)
!159 = !DILocation(line: 130, column: 13, scope: !158)
!160 = !DILocation(line: 131, column: 13, scope: !158)
!161 = !DILocation(line: 132, column: 9, scope: !158)
!162 = !DILocation(line: 129, column: 63, scope: !151)
!163 = !DILocation(line: 129, column: 9, scope: !151)
!164 = distinct !{!164, !156, !165, !103}
!165 = !DILocation(line: 132, column: 9, scope: !146)
!166 = !DILocalVariable(name: "j", scope: !167, file: !40, line: 133, type: !75)
!167 = distinct !DILexicalBlock(scope: !147, file: !40, line: 133, column: 9)
!168 = !DILocation(line: 133, column: 18, scope: !167)
!169 = !DILocation(line: 133, column: 14, scope: !167)
!170 = !DILocation(line: 133, column: 25, scope: !171)
!171 = distinct !DILexicalBlock(scope: !167, file: !40, line: 133, column: 9)
!172 = !DILocation(line: 133, column: 27, scope: !171)
!173 = !DILocation(line: 133, column: 32, scope: !171)
!174 = !DILocation(line: 133, column: 35, scope: !171)
!175 = !DILocation(line: 0, scope: !171)
!176 = !DILocation(line: 133, column: 9, scope: !167)
!177 = !DILocation(line: 134, column: 21, scope: !178)
!178 = distinct !DILexicalBlock(scope: !171, file: !40, line: 133, column: 67)
!179 = !DILocation(line: 134, column: 13, scope: !178)
!180 = !DILocation(line: 135, column: 9, scope: !178)
!181 = !DILocation(line: 133, column: 63, scope: !171)
!182 = !DILocation(line: 133, column: 9, scope: !171)
!183 = distinct !{!183, !176, !184, !103}
!184 = !DILocation(line: 135, column: 9, scope: !167)
!185 = !DILocation(line: 136, column: 5, scope: !147)
!186 = !DILocation(line: 125, column: 59, scope: !139)
!187 = !DILocation(line: 125, column: 5, scope: !139)
!188 = distinct !{!188, !144, !189, !103}
!189 = !DILocation(line: 136, column: 5, scope: !135)
!190 = !DILocation(line: 137, column: 5, scope: !125)
!191 = distinct !DISubprogram(name: "acquire", scope: !14, file: !14, line: 9, type: !192, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!192 = !DISubroutineType(types: !193)
!193 = !{null, !30}
!194 = !DILocalVariable(name: "tid", arg: 1, scope: !191, file: !14, line: 9, type: !30)
!195 = !DILocation(line: 9, column: 19, scope: !191)
!196 = !DILocation(line: 11, column: 9, scope: !197)
!197 = distinct !DILexicalBlock(scope: !191, file: !14, line: 11, column: 9)
!198 = !DILocation(line: 11, column: 13, scope: !197)
!199 = !DILocation(line: 11, column: 9, scope: !191)
!200 = !DILocalVariable(name: "acquired", scope: !201, file: !14, line: 13, type: !202)
!201 = distinct !DILexicalBlock(scope: !197, file: !14, line: 11, column: 30)
!202 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !7, line: 44, baseType: !203)
!203 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!204 = !DILocation(line: 13, column: 17, scope: !201)
!205 = !DILocation(line: 13, column: 59, scope: !201)
!206 = !DILocation(line: 13, column: 28, scope: !201)
!207 = !DILocation(line: 14, column: 29, scope: !201)
!208 = !DILocation(line: 14, column: 9, scope: !201)
!209 = !DILocation(line: 18, column: 5, scope: !201)
!210 = !DILocation(line: 19, column: 37, scope: !211)
!211 = distinct !DILexicalBlock(scope: !197, file: !14, line: 18, column: 12)
!212 = !DILocation(line: 19, column: 9, scope: !211)
!213 = !DILocation(line: 21, column: 1, scope: !191)
!214 = distinct !DISubprogram(name: "rec_spinlock_tryacquire", scope: !16, file: !16, line: 26, type: !215, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!215 = !DISubroutineType(types: !216)
!216 = !{!202, !217, !30}
!217 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!218 = !DILocalVariable(name: "l", arg: 1, scope: !214, file: !16, line: 26, type: !217)
!219 = !DILocation(line: 26, column: 1, scope: !214)
!220 = !DILocalVariable(name: "id", arg: 2, scope: !214, file: !16, line: 26, type: !30)
!221 = !DILocalVariable(name: "owner", scope: !214, file: !16, line: 26, type: !30)
!222 = !DILocation(line: 26, column: 1, scope: !223)
!223 = distinct !DILexicalBlock(scope: !224, file: !16, line: 26, column: 1)
!224 = distinct !DILexicalBlock(scope: !214, file: !16, line: 26, column: 1)
!225 = !DILocation(line: 26, column: 1, scope: !224)
!226 = !DILocation(line: 26, column: 1, scope: !227)
!227 = distinct !DILexicalBlock(scope: !214, file: !16, line: 26, column: 1)
!228 = !DILocation(line: 26, column: 1, scope: !229)
!229 = distinct !DILexicalBlock(scope: !227, file: !16, line: 26, column: 1)
!230 = !DILocation(line: 26, column: 1, scope: !231)
!231 = distinct !DILexicalBlock(scope: !214, file: !16, line: 26, column: 1)
!232 = !DILocation(line: 26, column: 1, scope: !233)
!233 = distinct !DILexicalBlock(scope: !231, file: !16, line: 26, column: 1)
!234 = !DILocation(line: 26, column: 1, scope: !235)
!235 = distinct !DILexicalBlock(scope: !214, file: !16, line: 26, column: 1)
!236 = !DILocation(line: 26, column: 1, scope: !237)
!237 = distinct !DILexicalBlock(scope: !235, file: !16, line: 26, column: 1)
!238 = distinct !DISubprogram(name: "verification_assume", scope: !239, file: !239, line: 116, type: !240, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!239 = !DIFile(filename: "include/vsync/common/verify.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "2fd10960d0c2c64c7ccf19294b1806ff")
!240 = !DISubroutineType(types: !241)
!241 = !{null, !202}
!242 = !DILocalVariable(name: "cond", arg: 1, scope: !238, file: !239, line: 116, type: !202)
!243 = !DILocation(line: 116, column: 29, scope: !238)
!244 = !DILocation(line: 118, column: 23, scope: !238)
!245 = !DILocation(line: 118, column: 5, scope: !238)
!246 = !DILocation(line: 119, column: 1, scope: !238)
!247 = distinct !DISubprogram(name: "rec_spinlock_acquire", scope: !16, file: !16, line: 26, type: !248, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!248 = !DISubroutineType(types: !249)
!249 = !{null, !217, !30}
!250 = !DILocalVariable(name: "l", arg: 1, scope: !247, file: !16, line: 26, type: !217)
!251 = !DILocation(line: 26, column: 1, scope: !247)
!252 = !DILocalVariable(name: "id", arg: 2, scope: !247, file: !16, line: 26, type: !30)
!253 = !DILocation(line: 26, column: 1, scope: !254)
!254 = distinct !DILexicalBlock(scope: !255, file: !16, line: 26, column: 1)
!255 = distinct !DILexicalBlock(scope: !247, file: !16, line: 26, column: 1)
!256 = !DILocation(line: 26, column: 1, scope: !255)
!257 = !DILocation(line: 26, column: 1, scope: !258)
!258 = distinct !DILexicalBlock(scope: !247, file: !16, line: 26, column: 1)
!259 = !DILocation(line: 26, column: 1, scope: !260)
!260 = distinct !DILexicalBlock(scope: !258, file: !16, line: 26, column: 1)
!261 = distinct !DISubprogram(name: "release", scope: !14, file: !14, line: 24, type: !192, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!262 = !DILocalVariable(name: "tid", arg: 1, scope: !261, file: !14, line: 24, type: !30)
!263 = !DILocation(line: 24, column: 19, scope: !261)
!264 = !DILocation(line: 26, column: 5, scope: !261)
!265 = !DILocation(line: 26, column: 5, scope: !266)
!266 = distinct !DILexicalBlock(scope: !261, file: !14, line: 26, column: 5)
!267 = !DILocation(line: 26, column: 5, scope: !268)
!268 = distinct !DILexicalBlock(scope: !266, file: !14, line: 26, column: 5)
!269 = !DILocation(line: 26, column: 5, scope: !270)
!270 = distinct !DILexicalBlock(scope: !268, file: !14, line: 26, column: 5)
!271 = !DILocation(line: 27, column: 5, scope: !261)
!272 = !DILocation(line: 28, column: 1, scope: !261)
!273 = distinct !DISubprogram(name: "rec_spinlock_release", scope: !16, file: !16, line: 26, type: !274, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!274 = !DISubroutineType(types: !275)
!275 = !{null, !217}
!276 = !DILocalVariable(name: "l", arg: 1, scope: !273, file: !16, line: 26, type: !217)
!277 = !DILocation(line: 26, column: 1, scope: !273)
!278 = !DILocation(line: 26, column: 1, scope: !279)
!279 = distinct !DILexicalBlock(scope: !273, file: !16, line: 26, column: 1)
!280 = !DILocation(line: 26, column: 1, scope: !281)
!281 = distinct !DILexicalBlock(scope: !279, file: !16, line: 26, column: 1)
!282 = !DILocation(line: 26, column: 1, scope: !283)
!283 = distinct !DILexicalBlock(scope: !279, file: !16, line: 26, column: 1)
!284 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !285, file: !285, line: 101, type: !286, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!285 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!286 = !DISubroutineType(types: !287)
!287 = !{!30, !288}
!288 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !289, size: 64)
!289 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !25)
!290 = !DILocalVariable(name: "a", arg: 1, scope: !284, file: !285, line: 101, type: !288)
!291 = !DILocation(line: 101, column: 39, scope: !284)
!292 = !DILocalVariable(name: "val", scope: !284, file: !285, line: 103, type: !30)
!293 = !DILocation(line: 103, column: 15, scope: !284)
!294 = !DILocation(line: 106, column: 32, scope: !284)
!295 = !DILocation(line: 106, column: 35, scope: !284)
!296 = !DILocation(line: 104, column: 5, scope: !284)
!297 = !{i64 397700}
!298 = !DILocation(line: 108, column: 12, scope: !284)
!299 = !DILocation(line: 108, column: 5, scope: !284)
!300 = distinct !DISubprogram(name: "caslock_tryacquire", scope: !21, file: !21, line: 59, type: !301, scopeLine: 60, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!301 = !DISubroutineType(types: !302)
!302 = !{!202, !303}
!303 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!304 = !DILocalVariable(name: "l", arg: 1, scope: !300, file: !21, line: 59, type: !303)
!305 = !DILocation(line: 59, column: 31, scope: !300)
!306 = !DILocation(line: 61, column: 35, scope: !300)
!307 = !DILocation(line: 61, column: 38, scope: !300)
!308 = !DILocation(line: 61, column: 12, scope: !300)
!309 = !DILocation(line: 61, column: 50, scope: !300)
!310 = !DILocation(line: 61, column: 5, scope: !300)
!311 = distinct !DISubprogram(name: "vatomic32_write_rlx", scope: !285, file: !285, line: 241, type: !312, scopeLine: 242, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!312 = !DISubroutineType(types: !313)
!313 = !{null, !314, !30}
!314 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!315 = !DILocalVariable(name: "a", arg: 1, scope: !311, file: !285, line: 241, type: !314)
!316 = !DILocation(line: 241, column: 34, scope: !311)
!317 = !DILocalVariable(name: "v", arg: 2, scope: !311, file: !285, line: 241, type: !30)
!318 = !DILocation(line: 241, column: 47, scope: !311)
!319 = !DILocation(line: 245, column: 32, scope: !311)
!320 = !DILocation(line: 245, column: 44, scope: !311)
!321 = !DILocation(line: 245, column: 47, scope: !311)
!322 = !DILocation(line: 243, column: 5, scope: !311)
!323 = !{i64 402084}
!324 = !DILocation(line: 247, column: 1, scope: !311)
!325 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !326, file: !326, line: 311, type: !327, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!326 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!327 = !DISubroutineType(types: !328)
!328 = !{!30, !314, !30, !30}
!329 = !DILocalVariable(name: "a", arg: 1, scope: !325, file: !326, line: 311, type: !314)
!330 = !DILocation(line: 311, column: 36, scope: !325)
!331 = !DILocalVariable(name: "e", arg: 2, scope: !325, file: !326, line: 311, type: !30)
!332 = !DILocation(line: 311, column: 49, scope: !325)
!333 = !DILocalVariable(name: "v", arg: 3, scope: !325, file: !326, line: 311, type: !30)
!334 = !DILocation(line: 311, column: 62, scope: !325)
!335 = !DILocalVariable(name: "oldv", scope: !325, file: !326, line: 313, type: !30)
!336 = !DILocation(line: 313, column: 15, scope: !325)
!337 = !DILocalVariable(name: "tmp", scope: !325, file: !326, line: 314, type: !30)
!338 = !DILocation(line: 314, column: 15, scope: !325)
!339 = !DILocation(line: 325, column: 22, scope: !325)
!340 = !DILocation(line: 325, column: 36, scope: !325)
!341 = !DILocation(line: 325, column: 48, scope: !325)
!342 = !DILocation(line: 325, column: 51, scope: !325)
!343 = !DILocation(line: 315, column: 5, scope: !325)
!344 = !{i64 462608, i64 462642, i64 462657, i64 462690, i64 462724, i64 462744, i64 462786, i64 462815}
!345 = !DILocation(line: 327, column: 12, scope: !325)
!346 = !DILocation(line: 327, column: 5, scope: !325)
!347 = distinct !DISubprogram(name: "caslock_acquire", scope: !21, file: !21, line: 47, type: !348, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!348 = !DISubroutineType(types: !349)
!349 = !{null, !303}
!350 = !DILocalVariable(name: "l", arg: 1, scope: !347, file: !21, line: 47, type: !303)
!351 = !DILocation(line: 47, column: 28, scope: !347)
!352 = !DILocation(line: 49, column: 33, scope: !347)
!353 = !DILocation(line: 49, column: 36, scope: !347)
!354 = !DILocation(line: 49, column: 5, scope: !347)
!355 = !DILocation(line: 50, column: 1, scope: !347)
!356 = distinct !DISubprogram(name: "vatomic32_await_eq_set_acq", scope: !357, file: !357, line: 7303, type: !327, scopeLine: 7304, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!357 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!358 = !DILocalVariable(name: "a", arg: 1, scope: !356, file: !357, line: 7303, type: !314)
!359 = !DILocation(line: 7303, column: 41, scope: !356)
!360 = !DILocalVariable(name: "c", arg: 2, scope: !356, file: !357, line: 7303, type: !30)
!361 = !DILocation(line: 7303, column: 54, scope: !356)
!362 = !DILocalVariable(name: "v", arg: 3, scope: !356, file: !357, line: 7303, type: !30)
!363 = !DILocation(line: 7303, column: 67, scope: !356)
!364 = !DILocation(line: 7305, column: 5, scope: !356)
!365 = !DILocation(line: 7306, column: 38, scope: !366)
!366 = distinct !DILexicalBlock(scope: !356, file: !357, line: 7305, column: 8)
!367 = !DILocation(line: 7306, column: 41, scope: !366)
!368 = !DILocation(line: 7306, column: 15, scope: !366)
!369 = !DILocation(line: 7307, column: 5, scope: !366)
!370 = !DILocation(line: 7307, column: 36, scope: !356)
!371 = !DILocation(line: 7307, column: 39, scope: !356)
!372 = !DILocation(line: 7307, column: 42, scope: !356)
!373 = !DILocation(line: 7307, column: 14, scope: !356)
!374 = !DILocation(line: 7307, column: 48, scope: !356)
!375 = !DILocation(line: 7307, column: 45, scope: !356)
!376 = distinct !{!376, !364, !377, !103}
!377 = !DILocation(line: 7307, column: 49, scope: !356)
!378 = !DILocation(line: 7308, column: 12, scope: !356)
!379 = !DILocation(line: 7308, column: 5, scope: !356)
!380 = distinct !DISubprogram(name: "vatomic32_await_eq_rlx", scope: !285, file: !285, line: 868, type: !381, scopeLine: 869, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!381 = !DISubroutineType(types: !382)
!382 = !{!30, !288, !30}
!383 = !DILocalVariable(name: "a", arg: 1, scope: !380, file: !285, line: 868, type: !288)
!384 = !DILocation(line: 868, column: 43, scope: !380)
!385 = !DILocalVariable(name: "v", arg: 2, scope: !380, file: !285, line: 868, type: !30)
!386 = !DILocation(line: 868, column: 56, scope: !380)
!387 = !DILocalVariable(name: "val", scope: !380, file: !285, line: 870, type: !30)
!388 = !DILocation(line: 870, column: 15, scope: !380)
!389 = !DILocation(line: 877, column: 21, scope: !380)
!390 = !DILocation(line: 877, column: 33, scope: !380)
!391 = !DILocation(line: 877, column: 36, scope: !380)
!392 = !DILocation(line: 871, column: 5, scope: !380)
!393 = !{i64 419153, i64 419169, i64 419199, i64 419232}
!394 = !DILocation(line: 879, column: 12, scope: !380)
!395 = !DILocation(line: 879, column: 5, scope: !380)
!396 = distinct !DISubprogram(name: "caslock_release", scope: !21, file: !21, line: 69, type: !348, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!397 = !DILocalVariable(name: "l", arg: 1, scope: !396, file: !21, line: 69, type: !303)
!398 = !DILocation(line: 69, column: 28, scope: !396)
!399 = !DILocation(line: 71, column: 26, scope: !396)
!400 = !DILocation(line: 71, column: 29, scope: !396)
!401 = !DILocation(line: 71, column: 5, scope: !396)
!402 = !DILocation(line: 72, column: 1, scope: !396)
!403 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !285, file: !285, line: 227, type: !312, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!404 = !DILocalVariable(name: "a", arg: 1, scope: !403, file: !285, line: 227, type: !314)
!405 = !DILocation(line: 227, column: 34, scope: !403)
!406 = !DILocalVariable(name: "v", arg: 2, scope: !403, file: !285, line: 227, type: !30)
!407 = !DILocation(line: 227, column: 47, scope: !403)
!408 = !DILocation(line: 231, column: 32, scope: !403)
!409 = !DILocation(line: 231, column: 44, scope: !403)
!410 = !DILocation(line: 231, column: 47, scope: !403)
!411 = !DILocation(line: 229, column: 5, scope: !403)
!412 = !{i64 401614}
!413 = !DILocation(line: 233, column: 1, scope: !403)
