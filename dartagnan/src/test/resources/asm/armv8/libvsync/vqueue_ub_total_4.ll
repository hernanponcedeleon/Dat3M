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
@.str = private unnamed_addr constant [35 x i8] c"deq_1->key == 2 || deq_1->key == 3\00", align 1
@.str.1 = private unnamed_addr constant [78 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/unbounded/verify/test_case_4.h\00", align 1
@__PRETTY_FUNCTION__.t2 = private unnamed_addr constant [17 x i8] c"void t2(vsize_t)\00", align 1
@.str.2 = private unnamed_addr constant [11 x i8] c"g_len == 1\00", align 1
@__PRETTY_FUNCTION__.verify = private unnamed_addr constant [18 x i8] c"void verify(void)\00", align 1
@.str.3 = private unnamed_addr constant [11 x i8] c"g_len == 2\00", align 1
@g_final_state = dso_local global [5 x i64] zeroinitializer, align 16, !dbg !166
@.str.4 = private unnamed_addr constant [47 x i8] c"g_final_state[0] == 2 || g_final_state[0] == 3\00", align 1
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
  br i1 %6, label %7, label %22, !dbg !210

7:                                                ; preds = %1
  %8 = load %struct.data_s*, %struct.data_s** @deq_1, align 8, !dbg !211
  %9 = getelementptr inbounds %struct.data_s, %struct.data_s* %8, i32 0, i32 0, !dbg !211
  %10 = load i64, i64* %9, align 8, !dbg !211
  %11 = icmp eq i64 %10, 2, !dbg !211
  br i1 %11, label %17, label %12, !dbg !211

12:                                               ; preds = %7
  %13 = load %struct.data_s*, %struct.data_s** @deq_1, align 8, !dbg !211
  %14 = getelementptr inbounds %struct.data_s, %struct.data_s* %13, i32 0, i32 0, !dbg !211
  %15 = load i64, i64* %14, align 8, !dbg !211
  %16 = icmp eq i64 %15, 3, !dbg !211
  br i1 %16, label %17, label %18, !dbg !215

17:                                               ; preds = %12, %7
  br label %19, !dbg !215

18:                                               ; preds = %12
  call void @__assert_fail(i8* noundef getelementptr inbounds ([35 x i8], [35 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t2, i64 0, i64 0)) #5, !dbg !211
  unreachable, !dbg !211

19:                                               ; preds = %17
  %20 = load %struct.data_s*, %struct.data_s** @deq_1, align 8, !dbg !216
  %21 = bitcast %struct.data_s* %20 to i8*, !dbg !216
  call void @free(i8* noundef %21) #6, !dbg !217
  br label %23, !dbg !218

22:                                               ; preds = %1
  call void @verification_ignore(), !dbg !219
  br label %23

23:                                               ; preds = %22, %19
  ret void, !dbg !221
}

; Function Attrs: noinline nounwind uwtable
define dso_local %struct.data_s* @deq(i64 noundef %0) #0 !dbg !222 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !225, metadata !DIExpression()), !dbg !226
  %3 = load i64, i64* %2, align 8, !dbg !227
  %4 = call i8* @queue_deq(i64 noundef %3, %struct.vqueue_ub_s* noundef @g_queue), !dbg !228
  %5 = bitcast i8* %4 to %struct.data_s*, !dbg !228
  ret %struct.data_s* %5, !dbg !229
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @verification_ignore() #0 !dbg !230 {
  %1 = call i32 (i32, ...) bitcast (i32 (...)* @__VERIFIER_assume to i32 (i32, ...)*)(i32 noundef 0), !dbg !234
  ret void, !dbg !235
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @t3(i64 noundef %0) #0 !dbg !236 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !237, metadata !DIExpression()), !dbg !238
  %3 = load i64, i64* %2, align 8, !dbg !239
  call void @enq(i64 noundef %3, i64 noundef 3, i8 noundef signext 66), !dbg !240
  %4 = load i64, i64* %2, align 8, !dbg !241
  call void @queue_clean(i64 noundef %4), !dbg !242
  ret void, !dbg !243
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_clean(i64 noundef %0) #0 !dbg !244 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !245, metadata !DIExpression()), !dbg !246
  %3 = load i64, i64* %2, align 8, !dbg !247
  call void @ismr_recycle(i64 noundef %3), !dbg !248
  ret void, !dbg !249
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @verify() #0 !dbg !250 {
  %1 = load %struct.data_s*, %struct.data_s** @deq_1, align 8, !dbg !251
  %2 = icmp ne %struct.data_s* %1, null, !dbg !251
  br i1 %2, label %3, label %9, !dbg !253

3:                                                ; preds = %0
  %4 = load i64, i64* @g_len, align 8, !dbg !254
  %5 = icmp eq i64 %4, 1, !dbg !254
  br i1 %5, label %6, label %7, !dbg !258

6:                                                ; preds = %3
  br label %8, !dbg !258

7:                                                ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 58, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !254
  unreachable, !dbg !254

8:                                                ; preds = %6
  br label %15, !dbg !259

9:                                                ; preds = %0
  %10 = load i64, i64* @g_len, align 8, !dbg !260
  %11 = icmp eq i64 %10, 2, !dbg !260
  br i1 %11, label %12, label %13, !dbg !264

12:                                               ; preds = %9
  br label %14, !dbg !264

13:                                               ; preds = %9
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 60, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !260
  unreachable, !dbg !260

14:                                               ; preds = %12
  br label %15

15:                                               ; preds = %14, %8
  %16 = load i64, i64* getelementptr inbounds ([5 x i64], [5 x i64]* @g_final_state, i64 0, i64 0), align 16, !dbg !265
  %17 = icmp eq i64 %16, 2, !dbg !265
  br i1 %17, label %21, label %18, !dbg !265

18:                                               ; preds = %15
  %19 = load i64, i64* getelementptr inbounds ([5 x i64], [5 x i64]* @g_final_state, i64 0, i64 0), align 16, !dbg !265
  %20 = icmp eq i64 %19, 3, !dbg !265
  br i1 %20, label %21, label %22, !dbg !268

21:                                               ; preds = %18, %15
  br label %23, !dbg !268

22:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i64 0, i64 0), i32 noundef 62, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.verify, i64 0, i64 0)) #5, !dbg !265
  unreachable, !dbg !265

23:                                               ; preds = %21
  ret void, !dbg !269
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !270 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @init(), !dbg !273
  call void @launch_threads(i64 noundef 3, i8* (i8*)* noundef @run), !dbg !274
  call void @queue_print(%struct.vqueue_ub_s* noundef @g_queue, void (i8*)* noundef @get_final_state), !dbg !275
  call void @verify(), !dbg !276
  call void @destroy(), !dbg !277
  %2 = call zeroext i1 @vmem_no_leak(), !dbg !278
  br i1 %2, label %3, label %4, !dbg !281

3:                                                ; preds = %0
  br label %5, !dbg !281

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.6, i64 0, i64 0), i32 noundef 58, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !278
  unreachable, !dbg !278

5:                                                ; preds = %3
  ret i32 0, !dbg !282
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !283 {
  %1 = alloca i8*, align 8
  call void @queue_init(%struct.vqueue_ub_s* noundef @g_queue), !dbg !284
  call void @queue_register(i64 noundef 0, %struct.vqueue_ub_s* noundef @g_queue), !dbg !285
  call void @enq(i64 noundef 0, i64 noundef 0, i8 noundef signext 97), !dbg !286
  call void @llvm.dbg.declare(metadata i8** %1, metadata !287, metadata !DIExpression()), !dbg !288
  %2 = call %struct.data_s* @deq(i64 noundef 0), !dbg !289
  %3 = bitcast %struct.data_s* %2 to i8*, !dbg !289
  store i8* %3, i8** %1, align 8, !dbg !288
  %4 = load i8*, i8** %1, align 8, !dbg !290
  call void @free(i8* noundef %4) #6, !dbg !291
  call void @queue_deregister(i64 noundef 0, %struct.vqueue_ub_s* noundef @g_queue), !dbg !292
  ret void, !dbg !293
}

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !294 {
  %3 = alloca i64, align 8
  %4 = alloca i8* (i8*)*, align 8
  %5 = alloca %struct.run_info_t*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !297, metadata !DIExpression()), !dbg !298
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %4, metadata !299, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !301, metadata !DIExpression()), !dbg !302
  %6 = load i64, i64* %3, align 8, !dbg !303
  %7 = mul i64 32, %6, !dbg !304
  %8 = call noalias i8* @malloc(i64 noundef %7) #6, !dbg !305
  %9 = bitcast i8* %8 to %struct.run_info_t*, !dbg !305
  store %struct.run_info_t* %9, %struct.run_info_t** %5, align 8, !dbg !302
  %10 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !306
  %11 = load i64, i64* %3, align 8, !dbg !307
  %12 = load i8* (i8*)*, i8* (i8*)** %4, align 8, !dbg !308
  call void @create_threads(%struct.run_info_t* noundef %10, i64 noundef %11, i8* (i8*)* noundef %12, i1 noundef zeroext true), !dbg !309
  %13 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !310
  %14 = load i64, i64* %3, align 8, !dbg !311
  call void @await_threads(%struct.run_info_t* noundef %13, i64 noundef %14), !dbg !312
  %15 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !313
  %16 = bitcast %struct.run_info_t* %15 to i8*, !dbg !313
  call void @free(i8* noundef %16) #6, !dbg !314
  ret void, !dbg !315
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !316 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !317, metadata !DIExpression()), !dbg !318
  call void @llvm.dbg.declare(metadata i64* %3, metadata !319, metadata !DIExpression()), !dbg !320
  %4 = load i8*, i8** %2, align 8, !dbg !321
  %5 = ptrtoint i8* %4 to i64, !dbg !322
  store i64 %5, i64* %3, align 8, !dbg !320
  %6 = load i64, i64* %3, align 8, !dbg !323
  call void @queue_register(i64 noundef %6, %struct.vqueue_ub_s* noundef @g_queue), !dbg !324
  %7 = load i64, i64* %3, align 8, !dbg !325
  switch i64 %7, label %14 [
    i64 0, label %8
    i64 1, label %10
    i64 2, label %12
  ], !dbg !326

8:                                                ; preds = %1
  %9 = load i64, i64* %3, align 8, !dbg !327
  call void @t1(i64 noundef %9), !dbg !329
  br label %18, !dbg !330

10:                                               ; preds = %1
  %11 = load i64, i64* %3, align 8, !dbg !331
  call void @t2(i64 noundef %11), !dbg !332
  br label %18, !dbg !333

12:                                               ; preds = %1
  %13 = load i64, i64* %3, align 8, !dbg !334
  call void @t3(i64 noundef %13), !dbg !335
  br label %18, !dbg !336

14:                                               ; preds = %1
  br i1 true, label %15, label %16, !dbg !337

15:                                               ; preds = %14
  br label %17, !dbg !337

16:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([41 x i8], [41 x i8]* @.str.10, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.6, i64 0, i64 0), i32 noundef 141, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !339
  unreachable, !dbg !339

17:                                               ; preds = %15
  br label %18, !dbg !341

18:                                               ; preds = %17, %12, %10, %8
  %19 = load i64, i64* %3, align 8, !dbg !342
  call void @queue_deregister(i64 noundef %19, %struct.vqueue_ub_s* noundef @g_queue), !dbg !343
  ret i8* null, !dbg !344
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_print(%struct.vqueue_ub_s* noundef %0, void (i8*)* noundef %1) #0 !dbg !345 {
  %3 = alloca %struct.vqueue_ub_s*, align 8
  %4 = alloca void (i8*)*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %3, metadata !349, metadata !DIExpression()), !dbg !350
  store void (i8*)* %1, void (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata void (i8*)** %4, metadata !351, metadata !DIExpression()), !dbg !352
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %3, align 8, !dbg !353
  %6 = load void (i8*)*, void (i8*)** %4, align 8, !dbg !354
  %7 = bitcast void (i8*)* %6 to i8*, !dbg !355
  call void @_vqueue_ub_visit_nodes(%struct.vqueue_ub_s* noundef %5, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_redirect_print, i8* noundef %7), !dbg !356
  ret void, !dbg !357
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @get_final_state(i8* noundef %0) #0 !dbg !358 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.data_s*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !359, metadata !DIExpression()), !dbg !360
  %4 = load i8*, i8** %2, align 8, !dbg !361
  %5 = icmp ne i8* %4, null, !dbg !361
  br i1 %5, label %6, label %7, !dbg !364

6:                                                ; preds = %1
  br label %8, !dbg !364

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.7, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.6, i64 0, i64 0), i32 noundef 119, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.get_final_state, i64 0, i64 0)) #5, !dbg !361
  unreachable, !dbg !361

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata %struct.data_s** %3, metadata !365, metadata !DIExpression()), !dbg !366
  %9 = load i8*, i8** %2, align 8, !dbg !367
  %10 = bitcast i8* %9 to %struct.data_s*, !dbg !367
  store %struct.data_s* %10, %struct.data_s** %3, align 8, !dbg !366
  %11 = load i64, i64* @g_len, align 8, !dbg !368
  %12 = icmp ult i64 %11, 5, !dbg !368
  br i1 %12, label %13, label %14, !dbg !371

13:                                               ; preds = %8
  br label %15, !dbg !371

14:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.8, i64 0, i64 0), i8* noundef getelementptr inbounds ([89 x i8], [89 x i8]* @.str.6, i64 0, i64 0), i32 noundef 121, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.get_final_state, i64 0, i64 0)) #5, !dbg !368
  unreachable, !dbg !368

15:                                               ; preds = %13
  %16 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !372
  %17 = getelementptr inbounds %struct.data_s, %struct.data_s* %16, i32 0, i32 0, !dbg !373
  %18 = load i64, i64* %17, align 8, !dbg !373
  %19 = load i64, i64* @g_len, align 8, !dbg !374
  %20 = add i64 %19, 1, !dbg !374
  store i64 %20, i64* @g_len, align 8, !dbg !374
  %21 = getelementptr inbounds [5 x i64], [5 x i64]* @g_final_state, i64 0, i64 %19, !dbg !375
  store i64 %18, i64* %21, align 8, !dbg !376
  ret void, !dbg !377
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @destroy() #0 !dbg !378 {
  call void @queue_destroy(%struct.vqueue_ub_s* noundef @g_queue), !dbg !379
  ret void, !dbg !380
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @vmem_no_leak() #0 !dbg !381 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !384, metadata !DIExpression()), !dbg !385
  %3 = call i64 @vmem_get_alloc_count(), !dbg !386
  store i64 %3, i64* %1, align 8, !dbg !385
  call void @llvm.dbg.declare(metadata i64* %2, metadata !387, metadata !DIExpression()), !dbg !388
  %4 = call i64 @vmem_get_free_count(), !dbg !389
  store i64 %4, i64* %2, align 8, !dbg !388
  %5 = load i64, i64* %1, align 8, !dbg !390
  %6 = load i64, i64* %2, align 8, !dbg !391
  %7 = icmp eq i64 %5, %6, !dbg !392
  ret i1 %7, !dbg !393
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_init(%struct.vqueue_ub_s* noundef %0) #0 !dbg !394 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !398, metadata !DIExpression()), !dbg !399
  call void @ismr_init(), !dbg !400
  %3 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !401
  call void @vqueue_ub_init(%struct.vqueue_ub_s* noundef %3), !dbg !402
  ret void, !dbg !403
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_register(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !404 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !407, metadata !DIExpression()), !dbg !408
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !409, metadata !DIExpression()), !dbg !410
  %5 = load i64, i64* %3, align 8, !dbg !411
  call void @ismr_reg(i64 noundef %5), !dbg !412
  br label %6, !dbg !413

6:                                                ; preds = %2
  br label %7, !dbg !414

7:                                                ; preds = %6
  %8 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !416
  br label %9, !dbg !416

9:                                                ; preds = %7
  br label %10, !dbg !418

10:                                               ; preds = %9
  br label %11, !dbg !416

11:                                               ; preds = %10
  br label %12, !dbg !414

12:                                               ; preds = %11
  ret void, !dbg !420
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_deregister(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !421 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !422, metadata !DIExpression()), !dbg !423
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !424, metadata !DIExpression()), !dbg !425
  %5 = load i64, i64* %3, align 8, !dbg !426
  call void @ismr_dereg(i64 noundef %5), !dbg !427
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
define internal void @queue_destroy(%struct.vqueue_ub_s* noundef %0) #0 !dbg !436 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !437, metadata !DIExpression()), !dbg !438
  call void @llvm.dbg.declare(metadata i8** %3, metadata !439, metadata !DIExpression()), !dbg !440
  store i8* null, i8** %3, align 8, !dbg !440
  br label %4, !dbg !441

4:                                                ; preds = %9, %1
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !442
  %6 = call i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %5, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_queue_destroy, i8* noundef null), !dbg !443
  store i8* %6, i8** %3, align 8, !dbg !444
  %7 = load i8*, i8** %3, align 8, !dbg !445
  %8 = icmp ne i8* %7, null, !dbg !441
  br i1 %8, label %9, label %11, !dbg !441

9:                                                ; preds = %4
  %10 = load i8*, i8** %3, align 8, !dbg !446
  call void @free(i8* noundef %10) #6, !dbg !448
  br label %4, !dbg !441, !llvm.loop !449

11:                                               ; preds = %4
  %12 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !452
  call void @vqueue_ub_destroy(%struct.vqueue_ub_s* noundef %12, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_queue_destroy, i8* noundef null), !dbg !453
  call void @ismr_destroy(), !dbg !454
  %13 = call zeroext i1 @vmem_no_leak(), !dbg !455
  br i1 %13, label %14, label %15, !dbg !458

14:                                               ; preds = %11
  br label %16, !dbg !458

15:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([97 x i8], [97 x i8]* @.str.15, i64 0, i64 0), i32 noundef 166, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.queue_destroy, i64 0, i64 0)) #5, !dbg !455
  unreachable, !dbg !455

16:                                               ; preds = %14
  ret void, !dbg !459
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_enq(i64 noundef %0, %struct.vqueue_ub_s* noundef %1, i64 noundef %2, i8 noundef signext %3) #0 !dbg !460 {
  %5 = alloca i64, align 8
  %6 = alloca %struct.vqueue_ub_s*, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  %9 = alloca %struct.data_s*, align 8
  %10 = alloca %struct.vqueue_ub_node_s*, align 8
  store i64 %0, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !463, metadata !DIExpression()), !dbg !464
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %6, metadata !465, metadata !DIExpression()), !dbg !466
  store i64 %2, i64* %7, align 8
  call void @llvm.dbg.declare(metadata i64* %7, metadata !467, metadata !DIExpression()), !dbg !468
  store i8 %3, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !469, metadata !DIExpression()), !dbg !470
  call void @llvm.dbg.declare(metadata %struct.data_s** %9, metadata !471, metadata !DIExpression()), !dbg !472
  %11 = call noalias i8* @malloc(i64 noundef 16) #6, !dbg !473
  %12 = bitcast i8* %11 to %struct.data_s*, !dbg !473
  store %struct.data_s* %12, %struct.data_s** %9, align 8, !dbg !472
  %13 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !474
  %14 = icmp ne %struct.data_s* %13, null, !dbg !474
  br i1 %14, label %15, label %30, !dbg !476

15:                                               ; preds = %4
  %16 = load i64, i64* %7, align 8, !dbg !477
  %17 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !479
  %18 = getelementptr inbounds %struct.data_s, %struct.data_s* %17, i32 0, i32 0, !dbg !480
  store i64 %16, i64* %18, align 8, !dbg !481
  %19 = load i8, i8* %8, align 1, !dbg !482
  %20 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !483
  %21 = getelementptr inbounds %struct.data_s, %struct.data_s* %20, i32 0, i32 1, !dbg !484
  store i8 %19, i8* %21, align 8, !dbg !485
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %10, metadata !486, metadata !DIExpression()), !dbg !489
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %10, align 8, !dbg !489
  %22 = call i8* @vmem_malloc(i64 noundef 16), !dbg !490
  %23 = bitcast i8* %22 to %struct.vqueue_ub_node_s*, !dbg !490
  store %struct.vqueue_ub_node_s* %23, %struct.vqueue_ub_node_s** %10, align 8, !dbg !491
  %24 = load i64, i64* %5, align 8, !dbg !492
  call void @ismr_enter(i64 noundef %24), !dbg !493
  %25 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %6, align 8, !dbg !494
  %26 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !495
  %27 = load %struct.data_s*, %struct.data_s** %9, align 8, !dbg !496
  %28 = bitcast %struct.data_s* %27 to i8*, !dbg !496
  call void @vqueue_ub_enq(%struct.vqueue_ub_s* noundef %25, %struct.vqueue_ub_node_s* noundef %26, i8* noundef %28), !dbg !497
  %29 = load i64, i64* %5, align 8, !dbg !498
  call void @ismr_exit(i64 noundef %29), !dbg !499
  br label %31, !dbg !500

