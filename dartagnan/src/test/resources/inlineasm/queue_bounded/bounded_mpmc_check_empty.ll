; ModuleID = '/home/stefano/huawei/libvsync/datastruct/queue/bounded/test/bounded_mpmc_check_empty.c'
source_filename = "/home/stefano/huawei/libvsync/datastruct/queue/bounded/test/bounded_mpmc_check_empty.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bounded_mpmc_s = type { %struct.vatomic32_s, %struct.vatomic32_s, %struct.vatomic32_s, %struct.vatomic32_s, i8**, i32 }
%struct.vatomic32_s = type { i32 }
%struct.xbo_s = type { i32, i32, i32, i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_val = dso_local global [4 x i64] zeroinitializer, align 16, !dbg !0
@g_queue = dso_local global %struct.bounded_mpmc_s zeroinitializer, align 8, !dbg !31
@g_cs_x = dso_local global %struct.vatomic32_s zeroinitializer, align 4, !dbg !57
@.str = private unnamed_addr constant [14 x i8] c"idx < (2 * 2)\00", align 1
@.str.1 = private unnamed_addr constant [87 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/bounded/test/bounded_mpmc_check_empty.c\00", align 1
@__PRETTY_FUNCTION__.reader = private unnamed_addr constant [21 x i8] c"void *reader(void *)\00", align 1
@g_ret = dso_local global [4 x i64] zeroinitializer, align 16, !dbg !54
@.str.2 = private unnamed_addr constant [16 x i8] c"g_ret[idx] != 0\00", align 1
@g_buf = dso_local global [4 x i8*] zeroinitializer, align 16, !dbg !25
@.str.3 = private unnamed_addr constant [17 x i8] c"found == (2 * 2)\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.4 = private unnamed_addr constant [13 x i8] c"x == (2 * 2)\00", align 1
@.str.5 = private unnamed_addr constant [27 x i8] c"ret == QUEUE_BOUNDED_EMPTY\00", align 1
@.str.6 = private unnamed_addr constant [15 x i8] c"buffer is NULL\00", align 1
@.str.7 = private unnamed_addr constant [22 x i8] c"b && \22buffer is NULL\22\00", align 1
@.str.8 = private unnamed_addr constant [90 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/bounded/include/vsync/queue/bounded_mpmc.h\00", align 1
@__PRETTY_FUNCTION__.bounded_mpmc_init = private unnamed_addr constant [61 x i8] c"void bounded_mpmc_init(bounded_mpmc_t *, void **, vuint32_t)\00", align 1
@.str.9 = private unnamed_addr constant [19 x i8] c"buffer with 0 size\00", align 1
@.str.10 = private unnamed_addr constant [31 x i8] c"s != 0 && \22buffer with 0 size\22\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @sched_yield() #0 !dbg !67 {
  ret i32 0, !dbg !72
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @writer(i8* noundef %0) #0 !dbg !73 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca %struct.xbo_s, align 4
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !76, metadata !DIExpression()), !dbg !77
  call void @llvm.dbg.declare(metadata i64* %3, metadata !78, metadata !DIExpression()), !dbg !79
  %7 = load i8*, i8** %2, align 8, !dbg !80
  %8 = ptrtoint i8* %7 to i64, !dbg !81
  store i64 %8, i64* %3, align 8, !dbg !79
  call void @llvm.dbg.declare(metadata %struct.xbo_s* %4, metadata !82, metadata !DIExpression()), !dbg !91
  call void @xbo_init(%struct.xbo_s* noundef %4, i32 noundef 0, i32 noundef 100, i32 noundef 2), !dbg !92
  call void @llvm.dbg.declare(metadata i64* %5, metadata !93, metadata !DIExpression()), !dbg !95
  store i64 0, i64* %5, align 8, !dbg !95
  br label %9, !dbg !96

9:                                                ; preds = %32, %1
  %10 = load i64, i64* %5, align 8, !dbg !97
  %11 = icmp ult i64 %10, 2, !dbg !99
  br i1 %11, label %12, label %35, !dbg !100

12:                                               ; preds = %9
  call void @llvm.dbg.declare(metadata i64* %6, metadata !101, metadata !DIExpression()), !dbg !103
  %13 = load i64, i64* %3, align 8, !dbg !104
  %14 = mul i64 %13, 2, !dbg !105
  %15 = load i64, i64* %5, align 8, !dbg !106
  %16 = add i64 %14, %15, !dbg !107
  store i64 %16, i64* %6, align 8, !dbg !103
  %17 = load i64, i64* %3, align 8, !dbg !108
  %18 = mul i64 %17, 10, !dbg !109
  %19 = load i64, i64* %5, align 8, !dbg !110
  %20 = add i64 %18, %19, !dbg !111
  %21 = add i64 %20, 1, !dbg !112
  %22 = load i64, i64* %6, align 8, !dbg !113
  %23 = getelementptr inbounds [4 x i64], [4 x i64]* @g_val, i64 0, i64 %22, !dbg !114
  store i64 %21, i64* %23, align 8, !dbg !115
  br label %24, !dbg !116

24:                                               ; preds = %30, %12
  %25 = load i64, i64* %6, align 8, !dbg !117
  %26 = getelementptr inbounds [4 x i64], [4 x i64]* @g_val, i64 0, i64 %25, !dbg !118
  %27 = bitcast i64* %26 to i8*, !dbg !119
  %28 = call i32 @bounded_mpmc_enq(%struct.bounded_mpmc_s* noundef @g_queue, i8* noundef %27), !dbg !120
  %29 = icmp ne i32 %28, 0, !dbg !121
  br i1 %29, label %30, label %31, !dbg !116

30:                                               ; preds = %24
  call void @verification_ignore(), !dbg !122
  br label %24, !dbg !116, !llvm.loop !124

31:                                               ; preds = %24
  call void @xbo_reset(%struct.xbo_s* noundef %4), !dbg !127
  br label %32, !dbg !128

32:                                               ; preds = %31
  %33 = load i64, i64* %5, align 8, !dbg !129
  %34 = add i64 %33, 1, !dbg !129
  store i64 %34, i64* %5, align 8, !dbg !129
  br label %9, !dbg !130, !llvm.loop !131

35:                                               ; preds = %9
  ret i8* null, !dbg !133
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @xbo_init(%struct.xbo_s* noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) #0 !dbg !134 {
  %5 = alloca %struct.xbo_s*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.xbo_s* %0, %struct.xbo_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.xbo_s** %5, metadata !138, metadata !DIExpression()), !dbg !139
  store i32 %1, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !140, metadata !DIExpression()), !dbg !141
  store i32 %2, i32* %7, align 4
  call void @llvm.dbg.declare(metadata i32* %7, metadata !142, metadata !DIExpression()), !dbg !143
  store i32 %3, i32* %8, align 4
  call void @llvm.dbg.declare(metadata i32* %8, metadata !144, metadata !DIExpression()), !dbg !145
  ret void, !dbg !146
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @bounded_mpmc_enq(%struct.bounded_mpmc_s* noundef %0, i8* noundef %1) #0 !dbg !147 {
  %3 = alloca i32, align 4
  %4 = alloca %struct.bounded_mpmc_s*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.bounded_mpmc_s* %0, %struct.bounded_mpmc_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.bounded_mpmc_s** %4, metadata !152, metadata !DIExpression()), !dbg !153
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !154, metadata !DIExpression()), !dbg !155
  call void @llvm.dbg.declare(metadata i32* %6, metadata !156, metadata !DIExpression()), !dbg !157
  call void @llvm.dbg.declare(metadata i32* %7, metadata !158, metadata !DIExpression()), !dbg !159
  %8 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !160
  %9 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %8, i32 0, i32 0, !dbg !161
  %10 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %9), !dbg !162
  store i32 %10, i32* %6, align 4, !dbg !163
  %11 = load i32, i32* %6, align 4, !dbg !164
  %12 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !166
  %13 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %12, i32 0, i32 3, !dbg !167
  %14 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %13), !dbg !168
  %15 = sub i32 %11, %14, !dbg !169
  %16 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !170
  %17 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %16, i32 0, i32 5, !dbg !171
  %18 = load i32, i32* %17, align 8, !dbg !171
  %19 = icmp eq i32 %15, %18, !dbg !172
  br i1 %19, label %20, label %21, !dbg !173

20:                                               ; preds = %2
  store i32 1, i32* %3, align 4, !dbg !174
  br label %51, !dbg !174

21:                                               ; preds = %2
  %22 = load i32, i32* %6, align 4, !dbg !176
  %23 = add i32 %22, 1, !dbg !177
  store i32 %23, i32* %7, align 4, !dbg !178
  %24 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !179
  %25 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %24, i32 0, i32 0, !dbg !181
  %26 = load i32, i32* %6, align 4, !dbg !182
  %27 = load i32, i32* %7, align 4, !dbg !183
  %28 = call i32 @vatomic32_cmpxchg_rel(%struct.vatomic32_s* noundef %25, i32 noundef %26, i32 noundef %27), !dbg !184
  %29 = load i32, i32* %6, align 4, !dbg !185
  %30 = icmp ne i32 %28, %29, !dbg !186
  br i1 %30, label %31, label %32, !dbg !187

31:                                               ; preds = %21
  store i32 3, i32* %3, align 4, !dbg !188
  br label %51, !dbg !188

32:                                               ; preds = %21
  %33 = load i8*, i8** %5, align 8, !dbg !190
  %34 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !191
  %35 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %34, i32 0, i32 4, !dbg !192
  %36 = load i8**, i8*** %35, align 8, !dbg !192
  %37 = load i32, i32* %6, align 4, !dbg !193
  %38 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !194
  %39 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %38, i32 0, i32 5, !dbg !195
  %40 = load i32, i32* %39, align 8, !dbg !195
  %41 = urem i32 %37, %40, !dbg !196
  %42 = zext i32 %41 to i64, !dbg !191
  %43 = getelementptr inbounds i8*, i8** %36, i64 %42, !dbg !191
  store i8* %33, i8** %43, align 8, !dbg !197
  %44 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !198
  %45 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %44, i32 0, i32 1, !dbg !199
  %46 = load i32, i32* %6, align 4, !dbg !200
  %47 = call i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %45, i32 noundef %46), !dbg !201
  %48 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !202
  %49 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %48, i32 0, i32 1, !dbg !203
  %50 = load i32, i32* %7, align 4, !dbg !204
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %49, i32 noundef %50), !dbg !205
  store i32 0, i32* %3, align 4, !dbg !206
  br label %51, !dbg !206

51:                                               ; preds = %32, %31, %20
  %52 = load i32, i32* %3, align 4, !dbg !207
  ret i32 %52, !dbg !207
}

