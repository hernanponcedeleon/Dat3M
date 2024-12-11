; ModuleID = '/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/unbounded_queue_verify.c'
source_filename = "/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/unbounded_queue_verify.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.vatomic64_s = type { i64 }
%struct.vqueue_ub_s = type { %union.pthread_mutex_t, %union.pthread_mutex_t, %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%struct.vqueue_ub_node_s = type { i8*, %struct.vatomicptr_s }
%struct.vatomicptr_s = type { i8* }
%struct.locked_trace_s = type { %struct.trace_s, %union.pthread_mutex_t }
%struct.trace_s = type { %struct.trace_unit_s*, i64, i64, i8 }
%struct.trace_unit_s = type { i64, i64 }
%struct.data_s = type { i64, i8 }
%struct.run_info_t = type { i64, i64, i8, i8* (i8*)* }
%union.pthread_attr_t = type { i64, [48 x i8] }
%union.pthread_mutexattr_t = type { i32 }
%struct.smr_none_retire_info_t = type { %struct.smr_node_s*, void (%struct.smr_node_s*, i8*)*, i8* }
%struct.smr_node_s = type { %struct.smr_node_core_s, i32, void (%struct.smr_node_s*, i8*)*, i8* }
%struct.smr_node_core_s = type { %struct.smr_node_core_s* }

@_g_vmem_alloc_count = dso_local global %struct.vatomic64_s zeroinitializer, align 8, !dbg !0
@_g_vmem_free_count = dso_local global %struct.vatomic64_s zeroinitializer, align 8, !dbg !77
@g_len = dso_local global i64 0, align 8, !dbg !89
@deq_succeeded = dso_local global i8 0, align 1, !dbg !92
@.str = private unnamed_addr constant [5 x i8] c"node\00", align 1
@.str.1 = private unnamed_addr constant [78 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/test_case_6.h\00", align 1
@__PRETTY_FUNCTION__.t1 = private unnamed_addr constant [17 x i8] c"void t1(vsize_t)\00", align 1
@.str.2 = private unnamed_addr constant [15 x i8] c"node->key == 1\00", align 1
@.str.3 = private unnamed_addr constant [15 x i8] c"node->key == 2\00", align 1
@.str.4 = private unnamed_addr constant [11 x i8] c"g_len == 2\00", align 1
@__PRETTY_FUNCTION__.verify = private unnamed_addr constant [18 x i8] c"void verify(void)\00", align 1
@g_queue = dso_local global %struct.vqueue_ub_s zeroinitializer, align 8, !dbg !148
@.str.5 = private unnamed_addr constant [15 x i8] c"vmem_no_leak()\00", align 1
@.str.6 = private unnamed_addr constant [89 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/unbounded_queue_verify.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c"data\00", align 1
@__PRETTY_FUNCTION__.get_final_state = private unnamed_addr constant [29 x i8] c"void get_final_state(void *)\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"g_len < 5\00", align 1
@g_final_state = dso_local global [5 x i64] zeroinitializer, align 16, !dbg !160
@.str.9 = private unnamed_addr constant [39 x i8] c"currently only 3 threads are supported\00", align 1
@.str.10 = private unnamed_addr constant [41 x i8] c"\22currently only 3 threads are supported\22\00", align 1
@__PRETTY_FUNCTION__.run = private unnamed_addr constant [18 x i8] c"void *run(void *)\00", align 1
@global_trace = dso_local global %struct.locked_trace_s zeroinitializer, align 8, !dbg !95
@.str.11 = private unnamed_addr constant [6 x i8] c"trace\00", align 1
@.str.12 = private unnamed_addr constant [64 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/locked_trace.h\00", align 1
@__PRETTY_FUNCTION__.locked_trace_init = private unnamed_addr constant [50 x i8] c"void locked_trace_init(locked_trace_t *, vsize_t)\00", align 1
@.str.13 = private unnamed_addr constant [65 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/trace_manager.h\00", align 1
@__PRETTY_FUNCTION__.trace_init = private unnamed_addr constant [36 x i8] c"void trace_init(trace_t *, vsize_t)\00", align 1
@.str.14 = private unnamed_addr constant [25 x i8] c"0 && \22allocation failed\22\00", align 1
@.str.15 = private unnamed_addr constant [97 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/include/test/queue/ub/queue_interface.h\00", align 1
@__PRETTY_FUNCTION__.queue_destroy = private unnamed_addr constant [30 x i8] c"void queue_destroy(queue_t *)\00", align 1
@.str.16 = private unnamed_addr constant [9 x i8] c"val == 0\00", align 1
@.str.17 = private unnamed_addr constant [101 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/include/vsync/queue/unbounded_queue_total.h\00", align 1
@__PRETTY_FUNCTION__.queue_lock_acquire = private unnamed_addr constant [40 x i8] c"void queue_lock_acquire(queue_lock_t *)\00", align 1
@__PRETTY_FUNCTION__.queue_lock_release = private unnamed_addr constant [40 x i8] c"void queue_lock_release(queue_lock_t *)\00", align 1
@__PRETTY_FUNCTION__.trace_verify = private unnamed_addr constant [51 x i8] c"vbool_t trace_verify(trace_t *, trace_verify_unit)\00", align 1
@.str.18 = private unnamed_addr constant [19 x i8] c"trace->initialized\00", align 1
@.str.19 = private unnamed_addr constant [11 x i8] c"verify_fun\00", align 1
@__PRETTY_FUNCTION__.trace_destroy = private unnamed_addr constant [30 x i8] c"void trace_destroy(trace_t *)\00", align 1
@.str.20 = private unnamed_addr constant [5 x i8] c"unit\00", align 1
@.str.21 = private unnamed_addr constant [70 x i8] c"/home/stefano/huawei/libvsync/memory/smr/include/test/smr/ismr_none.h\00", align 1
@__PRETTY_FUNCTION__._ismr_none_destroy_all_cb = private unnamed_addr constant [50 x i8] c"vbool_t _ismr_none_destroy_all_cb(trace_unit_t *)\00", align 1
@__PRETTY_FUNCTION__.queue_enq = private unnamed_addr constant [52 x i8] c"void queue_enq(vsize_t, queue_t *, vuint64_t, char)\00", align 1
@.str.22 = private unnamed_addr constant [63 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/vmem_stdlib.h\00", align 1
@__PRETTY_FUNCTION__.vmem_malloc = private unnamed_addr constant [27 x i8] c"void *vmem_malloc(vsize_t)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @t1(i64 noundef %0) #0 !dbg !173 {
  %2 = alloca i64, align 8
  %3 = alloca %struct.data_s*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !177, metadata !DIExpression()), !dbg !178
  call void @llvm.dbg.declare(metadata %struct.data_s** %3, metadata !179, metadata !DIExpression()), !dbg !186
  store %struct.data_s* null, %struct.data_s** %3, align 8, !dbg !186
  %4 = load i64, i64* %2, align 8, !dbg !187
  call void @enq(i64 noundef %4, i64 noundef 3, i8 noundef signext 65), !dbg !188
  %5 = load i64, i64* %2, align 8, !dbg !189
  %6 = call %struct.data_s* @deq(i64 noundef %5), !dbg !190
  store %struct.data_s* %6, %struct.data_s** %3, align 8, !dbg !191
  %7 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !192
  %8 = icmp ne %struct.data_s* %7, null, !dbg !192
  br i1 %8, label %9, label %10, !dbg !195

9:                                                ; preds = %1
  br label %11, !dbg !195

10:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 22, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t1, i64 0, i64 0)) #5, !dbg !192
  unreachable, !dbg !192

11:                                               ; preds = %9
  %12 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !196
  %13 = getelementptr inbounds %struct.data_s, %struct.data_s* %12, i32 0, i32 0, !dbg !196
  %14 = load i64, i64* %13, align 8, !dbg !196
  %15 = icmp eq i64 %14, 1, !dbg !196
  br i1 %15, label %16, label %17, !dbg !199

16:                                               ; preds = %11
  br label %18, !dbg !199

17:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 23, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t1, i64 0, i64 0)) #5, !dbg !196
  unreachable, !dbg !196

18:                                               ; preds = %16
  %19 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !200
  %20 = bitcast %struct.data_s* %19 to i8*, !dbg !200
  call void @free(i8* noundef %20) #6, !dbg !201
  %21 = load i64, i64* %2, align 8, !dbg !202
  %22 = call %struct.data_s* @deq(i64 noundef %21), !dbg !203
  store %struct.data_s* %22, %struct.data_s** %3, align 8, !dbg !204
  %23 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !205
  %24 = icmp ne %struct.data_s* %23, null, !dbg !205
  br i1 %24, label %25, label %26, !dbg !208

25:                                               ; preds = %18
  br label %27, !dbg !208

26:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 27, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t1, i64 0, i64 0)) #5, !dbg !205
  unreachable, !dbg !205

27:                                               ; preds = %25
  %28 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !209
  %29 = getelementptr inbounds %struct.data_s, %struct.data_s* %28, i32 0, i32 0, !dbg !209
  %30 = load i64, i64* %29, align 8, !dbg !209
  %31 = icmp eq i64 %30, 2, !dbg !209
  br i1 %31, label %32, label %33, !dbg !212

32:                                               ; preds = %27
  br label %34, !dbg !212

33:                                               ; preds = %27
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 28, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t1, i64 0, i64 0)) #5, !dbg !209
  unreachable, !dbg !209

34:                                               ; preds = %32
  %35 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !213
  %36 = bitcast %struct.data_s* %35 to i8*, !dbg !213
  call void @free(i8* noundef %36) #6, !dbg !214
  ret void, !dbg !215
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @enq(i64 noundef %0, i64 noundef %1, i8 noundef signext %2) #0 !dbg !216 {
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i8, align 1
  store i64 %0, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !219, metadata !DIExpression()), !dbg !220
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !221, metadata !DIExpression()), !dbg !222
  store i8 %2, i8* %6, align 1
  call void @llvm.dbg.declare(metadata i8* %6, metadata !223, metadata !DIExpression()), !dbg !224
  %7 = load i64, i64* %4, align 8, !dbg !225
  %8 = load i64, i64* %5, align 8, !dbg !226
  %9 = load i8, i8* %6, align 1, !dbg !227
  call void @queue_enq(i64 noundef %7, %struct.vqueue_ub_s* noundef @g_queue, i64 noundef %8, i8 noundef signext %9), !dbg !228
  ret void, !dbg !229
}

; Function Attrs: noinline nounwind uwtable
define dso_local %struct.data_s* @deq(i64 noundef %0) #0 !dbg !230 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !233, metadata !DIExpression()), !dbg !234
  %3 = load i64, i64* %2, align 8, !dbg !235
  %4 = call i8* @queue_deq(i64 noundef %3, %struct.vqueue_ub_s* noundef @g_queue), !dbg !236
  %5 = bitcast i8* %4 to %struct.data_s*, !dbg !236
  ret %struct.data_s* %5, !dbg !237
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @t2(i64 noundef %0) #0 !dbg !238 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !239, metadata !DIExpression()), !dbg !240
  %3 = load i64, i64* %2, align 8, !dbg !241
  call void @enq(i64 noundef %3, i64 noundef 4, i8 noundef signext 66), !dbg !242
  ret void, !dbg !243
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @t3(i64 noundef %0) #0 !dbg !244 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !245, metadata !DIExpression()), !dbg !246
  %3 = load i64, i64* %2, align 8, !dbg !247
  call void @queue_clean(i64 noundef %3), !dbg !248
  ret void, !dbg !249
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_clean(i64 noundef %0) #0 !dbg !250 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !251, metadata !DIExpression()), !dbg !252
  %3 = load i64, i64* %2, align 8, !dbg !253
  call void @ismr_recycle(i64 noundef %3), !dbg !254
  ret void, !dbg !255
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @verify() #0 !dbg !256 {
  %1 = load i64, i64* @g_len, align 8, !dbg !259
  %2 = icmp eq i64 %1, 2, !dbg !259
  br i1 %2, label %3, label %4, !dbg !262

3:                                                ; preds = %0
  br label %5, !dbg !262

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 53, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !259
  unreachable, !dbg !259

5:                                                ; preds = %3
  ret void, !dbg !263
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !264 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @init(), !dbg !267
  call void @launch_threads(i64 noundef 3, i8* (i8*)* noundef @run), !dbg !268
  call void @queue_print(%struct.vqueue_ub_s* noundef @g_queue, void (i8*)* noundef @get_final_state), !dbg !269
  call void @verify(), !dbg !270
  call void @destroy(), !dbg !271
  %2 = call zeroext i1 @vmem_no_leak(), !dbg !272
  br i1 %2, label %3, label %4, !dbg !275

3:                                                ; preds = %0
  br label %5, !dbg !275

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.6, i64 0, i64 0), i32 noundef 58, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !272
  unreachable, !dbg !272

5:                                                ; preds = %3
  ret i32 0, !dbg !276
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !277 {
  %1 = alloca i8*, align 8
  %2 = alloca i8, align 1
  %3 = alloca i64, align 8
  call void @queue_init(%struct.vqueue_ub_s* noundef @g_queue), !dbg !278
  call void @queue_register(i64 noundef 0, %struct.vqueue_ub_s* noundef @g_queue), !dbg !279
  call void @enq(i64 noundef 0, i64 noundef 0, i8 noundef signext 97), !dbg !280
  call void @llvm.dbg.declare(metadata i8** %1, metadata !281, metadata !DIExpression()), !dbg !282
  %4 = call %struct.data_s* @deq(i64 noundef 0), !dbg !283
  %5 = bitcast %struct.data_s* %4 to i8*, !dbg !283
  store i8* %5, i8** %1, align 8, !dbg !282
  %6 = load i8*, i8** %1, align 8, !dbg !284
  call void @free(i8* noundef %6) #6, !dbg !285
  call void @llvm.dbg.declare(metadata i8* %2, metadata !286, metadata !DIExpression()), !dbg !287
  store i8 97, i8* %2, align 1, !dbg !287
  call void @llvm.dbg.declare(metadata i64* %3, metadata !288, metadata !DIExpression()), !dbg !290
  store i64 1, i64* %3, align 8, !dbg !290
  br label %7, !dbg !291

7:                                                ; preds = %13, %0
  %8 = load i64, i64* %3, align 8, !dbg !292
  %9 = icmp ule i64 %8, 2, !dbg !294
  br i1 %9, label %10, label %18, !dbg !295

10:                                               ; preds = %7
  %11 = load i64, i64* %3, align 8, !dbg !296
  %12 = load i8, i8* %2, align 1, !dbg !298
  call void @enq(i64 noundef 0, i64 noundef %11, i8 noundef signext %12), !dbg !299
  br label %13, !dbg !300

13:                                               ; preds = %10
  %14 = load i64, i64* %3, align 8, !dbg !301
  %15 = add i64 %14, 1, !dbg !301
  store i64 %15, i64* %3, align 8, !dbg !301
  %16 = load i8, i8* %2, align 1, !dbg !302
  %17 = add i8 %16, 1, !dbg !302
  store i8 %17, i8* %2, align 1, !dbg !302
  br label %7, !dbg !303, !llvm.loop !304

18:                                               ; preds = %7
  call void @queue_deregister(i64 noundef 0, %struct.vqueue_ub_s* noundef @g_queue), !dbg !307
  ret void, !dbg !308
}

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !309 {
  %3 = alloca i64, align 8
  %4 = alloca i8* (i8*)*, align 8
  %5 = alloca %struct.run_info_t*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !312, metadata !DIExpression()), !dbg !313
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %4, metadata !314, metadata !DIExpression()), !dbg !315
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !316, metadata !DIExpression()), !dbg !317
  %6 = load i64, i64* %3, align 8, !dbg !318
  %7 = mul i64 32, %6, !dbg !319
  %8 = call noalias i8* @malloc(i64 noundef %7) #6, !dbg !320
  %9 = bitcast i8* %8 to %struct.run_info_t*, !dbg !320
  store %struct.run_info_t* %9, %struct.run_info_t** %5, align 8, !dbg !317
  %10 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !321
  %11 = load i64, i64* %3, align 8, !dbg !322
  %12 = load i8* (i8*)*, i8* (i8*)** %4, align 8, !dbg !323
  call void @create_threads(%struct.run_info_t* noundef %10, i64 noundef %11, i8* (i8*)* noundef %12, i1 noundef zeroext true), !dbg !324
  %13 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !325
  %14 = load i64, i64* %3, align 8, !dbg !326
  call void @await_threads(%struct.run_info_t* noundef %13, i64 noundef %14), !dbg !327
  %15 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !328
  %16 = bitcast %struct.run_info_t* %15 to i8*, !dbg !328
  call void @free(i8* noundef %16) #6, !dbg !329
  ret void, !dbg !330
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !331 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !332, metadata !DIExpression()), !dbg !333
  call void @llvm.dbg.declare(metadata i64* %3, metadata !334, metadata !DIExpression()), !dbg !335
  %4 = load i8*, i8** %2, align 8, !dbg !336
  %5 = ptrtoint i8* %4 to i64, !dbg !337
  store i64 %5, i64* %3, align 8, !dbg !335
  %6 = load i64, i64* %3, align 8, !dbg !338
  call void @queue_register(i64 noundef %6, %struct.vqueue_ub_s* noundef @g_queue), !dbg !339
  %7 = load i64, i64* %3, align 8, !dbg !340
  switch i64 %7, label %14 [
    i64 0, label %8
    i64 1, label %10
    i64 2, label %12
  ], !dbg !341

8:                                                ; preds = %1
  %9 = load i64, i64* %3, align 8, !dbg !342
  call void @t1(i64 noundef %9), !dbg !344
  br label %18, !dbg !345

10:                                               ; preds = %1
  %11 = load i64, i64* %3, align 8, !dbg !346
  call void @t2(i64 noundef %11), !dbg !347
  br label %18, !dbg !348

12:                                               ; preds = %1
  %13 = load i64, i64* %3, align 8, !dbg !349
  call void @t3(i64 noundef %13), !dbg !350
  br label %18, !dbg !351

14:                                               ; preds = %1
  br i1 true, label %15, label %16, !dbg !352

15:                                               ; preds = %14
  br label %17, !dbg !352

16:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([41 x i8], [41 x i8]* @.str.10, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.6, i64 0, i64 0), i32 noundef 141, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !354
  unreachable, !dbg !354

17:                                               ; preds = %15
  br label %18, !dbg !356

18:                                               ; preds = %17, %12, %10, %8
  %19 = load i64, i64* %3, align 8, !dbg !357
  call void @queue_deregister(i64 noundef %19, %struct.vqueue_ub_s* noundef @g_queue), !dbg !358
  ret i8* null, !dbg !359
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_print(%struct.vqueue_ub_s* noundef %0, void (i8*)* noundef %1) #0 !dbg !360 {
  %3 = alloca %struct.vqueue_ub_s*, align 8
  %4 = alloca void (i8*)*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %3, metadata !364, metadata !DIExpression()), !dbg !365
  store void (i8*)* %1, void (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata void (i8*)** %4, metadata !366, metadata !DIExpression()), !dbg !367
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %3, align 8, !dbg !368
  %6 = load void (i8*)*, void (i8*)** %4, align 8, !dbg !369
  %7 = bitcast void (i8*)* %6 to i8*, !dbg !370
  call void @_vqueue_ub_visit_nodes(%struct.vqueue_ub_s* noundef %5, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_redirect_print, i8* noundef %7), !dbg !371
  ret void, !dbg !372
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @get_final_state(i8* noundef %0) #0 !dbg !373 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.data_s*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !374, metadata !DIExpression()), !dbg !375
  %4 = load i8*, i8** %2, align 8, !dbg !376
  %5 = icmp ne i8* %4, null, !dbg !376
  br i1 %5, label %6, label %7, !dbg !379

6:                                                ; preds = %1
  br label %8, !dbg !379

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.7, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.6, i64 0, i64 0), i32 noundef 119, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.get_final_state, i64 0, i64 0)) #5, !dbg !376
  unreachable, !dbg !376

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata %struct.data_s** %3, metadata !380, metadata !DIExpression()), !dbg !381
  %9 = load i8*, i8** %2, align 8, !dbg !382
  %10 = bitcast i8* %9 to %struct.data_s*, !dbg !382
  store %struct.data_s* %10, %struct.data_s** %3, align 8, !dbg !381
  %11 = load i64, i64* @g_len, align 8, !dbg !383
  %12 = icmp ult i64 %11, 5, !dbg !383
  br i1 %12, label %13, label %14, !dbg !386

13:                                               ; preds = %8
  br label %15, !dbg !386

14:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.8, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.6, i64 0, i64 0), i32 noundef 121, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.get_final_state, i64 0, i64 0)) #5, !dbg !383
  unreachable, !dbg !383

15:                                               ; preds = %13
  %16 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !387
  %17 = getelementptr inbounds %struct.data_s, %struct.data_s* %16, i32 0, i32 0, !dbg !388
  %18 = load i64, i64* %17, align 8, !dbg !388
  %19 = load i64, i64* @g_len, align 8, !dbg !389
  %20 = add i64 %19, 1, !dbg !389
  store i64 %20, i64* @g_len, align 8, !dbg !389
  %21 = getelementptr inbounds [5 x i64], [5 x i64]* @g_final_state, i64 0, i64 %19, !dbg !390
  store i64 %18, i64* %21, align 8, !dbg !391
  ret void, !dbg !392
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @destroy() #0 !dbg !393 {
  call void @queue_destroy(%struct.vqueue_ub_s* noundef @g_queue), !dbg !394
  ret void, !dbg !395
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @vmem_no_leak() #0 !dbg !396 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !399, metadata !DIExpression()), !dbg !400
  %3 = call i64 @vmem_get_alloc_count(), !dbg !401
  store i64 %3, i64* %1, align 8, !dbg !400
  call void @llvm.dbg.declare(metadata i64* %2, metadata !402, metadata !DIExpression()), !dbg !403
  %4 = call i64 @vmem_get_free_count(), !dbg !404
  store i64 %4, i64* %2, align 8, !dbg !403
  %5 = load i64, i64* %1, align 8, !dbg !405
  %6 = load i64, i64* %2, align 8, !dbg !406
  %7 = icmp eq i64 %5, %6, !dbg !407
  ret i1 %7, !dbg !408
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_init(%struct.vqueue_ub_s* noundef %0) #0 !dbg !409 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !413, metadata !DIExpression()), !dbg !414
  call void @ismr_init(), !dbg !415
  %3 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !416
  call void @vqueue_ub_init(%struct.vqueue_ub_s* noundef %3), !dbg !417
  ret void, !dbg !418
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_register(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !419 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !422, metadata !DIExpression()), !dbg !423
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !424, metadata !DIExpression()), !dbg !425
  %5 = load i64, i64* %3, align 8, !dbg !426
  call void @ismr_reg(i64 noundef %5), !dbg !427
  br label %6, !dbg !428

