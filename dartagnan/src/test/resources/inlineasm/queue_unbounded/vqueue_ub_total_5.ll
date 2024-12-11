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
@.str = private unnamed_addr constant [9 x i8] c"msg == 1\00", align 1
@.str.1 = private unnamed_addr constant [78 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/test_case_5.h\00", align 1
@__PRETTY_FUNCTION__.t3 = private unnamed_addr constant [17 x i8] c"void t3(vsize_t)\00", align 1
@.str.2 = private unnamed_addr constant [11 x i8] c"g_len == 0\00", align 1
@__PRETTY_FUNCTION__.verify = private unnamed_addr constant [18 x i8] c"void verify(void)\00", align 1
@g_queue = dso_local global %struct.vqueue_ub_s zeroinitializer, align 8, !dbg !148
@.str.3 = private unnamed_addr constant [15 x i8] c"vmem_no_leak()\00", align 1
@.str.4 = private unnamed_addr constant [89 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/unbounded_queue_verify.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"data\00", align 1
@__PRETTY_FUNCTION__.get_final_state = private unnamed_addr constant [29 x i8] c"void get_final_state(void *)\00", align 1
@.str.6 = private unnamed_addr constant [10 x i8] c"g_len < 5\00", align 1
@g_final_state = dso_local global [5 x i64] zeroinitializer, align 16, !dbg !160
@.str.7 = private unnamed_addr constant [39 x i8] c"currently only 3 threads are supported\00", align 1
@.str.8 = private unnamed_addr constant [41 x i8] c"\22currently only 3 threads are supported\22\00", align 1
@__PRETTY_FUNCTION__.run = private unnamed_addr constant [18 x i8] c"void *run(void *)\00", align 1
@global_trace = dso_local global %struct.locked_trace_s zeroinitializer, align 8, !dbg !95
@.str.9 = private unnamed_addr constant [6 x i8] c"trace\00", align 1
@.str.10 = private unnamed_addr constant [64 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/locked_trace.h\00", align 1
@__PRETTY_FUNCTION__.locked_trace_init = private unnamed_addr constant [50 x i8] c"void locked_trace_init(locked_trace_t *, vsize_t)\00", align 1
@.str.11 = private unnamed_addr constant [65 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/trace_manager.h\00", align 1
@__PRETTY_FUNCTION__.trace_init = private unnamed_addr constant [36 x i8] c"void trace_init(trace_t *, vsize_t)\00", align 1
@.str.12 = private unnamed_addr constant [25 x i8] c"0 && \22allocation failed\22\00", align 1
@.str.13 = private unnamed_addr constant [97 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/include/test/queue/ub/queue_interface.h\00", align 1
@__PRETTY_FUNCTION__.queue_destroy = private unnamed_addr constant [30 x i8] c"void queue_destroy(queue_t *)\00", align 1
@.str.14 = private unnamed_addr constant [9 x i8] c"val == 0\00", align 1
@.str.15 = private unnamed_addr constant [101 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/include/vsync/queue/unbounded_queue_total.h\00", align 1
@__PRETTY_FUNCTION__.queue_lock_acquire = private unnamed_addr constant [40 x i8] c"void queue_lock_acquire(queue_lock_t *)\00", align 1
@__PRETTY_FUNCTION__.queue_lock_release = private unnamed_addr constant [40 x i8] c"void queue_lock_release(queue_lock_t *)\00", align 1
@__PRETTY_FUNCTION__.trace_verify = private unnamed_addr constant [51 x i8] c"vbool_t trace_verify(trace_t *, trace_verify_unit)\00", align 1
@.str.16 = private unnamed_addr constant [19 x i8] c"trace->initialized\00", align 1
@.str.17 = private unnamed_addr constant [11 x i8] c"verify_fun\00", align 1
@__PRETTY_FUNCTION__.trace_destroy = private unnamed_addr constant [30 x i8] c"void trace_destroy(trace_t *)\00", align 1
@.str.18 = private unnamed_addr constant [5 x i8] c"unit\00", align 1
@.str.19 = private unnamed_addr constant [70 x i8] c"/home/stefano/huawei/libvsync/memory/smr/include/test/smr/ismr_none.h\00", align 1
@__PRETTY_FUNCTION__._ismr_none_destroy_all_cb = private unnamed_addr constant [50 x i8] c"vbool_t _ismr_none_destroy_all_cb(trace_unit_t *)\00", align 1
@__PRETTY_FUNCTION__.queue_enq = private unnamed_addr constant [52 x i8] c"void queue_enq(vsize_t, queue_t *, vuint64_t, char)\00", align 1
@.str.20 = private unnamed_addr constant [63 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/vmem_stdlib.h\00", align 1
@__PRETTY_FUNCTION__.vmem_malloc = private unnamed_addr constant [27 x i8] c"void *vmem_malloc(vsize_t)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @t1(i64 noundef %0) #0 !dbg !173 {
  %2 = alloca i64, align 8
  %3 = alloca i8*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !177, metadata !DIExpression()), !dbg !178
  %4 = load i64, i64* %2, align 8, !dbg !179
  call void @enq(i64 noundef %4, i64 noundef 2, i8 noundef signext 65), !dbg !180
  call void @llvm.dbg.declare(metadata i8** %3, metadata !181, metadata !DIExpression()), !dbg !182
  %5 = load i64, i64* %2, align 8, !dbg !183
  %6 = call %struct.data_s* @deq(i64 noundef %5), !dbg !184
  %7 = bitcast %struct.data_s* %6 to i8*, !dbg !184
  store i8* %7, i8** %3, align 8, !dbg !182
  %8 = load i8*, i8** %3, align 8, !dbg !185
  call void @free(i8* noundef %8) #5, !dbg !186
  ret void, !dbg !187
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @enq(i64 noundef %0, i64 noundef %1, i8 noundef signext %2) #0 !dbg !188 {
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i8, align 1
  store i64 %0, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !191, metadata !DIExpression()), !dbg !192
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !193, metadata !DIExpression()), !dbg !194
  store i8 %2, i8* %6, align 1
  call void @llvm.dbg.declare(metadata i8* %6, metadata !195, metadata !DIExpression()), !dbg !196
  %7 = load i64, i64* %4, align 8, !dbg !197
  %8 = load i64, i64* %5, align 8, !dbg !198
  %9 = load i8, i8* %6, align 1, !dbg !199
  call void @queue_enq(i64 noundef %7, %struct.vqueue_ub_s* noundef @g_queue, i64 noundef %8, i8 noundef signext %9), !dbg !200
  ret void, !dbg !201
}

; Function Attrs: noinline nounwind uwtable
define dso_local %struct.data_s* @deq(i64 noundef %0) #0 !dbg !202 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !211, metadata !DIExpression()), !dbg !212
  %3 = load i64, i64* %2, align 8, !dbg !213
  %4 = call i8* @queue_deq(i64 noundef %3, %struct.vqueue_ub_s* noundef @g_queue), !dbg !214
  %5 = bitcast i8* %4 to %struct.data_s*, !dbg !214
  ret %struct.data_s* %5, !dbg !215
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @t2(i64 noundef %0) #0 !dbg !216 {
  %2 = alloca i64, align 8
  %3 = alloca i8*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !217, metadata !DIExpression()), !dbg !218
  store i32 1, i32* @msg, align 4, !dbg !219
  call void @llvm.dbg.declare(metadata i8** %3, metadata !220, metadata !DIExpression()), !dbg !221
  %4 = load i64, i64* %2, align 8, !dbg !222
  %5 = call %struct.data_s* @deq(i64 noundef %4), !dbg !223
  %6 = bitcast %struct.data_s* %5 to i8*, !dbg !223
  store i8* %6, i8** %3, align 8, !dbg !221
  %7 = load i8*, i8** %3, align 8, !dbg !224
  call void @free(i8* noundef %7) #5, !dbg !225
  ret void, !dbg !226
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @t3(i64 noundef %0) #0 !dbg !227 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !228, metadata !DIExpression()), !dbg !229
  %3 = load i64, i64* %2, align 8, !dbg !230
  %4 = call zeroext i1 @empty(i64 noundef %3), !dbg !232
  br i1 %4, label %5, label %11, !dbg !233

5:                                                ; preds = %1
  %6 = load i32, i32* @msg, align 4, !dbg !234
  %7 = icmp eq i32 %6, 1, !dbg !234
  br i1 %7, label %8, label %9, !dbg !238

8:                                                ; preds = %5
  br label %10, !dbg !238

9:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 39, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t3, i64 0, i64 0)) #6, !dbg !234
  unreachable, !dbg !234

10:                                               ; preds = %8
  br label %13, !dbg !239

11:                                               ; preds = %1
  %12 = load i64, i64* %2, align 8, !dbg !240
  call void @queue_clean(i64 noundef %12), !dbg !242
  br label %13

13:                                               ; preds = %11, %10
  ret void, !dbg !243
}

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @empty(i64 noundef %0) #0 !dbg !244 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !247, metadata !DIExpression()), !dbg !248
  %3 = load i64, i64* %2, align 8, !dbg !249
  %4 = call zeroext i1 @queue_empty(i64 noundef %3, %struct.vqueue_ub_s* noundef @g_queue), !dbg !250
  ret i1 %4, !dbg !251
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @queue_clean(i64 noundef %0) #0 !dbg !252 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !253, metadata !DIExpression()), !dbg !254
  %3 = load i64, i64* %2, align 8, !dbg !255
  call void @ismr_recycle(i64 noundef %3), !dbg !256
  ret void, !dbg !257
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @verify() #0 !dbg !258 {
  %1 = load i64, i64* @g_len, align 8, !dbg !261
  %2 = icmp eq i64 %1, 0, !dbg !261
  br i1 %2, label %3, label %4, !dbg !264

3:                                                ; preds = %0
  br label %5, !dbg !264

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 47, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #6, !dbg !261
  unreachable, !dbg !261

5:                                                ; preds = %3
  ret void, !dbg !265
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !266 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @init(), !dbg !269
  call void @launch_threads(i64 noundef 3, i8* (i8*)* noundef @run), !dbg !270
  call void @queue_print(%struct.vqueue_ub_s* noundef @g_queue, void (i8*)* noundef @get_final_state), !dbg !271
  call void @verify(), !dbg !272
  call void @destroy(), !dbg !273
  %2 = call zeroext i1 @vmem_no_leak(), !dbg !274
  br i1 %2, label %3, label %4, !dbg !277

3:                                                ; preds = %0
  br label %5, !dbg !277

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.4, i64 0, i64 0), i32 noundef 58, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !274
  unreachable, !dbg !274

5:                                                ; preds = %3
  ret i32 0, !dbg !278
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !279 {
  %1 = alloca i8, align 1
  %2 = alloca i64, align 8
  call void @queue_init(%struct.vqueue_ub_s* noundef @g_queue), !dbg !280
  call void @queue_register(i64 noundef 0, %struct.vqueue_ub_s* noundef @g_queue), !dbg !281
  call void @llvm.dbg.declare(metadata i8* %1, metadata !282, metadata !DIExpression()), !dbg !283
  store i8 97, i8* %1, align 1, !dbg !283
  call void @llvm.dbg.declare(metadata i64* %2, metadata !284, metadata !DIExpression()), !dbg !286
  store i64 1, i64* %2, align 8, !dbg !286
  br label %3, !dbg !287

3:                                                ; preds = %9, %0
  %4 = load i64, i64* %2, align 8, !dbg !288
  %5 = icmp ule i64 %4, 1, !dbg !290
  br i1 %5, label %6, label %14, !dbg !291

6:                                                ; preds = %3
  %7 = load i64, i64* %2, align 8, !dbg !292
  %8 = load i8, i8* %1, align 1, !dbg !294
  call void @enq(i64 noundef 0, i64 noundef %7, i8 noundef signext %8), !dbg !295
  br label %9, !dbg !296

9:                                                ; preds = %6
  %10 = load i64, i64* %2, align 8, !dbg !297
  %11 = add i64 %10, 1, !dbg !297
  store i64 %11, i64* %2, align 8, !dbg !297
  %12 = load i8, i8* %1, align 1, !dbg !298
  %13 = add i8 %12, 1, !dbg !298
  store i8 %13, i8* %1, align 1, !dbg !298
  br label %3, !dbg !299, !llvm.loop !300

14:                                               ; preds = %3
  call void @queue_deregister(i64 noundef 0, %struct.vqueue_ub_s* noundef @g_queue), !dbg !303
  ret void, !dbg !304
}

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !305 {
  %3 = alloca i64, align 8
  %4 = alloca i8* (i8*)*, align 8
  %5 = alloca %struct.run_info_t*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !308, metadata !DIExpression()), !dbg !309
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %4, metadata !310, metadata !DIExpression()), !dbg !311
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !312, metadata !DIExpression()), !dbg !313
  %6 = load i64, i64* %3, align 8, !dbg !314
  %7 = mul i64 32, %6, !dbg !315
  %8 = call noalias i8* @malloc(i64 noundef %7) #5, !dbg !316
  %9 = bitcast i8* %8 to %struct.run_info_t*, !dbg !316
  store %struct.run_info_t* %9, %struct.run_info_t** %5, align 8, !dbg !313
  %10 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !317
  %11 = load i64, i64* %3, align 8, !dbg !318
  %12 = load i8* (i8*)*, i8* (i8*)** %4, align 8, !dbg !319
  call void @create_threads(%struct.run_info_t* noundef %10, i64 noundef %11, i8* (i8*)* noundef %12, i1 noundef zeroext true), !dbg !320
  %13 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !321
  %14 = load i64, i64* %3, align 8, !dbg !322
  call void @await_threads(%struct.run_info_t* noundef %13, i64 noundef %14), !dbg !323
  %15 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !324
  %16 = bitcast %struct.run_info_t* %15 to i8*, !dbg !324
  call void @free(i8* noundef %16) #5, !dbg !325
  ret void, !dbg !326
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !327 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !328, metadata !DIExpression()), !dbg !329
  call void @llvm.dbg.declare(metadata i64* %3, metadata !330, metadata !DIExpression()), !dbg !331
  %4 = load i8*, i8** %2, align 8, !dbg !332
  %5 = ptrtoint i8* %4 to i64, !dbg !333
  store i64 %5, i64* %3, align 8, !dbg !331
  %6 = load i64, i64* %3, align 8, !dbg !334
  call void @queue_register(i64 noundef %6, %struct.vqueue_ub_s* noundef @g_queue), !dbg !335
  %7 = load i64, i64* %3, align 8, !dbg !336
  switch i64 %7, label %14 [
    i64 0, label %8
    i64 1, label %10
    i64 2, label %12
  ], !dbg !337

8:                                                ; preds = %1
  %9 = load i64, i64* %3, align 8, !dbg !338
  call void @t1(i64 noundef %9), !dbg !340
  br label %18, !dbg !341

10:                                               ; preds = %1
  %11 = load i64, i64* %3, align 8, !dbg !342
  call void @t2(i64 noundef %11), !dbg !343
  br label %18, !dbg !344

12:                                               ; preds = %1
  %13 = load i64, i64* %3, align 8, !dbg !345
  call void @t3(i64 noundef %13), !dbg !346
  br label %18, !dbg !347

14:                                               ; preds = %1
  br i1 true, label %15, label %16, !dbg !348

15:                                               ; preds = %14
  br label %17, !dbg !348

16:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([41 x i8], [41 x i8]* @.str.8, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.4, i64 0, i64 0), i32 noundef 141, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #6, !dbg !350
  unreachable, !dbg !350

17:                                               ; preds = %15
  br label %18, !dbg !352

18:                                               ; preds = %17, %12, %10, %8
  %19 = load i64, i64* %3, align 8, !dbg !353
  call void @queue_deregister(i64 noundef %19, %struct.vqueue_ub_s* noundef @g_queue), !dbg !354
  ret i8* null, !dbg !355
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_print(%struct.vqueue_ub_s* noundef %0, void (i8*)* noundef %1) #0 !dbg !356 {
  %3 = alloca %struct.vqueue_ub_s*, align 8
  %4 = alloca void (i8*)*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %3, metadata !360, metadata !DIExpression()), !dbg !361
  store void (i8*)* %1, void (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata void (i8*)** %4, metadata !362, metadata !DIExpression()), !dbg !363
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %3, align 8, !dbg !364
  %6 = load void (i8*)*, void (i8*)** %4, align 8, !dbg !365
  %7 = bitcast void (i8*)* %6 to i8*, !dbg !366
  call void @_vqueue_ub_visit_nodes(%struct.vqueue_ub_s* noundef %5, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_redirect_print, i8* noundef %7), !dbg !367
  ret void, !dbg !368
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @get_final_state(i8* noundef %0) #0 !dbg !369 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.data_s*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !370, metadata !DIExpression()), !dbg !371
  %4 = load i8*, i8** %2, align 8, !dbg !372
  %5 = icmp ne i8* %4, null, !dbg !372
  br i1 %5, label %6, label %7, !dbg !375

6:                                                ; preds = %1
  br label %8, !dbg !375

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.4, i64 0, i64 0), i32 noundef 119, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.get_final_state, i64 0, i64 0)) #6, !dbg !372
  unreachable, !dbg !372

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata %struct.data_s** %3, metadata !376, metadata !DIExpression()), !dbg !377
  %9 = load i8*, i8** %2, align 8, !dbg !378
  %10 = bitcast i8* %9 to %struct.data_s*, !dbg !378
  store %struct.data_s* %10, %struct.data_s** %3, align 8, !dbg !377
  %11 = load i64, i64* @g_len, align 8, !dbg !379
  %12 = icmp ult i64 %11, 5, !dbg !379
  br i1 %12, label %13, label %14, !dbg !382

13:                                               ; preds = %8
  br label %15, !dbg !382

14:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.4, i64 0, i64 0), i32 noundef 121, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.get_final_state, i64 0, i64 0)) #6, !dbg !379
  unreachable, !dbg !379

15:                                               ; preds = %13
  %16 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !383
  %17 = getelementptr inbounds %struct.data_s, %struct.data_s* %16, i32 0, i32 0, !dbg !384
  %18 = load i64, i64* %17, align 8, !dbg !384
  %19 = load i64, i64* @g_len, align 8, !dbg !385
  %20 = add i64 %19, 1, !dbg !385
  store i64 %20, i64* @g_len, align 8, !dbg !385
  %21 = getelementptr inbounds [5 x i64], [5 x i64]* @g_final_state, i64 0, i64 %19, !dbg !386
  store i64 %18, i64* %21, align 8, !dbg !387
  ret void, !dbg !388
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @destroy() #0 !dbg !389 {
  call void @queue_destroy(%struct.vqueue_ub_s* noundef @g_queue), !dbg !390
  ret void, !dbg !391
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @vmem_no_leak() #0 !dbg !392 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !395, metadata !DIExpression()), !dbg !396
  %3 = call i64 @vmem_get_alloc_count(), !dbg !397
  store i64 %3, i64* %1, align 8, !dbg !396
  call void @llvm.dbg.declare(metadata i64* %2, metadata !398, metadata !DIExpression()), !dbg !399
  %4 = call i64 @vmem_get_free_count(), !dbg !400
  store i64 %4, i64* %2, align 8, !dbg !399
  %5 = load i64, i64* %1, align 8, !dbg !401
  %6 = load i64, i64* %2, align 8, !dbg !402
  %7 = icmp eq i64 %5, %6, !dbg !403
  ret i1 %7, !dbg !404
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_init(%struct.vqueue_ub_s* noundef %0) #0 !dbg !405 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !409, metadata !DIExpression()), !dbg !410
  call void @ismr_init(), !dbg !411
  %3 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !412
  call void @vqueue_ub_init(%struct.vqueue_ub_s* noundef %3), !dbg !413
  ret void, !dbg !414
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_register(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !415 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !418, metadata !DIExpression()), !dbg !419
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !420, metadata !DIExpression()), !dbg !421
  %5 = load i64, i64* %3, align 8, !dbg !422
  call void @ismr_reg(i64 noundef %5), !dbg !423
  br label %6, !dbg !424

6:                                                ; preds = %2
  br label %7, !dbg !425

7:                                                ; preds = %6
  %8 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !427
  br label %9, !dbg !427

9:                                                ; preds = %7
  br label %10, !dbg !429

10:                                               ; preds = %9
  br label %11, !dbg !427

11:                                               ; preds = %10
  br label %12, !dbg !425

12:                                               ; preds = %11
  ret void, !dbg !431
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_deregister(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !432 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !433, metadata !DIExpression()), !dbg !434
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !435, metadata !DIExpression()), !dbg !436
  %5 = load i64, i64* %3, align 8, !dbg !437
  call void @ismr_dereg(i64 noundef %5), !dbg !438
  br label %6, !dbg !439

