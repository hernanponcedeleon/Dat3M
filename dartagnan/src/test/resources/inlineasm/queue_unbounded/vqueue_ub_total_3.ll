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
@.str = private unnamed_addr constant [6 x i8] c"deq_1\00", align 1
@.str.1 = private unnamed_addr constant [78 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/test_case_3.h\00", align 1
@__PRETTY_FUNCTION__.t2 = private unnamed_addr constant [17 x i8] c"void t2(vsize_t)\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"deq_1->key == 1\00", align 1
@.str.3 = private unnamed_addr constant [11 x i8] c"g_len == 2\00", align 1
@__PRETTY_FUNCTION__.verify = private unnamed_addr constant [18 x i8] c"void verify(void)\00", align 1
@g_final_state = dso_local global [5 x i64] zeroinitializer, align 16, !dbg !166
@.str.4 = private unnamed_addr constant [47 x i8] c"g_final_state[i] == 2 || g_final_state[i] == 3\00", align 1
@g_queue = dso_local global %struct.vqueue_ub_s zeroinitializer, align 8, !dbg !154
@.str.5 = private unnamed_addr constant [15 x i8] c"vmem_no_leak()\00", align 1
@.str.6 = private unnamed_addr constant [89 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/unbounded_queue_verify.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c"data\00", align 1
@__PRETTY_FUNCTION__.get_final_state = private unnamed_addr constant [29 x i8] c"void get_final_state(void *)\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"g_len < 5\00", align 1
@.str.9 = private unnamed_addr constant [39 x i8] c"currently only 3 threads are supported\00", align 1
@.str.10 = private unnamed_addr constant [41 x i8] c"\22currently only 3 threads are supported\22\00", align 1
@__PRETTY_FUNCTION__.run = private unnamed_addr constant [18 x i8] c"void *run(void *)\00", align 1
@global_trace = dso_local global %struct.locked_trace_s zeroinitializer, align 8, !dbg !102
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
define dso_local void @t1(i64 noundef %0) #0 !dbg !179 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !183, metadata !DIExpression()), !dbg !184
  %3 = load i64, i64* %2, align 8, !dbg !185
  call void @enq(i64 noundef %3, i64 noundef 2, i8 noundef signext 65), !dbg !186
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
define dso_local void @t2(i64 noundef %0) #0 !dbg !202 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !203, metadata !DIExpression()), !dbg !204
  %3 = load i64, i64* %2, align 8, !dbg !205
  %4 = call %struct.data_s* @deq(i64 noundef %3), !dbg !206
  store %struct.data_s* %4, %struct.data_s** @deq_1, align 8, !dbg !207
  %5 = load %struct.data_s*, %struct.data_s** @deq_1, align 8, !dbg !208
  %6 = icmp ne %struct.data_s* %5, null, !dbg !208
  br i1 %6, label %7, label %8, !dbg !211

7:                                                ; preds = %1
  br label %9, !dbg !211

8:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 21, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t2, i64 0, i64 0)) #5, !dbg !208
  unreachable, !dbg !208

9:                                                ; preds = %7
  %10 = load %struct.data_s*, %struct.data_s** @deq_1, align 8, !dbg !212
  %11 = getelementptr inbounds %struct.data_s, %struct.data_s* %10, i32 0, i32 0, !dbg !212
  %12 = load i64, i64* %11, align 8, !dbg !212
  %13 = icmp eq i64 %12, 1, !dbg !212
  br i1 %13, label %14, label %15, !dbg !215

14:                                               ; preds = %9
  br label %16, !dbg !215

15:                                               ; preds = %9
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 23, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t2, i64 0, i64 0)) #5, !dbg !212
  unreachable, !dbg !212

16:                                               ; preds = %14
  %17 = load i64, i64* %2, align 8, !dbg !216
  call void @queue_clean(i64 noundef %17), !dbg !217
  ret void, !dbg !218
}

; Function Attrs: noinline nounwind uwtable
define dso_local %struct.data_s* @deq(i64 noundef %0) #0 !dbg !219 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !222, metadata !DIExpression()), !dbg !223
  %3 = load i64, i64* %2, align 8, !dbg !224
  %4 = call i8* @queue_deq(i64 noundef %3, %struct.vqueue_ub_s* noundef @g_queue), !dbg !225
  %5 = bitcast i8* %4 to %struct.data_s*, !dbg !225
  ret %struct.data_s* %5, !dbg !226
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal void @queue_clean(i64 noundef %0) #0 !dbg !227 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !228, metadata !DIExpression()), !dbg !229
  %3 = load i64, i64* %2, align 8, !dbg !230
  call void @ismr_recycle(i64 noundef %3), !dbg !231
  ret void, !dbg !232
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @t3(i64 noundef %0) #0 !dbg !233 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !234, metadata !DIExpression()), !dbg !235
  %3 = load i64, i64* %2, align 8, !dbg !236
  call void @enq(i64 noundef %3, i64 noundef 3, i8 noundef signext 66), !dbg !237
  ret void, !dbg !238
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @verify() #0 !dbg !239 {
  %1 = alloca i64, align 8
  %2 = load i64, i64* @g_len, align 8, !dbg !242
  %3 = icmp eq i64 %2, 2, !dbg !242
  br i1 %3, label %4, label %5, !dbg !245

4:                                                ; preds = %0
  br label %6, !dbg !245

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !242
  unreachable, !dbg !242

6:                                                ; preds = %4
  call void @llvm.dbg.declare(metadata i64* %1, metadata !246, metadata !DIExpression()), !dbg !248
  store i64 0, i64* %1, align 8, !dbg !248
  br label %7, !dbg !249

7:                                                ; preds = %24, %6
  %8 = load i64, i64* %1, align 8, !dbg !250
  %9 = load i64, i64* @g_len, align 8, !dbg !252
  %10 = icmp ult i64 %8, %9, !dbg !253
  br i1 %10, label %11, label %27, !dbg !254

11:                                               ; preds = %7
  %12 = load i64, i64* %1, align 8, !dbg !255
  %13 = getelementptr inbounds [5 x i64], [5 x i64]* @g_final_state, i64 0, i64 %12, !dbg !255
  %14 = load i64, i64* %13, align 8, !dbg !255
  %15 = icmp eq i64 %14, 2, !dbg !255
  br i1 %15, label %21, label %16, !dbg !255

16:                                               ; preds = %11
  %17 = load i64, i64* %1, align 8, !dbg !255
  %18 = getelementptr inbounds [5 x i64], [5 x i64]* @g_final_state, i64 0, i64 %17, !dbg !255
  %19 = load i64, i64* %18, align 8, !dbg !255
  %20 = icmp eq i64 %19, 3, !dbg !255
  br i1 %20, label %21, label %22, !dbg !259

21:                                               ; preds = %16, %11
  br label %23, !dbg !259

22:                                               ; preds = %16
  call void @__assert_fail(i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 40, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !255
  unreachable, !dbg !255

23:                                               ; preds = %21
  br label %24, !dbg !260

24:                                               ; preds = %23
  %25 = load i64, i64* %1, align 8, !dbg !261
  %26 = add i64 %25, 1, !dbg !261
  store i64 %26, i64* %1, align 8, !dbg !261
  br label %7, !dbg !262, !llvm.loop !263

27:                                               ; preds = %7
  ret void, !dbg !266
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !267 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @init(), !dbg !270
  call void @launch_threads(i64 noundef 3, i8* (i8*)* noundef @run), !dbg !271
  call void @queue_print(%struct.vqueue_ub_s* noundef @g_queue, void (i8*)* noundef @get_final_state), !dbg !272
  call void @verify(), !dbg !273
  call void @destroy(), !dbg !274
  %2 = call zeroext i1 @vmem_no_leak(), !dbg !275
  br i1 %2, label %3, label %4, !dbg !278

3:                                                ; preds = %0
  br label %5, !dbg !278

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.6, i64 0, i64 0), i32 noundef 58, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !275
  unreachable, !dbg !275

5:                                                ; preds = %3
  ret i32 0, !dbg !279
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !280 {
  %1 = alloca i8, align 1
  %2 = alloca i64, align 8
  call void @queue_init(%struct.vqueue_ub_s* noundef @g_queue), !dbg !281
  call void @queue_register(i64 noundef 0, %struct.vqueue_ub_s* noundef @g_queue), !dbg !282
  call void @llvm.dbg.declare(metadata i8* %1, metadata !283, metadata !DIExpression()), !dbg !284
  store i8 97, i8* %1, align 1, !dbg !284
  call void @llvm.dbg.declare(metadata i64* %2, metadata !285, metadata !DIExpression()), !dbg !287
  store i64 1, i64* %2, align 8, !dbg !287
  br label %3, !dbg !288

3:                                                ; preds = %9, %0
  %4 = load i64, i64* %2, align 8, !dbg !289
  %5 = icmp ule i64 %4, 1, !dbg !291
  br i1 %5, label %6, label %14, !dbg !292

6:                                                ; preds = %3
  %7 = load i64, i64* %2, align 8, !dbg !293
  %8 = load i8, i8* %1, align 1, !dbg !295
  call void @enq(i64 noundef 0, i64 noundef %7, i8 noundef signext %8), !dbg !296
  br label %9, !dbg !297

9:                                                ; preds = %6
  %10 = load i64, i64* %2, align 8, !dbg !298
  %11 = add i64 %10, 1, !dbg !298
  store i64 %11, i64* %2, align 8, !dbg !298
  %12 = load i8, i8* %1, align 1, !dbg !299
  %13 = add i8 %12, 1, !dbg !299
  store i8 %13, i8* %1, align 1, !dbg !299
  br label %3, !dbg !300, !llvm.loop !301

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
  %8 = call noalias i8* @malloc(i64 noundef %7) #6, !dbg !316
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
  call void @free(i8* noundef %16) #6, !dbg !325
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([41 x i8], [41 x i8]* @.str.10, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.6, i64 0, i64 0), i32 noundef 141, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !350
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.7, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.6, i64 0, i64 0), i32 noundef 119, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.get_final_state, i64 0, i64 0)) #5, !dbg !372
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.8, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.6, i64 0, i64 0), i32 noundef 121, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.get_final_state, i64 0, i64 0)) #5, !dbg !379
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
  call void @free(i8* noundef %10) #6, !dbg !459
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([97 x i8], [97 x i8]* @.str.15, i64 0, i64 0), i32 noundef 166, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.queue_destroy, i64 0, i64 0)) #5, !dbg !465
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
  %11 = call noalias i8* @malloc(i64 noundef 16) #6, !dbg !483
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
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.14, i64 0, i64 0), i8* noundef getelementptr inbounds ([97 x i8], [97 x i8]* @.str.15, i64 0, i64 0), i32 noundef 196, i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @__PRETTY_FUNCTION__.queue_enq, i64 0, i64 0)) #5, !dbg !511
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
define dso_local zeroext i1 @empty(i64 noundef %0) #0 !dbg !535 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !538, metadata !DIExpression()), !dbg !539
  %3 = load i64, i64* %2, align 8, !dbg !540
  %4 = call zeroext i1 @queue_empty(i64 noundef %3, %struct.vqueue_ub_s* noundef @g_queue), !dbg !541
  ret i1 %4, !dbg !542
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @queue_empty(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !543 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca i8, align 1
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !546, metadata !DIExpression()), !dbg !547
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !548, metadata !DIExpression()), !dbg !549
  %6 = load i64, i64* %3, align 8, !dbg !550
  call void @ismr_enter(i64 noundef %6), !dbg !551
  call void @llvm.dbg.declare(metadata i8* %5, metadata !552, metadata !DIExpression()), !dbg !553
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !554
  %8 = call zeroext i1 @vqueue_ub_empty(%struct.vqueue_ub_s* noundef %7), !dbg !555
  %9 = zext i1 %8 to i8, !dbg !553
  store i8 %9, i8* %5, align 1, !dbg !553
  %10 = load i64, i64* %3, align 8, !dbg !556
  call void @ismr_exit(i64 noundef %10), !dbg !557
  %11 = load i8, i8* %5, align 1, !dbg !558
  %12 = trunc i8 %11 to i1, !dbg !558
  ret i1 %12, !dbg !559
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_recycle(i64 noundef %0) #0 !dbg !560 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !561, metadata !DIExpression()), !dbg !562
  br label %3, !dbg !563

3:                                                ; preds = %1
  br label %4, !dbg !564

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !566
  br label %6, !dbg !566

6:                                                ; preds = %4
  br label %7, !dbg !568

7:                                                ; preds = %6
  br label %8, !dbg !566

8:                                                ; preds = %7
  br label %9, !dbg !564

9:                                                ; preds = %8
  ret void, !dbg !570
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !571 {
  %5 = alloca %struct.run_info_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8* (i8*)*, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !574, metadata !DIExpression()), !dbg !575
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !576, metadata !DIExpression()), !dbg !577
  store i8* (i8*)* %2, i8* (i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %7, metadata !578, metadata !DIExpression()), !dbg !579
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !580, metadata !DIExpression()), !dbg !581
  call void @llvm.dbg.declare(metadata i64* %9, metadata !582, metadata !DIExpression()), !dbg !583
  store i64 0, i64* %9, align 8, !dbg !583
  store i64 0, i64* %9, align 8, !dbg !584
  br label %11, !dbg !586

11:                                               ; preds = %42, %4
  %12 = load i64, i64* %9, align 8, !dbg !587
  %13 = load i64, i64* %6, align 8, !dbg !589
  %14 = icmp ult i64 %12, %13, !dbg !590
  br i1 %14, label %15, label %45, !dbg !591

15:                                               ; preds = %11
  %16 = load i64, i64* %9, align 8, !dbg !592
  %17 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !594
  %18 = load i64, i64* %9, align 8, !dbg !595
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %17, i64 %18, !dbg !594
  %20 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %19, i32 0, i32 1, !dbg !596
  store i64 %16, i64* %20, align 8, !dbg !597
  %21 = load i8* (i8*)*, i8* (i8*)** %7, align 8, !dbg !598
  %22 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !599
  %23 = load i64, i64* %9, align 8, !dbg !600
  %24 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %22, i64 %23, !dbg !599
  %25 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %24, i32 0, i32 3, !dbg !601
  store i8* (i8*)* %21, i8* (i8*)** %25, align 8, !dbg !602
  %26 = load i8, i8* %8, align 1, !dbg !603
  %27 = trunc i8 %26 to i1, !dbg !603
  %28 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !604
  %29 = load i64, i64* %9, align 8, !dbg !605
  %30 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %28, i64 %29, !dbg !604
  %31 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %30, i32 0, i32 2, !dbg !606
  %32 = zext i1 %27 to i8, !dbg !607
  store i8 %32, i8* %31, align 8, !dbg !607
  %33 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !608
  %34 = load i64, i64* %9, align 8, !dbg !609
  %35 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %33, i64 %34, !dbg !608
  %36 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %35, i32 0, i32 0, !dbg !610
  %37 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !611
  %38 = load i64, i64* %9, align 8, !dbg !612
  %39 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %37, i64 %38, !dbg !611
  %40 = bitcast %struct.run_info_t* %39 to i8*, !dbg !613
  %41 = call i32 @pthread_create(i64* noundef %36, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %40) #6, !dbg !614
  br label %42, !dbg !615

42:                                               ; preds = %15
  %43 = load i64, i64* %9, align 8, !dbg !616
  %44 = add i64 %43, 1, !dbg !616
  store i64 %44, i64* %9, align 8, !dbg !616
  br label %11, !dbg !617, !llvm.loop !618

45:                                               ; preds = %11
  ret void, !dbg !620
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !621 {
  %3 = alloca %struct.run_info_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !624, metadata !DIExpression()), !dbg !625
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !626, metadata !DIExpression()), !dbg !627
  call void @llvm.dbg.declare(metadata i64* %5, metadata !628, metadata !DIExpression()), !dbg !629
  store i64 0, i64* %5, align 8, !dbg !629
  store i64 0, i64* %5, align 8, !dbg !630
  br label %6, !dbg !632

6:                                                ; preds = %17, %2
  %7 = load i64, i64* %5, align 8, !dbg !633
  %8 = load i64, i64* %4, align 8, !dbg !635
  %9 = icmp ult i64 %7, %8, !dbg !636
  br i1 %9, label %10, label %20, !dbg !637

10:                                               ; preds = %6
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !638
  %12 = load i64, i64* %5, align 8, !dbg !640
  %13 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i64 %12, !dbg !638
  %14 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %13, i32 0, i32 0, !dbg !641
  %15 = load i64, i64* %14, align 8, !dbg !641
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !642
  br label %17, !dbg !643

17:                                               ; preds = %10
  %18 = load i64, i64* %5, align 8, !dbg !644
  %19 = add i64 %18, 1, !dbg !644
  store i64 %19, i64* %5, align 8, !dbg !644
  br label %6, !dbg !645, !llvm.loop !646

20:                                               ; preds = %6
  ret void, !dbg !648
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !649 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.run_info_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !650, metadata !DIExpression()), !dbg !651
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !652, metadata !DIExpression()), !dbg !653
  %4 = load i8*, i8** %2, align 8, !dbg !654
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !655
  store %struct.run_info_t* %5, %struct.run_info_t** %3, align 8, !dbg !653
  %6 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !656
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %6, i32 0, i32 2, !dbg !658
  %8 = load i8, i8* %7, align 8, !dbg !658
  %9 = trunc i8 %8 to i1, !dbg !658
  br i1 %9, label %10, label %14, !dbg !659

10:                                               ; preds = %1
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !660
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i32 0, i32 1, !dbg !661
  %13 = load i64, i64* %12, align 8, !dbg !661
  call void @set_cpu_affinity(i64 noundef %13), !dbg !662
  br label %14, !dbg !662

