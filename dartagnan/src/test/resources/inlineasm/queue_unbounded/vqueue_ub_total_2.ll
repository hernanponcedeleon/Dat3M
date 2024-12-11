; ModuleID = '/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/unbounded_queue_verify.c'
source_filename = "/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/unbounded_queue_verify.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.vatomic64_s = type { i64 }
%struct.data_s = type { i64, i8 }
%struct.vqueue_ub_s = type { %union.pthread_mutex_t, %union.pthread_mutex_t, %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%struct.vqueue_ub_node_s = type { i8*, %struct.vatomicptr_s }
%struct.vatomicptr_s = type { i8* }
%struct.locked_trace_s = type { %struct.trace_s, %union.pthread_mutex_t }
%struct.trace_s = type { %struct.trace_unit_s*, i64, i64, i8 }
%struct.trace_unit_s = type { i64, i64 }
%struct.run_info_t = type { i64, i64, i8, i8* (i8*)* }
%union.pthread_attr_t = type { i64, [48 x i8] }
%union.pthread_mutexattr_t = type { i32 }
%struct.smr_none_retire_info_t = type { %struct.smr_node_s*, void (%struct.smr_node_s*, i8*)*, i8* }
%struct.smr_node_s = type { %struct.smr_node_core_s, i32, void (%struct.smr_node_s*, i8*)*, i8* }
%struct.smr_node_core_s = type { %struct.smr_node_core_s* }

@_g_vmem_alloc_count = dso_local global %struct.vatomic64_s zeroinitializer, align 8, !dbg !0
@_g_vmem_free_count = dso_local global %struct.vatomic64_s zeroinitializer, align 8, !dbg !77
@g_len = dso_local global i64 0, align 8, !dbg !89
@deq_1 = dso_local global %struct.data_s* null, align 8, !dbg !92
@deq_2 = dso_local global %struct.data_s* null, align 8, !dbg !102
@.str = private unnamed_addr constant [7 x i8] c"!deq_1\00", align 1
@.str.1 = private unnamed_addr constant [78 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/test_case_2.h\00", align 1
@__PRETTY_FUNCTION__.verify = private unnamed_addr constant [18 x i8] c"void verify(void)\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"!deq_2\00", align 1
@.str.3 = private unnamed_addr constant [16 x i8] c"deq_1->key == 1\00", align 1
@.str.4 = private unnamed_addr constant [16 x i8] c"deq_2->key == 1\00", align 1
@.str.5 = private unnamed_addr constant [83 x i8] c"0 && \22we expect at least one dequeue to succeed if the final \22 \22state length is 1\22\00", align 1
@g_final_state = dso_local global [5 x i64] zeroinitializer, align 16, !dbg !168
@.str.6 = private unnamed_addr constant [22 x i8] c"g_final_state[0] == 2\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"deq_1\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"deq_2\00", align 1
@.str.9 = private unnamed_addr constant [16 x i8] c"deq_2->key == 2\00", align 1
@.str.10 = private unnamed_addr constant [33 x i8] c"0 && \22the length makes no sense\22\00", align 1
@g_queue = dso_local global %struct.vqueue_ub_s zeroinitializer, align 8, !dbg !156
@.str.11 = private unnamed_addr constant [15 x i8] c"vmem_no_leak()\00", align 1
@.str.12 = private unnamed_addr constant [89 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/unbounded_queue_verify.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.13 = private unnamed_addr constant [5 x i8] c"data\00", align 1
@__PRETTY_FUNCTION__.get_final_state = private unnamed_addr constant [29 x i8] c"void get_final_state(void *)\00", align 1
@.str.14 = private unnamed_addr constant [10 x i8] c"g_len < 5\00", align 1
@.str.15 = private unnamed_addr constant [39 x i8] c"currently only 3 threads are supported\00", align 1
@.str.16 = private unnamed_addr constant [41 x i8] c"\22currently only 3 threads are supported\22\00", align 1
@__PRETTY_FUNCTION__.run = private unnamed_addr constant [18 x i8] c"void *run(void *)\00", align 1
@global_trace = dso_local global %struct.locked_trace_s zeroinitializer, align 8, !dbg !104
@.str.17 = private unnamed_addr constant [6 x i8] c"trace\00", align 1
@.str.18 = private unnamed_addr constant [64 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/locked_trace.h\00", align 1
@__PRETTY_FUNCTION__.locked_trace_init = private unnamed_addr constant [50 x i8] c"void locked_trace_init(locked_trace_t *, vsize_t)\00", align 1
@.str.19 = private unnamed_addr constant [65 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/trace_manager.h\00", align 1
@__PRETTY_FUNCTION__.trace_init = private unnamed_addr constant [36 x i8] c"void trace_init(trace_t *, vsize_t)\00", align 1
@.str.20 = private unnamed_addr constant [25 x i8] c"0 && \22allocation failed\22\00", align 1
@.str.21 = private unnamed_addr constant [97 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/include/test/queue/ub/queue_interface.h\00", align 1
@__PRETTY_FUNCTION__.queue_destroy = private unnamed_addr constant [30 x i8] c"void queue_destroy(queue_t *)\00", align 1
@.str.22 = private unnamed_addr constant [9 x i8] c"val == 0\00", align 1
@.str.23 = private unnamed_addr constant [101 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/include/vsync/queue/unbounded_queue_total.h\00", align 1
@__PRETTY_FUNCTION__.queue_lock_acquire = private unnamed_addr constant [40 x i8] c"void queue_lock_acquire(queue_lock_t *)\00", align 1
@__PRETTY_FUNCTION__.queue_lock_release = private unnamed_addr constant [40 x i8] c"void queue_lock_release(queue_lock_t *)\00", align 1
@__PRETTY_FUNCTION__.trace_verify = private unnamed_addr constant [51 x i8] c"vbool_t trace_verify(trace_t *, trace_verify_unit)\00", align 1
@.str.24 = private unnamed_addr constant [19 x i8] c"trace->initialized\00", align 1
@.str.25 = private unnamed_addr constant [11 x i8] c"verify_fun\00", align 1
@__PRETTY_FUNCTION__.trace_destroy = private unnamed_addr constant [30 x i8] c"void trace_destroy(trace_t *)\00", align 1
@.str.26 = private unnamed_addr constant [5 x i8] c"unit\00", align 1
@.str.27 = private unnamed_addr constant [70 x i8] c"/home/stefano/huawei/libvsync/memory/smr/include/test/smr/ismr_none.h\00", align 1
@__PRETTY_FUNCTION__._ismr_none_destroy_all_cb = private unnamed_addr constant [50 x i8] c"vbool_t _ismr_none_destroy_all_cb(trace_unit_t *)\00", align 1
@__PRETTY_FUNCTION__.queue_enq = private unnamed_addr constant [52 x i8] c"void queue_enq(vsize_t, queue_t *, vuint64_t, char)\00", align 1
@.str.28 = private unnamed_addr constant [63 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/vmem_stdlib.h\00", align 1
@__PRETTY_FUNCTION__.vmem_malloc = private unnamed_addr constant [27 x i8] c"void *vmem_malloc(vsize_t)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @t1(i64 noundef %0) #0 !dbg !181 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !185, metadata !DIExpression()), !dbg !186
  %3 = load i64, i64* %2, align 8, !dbg !187
  call void @enq(i64 noundef %3, i64 noundef 1, i8 noundef signext 65), !dbg !188
  %4 = load i64, i64* %2, align 8, !dbg !189
  call void @enq(i64 noundef %4, i64 noundef 2, i8 noundef signext 66), !dbg !190
  ret void, !dbg !191
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @enq(i64 noundef %0, i64 noundef %1, i8 noundef signext %2) #0 !dbg !192 {
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i8, align 1
  store i64 %0, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !195, metadata !DIExpression()), !dbg !196
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !197, metadata !DIExpression()), !dbg !198
  store i8 %2, i8* %6, align 1
  call void @llvm.dbg.declare(metadata i8* %6, metadata !199, metadata !DIExpression()), !dbg !200
  %7 = load i64, i64* %4, align 8, !dbg !201
  %8 = load i64, i64* %5, align 8, !dbg !202
  %9 = load i8, i8* %6, align 1, !dbg !203
  call void @queue_enq(i64 noundef %7, %struct.vqueue_ub_s* noundef @g_queue, i64 noundef %8, i8 noundef signext %9), !dbg !204
  ret void, !dbg !205
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @t2(i64 noundef %0) #0 !dbg !206 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !207, metadata !DIExpression()), !dbg !208
  %3 = load i64, i64* %2, align 8, !dbg !209
  %4 = call %struct.data_s* @deq(i64 noundef %3), !dbg !210
  store %struct.data_s* %4, %struct.data_s** @deq_1, align 8, !dbg !211
  %5 = load i64, i64* %2, align 8, !dbg !212
  %6 = call %struct.data_s* @deq(i64 noundef %5), !dbg !213
  store %struct.data_s* %6, %struct.data_s** @deq_2, align 8, !dbg !214
  ret void, !dbg !215
}

; Function Attrs: noinline nounwind uwtable
define dso_local %struct.data_s* @deq(i64 noundef %0) #0 !dbg !216 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !219, metadata !DIExpression()), !dbg !220
  %3 = load i64, i64* %2, align 8, !dbg !221
  %4 = call i8* @queue_deq(i64 noundef %3, %struct.vqueue_ub_s* noundef @g_queue), !dbg !222
  %5 = bitcast i8* %4 to %struct.data_s*, !dbg !222
  ret %struct.data_s* %5, !dbg !223
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @t3(i64 noundef %0) #0 !dbg !224 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !225, metadata !DIExpression()), !dbg !226
  %3 = load i64, i64* %2, align 8, !dbg !227
  call void @queue_clean(i64 noundef %3), !dbg !228
  ret void, !dbg !229
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_clean(i64 noundef %0) #0 !dbg !230 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !231, metadata !DIExpression()), !dbg !232
  %3 = load i64, i64* %2, align 8, !dbg !233
  call void @ismr_recycle(i64 noundef %3), !dbg !234
  ret void, !dbg !235
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @verify() #0 !dbg !236 {
  %1 = load i64, i64* @g_len, align 8, !dbg !239
  switch i64 %1, label %78 [
    i64 2, label %2
    i64 1, label %13
    i64 0, label %53
  ], !dbg !240

2:                                                ; preds = %0
  %3 = load %struct.data_s*, %struct.data_s** @deq_1, align 8, !dbg !241
  %4 = icmp ne %struct.data_s* %3, null, !dbg !241
  br i1 %4, label %6, label %5, !dbg !245

5:                                                ; preds = %2
  br label %7, !dbg !245

6:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 39, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !241
  unreachable, !dbg !241

7:                                                ; preds = %5
  %8 = load %struct.data_s*, %struct.data_s** @deq_2, align 8, !dbg !246
  %9 = icmp ne %struct.data_s* %8, null, !dbg !246
  br i1 %9, label %11, label %10, !dbg !249

10:                                               ; preds = %7
  br label %12, !dbg !249

11:                                               ; preds = %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 40, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !246
  unreachable, !dbg !246

12:                                               ; preds = %10
  br label %79, !dbg !250

13:                                               ; preds = %0
  %14 = load %struct.data_s*, %struct.data_s** @deq_1, align 8, !dbg !251
  %15 = icmp ne %struct.data_s* %14, null, !dbg !251
  br i1 %15, label %16, label %29, !dbg !253

16:                                               ; preds = %13
  %17 = load %struct.data_s*, %struct.data_s** @deq_1, align 8, !dbg !254
  %18 = getelementptr inbounds %struct.data_s, %struct.data_s* %17, i32 0, i32 0, !dbg !254
  %19 = load i64, i64* %18, align 8, !dbg !254
  %20 = icmp eq i64 %19, 1, !dbg !254
  br i1 %20, label %21, label %22, !dbg !258

21:                                               ; preds = %16
  br label %23, !dbg !258

22:                                               ; preds = %16
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 44, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !254
  unreachable, !dbg !254

23:                                               ; preds = %21
  %24 = load %struct.data_s*, %struct.data_s** @deq_2, align 8, !dbg !259
  %25 = icmp ne %struct.data_s* %24, null, !dbg !259
  br i1 %25, label %27, label %26, !dbg !262

26:                                               ; preds = %23
  br label %28, !dbg !262

27:                                               ; preds = %23
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 45, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !259
  unreachable, !dbg !259

28:                                               ; preds = %26
  br label %47, !dbg !263

29:                                               ; preds = %13
  %30 = load %struct.data_s*, %struct.data_s** @deq_2, align 8, !dbg !264
  %31 = icmp ne %struct.data_s* %30, null, !dbg !264
  br i1 %31, label %32, label %45, !dbg !266

32:                                               ; preds = %29
  %33 = load %struct.data_s*, %struct.data_s** @deq_2, align 8, !dbg !267
  %34 = getelementptr inbounds %struct.data_s, %struct.data_s* %33, i32 0, i32 0, !dbg !267
  %35 = load i64, i64* %34, align 8, !dbg !267
  %36 = icmp eq i64 %35, 1, !dbg !267
  br i1 %36, label %37, label %38, !dbg !271

37:                                               ; preds = %32
  br label %39, !dbg !271

38:                                               ; preds = %32
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 47, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !267
  unreachable, !dbg !267

39:                                               ; preds = %37
  %40 = load %struct.data_s*, %struct.data_s** @deq_1, align 8, !dbg !272
  %41 = icmp ne %struct.data_s* %40, null, !dbg !272
  br i1 %41, label %43, label %42, !dbg !275

42:                                               ; preds = %39
  br label %44, !dbg !275

43:                                               ; preds = %39
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 48, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !272
  unreachable, !dbg !272

44:                                               ; preds = %42
  br label %46, !dbg !276

45:                                               ; preds = %29
  call void @__assert_fail(i8* noundef getelementptr inbounds ([83 x i8], [83 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 52, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !277
  unreachable, !dbg !277

46:                                               ; preds = %44
  br label %47

47:                                               ; preds = %46, %28
  %48 = load i64, i64* getelementptr inbounds ([5 x i64], [5 x i64]* @g_final_state, i64 0, i64 0), align 16, !dbg !281
  %49 = icmp eq i64 %48, 2, !dbg !281
  br i1 %49, label %50, label %51, !dbg !284

50:                                               ; preds = %47
  br label %52, !dbg !284

51:                                               ; preds = %47
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 54, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !281
  unreachable, !dbg !281

52:                                               ; preds = %50
  br label %79, !dbg !285

53:                                               ; preds = %0
  %54 = load %struct.data_s*, %struct.data_s** @deq_1, align 8, !dbg !286
  %55 = icmp ne %struct.data_s* %54, null, !dbg !286
  br i1 %55, label %56, label %57, !dbg !289

56:                                               ; preds = %53
  br label %58, !dbg !289

57:                                               ; preds = %53
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.7, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 57, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !286
  unreachable, !dbg !286

58:                                               ; preds = %56
  %59 = load %struct.data_s*, %struct.data_s** @deq_2, align 8, !dbg !290
  %60 = icmp ne %struct.data_s* %59, null, !dbg !290
  br i1 %60, label %61, label %62, !dbg !293

61:                                               ; preds = %58
  br label %63, !dbg !293

62:                                               ; preds = %58
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.8, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 58, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !290
  unreachable, !dbg !290

63:                                               ; preds = %61
  %64 = load %struct.data_s*, %struct.data_s** @deq_1, align 8, !dbg !294
  %65 = getelementptr inbounds %struct.data_s, %struct.data_s* %64, i32 0, i32 0, !dbg !294
  %66 = load i64, i64* %65, align 8, !dbg !294
  %67 = icmp eq i64 %66, 1, !dbg !294
  br i1 %67, label %68, label %69, !dbg !297

68:                                               ; preds = %63
  br label %70, !dbg !297

69:                                               ; preds = %63
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 60, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !294
  unreachable, !dbg !294

70:                                               ; preds = %68
  %71 = load %struct.data_s*, %struct.data_s** @deq_2, align 8, !dbg !298
  %72 = getelementptr inbounds %struct.data_s, %struct.data_s* %71, i32 0, i32 0, !dbg !298
  %73 = load i64, i64* %72, align 8, !dbg !298
  %74 = icmp eq i64 %73, 2, !dbg !298
  br i1 %74, label %75, label %76, !dbg !301

75:                                               ; preds = %70
  br label %77, !dbg !301

76:                                               ; preds = %70
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 61, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !298
  unreachable, !dbg !298

77:                                               ; preds = %75
  br label %79, !dbg !302

78:                                               ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([33 x i8], [33 x i8]* @.str.10, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 64, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !303
  unreachable, !dbg !303

79:                                               ; preds = %77, %52, %12
  ret void, !dbg !306
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !307 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @init(), !dbg !310
  call void @launch_threads(i64 noundef 3, i8* (i8*)* noundef @run), !dbg !311
  call void @queue_print(%struct.vqueue_ub_s* noundef @g_queue, void (i8*)* noundef @get_final_state), !dbg !312
  call void @verify(), !dbg !313
  call void @destroy(), !dbg !314
  %2 = call zeroext i1 @vmem_no_leak(), !dbg !315
  br i1 %2, label %3, label %4, !dbg !318

3:                                                ; preds = %0
  br label %5, !dbg !318

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.12, i64 0, i64 0), i32 noundef 58, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !315
  unreachable, !dbg !315

5:                                                ; preds = %3
  ret i32 0, !dbg !319
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !320 {
  call void @queue_init(%struct.vqueue_ub_s* noundef @g_queue), !dbg !321
  call void @queue_register(i64 noundef 0, %struct.vqueue_ub_s* noundef @g_queue), !dbg !322
  call void @queue_deregister(i64 noundef 0, %struct.vqueue_ub_s* noundef @g_queue), !dbg !323
  ret void, !dbg !324
}

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !325 {
  %3 = alloca i64, align 8
  %4 = alloca i8* (i8*)*, align 8
  %5 = alloca %struct.run_info_t*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !328, metadata !DIExpression()), !dbg !329
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %4, metadata !330, metadata !DIExpression()), !dbg !331
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !332, metadata !DIExpression()), !dbg !333
  %6 = load i64, i64* %3, align 8, !dbg !334
  %7 = mul i64 32, %6, !dbg !335
  %8 = call noalias i8* @malloc(i64 noundef %7) #6, !dbg !336
  %9 = bitcast i8* %8 to %struct.run_info_t*, !dbg !336
  store %struct.run_info_t* %9, %struct.run_info_t** %5, align 8, !dbg !333
  %10 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !337
  %11 = load i64, i64* %3, align 8, !dbg !338
  %12 = load i8* (i8*)*, i8* (i8*)** %4, align 8, !dbg !339
  call void @create_threads(%struct.run_info_t* noundef %10, i64 noundef %11, i8* (i8*)* noundef %12, i1 noundef zeroext true), !dbg !340
  %13 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !341
  %14 = load i64, i64* %3, align 8, !dbg !342
  call void @await_threads(%struct.run_info_t* noundef %13, i64 noundef %14), !dbg !343
  %15 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !344
  %16 = bitcast %struct.run_info_t* %15 to i8*, !dbg !344
  call void @free(i8* noundef %16) #6, !dbg !345
  ret void, !dbg !346
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !347 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !348, metadata !DIExpression()), !dbg !349
  call void @llvm.dbg.declare(metadata i64* %3, metadata !350, metadata !DIExpression()), !dbg !351
  %4 = load i8*, i8** %2, align 8, !dbg !352
  %5 = ptrtoint i8* %4 to i64, !dbg !353
  store i64 %5, i64* %3, align 8, !dbg !351
  %6 = load i64, i64* %3, align 8, !dbg !354
  call void @queue_register(i64 noundef %6, %struct.vqueue_ub_s* noundef @g_queue), !dbg !355
  %7 = load i64, i64* %3, align 8, !dbg !356
  switch i64 %7, label %14 [
    i64 0, label %8
    i64 1, label %10
    i64 2, label %12
  ], !dbg !357

8:                                                ; preds = %1
  %9 = load i64, i64* %3, align 8, !dbg !358
  call void @t1(i64 noundef %9), !dbg !360
  br label %18, !dbg !361

10:                                               ; preds = %1
  %11 = load i64, i64* %3, align 8, !dbg !362
  call void @t2(i64 noundef %11), !dbg !363
  br label %18, !dbg !364

12:                                               ; preds = %1
  %13 = load i64, i64* %3, align 8, !dbg !365
  call void @t3(i64 noundef %13), !dbg !366
  br label %18, !dbg !367

14:                                               ; preds = %1
  br i1 true, label %15, label %16, !dbg !368

15:                                               ; preds = %14
  br label %17, !dbg !368

16:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([41 x i8], [41 x i8]* @.str.16, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.12, i64 0, i64 0), i32 noundef 141, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !370
  unreachable, !dbg !370

17:                                               ; preds = %15
  br label %18, !dbg !372

18:                                               ; preds = %17, %12, %10, %8
  %19 = load i64, i64* %3, align 8, !dbg !373
  call void @queue_deregister(i64 noundef %19, %struct.vqueue_ub_s* noundef @g_queue), !dbg !374
  ret i8* null, !dbg !375
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_print(%struct.vqueue_ub_s* noundef %0, void (i8*)* noundef %1) #0 !dbg !376 {
  %3 = alloca %struct.vqueue_ub_s*, align 8
  %4 = alloca void (i8*)*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %3, metadata !380, metadata !DIExpression()), !dbg !381
  store void (i8*)* %1, void (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata void (i8*)** %4, metadata !382, metadata !DIExpression()), !dbg !383
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %3, align 8, !dbg !384
  %6 = load void (i8*)*, void (i8*)** %4, align 8, !dbg !385
  %7 = bitcast void (i8*)* %6 to i8*, !dbg !386
  call void @_vqueue_ub_visit_nodes(%struct.vqueue_ub_s* noundef %5, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_redirect_print, i8* noundef %7), !dbg !387
  ret void, !dbg !388
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @get_final_state(i8* noundef %0) #0 !dbg !389 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.data_s*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !390, metadata !DIExpression()), !dbg !391
  %4 = load i8*, i8** %2, align 8, !dbg !392
  %5 = icmp ne i8* %4, null, !dbg !392
  br i1 %5, label %6, label %7, !dbg !395

6:                                                ; preds = %1
  br label %8, !dbg !395

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.13, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.12, i64 0, i64 0), i32 noundef 119, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.get_final_state, i64 0, i64 0)) #5, !dbg !392
  unreachable, !dbg !392

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata %struct.data_s** %3, metadata !396, metadata !DIExpression()), !dbg !397
  %9 = load i8*, i8** %2, align 8, !dbg !398
  %10 = bitcast i8* %9 to %struct.data_s*, !dbg !398
  store %struct.data_s* %10, %struct.data_s** %3, align 8, !dbg !397
  %11 = load i64, i64* @g_len, align 8, !dbg !399
  %12 = icmp ult i64 %11, 5, !dbg !399
  br i1 %12, label %13, label %14, !dbg !402