30:                                               ; preds = %4
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.14, i64 0, i64 0), i8* noundef getelementptr inbounds ([97 x i8], [97 x i8]* @.str.15, i64 0, i64 0), i32 noundef 196, i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @__PRETTY_FUNCTION__.queue_enq, i64 0, i64 0)) #5, !dbg !501
  unreachable, !dbg !501

31:                                               ; preds = %15
  ret void, !dbg !505
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @queue_deq(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !506 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca i8*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !509, metadata !DIExpression()), !dbg !510
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !511, metadata !DIExpression()), !dbg !512
  %6 = load i64, i64* %3, align 8, !dbg !513
  call void @ismr_enter(i64 noundef %6), !dbg !514
  call void @llvm.dbg.declare(metadata i8** %5, metadata !515, metadata !DIExpression()), !dbg !516
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !517
  %8 = load i64, i64* %3, align 8, !dbg !518
  %9 = inttoptr i64 %8 to i8*, !dbg !519
  %10 = call i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %7, void (%struct.vqueue_ub_node_s*, i8*)* noundef @_queue_retire, i8* noundef %9), !dbg !520
  store i8* %10, i8** %5, align 8, !dbg !516
  %11 = load i64, i64* %3, align 8, !dbg !521
  call void @ismr_exit(i64 noundef %11), !dbg !522
  %12 = load i8*, i8** %5, align 8, !dbg !523
  ret i8* %12, !dbg !524
}

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @empty(i64 noundef %0) #0 !dbg !525 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !528, metadata !DIExpression()), !dbg !529
  %3 = load i64, i64* %2, align 8, !dbg !530
  %4 = call zeroext i1 @queue_empty(i64 noundef %3, %struct.vqueue_ub_s* noundef @g_queue), !dbg !531
  ret i1 %4, !dbg !532
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @queue_empty(i64 noundef %0, %struct.vqueue_ub_s* noundef %1) #0 !dbg !533 {
  %3 = alloca i64, align 8
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca i8, align 1
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !536, metadata !DIExpression()), !dbg !537
  store %struct.vqueue_ub_s* %1, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !538, metadata !DIExpression()), !dbg !539
  %6 = load i64, i64* %3, align 8, !dbg !540
  call void @ismr_enter(i64 noundef %6), !dbg !541
  call void @llvm.dbg.declare(metadata i8* %5, metadata !542, metadata !DIExpression()), !dbg !543
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !544
  %8 = call zeroext i1 @vqueue_ub_empty(%struct.vqueue_ub_s* noundef %7), !dbg !545
  %9 = zext i1 %8 to i8, !dbg !543
  store i8 %9, i8* %5, align 1, !dbg !543
  %10 = load i64, i64* %3, align 8, !dbg !546
  call void @ismr_exit(i64 noundef %10), !dbg !547
  %11 = load i8, i8* %5, align 1, !dbg !548
  %12 = trunc i8 %11 to i1, !dbg !548
  ret i1 %12, !dbg !549
}

declare i32 @__VERIFIER_assume(...) #4

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_recycle(i64 noundef %0) #0 !dbg !550 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !551, metadata !DIExpression()), !dbg !552
  br label %3, !dbg !553

3:                                                ; preds = %1
  br label %4, !dbg !554

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !556
  br label %6, !dbg !556

6:                                                ; preds = %4
  br label %7, !dbg !558

7:                                                ; preds = %6
  br label %8, !dbg !556

8:                                                ; preds = %7
  br label %9, !dbg !554

9:                                                ; preds = %8
  ret void, !dbg !560
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !561 {
  %5 = alloca %struct.run_info_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8* (i8*)*, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !564, metadata !DIExpression()), !dbg !565
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !566, metadata !DIExpression()), !dbg !567
  store i8* (i8*)* %2, i8* (i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %7, metadata !568, metadata !DIExpression()), !dbg !569
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !570, metadata !DIExpression()), !dbg !571
  call void @llvm.dbg.declare(metadata i64* %9, metadata !572, metadata !DIExpression()), !dbg !573
  store i64 0, i64* %9, align 8, !dbg !573
  store i64 0, i64* %9, align 8, !dbg !574
  br label %11, !dbg !576

11:                                               ; preds = %42, %4
  %12 = load i64, i64* %9, align 8, !dbg !577
  %13 = load i64, i64* %6, align 8, !dbg !579
  %14 = icmp ult i64 %12, %13, !dbg !580
  br i1 %14, label %15, label %45, !dbg !581

15:                                               ; preds = %11
  %16 = load i64, i64* %9, align 8, !dbg !582
  %17 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !584
  %18 = load i64, i64* %9, align 8, !dbg !585
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %17, i64 %18, !dbg !584
  %20 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %19, i32 0, i32 1, !dbg !586
  store i64 %16, i64* %20, align 8, !dbg !587
  %21 = load i8* (i8*)*, i8* (i8*)** %7, align 8, !dbg !588
  %22 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !589
  %23 = load i64, i64* %9, align 8, !dbg !590
  %24 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %22, i64 %23, !dbg !589
  %25 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %24, i32 0, i32 3, !dbg !591
  store i8* (i8*)* %21, i8* (i8*)** %25, align 8, !dbg !592
  %26 = load i8, i8* %8, align 1, !dbg !593
  %27 = trunc i8 %26 to i1, !dbg !593
  %28 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !594
  %29 = load i64, i64* %9, align 8, !dbg !595
  %30 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %28, i64 %29, !dbg !594
  %31 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %30, i32 0, i32 2, !dbg !596
  %32 = zext i1 %27 to i8, !dbg !597
  store i8 %32, i8* %31, align 8, !dbg !597
  %33 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !598
  %34 = load i64, i64* %9, align 8, !dbg !599
  %35 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %33, i64 %34, !dbg !598
  %36 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %35, i32 0, i32 0, !dbg !600
  %37 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !601
  %38 = load i64, i64* %9, align 8, !dbg !602
  %39 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %37, i64 %38, !dbg !601
  %40 = bitcast %struct.run_info_t* %39 to i8*, !dbg !603
  %41 = call i32 @pthread_create(i64* noundef %36, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %40) #6, !dbg !604
  br label %42, !dbg !605

42:                                               ; preds = %15
  %43 = load i64, i64* %9, align 8, !dbg !606
  %44 = add i64 %43, 1, !dbg !606
  store i64 %44, i64* %9, align 8, !dbg !606
  br label %11, !dbg !607, !llvm.loop !608

45:                                               ; preds = %11
  ret void, !dbg !610
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !611 {
  %3 = alloca %struct.run_info_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !614, metadata !DIExpression()), !dbg !615
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !616, metadata !DIExpression()), !dbg !617
  call void @llvm.dbg.declare(metadata i64* %5, metadata !618, metadata !DIExpression()), !dbg !619
  store i64 0, i64* %5, align 8, !dbg !619
  store i64 0, i64* %5, align 8, !dbg !620
  br label %6, !dbg !622

6:                                                ; preds = %17, %2
  %7 = load i64, i64* %5, align 8, !dbg !623
  %8 = load i64, i64* %4, align 8, !dbg !625
  %9 = icmp ult i64 %7, %8, !dbg !626
  br i1 %9, label %10, label %20, !dbg !627

10:                                               ; preds = %6
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !628
  %12 = load i64, i64* %5, align 8, !dbg !630
  %13 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i64 %12, !dbg !628
  %14 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %13, i32 0, i32 0, !dbg !631
  %15 = load i64, i64* %14, align 8, !dbg !631
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !632
  br label %17, !dbg !633

17:                                               ; preds = %10
  %18 = load i64, i64* %5, align 8, !dbg !634
  %19 = add i64 %18, 1, !dbg !634
  store i64 %19, i64* %5, align 8, !dbg !634
  br label %6, !dbg !635, !llvm.loop !636

20:                                               ; preds = %6
  ret void, !dbg !638
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !639 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.run_info_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !640, metadata !DIExpression()), !dbg !641
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !642, metadata !DIExpression()), !dbg !643
  %4 = load i8*, i8** %2, align 8, !dbg !644
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !645
  store %struct.run_info_t* %5, %struct.run_info_t** %3, align 8, !dbg !643
  %6 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !646
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %6, i32 0, i32 2, !dbg !648
  %8 = load i8, i8* %7, align 8, !dbg !648
  %9 = trunc i8 %8 to i1, !dbg !648
  br i1 %9, label %10, label %14, !dbg !649

10:                                               ; preds = %1
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !650
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i32 0, i32 1, !dbg !651
  %13 = load i64, i64* %12, align 8, !dbg !651
  call void @set_cpu_affinity(i64 noundef %13), !dbg !652
  br label %14, !dbg !652

14:                                               ; preds = %10, %1
  %15 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !653
  %16 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %15, i32 0, i32 3, !dbg !654
  %17 = load i8* (i8*)*, i8* (i8*)** %16, align 8, !dbg !654
  %18 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !655
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %18, i32 0, i32 1, !dbg !656
  %20 = load i64, i64* %19, align 8, !dbg !656
  %21 = inttoptr i64 %20 to i8*, !dbg !657
  %22 = call i8* %17(i8* noundef %21), !dbg !653
  ret i8* %22, !dbg !658
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !659 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !660, metadata !DIExpression()), !dbg !661
  br label %3, !dbg !662

3:                                                ; preds = %1
  br label %4, !dbg !663

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !665
  br label %6, !dbg !665

6:                                                ; preds = %4
  br label %7, !dbg !667

7:                                                ; preds = %6
  br label %8, !dbg !665

8:                                                ; preds = %7
  br label %9, !dbg !663

9:                                                ; preds = %8
  ret void, !dbg !669
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @_vqueue_ub_visit_nodes(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !670 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !679, metadata !DIExpression()), !dbg !680
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !681, metadata !DIExpression()), !dbg !682
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !683, metadata !DIExpression()), !dbg !684
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !685, metadata !DIExpression()), !dbg !686
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !686
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !687, metadata !DIExpression()), !dbg !688
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !688
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !689
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 2, !dbg !690
  %11 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !690
  store %struct.vqueue_ub_node_s* %11, %struct.vqueue_ub_node_s** %7, align 8, !dbg !691
  %12 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !692
  %13 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %12, i32 0, i32 1, !dbg !693
  %14 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %13), !dbg !694
  %15 = bitcast i8* %14 to %struct.vqueue_ub_node_s*, !dbg !695
  store %struct.vqueue_ub_node_s* %15, %struct.vqueue_ub_node_s** %7, align 8, !dbg !696
  br label %16, !dbg !697

16:                                               ; preds = %19, %3
  %17 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !698
  %18 = icmp ne %struct.vqueue_ub_node_s* %17, null, !dbg !697
  br i1 %18, label %19, label %28, !dbg !697

19:                                               ; preds = %16
  %20 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !699
  %21 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %20, i32 0, i32 1, !dbg !701
  %22 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %21), !dbg !702
  %23 = bitcast i8* %22 to %struct.vqueue_ub_node_s*, !dbg !703
  store %struct.vqueue_ub_node_s* %23, %struct.vqueue_ub_node_s** %8, align 8, !dbg !704
  %24 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !705
  %25 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !706
  %26 = load i8*, i8** %6, align 8, !dbg !707
  call void %24(%struct.vqueue_ub_node_s* noundef %25, i8* noundef %26), !dbg !705
  %27 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !708
  store %struct.vqueue_ub_node_s* %27, %struct.vqueue_ub_node_s** %7, align 8, !dbg !709
  br label %16, !dbg !697, !llvm.loop !710

28:                                               ; preds = %16
  ret void, !dbg !712
}

; Function Attrs: noinline nounwind uwtable
define internal void @_redirect_print(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !713 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca void (i8*)*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !716, metadata !DIExpression()), !dbg !717
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !718, metadata !DIExpression()), !dbg !719
  call void @llvm.dbg.declare(metadata void (i8*)** %5, metadata !720, metadata !DIExpression()), !dbg !721
  %6 = load i8*, i8** %4, align 8, !dbg !722
  %7 = bitcast i8* %6 to void (i8*)*, !dbg !723
  store void (i8*)* %7, void (i8*)** %5, align 8, !dbg !721
  %8 = load void (i8*)*, void (i8*)** %5, align 8, !dbg !724
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !725
  %10 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %9, i32 0, i32 0, !dbg !726
  %11 = load i8*, i8** %10, align 8, !dbg !726
  call void %8(i8* noundef %11), !dbg !724
  ret void, !dbg !727
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !728 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !734, metadata !DIExpression()), !dbg !735
  call void @llvm.dbg.declare(metadata i8** %3, metadata !736, metadata !DIExpression()), !dbg !737
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !738
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !739
  %6 = load i8*, i8** %5, align 8, !dbg !739
  %7 = call i8* asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !740, !srcloc !741
  store i8* %7, i8** %3, align 8, !dbg !740
  %8 = load i8*, i8** %3, align 8, !dbg !742
  ret i8* %8, !dbg !743
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vmem_get_alloc_count() #0 !dbg !744 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !747, metadata !DIExpression()), !dbg !748
  %2 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef @_g_vmem_alloc_count), !dbg !749
  store i64 %2, i64* %1, align 8, !dbg !748
  br label %3, !dbg !750

3:                                                ; preds = %0
  br label %4, !dbg !751

4:                                                ; preds = %3
  %5 = load i64, i64* %1, align 8, !dbg !753
  br label %6, !dbg !753

6:                                                ; preds = %4
  br label %7, !dbg !755

7:                                                ; preds = %6
  br label %8, !dbg !753

8:                                                ; preds = %7
  br label %9, !dbg !751

9:                                                ; preds = %8
  %10 = load i64, i64* %1, align 8, !dbg !757
  ret i64 %10, !dbg !758
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vmem_get_free_count() #0 !dbg !759 {
  %1 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !760, metadata !DIExpression()), !dbg !761
  %2 = call i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef @_g_vmem_free_count), !dbg !762
  store i64 %2, i64* %1, align 8, !dbg !761
  br label %3, !dbg !763

3:                                                ; preds = %0
  br label %4, !dbg !764

4:                                                ; preds = %3
  %5 = load i64, i64* %1, align 8, !dbg !766
  br label %6, !dbg !766

6:                                                ; preds = %4
  br label %7, !dbg !768

7:                                                ; preds = %6
  br label %8, !dbg !766

8:                                                ; preds = %7
  br label %9, !dbg !764

9:                                                ; preds = %8
  %10 = load i64, i64* %1, align 8, !dbg !770
  ret i64 %10, !dbg !771
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_read_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !772 {
  %2 = alloca %struct.vatomic64_s*, align 8
  %3 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !777, metadata !DIExpression()), !dbg !778
  call void @llvm.dbg.declare(metadata i64* %3, metadata !779, metadata !DIExpression()), !dbg !780
  %4 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !781
  %5 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %4, i32 0, i32 0, !dbg !782
  %6 = load i64, i64* %5, align 8, !dbg !782
  %7 = call i64 asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i64 %6) #6, !dbg !783, !srcloc !784
  store i64 %7, i64* %3, align 8, !dbg !783
  %8 = load i64, i64* %3, align 8, !dbg !785
  ret i64 %8, !dbg !786
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_init() #0 !dbg !787 {
  call void @locked_trace_init(%struct.locked_trace_s* noundef @global_trace, i64 noundef 100), !dbg !788
  ret void, !dbg !789
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_init(%struct.vqueue_ub_s* noundef %0) #0 !dbg !790 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !793, metadata !DIExpression()), !dbg !794
  %3 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !795
  %4 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %3, i32 0, i32 4, !dbg !796
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !797
  %6 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %5, i32 0, i32 2, !dbg !798
  store %struct.vqueue_ub_node_s* %4, %struct.vqueue_ub_node_s** %6, align 8, !dbg !799
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !800
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 4, !dbg !801
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !802
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 3, !dbg !803
  store %struct.vqueue_ub_node_s* %8, %struct.vqueue_ub_node_s** %10, align 8, !dbg !804
  %11 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !805
  %12 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %11, i32 0, i32 4, !dbg !806
  call void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %12, i8* noundef null), !dbg !807
  %13 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !808
  %14 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %13, i32 0, i32 0, !dbg !809
  call void @queue_lock_init(%union.pthread_mutex_t* noundef %14), !dbg !810
  %15 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !811
  %16 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %15, i32 0, i32 1, !dbg !812
  call void @queue_lock_init(%union.pthread_mutex_t* noundef %16), !dbg !813
  ret void, !dbg !814
}

; Function Attrs: noinline nounwind uwtable
define internal void @locked_trace_init(%struct.locked_trace_s* noundef %0, i64 noundef %1) #0 !dbg !815 {
  %3 = alloca %struct.locked_trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.locked_trace_s* %0, %struct.locked_trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.locked_trace_s** %3, metadata !819, metadata !DIExpression()), !dbg !820
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !821, metadata !DIExpression()), !dbg !822
  %5 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !823
  %6 = icmp ne %struct.locked_trace_s* %5, null, !dbg !823
  br i1 %6, label %7, label %8, !dbg !826

7:                                                ; preds = %2
  br label %9, !dbg !826

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([64 x i8], [64 x i8]* @.str.12, i64 0, i64 0), i32 noundef 16, i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @__PRETTY_FUNCTION__.locked_trace_init, i64 0, i64 0)) #5, !dbg !823
  unreachable, !dbg !823

9:                                                ; preds = %7
  %10 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !827
  %11 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %10, i32 0, i32 1, !dbg !828
  %12 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %11, %union.pthread_mutexattr_t* noundef null) #6, !dbg !829
  %13 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !830
  %14 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %13, i32 0, i32 0, !dbg !831
  %15 = load i64, i64* %4, align 8, !dbg !832
  call void @trace_init(%struct.trace_s* noundef %14, i64 noundef %15), !dbg !833
  ret void, !dbg !834
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @trace_init(%struct.trace_s* noundef %0, i64 noundef %1) #0 !dbg !835 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !839, metadata !DIExpression()), !dbg !840
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !841, metadata !DIExpression()), !dbg !842
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !843
  %6 = icmp ne %struct.trace_s* %5, null, !dbg !843
  br i1 %6, label %7, label %8, !dbg !846

7:                                                ; preds = %2
  br label %9, !dbg !846

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 30, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !843
  unreachable, !dbg !843

9:                                                ; preds = %7
  %10 = load i64, i64* %4, align 8, !dbg !847
  %11 = mul i64 %10, 16, !dbg !848
  %12 = call noalias i8* @malloc(i64 noundef %11) #6, !dbg !849
  %13 = bitcast i8* %12 to %struct.trace_unit_s*, !dbg !849
  %14 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !850
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 0, !dbg !851
  store %struct.trace_unit_s* %13, %struct.trace_unit_s** %15, align 8, !dbg !852
  %16 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !853
  %17 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %16, i32 0, i32 0, !dbg !855
  %18 = load %struct.trace_unit_s*, %struct.trace_unit_s** %17, align 8, !dbg !855
  %19 = icmp ne %struct.trace_unit_s* %18, null, !dbg !853
  br i1 %19, label %20, label %28, !dbg !856

20:                                               ; preds = %9
  %21 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !857
  %22 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %21, i32 0, i32 1, !dbg !859
  store i64 0, i64* %22, align 8, !dbg !860
  %23 = load i64, i64* %4, align 8, !dbg !861
  %24 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !862
  %25 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %24, i32 0, i32 2, !dbg !863
  store i64 %23, i64* %25, align 8, !dbg !864
  %26 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !865
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 3, !dbg !866
  store i8 1, i8* %27, align 8, !dbg !867
  br label %35, !dbg !868