6:                                                ; preds = %2
  br label %7, !dbg !429

7:                                                ; preds = %6
  %8 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !431
  br label %9, !dbg !431

9:                                                ; preds = %7
  br label %10, !dbg !433

10:                                               ; preds = %9
  br label %11, !dbg !431

11:                                               ; preds = %10
  br label %12, !dbg !429

12:                                               ; preds = %11
  ret void, !dbg !435
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_deregister(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !436 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !437, metadata !DIExpression()), !dbg !438
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !439, metadata !DIExpression()), !dbg !440
  %5 = load i64, i64* %3, align 8, !dbg !441
  call void @ismr_dereg(i64 noundef %5), !dbg !442
  br label %6, !dbg !443

6:                                                ; preds = %2
  br label %7, !dbg !444

7:                                                ; preds = %6
  %8 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !446
  br label %9, !dbg !446

9:                                                ; preds = %7
  br label %10, !dbg !448

10:                                               ; preds = %9
  br label %11, !dbg !446

11:                                               ; preds = %10
  br label %12, !dbg !444

12:                                               ; preds = %11
  ret void, !dbg !450
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_destroy(%struct.vqueue_ub_s* noundef %0) #0 !dbg !451 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !452, metadata !DIExpression()), !dbg !453
  call void @llvm.dbg.declare(metadata i8** %3, metadata !454, metadata !DIExpression()), !dbg !455
  store i8* null, i8** %3, align 8, !dbg !455
  br label %4, !dbg !456

4:                                                ; preds = %9, %1
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !457
  %6 = call i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %5, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_queue_destroy, i8* noundef null), !dbg !458
  store i8* %6, i8** %3, align 8, !dbg !459
  %7 = load i8*, i8** %3, align 8, !dbg !460
  %8 = icmp ne i8* %7, null, !dbg !456
  br i1 %8, label %9, label %11, !dbg !456

9:                                                ; preds = %4
  %10 = load i8*, i8** %3, align 8, !dbg !461
  call void @free(i8* noundef %10) #6, !dbg !463
  br label %4, !dbg !456, !llvm.loop !464

11:                                               ; preds = %4
  %12 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !466
  call void @vqueue_ub_destroy(%struct.vqueue_ub_s* noundef %12, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_queue_destroy, i8* noundef null), !dbg !467
  call void @ismr_destroy(), !dbg !468
  %13 = call zeroext i1 @vmem_no_leak(), !dbg !469
  br i1 %13, label %14, label %15, !dbg !472

14:                                               ; preds = %11
  br label %16, !dbg !472

15:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([97 x i8], [97 x i8]* @.str.15, i64 0, i64 0), i32 noundef 166, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.queue_destroy, i64 0, i64 0)) #5, !dbg !469
  unreachable, !dbg !469

16:                                               ; preds = %14
  ret void, !dbg !473
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_enq(i64 noundef %0, %struct.vqueue_ub_s* noundef %1, i64 noundef %2, i8 noundef signext %3) #0 !dbg !474 {
  %5 = alloca i64, align 8
  %6 = alloca %struct.vqueue_ub_s*, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  %9 = alloca %struct.data_s*, align 8
  %10 = alloca %struct.vqueue_ub_node_s*, align 8
  store i64 %0, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !477, metadata !DIExpression()), !dbg !478
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %6, metadata !479, metadata !DIExpression()), !dbg !480
  store i64 %2, i64* %7, align 8
  call void @llvm.dbg.declare(metadata i64* %7, metadata !481, metadata !DIExpression()), !dbg !482
  store i8 %3, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !483, metadata !DIExpression()), !dbg !484
  call void @llvm.dbg.declare(metadata %struct.data_s** %9, metadata !485, metadata !DIExpression()), !dbg !486
  %11 = call noalias i8* @malloc(i64 noundef 16) #6, !dbg !487
  %12 = bitcast i8* %11 to %struct.data_s*, !dbg !487
  store %struct.data_s* %12, %struct.data_s** %9, align 8, !dbg !486
  %13 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !488
  %14 = icmp ne %struct.data_s* %13, null, !dbg !488
  br i1 %14, label %15, label %30, !dbg !490

15:                                               ; preds = %4
  %16 = load i64, i64* %7, align 8, !dbg !491
  %17 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !493
  %18 = getelementptr inbounds %struct.data_s, %struct.data_s* %17, i32 0, i32 0, !dbg !494
  store i64 %16, i64* %18, align 8, !dbg !495
  %19 = load i8, i8* %8, align 1, !dbg !496
  %20 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !497
  %21 = getelementptr inbounds %struct.data_s, %struct.data_s* %20, i32 0, i32 1, !dbg !498
  store i8 %19, i8* %21, align 8, !dbg !499
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %10, metadata !500, metadata !DIExpression()), !dbg !503
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %10, align 8, !dbg !503
  %22 = call i8* @vmem_malloc(i64 noundef 16), !dbg !504
  %23 = bitcast i8* %22 to %struct.vqueue_ub_node_s*, !dbg !504
  store %struct.vqueue_ub_node_s* %23, %struct.vqueue_ub_node_s** %10, align 8, !dbg !505
  %24 = load i64, i64* %5, align 8, !dbg !506
  call void @ismr_enter(i64 noundef %24), !dbg !507
  %25 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %6, align 8, !dbg !508
  %26 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !509
  %27 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !510
  %28 = bitcast %struct.data_s* %27 to i8*, !dbg !510
  call void @vqueue_ub_enq(%struct.vqueue_ub_s* noundef %25, %struct.vqueue_ub_node_s* noundef %26, i8* noundef %28), !dbg !511
  %29 = load i64, i64* %5, align 8, !dbg !512
  call void @ismr_exit(i64 noundef %29), !dbg !513
  br label %31, !dbg !514

30:                                               ; preds = %4
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.14, i64 0, i64 0), i8* noundef getelementptr inbounds ([97 x i8], [97 x i8]* @.str.15, i64 0, i64 0), i32 noundef 196, i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @__PRETTY_FUNCTION__.queue_enq, i64 0, i64 0)) #5, !dbg !515
  unreachable, !dbg !515

31:                                               ; preds = %15
  ret void, !dbg !519
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @queue_deq(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !520 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca i8*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !523, metadata !DIExpression()), !dbg !524
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !525, metadata !DIExpression()), !dbg !526
  %6 = load i64, i64* %3, align 8, !dbg !527
  call void @ismr_enter(i64 noundef %6), !dbg !528
  call void @llvm.dbg.declare(metadata i8** %5, metadata !529, metadata !DIExpression()), !dbg !530
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !531
  %8 = load i64, i64* %3, align 8, !dbg !532
  %9 = inttoptr i64 %8 to i8*, !dbg !533
  %10 = call i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %7, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_queue_retire, i8* noundef %9), !dbg !534
  store i8* %10, i8** %5, align 8, !dbg !530
  %11 = load i64, i64* %3, align 8, !dbg !535
  call void @ismr_exit(i64 noundef %11), !dbg !536
  %12 = load i8*, i8** %5, align 8, !dbg !537
  ret i8* %12, !dbg !538
}

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @empty(i64 noundef %0) #0 !dbg !539 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !542, metadata !DIExpression()), !dbg !543
  %3 = load i64, i64* %2, align 8, !dbg !544
  %4 = call zeroext i1 @queue_empty(i64 noundef %3, %struct.vqueue_ub_s* noundef @g_queue), !dbg !545
  ret i1 %4, !dbg !546
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @queue_empty(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !547 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca i8, align 1
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !550, metadata !DIExpression()), !dbg !551
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !552, metadata !DIExpression()), !dbg !553
  %6 = load i64, i64* %3, align 8, !dbg !554
  call void @ismr_enter(i64 noundef %6), !dbg !555
  call void @llvm.dbg.declare(metadata i8* %5, metadata !556, metadata !DIExpression()), !dbg !557
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !558
  %8 = call zeroext i1 @vqueue_ub_empty(%struct.vqueue_ub_s* noundef %7), !dbg !559
  %9 = zext i1 %8 to i8, !dbg !557
  store i8 %9, i8* %5, align 1, !dbg !557
  %10 = load i64, i64* %3, align 8, !dbg !560
  call void @ismr_exit(i64 noundef %10), !dbg !561
  %11 = load i8, i8* %5, align 1, !dbg !562
  %12 = trunc i8 %11 to i1, !dbg !562
  ret i1 %12, !dbg !563
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_recycle(i64 noundef %0) #0 !dbg !564 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !565, metadata !DIExpression()), !dbg !566
  br label %3, !dbg !567

3:                                                ; preds = %1
  br label %4, !dbg !568

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !570
  br label %6, !dbg !570

6:                                                ; preds = %4
  br label %7, !dbg !572

7:                                                ; preds = %6
  br label %8, !dbg !570

8:                                                ; preds = %7
  br label %9, !dbg !568

9:                                                ; preds = %8
  ret void, !dbg !574
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !575 {
  %5 = alloca %struct.run_info_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8* (i8*)*, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !578, metadata !DIExpression()), !dbg !579
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !580, metadata !DIExpression()), !dbg !581
  store i8* (i8*)* %2, i8* (i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %7, metadata !582, metadata !DIExpression()), !dbg !583
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !584, metadata !DIExpression()), !dbg !585
  call void @llvm.dbg.declare(metadata i64* %9, metadata !586, metadata !DIExpression()), !dbg !587
  store i64 0, i64* %9, align 8, !dbg !587
  store i64 0, i64* %9, align 8, !dbg !588
  br label %11, !dbg !590

11:                                               ; preds = %42, %4
  %12 = load i64, i64* %9, align 8, !dbg !591
  %13 = load i64, i64* %6, align 8, !dbg !593
  %14 = icmp ult i64 %12, %13, !dbg !594
  br i1 %14, label %15, label %45, !dbg !595

15:                                               ; preds = %11
  %16 = load i64, i64* %9, align 8, !dbg !596
  %17 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !598
  %18 = load i64, i64* %9, align 8, !dbg !599
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %17, i64 %18, !dbg !598
  %20 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %19, i32 0, i32 1, !dbg !600
  store i64 %16, i64* %20, align 8, !dbg !601
  %21 = load i8* (i8*)*, i8* (i8*)** %7, align 8, !dbg !602
  %22 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !603
  %23 = load i64, i64* %9, align 8, !dbg !604
  %24 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %22, i64 %23, !dbg !603
  %25 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %24, i32 0, i32 3, !dbg !605
  store i8* (i8*)* %21, i8* (i8*)** %25, align 8, !dbg !606
  %26 = load i8, i8* %8, align 1, !dbg !607
  %27 = trunc i8 %26 to i1, !dbg !607
  %28 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !608
  %29 = load i64, i64* %9, align 8, !dbg !609
  %30 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %28, i64 %29, !dbg !608
  %31 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %30, i32 0, i32 2, !dbg !610
  %32 = zext i1 %27 to i8, !dbg !611
  store i8 %32, i8* %31, align 8, !dbg !611
  %33 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !612
  %34 = load i64, i64* %9, align 8, !dbg !613
  %35 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %33, i64 %34, !dbg !612
  %36 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %35, i32 0, i32 0, !dbg !614
  %37 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !615
  %38 = load i64, i64* %9, align 8, !dbg !616
  %39 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %37, i64 %38, !dbg !615
  %40 = bitcast %struct.run_info_t* %39 to i8*, !dbg !617
  %41 = call i32 @pthread_create(i64* noundef %36, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %40) #6, !dbg !618
  br label %42, !dbg !619

42:                                               ; preds = %15
  %43 = load i64, i64* %9, align 8, !dbg !620
  %44 = add i64 %43, 1, !dbg !620
  store i64 %44, i64* %9, align 8, !dbg !620
  br label %11, !dbg !621, !llvm.loop !622

45:                                               ; preds = %11
  ret void, !dbg !624
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !625 {
  %3 = alloca %struct.run_info_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !628, metadata !DIExpression()), !dbg !629
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !630, metadata !DIExpression()), !dbg !631
  call void @llvm.dbg.declare(metadata i64* %5, metadata !632, metadata !DIExpression()), !dbg !633
  store i64 0, i64* %5, align 8, !dbg !633
  store i64 0, i64* %5, align 8, !dbg !634
  br label %6, !dbg !636

6:                                                ; preds = %17, %2
  %7 = load i64, i64* %5, align 8, !dbg !637
  %8 = load i64, i64* %4, align 8, !dbg !639
  %9 = icmp ult i64 %7, %8, !dbg !640
  br i1 %9, label %10, label %20, !dbg !641

10:                                               ; preds = %6
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !642
  %12 = load i64, i64* %5, align 8, !dbg !644
  %13 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i64 %12, !dbg !642
  %14 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %13, i32 0, i32 0, !dbg !645
  %15 = load i64, i64* %14, align 8, !dbg !645
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !646
  br label %17, !dbg !647

17:                                               ; preds = %10
  %18 = load i64, i64* %5, align 8, !dbg !648
  %19 = add i64 %18, 1, !dbg !648
  store i64 %19, i64* %5, align 8, !dbg !648
  br label %6, !dbg !649, !llvm.loop !650

20:                                               ; preds = %6
  ret void, !dbg !652
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !653 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.run_info_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !654, metadata !DIExpression()), !dbg !655
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !656, metadata !DIExpression()), !dbg !657
  %4 = load i8*, i8** %2, align 8, !dbg !658
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !659
  store %struct.run_info_t* %5, %struct.run_info_t** %3, align 8, !dbg !657
  %6 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !660
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %6, i32 0, i32 2, !dbg !662
  %8 = load i8, i8* %7, align 8, !dbg !662
  %9 = trunc i8 %8 to i1, !dbg !662
  br i1 %9, label %10, label %14, !dbg !663

10:                                               ; preds = %1
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !664
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i32 0, i32 1, !dbg !665
  %13 = load i64, i64* %12, align 8, !dbg !665
  call void @set_cpu_affinity(i64 noundef %13), !dbg !666
  br label %14, !dbg !666

14:                                               ; preds = %10, %1
  %15 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !667
  %16 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %15, i32 0, i32 3, !dbg !668
  %17 = load i8* (i8*)*, i8* (i8*)** %16, align 8, !dbg !668
  %18 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !669
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %18, i32 0, i32 1, !dbg !670
  %20 = load i64, i64* %19, align 8, !dbg !670
  %21 = inttoptr i64 %20 to i8*, !dbg !671
  %22 = call i8* %17(i8* noundef %21), !dbg !667
  ret i8* %22, !dbg !672
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !673 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !674, metadata !DIExpression()), !dbg !675
  br label %3, !dbg !676

3:                                                ; preds = %1
  br label %4, !dbg !677

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !679
  br label %6, !dbg !679

6:                                                ; preds = %4
  br label %7, !dbg !681

7:                                                ; preds = %6
  br label %8, !dbg !679

8:                                                ; preds = %7
  br label %9, !dbg !677

9:                                                ; preds = %8
  ret void, !dbg !683
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @_vqueue_ub_visit_nodes(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !684 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !693, metadata !DIExpression()), !dbg !694
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !695, metadata !DIExpression()), !dbg !696
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !697, metadata !DIExpression()), !dbg !698
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !699, metadata !DIExpression()), !dbg !700
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !700
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !701, metadata !DIExpression()), !dbg !702
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !702
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !703
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 2, !dbg !704
  %11 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !704
  store %struct.vqueue_ub_node_s* %11, %struct.vqueue_ub_node_s** %7, align 8, !dbg !705
  %12 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !706
  %13 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %12, i32 0, i32 1, !dbg !707
  %14 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %13), !dbg !708
  %15 = bitcast i8* %14 to %struct.vqueue_ub_node_s*, !dbg !709
  store %struct.vqueue_ub_node_s* %15, %struct.vqueue_ub_node_s** %7, align 8, !dbg !710
  br label %16, !dbg !711

16:                                               ; preds = %19, %3
  %17 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !712
  %18 = icmp ne %struct.vqueue_ub_node_s* %17, null, !dbg !711
  br i1 %18, label %19, label %28, !dbg !711

19:                                               ; preds = %16
  %20 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !713
  %21 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %20, i32 0, i32 1, !dbg !715
  %22 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %21), !dbg !716
  %23 = bitcast i8* %22 to %struct.vqueue_ub_node_s*, !dbg !717
  store %struct.vqueue_ub_node_s* %23, %struct.vqueue_ub_node_s** %8, align 8, !dbg !718
  %24 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !719
  %25 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !720
  %26 = load i8*, i8** %6, align 8, !dbg !721
  call void %24(%struct.vqueue_ub_node_s* noundef %25, i8* noundef %26), !dbg !719
  %27 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !722
  store %struct.vqueue_ub_node_s* %27, %struct.vqueue_ub_node_s** %7, align 8, !dbg !723
  br label %16, !dbg !711, !llvm.loop !724

28:                                               ; preds = %16
  ret void, !dbg !726
}

; Function Attrs: noinline nounwind uwtable
define internal void @_redirect_print(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !727 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca void (i8*)*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !730, metadata !DIExpression()), !dbg !731
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !732, metadata !DIExpression()), !dbg !733
  call void @llvm.dbg.declare(metadata void (i8*)** %5, metadata !734, metadata !DIExpression()), !dbg !735
  %6 = load i8*, i8** %4, align 8, !dbg !736
  %7 = bitcast i8* %6 to void (i8*)*, !dbg !737
  store void (i8*)* %7, void (i8*)** %5, align 8, !dbg !735
  %8 = load void (i8*)*, void (i8*)** %5, align 8, !dbg !738
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !739
  %10 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %9, i32 0, i32 0, !dbg !740
  %11 = load i8*, i8** %10, align 8, !dbg !740
  call void %8(i8* noundef %11), !dbg !738
  ret void, !dbg !741
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !742 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !748, metadata !DIExpression()), !dbg !749
  call void @llvm.dbg.declare(metadata i8** %3, metadata !750, metadata !DIExpression()), !dbg !751
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !752
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !753
  %6 = load i8*, i8** %5, align 8, !dbg !753
  %7 = call i8* asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !754, !srcloc !755
  store i8* %7, i8** %3, align 8, !dbg !754
  %8 = load i8*, i8** %3, align 8, !dbg !756
  ret i8* %8, !dbg !757
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vmem_get_alloc_count() #0 !dbg !758 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !761, metadata !DIExpression()), !dbg !762
  %2 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef @_g_vmem_alloc_count), !dbg !763
  store i64 %2, i64* %1, align 8, !dbg !762
  br label %3, !dbg !764

3:                                                ; preds = %0
  br label %4, !dbg !765

4:                                                ; preds = %3
  %5 = load i64, i64* %1, align 8, !dbg !767
  br label %6, !dbg !767

6:                                                ; preds = %4
  br label %7, !dbg !769

7:                                                ; preds = %6
  br label %8, !dbg !767

8:                                                ; preds = %7
  br label %9, !dbg !765

9:                                                ; preds = %8
  %10 = load i64, i64* %1, align 8, !dbg !771
  ret i64 %10, !dbg !772
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vmem_get_free_count() #0 !dbg !773 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !774, metadata !DIExpression()), !dbg !775
  %2 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef @_g_vmem_free_count), !dbg !776
  store i64 %2, i64* %1, align 8, !dbg !775
  br label %3, !dbg !777

3:                                                ; preds = %0
  br label %4, !dbg !778

4:                                                ; preds = %3
  %5 = load i64, i64* %1, align 8, !dbg !780
  br label %6, !dbg !780

6:                                                ; preds = %4
  br label %7, !dbg !782

7:                                                ; preds = %6
  br label %8, !dbg !780

8:                                                ; preds = %7
  br label %9, !dbg !778

9:                                                ; preds = %8
  %10 = load i64, i64* %1, align 8, !dbg !784
  ret i64 %10, !dbg !785
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !786 {
  %2 = alloca %struct.vatomic64_s*, align 8
  %3 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !791, metadata !DIExpression()), !dbg !792
  call void @llvm.dbg.declare(metadata i64* %3, metadata !793, metadata !DIExpression()), !dbg !794
  %4 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !795
  %5 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %4, i32 0, i32 0, !dbg !796
  %6 = load i64, i64* %5, align 8, !dbg !796
  %7 = call i64 asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i64 %6) #6, !dbg !797, !srcloc !798
  store i64 %7, i64* %3, align 8, !dbg !797
  %8 = load i64, i64* %3, align 8, !dbg !799
  ret i64 %8, !dbg !800
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_init() #0 !dbg !801 {
  call void @locked_trace_init(%struct.locked_trace_s* noundef @global_trace, i64 noundef 100), !dbg !802
  ret void, !dbg !803
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_init(%struct.vqueue_ub_s* noundef %0) #0 !dbg !804 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !807, metadata !DIExpression()), !dbg !808
  %3 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !809
  %4 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %3, i32 0, i32 4, !dbg !810
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !811
  %6 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %5, i32 0, i32 2, !dbg !812
  store %struct.vqueue_ub_node_s* %4, %struct.vqueue_ub_node_s** %6, align 8, !dbg !813
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !814
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 4, !dbg !815
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !816
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 3, !dbg !817
  store %struct.vqueue_ub_node_s* %8, %struct.vqueue_ub_node_s** %10, align 8, !dbg !818
  %11 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !819
  %12 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %11, i32 0, i32 4, !dbg !820
  call void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %12, i8* noundef null), !dbg !821
  %13 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !822
  %14 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %13, i32 0, i32 0, !dbg !823
  call void @queue_lock_init(%union.pthread_mutex_t* noundef %14), !dbg !824
  %15 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !825
  %16 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %15, i32 0, i32 1, !dbg !826
  call void @queue_lock_init(%union.pthread_mutex_t* noundef %16), !dbg !827
  ret void, !dbg !828
}

; Function Attrs: noinline nounwind uwtable
define internal void @locked_trace_init(%struct.locked_trace_s* noundef %0, i64 noundef %1) #0 !dbg !829 {
  %3 = alloca %struct.locked_trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.locked_trace_s* %0, %struct.locked_trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.locked_trace_s** %3, metadata !833, metadata !DIExpression()), !dbg !834
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !835, metadata !DIExpression()), !dbg !836
  %5 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !837
  %6 = icmp ne %struct.locked_trace_s* %5, null, !dbg !837
  br i1 %6, label %7, label %8, !dbg !840