14:                                               ; preds = %10, %1
  %15 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !663
  %16 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %15, i32 0, i32 3, !dbg !664
  %17 = load i8* (i8*)*, i8* (i8*)** %16, align 8, !dbg !664
  %18 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !665
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %18, i32 0, i32 1, !dbg !666
  %20 = load i64, i64* %19, align 8, !dbg !666
  %21 = inttoptr i64 %20 to i8*, !dbg !667
  %22 = call i8* %17(i8* noundef %21), !dbg !663
  ret i8* %22, !dbg !668
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !669 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !670, metadata !DIExpression()), !dbg !671
  br label %3, !dbg !672

3:                                                ; preds = %1
  br label %4, !dbg !673

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !675
  br label %6, !dbg !675

6:                                                ; preds = %4
  br label %7, !dbg !677

7:                                                ; preds = %6
  br label %8, !dbg !675

8:                                                ; preds = %7
  br label %9, !dbg !673

9:                                                ; preds = %8
  ret void, !dbg !679
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @_vqueue_ub_visit_nodes(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !680 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !689, metadata !DIExpression()), !dbg !690
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !691, metadata !DIExpression()), !dbg !692
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !693, metadata !DIExpression()), !dbg !694
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !695, metadata !DIExpression()), !dbg !696
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !696
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !697, metadata !DIExpression()), !dbg !698
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !698
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !699
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 2, !dbg !700
  %11 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !700
  store %struct.vqueue_ub_node_s* %11, %struct.vqueue_ub_node_s** %7, align 8, !dbg !701
  %12 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !702
  %13 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %12, i32 0, i32 1, !dbg !703
  %14 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %13), !dbg !704
  %15 = bitcast i8* %14 to %struct.vqueue_ub_node_s*, !dbg !705
  store %struct.vqueue_ub_node_s* %15, %struct.vqueue_ub_node_s** %7, align 8, !dbg !706
  br label %16, !dbg !707

16:                                               ; preds = %19, %3
  %17 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !708
  %18 = icmp ne %struct.vqueue_ub_node_s* %17, null, !dbg !707
  br i1 %18, label %19, label %28, !dbg !707

19:                                               ; preds = %16
  %20 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !709
  %21 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %20, i32 0, i32 1, !dbg !711
  %22 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %21), !dbg !712
  %23 = bitcast i8* %22 to %struct.vqueue_ub_node_s*, !dbg !713
  store %struct.vqueue_ub_node_s* %23, %struct.vqueue_ub_node_s** %8, align 8, !dbg !714
  %24 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !715
  %25 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !716
  %26 = load i8*, i8** %6, align 8, !dbg !717
  call void %24(%struct.vqueue_ub_node_s* noundef %25, i8* noundef %26), !dbg !715
  %27 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !718
  store %struct.vqueue_ub_node_s* %27, %struct.vqueue_ub_node_s** %7, align 8, !dbg !719
  br label %16, !dbg !707, !llvm.loop !720

28:                                               ; preds = %16
  ret void, !dbg !722
}

; Function Attrs: noinline nounwind uwtable
define internal void @_redirect_print(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !723 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca void (i8*)*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !726, metadata !DIExpression()), !dbg !727
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !728, metadata !DIExpression()), !dbg !729
  call void @llvm.dbg.declare(metadata void (i8*)** %5, metadata !730, metadata !DIExpression()), !dbg !731
  %6 = load i8*, i8** %4, align 8, !dbg !732
  %7 = bitcast i8* %6 to void (i8*)*, !dbg !733
  store void (i8*)* %7, void (i8*)** %5, align 8, !dbg !731
  %8 = load void (i8*)*, void (i8*)** %5, align 8, !dbg !734
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !735
  %10 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %9, i32 0, i32 0, !dbg !736
  %11 = load i8*, i8** %10, align 8, !dbg !736
  call void %8(i8* noundef %11), !dbg !734
  ret void, !dbg !737
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !738 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !744, metadata !DIExpression()), !dbg !745
  call void @llvm.dbg.declare(metadata i8** %3, metadata !746, metadata !DIExpression()), !dbg !747
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !748
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !749
  %6 = load i8*, i8** %5, align 8, !dbg !749
  %7 = call i8* asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !750, !srcloc !751
  store i8* %7, i8** %3, align 8, !dbg !750
  %8 = load i8*, i8** %3, align 8, !dbg !752
  ret i8* %8, !dbg !753
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vmem_get_alloc_count() #0 !dbg !754 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !757, metadata !DIExpression()), !dbg !758
  %2 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef @_g_vmem_alloc_count), !dbg !759
  store i64 %2, i64* %1, align 8, !dbg !758
  br label %3, !dbg !760

3:                                                ; preds = %0
  br label %4, !dbg !761

4:                                                ; preds = %3
  %5 = load i64, i64* %1, align 8, !dbg !763
  br label %6, !dbg !763

6:                                                ; preds = %4
  br label %7, !dbg !765

7:                                                ; preds = %6
  br label %8, !dbg !763

8:                                                ; preds = %7
  br label %9, !dbg !761

9:                                                ; preds = %8
  %10 = load i64, i64* %1, align 8, !dbg !767
  ret i64 %10, !dbg !768
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vmem_get_free_count() #0 !dbg !769 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !770, metadata !DIExpression()), !dbg !771
  %2 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef @_g_vmem_free_count), !dbg !772
  store i64 %2, i64* %1, align 8, !dbg !771
  br label %3, !dbg !773

3:                                                ; preds = %0
  br label %4, !dbg !774

4:                                                ; preds = %3
  %5 = load i64, i64* %1, align 8, !dbg !776
  br label %6, !dbg !776

6:                                                ; preds = %4
  br label %7, !dbg !778

7:                                                ; preds = %6
  br label %8, !dbg !776

8:                                                ; preds = %7
  br label %9, !dbg !774

9:                                                ; preds = %8
  %10 = load i64, i64* %1, align 8, !dbg !780
  ret i64 %10, !dbg !781
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !782 {
  %2 = alloca %struct.vatomic64_s*, align 8
  %3 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !787, metadata !DIExpression()), !dbg !788
  call void @llvm.dbg.declare(metadata i64* %3, metadata !789, metadata !DIExpression()), !dbg !790
  %4 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !791
  %5 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %4, i32 0, i32 0, !dbg !792
  %6 = load i64, i64* %5, align 8, !dbg !792
  %7 = call i64 asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i64 %6) #6, !dbg !793, !srcloc !794
  store i64 %7, i64* %3, align 8, !dbg !793
  %8 = load i64, i64* %3, align 8, !dbg !795
  ret i64 %8, !dbg !796
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_init() #0 !dbg !797 {
  call void @locked_trace_init(%struct.locked_trace_s* noundef @global_trace, i64 noundef 100), !dbg !798
  ret void, !dbg !799
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_init(%struct.vqueue_ub_s* noundef %0) #0 !dbg !800 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !803, metadata !DIExpression()), !dbg !804
  %3 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !805
  %4 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %3, i32 0, i32 4, !dbg !806
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !807
  %6 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %5, i32 0, i32 2, !dbg !808
  store %struct.vqueue_ub_node_s* %4, %struct.vqueue_ub_node_s** %6, align 8, !dbg !809
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !810
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 4, !dbg !811
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !812
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 3, !dbg !813
  store %struct.vqueue_ub_node_s* %8, %struct.vqueue_ub_node_s** %10, align 8, !dbg !814
  %11 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !815
  %12 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %11, i32 0, i32 4, !dbg !816
  call void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %12, i8* noundef null), !dbg !817
  %13 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !818
  %14 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %13, i32 0, i32 0, !dbg !819
  call void @queue_lock_init(%union.pthread_mutex_t* noundef %14), !dbg !820
  %15 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !821
  %16 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %15, i32 0, i32 1, !dbg !822
  call void @queue_lock_init(%union.pthread_mutex_t* noundef %16), !dbg !823
  ret void, !dbg !824
}

; Function Attrs: noinline nounwind uwtable
define internal void @locked_trace_init(%struct.locked_trace_s* noundef %0, i64 noundef %1) #0 !dbg !825 {
  %3 = alloca %struct.locked_trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.locked_trace_s* %0, %struct.locked_trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.locked_trace_s** %3, metadata !829, metadata !DIExpression()), !dbg !830
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !831, metadata !DIExpression()), !dbg !832
  %5 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !833
  %6 = icmp ne %struct.locked_trace_s* %5, null, !dbg !833
  br i1 %6, label %7, label %8, !dbg !836

7:                                                ; preds = %2
  br label %9, !dbg !836

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([64 x i8], [64 x i8]* @.str.12, i64 0, i64 0), i32 noundef 16, i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @__PRETTY_FUNCTION__.locked_trace_init, i64 0, i64 0)) #5, !dbg !833
  unreachable, !dbg !833

9:                                                ; preds = %7
  %10 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !837
  %11 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %10, i32 0, i32 1, !dbg !838
  %12 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %11, %union.pthread_mutexattr_t* noundef null) #6, !dbg !839
  %13 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !840
  %14 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %13, i32 0, i32 0, !dbg !841
  %15 = load i64, i64* %4, align 8, !dbg !842
  call void @trace_init(%struct.trace_s* noundef %14, i64 noundef %15), !dbg !843
  ret void, !dbg !844
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @trace_init(%struct.trace_s* noundef %0, i64 noundef %1) #0 !dbg !845 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !849, metadata !DIExpression()), !dbg !850
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !851, metadata !DIExpression()), !dbg !852
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !853
  %6 = icmp ne %struct.trace_s* %5, null, !dbg !853
  br i1 %6, label %7, label %8, !dbg !856

7:                                                ; preds = %2
  br label %9, !dbg !856

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 30, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !853
  unreachable, !dbg !853

9:                                                ; preds = %7
  %10 = load i64, i64* %4, align 8, !dbg !857
  %11 = mul i64 %10, 16, !dbg !858
  %12 = call noalias i8* @malloc(i64 noundef %11) #6, !dbg !859
  %13 = bitcast i8* %12 to %struct.trace_unit_s*, !dbg !859
  %14 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !860
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 0, !dbg !861
  store %struct.trace_unit_s* %13, %struct.trace_unit_s** %15, align 8, !dbg !862
  %16 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !863
  %17 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %16, i32 0, i32 0, !dbg !865
  %18 = load %struct.trace_unit_s*, %struct.trace_unit_s** %17, align 8, !dbg !865
  %19 = icmp ne %struct.trace_unit_s* %18, null, !dbg !863
  br i1 %19, label %20, label %28, !dbg !866

20:                                               ; preds = %9
  %21 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !867
  %22 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %21, i32 0, i32 1, !dbg !869
  store i64 0, i64* %22, align 8, !dbg !870
  %23 = load i64, i64* %4, align 8, !dbg !871
  %24 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !872
  %25 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %24, i32 0, i32 2, !dbg !873
  store i64 %23, i64* %25, align 8, !dbg !874
  %26 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !875
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 3, !dbg !876
  store i8 1, i8* %27, align 8, !dbg !877
  br label %35, !dbg !878

28:                                               ; preds = %9
  %29 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !879
  %30 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %29, i32 0, i32 1, !dbg !881
  store i64 0, i64* %30, align 8, !dbg !882
  %31 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !883
  %32 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %31, i32 0, i32 2, !dbg !884
  store i64 0, i64* %32, align 8, !dbg !885
  %33 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !886
  %34 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %33, i32 0, i32 3, !dbg !887
  store i8 0, i8* %34, align 8, !dbg !888
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.14, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 40, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !889
  unreachable, !dbg !889

35:                                               ; preds = %20
  ret void, !dbg !892
}

; Function Attrs: noinline nounwind uwtable
define internal void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !893 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !894, metadata !DIExpression()), !dbg !895
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !896, metadata !DIExpression()), !dbg !897
  %5 = load i8*, i8** %4, align 8, !dbg !898
  %6 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !899
  %7 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %6, i32 0, i32 0, !dbg !900
  store i8* %5, i8** %7, align 8, !dbg !901
  %8 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !902
  %9 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %8, i32 0, i32 1, !dbg !903
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %9, i8* noundef null), !dbg !904
  ret void, !dbg !905
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_init(%union.pthread_mutex_t* noundef %0) #0 !dbg !906 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !910, metadata !DIExpression()), !dbg !911
  %3 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !911
  %4 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %3, %union.pthread_mutexattr_t* noundef null) #6, !dbg !911
  ret void, !dbg !911
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !912 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !916, metadata !DIExpression()), !dbg !917
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !918, metadata !DIExpression()), !dbg !919
  %5 = load i8*, i8** %4, align 8, !dbg !920
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !921
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !922
  %8 = load i8*, i8** %7, align 8, !dbg !922
  call void asm sideeffect "str ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !923, !srcloc !924
  ret void, !dbg !925
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_reg(i64 noundef %0) #0 !dbg !926 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !927, metadata !DIExpression()), !dbg !928
  br label %3, !dbg !929

3:                                                ; preds = %1
  br label %4, !dbg !930

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !932
  br label %6, !dbg !932

6:                                                ; preds = %4
  br label %7, !dbg !934

7:                                                ; preds = %6
  br label %8, !dbg !932

8:                                                ; preds = %7
  br label %9, !dbg !930

9:                                                ; preds = %8
  ret void, !dbg !936
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_dereg(i64 noundef %0) #0 !dbg !937 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !938, metadata !DIExpression()), !dbg !939
  br label %3, !dbg !940

3:                                                ; preds = %1
  br label %4, !dbg !941

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !943
  br label %6, !dbg !943

6:                                                ; preds = %4
  br label %7, !dbg !945

7:                                                ; preds = %6
  br label %8, !dbg !943

8:                                                ; preds = %7
  br label %9, !dbg !941

9:                                                ; preds = %8
  ret void, !dbg !947
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !948 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  %9 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !951, metadata !DIExpression()), !dbg !952
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !953, metadata !DIExpression()), !dbg !954
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !955, metadata !DIExpression()), !dbg !956
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !957, metadata !DIExpression()), !dbg !958
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !958
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !959, metadata !DIExpression()), !dbg !960
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !960
  call void @llvm.dbg.declare(metadata i8** %9, metadata !961, metadata !DIExpression()), !dbg !962
  store i8* null, i8** %9, align 8, !dbg !962
  %10 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !963
  %11 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %10, i32 0, i32 1, !dbg !964
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %11), !dbg !965
  %12 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !966
  %13 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %12, i32 0, i32 2, !dbg !967
  %14 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %13, align 8, !dbg !967
  store %struct.vqueue_ub_node_s* %14, %struct.vqueue_ub_node_s** %8, align 8, !dbg !968
  %15 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !969
  %16 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %15, i32 0, i32 1, !dbg !970
  %17 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %16), !dbg !971
  %18 = bitcast i8* %17 to %struct.vqueue_ub_node_s*, !dbg !972
  store %struct.vqueue_ub_node_s* %18, %struct.vqueue_ub_node_s** %7, align 8, !dbg !973
  %19 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !974
  %20 = icmp ne %struct.vqueue_ub_node_s* %19, null, !dbg !974
  br i1 %20, label %21, label %37, !dbg !976

21:                                               ; preds = %3
  %22 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !977
  %23 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %22, i32 0, i32 0, !dbg !979
  %24 = load i8*, i8** %23, align 8, !dbg !979
  store i8* %24, i8** %9, align 8, !dbg !980
  %25 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !981
  %26 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !982
  %27 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %26, i32 0, i32 2, !dbg !983
  store %struct.vqueue_ub_node_s* %25, %struct.vqueue_ub_node_s** %27, align 8, !dbg !984
  %28 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !985
  %29 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !987
  %30 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %29, i32 0, i32 4, !dbg !988
  %31 = icmp ne %struct.vqueue_ub_node_s* %28, %30, !dbg !989
  br i1 %31, label %32, label %36, !dbg !990

32:                                               ; preds = %21
  %33 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !991
  %34 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !993
  %35 = load i8*, i8** %6, align 8, !dbg !994
  call void %33(%struct.vqueue_ub_node_s* noundef %34, i8* noundef %35), !dbg !991
  br label %36, !dbg !995

36:                                               ; preds = %32, %21
  br label %37, !dbg !996

37:                                               ; preds = %36, %3
  %38 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !997
  %39 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %38, i32 0, i32 1, !dbg !998
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %39), !dbg !999
  %40 = load i8*, i8** %9, align 8, !dbg !1000
  ret i8* %40, !dbg !1001
}

; Function Attrs: noinline nounwind uwtable
define internal void @_queue_destroy(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !1002 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1005, metadata !DIExpression()), !dbg !1006
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1007, metadata !DIExpression()), !dbg !1008
  %5 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1009
  %6 = bitcast %struct.vqueue_ub_node_s* %5 to i8*, !dbg !1009
  call void @vmem_free(i8* noundef %6), !dbg !1010
  br label %7, !dbg !1011

7:                                                ; preds = %2
  br label %8, !dbg !1012

8:                                                ; preds = %7
  %9 = load i8*, i8** %4, align 8, !dbg !1014
  br label %10, !dbg !1014

10:                                               ; preds = %8
  br label %11, !dbg !1016

11:                                               ; preds = %10
  br label %12, !dbg !1014

12:                                               ; preds = %11
  br label %13, !dbg !1012

13:                                               ; preds = %12
  ret void, !dbg !1018
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_destroy(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !1019 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !1020, metadata !DIExpression()), !dbg !1021
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !1022, metadata !DIExpression()), !dbg !1023
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !1024, metadata !DIExpression()), !dbg !1025
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !1026, metadata !DIExpression()), !dbg !1027
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1027
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !1028, metadata !DIExpression()), !dbg !1029
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1029
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1030
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 2, !dbg !1031
  %11 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !1031
  store %struct.vqueue_ub_node_s* %11, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1032
  br label %12, !dbg !1033