13:                                               ; preds = %8
  br label %15, !dbg !402

14:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.14, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.12, i64 0, i64 0), i32 noundef 121, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.get_final_state, i64 0, i64 0)) #5, !dbg !399
  unreachable, !dbg !399

15:                                               ; preds = %13
  %16 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !403
  %17 = getelementptr inbounds %struct.data_s, %struct.data_s* %16, i32 0, i32 0, !dbg !404
  %18 = load i64, i64* %17, align 8, !dbg !404
  %19 = load i64, i64* @g_len, align 8, !dbg !405
  %20 = add i64 %19, 1, !dbg !405
  store i64 %20, i64* @g_len, align 8, !dbg !405
  %21 = getelementptr inbounds [5 x i64], [5 x i64]* @g_final_state, i64 0, i64 %19, !dbg !406
  store i64 %18, i64* %21, align 8, !dbg !407
  ret void, !dbg !408
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @destroy() #0 !dbg !409 {
  call void @queue_destroy(%struct.vqueue_ub_s* noundef @g_queue), !dbg !410
  ret void, !dbg !411
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @vmem_no_leak() #0 !dbg !412 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !415, metadata !DIExpression()), !dbg !416
  %3 = call i64 @vmem_get_alloc_count(), !dbg !417
  store i64 %3, i64* %1, align 8, !dbg !416
  call void @llvm.dbg.declare(metadata i64* %2, metadata !418, metadata !DIExpression()), !dbg !419
  %4 = call i64 @vmem_get_free_count(), !dbg !420
  store i64 %4, i64* %2, align 8, !dbg !419
  %5 = load i64, i64* %1, align 8, !dbg !421
  %6 = load i64, i64* %2, align 8, !dbg !422
  %7 = icmp eq i64 %5, %6, !dbg !423
  ret i1 %7, !dbg !424
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_init(%struct.vqueue_ub_s* noundef %0) #0 !dbg !425 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !429, metadata !DIExpression()), !dbg !430
  call void @ismr_init(), !dbg !431
  %3 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !432
  call void @vqueue_ub_init(%struct.vqueue_ub_s* noundef %3), !dbg !433
  ret void, !dbg !434
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_register(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !435 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !438, metadata !DIExpression()), !dbg !439
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !440, metadata !DIExpression()), !dbg !441
  %5 = load i64, i64* %3, align 8, !dbg !442
  call void @ismr_reg(i64 noundef %5), !dbg !443
  br label %6, !dbg !444

6:                                                ; preds = %2
  br label %7, !dbg !445

7:                                                ; preds = %6
  %8 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !447
  br label %9, !dbg !447

9:                                                ; preds = %7
  br label %10, !dbg !449

10:                                               ; preds = %9
  br label %11, !dbg !447

11:                                               ; preds = %10
  br label %12, !dbg !445

12:                                               ; preds = %11
  ret void, !dbg !451
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_deregister(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !452 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !453, metadata !DIExpression()), !dbg !454
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !455, metadata !DIExpression()), !dbg !456
  %5 = load i64, i64* %3, align 8, !dbg !457
  call void @ismr_dereg(i64 noundef %5), !dbg !458
  br label %6, !dbg !459

6:                                                ; preds = %2
  br label %7, !dbg !460

7:                                                ; preds = %6
  %8 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !462
  br label %9, !dbg !462

9:                                                ; preds = %7
  br label %10, !dbg !464

10:                                               ; preds = %9
  br label %11, !dbg !462

11:                                               ; preds = %10
  br label %12, !dbg !460

12:                                               ; preds = %11
  ret void, !dbg !466
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_destroy(%struct.vqueue_ub_s* noundef %0) #0 !dbg !467 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !468, metadata !DIExpression()), !dbg !469
  call void @llvm.dbg.declare(metadata i8** %3, metadata !470, metadata !DIExpression()), !dbg !471
  store i8* null, i8** %3, align 8, !dbg !471
  br label %4, !dbg !472

4:                                                ; preds = %9, %1
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !473
  %6 = call i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %5, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_queue_destroy, i8* noundef null), !dbg !474
  store i8* %6, i8** %3, align 8, !dbg !475
  %7 = load i8*, i8** %3, align 8, !dbg !476
  %8 = icmp ne i8* %7, null, !dbg !472
  br i1 %8, label %9, label %11, !dbg !472

9:                                                ; preds = %4
  %10 = load i8*, i8** %3, align 8, !dbg !477
  call void @free(i8* noundef %10) #6, !dbg !479
  br label %4, !dbg !472, !llvm.loop !480

11:                                               ; preds = %4
  %12 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !483
  call void @vqueue_ub_destroy(%struct.vqueue_ub_s* noundef %12, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_queue_destroy, i8* noundef null), !dbg !484
  call void @ismr_destroy(), !dbg !485
  %13 = call zeroext i1 @vmem_no_leak(), !dbg !486
  br i1 %13, label %14, label %15, !dbg !489

14:                                               ; preds = %11
  br label %16, !dbg !489

15:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([97 x i8], [97 x i8]* @.str.21, i64 0, i64 0), i32 noundef 166, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.queue_destroy, i64 0, i64 0)) #5, !dbg !486
  unreachable, !dbg !486

16:                                               ; preds = %14
  ret void, !dbg !490
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_enq(i64 noundef %0, %struct.vqueue_ub_s* noundef %1, i64 noundef %2, i8 noundef signext %3) #0 !dbg !491 {
  %5 = alloca i64, align 8
  %6 = alloca %struct.vqueue_ub_s*, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  %9 = alloca %struct.data_s*, align 8
  %10 = alloca %struct.vqueue_ub_node_s*, align 8
  store i64 %0, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !494, metadata !DIExpression()), !dbg !495
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %6, metadata !496, metadata !DIExpression()), !dbg !497
  store i64 %2, i64* %7, align 8
  call void @llvm.dbg.declare(metadata i64* %7, metadata !498, metadata !DIExpression()), !dbg !499
  store i8 %3, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !500, metadata !DIExpression()), !dbg !501
  call void @llvm.dbg.declare(metadata %struct.data_s** %9, metadata !502, metadata !DIExpression()), !dbg !503
  %11 = call noalias i8* @malloc(i64 noundef 16) #6, !dbg !504
  %12 = bitcast i8* %11 to %struct.data_s*, !dbg !504
  store %struct.data_s* %12, %struct.data_s** %9, align 8, !dbg !503
  %13 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !505
  %14 = icmp ne %struct.data_s* %13, null, !dbg !505
  br i1 %14, label %15, label %30, !dbg !507

15:                                               ; preds = %4
  %16 = load i64, i64* %7, align 8, !dbg !508
  %17 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !510
  %18 = getelementptr inbounds %struct.data_s, %struct.data_s* %17, i32 0, i32 0, !dbg !511
  store i64 %16, i64* %18, align 8, !dbg !512
  %19 = load i8, i8* %8, align 1, !dbg !513
  %20 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !514
  %21 = getelementptr inbounds %struct.data_s, %struct.data_s* %20, i32 0, i32 1, !dbg !515
  store i8 %19, i8* %21, align 8, !dbg !516
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %10, metadata !517, metadata !DIExpression()), !dbg !520
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %10, align 8, !dbg !520
  %22 = call i8* @vmem_malloc(i64 noundef 16), !dbg !521
  %23 = bitcast i8* %22 to %struct.vqueue_ub_node_s*, !dbg !521
  store %struct.vqueue_ub_node_s* %23, %struct.vqueue_ub_node_s** %10, align 8, !dbg !522
  %24 = load i64, i64* %5, align 8, !dbg !523
  call void @ismr_enter(i64 noundef %24), !dbg !524
  %25 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %6, align 8, !dbg !525
  %26 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !526
  %27 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !527
  %28 = bitcast %struct.data_s* %27 to i8*, !dbg !527
  call void @vqueue_ub_enq(%struct.vqueue_ub_s* noundef %25, %struct.vqueue_ub_node_s* noundef %26, i8* noundef %28), !dbg !528
  %29 = load i64, i64* %5, align 8, !dbg !529
  call void @ismr_exit(i64 noundef %29), !dbg !530
  br label %31, !dbg !531

30:                                               ; preds = %4
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.20, i64 0, i64 0), i8* noundef getelementptr inbounds ([97 x i8], [97 x i8]* @.str.21, i64 0, i64 0), i32 noundef 196, i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @__PRETTY_FUNCTION__.queue_enq, i64 0, i64 0)) #5, !dbg !532
  unreachable, !dbg !532

31:                                               ; preds = %15
  ret void, !dbg !536
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @queue_deq(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !537 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca i8*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !540, metadata !DIExpression()), !dbg !541
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !542, metadata !DIExpression()), !dbg !543
  %6 = load i64, i64* %3, align 8, !dbg !544
  call void @ismr_enter(i64 noundef %6), !dbg !545
  call void @llvm.dbg.declare(metadata i8** %5, metadata !546, metadata !DIExpression()), !dbg !547
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !548
  %8 = load i64, i64* %3, align 8, !dbg !549
  %9 = inttoptr i64 %8 to i8*, !dbg !550
  %10 = call i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %7, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_queue_retire, i8* noundef %9), !dbg !551
  store i8* %10, i8** %5, align 8, !dbg !547
  %11 = load i64, i64* %3, align 8, !dbg !552
  call void @ismr_exit(i64 noundef %11), !dbg !553
  %12 = load i8*, i8** %5, align 8, !dbg !554
  ret i8* %12, !dbg !555
}

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @empty(i64 noundef %0) #0 !dbg !556 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !559, metadata !DIExpression()), !dbg !560
  %3 = load i64, i64* %2, align 8, !dbg !561
  %4 = call zeroext i1 @queue_empty(i64 noundef %3, %struct.vqueue_ub_s* noundef @g_queue), !dbg !562
  ret i1 %4, !dbg !563
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @queue_empty(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !564 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca i8, align 1
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !567, metadata !DIExpression()), !dbg !568
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !569, metadata !DIExpression()), !dbg !570
  %6 = load i64, i64* %3, align 8, !dbg !571
  call void @ismr_enter(i64 noundef %6), !dbg !572
  call void @llvm.dbg.declare(metadata i8* %5, metadata !573, metadata !DIExpression()), !dbg !574
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !575
  %8 = call zeroext i1 @vqueue_ub_empty(%struct.vqueue_ub_s* noundef %7), !dbg !576
  %9 = zext i1 %8 to i8, !dbg !574
  store i8 %9, i8* %5, align 1, !dbg !574
  %10 = load i64, i64* %3, align 8, !dbg !577
  call void @ismr_exit(i64 noundef %10), !dbg !578
  %11 = load i8, i8* %5, align 1, !dbg !579
  %12 = trunc i8 %11 to i1, !dbg !579
  ret i1 %12, !dbg !580
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_recycle(i64 noundef %0) #0 !dbg !581 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !582, metadata !DIExpression()), !dbg !583
  br label %3, !dbg !584

3:                                                ; preds = %1
  br label %4, !dbg !585

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !587
  br label %6, !dbg !587

6:                                                ; preds = %4
  br label %7, !dbg !589

7:                                                ; preds = %6
  br label %8, !dbg !587

8:                                                ; preds = %7
  br label %9, !dbg !585

9:                                                ; preds = %8
  ret void, !dbg !591
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !592 {
  %5 = alloca %struct.run_info_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8* (i8*)*, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !595, metadata !DIExpression()), !dbg !596
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !597, metadata !DIExpression()), !dbg !598
  store i8* (i8*)* %2, i8* (i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %7, metadata !599, metadata !DIExpression()), !dbg !600
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !601, metadata !DIExpression()), !dbg !602
  call void @llvm.dbg.declare(metadata i64* %9, metadata !603, metadata !DIExpression()), !dbg !604
  store i64 0, i64* %9, align 8, !dbg !604
  store i64 0, i64* %9, align 8, !dbg !605
  br label %11, !dbg !607

11:                                               ; preds = %42, %4
  %12 = load i64, i64* %9, align 8, !dbg !608
  %13 = load i64, i64* %6, align 8, !dbg !610
  %14 = icmp ult i64 %12, %13, !dbg !611
  br i1 %14, label %15, label %45, !dbg !612

15:                                               ; preds = %11
  %16 = load i64, i64* %9, align 8, !dbg !613
  %17 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !615
  %18 = load i64, i64* %9, align 8, !dbg !616
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %17, i64 %18, !dbg !615
  %20 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %19, i32 0, i32 1, !dbg !617
  store i64 %16, i64* %20, align 8, !dbg !618
  %21 = load i8* (i8*)*, i8* (i8*)** %7, align 8, !dbg !619
  %22 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !620
  %23 = load i64, i64* %9, align 8, !dbg !621
  %24 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %22, i64 %23, !dbg !620
  %25 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %24, i32 0, i32 3, !dbg !622
  store i8* (i8*)* %21, i8* (i8*)** %25, align 8, !dbg !623
  %26 = load i8, i8* %8, align 1, !dbg !624
  %27 = trunc i8 %26 to i1, !dbg !624
  %28 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !625
  %29 = load i64, i64* %9, align 8, !dbg !626
  %30 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %28, i64 %29, !dbg !625
  %31 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %30, i32 0, i32 2, !dbg !627
  %32 = zext i1 %27 to i8, !dbg !628
  store i8 %32, i8* %31, align 8, !dbg !628
  %33 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !629
  %34 = load i64, i64* %9, align 8, !dbg !630
  %35 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %33, i64 %34, !dbg !629
  %36 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %35, i32 0, i32 0, !dbg !631
  %37 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !632
  %38 = load i64, i64* %9, align 8, !dbg !633
  %39 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %37, i64 %38, !dbg !632
  %40 = bitcast %struct.run_info_t* %39 to i8*, !dbg !634
  %41 = call i32 @pthread_create(i64* noundef %36, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %40) #6, !dbg !635
  br label %42, !dbg !636

42:                                               ; preds = %15
  %43 = load i64, i64* %9, align 8, !dbg !637
  %44 = add i64 %43, 1, !dbg !637
  store i64 %44, i64* %9, align 8, !dbg !637
  br label %11, !dbg !638, !llvm.loop !639

45:                                               ; preds = %11
  ret void, !dbg !641
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !642 {
  %3 = alloca %struct.run_info_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !645, metadata !DIExpression()), !dbg !646
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !647, metadata !DIExpression()), !dbg !648
  call void @llvm.dbg.declare(metadata i64* %5, metadata !649, metadata !DIExpression()), !dbg !650
  store i64 0, i64* %5, align 8, !dbg !650
  store i64 0, i64* %5, align 8, !dbg !651
  br label %6, !dbg !653

6:                                                ; preds = %17, %2
  %7 = load i64, i64* %5, align 8, !dbg !654
  %8 = load i64, i64* %4, align 8, !dbg !656
  %9 = icmp ult i64 %7, %8, !dbg !657
  br i1 %9, label %10, label %20, !dbg !658

10:                                               ; preds = %6
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !659
  %12 = load i64, i64* %5, align 8, !dbg !661
  %13 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i64 %12, !dbg !659
  %14 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %13, i32 0, i32 0, !dbg !662
  %15 = load i64, i64* %14, align 8, !dbg !662
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !663
  br label %17, !dbg !664

17:                                               ; preds = %10
  %18 = load i64, i64* %5, align 8, !dbg !665
  %19 = add i64 %18, 1, !dbg !665
  store i64 %19, i64* %5, align 8, !dbg !665
  br label %6, !dbg !666, !llvm.loop !667

20:                                               ; preds = %6
  ret void, !dbg !669
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !670 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.run_info_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !671, metadata !DIExpression()), !dbg !672
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !673, metadata !DIExpression()), !dbg !674
  %4 = load i8*, i8** %2, align 8, !dbg !675
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !676
  store %struct.run_info_t* %5, %struct.run_info_t** %3, align 8, !dbg !674
  %6 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !677
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %6, i32 0, i32 2, !dbg !679
  %8 = load i8, i8* %7, align 8, !dbg !679
  %9 = trunc i8 %8 to i1, !dbg !679
  br i1 %9, label %10, label %14, !dbg !680

10:                                               ; preds = %1
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !681
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i32 0, i32 1, !dbg !682
  %13 = load i64, i64* %12, align 8, !dbg !682
  call void @set_cpu_affinity(i64 noundef %13), !dbg !683
  br label %14, !dbg !683

14:                                               ; preds = %10, %1
  %15 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !684
  %16 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %15, i32 0, i32 3, !dbg !685
  %17 = load i8* (i8*)*, i8* (i8*)** %16, align 8, !dbg !685
  %18 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !686
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %18, i32 0, i32 1, !dbg !687
  %20 = load i64, i64* %19, align 8, !dbg !687
  %21 = inttoptr i64 %20 to i8*, !dbg !688
  %22 = call i8* %17(i8* noundef %21), !dbg !684
  ret i8* %22, !dbg !689
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !690 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !691, metadata !DIExpression()), !dbg !692
  br label %3, !dbg !693

3:                                                ; preds = %1
  br label %4, !dbg !694

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !696
  br label %6, !dbg !696

6:                                                ; preds = %4
  br label %7, !dbg !698

7:                                                ; preds = %6
  br label %8, !dbg !696

8:                                                ; preds = %7
  br label %9, !dbg !694

9:                                                ; preds = %8
  ret void, !dbg !700
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @_vqueue_ub_visit_nodes(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !701 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !710, metadata !DIExpression()), !dbg !711
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !712, metadata !DIExpression()), !dbg !713
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !714, metadata !DIExpression()), !dbg !715
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !716, metadata !DIExpression()), !dbg !717
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !717
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !718, metadata !DIExpression()), !dbg !719
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !719
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !720
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 2, !dbg !721
  %11 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !721
  store %struct.vqueue_ub_node_s* %11, %struct.vqueue_ub_node_s** %7, align 8, !dbg !722
  %12 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !723
  %13 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %12, i32 0, i32 1, !dbg !724
  %14 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %13), !dbg !725
  %15 = bitcast i8* %14 to %struct.vqueue_ub_node_s*, !dbg !726
  store %struct.vqueue_ub_node_s* %15, %struct.vqueue_ub_node_s** %7, align 8, !dbg !727
  br label %16, !dbg !728

16:                                               ; preds = %19, %3
  %17 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !729
  %18 = icmp ne %struct.vqueue_ub_node_s* %17, null, !dbg !728
  br i1 %18, label %19, label %28, !dbg !728

19:                                               ; preds = %16
  %20 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !730
  %21 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %20, i32 0, i32 1, !dbg !732
  %22 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %21), !dbg !733
  %23 = bitcast i8* %22 to %struct.vqueue_ub_node_s*, !dbg !734
  store %struct.vqueue_ub_node_s* %23, %struct.vqueue_ub_node_s** %8, align 8, !dbg !735
  %24 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !736
  %25 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !737
  %26 = load i8*, i8** %6, align 8, !dbg !738
  call void %24(%struct.vqueue_ub_node_s* noundef %25, i8* noundef %26), !dbg !736
  %27 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !739
  store %struct.vqueue_ub_node_s* %27, %struct.vqueue_ub_node_s** %7, align 8, !dbg !740
  br label %16, !dbg !728, !llvm.loop !741

28:                                               ; preds = %16
  ret void, !dbg !743
}

; Function Attrs: noinline nounwind uwtable
define internal void @_redirect_print(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !744 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca void (i8*)*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !747, metadata !DIExpression()), !dbg !748
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !749, metadata !DIExpression()), !dbg !750
  call void @llvm.dbg.declare(metadata void (i8*)** %5, metadata !751, metadata !DIExpression()), !dbg !752
  %6 = load i8*, i8** %4, align 8, !dbg !753
  %7 = bitcast i8* %6 to void (i8*)*, !dbg !754
  store void (i8*)* %7, void (i8*)** %5, align 8, !dbg !752
  %8 = load void (i8*)*, void (i8*)** %5, align 8, !dbg !755
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !756
  %10 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %9, i32 0, i32 0, !dbg !757
  %11 = load i8*, i8** %10, align 8, !dbg !757
  call void %8(i8* noundef %11), !dbg !755
  ret void, !dbg !758
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !759 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !765, metadata !DIExpression()), !dbg !766
  call void @llvm.dbg.declare(metadata i8** %3, metadata !767, metadata !DIExpression()), !dbg !768
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !769
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !770
  %6 = load i8*, i8** %5, align 8, !dbg !770
  %7 = call i8* asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !771, !srcloc !772
  store i8* %7, i8** %3, align 8, !dbg !771
  %8 = load i8*, i8** %3, align 8, !dbg !773
  ret i8* %8, !dbg !774
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vmem_get_alloc_count() #0 !dbg !775 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !778, metadata !DIExpression()), !dbg !779
  %2 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef @_g_vmem_alloc_count), !dbg !780
  store i64 %2, i64* %1, align 8, !dbg !779
  br label %3, !dbg !781

3:                                                ; preds = %0
  br label %4, !dbg !782

4:                                                ; preds = %3
  %5 = load i64, i64* %1, align 8, !dbg !784
  br label %6, !dbg !784

6:                                                ; preds = %4
  br label %7, !dbg !786

7:                                                ; preds = %6
  br label %8, !dbg !784

8:                                                ; preds = %7
  br label %9, !dbg !782

9:                                                ; preds = %8
  %10 = load i64, i64* %1, align 8, !dbg !788
  ret i64 %10, !dbg !789
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vmem_get_free_count() #0 !dbg !790 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !791, metadata !DIExpression()), !dbg !792
  %2 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef @_g_vmem_free_count), !dbg !793
  store i64 %2, i64* %1, align 8, !dbg !792
  br label %3, !dbg !794

3:                                                ; preds = %0
  br label %4, !dbg !795

4:                                                ; preds = %3
  %5 = load i64, i64* %1, align 8, !dbg !797
  br label %6, !dbg !797

