; ModuleID = '/home/stefano/huawei/libvsync/thread/verify/mutex_musl.c'
source_filename = "/home/stefano/huawei/libvsync/thread/verify/mutex_musl.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.vmutex_t = type { %struct.vatomic32_s, %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !32
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [68 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (2 + 0 + 0)\00", align 1
@lock = dso_local global %struct.vmutex_t zeroinitializer, align 4, !dbg !12
@signal = internal global %struct.vatomic32_s zeroinitializer, align 4, !dbg !35

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !46 {
  ret void, !dbg !50
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !51 {
  ret void, !dbg !52
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !53 {
  ret void, !dbg !54
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !55 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !56
  %2 = add i32 %1, 1, !dbg !56
  store i32 %2, i32* @g_cs_x, align 4, !dbg !56
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !57
  %4 = add i32 %3, 1, !dbg !57
  store i32 %4, i32* @g_cs_y, align 4, !dbg !57
  ret void, !dbg !58
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !59 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !60
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !60
  %3 = icmp eq i32 %1, %2, !dbg !60
  br i1 %3, label %4, label %5, !dbg !63

4:                                                ; preds = %0
  br label %6, !dbg !63

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 112, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !60
  unreachable, !dbg !60

6:                                                ; preds = %4
  %7 = load i32, i32* @g_cs_x, align 4, !dbg !64
  %8 = icmp eq i32 %7, 2, !dbg !64
  br i1 %8, label %9, label %10, !dbg !67

9:                                                ; preds = %6
  br label %11, !dbg !67

10:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 113, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !64
  unreachable, !dbg !64

11:                                               ; preds = %9
  ret void, !dbg !68
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !69 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [2 x i64]* %2, metadata !73, metadata !DIExpression()), !dbg !79
  call void @init(), !dbg !80
  call void @llvm.dbg.declare(metadata i64* %3, metadata !81, metadata !DIExpression()), !dbg !83
  store i64 0, i64* %3, align 8, !dbg !83
  br label %5, !dbg !84

5:                                                ; preds = %14, %0
  %6 = load i64, i64* %3, align 8, !dbg !85
  %7 = icmp ult i64 %6, 2, !dbg !87
  br i1 %7, label %8, label %17, !dbg !88

8:                                                ; preds = %5
  %9 = load i64, i64* %3, align 8, !dbg !89
  %10 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 %9, !dbg !91
  %11 = load i64, i64* %3, align 8, !dbg !92
  %12 = inttoptr i64 %11 to i8*, !dbg !93
  %13 = call i32 @pthread_create(i64* noundef %10, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef %12) #6, !dbg !94
  br label %14, !dbg !95

14:                                               ; preds = %8
  %15 = load i64, i64* %3, align 8, !dbg !96
  %16 = add i64 %15, 1, !dbg !96
  store i64 %16, i64* %3, align 8, !dbg !96
  br label %5, !dbg !97, !llvm.loop !98

17:                                               ; preds = %5
  call void @post(), !dbg !101
  call void @llvm.dbg.declare(metadata i64* %4, metadata !102, metadata !DIExpression()), !dbg !104
  store i64 0, i64* %4, align 8, !dbg !104
  br label %18, !dbg !105

18:                                               ; preds = %26, %17
  %19 = load i64, i64* %4, align 8, !dbg !106
  %20 = icmp ult i64 %19, 2, !dbg !108
  br i1 %20, label %21, label %29, !dbg !109

21:                                               ; preds = %18
  %22 = load i64, i64* %4, align 8, !dbg !110
  %23 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 %22, !dbg !112
  %24 = load i64, i64* %23, align 8, !dbg !112
  %25 = call i32 @pthread_join(i64 noundef %24, i8** noundef null), !dbg !113
  br label %26, !dbg !114

26:                                               ; preds = %21
  %27 = load i64, i64* %4, align 8, !dbg !115
  %28 = add i64 %27, 1, !dbg !115
  store i64 %28, i64* %4, align 8, !dbg !115
  br label %18, !dbg !116, !llvm.loop !117

29:                                               ; preds = %18
  call void @check(), !dbg !119
  call void @fini(), !dbg !120
  ret i32 0, !dbg !121
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !122 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !125, metadata !DIExpression()), !dbg !126
  call void @llvm.dbg.declare(metadata i32* %3, metadata !127, metadata !DIExpression()), !dbg !128
  %7 = load i8*, i8** %2, align 8, !dbg !129
  %8 = ptrtoint i8* %7 to i64, !dbg !130
  %9 = trunc i64 %8 to i32, !dbg !130
  store i32 %9, i32* %3, align 4, !dbg !128
  call void @llvm.dbg.declare(metadata i32* %4, metadata !131, metadata !DIExpression()), !dbg !133
  store i32 0, i32* %4, align 4, !dbg !133
  br label %10, !dbg !134

10:                                               ; preds = %65, %1
  %11 = load i32, i32* %4, align 4, !dbg !135
  %12 = icmp eq i32 %11, 0, !dbg !137
  br i1 %12, label %22, label %13, !dbg !138

13:                                               ; preds = %10
  %14 = load i32, i32* %4, align 4, !dbg !139
  %15 = icmp eq i32 %14, 1, !dbg !139
  br i1 %15, label %16, label %20, !dbg !139

16:                                               ; preds = %13
  %17 = load i32, i32* %3, align 4, !dbg !139
  %18 = add i32 %17, 1, !dbg !139
  %19 = icmp ult i32 %18, 1, !dbg !139
  br label %20

20:                                               ; preds = %16, %13
  %21 = phi i1 [ false, %13 ], [ %19, %16 ], !dbg !140
  br label %22, !dbg !138

22:                                               ; preds = %20, %10
  %23 = phi i1 [ true, %10 ], [ %21, %20 ]
  br i1 %23, label %24, label %68, !dbg !141

24:                                               ; preds = %22
  call void @llvm.dbg.declare(metadata i32* %5, metadata !142, metadata !DIExpression()), !dbg !145
  store i32 0, i32* %5, align 4, !dbg !145
  br label %25, !dbg !146

25:                                               ; preds = %41, %24
  %26 = load i32, i32* %5, align 4, !dbg !147
  %27 = icmp eq i32 %26, 0, !dbg !149
  br i1 %27, label %37, label %28, !dbg !150

28:                                               ; preds = %25
  %29 = load i32, i32* %5, align 4, !dbg !151
  %30 = icmp eq i32 %29, 1, !dbg !151
  br i1 %30, label %31, label %35, !dbg !151

31:                                               ; preds = %28
  %32 = load i32, i32* %3, align 4, !dbg !151
  %33 = add i32 %32, 1, !dbg !151
  %34 = icmp ult i32 %33, 1, !dbg !151
  br label %35

35:                                               ; preds = %31, %28
  %36 = phi i1 [ false, %28 ], [ %34, %31 ], !dbg !152
  br label %37, !dbg !150

37:                                               ; preds = %35, %25
  %38 = phi i1 [ true, %25 ], [ %36, %35 ]
  br i1 %38, label %39, label %44, !dbg !153

39:                                               ; preds = %37
  %40 = load i32, i32* %3, align 4, !dbg !154
  call void @acquire(i32 noundef %40), !dbg !156
  call void @cs(), !dbg !157
  br label %41, !dbg !158

41:                                               ; preds = %39
  %42 = load i32, i32* %5, align 4, !dbg !159
  %43 = add nsw i32 %42, 1, !dbg !159
  store i32 %43, i32* %5, align 4, !dbg !159
  br label %25, !dbg !160, !llvm.loop !161

44:                                               ; preds = %37
  call void @llvm.dbg.declare(metadata i32* %6, metadata !163, metadata !DIExpression()), !dbg !165
  store i32 0, i32* %6, align 4, !dbg !165
  br label %45, !dbg !166

45:                                               ; preds = %61, %44
  %46 = load i32, i32* %6, align 4, !dbg !167
  %47 = icmp eq i32 %46, 0, !dbg !169
  br i1 %47, label %57, label %48, !dbg !170

48:                                               ; preds = %45
  %49 = load i32, i32* %6, align 4, !dbg !171
  %50 = icmp eq i32 %49, 1, !dbg !171
  br i1 %50, label %51, label %55, !dbg !171

51:                                               ; preds = %48
  %52 = load i32, i32* %3, align 4, !dbg !171
  %53 = add i32 %52, 1, !dbg !171
  %54 = icmp ult i32 %53, 1, !dbg !171
  br label %55

55:                                               ; preds = %51, %48
  %56 = phi i1 [ false, %48 ], [ %54, %51 ], !dbg !172
  br label %57, !dbg !170

57:                                               ; preds = %55, %45
  %58 = phi i1 [ true, %45 ], [ %56, %55 ]
  br i1 %58, label %59, label %64, !dbg !173

59:                                               ; preds = %57
  %60 = load i32, i32* %3, align 4, !dbg !174
  call void @release(i32 noundef %60), !dbg !176
  br label %61, !dbg !177

61:                                               ; preds = %59
  %62 = load i32, i32* %6, align 4, !dbg !178
  %63 = add nsw i32 %62, 1, !dbg !178
  store i32 %63, i32* %6, align 4, !dbg !178
  br label %45, !dbg !179, !llvm.loop !180

64:                                               ; preds = %57
  br label %65, !dbg !182

65:                                               ; preds = %64
  %66 = load i32, i32* %4, align 4, !dbg !183
  %67 = add nsw i32 %66, 1, !dbg !183
  store i32 %67, i32* %4, align 4, !dbg !183
  br label %10, !dbg !184, !llvm.loop !185

68:                                               ; preds = %22
  ret i8* null, !dbg !187
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !188 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !191, metadata !DIExpression()), !dbg !192
  br label %3, !dbg !193

3:                                                ; preds = %1
  br label %4, !dbg !194

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !196
  br label %6, !dbg !196

6:                                                ; preds = %4
  br label %7, !dbg !198

7:                                                ; preds = %6
  br label %8, !dbg !196

8:                                                ; preds = %7
  br label %9, !dbg !194

9:                                                ; preds = %8
  call void @vmutex_acquire(%struct.vmutex_t* noundef @lock), !dbg !200
  ret void, !dbg !201
}