12:                                               ; preds = %28, %3
  %13 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1034
  %14 = icmp ne %struct.vqueue_ub_node_s* %13, null, !dbg !1033
  br i1 %14, label %15, label %30, !dbg !1033

15:                                               ; preds = %12
  %16 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1035
  %17 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %16, i32 0, i32 1, !dbg !1037
  %18 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %17), !dbg !1038
  %19 = bitcast i8* %18 to %struct.vqueue_ub_node_s*, !dbg !1039
  store %struct.vqueue_ub_node_s* %19, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1040
  %20 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1041
  %21 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1043
  %22 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %21, i32 0, i32 4, !dbg !1044
  %23 = icmp ne %struct.vqueue_ub_node_s* %20, %22, !dbg !1045
  br i1 %23, label %24, label %28, !dbg !1046

24:                                               ; preds = %15
  %25 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !1047
  %26 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1049
  %27 = load i8*, i8** %6, align 8, !dbg !1050
  call void %25(%struct.vqueue_ub_node_s* noundef %26, i8* noundef %27), !dbg !1047
  br label %28, !dbg !1051

28:                                               ; preds = %24, %15
  %29 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1052
  store %struct.vqueue_ub_node_s* %29, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1053
  br label %12, !dbg !1033, !llvm.loop !1054

30:                                               ; preds = %12
  ret void, !dbg !1056
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_destroy() #0 !dbg !1057 {
  call void @locked_trace_destroy(%struct.locked_trace_s* noundef @global_trace, i1 (%struct.trace_unit_s*)* noundef @_ismr_none_destroy_all_cb), !dbg !1058
  ret void, !dbg !1059
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_acquire(%union.pthread_mutex_t* noundef %0) #0 !dbg !1060 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !1061, metadata !DIExpression()), !dbg !1062
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1063, metadata !DIExpression()), !dbg !1062
  %4 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !1062
  %5 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef %4) #6, !dbg !1062
  store i32 %5, i32* %3, align 4, !dbg !1062
  %6 = load i32, i32* %3, align 4, !dbg !1064
  %7 = icmp eq i32 %6, 0, !dbg !1064
  br i1 %7, label %8, label %9, !dbg !1067

8:                                                ; preds = %1
  br label %10, !dbg !1067

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.16, i64 0, i64 0), i8* noundef getelementptr inbounds ([101 x i8], [101 x i8]* @.str.17, i64 0, i64 0), i32 noundef 32, i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.queue_lock_acquire, i64 0, i64 0)) #5, !dbg !1064
  unreachable, !dbg !1064

10:                                               ; preds = %8
  ret void, !dbg !1062
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %0) #0 !dbg !1068 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !1069, metadata !DIExpression()), !dbg !1070
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1071, metadata !DIExpression()), !dbg !1072
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !1073
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !1074
  %6 = load i8*, i8** %5, align 8, !dbg !1074
  %7 = call i8* asm sideeffect "ldar ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !1075, !srcloc !1076
  store i8* %7, i8** %3, align 8, !dbg !1075
  %8 = load i8*, i8** %3, align 8, !dbg !1077
  ret i8* %8, !dbg !1078
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_release(%union.pthread_mutex_t* noundef %0) #0 !dbg !1079 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !1080, metadata !DIExpression()), !dbg !1081
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1082, metadata !DIExpression()), !dbg !1081
  %4 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !1081
  %5 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef %4) #6, !dbg !1081
  store i32 %5, i32* %3, align 4, !dbg !1081
  %6 = load i32, i32* %3, align 4, !dbg !1083
  %7 = icmp eq i32 %6, 0, !dbg !1083
  br i1 %7, label %8, label %9, !dbg !1086

8:                                                ; preds = %1
  br label %10, !dbg !1086

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.16, i64 0, i64 0), i8* noundef getelementptr inbounds ([101 x i8], [101 x i8]* @.str.17, i64 0, i64 0), i32 noundef 32, i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.queue_lock_release, i64 0, i64 0)) #5, !dbg !1083
  unreachable, !dbg !1083

10:                                               ; preds = %8
  ret void, !dbg !1081
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @vmem_free(i8* noundef %0) #0 !dbg !1087 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !1088, metadata !DIExpression()), !dbg !1089
  %3 = load i8*, i8** %2, align 8, !dbg !1090
  call void @free(i8* noundef %3) #6, !dbg !1091
  %4 = load i8*, i8** %2, align 8, !dbg !1092
  %5 = icmp ne i8* %4, null, !dbg !1092
  br i1 %5, label %6, label %7, !dbg !1094

6:                                                ; preds = %1
  call void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef @_g_vmem_free_count), !dbg !1095
  br label %7, !dbg !1097

7:                                                ; preds = %6, %1
  ret void, !dbg !1098
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !1099 {
  %2 = alloca %struct.vatomic64_s*, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !1104, metadata !DIExpression()), !dbg !1105
  %3 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !1106
  %4 = call i64 @vatomic64_get_inc_rlx(%struct.vatomic64_s* noundef %3), !dbg !1107
  ret void, !dbg !1108
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_get_inc_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !1109 {
  %2 = alloca %struct.vatomic64_s*, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !1112, metadata !DIExpression()), !dbg !1113
  %3 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !1114
  %4 = call i64 @vatomic64_get_add_rlx(%struct.vatomic64_s* noundef %3, i64 noundef 1), !dbg !1115
  ret i64 %4, !dbg !1116
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_get_add_rlx(%struct.vatomic64_s* noundef %0, i64 noundef %1) #0 !dbg !1117 {
  %3 = alloca %struct.vatomic64_s*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %3, metadata !1121, metadata !DIExpression()), !dbg !1122
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1123, metadata !DIExpression()), !dbg !1124
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1125, metadata !DIExpression()), !dbg !1126
  call void @llvm.dbg.declare(metadata i32* %6, metadata !1127, metadata !DIExpression()), !dbg !1131
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1132, metadata !DIExpression()), !dbg !1133
  %8 = load i64, i64* %4, align 8, !dbg !1134
  %9 = load %struct.vatomic64_s*, %struct.vatomic64_s** %3, align 8, !dbg !1135
  %10 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %9, i32 0, i32 0, !dbg !1136
  %11 = load i64, i64* %10, align 8, !dbg !1136
  %12 = call { i64, i64, i32, i64 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:x}, $4\0Aadd ${1:x}, ${0:x}, ${3:x}\0Astxr ${2:w}, ${1:x}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i64 %11, i64 %8) #6, !dbg !1134, !srcloc !1137
  %13 = extractvalue { i64, i64, i32, i64 } %12, 0, !dbg !1134
  %14 = extractvalue { i64, i64, i32, i64 } %12, 1, !dbg !1134
  %15 = extractvalue { i64, i64, i32, i64 } %12, 2, !dbg !1134
  %16 = extractvalue { i64, i64, i32, i64 } %12, 3, !dbg !1134
  store i64 %13, i64* %5, align 8, !dbg !1134
  store i64 %14, i64* %7, align 8, !dbg !1134
  store i32 %15, i32* %6, align 4, !dbg !1134
  store i64 %16, i64* %4, align 8, !dbg !1134
  %17 = load i64, i64* %5, align 8, !dbg !1138
  ret i64 %17, !dbg !1139
}

; Function Attrs: noinline nounwind uwtable
define internal void @locked_trace_destroy(%struct.locked_trace_s* noundef %0, i1 (%struct.trace_unit_s*)* noundef %1) #0 !dbg !1140 {
  %3 = alloca %struct.locked_trace_s*, align 8
  %4 = alloca i1 (%struct.trace_unit_s*)*, align 8
  store %struct.locked_trace_s* %0, %struct.locked_trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.locked_trace_s** %3, metadata !1147, metadata !DIExpression()), !dbg !1148
  store i1 (%struct.trace_unit_s*)* %1, i1 (%struct.trace_unit_s*)** %4, align 8
  call void @llvm.dbg.declare(metadata i1 (%struct.trace_unit_s*)** %4, metadata !1149, metadata !DIExpression()), !dbg !1150
  %5 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1151
  %6 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %5, i32 0, i32 0, !dbg !1152
  %7 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %4, align 8, !dbg !1153
  %8 = call zeroext i1 @trace_verify(%struct.trace_s* noundef %6, i1 (%struct.trace_unit_s*)* noundef %7), !dbg !1154
  %9 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1155
  %10 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %9, i32 0, i32 0, !dbg !1156
  call void @trace_destroy(%struct.trace_s* noundef %10), !dbg !1157
  %11 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1158
  %12 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %11, i32 0, i32 1, !dbg !1159
  %13 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef %12) #6, !dbg !1160
  ret void, !dbg !1161
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @_ismr_none_destroy_all_cb(%struct.trace_unit_s* noundef %0) #0 !dbg !1162 {
  %2 = alloca %struct.trace_unit_s*, align 8
  %3 = alloca %struct.smr_none_retire_info_t*, align 8
  store %struct.trace_unit_s* %0, %struct.trace_unit_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %2, metadata !1163, metadata !DIExpression()), !dbg !1164
  %4 = load %struct.trace_unit_s*, %struct.trace_unit_s** %2, align 8, !dbg !1165
  %5 = icmp ne %struct.trace_unit_s* %4, null, !dbg !1165
  br i1 %5, label %6, label %7, !dbg !1168

6:                                                ; preds = %1
  br label %8, !dbg !1168

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.20, i64 0, i64 0), i8* noundef getelementptr inbounds ([70 x i8], [70 x i8]* @.str.21, i64 0, i64 0), i32 noundef 27, i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @__PRETTY_FUNCTION__._ismr_none_destroy_all_cb, i64 0, i64 0)) #5, !dbg !1165
  unreachable, !dbg !1165

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata %struct.smr_none_retire_info_t** %3, metadata !1169, metadata !DIExpression()), !dbg !1170
  %9 = load %struct.trace_unit_s*, %struct.trace_unit_s** %2, align 8, !dbg !1171
  %10 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %9, i32 0, i32 0, !dbg !1172
  %11 = load i64, i64* %10, align 8, !dbg !1172
  %12 = inttoptr i64 %11 to %struct.smr_none_retire_info_t*, !dbg !1173
  store %struct.smr_none_retire_info_t* %12, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1170
  %13 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1174
  %14 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %13, i32 0, i32 1, !dbg !1175
  %15 = load void (%struct.smr_node_s*, i8*)*, void (%struct.smr_node_s*, i8*)** %14, align 8, !dbg !1175
  %16 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1176
  %17 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %16, i32 0, i32 0, !dbg !1177
  %18 = load %struct.smr_node_s*, %struct.smr_node_s** %17, align 8, !dbg !1177
  %19 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1178
  %20 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %19, i32 0, i32 2, !dbg !1179
  %21 = load i8*, i8** %20, align 8, !dbg !1179
  call void %15(%struct.smr_node_s* noundef %18, i8* noundef %21), !dbg !1174
  %22 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1180
  %23 = bitcast %struct.smr_none_retire_info_t* %22 to i8*, !dbg !1180
  call void @free(i8* noundef %23) #6, !dbg !1181
  ret i1 true, !dbg !1182
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @trace_verify(%struct.trace_s* noundef %0, i1 (%struct.trace_unit_s*)* noundef %1) #0 !dbg !1183 {
  %3 = alloca i1, align 1
  %4 = alloca %struct.trace_s*, align 8
  %5 = alloca i1 (%struct.trace_unit_s*)*, align 8
  %6 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !1186, metadata !DIExpression()), !dbg !1187
  store i1 (%struct.trace_unit_s*)* %1, i1 (%struct.trace_unit_s*)** %5, align 8
  call void @llvm.dbg.declare(metadata i1 (%struct.trace_unit_s*)** %5, metadata !1188, metadata !DIExpression()), !dbg !1189
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1190, metadata !DIExpression()), !dbg !1191
  store i64 0, i64* %6, align 8, !dbg !1191
  %7 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1192
  %8 = icmp ne %struct.trace_s* %7, null, !dbg !1192
  br i1 %8, label %9, label %10, !dbg !1195

9:                                                ; preds = %2
  br label %11, !dbg !1195

10:                                               ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 214, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #5, !dbg !1192
  unreachable, !dbg !1192

11:                                               ; preds = %9
  %12 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1196
  %13 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %12, i32 0, i32 3, !dbg !1196
  %14 = load i8, i8* %13, align 8, !dbg !1196
  %15 = trunc i8 %14 to i1, !dbg !1196
  br i1 %15, label %16, label %17, !dbg !1199

16:                                               ; preds = %11
  br label %18, !dbg !1199

17:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 215, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #5, !dbg !1196
  unreachable, !dbg !1196

18:                                               ; preds = %16
  %19 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %5, align 8, !dbg !1200
  %20 = icmp ne i1 (%struct.trace_unit_s*)* %19, null, !dbg !1200
  br i1 %20, label %21, label %22, !dbg !1203

21:                                               ; preds = %18
  br label %23, !dbg !1203

22:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 216, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #5, !dbg !1200
  unreachable, !dbg !1200

23:                                               ; preds = %21
  store i64 0, i64* %6, align 8, !dbg !1204
  br label %24, !dbg !1206

24:                                               ; preds = %42, %23
  %25 = load i64, i64* %6, align 8, !dbg !1207
  %26 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1209
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 1, !dbg !1210
  %28 = load i64, i64* %27, align 8, !dbg !1210
  %29 = icmp ult i64 %25, %28, !dbg !1211
  br i1 %29, label %30, label %45, !dbg !1212

30:                                               ; preds = %24
  %31 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %5, align 8, !dbg !1213
  %32 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1216
  %33 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %32, i32 0, i32 0, !dbg !1217
  %34 = load %struct.trace_unit_s*, %struct.trace_unit_s** %33, align 8, !dbg !1217
  %35 = load i64, i64* %6, align 8, !dbg !1218
  %36 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %34, i64 %35, !dbg !1216
  %37 = call zeroext i1 %31(%struct.trace_unit_s* noundef %36), !dbg !1213
  %38 = zext i1 %37 to i32, !dbg !1213
  %39 = icmp eq i32 %38, 0, !dbg !1219
  br i1 %39, label %40, label %41, !dbg !1220

40:                                               ; preds = %30
  store i1 false, i1* %3, align 1, !dbg !1221
  br label %46, !dbg !1221

41:                                               ; preds = %30
  br label %42, !dbg !1223

42:                                               ; preds = %41
  %43 = load i64, i64* %6, align 8, !dbg !1224
  %44 = add i64 %43, 1, !dbg !1224
  store i64 %44, i64* %6, align 8, !dbg !1224
  br label %24, !dbg !1225, !llvm.loop !1226

45:                                               ; preds = %24
  store i1 true, i1* %3, align 1, !dbg !1228
  br label %46, !dbg !1228

46:                                               ; preds = %45, %40
  %47 = load i1, i1* %3, align 1, !dbg !1229
  ret i1 %47, !dbg !1229
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_destroy(%struct.trace_s* noundef %0) #0 !dbg !1230 {
  %2 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %2, metadata !1233, metadata !DIExpression()), !dbg !1234
  %3 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1235
  %4 = icmp ne %struct.trace_s* %3, null, !dbg !1235
  br i1 %4, label %5, label %6, !dbg !1238

5:                                                ; preds = %1
  br label %7, !dbg !1238

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 99, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !1235
  unreachable, !dbg !1235

7:                                                ; preds = %5
  %8 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1239
  %9 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %8, i32 0, i32 3, !dbg !1239
  %10 = load i8, i8* %9, align 8, !dbg !1239
  %11 = trunc i8 %10 to i1, !dbg !1239
  br i1 %11, label %12, label %13, !dbg !1242

12:                                               ; preds = %7
  br label %14, !dbg !1242

13:                                               ; preds = %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !1239
  unreachable, !dbg !1239

14:                                               ; preds = %12
  %15 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1243
  %16 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %15, i32 0, i32 0, !dbg !1244
  %17 = load %struct.trace_unit_s*, %struct.trace_unit_s** %16, align 8, !dbg !1244
  %18 = bitcast %struct.trace_unit_s* %17 to i8*, !dbg !1243
  call void @free(i8* noundef %18) #6, !dbg !1245
  %19 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1246
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 3, !dbg !1247
  store i8 0, i8* %20, align 8, !dbg !1248
  ret void, !dbg !1249
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @vmem_malloc(i64 noundef %0) #0 !dbg !1250 {
  %2 = alloca i64, align 8
  %3 = alloca i8*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1253, metadata !DIExpression()), !dbg !1254
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1255, metadata !DIExpression()), !dbg !1256
  %4 = load i64, i64* %2, align 8, !dbg !1257
  %5 = call noalias i8* @malloc(i64 noundef %4) #6, !dbg !1258
  store i8* %5, i8** %3, align 8, !dbg !1256
  %6 = load i8*, i8** %3, align 8, !dbg !1259
  %7 = icmp ne i8* %6, null, !dbg !1259
  br i1 %7, label %8, label %9, !dbg !1261

8:                                                ; preds = %1
  call void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef @_g_vmem_alloc_count), !dbg !1262
  br label %10, !dbg !1264

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.14, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.22, i64 0, i64 0), i32 noundef 28, i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @__PRETTY_FUNCTION__.vmem_malloc, i64 0, i64 0)) #5, !dbg !1265
  unreachable, !dbg !1265

10:                                               ; preds = %8
  %11 = load i8*, i8** %3, align 8, !dbg !1269
  ret i8* %11, !dbg !1270
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_enter(i64 noundef %0) #0 !dbg !1271 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1272, metadata !DIExpression()), !dbg !1273
  br label %3, !dbg !1274

3:                                                ; preds = %1
  br label %4, !dbg !1275

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1277
  br label %6, !dbg !1277

