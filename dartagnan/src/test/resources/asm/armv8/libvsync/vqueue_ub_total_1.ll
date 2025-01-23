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
@msg = dso_local global i32 0, align 4, !dbg !92
@g_t1_deq = dso_local global i64 0, align 8, !dbg !95
@.str = private unnamed_addr constant [5 x i8] c"node\00", align 1
@.str.1 = private unnamed_addr constant [78 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/test_case_1.h\00", align 1
@__PRETTY_FUNCTION__.t1 = private unnamed_addr constant [17 x i8] c"void t1(vsize_t)\00", align 1
@.str.2 = private unnamed_addr constant [51 x i8] c"node->key == 1 || node->key == 2 || node->key == 3\00", align 1
@g_deq_success = dso_local global i8 0, align 1, !dbg !97
@g_t2_deq = dso_local global i64 0, align 8, !dbg !99
@__PRETTY_FUNCTION__.t2 = private unnamed_addr constant [17 x i8] c"void t2(vsize_t)\00", align 1
@.str.3 = private unnamed_addr constant [11 x i8] c"msg == 100\00", align 1
@.str.4 = private unnamed_addr constant [11 x i8] c"g_len == 1\00", align 1
@__PRETTY_FUNCTION__.verify = private unnamed_addr constant [18 x i8] c"void verify(void)\00", align 1
@.str.5 = private unnamed_addr constant [21 x i8] c"g_t1_deq != g_t2_deq\00", align 1
@g_final_state = dso_local global [5 x i64] zeroinitializer, align 16, !dbg !166
@.str.6 = private unnamed_addr constant [29 x i8] c"g_t1_deq != g_final_state[0]\00", align 1
@.str.7 = private unnamed_addr constant [29 x i8] c"g_t2_deq != g_final_state[0]\00", align 1
@.str.8 = private unnamed_addr constant [47 x i8] c"g_final_state[0] == 2 || g_final_state[0] == 3\00", align 1
@.str.9 = private unnamed_addr constant [11 x i8] c"g_len == 2\00", align 1
@.str.10 = private unnamed_addr constant [29 x i8] c"g_t1_deq != g_final_state[1]\00", align 1
@.str.11 = private unnamed_addr constant [153 x i8] c"(g_final_state[0] == 1 && g_final_state[1] == 2) || (g_final_state[0] == 2 && g_final_state[1] == 3) || (g_final_state[0] == 3 && g_final_state[1] == 2)\00", align 1
@g_queue = dso_local global %struct.vqueue_ub_s zeroinitializer, align 8, !dbg !154
@.str.12 = private unnamed_addr constant [15 x i8] c"vmem_no_leak()\00", align 1
@.str.13 = private unnamed_addr constant [89 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/unbounded_queue_verify.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.14 = private unnamed_addr constant [5 x i8] c"data\00", align 1
@__PRETTY_FUNCTION__.get_final_state = private unnamed_addr constant [29 x i8] c"void get_final_state(void *)\00", align 1
@.str.15 = private unnamed_addr constant [10 x i8] c"g_len < 5\00", align 1
@.str.16 = private unnamed_addr constant [39 x i8] c"currently only 3 threads are supported\00", align 1
@.str.17 = private unnamed_addr constant [41 x i8] c"\22currently only 3 threads are supported\22\00", align 1
@__PRETTY_FUNCTION__.run = private unnamed_addr constant [18 x i8] c"void *run(void *)\00", align 1
@global_trace = dso_local global %struct.locked_trace_s zeroinitializer, align 8, !dbg !101
@.str.18 = private unnamed_addr constant [6 x i8] c"trace\00", align 1
@.str.19 = private unnamed_addr constant [64 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/locked_trace.h\00", align 1
@__PRETTY_FUNCTION__.locked_trace_init = private unnamed_addr constant [50 x i8] c"void locked_trace_init(locked_trace_t *, vsize_t)\00", align 1
@.str.20 = private unnamed_addr constant [65 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/trace_manager.h\00", align 1
@__PRETTY_FUNCTION__.trace_init = private unnamed_addr constant [36 x i8] c"void trace_init(trace_t *, vsize_t)\00", align 1
@.str.21 = private unnamed_addr constant [25 x i8] c"0 && \22allocation failed\22\00", align 1
@.str.22 = private unnamed_addr constant [97 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/include/test/queue/ub/queue_interface.h\00", align 1
@__PRETTY_FUNCTION__.queue_destroy = private unnamed_addr constant [30 x i8] c"void queue_destroy(queue_t *)\00", align 1
@.str.23 = private unnamed_addr constant [9 x i8] c"val == 0\00", align 1
@.str.24 = private unnamed_addr constant [101 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/include/vsync/queue/unbounded_queue_total.h\00", align 1
@__PRETTY_FUNCTION__.queue_lock_acquire = private unnamed_addr constant [40 x i8] c"void queue_lock_acquire(queue_lock_t *)\00", align 1
@__PRETTY_FUNCTION__.queue_lock_release = private unnamed_addr constant [40 x i8] c"void queue_lock_release(queue_lock_t *)\00", align 1
@__PRETTY_FUNCTION__.trace_verify = private unnamed_addr constant [51 x i8] c"vbool_t trace_verify(trace_t *, trace_verify_unit)\00", align 1
@.str.25 = private unnamed_addr constant [19 x i8] c"trace->initialized\00", align 1
@.str.26 = private unnamed_addr constant [11 x i8] c"verify_fun\00", align 1
@__PRETTY_FUNCTION__.trace_destroy = private unnamed_addr constant [30 x i8] c"void trace_destroy(trace_t *)\00", align 1
@.str.27 = private unnamed_addr constant [5 x i8] c"unit\00", align 1
@.str.28 = private unnamed_addr constant [70 x i8] c"/home/stefano/huawei/libvsync/memory/smr/include/test/smr/ismr_none.h\00", align 1
@__PRETTY_FUNCTION__._ismr_none_destroy_all_cb = private unnamed_addr constant [50 x i8] c"vbool_t _ismr_none_destroy_all_cb(trace_unit_t *)\00", align 1
@__PRETTY_FUNCTION__.queue_enq = private unnamed_addr constant [52 x i8] c"void queue_enq(vsize_t, queue_t *, vuint64_t, char)\00", align 1
@.str.29 = private unnamed_addr constant [63 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/vmem_stdlib.h\00", align 1
@__PRETTY_FUNCTION__.vmem_malloc = private unnamed_addr constant [27 x i8] c"void *vmem_malloc(vsize_t)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @t1(i64 noundef %0) #0 !dbg !179 {
  %2 = alloca i64, align 8
  %3 = alloca %struct.data_s*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !183, metadata !DIExpression()), !dbg !184
  %4 = load i64, i64* %2, align 8, !dbg !185
  call void @enq(i64 noundef %4, i64 noundef 1, i8 noundef signext 65), !dbg !186
  store i32 100, i32* @msg, align 4, !dbg !187
  %5 = load i64, i64* %2, align 8, !dbg !188
  call void @enq(i64 noundef %5, i64 noundef 2, i8 noundef signext 66), !dbg !189
  call void @llvm.dbg.declare(metadata %struct.data_s** %3, metadata !190, metadata !DIExpression()), !dbg !197
  %6 = load i64, i64* %2, align 8, !dbg !198
  %7 = call %struct.data_s* @deq(i64 noundef %6), !dbg !199
  store %struct.data_s* %7, %struct.data_s** %3, align 8, !dbg !197
  %8 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !200
  %9 = icmp ne %struct.data_s* %8, null, !dbg !200
  br i1 %9, label %10, label %11, !dbg !203

10:                                               ; preds = %1
  br label %12, !dbg !203

11:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 27, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t1, i64 0, i64 0)) #5, !dbg !200
  unreachable, !dbg !200

12:                                               ; preds = %10
  %13 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !204
  %14 = getelementptr inbounds %struct.data_s, %struct.data_s* %13, i32 0, i32 0, !dbg !204
  %15 = load i64, i64* %14, align 8, !dbg !204
  %16 = icmp eq i64 %15, 1, !dbg !204
  br i1 %16, label %27, label %17, !dbg !204

17:                                               ; preds = %12
  %18 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !204
  %19 = getelementptr inbounds %struct.data_s, %struct.data_s* %18, i32 0, i32 0, !dbg !204
  %20 = load i64, i64* %19, align 8, !dbg !204
  %21 = icmp eq i64 %20, 2, !dbg !204
  br i1 %21, label %27, label %22, !dbg !204

22:                                               ; preds = %17
  %23 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !204
  %24 = getelementptr inbounds %struct.data_s, %struct.data_s* %23, i32 0, i32 0, !dbg !204
  %25 = load i64, i64* %24, align 8, !dbg !204
  %26 = icmp eq i64 %25, 3, !dbg !204
  br i1 %26, label %27, label %28, !dbg !207

27:                                               ; preds = %22, %17, %12
  br label %29, !dbg !207

28:                                               ; preds = %22
  call void @__assert_fail(i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 28, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t1, i64 0, i64 0)) #5, !dbg !204
  unreachable, !dbg !204

29:                                               ; preds = %27
  %30 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !208
  %31 = getelementptr inbounds %struct.data_s, %struct.data_s* %30, i32 0, i32 0, !dbg !209
  %32 = load i64, i64* %31, align 8, !dbg !209
  store i64 %32, i64* @g_t1_deq, align 8, !dbg !210
  %33 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !211
  %34 = bitcast %struct.data_s* %33 to i8*, !dbg !211
  call void @free(i8* noundef %34) #6, !dbg !212
  ret void, !dbg !213
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @enq(i64 noundef %0, i64 noundef %1, i8 noundef signext %2) #0 !dbg !214 {
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i8, align 1
  store i64 %0, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !217, metadata !DIExpression()), !dbg !218
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !219, metadata !DIExpression()), !dbg !220
  store i8 %2, i8* %6, align 1
  call void @llvm.dbg.declare(metadata i8* %6, metadata !221, metadata !DIExpression()), !dbg !222
  %7 = load i64, i64* %4, align 8, !dbg !223
  %8 = load i64, i64* %5, align 8, !dbg !224
  %9 = load i8, i8* %6, align 1, !dbg !225
  call void @queue_enq(i64 noundef %7, %struct.vqueue_ub_s* noundef @g_queue, i64 noundef %8, i8 noundef signext %9), !dbg !226
  ret void, !dbg !227
}

; Function Attrs: noinline nounwind uwtable
define dso_local %struct.data_s* @deq(i64 noundef %0) #0 !dbg !228 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !231, metadata !DIExpression()), !dbg !232
  %3 = load i64, i64* %2, align 8, !dbg !233
  %4 = call i8* @queue_deq(i64 noundef %3, %struct.vqueue_ub_s* noundef @g_queue), !dbg !234
  %5 = bitcast i8* %4 to %struct.data_s*, !dbg !234
  ret %struct.data_s* %5, !dbg !235
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @t2(i64 noundef %0) #0 !dbg !236 {
  %2 = alloca i64, align 8
  %3 = alloca %struct.data_s*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !237, metadata !DIExpression()), !dbg !238
  call void @llvm.dbg.declare(metadata %struct.data_s** %3, metadata !239, metadata !DIExpression()), !dbg !240
  %4 = load i64, i64* %2, align 8, !dbg !241
  %5 = call %struct.data_s* @deq(i64 noundef %4), !dbg !242
  store %struct.data_s* %5, %struct.data_s** %3, align 8, !dbg !240
  %6 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !243
  %7 = icmp ne %struct.data_s* %6, null, !dbg !243
  br i1 %7, label %8, label %42, !dbg !245

8:                                                ; preds = %1
  %9 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !246
  %10 = getelementptr inbounds %struct.data_s, %struct.data_s* %9, i32 0, i32 0, !dbg !246
  %11 = load i64, i64* %10, align 8, !dbg !246
  %12 = icmp eq i64 %11, 1, !dbg !246
  br i1 %12, label %23, label %13, !dbg !246

13:                                               ; preds = %8
  %14 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !246
  %15 = getelementptr inbounds %struct.data_s, %struct.data_s* %14, i32 0, i32 0, !dbg !246
  %16 = load i64, i64* %15, align 8, !dbg !246
  %17 = icmp eq i64 %16, 2, !dbg !246
  br i1 %17, label %23, label %18, !dbg !246

18:                                               ; preds = %13
  %19 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !246
  %20 = getelementptr inbounds %struct.data_s, %struct.data_s* %19, i32 0, i32 0, !dbg !246
  %21 = load i64, i64* %20, align 8, !dbg !246
  %22 = icmp eq i64 %21, 3, !dbg !246
  br i1 %22, label %23, label %24, !dbg !250

23:                                               ; preds = %18, %13, %8
  br label %25, !dbg !250

24:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 44, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t2, i64 0, i64 0)) #5, !dbg !246
  unreachable, !dbg !246

25:                                               ; preds = %23
  store i8 1, i8* @g_deq_success, align 1, !dbg !251
  %26 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !252
  %27 = getelementptr inbounds %struct.data_s, %struct.data_s* %26, i32 0, i32 0, !dbg !253
  %28 = load i64, i64* %27, align 8, !dbg !253
  store i64 %28, i64* @g_t2_deq, align 8, !dbg !254
  %29 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !255
  %30 = getelementptr inbounds %struct.data_s, %struct.data_s* %29, i32 0, i32 0, !dbg !257
  %31 = load i64, i64* %30, align 8, !dbg !257
  %32 = icmp eq i64 %31, 2, !dbg !258
  br i1 %32, label %33, label %39, !dbg !259

33:                                               ; preds = %25
  %34 = load i32, i32* @msg, align 4, !dbg !260
  %35 = icmp eq i32 %34, 100, !dbg !260
  br i1 %35, label %36, label %37, !dbg !264

36:                                               ; preds = %33
  br label %38, !dbg !264

37:                                               ; preds = %33
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 49, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t2, i64 0, i64 0)) #5, !dbg !260
  unreachable, !dbg !260

38:                                               ; preds = %36
  br label %39, !dbg !265

39:                                               ; preds = %38, %25
  %40 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !266
  %41 = bitcast %struct.data_s* %40 to i8*, !dbg !266
  call void @free(i8* noundef %41) #6, !dbg !267
  br label %42, !dbg !268

42:                                               ; preds = %39, %1
  ret void, !dbg !269
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @t3(i64 noundef %0) #0 !dbg !270 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !271, metadata !DIExpression()), !dbg !272
  %3 = load i64, i64* %2, align 8, !dbg !273
  call void @enq(i64 noundef %3, i64 noundef 3, i8 noundef signext 67), !dbg !274
  %4 = load i64, i64* %2, align 8, !dbg !275
  call void @queue_clean(i64 noundef %4), !dbg !276
  ret void, !dbg !277
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_clean(i64 noundef %0) #0 !dbg !278 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !279, metadata !DIExpression()), !dbg !280
  %3 = load i64, i64* %2, align 8, !dbg !281
  call void @ismr_recycle(i64 noundef %3), !dbg !282
  ret void, !dbg !283
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @verify() #0 !dbg !284 {
  %1 = load i8, i8* @g_deq_success, align 1, !dbg !287
  %2 = trunc i8 %1 to i1, !dbg !287
  br i1 %2, label %3, label %35, !dbg !289

3:                                                ; preds = %0
  %4 = load i64, i64* @g_len, align 8, !dbg !290
  %5 = icmp eq i64 %4, 1, !dbg !290
  br i1 %5, label %6, label %7, !dbg !294

6:                                                ; preds = %3
  br label %8, !dbg !294

7:                                                ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 76, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !290
  unreachable, !dbg !290

8:                                                ; preds = %6
  %9 = load i64, i64* @g_t1_deq, align 8, !dbg !295
  %10 = load i64, i64* @g_t2_deq, align 8, !dbg !295
  %11 = icmp ne i64 %9, %10, !dbg !295
  br i1 %11, label %12, label %13, !dbg !298

12:                                               ; preds = %8
  br label %14, !dbg !298

13:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 77, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !295
  unreachable, !dbg !295

14:                                               ; preds = %12
  %15 = load i64, i64* @g_t1_deq, align 8, !dbg !299
  %16 = load i64, i64* getelementptr inbounds ([5 x i64], [5 x i64]* @g_final_state, i64 0, i64 0), align 16, !dbg !299
  %17 = icmp ne i64 %15, %16, !dbg !299
  br i1 %17, label %18, label %19, !dbg !302

18:                                               ; preds = %14
  br label %20, !dbg !302

19:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 78, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !299
  unreachable, !dbg !299

20:                                               ; preds = %18
  %21 = load i64, i64* @g_t2_deq, align 8, !dbg !303
  %22 = load i64, i64* getelementptr inbounds ([5 x i64], [5 x i64]* @g_final_state, i64 0, i64 0), align 16, !dbg !303
  %23 = icmp ne i64 %21, %22, !dbg !303
  br i1 %23, label %24, label %25, !dbg !306

24:                                               ; preds = %20
  br label %26, !dbg !306

25:                                               ; preds = %20
  call void @__assert_fail(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.7, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 79, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !303
  unreachable, !dbg !303

26:                                               ; preds = %24
  %27 = load i64, i64* getelementptr inbounds ([5 x i64], [5 x i64]* @g_final_state, i64 0, i64 0), align 16, !dbg !307
  %28 = icmp eq i64 %27, 2, !dbg !307
  br i1 %28, label %32, label %29, !dbg !307

29:                                               ; preds = %26
  %30 = load i64, i64* getelementptr inbounds ([5 x i64], [5 x i64]* @g_final_state, i64 0, i64 0), align 16, !dbg !307
  %31 = icmp eq i64 %30, 3, !dbg !307
  br i1 %31, label %32, label %33, !dbg !310

32:                                               ; preds = %29, %26
  br label %34, !dbg !310

33:                                               ; preds = %29
  call void @__assert_fail(i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @.str.8, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 80, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !307
  unreachable, !dbg !307

34:                                               ; preds = %32
  br label %73, !dbg !311

35:                                               ; preds = %0
  %36 = load i64, i64* @g_len, align 8, !dbg !312
  %37 = icmp eq i64 %36, 2, !dbg !312
  br i1 %37, label %38, label %39, !dbg !316

38:                                               ; preds = %35
  br label %40, !dbg !316

39:                                               ; preds = %35
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 82, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !312
  unreachable, !dbg !312

40:                                               ; preds = %38
  %41 = load i64, i64* @g_t1_deq, align 8, !dbg !317
  %42 = load i64, i64* getelementptr inbounds ([5 x i64], [5 x i64]* @g_final_state, i64 0, i64 0), align 16, !dbg !317
  %43 = icmp ne i64 %41, %42, !dbg !317
  br i1 %43, label %44, label %45, !dbg !320

44:                                               ; preds = %40
  br label %46, !dbg !320

45:                                               ; preds = %40
  call void @__assert_fail(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 83, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !317
  unreachable, !dbg !317

46:                                               ; preds = %44
  %47 = load i64, i64* @g_t1_deq, align 8, !dbg !321
  %48 = load i64, i64* getelementptr inbounds ([5 x i64], [5 x i64]* @g_final_state, i64 0, i64 1), align 8, !dbg !321
  %49 = icmp ne i64 %47, %48, !dbg !321
  br i1 %49, label %50, label %51, !dbg !324

50:                                               ; preds = %46
  br label %52, !dbg !324

51:                                               ; preds = %46
  call void @__assert_fail(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.10, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 84, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !321
  unreachable, !dbg !321

52:                                               ; preds = %50
  %53 = load i64, i64* getelementptr inbounds ([5 x i64], [5 x i64]* @g_final_state, i64 0, i64 0), align 16, !dbg !325
  %54 = icmp eq i64 %53, 1, !dbg !325
  br i1 %54, label %55, label %58, !dbg !325

55:                                               ; preds = %52
  %56 = load i64, i64* getelementptr inbounds ([5 x i64], [5 x i64]* @g_final_state, i64 0, i64 1), align 8, !dbg !325
  %57 = icmp eq i64 %56, 2, !dbg !325
  br i1 %57, label %70, label %58, !dbg !325

58:                                               ; preds = %55, %52
  %59 = load i64, i64* getelementptr inbounds ([5 x i64], [5 x i64]* @g_final_state, i64 0, i64 0), align 16, !dbg !325
  %60 = icmp eq i64 %59, 2, !dbg !325
  br i1 %60, label %61, label %64, !dbg !325

61:                                               ; preds = %58
  %62 = load i64, i64* getelementptr inbounds ([5 x i64], [5 x i64]* @g_final_state, i64 0, i64 1), align 8, !dbg !325
  %63 = icmp eq i64 %62, 3, !dbg !325
  br i1 %63, label %70, label %64, !dbg !325

64:                                               ; preds = %61, %58
  %65 = load i64, i64* getelementptr inbounds ([5 x i64], [5 x i64]* @g_final_state, i64 0, i64 0), align 16, !dbg !325
  %66 = icmp eq i64 %65, 3, !dbg !325
  br i1 %66, label %67, label %71, !dbg !325

67:                                               ; preds = %64
  %68 = load i64, i64* getelementptr inbounds ([5 x i64], [5 x i64]* @g_final_state, i64 0, i64 1), align 8, !dbg !325
  %69 = icmp eq i64 %68, 2, !dbg !325
  br i1 %69, label %70, label %71, !dbg !328

70:                                               ; preds = %67, %61, %55
  br label %72, !dbg !328

71:                                               ; preds = %67, %64
  call void @__assert_fail(i8* noundef getelementptr inbounds ([153 x i8], [153 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 87, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !325
  unreachable, !dbg !325

72:                                               ; preds = %70
  br label %73

73:                                               ; preds = %72, %34
  ret void, !dbg !329
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !330 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @init(), !dbg !333
  call void @launch_threads(i64 noundef 3, i8* (i8*)* noundef @run), !dbg !334
  call void @queue_print(%struct.vqueue_ub_s* noundef @g_queue, void (i8*)* noundef @get_final_state), !dbg !335
  call void @verify(), !dbg !336
  call void @destroy(), !dbg !337
  %2 = call zeroext i1 @vmem_no_leak(), !dbg !338
  br i1 %2, label %3, label %4, !dbg !341

3:                                                ; preds = %0
  br label %5, !dbg !341

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.12, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.13, i64 0, i64 0), i32 noundef 58, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !338
  unreachable, !dbg !338

5:                                                ; preds = %3
  ret i32 0, !dbg !342
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !343 {
  call void @queue_init(%struct.vqueue_ub_s* noundef @g_queue), !dbg !344
  call void @queue_register(i64 noundef 0, %struct.vqueue_ub_s* noundef @g_queue), !dbg !345
  call void @queue_deregister(i64 noundef 0, %struct.vqueue_ub_s* noundef @g_queue), !dbg !346
  ret void, !dbg !347
}

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !348 {
  %3 = alloca i64, align 8
  %4 = alloca i8* (i8*)*, align 8
  %5 = alloca %struct.run_info_t*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !351, metadata !DIExpression()), !dbg !352
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %4, metadata !353, metadata !DIExpression()), !dbg !354
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !355, metadata !DIExpression()), !dbg !356
  %6 = load i64, i64* %3, align 8, !dbg !357
  %7 = mul i64 32, %6, !dbg !358
  %8 = call noalias i8* @malloc(i64 noundef %7) #6, !dbg !359
  %9 = bitcast i8* %8 to %struct.run_info_t*, !dbg !359
  store %struct.run_info_t* %9, %struct.run_info_t** %5, align 8, !dbg !356
  %10 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !360
  %11 = load i64, i64* %3, align 8, !dbg !361
  %12 = load i8* (i8*)*, i8* (i8*)** %4, align 8, !dbg !362
  call void @create_threads(%struct.run_info_t* noundef %10, i64 noundef %11, i8* (i8*)* noundef %12, i1 noundef zeroext true), !dbg !363
  %13 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !364
  %14 = load i64, i64* %3, align 8, !dbg !365
  call void @await_threads(%struct.run_info_t* noundef %13, i64 noundef %14), !dbg !366
  %15 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !367
  %16 = bitcast %struct.run_info_t* %15 to i8*, !dbg !367
  call void @free(i8* noundef %16) #6, !dbg !368
  ret void, !dbg !369
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !370 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !371, metadata !DIExpression()), !dbg !372
  call void @llvm.dbg.declare(metadata i64* %3, metadata !373, metadata !DIExpression()), !dbg !374
  %4 = load i8*, i8** %2, align 8, !dbg !375
  %5 = ptrtoint i8* %4 to i64, !dbg !376
  store i64 %5, i64* %3, align 8, !dbg !374
  %6 = load i64, i64* %3, align 8, !dbg !377
  call void @queue_register(i64 noundef %6, %struct.vqueue_ub_s* noundef @g_queue), !dbg !378
  %7 = load i64, i64* %3, align 8, !dbg !379
  switch i64 %7, label %14 [
    i64 0, label %8
    i64 1, label %10
    i64 2, label %12
  ], !dbg !380

8:                                                ; preds = %1
  %9 = load i64, i64* %3, align 8, !dbg !381
  call void @t1(i64 noundef %9), !dbg !383
  br label %18, !dbg !384

10:                                               ; preds = %1
  %11 = load i64, i64* %3, align 8, !dbg !385
  call void @t2(i64 noundef %11), !dbg !386
  br label %18, !dbg !387

12:                                               ; preds = %1
  %13 = load i64, i64* %3, align 8, !dbg !388
  call void @t3(i64 noundef %13), !dbg !389
  br label %18, !dbg !390

14:                                               ; preds = %1
  br i1 true, label %15, label %16, !dbg !391

15:                                               ; preds = %14
  br label %17, !dbg !391

16:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([41 x i8], [41 x i8]* @.str.17, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.13, i64 0, i64 0), i32 noundef 141, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !393
  unreachable, !dbg !393

17:                                               ; preds = %15
  br label %18, !dbg !395

18:                                               ; preds = %17, %12, %10, %8
  %19 = load i64, i64* %3, align 8, !dbg !396
  call void @queue_deregister(i64 noundef %19, %struct.vqueue_ub_s* noundef @g_queue), !dbg !397
  ret i8* null, !dbg !398
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_print(%struct.vqueue_ub_s* noundef %0, void (i8*)* noundef %1) #0 !dbg !399 {
  %3 = alloca %struct.vqueue_ub_s*, align 8
  %4 = alloca void (i8*)*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %3, metadata !403, metadata !DIExpression()), !dbg !404
  store void (i8*)* %1, void (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata void (i8*)** %4, metadata !405, metadata !DIExpression()), !dbg !406
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %3, align 8, !dbg !407
  %6 = load void (i8*)*, void (i8*)** %4, align 8, !dbg !408
  %7 = bitcast void (i8*)* %6 to i8*, !dbg !409
  call void @_vqueue_ub_visit_nodes(%struct.vqueue_ub_s* noundef %5, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_redirect_print, i8* noundef %7), !dbg !410
  ret void, !dbg !411
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @get_final_state(i8* noundef %0) #0 !dbg !412 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.data_s*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !413, metadata !DIExpression()), !dbg !414
  %4 = load i8*, i8** %2, align 8, !dbg !415
  %5 = icmp ne i8* %4, null, !dbg !415
  br i1 %5, label %6, label %7, !dbg !418

6:                                                ; preds = %1
  br label %8, !dbg !418

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.14, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.13, i64 0, i64 0), i32 noundef 119, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.get_final_state, i64 0, i64 0)) #5, !dbg !415
  unreachable, !dbg !415

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata %struct.data_s** %3, metadata !419, metadata !DIExpression()), !dbg !420
  %9 = load i8*, i8** %2, align 8, !dbg !421
  %10 = bitcast i8* %9 to %struct.data_s*, !dbg !421
  store %struct.data_s* %10, %struct.data_s** %3, align 8, !dbg !420
  %11 = load i64, i64* @g_len, align 8, !dbg !422
  %12 = icmp ult i64 %11, 5, !dbg !422
  br i1 %12, label %13, label %14, !dbg !425