; Function Attrs: noinline nounwind uwtable
define internal void @vmutex_acquire(%struct.vmutex_t* noundef %0) #0 !dbg !202 {
  %2 = alloca %struct.vmutex_t*, align 8
  store %struct.vmutex_t* %0, %struct.vmutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vmutex_t** %2, metadata !206, metadata !DIExpression()), !dbg !207
  %3 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !208
  %4 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %3, i32 0, i32 0, !dbg !210
  %5 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %4, i32 noundef 0, i32 noundef 1), !dbg !211
  %6 = icmp eq i32 %5, 0, !dbg !212
  br i1 %6, label %7, label %8, !dbg !213

7:                                                ; preds = %1
  br label %27, !dbg !214

8:                                                ; preds = %1
  call void @vatomic_fence_rlx(), !dbg !216
  br label %9, !dbg !217

9:                                                ; preds = %22, %8
  %10 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !218
  %11 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %10, i32 0, i32 0, !dbg !219
  %12 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %11, i32 noundef 0, i32 noundef 1), !dbg !220
  %13 = icmp ne i32 %12, 0, !dbg !221
  br i1 %13, label %14, label %27, !dbg !217

14:                                               ; preds = %9
  call void @vatomic_fence_rlx(), !dbg !222
  %15 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !224
  %16 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %15, i32 0, i32 1, !dbg !225
  call void @vatomic32_inc_rlx(%struct.vatomic32_s* noundef %16), !dbg !226
  %17 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !227
  %18 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %17, i32 0, i32 0, !dbg !229
  %19 = call i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %18, i32 noundef 1, i32 noundef 2), !dbg !230
  %20 = icmp ne i32 %19, 1, !dbg !231
  br i1 %20, label %21, label %22, !dbg !232

21:                                               ; preds = %14
  call void @vatomic_fence_rlx(), !dbg !233
  br label %22, !dbg !235

22:                                               ; preds = %21, %14
  %23 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !236
  %24 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %23, i32 0, i32 0, !dbg !237
  call void @vfutex_wait(%struct.vatomic32_s* noundef %24, i32 noundef 2), !dbg !238
  %25 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !239
  %26 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %25, i32 0, i32 1, !dbg !240
  call void @vatomic32_dec_rlx(%struct.vatomic32_s* noundef %26), !dbg !241
  br label %9, !dbg !217, !llvm.loop !242

27:                                               ; preds = %7, %9
  ret void, !dbg !244
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !245 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !246, metadata !DIExpression()), !dbg !247
  br label %3, !dbg !248

3:                                                ; preds = %1
  br label %4, !dbg !249

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !251
  br label %6, !dbg !251

6:                                                ; preds = %4
  br label %7, !dbg !253

7:                                                ; preds = %6
  br label %8, !dbg !251

8:                                                ; preds = %7
  br label %9, !dbg !249

9:                                                ; preds = %8
  call void @vmutex_release(%struct.vmutex_t* noundef @lock), !dbg !255
  ret void, !dbg !256
}

; Function Attrs: noinline nounwind uwtable
define internal void @vmutex_release(%struct.vmutex_t* noundef %0) #0 !dbg !257 {
  %2 = alloca %struct.vmutex_t*, align 8
  %3 = alloca i32, align 4
  store %struct.vmutex_t* %0, %struct.vmutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vmutex_t** %2, metadata !258, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.declare(metadata i32* %3, metadata !260, metadata !DIExpression()), !dbg !261
  %4 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !262
  %5 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %4, i32 0, i32 0, !dbg !263
  %6 = call i32 @vatomic32_xchg_rel(%struct.vatomic32_s* noundef %5, i32 noundef 0), !dbg !264
  store i32 %6, i32* %3, align 4, !dbg !261
  %7 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !265
  %8 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %7, i32 0, i32 1, !dbg !267
  %9 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %8), !dbg !268
  %10 = icmp ugt i32 %9, 0, !dbg !269
  br i1 %10, label %14, label %11, !dbg !270

11:                                               ; preds = %1
  %12 = load i32, i32* %3, align 4, !dbg !271
  %13 = icmp ne i32 %12, 1, !dbg !272
  br i1 %13, label %14, label %17, !dbg !273

14:                                               ; preds = %11, %1
  %15 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !274
  %16 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %15, i32 0, i32 0, !dbg !276
  call void @vfutex_wake(%struct.vatomic32_s* noundef %16, i32 noundef 1), !dbg !277
  br label %17, !dbg !278