; Function Attrs: noinline nounwind uwtable
define internal void @verification_ignore() #0 !dbg !208 {
  %1 = call i32 (i32, ...) bitcast (i32 (...)* @__VERIFIER_assume to i32 (i32, ...)*)(i32 noundef 0), !dbg !212
  ret void, !dbg !213
}

; Function Attrs: noinline nounwind uwtable
define internal void @xbo_reset(%struct.xbo_s* noundef %0) #0 !dbg !214 {
  %2 = alloca %struct.xbo_s*, align 8
  store %struct.xbo_s* %0, %struct.xbo_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.xbo_s** %2, metadata !217, metadata !DIExpression()), !dbg !218
  ret void, !dbg !219
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @reader(i8* noundef %0) #0 !dbg !220 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca %struct.xbo_s, align 4
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !221, metadata !DIExpression()), !dbg !222
  call void @llvm.dbg.declare(metadata i64* %3, metadata !223, metadata !DIExpression()), !dbg !224
  %7 = load i8*, i8** %2, align 8, !dbg !225
  %8 = ptrtoint i8* %7 to i64, !dbg !226
  store i64 %8, i64* %3, align 8, !dbg !224
  br label %9, !dbg !227

9:                                                ; preds = %1
  br label %10, !dbg !228

10:                                               ; preds = %9
  %11 = load i64, i64* %3, align 8, !dbg !230
  br label %12, !dbg !230

12:                                               ; preds = %10
  br label %13, !dbg !232

13:                                               ; preds = %12
  br label %14, !dbg !230

14:                                               ; preds = %13
  br label %15, !dbg !228

15:                                               ; preds = %14
  call void @llvm.dbg.declare(metadata %struct.xbo_s* %4, metadata !234, metadata !DIExpression()), !dbg !235
  call void @xbo_init(%struct.xbo_s* noundef %4, i32 noundef 0, i32 noundef 100, i32 noundef 2), !dbg !236
  br label %16, !dbg !237

16:                                               ; preds = %42, %15
  call void @llvm.dbg.declare(metadata i8** %5, metadata !238, metadata !DIExpression()), !dbg !240
  store i8* null, i8** %5, align 8, !dbg !240
  %17 = call i32 @bounded_mpmc_deq(%struct.bounded_mpmc_s* noundef @g_queue, i8** noundef %5), !dbg !241
  %18 = icmp eq i32 %17, 0, !dbg !243
  br i1 %18, label %19, label %40, !dbg !244

19:                                               ; preds = %16
  call void @llvm.dbg.declare(metadata i32* %6, metadata !245, metadata !DIExpression()), !dbg !247
  %20 = call i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef @g_cs_x), !dbg !248
  store i32 %20, i32* %6, align 4, !dbg !247
  %21 = load i32, i32* %6, align 4, !dbg !249
  %22 = icmp ult i32 %21, 4, !dbg !249
  br i1 %22, label %23, label %24, !dbg !252

23:                                               ; preds = %19
  br label %25, !dbg !252

24:                                               ; preds = %19
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([87 x i8], [87 x i8]* @.str.1, i64 0, i64 0), i32 noundef 82, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.reader, i64 0, i64 0)) #5, !dbg !249
  unreachable, !dbg !249

25:                                               ; preds = %23
  %26 = load i8*, i8** %5, align 8, !dbg !253
  %27 = bitcast i8* %26 to i64*, !dbg !254
  %28 = load i64, i64* %27, align 8, !dbg !255
  %29 = load i32, i32* %6, align 4, !dbg !256
  %30 = zext i32 %29 to i64, !dbg !257
  %31 = getelementptr inbounds [4 x i64], [4 x i64]* @g_ret, i64 0, i64 %30, !dbg !257
  store i64 %28, i64* %31, align 8, !dbg !258
  %32 = load i32, i32* %6, align 4, !dbg !259
  %33 = zext i32 %32 to i64, !dbg !259
  %34 = getelementptr inbounds [4 x i64], [4 x i64]* @g_ret, i64 0, i64 %33, !dbg !259
  %35 = load i64, i64* %34, align 8, !dbg !259
  %36 = icmp ne i64 %35, 0, !dbg !259
  br i1 %36, label %37, label %38, !dbg !262

37:                                               ; preds = %25
  br label %39, !dbg !262

38:                                               ; preds = %25
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([87 x i8], [87 x i8]* @.str.1, i64 0, i64 0), i32 noundef 84, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.reader, i64 0, i64 0)) #5, !dbg !259
  unreachable, !dbg !259

39:                                               ; preds = %37
  br label %41, !dbg !263

40:                                               ; preds = %16
  call void @verification_ignore(), !dbg !264
  br label %41

41:                                               ; preds = %40, %39
  call void @xbo_reset(%struct.xbo_s* noundef %4), !dbg !266
  br label %42, !dbg !267

42:                                               ; preds = %41
  %43 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef @g_cs_x), !dbg !268
  %44 = icmp ne i32 %43, 4, !dbg !269
  br i1 %44, label %16, label %45, !dbg !267, !llvm.loop !270

45:                                               ; preds = %42
  ret i8* null, !dbg !272
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @bounded_mpmc_deq(%struct.bounded_mpmc_s* noundef %0, i8** noundef %1) #0 !dbg !273 {
  %3 = alloca i32, align 4
  %4 = alloca %struct.bounded_mpmc_s*, align 8
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.bounded_mpmc_s* %0, %struct.bounded_mpmc_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.bounded_mpmc_s** %4, metadata !276, metadata !DIExpression()), !dbg !277
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !278, metadata !DIExpression()), !dbg !279
  call void @llvm.dbg.declare(metadata i32* %6, metadata !280, metadata !DIExpression()), !dbg !281
  call void @llvm.dbg.declare(metadata i32* %7, metadata !282, metadata !DIExpression()), !dbg !283
  %8 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !284
  %9 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %8, i32 0, i32 2, !dbg !285
  %10 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %9), !dbg !286
  store i32 %10, i32* %6, align 4, !dbg !287
  %11 = load i32, i32* %6, align 4, !dbg !288
  %12 = add i32 %11, 1, !dbg !289
  store i32 %12, i32* %7, align 4, !dbg !290
  %13 = load i32, i32* %6, align 4, !dbg !291
  %14 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !293
  %15 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %14, i32 0, i32 1, !dbg !294
  %16 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %15), !dbg !295
  %17 = icmp eq i32 %13, %16, !dbg !296
  br i1 %17, label %18, label %19, !dbg !297

18:                                               ; preds = %2
  store i32 2, i32* %3, align 4, !dbg !298
  br label %48, !dbg !298

19:                                               ; preds = %2
  %20 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !300
  %21 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %20, i32 0, i32 2, !dbg !302
  %22 = load i32, i32* %6, align 4, !dbg !303
  %23 = load i32, i32* %7, align 4, !dbg !304
  %24 = call i32 @vatomic32_cmpxchg_rel(%struct.vatomic32_s* noundef %21, i32 noundef %22, i32 noundef %23), !dbg !305
  %25 = load i32, i32* %6, align 4, !dbg !306
  %26 = icmp ne i32 %24, %25, !dbg !307
  br i1 %26, label %27, label %28, !dbg !308

27:                                               ; preds = %19
  store i32 3, i32* %3, align 4, !dbg !309
  br label %48, !dbg !309

28:                                               ; preds = %19
  %29 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !311
  %30 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %29, i32 0, i32 4, !dbg !312
  %31 = load i8**, i8*** %30, align 8, !dbg !312
  %32 = load i32, i32* %6, align 4, !dbg !313
  %33 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !314
  %34 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %33, i32 0, i32 5, !dbg !315
  %35 = load i32, i32* %34, align 8, !dbg !315
  %36 = urem i32 %32, %35, !dbg !316
  %37 = zext i32 %36 to i64, !dbg !311
  %38 = getelementptr inbounds i8*, i8** %31, i64 %37, !dbg !311
  %39 = load i8*, i8** %38, align 8, !dbg !311
  %40 = load i8**, i8*** %5, align 8, !dbg !317
  store i8* %39, i8** %40, align 8, !dbg !318
  %41 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !319
  %42 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %41, i32 0, i32 3, !dbg !320
  %43 = load i32, i32* %6, align 4, !dbg !321
  %44 = call i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %42, i32 noundef %43), !dbg !322
  %45 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !323
  %46 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %45, i32 0, i32 3, !dbg !324
  %47 = load i32, i32* %7, align 4, !dbg !325
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %46, i32 noundef %47), !dbg !326
  store i32 0, i32* %3, align 4, !dbg !327
  br label %48, !dbg !327