6:                                                ; preds = %4
  br label %7, !dbg !1279

7:                                                ; preds = %6
  br label %8, !dbg !1277

8:                                                ; preds = %7
  br label %9, !dbg !1275

9:                                                ; preds = %8
  ret void, !dbg !1281
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_enq(%struct.vqueue_ub_s* noundef %0, %struct.vqueue_ub_node_s* noundef %1, i8* noundef %2) #0 !dbg !1282 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca %struct.vqueue_ub_node_s*, align 8
  %6 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !1285, metadata !DIExpression()), !dbg !1286
  store %struct.vqueue_ub_node_s* %1, %struct.vqueue_ub_node_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %5, metadata !1287, metadata !DIExpression()), !dbg !1288
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !1289, metadata !DIExpression()), !dbg !1290
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1291
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 0, !dbg !1292
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %8), !dbg !1293
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1294
  %10 = load i8*, i8** %6, align 8, !dbg !1295
  call void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %9, i8* noundef %10), !dbg !1296
  %11 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1297
  %12 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %11, i32 0, i32 3, !dbg !1298
  %13 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %12, align 8, !dbg !1298
  %14 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %13, i32 0, i32 1, !dbg !1299
  %15 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1300
  %16 = bitcast %struct.vqueue_ub_node_s* %15 to i8*, !dbg !1300
  call void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %14, i8* noundef %16), !dbg !1301
  %17 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1302
  %18 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1303
  %19 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %18, i32 0, i32 3, !dbg !1304
  store %struct.vqueue_ub_node_s* %17, %struct.vqueue_ub_node_s** %19, align 8, !dbg !1305
  %20 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1306
  %21 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %20, i32 0, i32 0, !dbg !1307
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %21), !dbg !1308
  ret void, !dbg !1309
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_exit(i64 noundef %0) #0 !dbg !1310 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1311, metadata !DIExpression()), !dbg !1312
  br label %3, !dbg !1313

3:                                                ; preds = %1
  br label %4, !dbg !1314

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1316
  br label %6, !dbg !1316

6:                                                ; preds = %4
  br label %7, !dbg !1318

7:                                                ; preds = %6
  br label %8, !dbg !1316

8:                                                ; preds = %7
  br label %9, !dbg !1314

9:                                                ; preds = %8
  ret void, !dbg !1320
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1321 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1322, metadata !DIExpression()), !dbg !1323
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1324, metadata !DIExpression()), !dbg !1325
  %5 = load i8*, i8** %4, align 8, !dbg !1326
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !1327
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !1328
  %8 = load i8*, i8** %7, align 8, !dbg !1328
  call void asm sideeffect "stlr ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !1329, !srcloc !1330
  ret void, !dbg !1331
}

; Function Attrs: noinline nounwind uwtable
define internal void @_queue_retire(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !1332 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1333, metadata !DIExpression()), !dbg !1334
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1335, metadata !DIExpression()), !dbg !1336
  %5 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1337
  %6 = bitcast %struct.vqueue_ub_node_s* %5 to i8*, !dbg !1337
  call void @vmem_free(i8* noundef %6), !dbg !1338
  br label %7, !dbg !1339

7:                                                ; preds = %2
  br label %8, !dbg !1340

8:                                                ; preds = %7
  %9 = load i8*, i8** %4, align 8, !dbg !1342
  br label %10, !dbg !1342

10:                                               ; preds = %8
  br label %11, !dbg !1344

11:                                               ; preds = %10
  br label %12, !dbg !1342

12:                                               ; preds = %11
  br label %13, !dbg !1340

