; ModuleID = '/home/stefano/huawei/libvsync/datastruct/queue/bounded/test/bounded_mpmc_check_full.c'
source_filename = "/home/stefano/huawei/libvsync/datastruct/queue/bounded/test/bounded_mpmc_check_full.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bounded_mpmc_s = type { %struct.vatomic32_s, %struct.vatomic32_s, %struct.vatomic32_s, %struct.vatomic32_s, i8**, i32 }
%struct.vatomic32_s = type { i32 }
%struct.xbo_s = type { i32, i32, i32, i32 }
%struct.run_info_t = type { i64, i64, i8, i8* (i8*)* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_val = dso_local global [4 x i64] zeroinitializer, align 16, !dbg !0
@g_queue = dso_local global %struct.bounded_mpmc_s zeroinitializer, align 8, !dbg !48
@g_buf = dso_local global [4 x i8*] zeroinitializer, align 16, !dbg !42
@.str = private unnamed_addr constant [24 x i8] c"ret == QUEUE_BOUNDED_OK\00", align 1
@.str.1 = private unnamed_addr constant [86 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/bounded/test/bounded_mpmc_check_full.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"(dequeued % 10U) == 1\00", align 1
@.str.3 = private unnamed_addr constant [26 x i8] c"dequeued <= (2 * 10U + 1)\00", align 1
@.str.4 = private unnamed_addr constant [26 x i8] c"ret == QUEUE_BOUNDED_FULL\00", align 1
@.str.5 = private unnamed_addr constant [15 x i8] c"buffer is NULL\00", align 1
@.str.6 = private unnamed_addr constant [22 x i8] c"b && \22buffer is NULL\22\00", align 1
@.str.7 = private unnamed_addr constant [90 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/bounded/include/vsync/queue/bounded_mpmc.h\00", align 1
@__PRETTY_FUNCTION__.bounded_mpmc_init = private unnamed_addr constant [61 x i8] c"void bounded_mpmc_init(bounded_mpmc_t *, void **, vuint32_t)\00", align 1
@.str.8 = private unnamed_addr constant [19 x i8] c"buffer with 0 size\00", align 1
@.str.9 = private unnamed_addr constant [31 x i8] c"s != 0 && \22buffer with 0 size\22\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @sched_yield() #0 !dbg !80 {
  ret i32 0, !dbg !85
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @writer(i8* noundef %0) #0 !dbg !86 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca %struct.xbo_s, align 4
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !87, metadata !DIExpression()), !dbg !88
  call void @llvm.dbg.declare(metadata i64* %3, metadata !89, metadata !DIExpression()), !dbg !90
  %7 = load i8*, i8** %2, align 8, !dbg !91
  %8 = ptrtoint i8* %7 to i64, !dbg !92
  store i64 %8, i64* %3, align 8, !dbg !90
  call void @llvm.dbg.declare(metadata %struct.xbo_s* %4, metadata !93, metadata !DIExpression()), !dbg !102
  call void @xbo_init(%struct.xbo_s* noundef %4, i32 noundef 0, i32 noundef 100, i32 noundef 2), !dbg !103
  call void @llvm.dbg.declare(metadata i64* %5, metadata !104, metadata !DIExpression()), !dbg !106
  store i64 0, i64* %5, align 8, !dbg !106
  br label %9, !dbg !107

9:                                                ; preds = %32, %1
  %10 = load i64, i64* %5, align 8, !dbg !108
  %11 = icmp ult i64 %10, 2, !dbg !110
  br i1 %11, label %12, label %35, !dbg !111

12:                                               ; preds = %9
  call void @llvm.dbg.declare(metadata i64* %6, metadata !112, metadata !DIExpression()), !dbg !114
  %13 = load i64, i64* %3, align 8, !dbg !115
  %14 = mul i64 %13, 2, !dbg !116
  %15 = load i64, i64* %5, align 8, !dbg !117
  %16 = add i64 %14, %15, !dbg !118
  store i64 %16, i64* %6, align 8, !dbg !114
  %17 = load i64, i64* %3, align 8, !dbg !119
  %18 = mul i64 %17, 10, !dbg !120
  %19 = load i64, i64* %5, align 8, !dbg !121
  %20 = add i64 %18, %19, !dbg !122
  %21 = add i64 %20, 1, !dbg !123
  %22 = load i64, i64* %6, align 8, !dbg !124
  %23 = getelementptr inbounds [4 x i64], [4 x i64]* @g_val, i64 0, i64 %22, !dbg !125
  store i64 %21, i64* %23, align 8, !dbg !126
  br label %24, !dbg !127

24:                                               ; preds = %30, %12
  %25 = load i64, i64* %6, align 8, !dbg !128
  %26 = getelementptr inbounds [4 x i64], [4 x i64]* @g_val, i64 0, i64 %25, !dbg !129
  %27 = bitcast i64* %26 to i8*, !dbg !130
  %28 = call i32 @bounded_mpmc_enq(%struct.bounded_mpmc_s* noundef @g_queue, i8* noundef %27), !dbg !131
  %29 = icmp ne i32 %28, 0, !dbg !132
  br i1 %29, label %30, label %31, !dbg !127

30:                                               ; preds = %24
  call void @xbo_backoff(%struct.xbo_s* noundef %4, i32 ()* noundef @xbo_nop, i32 ()* noundef @sched_yield), !dbg !133
  br label %24, !dbg !127, !llvm.loop !135

31:                                               ; preds = %24
  call void @xbo_reset(%struct.xbo_s* noundef %4), !dbg !138
  br label %32, !dbg !139

32:                                               ; preds = %31
  %33 = load i64, i64* %5, align 8, !dbg !140
  %34 = add i64 %33, 1, !dbg !140
  store i64 %34, i64* %5, align 8, !dbg !140
  br label %9, !dbg !141, !llvm.loop !142

35:                                               ; preds = %9
  ret i8* null, !dbg !144
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @xbo_init(%struct.xbo_s* noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) #0 !dbg !145 {
  %5 = alloca %struct.xbo_s*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.xbo_s* %0, %struct.xbo_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.xbo_s** %5, metadata !149, metadata !DIExpression()), !dbg !150
  store i32 %1, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !151, metadata !DIExpression()), !dbg !152
  store i32 %2, i32* %7, align 4
  call void @llvm.dbg.declare(metadata i32* %7, metadata !153, metadata !DIExpression()), !dbg !154
  store i32 %3, i32* %8, align 4
  call void @llvm.dbg.declare(metadata i32* %8, metadata !155, metadata !DIExpression()), !dbg !156
  ret void, !dbg !157
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @bounded_mpmc_enq(%struct.bounded_mpmc_s* noundef %0, i8* noundef %1) #0 !dbg !158 {
  %3 = alloca i32, align 4
  %4 = alloca %struct.bounded_mpmc_s*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.bounded_mpmc_s* %0, %struct.bounded_mpmc_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.bounded_mpmc_s** %4, metadata !163, metadata !DIExpression()), !dbg !164
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !165, metadata !DIExpression()), !dbg !166
  call void @llvm.dbg.declare(metadata i32* %6, metadata !167, metadata !DIExpression()), !dbg !168
  call void @llvm.dbg.declare(metadata i32* %7, metadata !169, metadata !DIExpression()), !dbg !170
  %8 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !171
  %9 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %8, i32 0, i32 0, !dbg !172
  %10 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %9), !dbg !173
  store i32 %10, i32* %6, align 4, !dbg !174
  %11 = load i32, i32* %6, align 4, !dbg !175
  %12 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !177
  %13 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %12, i32 0, i32 3, !dbg !178
  %14 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %13), !dbg !179
  %15 = sub i32 %11, %14, !dbg !180
  %16 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !181
  %17 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %16, i32 0, i32 5, !dbg !182
  %18 = load i32, i32* %17, align 8, !dbg !182
  %19 = icmp eq i32 %15, %18, !dbg !183
  br i1 %19, label %20, label %21, !dbg !184

20:                                               ; preds = %2
  store i32 1, i32* %3, align 4, !dbg !185
  br label %51, !dbg !185

21:                                               ; preds = %2
  %22 = load i32, i32* %6, align 4, !dbg !187
  %23 = add i32 %22, 1, !dbg !188
  store i32 %23, i32* %7, align 4, !dbg !189
  %24 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !190
  %25 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %24, i32 0, i32 0, !dbg !192
  %26 = load i32, i32* %6, align 4, !dbg !193
  %27 = load i32, i32* %7, align 4, !dbg !194
  %28 = call i32 @vatomic32_cmpxchg_rel(%struct.vatomic32_s* noundef %25, i32 noundef %26, i32 noundef %27), !dbg !195
  %29 = load i32, i32* %6, align 4, !dbg !196
  %30 = icmp ne i32 %28, %29, !dbg !197
  br i1 %30, label %31, label %32, !dbg !198

31:                                               ; preds = %21
  store i32 3, i32* %3, align 4, !dbg !199
  br label %51, !dbg !199

32:                                               ; preds = %21
  %33 = load i8*, i8** %5, align 8, !dbg !201
  %34 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !202
  %35 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %34, i32 0, i32 4, !dbg !203
  %36 = load i8**, i8*** %35, align 8, !dbg !203
  %37 = load i32, i32* %6, align 4, !dbg !204
  %38 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !205
  %39 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %38, i32 0, i32 5, !dbg !206
  %40 = load i32, i32* %39, align 8, !dbg !206
  %41 = urem i32 %37, %40, !dbg !207
  %42 = zext i32 %41 to i64, !dbg !202
  %43 = getelementptr inbounds i8*, i8** %36, i64 %42, !dbg !202
  store i8* %33, i8** %43, align 8, !dbg !208
  %44 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !209
  %45 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %44, i32 0, i32 1, !dbg !210
  %46 = load i32, i32* %6, align 4, !dbg !211
  %47 = call i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %45, i32 noundef %46), !dbg !212
  %48 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !213
  %49 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %48, i32 0, i32 1, !dbg !214
  %50 = load i32, i32* %7, align 4, !dbg !215
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %49, i32 noundef %50), !dbg !216
  store i32 0, i32* %3, align 4, !dbg !217
  br label %51, !dbg !217