13:                                               ; preds = %8
  br label %15, !dbg !425

14:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.13, i64 0, i64 0), i32 noundef 121, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.get_final_state, i64 0, i64 0)) #5, !dbg !422
  unreachable, !dbg !422

15:                                               ; preds = %13
  %16 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !426
  %17 = getelementptr inbounds %struct.data_s, %struct.data_s* %16, i32 0, i32 0, !dbg !427
  %18 = load i64, i64* %17, align 8, !dbg !427
  %19 = load i64, i64* @g_len, align 8, !dbg !428
  %20 = add i64 %19, 1, !dbg !428
  store i64 %20, i64* @g_len, align 8, !dbg !428
  %21 = getelementptr inbounds [5 x i64], [5 x i64]* @g_final_state, i64 0, i64 %19, !dbg !429
  store i64 %18, i64* %21, align 8, !dbg !430
  ret void, !dbg !431
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @destroy() #0 !dbg !432 {
  call void @queue_destroy(%struct.vqueue_ub_s* noundef @g_queue), !dbg !433
  ret void, !dbg !434
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @vmem_no_leak() #0 !dbg !435 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !438, metadata !DIExpression()), !dbg !439
  %3 = call i64 @vmem_get_alloc_count(), !dbg !440
  store i64 %3, i64* %1, align 8, !dbg !439
  call void @llvm.dbg.declare(metadata i64* %2, metadata !441, metadata !DIExpression()), !dbg !442
  %4 = call i64 @vmem_get_free_count(), !dbg !443
  store i64 %4, i64* %2, align 8, !dbg !442
  %5 = load i64, i64* %1, align 8, !dbg !444
  %6 = load i64, i64* %2, align 8, !dbg !445
  %7 = icmp eq i64 %5, %6, !dbg !446
  ret i1 %7, !dbg !447
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_init(%struct.vqueue_ub_s* noundef %0) #0 !dbg !448 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !452, metadata !DIExpression()), !dbg !453
  call void @ismr_init(), !dbg !454
  %3 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !455
  call void @vqueue_ub_init(%struct.vqueue_ub_s* noundef %3), !dbg !456
  ret void, !dbg !457
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_register(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !458 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !461, metadata !DIExpression()), !dbg !462
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !463, metadata !DIExpression()), !dbg !464
  %5 = load i64, i64* %3, align 8, !dbg !465
  call void @ismr_reg(i64 noundef %5), !dbg !466
  br label %6, !dbg !467

6:                                                ; preds = %2
  br label %7, !dbg !468

7:                                                ; preds = %6
  %8 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !470
  br label %9, !dbg !470

9:                                                ; preds = %7
  br label %10, !dbg !472

10:                                               ; preds = %9
  br label %11, !dbg !470

11:                                               ; preds = %10
  br label %12, !dbg !468

12:                                               ; preds = %11
  ret void, !dbg !474
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_deregister(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !475 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !476, metadata !DIExpression()), !dbg !477
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !478, metadata !DIExpression()), !dbg !479
  %5 = load i64, i64* %3, align 8, !dbg !480
  call void @ismr_dereg(i64 noundef %5), !dbg !481
  br label %6, !dbg !482

6:                                                ; preds = %2
  br label %7, !dbg !483

7:                                                ; preds = %6
  %8 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !485
  br label %9, !dbg !485

9:                                                ; preds = %7
  br label %10, !dbg !487

10:                                               ; preds = %9
  br label %11, !dbg !485

11:                                               ; preds = %10
  br label %12, !dbg !483

12:                                               ; preds = %11
  ret void, !dbg !489
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_destroy(%struct.vqueue_ub_s* noundef %0) #0 !dbg !490 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !491, metadata !DIExpression()), !dbg !492
  call void @llvm.dbg.declare(metadata i8** %3, metadata !493, metadata !DIExpression()), !dbg !494
  store i8* null, i8** %3, align 8, !dbg !494
  br label %4, !dbg !495

4:                                                ; preds = %9, %1
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !496
  %6 = call i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %5, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_queue_destroy, i8* noundef null), !dbg !497
  store i8* %6, i8** %3, align 8, !dbg !498
  %7 = load i8*, i8** %3, align 8, !dbg !499
  %8 = icmp ne i8* %7, null, !dbg !495
  br i1 %8, label %9, label %11, !dbg !495

9:                                                ; preds = %4
  %10 = load i8*, i8** %3, align 8, !dbg !500
  call void @free(i8* noundef %10) #6, !dbg !502
  br label %4, !dbg !495, !llvm.loop !503

11:                                               ; preds = %4
  %12 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !506
  call void @vqueue_ub_destroy(%struct.vqueue_ub_s* noundef %12, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_queue_destroy, i8* noundef null), !dbg !507
  call void @ismr_destroy(), !dbg !508
  %13 = call zeroext i1 @vmem_no_leak(), !dbg !509
  br i1 %13, label %14, label %15, !dbg !512

14:                                               ; preds = %11
  br label %16, !dbg !512

15:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.12, i64 0, i64 0), i8* noundef getelementptr inbounds ([97 x i8], [97 x i8]* @.str.22, i64 0, i64 0), i32 noundef 166, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.queue_destroy, i64 0, i64 0)) #5, !dbg !509
  unreachable, !dbg !509

16:                                               ; preds = %14
  ret void, !dbg !513
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_enq(i64 noundef %0, %struct.vqueue_ub_s* noundef %1, i64 noundef %2, i8 noundef signext %3) #0 !dbg !514 {
  %5 = alloca i64, align 8
  %6 = alloca %struct.vqueue_ub_s*, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  %9 = alloca %struct.data_s*, align 8
  %10 = alloca %struct.vqueue_ub_node_s*, align 8
  store i64 %0, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !517, metadata !DIExpression()), !dbg !518
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %6, metadata !519, metadata !DIExpression()), !dbg !520
  store i64 %2, i64* %7, align 8
  call void @llvm.dbg.declare(metadata i64* %7, metadata !521, metadata !DIExpression()), !dbg !522
  store i8 %3, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !523, metadata !DIExpression()), !dbg !524
  call void @llvm.dbg.declare(metadata %struct.data_s** %9, metadata !525, metadata !DIExpression()), !dbg !526
  %11 = call noalias i8* @malloc(i64 noundef 16) #6, !dbg !527
  %12 = bitcast i8* %11 to %struct.data_s*, !dbg !527
  store %struct.data_s* %12, %struct.data_s** %9, align 8, !dbg !526
  %13 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !528
  %14 = icmp ne %struct.data_s* %13, null, !dbg !528
  br i1 %14, label %15, label %30, !dbg !530

15:                                               ; preds = %4
  %16 = load i64, i64* %7, align 8, !dbg !531
  %17 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !533
  %18 = getelementptr inbounds %struct.data_s, %struct.data_s* %17, i32 0, i32 0, !dbg !534
  store i64 %16, i64* %18, align 8, !dbg !535
  %19 = load i8, i8* %8, align 1, !dbg !536
  %20 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !537
  %21 = getelementptr inbounds %struct.data_s, %struct.data_s* %20, i32 0, i32 1, !dbg !538
  store i8 %19, i8* %21, align 8, !dbg !539
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %10, metadata !540, metadata !DIExpression()), !dbg !543
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %10, align 8, !dbg !543
  %22 = call i8* @vmem_malloc(i64 noundef 16), !dbg !544
  %23 = bitcast i8* %22 to %struct.vqueue_ub_node_s*, !dbg !544
  store %struct.vqueue_ub_node_s* %23, %struct.vqueue_ub_node_s** %10, align 8, !dbg !545
  %24 = load i64, i64* %5, align 8, !dbg !546
  call void @ismr_enter(i64 noundef %24), !dbg !547
  %25 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %6, align 8, !dbg !548
  %26 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !549
  %27 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !550
  %28 = bitcast %struct.data_s* %27 to i8*, !dbg !550
  call void @vqueue_ub_enq(%struct.vqueue_ub_s* noundef %25, %struct.vqueue_ub_node_s* noundef %26, i8* noundef %28), !dbg !551
  %29 = load i64, i64* %5, align 8, !dbg !552
  call void @ismr_exit(i64 noundef %29), !dbg !553
  br label %31, !dbg !554

30:                                               ; preds = %4
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([97 x i8], [97 x i8]* @.str.22, i64 0, i64 0), i32 noundef 196, i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @__PRETTY_FUNCTION__.queue_enq, i64 0, i64 0)) #5, !dbg !555
  unreachable, !dbg !555

31:                                               ; preds = %15
  ret void, !dbg !559
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @queue_deq(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !560 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca i8*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !563, metadata !DIExpression()), !dbg !564
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !565, metadata !DIExpression()), !dbg !566
  %6 = load i64, i64* %3, align 8, !dbg !567
  call void @ismr_enter(i64 noundef %6), !dbg !568
  call void @llvm.dbg.declare(metadata i8** %5, metadata !569, metadata !DIExpression()), !dbg !570
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !571
  %8 = load i64, i64* %3, align 8, !dbg !572
  %9 = inttoptr i64 %8 to i8*, !dbg !573
  %10 = call i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %7, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_queue_retire, i8* noundef %9), !dbg !574
  store i8* %10, i8** %5, align 8, !dbg !570
  %11 = load i64, i64* %3, align 8, !dbg !575
  call void @ismr_exit(i64 noundef %11), !dbg !576
  %12 = load i8*, i8** %5, align 8, !dbg !577
  ret i8* %12, !dbg !578
}

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @empty(i64 noundef %0) #0 !dbg !579 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !582, metadata !DIExpression()), !dbg !583
  %3 = load i64, i64* %2, align 8, !dbg !584
  %4 = call zeroext i1 @queue_empty(i64 noundef %3, %struct.vqueue_ub_s* noundef @g_queue), !dbg !585
  ret i1 %4, !dbg !586
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @queue_empty(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !587 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca i8, align 1
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !590, metadata !DIExpression()), !dbg !591
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !592, metadata !DIExpression()), !dbg !593
  %6 = load i64, i64* %3, align 8, !dbg !594
  call void @ismr_enter(i64 noundef %6), !dbg !595
  call void @llvm.dbg.declare(metadata i8* %5, metadata !596, metadata !DIExpression()), !dbg !597
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !598
  %8 = call zeroext i1 @vqueue_ub_empty(%struct.vqueue_ub_s* noundef %7), !dbg !599
  %9 = zext i1 %8 to i8, !dbg !597
  store i8 %9, i8* %5, align 1, !dbg !597
  %10 = load i64, i64* %3, align 8, !dbg !600
  call void @ismr_exit(i64 noundef %10), !dbg !601
  %11 = load i8, i8* %5, align 1, !dbg !602
  %12 = trunc i8 %11 to i1, !dbg !602
  ret i1 %12, !dbg !603
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_recycle(i64 noundef %0) #0 !dbg !604 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !605, metadata !DIExpression()), !dbg !606
  br label %3, !dbg !607

3:                                                ; preds = %1
  br label %4, !dbg !608

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !610
  br label %6, !dbg !610

6:                                                ; preds = %4
  br label %7, !dbg !612

7:                                                ; preds = %6
  br label %8, !dbg !610

8:                                                ; preds = %7
  br label %9, !dbg !608

9:                                                ; preds = %8
  ret void, !dbg !614
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !615 {
  %5 = alloca %struct.run_info_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8* (i8*)*, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !618, metadata !DIExpression()), !dbg !619
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !620, metadata !DIExpression()), !dbg !621
  store i8* (i8*)* %2, i8* (i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %7, metadata !622, metadata !DIExpression()), !dbg !623
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !624, metadata !DIExpression()), !dbg !625
  call void @llvm.dbg.declare(metadata i64* %9, metadata !626, metadata !DIExpression()), !dbg !627
  store i64 0, i64* %9, align 8, !dbg !627
  store i64 0, i64* %9, align 8, !dbg !628
  br label %11, !dbg !630

11:                                               ; preds = %42, %4
  %12 = load i64, i64* %9, align 8, !dbg !631
  %13 = load i64, i64* %6, align 8, !dbg !633
  %14 = icmp ult i64 %12, %13, !dbg !634
  br i1 %14, label %15, label %45, !dbg !635

15:                                               ; preds = %11
  %16 = load i64, i64* %9, align 8, !dbg !636
  %17 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !638
  %18 = load i64, i64* %9, align 8, !dbg !639
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %17, i64 %18, !dbg !638
  %20 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %19, i32 0, i32 1, !dbg !640
  store i64 %16, i64* %20, align 8, !dbg !641
  %21 = load i8* (i8*)*, i8* (i8*)** %7, align 8, !dbg !642
  %22 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !643
  %23 = load i64, i64* %9, align 8, !dbg !644
  %24 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %22, i64 %23, !dbg !643
  %25 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %24, i32 0, i32 3, !dbg !645
  store i8* (i8*)* %21, i8* (i8*)** %25, align 8, !dbg !646
  %26 = load i8, i8* %8, align 1, !dbg !647
  %27 = trunc i8 %26 to i1, !dbg !647
  %28 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !648
  %29 = load i64, i64* %9, align 8, !dbg !649
  %30 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %28, i64 %29, !dbg !648
  %31 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %30, i32 0, i32 2, !dbg !650
  %32 = zext i1 %27 to i8, !dbg !651
  store i8 %32, i8* %31, align 8, !dbg !651
  %33 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !652
  %34 = load i64, i64* %9, align 8, !dbg !653
  %35 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %33, i64 %34, !dbg !652
  %36 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %35, i32 0, i32 0, !dbg !654
  %37 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !655
  %38 = load i64, i64* %9, align 8, !dbg !656
  %39 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %37, i64 %38, !dbg !655
  %40 = bitcast %struct.run_info_t* %39 to i8*, !dbg !657
  %41 = call i32 @pthread_create(i64* noundef %36, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %40) #6, !dbg !658
  br label %42, !dbg !659

42:                                               ; preds = %15
  %43 = load i64, i64* %9, align 8, !dbg !660
  %44 = add i64 %43, 1, !dbg !660
  store i64 %44, i64* %9, align 8, !dbg !660
  br label %11, !dbg !661, !llvm.loop !662

45:                                               ; preds = %11
  ret void, !dbg !664
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !665 {
  %3 = alloca %struct.run_info_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !668, metadata !DIExpression()), !dbg !669
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !670, metadata !DIExpression()), !dbg !671
  call void @llvm.dbg.declare(metadata i64* %5, metadata !672, metadata !DIExpression()), !dbg !673
  store i64 0, i64* %5, align 8, !dbg !673
  store i64 0, i64* %5, align 8, !dbg !674
  br label %6, !dbg !676

6:                                                ; preds = %17, %2
  %7 = load i64, i64* %5, align 8, !dbg !677
  %8 = load i64, i64* %4, align 8, !dbg !679
  %9 = icmp ult i64 %7, %8, !dbg !680
  br i1 %9, label %10, label %20, !dbg !681

10:                                               ; preds = %6
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !682
  %12 = load i64, i64* %5, align 8, !dbg !684
  %13 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i64 %12, !dbg !682
  %14 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %13, i32 0, i32 0, !dbg !685
  %15 = load i64, i64* %14, align 8, !dbg !685
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !686
  br label %17, !dbg !687

17:                                               ; preds = %10
  %18 = load i64, i64* %5, align 8, !dbg !688
  %19 = add i64 %18, 1, !dbg !688
  store i64 %19, i64* %5, align 8, !dbg !688
  br label %6, !dbg !689, !llvm.loop !690

20:                                               ; preds = %6
  ret void, !dbg !692
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !693 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.run_info_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !694, metadata !DIExpression()), !dbg !695
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !696, metadata !DIExpression()), !dbg !697
  %4 = load i8*, i8** %2, align 8, !dbg !698
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !699
  store %struct.run_info_t* %5, %struct.run_info_t** %3, align 8, !dbg !697
  %6 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !700
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %6, i32 0, i32 2, !dbg !702
  %8 = load i8, i8* %7, align 8, !dbg !702
  %9 = trunc i8 %8 to i1, !dbg !702
  br i1 %9, label %10, label %14, !dbg !703

10:                                               ; preds = %1
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !704
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i32 0, i32 1, !dbg !705
  %13 = load i64, i64* %12, align 8, !dbg !705
  call void @set_cpu_affinity(i64 noundef %13), !dbg !706
  br label %14, !dbg !706

14:                                               ; preds = %10, %1
  %15 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !707
  %16 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %15, i32 0, i32 3, !dbg !708
  %17 = load i8* (i8*)*, i8* (i8*)** %16, align 8, !dbg !708
  %18 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !709
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %18, i32 0, i32 1, !dbg !710
  %20 = load i64, i64* %19, align 8, !dbg !710
  %21 = inttoptr i64 %20 to i8*, !dbg !711
  %22 = call i8* %17(i8* noundef %21), !dbg !707
  ret i8* %22, !dbg !712
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !713 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !714, metadata !DIExpression()), !dbg !715
  br label %3, !dbg !716

3:                                                ; preds = %1
  br label %4, !dbg !717

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !719
  br label %6, !dbg !719

6:                                                ; preds = %4
  br label %7, !dbg !721

7:                                                ; preds = %6
  br label %8, !dbg !719

8:                                                ; preds = %7
  br label %9, !dbg !717

9:                                                ; preds = %8
  ret void, !dbg !723
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @_vqueue_ub_visit_nodes(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !724 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !733, metadata !DIExpression()), !dbg !734
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !735, metadata !DIExpression()), !dbg !736
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !737, metadata !DIExpression()), !dbg !738
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !739, metadata !DIExpression()), !dbg !740
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !740
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !741, metadata !DIExpression()), !dbg !742
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !742
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !743
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 2, !dbg !744
  %11 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !744
  store %struct.vqueue_ub_node_s* %11, %struct.vqueue_ub_node_s** %7, align 8, !dbg !745
  %12 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !746
  %13 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %12, i32 0, i32 1, !dbg !747
  %14 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %13), !dbg !748
  %15 = bitcast i8* %14 to %struct.vqueue_ub_node_s*, !dbg !749
  store %struct.vqueue_ub_node_s* %15, %struct.vqueue_ub_node_s** %7, align 8, !dbg !750
  br label %16, !dbg !751

16:                                               ; preds = %19, %3
  %17 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !752
  %18 = icmp ne %struct.vqueue_ub_node_s* %17, null, !dbg !751
  br i1 %18, label %19, label %28, !dbg !751