6:                                                ; preds = %4
  br label %7, !dbg !799

7:                                                ; preds = %6
  br label %8, !dbg !797

8:                                                ; preds = %7
  br label %9, !dbg !795

9:                                                ; preds = %8
  %10 = load i64, i64* %1, align 8, !dbg !801
  ret i64 %10, !dbg !802
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !803 {
  %2 = alloca %struct.vatomic64_s*, align 8
  %3 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !808, metadata !DIExpression()), !dbg !809
  call void @llvm.dbg.declare(metadata i64* %3, metadata !810, metadata !DIExpression()), !dbg !811
  %4 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !812
  %5 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %4, i32 0, i32 0, !dbg !813
  %6 = load i64, i64* %5, align 8, !dbg !813
  %7 = call i64 asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i64 %6) #6, !dbg !814, !srcloc !815
  store i64 %7, i64* %3, align 8, !dbg !814
  %8 = load i64, i64* %3, align 8, !dbg !816
  ret i64 %8, !dbg !817
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_init() #0 !dbg !818 {
  call void @locked_trace_init(%struct.locked_trace_s* noundef @global_trace, i64 noundef 100), !dbg !819
  ret void, !dbg !820
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_init(%struct.vqueue_ub_s* noundef %0) #0 !dbg !821 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !824, metadata !DIExpression()), !dbg !825
  %3 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !826
  %4 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %3, i32 0, i32 4, !dbg !827
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !828
  %6 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %5, i32 0, i32 2, !dbg !829
  store %struct.vqueue_ub_node_s* %4, %struct.vqueue_ub_node_s** %6, align 8, !dbg !830
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !831
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 4, !dbg !832
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !833
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 3, !dbg !834
  store %struct.vqueue_ub_node_s* %8, %struct.vqueue_ub_node_s** %10, align 8, !dbg !835
  %11 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !836
  %12 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %11, i32 0, i32 4, !dbg !837
  call void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %12, i8* noundef null), !dbg !838
  %13 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !839
  %14 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %13, i32 0, i32 0, !dbg !840
  call void @queue_lock_init(%union.pthread_mutex_t* noundef %14), !dbg !841
  %15 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !842
  %16 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %15, i32 0, i32 1, !dbg !843
  call void @queue_lock_init(%union.pthread_mutex_t* noundef %16), !dbg !844
  ret void, !dbg !845
}

; Function Attrs: noinline nounwind uwtable
define internal void @locked_trace_init(%struct.locked_trace_s* noundef %0, i64 noundef %1) #0 !dbg !846 {
  %3 = alloca %struct.locked_trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.locked_trace_s* %0, %struct.locked_trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.locked_trace_s** %3, metadata !850, metadata !DIExpression()), !dbg !851
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !852, metadata !DIExpression()), !dbg !853
  %5 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !854
  %6 = icmp ne %struct.locked_trace_s* %5, null, !dbg !854
  br i1 %6, label %7, label %8, !dbg !857

7:                                                ; preds = %2
  br label %9, !dbg !857

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.17, i64 0, i64 0), i8* noundef getelementptr inbounds ([64 x i8], [64 x i8]* @.str.18, i64 0, i64 0), i32 noundef 16, i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @__PRETTY_FUNCTION__.locked_trace_init, i64 0, i64 0)) #5, !dbg !854
  unreachable, !dbg !854

9:                                                ; preds = %7
  %10 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !858
  %11 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %10, i32 0, i32 1, !dbg !859
  %12 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %11, %union.pthread_mutexattr_t* noundef null) #6, !dbg !860
  %13 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !861
  %14 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %13, i32 0, i32 0, !dbg !862
  %15 = load i64, i64* %4, align 8, !dbg !863
  call void @trace_init(%struct.trace_s* noundef %14, i64 noundef %15), !dbg !864
  ret void, !dbg !865
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @trace_init(%struct.trace_s* noundef %0, i64 noundef %1) #0 !dbg !866 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !870, metadata !DIExpression()), !dbg !871
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !872, metadata !DIExpression()), !dbg !873
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !874
  %6 = icmp ne %struct.trace_s* %5, null, !dbg !874
  br i1 %6, label %7, label %8, !dbg !877

7:                                                ; preds = %2
  br label %9, !dbg !877

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.17, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.19, i64 0, i64 0), i32 noundef 30, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !874
  unreachable, !dbg !874

9:                                                ; preds = %7
  %10 = load i64, i64* %4, align 8, !dbg !878
  %11 = mul i64 %10, 16, !dbg !879
  %12 = call noalias i8* @malloc(i64 noundef %11) #6, !dbg !880
  %13 = bitcast i8* %12 to %struct.trace_unit_s*, !dbg !880
  %14 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !881
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 0, !dbg !882
  store %struct.trace_unit_s* %13, %struct.trace_unit_s** %15, align 8, !dbg !883
  %16 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !884
  %17 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %16, i32 0, i32 0, !dbg !886
  %18 = load %struct.trace_unit_s*, %struct.trace_unit_s** %17, align 8, !dbg !886
  %19 = icmp ne %struct.trace_unit_s* %18, null, !dbg !884
  br i1 %19, label %20, label %28, !dbg !887

20:                                               ; preds = %9
  %21 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !888
  %22 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %21, i32 0, i32 1, !dbg !890
  store i64 0, i64* %22, align 8, !dbg !891
  %23 = load i64, i64* %4, align 8, !dbg !892
  %24 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !893
  %25 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %24, i32 0, i32 2, !dbg !894
  store i64 %23, i64* %25, align 8, !dbg !895
  %26 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !896
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 3, !dbg !897
  store i8 1, i8* %27, align 8, !dbg !898
  br label %35, !dbg !899

28:                                               ; preds = %9
  %29 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !900
  %30 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %29, i32 0, i32 1, !dbg !902
  store i64 0, i64* %30, align 8, !dbg !903
  %31 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !904
  %32 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %31, i32 0, i32 2, !dbg !905
  store i64 0, i64* %32, align 8, !dbg !906
  %33 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !907
  %34 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %33, i32 0, i32 3, !dbg !908
  store i8 0, i8* %34, align 8, !dbg !909
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.20, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.19, i64 0, i64 0), i32 noundef 40, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !910
  unreachable, !dbg !910

35:                                               ; preds = %20
  ret void, !dbg !913
}

; Function Attrs: noinline nounwind uwtable
define internal void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !914 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !915, metadata !DIExpression()), !dbg !916
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !917, metadata !DIExpression()), !dbg !918
  %5 = load i8*, i8** %4, align 8, !dbg !919
  %6 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !920
  %7 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %6, i32 0, i32 0, !dbg !921
  store i8* %5, i8** %7, align 8, !dbg !922
  %8 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !923
  %9 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %8, i32 0, i32 1, !dbg !924
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %9, i8* noundef null), !dbg !925
  ret void, !dbg !926
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_init(%union.pthread_mutex_t* noundef %0) #0 !dbg !927 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !931, metadata !DIExpression()), !dbg !932
  %3 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !932
  %4 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %3, %union.pthread_mutexattr_t* noundef null) #6, !dbg !932
  ret void, !dbg !932
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !933 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !937, metadata !DIExpression()), !dbg !938
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !939, metadata !DIExpression()), !dbg !940
  %5 = load i8*, i8** %4, align 8, !dbg !941
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !942
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !943
  %8 = load i8*, i8** %7, align 8, !dbg !943
  call void asm sideeffect "str ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !944, !srcloc !945
  ret void, !dbg !946
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_reg(i64 noundef %0) #0 !dbg !947 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !948, metadata !DIExpression()), !dbg !949
  br label %3, !dbg !950

3:                                                ; preds = %1
  br label %4, !dbg !951

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !953
  br label %6, !dbg !953

6:                                                ; preds = %4
  br label %7, !dbg !955

7:                                                ; preds = %6
  br label %8, !dbg !953

8:                                                ; preds = %7
  br label %9, !dbg !951

9:                                                ; preds = %8
  ret void, !dbg !957
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_dereg(i64 noundef %0) #0 !dbg !958 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !959, metadata !DIExpression()), !dbg !960
  br label %3, !dbg !961

3:                                                ; preds = %1
  br label %4, !dbg !962

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !964
  br label %6, !dbg !964

6:                                                ; preds = %4
  br label %7, !dbg !966

7:                                                ; preds = %6
  br label %8, !dbg !964

8:                                                ; preds = %7
  br label %9, !dbg !962

9:                                                ; preds = %8
  ret void, !dbg !968
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !969 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  %9 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !972, metadata !DIExpression()), !dbg !973
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !974, metadata !DIExpression()), !dbg !975
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !976, metadata !DIExpression()), !dbg !977
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !978, metadata !DIExpression()), !dbg !979
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !979
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !980, metadata !DIExpression()), !dbg !981
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !981
  call void @llvm.dbg.declare(metadata i8** %9, metadata !982, metadata !DIExpression()), !dbg !983
  store i8* null, i8** %9, align 8, !dbg !983
  %10 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !984
  %11 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %10, i32 0, i32 1, !dbg !985
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %11), !dbg !986
  %12 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !987
  %13 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %12, i32 0, i32 2, !dbg !988
  %14 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %13, align 8, !dbg !988
  store %struct.vqueue_ub_node_s* %14, %struct.vqueue_ub_node_s** %8, align 8, !dbg !989
  %15 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !990
  %16 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %15, i32 0, i32 1, !dbg !991
  %17 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %16), !dbg !992
  %18 = bitcast i8* %17 to %struct.vqueue_ub_node_s*, !dbg !993
  store %struct.vqueue_ub_node_s* %18, %struct.vqueue_ub_node_s** %7, align 8, !dbg !994
  %19 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !995
  %20 = icmp ne %struct.vqueue_ub_node_s* %19, null, !dbg !995
  br i1 %20, label %21, label %37, !dbg !997

21:                                               ; preds = %3
  %22 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !998
  %23 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %22, i32 0, i32 0, !dbg !1000
  %24 = load i8*, i8** %23, align 8, !dbg !1000
  store i8* %24, i8** %9, align 8, !dbg !1001
  %25 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1002
  %26 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1003
  %27 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %26, i32 0, i32 2, !dbg !1004
  store %struct.vqueue_ub_node_s* %25, %struct.vqueue_ub_node_s** %27, align 8, !dbg !1005
  %28 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1006
  %29 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1008
  %30 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %29, i32 0, i32 4, !dbg !1009
  %31 = icmp ne %struct.vqueue_ub_node_s* %28, %30, !dbg !1010
  br i1 %31, label %32, label %36, !dbg !1011

32:                                               ; preds = %21
  %33 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !1012
  %34 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1014
  %35 = load i8*, i8** %6, align 8, !dbg !1015
  call void %33(%struct.vqueue_ub_node_s* noundef %34, i8* noundef %35), !dbg !1012
  br label %36, !dbg !1016

36:                                               ; preds = %32, %21
  br label %37, !dbg !1017

37:                                               ; preds = %36, %3
  %38 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1018
  %39 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %38, i32 0, i32 1, !dbg !1019
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %39), !dbg !1020
  %40 = load i8*, i8** %9, align 8, !dbg !1021
  ret i8* %40, !dbg !1022
}

; Function Attrs: noinline nounwind uwtable
define internal void @_queue_destroy(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !1023 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1026, metadata !DIExpression()), !dbg !1027
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1028, metadata !DIExpression()), !dbg !1029
  %5 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1030
  %6 = bitcast %struct.vqueue_ub_node_s* %5 to i8*, !dbg !1030
  call void @vmem_free(i8* noundef %6), !dbg !1031
  br label %7, !dbg !1032

7:                                                ; preds = %2
  br label %8, !dbg !1033

8:                                                ; preds = %7
  %9 = load i8*, i8** %4, align 8, !dbg !1035
  br label %10, !dbg !1035

10:                                               ; preds = %8
  br label %11, !dbg !1037

11:                                               ; preds = %10
  br label %12, !dbg !1035

12:                                               ; preds = %11
  br label %13, !dbg !1033

13:                                               ; preds = %12
  ret void, !dbg !1039
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_destroy(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !1040 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !1041, metadata !DIExpression()), !dbg !1042
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !1043, metadata !DIExpression()), !dbg !1044
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !1045, metadata !DIExpression()), !dbg !1046
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !1047, metadata !DIExpression()), !dbg !1048
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1048
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !1049, metadata !DIExpression()), !dbg !1050
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1050
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1051
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 2, !dbg !1052
  %11 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !1052
  store %struct.vqueue_ub_node_s* %11, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1053
  br label %12, !dbg !1054

12:                                               ; preds = %28, %3
  %13 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1055
  %14 = icmp ne %struct.vqueue_ub_node_s* %13, null, !dbg !1054
  br i1 %14, label %15, label %30, !dbg !1054

15:                                               ; preds = %12
  %16 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1056
  %17 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %16, i32 0, i32 1, !dbg !1058
  %18 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %17), !dbg !1059
  %19 = bitcast i8* %18 to %struct.vqueue_ub_node_s*, !dbg !1060
  store %struct.vqueue_ub_node_s* %19, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1061
  %20 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1062
  %21 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1064
  %22 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %21, i32 0, i32 4, !dbg !1065
  %23 = icmp ne %struct.vqueue_ub_node_s* %20, %22, !dbg !1066
  br i1 %23, label %24, label %28, !dbg !1067

24:                                               ; preds = %15
  %25 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !1068
  %26 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1070
  %27 = load i8*, i8** %6, align 8, !dbg !1071
  call void %25(%struct.vqueue_ub_node_s* noundef %26, i8* noundef %27), !dbg !1068
  br label %28, !dbg !1072

28:                                               ; preds = %24, %15
  %29 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1073
  store %struct.vqueue_ub_node_s* %29, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1074
  br label %12, !dbg !1054, !llvm.loop !1075

30:                                               ; preds = %12
  ret void, !dbg !1077
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_destroy() #0 !dbg !1078 {
  call void @locked_trace_destroy(%struct.locked_trace_s* noundef @global_trace, i1 (%struct.trace_unit_s*)* noundef @_ismr_none_destroy_all_cb), !dbg !1079
  ret void, !dbg !1080
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_acquire(%union.pthread_mutex_t* noundef %0) #0 !dbg !1081 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !1082, metadata !DIExpression()), !dbg !1083
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1084, metadata !DIExpression()), !dbg !1083
  %4 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !1083
  %5 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef %4) #6, !dbg !1083
  store i32 %5, i32* %3, align 4, !dbg !1083
  %6 = load i32, i32* %3, align 4, !dbg !1085
  %7 = icmp eq i32 %6, 0, !dbg !1085
  br i1 %7, label %8, label %9, !dbg !1088

8:                                                ; preds = %1
  br label %10, !dbg !1088

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.22, i64 0, i64 0), i8* noundef getelementptr inbounds ([101 x i8], [101 x i8]* @.str.23, i64 0, i64 0), i32 noundef 32, i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.queue_lock_acquire, i64 0, i64 0)) #5, !dbg !1085
  unreachable, !dbg !1085

10:                                               ; preds = %8
  ret void, !dbg !1083
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %0) #0 !dbg !1089 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !1090, metadata !DIExpression()), !dbg !1091
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1092, metadata !DIExpression()), !dbg !1093
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !1094
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !1095
  %6 = load i8*, i8** %5, align 8, !dbg !1095
  %7 = call i8* asm sideeffect "ldar ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !1096, !srcloc !1097
  store i8* %7, i8** %3, align 8, !dbg !1096
  %8 = load i8*, i8** %3, align 8, !dbg !1098
  ret i8* %8, !dbg !1099
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_release(%union.pthread_mutex_t* noundef %0) #0 !dbg !1100 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !1101, metadata !DIExpression()), !dbg !1102
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1103, metadata !DIExpression()), !dbg !1102
  %4 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !1102
  %5 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef %4) #6, !dbg !1102
  store i32 %5, i32* %3, align 4, !dbg !1102
  %6 = load i32, i32* %3, align 4, !dbg !1104
  %7 = icmp eq i32 %6, 0, !dbg !1104
  br i1 %7, label %8, label %9, !dbg !1107

8:                                                ; preds = %1
  br label %10, !dbg !1107

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.22, i64 0, i64 0), i8* noundef getelementptr inbounds ([101 x i8], [101 x i8]* @.str.23, i64 0, i64 0), i32 noundef 32, i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.queue_lock_release, i64 0, i64 0)) #5, !dbg !1104
  unreachable, !dbg !1104

10:                                               ; preds = %8
  ret void, !dbg !1102
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @vmem_free(i8* noundef %0) #0 !dbg !1108 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !1109, metadata !DIExpression()), !dbg !1110
  %3 = load i8*, i8** %2, align 8, !dbg !1111
  call void @free(i8* noundef %3) #6, !dbg !1112
  %4 = load i8*, i8** %2, align 8, !dbg !1113
  %5 = icmp ne i8* %4, null, !dbg !1113
  br i1 %5, label %6, label %7, !dbg !1115

6:                                                ; preds = %1
  call void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef @_g_vmem_free_count), !dbg !1116
  br label %7, !dbg !1118

7:                                                ; preds = %6, %1
  ret void, !dbg !1119
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !1120 {
  %2 = alloca %struct.vatomic64_s*, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !1125, metadata !DIExpression()), !dbg !1126
  %3 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !1127
  %4 = call i64 @vatomic64_get_inc_rlx(%struct.vatomic64_s* noundef %3), !dbg !1128
  ret void, !dbg !1129
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_get_inc_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !1130 {
  %2 = alloca %struct.vatomic64_s*, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !1133, metadata !DIExpression()), !dbg !1134
  %3 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !1135
  %4 = call i64 @vatomic64_get_add_rlx(%struct.vatomic64_s* noundef %3, i64 noundef 1), !dbg !1136
  ret i64 %4, !dbg !1137
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_get_add_rlx(%struct.vatomic64_s* noundef %0, i64 noundef %1) #0 !dbg !1138 {
  %3 = alloca %struct.vatomic64_s*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %3, metadata !1142, metadata !DIExpression()), !dbg !1143
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1144, metadata !DIExpression()), !dbg !1145
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1146, metadata !DIExpression()), !dbg !1147
  call void @llvm.dbg.declare(metadata i32* %6, metadata !1148, metadata !DIExpression()), !dbg !1152
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1153, metadata !DIExpression()), !dbg !1154
  %8 = load i64, i64* %4, align 8, !dbg !1155
  %9 = load %struct.vatomic64_s*, %struct.vatomic64_s** %3, align 8, !dbg !1156
  %10 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %9, i32 0, i32 0, !dbg !1157
  %11 = load i64, i64* %10, align 8, !dbg !1157
  %12 = call { i64, i64, i32, i64 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:x}, $4\0Aadd ${1:x}, ${0:x}, ${3:x}\0Astxr ${2:w}, ${1:x}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i64 %11, i64 %8) #6, !dbg !1155, !srcloc !1158
  %13 = extractvalue { i64, i64, i32, i64 } %12, 0, !dbg !1155
  %14 = extractvalue { i64, i64, i32, i64 } %12, 1, !dbg !1155
  %15 = extractvalue { i64, i64, i32, i64 } %12, 2, !dbg !1155
  %16 = extractvalue { i64, i64, i32, i64 } %12, 3, !dbg !1155
  store i64 %13, i64* %5, align 8, !dbg !1155
  store i64 %14, i64* %7, align 8, !dbg !1155
  store i32 %15, i32* %6, align 4, !dbg !1155
  store i64 %16, i64* %4, align 8, !dbg !1155
  %17 = load i64, i64* %5, align 8, !dbg !1159
  ret i64 %17, !dbg !1160
}

; Function Attrs: noinline nounwind uwtable
define internal void @locked_trace_destroy(%struct.locked_trace_s* noundef %0, i1 (%struct.trace_unit_s*)* noundef %1) #0 !dbg !1161 {
  %3 = alloca %struct.locked_trace_s*, align 8
  %4 = alloca i1 (%struct.trace_unit_s*)*, align 8
  store %struct.locked_trace_s* %0, %struct.locked_trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.locked_trace_s** %3, metadata !1168, metadata !DIExpression()), !dbg !1169
  store i1 (%struct.trace_unit_s*)* %1, i1 (%struct.trace_unit_s*)** %4, align 8
  call void @llvm.dbg.declare(metadata i1 (%struct.trace_unit_s*)** %4, metadata !1170, metadata !DIExpression()), !dbg !1171
  %5 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1172
  %6 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %5, i32 0, i32 0, !dbg !1173
  %7 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %4, align 8, !dbg !1174
  %8 = call zeroext i1 @trace_verify(%struct.trace_s* noundef %6, i1 (%struct.trace_unit_s*)* noundef %7), !dbg !1175
  %9 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1176
  %10 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %9, i32 0, i32 0, !dbg !1177
  call void @trace_destroy(%struct.trace_s* noundef %10), !dbg !1178
  %11 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1179
  %12 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %11, i32 0, i32 1, !dbg !1180
  %13 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef %12) #6, !dbg !1181
  ret void, !dbg !1182
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @_ismr_none_destroy_all_cb(%struct.trace_unit_s* noundef %0) #0 !dbg !1183 {
  %2 = alloca %struct.trace_unit_s*, align 8
  %3 = alloca %struct.smr_none_retire_info_t*, align 8
  store %struct.trace_unit_s* %0, %struct.trace_unit_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %2, metadata !1184, metadata !DIExpression()), !dbg !1185
  %4 = load %struct.trace_unit_s*, %struct.trace_unit_s** %2, align 8, !dbg !1186
  %5 = icmp ne %struct.trace_unit_s* %4, null, !dbg !1186
  br i1 %5, label %6, label %7, !dbg !1189