6:                                                ; preds = %2
  br label %7, !dbg !440

7:                                                ; preds = %6
  %8 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !442
  br label %9, !dbg !442

9:                                                ; preds = %7
  br label %10, !dbg !444

10:                                               ; preds = %9
  br label %11, !dbg !442

11:                                               ; preds = %10
  br label %12, !dbg !440

12:                                               ; preds = %11
  ret void, !dbg !446
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_destroy(%struct.vqueue_ub_s* noundef %0) #0 !dbg !447 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !448, metadata !DIExpression()), !dbg !449
  call void @llvm.dbg.declare(metadata i8** %3, metadata !450, metadata !DIExpression()), !dbg !451
  store i8* null, i8** %3, align 8, !dbg !451
  br label %4, !dbg !452

4:                                                ; preds = %9, %1
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !453
  %6 = call i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %5, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_queue_destroy, i8* noundef null), !dbg !454
  store i8* %6, i8** %3, align 8, !dbg !455
  %7 = load i8*, i8** %3, align 8, !dbg !456
  %8 = icmp ne i8* %7, null, !dbg !452
  br i1 %8, label %9, label %11, !dbg !452

9:                                                ; preds = %4
  %10 = load i8*, i8** %3, align 8, !dbg !457
  call void @free(i8* noundef %10) #5, !dbg !459
  br label %4, !dbg !452, !llvm.loop !460

11:                                               ; preds = %4
  %12 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !462
  call void @vqueue_ub_destroy(%struct.vqueue_ub_s* noundef %12, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_queue_destroy, i8* noundef null), !dbg !463
  call void @ismr_destroy(), !dbg !464
  %13 = call zeroext i1 @vmem_no_leak(), !dbg !465
  br i1 %13, label %14, label %15, !dbg !468

14:                                               ; preds = %11
  br label %16, !dbg !468

15:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([97 x i8], [97 x i8]* @.str.13, i64 0, i64 0), i32 noundef 166, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.queue_destroy, i64 0, i64 0)) #6, !dbg !465
  unreachable, !dbg !465

16:                                               ; preds = %14
  ret void, !dbg !469
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_enq(i64 noundef %0, %struct.vqueue_ub_s* noundef %1, i64 noundef %2, i8 noundef signext %3) #0 !dbg !470 {
  %5 = alloca i64, align 8
  %6 = alloca %struct.vqueue_ub_s*, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  %9 = alloca %struct.data_s*, align 8
  %10 = alloca %struct.vqueue_ub_node_s*, align 8
  store i64 %0, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !473, metadata !DIExpression()), !dbg !474
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %6, metadata !475, metadata !DIExpression()), !dbg !476
  store i64 %2, i64* %7, align 8
  call void @llvm.dbg.declare(metadata i64* %7, metadata !477, metadata !DIExpression()), !dbg !478
  store i8 %3, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !479, metadata !DIExpression()), !dbg !480
  call void @llvm.dbg.declare(metadata %struct.data_s** %9, metadata !481, metadata !DIExpression()), !dbg !482
  %11 = call noalias i8* @malloc(i64 noundef 16) #5, !dbg !483
  %12 = bitcast i8* %11 to %struct.data_s*, !dbg !483
  store %struct.data_s* %12, %struct.data_s** %9, align 8, !dbg !482
  %13 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !484
  %14 = icmp ne %struct.data_s* %13, null, !dbg !484
  br i1 %14, label %15, label %30, !dbg !486

15:                                               ; preds = %4
  %16 = load i64, i64* %7, align 8, !dbg !487
  %17 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !489
  %18 = getelementptr inbounds %struct.data_s, %struct.data_s* %17, i32 0, i32 0, !dbg !490
  store i64 %16, i64* %18, align 8, !dbg !491
  %19 = load i8, i8* %8, align 1, !dbg !492
  %20 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !493
  %21 = getelementptr inbounds %struct.data_s, %struct.data_s* %20, i32 0, i32 1, !dbg !494
  store i8 %19, i8* %21, align 8, !dbg !495
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %10, metadata !496, metadata !DIExpression()), !dbg !499
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %10, align 8, !dbg !499
  %22 = call i8* @vmem_malloc(i64 noundef 16), !dbg !500
  %23 = bitcast i8* %22 to %struct.vqueue_ub_node_s*, !dbg !500
  store %struct.vqueue_ub_node_s* %23, %struct.vqueue_ub_node_s** %10, align 8, !dbg !501
  %24 = load i64, i64* %5, align 8, !dbg !502
  call void @ismr_enter(i64 noundef %24), !dbg !503
  %25 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %6, align 8, !dbg !504
  %26 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !505
  %27 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !506
  %28 = bitcast %struct.data_s* %27 to i8*, !dbg !506
  call void @vqueue_ub_enq(%struct.vqueue_ub_s* noundef %25, %struct.vqueue_ub_node_s* noundef %26, i8* noundef %28), !dbg !507
  %29 = load i64, i64* %5, align 8, !dbg !508
  call void @ismr_exit(i64 noundef %29), !dbg !509
  br label %31, !dbg !510

30:                                               ; preds = %4
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.12, i64 0, i64 0), i8* noundef getelementptr inbounds ([97 x i8], [97 x i8]* @.str.13, i64 0, i64 0), i32 noundef 196, i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @__PRETTY_FUNCTION__.queue_enq, i64 0, i64 0)) #6, !dbg !511
  unreachable, !dbg !511

31:                                               ; preds = %15
  ret void, !dbg !515
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @queue_deq(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !516 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca i8*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !519, metadata !DIExpression()), !dbg !520
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !521, metadata !DIExpression()), !dbg !522
  %6 = load i64, i64* %3, align 8, !dbg !523
  call void @ismr_enter(i64 noundef %6), !dbg !524
  call void @llvm.dbg.declare(metadata i8** %5, metadata !525, metadata !DIExpression()), !dbg !526
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !527
  %8 = load i64, i64* %3, align 8, !dbg !528
  %9 = inttoptr i64 %8 to i8*, !dbg !529
  %10 = call i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %7, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_queue_retire, i8* noundef %9), !dbg !530
  store i8* %10, i8** %5, align 8, !dbg !526
  %11 = load i64, i64* %3, align 8, !dbg !531
  call void @ismr_exit(i64 noundef %11), !dbg !532
  %12 = load i8*, i8** %5, align 8, !dbg !533
  ret i8* %12, !dbg !534
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @queue_empty(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !535 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca i8, align 1
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !538, metadata !DIExpression()), !dbg !539
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !540, metadata !DIExpression()), !dbg !541
  %6 = load i64, i64* %3, align 8, !dbg !542
  call void @ismr_enter(i64 noundef %6), !dbg !543
  call void @llvm.dbg.declare(metadata i8* %5, metadata !544, metadata !DIExpression()), !dbg !545
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !546
  %8 = call zeroext i1 @vqueue_ub_empty(%struct.vqueue_ub_s* noundef %7), !dbg !547
  %9 = zext i1 %8 to i8, !dbg !545
  store i8 %9, i8* %5, align 1, !dbg !545
  %10 = load i64, i64* %3, align 8, !dbg !548
  call void @ismr_exit(i64 noundef %10), !dbg !549
  %11 = load i8, i8* %5, align 1, !dbg !550
  %12 = trunc i8 %11 to i1, !dbg !550
  ret i1 %12, !dbg !551
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_recycle(i64 noundef %0) #0 !dbg !552 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !553, metadata !DIExpression()), !dbg !554
  br label %3, !dbg !555

3:                                                ; preds = %1
  br label %4, !dbg !556

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !558
  br label %6, !dbg !558

6:                                                ; preds = %4
  br label %7, !dbg !560

7:                                                ; preds = %6
  br label %8, !dbg !558

8:                                                ; preds = %7
  br label %9, !dbg !556

9:                                                ; preds = %8
  ret void, !dbg !562
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !563 {
  %5 = alloca %struct.run_info_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8* (i8*)*, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !566, metadata !DIExpression()), !dbg !567
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !568, metadata !DIExpression()), !dbg !569
  store i8* (i8*)* %2, i8* (i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %7, metadata !570, metadata !DIExpression()), !dbg !571
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !572, metadata !DIExpression()), !dbg !573
  call void @llvm.dbg.declare(metadata i64* %9, metadata !574, metadata !DIExpression()), !dbg !575
  store i64 0, i64* %9, align 8, !dbg !575
  store i64 0, i64* %9, align 8, !dbg !576
  br label %11, !dbg !578

11:                                               ; preds = %42, %4
  %12 = load i64, i64* %9, align 8, !dbg !579
  %13 = load i64, i64* %6, align 8, !dbg !581
  %14 = icmp ult i64 %12, %13, !dbg !582
  br i1 %14, label %15, label %45, !dbg !583

15:                                               ; preds = %11
  %16 = load i64, i64* %9, align 8, !dbg !584
  %17 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !586
  %18 = load i64, i64* %9, align 8, !dbg !587
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %17, i64 %18, !dbg !586
  %20 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %19, i32 0, i32 1, !dbg !588
  store i64 %16, i64* %20, align 8, !dbg !589
  %21 = load i8* (i8*)*, i8* (i8*)** %7, align 8, !dbg !590
  %22 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !591
  %23 = load i64, i64* %9, align 8, !dbg !592
  %24 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %22, i64 %23, !dbg !591
  %25 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %24, i32 0, i32 3, !dbg !593
  store i8* (i8*)* %21, i8* (i8*)** %25, align 8, !dbg !594
  %26 = load i8, i8* %8, align 1, !dbg !595
  %27 = trunc i8 %26 to i1, !dbg !595
  %28 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !596
  %29 = load i64, i64* %9, align 8, !dbg !597
  %30 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %28, i64 %29, !dbg !596
  %31 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %30, i32 0, i32 2, !dbg !598
  %32 = zext i1 %27 to i8, !dbg !599
  store i8 %32, i8* %31, align 8, !dbg !599
  %33 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !600
  %34 = load i64, i64* %9, align 8, !dbg !601
  %35 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %33, i64 %34, !dbg !600
  %36 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %35, i32 0, i32 0, !dbg !602
  %37 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !603
  %38 = load i64, i64* %9, align 8, !dbg !604
  %39 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %37, i64 %38, !dbg !603
  %40 = bitcast %struct.run_info_t* %39 to i8*, !dbg !605
  %41 = call i32 @pthread_create(i64* noundef %36, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %40) #5, !dbg !606
  br label %42, !dbg !607

42:                                               ; preds = %15
  %43 = load i64, i64* %9, align 8, !dbg !608
  %44 = add i64 %43, 1, !dbg !608
  store i64 %44, i64* %9, align 8, !dbg !608
  br label %11, !dbg !609, !llvm.loop !610

45:                                               ; preds = %11
  ret void, !dbg !612
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !613 {
  %3 = alloca %struct.run_info_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !616, metadata !DIExpression()), !dbg !617
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !618, metadata !DIExpression()), !dbg !619
  call void @llvm.dbg.declare(metadata i64* %5, metadata !620, metadata !DIExpression()), !dbg !621
  store i64 0, i64* %5, align 8, !dbg !621
  store i64 0, i64* %5, align 8, !dbg !622
  br label %6, !dbg !624

6:                                                ; preds = %17, %2
  %7 = load i64, i64* %5, align 8, !dbg !625
  %8 = load i64, i64* %4, align 8, !dbg !627
  %9 = icmp ult i64 %7, %8, !dbg !628
  br i1 %9, label %10, label %20, !dbg !629

10:                                               ; preds = %6
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !630
  %12 = load i64, i64* %5, align 8, !dbg !632
  %13 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i64 %12, !dbg !630
  %14 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %13, i32 0, i32 0, !dbg !633
  %15 = load i64, i64* %14, align 8, !dbg !633
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !634
  br label %17, !dbg !635

17:                                               ; preds = %10
  %18 = load i64, i64* %5, align 8, !dbg !636
  %19 = add i64 %18, 1, !dbg !636
  store i64 %19, i64* %5, align 8, !dbg !636
  br label %6, !dbg !637, !llvm.loop !638

20:                                               ; preds = %6
  ret void, !dbg !640
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !641 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.run_info_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !642, metadata !DIExpression()), !dbg !643
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !644, metadata !DIExpression()), !dbg !645
  %4 = load i8*, i8** %2, align 8, !dbg !646
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !647
  store %struct.run_info_t* %5, %struct.run_info_t** %3, align 8, !dbg !645
  %6 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !648
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %6, i32 0, i32 2, !dbg !650
  %8 = load i8, i8* %7, align 8, !dbg !650
  %9 = trunc i8 %8 to i1, !dbg !650
  br i1 %9, label %10, label %14, !dbg !651

10:                                               ; preds = %1
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !652
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i32 0, i32 1, !dbg !653
  %13 = load i64, i64* %12, align 8, !dbg !653
  call void @set_cpu_affinity(i64 noundef %13), !dbg !654
  br label %14, !dbg !654

14:                                               ; preds = %10, %1
  %15 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !655
  %16 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %15, i32 0, i32 3, !dbg !656
  %17 = load i8* (i8*)*, i8* (i8*)** %16, align 8, !dbg !656
  %18 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !657
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %18, i32 0, i32 1, !dbg !658
  %20 = load i64, i64* %19, align 8, !dbg !658
  %21 = inttoptr i64 %20 to i8*, !dbg !659
  %22 = call i8* %17(i8* noundef %21), !dbg !655
  ret i8* %22, !dbg !660
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !661 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !662, metadata !DIExpression()), !dbg !663
  br label %3, !dbg !664

3:                                                ; preds = %1
  br label %4, !dbg !665

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !667
  br label %6, !dbg !667

6:                                                ; preds = %4
  br label %7, !dbg !669

7:                                                ; preds = %6
  br label %8, !dbg !667

8:                                                ; preds = %7
  br label %9, !dbg !665

9:                                                ; preds = %8
  ret void, !dbg !671
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @_vqueue_ub_visit_nodes(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !672 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !681, metadata !DIExpression()), !dbg !682
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !683, metadata !DIExpression()), !dbg !684
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !685, metadata !DIExpression()), !dbg !686
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !687, metadata !DIExpression()), !dbg !688
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !688
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !689, metadata !DIExpression()), !dbg !690
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !690
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !691
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 2, !dbg !692
  %11 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !692
  store %struct.vqueue_ub_node_s* %11, %struct.vqueue_ub_node_s** %7, align 8, !dbg !693
  %12 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !694
  %13 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %12, i32 0, i32 1, !dbg !695
  %14 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %13), !dbg !696
  %15 = bitcast i8* %14 to %struct.vqueue_ub_node_s*, !dbg !697
  store %struct.vqueue_ub_node_s* %15, %struct.vqueue_ub_node_s** %7, align 8, !dbg !698
  br label %16, !dbg !699

16:                                               ; preds = %19, %3
  %17 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !700
  %18 = icmp ne %struct.vqueue_ub_node_s* %17, null, !dbg !699
  br i1 %18, label %19, label %28, !dbg !699

19:                                               ; preds = %16
  %20 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !701
  %21 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %20, i32 0, i32 1, !dbg !703
  %22 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %21), !dbg !704
  %23 = bitcast i8* %22 to %struct.vqueue_ub_node_s*, !dbg !705
  store %struct.vqueue_ub_node_s* %23, %struct.vqueue_ub_node_s** %8, align 8, !dbg !706
  %24 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !707
  %25 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !708
  %26 = load i8*, i8** %6, align 8, !dbg !709
  call void %24(%struct.vqueue_ub_node_s* noundef %25, i8* noundef %26), !dbg !707
  %27 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !710
  store %struct.vqueue_ub_node_s* %27, %struct.vqueue_ub_node_s** %7, align 8, !dbg !711
  br label %16, !dbg !699, !llvm.loop !712

28:                                               ; preds = %16
  ret void, !dbg !714
}

; Function Attrs: noinline nounwind uwtable
define internal void @_redirect_print(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !715 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca void (i8*)*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !718, metadata !DIExpression()), !dbg !719
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !720, metadata !DIExpression()), !dbg !721
  call void @llvm.dbg.declare(metadata void (i8*)** %5, metadata !722, metadata !DIExpression()), !dbg !723
  %6 = load i8*, i8** %4, align 8, !dbg !724
  %7 = bitcast i8* %6 to void (i8*)*, !dbg !725
  store void (i8*)* %7, void (i8*)** %5, align 8, !dbg !723
  %8 = load void (i8*)*, void (i8*)** %5, align 8, !dbg !726
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !727
  %10 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %9, i32 0, i32 0, !dbg !728
  %11 = load i8*, i8** %10, align 8, !dbg !728
  call void %8(i8* noundef %11), !dbg !726
  ret void, !dbg !729
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !730 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !736, metadata !DIExpression()), !dbg !737
  call void @llvm.dbg.declare(metadata i8** %3, metadata !738, metadata !DIExpression()), !dbg !739
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !740
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !741
  %6 = load i8*, i8** %5, align 8, !dbg !741
  %7 = call i8* asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #5, !dbg !742, !srcloc !743
  store i8* %7, i8** %3, align 8, !dbg !742
  %8 = load i8*, i8** %3, align 8, !dbg !744
  ret i8* %8, !dbg !745
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vmem_get_alloc_count() #0 !dbg !746 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !749, metadata !DIExpression()), !dbg !750
  %2 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef @_g_vmem_alloc_count), !dbg !751
  store i64 %2, i64* %1, align 8, !dbg !750
  br label %3, !dbg !752

3:                                                ; preds = %0
  br label %4, !dbg !753

4:                                                ; preds = %3
  %5 = load i64, i64* %1, align 8, !dbg !755
  br label %6, !dbg !755

6:                                                ; preds = %4
  br label %7, !dbg !757

7:                                                ; preds = %6
  br label %8, !dbg !755

8:                                                ; preds = %7
  br label %9, !dbg !753

9:                                                ; preds = %8
  %10 = load i64, i64* %1, align 8, !dbg !759
  ret i64 %10, !dbg !760
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vmem_get_free_count() #0 !dbg !761 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !762, metadata !DIExpression()), !dbg !763
  %2 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef @_g_vmem_free_count), !dbg !764
  store i64 %2, i64* %1, align 8, !dbg !763
  br label %3, !dbg !765

3:                                                ; preds = %0
  br label %4, !dbg !766

4:                                                ; preds = %3
  %5 = load i64, i64* %1, align 8, !dbg !768
  br label %6, !dbg !768

6:                                                ; preds = %4
  br label %7, !dbg !770

7:                                                ; preds = %6
  br label %8, !dbg !768

8:                                                ; preds = %7
  br label %9, !dbg !766

9:                                                ; preds = %8
  %10 = load i64, i64* %1, align 8, !dbg !772
  ret i64 %10, !dbg !773
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !774 {
  %2 = alloca %struct.vatomic64_s*, align 8
  %3 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !779, metadata !DIExpression()), !dbg !780
  call void @llvm.dbg.declare(metadata i64* %3, metadata !781, metadata !DIExpression()), !dbg !782
  %4 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !783
  %5 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %4, i32 0, i32 0, !dbg !784
  %6 = load i64, i64* %5, align 8, !dbg !784
  %7 = call i64 asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i64 %6) #5, !dbg !785, !srcloc !786
  store i64 %7, i64* %3, align 8, !dbg !785
  %8 = load i64, i64* %3, align 8, !dbg !787
  ret i64 %8, !dbg !788
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_init() #0 !dbg !789 {
  call void @locked_trace_init(%struct.locked_trace_s* noundef @global_trace, i64 noundef 100), !dbg !790
  ret void, !dbg !791
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_init(%struct.vqueue_ub_s* noundef %0) #0 !dbg !792 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !795, metadata !DIExpression()), !dbg !796
  %3 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !797
  %4 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %3, i32 0, i32 4, !dbg !798
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !799
  %6 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %5, i32 0, i32 2, !dbg !800
  store %struct.vqueue_ub_node_s* %4, %struct.vqueue_ub_node_s** %6, align 8, !dbg !801
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !802
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 4, !dbg !803
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !804
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 3, !dbg !805
  store %struct.vqueue_ub_node_s* %8, %struct.vqueue_ub_node_s** %10, align 8, !dbg !806
  %11 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !807
  %12 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %11, i32 0, i32 4, !dbg !808
  call void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %12, i8* noundef null), !dbg !809
  %13 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !810
  %14 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %13, i32 0, i32 0, !dbg !811
  call void @queue_lock_init(%union.pthread_mutex_t* noundef %14), !dbg !812
  %15 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !813
  %16 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %15, i32 0, i32 1, !dbg !814
  call void @queue_lock_init(%union.pthread_mutex_t* noundef %16), !dbg !815
  ret void, !dbg !816
}