51:                                               ; preds = %32, %31, %20
  %52 = load i32, i32* %3, align 4, !dbg !218
  ret i32 %52, !dbg !218
}

; Function Attrs: noinline nounwind uwtable
define internal void @xbo_backoff(%struct.xbo_s* noundef %0, i32 ()* noundef %1, i32 ()* noundef %2) #0 !dbg !219 {
  %4 = alloca %struct.xbo_s*, align 8
  %5 = alloca i32 ()*, align 8
  %6 = alloca i32 ()*, align 8
  store %struct.xbo_s* %0, %struct.xbo_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.xbo_s** %4, metadata !224, metadata !DIExpression()), !dbg !225
  store i32 ()* %1, i32 ()** %5, align 8
  call void @llvm.dbg.declare(metadata i32 ()** %5, metadata !226, metadata !DIExpression()), !dbg !227
  store i32 ()* %2, i32 ()** %6, align 8
  call void @llvm.dbg.declare(metadata i32 ()** %6, metadata !228, metadata !DIExpression()), !dbg !229
  ret void, !dbg !230
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @xbo_nop() #0 !dbg !231 {
  %1 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %1, metadata !232, metadata !DIExpression()), !dbg !234
  store volatile i32 0, i32* %1, align 4, !dbg !234
  %2 = load volatile i32, i32* %1, align 4, !dbg !235
  ret i32 %2, !dbg !236
}

; Function Attrs: noinline nounwind uwtable
define internal void @xbo_reset(%struct.xbo_s* noundef %0) #0 !dbg !237 {
  %2 = alloca %struct.xbo_s*, align 8
  store %struct.xbo_s* %0, %struct.xbo_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.xbo_s** %2, metadata !240, metadata !DIExpression()), !dbg !241
  ret void, !dbg !242
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !243 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8*, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !244, metadata !DIExpression()), !dbg !245
  store i32 0, i32* %2, align 4, !dbg !245
  call void @bounded_mpmc_init(%struct.bounded_mpmc_s* noundef @g_queue, i8** noundef getelementptr inbounds ([4 x i8*], [4 x i8*]* @g_buf, i64 0, i64 0), i32 noundef 4), !dbg !246
  call void @launch_threads(i64 noundef 2, i8* (i8*)* noundef @writer), !dbg !247
  call void @llvm.dbg.declare(metadata i8** %3, metadata !248, metadata !DIExpression()), !dbg !249
  store i8* null, i8** %3, align 8, !dbg !249
  %5 = call i32 @bounded_mpmc_deq(%struct.bounded_mpmc_s* noundef @g_queue, i8** noundef %3), !dbg !250
  store i32 %5, i32* %2, align 4, !dbg !251
  %6 = load i32, i32* %2, align 4, !dbg !252
  %7 = icmp eq i32 %6, 0, !dbg !252
  br i1 %7, label %8, label %9, !dbg !255

8:                                                ; preds = %0
  br label %10, !dbg !255

9:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([86 x i8], [86 x i8]* @.str.1, i64 0, i64 0), i32 noundef 69, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !252
  unreachable, !dbg !252

10:                                               ; preds = %8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !256, metadata !DIExpression()), !dbg !257
  %11 = load i8*, i8** %3, align 8, !dbg !258
  %12 = bitcast i8* %11 to i64*, !dbg !259
  %13 = load i64, i64* %12, align 8, !dbg !260
  store i64 %13, i64* %4, align 8, !dbg !257
  %14 = load i64, i64* %4, align 8, !dbg !261
  %15 = urem i64 %14, 10, !dbg !261
  %16 = icmp eq i64 %15, 1, !dbg !261
  br i1 %16, label %17, label %18, !dbg !264

17:                                               ; preds = %10
  br label %19, !dbg !264

18:                                               ; preds = %10
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([86 x i8], [86 x i8]* @.str.1, i64 0, i64 0), i32 noundef 74, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !261
  unreachable, !dbg !261

19:                                               ; preds = %17
  %20 = load i64, i64* %4, align 8, !dbg !265
  %21 = icmp ule i64 %20, 21, !dbg !265
  br i1 %21, label %22, label %23, !dbg !268

22:                                               ; preds = %19
  br label %24, !dbg !268

23:                                               ; preds = %19
  call void @__assert_fail(i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([86 x i8], [86 x i8]* @.str.1, i64 0, i64 0), i32 noundef 75, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !265
  unreachable, !dbg !265

24:                                               ; preds = %22
  %25 = bitcast i8** %3 to i8*, !dbg !269
  %26 = call i32 @bounded_mpmc_enq(%struct.bounded_mpmc_s* noundef @g_queue, i8* noundef %25), !dbg !270
  store i32 %26, i32* %2, align 4, !dbg !271
  %27 = load i32, i32* %2, align 4, !dbg !272
  %28 = icmp eq i32 %27, 0, !dbg !272
  br i1 %28, label %29, label %30, !dbg !275

29:                                               ; preds = %24
  br label %31, !dbg !275

30:                                               ; preds = %24
  call void @__assert_fail(i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([86 x i8], [86 x i8]* @.str.1, i64 0, i64 0), i32 noundef 79, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !272
  unreachable, !dbg !272

31:                                               ; preds = %29
  %32 = bitcast i8** %3 to i8*, !dbg !276
  %33 = call i32 @bounded_mpmc_enq(%struct.bounded_mpmc_s* noundef @g_queue, i8* noundef %32), !dbg !277
  store i32 %33, i32* %2, align 4, !dbg !278
  %34 = load i32, i32* %2, align 4, !dbg !279
  %35 = icmp eq i32 %34, 1, !dbg !279
  br i1 %35, label %36, label %37, !dbg !282

36:                                               ; preds = %31
  br label %38, !dbg !282

37:                                               ; preds = %31
  call void @__assert_fail(i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([86 x i8], [86 x i8]* @.str.1, i64 0, i64 0), i32 noundef 83, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !279
  unreachable, !dbg !279

38:                                               ; preds = %36
  br label %39, !dbg !283

39:                                               ; preds = %38
  br label %40, !dbg !284

40:                                               ; preds = %39
  %41 = load i32, i32* %2, align 4, !dbg !286
  br label %42, !dbg !286

42:                                               ; preds = %40
  %43 = load i64, i64* %4, align 8, !dbg !288
  br label %44, !dbg !288

44:                                               ; preds = %42
  br label %45, !dbg !290

45:                                               ; preds = %44
  br label %46, !dbg !288

46:                                               ; preds = %45
  br label %47, !dbg !286

47:                                               ; preds = %46
  br label %48, !dbg !284

48:                                               ; preds = %47
  ret i32 0, !dbg !292
}

; Function Attrs: noinline nounwind uwtable
define internal void @bounded_mpmc_init(%struct.bounded_mpmc_s* noundef %0, i8** noundef %1, i32 noundef %2) #0 !dbg !293 {
  %4 = alloca %struct.bounded_mpmc_s*, align 8
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  store %struct.bounded_mpmc_s* %0, %struct.bounded_mpmc_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.bounded_mpmc_s** %4, metadata !296, metadata !DIExpression()), !dbg !297
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !298, metadata !DIExpression()), !dbg !299
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !300, metadata !DIExpression()), !dbg !301
  %7 = load i8**, i8*** %5, align 8, !dbg !302
  %8 = icmp ne i8** %7, null, !dbg !302
  br i1 %8, label %9, label %11, !dbg !302

9:                                                ; preds = %3
  br i1 true, label %10, label %11, !dbg !305

10:                                               ; preds = %9
  br label %12, !dbg !305

11:                                               ; preds = %9, %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([90 x i8], [90 x i8]* @.str.7, i64 0, i64 0), i32 noundef 52, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__.bounded_mpmc_init, i64 0, i64 0)) #5, !dbg !302
  unreachable, !dbg !302

12:                                               ; preds = %10
  %13 = load i32, i32* %6, align 4, !dbg !306
  %14 = icmp ne i32 %13, 0, !dbg !306
  br i1 %14, label %15, label %17, !dbg !306

15:                                               ; preds = %12
  br i1 true, label %16, label %17, !dbg !309

16:                                               ; preds = %15
  br label %18, !dbg !309

17:                                               ; preds = %15, %12
  call void @__assert_fail(i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([90 x i8], [90 x i8]* @.str.7, i64 0, i64 0), i32 noundef 53, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__.bounded_mpmc_init, i64 0, i64 0)) #5, !dbg !306
  unreachable, !dbg !306