48:                                               ; preds = %28, %27, %18
  %49 = load i32, i32* %3, align 4, !dbg !328
  ret i32 %49, !dbg !328
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !329 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !334, metadata !DIExpression()), !dbg !335
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !336
  %4 = call i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !337
  ret i32 %4, !dbg !338
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !339 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !345, metadata !DIExpression()), !dbg !346
  call void @llvm.dbg.declare(metadata i32* %3, metadata !347, metadata !DIExpression()), !dbg !348
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !349
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !350
  %6 = load i32, i32* %5, align 4, !dbg !350
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !351, !srcloc !352
  store i32 %7, i32* %3, align 4, !dbg !351
  %8 = load i32, i32* %3, align 4, !dbg !353
  ret i32 %8, !dbg !354
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !355 {
  %1 = alloca i32, align 4
  %2 = alloca [4 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i8*, align 8
  %11 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @bounded_mpmc_init(%struct.bounded_mpmc_s* noundef @g_queue, i8** noundef getelementptr inbounds ([4 x i8*], [4 x i8*]* @g_buf, i64 0, i64 0), i32 noundef 4), !dbg !356
  call void @llvm.dbg.declare(metadata [4 x i64]* %2, metadata !357, metadata !DIExpression()), !dbg !361
  call void @llvm.dbg.declare(metadata i64* %3, metadata !362, metadata !DIExpression()), !dbg !364
  store i64 0, i64* %3, align 8, !dbg !364
  br label %12, !dbg !365

12:                                               ; preds = %21, %0
  %13 = load i64, i64* %3, align 8, !dbg !366
  %14 = icmp ult i64 %13, 2, !dbg !368
  br i1 %14, label %15, label %24, !dbg !369

15:                                               ; preds = %12
  %16 = load i64, i64* %3, align 8, !dbg !370
  %17 = getelementptr inbounds [4 x i64], [4 x i64]* %2, i64 0, i64 %16, !dbg !372
  %18 = load i64, i64* %3, align 8, !dbg !373
  %19 = inttoptr i64 %18 to i8*, !dbg !374
  %20 = call i32 @pthread_create(i64* noundef %17, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef %19) #6, !dbg !375
  br label %21, !dbg !376

21:                                               ; preds = %15
  %22 = load i64, i64* %3, align 8, !dbg !377
  %23 = add i64 %22, 1, !dbg !377
  store i64 %23, i64* %3, align 8, !dbg !377
  br label %12, !dbg !378, !llvm.loop !379

24:                                               ; preds = %12
  call void @llvm.dbg.declare(metadata i64* %4, metadata !381, metadata !DIExpression()), !dbg !383
  store i64 0, i64* %4, align 8, !dbg !383
  br label %25, !dbg !384

25:                                               ; preds = %35, %24
  %26 = load i64, i64* %4, align 8, !dbg !385
  %27 = icmp ult i64 %26, 2, !dbg !387
  br i1 %27, label %28, label %38, !dbg !388

28:                                               ; preds = %25
  %29 = load i64, i64* %4, align 8, !dbg !389
  %30 = add i64 2, %29, !dbg !391
  %31 = getelementptr inbounds [4 x i64], [4 x i64]* %2, i64 0, i64 %30, !dbg !392
  %32 = load i64, i64* %4, align 8, !dbg !393
  %33 = inttoptr i64 %32 to i8*, !dbg !394
  %34 = call i32 @pthread_create(i64* noundef %31, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef %33) #6, !dbg !395
  br label %35, !dbg !396

35:                                               ; preds = %28
  %36 = load i64, i64* %4, align 8, !dbg !397
  %37 = add i64 %36, 1, !dbg !397
  store i64 %37, i64* %4, align 8, !dbg !397
  br label %25, !dbg !398, !llvm.loop !399

38:                                               ; preds = %25
  call void @llvm.dbg.declare(metadata i64* %5, metadata !401, metadata !DIExpression()), !dbg !403
  store i64 0, i64* %5, align 8, !dbg !403
  br label %39, !dbg !404

39:                                               ; preds = %47, %38
  %40 = load i64, i64* %5, align 8, !dbg !405
  %41 = icmp ult i64 %40, 4, !dbg !407
  br i1 %41, label %42, label %50, !dbg !408

42:                                               ; preds = %39
  %43 = load i64, i64* %5, align 8, !dbg !409
  %44 = getelementptr inbounds [4 x i64], [4 x i64]* %2, i64 0, i64 %43, !dbg !411
  %45 = load i64, i64* %44, align 8, !dbg !411
  %46 = call i32 @pthread_join(i64 noundef %45, i8** noundef null), !dbg !412
  br label %47, !dbg !413

47:                                               ; preds = %42
  %48 = load i64, i64* %5, align 8, !dbg !414
  %49 = add i64 %48, 1, !dbg !414
  store i64 %49, i64* %5, align 8, !dbg !414
  br label %39, !dbg !415, !llvm.loop !416

50:                                               ; preds = %39
  call void @llvm.dbg.declare(metadata i32* %6, metadata !418, metadata !DIExpression()), !dbg !419
  store i32 0, i32* %6, align 4, !dbg !419
  call void @llvm.dbg.declare(metadata i32* %7, metadata !420, metadata !DIExpression()), !dbg !422
  store i32 0, i32* %7, align 4, !dbg !422
  br label %51, !dbg !423

51:                                               ; preds = %79, %50
  %52 = load i32, i32* %7, align 4, !dbg !424
  %53 = icmp slt i32 %52, 4, !dbg !426
  br i1 %53, label %54, label %82, !dbg !427

54:                                               ; preds = %51
  call void @llvm.dbg.declare(metadata i32* %8, metadata !428, metadata !DIExpression()), !dbg !431
  store i32 0, i32* %8, align 4, !dbg !431
  br label %55, !dbg !432

55:                                               ; preds = %75, %54
  %56 = load i32, i32* %8, align 4, !dbg !433
  %57 = icmp slt i32 %56, 4, !dbg !435
  br i1 %57, label %58, label %78, !dbg !436

58:                                               ; preds = %55
  %59 = load i32, i32* %7, align 4, !dbg !437
  %60 = sext i32 %59 to i64, !dbg !440
  %61 = getelementptr inbounds [4 x i64], [4 x i64]* @g_val, i64 0, i64 %60, !dbg !440
  %62 = load i64, i64* %61, align 8, !dbg !440
  %63 = load i32, i32* %8, align 4, !dbg !441
  %64 = sext i32 %63 to i64, !dbg !442
  %65 = getelementptr inbounds [4 x i64], [4 x i64]* @g_ret, i64 0, i64 %64, !dbg !442
  %66 = load i64, i64* %65, align 8, !dbg !442
  %67 = icmp eq i64 %62, %66, !dbg !443
  br i1 %67, label %68, label %74, !dbg !444

68:                                               ; preds = %58
  %69 = load i32, i32* %7, align 4, !dbg !445
  %70 = sext i32 %69 to i64, !dbg !447
  %71 = getelementptr inbounds [4 x i64], [4 x i64]* @g_val, i64 0, i64 %70, !dbg !447
  store i64 16777215, i64* %71, align 8, !dbg !448
  %72 = load i32, i32* %6, align 4, !dbg !449
  %73 = add nsw i32 %72, 1, !dbg !449
  store i32 %73, i32* %6, align 4, !dbg !449
  br label %78, !dbg !450

74:                                               ; preds = %58
  br label %75, !dbg !451

75:                                               ; preds = %74
  %76 = load i32, i32* %8, align 4, !dbg !452
  %77 = add nsw i32 %76, 1, !dbg !452
  store i32 %77, i32* %8, align 4, !dbg !452
  br label %55, !dbg !453, !llvm.loop !454

78:                                               ; preds = %68, %55
  br label %79, !dbg !456

79:                                               ; preds = %78
  %80 = load i32, i32* %7, align 4, !dbg !457
  %81 = add nsw i32 %80, 1, !dbg !457
  store i32 %81, i32* %7, align 4, !dbg !457
  br label %51, !dbg !458, !llvm.loop !459

82:                                               ; preds = %51
  %83 = load i32, i32* %6, align 4, !dbg !461
  %84 = icmp eq i32 %83, 4, !dbg !461
  br i1 %84, label %85, label %86, !dbg !464

85:                                               ; preds = %82
  br label %87, !dbg !464

86:                                               ; preds = %82
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([87 x i8], [87 x i8]* @.str.1, i64 0, i64 0), i32 noundef 124, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !461
  unreachable, !dbg !461

87:                                               ; preds = %85
  call void @llvm.dbg.declare(metadata i32* %9, metadata !465, metadata !DIExpression()), !dbg !466
  %88 = call i32 @vatomic32_read(%struct.vatomic32_s* noundef @g_cs_x), !dbg !467
  store i32 %88, i32* %9, align 4, !dbg !466
  %89 = load i32, i32* %9, align 4, !dbg !468
  %90 = icmp eq i32 %89, 4, !dbg !468
  br i1 %90, label %91, label %92, !dbg !471

91:                                               ; preds = %87
  br label %93, !dbg !471

92:                                               ; preds = %87
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([87 x i8], [87 x i8]* @.str.1, i64 0, i64 0), i32 noundef 126, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !468
  unreachable, !dbg !468

93:                                               ; preds = %91
  call void @llvm.dbg.declare(metadata i8** %10, metadata !472, metadata !DIExpression()), !dbg !473
  store i8* null, i8** %10, align 8, !dbg !473
  call void @llvm.dbg.declare(metadata i32* %11, metadata !474, metadata !DIExpression()), !dbg !475
  %94 = call i32 @bounded_mpmc_deq(%struct.bounded_mpmc_s* noundef @g_queue, i8** noundef %10), !dbg !476
  store i32 %94, i32* %11, align 4, !dbg !475
  %95 = load i32, i32* %11, align 4, !dbg !477
  %96 = icmp eq i32 %95, 2, !dbg !477
  br i1 %96, label %97, label %98, !dbg !480

97:                                               ; preds = %93
  br label %99, !dbg !480

98:                                               ; preds = %93
  call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([87 x i8], [87 x i8]* @.str.1, i64 0, i64 0), i32 noundef 130, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !477
  unreachable, !dbg !477

99:                                               ; preds = %97
  br label %100, !dbg !481

100:                                              ; preds = %99
  br label %101, !dbg !482

101:                                              ; preds = %100
  %102 = load i8*, i8** %10, align 8, !dbg !484
  br label %103, !dbg !484

103:                                              ; preds = %101
  %104 = load i32, i32* %11, align 4, !dbg !486
  br label %105, !dbg !486

105:                                              ; preds = %103
  %106 = load i32, i32* %9, align 4, !dbg !488
  br label %107, !dbg !488

107:                                              ; preds = %105
  br label %108, !dbg !490

108:                                              ; preds = %107
  br label %109, !dbg !488

109:                                              ; preds = %108
  br label %110, !dbg !486

110:                                              ; preds = %109
  br label %111, !dbg !484

111:                                              ; preds = %110
  br label %112, !dbg !482

112:                                              ; preds = %111
  ret i32 0, !dbg !492
}

; Function Attrs: noinline nounwind uwtable
define internal void @bounded_mpmc_init(%struct.bounded_mpmc_s* noundef %0, i8** noundef %1, i32 noundef %2) #0 !dbg !493 {
  %4 = alloca %struct.bounded_mpmc_s*, align 8
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  store %struct.bounded_mpmc_s* %0, %struct.bounded_mpmc_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.bounded_mpmc_s** %4, metadata !496, metadata !DIExpression()), !dbg !497
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !498, metadata !DIExpression()), !dbg !499
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !500, metadata !DIExpression()), !dbg !501
  %7 = load i8**, i8*** %5, align 8, !dbg !502
  %8 = icmp ne i8** %7, null, !dbg !502
  br i1 %8, label %9, label %11, !dbg !502

9:                                                ; preds = %3
  br i1 true, label %10, label %11, !dbg !505

10:                                               ; preds = %9
  br label %12, !dbg !505

11:                                               ; preds = %9, %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.7, i64 0, i64 0), i8* noundef getelementptr inbounds ([90 x i8], [90 x i8]* @.str.8, i64 0, i64 0), i32 noundef 52, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__.bounded_mpmc_init, i64 0, i64 0)) #5, !dbg !502
  unreachable, !dbg !502

12:                                               ; preds = %10
  %13 = load i32, i32* %6, align 4, !dbg !506
  %14 = icmp ne i32 %13, 0, !dbg !506
  br i1 %14, label %15, label %17, !dbg !506

15:                                               ; preds = %12
  br i1 true, label %16, label %17, !dbg !509

16:                                               ; preds = %15
  br label %18, !dbg !509

17:                                               ; preds = %15, %12
  call void @__assert_fail(i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.10, i64 0, i64 0), i8* noundef getelementptr inbounds ([90 x i8], [90 x i8]* @.str.8, i64 0, i64 0), i32 noundef 53, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__.bounded_mpmc_init, i64 0, i64 0)) #5, !dbg !506
  unreachable, !dbg !506

