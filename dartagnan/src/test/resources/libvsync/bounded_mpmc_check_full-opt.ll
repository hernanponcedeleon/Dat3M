; ModuleID = '/home/drc/git/Dat3M/output/bounded_mpmc_check_full.ll'
source_filename = "/home/drc/git/libvsync/test/queue/bounded_mpmc_check_full.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bounded_mpmc_s = type { %struct.vatomic32_s, %struct.vatomic32_s, %struct.vatomic32_s, %struct.vatomic32_s, i8**, i32 }
%struct.vatomic32_s = type { i32 }
%struct.xbo_s = type { i32, i32, i32, i32 }
%struct.run_info_t = type { i64, i64, i8, i8* (i8*)* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_val = dso_local global [4 x i64] zeroinitializer, align 16, !dbg !0
@g_queue = dso_local global %struct.bounded_mpmc_s zeroinitializer, align 8, !dbg !53
@g_buf = dso_local global [4 x i8*] zeroinitializer, align 16, !dbg !47
@.str = private unnamed_addr constant [24 x i8] c"ret == QUEUE_BOUNDED_OK\00", align 1
@.str.1 = private unnamed_addr constant [60 x i8] c"/home/drc/git/libvsync/test/queue/bounded_mpmc_check_full.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"(dequeued % 10U) == 1\00", align 1
@.str.3 = private unnamed_addr constant [26 x i8] c"dequeued <= (2 * 10U + 1)\00", align 1
@.str.4 = private unnamed_addr constant [26 x i8] c"ret == QUEUE_BOUNDED_FULL\00", align 1
@.str.5 = private unnamed_addr constant [15 x i8] c"buffer is NULL\00", align 1
@.str.6 = private unnamed_addr constant [22 x i8] c"b && \22buffer is NULL\22\00", align 1
@.str.7 = private unnamed_addr constant [37 x i8] c"./include/vsync/queue/bounded_mpmc.h\00", align 1
@__PRETTY_FUNCTION__.bounded_mpmc_init = private unnamed_addr constant [61 x i8] c"void bounded_mpmc_init(bounded_mpmc_t *, void **, vuint32_t)\00", align 1
@.str.8 = private unnamed_addr constant [19 x i8] c"buffer with 0 size\00", align 1
@.str.9 = private unnamed_addr constant [31 x i8] c"s != 0 && \22buffer with 0 size\22\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @sched_yield() #0 !dbg !80 {
  ret i32 0, !dbg !85
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @writer(i8* noundef %0) #0 !dbg !86 {
  %2 = alloca %struct.xbo_s, align 4
  call void @llvm.dbg.value(metadata i8* %0, metadata !87, metadata !DIExpression()), !dbg !88
  %3 = ptrtoint i8* %0 to i64, !dbg !89
  call void @llvm.dbg.value(metadata i64 %3, metadata !90, metadata !DIExpression()), !dbg !88
  call void @llvm.dbg.declare(metadata %struct.xbo_s* %2, metadata !91, metadata !DIExpression()), !dbg !100
  call void @xbo_init(%struct.xbo_s* noundef %2, i32 noundef 0, i32 noundef 100, i32 noundef 2), !dbg !101
  call void @llvm.dbg.value(metadata i64 0, metadata !102, metadata !DIExpression()), !dbg !104
  call void @llvm.dbg.value(metadata i64 0, metadata !102, metadata !DIExpression()), !dbg !104
  %4 = mul i64 %3, 2, !dbg !105
  call void @llvm.dbg.value(metadata i64 %4, metadata !108, metadata !DIExpression()), !dbg !109
  %5 = mul i64 %3, 10, !dbg !110
  %6 = add i64 %5, 1, !dbg !111
  %7 = getelementptr inbounds [4 x i64], [4 x i64]* @g_val, i64 0, i64 %4, !dbg !112
  store i64 %6, i64* %7, align 8, !dbg !113
  br label %8, !dbg !114

8:                                                ; preds = %12, %1
  %9 = bitcast i64* %7 to i8*, !dbg !115
  %10 = call i32 @bounded_mpmc_enq(%struct.bounded_mpmc_s* noundef @g_queue, i8* noundef %9), !dbg !116
  %11 = icmp ne i32 %10, 0, !dbg !117
  br i1 %11, label %12, label %13, !dbg !114

12:                                               ; preds = %8
  call void @xbo_backoff(%struct.xbo_s* noundef %2, i32 ()* noundef @xbo_nop, i32 ()* noundef @sched_yield), !dbg !118
  br label %8, !dbg !114, !llvm.loop !120

13:                                               ; preds = %8
  call void @xbo_reset(%struct.xbo_s* noundef %2), !dbg !123
  call void @llvm.dbg.value(metadata i64 1, metadata !102, metadata !DIExpression()), !dbg !104
  call void @llvm.dbg.value(metadata i64 1, metadata !102, metadata !DIExpression()), !dbg !104
  %14 = add i64 %4, 1, !dbg !124
  call void @llvm.dbg.value(metadata i64 %14, metadata !108, metadata !DIExpression()), !dbg !109
  %15 = add i64 %6, 1, !dbg !111
  %16 = getelementptr inbounds [4 x i64], [4 x i64]* @g_val, i64 0, i64 %14, !dbg !112
  store i64 %15, i64* %16, align 8, !dbg !113
  br label %17, !dbg !114

17:                                               ; preds = %22, %13
  %18 = bitcast i64* %16 to i8*, !dbg !115
  %19 = call i32 @bounded_mpmc_enq(%struct.bounded_mpmc_s* noundef @g_queue, i8* noundef %18), !dbg !116
  %20 = icmp ne i32 %19, 0, !dbg !117
  br i1 %20, label %22, label %21, !dbg !114

21:                                               ; preds = %17
  call void @xbo_reset(%struct.xbo_s* noundef %2), !dbg !123
  call void @llvm.dbg.value(metadata i64 2, metadata !102, metadata !DIExpression()), !dbg !104
  call void @llvm.dbg.value(metadata i64 2, metadata !102, metadata !DIExpression()), !dbg !104
  ret i8* null, !dbg !125

22:                                               ; preds = %17
  call void @xbo_backoff(%struct.xbo_s* noundef %2, i32 ()* noundef @xbo_nop, i32 ()* noundef @sched_yield), !dbg !118
  br label %17, !dbg !114, !llvm.loop !120
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @xbo_init(%struct.xbo_s* noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) #0 !dbg !126 {
  call void @llvm.dbg.value(metadata %struct.xbo_s* %0, metadata !130, metadata !DIExpression()), !dbg !131
  call void @llvm.dbg.value(metadata i32 %1, metadata !132, metadata !DIExpression()), !dbg !131
  call void @llvm.dbg.value(metadata i32 %2, metadata !133, metadata !DIExpression()), !dbg !131
  call void @llvm.dbg.value(metadata i32 %3, metadata !134, metadata !DIExpression()), !dbg !131
  ret void, !dbg !135
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @bounded_mpmc_enq(%struct.bounded_mpmc_s* noundef %0, i8* noundef %1) #0 !dbg !136 {
  call void @llvm.dbg.value(metadata %struct.bounded_mpmc_s* %0, metadata !141, metadata !DIExpression()), !dbg !142
  call void @llvm.dbg.value(metadata i8* %1, metadata !143, metadata !DIExpression()), !dbg !142
  %3 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 0, !dbg !144
  %4 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %3), !dbg !145
  call void @llvm.dbg.value(metadata i32 %4, metadata !146, metadata !DIExpression()), !dbg !142
  %5 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 3, !dbg !147
  %6 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %5), !dbg !149
  %7 = sub i32 %4, %6, !dbg !150
  %8 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 5, !dbg !151
  %9 = load i32, i32* %8, align 8, !dbg !151
  %10 = icmp eq i32 %7, %9, !dbg !152
  br i1 %10, label %24, label %11, !dbg !153