18:                                               ; preds = %16
  %19 = load i8**, i8*** %5, align 8, !dbg !310
  %20 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !311
  %21 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %20, i32 0, i32 4, !dbg !312
  store i8** %19, i8*** %21, align 8, !dbg !313
  %22 = load i32, i32* %6, align 4, !dbg !314
  %23 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !315
  %24 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %23, i32 0, i32 5, !dbg !316
  store i32 %22, i32* %24, align 8, !dbg !317
  %25 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !318
  %26 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %25, i32 0, i32 2, !dbg !319
  call void @vatomic32_init(%struct.vatomic32_s* noundef %26, i32 noundef 0), !dbg !320
  %27 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !321
  %28 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %27, i32 0, i32 3, !dbg !322
  call void @vatomic32_init(%struct.vatomic32_s* noundef %28, i32 noundef 0), !dbg !323
  %29 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !324
  %30 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %29, i32 0, i32 0, !dbg !325
  call void @vatomic32_init(%struct.vatomic32_s* noundef %30, i32 noundef 0), !dbg !326
  %31 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !327
  %32 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %31, i32 0, i32 1, !dbg !328
  call void @vatomic32_init(%struct.vatomic32_s* noundef %32, i32 noundef 0), !dbg !329
  ret void, !dbg !330
}

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !331 {
  %3 = alloca i64, align 8
  %4 = alloca i8* (i8*)*, align 8
  %5 = alloca %struct.run_info_t*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !334, metadata !DIExpression()), !dbg !335
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %4, metadata !336, metadata !DIExpression()), !dbg !337
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !338, metadata !DIExpression()), !dbg !339
  %6 = load i64, i64* %3, align 8, !dbg !340
  %7 = mul i64 32, %6, !dbg !341
  %8 = call noalias i8* @malloc(i64 noundef %7) #6, !dbg !342
  %9 = bitcast i8* %8 to %struct.run_info_t*, !dbg !342
  store %struct.run_info_t* %9, %struct.run_info_t** %5, align 8, !dbg !339
  %10 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !343
  %11 = load i64, i64* %3, align 8, !dbg !344
  %12 = load i8* (i8*)*, i8* (i8*)** %4, align 8, !dbg !345
  call void @create_threads(%struct.run_info_t* noundef %10, i64 noundef %11, i8* (i8*)* noundef %12, i1 noundef zeroext true), !dbg !346
  %13 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !347
  %14 = load i64, i64* %3, align 8, !dbg !348
  call void @await_threads(%struct.run_info_t* noundef %13, i64 noundef %14), !dbg !349
  %15 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !350
  %16 = bitcast %struct.run_info_t* %15 to i8*, !dbg !350
  call void @free(i8* noundef %16) #6, !dbg !351
  ret void, !dbg !352
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @bounded_mpmc_deq(%struct.bounded_mpmc_s* noundef %0, i8** noundef %1) #0 !dbg !353 {
  %3 = alloca i32, align 4
  %4 = alloca %struct.bounded_mpmc_s*, align 8
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.bounded_mpmc_s* %0, %struct.bounded_mpmc_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.bounded_mpmc_s** %4, metadata !356, metadata !DIExpression()), !dbg !357
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !358, metadata !DIExpression()), !dbg !359
  call void @llvm.dbg.declare(metadata i32* %6, metadata !360, metadata !DIExpression()), !dbg !361
  call void @llvm.dbg.declare(metadata i32* %7, metadata !362, metadata !DIExpression()), !dbg !363
  %8 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !364
  %9 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %8, i32 0, i32 2, !dbg !365
  %10 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %9), !dbg !366
  store i32 %10, i32* %6, align 4, !dbg !367
  %11 = load i32, i32* %6, align 4, !dbg !368
  %12 = add i32 %11, 1, !dbg !369
  store i32 %12, i32* %7, align 4, !dbg !370
  %13 = load i32, i32* %6, align 4, !dbg !371
  %14 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !373
  %15 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %14, i32 0, i32 1, !dbg !374
  %16 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %15), !dbg !375
  %17 = icmp eq i32 %13, %16, !dbg !376
  br i1 %17, label %18, label %19, !dbg !377

18:                                               ; preds = %2
  store i32 2, i32* %3, align 4, !dbg !378
  br label %48, !dbg !378

19:                                               ; preds = %2
  %20 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !380
  %21 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %20, i32 0, i32 2, !dbg !382
  %22 = load i32, i32* %6, align 4, !dbg !383
  %23 = load i32, i32* %7, align 4, !dbg !384
  %24 = call i32 @vatomic32_cmpxchg_rel(%struct.vatomic32_s* noundef %21, i32 noundef %22, i32 noundef %23), !dbg !385
  %25 = load i32, i32* %6, align 4, !dbg !386
  %26 = icmp ne i32 %24, %25, !dbg !387
  br i1 %26, label %27, label %28, !dbg !388

27:                                               ; preds = %19
  store i32 3, i32* %3, align 4, !dbg !389
  br label %48, !dbg !389

28:                                               ; preds = %19
  %29 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !391
  %30 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %29, i32 0, i32 4, !dbg !392
  %31 = load i8**, i8*** %30, align 8, !dbg !392
  %32 = load i32, i32* %6, align 4, !dbg !393
  %33 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !394
  %34 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %33, i32 0, i32 5, !dbg !395
  %35 = load i32, i32* %34, align 8, !dbg !395
  %36 = urem i32 %32, %35, !dbg !396
  %37 = zext i32 %36 to i64, !dbg !391
  %38 = getelementptr inbounds i8*, i8** %31, i64 %37, !dbg !391
  %39 = load i8*, i8** %38, align 8, !dbg !391
  %40 = load i8**, i8*** %5, align 8, !dbg !397
  store i8* %39, i8** %40, align 8, !dbg !398
  %41 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !399
  %42 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %41, i32 0, i32 3, !dbg !400
  %43 = load i32, i32* %6, align 4, !dbg !401
  %44 = call i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %42, i32 noundef %43), !dbg !402
  %45 = load %struct.bounded_mpmc_s*, %struct.bounded_mpmc_s** %4, align 8, !dbg !403
  %46 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %45, i32 0, i32 3, !dbg !404
  %47 = load i32, i32* %7, align 4, !dbg !405
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %46, i32 noundef %47), !dbg !406
  store i32 0, i32* %3, align 4, !dbg !407
  br label %48, !dbg !407

48:                                               ; preds = %28, %27, %18
  %49 = load i32, i32* %3, align 4, !dbg !408
  ret i32 %49, !dbg !408
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !409 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !415, metadata !DIExpression()), !dbg !416
  call void @llvm.dbg.declare(metadata i32* %3, metadata !417, metadata !DIExpression()), !dbg !418
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !419
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !420
  %6 = load i32, i32* %5, align 4, !dbg !420
  %7 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !421, !srcloc !422
  store i32 %7, i32* %3, align 4, !dbg !421
  %8 = load i32, i32* %3, align 4, !dbg !423
  ret i32 %8, !dbg !424
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !425 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !426, metadata !DIExpression()), !dbg !427
  call void @llvm.dbg.declare(metadata i32* %3, metadata !428, metadata !DIExpression()), !dbg !429
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !430
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !431
  %6 = load i32, i32* %5, align 4, !dbg !431
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !432, !srcloc !433
  store i32 %7, i32* %3, align 4, !dbg !432
  %8 = load i32, i32* %3, align 4, !dbg !434
  ret i32 %8, !dbg !435
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !436 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !441, metadata !DIExpression()), !dbg !442
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !443, metadata !DIExpression()), !dbg !444
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !445, metadata !DIExpression()), !dbg !446
  call void @llvm.dbg.declare(metadata i32* %7, metadata !447, metadata !DIExpression()), !dbg !448
  call void @llvm.dbg.declare(metadata i32* %8, metadata !449, metadata !DIExpression()), !dbg !450
  %9 = load i32, i32* %6, align 4, !dbg !451
  %10 = load i32, i32* %5, align 4, !dbg !452
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !453
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !454
  %13 = load i32, i32* %12, align 4, !dbg !454
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astlxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !455, !srcloc !456
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !455
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !455
  store i32 %15, i32* %7, align 4, !dbg !455
  store i32 %16, i32* %8, align 4, !dbg !455
  %17 = load i32, i32* %7, align 4, !dbg !457
  ret i32 %17, !dbg !458
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !459 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !462, metadata !DIExpression()), !dbg !463
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !464, metadata !DIExpression()), !dbg !465
  call void @llvm.dbg.declare(metadata i32* %5, metadata !466, metadata !DIExpression()), !dbg !467
  %6 = load i32, i32* %4, align 4, !dbg !468
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !469
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !470
  %9 = load i32, i32* %8, align 4, !dbg !470
  %10 = call i32 asm sideeffect "1:\0Aldar ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.ne 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !471, !srcloc !472
  store i32 %10, i32* %5, align 4, !dbg !471
  %11 = load i32, i32* %5, align 4, !dbg !473
  ret i32 %11, !dbg !474
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !475 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !478, metadata !DIExpression()), !dbg !479
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !480, metadata !DIExpression()), !dbg !481
  %5 = load i32, i32* %4, align 4, !dbg !482
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !483
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !484
  %8 = load i32, i32* %7, align 4, !dbg !484
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !485, !srcloc !486
  ret void, !dbg !487
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_init(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !488 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !490, metadata !DIExpression()), !dbg !491
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !492, metadata !DIExpression()), !dbg !493
  %5 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !494
  %6 = load i32, i32* %4, align 4, !dbg !495
  call void @vatomic32_write(%struct.vatomic32_s* noundef %5, i32 noundef %6), !dbg !496
  ret void, !dbg !497
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !498 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !499, metadata !DIExpression()), !dbg !500
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !501, metadata !DIExpression()), !dbg !502
  %5 = load i32, i32* %4, align 4, !dbg !503
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !504
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !505
  %8 = load i32, i32* %7, align 4, !dbg !505
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !506, !srcloc !507
  ret void, !dbg !508
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !509 {
  %5 = alloca %struct.run_info_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8* (i8*)*, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !512, metadata !DIExpression()), !dbg !513
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !514, metadata !DIExpression()), !dbg !515
  store i8* (i8*)* %2, i8* (i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %7, metadata !516, metadata !DIExpression()), !dbg !517
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !518, metadata !DIExpression()), !dbg !519
  call void @llvm.dbg.declare(metadata i64* %9, metadata !520, metadata !DIExpression()), !dbg !521
  store i64 0, i64* %9, align 8, !dbg !521
  store i64 0, i64* %9, align 8, !dbg !522
  br label %11, !dbg !524

11:                                               ; preds = %42, %4
  %12 = load i64, i64* %9, align 8, !dbg !525
  %13 = load i64, i64* %6, align 8, !dbg !527
  %14 = icmp ult i64 %12, %13, !dbg !528
  br i1 %14, label %15, label %45, !dbg !529