6:                                                ; preds = %1
  br label %8, !dbg !1189

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.26, i64 0, i64 0), i8* noundef getelementptr inbounds ([70 x i8], [70 x i8]* @.str.27, i64 0, i64 0), i32 noundef 27, i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @__PRETTY_FUNCTION__._ismr_none_destroy_all_cb, i64 0, i64 0)) #5, !dbg !1186
  unreachable, !dbg !1186

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata %struct.smr_none_retire_info_t** %3, metadata !1190, metadata !DIExpression()), !dbg !1191
  %9 = load %struct.trace_unit_s*, %struct.trace_unit_s** %2, align 8, !dbg !1192
  %10 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %9, i32 0, i32 0, !dbg !1193
  %11 = load i64, i64* %10, align 8, !dbg !1193
  %12 = inttoptr i64 %11 to %struct.smr_none_retire_info_t*, !dbg !1194
  store %struct.smr_none_retire_info_t* %12, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1191
  %13 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1195
  %14 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %13, i32 0, i32 1, !dbg !1196
  %15 = load void (%struct.smr_node_s*, i8*)*, void (%struct.smr_node_s*, i8*)** %14, align 8, !dbg !1196
  %16 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1197
  %17 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %16, i32 0, i32 0, !dbg !1198
  %18 = load %struct.smr_node_s*, %struct.smr_node_s** %17, align 8, !dbg !1198
  %19 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1199
  %20 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %19, i32 0, i32 2, !dbg !1200
  %21 = load i8*, i8** %20, align 8, !dbg !1200
  call void %15(%struct.smr_node_s* noundef %18, i8* noundef %21), !dbg !1195
  %22 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1201
  %23 = bitcast %struct.smr_none_retire_info_t* %22 to i8*, !dbg !1201
  call void @free(i8* noundef %23) #6, !dbg !1202
  ret i1 true, !dbg !1203
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @trace_verify(%struct.trace_s* noundef %0, i1 (%struct.trace_unit_s*)* noundef %1) #0 !dbg !1204 {
  %3 = alloca i1, align 1
  %4 = alloca %struct.trace_s*, align 8
  %5 = alloca i1 (%struct.trace_unit_s*)*, align 8
  %6 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !1207, metadata !DIExpression()), !dbg !1208
  store i1 (%struct.trace_unit_s*)* %1, i1 (%struct.trace_unit_s*)** %5, align 8
  call void @llvm.dbg.declare(metadata i1 (%struct.trace_unit_s*)** %5, metadata !1209, metadata !DIExpression()), !dbg !1210
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1211, metadata !DIExpression()), !dbg !1212
  store i64 0, i64* %6, align 8, !dbg !1212
  %7 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1213
  %8 = icmp ne %struct.trace_s* %7, null, !dbg !1213
  br i1 %8, label %9, label %10, !dbg !1216

9:                                                ; preds = %2
  br label %11, !dbg !1216

10:                                               ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.17, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.19, i64 0, i64 0), i32 noundef 214, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #5, !dbg !1213
  unreachable, !dbg !1213

11:                                               ; preds = %9
  %12 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1217
  %13 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %12, i32 0, i32 3, !dbg !1217
  %14 = load i8, i8* %13, align 8, !dbg !1217
  %15 = trunc i8 %14 to i1, !dbg !1217
  br i1 %15, label %16, label %17, !dbg !1220

16:                                               ; preds = %11
  br label %18, !dbg !1220

17:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.24, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.19, i64 0, i64 0), i32 noundef 215, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #5, !dbg !1217
  unreachable, !dbg !1217

18:                                               ; preds = %16
  %19 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %5, align 8, !dbg !1221
  %20 = icmp ne i1 (%struct.trace_unit_s*)* %19, null, !dbg !1221
  br i1 %20, label %21, label %22, !dbg !1224

21:                                               ; preds = %18
  br label %23, !dbg !1224

22:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.25, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.19, i64 0, i64 0), i32 noundef 216, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #5, !dbg !1221
  unreachable, !dbg !1221

23:                                               ; preds = %21
  store i64 0, i64* %6, align 8, !dbg !1225
  br label %24, !dbg !1227

24:                                               ; preds = %42, %23
  %25 = load i64, i64* %6, align 8, !dbg !1228
  %26 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1230
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 1, !dbg !1231
  %28 = load i64, i64* %27, align 8, !dbg !1231
  %29 = icmp ult i64 %25, %28, !dbg !1232
  br i1 %29, label %30, label %45, !dbg !1233

30:                                               ; preds = %24
  %31 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %5, align 8, !dbg !1234
  %32 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1237
  %33 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %32, i32 0, i32 0, !dbg !1238
  %34 = load %struct.trace_unit_s*, %struct.trace_unit_s** %33, align 8, !dbg !1238
  %35 = load i64, i64* %6, align 8, !dbg !1239
  %36 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %34, i64 %35, !dbg !1237
  %37 = call zeroext i1 %31(%struct.trace_unit_s* noundef %36), !dbg !1234
  %38 = zext i1 %37 to i32, !dbg !1234
  %39 = icmp eq i32 %38, 0, !dbg !1240
  br i1 %39, label %40, label %41, !dbg !1241

40:                                               ; preds = %30
  store i1 false, i1* %3, align 1, !dbg !1242
  br label %46, !dbg !1242

41:                                               ; preds = %30
  br label %42, !dbg !1244

42:                                               ; preds = %41
  %43 = load i64, i64* %6, align 8, !dbg !1245
  %44 = add i64 %43, 1, !dbg !1245
  store i64 %44, i64* %6, align 8, !dbg !1245
  br label %24, !dbg !1246, !llvm.loop !1247

45:                                               ; preds = %24
  store i1 true, i1* %3, align 1, !dbg !1249
  br label %46, !dbg !1249

46:                                               ; preds = %45, %40
  %47 = load i1, i1* %3, align 1, !dbg !1250
  ret i1 %47, !dbg !1250
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_destroy(%struct.trace_s* noundef %0) #0 !dbg !1251 {
  %2 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %2, metadata !1254, metadata !DIExpression()), !dbg !1255
  %3 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1256
  %4 = icmp ne %struct.trace_s* %3, null, !dbg !1256
  br i1 %4, label %5, label %6, !dbg !1259

5:                                                ; preds = %1
  br label %7, !dbg !1259

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.17, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.19, i64 0, i64 0), i32 noundef 99, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !1256
  unreachable, !dbg !1256

7:                                                ; preds = %5
  %8 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1260
  %9 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %8, i32 0, i32 3, !dbg !1260
  %10 = load i8, i8* %9, align 8, !dbg !1260
  %11 = trunc i8 %10 to i1, !dbg !1260
  br i1 %11, label %12, label %13, !dbg !1263

12:                                               ; preds = %7
  br label %14, !dbg !1263

13:                                               ; preds = %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.24, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.19, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !1260
  unreachable, !dbg !1260

14:                                               ; preds = %12
  %15 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1264
  %16 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %15, i32 0, i32 0, !dbg !1265
  %17 = load %struct.trace_unit_s*, %struct.trace_unit_s** %16, align 8, !dbg !1265
  %18 = bitcast %struct.trace_unit_s* %17 to i8*, !dbg !1264
  call void @free(i8* noundef %18) #6, !dbg !1266
  %19 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1267
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 3, !dbg !1268
  store i8 0, i8* %20, align 8, !dbg !1269
  ret void, !dbg !1270
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @vmem_malloc(i64 noundef %0) #0 !dbg !1271 {
  %2 = alloca i64, align 8
  %3 = alloca i8*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1274, metadata !DIExpression()), !dbg !1275
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1276, metadata !DIExpression()), !dbg !1277
  %4 = load i64, i64* %2, align 8, !dbg !1278
  %5 = call noalias i8* @malloc(i64 noundef %4) #6, !dbg !1279
  store i8* %5, i8** %3, align 8, !dbg !1277
  %6 = load i8*, i8** %3, align 8, !dbg !1280
  %7 = icmp ne i8* %6, null, !dbg !1280
  br i1 %7, label %8, label %9, !dbg !1282

8:                                                ; preds = %1
  call void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef @_g_vmem_alloc_count), !dbg !1283
  br label %10, !dbg !1285

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.20, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.28, i64 0, i64 0), i32 noundef 28, i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @__PRETTY_FUNCTION__.vmem_malloc, i64 0, i64 0)) #5, !dbg !1286
  unreachable, !dbg !1286

10:                                               ; preds = %8
  %11 = load i8*, i8** %3, align 8, !dbg !1290
  ret i8* %11, !dbg !1291
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_enter(i64 noundef %0) #0 !dbg !1292 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1293, metadata !DIExpression()), !dbg !1294
  br label %3, !dbg !1295

3:                                                ; preds = %1
  br label %4, !dbg !1296

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1298
  br label %6, !dbg !1298

6:                                                ; preds = %4
  br label %7, !dbg !1300

7:                                                ; preds = %6
  br label %8, !dbg !1298

8:                                                ; preds = %7
  br label %9, !dbg !1296

9:                                                ; preds = %8
  ret void, !dbg !1302
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_enq(%struct.vqueue_ub_s* noundef %0, %struct.vqueue_ub_node_s* noundef %1, i8* noundef %2) #0 !dbg !1303 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca %struct.vqueue_ub_node_s*, align 8
  %6 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !1306, metadata !DIExpression()), !dbg !1307
  store %struct.vqueue_ub_node_s* %1, %struct.vqueue_ub_node_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %5, metadata !1308, metadata !DIExpression()), !dbg !1309
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !1310, metadata !DIExpression()), !dbg !1311
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1312
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 0, !dbg !1313
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %8), !dbg !1314
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1315
  %10 = load i8*, i8** %6, align 8, !dbg !1316
  call void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %9, i8* noundef %10), !dbg !1317
  %11 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1318
  %12 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %11, i32 0, i32 3, !dbg !1319
  %13 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %12, align 8, !dbg !1319
  %14 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %13, i32 0, i32 1, !dbg !1320
  %15 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1321
  %16 = bitcast %struct.vqueue_ub_node_s* %15 to i8*, !dbg !1321
  call void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %14, i8* noundef %16), !dbg !1322
  %17 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1323
  %18 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1324
  %19 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %18, i32 0, i32 3, !dbg !1325
  store %struct.vqueue_ub_node_s* %17, %struct.vqueue_ub_node_s** %19, align 8, !dbg !1326
  %20 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1327
  %21 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %20, i32 0, i32 0, !dbg !1328
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %21), !dbg !1329
  ret void, !dbg !1330
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_exit(i64 noundef %0) #0 !dbg !1331 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1332, metadata !DIExpression()), !dbg !1333
  br label %3, !dbg !1334

3:                                                ; preds = %1
  br label %4, !dbg !1335

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1337
  br label %6, !dbg !1337

6:                                                ; preds = %4
  br label %7, !dbg !1339

7:                                                ; preds = %6
  br label %8, !dbg !1337

8:                                                ; preds = %7
  br label %9, !dbg !1335

9:                                                ; preds = %8
  ret void, !dbg !1341
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1342 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1343, metadata !DIExpression()), !dbg !1344
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1345, metadata !DIExpression()), !dbg !1346
  %5 = load i8*, i8** %4, align 8, !dbg !1347
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !1348
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !1349
  %8 = load i8*, i8** %7, align 8, !dbg !1349
  call void asm sideeffect "stlr ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !1350, !srcloc !1351
  ret void, !dbg !1352
}

; Function Attrs: noinline nounwind uwtable
define internal void @_queue_retire(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !1353 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1354, metadata !DIExpression()), !dbg !1355
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1356, metadata !DIExpression()), !dbg !1357
  %5 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1358
  %6 = bitcast %struct.vqueue_ub_node_s* %5 to i8*, !dbg !1358
  call void @vmem_free(i8* noundef %6), !dbg !1359
  br label %7, !dbg !1360

7:                                                ; preds = %2
  br label %8, !dbg !1361

8:                                                ; preds = %7
  %9 = load i8*, i8** %4, align 8, !dbg !1363
  br label %10, !dbg !1363

10:                                               ; preds = %8
  br label %11, !dbg !1365

11:                                               ; preds = %10
  br label %12, !dbg !1363

12:                                               ; preds = %11
  br label %13, !dbg !1361