11:                                               ; preds = %2
  %12 = add i32 %4, 1, !dbg !154
  call void @llvm.dbg.value(metadata i32 %12, metadata !155, metadata !DIExpression()), !dbg !142
  %13 = call i32 @vatomic32_cmpxchg_rel(%struct.vatomic32_s* noundef %3, i32 noundef %4, i32 noundef %12), !dbg !156
  %14 = icmp ne i32 %13, %4, !dbg !158
  br i1 %14, label %24, label %15, !dbg !159

15:                                               ; preds = %11
  %16 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 4, !dbg !160
  %17 = load i8**, i8*** %16, align 8, !dbg !160
  %18 = load i32, i32* %8, align 8, !dbg !161
  %19 = urem i32 %4, %18, !dbg !162
  %20 = zext i32 %19 to i64, !dbg !163
  %21 = getelementptr inbounds i8*, i8** %17, i64 %20, !dbg !163
  store i8* %1, i8** %21, align 8, !dbg !164
  %22 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 1, !dbg !165
  %23 = call i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %22, i32 noundef %4), !dbg !166
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %22, i32 noundef %12), !dbg !167
  br label %24, !dbg !168

24:                                               ; preds = %11, %2, %15
  %.0 = phi i32 [ 0, %15 ], [ 1, %2 ], [ 3, %11 ], !dbg !142
  ret i32 %.0, !dbg !169
}

; Function Attrs: noinline nounwind uwtable
define internal void @xbo_backoff(%struct.xbo_s* noundef %0, i32 ()* noundef %1, i32 ()* noundef %2) #0 !dbg !170 {
  call void @llvm.dbg.value(metadata %struct.xbo_s* %0, metadata !175, metadata !DIExpression()), !dbg !176
  call void @llvm.dbg.value(metadata i32 ()* %1, metadata !177, metadata !DIExpression()), !dbg !176
  call void @llvm.dbg.value(metadata i32 ()* %2, metadata !178, metadata !DIExpression()), !dbg !176
  ret void, !dbg !179
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @xbo_nop() #0 !dbg !180 {
  %1 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %1, metadata !181, metadata !DIExpression()), !dbg !183
  store volatile i32 0, i32* %1, align 4, !dbg !183
  %.0. = load volatile i32, i32* %1, align 4, !dbg !184
  ret i32 %.0., !dbg !185
}

; Function Attrs: noinline nounwind uwtable
define internal void @xbo_reset(%struct.xbo_s* noundef %0) #0 !dbg !186 {
  call void @llvm.dbg.value(metadata %struct.xbo_s* %0, metadata !189, metadata !DIExpression()), !dbg !190
  ret void, !dbg !191
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !192 {
  %1 = alloca i8*, align 8
  call void @llvm.dbg.value(metadata i32 0, metadata !193, metadata !DIExpression()), !dbg !194
  call void @bounded_mpmc_init(%struct.bounded_mpmc_s* noundef @g_queue, i8** noundef getelementptr inbounds ([4 x i8*], [4 x i8*]* @g_buf, i64 0, i64 0), i32 noundef 4), !dbg !195
  call void @launch_threads(i64 noundef 2, i8* (i8*)* noundef @writer), !dbg !196
  call void @llvm.dbg.declare(metadata i8** %1, metadata !197, metadata !DIExpression()), !dbg !198
  store i8* null, i8** %1, align 8, !dbg !198
  %2 = call i32 @bounded_mpmc_deq(%struct.bounded_mpmc_s* noundef @g_queue, i8** noundef %1), !dbg !199
  call void @llvm.dbg.value(metadata i32 %2, metadata !193, metadata !DIExpression()), !dbg !194
  %3 = icmp eq i32 %2, 0, !dbg !200
  br i1 %3, label %5, label %4, !dbg !203

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 noundef 73, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !200
  unreachable, !dbg !200

5:                                                ; preds = %0
  %6 = load i8*, i8** %1, align 8, !dbg !204
  %7 = bitcast i8* %6 to i64*, !dbg !205
  %8 = load i64, i64* %7, align 8, !dbg !206
  call void @llvm.dbg.value(metadata i64 %8, metadata !207, metadata !DIExpression()), !dbg !194
  %9 = urem i64 %8, 10, !dbg !208
  %10 = icmp eq i64 %9, 1, !dbg !208
  br i1 %10, label %12, label %11, !dbg !211

11:                                               ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 noundef 78, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !208
  unreachable, !dbg !208

12:                                               ; preds = %5
  %13 = icmp ule i64 %8, 21, !dbg !212
  br i1 %13, label %15, label %14, !dbg !215

14:                                               ; preds = %12
  call void @__assert_fail(i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 noundef 79, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !212
  unreachable, !dbg !212

15:                                               ; preds = %12
  %16 = bitcast i8** %1 to i8*, !dbg !216
  %17 = call i32 @bounded_mpmc_enq(%struct.bounded_mpmc_s* noundef @g_queue, i8* noundef %16), !dbg !217
  call void @llvm.dbg.value(metadata i32 %17, metadata !193, metadata !DIExpression()), !dbg !194
  %18 = icmp eq i32 %17, 0, !dbg !218
  br i1 %18, label %20, label %19, !dbg !221

19:                                               ; preds = %15
  call void @__assert_fail(i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 noundef 83, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !218
  unreachable, !dbg !218

20:                                               ; preds = %15
  %21 = call i32 @bounded_mpmc_enq(%struct.bounded_mpmc_s* noundef @g_queue, i8* noundef %16), !dbg !222
  call void @llvm.dbg.value(metadata i32 %21, metadata !193, metadata !DIExpression()), !dbg !194
  %22 = icmp eq i32 %21, 1, !dbg !223
  br i1 %22, label %24, label %23, !dbg !226

23:                                               ; preds = %20
  call void @__assert_fail(i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 noundef 87, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !223
  unreachable, !dbg !223

24:                                               ; preds = %20
  ret i32 0, !dbg !227
}

; Function Attrs: noinline nounwind uwtable
define internal void @bounded_mpmc_init(%struct.bounded_mpmc_s* noundef %0, i8** noundef %1, i32 noundef %2) #0 !dbg !228 {
  call void @llvm.dbg.value(metadata %struct.bounded_mpmc_s* %0, metadata !231, metadata !DIExpression()), !dbg !232
  call void @llvm.dbg.value(metadata i8** %1, metadata !233, metadata !DIExpression()), !dbg !232
  call void @llvm.dbg.value(metadata i32 %2, metadata !234, metadata !DIExpression()), !dbg !232
  %4 = icmp ne i8** %1, null, !dbg !235
  br i1 %4, label %6, label %5, !dbg !235

5:                                                ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @.str.7, i64 0, i64 0), i32 noundef 51, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__.bounded_mpmc_init, i64 0, i64 0)) #5, !dbg !235
  unreachable, !dbg !235

6:                                                ; preds = %3
  %7 = icmp ne i32 %2, 0, !dbg !238
  br i1 %7, label %9, label %8, !dbg !238

8:                                                ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @.str.7, i64 0, i64 0), i32 noundef 52, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__.bounded_mpmc_init, i64 0, i64 0)) #5, !dbg !238
  unreachable, !dbg !238