; Function Attrs: noinline nounwind uwtable
define internal void @locked_trace_init(%struct.locked_trace_s* noundef %0, i64 noundef %1) #0 !dbg !817 {
  %3 = alloca %struct.locked_trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.locked_trace_s* %0, %struct.locked_trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.locked_trace_s** %3, metadata !821, metadata !DIExpression()), !dbg !822
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !823, metadata !DIExpression()), !dbg !824
  %5 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !825
  %6 = icmp ne %struct.locked_trace_s* %5, null, !dbg !825
  br i1 %6, label %7, label %8, !dbg !828

7:                                                ; preds = %2
  br label %9, !dbg !828

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([64 x i8], [64 x i8]* @.str.10, i64 0, i64 0), i32 noundef 16, i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @__PRETTY_FUNCTION__.locked_trace_init, i64 0, i64 0)) #6, !dbg !825
  unreachable, !dbg !825

9:                                                ; preds = %7
  %10 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !829
  %11 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %10, i32 0, i32 1, !dbg !830
  %12 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %11, %union.pthread_mutexattr_t* noundef null) #5, !dbg !831
  %13 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !832
  %14 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %13, i32 0, i32 0, !dbg !833
  %15 = load i64, i64* %4, align 8, !dbg !834
  call void @trace_init(%struct.trace_s* noundef %14, i64 noundef %15), !dbg !835
  ret void, !dbg !836
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @trace_init(%struct.trace_s* noundef %0, i64 noundef %1) #0 !dbg !837 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !841, metadata !DIExpression()), !dbg !842
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !843, metadata !DIExpression()), !dbg !844
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !845
  %6 = icmp ne %struct.trace_s* %5, null, !dbg !845
  br i1 %6, label %7, label %8, !dbg !848

7:                                                ; preds = %2
  br label %9, !dbg !848

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.11, i64 0, i64 0), i32 noundef 30, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #6, !dbg !845
  unreachable, !dbg !845

9:                                                ; preds = %7
  %10 = load i64, i64* %4, align 8, !dbg !849
  %11 = mul i64 %10, 16, !dbg !850
  %12 = call noalias i8* @malloc(i64 noundef %11) #5, !dbg !851
  %13 = bitcast i8* %12 to %struct.trace_unit_s*, !dbg !851
  %14 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !852
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 0, !dbg !853
  store %struct.trace_unit_s* %13, %struct.trace_unit_s** %15, align 8, !dbg !854
  %16 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !855
  %17 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %16, i32 0, i32 0, !dbg !857
  %18 = load %struct.trace_unit_s*, %struct.trace_unit_s** %17, align 8, !dbg !857
  %19 = icmp ne %struct.trace_unit_s* %18, null, !dbg !855
  br i1 %19, label %20, label %28, !dbg !858

20:                                               ; preds = %9
  %21 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !859
  %22 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %21, i32 0, i32 1, !dbg !861
  store i64 0, i64* %22, align 8, !dbg !862
  %23 = load i64, i64* %4, align 8, !dbg !863
  %24 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !864
  %25 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %24, i32 0, i32 2, !dbg !865
  store i64 %23, i64* %25, align 8, !dbg !866
  %26 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !867
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 3, !dbg !868
  store i8 1, i8* %27, align 8, !dbg !869
  br label %35, !dbg !870

28:                                               ; preds = %9
  %29 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !871
  %30 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %29, i32 0, i32 1, !dbg !873
  store i64 0, i64* %30, align 8, !dbg !874
  %31 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !875
  %32 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %31, i32 0, i32 2, !dbg !876
  store i64 0, i64* %32, align 8, !dbg !877
  %33 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !878
  %34 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %33, i32 0, i32 3, !dbg !879
  store i8 0, i8* %34, align 8, !dbg !880
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.12, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.11, i64 0, i64 0), i32 noundef 40, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #6, !dbg !881
  unreachable, !dbg !881

35:                                               ; preds = %20
  ret void, !dbg !884
}

; Function Attrs: noinline nounwind uwtable
define internal void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !885 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !886, metadata !DIExpression()), !dbg !887
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !888, metadata !DIExpression()), !dbg !889
  %5 = load i8*, i8** %4, align 8, !dbg !890
  %6 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !891
  %7 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %6, i32 0, i32 0, !dbg !892
  store i8* %5, i8** %7, align 8, !dbg !893
  %8 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !894
  %9 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %8, i32 0, i32 1, !dbg !895
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %9, i8* noundef null), !dbg !896
  ret void, !dbg !897
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_init(%union.pthread_mutex_t* noundef %0) #0 !dbg !898 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !902, metadata !DIExpression()), !dbg !903
  %3 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !903
  %4 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %3, %union.pthread_mutexattr_t* noundef null) #5, !dbg !903
  ret void, !dbg !903
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !904 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !908, metadata !DIExpression()), !dbg !909
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !910, metadata !DIExpression()), !dbg !911
  %5 = load i8*, i8** %4, align 8, !dbg !912
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !913
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !914
  %8 = load i8*, i8** %7, align 8, !dbg !914
  call void asm sideeffect "str ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #5, !dbg !915, !srcloc !916
  ret void, !dbg !917
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_reg(i64 noundef %0) #0 !dbg !918 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !919, metadata !DIExpression()), !dbg !920
  br label %3, !dbg !921

3:                                                ; preds = %1
  br label %4, !dbg !922

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !924
  br label %6, !dbg !924

6:                                                ; preds = %4
  br label %7, !dbg !926

7:                                                ; preds = %6
  br label %8, !dbg !924

8:                                                ; preds = %7
  br label %9, !dbg !922

9:                                                ; preds = %8
  ret void, !dbg !928
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_dereg(i64 noundef %0) #0 !dbg !929 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !930, metadata !DIExpression()), !dbg !931
  br label %3, !dbg !932

3:                                                ; preds = %1
  br label %4, !dbg !933

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !935
  br label %6, !dbg !935

6:                                                ; preds = %4
  br label %7, !dbg !937

7:                                                ; preds = %6
  br label %8, !dbg !935

8:                                                ; preds = %7
  br label %9, !dbg !933

9:                                                ; preds = %8
  ret void, !dbg !939
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !940 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  %9 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !943, metadata !DIExpression()), !dbg !944
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !945, metadata !DIExpression()), !dbg !946
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !947, metadata !DIExpression()), !dbg !948
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !949, metadata !DIExpression()), !dbg !950
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !950
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !951, metadata !DIExpression()), !dbg !952
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !952
  call void @llvm.dbg.declare(metadata i8** %9, metadata !953, metadata !DIExpression()), !dbg !954
  store i8* null, i8** %9, align 8, !dbg !954
  %10 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !955
  %11 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %10, i32 0, i32 1, !dbg !956
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %11), !dbg !957
  %12 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !958
  %13 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %12, i32 0, i32 2, !dbg !959
  %14 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %13, align 8, !dbg !959
  store %struct.vqueue_ub_node_s* %14, %struct.vqueue_ub_node_s** %8, align 8, !dbg !960
  %15 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !961
  %16 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %15, i32 0, i32 1, !dbg !962
  %17 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %16), !dbg !963
  %18 = bitcast i8* %17 to %struct.vqueue_ub_node_s*, !dbg !964
  store %struct.vqueue_ub_node_s* %18, %struct.vqueue_ub_node_s** %7, align 8, !dbg !965
  %19 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !966
  %20 = icmp ne %struct.vqueue_ub_node_s* %19, null, !dbg !966
  br i1 %20, label %21, label %37, !dbg !968

21:                                               ; preds = %3
  %22 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !969
  %23 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %22, i32 0, i32 0, !dbg !971
  %24 = load i8*, i8** %23, align 8, !dbg !971
  store i8* %24, i8** %9, align 8, !dbg !972
  %25 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !973
  %26 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !974
  %27 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %26, i32 0, i32 2, !dbg !975
  store %struct.vqueue_ub_node_s* %25, %struct.vqueue_ub_node_s** %27, align 8, !dbg !976
  %28 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !977
  %29 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !979
  %30 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %29, i32 0, i32 4, !dbg !980
  %31 = icmp ne %struct.vqueue_ub_node_s* %28, %30, !dbg !981
  br i1 %31, label %32, label %36, !dbg !982

32:                                               ; preds = %21
  %33 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !983
  %34 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !985
  %35 = load i8*, i8** %6, align 8, !dbg !986
  call void %33(%struct.vqueue_ub_node_s* noundef %34, i8* noundef %35), !dbg !983
  br label %36, !dbg !987

36:                                               ; preds = %32, %21
  br label %37, !dbg !988

37:                                               ; preds = %36, %3
  %38 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !989
  %39 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %38, i32 0, i32 1, !dbg !990
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %39), !dbg !991
  %40 = load i8*, i8** %9, align 8, !dbg !992
  ret i8* %40, !dbg !993
}

; Function Attrs: noinline nounwind uwtable
define internal void @_queue_destroy(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !994 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !997, metadata !DIExpression()), !dbg !998
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !999, metadata !DIExpression()), !dbg !1000
  %5 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1001
  %6 = bitcast %struct.vqueue_ub_node_s* %5 to i8*, !dbg !1001
  call void @vmem_free(i8* noundef %6), !dbg !1002
  br label %7, !dbg !1003

7:                                                ; preds = %2
  br label %8, !dbg !1004

8:                                                ; preds = %7
  %9 = load i8*, i8** %4, align 8, !dbg !1006
  br label %10, !dbg !1006

10:                                               ; preds = %8
  br label %11, !dbg !1008

11:                                               ; preds = %10
  br label %12, !dbg !1006

12:                                               ; preds = %11
  br label %13, !dbg !1004

13:                                               ; preds = %12
  ret void, !dbg !1010
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_destroy(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !1011 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !1012, metadata !DIExpression()), !dbg !1013
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !1014, metadata !DIExpression()), !dbg !1015
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !1016, metadata !DIExpression()), !dbg !1017
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !1018, metadata !DIExpression()), !dbg !1019
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1019
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !1020, metadata !DIExpression()), !dbg !1021
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1021
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1022
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 2, !dbg !1023
  %11 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !1023
  store %struct.vqueue_ub_node_s* %11, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1024
  br label %12, !dbg !1025

12:                                               ; preds = %28, %3
  %13 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1026
  %14 = icmp ne %struct.vqueue_ub_node_s* %13, null, !dbg !1025
  br i1 %14, label %15, label %30, !dbg !1025

15:                                               ; preds = %12
  %16 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1027
  %17 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %16, i32 0, i32 1, !dbg !1029
  %18 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %17), !dbg !1030
  %19 = bitcast i8* %18 to %struct.vqueue_ub_node_s*, !dbg !1031
  store %struct.vqueue_ub_node_s* %19, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1032
  %20 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1033
  %21 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1035
  %22 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %21, i32 0, i32 4, !dbg !1036
  %23 = icmp ne %struct.vqueue_ub_node_s* %20, %22, !dbg !1037
  br i1 %23, label %24, label %28, !dbg !1038

24:                                               ; preds = %15
  %25 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !1039
  %26 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1041
  %27 = load i8*, i8** %6, align 8, !dbg !1042
  call void %25(%struct.vqueue_ub_node_s* noundef %26, i8* noundef %27), !dbg !1039
  br label %28, !dbg !1043

28:                                               ; preds = %24, %15
  %29 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1044
  store %struct.vqueue_ub_node_s* %29, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1045
  br label %12, !dbg !1025, !llvm.loop !1046

30:                                               ; preds = %12
  ret void, !dbg !1048
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_destroy() #0 !dbg !1049 {
  call void @locked_trace_destroy(%struct.locked_trace_s* noundef @global_trace, i1 (%struct.trace_unit_s*)* noundef @_ismr_none_destroy_all_cb), !dbg !1050
  ret void, !dbg !1051
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_acquire(%union.pthread_mutex_t* noundef %0) #0 !dbg !1052 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !1053, metadata !DIExpression()), !dbg !1054
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1055, metadata !DIExpression()), !dbg !1054
  %4 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !1054
  %5 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef %4) #5, !dbg !1054
  store i32 %5, i32* %3, align 4, !dbg !1054
  %6 = load i32, i32* %3, align 4, !dbg !1056
  %7 = icmp eq i32 %6, 0, !dbg !1056
  br i1 %7, label %8, label %9, !dbg !1059

8:                                                ; preds = %1
  br label %10, !dbg !1059

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.14, i64 0, i64 0), i8* noundef getelementptr inbounds ([101 x i8], [101 x i8]* @.str.15, i64 0, i64 0), i32 noundef 32, i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.queue_lock_acquire, i64 0, i64 0)) #6, !dbg !1056
  unreachable, !dbg !1056

10:                                               ; preds = %8
  ret void, !dbg !1054
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %0) #0 !dbg !1060 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !1061, metadata !DIExpression()), !dbg !1062
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1063, metadata !DIExpression()), !dbg !1064
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !1065
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !1066
  %6 = load i8*, i8** %5, align 8, !dbg !1066
  %7 = call i8* asm sideeffect "ldar ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #5, !dbg !1067, !srcloc !1068
  store i8* %7, i8** %3, align 8, !dbg !1067
  %8 = load i8*, i8** %3, align 8, !dbg !1069
  ret i8* %8, !dbg !1070
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_release(%union.pthread_mutex_t* noundef %0) #0 !dbg !1071 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !1072, metadata !DIExpression()), !dbg !1073
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1074, metadata !DIExpression()), !dbg !1073
  %4 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !1073
  %5 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef %4) #5, !dbg !1073
  store i32 %5, i32* %3, align 4, !dbg !1073
  %6 = load i32, i32* %3, align 4, !dbg !1075
  %7 = icmp eq i32 %6, 0, !dbg !1075
  br i1 %7, label %8, label %9, !dbg !1078

8:                                                ; preds = %1
  br label %10, !dbg !1078

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.14, i64 0, i64 0), i8* noundef getelementptr inbounds ([101 x i8], [101 x i8]* @.str.15, i64 0, i64 0), i32 noundef 32, i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.queue_lock_release, i64 0, i64 0)) #6, !dbg !1075
  unreachable, !dbg !1075

10:                                               ; preds = %8
  ret void, !dbg !1073
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @vmem_free(i8* noundef %0) #0 !dbg !1079 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !1080, metadata !DIExpression()), !dbg !1081
  %3 = load i8*, i8** %2, align 8, !dbg !1082
  call void @free(i8* noundef %3) #5, !dbg !1083
  %4 = load i8*, i8** %2, align 8, !dbg !1084
  %5 = icmp ne i8* %4, null, !dbg !1084
  br i1 %5, label %6, label %7, !dbg !1086

6:                                                ; preds = %1
  call void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef @_g_vmem_free_count), !dbg !1087
  br label %7, !dbg !1089

7:                                                ; preds = %6, %1
  ret void, !dbg !1090
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !1091 {
  %2 = alloca %struct.vatomic64_s*, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !1096, metadata !DIExpression()), !dbg !1097
  %3 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !1098
  %4 = call i64 @vatomic64_get_inc_rlx(%struct.vatomic64_s* noundef %3), !dbg !1099
  ret void, !dbg !1100
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_get_inc_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !1101 {
  %2 = alloca %struct.vatomic64_s*, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !1104, metadata !DIExpression()), !dbg !1105
  %3 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !1106
  %4 = call i64 @vatomic64_get_add_rlx(%struct.vatomic64_s* noundef %3, i64 noundef 1), !dbg !1107
  ret i64 %4, !dbg !1108
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_get_add_rlx(%struct.vatomic64_s* noundef %0, i64 noundef %1) #0 !dbg !1109 {
  %3 = alloca %struct.vatomic64_s*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %3, metadata !1113, metadata !DIExpression()), !dbg !1114
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1115, metadata !DIExpression()), !dbg !1116
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1117, metadata !DIExpression()), !dbg !1118
  call void @llvm.dbg.declare(metadata i32* %6, metadata !1119, metadata !DIExpression()), !dbg !1123
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1124, metadata !DIExpression()), !dbg !1125
  %8 = load i64, i64* %4, align 8, !dbg !1126
  %9 = load %struct.vatomic64_s*, %struct.vatomic64_s** %3, align 8, !dbg !1127
  %10 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %9, i32 0, i32 0, !dbg !1128
  %11 = load i64, i64* %10, align 8, !dbg !1128
  %12 = call { i64, i64, i32, i64 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:x}, $4\0Aadd ${1:x}, ${0:x}, ${3:x}\0Astxr ${2:w}, ${1:x}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i64 %11, i64 %8) #5, !dbg !1126, !srcloc !1129
  %13 = extractvalue { i64, i64, i32, i64 } %12, 0, !dbg !1126
  %14 = extractvalue { i64, i64, i32, i64 } %12, 1, !dbg !1126
  %15 = extractvalue { i64, i64, i32, i64 } %12, 2, !dbg !1126
  %16 = extractvalue { i64, i64, i32, i64 } %12, 3, !dbg !1126
  store i64 %13, i64* %5, align 8, !dbg !1126
  store i64 %14, i64* %7, align 8, !dbg !1126
  store i32 %15, i32* %6, align 4, !dbg !1126
  store i64 %16, i64* %4, align 8, !dbg !1126
  %17 = load i64, i64* %5, align 8, !dbg !1130
  ret i64 %17, !dbg !1131
}

; Function Attrs: noinline nounwind uwtable
define internal void @locked_trace_destroy(%struct.locked_trace_s* noundef %0, i1 (%struct.trace_unit_s*)* noundef %1) #0 !dbg !1132 {
  %3 = alloca %struct.locked_trace_s*, align 8
  %4 = alloca i1 (%struct.trace_unit_s*)*, align 8
  store %struct.locked_trace_s* %0, %struct.locked_trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.locked_trace_s** %3, metadata !1139, metadata !DIExpression()), !dbg !1140
  store i1 (%struct.trace_unit_s*)* %1, i1 (%struct.trace_unit_s*)** %4, align 8
  call void @llvm.dbg.declare(metadata i1 (%struct.trace_unit_s*)** %4, metadata !1141, metadata !DIExpression()), !dbg !1142
  %5 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1143
  %6 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %5, i32 0, i32 0, !dbg !1144
  %7 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %4, align 8, !dbg !1145
  %8 = call zeroext i1 @trace_verify(%struct.trace_s* noundef %6, i1 (%struct.trace_unit_s*)* noundef %7), !dbg !1146
  %9 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1147
  %10 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %9, i32 0, i32 0, !dbg !1148
  call void @trace_destroy(%struct.trace_s* noundef %10), !dbg !1149
  %11 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1150
  %12 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %11, i32 0, i32 1, !dbg !1151
  %13 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef %12) #5, !dbg !1152
  ret void, !dbg !1153
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @_ismr_none_destroy_all_cb(%struct.trace_unit_s* noundef %0) #0 !dbg !1154 {
  %2 = alloca %struct.trace_unit_s*, align 8
  %3 = alloca %struct.smr_none_retire_info_t*, align 8
  store %struct.trace_unit_s* %0, %struct.trace_unit_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %2, metadata !1155, metadata !DIExpression()), !dbg !1156
  %4 = load %struct.trace_unit_s*, %struct.trace_unit_s** %2, align 8, !dbg !1157
  %5 = icmp ne %struct.trace_unit_s* %4, null, !dbg !1157
  br i1 %5, label %6, label %7, !dbg !1160