13:                                               ; preds = %12
  ret void, !dbg !1367
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @vqueue_ub_empty(%struct.vqueue_ub_s* noundef %0) #0 !dbg !1368 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !1371, metadata !DIExpression()), !dbg !1372
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1373, metadata !DIExpression()), !dbg !1374
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1374
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %4, metadata !1375, metadata !DIExpression()), !dbg !1376
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1376
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1377
  %6 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %5, i32 0, i32 1, !dbg !1378
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %6), !dbg !1379
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1380
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 2, !dbg !1381
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1381
  store %struct.vqueue_ub_node_s* %9, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1382
  %10 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1383
  %11 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %10, i32 0, i32 1, !dbg !1384
  %12 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %11), !dbg !1385
  %13 = bitcast i8* %12 to %struct.vqueue_ub_node_s*, !dbg !1386
  store %struct.vqueue_ub_node_s* %13, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1387
  %14 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1388
  %15 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %14, i32 0, i32 1, !dbg !1389
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %15), !dbg !1390
  %16 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1391
  %17 = icmp eq %struct.vqueue_ub_node_s* %16, null, !dbg !1392
  ret i1 %17, !dbg !1393
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!173, !174, !175, !176, !177, !178, !179}
!llvm.ident = !{!180}

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
!76 = !{!0, !77, !89, !92, !102, !104, !156, !168}
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
!93 = distinct !DIGlobalVariable(name: "deq_1", scope: !2, file: !94, line: 16, type: !95, isLocal: false, isDefinition: true)
!94 = !DIFile(filename: "datastruct/queue/unbounded/verify/test_case_2.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "d7f074e1ae268539cceb540def1f58f8")
!95 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !96, size: 64)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "data_t", file: !44, line: 49, baseType: !97)
!97 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "data_s", file: !44, line: 46, size: 128, elements: !98)
!98 = !{!99, !100}
!99 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !97, file: !44, line: 47, baseType: !84, size: 64)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "lbl", scope: !97, file: !44, line: 48, baseType: !101, size: 8, offset: 64)
!101 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!102 = !DIGlobalVariableExpression(var: !103, expr: !DIExpression())
!103 = distinct !DIGlobalVariable(name: "deq_2", scope: !2, file: !94, line: 17, type: !95, isLocal: false, isDefinition: true)
!104 = !DIGlobalVariableExpression(var: !105, expr: !DIExpression())
!105 = distinct !DIGlobalVariable(name: "global_trace", scope: !2, file: !50, line: 15, type: !106, isLocal: false, isDefinition: true)
!106 = !DIDerivedType(tag: DW_TAG_typedef, name: "locked_trace_t", file: !107, line: 11, baseType: !108)
!107 = !DIFile(filename: "utils/include/test/locked_trace.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "6b9b066c8ea09bc73550cef772f1c7ca")
!108 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "locked_trace_s", file: !107, line: 8, size: 576, elements: !109)
!109 = !{!110, !125}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "trace", scope: !108, file: !107, line: 9, baseType: !111, size: 256)
!111 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_t", file: !112, line: 23, baseType: !113)
!112 = !DIFile(filename: "utils/include/test/trace_manager.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "ef0cfa2f64930baab6e03245b4188b52")
!113 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_s", file: !112, line: 18, size: 256, elements: !114)
!114 = !{!115, !122, !123, !124}
!115 = !DIDerivedType(tag: DW_TAG_member, name: "units", scope: !113, file: !112, line: 19, baseType: !116, size: 64)
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_unit_t", file: !112, line: 16, baseType: !118)
!118 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_unit_s", file: !112, line: 13, size: 128, elements: !119)
!119 = !{!120, !121}
!120 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !118, file: !112, line: 14, baseType: !10, size: 64)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !118, file: !112, line: 15, baseType: !5, size: 64, offset: 64)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !113, file: !112, line: 20, baseType: !5, size: 64, offset: 64)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "capacity", scope: !113, file: !112, line: 21, baseType: !5, size: 64, offset: 128)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "initialized", scope: !113, file: !112, line: 22, baseType: !24, size: 8, offset: 192)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !108, file: !107, line: 10, baseType: !126, size: 320, offset: 256)
!126 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !21, line: 72, baseType: !127)
!127 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !21, line: 67, size: 320, elements: !128)
!128 = !{!129, !150, !154}
!129 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !127, file: !21, line: 69, baseType: !130, size: 320)
!130 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !131, line: 22, size: 320, elements: !132)
!131 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "584baedd80e6041b81caae7f496091c0")
!132 = !{!133, !134, !136, !137, !138, !139, !141, !142}
!133 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !130, file: !131, line: 24, baseType: !66, size: 32)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !130, file: !131, line: 25, baseType: !135, size: 32, offset: 32)
!135 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !130, file: !131, line: 26, baseType: !66, size: 32, offset: 64)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !130, file: !131, line: 28, baseType: !135, size: 32, offset: 96)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !130, file: !131, line: 32, baseType: !66, size: 32, offset: 128)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !130, file: !131, line: 34, baseType: !140, size: 16, offset: 160)
!140 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !130, file: !131, line: 35, baseType: !140, size: 16, offset: 176)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !130, file: !131, line: 36, baseType: !143, size: 128, offset: 192)
!143 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !144, line: 55, baseType: !145)
!144 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "04c81e86d34dad9c99ad006d32e47a0d")
!145 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !144, line: 51, size: 128, elements: !146)
!146 = !{!147, !149}
!147 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !145, file: !144, line: 53, baseType: !148, size: 64)
!148 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !145, size: 64)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !145, file: !144, line: 54, baseType: !148, size: 64, offset: 64)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !127, file: !21, line: 70, baseType: !151, size: 320)
!151 = !DICompositeType(tag: DW_TAG_array_type, baseType: !101, size: 320, elements: !152)
!152 = !{!153}
!153 = !DISubrange(count: 40)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !127, file: !21, line: 71, baseType: !155, size: 64)
!155 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!156 = !DIGlobalVariableExpression(var: !157, expr: !DIExpression())
!157 = distinct !DIGlobalVariable(name: "g_queue", scope: !2, file: !91, line: 25, type: !158, isLocal: false, isDefinition: true)
!158 = !DIDerivedType(tag: DW_TAG_typedef, name: "queue_t", file: !44, line: 41, baseType: !159)
!159 = !DIDerivedType(tag: DW_TAG_typedef, name: "vqueue_ub_t", file: !33, line: 47, baseType: !160)
!160 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vqueue_ub_s", file: !33, line: 41, size: 896, elements: !161)
!161 = !{!162, !164, !165, !166, !167}
!162 = !DIDerivedType(tag: DW_TAG_member, name: "enq_l", scope: !160, file: !33, line: 42, baseType: !163, size: 320)
!163 = !DIDerivedType(tag: DW_TAG_typedef, name: "queue_lock_t", file: !33, line: 31, baseType: !126)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "deq_l", scope: !160, file: !33, line: 43, baseType: !163, size: 320, offset: 320)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !160, file: !33, line: 44, baseType: !31, size: 64, offset: 640)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !160, file: !33, line: 45, baseType: !31, size: 64, offset: 704)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "sentinel", scope: !160, file: !33, line: 46, baseType: !32, size: 128, offset: 768)
!168 = !DIGlobalVariableExpression(var: !169, expr: !DIExpression())
!169 = distinct !DIGlobalVariable(name: "g_final_state", scope: !2, file: !91, line: 28, type: !170, isLocal: false, isDefinition: true)
!170 = !DICompositeType(tag: DW_TAG_array_type, baseType: !84, size: 320, elements: !171)
!171 = !{!172}
!172 = !DISubrange(count: 5)
!173 = !{i32 7, !"Dwarf Version", i32 5}
!174 = !{i32 2, !"Debug Info Version", i32 3}
!175 = !{i32 1, !"wchar_size", i32 4}
!176 = !{i32 7, !"PIC Level", i32 2}
!177 = !{i32 7, !"PIE Level", i32 2}
!178 = !{i32 7, !"uwtable", i32 1}
!179 = !{i32 7, !"frame-pointer", i32 2}
!180 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!181 = distinct !DISubprogram(name: "t1", scope: !94, file: !94, line: 6, type: !182, scopeLine: 7, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!182 = !DISubroutineType(types: !183)
!183 = !{null, !5}
!184 = !{}
!185 = !DILocalVariable(name: "tid", arg: 1, scope: !181, file: !94, line: 6, type: !5)
!186 = !DILocation(line: 6, column: 12, scope: !181)
!187 = !DILocation(line: 8, column: 9, scope: !181)
!188 = !DILocation(line: 8, column: 5, scope: !181)
!189 = !DILocation(line: 9, column: 9, scope: !181)
!190 = !DILocation(line: 9, column: 5, scope: !181)
!191 = !DILocation(line: 10, column: 1, scope: !181)
!192 = distinct !DISubprogram(name: "enq", scope: !91, file: !91, line: 94, type: !193, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!193 = !DISubroutineType(types: !194)
!194 = !{null, !5, !84, !101}
!195 = !DILocalVariable(name: "tid", arg: 1, scope: !192, file: !91, line: 94, type: !5)
!196 = !DILocation(line: 94, column: 13, scope: !192)
!197 = !DILocalVariable(name: "k", arg: 2, scope: !192, file: !91, line: 94, type: !84)
!198 = !DILocation(line: 94, column: 28, scope: !192)
!199 = !DILocalVariable(name: "lbl", arg: 3, scope: !192, file: !91, line: 94, type: !101)
!200 = !DILocation(line: 94, column: 36, scope: !192)
!201 = !DILocation(line: 96, column: 15, scope: !192)
!202 = !DILocation(line: 96, column: 30, scope: !192)
!203 = !DILocation(line: 96, column: 33, scope: !192)
!204 = !DILocation(line: 96, column: 5, scope: !192)
!205 = !DILocation(line: 97, column: 1, scope: !192)
!206 = distinct !DISubprogram(name: "t2", scope: !94, file: !94, line: 19, type: !182, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!207 = !DILocalVariable(name: "tid", arg: 1, scope: !206, file: !94, line: 19, type: !5)
!208 = !DILocation(line: 19, column: 12, scope: !206)
!209 = !DILocation(line: 21, column: 17, scope: !206)
!210 = !DILocation(line: 21, column: 13, scope: !206)
!211 = !DILocation(line: 21, column: 11, scope: !206)
!212 = !DILocation(line: 22, column: 17, scope: !206)
!213 = !DILocation(line: 22, column: 13, scope: !206)
!214 = !DILocation(line: 22, column: 11, scope: !206)
!215 = !DILocation(line: 23, column: 1, scope: !206)
!216 = distinct !DISubprogram(name: "deq", scope: !91, file: !91, line: 100, type: !217, scopeLine: 101, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!217 = !DISubroutineType(types: !218)
!218 = !{!95, !5}
!219 = !DILocalVariable(name: "tid", arg: 1, scope: !216, file: !91, line: 100, type: !5)
!220 = !DILocation(line: 100, column: 13, scope: !216)
!221 = !DILocation(line: 102, column: 22, scope: !216)
!222 = !DILocation(line: 102, column: 12, scope: !216)
!223 = !DILocation(line: 102, column: 5, scope: !216)
!224 = distinct !DISubprogram(name: "t3", scope: !94, file: !94, line: 29, type: !182, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!225 = !DILocalVariable(name: "tid", arg: 1, scope: !224, file: !94, line: 29, type: !5)
!226 = !DILocation(line: 29, column: 12, scope: !224)
!227 = !DILocation(line: 31, column: 17, scope: !224)
!228 = !DILocation(line: 31, column: 5, scope: !224)
!229 = !DILocation(line: 32, column: 1, scope: !224)
!230 = distinct !DISubprogram(name: "queue_clean", scope: !44, file: !44, line: 248, type: !182, scopeLine: 249, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!231 = !DILocalVariable(name: "tid", arg: 1, scope: !230, file: !44, line: 248, type: !5)
!232 = !DILocation(line: 248, column: 21, scope: !230)
!233 = !DILocation(line: 250, column: 18, scope: !230)
!234 = !DILocation(line: 250, column: 5, scope: !230)
!235 = !DILocation(line: 251, column: 1, scope: !230)
!236 = distinct !DISubprogram(name: "verify", scope: !94, file: !94, line: 35, type: !237, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!237 = !DISubroutineType(types: !238)
!238 = !{null}
!239 = !DILocation(line: 37, column: 13, scope: !236)
!240 = !DILocation(line: 37, column: 5, scope: !236)
!241 = !DILocation(line: 39, column: 13, scope: !242)
!242 = distinct !DILexicalBlock(scope: !243, file: !94, line: 39, column: 13)
!243 = distinct !DILexicalBlock(scope: !244, file: !94, line: 39, column: 13)
!244 = distinct !DILexicalBlock(scope: !236, file: !94, line: 37, column: 20)
!245 = !DILocation(line: 39, column: 13, scope: !243)
!246 = !DILocation(line: 40, column: 13, scope: !247)
!247 = distinct !DILexicalBlock(scope: !248, file: !94, line: 40, column: 13)
!248 = distinct !DILexicalBlock(scope: !244, file: !94, line: 40, column: 13)
!249 = !DILocation(line: 40, column: 13, scope: !248)
!250 = !DILocation(line: 41, column: 13, scope: !244)
!251 = !DILocation(line: 43, column: 17, scope: !252)
!252 = distinct !DILexicalBlock(scope: !244, file: !94, line: 43, column: 17)
!253 = !DILocation(line: 43, column: 17, scope: !244)
!254 = !DILocation(line: 44, column: 17, scope: !255)
!255 = distinct !DILexicalBlock(scope: !256, file: !94, line: 44, column: 17)
!256 = distinct !DILexicalBlock(scope: !257, file: !94, line: 44, column: 17)
!257 = distinct !DILexicalBlock(scope: !252, file: !94, line: 43, column: 24)
!258 = !DILocation(line: 44, column: 17, scope: !256)
!259 = !DILocation(line: 45, column: 17, scope: !260)
!260 = distinct !DILexicalBlock(scope: !261, file: !94, line: 45, column: 17)
!261 = distinct !DILexicalBlock(scope: !257, file: !94, line: 45, column: 17)
!262 = !DILocation(line: 45, column: 17, scope: !261)
!263 = !DILocation(line: 46, column: 13, scope: !257)
!264 = !DILocation(line: 46, column: 24, scope: !265)
!265 = distinct !DILexicalBlock(scope: !252, file: !94, line: 46, column: 24)
!266 = !DILocation(line: 46, column: 24, scope: !252)
!267 = !DILocation(line: 47, column: 17, scope: !268)
!268 = distinct !DILexicalBlock(scope: !269, file: !94, line: 47, column: 17)
!269 = distinct !DILexicalBlock(scope: !270, file: !94, line: 47, column: 17)
!270 = distinct !DILexicalBlock(scope: !265, file: !94, line: 46, column: 31)
!271 = !DILocation(line: 47, column: 17, scope: !269)
!272 = !DILocation(line: 48, column: 17, scope: !273)
!273 = distinct !DILexicalBlock(scope: !274, file: !94, line: 48, column: 17)
!274 = distinct !DILexicalBlock(scope: !270, file: !94, line: 48, column: 17)
!275 = !DILocation(line: 48, column: 17, scope: !274)
!276 = !DILocation(line: 49, column: 13, scope: !270)
!277 = !DILocation(line: 50, column: 17, scope: !278)
!278 = distinct !DILexicalBlock(scope: !279, file: !94, line: 50, column: 17)
!279 = distinct !DILexicalBlock(scope: !280, file: !94, line: 50, column: 17)
!280 = distinct !DILexicalBlock(scope: !265, file: !94, line: 49, column: 20)
!281 = !DILocation(line: 54, column: 13, scope: !282)
!282 = distinct !DILexicalBlock(scope: !283, file: !94, line: 54, column: 13)
!283 = distinct !DILexicalBlock(scope: !244, file: !94, line: 54, column: 13)
!284 = !DILocation(line: 54, column: 13, scope: !283)
!285 = !DILocation(line: 55, column: 13, scope: !244)
!286 = !DILocation(line: 57, column: 13, scope: !287)
!287 = distinct !DILexicalBlock(scope: !288, file: !94, line: 57, column: 13)
!288 = distinct !DILexicalBlock(scope: !244, file: !94, line: 57, column: 13)
!289 = !DILocation(line: 57, column: 13, scope: !288)
!290 = !DILocation(line: 58, column: 13, scope: !291)
!291 = distinct !DILexicalBlock(scope: !292, file: !94, line: 58, column: 13)
!292 = distinct !DILexicalBlock(scope: !244, file: !94, line: 58, column: 13)
!293 = !DILocation(line: 58, column: 13, scope: !292)
!294 = !DILocation(line: 60, column: 13, scope: !295)
!295 = distinct !DILexicalBlock(scope: !296, file: !94, line: 60, column: 13)
!296 = distinct !DILexicalBlock(scope: !244, file: !94, line: 60, column: 13)
!297 = !DILocation(line: 60, column: 13, scope: !296)
!298 = !DILocation(line: 61, column: 13, scope: !299)
!299 = distinct !DILexicalBlock(scope: !300, file: !94, line: 61, column: 13)
!300 = distinct !DILexicalBlock(scope: !244, file: !94, line: 61, column: 13)
!301 = !DILocation(line: 61, column: 13, scope: !300)
!302 = !DILocation(line: 62, column: 13, scope: !244)
!303 = !DILocation(line: 64, column: 13, scope: !304)
!304 = distinct !DILexicalBlock(scope: !305, file: !94, line: 64, column: 13)
!305 = distinct !DILexicalBlock(scope: !244, file: !94, line: 64, column: 13)
!306 = !DILocation(line: 67, column: 1, scope: !236)
!307 = distinct !DISubprogram(name: "main", scope: !91, file: !91, line: 50, type: !308, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!308 = !DISubroutineType(types: !309)
!309 = !{!66}
!310 = !DILocation(line: 52, column: 5, scope: !307)
!311 = !DILocation(line: 53, column: 5, scope: !307)
!312 = !DILocation(line: 55, column: 5, scope: !307)
!313 = !DILocation(line: 56, column: 5, scope: !307)
!314 = !DILocation(line: 57, column: 5, scope: !307)
!315 = !DILocation(line: 58, column: 5, scope: !316)
!316 = distinct !DILexicalBlock(scope: !317, file: !91, line: 58, column: 5)
!317 = distinct !DILexicalBlock(scope: !307, file: !91, line: 58, column: 5)
!318 = !DILocation(line: 58, column: 5, scope: !317)
!319 = !DILocation(line: 59, column: 5, scope: !307)
!320 = distinct !DISubprogram(name: "init", scope: !91, file: !91, line: 63, type: !237, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!321 = !DILocation(line: 65, column: 5, scope: !320)
!322 = !DILocation(line: 70, column: 5, scope: !320)
!323 = !DILocation(line: 84, column: 5, scope: !320)
!324 = !DILocation(line: 85, column: 1, scope: !320)
!325 = distinct !DISubprogram(name: "launch_threads", scope: !16, file: !16, line: 111, type: !326, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!326 = !DISubroutineType(types: !327)
!327 = !{null, !5, !27}
!328 = !DILocalVariable(name: "thread_count", arg: 1, scope: !325, file: !16, line: 111, type: !5)
!329 = !DILocation(line: 111, column: 24, scope: !325)
!330 = !DILocalVariable(name: "fun", arg: 2, scope: !325, file: !16, line: 111, type: !27)
!331 = !DILocation(line: 111, column: 51, scope: !325)
!332 = !DILocalVariable(name: "threads", scope: !325, file: !16, line: 113, type: !14)
!333 = !DILocation(line: 113, column: 17, scope: !325)
!334 = !DILocation(line: 113, column: 55, scope: !325)
!335 = !DILocation(line: 113, column: 53, scope: !325)
!336 = !DILocation(line: 113, column: 27, scope: !325)
!337 = !DILocation(line: 115, column: 20, scope: !325)
!338 = !DILocation(line: 115, column: 29, scope: !325)
!339 = !DILocation(line: 115, column: 43, scope: !325)
!340 = !DILocation(line: 115, column: 5, scope: !325)
!341 = !DILocation(line: 117, column: 19, scope: !325)
!342 = !DILocation(line: 117, column: 28, scope: !325)
!343 = !DILocation(line: 117, column: 5, scope: !325)
!344 = !DILocation(line: 119, column: 10, scope: !325)
!345 = !DILocation(line: 119, column: 5, scope: !325)
!346 = !DILocation(line: 120, column: 1, scope: !325)
!347 = distinct !DISubprogram(name: "run", scope: !91, file: !91, line: 126, type: !29, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!348 = !DILocalVariable(name: "args", arg: 1, scope: !347, file: !91, line: 126, type: !13)
!349 = !DILocation(line: 126, column: 11, scope: !347)
!350 = !DILocalVariable(name: "tid", scope: !347, file: !91, line: 128, type: !5)
!351 = !DILocation(line: 128, column: 13, scope: !347)
!352 = !DILocation(line: 128, column: 40, scope: !347)
!353 = !DILocation(line: 128, column: 28, scope: !347)
!354 = !DILocation(line: 129, column: 20, scope: !347)
!355 = !DILocation(line: 129, column: 5, scope: !347)
!356 = !DILocation(line: 130, column: 13, scope: !347)
!357 = !DILocation(line: 130, column: 5, scope: !347)
!358 = !DILocation(line: 132, column: 16, scope: !359)
!359 = distinct !DILexicalBlock(scope: !347, file: !91, line: 130, column: 18)
!360 = !DILocation(line: 132, column: 13, scope: !359)
!361 = !DILocation(line: 133, column: 13, scope: !359)
!362 = !DILocation(line: 135, column: 16, scope: !359)
!363 = !DILocation(line: 135, column: 13, scope: !359)
!364 = !DILocation(line: 136, column: 13, scope: !359)
!365 = !DILocation(line: 138, column: 16, scope: !359)
!366 = !DILocation(line: 138, column: 13, scope: !359)
!367 = !DILocation(line: 139, column: 13, scope: !359)
!368 = !DILocation(line: 141, column: 13, scope: !369)
!369 = distinct !DILexicalBlock(scope: !359, file: !91, line: 141, column: 13)
!370 = !DILocation(line: 141, column: 13, scope: !371)
!371 = distinct !DILexicalBlock(scope: !369, file: !91, line: 141, column: 13)
!372 = !DILocation(line: 142, column: 5, scope: !359)
!373 = !DILocation(line: 143, column: 22, scope: !347)
!374 = !DILocation(line: 143, column: 5, scope: !347)
!375 = !DILocation(line: 144, column: 5, scope: !347)
!376 = distinct !DISubprogram(name: "queue_print", scope: !44, file: !44, line: 235, type: !377, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!377 = !DISubroutineType(types: !378)
!378 = !{null, !379, !43}
!379 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !159, size: 64)
!380 = !DILocalVariable(name: "q", arg: 1, scope: !376, file: !44, line: 235, type: !379)
!381 = !DILocation(line: 235, column: 26, scope: !376)
!382 = !DILocalVariable(name: "print", arg: 2, scope: !376, file: !44, line: 235, type: !43)
!383 = !DILocation(line: 235, column: 41, scope: !376)
!384 = !DILocation(line: 237, column: 28, scope: !376)
!385 = !DILocation(line: 237, column: 56, scope: !376)
!386 = !DILocation(line: 237, column: 48, scope: !376)
!387 = !DILocation(line: 237, column: 5, scope: !376)
!388 = !DILocation(line: 238, column: 1, scope: !376)
!389 = distinct !DISubprogram(name: "get_final_state", scope: !91, file: !91, line: 117, type: !46, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!390 = !DILocalVariable(name: "data", arg: 1, scope: !389, file: !91, line: 117, type: !13)
!391 = !DILocation(line: 117, column: 23, scope: !389)
!392 = !DILocation(line: 119, column: 5, scope: !393)
!393 = distinct !DILexicalBlock(scope: !394, file: !91, line: 119, column: 5)
!394 = distinct !DILexicalBlock(scope: !389, file: !91, line: 119, column: 5)
!395 = !DILocation(line: 119, column: 5, scope: !394)
!396 = !DILocalVariable(name: "node", scope: !389, file: !91, line: 120, type: !95)
!397 = !DILocation(line: 120, column: 13, scope: !389)
!398 = !DILocation(line: 120, column: 20, scope: !389)
!399 = !DILocation(line: 121, column: 5, scope: !400)
!400 = distinct !DILexicalBlock(scope: !401, file: !91, line: 121, column: 5)
!401 = distinct !DILexicalBlock(scope: !389, file: !91, line: 121, column: 5)
!402 = !DILocation(line: 121, column: 5, scope: !401)
!403 = !DILocation(line: 122, column: 30, scope: !389)
!404 = !DILocation(line: 122, column: 36, scope: !389)
!405 = !DILocation(line: 122, column: 24, scope: !389)
!406 = !DILocation(line: 122, column: 5, scope: !389)
!407 = !DILocation(line: 122, column: 28, scope: !389)
!408 = !DILocation(line: 123, column: 1, scope: !389)
!409 = distinct !DISubprogram(name: "destroy", scope: !91, file: !91, line: 88, type: !237, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!410 = !DILocation(line: 90, column: 5, scope: !409)
!411 = !DILocation(line: 91, column: 1, scope: !409)
!412 = distinct !DISubprogram(name: "vmem_no_leak", scope: !79, file: !79, line: 133, type: !413, scopeLine: 134, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!413 = !DISubroutineType(types: !414)
!414 = !{!24}
!415 = !DILocalVariable(name: "alloc_count", scope: !412, file: !79, line: 135, type: !84)
!416 = !DILocation(line: 135, column: 15, scope: !412)
!417 = !DILocation(line: 135, column: 29, scope: !412)
!418 = !DILocalVariable(name: "free_count", scope: !412, file: !79, line: 136, type: !84)
!419 = !DILocation(line: 136, column: 15, scope: !412)
!420 = !DILocation(line: 136, column: 29, scope: !412)
!421 = !DILocation(line: 137, column: 13, scope: !412)
!422 = !DILocation(line: 137, column: 28, scope: !412)
!423 = !DILocation(line: 137, column: 25, scope: !412)
!424 = !DILocation(line: 137, column: 5, scope: !412)
!425 = distinct !DISubprogram(name: "queue_init", scope: !44, file: !44, line: 110, type: !426, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!426 = !DISubroutineType(types: !427)
!427 = !{null, !428}
!428 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !158, size: 64)
!429 = !DILocalVariable(name: "q", arg: 1, scope: !425, file: !44, line: 110, type: !428)
!430 = !DILocation(line: 110, column: 21, scope: !425)
!431 = !DILocation(line: 112, column: 5, scope: !425)
!432 = !DILocation(line: 113, column: 20, scope: !425)
!433 = !DILocation(line: 113, column: 5, scope: !425)
!434 = !DILocation(line: 120, column: 1, scope: !425)
!435 = distinct !DISubprogram(name: "queue_register", scope: !44, file: !44, line: 123, type: !436, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!436 = !DISubroutineType(types: !437)
!437 = !{null, !5, !428}
!438 = !DILocalVariable(name: "tid", arg: 1, scope: !435, file: !44, line: 123, type: !5)
!439 = !DILocation(line: 123, column: 24, scope: !435)
!440 = !DILocalVariable(name: "q", arg: 2, scope: !435, file: !44, line: 123, type: !428)
!441 = !DILocation(line: 123, column: 38, scope: !435)
!442 = !DILocation(line: 125, column: 14, scope: !435)
!443 = !DILocation(line: 125, column: 5, scope: !435)
!444 = !DILocation(line: 126, column: 5, scope: !435)
!445 = !DILocation(line: 126, column: 5, scope: !446)
!446 = distinct !DILexicalBlock(scope: !435, file: !44, line: 126, column: 5)
!447 = !DILocation(line: 126, column: 5, scope: !448)
!448 = distinct !DILexicalBlock(scope: !446, file: !44, line: 126, column: 5)
!449 = !DILocation(line: 126, column: 5, scope: !450)
!450 = distinct !DILexicalBlock(scope: !448, file: !44, line: 126, column: 5)
!451 = !DILocation(line: 127, column: 1, scope: !435)
!452 = distinct !DISubprogram(name: "queue_deregister", scope: !44, file: !44, line: 139, type: !436, scopeLine: 140, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!453 = !DILocalVariable(name: "tid", arg: 1, scope: !452, file: !44, line: 139, type: !5)
!454 = !DILocation(line: 139, column: 26, scope: !452)
!455 = !DILocalVariable(name: "q", arg: 2, scope: !452, file: !44, line: 139, type: !428)
!456 = !DILocation(line: 139, column: 40, scope: !452)
!457 = !DILocation(line: 144, column: 16, scope: !452)
!458 = !DILocation(line: 144, column: 5, scope: !452)
!459 = !DILocation(line: 145, column: 5, scope: !452)
!460 = !DILocation(line: 145, column: 5, scope: !461)
!461 = distinct !DILexicalBlock(scope: !452, file: !44, line: 145, column: 5)
!462 = !DILocation(line: 145, column: 5, scope: !463)
!463 = distinct !DILexicalBlock(scope: !461, file: !44, line: 145, column: 5)
!464 = !DILocation(line: 145, column: 5, scope: !465)
!465 = distinct !DILexicalBlock(scope: !463, file: !44, line: 145, column: 5)
!466 = !DILocation(line: 146, column: 1, scope: !452)
!467 = distinct !DISubprogram(name: "queue_destroy", scope: !44, file: !44, line: 149, type: !426, scopeLine: 150, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!468 = !DILocalVariable(name: "q", arg: 1, scope: !467, file: !44, line: 149, type: !428)
!469 = !DILocation(line: 149, column: 24, scope: !467)
!470 = !DILocalVariable(name: "data", scope: !467, file: !44, line: 151, type: !13)
!471 = !DILocation(line: 151, column: 11, scope: !467)
!472 = !DILocation(line: 156, column: 5, scope: !467)
!473 = !DILocation(line: 156, column: 33, scope: !467)
!474 = !DILocation(line: 156, column: 19, scope: !467)
!475 = !DILocation(line: 156, column: 17, scope: !467)
!476 = !DILocation(line: 156, column: 59, scope: !467)
!477 = !DILocation(line: 157, column: 14, scope: !478)
!478 = distinct !DILexicalBlock(scope: !467, file: !44, line: 156, column: 65)
!479 = !DILocation(line: 157, column: 9, scope: !478)
!480 = distinct !{!480, !472, !481, !482}
!481 = !DILocation(line: 158, column: 5, scope: !467)
!482 = !{!"llvm.loop.mustprogress"}
!483 = !DILocation(line: 159, column: 23, scope: !467)
!484 = !DILocation(line: 159, column: 5, scope: !467)
!485 = !DILocation(line: 165, column: 5, scope: !467)
!486 = !DILocation(line: 166, column: 5, scope: !487)
!487 = distinct !DILexicalBlock(scope: !488, file: !44, line: 166, column: 5)
!488 = distinct !DILexicalBlock(scope: !467, file: !44, line: 166, column: 5)
!489 = !DILocation(line: 166, column: 5, scope: !488)
!490 = !DILocation(line: 167, column: 1, scope: !467)
!491 = distinct !DISubprogram(name: "queue_enq", scope: !44, file: !44, line: 170, type: !492, scopeLine: 171, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!492 = !DISubroutineType(types: !493)
!493 = !{null, !5, !428, !84, !101}
!494 = !DILocalVariable(name: "tid", arg: 1, scope: !491, file: !44, line: 170, type: !5)
!495 = !DILocation(line: 170, column: 19, scope: !491)
!496 = !DILocalVariable(name: "q", arg: 2, scope: !491, file: !44, line: 170, type: !428)
!497 = !DILocation(line: 170, column: 33, scope: !491)
!498 = !DILocalVariable(name: "key", arg: 3, scope: !491, file: !44, line: 170, type: !84)
!499 = !DILocation(line: 170, column: 46, scope: !491)
!500 = !DILocalVariable(name: "lbl", arg: 4, scope: !491, file: !44, line: 170, type: !101)
!501 = !DILocation(line: 170, column: 56, scope: !491)
!502 = !DILocalVariable(name: "data", scope: !491, file: !44, line: 172, type: !95)
!503 = !DILocation(line: 172, column: 13, scope: !491)
!504 = !DILocation(line: 172, column: 20, scope: !491)
!505 = !DILocation(line: 173, column: 9, scope: !506)
!506 = distinct !DILexicalBlock(scope: !491, file: !44, line: 173, column: 9)
!507 = !DILocation(line: 173, column: 9, scope: !491)
!508 = !DILocation(line: 174, column: 31, scope: !509)
!509 = distinct !DILexicalBlock(scope: !506, file: !44, line: 173, column: 15)
!510 = !DILocation(line: 174, column: 9, scope: !509)
!511 = !DILocation(line: 174, column: 15, scope: !509)
!512 = !DILocation(line: 174, column: 29, scope: !509)
!513 = !DILocation(line: 175, column: 31, scope: !509)
!514 = !DILocation(line: 175, column: 9, scope: !509)
!515 = !DILocation(line: 175, column: 15, scope: !509)
!516 = !DILocation(line: 175, column: 29, scope: !509)
!517 = !DILocalVariable(name: "qnode", scope: !509, file: !44, line: 176, type: !518)
!518 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !519, size: 64)
!519 = !DIDerivedType(tag: DW_TAG_typedef, name: "queue_node_t", file: !44, line: 42, baseType: !32)
!520 = !DILocation(line: 176, column: 23, scope: !509)
!521 = !DILocation(line: 190, column: 17, scope: !509)
!522 = !DILocation(line: 190, column: 15, scope: !509)
!523 = !DILocation(line: 192, column: 20, scope: !509)
!524 = !DILocation(line: 192, column: 9, scope: !509)
!525 = !DILocation(line: 193, column: 23, scope: !509)
!526 = !DILocation(line: 193, column: 26, scope: !509)
!527 = !DILocation(line: 193, column: 33, scope: !509)
!528 = !DILocation(line: 193, column: 9, scope: !509)
!529 = !DILocation(line: 194, column: 19, scope: !509)
!530 = !DILocation(line: 194, column: 9, scope: !509)
!531 = !DILocation(line: 195, column: 5, scope: !509)
!532 = !DILocation(line: 196, column: 9, scope: !533)
!533 = distinct !DILexicalBlock(scope: !534, file: !44, line: 196, column: 9)
!534 = distinct !DILexicalBlock(scope: !535, file: !44, line: 196, column: 9)
!535 = distinct !DILexicalBlock(scope: !506, file: !44, line: 195, column: 12)
!536 = !DILocation(line: 198, column: 1, scope: !491)
!537 = distinct !DISubprogram(name: "queue_deq", scope: !44, file: !44, line: 219, type: !538, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!538 = !DISubroutineType(types: !539)
!539 = !{!13, !5, !428}
!540 = !DILocalVariable(name: "tid", arg: 1, scope: !537, file: !44, line: 219, type: !5)
!541 = !DILocation(line: 219, column: 19, scope: !537)
!542 = !DILocalVariable(name: "q", arg: 2, scope: !537, file: !44, line: 219, type: !428)
!543 = !DILocation(line: 219, column: 33, scope: !537)
!544 = !DILocation(line: 221, column: 16, scope: !537)
!545 = !DILocation(line: 221, column: 5, scope: !537)
!546 = !DILocalVariable(name: "data", scope: !537, file: !44, line: 222, type: !13)
!547 = !DILocation(line: 222, column: 11, scope: !537)
!548 = !DILocation(line: 222, column: 32, scope: !537)
!549 = !DILocation(line: 222, column: 58, scope: !537)
!550 = !DILocation(line: 222, column: 50, scope: !537)
!551 = !DILocation(line: 222, column: 18, scope: !537)
!552 = !DILocation(line: 223, column: 15, scope: !537)
!553 = !DILocation(line: 223, column: 5, scope: !537)
!554 = !DILocation(line: 224, column: 12, scope: !537)
!555 = !DILocation(line: 224, column: 5, scope: !537)
!556 = distinct !DISubprogram(name: "empty", scope: !91, file: !91, line: 106, type: !557, scopeLine: 107, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!557 = !DISubroutineType(types: !558)
!558 = !{!24, !5}
!559 = !DILocalVariable(name: "tid", arg: 1, scope: !556, file: !91, line: 106, type: !5)
!560 = !DILocation(line: 106, column: 15, scope: !556)
!561 = !DILocation(line: 108, column: 24, scope: !556)
!562 = !DILocation(line: 108, column: 12, scope: !556)
!563 = !DILocation(line: 108, column: 5, scope: !556)
!564 = distinct !DISubprogram(name: "queue_empty", scope: !44, file: !44, line: 210, type: !565, scopeLine: 211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!565 = !DISubroutineType(types: !566)
!566 = !{!24, !5, !428}
!567 = !DILocalVariable(name: "tid", arg: 1, scope: !564, file: !44, line: 210, type: !5)
!568 = !DILocation(line: 210, column: 21, scope: !564)
!569 = !DILocalVariable(name: "q", arg: 2, scope: !564, file: !44, line: 210, type: !428)
!570 = !DILocation(line: 210, column: 35, scope: !564)
!571 = !DILocation(line: 212, column: 16, scope: !564)
!572 = !DILocation(line: 212, column: 5, scope: !564)
!573 = !DILocalVariable(name: "empty", scope: !564, file: !44, line: 213, type: !24)
!574 = !DILocation(line: 213, column: 13, scope: !564)
!575 = !DILocation(line: 213, column: 37, scope: !564)
!576 = !DILocation(line: 213, column: 21, scope: !564)
!577 = !DILocation(line: 214, column: 15, scope: !564)
!578 = !DILocation(line: 214, column: 5, scope: !564)
!579 = !DILocation(line: 215, column: 12, scope: !564)
!580 = !DILocation(line: 215, column: 5, scope: !564)
!581 = distinct !DISubprogram(name: "ismr_recycle", scope: !50, file: !50, line: 114, type: !182, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!582 = !DILocalVariable(name: "tid", arg: 1, scope: !581, file: !50, line: 114, type: !5)
!583 = !DILocation(line: 114, column: 22, scope: !581)
!584 = !DILocation(line: 116, column: 5, scope: !581)
!585 = !DILocation(line: 116, column: 5, scope: !586)
!586 = distinct !DILexicalBlock(scope: !581, file: !50, line: 116, column: 5)
!587 = !DILocation(line: 116, column: 5, scope: !588)
!588 = distinct !DILexicalBlock(scope: !586, file: !50, line: 116, column: 5)
!589 = !DILocation(line: 116, column: 5, scope: !590)
!590 = distinct !DILexicalBlock(scope: !588, file: !50, line: 116, column: 5)
!591 = !DILocation(line: 117, column: 1, scope: !581)
!592 = distinct !DISubprogram(name: "create_threads", scope: !16, file: !16, line: 83, type: !593, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!593 = !DISubroutineType(types: !594)
!594 = !{null, !14, !5, !27, !24}
!595 = !DILocalVariable(name: "threads", arg: 1, scope: !592, file: !16, line: 83, type: !14)
!596 = !DILocation(line: 83, column: 28, scope: !592)
!597 = !DILocalVariable(name: "num_threads", arg: 2, scope: !592, file: !16, line: 83, type: !5)
!598 = !DILocation(line: 83, column: 45, scope: !592)
!599 = !DILocalVariable(name: "fun", arg: 3, scope: !592, file: !16, line: 83, type: !27)
!600 = !DILocation(line: 83, column: 71, scope: !592)
!601 = !DILocalVariable(name: "bind", arg: 4, scope: !592, file: !16, line: 84, type: !24)
!602 = !DILocation(line: 84, column: 24, scope: !592)
!603 = !DILocalVariable(name: "i", scope: !592, file: !16, line: 86, type: !5)
!604 = !DILocation(line: 86, column: 13, scope: !592)
!605 = !DILocation(line: 87, column: 12, scope: !606)
!606 = distinct !DILexicalBlock(scope: !592, file: !16, line: 87, column: 5)
!607 = !DILocation(line: 87, column: 10, scope: !606)
!608 = !DILocation(line: 87, column: 17, scope: !609)
!609 = distinct !DILexicalBlock(scope: !606, file: !16, line: 87, column: 5)
!610 = !DILocation(line: 87, column: 21, scope: !609)
!611 = !DILocation(line: 87, column: 19, scope: !609)
!612 = !DILocation(line: 87, column: 5, scope: !606)
!613 = !DILocation(line: 88, column: 40, scope: !614)
!614 = distinct !DILexicalBlock(scope: !609, file: !16, line: 87, column: 39)
!615 = !DILocation(line: 88, column: 9, scope: !614)
!616 = !DILocation(line: 88, column: 17, scope: !614)
!617 = !DILocation(line: 88, column: 20, scope: !614)
!618 = !DILocation(line: 88, column: 38, scope: !614)
!619 = !DILocation(line: 89, column: 40, scope: !614)
!620 = !DILocation(line: 89, column: 9, scope: !614)
!621 = !DILocation(line: 89, column: 17, scope: !614)
!622 = !DILocation(line: 89, column: 20, scope: !614)
!623 = !DILocation(line: 89, column: 38, scope: !614)
!624 = !DILocation(line: 90, column: 40, scope: !614)
!625 = !DILocation(line: 90, column: 9, scope: !614)
!626 = !DILocation(line: 90, column: 17, scope: !614)
!627 = !DILocation(line: 90, column: 20, scope: !614)
!628 = !DILocation(line: 90, column: 38, scope: !614)
!629 = !DILocation(line: 91, column: 25, scope: !614)
!630 = !DILocation(line: 91, column: 33, scope: !614)
!631 = !DILocation(line: 91, column: 36, scope: !614)
!632 = !DILocation(line: 91, column: 55, scope: !614)
!633 = !DILocation(line: 91, column: 63, scope: !614)
!634 = !DILocation(line: 91, column: 54, scope: !614)
!635 = !DILocation(line: 91, column: 9, scope: !614)
!636 = !DILocation(line: 92, column: 5, scope: !614)
!637 = !DILocation(line: 87, column: 35, scope: !609)
!638 = !DILocation(line: 87, column: 5, scope: !609)
!639 = distinct !{!639, !612, !640, !482}
!640 = !DILocation(line: 92, column: 5, scope: !606)
!641 = !DILocation(line: 94, column: 1, scope: !592)
!642 = distinct !DISubprogram(name: "await_threads", scope: !16, file: !16, line: 97, type: !643, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!643 = !DISubroutineType(types: !644)
!644 = !{null, !14, !5}
!645 = !DILocalVariable(name: "threads", arg: 1, scope: !642, file: !16, line: 97, type: !14)
!646 = !DILocation(line: 97, column: 27, scope: !642)
!647 = !DILocalVariable(name: "num_threads", arg: 2, scope: !642, file: !16, line: 97, type: !5)
!648 = !DILocation(line: 97, column: 44, scope: !642)
!649 = !DILocalVariable(name: "i", scope: !642, file: !16, line: 99, type: !5)
!650 = !DILocation(line: 99, column: 13, scope: !642)
!651 = !DILocation(line: 100, column: 12, scope: !652)
!652 = distinct !DILexicalBlock(scope: !642, file: !16, line: 100, column: 5)
!653 = !DILocation(line: 100, column: 10, scope: !652)
!654 = !DILocation(line: 100, column: 17, scope: !655)
!655 = distinct !DILexicalBlock(scope: !652, file: !16, line: 100, column: 5)
!656 = !DILocation(line: 100, column: 21, scope: !655)
!657 = !DILocation(line: 100, column: 19, scope: !655)
!658 = !DILocation(line: 100, column: 5, scope: !652)
!659 = !DILocation(line: 101, column: 22, scope: !660)
!660 = distinct !DILexicalBlock(scope: !655, file: !16, line: 100, column: 39)
!661 = !DILocation(line: 101, column: 30, scope: !660)
!662 = !DILocation(line: 101, column: 33, scope: !660)
!663 = !DILocation(line: 101, column: 9, scope: !660)
!664 = !DILocation(line: 102, column: 5, scope: !660)
!665 = !DILocation(line: 100, column: 35, scope: !655)
!666 = !DILocation(line: 100, column: 5, scope: !655)
!667 = distinct !{!667, !658, !668, !482}
!668 = !DILocation(line: 102, column: 5, scope: !652)
!669 = !DILocation(line: 103, column: 1, scope: !642)
!670 = distinct !DISubprogram(name: "common_run", scope: !16, file: !16, line: 43, type: !29, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!671 = !DILocalVariable(name: "args", arg: 1, scope: !670, file: !16, line: 43, type: !13)
!672 = !DILocation(line: 43, column: 18, scope: !670)
!673 = !DILocalVariable(name: "run_info", scope: !670, file: !16, line: 45, type: !14)
!674 = !DILocation(line: 45, column: 17, scope: !670)
!675 = !DILocation(line: 45, column: 42, scope: !670)
!676 = !DILocation(line: 45, column: 28, scope: !670)
!677 = !DILocation(line: 47, column: 9, scope: !678)
!678 = distinct !DILexicalBlock(scope: !670, file: !16, line: 47, column: 9)
!679 = !DILocation(line: 47, column: 19, scope: !678)
!680 = !DILocation(line: 47, column: 9, scope: !670)
!681 = !DILocation(line: 48, column: 26, scope: !678)
!682 = !DILocation(line: 48, column: 36, scope: !678)
!683 = !DILocation(line: 48, column: 9, scope: !678)
!684 = !DILocation(line: 52, column: 12, scope: !670)
!685 = !DILocation(line: 52, column: 22, scope: !670)
!686 = !DILocation(line: 52, column: 38, scope: !670)
!687 = !DILocation(line: 52, column: 48, scope: !670)
!688 = !DILocation(line: 52, column: 30, scope: !670)
!689 = !DILocation(line: 52, column: 5, scope: !670)
!690 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !16, file: !16, line: 61, type: !182, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!691 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !690, file: !16, line: 61, type: !5)
!692 = !DILocation(line: 61, column: 26, scope: !690)
!693 = !DILocation(line: 78, column: 5, scope: !690)
!694 = !DILocation(line: 78, column: 5, scope: !695)
!695 = distinct !DILexicalBlock(scope: !690, file: !16, line: 78, column: 5)
!696 = !DILocation(line: 78, column: 5, scope: !697)
!697 = distinct !DILexicalBlock(scope: !695, file: !16, line: 78, column: 5)
!698 = !DILocation(line: 78, column: 5, scope: !699)
!699 = distinct !DILexicalBlock(scope: !697, file: !16, line: 78, column: 5)
!700 = !DILocation(line: 80, column: 1, scope: !690)
!701 = distinct !DISubprogram(name: "_vqueue_ub_visit_nodes", scope: !33, file: !33, line: 233, type: !702, scopeLine: 235, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!702 = !DISubroutineType(types: !703)
!703 = !{null, !379, !704, !13}
!704 = !DIDerivedType(tag: DW_TAG_typedef, name: "vqueue_ub_node_handler_t", file: !705, line: 9, baseType: !706)
!705 = !DIFile(filename: "datastruct/queue/unbounded/include/vsync/queue/internal/ub/vqueue_ub_common.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "bc5763170bb9d2e4aa9aa1f04b243580")
!706 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !707, size: 64)
!707 = !DISubroutineType(types: !708)
!708 = !{null, !709, !13}
!709 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!710 = !DILocalVariable(name: "q", arg: 1, scope: !701, file: !33, line: 233, type: !379)
!711 = !DILocation(line: 233, column: 37, scope: !701)
!712 = !DILocalVariable(name: "visitor", arg: 2, scope: !701, file: !33, line: 233, type: !704)
!713 = !DILocation(line: 233, column: 65, scope: !701)
!714 = !DILocalVariable(name: "arg", arg: 3, scope: !701, file: !33, line: 234, type: !13)
!715 = !DILocation(line: 234, column: 30, scope: !701)
!716 = !DILocalVariable(name: "curr", scope: !701, file: !33, line: 236, type: !31)
!717 = !DILocation(line: 236, column: 23, scope: !701)
!718 = !DILocalVariable(name: "next", scope: !701, file: !33, line: 237, type: !31)
!719 = !DILocation(line: 237, column: 23, scope: !701)
!720 = !DILocation(line: 239, column: 12, scope: !701)
!721 = !DILocation(line: 239, column: 15, scope: !701)
!722 = !DILocation(line: 239, column: 10, scope: !701)
!723 = !DILocation(line: 241, column: 53, scope: !701)
!724 = !DILocation(line: 241, column: 59, scope: !701)
!725 = !DILocation(line: 241, column: 32, scope: !701)
!726 = !DILocation(line: 241, column: 12, scope: !701)
!727 = !DILocation(line: 241, column: 10, scope: !701)
!728 = !DILocation(line: 243, column: 5, scope: !701)
!729 = !DILocation(line: 243, column: 12, scope: !701)
!730 = !DILocation(line: 244, column: 57, scope: !731)
!731 = distinct !DILexicalBlock(scope: !701, file: !33, line: 243, column: 18)
!732 = !DILocation(line: 244, column: 63, scope: !731)
!733 = !DILocation(line: 244, column: 36, scope: !731)
!734 = !DILocation(line: 244, column: 16, scope: !731)
!735 = !DILocation(line: 244, column: 14, scope: !731)
!736 = !DILocation(line: 245, column: 9, scope: !731)
!737 = !DILocation(line: 245, column: 17, scope: !731)
!738 = !DILocation(line: 245, column: 23, scope: !731)
!739 = !DILocation(line: 246, column: 16, scope: !731)
!740 = !DILocation(line: 246, column: 14, scope: !731)
!741 = distinct !{!741, !728, !742, !482}
!742 = !DILocation(line: 247, column: 5, scope: !701)
!743 = !DILocation(line: 248, column: 1, scope: !701)
!744 = distinct !DISubprogram(name: "_redirect_print", scope: !44, file: !44, line: 229, type: !745, scopeLine: 230, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!745 = !DISubroutineType(types: !746)
!746 = !{null, !31, !13}
!747 = !DILocalVariable(name: "qnode", arg: 1, scope: !744, file: !44, line: 229, type: !31)
!748 = !DILocation(line: 229, column: 35, scope: !744)
!749 = !DILocalVariable(name: "arg", arg: 2, scope: !744, file: !44, line: 229, type: !13)
!750 = !DILocation(line: 229, column: 48, scope: !744)
!751 = !DILocalVariable(name: "print", scope: !744, file: !44, line: 231, type: !43)
!752 = !DILocation(line: 231, column: 17, scope: !744)
!753 = !DILocation(line: 231, column: 38, scope: !744)
!754 = !DILocation(line: 231, column: 25, scope: !744)
!755 = !DILocation(line: 232, column: 5, scope: !744)
!756 = !DILocation(line: 232, column: 11, scope: !744)
!757 = !DILocation(line: 232, column: 18, scope: !744)
!758 = !DILocation(line: 233, column: 1, scope: !744)
!759 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !760, file: !760, line: 197, type: !761, scopeLine: 198, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!760 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!761 = !DISubroutineType(types: !762)
!762 = !{!13, !763}
!763 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !764, size: 64)
!764 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !38)
!765 = !DILocalVariable(name: "a", arg: 1, scope: !759, file: !760, line: 197, type: !763)
!766 = !DILocation(line: 197, column: 41, scope: !759)
!767 = !DILocalVariable(name: "val", scope: !759, file: !760, line: 199, type: !13)
!768 = !DILocation(line: 199, column: 11, scope: !759)
!769 = !DILocation(line: 202, column: 32, scope: !759)
!770 = !DILocation(line: 202, column: 35, scope: !759)
!771 = !DILocation(line: 200, column: 5, scope: !759)
!772 = !{i64 852631}
!773 = !DILocation(line: 204, column: 12, scope: !759)
!774 = !DILocation(line: 204, column: 5, scope: !759)
!775 = distinct !DISubprogram(name: "vmem_get_alloc_count", scope: !79, file: !79, line: 90, type: !776, scopeLine: 91, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!776 = !DISubroutineType(types: !777)
!777 = !{!84}
!778 = !DILocalVariable(name: "alloc_count", scope: !775, file: !79, line: 93, type: !84)
!779 = !DILocation(line: 93, column: 15, scope: !775)
!780 = !DILocation(line: 93, column: 29, scope: !775)
!781 = !DILocation(line: 94, column: 5, scope: !775)
!782 = !DILocation(line: 94, column: 5, scope: !783)
!783 = distinct !DILexicalBlock(scope: !775, file: !79, line: 94, column: 5)
!784 = !DILocation(line: 94, column: 5, scope: !785)
!785 = distinct !DILexicalBlock(scope: !783, file: !79, line: 94, column: 5)
!786 = !DILocation(line: 94, column: 5, scope: !787)
!787 = distinct !DILexicalBlock(scope: !785, file: !79, line: 94, column: 5)
!788 = !DILocation(line: 95, column: 12, scope: !775)
!789 = !DILocation(line: 95, column: 5, scope: !775)
!790 = distinct !DISubprogram(name: "vmem_get_free_count", scope: !79, file: !79, line: 104, type: !776, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!791 = !DILocalVariable(name: "free_count", scope: !790, file: !79, line: 107, type: !84)
!792 = !DILocation(line: 107, column: 15, scope: !790)
!793 = !DILocation(line: 107, column: 28, scope: !790)
!794 = !DILocation(line: 108, column: 5, scope: !790)
!795 = !DILocation(line: 108, column: 5, scope: !796)
!796 = distinct !DILexicalBlock(scope: !790, file: !79, line: 108, column: 5)
!797 = !DILocation(line: 108, column: 5, scope: !798)
!798 = distinct !DILexicalBlock(scope: !796, file: !79, line: 108, column: 5)
!799 = !DILocation(line: 108, column: 5, scope: !800)
!800 = distinct !DILexicalBlock(scope: !798, file: !79, line: 108, column: 5)
!801 = !DILocation(line: 109, column: 12, scope: !790)
!802 = !DILocation(line: 109, column: 5, scope: !790)
!803 = distinct !DISubprogram(name: "vatomic64_read_rlx", scope: !760, file: !760, line: 149, type: !804, scopeLine: 150, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!804 = !DISubroutineType(types: !805)
!805 = !{!84, !806}
!806 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !807, size: 64)
!807 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !80)
!808 = !DILocalVariable(name: "a", arg: 1, scope: !803, file: !760, line: 149, type: !806)
!809 = !DILocation(line: 149, column: 39, scope: !803)
!810 = !DILocalVariable(name: "val", scope: !803, file: !760, line: 151, type: !84)
!811 = !DILocation(line: 151, column: 15, scope: !803)
!812 = !DILocation(line: 154, column: 32, scope: !803)
!813 = !DILocation(line: 154, column: 35, scope: !803)
!814 = !DILocation(line: 152, column: 5, scope: !803)
!815 = !{i64 851148}
!816 = !DILocation(line: 156, column: 12, scope: !803)
!817 = !DILocation(line: 156, column: 5, scope: !803)
!818 = distinct !DISubprogram(name: "ismr_init", scope: !50, file: !50, line: 35, type: !237, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!819 = !DILocation(line: 37, column: 5, scope: !818)
!820 = !DILocation(line: 38, column: 1, scope: !818)
!821 = distinct !DISubprogram(name: "vqueue_ub_init", scope: !33, file: !33, line: 76, type: !822, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!822 = !DISubroutineType(types: !823)
!823 = !{null, !379}
!824 = !DILocalVariable(name: "q", arg: 1, scope: !821, file: !33, line: 76, type: !379)
!825 = !DILocation(line: 76, column: 29, scope: !821)
!826 = !DILocation(line: 78, column: 16, scope: !821)
!827 = !DILocation(line: 78, column: 19, scope: !821)
!828 = !DILocation(line: 78, column: 5, scope: !821)
!829 = !DILocation(line: 78, column: 8, scope: !821)
!830 = !DILocation(line: 78, column: 13, scope: !821)
!831 = !DILocation(line: 79, column: 16, scope: !821)
!832 = !DILocation(line: 79, column: 19, scope: !821)
!833 = !DILocation(line: 79, column: 5, scope: !821)
!834 = !DILocation(line: 79, column: 8, scope: !821)
!835 = !DILocation(line: 79, column: 13, scope: !821)
!836 = !DILocation(line: 81, column: 27, scope: !821)
!837 = !DILocation(line: 81, column: 30, scope: !821)
!838 = !DILocation(line: 81, column: 5, scope: !821)
!839 = !DILocation(line: 83, column: 22, scope: !821)
!840 = !DILocation(line: 83, column: 25, scope: !821)
!841 = !DILocation(line: 83, column: 5, scope: !821)
!842 = !DILocation(line: 84, column: 22, scope: !821)
!843 = !DILocation(line: 84, column: 25, scope: !821)
!844 = !DILocation(line: 84, column: 5, scope: !821)
!845 = !DILocation(line: 85, column: 1, scope: !821)
!846 = distinct !DISubprogram(name: "locked_trace_init", scope: !107, file: !107, line: 14, type: !847, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!847 = !DISubroutineType(types: !848)
!848 = !{null, !849, !5}
!849 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !106, size: 64)
!850 = !DILocalVariable(name: "trace", arg: 1, scope: !846, file: !107, line: 14, type: !849)
!851 = !DILocation(line: 14, column: 35, scope: !846)
!852 = !DILocalVariable(name: "capacity", arg: 2, scope: !846, file: !107, line: 14, type: !5)
!853 = !DILocation(line: 14, column: 50, scope: !846)
!854 = !DILocation(line: 16, column: 5, scope: !855)
!855 = distinct !DILexicalBlock(scope: !856, file: !107, line: 16, column: 5)
!856 = distinct !DILexicalBlock(scope: !846, file: !107, line: 16, column: 5)
!857 = !DILocation(line: 16, column: 5, scope: !856)
!858 = !DILocation(line: 17, column: 25, scope: !846)
!859 = !DILocation(line: 17, column: 32, scope: !846)
!860 = !DILocation(line: 17, column: 5, scope: !846)
!861 = !DILocation(line: 18, column: 17, scope: !846)
!862 = !DILocation(line: 18, column: 24, scope: !846)
!863 = !DILocation(line: 18, column: 31, scope: !846)
!864 = !DILocation(line: 18, column: 5, scope: !846)
!865 = !DILocation(line: 19, column: 1, scope: !846)
!866 = distinct !DISubprogram(name: "trace_init", scope: !112, file: !112, line: 28, type: !867, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!867 = !DISubroutineType(types: !868)
!868 = !{null, !869, !5}
!869 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !111, size: 64)
!870 = !DILocalVariable(name: "trace", arg: 1, scope: !866, file: !112, line: 28, type: !869)
!871 = !DILocation(line: 28, column: 21, scope: !866)
!872 = !DILocalVariable(name: "capacity", arg: 2, scope: !866, file: !112, line: 28, type: !5)
!873 = !DILocation(line: 28, column: 36, scope: !866)
!874 = !DILocation(line: 30, column: 5, scope: !875)
!875 = distinct !DILexicalBlock(scope: !876, file: !112, line: 30, column: 5)
!876 = distinct !DILexicalBlock(scope: !866, file: !112, line: 30, column: 5)
!877 = !DILocation(line: 30, column: 5, scope: !876)
!878 = !DILocation(line: 31, column: 27, scope: !866)
!879 = !DILocation(line: 31, column: 36, scope: !866)
!880 = !DILocation(line: 31, column: 20, scope: !866)
!881 = !DILocation(line: 31, column: 5, scope: !866)
!882 = !DILocation(line: 31, column: 12, scope: !866)
!883 = !DILocation(line: 31, column: 18, scope: !866)
!884 = !DILocation(line: 32, column: 9, scope: !885)
!885 = distinct !DILexicalBlock(scope: !866, file: !112, line: 32, column: 9)
!886 = !DILocation(line: 32, column: 16, scope: !885)
!887 = !DILocation(line: 32, column: 9, scope: !866)
!888 = !DILocation(line: 33, column: 9, scope: !889)
!889 = distinct !DILexicalBlock(scope: !885, file: !112, line: 32, column: 23)
!890 = !DILocation(line: 33, column: 16, scope: !889)
!891 = !DILocation(line: 33, column: 28, scope: !889)
!892 = !DILocation(line: 34, column: 30, scope: !889)
!893 = !DILocation(line: 34, column: 9, scope: !889)
!894 = !DILocation(line: 34, column: 16, scope: !889)
!895 = !DILocation(line: 34, column: 28, scope: !889)
!896 = !DILocation(line: 35, column: 9, scope: !889)
!897 = !DILocation(line: 35, column: 16, scope: !889)
!898 = !DILocation(line: 35, column: 28, scope: !889)
!899 = !DILocation(line: 36, column: 5, scope: !889)
!900 = !DILocation(line: 37, column: 9, scope: !901)
!901 = distinct !DILexicalBlock(scope: !885, file: !112, line: 36, column: 12)
!902 = !DILocation(line: 37, column: 16, scope: !901)
!903 = !DILocation(line: 37, column: 28, scope: !901)
!904 = !DILocation(line: 38, column: 9, scope: !901)
!905 = !DILocation(line: 38, column: 16, scope: !901)
!906 = !DILocation(line: 38, column: 28, scope: !901)
!907 = !DILocation(line: 39, column: 9, scope: !901)
!908 = !DILocation(line: 39, column: 16, scope: !901)
!909 = !DILocation(line: 39, column: 28, scope: !901)
!910 = !DILocation(line: 40, column: 9, scope: !911)
!911 = distinct !DILexicalBlock(scope: !912, file: !112, line: 40, column: 9)
!912 = distinct !DILexicalBlock(scope: !901, file: !112, line: 40, column: 9)
!913 = !DILocation(line: 42, column: 1, scope: !866)
!914 = distinct !DISubprogram(name: "_vqueue_ub_node_init", scope: !33, file: !33, line: 219, type: !745, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!915 = !DILocalVariable(name: "qnode", arg: 1, scope: !914, file: !33, line: 219, type: !31)
!916 = !DILocation(line: 219, column: 40, scope: !914)
!917 = !DILocalVariable(name: "data", arg: 2, scope: !914, file: !33, line: 219, type: !13)
!918 = !DILocation(line: 219, column: 53, scope: !914)
!919 = !DILocation(line: 221, column: 19, scope: !914)
!920 = !DILocation(line: 221, column: 5, scope: !914)
!921 = !DILocation(line: 221, column: 12, scope: !914)
!922 = !DILocation(line: 221, column: 17, scope: !914)
!923 = !DILocation(line: 222, column: 27, scope: !914)
!924 = !DILocation(line: 222, column: 34, scope: !914)
!925 = !DILocation(line: 222, column: 5, scope: !914)
!926 = !DILocation(line: 223, column: 1, scope: !914)
!927 = distinct !DISubprogram(name: "queue_lock_init", scope: !33, file: !33, line: 31, type: !928, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!928 = !DISubroutineType(types: !929)
!929 = !{null, !930}
!930 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !163, size: 64)
!931 = !DILocalVariable(name: "l", arg: 1, scope: !927, file: !33, line: 31, type: !930)
!932 = !DILocation(line: 31, column: 1, scope: !927)
!933 = distinct !DISubprogram(name: "vatomicptr_write_rlx", scope: !760, file: !760, line: 325, type: !934, scopeLine: 326, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!934 = !DISubroutineType(types: !935)
!935 = !{null, !936, !13}
!936 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!937 = !DILocalVariable(name: "a", arg: 1, scope: !933, file: !760, line: 325, type: !936)
!938 = !DILocation(line: 325, column: 36, scope: !933)
!939 = !DILocalVariable(name: "v", arg: 2, scope: !933, file: !760, line: 325, type: !13)
!940 = !DILocation(line: 325, column: 45, scope: !933)
!941 = !DILocation(line: 329, column: 32, scope: !933)
!942 = !DILocation(line: 329, column: 44, scope: !933)
!943 = !DILocation(line: 329, column: 47, scope: !933)
!944 = !DILocation(line: 327, column: 5, scope: !933)
!945 = !{i64 856832}
!946 = !DILocation(line: 331, column: 1, scope: !933)
!947 = distinct !DISubprogram(name: "ismr_reg", scope: !50, file: !50, line: 89, type: !182, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!948 = !DILocalVariable(name: "tid", arg: 1, scope: !947, file: !50, line: 89, type: !5)
!949 = !DILocation(line: 89, column: 18, scope: !947)
!950 = !DILocation(line: 91, column: 5, scope: !947)
!951 = !DILocation(line: 91, column: 5, scope: !952)
!952 = distinct !DILexicalBlock(scope: !947, file: !50, line: 91, column: 5)
!953 = !DILocation(line: 91, column: 5, scope: !954)
!954 = distinct !DILexicalBlock(scope: !952, file: !50, line: 91, column: 5)
!955 = !DILocation(line: 91, column: 5, scope: !956)
!956 = distinct !DILexicalBlock(scope: !954, file: !50, line: 91, column: 5)
!957 = !DILocation(line: 92, column: 1, scope: !947)
!958 = distinct !DISubprogram(name: "ismr_dereg", scope: !50, file: !50, line: 95, type: !182, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!959 = !DILocalVariable(name: "tid", arg: 1, scope: !958, file: !50, line: 95, type: !5)
!960 = !DILocation(line: 95, column: 20, scope: !958)
!961 = !DILocation(line: 97, column: 5, scope: !958)
!962 = !DILocation(line: 97, column: 5, scope: !963)
!963 = distinct !DILexicalBlock(scope: !958, file: !50, line: 97, column: 5)
!964 = !DILocation(line: 97, column: 5, scope: !965)
!965 = distinct !DILexicalBlock(scope: !963, file: !50, line: 97, column: 5)
!966 = !DILocation(line: 97, column: 5, scope: !967)
!967 = distinct !DILexicalBlock(scope: !965, file: !50, line: 97, column: 5)
!968 = !DILocation(line: 98, column: 1, scope: !958)
!969 = distinct !DISubprogram(name: "vqueue_ub_deq", scope: !33, file: !33, line: 166, type: !970, scopeLine: 167, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!970 = !DISubroutineType(types: !971)
!971 = !{!13, !379, !704, !13}
!972 = !DILocalVariable(name: "q", arg: 1, scope: !969, file: !33, line: 166, type: !379)
!973 = !DILocation(line: 166, column: 28, scope: !969)
!974 = !DILocalVariable(name: "retire", arg: 2, scope: !969, file: !33, line: 166, type: !704)
!975 = !DILocation(line: 166, column: 56, scope: !969)
!976 = !DILocalVariable(name: "retire_arg", arg: 3, scope: !969, file: !33, line: 166, type: !13)
!977 = !DILocation(line: 166, column: 70, scope: !969)
!978 = !DILocalVariable(name: "qnode", scope: !969, file: !33, line: 168, type: !31)
!979 = !DILocation(line: 168, column: 23, scope: !969)
!980 = !DILocalVariable(name: "head", scope: !969, file: !33, line: 169, type: !31)
!981 = !DILocation(line: 169, column: 23, scope: !969)
!982 = !DILocalVariable(name: "data", scope: !969, file: !33, line: 170, type: !13)
!983 = !DILocation(line: 170, column: 11, scope: !969)
!984 = !DILocation(line: 172, column: 25, scope: !969)
!985 = !DILocation(line: 172, column: 28, scope: !969)
!986 = !DILocation(line: 172, column: 5, scope: !969)
!987 = !DILocation(line: 174, column: 12, scope: !969)
!988 = !DILocation(line: 174, column: 15, scope: !969)
!989 = !DILocation(line: 174, column: 10, scope: !969)
!990 = !DILocation(line: 176, column: 54, scope: !969)
!991 = !DILocation(line: 176, column: 60, scope: !969)
!992 = !DILocation(line: 176, column: 33, scope: !969)
!993 = !DILocation(line: 176, column: 13, scope: !969)
!994 = !DILocation(line: 176, column: 11, scope: !969)
!995 = !DILocation(line: 177, column: 9, scope: !996)
!996 = distinct !DILexicalBlock(scope: !969, file: !33, line: 177, column: 9)
!997 = !DILocation(line: 177, column: 9, scope: !969)
!998 = !DILocation(line: 178, column: 19, scope: !999)
!999 = distinct !DILexicalBlock(scope: !996, file: !33, line: 177, column: 16)
!1000 = !DILocation(line: 178, column: 26, scope: !999)
!1001 = !DILocation(line: 178, column: 17, scope: !999)
!1002 = !DILocation(line: 179, column: 19, scope: !999)
!1003 = !DILocation(line: 179, column: 9, scope: !999)
!1004 = !DILocation(line: 179, column: 12, scope: !999)
!1005 = !DILocation(line: 179, column: 17, scope: !999)
!1006 = !DILocation(line: 180, column: 13, scope: !1007)
!1007 = distinct !DILexicalBlock(scope: !999, file: !33, line: 180, column: 13)
!1008 = !DILocation(line: 180, column: 22, scope: !1007)
!1009 = !DILocation(line: 180, column: 25, scope: !1007)
!1010 = !DILocation(line: 180, column: 18, scope: !1007)
!1011 = !DILocation(line: 180, column: 13, scope: !999)
!1012 = !DILocation(line: 181, column: 13, scope: !1013)
!1013 = distinct !DILexicalBlock(scope: !1007, file: !33, line: 180, column: 35)
!1014 = !DILocation(line: 181, column: 20, scope: !1013)
!1015 = !DILocation(line: 181, column: 26, scope: !1013)
!1016 = !DILocation(line: 182, column: 9, scope: !1013)
!1017 = !DILocation(line: 183, column: 5, scope: !999)
!1018 = !DILocation(line: 184, column: 25, scope: !969)
!1019 = !DILocation(line: 184, column: 28, scope: !969)
!1020 = !DILocation(line: 184, column: 5, scope: !969)
!1021 = !DILocation(line: 185, column: 12, scope: !969)
!1022 = !DILocation(line: 185, column: 5, scope: !969)
!1023 = distinct !DISubprogram(name: "_queue_destroy", scope: !44, file: !44, line: 67, type: !1024, scopeLine: 68, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1024 = !DISubroutineType(types: !1025)
!1025 = !{null, !518, !13}
!1026 = !DILocalVariable(name: "node", arg: 1, scope: !1023, file: !44, line: 67, type: !518)
!1027 = !DILocation(line: 67, column: 30, scope: !1023)
!1028 = !DILocalVariable(name: "arg", arg: 2, scope: !1023, file: !44, line: 67, type: !13)
!1029 = !DILocation(line: 67, column: 42, scope: !1023)
!1030 = !DILocation(line: 72, column: 15, scope: !1023)
!1031 = !DILocation(line: 72, column: 5, scope: !1023)
!1032 = !DILocation(line: 74, column: 5, scope: !1023)
!1033 = !DILocation(line: 74, column: 5, scope: !1034)
!1034 = distinct !DILexicalBlock(scope: !1023, file: !44, line: 74, column: 5)
!1035 = !DILocation(line: 74, column: 5, scope: !1036)
!1036 = distinct !DILexicalBlock(scope: !1034, file: !44, line: 74, column: 5)
!1037 = !DILocation(line: 74, column: 5, scope: !1038)
!1038 = distinct !DILexicalBlock(scope: !1036, file: !44, line: 74, column: 5)
!1039 = !DILocation(line: 75, column: 1, scope: !1023)
!1040 = distinct !DISubprogram(name: "vqueue_ub_destroy", scope: !33, file: !33, line: 98, type: !702, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1041 = !DILocalVariable(name: "q", arg: 1, scope: !1040, file: !33, line: 98, type: !379)
!1042 = !DILocation(line: 98, column: 32, scope: !1040)
!1043 = !DILocalVariable(name: "retire", arg: 2, scope: !1040, file: !33, line: 98, type: !704)
!1044 = !DILocation(line: 98, column: 60, scope: !1040)
!1045 = !DILocalVariable(name: "retire_arg", arg: 3, scope: !1040, file: !33, line: 99, type: !13)
!1046 = !DILocation(line: 99, column: 25, scope: !1040)
!1047 = !DILocalVariable(name: "curr", scope: !1040, file: !33, line: 101, type: !31)
!1048 = !DILocation(line: 101, column: 23, scope: !1040)
!1049 = !DILocalVariable(name: "next", scope: !1040, file: !33, line: 102, type: !31)
!1050 = !DILocation(line: 102, column: 23, scope: !1040)
!1051 = !DILocation(line: 104, column: 12, scope: !1040)
!1052 = !DILocation(line: 104, column: 15, scope: !1040)
!1053 = !DILocation(line: 104, column: 10, scope: !1040)
!1054 = !DILocation(line: 106, column: 5, scope: !1040)
!1055 = !DILocation(line: 106, column: 12, scope: !1040)
!1056 = !DILocation(line: 107, column: 57, scope: !1057)
!1057 = distinct !DILexicalBlock(scope: !1040, file: !33, line: 106, column: 18)
!1058 = !DILocation(line: 107, column: 63, scope: !1057)
!1059 = !DILocation(line: 107, column: 36, scope: !1057)
!1060 = !DILocation(line: 107, column: 16, scope: !1057)
!1061 = !DILocation(line: 107, column: 14, scope: !1057)
!1062 = !DILocation(line: 108, column: 13, scope: !1063)
!1063 = distinct !DILexicalBlock(scope: !1057, file: !33, line: 108, column: 13)
!1064 = !DILocation(line: 108, column: 22, scope: !1063)
!1065 = !DILocation(line: 108, column: 25, scope: !1063)
!1066 = !DILocation(line: 108, column: 18, scope: !1063)
!1067 = !DILocation(line: 108, column: 13, scope: !1057)
!1068 = !DILocation(line: 109, column: 13, scope: !1069)
!1069 = distinct !DILexicalBlock(scope: !1063, file: !33, line: 108, column: 35)
!1070 = !DILocation(line: 109, column: 20, scope: !1069)
!1071 = !DILocation(line: 109, column: 26, scope: !1069)
!1072 = !DILocation(line: 110, column: 9, scope: !1069)
!1073 = !DILocation(line: 111, column: 16, scope: !1057)
!1074 = !DILocation(line: 111, column: 14, scope: !1057)
!1075 = distinct !{!1075, !1054, !1076, !482}
!1076 = !DILocation(line: 112, column: 5, scope: !1040)
!1077 = !DILocation(line: 113, column: 1, scope: !1040)
!1078 = distinct !DISubprogram(name: "ismr_destroy", scope: !50, file: !50, line: 101, type: !237, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1079 = !DILocation(line: 103, column: 5, scope: !1078)
!1080 = !DILocation(line: 104, column: 1, scope: !1078)
!1081 = distinct !DISubprogram(name: "queue_lock_acquire", scope: !33, file: !33, line: 31, type: !928, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1082 = !DILocalVariable(name: "l", arg: 1, scope: !1081, file: !33, line: 31, type: !930)
!1083 = !DILocation(line: 31, column: 1, scope: !1081)
!1084 = !DILocalVariable(name: "val", scope: !1081, file: !33, line: 31, type: !66)
!1085 = !DILocation(line: 31, column: 1, scope: !1086)
!1086 = distinct !DILexicalBlock(scope: !1087, file: !33, line: 31, column: 1)
!1087 = distinct !DILexicalBlock(scope: !1081, file: !33, line: 31, column: 1)
!1088 = !DILocation(line: 31, column: 1, scope: !1087)
!1089 = distinct !DISubprogram(name: "vatomicptr_read_acq", scope: !760, file: !760, line: 181, type: !761, scopeLine: 182, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1090 = !DILocalVariable(name: "a", arg: 1, scope: !1089, file: !760, line: 181, type: !763)
!1091 = !DILocation(line: 181, column: 41, scope: !1089)
!1092 = !DILocalVariable(name: "val", scope: !1089, file: !760, line: 183, type: !13)
!1093 = !DILocation(line: 183, column: 11, scope: !1089)
!1094 = !DILocation(line: 186, column: 32, scope: !1089)
!1095 = !DILocation(line: 186, column: 35, scope: !1089)
!1096 = !DILocation(line: 184, column: 5, scope: !1089)
!1097 = !{i64 852131}
!1098 = !DILocation(line: 188, column: 12, scope: !1089)
!1099 = !DILocation(line: 188, column: 5, scope: !1089)
!1100 = distinct !DISubprogram(name: "queue_lock_release", scope: !33, file: !33, line: 31, type: !928, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1101 = !DILocalVariable(name: "l", arg: 1, scope: !1100, file: !33, line: 31, type: !930)
!1102 = !DILocation(line: 31, column: 1, scope: !1100)
!1103 = !DILocalVariable(name: "val", scope: !1100, file: !33, line: 31, type: !66)
!1104 = !DILocation(line: 31, column: 1, scope: !1105)
!1105 = distinct !DILexicalBlock(scope: !1106, file: !33, line: 31, column: 1)
!1106 = distinct !DILexicalBlock(scope: !1100, file: !33, line: 31, column: 1)
!1107 = !DILocation(line: 31, column: 1, scope: !1106)
!1108 = distinct !DISubprogram(name: "vmem_free", scope: !79, file: !79, line: 71, type: !46, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1109 = !DILocalVariable(name: "ptr", arg: 1, scope: !1108, file: !79, line: 71, type: !13)
!1110 = !DILocation(line: 71, column: 17, scope: !1108)
!1111 = !DILocation(line: 73, column: 10, scope: !1108)
!1112 = !DILocation(line: 73, column: 5, scope: !1108)
!1113 = !DILocation(line: 74, column: 9, scope: !1114)
!1114 = distinct !DILexicalBlock(scope: !1108, file: !79, line: 74, column: 9)
!1115 = !DILocation(line: 74, column: 9, scope: !1108)
!1116 = !DILocation(line: 76, column: 9, scope: !1117)
!1117 = distinct !DILexicalBlock(scope: !1114, file: !79, line: 74, column: 14)
!1118 = !DILocation(line: 78, column: 5, scope: !1117)
!1119 = !DILocation(line: 79, column: 1, scope: !1108)
!1120 = distinct !DISubprogram(name: "vatomic64_inc_rlx", scope: !1121, file: !1121, line: 3000, type: !1122, scopeLine: 3001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1121 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!1122 = !DISubroutineType(types: !1123)
!1123 = !{null, !1124}
!1124 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!1125 = !DILocalVariable(name: "a", arg: 1, scope: !1120, file: !1121, line: 3000, type: !1124)
!1126 = !DILocation(line: 3000, column: 32, scope: !1120)
!1127 = !DILocation(line: 3002, column: 33, scope: !1120)
!1128 = !DILocation(line: 3002, column: 11, scope: !1120)
!1129 = !DILocation(line: 3003, column: 1, scope: !1120)
!1130 = distinct !DISubprogram(name: "vatomic64_get_inc_rlx", scope: !1121, file: !1121, line: 2560, type: !1131, scopeLine: 2561, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1131 = !DISubroutineType(types: !1132)
!1132 = !{!84, !1124}
!1133 = !DILocalVariable(name: "a", arg: 1, scope: !1130, file: !1121, line: 2560, type: !1124)
!1134 = !DILocation(line: 2560, column: 36, scope: !1130)
!1135 = !DILocation(line: 2562, column: 34, scope: !1130)
!1136 = !DILocation(line: 2562, column: 12, scope: !1130)
!1137 = !DILocation(line: 2562, column: 5, scope: !1130)
!1138 = distinct !DISubprogram(name: "vatomic64_get_add_rlx", scope: !1139, file: !1139, line: 1888, type: !1140, scopeLine: 1889, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1139 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!1140 = !DISubroutineType(types: !1141)
!1141 = !{!84, !1124, !84}
!1142 = !DILocalVariable(name: "a", arg: 1, scope: !1138, file: !1139, line: 1888, type: !1124)
!1143 = !DILocation(line: 1888, column: 36, scope: !1138)
!1144 = !DILocalVariable(name: "v", arg: 2, scope: !1138, file: !1139, line: 1888, type: !84)
!1145 = !DILocation(line: 1888, column: 49, scope: !1138)
!1146 = !DILocalVariable(name: "oldv", scope: !1138, file: !1139, line: 1890, type: !84)
!1147 = !DILocation(line: 1890, column: 15, scope: !1138)
!1148 = !DILocalVariable(name: "tmp", scope: !1138, file: !1139, line: 1891, type: !1149)
!1149 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !6, line: 35, baseType: !1150)
!1150 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !86, line: 26, baseType: !1151)
!1151 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !88, line: 42, baseType: !135)
!1152 = !DILocation(line: 1891, column: 15, scope: !1138)
!1153 = !DILocalVariable(name: "newv", scope: !1138, file: !1139, line: 1892, type: !84)
!1154 = !DILocation(line: 1892, column: 15, scope: !1138)
!1155 = !DILocation(line: 1893, column: 5, scope: !1138)
!1156 = !DILocation(line: 1901, column: 19, scope: !1138)
!1157 = !DILocation(line: 1901, column: 22, scope: !1138)
!1158 = !{i64 961875, i64 961909, i64 961924, i64 961956, i64 961998, i64 962039}
!1159 = !DILocation(line: 1904, column: 12, scope: !1138)
!1160 = !DILocation(line: 1904, column: 5, scope: !1138)
!1161 = distinct !DISubprogram(name: "locked_trace_destroy", scope: !107, file: !107, line: 31, type: !1162, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1162 = !DISubroutineType(types: !1163)
!1163 = !{null, !849, !1164}
!1164 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_verify_unit", file: !112, line: 25, baseType: !1165)
!1165 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1166, size: 64)
!1166 = !DISubroutineType(types: !1167)
!1167 = !{!24, !116}
!1168 = !DILocalVariable(name: "trace", arg: 1, scope: !1161, file: !107, line: 31, type: !849)
!1169 = !DILocation(line: 31, column: 38, scope: !1161)
!1170 = !DILocalVariable(name: "callback", arg: 2, scope: !1161, file: !107, line: 31, type: !1164)
!1171 = !DILocation(line: 31, column: 63, scope: !1161)
!1172 = !DILocation(line: 33, column: 19, scope: !1161)
!1173 = !DILocation(line: 33, column: 26, scope: !1161)
!1174 = !DILocation(line: 33, column: 33, scope: !1161)
!1175 = !DILocation(line: 33, column: 5, scope: !1161)
!1176 = !DILocation(line: 34, column: 20, scope: !1161)
!1177 = !DILocation(line: 34, column: 27, scope: !1161)
!1178 = !DILocation(line: 34, column: 5, scope: !1161)
!1179 = !DILocation(line: 35, column: 28, scope: !1161)
!1180 = !DILocation(line: 35, column: 35, scope: !1161)
!1181 = !DILocation(line: 35, column: 5, scope: !1161)
!1182 = !DILocation(line: 36, column: 1, scope: !1161)
!1183 = distinct !DISubprogram(name: "_ismr_none_destroy_all_cb", scope: !50, file: !50, line: 25, type: !1166, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1184 = !DILocalVariable(name: "unit", arg: 1, scope: !1183, file: !50, line: 25, type: !116)
!1185 = !DILocation(line: 25, column: 41, scope: !1183)
!1186 = !DILocation(line: 27, column: 5, scope: !1187)
!1187 = distinct !DILexicalBlock(scope: !1188, file: !50, line: 27, column: 5)
!1188 = distinct !DILexicalBlock(scope: !1183, file: !50, line: 27, column: 5)
!1189 = !DILocation(line: 27, column: 5, scope: !1188)
!1190 = !DILocalVariable(name: "info", scope: !1183, file: !50, line: 28, type: !48)
!1191 = !DILocation(line: 28, column: 29, scope: !1183)
!1192 = !DILocation(line: 28, column: 62, scope: !1183)
!1193 = !DILocation(line: 28, column: 68, scope: !1183)
!1194 = !DILocation(line: 28, column: 36, scope: !1183)
!1195 = !DILocation(line: 29, column: 5, scope: !1183)
!1196 = !DILocation(line: 29, column: 11, scope: !1183)
!1197 = !DILocation(line: 29, column: 20, scope: !1183)
!1198 = !DILocation(line: 29, column: 26, scope: !1183)
!1199 = !DILocation(line: 29, column: 35, scope: !1183)
!1200 = !DILocation(line: 29, column: 41, scope: !1183)
!1201 = !DILocation(line: 30, column: 10, scope: !1183)
!1202 = !DILocation(line: 30, column: 5, scope: !1183)
!1203 = !DILocation(line: 31, column: 5, scope: !1183)
!1204 = distinct !DISubprogram(name: "trace_verify", scope: !112, file: !112, line: 210, type: !1205, scopeLine: 211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1205 = !DISubroutineType(types: !1206)
!1206 = !{!24, !869, !1164}
!1207 = !DILocalVariable(name: "trace", arg: 1, scope: !1204, file: !112, line: 210, type: !869)
!1208 = !DILocation(line: 210, column: 23, scope: !1204)
!1209 = !DILocalVariable(name: "verify_fun", arg: 2, scope: !1204, file: !112, line: 210, type: !1164)
!1210 = !DILocation(line: 210, column: 48, scope: !1204)
!1211 = !DILocalVariable(name: "i", scope: !1204, file: !112, line: 212, type: !5)
!1212 = !DILocation(line: 212, column: 13, scope: !1204)
!1213 = !DILocation(line: 214, column: 5, scope: !1214)
!1214 = distinct !DILexicalBlock(scope: !1215, file: !112, line: 214, column: 5)
!1215 = distinct !DILexicalBlock(scope: !1204, file: !112, line: 214, column: 5)
!1216 = !DILocation(line: 214, column: 5, scope: !1215)
!1217 = !DILocation(line: 215, column: 5, scope: !1218)
!1218 = distinct !DILexicalBlock(scope: !1219, file: !112, line: 215, column: 5)
!1219 = distinct !DILexicalBlock(scope: !1204, file: !112, line: 215, column: 5)
!1220 = !DILocation(line: 215, column: 5, scope: !1219)
!1221 = !DILocation(line: 216, column: 5, scope: !1222)
!1222 = distinct !DILexicalBlock(scope: !1223, file: !112, line: 216, column: 5)
!1223 = distinct !DILexicalBlock(scope: !1204, file: !112, line: 216, column: 5)
!1224 = !DILocation(line: 216, column: 5, scope: !1223)
!1225 = !DILocation(line: 218, column: 12, scope: !1226)
!1226 = distinct !DILexicalBlock(scope: !1204, file: !112, line: 218, column: 5)
!1227 = !DILocation(line: 218, column: 10, scope: !1226)
!1228 = !DILocation(line: 218, column: 17, scope: !1229)
!1229 = distinct !DILexicalBlock(scope: !1226, file: !112, line: 218, column: 5)
!1230 = !DILocation(line: 218, column: 21, scope: !1229)
!1231 = !DILocation(line: 218, column: 28, scope: !1229)
!1232 = !DILocation(line: 218, column: 19, scope: !1229)
!1233 = !DILocation(line: 218, column: 5, scope: !1226)
!1234 = !DILocation(line: 219, column: 13, scope: !1235)
!1235 = distinct !DILexicalBlock(scope: !1236, file: !112, line: 219, column: 13)
!1236 = distinct !DILexicalBlock(scope: !1229, file: !112, line: 218, column: 38)
!1237 = !DILocation(line: 219, column: 25, scope: !1235)
!1238 = !DILocation(line: 219, column: 32, scope: !1235)
!1239 = !DILocation(line: 219, column: 38, scope: !1235)
!1240 = !DILocation(line: 219, column: 42, scope: !1235)
!1241 = !DILocation(line: 219, column: 13, scope: !1236)
!1242 = !DILocation(line: 220, column: 13, scope: !1243)
!1243 = distinct !DILexicalBlock(scope: !1235, file: !112, line: 219, column: 52)
!1244 = !DILocation(line: 222, column: 5, scope: !1236)
!1245 = !DILocation(line: 218, column: 34, scope: !1229)
!1246 = !DILocation(line: 218, column: 5, scope: !1229)
!1247 = distinct !{!1247, !1233, !1248, !482}
!1248 = !DILocation(line: 222, column: 5, scope: !1226)
!1249 = !DILocation(line: 223, column: 5, scope: !1204)
!1250 = !DILocation(line: 224, column: 1, scope: !1204)
!1251 = distinct !DISubprogram(name: "trace_destroy", scope: !112, file: !112, line: 97, type: !1252, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1252 = !DISubroutineType(types: !1253)
!1253 = !{null, !869}
!1254 = !DILocalVariable(name: "trace", arg: 1, scope: !1251, file: !112, line: 97, type: !869)
!1255 = !DILocation(line: 97, column: 24, scope: !1251)
!1256 = !DILocation(line: 99, column: 5, scope: !1257)
!1257 = distinct !DILexicalBlock(scope: !1258, file: !112, line: 99, column: 5)
!1258 = distinct !DILexicalBlock(scope: !1251, file: !112, line: 99, column: 5)
!1259 = !DILocation(line: 99, column: 5, scope: !1258)
!1260 = !DILocation(line: 100, column: 5, scope: !1261)
!1261 = distinct !DILexicalBlock(scope: !1262, file: !112, line: 100, column: 5)
!1262 = distinct !DILexicalBlock(scope: !1251, file: !112, line: 100, column: 5)
!1263 = !DILocation(line: 100, column: 5, scope: !1262)
!1264 = !DILocation(line: 101, column: 10, scope: !1251)
!1265 = !DILocation(line: 101, column: 17, scope: !1251)
!1266 = !DILocation(line: 101, column: 5, scope: !1251)
!1267 = !DILocation(line: 102, column: 5, scope: !1251)
!1268 = !DILocation(line: 102, column: 12, scope: !1251)
!1269 = !DILocation(line: 102, column: 24, scope: !1251)
!1270 = !DILocation(line: 103, column: 1, scope: !1251)
!1271 = distinct !DISubprogram(name: "vmem_malloc", scope: !79, file: !79, line: 20, type: !1272, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1272 = !DISubroutineType(types: !1273)
!1273 = !{!13, !5}
!1274 = !DILocalVariable(name: "sz", arg: 1, scope: !1271, file: !79, line: 20, type: !5)
!1275 = !DILocation(line: 20, column: 21, scope: !1271)
!1276 = !DILocalVariable(name: "ptr", scope: !1271, file: !79, line: 22, type: !13)
!1277 = !DILocation(line: 22, column: 11, scope: !1271)
!1278 = !DILocation(line: 22, column: 24, scope: !1271)
!1279 = !DILocation(line: 22, column: 17, scope: !1271)
!1280 = !DILocation(line: 23, column: 9, scope: !1281)
!1281 = distinct !DILexicalBlock(scope: !1271, file: !79, line: 23, column: 9)
!1282 = !DILocation(line: 23, column: 9, scope: !1271)
!1283 = !DILocation(line: 25, column: 9, scope: !1284)
!1284 = distinct !DILexicalBlock(scope: !1281, file: !79, line: 23, column: 14)
!1285 = !DILocation(line: 27, column: 5, scope: !1284)
!1286 = !DILocation(line: 28, column: 9, scope: !1287)
!1287 = distinct !DILexicalBlock(scope: !1288, file: !79, line: 28, column: 9)
!1288 = distinct !DILexicalBlock(scope: !1289, file: !79, line: 28, column: 9)
!1289 = distinct !DILexicalBlock(scope: !1281, file: !79, line: 27, column: 12)
!1290 = !DILocation(line: 30, column: 12, scope: !1271)
!1291 = !DILocation(line: 30, column: 5, scope: !1271)
!1292 = distinct !DISubprogram(name: "ismr_enter", scope: !50, file: !50, line: 41, type: !182, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1293 = !DILocalVariable(name: "tid", arg: 1, scope: !1292, file: !50, line: 41, type: !5)
!1294 = !DILocation(line: 41, column: 20, scope: !1292)
!1295 = !DILocation(line: 43, column: 5, scope: !1292)
!1296 = !DILocation(line: 43, column: 5, scope: !1297)
!1297 = distinct !DILexicalBlock(scope: !1292, file: !50, line: 43, column: 5)
!1298 = !DILocation(line: 43, column: 5, scope: !1299)
!1299 = distinct !DILexicalBlock(scope: !1297, file: !50, line: 43, column: 5)
!1300 = !DILocation(line: 43, column: 5, scope: !1301)
!1301 = distinct !DILexicalBlock(scope: !1299, file: !50, line: 43, column: 5)
!1302 = !DILocation(line: 44, column: 1, scope: !1292)
!1303 = distinct !DISubprogram(name: "vqueue_ub_enq", scope: !33, file: !33, line: 122, type: !1304, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1304 = !DISubroutineType(types: !1305)
!1305 = !{null, !379, !31, !13}
!1306 = !DILocalVariable(name: "q", arg: 1, scope: !1303, file: !33, line: 122, type: !379)
!1307 = !DILocation(line: 122, column: 28, scope: !1303)
!1308 = !DILocalVariable(name: "qnode", arg: 2, scope: !1303, file: !33, line: 122, type: !31)
!1309 = !DILocation(line: 122, column: 49, scope: !1303)
!1310 = !DILocalVariable(name: "data", arg: 3, scope: !1303, file: !33, line: 122, type: !13)
!1311 = !DILocation(line: 122, column: 62, scope: !1303)
!1312 = !DILocation(line: 124, column: 25, scope: !1303)
!1313 = !DILocation(line: 124, column: 28, scope: !1303)
!1314 = !DILocation(line: 124, column: 5, scope: !1303)
!1315 = !DILocation(line: 127, column: 26, scope: !1303)
!1316 = !DILocation(line: 127, column: 33, scope: !1303)
!1317 = !DILocation(line: 127, column: 5, scope: !1303)
!1318 = !DILocation(line: 129, column: 27, scope: !1303)
!1319 = !DILocation(line: 129, column: 30, scope: !1303)
!1320 = !DILocation(line: 129, column: 36, scope: !1303)
!1321 = !DILocation(line: 129, column: 42, scope: !1303)
!1322 = !DILocation(line: 129, column: 5, scope: !1303)
!1323 = !DILocation(line: 131, column: 15, scope: !1303)
!1324 = !DILocation(line: 131, column: 5, scope: !1303)
!1325 = !DILocation(line: 131, column: 8, scope: !1303)
!1326 = !DILocation(line: 131, column: 13, scope: !1303)
!1327 = !DILocation(line: 132, column: 25, scope: !1303)
!1328 = !DILocation(line: 132, column: 28, scope: !1303)
!1329 = !DILocation(line: 132, column: 5, scope: !1303)
!1330 = !DILocation(line: 133, column: 1, scope: !1303)
!1331 = distinct !DISubprogram(name: "ismr_exit", scope: !50, file: !50, line: 83, type: !182, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1332 = !DILocalVariable(name: "tid", arg: 1, scope: !1331, file: !50, line: 83, type: !5)
!1333 = !DILocation(line: 83, column: 19, scope: !1331)
!1334 = !DILocation(line: 85, column: 5, scope: !1331)
!1335 = !DILocation(line: 85, column: 5, scope: !1336)
!1336 = distinct !DILexicalBlock(scope: !1331, file: !50, line: 85, column: 5)
!1337 = !DILocation(line: 85, column: 5, scope: !1338)
!1338 = distinct !DILexicalBlock(scope: !1336, file: !50, line: 85, column: 5)
!1339 = !DILocation(line: 85, column: 5, scope: !1340)
!1340 = distinct !DILexicalBlock(scope: !1338, file: !50, line: 85, column: 5)
!1341 = !DILocation(line: 86, column: 1, scope: !1331)
!1342 = distinct !DISubprogram(name: "vatomicptr_write_rel", scope: !760, file: !760, line: 311, type: !934, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1343 = !DILocalVariable(name: "a", arg: 1, scope: !1342, file: !760, line: 311, type: !936)
!1344 = !DILocation(line: 311, column: 36, scope: !1342)
!1345 = !DILocalVariable(name: "v", arg: 2, scope: !1342, file: !760, line: 311, type: !13)
!1346 = !DILocation(line: 311, column: 45, scope: !1342)
!1347 = !DILocation(line: 315, column: 32, scope: !1342)
!1348 = !DILocation(line: 315, column: 44, scope: !1342)
!1349 = !DILocation(line: 315, column: 47, scope: !1342)
!1350 = !DILocation(line: 313, column: 5, scope: !1342)
!1351 = !{i64 856361}
!1352 = !DILocation(line: 317, column: 1, scope: !1342)
!1353 = distinct !DISubprogram(name: "_queue_retire", scope: !44, file: !44, line: 53, type: !1024, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1354 = !DILocalVariable(name: "node", arg: 1, scope: !1353, file: !44, line: 53, type: !518)
!1355 = !DILocation(line: 53, column: 29, scope: !1353)
!1356 = !DILocalVariable(name: "arg", arg: 2, scope: !1353, file: !44, line: 53, type: !13)
!1357 = !DILocation(line: 53, column: 41, scope: !1353)
!1358 = !DILocation(line: 61, column: 15, scope: !1353)
!1359 = !DILocation(line: 61, column: 5, scope: !1353)
!1360 = !DILocation(line: 63, column: 5, scope: !1353)
!1361 = !DILocation(line: 63, column: 5, scope: !1362)
!1362 = distinct !DILexicalBlock(scope: !1353, file: !44, line: 63, column: 5)
!1363 = !DILocation(line: 63, column: 5, scope: !1364)
!1364 = distinct !DILexicalBlock(scope: !1362, file: !44, line: 63, column: 5)
!1365 = !DILocation(line: 63, column: 5, scope: !1366)
!1366 = distinct !DILexicalBlock(scope: !1364, file: !44, line: 63, column: 5)
!1367 = !DILocation(line: 64, column: 1, scope: !1353)
!1368 = distinct !DISubprogram(name: "vqueue_ub_empty", scope: !33, file: !33, line: 143, type: !1369, scopeLine: 144, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1369 = !DISubroutineType(types: !1370)
!1370 = !{!24, !379}
!1371 = !DILocalVariable(name: "q", arg: 1, scope: !1368, file: !33, line: 143, type: !379)
!1372 = !DILocation(line: 143, column: 30, scope: !1368)
!1373 = !DILocalVariable(name: "qnode", scope: !1368, file: !33, line: 145, type: !31)
!1374 = !DILocation(line: 145, column: 23, scope: !1368)
!1375 = !DILocalVariable(name: "head", scope: !1368, file: !33, line: 146, type: !31)
!1376 = !DILocation(line: 146, column: 23, scope: !1368)
!1377 = !DILocation(line: 148, column: 25, scope: !1368)
!1378 = !DILocation(line: 148, column: 28, scope: !1368)
!1379 = !DILocation(line: 148, column: 5, scope: !1368)
!1380 = !DILocation(line: 149, column: 12, scope: !1368)
!1381 = !DILocation(line: 149, column: 15, scope: !1368)
!1382 = !DILocation(line: 149, column: 10, scope: !1368)
!1383 = !DILocation(line: 151, column: 54, scope: !1368)
!1384 = !DILocation(line: 151, column: 60, scope: !1368)
!1385 = !DILocation(line: 151, column: 33, scope: !1368)
!1386 = !DILocation(line: 151, column: 13, scope: !1368)
!1387 = !DILocation(line: 151, column: 11, scope: !1368)
!1388 = !DILocation(line: 152, column: 25, scope: !1368)
!1389 = !DILocation(line: 152, column: 28, scope: !1368)
!1390 = !DILocation(line: 152, column: 5, scope: !1368)
!1391 = !DILocation(line: 153, column: 12, scope: !1368)
!1392 = !DILocation(line: 153, column: 18, scope: !1368)
!1393 = !DILocation(line: 153, column: 5, scope: !1368)