7:                                                ; preds = %2
  br label %9, !dbg !840

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([64 x i8], [64 x i8]* @.str.12, i64 0, i64 0), i32 noundef 16, i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @__PRETTY_FUNCTION__.locked_trace_init, i64 0, i64 0)) #5, !dbg !837
  unreachable, !dbg !837

9:                                                ; preds = %7
  %10 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !841
  %11 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %10, i32 0, i32 1, !dbg !842
  %12 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %11, %union.pthread_mutexattr_t* noundef null) #6, !dbg !843
  %13 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !844
  %14 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %13, i32 0, i32 0, !dbg !845
  %15 = load i64, i64* %4, align 8, !dbg !846
  call void @trace_init(%struct.trace_s* noundef %14, i64 noundef %15), !dbg !847
  ret void, !dbg !848
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @trace_init(%struct.trace_s* noundef %0, i64 noundef %1) #0 !dbg !849 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !853, metadata !DIExpression()), !dbg !854
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !855, metadata !DIExpression()), !dbg !856
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !857
  %6 = icmp ne %struct.trace_s* %5, null, !dbg !857
  br i1 %6, label %7, label %8, !dbg !860

7:                                                ; preds = %2
  br label %9, !dbg !860

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 30, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !857
  unreachable, !dbg !857

9:                                                ; preds = %7
  %10 = load i64, i64* %4, align 8, !dbg !861
  %11 = mul i64 %10, 16, !dbg !862
  %12 = call noalias i8* @malloc(i64 noundef %11) #6, !dbg !863
  %13 = bitcast i8* %12 to %struct.trace_unit_s*, !dbg !863
  %14 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !864
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 0, !dbg !865
  store %struct.trace_unit_s* %13, %struct.trace_unit_s** %15, align 8, !dbg !866
  %16 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !867
  %17 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %16, i32 0, i32 0, !dbg !869
  %18 = load %struct.trace_unit_s*, %struct.trace_unit_s** %17, align 8, !dbg !869
  %19 = icmp ne %struct.trace_unit_s* %18, null, !dbg !867
  br i1 %19, label %20, label %28, !dbg !870

20:                                               ; preds = %9
  %21 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !871
  %22 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %21, i32 0, i32 1, !dbg !873
  store i64 0, i64* %22, align 8, !dbg !874
  %23 = load i64, i64* %4, align 8, !dbg !875
  %24 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !876
  %25 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %24, i32 0, i32 2, !dbg !877
  store i64 %23, i64* %25, align 8, !dbg !878
  %26 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !879
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 3, !dbg !880
  store i8 1, i8* %27, align 8, !dbg !881
  br label %35, !dbg !882

28:                                               ; preds = %9
  %29 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !883
  %30 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %29, i32 0, i32 1, !dbg !885
  store i64 0, i64* %30, align 8, !dbg !886
  %31 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !887
  %32 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %31, i32 0, i32 2, !dbg !888
  store i64 0, i64* %32, align 8, !dbg !889
  %33 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !890
  %34 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %33, i32 0, i32 3, !dbg !891
  store i8 0, i8* %34, align 8, !dbg !892
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.14, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 40, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !893
  unreachable, !dbg !893

35:                                               ; preds = %20
  ret void, !dbg !896
}

; Function Attrs: noinline nounwind uwtable
define internal void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !897 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !898, metadata !DIExpression()), !dbg !899
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !900, metadata !DIExpression()), !dbg !901
  %5 = load i8*, i8** %4, align 8, !dbg !902
  %6 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !903
  %7 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %6, i32 0, i32 0, !dbg !904
  store i8* %5, i8** %7, align 8, !dbg !905
  %8 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !906
  %9 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %8, i32 0, i32 1, !dbg !907
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %9, i8* noundef null), !dbg !908
  ret void, !dbg !909
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_init(%union.pthread_mutex_t* noundef %0) #0 !dbg !910 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !914, metadata !DIExpression()), !dbg !915
  %3 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !915
  %4 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %3, %union.pthread_mutexattr_t* noundef null) #6, !dbg !915
  ret void, !dbg !915
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !916 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !920, metadata !DIExpression()), !dbg !921
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !922, metadata !DIExpression()), !dbg !923
  %5 = load i8*, i8** %4, align 8, !dbg !924
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !925
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !926
  %8 = load i8*, i8** %7, align 8, !dbg !926
  call void asm sideeffect "str ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !927, !srcloc !928
  ret void, !dbg !929
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_reg(i64 noundef %0) #0 !dbg !930 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !931, metadata !DIExpression()), !dbg !932
  br label %3, !dbg !933

3:                                                ; preds = %1
  br label %4, !dbg !934

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !936
  br label %6, !dbg !936

6:                                                ; preds = %4
  br label %7, !dbg !938

7:                                                ; preds = %6
  br label %8, !dbg !936

8:                                                ; preds = %7
  br label %9, !dbg !934

9:                                                ; preds = %8
  ret void, !dbg !940
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_dereg(i64 noundef %0) #0 !dbg !941 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !942, metadata !DIExpression()), !dbg !943
  br label %3, !dbg !944

3:                                                ; preds = %1
  br label %4, !dbg !945

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !947
  br label %6, !dbg !947

6:                                                ; preds = %4
  br label %7, !dbg !949

7:                                                ; preds = %6
  br label %8, !dbg !947

8:                                                ; preds = %7
  br label %9, !dbg !945

9:                                                ; preds = %8
  ret void, !dbg !951
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !952 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  %9 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !955, metadata !DIExpression()), !dbg !956
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !957, metadata !DIExpression()), !dbg !958
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !959, metadata !DIExpression()), !dbg !960
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !961, metadata !DIExpression()), !dbg !962
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !962
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !963, metadata !DIExpression()), !dbg !964
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !964
  call void @llvm.dbg.declare(metadata i8** %9, metadata !965, metadata !DIExpression()), !dbg !966
  store i8* null, i8** %9, align 8, !dbg !966
  %10 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !967
  %11 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %10, i32 0, i32 1, !dbg !968
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %11), !dbg !969
  %12 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !970
  %13 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %12, i32 0, i32 2, !dbg !971
  %14 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %13, align 8, !dbg !971
  store %struct.vqueue_ub_node_s* %14, %struct.vqueue_ub_node_s** %8, align 8, !dbg !972
  %15 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !973
  %16 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %15, i32 0, i32 1, !dbg !974
  %17 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %16), !dbg !975
  %18 = bitcast i8* %17 to %struct.vqueue_ub_node_s*, !dbg !976
  store %struct.vqueue_ub_node_s* %18, %struct.vqueue_ub_node_s** %7, align 8, !dbg !977
  %19 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !978
  %20 = icmp ne %struct.vqueue_ub_node_s* %19, null, !dbg !978
  br i1 %20, label %21, label %37, !dbg !980

21:                                               ; preds = %3
  %22 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !981
  %23 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %22, i32 0, i32 0, !dbg !983
  %24 = load i8*, i8** %23, align 8, !dbg !983
  store i8* %24, i8** %9, align 8, !dbg !984
  %25 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !985
  %26 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !986
  %27 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %26, i32 0, i32 2, !dbg !987
  store %struct.vqueue_ub_node_s* %25, %struct.vqueue_ub_node_s** %27, align 8, !dbg !988
  %28 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !989
  %29 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !991
  %30 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %29, i32 0, i32 4, !dbg !992
  %31 = icmp ne %struct.vqueue_ub_node_s* %28, %30, !dbg !993
  br i1 %31, label %32, label %36, !dbg !994

32:                                               ; preds = %21
  %33 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !995
  %34 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !997
  %35 = load i8*, i8** %6, align 8, !dbg !998
  call void %33(%struct.vqueue_ub_node_s* noundef %34, i8* noundef %35), !dbg !995
  br label %36, !dbg !999

36:                                               ; preds = %32, %21
  br label %37, !dbg !1000

37:                                               ; preds = %36, %3
  %38 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1001
  %39 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %38, i32 0, i32 1, !dbg !1002
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %39), !dbg !1003
  %40 = load i8*, i8** %9, align 8, !dbg !1004
  ret i8* %40, !dbg !1005
}

; Function Attrs: noinline nounwind uwtable
define internal void @_queue_destroy(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !1006 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1009, metadata !DIExpression()), !dbg !1010
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1011, metadata !DIExpression()), !dbg !1012
  %5 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1013
  %6 = bitcast %struct.vqueue_ub_node_s* %5 to i8*, !dbg !1013
  call void @vmem_free(i8* noundef %6), !dbg !1014
  br label %7, !dbg !1015

7:                                                ; preds = %2
  br label %8, !dbg !1016

8:                                                ; preds = %7
  %9 = load i8*, i8** %4, align 8, !dbg !1018
  br label %10, !dbg !1018

10:                                               ; preds = %8
  br label %11, !dbg !1020

11:                                               ; preds = %10
  br label %12, !dbg !1018

12:                                               ; preds = %11
  br label %13, !dbg !1016

13:                                               ; preds = %12
  ret void, !dbg !1022
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_destroy(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !1023 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !1024, metadata !DIExpression()), !dbg !1025
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !1026, metadata !DIExpression()), !dbg !1027
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !1028, metadata !DIExpression()), !dbg !1029
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !1030, metadata !DIExpression()), !dbg !1031
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1031
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !1032, metadata !DIExpression()), !dbg !1033
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1033
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1034
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 2, !dbg !1035
  %11 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !1035
  store %struct.vqueue_ub_node_s* %11, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1036
  br label %12, !dbg !1037

12:                                               ; preds = %28, %3
  %13 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1038
  %14 = icmp ne %struct.vqueue_ub_node_s* %13, null, !dbg !1037
  br i1 %14, label %15, label %30, !dbg !1037

15:                                               ; preds = %12
  %16 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1039
  %17 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %16, i32 0, i32 1, !dbg !1041
  %18 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %17), !dbg !1042
  %19 = bitcast i8* %18 to %struct.vqueue_ub_node_s*, !dbg !1043
  store %struct.vqueue_ub_node_s* %19, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1044
  %20 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1045
  %21 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1047
  %22 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %21, i32 0, i32 4, !dbg !1048
  %23 = icmp ne %struct.vqueue_ub_node_s* %20, %22, !dbg !1049
  br i1 %23, label %24, label %28, !dbg !1050

24:                                               ; preds = %15
  %25 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !1051
  %26 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1053
  %27 = load i8*, i8** %6, align 8, !dbg !1054
  call void %25(%struct.vqueue_ub_node_s* noundef %26, i8* noundef %27), !dbg !1051
  br label %28, !dbg !1055

28:                                               ; preds = %24, %15
  %29 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1056
  store %struct.vqueue_ub_node_s* %29, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1057
  br label %12, !dbg !1037, !llvm.loop !1058

30:                                               ; preds = %12
  ret void, !dbg !1060
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_destroy() #0 !dbg !1061 {
  call void @locked_trace_destroy(%struct.locked_trace_s* noundef @global_trace, i1 (%struct.trace_unit_s*)* noundef @_ismr_none_destroy_all_cb), !dbg !1062
  ret void, !dbg !1063
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_acquire(%union.pthread_mutex_t* noundef %0) #0 !dbg !1064 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !1065, metadata !DIExpression()), !dbg !1066
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1067, metadata !DIExpression()), !dbg !1066
  %4 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !1066
  %5 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef %4) #6, !dbg !1066
  store i32 %5, i32* %3, align 4, !dbg !1066
  %6 = load i32, i32* %3, align 4, !dbg !1068
  %7 = icmp eq i32 %6, 0, !dbg !1068
  br i1 %7, label %8, label %9, !dbg !1071

8:                                                ; preds = %1
  br label %10, !dbg !1071

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.16, i64 0, i64 0), i8* noundef getelementptr inbounds ([101 x i8], [101 x i8]* @.str.17, i64 0, i64 0), i32 noundef 32, i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.queue_lock_acquire, i64 0, i64 0)) #5, !dbg !1068
  unreachable, !dbg !1068

10:                                               ; preds = %8
  ret void, !dbg !1066
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %0) #0 !dbg !1072 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !1073, metadata !DIExpression()), !dbg !1074
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1075, metadata !DIExpression()), !dbg !1076
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !1077
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !1078
  %6 = load i8*, i8** %5, align 8, !dbg !1078
  %7 = call i8* asm sideeffect "ldar ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !1079, !srcloc !1080
  store i8* %7, i8** %3, align 8, !dbg !1079
  %8 = load i8*, i8** %3, align 8, !dbg !1081
  ret i8* %8, !dbg !1082
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_release(%union.pthread_mutex_t* noundef %0) #0 !dbg !1083 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !1084, metadata !DIExpression()), !dbg !1085
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1086, metadata !DIExpression()), !dbg !1085
  %4 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !1085
  %5 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef %4) #6, !dbg !1085
  store i32 %5, i32* %3, align 4, !dbg !1085
  %6 = load i32, i32* %3, align 4, !dbg !1087
  %7 = icmp eq i32 %6, 0, !dbg !1087
  br i1 %7, label %8, label %9, !dbg !1090

8:                                                ; preds = %1
  br label %10, !dbg !1090

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.16, i64 0, i64 0), i8* noundef getelementptr inbounds ([101 x i8], [101 x i8]* @.str.17, i64 0, i64 0), i32 noundef 32, i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.queue_lock_release, i64 0, i64 0)) #5, !dbg !1087
  unreachable, !dbg !1087

10:                                               ; preds = %8
  ret void, !dbg !1085
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @vmem_free(i8* noundef %0) #0 !dbg !1091 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !1092, metadata !DIExpression()), !dbg !1093
  %3 = load i8*, i8** %2, align 8, !dbg !1094
  call void @free(i8* noundef %3) #6, !dbg !1095
  %4 = load i8*, i8** %2, align 8, !dbg !1096
  %5 = icmp ne i8* %4, null, !dbg !1096
  br i1 %5, label %6, label %7, !dbg !1098

6:                                                ; preds = %1
  call void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef @_g_vmem_free_count), !dbg !1099
  br label %7, !dbg !1101

7:                                                ; preds = %6, %1
  ret void, !dbg !1102
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !1103 {
  %2 = alloca %struct.vatomic64_s*, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !1108, metadata !DIExpression()), !dbg !1109
  %3 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !1110
  %4 = call i64 @vatomic64_get_inc_rlx(%struct.vatomic64_s* noundef %3), !dbg !1111
  ret void, !dbg !1112
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_get_inc_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !1113 {
  %2 = alloca %struct.vatomic64_s*, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !1116, metadata !DIExpression()), !dbg !1117
  %3 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !1118
  %4 = call i64 @vatomic64_get_add_rlx(%struct.vatomic64_s* noundef %3, i64 noundef 1), !dbg !1119
  ret i64 %4, !dbg !1120
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_get_add_rlx(%struct.vatomic64_s* noundef %0, i64 noundef %1) #0 !dbg !1121 {
  %3 = alloca %struct.vatomic64_s*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %3, metadata !1125, metadata !DIExpression()), !dbg !1126
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1127, metadata !DIExpression()), !dbg !1128
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1129, metadata !DIExpression()), !dbg !1130
  call void @llvm.dbg.declare(metadata i32* %6, metadata !1131, metadata !DIExpression()), !dbg !1135
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1136, metadata !DIExpression()), !dbg !1137
  %8 = load i64, i64* %4, align 8, !dbg !1138
  %9 = load %struct.vatomic64_s*, %struct.vatomic64_s** %3, align 8, !dbg !1139
  %10 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %9, i32 0, i32 0, !dbg !1140
  %11 = load i64, i64* %10, align 8, !dbg !1140
  %12 = call { i64, i64, i32, i64 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:x}, $4\0Aadd ${1:x}, ${0:x}, ${3:x}\0Astxr ${2:w}, ${1:x}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i64 %11, i64 %8) #6, !dbg !1138, !srcloc !1141
  %13 = extractvalue { i64, i64, i32, i64 } %12, 0, !dbg !1138
  %14 = extractvalue { i64, i64, i32, i64 } %12, 1, !dbg !1138
  %15 = extractvalue { i64, i64, i32, i64 } %12, 2, !dbg !1138
  %16 = extractvalue { i64, i64, i32, i64 } %12, 3, !dbg !1138
  store i64 %13, i64* %5, align 8, !dbg !1138
  store i64 %14, i64* %7, align 8, !dbg !1138
  store i32 %15, i32* %6, align 4, !dbg !1138
  store i64 %16, i64* %4, align 8, !dbg !1138
  %17 = load i64, i64* %5, align 8, !dbg !1142
  ret i64 %17, !dbg !1143
}

; Function Attrs: noinline nounwind uwtable
define internal void @locked_trace_destroy(%struct.locked_trace_s* noundef %0, i1 (%struct.trace_unit_s*)* noundef %1) #0 !dbg !1144 {
  %3 = alloca %struct.locked_trace_s*, align 8
  %4 = alloca i1 (%struct.trace_unit_s*)*, align 8
  store %struct.locked_trace_s* %0, %struct.locked_trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.locked_trace_s** %3, metadata !1151, metadata !DIExpression()), !dbg !1152
  store i1 (%struct.trace_unit_s*)* %1, i1 (%struct.trace_unit_s*)** %4, align 8
  call void @llvm.dbg.declare(metadata i1 (%struct.trace_unit_s*)** %4, metadata !1153, metadata !DIExpression()), !dbg !1154
  %5 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1155
  %6 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %5, i32 0, i32 0, !dbg !1156
  %7 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %4, align 8, !dbg !1157
  %8 = call zeroext i1 @trace_verify(%struct.trace_s* noundef %6, i1 (%struct.trace_unit_s*)* noundef %7), !dbg !1158
  %9 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1159
  %10 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %9, i32 0, i32 0, !dbg !1160
  call void @trace_destroy(%struct.trace_s* noundef %10), !dbg !1161
  %11 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1162
  %12 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %11, i32 0, i32 1, !dbg !1163
  %13 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef %12) #6, !dbg !1164
  ret void, !dbg !1165
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @_ismr_none_destroy_all_cb(%struct.trace_unit_s* noundef %0) #0 !dbg !1166 {
  %2 = alloca %struct.trace_unit_s*, align 8
  %3 = alloca %struct.smr_none_retire_info_t*, align 8
  store %struct.trace_unit_s* %0, %struct.trace_unit_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %2, metadata !1167, metadata !DIExpression()), !dbg !1168
  %4 = load %struct.trace_unit_s*, %struct.trace_unit_s** %2, align 8, !dbg !1169
  %5 = icmp ne %struct.trace_unit_s* %4, null, !dbg !1169
  br i1 %5, label %6, label %7, !dbg !1172

6:                                                ; preds = %1
  br label %8, !dbg !1172

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.20, i64 0, i64 0), i8* noundef getelementptr inbounds ([70 x i8], [70 x i8]* @.str.21, i64 0, i64 0), i32 noundef 27, i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @__PRETTY_FUNCTION__._ismr_none_destroy_all_cb, i64 0, i64 0)) #5, !dbg !1169
  unreachable, !dbg !1169

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata %struct.smr_none_retire_info_t** %3, metadata !1173, metadata !DIExpression()), !dbg !1174
  %9 = load %struct.trace_unit_s*, %struct.trace_unit_s** %2, align 8, !dbg !1175
  %10 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %9, i32 0, i32 0, !dbg !1176
  %11 = load i64, i64* %10, align 8, !dbg !1176
  %12 = inttoptr i64 %11 to %struct.smr_none_retire_info_t*, !dbg !1177
  store %struct.smr_none_retire_info_t* %12, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1174
  %13 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1178
  %14 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %13, i32 0, i32 1, !dbg !1179
  %15 = load void (%struct.smr_node_s*, i8*)*, void (%struct.smr_node_s*, i8*)** %14, align 8, !dbg !1179
  %16 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1180
  %17 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %16, i32 0, i32 0, !dbg !1181
  %18 = load %struct.smr_node_s*, %struct.smr_node_s** %17, align 8, !dbg !1181
  %19 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1182
  %20 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %19, i32 0, i32 2, !dbg !1183
  %21 = load i8*, i8** %20, align 8, !dbg !1183
  call void %15(%struct.smr_node_s* noundef %18, i8* noundef %21), !dbg !1178
  %22 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1184
  %23 = bitcast %struct.smr_none_retire_info_t* %22 to i8*, !dbg !1184
  call void @free(i8* noundef %23) #6, !dbg !1185
  ret i1 true, !dbg !1186
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @trace_verify(%struct.trace_s* noundef %0, i1 (%struct.trace_unit_s*)* noundef %1) #0 !dbg !1187 {
  %3 = alloca i1, align 1
  %4 = alloca %struct.trace_s*, align 8
  %5 = alloca i1 (%struct.trace_unit_s*)*, align 8
  %6 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !1190, metadata !DIExpression()), !dbg !1191
  store i1 (%struct.trace_unit_s*)* %1, i1 (%struct.trace_unit_s*)** %5, align 8
  call void @llvm.dbg.declare(metadata i1 (%struct.trace_unit_s*)** %5, metadata !1192, metadata !DIExpression()), !dbg !1193
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1194, metadata !DIExpression()), !dbg !1195
  store i64 0, i64* %6, align 8, !dbg !1195
  %7 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1196
  %8 = icmp ne %struct.trace_s* %7, null, !dbg !1196
  br i1 %8, label %9, label %10, !dbg !1199

9:                                                ; preds = %2
  br label %11, !dbg !1199

10:                                               ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 214, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #5, !dbg !1196
  unreachable, !dbg !1196

11:                                               ; preds = %9
  %12 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1200
  %13 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %12, i32 0, i32 3, !dbg !1200
  %14 = load i8, i8* %13, align 8, !dbg !1200
  %15 = trunc i8 %14 to i1, !dbg !1200
  br i1 %15, label %16, label %17, !dbg !1203

16:                                               ; preds = %11
  br label %18, !dbg !1203

17:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 215, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #5, !dbg !1200
  unreachable, !dbg !1200

18:                                               ; preds = %16
  %19 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %5, align 8, !dbg !1204
  %20 = icmp ne i1 (%struct.trace_unit_s*)* %19, null, !dbg !1204
  br i1 %20, label %21, label %22, !dbg !1207

21:                                               ; preds = %18
  br label %23, !dbg !1207

22:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 216, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #5, !dbg !1204
  unreachable, !dbg !1204