28:                                               ; preds = %9
  %29 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !869
  %30 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %29, i32 0, i32 1, !dbg !871
  store i64 0, i64* %30, align 8, !dbg !872
  %31 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !873
  %32 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %31, i32 0, i32 2, !dbg !874
  store i64 0, i64* %32, align 8, !dbg !875
  %33 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !876
  %34 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %33, i32 0, i32 3, !dbg !877
  store i8 0, i8* %34, align 8, !dbg !878
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.14, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 40, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !879
  unreachable, !dbg !879

35:                                               ; preds = %20
  ret void, !dbg !882
}

; Function Attrs: noinline nounwind uwtable
define internal void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !883 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !884, metadata !DIExpression()), !dbg !885
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !886, metadata !DIExpression()), !dbg !887
  %5 = load i8*, i8** %4, align 8, !dbg !888
  %6 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !889
  %7 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %6, i32 0, i32 0, !dbg !890
  store i8* %5, i8** %7, align 8, !dbg !891
  %8 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !892
  %9 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %8, i32 0, i32 1, !dbg !893
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %9, i8* noundef null), !dbg !894
  ret void, !dbg !895
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_init(%union.pthread_mutex_t* noundef %0) #0 !dbg !896 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !900, metadata !DIExpression()), !dbg !901
  %3 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !901
  %4 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %3, %union.pthread_mutexattr_t* noundef null) #6, !dbg !901
  ret void, !dbg !901
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !902 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !906, metadata !DIExpression()), !dbg !907
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !908, metadata !DIExpression()), !dbg !909
  %5 = load i8*, i8** %4, align 8, !dbg !910
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !911
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !912
  %8 = load i8*, i8** %7, align 8, !dbg !912
  call void asm sideeffect "str ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !913, !srcloc !914
  ret void, !dbg !915
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_reg(i64 noundef %0) #0 !dbg !916 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !917, metadata !DIExpression()), !dbg !918
  br label %3, !dbg !919

3:                                                ; preds = %1
  br label %4, !dbg !920

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !922
  br label %6, !dbg !922

6:                                                ; preds = %4
  br label %7, !dbg !924

7:                                                ; preds = %6
  br label %8, !dbg !922

8:                                                ; preds = %7
  br label %9, !dbg !920

9:                                                ; preds = %8
  ret void, !dbg !926
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_dereg(i64 noundef %0) #0 !dbg !927 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !928, metadata !DIExpression()), !dbg !929
  br label %3, !dbg !930

3:                                                ; preds = %1
  br label %4, !dbg !931

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !933
  br label %6, !dbg !933

6:                                                ; preds = %4
  br label %7, !dbg !935

7:                                                ; preds = %6
  br label %8, !dbg !933

8:                                                ; preds = %7
  br label %9, !dbg !931

9:                                                ; preds = %8
  ret void, !dbg !937
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vqueue_ub_deq(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !938 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  %9 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !941, metadata !DIExpression()), !dbg !942
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !943, metadata !DIExpression()), !dbg !944
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !945, metadata !DIExpression()), !dbg !946
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !947, metadata !DIExpression()), !dbg !948
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !948
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !949, metadata !DIExpression()), !dbg !950
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !950
  call void @llvm.dbg.declare(metadata i8** %9, metadata !951, metadata !DIExpression()), !dbg !952
  store i8* null, i8** %9, align 8, !dbg !952
  %10 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !953
  %11 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %10, i32 0, i32 1, !dbg !954
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %11), !dbg !955
  %12 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !956
  %13 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %12, i32 0, i32 2, !dbg !957
  %14 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %13, align 8, !dbg !957
  store %struct.vqueue_ub_node_s* %14, %struct.vqueue_ub_node_s** %8, align 8, !dbg !958
  %15 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !959
  %16 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %15, i32 0, i32 1, !dbg !960
  %17 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %16), !dbg !961
  %18 = bitcast i8* %17 to %struct.vqueue_ub_node_s*, !dbg !962
  store %struct.vqueue_ub_node_s* %18, %struct.vqueue_ub_node_s** %7, align 8, !dbg !963
  %19 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !964
  %20 = icmp ne %struct.vqueue_ub_node_s* %19, null, !dbg !964
  br i1 %20, label %21, label %37, !dbg !966

21:                                               ; preds = %3
  %22 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !967
  %23 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %22, i32 0, i32 0, !dbg !969
  %24 = load i8*, i8** %23, align 8, !dbg !969
  store i8* %24, i8** %9, align 8, !dbg !970
  %25 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !971
  %26 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !972
  %27 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %26, i32 0, i32 2, !dbg !973
  store %struct.vqueue_ub_node_s* %25, %struct.vqueue_ub_node_s** %27, align 8, !dbg !974
  %28 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !975
  %29 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !977
  %30 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %29, i32 0, i32 4, !dbg !978
  %31 = icmp ne %struct.vqueue_ub_node_s* %28, %30, !dbg !979
  br i1 %31, label %32, label %36, !dbg !980

32:                                               ; preds = %21
  %33 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !981
  %34 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !983
  %35 = load i8*, i8** %6, align 8, !dbg !984
  call void %33(%struct.vqueue_ub_node_s* noundef %34, i8* noundef %35), !dbg !981
  br label %36, !dbg !985

36:                                               ; preds = %32, %21
  br label %37, !dbg !986

37:                                               ; preds = %36, %3
  %38 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !987
  %39 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %38, i32 0, i32 1, !dbg !988
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %39), !dbg !989
  %40 = load i8*, i8** %9, align 8, !dbg !990
  ret i8* %40, !dbg !991
}

; Function Attrs: noinline nounwind uwtable
define internal void @_queue_destroy(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !992 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !995, metadata !DIExpression()), !dbg !996
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !997, metadata !DIExpression()), !dbg !998
  %5 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !999
  %6 = bitcast %struct.vqueue_ub_node_s* %5 to i8*, !dbg !999
  call void @vmem_free(i8* noundef %6), !dbg !1000
  br label %7, !dbg !1001

7:                                                ; preds = %2
  br label %8, !dbg !1002

8:                                                ; preds = %7
  %9 = load i8*, i8** %4, align 8, !dbg !1004
  br label %10, !dbg !1004

10:                                               ; preds = %8
  br label %11, !dbg !1006

11:                                               ; preds = %10
  br label %12, !dbg !1004

12:                                               ; preds = %11
  br label %13, !dbg !1002

13:                                               ; preds = %12
  ret void, !dbg !1008
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_destroy(%struct.vqueue_ub_s* noundef %0, void (%struct.vqueue_ub_node_s*, i8*)* noundef %1, i8* noundef %2) #0 !dbg !1009 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca void (%struct.vqueue_ub_node_s*, i8*)*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca %struct.vqueue_ub_node_s*, align 8
  %8 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !1010, metadata !DIExpression()), !dbg !1011
  store void (%struct.vqueue_ub_node_s*, i8*)* %1, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8
  call void @llvm.dbg.declare(metadata void (%struct.vqueue_ub_node_s*, i8*)** %5, metadata !1012, metadata !DIExpression()), !dbg !1013
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !1014, metadata !DIExpression()), !dbg !1015
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %7, metadata !1016, metadata !DIExpression()), !dbg !1017
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1017
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %8, metadata !1018, metadata !DIExpression()), !dbg !1019
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1019
  %9 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1020
  %10 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %9, i32 0, i32 2, !dbg !1021
  %11 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %10, align 8, !dbg !1021
  store %struct.vqueue_ub_node_s* %11, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1022
  br label %12, !dbg !1023

12:                                               ; preds = %28, %3
  %13 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1024
  %14 = icmp ne %struct.vqueue_ub_node_s* %13, null, !dbg !1023
  br i1 %14, label %15, label %30, !dbg !1023

15:                                               ; preds = %12
  %16 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1025
  %17 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %16, i32 0, i32 1, !dbg !1027
  %18 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %17), !dbg !1028
  %19 = bitcast i8* %18 to %struct.vqueue_ub_node_s*, !dbg !1029
  store %struct.vqueue_ub_node_s* %19, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1030
  %20 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1031
  %21 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1033
  %22 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %21, i32 0, i32 4, !dbg !1034
  %23 = icmp ne %struct.vqueue_ub_node_s* %20, %22, !dbg !1035
  br i1 %23, label %24, label %28, !dbg !1036

24:                                               ; preds = %15
  %25 = load void (%struct.vqueue_ub_node_s*, i8*)*, void (%struct.vqueue_ub_node_s*, i8*)** %5, align 8, !dbg !1037
  %26 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1039
  %27 = load i8*, i8** %6, align 8, !dbg !1040
  call void %25(%struct.vqueue_ub_node_s* noundef %26, i8* noundef %27), !dbg !1037
  br label %28, !dbg !1041

28:                                               ; preds = %24, %15
  %29 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1042
  store %struct.vqueue_ub_node_s* %29, %struct.vqueue_ub_node_s** %7, align 8, !dbg !1043
  br label %12, !dbg !1023, !llvm.loop !1044

30:                                               ; preds = %12
  ret void, !dbg !1046
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_destroy() #0 !dbg !1047 {
  call void @locked_trace_destroy(%struct.locked_trace_s* noundef @global_trace, i1 (%struct.trace_unit_s*)* noundef @_ismr_none_destroy_all_cb), !dbg !1048
  ret void, !dbg !1049
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_acquire(%union.pthread_mutex_t* noundef %0) #0 !dbg !1050 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !1051, metadata !DIExpression()), !dbg !1052
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1053, metadata !DIExpression()), !dbg !1052
  %4 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !1052
  %5 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef %4) #6, !dbg !1052
  store i32 %5, i32* %3, align 4, !dbg !1052
  %6 = load i32, i32* %3, align 4, !dbg !1054
  %7 = icmp eq i32 %6, 0, !dbg !1054
  br i1 %7, label %8, label %9, !dbg !1057

8:                                                ; preds = %1
  br label %10, !dbg !1057

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.16, i64 0, i64 0), i8* noundef getelementptr inbounds ([101 x i8], [101 x i8]* @.str.17, i64 0, i64 0), i32 noundef 32, i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.queue_lock_acquire, i64 0, i64 0)) #5, !dbg !1054
  unreachable, !dbg !1054

10:                                               ; preds = %8
  ret void, !dbg !1052
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %0) #0 !dbg !1058 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !1059, metadata !DIExpression()), !dbg !1060
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1061, metadata !DIExpression()), !dbg !1062
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !1063
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !1064
  %6 = load i8*, i8** %5, align 8, !dbg !1064
  %7 = call i8* asm sideeffect "ldar ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !1065, !srcloc !1066
  store i8* %7, i8** %3, align 8, !dbg !1065
  %8 = load i8*, i8** %3, align 8, !dbg !1067
  ret i8* %8, !dbg !1068
}

; Function Attrs: noinline nounwind uwtable
define internal void @queue_lock_release(%union.pthread_mutex_t* noundef %0) #0 !dbg !1069 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  %3 = alloca i32, align 4
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !1070, metadata !DIExpression()), !dbg !1071
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1072, metadata !DIExpression()), !dbg !1071
  %4 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !1071
  %5 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef %4) #6, !dbg !1071
  store i32 %5, i32* %3, align 4, !dbg !1071
  %6 = load i32, i32* %3, align 4, !dbg !1073
  %7 = icmp eq i32 %6, 0, !dbg !1073
  br i1 %7, label %8, label %9, !dbg !1076

8:                                                ; preds = %1
  br label %10, !dbg !1076

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.16, i64 0, i64 0), i8* noundef getelementptr inbounds ([101 x i8], [101 x i8]* @.str.17, i64 0, i64 0), i32 noundef 32, i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.queue_lock_release, i64 0, i64 0)) #5, !dbg !1073
  unreachable, !dbg !1073

10:                                               ; preds = %8
  ret void, !dbg !1071
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @vmem_free(i8* noundef %0) #0 !dbg !1077 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !1078, metadata !DIExpression()), !dbg !1079
  %3 = load i8*, i8** %2, align 8, !dbg !1080
  call void @free(i8* noundef %3) #6, !dbg !1081
  %4 = load i8*, i8** %2, align 8, !dbg !1082
  %5 = icmp ne i8* %4, null, !dbg !1082
  br i1 %5, label %6, label %7, !dbg !1084

6:                                                ; preds = %1
  call void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef @_g_vmem_free_count), !dbg !1085
  br label %7, !dbg !1087

7:                                                ; preds = %6, %1
  ret void, !dbg !1088
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !1089 {
  %2 = alloca %struct.vatomic64_s*, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !1094, metadata !DIExpression()), !dbg !1095
  %3 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !1096
  %4 = call i64 @vatomic64_get_inc_rlx(%struct.vatomic64_s* noundef %3), !dbg !1097
  ret void, !dbg !1098
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_get_inc_rlx(%struct.vatomic64_s* noundef %0) #0 !dbg !1099 {
  %2 = alloca %struct.vatomic64_s*, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %2, metadata !1102, metadata !DIExpression()), !dbg !1103
  %3 = load %struct.vatomic64_s*, %struct.vatomic64_s** %2, align 8, !dbg !1104
  %4 = call i64 @vatomic64_get_add_rlx(%struct.vatomic64_s* noundef %3, i64 noundef 1), !dbg !1105
  ret i64 %4, !dbg !1106
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomic64_get_add_rlx(%struct.vatomic64_s* noundef %0, i64 noundef %1) #0 !dbg !1107 {
  %3 = alloca %struct.vatomic64_s*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  store %struct.vatomic64_s* %0, %struct.vatomic64_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic64_s** %3, metadata !1111, metadata !DIExpression()), !dbg !1112
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1113, metadata !DIExpression()), !dbg !1114
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1115, metadata !DIExpression()), !dbg !1116
  call void @llvm.dbg.declare(metadata i32* %6, metadata !1117, metadata !DIExpression()), !dbg !1121
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1122, metadata !DIExpression()), !dbg !1123
  %8 = load i64, i64* %4, align 8, !dbg !1124
  %9 = load %struct.vatomic64_s*, %struct.vatomic64_s** %3, align 8, !dbg !1125
  %10 = getelementptr inbounds %struct.vatomic64_s, %struct.vatomic64_s* %9, i32 0, i32 0, !dbg !1126
  %11 = load i64, i64* %10, align 8, !dbg !1126
  %12 = call { i64, i64, i32, i64 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:x}, $4\0Aadd ${1:x}, ${0:x}, ${3:x}\0Astxr ${2:w}, ${1:x}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i64 %11, i64 %8) #6, !dbg !1124, !srcloc !1127
  %13 = extractvalue { i64, i64, i32, i64 } %12, 0, !dbg !1124
  %14 = extractvalue { i64, i64, i32, i64 } %12, 1, !dbg !1124
  %15 = extractvalue { i64, i64, i32, i64 } %12, 2, !dbg !1124
  %16 = extractvalue { i64, i64, i32, i64 } %12, 3, !dbg !1124
  store i64 %13, i64* %5, align 8, !dbg !1124
  store i64 %14, i64* %7, align 8, !dbg !1124
  store i32 %15, i32* %6, align 4, !dbg !1124
  store i64 %16, i64* %4, align 8, !dbg !1124
  %17 = load i64, i64* %5, align 8, !dbg !1128
  ret i64 %17, !dbg !1129
}

; Function Attrs: noinline nounwind uwtable
define internal void @locked_trace_destroy(%struct.locked_trace_s* noundef %0, i1 (%struct.trace_unit_s*)* noundef %1) #0 !dbg !1130 {
  %3 = alloca %struct.locked_trace_s*, align 8
  %4 = alloca i1 (%struct.trace_unit_s*)*, align 8
  store %struct.locked_trace_s* %0, %struct.locked_trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.locked_trace_s** %3, metadata !1137, metadata !DIExpression()), !dbg !1138
  store i1 (%struct.trace_unit_s*)* %1, i1 (%struct.trace_unit_s*)** %4, align 8
  call void @llvm.dbg.declare(metadata i1 (%struct.trace_unit_s*)** %4, metadata !1139, metadata !DIExpression()), !dbg !1140
  %5 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1141
  %6 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %5, i32 0, i32 0, !dbg !1142
  %7 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %4, align 8, !dbg !1143
  %8 = call zeroext i1 @trace_verify(%struct.trace_s* noundef %6, i1 (%struct.trace_unit_s*)* noundef %7), !dbg !1144
  %9 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1145
  %10 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %9, i32 0, i32 0, !dbg !1146
  call void @trace_destroy(%struct.trace_s* noundef %10), !dbg !1147
  %11 = load %struct.locked_trace_s*, %struct.locked_trace_s** %3, align 8, !dbg !1148
  %12 = getelementptr inbounds %struct.locked_trace_s, %struct.locked_trace_s* %11, i32 0, i32 1, !dbg !1149
  %13 = call i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef %12) #6, !dbg !1150
  ret void, !dbg !1151
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @_ismr_none_destroy_all_cb(%struct.trace_unit_s* noundef %0) #0 !dbg !1152 {
  %2 = alloca %struct.trace_unit_s*, align 8
  %3 = alloca %struct.smr_none_retire_info_t*, align 8
  store %struct.trace_unit_s* %0, %struct.trace_unit_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %2, metadata !1153, metadata !DIExpression()), !dbg !1154
  %4 = load %struct.trace_unit_s*, %struct.trace_unit_s** %2, align 8, !dbg !1155
  %5 = icmp ne %struct.trace_unit_s* %4, null, !dbg !1155
  br i1 %5, label %6, label %7, !dbg !1158

6:                                                ; preds = %1
  br label %8, !dbg !1158

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.20, i64 0, i64 0), i8* noundef getelementptr inbounds ([70 x i8], [70 x i8]* @.str.21, i64 0, i64 0), i32 noundef 27, i8* noundef getelementptr inbounds ([50 x i8], [50 x i8]* @__PRETTY_FUNCTION__._ismr_none_destroy_all_cb, i64 0, i64 0)) #5, !dbg !1155
  unreachable, !dbg !1155

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata %struct.smr_none_retire_info_t** %3, metadata !1159, metadata !DIExpression()), !dbg !1160
  %9 = load %struct.trace_unit_s*, %struct.trace_unit_s** %2, align 8, !dbg !1161
  %10 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %9, i32 0, i32 0, !dbg !1162
  %11 = load i64, i64* %10, align 8, !dbg !1162
  %12 = inttoptr i64 %11 to %struct.smr_none_retire_info_t*, !dbg !1163
  store %struct.smr_none_retire_info_t* %12, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1160
  %13 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1164
  %14 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %13, i32 0, i32 1, !dbg !1165
  %15 = load void (%struct.smr_node_s*, i8*)*, void (%struct.smr_node_s*, i8*)** %14, align 8, !dbg !1165
  %16 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1166
  %17 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %16, i32 0, i32 0, !dbg !1167
  %18 = load %struct.smr_node_s*, %struct.smr_node_s** %17, align 8, !dbg !1167
  %19 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1168
  %20 = getelementptr inbounds %struct.smr_none_retire_info_t, %struct.smr_none_retire_info_t* %19, i32 0, i32 2, !dbg !1169
  %21 = load i8*, i8** %20, align 8, !dbg !1169
  call void %15(%struct.smr_node_s* noundef %18, i8* noundef %21), !dbg !1164
  %22 = load %struct.smr_none_retire_info_t*, %struct.smr_none_retire_info_t** %3, align 8, !dbg !1170
  %23 = bitcast %struct.smr_none_retire_info_t* %22 to i8*, !dbg !1170
  call void @free(i8* noundef %23) #6, !dbg !1171
  ret i1 true, !dbg !1172
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @trace_verify(%struct.trace_s* noundef %0, i1 (%struct.trace_unit_s*)* noundef %1) #0 !dbg !1173 {
  %3 = alloca i1, align 1
  %4 = alloca %struct.trace_s*, align 8
  %5 = alloca i1 (%struct.trace_unit_s*)*, align 8
  %6 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !1176, metadata !DIExpression()), !dbg !1177
  store i1 (%struct.trace_unit_s*)* %1, i1 (%struct.trace_unit_s*)** %5, align 8
  call void @llvm.dbg.declare(metadata i1 (%struct.trace_unit_s*)** %5, metadata !1178, metadata !DIExpression()), !dbg !1179
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1180, metadata !DIExpression()), !dbg !1181
  store i64 0, i64* %6, align 8, !dbg !1181
  %7 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1182
  %8 = icmp ne %struct.trace_s* %7, null, !dbg !1182
  br i1 %8, label %9, label %10, !dbg !1185