17:                                               ; preds = %14, %11
  ret void, !dbg !279
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !280 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !285, metadata !DIExpression()), !dbg !286
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !287, metadata !DIExpression()), !dbg !288
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !289, metadata !DIExpression()), !dbg !290
  call void @llvm.dbg.declare(metadata i32* %7, metadata !291, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.declare(metadata i32* %8, metadata !293, metadata !DIExpression()), !dbg !294
  %9 = load i32, i32* %6, align 4, !dbg !295
  %10 = load i32, i32* %5, align 4, !dbg !296
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !297
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !298
  %13 = load i32, i32* %12, align 4, !dbg !298
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldaxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !299, !srcloc !300
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !299
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !299
  store i32 %15, i32* %7, align 4, !dbg !299
  store i32 %16, i32* %8, align 4, !dbg !299
  %17 = load i32, i32* %7, align 4, !dbg !301
  ret i32 %17, !dbg !302
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic_fence_rlx() #0 !dbg !303 {
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !305, !srcloc !306
  ret void, !dbg !307
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_inc_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !308 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !312, metadata !DIExpression()), !dbg !313
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !314
  %4 = call i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %3), !dbg !315
  ret void, !dbg !316
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !317 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !318, metadata !DIExpression()), !dbg !319
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !320, metadata !DIExpression()), !dbg !321
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !322, metadata !DIExpression()), !dbg !323
  call void @llvm.dbg.declare(metadata i32* %7, metadata !324, metadata !DIExpression()), !dbg !325
  call void @llvm.dbg.declare(metadata i32* %8, metadata !326, metadata !DIExpression()), !dbg !327
  %9 = load i32, i32* %6, align 4, !dbg !328
  %10 = load i32, i32* %5, align 4, !dbg !329
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !330
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !331
  %13 = load i32, i32* %12, align 4, !dbg !331
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !332, !srcloc !333
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !332
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !332
  store i32 %15, i32* %7, align 4, !dbg !332
  store i32 %16, i32* %8, align 4, !dbg !332
  %17 = load i32, i32* %7, align 4, !dbg !334
  ret i32 %17, !dbg !335
}

; Function Attrs: noinline nounwind uwtable
define internal void @vfutex_wait(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !336 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !339, metadata !DIExpression()), !dbg !340
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !341, metadata !DIExpression()), !dbg !342
  call void @llvm.dbg.declare(metadata i32* %5, metadata !343, metadata !DIExpression()), !dbg !344
  %6 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef @signal), !dbg !345
  store i32 %6, i32* %5, align 4, !dbg !344
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !346
  %8 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %7), !dbg !348
  %9 = load i32, i32* %4, align 4, !dbg !349
  %10 = icmp ne i32 %8, %9, !dbg !350
  br i1 %10, label %11, label %12, !dbg !351

11:                                               ; preds = %2
  br label %15, !dbg !352

12:                                               ; preds = %2
  %13 = load i32, i32* %5, align 4, !dbg !353
  %14 = call i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef @signal, i32 noundef %13), !dbg !354
  br label %15, !dbg !355

15:                                               ; preds = %12, %11
  ret void, !dbg !355
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_dec_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !356 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !357, metadata !DIExpression()), !dbg !358
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !359
  %4 = call i32 @vatomic32_get_dec_rlx(%struct.vatomic32_s* noundef %3), !dbg !360
  ret void, !dbg !361
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !362 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !365, metadata !DIExpression()), !dbg !366
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !367
  %4 = call i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !368
  ret i32 %4, !dbg !369
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !370 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !373, metadata !DIExpression()), !dbg !374
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !375, metadata !DIExpression()), !dbg !376
  call void @llvm.dbg.declare(metadata i32* %5, metadata !377, metadata !DIExpression()), !dbg !378
  call void @llvm.dbg.declare(metadata i32* %6, metadata !379, metadata !DIExpression()), !dbg !380
  call void @llvm.dbg.declare(metadata i32* %7, metadata !381, metadata !DIExpression()), !dbg !382
  %8 = load i32, i32* %4, align 4, !dbg !383
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !384
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !385
  %11 = load i32, i32* %10, align 4, !dbg !385
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #6, !dbg !383, !srcloc !386
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !383
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !383
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !383
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !383
  store i32 %13, i32* %5, align 4, !dbg !383
  store i32 %14, i32* %7, align 4, !dbg !383
  store i32 %15, i32* %6, align 4, !dbg !383
  store i32 %16, i32* %4, align 4, !dbg !383
  %17 = load i32, i32* %5, align 4, !dbg !387
  ret i32 %17, !dbg !388
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !389 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !394, metadata !DIExpression()), !dbg !395
  call void @llvm.dbg.declare(metadata i32* %3, metadata !396, metadata !DIExpression()), !dbg !397
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !398
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !399
  %6 = load i32, i32* %5, align 4, !dbg !399
  %7 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !400, !srcloc !401
  store i32 %7, i32* %3, align 4, !dbg !400
  %8 = load i32, i32* %3, align 4, !dbg !402
  ret i32 %8, !dbg !403
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !404 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !405, metadata !DIExpression()), !dbg !406
  call void @llvm.dbg.declare(metadata i32* %3, metadata !407, metadata !DIExpression()), !dbg !408
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !409
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !410
  %6 = load i32, i32* %5, align 4, !dbg !410
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !411, !srcloc !412
  store i32 %7, i32* %3, align 4, !dbg !411
  %8 = load i32, i32* %3, align 4, !dbg !413
  ret i32 %8, !dbg !414
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !415 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !418, metadata !DIExpression()), !dbg !419
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !420, metadata !DIExpression()), !dbg !421
  call void @llvm.dbg.declare(metadata i32* %5, metadata !422, metadata !DIExpression()), !dbg !423
  %6 = load i32, i32* %4, align 4, !dbg !424
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !425
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !426
  %9 = load i32, i32* %8, align 4, !dbg !426
  %10 = call i32 asm sideeffect "1:\0Aldr ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.eq 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !427, !srcloc !428
  store i32 %10, i32* %5, align 4, !dbg !427
  %11 = load i32, i32* %5, align 4, !dbg !429
  ret i32 %11, !dbg !430
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_dec_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !431 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !432, metadata !DIExpression()), !dbg !433
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !434
  %4 = call i32 @vatomic32_get_sub_rlx(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !435
  ret i32 %4, !dbg !436
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_sub_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !437 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !438, metadata !DIExpression()), !dbg !439
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !440, metadata !DIExpression()), !dbg !441
  call void @llvm.dbg.declare(metadata i32* %5, metadata !442, metadata !DIExpression()), !dbg !443
  call void @llvm.dbg.declare(metadata i32* %6, metadata !444, metadata !DIExpression()), !dbg !445
  call void @llvm.dbg.declare(metadata i32* %7, metadata !446, metadata !DIExpression()), !dbg !447
  %8 = load i32, i32* %4, align 4, !dbg !448
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !449
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !450
  %11 = load i32, i32* %10, align 4, !dbg !450
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Asub ${1:w}, ${0:w}, ${3:w}\0Astxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #6, !dbg !448, !srcloc !451
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !448
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !448
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !448
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !448
  store i32 %13, i32* %5, align 4, !dbg !448
  store i32 %14, i32* %7, align 4, !dbg !448
  store i32 %15, i32* %6, align 4, !dbg !448
  store i32 %16, i32* %4, align 4, !dbg !448
  %17 = load i32, i32* %5, align 4, !dbg !452
  ret i32 %17, !dbg !453
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_xchg_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !454 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !455, metadata !DIExpression()), !dbg !456
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !457, metadata !DIExpression()), !dbg !458
  call void @llvm.dbg.declare(metadata i32* %5, metadata !459, metadata !DIExpression()), !dbg !460
  call void @llvm.dbg.declare(metadata i32* %6, metadata !461, metadata !DIExpression()), !dbg !462
  %7 = load i32, i32* %4, align 4, !dbg !463
  %8 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !464
  %9 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %8, i32 0, i32 0, !dbg !465
  %10 = load i32, i32* %9, align 4, !dbg !465
  %11 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $3\0A1:\0Aldxr ${0:w}, $3\0Astlxr  ${1:w}, ${2:w}, $3\0Acbnz ${1:w}, 1b\0A", "=&r,=&r,r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %7, i32 %10) #6, !dbg !466, !srcloc !467
  %12 = extractvalue { i32, i32 } %11, 0, !dbg !466
  %13 = extractvalue { i32, i32 } %11, 1, !dbg !466
  store i32 %12, i32* %5, align 4, !dbg !466
  store i32 %13, i32* %6, align 4, !dbg !466
  %14 = load i32, i32* %5, align 4, !dbg !468
  ret i32 %14, !dbg !469
}