19:                                               ; preds = %16
  %20 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !753
  %21 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %20, i32 0, i32 1, !dbg !755
  %22 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %21), !dbg !756
  %23 = bitcast i8* %22 to %struct.vqueue_ub_node_s*, !dbg !757
  store %struct.vqueue_ub_node_s* %23, %struct.vqueue_ub_node_s** %8, align 8, !dbg !758
  %24 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !759
  %25 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !760
  %26 = load i8*, i8** %6, align 8, !dbg !761
  call void %24(%struct.vqueue_ub_node_s* noundef %25, i8* noundef %26), !dbg !759
  %27 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !762
  store %struct.vqueue_ub_node_s* %27, %struct.vqueue_ub_node_s** %7, align 8, !dbg !763
  br label %16, !dbg !751, !llvm.loop !764

28:                                               ; preds = %16
  ret void, !dbg !766
}

; Function Attrs: noinline nounwind uwtable
define internal void @_redirect_print(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !767 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca void (i8*)*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !770, metadata !DIExpression()), !dbg !771
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !772, metadata !DIExpression()), !dbg !773
  call void @llvm.dbg.declare(metadata void (i8*)** %5, metadata !774, metadata !DIExpression()), !dbg !775
  %6 = load i8*, i8** %4, align 8, !dbg !776
  %7 = bitcast i8* %6 to void (i8*)*, !dbg !777
  store void (i8*)* %7, void (i8*)** %5, align 8, !dbg !775
  %8 = load void (i8*)*, void (i8*)** %5, align 8, !dbg !778
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !779
  %10 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %9, i32 0, i32 0, !dbg !780
  %11 = load i8*, i8** %10, align 8, !dbg !780
  call void %8(i8* noundef %11), !dbg !778
  ret void, !dbg !781
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !782 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !788, metadata !DIExpression()), !dbg !789
  call void @llvm.dbg.declare(metadata i8** %3, metadata !790, metadata !DIExpression()), !dbg !791
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !792
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !793
  %6 = load i8*, i8** %5, align 8, !dbg !793
  %7 = call i8* asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !794, !srcloc !795
  store i8* %7, i8** %3, align 8, !dbg !794
  %8 = load i8*, i8** %3, align 8, !dbg !796
  ret i8* %8, !dbg !797
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vmem_get_alloc_count() #0 !dbg !798 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !801, metadata !DIExpression()), !dbg !802
  %2 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef @_g_vmem_alloc_count), !dbg !803
  store i64 %2, i64* %1, align 8, !dbg !802
  br label %3, !dbg !804

3:                                                ; preds = %0
  br label %4, !dbg !805

4:                                                ; preds = %3
  %5 = load i64, i64* %1, align 8, !dbg !807
  br label %6, !dbg !807

6:                                                ; preds = %4
  br label %7, !dbg !809

7:                                                ; preds = %6
  br label %8, !dbg !807

8:                                                ; preds = %7
  br label %9, !dbg !805

9:                                                ; preds = %8
  %10 = load i64, i64* %1, align 8, !dbg !811
  ret i64 %10, !dbg !812
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vmem_get_free_count() #0 !dbg !813 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !814, metadata !DIExpression()), !dbg !815
  %2 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef @_g_vmem_free_count), !dbg !816
  store i64 %2, i64* %1, align 8, !dbg !815
  br label %3, !dbg !817

3:                                                ; preds = %0
  br label %4, !dbg !818

4:                                                ; preds = %3
  %5 = load i64, i64* %1, align 8, !dbg !820
  br label %6, !dbg !820

6:                                                ; preds = %4
  br label %7, !dbg !822

7:                                                ; preds = %6
  br label %8, !dbg !820

8:                                                ; preds = %7
  br label %9, !dbg !818

9:                                                ; preds = %8
  %10 = load i64, i64* %1, align 8, !dbg !824
  ret i64 %10, !dbg !825
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !826 {
  %2 = alloca %struct.vatomic64_s*, align 8
  %3 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !831, metadata !DIExpression()), !dbg !832
  call void @llvm.dbg.declare(metadata i64* %3, metadata !833, metadata !DIExpression()), !dbg !834
  %4 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !835
  %5 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %4, i32 0, i32 0, !dbg !836
  %6 = load i64, i64* %5, align 8, !dbg !836
  %7 = call i64 asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i64 %6) #6, !dbg !837, !srcloc !838
  store i64 %7, i64* %3, align 8, !dbg !837
  %8 = load i64, i64* %3, align 8, !dbg !839
  ret i64 %8, !dbg !840
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_init() #0 !dbg !841 {
  call void @locked_trace_init(%struct.locked_trace_s* noundef @global_trace, i64 noundef 100), !dbg !842
  ret void, !dbg !843
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_init(%struct.vqueue_ub_s* noundef %0) #0 !dbg !844 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !847, metadata !DIExpression()), !dbg !848
  %3 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !849
  %4 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %3, i32 0, i32 4, !dbg !850
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !851
  %6 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %5, i32 0, i32 2, !dbg !852
  store %struct.vqueue_ub_node_s* %4, %struct.vqueue_ub_node_s** %6, align 8, !dbg !853
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !854
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 4, !dbg !855
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !856
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 3, !dbg !857
  store %struct.vqueue_ub_node_s* %8, %struct.vqueue_ub_node_s** %10, align 8, !dbg !858
  %11 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !859
  %12 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %11, i32 0, i32 4, !dbg !860
  call void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %12, i8* noundef null), !dbg !861
  %13 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !862
  %14 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %13, i32 0, i32 0, !dbg !863
  call void @queue_lock_init(%union.pthread_mutex_t* noundef %14), !dbg !864
  %15 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !865
  %16 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %15, i32 0, i32 1, !dbg !866
  call void @queue_lock_init(%union.pthread_mutex_t* noundef %16), !dbg !867
  ret void, !dbg !868
}

; Function Attrs: noinline nounwind uwtable
define internal void @locked_trace_init(%struct.locked_trace_s* noundef %0, i64 noundef %1) #0 !dbg !869 {
  %3 = alloca %struct.locked_trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.locked_trace_s* %0, %struct.locked_trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.locked_trace_s** %3, metadata !873, metadata !DIExpression()), !dbg !874
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !875, metadata !DIExpression()), !dbg !876
  %5 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !877
  %6 = icmp ne %struct.locked_trace_s* %5, null, !dbg !877
  br i1 %6, label %7, label %8, !dbg !880

7:                                                ; preds = %2
  br label %9, !dbg !880

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([64 x i8], [64 x i8]* @.str.19, i64 0, i64 0), i32 noundef 16, i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @__PRETTY_FUNCTION__.locked_trace_init, i64 0, i64 0)) #5, !dbg !877
  unreachable, !dbg !877

9:                                                ; preds = %7
  %10 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !881
  %11 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %10, i32 0, i32 1, !dbg !882
  %12 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %11, %union.pthread_mutexattr_t* noundef null) #6, !dbg !883
  %13 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !884
  %14 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %13, i32 0, i32 0, !dbg !885
  %15 = load i64, i64* %4, align 8, !dbg !886
  call void @trace_init(%struct.trace_s* noundef %14, i64 noundef %15), !dbg !887
  ret void, !dbg !888
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @trace_init(%struct.trace_s* noundef %0, i64 noundef %1) #0 !dbg !889 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !893, metadata !DIExpression()), !dbg !894
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !895, metadata !DIExpression()), !dbg !896
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !897
  %6 = icmp ne %struct.trace_s* %5, null, !dbg !897
  br i1 %6, label %7, label %8, !dbg !900

7:                                                ; preds = %2
  br label %9, !dbg !900

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.20, i64 0, i64 0), i32 noundef 30, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !897
  unreachable, !dbg !897

9:                                                ; preds = %7
  %10 = load i64, i64* %4, align 8, !dbg !901
  %11 = mul i64 %10, 16, !dbg !902
  %12 = call noalias i8* @malloc(i64 noundef %11) #6, !dbg !903
  %13 = bitcast i8* %12 to %struct.trace_unit_s*, !dbg !903
  %14 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !904
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 0, !dbg !905
  store %struct.trace_unit_s* %13, %struct.trace_unit_s** %15, align 8, !dbg !906
  %16 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !907
  %17 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %16, i32 0, i32 0, !dbg !909
  %18 = load %struct.trace_unit_s*, %struct.trace_unit_s** %17, align 8, !dbg !909
  %19 = icmp ne %struct.trace_unit_s* %18, null, !dbg !907
  br i1 %19, label %20, label %28, !dbg !910

20:                                               ; preds = %9
  %21 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !911
  %22 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %21, i32 0, i32 1, !dbg !913
  store i64 0, i64* %22, align 8, !dbg !914
  %23 = load i64, i64* %4, align 8, !dbg !915
  %24 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !916
  %25 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %24, i32 0, i32 2, !dbg !917
  store i64 %23, i64* %25, align 8, !dbg !918
  %26 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !919
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 3, !dbg !920
  store i8 1, i8* %27, align 8, !dbg !921
  br label %35, !dbg !922

28:                                               ; preds = %9
  %29 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !923
  %30 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %29, i32 0, i32 1, !dbg !925
  store i64 0, i64* %30, align 8, !dbg !926
  %31 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !927
  %32 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %31, i32 0, i32 2, !dbg !928
  store i64 0, i64* %32, align 8, !dbg !929
  %33 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !930
  %34 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %33, i32 0, i32 3, !dbg !931
  store i8 0, i8* %34, align 8, !dbg !932
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.20, i64 0, i64 0), i32 noundef 40, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !933
  unreachable, !dbg !933

35:                                               ; preds = %20
  ret void, !dbg !936
}

; Function Attrs: noinline nounwind uwtable
define internal void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !937 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !938, metadata !DIExpression()), !dbg !939
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !940, metadata !DIExpression()), !dbg !941
  %5 = load i8*, i8** %4, align 8, !dbg !942
  %6 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !943
  %7 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %6, i32 0, i32 0, !dbg !944
  store i8* %5, i8** %7, align 8, !dbg !945
  %8 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !946
  %9 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %8, i32 0, i32 1, !dbg !947
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %9, i8* noundef null), !dbg !948
  ret void, !dbg !949
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_init(%union.pthread_mutex_t* noundef %0) #0 !dbg !950 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !954, metadata !DIExpression()), !dbg !955
  %3 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !955
  %4 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %3, %union.pthread_mutexattr_t* noundef null) #6, !dbg !955
  ret void, !dbg !955
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !956 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !960, metadata !DIExpression()), !dbg !961
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !962, metadata !DIExpression()), !dbg !963
  %5 = load i8*, i8** %4, align 8, !dbg !964
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !965
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !966
  %8 = load i8*, i8** %7, align 8, !dbg !966
  call void asm sideeffect "str ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !967, !srcloc !968
  ret void, !dbg !969
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_reg(i64 noundef %0) #0 !dbg !970 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !971, metadata !DIExpression()), !dbg !972
  br label %3, !dbg !973

3:                                                ; preds = %1
  br label %4, !dbg !974

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !976
  br label %6, !dbg !976

6:                                                ; preds = %4
  br label %7, !dbg !978

7:                                                ; preds = %6
  br label %8, !dbg !976

8:                                                ; preds = %7
  br label %9, !dbg !974

9:                                                ; preds = %8
  ret void, !dbg !980
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_dereg(i64 noundef %0) #0 !dbg !981 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !982, metadata !DIExpression()), !dbg !983
  br label %3, !dbg !984

3:                                                ; preds = %1
  br label %4, !dbg !985

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !987
  br label %6, !dbg !987

6:                                                ; preds = %4
  br label %7, !dbg !989

7:                                                ; preds = %6
  br label %8, !dbg !987

8:                                                ; preds = %7
  br label %9, !dbg !985

9:                                                ; preds = %8
  ret void, !dbg !991
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !992 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  %9 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !995, metadata !DIExpression()), !dbg !996
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !997, metadata !DIExpression()), !dbg !998
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !999, metadata !DIExpression()), !dbg !1000
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !1001, metadata !DIExpression()), !dbg !1002
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1002
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !1003, metadata !DIExpression()), !dbg !1004
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1004
  call void @llvm.dbg.declare(metadata i8** %9, metadata !1005, metadata !DIExpression()), !dbg !1006
  store i8* null, i8** %9, align 8, !dbg !1006
  %10 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1007
  %11 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %10, i32 0, i32 1, !dbg !1008
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %11), !dbg !1009
  %12 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1010
  %13 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %12, i32 0, i32 2, !dbg !1011
  %14 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %13, align 8, !dbg !1011
  store %struct.vqueue_ub_node_s* %14, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1012
  %15 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1013
  %16 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %15, i32 0, i32 1, !dbg !1014
  %17 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %16), !dbg !1015
  %18 = bitcast i8* %17 to %struct.vqueue_ub_node_s*, !dbg !1016
  store %struct.vqueue_ub_node_s* %18, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1017
  %19 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1018
  %20 = icmp ne %struct.vqueue_ub_node_s* %19, null, !dbg !1018
  br i1 %20, label %21, label %37, !dbg !1020

21:                                               ; preds = %3
  %22 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1021
  %23 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %22, i32 0, i32 0, !dbg !1023
  %24 = load i8*, i8** %23, align 8, !dbg !1023
  store i8* %24, i8** %9, align 8, !dbg !1024
  %25 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1025
  %26 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1026
  %27 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %26, i32 0, i32 2, !dbg !1027
  store %struct.vqueue_ub_node_s* %25, %struct.vqueue_ub_node_s** %27, align 8, !dbg !1028
  %28 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1029
  %29 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1031
  %30 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %29, i32 0, i32 4, !dbg !1032
  %31 = icmp ne %struct.vqueue_ub_node_s* %28, %30, !dbg !1033
  br i1 %31, label %32, label %36, !dbg !1034

32:                                               ; preds = %21
  %33 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !1035
  %34 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1037
  %35 = load i8*, i8** %6, align 8, !dbg !1038
  call void %33(%struct.vqueue_ub_node_s* noundef %34, i8* noundef %35), !dbg !1035
  br label %36, !dbg !1039

36:                                               ; preds = %32, %21
  br label %37, !dbg !1040

37:                                               ; preds = %36, %3
  %38 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1041
  %39 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %38, i32 0, i32 1, !dbg !1042
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %39), !dbg !1043
  %40 = load i8*, i8** %9, align 8, !dbg !1044
  ret i8* %40, !dbg !1045
}

; Function Attrs: noinline nounwind uwtable
define internal void @_queue_destroy(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !1046 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1049, metadata !DIExpression()), !dbg !1050
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1051, metadata !DIExpression()), !dbg !1052
  %5 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1053
  %6 = bitcast %struct.vqueue_ub_node_s* %5 to i8*, !dbg !1053
  call void @vmem_free(i8* noundef %6), !dbg !1054
  br label %7, !dbg !1055

7:                                                ; preds = %2
  br label %8, !dbg !1056

8:                                                ; preds = %7
  %9 = load i8*, i8** %4, align 8, !dbg !1058
  br label %10, !dbg !1058

10:                                               ; preds = %8
  br label %11, !dbg !1060

11:                                               ; preds = %10
  br label %12, !dbg !1058

12:                                               ; preds = %11
  br label %13, !dbg !1056

13:                                               ; preds = %12
  ret void, !dbg !1062
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_destroy(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !1063 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !1064, metadata !DIExpression()), !dbg !1065
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !1066, metadata !DIExpression()), !dbg !1067
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !1068, metadata !DIExpression()), !dbg !1069
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !1070, metadata !DIExpression()), !dbg !1071
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1071
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !1072, metadata !DIExpression()), !dbg !1073
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1073
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1074
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 2, !dbg !1075
  %11 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !1075
  store %struct.vqueue_ub_node_s* %11, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1076
  br label %12, !dbg !1077

12:                                               ; preds = %28, %3
  %13 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1078
  %14 = icmp ne %struct.vqueue_ub_node_s* %13, null, !dbg !1077
  br i1 %14, label %15, label %30, !dbg !1077

15:                                               ; preds = %12
  %16 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1079
  %17 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %16, i32 0, i32 1, !dbg !1081
  %18 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %17), !dbg !1082
  %19 = bitcast i8* %18 to %struct.vqueue_ub_node_s*, !dbg !1083
  store %struct.vqueue_ub_node_s* %19, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1084
  %20 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1085
  %21 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1087
  %22 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %21, i32 0, i32 4, !dbg !1088
  %23 = icmp ne %struct.vqueue_ub_node_s* %20, %22, !dbg !1089
  br i1 %23, label %24, label %28, !dbg !1090

24:                                               ; preds = %15
  %25 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !1091
  %26 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1093
  %27 = load i8*, i8** %6, align 8, !dbg !1094
  call void %25(%struct.vqueue_ub_node_s* noundef %26, i8* noundef %27), !dbg !1091
  br label %28, !dbg !1095

28:                                               ; preds = %24, %15
  %29 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1096
  store %struct.vqueue_ub_node_s* %29, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1097
  br label %12, !dbg !1077, !llvm.loop !1098

30:                                               ; preds = %12
  ret void, !dbg !1100
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_destroy() #0 !dbg !1101 {
  call void @locked_trace_destroy(%struct.locked_trace_s* noundef @global_trace, i1 (%struct.trace_unit_s*)* noundef @_ismr_none_destroy_all_cb), !dbg !1102
  ret void, !dbg !1103
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_acquire(%union.pthread_mutex_t* noundef %0) #0 !dbg !1104 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !1105, metadata !DIExpression()), !dbg !1106
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1107, metadata !DIExpression()), !dbg !1106
  %4 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !1106
  %5 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef %4) #6, !dbg !1106
  store i32 %5, i32* %3, align 4, !dbg !1106
  %6 = load i32, i32* %3, align 4, !dbg !1108
  %7 = icmp eq i32 %6, 0, !dbg !1108
  br i1 %7, label %8, label %9, !dbg !1111

8:                                                ; preds = %1
  br label %10, !dbg !1111

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.23, i64 0, i64 0), i8* noundef getelementptr inbounds ([101 x i8], [101 x i8]* @.str.24, i64 0, i64 0), i32 noundef 32, i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.queue_lock_acquire, i64 0, i64 0)) #5, !dbg !1108
  unreachable, !dbg !1108

10:                                               ; preds = %8
  ret void, !dbg !1106
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %0) #0 !dbg !1112 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !1113, metadata !DIExpression()), !dbg !1114
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1115, metadata !DIExpression()), !dbg !1116
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !1117
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !1118
  %6 = load i8*, i8** %5, align 8, !dbg !1118
  %7 = call i8* asm sideeffect "ldar ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !1119, !srcloc !1120
  store i8* %7, i8** %3, align 8, !dbg !1119
  %8 = load i8*, i8** %3, align 8, !dbg !1121
  ret i8* %8, !dbg !1122
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_release(%union.pthread_mutex_t* noundef %0) #0 !dbg !1123 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !1124, metadata !DIExpression()), !dbg !1125
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1126, metadata !DIExpression()), !dbg !1125
  %4 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !1125
  %5 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef %4) #6, !dbg !1125
  store i32 %5, i32* %3, align 4, !dbg !1125
  %6 = load i32, i32* %3, align 4, !dbg !1127
  %7 = icmp eq i32 %6, 0, !dbg !1127
  br i1 %7, label %8, label %9, !dbg !1130

8:                                                ; preds = %1
  br label %10, !dbg !1130

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.23, i64 0, i64 0), i8* noundef getelementptr inbounds ([101 x i8], [101 x i8]* @.str.24, i64 0, i64 0), i32 noundef 32, i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.queue_lock_release, i64 0, i64 0)) #5, !dbg !1127
  unreachable, !dbg !1127

10:                                               ; preds = %8
  ret void, !dbg !1125
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @vmem_free(i8* noundef %0) #0 !dbg !1131 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !1132, metadata !DIExpression()), !dbg !1133
  %3 = load i8*, i8** %2, align 8, !dbg !1134
  call void @free(i8* noundef %3) #6, !dbg !1135
  %4 = load i8*, i8** %2, align 8, !dbg !1136
  %5 = icmp ne i8* %4, null, !dbg !1136
  br i1 %5, label %6, label %7, !dbg !1138

6:                                                ; preds = %1
  call void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef @_g_vmem_free_count), !dbg !1139
  br label %7, !dbg !1141

7:                                                ; preds = %6, %1
  ret void, !dbg !1142
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !1143 {
  %2 = alloca %struct.vatomic64_s*, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !1148, metadata !DIExpression()), !dbg !1149
  %3 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !1150
  %4 = call i64 @vatomic64_get_inc_rlx(%struct.vatomic64_s* noundef %3), !dbg !1151
  ret void, !dbg !1152
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_get_inc_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !1153 {
  %2 = alloca %struct.vatomic64_s*, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !1156, metadata !DIExpression()), !dbg !1157
  %3 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !1158
  %4 = call i64 @vatomic64_get_add_rlx(%struct.vatomic64_s* noundef %3, i64 noundef 1), !dbg !1159
  ret i64 %4, !dbg !1160
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_get_add_rlx(%struct.vatomic64_s* noundef %0, i64 noundef %1) #0 !dbg !1161 {
  %3 = alloca %struct.vatomic64_s*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %3, metadata !1165, metadata !DIExpression()), !dbg !1166
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1167, metadata !DIExpression()), !dbg !1168
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1169, metadata !DIExpression()), !dbg !1170
  call void @llvm.dbg.declare(metadata i32* %6, metadata !1171, metadata !DIExpression()), !dbg !1175
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1176, metadata !DIExpression()), !dbg !1177
  %8 = load i64, i64* %4, align 8, !dbg !1178
  %9 = load %struct.vatomic64_s*, %struct.vatomic64_s** %3, align 8, !dbg !1179
  %10 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %9, i32 0, i32 0, !dbg !1180
  %11 = load i64, i64* %10, align 8, !dbg !1180
  %12 = call { i64, i64, i32, i64 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:x}, $4\0Aadd ${1:x}, ${0:x}, ${3:x}\0Astxr ${2:w}, ${1:x}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i64 %11, i64 %8) #6, !dbg !1178, !srcloc !1181
  %13 = extractvalue { i64, i64, i32, i64 } %12, 0, !dbg !1178
  %14 = extractvalue { i64, i64, i32, i64 } %12, 1, !dbg !1178
  %15 = extractvalue { i64, i64, i32, i64 } %12, 2, !dbg !1178
  %16 = extractvalue { i64, i64, i32, i64 } %12, 3, !dbg !1178
  store i64 %13, i64* %5, align 8, !dbg !1178
  store i64 %14, i64* %7, align 8, !dbg !1178
  store i32 %15, i32* %6, align 4, !dbg !1178
  store i64 %16, i64* %4, align 8, !dbg !1178
  %17 = load i64, i64* %5, align 8, !dbg !1182
  ret i64 %17, !dbg !1183
}