9:                                                ; preds = %2
  br label %11, !dbg !1185

10:                                               ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 214, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #5, !dbg !1182
  unreachable, !dbg !1182

11:                                               ; preds = %9
  %12 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1186
  %13 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %12, i32 0, i32 3, !dbg !1186
  %14 = load i8, i8* %13, align 8, !dbg !1186
  %15 = trunc i8 %14 to i1, !dbg !1186
  br i1 %15, label %16, label %17, !dbg !1189

16:                                               ; preds = %11
  br label %18, !dbg !1189

17:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 215, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #5, !dbg !1186
  unreachable, !dbg !1186

18:                                               ; preds = %16
  %19 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %5, align 8, !dbg !1190
  %20 = icmp ne i1 (%struct.trace_unit_s*)* %19, null, !dbg !1190
  br i1 %20, label %21, label %22, !dbg !1193

21:                                               ; preds = %18
  br label %23, !dbg !1193

22:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 216, i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @__PRETTY_FUNCTION__.trace_verify, i64 0, i64 0)) #5, !dbg !1190
  unreachable, !dbg !1190

23:                                               ; preds = %21
  store i64 0, i64* %6, align 8, !dbg !1194
  br label %24, !dbg !1196

24:                                               ; preds = %42, %23
  %25 = load i64, i64* %6, align 8, !dbg !1197
  %26 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1199
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 1, !dbg !1200
  %28 = load i64, i64* %27, align 8, !dbg !1200
  %29 = icmp ult i64 %25, %28, !dbg !1201
  br i1 %29, label %30, label %45, !dbg !1202

30:                                               ; preds = %24
  %31 = load i1 (%struct.trace_unit_s*)*, i1 (%struct.trace_unit_s*)** %5, align 8, !dbg !1203
  %32 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1206
  %33 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %32, i32 0, i32 0, !dbg !1207
  %34 = load %struct.trace_unit_s*, %struct.trace_unit_s** %33, align 8, !dbg !1207
  %35 = load i64, i64* %6, align 8, !dbg !1208
  %36 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %34, i64 %35, !dbg !1206
  %37 = call zeroext i1 %31(%struct.trace_unit_s* noundef %36), !dbg !1203
  %38 = zext i1 %37 to i32, !dbg !1203
  %39 = icmp eq i32 %38, 0, !dbg !1209
  br i1 %39, label %40, label %41, !dbg !1210

40:                                               ; preds = %30
  store i1 false, i1* %3, align 1, !dbg !1211
  br label %46, !dbg !1211

41:                                               ; preds = %30
  br label %42, !dbg !1213

42:                                               ; preds = %41
  %43 = load i64, i64* %6, align 8, !dbg !1214
  %44 = add i64 %43, 1, !dbg !1214
  store i64 %44, i64* %6, align 8, !dbg !1214
  br label %24, !dbg !1215, !llvm.loop !1216

45:                                               ; preds = %24
  store i1 true, i1* %3, align 1, !dbg !1218
  br label %46, !dbg !1218

46:                                               ; preds = %45, %40
  %47 = load i1, i1* %3, align 1, !dbg !1219
  ret i1 %47, !dbg !1219
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_destroy(%struct.trace_s* noundef %0) #0 !dbg !1220 {
  %2 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %2, metadata !1223, metadata !DIExpression()), !dbg !1224
  %3 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1225
  %4 = icmp ne %struct.trace_s* %3, null, !dbg !1225
  br i1 %4, label %5, label %6, !dbg !1228

5:                                                ; preds = %1
  br label %7, !dbg !1228

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 99, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !1225
  unreachable, !dbg !1225

7:                                                ; preds = %5
  %8 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1229
  %9 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %8, i32 0, i32 3, !dbg !1229
  %10 = load i8, i8* %9, align 8, !dbg !1229
  %11 = trunc i8 %10 to i1, !dbg !1229
  br i1 %11, label %12, label %13, !dbg !1232

12:                                               ; preds = %7
  br label %14, !dbg !1232

13:                                               ; preds = %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.13, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !1229
  unreachable, !dbg !1229

14:                                               ; preds = %12
  %15 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1233
  %16 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %15, i32 0, i32 0, !dbg !1234
  %17 = load %struct.trace_unit_s*, %struct.trace_unit_s** %16, align 8, !dbg !1234
  %18 = bitcast %struct.trace_unit_s* %17 to i8*, !dbg !1233
  call void @free(i8* noundef %18) #6, !dbg !1235
  %19 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1236
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 3, !dbg !1237
  store i8 0, i8* %20, align 8, !dbg !1238
  ret void, !dbg !1239
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_destroy(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @vmem_malloc(i64 noundef %0) #0 !dbg !1240 {
  %2 = alloca i64, align 8
  %3 = alloca i8*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1243, metadata !DIExpression()), !dbg !1244
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1245, metadata !DIExpression()), !dbg !1246
  %4 = load i64, i64* %2, align 8, !dbg !1247
  %5 = call noalias i8* @malloc(i64 noundef %4) #6, !dbg !1248
  store i8* %5, i8** %3, align 8, !dbg !1246
  %6 = load i8*, i8** %3, align 8, !dbg !1249
  %7 = icmp ne i8* %6, null, !dbg !1249
  br i1 %7, label %8, label %9, !dbg !1251

8:                                                ; preds = %1
  call void @vatomic64_inc_rlx(%struct.vatomic64_s* noundef @_g_vmem_alloc_count), !dbg !1252
  br label %10, !dbg !1254

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.14, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.22, i64 0, i64 0), i32 noundef 28, i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @__PRETTY_FUNCTION__.vmem_malloc, i64 0, i64 0)) #5, !dbg !1255
  unreachable, !dbg !1255

10:                                               ; preds = %8
  %11 = load i8*, i8** %3, align 8, !dbg !1259
  ret i8* %11, !dbg !1260
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_enter(i64 noundef %0) #0 !dbg !1261 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1262, metadata !DIExpression()), !dbg !1263
  br label %3, !dbg !1264

3:                                                ; preds = %1
  br label %4, !dbg !1265

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1267
  br label %6, !dbg !1267

6:                                                ; preds = %4
  br label %7, !dbg !1269

7:                                                ; preds = %6
  br label %8, !dbg !1267

8:                                                ; preds = %7
  br label %9, !dbg !1265

9:                                                ; preds = %8
  ret void, !dbg !1271
}

; Function Attrs: noinline nounwind uwtable
define internal void @vqueue_ub_enq(%struct.vqueue_ub_s* noundef %0, %struct.vqueue_ub_node_s* noundef %1, i8* noundef %2) #0 !dbg !1272 {
  %4 = alloca %struct.vqueue_ub_s*, align 8
  %5 = alloca %struct.vqueue_ub_node_s*, align 8
  %6 = alloca i8*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %4, metadata !1275, metadata !DIExpression()), !dbg !1276
  store %struct.vqueue_ub_node_s* %1, %struct.vqueue_ub_node_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %5, metadata !1277, metadata !DIExpression()), !dbg !1278
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !1279, metadata !DIExpression()), !dbg !1280
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1281
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 0, !dbg !1282
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %8), !dbg !1283
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1284
  %10 = load i8*, i8** %6, align 8, !dbg !1285
  call void @_vqueue_ub_node_init(%struct.vqueue_ub_node_s* noundef %9, i8* noundef %10), !dbg !1286
  %11 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1287
  %12 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %11, i32 0, i32 3, !dbg !1288
  %13 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %12, align 8, !dbg !1288
  %14 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %13, i32 0, i32 1, !dbg !1289
  %15 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1290
  %16 = bitcast %struct.vqueue_ub_node_s* %15 to i8*, !dbg !1290
  call void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %14, i8* noundef %16), !dbg !1291
  %17 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %5, align 8, !dbg !1292
  %18 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1293
  %19 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %18, i32 0, i32 3, !dbg !1294
  store %struct.vqueue_ub_node_s* %17, %struct.vqueue_ub_node_s** %19, align 8, !dbg !1295
  %20 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %4, align 8, !dbg !1296
  %21 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %20, i32 0, i32 0, !dbg !1297
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %21), !dbg !1298
  ret void, !dbg !1299
}

; Function Attrs: noinline nounwind uwtable
define internal void @ismr_exit(i64 noundef %0) #0 !dbg !1300 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1301, metadata !DIExpression()), !dbg !1302
  br label %3, !dbg !1303

3:                                                ; preds = %1
  br label %4, !dbg !1304

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1306
  br label %6, !dbg !1306

6:                                                ; preds = %4
  br label %7, !dbg !1308

7:                                                ; preds = %6
  br label %8, !dbg !1306

8:                                                ; preds = %7
  br label %9, !dbg !1304

9:                                                ; preds = %8
  ret void, !dbg !1310
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1311 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1312, metadata !DIExpression()), !dbg !1313
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1314, metadata !DIExpression()), !dbg !1315
  %5 = load i8*, i8** %4, align 8, !dbg !1316
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !1317
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !1318
  %8 = load i8*, i8** %7, align 8, !dbg !1318
  call void asm sideeffect "stlr ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !1319, !srcloc !1320
  ret void, !dbg !1321
}

; Function Attrs: noinline nounwind uwtable
define internal void @_queue_retire(%struct.vqueue_ub_node_s* noundef %0, i8* noundef %1) #0 !dbg !1322 {
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vqueue_ub_node_s* %0, %struct.vqueue_ub_node_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1323, metadata !DIExpression()), !dbg !1324
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1325, metadata !DIExpression()), !dbg !1326
  %5 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1327
  %6 = bitcast %struct.vqueue_ub_node_s* %5 to i8*, !dbg !1327
  call void @vmem_free(i8* noundef %6), !dbg !1328
  br label %7, !dbg !1329

7:                                                ; preds = %2
  br label %8, !dbg !1330

8:                                                ; preds = %7
  %9 = load i8*, i8** %4, align 8, !dbg !1332
  br label %10, !dbg !1332

10:                                               ; preds = %8
  br label %11, !dbg !1334

11:                                               ; preds = %10
  br label %12, !dbg !1332

12:                                               ; preds = %11
  br label %13, !dbg !1330