6:                                                ; preds = %1
  br label %8, !dbg !1160

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([70 x i8], [70 x i8]* @.str.19, i64 0, i64 0), i32 noundef 27, i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @__PRETTY_FUNCTION__._ismr_none_destroy_all_cb, i64 0, i64 0)) #6, !dbg !1157
  unreachable, !dbg !1157

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata %struct.smr_none_retire_info_t** %3, metadata !1161, metadata !DIExpression()), !dbg !1162
  %9 = load %struct.trace_unit_s*, %struct.trace_unit_s** %2, align 8, !dbg !1163
  %10 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %9, i32 0, i32 0, !dbg !1164
  %11 = load i64, i64* %10, align 8, !dbg !1164
  %12 = inttoptr i64 %11 to %struct.smr_none_retire_info_t*, !dbg !1165
  store %struct.smr_none_retire_info_t* %12, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1162
  %13 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1166
  %14 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %13, i32 0, i32 1, !dbg !1167
  %15 = load void (%struct.smr_node_s*, i8*)*, void (%struct.smr_node_s*, i8*)** %14, align 8, !dbg !1167
  %16 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1168
  %17 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %16, i32 0, i32 0, !dbg !1169
  %18 = load %struct.smr_node_s*, %struct.smr_node_s** %17, align 8, !dbg !1169
  %19 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1170
  %20 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %19, i32 0, i32 2, !dbg !1171
  %21 = load i8*, i8** %20, align 8, !dbg !1171
  call void %15(%struct.smr_node_s* noundef %18, i8* noundef %21), !dbg !1166
  %22 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1172
  %23 = bitcast %struct.smr_none_retire_info_t* %22 to i8*, !dbg !1172
  call void @free(i8* noundef %23) #5, !dbg !1173
  ret i1 true, !dbg !1174
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @trace_verify(%struct.trace_s* noundef %0, i1 (%struct.trace_unit_s*)* noundef %1) #0 !dbg !1175 {
  %3 = alloca i1, align 1
  %4 = alloca %struct.trace_s*, align 8
  %5 = alloca i1 (%struct.trace_unit_s*)*, align 8
  %6 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !1178, metadata !DIExpression()), !dbg !1179
  store i1 (%struct.trace_unit_s*)* %1, i1 (%struct.trace_unit_s*)** %5, align 8
  call void @llvm.dbg.declare(metadata i1 (%struct.trace_unit_s*)** %5, metadata !1180, metadata !DIExpression()), !dbg !1181
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1182, metadata !DIExpression()), !dbg !1183
  store i64 0, i64* %6, align 8, !dbg !1183
  %7 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1184
  %8 = icmp ne %struct.trace_s* %7, null, !dbg !1184
  br i1 %8, label %9, label %10, !dbg !1187

9:                                                ; preds = %2
  br label %11, !dbg !1187

10:                                               ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.11, i64 0, i64 0), i32 noundef 214, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #6, !dbg !1184
  unreachable, !dbg !1184

11:                                               ; preds = %9
  %12 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1188
  %13 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %12, i32 0, i32 3, !dbg !1188
  %14 = load i8, i8* %13, align 8, !dbg !1188
  %15 = trunc i8 %14 to i1, !dbg !1188
  br i1 %15, label %16, label %17, !dbg !1191

16:                                               ; preds = %11
  br label %18, !dbg !1191

17:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.16, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.11, i64 0, i64 0), i32 noundef 215, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #6, !dbg !1188
  unreachable, !dbg !1188

18:                                               ; preds = %16
  %19 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %5, align 8, !dbg !1192
  %20 = icmp ne i1 (%struct.trace_unit_s*)* %19, null, !dbg !1192
  br i1 %20, label %21, label %22, !dbg !1195

21:                                               ; preds = %18
  br label %23, !dbg !1195

22:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.17, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.11, i64 0, i64 0), i32 noundef 216, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #6, !dbg !1192
  unreachable, !dbg !1192

23:                                               ; preds = %21
  store i64 0, i64* %6, align 8, !dbg !1196
  br label %24, !dbg !1198

24:                                               ; preds = %42, %23
  %25 = load i64, i64* %6, align 8, !dbg !1199
  %26 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1201
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 1, !dbg !1202
  %28 = load i64, i64* %27, align 8, !dbg !1202
  %29 = icmp ult i64 %25, %28, !dbg !1203
  br i1 %29, label %30, label %45, !dbg !1204

30:                                               ; preds = %24
  %31 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %5, align 8, !dbg !1205
  %32 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1208
  %33 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %32, i32 0, i32 0, !dbg !1209
  %34 = load %struct.trace_unit_s*, %struct.trace_unit_s** %33, align 8, !dbg !1209
  %35 = load i64, i64* %6, align 8, !dbg !1210
  %36 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %34, i64 %35, !dbg !1208
  %37 = call zeroext i1 %31(%struct.trace_unit_s* noundef %36), !dbg !1205
  %38 = zext i1 %37 to i32, !dbg !1205
  %39 = icmp eq i32 %38, 0, !dbg !1211
  br i1 %39, label %40, label %41, !dbg !1212

40:                                               ; preds = %30
  store i1 false, i1* %3, align 1, !dbg !1213
  br label %46, !dbg !1213

41:                                               ; preds = %30
  br label %42, !dbg !1215

42:                                               ; preds = %41
  %43 = load i64, i64* %6, align 8, !dbg !1216
  %44 = add i64 %43, 1, !dbg !1216
  store i64 %44, i64* %6, align 8, !dbg !1216
  br label %24, !dbg !1217, !llvm.loop !1218

45:                                               ; preds = %24
  store i1 true, i1* %3, align 1, !dbg !1220
  br label %46, !dbg !1220

46:                                               ; preds = %45, %40
  %47 = load i1, i1* %3, align 1, !dbg !1221
  ret i1 %47, !dbg !1221
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_destroy(%struct.trace_s* noundef %0) #0 !dbg !1222 {
  %2 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %2, metadata !1225, metadata !DIExpression()), !dbg !1226
  %3 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1227
  %4 = icmp ne %struct.trace_s* %3, null, !dbg !1227
  br i1 %4, label %5, label %6, !dbg !1230

5:                                                ; preds = %1
  br label %7, !dbg !1230

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.11, i64 0, i64 0), i32 noundef 99, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #6, !dbg !1227
  unreachable, !dbg !1227

7:                                                ; preds = %5
  %8 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1231
  %9 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %8, i32 0, i32 3, !dbg !1231
  %10 = load i8, i8* %9, align 8, !dbg !1231
  %11 = trunc i8 %10 to i1, !dbg !1231
  br i1 %11, label %12, label %13, !dbg !1234

12:                                               ; preds = %7
  br label %14, !dbg !1234

13:                                               ; preds = %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.16, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.11, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #6, !dbg !1231
  unreachable, !dbg !1231

14:                                               ; preds = %12
  %15 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1235
  %16 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %15, i32 0, i32 0, !dbg !1236
  %17 = load %struct.trace_unit_s*, %struct.trace_unit_s** %16, align 8, !dbg !1236
  %18 = bitcast %struct.trace_unit_s* %17 to i8*, !dbg !1235
  call void @free(i8* noundef %18) #5, !dbg !1237
  %19 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1238
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 3, !dbg !1239
  store i8 0, i8* %20, align 8, !dbg !1240
  ret void, !dbg !1241
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal i8* @vmem_malloc(i64 noundef %0) #0 !dbg !1242 {
  %2 = alloca i64, align 8
  %3 = alloca i8*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1245, metadata !DIExpression()), !dbg !1246
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1247, metadata !DIExpression()), !dbg !1248
  %4 = load i64, i64* %2, align 8, !dbg !1249
  %5 = call noalias i8* @malloc(i64 noundef %4) #5, !dbg !1250
  store i8* %5, i8** %3, align 8, !dbg !1248
  %6 = load i8*, i8** %3, align 8, !dbg !1251
  %7 = icmp ne i8* %6, null, !dbg !1251
  br i1 %7, label %8, label %9, !dbg !1253

8:                                                ; preds = %1
  call void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef @_g_vmem_alloc_count), !dbg !1254
  br label %10, !dbg !1256

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.12, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.20, i64 0, i64 0), i32 noundef 28, i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @__PRETTY_FUNCTION__.vmem_malloc, i64 0, i64 0)) #6, !dbg !1257
  unreachable, !dbg !1257

10:                                               ; preds = %8
  %11 = load i8*, i8** %3, align 8, !dbg !1261
  ret i8* %11, !dbg !1262
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_enter(i64 noundef %0) #0 !dbg !1263 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1264, metadata !DIExpression()), !dbg !1265
  br label %3, !dbg !1266

3:                                                ; preds = %1
  br label %4, !dbg !1267

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1269
  br label %6, !dbg !1269

6:                                                ; preds = %4
  br label %7, !dbg !1271

7:                                                ; preds = %6
  br label %8, !dbg !1269

8:                                                ; preds = %7
  br label %9, !dbg !1267

9:                                                ; preds = %8
  ret void, !dbg !1273
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_enq(%struct.vqueue_ub_s* noundef %0, %struct.vqueue_ub_node_s* noundef %1, i8* noundef %2) #0 !dbg !1274 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca %struct.vqueue_ub_node_s*, align 8
  %6 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !1277, metadata !DIExpression()), !dbg !1278
  store %struct.vqueue_ub_node_s* %1, %struct.vqueue_ub_node_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %5, metadata !1279, metadata !DIExpression()), !dbg !1280
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !1281, metadata !DIExpression()), !dbg !1282
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1283
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 0, !dbg !1284
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %8), !dbg !1285
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1286
  %10 = load i8*, i8** %6, align 8, !dbg !1287
  call void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %9, i8* noundef %10), !dbg !1288
  %11 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1289
  %12 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %11, i32 0, i32 3, !dbg !1290
  %13 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %12, align 8, !dbg !1290
  %14 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %13, i32 0, i32 1, !dbg !1291
  %15 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1292
  %16 = bitcast %struct.vqueue_ub_node_s* %15 to i8*, !dbg !1292
  call void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %14, i8* noundef %16), !dbg !1293
  %17 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1294
  %18 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1295
  %19 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %18, i32 0, i32 3, !dbg !1296
  store %struct.vqueue_ub_node_s* %17, %struct.vqueue_ub_node_s** %19, align 8, !dbg !1297
  %20 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1298
  %21 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %20, i32 0, i32 0, !dbg !1299
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %21), !dbg !1300
  ret void, !dbg !1301
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_exit(i64 noundef %0) #0 !dbg !1302 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1303, metadata !DIExpression()), !dbg !1304
  br label %3, !dbg !1305

3:                                                ; preds = %1
  br label %4, !dbg !1306

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1308
  br label %6, !dbg !1308

6:                                                ; preds = %4
  br label %7, !dbg !1310

7:                                                ; preds = %6
  br label %8, !dbg !1308

8:                                                ; preds = %7
  br label %9, !dbg !1306

9:                                                ; preds = %8
  ret void, !dbg !1312
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1313 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1314, metadata !DIExpression()), !dbg !1315
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1316, metadata !DIExpression()), !dbg !1317
  %5 = load i8*, i8** %4, align 8, !dbg !1318
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !1319
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !1320
  %8 = load i8*, i8** %7, align 8, !dbg !1320
  call void asm sideeffect "stlr ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #5, !dbg !1321, !srcloc !1322
  ret void, !dbg !1323
}

; Function Attrs: noinline nounwind uwtable
define internal void @_queue_retire(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !1324 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1325, metadata !DIExpression()), !dbg !1326
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1327, metadata !DIExpression()), !dbg !1328
  %5 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1329
  %6 = bitcast %struct.vqueue_ub_node_s* %5 to i8*, !dbg !1329
  call void @vmem_free(i8* noundef %6), !dbg !1330
  br label %7, !dbg !1331

7:                                                ; preds = %2
  br label %8, !dbg !1332

8:                                                ; preds = %7
  %9 = load i8*, i8** %4, align 8, !dbg !1334
  br label %10, !dbg !1334

10:                                               ; preds = %8
  br label %11, !dbg !1336

11:                                               ; preds = %10
  br label %12, !dbg !1334

12:                                               ; preds = %11
  br label %13, !dbg !1332