13:                                               ; preds = %12
  ret void, !dbg !1346
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @vqueue_ub_empty(%struct.vqueue_ub_s* noundef %0) #0 !dbg !1347 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !1350, metadata !DIExpression()), !dbg !1351
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1352, metadata !DIExpression()), !dbg !1353
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1353
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %4, metadata !1354, metadata !DIExpression()), !dbg !1355
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1355
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1356
  %6 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %5, i32 0, i32 1, !dbg !1357
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %6), !dbg !1358
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1359
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 2, !dbg !1360
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1360
  store %struct.vqueue_ub_node_s* %9, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1361
  %10 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1362
  %11 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %10, i32 0, i32 1, !dbg !1363
  %12 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %11), !dbg !1364
  %13 = bitcast i8* %12 to %struct.vqueue_ub_node_s*, !dbg !1365
  store %struct.vqueue_ub_node_s* %13, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1366
  %14 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1367
  %15 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %14, i32 0, i32 1, !dbg !1368
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %15), !dbg !1369
  %16 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1370
  %17 = icmp eq %struct.vqueue_ub_node_s* %16, null, !dbg !1371
  ret i1 %17, !dbg !1372
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
!76 = !{!0, !77, !89, !92, !102, !154, !166}
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
!94 = !DIFile(filename: "datastruct/queue/unbounded/verify/test_case_3.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4db401663e0a433af01e00a8218a7270")
!95 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !96, size: 64)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "data_t", file: !44, line: 49, baseType: !97)
!97 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "data_s", file: !44, line: 46, size: 128, elements: !98)
!98 = !{!99, !100}
!99 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !97, file: !44, line: 47, baseType: !84, size: 64)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "lbl", scope: !97, file: !44, line: 48, baseType: !101, size: 8, offset: 64)
!101 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!102 = !DIGlobalVariableExpression(var: !103, expr: !DIExpression())
!103 = distinct !DIGlobalVariable(name: "global_trace", scope: !2, file: !50, line: 15, type: !104, isLocal: false, isDefinition: true)
!104 = !DIDerivedType(tag: DW_TAG_typedef, name: "locked_trace_t", file: !105, line: 11, baseType: !106)
!105 = !DIFile(filename: "utils/include/test/locked_trace.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "6b9b066c8ea09bc73550cef772f1c7ca")
!106 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "locked_trace_s", file: !105, line: 8, size: 576, elements: !107)
!107 = !{!108, !123}
!108 = !DIDerivedType(tag: DW_TAG_member, name: "trace", scope: !106, file: !105, line: 9, baseType: !109, size: 256)
!109 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_t", file: !110, line: 23, baseType: !111)
!110 = !DIFile(filename: "utils/include/test/trace_manager.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "ef0cfa2f64930baab6e03245b4188b52")
!111 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_s", file: !110, line: 18, size: 256, elements: !112)
!112 = !{!113, !120, !121, !122}
!113 = !DIDerivedType(tag: DW_TAG_member, name: "units", scope: !111, file: !110, line: 19, baseType: !114, size: 64)
!114 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !115, size: 64)
!115 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_unit_t", file: !110, line: 16, baseType: !116)
!116 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_unit_s", file: !110, line: 13, size: 128, elements: !117)
!117 = !{!118, !119}
!118 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !116, file: !110, line: 14, baseType: !10, size: 64)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !116, file: !110, line: 15, baseType: !5, size: 64, offset: 64)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !111, file: !110, line: 20, baseType: !5, size: 64, offset: 64)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "capacity", scope: !111, file: !110, line: 21, baseType: !5, size: 64, offset: 128)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "initialized", scope: !111, file: !110, line: 22, baseType: !24, size: 8, offset: 192)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !106, file: !105, line: 10, baseType: !124, size: 320, offset: 256)
!124 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !21, line: 72, baseType: !125)
!125 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !21, line: 67, size: 320, elements: !126)
!126 = !{!127, !148, !152}
!127 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !125, file: !21, line: 69, baseType: !128, size: 320)
!128 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !129, line: 22, size: 320, elements: !130)
!129 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "584baedd80e6041b81caae7f496091c0")
!130 = !{!131, !132, !134, !135, !136, !137, !139, !140}
!131 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !128, file: !129, line: 24, baseType: !66, size: 32)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !128, file: !129, line: 25, baseType: !133, size: 32, offset: 32)
!133 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !128, file: !129, line: 26, baseType: !66, size: 32, offset: 64)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !128, file: !129, line: 28, baseType: !133, size: 32, offset: 96)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !128, file: !129, line: 32, baseType: !66, size: 32, offset: 128)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !128, file: !129, line: 34, baseType: !138, size: 16, offset: 160)
!138 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !128, file: !129, line: 35, baseType: !138, size: 16, offset: 176)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !128, file: !129, line: 36, baseType: !141, size: 128, offset: 192)
!141 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !142, line: 55, baseType: !143)
!142 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "04c81e86d34dad9c99ad006d32e47a0d")
!143 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !142, line: 51, size: 128, elements: !144)
!144 = !{!145, !147}
!145 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !143, file: !142, line: 53, baseType: !146, size: 64)
!146 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !143, size: 64)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !143, file: !142, line: 54, baseType: !146, size: 64, offset: 64)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !125, file: !21, line: 70, baseType: !149, size: 320)
!149 = !DICompositeType(tag: DW_TAG_array_type, baseType: !101, size: 320, elements: !150)
!150 = !{!151}
!151 = !DISubrange(count: 40)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !125, file: !21, line: 71, baseType: !153, size: 64)
!153 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!154 = !DIGlobalVariableExpression(var: !155, expr: !DIExpression())
!155 = distinct !DIGlobalVariable(name: "g_queue", scope: !2, file: !91, line: 25, type: !156, isLocal: false, isDefinition: true)
!156 = !DIDerivedType(tag: DW_TAG_typedef, name: "queue_t", file: !44, line: 41, baseType: !157)
!157 = !DIDerivedType(tag: DW_TAG_typedef, name: "vqueue_ub_t", file: !33, line: 47, baseType: !158)
!158 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vqueue_ub_s", file: !33, line: 41, size: 896, elements: !159)
!159 = !{!160, !162, !163, !164, !165}
!160 = !DIDerivedType(tag: DW_TAG_member, name: "enq_l", scope: !158, file: !33, line: 42, baseType: !161, size: 320)
!161 = !DIDerivedType(tag: DW_TAG_typedef, name: "queue_lock_t", file: !33, line: 31, baseType: !124)
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
!179 = distinct !DISubprogram(name: "t1", scope: !94, file: !94, line: 7, type: !180, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!180 = !DISubroutineType(types: !181)
!181 = !{null, !5}
!182 = !{}
!183 = !DILocalVariable(name: "tid", arg: 1, scope: !179, file: !94, line: 7, type: !5)
!184 = !DILocation(line: 7, column: 12, scope: !179)
!185 = !DILocation(line: 9, column: 9, scope: !179)
!186 = !DILocation(line: 9, column: 5, scope: !179)
!187 = !DILocation(line: 10, column: 1, scope: !179)
!188 = distinct !DISubprogram(name: "enq", scope: !91, file: !91, line: 94, type: !189, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!189 = !DISubroutineType(types: !190)
!190 = !{null, !5, !84, !101}
!191 = !DILocalVariable(name: "tid", arg: 1, scope: !188, file: !91, line: 94, type: !5)
!192 = !DILocation(line: 94, column: 13, scope: !188)
!193 = !DILocalVariable(name: "k", arg: 2, scope: !188, file: !91, line: 94, type: !84)
!194 = !DILocation(line: 94, column: 28, scope: !188)
!195 = !DILocalVariable(name: "lbl", arg: 3, scope: !188, file: !91, line: 94, type: !101)
!196 = !DILocation(line: 94, column: 36, scope: !188)
!197 = !DILocation(line: 96, column: 15, scope: !188)
!198 = !DILocation(line: 96, column: 30, scope: !188)
!199 = !DILocation(line: 96, column: 33, scope: !188)
!200 = !DILocation(line: 96, column: 5, scope: !188)
!201 = !DILocation(line: 97, column: 1, scope: !188)
!202 = distinct !DISubprogram(name: "t2", scope: !94, file: !94, line: 18, type: !180, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!203 = !DILocalVariable(name: "tid", arg: 1, scope: !202, file: !94, line: 18, type: !5)
!204 = !DILocation(line: 18, column: 12, scope: !202)
!205 = !DILocation(line: 20, column: 17, scope: !202)
!206 = !DILocation(line: 20, column: 13, scope: !202)
!207 = !DILocation(line: 20, column: 11, scope: !202)
!208 = !DILocation(line: 21, column: 5, scope: !209)
!209 = distinct !DILexicalBlock(scope: !210, file: !94, line: 21, column: 5)
!210 = distinct !DILexicalBlock(scope: !202, file: !94, line: 21, column: 5)
!211 = !DILocation(line: 21, column: 5, scope: !210)
!212 = !DILocation(line: 23, column: 5, scope: !213)
!213 = distinct !DILexicalBlock(scope: !214, file: !94, line: 23, column: 5)
!214 = distinct !DILexicalBlock(scope: !202, file: !94, line: 23, column: 5)
!215 = !DILocation(line: 23, column: 5, scope: !214)
!216 = !DILocation(line: 24, column: 17, scope: !202)
!217 = !DILocation(line: 24, column: 5, scope: !202)
!218 = !DILocation(line: 25, column: 1, scope: !202)
!219 = distinct !DISubprogram(name: "deq", scope: !91, file: !91, line: 100, type: !220, scopeLine: 101, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!220 = !DISubroutineType(types: !221)
!221 = !{!95, !5}
!222 = !DILocalVariable(name: "tid", arg: 1, scope: !219, file: !91, line: 100, type: !5)
!223 = !DILocation(line: 100, column: 13, scope: !219)
!224 = !DILocation(line: 102, column: 22, scope: !219)
!225 = !DILocation(line: 102, column: 12, scope: !219)
!226 = !DILocation(line: 102, column: 5, scope: !219)
!227 = distinct !DISubprogram(name: "queue_clean", scope: !44, file: !44, line: 248, type: !180, scopeLine: 249, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!228 = !DILocalVariable(name: "tid", arg: 1, scope: !227, file: !44, line: 248, type: !5)
!229 = !DILocation(line: 248, column: 21, scope: !227)
!230 = !DILocation(line: 250, column: 18, scope: !227)
!231 = !DILocation(line: 250, column: 5, scope: !227)
!232 = !DILocation(line: 251, column: 1, scope: !227)
!233 = distinct !DISubprogram(name: "t3", scope: !94, file: !94, line: 31, type: !180, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!234 = !DILocalVariable(name: "tid", arg: 1, scope: !233, file: !94, line: 31, type: !5)
!235 = !DILocation(line: 31, column: 12, scope: !233)
!236 = !DILocation(line: 33, column: 9, scope: !233)
!237 = !DILocation(line: 33, column: 5, scope: !233)
!238 = !DILocation(line: 34, column: 1, scope: !233)
!239 = distinct !DISubprogram(name: "verify", scope: !94, file: !94, line: 36, type: !240, scopeLine: 37, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!240 = !DISubroutineType(types: !241)
!241 = !{null}
!242 = !DILocation(line: 38, column: 5, scope: !243)
!243 = distinct !DILexicalBlock(scope: !244, file: !94, line: 38, column: 5)
!244 = distinct !DILexicalBlock(scope: !239, file: !94, line: 38, column: 5)
!245 = !DILocation(line: 38, column: 5, scope: !244)
!246 = !DILocalVariable(name: "i", scope: !247, file: !94, line: 39, type: !5)
!247 = distinct !DILexicalBlock(scope: !239, file: !94, line: 39, column: 5)
!248 = !DILocation(line: 39, column: 18, scope: !247)
!249 = !DILocation(line: 39, column: 10, scope: !247)
!250 = !DILocation(line: 39, column: 25, scope: !251)
!251 = distinct !DILexicalBlock(scope: !247, file: !94, line: 39, column: 5)
!252 = !DILocation(line: 39, column: 29, scope: !251)
!253 = !DILocation(line: 39, column: 27, scope: !251)
!254 = !DILocation(line: 39, column: 5, scope: !247)
!255 = !DILocation(line: 40, column: 9, scope: !256)
!256 = distinct !DILexicalBlock(scope: !257, file: !94, line: 40, column: 9)
!257 = distinct !DILexicalBlock(scope: !258, file: !94, line: 40, column: 9)
!258 = distinct !DILexicalBlock(scope: !251, file: !94, line: 39, column: 41)
!259 = !DILocation(line: 40, column: 9, scope: !257)
!260 = !DILocation(line: 41, column: 5, scope: !258)
!261 = !DILocation(line: 39, column: 37, scope: !251)
!262 = !DILocation(line: 39, column: 5, scope: !251)
!263 = distinct !{!263, !254, !264, !265}
!264 = !DILocation(line: 41, column: 5, scope: !247)
!265 = !{!"llvm.loop.mustprogress"}
!266 = !DILocation(line: 42, column: 1, scope: !239)
!267 = distinct !DISubprogram(name: "main", scope: !91, file: !91, line: 50, type: !268, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!268 = !DISubroutineType(types: !269)
!269 = !{!66}
!270 = !DILocation(line: 52, column: 5, scope: !267)
!271 = !DILocation(line: 53, column: 5, scope: !267)
!272 = !DILocation(line: 55, column: 5, scope: !267)
!273 = !DILocation(line: 56, column: 5, scope: !267)
!274 = !DILocation(line: 57, column: 5, scope: !267)
!275 = !DILocation(line: 58, column: 5, scope: !276)
!276 = distinct !DILexicalBlock(scope: !277, file: !91, line: 58, column: 5)
!277 = distinct !DILexicalBlock(scope: !267, file: !91, line: 58, column: 5)
!278 = !DILocation(line: 58, column: 5, scope: !277)
!279 = !DILocation(line: 59, column: 5, scope: !267)
!280 = distinct !DISubprogram(name: "init", scope: !91, file: !91, line: 63, type: !240, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!281 = !DILocation(line: 65, column: 5, scope: !280)
!282 = !DILocation(line: 70, column: 5, scope: !280)
!283 = !DILocalVariable(name: "lbl", scope: !280, file: !91, line: 79, type: !101)
!284 = !DILocation(line: 79, column: 10, scope: !280)
!285 = !DILocalVariable(name: "i", scope: !286, file: !91, line: 80, type: !5)
!286 = distinct !DILexicalBlock(scope: !280, file: !91, line: 80, column: 5)
!287 = !DILocation(line: 80, column: 18, scope: !286)
!288 = !DILocation(line: 80, column: 10, scope: !286)
!289 = !DILocation(line: 80, column: 25, scope: !290)
!290 = distinct !DILexicalBlock(scope: !286, file: !91, line: 80, column: 5)
!291 = !DILocation(line: 80, column: 27, scope: !290)
!292 = !DILocation(line: 80, column: 5, scope: !286)
!293 = !DILocation(line: 81, column: 16, scope: !294)
!294 = distinct !DILexicalBlock(scope: !290, file: !91, line: 80, column: 61)
!295 = !DILocation(line: 81, column: 19, scope: !294)
!296 = !DILocation(line: 81, column: 9, scope: !294)
!297 = !DILocation(line: 82, column: 5, scope: !294)
!298 = !DILocation(line: 80, column: 50, scope: !290)
!299 = !DILocation(line: 80, column: 57, scope: !290)
!300 = !DILocation(line: 80, column: 5, scope: !290)
!301 = distinct !{!301, !292, !302, !265}
!302 = !DILocation(line: 82, column: 5, scope: !286)
!303 = !DILocation(line: 84, column: 5, scope: !280)
!304 = !DILocation(line: 85, column: 1, scope: !280)
!305 = distinct !DISubprogram(name: "launch_threads", scope: !16, file: !16, line: 111, type: !306, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
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
!327 = distinct !DISubprogram(name: "run", scope: !91, file: !91, line: 126, type: !29, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
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
!356 = distinct !DISubprogram(name: "queue_print", scope: !44, file: !44, line: 235, type: !357, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!357 = !DISubroutineType(types: !358)
!358 = !{null, !359, !43}
!359 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !157, size: 64)
!360 = !DILocalVariable(name: "q", arg: 1, scope: !356, file: !44, line: 235, type: !359)
!361 = !DILocation(line: 235, column: 26, scope: !356)
!362 = !DILocalVariable(name: "print", arg: 2, scope: !356, file: !44, line: 235, type: !43)
!363 = !DILocation(line: 235, column: 41, scope: !356)
!364 = !DILocation(line: 237, column: 28, scope: !356)
!365 = !DILocation(line: 237, column: 56, scope: !356)
!366 = !DILocation(line: 237, column: 48, scope: !356)
!367 = !DILocation(line: 237, column: 5, scope: !356)
!368 = !DILocation(line: 238, column: 1, scope: !356)
!369 = distinct !DISubprogram(name: "get_final_state", scope: !91, file: !91, line: 117, type: !46, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!370 = !DILocalVariable(name: "data", arg: 1, scope: !369, file: !91, line: 117, type: !13)
!371 = !DILocation(line: 117, column: 23, scope: !369)
!372 = !DILocation(line: 119, column: 5, scope: !373)
!373 = distinct !DILexicalBlock(scope: !374, file: !91, line: 119, column: 5)
!374 = distinct !DILexicalBlock(scope: !369, file: !91, line: 119, column: 5)
!375 = !DILocation(line: 119, column: 5, scope: !374)
!376 = !DILocalVariable(name: "node", scope: !369, file: !91, line: 120, type: !95)
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
!389 = distinct !DISubprogram(name: "destroy", scope: !91, file: !91, line: 88, type: !240, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!390 = !DILocation(line: 90, column: 5, scope: !389)
!391 = !DILocation(line: 91, column: 1, scope: !389)
!392 = distinct !DISubprogram(name: "vmem_no_leak", scope: !79, file: !79, line: 133, type: !393, scopeLine: 134, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
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
!405 = distinct !DISubprogram(name: "queue_init", scope: !44, file: !44, line: 110, type: !406, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!406 = !DISubroutineType(types: !407)
!407 = !{null, !408}
!408 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !156, size: 64)
!409 = !DILocalVariable(name: "q", arg: 1, scope: !405, file: !44, line: 110, type: !408)
!410 = !DILocation(line: 110, column: 21, scope: !405)
!411 = !DILocation(line: 112, column: 5, scope: !405)
!412 = !DILocation(line: 113, column: 20, scope: !405)
!413 = !DILocation(line: 113, column: 5, scope: !405)
!414 = !DILocation(line: 120, column: 1, scope: !405)
!415 = distinct !DISubprogram(name: "queue_register", scope: !44, file: !44, line: 123, type: !416, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
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
!432 = distinct !DISubprogram(name: "queue_deregister", scope: !44, file: !44, line: 139, type: !416, scopeLine: 140, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
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
!447 = distinct !DISubprogram(name: "queue_destroy", scope: !44, file: !44, line: 149, type: !406, scopeLine: 150, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
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
!460 = distinct !{!460, !452, !461, !265}
!461 = !DILocation(line: 158, column: 5, scope: !447)
!462 = !DILocation(line: 159, column: 23, scope: !447)
!463 = !DILocation(line: 159, column: 5, scope: !447)
!464 = !DILocation(line: 165, column: 5, scope: !447)
!465 = !DILocation(line: 166, column: 5, scope: !466)
!466 = distinct !DILexicalBlock(scope: !467, file: !44, line: 166, column: 5)
!467 = distinct !DILexicalBlock(scope: !447, file: !44, line: 166, column: 5)
!468 = !DILocation(line: 166, column: 5, scope: !467)
!469 = !DILocation(line: 167, column: 1, scope: !447)
!470 = distinct !DISubprogram(name: "queue_enq", scope: !44, file: !44, line: 170, type: !471, scopeLine: 171, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!471 = !DISubroutineType(types: !472)
!472 = !{null, !5, !408, !84, !101}
!473 = !DILocalVariable(name: "tid", arg: 1, scope: !470, file: !44, line: 170, type: !5)
!474 = !DILocation(line: 170, column: 19, scope: !470)
!475 = !DILocalVariable(name: "q", arg: 2, scope: !470, file: !44, line: 170, type: !408)
!476 = !DILocation(line: 170, column: 33, scope: !470)
!477 = !DILocalVariable(name: "key", arg: 3, scope: !470, file: !44, line: 170, type: !84)
!478 = !DILocation(line: 170, column: 46, scope: !470)
!479 = !DILocalVariable(name: "lbl", arg: 4, scope: !470, file: !44, line: 170, type: !101)
!480 = !DILocation(line: 170, column: 56, scope: !470)
!481 = !DILocalVariable(name: "data", scope: !470, file: !44, line: 172, type: !95)
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
!516 = distinct !DISubprogram(name: "queue_deq", scope: !44, file: !44, line: 219, type: !517, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
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
!535 = distinct !DISubprogram(name: "empty", scope: !91, file: !91, line: 106, type: !536, scopeLine: 107, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!536 = !DISubroutineType(types: !537)
!537 = !{!24, !5}
!538 = !DILocalVariable(name: "tid", arg: 1, scope: !535, file: !91, line: 106, type: !5)
!539 = !DILocation(line: 106, column: 15, scope: !535)
!540 = !DILocation(line: 108, column: 24, scope: !535)
!541 = !DILocation(line: 108, column: 12, scope: !535)
!542 = !DILocation(line: 108, column: 5, scope: !535)
!543 = distinct !DISubprogram(name: "queue_empty", scope: !44, file: !44, line: 210, type: !544, scopeLine: 211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!544 = !DISubroutineType(types: !545)
!545 = !{!24, !5, !408}
!546 = !DILocalVariable(name: "tid", arg: 1, scope: !543, file: !44, line: 210, type: !5)
!547 = !DILocation(line: 210, column: 21, scope: !543)
!548 = !DILocalVariable(name: "q", arg: 2, scope: !543, file: !44, line: 210, type: !408)
!549 = !DILocation(line: 210, column: 35, scope: !543)
!550 = !DILocation(line: 212, column: 16, scope: !543)
!551 = !DILocation(line: 212, column: 5, scope: !543)
!552 = !DILocalVariable(name: "empty", scope: !543, file: !44, line: 213, type: !24)
!553 = !DILocation(line: 213, column: 13, scope: !543)
!554 = !DILocation(line: 213, column: 37, scope: !543)
!555 = !DILocation(line: 213, column: 21, scope: !543)
!556 = !DILocation(line: 214, column: 15, scope: !543)
!557 = !DILocation(line: 214, column: 5, scope: !543)
!558 = !DILocation(line: 215, column: 12, scope: !543)
!559 = !DILocation(line: 215, column: 5, scope: !543)
!560 = distinct !DISubprogram(name: "ismr_recycle", scope: !50, file: !50, line: 114, type: !180, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!561 = !DILocalVariable(name: "tid", arg: 1, scope: !560, file: !50, line: 114, type: !5)
!562 = !DILocation(line: 114, column: 22, scope: !560)
!563 = !DILocation(line: 116, column: 5, scope: !560)
!564 = !DILocation(line: 116, column: 5, scope: !565)
!565 = distinct !DILexicalBlock(scope: !560, file: !50, line: 116, column: 5)
!566 = !DILocation(line: 116, column: 5, scope: !567)
!567 = distinct !DILexicalBlock(scope: !565, file: !50, line: 116, column: 5)
!568 = !DILocation(line: 116, column: 5, scope: !569)
!569 = distinct !DILexicalBlock(scope: !567, file: !50, line: 116, column: 5)
!570 = !DILocation(line: 117, column: 1, scope: !560)
!571 = distinct !DISubprogram(name: "create_threads", scope: !16, file: !16, line: 83, type: !572, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!572 = !DISubroutineType(types: !573)
!573 = !{null, !14, !5, !27, !24}
!574 = !DILocalVariable(name: "threads", arg: 1, scope: !571, file: !16, line: 83, type: !14)
!575 = !DILocation(line: 83, column: 28, scope: !571)
!576 = !DILocalVariable(name: "num_threads", arg: 2, scope: !571, file: !16, line: 83, type: !5)
!577 = !DILocation(line: 83, column: 45, scope: !571)
!578 = !DILocalVariable(name: "fun", arg: 3, scope: !571, file: !16, line: 83, type: !27)
!579 = !DILocation(line: 83, column: 71, scope: !571)
!580 = !DILocalVariable(name: "bind", arg: 4, scope: !571, file: !16, line: 84, type: !24)
!581 = !DILocation(line: 84, column: 24, scope: !571)
!582 = !DILocalVariable(name: "i", scope: !571, file: !16, line: 86, type: !5)
!583 = !DILocation(line: 86, column: 13, scope: !571)
!584 = !DILocation(line: 87, column: 12, scope: !585)
!585 = distinct !DILexicalBlock(scope: !571, file: !16, line: 87, column: 5)
!586 = !DILocation(line: 87, column: 10, scope: !585)
!587 = !DILocation(line: 87, column: 17, scope: !588)
!588 = distinct !DILexicalBlock(scope: !585, file: !16, line: 87, column: 5)
!589 = !DILocation(line: 87, column: 21, scope: !588)
!590 = !DILocation(line: 87, column: 19, scope: !588)
!591 = !DILocation(line: 87, column: 5, scope: !585)
!592 = !DILocation(line: 88, column: 40, scope: !593)
!593 = distinct !DILexicalBlock(scope: !588, file: !16, line: 87, column: 39)
!594 = !DILocation(line: 88, column: 9, scope: !593)
!595 = !DILocation(line: 88, column: 17, scope: !593)
!596 = !DILocation(line: 88, column: 20, scope: !593)
!597 = !DILocation(line: 88, column: 38, scope: !593)
!598 = !DILocation(line: 89, column: 40, scope: !593)
!599 = !DILocation(line: 89, column: 9, scope: !593)
!600 = !DILocation(line: 89, column: 17, scope: !593)
!601 = !DILocation(line: 89, column: 20, scope: !593)
!602 = !DILocation(line: 89, column: 38, scope: !593)
!603 = !DILocation(line: 90, column: 40, scope: !593)
!604 = !DILocation(line: 90, column: 9, scope: !593)
!605 = !DILocation(line: 90, column: 17, scope: !593)
!606 = !DILocation(line: 90, column: 20, scope: !593)
!607 = !DILocation(line: 90, column: 38, scope: !593)
!608 = !DILocation(line: 91, column: 25, scope: !593)
!609 = !DILocation(line: 91, column: 33, scope: !593)
!610 = !DILocation(line: 91, column: 36, scope: !593)
!611 = !DILocation(line: 91, column: 55, scope: !593)
!612 = !DILocation(line: 91, column: 63, scope: !593)
!613 = !DILocation(line: 91, column: 54, scope: !593)
!614 = !DILocation(line: 91, column: 9, scope: !593)
!615 = !DILocation(line: 92, column: 5, scope: !593)
!616 = !DILocation(line: 87, column: 35, scope: !588)
!617 = !DILocation(line: 87, column: 5, scope: !588)
!618 = distinct !{!618, !591, !619, !265}
!619 = !DILocation(line: 92, column: 5, scope: !585)
!620 = !DILocation(line: 94, column: 1, scope: !571)
!621 = distinct !DISubprogram(name: "await_threads", scope: !16, file: !16, line: 97, type: !622, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!622 = !DISubroutineType(types: !623)
!623 = !{null, !14, !5}
!624 = !DILocalVariable(name: "threads", arg: 1, scope: !621, file: !16, line: 97, type: !14)
!625 = !DILocation(line: 97, column: 27, scope: !621)
!626 = !DILocalVariable(name: "num_threads", arg: 2, scope: !621, file: !16, line: 97, type: !5)
!627 = !DILocation(line: 97, column: 44, scope: !621)
!628 = !DILocalVariable(name: "i", scope: !621, file: !16, line: 99, type: !5)
!629 = !DILocation(line: 99, column: 13, scope: !621)
!630 = !DILocation(line: 100, column: 12, scope: !631)
!631 = distinct !DILexicalBlock(scope: !621, file: !16, line: 100, column: 5)
!632 = !DILocation(line: 100, column: 10, scope: !631)
!633 = !DILocation(line: 100, column: 17, scope: !634)
!634 = distinct !DILexicalBlock(scope: !631, file: !16, line: 100, column: 5)
!635 = !DILocation(line: 100, column: 21, scope: !634)
!636 = !DILocation(line: 100, column: 19, scope: !634)
!637 = !DILocation(line: 100, column: 5, scope: !631)
!638 = !DILocation(line: 101, column: 22, scope: !639)
!639 = distinct !DILexicalBlock(scope: !634, file: !16, line: 100, column: 39)
!640 = !DILocation(line: 101, column: 30, scope: !639)
!641 = !DILocation(line: 101, column: 33, scope: !639)
!642 = !DILocation(line: 101, column: 9, scope: !639)
!643 = !DILocation(line: 102, column: 5, scope: !639)
!644 = !DILocation(line: 100, column: 35, scope: !634)
!645 = !DILocation(line: 100, column: 5, scope: !634)
!646 = distinct !{!646, !637, !647, !265}
!647 = !DILocation(line: 102, column: 5, scope: !631)
!648 = !DILocation(line: 103, column: 1, scope: !621)
!649 = distinct !DISubprogram(name: "common_run", scope: !16, file: !16, line: 43, type: !29, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!650 = !DILocalVariable(name: "args", arg: 1, scope: !649, file: !16, line: 43, type: !13)
!651 = !DILocation(line: 43, column: 18, scope: !649)
!652 = !DILocalVariable(name: "run_info", scope: !649, file: !16, line: 45, type: !14)
!653 = !DILocation(line: 45, column: 17, scope: !649)
!654 = !DILocation(line: 45, column: 42, scope: !649)
!655 = !DILocation(line: 45, column: 28, scope: !649)
!656 = !DILocation(line: 47, column: 9, scope: !657)
!657 = distinct !DILexicalBlock(scope: !649, file: !16, line: 47, column: 9)
!658 = !DILocation(line: 47, column: 19, scope: !657)
!659 = !DILocation(line: 47, column: 9, scope: !649)
!660 = !DILocation(line: 48, column: 26, scope: !657)
!661 = !DILocation(line: 48, column: 36, scope: !657)
!662 = !DILocation(line: 48, column: 9, scope: !657)
!663 = !DILocation(line: 52, column: 12, scope: !649)
!664 = !DILocation(line: 52, column: 22, scope: !649)
!665 = !DILocation(line: 52, column: 38, scope: !649)
!666 = !DILocation(line: 52, column: 48, scope: !649)
!667 = !DILocation(line: 52, column: 30, scope: !649)
!668 = !DILocation(line: 52, column: 5, scope: !649)
!669 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !16, file: !16, line: 61, type: !180, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!670 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !669, file: !16, line: 61, type: !5)
!671 = !DILocation(line: 61, column: 26, scope: !669)
!672 = !DILocation(line: 78, column: 5, scope: !669)
!673 = !DILocation(line: 78, column: 5, scope: !674)
!674 = distinct !DILexicalBlock(scope: !669, file: !16, line: 78, column: 5)
!675 = !DILocation(line: 78, column: 5, scope: !676)
!676 = distinct !DILexicalBlock(scope: !674, file: !16, line: 78, column: 5)
!677 = !DILocation(line: 78, column: 5, scope: !678)
!678 = distinct !DILexicalBlock(scope: !676, file: !16, line: 78, column: 5)
!679 = !DILocation(line: 80, column: 1, scope: !669)
!680 = distinct !DISubprogram(name: "_vqueue_ub_visit_nodes", scope: !33, file: !33, line: 233, type: !681, scopeLine: 235, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!681 = !DISubroutineType(types: !682)
!682 = !{null, !359, !683, !13}
!683 = !DIDerivedType(tag: DW_TAG_typedef, name: "vqueue_ub_node_handler_t", file: !684, line: 9, baseType: !685)
!684 = !DIFile(filename: "datastruct/queue/unbounded/include/vsync/queue/internal/ub/vqueue_ub_common.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "bc5763170bb9d2e4aa9aa1f04b243580")
!685 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !686, size: 64)
!686 = !DISubroutineType(types: !687)
!687 = !{null, !688, !13}
!688 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!689 = !DILocalVariable(name: "q", arg: 1, scope: !680, file: !33, line: 233, type: !359)
!690 = !DILocation(line: 233, column: 37, scope: !680)
!691 = !DILocalVariable(name: "visitor", arg: 2, scope: !680, file: !33, line: 233, type: !683)
!692 = !DILocation(line: 233, column: 65, scope: !680)
!693 = !DILocalVariable(name: "arg", arg: 3, scope: !680, file: !33, line: 234, type: !13)
!694 = !DILocation(line: 234, column: 30, scope: !680)
!695 = !DILocalVariable(name: "curr", scope: !680, file: !33, line: 236, type: !31)
!696 = !DILocation(line: 236, column: 23, scope: !680)
!697 = !DILocalVariable(name: "next", scope: !680, file: !33, line: 237, type: !31)
!698 = !DILocation(line: 237, column: 23, scope: !680)
!699 = !DILocation(line: 239, column: 12, scope: !680)
!700 = !DILocation(line: 239, column: 15, scope: !680)
!701 = !DILocation(line: 239, column: 10, scope: !680)
!702 = !DILocation(line: 241, column: 53, scope: !680)
!703 = !DILocation(line: 241, column: 59, scope: !680)
!704 = !DILocation(line: 241, column: 32, scope: !680)
!705 = !DILocation(line: 241, column: 12, scope: !680)
!706 = !DILocation(line: 241, column: 10, scope: !680)
!707 = !DILocation(line: 243, column: 5, scope: !680)
!708 = !DILocation(line: 243, column: 12, scope: !680)
!709 = !DILocation(line: 244, column: 57, scope: !710)
!710 = distinct !DILexicalBlock(scope: !680, file: !33, line: 243, column: 18)
!711 = !DILocation(line: 244, column: 63, scope: !710)
!712 = !DILocation(line: 244, column: 36, scope: !710)
!713 = !DILocation(line: 244, column: 16, scope: !710)
!714 = !DILocation(line: 244, column: 14, scope: !710)
!715 = !DILocation(line: 245, column: 9, scope: !710)
!716 = !DILocation(line: 245, column: 17, scope: !710)
!717 = !DILocation(line: 245, column: 23, scope: !710)
!718 = !DILocation(line: 246, column: 16, scope: !710)
!719 = !DILocation(line: 246, column: 14, scope: !710)
!720 = distinct !{!720, !707, !721, !265}
!721 = !DILocation(line: 247, column: 5, scope: !680)
!722 = !DILocation(line: 248, column: 1, scope: !680)
!723 = distinct !DISubprogram(name: "_redirect_print", scope: !44, file: !44, line: 229, type: !724, scopeLine: 230, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!724 = !DISubroutineType(types: !725)
!725 = !{null, !31, !13}
!726 = !DILocalVariable(name: "qnode", arg: 1, scope: !723, file: !44, line: 229, type: !31)
!727 = !DILocation(line: 229, column: 35, scope: !723)
!728 = !DILocalVariable(name: "arg", arg: 2, scope: !723, file: !44, line: 229, type: !13)
!729 = !DILocation(line: 229, column: 48, scope: !723)
!730 = !DILocalVariable(name: "print", scope: !723, file: !44, line: 231, type: !43)
!731 = !DILocation(line: 231, column: 17, scope: !723)
!732 = !DILocation(line: 231, column: 38, scope: !723)
!733 = !DILocation(line: 231, column: 25, scope: !723)
!734 = !DILocation(line: 232, column: 5, scope: !723)
!735 = !DILocation(line: 232, column: 11, scope: !723)
!736 = !DILocation(line: 232, column: 18, scope: !723)
!737 = !DILocation(line: 233, column: 1, scope: !723)
!738 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !739, file: !739, line: 197, type: !740, scopeLine: 198, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!739 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!740 = !DISubroutineType(types: !741)
!741 = !{!13, !742}
!742 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !743, size: 64)
!743 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !38)
!744 = !DILocalVariable(name: "a", arg: 1, scope: !738, file: !739, line: 197, type: !742)
!745 = !DILocation(line: 197, column: 41, scope: !738)
!746 = !DILocalVariable(name: "val", scope: !738, file: !739, line: 199, type: !13)
!747 = !DILocation(line: 199, column: 11, scope: !738)
!748 = !DILocation(line: 202, column: 32, scope: !738)
!749 = !DILocation(line: 202, column: 35, scope: !738)
!750 = !DILocation(line: 200, column: 5, scope: !738)
!751 = !{i64 852631}
!752 = !DILocation(line: 204, column: 12, scope: !738)
!753 = !DILocation(line: 204, column: 5, scope: !738)
!754 = distinct !DISubprogram(name: "vmem_get_alloc_count", scope: !79, file: !79, line: 90, type: !755, scopeLine: 91, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!755 = !DISubroutineType(types: !756)
!756 = !{!84}
!757 = !DILocalVariable(name: "alloc_count", scope: !754, file: !79, line: 93, type: !84)
!758 = !DILocation(line: 93, column: 15, scope: !754)
!759 = !DILocation(line: 93, column: 29, scope: !754)
!760 = !DILocation(line: 94, column: 5, scope: !754)
!761 = !DILocation(line: 94, column: 5, scope: !762)
!762 = distinct !DILexicalBlock(scope: !754, file: !79, line: 94, column: 5)
!763 = !DILocation(line: 94, column: 5, scope: !764)
!764 = distinct !DILexicalBlock(scope: !762, file: !79, line: 94, column: 5)
!765 = !DILocation(line: 94, column: 5, scope: !766)
!766 = distinct !DILexicalBlock(scope: !764, file: !79, line: 94, column: 5)
!767 = !DILocation(line: 95, column: 12, scope: !754)
!768 = !DILocation(line: 95, column: 5, scope: !754)
!769 = distinct !DISubprogram(name: "vmem_get_free_count", scope: !79, file: !79, line: 104, type: !755, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!770 = !DILocalVariable(name: "free_count", scope: !769, file: !79, line: 107, type: !84)
!771 = !DILocation(line: 107, column: 15, scope: !769)
!772 = !DILocation(line: 107, column: 28, scope: !769)
!773 = !DILocation(line: 108, column: 5, scope: !769)
!774 = !DILocation(line: 108, column: 5, scope: !775)
!775 = distinct !DILexicalBlock(scope: !769, file: !79, line: 108, column: 5)
!776 = !DILocation(line: 108, column: 5, scope: !777)
!777 = distinct !DILexicalBlock(scope: !775, file: !79, line: 108, column: 5)
!778 = !DILocation(line: 108, column: 5, scope: !779)
!779 = distinct !DILexicalBlock(scope: !777, file: !79, line: 108, column: 5)
!780 = !DILocation(line: 109, column: 12, scope: !769)
!781 = !DILocation(line: 109, column: 5, scope: !769)
!782 = distinct !DISubprogram(name: "vatomic64_read_rlx", scope: !739, file: !739, line: 149, type: !783, scopeLine: 150, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!783 = !DISubroutineType(types: !784)
!784 = !{!84, !785}
!785 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !786, size: 64)
!786 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !80)
!787 = !DILocalVariable(name: "a", arg: 1, scope: !782, file: !739, line: 149, type: !785)
!788 = !DILocation(line: 149, column: 39, scope: !782)
!789 = !DILocalVariable(name: "val", scope: !782, file: !739, line: 151, type: !84)
!790 = !DILocation(line: 151, column: 15, scope: !782)
!791 = !DILocation(line: 154, column: 32, scope: !782)
!792 = !DILocation(line: 154, column: 35, scope: !782)
!793 = !DILocation(line: 152, column: 5, scope: !782)
!794 = !{i64 851148}
!795 = !DILocation(line: 156, column: 12, scope: !782)
!796 = !DILocation(line: 156, column: 5, scope: !782)
!797 = distinct !DISubprogram(name: "ismr_init", scope: !50, file: !50, line: 35, type: !240, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!798 = !DILocation(line: 37, column: 5, scope: !797)
!799 = !DILocation(line: 38, column: 1, scope: !797)
!800 = distinct !DISubprogram(name: "vqueue_ub_init", scope: !33, file: !33, line: 76, type: !801, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!801 = !DISubroutineType(types: !802)
!802 = !{null, !359}
!803 = !DILocalVariable(name: "q", arg: 1, scope: !800, file: !33, line: 76, type: !359)
!804 = !DILocation(line: 76, column: 29, scope: !800)
!805 = !DILocation(line: 78, column: 16, scope: !800)
!806 = !DILocation(line: 78, column: 19, scope: !800)
!807 = !DILocation(line: 78, column: 5, scope: !800)
!808 = !DILocation(line: 78, column: 8, scope: !800)
!809 = !DILocation(line: 78, column: 13, scope: !800)
!810 = !DILocation(line: 79, column: 16, scope: !800)
!811 = !DILocation(line: 79, column: 19, scope: !800)
!812 = !DILocation(line: 79, column: 5, scope: !800)
!813 = !DILocation(line: 79, column: 8, scope: !800)
!814 = !DILocation(line: 79, column: 13, scope: !800)
!815 = !DILocation(line: 81, column: 27, scope: !800)
!816 = !DILocation(line: 81, column: 30, scope: !800)
!817 = !DILocation(line: 81, column: 5, scope: !800)
!818 = !DILocation(line: 83, column: 22, scope: !800)
!819 = !DILocation(line: 83, column: 25, scope: !800)
!820 = !DILocation(line: 83, column: 5, scope: !800)
!821 = !DILocation(line: 84, column: 22, scope: !800)
!822 = !DILocation(line: 84, column: 25, scope: !800)
!823 = !DILocation(line: 84, column: 5, scope: !800)
!824 = !DILocation(line: 85, column: 1, scope: !800)
!825 = distinct !DISubprogram(name: "locked_trace_init", scope: !105, file: !105, line: 14, type: !826, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!826 = !DISubroutineType(types: !827)
!827 = !{null, !828, !5}
!828 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!829 = !DILocalVariable(name: "trace", arg: 1, scope: !825, file: !105, line: 14, type: !828)
!830 = !DILocation(line: 14, column: 35, scope: !825)
!831 = !DILocalVariable(name: "capacity", arg: 2, scope: !825, file: !105, line: 14, type: !5)
!832 = !DILocation(line: 14, column: 50, scope: !825)
!833 = !DILocation(line: 16, column: 5, scope: !834)
!834 = distinct !DILexicalBlock(scope: !835, file: !105, line: 16, column: 5)
!835 = distinct !DILexicalBlock(scope: !825, file: !105, line: 16, column: 5)
!836 = !DILocation(line: 16, column: 5, scope: !835)
!837 = !DILocation(line: 17, column: 25, scope: !825)
!838 = !DILocation(line: 17, column: 32, scope: !825)
!839 = !DILocation(line: 17, column: 5, scope: !825)
!840 = !DILocation(line: 18, column: 17, scope: !825)
!841 = !DILocation(line: 18, column: 24, scope: !825)
!842 = !DILocation(line: 18, column: 31, scope: !825)
!843 = !DILocation(line: 18, column: 5, scope: !825)
!844 = !DILocation(line: 19, column: 1, scope: !825)
!845 = distinct !DISubprogram(name: "trace_init", scope: !110, file: !110, line: 28, type: !846, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!846 = !DISubroutineType(types: !847)
!847 = !{null, !848, !5}
!848 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!849 = !DILocalVariable(name: "trace", arg: 1, scope: !845, file: !110, line: 28, type: !848)
!850 = !DILocation(line: 28, column: 21, scope: !845)
!851 = !DILocalVariable(name: "capacity", arg: 2, scope: !845, file: !110, line: 28, type: !5)
!852 = !DILocation(line: 28, column: 36, scope: !845)
!853 = !DILocation(line: 30, column: 5, scope: !854)
!854 = distinct !DILexicalBlock(scope: !855, file: !110, line: 30, column: 5)
!855 = distinct !DILexicalBlock(scope: !845, file: !110, line: 30, column: 5)
!856 = !DILocation(line: 30, column: 5, scope: !855)
!857 = !DILocation(line: 31, column: 27, scope: !845)
!858 = !DILocation(line: 31, column: 36, scope: !845)
!859 = !DILocation(line: 31, column: 20, scope: !845)
!860 = !DILocation(line: 31, column: 5, scope: !845)
!861 = !DILocation(line: 31, column: 12, scope: !845)
!862 = !DILocation(line: 31, column: 18, scope: !845)
!863 = !DILocation(line: 32, column: 9, scope: !864)
!864 = distinct !DILexicalBlock(scope: !845, file: !110, line: 32, column: 9)
!865 = !DILocation(line: 32, column: 16, scope: !864)
!866 = !DILocation(line: 32, column: 9, scope: !845)
!867 = !DILocation(line: 33, column: 9, scope: !868)
!868 = distinct !DILexicalBlock(scope: !864, file: !110, line: 32, column: 23)
!869 = !DILocation(line: 33, column: 16, scope: !868)
!870 = !DILocation(line: 33, column: 28, scope: !868)
!871 = !DILocation(line: 34, column: 30, scope: !868)
!872 = !DILocation(line: 34, column: 9, scope: !868)
!873 = !DILocation(line: 34, column: 16, scope: !868)
!874 = !DILocation(line: 34, column: 28, scope: !868)
!875 = !DILocation(line: 35, column: 9, scope: !868)
!876 = !DILocation(line: 35, column: 16, scope: !868)
!877 = !DILocation(line: 35, column: 28, scope: !868)
!878 = !DILocation(line: 36, column: 5, scope: !868)
!879 = !DILocation(line: 37, column: 9, scope: !880)
!880 = distinct !DILexicalBlock(scope: !864, file: !110, line: 36, column: 12)
!881 = !DILocation(line: 37, column: 16, scope: !880)
!882 = !DILocation(line: 37, column: 28, scope: !880)
!883 = !DILocation(line: 38, column: 9, scope: !880)
!884 = !DILocation(line: 38, column: 16, scope: !880)
!885 = !DILocation(line: 38, column: 28, scope: !880)
!886 = !DILocation(line: 39, column: 9, scope: !880)
!887 = !DILocation(line: 39, column: 16, scope: !880)
!888 = !DILocation(line: 39, column: 28, scope: !880)
!889 = !DILocation(line: 40, column: 9, scope: !890)
!890 = distinct !DILexicalBlock(scope: !891, file: !110, line: 40, column: 9)
!891 = distinct !DILexicalBlock(scope: !880, file: !110, line: 40, column: 9)
!892 = !DILocation(line: 42, column: 1, scope: !845)
!893 = distinct !DISubprogram(name: "_vqueue_ub_node_init", scope: !33, file: !33, line: 219, type: !724, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!894 = !DILocalVariable(name: "qnode", arg: 1, scope: !893, file: !33, line: 219, type: !31)
!895 = !DILocation(line: 219, column: 40, scope: !893)
!896 = !DILocalVariable(name: "data", arg: 2, scope: !893, file: !33, line: 219, type: !13)
!897 = !DILocation(line: 219, column: 53, scope: !893)
!898 = !DILocation(line: 221, column: 19, scope: !893)
!899 = !DILocation(line: 221, column: 5, scope: !893)
!900 = !DILocation(line: 221, column: 12, scope: !893)
!901 = !DILocation(line: 221, column: 17, scope: !893)
!902 = !DILocation(line: 222, column: 27, scope: !893)
!903 = !DILocation(line: 222, column: 34, scope: !893)
!904 = !DILocation(line: 222, column: 5, scope: !893)
!905 = !DILocation(line: 223, column: 1, scope: !893)
!906 = distinct !DISubprogram(name: "queue_lock_init", scope: !33, file: !33, line: 31, type: !907, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!907 = !DISubroutineType(types: !908)
!908 = !{null, !909}
!909 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !161, size: 64)
!910 = !DILocalVariable(name: "l", arg: 1, scope: !906, file: !33, line: 31, type: !909)
!911 = !DILocation(line: 31, column: 1, scope: !906)
!912 = distinct !DISubprogram(name: "vatomicptr_write_rlx", scope: !739, file: !739, line: 325, type: !913, scopeLine: 326, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!913 = !DISubroutineType(types: !914)
!914 = !{null, !915, !13}
!915 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!916 = !DILocalVariable(name: "a", arg: 1, scope: !912, file: !739, line: 325, type: !915)
!917 = !DILocation(line: 325, column: 36, scope: !912)
!918 = !DILocalVariable(name: "v", arg: 2, scope: !912, file: !739, line: 325, type: !13)
!919 = !DILocation(line: 325, column: 45, scope: !912)
!920 = !DILocation(line: 329, column: 32, scope: !912)
!921 = !DILocation(line: 329, column: 44, scope: !912)
!922 = !DILocation(line: 329, column: 47, scope: !912)
!923 = !DILocation(line: 327, column: 5, scope: !912)
!924 = !{i64 856832}
!925 = !DILocation(line: 331, column: 1, scope: !912)
!926 = distinct !DISubprogram(name: "ismr_reg", scope: !50, file: !50, line: 89, type: !180, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!927 = !DILocalVariable(name: "tid", arg: 1, scope: !926, file: !50, line: 89, type: !5)
!928 = !DILocation(line: 89, column: 18, scope: !926)
!929 = !DILocation(line: 91, column: 5, scope: !926)
!930 = !DILocation(line: 91, column: 5, scope: !931)
!931 = distinct !DILexicalBlock(scope: !926, file: !50, line: 91, column: 5)
!932 = !DILocation(line: 91, column: 5, scope: !933)
!933 = distinct !DILexicalBlock(scope: !931, file: !50, line: 91, column: 5)
!934 = !DILocation(line: 91, column: 5, scope: !935)
!935 = distinct !DILexicalBlock(scope: !933, file: !50, line: 91, column: 5)
!936 = !DILocation(line: 92, column: 1, scope: !926)
!937 = distinct !DISubprogram(name: "ismr_dereg", scope: !50, file: !50, line: 95, type: !180, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!938 = !DILocalVariable(name: "tid", arg: 1, scope: !937, file: !50, line: 95, type: !5)
!939 = !DILocation(line: 95, column: 20, scope: !937)
!940 = !DILocation(line: 97, column: 5, scope: !937)
!941 = !DILocation(line: 97, column: 5, scope: !942)
!942 = distinct !DILexicalBlock(scope: !937, file: !50, line: 97, column: 5)
!943 = !DILocation(line: 97, column: 5, scope: !944)
!944 = distinct !DILexicalBlock(scope: !942, file: !50, line: 97, column: 5)
!945 = !DILocation(line: 97, column: 5, scope: !946)
!946 = distinct !DILexicalBlock(scope: !944, file: !50, line: 97, column: 5)
!947 = !DILocation(line: 98, column: 1, scope: !937)
!948 = distinct !DISubprogram(name: "vqueue_ub_deq", scope: !33, file: !33, line: 166, type: !949, scopeLine: 167, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!949 = !DISubroutineType(types: !950)
!950 = !{!13, !359, !683, !13}
!951 = !DILocalVariable(name: "q", arg: 1, scope: !948, file: !33, line: 166, type: !359)
!952 = !DILocation(line: 166, column: 28, scope: !948)
!953 = !DILocalVariable(name: "retire", arg: 2, scope: !948, file: !33, line: 166, type: !683)
!954 = !DILocation(line: 166, column: 56, scope: !948)
!955 = !DILocalVariable(name: "retire_arg", arg: 3, scope: !948, file: !33, line: 166, type: !13)
!956 = !DILocation(line: 166, column: 70, scope: !948)
!957 = !DILocalVariable(name: "qnode", scope: !948, file: !33, line: 168, type: !31)
!958 = !DILocation(line: 168, column: 23, scope: !948)
!959 = !DILocalVariable(name: "head", scope: !948, file: !33, line: 169, type: !31)
!960 = !DILocation(line: 169, column: 23, scope: !948)
!961 = !DILocalVariable(name: "data", scope: !948, file: !33, line: 170, type: !13)
!962 = !DILocation(line: 170, column: 11, scope: !948)
!963 = !DILocation(line: 172, column: 25, scope: !948)
!964 = !DILocation(line: 172, column: 28, scope: !948)
!965 = !DILocation(line: 172, column: 5, scope: !948)
!966 = !DILocation(line: 174, column: 12, scope: !948)
!967 = !DILocation(line: 174, column: 15, scope: !948)
!968 = !DILocation(line: 174, column: 10, scope: !948)
!969 = !DILocation(line: 176, column: 54, scope: !948)
!970 = !DILocation(line: 176, column: 60, scope: !948)
!971 = !DILocation(line: 176, column: 33, scope: !948)
!972 = !DILocation(line: 176, column: 13, scope: !948)
!973 = !DILocation(line: 176, column: 11, scope: !948)
!974 = !DILocation(line: 177, column: 9, scope: !975)
!975 = distinct !DILexicalBlock(scope: !948, file: !33, line: 177, column: 9)
!976 = !DILocation(line: 177, column: 9, scope: !948)
!977 = !DILocation(line: 178, column: 19, scope: !978)
!978 = distinct !DILexicalBlock(scope: !975, file: !33, line: 177, column: 16)
!979 = !DILocation(line: 178, column: 26, scope: !978)
!980 = !DILocation(line: 178, column: 17, scope: !978)
!981 = !DILocation(line: 179, column: 19, scope: !978)
!982 = !DILocation(line: 179, column: 9, scope: !978)
!983 = !DILocation(line: 179, column: 12, scope: !978)
!984 = !DILocation(line: 179, column: 17, scope: !978)
!985 = !DILocation(line: 180, column: 13, scope: !986)
!986 = distinct !DILexicalBlock(scope: !978, file: !33, line: 180, column: 13)
!987 = !DILocation(line: 180, column: 22, scope: !986)
!988 = !DILocation(line: 180, column: 25, scope: !986)
!989 = !DILocation(line: 180, column: 18, scope: !986)
!990 = !DILocation(line: 180, column: 13, scope: !978)
!991 = !DILocation(line: 181, column: 13, scope: !992)
!992 = distinct !DILexicalBlock(scope: !986, file: !33, line: 180, column: 35)
!993 = !DILocation(line: 181, column: 20, scope: !992)
!994 = !DILocation(line: 181, column: 26, scope: !992)
!995 = !DILocation(line: 182, column: 9, scope: !992)
!996 = !DILocation(line: 183, column: 5, scope: !978)
!997 = !DILocation(line: 184, column: 25, scope: !948)
!998 = !DILocation(line: 184, column: 28, scope: !948)
!999 = !DILocation(line: 184, column: 5, scope: !948)
!1000 = !DILocation(line: 185, column: 12, scope: !948)
!1001 = !DILocation(line: 185, column: 5, scope: !948)
!1002 = distinct !DISubprogram(name: "_queue_destroy", scope: !44, file: !44, line: 67, type: !1003, scopeLine: 68, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1003 = !DISubroutineType(types: !1004)
!1004 = !{null, !497, !13}
!1005 = !DILocalVariable(name: "node", arg: 1, scope: !1002, file: !44, line: 67, type: !497)
!1006 = !DILocation(line: 67, column: 30, scope: !1002)
!1007 = !DILocalVariable(name: "arg", arg: 2, scope: !1002, file: !44, line: 67, type: !13)
!1008 = !DILocation(line: 67, column: 42, scope: !1002)
!1009 = !DILocation(line: 72, column: 15, scope: !1002)
!1010 = !DILocation(line: 72, column: 5, scope: !1002)
!1011 = !DILocation(line: 74, column: 5, scope: !1002)
!1012 = !DILocation(line: 74, column: 5, scope: !1013)
!1013 = distinct !DILexicalBlock(scope: !1002, file: !44, line: 74, column: 5)
!1014 = !DILocation(line: 74, column: 5, scope: !1015)
!1015 = distinct !DILexicalBlock(scope: !1013, file: !44, line: 74, column: 5)
!1016 = !DILocation(line: 74, column: 5, scope: !1017)
!1017 = distinct !DILexicalBlock(scope: !1015, file: !44, line: 74, column: 5)
!1018 = !DILocation(line: 75, column: 1, scope: !1002)
!1019 = distinct !DISubprogram(name: "vqueue_ub_destroy", scope: !33, file: !33, line: 98, type: !681, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1020 = !DILocalVariable(name: "q", arg: 1, scope: !1019, file: !33, line: 98, type: !359)
!1021 = !DILocation(line: 98, column: 32, scope: !1019)
!1022 = !DILocalVariable(name: "retire", arg: 2, scope: !1019, file: !33, line: 98, type: !683)
!1023 = !DILocation(line: 98, column: 60, scope: !1019)
!1024 = !DILocalVariable(name: "retire_arg", arg: 3, scope: !1019, file: !33, line: 99, type: !13)
!1025 = !DILocation(line: 99, column: 25, scope: !1019)
!1026 = !DILocalVariable(name: "curr", scope: !1019, file: !33, line: 101, type: !31)
!1027 = !DILocation(line: 101, column: 23, scope: !1019)
!1028 = !DILocalVariable(name: "next", scope: !1019, file: !33, line: 102, type: !31)
!1029 = !DILocation(line: 102, column: 23, scope: !1019)
!1030 = !DILocation(line: 104, column: 12, scope: !1019)
!1031 = !DILocation(line: 104, column: 15, scope: !1019)
!1032 = !DILocation(line: 104, column: 10, scope: !1019)
!1033 = !DILocation(line: 106, column: 5, scope: !1019)
!1034 = !DILocation(line: 106, column: 12, scope: !1019)
!1035 = !DILocation(line: 107, column: 57, scope: !1036)
!1036 = distinct !DILexicalBlock(scope: !1019, file: !33, line: 106, column: 18)
!1037 = !DILocation(line: 107, column: 63, scope: !1036)
!1038 = !DILocation(line: 107, column: 36, scope: !1036)
!1039 = !DILocation(line: 107, column: 16, scope: !1036)
!1040 = !DILocation(line: 107, column: 14, scope: !1036)
!1041 = !DILocation(line: 108, column: 13, scope: !1042)
!1042 = distinct !DILexicalBlock(scope: !1036, file: !33, line: 108, column: 13)
!1043 = !DILocation(line: 108, column: 22, scope: !1042)
!1044 = !DILocation(line: 108, column: 25, scope: !1042)
!1045 = !DILocation(line: 108, column: 18, scope: !1042)
!1046 = !DILocation(line: 108, column: 13, scope: !1036)
!1047 = !DILocation(line: 109, column: 13, scope: !1048)
!1048 = distinct !DILexicalBlock(scope: !1042, file: !33, line: 108, column: 35)
!1049 = !DILocation(line: 109, column: 20, scope: !1048)
!1050 = !DILocation(line: 109, column: 26, scope: !1048)
!1051 = !DILocation(line: 110, column: 9, scope: !1048)
!1052 = !DILocation(line: 111, column: 16, scope: !1036)
!1053 = !DILocation(line: 111, column: 14, scope: !1036)
!1054 = distinct !{!1054, !1033, !1055, !265}
!1055 = !DILocation(line: 112, column: 5, scope: !1019)
!1056 = !DILocation(line: 113, column: 1, scope: !1019)
!1057 = distinct !DISubprogram(name: "ismr_destroy", scope: !50, file: !50, line: 101, type: !240, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1058 = !DILocation(line: 103, column: 5, scope: !1057)
!1059 = !DILocation(line: 104, column: 1, scope: !1057)
!1060 = distinct !DISubprogram(name: "queue_lock_acquire", scope: !33, file: !33, line: 31, type: !907, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1061 = !DILocalVariable(name: "l", arg: 1, scope: !1060, file: !33, line: 31, type: !909)
!1062 = !DILocation(line: 31, column: 1, scope: !1060)
!1063 = !DILocalVariable(name: "val", scope: !1060, file: !33, line: 31, type: !66)
!1064 = !DILocation(line: 31, column: 1, scope: !1065)
!1065 = distinct !DILexicalBlock(scope: !1066, file: !33, line: 31, column: 1)
!1066 = distinct !DILexicalBlock(scope: !1060, file: !33, line: 31, column: 1)
!1067 = !DILocation(line: 31, column: 1, scope: !1066)
!1068 = distinct !DISubprogram(name: "vatomicptr_read_acq", scope: !739, file: !739, line: 181, type: !740, scopeLine: 182, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1069 = !DILocalVariable(name: "a", arg: 1, scope: !1068, file: !739, line: 181, type: !742)
!1070 = !DILocation(line: 181, column: 41, scope: !1068)
!1071 = !DILocalVariable(name: "val", scope: !1068, file: !739, line: 183, type: !13)
!1072 = !DILocation(line: 183, column: 11, scope: !1068)
!1073 = !DILocation(line: 186, column: 32, scope: !1068)
!1074 = !DILocation(line: 186, column: 35, scope: !1068)
!1075 = !DILocation(line: 184, column: 5, scope: !1068)
!1076 = !{i64 852131}
!1077 = !DILocation(line: 188, column: 12, scope: !1068)
!1078 = !DILocation(line: 188, column: 5, scope: !1068)
!1079 = distinct !DISubprogram(name: "queue_lock_release", scope: !33, file: !33, line: 31, type: !907, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1080 = !DILocalVariable(name: "l", arg: 1, scope: !1079, file: !33, line: 31, type: !909)
!1081 = !DILocation(line: 31, column: 1, scope: !1079)
!1082 = !DILocalVariable(name: "val", scope: !1079, file: !33, line: 31, type: !66)
!1083 = !DILocation(line: 31, column: 1, scope: !1084)
!1084 = distinct !DILexicalBlock(scope: !1085, file: !33, line: 31, column: 1)
!1085 = distinct !DILexicalBlock(scope: !1079, file: !33, line: 31, column: 1)
!1086 = !DILocation(line: 31, column: 1, scope: !1085)
!1087 = distinct !DISubprogram(name: "vmem_free", scope: !79, file: !79, line: 71, type: !46, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1088 = !DILocalVariable(name: "ptr", arg: 1, scope: !1087, file: !79, line: 71, type: !13)
!1089 = !DILocation(line: 71, column: 17, scope: !1087)
!1090 = !DILocation(line: 73, column: 10, scope: !1087)
!1091 = !DILocation(line: 73, column: 5, scope: !1087)
!1092 = !DILocation(line: 74, column: 9, scope: !1093)
!1093 = distinct !DILexicalBlock(scope: !1087, file: !79, line: 74, column: 9)
!1094 = !DILocation(line: 74, column: 9, scope: !1087)
!1095 = !DILocation(line: 76, column: 9, scope: !1096)
!1096 = distinct !DILexicalBlock(scope: !1093, file: !79, line: 74, column: 14)
!1097 = !DILocation(line: 78, column: 5, scope: !1096)
!1098 = !DILocation(line: 79, column: 1, scope: !1087)
!1099 = distinct !DISubprogram(name: "vatomic64_inc_rlx", scope: !1100, file: !1100, line: 3000, type: !1101, scopeLine: 3001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1100 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!1101 = !DISubroutineType(types: !1102)
!1102 = !{null, !1103}
!1103 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!1104 = !DILocalVariable(name: "a", arg: 1, scope: !1099, file: !1100, line: 3000, type: !1103)
!1105 = !DILocation(line: 3000, column: 32, scope: !1099)
!1106 = !DILocation(line: 3002, column: 33, scope: !1099)
!1107 = !DILocation(line: 3002, column: 11, scope: !1099)
!1108 = !DILocation(line: 3003, column: 1, scope: !1099)
!1109 = distinct !DISubprogram(name: "vatomic64_get_inc_rlx", scope: !1100, file: !1100, line: 2560, type: !1110, scopeLine: 2561, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1110 = !DISubroutineType(types: !1111)
!1111 = !{!84, !1103}
!1112 = !DILocalVariable(name: "a", arg: 1, scope: !1109, file: !1100, line: 2560, type: !1103)
!1113 = !DILocation(line: 2560, column: 36, scope: !1109)
!1114 = !DILocation(line: 2562, column: 34, scope: !1109)
!1115 = !DILocation(line: 2562, column: 12, scope: !1109)
!1116 = !DILocation(line: 2562, column: 5, scope: !1109)
!1117 = distinct !DISubprogram(name: "vatomic64_get_add_rlx", scope: !1118, file: !1118, line: 1888, type: !1119, scopeLine: 1889, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1118 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!1119 = !DISubroutineType(types: !1120)
!1120 = !{!84, !1103, !84}
!1121 = !DILocalVariable(name: "a", arg: 1, scope: !1117, file: !1118, line: 1888, type: !1103)
!1122 = !DILocation(line: 1888, column: 36, scope: !1117)
!1123 = !DILocalVariable(name: "v", arg: 2, scope: !1117, file: !1118, line: 1888, type: !84)
!1124 = !DILocation(line: 1888, column: 49, scope: !1117)
!1125 = !DILocalVariable(name: "oldv", scope: !1117, file: !1118, line: 1890, type: !84)
!1126 = !DILocation(line: 1890, column: 15, scope: !1117)
!1127 = !DILocalVariable(name: "tmp", scope: !1117, file: !1118, line: 1891, type: !1128)
!1128 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !6, line: 35, baseType: !1129)
!1129 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !86, line: 26, baseType: !1130)
!1130 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !88, line: 42, baseType: !133)
!1131 = !DILocation(line: 1891, column: 15, scope: !1117)
!1132 = !DILocalVariable(name: "newv", scope: !1117, file: !1118, line: 1892, type: !84)
!1133 = !DILocation(line: 1892, column: 15, scope: !1117)
!1134 = !DILocation(line: 1893, column: 5, scope: !1117)
!1135 = !DILocation(line: 1901, column: 19, scope: !1117)
!1136 = !DILocation(line: 1901, column: 22, scope: !1117)
!1137 = !{i64 961875, i64 961909, i64 961924, i64 961956, i64 961998, i64 962039}
!1138 = !DILocation(line: 1904, column: 12, scope: !1117)
!1139 = !DILocation(line: 1904, column: 5, scope: !1117)
!1140 = distinct !DISubprogram(name: "locked_trace_destroy", scope: !105, file: !105, line: 31, type: !1141, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1141 = !DISubroutineType(types: !1142)
!1142 = !{null, !828, !1143}
!1143 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_verify_unit", file: !110, line: 25, baseType: !1144)
!1144 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1145, size: 64)
!1145 = !DISubroutineType(types: !1146)
!1146 = !{!24, !114}
!1147 = !DILocalVariable(name: "trace", arg: 1, scope: !1140, file: !105, line: 31, type: !828)
!1148 = !DILocation(line: 31, column: 38, scope: !1140)
!1149 = !DILocalVariable(name: "callback", arg: 2, scope: !1140, file: !105, line: 31, type: !1143)
!1150 = !DILocation(line: 31, column: 63, scope: !1140)
!1151 = !DILocation(line: 33, column: 19, scope: !1140)
!1152 = !DILocation(line: 33, column: 26, scope: !1140)
!1153 = !DILocation(line: 33, column: 33, scope: !1140)
!1154 = !DILocation(line: 33, column: 5, scope: !1140)
!1155 = !DILocation(line: 34, column: 20, scope: !1140)
!1156 = !DILocation(line: 34, column: 27, scope: !1140)
!1157 = !DILocation(line: 34, column: 5, scope: !1140)
!1158 = !DILocation(line: 35, column: 28, scope: !1140)
!1159 = !DILocation(line: 35, column: 35, scope: !1140)
!1160 = !DILocation(line: 35, column: 5, scope: !1140)
!1161 = !DILocation(line: 36, column: 1, scope: !1140)
!1162 = distinct !DISubprogram(name: "_ismr_none_destroy_all_cb", scope: !50, file: !50, line: 25, type: !1145, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1163 = !DILocalVariable(name: "unit", arg: 1, scope: !1162, file: !50, line: 25, type: !114)
!1164 = !DILocation(line: 25, column: 41, scope: !1162)
!1165 = !DILocation(line: 27, column: 5, scope: !1166)
!1166 = distinct !DILexicalBlock(scope: !1167, file: !50, line: 27, column: 5)
!1167 = distinct !DILexicalBlock(scope: !1162, file: !50, line: 27, column: 5)
!1168 = !DILocation(line: 27, column: 5, scope: !1167)
!1169 = !DILocalVariable(name: "info", scope: !1162, file: !50, line: 28, type: !48)
!1170 = !DILocation(line: 28, column: 29, scope: !1162)
!1171 = !DILocation(line: 28, column: 62, scope: !1162)
!1172 = !DILocation(line: 28, column: 68, scope: !1162)
!1173 = !DILocation(line: 28, column: 36, scope: !1162)
!1174 = !DILocation(line: 29, column: 5, scope: !1162)
!1175 = !DILocation(line: 29, column: 11, scope: !1162)
!1176 = !DILocation(line: 29, column: 20, scope: !1162)
!1177 = !DILocation(line: 29, column: 26, scope: !1162)
!1178 = !DILocation(line: 29, column: 35, scope: !1162)
!1179 = !DILocation(line: 29, column: 41, scope: !1162)
!1180 = !DILocation(line: 30, column: 10, scope: !1162)
!1181 = !DILocation(line: 30, column: 5, scope: !1162)
!1182 = !DILocation(line: 31, column: 5, scope: !1162)
!1183 = distinct !DISubprogram(name: "trace_verify", scope: !110, file: !110, line: 210, type: !1184, scopeLine: 211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1184 = !DISubroutineType(types: !1185)
!1185 = !{!24, !848, !1143}
!1186 = !DILocalVariable(name: "trace", arg: 1, scope: !1183, file: !110, line: 210, type: !848)
!1187 = !DILocation(line: 210, column: 23, scope: !1183)
!1188 = !DILocalVariable(name: "verify_fun", arg: 2, scope: !1183, file: !110, line: 210, type: !1143)
!1189 = !DILocation(line: 210, column: 48, scope: !1183)
!1190 = !DILocalVariable(name: "i", scope: !1183, file: !110, line: 212, type: !5)
!1191 = !DILocation(line: 212, column: 13, scope: !1183)
!1192 = !DILocation(line: 214, column: 5, scope: !1193)
!1193 = distinct !DILexicalBlock(scope: !1194, file: !110, line: 214, column: 5)
!1194 = distinct !DILexicalBlock(scope: !1183, file: !110, line: 214, column: 5)
!1195 = !DILocation(line: 214, column: 5, scope: !1194)
!1196 = !DILocation(line: 215, column: 5, scope: !1197)
!1197 = distinct !DILexicalBlock(scope: !1198, file: !110, line: 215, column: 5)
!1198 = distinct !DILexicalBlock(scope: !1183, file: !110, line: 215, column: 5)
!1199 = !DILocation(line: 215, column: 5, scope: !1198)
!1200 = !DILocation(line: 216, column: 5, scope: !1201)
!1201 = distinct !DILexicalBlock(scope: !1202, file: !110, line: 216, column: 5)
!1202 = distinct !DILexicalBlock(scope: !1183, file: !110, line: 216, column: 5)
!1203 = !DILocation(line: 216, column: 5, scope: !1202)
!1204 = !DILocation(line: 218, column: 12, scope: !1205)
!1205 = distinct !DILexicalBlock(scope: !1183, file: !110, line: 218, column: 5)
!1206 = !DILocation(line: 218, column: 10, scope: !1205)
!1207 = !DILocation(line: 218, column: 17, scope: !1208)
!1208 = distinct !DILexicalBlock(scope: !1205, file: !110, line: 218, column: 5)
!1209 = !DILocation(line: 218, column: 21, scope: !1208)
!1210 = !DILocation(line: 218, column: 28, scope: !1208)
!1211 = !DILocation(line: 218, column: 19, scope: !1208)
!1212 = !DILocation(line: 218, column: 5, scope: !1205)
!1213 = !DILocation(line: 219, column: 13, scope: !1214)
!1214 = distinct !DILexicalBlock(scope: !1215, file: !110, line: 219, column: 13)
!1215 = distinct !DILexicalBlock(scope: !1208, file: !110, line: 218, column: 38)
!1216 = !DILocation(line: 219, column: 25, scope: !1214)
!1217 = !DILocation(line: 219, column: 32, scope: !1214)
!1218 = !DILocation(line: 219, column: 38, scope: !1214)
!1219 = !DILocation(line: 219, column: 42, scope: !1214)
!1220 = !DILocation(line: 219, column: 13, scope: !1215)
!1221 = !DILocation(line: 220, column: 13, scope: !1222)
!1222 = distinct !DILexicalBlock(scope: !1214, file: !110, line: 219, column: 52)
!1223 = !DILocation(line: 222, column: 5, scope: !1215)
!1224 = !DILocation(line: 218, column: 34, scope: !1208)
!1225 = !DILocation(line: 218, column: 5, scope: !1208)
!1226 = distinct !{!1226, !1212, !1227, !265}
!1227 = !DILocation(line: 222, column: 5, scope: !1205)
!1228 = !DILocation(line: 223, column: 5, scope: !1183)
!1229 = !DILocation(line: 224, column: 1, scope: !1183)
!1230 = distinct !DISubprogram(name: "trace_destroy", scope: !110, file: !110, line: 97, type: !1231, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1231 = !DISubroutineType(types: !1232)
!1232 = !{null, !848}
!1233 = !DILocalVariable(name: "trace", arg: 1, scope: !1230, file: !110, line: 97, type: !848)
!1234 = !DILocation(line: 97, column: 24, scope: !1230)
!1235 = !DILocation(line: 99, column: 5, scope: !1236)
!1236 = distinct !DILexicalBlock(scope: !1237, file: !110, line: 99, column: 5)
!1237 = distinct !DILexicalBlock(scope: !1230, file: !110, line: 99, column: 5)
!1238 = !DILocation(line: 99, column: 5, scope: !1237)
!1239 = !DILocation(line: 100, column: 5, scope: !1240)
!1240 = distinct !DILexicalBlock(scope: !1241, file: !110, line: 100, column: 5)
!1241 = distinct !DILexicalBlock(scope: !1230, file: !110, line: 100, column: 5)
!1242 = !DILocation(line: 100, column: 5, scope: !1241)
!1243 = !DILocation(line: 101, column: 10, scope: !1230)
!1244 = !DILocation(line: 101, column: 17, scope: !1230)
!1245 = !DILocation(line: 101, column: 5, scope: !1230)
!1246 = !DILocation(line: 102, column: 5, scope: !1230)
!1247 = !DILocation(line: 102, column: 12, scope: !1230)
!1248 = !DILocation(line: 102, column: 24, scope: !1230)
!1249 = !DILocation(line: 103, column: 1, scope: !1230)
!1250 = distinct !DISubprogram(name: "vmem_malloc", scope: !79, file: !79, line: 20, type: !1251, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1251 = !DISubroutineType(types: !1252)
!1252 = !{!13, !5}
!1253 = !DILocalVariable(name: "sz", arg: 1, scope: !1250, file: !79, line: 20, type: !5)
!1254 = !DILocation(line: 20, column: 21, scope: !1250)
!1255 = !DILocalVariable(name: "ptr", scope: !1250, file: !79, line: 22, type: !13)
!1256 = !DILocation(line: 22, column: 11, scope: !1250)
!1257 = !DILocation(line: 22, column: 24, scope: !1250)
!1258 = !DILocation(line: 22, column: 17, scope: !1250)
!1259 = !DILocation(line: 23, column: 9, scope: !1260)
!1260 = distinct !DILexicalBlock(scope: !1250, file: !79, line: 23, column: 9)
!1261 = !DILocation(line: 23, column: 9, scope: !1250)
!1262 = !DILocation(line: 25, column: 9, scope: !1263)
!1263 = distinct !DILexicalBlock(scope: !1260, file: !79, line: 23, column: 14)
!1264 = !DILocation(line: 27, column: 5, scope: !1263)
!1265 = !DILocation(line: 28, column: 9, scope: !1266)
!1266 = distinct !DILexicalBlock(scope: !1267, file: !79, line: 28, column: 9)
!1267 = distinct !DILexicalBlock(scope: !1268, file: !79, line: 28, column: 9)
!1268 = distinct !DILexicalBlock(scope: !1260, file: !79, line: 27, column: 12)
!1269 = !DILocation(line: 30, column: 12, scope: !1250)
!1270 = !DILocation(line: 30, column: 5, scope: !1250)
!1271 = distinct !DISubprogram(name: "ismr_enter", scope: !50, file: !50, line: 41, type: !180, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1272 = !DILocalVariable(name: "tid", arg: 1, scope: !1271, file: !50, line: 41, type: !5)
!1273 = !DILocation(line: 41, column: 20, scope: !1271)
!1274 = !DILocation(line: 43, column: 5, scope: !1271)
!1275 = !DILocation(line: 43, column: 5, scope: !1276)
!1276 = distinct !DILexicalBlock(scope: !1271, file: !50, line: 43, column: 5)
!1277 = !DILocation(line: 43, column: 5, scope: !1278)
!1278 = distinct !DILexicalBlock(scope: !1276, file: !50, line: 43, column: 5)
!1279 = !DILocation(line: 43, column: 5, scope: !1280)
!1280 = distinct !DILexicalBlock(scope: !1278, file: !50, line: 43, column: 5)
!1281 = !DILocation(line: 44, column: 1, scope: !1271)
!1282 = distinct !DISubprogram(name: "vqueue_ub_enq", scope: !33, file: !33, line: 122, type: !1283, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1283 = !DISubroutineType(types: !1284)
!1284 = !{null, !359, !31, !13}
!1285 = !DILocalVariable(name: "q", arg: 1, scope: !1282, file: !33, line: 122, type: !359)
!1286 = !DILocation(line: 122, column: 28, scope: !1282)
!1287 = !DILocalVariable(name: "qnode", arg: 2, scope: !1282, file: !33, line: 122, type: !31)
!1288 = !DILocation(line: 122, column: 49, scope: !1282)
!1289 = !DILocalVariable(name: "data", arg: 3, scope: !1282, file: !33, line: 122, type: !13)
!1290 = !DILocation(line: 122, column: 62, scope: !1282)
!1291 = !DILocation(line: 124, column: 25, scope: !1282)
!1292 = !DILocation(line: 124, column: 28, scope: !1282)
!1293 = !DILocation(line: 124, column: 5, scope: !1282)
!1294 = !DILocation(line: 127, column: 26, scope: !1282)
!1295 = !DILocation(line: 127, column: 33, scope: !1282)
!1296 = !DILocation(line: 127, column: 5, scope: !1282)
!1297 = !DILocation(line: 129, column: 27, scope: !1282)
!1298 = !DILocation(line: 129, column: 30, scope: !1282)
!1299 = !DILocation(line: 129, column: 36, scope: !1282)
!1300 = !DILocation(line: 129, column: 42, scope: !1282)
!1301 = !DILocation(line: 129, column: 5, scope: !1282)
!1302 = !DILocation(line: 131, column: 15, scope: !1282)
!1303 = !DILocation(line: 131, column: 5, scope: !1282)
!1304 = !DILocation(line: 131, column: 8, scope: !1282)
!1305 = !DILocation(line: 131, column: 13, scope: !1282)
!1306 = !DILocation(line: 132, column: 25, scope: !1282)
!1307 = !DILocation(line: 132, column: 28, scope: !1282)
!1308 = !DILocation(line: 132, column: 5, scope: !1282)
!1309 = !DILocation(line: 133, column: 1, scope: !1282)
!1310 = distinct !DISubprogram(name: "ismr_exit", scope: !50, file: !50, line: 83, type: !180, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1311 = !DILocalVariable(name: "tid", arg: 1, scope: !1310, file: !50, line: 83, type: !5)
!1312 = !DILocation(line: 83, column: 19, scope: !1310)
!1313 = !DILocation(line: 85, column: 5, scope: !1310)
!1314 = !DILocation(line: 85, column: 5, scope: !1315)
!1315 = distinct !DILexicalBlock(scope: !1310, file: !50, line: 85, column: 5)
!1316 = !DILocation(line: 85, column: 5, scope: !1317)
!1317 = distinct !DILexicalBlock(scope: !1315, file: !50, line: 85, column: 5)
!1318 = !DILocation(line: 85, column: 5, scope: !1319)
!1319 = distinct !DILexicalBlock(scope: !1317, file: !50, line: 85, column: 5)
!1320 = !DILocation(line: 86, column: 1, scope: !1310)
!1321 = distinct !DISubprogram(name: "vatomicptr_write_rel", scope: !739, file: !739, line: 311, type: !913, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1322 = !DILocalVariable(name: "a", arg: 1, scope: !1321, file: !739, line: 311, type: !915)
!1323 = !DILocation(line: 311, column: 36, scope: !1321)
!1324 = !DILocalVariable(name: "v", arg: 2, scope: !1321, file: !739, line: 311, type: !13)
!1325 = !DILocation(line: 311, column: 45, scope: !1321)
!1326 = !DILocation(line: 315, column: 32, scope: !1321)
!1327 = !DILocation(line: 315, column: 44, scope: !1321)
!1328 = !DILocation(line: 315, column: 47, scope: !1321)
!1329 = !DILocation(line: 313, column: 5, scope: !1321)
!1330 = !{i64 856361}
!1331 = !DILocation(line: 317, column: 1, scope: !1321)
!1332 = distinct !DISubprogram(name: "_queue_retire", scope: !44, file: !44, line: 53, type: !1003, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1333 = !DILocalVariable(name: "node", arg: 1, scope: !1332, file: !44, line: 53, type: !497)
!1334 = !DILocation(line: 53, column: 29, scope: !1332)
!1335 = !DILocalVariable(name: "arg", arg: 2, scope: !1332, file: !44, line: 53, type: !13)
!1336 = !DILocation(line: 53, column: 41, scope: !1332)
!1337 = !DILocation(line: 61, column: 15, scope: !1332)
!1338 = !DILocation(line: 61, column: 5, scope: !1332)
!1339 = !DILocation(line: 63, column: 5, scope: !1332)
!1340 = !DILocation(line: 63, column: 5, scope: !1341)
!1341 = distinct !DILexicalBlock(scope: !1332, file: !44, line: 63, column: 5)
!1342 = !DILocation(line: 63, column: 5, scope: !1343)
!1343 = distinct !DILexicalBlock(scope: !1341, file: !44, line: 63, column: 5)
!1344 = !DILocation(line: 63, column: 5, scope: !1345)
!1345 = distinct !DILexicalBlock(scope: !1343, file: !44, line: 63, column: 5)
!1346 = !DILocation(line: 64, column: 1, scope: !1332)
!1347 = distinct !DISubprogram(name: "vqueue_ub_empty", scope: !33, file: !33, line: 143, type: !1348, scopeLine: 144, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1348 = !DISubroutineType(types: !1349)
!1349 = !{!24, !359}
!1350 = !DILocalVariable(name: "q", arg: 1, scope: !1347, file: !33, line: 143, type: !359)
!1351 = !DILocation(line: 143, column: 30, scope: !1347)
!1352 = !DILocalVariable(name: "qnode", scope: !1347, file: !33, line: 145, type: !31)
!1353 = !DILocation(line: 145, column: 23, scope: !1347)
!1354 = !DILocalVariable(name: "head", scope: !1347, file: !33, line: 146, type: !31)
!1355 = !DILocation(line: 146, column: 23, scope: !1347)
!1356 = !DILocation(line: 148, column: 25, scope: !1347)
!1357 = !DILocation(line: 148, column: 28, scope: !1347)
!1358 = !DILocation(line: 148, column: 5, scope: !1347)
!1359 = !DILocation(line: 149, column: 12, scope: !1347)
!1360 = !DILocation(line: 149, column: 15, scope: !1347)
!1361 = !DILocation(line: 149, column: 10, scope: !1347)
!1362 = !DILocation(line: 151, column: 54, scope: !1347)
!1363 = !DILocation(line: 151, column: 60, scope: !1347)
!1364 = !DILocation(line: 151, column: 33, scope: !1347)
!1365 = !DILocation(line: 151, column: 13, scope: !1347)
!1366 = !DILocation(line: 151, column: 11, scope: !1347)
!1367 = !DILocation(line: 152, column: 25, scope: !1347)
!1368 = !DILocation(line: 152, column: 28, scope: !1347)
!1369 = !DILocation(line: 152, column: 5, scope: !1347)
!1370 = !DILocation(line: 153, column: 12, scope: !1347)
!1371 = !DILocation(line: 153, column: 18, scope: !1347)
!1372 = !DILocation(line: 153, column: 5, scope: !1347)