18:                                               ; preds = %16
  %19 = load i8**, i8*** %5, align 8, !dbg !510
  %20 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !511
  %21 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %20, i32 0, i32 4, !dbg !512
  store i8** %19, i8*** %21, align 8, !dbg !513
  %22 = load i32, i32* %6, align 4, !dbg !514
  %23 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !515
  %24 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %23, i32 0, i32 5, !dbg !516
  store i32 %22, i32* %24, align 8, !dbg !517
  %25 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !518
  %26 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %25, i32 0, i32 2, !dbg !519
  call void @vatomic32_init(%struct.vatomic32_s* noundef %26, i32 noundef 0), !dbg !520
  %27 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !521
  %28 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %27, i32 0, i32 3, !dbg !522
  call void @vatomic32_init(%struct.vatomic32_s* noundef %28, i32 noundef 0), !dbg !523
  %29 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !524
  %30 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %29, i32 0, i32 0, !dbg !525
  call void @vatomic32_init(%struct.vatomic32_s* noundef %30, i32 noundef 0), !dbg !526
  %31 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !527
  %32 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %31, i32 0, i32 1, !dbg !528
  call void @vatomic32_init(%struct.vatomic32_s* noundef %32, i32 noundef 0), !dbg !529
  ret void, !dbg !530
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read(%struct.vatomic32_s* noundef %0) #0 !dbg !531 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !532, metadata !DIExpression()), !dbg !533
  call void @llvm.dbg.declare(metadata i32* %3, metadata !534, metadata !DIExpression()), !dbg !535
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !536
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !537
  %6 = load i32, i32* %5, align 4, !dbg !537
  %7 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !538, !srcloc !539
  store i32 %7, i32* %3, align 4, !dbg !538
  %8 = load i32, i32* %3, align 4, !dbg !540
  ret i32 %8, !dbg !541
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !542 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !543, metadata !DIExpression()), !dbg !544
  call void @llvm.dbg.declare(metadata i32* %3, metadata !545, metadata !DIExpression()), !dbg !546
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !547
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !548
  %6 = load i32, i32* %5, align 4, !dbg !548
  %7 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !549, !srcloc !550
  store i32 %7, i32* %3, align 4, !dbg !549
  %8 = load i32, i32* %3, align 4, !dbg !551
  ret i32 %8, !dbg !552
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !553 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !557, metadata !DIExpression()), !dbg !558
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !559, metadata !DIExpression()), !dbg !560
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !561, metadata !DIExpression()), !dbg !562
  call void @llvm.dbg.declare(metadata i32* %7, metadata !563, metadata !DIExpression()), !dbg !564
  call void @llvm.dbg.declare(metadata i32* %8, metadata !565, metadata !DIExpression()), !dbg !566
  %9 = load i32, i32* %6, align 4, !dbg !567
  %10 = load i32, i32* %5, align 4, !dbg !568
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !569
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !570
  %13 = load i32, i32* %12, align 4, !dbg !570
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astlxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !571, !srcloc !572
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !571
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !571
  store i32 %15, i32* %7, align 4, !dbg !571
  store i32 %16, i32* %8, align 4, !dbg !571
  %17 = load i32, i32* %7, align 4, !dbg !573
  ret i32 %17, !dbg !574
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !575 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !578, metadata !DIExpression()), !dbg !579
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !580, metadata !DIExpression()), !dbg !581
  call void @llvm.dbg.declare(metadata i32* %5, metadata !582, metadata !DIExpression()), !dbg !583
  %6 = load i32, i32* %4, align 4, !dbg !584
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !585
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !586
  %9 = load i32, i32* %8, align 4, !dbg !586
  %10 = call i32 asm sideeffect "1:\0Aldar ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.ne 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !587, !srcloc !588
  store i32 %10, i32* %5, align 4, !dbg !587
  %11 = load i32, i32* %5, align 4, !dbg !589
  ret i32 %11, !dbg !590
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !591 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !594, metadata !DIExpression()), !dbg !595
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !596, metadata !DIExpression()), !dbg !597
  %5 = load i32, i32* %4, align 4, !dbg !598
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !599
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !600
  %8 = load i32, i32* %7, align 4, !dbg !600
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !601, !srcloc !602
  ret void, !dbg !603
}