; Function Attrs: noinline nounwind uwtable
define internal void @vfutex_wake(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !470 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !471, metadata !DIExpression()), !dbg !472
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !473, metadata !DIExpression()), !dbg !474
  call void @vatomic32_inc_rel(%struct.vatomic32_s* noundef @signal), !dbg !475
  ret void, !dbg !476
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !477 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !478, metadata !DIExpression()), !dbg !479
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !480
  %4 = call i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %3), !dbg !481
  ret void, !dbg !482
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !483 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !484, metadata !DIExpression()), !dbg !485
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !486
  %4 = call i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !487
  ret i32 %4, !dbg !488
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !489 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !490, metadata !DIExpression()), !dbg !491
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !492, metadata !DIExpression()), !dbg !493
  call void @llvm.dbg.declare(metadata i32* %5, metadata !494, metadata !DIExpression()), !dbg !495
  call void @llvm.dbg.declare(metadata i32* %6, metadata !496, metadata !DIExpression()), !dbg !497
  call void @llvm.dbg.declare(metadata i32* %7, metadata !498, metadata !DIExpression()), !dbg !499
  %8 = load i32, i32* %4, align 4, !dbg !500
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !501
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !502
  %11 = load i32, i32* %10, align 4, !dbg !502
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astlxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #6, !dbg !500, !srcloc !503
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !500
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !500
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !500
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !500
  store i32 %13, i32* %5, align 4, !dbg !500
  store i32 %14, i32* %7, align 4, !dbg !500
  store i32 %15, i32* %6, align 4, !dbg !500
  store i32 %16, i32* %4, align 4, !dbg !500
  %17 = load i32, i32* %5, align 4, !dbg !504
  ret i32 %17, !dbg !505
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!38, !39, !40, !41, !42, !43, !44}
!llvm.ident = !{!45}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !34, line: 100, type: !25, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !11, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/thread/verify/mutex_musl.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "e7885d2707a22497ddae5c98c6ea2cdb")
!4 = !{!5, !6}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 37, baseType: !8)
!7 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !9, line: 90, baseType: !10)
!9 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = !{!12, !0, !32, !35}
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !14, line: 10, type: !15, isLocal: false, isDefinition: true)
!14 = !DIFile(filename: "thread/verify/mutex_musl.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "e7885d2707a22497ddae5c98c6ea2cdb")
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "vmutex_t", file: !16, line: 44, baseType: !17)
!16 = !DIFile(filename: "thread/include/vsync/thread/mutex/musl.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "614d9bef26e902659be21628cd56cf27")
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !16, line: 41, size: 64, elements: !18)
!18 = !{!19, !31}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !17, file: !16, line: 42, baseType: !20, size: 32, align: 32)
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
!31 = !DIDerivedType(tag: DW_TAG_member, name: "waiters", scope: !17, file: !16, line: 43, baseType: !20, size: 32, align: 32, offset: 32)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !34, line: 101, type: !25, isLocal: true, isDefinition: true)
!34 = !DIFile(filename: "utils/include/test/boilerplate/lock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4187ade4a536ecfd1f9ed3ab727ca965")
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "signal", scope: !2, file: !37, line: 22, type: !20, isLocal: true, isDefinition: true)
!37 = !DIFile(filename: "thread/include/vsync/thread/internal/futex.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "dede791c10be6385ed442bbae7c7e9b0")
!38 = !{i32 7, !"Dwarf Version", i32 5}
!39 = !{i32 2, !"Debug Info Version", i32 3}
!40 = !{i32 1, !"wchar_size", i32 4}
!41 = !{i32 7, !"PIC Level", i32 2}
!42 = !{i32 7, !"PIE Level", i32 2}
!43 = !{i32 7, !"uwtable", i32 1}
!44 = !{i32 7, !"frame-pointer", i32 2}
!45 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!46 = distinct !DISubprogram(name: "init", scope: !34, file: !34, line: 68, type: !47, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!47 = !DISubroutineType(types: !48)
!48 = !{null}
!49 = !{}
!50 = !DILocation(line: 70, column: 1, scope: !46)
!51 = distinct !DISubprogram(name: "post", scope: !34, file: !34, line: 77, type: !47, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!52 = !DILocation(line: 79, column: 1, scope: !51)
!53 = distinct !DISubprogram(name: "fini", scope: !34, file: !34, line: 86, type: !47, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!54 = !DILocation(line: 88, column: 1, scope: !53)
!55 = distinct !DISubprogram(name: "cs", scope: !34, file: !34, line: 104, type: !47, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!56 = !DILocation(line: 106, column: 11, scope: !55)
!57 = !DILocation(line: 107, column: 11, scope: !55)
!58 = !DILocation(line: 108, column: 1, scope: !55)
!59 = distinct !DISubprogram(name: "check", scope: !34, file: !34, line: 110, type: !47, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!60 = !DILocation(line: 112, column: 5, scope: !61)
!61 = distinct !DILexicalBlock(scope: !62, file: !34, line: 112, column: 5)
!62 = distinct !DILexicalBlock(scope: !59, file: !34, line: 112, column: 5)
!63 = !DILocation(line: 112, column: 5, scope: !62)
!64 = !DILocation(line: 113, column: 5, scope: !65)
!65 = distinct !DILexicalBlock(scope: !66, file: !34, line: 113, column: 5)
!66 = distinct !DILexicalBlock(scope: !59, file: !34, line: 113, column: 5)
!67 = !DILocation(line: 113, column: 5, scope: !66)
!68 = !DILocation(line: 114, column: 1, scope: !59)
!69 = distinct !DISubprogram(name: "main", scope: !34, file: !34, line: 141, type: !70, scopeLine: 142, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!70 = !DISubroutineType(types: !71)
!71 = !{!72}
!72 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!73 = !DILocalVariable(name: "t", scope: !69, file: !34, line: 143, type: !74)
!74 = !DICompositeType(tag: DW_TAG_array_type, baseType: !75, size: 128, elements: !77)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !76, line: 27, baseType: !10)
!76 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!77 = !{!78}
!78 = !DISubrange(count: 2)
!79 = !DILocation(line: 143, column: 15, scope: !69)
!80 = !DILocation(line: 150, column: 5, scope: !69)
!81 = !DILocalVariable(name: "i", scope: !82, file: !34, line: 152, type: !6)
!82 = distinct !DILexicalBlock(scope: !69, file: !34, line: 152, column: 5)
!83 = !DILocation(line: 152, column: 21, scope: !82)
!84 = !DILocation(line: 152, column: 10, scope: !82)
!85 = !DILocation(line: 152, column: 28, scope: !86)
!86 = distinct !DILexicalBlock(scope: !82, file: !34, line: 152, column: 5)
!87 = !DILocation(line: 152, column: 30, scope: !86)
!88 = !DILocation(line: 152, column: 5, scope: !82)
!89 = !DILocation(line: 153, column: 33, scope: !90)
!90 = distinct !DILexicalBlock(scope: !86, file: !34, line: 152, column: 47)
!91 = !DILocation(line: 153, column: 31, scope: !90)
!92 = !DILocation(line: 153, column: 53, scope: !90)
!93 = !DILocation(line: 153, column: 45, scope: !90)
!94 = !DILocation(line: 153, column: 15, scope: !90)
!95 = !DILocation(line: 154, column: 5, scope: !90)
!96 = !DILocation(line: 152, column: 43, scope: !86)
!97 = !DILocation(line: 152, column: 5, scope: !86)
!98 = distinct !{!98, !88, !99, !100}
!99 = !DILocation(line: 154, column: 5, scope: !82)
!100 = !{!"llvm.loop.mustprogress"}
!101 = !DILocation(line: 156, column: 5, scope: !69)
!102 = !DILocalVariable(name: "i", scope: !103, file: !34, line: 158, type: !6)
!103 = distinct !DILexicalBlock(scope: !69, file: !34, line: 158, column: 5)
!104 = !DILocation(line: 158, column: 21, scope: !103)
!105 = !DILocation(line: 158, column: 10, scope: !103)
!106 = !DILocation(line: 158, column: 28, scope: !107)
!107 = distinct !DILexicalBlock(scope: !103, file: !34, line: 158, column: 5)
!108 = !DILocation(line: 158, column: 30, scope: !107)
!109 = !DILocation(line: 158, column: 5, scope: !103)
!110 = !DILocation(line: 159, column: 30, scope: !111)
!111 = distinct !DILexicalBlock(scope: !107, file: !34, line: 158, column: 47)
!112 = !DILocation(line: 159, column: 28, scope: !111)
!113 = !DILocation(line: 159, column: 15, scope: !111)
!114 = !DILocation(line: 160, column: 5, scope: !111)
!115 = !DILocation(line: 158, column: 43, scope: !107)
!116 = !DILocation(line: 158, column: 5, scope: !107)
!117 = distinct !{!117, !109, !118, !100}
!118 = !DILocation(line: 160, column: 5, scope: !103)
!119 = !DILocation(line: 167, column: 5, scope: !69)
!120 = !DILocation(line: 168, column: 5, scope: !69)
!121 = !DILocation(line: 170, column: 5, scope: !69)
!122 = distinct !DISubprogram(name: "run", scope: !34, file: !34, line: 119, type: !123, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!123 = !DISubroutineType(types: !124)
!124 = !{!5, !5}
!125 = !DILocalVariable(name: "arg", arg: 1, scope: !122, file: !34, line: 119, type: !5)
!126 = !DILocation(line: 119, column: 11, scope: !122)
!127 = !DILocalVariable(name: "tid", scope: !122, file: !34, line: 121, type: !25)
!128 = !DILocation(line: 121, column: 15, scope: !122)
!129 = !DILocation(line: 121, column: 33, scope: !122)
!130 = !DILocation(line: 121, column: 21, scope: !122)
!131 = !DILocalVariable(name: "i", scope: !132, file: !34, line: 125, type: !72)
!132 = distinct !DILexicalBlock(scope: !122, file: !34, line: 125, column: 5)
!133 = !DILocation(line: 125, column: 14, scope: !132)
!134 = !DILocation(line: 125, column: 10, scope: !132)
!135 = !DILocation(line: 125, column: 21, scope: !136)
!136 = distinct !DILexicalBlock(scope: !132, file: !34, line: 125, column: 5)
!137 = !DILocation(line: 125, column: 23, scope: !136)
!138 = !DILocation(line: 125, column: 28, scope: !136)
!139 = !DILocation(line: 125, column: 31, scope: !136)
!140 = !DILocation(line: 0, scope: !136)
!141 = !DILocation(line: 125, column: 5, scope: !132)
!142 = !DILocalVariable(name: "j", scope: !143, file: !34, line: 129, type: !72)
!143 = distinct !DILexicalBlock(scope: !144, file: !34, line: 129, column: 9)
!144 = distinct !DILexicalBlock(scope: !136, file: !34, line: 125, column: 63)
!145 = !DILocation(line: 129, column: 18, scope: !143)
!146 = !DILocation(line: 129, column: 14, scope: !143)
!147 = !DILocation(line: 129, column: 25, scope: !148)
!148 = distinct !DILexicalBlock(scope: !143, file: !34, line: 129, column: 9)
!149 = !DILocation(line: 129, column: 27, scope: !148)
!150 = !DILocation(line: 129, column: 32, scope: !148)
!151 = !DILocation(line: 129, column: 35, scope: !148)
!152 = !DILocation(line: 0, scope: !148)
!153 = !DILocation(line: 129, column: 9, scope: !143)
!154 = !DILocation(line: 130, column: 21, scope: !155)
!155 = distinct !DILexicalBlock(scope: !148, file: !34, line: 129, column: 67)
!156 = !DILocation(line: 130, column: 13, scope: !155)
!157 = !DILocation(line: 131, column: 13, scope: !155)
!158 = !DILocation(line: 132, column: 9, scope: !155)
!159 = !DILocation(line: 129, column: 63, scope: !148)
!160 = !DILocation(line: 129, column: 9, scope: !148)
!161 = distinct !{!161, !153, !162, !100}
!162 = !DILocation(line: 132, column: 9, scope: !143)
!163 = !DILocalVariable(name: "j", scope: !164, file: !34, line: 133, type: !72)
!164 = distinct !DILexicalBlock(scope: !144, file: !34, line: 133, column: 9)
!165 = !DILocation(line: 133, column: 18, scope: !164)
!166 = !DILocation(line: 133, column: 14, scope: !164)
!167 = !DILocation(line: 133, column: 25, scope: !168)
!168 = distinct !DILexicalBlock(scope: !164, file: !34, line: 133, column: 9)
!169 = !DILocation(line: 133, column: 27, scope: !168)
!170 = !DILocation(line: 133, column: 32, scope: !168)
!171 = !DILocation(line: 133, column: 35, scope: !168)
!172 = !DILocation(line: 0, scope: !168)
!173 = !DILocation(line: 133, column: 9, scope: !164)
!174 = !DILocation(line: 134, column: 21, scope: !175)
!175 = distinct !DILexicalBlock(scope: !168, file: !34, line: 133, column: 67)
!176 = !DILocation(line: 134, column: 13, scope: !175)
!177 = !DILocation(line: 135, column: 9, scope: !175)
!178 = !DILocation(line: 133, column: 63, scope: !168)
!179 = !DILocation(line: 133, column: 9, scope: !168)
!180 = distinct !{!180, !173, !181, !100}
!181 = !DILocation(line: 135, column: 9, scope: !164)
!182 = !DILocation(line: 136, column: 5, scope: !144)
!183 = !DILocation(line: 125, column: 59, scope: !136)
!184 = !DILocation(line: 125, column: 5, scope: !136)
!185 = distinct !{!185, !141, !186, !100}
!186 = !DILocation(line: 136, column: 5, scope: !132)
!187 = !DILocation(line: 137, column: 5, scope: !122)
!188 = distinct !DISubprogram(name: "acquire", scope: !14, file: !14, line: 13, type: !189, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!189 = !DISubroutineType(types: !190)
!190 = !{null, !25}
!191 = !DILocalVariable(name: "tid", arg: 1, scope: !188, file: !14, line: 13, type: !25)
!192 = !DILocation(line: 13, column: 19, scope: !188)
!193 = !DILocation(line: 15, column: 5, scope: !188)
!194 = !DILocation(line: 15, column: 5, scope: !195)
!195 = distinct !DILexicalBlock(scope: !188, file: !14, line: 15, column: 5)
!196 = !DILocation(line: 15, column: 5, scope: !197)
!197 = distinct !DILexicalBlock(scope: !195, file: !14, line: 15, column: 5)
!198 = !DILocation(line: 15, column: 5, scope: !199)
!199 = distinct !DILexicalBlock(scope: !197, file: !14, line: 15, column: 5)
!200 = !DILocation(line: 16, column: 5, scope: !188)
!201 = !DILocation(line: 17, column: 1, scope: !188)
!202 = distinct !DISubprogram(name: "vmutex_acquire", scope: !16, file: !16, line: 63, type: !203, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!203 = !DISubroutineType(types: !204)
!204 = !{null, !205}
!205 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!206 = !DILocalVariable(name: "m", arg: 1, scope: !202, file: !16, line: 63, type: !205)
!207 = !DILocation(line: 63, column: 26, scope: !202)
!208 = !DILocation(line: 65, column: 32, scope: !209)
!209 = distinct !DILexicalBlock(scope: !202, file: !16, line: 65, column: 9)
!210 = !DILocation(line: 65, column: 35, scope: !209)
!211 = !DILocation(line: 65, column: 9, scope: !209)
!212 = !DILocation(line: 65, column: 49, scope: !209)
!213 = !DILocation(line: 65, column: 9, scope: !202)
!214 = !DILocation(line: 66, column: 9, scope: !215)
!215 = distinct !DILexicalBlock(scope: !209, file: !16, line: 65, column: 56)
!216 = !DILocation(line: 68, column: 5, scope: !202)
!217 = !DILocation(line: 78, column: 5, scope: !202)
!218 = !DILocation(line: 78, column: 35, scope: !202)
!219 = !DILocation(line: 78, column: 38, scope: !202)
!220 = !DILocation(line: 78, column: 12, scope: !202)
!221 = !DILocation(line: 78, column: 52, scope: !202)
!222 = !DILocation(line: 79, column: 9, scope: !223)
!223 = distinct !DILexicalBlock(scope: !202, file: !16, line: 78, column: 59)
!224 = !DILocation(line: 80, column: 28, scope: !223)
!225 = !DILocation(line: 80, column: 31, scope: !223)
!226 = !DILocation(line: 80, column: 9, scope: !223)
!227 = !DILocation(line: 81, column: 36, scope: !228)
!228 = distinct !DILexicalBlock(scope: !223, file: !16, line: 81, column: 13)
!229 = !DILocation(line: 81, column: 39, scope: !228)
!230 = !DILocation(line: 81, column: 13, scope: !228)
!231 = !DILocation(line: 81, column: 53, scope: !228)
!232 = !DILocation(line: 81, column: 13, scope: !223)
!233 = !DILocation(line: 82, column: 13, scope: !234)
!234 = distinct !DILexicalBlock(scope: !228, file: !16, line: 81, column: 60)
!235 = !DILocation(line: 83, column: 9, scope: !234)
!236 = !DILocation(line: 84, column: 22, scope: !223)
!237 = !DILocation(line: 84, column: 25, scope: !223)
!238 = !DILocation(line: 84, column: 9, scope: !223)
!239 = !DILocation(line: 85, column: 28, scope: !223)
!240 = !DILocation(line: 85, column: 31, scope: !223)
!241 = !DILocation(line: 85, column: 9, scope: !223)
!242 = distinct !{!242, !217, !243, !100}
!243 = !DILocation(line: 86, column: 5, scope: !202)
!244 = !DILocation(line: 87, column: 1, scope: !202)
!245 = distinct !DISubprogram(name: "release", scope: !14, file: !14, line: 20, type: !189, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!246 = !DILocalVariable(name: "tid", arg: 1, scope: !245, file: !14, line: 20, type: !25)
!247 = !DILocation(line: 20, column: 19, scope: !245)
!248 = !DILocation(line: 22, column: 5, scope: !245)
!249 = !DILocation(line: 22, column: 5, scope: !250)
!250 = distinct !DILexicalBlock(scope: !245, file: !14, line: 22, column: 5)
!251 = !DILocation(line: 22, column: 5, scope: !252)
!252 = distinct !DILexicalBlock(scope: !250, file: !14, line: 22, column: 5)
!253 = !DILocation(line: 22, column: 5, scope: !254)
!254 = distinct !DILexicalBlock(scope: !252, file: !14, line: 22, column: 5)
!255 = !DILocation(line: 23, column: 5, scope: !245)
!256 = !DILocation(line: 24, column: 1, scope: !245)
!257 = distinct !DISubprogram(name: "vmutex_release", scope: !16, file: !16, line: 94, type: !203, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!258 = !DILocalVariable(name: "m", arg: 1, scope: !257, file: !16, line: 94, type: !205)
!259 = !DILocation(line: 94, column: 26, scope: !257)
!260 = !DILocalVariable(name: "old", scope: !257, file: !16, line: 96, type: !25)
!261 = !DILocation(line: 96, column: 15, scope: !257)
!262 = !DILocation(line: 96, column: 41, scope: !257)
!263 = !DILocation(line: 96, column: 44, scope: !257)
!264 = !DILocation(line: 96, column: 21, scope: !257)
!265 = !DILocation(line: 97, column: 29, scope: !266)
!266 = distinct !DILexicalBlock(scope: !257, file: !16, line: 97, column: 9)
!267 = !DILocation(line: 97, column: 32, scope: !266)
!268 = !DILocation(line: 97, column: 9, scope: !266)
!269 = !DILocation(line: 97, column: 41, scope: !266)
!270 = !DILocation(line: 97, column: 46, scope: !266)
!271 = !DILocation(line: 97, column: 49, scope: !266)
!272 = !DILocation(line: 97, column: 53, scope: !266)
!273 = !DILocation(line: 97, column: 9, scope: !257)
!274 = !DILocation(line: 98, column: 22, scope: !275)
!275 = distinct !DILexicalBlock(scope: !266, file: !16, line: 97, column: 60)
!276 = !DILocation(line: 98, column: 25, scope: !275)
!277 = !DILocation(line: 98, column: 9, scope: !275)
!278 = !DILocation(line: 99, column: 5, scope: !275)
!279 = !DILocation(line: 100, column: 1, scope: !257)
!280 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !281, file: !281, line: 311, type: !282, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!281 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!282 = !DISubroutineType(types: !283)
!283 = !{!25, !284, !25, !25}
!284 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!285 = !DILocalVariable(name: "a", arg: 1, scope: !280, file: !281, line: 311, type: !284)
!286 = !DILocation(line: 311, column: 36, scope: !280)
!287 = !DILocalVariable(name: "e", arg: 2, scope: !280, file: !281, line: 311, type: !25)
!288 = !DILocation(line: 311, column: 49, scope: !280)
!289 = !DILocalVariable(name: "v", arg: 3, scope: !280, file: !281, line: 311, type: !25)
!290 = !DILocation(line: 311, column: 62, scope: !280)
!291 = !DILocalVariable(name: "oldv", scope: !280, file: !281, line: 313, type: !25)
!292 = !DILocation(line: 313, column: 15, scope: !280)
!293 = !DILocalVariable(name: "tmp", scope: !280, file: !281, line: 314, type: !25)
!294 = !DILocation(line: 314, column: 15, scope: !280)
!295 = !DILocation(line: 325, column: 22, scope: !280)
!296 = !DILocation(line: 325, column: 36, scope: !280)
!297 = !DILocation(line: 325, column: 48, scope: !280)
!298 = !DILocation(line: 325, column: 51, scope: !280)
!299 = !DILocation(line: 315, column: 5, scope: !280)
!300 = !{i64 463805, i64 463839, i64 463854, i64 463887, i64 463921, i64 463941, i64 463983, i64 464012}
!301 = !DILocation(line: 327, column: 12, scope: !280)
!302 = !DILocation(line: 327, column: 5, scope: !280)
!303 = distinct !DISubprogram(name: "vatomic_fence_rlx", scope: !304, file: !304, line: 58, type: !47, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!304 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!305 = !DILocation(line: 60, column: 5, scope: !303)
!306 = !{i64 2148017349}
!307 = !DILocation(line: 61, column: 1, scope: !303)
!308 = distinct !DISubprogram(name: "vatomic32_inc_rlx", scope: !309, file: !309, line: 2956, type: !310, scopeLine: 2957, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!309 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!310 = !DISubroutineType(types: !311)
!311 = !{null, !284}
!312 = !DILocalVariable(name: "a", arg: 1, scope: !308, file: !309, line: 2956, type: !284)
!313 = !DILocation(line: 2956, column: 32, scope: !308)
!314 = !DILocation(line: 2958, column: 33, scope: !308)
!315 = !DILocation(line: 2958, column: 11, scope: !308)
!316 = !DILocation(line: 2959, column: 1, scope: !308)
!317 = distinct !DISubprogram(name: "vatomic32_cmpxchg_rlx", scope: !281, file: !281, line: 361, type: !282, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!318 = !DILocalVariable(name: "a", arg: 1, scope: !317, file: !281, line: 361, type: !284)
!319 = !DILocation(line: 361, column: 36, scope: !317)
!320 = !DILocalVariable(name: "e", arg: 2, scope: !317, file: !281, line: 361, type: !25)
!321 = !DILocation(line: 361, column: 49, scope: !317)
!322 = !DILocalVariable(name: "v", arg: 3, scope: !317, file: !281, line: 361, type: !25)
!323 = !DILocation(line: 361, column: 62, scope: !317)
!324 = !DILocalVariable(name: "oldv", scope: !317, file: !281, line: 363, type: !25)
!325 = !DILocation(line: 363, column: 15, scope: !317)
!326 = !DILocalVariable(name: "tmp", scope: !317, file: !281, line: 364, type: !25)
!327 = !DILocation(line: 364, column: 15, scope: !317)
!328 = !DILocation(line: 375, column: 22, scope: !317)
!329 = !DILocation(line: 375, column: 36, scope: !317)
!330 = !DILocation(line: 375, column: 48, scope: !317)
!331 = !DILocation(line: 375, column: 51, scope: !317)
!332 = !DILocation(line: 365, column: 5, scope: !317)
!333 = !{i64 465357, i64 465391, i64 465406, i64 465438, i64 465472, i64 465492, i64 465534, i64 465563}
!334 = !DILocation(line: 377, column: 12, scope: !317)
!335 = !DILocation(line: 377, column: 5, scope: !317)
!336 = distinct !DISubprogram(name: "vfutex_wait", scope: !37, file: !37, line: 25, type: !337, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!337 = !DISubroutineType(types: !338)
!338 = !{null, !284, !25}
!339 = !DILocalVariable(name: "m", arg: 1, scope: !336, file: !37, line: 25, type: !284)
!340 = !DILocation(line: 25, column: 26, scope: !336)
!341 = !DILocalVariable(name: "v", arg: 2, scope: !336, file: !37, line: 25, type: !25)
!342 = !DILocation(line: 25, column: 39, scope: !336)
!343 = !DILocalVariable(name: "s", scope: !336, file: !37, line: 27, type: !25)
!344 = !DILocation(line: 27, column: 15, scope: !336)
!345 = !DILocation(line: 27, column: 19, scope: !336)
!346 = !DILocation(line: 28, column: 28, scope: !347)
!347 = distinct !DILexicalBlock(scope: !336, file: !37, line: 28, column: 9)
!348 = !DILocation(line: 28, column: 9, scope: !347)
!349 = !DILocation(line: 28, column: 34, scope: !347)
!350 = !DILocation(line: 28, column: 31, scope: !347)
!351 = !DILocation(line: 28, column: 9, scope: !336)
!352 = !DILocation(line: 29, column: 9, scope: !347)
!353 = !DILocation(line: 30, column: 38, scope: !336)
!354 = !DILocation(line: 30, column: 5, scope: !336)
!355 = !DILocation(line: 31, column: 1, scope: !336)
!356 = distinct !DISubprogram(name: "vatomic32_dec_rlx", scope: !309, file: !309, line: 4064, type: !310, scopeLine: 4065, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!357 = !DILocalVariable(name: "a", arg: 1, scope: !356, file: !309, line: 4064, type: !284)
!358 = !DILocation(line: 4064, column: 32, scope: !356)
!359 = !DILocation(line: 4066, column: 33, scope: !356)
!360 = !DILocation(line: 4066, column: 11, scope: !356)
!361 = !DILocation(line: 4067, column: 1, scope: !356)
!362 = distinct !DISubprogram(name: "vatomic32_get_inc_rlx", scope: !309, file: !309, line: 2516, type: !363, scopeLine: 2517, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!363 = !DISubroutineType(types: !364)
!364 = !{!25, !284}
!365 = !DILocalVariable(name: "a", arg: 1, scope: !362, file: !309, line: 2516, type: !284)
!366 = !DILocation(line: 2516, column: 36, scope: !362)
!367 = !DILocation(line: 2518, column: 34, scope: !362)
!368 = !DILocation(line: 2518, column: 12, scope: !362)
!369 = !DILocation(line: 2518, column: 5, scope: !362)
!370 = distinct !DISubprogram(name: "vatomic32_get_add_rlx", scope: !281, file: !281, line: 1388, type: !371, scopeLine: 1389, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!371 = !DISubroutineType(types: !372)
!372 = !{!25, !284, !25}
!373 = !DILocalVariable(name: "a", arg: 1, scope: !370, file: !281, line: 1388, type: !284)
!374 = !DILocation(line: 1388, column: 36, scope: !370)
!375 = !DILocalVariable(name: "v", arg: 2, scope: !370, file: !281, line: 1388, type: !25)
!376 = !DILocation(line: 1388, column: 49, scope: !370)
!377 = !DILocalVariable(name: "oldv", scope: !370, file: !281, line: 1390, type: !25)
!378 = !DILocation(line: 1390, column: 15, scope: !370)
!379 = !DILocalVariable(name: "tmp", scope: !370, file: !281, line: 1391, type: !25)
!380 = !DILocation(line: 1391, column: 15, scope: !370)
!381 = !DILocalVariable(name: "newv", scope: !370, file: !281, line: 1392, type: !25)
!382 = !DILocation(line: 1392, column: 15, scope: !370)
!383 = !DILocation(line: 1393, column: 5, scope: !370)
!384 = !DILocation(line: 1401, column: 19, scope: !370)
!385 = !DILocation(line: 1401, column: 22, scope: !370)
!386 = !{i64 495989, i64 496023, i64 496038, i64 496070, i64 496112, i64 496153}
!387 = !DILocation(line: 1404, column: 12, scope: !370)
!388 = !DILocation(line: 1404, column: 5, scope: !370)
!389 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !304, file: !304, line: 85, type: !390, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!390 = !DISubroutineType(types: !391)
!391 = !{!25, !392}
!392 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !393, size: 64)
!393 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !20)
!394 = !DILocalVariable(name: "a", arg: 1, scope: !389, file: !304, line: 85, type: !392)
!395 = !DILocation(line: 85, column: 39, scope: !389)
!396 = !DILocalVariable(name: "val", scope: !389, file: !304, line: 87, type: !25)
!397 = !DILocation(line: 87, column: 15, scope: !389)
!398 = !DILocation(line: 90, column: 32, scope: !389)
!399 = !DILocation(line: 90, column: 35, scope: !389)
!400 = !DILocation(line: 88, column: 5, scope: !389)
!401 = !{i64 398395}
!402 = !DILocation(line: 92, column: 12, scope: !389)
!403 = !DILocation(line: 92, column: 5, scope: !389)
!404 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !304, file: !304, line: 101, type: !390, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!405 = !DILocalVariable(name: "a", arg: 1, scope: !404, file: !304, line: 101, type: !392)
!406 = !DILocation(line: 101, column: 39, scope: !404)
!407 = !DILocalVariable(name: "val", scope: !404, file: !304, line: 103, type: !25)
!408 = !DILocation(line: 103, column: 15, scope: !404)
!409 = !DILocation(line: 106, column: 32, scope: !404)
!410 = !DILocation(line: 106, column: 35, scope: !404)
!411 = !DILocation(line: 104, column: 5, scope: !404)
!412 = !{i64 398897}
!413 = !DILocation(line: 108, column: 12, scope: !404)
!414 = !DILocation(line: 108, column: 5, scope: !404)
!415 = distinct !DISubprogram(name: "vatomic32_await_neq_rlx", scope: !304, file: !304, line: 912, type: !416, scopeLine: 913, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!416 = !DISubroutineType(types: !417)
!417 = !{!25, !392, !25}
!418 = !DILocalVariable(name: "a", arg: 1, scope: !415, file: !304, line: 912, type: !392)
!419 = !DILocation(line: 912, column: 44, scope: !415)
!420 = !DILocalVariable(name: "v", arg: 2, scope: !415, file: !304, line: 912, type: !25)
!421 = !DILocation(line: 912, column: 57, scope: !415)
!422 = !DILocalVariable(name: "val", scope: !415, file: !304, line: 914, type: !25)
!423 = !DILocation(line: 914, column: 15, scope: !415)
!424 = !DILocation(line: 921, column: 21, scope: !415)
!425 = !DILocation(line: 921, column: 33, scope: !415)
!426 = !DILocation(line: 921, column: 36, scope: !415)
!427 = !DILocation(line: 915, column: 5, scope: !415)
!428 = !{i64 421503, i64 421519, i64 421549, i64 421582}
!429 = !DILocation(line: 923, column: 12, scope: !415)
!430 = !DILocation(line: 923, column: 5, scope: !415)
!431 = distinct !DISubprogram(name: "vatomic32_get_dec_rlx", scope: !309, file: !309, line: 3624, type: !363, scopeLine: 3625, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!432 = !DILocalVariable(name: "a", arg: 1, scope: !431, file: !309, line: 3624, type: !284)
!433 = !DILocation(line: 3624, column: 36, scope: !431)
!434 = !DILocation(line: 3626, column: 34, scope: !431)
!435 = !DILocation(line: 3626, column: 12, scope: !431)
!436 = !DILocation(line: 3626, column: 5, scope: !431)
!437 = distinct !DISubprogram(name: "vatomic32_get_sub_rlx", scope: !281, file: !281, line: 1413, type: !371, scopeLine: 1414, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!438 = !DILocalVariable(name: "a", arg: 1, scope: !437, file: !281, line: 1413, type: !284)
!439 = !DILocation(line: 1413, column: 36, scope: !437)
!440 = !DILocalVariable(name: "v", arg: 2, scope: !437, file: !281, line: 1413, type: !25)
!441 = !DILocation(line: 1413, column: 49, scope: !437)
!442 = !DILocalVariable(name: "oldv", scope: !437, file: !281, line: 1415, type: !25)
!443 = !DILocation(line: 1415, column: 15, scope: !437)
!444 = !DILocalVariable(name: "tmp", scope: !437, file: !281, line: 1416, type: !25)
!445 = !DILocation(line: 1416, column: 15, scope: !437)
!446 = !DILocalVariable(name: "newv", scope: !437, file: !281, line: 1417, type: !25)
!447 = !DILocation(line: 1417, column: 15, scope: !437)
!448 = !DILocation(line: 1418, column: 5, scope: !437)
!449 = !DILocation(line: 1426, column: 19, scope: !437)
!450 = !DILocation(line: 1426, column: 22, scope: !437)
!451 = !{i64 496749, i64 496783, i64 496798, i64 496830, i64 496872, i64 496913}
!452 = !DILocation(line: 1429, column: 12, scope: !437)
!453 = !DILocation(line: 1429, column: 5, scope: !437)
!454 = distinct !DISubprogram(name: "vatomic32_xchg_rel", scope: !281, file: !281, line: 66, type: !371, scopeLine: 67, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!455 = !DILocalVariable(name: "a", arg: 1, scope: !454, file: !281, line: 66, type: !284)
!456 = !DILocation(line: 66, column: 33, scope: !454)
!457 = !DILocalVariable(name: "v", arg: 2, scope: !454, file: !281, line: 66, type: !25)
!458 = !DILocation(line: 66, column: 46, scope: !454)
!459 = !DILocalVariable(name: "oldv", scope: !454, file: !281, line: 68, type: !25)
!460 = !DILocation(line: 68, column: 15, scope: !454)
!461 = !DILocalVariable(name: "tmp", scope: !454, file: !281, line: 69, type: !25)
!462 = !DILocation(line: 69, column: 15, scope: !454)
!463 = !DILocation(line: 77, column: 22, scope: !454)
!464 = !DILocation(line: 77, column: 34, scope: !454)
!465 = !DILocation(line: 77, column: 37, scope: !454)
!466 = !DILocation(line: 70, column: 5, scope: !454)
!467 = !{i64 456456, i64 456490, i64 456505, i64 456537, i64 456580}
!468 = !DILocation(line: 79, column: 12, scope: !454)
!469 = !DILocation(line: 79, column: 5, scope: !454)
!470 = distinct !DISubprogram(name: "vfutex_wake", scope: !37, file: !37, line: 34, type: !337, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!471 = !DILocalVariable(name: "m", arg: 1, scope: !470, file: !37, line: 34, type: !284)
!472 = !DILocation(line: 34, column: 26, scope: !470)
!473 = !DILocalVariable(name: "v", arg: 2, scope: !470, file: !37, line: 34, type: !25)
!474 = !DILocation(line: 34, column: 39, scope: !470)
!475 = !DILocation(line: 36, column: 5, scope: !470)
!476 = !DILocation(line: 37, column: 1, scope: !470)
!477 = distinct !DISubprogram(name: "vatomic32_inc_rel", scope: !309, file: !309, line: 2945, type: !310, scopeLine: 2946, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!478 = !DILocalVariable(name: "a", arg: 1, scope: !477, file: !309, line: 2945, type: !284)
!479 = !DILocation(line: 2945, column: 32, scope: !477)
!480 = !DILocation(line: 2947, column: 33, scope: !477)
!481 = !DILocation(line: 2947, column: 11, scope: !477)
!482 = !DILocation(line: 2948, column: 1, scope: !477)
!483 = distinct !DISubprogram(name: "vatomic32_get_inc_rel", scope: !309, file: !309, line: 2505, type: !363, scopeLine: 2506, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!484 = !DILocalVariable(name: "a", arg: 1, scope: !483, file: !309, line: 2505, type: !284)
!485 = !DILocation(line: 2505, column: 36, scope: !483)
!486 = !DILocation(line: 2507, column: 34, scope: !483)
!487 = !DILocation(line: 2507, column: 12, scope: !483)
!488 = !DILocation(line: 2507, column: 5, scope: !483)
!489 = distinct !DISubprogram(name: "vatomic32_get_add_rel", scope: !281, file: !281, line: 1263, type: !371, scopeLine: 1264, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!490 = !DILocalVariable(name: "a", arg: 1, scope: !489, file: !281, line: 1263, type: !284)
!491 = !DILocation(line: 1263, column: 36, scope: !489)
!492 = !DILocalVariable(name: "v", arg: 2, scope: !489, file: !281, line: 1263, type: !25)
!493 = !DILocation(line: 1263, column: 49, scope: !489)
!494 = !DILocalVariable(name: "oldv", scope: !489, file: !281, line: 1265, type: !25)
!495 = !DILocation(line: 1265, column: 15, scope: !489)
!496 = !DILocalVariable(name: "tmp", scope: !489, file: !281, line: 1266, type: !25)
!497 = !DILocation(line: 1266, column: 15, scope: !489)
!498 = !DILocalVariable(name: "newv", scope: !489, file: !281, line: 1267, type: !25)
!499 = !DILocation(line: 1267, column: 15, scope: !489)
!500 = !DILocation(line: 1268, column: 5, scope: !489)
!501 = !DILocation(line: 1276, column: 19, scope: !489)
!502 = !DILocation(line: 1276, column: 22, scope: !489)
!503 = !{i64 492191, i64 492225, i64 492240, i64 492272, i64 492314, i64 492356}
!504 = !DILocation(line: 1279, column: 12, scope: !489)
!505 = !DILocation(line: 1279, column: 5, scope: !489)