9:                                                ; preds = %6
  %10 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 4, !dbg !241
  store i8** %1, i8*** %10, align 8, !dbg !242
  %11 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 5, !dbg !243
  store i32 %2, i32* %11, align 8, !dbg !244
  %12 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 2, !dbg !245
  call void @vatomic32_init(%struct.vatomic32_s* noundef %12, i32 noundef 0), !dbg !246
  %13 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 3, !dbg !247
  call void @vatomic32_init(%struct.vatomic32_s* noundef %13, i32 noundef 0), !dbg !248
  %14 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 0, !dbg !249
  call void @vatomic32_init(%struct.vatomic32_s* noundef %14, i32 noundef 0), !dbg !250
  %15 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 1, !dbg !251
  call void @vatomic32_init(%struct.vatomic32_s* noundef %15, i32 noundef 0), !dbg !252
  ret void, !dbg !253
}

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !254 {
  call void @llvm.dbg.value(metadata i64 %0, metadata !257, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata i8* (i8*)* %1, metadata !259, metadata !DIExpression()), !dbg !258
  %3 = mul i64 32, %0, !dbg !260
  %4 = call noalias i8* @malloc(i64 noundef %3) #6, !dbg !261
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !261
  call void @llvm.dbg.value(metadata %struct.run_info_t* %5, metadata !262, metadata !DIExpression()), !dbg !258
  call void @create_threads(%struct.run_info_t* noundef %5, i64 noundef %0, i8* (i8*)* noundef %1, i1 noundef zeroext true), !dbg !263
  call void @await_threads(%struct.run_info_t* noundef %5, i64 noundef %0), !dbg !264
  call void @free(i8* noundef %4) #6, !dbg !265
  ret void, !dbg !266
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @bounded_mpmc_deq(%struct.bounded_mpmc_s* noundef %0, i8** noundef %1) #0 !dbg !267 {
  call void @llvm.dbg.value(metadata %struct.bounded_mpmc_s* %0, metadata !270, metadata !DIExpression()), !dbg !271
  call void @llvm.dbg.value(metadata i8** %1, metadata !272, metadata !DIExpression()), !dbg !271
  %3 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 2, !dbg !273
  %4 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %3), !dbg !274
  call void @llvm.dbg.value(metadata i32 %4, metadata !275, metadata !DIExpression()), !dbg !271
  %5 = add i32 %4, 1, !dbg !276
  call void @llvm.dbg.value(metadata i32 %5, metadata !277, metadata !DIExpression()), !dbg !271
  %6 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 1, !dbg !278
  %7 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %6), !dbg !280
  %8 = icmp eq i32 %4, %7, !dbg !281
  br i1 %8, label %23, label %9, !dbg !282

9:                                                ; preds = %2
  %10 = call i32 @vatomic32_cmpxchg_rel(%struct.vatomic32_s* noundef %3, i32 noundef %4, i32 noundef %5), !dbg !283
  %11 = icmp ne i32 %10, %4, !dbg !285
  br i1 %11, label %23, label %12, !dbg !286

12:                                               ; preds = %9
  %13 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 4, !dbg !287
  %14 = load i8**, i8*** %13, align 8, !dbg !287
  %15 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 5, !dbg !288
  %16 = load i32, i32* %15, align 8, !dbg !288
  %17 = urem i32 %4, %16, !dbg !289
  %18 = zext i32 %17 to i64, !dbg !290
  %19 = getelementptr inbounds i8*, i8** %14, i64 %18, !dbg !290
  %20 = load i8*, i8** %19, align 8, !dbg !290
  store i8* %20, i8** %1, align 8, !dbg !291
  %21 = getelementptr inbounds %struct.bounded_mpmc_s, %struct.bounded_mpmc_s* %0, i32 0, i32 3, !dbg !292
  %22 = call i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %21, i32 noundef %4), !dbg !293
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %21, i32 noundef %5), !dbg !294
  br label %23, !dbg !295

23:                                               ; preds = %9, %2, %12
  %.0 = phi i32 [ 0, %12 ], [ 2, %2 ], [ 3, %9 ], !dbg !271
  ret i32 %.0, !dbg !296
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !297 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !302, metadata !DIExpression()), !dbg !303
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !304, !srcloc !305
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !306
  %3 = load atomic i32, i32* %2 acquire, align 4, !dbg !307
  call void @llvm.dbg.value(metadata i32 %3, metadata !308, metadata !DIExpression()), !dbg !303
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !309, !srcloc !310
  ret i32 %3, !dbg !311
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !312 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !313, metadata !DIExpression()), !dbg !314
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !315, !srcloc !316
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !317
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !318
  call void @llvm.dbg.value(metadata i32 %3, metadata !319, metadata !DIExpression()), !dbg !314
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !320, !srcloc !321
  ret i32 %3, !dbg !322
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !323 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !326, metadata !DIExpression()), !dbg !327
  call void @llvm.dbg.value(metadata i32 %1, metadata !328, metadata !DIExpression()), !dbg !327
  call void @llvm.dbg.value(metadata i32 %2, metadata !329, metadata !DIExpression()), !dbg !327
  call void @llvm.dbg.value(metadata i32 %1, metadata !330, metadata !DIExpression()), !dbg !327
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !331, !srcloc !332
  %4 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !333
  %5 = cmpxchg i32* %4, i32 %1, i32 %2 release monotonic, align 4, !dbg !334
  %6 = extractvalue { i32, i1 } %5, 0, !dbg !334
  %7 = extractvalue { i32, i1 } %5, 1, !dbg !334
  %spec.select = select i1 %7, i32 %1, i32 %6, !dbg !334
  call void @llvm.dbg.value(metadata i32 %spec.select, metadata !330, metadata !DIExpression()), !dbg !327
  %8 = zext i1 %7 to i8, !dbg !334
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !335, !srcloc !336
  ret i32 %spec.select, !dbg !337
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !338 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !342, metadata !DIExpression()), !dbg !343
  call void @llvm.dbg.value(metadata i32 %1, metadata !344, metadata !DIExpression()), !dbg !343
  call void @llvm.dbg.value(metadata i32 %1, metadata !345, metadata !DIExpression()), !dbg !343
  call void @llvm.dbg.value(metadata i32 0, metadata !346, metadata !DIExpression()), !dbg !343
  br label %3, !dbg !347

3:                                                ; preds = %3, %2
  %.0 = phi i32 [ %1, %2 ], [ %4, %3 ], !dbg !343
  call void @llvm.dbg.value(metadata i32 %.0, metadata !345, metadata !DIExpression()), !dbg !343
  %4 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0), !dbg !347
  call void @llvm.dbg.value(metadata i32 %4, metadata !346, metadata !DIExpression()), !dbg !343
  %5 = icmp ne i32 %4, %1, !dbg !347
  br i1 %5, label %3, label %6, !dbg !347, !llvm.loop !348