13:                                               ; preds = %12
  ret void, !dbg !1336
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @vqueue_ub_empty(%struct.vqueue_ub_s* noundef %0) #0 !dbg !1337 {
  %2 = alloca %struct.vqueue_ub_s*, align 8
  %3 = alloca %struct.vqueue_ub_node_s*, align 8
  %4 = alloca %struct.vqueue_ub_node_s*, align 8
  store %struct.vqueue_ub_s* %0, %struct.vqueue_ub_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_s** %2, metadata !1340, metadata !DIExpression()), !dbg !1341
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %3, metadata !1342, metadata !DIExpression()), !dbg !1343
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1343
  call void @llvm.dbg.declare(metadata %struct.vqueue_ub_node_s** %4, metadata !1344, metadata !DIExpression()), !dbg !1345
  store %struct.vqueue_ub_node_s* null, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1345
  %5 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1346
  %6 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %5, i32 0, i32 1, !dbg !1347
  call void @queue_lock_acquire(%union.pthread_mutex_t* noundef %6), !dbg !1348
  %7 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1349
  %8 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %7, i32 0, i32 2, !dbg !1350
  %9 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %8, align 8, !dbg !1350
  store %struct.vqueue_ub_node_s* %9, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1351
  %10 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %4, align 8, !dbg !1352
  %11 = getelementptr inbounds %struct.vqueue_ub_node_s, %struct.vqueue_ub_node_s* %10, i32 0, i32 1, !dbg !1353
  %12 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %11), !dbg !1354
  %13 = bitcast i8* %12 to %struct.vqueue_ub_node_s*, !dbg !1355
  store %struct.vqueue_ub_node_s* %13, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1356
  %14 = load %struct.vqueue_ub_s*, %struct.vqueue_ub_s** %2, align 8, !dbg !1357
  %15 = getelementptr inbounds %struct.vqueue_ub_s, %struct.vqueue_ub_s* %14, i32 0, i32 1, !dbg !1358
  call void @queue_lock_release(%union.pthread_mutex_t* noundef %15), !dbg !1359
  %16 = load %struct.vqueue_ub_node_s*, %struct.vqueue_ub_node_s** %3, align 8, !dbg !1360
  %17 = icmp eq %struct.vqueue_ub_node_s* %16, null, !dbg !1361
  ret i1 %17, !dbg !1362
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
!93 = distinct !DIGlobalVariable(name: "deq_1", scope: !2, file: !94, line: 32, type: !95, isLocal: false, isDefinition: true)
!94 = !DIFile(filename: "datastruct/queue/unbounded/verify/test_case_4.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "dbb08ec92cf81887ee622c56de5825f8")
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
!179 = distinct !DISubprogram(name: "t1", scope: !94, file: !94, line: 23, type: !180, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!180 = !DISubroutineType(types: !181)
!181 = !{null, !5}
!182 = !{}
!183 = !DILocalVariable(name: "tid", arg: 1, scope: !179, file: !94, line: 23, type: !5)
!184 = !DILocation(line: 23, column: 12, scope: !179)
!185 = !DILocation(line: 25, column: 9, scope: !179)
!186 = !DILocation(line: 25, column: 5, scope: !179)
!187 = !DILocation(line: 26, column: 1, scope: !179)
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
!202 = distinct !DISubprogram(name: "t2", scope: !94, file: !94, line: 34, type: !180, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!203 = !DILocalVariable(name: "tid", arg: 1, scope: !202, file: !94, line: 34, type: !5)
!204 = !DILocation(line: 34, column: 12, scope: !202)
!205 = !DILocation(line: 36, column: 17, scope: !202)
!206 = !DILocation(line: 36, column: 13, scope: !202)
!207 = !DILocation(line: 36, column: 11, scope: !202)
!208 = !DILocation(line: 37, column: 9, scope: !209)
!209 = distinct !DILexicalBlock(scope: !202, file: !94, line: 37, column: 9)
!210 = !DILocation(line: 37, column: 9, scope: !202)
!211 = !DILocation(line: 38, column: 9, scope: !212)
!212 = distinct !DILexicalBlock(scope: !213, file: !94, line: 38, column: 9)
!213 = distinct !DILexicalBlock(scope: !214, file: !94, line: 38, column: 9)
!214 = distinct !DILexicalBlock(scope: !209, file: !94, line: 37, column: 16)
!215 = !DILocation(line: 38, column: 9, scope: !213)
!216 = !DILocation(line: 39, column: 14, scope: !214)
!217 = !DILocation(line: 39, column: 9, scope: !214)
!218 = !DILocation(line: 40, column: 5, scope: !214)
!219 = !DILocation(line: 41, column: 9, scope: !220)
!220 = distinct !DILexicalBlock(scope: !209, file: !94, line: 40, column: 12)
!221 = !DILocation(line: 43, column: 1, scope: !202)
!222 = distinct !DISubprogram(name: "deq", scope: !91, file: !91, line: 100, type: !223, scopeLine: 101, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!223 = !DISubroutineType(types: !224)
!224 = !{!95, !5}
!225 = !DILocalVariable(name: "tid", arg: 1, scope: !222, file: !91, line: 100, type: !5)
!226 = !DILocation(line: 100, column: 13, scope: !222)
!227 = !DILocation(line: 102, column: 22, scope: !222)
!228 = !DILocation(line: 102, column: 12, scope: !222)
!229 = !DILocation(line: 102, column: 5, scope: !222)
!230 = distinct !DISubprogram(name: "verification_ignore", scope: !231, file: !231, line: 110, type: !232, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!231 = !DIFile(filename: "include/vsync/common/verify.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "2fd10960d0c2c64c7ccf19294b1806ff")
!232 = !DISubroutineType(types: !233)
!233 = !{null}
!234 = !DILocation(line: 112, column: 5, scope: !230)
!235 = !DILocation(line: 113, column: 1, scope: !230)
!236 = distinct !DISubprogram(name: "t3", scope: !94, file: !94, line: 49, type: !180, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!237 = !DILocalVariable(name: "tid", arg: 1, scope: !236, file: !94, line: 49, type: !5)
!238 = !DILocation(line: 49, column: 12, scope: !236)
!239 = !DILocation(line: 51, column: 9, scope: !236)
!240 = !DILocation(line: 51, column: 5, scope: !236)
!241 = !DILocation(line: 52, column: 17, scope: !236)
!242 = !DILocation(line: 52, column: 5, scope: !236)
!243 = !DILocation(line: 53, column: 1, scope: !236)
!244 = distinct !DISubprogram(name: "queue_clean", scope: !44, file: !44, line: 248, type: !180, scopeLine: 249, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!245 = !DILocalVariable(name: "tid", arg: 1, scope: !244, file: !44, line: 248, type: !5)
!246 = !DILocation(line: 248, column: 21, scope: !244)
!247 = !DILocation(line: 250, column: 18, scope: !244)
!248 = !DILocation(line: 250, column: 5, scope: !244)
!249 = !DILocation(line: 251, column: 1, scope: !244)
!250 = distinct !DISubprogram(name: "verify", scope: !94, file: !94, line: 55, type: !232, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!251 = !DILocation(line: 57, column: 9, scope: !252)
!252 = distinct !DILexicalBlock(scope: !250, file: !94, line: 57, column: 9)
!253 = !DILocation(line: 57, column: 9, scope: !250)
!254 = !DILocation(line: 58, column: 9, scope: !255)
!255 = distinct !DILexicalBlock(scope: !256, file: !94, line: 58, column: 9)
!256 = distinct !DILexicalBlock(scope: !257, file: !94, line: 58, column: 9)
!257 = distinct !DILexicalBlock(scope: !252, file: !94, line: 57, column: 16)
!258 = !DILocation(line: 58, column: 9, scope: !256)
!259 = !DILocation(line: 59, column: 5, scope: !257)
!260 = !DILocation(line: 60, column: 9, scope: !261)
!261 = distinct !DILexicalBlock(scope: !262, file: !94, line: 60, column: 9)
!262 = distinct !DILexicalBlock(scope: !263, file: !94, line: 60, column: 9)
!263 = distinct !DILexicalBlock(scope: !252, file: !94, line: 59, column: 12)
!264 = !DILocation(line: 60, column: 9, scope: !262)
!265 = !DILocation(line: 62, column: 5, scope: !266)
!266 = distinct !DILexicalBlock(scope: !267, file: !94, line: 62, column: 5)
!267 = distinct !DILexicalBlock(scope: !250, file: !94, line: 62, column: 5)
!268 = !DILocation(line: 62, column: 5, scope: !267)
!269 = !DILocation(line: 63, column: 1, scope: !250)
!270 = distinct !DISubprogram(name: "main", scope: !91, file: !91, line: 50, type: !271, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!271 = !DISubroutineType(types: !272)
!272 = !{!66}
!273 = !DILocation(line: 52, column: 5, scope: !270)
!274 = !DILocation(line: 53, column: 5, scope: !270)
!275 = !DILocation(line: 55, column: 5, scope: !270)
!276 = !DILocation(line: 56, column: 5, scope: !270)
!277 = !DILocation(line: 57, column: 5, scope: !270)
!278 = !DILocation(line: 58, column: 5, scope: !279)
!279 = distinct !DILexicalBlock(scope: !280, file: !91, line: 58, column: 5)
!280 = distinct !DILexicalBlock(scope: !270, file: !91, line: 58, column: 5)
!281 = !DILocation(line: 58, column: 5, scope: !280)
!282 = !DILocation(line: 59, column: 5, scope: !270)
!283 = distinct !DISubprogram(name: "init", scope: !91, file: !91, line: 63, type: !232, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!284 = !DILocation(line: 65, column: 5, scope: !283)
!285 = !DILocation(line: 70, column: 5, scope: !283)
!286 = !DILocation(line: 73, column: 5, scope: !283)
!287 = !DILocalVariable(name: "data", scope: !283, file: !91, line: 74, type: !13)
!288 = !DILocation(line: 74, column: 11, scope: !283)
!289 = !DILocation(line: 74, column: 18, scope: !283)
!290 = !DILocation(line: 75, column: 10, scope: !283)
!291 = !DILocation(line: 75, column: 5, scope: !283)
!292 = !DILocation(line: 84, column: 5, scope: !283)
!293 = !DILocation(line: 85, column: 1, scope: !283)
!294 = distinct !DISubprogram(name: "launch_threads", scope: !16, file: !16, line: 111, type: !295, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!295 = !DISubroutineType(types: !296)
!296 = !{null, !5, !27}
!297 = !DILocalVariable(name: "thread_count", arg: 1, scope: !294, file: !16, line: 111, type: !5)
!298 = !DILocation(line: 111, column: 24, scope: !294)
!299 = !DILocalVariable(name: "fun", arg: 2, scope: !294, file: !16, line: 111, type: !27)
!300 = !DILocation(line: 111, column: 51, scope: !294)
!301 = !DILocalVariable(name: "threads", scope: !294, file: !16, line: 113, type: !14)
!302 = !DILocation(line: 113, column: 17, scope: !294)
!303 = !DILocation(line: 113, column: 55, scope: !294)
!304 = !DILocation(line: 113, column: 53, scope: !294)
!305 = !DILocation(line: 113, column: 27, scope: !294)
!306 = !DILocation(line: 115, column: 20, scope: !294)
!307 = !DILocation(line: 115, column: 29, scope: !294)
!308 = !DILocation(line: 115, column: 43, scope: !294)
!309 = !DILocation(line: 115, column: 5, scope: !294)
!310 = !DILocation(line: 117, column: 19, scope: !294)
!311 = !DILocation(line: 117, column: 28, scope: !294)
!312 = !DILocation(line: 117, column: 5, scope: !294)
!313 = !DILocation(line: 119, column: 10, scope: !294)
!314 = !DILocation(line: 119, column: 5, scope: !294)
!315 = !DILocation(line: 120, column: 1, scope: !294)
!316 = distinct !DISubprogram(name: "run", scope: !91, file: !91, line: 126, type: !29, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!317 = !DILocalVariable(name: "args", arg: 1, scope: !316, file: !91, line: 126, type: !13)
!318 = !DILocation(line: 126, column: 11, scope: !316)
!319 = !DILocalVariable(name: "tid", scope: !316, file: !91, line: 128, type: !5)
!320 = !DILocation(line: 128, column: 13, scope: !316)
!321 = !DILocation(line: 128, column: 40, scope: !316)
!322 = !DILocation(line: 128, column: 28, scope: !316)
!323 = !DILocation(line: 129, column: 20, scope: !316)
!324 = !DILocation(line: 129, column: 5, scope: !316)
!325 = !DILocation(line: 130, column: 13, scope: !316)
!326 = !DILocation(line: 130, column: 5, scope: !316)
!327 = !DILocation(line: 132, column: 16, scope: !328)
!328 = distinct !DILexicalBlock(scope: !316, file: !91, line: 130, column: 18)
!329 = !DILocation(line: 132, column: 13, scope: !328)
!330 = !DILocation(line: 133, column: 13, scope: !328)
!331 = !DILocation(line: 135, column: 16, scope: !328)
!332 = !DILocation(line: 135, column: 13, scope: !328)
!333 = !DILocation(line: 136, column: 13, scope: !328)
!334 = !DILocation(line: 138, column: 16, scope: !328)
!335 = !DILocation(line: 138, column: 13, scope: !328)
!336 = !DILocation(line: 139, column: 13, scope: !328)
!337 = !DILocation(line: 141, column: 13, scope: !338)
!338 = distinct !DILexicalBlock(scope: !328, file: !91, line: 141, column: 13)
!339 = !DILocation(line: 141, column: 13, scope: !340)
!340 = distinct !DILexicalBlock(scope: !338, file: !91, line: 141, column: 13)
!341 = !DILocation(line: 142, column: 5, scope: !328)
!342 = !DILocation(line: 143, column: 22, scope: !316)
!343 = !DILocation(line: 143, column: 5, scope: !316)
!344 = !DILocation(line: 144, column: 5, scope: !316)
!345 = distinct !DISubprogram(name: "queue_print", scope: !44, file: !44, line: 235, type: !346, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!346 = !DISubroutineType(types: !347)
!347 = !{null, !348, !43}
!348 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !157, size: 64)
!349 = !DILocalVariable(name: "q", arg: 1, scope: !345, file: !44, line: 235, type: !348)
!350 = !DILocation(line: 235, column: 26, scope: !345)
!351 = !DILocalVariable(name: "print", arg: 2, scope: !345, file: !44, line: 235, type: !43)
!352 = !DILocation(line: 235, column: 41, scope: !345)
!353 = !DILocation(line: 237, column: 28, scope: !345)
!354 = !DILocation(line: 237, column: 56, scope: !345)
!355 = !DILocation(line: 237, column: 48, scope: !345)
!356 = !DILocation(line: 237, column: 5, scope: !345)
!357 = !DILocation(line: 238, column: 1, scope: !345)
!358 = distinct !DISubprogram(name: "get_final_state", scope: !91, file: !91, line: 117, type: !46, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!359 = !DILocalVariable(name: "data", arg: 1, scope: !358, file: !91, line: 117, type: !13)
!360 = !DILocation(line: 117, column: 23, scope: !358)
!361 = !DILocation(line: 119, column: 5, scope: !362)
!362 = distinct !DILexicalBlock(scope: !363, file: !91, line: 119, column: 5)
!363 = distinct !DILexicalBlock(scope: !358, file: !91, line: 119, column: 5)
!364 = !DILocation(line: 119, column: 5, scope: !363)
!365 = !DILocalVariable(name: "node", scope: !358, file: !91, line: 120, type: !95)
!366 = !DILocation(line: 120, column: 13, scope: !358)
!367 = !DILocation(line: 120, column: 20, scope: !358)
!368 = !DILocation(line: 121, column: 5, scope: !369)
!369 = distinct !DILexicalBlock(scope: !370, file: !91, line: 121, column: 5)
!370 = distinct !DILexicalBlock(scope: !358, file: !91, line: 121, column: 5)
!371 = !DILocation(line: 121, column: 5, scope: !370)
!372 = !DILocation(line: 122, column: 30, scope: !358)
!373 = !DILocation(line: 122, column: 36, scope: !358)
!374 = !DILocation(line: 122, column: 24, scope: !358)
!375 = !DILocation(line: 122, column: 5, scope: !358)
!376 = !DILocation(line: 122, column: 28, scope: !358)
!377 = !DILocation(line: 123, column: 1, scope: !358)
!378 = distinct !DISubprogram(name: "destroy", scope: !91, file: !91, line: 88, type: !232, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!379 = !DILocation(line: 90, column: 5, scope: !378)
!380 = !DILocation(line: 91, column: 1, scope: !378)
!381 = distinct !DISubprogram(name: "vmem_no_leak", scope: !79, file: !79, line: 133, type: !382, scopeLine: 134, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!382 = !DISubroutineType(types: !383)
!383 = !{!24}
!384 = !DILocalVariable(name: "alloc_count", scope: !381, file: !79, line: 135, type: !84)
!385 = !DILocation(line: 135, column: 15, scope: !381)
!386 = !DILocation(line: 135, column: 29, scope: !381)
!387 = !DILocalVariable(name: "free_count", scope: !381, file: !79, line: 136, type: !84)
!388 = !DILocation(line: 136, column: 15, scope: !381)
!389 = !DILocation(line: 136, column: 29, scope: !381)
!390 = !DILocation(line: 137, column: 13, scope: !381)
!391 = !DILocation(line: 137, column: 28, scope: !381)
!392 = !DILocation(line: 137, column: 25, scope: !381)
!393 = !DILocation(line: 137, column: 5, scope: !381)
!394 = distinct !DISubprogram(name: "queue_init", scope: !44, file: !44, line: 110, type: !395, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!395 = !DISubroutineType(types: !396)
!396 = !{null, !397}
!397 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !156, size: 64)
!398 = !DILocalVariable(name: "q", arg: 1, scope: !394, file: !44, line: 110, type: !397)
!399 = !DILocation(line: 110, column: 21, scope: !394)
!400 = !DILocation(line: 112, column: 5, scope: !394)
!401 = !DILocation(line: 113, column: 20, scope: !394)
!402 = !DILocation(line: 113, column: 5, scope: !394)
!403 = !DILocation(line: 120, column: 1, scope: !394)
!404 = distinct !DISubprogram(name: "queue_register", scope: !44, file: !44, line: 123, type: !405, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!405 = !DISubroutineType(types: !406)
!406 = !{null, !5, !397}
!407 = !DILocalVariable(name: "tid", arg: 1, scope: !404, file: !44, line: 123, type: !5)
!408 = !DILocation(line: 123, column: 24, scope: !404)
!409 = !DILocalVariable(name: "q", arg: 2, scope: !404, file: !44, line: 123, type: !397)
!410 = !DILocation(line: 123, column: 38, scope: !404)
!411 = !DILocation(line: 125, column: 14, scope: !404)
!412 = !DILocation(line: 125, column: 5, scope: !404)
!413 = !DILocation(line: 126, column: 5, scope: !404)
!414 = !DILocation(line: 126, column: 5, scope: !415)
!415 = distinct !DILexicalBlock(scope: !404, file: !44, line: 126, column: 5)
!416 = !DILocation(line: 126, column: 5, scope: !417)
!417 = distinct !DILexicalBlock(scope: !415, file: !44, line: 126, column: 5)
!418 = !DILocation(line: 126, column: 5, scope: !419)
!419 = distinct !DILexicalBlock(scope: !417, file: !44, line: 126, column: 5)
!420 = !DILocation(line: 127, column: 1, scope: !404)
!421 = distinct !DISubprogram(name: "queue_deregister", scope: !44, file: !44, line: 139, type: !405, scopeLine: 140, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!422 = !DILocalVariable(name: "tid", arg: 1, scope: !421, file: !44, line: 139, type: !5)
!423 = !DILocation(line: 139, column: 26, scope: !421)
!424 = !DILocalVariable(name: "q", arg: 2, scope: !421, file: !44, line: 139, type: !397)
!425 = !DILocation(line: 139, column: 40, scope: !421)
!426 = !DILocation(line: 144, column: 16, scope: !421)
!427 = !DILocation(line: 144, column: 5, scope: !421)
!428 = !DILocation(line: 145, column: 5, scope: !421)
!429 = !DILocation(line: 145, column: 5, scope: !430)
!430 = distinct !DILexicalBlock(scope: !421, file: !44, line: 145, column: 5)
!431 = !DILocation(line: 145, column: 5, scope: !432)
!432 = distinct !DILexicalBlock(scope: !430, file: !44, line: 145, column: 5)
!433 = !DILocation(line: 145, column: 5, scope: !434)
!434 = distinct !DILexicalBlock(scope: !432, file: !44, line: 145, column: 5)
!435 = !DILocation(line: 146, column: 1, scope: !421)
!436 = distinct !DISubprogram(name: "queue_destroy", scope: !44, file: !44, line: 149, type: !395, scopeLine: 150, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!437 = !DILocalVariable(name: "q", arg: 1, scope: !436, file: !44, line: 149, type: !397)
!438 = !DILocation(line: 149, column: 24, scope: !436)
!439 = !DILocalVariable(name: "data", scope: !436, file: !44, line: 151, type: !13)
!440 = !DILocation(line: 151, column: 11, scope: !436)
!441 = !DILocation(line: 156, column: 5, scope: !436)
!442 = !DILocation(line: 156, column: 33, scope: !436)
!443 = !DILocation(line: 156, column: 19, scope: !436)
!444 = !DILocation(line: 156, column: 17, scope: !436)
!445 = !DILocation(line: 156, column: 59, scope: !436)
!446 = !DILocation(line: 157, column: 14, scope: !447)
!447 = distinct !DILexicalBlock(scope: !436, file: !44, line: 156, column: 65)
!448 = !DILocation(line: 157, column: 9, scope: !447)
!449 = distinct !{!449, !441, !450, !451}
!450 = !DILocation(line: 158, column: 5, scope: !436)
!451 = !{!"llvm.loop.mustprogress"}
!452 = !DILocation(line: 159, column: 23, scope: !436)
!453 = !DILocation(line: 159, column: 5, scope: !436)
!454 = !DILocation(line: 165, column: 5, scope: !436)
!455 = !DILocation(line: 166, column: 5, scope: !456)
!456 = distinct !DILexicalBlock(scope: !457, file: !44, line: 166, column: 5)
!457 = distinct !DILexicalBlock(scope: !436, file: !44, line: 166, column: 5)
!458 = !DILocation(line: 166, column: 5, scope: !457)
!459 = !DILocation(line: 167, column: 1, scope: !436)
!460 = distinct !DISubprogram(name: "queue_enq", scope: !44, file: !44, line: 170, type: !461, scopeLine: 171, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!461 = !DISubroutineType(types: !462)
!462 = !{null, !5, !397, !84, !101}
!463 = !DILocalVariable(name: "tid", arg: 1, scope: !460, file: !44, line: 170, type: !5)
!464 = !DILocation(line: 170, column: 19, scope: !460)
!465 = !DILocalVariable(name: "q", arg: 2, scope: !460, file: !44, line: 170, type: !397)
!466 = !DILocation(line: 170, column: 33, scope: !460)
!467 = !DILocalVariable(name: "key", arg: 3, scope: !460, file: !44, line: 170, type: !84)
!468 = !DILocation(line: 170, column: 46, scope: !460)
!469 = !DILocalVariable(name: "lbl", arg: 4, scope: !460, file: !44, line: 170, type: !101)
!470 = !DILocation(line: 170, column: 56, scope: !460)
!471 = !DILocalVariable(name: "data", scope: !460, file: !44, line: 172, type: !95)
!472 = !DILocation(line: 172, column: 13, scope: !460)
!473 = !DILocation(line: 172, column: 20, scope: !460)
!474 = !DILocation(line: 173, column: 9, scope: !475)
!475 = distinct !DILexicalBlock(scope: !460, file: !44, line: 173, column: 9)
!476 = !DILocation(line: 173, column: 9, scope: !460)
!477 = !DILocation(line: 174, column: 31, scope: !478)
!478 = distinct !DILexicalBlock(scope: !475, file: !44, line: 173, column: 15)
!479 = !DILocation(line: 174, column: 9, scope: !478)
!480 = !DILocation(line: 174, column: 15, scope: !478)
!481 = !DILocation(line: 174, column: 29, scope: !478)
!482 = !DILocation(line: 175, column: 31, scope: !478)
!483 = !DILocation(line: 175, column: 9, scope: !478)
!484 = !DILocation(line: 175, column: 15, scope: !478)
!485 = !DILocation(line: 175, column: 29, scope: !478)
!486 = !DILocalVariable(name: "qnode", scope: !478, file: !44, line: 176, type: !487)
!487 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !488, size: 64)
!488 = !DIDerivedType(tag: DW_TAG_typedef, name: "queue_node_t", file: !44, line: 42, baseType: !32)
!489 = !DILocation(line: 176, column: 23, scope: !478)
!490 = !DILocation(line: 190, column: 17, scope: !478)
!491 = !DILocation(line: 190, column: 15, scope: !478)
!492 = !DILocation(line: 192, column: 20, scope: !478)
!493 = !DILocation(line: 192, column: 9, scope: !478)
!494 = !DILocation(line: 193, column: 23, scope: !478)
!495 = !DILocation(line: 193, column: 26, scope: !478)
!496 = !DILocation(line: 193, column: 33, scope: !478)
!497 = !DILocation(line: 193, column: 9, scope: !478)
!498 = !DILocation(line: 194, column: 19, scope: !478)
!499 = !DILocation(line: 194, column: 9, scope: !478)
!500 = !DILocation(line: 195, column: 5, scope: !478)
!501 = !DILocation(line: 196, column: 9, scope: !502)
!502 = distinct !DILexicalBlock(scope: !503, file: !44, line: 196, column: 9)
!503 = distinct !DILexicalBlock(scope: !504, file: !44, line: 196, column: 9)
!504 = distinct !DILexicalBlock(scope: !475, file: !44, line: 195, column: 12)
!505 = !DILocation(line: 198, column: 1, scope: !460)
!506 = distinct !DISubprogram(name: "queue_deq", scope: !44, file: !44, line: 219, type: !507, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!507 = !DISubroutineType(types: !508)
!508 = !{!13, !5, !397}
!509 = !DILocalVariable(name: "tid", arg: 1, scope: !506, file: !44, line: 219, type: !5)
!510 = !DILocation(line: 219, column: 19, scope: !506)
!511 = !DILocalVariable(name: "q", arg: 2, scope: !506, file: !44, line: 219, type: !397)
!512 = !DILocation(line: 219, column: 33, scope: !506)
!513 = !DILocation(line: 221, column: 16, scope: !506)
!514 = !DILocation(line: 221, column: 5, scope: !506)
!515 = !DILocalVariable(name: "data", scope: !506, file: !44, line: 222, type: !13)
!516 = !DILocation(line: 222, column: 11, scope: !506)
!517 = !DILocation(line: 222, column: 32, scope: !506)
!518 = !DILocation(line: 222, column: 58, scope: !506)
!519 = !DILocation(line: 222, column: 50, scope: !506)
!520 = !DILocation(line: 222, column: 18, scope: !506)
!521 = !DILocation(line: 223, column: 15, scope: !506)
!522 = !DILocation(line: 223, column: 5, scope: !506)
!523 = !DILocation(line: 224, column: 12, scope: !506)
!524 = !DILocation(line: 224, column: 5, scope: !506)
!525 = distinct !DISubprogram(name: "empty", scope: !91, file: !91, line: 106, type: !526, scopeLine: 107, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !182)
!526 = !DISubroutineType(types: !527)
!527 = !{!24, !5}
!528 = !DILocalVariable(name: "tid", arg: 1, scope: !525, file: !91, line: 106, type: !5)
!529 = !DILocation(line: 106, column: 15, scope: !525)
!530 = !DILocation(line: 108, column: 24, scope: !525)
!531 = !DILocation(line: 108, column: 12, scope: !525)
!532 = !DILocation(line: 108, column: 5, scope: !525)
!533 = distinct !DISubprogram(name: "queue_empty", scope: !44, file: !44, line: 210, type: !534, scopeLine: 211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!534 = !DISubroutineType(types: !535)
!535 = !{!24, !5, !397}
!536 = !DILocalVariable(name: "tid", arg: 1, scope: !533, file: !44, line: 210, type: !5)
!537 = !DILocation(line: 210, column: 21, scope: !533)
!538 = !DILocalVariable(name: "q", arg: 2, scope: !533, file: !44, line: 210, type: !397)
!539 = !DILocation(line: 210, column: 35, scope: !533)
!540 = !DILocation(line: 212, column: 16, scope: !533)
!541 = !DILocation(line: 212, column: 5, scope: !533)
!542 = !DILocalVariable(name: "empty", scope: !533, file: !44, line: 213, type: !24)
!543 = !DILocation(line: 213, column: 13, scope: !533)
!544 = !DILocation(line: 213, column: 37, scope: !533)
!545 = !DILocation(line: 213, column: 21, scope: !533)
!546 = !DILocation(line: 214, column: 15, scope: !533)
!547 = !DILocation(line: 214, column: 5, scope: !533)
!548 = !DILocation(line: 215, column: 12, scope: !533)
!549 = !DILocation(line: 215, column: 5, scope: !533)
!550 = distinct !DISubprogram(name: "ismr_recycle", scope: !50, file: !50, line: 114, type: !180, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!551 = !DILocalVariable(name: "tid", arg: 1, scope: !550, file: !50, line: 114, type: !5)
!552 = !DILocation(line: 114, column: 22, scope: !550)
!553 = !DILocation(line: 116, column: 5, scope: !550)
!554 = !DILocation(line: 116, column: 5, scope: !555)
!555 = distinct !DILexicalBlock(scope: !550, file: !50, line: 116, column: 5)
!556 = !DILocation(line: 116, column: 5, scope: !557)
!557 = distinct !DILexicalBlock(scope: !555, file: !50, line: 116, column: 5)
!558 = !DILocation(line: 116, column: 5, scope: !559)
!559 = distinct !DILexicalBlock(scope: !557, file: !50, line: 116, column: 5)
!560 = !DILocation(line: 117, column: 1, scope: !550)
!561 = distinct !DISubprogram(name: "create_threads", scope: !16, file: !16, line: 83, type: !562, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!562 = !DISubroutineType(types: !563)
!563 = !{null, !14, !5, !27, !24}
!564 = !DILocalVariable(name: "threads", arg: 1, scope: !561, file: !16, line: 83, type: !14)
!565 = !DILocation(line: 83, column: 28, scope: !561)
!566 = !DILocalVariable(name: "num_threads", arg: 2, scope: !561, file: !16, line: 83, type: !5)
!567 = !DILocation(line: 83, column: 45, scope: !561)
!568 = !DILocalVariable(name: "fun", arg: 3, scope: !561, file: !16, line: 83, type: !27)
!569 = !DILocation(line: 83, column: 71, scope: !561)
!570 = !DILocalVariable(name: "bind", arg: 4, scope: !561, file: !16, line: 84, type: !24)
!571 = !DILocation(line: 84, column: 24, scope: !561)
!572 = !DILocalVariable(name: "i", scope: !561, file: !16, line: 86, type: !5)
!573 = !DILocation(line: 86, column: 13, scope: !561)
!574 = !DILocation(line: 87, column: 12, scope: !575)
!575 = distinct !DILexicalBlock(scope: !561, file: !16, line: 87, column: 5)
!576 = !DILocation(line: 87, column: 10, scope: !575)
!577 = !DILocation(line: 87, column: 17, scope: !578)
!578 = distinct !DILexicalBlock(scope: !575, file: !16, line: 87, column: 5)
!579 = !DILocation(line: 87, column: 21, scope: !578)
!580 = !DILocation(line: 87, column: 19, scope: !578)
!581 = !DILocation(line: 87, column: 5, scope: !575)
!582 = !DILocation(line: 88, column: 40, scope: !583)
!583 = distinct !DILexicalBlock(scope: !578, file: !16, line: 87, column: 39)
!584 = !DILocation(line: 88, column: 9, scope: !583)
!585 = !DILocation(line: 88, column: 17, scope: !583)
!586 = !DILocation(line: 88, column: 20, scope: !583)
!587 = !DILocation(line: 88, column: 38, scope: !583)
!588 = !DILocation(line: 89, column: 40, scope: !583)
!589 = !DILocation(line: 89, column: 9, scope: !583)
!590 = !DILocation(line: 89, column: 17, scope: !583)
!591 = !DILocation(line: 89, column: 20, scope: !583)
!592 = !DILocation(line: 89, column: 38, scope: !583)
!593 = !DILocation(line: 90, column: 40, scope: !583)
!594 = !DILocation(line: 90, column: 9, scope: !583)
!595 = !DILocation(line: 90, column: 17, scope: !583)
!596 = !DILocation(line: 90, column: 20, scope: !583)
!597 = !DILocation(line: 90, column: 38, scope: !583)
!598 = !DILocation(line: 91, column: 25, scope: !583)
!599 = !DILocation(line: 91, column: 33, scope: !583)
!600 = !DILocation(line: 91, column: 36, scope: !583)
!601 = !DILocation(line: 91, column: 55, scope: !583)
!602 = !DILocation(line: 91, column: 63, scope: !583)
!603 = !DILocation(line: 91, column: 54, scope: !583)
!604 = !DILocation(line: 91, column: 9, scope: !583)
!605 = !DILocation(line: 92, column: 5, scope: !583)
!606 = !DILocation(line: 87, column: 35, scope: !578)
!607 = !DILocation(line: 87, column: 5, scope: !578)
!608 = distinct !{!608, !581, !609, !451}
!609 = !DILocation(line: 92, column: 5, scope: !575)
!610 = !DILocation(line: 94, column: 1, scope: !561)
!611 = distinct !DISubprogram(name: "await_threads", scope: !16, file: !16, line: 97, type: !612, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!612 = !DISubroutineType(types: !613)
!613 = !{null, !14, !5}
!614 = !DILocalVariable(name: "threads", arg: 1, scope: !611, file: !16, line: 97, type: !14)
!615 = !DILocation(line: 97, column: 27, scope: !611)
!616 = !DILocalVariable(name: "num_threads", arg: 2, scope: !611, file: !16, line: 97, type: !5)
!617 = !DILocation(line: 97, column: 44, scope: !611)
!618 = !DILocalVariable(name: "i", scope: !611, file: !16, line: 99, type: !5)
!619 = !DILocation(line: 99, column: 13, scope: !611)
!620 = !DILocation(line: 100, column: 12, scope: !621)
!621 = distinct !DILexicalBlock(scope: !611, file: !16, line: 100, column: 5)
!622 = !DILocation(line: 100, column: 10, scope: !621)
!623 = !DILocation(line: 100, column: 17, scope: !624)
!624 = distinct !DILexicalBlock(scope: !621, file: !16, line: 100, column: 5)
!625 = !DILocation(line: 100, column: 21, scope: !624)
!626 = !DILocation(line: 100, column: 19, scope: !624)
!627 = !DILocation(line: 100, column: 5, scope: !621)
!628 = !DILocation(line: 101, column: 22, scope: !629)
!629 = distinct !DILexicalBlock(scope: !624, file: !16, line: 100, column: 39)
!630 = !DILocation(line: 101, column: 30, scope: !629)
!631 = !DILocation(line: 101, column: 33, scope: !629)
!632 = !DILocation(line: 101, column: 9, scope: !629)
!633 = !DILocation(line: 102, column: 5, scope: !629)
!634 = !DILocation(line: 100, column: 35, scope: !624)
!635 = !DILocation(line: 100, column: 5, scope: !624)
!636 = distinct !{!636, !627, !637, !451}
!637 = !DILocation(line: 102, column: 5, scope: !621)
!638 = !DILocation(line: 103, column: 1, scope: !611)
!639 = distinct !DISubprogram(name: "common_run", scope: !16, file: !16, line: 43, type: !29, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!640 = !DILocalVariable(name: "args", arg: 1, scope: !639, file: !16, line: 43, type: !13)
!641 = !DILocation(line: 43, column: 18, scope: !639)
!642 = !DILocalVariable(name: "run_info", scope: !639, file: !16, line: 45, type: !14)
!643 = !DILocation(line: 45, column: 17, scope: !639)
!644 = !DILocation(line: 45, column: 42, scope: !639)
!645 = !DILocation(line: 45, column: 28, scope: !639)
!646 = !DILocation(line: 47, column: 9, scope: !647)
!647 = distinct !DILexicalBlock(scope: !639, file: !16, line: 47, column: 9)
!648 = !DILocation(line: 47, column: 19, scope: !647)
!649 = !DILocation(line: 47, column: 9, scope: !639)
!650 = !DILocation(line: 48, column: 26, scope: !647)
!651 = !DILocation(line: 48, column: 36, scope: !647)
!652 = !DILocation(line: 48, column: 9, scope: !647)
!653 = !DILocation(line: 52, column: 12, scope: !639)
!654 = !DILocation(line: 52, column: 22, scope: !639)
!655 = !DILocation(line: 52, column: 38, scope: !639)
!656 = !DILocation(line: 52, column: 48, scope: !639)
!657 = !DILocation(line: 52, column: 30, scope: !639)
!658 = !DILocation(line: 52, column: 5, scope: !639)
!659 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !16, file: !16, line: 61, type: !180, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!660 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !659, file: !16, line: 61, type: !5)
!661 = !DILocation(line: 61, column: 26, scope: !659)
!662 = !DILocation(line: 78, column: 5, scope: !659)
!663 = !DILocation(line: 78, column: 5, scope: !664)
!664 = distinct !DILexicalBlock(scope: !659, file: !16, line: 78, column: 5)
!665 = !DILocation(line: 78, column: 5, scope: !666)
!666 = distinct !DILexicalBlock(scope: !664, file: !16, line: 78, column: 5)
!667 = !DILocation(line: 78, column: 5, scope: !668)
!668 = distinct !DILexicalBlock(scope: !666, file: !16, line: 78, column: 5)
!669 = !DILocation(line: 80, column: 1, scope: !659)
!670 = distinct !DISubprogram(name: "_vqueue_ub_visit_nodes", scope: !33, file: !33, line: 233, type: !671, scopeLine: 235, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!671 = !DISubroutineType(types: !672)
!672 = !{null, !348, !673, !13}
!673 = !DIDerivedType(tag: DW_TAG_typedef, name: "vqueue_ub_node_handler_t", file: !674, line: 9, baseType: !675)
!674 = !DIFile(filename: "datastruct/queue/unbounded/include/vsync/queue/internal/ub/vqueue_ub_common.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "bc5763170bb9d2e4aa9aa1f04b243580")
!675 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !676, size: 64)
!676 = !DISubroutineType(types: !677)
!677 = !{null, !678, !13}
!678 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!679 = !DILocalVariable(name: "q", arg: 1, scope: !670, file: !33, line: 233, type: !348)
!680 = !DILocation(line: 233, column: 37, scope: !670)
!681 = !DILocalVariable(name: "visitor", arg: 2, scope: !670, file: !33, line: 233, type: !673)
!682 = !DILocation(line: 233, column: 65, scope: !670)
!683 = !DILocalVariable(name: "arg", arg: 3, scope: !670, file: !33, line: 234, type: !13)
!684 = !DILocation(line: 234, column: 30, scope: !670)
!685 = !DILocalVariable(name: "curr", scope: !670, file: !33, line: 236, type: !31)
!686 = !DILocation(line: 236, column: 23, scope: !670)
!687 = !DILocalVariable(name: "next", scope: !670, file: !33, line: 237, type: !31)
!688 = !DILocation(line: 237, column: 23, scope: !670)
!689 = !DILocation(line: 239, column: 12, scope: !670)
!690 = !DILocation(line: 239, column: 15, scope: !670)
!691 = !DILocation(line: 239, column: 10, scope: !670)
!692 = !DILocation(line: 241, column: 53, scope: !670)
!693 = !DILocation(line: 241, column: 59, scope: !670)
!694 = !DILocation(line: 241, column: 32, scope: !670)
!695 = !DILocation(line: 241, column: 12, scope: !670)
!696 = !DILocation(line: 241, column: 10, scope: !670)
!697 = !DILocation(line: 243, column: 5, scope: !670)
!698 = !DILocation(line: 243, column: 12, scope: !670)
!699 = !DILocation(line: 244, column: 57, scope: !700)
!700 = distinct !DILexicalBlock(scope: !670, file: !33, line: 243, column: 18)
!701 = !DILocation(line: 244, column: 63, scope: !700)
!702 = !DILocation(line: 244, column: 36, scope: !700)
!703 = !DILocation(line: 244, column: 16, scope: !700)
!704 = !DILocation(line: 244, column: 14, scope: !700)
!705 = !DILocation(line: 245, column: 9, scope: !700)
!706 = !DILocation(line: 245, column: 17, scope: !700)
!707 = !DILocation(line: 245, column: 23, scope: !700)
!708 = !DILocation(line: 246, column: 16, scope: !700)
!709 = !DILocation(line: 246, column: 14, scope: !700)
!710 = distinct !{!710, !697, !711, !451}
!711 = !DILocation(line: 247, column: 5, scope: !670)
!712 = !DILocation(line: 248, column: 1, scope: !670)
!713 = distinct !DISubprogram(name: "_redirect_print", scope: !44, file: !44, line: 229, type: !714, scopeLine: 230, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!714 = !DISubroutineType(types: !715)
!715 = !{null, !31, !13}
!716 = !DILocalVariable(name: "qnode", arg: 1, scope: !713, file: !44, line: 229, type: !31)
!717 = !DILocation(line: 229, column: 35, scope: !713)
!718 = !DILocalVariable(name: "arg", arg: 2, scope: !713, file: !44, line: 229, type: !13)
!719 = !DILocation(line: 229, column: 48, scope: !713)
!720 = !DILocalVariable(name: "print", scope: !713, file: !44, line: 231, type: !43)
!721 = !DILocation(line: 231, column: 17, scope: !713)
!722 = !DILocation(line: 231, column: 38, scope: !713)
!723 = !DILocation(line: 231, column: 25, scope: !713)
!724 = !DILocation(line: 232, column: 5, scope: !713)
!725 = !DILocation(line: 232, column: 11, scope: !713)
!726 = !DILocation(line: 232, column: 18, scope: !713)
!727 = !DILocation(line: 233, column: 1, scope: !713)
!728 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !729, file: !729, line: 197, type: !730, scopeLine: 198, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!729 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!730 = !DISubroutineType(types: !731)
!731 = !{!13, !732}
!732 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !733, size: 64)
!733 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !38)
!734 = !DILocalVariable(name: "a", arg: 1, scope: !728, file: !729, line: 197, type: !732)
!735 = !DILocation(line: 197, column: 41, scope: !728)
!736 = !DILocalVariable(name: "val", scope: !728, file: !729, line: 199, type: !13)
!737 = !DILocation(line: 199, column: 11, scope: !728)
!738 = !DILocation(line: 202, column: 32, scope: !728)
!739 = !DILocation(line: 202, column: 35, scope: !728)
!740 = !DILocation(line: 200, column: 5, scope: !728)
!741 = !{i64 852631}
!742 = !DILocation(line: 204, column: 12, scope: !728)
!743 = !DILocation(line: 204, column: 5, scope: !728)
!744 = distinct !DISubprogram(name: "vmem_get_alloc_count", scope: !79, file: !79, line: 90, type: !745, scopeLine: 91, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!745 = !DISubroutineType(types: !746)
!746 = !{!84}
!747 = !DILocalVariable(name: "alloc_count", scope: !744, file: !79, line: 93, type: !84)
!748 = !DILocation(line: 93, column: 15, scope: !744)
!749 = !DILocation(line: 93, column: 29, scope: !744)
!750 = !DILocation(line: 94, column: 5, scope: !744)
!751 = !DILocation(line: 94, column: 5, scope: !752)
!752 = distinct !DILexicalBlock(scope: !744, file: !79, line: 94, column: 5)
!753 = !DILocation(line: 94, column: 5, scope: !754)
!754 = distinct !DILexicalBlock(scope: !752, file: !79, line: 94, column: 5)
!755 = !DILocation(line: 94, column: 5, scope: !756)
!756 = distinct !DILexicalBlock(scope: !754, file: !79, line: 94, column: 5)
!757 = !DILocation(line: 95, column: 12, scope: !744)
!758 = !DILocation(line: 95, column: 5, scope: !744)
!759 = distinct !DISubprogram(name: "vmem_get_free_count", scope: !79, file: !79, line: 104, type: !745, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!760 = !DILocalVariable(name: "free_count", scope: !759, file: !79, line: 107, type: !84)
!761 = !DILocation(line: 107, column: 15, scope: !759)
!762 = !DILocation(line: 107, column: 28, scope: !759)
!763 = !DILocation(line: 108, column: 5, scope: !759)
!764 = !DILocation(line: 108, column: 5, scope: !765)
!765 = distinct !DILexicalBlock(scope: !759, file: !79, line: 108, column: 5)
!766 = !DILocation(line: 108, column: 5, scope: !767)
!767 = distinct !DILexicalBlock(scope: !765, file: !79, line: 108, column: 5)
!768 = !DILocation(line: 108, column: 5, scope: !769)
!769 = distinct !DILexicalBlock(scope: !767, file: !79, line: 108, column: 5)
!770 = !DILocation(line: 109, column: 12, scope: !759)
!771 = !DILocation(line: 109, column: 5, scope: !759)
!772 = distinct !DISubprogram(name: "vatomic64_read_rlx", scope: !729, file: !729, line: 149, type: !773, scopeLine: 150, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!773 = !DISubroutineType(types: !774)
!774 = !{!84, !775}
!775 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !776, size: 64)
!776 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !80)
!777 = !DILocalVariable(name: "a", arg: 1, scope: !772, file: !729, line: 149, type: !775)
!778 = !DILocation(line: 149, column: 39, scope: !772)
!779 = !DILocalVariable(name: "val", scope: !772, file: !729, line: 151, type: !84)
!780 = !DILocation(line: 151, column: 15, scope: !772)
!781 = !DILocation(line: 154, column: 32, scope: !772)
!782 = !DILocation(line: 154, column: 35, scope: !772)
!783 = !DILocation(line: 152, column: 5, scope: !772)
!784 = !{i64 851148}
!785 = !DILocation(line: 156, column: 12, scope: !772)
!786 = !DILocation(line: 156, column: 5, scope: !772)
!787 = distinct !DISubprogram(name: "ismr_init", scope: !50, file: !50, line: 35, type: !232, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!788 = !DILocation(line: 37, column: 5, scope: !787)
!789 = !DILocation(line: 38, column: 1, scope: !787)
!790 = distinct !DISubprogram(name: "vqueue_ub_init", scope: !33, file: !33, line: 76, type: !791, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!791 = !DISubroutineType(types: !792)
!792 = !{null, !348}
!793 = !DILocalVariable(name: "q", arg: 1, scope: !790, file: !33, line: 76, type: !348)
!794 = !DILocation(line: 76, column: 29, scope: !790)
!795 = !DILocation(line: 78, column: 16, scope: !790)
!796 = !DILocation(line: 78, column: 19, scope: !790)
!797 = !DILocation(line: 78, column: 5, scope: !790)
!798 = !DILocation(line: 78, column: 8, scope: !790)
!799 = !DILocation(line: 78, column: 13, scope: !790)
!800 = !DILocation(line: 79, column: 16, scope: !790)
!801 = !DILocation(line: 79, column: 19, scope: !790)
!802 = !DILocation(line: 79, column: 5, scope: !790)
!803 = !DILocation(line: 79, column: 8, scope: !790)
!804 = !DILocation(line: 79, column: 13, scope: !790)
!805 = !DILocation(line: 81, column: 27, scope: !790)
!806 = !DILocation(line: 81, column: 30, scope: !790)
!807 = !DILocation(line: 81, column: 5, scope: !790)
!808 = !DILocation(line: 83, column: 22, scope: !790)
!809 = !DILocation(line: 83, column: 25, scope: !790)
!810 = !DILocation(line: 83, column: 5, scope: !790)
!811 = !DILocation(line: 84, column: 22, scope: !790)
!812 = !DILocation(line: 84, column: 25, scope: !790)
!813 = !DILocation(line: 84, column: 5, scope: !790)
!814 = !DILocation(line: 85, column: 1, scope: !790)
!815 = distinct !DISubprogram(name: "locked_trace_init", scope: !105, file: !105, line: 14, type: !816, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!816 = !DISubroutineType(types: !817)
!817 = !{null, !818, !5}
!818 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!819 = !DILocalVariable(name: "trace", arg: 1, scope: !815, file: !105, line: 14, type: !818)
!820 = !DILocation(line: 14, column: 35, scope: !815)
!821 = !DILocalVariable(name: "capacity", arg: 2, scope: !815, file: !105, line: 14, type: !5)
!822 = !DILocation(line: 14, column: 50, scope: !815)
!823 = !DILocation(line: 16, column: 5, scope: !824)
!824 = distinct !DILexicalBlock(scope: !825, file: !105, line: 16, column: 5)
!825 = distinct !DILexicalBlock(scope: !815, file: !105, line: 16, column: 5)
!826 = !DILocation(line: 16, column: 5, scope: !825)
!827 = !DILocation(line: 17, column: 25, scope: !815)
!828 = !DILocation(line: 17, column: 32, scope: !815)
!829 = !DILocation(line: 17, column: 5, scope: !815)
!830 = !DILocation(line: 18, column: 17, scope: !815)
!831 = !DILocation(line: 18, column: 24, scope: !815)
!832 = !DILocation(line: 18, column: 31, scope: !815)
!833 = !DILocation(line: 18, column: 5, scope: !815)
!834 = !DILocation(line: 19, column: 1, scope: !815)
!835 = distinct !DISubprogram(name: "trace_init", scope: !110, file: !110, line: 28, type: !836, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!836 = !DISubroutineType(types: !837)
!837 = !{null, !838, !5}
!838 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!839 = !DILocalVariable(name: "trace", arg: 1, scope: !835, file: !110, line: 28, type: !838)
!840 = !DILocation(line: 28, column: 21, scope: !835)
!841 = !DILocalVariable(name: "capacity", arg: 2, scope: !835, file: !110, line: 28, type: !5)
!842 = !DILocation(line: 28, column: 36, scope: !835)
!843 = !DILocation(line: 30, column: 5, scope: !844)
!844 = distinct !DILexicalBlock(scope: !845, file: !110, line: 30, column: 5)
!845 = distinct !DILexicalBlock(scope: !835, file: !110, line: 30, column: 5)
!846 = !DILocation(line: 30, column: 5, scope: !845)
!847 = !DILocation(line: 31, column: 27, scope: !835)
!848 = !DILocation(line: 31, column: 36, scope: !835)
!849 = !DILocation(line: 31, column: 20, scope: !835)
!850 = !DILocation(line: 31, column: 5, scope: !835)
!851 = !DILocation(line: 31, column: 12, scope: !835)
!852 = !DILocation(line: 31, column: 18, scope: !835)
!853 = !DILocation(line: 32, column: 9, scope: !854)
!854 = distinct !DILexicalBlock(scope: !835, file: !110, line: 32, column: 9)
!855 = !DILocation(line: 32, column: 16, scope: !854)
!856 = !DILocation(line: 32, column: 9, scope: !835)
!857 = !DILocation(line: 33, column: 9, scope: !858)
!858 = distinct !DILexicalBlock(scope: !854, file: !110, line: 32, column: 23)
!859 = !DILocation(line: 33, column: 16, scope: !858)
!860 = !DILocation(line: 33, column: 28, scope: !858)
!861 = !DILocation(line: 34, column: 30, scope: !858)
!862 = !DILocation(line: 34, column: 9, scope: !858)
!863 = !DILocation(line: 34, column: 16, scope: !858)
!864 = !DILocation(line: 34, column: 28, scope: !858)
!865 = !DILocation(line: 35, column: 9, scope: !858)
!866 = !DILocation(line: 35, column: 16, scope: !858)
!867 = !DILocation(line: 35, column: 28, scope: !858)
!868 = !DILocation(line: 36, column: 5, scope: !858)
!869 = !DILocation(line: 37, column: 9, scope: !870)
!870 = distinct !DILexicalBlock(scope: !854, file: !110, line: 36, column: 12)
!871 = !DILocation(line: 37, column: 16, scope: !870)
!872 = !DILocation(line: 37, column: 28, scope: !870)
!873 = !DILocation(line: 38, column: 9, scope: !870)
!874 = !DILocation(line: 38, column: 16, scope: !870)
!875 = !DILocation(line: 38, column: 28, scope: !870)
!876 = !DILocation(line: 39, column: 9, scope: !870)
!877 = !DILocation(line: 39, column: 16, scope: !870)
!878 = !DILocation(line: 39, column: 28, scope: !870)
!879 = !DILocation(line: 40, column: 9, scope: !880)
!880 = distinct !DILexicalBlock(scope: !881, file: !110, line: 40, column: 9)
!881 = distinct !DILexicalBlock(scope: !870, file: !110, line: 40, column: 9)
!882 = !DILocation(line: 42, column: 1, scope: !835)
!883 = distinct !DISubprogram(name: "_vqueue_ub_node_init", scope: !33, file: !33, line: 219, type: !714, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!884 = !DILocalVariable(name: "qnode", arg: 1, scope: !883, file: !33, line: 219, type: !31)
!885 = !DILocation(line: 219, column: 40, scope: !883)
!886 = !DILocalVariable(name: "data", arg: 2, scope: !883, file: !33, line: 219, type: !13)
!887 = !DILocation(line: 219, column: 53, scope: !883)
!888 = !DILocation(line: 221, column: 19, scope: !883)
!889 = !DILocation(line: 221, column: 5, scope: !883)
!890 = !DILocation(line: 221, column: 12, scope: !883)
!891 = !DILocation(line: 221, column: 17, scope: !883)
!892 = !DILocation(line: 222, column: 27, scope: !883)
!893 = !DILocation(line: 222, column: 34, scope: !883)
!894 = !DILocation(line: 222, column: 5, scope: !883)
!895 = !DILocation(line: 223, column: 1, scope: !883)
!896 = distinct !DISubprogram(name: "queue_lock_init", scope: !33, file: !33, line: 31, type: !897, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!897 = !DISubroutineType(types: !898)
!898 = !{null, !899}
!899 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !161, size: 64)
!900 = !DILocalVariable(name: "l", arg: 1, scope: !896, file: !33, line: 31, type: !899)
!901 = !DILocation(line: 31, column: 1, scope: !896)
!902 = distinct !DISubprogram(name: "vatomicptr_write_rlx", scope: !729, file: !729, line: 325, type: !903, scopeLine: 326, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!903 = !DISubroutineType(types: !904)
!904 = !{null, !905, !13}
!905 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!906 = !DILocalVariable(name: "a", arg: 1, scope: !902, file: !729, line: 325, type: !905)
!907 = !DILocation(line: 325, column: 36, scope: !902)
!908 = !DILocalVariable(name: "v", arg: 2, scope: !902, file: !729, line: 325, type: !13)
!909 = !DILocation(line: 325, column: 45, scope: !902)
!910 = !DILocation(line: 329, column: 32, scope: !902)
!911 = !DILocation(line: 329, column: 44, scope: !902)
!912 = !DILocation(line: 329, column: 47, scope: !902)
!913 = !DILocation(line: 327, column: 5, scope: !902)
!914 = !{i64 856832}
!915 = !DILocation(line: 331, column: 1, scope: !902)
!916 = distinct !DISubprogram(name: "ismr_reg", scope: !50, file: !50, line: 89, type: !180, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!917 = !DILocalVariable(name: "tid", arg: 1, scope: !916, file: !50, line: 89, type: !5)
!918 = !DILocation(line: 89, column: 18, scope: !916)
!919 = !DILocation(line: 91, column: 5, scope: !916)
!920 = !DILocation(line: 91, column: 5, scope: !921)
!921 = distinct !DILexicalBlock(scope: !916, file: !50, line: 91, column: 5)
!922 = !DILocation(line: 91, column: 5, scope: !923)
!923 = distinct !DILexicalBlock(scope: !921, file: !50, line: 91, column: 5)
!924 = !DILocation(line: 91, column: 5, scope: !925)
!925 = distinct !DILexicalBlock(scope: !923, file: !50, line: 91, column: 5)
!926 = !DILocation(line: 92, column: 1, scope: !916)
!927 = distinct !DISubprogram(name: "ismr_dereg", scope: !50, file: !50, line: 95, type: !180, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!928 = !DILocalVariable(name: "tid", arg: 1, scope: !927, file: !50, line: 95, type: !5)
!929 = !DILocation(line: 95, column: 20, scope: !927)
!930 = !DILocation(line: 97, column: 5, scope: !927)
!931 = !DILocation(line: 97, column: 5, scope: !932)
!932 = distinct !DILexicalBlock(scope: !927, file: !50, line: 97, column: 5)
!933 = !DILocation(line: 97, column: 5, scope: !934)
!934 = distinct !DILexicalBlock(scope: !932, file: !50, line: 97, column: 5)
!935 = !DILocation(line: 97, column: 5, scope: !936)
!936 = distinct !DILexicalBlock(scope: !934, file: !50, line: 97, column: 5)
!937 = !DILocation(line: 98, column: 1, scope: !927)
!938 = distinct !DISubprogram(name: "vqueue_ub_deq", scope: !33, file: !33, line: 166, type: !939, scopeLine: 167, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!939 = !DISubroutineType(types: !940)
!940 = !{!13, !348, !673, !13}
!941 = !DILocalVariable(name: "q", arg: 1, scope: !938, file: !33, line: 166, type: !348)
!942 = !DILocation(line: 166, column: 28, scope: !938)
!943 = !DILocalVariable(name: "retire", arg: 2, scope: !938, file: !33, line: 166, type: !673)
!944 = !DILocation(line: 166, column: 56, scope: !938)
!945 = !DILocalVariable(name: "retire_arg", arg: 3, scope: !938, file: !33, line: 166, type: !13)
!946 = !DILocation(line: 166, column: 70, scope: !938)
!947 = !DILocalVariable(name: "qnode", scope: !938, file: !33, line: 168, type: !31)
!948 = !DILocation(line: 168, column: 23, scope: !938)
!949 = !DILocalVariable(name: "head", scope: !938, file: !33, line: 169, type: !31)
!950 = !DILocation(line: 169, column: 23, scope: !938)
!951 = !DILocalVariable(name: "data", scope: !938, file: !33, line: 170, type: !13)
!952 = !DILocation(line: 170, column: 11, scope: !938)
!953 = !DILocation(line: 172, column: 25, scope: !938)
!954 = !DILocation(line: 172, column: 28, scope: !938)
!955 = !DILocation(line: 172, column: 5, scope: !938)
!956 = !DILocation(line: 174, column: 12, scope: !938)
!957 = !DILocation(line: 174, column: 15, scope: !938)
!958 = !DILocation(line: 174, column: 10, scope: !938)
!959 = !DILocation(line: 176, column: 54, scope: !938)
!960 = !DILocation(line: 176, column: 60, scope: !938)
!961 = !DILocation(line: 176, column: 33, scope: !938)
!962 = !DILocation(line: 176, column: 13, scope: !938)
!963 = !DILocation(line: 176, column: 11, scope: !938)
!964 = !DILocation(line: 177, column: 9, scope: !965)
!965 = distinct !DILexicalBlock(scope: !938, file: !33, line: 177, column: 9)
!966 = !DILocation(line: 177, column: 9, scope: !938)
!967 = !DILocation(line: 178, column: 19, scope: !968)
!968 = distinct !DILexicalBlock(scope: !965, file: !33, line: 177, column: 16)
!969 = !DILocation(line: 178, column: 26, scope: !968)
!970 = !DILocation(line: 178, column: 17, scope: !968)
!971 = !DILocation(line: 179, column: 19, scope: !968)
!972 = !DILocation(line: 179, column: 9, scope: !968)
!973 = !DILocation(line: 179, column: 12, scope: !968)
!974 = !DILocation(line: 179, column: 17, scope: !968)
!975 = !DILocation(line: 180, column: 13, scope: !976)
!976 = distinct !DILexicalBlock(scope: !968, file: !33, line: 180, column: 13)
!977 = !DILocation(line: 180, column: 22, scope: !976)
!978 = !DILocation(line: 180, column: 25, scope: !976)
!979 = !DILocation(line: 180, column: 18, scope: !976)
!980 = !DILocation(line: 180, column: 13, scope: !968)
!981 = !DILocation(line: 181, column: 13, scope: !982)
!982 = distinct !DILexicalBlock(scope: !976, file: !33, line: 180, column: 35)
!983 = !DILocation(line: 181, column: 20, scope: !982)
!984 = !DILocation(line: 181, column: 26, scope: !982)
!985 = !DILocation(line: 182, column: 9, scope: !982)
!986 = !DILocation(line: 183, column: 5, scope: !968)
!987 = !DILocation(line: 184, column: 25, scope: !938)
!988 = !DILocation(line: 184, column: 28, scope: !938)
!989 = !DILocation(line: 184, column: 5, scope: !938)
!990 = !DILocation(line: 185, column: 12, scope: !938)
!991 = !DILocation(line: 185, column: 5, scope: !938)
!992 = distinct !DISubprogram(name: "_queue_destroy", scope: !44, file: !44, line: 67, type: !993, scopeLine: 68, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!993 = !DISubroutineType(types: !994)
!994 = !{null, !487, !13}
!995 = !DILocalVariable(name: "node", arg: 1, scope: !992, file: !44, line: 67, type: !487)
!996 = !DILocation(line: 67, column: 30, scope: !992)
!997 = !DILocalVariable(name: "arg", arg: 2, scope: !992, file: !44, line: 67, type: !13)
!998 = !DILocation(line: 67, column: 42, scope: !992)
!999 = !DILocation(line: 72, column: 15, scope: !992)
!1000 = !DILocation(line: 72, column: 5, scope: !992)
!1001 = !DILocation(line: 74, column: 5, scope: !992)
!1002 = !DILocation(line: 74, column: 5, scope: !1003)
!1003 = distinct !DILexicalBlock(scope: !992, file: !44, line: 74, column: 5)
!1004 = !DILocation(line: 74, column: 5, scope: !1005)
!1005 = distinct !DILexicalBlock(scope: !1003, file: !44, line: 74, column: 5)
!1006 = !DILocation(line: 74, column: 5, scope: !1007)
!1007 = distinct !DILexicalBlock(scope: !1005, file: !44, line: 74, column: 5)
!1008 = !DILocation(line: 75, column: 1, scope: !992)
!1009 = distinct !DISubprogram(name: "vqueue_ub_destroy", scope: !33, file: !33, line: 98, type: !671, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1010 = !DILocalVariable(name: "q", arg: 1, scope: !1009, file: !33, line: 98, type: !348)
!1011 = !DILocation(line: 98, column: 32, scope: !1009)
!1012 = !DILocalVariable(name: "retire", arg: 2, scope: !1009, file: !33, line: 98, type: !673)
!1013 = !DILocation(line: 98, column: 60, scope: !1009)
!1014 = !DILocalVariable(name: "retire_arg", arg: 3, scope: !1009, file: !33, line: 99, type: !13)
!1015 = !DILocation(line: 99, column: 25, scope: !1009)
!1016 = !DILocalVariable(name: "curr", scope: !1009, file: !33, line: 101, type: !31)
!1017 = !DILocation(line: 101, column: 23, scope: !1009)
!1018 = !DILocalVariable(name: "next", scope: !1009, file: !33, line: 102, type: !31)
!1019 = !DILocation(line: 102, column: 23, scope: !1009)
!1020 = !DILocation(line: 104, column: 12, scope: !1009)
!1021 = !DILocation(line: 104, column: 15, scope: !1009)
!1022 = !DILocation(line: 104, column: 10, scope: !1009)
!1023 = !DILocation(line: 106, column: 5, scope: !1009)
!1024 = !DILocation(line: 106, column: 12, scope: !1009)
!1025 = !DILocation(line: 107, column: 57, scope: !1026)
!1026 = distinct !DILexicalBlock(scope: !1009, file: !33, line: 106, column: 18)
!1027 = !DILocation(line: 107, column: 63, scope: !1026)
!1028 = !DILocation(line: 107, column: 36, scope: !1026)
!1029 = !DILocation(line: 107, column: 16, scope: !1026)
!1030 = !DILocation(line: 107, column: 14, scope: !1026)
!1031 = !DILocation(line: 108, column: 13, scope: !1032)
!1032 = distinct !DILexicalBlock(scope: !1026, file: !33, line: 108, column: 13)
!1033 = !DILocation(line: 108, column: 22, scope: !1032)
!1034 = !DILocation(line: 108, column: 25, scope: !1032)
!1035 = !DILocation(line: 108, column: 18, scope: !1032)
!1036 = !DILocation(line: 108, column: 13, scope: !1026)
!1037 = !DILocation(line: 109, column: 13, scope: !1038)
!1038 = distinct !DILexicalBlock(scope: !1032, file: !33, line: 108, column: 35)
!1039 = !DILocation(line: 109, column: 20, scope: !1038)
!1040 = !DILocation(line: 109, column: 26, scope: !1038)
!1041 = !DILocation(line: 110, column: 9, scope: !1038)
!1042 = !DILocation(line: 111, column: 16, scope: !1026)
!1043 = !DILocation(line: 111, column: 14, scope: !1026)
!1044 = distinct !{!1044, !1023, !1045, !451}
!1045 = !DILocation(line: 112, column: 5, scope: !1009)
!1046 = !DILocation(line: 113, column: 1, scope: !1009)
!1047 = distinct !DISubprogram(name: "ismr_destroy", scope: !50, file: !50, line: 101, type: !232, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1048 = !DILocation(line: 103, column: 5, scope: !1047)
!1049 = !DILocation(line: 104, column: 1, scope: !1047)
!1050 = distinct !DISubprogram(name: "queue_lock_acquire", scope: !33, file: !33, line: 31, type: !897, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1051 = !DILocalVariable(name: "l", arg: 1, scope: !1050, file: !33, line: 31, type: !899)
!1052 = !DILocation(line: 31, column: 1, scope: !1050)
!1053 = !DILocalVariable(name: "val", scope: !1050, file: !33, line: 31, type: !66)
!1054 = !DILocation(line: 31, column: 1, scope: !1055)
!1055 = distinct !DILexicalBlock(scope: !1056, file: !33, line: 31, column: 1)
!1056 = distinct !DILexicalBlock(scope: !1050, file: !33, line: 31, column: 1)
!1057 = !DILocation(line: 31, column: 1, scope: !1056)
!1058 = distinct !DISubprogram(name: "vatomicptr_read_acq", scope: !729, file: !729, line: 181, type: !730, scopeLine: 182, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1059 = !DILocalVariable(name: "a", arg: 1, scope: !1058, file: !729, line: 181, type: !732)
!1060 = !DILocation(line: 181, column: 41, scope: !1058)
!1061 = !DILocalVariable(name: "val", scope: !1058, file: !729, line: 183, type: !13)
!1062 = !DILocation(line: 183, column: 11, scope: !1058)
!1063 = !DILocation(line: 186, column: 32, scope: !1058)
!1064 = !DILocation(line: 186, column: 35, scope: !1058)
!1065 = !DILocation(line: 184, column: 5, scope: !1058)
!1066 = !{i64 852131}
!1067 = !DILocation(line: 188, column: 12, scope: !1058)
!1068 = !DILocation(line: 188, column: 5, scope: !1058)
!1069 = distinct !DISubprogram(name: "queue_lock_release", scope: !33, file: !33, line: 31, type: !897, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1070 = !DILocalVariable(name: "l", arg: 1, scope: !1069, file: !33, line: 31, type: !899)
!1071 = !DILocation(line: 31, column: 1, scope: !1069)
!1072 = !DILocalVariable(name: "val", scope: !1069, file: !33, line: 31, type: !66)
!1073 = !DILocation(line: 31, column: 1, scope: !1074)
!1074 = distinct !DILexicalBlock(scope: !1075, file: !33, line: 31, column: 1)
!1075 = distinct !DILexicalBlock(scope: !1069, file: !33, line: 31, column: 1)
!1076 = !DILocation(line: 31, column: 1, scope: !1075)
!1077 = distinct !DISubprogram(name: "vmem_free", scope: !79, file: !79, line: 71, type: !46, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1078 = !DILocalVariable(name: "ptr", arg: 1, scope: !1077, file: !79, line: 71, type: !13)
!1079 = !DILocation(line: 71, column: 17, scope: !1077)
!1080 = !DILocation(line: 73, column: 10, scope: !1077)
!1081 = !DILocation(line: 73, column: 5, scope: !1077)
!1082 = !DILocation(line: 74, column: 9, scope: !1083)
!1083 = distinct !DILexicalBlock(scope: !1077, file: !79, line: 74, column: 9)
!1084 = !DILocation(line: 74, column: 9, scope: !1077)
!1085 = !DILocation(line: 76, column: 9, scope: !1086)
!1086 = distinct !DILexicalBlock(scope: !1083, file: !79, line: 74, column: 14)
!1087 = !DILocation(line: 78, column: 5, scope: !1086)
!1088 = !DILocation(line: 79, column: 1, scope: !1077)
!1089 = distinct !DISubprogram(name: "vatomic64_inc_rlx", scope: !1090, file: !1090, line: 3000, type: !1091, scopeLine: 3001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1090 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!1091 = !DISubroutineType(types: !1092)
!1092 = !{null, !1093}
!1093 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!1094 = !DILocalVariable(name: "a", arg: 1, scope: !1089, file: !1090, line: 3000, type: !1093)
!1095 = !DILocation(line: 3000, column: 32, scope: !1089)
!1096 = !DILocation(line: 3002, column: 33, scope: !1089)
!1097 = !DILocation(line: 3002, column: 11, scope: !1089)
!1098 = !DILocation(line: 3003, column: 1, scope: !1089)
!1099 = distinct !DISubprogram(name: "vatomic64_get_inc_rlx", scope: !1090, file: !1090, line: 2560, type: !1100, scopeLine: 2561, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1100 = !DISubroutineType(types: !1101)
!1101 = !{!84, !1093}
!1102 = !DILocalVariable(name: "a", arg: 1, scope: !1099, file: !1090, line: 2560, type: !1093)
!1103 = !DILocation(line: 2560, column: 36, scope: !1099)
!1104 = !DILocation(line: 2562, column: 34, scope: !1099)
!1105 = !DILocation(line: 2562, column: 12, scope: !1099)
!1106 = !DILocation(line: 2562, column: 5, scope: !1099)
!1107 = distinct !DISubprogram(name: "vatomic64_get_add_rlx", scope: !1108, file: !1108, line: 1888, type: !1109, scopeLine: 1889, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1108 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!1109 = !DISubroutineType(types: !1110)
!1110 = !{!84, !1093, !84}
!1111 = !DILocalVariable(name: "a", arg: 1, scope: !1107, file: !1108, line: 1888, type: !1093)
!1112 = !DILocation(line: 1888, column: 36, scope: !1107)
!1113 = !DILocalVariable(name: "v", arg: 2, scope: !1107, file: !1108, line: 1888, type: !84)
!1114 = !DILocation(line: 1888, column: 49, scope: !1107)
!1115 = !DILocalVariable(name: "oldv", scope: !1107, file: !1108, line: 1890, type: !84)
!1116 = !DILocation(line: 1890, column: 15, scope: !1107)
!1117 = !DILocalVariable(name: "tmp", scope: !1107, file: !1108, line: 1891, type: !1118)
!1118 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !6, line: 35, baseType: !1119)
!1119 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !86, line: 26, baseType: !1120)
!1120 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !88, line: 42, baseType: !133)
!1121 = !DILocation(line: 1891, column: 15, scope: !1107)
!1122 = !DILocalVariable(name: "newv", scope: !1107, file: !1108, line: 1892, type: !84)
!1123 = !DILocation(line: 1892, column: 15, scope: !1107)
!1124 = !DILocation(line: 1893, column: 5, scope: !1107)
!1125 = !DILocation(line: 1901, column: 19, scope: !1107)
!1126 = !DILocation(line: 1901, column: 22, scope: !1107)
!1127 = !{i64 961875, i64 961909, i64 961924, i64 961956, i64 961998, i64 962039}
!1128 = !DILocation(line: 1904, column: 12, scope: !1107)
!1129 = !DILocation(line: 1904, column: 5, scope: !1107)
!1130 = distinct !DISubprogram(name: "locked_trace_destroy", scope: !105, file: !105, line: 31, type: !1131, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1131 = !DISubroutineType(types: !1132)
!1132 = !{null, !818, !1133}
!1133 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_verify_unit", file: !110, line: 25, baseType: !1134)
!1134 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1135, size: 64)
!1135 = !DISubroutineType(types: !1136)
!1136 = !{!24, !114}
!1137 = !DILocalVariable(name: "trace", arg: 1, scope: !1130, file: !105, line: 31, type: !818)
!1138 = !DILocation(line: 31, column: 38, scope: !1130)
!1139 = !DILocalVariable(name: "callback", arg: 2, scope: !1130, file: !105, line: 31, type: !1133)
!1140 = !DILocation(line: 31, column: 63, scope: !1130)
!1141 = !DILocation(line: 33, column: 19, scope: !1130)
!1142 = !DILocation(line: 33, column: 26, scope: !1130)
!1143 = !DILocation(line: 33, column: 33, scope: !1130)
!1144 = !DILocation(line: 33, column: 5, scope: !1130)
!1145 = !DILocation(line: 34, column: 20, scope: !1130)
!1146 = !DILocation(line: 34, column: 27, scope: !1130)
!1147 = !DILocation(line: 34, column: 5, scope: !1130)
!1148 = !DILocation(line: 35, column: 28, scope: !1130)
!1149 = !DILocation(line: 35, column: 35, scope: !1130)
!1150 = !DILocation(line: 35, column: 5, scope: !1130)
!1151 = !DILocation(line: 36, column: 1, scope: !1130)
!1152 = distinct !DISubprogram(name: "_ismr_none_destroy_all_cb", scope: !50, file: !50, line: 25, type: !1135, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1153 = !DILocalVariable(name: "unit", arg: 1, scope: !1152, file: !50, line: 25, type: !114)
!1154 = !DILocation(line: 25, column: 41, scope: !1152)
!1155 = !DILocation(line: 27, column: 5, scope: !1156)
!1156 = distinct !DILexicalBlock(scope: !1157, file: !50, line: 27, column: 5)
!1157 = distinct !DILexicalBlock(scope: !1152, file: !50, line: 27, column: 5)
!1158 = !DILocation(line: 27, column: 5, scope: !1157)
!1159 = !DILocalVariable(name: "info", scope: !1152, file: !50, line: 28, type: !48)
!1160 = !DILocation(line: 28, column: 29, scope: !1152)
!1161 = !DILocation(line: 28, column: 62, scope: !1152)
!1162 = !DILocation(line: 28, column: 68, scope: !1152)
!1163 = !DILocation(line: 28, column: 36, scope: !1152)
!1164 = !DILocation(line: 29, column: 5, scope: !1152)
!1165 = !DILocation(line: 29, column: 11, scope: !1152)
!1166 = !DILocation(line: 29, column: 20, scope: !1152)
!1167 = !DILocation(line: 29, column: 26, scope: !1152)
!1168 = !DILocation(line: 29, column: 35, scope: !1152)
!1169 = !DILocation(line: 29, column: 41, scope: !1152)
!1170 = !DILocation(line: 30, column: 10, scope: !1152)
!1171 = !DILocation(line: 30, column: 5, scope: !1152)
!1172 = !DILocation(line: 31, column: 5, scope: !1152)
!1173 = distinct !DISubprogram(name: "trace_verify", scope: !110, file: !110, line: 210, type: !1174, scopeLine: 211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1174 = !DISubroutineType(types: !1175)
!1175 = !{!24, !838, !1133}
!1176 = !DILocalVariable(name: "trace", arg: 1, scope: !1173, file: !110, line: 210, type: !838)
!1177 = !DILocation(line: 210, column: 23, scope: !1173)
!1178 = !DILocalVariable(name: "verify_fun", arg: 2, scope: !1173, file: !110, line: 210, type: !1133)
!1179 = !DILocation(line: 210, column: 48, scope: !1173)
!1180 = !DILocalVariable(name: "i", scope: !1173, file: !110, line: 212, type: !5)
!1181 = !DILocation(line: 212, column: 13, scope: !1173)
!1182 = !DILocation(line: 214, column: 5, scope: !1183)
!1183 = distinct !DILexicalBlock(scope: !1184, file: !110, line: 214, column: 5)
!1184 = distinct !DILexicalBlock(scope: !1173, file: !110, line: 214, column: 5)
!1185 = !DILocation(line: 214, column: 5, scope: !1184)
!1186 = !DILocation(line: 215, column: 5, scope: !1187)
!1187 = distinct !DILexicalBlock(scope: !1188, file: !110, line: 215, column: 5)
!1188 = distinct !DILexicalBlock(scope: !1173, file: !110, line: 215, column: 5)
!1189 = !DILocation(line: 215, column: 5, scope: !1188)
!1190 = !DILocation(line: 216, column: 5, scope: !1191)
!1191 = distinct !DILexicalBlock(scope: !1192, file: !110, line: 216, column: 5)
!1192 = distinct !DILexicalBlock(scope: !1173, file: !110, line: 216, column: 5)
!1193 = !DILocation(line: 216, column: 5, scope: !1192)
!1194 = !DILocation(line: 218, column: 12, scope: !1195)
!1195 = distinct !DILexicalBlock(scope: !1173, file: !110, line: 218, column: 5)
!1196 = !DILocation(line: 218, column: 10, scope: !1195)
!1197 = !DILocation(line: 218, column: 17, scope: !1198)
!1198 = distinct !DILexicalBlock(scope: !1195, file: !110, line: 218, column: 5)
!1199 = !DILocation(line: 218, column: 21, scope: !1198)
!1200 = !DILocation(line: 218, column: 28, scope: !1198)
!1201 = !DILocation(line: 218, column: 19, scope: !1198)
!1202 = !DILocation(line: 218, column: 5, scope: !1195)
!1203 = !DILocation(line: 219, column: 13, scope: !1204)
!1204 = distinct !DILexicalBlock(scope: !1205, file: !110, line: 219, column: 13)
!1205 = distinct !DILexicalBlock(scope: !1198, file: !110, line: 218, column: 38)
!1206 = !DILocation(line: 219, column: 25, scope: !1204)
!1207 = !DILocation(line: 219, column: 32, scope: !1204)
!1208 = !DILocation(line: 219, column: 38, scope: !1204)
!1209 = !DILocation(line: 219, column: 42, scope: !1204)
!1210 = !DILocation(line: 219, column: 13, scope: !1205)
!1211 = !DILocation(line: 220, column: 13, scope: !1212)
!1212 = distinct !DILexicalBlock(scope: !1204, file: !110, line: 219, column: 52)
!1213 = !DILocation(line: 222, column: 5, scope: !1205)
!1214 = !DILocation(line: 218, column: 34, scope: !1198)
!1215 = !DILocation(line: 218, column: 5, scope: !1198)
!1216 = distinct !{!1216, !1202, !1217, !451}
!1217 = !DILocation(line: 222, column: 5, scope: !1195)
!1218 = !DILocation(line: 223, column: 5, scope: !1173)
!1219 = !DILocation(line: 224, column: 1, scope: !1173)
!1220 = distinct !DISubprogram(name: "trace_destroy", scope: !110, file: !110, line: 97, type: !1221, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1221 = !DISubroutineType(types: !1222)
!1222 = !{null, !838}
!1223 = !DILocalVariable(name: "trace", arg: 1, scope: !1220, file: !110, line: 97, type: !838)
!1224 = !DILocation(line: 97, column: 24, scope: !1220)
!1225 = !DILocation(line: 99, column: 5, scope: !1226)
!1226 = distinct !DILexicalBlock(scope: !1227, file: !110, line: 99, column: 5)
!1227 = distinct !DILexicalBlock(scope: !1220, file: !110, line: 99, column: 5)
!1228 = !DILocation(line: 99, column: 5, scope: !1227)
!1229 = !DILocation(line: 100, column: 5, scope: !1230)
!1230 = distinct !DILexicalBlock(scope: !1231, file: !110, line: 100, column: 5)
!1231 = distinct !DILexicalBlock(scope: !1220, file: !110, line: 100, column: 5)
!1232 = !DILocation(line: 100, column: 5, scope: !1231)
!1233 = !DILocation(line: 101, column: 10, scope: !1220)
!1234 = !DILocation(line: 101, column: 17, scope: !1220)
!1235 = !DILocation(line: 101, column: 5, scope: !1220)
!1236 = !DILocation(line: 102, column: 5, scope: !1220)
!1237 = !DILocation(line: 102, column: 12, scope: !1220)
!1238 = !DILocation(line: 102, column: 24, scope: !1220)
!1239 = !DILocation(line: 103, column: 1, scope: !1220)
!1240 = distinct !DISubprogram(name: "vmem_malloc", scope: !79, file: !79, line: 20, type: !1241, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1241 = !DISubroutineType(types: !1242)
!1242 = !{!13, !5}
!1243 = !DILocalVariable(name: "sz", arg: 1, scope: !1240, file: !79, line: 20, type: !5)
!1244 = !DILocation(line: 20, column: 21, scope: !1240)
!1245 = !DILocalVariable(name: "ptr", scope: !1240, file: !79, line: 22, type: !13)
!1246 = !DILocation(line: 22, column: 11, scope: !1240)
!1247 = !DILocation(line: 22, column: 24, scope: !1240)
!1248 = !DILocation(line: 22, column: 17, scope: !1240)
!1249 = !DILocation(line: 23, column: 9, scope: !1250)
!1250 = distinct !DILexicalBlock(scope: !1240, file: !79, line: 23, column: 9)
!1251 = !DILocation(line: 23, column: 9, scope: !1240)
!1252 = !DILocation(line: 25, column: 9, scope: !1253)
!1253 = distinct !DILexicalBlock(scope: !1250, file: !79, line: 23, column: 14)
!1254 = !DILocation(line: 27, column: 5, scope: !1253)
!1255 = !DILocation(line: 28, column: 9, scope: !1256)
!1256 = distinct !DILexicalBlock(scope: !1257, file: !79, line: 28, column: 9)
!1257 = distinct !DILexicalBlock(scope: !1258, file: !79, line: 28, column: 9)
!1258 = distinct !DILexicalBlock(scope: !1250, file: !79, line: 27, column: 12)
!1259 = !DILocation(line: 30, column: 12, scope: !1240)
!1260 = !DILocation(line: 30, column: 5, scope: !1240)
!1261 = distinct !DISubprogram(name: "ismr_enter", scope: !50, file: !50, line: 41, type: !180, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1262 = !DILocalVariable(name: "tid", arg: 1, scope: !1261, file: !50, line: 41, type: !5)
!1263 = !DILocation(line: 41, column: 20, scope: !1261)
!1264 = !DILocation(line: 43, column: 5, scope: !1261)
!1265 = !DILocation(line: 43, column: 5, scope: !1266)
!1266 = distinct !DILexicalBlock(scope: !1261, file: !50, line: 43, column: 5)
!1267 = !DILocation(line: 43, column: 5, scope: !1268)
!1268 = distinct !DILexicalBlock(scope: !1266, file: !50, line: 43, column: 5)
!1269 = !DILocation(line: 43, column: 5, scope: !1270)
!1270 = distinct !DILexicalBlock(scope: !1268, file: !50, line: 43, column: 5)
!1271 = !DILocation(line: 44, column: 1, scope: !1261)
!1272 = distinct !DISubprogram(name: "vqueue_ub_enq", scope: !33, file: !33, line: 122, type: !1273, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1273 = !DISubroutineType(types: !1274)
!1274 = !{null, !348, !31, !13}
!1275 = !DILocalVariable(name: "q", arg: 1, scope: !1272, file: !33, line: 122, type: !348)
!1276 = !DILocation(line: 122, column: 28, scope: !1272)
!1277 = !DILocalVariable(name: "qnode", arg: 2, scope: !1272, file: !33, line: 122, type: !31)
!1278 = !DILocation(line: 122, column: 49, scope: !1272)
!1279 = !DILocalVariable(name: "data", arg: 3, scope: !1272, file: !33, line: 122, type: !13)
!1280 = !DILocation(line: 122, column: 62, scope: !1272)
!1281 = !DILocation(line: 124, column: 25, scope: !1272)
!1282 = !DILocation(line: 124, column: 28, scope: !1272)
!1283 = !DILocation(line: 124, column: 5, scope: !1272)
!1284 = !DILocation(line: 127, column: 26, scope: !1272)
!1285 = !DILocation(line: 127, column: 33, scope: !1272)
!1286 = !DILocation(line: 127, column: 5, scope: !1272)
!1287 = !DILocation(line: 129, column: 27, scope: !1272)
!1288 = !DILocation(line: 129, column: 30, scope: !1272)
!1289 = !DILocation(line: 129, column: 36, scope: !1272)
!1290 = !DILocation(line: 129, column: 42, scope: !1272)
!1291 = !DILocation(line: 129, column: 5, scope: !1272)
!1292 = !DILocation(line: 131, column: 15, scope: !1272)
!1293 = !DILocation(line: 131, column: 5, scope: !1272)
!1294 = !DILocation(line: 131, column: 8, scope: !1272)
!1295 = !DILocation(line: 131, column: 13, scope: !1272)
!1296 = !DILocation(line: 132, column: 25, scope: !1272)
!1297 = !DILocation(line: 132, column: 28, scope: !1272)
!1298 = !DILocation(line: 132, column: 5, scope: !1272)
!1299 = !DILocation(line: 133, column: 1, scope: !1272)
!1300 = distinct !DISubprogram(name: "ismr_exit", scope: !50, file: !50, line: 83, type: !180, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1301 = !DILocalVariable(name: "tid", arg: 1, scope: !1300, file: !50, line: 83, type: !5)
!1302 = !DILocation(line: 83, column: 19, scope: !1300)
!1303 = !DILocation(line: 85, column: 5, scope: !1300)
!1304 = !DILocation(line: 85, column: 5, scope: !1305)
!1305 = distinct !DILexicalBlock(scope: !1300, file: !50, line: 85, column: 5)
!1306 = !DILocation(line: 85, column: 5, scope: !1307)
!1307 = distinct !DILexicalBlock(scope: !1305, file: !50, line: 85, column: 5)
!1308 = !DILocation(line: 85, column: 5, scope: !1309)
!1309 = distinct !DILexicalBlock(scope: !1307, file: !50, line: 85, column: 5)
!1310 = !DILocation(line: 86, column: 1, scope: !1300)
!1311 = distinct !DISubprogram(name: "vatomicptr_write_rel", scope: !729, file: !729, line: 311, type: !903, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1312 = !DILocalVariable(name: "a", arg: 1, scope: !1311, file: !729, line: 311, type: !905)
!1313 = !DILocation(line: 311, column: 36, scope: !1311)
!1314 = !DILocalVariable(name: "v", arg: 2, scope: !1311, file: !729, line: 311, type: !13)
!1315 = !DILocation(line: 311, column: 45, scope: !1311)
!1316 = !DILocation(line: 315, column: 32, scope: !1311)
!1317 = !DILocation(line: 315, column: 44, scope: !1311)
!1318 = !DILocation(line: 315, column: 47, scope: !1311)
!1319 = !DILocation(line: 313, column: 5, scope: !1311)
!1320 = !{i64 856361}
!1321 = !DILocation(line: 317, column: 1, scope: !1311)
!1322 = distinct !DISubprogram(name: "_queue_retire", scope: !44, file: !44, line: 53, type: !993, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1323 = !DILocalVariable(name: "node", arg: 1, scope: !1322, file: !44, line: 53, type: !487)
!1324 = !DILocation(line: 53, column: 29, scope: !1322)
!1325 = !DILocalVariable(name: "arg", arg: 2, scope: !1322, file: !44, line: 53, type: !13)
!1326 = !DILocation(line: 53, column: 41, scope: !1322)
!1327 = !DILocation(line: 61, column: 15, scope: !1322)
!1328 = !DILocation(line: 61, column: 5, scope: !1322)
!1329 = !DILocation(line: 63, column: 5, scope: !1322)
!1330 = !DILocation(line: 63, column: 5, scope: !1331)
!1331 = distinct !DILexicalBlock(scope: !1322, file: !44, line: 63, column: 5)
!1332 = !DILocation(line: 63, column: 5, scope: !1333)
!1333 = distinct !DILexicalBlock(scope: !1331, file: !44, line: 63, column: 5)
!1334 = !DILocation(line: 63, column: 5, scope: !1335)
!1335 = distinct !DILexicalBlock(scope: !1333, file: !44, line: 63, column: 5)
!1336 = !DILocation(line: 64, column: 1, scope: !1322)
!1337 = distinct !DISubprogram(name: "vqueue_ub_empty", scope: !33, file: !33, line: 143, type: !1338, scopeLine: 144, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !182)
!1338 = !DISubroutineType(types: !1339)
!1339 = !{!24, !348}
!1340 = !DILocalVariable(name: "q", arg: 1, scope: !1337, file: !33, line: 143, type: !348)
!1341 = !DILocation(line: 143, column: 30, scope: !1337)
!1342 = !DILocalVariable(name: "qnode", scope: !1337, file: !33, line: 145, type: !31)
!1343 = !DILocation(line: 145, column: 23, scope: !1337)
!1344 = !DILocalVariable(name: "head", scope: !1337, file: !33, line: 146, type: !31)
!1345 = !DILocation(line: 146, column: 23, scope: !1337)
!1346 = !DILocation(line: 148, column: 25, scope: !1337)
!1347 = !DILocation(line: 148, column: 28, scope: !1337)
!1348 = !DILocation(line: 148, column: 5, scope: !1337)
!1349 = !DILocation(line: 149, column: 12, scope: !1337)
!1350 = !DILocation(line: 149, column: 15, scope: !1337)
!1351 = !DILocation(line: 149, column: 10, scope: !1337)
!1352 = !DILocation(line: 151, column: 54, scope: !1337)
!1353 = !DILocation(line: 151, column: 60, scope: !1337)
!1354 = !DILocation(line: 151, column: 33, scope: !1337)
!1355 = !DILocation(line: 151, column: 13, scope: !1337)
!1356 = !DILocation(line: 151, column: 11, scope: !1337)
!1357 = !DILocation(line: 152, column: 25, scope: !1337)
!1358 = !DILocation(line: 152, column: 28, scope: !1337)
!1359 = !DILocation(line: 152, column: 5, scope: !1337)
!1360 = !DILocation(line: 153, column: 12, scope: !1337)
!1361 = !DILocation(line: 153, column: 18, scope: !1337)
!1362 = !DILocation(line: 153, column: 5, scope: !1337)