; Function Attrs: noinline nounwind uwtable
define internal void @locked_trace_destroy(%struct.locked_trace_s* noundef %0, i1 (%struct.trace_unit_s*)* noundef %1) #0 !dbg !1184 {
  %3 = alloca %struct.locked_trace_s*, align 8
  %4 = alloca i1 (%struct.trace_unit_s*)*, align 8
  store %struct.locked_trace_s* %0, %struct.locked_trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.locked_trace_s** %3, metadata !1191, metadata !DIExpression()), !dbg !1192
  store i1 (%struct.trace_unit_s*)* %1, i1 (%struct.trace_unit_s*)** %4, align 8
  call void @llvm.dbg.declare(metadata i1 (%struct.trace_unit_s*)** %4, metadata !1193, metadata !DIExpression()), !dbg !1194
  %5 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1195
  %6 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %5, i32 0, i32 0, !dbg !1196
  %7 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %4, align 8, !dbg !1197
  %8 = call zeroext i1 @trace_verify(%struct.trace_s* noundef %6, i1 (%struct.trace_unit_s*)* noundef %7), !dbg !1198
  %9 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1199
  %10 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %9, i32 0, i32 0, !dbg !1200
  call void @trace_destroy(%struct.trace_s* noundef %10), !dbg !1201
  %11 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1202
  %12 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %11, i32 0, i32 1, !dbg !1203
  %13 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef %12) #6, !dbg !1204
  ret void, !dbg !1205
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @_ismr_none_destroy_all_cb(%struct.trace_unit_s* noundef %0) #0 !dbg !1206 {
  %2 = alloca %struct.trace_unit_s*, align 8
  %3 = alloca %struct.smr_none_retire_info_t*, align 8
  store %struct.trace_unit_s* %0, %struct.trace_unit_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %2, metadata !1207, metadata !DIExpression()), !dbg !1208
  %4 = load %struct.trace_unit_s*, %struct.trace_unit_s** %2, align 8, !dbg !1209
  %5 = icmp ne %struct.trace_unit_s* %4, null, !dbg !1209
  br i1 %5, label %6, label %7, !dbg !1212

6:                                                ; preds = %1
  br label %8, !dbg !1212

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.27, i64 0, i64 0), i8* noundef getelementptr inbounds ([70 x i8], [70 x i8]* @.str.28, i64 0, i64 0), i32 noundef 27, i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @__PRETTY_FUNCTION__._ismr_none_destroy_all_cb, i64 0, i64 0)) #5, !dbg !1209
  unreachable, !dbg !1209

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata %struct.smr_none_retire_info_t** %3, metadata !1213, metadata !DIExpression()), !dbg !1214
  %9 = load %struct.trace_unit_s*, %struct.trace_unit_s** %2, align 8, !dbg !1215
  %10 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %9, i32 0, i32 0, !dbg !1216
  %11 = load i64, i64* %10, align 8, !dbg !1216
  %12 = inttoptr i64 %11 to %struct.smr_none_retire_info_t*, !dbg !1217
  store %struct.smr_none_retire_info_t* %12, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1214
  %13 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1218
  %14 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %13, i32 0, i32 1, !dbg !1219
  %15 = load void (%struct.smr_node_s*, i8*)*, void (%struct.smr_node_s*, i8*)** %14, align 8, !dbg !1219
  %16 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1220
  %17 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %16, i32 0, i32 0, !dbg !1221
  %18 = load %struct.smr_node_s*, %struct.smr_node_s** %17, align 8, !dbg !1221
  %19 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1222
  %20 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %19, i32 0, i32 2, !dbg !1223
  %21 = load i8*, i8** %20, align 8, !dbg !1223
  call void %15(%struct.smr_node_s* noundef %18, i8* noundef %21), !dbg !1218
  %22 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1224
  %23 = bitcast %struct.smr_none_retire_info_t* %22 to i8*, !dbg !1224
  call void @free(i8* noundef %23) #6, !dbg !1225
  ret i1 true, !dbg !1226
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @trace_verify(%struct.trace_s* noundef %0, i1 (%struct.trace_unit_s*)* noundef %1) #0 !dbg !1227 {
  %3 = alloca i1, align 1
  %4 = alloca %struct.trace_s*, align 8
  %5 = alloca i1 (%struct.trace_unit_s*)*, align 8
  %6 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !1230, metadata !DIExpression()), !dbg !1231
  store i1 (%struct.trace_unit_s*)* %1, i1 (%struct.trace_unit_s*)** %5, align 8
  call void @llvm.dbg.declare(metadata i1 (%struct.trace_unit_s*)** %5, metadata !1232, metadata !DIExpression()), !dbg !1233
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1234, metadata !DIExpression()), !dbg !1235
  store i64 0, i64* %6, align 8, !dbg !1235
  %7 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1236
  %8 = icmp ne %struct.trace_s* %7, null, !dbg !1236
  br i1 %8, label %9, label %10, !dbg !1239

9:                                                ; preds = %2
  br label %11, !dbg !1239

10:                                               ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.20, i64 0, i64 0), i32 noundef 214, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #5, !dbg !1236
  unreachable, !dbg !1236

11:                                               ; preds = %9
  %12 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1240
  %13 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %12, i32 0, i32 3, !dbg !1240
  %14 = load i8, i8* %13, align 8, !dbg !1240
  %15 = trunc i8 %14 to i1, !dbg !1240
  br i1 %15, label %16, label %17, !dbg !1243

16:                                               ; preds = %11
  br label %18, !dbg !1243

17:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.25, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.20, i64 0, i64 0), i32 noundef 215, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #5, !dbg !1240
  unreachable, !dbg !1240

18:                                               ; preds = %16
  %19 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %5, align 8, !dbg !1244
  %20 = icmp ne i1 (%struct.trace_unit_s*)* %19, null, !dbg !1244
  br i1 %20, label %21, label %22, !dbg !1247

21:                                               ; preds = %18
  br label %23, !dbg !1247

22:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.20, i64 0, i64 0), i32 noundef 216, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #5, !dbg !1244
  unreachable, !dbg !1244

23:                                               ; preds = %21
  store i64 0, i64* %6, align 8, !dbg !1248
  br label %24, !dbg !1250

24:                                               ; preds = %42, %23
  %25 = load i64, i64* %6, align 8, !dbg !1251
  %26 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1253
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 1, !dbg !1254
  %28 = load i64, i64* %27, align 8, !dbg !1254
  %29 = icmp ult i64 %25, %28, !dbg !1255
  br i1 %29, label %30, label %45, !dbg !1256

30:                                               ; preds = %24
  %31 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %5, align 8, !dbg !1257
  %32 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1260
  %33 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %32, i32 0, i32 0, !dbg !1261
  %34 = load %struct.trace_unit_s*, %struct.trace_unit_s** %33, align 8, !dbg !1261
  %35 = load i64, i64* %6, align 8, !dbg !1262
  %36 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %34, i64 %35, !dbg !1260
  %37 = call zeroext i1 %31(%struct.trace_unit_s* noundef %36), !dbg !1257
  %38 = zext i1 %37 to i32, !dbg !1257
  %39 = icmp eq i32 %38, 0, !dbg !1263
  br i1 %39, label %40, label %41, !dbg !1264

40:                                               ; preds = %30
  store i1 false, i1* %3, align 1, !dbg !1265
  br label %46, !dbg !1265

41:                                               ; preds = %30
  br label %42, !dbg !1267

42:                                               ; preds = %41
  %43 = load i64, i64* %6, align 8, !dbg !1268
  %44 = add i64 %43, 1, !dbg !1268
  store i64 %44, i64* %6, align 8, !dbg !1268
  br label %24, !dbg !1269, !llvm.loop !1270

45:                                               ; preds = %24
  store i1 true, i1* %3, align 1, !dbg !1272
  br label %46, !dbg !1272

46:                                               ; preds = %45, %40
  %47 = load i1, i1* %3, align 1, !dbg !1273
  ret i1 %47, !dbg !1273
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_destroy(%struct.trace_s* noundef %0) #0 !dbg !1274 {
  %2 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %2, metadata !1277, metadata !DIExpression()), !dbg !1278
  %3 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1279
  %4 = icmp ne %struct.trace_s* %3, null, !dbg !1279
  br i1 %4, label %5, label %6, !dbg !1282

5:                                                ; preds = %1
  br label %7, !dbg !1282

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.20, i64 0, i64 0), i32 noundef 99, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !1279
  unreachable, !dbg !1279

7:                                                ; preds = %5
  %8 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1283
  %9 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %8, i32 0, i32 3, !dbg !1283
  %10 = load i8, i8* %9, align 8, !dbg !1283
  %11 = trunc i8 %10 to i1, !dbg !1283
  br i1 %11, label %12, label %13, !dbg !1286

12:                                               ; preds = %7
  br label %14, !dbg !1286

13:                                               ; preds = %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.25, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.20, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !1283
  unreachable, !dbg !1283

14:                                               ; preds = %12
  %15 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1287
  %16 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %15, i32 0, i32 0, !dbg !1288
  %17 = load %struct.trace_unit_s*, %struct.trace_unit_s** %16, align 8, !dbg !1288
  %18 = bitcast %struct.trace_unit_s* %17 to i8*, !dbg !1287
  call void @free(i8* noundef %18) #6, !dbg !1289
  %19 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1290
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 3, !dbg !1291
  store i8 0, i8* %20, align 8, !dbg !1292
  ret void, !dbg !1293
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @vmem_malloc(i64 noundef %0) #0 !dbg !1294 {
  %2 = alloca i64, align 8
  %3 = alloca i8*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1297, metadata !DIExpression()), !dbg !1298
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1299, metadata !DIExpression()), !dbg !1300
  %4 = load i64, i64* %2, align 8, !dbg !1301
  %5 = call noalias i8* @malloc(i64 noundef %4) #6, !dbg !1302
  store i8* %5, i8** %3, align 8, !dbg !1300
  %6 = load i8*, i8** %3, align 8, !dbg !1303
  %7 = icmp ne i8* %6, null, !dbg !1303
  br i1 %7, label %8, label %9, !dbg !1305

8:                                                ; preds = %1
  call void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef @_g_vmem_alloc_count), !dbg !1306
  br label %10, !dbg !1308

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.29, i64 0, i64 0), i32 noundef 28, i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @__PRETTY_FUNCTION__.vmem_malloc, i64 0, i64 0)) #5, !dbg !1309
  unreachable, !dbg !1309

10:                                               ; preds = %8
  %11 = load i8*, i8** %3, align 8, !dbg !1313
  ret i8* %11, !dbg !1314
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_enter(i64 noundef %0) #0 !dbg !1315 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1316, metadata !DIExpression()), !dbg !1317
  br label %3, !dbg !1318

3:                                                ; preds = %1
  br label %4, !dbg !1319

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1321
  br label %6, !dbg !1321

6:                                                ; preds = %4
  br label %7, !dbg !1323

7:                                                ; preds = %6
  br label %8, !dbg !1321

8:                                                ; preds = %7
  br label %9, !dbg !1319

9:                                                ; preds = %8
  ret void, !dbg !1325
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_enq(%struct.vqueue_ub_s* noundef %0, %struct.vqueue_ub_node_s* noundef %1, i8* noundef %2) #0 !dbg !1326 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca %struct.vqueue_ub_node_s*, align 8
  %6 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !1329, metadata !DIExpression()), !dbg !1330
  store %struct.vqueue_ub_node_s* %1, %struct.vqueue_ub_node_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %5, metadata !1331, metadata !DIExpression()), !dbg !1332
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !1333, metadata !DIExpression()), !dbg !1334
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1335
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 0, !dbg !1336
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %8), !dbg !1337
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1338
  %10 = load i8*, i8** %6, align 8, !dbg !1339
  call void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %9, i8* noundef %10), !dbg !1340
  %11 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1341
  %12 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %11, i32 0, i32 3, !dbg !1342
  %13 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %12, align 8, !dbg !1342
  %14 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %13, i32 0, i32 1, !dbg !1343
  %15 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1344
  %16 = bitcast %struct.vqueue_ub_node_s* %15 to i8*, !dbg !1344
  call void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %14, i8* noundef %16), !dbg !1345
  %17 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1346
  %18 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1347
  %19 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %18, i32 0, i32 3, !dbg !1348
  store %struct.vqueue_ub_node_s* %17, %struct.vqueue_ub_node_s** %19, align 8, !dbg !1349
  %20 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1350
  %21 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %20, i32 0, i32 0, !dbg !1351
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %21), !dbg !1352
  ret void, !dbg !1353
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_exit(i64 noundef %0) #0 !dbg !1354 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1355, metadata !DIExpression()), !dbg !1356
  br label %3, !dbg !1357

3:                                                ; preds = %1
  br label %4, !dbg !1358

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1360
  br label %6, !dbg !1360

6:                                                ; preds = %4
  br label %7, !dbg !1362

7:                                                ; preds = %6
  br label %8, !dbg !1360

8:                                                ; preds = %7
  br label %9, !dbg !1358

9:                                                ; preds = %8
  ret void, !dbg !1364
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1365 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1366, metadata !DIExpression()), !dbg !1367
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1368, metadata !DIExpression()), !dbg !1369
  %5 = load i8*, i8** %4, align 8, !dbg !1370
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !1371
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !1372
  %8 = load i8*, i8** %7, align 8, !dbg !1372
  call void asm sideeffect "stlr ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !1373, !srcloc !1374
  ret void, !dbg !1375
}

; Function Attrs: noinline nounwind uwtable
define internal void @_queue_retire(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !1376 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1377, metadata !DIExpression()), !dbg !1378
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1379, metadata !DIExpression()), !dbg !1380
  %5 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1381
  %6 = bitcast %struct.vqueue_ub_node_s* %5 to i8*, !dbg !1381
  call void @vmem_free(i8* noundef %6), !dbg !1382
  br label %7, !dbg !1383

7:                                                ; preds = %2
  br label %8, !dbg !1384

8:                                                ; preds = %7
  %9 = load i8*, i8** %4, align 8, !dbg !1386
  br label %10, !dbg !1386

10:                                               ; preds = %8
  br label %11, !dbg !1388

11:                                               ; preds = %10
  br label %12, !dbg !1386

12:                                               ; preds = %11
  br label %13, !dbg !1384