15:                                               ; preds = %11
  %16 = load i64, i64* %9, align 8, !dbg !530
  %17 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !532
  %18 = load i64, i64* %9, align 8, !dbg !533
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %17, i64 %18, !dbg !532
  %20 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %19, i32 0, i32 1, !dbg !534
  store i64 %16, i64* %20, align 8, !dbg !535
  %21 = load i8* (i8*)*, i8* (i8*)** %7, align 8, !dbg !536
  %22 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !537
  %23 = load i64, i64* %9, align 8, !dbg !538
  %24 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %22, i64 %23, !dbg !537
  %25 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %24, i32 0, i32 3, !dbg !539
  store i8* (i8*)* %21, i8* (i8*)** %25, align 8, !dbg !540
  %26 = load i8, i8* %8, align 1, !dbg !541
  %27 = trunc i8 %26 to i1, !dbg !541
  %28 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !542
  %29 = load i64, i64* %9, align 8, !dbg !543
  %30 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %28, i64 %29, !dbg !542
  %31 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %30, i32 0, i32 2, !dbg !544
  %32 = zext i1 %27 to i8, !dbg !545
  store i8 %32, i8* %31, align 8, !dbg !545
  %33 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !546
  %34 = load i64, i64* %9, align 8, !dbg !547
  %35 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %33, i64 %34, !dbg !546
  %36 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %35, i32 0, i32 0, !dbg !548
  %37 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !549
  %38 = load i64, i64* %9, align 8, !dbg !550
  %39 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %37, i64 %38, !dbg !549
  %40 = bitcast %struct.run_info_t* %39 to i8*, !dbg !551
  %41 = call i32 @pthread_create(i64* noundef %36, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %40) #6, !dbg !552
  br label %42, !dbg !553

42:                                               ; preds = %15
  %43 = load i64, i64* %9, align 8, !dbg !554
  %44 = add i64 %43, 1, !dbg !554
  store i64 %44, i64* %9, align 8, !dbg !554
  br label %11, !dbg !555, !llvm.loop !556

45:                                               ; preds = %11
  ret void, !dbg !558
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !559 {
  %3 = alloca %struct.run_info_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !562, metadata !DIExpression()), !dbg !563
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !564, metadata !DIExpression()), !dbg !565
  call void @llvm.dbg.declare(metadata i64* %5, metadata !566, metadata !DIExpression()), !dbg !567
  store i64 0, i64* %5, align 8, !dbg !567
  store i64 0, i64* %5, align 8, !dbg !568
  br label %6, !dbg !570

6:                                                ; preds = %17, %2
  %7 = load i64, i64* %5, align 8, !dbg !571
  %8 = load i64, i64* %4, align 8, !dbg !573
  %9 = icmp ult i64 %7, %8, !dbg !574
  br i1 %9, label %10, label %20, !dbg !575

10:                                               ; preds = %6
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !576
  %12 = load i64, i64* %5, align 8, !dbg !578
  %13 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i64 %12, !dbg !576
  %14 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %13, i32 0, i32 0, !dbg !579
  %15 = load i64, i64* %14, align 8, !dbg !579
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !580
  br label %17, !dbg !581

17:                                               ; preds = %10
  %18 = load i64, i64* %5, align 8, !dbg !582
  %19 = add i64 %18, 1, !dbg !582
  store i64 %19, i64* %5, align 8, !dbg !582
  br label %6, !dbg !583, !llvm.loop !584

20:                                               ; preds = %6
  ret void, !dbg !586
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !587 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.run_info_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !588, metadata !DIExpression()), !dbg !589
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !590, metadata !DIExpression()), !dbg !591
  %4 = load i8*, i8** %2, align 8, !dbg !592
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !593
  store %struct.run_info_t* %5, %struct.run_info_t** %3, align 8, !dbg !591
  %6 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !594
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %6, i32 0, i32 2, !dbg !596
  %8 = load i8, i8* %7, align 8, !dbg !596
  %9 = trunc i8 %8 to i1, !dbg !596
  br i1 %9, label %10, label %14, !dbg !597

10:                                               ; preds = %1
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !598
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i32 0, i32 1, !dbg !599
  %13 = load i64, i64* %12, align 8, !dbg !599
  call void @set_cpu_affinity(i64 noundef %13), !dbg !600
  br label %14, !dbg !600

14:                                               ; preds = %10, %1
  %15 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !601
  %16 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %15, i32 0, i32 3, !dbg !602
  %17 = load i8* (i8*)*, i8* (i8*)** %16, align 8, !dbg !602
  %18 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !603
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %18, i32 0, i32 1, !dbg !604
  %20 = load i64, i64* %19, align 8, !dbg !604
  %21 = inttoptr i64 %20 to i8*, !dbg !605
  %22 = call i8* %17(i8* noundef %21), !dbg !601
  ret i8* %22, !dbg !606
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !607 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !610, metadata !DIExpression()), !dbg !611
  br label %3, !dbg !612

3:                                                ; preds = %1
  br label %4, !dbg !613

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !615
  br label %6, !dbg !615

6:                                                ; preds = %4
  br label %7, !dbg !617

7:                                                ; preds = %6
  br label %8, !dbg !615

8:                                                ; preds = %7
  br label %9, !dbg !613