6:                                                ; preds = %3
  ret i32 %.0, !dbg !350
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !351 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !354, metadata !DIExpression()), !dbg !355
  call void @llvm.dbg.value(metadata i32 %1, metadata !356, metadata !DIExpression()), !dbg !355
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !357, !srcloc !358
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !359
  store atomic i32 %1, i32* %3 release, align 4, !dbg !360
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !361, !srcloc !362
  ret void, !dbg !363
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_init(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !364 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !365, metadata !DIExpression()), !dbg !366
  call void @llvm.dbg.value(metadata i32 %1, metadata !367, metadata !DIExpression()), !dbg !366
  call void @vatomic32_write(%struct.vatomic32_s* noundef %0, i32 noundef %1), !dbg !368
  ret void, !dbg !369
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !370 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !371, metadata !DIExpression()), !dbg !372
  call void @llvm.dbg.value(metadata i32 %1, metadata !373, metadata !DIExpression()), !dbg !372
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !374, !srcloc !375
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !376
  store atomic i32 %1, i32* %3 seq_cst, align 4, !dbg !377
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !378, !srcloc !379
  ret void, !dbg !380
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !381 {
  call void @llvm.dbg.value(metadata %struct.run_info_t* %0, metadata !384, metadata !DIExpression()), !dbg !385
  call void @llvm.dbg.value(metadata i64 %1, metadata !386, metadata !DIExpression()), !dbg !385
  call void @llvm.dbg.value(metadata i8* (i8*)* %2, metadata !387, metadata !DIExpression()), !dbg !385
  %5 = zext i1 %3 to i8
  call void @llvm.dbg.value(metadata i8 %5, metadata !388, metadata !DIExpression()), !dbg !385
  call void @llvm.dbg.value(metadata i64 0, metadata !389, metadata !DIExpression()), !dbg !385
  call void @llvm.dbg.value(metadata i64 0, metadata !389, metadata !DIExpression()), !dbg !385
  br label %6, !dbg !390

6:                                                ; preds = %7, %4
  %.0 = phi i64 [ 0, %4 ], [ %15, %7 ], !dbg !392
  call void @llvm.dbg.value(metadata i64 %.0, metadata !389, metadata !DIExpression()), !dbg !385
  %exitcond = icmp ne i64 %.0, %1, !dbg !393
  br i1 %exitcond, label %7, label %16, !dbg !395

7:                                                ; preds = %6
  %8 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %0, i64 %.0, !dbg !396
  %9 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %8, i32 0, i32 1, !dbg !398
  store i64 %.0, i64* %9, align 8, !dbg !399
  %10 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %8, i32 0, i32 3, !dbg !400
  store i8* (i8*)* %2, i8* (i8*)** %10, align 8, !dbg !401
  %11 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %8, i32 0, i32 2, !dbg !402
  store i8 %5, i8* %11, align 8, !dbg !403
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %8, i32 0, i32 0, !dbg !404
  %13 = bitcast %struct.run_info_t* %8 to i8*, !dbg !405
  %14 = call i32 @pthread_create(i64* noundef %12, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %13) #6, !dbg !406
  %15 = add i64 %.0, 1, !dbg !407
  call void @llvm.dbg.value(metadata i64 %15, metadata !389, metadata !DIExpression()), !dbg !385
  br label %6, !dbg !408, !llvm.loop !409

16:                                               ; preds = %6
  ret void, !dbg !411
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !412 {
  call void @llvm.dbg.value(metadata %struct.run_info_t* %0, metadata !415, metadata !DIExpression()), !dbg !416
  call void @llvm.dbg.value(metadata i64 %1, metadata !417, metadata !DIExpression()), !dbg !416
  call void @llvm.dbg.value(metadata i64 0, metadata !418, metadata !DIExpression()), !dbg !416
  call void @llvm.dbg.value(metadata i64 0, metadata !418, metadata !DIExpression()), !dbg !416
  br label %3, !dbg !419

3:                                                ; preds = %4, %2
  %.0 = phi i64 [ 0, %2 ], [ %9, %4 ], !dbg !421
  call void @llvm.dbg.value(metadata i64 %.0, metadata !418, metadata !DIExpression()), !dbg !416
  %exitcond = icmp ne i64 %.0, %1, !dbg !422
  br i1 %exitcond, label %4, label %10, !dbg !424

4:                                                ; preds = %3
  %5 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %0, i64 %.0, !dbg !425
  %6 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %5, i32 0, i32 0, !dbg !427
  %7 = load i64, i64* %6, align 8, !dbg !427
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null), !dbg !428
  %9 = add i64 %.0, 1, !dbg !429
  call void @llvm.dbg.value(metadata i64 %9, metadata !418, metadata !DIExpression()), !dbg !416
  br label %3, !dbg !430, !llvm.loop !431

10:                                               ; preds = %3
  ret void, !dbg !433
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !434 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !435, metadata !DIExpression()), !dbg !436
  %2 = bitcast i8* %0 to %struct.run_info_t*, !dbg !437
  call void @llvm.dbg.value(metadata %struct.run_info_t* %2, metadata !438, metadata !DIExpression()), !dbg !436
  %3 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %2, i32 0, i32 2, !dbg !439
  %4 = load i8, i8* %3, align 8, !dbg !439
  %5 = trunc i8 %4 to i1, !dbg !439
  br i1 %5, label %6, label %9, !dbg !441

6:                                                ; preds = %1
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %2, i32 0, i32 1, !dbg !442
  %8 = load i64, i64* %7, align 8, !dbg !442
  call void @set_cpu_affinity(i64 noundef %8), !dbg !443
  br label %9, !dbg !443

9:                                                ; preds = %6, %1
  %10 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %2, i32 0, i32 3, !dbg !444
  %11 = load i8* (i8*)*, i8* (i8*)** %10, align 8, !dbg !444
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %2, i32 0, i32 1, !dbg !445
  %13 = load i64, i64* %12, align 8, !dbg !445
  %14 = inttoptr i64 %13 to i8*, !dbg !446
  %15 = call i8* %11(i8* noundef %14), !dbg !447
  ret i8* %15, !dbg !448
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !449 {
  call void @llvm.dbg.value(metadata i64 %0, metadata !452, metadata !DIExpression()), !dbg !453
  ret void, !dbg !454
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !455 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !456, metadata !DIExpression()), !dbg !457
  call void @llvm.dbg.value(metadata i32 %1, metadata !458, metadata !DIExpression()), !dbg !457
  call void @llvm.dbg.value(metadata i32 %1, metadata !459, metadata !DIExpression()), !dbg !457
  call void @llvm.dbg.value(metadata i32 0, metadata !460, metadata !DIExpression()), !dbg !457
  br label %3, !dbg !461

3:                                                ; preds = %3, %2
  %.0 = phi i32 [ %1, %2 ], [ %4, %3 ], !dbg !457
  call void @llvm.dbg.value(metadata i32 %.0, metadata !459, metadata !DIExpression()), !dbg !457
  %4 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0), !dbg !461
  call void @llvm.dbg.value(metadata i32 %4, metadata !460, metadata !DIExpression()), !dbg !457
  %5 = icmp ne i32 %4, %1, !dbg !461
  br i1 %5, label %3, label %6, !dbg !461, !llvm.loop !462