13:                                               ; preds = %12
  ret void, !dbg !1390
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @vqueue_ub_empty(%struct.vqueue_ub_s* noundef %0) #0 !dbg !1391 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !1394, metadata !DIExpression()), !dbg !1395
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1396, metadata !DIExpression()), !dbg !1397
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1397
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %4, metadata !1398, metadata !DIExpression()), !dbg !1399
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1399
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1400
  %6 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %5, i32 0, i32 1, !dbg !1401
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %6), !dbg !1402
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1403
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 2, !dbg !1404
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1404
  store %struct.vqueue_ub_node_s* %9, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1405
  %10 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1406
  %11 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %10, i32 0, i32 1, !dbg !1407
  %12 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %11), !dbg !1408
  %13 = bitcast i8* %12 to %struct.vqueue_ub_node_s*, !dbg !1409
  store %struct.vqueue_ub_node_s* %13, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1410
  %14 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1411
  %15 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %14, i32 0, i32 1, !dbg !1412
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %15), !dbg !1413
  %16 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1414
  %17 = icmp eq %struct.vqueue_ub_node_s* %16, null, !dbg !1415
  ret i1 %17, !dbg !1416
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!171, !172, !173, !174, !175, !176, !177}
!llvm.ident = !{!178}

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
!76 = !{!0, !77, !89, !92, !95, !97, !99, !101, !154, !166}
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
!93 = distinct !DIGlobalVariable(name: "msg", scope: !2, file: !94, line: 1, type: !66, isLocal: false, isDefinition: true)
!94 = !DIFile(filename: "datastruct/queue/unbounded/verify/test_case_1.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "3ed2ee8cdfebac763b1acfd331ac1620")
!95 = !DIGlobalVariableExpression(var: !96, expr: !DIExpression())
!96 = distinct !DIGlobalVariable(name: "g_t1_deq", scope: !2, file: !94, line: 19, type: !84, isLocal: false, isDefinition: true)
!97 = !DIGlobalVariableExpression(var: !98, expr: !DIExpression())
!98 = distinct !DIGlobalVariable(name: "g_deq_success", scope: !2, file: !94, line: 37, type: !24, isLocal: false, isDefinition: true)
!99 = !DIGlobalVariableExpression(var: !100, expr: !DIExpression())
!100 = distinct !DIGlobalVariable(name: "g_t2_deq", scope: !2, file: !94, line: 38, type: !84, isLocal: false, isDefinition: true)
!101 = !DIGlobalVariableExpression(var: !102, expr: !DIExpression())
!102 = distinct !DIGlobalVariable(name: "global_trace", scope: !2, file: !50, line: 15, type: !103, isLocal: false, isDefinition: true)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "locked_trace_t", file: !104, line: 11, baseType: !105)
!104 = !DIFile(filename: "utils/include/test/locked_trace.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "6b9b066c8ea09bc73550cef772f1c7ca")
!105 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "locked_trace_s", file: !104, line: 8, size: 576, elements: !106)
!106 = !{!107, !122}
!107 = !DIDerivedType(tag: DW_TAG_member, name: "trace", scope: !105, file: !104, line: 9, baseType: !108, size: 256)
!108 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_t", file: !109, line: 23, baseType: !110)
!109 = !DIFile(filename: "utils/include/test/trace_manager.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "ef0cfa2f64930baab6e03245b4188b52")
!110 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_s", file: !109, line: 18, size: 256, elements: !111)
!111 = !{!112, !119, !120, !121}
!112 = !DIDerivedType(tag: DW_TAG_member, name: "units", scope: !110, file: !109, line: 19, baseType: !113, size: 64)
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!114 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_unit_t", file: !109, line: 16, baseType: !115)
!115 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_unit_s", file: !109, line: 13, size: 128, elements: !116)
!116 = !{!117, !118}
!117 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !115, file: !109, line: 14, baseType: !10, size: 64)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !115, file: !109, line: 15, baseType: !5, size: 64, offset: 64)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !110, file: !109, line: 20, baseType: !5, size: 64, offset: 64)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "capacity", scope: !110, file: !109, line: 21, baseType: !5, size: 64, offset: 128)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "initialized", scope: !110, file: !109, line: 22, baseType: !24, size: 8, offset: 192)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !105, file: !104, line: 10, baseType: !123, size: 320, offset: 256)
!123 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !21, line: 72, baseType: !124)
!124 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !21, line: 67, size: 320, elements: !125)
!125 = !{!126, !147, !152}
!126 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !124, file: !21, line: 69, baseType: !127, size: 320)
!127 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !128, line: 22, size: 320, elements: !129)
!128 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "584baedd80e6041b81caae7f496091c0")
!129 = !{!130, !131, !133, !134, !135, !136, !138, !139}
!130 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !127, file: !128, line: 24, baseType: !66, size: 32)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !127, file: !128, line: 25, baseType: !132, size: 32, offset: 32)
!132 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !127, file: !128, line: 26, baseType: !66, size: 32, offset: 64)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !127, file: !128, line: 28, baseType: !132, size: 32, offset: 96)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !127, file: !128, line: 32, baseType: !66, size: 32, offset: 128)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !127, file: !128, line: 34, baseType: !137, size: 16, offset: 160)
!137 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !127, file: !128, line: 35, baseType: !137, size: 16, offset: 176)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !127, file: !128, line: 36, baseType: !140, size: 128, offset: 192)
!140 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !141, line: 55, baseType: !142)
!141 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "04c81e86d34dad9c99ad006d32e47a0d")
!142 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !141, line: 51, size: 128, elements: !143)
!143 = !{!144, !146}
!144 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !142, file: !141, line: 53, baseType: !145, size: 64)
!145 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !142, size: 64)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !142, file: !141, line: 54, baseType: !145, size: 64, offset: 64)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !124, file: !21, line: 70, baseType: !148, size: 320)
!148 = !DICompositeType(tag: DW_TAG_array_type, baseType: !149, size: 320, elements: !150)
!149 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!150 = !{!151}
!151 = !DISubrange(count: 40)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !124, file: !21, line: 71, baseType: !153, size: 64)
!153 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!154 = !DIGlobalVariableExpression(var: !155, expr: !DIExpression())
!155 = distinct !DIGlobalVariable(name: "g_queue", scope: !2, file: !91, line: 25, type: !156, isLocal: false, isDefinition: true)
!156 = !DIDerivedType(tag: DW_TAG_typedef, name: "queue_t", file: !44, line: 41, baseType: !157)
!157 = !DIDerivedType(tag: DW_TAG_typedef, name: "vqueue_ub_t", file: !33, line: 47, baseType: !158)
!158 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vqueue_ub_s", file: !33, line: 41, size: 896, elements: !159)
!159 = !{!160, !162, !163, !164, !165}
!160 = !DIDerivedType(tag: DW_TAG_member, name: "enq_l", scope: !158, file: !33, line: 42, baseType: !161, size: 320)
!161 = !DIDerivedType(tag: DW_TAG_typedef, name: "queue_lock_t", file: !33, line: 31, baseType: !123)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "deq_l", scope: !158, file: !33, line: 43, baseType: !161, size: 320, offset: 320)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !158, file: !33, line: 44, baseType: !31, size: 64, offset: 640)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !158, file: !33, line: 45, baseType: !31, size: 64, offset: 704)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "sentinel", scope: !158, file: !33, line: 46, baseType: !32, size: 128, offset: 768)
!166 = !DIGlobalVariableExpression(var: !167, expr: !DIExpression())
!167 = distinct !DIGlobalVariable(name: "g_final_state", scope: !2, file: !91, line: 28, type: !168, isLocal: false, isDefinition: true)
!168 = !DICompositeType(tag: DW_TAG_array_type, baseType: !84, size: 320, elements: !169)
!169 = !{!170}
!170 = !DISubrange(count: 5)
!171 = !{i32 7, !"Dwarf Version", i32 5}
!172 = !{i32 2, !"Debug Info Version", i32 3}
!173 = !{i32 1, !"wchar_size", i32 4}
!174 = !{i32 7, !"PIC Level", i32 2}
!175 = !{i32 7, !"PIE Level", i32 2}
!176 = !{i32 7, !"uwtable", i32 1}
!177 = !{i32 7, !"frame-pointer", i32 2}
!178 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!179 = distinct !DISubprogram(name: "t1", scope: !94, file: !94, line: 21, type: !180, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!180 = !DISubroutineType(types: !181)
!181 = !{null, !5}
!182 = !{}
!183 = !DILocalVariable(name: "tid", arg: 1, scope: !179, file: !94, line: 21, type: !5)
!184 = !DILocation(line: 21, column: 12, scope: !179)
!185 = !DILocation(line: 23, column: 9, scope: !179)
!186 = !DILocation(line: 23, column: 5, scope: !179)
!187 = !DILocation(line: 24, column: 9, scope: !179)
!188 = !DILocation(line: 25, column: 9, scope: !179)
!189 = !DILocation(line: 25, column: 5, scope: !179)
!190 = !DILocalVariable(name: "node", scope: !179, file: !94, line: 26, type: !191)
!191 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !192, size: 64)
!192 = !DIDerivedType(tag: DW_TAG_typedef, name: "data_t", file: !44, line: 49, baseType: !193)
!193 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "data_s", file: !44, line: 46, size: 128, elements: !194)
!194 = !{!195, !196}
!195 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !193, file: !44, line: 47, baseType: !84, size: 64)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "lbl", scope: !193, file: !44, line: 48, baseType: !149, size: 8, offset: 64)
!197 = !DILocation(line: 26, column: 13, scope: !179)
!198 = !DILocation(line: 26, column: 24, scope: !179)
!199 = !DILocation(line: 26, column: 20, scope: !179)
!200 = !DILocation(line: 27, column: 5, scope: !201)
!201 = distinct !DILexicalBlock(scope: !202, file: !94, line: 27, column: 5)
!202 = distinct !DILexicalBlock(scope: !179, file: !94, line: 27, column: 5)
!203 = !DILocation(line: 27, column: 5, scope: !202)
!204 = !DILocation(line: 28, column: 5, scope: !205)
!205 = distinct !DILexicalBlock(scope: !206, file: !94, line: 28, column: 5)
!206 = distinct !DILexicalBlock(scope: !179, file: !94, line: 28, column: 5)
!207 = !DILocation(line: 28, column: 5, scope: !206)
!208 = !DILocation(line: 29, column: 16, scope: !179)
!209 = !DILocation(line: 29, column: 22, scope: !179)
!210 = !DILocation(line: 29, column: 14, scope: !179)
!211 = !DILocation(line: 30, column: 10, scope: !179)
!212 = !DILocation(line: 30, column: 5, scope: !179)
!213 = !DILocation(line: 31, column: 1, scope: !179)
!214 = distinct !DISubprogram(name: "enq", scope: !91, file: !91, line: 94, type: !215, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!215 = !DISubroutineType(types: !216)
!216 = !{null, !5, !84, !149}
!217 = !DILocalVariable(name: "tid", arg: 1, scope: !214, file: !91, line: 94, type: !5)
!218 = !DILocation(line: 94, column: 13, scope: !214)
!219 = !DILocalVariable(name: "k", arg: 2, scope: !214, file: !91, line: 94, type: !84)
!220 = !DILocation(line: 94, column: 28, scope: !214)
!221 = !DILocalVariable(name: "lbl", arg: 3, scope: !214, file: !91, line: 94, type: !149)
!222 = !DILocation(line: 94, column: 36, scope: !214)
!223 = !DILocation(line: 96, column: 15, scope: !214)
!224 = !DILocation(line: 96, column: 30, scope: !214)
!225 = !DILocation(line: 96, column: 33, scope: !214)
!226 = !DILocation(line: 96, column: 5, scope: !214)
!227 = !DILocation(line: 97, column: 1, scope: !214)
!228 = distinct !DISubprogram(name: "deq", scope: !91, file: !91, line: 100, type: !229, scopeLine: 101, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!229 = !DISubroutineType(types: !230)
!230 = !{!191, !5}
!231 = !DILocalVariable(name: "tid", arg: 1, scope: !228, file: !91, line: 100, type: !5)
!232 = !DILocation(line: 100, column: 13, scope: !228)
!233 = !DILocation(line: 102, column: 22, scope: !228)
!234 = !DILocation(line: 102, column: 12, scope: !228)
!235 = !DILocation(line: 102, column: 5, scope: !228)
!236 = distinct !DISubprogram(name: "t2", scope: !94, file: !94, line: 40, type: !180, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!237 = !DILocalVariable(name: "tid", arg: 1, scope: !236, file: !94, line: 40, type: !5)
!238 = !DILocation(line: 40, column: 12, scope: !236)
!239 = !DILocalVariable(name: "node", scope: !236, file: !94, line: 42, type: !191)
!240 = !DILocation(line: 42, column: 13, scope: !236)
!241 = !DILocation(line: 42, column: 24, scope: !236)
!242 = !DILocation(line: 42, column: 20, scope: !236)
!243 = !DILocation(line: 43, column: 9, scope: !244)
!244 = distinct !DILexicalBlock(scope: !236, file: !94, line: 43, column: 9)
!245 = !DILocation(line: 43, column: 9, scope: !236)
!246 = !DILocation(line: 44, column: 9, scope: !247)
!247 = distinct !DILexicalBlock(scope: !248, file: !94, line: 44, column: 9)
!248 = distinct !DILexicalBlock(scope: !249, file: !94, line: 44, column: 9)
!249 = distinct !DILexicalBlock(scope: !244, file: !94, line: 43, column: 15)
!250 = !DILocation(line: 44, column: 9, scope: !248)
!251 = !DILocation(line: 45, column: 23, scope: !249)
!252 = !DILocation(line: 46, column: 25, scope: !249)
!253 = !DILocation(line: 46, column: 31, scope: !249)
!254 = !DILocation(line: 46, column: 23, scope: !249)
!255 = !DILocation(line: 48, column: 13, scope: !256)
!256 = distinct !DILexicalBlock(scope: !249, file: !94, line: 48, column: 13)
!257 = !DILocation(line: 48, column: 19, scope: !256)
!258 = !DILocation(line: 48, column: 23, scope: !256)
!259 = !DILocation(line: 48, column: 13, scope: !249)
!260 = !DILocation(line: 49, column: 13, scope: !261)
!261 = distinct !DILexicalBlock(scope: !262, file: !94, line: 49, column: 13)
!262 = distinct !DILexicalBlock(scope: !263, file: !94, line: 49, column: 13)
!263 = distinct !DILexicalBlock(scope: !256, file: !94, line: 48, column: 29)
!264 = !DILocation(line: 49, column: 13, scope: !262)
!265 = !DILocation(line: 50, column: 9, scope: !263)
!266 = !DILocation(line: 51, column: 14, scope: !249)
!267 = !DILocation(line: 51, column: 9, scope: !249)
!268 = !DILocation(line: 52, column: 5, scope: !249)
!269 = !DILocation(line: 53, column: 1, scope: !236)
!270 = distinct !DISubprogram(name: "t3", scope: !94, file: !94, line: 60, type: !180, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!271 = !DILocalVariable(name: "tid", arg: 1, scope: !270, file: !94, line: 60, type: !5)
!272 = !DILocation(line: 60, column: 12, scope: !270)
!273 = !DILocation(line: 62, column: 9, scope: !270)
!274 = !DILocation(line: 62, column: 5, scope: !270)
!275 = !DILocation(line: 63, column: 17, scope: !270)
!276 = !DILocation(line: 63, column: 5, scope: !270)
!277 = !DILocation(line: 64, column: 1, scope: !270)
!278 = distinct !DISubprogram(name: "queue_clean", scope: !44, file: !44, line: 248, type: !180, scopeLine: 249, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!279 = !DILocalVariable(name: "tid", arg: 1, scope: !278, file: !44, line: 248, type: !5)
!280 = !DILocation(line: 248, column: 21, scope: !278)
!281 = !DILocation(line: 250, column: 18, scope: !278)
!282 = !DILocation(line: 250, column: 5, scope: !278)
!283 = !DILocation(line: 251, column: 1, scope: !278)
!284 = distinct !DISubprogram(name: "verify", scope: !94, file: !94, line: 67, type: !285, scopeLine: 68, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!285 = !DISubroutineType(types: !286)
!286 = !{null}
!287 = !DILocation(line: 75, column: 9, scope: !288)
!288 = distinct !DILexicalBlock(scope: !284, file: !94, line: 75, column: 9)
!289 = !DILocation(line: 75, column: 9, scope: !284)
!290 = !DILocation(line: 76, column: 9, scope: !291)
!291 = distinct !DILexicalBlock(scope: !292, file: !94, line: 76, column: 9)
!292 = distinct !DILexicalBlock(scope: !293, file: !94, line: 76, column: 9)
!293 = distinct !DILexicalBlock(scope: !288, file: !94, line: 75, column: 24)
!294 = !DILocation(line: 76, column: 9, scope: !292)
!295 = !DILocation(line: 77, column: 9, scope: !296)
!296 = distinct !DILexicalBlock(scope: !297, file: !94, line: 77, column: 9)
!297 = distinct !DILexicalBlock(scope: !293, file: !94, line: 77, column: 9)
!298 = !DILocation(line: 77, column: 9, scope: !297)
!299 = !DILocation(line: 78, column: 9, scope: !300)
!300 = distinct !DILexicalBlock(scope: !301, file: !94, line: 78, column: 9)
!301 = distinct !DILexicalBlock(scope: !293, file: !94, line: 78, column: 9)
!302 = !DILocation(line: 78, column: 9, scope: !301)
!303 = !DILocation(line: 79, column: 9, scope: !304)
!304 = distinct !DILexicalBlock(scope: !305, file: !94, line: 79, column: 9)
!305 = distinct !DILexicalBlock(scope: !293, file: !94, line: 79, column: 9)
!306 = !DILocation(line: 79, column: 9, scope: !305)
!307 = !DILocation(line: 80, column: 9, scope: !308)
!308 = distinct !DILexicalBlock(scope: !309, file: !94, line: 80, column: 9)
!309 = distinct !DILexicalBlock(scope: !293, file: !94, line: 80, column: 9)
!310 = !DILocation(line: 80, column: 9, scope: !309)
!311 = !DILocation(line: 81, column: 5, scope: !293)
!312 = !DILocation(line: 82, column: 9, scope: !313)
!313 = distinct !DILexicalBlock(scope: !314, file: !94, line: 82, column: 9)
!314 = distinct !DILexicalBlock(scope: !315, file: !94, line: 82, column: 9)
!315 = distinct !DILexicalBlock(scope: !288, file: !94, line: 81, column: 12)
!316 = !DILocation(line: 82, column: 9, scope: !314)
!317 = !DILocation(line: 83, column: 9, scope: !318)
!318 = distinct !DILexicalBlock(scope: !319, file: !94, line: 83, column: 9)
!319 = distinct !DILexicalBlock(scope: !315, file: !94, line: 83, column: 9)
!320 = !DILocation(line: 83, column: 9, scope: !319)
!321 = !DILocation(line: 84, column: 9, scope: !322)
!322 = distinct !DILexicalBlock(scope: !323, file: !94, line: 84, column: 9)
!323 = distinct !DILexicalBlock(scope: !315, file: !94, line: 84, column: 9)
!324 = !DILocation(line: 84, column: 9, scope: !323)
!325 = !DILocation(line: 85, column: 9, scope: !326)
!326 = distinct !DILexicalBlock(scope: !327, file: !94, line: 85, column: 9)
!327 = distinct !DILexicalBlock(scope: !315, file: !94, line: 85, column: 9)
!328 = !DILocation(line: 85, column: 9, scope: !327)
!329 = !DILocation(line: 89, column: 1, scope: !284)
!330 = distinct !DISubprogram(name: "main", scope: !91, file: !91, line: 50, type: !331, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!331 = !DISubroutineType(types: !332)
!332 = !{!66}
!333 = !DILocation(line: 52, column: 5, scope: !330)
!334 = !DILocation(line: 53, column: 5, scope: !330)
!335 = !DILocation(line: 55, column: 5, scope: !330)
!336 = !DILocation(line: 56, column: 5, scope: !330)
!337 = !DILocation(line: 57, column: 5, scope: !330)
!338 = !DILocation(line: 58, column: 5, scope: !339)
!339 = distinct !DILexicalBlock(scope: !340, file: !91, line: 58, column: 5)
!340 = distinct !DILexicalBlock(scope: !330, file: !91, line: 58, column: 5)
!341 = !DILocation(line: 58, column: 5, scope: !340)
!342 = !DILocation(line: 59, column: 5, scope: !330)
!343 = distinct !DISubprogram(name: "init", scope: !91, file: !91, line: 63, type: !285, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!344 = !DILocation(line: 65, column: 5, scope: !343)
!345 = !DILocation(line: 70, column: 5, scope: !343)
!346 = !DILocation(line: 84, column: 5, scope: !343)
!347 = !DILocation(line: 85, column: 1, scope: !343)
!348 = distinct !DISubprogram(name: "launch_threads", scope: !16, file: !16, line: 111, type: !349, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!349 = !DISubroutineType(types: !350)
!350 = !{null, !5, !27}
!351 = !DILocalVariable(name: "thread_count", arg: 1, scope: !348, file: !16, line: 111, type: !5)
!352 = !DILocation(line: 111, column: 24, scope: !348)
!353 = !DILocalVariable(name: "fun", arg: 2, scope: !348, file: !16, line: 111, type: !27)
!354 = !DILocation(line: 111, column: 51, scope: !348)
!355 = !DILocalVariable(name: "threads", scope: !348, file: !16, line: 113, type: !14)
!356 = !DILocation(line: 113, column: 17, scope: !348)
!357 = !DILocation(line: 113, column: 55, scope: !348)
!358 = !DILocation(line: 113, column: 53, scope: !348)
!359 = !DILocation(line: 113, column: 27, scope: !348)
!360 = !DILocation(line: 115, column: 20, scope: !348)
!361 = !DILocation(line: 115, column: 29, scope: !348)
!362 = !DILocation(line: 115, column: 43, scope: !348)
!363 = !DILocation(line: 115, column: 5, scope: !348)
!364 = !DILocation(line: 117, column: 19, scope: !348)
!365 = !DILocation(line: 117, column: 28, scope: !348)
!366 = !DILocation(line: 117, column: 5, scope: !348)
!367 = !DILocation(line: 119, column: 10, scope: !348)
!368 = !DILocation(line: 119, column: 5, scope: !348)
!369 = !DILocation(line: 120, column: 1, scope: !348)
!370 = distinct !DISubprogram(name: "run", scope: !91, file: !91, line: 126, type: !29, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!371 = !DILocalVariable(name: "args", arg: 1, scope: !370, file: !91, line: 126, type: !13)
!372 = !DILocation(line: 126, column: 11, scope: !370)
!373 = !DILocalVariable(name: "tid", scope: !370, file: !91, line: 128, type: !5)
!374 = !DILocation(line: 128, column: 13, scope: !370)
!375 = !DILocation(line: 128, column: 40, scope: !370)
!376 = !DILocation(line: 128, column: 28, scope: !370)
!377 = !DILocation(line: 129, column: 20, scope: !370)
!378 = !DILocation(line: 129, column: 5, scope: !370)
!379 = !DILocation(line: 130, column: 13, scope: !370)
!380 = !DILocation(line: 130, column: 5, scope: !370)
!381 = !DILocation(line: 132, column: 16, scope: !382)
!382 = distinct !DILexicalBlock(scope: !370, file: !91, line: 130, column: 18)
!383 = !DILocation(line: 132, column: 13, scope: !382)
!384 = !DILocation(line: 133, column: 13, scope: !382)
!385 = !DILocation(line: 135, column: 16, scope: !382)
!386 = !DILocation(line: 135, column: 13, scope: !382)
!387 = !DILocation(line: 136, column: 13, scope: !382)
!388 = !DILocation(line: 138, column: 16, scope: !382)
!389 = !DILocation(line: 138, column: 13, scope: !382)
!390 = !DILocation(line: 139, column: 13, scope: !382)
!391 = !DILocation(line: 141, column: 13, scope: !392)
!392 = distinct !DILexicalBlock(scope: !382, file: !91, line: 141, column: 13)
!393 = !DILocation(line: 141, column: 13, scope: !394)
!394 = distinct !DILexicalBlock(scope: !392, file: !91, line: 141, column: 13)
!395 = !DILocation(line: 142, column: 5, scope: !382)
!396 = !DILocation(line: 143, column: 22, scope: !370)
!397 = !DILocation(line: 143, column: 5, scope: !370)
!398 = !DILocation(line: 144, column: 5, scope: !370)
!399 = distinct !DISubprogram(name: "queue_print", scope: !44, file: !44, line: 235, type: !400, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!400 = !DISubroutineType(types: !401)
!401 = !{null, !402, !43}
!402 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !157, size: 64)
!403 = !DILocalVariable(name: "q", arg: 1, scope: !399, file: !44, line: 235, type: !402)
!404 = !DILocation(line: 235, column: 26, scope: !399)
!405 = !DILocalVariable(name: "print", arg: 2, scope: !399, file: !44, line: 235, type: !43)
!406 = !DILocation(line: 235, column: 41, scope: !399)
!407 = !DILocation(line: 237, column: 28, scope: !399)
!408 = !DILocation(line: 237, column: 56, scope: !399)
!409 = !DILocation(line: 237, column: 48, scope: !399)
!410 = !DILocation(line: 237, column: 5, scope: !399)
!411 = !DILocation(line: 238, column: 1, scope: !399)
!412 = distinct !DISubprogram(name: "get_final_state", scope: !91, file: !91, line: 117, type: !46, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!413 = !DILocalVariable(name: "data", arg: 1, scope: !412, file: !91, line: 117, type: !13)
!414 = !DILocation(line: 117, column: 23, scope: !412)
!415 = !DILocation(line: 119, column: 5, scope: !416)
!416 = distinct !DILexicalBlock(scope: !417, file: !91, line: 119, column: 5)
!417 = distinct !DILexicalBlock(scope: !412, file: !91, line: 119, column: 5)
!418 = !DILocation(line: 119, column: 5, scope: !417)
!419 = !DILocalVariable(name: "node", scope: !412, file: !91, line: 120, type: !191)
!420 = !DILocation(line: 120, column: 13, scope: !412)
!421 = !DILocation(line: 120, column: 20, scope: !412)
!422 = !DILocation(line: 121, column: 5, scope: !423)
!423 = distinct !DILexicalBlock(scope: !424, file: !91, line: 121, column: 5)
!424 = distinct !DILexicalBlock(scope: !412, file: !91, line: 121, column: 5)
!425 = !DILocation(line: 121, column: 5, scope: !424)
!426 = !DILocation(line: 122, column: 30, scope: !412)
!427 = !DILocation(line: 122, column: 36, scope: !412)
!428 = !DILocation(line: 122, column: 24, scope: !412)
!429 = !DILocation(line: 122, column: 5, scope: !412)
!430 = !DILocation(line: 122, column: 28, scope: !412)
!431 = !DILocation(line: 123, column: 1, scope: !412)
!432 = distinct !DISubprogram(name: "destroy", scope: !91, file: !91, line: 88, type: !285, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!433 = !DILocation(line: 90, column: 5, scope: !432)
!434 = !DILocation(line: 91, column: 1, scope: !432)
!435 = distinct !DISubprogram(name: "vmem_no_leak", scope: !79, file: !79, line: 133, type: !436, scopeLine: 134, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!436 = !DISubroutineType(types: !437)
!437 = !{!24}
!438 = !DILocalVariable(name: "alloc_count", scope: !435, file: !79, line: 135, type: !84)
!439 = !DILocation(line: 135, column: 15, scope: !435)
!440 = !DILocation(line: 135, column: 29, scope: !435)
!441 = !DILocalVariable(name: "free_count", scope: !435, file: !79, line: 136, type: !84)
!442 = !DILocation(line: 136, column: 15, scope: !435)
!443 = !DILocation(line: 136, column: 29, scope: !435)
!444 = !DILocation(line: 137, column: 13, scope: !435)
!445 = !DILocation(line: 137, column: 28, scope: !435)
!446 = !DILocation(line: 137, column: 25, scope: !435)
!447 = !DILocation(line: 137, column: 5, scope: !435)
!448 = distinct !DISubprogram(name: "queue_init", scope: !44, file: !44, line: 110, type: !449, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!449 = !DISubroutineType(types: !450)
!450 = !{null, !451}
!451 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !156, size: 64)
!452 = !DILocalVariable(name: "q", arg: 1, scope: !448, file: !44, line: 110, type: !451)
!453 = !DILocation(line: 110, column: 21, scope: !448)
!454 = !DILocation(line: 112, column: 5, scope: !448)
!455 = !DILocation(line: 113, column: 20, scope: !448)
!456 = !DILocation(line: 113, column: 5, scope: !448)
!457 = !DILocation(line: 120, column: 1, scope: !448)
!458 = distinct !DISubprogram(name: "queue_register", scope: !44, file: !44, line: 123, type: !459, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!459 = !DISubroutineType(types: !460)
!460 = !{null, !5, !451}
!461 = !DILocalVariable(name: "tid", arg: 1, scope: !458, file: !44, line: 123, type: !5)
!462 = !DILocation(line: 123, column: 24, scope: !458)
!463 = !DILocalVariable(name: "q", arg: 2, scope: !458, file: !44, line: 123, type: !451)
!464 = !DILocation(line: 123, column: 38, scope: !458)
!465 = !DILocation(line: 125, column: 14, scope: !458)
!466 = !DILocation(line: 125, column: 5, scope: !458)
!467 = !DILocation(line: 126, column: 5, scope: !458)
!468 = !DILocation(line: 126, column: 5, scope: !469)
!469 = distinct !DILexicalBlock(scope: !458, file: !44, line: 126, column: 5)
!470 = !DILocation(line: 126, column: 5, scope: !471)
!471 = distinct !DILexicalBlock(scope: !469, file: !44, line: 126, column: 5)
!472 = !DILocation(line: 126, column: 5, scope: !473)
!473 = distinct !DILexicalBlock(scope: !471, file: !44, line: 126, column: 5)
!474 = !DILocation(line: 127, column: 1, scope: !458)
!475 = distinct !DISubprogram(name: "queue_deregister", scope: !44, file: !44, line: 139, type: !459, scopeLine: 140, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!476 = !DILocalVariable(name: "tid", arg: 1, scope: !475, file: !44, line: 139, type: !5)
!477 = !DILocation(line: 139, column: 26, scope: !475)
!478 = !DILocalVariable(name: "q", arg: 2, scope: !475, file: !44, line: 139, type: !451)
!479 = !DILocation(line: 139, column: 40, scope: !475)
!480 = !DILocation(line: 144, column: 16, scope: !475)
!481 = !DILocation(line: 144, column: 5, scope: !475)
!482 = !DILocation(line: 145, column: 5, scope: !475)
!483 = !DILocation(line: 145, column: 5, scope: !484)
!484 = distinct !DILexicalBlock(scope: !475, file: !44, line: 145, column: 5)
!485 = !DILocation(line: 145, column: 5, scope: !486)
!486 = distinct !DILexicalBlock(scope: !484, file: !44, line: 145, column: 5)
!487 = !DILocation(line: 145, column: 5, scope: !488)
!488 = distinct !DILexicalBlock(scope: !486, file: !44, line: 145, column: 5)
!489 = !DILocation(line: 146, column: 1, scope: !475)
!490 = distinct !DISubprogram(name: "queue_destroy", scope: !44, file: !44, line: 149, type: !449, scopeLine: 150, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!491 = !DILocalVariable(name: "q", arg: 1, scope: !490, file: !44, line: 149, type: !451)
!492 = !DILocation(line: 149, column: 24, scope: !490)
!493 = !DILocalVariable(name: "data", scope: !490, file: !44, line: 151, type: !13)
!494 = !DILocation(line: 151, column: 11, scope: !490)
!495 = !DILocation(line: 156, column: 5, scope: !490)
!496 = !DILocation(line: 156, column: 33, scope: !490)
!497 = !DILocation(line: 156, column: 19, scope: !490)
!498 = !DILocation(line: 156, column: 17, scope: !490)
!499 = !DILocation(line: 156, column: 59, scope: !490)
!500 = !DILocation(line: 157, column: 14, scope: !501)
!501 = distinct !DILexicalBlock(scope: !490, file: !44, line: 156, column: 65)
!502 = !DILocation(line: 157, column: 9, scope: !501)
!503 = distinct !{!503, !495, !504, !505}
!504 = !DILocation(line: 158, column: 5, scope: !490)
!505 = !{!"llvm.loop.mustprogress"}
!506 = !DILocation(line: 159, column: 23, scope: !490)
!507 = !DILocation(line: 159, column: 5, scope: !490)
!508 = !DILocation(line: 165, column: 5, scope: !490)
!509 = !DILocation(line: 166, column: 5, scope: !510)
!510 = distinct !DILexicalBlock(scope: !511, file: !44, line: 166, column: 5)
!511 = distinct !DILexicalBlock(scope: !490, file: !44, line: 166, column: 5)
!512 = !DILocation(line: 166, column: 5, scope: !511)
!513 = !DILocation(line: 167, column: 1, scope: !490)
!514 = distinct !DISubprogram(name: "queue_enq", scope: !44, file: !44, line: 170, type: !515, scopeLine: 171, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!515 = !DISubroutineType(types: !516)
!516 = !{null, !5, !451, !84, !149}
!517 = !DILocalVariable(name: "tid", arg: 1, scope: !514, file: !44, line: 170, type: !5)
!518 = !DILocation(line: 170, column: 19, scope: !514)
!519 = !DILocalVariable(name: "q", arg: 2, scope: !514, file: !44, line: 170, type: !451)
!520 = !DILocation(line: 170, column: 33, scope: !514)
!521 = !DILocalVariable(name: "key", arg: 3, scope: !514, file: !44, line: 170, type: !84)
!522 = !DILocation(line: 170, column: 46, scope: !514)
!523 = !DILocalVariable(name: "lbl", arg: 4, scope: !514, file: !44, line: 170, type: !149)
!524 = !DILocation(line: 170, column: 56, scope: !514)
!525 = !DILocalVariable(name: "data", scope: !514, file: !44, line: 172, type: !191)
!526 = !DILocation(line: 172, column: 13, scope: !514)
!527 = !DILocation(line: 172, column: 20, scope: !514)
!528 = !DILocation(line: 173, column: 9, scope: !529)
!529 = distinct !DILexicalBlock(scope: !514, file: !44, line: 173, column: 9)
!530 = !DILocation(line: 173, column: 9, scope: !514)
!531 = !DILocation(line: 174, column: 31, scope: !532)
!532 = distinct !DILexicalBlock(scope: !529, file: !44, line: 173, column: 15)
!533 = !DILocation(line: 174, column: 9, scope: !532)
!534 = !DILocation(line: 174, column: 15, scope: !532)
!535 = !DILocation(line: 174, column: 29, scope: !532)
!536 = !DILocation(line: 175, column: 31, scope: !532)
!537 = !DILocation(line: 175, column: 9, scope: !532)
!538 = !DILocation(line: 175, column: 15, scope: !532)
!539 = !DILocation(line: 175, column: 29, scope: !532)
!540 = !DILocalVariable(name: "qnode", scope: !532, file: !44, line: 176, type: !541)
!541 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !542, size: 64)
!542 = !DIDerivedType(tag: DW_TAG_typedef, name: "queue_node_t", file: !44, line: 42, baseType: !32)
!543 = !DILocation(line: 176, column: 23, scope: !532)
!544 = !DILocation(line: 190, column: 17, scope: !532)
!545 = !DILocation(line: 190, column: 15, scope: !532)
!546 = !DILocation(line: 192, column: 20, scope: !532)
!547 = !DILocation(line: 192, column: 9, scope: !532)
!548 = !DILocation(line: 193, column: 23, scope: !532)
!549 = !DILocation(line: 193, column: 26, scope: !532)
!550 = !DILocation(line: 193, column: 33, scope: !532)
!551 = !DILocation(line: 193, column: 9, scope: !532)
!552 = !DILocation(line: 194, column: 19, scope: !532)
!553 = !DILocation(line: 194, column: 9, scope: !532)
!554 = !DILocation(line: 195, column: 5, scope: !532)
!555 = !DILocation(line: 196, column: 9, scope: !556)
!556 = distinct !DILexicalBlock(scope: !557, file: !44, line: 196, column: 9)
!557 = distinct !DILexicalBlock(scope: !558, file: !44, line: 196, column: 9)
!558 = distinct !DILexicalBlock(scope: !529, file: !44, line: 195, column: 12)
!559 = !DILocation(line: 198, column: 1, scope: !514)
!560 = distinct !DISubprogram(name: "queue_deq", scope: !44, file: !44, line: 219, type: !561, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!561 = !DISubroutineType(types: !562)
!562 = !{!13, !5, !451}
!563 = !DILocalVariable(name: "tid", arg: 1, scope: !560, file: !44, line: 219, type: !5)
!564 = !DILocation(line: 219, column: 19, scope: !560)
!565 = !DILocalVariable(name: "q", arg: 2, scope: !560, file: !44, line: 219, type: !451)
!566 = !DILocation(line: 219, column: 33, scope: !560)
!567 = !DILocation(line: 221, column: 16, scope: !560)
!568 = !DILocation(line: 221, column: 5, scope: !560)
!569 = !DILocalVariable(name: "data", scope: !560, file: !44, line: 222, type: !13)
!570 = !DILocation(line: 222, column: 11, scope: !560)
!571 = !DILocation(line: 222, column: 32, scope: !560)
!572 = !DILocation(line: 222, column: 58, scope: !560)
!573 = !DILocation(line: 222, column: 50, scope: !560)
!574 = !DILocation(line: 222, column: 18, scope: !560)
!575 = !DILocation(line: 223, column: 15, scope: !560)
!576 = !DILocation(line: 223, column: 5, scope: !560)
!577 = !DILocation(line: 224, column: 12, scope: !560)
!578 = !DILocation(line: 224, column: 5, scope: !560)
!579 = distinct !DISubprogram(name: "empty", scope: !91, file: !91, line: 106, type: !580, scopeLine: 107, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!580 = !DISubroutineType(types: !581)
!581 = !{!24, !5}
!582 = !DILocalVariable(name: "tid", arg: 1, scope: !579, file: !91, line: 106, type: !5)
!583 = !DILocation(line: 106, column: 15, scope: !579)
!584 = !DILocation(line: 108, column: 24, scope: !579)
!585 = !DILocation(line: 108, column: 12, scope: !579)
!586 = !DILocation(line: 108, column: 5, scope: !579)
!587 = distinct !DISubprogram(name: "queue_empty", scope: !44, file: !44, line: 210, type: !588, scopeLine: 211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!588 = !DISubroutineType(types: !589)
!589 = !{!24, !5, !451}
!590 = !DILocalVariable(name: "tid", arg: 1, scope: !587, file: !44, line: 210, type: !5)
!591 = !DILocation(line: 210, column: 21, scope: !587)
!592 = !DILocalVariable(name: "q", arg: 2, scope: !587, file: !44, line: 210, type: !451)
!593 = !DILocation(line: 210, column: 35, scope: !587)
!594 = !DILocation(line: 212, column: 16, scope: !587)
!595 = !DILocation(line: 212, column: 5, scope: !587)
!596 = !DILocalVariable(name: "empty", scope: !587, file: !44, line: 213, type: !24)
!597 = !DILocation(line: 213, column: 13, scope: !587)
!598 = !DILocation(line: 213, column: 37, scope: !587)
!599 = !DILocation(line: 213, column: 21, scope: !587)
!600 = !DILocation(line: 214, column: 15, scope: !587)
!601 = !DILocation(line: 214, column: 5, scope: !587)
!602 = !DILocation(line: 215, column: 12, scope: !587)
!603 = !DILocation(line: 215, column: 5, scope: !587)
!604 = distinct !DISubprogram(name: "ismr_recycle", scope: !50, file: !50, line: 114, type: !180, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!605 = !DILocalVariable(name: "tid", arg: 1, scope: !604, file: !50, line: 114, type: !5)
!606 = !DILocation(line: 114, column: 22, scope: !604)
!607 = !DILocation(line: 116, column: 5, scope: !604)
!608 = !DILocation(line: 116, column: 5, scope: !609)
!609 = distinct !DILexicalBlock(scope: !604, file: !50, line: 116, column: 5)
!610 = !DILocation(line: 116, column: 5, scope: !611)
!611 = distinct !DILexicalBlock(scope: !609, file: !50, line: 116, column: 5)
!612 = !DILocation(line: 116, column: 5, scope: !613)
!613 = distinct !DILexicalBlock(scope: !611, file: !50, line: 116, column: 5)
!614 = !DILocation(line: 117, column: 1, scope: !604)
!615 = distinct !DISubprogram(name: "create_threads", scope: !16, file: !16, line: 83, type: !616, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!616 = !DISubroutineType(types: !617)
!617 = !{null, !14, !5, !27, !24}
!618 = !DILocalVariable(name: "threads", arg: 1, scope: !615, file: !16, line: 83, type: !14)
!619 = !DILocation(line: 83, column: 28, scope: !615)
!620 = !DILocalVariable(name: "num_threads", arg: 2, scope: !615, file: !16, line: 83, type: !5)
!621 = !DILocation(line: 83, column: 45, scope: !615)
!622 = !DILocalVariable(name: "fun", arg: 3, scope: !615, file: !16, line: 83, type: !27)
!623 = !DILocation(line: 83, column: 71, scope: !615)
!624 = !DILocalVariable(name: "bind", arg: 4, scope: !615, file: !16, line: 84, type: !24)
!625 = !DILocation(line: 84, column: 24, scope: !615)
!626 = !DILocalVariable(name: "i", scope: !615, file: !16, line: 86, type: !5)
!627 = !DILocation(line: 86, column: 13, scope: !615)
!628 = !DILocation(line: 87, column: 12, scope: !629)
!629 = distinct !DILexicalBlock(scope: !615, file: !16, line: 87, column: 5)
!630 = !DILocation(line: 87, column: 10, scope: !629)
!631 = !DILocation(line: 87, column: 17, scope: !632)
!632 = distinct !DILexicalBlock(scope: !629, file: !16, line: 87, column: 5)
!633 = !DILocation(line: 87, column: 21, scope: !632)
!634 = !DILocation(line: 87, column: 19, scope: !632)
!635 = !DILocation(line: 87, column: 5, scope: !629)
!636 = !DILocation(line: 88, column: 40, scope: !637)
!637 = distinct !DILexicalBlock(scope: !632, file: !16, line: 87, column: 39)
!638 = !DILocation(line: 88, column: 9, scope: !637)
!639 = !DILocation(line: 88, column: 17, scope: !637)
!640 = !DILocation(line: 88, column: 20, scope: !637)
!641 = !DILocation(line: 88, column: 38, scope: !637)
!642 = !DILocation(line: 89, column: 40, scope: !637)
!643 = !DILocation(line: 89, column: 9, scope: !637)
!644 = !DILocation(line: 89, column: 17, scope: !637)
!645 = !DILocation(line: 89, column: 20, scope: !637)
!646 = !DILocation(line: 89, column: 38, scope: !637)
!647 = !DILocation(line: 90, column: 40, scope: !637)
!648 = !DILocation(line: 90, column: 9, scope: !637)
!649 = !DILocation(line: 90, column: 17, scope: !637)
!650 = !DILocation(line: 90, column: 20, scope: !637)
!651 = !DILocation(line: 90, column: 38, scope: !637)
!652 = !DILocation(line: 91, column: 25, scope: !637)
!653 = !DILocation(line: 91, column: 33, scope: !637)
!654 = !DILocation(line: 91, column: 36, scope: !637)
!655 = !DILocation(line: 91, column: 55, scope: !637)
!656 = !DILocation(line: 91, column: 63, scope: !637)
!657 = !DILocation(line: 91, column: 54, scope: !637)
!658 = !DILocation(line: 91, column: 9, scope: !637)
!659 = !DILocation(line: 92, column: 5, scope: !637)
!660 = !DILocation(line: 87, column: 35, scope: !632)
!661 = !DILocation(line: 87, column: 5, scope: !632)
!662 = distinct !{!662, !635, !663, !505}
!663 = !DILocation(line: 92, column: 5, scope: !629)
!664 = !DILocation(line: 94, column: 1, scope: !615)
!665 = distinct !DISubprogram(name: "await_threads", scope: !16, file: !16, line: 97, type: !666, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!666 = !DISubroutineType(types: !667)
!667 = !{null, !14, !5}
!668 = !DILocalVariable(name: "threads", arg: 1, scope: !665, file: !16, line: 97, type: !14)
!669 = !DILocation(line: 97, column: 27, scope: !665)
!670 = !DILocalVariable(name: "num_threads", arg: 2, scope: !665, file: !16, line: 97, type: !5)
!671 = !DILocation(line: 97, column: 44, scope: !665)
!672 = !DILocalVariable(name: "i", scope: !665, file: !16, line: 99, type: !5)
!673 = !DILocation(line: 99, column: 13, scope: !665)
!674 = !DILocation(line: 100, column: 12, scope: !675)
!675 = distinct !DILexicalBlock(scope: !665, file: !16, line: 100, column: 5)
!676 = !DILocation(line: 100, column: 10, scope: !675)
!677 = !DILocation(line: 100, column: 17, scope: !678)
!678 = distinct !DILexicalBlock(scope: !675, file: !16, line: 100, column: 5)
!679 = !DILocation(line: 100, column: 21, scope: !678)
!680 = !DILocation(line: 100, column: 19, scope: !678)
!681 = !DILocation(line: 100, column: 5, scope: !675)
!682 = !DILocation(line: 101, column: 22, scope: !683)
!683 = distinct !DILexicalBlock(scope: !678, file: !16, line: 100, column: 39)
!684 = !DILocation(line: 101, column: 30, scope: !683)
!685 = !DILocation(line: 101, column: 33, scope: !683)
!686 = !DILocation(line: 101, column: 9, scope: !683)
!687 = !DILocation(line: 102, column: 5, scope: !683)
!688 = !DILocation(line: 100, column: 35, scope: !678)
!689 = !DILocation(line: 100, column: 5, scope: !678)
!690 = distinct !{!690, !681, !691, !505}
!691 = !DILocation(line: 102, column: 5, scope: !675)
!692 = !DILocation(line: 103, column: 1, scope: !665)
!693 = distinct !DISubprogram(name: "common_run", scope: !16, file: !16, line: 43, type: !29, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!694 = !DILocalVariable(name: "args", arg: 1, scope: !693, file: !16, line: 43, type: !13)
!695 = !DILocation(line: 43, column: 18, scope: !693)
!696 = !DILocalVariable(name: "run_info", scope: !693, file: !16, line: 45, type: !14)
!697 = !DILocation(line: 45, column: 17, scope: !693)
!698 = !DILocation(line: 45, column: 42, scope: !693)
!699 = !DILocation(line: 45, column: 28, scope: !693)
!700 = !DILocation(line: 47, column: 9, scope: !701)
!701 = distinct !DILexicalBlock(scope: !693, file: !16, line: 47, column: 9)
!702 = !DILocation(line: 47, column: 19, scope: !701)
!703 = !DILocation(line: 47, column: 9, scope: !693)
!704 = !DILocation(line: 48, column: 26, scope: !701)
!705 = !DILocation(line: 48, column: 36, scope: !701)
!706 = !DILocation(line: 48, column: 9, scope: !701)
!707 = !DILocation(line: 52, column: 12, scope: !693)
!708 = !DILocation(line: 52, column: 22, scope: !693)
!709 = !DILocation(line: 52, column: 38, scope: !693)
!710 = !DILocation(line: 52, column: 48, scope: !693)
!711 = !DILocation(line: 52, column: 30, scope: !693)
!712 = !DILocation(line: 52, column: 5, scope: !693)
!713 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !16, file: !16, line: 61, type: !180, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!714 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !713, file: !16, line: 61, type: !5)
!715 = !DILocation(line: 61, column: 26, scope: !713)
!716 = !DILocation(line: 78, column: 5, scope: !713)
!717 = !DILocation(line: 78, column: 5, scope: !718)
!718 = distinct !DILexicalBlock(scope: !713, file: !16, line: 78, column: 5)
!719 = !DILocation(line: 78, column: 5, scope: !720)
!720 = distinct !DILexicalBlock(scope: !718, file: !16, line: 78, column: 5)
!721 = !DILocation(line: 78, column: 5, scope: !722)
!722 = distinct !DILexicalBlock(scope: !720, file: !16, line: 78, column: 5)
!723 = !DILocation(line: 80, column: 1, scope: !713)
!724 = distinct !DISubprogram(name: "_vqueue_ub_visit_nodes", scope: !33, file: !33, line: 233, type: !725, scopeLine: 235, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!725 = !DISubroutineType(types: !726)
!726 = !{null, !402, !727, !13}
!727 = !DIDerivedType(tag: DW_TAG_typedef, name: "vqueue_ub_node_handler_t", file: !728, line: 9, baseType: !729)
!728 = !DIFile(filename: "datastruct/queue/unbounded/include/vsync/queue/internal/ub/vqueue_ub_common.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "bc5763170bb9d2e4aa9aa1f04b243580")
!729 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !730, size: 64)
!730 = !DISubroutineType(types: !731)
!731 = !{null, !732, !13}
!732 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!733 = !DILocalVariable(name: "q", arg: 1, scope: !724, file: !33, line: 233, type: !402)
!734 = !DILocation(line: 233, column: 37, scope: !724)
!735 = !DILocalVariable(name: "visitor", arg: 2, scope: !724, file: !33, line: 233, type: !727)
!736 = !DILocation(line: 233, column: 65, scope: !724)
!737 = !DILocalVariable(name: "arg", arg: 3, scope: !724, file: !33, line: 234, type: !13)
!738 = !DILocation(line: 234, column: 30, scope: !724)
!739 = !DILocalVariable(name: "curr", scope: !724, file: !33, line: 236, type: !31)
!740 = !DILocation(line: 236, column: 23, scope: !724)
!741 = !DILocalVariable(name: "next", scope: !724, file: !33, line: 237, type: !31)
!742 = !DILocation(line: 237, column: 23, scope: !724)
!743 = !DILocation(line: 239, column: 12, scope: !724)
!744 = !DILocation(line: 239, column: 15, scope: !724)
!745 = !DILocation(line: 239, column: 10, scope: !724)
!746 = !DILocation(line: 241, column: 53, scope: !724)
!747 = !DILocation(line: 241, column: 59, scope: !724)
!748 = !DILocation(line: 241, column: 32, scope: !724)
!749 = !DILocation(line: 241, column: 12, scope: !724)
!750 = !DILocation(line: 241, column: 10, scope: !724)
!751 = !DILocation(line: 243, column: 5, scope: !724)
!752 = !DILocation(line: 243, column: 12, scope: !724)
!753 = !DILocation(line: 244, column: 57, scope: !754)
!754 = distinct !DILexicalBlock(scope: !724, file: !33, line: 243, column: 18)
!755 = !DILocation(line: 244, column: 63, scope: !754)
!756 = !DILocation(line: 244, column: 36, scope: !754)
!757 = !DILocation(line: 244, column: 16, scope: !754)
!758 = !DILocation(line: 244, column: 14, scope: !754)
!759 = !DILocation(line: 245, column: 9, scope: !754)
!760 = !DILocation(line: 245, column: 17, scope: !754)
!761 = !DILocation(line: 245, column: 23, scope: !754)
!762 = !DILocation(line: 246, column: 16, scope: !754)
!763 = !DILocation(line: 246, column: 14, scope: !754)
!764 = distinct !{!764, !751, !765, !505}
!765 = !DILocation(line: 247, column: 5, scope: !724)
!766 = !DILocation(line: 248, column: 1, scope: !724)
!767 = distinct !DISubprogram(name: "_redirect_print", scope: !44, file: !44, line: 229, type: !768, scopeLine: 230, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!768 = !DISubroutineType(types: !769)
!769 = !{null, !31, !13}
!770 = !DILocalVariable(name: "qnode", arg: 1, scope: !767, file: !44, line: 229, type: !31)
!771 = !DILocation(line: 229, column: 35, scope: !767)
!772 = !DILocalVariable(name: "arg", arg: 2, scope: !767, file: !44, line: 229, type: !13)
!773 = !DILocation(line: 229, column: 48, scope: !767)
!774 = !DILocalVariable(name: "print", scope: !767, file: !44, line: 231, type: !43)
!775 = !DILocation(line: 231, column: 17, scope: !767)
!776 = !DILocation(line: 231, column: 38, scope: !767)
!777 = !DILocation(line: 231, column: 25, scope: !767)
!778 = !DILocation(line: 232, column: 5, scope: !767)
!779 = !DILocation(line: 232, column: 11, scope: !767)
!780 = !DILocation(line: 232, column: 18, scope: !767)
!781 = !DILocation(line: 233, column: 1, scope: !767)
!782 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !783, file: !783, line: 197, type: !784, scopeLine: 198, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!783 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!784 = !DISubroutineType(types: !785)
!785 = !{!13, !786}
!786 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !787, size: 64)
!787 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !38)
!788 = !DILocalVariable(name: "a", arg: 1, scope: !782, file: !783, line: 197, type: !786)
!789 = !DILocation(line: 197, column: 41, scope: !782)
!790 = !DILocalVariable(name: "val", scope: !782, file: !783, line: 199, type: !13)
!791 = !DILocation(line: 199, column: 11, scope: !782)
!792 = !DILocation(line: 202, column: 32, scope: !782)
!793 = !DILocation(line: 202, column: 35, scope: !782)
!794 = !DILocation(line: 200, column: 5, scope: !782)
!795 = !{i64 852631}
!796 = !DILocation(line: 204, column: 12, scope: !782)
!797 = !DILocation(line: 204, column: 5, scope: !782)
!798 = distinct !DISubprogram(name: "vmem_get_alloc_count", scope: !79, file: !79, line: 90, type: !799, scopeLine: 91, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!799 = !DISubroutineType(types: !800)
!800 = !{!84}
!801 = !DILocalVariable(name: "alloc_count", scope: !798, file: !79, line: 93, type: !84)
!802 = !DILocation(line: 93, column: 15, scope: !798)
!803 = !DILocation(line: 93, column: 29, scope: !798)
!804 = !DILocation(line: 94, column: 5, scope: !798)
!805 = !DILocation(line: 94, column: 5, scope: !806)
!806 = distinct !DILexicalBlock(scope: !798, file: !79, line: 94, column: 5)
!807 = !DILocation(line: 94, column: 5, scope: !808)
!808 = distinct !DILexicalBlock(scope: !806, file: !79, line: 94, column: 5)
!809 = !DILocation(line: 94, column: 5, scope: !810)
!810 = distinct !DILexicalBlock(scope: !808, file: !79, line: 94, column: 5)
!811 = !DILocation(line: 95, column: 12, scope: !798)
!812 = !DILocation(line: 95, column: 5, scope: !798)
!813 = distinct !DISubprogram(name: "vmem_get_free_count", scope: !79, file: !79, line: 104, type: !799, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!814 = !DILocalVariable(name: "free_count", scope: !813, file: !79, line: 107, type: !84)
!815 = !DILocation(line: 107, column: 15, scope: !813)
!816 = !DILocation(line: 107, column: 28, scope: !813)
!817 = !DILocation(line: 108, column: 5, scope: !813)
!818 = !DILocation(line: 108, column: 5, scope: !819)
!819 = distinct !DILexicalBlock(scope: !813, file: !79, line: 108, column: 5)
!820 = !DILocation(line: 108, column: 5, scope: !821)
!821 = distinct !DILexicalBlock(scope: !819, file: !79, line: 108, column: 5)
!822 = !DILocation(line: 108, column: 5, scope: !823)
!823 = distinct !DILexicalBlock(scope: !821, file: !79, line: 108, column: 5)
!824 = !DILocation(line: 109, column: 12, scope: !813)
!825 = !DILocation(line: 109, column: 5, scope: !813)
!826 = distinct !DISubprogram(name: "vatomic64_read_rlx", scope: !783, file: !783, line: 149, type: !827, scopeLine: 150, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!827 = !DISubroutineType(types: !828)
!828 = !{!84, !829}
!829 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !830, size: 64)
!830 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !80)
!831 = !DILocalVariable(name: "a", arg: 1, scope: !826, file: !783, line: 149, type: !829)
!832 = !DILocation(line: 149, column: 39, scope: !826)
!833 = !DILocalVariable(name: "val", scope: !826, file: !783, line: 151, type: !84)
!834 = !DILocation(line: 151, column: 15, scope: !826)
!835 = !DILocation(line: 154, column: 32, scope: !826)
!836 = !DILocation(line: 154, column: 35, scope: !826)
!837 = !DILocation(line: 152, column: 5, scope: !826)
!838 = !{i64 851148}
!839 = !DILocation(line: 156, column: 12, scope: !826)
!840 = !DILocation(line: 156, column: 5, scope: !826)
!841 = distinct !DISubprogram(name: "ismr_init", scope: !50, file: !50, line: 35, type: !285, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!842 = !DILocation(line: 37, column: 5, scope: !841)
!843 = !DILocation(line: 38, column: 1, scope: !841)
!844 = distinct !DISubprogram(name: "vqueue_ub_init", scope: !33, file: !33, line: 76, type: !845, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!845 = !DISubroutineType(types: !846)
!846 = !{null, !402}
!847 = !DILocalVariable(name: "q", arg: 1, scope: !844, file: !33, line: 76, type: !402)
!848 = !DILocation(line: 76, column: 29, scope: !844)
!849 = !DILocation(line: 78, column: 16, scope: !844)
!850 = !DILocation(line: 78, column: 19, scope: !844)
!851 = !DILocation(line: 78, column: 5, scope: !844)
!852 = !DILocation(line: 78, column: 8, scope: !844)
!853 = !DILocation(line: 78, column: 13, scope: !844)
!854 = !DILocation(line: 79, column: 16, scope: !844)
!855 = !DILocation(line: 79, column: 19, scope: !844)
!856 = !DILocation(line: 79, column: 5, scope: !844)
!857 = !DILocation(line: 79, column: 8, scope: !844)
!858 = !DILocation(line: 79, column: 13, scope: !844)
!859 = !DILocation(line: 81, column: 27, scope: !844)
!860 = !DILocation(line: 81, column: 30, scope: !844)
!861 = !DILocation(line: 81, column: 5, scope: !844)
!862 = !DILocation(line: 83, column: 22, scope: !844)
!863 = !DILocation(line: 83, column: 25, scope: !844)
!864 = !DILocation(line: 83, column: 5, scope: !844)
!865 = !DILocation(line: 84, column: 22, scope: !844)
!866 = !DILocation(line: 84, column: 25, scope: !844)
!867 = !DILocation(line: 84, column: 5, scope: !844)
!868 = !DILocation(line: 85, column: 1, scope: !844)
!869 = distinct !DISubprogram(name: "locked_trace_init", scope: !104, file: !104, line: 14, type: !870, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!870 = !DISubroutineType(types: !871)
!871 = !{null, !872, !5}
!872 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!873 = !DILocalVariable(name: "trace", arg: 1, scope: !869, file: !104, line: 14, type: !872)
!874 = !DILocation(line: 14, column: 35, scope: !869)
!875 = !DILocalVariable(name: "capacity", arg: 2, scope: !869, file: !104, line: 14, type: !5)
!876 = !DILocation(line: 14, column: 50, scope: !869)
!877 = !DILocation(line: 16, column: 5, scope: !878)
!878 = distinct !DILexicalBlock(scope: !879, file: !104, line: 16, column: 5)
!879 = distinct !DILexicalBlock(scope: !869, file: !104, line: 16, column: 5)
!880 = !DILocation(line: 16, column: 5, scope: !879)
!881 = !DILocation(line: 17, column: 25, scope: !869)
!882 = !DILocation(line: 17, column: 32, scope: !869)
!883 = !DILocation(line: 17, column: 5, scope: !869)
!884 = !DILocation(line: 18, column: 17, scope: !869)
!885 = !DILocation(line: 18, column: 24, scope: !869)
!886 = !DILocation(line: 18, column: 31, scope: !869)
!887 = !DILocation(line: 18, column: 5, scope: !869)
!888 = !DILocation(line: 19, column: 1, scope: !869)
!889 = distinct !DISubprogram(name: "trace_init", scope: !109, file: !109, line: 28, type: !890, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!890 = !DISubroutineType(types: !891)
!891 = !{null, !892, !5}
!892 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !108, size: 64)
!893 = !DILocalVariable(name: "trace", arg: 1, scope: !889, file: !109, line: 28, type: !892)
!894 = !DILocation(line: 28, column: 21, scope: !889)
!895 = !DILocalVariable(name: "capacity", arg: 2, scope: !889, file: !109, line: 28, type: !5)
!896 = !DILocation(line: 28, column: 36, scope: !889)
!897 = !DILocation(line: 30, column: 5, scope: !898)
!898 = distinct !DILexicalBlock(scope: !899, file: !109, line: 30, column: 5)
!899 = distinct !DILexicalBlock(scope: !889, file: !109, line: 30, column: 5)
!900 = !DILocation(line: 30, column: 5, scope: !899)
!901 = !DILocation(line: 31, column: 27, scope: !889)
!902 = !DILocation(line: 31, column: 36, scope: !889)
!903 = !DILocation(line: 31, column: 20, scope: !889)
!904 = !DILocation(line: 31, column: 5, scope: !889)
!905 = !DILocation(line: 31, column: 12, scope: !889)
!906 = !DILocation(line: 31, column: 18, scope: !889)
!907 = !DILocation(line: 32, column: 9, scope: !908)
!908 = distinct !DILexicalBlock(scope: !889, file: !109, line: 32, column: 9)
!909 = !DILocation(line: 32, column: 16, scope: !908)
!910 = !DILocation(line: 32, column: 9, scope: !889)
!911 = !DILocation(line: 33, column: 9, scope: !912)
!912 = distinct !DILexicalBlock(scope: !908, file: !109, line: 32, column: 23)
!913 = !DILocation(line: 33, column: 16, scope: !912)
!914 = !DILocation(line: 33, column: 28, scope: !912)
!915 = !DILocation(line: 34, column: 30, scope: !912)
!916 = !DILocation(line: 34, column: 9, scope: !912)
!917 = !DILocation(line: 34, column: 16, scope: !912)
!918 = !DILocation(line: 34, column: 28, scope: !912)
!919 = !DILocation(line: 35, column: 9, scope: !912)
!920 = !DILocation(line: 35, column: 16, scope: !912)
!921 = !DILocation(line: 35, column: 28, scope: !912)
!922 = !DILocation(line: 36, column: 5, scope: !912)
!923 = !DILocation(line: 37, column: 9, scope: !924)
!924 = distinct !DILexicalBlock(scope: !908, file: !109, line: 36, column: 12)
!925 = !DILocation(line: 37, column: 16, scope: !924)
!926 = !DILocation(line: 37, column: 28, scope: !924)
!927 = !DILocation(line: 38, column: 9, scope: !924)
!928 = !DILocation(line: 38, column: 16, scope: !924)
!929 = !DILocation(line: 38, column: 28, scope: !924)
!930 = !DILocation(line: 39, column: 9, scope: !924)
!931 = !DILocation(line: 39, column: 16, scope: !924)
!932 = !DILocation(line: 39, column: 28, scope: !924)
!933 = !DILocation(line: 40, column: 9, scope: !934)
!934 = distinct !DILexicalBlock(scope: !935, file: !109, line: 40, column: 9)
!935 = distinct !DILexicalBlock(scope: !924, file: !109, line: 40, column: 9)
!936 = !DILocation(line: 42, column: 1, scope: !889)
!937 = distinct !DISubprogram(name: "_vqueue_ub_node_init", scope: !33, file: !33, line: 219, type: !768, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!938 = !DILocalVariable(name: "qnode", arg: 1, scope: !937, file: !33, line: 219, type: !31)
!939 = !DILocation(line: 219, column: 40, scope: !937)
!940 = !DILocalVariable(name: "data", arg: 2, scope: !937, file: !33, line: 219, type: !13)
!941 = !DILocation(line: 219, column: 53, scope: !937)
!942 = !DILocation(line: 221, column: 19, scope: !937)
!943 = !DILocation(line: 221, column: 5, scope: !937)
!944 = !DILocation(line: 221, column: 12, scope: !937)
!945 = !DILocation(line: 221, column: 17, scope: !937)
!946 = !DILocation(line: 222, column: 27, scope: !937)
!947 = !DILocation(line: 222, column: 34, scope: !937)
!948 = !DILocation(line: 222, column: 5, scope: !937)
!949 = !DILocation(line: 223, column: 1, scope: !937)
!950 = distinct !DISubprogram(name: "queue_lock_init", scope: !33, file: !33, line: 31, type: !951, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!951 = !DISubroutineType(types: !952)
!952 = !{null, !953}
!953 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !161, size: 64)
!954 = !DILocalVariable(name: "l", arg: 1, scope: !950, file: !33, line: 31, type: !953)
!955 = !DILocation(line: 31, column: 1, scope: !950)
!956 = distinct !DISubprogram(name: "vatomicptr_write_rlx", scope: !783, file: !783, line: 325, type: !957, scopeLine: 326, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!957 = !DISubroutineType(types: !958)
!958 = !{null, !959, !13}
!959 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!960 = !DILocalVariable(name: "a", arg: 1, scope: !956, file: !783, line: 325, type: !959)
!961 = !DILocation(line: 325, column: 36, scope: !956)
!962 = !DILocalVariable(name: "v", arg: 2, scope: !956, file: !783, line: 325, type: !13)
!963 = !DILocation(line: 325, column: 45, scope: !956)
!964 = !DILocation(line: 329, column: 32, scope: !956)
!965 = !DILocation(line: 329, column: 44, scope: !956)
!966 = !DILocation(line: 329, column: 47, scope: !956)
!967 = !DILocation(line: 327, column: 5, scope: !956)
!968 = !{i64 856832}
!969 = !DILocation(line: 331, column: 1, scope: !956)
!970 = distinct !DISubprogram(name: "ismr_reg", scope: !50, file: !50, line: 89, type: !180, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!971 = !DILocalVariable(name: "tid", arg: 1, scope: !970, file: !50, line: 89, type: !5)
!972 = !DILocation(line: 89, column: 18, scope: !970)
!973 = !DILocation(line: 91, column: 5, scope: !970)
!974 = !DILocation(line: 91, column: 5, scope: !975)
!975 = distinct !DILexicalBlock(scope: !970, file: !50, line: 91, column: 5)
!976 = !DILocation(line: 91, column: 5, scope: !977)
!977 = distinct !DILexicalBlock(scope: !975, file: !50, line: 91, column: 5)
!978 = !DILocation(line: 91, column: 5, scope: !979)
!979 = distinct !DILexicalBlock(scope: !977, file: !50, line: 91, column: 5)
!980 = !DILocation(line: 92, column: 1, scope: !970)
!981 = distinct !DISubprogram(name: "ismr_dereg", scope: !50, file: !50, line: 95, type: !180, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!982 = !DILocalVariable(name: "tid", arg: 1, scope: !981, file: !50, line: 95, type: !5)
!983 = !DILocation(line: 95, column: 20, scope: !981)
!984 = !DILocation(line: 97, column: 5, scope: !981)
!985 = !DILocation(line: 97, column: 5, scope: !986)
!986 = distinct !DILexicalBlock(scope: !981, file: !50, line: 97, column: 5)
!987 = !DILocation(line: 97, column: 5, scope: !988)
!988 = distinct !DILexicalBlock(scope: !986, file: !50, line: 97, column: 5)
!989 = !DILocation(line: 97, column: 5, scope: !990)
!990 = distinct !DILexicalBlock(scope: !988, file: !50, line: 97, column: 5)
!991 = !DILocation(line: 98, column: 1, scope: !981)
!992 = distinct !DISubprogram(name: "vqueue_ub_deq", scope: !33, file: !33, line: 166, type: !993, scopeLine: 167, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!993 = !DISubroutineType(types: !994)
!994 = !{!13, !402, !727, !13}
!995 = !DILocalVariable(name: "q", arg: 1, scope: !992, file: !33, line: 166, type: !402)
!996 = !DILocation(line: 166, column: 28, scope: !992)
!997 = !DILocalVariable(name: "retire", arg: 2, scope: !992, file: !33, line: 166, type: !727)
!998 = !DILocation(line: 166, column: 56, scope: !992)
!999 = !DILocalVariable(name: "retire_arg", arg: 3, scope: !992, file: !33, line: 166, type: !13)
!1000 = !DILocation(line: 166, column: 70, scope: !992)
!1001 = !DILocalVariable(name: "qnode", scope: !992, file: !33, line: 168, type: !31)
!1002 = !DILocation(line: 168, column: 23, scope: !992)
!1003 = !DILocalVariable(name: "head", scope: !992, file: !33, line: 169, type: !31)
!1004 = !DILocation(line: 169, column: 23, scope: !992)
!1005 = !DILocalVariable(name: "data", scope: !992, file: !33, line: 170, type: !13)
!1006 = !DILocation(line: 170, column: 11, scope: !992)
!1007 = !DILocation(line: 172, column: 25, scope: !992)
!1008 = !DILocation(line: 172, column: 28, scope: !992)
!1009 = !DILocation(line: 172, column: 5, scope: !992)
!1010 = !DILocation(line: 174, column: 12, scope: !992)
!1011 = !DILocation(line: 174, column: 15, scope: !992)
!1012 = !DILocation(line: 174, column: 10, scope: !992)
!1013 = !DILocation(line: 176, column: 54, scope: !992)
!1014 = !DILocation(line: 176, column: 60, scope: !992)
!1015 = !DILocation(line: 176, column: 33, scope: !992)
!1016 = !DILocation(line: 176, column: 13, scope: !992)
!1017 = !DILocation(line: 176, column: 11, scope: !992)
!1018 = !DILocation(line: 177, column: 9, scope: !1019)
!1019 = distinct !DILexicalBlock(scope: !992, file: !33, line: 177, column: 9)
!1020 = !DILocation(line: 177, column: 9, scope: !992)
!1021 = !DILocation(line: 178, column: 19, scope: !1022)
!1022 = distinct !DILexicalBlock(scope: !1019, file: !33, line: 177, column: 16)
!1023 = !DILocation(line: 178, column: 26, scope: !1022)
!1024 = !DILocation(line: 178, column: 17, scope: !1022)
!1025 = !DILocation(line: 179, column: 19, scope: !1022)
!1026 = !DILocation(line: 179, column: 9, scope: !1022)
!1027 = !DILocation(line: 179, column: 12, scope: !1022)
!1028 = !DILocation(line: 179, column: 17, scope: !1022)
!1029 = !DILocation(line: 180, column: 13, scope: !1030)
!1030 = distinct !DILexicalBlock(scope: !1022, file: !33, line: 180, column: 13)
!1031 = !DILocation(line: 180, column: 22, scope: !1030)
!1032 = !DILocation(line: 180, column: 25, scope: !1030)
!1033 = !DILocation(line: 180, column: 18, scope: !1030)
!1034 = !DILocation(line: 180, column: 13, scope: !1022)
!1035 = !DILocation(line: 181, column: 13, scope: !1036)
!1036 = distinct !DILexicalBlock(scope: !1030, file: !33, line: 180, column: 35)
!1037 = !DILocation(line: 181, column: 20, scope: !1036)
!1038 = !DILocation(line: 181, column: 26, scope: !1036)
!1039 = !DILocation(line: 182, column: 9, scope: !1036)
!1040 = !DILocation(line: 183, column: 5, scope: !1022)
!1041 = !DILocation(line: 184, column: 25, scope: !992)
!1042 = !DILocation(line: 184, column: 28, scope: !992)
!1043 = !DILocation(line: 184, column: 5, scope: !992)
!1044 = !DILocation(line: 185, column: 12, scope: !992)
!1045 = !DILocation(line: 185, column: 5, scope: !992)
!1046 = distinct !DISubprogram(name: "_queue_destroy", scope: !44, file: !44, line: 67, type: !1047, scopeLine: 68, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1047 = !DISubroutineType(types: !1048)
!1048 = !{null, !541, !13}
!1049 = !DILocalVariable(name: "node", arg: 1, scope: !1046, file: !44, line: 67, type: !541)
!1050 = !DILocation(line: 67, column: 30, scope: !1046)
!1051 = !DILocalVariable(name: "arg", arg: 2, scope: !1046, file: !44, line: 67, type: !13)
!1052 = !DILocation(line: 67, column: 42, scope: !1046)
!1053 = !DILocation(line: 72, column: 15, scope: !1046)
!1054 = !DILocation(line: 72, column: 5, scope: !1046)
!1055 = !DILocation(line: 74, column: 5, scope: !1046)
!1056 = !DILocation(line: 74, column: 5, scope: !1057)
!1057 = distinct !DILexicalBlock(scope: !1046, file: !44, line: 74, column: 5)
!1058 = !DILocation(line: 74, column: 5, scope: !1059)
!1059 = distinct !DILexicalBlock(scope: !1057, file: !44, line: 74, column: 5)
!1060 = !DILocation(line: 74, column: 5, scope: !1061)
!1061 = distinct !DILexicalBlock(scope: !1059, file: !44, line: 74, column: 5)
!1062 = !DILocation(line: 75, column: 1, scope: !1046)
!1063 = distinct !DISubprogram(name: "vqueue_ub_destroy", scope: !33, file: !33, line: 98, type: !725, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1064 = !DILocalVariable(name: "q", arg: 1, scope: !1063, file: !33, line: 98, type: !402)
!1065 = !DILocation(line: 98, column: 32, scope: !1063)
!1066 = !DILocalVariable(name: "retire", arg: 2, scope: !1063, file: !33, line: 98, type: !727)
!1067 = !DILocation(line: 98, column: 60, scope: !1063)
!1068 = !DILocalVariable(name: "retire_arg", arg: 3, scope: !1063, file: !33, line: 99, type: !13)
!1069 = !DILocation(line: 99, column: 25, scope: !1063)
!1070 = !DILocalVariable(name: "curr", scope: !1063, file: !33, line: 101, type: !31)
!1071 = !DILocation(line: 101, column: 23, scope: !1063)
!1072 = !DILocalVariable(name: "next", scope: !1063, file: !33, line: 102, type: !31)
!1073 = !DILocation(line: 102, column: 23, scope: !1063)
!1074 = !DILocation(line: 104, column: 12, scope: !1063)
!1075 = !DILocation(line: 104, column: 15, scope: !1063)
!1076 = !DILocation(line: 104, column: 10, scope: !1063)
!1077 = !DILocation(line: 106, column: 5, scope: !1063)
!1078 = !DILocation(line: 106, column: 12, scope: !1063)
!1079 = !DILocation(line: 107, column: 57, scope: !1080)
!1080 = distinct !DILexicalBlock(scope: !1063, file: !33, line: 106, column: 18)
!1081 = !DILocation(line: 107, column: 63, scope: !1080)
!1082 = !DILocation(line: 107, column: 36, scope: !1080)
!1083 = !DILocation(line: 107, column: 16, scope: !1080)
!1084 = !DILocation(line: 107, column: 14, scope: !1080)
!1085 = !DILocation(line: 108, column: 13, scope: !1086)
!1086 = distinct !DILexicalBlock(scope: !1080, file: !33, line: 108, column: 13)
!1087 = !DILocation(line: 108, column: 22, scope: !1086)
!1088 = !DILocation(line: 108, column: 25, scope: !1086)
!1089 = !DILocation(line: 108, column: 18, scope: !1086)
!1090 = !DILocation(line: 108, column: 13, scope: !1080)
!1091 = !DILocation(line: 109, column: 13, scope: !1092)
!1092 = distinct !DILexicalBlock(scope: !1086, file: !33, line: 108, column: 35)
!1093 = !DILocation(line: 109, column: 20, scope: !1092)
!1094 = !DILocation(line: 109, column: 26, scope: !1092)
!1095 = !DILocation(line: 110, column: 9, scope: !1092)
!1096 = !DILocation(line: 111, column: 16, scope: !1080)
!1097 = !DILocation(line: 111, column: 14, scope: !1080)
!1098 = distinct !{!1098, !1077, !1099, !505}
!1099 = !DILocation(line: 112, column: 5, scope: !1063)
!1100 = !DILocation(line: 113, column: 1, scope: !1063)
!1101 = distinct !DISubprogram(name: "ismr_destroy", scope: !50, file: !50, line: 101, type: !285, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1102 = !DILocation(line: 103, column: 5, scope: !1101)
!1103 = !DILocation(line: 104, column: 1, scope: !1101)
!1104 = distinct !DISubprogram(name: "queue_lock_acquire", scope: !33, file: !33, line: 31, type: !951, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1105 = !DILocalVariable(name: "l", arg: 1, scope: !1104, file: !33, line: 31, type: !953)
!1106 = !DILocation(line: 31, column: 1, scope: !1104)
!1107 = !DILocalVariable(name: "val", scope: !1104, file: !33, line: 31, type: !66)
!1108 = !DILocation(line: 31, column: 1, scope: !1109)
!1109 = distinct !DILexicalBlock(scope: !1110, file: !33, line: 31, column: 1)
!1110 = distinct !DILexicalBlock(scope: !1104, file: !33, line: 31, column: 1)
!1111 = !DILocation(line: 31, column: 1, scope: !1110)
!1112 = distinct !DISubprogram(name: "vatomicptr_read_acq", scope: !783, file: !783, line: 181, type: !784, scopeLine: 182, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1113 = !DILocalVariable(name: "a", arg: 1, scope: !1112, file: !783, line: 181, type: !786)
!1114 = !DILocation(line: 181, column: 41, scope: !1112)
!1115 = !DILocalVariable(name: "val", scope: !1112, file: !783, line: 183, type: !13)
!1116 = !DILocation(line: 183, column: 11, scope: !1112)
!1117 = !DILocation(line: 186, column: 32, scope: !1112)
!1118 = !DILocation(line: 186, column: 35, scope: !1112)
!1119 = !DILocation(line: 184, column: 5, scope: !1112)
!1120 = !{i64 852131}
!1121 = !DILocation(line: 188, column: 12, scope: !1112)
!1122 = !DILocation(line: 188, column: 5, scope: !1112)
!1123 = distinct !DISubprogram(name: "queue_lock_release", scope: !33, file: !33, line: 31, type: !951, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1124 = !DILocalVariable(name: "l", arg: 1, scope: !1123, file: !33, line: 31, type: !953)
!1125 = !DILocation(line: 31, column: 1, scope: !1123)
!1126 = !DILocalVariable(name: "val", scope: !1123, file: !33, line: 31, type: !66)
!1127 = !DILocation(line: 31, column: 1, scope: !1128)
!1128 = distinct !DILexicalBlock(scope: !1129, file: !33, line: 31, column: 1)
!1129 = distinct !DILexicalBlock(scope: !1123, file: !33, line: 31, column: 1)
!1130 = !DILocation(line: 31, column: 1, scope: !1129)
!1131 = distinct !DISubprogram(name: "vmem_free", scope: !79, file: !79, line: 71, type: !46, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1132 = !DILocalVariable(name: "ptr", arg: 1, scope: !1131, file: !79, line: 71, type: !13)
!1133 = !DILocation(line: 71, column: 17, scope: !1131)
!1134 = !DILocation(line: 73, column: 10, scope: !1131)
!1135 = !DILocation(line: 73, column: 5, scope: !1131)
!1136 = !DILocation(line: 74, column: 9, scope: !1137)
!1137 = distinct !DILexicalBlock(scope: !1131, file: !79, line: 74, column: 9)
!1138 = !DILocation(line: 74, column: 9, scope: !1131)
!1139 = !DILocation(line: 76, column: 9, scope: !1140)
!1140 = distinct !DILexicalBlock(scope: !1137, file: !79, line: 74, column: 14)
!1141 = !DILocation(line: 78, column: 5, scope: !1140)
!1142 = !DILocation(line: 79, column: 1, scope: !1131)
!1143 = distinct !DISubprogram(name: "vatomic64_inc_rlx", scope: !1144, file: !1144, line: 3000, type: !1145, scopeLine: 3001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1144 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!1145 = !DISubroutineType(types: !1146)
!1146 = !{null, !1147}
!1147 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!1148 = !DILocalVariable(name: "a", arg: 1, scope: !1143, file: !1144, line: 3000, type: !1147)
!1149 = !DILocation(line: 3000, column: 32, scope: !1143)
!1150 = !DILocation(line: 3002, column: 33, scope: !1143)
!1151 = !DILocation(line: 3002, column: 11, scope: !1143)
!1152 = !DILocation(line: 3003, column: 1, scope: !1143)
!1153 = distinct !DISubprogram(name: "vatomic64_get_inc_rlx", scope: !1144, file: !1144, line: 2560, type: !1154, scopeLine: 2561, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1154 = !DISubroutineType(types: !1155)
!1155 = !{!84, !1147}
!1156 = !DILocalVariable(name: "a", arg: 1, scope: !1153, file: !1144, line: 2560, type: !1147)
!1157 = !DILocation(line: 2560, column: 36, scope: !1153)
!1158 = !DILocation(line: 2562, column: 34, scope: !1153)
!1159 = !DILocation(line: 2562, column: 12, scope: !1153)
!1160 = !DILocation(line: 2562, column: 5, scope: !1153)
!1161 = distinct !DISubprogram(name: "vatomic64_get_add_rlx", scope: !1162, file: !1162, line: 1888, type: !1163, scopeLine: 1889, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1162 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!1163 = !DISubroutineType(types: !1164)
!1164 = !{!84, !1147, !84}
!1165 = !DILocalVariable(name: "a", arg: 1, scope: !1161, file: !1162, line: 1888, type: !1147)
!1166 = !DILocation(line: 1888, column: 36, scope: !1161)
!1167 = !DILocalVariable(name: "v", arg: 2, scope: !1161, file: !1162, line: 1888, type: !84)
!1168 = !DILocation(line: 1888, column: 49, scope: !1161)
!1169 = !DILocalVariable(name: "oldv", scope: !1161, file: !1162, line: 1890, type: !84)
!1170 = !DILocation(line: 1890, column: 15, scope: !1161)
!1171 = !DILocalVariable(name: "tmp", scope: !1161, file: !1162, line: 1891, type: !1172)
!1172 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !6, line: 35, baseType: !1173)
!1173 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !86, line: 26, baseType: !1174)
!1174 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !88, line: 42, baseType: !132)
!1175 = !DILocation(line: 1891, column: 15, scope: !1161)
!1176 = !DILocalVariable(name: "newv", scope: !1161, file: !1162, line: 1892, type: !84)
!1177 = !DILocation(line: 1892, column: 15, scope: !1161)
!1178 = !DILocation(line: 1893, column: 5, scope: !1161)
!1179 = !DILocation(line: 1901, column: 19, scope: !1161)
!1180 = !DILocation(line: 1901, column: 22, scope: !1161)
!1181 = !{i64 961875, i64 961909, i64 961924, i64 961956, i64 961998, i64 962039}
!1182 = !DILocation(line: 1904, column: 12, scope: !1161)
!1183 = !DILocation(line: 1904, column: 5, scope: !1161)
!1184 = distinct !DISubprogram(name: "locked_trace_destroy", scope: !104, file: !104, line: 31, type: !1185, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1185 = !DISubroutineType(types: !1186)
!1186 = !{null, !872, !1187}
!1187 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_verify_unit", file: !109, line: 25, baseType: !1188)
!1188 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1189, size: 64)
!1189 = !DISubroutineType(types: !1190)
!1190 = !{!24, !113}
!1191 = !DILocalVariable(name: "trace", arg: 1, scope: !1184, file: !104, line: 31, type: !872)
!1192 = !DILocation(line: 31, column: 38, scope: !1184)
!1193 = !DILocalVariable(name: "callback", arg: 2, scope: !1184, file: !104, line: 31, type: !1187)
!1194 = !DILocation(line: 31, column: 63, scope: !1184)
!1195 = !DILocation(line: 33, column: 19, scope: !1184)
!1196 = !DILocation(line: 33, column: 26, scope: !1184)
!1197 = !DILocation(line: 33, column: 33, scope: !1184)
!1198 = !DILocation(line: 33, column: 5, scope: !1184)
!1199 = !DILocation(line: 34, column: 20, scope: !1184)
!1200 = !DILocation(line: 34, column: 27, scope: !1184)
!1201 = !DILocation(line: 34, column: 5, scope: !1184)
!1202 = !DILocation(line: 35, column: 28, scope: !1184)
!1203 = !DILocation(line: 35, column: 35, scope: !1184)
!1204 = !DILocation(line: 35, column: 5, scope: !1184)
!1205 = !DILocation(line: 36, column: 1, scope: !1184)
!1206 = distinct !DISubprogram(name: "_ismr_none_destroy_all_cb", scope: !50, file: !50, line: 25, type: !1189, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1207 = !DILocalVariable(name: "unit", arg: 1, scope: !1206, file: !50, line: 25, type: !113)
!1208 = !DILocation(line: 25, column: 41, scope: !1206)
!1209 = !DILocation(line: 27, column: 5, scope: !1210)
!1210 = distinct !DILexicalBlock(scope: !1211, file: !50, line: 27, column: 5)
!1211 = distinct !DILexicalBlock(scope: !1206, file: !50, line: 27, column: 5)
!1212 = !DILocation(line: 27, column: 5, scope: !1211)
!1213 = !DILocalVariable(name: "info", scope: !1206, file: !50, line: 28, type: !48)
!1214 = !DILocation(line: 28, column: 29, scope: !1206)
!1215 = !DILocation(line: 28, column: 62, scope: !1206)
!1216 = !DILocation(line: 28, column: 68, scope: !1206)
!1217 = !DILocation(line: 28, column: 36, scope: !1206)
!1218 = !DILocation(line: 29, column: 5, scope: !1206)
!1219 = !DILocation(line: 29, column: 11, scope: !1206)
!1220 = !DILocation(line: 29, column: 20, scope: !1206)
!1221 = !DILocation(line: 29, column: 26, scope: !1206)
!1222 = !DILocation(line: 29, column: 35, scope: !1206)
!1223 = !DILocation(line: 29, column: 41, scope: !1206)
!1224 = !DILocation(line: 30, column: 10, scope: !1206)
!1225 = !DILocation(line: 30, column: 5, scope: !1206)
!1226 = !DILocation(line: 31, column: 5, scope: !1206)
!1227 = distinct !DISubprogram(name: "trace_verify", scope: !109, file: !109, line: 210, type: !1228, scopeLine: 211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1228 = !DISubroutineType(types: !1229)
!1229 = !{!24, !892, !1187}
!1230 = !DILocalVariable(name: "trace", arg: 1, scope: !1227, file: !109, line: 210, type: !892)
!1231 = !DILocation(line: 210, column: 23, scope: !1227)
!1232 = !DILocalVariable(name: "verify_fun", arg: 2, scope: !1227, file: !109, line: 210, type: !1187)
!1233 = !DILocation(line: 210, column: 48, scope: !1227)
!1234 = !DILocalVariable(name: "i", scope: !1227, file: !109, line: 212, type: !5)
!1235 = !DILocation(line: 212, column: 13, scope: !1227)
!1236 = !DILocation(line: 214, column: 5, scope: !1237)
!1237 = distinct !DILexicalBlock(scope: !1238, file: !109, line: 214, column: 5)
!1238 = distinct !DILexicalBlock(scope: !1227, file: !109, line: 214, column: 5)
!1239 = !DILocation(line: 214, column: 5, scope: !1238)
!1240 = !DILocation(line: 215, column: 5, scope: !1241)
!1241 = distinct !DILexicalBlock(scope: !1242, file: !109, line: 215, column: 5)
!1242 = distinct !DILexicalBlock(scope: !1227, file: !109, line: 215, column: 5)
!1243 = !DILocation(line: 215, column: 5, scope: !1242)
!1244 = !DILocation(line: 216, column: 5, scope: !1245)
!1245 = distinct !DILexicalBlock(scope: !1246, file: !109, line: 216, column: 5)
!1246 = distinct !DILexicalBlock(scope: !1227, file: !109, line: 216, column: 5)
!1247 = !DILocation(line: 216, column: 5, scope: !1246)
!1248 = !DILocation(line: 218, column: 12, scope: !1249)
!1249 = distinct !DILexicalBlock(scope: !1227, file: !109, line: 218, column: 5)
!1250 = !DILocation(line: 218, column: 10, scope: !1249)
!1251 = !DILocation(line: 218, column: 17, scope: !1252)
!1252 = distinct !DILexicalBlock(scope: !1249, file: !109, line: 218, column: 5)
!1253 = !DILocation(line: 218, column: 21, scope: !1252)
!1254 = !DILocation(line: 218, column: 28, scope: !1252)
!1255 = !DILocation(line: 218, column: 19, scope: !1252)
!1256 = !DILocation(line: 218, column: 5, scope: !1249)
!1257 = !DILocation(line: 219, column: 13, scope: !1258)
!1258 = distinct !DILexicalBlock(scope: !1259, file: !109, line: 219, column: 13)
!1259 = distinct !DILexicalBlock(scope: !1252, file: !109, line: 218, column: 38)
!1260 = !DILocation(line: 219, column: 25, scope: !1258)
!1261 = !DILocation(line: 219, column: 32, scope: !1258)
!1262 = !DILocation(line: 219, column: 38, scope: !1258)
!1263 = !DILocation(line: 219, column: 42, scope: !1258)
!1264 = !DILocation(line: 219, column: 13, scope: !1259)
!1265 = !DILocation(line: 220, column: 13, scope: !1266)
!1266 = distinct !DILexicalBlock(scope: !1258, file: !109, line: 219, column: 52)
!1267 = !DILocation(line: 222, column: 5, scope: !1259)
!1268 = !DILocation(line: 218, column: 34, scope: !1252)
!1269 = !DILocation(line: 218, column: 5, scope: !1252)
!1270 = distinct !{!1270, !1256, !1271, !505}
!1271 = !DILocation(line: 222, column: 5, scope: !1249)
!1272 = !DILocation(line: 223, column: 5, scope: !1227)
!1273 = !DILocation(line: 224, column: 1, scope: !1227)
!1274 = distinct !DISubprogram(name: "trace_destroy", scope: !109, file: !109, line: 97, type: !1275, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1275 = !DISubroutineType(types: !1276)
!1276 = !{null, !892}
!1277 = !DILocalVariable(name: "trace", arg: 1, scope: !1274, file: !109, line: 97, type: !892)
!1278 = !DILocation(line: 97, column: 24, scope: !1274)
!1279 = !DILocation(line: 99, column: 5, scope: !1280)
!1280 = distinct !DILexicalBlock(scope: !1281, file: !109, line: 99, column: 5)
!1281 = distinct !DILexicalBlock(scope: !1274, file: !109, line: 99, column: 5)
!1282 = !DILocation(line: 99, column: 5, scope: !1281)
!1283 = !DILocation(line: 100, column: 5, scope: !1284)
!1284 = distinct !DILexicalBlock(scope: !1285, file: !109, line: 100, column: 5)
!1285 = distinct !DILexicalBlock(scope: !1274, file: !109, line: 100, column: 5)
!1286 = !DILocation(line: 100, column: 5, scope: !1285)
!1287 = !DILocation(line: 101, column: 10, scope: !1274)
!1288 = !DILocation(line: 101, column: 17, scope: !1274)
!1289 = !DILocation(line: 101, column: 5, scope: !1274)
!1290 = !DILocation(line: 102, column: 5, scope: !1274)
!1291 = !DILocation(line: 102, column: 12, scope: !1274)
!1292 = !DILocation(line: 102, column: 24, scope: !1274)
!1293 = !DILocation(line: 103, column: 1, scope: !1274)
!1294 = distinct !DISubprogram(name: "vmem_malloc", scope: !79, file: !79, line: 20, type: !1295, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1295 = !DISubroutineType(types: !1296)
!1296 = !{!13, !5}
!1297 = !DILocalVariable(name: "sz", arg: 1, scope: !1294, file: !79, line: 20, type: !5)
!1298 = !DILocation(line: 20, column: 21, scope: !1294)
!1299 = !DILocalVariable(name: "ptr", scope: !1294, file: !79, line: 22, type: !13)
!1300 = !DILocation(line: 22, column: 11, scope: !1294)
!1301 = !DILocation(line: 22, column: 24, scope: !1294)
!1302 = !DILocation(line: 22, column: 17, scope: !1294)
!1303 = !DILocation(line: 23, column: 9, scope: !1304)
!1304 = distinct !DILexicalBlock(scope: !1294, file: !79, line: 23, column: 9)
!1305 = !DILocation(line: 23, column: 9, scope: !1294)
!1306 = !DILocation(line: 25, column: 9, scope: !1307)
!1307 = distinct !DILexicalBlock(scope: !1304, file: !79, line: 23, column: 14)
!1308 = !DILocation(line: 27, column: 5, scope: !1307)
!1309 = !DILocation(line: 28, column: 9, scope: !1310)
!1310 = distinct !DILexicalBlock(scope: !1311, file: !79, line: 28, column: 9)
!1311 = distinct !DILexicalBlock(scope: !1312, file: !79, line: 28, column: 9)
!1312 = distinct !DILexicalBlock(scope: !1304, file: !79, line: 27, column: 12)
!1313 = !DILocation(line: 30, column: 12, scope: !1294)
!1314 = !DILocation(line: 30, column: 5, scope: !1294)
!1315 = distinct !DISubprogram(name: "ismr_enter", scope: !50, file: !50, line: 41, type: !180, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1316 = !DILocalVariable(name: "tid", arg: 1, scope: !1315, file: !50, line: 41, type: !5)
!1317 = !DILocation(line: 41, column: 20, scope: !1315)
!1318 = !DILocation(line: 43, column: 5, scope: !1315)
!1319 = !DILocation(line: 43, column: 5, scope: !1320)
!1320 = distinct !DILexicalBlock(scope: !1315, file: !50, line: 43, column: 5)
!1321 = !DILocation(line: 43, column: 5, scope: !1322)
!1322 = distinct !DILexicalBlock(scope: !1320, file: !50, line: 43, column: 5)
!1323 = !DILocation(line: 43, column: 5, scope: !1324)
!1324 = distinct !DILexicalBlock(scope: !1322, file: !50, line: 43, column: 5)
!1325 = !DILocation(line: 44, column: 1, scope: !1315)
!1326 = distinct !DISubprogram(name: "vqueue_ub_enq", scope: !33, file: !33, line: 122, type: !1327, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1327 = !DISubroutineType(types: !1328)
!1328 = !{null, !402, !31, !13}
!1329 = !DILocalVariable(name: "q", arg: 1, scope: !1326, file: !33, line: 122, type: !402)
!1330 = !DILocation(line: 122, column: 28, scope: !1326)
!1331 = !DILocalVariable(name: "qnode", arg: 2, scope: !1326, file: !33, line: 122, type: !31)
!1332 = !DILocation(line: 122, column: 49, scope: !1326)
!1333 = !DILocalVariable(name: "data", arg: 3, scope: !1326, file: !33, line: 122, type: !13)
!1334 = !DILocation(line: 122, column: 62, scope: !1326)
!1335 = !DILocation(line: 124, column: 25, scope: !1326)
!1336 = !DILocation(line: 124, column: 28, scope: !1326)
!1337 = !DILocation(line: 124, column: 5, scope: !1326)
!1338 = !DILocation(line: 127, column: 26, scope: !1326)
!1339 = !DILocation(line: 127, column: 33, scope: !1326)
!1340 = !DILocation(line: 127, column: 5, scope: !1326)
!1341 = !DILocation(line: 129, column: 27, scope: !1326)
!1342 = !DILocation(line: 129, column: 30, scope: !1326)
!1343 = !DILocation(line: 129, column: 36, scope: !1326)
!1344 = !DILocation(line: 129, column: 42, scope: !1326)
!1345 = !DILocation(line: 129, column: 5, scope: !1326)
!1346 = !DILocation(line: 131, column: 15, scope: !1326)
!1347 = !DILocation(line: 131, column: 5, scope: !1326)
!1348 = !DILocation(line: 131, column: 8, scope: !1326)
!1349 = !DILocation(line: 131, column: 13, scope: !1326)
!1350 = !DILocation(line: 132, column: 25, scope: !1326)
!1351 = !DILocation(line: 132, column: 28, scope: !1326)
!1352 = !DILocation(line: 132, column: 5, scope: !1326)
!1353 = !DILocation(line: 133, column: 1, scope: !1326)
!1354 = distinct !DISubprogram(name: "ismr_exit", scope: !50, file: !50, line: 83, type: !180, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1355 = !DILocalVariable(name: "tid", arg: 1, scope: !1354, file: !50, line: 83, type: !5)
!1356 = !DILocation(line: 83, column: 19, scope: !1354)
!1357 = !DILocation(line: 85, column: 5, scope: !1354)
!1358 = !DILocation(line: 85, column: 5, scope: !1359)
!1359 = distinct !DILexicalBlock(scope: !1354, file: !50, line: 85, column: 5)
!1360 = !DILocation(line: 85, column: 5, scope: !1361)
!1361 = distinct !DILexicalBlock(scope: !1359, file: !50, line: 85, column: 5)
!1362 = !DILocation(line: 85, column: 5, scope: !1363)
!1363 = distinct !DILexicalBlock(scope: !1361, file: !50, line: 85, column: 5)
!1364 = !DILocation(line: 86, column: 1, scope: !1354)
!1365 = distinct !DISubprogram(name: "vatomicptr_write_rel", scope: !783, file: !783, line: 311, type: !957, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1366 = !DILocalVariable(name: "a", arg: 1, scope: !1365, file: !783, line: 311, type: !959)
!1367 = !DILocation(line: 311, column: 36, scope: !1365)
!1368 = !DILocalVariable(name: "v", arg: 2, scope: !1365, file: !783, line: 311, type: !13)
!1369 = !DILocation(line: 311, column: 45, scope: !1365)
!1370 = !DILocation(line: 315, column: 32, scope: !1365)
!1371 = !DILocation(line: 315, column: 44, scope: !1365)
!1372 = !DILocation(line: 315, column: 47, scope: !1365)
!1373 = !DILocation(line: 313, column: 5, scope: !1365)
!1374 = !{i64 856361}
!1375 = !DILocation(line: 317, column: 1, scope: !1365)
!1376 = distinct !DISubprogram(name: "_queue_retire", scope: !44, file: !44, line: 53, type: !1047, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1377 = !DILocalVariable(name: "node", arg: 1, scope: !1376, file: !44, line: 53, type: !541)
!1378 = !DILocation(line: 53, column: 29, scope: !1376)
!1379 = !DILocalVariable(name: "arg", arg: 2, scope: !1376, file: !44, line: 53, type: !13)
!1380 = !DILocation(line: 53, column: 41, scope: !1376)
!1381 = !DILocation(line: 61, column: 15, scope: !1376)
!1382 = !DILocation(line: 61, column: 5, scope: !1376)
!1383 = !DILocation(line: 63, column: 5, scope: !1376)
!1384 = !DILocation(line: 63, column: 5, scope: !1385)
!1385 = distinct !DILexicalBlock(scope: !1376, file: !44, line: 63, column: 5)
!1386 = !DILocation(line: 63, column: 5, scope: !1387)
!1387 = distinct !DILexicalBlock(scope: !1385, file: !44, line: 63, column: 5)
!1388 = !DILocation(line: 63, column: 5, scope: !1389)
!1389 = distinct !DILexicalBlock(scope: !1387, file: !44, line: 63, column: 5)
!1390 = !DILocation(line: 64, column: 1, scope: !1376)
!1391 = distinct !DISubprogram(name: "vqueue_ub_empty", scope: !33, file: !33, line: 143, type: !1392, scopeLine: 144, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1392 = !DISubroutineType(types: !1393)
!1393 = !{!24, !402}
!1394 = !DILocalVariable(name: "q", arg: 1, scope: !1391, file: !33, line: 143, type: !402)
!1395 = !DILocation(line: 143, column: 30, scope: !1391)
!1396 = !DILocalVariable(name: "qnode", scope: !1391, file: !33, line: 145, type: !31)
!1397 = !DILocation(line: 145, column: 23, scope: !1391)
!1398 = !DILocalVariable(name: "head", scope: !1391, file: !33, line: 146, type: !31)
!1399 = !DILocation(line: 146, column: 23, scope: !1391)
!1400 = !DILocation(line: 148, column: 25, scope: !1391)
!1401 = !DILocation(line: 148, column: 28, scope: !1391)
!1402 = !DILocation(line: 148, column: 5, scope: !1391)
!1403 = !DILocation(line: 149, column: 12, scope: !1391)
!1404 = !DILocation(line: 149, column: 15, scope: !1391)
!1405 = !DILocation(line: 149, column: 10, scope: !1391)
!1406 = !DILocation(line: 151, column: 54, scope: !1391)
!1407 = !DILocation(line: 151, column: 60, scope: !1391)
!1408 = !DILocation(line: 151, column: 33, scope: !1391)
!1409 = !DILocation(line: 151, column: 13, scope: !1391)
!1410 = !DILocation(line: 151, column: 11, scope: !1391)
!1411 = !DILocation(line: 152, column: 25, scope: !1391)
!1412 = !DILocation(line: 152, column: 28, scope: !1391)
!1413 = !DILocation(line: 152, column: 5, scope: !1391)
!1414 = !DILocation(line: 153, column: 12, scope: !1391)
!1415 = !DILocation(line: 153, column: 18, scope: !1391)
!1416 = !DILocation(line: 153, column: 5, scope: !1391)