declare i32 @__VERIFIER_assume(...) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !604 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !605, metadata !DIExpression()), !dbg !606
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !607, metadata !DIExpression()), !dbg !608
  call void @llvm.dbg.declare(metadata i32* %5, metadata !609, metadata !DIExpression()), !dbg !610
  %6 = load i32, i32* %4, align 4, !dbg !611
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !612
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !613
  %9 = load i32, i32* %8, align 4, !dbg !613
  %10 = call i32 asm sideeffect "1:\0Aldr ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.ne 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !614, !srcloc !615
  store i32 %10, i32* %5, align 4, !dbg !614
  %11 = load i32, i32* %5, align 4, !dbg !616
  ret i32 %11, !dbg !617
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !618 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !621, metadata !DIExpression()), !dbg !622
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !623, metadata !DIExpression()), !dbg !624
  call void @llvm.dbg.declare(metadata i32* %5, metadata !625, metadata !DIExpression()), !dbg !626
  call void @llvm.dbg.declare(metadata i32* %6, metadata !627, metadata !DIExpression()), !dbg !628
  call void @llvm.dbg.declare(metadata i32* %7, metadata !629, metadata !DIExpression()), !dbg !630
  %8 = load i32, i32* %4, align 4, !dbg !631
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !632
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !633
  %11 = load i32, i32* %10, align 4, !dbg !633
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #6, !dbg !631, !srcloc !634
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !631
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !631
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !631
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !631
  store i32 %13, i32* %5, align 4, !dbg !631
  store i32 %14, i32* %7, align 4, !dbg !631
  store i32 %15, i32* %6, align 4, !dbg !631
  store i32 %16, i32* %4, align 4, !dbg !631
  %17 = load i32, i32* %5, align 4, !dbg !635
  ret i32 %17, !dbg !636
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_init(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !637 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !638, metadata !DIExpression()), !dbg !639
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !640, metadata !DIExpression()), !dbg !641
  %5 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !642
  %6 = load i32, i32* %4, align 4, !dbg !643
  call void @vatomic32_write(%struct.vatomic32_s* noundef %5, i32 noundef %6), !dbg !644
  ret void, !dbg !645
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !646 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !647, metadata !DIExpression()), !dbg !648
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !649, metadata !DIExpression()), !dbg !650
  %5 = load i32, i32* %4, align 4, !dbg !651
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !652
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !653
  %8 = load i32, i32* %7, align 4, !dbg !653
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !654, !srcloc !655
  ret void, !dbg !656
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!59, !60, !61, !62, !63, !64, !65}
!llvm.ident = !{!66}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_val", scope: !2, file: !27, line: 45, type: !56, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !13, globals: !24, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/datastruct/queue/bounded/test/bounded_mpmc_check_empty.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "d9f8f034263e79e4d90c246f822e35b1")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 8, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "datastruct/queue/bounded/include/vsync/queue/internal/bounded_ret.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "391da9ed4071ef46b42c0029bc1a53be")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12}
!9 = !DIEnumerator(name: "QUEUE_BOUNDED_OK", value: 0)
!10 = !DIEnumerator(name: "QUEUE_BOUNDED_FULL", value: 1)
!11 = !DIEnumerator(name: "QUEUE_BOUNDED_EMPTY", value: 2)
!12 = !DIEnumerator(name: "QUEUE_BOUNDED_AGAIN", value: 3)
!13 = !{!14, !19, !20}
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !15, line: 37, baseType: !16)
!15 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !17, line: 90, baseType: !18)
!17 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!18 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsize_t", file: !15, line: 43, baseType: !22)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !23, line: 46, baseType: !18)
!23 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!24 = !{!25, !31, !0, !54, !57}
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "g_buf", scope: !2, file: !27, line: 42, type: !28, isLocal: false, isDefinition: true)
!27 = !DIFile(filename: "datastruct/queue/bounded/test/bounded_mpmc_check_empty.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "d9f8f034263e79e4d90c246f822e35b1")
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !19, size: 256, elements: !29)
!29 = !{!30}
!30 = !DISubrange(count: 4)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "g_queue", scope: !2, file: !27, line: 43, type: !33, isLocal: false, isDefinition: true)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "bounded_mpmc_t", file: !34, line: 40, baseType: !35)
!34 = !DIFile(filename: "datastruct/queue/bounded/include/vsync/queue/bounded_mpmc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "10225dc7f7d17a81603a9ca0b9243ec5")
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bounded_mpmc_s", file: !34, line: 31, size: 256, elements: !36)
!36 = !{!37, !48, !49, !50, !51, !53}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "phead", scope: !35, file: !34, line: 32, baseType: !38, size: 32, align: 32)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !39, line: 34, baseType: !40)
!39 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !39, line: 32, size: 32, align: 32, elements: !41)
!41 = !{!42}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !40, file: !39, line: 33, baseType: !43, size: 32)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !15, line: 35, baseType: !44)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !45, line: 26, baseType: !46)
!45 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !47, line: 42, baseType: !7)
!47 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!48 = !DIDerivedType(tag: DW_TAG_member, name: "ptail", scope: !35, file: !34, line: 33, baseType: !38, size: 32, align: 32, offset: 32)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "chead", scope: !35, file: !34, line: 35, baseType: !38, size: 32, align: 32, offset: 64)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "ctail", scope: !35, file: !34, line: 36, baseType: !38, size: 32, align: 32, offset: 96)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "buf", scope: !35, file: !34, line: 38, baseType: !52, size: 64, offset: 128)
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !35, file: !34, line: 39, baseType: !43, size: 32, offset: 192)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "g_ret", scope: !2, file: !27, line: 46, type: !56, isLocal: false, isDefinition: true)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 256, elements: !29)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !27, line: 47, type: !38, isLocal: false, isDefinition: true)
!59 = !{i32 7, !"Dwarf Version", i32 5}
!60 = !{i32 2, !"Debug Info Version", i32 3}
!61 = !{i32 1, !"wchar_size", i32 4}
!62 = !{i32 7, !"PIC Level", i32 2}
!63 = !{i32 7, !"PIE Level", i32 2}
!64 = !{i32 7, !"uwtable", i32 1}
!65 = !{i32 7, !"frame-pointer", i32 2}
!66 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!67 = distinct !DISubprogram(name: "sched_yield", scope: !27, file: !27, line: 19, type: !68, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!68 = !DISubroutineType(types: !69)
!69 = !{!70}
!70 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!71 = !{}
!72 = !DILocation(line: 21, column: 5, scope: !67)
!73 = distinct !DISubprogram(name: "writer", scope: !27, file: !27, line: 50, type: !74, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!74 = !DISubroutineType(types: !75)
!75 = !{!19, !19}
!76 = !DILocalVariable(name: "arg", arg: 1, scope: !73, file: !27, line: 50, type: !19)
!77 = !DILocation(line: 50, column: 14, scope: !73)
!78 = !DILocalVariable(name: "tid", scope: !73, file: !27, line: 52, type: !14)
!79 = !DILocation(line: 52, column: 16, scope: !73)
!80 = !DILocation(line: 52, column: 34, scope: !73)
!81 = !DILocation(line: 52, column: 22, scope: !73)
!82 = !DILocalVariable(name: "xbo", scope: !73, file: !27, line: 54, type: !83)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "xbo_t", file: !84, line: 49, baseType: !85)
!84 = !DIFile(filename: "utils/include/vsync/utils/xbo.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "01e2840bcd40115be17bb38f1f2baae6")
!85 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xbo_s", file: !84, line: 45, size: 128, elements: !86)
!86 = !{!87, !88, !89, !90}
!87 = !DIDerivedType(tag: DW_TAG_member, name: "min", scope: !85, file: !84, line: 46, baseType: !43, size: 32)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "max", scope: !85, file: !84, line: 46, baseType: !43, size: 32, offset: 32)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "factor", scope: !85, file: !84, line: 47, baseType: !43, size: 32, offset: 64)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !85, file: !84, line: 48, baseType: !43, size: 32, offset: 96)
!91 = !DILocation(line: 54, column: 11, scope: !73)
!92 = !DILocation(line: 55, column: 5, scope: !73)
!93 = !DILocalVariable(name: "i", scope: !94, file: !27, line: 57, type: !21)
!94 = distinct !DILexicalBlock(scope: !73, file: !27, line: 57, column: 5)
!95 = !DILocation(line: 57, column: 18, scope: !94)
!96 = !DILocation(line: 57, column: 10, scope: !94)
!97 = !DILocation(line: 57, column: 25, scope: !98)
!98 = distinct !DILexicalBlock(scope: !94, file: !27, line: 57, column: 5)
!99 = !DILocation(line: 57, column: 27, scope: !98)
!100 = !DILocation(line: 57, column: 5, scope: !94)
!101 = !DILocalVariable(name: "idx", scope: !102, file: !27, line: 58, type: !21)
!102 = distinct !DILexicalBlock(scope: !98, file: !27, line: 57, column: 42)
!103 = !DILocation(line: 58, column: 17, scope: !102)
!104 = !DILocation(line: 58, column: 23, scope: !102)
!105 = !DILocation(line: 58, column: 27, scope: !102)
!106 = !DILocation(line: 58, column: 38, scope: !102)
!107 = !DILocation(line: 58, column: 36, scope: !102)
!108 = !DILocation(line: 59, column: 23, scope: !102)
!109 = !DILocation(line: 59, column: 27, scope: !102)
!110 = !DILocation(line: 59, column: 42, scope: !102)
!111 = !DILocation(line: 59, column: 40, scope: !102)
!112 = !DILocation(line: 59, column: 44, scope: !102)
!113 = !DILocation(line: 59, column: 15, scope: !102)
!114 = !DILocation(line: 59, column: 9, scope: !102)
!115 = !DILocation(line: 59, column: 21, scope: !102)
!116 = !DILocation(line: 60, column: 9, scope: !102)
!117 = !DILocation(line: 60, column: 50, scope: !102)
!118 = !DILocation(line: 60, column: 44, scope: !102)
!119 = !DILocation(line: 60, column: 43, scope: !102)
!120 = !DILocation(line: 60, column: 16, scope: !102)
!121 = !DILocation(line: 60, column: 56, scope: !102)
!122 = !DILocation(line: 62, column: 13, scope: !123)
!123 = distinct !DILexicalBlock(scope: !102, file: !27, line: 60, column: 77)
!124 = distinct !{!124, !116, !125, !126}
!125 = !DILocation(line: 63, column: 9, scope: !102)
!126 = !{!"llvm.loop.mustprogress"}
!127 = !DILocation(line: 64, column: 9, scope: !102)
!128 = !DILocation(line: 65, column: 5, scope: !102)
!129 = !DILocation(line: 57, column: 38, scope: !98)
!130 = !DILocation(line: 57, column: 5, scope: !98)
!131 = distinct !{!131, !100, !132, !126}
!132 = !DILocation(line: 65, column: 5, scope: !94)
!133 = !DILocation(line: 66, column: 5, scope: !73)
!134 = distinct !DISubprogram(name: "xbo_init", scope: !84, file: !84, line: 65, type: !135, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!135 = !DISubroutineType(types: !136)
!136 = !{null, !137, !43, !43, !43}
!137 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !83, size: 64)
!138 = !DILocalVariable(name: "xbo", arg: 1, scope: !134, file: !84, line: 65, type: !137)
!139 = !DILocation(line: 65, column: 17, scope: !134)
!140 = !DILocalVariable(name: "min", arg: 2, scope: !134, file: !84, line: 65, type: !43)
!141 = !DILocation(line: 65, column: 32, scope: !134)
!142 = !DILocalVariable(name: "max", arg: 3, scope: !134, file: !84, line: 65, type: !43)
!143 = !DILocation(line: 65, column: 47, scope: !134)
!144 = !DILocalVariable(name: "factor", arg: 4, scope: !134, file: !84, line: 65, type: !43)
!145 = !DILocation(line: 65, column: 62, scope: !134)
!146 = !DILocation(line: 72, column: 1, scope: !134)
!147 = distinct !DISubprogram(name: "bounded_mpmc_enq", scope: !34, file: !34, line: 75, type: !148, scopeLine: 76, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!148 = !DISubroutineType(types: !149)
!149 = !{!150, !151, !19}
!150 = !DIDerivedType(tag: DW_TAG_typedef, name: "bounded_ret_t", file: !6, line: 13, baseType: !5)
!151 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!152 = !DILocalVariable(name: "q", arg: 1, scope: !147, file: !34, line: 75, type: !151)
!153 = !DILocation(line: 75, column: 34, scope: !147)
!154 = !DILocalVariable(name: "v", arg: 2, scope: !147, file: !34, line: 75, type: !19)
!155 = !DILocation(line: 75, column: 43, scope: !147)
!156 = !DILocalVariable(name: "curr", scope: !147, file: !34, line: 77, type: !43)
!157 = !DILocation(line: 77, column: 15, scope: !147)
!158 = !DILocalVariable(name: "next", scope: !147, file: !34, line: 77, type: !43)
!159 = !DILocation(line: 77, column: 21, scope: !147)
!160 = !DILocation(line: 80, column: 32, scope: !147)
!161 = !DILocation(line: 80, column: 35, scope: !147)
!162 = !DILocation(line: 80, column: 12, scope: !147)
!163 = !DILocation(line: 80, column: 10, scope: !147)
!164 = !DILocation(line: 81, column: 9, scope: !165)
!165 = distinct !DILexicalBlock(scope: !147, file: !34, line: 81, column: 9)
!166 = !DILocation(line: 81, column: 36, scope: !165)
!167 = !DILocation(line: 81, column: 39, scope: !165)
!168 = !DILocation(line: 81, column: 16, scope: !165)
!169 = !DILocation(line: 81, column: 14, scope: !165)
!170 = !DILocation(line: 81, column: 49, scope: !165)
!171 = !DILocation(line: 81, column: 52, scope: !165)
!172 = !DILocation(line: 81, column: 46, scope: !165)
!173 = !DILocation(line: 81, column: 9, scope: !147)
!174 = !DILocation(line: 82, column: 9, scope: !175)
!175 = distinct !DILexicalBlock(scope: !165, file: !34, line: 81, column: 58)
!176 = !DILocation(line: 84, column: 12, scope: !147)
!177 = !DILocation(line: 84, column: 17, scope: !147)
!178 = !DILocation(line: 84, column: 10, scope: !147)
!179 = !DILocation(line: 85, column: 32, scope: !180)
!180 = distinct !DILexicalBlock(scope: !147, file: !34, line: 85, column: 9)
!181 = !DILocation(line: 85, column: 35, scope: !180)
!182 = !DILocation(line: 85, column: 42, scope: !180)
!183 = !DILocation(line: 85, column: 48, scope: !180)
!184 = !DILocation(line: 85, column: 9, scope: !180)
!185 = !DILocation(line: 85, column: 57, scope: !180)
!186 = !DILocation(line: 85, column: 54, scope: !180)
!187 = !DILocation(line: 85, column: 9, scope: !147)
!188 = !DILocation(line: 86, column: 9, scope: !189)
!189 = distinct !DILexicalBlock(scope: !180, file: !34, line: 85, column: 63)
!190 = !DILocation(line: 89, column: 30, scope: !147)
!191 = !DILocation(line: 89, column: 5, scope: !147)
!192 = !DILocation(line: 89, column: 8, scope: !147)
!193 = !DILocation(line: 89, column: 12, scope: !147)
!194 = !DILocation(line: 89, column: 19, scope: !147)
!195 = !DILocation(line: 89, column: 22, scope: !147)
!196 = !DILocation(line: 89, column: 17, scope: !147)
!197 = !DILocation(line: 89, column: 28, scope: !147)
!198 = !DILocation(line: 92, column: 29, scope: !147)
!199 = !DILocation(line: 92, column: 32, scope: !147)
!200 = !DILocation(line: 92, column: 39, scope: !147)
!201 = !DILocation(line: 92, column: 5, scope: !147)
!202 = !DILocation(line: 93, column: 26, scope: !147)
!203 = !DILocation(line: 93, column: 29, scope: !147)
!204 = !DILocation(line: 93, column: 36, scope: !147)
!205 = !DILocation(line: 93, column: 5, scope: !147)
!206 = !DILocation(line: 95, column: 5, scope: !147)
!207 = !DILocation(line: 96, column: 1, scope: !147)
!208 = distinct !DISubprogram(name: "verification_ignore", scope: !209, file: !209, line: 110, type: !210, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!209 = !DIFile(filename: "include/vsync/common/verify.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "2fd10960d0c2c64c7ccf19294b1806ff")
!210 = !DISubroutineType(types: !211)
!211 = !{null}
!212 = !DILocation(line: 112, column: 5, scope: !208)
!213 = !DILocation(line: 113, column: 1, scope: !208)
!214 = distinct !DISubprogram(name: "xbo_reset", scope: !84, file: !84, line: 106, type: !215, scopeLine: 107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!215 = !DISubroutineType(types: !216)
!216 = !{null, !137}
!217 = !DILocalVariable(name: "xbo", arg: 1, scope: !214, file: !84, line: 106, type: !137)
!218 = !DILocation(line: 106, column: 18, scope: !214)
!219 = !DILocation(line: 111, column: 1, scope: !214)
!220 = distinct !DISubprogram(name: "reader", scope: !27, file: !27, line: 70, type: !74, scopeLine: 71, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!221 = !DILocalVariable(name: "arg", arg: 1, scope: !220, file: !27, line: 70, type: !19)
!222 = !DILocation(line: 70, column: 14, scope: !220)
!223 = !DILocalVariable(name: "tid", scope: !220, file: !27, line: 72, type: !14)
!224 = !DILocation(line: 72, column: 16, scope: !220)
!225 = !DILocation(line: 72, column: 34, scope: !220)
!226 = !DILocation(line: 72, column: 22, scope: !220)
!227 = !DILocation(line: 73, column: 5, scope: !220)
!228 = !DILocation(line: 73, column: 5, scope: !229)
!229 = distinct !DILexicalBlock(scope: !220, file: !27, line: 73, column: 5)
!230 = !DILocation(line: 73, column: 5, scope: !231)
!231 = distinct !DILexicalBlock(scope: !229, file: !27, line: 73, column: 5)
!232 = !DILocation(line: 73, column: 5, scope: !233)
!233 = distinct !DILexicalBlock(scope: !231, file: !27, line: 73, column: 5)
!234 = !DILocalVariable(name: "xbo", scope: !220, file: !27, line: 75, type: !83)
!235 = !DILocation(line: 75, column: 11, scope: !220)
!236 = !DILocation(line: 76, column: 5, scope: !220)
!237 = !DILocation(line: 78, column: 5, scope: !220)
!238 = !DILocalVariable(name: "r", scope: !239, file: !27, line: 79, type: !19)
!239 = distinct !DILexicalBlock(scope: !220, file: !27, line: 78, column: 8)
!240 = !DILocation(line: 79, column: 15, scope: !239)
!241 = !DILocation(line: 80, column: 13, scope: !242)
!242 = distinct !DILexicalBlock(scope: !239, file: !27, line: 80, column: 13)
!243 = !DILocation(line: 80, column: 44, scope: !242)
!244 = !DILocation(line: 80, column: 13, scope: !239)
!245 = !DILocalVariable(name: "idx", scope: !246, file: !27, line: 81, type: !43)
!246 = distinct !DILexicalBlock(scope: !242, file: !27, line: 80, column: 65)
!247 = !DILocation(line: 81, column: 23, scope: !246)
!248 = !DILocation(line: 81, column: 29, scope: !246)
!249 = !DILocation(line: 82, column: 13, scope: !250)
!250 = distinct !DILexicalBlock(scope: !251, file: !27, line: 82, column: 13)
!251 = distinct !DILexicalBlock(scope: !246, file: !27, line: 82, column: 13)
!252 = !DILocation(line: 82, column: 13, scope: !251)
!253 = !DILocation(line: 83, column: 38, scope: !246)
!254 = !DILocation(line: 83, column: 27, scope: !246)
!255 = !DILocation(line: 83, column: 26, scope: !246)
!256 = !DILocation(line: 83, column: 19, scope: !246)
!257 = !DILocation(line: 83, column: 13, scope: !246)
!258 = !DILocation(line: 83, column: 24, scope: !246)
!259 = !DILocation(line: 84, column: 13, scope: !260)
!260 = distinct !DILexicalBlock(scope: !261, file: !27, line: 84, column: 13)
!261 = distinct !DILexicalBlock(scope: !246, file: !27, line: 84, column: 13)
!262 = !DILocation(line: 84, column: 13, scope: !261)
!263 = !DILocation(line: 85, column: 9, scope: !246)
!264 = !DILocation(line: 87, column: 13, scope: !265)
!265 = distinct !DILexicalBlock(scope: !242, file: !27, line: 85, column: 16)
!266 = !DILocation(line: 89, column: 9, scope: !239)
!267 = !DILocation(line: 90, column: 5, scope: !239)
!268 = !DILocation(line: 90, column: 14, scope: !220)
!269 = !DILocation(line: 90, column: 42, scope: !220)
!270 = distinct !{!270, !237, !271, !126}
!271 = !DILocation(line: 90, column: 57, scope: !220)
!272 = !DILocation(line: 92, column: 5, scope: !220)
!273 = distinct !DISubprogram(name: "bounded_mpmc_deq", scope: !34, file: !34, line: 111, type: !274, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!274 = !DISubroutineType(types: !275)
!275 = !{!150, !151, !52}
!276 = !DILocalVariable(name: "q", arg: 1, scope: !273, file: !34, line: 111, type: !151)
!277 = !DILocation(line: 111, column: 34, scope: !273)
!278 = !DILocalVariable(name: "v", arg: 2, scope: !273, file: !34, line: 111, type: !52)
!279 = !DILocation(line: 111, column: 44, scope: !273)
!280 = !DILocalVariable(name: "curr", scope: !273, file: !34, line: 113, type: !43)
!281 = !DILocation(line: 113, column: 15, scope: !273)
!282 = !DILocalVariable(name: "next", scope: !273, file: !34, line: 113, type: !43)
!283 = !DILocation(line: 113, column: 21, scope: !273)
!284 = !DILocation(line: 116, column: 32, scope: !273)
!285 = !DILocation(line: 116, column: 35, scope: !273)
!286 = !DILocation(line: 116, column: 12, scope: !273)
!287 = !DILocation(line: 116, column: 10, scope: !273)
!288 = !DILocation(line: 117, column: 12, scope: !273)
!289 = !DILocation(line: 117, column: 17, scope: !273)
!290 = !DILocation(line: 117, column: 10, scope: !273)
!291 = !DILocation(line: 118, column: 9, scope: !292)
!292 = distinct !DILexicalBlock(scope: !273, file: !34, line: 118, column: 9)
!293 = !DILocation(line: 118, column: 37, scope: !292)
!294 = !DILocation(line: 118, column: 40, scope: !292)
!295 = !DILocation(line: 118, column: 17, scope: !292)
!296 = !DILocation(line: 118, column: 14, scope: !292)
!297 = !DILocation(line: 118, column: 9, scope: !273)
!298 = !DILocation(line: 119, column: 9, scope: !299)
!299 = distinct !DILexicalBlock(scope: !292, file: !34, line: 118, column: 48)
!300 = !DILocation(line: 121, column: 32, scope: !301)
!301 = distinct !DILexicalBlock(scope: !273, file: !34, line: 121, column: 9)
!302 = !DILocation(line: 121, column: 35, scope: !301)
!303 = !DILocation(line: 121, column: 42, scope: !301)
!304 = !DILocation(line: 121, column: 48, scope: !301)
!305 = !DILocation(line: 121, column: 9, scope: !301)
!306 = !DILocation(line: 121, column: 57, scope: !301)
!307 = !DILocation(line: 121, column: 54, scope: !301)
!308 = !DILocation(line: 121, column: 9, scope: !273)
!309 = !DILocation(line: 122, column: 9, scope: !310)
!310 = distinct !DILexicalBlock(scope: !301, file: !34, line: 121, column: 63)
!311 = !DILocation(line: 125, column: 10, scope: !273)
!312 = !DILocation(line: 125, column: 13, scope: !273)
!313 = !DILocation(line: 125, column: 17, scope: !273)
!314 = !DILocation(line: 125, column: 24, scope: !273)
!315 = !DILocation(line: 125, column: 27, scope: !273)
!316 = !DILocation(line: 125, column: 22, scope: !273)
!317 = !DILocation(line: 125, column: 6, scope: !273)
!318 = !DILocation(line: 125, column: 8, scope: !273)
!319 = !DILocation(line: 128, column: 29, scope: !273)
!320 = !DILocation(line: 128, column: 32, scope: !273)
!321 = !DILocation(line: 128, column: 39, scope: !273)
!322 = !DILocation(line: 128, column: 5, scope: !273)
!323 = !DILocation(line: 129, column: 26, scope: !273)
!324 = !DILocation(line: 129, column: 29, scope: !273)
!325 = !DILocation(line: 129, column: 36, scope: !273)
!326 = !DILocation(line: 129, column: 5, scope: !273)
!327 = !DILocation(line: 131, column: 5, scope: !273)
!328 = !DILocation(line: 132, column: 1, scope: !273)
!329 = distinct !DISubprogram(name: "vatomic32_get_inc_rlx", scope: !330, file: !330, line: 2516, type: !331, scopeLine: 2517, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!330 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!331 = !DISubroutineType(types: !332)
!332 = !{!43, !333}
!333 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!334 = !DILocalVariable(name: "a", arg: 1, scope: !329, file: !330, line: 2516, type: !333)
!335 = !DILocation(line: 2516, column: 36, scope: !329)
!336 = !DILocation(line: 2518, column: 34, scope: !329)
!337 = !DILocation(line: 2518, column: 12, scope: !329)
!338 = !DILocation(line: 2518, column: 5, scope: !329)
!339 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !340, file: !340, line: 101, type: !341, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!340 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!341 = !DISubroutineType(types: !342)
!342 = !{!43, !343}
!343 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !344, size: 64)
!344 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !38)
!345 = !DILocalVariable(name: "a", arg: 1, scope: !339, file: !340, line: 101, type: !343)
!346 = !DILocation(line: 101, column: 39, scope: !339)
!347 = !DILocalVariable(name: "val", scope: !339, file: !340, line: 103, type: !43)
!348 = !DILocation(line: 103, column: 15, scope: !339)
!349 = !DILocation(line: 106, column: 32, scope: !339)
!350 = !DILocation(line: 106, column: 35, scope: !339)
!351 = !DILocation(line: 104, column: 5, scope: !339)
!352 = !{i64 603172}
!353 = !DILocation(line: 108, column: 12, scope: !339)
!354 = !DILocation(line: 108, column: 5, scope: !339)
!355 = distinct !DISubprogram(name: "main", scope: !27, file: !27, line: 96, type: !68, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !71)
!356 = !DILocation(line: 98, column: 5, scope: !355)
!357 = !DILocalVariable(name: "t", scope: !355, file: !27, line: 100, type: !358)
!358 = !DICompositeType(tag: DW_TAG_array_type, baseType: !359, size: 256, elements: !29)
!359 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !360, line: 27, baseType: !18)
!360 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!361 = !DILocation(line: 100, column: 15, scope: !355)
!362 = !DILocalVariable(name: "i", scope: !363, file: !27, line: 102, type: !14)
!363 = distinct !DILexicalBlock(scope: !355, file: !27, line: 102, column: 5)
!364 = !DILocation(line: 102, column: 21, scope: !363)
!365 = !DILocation(line: 102, column: 10, scope: !363)
!366 = !DILocation(line: 102, column: 28, scope: !367)
!367 = distinct !DILexicalBlock(scope: !363, file: !27, line: 102, column: 5)
!368 = !DILocation(line: 102, column: 30, scope: !367)
!369 = !DILocation(line: 102, column: 5, scope: !363)
!370 = !DILocation(line: 103, column: 33, scope: !371)
!371 = distinct !DILexicalBlock(scope: !367, file: !27, line: 102, column: 47)
!372 = !DILocation(line: 103, column: 31, scope: !371)
!373 = !DILocation(line: 103, column: 56, scope: !371)
!374 = !DILocation(line: 103, column: 48, scope: !371)
!375 = !DILocation(line: 103, column: 15, scope: !371)
!376 = !DILocation(line: 104, column: 5, scope: !371)
!377 = !DILocation(line: 102, column: 43, scope: !367)
!378 = !DILocation(line: 102, column: 5, scope: !367)
!379 = distinct !{!379, !369, !380, !126}
!380 = !DILocation(line: 104, column: 5, scope: !363)
!381 = !DILocalVariable(name: "i", scope: !382, file: !27, line: 105, type: !14)
!382 = distinct !DILexicalBlock(scope: !355, file: !27, line: 105, column: 5)
!383 = !DILocation(line: 105, column: 21, scope: !382)
!384 = !DILocation(line: 105, column: 10, scope: !382)
!385 = !DILocation(line: 105, column: 28, scope: !386)
!386 = distinct !DILexicalBlock(scope: !382, file: !27, line: 105, column: 5)
!387 = !DILocation(line: 105, column: 30, scope: !386)
!388 = !DILocation(line: 105, column: 5, scope: !382)
!389 = !DILocation(line: 106, column: 44, scope: !390)
!390 = distinct !DILexicalBlock(scope: !386, file: !27, line: 105, column: 47)
!391 = !DILocation(line: 106, column: 42, scope: !390)
!392 = !DILocation(line: 106, column: 31, scope: !390)
!393 = !DILocation(line: 106, column: 67, scope: !390)
!394 = !DILocation(line: 106, column: 59, scope: !390)
!395 = !DILocation(line: 106, column: 15, scope: !390)
!396 = !DILocation(line: 107, column: 5, scope: !390)
!397 = !DILocation(line: 105, column: 43, scope: !386)
!398 = !DILocation(line: 105, column: 5, scope: !386)
!399 = distinct !{!399, !388, !400, !126}
!400 = !DILocation(line: 107, column: 5, scope: !382)
!401 = !DILocalVariable(name: "i", scope: !402, file: !27, line: 109, type: !14)
!402 = distinct !DILexicalBlock(scope: !355, file: !27, line: 109, column: 5)
!403 = !DILocation(line: 109, column: 21, scope: !402)
!404 = !DILocation(line: 109, column: 10, scope: !402)
!405 = !DILocation(line: 109, column: 28, scope: !406)
!406 = distinct !DILexicalBlock(scope: !402, file: !27, line: 109, column: 5)
!407 = !DILocation(line: 109, column: 30, scope: !406)
!408 = !DILocation(line: 109, column: 5, scope: !402)
!409 = !DILocation(line: 110, column: 30, scope: !410)
!410 = distinct !DILexicalBlock(scope: !406, file: !27, line: 109, column: 47)
!411 = !DILocation(line: 110, column: 28, scope: !410)
!412 = !DILocation(line: 110, column: 15, scope: !410)
!413 = !DILocation(line: 111, column: 5, scope: !410)
!414 = !DILocation(line: 109, column: 43, scope: !406)
!415 = !DILocation(line: 109, column: 5, scope: !406)
!416 = distinct !{!416, !408, !417, !126}
!417 = !DILocation(line: 111, column: 5, scope: !402)
!418 = !DILocalVariable(name: "found", scope: !355, file: !27, line: 114, type: !70)
!419 = !DILocation(line: 114, column: 9, scope: !355)
!420 = !DILocalVariable(name: "i", scope: !421, file: !27, line: 115, type: !70)
!421 = distinct !DILexicalBlock(scope: !355, file: !27, line: 115, column: 5)
!422 = !DILocation(line: 115, column: 14, scope: !421)
!423 = !DILocation(line: 115, column: 10, scope: !421)
!424 = !DILocation(line: 115, column: 21, scope: !425)
!425 = distinct !DILexicalBlock(scope: !421, file: !27, line: 115, column: 5)
!426 = !DILocation(line: 115, column: 23, scope: !425)
!427 = !DILocation(line: 115, column: 5, scope: !421)
!428 = !DILocalVariable(name: "j", scope: !429, file: !27, line: 116, type: !70)
!429 = distinct !DILexicalBlock(scope: !430, file: !27, line: 116, column: 9)
!430 = distinct !DILexicalBlock(scope: !425, file: !27, line: 115, column: 44)
!431 = !DILocation(line: 116, column: 18, scope: !429)
!432 = !DILocation(line: 116, column: 14, scope: !429)
!433 = !DILocation(line: 116, column: 25, scope: !434)
!434 = distinct !DILexicalBlock(scope: !429, file: !27, line: 116, column: 9)
!435 = !DILocation(line: 116, column: 27, scope: !434)
!436 = !DILocation(line: 116, column: 9, scope: !429)
!437 = !DILocation(line: 117, column: 23, scope: !438)
!438 = distinct !DILexicalBlock(scope: !439, file: !27, line: 117, column: 17)
!439 = distinct !DILexicalBlock(scope: !434, file: !27, line: 116, column: 48)
!440 = !DILocation(line: 117, column: 17, scope: !438)
!441 = !DILocation(line: 117, column: 35, scope: !438)
!442 = !DILocation(line: 117, column: 29, scope: !438)
!443 = !DILocation(line: 117, column: 26, scope: !438)
!444 = !DILocation(line: 117, column: 17, scope: !439)
!445 = !DILocation(line: 118, column: 23, scope: !446)
!446 = distinct !DILexicalBlock(scope: !438, file: !27, line: 117, column: 39)
!447 = !DILocation(line: 118, column: 17, scope: !446)
!448 = !DILocation(line: 118, column: 26, scope: !446)
!449 = !DILocation(line: 119, column: 22, scope: !446)
!450 = !DILocation(line: 120, column: 17, scope: !446)
!451 = !DILocation(line: 122, column: 9, scope: !439)
!452 = !DILocation(line: 116, column: 44, scope: !434)
!453 = !DILocation(line: 116, column: 9, scope: !434)
!454 = distinct !{!454, !436, !455, !126}
!455 = !DILocation(line: 122, column: 9, scope: !429)
!456 = !DILocation(line: 123, column: 5, scope: !430)
!457 = !DILocation(line: 115, column: 40, scope: !425)
!458 = !DILocation(line: 115, column: 5, scope: !425)
!459 = distinct !{!459, !427, !460, !126}
!460 = !DILocation(line: 123, column: 5, scope: !421)
!461 = !DILocation(line: 124, column: 5, scope: !462)
!462 = distinct !DILexicalBlock(scope: !463, file: !27, line: 124, column: 5)
!463 = distinct !DILexicalBlock(scope: !355, file: !27, line: 124, column: 5)
!464 = !DILocation(line: 124, column: 5, scope: !463)
!465 = !DILocalVariable(name: "x", scope: !355, file: !27, line: 125, type: !43)
!466 = !DILocation(line: 125, column: 15, scope: !355)
!467 = !DILocation(line: 125, column: 19, scope: !355)
!468 = !DILocation(line: 126, column: 5, scope: !469)
!469 = distinct !DILexicalBlock(scope: !470, file: !27, line: 126, column: 5)
!470 = distinct !DILexicalBlock(scope: !355, file: !27, line: 126, column: 5)
!471 = !DILocation(line: 126, column: 5, scope: !470)
!472 = !DILocalVariable(name: "r", scope: !355, file: !27, line: 128, type: !19)
!473 = !DILocation(line: 128, column: 11, scope: !355)
!474 = !DILocalVariable(name: "ret", scope: !355, file: !27, line: 129, type: !150)
!475 = !DILocation(line: 129, column: 19, scope: !355)
!476 = !DILocation(line: 129, column: 25, scope: !355)
!477 = !DILocation(line: 130, column: 5, scope: !478)
!478 = distinct !DILexicalBlock(scope: !479, file: !27, line: 130, column: 5)
!479 = distinct !DILexicalBlock(scope: !355, file: !27, line: 130, column: 5)
!480 = !DILocation(line: 130, column: 5, scope: !479)
!481 = !DILocation(line: 132, column: 5, scope: !355)
!482 = !DILocation(line: 132, column: 5, scope: !483)
!483 = distinct !DILexicalBlock(scope: !355, file: !27, line: 132, column: 5)
!484 = !DILocation(line: 132, column: 5, scope: !485)
!485 = distinct !DILexicalBlock(scope: !483, file: !27, line: 132, column: 5)
!486 = !DILocation(line: 132, column: 5, scope: !487)
!487 = distinct !DILexicalBlock(scope: !485, file: !27, line: 132, column: 5)
!488 = !DILocation(line: 132, column: 5, scope: !489)
!489 = distinct !DILexicalBlock(scope: !487, file: !27, line: 132, column: 5)
!490 = !DILocation(line: 132, column: 5, scope: !491)
!491 = distinct !DILexicalBlock(scope: !489, file: !27, line: 132, column: 5)
!492 = !DILocation(line: 134, column: 5, scope: !355)
!493 = distinct !DISubprogram(name: "bounded_mpmc_init", scope: !34, file: !34, line: 50, type: !494, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!494 = !DISubroutineType(types: !495)
!495 = !{null, !151, !52, !43}
!496 = !DILocalVariable(name: "q", arg: 1, scope: !493, file: !34, line: 50, type: !151)
!497 = !DILocation(line: 50, column: 35, scope: !493)
!498 = !DILocalVariable(name: "b", arg: 2, scope: !493, file: !34, line: 50, type: !52)
!499 = !DILocation(line: 50, column: 45, scope: !493)
!500 = !DILocalVariable(name: "s", arg: 3, scope: !493, file: !34, line: 50, type: !43)
!501 = !DILocation(line: 50, column: 58, scope: !493)
!502 = !DILocation(line: 52, column: 5, scope: !503)
!503 = distinct !DILexicalBlock(scope: !504, file: !34, line: 52, column: 5)
!504 = distinct !DILexicalBlock(scope: !493, file: !34, line: 52, column: 5)
!505 = !DILocation(line: 52, column: 5, scope: !504)
!506 = !DILocation(line: 53, column: 5, scope: !507)
!507 = distinct !DILexicalBlock(scope: !508, file: !34, line: 53, column: 5)
!508 = distinct !DILexicalBlock(scope: !493, file: !34, line: 53, column: 5)
!509 = !DILocation(line: 53, column: 5, scope: !508)
!510 = !DILocation(line: 55, column: 15, scope: !493)
!511 = !DILocation(line: 55, column: 5, scope: !493)
!512 = !DILocation(line: 55, column: 8, scope: !493)
!513 = !DILocation(line: 55, column: 13, scope: !493)
!514 = !DILocation(line: 56, column: 15, scope: !493)
!515 = !DILocation(line: 56, column: 5, scope: !493)
!516 = !DILocation(line: 56, column: 8, scope: !493)
!517 = !DILocation(line: 56, column: 13, scope: !493)
!518 = !DILocation(line: 57, column: 21, scope: !493)
!519 = !DILocation(line: 57, column: 24, scope: !493)
!520 = !DILocation(line: 57, column: 5, scope: !493)
!521 = !DILocation(line: 58, column: 21, scope: !493)
!522 = !DILocation(line: 58, column: 24, scope: !493)
!523 = !DILocation(line: 58, column: 5, scope: !493)
!524 = !DILocation(line: 59, column: 21, scope: !493)
!525 = !DILocation(line: 59, column: 24, scope: !493)
!526 = !DILocation(line: 59, column: 5, scope: !493)
!527 = !DILocation(line: 60, column: 21, scope: !493)
!528 = !DILocation(line: 60, column: 24, scope: !493)
!529 = !DILocation(line: 60, column: 5, scope: !493)
!530 = !DILocation(line: 61, column: 1, scope: !493)
!531 = distinct !DISubprogram(name: "vatomic32_read", scope: !340, file: !340, line: 69, type: !341, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!532 = !DILocalVariable(name: "a", arg: 1, scope: !531, file: !340, line: 69, type: !343)
!533 = !DILocation(line: 69, column: 35, scope: !531)
!534 = !DILocalVariable(name: "val", scope: !531, file: !340, line: 71, type: !43)
!535 = !DILocation(line: 71, column: 15, scope: !531)
!536 = !DILocation(line: 74, column: 32, scope: !531)
!537 = !DILocation(line: 74, column: 35, scope: !531)
!538 = !DILocation(line: 72, column: 5, scope: !531)
!539 = !{i64 602168}
!540 = !DILocation(line: 76, column: 12, scope: !531)
!541 = !DILocation(line: 76, column: 5, scope: !531)
!542 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !340, file: !340, line: 85, type: !341, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!543 = !DILocalVariable(name: "a", arg: 1, scope: !542, file: !340, line: 85, type: !343)
!544 = !DILocation(line: 85, column: 39, scope: !542)
!545 = !DILocalVariable(name: "val", scope: !542, file: !340, line: 87, type: !43)
!546 = !DILocation(line: 87, column: 15, scope: !542)
!547 = !DILocation(line: 90, column: 32, scope: !542)
!548 = !DILocation(line: 90, column: 35, scope: !542)
!549 = !DILocation(line: 88, column: 5, scope: !542)
!550 = !{i64 602670}
!551 = !DILocation(line: 92, column: 12, scope: !542)
!552 = !DILocation(line: 92, column: 5, scope: !542)
!553 = distinct !DISubprogram(name: "vatomic32_cmpxchg_rel", scope: !554, file: !554, line: 336, type: !555, scopeLine: 337, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!554 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!555 = !DISubroutineType(types: !556)
!556 = !{!43, !333, !43, !43}
!557 = !DILocalVariable(name: "a", arg: 1, scope: !553, file: !554, line: 336, type: !333)
!558 = !DILocation(line: 336, column: 36, scope: !553)
!559 = !DILocalVariable(name: "e", arg: 2, scope: !553, file: !554, line: 336, type: !43)
!560 = !DILocation(line: 336, column: 49, scope: !553)
!561 = !DILocalVariable(name: "v", arg: 3, scope: !553, file: !554, line: 336, type: !43)
!562 = !DILocation(line: 336, column: 62, scope: !553)
!563 = !DILocalVariable(name: "oldv", scope: !553, file: !554, line: 338, type: !43)
!564 = !DILocation(line: 338, column: 15, scope: !553)
!565 = !DILocalVariable(name: "tmp", scope: !553, file: !554, line: 339, type: !43)
!566 = !DILocation(line: 339, column: 15, scope: !553)
!567 = !DILocation(line: 350, column: 22, scope: !553)
!568 = !DILocation(line: 350, column: 36, scope: !553)
!569 = !DILocation(line: 350, column: 48, scope: !553)
!570 = !DILocation(line: 350, column: 51, scope: !553)
!571 = !DILocation(line: 340, column: 5, scope: !553)
!572 = !{i64 668856, i64 668890, i64 668905, i64 668937, i64 668971, i64 668991, i64 669034, i64 669063}
!573 = !DILocation(line: 352, column: 12, scope: !553)
!574 = !DILocation(line: 352, column: 5, scope: !553)
!575 = distinct !DISubprogram(name: "vatomic32_await_eq_acq", scope: !340, file: !340, line: 604, type: !576, scopeLine: 605, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!576 = !DISubroutineType(types: !577)
!577 = !{!43, !343, !43}
!578 = !DILocalVariable(name: "a", arg: 1, scope: !575, file: !340, line: 604, type: !343)
!579 = !DILocation(line: 604, column: 43, scope: !575)
!580 = !DILocalVariable(name: "v", arg: 2, scope: !575, file: !340, line: 604, type: !43)
!581 = !DILocation(line: 604, column: 56, scope: !575)
!582 = !DILocalVariable(name: "val", scope: !575, file: !340, line: 606, type: !43)
!583 = !DILocation(line: 606, column: 15, scope: !575)
!584 = !DILocation(line: 613, column: 21, scope: !575)
!585 = !DILocation(line: 613, column: 33, scope: !575)
!586 = !DILocation(line: 613, column: 36, scope: !575)
!587 = !DILocation(line: 607, column: 5, scope: !575)
!588 = !{i64 617708, i64 617724, i64 617755, i64 617788}
!589 = !DILocation(line: 615, column: 12, scope: !575)
!590 = !DILocation(line: 615, column: 5, scope: !575)
!591 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !340, file: !340, line: 227, type: !592, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!592 = !DISubroutineType(types: !593)
!593 = !{null, !333, !43}
!594 = !DILocalVariable(name: "a", arg: 1, scope: !591, file: !340, line: 227, type: !333)
!595 = !DILocation(line: 227, column: 34, scope: !591)
!596 = !DILocalVariable(name: "v", arg: 2, scope: !591, file: !340, line: 227, type: !43)
!597 = !DILocation(line: 227, column: 47, scope: !591)
!598 = !DILocation(line: 231, column: 32, scope: !591)
!599 = !DILocation(line: 231, column: 44, scope: !591)
!600 = !DILocation(line: 231, column: 47, scope: !591)
!601 = !DILocation(line: 229, column: 5, scope: !591)
!602 = !{i64 607086}
!603 = !DILocation(line: 233, column: 1, scope: !591)
!604 = distinct !DISubprogram(name: "vatomic32_await_eq_rlx", scope: !340, file: !340, line: 868, type: !576, scopeLine: 869, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!605 = !DILocalVariable(name: "a", arg: 1, scope: !604, file: !340, line: 868, type: !343)
!606 = !DILocation(line: 868, column: 43, scope: !604)
!607 = !DILocalVariable(name: "v", arg: 2, scope: !604, file: !340, line: 868, type: !43)
!608 = !DILocation(line: 868, column: 56, scope: !604)
!609 = !DILocalVariable(name: "val", scope: !604, file: !340, line: 870, type: !43)
!610 = !DILocation(line: 870, column: 15, scope: !604)
!611 = !DILocation(line: 877, column: 21, scope: !604)
!612 = !DILocation(line: 877, column: 33, scope: !604)
!613 = !DILocation(line: 877, column: 36, scope: !604)
!614 = !DILocation(line: 871, column: 5, scope: !604)
!615 = !{i64 624625, i64 624641, i64 624671, i64 624704}
!616 = !DILocation(line: 879, column: 12, scope: !604)
!617 = !DILocation(line: 879, column: 5, scope: !604)
!618 = distinct !DISubprogram(name: "vatomic32_get_add_rlx", scope: !554, file: !554, line: 1388, type: !619, scopeLine: 1389, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!619 = !DISubroutineType(types: !620)
!620 = !{!43, !333, !43}
!621 = !DILocalVariable(name: "a", arg: 1, scope: !618, file: !554, line: 1388, type: !333)
!622 = !DILocation(line: 1388, column: 36, scope: !618)
!623 = !DILocalVariable(name: "v", arg: 2, scope: !618, file: !554, line: 1388, type: !43)
!624 = !DILocation(line: 1388, column: 49, scope: !618)
!625 = !DILocalVariable(name: "oldv", scope: !618, file: !554, line: 1390, type: !43)
!626 = !DILocation(line: 1390, column: 15, scope: !618)
!627 = !DILocalVariable(name: "tmp", scope: !618, file: !554, line: 1391, type: !43)
!628 = !DILocation(line: 1391, column: 15, scope: !618)
!629 = !DILocalVariable(name: "newv", scope: !618, file: !554, line: 1392, type: !43)
!630 = !DILocation(line: 1392, column: 15, scope: !618)
!631 = !DILocation(line: 1393, column: 5, scope: !618)
!632 = !DILocation(line: 1401, column: 19, scope: !618)
!633 = !DILocation(line: 1401, column: 22, scope: !618)
!634 = !{i64 700264, i64 700298, i64 700313, i64 700345, i64 700387, i64 700428}
!635 = !DILocation(line: 1404, column: 12, scope: !618)
!636 = !DILocation(line: 1404, column: 5, scope: !618)
!637 = distinct !DISubprogram(name: "vatomic32_init", scope: !330, file: !330, line: 4189, type: !592, scopeLine: 4190, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!638 = !DILocalVariable(name: "a", arg: 1, scope: !637, file: !330, line: 4189, type: !333)
!639 = !DILocation(line: 4189, column: 29, scope: !637)
!640 = !DILocalVariable(name: "v", arg: 2, scope: !637, file: !330, line: 4189, type: !43)
!641 = !DILocation(line: 4189, column: 42, scope: !637)
!642 = !DILocation(line: 4191, column: 21, scope: !637)
!643 = !DILocation(line: 4191, column: 24, scope: !637)
!644 = !DILocation(line: 4191, column: 5, scope: !637)
!645 = !DILocation(line: 4192, column: 1, scope: !637)
!646 = distinct !DISubprogram(name: "vatomic32_write", scope: !340, file: !340, line: 213, type: !592, scopeLine: 214, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !71)
!647 = !DILocalVariable(name: "a", arg: 1, scope: !646, file: !340, line: 213, type: !333)
!648 = !DILocation(line: 213, column: 30, scope: !646)
!649 = !DILocalVariable(name: "v", arg: 2, scope: !646, file: !340, line: 213, type: !43)
!650 = !DILocation(line: 213, column: 43, scope: !646)
!651 = !DILocation(line: 217, column: 32, scope: !646)
!652 = !DILocation(line: 217, column: 44, scope: !646)
!653 = !DILocation(line: 217, column: 47, scope: !646)
!654 = !DILocation(line: 215, column: 5, scope: !646)
!655 = !{i64 606616}
!656 = !DILocation(line: 219, column: 1, scope: !646)