13:                                               ; preds = %12
  ret void, !dbg !1338
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @vqueue_ub_empty(%struct.vqueue_ub_s* noundef %0) #0 !dbg !1339 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !1342, metadata !DIExpression()), !dbg !1343
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1344, metadata !DIExpression()), !dbg !1345
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1345
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %4, metadata !1346, metadata !DIExpression()), !dbg !1347
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1347
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1348
  %6 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %5, i32 0, i32 1, !dbg !1349
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %6), !dbg !1350
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1351
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 2, !dbg !1352
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1352
  store %struct.vqueue_ub_node_s* %9, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1353
  %10 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1354
  %11 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %10, i32 0, i32 1, !dbg !1355
  %12 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %11), !dbg !1356
  %13 = bitcast i8* %12 to %struct.vqueue_ub_node_s*, !dbg !1357
  store %struct.vqueue_ub_node_s* %13, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1358
  %14 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1359
  %15 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %14, i32 0, i32 1, !dbg !1360
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %15), !dbg !1361
  %16 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1362
  %17 = icmp eq %struct.vqueue_ub_node_s* %16, null, !dbg !1363
  ret i1 %17, !dbg !1364
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

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
!93 = distinct !DIGlobalVariable(name: "msg", scope: !2, file: !94, line: 22, type: !66, isLocal: false, isDefinition: true)
!94 = !DIFile(filename: "datastruct/queue/unbounded/verify/test_case_5.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "16c3149d045d85103f98b24a19a9ad36")
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
!173 = distinct !DISubprogram(name: "t1", scope: !94, file: !94, line: 11, type: !174, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!174 = !DISubroutineType(types: !175)
!175 = !{null, !5}
!176 = !{}
!177 = !DILocalVariable(name: "tid", arg: 1, scope: !173, file: !94, line: 11, type: !5)
!178 = !DILocation(line: 11, column: 12, scope: !173)
!179 = !DILocation(line: 13, column: 9, scope: !173)
!180 = !DILocation(line: 13, column: 5, scope: !173)
!181 = !DILocalVariable(name: "data", scope: !173, file: !94, line: 14, type: !13)
!182 = !DILocation(line: 14, column: 11, scope: !173)
!183 = !DILocation(line: 14, column: 22, scope: !173)
!184 = !DILocation(line: 14, column: 18, scope: !173)
!185 = !DILocation(line: 15, column: 10, scope: !173)
!186 = !DILocation(line: 15, column: 5, scope: !173)
!187 = !DILocation(line: 16, column: 1, scope: !173)
!188 = distinct !DISubprogram(name: "enq", scope: !91, file: !91, line: 94, type: !189, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!189 = !DISubroutineType(types: !190)
!190 = !{null, !5, !84, !143}
!191 = !DILocalVariable(name: "tid", arg: 1, scope: !188, file: !91, line: 94, type: !5)
!192 = !DILocation(line: 94, column: 13, scope: !188)
!193 = !DILocalVariable(name: "k", arg: 2, scope: !188, file: !91, line: 94, type: !84)
!194 = !DILocation(line: 94, column: 28, scope: !188)
!195 = !DILocalVariable(name: "lbl", arg: 3, scope: !188, file: !91, line: 94, type: !143)
!196 = !DILocation(line: 94, column: 36, scope: !188)
!197 = !DILocation(line: 96, column: 15, scope: !188)
!198 = !DILocation(line: 96, column: 30, scope: !188)
!199 = !DILocation(line: 96, column: 33, scope: !188)
!200 = !DILocation(line: 96, column: 5, scope: !188)
!201 = !DILocation(line: 97, column: 1, scope: !188)
!202 = distinct !DISubprogram(name: "deq", scope: !91, file: !91, line: 100, type: !203, scopeLine: 101, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!203 = !DISubroutineType(types: !204)
!204 = !{!205, !5}
!205 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !206, size: 64)
!206 = !DIDerivedType(tag: DW_TAG_typedef, name: "data_t", file: !44, line: 49, baseType: !207)
!207 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "data_s", file: !44, line: 46, size: 128, elements: !208)
!208 = !{!209, !210}
!209 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !207, file: !44, line: 47, baseType: !84, size: 64)
!210 = !DIDerivedType(tag: DW_TAG_member, name: "lbl", scope: !207, file: !44, line: 48, baseType: !143, size: 8, offset: 64)
!211 = !DILocalVariable(name: "tid", arg: 1, scope: !202, file: !91, line: 100, type: !5)
!212 = !DILocation(line: 100, column: 13, scope: !202)
!213 = !DILocation(line: 102, column: 22, scope: !202)
!214 = !DILocation(line: 102, column: 12, scope: !202)
!215 = !DILocation(line: 102, column: 5, scope: !202)
!216 = distinct !DISubprogram(name: "t2", scope: !94, file: !94, line: 24, type: !174, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!217 = !DILocalVariable(name: "tid", arg: 1, scope: !216, file: !94, line: 24, type: !5)
!218 = !DILocation(line: 24, column: 12, scope: !216)
!219 = !DILocation(line: 26, column: 16, scope: !216)
!220 = !DILocalVariable(name: "data", scope: !216, file: !94, line: 27, type: !13)
!221 = !DILocation(line: 27, column: 11, scope: !216)
!222 = !DILocation(line: 27, column: 22, scope: !216)
!223 = !DILocation(line: 27, column: 18, scope: !216)
!224 = !DILocation(line: 28, column: 10, scope: !216)
!225 = !DILocation(line: 28, column: 5, scope: !216)
!226 = !DILocation(line: 29, column: 1, scope: !216)
!227 = distinct !DISubprogram(name: "t3", scope: !94, file: !94, line: 35, type: !174, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!228 = !DILocalVariable(name: "tid", arg: 1, scope: !227, file: !94, line: 35, type: !5)
!229 = !DILocation(line: 35, column: 12, scope: !227)
!230 = !DILocation(line: 38, column: 15, scope: !231)
!231 = distinct !DILexicalBlock(scope: !227, file: !94, line: 38, column: 9)
!232 = !DILocation(line: 38, column: 9, scope: !231)
!233 = !DILocation(line: 38, column: 9, scope: !227)
!234 = !DILocation(line: 39, column: 9, scope: !235)
!235 = distinct !DILexicalBlock(scope: !236, file: !94, line: 39, column: 9)
!236 = distinct !DILexicalBlock(scope: !237, file: !94, line: 39, column: 9)
!237 = distinct !DILexicalBlock(scope: !231, file: !94, line: 38, column: 21)
!238 = !DILocation(line: 39, column: 9, scope: !236)
!239 = !DILocation(line: 40, column: 5, scope: !237)
!240 = !DILocation(line: 41, column: 21, scope: !241)
!241 = distinct !DILexicalBlock(scope: !231, file: !94, line: 40, column: 12)
!242 = !DILocation(line: 41, column: 9, scope: !241)
!243 = !DILocation(line: 43, column: 1, scope: !227)
!244 = distinct !DISubprogram(name: "empty", scope: !91, file: !91, line: 106, type: !245, scopeLine: 107, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!245 = !DISubroutineType(types: !246)
!246 = !{!24, !5}
!247 = !DILocalVariable(name: "tid", arg: 1, scope: !244, file: !91, line: 106, type: !5)
!248 = !DILocation(line: 106, column: 15, scope: !244)
!249 = !DILocation(line: 108, column: 24, scope: !244)
!250 = !DILocation(line: 108, column: 12, scope: !244)
!251 = !DILocation(line: 108, column: 5, scope: !244)
!252 = distinct !DISubprogram(name: "queue_clean", scope: !44, file: !44, line: 248, type: !174, scopeLine: 249, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!253 = !DILocalVariable(name: "tid", arg: 1, scope: !252, file: !44, line: 248, type: !5)
!254 = !DILocation(line: 248, column: 21, scope: !252)
!255 = !DILocation(line: 250, column: 18, scope: !252)
!256 = !DILocation(line: 250, column: 5, scope: !252)
!257 = !DILocation(line: 251, column: 1, scope: !252)
!258 = distinct !DISubprogram(name: "verify", scope: !94, file: !94, line: 45, type: !259, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!259 = !DISubroutineType(types: !260)
!260 = !{null}
!261 = !DILocation(line: 47, column: 5, scope: !262)
!262 = distinct !DILexicalBlock(scope: !263, file: !94, line: 47, column: 5)
!263 = distinct !DILexicalBlock(scope: !258, file: !94, line: 47, column: 5)
!264 = !DILocation(line: 47, column: 5, scope: !263)
!265 = !DILocation(line: 48, column: 1, scope: !258)
!266 = distinct !DISubprogram(name: "main", scope: !91, file: !91, line: 50, type: !267, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!267 = !DISubroutineType(types: !268)
!268 = !{!66}
!269 = !DILocation(line: 52, column: 5, scope: !266)
!270 = !DILocation(line: 53, column: 5, scope: !266)
!271 = !DILocation(line: 55, column: 5, scope: !266)
!272 = !DILocation(line: 56, column: 5, scope: !266)
!273 = !DILocation(line: 57, column: 5, scope: !266)
!274 = !DILocation(line: 58, column: 5, scope: !275)
!275 = distinct !DILexicalBlock(scope: !276, file: !91, line: 58, column: 5)
!276 = distinct !DILexicalBlock(scope: !266, file: !91, line: 58, column: 5)
!277 = !DILocation(line: 58, column: 5, scope: !276)
!278 = !DILocation(line: 59, column: 5, scope: !266)
!279 = distinct !DISubprogram(name: "init", scope: !91, file: !91, line: 63, type: !259, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!280 = !DILocation(line: 65, column: 5, scope: !279)
!281 = !DILocation(line: 70, column: 5, scope: !279)
!282 = !DILocalVariable(name: "lbl", scope: !279, file: !91, line: 79, type: !143)
!283 = !DILocation(line: 79, column: 10, scope: !279)
!284 = !DILocalVariable(name: "i", scope: !285, file: !91, line: 80, type: !5)
!285 = distinct !DILexicalBlock(scope: !279, file: !91, line: 80, column: 5)
!286 = !DILocation(line: 80, column: 18, scope: !285)
!287 = !DILocation(line: 80, column: 10, scope: !285)
!288 = !DILocation(line: 80, column: 25, scope: !289)
!289 = distinct !DILexicalBlock(scope: !285, file: !91, line: 80, column: 5)
!290 = !DILocation(line: 80, column: 27, scope: !289)
!291 = !DILocation(line: 80, column: 5, scope: !285)
!292 = !DILocation(line: 81, column: 16, scope: !293)
!293 = distinct !DILexicalBlock(scope: !289, file: !91, line: 80, column: 61)
!294 = !DILocation(line: 81, column: 19, scope: !293)
!295 = !DILocation(line: 81, column: 9, scope: !293)
!296 = !DILocation(line: 82, column: 5, scope: !293)
!297 = !DILocation(line: 80, column: 50, scope: !289)
!298 = !DILocation(line: 80, column: 57, scope: !289)
!299 = !DILocation(line: 80, column: 5, scope: !289)
!300 = distinct !{!300, !291, !301, !302}
!301 = !DILocation(line: 82, column: 5, scope: !285)
!302 = !{!"llvm.loop.mustprogress"}
!303 = !DILocation(line: 84, column: 5, scope: !279)
!304 = !DILocation(line: 85, column: 1, scope: !279)
!305 = distinct !DISubprogram(name: "launch_threads", scope: !16, file: !16, line: 111, type: !306, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!306 = !DISubroutineType(types: !307)
!307 = !{null, !5, !27}
!308 = !DILocalVariable(name: "thread_count", arg: 1, scope: !305, file: !16, line: 111, type: !5)
!309 = !DILocation(line: 111, column: 24, scope: !305)
!310 = !DILocalVariable(name: "fun", arg: 2, scope: !305, file: !16, line: 111, type: !27)
!311 = !DILocation(line: 111, column: 51, scope: !305)
!312 = !DILocalVariable(name: "threads", scope: !305, file: !16, line: 113, type: !14)
!313 = !DILocation(line: 113, column: 17, scope: !305)
!314 = !DILocation(line: 113, column: 55, scope: !305)
!315 = !DILocation(line: 113, column: 53, scope: !305)
!316 = !DILocation(line: 113, column: 27, scope: !305)
!317 = !DILocation(line: 115, column: 20, scope: !305)
!318 = !DILocation(line: 115, column: 29, scope: !305)
!319 = !DILocation(line: 115, column: 43, scope: !305)
!320 = !DILocation(line: 115, column: 5, scope: !305)
!321 = !DILocation(line: 117, column: 19, scope: !305)
!322 = !DILocation(line: 117, column: 28, scope: !305)
!323 = !DILocation(line: 117, column: 5, scope: !305)
!324 = !DILocation(line: 119, column: 10, scope: !305)
!325 = !DILocation(line: 119, column: 5, scope: !305)
!326 = !DILocation(line: 120, column: 1, scope: !305)
!327 = distinct !DISubprogram(name: "run", scope: !91, file: !91, line: 126, type: !29, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!328 = !DILocalVariable(name: "args", arg: 1, scope: !327, file: !91, line: 126, type: !13)
!329 = !DILocation(line: 126, column: 11, scope: !327)
!330 = !DILocalVariable(name: "tid", scope: !327, file: !91, line: 128, type: !5)
!331 = !DILocation(line: 128, column: 13, scope: !327)
!332 = !DILocation(line: 128, column: 40, scope: !327)
!333 = !DILocation(line: 128, column: 28, scope: !327)
!334 = !DILocation(line: 129, column: 20, scope: !327)
!335 = !DILocation(line: 129, column: 5, scope: !327)
!336 = !DILocation(line: 130, column: 13, scope: !327)
!337 = !DILocation(line: 130, column: 5, scope: !327)
!338 = !DILocation(line: 132, column: 16, scope: !339)
!339 = distinct !DILexicalBlock(scope: !327, file: !91, line: 130, column: 18)
!340 = !DILocation(line: 132, column: 13, scope: !339)
!341 = !DILocation(line: 133, column: 13, scope: !339)
!342 = !DILocation(line: 135, column: 16, scope: !339)
!343 = !DILocation(line: 135, column: 13, scope: !339)
!344 = !DILocation(line: 136, column: 13, scope: !339)
!345 = !DILocation(line: 138, column: 16, scope: !339)
!346 = !DILocation(line: 138, column: 13, scope: !339)
!347 = !DILocation(line: 139, column: 13, scope: !339)
!348 = !DILocation(line: 141, column: 13, scope: !349)
!349 = distinct !DILexicalBlock(scope: !339, file: !91, line: 141, column: 13)
!350 = !DILocation(line: 141, column: 13, scope: !351)
!351 = distinct !DILexicalBlock(scope: !349, file: !91, line: 141, column: 13)
!352 = !DILocation(line: 142, column: 5, scope: !339)
!353 = !DILocation(line: 143, column: 22, scope: !327)
!354 = !DILocation(line: 143, column: 5, scope: !327)
!355 = !DILocation(line: 144, column: 5, scope: !327)
!356 = distinct !DISubprogram(name: "queue_print", scope: !44, file: !44, line: 235, type: !357, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!357 = !DISubroutineType(types: !358)
!358 = !{null, !359, !43}
!359 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !151, size: 64)
!360 = !DILocalVariable(name: "q", arg: 1, scope: !356, file: !44, line: 235, type: !359)
!361 = !DILocation(line: 235, column: 26, scope: !356)
!362 = !DILocalVariable(name: "print", arg: 2, scope: !356, file: !44, line: 235, type: !43)
!363 = !DILocation(line: 235, column: 41, scope: !356)
!364 = !DILocation(line: 237, column: 28, scope: !356)
!365 = !DILocation(line: 237, column: 56, scope: !356)
!366 = !DILocation(line: 237, column: 48, scope: !356)
!367 = !DILocation(line: 237, column: 5, scope: !356)
!368 = !DILocation(line: 238, column: 1, scope: !356)
!369 = distinct !DISubprogram(name: "get_final_state", scope: !91, file: !91, line: 117, type: !46, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!370 = !DILocalVariable(name: "data", arg: 1, scope: !369, file: !91, line: 117, type: !13)
!371 = !DILocation(line: 117, column: 23, scope: !369)
!372 = !DILocation(line: 119, column: 5, scope: !373)
!373 = distinct !DILexicalBlock(scope: !374, file: !91, line: 119, column: 5)
!374 = distinct !DILexicalBlock(scope: !369, file: !91, line: 119, column: 5)
!375 = !DILocation(line: 119, column: 5, scope: !374)
!376 = !DILocalVariable(name: "node", scope: !369, file: !91, line: 120, type: !205)
!377 = !DILocation(line: 120, column: 13, scope: !369)
!378 = !DILocation(line: 120, column: 20, scope: !369)
!379 = !DILocation(line: 121, column: 5, scope: !380)
!380 = distinct !DILexicalBlock(scope: !381, file: !91, line: 121, column: 5)
!381 = distinct !DILexicalBlock(scope: !369, file: !91, line: 121, column: 5)
!382 = !DILocation(line: 121, column: 5, scope: !381)
!383 = !DILocation(line: 122, column: 30, scope: !369)
!384 = !DILocation(line: 122, column: 36, scope: !369)
!385 = !DILocation(line: 122, column: 24, scope: !369)
!386 = !DILocation(line: 122, column: 5, scope: !369)
!387 = !DILocation(line: 122, column: 28, scope: !369)
!388 = !DILocation(line: 123, column: 1, scope: !369)
!389 = distinct !DISubprogram(name: "destroy", scope: !91, file: !91, line: 88, type: !259, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !176)
!390 = !DILocation(line: 90, column: 5, scope: !389)
!391 = !DILocation(line: 91, column: 1, scope: !389)
!392 = distinct !DISubprogram(name: "vmem_no_leak", scope: !79, file: !79, line: 133, type: !393, scopeLine: 134, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!393 = !DISubroutineType(types: !394)
!394 = !{!24}
!395 = !DILocalVariable(name: "alloc_count", scope: !392, file: !79, line: 135, type: !84)
!396 = !DILocation(line: 135, column: 15, scope: !392)
!397 = !DILocation(line: 135, column: 29, scope: !392)
!398 = !DILocalVariable(name: "free_count", scope: !392, file: !79, line: 136, type: !84)
!399 = !DILocation(line: 136, column: 15, scope: !392)
!400 = !DILocation(line: 136, column: 29, scope: !392)
!401 = !DILocation(line: 137, column: 13, scope: !392)
!402 = !DILocation(line: 137, column: 28, scope: !392)
!403 = !DILocation(line: 137, column: 25, scope: !392)
!404 = !DILocation(line: 137, column: 5, scope: !392)
!405 = distinct !DISubprogram(name: "queue_init", scope: !44, file: !44, line: 110, type: !406, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!406 = !DISubroutineType(types: !407)
!407 = !{null, !408}
!408 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !150, size: 64)
!409 = !DILocalVariable(name: "q", arg: 1, scope: !405, file: !44, line: 110, type: !408)
!410 = !DILocation(line: 110, column: 21, scope: !405)
!411 = !DILocation(line: 112, column: 5, scope: !405)
!412 = !DILocation(line: 113, column: 20, scope: !405)
!413 = !DILocation(line: 113, column: 5, scope: !405)
!414 = !DILocation(line: 120, column: 1, scope: !405)
!415 = distinct !DISubprogram(name: "queue_register", scope: !44, file: !44, line: 123, type: !416, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!416 = !DISubroutineType(types: !417)
!417 = !{null, !5, !408}
!418 = !DILocalVariable(name: "tid", arg: 1, scope: !415, file: !44, line: 123, type: !5)
!419 = !DILocation(line: 123, column: 24, scope: !415)
!420 = !DILocalVariable(name: "q", arg: 2, scope: !415, file: !44, line: 123, type: !408)
!421 = !DILocation(line: 123, column: 38, scope: !415)
!422 = !DILocation(line: 125, column: 14, scope: !415)
!423 = !DILocation(line: 125, column: 5, scope: !415)
!424 = !DILocation(line: 126, column: 5, scope: !415)
!425 = !DILocation(line: 126, column: 5, scope: !426)
!426 = distinct !DILexicalBlock(scope: !415, file: !44, line: 126, column: 5)
!427 = !DILocation(line: 126, column: 5, scope: !428)
!428 = distinct !DILexicalBlock(scope: !426, file: !44, line: 126, column: 5)
!429 = !DILocation(line: 126, column: 5, scope: !430)
!430 = distinct !DILexicalBlock(scope: !428, file: !44, line: 126, column: 5)
!431 = !DILocation(line: 127, column: 1, scope: !415)
!432 = distinct !DISubprogram(name: "queue_deregister", scope: !44, file: !44, line: 139, type: !416, scopeLine: 140, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!433 = !DILocalVariable(name: "tid", arg: 1, scope: !432, file: !44, line: 139, type: !5)
!434 = !DILocation(line: 139, column: 26, scope: !432)
!435 = !DILocalVariable(name: "q", arg: 2, scope: !432, file: !44, line: 139, type: !408)
!436 = !DILocation(line: 139, column: 40, scope: !432)
!437 = !DILocation(line: 144, column: 16, scope: !432)
!438 = !DILocation(line: 144, column: 5, scope: !432)
!439 = !DILocation(line: 145, column: 5, scope: !432)
!440 = !DILocation(line: 145, column: 5, scope: !441)
!441 = distinct !DILexicalBlock(scope: !432, file: !44, line: 145, column: 5)
!442 = !DILocation(line: 145, column: 5, scope: !443)
!443 = distinct !DILexicalBlock(scope: !441, file: !44, line: 145, column: 5)
!444 = !DILocation(line: 145, column: 5, scope: !445)
!445 = distinct !DILexicalBlock(scope: !443, file: !44, line: 145, column: 5)
!446 = !DILocation(line: 146, column: 1, scope: !432)
!447 = distinct !DISubprogram(name: "queue_destroy", scope: !44, file: !44, line: 149, type: !406, scopeLine: 150, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!448 = !DILocalVariable(name: "q", arg: 1, scope: !447, file: !44, line: 149, type: !408)
!449 = !DILocation(line: 149, column: 24, scope: !447)
!450 = !DILocalVariable(name: "data", scope: !447, file: !44, line: 151, type: !13)
!451 = !DILocation(line: 151, column: 11, scope: !447)
!452 = !DILocation(line: 156, column: 5, scope: !447)
!453 = !DILocation(line: 156, column: 33, scope: !447)
!454 = !DILocation(line: 156, column: 19, scope: !447)
!455 = !DILocation(line: 156, column: 17, scope: !447)
!456 = !DILocation(line: 156, column: 59, scope: !447)
!457 = !DILocation(line: 157, column: 14, scope: !458)
!458 = distinct !DILexicalBlock(scope: !447, file: !44, line: 156, column: 65)
!459 = !DILocation(line: 157, column: 9, scope: !458)
!460 = distinct !{!460, !452, !461, !302}
!461 = !DILocation(line: 158, column: 5, scope: !447)
!462 = !DILocation(line: 159, column: 23, scope: !447)
!463 = !DILocation(line: 159, column: 5, scope: !447)
!464 = !DILocation(line: 165, column: 5, scope: !447)
!465 = !DILocation(line: 166, column: 5, scope: !466)
!466 = distinct !DILexicalBlock(scope: !467, file: !44, line: 166, column: 5)
!467 = distinct !DILexicalBlock(scope: !447, file: !44, line: 166, column: 5)
!468 = !DILocation(line: 166, column: 5, scope: !467)
!469 = !DILocation(line: 167, column: 1, scope: !447)
!470 = distinct !DISubprogram(name: "queue_enq", scope: !44, file: !44, line: 170, type: !471, scopeLine: 171, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!471 = !DISubroutineType(types: !472)
!472 = !{null, !5, !408, !84, !143}
!473 = !DILocalVariable(name: "tid", arg: 1, scope: !470, file: !44, line: 170, type: !5)
!474 = !DILocation(line: 170, column: 19, scope: !470)
!475 = !DILocalVariable(name: "q", arg: 2, scope: !470, file: !44, line: 170, type: !408)
!476 = !DILocation(line: 170, column: 33, scope: !470)
!477 = !DILocalVariable(name: "key", arg: 3, scope: !470, file: !44, line: 170, type: !84)
!478 = !DILocation(line: 170, column: 46, scope: !470)
!479 = !DILocalVariable(name: "lbl", arg: 4, scope: !470, file: !44, line: 170, type: !143)
!480 = !DILocation(line: 170, column: 56, scope: !470)
!481 = !DILocalVariable(name: "data", scope: !470, file: !44, line: 172, type: !205)
!482 = !DILocation(line: 172, column: 13, scope: !470)
!483 = !DILocation(line: 172, column: 20, scope: !470)
!484 = !DILocation(line: 173, column: 9, scope: !485)
!485 = distinct !DILexicalBlock(scope: !470, file: !44, line: 173, column: 9)
!486 = !DILocation(line: 173, column: 9, scope: !470)
!487 = !DILocation(line: 174, column: 31, scope: !488)
!488 = distinct !DILexicalBlock(scope: !485, file: !44, line: 173, column: 15)
!489 = !DILocation(line: 174, column: 9, scope: !488)
!490 = !DILocation(line: 174, column: 15, scope: !488)
!491 = !DILocation(line: 174, column: 29, scope: !488)
!492 = !DILocation(line: 175, column: 31, scope: !488)
!493 = !DILocation(line: 175, column: 9, scope: !488)
!494 = !DILocation(line: 175, column: 15, scope: !488)
!495 = !DILocation(line: 175, column: 29, scope: !488)
!496 = !DILocalVariable(name: "qnode", scope: !488, file: !44, line: 176, type: !497)
!497 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !498, size: 64)
!498 = !DIDerivedType(tag: DW_TAG_typedef, name: "queue_node_t", file: !44, line: 42, baseType: !32)
!499 = !DILocation(line: 176, column: 23, scope: !488)
!500 = !DILocation(line: 190, column: 17, scope: !488)
!501 = !DILocation(line: 190, column: 15, scope: !488)
!502 = !DILocation(line: 192, column: 20, scope: !488)
!503 = !DILocation(line: 192, column: 9, scope: !488)
!504 = !DILocation(line: 193, column: 23, scope: !488)
!505 = !DILocation(line: 193, column: 26, scope: !488)
!506 = !DILocation(line: 193, column: 33, scope: !488)
!507 = !DILocation(line: 193, column: 9, scope: !488)
!508 = !DILocation(line: 194, column: 19, scope: !488)
!509 = !DILocation(line: 194, column: 9, scope: !488)
!510 = !DILocation(line: 195, column: 5, scope: !488)
!511 = !DILocation(line: 196, column: 9, scope: !512)
!512 = distinct !DILexicalBlock(scope: !513, file: !44, line: 196, column: 9)
!513 = distinct !DILexicalBlock(scope: !514, file: !44, line: 196, column: 9)
!514 = distinct !DILexicalBlock(scope: !485, file: !44, line: 195, column: 12)
!515 = !DILocation(line: 198, column: 1, scope: !470)
!516 = distinct !DISubprogram(name: "queue_deq", scope: !44, file: !44, line: 219, type: !517, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!517 = !DISubroutineType(types: !518)
!518 = !{!13, !5, !408}
!519 = !DILocalVariable(name: "tid", arg: 1, scope: !516, file: !44, line: 219, type: !5)
!520 = !DILocation(line: 219, column: 19, scope: !516)
!521 = !DILocalVariable(name: "q", arg: 2, scope: !516, file: !44, line: 219, type: !408)
!522 = !DILocation(line: 219, column: 33, scope: !516)
!523 = !DILocation(line: 221, column: 16, scope: !516)
!524 = !DILocation(line: 221, column: 5, scope: !516)
!525 = !DILocalVariable(name: "data", scope: !516, file: !44, line: 222, type: !13)
!526 = !DILocation(line: 222, column: 11, scope: !516)
!527 = !DILocation(line: 222, column: 32, scope: !516)
!528 = !DILocation(line: 222, column: 58, scope: !516)
!529 = !DILocation(line: 222, column: 50, scope: !516)
!530 = !DILocation(line: 222, column: 18, scope: !516)
!531 = !DILocation(line: 223, column: 15, scope: !516)
!532 = !DILocation(line: 223, column: 5, scope: !516)
!533 = !DILocation(line: 224, column: 12, scope: !516)
!534 = !DILocation(line: 224, column: 5, scope: !516)
!535 = distinct !DISubprogram(name: "queue_empty", scope: !44, file: !44, line: 210, type: !536, scopeLine: 211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!536 = !DISubroutineType(types: !537)
!537 = !{!24, !5, !408}
!538 = !DILocalVariable(name: "tid", arg: 1, scope: !535, file: !44, line: 210, type: !5)
!539 = !DILocation(line: 210, column: 21, scope: !535)
!540 = !DILocalVariable(name: "q", arg: 2, scope: !535, file: !44, line: 210, type: !408)
!541 = !DILocation(line: 210, column: 35, scope: !535)
!542 = !DILocation(line: 212, column: 16, scope: !535)
!543 = !DILocation(line: 212, column: 5, scope: !535)
!544 = !DILocalVariable(name: "empty", scope: !535, file: !44, line: 213, type: !24)
!545 = !DILocation(line: 213, column: 13, scope: !535)
!546 = !DILocation(line: 213, column: 37, scope: !535)
!547 = !DILocation(line: 213, column: 21, scope: !535)
!548 = !DILocation(line: 214, column: 15, scope: !535)
!549 = !DILocation(line: 214, column: 5, scope: !535)
!550 = !DILocation(line: 215, column: 12, scope: !535)
!551 = !DILocation(line: 215, column: 5, scope: !535)
!552 = distinct !DISubprogram(name: "ismr_recycle", scope: !50, file: !50, line: 114, type: !174, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!553 = !DILocalVariable(name: "tid", arg: 1, scope: !552, file: !50, line: 114, type: !5)
!554 = !DILocation(line: 114, column: 22, scope: !552)
!555 = !DILocation(line: 116, column: 5, scope: !552)
!556 = !DILocation(line: 116, column: 5, scope: !557)
!557 = distinct !DILexicalBlock(scope: !552, file: !50, line: 116, column: 5)
!558 = !DILocation(line: 116, column: 5, scope: !559)
!559 = distinct !DILexicalBlock(scope: !557, file: !50, line: 116, column: 5)
!560 = !DILocation(line: 116, column: 5, scope: !561)
!561 = distinct !DILexicalBlock(scope: !559, file: !50, line: 116, column: 5)
!562 = !DILocation(line: 117, column: 1, scope: !552)
!563 = distinct !DISubprogram(name: "create_threads", scope: !16, file: !16, line: 83, type: !564, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!564 = !DISubroutineType(types: !565)
!565 = !{null, !14, !5, !27, !24}
!566 = !DILocalVariable(name: "threads", arg: 1, scope: !563, file: !16, line: 83, type: !14)
!567 = !DILocation(line: 83, column: 28, scope: !563)
!568 = !DILocalVariable(name: "num_threads", arg: 2, scope: !563, file: !16, line: 83, type: !5)
!569 = !DILocation(line: 83, column: 45, scope: !563)
!570 = !DILocalVariable(name: "fun", arg: 3, scope: !563, file: !16, line: 83, type: !27)
!571 = !DILocation(line: 83, column: 71, scope: !563)
!572 = !DILocalVariable(name: "bind", arg: 4, scope: !563, file: !16, line: 84, type: !24)
!573 = !DILocation(line: 84, column: 24, scope: !563)
!574 = !DILocalVariable(name: "i", scope: !563, file: !16, line: 86, type: !5)
!575 = !DILocation(line: 86, column: 13, scope: !563)
!576 = !DILocation(line: 87, column: 12, scope: !577)
!577 = distinct !DILexicalBlock(scope: !563, file: !16, line: 87, column: 5)
!578 = !DILocation(line: 87, column: 10, scope: !577)
!579 = !DILocation(line: 87, column: 17, scope: !580)
!580 = distinct !DILexicalBlock(scope: !577, file: !16, line: 87, column: 5)
!581 = !DILocation(line: 87, column: 21, scope: !580)
!582 = !DILocation(line: 87, column: 19, scope: !580)
!583 = !DILocation(line: 87, column: 5, scope: !577)
!584 = !DILocation(line: 88, column: 40, scope: !585)
!585 = distinct !DILexicalBlock(scope: !580, file: !16, line: 87, column: 39)
!586 = !DILocation(line: 88, column: 9, scope: !585)
!587 = !DILocation(line: 88, column: 17, scope: !585)
!588 = !DILocation(line: 88, column: 20, scope: !585)
!589 = !DILocation(line: 88, column: 38, scope: !585)
!590 = !DILocation(line: 89, column: 40, scope: !585)
!591 = !DILocation(line: 89, column: 9, scope: !585)
!592 = !DILocation(line: 89, column: 17, scope: !585)
!593 = !DILocation(line: 89, column: 20, scope: !585)
!594 = !DILocation(line: 89, column: 38, scope: !585)
!595 = !DILocation(line: 90, column: 40, scope: !585)
!596 = !DILocation(line: 90, column: 9, scope: !585)
!597 = !DILocation(line: 90, column: 17, scope: !585)
!598 = !DILocation(line: 90, column: 20, scope: !585)
!599 = !DILocation(line: 90, column: 38, scope: !585)
!600 = !DILocation(line: 91, column: 25, scope: !585)
!601 = !DILocation(line: 91, column: 33, scope: !585)
!602 = !DILocation(line: 91, column: 36, scope: !585)
!603 = !DILocation(line: 91, column: 55, scope: !585)
!604 = !DILocation(line: 91, column: 63, scope: !585)
!605 = !DILocation(line: 91, column: 54, scope: !585)
!606 = !DILocation(line: 91, column: 9, scope: !585)
!607 = !DILocation(line: 92, column: 5, scope: !585)
!608 = !DILocation(line: 87, column: 35, scope: !580)
!609 = !DILocation(line: 87, column: 5, scope: !580)
!610 = distinct !{!610, !583, !611, !302}
!611 = !DILocation(line: 92, column: 5, scope: !577)
!612 = !DILocation(line: 94, column: 1, scope: !563)
!613 = distinct !DISubprogram(name: "await_threads", scope: !16, file: !16, line: 97, type: !614, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!614 = !DISubroutineType(types: !615)
!615 = !{null, !14, !5}
!616 = !DILocalVariable(name: "threads", arg: 1, scope: !613, file: !16, line: 97, type: !14)
!617 = !DILocation(line: 97, column: 27, scope: !613)
!618 = !DILocalVariable(name: "num_threads", arg: 2, scope: !613, file: !16, line: 97, type: !5)
!619 = !DILocation(line: 97, column: 44, scope: !613)
!620 = !DILocalVariable(name: "i", scope: !613, file: !16, line: 99, type: !5)
!621 = !DILocation(line: 99, column: 13, scope: !613)
!622 = !DILocation(line: 100, column: 12, scope: !623)
!623 = distinct !DILexicalBlock(scope: !613, file: !16, line: 100, column: 5)
!624 = !DILocation(line: 100, column: 10, scope: !623)
!625 = !DILocation(line: 100, column: 17, scope: !626)
!626 = distinct !DILexicalBlock(scope: !623, file: !16, line: 100, column: 5)
!627 = !DILocation(line: 100, column: 21, scope: !626)
!628 = !DILocation(line: 100, column: 19, scope: !626)
!629 = !DILocation(line: 100, column: 5, scope: !623)
!630 = !DILocation(line: 101, column: 22, scope: !631)
!631 = distinct !DILexicalBlock(scope: !626, file: !16, line: 100, column: 39)
!632 = !DILocation(line: 101, column: 30, scope: !631)
!633 = !DILocation(line: 101, column: 33, scope: !631)
!634 = !DILocation(line: 101, column: 9, scope: !631)
!635 = !DILocation(line: 102, column: 5, scope: !631)
!636 = !DILocation(line: 100, column: 35, scope: !626)
!637 = !DILocation(line: 100, column: 5, scope: !626)
!638 = distinct !{!638, !629, !639, !302}
!639 = !DILocation(line: 102, column: 5, scope: !623)
!640 = !DILocation(line: 103, column: 1, scope: !613)
!641 = distinct !DISubprogram(name: "common_run", scope: !16, file: !16, line: 43, type: !29, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!642 = !DILocalVariable(name: "args", arg: 1, scope: !641, file: !16, line: 43, type: !13)
!643 = !DILocation(line: 43, column: 18, scope: !641)
!644 = !DILocalVariable(name: "run_info", scope: !641, file: !16, line: 45, type: !14)
!645 = !DILocation(line: 45, column: 17, scope: !641)
!646 = !DILocation(line: 45, column: 42, scope: !641)
!647 = !DILocation(line: 45, column: 28, scope: !641)
!648 = !DILocation(line: 47, column: 9, scope: !649)
!649 = distinct !DILexicalBlock(scope: !641, file: !16, line: 47, column: 9)
!650 = !DILocation(line: 47, column: 19, scope: !649)
!651 = !DILocation(line: 47, column: 9, scope: !641)
!652 = !DILocation(line: 48, column: 26, scope: !649)
!653 = !DILocation(line: 48, column: 36, scope: !649)
!654 = !DILocation(line: 48, column: 9, scope: !649)
!655 = !DILocation(line: 52, column: 12, scope: !641)
!656 = !DILocation(line: 52, column: 22, scope: !641)
!657 = !DILocation(line: 52, column: 38, scope: !641)
!658 = !DILocation(line: 52, column: 48, scope: !641)
!659 = !DILocation(line: 52, column: 30, scope: !641)
!660 = !DILocation(line: 52, column: 5, scope: !641)
!661 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !16, file: !16, line: 61, type: !174, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!662 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !661, file: !16, line: 61, type: !5)
!663 = !DILocation(line: 61, column: 26, scope: !661)
!664 = !DILocation(line: 78, column: 5, scope: !661)
!665 = !DILocation(line: 78, column: 5, scope: !666)
!666 = distinct !DILexicalBlock(scope: !661, file: !16, line: 78, column: 5)
!667 = !DILocation(line: 78, column: 5, scope: !668)
!668 = distinct !DILexicalBlock(scope: !666, file: !16, line: 78, column: 5)
!669 = !DILocation(line: 78, column: 5, scope: !670)
!670 = distinct !DILexicalBlock(scope: !668, file: !16, line: 78, column: 5)
!671 = !DILocation(line: 80, column: 1, scope: !661)
!672 = distinct !DISubprogram(name: "_vqueue_ub_visit_nodes", scope: !33, file: !33, line: 233, type: !673, scopeLine: 235, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!673 = !DISubroutineType(types: !674)
!674 = !{null, !359, !675, !13}
!675 = !DIDerivedType(tag: DW_TAG_typedef, name: "vqueue_ub_node_handler_t", file: !676, line: 9, baseType: !677)
!676 = !DIFile(filename: "datastruct/queue/unbounded/include/vsync/queue/internal/ub/vqueue_ub_common.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "bc5763170bb9d2e4aa9aa1f04b243580")
!677 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !678, size: 64)
!678 = !DISubroutineType(types: !679)
!679 = !{null, !680, !13}
!680 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!681 = !DILocalVariable(name: "q", arg: 1, scope: !672, file: !33, line: 233, type: !359)
!682 = !DILocation(line: 233, column: 37, scope: !672)
!683 = !DILocalVariable(name: "visitor", arg: 2, scope: !672, file: !33, line: 233, type: !675)
!684 = !DILocation(line: 233, column: 65, scope: !672)
!685 = !DILocalVariable(name: "arg", arg: 3, scope: !672, file: !33, line: 234, type: !13)
!686 = !DILocation(line: 234, column: 30, scope: !672)
!687 = !DILocalVariable(name: "curr", scope: !672, file: !33, line: 236, type: !31)
!688 = !DILocation(line: 236, column: 23, scope: !672)
!689 = !DILocalVariable(name: "next", scope: !672, file: !33, line: 237, type: !31)
!690 = !DILocation(line: 237, column: 23, scope: !672)
!691 = !DILocation(line: 239, column: 12, scope: !672)
!692 = !DILocation(line: 239, column: 15, scope: !672)
!693 = !DILocation(line: 239, column: 10, scope: !672)
!694 = !DILocation(line: 241, column: 53, scope: !672)
!695 = !DILocation(line: 241, column: 59, scope: !672)
!696 = !DILocation(line: 241, column: 32, scope: !672)
!697 = !DILocation(line: 241, column: 12, scope: !672)
!698 = !DILocation(line: 241, column: 10, scope: !672)
!699 = !DILocation(line: 243, column: 5, scope: !672)
!700 = !DILocation(line: 243, column: 12, scope: !672)
!701 = !DILocation(line: 244, column: 57, scope: !702)
!702 = distinct !DILexicalBlock(scope: !672, file: !33, line: 243, column: 18)
!703 = !DILocation(line: 244, column: 63, scope: !702)
!704 = !DILocation(line: 244, column: 36, scope: !702)
!705 = !DILocation(line: 244, column: 16, scope: !702)
!706 = !DILocation(line: 244, column: 14, scope: !702)
!707 = !DILocation(line: 245, column: 9, scope: !702)
!708 = !DILocation(line: 245, column: 17, scope: !702)
!709 = !DILocation(line: 245, column: 23, scope: !702)
!710 = !DILocation(line: 246, column: 16, scope: !702)
!711 = !DILocation(line: 246, column: 14, scope: !702)
!712 = distinct !{!712, !699, !713, !302}
!713 = !DILocation(line: 247, column: 5, scope: !672)
!714 = !DILocation(line: 248, column: 1, scope: !672)
!715 = distinct !DISubprogram(name: "_redirect_print", scope: !44, file: !44, line: 229, type: !716, scopeLine: 230, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!716 = !DISubroutineType(types: !717)
!717 = !{null, !31, !13}
!718 = !DILocalVariable(name: "qnode", arg: 1, scope: !715, file: !44, line: 229, type: !31)
!719 = !DILocation(line: 229, column: 35, scope: !715)
!720 = !DILocalVariable(name: "arg", arg: 2, scope: !715, file: !44, line: 229, type: !13)
!721 = !DILocation(line: 229, column: 48, scope: !715)
!722 = !DILocalVariable(name: "print", scope: !715, file: !44, line: 231, type: !43)
!723 = !DILocation(line: 231, column: 17, scope: !715)
!724 = !DILocation(line: 231, column: 38, scope: !715)
!725 = !DILocation(line: 231, column: 25, scope: !715)
!726 = !DILocation(line: 232, column: 5, scope: !715)
!727 = !DILocation(line: 232, column: 11, scope: !715)
!728 = !DILocation(line: 232, column: 18, scope: !715)
!729 = !DILocation(line: 233, column: 1, scope: !715)
!730 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !731, file: !731, line: 197, type: !732, scopeLine: 198, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!731 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!732 = !DISubroutineType(types: !733)
!733 = !{!13, !734}
!734 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !735, size: 64)
!735 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !38)
!736 = !DILocalVariable(name: "a", arg: 1, scope: !730, file: !731, line: 197, type: !734)
!737 = !DILocation(line: 197, column: 41, scope: !730)
!738 = !DILocalVariable(name: "val", scope: !730, file: !731, line: 199, type: !13)
!739 = !DILocation(line: 199, column: 11, scope: !730)
!740 = !DILocation(line: 202, column: 32, scope: !730)
!741 = !DILocation(line: 202, column: 35, scope: !730)
!742 = !DILocation(line: 200, column: 5, scope: !730)
!743 = !{i64 852631}
!744 = !DILocation(line: 204, column: 12, scope: !730)
!745 = !DILocation(line: 204, column: 5, scope: !730)
!746 = distinct !DISubprogram(name: "vmem_get_alloc_count", scope: !79, file: !79, line: 90, type: !747, scopeLine: 91, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!747 = !DISubroutineType(types: !748)
!748 = !{!84}
!749 = !DILocalVariable(name: "alloc_count", scope: !746, file: !79, line: 93, type: !84)
!750 = !DILocation(line: 93, column: 15, scope: !746)
!751 = !DILocation(line: 93, column: 29, scope: !746)
!752 = !DILocation(line: 94, column: 5, scope: !746)
!753 = !DILocation(line: 94, column: 5, scope: !754)
!754 = distinct !DILexicalBlock(scope: !746, file: !79, line: 94, column: 5)
!755 = !DILocation(line: 94, column: 5, scope: !756)
!756 = distinct !DILexicalBlock(scope: !754, file: !79, line: 94, column: 5)
!757 = !DILocation(line: 94, column: 5, scope: !758)
!758 = distinct !DILexicalBlock(scope: !756, file: !79, line: 94, column: 5)
!759 = !DILocation(line: 95, column: 12, scope: !746)
!760 = !DILocation(line: 95, column: 5, scope: !746)
!761 = distinct !DISubprogram(name: "vmem_get_free_count", scope: !79, file: !79, line: 104, type: !747, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!762 = !DILocalVariable(name: "free_count", scope: !761, file: !79, line: 107, type: !84)
!763 = !DILocation(line: 107, column: 15, scope: !761)
!764 = !DILocation(line: 107, column: 28, scope: !761)
!765 = !DILocation(line: 108, column: 5, scope: !761)
!766 = !DILocation(line: 108, column: 5, scope: !767)
!767 = distinct !DILexicalBlock(scope: !761, file: !79, line: 108, column: 5)
!768 = !DILocation(line: 108, column: 5, scope: !769)
!769 = distinct !DILexicalBlock(scope: !767, file: !79, line: 108, column: 5)
!770 = !DILocation(line: 108, column: 5, scope: !771)
!771 = distinct !DILexicalBlock(scope: !769, file: !79, line: 108, column: 5)
!772 = !DILocation(line: 109, column: 12, scope: !761)
!773 = !DILocation(line: 109, column: 5, scope: !761)
!774 = distinct !DISubprogram(name: "vatomic64_read_rlx", scope: !731, file: !731, line: 149, type: !775, scopeLine: 150, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!775 = !DISubroutineType(types: !776)
!776 = !{!84, !777}
!777 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !778, size: 64)
!778 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !80)
!779 = !DILocalVariable(name: "a", arg: 1, scope: !774, file: !731, line: 149, type: !777)
!780 = !DILocation(line: 149, column: 39, scope: !774)
!781 = !DILocalVariable(name: "val", scope: !774, file: !731, line: 151, type: !84)
!782 = !DILocation(line: 151, column: 15, scope: !774)
!783 = !DILocation(line: 154, column: 32, scope: !774)
!784 = !DILocation(line: 154, column: 35, scope: !774)
!785 = !DILocation(line: 152, column: 5, scope: !774)
!786 = !{i64 851148}
!787 = !DILocation(line: 156, column: 12, scope: !774)
!788 = !DILocation(line: 156, column: 5, scope: !774)
!789 = distinct !DISubprogram(name: "ismr_init", scope: !50, file: !50, line: 35, type: !259, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!790 = !DILocation(line: 37, column: 5, scope: !789)
!791 = !DILocation(line: 38, column: 1, scope: !789)
!792 = distinct !DISubprogram(name: "vqueue_ub_init", scope: !33, file: !33, line: 76, type: !793, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!793 = !DISubroutineType(types: !794)
!794 = !{null, !359}
!795 = !DILocalVariable(name: "q", arg: 1, scope: !792, file: !33, line: 76, type: !359)
!796 = !DILocation(line: 76, column: 29, scope: !792)
!797 = !DILocation(line: 78, column: 16, scope: !792)
!798 = !DILocation(line: 78, column: 19, scope: !792)
!799 = !DILocation(line: 78, column: 5, scope: !792)
!800 = !DILocation(line: 78, column: 8, scope: !792)
!801 = !DILocation(line: 78, column: 13, scope: !792)
!802 = !DILocation(line: 79, column: 16, scope: !792)
!803 = !DILocation(line: 79, column: 19, scope: !792)
!804 = !DILocation(line: 79, column: 5, scope: !792)
!805 = !DILocation(line: 79, column: 8, scope: !792)
!806 = !DILocation(line: 79, column: 13, scope: !792)
!807 = !DILocation(line: 81, column: 27, scope: !792)
!808 = !DILocation(line: 81, column: 30, scope: !792)
!809 = !DILocation(line: 81, column: 5, scope: !792)
!810 = !DILocation(line: 83, column: 22, scope: !792)
!811 = !DILocation(line: 83, column: 25, scope: !792)
!812 = !DILocation(line: 83, column: 5, scope: !792)
!813 = !DILocation(line: 84, column: 22, scope: !792)
!814 = !DILocation(line: 84, column: 25, scope: !792)
!815 = !DILocation(line: 84, column: 5, scope: !792)
!816 = !DILocation(line: 85, column: 1, scope: !792)
!817 = distinct !DISubprogram(name: "locked_trace_init", scope: !98, file: !98, line: 14, type: !818, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!818 = !DISubroutineType(types: !819)
!819 = !{null, !820, !5}
!820 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!821 = !DILocalVariable(name: "trace", arg: 1, scope: !817, file: !98, line: 14, type: !820)
!822 = !DILocation(line: 14, column: 35, scope: !817)
!823 = !DILocalVariable(name: "capacity", arg: 2, scope: !817, file: !98, line: 14, type: !5)
!824 = !DILocation(line: 14, column: 50, scope: !817)
!825 = !DILocation(line: 16, column: 5, scope: !826)
!826 = distinct !DILexicalBlock(scope: !827, file: !98, line: 16, column: 5)
!827 = distinct !DILexicalBlock(scope: !817, file: !98, line: 16, column: 5)
!828 = !DILocation(line: 16, column: 5, scope: !827)
!829 = !DILocation(line: 17, column: 25, scope: !817)
!830 = !DILocation(line: 17, column: 32, scope: !817)
!831 = !DILocation(line: 17, column: 5, scope: !817)
!832 = !DILocation(line: 18, column: 17, scope: !817)
!833 = !DILocation(line: 18, column: 24, scope: !817)
!834 = !DILocation(line: 18, column: 31, scope: !817)
!835 = !DILocation(line: 18, column: 5, scope: !817)
!836 = !DILocation(line: 19, column: 1, scope: !817)
!837 = distinct !DISubprogram(name: "trace_init", scope: !103, file: !103, line: 28, type: !838, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!838 = !DISubroutineType(types: !839)
!839 = !{null, !840, !5}
!840 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !102, size: 64)
!841 = !DILocalVariable(name: "trace", arg: 1, scope: !837, file: !103, line: 28, type: !840)
!842 = !DILocation(line: 28, column: 21, scope: !837)
!843 = !DILocalVariable(name: "capacity", arg: 2, scope: !837, file: !103, line: 28, type: !5)
!844 = !DILocation(line: 28, column: 36, scope: !837)
!845 = !DILocation(line: 30, column: 5, scope: !846)
!846 = distinct !DILexicalBlock(scope: !847, file: !103, line: 30, column: 5)
!847 = distinct !DILexicalBlock(scope: !837, file: !103, line: 30, column: 5)
!848 = !DILocation(line: 30, column: 5, scope: !847)
!849 = !DILocation(line: 31, column: 27, scope: !837)
!850 = !DILocation(line: 31, column: 36, scope: !837)
!851 = !DILocation(line: 31, column: 20, scope: !837)
!852 = !DILocation(line: 31, column: 5, scope: !837)
!853 = !DILocation(line: 31, column: 12, scope: !837)
!854 = !DILocation(line: 31, column: 18, scope: !837)
!855 = !DILocation(line: 32, column: 9, scope: !856)
!856 = distinct !DILexicalBlock(scope: !837, file: !103, line: 32, column: 9)
!857 = !DILocation(line: 32, column: 16, scope: !856)
!858 = !DILocation(line: 32, column: 9, scope: !837)
!859 = !DILocation(line: 33, column: 9, scope: !860)
!860 = distinct !DILexicalBlock(scope: !856, file: !103, line: 32, column: 23)
!861 = !DILocation(line: 33, column: 16, scope: !860)
!862 = !DILocation(line: 33, column: 28, scope: !860)
!863 = !DILocation(line: 34, column: 30, scope: !860)
!864 = !DILocation(line: 34, column: 9, scope: !860)
!865 = !DILocation(line: 34, column: 16, scope: !860)
!866 = !DILocation(line: 34, column: 28, scope: !860)
!867 = !DILocation(line: 35, column: 9, scope: !860)
!868 = !DILocation(line: 35, column: 16, scope: !860)
!869 = !DILocation(line: 35, column: 28, scope: !860)
!870 = !DILocation(line: 36, column: 5, scope: !860)
!871 = !DILocation(line: 37, column: 9, scope: !872)
!872 = distinct !DILexicalBlock(scope: !856, file: !103, line: 36, column: 12)
!873 = !DILocation(line: 37, column: 16, scope: !872)
!874 = !DILocation(line: 37, column: 28, scope: !872)
!875 = !DILocation(line: 38, column: 9, scope: !872)
!876 = !DILocation(line: 38, column: 16, scope: !872)
!877 = !DILocation(line: 38, column: 28, scope: !872)
!878 = !DILocation(line: 39, column: 9, scope: !872)
!879 = !DILocation(line: 39, column: 16, scope: !872)
!880 = !DILocation(line: 39, column: 28, scope: !872)
!881 = !DILocation(line: 40, column: 9, scope: !882)
!882 = distinct !DILexicalBlock(scope: !883, file: !103, line: 40, column: 9)
!883 = distinct !DILexicalBlock(scope: !872, file: !103, line: 40, column: 9)
!884 = !DILocation(line: 42, column: 1, scope: !837)
!885 = distinct !DISubprogram(name: "_vqueue_ub_node_init", scope: !33, file: !33, line: 219, type: !716, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!886 = !DILocalVariable(name: "qnode", arg: 1, scope: !885, file: !33, line: 219, type: !31)
!887 = !DILocation(line: 219, column: 40, scope: !885)
!888 = !DILocalVariable(name: "data", arg: 2, scope: !885, file: !33, line: 219, type: !13)
!889 = !DILocation(line: 219, column: 53, scope: !885)
!890 = !DILocation(line: 221, column: 19, scope: !885)
!891 = !DILocation(line: 221, column: 5, scope: !885)
!892 = !DILocation(line: 221, column: 12, scope: !885)
!893 = !DILocation(line: 221, column: 17, scope: !885)
!894 = !DILocation(line: 222, column: 27, scope: !885)
!895 = !DILocation(line: 222, column: 34, scope: !885)
!896 = !DILocation(line: 222, column: 5, scope: !885)
!897 = !DILocation(line: 223, column: 1, scope: !885)
!898 = distinct !DISubprogram(name: "queue_lock_init", scope: !33, file: !33, line: 31, type: !899, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!899 = !DISubroutineType(types: !900)
!900 = !{null, !901}
!901 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !155, size: 64)
!902 = !DILocalVariable(name: "l", arg: 1, scope: !898, file: !33, line: 31, type: !901)
!903 = !DILocation(line: 31, column: 1, scope: !898)
!904 = distinct !DISubprogram(name: "vatomicptr_write_rlx", scope: !731, file: !731, line: 325, type: !905, scopeLine: 326, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!905 = !DISubroutineType(types: !906)
!906 = !{null, !907, !13}
!907 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!908 = !DILocalVariable(name: "a", arg: 1, scope: !904, file: !731, line: 325, type: !907)
!909 = !DILocation(line: 325, column: 36, scope: !904)
!910 = !DILocalVariable(name: "v", arg: 2, scope: !904, file: !731, line: 325, type: !13)
!911 = !DILocation(line: 325, column: 45, scope: !904)
!912 = !DILocation(line: 329, column: 32, scope: !904)
!913 = !DILocation(line: 329, column: 44, scope: !904)
!914 = !DILocation(line: 329, column: 47, scope: !904)
!915 = !DILocation(line: 327, column: 5, scope: !904)
!916 = !{i64 856832}
!917 = !DILocation(line: 331, column: 1, scope: !904)
!918 = distinct !DISubprogram(name: "ismr_reg", scope: !50, file: !50, line: 89, type: !174, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!919 = !DILocalVariable(name: "tid", arg: 1, scope: !918, file: !50, line: 89, type: !5)
!920 = !DILocation(line: 89, column: 18, scope: !918)
!921 = !DILocation(line: 91, column: 5, scope: !918)
!922 = !DILocation(line: 91, column: 5, scope: !923)
!923 = distinct !DILexicalBlock(scope: !918, file: !50, line: 91, column: 5)
!924 = !DILocation(line: 91, column: 5, scope: !925)
!925 = distinct !DILexicalBlock(scope: !923, file: !50, line: 91, column: 5)
!926 = !DILocation(line: 91, column: 5, scope: !927)
!927 = distinct !DILexicalBlock(scope: !925, file: !50, line: 91, column: 5)
!928 = !DILocation(line: 92, column: 1, scope: !918)
!929 = distinct !DISubprogram(name: "ismr_dereg", scope: !50, file: !50, line: 95, type: !174, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!930 = !DILocalVariable(name: "tid", arg: 1, scope: !929, file: !50, line: 95, type: !5)
!931 = !DILocation(line: 95, column: 20, scope: !929)
!932 = !DILocation(line: 97, column: 5, scope: !929)
!933 = !DILocation(line: 97, column: 5, scope: !934)
!934 = distinct !DILexicalBlock(scope: !929, file: !50, line: 97, column: 5)
!935 = !DILocation(line: 97, column: 5, scope: !936)
!936 = distinct !DILexicalBlock(scope: !934, file: !50, line: 97, column: 5)
!937 = !DILocation(line: 97, column: 5, scope: !938)
!938 = distinct !DILexicalBlock(scope: !936, file: !50, line: 97, column: 5)
!939 = !DILocation(line: 98, column: 1, scope: !929)
!940 = distinct !DISubprogram(name: "vqueue_ub_deq", scope: !33, file: !33, line: 166, type: !941, scopeLine: 167, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!941 = !DISubroutineType(types: !942)
!942 = !{!13, !359, !675, !13}
!943 = !DILocalVariable(name: "q", arg: 1, scope: !940, file: !33, line: 166, type: !359)
!944 = !DILocation(line: 166, column: 28, scope: !940)
!945 = !DILocalVariable(name: "retire", arg: 2, scope: !940, file: !33, line: 166, type: !675)
!946 = !DILocation(line: 166, column: 56, scope: !940)
!947 = !DILocalVariable(name: "retire_arg", arg: 3, scope: !940, file: !33, line: 166, type: !13)
!948 = !DILocation(line: 166, column: 70, scope: !940)
!949 = !DILocalVariable(name: "qnode", scope: !940, file: !33, line: 168, type: !31)
!950 = !DILocation(line: 168, column: 23, scope: !940)
!951 = !DILocalVariable(name: "head", scope: !940, file: !33, line: 169, type: !31)
!952 = !DILocation(line: 169, column: 23, scope: !940)
!953 = !DILocalVariable(name: "data", scope: !940, file: !33, line: 170, type: !13)
!954 = !DILocation(line: 170, column: 11, scope: !940)
!955 = !DILocation(line: 172, column: 25, scope: !940)
!956 = !DILocation(line: 172, column: 28, scope: !940)
!957 = !DILocation(line: 172, column: 5, scope: !940)
!958 = !DILocation(line: 174, column: 12, scope: !940)
!959 = !DILocation(line: 174, column: 15, scope: !940)
!960 = !DILocation(line: 174, column: 10, scope: !940)
!961 = !DILocation(line: 176, column: 54, scope: !940)
!962 = !DILocation(line: 176, column: 60, scope: !940)
!963 = !DILocation(line: 176, column: 33, scope: !940)
!964 = !DILocation(line: 176, column: 13, scope: !940)
!965 = !DILocation(line: 176, column: 11, scope: !940)
!966 = !DILocation(line: 177, column: 9, scope: !967)
!967 = distinct !DILexicalBlock(scope: !940, file: !33, line: 177, column: 9)
!968 = !DILocation(line: 177, column: 9, scope: !940)
!969 = !DILocation(line: 178, column: 19, scope: !970)
!970 = distinct !DILexicalBlock(scope: !967, file: !33, line: 177, column: 16)
!971 = !DILocation(line: 178, column: 26, scope: !970)
!972 = !DILocation(line: 178, column: 17, scope: !970)
!973 = !DILocation(line: 179, column: 19, scope: !970)
!974 = !DILocation(line: 179, column: 9, scope: !970)
!975 = !DILocation(line: 179, column: 12, scope: !970)
!976 = !DILocation(line: 179, column: 17, scope: !970)
!977 = !DILocation(line: 180, column: 13, scope: !978)
!978 = distinct !DILexicalBlock(scope: !970, file: !33, line: 180, column: 13)
!979 = !DILocation(line: 180, column: 22, scope: !978)
!980 = !DILocation(line: 180, column: 25, scope: !978)
!981 = !DILocation(line: 180, column: 18, scope: !978)
!982 = !DILocation(line: 180, column: 13, scope: !970)
!983 = !DILocation(line: 181, column: 13, scope: !984)
!984 = distinct !DILexicalBlock(scope: !978, file: !33, line: 180, column: 35)
!985 = !DILocation(line: 181, column: 20, scope: !984)
!986 = !DILocation(line: 181, column: 26, scope: !984)
!987 = !DILocation(line: 182, column: 9, scope: !984)
!988 = !DILocation(line: 183, column: 5, scope: !970)
!989 = !DILocation(line: 184, column: 25, scope: !940)
!990 = !DILocation(line: 184, column: 28, scope: !940)
!991 = !DILocation(line: 184, column: 5, scope: !940)
!992 = !DILocation(line: 185, column: 12, scope: !940)
!993 = !DILocation(line: 185, column: 5, scope: !940)
!994 = distinct !DISubprogram(name: "_queue_destroy", scope: !44, file: !44, line: 67, type: !995, scopeLine: 68, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!995 = !DISubroutineType(types: !996)
!996 = !{null, !497, !13}
!997 = !DILocalVariable(name: "node", arg: 1, scope: !994, file: !44, line: 67, type: !497)
!998 = !DILocation(line: 67, column: 30, scope: !994)
!999 = !DILocalVariable(name: "arg", arg: 2, scope: !994, file: !44, line: 67, type: !13)
!1000 = !DILocation(line: 67, column: 42, scope: !994)
!1001 = !DILocation(line: 72, column: 15, scope: !994)
!1002 = !DILocation(line: 72, column: 5, scope: !994)
!1003 = !DILocation(line: 74, column: 5, scope: !994)
!1004 = !DILocation(line: 74, column: 5, scope: !1005)
!1005 = distinct !DILexicalBlock(scope: !994, file: !44, line: 74, column: 5)
!1006 = !DILocation(line: 74, column: 5, scope: !1007)
!1007 = distinct !DILexicalBlock(scope: !1005, file: !44, line: 74, column: 5)
!1008 = !DILocation(line: 74, column: 5, scope: !1009)
!1009 = distinct !DILexicalBlock(scope: !1007, file: !44, line: 74, column: 5)
!1010 = !DILocation(line: 75, column: 1, scope: !994)
!1011 = distinct !DISubprogram(name: "vqueue_ub_destroy", scope: !33, file: !33, line: 98, type: !673, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1012 = !DILocalVariable(name: "q", arg: 1, scope: !1011, file: !33, line: 98, type: !359)
!1013 = !DILocation(line: 98, column: 32, scope: !1011)
!1014 = !DILocalVariable(name: "retire", arg: 2, scope: !1011, file: !33, line: 98, type: !675)
!1015 = !DILocation(line: 98, column: 60, scope: !1011)
!1016 = !DILocalVariable(name: "retire_arg", arg: 3, scope: !1011, file: !33, line: 99, type: !13)
!1017 = !DILocation(line: 99, column: 25, scope: !1011)
!1018 = !DILocalVariable(name: "curr", scope: !1011, file: !33, line: 101, type: !31)
!1019 = !DILocation(line: 101, column: 23, scope: !1011)
!1020 = !DILocalVariable(name: "next", scope: !1011, file: !33, line: 102, type: !31)
!1021 = !DILocation(line: 102, column: 23, scope: !1011)
!1022 = !DILocation(line: 104, column: 12, scope: !1011)
!1023 = !DILocation(line: 104, column: 15, scope: !1011)
!1024 = !DILocation(line: 104, column: 10, scope: !1011)
!1025 = !DILocation(line: 106, column: 5, scope: !1011)
!1026 = !DILocation(line: 106, column: 12, scope: !1011)
!1027 = !DILocation(line: 107, column: 57, scope: !1028)
!1028 = distinct !DILexicalBlock(scope: !1011, file: !33, line: 106, column: 18)
!1029 = !DILocation(line: 107, column: 63, scope: !1028)
!1030 = !DILocation(line: 107, column: 36, scope: !1028)
!1031 = !DILocation(line: 107, column: 16, scope: !1028)
!1032 = !DILocation(line: 107, column: 14, scope: !1028)
!1033 = !DILocation(line: 108, column: 13, scope: !1034)
!1034 = distinct !DILexicalBlock(scope: !1028, file: !33, line: 108, column: 13)
!1035 = !DILocation(line: 108, column: 22, scope: !1034)
!1036 = !DILocation(line: 108, column: 25, scope: !1034)
!1037 = !DILocation(line: 108, column: 18, scope: !1034)
!1038 = !DILocation(line: 108, column: 13, scope: !1028)
!1039 = !DILocation(line: 109, column: 13, scope: !1040)
!1040 = distinct !DILexicalBlock(scope: !1034, file: !33, line: 108, column: 35)
!1041 = !DILocation(line: 109, column: 20, scope: !1040)
!1042 = !DILocation(line: 109, column: 26, scope: !1040)
!1043 = !DILocation(line: 110, column: 9, scope: !1040)
!1044 = !DILocation(line: 111, column: 16, scope: !1028)
!1045 = !DILocation(line: 111, column: 14, scope: !1028)
!1046 = distinct !{!1046, !1025, !1047, !302}
!1047 = !DILocation(line: 112, column: 5, scope: !1011)
!1048 = !DILocation(line: 113, column: 1, scope: !1011)
!1049 = distinct !DISubprogram(name: "ismr_destroy", scope: !50, file: !50, line: 101, type: !259, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1050 = !DILocation(line: 103, column: 5, scope: !1049)
!1051 = !DILocation(line: 104, column: 1, scope: !1049)
!1052 = distinct !DISubprogram(name: "queue_lock_acquire", scope: !33, file: !33, line: 31, type: !899, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1053 = !DILocalVariable(name: "l", arg: 1, scope: !1052, file: !33, line: 31, type: !901)
!1054 = !DILocation(line: 31, column: 1, scope: !1052)
!1055 = !DILocalVariable(name: "val", scope: !1052, file: !33, line: 31, type: !66)
!1056 = !DILocation(line: 31, column: 1, scope: !1057)
!1057 = distinct !DILexicalBlock(scope: !1058, file: !33, line: 31, column: 1)
!1058 = distinct !DILexicalBlock(scope: !1052, file: !33, line: 31, column: 1)
!1059 = !DILocation(line: 31, column: 1, scope: !1058)
!1060 = distinct !DISubprogram(name: "vatomicptr_read_acq", scope: !731, file: !731, line: 181, type: !732, scopeLine: 182, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1061 = !DILocalVariable(name: "a", arg: 1, scope: !1060, file: !731, line: 181, type: !734)
!1062 = !DILocation(line: 181, column: 41, scope: !1060)
!1063 = !DILocalVariable(name: "val", scope: !1060, file: !731, line: 183, type: !13)
!1064 = !DILocation(line: 183, column: 11, scope: !1060)
!1065 = !DILocation(line: 186, column: 32, scope: !1060)
!1066 = !DILocation(line: 186, column: 35, scope: !1060)
!1067 = !DILocation(line: 184, column: 5, scope: !1060)
!1068 = !{i64 852131}
!1069 = !DILocation(line: 188, column: 12, scope: !1060)
!1070 = !DILocation(line: 188, column: 5, scope: !1060)
!1071 = distinct !DISubprogram(name: "queue_lock_release", scope: !33, file: !33, line: 31, type: !899, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1072 = !DILocalVariable(name: "l", arg: 1, scope: !1071, file: !33, line: 31, type: !901)
!1073 = !DILocation(line: 31, column: 1, scope: !1071)
!1074 = !DILocalVariable(name: "val", scope: !1071, file: !33, line: 31, type: !66)
!1075 = !DILocation(line: 31, column: 1, scope: !1076)
!1076 = distinct !DILexicalBlock(scope: !1077, file: !33, line: 31, column: 1)
!1077 = distinct !DILexicalBlock(scope: !1071, file: !33, line: 31, column: 1)
!1078 = !DILocation(line: 31, column: 1, scope: !1077)
!1079 = distinct !DISubprogram(name: "vmem_free", scope: !79, file: !79, line: 71, type: !46, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1080 = !DILocalVariable(name: "ptr", arg: 1, scope: !1079, file: !79, line: 71, type: !13)
!1081 = !DILocation(line: 71, column: 17, scope: !1079)
!1082 = !DILocation(line: 73, column: 10, scope: !1079)
!1083 = !DILocation(line: 73, column: 5, scope: !1079)
!1084 = !DILocation(line: 74, column: 9, scope: !1085)
!1085 = distinct !DILexicalBlock(scope: !1079, file: !79, line: 74, column: 9)
!1086 = !DILocation(line: 74, column: 9, scope: !1079)
!1087 = !DILocation(line: 76, column: 9, scope: !1088)
!1088 = distinct !DILexicalBlock(scope: !1085, file: !79, line: 74, column: 14)
!1089 = !DILocation(line: 78, column: 5, scope: !1088)
!1090 = !DILocation(line: 79, column: 1, scope: !1079)
!1091 = distinct !DISubprogram(name: "vatomic64_inc_rlx", scope: !1092, file: !1092, line: 3000, type: !1093, scopeLine: 3001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1092 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!1093 = !DISubroutineType(types: !1094)
!1094 = !{null, !1095}
!1095 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!1096 = !DILocalVariable(name: "a", arg: 1, scope: !1091, file: !1092, line: 3000, type: !1095)
!1097 = !DILocation(line: 3000, column: 32, scope: !1091)
!1098 = !DILocation(line: 3002, column: 33, scope: !1091)
!1099 = !DILocation(line: 3002, column: 11, scope: !1091)
!1100 = !DILocation(line: 3003, column: 1, scope: !1091)
!1101 = distinct !DISubprogram(name: "vatomic64_get_inc_rlx", scope: !1092, file: !1092, line: 2560, type: !1102, scopeLine: 2561, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1102 = !DISubroutineType(types: !1103)
!1103 = !{!84, !1095}
!1104 = !DILocalVariable(name: "a", arg: 1, scope: !1101, file: !1092, line: 2560, type: !1095)
!1105 = !DILocation(line: 2560, column: 36, scope: !1101)
!1106 = !DILocation(line: 2562, column: 34, scope: !1101)
!1107 = !DILocation(line: 2562, column: 12, scope: !1101)
!1108 = !DILocation(line: 2562, column: 5, scope: !1101)
!1109 = distinct !DISubprogram(name: "vatomic64_get_add_rlx", scope: !1110, file: !1110, line: 1888, type: !1111, scopeLine: 1889, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1110 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!1111 = !DISubroutineType(types: !1112)
!1112 = !{!84, !1095, !84}
!1113 = !DILocalVariable(name: "a", arg: 1, scope: !1109, file: !1110, line: 1888, type: !1095)
!1114 = !DILocation(line: 1888, column: 36, scope: !1109)
!1115 = !DILocalVariable(name: "v", arg: 2, scope: !1109, file: !1110, line: 1888, type: !84)
!1116 = !DILocation(line: 1888, column: 49, scope: !1109)
!1117 = !DILocalVariable(name: "oldv", scope: !1109, file: !1110, line: 1890, type: !84)
!1118 = !DILocation(line: 1890, column: 15, scope: !1109)
!1119 = !DILocalVariable(name: "tmp", scope: !1109, file: !1110, line: 1891, type: !1120)
!1120 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !6, line: 35, baseType: !1121)
!1121 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !86, line: 26, baseType: !1122)
!1122 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !88, line: 42, baseType: !126)
!1123 = !DILocation(line: 1891, column: 15, scope: !1109)
!1124 = !DILocalVariable(name: "newv", scope: !1109, file: !1110, line: 1892, type: !84)
!1125 = !DILocation(line: 1892, column: 15, scope: !1109)
!1126 = !DILocation(line: 1893, column: 5, scope: !1109)
!1127 = !DILocation(line: 1901, column: 19, scope: !1109)
!1128 = !DILocation(line: 1901, column: 22, scope: !1109)
!1129 = !{i64 961875, i64 961909, i64 961924, i64 961956, i64 961998, i64 962039}
!1130 = !DILocation(line: 1904, column: 12, scope: !1109)
!1131 = !DILocation(line: 1904, column: 5, scope: !1109)
!1132 = distinct !DISubprogram(name: "locked_trace_destroy", scope: !98, file: !98, line: 31, type: !1133, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1133 = !DISubroutineType(types: !1134)
!1134 = !{null, !820, !1135}
!1135 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_verify_unit", file: !103, line: 25, baseType: !1136)
!1136 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1137, size: 64)
!1137 = !DISubroutineType(types: !1138)
!1138 = !{!24, !107}
!1139 = !DILocalVariable(name: "trace", arg: 1, scope: !1132, file: !98, line: 31, type: !820)
!1140 = !DILocation(line: 31, column: 38, scope: !1132)
!1141 = !DILocalVariable(name: "callback", arg: 2, scope: !1132, file: !98, line: 31, type: !1135)
!1142 = !DILocation(line: 31, column: 63, scope: !1132)
!1143 = !DILocation(line: 33, column: 19, scope: !1132)
!1144 = !DILocation(line: 33, column: 26, scope: !1132)
!1145 = !DILocation(line: 33, column: 33, scope: !1132)
!1146 = !DILocation(line: 33, column: 5, scope: !1132)
!1147 = !DILocation(line: 34, column: 20, scope: !1132)
!1148 = !DILocation(line: 34, column: 27, scope: !1132)
!1149 = !DILocation(line: 34, column: 5, scope: !1132)
!1150 = !DILocation(line: 35, column: 28, scope: !1132)
!1151 = !DILocation(line: 35, column: 35, scope: !1132)
!1152 = !DILocation(line: 35, column: 5, scope: !1132)
!1153 = !DILocation(line: 36, column: 1, scope: !1132)
!1154 = distinct !DISubprogram(name: "_ismr_none_destroy_all_cb", scope: !50, file: !50, line: 25, type: !1137, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1155 = !DILocalVariable(name: "unit", arg: 1, scope: !1154, file: !50, line: 25, type: !107)
!1156 = !DILocation(line: 25, column: 41, scope: !1154)
!1157 = !DILocation(line: 27, column: 5, scope: !1158)
!1158 = distinct !DILexicalBlock(scope: !1159, file: !50, line: 27, column: 5)
!1159 = distinct !DILexicalBlock(scope: !1154, file: !50, line: 27, column: 5)
!1160 = !DILocation(line: 27, column: 5, scope: !1159)
!1161 = !DILocalVariable(name: "info", scope: !1154, file: !50, line: 28, type: !48)
!1162 = !DILocation(line: 28, column: 29, scope: !1154)
!1163 = !DILocation(line: 28, column: 62, scope: !1154)
!1164 = !DILocation(line: 28, column: 68, scope: !1154)
!1165 = !DILocation(line: 28, column: 36, scope: !1154)
!1166 = !DILocation(line: 29, column: 5, scope: !1154)
!1167 = !DILocation(line: 29, column: 11, scope: !1154)
!1168 = !DILocation(line: 29, column: 20, scope: !1154)
!1169 = !DILocation(line: 29, column: 26, scope: !1154)
!1170 = !DILocation(line: 29, column: 35, scope: !1154)
!1171 = !DILocation(line: 29, column: 41, scope: !1154)
!1172 = !DILocation(line: 30, column: 10, scope: !1154)
!1173 = !DILocation(line: 30, column: 5, scope: !1154)
!1174 = !DILocation(line: 31, column: 5, scope: !1154)
!1175 = distinct !DISubprogram(name: "trace_verify", scope: !103, file: !103, line: 210, type: !1176, scopeLine: 211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1176 = !DISubroutineType(types: !1177)
!1177 = !{!24, !840, !1135}
!1178 = !DILocalVariable(name: "trace", arg: 1, scope: !1175, file: !103, line: 210, type: !840)
!1179 = !DILocation(line: 210, column: 23, scope: !1175)
!1180 = !DILocalVariable(name: "verify_fun", arg: 2, scope: !1175, file: !103, line: 210, type: !1135)
!1181 = !DILocation(line: 210, column: 48, scope: !1175)
!1182 = !DILocalVariable(name: "i", scope: !1175, file: !103, line: 212, type: !5)
!1183 = !DILocation(line: 212, column: 13, scope: !1175)
!1184 = !DILocation(line: 214, column: 5, scope: !1185)
!1185 = distinct !DILexicalBlock(scope: !1186, file: !103, line: 214, column: 5)
!1186 = distinct !DILexicalBlock(scope: !1175, file: !103, line: 214, column: 5)
!1187 = !DILocation(line: 214, column: 5, scope: !1186)
!1188 = !DILocation(line: 215, column: 5, scope: !1189)
!1189 = distinct !DILexicalBlock(scope: !1190, file: !103, line: 215, column: 5)
!1190 = distinct !DILexicalBlock(scope: !1175, file: !103, line: 215, column: 5)
!1191 = !DILocation(line: 215, column: 5, scope: !1190)
!1192 = !DILocation(line: 216, column: 5, scope: !1193)
!1193 = distinct !DILexicalBlock(scope: !1194, file: !103, line: 216, column: 5)
!1194 = distinct !DILexicalBlock(scope: !1175, file: !103, line: 216, column: 5)
!1195 = !DILocation(line: 216, column: 5, scope: !1194)
!1196 = !DILocation(line: 218, column: 12, scope: !1197)
!1197 = distinct !DILexicalBlock(scope: !1175, file: !103, line: 218, column: 5)
!1198 = !DILocation(line: 218, column: 10, scope: !1197)
!1199 = !DILocation(line: 218, column: 17, scope: !1200)
!1200 = distinct !DILexicalBlock(scope: !1197, file: !103, line: 218, column: 5)
!1201 = !DILocation(line: 218, column: 21, scope: !1200)
!1202 = !DILocation(line: 218, column: 28, scope: !1200)
!1203 = !DILocation(line: 218, column: 19, scope: !1200)
!1204 = !DILocation(line: 218, column: 5, scope: !1197)
!1205 = !DILocation(line: 219, column: 13, scope: !1206)
!1206 = distinct !DILexicalBlock(scope: !1207, file: !103, line: 219, column: 13)
!1207 = distinct !DILexicalBlock(scope: !1200, file: !103, line: 218, column: 38)
!1208 = !DILocation(line: 219, column: 25, scope: !1206)
!1209 = !DILocation(line: 219, column: 32, scope: !1206)
!1210 = !DILocation(line: 219, column: 38, scope: !1206)
!1211 = !DILocation(line: 219, column: 42, scope: !1206)
!1212 = !DILocation(line: 219, column: 13, scope: !1207)
!1213 = !DILocation(line: 220, column: 13, scope: !1214)
!1214 = distinct !DILexicalBlock(scope: !1206, file: !103, line: 219, column: 52)
!1215 = !DILocation(line: 222, column: 5, scope: !1207)
!1216 = !DILocation(line: 218, column: 34, scope: !1200)
!1217 = !DILocation(line: 218, column: 5, scope: !1200)
!1218 = distinct !{!1218, !1204, !1219, !302}
!1219 = !DILocation(line: 222, column: 5, scope: !1197)
!1220 = !DILocation(line: 223, column: 5, scope: !1175)
!1221 = !DILocation(line: 224, column: 1, scope: !1175)
!1222 = distinct !DISubprogram(name: "trace_destroy", scope: !103, file: !103, line: 97, type: !1223, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1223 = !DISubroutineType(types: !1224)
!1224 = !{null, !840}
!1225 = !DILocalVariable(name: "trace", arg: 1, scope: !1222, file: !103, line: 97, type: !840)
!1226 = !DILocation(line: 97, column: 24, scope: !1222)
!1227 = !DILocation(line: 99, column: 5, scope: !1228)
!1228 = distinct !DILexicalBlock(scope: !1229, file: !103, line: 99, column: 5)
!1229 = distinct !DILexicalBlock(scope: !1222, file: !103, line: 99, column: 5)
!1230 = !DILocation(line: 99, column: 5, scope: !1229)
!1231 = !DILocation(line: 100, column: 5, scope: !1232)
!1232 = distinct !DILexicalBlock(scope: !1233, file: !103, line: 100, column: 5)
!1233 = distinct !DILexicalBlock(scope: !1222, file: !103, line: 100, column: 5)
!1234 = !DILocation(line: 100, column: 5, scope: !1233)
!1235 = !DILocation(line: 101, column: 10, scope: !1222)
!1236 = !DILocation(line: 101, column: 17, scope: !1222)
!1237 = !DILocation(line: 101, column: 5, scope: !1222)
!1238 = !DILocation(line: 102, column: 5, scope: !1222)
!1239 = !DILocation(line: 102, column: 12, scope: !1222)
!1240 = !DILocation(line: 102, column: 24, scope: !1222)
!1241 = !DILocation(line: 103, column: 1, scope: !1222)
!1242 = distinct !DISubprogram(name: "vmem_malloc", scope: !79, file: !79, line: 20, type: !1243, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1243 = !DISubroutineType(types: !1244)
!1244 = !{!13, !5}
!1245 = !DILocalVariable(name: "sz", arg: 1, scope: !1242, file: !79, line: 20, type: !5)
!1246 = !DILocation(line: 20, column: 21, scope: !1242)
!1247 = !DILocalVariable(name: "ptr", scope: !1242, file: !79, line: 22, type: !13)
!1248 = !DILocation(line: 22, column: 11, scope: !1242)
!1249 = !DILocation(line: 22, column: 24, scope: !1242)
!1250 = !DILocation(line: 22, column: 17, scope: !1242)
!1251 = !DILocation(line: 23, column: 9, scope: !1252)
!1252 = distinct !DILexicalBlock(scope: !1242, file: !79, line: 23, column: 9)
!1253 = !DILocation(line: 23, column: 9, scope: !1242)
!1254 = !DILocation(line: 25, column: 9, scope: !1255)
!1255 = distinct !DILexicalBlock(scope: !1252, file: !79, line: 23, column: 14)
!1256 = !DILocation(line: 27, column: 5, scope: !1255)
!1257 = !DILocation(line: 28, column: 9, scope: !1258)
!1258 = distinct !DILexicalBlock(scope: !1259, file: !79, line: 28, column: 9)
!1259 = distinct !DILexicalBlock(scope: !1260, file: !79, line: 28, column: 9)
!1260 = distinct !DILexicalBlock(scope: !1252, file: !79, line: 27, column: 12)
!1261 = !DILocation(line: 30, column: 12, scope: !1242)
!1262 = !DILocation(line: 30, column: 5, scope: !1242)
!1263 = distinct !DISubprogram(name: "ismr_enter", scope: !50, file: !50, line: 41, type: !174, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1264 = !DILocalVariable(name: "tid", arg: 1, scope: !1263, file: !50, line: 41, type: !5)
!1265 = !DILocation(line: 41, column: 20, scope: !1263)
!1266 = !DILocation(line: 43, column: 5, scope: !1263)
!1267 = !DILocation(line: 43, column: 5, scope: !1268)
!1268 = distinct !DILexicalBlock(scope: !1263, file: !50, line: 43, column: 5)
!1269 = !DILocation(line: 43, column: 5, scope: !1270)
!1270 = distinct !DILexicalBlock(scope: !1268, file: !50, line: 43, column: 5)
!1271 = !DILocation(line: 43, column: 5, scope: !1272)
!1272 = distinct !DILexicalBlock(scope: !1270, file: !50, line: 43, column: 5)
!1273 = !DILocation(line: 44, column: 1, scope: !1263)
!1274 = distinct !DISubprogram(name: "vqueue_ub_enq", scope: !33, file: !33, line: 122, type: !1275, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1275 = !DISubroutineType(types: !1276)
!1276 = !{null, !359, !31, !13}
!1277 = !DILocalVariable(name: "q", arg: 1, scope: !1274, file: !33, line: 122, type: !359)
!1278 = !DILocation(line: 122, column: 28, scope: !1274)
!1279 = !DILocalVariable(name: "qnode", arg: 2, scope: !1274, file: !33, line: 122, type: !31)
!1280 = !DILocation(line: 122, column: 49, scope: !1274)
!1281 = !DILocalVariable(name: "data", arg: 3, scope: !1274, file: !33, line: 122, type: !13)
!1282 = !DILocation(line: 122, column: 62, scope: !1274)
!1283 = !DILocation(line: 124, column: 25, scope: !1274)
!1284 = !DILocation(line: 124, column: 28, scope: !1274)
!1285 = !DILocation(line: 124, column: 5, scope: !1274)
!1286 = !DILocation(line: 127, column: 26, scope: !1274)
!1287 = !DILocation(line: 127, column: 33, scope: !1274)
!1288 = !DILocation(line: 127, column: 5, scope: !1274)
!1289 = !DILocation(line: 129, column: 27, scope: !1274)
!1290 = !DILocation(line: 129, column: 30, scope: !1274)
!1291 = !DILocation(line: 129, column: 36, scope: !1274)
!1292 = !DILocation(line: 129, column: 42, scope: !1274)
!1293 = !DILocation(line: 129, column: 5, scope: !1274)
!1294 = !DILocation(line: 131, column: 15, scope: !1274)
!1295 = !DILocation(line: 131, column: 5, scope: !1274)
!1296 = !DILocation(line: 131, column: 8, scope: !1274)
!1297 = !DILocation(line: 131, column: 13, scope: !1274)
!1298 = !DILocation(line: 132, column: 25, scope: !1274)
!1299 = !DILocation(line: 132, column: 28, scope: !1274)
!1300 = !DILocation(line: 132, column: 5, scope: !1274)
!1301 = !DILocation(line: 133, column: 1, scope: !1274)
!1302 = distinct !DISubprogram(name: "ismr_exit", scope: !50, file: !50, line: 83, type: !174, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1303 = !DILocalVariable(name: "tid", arg: 1, scope: !1302, file: !50, line: 83, type: !5)
!1304 = !DILocation(line: 83, column: 19, scope: !1302)
!1305 = !DILocation(line: 85, column: 5, scope: !1302)
!1306 = !DILocation(line: 85, column: 5, scope: !1307)
!1307 = distinct !DILexicalBlock(scope: !1302, file: !50, line: 85, column: 5)
!1308 = !DILocation(line: 85, column: 5, scope: !1309)
!1309 = distinct !DILexicalBlock(scope: !1307, file: !50, line: 85, column: 5)
!1310 = !DILocation(line: 85, column: 5, scope: !1311)
!1311 = distinct !DILexicalBlock(scope: !1309, file: !50, line: 85, column: 5)
!1312 = !DILocation(line: 86, column: 1, scope: !1302)
!1313 = distinct !DISubprogram(name: "vatomicptr_write_rel", scope: !731, file: !731, line: 311, type: !905, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1314 = !DILocalVariable(name: "a", arg: 1, scope: !1313, file: !731, line: 311, type: !907)
!1315 = !DILocation(line: 311, column: 36, scope: !1313)
!1316 = !DILocalVariable(name: "v", arg: 2, scope: !1313, file: !731, line: 311, type: !13)
!1317 = !DILocation(line: 311, column: 45, scope: !1313)
!1318 = !DILocation(line: 315, column: 32, scope: !1313)
!1319 = !DILocation(line: 315, column: 44, scope: !1313)
!1320 = !DILocation(line: 315, column: 47, scope: !1313)
!1321 = !DILocation(line: 313, column: 5, scope: !1313)
!1322 = !{i64 856361}
!1323 = !DILocation(line: 317, column: 1, scope: !1313)
!1324 = distinct !DISubprogram(name: "_queue_retire", scope: !44, file: !44, line: 53, type: !995, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1325 = !DILocalVariable(name: "node", arg: 1, scope: !1324, file: !44, line: 53, type: !497)
!1326 = !DILocation(line: 53, column: 29, scope: !1324)
!1327 = !DILocalVariable(name: "arg", arg: 2, scope: !1324, file: !44, line: 53, type: !13)
!1328 = !DILocation(line: 53, column: 41, scope: !1324)
!1329 = !DILocation(line: 61, column: 15, scope: !1324)
!1330 = !DILocation(line: 61, column: 5, scope: !1324)
!1331 = !DILocation(line: 63, column: 5, scope: !1324)
!1332 = !DILocation(line: 63, column: 5, scope: !1333)
!1333 = distinct !DILexicalBlock(scope: !1324, file: !44, line: 63, column: 5)
!1334 = !DILocation(line: 63, column: 5, scope: !1335)
!1335 = distinct !DILexicalBlock(scope: !1333, file: !44, line: 63, column: 5)
!1336 = !DILocation(line: 63, column: 5, scope: !1337)
!1337 = distinct !DILexicalBlock(scope: !1335, file: !44, line: 63, column: 5)
!1338 = !DILocation(line: 64, column: 1, scope: !1324)
!1339 = distinct !DISubprogram(name: "vqueue_ub_empty", scope: !33, file: !33, line: 143, type: !1340, scopeLine: 144, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !176)
!1340 = !DISubroutineType(types: !1341)
!1341 = !{!24, !359}
!1342 = !DILocalVariable(name: "q", arg: 1, scope: !1339, file: !33, line: 143, type: !359)
!1343 = !DILocation(line: 143, column: 30, scope: !1339)
!1344 = !DILocalVariable(name: "qnode", scope: !1339, file: !33, line: 145, type: !31)
!1345 = !DILocation(line: 145, column: 23, scope: !1339)
!1346 = !DILocalVariable(name: "head", scope: !1339, file: !33, line: 146, type: !31)
!1347 = !DILocation(line: 146, column: 23, scope: !1339)
!1348 = !DILocation(line: 148, column: 25, scope: !1339)
!1349 = !DILocation(line: 148, column: 28, scope: !1339)
!1350 = !DILocation(line: 148, column: 5, scope: !1339)
!1351 = !DILocation(line: 149, column: 12, scope: !1339)
!1352 = !DILocation(line: 149, column: 15, scope: !1339)
!1353 = !DILocation(line: 149, column: 10, scope: !1339)
!1354 = !DILocation(line: 151, column: 54, scope: !1339)
!1355 = !DILocation(line: 151, column: 60, scope: !1339)
!1356 = !DILocation(line: 151, column: 33, scope: !1339)
!1357 = !DILocation(line: 151, column: 13, scope: !1339)
!1358 = !DILocation(line: 151, column: 11, scope: !1339)
!1359 = !DILocation(line: 152, column: 25, scope: !1339)
!1360 = !DILocation(line: 152, column: 28, scope: !1339)
!1361 = !DILocation(line: 152, column: 5, scope: !1339)
!1362 = !DILocation(line: 153, column: 12, scope: !1339)
!1363 = !DILocation(line: 153, column: 18, scope: !1339)
!1364 = !DILocation(line: 153, column: 5, scope: !1339)