6:                                                ; preds = %3
  ret i32 %.0, !dbg !464
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

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
!1 = distinct !DIGlobalVariable(name: "g_val", scope: !2, file: !49, line: 40, type: !71, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !13, globals: !46, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/libvsync/test/queue/bounded_mpmc_check_full.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "3d7240dfa1c4978843ec3696fbbd43c8")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 8, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "./include/vsync/queue/internal/bounded_ret.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "c46e1376bff92f38e6ff9a1c56080188")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12}
!9 = !DIEnumerator(name: "QUEUE_BOUNDED_OK", value: 0)
!10 = !DIEnumerator(name: "QUEUE_BOUNDED_FULL", value: 1)
!11 = !DIEnumerator(name: "QUEUE_BOUNDED_EMPTY", value: 2)
!12 = !DIEnumerator(name: "QUEUE_BOUNDED_AGAIN", value: 3)
!13 = !{!14, !19, !22, !23, !24, !29}
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsize_t", file: !15, line: 42, baseType: !16)
!15 = !DIFile(filename: "./include/vsync/vtypes.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "6ac6784bf37e03e28013e7eed706797e")
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !17, line: 46, baseType: !18)
!17 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!18 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !15, line: 36, baseType: !20)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !21, line: 90, baseType: !18)
!21 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !15, line: 34, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !26, line: 26, baseType: !27)
!26 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !28, line: 42, baseType: !7)
!28 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "run_info_t", file: !31, line: 42, baseType: !32)
!31 = !DIFile(filename: "./include/test/thread_launcher.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "30ea34619353fe641f60bde6259a2c36")
!32 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !31, line: 37, size: 256, elements: !33)
!33 = !{!34, !37, !38, !41}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "t", scope: !32, file: !31, line: 38, baseType: !35, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !36, line: 27, baseType: !18)
!36 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!37 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !32, file: !31, line: 39, baseType: !14, size: 64, offset: 64)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "assign_me_to_core", scope: !32, file: !31, line: 40, baseType: !39, size: 8, offset: 128)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !15, line: 43, baseType: !40)
!40 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "run_fun", scope: !32, file: !31, line: 41, baseType: !42, size: 64, offset: 192)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "thread_fun_t", file: !31, line: 34, baseType: !43)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!44 = !DISubroutineType(types: !45)
!45 = !{!22, !22}
!46 = !{!47, !53, !0}
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "g_buf", scope: !2, file: !49, line: 38, type: !50, isLocal: false, isDefinition: true)
!49 = !DIFile(filename: "test/queue/bounded_mpmc_check_full.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "3d7240dfa1c4978843ec3696fbbd43c8")
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 256, elements: !51)
!51 = !{!52}
!52 = !DISubrange(count: 4)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "g_queue", scope: !2, file: !49, line: 39, type: !55, isLocal: false, isDefinition: true)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "bounded_mpmc_t", file: !56, line: 39, baseType: !57)
!56 = !DIFile(filename: "./include/vsync/queue/bounded_mpmc.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "ae97e0b4a2e991e85ba75388249cbc94")
!57 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bounded_mpmc_s", file: !56, line: 30, size: 256, elements: !58)
!58 = !{!59, !65, !66, !67, !68, !70}
!59 = !DIDerivedType(tag: DW_TAG_member, name: "phead", scope: !57, file: !56, line: 31, baseType: !60, size: 32, align: 32)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !61, line: 62, baseType: !62)
!61 = !DIFile(filename: "./include/vsync/atomic/core.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1cc0657a82f0605ef67642f178a77e1c")
!62 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !61, line: 60, size: 32, align: 32, elements: !63)
!63 = !{!64}
!64 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !62, file: !61, line: 61, baseType: !24, size: 32)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "ptail", scope: !57, file: !56, line: 32, baseType: !60, size: 32, align: 32, offset: 32)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "chead", scope: !57, file: !56, line: 34, baseType: !60, size: 32, align: 32, offset: 64)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "ctail", scope: !57, file: !56, line: 35, baseType: !60, size: 32, align: 32, offset: 96)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "buf", scope: !57, file: !56, line: 37, baseType: !69, size: 64, offset: 128)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !57, file: !56, line: 38, baseType: !24, size: 32, offset: 192)
!71 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 256, elements: !51)
!72 = !{i32 7, !"Dwarf Version", i32 5}
!73 = !{i32 2, !"Debug Info Version", i32 3}
!74 = !{i32 1, !"wchar_size", i32 4}
!75 = !{i32 7, !"PIC Level", i32 2}
!76 = !{i32 7, !"PIE Level", i32 2}
!77 = !{i32 7, !"uwtable", i32 1}
!78 = !{i32 7, !"frame-pointer", i32 2}
!79 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!80 = distinct !DISubprogram(name: "sched_yield", scope: !49, file: !49, line: 22, type: !81, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!81 = !DISubroutineType(types: !82)
!82 = !{!83}
!83 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!84 = !{}
!85 = !DILocation(line: 24, column: 2, scope: !80)
!86 = distinct !DISubprogram(name: "writer", scope: !49, file: !49, line: 43, type: !44, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!87 = !DILocalVariable(name: "arg", arg: 1, scope: !86, file: !49, line: 43, type: !22)
!88 = !DILocation(line: 0, scope: !86)
!89 = !DILocation(line: 45, column: 25, scope: !86)
!90 = !DILocalVariable(name: "tid", scope: !86, file: !49, line: 45, type: !14)
!91 = !DILocalVariable(name: "xbo", scope: !86, file: !49, line: 47, type: !92)
!92 = !DIDerivedType(tag: DW_TAG_typedef, name: "xbo_t", file: !93, line: 48, baseType: !94)
!93 = !DIFile(filename: "./include/vsync/utils/xbo.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "f587429cfeb993858d7ede0d279131f0")
!94 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xbo_s", file: !93, line: 44, size: 128, elements: !95)
!95 = !{!96, !97, !98, !99}
!96 = !DIDerivedType(tag: DW_TAG_member, name: "min", scope: !94, file: !93, line: 45, baseType: !24, size: 32)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "max", scope: !94, file: !93, line: 45, baseType: !24, size: 32, offset: 32)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "factor", scope: !94, file: !93, line: 46, baseType: !24, size: 32, offset: 64)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !94, file: !93, line: 47, baseType: !24, size: 32, offset: 96)
!100 = !DILocation(line: 47, column: 8, scope: !86)
!101 = !DILocation(line: 48, column: 2, scope: !86)
!102 = !DILocalVariable(name: "i", scope: !103, file: !49, line: 50, type: !14)
!103 = distinct !DILexicalBlock(scope: !86, file: !49, line: 50, column: 2)
!104 = !DILocation(line: 0, scope: !103)
!105 = !DILocation(line: 51, column: 21, scope: !106)
!106 = distinct !DILexicalBlock(scope: !107, file: !49, line: 50, column: 39)
!107 = distinct !DILexicalBlock(scope: !103, file: !49, line: 50, column: 2)
!108 = !DILocalVariable(name: "idx", scope: !106, file: !49, line: 51, type: !14)
!109 = !DILocation(line: 0, scope: !106)
!110 = !DILocation(line: 52, column: 20, scope: !106)
!111 = !DILocation(line: 52, column: 51, scope: !106)
!112 = !DILocation(line: 52, column: 3, scope: !106)
!113 = !DILocation(line: 52, column: 14, scope: !106)
!114 = !DILocation(line: 53, column: 3, scope: !106)
!115 = !DILocation(line: 53, column: 37, scope: !106)
!116 = !DILocation(line: 53, column: 10, scope: !106)
!117 = !DILocation(line: 53, column: 50, scope: !106)
!118 = !DILocation(line: 54, column: 4, scope: !119)
!119 = distinct !DILexicalBlock(scope: !106, file: !49, line: 53, column: 71)
!120 = distinct !{!120, !114, !121, !122}
!121 = !DILocation(line: 55, column: 3, scope: !106)
!122 = !{!"llvm.loop.mustprogress"}
!123 = !DILocation(line: 56, column: 3, scope: !106)
!124 = !DILocation(line: 51, column: 30, scope: !106)
!125 = !DILocation(line: 58, column: 2, scope: !86)
!126 = distinct !DISubprogram(name: "xbo_init", scope: !93, file: !93, line: 64, type: !127, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!127 = !DISubroutineType(types: !128)
!128 = !{null, !129, !24, !24, !24}
!129 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !92, size: 64)
!130 = !DILocalVariable(name: "xbo", arg: 1, scope: !126, file: !93, line: 64, type: !129)
!131 = !DILocation(line: 0, scope: !126)
!132 = !DILocalVariable(name: "min", arg: 2, scope: !126, file: !93, line: 64, type: !24)
!133 = !DILocalVariable(name: "max", arg: 3, scope: !126, file: !93, line: 64, type: !24)
!134 = !DILocalVariable(name: "factor", arg: 4, scope: !126, file: !93, line: 64, type: !24)
!135 = !DILocation(line: 71, column: 1, scope: !126)
!136 = distinct !DISubprogram(name: "bounded_mpmc_enq", scope: !56, file: !56, line: 73, type: !137, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!137 = !DISubroutineType(types: !138)
!138 = !{!139, !140, !22}
!139 = !DIDerivedType(tag: DW_TAG_typedef, name: "bounded_ret_t", file: !6, line: 13, baseType: !5)
!140 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !55, size: 64)
!141 = !DILocalVariable(name: "q", arg: 1, scope: !136, file: !56, line: 73, type: !140)
!142 = !DILocation(line: 0, scope: !136)
!143 = !DILocalVariable(name: "v", arg: 2, scope: !136, file: !56, line: 73, type: !22)
!144 = !DILocation(line: 78, column: 32, scope: !136)
!145 = !DILocation(line: 78, column: 9, scope: !136)
!146 = !DILocalVariable(name: "curr", scope: !136, file: !56, line: 75, type: !24)
!147 = !DILocation(line: 79, column: 36, scope: !148)
!148 = distinct !DILexicalBlock(scope: !136, file: !56, line: 79, column: 6)
!149 = !DILocation(line: 79, column: 13, scope: !148)
!150 = !DILocation(line: 79, column: 11, scope: !148)
!151 = !DILocation(line: 79, column: 49, scope: !148)
!152 = !DILocation(line: 79, column: 43, scope: !148)
!153 = !DILocation(line: 79, column: 6, scope: !136)
!154 = !DILocation(line: 82, column: 14, scope: !136)
!155 = !DILocalVariable(name: "next", scope: !136, file: !56, line: 75, type: !24)
!156 = !DILocation(line: 83, column: 6, scope: !157)
!157 = distinct !DILexicalBlock(scope: !136, file: !56, line: 83, column: 6)
!158 = !DILocation(line: 83, column: 51, scope: !157)
!159 = !DILocation(line: 83, column: 6, scope: !136)
!160 = !DILocation(line: 87, column: 5, scope: !136)
!161 = !DILocation(line: 87, column: 19, scope: !136)
!162 = !DILocation(line: 87, column: 14, scope: !136)
!163 = !DILocation(line: 87, column: 2, scope: !136)
!164 = !DILocation(line: 87, column: 25, scope: !136)
!165 = !DILocation(line: 90, column: 29, scope: !136)
!166 = !DILocation(line: 90, column: 2, scope: !136)
!167 = !DILocation(line: 91, column: 2, scope: !136)
!168 = !DILocation(line: 93, column: 2, scope: !136)
!169 = !DILocation(line: 94, column: 1, scope: !136)
!170 = distinct !DISubprogram(name: "xbo_backoff", scope: !93, file: !93, line: 83, type: !171, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!171 = !DISubroutineType(types: !172)
!172 = !{null, !129, !173, !173}
!173 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !174, size: 64)
!174 = !DIDerivedType(tag: DW_TAG_typedef, name: "xbo_cb", file: !93, line: 42, baseType: !81)
!175 = !DILocalVariable(name: "xbo", arg: 1, scope: !170, file: !93, line: 83, type: !129)
!176 = !DILocation(line: 0, scope: !170)
!177 = !DILocalVariable(name: "nop", arg: 2, scope: !170, file: !93, line: 83, type: !173)
!178 = !DILocalVariable(name: "cb", arg: 3, scope: !170, file: !93, line: 83, type: !173)
!179 = !DILocation(line: 96, column: 1, scope: !170)
!180 = distinct !DISubprogram(name: "xbo_nop", scope: !93, file: !93, line: 113, type: !81, scopeLine: 114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!181 = !DILocalVariable(name: "k", scope: !180, file: !93, line: 115, type: !182)
!182 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !83)
!183 = !DILocation(line: 115, column: 15, scope: !180)
!184 = !DILocation(line: 116, column: 9, scope: !180)
!185 = !DILocation(line: 116, column: 2, scope: !180)
!186 = distinct !DISubprogram(name: "xbo_reset", scope: !93, file: !93, line: 104, type: !187, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!187 = !DISubroutineType(types: !188)
!188 = !{null, !129}
!189 = !DILocalVariable(name: "xbo", arg: 1, scope: !186, file: !93, line: 104, type: !129)
!190 = !DILocation(line: 0, scope: !186)
!191 = !DILocation(line: 109, column: 1, scope: !186)
!192 = distinct !DISubprogram(name: "main", scope: !49, file: !49, line: 62, type: !81, scopeLine: 63, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!193 = !DILocalVariable(name: "ret", scope: !192, file: !49, line: 64, type: !139)
!194 = !DILocation(line: 0, scope: !192)
!195 = !DILocation(line: 66, column: 2, scope: !192)
!196 = !DILocation(line: 68, column: 2, scope: !192)
!197 = !DILocalVariable(name: "r", scope: !192, file: !49, line: 70, type: !22)
!198 = !DILocation(line: 70, column: 8, scope: !192)
!199 = !DILocation(line: 72, column: 8, scope: !192)
!200 = !DILocation(line: 73, column: 2, scope: !201)
!201 = distinct !DILexicalBlock(scope: !202, file: !49, line: 73, column: 2)
!202 = distinct !DILexicalBlock(scope: !192, file: !49, line: 73, column: 2)
!203 = !DILocation(line: 73, column: 2, scope: !202)
!204 = !DILocation(line: 76, column: 34, scope: !192)
!205 = !DILocation(line: 76, column: 23, scope: !192)
!206 = !DILocation(line: 76, column: 21, scope: !192)
!207 = !DILocalVariable(name: "dequeued", scope: !192, file: !49, line: 76, type: !14)
!208 = !DILocation(line: 78, column: 2, scope: !209)
!209 = distinct !DILexicalBlock(scope: !210, file: !49, line: 78, column: 2)
!210 = distinct !DILexicalBlock(scope: !192, file: !49, line: 78, column: 2)
!211 = !DILocation(line: 78, column: 2, scope: !210)
!212 = !DILocation(line: 79, column: 2, scope: !213)
!213 = distinct !DILexicalBlock(scope: !214, file: !49, line: 79, column: 2)
!214 = distinct !DILexicalBlock(scope: !192, file: !49, line: 79, column: 2)
!215 = !DILocation(line: 79, column: 2, scope: !214)
!216 = !DILocation(line: 82, column: 35, scope: !192)
!217 = !DILocation(line: 82, column: 8, scope: !192)
!218 = !DILocation(line: 83, column: 2, scope: !219)
!219 = distinct !DILexicalBlock(scope: !220, file: !49, line: 83, column: 2)
!220 = distinct !DILexicalBlock(scope: !192, file: !49, line: 83, column: 2)
!221 = !DILocation(line: 83, column: 2, scope: !220)
!222 = !DILocation(line: 86, column: 8, scope: !192)
!223 = !DILocation(line: 87, column: 2, scope: !224)
!224 = distinct !DILexicalBlock(scope: !225, file: !49, line: 87, column: 2)
!225 = distinct !DILexicalBlock(scope: !192, file: !49, line: 87, column: 2)
!226 = !DILocation(line: 87, column: 2, scope: !225)
!227 = !DILocation(line: 91, column: 2, scope: !192)
!228 = distinct !DISubprogram(name: "bounded_mpmc_init", scope: !56, file: !56, line: 49, type: !229, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!229 = !DISubroutineType(types: !230)
!230 = !{null, !140, !69, !24}
!231 = !DILocalVariable(name: "q", arg: 1, scope: !228, file: !56, line: 49, type: !140)
!232 = !DILocation(line: 0, scope: !228)
!233 = !DILocalVariable(name: "b", arg: 2, scope: !228, file: !56, line: 49, type: !69)
!234 = !DILocalVariable(name: "s", arg: 3, scope: !228, file: !56, line: 49, type: !24)
!235 = !DILocation(line: 51, column: 2, scope: !236)
!236 = distinct !DILexicalBlock(scope: !237, file: !56, line: 51, column: 2)
!237 = distinct !DILexicalBlock(scope: !228, file: !56, line: 51, column: 2)
!238 = !DILocation(line: 52, column: 2, scope: !239)
!239 = distinct !DILexicalBlock(scope: !240, file: !56, line: 52, column: 2)
!240 = distinct !DILexicalBlock(scope: !228, file: !56, line: 52, column: 2)
!241 = !DILocation(line: 54, column: 5, scope: !228)
!242 = !DILocation(line: 54, column: 9, scope: !228)
!243 = !DILocation(line: 55, column: 5, scope: !228)
!244 = !DILocation(line: 55, column: 10, scope: !228)
!245 = !DILocation(line: 56, column: 21, scope: !228)
!246 = !DILocation(line: 56, column: 2, scope: !228)
!247 = !DILocation(line: 57, column: 21, scope: !228)
!248 = !DILocation(line: 57, column: 2, scope: !228)
!249 = !DILocation(line: 58, column: 21, scope: !228)
!250 = !DILocation(line: 58, column: 2, scope: !228)
!251 = !DILocation(line: 59, column: 21, scope: !228)
!252 = !DILocation(line: 59, column: 2, scope: !228)
!253 = !DILocation(line: 60, column: 1, scope: !228)
!254 = distinct !DISubprogram(name: "launch_threads", scope: !31, file: !31, line: 115, type: !255, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!255 = !DISubroutineType(types: !256)
!256 = !{null, !14, !42}
!257 = !DILocalVariable(name: "thread_count", arg: 1, scope: !254, file: !31, line: 115, type: !14)
!258 = !DILocation(line: 0, scope: !254)
!259 = !DILocalVariable(name: "fun", arg: 2, scope: !254, file: !31, line: 115, type: !42)
!260 = !DILocation(line: 117, column: 50, scope: !254)
!261 = !DILocation(line: 117, column: 24, scope: !254)
!262 = !DILocalVariable(name: "threads", scope: !254, file: !31, line: 117, type: !29)
!263 = !DILocation(line: 119, column: 2, scope: !254)
!264 = !DILocation(line: 121, column: 2, scope: !254)
!265 = !DILocation(line: 123, column: 2, scope: !254)
!266 = !DILocation(line: 124, column: 1, scope: !254)
!267 = distinct !DISubprogram(name: "bounded_mpmc_deq", scope: !56, file: !56, line: 108, type: !268, scopeLine: 109, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!268 = !DISubroutineType(types: !269)
!269 = !{!139, !140, !69}
!270 = !DILocalVariable(name: "q", arg: 1, scope: !267, file: !56, line: 108, type: !140)
!271 = !DILocation(line: 0, scope: !267)
!272 = !DILocalVariable(name: "v", arg: 2, scope: !267, file: !56, line: 108, type: !69)
!273 = !DILocation(line: 113, column: 32, scope: !267)
!274 = !DILocation(line: 113, column: 9, scope: !267)
!275 = !DILocalVariable(name: "curr", scope: !267, file: !56, line: 110, type: !24)
!276 = !DILocation(line: 114, column: 14, scope: !267)
!277 = !DILocalVariable(name: "next", scope: !267, file: !56, line: 110, type: !24)
!278 = !DILocation(line: 115, column: 37, scope: !279)
!279 = distinct !DILexicalBlock(scope: !267, file: !56, line: 115, column: 6)
!280 = !DILocation(line: 115, column: 14, scope: !279)
!281 = !DILocation(line: 115, column: 11, scope: !279)
!282 = !DILocation(line: 115, column: 6, scope: !267)
!283 = !DILocation(line: 118, column: 6, scope: !284)
!284 = distinct !DILexicalBlock(scope: !267, file: !56, line: 118, column: 6)
!285 = !DILocation(line: 118, column: 51, scope: !284)
!286 = !DILocation(line: 118, column: 6, scope: !267)
!287 = !DILocation(line: 122, column: 10, scope: !267)
!288 = !DILocation(line: 122, column: 24, scope: !267)
!289 = !DILocation(line: 122, column: 19, scope: !267)
!290 = !DILocation(line: 122, column: 7, scope: !267)
!291 = !DILocation(line: 122, column: 5, scope: !267)
!292 = !DILocation(line: 125, column: 29, scope: !267)
!293 = !DILocation(line: 125, column: 2, scope: !267)
!294 = !DILocation(line: 126, column: 2, scope: !267)
!295 = !DILocation(line: 128, column: 2, scope: !267)
!296 = !DILocation(line: 129, column: 1, scope: !267)
!297 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !298, file: !298, line: 178, type: !299, scopeLine: 179, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!298 = !DIFile(filename: "./include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "31d9a9647b315cadb2f817a7c8e98ecf")
!299 = !DISubroutineType(types: !300)
!300 = !{!24, !301}
!301 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!302 = !DILocalVariable(name: "a", arg: 1, scope: !297, file: !298, line: 178, type: !301)
!303 = !DILocation(line: 0, scope: !297)
!304 = !DILocation(line: 180, column: 2, scope: !297)
!305 = !{i64 2148055197}
!306 = !DILocation(line: 182, column: 7, scope: !297)
!307 = !DILocation(line: 181, column: 29, scope: !297)
!308 = !DILocalVariable(name: "tmp", scope: !297, file: !298, line: 181, type: !24)
!309 = !DILocation(line: 183, column: 2, scope: !297)
!310 = !{i64 2148055243}
!311 = !DILocation(line: 184, column: 2, scope: !297)
!312 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !298, file: !298, line: 193, type: !299, scopeLine: 194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!313 = !DILocalVariable(name: "a", arg: 1, scope: !312, file: !298, line: 193, type: !301)
!314 = !DILocation(line: 0, scope: !312)
!315 = !DILocation(line: 195, column: 2, scope: !312)
!316 = !{i64 2148055281}
!317 = !DILocation(line: 197, column: 7, scope: !312)
!318 = !DILocation(line: 196, column: 29, scope: !312)
!319 = !DILocalVariable(name: "tmp", scope: !312, file: !298, line: 196, type: !24)
!320 = !DILocation(line: 198, column: 2, scope: !312)
!321 = !{i64 2148055327}
!322 = !DILocation(line: 199, column: 2, scope: !312)
!323 = distinct !DISubprogram(name: "vatomic32_cmpxchg_rel", scope: !298, file: !298, line: 1119, type: !324, scopeLine: 1120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!324 = !DISubroutineType(types: !325)
!325 = !{!24, !301, !24, !24}
!326 = !DILocalVariable(name: "a", arg: 1, scope: !323, file: !298, line: 1119, type: !301)
!327 = !DILocation(line: 0, scope: !323)
!328 = !DILocalVariable(name: "e", arg: 2, scope: !323, file: !298, line: 1119, type: !24)
!329 = !DILocalVariable(name: "v", arg: 3, scope: !323, file: !298, line: 1119, type: !24)
!330 = !DILocalVariable(name: "exp", scope: !323, file: !298, line: 1121, type: !24)
!331 = !DILocation(line: 1122, column: 2, scope: !323)
!332 = !{i64 2148060569}
!333 = !DILocation(line: 1123, column: 34, scope: !323)
!334 = !DILocation(line: 1123, column: 2, scope: !323)
!335 = !DILocation(line: 1126, column: 2, scope: !323)
!336 = !{i64 2148060623}
!337 = !DILocation(line: 1127, column: 2, scope: !323)
!338 = distinct !DISubprogram(name: "vatomic32_await_eq_acq", scope: !339, file: !339, line: 4389, type: !340, scopeLine: 4390, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!339 = !DIFile(filename: "./include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "bfc5d50ad810da3af0d582a48b47498f")
!340 = !DISubroutineType(types: !341)
!341 = !{!24, !301, !24}
!342 = !DILocalVariable(name: "a", arg: 1, scope: !338, file: !339, line: 4389, type: !301)
!343 = !DILocation(line: 0, scope: !338)
!344 = !DILocalVariable(name: "c", arg: 2, scope: !338, file: !339, line: 4389, type: !24)
!345 = !DILocalVariable(name: "ret", scope: !338, file: !339, line: 4391, type: !24)
!346 = !DILocalVariable(name: "o", scope: !338, file: !339, line: 4392, type: !24)
!347 = !DILocation(line: 4393, column: 2, scope: !338)
!348 = distinct !{!348, !347, !349, !122}
!349 = !DILocation(line: 4396, column: 2, scope: !338)
!350 = !DILocation(line: 4397, column: 2, scope: !338)
!351 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !298, file: !298, line: 438, type: !352, scopeLine: 439, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!352 = !DISubroutineType(types: !353)
!353 = !{null, !301, !24}
!354 = !DILocalVariable(name: "a", arg: 1, scope: !351, file: !298, line: 438, type: !301)
!355 = !DILocation(line: 0, scope: !351)
!356 = !DILocalVariable(name: "v", arg: 2, scope: !351, file: !298, line: 438, type: !24)
!357 = !DILocation(line: 440, column: 2, scope: !351)
!358 = !{i64 2148056709}
!359 = !DILocation(line: 441, column: 23, scope: !351)
!360 = !DILocation(line: 441, column: 2, scope: !351)
!361 = !DILocation(line: 442, column: 2, scope: !351)
!362 = !{i64 2148056755}
!363 = !DILocation(line: 443, column: 1, scope: !351)
!364 = distinct !DISubprogram(name: "vatomic32_init", scope: !339, file: !339, line: 4189, type: !352, scopeLine: 4190, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!365 = !DILocalVariable(name: "a", arg: 1, scope: !364, file: !339, line: 4189, type: !301)
!366 = !DILocation(line: 0, scope: !364)
!367 = !DILocalVariable(name: "v", arg: 2, scope: !364, file: !339, line: 4189, type: !24)
!368 = !DILocation(line: 4191, column: 2, scope: !364)
!369 = !DILocation(line: 4192, column: 1, scope: !364)
!370 = distinct !DISubprogram(name: "vatomic32_write", scope: !298, file: !298, line: 425, type: !352, scopeLine: 426, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!371 = !DILocalVariable(name: "a", arg: 1, scope: !370, file: !298, line: 425, type: !301)
!372 = !DILocation(line: 0, scope: !370)
!373 = !DILocalVariable(name: "v", arg: 2, scope: !370, file: !298, line: 425, type: !24)
!374 = !DILocation(line: 427, column: 2, scope: !370)
!375 = !{i64 2148056625}
!376 = !DILocation(line: 428, column: 23, scope: !370)
!377 = !DILocation(line: 428, column: 2, scope: !370)
!378 = !DILocation(line: 429, column: 2, scope: !370)
!379 = !{i64 2148056671}
!380 = !DILocation(line: 430, column: 1, scope: !370)
!381 = distinct !DISubprogram(name: "create_threads", scope: !31, file: !31, line: 87, type: !382, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!382 = !DISubroutineType(types: !383)
!383 = !{null, !29, !14, !42, !39}
!384 = !DILocalVariable(name: "threads", arg: 1, scope: !381, file: !31, line: 87, type: !29)
!385 = !DILocation(line: 0, scope: !381)
!386 = !DILocalVariable(name: "num_threads", arg: 2, scope: !381, file: !31, line: 87, type: !14)
!387 = !DILocalVariable(name: "fun", arg: 3, scope: !381, file: !31, line: 87, type: !42)
!388 = !DILocalVariable(name: "bind", arg: 4, scope: !381, file: !31, line: 88, type: !39)
!389 = !DILocalVariable(name: "i", scope: !381, file: !31, line: 90, type: !14)
!390 = !DILocation(line: 91, column: 7, scope: !391)
!391 = distinct !DILexicalBlock(scope: !381, file: !31, line: 91, column: 2)
!392 = !DILocation(line: 0, scope: !391)
!393 = !DILocation(line: 91, column: 16, scope: !394)
!394 = distinct !DILexicalBlock(scope: !391, file: !31, line: 91, column: 2)
!395 = !DILocation(line: 91, column: 2, scope: !391)
!396 = !DILocation(line: 92, column: 3, scope: !397)
!397 = distinct !DILexicalBlock(scope: !394, file: !31, line: 91, column: 36)
!398 = !DILocation(line: 92, column: 14, scope: !397)
!399 = !DILocation(line: 92, column: 21, scope: !397)
!400 = !DILocation(line: 93, column: 14, scope: !397)
!401 = !DILocation(line: 93, column: 25, scope: !397)
!402 = !DILocation(line: 94, column: 14, scope: !397)
!403 = !DILocation(line: 94, column: 32, scope: !397)
!404 = !DILocation(line: 95, column: 30, scope: !397)
!405 = !DILocation(line: 95, column: 48, scope: !397)
!406 = !DILocation(line: 95, column: 3, scope: !397)
!407 = !DILocation(line: 91, column: 32, scope: !394)
!408 = !DILocation(line: 91, column: 2, scope: !394)
!409 = distinct !{!409, !395, !410, !122}
!410 = !DILocation(line: 96, column: 2, scope: !391)
!411 = !DILocation(line: 98, column: 1, scope: !381)
!412 = distinct !DISubprogram(name: "await_threads", scope: !31, file: !31, line: 101, type: !413, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!413 = !DISubroutineType(types: !414)
!414 = !{null, !29, !14}
!415 = !DILocalVariable(name: "threads", arg: 1, scope: !412, file: !31, line: 101, type: !29)
!416 = !DILocation(line: 0, scope: !412)
!417 = !DILocalVariable(name: "num_threads", arg: 2, scope: !412, file: !31, line: 101, type: !14)
!418 = !DILocalVariable(name: "i", scope: !412, file: !31, line: 103, type: !14)
!419 = !DILocation(line: 104, column: 7, scope: !420)
!420 = distinct !DILexicalBlock(scope: !412, file: !31, line: 104, column: 2)
!421 = !DILocation(line: 0, scope: !420)
!422 = !DILocation(line: 104, column: 16, scope: !423)
!423 = distinct !DILexicalBlock(scope: !420, file: !31, line: 104, column: 2)
!424 = !DILocation(line: 104, column: 2, scope: !420)
!425 = !DILocation(line: 105, column: 16, scope: !426)
!426 = distinct !DILexicalBlock(scope: !423, file: !31, line: 104, column: 36)
!427 = !DILocation(line: 105, column: 27, scope: !426)
!428 = !DILocation(line: 105, column: 3, scope: !426)
!429 = !DILocation(line: 104, column: 32, scope: !423)
!430 = !DILocation(line: 104, column: 2, scope: !423)
!431 = distinct !{!431, !424, !432, !122}
!432 = !DILocation(line: 106, column: 2, scope: !420)
!433 = !DILocation(line: 107, column: 1, scope: !412)
!434 = distinct !DISubprogram(name: "common_run", scope: !31, file: !31, line: 47, type: !44, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!435 = !DILocalVariable(name: "args", arg: 1, scope: !434, file: !31, line: 47, type: !22)
!436 = !DILocation(line: 0, scope: !434)
!437 = !DILocation(line: 49, column: 25, scope: !434)
!438 = !DILocalVariable(name: "run_info", scope: !434, file: !31, line: 49, type: !29)
!439 = !DILocation(line: 51, column: 16, scope: !440)
!440 = distinct !DILexicalBlock(scope: !434, file: !31, line: 51, column: 6)
!441 = !DILocation(line: 51, column: 6, scope: !434)
!442 = !DILocation(line: 52, column: 30, scope: !440)
!443 = !DILocation(line: 52, column: 3, scope: !440)
!444 = !DILocation(line: 56, column: 19, scope: !434)
!445 = !DILocation(line: 56, column: 45, scope: !434)
!446 = !DILocation(line: 56, column: 27, scope: !434)
!447 = !DILocation(line: 56, column: 9, scope: !434)
!448 = !DILocation(line: 56, column: 2, scope: !434)
!449 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !31, file: !31, line: 65, type: !450, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!450 = !DISubroutineType(types: !451)
!451 = !{null, !14}
!452 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !449, file: !31, line: 65, type: !14)
!453 = !DILocation(line: 0, scope: !449)
!454 = !DILocation(line: 84, column: 1, scope: !449)
!455 = distinct !DISubprogram(name: "vatomic32_await_eq_rlx", scope: !339, file: !339, line: 4406, type: !340, scopeLine: 4407, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!456 = !DILocalVariable(name: "a", arg: 1, scope: !455, file: !339, line: 4406, type: !301)
!457 = !DILocation(line: 0, scope: !455)
!458 = !DILocalVariable(name: "c", arg: 2, scope: !455, file: !339, line: 4406, type: !24)
!459 = !DILocalVariable(name: "ret", scope: !455, file: !339, line: 4408, type: !24)
!460 = !DILocalVariable(name: "o", scope: !455, file: !339, line: 4409, type: !24)
!461 = !DILocation(line: 4410, column: 2, scope: !455)
!462 = distinct !{!462, !461, !463, !122}
!463 = !DILocation(line: 4413, column: 2, scope: !455)
!464 = !DILocation(line: 4414, column: 2, scope: !455)