23:                                               ; preds = %21
  store i64 0, i64* %6, align 8, !dbg !1208
  br label %24, !dbg !1210

24:                                               ; preds = %42, %23
  %25 = load i64, i64* %6, align 8, !dbg !1211
  %26 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1213
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 1, !dbg !1214
  %28 = load i64, i64* %27, align 8, !dbg !1214
  %29 = icmp ult i64 %25, %28, !dbg !1215
  br i1 %29, label %30, label %45, !dbg !1216

30:                                               ; preds = %24
  %31 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %5, align 8, !dbg !1217
  %32 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1220
  %33 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %32, i32 0, i32 0, !dbg !1221
  %34 = load %struct.trace_unit_s*, %struct.trace_unit_s** %33, align 8, !dbg !1221
  %35 = load i64, i64* %6, align 8, !dbg !1222
  %36 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %34, i64 %35, !dbg !1220
  %37 = call zeroext i1 %31(%struct.trace_unit_s* noundef %36), !dbg !1217
  %38 = zext i1 %37 to i32, !dbg !1217
  %39 = icmp eq i32 %38, 0, !dbg !1223
  br i1 %39, label %40, label %41, !dbg !1224

40:                                               ; preds = %30
  store i1 false, i1* %3, align 1, !dbg !1225
  br label %46, !dbg !1225

41:                                               ; preds = %30
  br label %42, !dbg !1227

42:                                               ; preds = %41
  %43 = load i64, i64* %6, align 8, !dbg !1228
  %44 = add i64 %43, 1, !dbg !1228
  store i64 %44, i64* %6, align 8, !dbg !1228
  br label %24, !dbg !1229, !llvm.loop !1230

45:                                               ; preds = %24
  store i1 true, i1* %3, align 1, !dbg !1232
  br label %46, !dbg !1232

46:                                               ; preds = %45, %40
  %47 = load i1, i1* %3, align 1, !dbg !1233
  ret i1 %47, !dbg !1233
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_destroy(%struct.trace_s* noundef %0) #0 !dbg !1234 {
  %2 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %2, metadata !1237, metadata !DIExpression()), !dbg !1238
  %3 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1239
  %4 = icmp ne %struct.trace_s* %3, null, !dbg !1239
  br i1 %4, label %5, label %6, !dbg !1242

5:                                                ; preds = %1
  br label %7, !dbg !1242

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 99, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !1239
  unreachable, !dbg !1239

7:                                                ; preds = %5
  %8 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1243
  %9 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %8, i32 0, i32 3, !dbg !1243
  %10 = load i8, i8* %9, align 8, !dbg !1243
  %11 = trunc i8 %10 to i1, !dbg !1243
  br i1 %11, label %12, label %13, !dbg !1246

12:                                               ; preds = %7
  br label %14, !dbg !1246

13:                                               ; preds = %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !1243
  unreachable, !dbg !1243

14:                                               ; preds = %12
  %15 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1247
  %16 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %15, i32 0, i32 0, !dbg !1248
  %17 = load %struct.trace_unit_s*, %struct.trace_unit_s** %16, align 8, !dbg !1248
  %18 = bitcast %struct.trace_unit_s* %17 to i8*, !dbg !1247
  call void @free(i8* noundef %18) #6, !dbg !1249
  %19 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1250
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 3, !dbg !1251
  store i8 0, i8* %20, align 8, !dbg !1252
  ret void, !dbg !1253
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @vmem_malloc(i64 noundef %0) #0 !dbg !1254 {
  %2 = alloca i64, align 8
  %3 = alloca i8*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1257, metadata !DIExpression()), !dbg !1258
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1259, metadata !DIExpression()), !dbg !1260
  %4 = load i64, i64* %2, align 8, !dbg !1261
  %5 = call noalias i8* @malloc(i64 noundef %4) #6, !dbg !1262
  store i8* %5, i8** %3, align 8, !dbg !1260
  %6 = load i8*, i8** %3, align 8, !dbg !1263
  %7 = icmp ne i8* %6, null, !dbg !1263
  br i1 %7, label %8, label %9, !dbg !1265

8:                                                ; preds = %1
  call void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef @_g_vmem_alloc_count), !dbg !1266
  br label %10, !dbg !1268

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.14, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.22, i64 0, i64 0), i32 noundef 28, i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @__PRETTY_FUNCTION__.vmem_malloc, i64 0, i64 0)) #5, !dbg !1269
  unreachable, !dbg !1269

10:                                               ; preds = %8
  %11 = load i8*, i8** %3, align 8, !dbg !1273
  ret i8* %11, !dbg !1274
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_enter(i64 noundef %0) #0 !dbg !1275 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1276, metadata !DIExpression()), !dbg !1277
  br label %3, !dbg !1278

3:                                                ; preds = %1
  br label %4, !dbg !1279

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1281
  br label %6, !dbg !1281

6:                                                ; preds = %4
  br label %7, !dbg !1283

7:                                                ; preds = %6
  br label %8, !dbg !1281

8:                                                ; preds = %7
  br label %9, !dbg !1279

9:                                                ; preds = %8
  ret void, !dbg !1285
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_enq(%struct.vqueue_ub_s* noundef %0, %struct.vqueue_ub_node_s* noundef %1, i8* noundef %2) #0 !dbg !1286 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca %struct.vqueue_ub_node_s*, align 8
  %6 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !1289, metadata !DIExpression()), !dbg !1290
  store %struct.vqueue_ub_node_s* %1, %struct.vqueue_ub_node_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %5, metadata !1291, metadata !DIExpression()), !dbg !1292
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !1293, metadata !DIExpression()), !dbg !1294
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1295
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 0, !dbg !1296
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %8), !dbg !1297
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1298
  %10 = load i8*, i8** %6, align 8, !dbg !1299
  call void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %9, i8* noundef %10), !dbg !1300
  %11 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1301
  %12 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %11, i32 0, i32 3, !dbg !1302
  %13 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %12, align 8, !dbg !1302
  %14 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %13, i32 0, i32 1, !dbg !1303
  %15 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1304
  %16 = bitcast %struct.vqueue_ub_node_s* %15 to i8*, !dbg !1304
  call void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %14, i8* noundef %16), !dbg !1305
  %17 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1306
  %18 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1307
  %19 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %18, i32 0, i32 3, !dbg !1308
  store %struct.vqueue_ub_node_s* %17, %struct.vqueue_ub_node_s** %19, align 8, !dbg !1309
  %20 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1310
  %21 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %20, i32 0, i32 0, !dbg !1311
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %21), !dbg !1312
  ret void, !dbg !1313
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_exit(i64 noundef %0) #0 !dbg !1314 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1315, metadata !DIExpression()), !dbg !1316
  br label %3, !dbg !1317

3:                                                ; preds = %1
  br label %4, !dbg !1318

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1320
  br label %6, !dbg !1320

6:                                                ; preds = %4
  br label %7, !dbg !1322

7:                                                ; preds = %6
  br label %8, !dbg !1320

8:                                                ; preds = %7
  br label %9, !dbg !1318

9:                                                ; preds = %8
  ret void, !dbg !1324
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1325 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1326, metadata !DIExpression()), !dbg !1327
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1328, metadata !DIExpression()), !dbg !1329
  %5 = load i8*, i8** %4, align 8, !dbg !1330
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !1331
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !1332
  %8 = load i8*, i8** %7, align 8, !dbg !1332
  call void asm sideeffect "stlr ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !1333, !srcloc !1334
  ret void, !dbg !1335
}

; Function Attrs: noinline nounwind uwtable
define internal void @_queue_retire(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !1336 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1337, metadata !DIExpression()), !dbg !1338
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1339, metadata !DIExpression()), !dbg !1340
  %5 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1341
  %6 = bitcast %struct.vqueue_ub_node_s* %5 to i8*, !dbg !1341
  call void @vmem_free(i8* noundef %6), !dbg !1342
  br label %7, !dbg !1343

7:                                                ; preds = %2
  br label %8, !dbg !1344

8:                                                ; preds = %7
  %9 = load i8*, i8** %4, align 8, !dbg !1346
  br label %10, !dbg !1346

10:                                               ; preds = %8
  br label %11, !dbg !1348

11:                                               ; preds = %10
  br label %12, !dbg !1346

12:                                               ; preds = %11
  br label %13, !dbg !1344