9:                                                ; preds = %8
  ret void, !dbg !619
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !620 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !621, metadata !DIExpression()), !dbg !622
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !623, metadata !DIExpression()), !dbg !624
  call void @llvm.dbg.declare(metadata i32* %5, metadata !625, metadata !DIExpression()), !dbg !626
  %6 = load i32, i32* %4, align 4, !dbg !627
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !628
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !629
  %9 = load i32, i32* %8, align 4, !dbg !629
  %10 = call i32 asm sideeffect "1:\0Aldr ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.ne 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !630, !srcloc !631
  store i32 %10, i32* %5, align 4, !dbg !630
  %11 = load i32, i32* %5, align 4, !dbg !632
  ret i32 %11, !dbg !633
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!72, !73, !74, !75, !76, !77, !78}
!llvm.ident = !{!79}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_val", scope: !2, file: !44, line: 36, type: !71, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !13, globals: !41, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/datastruct/queue/bounded/test/bounded_mpmc_check_full.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "d08907d3dceff21e12ae5655a1278430")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 8, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "datastruct/queue/bounded/include/vsync/queue/internal/bounded_ret.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "391da9ed4071ef46b42c0029bc1a53be")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12}
!9 = !DIEnumerator(name: "QUEUE_BOUNDED_OK", value: 0)
!10 = !DIEnumerator(name: "QUEUE_BOUNDED_FULL", value: 1)
!11 = !DIEnumerator(name: "QUEUE_BOUNDED_EMPTY", value: 2)
!12 = !DIEnumerator(name: "QUEUE_BOUNDED_AGAIN", value: 3)
!13 = !{!14, !19, !22, !23, !24}
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsize_t", file: !15, line: 43, baseType: !16)
!15 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !17, line: 46, baseType: !18)
!17 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!18 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !15, line: 37, baseType: !20)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !21, line: 90, baseType: !18)
!21 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "run_info_t", file: !26, line: 38, baseType: !27)
!26 = !DIFile(filename: "utils/include/test/thread_launcher.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "b854c1934ab1739fab93f88f22662d53")
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !26, line: 33, size: 256, elements: !28)
!28 = !{!29, !32, !33, !36}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "t", scope: !27, file: !26, line: 34, baseType: !30, size: 64)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !31, line: 27, baseType: !18)
!31 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!32 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !27, file: !26, line: 35, baseType: !14, size: 64, offset: 64)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "assign_me_to_core", scope: !27, file: !26, line: 36, baseType: !34, size: 8, offset: 128)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !15, line: 44, baseType: !35)
!35 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "run_fun", scope: !27, file: !26, line: 37, baseType: !37, size: 64, offset: 192)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "thread_fun_t", file: !26, line: 30, baseType: !38)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!39 = !DISubroutineType(types: !40)
!40 = !{!22, !22}
!41 = !{!42, !48, !0}
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "g_buf", scope: !2, file: !44, line: 34, type: !45, isLocal: false, isDefinition: true)
!44 = !DIFile(filename: "datastruct/queue/bounded/test/bounded_mpmc_check_full.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "d08907d3dceff21e12ae5655a1278430")
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 256, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 4)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "g_queue", scope: !2, file: !44, line: 35, type: !50, isLocal: false, isDefinition: true)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "bounded_mpmc_t", file: !51, line: 40, baseType: !52)
!51 = !DIFile(filename: "datastruct/queue/bounded/include/vsync/queue/bounded_mpmc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "10225dc7f7d17a81603a9ca0b9243ec5")
!52 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bounded_mpmc_s", file: !51, line: 31, size: 256, elements: !53)
!53 = !{!54, !65, !66, !67, !68, !70}
!54 = !DIDerivedType(tag: DW_TAG_member, name: "phead", scope: !52, file: !51, line: 32, baseType: !55, size: 32, align: 32)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !56, line: 34, baseType: !57)
!56 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!57 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !56, line: 32, size: 32, align: 32, elements: !58)
!58 = !{!59}
!59 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !57, file: !56, line: 33, baseType: !60, size: 32)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !15, line: 35, baseType: !61)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !62, line: 26, baseType: !63)
!62 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !64, line: 42, baseType: !7)
!64 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!65 = !DIDerivedType(tag: DW_TAG_member, name: "ptail", scope: !52, file: !51, line: 33, baseType: !55, size: 32, align: 32, offset: 32)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "chead", scope: !52, file: !51, line: 35, baseType: !55, size: 32, align: 32, offset: 64)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "ctail", scope: !52, file: !51, line: 36, baseType: !55, size: 32, align: 32, offset: 96)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "buf", scope: !52, file: !51, line: 38, baseType: !69, size: 64, offset: 128)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !52, file: !51, line: 39, baseType: !60, size: 32, offset: 192)
!71 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 256, elements: !46)
!72 = !{i32 7, !"Dwarf Version", i32 5}
!73 = !{i32 2, !"Debug Info Version", i32 3}
!74 = !{i32 1, !"wchar_size", i32 4}
!75 = !{i32 7, !"PIC Level", i32 2}
!76 = !{i32 7, !"PIE Level", i32 2}
!77 = !{i32 7, !"uwtable", i32 1}
!78 = !{i32 7, !"frame-pointer", i32 2}
!79 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!80 = distinct !DISubprogram(name: "sched_yield", scope: !44, file: !44, line: 18, type: !81, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!81 = !DISubroutineType(types: !82)
!82 = !{!83}
!83 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!84 = !{}
!85 = !DILocation(line: 20, column: 5, scope: !80)
!86 = distinct !DISubprogram(name: "writer", scope: !44, file: !44, line: 39, type: !39, scopeLine: 40, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!87 = !DILocalVariable(name: "arg", arg: 1, scope: !86, file: !44, line: 39, type: !22)
!88 = !DILocation(line: 39, column: 14, scope: !86)
!89 = !DILocalVariable(name: "tid", scope: !86, file: !44, line: 41, type: !14)
!90 = !DILocation(line: 41, column: 13, scope: !86)
!91 = !DILocation(line: 41, column: 40, scope: !86)
!92 = !DILocation(line: 41, column: 28, scope: !86)
!93 = !DILocalVariable(name: "xbo", scope: !86, file: !44, line: 43, type: !94)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "xbo_t", file: !95, line: 49, baseType: !96)
!95 = !DIFile(filename: "utils/include/vsync/utils/xbo.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "01e2840bcd40115be17bb38f1f2baae6")
!96 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xbo_s", file: !95, line: 45, size: 128, elements: !97)
!97 = !{!98, !99, !100, !101}
!98 = !DIDerivedType(tag: DW_TAG_member, name: "min", scope: !96, file: !95, line: 46, baseType: !60, size: 32)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "max", scope: !96, file: !95, line: 46, baseType: !60, size: 32, offset: 32)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "factor", scope: !96, file: !95, line: 47, baseType: !60, size: 32, offset: 64)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !96, file: !95, line: 48, baseType: !60, size: 32, offset: 96)
!102 = !DILocation(line: 43, column: 11, scope: !86)
!103 = !DILocation(line: 44, column: 5, scope: !86)
!104 = !DILocalVariable(name: "i", scope: !105, file: !44, line: 46, type: !14)
!105 = distinct !DILexicalBlock(scope: !86, file: !44, line: 46, column: 5)
!106 = !DILocation(line: 46, column: 18, scope: !105)
!107 = !DILocation(line: 46, column: 10, scope: !105)
!108 = !DILocation(line: 46, column: 25, scope: !109)
!109 = distinct !DILexicalBlock(scope: !105, file: !44, line: 46, column: 5)
!110 = !DILocation(line: 46, column: 27, scope: !109)
!111 = !DILocation(line: 46, column: 5, scope: !105)
!112 = !DILocalVariable(name: "idx", scope: !113, file: !44, line: 47, type: !14)
!113 = distinct !DILexicalBlock(scope: !109, file: !44, line: 46, column: 42)
!114 = !DILocation(line: 47, column: 17, scope: !113)
!115 = !DILocation(line: 47, column: 23, scope: !113)
!116 = !DILocation(line: 47, column: 27, scope: !113)
!117 = !DILocation(line: 47, column: 38, scope: !113)
!118 = !DILocation(line: 47, column: 36, scope: !113)
!119 = !DILocation(line: 48, column: 23, scope: !113)
!120 = !DILocation(line: 48, column: 27, scope: !113)
!121 = !DILocation(line: 48, column: 56, scope: !113)
!122 = !DILocation(line: 48, column: 54, scope: !113)
!123 = !DILocation(line: 48, column: 58, scope: !113)
!124 = !DILocation(line: 48, column: 15, scope: !113)
!125 = !DILocation(line: 48, column: 9, scope: !113)
!126 = !DILocation(line: 48, column: 21, scope: !113)
!127 = !DILocation(line: 49, column: 9, scope: !113)
!128 = !DILocation(line: 49, column: 50, scope: !113)
!129 = !DILocation(line: 49, column: 44, scope: !113)
!130 = !DILocation(line: 49, column: 43, scope: !113)
!131 = !DILocation(line: 49, column: 16, scope: !113)
!132 = !DILocation(line: 49, column: 56, scope: !113)
!133 = !DILocation(line: 50, column: 13, scope: !134)
!134 = distinct !DILexicalBlock(scope: !113, file: !44, line: 49, column: 77)
!135 = distinct !{!135, !127, !136, !137}
!136 = !DILocation(line: 51, column: 9, scope: !113)
!137 = !{!"llvm.loop.mustprogress"}
!138 = !DILocation(line: 52, column: 9, scope: !113)
!139 = !DILocation(line: 53, column: 5, scope: !113)
!140 = !DILocation(line: 46, column: 38, scope: !109)
!141 = !DILocation(line: 46, column: 5, scope: !109)
!142 = distinct !{!142, !111, !143, !137}
!143 = !DILocation(line: 53, column: 5, scope: !105)
!144 = !DILocation(line: 54, column: 5, scope: !86)
!145 = distinct !DISubprogram(name: "xbo_init", scope: !95, file: !95, line: 65, type: !146, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!146 = !DISubroutineType(types: !147)
!147 = !{null, !148, !60, !60, !60}
!148 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!149 = !DILocalVariable(name: "xbo", arg: 1, scope: !145, file: !95, line: 65, type: !148)
!150 = !DILocation(line: 65, column: 17, scope: !145)
!151 = !DILocalVariable(name: "min", arg: 2, scope: !145, file: !95, line: 65, type: !60)
!152 = !DILocation(line: 65, column: 32, scope: !145)
!153 = !DILocalVariable(name: "max", arg: 3, scope: !145, file: !95, line: 65, type: !60)
!154 = !DILocation(line: 65, column: 47, scope: !145)
!155 = !DILocalVariable(name: "factor", arg: 4, scope: !145, file: !95, line: 65, type: !60)
!156 = !DILocation(line: 65, column: 62, scope: !145)
!157 = !DILocation(line: 72, column: 1, scope: !145)
!158 = distinct !DISubprogram(name: "bounded_mpmc_enq", scope: !51, file: !51, line: 75, type: !159, scopeLine: 76, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!159 = !DISubroutineType(types: !160)
!160 = !{!161, !162, !22}
!161 = !DIDerivedType(tag: DW_TAG_typedef, name: "bounded_ret_t", file: !6, line: 13, baseType: !5)
!162 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!163 = !DILocalVariable(name: "q", arg: 1, scope: !158, file: !51, line: 75, type: !162)
!164 = !DILocation(line: 75, column: 34, scope: !158)
!165 = !DILocalVariable(name: "v", arg: 2, scope: !158, file: !51, line: 75, type: !22)
!166 = !DILocation(line: 75, column: 43, scope: !158)
!167 = !DILocalVariable(name: "curr", scope: !158, file: !51, line: 77, type: !60)
!168 = !DILocation(line: 77, column: 15, scope: !158)
!169 = !DILocalVariable(name: "next", scope: !158, file: !51, line: 77, type: !60)
!170 = !DILocation(line: 77, column: 21, scope: !158)
!171 = !DILocation(line: 80, column: 32, scope: !158)
!172 = !DILocation(line: 80, column: 35, scope: !158)
!173 = !DILocation(line: 80, column: 12, scope: !158)
!174 = !DILocation(line: 80, column: 10, scope: !158)
!175 = !DILocation(line: 81, column: 9, scope: !176)
!176 = distinct !DILexicalBlock(scope: !158, file: !51, line: 81, column: 9)
!177 = !DILocation(line: 81, column: 36, scope: !176)
!178 = !DILocation(line: 81, column: 39, scope: !176)
!179 = !DILocation(line: 81, column: 16, scope: !176)
!180 = !DILocation(line: 81, column: 14, scope: !176)
!181 = !DILocation(line: 81, column: 49, scope: !176)
!182 = !DILocation(line: 81, column: 52, scope: !176)
!183 = !DILocation(line: 81, column: 46, scope: !176)
!184 = !DILocation(line: 81, column: 9, scope: !158)
!185 = !DILocation(line: 82, column: 9, scope: !186)
!186 = distinct !DILexicalBlock(scope: !176, file: !51, line: 81, column: 58)
!187 = !DILocation(line: 84, column: 12, scope: !158)
!188 = !DILocation(line: 84, column: 17, scope: !158)
!189 = !DILocation(line: 84, column: 10, scope: !158)
!190 = !DILocation(line: 85, column: 32, scope: !191)
!191 = distinct !DILexicalBlock(scope: !158, file: !51, line: 85, column: 9)
!192 = !DILocation(line: 85, column: 35, scope: !191)
!193 = !DILocation(line: 85, column: 42, scope: !191)
!194 = !DILocation(line: 85, column: 48, scope: !191)
!195 = !DILocation(line: 85, column: 9, scope: !191)
!196 = !DILocation(line: 85, column: 57, scope: !191)
!197 = !DILocation(line: 85, column: 54, scope: !191)
!198 = !DILocation(line: 85, column: 9, scope: !158)
!199 = !DILocation(line: 86, column: 9, scope: !200)
!200 = distinct !DILexicalBlock(scope: !191, file: !51, line: 85, column: 63)
!201 = !DILocation(line: 89, column: 30, scope: !158)
!202 = !DILocation(line: 89, column: 5, scope: !158)
!203 = !DILocation(line: 89, column: 8, scope: !158)
!204 = !DILocation(line: 89, column: 12, scope: !158)
!205 = !DILocation(line: 89, column: 19, scope: !158)
!206 = !DILocation(line: 89, column: 22, scope: !158)
!207 = !DILocation(line: 89, column: 17, scope: !158)
!208 = !DILocation(line: 89, column: 28, scope: !158)
!209 = !DILocation(line: 92, column: 29, scope: !158)
!210 = !DILocation(line: 92, column: 32, scope: !158)
!211 = !DILocation(line: 92, column: 39, scope: !158)
!212 = !DILocation(line: 92, column: 5, scope: !158)
!213 = !DILocation(line: 93, column: 26, scope: !158)
!214 = !DILocation(line: 93, column: 29, scope: !158)
!215 = !DILocation(line: 93, column: 36, scope: !158)
!216 = !DILocation(line: 93, column: 5, scope: !158)
!217 = !DILocation(line: 95, column: 5, scope: !158)
!218 = !DILocation(line: 96, column: 1, scope: !158)
!219 = distinct !DISubprogram(name: "xbo_backoff", scope: !95, file: !95, line: 84, type: !220, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!220 = !DISubroutineType(types: !221)
!221 = !{null, !148, !222, !222}
!222 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !223, size: 64)
!223 = !DIDerivedType(tag: DW_TAG_typedef, name: "xbo_cb", file: !95, line: 43, baseType: !81)
!224 = !DILocalVariable(name: "xbo", arg: 1, scope: !219, file: !95, line: 84, type: !148)
!225 = !DILocation(line: 84, column: 20, scope: !219)
!226 = !DILocalVariable(name: "nop", arg: 2, scope: !219, file: !95, line: 84, type: !222)
!227 = !DILocation(line: 84, column: 33, scope: !219)
!228 = !DILocalVariable(name: "cb", arg: 3, scope: !219, file: !95, line: 84, type: !222)
!229 = !DILocation(line: 84, column: 46, scope: !219)
!230 = !DILocation(line: 98, column: 1, scope: !219)
!231 = distinct !DISubprogram(name: "xbo_nop", scope: !95, file: !95, line: 115, type: !81, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!232 = !DILocalVariable(name: "k", scope: !231, file: !95, line: 117, type: !233)
!233 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !83)
!234 = !DILocation(line: 117, column: 18, scope: !231)
!235 = !DILocation(line: 118, column: 12, scope: !231)
!236 = !DILocation(line: 118, column: 5, scope: !231)
!237 = distinct !DISubprogram(name: "xbo_reset", scope: !95, file: !95, line: 106, type: !238, scopeLine: 107, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!238 = !DISubroutineType(types: !239)
!239 = !{null, !148}
!240 = !DILocalVariable(name: "xbo", arg: 1, scope: !237, file: !95, line: 106, type: !148)
!241 = !DILocation(line: 106, column: 18, scope: !237)
!242 = !DILocation(line: 111, column: 1, scope: !237)
!243 = distinct !DISubprogram(name: "main", scope: !44, file: !44, line: 58, type: !81, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!244 = !DILocalVariable(name: "ret", scope: !243, file: !44, line: 60, type: !161)
!245 = !DILocation(line: 60, column: 19, scope: !243)
!246 = !DILocation(line: 62, column: 5, scope: !243)
!247 = !DILocation(line: 64, column: 5, scope: !243)
!248 = !DILocalVariable(name: "r", scope: !243, file: !44, line: 66, type: !22)
!249 = !DILocation(line: 66, column: 11, scope: !243)
!250 = !DILocation(line: 68, column: 11, scope: !243)
!251 = !DILocation(line: 68, column: 9, scope: !243)
!252 = !DILocation(line: 69, column: 5, scope: !253)
!253 = distinct !DILexicalBlock(scope: !254, file: !44, line: 69, column: 5)
!254 = distinct !DILexicalBlock(scope: !243, file: !44, line: 69, column: 5)
!255 = !DILocation(line: 69, column: 5, scope: !254)
!256 = !DILocalVariable(name: "dequeued", scope: !243, file: !44, line: 72, type: !14)
!257 = !DILocation(line: 72, column: 13, scope: !243)
!258 = !DILocation(line: 72, column: 37, scope: !243)
!259 = !DILocation(line: 72, column: 26, scope: !243)
!260 = !DILocation(line: 72, column: 24, scope: !243)
!261 = !DILocation(line: 74, column: 5, scope: !262)
!262 = distinct !DILexicalBlock(scope: !263, file: !44, line: 74, column: 5)
!263 = distinct !DILexicalBlock(scope: !243, file: !44, line: 74, column: 5)
!264 = !DILocation(line: 74, column: 5, scope: !263)
!265 = !DILocation(line: 75, column: 5, scope: !266)
!266 = distinct !DILexicalBlock(scope: !267, file: !44, line: 75, column: 5)
!267 = distinct !DILexicalBlock(scope: !243, file: !44, line: 75, column: 5)
!268 = !DILocation(line: 75, column: 5, scope: !267)
!269 = !DILocation(line: 78, column: 38, scope: !243)
!270 = !DILocation(line: 78, column: 11, scope: !243)
!271 = !DILocation(line: 78, column: 9, scope: !243)
!272 = !DILocation(line: 79, column: 5, scope: !273)
!273 = distinct !DILexicalBlock(scope: !274, file: !44, line: 79, column: 5)
!274 = distinct !DILexicalBlock(scope: !243, file: !44, line: 79, column: 5)
!275 = !DILocation(line: 79, column: 5, scope: !274)
!276 = !DILocation(line: 82, column: 38, scope: !243)
!277 = !DILocation(line: 82, column: 11, scope: !243)
!278 = !DILocation(line: 82, column: 9, scope: !243)
!279 = !DILocation(line: 83, column: 5, scope: !280)
!280 = distinct !DILexicalBlock(scope: !281, file: !44, line: 83, column: 5)
!281 = distinct !DILexicalBlock(scope: !243, file: !44, line: 83, column: 5)
!282 = !DILocation(line: 83, column: 5, scope: !281)
!283 = !DILocation(line: 85, column: 5, scope: !243)
!284 = !DILocation(line: 85, column: 5, scope: !285)
!285 = distinct !DILexicalBlock(scope: !243, file: !44, line: 85, column: 5)
!286 = !DILocation(line: 85, column: 5, scope: !287)
!287 = distinct !DILexicalBlock(scope: !285, file: !44, line: 85, column: 5)
!288 = !DILocation(line: 85, column: 5, scope: !289)
!289 = distinct !DILexicalBlock(scope: !287, file: !44, line: 85, column: 5)
!290 = !DILocation(line: 85, column: 5, scope: !291)
!291 = distinct !DILexicalBlock(scope: !289, file: !44, line: 85, column: 5)
!292 = !DILocation(line: 87, column: 5, scope: !243)
!293 = distinct !DISubprogram(name: "bounded_mpmc_init", scope: !51, file: !51, line: 50, type: !294, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!294 = !DISubroutineType(types: !295)
!295 = !{null, !162, !69, !60}
!296 = !DILocalVariable(name: "q", arg: 1, scope: !293, file: !51, line: 50, type: !162)
!297 = !DILocation(line: 50, column: 35, scope: !293)
!298 = !DILocalVariable(name: "b", arg: 2, scope: !293, file: !51, line: 50, type: !69)
!299 = !DILocation(line: 50, column: 45, scope: !293)
!300 = !DILocalVariable(name: "s", arg: 3, scope: !293, file: !51, line: 50, type: !60)
!301 = !DILocation(line: 50, column: 58, scope: !293)
!302 = !DILocation(line: 52, column: 5, scope: !303)
!303 = distinct !DILexicalBlock(scope: !304, file: !51, line: 52, column: 5)
!304 = distinct !DILexicalBlock(scope: !293, file: !51, line: 52, column: 5)
!305 = !DILocation(line: 52, column: 5, scope: !304)
!306 = !DILocation(line: 53, column: 5, scope: !307)
!307 = distinct !DILexicalBlock(scope: !308, file: !51, line: 53, column: 5)
!308 = distinct !DILexicalBlock(scope: !293, file: !51, line: 53, column: 5)
!309 = !DILocation(line: 53, column: 5, scope: !308)
!310 = !DILocation(line: 55, column: 15, scope: !293)
!311 = !DILocation(line: 55, column: 5, scope: !293)
!312 = !DILocation(line: 55, column: 8, scope: !293)
!313 = !DILocation(line: 55, column: 13, scope: !293)
!314 = !DILocation(line: 56, column: 15, scope: !293)
!315 = !DILocation(line: 56, column: 5, scope: !293)
!316 = !DILocation(line: 56, column: 8, scope: !293)
!317 = !DILocation(line: 56, column: 13, scope: !293)
!318 = !DILocation(line: 57, column: 21, scope: !293)
!319 = !DILocation(line: 57, column: 24, scope: !293)
!320 = !DILocation(line: 57, column: 5, scope: !293)
!321 = !DILocation(line: 58, column: 21, scope: !293)
!322 = !DILocation(line: 58, column: 24, scope: !293)
!323 = !DILocation(line: 58, column: 5, scope: !293)
!324 = !DILocation(line: 59, column: 21, scope: !293)
!325 = !DILocation(line: 59, column: 24, scope: !293)
!326 = !DILocation(line: 59, column: 5, scope: !293)
!327 = !DILocation(line: 60, column: 21, scope: !293)
!328 = !DILocation(line: 60, column: 24, scope: !293)
!329 = !DILocation(line: 60, column: 5, scope: !293)
!330 = !DILocation(line: 61, column: 1, scope: !293)
!331 = distinct !DISubprogram(name: "launch_threads", scope: !26, file: !26, line: 111, type: !332, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!332 = !DISubroutineType(types: !333)
!333 = !{null, !14, !37}
!334 = !DILocalVariable(name: "thread_count", arg: 1, scope: !331, file: !26, line: 111, type: !14)
!335 = !DILocation(line: 111, column: 24, scope: !331)
!336 = !DILocalVariable(name: "fun", arg: 2, scope: !331, file: !26, line: 111, type: !37)
!337 = !DILocation(line: 111, column: 51, scope: !331)
!338 = !DILocalVariable(name: "threads", scope: !331, file: !26, line: 113, type: !24)
!339 = !DILocation(line: 113, column: 17, scope: !331)
!340 = !DILocation(line: 113, column: 55, scope: !331)
!341 = !DILocation(line: 113, column: 53, scope: !331)
!342 = !DILocation(line: 113, column: 27, scope: !331)
!343 = !DILocation(line: 115, column: 20, scope: !331)
!344 = !DILocation(line: 115, column: 29, scope: !331)
!345 = !DILocation(line: 115, column: 43, scope: !331)
!346 = !DILocation(line: 115, column: 5, scope: !331)
!347 = !DILocation(line: 117, column: 19, scope: !331)
!348 = !DILocation(line: 117, column: 28, scope: !331)
!349 = !DILocation(line: 117, column: 5, scope: !331)
!350 = !DILocation(line: 119, column: 10, scope: !331)
!351 = !DILocation(line: 119, column: 5, scope: !331)
!352 = !DILocation(line: 120, column: 1, scope: !331)
!353 = distinct !DISubprogram(name: "bounded_mpmc_deq", scope: !51, file: !51, line: 111, type: !354, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!354 = !DISubroutineType(types: !355)
!355 = !{!161, !162, !69}
!356 = !DILocalVariable(name: "q", arg: 1, scope: !353, file: !51, line: 111, type: !162)
!357 = !DILocation(line: 111, column: 34, scope: !353)
!358 = !DILocalVariable(name: "v", arg: 2, scope: !353, file: !51, line: 111, type: !69)
!359 = !DILocation(line: 111, column: 44, scope: !353)
!360 = !DILocalVariable(name: "curr", scope: !353, file: !51, line: 113, type: !60)
!361 = !DILocation(line: 113, column: 15, scope: !353)
!362 = !DILocalVariable(name: "next", scope: !353, file: !51, line: 113, type: !60)
!363 = !DILocation(line: 113, column: 21, scope: !353)
!364 = !DILocation(line: 116, column: 32, scope: !353)
!365 = !DILocation(line: 116, column: 35, scope: !353)
!366 = !DILocation(line: 116, column: 12, scope: !353)
!367 = !DILocation(line: 116, column: 10, scope: !353)
!368 = !DILocation(line: 117, column: 12, scope: !353)
!369 = !DILocation(line: 117, column: 17, scope: !353)
!370 = !DILocation(line: 117, column: 10, scope: !353)
!371 = !DILocation(line: 118, column: 9, scope: !372)
!372 = distinct !DILexicalBlock(scope: !353, file: !51, line: 118, column: 9)
!373 = !DILocation(line: 118, column: 37, scope: !372)
!374 = !DILocation(line: 118, column: 40, scope: !372)
!375 = !DILocation(line: 118, column: 17, scope: !372)
!376 = !DILocation(line: 118, column: 14, scope: !372)
!377 = !DILocation(line: 118, column: 9, scope: !353)
!378 = !DILocation(line: 119, column: 9, scope: !379)
!379 = distinct !DILexicalBlock(scope: !372, file: !51, line: 118, column: 48)
!380 = !DILocation(line: 121, column: 32, scope: !381)
!381 = distinct !DILexicalBlock(scope: !353, file: !51, line: 121, column: 9)
!382 = !DILocation(line: 121, column: 35, scope: !381)
!383 = !DILocation(line: 121, column: 42, scope: !381)
!384 = !DILocation(line: 121, column: 48, scope: !381)
!385 = !DILocation(line: 121, column: 9, scope: !381)
!386 = !DILocation(line: 121, column: 57, scope: !381)
!387 = !DILocation(line: 121, column: 54, scope: !381)
!388 = !DILocation(line: 121, column: 9, scope: !353)
!389 = !DILocation(line: 122, column: 9, scope: !390)
!390 = distinct !DILexicalBlock(scope: !381, file: !51, line: 121, column: 63)
!391 = !DILocation(line: 125, column: 10, scope: !353)
!392 = !DILocation(line: 125, column: 13, scope: !353)
!393 = !DILocation(line: 125, column: 17, scope: !353)
!394 = !DILocation(line: 125, column: 24, scope: !353)
!395 = !DILocation(line: 125, column: 27, scope: !353)
!396 = !DILocation(line: 125, column: 22, scope: !353)
!397 = !DILocation(line: 125, column: 6, scope: !353)
!398 = !DILocation(line: 125, column: 8, scope: !353)
!399 = !DILocation(line: 128, column: 29, scope: !353)
!400 = !DILocation(line: 128, column: 32, scope: !353)
!401 = !DILocation(line: 128, column: 39, scope: !353)
!402 = !DILocation(line: 128, column: 5, scope: !353)
!403 = !DILocation(line: 129, column: 26, scope: !353)
!404 = !DILocation(line: 129, column: 29, scope: !353)
!405 = !DILocation(line: 129, column: 36, scope: !353)
!406 = !DILocation(line: 129, column: 5, scope: !353)
!407 = !DILocation(line: 131, column: 5, scope: !353)
!408 = !DILocation(line: 132, column: 1, scope: !353)
!409 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !410, file: !410, line: 85, type: !411, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!410 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!411 = !DISubroutineType(types: !412)
!412 = !{!60, !413}
!413 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !414, size: 64)
!414 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !55)
!415 = !DILocalVariable(name: "a", arg: 1, scope: !409, file: !410, line: 85, type: !413)
!416 = !DILocation(line: 85, column: 39, scope: !409)
!417 = !DILocalVariable(name: "val", scope: !409, file: !410, line: 87, type: !60)
!418 = !DILocation(line: 87, column: 15, scope: !409)
!419 = !DILocation(line: 90, column: 32, scope: !409)
!420 = !DILocation(line: 90, column: 35, scope: !409)
!421 = !DILocation(line: 88, column: 5, scope: !409)
!422 = !{i64 601562}
!423 = !DILocation(line: 92, column: 12, scope: !409)
!424 = !DILocation(line: 92, column: 5, scope: !409)
!425 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !410, file: !410, line: 101, type: !411, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!426 = !DILocalVariable(name: "a", arg: 1, scope: !425, file: !410, line: 101, type: !413)
!427 = !DILocation(line: 101, column: 39, scope: !425)
!428 = !DILocalVariable(name: "val", scope: !425, file: !410, line: 103, type: !60)
!429 = !DILocation(line: 103, column: 15, scope: !425)
!430 = !DILocation(line: 106, column: 32, scope: !425)
!431 = !DILocation(line: 106, column: 35, scope: !425)
!432 = !DILocation(line: 104, column: 5, scope: !425)
!433 = !{i64 602064}
!434 = !DILocation(line: 108, column: 12, scope: !425)
!435 = !DILocation(line: 108, column: 5, scope: !425)
!436 = distinct !DISubprogram(name: "vatomic32_cmpxchg_rel", scope: !437, file: !437, line: 336, type: !438, scopeLine: 337, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!437 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!438 = !DISubroutineType(types: !439)
!439 = !{!60, !440, !60, !60}
!440 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !55, size: 64)
!441 = !DILocalVariable(name: "a", arg: 1, scope: !436, file: !437, line: 336, type: !440)
!442 = !DILocation(line: 336, column: 36, scope: !436)
!443 = !DILocalVariable(name: "e", arg: 2, scope: !436, file: !437, line: 336, type: !60)
!444 = !DILocation(line: 336, column: 49, scope: !436)
!445 = !DILocalVariable(name: "v", arg: 3, scope: !436, file: !437, line: 336, type: !60)
!446 = !DILocation(line: 336, column: 62, scope: !436)
!447 = !DILocalVariable(name: "oldv", scope: !436, file: !437, line: 338, type: !60)
!448 = !DILocation(line: 338, column: 15, scope: !436)
!449 = !DILocalVariable(name: "tmp", scope: !436, file: !437, line: 339, type: !60)
!450 = !DILocation(line: 339, column: 15, scope: !436)
!451 = !DILocation(line: 350, column: 22, scope: !436)
!452 = !DILocation(line: 350, column: 36, scope: !436)
!453 = !DILocation(line: 350, column: 48, scope: !436)
!454 = !DILocation(line: 350, column: 51, scope: !436)
!455 = !DILocation(line: 340, column: 5, scope: !436)
!456 = !{i64 667748, i64 667782, i64 667797, i64 667829, i64 667863, i64 667883, i64 667926, i64 667955}
!457 = !DILocation(line: 352, column: 12, scope: !436)
!458 = !DILocation(line: 352, column: 5, scope: !436)
!459 = distinct !DISubprogram(name: "vatomic32_await_eq_acq", scope: !410, file: !410, line: 604, type: !460, scopeLine: 605, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!460 = !DISubroutineType(types: !461)
!461 = !{!60, !413, !60}
!462 = !DILocalVariable(name: "a", arg: 1, scope: !459, file: !410, line: 604, type: !413)
!463 = !DILocation(line: 604, column: 43, scope: !459)
!464 = !DILocalVariable(name: "v", arg: 2, scope: !459, file: !410, line: 604, type: !60)
!465 = !DILocation(line: 604, column: 56, scope: !459)
!466 = !DILocalVariable(name: "val", scope: !459, file: !410, line: 606, type: !60)
!467 = !DILocation(line: 606, column: 15, scope: !459)
!468 = !DILocation(line: 613, column: 21, scope: !459)
!469 = !DILocation(line: 613, column: 33, scope: !459)
!470 = !DILocation(line: 613, column: 36, scope: !459)
!471 = !DILocation(line: 607, column: 5, scope: !459)
!472 = !{i64 616600, i64 616616, i64 616647, i64 616680}
!473 = !DILocation(line: 615, column: 12, scope: !459)
!474 = !DILocation(line: 615, column: 5, scope: !459)
!475 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !410, file: !410, line: 227, type: !476, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!476 = !DISubroutineType(types: !477)
!477 = !{null, !440, !60}
!478 = !DILocalVariable(name: "a", arg: 1, scope: !475, file: !410, line: 227, type: !440)
!479 = !DILocation(line: 227, column: 34, scope: !475)
!480 = !DILocalVariable(name: "v", arg: 2, scope: !475, file: !410, line: 227, type: !60)
!481 = !DILocation(line: 227, column: 47, scope: !475)
!482 = !DILocation(line: 231, column: 32, scope: !475)
!483 = !DILocation(line: 231, column: 44, scope: !475)
!484 = !DILocation(line: 231, column: 47, scope: !475)
!485 = !DILocation(line: 229, column: 5, scope: !475)
!486 = !{i64 605978}
!487 = !DILocation(line: 233, column: 1, scope: !475)
!488 = distinct !DISubprogram(name: "vatomic32_init", scope: !489, file: !489, line: 4189, type: !476, scopeLine: 4190, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!489 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!490 = !DILocalVariable(name: "a", arg: 1, scope: !488, file: !489, line: 4189, type: !440)
!491 = !DILocation(line: 4189, column: 29, scope: !488)
!492 = !DILocalVariable(name: "v", arg: 2, scope: !488, file: !489, line: 4189, type: !60)
!493 = !DILocation(line: 4189, column: 42, scope: !488)
!494 = !DILocation(line: 4191, column: 21, scope: !488)
!495 = !DILocation(line: 4191, column: 24, scope: !488)
!496 = !DILocation(line: 4191, column: 5, scope: !488)
!497 = !DILocation(line: 4192, column: 1, scope: !488)
!498 = distinct !DISubprogram(name: "vatomic32_write", scope: !410, file: !410, line: 213, type: !476, scopeLine: 214, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!499 = !DILocalVariable(name: "a", arg: 1, scope: !498, file: !410, line: 213, type: !440)
!500 = !DILocation(line: 213, column: 30, scope: !498)
!501 = !DILocalVariable(name: "v", arg: 2, scope: !498, file: !410, line: 213, type: !60)
!502 = !DILocation(line: 213, column: 43, scope: !498)
!503 = !DILocation(line: 217, column: 32, scope: !498)
!504 = !DILocation(line: 217, column: 44, scope: !498)
!505 = !DILocation(line: 217, column: 47, scope: !498)
!506 = !DILocation(line: 215, column: 5, scope: !498)
!507 = !{i64 605508}
!508 = !DILocation(line: 219, column: 1, scope: !498)
!509 = distinct !DISubprogram(name: "create_threads", scope: !26, file: !26, line: 83, type: !510, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!510 = !DISubroutineType(types: !511)
!511 = !{null, !24, !14, !37, !34}
!512 = !DILocalVariable(name: "threads", arg: 1, scope: !509, file: !26, line: 83, type: !24)
!513 = !DILocation(line: 83, column: 28, scope: !509)
!514 = !DILocalVariable(name: "num_threads", arg: 2, scope: !509, file: !26, line: 83, type: !14)
!515 = !DILocation(line: 83, column: 45, scope: !509)
!516 = !DILocalVariable(name: "fun", arg: 3, scope: !509, file: !26, line: 83, type: !37)
!517 = !DILocation(line: 83, column: 71, scope: !509)
!518 = !DILocalVariable(name: "bind", arg: 4, scope: !509, file: !26, line: 84, type: !34)
!519 = !DILocation(line: 84, column: 24, scope: !509)
!520 = !DILocalVariable(name: "i", scope: !509, file: !26, line: 86, type: !14)
!521 = !DILocation(line: 86, column: 13, scope: !509)
!522 = !DILocation(line: 87, column: 12, scope: !523)
!523 = distinct !DILexicalBlock(scope: !509, file: !26, line: 87, column: 5)
!524 = !DILocation(line: 87, column: 10, scope: !523)
!525 = !DILocation(line: 87, column: 17, scope: !526)
!526 = distinct !DILexicalBlock(scope: !523, file: !26, line: 87, column: 5)
!527 = !DILocation(line: 87, column: 21, scope: !526)
!528 = !DILocation(line: 87, column: 19, scope: !526)
!529 = !DILocation(line: 87, column: 5, scope: !523)
!530 = !DILocation(line: 88, column: 40, scope: !531)
!531 = distinct !DILexicalBlock(scope: !526, file: !26, line: 87, column: 39)
!532 = !DILocation(line: 88, column: 9, scope: !531)
!533 = !DILocation(line: 88, column: 17, scope: !531)
!534 = !DILocation(line: 88, column: 20, scope: !531)
!535 = !DILocation(line: 88, column: 38, scope: !531)
!536 = !DILocation(line: 89, column: 40, scope: !531)
!537 = !DILocation(line: 89, column: 9, scope: !531)
!538 = !DILocation(line: 89, column: 17, scope: !531)
!539 = !DILocation(line: 89, column: 20, scope: !531)
!540 = !DILocation(line: 89, column: 38, scope: !531)
!541 = !DILocation(line: 90, column: 40, scope: !531)
!542 = !DILocation(line: 90, column: 9, scope: !531)
!543 = !DILocation(line: 90, column: 17, scope: !531)
!544 = !DILocation(line: 90, column: 20, scope: !531)
!545 = !DILocation(line: 90, column: 38, scope: !531)
!546 = !DILocation(line: 91, column: 25, scope: !531)
!547 = !DILocation(line: 91, column: 33, scope: !531)
!548 = !DILocation(line: 91, column: 36, scope: !531)
!549 = !DILocation(line: 91, column: 55, scope: !531)
!550 = !DILocation(line: 91, column: 63, scope: !531)
!551 = !DILocation(line: 91, column: 54, scope: !531)
!552 = !DILocation(line: 91, column: 9, scope: !531)
!553 = !DILocation(line: 92, column: 5, scope: !531)
!554 = !DILocation(line: 87, column: 35, scope: !526)
!555 = !DILocation(line: 87, column: 5, scope: !526)
!556 = distinct !{!556, !529, !557, !137}
!557 = !DILocation(line: 92, column: 5, scope: !523)
!558 = !DILocation(line: 94, column: 1, scope: !509)
!559 = distinct !DISubprogram(name: "await_threads", scope: !26, file: !26, line: 97, type: !560, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!560 = !DISubroutineType(types: !561)
!561 = !{null, !24, !14}
!562 = !DILocalVariable(name: "threads", arg: 1, scope: !559, file: !26, line: 97, type: !24)
!563 = !DILocation(line: 97, column: 27, scope: !559)
!564 = !DILocalVariable(name: "num_threads", arg: 2, scope: !559, file: !26, line: 97, type: !14)
!565 = !DILocation(line: 97, column: 44, scope: !559)
!566 = !DILocalVariable(name: "i", scope: !559, file: !26, line: 99, type: !14)
!567 = !DILocation(line: 99, column: 13, scope: !559)
!568 = !DILocation(line: 100, column: 12, scope: !569)
!569 = distinct !DILexicalBlock(scope: !559, file: !26, line: 100, column: 5)
!570 = !DILocation(line: 100, column: 10, scope: !569)
!571 = !DILocation(line: 100, column: 17, scope: !572)
!572 = distinct !DILexicalBlock(scope: !569, file: !26, line: 100, column: 5)
!573 = !DILocation(line: 100, column: 21, scope: !572)
!574 = !DILocation(line: 100, column: 19, scope: !572)
!575 = !DILocation(line: 100, column: 5, scope: !569)
!576 = !DILocation(line: 101, column: 22, scope: !577)
!577 = distinct !DILexicalBlock(scope: !572, file: !26, line: 100, column: 39)
!578 = !DILocation(line: 101, column: 30, scope: !577)
!579 = !DILocation(line: 101, column: 33, scope: !577)
!580 = !DILocation(line: 101, column: 9, scope: !577)
!581 = !DILocation(line: 102, column: 5, scope: !577)
!582 = !DILocation(line: 100, column: 35, scope: !572)
!583 = !DILocation(line: 100, column: 5, scope: !572)
!584 = distinct !{!584, !575, !585, !137}
!585 = !DILocation(line: 102, column: 5, scope: !569)
!586 = !DILocation(line: 103, column: 1, scope: !559)
!587 = distinct !DISubprogram(name: "common_run", scope: !26, file: !26, line: 43, type: !39, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!588 = !DILocalVariable(name: "args", arg: 1, scope: !587, file: !26, line: 43, type: !22)
!589 = !DILocation(line: 43, column: 18, scope: !587)
!590 = !DILocalVariable(name: "run_info", scope: !587, file: !26, line: 45, type: !24)
!591 = !DILocation(line: 45, column: 17, scope: !587)
!592 = !DILocation(line: 45, column: 42, scope: !587)
!593 = !DILocation(line: 45, column: 28, scope: !587)
!594 = !DILocation(line: 47, column: 9, scope: !595)
!595 = distinct !DILexicalBlock(scope: !587, file: !26, line: 47, column: 9)
!596 = !DILocation(line: 47, column: 19, scope: !595)
!597 = !DILocation(line: 47, column: 9, scope: !587)
!598 = !DILocation(line: 48, column: 26, scope: !595)
!599 = !DILocation(line: 48, column: 36, scope: !595)
!600 = !DILocation(line: 48, column: 9, scope: !595)
!601 = !DILocation(line: 52, column: 12, scope: !587)
!602 = !DILocation(line: 52, column: 22, scope: !587)
!603 = !DILocation(line: 52, column: 38, scope: !587)
!604 = !DILocation(line: 52, column: 48, scope: !587)
!605 = !DILocation(line: 52, column: 30, scope: !587)
!606 = !DILocation(line: 52, column: 5, scope: !587)
!607 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !26, file: !26, line: 61, type: !608, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!608 = !DISubroutineType(types: !609)
!609 = !{null, !14}
!610 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !607, file: !26, line: 61, type: !14)
!611 = !DILocation(line: 61, column: 26, scope: !607)
!612 = !DILocation(line: 78, column: 5, scope: !607)
!613 = !DILocation(line: 78, column: 5, scope: !614)
!614 = distinct !DILexicalBlock(scope: !607, file: !26, line: 78, column: 5)
!615 = !DILocation(line: 78, column: 5, scope: !616)
!616 = distinct !DILexicalBlock(scope: !614, file: !26, line: 78, column: 5)
!617 = !DILocation(line: 78, column: 5, scope: !618)
!618 = distinct !DILexicalBlock(scope: !616, file: !26, line: 78, column: 5)
!619 = !DILocation(line: 80, column: 1, scope: !607)
!620 = distinct !DISubprogram(name: "vatomic32_await_eq_rlx", scope: !410, file: !410, line: 868, type: !460, scopeLine: 869, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!621 = !DILocalVariable(name: "a", arg: 1, scope: !620, file: !410, line: 868, type: !413)
!622 = !DILocation(line: 868, column: 43, scope: !620)
!623 = !DILocalVariable(name: "v", arg: 2, scope: !620, file: !410, line: 868, type: !60)
!624 = !DILocation(line: 868, column: 56, scope: !620)
!625 = !DILocalVariable(name: "val", scope: !620, file: !410, line: 870, type: !60)
!626 = !DILocation(line: 870, column: 15, scope: !620)
!627 = !DILocation(line: 877, column: 21, scope: !620)
!628 = !DILocation(line: 877, column: 33, scope: !620)
!629 = !DILocation(line: 877, column: 36, scope: !620)
!630 = !DILocation(line: 871, column: 5, scope: !620)
!631 = !{i64 623517, i64 623533, i64 623563, i64 623596}
!632 = !DILocation(line: 879, column: 12, scope: !620)
!633 = !DILocation(line: 879, column: 5, scope: !620)