13:                                               ; preds = %12
  ret void, !dbg !1350
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @vqueue_ub_empty(%struct.vqueue_ub_s* noundef %0) #0 !dbg !1351 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !1354, metadata !DIExpression()), !dbg !1355
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1356, metadata !DIExpression()), !dbg !1357
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1357
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %4, metadata !1358, metadata !DIExpression()), !dbg !1359
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1359
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1360
  %6 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %5, i32 0, i32 1, !dbg !1361
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %6), !dbg !1362
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1363
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 2, !dbg !1364
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1364
  store %struct.vqueue_ub_node_s* %9, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1365
  %10 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1366
  %11 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %10, i32 0, i32 1, !dbg !1367
  %12 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %11), !dbg !1368
  %13 = bitcast i8* %12 to %struct.vqueue_ub_node_s*, !dbg !1369
  store %struct.vqueue_ub_node_s* %13, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1370
  %14 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1371
  %15 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %14, i32 0, i32 1, !dbg !1372
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %15), !dbg !1373
  %16 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1374
  %17 = icmp eq %struct.vqueue_ub_node_s* %16, null, !dbg !1375
  ret i1 %17, !dbg !1376
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!165, !166, !167, !168, !169, !170, !171}
!llvm.ident = !{!172}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "_g_vmem_alloc_count", scope: !2, file: !79, line: 14, type: !80, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !76, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/unbounded_queue_verify.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "0e469bf9879777a23b2ea686edfbbfe8")
!4 = !{!5, !10, !13, !14, !31, !43, !48}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsize_t", file: !6, line: 43, baseType: !7)
!6 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !8, line: 46, baseType: !9)
!8 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!9 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !6, line: 37, baseType: !11)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !12, line: 90, baseType: !9)
!12 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "run_info_t", file: !16, line: 38, baseType: !17)
!16 = !DIFile(filename: "utils/include/test/thread_launcher.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "b854c1934ab1739fab93f88f22662d53")
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !16, line: 33, size: 256, elements: !18)
!18 = !{!19, !22, !23, !26}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "t", scope: !17, file: !16, line: 34, baseType: !20, size: 64)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !21, line: 27, baseType: !9)
!21 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!22 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !17, file: !16, line: 35, baseType: !5, size: 64, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "assign_me_to_core", scope: !17, file: !16, line: 36, baseType: !24, size: 8, offset: 128)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !6, line: 44, baseType: !25)
!25 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "run_fun", scope: !17, file: !16, line: 37, baseType: !27, size: 64, offset: 192)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "thread_fun_t", file: !16, line: 30, baseType: !28)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!29 = !DISubroutineType(types: !30)
!30 = !{!13, !13}
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "vqueue_ub_node_t", file: !33, line: 39, baseType: !34)
!33 = !DIFile(filename: "datastruct/queue/unbounded/include/vsync/queue/unbounded_queue_total.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "b4e848a3266a7fc151b6fc5ae8d41cb4")
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vqueue_ub_node_s", file: !33, line: 36, size: 128, elements: !35)
!35 = !{!36, !37}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !34, file: !33, line: 37, baseType: !13, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !34, file: !33, line: 38, baseType: !38, size: 64, align: 64, offset: 64)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomicptr_t", file: !39, line: 44, baseType: !40)
!39 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomicptr_s", file: !39, line: 42, size: 64, align: 64, elements: !41)
!41 = !{!42}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !40, file: !39, line: 43, baseType: !13, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "print_fun_t", file: !44, line: 227, baseType: !45)
!44 = !DIFile(filename: "datastruct/queue/unbounded/include/test/queue/ub/queue_interface.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1ac49a72c99bae51c524b5cddaa9bf59")
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!46 = !DISubroutineType(types: !47)
!47 = !{null, !13}
!48 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "smr_none_retire_info_t", file: !50, line: 21, baseType: !51)
!50 = !DIFile(filename: "memory/smr/include/test/smr/ismr_none.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "82ae29b5d69fc210cc0afc11677b0a3d")
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !50, line: 17, size: 192, elements: !52)
!52 = !{!53, !74, !75}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "address", scope: !51, file: !50, line: 18, baseType: !54, size: 64)
!54 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !55, size: 64)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "smr_node_t", file: !56, line: 25, baseType: !57)
!56 = !DIFile(filename: "memory/smr/include/vsync/smr/internal/smr_node.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "33b22eef5fa32f451294d19fc9760563")
!57 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "smr_node_s", file: !56, line: 19, size: 256, elements: !58)
!58 = !{!59, !65, !67, !73}
!59 = !DIDerivedType(tag: DW_TAG_member, name: "core", scope: !57, file: !56, line: 20, baseType: !60, size: 64)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "smr_node_core_t", file: !56, line: 17, baseType: !61)
!61 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "smr_node_core_s", file: !56, line: 15, size: 64, elements: !62)
!62 = !{!63}
!63 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !61, file: !56, line: 16, baseType: !64, size: 64)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !57, file: !56, line: 21, baseType: !66, size: 32, offset: 64)
!66 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "destroy_fun", scope: !57, file: !56, line: 23, baseType: !68, size: 64, offset: 128)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "smr_node_destroy_fun", file: !56, line: 13, baseType: !69)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!70 = !DISubroutineType(types: !71)
!71 = !{null, !72, !13}
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "destroy_fun_arg", scope: !57, file: !56, line: 24, baseType: !13, size: 64, offset: 192)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "callback", scope: !51, file: !50, line: 19, baseType: !68, size: 64, offset: 64)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "args", scope: !51, file: !50, line: 20, baseType: !13, size: 64, offset: 128)
!76 = !{!0, !77, !89, !92, !95, !148, !160}
!77 = !DIGlobalVariableExpression(var: !78, expr: !DIExpression())
!78 = distinct !DIGlobalVariable(name: "_g_vmem_free_count", scope: !2, file: !79, line: 15, type: !80, isLocal: false, isDefinition: true)
!79 = !DIFile(filename: "utils/include/test/vmem_stdlib.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "8ea894a152afbfd198826e45bdb67542")
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic64_t", file: !39, line: 39, baseType: !81)
!81 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic64_s", file: !39, line: 37, size: 64, align: 64, elements: !82)
!82 = !{!83}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !81, file: !39, line: 38, baseType: !84, size: 64)
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint64_t", file: !6, line: 36, baseType: !85)
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !86, line: 27, baseType: !87)
!86 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !88, line: 45, baseType: !9)
!88 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!89 = !DIGlobalVariableExpression(var: !90, expr: !DIExpression())
!90 = distinct !DIGlobalVariable(name: "g_len", scope: !2, file: !91, line: 29, type: !5, isLocal: false, isDefinition: true)
!91 = !DIFile(filename: "datastruct/queue/unbounded/verify/unbounded_queue_verify.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "0e469bf9879777a23b2ea686edfbbfe8")
!92 = !DIGlobalVariableExpression(var: !93, expr: !DIExpression())
!93 = distinct !DIGlobalVariable(name: "deq_succeeded", scope: !2, file: !94, line: 13, type: !24, isLocal: false, isDefinition: true)
!94 = !DIFile(filename: "datastruct/queue/unbounded/verify/test_case_6.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "f94b5c2581483d1ed803406957afb965")
!95 = !DIGlobalVariableExpression(var: !96, expr: !DIExpression())
!96 = distinct !DIGlobalVariable(name: "global_trace", scope: !2, file: !50, line: 15, type: !97, isLocal: false, isDefinition: true)
!97 = !DIDerivedType(tag: DW_TAG_typedef, name: "locked_trace_t", file: !98, line: 11, baseType: !99)
!98 = !DIFile(filename: "utils/include/test/locked_trace.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "6b9b066c8ea09bc73550cef772f1c7ca")
!99 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "locked_trace_s", file: !98, line: 8, size: 576, elements: !100)
!100 = !{!101, !116}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "trace", scope: !99, file: !98, line: 9, baseType: !102, size: 256)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_t", file: !103, line: 23, baseType: !104)
!103 = !DIFile(filename: "utils/include/test/trace_manager.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "ef0cfa2f64930baab6e03245b4188b52")
!104 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_s", file: !103, line: 18, size: 256, elements: !105)
!105 = !{!106, !113, !114, !115}
!106 = !DIDerivedType(tag: DW_TAG_member, name: "units", scope: !104, file: !103, line: 19, baseType: !107, size: 64)
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !108, size: 64)
!108 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_unit_t", file: !103, line: 16, baseType: !109)
!109 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_unit_s", file: !103, line: 13, size: 128, elements: !110)
!110 = !{!111, !112}
!111 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !109, file: !103, line: 14, baseType: !10, size: 64)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !109, file: !103, line: 15, baseType: !5, size: 64, offset: 64)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !104, file: !103, line: 20, baseType: !5, size: 64, offset: 64)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "capacity", scope: !104, file: !103, line: 21, baseType: !5, size: 64, offset: 128)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "initialized", scope: !104, file: !103, line: 22, baseType: !24, size: 8, offset: 192)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !99, file: !98, line: 10, baseType: !117, size: 320, offset: 256)
!117 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !21, line: 72, baseType: !118)
!118 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !21, line: 67, size: 320, elements: !119)
!119 = !{!120, !141, !146}
!120 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !118, file: !21, line: 69, baseType: !121, size: 320)
!121 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !122, line: 22, size: 320, elements: !123)
!122 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "584baedd80e6041b81caae7f496091c0")
!123 = !{!124, !125, !127, !128, !129, !130, !132, !133}
!124 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !121, file: !122, line: 24, baseType: !66, size: 32)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !121, file: !122, line: 25, baseType: !126, size: 32, offset: 32)
!126 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !121, file: !122, line: 26, baseType: !66, size: 32, offset: 64)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !121, file: !122, line: 28, baseType: !126, size: 32, offset: 96)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !121, file: !122, line: 32, baseType: !66, size: 32, offset: 128)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !121, file: !122, line: 34, baseType: !131, size: 16, offset: 160)
!131 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !121, file: !122, line: 35, baseType: !131, size: 16, offset: 176)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !121, file: !122, line: 36, baseType: !134, size: 128, offset: 192)
!134 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !135, line: 55, baseType: !136)
!135 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "04c81e86d34dad9c99ad006d32e47a0d")
!136 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !135, line: 51, size: 128, elements: !137)
!137 = !{!138, !140}
!138 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !136, file: !135, line: 53, baseType: !139, size: 64)
!139 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !136, size: 64)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !136, file: !135, line: 54, baseType: !139, size: 64, offset: 64)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !118, file: !21, line: 70, baseType: !142, size: 320)
!142 = !DICompositeType(tag: DW_TAG_array_type, baseType: !143, size: 320, elements: !144)
!143 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!144 = !{!145}
!145 = !DISubrange(count: 40)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !118, file: !21, line: 71, baseType: !147, size: 64)
!147 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!148 = !DIGlobalVariableExpression(var: !149, expr: !DIExpression())
!149 = distinct !DIGlobalVariable(name: "g_queue", scope: !2, file: !91, line: 25, type: !150, isLocal: false, isDefinition: true)
!150 = !DIDerivedType(tag: DW_TAG_typedef, name: "queue_t", file: !44, line: 41, baseType: !151)
!151 = !DIDerivedType(tag: DW_TAG_typedef, name: "vqueue_ub_t", file: !33, line: 47, baseType: !152)
!152 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vqueue_ub_s", file: !33, line: 41, size: 896, elements: !153)
!153 = !{!154, !156, !157, !158, !159}
!154 = !DIDerivedType(tag: DW_TAG_member, name: "enq_l", scope: !152, file: !33, line: 42, baseType: !155, size: 320)
!155 = !DIDerivedType(tag: DW_TAG_typedef, name: "queue_lock_t", file: !33, line: 31, baseType: !117)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "deq_l", scope: !152, file: !33, line: 43, baseType: !155, size: 320, offset: 320)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !152, file: !33, line: 44, baseType: !31, size: 64, offset: 640)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !152, file: !33, line: 45, baseType: !31, size: 64, offset: 704)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "sentinel", scope: !152, file: !33, line: 46, baseType: !32, size: 128, offset: 768)
!160 = !DIGlobalVariableExpression(var: !161, expr: !DIExpression())
!161 = distinct !DIGlobalVariable(name: "g_final_state", scope: !2, file: !91, line: 28, type: !162, isLocal: false, isDefinition: true)
!162 = !DICompositeType(tag: DW_TAG_array_type, baseType: !84, size: 320, elements: !163)
!163 = !{!164}
!164 = !DISubrange(count: 5)
!165 = !{i32 7, !"Dwarf Version", i32 5}
!166 = !{i32 2, !"Debug Info Version", i32 3}
!167 = !{i32 1, !"wchar_size", i32 4}
!168 = !{i32 7, !"PIC Level", i32 2}
!169 = !{i32 7, !"PIE Level", i32 2}
!170 = !{i32 7, !"uwtable", i32 1}
!171 = !{i32 7, !"frame-pointer", i32 2}
!172 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!173 = distinct !DISubprogram(name: "t1", scope: !94, file: !94, line: 15, type: !174, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!174 = !DISubroutineType(types: !175)
!175 = !{null, !5}
!176 = !{}
!177 = !DILocalVariable(name: "tid", arg: 1, scope: !173, file: !94, line: 15, type: !5)
!178 = !DILocation(line: 15, column: 12, scope: !173)
!179 = !DILocalVariable(name: "node", scope: !173, file: !94, line: 17, type: !180)
!180 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !181, size: 64)
!181 = !DIDerivedType(tag: DW_TAG_typedef, name: "data_t", file: !44, line: 49, baseType: !182)
!182 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "data_s", file: !44, line: 46, size: 128, elements: !183)
!183 = !{!184, !185}
!184 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !182, file: !44, line: 47, baseType: !84, size: 64)
!185 = !DIDerivedType(tag: DW_TAG_member, name: "lbl", scope: !182, file: !44, line: 48, baseType: !143, size: 8, offset: 64)
!186 = !DILocation(line: 17, column: 13, scope: !173)
!187 = !DILocation(line: 19, column: 9, scope: !173)
!188 = !DILocation(line: 19, column: 5, scope: !173)
!189 = !DILocation(line: 21, column: 16, scope: !173)
!190 = !DILocation(line: 21, column: 12, scope: !173)
!191 = !DILocation(line: 21, column: 10, scope: !173)
!192 = !DILocation(line: 22, column: 5, scope: !193)
!193 = distinct !DILexicalBlock(scope: !194, file: !94, line: 22, column: 5)
!194 = distinct !DILexicalBlock(scope: !173, file: !94, line: 22, column: 5)
!195 = !DILocation(line: 22, column: 5, scope: !194)
!196 = !DILocation(line: 23, column: 5, scope: !197)
!197 = distinct !DILexicalBlock(scope: !198, file: !94, line: 23, column: 5)
!198 = distinct !DILexicalBlock(scope: !173, file: !94, line: 23, column: 5)
!199 = !DILocation(line: 23, column: 5, scope: !198)
!200 = !DILocation(line: 24, column: 10, scope: !173)
!201 = !DILocation(line: 24, column: 5, scope: !173)
!202 = !DILocation(line: 26, column: 16, scope: !173)
!203 = !DILocation(line: 26, column: 12, scope: !173)
!204 = !DILocation(line: 26, column: 10, scope: !173)
!205 = !DILocation(line: 27, column: 5, scope: !206)
!206 = distinct !DILexicalBlock(scope: !207, file: !94, line: 27, column: 5)
!207 = distinct !DILexicalBlock(scope: !173, file: !94, line: 27, column: 5)
!208 = !DILocation(line: 27, column: 5, scope: !207)
!209 = !DILocation(line: 28, column: 5, scope: !210)
!210 = distinct !DILexicalBlock(scope: !211, file: !94, line: 28, column: 5)
!211 = distinct !DILexicalBlock(scope: !173, file: !94, line: 28, column: 5)
!212 = !DILocation(line: 28, column: 5, scope: !211)
!213 = !DILocation(line: 29, column: 10, scope: !173)
!214 = !DILocation(line: 29, column: 5, scope: !173)
!215 = !DILocation(line: 30, column: 1, scope: !173)
!216 = distinct !DISubprogram(name: "enq", scope: !91, file: !91, line: 94, type: !217, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!217 = !DISubroutineType(types: !218)
!218 = !{null, !5, !84, !143}
!219 = !DILocalVariable(name: "tid", arg: 1, scope: !216, file: !91, line: 94, type: !5)
!220 = !DILocation(line: 94, column: 13, scope: !216)
!221 = !DILocalVariable(name: "k", arg: 2, scope: !216, file: !91, line: 94, type: !84)
!222 = !DILocation(line: 94, column: 28, scope: !216)
!223 = !DILocalVariable(name: "lbl", arg: 3, scope: !216, file: !91, line: 94, type: !143)
!224 = !DILocation(line: 94, column: 36, scope: !216)
!225 = !DILocation(line: 96, column: 15, scope: !216)
!226 = !DILocation(line: 96, column: 30, scope: !216)
!227 = !DILocation(line: 96, column: 33, scope: !216)
!228 = !DILocation(line: 96, column: 5, scope: !216)
!229 = !DILocation(line: 97, column: 1, scope: !216)
!230 = distinct !DISubprogram(name: "deq", scope: !91, file: !91, line: 100, type: !231, scopeLine: 101, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!231 = !DISubroutineType(types: !232)
!232 = !{!180, !5}
!233 = !DILocalVariable(name: "tid", arg: 1, scope: !230, file: !91, line: 100, type: !5)
!234 = !DILocation(line: 100, column: 13, scope: !230)
!235 = !DILocation(line: 102, column: 22, scope: !230)
!236 = !DILocation(line: 102, column: 12, scope: !230)
!237 = !DILocation(line: 102, column: 5, scope: !230)
!238 = distinct !DISubprogram(name: "t2", scope: !94, file: !94, line: 37, type: !174, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!239 = !DILocalVariable(name: "tid", arg: 1, scope: !238, file: !94, line: 37, type: !5)
!240 = !DILocation(line: 37, column: 12, scope: !238)
!241 = !DILocation(line: 39, column: 9, scope: !238)
!242 = !DILocation(line: 39, column: 5, scope: !238)
!243 = !DILocation(line: 40, column: 1, scope: !238)
!244 = distinct !DISubprogram(name: "t3", scope: !94, file: !94, line: 46, type: !174, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!245 = !DILocalVariable(name: "tid", arg: 1, scope: !244, file: !94, line: 46, type: !5)
!246 = !DILocation(line: 46, column: 12, scope: !244)
!247 = !DILocation(line: 48, column: 17, scope: !244)
!248 = !DILocation(line: 48, column: 5, scope: !244)
!249 = !DILocation(line: 49, column: 1, scope: !244)
!250 = distinct !DISubprogram(name: "queue_clean", scope: !44, file: !44, line: 248, type: !174, scopeLine: 249, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!251 = !DILocalVariable(name: "tid", arg: 1, scope: !250, file: !44, line: 248, type: !5)
!252 = !DILocation(line: 248, column: 21, scope: !250)
!253 = !DILocation(line: 250, column: 18, scope: !250)
!254 = !DILocation(line: 250, column: 5, scope: !250)
!255 = !DILocation(line: 251, column: 1, scope: !250)
!256 = distinct !DISubprogram(name: "verify", scope: !94, file: !94, line: 51, type: !257, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!257 = !DISubroutineType(types: !258)
!258 = !{null}
!259 = !DILocation(line: 53, column: 5, scope: !260)
!260 = distinct !DILexicalBlock(scope: !261, file: !94, line: 53, column: 5)
!261 = distinct !DILexicalBlock(scope: !256, file: !94, line: 53, column: 5)
!262 = !DILocation(line: 53, column: 5, scope: !261)
!263 = !DILocation(line: 54, column: 1, scope: !256)
!264 = distinct !DISubprogram(name: "main", scope: !91, file: !91, line: 50, type: !265, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!265 = !DISubroutineType(types: !266)
!266 = !{!66}
!267 = !DILocation(line: 52, column: 5, scope: !264)
!268 = !DILocation(line: 53, column: 5, scope: !264)
!269 = !DILocation(line: 55, column: 5, scope: !264)
!270 = !DILocation(line: 56, column: 5, scope: !264)
!271 = !DILocation(line: 57, column: 5, scope: !264)
!272 = !DILocation(line: 58, column: 5, scope: !273)
!273 = distinct !DILexicalBlock(scope: !274, file: !91, line: 58, column: 5)
!274 = distinct !DILexicalBlock(scope: !264, file: !91, line: 58, column: 5)
!275 = !DILocation(line: 58, column: 5, scope: !274)
!276 = !DILocation(line: 59, column: 5, scope: !264)
!277 = distinct !DISubprogram(name: "init", scope: !91, file: !91, line: 63, type: !257, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!278 = !DILocation(line: 65, column: 5, scope: !277)
!279 = !DILocation(line: 70, column: 5, scope: !277)
!280 = !DILocation(line: 73, column: 5, scope: !277)
!281 = !DILocalVariable(name: "data", scope: !277, file: !91, line: 74, type: !13)
!282 = !DILocation(line: 74, column: 11, scope: !277)
!283 = !DILocation(line: 74, column: 18, scope: !277)
!284 = !DILocation(line: 75, column: 10, scope: !277)
!285 = !DILocation(line: 75, column: 5, scope: !277)
!286 = !DILocalVariable(name: "lbl", scope: !277, file: !91, line: 79, type: !143)
!287 = !DILocation(line: 79, column: 10, scope: !277)
!288 = !DILocalVariable(name: "i", scope: !289, file: !91, line: 80, type: !5)
!289 = distinct !DILexicalBlock(scope: !277, file: !91, line: 80, column: 5)
!290 = !DILocation(line: 80, column: 18, scope: !289)
!291 = !DILocation(line: 80, column: 10, scope: !289)
!292 = !DILocation(line: 80, column: 25, scope: !293)
!293 = distinct !DILexicalBlock(scope: !289, file: !91, line: 80, column: 5)
!294 = !DILocation(line: 80, column: 27, scope: !293)
!295 = !DILocation(line: 80, column: 5, scope: !289)
!296 = !DILocation(line: 81, column: 16, scope: !297)
!297 = distinct !DILexicalBlock(scope: !293, file: !91, line: 80, column: 61)
!298 = !DILocation(line: 81, column: 19, scope: !297)
!299 = !DILocation(line: 81, column: 9, scope: !297)
!300 = !DILocation(line: 82, column: 5, scope: !297)
!301 = !DILocation(line: 80, column: 50, scope: !293)
!302 = !DILocation(line: 80, column: 57, scope: !293)
!303 = !DILocation(line: 80, column: 5, scope: !293)
!304 = distinct !{!304, !295, !305, !306}
!305 = !DILocation(line: 82, column: 5, scope: !289)
!306 = !{!"llvm.loop.mustprogress"}
!307 = !DILocation(line: 84, column: 5, scope: !277)
!308 = !DILocation(line: 85, column: 1, scope: !277)
!309 = distinct !DISubprogram(name: "launch_threads", scope: !16, file: !16, line: 111, type: !310, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!310 = !DISubroutineType(types: !311)
!311 = !{null, !5, !27}
!312 = !DILocalVariable(name: "thread_count", arg: 1, scope: !309, file: !16, line: 111, type: !5)
!313 = !DILocation(line: 111, column: 24, scope: !309)
!314 = !DILocalVariable(name: "fun", arg: 2, scope: !309, file: !16, line: 111, type: !27)
!315 = !DILocation(line: 111, column: 51, scope: !309)
!316 = !DILocalVariable(name: "threads", scope: !309, file: !16, line: 113, type: !14)
!317 = !DILocation(line: 113, column: 17, scope: !309)
!318 = !DILocation(line: 113, column: 55, scope: !309)
!319 = !DILocation(line: 113, column: 53, scope: !309)
!320 = !DILocation(line: 113, column: 27, scope: !309)
!321 = !DILocation(line: 115, column: 20, scope: !309)
!322 = !DILocation(line: 115, column: 29, scope: !309)
!323 = !DILocation(line: 115, column: 43, scope: !309)
!324 = !DILocation(line: 115, column: 5, scope: !309)
!325 = !DILocation(line: 117, column: 19, scope: !309)
!326 = !DILocation(line: 117, column: 28, scope: !309)
!327 = !DILocation(line: 117, column: 5, scope: !309)
!328 = !DILocation(line: 119, column: 10, scope: !309)
!329 = !DILocation(line: 119, column: 5, scope: !309)
!330 = !DILocation(line: 120, column: 1, scope: !309)
!331 = distinct !DISubprogram(name: "run", scope: !91, file: !91, line: 126, type: !29, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!332 = !DILocalVariable(name: "args", arg: 1, scope: !331, file: !91, line: 126, type: !13)
!333 = !DILocation(line: 126, column: 11, scope: !331)
!334 = !DILocalVariable(name: "tid", scope: !331, file: !91, line: 128, type: !5)
!335 = !DILocation(line: 128, column: 13, scope: !331)
!336 = !DILocation(line: 128, column: 40, scope: !331)
!337 = !DILocation(line: 128, column: 28, scope: !331)
!338 = !DILocation(line: 129, column: 20, scope: !331)
!339 = !DILocation(line: 129, column: 5, scope: !331)
!340 = !DILocation(line: 130, column: 13, scope: !331)
!341 = !DILocation(line: 130, column: 5, scope: !331)
!342 = !DILocation(line: 132, column: 16, scope: !343)
!343 = distinct !DILexicalBlock(scope: !331, file: !91, line: 130, column: 18)
!344 = !DILocation(line: 132, column: 13, scope: !343)
!345 = !DILocation(line: 133, column: 13, scope: !343)
!346 = !DILocation(line: 135, column: 16, scope: !343)
!347 = !DILocation(line: 135, column: 13, scope: !343)
!348 = !DILocation(line: 136, column: 13, scope: !343)
!349 = !DILocation(line: 138, column: 16, scope: !343)
!350 = !DILocation(line: 138, column: 13, scope: !343)
!351 = !DILocation(line: 139, column: 13, scope: !343)
!352 = !DILocation(line: 141, column: 13, scope: !353)
!353 = distinct !DILexicalBlock(scope: !343, file: !91, line: 141, column: 13)
!354 = !DILocation(line: 141, column: 13, scope: !355)
!355 = distinct !DILexicalBlock(scope: !353, file: !91, line: 141, column: 13)
!356 = !DILocation(line: 142, column: 5, scope: !343)
!357 = !DILocation(line: 143, column: 22, scope: !331)
!358 = !DILocation(line: 143, column: 5, scope: !331)
!359 = !DILocation(line: 144, column: 5, scope: !331)
!360 = distinct !DISubprogram(name: "queue_print", scope: !44, file: !44, line: 235, type: !361, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!361 = !DISubroutineType(types: !362)
!362 = !{null, !363, !43}
!363 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !151, size: 64)
!364 = !DILocalVariable(name: "q", arg: 1, scope: !360, file: !44, line: 235, type: !363)
!365 = !DILocation(line: 235, column: 26, scope: !360)
!366 = !DILocalVariable(name: "print", arg: 2, scope: !360, file: !44, line: 235, type: !43)
!367 = !DILocation(line: 235, column: 41, scope: !360)
!368 = !DILocation(line: 237, column: 28, scope: !360)
!369 = !DILocation(line: 237, column: 56, scope: !360)
!370 = !DILocation(line: 237, column: 48, scope: !360)
!371 = !DILocation(line: 237, column: 5, scope: !360)
!372 = !DILocation(line: 238, column: 1, scope: !360)
!373 = distinct !DISubprogram(name: "get_final_state", scope: !91, file: !91, line: 117, type: !46, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!374 = !DILocalVariable(name: "data", arg: 1, scope: !373, file: !91, line: 117, type: !13)
!375 = !DILocation(line: 117, column: 23, scope: !373)
!376 = !DILocation(line: 119, column: 5, scope: !377)
!377 = distinct !DILexicalBlock(scope: !378, file: !91, line: 119, column: 5)
!378 = distinct !DILexicalBlock(scope: !373, file: !91, line: 119, column: 5)
!379 = !DILocation(line: 119, column: 5, scope: !378)
!380 = !DILocalVariable(name: "node", scope: !373, file: !91, line: 120, type: !180)
!381 = !DILocation(line: 120, column: 13, scope: !373)
!382 = !DILocation(line: 120, column: 20, scope: !373)
!383 = !DILocation(line: 121, column: 5, scope: !384)
!384 = distinct !DILexicalBlock(scope: !385, file: !91, line: 121, column: 5)
!385 = distinct !DILexicalBlock(scope: !373, file: !91, line: 121, column: 5)
!386 = !DILocation(line: 121, column: 5, scope: !385)
!387 = !DILocation(line: 122, column: 30, scope: !373)
!388 = !DILocation(line: 122, column: 36, scope: !373)
!389 = !DILocation(line: 122, column: 24, scope: !373)
!390 = !DILocation(line: 122, column: 5, scope: !373)
!391 = !DILocation(line: 122, column: 28, scope: !373)
!392 = !DILocation(line: 123, column: 1, scope: !373)
!393 = distinct !DISubprogram(name: "destroy", scope: !91, file: !91, line: 88, type: !257, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!394 = !DILocation(line: 90, column: 5, scope: !393)
!395 = !DILocation(line: 91, column: 1, scope: !393)
!396 = distinct !DISubprogram(name: "vmem_no_leak", scope: !79, file: !79, line: 133, type: !397, scopeLine: 134, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!397 = !DISubroutineType(types: !398)
!398 = !{!24}
!399 = !DILocalVariable(name: "alloc_count", scope: !396, file: !79, line: 135, type: !84)
!400 = !DILocation(line: 135, column: 15, scope: !396)
!401 = !DILocation(line: 135, column: 29, scope: !396)
!402 = !DILocalVariable(name: "free_count", scope: !396, file: !79, line: 136, type: !84)
!403 = !DILocation(line: 136, column: 15, scope: !396)
!404 = !DILocation(line: 136, column: 29, scope: !396)
!405 = !DILocation(line: 137, column: 13, scope: !396)
!406 = !DILocation(line: 137, column: 28, scope: !396)
!407 = !DILocation(line: 137, column: 25, scope: !396)
!408 = !DILocation(line: 137, column: 5, scope: !396)
!409 = distinct !DISubprogram(name: "queue_init", scope: !44, file: !44, line: 110, type: !410, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!410 = !DISubroutineType(types: !411)
!411 = !{null, !412}
!412 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !150, size: 64)
!413 = !DILocalVariable(name: "q", arg: 1, scope: !409, file: !44, line: 110, type: !412)
!414 = !DILocation(line: 110, column: 21, scope: !409)
!415 = !DILocation(line: 112, column: 5, scope: !409)
!416 = !DILocation(line: 113, column: 20, scope: !409)
!417 = !DILocation(line: 113, column: 5, scope: !409)
!418 = !DILocation(line: 120, column: 1, scope: !409)
!419 = distinct !DISubprogram(name: "queue_register", scope: !44, file: !44, line: 123, type: !420, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!420 = !DISubroutineType(types: !421)
!421 = !{null, !5, !412}
!422 = !DILocalVariable(name: "tid", arg: 1, scope: !419, file: !44, line: 123, type: !5)
!423 = !DILocation(line: 123, column: 24, scope: !419)
!424 = !DILocalVariable(name: "q", arg: 2, scope: !419, file: !44, line: 123, type: !412)
!425 = !DILocation(line: 123, column: 38, scope: !419)
!426 = !DILocation(line: 125, column: 14, scope: !419)
!427 = !DILocation(line: 125, column: 5, scope: !419)
!428 = !DILocation(line: 126, column: 5, scope: !419)
!429 = !DILocation(line: 126, column: 5, scope: !430)
!430 = distinct !DILexicalBlock(scope: !419, file: !44, line: 126, column: 5)
!431 = !DILocation(line: 126, column: 5, scope: !432)
!432 = distinct !DILexicalBlock(scope: !430, file: !44, line: 126, column: 5)
!433 = !DILocation(line: 126, column: 5, scope: !434)
!434 = distinct !DILexicalBlock(scope: !432, file: !44, line: 126, column: 5)
!435 = !DILocation(line: 127, column: 1, scope: !419)
!436 = distinct !DISubprogram(name: "queue_deregister", scope: !44, file: !44, line: 139, type: !420, scopeLine: 140, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!437 = !DILocalVariable(name: "tid", arg: 1, scope: !436, file: !44, line: 139, type: !5)
!438 = !DILocation(line: 139, column: 26, scope: !436)
!439 = !DILocalVariable(name: "q", arg: 2, scope: !436, file: !44, line: 139, type: !412)
!440 = !DILocation(line: 139, column: 40, scope: !436)
!441 = !DILocation(line: 144, column: 16, scope: !436)
!442 = !DILocation(line: 144, column: 5, scope: !436)
!443 = !DILocation(line: 145, column: 5, scope: !436)
!444 = !DILocation(line: 145, column: 5, scope: !445)
!445 = distinct !DILexicalBlock(scope: !436, file: !44, line: 145, column: 5)
!446 = !DILocation(line: 145, column: 5, scope: !447)
!447 = distinct !DILexicalBlock(scope: !445, file: !44, line: 145, column: 5)
!448 = !DILocation(line: 145, column: 5, scope: !449)
!449 = distinct !DILexicalBlock(scope: !447, file: !44, line: 145, column: 5)
!450 = !DILocation(line: 146, column: 1, scope: !436)
!451 = distinct !DISubprogram(name: "queue_destroy", scope: !44, file: !44, line: 149, type: !410, scopeLine: 150, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!452 = !DILocalVariable(name: "q", arg: 1, scope: !451, file: !44, line: 149, type: !412)
!453 = !DILocation(line: 149, column: 24, scope: !451)
!454 = !DILocalVariable(name: "data", scope: !451, file: !44, line: 151, type: !13)
!455 = !DILocation(line: 151, column: 11, scope: !451)
!456 = !DILocation(line: 156, column: 5, scope: !451)
!457 = !DILocation(line: 156, column: 33, scope: !451)
!458 = !DILocation(line: 156, column: 19, scope: !451)
!459 = !DILocation(line: 156, column: 17, scope: !451)
!460 = !DILocation(line: 156, column: 59, scope: !451)
!461 = !DILocation(line: 157, column: 14, scope: !462)
!462 = distinct !DILexicalBlock(scope: !451, file: !44, line: 156, column: 65)
!463 = !DILocation(line: 157, column: 9, scope: !462)
!464 = distinct !{!464, !456, !465, !306}
!465 = !DILocation(line: 158, column: 5, scope: !451)
!466 = !DILocation(line: 159, column: 23, scope: !451)
!467 = !DILocation(line: 159, column: 5, scope: !451)
!468 = !DILocation(line: 165, column: 5, scope: !451)
!469 = !DILocation(line: 166, column: 5, scope: !470)
!470 = distinct !DILexicalBlock(scope: !471, file: !44, line: 166, column: 5)
!471 = distinct !DILexicalBlock(scope: !451, file: !44, line: 166, column: 5)
!472 = !DILocation(line: 166, column: 5, scope: !471)
!473 = !DILocation(line: 167, column: 1, scope: !451)
!474 = distinct !DISubprogram(name: "queue_enq", scope: !44, file: !44, line: 170, type: !475, scopeLine: 171, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!475 = !DISubroutineType(types: !476)
!476 = !{null, !5, !412, !84, !143}
!477 = !DILocalVariable(name: "tid", arg: 1, scope: !474, file: !44, line: 170, type: !5)
!478 = !DILocation(line: 170, column: 19, scope: !474)
!479 = !DILocalVariable(name: "q", arg: 2, scope: !474, file: !44, line: 170, type: !412)
!480 = !DILocation(line: 170, column: 33, scope: !474)
!481 = !DILocalVariable(name: "key", arg: 3, scope: !474, file: !44, line: 170, type: !84)
!482 = !DILocation(line: 170, column: 46, scope: !474)
!483 = !DILocalVariable(name: "lbl", arg: 4, scope: !474, file: !44, line: 170, type: !143)
!484 = !DILocation(line: 170, column: 56, scope: !474)
!485 = !DILocalVariable(name: "data", scope: !474, file: !44, line: 172, type: !180)
!486 = !DILocation(line: 172, column: 13, scope: !474)
!487 = !DILocation(line: 172, column: 20, scope: !474)
!488 = !DILocation(line: 173, column: 9, scope: !489)
!489 = distinct !DILexicalBlock(scope: !474, file: !44, line: 173, column: 9)
!490 = !DILocation(line: 173, column: 9, scope: !474)
!491 = !DILocation(line: 174, column: 31, scope: !492)
!492 = distinct !DILexicalBlock(scope: !489, file: !44, line: 173, column: 15)
!493 = !DILocation(line: 174, column: 9, scope: !492)
!494 = !DILocation(line: 174, column: 15, scope: !492)
!495 = !DILocation(line: 174, column: 29, scope: !492)
!496 = !DILocation(line: 175, column: 31, scope: !492)
!497 = !DILocation(line: 175, column: 9, scope: !492)
!498 = !DILocation(line: 175, column: 15, scope: !492)
!499 = !DILocation(line: 175, column: 29, scope: !492)
!500 = !DILocalVariable(name: "qnode", scope: !492, file: !44, line: 176, type: !501)
!501 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !502, size: 64)
!502 = !DIDerivedType(tag: DW_TAG_typedef, name: "queue_node_t", file: !44, line: 42, baseType: !32)
!503 = !DILocation(line: 176, column: 23, scope: !492)
!504 = !DILocation(line: 190, column: 17, scope: !492)
!505 = !DILocation(line: 190, column: 15, scope: !492)
!506 = !DILocation(line: 192, column: 20, scope: !492)
!507 = !DILocation(line: 192, column: 9, scope: !492)
!508 = !DILocation(line: 193, column: 23, scope: !492)
!509 = !DILocation(line: 193, column: 26, scope: !492)
!510 = !DILocation(line: 193, column: 33, scope: !492)
!511 = !DILocation(line: 193, column: 9, scope: !492)
!512 = !DILocation(line: 194, column: 19, scope: !492)
!513 = !DILocation(line: 194, column: 9, scope: !492)
!514 = !DILocation(line: 195, column: 5, scope: !492)
!515 = !DILocation(line: 196, column: 9, scope: !516)
!516 = distinct !DILexicalBlock(scope: !517, file: !44, line: 196, column: 9)
!517 = distinct !DILexicalBlock(scope: !518, file: !44, line: 196, column: 9)
!518 = distinct !DILexicalBlock(scope: !489, file: !44, line: 195, column: 12)
!519 = !DILocation(line: 198, column: 1, scope: !474)
!520 = distinct !DISubprogram(name: "queue_deq", scope: !44, file: !44, line: 219, type: !521, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!521 = !DISubroutineType(types: !522)
!522 = !{!13, !5, !412}
!523 = !DILocalVariable(name: "tid", arg: 1, scope: !520, file: !44, line: 219, type: !5)
!524 = !DILocation(line: 219, column: 19, scope: !520)
!525 = !DILocalVariable(name: "q", arg: 2, scope: !520, file: !44, line: 219, type: !412)
!526 = !DILocation(line: 219, column: 33, scope: !520)
!527 = !DILocation(line: 221, column: 16, scope: !520)
!528 = !DILocation(line: 221, column: 5, scope: !520)
!529 = !DILocalVariable(name: "data", scope: !520, file: !44, line: 222, type: !13)
!530 = !DILocation(line: 222, column: 11, scope: !520)
!531 = !DILocation(line: 222, column: 32, scope: !520)
!532 = !DILocation(line: 222, column: 58, scope: !520)
!533 = !DILocation(line: 222, column: 50, scope: !520)
!534 = !DILocation(line: 222, column: 18, scope: !520)
!535 = !DILocation(line: 223, column: 15, scope: !520)
!536 = !DILocation(line: 223, column: 5, scope: !520)
!537 = !DILocation(line: 224, column: 12, scope: !520)
!538 = !DILocation(line: 224, column: 5, scope: !520)
!539 = distinct !DISubprogram(name: "empty", scope: !91, file: !91, line: 106, type: !540, scopeLine: 107, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!540 = !DISubroutineType(types: !541)
!541 = !{!24, !5}
!542 = !DILocalVariable(name: "tid", arg: 1, scope: !539, file: !91, line: 106, type: !5)
!543 = !DILocation(line: 106, column: 15, scope: !539)
!544 = !DILocation(line: 108, column: 24, scope: !539)
!545 = !DILocation(line: 108, column: 12, scope: !539)
!546 = !DILocation(line: 108, column: 5, scope: !539)
!547 = distinct !DISubprogram(name: "queue_empty", scope: !44, file: !44, line: 210, type: !548, scopeLine: 211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!548 = !DISubroutineType(types: !549)
!549 = !{!24, !5, !412}
!550 = !DILocalVariable(name: "tid", arg: 1, scope: !547, file: !44, line: 210, type: !5)
!551 = !DILocation(line: 210, column: 21, scope: !547)
!552 = !DILocalVariable(name: "q", arg: 2, scope: !547, file: !44, line: 210, type: !412)
!553 = !DILocation(line: 210, column: 35, scope: !547)
!554 = !DILocation(line: 212, column: 16, scope: !547)
!555 = !DILocation(line: 212, column: 5, scope: !547)
!556 = !DILocalVariable(name: "empty", scope: !547, file: !44, line: 213, type: !24)
!557 = !DILocation(line: 213, column: 13, scope: !547)
!558 = !DILocation(line: 213, column: 37, scope: !547)
!559 = !DILocation(line: 213, column: 21, scope: !547)
!560 = !DILocation(line: 214, column: 15, scope: !547)
!561 = !DILocation(line: 214, column: 5, scope: !547)
!562 = !DILocation(line: 215, column: 12, scope: !547)
!563 = !DILocation(line: 215, column: 5, scope: !547)
!564 = distinct !DISubprogram(name: "ismr_recycle", scope: !50, file: !50, line: 114, type: !174, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!565 = !DILocalVariable(name: "tid", arg: 1, scope: !564, file: !50, line: 114, type: !5)
!566 = !DILocation(line: 114, column: 22, scope: !564)
!567 = !DILocation(line: 116, column: 5, scope: !564)
!568 = !DILocation(line: 116, column: 5, scope: !569)
!569 = distinct !DILexicalBlock(scope: !564, file: !50, line: 116, column: 5)
!570 = !DILocation(line: 116, column: 5, scope: !571)
!571 = distinct !DILexicalBlock(scope: !569, file: !50, line: 116, column: 5)
!572 = !DILocation(line: 116, column: 5, scope: !573)
!573 = distinct !DILexicalBlock(scope: !571, file: !50, line: 116, column: 5)
!574 = !DILocation(line: 117, column: 1, scope: !564)
!575 = distinct !DISubprogram(name: "create_threads", scope: !16, file: !16, line: 83, type: !576, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!576 = !DISubroutineType(types: !577)
!577 = !{null, !14, !5, !27, !24}
!578 = !DILocalVariable(name: "threads", arg: 1, scope: !575, file: !16, line: 83, type: !14)
!579 = !DILocation(line: 83, column: 28, scope: !575)
!580 = !DILocalVariable(name: "num_threads", arg: 2, scope: !575, file: !16, line: 83, type: !5)
!581 = !DILocation(line: 83, column: 45, scope: !575)
!582 = !DILocalVariable(name: "fun", arg: 3, scope: !575, file: !16, line: 83, type: !27)
!583 = !DILocation(line: 83, column: 71, scope: !575)
!584 = !DILocalVariable(name: "bind", arg: 4, scope: !575, file: !16, line: 84, type: !24)
!585 = !DILocation(line: 84, column: 24, scope: !575)
!586 = !DILocalVariable(name: "i", scope: !575, file: !16, line: 86, type: !5)
!587 = !DILocation(line: 86, column: 13, scope: !575)
!588 = !DILocation(line: 87, column: 12, scope: !589)
!589 = distinct !DILexicalBlock(scope: !575, file: !16, line: 87, column: 5)
!590 = !DILocation(line: 87, column: 10, scope: !589)
!591 = !DILocation(line: 87, column: 17, scope: !592)
!592 = distinct !DILexicalBlock(scope: !589, file: !16, line: 87, column: 5)
!593 = !DILocation(line: 87, column: 21, scope: !592)
!594 = !DILocation(line: 87, column: 19, scope: !592)
!595 = !DILocation(line: 87, column: 5, scope: !589)
!596 = !DILocation(line: 88, column: 40, scope: !597)
!597 = distinct !DILexicalBlock(scope: !592, file: !16, line: 87, column: 39)
!598 = !DILocation(line: 88, column: 9, scope: !597)
!599 = !DILocation(line: 88, column: 17, scope: !597)
!600 = !DILocation(line: 88, column: 20, scope: !597)
!601 = !DILocation(line: 88, column: 38, scope: !597)
!602 = !DILocation(line: 89, column: 40, scope: !597)
!603 = !DILocation(line: 89, column: 9, scope: !597)
!604 = !DILocation(line: 89, column: 17, scope: !597)
!605 = !DILocation(line: 89, column: 20, scope: !597)
!606 = !DILocation(line: 89, column: 38, scope: !597)
!607 = !DILocation(line: 90, column: 40, scope: !597)
!608 = !DILocation(line: 90, column: 9, scope: !597)
!609 = !DILocation(line: 90, column: 17, scope: !597)
!610 = !DILocation(line: 90, column: 20, scope: !597)
!611 = !DILocation(line: 90, column: 38, scope: !597)
!612 = !DILocation(line: 91, column: 25, scope: !597)
!613 = !DILocation(line: 91, column: 33, scope: !597)
!614 = !DILocation(line: 91, column: 36, scope: !597)
!615 = !DILocation(line: 91, column: 55, scope: !597)
!616 = !DILocation(line: 91, column: 63, scope: !597)
!617 = !DILocation(line: 91, column: 54, scope: !597)
!618 = !DILocation(line: 91, column: 9, scope: !597)
!619 = !DILocation(line: 92, column: 5, scope: !597)
!620 = !DILocation(line: 87, column: 35, scope: !592)
!621 = !DILocation(line: 87, column: 5, scope: !592)
!622 = distinct !{!622, !595, !623, !306}
!623 = !DILocation(line: 92, column: 5, scope: !589)
!624 = !DILocation(line: 94, column: 1, scope: !575)
!625 = distinct !DISubprogram(name: "await_threads", scope: !16, file: !16, line: 97, type: !626, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!626 = !DISubroutineType(types: !627)
!627 = !{null, !14, !5}
!628 = !DILocalVariable(name: "threads", arg: 1, scope: !625, file: !16, line: 97, type: !14)
!629 = !DILocation(line: 97, column: 27, scope: !625)
!630 = !DILocalVariable(name: "num_threads", arg: 2, scope: !625, file: !16, line: 97, type: !5)
!631 = !DILocation(line: 97, column: 44, scope: !625)
!632 = !DILocalVariable(name: "i", scope: !625, file: !16, line: 99, type: !5)
!633 = !DILocation(line: 99, column: 13, scope: !625)
!634 = !DILocation(line: 100, column: 12, scope: !635)
!635 = distinct !DILexicalBlock(scope: !625, file: !16, line: 100, column: 5)
!636 = !DILocation(line: 100, column: 10, scope: !635)
!637 = !DILocation(line: 100, column: 17, scope: !638)
!638 = distinct !DILexicalBlock(scope: !635, file: !16, line: 100, column: 5)
!639 = !DILocation(line: 100, column: 21, scope: !638)
!640 = !DILocation(line: 100, column: 19, scope: !638)
!641 = !DILocation(line: 100, column: 5, scope: !635)
!642 = !DILocation(line: 101, column: 22, scope: !643)
!643 = distinct !DILexicalBlock(scope: !638, file: !16, line: 100, column: 39)
!644 = !DILocation(line: 101, column: 30, scope: !643)
!645 = !DILocation(line: 101, column: 33, scope: !643)
!646 = !DILocation(line: 101, column: 9, scope: !643)
!647 = !DILocation(line: 102, column: 5, scope: !643)
!648 = !DILocation(line: 100, column: 35, scope: !638)
!649 = !DILocation(line: 100, column: 5, scope: !638)
!650 = distinct !{!650, !641, !651, !306}
!651 = !DILocation(line: 102, column: 5, scope: !635)
!652 = !DILocation(line: 103, column: 1, scope: !625)
!653 = distinct !DISubprogram(name: "common_run", scope: !16, file: !16, line: 43, type: !29, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!654 = !DILocalVariable(name: "args", arg: 1, scope: !653, file: !16, line: 43, type: !13)
!655 = !DILocation(line: 43, column: 18, scope: !653)
!656 = !DILocalVariable(name: "run_info", scope: !653, file: !16, line: 45, type: !14)
!657 = !DILocation(line: 45, column: 17, scope: !653)
!658 = !DILocation(line: 45, column: 42, scope: !653)
!659 = !DILocation(line: 45, column: 28, scope: !653)
!660 = !DILocation(line: 47, column: 9, scope: !661)
!661 = distinct !DILexicalBlock(scope: !653, file: !16, line: 47, column: 9)
!662 = !DILocation(line: 47, column: 19, scope: !661)
!663 = !DILocation(line: 47, column: 9, scope: !653)
!664 = !DILocation(line: 48, column: 26, scope: !661)
!665 = !DILocation(line: 48, column: 36, scope: !661)
!666 = !DILocation(line: 48, column: 9, scope: !661)
!667 = !DILocation(line: 52, column: 12, scope: !653)
!668 = !DILocation(line: 52, column: 22, scope: !653)
!669 = !DILocation(line: 52, column: 38, scope: !653)
!670 = !DILocation(line: 52, column: 48, scope: !653)
!671 = !DILocation(line: 52, column: 30, scope: !653)
!672 = !DILocation(line: 52, column: 5, scope: !653)
!673 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !16, file: !16, line: 61, type: !174, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!674 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !673, file: !16, line: 61, type: !5)
!675 = !DILocation(line: 61, column: 26, scope: !673)
!676 = !DILocation(line: 78, column: 5, scope: !673)
!677 = !DILocation(line: 78, column: 5, scope: !678)
!678 = distinct !DILexicalBlock(scope: !673, file: !16, line: 78, column: 5)
!679 = !DILocation(line: 78, column: 5, scope: !680)
!680 = distinct !DILexicalBlock(scope: !678, file: !16, line: 78, column: 5)
!681 = !DILocation(line: 78, column: 5, scope: !682)
!682 = distinct !DILexicalBlock(scope: !680, file: !16, line: 78, column: 5)
!683 = !DILocation(line: 80, column: 1, scope: !673)
!684 = distinct !DISubprogram(name: "_vqueue_ub_visit_nodes", scope: !33, file: !33, line: 233, type: !685, scopeLine: 235, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!685 = !DISubroutineType(types: !686)
!686 = !{null, !363, !687, !13}
!687 = !DIDerivedType(tag: DW_TAG_typedef, name: "vqueue_ub_node_handler_t", file: !688, line: 9, baseType: !689)
!688 = !DIFile(filename: "datastruct/queue/unbounded/include/vsync/queue/internal/ub/vqueue_ub_common.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "bc5763170bb9d2e4aa9aa1f04b243580")
!689 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !690, size: 64)
!690 = !DISubroutineType(types: !691)
!691 = !{null, !692, !13}
!692 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!693 = !DILocalVariable(name: "q", arg: 1, scope: !684, file: !33, line: 233, type: !363)
!694 = !DILocation(line: 233, column: 37, scope: !684)
!695 = !DILocalVariable(name: "visitor", arg: 2, scope: !684, file: !33, line: 233, type: !687)
!696 = !DILocation(line: 233, column: 65, scope: !684)
!697 = !DILocalVariable(name: "arg", arg: 3, scope: !684, file: !33, line: 234, type: !13)
!698 = !DILocation(line: 234, column: 30, scope: !684)
!699 = !DILocalVariable(name: "curr", scope: !684, file: !33, line: 236, type: !31)
!700 = !DILocation(line: 236, column: 23, scope: !684)
!701 = !DILocalVariable(name: "next", scope: !684, file: !33, line: 237, type: !31)
!702 = !DILocation(line: 237, column: 23, scope: !684)
!703 = !DILocation(line: 239, column: 12, scope: !684)
!704 = !DILocation(line: 239, column: 15, scope: !684)
!705 = !DILocation(line: 239, column: 10, scope: !684)
!706 = !DILocation(line: 241, column: 53, scope: !684)
!707 = !DILocation(line: 241, column: 59, scope: !684)
!708 = !DILocation(line: 241, column: 32, scope: !684)
!709 = !DILocation(line: 241, column: 12, scope: !684)
!710 = !DILocation(line: 241, column: 10, scope: !684)
!711 = !DILocation(line: 243, column: 5, scope: !684)
!712 = !DILocation(line: 243, column: 12, scope: !684)
!713 = !DILocation(line: 244, column: 57, scope: !714)
!714 = distinct !DILexicalBlock(scope: !684, file: !33, line: 243, column: 18)
!715 = !DILocation(line: 244, column: 63, scope: !714)
!716 = !DILocation(line: 244, column: 36, scope: !714)
!717 = !DILocation(line: 244, column: 16, scope: !714)
!718 = !DILocation(line: 244, column: 14, scope: !714)
!719 = !DILocation(line: 245, column: 9, scope: !714)
!720 = !DILocation(line: 245, column: 17, scope: !714)
!721 = !DILocation(line: 245, column: 23, scope: !714)
!722 = !DILocation(line: 246, column: 16, scope: !714)
!723 = !DILocation(line: 246, column: 14, scope: !714)
!724 = distinct !{!724, !711, !725, !306}
!725 = !DILocation(line: 247, column: 5, scope: !684)
!726 = !DILocation(line: 248, column: 1, scope: !684)
!727 = distinct !DISubprogram(name: "_redirect_print", scope: !44, file: !44, line: 229, type: !728, scopeLine: 230, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!728 = !DISubroutineType(types: !729)
!729 = !{null, !31, !13}
!730 = !DILocalVariable(name: "qnode", arg: 1, scope: !727, file: !44, line: 229, type: !31)
!731 = !DILocation(line: 229, column: 35, scope: !727)
!732 = !DILocalVariable(name: "arg", arg: 2, scope: !727, file: !44, line: 229, type: !13)
!733 = !DILocation(line: 229, column: 48, scope: !727)
!734 = !DILocalVariable(name: "print", scope: !727, file: !44, line: 231, type: !43)
!735 = !DILocation(line: 231, column: 17, scope: !727)
!736 = !DILocation(line: 231, column: 38, scope: !727)
!737 = !DILocation(line: 231, column: 25, scope: !727)
!738 = !DILocation(line: 232, column: 5, scope: !727)
!739 = !DILocation(line: 232, column: 11, scope: !727)
!740 = !DILocation(line: 232, column: 18, scope: !727)
!741 = !DILocation(line: 233, column: 1, scope: !727)
!742 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !743, file: !743, line: 197, type: !744, scopeLine: 198, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!743 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!744 = !DISubroutineType(types: !745)
!745 = !{!13, !746}
!746 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !747, size: 64)
!747 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !38)
!748 = !DILocalVariable(name: "a", arg: 1, scope: !742, file: !743, line: 197, type: !746)
!749 = !DILocation(line: 197, column: 41, scope: !742)
!750 = !DILocalVariable(name: "val", scope: !742, file: !743, line: 199, type: !13)
!751 = !DILocation(line: 199, column: 11, scope: !742)
!752 = !DILocation(line: 202, column: 32, scope: !742)
!753 = !DILocation(line: 202, column: 35, scope: !742)
!754 = !DILocation(line: 200, column: 5, scope: !742)
!755 = !{i64 852631}
!756 = !DILocation(line: 204, column: 12, scope: !742)
!757 = !DILocation(line: 204, column: 5, scope: !742)
!758 = distinct !DISubprogram(name: "vmem_get_alloc_count", scope: !79, file: !79, line: 90, type: !759, scopeLine: 91, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!759 = !DISubroutineType(types: !760)
!760 = !{!84}
!761 = !DILocalVariable(name: "alloc_count", scope: !758, file: !79, line: 93, type: !84)
!762 = !DILocation(line: 93, column: 15, scope: !758)
!763 = !DILocation(line: 93, column: 29, scope: !758)
!764 = !DILocation(line: 94, column: 5, scope: !758)
!765 = !DILocation(line: 94, column: 5, scope: !766)
!766 = distinct !DILexicalBlock(scope: !758, file: !79, line: 94, column: 5)
!767 = !DILocation(line: 94, column: 5, scope: !768)
!768 = distinct !DILexicalBlock(scope: !766, file: !79, line: 94, column: 5)
!769 = !DILocation(line: 94, column: 5, scope: !770)
!770 = distinct !DILexicalBlock(scope: !768, file: !79, line: 94, column: 5)
!771 = !DILocation(line: 95, column: 12, scope: !758)
!772 = !DILocation(line: 95, column: 5, scope: !758)
!773 = distinct !DISubprogram(name: "vmem_get_free_count", scope: !79, file: !79, line: 104, type: !759, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!774 = !DILocalVariable(name: "free_count", scope: !773, file: !79, line: 107, type: !84)
!775 = !DILocation(line: 107, column: 15, scope: !773)
!776 = !DILocation(line: 107, column: 28, scope: !773)
!777 = !DILocation(line: 108, column: 5, scope: !773)
!778 = !DILocation(line: 108, column: 5, scope: !779)
!779 = distinct !DILexicalBlock(scope: !773, file: !79, line: 108, column: 5)
!780 = !DILocation(line: 108, column: 5, scope: !781)
!781 = distinct !DILexicalBlock(scope: !779, file: !79, line: 108, column: 5)
!782 = !DILocation(line: 108, column: 5, scope: !783)
!783 = distinct !DILexicalBlock(scope: !781, file: !79, line: 108, column: 5)
!784 = !DILocation(line: 109, column: 12, scope: !773)
!785 = !DILocation(line: 109, column: 5, scope: !773)
!786 = distinct !DISubprogram(name: "vatomic64_read_rlx", scope: !743, file: !743, line: 149, type: !787, scopeLine: 150, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!787 = !DISubroutineType(types: !788)
!788 = !{!84, !789}
!789 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !790, size: 64)
!790 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !80)
!791 = !DILocalVariable(name: "a", arg: 1, scope: !786, file: !743, line: 149, type: !789)
!792 = !DILocation(line: 149, column: 39, scope: !786)
!793 = !DILocalVariable(name: "val", scope: !786, file: !743, line: 151, type: !84)
!794 = !DILocation(line: 151, column: 15, scope: !786)
!795 = !DILocation(line: 154, column: 32, scope: !786)
!796 = !DILocation(line: 154, column: 35, scope: !786)
!797 = !DILocation(line: 152, column: 5, scope: !786)
!798 = !{i64 851148}
!799 = !DILocation(line: 156, column: 12, scope: !786)
!800 = !DILocation(line: 156, column: 5, scope: !786)
!801 = distinct !DISubprogram(name: "ismr_init", scope: !50, file: !50, line: 35, type: !257, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!802 = !DILocation(line: 37, column: 5, scope: !801)
!803 = !DILocation(line: 38, column: 1, scope: !801)
!804 = distinct !DISubprogram(name: "vqueue_ub_init", scope: !33, file: !33, line: 76, type: !805, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!805 = !DISubroutineType(types: !806)
!806 = !{null, !363}
!807 = !DILocalVariable(name: "q", arg: 1, scope: !804, file: !33, line: 76, type: !363)
!808 = !DILocation(line: 76, column: 29, scope: !804)
!809 = !DILocation(line: 78, column: 16, scope: !804)
!810 = !DILocation(line: 78, column: 19, scope: !804)
!811 = !DILocation(line: 78, column: 5, scope: !804)
!812 = !DILocation(line: 78, column: 8, scope: !804)
!813 = !DILocation(line: 78, column: 13, scope: !804)
!814 = !DILocation(line: 79, column: 16, scope: !804)
!815 = !DILocation(line: 79, column: 19, scope: !804)
!816 = !DILocation(line: 79, column: 5, scope: !804)
!817 = !DILocation(line: 79, column: 8, scope: !804)
!818 = !DILocation(line: 79, column: 13, scope: !804)
!819 = !DILocation(line: 81, column: 27, scope: !804)
!820 = !DILocation(line: 81, column: 30, scope: !804)
!821 = !DILocation(line: 81, column: 5, scope: !804)
!822 = !DILocation(line: 83, column: 22, scope: !804)
!823 = !DILocation(line: 83, column: 25, scope: !804)
!824 = !DILocation(line: 83, column: 5, scope: !804)
!825 = !DILocation(line: 84, column: 22, scope: !804)
!826 = !DILocation(line: 84, column: 25, scope: !804)
!827 = !DILocation(line: 84, column: 5, scope: !804)
!828 = !DILocation(line: 85, column: 1, scope: !804)
!829 = distinct !DISubprogram(name: "locked_trace_init", scope: !98, file: !98, line: 14, type: !830, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!830 = !DISubroutineType(types: !831)
!831 = !{null, !832, !5}
!832 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!833 = !DILocalVariable(name: "trace", arg: 1, scope: !829, file: !98, line: 14, type: !832)
!834 = !DILocation(line: 14, column: 35, scope: !829)
!835 = !DILocalVariable(name: "capacity", arg: 2, scope: !829, file: !98, line: 14, type: !5)
!836 = !DILocation(line: 14, column: 50, scope: !829)
!837 = !DILocation(line: 16, column: 5, scope: !838)
!838 = distinct !DILexicalBlock(scope: !839, file: !98, line: 16, column: 5)
!839 = distinct !DILexicalBlock(scope: !829, file: !98, line: 16, column: 5)
!840 = !DILocation(line: 16, column: 5, scope: !839)
!841 = !DILocation(line: 17, column: 25, scope: !829)
!842 = !DILocation(line: 17, column: 32, scope: !829)
!843 = !DILocation(line: 17, column: 5, scope: !829)
!844 = !DILocation(line: 18, column: 17, scope: !829)
!845 = !DILocation(line: 18, column: 24, scope: !829)
!846 = !DILocation(line: 18, column: 31, scope: !829)
!847 = !DILocation(line: 18, column: 5, scope: !829)
!848 = !DILocation(line: 19, column: 1, scope: !829)
!849 = distinct !DISubprogram(name: "trace_init", scope: !103, file: !103, line: 28, type: !850, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!850 = !DISubroutineType(types: !851)
!851 = !{null, !852, !5}
!852 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !102, size: 64)
!853 = !DILocalVariable(name: "trace", arg: 1, scope: !849, file: !103, line: 28, type: !852)
!854 = !DILocation(line: 28, column: 21, scope: !849)
!855 = !DILocalVariable(name: "capacity", arg: 2, scope: !849, file: !103, line: 28, type: !5)
!856 = !DILocation(line: 28, column: 36, scope: !849)
!857 = !DILocation(line: 30, column: 5, scope: !858)
!858 = distinct !DILexicalBlock(scope: !859, file: !103, line: 30, column: 5)
!859 = distinct !DILexicalBlock(scope: !849, file: !103, line: 30, column: 5)
!860 = !DILocation(line: 30, column: 5, scope: !859)
!861 = !DILocation(line: 31, column: 27, scope: !849)
!862 = !DILocation(line: 31, column: 36, scope: !849)
!863 = !DILocation(line: 31, column: 20, scope: !849)
!864 = !DILocation(line: 31, column: 5, scope: !849)
!865 = !DILocation(line: 31, column: 12, scope: !849)
!866 = !DILocation(line: 31, column: 18, scope: !849)
!867 = !DILocation(line: 32, column: 9, scope: !868)
!868 = distinct !DILexicalBlock(scope: !849, file: !103, line: 32, column: 9)
!869 = !DILocation(line: 32, column: 16, scope: !868)
!870 = !DILocation(line: 32, column: 9, scope: !849)
!871 = !DILocation(line: 33, column: 9, scope: !872)
!872 = distinct !DILexicalBlock(scope: !868, file: !103, line: 32, column: 23)
!873 = !DILocation(line: 33, column: 16, scope: !872)
!874 = !DILocation(line: 33, column: 28, scope: !872)
!875 = !DILocation(line: 34, column: 30, scope: !872)
!876 = !DILocation(line: 34, column: 9, scope: !872)
!877 = !DILocation(line: 34, column: 16, scope: !872)
!878 = !DILocation(line: 34, column: 28, scope: !872)
!879 = !DILocation(line: 35, column: 9, scope: !872)
!880 = !DILocation(line: 35, column: 16, scope: !872)
!881 = !DILocation(line: 35, column: 28, scope: !872)
!882 = !DILocation(line: 36, column: 5, scope: !872)
!883 = !DILocation(line: 37, column: 9, scope: !884)
!884 = distinct !DILexicalBlock(scope: !868, file: !103, line: 36, column: 12)
!885 = !DILocation(line: 37, column: 16, scope: !884)
!886 = !DILocation(line: 37, column: 28, scope: !884)
!887 = !DILocation(line: 38, column: 9, scope: !884)
!888 = !DILocation(line: 38, column: 16, scope: !884)
!889 = !DILocation(line: 38, column: 28, scope: !884)
!890 = !DILocation(line: 39, column: 9, scope: !884)
!891 = !DILocation(line: 39, column: 16, scope: !884)
!892 = !DILocation(line: 39, column: 28, scope: !884)
!893 = !DILocation(line: 40, column: 9, scope: !894)
!894 = distinct !DILexicalBlock(scope: !895, file: !103, line: 40, column: 9)
!895 = distinct !DILexicalBlock(scope: !884, file: !103, line: 40, column: 9)
!896 = !DILocation(line: 42, column: 1, scope: !849)
!897 = distinct !DISubprogram(name: "_vqueue_ub_node_init", scope: !33, file: !33, line: 219, type: !728, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!898 = !DILocalVariable(name: "qnode", arg: 1, scope: !897, file: !33, line: 219, type: !31)
!899 = !DILocation(line: 219, column: 40, scope: !897)
!900 = !DILocalVariable(name: "data", arg: 2, scope: !897, file: !33, line: 219, type: !13)
!901 = !DILocation(line: 219, column: 53, scope: !897)
!902 = !DILocation(line: 221, column: 19, scope: !897)
!903 = !DILocation(line: 221, column: 5, scope: !897)
!904 = !DILocation(line: 221, column: 12, scope: !897)
!905 = !DILocation(line: 221, column: 17, scope: !897)
!906 = !DILocation(line: 222, column: 27, scope: !897)
!907 = !DILocation(line: 222, column: 34, scope: !897)
!908 = !DILocation(line: 222, column: 5, scope: !897)
!909 = !DILocation(line: 223, column: 1, scope: !897)
!910 = distinct !DISubprogram(name: "queue_lock_init", scope: !33, file: !33, line: 31, type: !911, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!911 = !DISubroutineType(types: !912)
!912 = !{null, !913}
!913 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !155, size: 64)
!914 = !DILocalVariable(name: "l", arg: 1, scope: !910, file: !33, line: 31, type: !913)
!915 = !DILocation(line: 31, column: 1, scope: !910)
!916 = distinct !DISubprogram(name: "vatomicptr_write_rlx", scope: !743, file: !743, line: 325, type: !917, scopeLine: 326, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!917 = !DISubroutineType(types: !918)
!918 = !{null, !919, !13}
!919 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!920 = !DILocalVariable(name: "a", arg: 1, scope: !916, file: !743, line: 325, type: !919)
!921 = !DILocation(line: 325, column: 36, scope: !916)
!922 = !DILocalVariable(name: "v", arg: 2, scope: !916, file: !743, line: 325, type: !13)
!923 = !DILocation(line: 325, column: 45, scope: !916)
!924 = !DILocation(line: 329, column: 32, scope: !916)
!925 = !DILocation(line: 329, column: 44, scope: !916)
!926 = !DILocation(line: 329, column: 47, scope: !916)
!927 = !DILocation(line: 327, column: 5, scope: !916)
!928 = !{i64 856832}
!929 = !DILocation(line: 331, column: 1, scope: !916)
!930 = distinct !DISubprogram(name: "ismr_reg", scope: !50, file: !50, line: 89, type: !174, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!931 = !DILocalVariable(name: "tid", arg: 1, scope: !930, file: !50, line: 89, type: !5)
!932 = !DILocation(line: 89, column: 18, scope: !930)
!933 = !DILocation(line: 91, column: 5, scope: !930)
!934 = !DILocation(line: 91, column: 5, scope: !935)
!935 = distinct !DILexicalBlock(scope: !930, file: !50, line: 91, column: 5)
!936 = !DILocation(line: 91, column: 5, scope: !937)
!937 = distinct !DILexicalBlock(scope: !935, file: !50, line: 91, column: 5)
!938 = !DILocation(line: 91, column: 5, scope: !939)
!939 = distinct !DILexicalBlock(scope: !937, file: !50, line: 91, column: 5)
!940 = !DILocation(line: 92, column: 1, scope: !930)
!941 = distinct !DISubprogram(name: "ismr_dereg", scope: !50, file: !50, line: 95, type: !174, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!942 = !DILocalVariable(name: "tid", arg: 1, scope: !941, file: !50, line: 95, type: !5)
!943 = !DILocation(line: 95, column: 20, scope: !941)
!944 = !DILocation(line: 97, column: 5, scope: !941)
!945 = !DILocation(line: 97, column: 5, scope: !946)
!946 = distinct !DILexicalBlock(scope: !941, file: !50, line: 97, column: 5)
!947 = !DILocation(line: 97, column: 5, scope: !948)
!948 = distinct !DILexicalBlock(scope: !946, file: !50, line: 97, column: 5)
!949 = !DILocation(line: 97, column: 5, scope: !950)
!950 = distinct !DILexicalBlock(scope: !948, file: !50, line: 97, column: 5)
!951 = !DILocation(line: 98, column: 1, scope: !941)
!952 = distinct !DISubprogram(name: "vqueue_ub_deq", scope: !33, file: !33, line: 166, type: !953, scopeLine: 167, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!953 = !DISubroutineType(types: !954)
!954 = !{!13, !363, !687, !13}
!955 = !DILocalVariable(name: "q", arg: 1, scope: !952, file: !33, line: 166, type: !363)
!956 = !DILocation(line: 166, column: 28, scope: !952)
!957 = !DILocalVariable(name: "retire", arg: 2, scope: !952, file: !33, line: 166, type: !687)
!958 = !DILocation(line: 166, column: 56, scope: !952)
!959 = !DILocalVariable(name: "retire_arg", arg: 3, scope: !952, file: !33, line: 166, type: !13)
!960 = !DILocation(line: 166, column: 70, scope: !952)
!961 = !DILocalVariable(name: "qnode", scope: !952, file: !33, line: 168, type: !31)
!962 = !DILocation(line: 168, column: 23, scope: !952)
!963 = !DILocalVariable(name: "head", scope: !952, file: !33, line: 169, type: !31)
!964 = !DILocation(line: 169, column: 23, scope: !952)
!965 = !DILocalVariable(name: "data", scope: !952, file: !33, line: 170, type: !13)
!966 = !DILocation(line: 170, column: 11, scope: !952)
!967 = !DILocation(line: 172, column: 25, scope: !952)
!968 = !DILocation(line: 172, column: 28, scope: !952)
!969 = !DILocation(line: 172, column: 5, scope: !952)
!970 = !DILocation(line: 174, column: 12, scope: !952)
!971 = !DILocation(line: 174, column: 15, scope: !952)
!972 = !DILocation(line: 174, column: 10, scope: !952)
!973 = !DILocation(line: 176, column: 54, scope: !952)
!974 = !DILocation(line: 176, column: 60, scope: !952)
!975 = !DILocation(line: 176, column: 33, scope: !952)
!976 = !DILocation(line: 176, column: 13, scope: !952)
!977 = !DILocation(line: 176, column: 11, scope: !952)
!978 = !DILocation(line: 177, column: 9, scope: !979)
!979 = distinct !DILexicalBlock(scope: !952, file: !33, line: 177, column: 9)
!980 = !DILocation(line: 177, column: 9, scope: !952)
!981 = !DILocation(line: 178, column: 19, scope: !982)
!982 = distinct !DILexicalBlock(scope: !979, file: !33, line: 177, column: 16)
!983 = !DILocation(line: 178, column: 26, scope: !982)
!984 = !DILocation(line: 178, column: 17, scope: !982)
!985 = !DILocation(line: 179, column: 19, scope: !982)
!986 = !DILocation(line: 179, column: 9, scope: !982)
!987 = !DILocation(line: 179, column: 12, scope: !982)
!988 = !DILocation(line: 179, column: 17, scope: !982)
!989 = !DILocation(line: 180, column: 13, scope: !990)
!990 = distinct !DILexicalBlock(scope: !982, file: !33, line: 180, column: 13)
!991 = !DILocation(line: 180, column: 22, scope: !990)
!992 = !DILocation(line: 180, column: 25, scope: !990)
!993 = !DILocation(line: 180, column: 18, scope: !990)
!994 = !DILocation(line: 180, column: 13, scope: !982)
!995 = !DILocation(line: 181, column: 13, scope: !996)
!996 = distinct !DILexicalBlock(scope: !990, file: !33, line: 180, column: 35)
!997 = !DILocation(line: 181, column: 20, scope: !996)
!998 = !DILocation(line: 181, column: 26, scope: !996)
!999 = !DILocation(line: 182, column: 9, scope: !996)
!1000 = !DILocation(line: 183, column: 5, scope: !982)
!1001 = !DILocation(line: 184, column: 25, scope: !952)
!1002 = !DILocation(line: 184, column: 28, scope: !952)
!1003 = !DILocation(line: 184, column: 5, scope: !952)
!1004 = !DILocation(line: 185, column: 12, scope: !952)
!1005 = !DILocation(line: 185, column: 5, scope: !952)
!1006 = distinct !DISubprogram(name: "_queue_destroy", scope: !44, file: !44, line: 67, type: !1007, scopeLine: 68, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1007 = !DISubroutineType(types: !1008)
!1008 = !{null, !501, !13}
!1009 = !DILocalVariable(name: "node", arg: 1, scope: !1006, file: !44, line: 67, type: !501)
!1010 = !DILocation(line: 67, column: 30, scope: !1006)
!1011 = !DILocalVariable(name: "arg", arg: 2, scope: !1006, file: !44, line: 67, type: !13)
!1012 = !DILocation(line: 67, column: 42, scope: !1006)
!1013 = !DILocation(line: 72, column: 15, scope: !1006)
!1014 = !DILocation(line: 72, column: 5, scope: !1006)
!1015 = !DILocation(line: 74, column: 5, scope: !1006)
!1016 = !DILocation(line: 74, column: 5, scope: !1017)
!1017 = distinct !DILexicalBlock(scope: !1006, file: !44, line: 74, column: 5)
!1018 = !DILocation(line: 74, column: 5, scope: !1019)
!1019 = distinct !DILexicalBlock(scope: !1017, file: !44, line: 74, column: 5)
!1020 = !DILocation(line: 74, column: 5, scope: !1021)
!1021 = distinct !DILexicalBlock(scope: !1019, file: !44, line: 74, column: 5)
!1022 = !DILocation(line: 75, column: 1, scope: !1006)
!1023 = distinct !DISubprogram(name: "vqueue_ub_destroy", scope: !33, file: !33, line: 98, type: !685, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1024 = !DILocalVariable(name: "q", arg: 1, scope: !1023, file: !33, line: 98, type: !363)
!1025 = !DILocation(line: 98, column: 32, scope: !1023)
!1026 = !DILocalVariable(name: "retire", arg: 2, scope: !1023, file: !33, line: 98, type: !687)
!1027 = !DILocation(line: 98, column: 60, scope: !1023)
!1028 = !DILocalVariable(name: "retire_arg", arg: 3, scope: !1023, file: !33, line: 99, type: !13)
!1029 = !DILocation(line: 99, column: 25, scope: !1023)
!1030 = !DILocalVariable(name: "curr", scope: !1023, file: !33, line: 101, type: !31)
!1031 = !DILocation(line: 101, column: 23, scope: !1023)
!1032 = !DILocalVariable(name: "next", scope: !1023, file: !33, line: 102, type: !31)
!1033 = !DILocation(line: 102, column: 23, scope: !1023)
!1034 = !DILocation(line: 104, column: 12, scope: !1023)
!1035 = !DILocation(line: 104, column: 15, scope: !1023)
!1036 = !DILocation(line: 104, column: 10, scope: !1023)
!1037 = !DILocation(line: 106, column: 5, scope: !1023)
!1038 = !DILocation(line: 106, column: 12, scope: !1023)
!1039 = !DILocation(line: 107, column: 57, scope: !1040)
!1040 = distinct !DILexicalBlock(scope: !1023, file: !33, line: 106, column: 18)
!1041 = !DILocation(line: 107, column: 63, scope: !1040)
!1042 = !DILocation(line: 107, column: 36, scope: !1040)
!1043 = !DILocation(line: 107, column: 16, scope: !1040)
!1044 = !DILocation(line: 107, column: 14, scope: !1040)
!1045 = !DILocation(line: 108, column: 13, scope: !1046)
!1046 = distinct !DILexicalBlock(scope: !1040, file: !33, line: 108, column: 13)
!1047 = !DILocation(line: 108, column: 22, scope: !1046)
!1048 = !DILocation(line: 108, column: 25, scope: !1046)
!1049 = !DILocation(line: 108, column: 18, scope: !1046)
!1050 = !DILocation(line: 108, column: 13, scope: !1040)
!1051 = !DILocation(line: 109, column: 13, scope: !1052)
!1052 = distinct !DILexicalBlock(scope: !1046, file: !33, line: 108, column: 35)
!1053 = !DILocation(line: 109, column: 20, scope: !1052)
!1054 = !DILocation(line: 109, column: 26, scope: !1052)
!1055 = !DILocation(line: 110, column: 9, scope: !1052)
!1056 = !DILocation(line: 111, column: 16, scope: !1040)
!1057 = !DILocation(line: 111, column: 14, scope: !1040)
!1058 = distinct !{!1058, !1037, !1059, !306}
!1059 = !DILocation(line: 112, column: 5, scope: !1023)
!1060 = !DILocation(line: 113, column: 1, scope: !1023)
!1061 = distinct !DISubprogram(name: "ismr_destroy", scope: !50, file: !50, line: 101, type: !257, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1062 = !DILocation(line: 103, column: 5, scope: !1061)
!1063 = !DILocation(line: 104, column: 1, scope: !1061)
!1064 = distinct !DISubprogram(name: "queue_lock_acquire", scope: !33, file: !33, line: 31, type: !911, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1065 = !DILocalVariable(name: "l", arg: 1, scope: !1064, file: !33, line: 31, type: !913)
!1066 = !DILocation(line: 31, column: 1, scope: !1064)
!1067 = !DILocalVariable(name: "val", scope: !1064, file: !33, line: 31, type: !66)
!1068 = !DILocation(line: 31, column: 1, scope: !1069)
!1069 = distinct !DILexicalBlock(scope: !1070, file: !33, line: 31, column: 1)
!1070 = distinct !DILexicalBlock(scope: !1064, file: !33, line: 31, column: 1)
!1071 = !DILocation(line: 31, column: 1, scope: !1070)
!1072 = distinct !DISubprogram(name: "vatomicptr_read_acq", scope: !743, file: !743, line: 181, type: !744, scopeLine: 182, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1073 = !DILocalVariable(name: "a", arg: 1, scope: !1072, file: !743, line: 181, type: !746)
!1074 = !DILocation(line: 181, column: 41, scope: !1072)
!1075 = !DILocalVariable(name: "val", scope: !1072, file: !743, line: 183, type: !13)
!1076 = !DILocation(line: 183, column: 11, scope: !1072)
!1077 = !DILocation(line: 186, column: 32, scope: !1072)
!1078 = !DILocation(line: 186, column: 35, scope: !1072)
!1079 = !DILocation(line: 184, column: 5, scope: !1072)
!1080 = !{i64 852131}
!1081 = !DILocation(line: 188, column: 12, scope: !1072)
!1082 = !DILocation(line: 188, column: 5, scope: !1072)
!1083 = distinct !DISubprogram(name: "queue_lock_release", scope: !33, file: !33, line: 31, type: !911, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1084 = !DILocalVariable(name: "l", arg: 1, scope: !1083, file: !33, line: 31, type: !913)
!1085 = !DILocation(line: 31, column: 1, scope: !1083)
!1086 = !DILocalVariable(name: "val", scope: !1083, file: !33, line: 31, type: !66)
!1087 = !DILocation(line: 31, column: 1, scope: !1088)
!1088 = distinct !DILexicalBlock(scope: !1089, file: !33, line: 31, column: 1)
!1089 = distinct !DILexicalBlock(scope: !1083, file: !33, line: 31, column: 1)
!1090 = !DILocation(line: 31, column: 1, scope: !1089)
!1091 = distinct !DISubprogram(name: "vmem_free", scope: !79, file: !79, line: 71, type: !46, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1092 = !DILocalVariable(name: "ptr", arg: 1, scope: !1091, file: !79, line: 71, type: !13)
!1093 = !DILocation(line: 71, column: 17, scope: !1091)
!1094 = !DILocation(line: 73, column: 10, scope: !1091)
!1095 = !DILocation(line: 73, column: 5, scope: !1091)
!1096 = !DILocation(line: 74, column: 9, scope: !1097)
!1097 = distinct !DILexicalBlock(scope: !1091, file: !79, line: 74, column: 9)
!1098 = !DILocation(line: 74, column: 9, scope: !1091)
!1099 = !DILocation(line: 76, column: 9, scope: !1100)
!1100 = distinct !DILexicalBlock(scope: !1097, file: !79, line: 74, column: 14)
!1101 = !DILocation(line: 78, column: 5, scope: !1100)
!1102 = !DILocation(line: 79, column: 1, scope: !1091)
!1103 = distinct !DISubprogram(name: "vatomic64_inc_rlx", scope: !1104, file: !1104, line: 3000, type: !1105, scopeLine: 3001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1104 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!1105 = !DISubroutineType(types: !1106)
!1106 = !{null, !1107}
!1107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!1108 = !DILocalVariable(name: "a", arg: 1, scope: !1103, file: !1104, line: 3000, type: !1107)
!1109 = !DILocation(line: 3000, column: 32, scope: !1103)
!1110 = !DILocation(line: 3002, column: 33, scope: !1103)
!1111 = !DILocation(line: 3002, column: 11, scope: !1103)
!1112 = !DILocation(line: 3003, column: 1, scope: !1103)
!1113 = distinct !DISubprogram(name: "vatomic64_get_inc_rlx", scope: !1104, file: !1104, line: 2560, type: !1114, scopeLine: 2561, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1114 = !DISubroutineType(types: !1115)
!1115 = !{!84, !1107}
!1116 = !DILocalVariable(name: "a", arg: 1, scope: !1113, file: !1104, line: 2560, type: !1107)
!1117 = !DILocation(line: 2560, column: 36, scope: !1113)
!1118 = !DILocation(line: 2562, column: 34, scope: !1113)
!1119 = !DILocation(line: 2562, column: 12, scope: !1113)
!1120 = !DILocation(line: 2562, column: 5, scope: !1113)
!1121 = distinct !DISubprogram(name: "vatomic64_get_add_rlx", scope: !1122, file: !1122, line: 1888, type: !1123, scopeLine: 1889, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1122 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!1123 = !DISubroutineType(types: !1124)
!1124 = !{!84, !1107, !84}
!1125 = !DILocalVariable(name: "a", arg: 1, scope: !1121, file: !1122, line: 1888, type: !1107)
!1126 = !DILocation(line: 1888, column: 36, scope: !1121)
!1127 = !DILocalVariable(name: "v", arg: 2, scope: !1121, file: !1122, line: 1888, type: !84)
!1128 = !DILocation(line: 1888, column: 49, scope: !1121)
!1129 = !DILocalVariable(name: "oldv", scope: !1121, file: !1122, line: 1890, type: !84)
!1130 = !DILocation(line: 1890, column: 15, scope: !1121)
!1131 = !DILocalVariable(name: "tmp", scope: !1121, file: !1122, line: 1891, type: !1132)
!1132 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !6, line: 35, baseType: !1133)
!1133 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !86, line: 26, baseType: !1134)
!1134 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !88, line: 42, baseType: !126)
!1135 = !DILocation(line: 1891, column: 15, scope: !1121)
!1136 = !DILocalVariable(name: "newv", scope: !1121, file: !1122, line: 1892, type: !84)
!1137 = !DILocation(line: 1892, column: 15, scope: !1121)
!1138 = !DILocation(line: 1893, column: 5, scope: !1121)
!1139 = !DILocation(line: 1901, column: 19, scope: !1121)
!1140 = !DILocation(line: 1901, column: 22, scope: !1121)
!1141 = !{i64 961875, i64 961909, i64 961924, i64 961956, i64 961998, i64 962039}
!1142 = !DILocation(line: 1904, column: 12, scope: !1121)
!1143 = !DILocation(line: 1904, column: 5, scope: !1121)
!1144 = distinct !DISubprogram(name: "locked_trace_destroy", scope: !98, file: !98, line: 31, type: !1145, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1145 = !DISubroutineType(types: !1146)
!1146 = !{null, !832, !1147}
!1147 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_verify_unit", file: !103, line: 25, baseType: !1148)
!1148 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1149, size: 64)
!1149 = !DISubroutineType(types: !1150)
!1150 = !{!24, !107}
!1151 = !DILocalVariable(name: "trace", arg: 1, scope: !1144, file: !98, line: 31, type: !832)
!1152 = !DILocation(line: 31, column: 38, scope: !1144)
!1153 = !DILocalVariable(name: "callback", arg: 2, scope: !1144, file: !98, line: 31, type: !1147)
!1154 = !DILocation(line: 31, column: 63, scope: !1144)
!1155 = !DILocation(line: 33, column: 19, scope: !1144)
!1156 = !DILocation(line: 33, column: 26, scope: !1144)
!1157 = !DILocation(line: 33, column: 33, scope: !1144)
!1158 = !DILocation(line: 33, column: 5, scope: !1144)
!1159 = !DILocation(line: 34, column: 20, scope: !1144)
!1160 = !DILocation(line: 34, column: 27, scope: !1144)
!1161 = !DILocation(line: 34, column: 5, scope: !1144)
!1162 = !DILocation(line: 35, column: 28, scope: !1144)
!1163 = !DILocation(line: 35, column: 35, scope: !1144)
!1164 = !DILocation(line: 35, column: 5, scope: !1144)
!1165 = !DILocation(line: 36, column: 1, scope: !1144)
!1166 = distinct !DISubprogram(name: "_ismr_none_destroy_all_cb", scope: !50, file: !50, line: 25, type: !1149, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1167 = !DILocalVariable(name: "unit", arg: 1, scope: !1166, file: !50, line: 25, type: !107)
!1168 = !DILocation(line: 25, column: 41, scope: !1166)
!1169 = !DILocation(line: 27, column: 5, scope: !1170)
!1170 = distinct !DILexicalBlock(scope: !1171, file: !50, line: 27, column: 5)
!1171 = distinct !DILexicalBlock(scope: !1166, file: !50, line: 27, column: 5)
!1172 = !DILocation(line: 27, column: 5, scope: !1171)
!1173 = !DILocalVariable(name: "info", scope: !1166, file: !50, line: 28, type: !48)
!1174 = !DILocation(line: 28, column: 29, scope: !1166)
!1175 = !DILocation(line: 28, column: 62, scope: !1166)
!1176 = !DILocation(line: 28, column: 68, scope: !1166)
!1177 = !DILocation(line: 28, column: 36, scope: !1166)
!1178 = !DILocation(line: 29, column: 5, scope: !1166)
!1179 = !DILocation(line: 29, column: 11, scope: !1166)
!1180 = !DILocation(line: 29, column: 20, scope: !1166)
!1181 = !DILocation(line: 29, column: 26, scope: !1166)
!1182 = !DILocation(line: 29, column: 35, scope: !1166)
!1183 = !DILocation(line: 29, column: 41, scope: !1166)
!1184 = !DILocation(line: 30, column: 10, scope: !1166)
!1185 = !DILocation(line: 30, column: 5, scope: !1166)
!1186 = !DILocation(line: 31, column: 5, scope: !1166)
!1187 = distinct !DISubprogram(name: "trace_verify", scope: !103, file: !103, line: 210, type: !1188, scopeLine: 211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1188 = !DISubroutineType(types: !1189)
!1189 = !{!24, !852, !1147}
!1190 = !DILocalVariable(name: "trace", arg: 1, scope: !1187, file: !103, line: 210, type: !852)
!1191 = !DILocation(line: 210, column: 23, scope: !1187)
!1192 = !DILocalVariable(name: "verify_fun", arg: 2, scope: !1187, file: !103, line: 210, type: !1147)
!1193 = !DILocation(line: 210, column: 48, scope: !1187)
!1194 = !DILocalVariable(name: "i", scope: !1187, file: !103, line: 212, type: !5)
!1195 = !DILocation(line: 212, column: 13, scope: !1187)
!1196 = !DILocation(line: 214, column: 5, scope: !1197)
!1197 = distinct !DILexicalBlock(scope: !1198, file: !103, line: 214, column: 5)
!1198 = distinct !DILexicalBlock(scope: !1187, file: !103, line: 214, column: 5)
!1199 = !DILocation(line: 214, column: 5, scope: !1198)
!1200 = !DILocation(line: 215, column: 5, scope: !1201)
!1201 = distinct !DILexicalBlock(scope: !1202, file: !103, line: 215, column: 5)
!1202 = distinct !DILexicalBlock(scope: !1187, file: !103, line: 215, column: 5)
!1203 = !DILocation(line: 215, column: 5, scope: !1202)
!1204 = !DILocation(line: 216, column: 5, scope: !1205)
!1205 = distinct !DILexicalBlock(scope: !1206, file: !103, line: 216, column: 5)
!1206 = distinct !DILexicalBlock(scope: !1187, file: !103, line: 216, column: 5)
!1207 = !DILocation(line: 216, column: 5, scope: !1206)
!1208 = !DILocation(line: 218, column: 12, scope: !1209)
!1209 = distinct !DILexicalBlock(scope: !1187, file: !103, line: 218, column: 5)
!1210 = !DILocation(line: 218, column: 10, scope: !1209)
!1211 = !DILocation(line: 218, column: 17, scope: !1212)
!1212 = distinct !DILexicalBlock(scope: !1209, file: !103, line: 218, column: 5)
!1213 = !DILocation(line: 218, column: 21, scope: !1212)
!1214 = !DILocation(line: 218, column: 28, scope: !1212)
!1215 = !DILocation(line: 218, column: 19, scope: !1212)
!1216 = !DILocation(line: 218, column: 5, scope: !1209)
!1217 = !DILocation(line: 219, column: 13, scope: !1218)
!1218 = distinct !DILexicalBlock(scope: !1219, file: !103, line: 219, column: 13)
!1219 = distinct !DILexicalBlock(scope: !1212, file: !103, line: 218, column: 38)
!1220 = !DILocation(line: 219, column: 25, scope: !1218)
!1221 = !DILocation(line: 219, column: 32, scope: !1218)
!1222 = !DILocation(line: 219, column: 38, scope: !1218)
!1223 = !DILocation(line: 219, column: 42, scope: !1218)
!1224 = !DILocation(line: 219, column: 13, scope: !1219)
!1225 = !DILocation(line: 220, column: 13, scope: !1226)
!1226 = distinct !DILexicalBlock(scope: !1218, file: !103, line: 219, column: 52)
!1227 = !DILocation(line: 222, column: 5, scope: !1219)
!1228 = !DILocation(line: 218, column: 34, scope: !1212)
!1229 = !DILocation(line: 218, column: 5, scope: !1212)
!1230 = distinct !{!1230, !1216, !1231, !306}
!1231 = !DILocation(line: 222, column: 5, scope: !1209)
!1232 = !DILocation(line: 223, column: 5, scope: !1187)
!1233 = !DILocation(line: 224, column: 1, scope: !1187)
!1234 = distinct !DISubprogram(name: "trace_destroy", scope: !103, file: !103, line: 97, type: !1235, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1235 = !DISubroutineType(types: !1236)
!1236 = !{null, !852}
!1237 = !DILocalVariable(name: "trace", arg: 1, scope: !1234, file: !103, line: 97, type: !852)
!1238 = !DILocation(line: 97, column: 24, scope: !1234)
!1239 = !DILocation(line: 99, column: 5, scope: !1240)
!1240 = distinct !DILexicalBlock(scope: !1241, file: !103, line: 99, column: 5)
!1241 = distinct !DILexicalBlock(scope: !1234, file: !103, line: 99, column: 5)
!1242 = !DILocation(line: 99, column: 5, scope: !1241)
!1243 = !DILocation(line: 100, column: 5, scope: !1244)
!1244 = distinct !DILexicalBlock(scope: !1245, file: !103, line: 100, column: 5)
!1245 = distinct !DILexicalBlock(scope: !1234, file: !103, line: 100, column: 5)
!1246 = !DILocation(line: 100, column: 5, scope: !1245)
!1247 = !DILocation(line: 101, column: 10, scope: !1234)
!1248 = !DILocation(line: 101, column: 17, scope: !1234)
!1249 = !DILocation(line: 101, column: 5, scope: !1234)
!1250 = !DILocation(line: 102, column: 5, scope: !1234)
!1251 = !DILocation(line: 102, column: 12, scope: !1234)
!1252 = !DILocation(line: 102, column: 24, scope: !1234)
!1253 = !DILocation(line: 103, column: 1, scope: !1234)
!1254 = distinct !DISubprogram(name: "vmem_malloc", scope: !79, file: !79, line: 20, type: !1255, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1255 = !DISubroutineType(types: !1256)
!1256 = !{!13, !5}
!1257 = !DILocalVariable(name: "sz", arg: 1, scope: !1254, file: !79, line: 20, type: !5)
!1258 = !DILocation(line: 20, column: 21, scope: !1254)
!1259 = !DILocalVariable(name: "ptr", scope: !1254, file: !79, line: 22, type: !13)
!1260 = !DILocation(line: 22, column: 11, scope: !1254)
!1261 = !DILocation(line: 22, column: 24, scope: !1254)
!1262 = !DILocation(line: 22, column: 17, scope: !1254)
!1263 = !DILocation(line: 23, column: 9, scope: !1264)
!1264 = distinct !DILexicalBlock(scope: !1254, file: !79, line: 23, column: 9)
!1265 = !DILocation(line: 23, column: 9, scope: !1254)
!1266 = !DILocation(line: 25, column: 9, scope: !1267)
!1267 = distinct !DILexicalBlock(scope: !1264, file: !79, line: 23, column: 14)
!1268 = !DILocation(line: 27, column: 5, scope: !1267)
!1269 = !DILocation(line: 28, column: 9, scope: !1270)
!1270 = distinct !DILexicalBlock(scope: !1271, file: !79, line: 28, column: 9)
!1271 = distinct !DILexicalBlock(scope: !1272, file: !79, line: 28, column: 9)
!1272 = distinct !DILexicalBlock(scope: !1264, file: !79, line: 27, column: 12)
!1273 = !DILocation(line: 30, column: 12, scope: !1254)
!1274 = !DILocation(line: 30, column: 5, scope: !1254)
!1275 = distinct !DISubprogram(name: "ismr_enter", scope: !50, file: !50, line: 41, type: !174, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1276 = !DILocalVariable(name: "tid", arg: 1, scope: !1275, file: !50, line: 41, type: !5)
!1277 = !DILocation(line: 41, column: 20, scope: !1275)
!1278 = !DILocation(line: 43, column: 5, scope: !1275)
!1279 = !DILocation(line: 43, column: 5, scope: !1280)
!1280 = distinct !DILexicalBlock(scope: !1275, file: !50, line: 43, column: 5)
!1281 = !DILocation(line: 43, column: 5, scope: !1282)
!1282 = distinct !DILexicalBlock(scope: !1280, file: !50, line: 43, column: 5)
!1283 = !DILocation(line: 43, column: 5, scope: !1284)
!1284 = distinct !DILexicalBlock(scope: !1282, file: !50, line: 43, column: 5)
!1285 = !DILocation(line: 44, column: 1, scope: !1275)
!1286 = distinct !DISubprogram(name: "vqueue_ub_enq", scope: !33, file: !33, line: 122, type: !1287, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1287 = !DISubroutineType(types: !1288)
!1288 = !{null, !363, !31, !13}
!1289 = !DILocalVariable(name: "q", arg: 1, scope: !1286, file: !33, line: 122, type: !363)
!1290 = !DILocation(line: 122, column: 28, scope: !1286)
!1291 = !DILocalVariable(name: "qnode", arg: 2, scope: !1286, file: !33, line: 122, type: !31)
!1292 = !DILocation(line: 122, column: 49, scope: !1286)
!1293 = !DILocalVariable(name: "data", arg: 3, scope: !1286, file: !33, line: 122, type: !13)
!1294 = !DILocation(line: 122, column: 62, scope: !1286)
!1295 = !DILocation(line: 124, column: 25, scope: !1286)
!1296 = !DILocation(line: 124, column: 28, scope: !1286)
!1297 = !DILocation(line: 124, column: 5, scope: !1286)
!1298 = !DILocation(line: 127, column: 26, scope: !1286)
!1299 = !DILocation(line: 127, column: 33, scope: !1286)
!1300 = !DILocation(line: 127, column: 5, scope: !1286)
!1301 = !DILocation(line: 129, column: 27, scope: !1286)
!1302 = !DILocation(line: 129, column: 30, scope: !1286)
!1303 = !DILocation(line: 129, column: 36, scope: !1286)
!1304 = !DILocation(line: 129, column: 42, scope: !1286)
!1305 = !DILocation(line: 129, column: 5, scope: !1286)
!1306 = !DILocation(line: 131, column: 15, scope: !1286)
!1307 = !DILocation(line: 131, column: 5, scope: !1286)
!1308 = !DILocation(line: 131, column: 8, scope: !1286)
!1309 = !DILocation(line: 131, column: 13, scope: !1286)
!1310 = !DILocation(line: 132, column: 25, scope: !1286)
!1311 = !DILocation(line: 132, column: 28, scope: !1286)
!1312 = !DILocation(line: 132, column: 5, scope: !1286)
!1313 = !DILocation(line: 133, column: 1, scope: !1286)
!1314 = distinct !DISubprogram(name: "ismr_exit", scope: !50, file: !50, line: 83, type: !174, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1315 = !DILocalVariable(name: "tid", arg: 1, scope: !1314, file: !50, line: 83, type: !5)
!1316 = !DILocation(line: 83, column: 19, scope: !1314)
!1317 = !DILocation(line: 85, column: 5, scope: !1314)
!1318 = !DILocation(line: 85, column: 5, scope: !1319)
!1319 = distinct !DILexicalBlock(scope: !1314, file: !50, line: 85, column: 5)
!1320 = !DILocation(line: 85, column: 5, scope: !1321)
!1321 = distinct !DILexicalBlock(scope: !1319, file: !50, line: 85, column: 5)
!1322 = !DILocation(line: 85, column: 5, scope: !1323)
!1323 = distinct !DILexicalBlock(scope: !1321, file: !50, line: 85, column: 5)
!1324 = !DILocation(line: 86, column: 1, scope: !1314)
!1325 = distinct !DISubprogram(name: "vatomicptr_write_rel", scope: !743, file: !743, line: 311, type: !917, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1326 = !DILocalVariable(name: "a", arg: 1, scope: !1325, file: !743, line: 311, type: !919)
!1327 = !DILocation(line: 311, column: 36, scope: !1325)
!1328 = !DILocalVariable(name: "v", arg: 2, scope: !1325, file: !743, line: 311, type: !13)
!1329 = !DILocation(line: 311, column: 45, scope: !1325)
!1330 = !DILocation(line: 315, column: 32, scope: !1325)
!1331 = !DILocation(line: 315, column: 44, scope: !1325)
!1332 = !DILocation(line: 315, column: 47, scope: !1325)
!1333 = !DILocation(line: 313, column: 5, scope: !1325)
!1334 = !{i64 856361}
!1335 = !DILocation(line: 317, column: 1, scope: !1325)
!1336 = distinct !DISubprogram(name: "_queue_retire", scope: !44, file: !44, line: 53, type: !1007, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1337 = !DILocalVariable(name: "node", arg: 1, scope: !1336, file: !44, line: 53, type: !501)
!1338 = !DILocation(line: 53, column: 29, scope: !1336)
!1339 = !DILocalVariable(name: "arg", arg: 2, scope: !1336, file: !44, line: 53, type: !13)
!1340 = !DILocation(line: 53, column: 41, scope: !1336)
!1341 = !DILocation(line: 61, column: 15, scope: !1336)
!1342 = !DILocation(line: 61, column: 5, scope: !1336)
!1343 = !DILocation(line: 63, column: 5, scope: !1336)
!1344 = !DILocation(line: 63, column: 5, scope: !1345)
!1345 = distinct !DILexicalBlock(scope: !1336, file: !44, line: 63, column: 5)
!1346 = !DILocation(line: 63, column: 5, scope: !1347)
!1347 = distinct !DILexicalBlock(scope: !1345, file: !44, line: 63, column: 5)
!1348 = !DILocation(line: 63, column: 5, scope: !1349)
!1349 = distinct !DILexicalBlock(scope: !1347, file: !44, line: 63, column: 5)
!1350 = !DILocation(line: 64, column: 1, scope: !1336)
!1351 = distinct !DISubprogram(name: "vqueue_ub_empty", scope: !33, file: !33, line: 143, type: !1352, scopeLine: 144, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1352 = !DISubroutineType(types: !1353)
!1353 = !{!24, !363}
!1354 = !DILocalVariable(name: "q", arg: 1, scope: !1351, file: !33, line: 143, type: !363)
!1355 = !DILocation(line: 143, column: 30, scope: !1351)
!1356 = !DILocalVariable(name: "qnode", scope: !1351, file: !33, line: 145, type: !31)
!1357 = !DILocation(line: 145, column: 23, scope: !1351)
!1358 = !DILocalVariable(name: "head", scope: !1351, file: !33, line: 146, type: !31)
!1359 = !DILocation(line: 146, column: 23, scope: !1351)
!1360 = !DILocation(line: 148, column: 25, scope: !1351)
!1361 = !DILocation(line: 148, column: 28, scope: !1351)
!1362 = !DILocation(line: 148, column: 5, scope: !1351)
!1363 = !DILocation(line: 149, column: 12, scope: !1351)
!1364 = !DILocation(line: 149, column: 15, scope: !1351)
!1365 = !DILocation(line: 149, column: 10, scope: !1351)
!1366 = !DILocation(line: 151, column: 54, scope: !1351)
!1367 = !DILocation(line: 151, column: 60, scope: !1351)
!1368 = !DILocation(line: 151, column: 33, scope: !1351)
!1369 = !DILocation(line: 151, column: 13, scope: !1351)
!1370 = !DILocation(line: 151, column: 11, scope: !1351)
!1371 = !DILocation(line: 152, column: 25, scope: !1351)
!1372 = !DILocation(line: 152, column: 28, scope: !1351)
!1373 = !DILocation(line: 152, column: 5, scope: !1351)
!1374 = !DILocation(line: 153, column: 12, scope: !1351)
!1375 = !DILocation(line: 153, column: 18, scope: !1351)
!1376 = !DILocation(line: 153, column: 5, scope: !1351)
