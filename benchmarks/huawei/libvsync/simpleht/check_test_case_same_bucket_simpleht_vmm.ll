; ModuleID = '/home/drc/git/libvsync/verify/simpleht/verify.c'
source_filename = "/home/drc/git/libvsync/verify/simpleht/verify.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.vsimpleht_s = type { i64, %struct.vsimpleht_entry_s*, i8 (i64, i64)*, i64 (i64)*, void (i8*)*, i64, %struct.vatomicsz_s, %struct.rwlock_s }
%struct.vsimpleht_entry_s = type { %struct.vatomicptr_s, %struct.vatomicptr_s }
%struct.vatomicptr_s = type { i8* }
%struct.vatomicsz_s = type { i64 }
%struct.rwlock_s = type { [3 x %union.pthread_mutex_t], %struct.vatomic8_s, %struct.vatomic32_s }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%struct.vatomic8_s = type { i8 }
%struct.vatomic32_s = type { i32 }
%struct.trace_s = type { %struct.trace_unit_s*, i64, i64, i8 }
%struct.trace_unit_s = type { i64, i64 }
%struct.data_s = type { i64, i64 }
%struct.run_info_t = type { i64, i64, i8, i8* (i8*)* }
%union.pthread_attr_t = type { i64, [48 x i8] }
%union.pthread_mutexattr_t = type { i32 }
%struct.vsimpleht_iter_s = type { %struct.vsimpleht_s*, i64 }

@g_tid = dso_local thread_local global i32 3, align 4, !dbg !0
@.str = private unnamed_addr constant [8 x i8] c"success\00", align 1
@.str.1 = private unnamed_addr constant [63 x i8] c"/home/drc/git/libvsync/verify/simpleht/test_case_same_bucket.h\00", align 1
@__PRETTY_FUNCTION__.pre = private unnamed_addr constant [15 x i8] c"void pre(void)\00", align 1
@g_keys = dso_local global [3 x i64] zeroinitializer, align 16, !dbg !54
@.str.2 = private unnamed_addr constant [23 x i8] c"tid < ((8U / 2U) - 1U)\00", align 1
@__PRETTY_FUNCTION__.t0 = private unnamed_addr constant [17 x i8] c"void t0(vsize_t)\00", align 1
@.str.3 = private unnamed_addr constant [9 x i8] c"!success\00", align 1
@__PRETTY_FUNCTION__.t1 = private unnamed_addr constant [17 x i8] c"void t1(vsize_t)\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"data\00", align 1
@__PRETTY_FUNCTION__.t2 = private unnamed_addr constant [17 x i8] c"void t2(vsize_t)\00", align 1
@.str.5 = private unnamed_addr constant [9 x i8] c"tid < 3U\00", align 1
@.str.6 = private unnamed_addr constant [65 x i8] c"/home/drc/git/libvsync/test/include/test/boilerplate/test_case.h\00", align 1
@__PRETTY_FUNCTION__.run = private unnamed_addr constant [18 x i8] c"void *run(void *)\00", align 1
@g_simpleht = internal global %struct.vsimpleht_s zeroinitializer, align 8, !dbg !60
@g_add = internal global [4 x %struct.trace_s] zeroinitializer, align 16, !dbg !153
@.str.7 = private unnamed_addr constant [9 x i8] c"key != 0\00", align 1
@.str.8 = private unnamed_addr constant [52 x i8] c"/home/drc/git/libvsync/include/vsync/map/simpleht.h\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_add = private unnamed_addr constant [65 x i8] c"vsimpleht_ret_t vsimpleht_add(vsimpleht_t *, vuintptr_t, void *)\00", align 1
@.str.9 = private unnamed_addr constant [20 x i8] c"value != ((void*)0)\00", align 1
@.str.10 = private unnamed_addr constant [65 x i8] c"You seem to have forgotten to call the  thread register function\00", align 1
@.str.11 = private unnamed_addr constant [112 x i8] c"rwlock_acquired_by_readers(&tbl->lock) && \22You seem to have forgotten to call the \22 \22 thread register function\22\00", align 1
@__PRETTY_FUNCTION__._vsimpleht_give_cleanup_a_chance = private unnamed_addr constant [53 x i8] c"void _vsimpleht_give_cleanup_a_chance(vsimpleht_t *)\00", align 1
@.str.12 = private unnamed_addr constant [11 x i8] c"g_tid < 3U\00", align 1
@.str.13 = private unnamed_addr constant [54 x i8] c"/home/drc/git/libvsync/verify/include/verify/rwlock.h\00", align 1
@__PRETTY_FUNCTION__._rwlock_get_tid = private unnamed_addr constant [38 x i8] c"vuint32_t _rwlock_get_tid(rwlock_t *)\00", align 1
@.str.14 = private unnamed_addr constant [25 x i8] c"NULL key is not allowed!\00", align 1
@.str.15 = private unnamed_addr constant [34 x i8] c"key && \22NULL key is not allowed!\22\00", align 1
@__PRETTY_FUNCTION__._vsimpleht_add = private unnamed_addr constant [66 x i8] c"vsimpleht_ret_t _vsimpleht_add(vsimpleht_t *, vuintptr_t, void *)\00", align 1
@.str.16 = private unnamed_addr constant [27 x i8] c"NULL value is not allowed!\00", align 1
@.str.17 = private unnamed_addr constant [38 x i8] c"value && \22NULL value is not allowed!\22\00", align 1
@.str.18 = private unnamed_addr constant [22 x i8] c"index < tbl->capacity\00", align 1
@.str.19 = private unnamed_addr constant [79 x i8] c"tbl->cmp_key(key, (vuintptr_t)vatomicptr_read( &tbl->entries[index].key)) == 0\00", align 1
@.str.20 = private unnamed_addr constant [6 x i8] c"trace\00", align 1
@.str.21 = private unnamed_addr constant [57 x i8] c"/home/drc/git/libvsync/test/include/test/trace_manager.h\00", align 1
@__PRETTY_FUNCTION__.trace_add = private unnamed_addr constant [38 x i8] c"void trace_add(trace_t *, vuintptr_t)\00", align 1
@.str.22 = private unnamed_addr constant [19 x i8] c"trace->initialized\00", align 1
@__PRETTY_FUNCTION__._trace_add_or_rem_occurrences = private unnamed_addr constant [76 x i8] c"void _trace_add_or_rem_occurrences(trace_t *, vuintptr_t, vsize_t, vbool_t)\00", align 1
@.str.23 = private unnamed_addr constant [6 x i8] c"found\00", align 1
@.str.24 = private unnamed_addr constant [33 x i8] c"trace->units[idx].count >= count\00", align 1
@__PRETTY_FUNCTION__.trace_find_unit_idx = private unnamed_addr constant [62 x i8] c"vbool_t trace_find_unit_idx(trace_t *, vuintptr_t, vsize_t *)\00", align 1
@__PRETTY_FUNCTION__.trace_extend = private unnamed_addr constant [29 x i8] c"void trace_extend(trace_t *)\00", align 1
@.str.25 = private unnamed_addr constant [22 x i8] c"0 && \22copying failed\22\00", align 1
@.str.26 = private unnamed_addr constant [25 x i8] c"0 && \22allocation failed\22\00", align 1
@.str.27 = private unnamed_addr constant [17 x i8] c"data->key == key\00", align 1
@.str.28 = private unnamed_addr constant [55 x i8] c"/home/drc/git/libvsync/test/include/test/map/isimple.h\00", align 1
@__PRETTY_FUNCTION__.imap_get = private unnamed_addr constant [36 x i8] c"void *imap_get(vsize_t, vuintptr_t)\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_get = private unnamed_addr constant [47 x i8] c"void *vsimpleht_get(vsimpleht_t *, vuintptr_t)\00", align 1
@g_rem = internal global [4 x %struct.trace_s] zeroinitializer, align 16, !dbg !172
@__PRETTY_FUNCTION__._vsimpleht_trigger_cleanup = private unnamed_addr constant [55 x i8] c"void _vsimpleht_trigger_cleanup(vsimpleht_t *, void *)\00", align 1
@.str.29 = private unnamed_addr constant [78 x i8] c"since we are inserting what is already in the table, this should never happen\00", align 1
@.str.30 = private unnamed_addr constant [116 x i8] c"ret != VSIMPLEHT_RET_TBL_FULL && \22since we are inserting what is already in the table, \22 \22this should never happen\22\00", align 1
@__PRETTY_FUNCTION__._vsimpleht_cleanup = private unnamed_addr constant [47 x i8] c"void _vsimpleht_cleanup(vsimpleht_t *, void *)\00", align 1
@.str.31 = private unnamed_addr constant [13 x i8] c"capacity > 0\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_buff_size = private unnamed_addr constant [37 x i8] c"vsize_t vsimpleht_buff_size(vsize_t)\00", align 1
@.str.32 = private unnamed_addr constant [28 x i8] c"capacity must be power of 2\00", align 1
@.str.33 = private unnamed_addr constant [66 x i8] c"(capacity & (capacity - 1)) == 0 && \22capacity must be power of 2\22\00", align 1
@.str.34 = private unnamed_addr constant [4 x i8] c"tbl\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_init = private unnamed_addr constant [122 x i8] c"void vsimpleht_init(vsimpleht_t *, void *, vsize_t, vsimpleht_cmp_key_t, vsimpleht_hash_key_t, vsimpleht_destroy_entry_t)\00", align 1
@.str.35 = private unnamed_addr constant [5 x i8] c"buff\00", align 1
@.str.36 = private unnamed_addr constant [30 x i8] c"Array size must be power of 2\00", align 1
@.str.37 = private unnamed_addr constant [68 x i8] c"(capacity & (capacity - 1)) == 0 && \22Array size must be power of 2\22\00", align 1
@__PRETTY_FUNCTION__.trace_init = private unnamed_addr constant [36 x i8] c"void trace_init(trace_t *, vsize_t)\00", align 1
@g_buff = internal global i8* null, align 8, !dbg !174
@.str.38 = private unnamed_addr constant [40 x i8] c"the final state is not what is expected\00", align 1
@.str.39 = private unnamed_addr constant [48 x i8] c"eq && \22the final state is not what is expected\22\00", align 1
@__PRETTY_FUNCTION__._imap_verify = private unnamed_addr constant [24 x i8] c"void _imap_verify(void)\00", align 1
@.str.40 = private unnamed_addr constant [16 x i8] c"trace_container\00", align 1
@__PRETTY_FUNCTION__._trace_merge_or_subtract = private unnamed_addr constant [61 x i8] c"void _trace_merge_or_subtract(trace_t *, trace_t *, vbool_t)\00", align 1
@.str.41 = private unnamed_addr constant [29 x i8] c"trace_container->initialized\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_iter_init = private unnamed_addr constant [60 x i8] c"void vsimpleht_iter_init(vsimpleht_t *, vsimpleht_iter_t *)\00", align 1
@.str.42 = private unnamed_addr constant [5 x i8] c"iter\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_iter_next = private unnamed_addr constant [71 x i8] c"vbool_t vsimpleht_iter_next(vsimpleht_iter_t *, vuintptr_t *, void **)\00", align 1
@.str.43 = private unnamed_addr constant [10 x i8] c"iter->tbl\00", align 1
@.str.44 = private unnamed_addr constant [4 x i8] c"key\00", align 1
@.str.45 = private unnamed_addr constant [4 x i8] c"val\00", align 1
@.str.46 = private unnamed_addr constant [8 x i8] c"entries\00", align 1
@.str.47 = private unnamed_addr constant [27 x i8] c"unit_a->key == unit_b->key\00", align 1
@__PRETTY_FUNCTION__.trace_is_subtrace = private unnamed_addr constant [70 x i8] c"vbool_t trace_is_subtrace(trace_t *, trace_t *, void (*)(vuintptr_t))\00", align 1
@.str.48 = private unnamed_addr constant [40 x i8] c"key[%lu] count is different %zu != %zu\0A\00", align 1
@.str.49 = private unnamed_addr constant [20 x i8] c"key[%lu] not found\0A\00", align 1
@__PRETTY_FUNCTION__.trace_destroy = private unnamed_addr constant [30 x i8] c"void trace_destroy(trace_t *)\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_destroy = private unnamed_addr constant [38 x i8] c"void vsimpleht_destroy(vsimpleht_t *)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @pre() #0 !dbg !184 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata i64* %1, metadata !188, metadata !DIExpression()), !dbg !189
  store i64 0, i64* %1, align 8, !dbg !189
  call void @llvm.dbg.declare(metadata i64* %2, metadata !190, metadata !DIExpression()), !dbg !191
  store i64 0, i64* %2, align 8, !dbg !191
  call void @llvm.dbg.declare(metadata i64* %3, metadata !192, metadata !DIExpression()), !dbg !193
  store i64 3, i64* %3, align 8, !dbg !193
  br label %5, !dbg !194

5:                                                ; preds = %30, %0
  %6 = load i64, i64* %1, align 8, !dbg !195
  %7 = icmp ult i64 %6, 3, !dbg !196
  br i1 %7, label %8, label %31, !dbg !194

8:                                                ; preds = %5
  %9 = load i64, i64* %2, align 8, !dbg !197
  %10 = add i64 %9, 1, !dbg !197
  store i64 %10, i64* %2, align 8, !dbg !197
  %11 = load i64, i64* %2, align 8, !dbg !199
  %12 = urem i64 %11, 4, !dbg !201
  %13 = load i64, i64* %3, align 8, !dbg !202
  %14 = icmp eq i64 %12, %13, !dbg !203
  br i1 %14, label %15, label %30, !dbg !204

15:                                               ; preds = %8
  call void @llvm.dbg.declare(metadata i8* %4, metadata !205, metadata !DIExpression()), !dbg !207
  %16 = load i64, i64* %2, align 8, !dbg !208
  %17 = load i64, i64* %2, align 8, !dbg !209
  %18 = call zeroext i1 @imap_add(i64 noundef 3, i64 noundef %16, i64 noundef %17), !dbg !210
  %19 = zext i1 %18 to i8, !dbg !207
  store i8 %19, i8* %4, align 1, !dbg !207
  %20 = load i8, i8* %4, align 1, !dbg !211
  %21 = trunc i8 %20 to i1, !dbg !211
  br i1 %21, label %22, label %23, !dbg !214

22:                                               ; preds = %15
  br label %24, !dbg !214

23:                                               ; preds = %15
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 22, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.pre, i64 0, i64 0)) #5, !dbg !211
  unreachable, !dbg !211

24:                                               ; preds = %22
  %25 = load i64, i64* %2, align 8, !dbg !215
  %26 = load i64, i64* %1, align 8, !dbg !216
  %27 = getelementptr inbounds [3 x i64], [3 x i64]* @g_keys, i64 0, i64 %26, !dbg !217
  store i64 %25, i64* %27, align 8, !dbg !218
  %28 = load i64, i64* %1, align 8, !dbg !219
  %29 = add i64 %28, 1, !dbg !219
  store i64 %29, i64* %1, align 8, !dbg !219
  br label %30, !dbg !220

30:                                               ; preds = %24, %8
  br label %5, !dbg !194, !llvm.loop !221

31:                                               ; preds = %5
  ret void, !dbg !224
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @imap_add(i64 noundef %0, i64 noundef %1, i64 noundef %2) #0 !dbg !225 {
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.data_s*, align 8
  %8 = alloca i8, align 1
  store i64 %0, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !228, metadata !DIExpression()), !dbg !229
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !230, metadata !DIExpression()), !dbg !231
  store i64 %2, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !232, metadata !DIExpression()), !dbg !233
  call void @llvm.dbg.declare(metadata %struct.data_s** %7, metadata !234, metadata !DIExpression()), !dbg !241
  %9 = call noalias i8* @malloc(i64 noundef 16) #6, !dbg !242
  %10 = bitcast i8* %9 to %struct.data_s*, !dbg !242
  store %struct.data_s* %10, %struct.data_s** %7, align 8, !dbg !241
  %11 = load i64, i64* %5, align 8, !dbg !243
  %12 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !244
  %13 = getelementptr inbounds %struct.data_s, %struct.data_s* %12, i32 0, i32 0, !dbg !245
  store i64 %11, i64* %13, align 8, !dbg !246
  %14 = load i64, i64* %6, align 8, !dbg !247
  %15 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !248
  %16 = getelementptr inbounds %struct.data_s, %struct.data_s* %15, i32 0, i32 1, !dbg !249
  store i64 %14, i64* %16, align 8, !dbg !250
  call void @llvm.dbg.declare(metadata i8* %8, metadata !251, metadata !DIExpression()), !dbg !252
  %17 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !253
  %18 = getelementptr inbounds %struct.data_s, %struct.data_s* %17, i32 0, i32 0, !dbg !254
  %19 = load i64, i64* %18, align 8, !dbg !254
  %20 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !255
  %21 = bitcast %struct.data_s* %20 to i8*, !dbg !255
  %22 = call i32 @vsimpleht_add(%struct.vsimpleht_s* noundef @g_simpleht, i64 noundef %19, i8* noundef %21), !dbg !256
  %23 = icmp eq i32 %22, 0, !dbg !257
  %24 = zext i1 %23 to i8, !dbg !252
  store i8 %24, i8* %8, align 1, !dbg !252
  %25 = load i8, i8* %8, align 1, !dbg !258
  %26 = trunc i8 %25 to i1, !dbg !258
  br i1 %26, label %27, label %33, !dbg !260

27:                                               ; preds = %3
  %28 = load i64, i64* %4, align 8, !dbg !261
  %29 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %28, !dbg !263
  %30 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !264
  %31 = getelementptr inbounds %struct.data_s, %struct.data_s* %30, i32 0, i32 0, !dbg !265
  %32 = load i64, i64* %31, align 8, !dbg !265
  call void @trace_add(%struct.trace_s* noundef %29, i64 noundef %32), !dbg !266
  br label %36, !dbg !267

33:                                               ; preds = %3
  %34 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !268
  %35 = bitcast %struct.data_s* %34 to i8*, !dbg !268
  call void @free(i8* noundef %35) #6, !dbg !270
  br label %36

36:                                               ; preds = %33, %27
  %37 = load i8, i8* %8, align 1, !dbg !271
  %38 = trunc i8 %37 to i1, !dbg !271
  ret i1 %38, !dbg !272
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @t0(i64 noundef %0) #0 !dbg !273 {
  %2 = alloca i64, align 8
  %3 = alloca i8, align 1
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !276, metadata !DIExpression()), !dbg !277
  %4 = load i64, i64* %2, align 8, !dbg !278
  %5 = icmp ult i64 %4, 3, !dbg !278
  br i1 %5, label %6, label %7, !dbg !281

6:                                                ; preds = %1
  br label %8, !dbg !281

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 31, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t0, i64 0, i64 0)) #5, !dbg !278
  unreachable, !dbg !278

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata i8* %3, metadata !282, metadata !DIExpression()), !dbg !283
  %9 = load i64, i64* %2, align 8, !dbg !284
  %10 = load i64, i64* %2, align 8, !dbg !285
  %11 = getelementptr inbounds [3 x i64], [3 x i64]* @g_keys, i64 0, i64 %10, !dbg !286
  %12 = load i64, i64* %11, align 8, !dbg !286
  %13 = load i64, i64* %2, align 8, !dbg !287
  %14 = getelementptr inbounds [3 x i64], [3 x i64]* @g_keys, i64 0, i64 %13, !dbg !288
  %15 = load i64, i64* %14, align 8, !dbg !288
  %16 = call zeroext i1 @imap_add(i64 noundef %9, i64 noundef %12, i64 noundef %15), !dbg !289
  %17 = zext i1 %16 to i8, !dbg !283
  store i8 %17, i8* %3, align 1, !dbg !283
  %18 = load i8, i8* %3, align 1, !dbg !290
  %19 = trunc i8 %18 to i1, !dbg !290
  br i1 %19, label %21, label %20, !dbg !293

20:                                               ; preds = %8
  br label %22, !dbg !293

21:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 33, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t0, i64 0, i64 0)) #5, !dbg !290
  unreachable, !dbg !290

22:                                               ; preds = %20
  ret void, !dbg !294
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @t1(i64 noundef %0) #0 !dbg !295 {
  %2 = alloca i64, align 8
  %3 = alloca %struct.data_s*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !296, metadata !DIExpression()), !dbg !297
  %4 = load i64, i64* %2, align 8, !dbg !298
  %5 = icmp ult i64 %4, 3, !dbg !298
  br i1 %5, label %6, label %7, !dbg !301

6:                                                ; preds = %1
  br label %8, !dbg !301

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t1, i64 0, i64 0)) #5, !dbg !298
  unreachable, !dbg !298

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata %struct.data_s** %3, metadata !302, metadata !DIExpression()), !dbg !303
  %9 = load i64, i64* %2, align 8, !dbg !304
  %10 = load i64, i64* %2, align 8, !dbg !305
  %11 = getelementptr inbounds [3 x i64], [3 x i64]* @g_keys, i64 0, i64 %10, !dbg !306
  %12 = load i64, i64* %11, align 8, !dbg !306
  %13 = call i8* @imap_get(i64 noundef %9, i64 noundef %12), !dbg !307
  %14 = bitcast i8* %13 to %struct.data_s*, !dbg !307
  store %struct.data_s* %14, %struct.data_s** %3, align 8, !dbg !303
  %15 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !308
  %16 = icmp ne %struct.data_s* %15, null, !dbg !308
  br i1 %16, label %17, label %18, !dbg !311

17:                                               ; preds = %8
  br label %19, !dbg !311

18:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 40, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t1, i64 0, i64 0)) #5, !dbg !308
  unreachable, !dbg !308

19:                                               ; preds = %17
  ret void, !dbg !312
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @imap_get(i64 noundef %0, i64 noundef %1) #0 !dbg !313 {
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca %struct.data_s*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !316, metadata !DIExpression()), !dbg !317
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !318, metadata !DIExpression()), !dbg !319
  br label %6, !dbg !320

6:                                                ; preds = %2
  br label %7, !dbg !321

7:                                                ; preds = %6
  %8 = load i64, i64* %3, align 8, !dbg !323
  br label %9, !dbg !323

9:                                                ; preds = %7
  br label %10, !dbg !325

10:                                               ; preds = %9
  br label %11, !dbg !323

11:                                               ; preds = %10
  br label %12, !dbg !321

12:                                               ; preds = %11
  call void @llvm.dbg.declare(metadata %struct.data_s** %5, metadata !327, metadata !DIExpression()), !dbg !328
  %13 = load i64, i64* %4, align 8, !dbg !329
  %14 = call i8* @vsimpleht_get(%struct.vsimpleht_s* noundef @g_simpleht, i64 noundef %13), !dbg !330
  %15 = bitcast i8* %14 to %struct.data_s*, !dbg !330
  store %struct.data_s* %15, %struct.data_s** %5, align 8, !dbg !328
  %16 = load %struct.data_s*, %struct.data_s** %5, align 8, !dbg !331
  %17 = icmp ne %struct.data_s* %16, null, !dbg !331
  br i1 %17, label %18, label %27, !dbg !333

18:                                               ; preds = %12
  %19 = load %struct.data_s*, %struct.data_s** %5, align 8, !dbg !334
  %20 = getelementptr inbounds %struct.data_s, %struct.data_s* %19, i32 0, i32 0, !dbg !334
  %21 = load i64, i64* %20, align 8, !dbg !334
  %22 = load i64, i64* %4, align 8, !dbg !334
  %23 = icmp eq i64 %21, %22, !dbg !334
  br i1 %23, label %24, label %25, !dbg !338

24:                                               ; preds = %18
  br label %26, !dbg !338

25:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.27, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.28, i64 0, i64 0), i32 noundef 171, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.imap_get, i64 0, i64 0)) #5, !dbg !334
  unreachable, !dbg !334

26:                                               ; preds = %24
  br label %27, !dbg !339

27:                                               ; preds = %26, %12
  %28 = load %struct.data_s*, %struct.data_s** %5, align 8, !dbg !340
  %29 = bitcast %struct.data_s* %28 to i8*, !dbg !340
  ret i8* %29, !dbg !341
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @t2(i64 noundef %0) #0 !dbg !342 {
  %2 = alloca i64, align 8
  %3 = alloca i8, align 1
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !343, metadata !DIExpression()), !dbg !344
  %4 = load i64, i64* %2, align 8, !dbg !345
  %5 = icmp ult i64 %4, 3, !dbg !345
  br i1 %5, label %6, label %7, !dbg !348

6:                                                ; preds = %1
  br label %8, !dbg !348

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 45, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t2, i64 0, i64 0)) #5, !dbg !345
  unreachable, !dbg !345

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata i8* %3, metadata !349, metadata !DIExpression()), !dbg !350
  %9 = load i64, i64* %2, align 8, !dbg !351
  %10 = load i64, i64* %2, align 8, !dbg !352
  %11 = getelementptr inbounds [3 x i64], [3 x i64]* @g_keys, i64 0, i64 %10, !dbg !353
  %12 = load i64, i64* %11, align 8, !dbg !353
  %13 = call zeroext i1 @imap_rem(i64 noundef %9, i64 noundef %12), !dbg !354
  %14 = zext i1 %13 to i8, !dbg !350
  store i8 %14, i8* %3, align 1, !dbg !350
  %15 = load i8, i8* %3, align 1, !dbg !355
  %16 = trunc i8 %15 to i1, !dbg !355
  br i1 %16, label %17, label %18, !dbg !358

17:                                               ; preds = %8
  br label %19, !dbg !358

18:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 47, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t2, i64 0, i64 0)) #5, !dbg !355
  unreachable, !dbg !355

19:                                               ; preds = %17
  ret void, !dbg !359
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @imap_rem(i64 noundef %0, i64 noundef %1) #0 !dbg !360 {
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i8, align 1
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !363, metadata !DIExpression()), !dbg !364
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !365, metadata !DIExpression()), !dbg !366
  call void @llvm.dbg.declare(metadata i8* %5, metadata !367, metadata !DIExpression()), !dbg !368
  %6 = load i64, i64* %4, align 8, !dbg !369
  %7 = call i32 @vsimpleht_remove(%struct.vsimpleht_s* noundef @g_simpleht, i64 noundef %6), !dbg !370
  %8 = icmp eq i32 %7, 0, !dbg !371
  %9 = zext i1 %8 to i8, !dbg !368
  store i8 %9, i8* %5, align 1, !dbg !368
  %10 = load i8, i8* %5, align 1, !dbg !372
  %11 = trunc i8 %10 to i1, !dbg !372
  br i1 %11, label %12, label %16, !dbg !374

12:                                               ; preds = %2
  %13 = load i64, i64* %3, align 8, !dbg !375
  %14 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_rem, i64 0, i64 %13, !dbg !377
  %15 = load i64, i64* %4, align 8, !dbg !378
  call void @trace_add(%struct.trace_s* noundef %14, i64 noundef %15), !dbg !379
  br label %16, !dbg !380

16:                                               ; preds = %12, %2
  %17 = load i8, i8* %5, align 1, !dbg !381
  %18 = trunc i8 %17 to i1, !dbg !381
  ret i1 %18, !dbg !382
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !383 {
  ret void, !dbg !384
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !385 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !387, metadata !DIExpression()), !dbg !388
  call void @llvm.dbg.declare(metadata i64* %3, metadata !389, metadata !DIExpression()), !dbg !390
  %4 = load i8*, i8** %2, align 8, !dbg !391
  %5 = ptrtoint i8* %4 to i64, !dbg !392
  store i64 %5, i64* %3, align 8, !dbg !390
  %6 = load i64, i64* %3, align 8, !dbg !393
  %7 = icmp ult i64 %6, 3, !dbg !393
  br i1 %7, label %8, label %9, !dbg !396

8:                                                ; preds = %1
  br label %10, !dbg !396

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.6, i64 0, i64 0), i32 noundef 97, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !393
  unreachable, !dbg !393

10:                                               ; preds = %8
  %11 = load i64, i64* %3, align 8, !dbg !397
  call void @reg(i64 noundef %11), !dbg !398
  %12 = load i64, i64* %3, align 8, !dbg !399
  switch i64 %12, label %19 [
    i64 0, label %13
    i64 1, label %15
    i64 2, label %17
  ], !dbg !400

13:                                               ; preds = %10
  %14 = load i64, i64* %3, align 8, !dbg !401
  call void @t0(i64 noundef %14), !dbg !403
  br label %20, !dbg !404

15:                                               ; preds = %10
  %16 = load i64, i64* %3, align 8, !dbg !405
  call void @t1(i64 noundef %16), !dbg !406
  br label %20, !dbg !407

17:                                               ; preds = %10
  %18 = load i64, i64* %3, align 8, !dbg !408
  call void @t2(i64 noundef %18), !dbg !409
  br label %20, !dbg !410

19:                                               ; preds = %10
  br label %20, !dbg !411

20:                                               ; preds = %19, %17, %15, %13
  %21 = load i64, i64* %3, align 8, !dbg !412
  call void @dereg(i64 noundef %21), !dbg !413
  ret i8* null, !dbg !414
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reg(i64 noundef %0) #0 !dbg !415 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !417, metadata !DIExpression()), !dbg !418
  %3 = load i64, i64* %2, align 8, !dbg !419
  call void @imap_reg(i64 noundef %3), !dbg !420
  ret void, !dbg !421
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @dereg(i64 noundef %0) #0 !dbg !422 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !423, metadata !DIExpression()), !dbg !424
  %3 = load i64, i64* %2, align 8, !dbg !425
  call void @imap_dereg(i64 noundef %3), !dbg !426
  ret void, !dbg !427
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @tc() #0 !dbg !428 {
  call void @init(), !dbg !429
  call void @pre(), !dbg !430
  call void @launch_threads(i64 noundef 3, i8* (i8*)* noundef @run), !dbg !431
  call void @post(), !dbg !432
  call void @fini(), !dbg !433
  ret void, !dbg !434
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !435 {
  call void @imap_init(), !dbg !436
  ret void, !dbg !437
}

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !438 {
  %3 = alloca i64, align 8
  %4 = alloca i8* (i8*)*, align 8
  %5 = alloca %struct.run_info_t*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !441, metadata !DIExpression()), !dbg !442
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %4, metadata !443, metadata !DIExpression()), !dbg !444
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !445, metadata !DIExpression()), !dbg !446
  %6 = load i64, i64* %3, align 8, !dbg !447
  %7 = mul i64 32, %6, !dbg !448
  %8 = call noalias i8* @malloc(i64 noundef %7) #6, !dbg !449
  %9 = bitcast i8* %8 to %struct.run_info_t*, !dbg !449
  store %struct.run_info_t* %9, %struct.run_info_t** %5, align 8, !dbg !446
  %10 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !450
  %11 = load i64, i64* %3, align 8, !dbg !451
  %12 = load i8* (i8*)*, i8* (i8*)** %4, align 8, !dbg !452
  call void @create_threads(%struct.run_info_t* noundef %10, i64 noundef %11, i8* (i8*)* noundef %12, i1 noundef zeroext true), !dbg !453
  %13 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !454
  %14 = load i64, i64* %3, align 8, !dbg !455
  call void @await_threads(%struct.run_info_t* noundef %13, i64 noundef %14), !dbg !456
  %15 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !457
  %16 = bitcast %struct.run_info_t* %15 to i8*, !dbg !457
  call void @free(i8* noundef %16) #6, !dbg !458
  ret void, !dbg !459
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !460 {
  call void @imap_destroy(), !dbg !461
  ret void, !dbg !462
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_reg(i64 noundef %0) #0 !dbg !463 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !464, metadata !DIExpression()), !dbg !465
  br label %3, !dbg !466

3:                                                ; preds = %1
  br label %4, !dbg !467

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !469
  br label %6, !dbg !469

6:                                                ; preds = %4
  br label %7, !dbg !471

7:                                                ; preds = %6
  br label %8, !dbg !469

8:                                                ; preds = %7
  br label %9, !dbg !467

9:                                                ; preds = %8
  call void @vsimpleht_thread_register(%struct.vsimpleht_s* noundef @g_simpleht), !dbg !473
  ret void, !dbg !474
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_dereg(i64 noundef %0) #0 !dbg !475 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !476, metadata !DIExpression()), !dbg !477
  br label %3, !dbg !478

3:                                                ; preds = %1
  br label %4, !dbg !479

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !481
  br label %6, !dbg !481

6:                                                ; preds = %4
  br label %7, !dbg !483

7:                                                ; preds = %6
  br label %8, !dbg !481

8:                                                ; preds = %7
  br label %9, !dbg !479

9:                                                ; preds = %8
  call void @vsimpleht_thread_deregister(%struct.vsimpleht_s* noundef @g_simpleht), !dbg !485
  ret void, !dbg !486
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_init() #0 !dbg !487 {
  %1 = alloca i64, align 8
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !488, metadata !DIExpression()), !dbg !489
  %4 = call i64 @vsimpleht_buff_size(i64 noundef 4), !dbg !490
  store i64 %4, i64* %1, align 8, !dbg !489
  call void @llvm.dbg.declare(metadata i8** %2, metadata !491, metadata !DIExpression()), !dbg !492
  %5 = load i64, i64* %1, align 8, !dbg !493
  %6 = call noalias i8* @malloc(i64 noundef %5) #6, !dbg !494
  store i8* %6, i8** %2, align 8, !dbg !492
  %7 = load i8*, i8** %2, align 8, !dbg !495
  call void @vsimpleht_init(%struct.vsimpleht_s* noundef @g_simpleht, i8* noundef %7, i64 noundef 4, i8 (i64, i64)* noundef @cb_cmp, i64 (i64)* noundef @cb_hash, void (i8*)* noundef @cb_destroy), !dbg !496
  call void @llvm.dbg.declare(metadata i64* %3, metadata !497, metadata !DIExpression()), !dbg !499
  store i64 0, i64* %3, align 8, !dbg !499
  br label %8, !dbg !500

8:                                                ; preds = %16, %0
  %9 = load i64, i64* %3, align 8, !dbg !501
  %10 = icmp ult i64 %9, 4, !dbg !503
  br i1 %10, label %11, label %19, !dbg !504

11:                                               ; preds = %8
  %12 = load i64, i64* %3, align 8, !dbg !505
  %13 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %12, !dbg !507
  call void @trace_init(%struct.trace_s* noundef %13, i64 noundef 8), !dbg !508
  %14 = load i64, i64* %3, align 8, !dbg !509
  %15 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_rem, i64 0, i64 %14, !dbg !510
  call void @trace_init(%struct.trace_s* noundef %15, i64 noundef 8), !dbg !511
  br label %16, !dbg !512

16:                                               ; preds = %11
  %17 = load i64, i64* %3, align 8, !dbg !513
  %18 = add i64 %17, 1, !dbg !513
  store i64 %18, i64* %3, align 8, !dbg !513
  br label %8, !dbg !514, !llvm.loop !515

19:                                               ; preds = %8
  ret void, !dbg !517
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_destroy() #0 !dbg !518 {
  %1 = alloca i64, align 8
  call void @_imap_verify(), !dbg !519
  call void @llvm.dbg.declare(metadata i64* %1, metadata !520, metadata !DIExpression()), !dbg !522
  store i64 0, i64* %1, align 8, !dbg !522
  br label %2, !dbg !523

2:                                                ; preds = %10, %0
  %3 = load i64, i64* %1, align 8, !dbg !524
  %4 = icmp ult i64 %3, 4, !dbg !526
  br i1 %4, label %5, label %13, !dbg !527

5:                                                ; preds = %2
  %6 = load i64, i64* %1, align 8, !dbg !528
  %7 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %6, !dbg !530
  call void @trace_destroy(%struct.trace_s* noundef %7), !dbg !531
  %8 = load i64, i64* %1, align 8, !dbg !532
  %9 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_rem, i64 0, i64 %8, !dbg !533
  call void @trace_destroy(%struct.trace_s* noundef %9), !dbg !534
  br label %10, !dbg !535

10:                                               ; preds = %5
  %11 = load i64, i64* %1, align 8, !dbg !536
  %12 = add i64 %11, 1, !dbg !536
  store i64 %12, i64* %1, align 8, !dbg !536
  br label %2, !dbg !537, !llvm.loop !538

13:                                               ; preds = %2
  call void @vsimpleht_destroy(%struct.vsimpleht_s* noundef @g_simpleht), !dbg !540
  %14 = load i8*, i8** @g_buff, align 8, !dbg !541
  call void @free(i8* noundef %14) #6, !dbg !542
  store i8* null, i8** @g_buff, align 8, !dbg !543
  ret void, !dbg !544
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !545 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @tc(), !dbg !548
  ret i32 0, !dbg !549
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i32 @vsimpleht_add(%struct.vsimpleht_s* noundef %0, i64 noundef %1, i8* noundef %2) #0 !dbg !550 {
  %4 = alloca %struct.vsimpleht_s*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i8*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %4, metadata !555, metadata !DIExpression()), !dbg !556
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !557, metadata !DIExpression()), !dbg !558
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !559, metadata !DIExpression()), !dbg !560
  %7 = load i64, i64* %5, align 8, !dbg !561
  %8 = icmp ne i64 %7, 0, !dbg !561
  br i1 %8, label %9, label %10, !dbg !564

9:                                                ; preds = %3
  br label %11, !dbg !564

10:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.7, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 243, i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @__PRETTY_FUNCTION__.vsimpleht_add, i64 0, i64 0)) #5, !dbg !561
  unreachable, !dbg !561

11:                                               ; preds = %9
  %12 = load i8*, i8** %6, align 8, !dbg !565
  %13 = icmp ne i8* %12, null, !dbg !565
  br i1 %13, label %14, label %15, !dbg !568

14:                                               ; preds = %11
  br label %16, !dbg !568

15:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 244, i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @__PRETTY_FUNCTION__.vsimpleht_add, i64 0, i64 0)) #5, !dbg !565
  unreachable, !dbg !565

16:                                               ; preds = %14
  %17 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !569
  call void @_vsimpleht_give_cleanup_a_chance(%struct.vsimpleht_s* noundef %17), !dbg !570
  %18 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !571
  %19 = load i64, i64* %5, align 8, !dbg !572
  %20 = load i8*, i8** %6, align 8, !dbg !573
  %21 = call i32 @_vsimpleht_add(%struct.vsimpleht_s* noundef %18, i64 noundef %19, i8* noundef %20), !dbg !574
  ret i32 %21, !dbg !575
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_add(%struct.trace_s* noundef %0, i64 noundef %1) #0 !dbg !576 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !580, metadata !DIExpression()), !dbg !581
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !582, metadata !DIExpression()), !dbg !583
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !584
  %6 = icmp ne %struct.trace_s* %5, null, !dbg !584
  br i1 %6, label %7, label %8, !dbg !587

7:                                                ; preds = %2
  br label %9, !dbg !587

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.20, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 155, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__.trace_add, i64 0, i64 0)) #5, !dbg !584
  unreachable, !dbg !584

9:                                                ; preds = %7
  %10 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !588
  %11 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %10, i32 0, i32 3, !dbg !588
  %12 = load i8, i8* %11, align 8, !dbg !588
  %13 = trunc i8 %12 to i1, !dbg !588
  br i1 %13, label %14, label %15, !dbg !591

14:                                               ; preds = %9
  br label %16, !dbg !591

15:                                               ; preds = %9
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.22, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 156, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__.trace_add, i64 0, i64 0)) #5, !dbg !588
  unreachable, !dbg !588

16:                                               ; preds = %14
  %17 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !592
  %18 = load i64, i64* %4, align 8, !dbg !593
  call void @_trace_add_or_rem_occurrences(%struct.trace_s* noundef %17, i64 noundef %18, i64 noundef 1, i1 noundef zeroext false), !dbg !594
  ret void, !dbg !595
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @_vsimpleht_give_cleanup_a_chance(%struct.vsimpleht_s* noundef %0) #0 !dbg !596 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !599, metadata !DIExpression()), !dbg !600
  %3 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !601
  %4 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %3, i32 0, i32 7, !dbg !603
  %5 = call zeroext i1 @rwlock_acquired_by_writer(%struct.rwlock_s* noundef %4), !dbg !604
  br i1 %5, label %6, label %18, !dbg !605

6:                                                ; preds = %1
  %7 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !606
  %8 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %7, i32 0, i32 7, !dbg !606
  %9 = call zeroext i1 @rwlock_acquired_by_readers(%struct.rwlock_s* noundef %8), !dbg !606
  br i1 %9, label %10, label %12, !dbg !606

10:                                               ; preds = %6
  br i1 true, label %11, label %12, !dbg !610

11:                                               ; preds = %10
  br label %13, !dbg !610

12:                                               ; preds = %10, %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([112 x i8], [112 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 487, i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @__PRETTY_FUNCTION__._vsimpleht_give_cleanup_a_chance, i64 0, i64 0)) #5, !dbg !606
  unreachable, !dbg !606

13:                                               ; preds = %11
  %14 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !611
  %15 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %14, i32 0, i32 7, !dbg !612
  call void @rwlock_read_release(%struct.rwlock_s* noundef %15), !dbg !613
  %16 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !614
  %17 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %16, i32 0, i32 7, !dbg !615
  call void @rwlock_read_acquire(%struct.rwlock_s* noundef %17), !dbg !616
  br label %18, !dbg !617

18:                                               ; preds = %13, %1
  ret void, !dbg !618
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @_vsimpleht_add(%struct.vsimpleht_s* noundef %0, i64 noundef %1, i8* noundef %2) #0 !dbg !619 {
  %4 = alloca i32, align 4
  %5 = alloca %struct.vsimpleht_s*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca i8*, align 8
  %11 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %5, metadata !620, metadata !DIExpression()), !dbg !621
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !622, metadata !DIExpression()), !dbg !623
  store i8* %2, i8** %7, align 8
  call void @llvm.dbg.declare(metadata i8** %7, metadata !624, metadata !DIExpression()), !dbg !625
  call void @llvm.dbg.declare(metadata i64* %8, metadata !626, metadata !DIExpression()), !dbg !627
  store i64 0, i64* %8, align 8, !dbg !627
  call void @llvm.dbg.declare(metadata i64* %9, metadata !628, metadata !DIExpression()), !dbg !629
  store i64 0, i64* %9, align 8, !dbg !629
  call void @llvm.dbg.declare(metadata i8** %10, metadata !630, metadata !DIExpression()), !dbg !631
  store i8* null, i8** %10, align 8, !dbg !631
  call void @llvm.dbg.declare(metadata i64* %11, metadata !632, metadata !DIExpression()), !dbg !633
  store i64 0, i64* %11, align 8, !dbg !633
  %12 = load i64, i64* %6, align 8, !dbg !634
  %13 = icmp ne i64 %12, 0, !dbg !634
  br i1 %13, label %14, label %16, !dbg !634

14:                                               ; preds = %3
  br i1 true, label %15, label %16, !dbg !637

15:                                               ; preds = %14
  br label %17, !dbg !637

16:                                               ; preds = %14, %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.15, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 423, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !634
  unreachable, !dbg !634

17:                                               ; preds = %15
  %18 = load i8*, i8** %7, align 8, !dbg !638
  %19 = icmp ne i8* %18, null, !dbg !638
  br i1 %19, label %20, label %22, !dbg !638

20:                                               ; preds = %17
  br i1 true, label %21, label %22, !dbg !641

21:                                               ; preds = %20
  br label %23, !dbg !641

22:                                               ; preds = %20, %17
  call void @__assert_fail(i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @.str.17, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 424, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !638
  unreachable, !dbg !638

23:                                               ; preds = %21
  %24 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !642
  %25 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %24, i32 0, i32 3, !dbg !644
  %26 = load i64 (i64)*, i64 (i64)** %25, align 8, !dbg !644
  %27 = load i64, i64* %6, align 8, !dbg !645
  %28 = call i64 %26(i64 noundef %27), !dbg !642
  store i64 %28, i64* %8, align 8, !dbg !646
  br label %29, !dbg !647

29:                                               ; preds = %126, %23
  %30 = load i64, i64* %11, align 8, !dbg !648
  %31 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !650
  %32 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %31, i32 0, i32 0, !dbg !651
  %33 = load i64, i64* %32, align 8, !dbg !651
  %34 = icmp ult i64 %30, %33, !dbg !652
  br i1 %34, label %35, label %131, !dbg !653

35:                                               ; preds = %29
  %36 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !654
  %37 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %36, i32 0, i32 0, !dbg !656
  %38 = load i64, i64* %37, align 8, !dbg !656
  %39 = sub i64 %38, 1, !dbg !657
  %40 = load i64, i64* %8, align 8, !dbg !658
  %41 = and i64 %40, %39, !dbg !658
  store i64 %41, i64* %8, align 8, !dbg !658
  %42 = load i64, i64* %8, align 8, !dbg !659
  %43 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !659
  %44 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %43, i32 0, i32 0, !dbg !659
  %45 = load i64, i64* %44, align 8, !dbg !659
  %46 = icmp ult i64 %42, %45, !dbg !659
  br i1 %46, label %47, label %48, !dbg !662

47:                                               ; preds = %35
  br label %49, !dbg !662

48:                                               ; preds = %35
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 431, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !659
  unreachable, !dbg !659

49:                                               ; preds = %47
  %50 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !663
  %51 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %50, i32 0, i32 1, !dbg !664
  %52 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %51, align 8, !dbg !664
  %53 = load i64, i64* %8, align 8, !dbg !665
  %54 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %52, i64 %53, !dbg !663
  %55 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %54, i32 0, i32 0, !dbg !666
  %56 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %55), !dbg !667
  %57 = ptrtoint i8* %56 to i64, !dbg !668
  store i64 %57, i64* %9, align 8, !dbg !669
  %58 = load i64, i64* %9, align 8, !dbg !670
  %59 = icmp eq i64 %58, 0, !dbg !672
  br i1 %59, label %60, label %84, !dbg !673

60:                                               ; preds = %49
  %61 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !674
  %62 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %61, i32 0, i32 1, !dbg !676
  %63 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %62, align 8, !dbg !676
  %64 = load i64, i64* %8, align 8, !dbg !677
  %65 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %63, i64 %64, !dbg !674
  %66 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %65, i32 0, i32 0, !dbg !678
  %67 = load i64, i64* %6, align 8, !dbg !679
  %68 = inttoptr i64 %67 to i8*, !dbg !680
  %69 = call i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %66, i8* noundef null, i8* noundef %68), !dbg !681
  %70 = ptrtoint i8* %69 to i64, !dbg !682
  store i64 %70, i64* %9, align 8, !dbg !683
  %71 = load i64, i64* %9, align 8, !dbg !684
  %72 = icmp ne i64 %71, 0, !dbg !686
  br i1 %72, label %73, label %83, !dbg !687

73:                                               ; preds = %60
  %74 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !688
  %75 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %74, i32 0, i32 2, !dbg !689
  %76 = load i8 (i64, i64)*, i8 (i64, i64)** %75, align 8, !dbg !689
  %77 = load i64, i64* %6, align 8, !dbg !690
  %78 = load i64, i64* %9, align 8, !dbg !691
  %79 = call signext i8 %76(i64 noundef %77, i64 noundef %78), !dbg !688
  %80 = sext i8 %79 to i32, !dbg !688
  %81 = icmp ne i32 %80, 0, !dbg !692
  br i1 %81, label %82, label %83, !dbg !693

82:                                               ; preds = %73
  br label %126, !dbg !694

83:                                               ; preds = %73, %60
  br label %95, !dbg !696

84:                                               ; preds = %49
  %85 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !697
  %86 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %85, i32 0, i32 2, !dbg !699
  %87 = load i8 (i64, i64)*, i8 (i64, i64)** %86, align 8, !dbg !699
  %88 = load i64, i64* %6, align 8, !dbg !700
  %89 = load i64, i64* %9, align 8, !dbg !701
  %90 = call signext i8 %87(i64 noundef %88, i64 noundef %89), !dbg !697
  %91 = sext i8 %90 to i32, !dbg !697
  %92 = icmp ne i32 %91, 0, !dbg !702
  br i1 %92, label %93, label %94, !dbg !703

93:                                               ; preds = %84
  br label %126, !dbg !704

94:                                               ; preds = %84
  br label %95

95:                                               ; preds = %94, %83
  %96 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !706
  %97 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %96, i32 0, i32 2, !dbg !706
  %98 = load i8 (i64, i64)*, i8 (i64, i64)** %97, align 8, !dbg !706
  %99 = load i64, i64* %6, align 8, !dbg !706
  %100 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !706
  %101 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %100, i32 0, i32 1, !dbg !706
  %102 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %101, align 8, !dbg !706
  %103 = load i64, i64* %8, align 8, !dbg !706
  %104 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %102, i64 %103, !dbg !706
  %105 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %104, i32 0, i32 0, !dbg !706
  %106 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %105), !dbg !706
  %107 = ptrtoint i8* %106 to i64, !dbg !706
  %108 = call signext i8 %98(i64 noundef %99, i64 noundef %107), !dbg !706
  %109 = sext i8 %108 to i32, !dbg !706
  %110 = icmp eq i32 %109, 0, !dbg !706
  br i1 %110, label %111, label %112, !dbg !709

111:                                              ; preds = %95
  br label %113, !dbg !709

112:                                              ; preds = %95
  call void @__assert_fail(i8* noundef getelementptr inbounds ([79 x i8], [79 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 451, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !706
  unreachable, !dbg !706

113:                                              ; preds = %111
  %114 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !710
  %115 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %114, i32 0, i32 1, !dbg !711
  %116 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %115, align 8, !dbg !711
  %117 = load i64, i64* %8, align 8, !dbg !712
  %118 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %116, i64 %117, !dbg !710
  %119 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %118, i32 0, i32 1, !dbg !713
  %120 = load i8*, i8** %7, align 8, !dbg !714
  %121 = call i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %119, i8* noundef null, i8* noundef %120), !dbg !715
  store i8* %121, i8** %10, align 8, !dbg !716
  %122 = load i8*, i8** %10, align 8, !dbg !717
  %123 = icmp eq i8* %122, null, !dbg !718
  %124 = zext i1 %123 to i64, !dbg !719
  %125 = select i1 %123, i32 0, i32 2, !dbg !719
  store i32 %125, i32* %4, align 4, !dbg !720
  br label %132, !dbg !720

126:                                              ; preds = %93, %82
  %127 = load i64, i64* %11, align 8, !dbg !721
  %128 = add i64 %127, 1, !dbg !721
  store i64 %128, i64* %11, align 8, !dbg !721
  %129 = load i64, i64* %8, align 8, !dbg !722
  %130 = add i64 %129, 1, !dbg !722
  store i64 %130, i64* %8, align 8, !dbg !722
  br label %29, !dbg !723, !llvm.loop !724

131:                                              ; preds = %29
  store i32 1, i32* %4, align 4, !dbg !726
  br label %132, !dbg !726

132:                                              ; preds = %131, %113
  %133 = load i32, i32* %4, align 4, !dbg !727
  ret i32 %133, !dbg !727
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @rwlock_acquired_by_writer(%struct.rwlock_s* noundef %0) #0 !dbg !728 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !732, metadata !DIExpression()), !dbg !733
  %3 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !734
  %4 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %3, i32 0, i32 1, !dbg !735
  %5 = call zeroext i8 @vatomic8_read_rlx(%struct.vatomic8_s* noundef %4), !dbg !736
  %6 = zext i8 %5 to i32, !dbg !736
  %7 = icmp eq i32 %6, 1, !dbg !737
  ret i1 %7, !dbg !738
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @rwlock_acquired_by_readers(%struct.rwlock_s* noundef %0) #0 !dbg !739 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !740, metadata !DIExpression()), !dbg !741
  br label %3, !dbg !742

3:                                                ; preds = %1
  br label %4, !dbg !743

4:                                                ; preds = %3
  %5 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !745
  br label %6, !dbg !745

6:                                                ; preds = %4
  br label %7, !dbg !747

7:                                                ; preds = %6
  br label %8, !dbg !745

8:                                                ; preds = %7
  br label %9, !dbg !743

9:                                                ; preds = %8
  ret i1 true, !dbg !749
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_read_release(%struct.rwlock_s* noundef %0) #0 !dbg !750 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !753, metadata !DIExpression()), !dbg !754
  call void @llvm.dbg.declare(metadata i32* %3, metadata !755, metadata !DIExpression()), !dbg !756
  %4 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !757
  %5 = call i32 @_rwlock_get_tid(%struct.rwlock_s* noundef %4), !dbg !758
  store i32 %5, i32* %3, align 4, !dbg !756
  %6 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !759
  %7 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %6, i32 0, i32 0, !dbg !760
  %8 = load i32, i32* %3, align 4, !dbg !761
  %9 = zext i32 %8 to i64, !dbg !759
  %10 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %7, i64 0, i64 %9, !dbg !759
  %11 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef %10) #6, !dbg !762
  ret void, !dbg !763
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_read_acquire(%struct.rwlock_s* noundef %0) #0 !dbg !764 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !765, metadata !DIExpression()), !dbg !766
  call void @llvm.dbg.declare(metadata i32* %3, metadata !767, metadata !DIExpression()), !dbg !768
  %4 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !769
  %5 = call i32 @_rwlock_get_tid(%struct.rwlock_s* noundef %4), !dbg !770
  store i32 %5, i32* %3, align 4, !dbg !768
  %6 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !771
  %7 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %6, i32 0, i32 0, !dbg !772
  %8 = load i32, i32* %3, align 4, !dbg !773
  %9 = zext i32 %8 to i64, !dbg !771
  %10 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %7, i64 0, i64 %9, !dbg !771
  %11 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef %10) #6, !dbg !774
  ret void, !dbg !775
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i8 @vatomic8_read_rlx(%struct.vatomic8_s* noundef %0) #0 !dbg !776 {
  %2 = alloca %struct.vatomic8_s*, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  store %struct.vatomic8_s* %0, %struct.vatomic8_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic8_s** %2, metadata !782, metadata !DIExpression()), !dbg !783
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !784, !srcloc !785
  call void @llvm.dbg.declare(metadata i8* %3, metadata !786, metadata !DIExpression()), !dbg !787
  %5 = load %struct.vatomic8_s*, %struct.vatomic8_s** %2, align 8, !dbg !788
  %6 = getelementptr inbounds %struct.vatomic8_s, %struct.vatomic8_s* %5, i32 0, i32 0, !dbg !789
  %7 = load atomic i8, i8* %6 monotonic, align 1, !dbg !790
  store i8 %7, i8* %4, align 1, !dbg !790
  %8 = load i8, i8* %4, align 1, !dbg !790
  store i8 %8, i8* %3, align 1, !dbg !787
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !791, !srcloc !792
  %9 = load i8, i8* %3, align 1, !dbg !793
  ret i8 %9, !dbg !794
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @_rwlock_get_tid(%struct.rwlock_s* noundef %0) #0 !dbg !795 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !798, metadata !DIExpression()), !dbg !799
  %3 = load i32, i32* @g_tid, align 4, !dbg !800
  %4 = icmp eq i32 %3, 3, !dbg !802
  br i1 %4, label %5, label %14, !dbg !803

5:                                                ; preds = %1
  %6 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !804
  %7 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %6, i32 0, i32 2, !dbg !806
  %8 = call i32 @vatomic32_get_inc(%struct.vatomic32_s* noundef %7), !dbg !807
  store i32 %8, i32* @g_tid, align 4, !dbg !808
  %9 = load i32, i32* @g_tid, align 4, !dbg !809
  %10 = icmp ult i32 %9, 3, !dbg !809
  br i1 %10, label %11, label %12, !dbg !812

11:                                               ; preds = %5
  br label %13, !dbg !812

12:                                               ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.12, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.13, i64 0, i64 0), i32 noundef 93, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__._rwlock_get_tid, i64 0, i64 0)) #5, !dbg !809
  unreachable, !dbg !809

13:                                               ; preds = %11
  br label %14, !dbg !813

14:                                               ; preds = %13, %1
  %15 = load i32, i32* @g_tid, align 4, !dbg !814
  ret i32 %15, !dbg !815
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc(%struct.vatomic32_s* noundef %0) #0 !dbg !816 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !821, metadata !DIExpression()), !dbg !822
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !823
  %4 = call i32 @vatomic32_get_add(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !824
  ret i32 %4, !dbg !825
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !826 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !829, metadata !DIExpression()), !dbg !830
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !831, metadata !DIExpression()), !dbg !832
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !833, !srcloc !834
  call void @llvm.dbg.declare(metadata i32* %5, metadata !835, metadata !DIExpression()), !dbg !836
  %8 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !837
  %9 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %8, i32 0, i32 0, !dbg !838
  %10 = load i32, i32* %4, align 4, !dbg !839
  store i32 %10, i32* %6, align 4, !dbg !840
  %11 = load i32, i32* %6, align 4, !dbg !840
  %12 = atomicrmw add i32* %9, i32 %11 seq_cst, align 4, !dbg !840
  store i32 %12, i32* %7, align 4, !dbg !840
  %13 = load i32, i32* %7, align 4, !dbg !840
  store i32 %13, i32* %5, align 4, !dbg !836
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !841, !srcloc !842
  %14 = load i32, i32* %5, align 4, !dbg !843
  ret i32 %14, !dbg !844
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %0) #0 !dbg !845 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !850, metadata !DIExpression()), !dbg !851
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !852, !srcloc !853
  call void @llvm.dbg.declare(metadata i8** %3, metadata !854, metadata !DIExpression()), !dbg !855
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !856
  %6 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %5, i32 0, i32 0, !dbg !857
  %7 = bitcast i8** %6 to i64*, !dbg !858
  %8 = bitcast i8** %4 to i64*, !dbg !858
  %9 = load atomic i64, i64* %7 seq_cst, align 8, !dbg !858
  store i64 %9, i64* %8, align 8, !dbg !858
  %10 = bitcast i64* %8 to i8**, !dbg !858
  %11 = load i8*, i8** %10, align 8, !dbg !858
  store i8* %11, i8** %3, align 8, !dbg !855
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !859, !srcloc !860
  %12 = load i8*, i8** %3, align 8, !dbg !861
  ret i8* %12, !dbg !862
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !863 {
  %4 = alloca %struct.vatomicptr_s*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i8*, align 8
  %9 = alloca i8, align 1
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %4, metadata !867, metadata !DIExpression()), !dbg !868
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !869, metadata !DIExpression()), !dbg !870
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !871, metadata !DIExpression()), !dbg !872
  call void @llvm.dbg.declare(metadata i8** %7, metadata !873, metadata !DIExpression()), !dbg !874
  %10 = load i8*, i8** %5, align 8, !dbg !875
  store i8* %10, i8** %7, align 8, !dbg !874
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !876, !srcloc !877
  %11 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %4, align 8, !dbg !878
  %12 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %11, i32 0, i32 0, !dbg !879
  %13 = load i8*, i8** %6, align 8, !dbg !880
  store i8* %13, i8** %8, align 8, !dbg !881
  %14 = bitcast i8** %12 to i64*, !dbg !881
  %15 = bitcast i8** %7 to i64*, !dbg !881
  %16 = bitcast i8** %8 to i64*, !dbg !881
  %17 = load i64, i64* %15, align 8, !dbg !881
  %18 = load i64, i64* %16, align 8, !dbg !881
  %19 = cmpxchg i64* %14, i64 %17, i64 %18 seq_cst seq_cst, align 8, !dbg !881
  %20 = extractvalue { i64, i1 } %19, 0, !dbg !881
  %21 = extractvalue { i64, i1 } %19, 1, !dbg !881
  br i1 %21, label %23, label %22, !dbg !881

22:                                               ; preds = %3
  store i64 %20, i64* %15, align 8, !dbg !881
  br label %23, !dbg !881

23:                                               ; preds = %22, %3
  %24 = zext i1 %21 to i8, !dbg !881
  store i8 %24, i8* %9, align 1, !dbg !881
  %25 = load i8, i8* %9, align 1, !dbg !881
  %26 = trunc i8 %25 to i1, !dbg !881
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !882, !srcloc !883
  %27 = load i8*, i8** %7, align 8, !dbg !884
  ret i8* %27, !dbg !885
}

; Function Attrs: noinline nounwind uwtable
define internal void @_trace_add_or_rem_occurrences(%struct.trace_s* noundef %0, i64 noundef %1, i64 noundef %2, i1 noundef zeroext %3) #0 !dbg !886 {
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  %10 = alloca i8, align 1
  store %struct.trace_s* %0, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !889, metadata !DIExpression()), !dbg !890
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !891, metadata !DIExpression()), !dbg !892
  store i64 %2, i64* %7, align 8
  call void @llvm.dbg.declare(metadata i64* %7, metadata !893, metadata !DIExpression()), !dbg !894
  %11 = zext i1 %3 to i8
  store i8 %11, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !895, metadata !DIExpression()), !dbg !896
  call void @llvm.dbg.declare(metadata i64* %9, metadata !897, metadata !DIExpression()), !dbg !898
  store i64 0, i64* %9, align 8, !dbg !898
  call void @llvm.dbg.declare(metadata i8* %10, metadata !899, metadata !DIExpression()), !dbg !900
  store i8 0, i8* %10, align 1, !dbg !900
  %12 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !901
  %13 = icmp ne %struct.trace_s* %12, null, !dbg !901
  br i1 %13, label %14, label %15, !dbg !904

14:                                               ; preds = %4
  br label %16, !dbg !904

15:                                               ; preds = %4
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.20, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 128, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !901
  unreachable, !dbg !901

16:                                               ; preds = %14
  %17 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !905
  %18 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %17, i32 0, i32 3, !dbg !905
  %19 = load i8, i8* %18, align 8, !dbg !905
  %20 = trunc i8 %19 to i1, !dbg !905
  br i1 %20, label %21, label %22, !dbg !908

21:                                               ; preds = %16
  br label %23, !dbg !908

22:                                               ; preds = %16
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.22, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 129, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !905
  unreachable, !dbg !905

23:                                               ; preds = %21
  %24 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !909
  %25 = load i64, i64* %6, align 8, !dbg !910
  %26 = call zeroext i1 @trace_find_unit_idx(%struct.trace_s* noundef %24, i64 noundef %25, i64* noundef %9), !dbg !911
  %27 = zext i1 %26 to i8, !dbg !912
  store i8 %27, i8* %10, align 1, !dbg !912
  %28 = load i8, i8* %8, align 1, !dbg !913
  %29 = trunc i8 %28 to i1, !dbg !913
  br i1 %29, label %30, label %57, !dbg !915

30:                                               ; preds = %23
  %31 = load i8, i8* %10, align 1, !dbg !916
  %32 = trunc i8 %31 to i1, !dbg !916
  br i1 %32, label %33, label %34, !dbg !920

33:                                               ; preds = %30
  br label %35, !dbg !920

34:                                               ; preds = %30
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.23, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 134, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !916
  unreachable, !dbg !916

35:                                               ; preds = %33
  %36 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !921
  %37 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %36, i32 0, i32 0, !dbg !921
  %38 = load %struct.trace_unit_s*, %struct.trace_unit_s** %37, align 8, !dbg !921
  %39 = load i64, i64* %9, align 8, !dbg !921
  %40 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %38, i64 %39, !dbg !921
  %41 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %40, i32 0, i32 1, !dbg !921
  %42 = load i64, i64* %41, align 8, !dbg !921
  %43 = load i64, i64* %7, align 8, !dbg !921
  %44 = icmp uge i64 %42, %43, !dbg !921
  br i1 %44, label %45, label %46, !dbg !924

45:                                               ; preds = %35
  br label %47, !dbg !924

46:                                               ; preds = %35
  call void @__assert_fail(i8* noundef getelementptr inbounds ([33 x i8], [33 x i8]* @.str.24, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 135, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !921
  unreachable, !dbg !921

47:                                               ; preds = %45
  %48 = load i64, i64* %7, align 8, !dbg !925
  %49 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !926
  %50 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %49, i32 0, i32 0, !dbg !927
  %51 = load %struct.trace_unit_s*, %struct.trace_unit_s** %50, align 8, !dbg !927
  %52 = load i64, i64* %9, align 8, !dbg !928
  %53 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %51, i64 %52, !dbg !926
  %54 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %53, i32 0, i32 1, !dbg !929
  %55 = load i64, i64* %54, align 8, !dbg !930
  %56 = sub i64 %55, %48, !dbg !930
  store i64 %56, i64* %54, align 8, !dbg !930
  br label %97, !dbg !931

57:                                               ; preds = %23
  %58 = load i8, i8* %10, align 1, !dbg !932
  %59 = trunc i8 %58 to i1, !dbg !932
  br i1 %59, label %87, label %60, !dbg !934

60:                                               ; preds = %57
  %61 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !935
  %62 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %61, i32 0, i32 1, !dbg !937
  %63 = load i64, i64* %62, align 8, !dbg !938
  %64 = add i64 %63, 1, !dbg !938
  store i64 %64, i64* %62, align 8, !dbg !938
  store i64 %63, i64* %9, align 8, !dbg !939
  %65 = load i64, i64* %9, align 8, !dbg !940
  %66 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !942
  %67 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %66, i32 0, i32 2, !dbg !943
  %68 = load i64, i64* %67, align 8, !dbg !943
  %69 = icmp uge i64 %65, %68, !dbg !944
  br i1 %69, label %70, label %72, !dbg !945

70:                                               ; preds = %60
  %71 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !946
  call void @trace_extend(%struct.trace_s* noundef %71), !dbg !948
  br label %72, !dbg !949

72:                                               ; preds = %70, %60
  %73 = load i64, i64* %6, align 8, !dbg !950
  %74 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !951
  %75 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %74, i32 0, i32 0, !dbg !952
  %76 = load %struct.trace_unit_s*, %struct.trace_unit_s** %75, align 8, !dbg !952
  %77 = load i64, i64* %9, align 8, !dbg !953
  %78 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %76, i64 %77, !dbg !951
  %79 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %78, i32 0, i32 0, !dbg !954
  store i64 %73, i64* %79, align 8, !dbg !955
  %80 = load i64, i64* %7, align 8, !dbg !956
  %81 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !957
  %82 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %81, i32 0, i32 0, !dbg !958
  %83 = load %struct.trace_unit_s*, %struct.trace_unit_s** %82, align 8, !dbg !958
  %84 = load i64, i64* %9, align 8, !dbg !959
  %85 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %83, i64 %84, !dbg !957
  %86 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %85, i32 0, i32 1, !dbg !960
  store i64 %80, i64* %86, align 8, !dbg !961
  br label %97, !dbg !962

87:                                               ; preds = %57
  %88 = load i64, i64* %7, align 8, !dbg !963
  %89 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !965
  %90 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %89, i32 0, i32 0, !dbg !966
  %91 = load %struct.trace_unit_s*, %struct.trace_unit_s** %90, align 8, !dbg !966
  %92 = load i64, i64* %9, align 8, !dbg !967
  %93 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %91, i64 %92, !dbg !965
  %94 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %93, i32 0, i32 1, !dbg !968
  %95 = load i64, i64* %94, align 8, !dbg !969
  %96 = add i64 %95, %88, !dbg !969
  store i64 %96, i64* %94, align 8, !dbg !969
  br label %97

97:                                               ; preds = %47, %87, %72
  ret void, !dbg !970
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @trace_find_unit_idx(%struct.trace_s* noundef %0, i64 noundef %1, i64* noundef %2) #0 !dbg !971 {
  %4 = alloca i1, align 1
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64*, align 8
  %8 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !975, metadata !DIExpression()), !dbg !976
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !977, metadata !DIExpression()), !dbg !978
  store i64* %2, i64** %7, align 8
  call void @llvm.dbg.declare(metadata i64** %7, metadata !979, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.declare(metadata i64* %8, metadata !981, metadata !DIExpression()), !dbg !982
  store i64 0, i64* %8, align 8, !dbg !982
  %9 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !983
  %10 = icmp ne %struct.trace_s* %9, null, !dbg !983
  br i1 %10, label %11, label %12, !dbg !986

11:                                               ; preds = %3
  br label %13, !dbg !986

12:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.20, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 110, i8* noundef getelementptr inbounds ([62 x i8], [62 x i8]* @__PRETTY_FUNCTION__.trace_find_unit_idx, i64 0, i64 0)) #5, !dbg !983
  unreachable, !dbg !983

13:                                               ; preds = %11
  %14 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !987
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 3, !dbg !987
  %16 = load i8, i8* %15, align 8, !dbg !987
  %17 = trunc i8 %16 to i1, !dbg !987
  br i1 %17, label %18, label %19, !dbg !990

18:                                               ; preds = %13
  br label %20, !dbg !990

19:                                               ; preds = %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.22, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 111, i8* noundef getelementptr inbounds ([62 x i8], [62 x i8]* @__PRETTY_FUNCTION__.trace_find_unit_idx, i64 0, i64 0)) #5, !dbg !987
  unreachable, !dbg !987

20:                                               ; preds = %18
  store i64 0, i64* %8, align 8, !dbg !991
  br label %21, !dbg !993

21:                                               ; preds = %41, %20
  %22 = load i64, i64* %8, align 8, !dbg !994
  %23 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !996
  %24 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %23, i32 0, i32 1, !dbg !997
  %25 = load i64, i64* %24, align 8, !dbg !997
  %26 = icmp ult i64 %22, %25, !dbg !998
  br i1 %26, label %27, label %44, !dbg !999

27:                                               ; preds = %21
  %28 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1000
  %29 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %28, i32 0, i32 0, !dbg !1003
  %30 = load %struct.trace_unit_s*, %struct.trace_unit_s** %29, align 8, !dbg !1003
  %31 = load i64, i64* %8, align 8, !dbg !1004
  %32 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %30, i64 %31, !dbg !1000
  %33 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %32, i32 0, i32 0, !dbg !1005
  %34 = load i64, i64* %33, align 8, !dbg !1005
  %35 = load i64, i64* %6, align 8, !dbg !1006
  %36 = icmp eq i64 %34, %35, !dbg !1007
  br i1 %36, label %37, label %40, !dbg !1008

37:                                               ; preds = %27
  %38 = load i64, i64* %8, align 8, !dbg !1009
  %39 = load i64*, i64** %7, align 8, !dbg !1011
  store i64 %38, i64* %39, align 8, !dbg !1012
  store i1 true, i1* %4, align 1, !dbg !1013
  br label %45, !dbg !1013

40:                                               ; preds = %27
  br label %41, !dbg !1014

41:                                               ; preds = %40
  %42 = load i64, i64* %8, align 8, !dbg !1015
  %43 = add i64 %42, 1, !dbg !1015
  store i64 %43, i64* %8, align 8, !dbg !1015
  br label %21, !dbg !1016, !llvm.loop !1017

44:                                               ; preds = %21
  store i1 false, i1* %4, align 1, !dbg !1019
  br label %45, !dbg !1019

45:                                               ; preds = %44, %37
  %46 = load i1, i1* %4, align 1, !dbg !1020
  ret i1 %46, !dbg !1020
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_extend(%struct.trace_s* noundef %0) #0 !dbg !1021 {
  %2 = alloca %struct.trace_s*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca %struct.trace_unit_s*, align 8
  %6 = alloca %struct.trace_unit_s*, align 8
  %7 = alloca i32, align 4
  store %struct.trace_s* %0, %struct.trace_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %2, metadata !1024, metadata !DIExpression()), !dbg !1025
  %8 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1026
  %9 = icmp ne %struct.trace_s* %8, null, !dbg !1026
  br i1 %9, label %10, label %11, !dbg !1029

10:                                               ; preds = %1
  br label %12, !dbg !1029

11:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.20, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 75, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.trace_extend, i64 0, i64 0)) #5, !dbg !1026
  unreachable, !dbg !1026

12:                                               ; preds = %10
  call void @llvm.dbg.declare(metadata i64* %3, metadata !1030, metadata !DIExpression()), !dbg !1031
  %13 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1032
  %14 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %13, i32 0, i32 2, !dbg !1033
  %15 = load i64, i64* %14, align 8, !dbg !1033
  %16 = mul i64 %15, 16, !dbg !1034
  store i64 %16, i64* %3, align 8, !dbg !1031
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1035, metadata !DIExpression()), !dbg !1036
  %17 = load i64, i64* %3, align 8, !dbg !1037
  %18 = mul i64 %17, 2, !dbg !1038
  store i64 %18, i64* %4, align 8, !dbg !1036
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %5, metadata !1039, metadata !DIExpression()), !dbg !1040
  %19 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1041
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 0, !dbg !1042
  %21 = load %struct.trace_unit_s*, %struct.trace_unit_s** %20, align 8, !dbg !1042
  store %struct.trace_unit_s* %21, %struct.trace_unit_s** %5, align 8, !dbg !1040
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %6, metadata !1043, metadata !DIExpression()), !dbg !1044
  %22 = load i64, i64* %4, align 8, !dbg !1045
  %23 = call noalias i8* @malloc(i64 noundef %22) #6, !dbg !1046
  %24 = bitcast i8* %23 to %struct.trace_unit_s*, !dbg !1046
  store %struct.trace_unit_s* %24, %struct.trace_unit_s** %6, align 8, !dbg !1044
  %25 = load %struct.trace_unit_s*, %struct.trace_unit_s** %6, align 8, !dbg !1047
  %26 = icmp ne %struct.trace_unit_s* %25, null, !dbg !1047
  br i1 %26, label %27, label %47, !dbg !1049

27:                                               ; preds = %12
  call void @llvm.dbg.declare(metadata i32* %7, metadata !1050, metadata !DIExpression()), !dbg !1052
  %28 = load %struct.trace_unit_s*, %struct.trace_unit_s** %6, align 8, !dbg !1053
  %29 = load i64, i64* %4, align 8, !dbg !1054
  %30 = load %struct.trace_unit_s*, %struct.trace_unit_s** %5, align 8, !dbg !1055
  %31 = load i64, i64* %3, align 8, !dbg !1056
  %32 = call i32 (%struct.trace_unit_s*, i64, %struct.trace_unit_s*, i64, ...) bitcast (i32 (...)* @memcpy_s to i32 (%struct.trace_unit_s*, i64, %struct.trace_unit_s*, i64, ...)*)(%struct.trace_unit_s* noundef %28, i64 noundef %29, %struct.trace_unit_s* noundef %30, i64 noundef %31), !dbg !1057
  store i32 %32, i32* %7, align 4, !dbg !1052
  %33 = load i32, i32* %7, align 4, !dbg !1058
  %34 = icmp eq i32 %33, 0, !dbg !1060
  br i1 %34, label %35, label %43, !dbg !1061

35:                                               ; preds = %27
  %36 = load %struct.trace_unit_s*, %struct.trace_unit_s** %6, align 8, !dbg !1062
  %37 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1064
  %38 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %37, i32 0, i32 0, !dbg !1065
  store %struct.trace_unit_s* %36, %struct.trace_unit_s** %38, align 8, !dbg !1066
  %39 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1067
  %40 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %39, i32 0, i32 2, !dbg !1068
  %41 = load i64, i64* %40, align 8, !dbg !1069
  %42 = mul i64 %41, 2, !dbg !1069
  store i64 %42, i64* %40, align 8, !dbg !1069
  br label %44, !dbg !1070

43:                                               ; preds = %27
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.25, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 89, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.trace_extend, i64 0, i64 0)) #5, !dbg !1071
  unreachable, !dbg !1071

44:                                               ; preds = %35
  %45 = load %struct.trace_unit_s*, %struct.trace_unit_s** %5, align 8, !dbg !1075
  %46 = bitcast %struct.trace_unit_s* %45 to i8*, !dbg !1075
  call void @free(i8* noundef %46) #6, !dbg !1076
  br label %48, !dbg !1077

47:                                               ; preds = %12
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.26, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 93, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.trace_extend, i64 0, i64 0)) #5, !dbg !1078
  unreachable, !dbg !1078

48:                                               ; preds = %44
  ret void, !dbg !1082
}

declare i32 @memcpy_s(...) #4

; Function Attrs: noinline nounwind uwtable
define internal i8* @vsimpleht_get(%struct.vsimpleht_s* noundef %0, i64 noundef %1) #0 !dbg !1083 {
  %3 = alloca i8*, align 8
  %4 = alloca %struct.vsimpleht_s*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %4, metadata !1086, metadata !DIExpression()), !dbg !1087
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1088, metadata !DIExpression()), !dbg !1089
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1090, metadata !DIExpression()), !dbg !1091
  store i64 0, i64* %6, align 8, !dbg !1091
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1092, metadata !DIExpression()), !dbg !1093
  store i64 0, i64* %7, align 8, !dbg !1093
  %8 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1094
  call void @_vsimpleht_give_cleanup_a_chance(%struct.vsimpleht_s* noundef %8), !dbg !1095
  %9 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1096
  %10 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %9, i32 0, i32 3, !dbg !1098
  %11 = load i64 (i64)*, i64 (i64)** %10, align 8, !dbg !1098
  %12 = load i64, i64* %5, align 8, !dbg !1099
  %13 = call i64 %11(i64 noundef %12), !dbg !1096
  store i64 %13, i64* %6, align 8, !dbg !1100
  br label %14, !dbg !1101

14:                                               ; preds = %59, %2
  %15 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1102
  %16 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %15, i32 0, i32 0, !dbg !1105
  %17 = load i64, i64* %16, align 8, !dbg !1105
  %18 = sub i64 %17, 1, !dbg !1106
  %19 = load i64, i64* %6, align 8, !dbg !1107
  %20 = and i64 %19, %18, !dbg !1107
  store i64 %20, i64* %6, align 8, !dbg !1107
  %21 = load i64, i64* %6, align 8, !dbg !1108
  %22 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1108
  %23 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %22, i32 0, i32 0, !dbg !1108
  %24 = load i64, i64* %23, align 8, !dbg !1108
  %25 = icmp ult i64 %21, %24, !dbg !1108
  br i1 %25, label %26, label %27, !dbg !1111

26:                                               ; preds = %14
  br label %28, !dbg !1111

27:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 264, i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @__PRETTY_FUNCTION__.vsimpleht_get, i64 0, i64 0)) #5, !dbg !1108
  unreachable, !dbg !1108

28:                                               ; preds = %26
  %29 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1112
  %30 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %29, i32 0, i32 1, !dbg !1113
  %31 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %30, align 8, !dbg !1113
  %32 = load i64, i64* %6, align 8, !dbg !1114
  %33 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %31, i64 %32, !dbg !1112
  %34 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %33, i32 0, i32 0, !dbg !1115
  %35 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %34), !dbg !1116
  %36 = ptrtoint i8* %35 to i64, !dbg !1117
  store i64 %36, i64* %7, align 8, !dbg !1118
  %37 = load i64, i64* %7, align 8, !dbg !1119
  %38 = icmp eq i64 %37, 0, !dbg !1121
  br i1 %38, label %39, label %40, !dbg !1122

39:                                               ; preds = %28
  store i8* null, i8** %3, align 8, !dbg !1123
  br label %62, !dbg !1123

40:                                               ; preds = %28
  %41 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1125
  %42 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %41, i32 0, i32 2, !dbg !1127
  %43 = load i8 (i64, i64)*, i8 (i64, i64)** %42, align 8, !dbg !1127
  %44 = load i64, i64* %5, align 8, !dbg !1128
  %45 = load i64, i64* %7, align 8, !dbg !1129
  %46 = call signext i8 %43(i64 noundef %44, i64 noundef %45), !dbg !1125
  %47 = sext i8 %46 to i32, !dbg !1125
  %48 = icmp eq i32 %47, 0, !dbg !1130
  br i1 %48, label %49, label %57, !dbg !1131

49:                                               ; preds = %40
  %50 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1132
  %51 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %50, i32 0, i32 1, !dbg !1134
  %52 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %51, align 8, !dbg !1134
  %53 = load i64, i64* %6, align 8, !dbg !1135
  %54 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %52, i64 %53, !dbg !1132
  %55 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %54, i32 0, i32 1, !dbg !1136
  %56 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %55), !dbg !1137
  store i8* %56, i8** %3, align 8, !dbg !1138
  br label %62, !dbg !1138

57:                                               ; preds = %40
  br label %58

58:                                               ; preds = %57
  br label %59, !dbg !1139

59:                                               ; preds = %58
  %60 = load i64, i64* %6, align 8, !dbg !1140
  %61 = add i64 %60, 1, !dbg !1140
  store i64 %61, i64* %6, align 8, !dbg !1140
  br label %14, !dbg !1141, !llvm.loop !1142

62:                                               ; preds = %49, %39
  %63 = load i8*, i8** %3, align 8, !dbg !1145
  ret i8* %63, !dbg !1145
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %0) #0 !dbg !1146 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !1147, metadata !DIExpression()), !dbg !1148
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1149, !srcloc !1150
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1151, metadata !DIExpression()), !dbg !1152
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !1153
  %6 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %5, i32 0, i32 0, !dbg !1154
  %7 = bitcast i8** %6 to i64*, !dbg !1155
  %8 = bitcast i8** %4 to i64*, !dbg !1155
  %9 = load atomic i64, i64* %7 acquire, align 8, !dbg !1155
  store i64 %9, i64* %8, align 8, !dbg !1155
  %10 = bitcast i64* %8 to i8**, !dbg !1155
  %11 = load i8*, i8** %10, align 8, !dbg !1155
  store i8* %11, i8** %3, align 8, !dbg !1152
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1156, !srcloc !1157
  %12 = load i8*, i8** %3, align 8, !dbg !1158
  ret i8* %12, !dbg !1159
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vsimpleht_remove(%struct.vsimpleht_s* noundef %0, i64 noundef %1) #0 !dbg !1160 {
  %3 = alloca i32, align 4
  %4 = alloca %struct.vsimpleht_s*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8*, align 8
  %9 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %4, metadata !1163, metadata !DIExpression()), !dbg !1164
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1165, metadata !DIExpression()), !dbg !1166
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1167, metadata !DIExpression()), !dbg !1168
  store i64 0, i64* %6, align 8, !dbg !1168
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1169, metadata !DIExpression()), !dbg !1170
  store i64 0, i64* %7, align 8, !dbg !1170
  call void @llvm.dbg.declare(metadata i8** %8, metadata !1171, metadata !DIExpression()), !dbg !1172
  store i8* null, i8** %8, align 8, !dbg !1172
  call void @llvm.dbg.declare(metadata i64* %9, metadata !1173, metadata !DIExpression()), !dbg !1174
  %10 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1175
  %11 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %10, i32 0, i32 3, !dbg !1176
  %12 = load i64 (i64)*, i64 (i64)** %11, align 8, !dbg !1176
  %13 = load i64, i64* %5, align 8, !dbg !1177
  %14 = call i64 %12(i64 noundef %13), !dbg !1175
  store i64 %14, i64* %9, align 8, !dbg !1174
  %15 = load i64, i64* %9, align 8, !dbg !1178
  %16 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1179
  %17 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %16, i32 0, i32 0, !dbg !1180
  %18 = load i64, i64* %17, align 8, !dbg !1180
  %19 = sub i64 %18, 1, !dbg !1181
  %20 = and i64 %15, %19, !dbg !1182
  store i64 %20, i64* %6, align 8, !dbg !1183
  %21 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1184
  call void @_vsimpleht_give_cleanup_a_chance(%struct.vsimpleht_s* noundef %21), !dbg !1185
  br label %22, !dbg !1186

22:                                               ; preds = %81, %2
  %23 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1187
  %24 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %23, i32 0, i32 1, !dbg !1189
  %25 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %24, align 8, !dbg !1189
  %26 = load i64, i64* %6, align 8, !dbg !1190
  %27 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %25, i64 %26, !dbg !1187
  %28 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %27, i32 0, i32 0, !dbg !1191
  %29 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %28), !dbg !1192
  %30 = ptrtoint i8* %29 to i64, !dbg !1193
  store i64 %30, i64* %7, align 8, !dbg !1194
  %31 = load i64, i64* %7, align 8, !dbg !1195
  %32 = icmp eq i64 %31, 0, !dbg !1197
  br i1 %32, label %33, label %34, !dbg !1198

33:                                               ; preds = %22
  store i32 3, i32* %3, align 4, !dbg !1199
  br label %86, !dbg !1199

34:                                               ; preds = %22
  %35 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1201
  %36 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %35, i32 0, i32 2, !dbg !1203
  %37 = load i8 (i64, i64)*, i8 (i64, i64)** %36, align 8, !dbg !1203
  %38 = load i64, i64* %5, align 8, !dbg !1204
  %39 = load i64, i64* %7, align 8, !dbg !1205
  %40 = call signext i8 %37(i64 noundef %38, i64 noundef %39), !dbg !1201
  %41 = sext i8 %40 to i32, !dbg !1201
  %42 = icmp eq i32 %41, 0, !dbg !1206
  br i1 %42, label %43, label %71, !dbg !1207

43:                                               ; preds = %34
  %44 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1208
  %45 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %44, i32 0, i32 1, !dbg !1210
  %46 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %45, align 8, !dbg !1210
  %47 = load i64, i64* %6, align 8, !dbg !1211
  %48 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %46, i64 %47, !dbg !1208
  %49 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %48, i32 0, i32 1, !dbg !1212
  %50 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %49), !dbg !1213
  store i8* %50, i8** %8, align 8, !dbg !1214
  %51 = load i8*, i8** %8, align 8, !dbg !1215
  %52 = icmp eq i8* %51, null, !dbg !1217
  br i1 %52, label %53, label %54, !dbg !1218

53:                                               ; preds = %43
  store i32 3, i32* %3, align 4, !dbg !1219
  br label %86, !dbg !1219

54:                                               ; preds = %43
  %55 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1221
  %56 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %55, i32 0, i32 1, !dbg !1223
  %57 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %56, align 8, !dbg !1223
  %58 = load i64, i64* %6, align 8, !dbg !1224
  %59 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %57, i64 %58, !dbg !1221
  %60 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %59, i32 0, i32 1, !dbg !1225
  %61 = load i8*, i8** %8, align 8, !dbg !1226
  %62 = call i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %60, i8* noundef %61, i8* noundef null), !dbg !1227
  %63 = load i8*, i8** %8, align 8, !dbg !1228
  %64 = icmp eq i8* %62, %63, !dbg !1229
  br i1 %64, label %65, label %70, !dbg !1230

65:                                               ; preds = %54
  %66 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1231
  %67 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %66, i32 0, i32 6, !dbg !1233
  call void @vatomicsz_inc_rlx(%struct.vatomicsz_s* noundef %67), !dbg !1234
  %68 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1235
  %69 = load i8*, i8** %8, align 8, !dbg !1236
  call void @_vsimpleht_trigger_cleanup(%struct.vsimpleht_s* noundef %68, i8* noundef %69), !dbg !1237
  store i32 0, i32* %3, align 4, !dbg !1238
  br label %86, !dbg !1238

70:                                               ; preds = %54
  store i32 3, i32* %3, align 4, !dbg !1239
  br label %86, !dbg !1239

71:                                               ; preds = %34
  br label %72

72:                                               ; preds = %71
  %73 = load i64, i64* %6, align 8, !dbg !1240
  %74 = add i64 %73, 1, !dbg !1240
  store i64 %74, i64* %6, align 8, !dbg !1240
  %75 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1241
  %76 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %75, i32 0, i32 0, !dbg !1242
  %77 = load i64, i64* %76, align 8, !dbg !1242
  %78 = sub i64 %77, 1, !dbg !1243
  %79 = load i64, i64* %6, align 8, !dbg !1244
  %80 = and i64 %79, %78, !dbg !1244
  store i64 %80, i64* %6, align 8, !dbg !1244
  br label %81, !dbg !1245

81:                                               ; preds = %72
  %82 = load i64, i64* %6, align 8, !dbg !1246
  %83 = load i64, i64* %9, align 8, !dbg !1247
  %84 = icmp ne i64 %82, %83, !dbg !1248
  br i1 %84, label %22, label %85, !dbg !1245, !llvm.loop !1249

85:                                               ; preds = %81
  store i32 3, i32* %3, align 4, !dbg !1251
  br label %86, !dbg !1251

86:                                               ; preds = %85, %70, %65, %53, %33
  %87 = load i32, i32* %3, align 4, !dbg !1252
  ret i32 %87, !dbg !1252
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !1253 {
  %4 = alloca %struct.vatomicptr_s*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i8*, align 8
  %9 = alloca i8, align 1
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %4, metadata !1254, metadata !DIExpression()), !dbg !1255
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !1256, metadata !DIExpression()), !dbg !1257
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !1258, metadata !DIExpression()), !dbg !1259
  call void @llvm.dbg.declare(metadata i8** %7, metadata !1260, metadata !DIExpression()), !dbg !1261
  %10 = load i8*, i8** %5, align 8, !dbg !1262
  store i8* %10, i8** %7, align 8, !dbg !1261
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1263, !srcloc !1264
  %11 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %4, align 8, !dbg !1265
  %12 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %11, i32 0, i32 0, !dbg !1266
  %13 = load i8*, i8** %6, align 8, !dbg !1267
  store i8* %13, i8** %8, align 8, !dbg !1268
  %14 = bitcast i8** %12 to i64*, !dbg !1268
  %15 = bitcast i8** %7 to i64*, !dbg !1268
  %16 = bitcast i8** %8 to i64*, !dbg !1268
  %17 = load i64, i64* %15, align 8, !dbg !1268
  %18 = load i64, i64* %16, align 8, !dbg !1268
  %19 = cmpxchg i64* %14, i64 %17, i64 %18 release monotonic, align 8, !dbg !1268
  %20 = extractvalue { i64, i1 } %19, 0, !dbg !1268
  %21 = extractvalue { i64, i1 } %19, 1, !dbg !1268
  br i1 %21, label %23, label %22, !dbg !1268

22:                                               ; preds = %3
  store i64 %20, i64* %15, align 8, !dbg !1268
  br label %23, !dbg !1268

23:                                               ; preds = %22, %3
  %24 = zext i1 %21 to i8, !dbg !1268
  store i8 %24, i8* %9, align 1, !dbg !1268
  %25 = load i8, i8* %9, align 1, !dbg !1268
  %26 = trunc i8 %25 to i1, !dbg !1268
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1269, !srcloc !1270
  %27 = load i8*, i8** %7, align 8, !dbg !1271
  ret i8* %27, !dbg !1272
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicsz_inc_rlx(%struct.vatomicsz_s* noundef %0) #0 !dbg !1273 {
  %2 = alloca %struct.vatomicsz_s*, align 8
  store %struct.vatomicsz_s* %0, %struct.vatomicsz_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicsz_s** %2, metadata !1277, metadata !DIExpression()), !dbg !1278
  %3 = load %struct.vatomicsz_s*, %struct.vatomicsz_s** %2, align 8, !dbg !1279
  %4 = call i64 @vatomicsz_get_inc_rlx(%struct.vatomicsz_s* noundef %3), !dbg !1280
  ret void, !dbg !1281
}

; Function Attrs: noinline nounwind uwtable
define internal void @_vsimpleht_trigger_cleanup(%struct.vsimpleht_s* noundef %0, i8* noundef %1) #0 !dbg !1282 {
  %3 = alloca %struct.vsimpleht_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %3, metadata !1285, metadata !DIExpression()), !dbg !1286
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1287, metadata !DIExpression()), !dbg !1288
  %5 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1289
  %6 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %5, i32 0, i32 7, !dbg !1289
  %7 = call zeroext i1 @rwlock_acquired_by_readers(%struct.rwlock_s* noundef %6), !dbg !1289
  br i1 %7, label %8, label %10, !dbg !1289

8:                                                ; preds = %2
  br i1 true, label %9, label %10, !dbg !1292

9:                                                ; preds = %8
  br label %11, !dbg !1292

10:                                               ; preds = %8, %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([112 x i8], [112 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 508, i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @__PRETTY_FUNCTION__._vsimpleht_trigger_cleanup, i64 0, i64 0)) #5, !dbg !1289
  unreachable, !dbg !1289

11:                                               ; preds = %9
  %12 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1293
  %13 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %12, i32 0, i32 7, !dbg !1294
  call void @rwlock_read_release(%struct.rwlock_s* noundef %13), !dbg !1295
  %14 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1296
  %15 = load i8*, i8** %4, align 8, !dbg !1297
  call void @_vsimpleht_cleanup(%struct.vsimpleht_s* noundef %14, i8* noundef %15), !dbg !1298
  %16 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1299
  %17 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %16, i32 0, i32 7, !dbg !1300
  call void @rwlock_read_acquire(%struct.rwlock_s* noundef %17), !dbg !1301
  ret void, !dbg !1302
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomicsz_get_inc_rlx(%struct.vatomicsz_s* noundef %0) #0 !dbg !1303 {
  %2 = alloca %struct.vatomicsz_s*, align 8
  store %struct.vatomicsz_s* %0, %struct.vatomicsz_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicsz_s** %2, metadata !1306, metadata !DIExpression()), !dbg !1307
  %3 = load %struct.vatomicsz_s*, %struct.vatomicsz_s** %2, align 8, !dbg !1308
  %4 = call i64 @vatomicsz_get_add_rlx(%struct.vatomicsz_s* noundef %3, i64 noundef 1), !dbg !1309
  ret i64 %4, !dbg !1310
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomicsz_get_add_rlx(%struct.vatomicsz_s* noundef %0, i64 noundef %1) #0 !dbg !1311 {
  %3 = alloca %struct.vatomicsz_s*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  store %struct.vatomicsz_s* %0, %struct.vatomicsz_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicsz_s** %3, metadata !1314, metadata !DIExpression()), !dbg !1315
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1316, metadata !DIExpression()), !dbg !1317
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1318, !srcloc !1319
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1320, metadata !DIExpression()), !dbg !1321
  %8 = load %struct.vatomicsz_s*, %struct.vatomicsz_s** %3, align 8, !dbg !1322
  %9 = getelementptr inbounds %struct.vatomicsz_s, %struct.vatomicsz_s* %8, i32 0, i32 0, !dbg !1323
  %10 = load i64, i64* %4, align 8, !dbg !1324
  store i64 %10, i64* %6, align 8, !dbg !1325
  %11 = load i64, i64* %6, align 8, !dbg !1325
  %12 = atomicrmw add i64* %9, i64 %11 monotonic, align 8, !dbg !1325
  store i64 %12, i64* %7, align 8, !dbg !1325
  %13 = load i64, i64* %7, align 8, !dbg !1325
  store i64 %13, i64* %5, align 8, !dbg !1321
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1326, !srcloc !1327
  %14 = load i64, i64* %5, align 8, !dbg !1328
  ret i64 %14, !dbg !1329
}

; Function Attrs: noinline nounwind uwtable
define internal void @_vsimpleht_cleanup(%struct.vsimpleht_s* noundef %0, i8* noundef %1) #0 !dbg !1330 {
  %3 = alloca %struct.vsimpleht_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8*, align 8
  %9 = alloca i64, align 8
  %10 = alloca %struct.vsimpleht_entry_s*, align 8
  %11 = alloca i64, align 8
  %12 = alloca i8, align 1
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %3, metadata !1331, metadata !DIExpression()), !dbg !1332
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1333, metadata !DIExpression()), !dbg !1334
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1335, metadata !DIExpression()), !dbg !1336
  store i64 0, i64* %5, align 8, !dbg !1336
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1337, metadata !DIExpression()), !dbg !1338
  store i64 0, i64* %6, align 8, !dbg !1338
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1339, metadata !DIExpression()), !dbg !1340
  store i64 0, i64* %7, align 8, !dbg !1340
  call void @llvm.dbg.declare(metadata i8** %8, metadata !1341, metadata !DIExpression()), !dbg !1342
  store i8* null, i8** %8, align 8, !dbg !1342
  call void @llvm.dbg.declare(metadata i64* %9, metadata !1343, metadata !DIExpression()), !dbg !1344
  %13 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1345
  %14 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %13, i32 0, i32 0, !dbg !1346
  %15 = load i64, i64* %14, align 8, !dbg !1346
  store i64 %15, i64* %9, align 8, !dbg !1344
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_entry_s** %10, metadata !1347, metadata !DIExpression()), !dbg !1348
  %16 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1349
  %17 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %16, i32 0, i32 1, !dbg !1350
  %18 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %17, align 8, !dbg !1350
  store %struct.vsimpleht_entry_s* %18, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1348
  call void @llvm.dbg.declare(metadata i64* %11, metadata !1351, metadata !DIExpression()), !dbg !1352
  %19 = load i64, i64* %9, align 8, !dbg !1353
  %20 = sub i64 %19, 1, !dbg !1354
  store i64 %20, i64* %11, align 8, !dbg !1352
  call void @llvm.dbg.declare(metadata i8* %12, metadata !1355, metadata !DIExpression()), !dbg !1356
  %21 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1357
  %22 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %21, i32 0, i32 7, !dbg !1358
  call void @rwlock_write_acquire(%struct.rwlock_s* noundef %22), !dbg !1359
  %23 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1360
  %24 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %23, i32 0, i32 6, !dbg !1362
  %25 = call i64 @vatomicsz_read_rlx(%struct.vatomicsz_s* noundef %24), !dbg !1363
  %26 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1364
  %27 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %26, i32 0, i32 5, !dbg !1365
  %28 = load i64, i64* %27, align 8, !dbg !1365
  %29 = icmp ult i64 %25, %28, !dbg !1366
  br i1 %29, label %30, label %31, !dbg !1367

30:                                               ; preds = %2
  br label %129, !dbg !1368

31:                                               ; preds = %2
  store i64 0, i64* %5, align 8, !dbg !1370
  br label %32, !dbg !1372

32:                                               ; preds = %53, %31
  %33 = load i64, i64* %5, align 8, !dbg !1373
  %34 = load i64, i64* %9, align 8, !dbg !1375
  %35 = icmp ult i64 %33, %34, !dbg !1376
  br i1 %35, label %36, label %56, !dbg !1377

36:                                               ; preds = %32
  %37 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1378
  %38 = load i64, i64* %5, align 8, !dbg !1380
  %39 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %37, i64 %38, !dbg !1378
  %40 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %39, i32 0, i32 0, !dbg !1381
  %41 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %40), !dbg !1382
  %42 = ptrtoint i8* %41 to i64, !dbg !1383
  store i64 %42, i64* %7, align 8, !dbg !1384
  %43 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1385
  %44 = load i64, i64* %5, align 8, !dbg !1386
  %45 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %43, i64 %44, !dbg !1385
  %46 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %45, i32 0, i32 1, !dbg !1387
  %47 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %46), !dbg !1388
  store i8* %47, i8** %8, align 8, !dbg !1389
  %48 = load i64, i64* %7, align 8, !dbg !1390
  %49 = icmp eq i64 %48, 0, !dbg !1392
  br i1 %49, label %50, label %52, !dbg !1393

50:                                               ; preds = %36
  %51 = load i64, i64* %5, align 8, !dbg !1394
  store i64 %51, i64* %11, align 8, !dbg !1396
  br label %56, !dbg !1397

52:                                               ; preds = %36
  br label %53, !dbg !1398

53:                                               ; preds = %52
  %54 = load i64, i64* %5, align 8, !dbg !1399
  %55 = add i64 %54, 1, !dbg !1399
  store i64 %55, i64* %5, align 8, !dbg !1399
  br label %32, !dbg !1400, !llvm.loop !1401

56:                                               ; preds = %50, %32
  store i64 0, i64* %5, align 8, !dbg !1403
  br label %57, !dbg !1405

57:                                               ; preds = %123, %56
  %58 = load i64, i64* %5, align 8, !dbg !1406
  %59 = load i64, i64* %9, align 8, !dbg !1408
  %60 = icmp ult i64 %58, %59, !dbg !1409
  br i1 %60, label %61, label %126, !dbg !1410

61:                                               ; preds = %57
  %62 = load i64, i64* %5, align 8, !dbg !1411
  %63 = load i64, i64* %11, align 8, !dbg !1413
  %64 = add i64 %62, %63, !dbg !1414
  %65 = load i64, i64* %9, align 8, !dbg !1415
  %66 = sub i64 %65, 1, !dbg !1416
  %67 = and i64 %64, %66, !dbg !1417
  store i64 %67, i64* %6, align 8, !dbg !1418
  %68 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1419
  %69 = load i64, i64* %6, align 8, !dbg !1420
  %70 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %68, i64 %69, !dbg !1419
  %71 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %70, i32 0, i32 0, !dbg !1421
  %72 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %71), !dbg !1422
  %73 = ptrtoint i8* %72 to i64, !dbg !1423
  store i64 %73, i64* %7, align 8, !dbg !1424
  %74 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1425
  %75 = load i64, i64* %6, align 8, !dbg !1426
  %76 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %74, i64 %75, !dbg !1425
  %77 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %76, i32 0, i32 1, !dbg !1427
  %78 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %77), !dbg !1428
  store i8* %78, i8** %8, align 8, !dbg !1429
  %79 = load i64, i64* %7, align 8, !dbg !1430
  %80 = icmp ne i64 %79, 0, !dbg !1432
  br i1 %80, label %81, label %110, !dbg !1433

81:                                               ; preds = %61
  %82 = load i8*, i8** %8, align 8, !dbg !1434
  %83 = icmp ne i8* %82, null, !dbg !1435
  br i1 %83, label %84, label %110, !dbg !1436

84:                                               ; preds = %81
  %85 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1437
  %86 = load i64, i64* %7, align 8, !dbg !1439
  %87 = load i8*, i8** %8, align 8, !dbg !1440
  %88 = call i32 @_vsimpleht_add(%struct.vsimpleht_s* noundef %85, i64 noundef %86, i8* noundef %87), !dbg !1441
  %89 = trunc i32 %88 to i8, !dbg !1441
  store i8 %89, i8* %12, align 1, !dbg !1442
  %90 = load i8, i8* %12, align 1, !dbg !1443
  %91 = zext i8 %90 to i32, !dbg !1443
  %92 = icmp eq i32 %91, 0, !dbg !1445
  br i1 %92, label %93, label %102, !dbg !1446

93:                                               ; preds = %84
  %94 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1447
  %95 = load i64, i64* %6, align 8, !dbg !1449
  %96 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %94, i64 %95, !dbg !1447
  %97 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %96, i32 0, i32 0, !dbg !1450
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %97, i8* noundef null), !dbg !1451
  %98 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1452
  %99 = load i64, i64* %6, align 8, !dbg !1453
  %100 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %98, i64 %99, !dbg !1452
  %101 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %100, i32 0, i32 1, !dbg !1454
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %101, i8* noundef null), !dbg !1455
  br label %102, !dbg !1456

102:                                              ; preds = %93, %84
  %103 = load i8, i8* %12, align 1, !dbg !1457
  %104 = zext i8 %103 to i32, !dbg !1457
  %105 = icmp ne i32 %104, 1, !dbg !1457
  br i1 %105, label %106, label %108, !dbg !1457

106:                                              ; preds = %102
  br i1 true, label %107, label %108, !dbg !1460

107:                                              ; preds = %106
  br label %109, !dbg !1460

108:                                              ; preds = %106, %102
  call void @__assert_fail(i8* noundef getelementptr inbounds ([116 x i8], [116 x i8]* @.str.30, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 586, i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @__PRETTY_FUNCTION__._vsimpleht_cleanup, i64 0, i64 0)) #5, !dbg !1457
  unreachable, !dbg !1457

109:                                              ; preds = %107
  br label %122, !dbg !1461

110:                                              ; preds = %81, %61
  %111 = load i64, i64* %7, align 8, !dbg !1462
  %112 = icmp ne i64 %111, 0, !dbg !1464
  br i1 %112, label %113, label %121, !dbg !1465

113:                                              ; preds = %110
  %114 = load i8*, i8** %8, align 8, !dbg !1466
  %115 = icmp eq i8* %114, null, !dbg !1467
  br i1 %115, label %116, label %121, !dbg !1468

116:                                              ; preds = %113
  %117 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1469
  %118 = load i64, i64* %6, align 8, !dbg !1471
  %119 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %117, i64 %118, !dbg !1469
  %120 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %119, i32 0, i32 0, !dbg !1472
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %120, i8* noundef null), !dbg !1473
  br label %121, !dbg !1474

121:                                              ; preds = %116, %113, %110
  br label %122

122:                                              ; preds = %121, %109
  br label %123, !dbg !1475

123:                                              ; preds = %122
  %124 = load i64, i64* %5, align 8, !dbg !1476
  %125 = add i64 %124, 1, !dbg !1476
  store i64 %125, i64* %5, align 8, !dbg !1476
  br label %57, !dbg !1477, !llvm.loop !1478

126:                                              ; preds = %57
  %127 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1480
  %128 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %127, i32 0, i32 6, !dbg !1481
  call void @vatomicsz_write_rlx(%struct.vatomicsz_s* noundef %128, i64 noundef 0), !dbg !1482
  br label %129, !dbg !1482

129:                                              ; preds = %126, %30
  call void @llvm.dbg.label(metadata !1483), !dbg !1484
  %130 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1485
  %131 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %130, i32 0, i32 4, !dbg !1486
  %132 = load void (i8*)*, void (i8*)** %131, align 8, !dbg !1486
  %133 = load i8*, i8** %4, align 8, !dbg !1487
  call void %132(i8* noundef %133), !dbg !1485
  %134 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1488
  %135 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %134, i32 0, i32 7, !dbg !1489
  call void @rwlock_write_release(%struct.rwlock_s* noundef %135), !dbg !1490
  ret void, !dbg !1491
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_write_acquire(%struct.rwlock_s* noundef %0) #0 !dbg !1492 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i64, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !1493, metadata !DIExpression()), !dbg !1494
  %4 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !1495
  %5 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %4, i32 0, i32 1, !dbg !1496
  call void @vatomic8_write_rlx(%struct.vatomic8_s* noundef %5, i8 noundef zeroext 1), !dbg !1497
  call void @llvm.dbg.declare(metadata i64* %3, metadata !1498, metadata !DIExpression()), !dbg !1500
  store i64 0, i64* %3, align 8, !dbg !1500
  br label %6, !dbg !1501

6:                                                ; preds = %15, %1
  %7 = load i64, i64* %3, align 8, !dbg !1502
  %8 = icmp ult i64 %7, 3, !dbg !1504
  br i1 %8, label %9, label %18, !dbg !1505

9:                                                ; preds = %6
  %10 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !1506
  %11 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %10, i32 0, i32 0, !dbg !1508
  %12 = load i64, i64* %3, align 8, !dbg !1509
  %13 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %11, i64 0, i64 %12, !dbg !1506
  %14 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef %13) #6, !dbg !1510
  br label %15, !dbg !1511

15:                                               ; preds = %9
  %16 = load i64, i64* %3, align 8, !dbg !1512
  %17 = add i64 %16, 1, !dbg !1512
  store i64 %17, i64* %3, align 8, !dbg !1512
  br label %6, !dbg !1513, !llvm.loop !1514

18:                                               ; preds = %6
  ret void, !dbg !1516
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomicsz_read_rlx(%struct.vatomicsz_s* noundef %0) #0 !dbg !1517 {
  %2 = alloca %struct.vatomicsz_s*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store %struct.vatomicsz_s* %0, %struct.vatomicsz_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicsz_s** %2, metadata !1522, metadata !DIExpression()), !dbg !1523
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1524, !srcloc !1525
  call void @llvm.dbg.declare(metadata i64* %3, metadata !1526, metadata !DIExpression()), !dbg !1527
  %5 = load %struct.vatomicsz_s*, %struct.vatomicsz_s** %2, align 8, !dbg !1528
  %6 = getelementptr inbounds %struct.vatomicsz_s, %struct.vatomicsz_s* %5, i32 0, i32 0, !dbg !1529
  %7 = load atomic i64, i64* %6 monotonic, align 8, !dbg !1530
  store i64 %7, i64* %4, align 8, !dbg !1530
  %8 = load i64, i64* %4, align 8, !dbg !1530
  store i64 %8, i64* %3, align 8, !dbg !1527
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1531, !srcloc !1532
  %9 = load i64, i64* %3, align 8, !dbg !1533
  ret i64 %9, !dbg !1534
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !1535 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !1536, metadata !DIExpression()), !dbg !1537
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1538, !srcloc !1539
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1540, metadata !DIExpression()), !dbg !1541
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !1542
  %6 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %5, i32 0, i32 0, !dbg !1543
  %7 = bitcast i8** %6 to i64*, !dbg !1544
  %8 = bitcast i8** %4 to i64*, !dbg !1544
  %9 = load atomic i64, i64* %7 monotonic, align 8, !dbg !1544
  store i64 %9, i64* %8, align 8, !dbg !1544
  %10 = bitcast i64* %8 to i8**, !dbg !1544
  %11 = load i8*, i8** %10, align 8, !dbg !1544
  store i8* %11, i8** %3, align 8, !dbg !1541
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1545, !srcloc !1546
  %12 = load i8*, i8** %3, align 8, !dbg !1547
  ret i8* %12, !dbg !1548
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1549 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1552, metadata !DIExpression()), !dbg !1553
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1554, metadata !DIExpression()), !dbg !1555
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1556, !srcloc !1557
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !1558
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !1559
  %8 = load i8*, i8** %4, align 8, !dbg !1560
  store i8* %8, i8** %5, align 8, !dbg !1561
  %9 = bitcast i8** %7 to i64*, !dbg !1561
  %10 = bitcast i8** %5 to i64*, !dbg !1561
  %11 = load i64, i64* %10, align 8, !dbg !1561
  store atomic i64 %11, i64* %9 monotonic, align 8, !dbg !1561
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1562, !srcloc !1563
  ret void, !dbg !1564
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicsz_write_rlx(%struct.vatomicsz_s* noundef %0, i64 noundef %1) #0 !dbg !1565 {
  %3 = alloca %struct.vatomicsz_s*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.vatomicsz_s* %0, %struct.vatomicsz_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicsz_s** %3, metadata !1568, metadata !DIExpression()), !dbg !1569
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1570, metadata !DIExpression()), !dbg !1571
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1572, !srcloc !1573
  %6 = load %struct.vatomicsz_s*, %struct.vatomicsz_s** %3, align 8, !dbg !1574
  %7 = getelementptr inbounds %struct.vatomicsz_s, %struct.vatomicsz_s* %6, i32 0, i32 0, !dbg !1575
  %8 = load i64, i64* %4, align 8, !dbg !1576
  store i64 %8, i64* %5, align 8, !dbg !1577
  %9 = load i64, i64* %5, align 8, !dbg !1577
  store atomic i64 %9, i64* %7 monotonic, align 8, !dbg !1577
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1578, !srcloc !1579
  ret void, !dbg !1580
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_write_release(%struct.rwlock_s* noundef %0) #0 !dbg !1581 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i64, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !1582, metadata !DIExpression()), !dbg !1583
  %4 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !1584
  %5 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %4, i32 0, i32 1, !dbg !1585
  call void @vatomic8_write_rlx(%struct.vatomic8_s* noundef %5, i8 noundef zeroext 0), !dbg !1586
  call void @llvm.dbg.declare(metadata i64* %3, metadata !1587, metadata !DIExpression()), !dbg !1589
  store i64 0, i64* %3, align 8, !dbg !1589
  br label %6, !dbg !1590

6:                                                ; preds = %15, %1
  %7 = load i64, i64* %3, align 8, !dbg !1591
  %8 = icmp ult i64 %7, 3, !dbg !1593
  br i1 %8, label %9, label %18, !dbg !1594

9:                                                ; preds = %6
  %10 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !1595
  %11 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %10, i32 0, i32 0, !dbg !1597
  %12 = load i64, i64* %3, align 8, !dbg !1598
  %13 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %11, i64 0, i64 %12, !dbg !1595
  %14 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef %13) #6, !dbg !1599
  br label %15, !dbg !1600

15:                                               ; preds = %9
  %16 = load i64, i64* %3, align 8, !dbg !1601
  %17 = add i64 %16, 1, !dbg !1601
  store i64 %17, i64* %3, align 8, !dbg !1601
  br label %6, !dbg !1602, !llvm.loop !1603

18:                                               ; preds = %6
  ret void, !dbg !1605
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic8_write_rlx(%struct.vatomic8_s* noundef %0, i8 noundef zeroext %1) #0 !dbg !1606 {
  %3 = alloca %struct.vatomic8_s*, align 8
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
  store %struct.vatomic8_s* %0, %struct.vatomic8_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic8_s** %3, metadata !1610, metadata !DIExpression()), !dbg !1611
  store i8 %1, i8* %4, align 1
  call void @llvm.dbg.declare(metadata i8* %4, metadata !1612, metadata !DIExpression()), !dbg !1613
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1614, !srcloc !1615
  %6 = load %struct.vatomic8_s*, %struct.vatomic8_s** %3, align 8, !dbg !1616
  %7 = getelementptr inbounds %struct.vatomic8_s, %struct.vatomic8_s* %6, i32 0, i32 0, !dbg !1617
  %8 = load i8, i8* %4, align 1, !dbg !1618
  store i8 %8, i8* %5, align 1, !dbg !1619
  %9 = load i8, i8* %5, align 1, !dbg !1619
  store atomic i8 %9, i8* %7 monotonic, align 1, !dbg !1619
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1620, !srcloc !1621
  ret void, !dbg !1622
}

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !1623 {
  %5 = alloca %struct.run_info_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8* (i8*)*, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !1626, metadata !DIExpression()), !dbg !1627
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1628, metadata !DIExpression()), !dbg !1629
  store i8* (i8*)* %2, i8* (i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %7, metadata !1630, metadata !DIExpression()), !dbg !1631
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !1632, metadata !DIExpression()), !dbg !1633
  call void @llvm.dbg.declare(metadata i64* %9, metadata !1634, metadata !DIExpression()), !dbg !1635
  store i64 0, i64* %9, align 8, !dbg !1635
  store i64 0, i64* %9, align 8, !dbg !1636
  br label %11, !dbg !1638

11:                                               ; preds = %42, %4
  %12 = load i64, i64* %9, align 8, !dbg !1639
  %13 = load i64, i64* %6, align 8, !dbg !1641
  %14 = icmp ult i64 %12, %13, !dbg !1642
  br i1 %14, label %15, label %45, !dbg !1643

15:                                               ; preds = %11
  %16 = load i64, i64* %9, align 8, !dbg !1644
  %17 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1646
  %18 = load i64, i64* %9, align 8, !dbg !1647
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %17, i64 %18, !dbg !1646
  %20 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %19, i32 0, i32 1, !dbg !1648
  store i64 %16, i64* %20, align 8, !dbg !1649
  %21 = load i8* (i8*)*, i8* (i8*)** %7, align 8, !dbg !1650
  %22 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1651
  %23 = load i64, i64* %9, align 8, !dbg !1652
  %24 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %22, i64 %23, !dbg !1651
  %25 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %24, i32 0, i32 3, !dbg !1653
  store i8* (i8*)* %21, i8* (i8*)** %25, align 8, !dbg !1654
  %26 = load i8, i8* %8, align 1, !dbg !1655
  %27 = trunc i8 %26 to i1, !dbg !1655
  %28 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1656
  %29 = load i64, i64* %9, align 8, !dbg !1657
  %30 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %28, i64 %29, !dbg !1656
  %31 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %30, i32 0, i32 2, !dbg !1658
  %32 = zext i1 %27 to i8, !dbg !1659
  store i8 %32, i8* %31, align 8, !dbg !1659
  %33 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1660
  %34 = load i64, i64* %9, align 8, !dbg !1661
  %35 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %33, i64 %34, !dbg !1660
  %36 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %35, i32 0, i32 0, !dbg !1662
  %37 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1663
  %38 = load i64, i64* %9, align 8, !dbg !1664
  %39 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %37, i64 %38, !dbg !1663
  %40 = bitcast %struct.run_info_t* %39 to i8*, !dbg !1665
  %41 = call i32 @pthread_create(i64* noundef %36, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %40) #6, !dbg !1666
  br label %42, !dbg !1667

42:                                               ; preds = %15
  %43 = load i64, i64* %9, align 8, !dbg !1668
  %44 = add i64 %43, 1, !dbg !1668
  store i64 %44, i64* %9, align 8, !dbg !1668
  br label %11, !dbg !1669, !llvm.loop !1670

45:                                               ; preds = %11
  ret void, !dbg !1672
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !1673 {
  %3 = alloca %struct.run_info_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !1676, metadata !DIExpression()), !dbg !1677
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1678, metadata !DIExpression()), !dbg !1679
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1680, metadata !DIExpression()), !dbg !1681
  store i64 0, i64* %5, align 8, !dbg !1681
  store i64 0, i64* %5, align 8, !dbg !1682
  br label %6, !dbg !1684

6:                                                ; preds = %17, %2
  %7 = load i64, i64* %5, align 8, !dbg !1685
  %8 = load i64, i64* %4, align 8, !dbg !1687
  %9 = icmp ult i64 %7, %8, !dbg !1688
  br i1 %9, label %10, label %20, !dbg !1689

10:                                               ; preds = %6
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1690
  %12 = load i64, i64* %5, align 8, !dbg !1692
  %13 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i64 %12, !dbg !1690
  %14 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %13, i32 0, i32 0, !dbg !1693
  %15 = load i64, i64* %14, align 8, !dbg !1693
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !1694
  br label %17, !dbg !1695

17:                                               ; preds = %10
  %18 = load i64, i64* %5, align 8, !dbg !1696
  %19 = add i64 %18, 1, !dbg !1696
  store i64 %19, i64* %5, align 8, !dbg !1696
  br label %6, !dbg !1697, !llvm.loop !1698

20:                                               ; preds = %6
  ret void, !dbg !1700
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !1701 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.run_info_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !1702, metadata !DIExpression()), !dbg !1703
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !1704, metadata !DIExpression()), !dbg !1705
  %4 = load i8*, i8** %2, align 8, !dbg !1706
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !1707
  store %struct.run_info_t* %5, %struct.run_info_t** %3, align 8, !dbg !1705
  %6 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1708
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %6, i32 0, i32 2, !dbg !1710
  %8 = load i8, i8* %7, align 8, !dbg !1710
  %9 = trunc i8 %8 to i1, !dbg !1710
  br i1 %9, label %10, label %14, !dbg !1711

10:                                               ; preds = %1
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1712
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i32 0, i32 1, !dbg !1713
  %13 = load i64, i64* %12, align 8, !dbg !1713
  call void @set_cpu_affinity(i64 noundef %13), !dbg !1714
  br label %14, !dbg !1714

14:                                               ; preds = %10, %1
  %15 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1715
  %16 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %15, i32 0, i32 3, !dbg !1716
  %17 = load i8* (i8*)*, i8* (i8*)** %16, align 8, !dbg !1716
  %18 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1717
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %18, i32 0, i32 1, !dbg !1718
  %20 = load i64, i64* %19, align 8, !dbg !1718
  %21 = inttoptr i64 %20 to i8*, !dbg !1719
  %22 = call i8* %17(i8* noundef %21), !dbg !1715
  ret i8* %22, !dbg !1720
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !1721 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1722, metadata !DIExpression()), !dbg !1723
  br label %3, !dbg !1724

3:                                                ; preds = %1
  br label %4, !dbg !1725

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1727
  br label %6, !dbg !1727

6:                                                ; preds = %4
  br label %7, !dbg !1729

7:                                                ; preds = %6
  br label %8, !dbg !1727

8:                                                ; preds = %7
  br label %9, !dbg !1725

9:                                                ; preds = %8
  ret void, !dbg !1731
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_thread_register(%struct.vsimpleht_s* noundef %0) #0 !dbg !1732 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !1733, metadata !DIExpression()), !dbg !1734
  %3 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1735
  %4 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %3, i32 0, i32 7, !dbg !1736
  call void @rwlock_read_acquire(%struct.rwlock_s* noundef %4), !dbg !1737
  ret void, !dbg !1738
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_thread_deregister(%struct.vsimpleht_s* noundef %0) #0 !dbg !1739 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !1740, metadata !DIExpression()), !dbg !1741
  %3 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1742
  %4 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %3, i32 0, i32 7, !dbg !1743
  call void @rwlock_read_release(%struct.rwlock_s* noundef %4), !dbg !1744
  ret void, !dbg !1745
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vsimpleht_buff_size(i64 noundef %0) #0 !dbg !1746 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1749, metadata !DIExpression()), !dbg !1750
  %3 = load i64, i64* %2, align 8, !dbg !1751
  %4 = icmp ugt i64 %3, 0, !dbg !1751
  br i1 %4, label %5, label %6, !dbg !1754

5:                                                ; preds = %1
  br label %7, !dbg !1754

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.31, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 128, i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @__PRETTY_FUNCTION__.vsimpleht_buff_size, i64 0, i64 0)) #5, !dbg !1751
  unreachable, !dbg !1751

7:                                                ; preds = %5
  %8 = load i64, i64* %2, align 8, !dbg !1755
  %9 = load i64, i64* %2, align 8, !dbg !1755
  %10 = sub i64 %9, 1, !dbg !1755
  %11 = and i64 %8, %10, !dbg !1755
  %12 = icmp eq i64 %11, 0, !dbg !1755
  br i1 %12, label %13, label %15, !dbg !1755

13:                                               ; preds = %7
  br i1 true, label %14, label %15, !dbg !1758

14:                                               ; preds = %13
  br label %16, !dbg !1758

15:                                               ; preds = %13, %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @.str.33, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 129, i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @__PRETTY_FUNCTION__.vsimpleht_buff_size, i64 0, i64 0)) #5, !dbg !1755
  unreachable, !dbg !1755

16:                                               ; preds = %14
  %17 = load i64, i64* %2, align 8, !dbg !1759
  %18 = mul i64 16, %17, !dbg !1760
  ret i64 %18, !dbg !1761
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_init(%struct.vsimpleht_s* noundef %0, i8* noundef %1, i64 noundef %2, i8 (i64, i64)* noundef %3, i64 (i64)* noundef %4, void (i8*)* noundef %5) #0 !dbg !1762 {
  %7 = alloca %struct.vsimpleht_s*, align 8
  %8 = alloca i8*, align 8
  %9 = alloca i64, align 8
  %10 = alloca i8 (i64, i64)*, align 8
  %11 = alloca i64 (i64)*, align 8
  %12 = alloca void (i8*)*, align 8
  %13 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %7, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %7, metadata !1765, metadata !DIExpression()), !dbg !1766
  store i8* %1, i8** %8, align 8
  call void @llvm.dbg.declare(metadata i8** %8, metadata !1767, metadata !DIExpression()), !dbg !1768
  store i64 %2, i64* %9, align 8
  call void @llvm.dbg.declare(metadata i64* %9, metadata !1769, metadata !DIExpression()), !dbg !1770
  store i8 (i64, i64)* %3, i8 (i64, i64)** %10, align 8
  call void @llvm.dbg.declare(metadata i8 (i64, i64)** %10, metadata !1771, metadata !DIExpression()), !dbg !1772
  store i64 (i64)* %4, i64 (i64)** %11, align 8
  call void @llvm.dbg.declare(metadata i64 (i64)** %11, metadata !1773, metadata !DIExpression()), !dbg !1774
  store void (i8*)* %5, void (i8*)** %12, align 8
  call void @llvm.dbg.declare(metadata void (i8*)** %12, metadata !1775, metadata !DIExpression()), !dbg !1776
  %14 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1777
  %15 = icmp ne %struct.vsimpleht_s* %14, null, !dbg !1777
  br i1 %15, label %16, label %17, !dbg !1780

16:                                               ; preds = %6
  br label %18, !dbg !1780

17:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.34, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 150, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1777
  unreachable, !dbg !1777

18:                                               ; preds = %16
  %19 = load i8*, i8** %8, align 8, !dbg !1781
  %20 = icmp ne i8* %19, null, !dbg !1781
  br i1 %20, label %21, label %22, !dbg !1784

21:                                               ; preds = %18
  br label %23, !dbg !1784

22:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.35, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 151, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1781
  unreachable, !dbg !1781

23:                                               ; preds = %21
  %24 = load i64, i64* %9, align 8, !dbg !1785
  %25 = icmp ugt i64 %24, 0, !dbg !1785
  br i1 %25, label %26, label %27, !dbg !1788

26:                                               ; preds = %23
  br label %28, !dbg !1788

27:                                               ; preds = %23
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.31, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 152, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1785
  unreachable, !dbg !1785

28:                                               ; preds = %26
  %29 = load i64, i64* %9, align 8, !dbg !1789
  %30 = load i64, i64* %9, align 8, !dbg !1789
  %31 = sub i64 %30, 1, !dbg !1789
  %32 = and i64 %29, %31, !dbg !1789
  %33 = icmp eq i64 %32, 0, !dbg !1789
  br i1 %33, label %34, label %36, !dbg !1789

34:                                               ; preds = %28
  br i1 true, label %35, label %36, !dbg !1792

35:                                               ; preds = %34
  br label %37, !dbg !1792

36:                                               ; preds = %34, %28
  call void @__assert_fail(i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.37, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 153, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1789
  unreachable, !dbg !1789

37:                                               ; preds = %35
  %38 = load i64, i64* %9, align 8, !dbg !1793
  %39 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1794
  %40 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %39, i32 0, i32 0, !dbg !1795
  store i64 %38, i64* %40, align 8, !dbg !1796
  %41 = load i8*, i8** %8, align 8, !dbg !1797
  %42 = bitcast i8* %41 to %struct.vsimpleht_entry_s*, !dbg !1797
  %43 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1798
  %44 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %43, i32 0, i32 1, !dbg !1799
  store %struct.vsimpleht_entry_s* %42, %struct.vsimpleht_entry_s** %44, align 8, !dbg !1800
  %45 = load i8 (i64, i64)*, i8 (i64, i64)** %10, align 8, !dbg !1801
  %46 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1802
  %47 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %46, i32 0, i32 2, !dbg !1803
  store i8 (i64, i64)* %45, i8 (i64, i64)** %47, align 8, !dbg !1804
  %48 = load i64 (i64)*, i64 (i64)** %11, align 8, !dbg !1805
  %49 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1806
  %50 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %49, i32 0, i32 3, !dbg !1807
  store i64 (i64)* %48, i64 (i64)** %50, align 8, !dbg !1808
  %51 = load void (i8*)*, void (i8*)** %12, align 8, !dbg !1809
  %52 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1810
  %53 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %52, i32 0, i32 4, !dbg !1811
  store void (i8*)* %51, void (i8*)** %53, align 8, !dbg !1812
  call void @llvm.dbg.declare(metadata i64* %13, metadata !1813, metadata !DIExpression()), !dbg !1815
  store i64 0, i64* %13, align 8, !dbg !1815
  br label %54, !dbg !1816

54:                                               ; preds = %73, %37
  %55 = load i64, i64* %13, align 8, !dbg !1817
  %56 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1819
  %57 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %56, i32 0, i32 0, !dbg !1820
  %58 = load i64, i64* %57, align 8, !dbg !1820
  %59 = icmp ult i64 %55, %58, !dbg !1821
  br i1 %59, label %60, label %76, !dbg !1822

60:                                               ; preds = %54
  %61 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1823
  %62 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %61, i32 0, i32 1, !dbg !1825
  %63 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %62, align 8, !dbg !1825
  %64 = load i64, i64* %13, align 8, !dbg !1826
  %65 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %63, i64 %64, !dbg !1823
  %66 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %65, i32 0, i32 0, !dbg !1827
  call void @vatomicptr_init(%struct.vatomicptr_s* noundef %66, i8* noundef null), !dbg !1828
  %67 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1829
  %68 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %67, i32 0, i32 1, !dbg !1830
  %69 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %68, align 8, !dbg !1830
  %70 = load i64, i64* %13, align 8, !dbg !1831
  %71 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %69, i64 %70, !dbg !1829
  %72 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %71, i32 0, i32 1, !dbg !1832
  call void @vatomicptr_init(%struct.vatomicptr_s* noundef %72, i8* noundef null), !dbg !1833
  br label %73, !dbg !1834

73:                                               ; preds = %60
  %74 = load i64, i64* %13, align 8, !dbg !1835
  %75 = add i64 %74, 1, !dbg !1835
  store i64 %75, i64* %13, align 8, !dbg !1835
  br label %54, !dbg !1836, !llvm.loop !1837

76:                                               ; preds = %54
  %77 = load i64, i64* %9, align 8, !dbg !1839
  %78 = udiv i64 %77, 4, !dbg !1840
  %79 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1841
  %80 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %79, i32 0, i32 5, !dbg !1842
  store i64 %78, i64* %80, align 8, !dbg !1843
  %81 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1844
  %82 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %81, i32 0, i32 6, !dbg !1845
  call void @vatomicsz_write_rlx(%struct.vatomicsz_s* noundef %82, i64 noundef 0), !dbg !1846
  %83 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1847
  %84 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %83, i32 0, i32 7, !dbg !1848
  call void @rwlock_init(%struct.rwlock_s* noundef %84), !dbg !1849
  ret void, !dbg !1850
}

; Function Attrs: noinline nounwind uwtable
define internal signext i8 @cb_cmp(i64 noundef %0, i64 noundef %1) #0 !dbg !1851 {
  %3 = alloca i8, align 1
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i64 %0, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1852, metadata !DIExpression()), !dbg !1853
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1854, metadata !DIExpression()), !dbg !1855
  %6 = load i64, i64* %4, align 8, !dbg !1856
  %7 = load i64, i64* %5, align 8, !dbg !1858
  %8 = icmp eq i64 %6, %7, !dbg !1859
  br i1 %8, label %9, label %10, !dbg !1860

9:                                                ; preds = %2
  store i8 0, i8* %3, align 1, !dbg !1861
  br label %16, !dbg !1861

10:                                               ; preds = %2
  %11 = load i64, i64* %4, align 8, !dbg !1863
  %12 = load i64, i64* %5, align 8, !dbg !1865
  %13 = icmp ult i64 %11, %12, !dbg !1866
  br i1 %13, label %14, label %15, !dbg !1867

14:                                               ; preds = %10
  store i8 -1, i8* %3, align 1, !dbg !1868
  br label %16, !dbg !1868

15:                                               ; preds = %10
  store i8 1, i8* %3, align 1, !dbg !1870
  br label %16, !dbg !1870

16:                                               ; preds = %15, %14, %9
  %17 = load i8, i8* %3, align 1, !dbg !1872
  ret i8 %17, !dbg !1872
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @cb_hash(i64 noundef %0) #0 !dbg !1873 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1874, metadata !DIExpression()), !dbg !1875
  %3 = load i64, i64* %2, align 8, !dbg !1876
  ret i64 %3, !dbg !1877
}

; Function Attrs: noinline nounwind uwtable
define internal void @cb_destroy(i8* noundef %0) #0 !dbg !1878 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !1879, metadata !DIExpression()), !dbg !1880
  %3 = load i8*, i8** %2, align 8, !dbg !1881
  call void @free(i8* noundef %3) #6, !dbg !1882
  ret void, !dbg !1883
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_init(%struct.trace_s* noundef %0, i64 noundef %1) #0 !dbg !1884 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !1887, metadata !DIExpression()), !dbg !1888
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1889, metadata !DIExpression()), !dbg !1890
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1891
  %6 = icmp ne %struct.trace_s* %5, null, !dbg !1891
  br i1 %6, label %7, label %8, !dbg !1894

7:                                                ; preds = %2
  br label %9, !dbg !1894

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.20, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 36, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !1891
  unreachable, !dbg !1891

9:                                                ; preds = %7
  %10 = load i64, i64* %4, align 8, !dbg !1895
  %11 = mul i64 %10, 16, !dbg !1896
  %12 = call noalias i8* @malloc(i64 noundef %11) #6, !dbg !1897
  %13 = bitcast i8* %12 to %struct.trace_unit_s*, !dbg !1897
  %14 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1898
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 0, !dbg !1899
  store %struct.trace_unit_s* %13, %struct.trace_unit_s** %15, align 8, !dbg !1900
  %16 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1901
  %17 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %16, i32 0, i32 0, !dbg !1903
  %18 = load %struct.trace_unit_s*, %struct.trace_unit_s** %17, align 8, !dbg !1903
  %19 = icmp ne %struct.trace_unit_s* %18, null, !dbg !1901
  br i1 %19, label %20, label %28, !dbg !1904

20:                                               ; preds = %9
  %21 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1905
  %22 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %21, i32 0, i32 1, !dbg !1907
  store i64 0, i64* %22, align 8, !dbg !1908
  %23 = load i64, i64* %4, align 8, !dbg !1909
  %24 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1910
  %25 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %24, i32 0, i32 2, !dbg !1911
  store i64 %23, i64* %25, align 8, !dbg !1912
  %26 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1913
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 3, !dbg !1914
  store i8 1, i8* %27, align 8, !dbg !1915
  br label %35, !dbg !1916

28:                                               ; preds = %9
  %29 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1917
  %30 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %29, i32 0, i32 1, !dbg !1919
  store i64 0, i64* %30, align 8, !dbg !1920
  %31 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1921
  %32 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %31, i32 0, i32 2, !dbg !1922
  store i64 0, i64* %32, align 8, !dbg !1923
  %33 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1924
  %34 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %33, i32 0, i32 3, !dbg !1925
  store i8 0, i8* %34, align 8, !dbg !1926
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.26, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 46, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !1927
  unreachable, !dbg !1927

35:                                               ; preds = %20
  ret void, !dbg !1930
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_init(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1931 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1932, metadata !DIExpression()), !dbg !1933
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1934, metadata !DIExpression()), !dbg !1935
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !1936
  %6 = load i8*, i8** %4, align 8, !dbg !1937
  call void @vatomicptr_write(%struct.vatomicptr_s* noundef %5, i8* noundef %6), !dbg !1938
  ret void, !dbg !1939
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_init(%struct.rwlock_s* noundef %0) #0 !dbg !1940 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i64, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !1941, metadata !DIExpression()), !dbg !1942
  call void @llvm.dbg.declare(metadata i64* %3, metadata !1943, metadata !DIExpression()), !dbg !1945
  store i64 0, i64* %3, align 8, !dbg !1945
  br label %4, !dbg !1946

4:                                                ; preds = %13, %1
  %5 = load i64, i64* %3, align 8, !dbg !1947
  %6 = icmp ult i64 %5, 3, !dbg !1949
  br i1 %6, label %7, label %16, !dbg !1950

7:                                                ; preds = %4
  %8 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !1951
  %9 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %8, i32 0, i32 0, !dbg !1953
  %10 = load i64, i64* %3, align 8, !dbg !1954
  %11 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %9, i64 0, i64 %10, !dbg !1951
  %12 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %11, %union.pthread_mutexattr_t* noundef null) #6, !dbg !1955
  br label %13, !dbg !1956

13:                                               ; preds = %7
  %14 = load i64, i64* %3, align 8, !dbg !1957
  %15 = add i64 %14, 1, !dbg !1957
  store i64 %15, i64* %3, align 8, !dbg !1957
  br label %4, !dbg !1958, !llvm.loop !1959

16:                                               ; preds = %4
  ret void, !dbg !1961
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1962 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1963, metadata !DIExpression()), !dbg !1964
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1965, metadata !DIExpression()), !dbg !1966
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1967, !srcloc !1968
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !1969
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !1970
  %8 = load i8*, i8** %4, align 8, !dbg !1971
  store i8* %8, i8** %5, align 8, !dbg !1972
  %9 = bitcast i8** %7 to i64*, !dbg !1972
  %10 = bitcast i8** %5 to i64*, !dbg !1972
  %11 = load i64, i64* %10, align 8, !dbg !1972
  store atomic i64 %11, i64* %9 seq_cst, align 8, !dbg !1972
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1973, !srcloc !1974
  ret void, !dbg !1975
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @_imap_verify() #0 !dbg !1976 {
  %1 = alloca i64, align 8
  %2 = alloca %struct.data_s*, align 8
  %3 = alloca %struct.vsimpleht_iter_s, align 8
  %4 = alloca %struct.trace_s, align 8
  %5 = alloca %struct.trace_s, align 8
  %6 = alloca %struct.trace_s, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata i64* %1, metadata !1977, metadata !DIExpression()), !dbg !1978
  store i64 0, i64* %1, align 8, !dbg !1978
  call void @llvm.dbg.declare(metadata %struct.data_s** %2, metadata !1979, metadata !DIExpression()), !dbg !1980
  store %struct.data_s* null, %struct.data_s** %2, align 8, !dbg !1980
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_iter_s* %3, metadata !1981, metadata !DIExpression()), !dbg !1987
  call void @llvm.dbg.declare(metadata %struct.trace_s* %4, metadata !1988, metadata !DIExpression()), !dbg !1989
  call void @llvm.dbg.declare(metadata %struct.trace_s* %5, metadata !1990, metadata !DIExpression()), !dbg !1991
  call void @llvm.dbg.declare(metadata %struct.trace_s* %6, metadata !1992, metadata !DIExpression()), !dbg !1993
  call void @trace_init(%struct.trace_s* noundef %4, i64 noundef 8), !dbg !1994
  call void @trace_init(%struct.trace_s* noundef %5, i64 noundef 8), !dbg !1995
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1996, metadata !DIExpression()), !dbg !1998
  store i64 0, i64* %7, align 8, !dbg !1998
  br label %9, !dbg !1999

9:                                                ; preds = %17, %0
  %10 = load i64, i64* %7, align 8, !dbg !2000
  %11 = icmp ult i64 %10, 4, !dbg !2002
  br i1 %11, label %12, label %20, !dbg !2003

12:                                               ; preds = %9
  %13 = load i64, i64* %7, align 8, !dbg !2004
  %14 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %13, !dbg !2006
  call void @trace_merge_into(%struct.trace_s* noundef %4, %struct.trace_s* noundef %14), !dbg !2007
  %15 = load i64, i64* %7, align 8, !dbg !2008
  %16 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_rem, i64 0, i64 %15, !dbg !2009
  call void @trace_merge_into(%struct.trace_s* noundef %5, %struct.trace_s* noundef %16), !dbg !2010
  br label %17, !dbg !2011

17:                                               ; preds = %12
  %18 = load i64, i64* %7, align 8, !dbg !2012
  %19 = add i64 %18, 1, !dbg !2012
  store i64 %19, i64* %7, align 8, !dbg !2012
  br label %9, !dbg !2013, !llvm.loop !2014

20:                                               ; preds = %9
  call void @trace_init(%struct.trace_s* noundef %6, i64 noundef 8), !dbg !2016
  call void @vsimpleht_iter_init(%struct.vsimpleht_s* noundef @g_simpleht, %struct.vsimpleht_iter_s* noundef %3), !dbg !2017
  br label %21, !dbg !2018

21:                                               ; preds = %24, %20
  %22 = bitcast %struct.data_s** %2 to i8**, !dbg !2019
  %23 = call zeroext i1 @vsimpleht_iter_next(%struct.vsimpleht_iter_s* noundef %3, i64* noundef %1, i8** noundef %22), !dbg !2020
  br i1 %23, label %24, label %26, !dbg !2018

24:                                               ; preds = %21
  %25 = load i64, i64* %1, align 8, !dbg !2021
  call void @trace_add(%struct.trace_s* noundef %6, i64 noundef %25), !dbg !2023
  br label %21, !dbg !2018, !llvm.loop !2024

26:                                               ; preds = %21
  call void @trace_subtract_from(%struct.trace_s* noundef %4, %struct.trace_s* noundef %5), !dbg !2026
  call void @llvm.dbg.declare(metadata i8* %8, metadata !2027, metadata !DIExpression()), !dbg !2028
  %27 = call zeroext i1 @trace_is_subtrace(%struct.trace_s* noundef %4, %struct.trace_s* noundef %6, void (i64)* noundef null), !dbg !2029
  %28 = zext i1 %27 to i8, !dbg !2028
  store i8 %28, i8* %8, align 1, !dbg !2028
  call void @trace_destroy(%struct.trace_s* noundef %4), !dbg !2030
  call void @trace_destroy(%struct.trace_s* noundef %5), !dbg !2031
  call void @trace_destroy(%struct.trace_s* noundef %6), !dbg !2032
  %29 = load i8, i8* %8, align 1, !dbg !2033
  %30 = trunc i8 %29 to i1, !dbg !2033
  br i1 %30, label %31, label %33, !dbg !2033

31:                                               ; preds = %26
  br i1 true, label %32, label %33, !dbg !2036

32:                                               ; preds = %31
  br label %34, !dbg !2036

33:                                               ; preds = %31, %26
  call void @__assert_fail(i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.39, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.28, i64 0, i64 0), i32 noundef 109, i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @__PRETTY_FUNCTION__._imap_verify, i64 0, i64 0)) #5, !dbg !2033
  unreachable, !dbg !2033

34:                                               ; preds = %32
  ret void, !dbg !2037
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_destroy(%struct.trace_s* noundef %0) #0 !dbg !2038 {
  %2 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %2, metadata !2039, metadata !DIExpression()), !dbg !2040
  %3 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !2041
  %4 = icmp ne %struct.trace_s* %3, null, !dbg !2041
  br i1 %4, label %5, label %6, !dbg !2044

5:                                                ; preds = %1
  br label %7, !dbg !2044

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.20, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !2041
  unreachable, !dbg !2041

7:                                                ; preds = %5
  %8 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !2045
  %9 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %8, i32 0, i32 3, !dbg !2045
  %10 = load i8, i8* %9, align 8, !dbg !2045
  %11 = trunc i8 %10 to i1, !dbg !2045
  br i1 %11, label %12, label %13, !dbg !2048

12:                                               ; preds = %7
  br label %14, !dbg !2048

13:                                               ; preds = %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.22, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 101, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !2045
  unreachable, !dbg !2045

14:                                               ; preds = %12
  %15 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !2049
  %16 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %15, i32 0, i32 0, !dbg !2050
  %17 = load %struct.trace_unit_s*, %struct.trace_unit_s** %16, align 8, !dbg !2050
  %18 = bitcast %struct.trace_unit_s* %17 to i8*, !dbg !2049
  call void @free(i8* noundef %18) #6, !dbg !2051
  %19 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !2052
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 3, !dbg !2053
  store i8 0, i8* %20, align 8, !dbg !2054
  ret void, !dbg !2055
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_destroy(%struct.vsimpleht_s* noundef %0) #0 !dbg !2056 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  %3 = alloca %struct.vsimpleht_entry_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !2057, metadata !DIExpression()), !dbg !2058
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_entry_s** %3, metadata !2059, metadata !DIExpression()), !dbg !2060
  store %struct.vsimpleht_entry_s* null, %struct.vsimpleht_entry_s** %3, align 8, !dbg !2060
  call void @llvm.dbg.declare(metadata i8** %4, metadata !2061, metadata !DIExpression()), !dbg !2062
  store i8* null, i8** %4, align 8, !dbg !2062
  %6 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !2063
  %7 = icmp ne %struct.vsimpleht_s* %6, null, !dbg !2063
  br i1 %7, label %8, label %9, !dbg !2066

8:                                                ; preds = %1
  br label %10, !dbg !2066

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.34, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 182, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__.vsimpleht_destroy, i64 0, i64 0)) #5, !dbg !2063
  unreachable, !dbg !2063

10:                                               ; preds = %8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !2067, metadata !DIExpression()), !dbg !2069
  store i64 0, i64* %5, align 8, !dbg !2069
  br label %11, !dbg !2070

11:                                               ; preds = %34, %10
  %12 = load i64, i64* %5, align 8, !dbg !2071
  %13 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !2073
  %14 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %13, i32 0, i32 0, !dbg !2074
  %15 = load i64, i64* %14, align 8, !dbg !2074
  %16 = icmp ult i64 %12, %15, !dbg !2075
  br i1 %16, label %17, label %37, !dbg !2076

17:                                               ; preds = %11
  %18 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !2077
  %19 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %18, i32 0, i32 1, !dbg !2079
  %20 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %19, align 8, !dbg !2079
  %21 = load i64, i64* %5, align 8, !dbg !2080
  %22 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %20, i64 %21, !dbg !2077
  store %struct.vsimpleht_entry_s* %22, %struct.vsimpleht_entry_s** %3, align 8, !dbg !2081
  %23 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %3, align 8, !dbg !2082
  %24 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %23, i32 0, i32 1, !dbg !2083
  %25 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %24), !dbg !2084
  store i8* %25, i8** %4, align 8, !dbg !2085
  %26 = load i8*, i8** %4, align 8, !dbg !2086
  %27 = icmp ne i8* %26, null, !dbg !2086
  br i1 %27, label %28, label %33, !dbg !2088

28:                                               ; preds = %17
  %29 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !2089
  %30 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %29, i32 0, i32 4, !dbg !2091
  %31 = load void (i8*)*, void (i8*)** %30, align 8, !dbg !2091
  %32 = load i8*, i8** %4, align 8, !dbg !2092
  call void %31(i8* noundef %32), !dbg !2089
  br label %33, !dbg !2093

33:                                               ; preds = %28, %17
  br label %34, !dbg !2094

34:                                               ; preds = %33
  %35 = load i64, i64* %5, align 8, !dbg !2095
  %36 = add i64 %35, 1, !dbg !2095
  store i64 %36, i64* %5, align 8, !dbg !2095
  br label %11, !dbg !2096, !llvm.loop !2097

37:                                               ; preds = %11
  ret void, !dbg !2099
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_merge_into(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1) #0 !dbg !2100 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !2103, metadata !DIExpression()), !dbg !2104
  store %struct.trace_s* %1, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !2105, metadata !DIExpression()), !dbg !2106
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !2107
  %6 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !2108
  call void @_trace_merge_or_subtract(%struct.trace_s* noundef %5, %struct.trace_s* noundef %6, i1 noundef zeroext false), !dbg !2109
  ret void, !dbg !2110
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_iter_init(%struct.vsimpleht_s* noundef %0, %struct.vsimpleht_iter_s* noundef %1) #0 !dbg !2111 {
  %3 = alloca %struct.vsimpleht_s*, align 8
  %4 = alloca %struct.vsimpleht_iter_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %3, metadata !2115, metadata !DIExpression()), !dbg !2116
  store %struct.vsimpleht_iter_s* %1, %struct.vsimpleht_iter_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_iter_s** %4, metadata !2117, metadata !DIExpression()), !dbg !2118
  %5 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !2119
  %6 = icmp ne %struct.vsimpleht_s* %5, null, !dbg !2119
  br i1 %6, label %7, label %8, !dbg !2122

7:                                                ; preds = %2
  br label %9, !dbg !2122

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.34, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 282, i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_init, i64 0, i64 0)) #5, !dbg !2119
  unreachable, !dbg !2119

9:                                                ; preds = %7
  %10 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %4, align 8, !dbg !2123
  %11 = icmp ne %struct.vsimpleht_iter_s* %10, null, !dbg !2123
  br i1 %11, label %12, label %13, !dbg !2126

12:                                               ; preds = %9
  br label %14, !dbg !2126

13:                                               ; preds = %9
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.42, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 283, i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_init, i64 0, i64 0)) #5, !dbg !2123
  unreachable, !dbg !2123

14:                                               ; preds = %12
  %15 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !2127
  %16 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %4, align 8, !dbg !2128
  %17 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %16, i32 0, i32 0, !dbg !2129
  store %struct.vsimpleht_s* %15, %struct.vsimpleht_s** %17, align 8, !dbg !2130
  %18 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %4, align 8, !dbg !2131
  %19 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %18, i32 0, i32 1, !dbg !2132
  store i64 0, i64* %19, align 8, !dbg !2133
  ret void, !dbg !2134
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @vsimpleht_iter_next(%struct.vsimpleht_iter_s* noundef %0, i64* noundef %1, i8** noundef %2) #0 !dbg !2135 {
  %4 = alloca i1, align 1
  %5 = alloca %struct.vsimpleht_iter_s*, align 8
  %6 = alloca i64*, align 8
  %7 = alloca i8**, align 8
  %8 = alloca i64, align 8
  %9 = alloca i8*, align 8
  %10 = alloca %struct.vsimpleht_entry_s*, align 8
  %11 = alloca i64, align 8
  store %struct.vsimpleht_iter_s* %0, %struct.vsimpleht_iter_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_iter_s** %5, metadata !2139, metadata !DIExpression()), !dbg !2140
  store i64* %1, i64** %6, align 8
  call void @llvm.dbg.declare(metadata i64** %6, metadata !2141, metadata !DIExpression()), !dbg !2142
  store i8** %2, i8*** %7, align 8
  call void @llvm.dbg.declare(metadata i8*** %7, metadata !2143, metadata !DIExpression()), !dbg !2144
  call void @llvm.dbg.declare(metadata i64* %8, metadata !2145, metadata !DIExpression()), !dbg !2146
  store i64 0, i64* %8, align 8, !dbg !2146
  call void @llvm.dbg.declare(metadata i8** %9, metadata !2147, metadata !DIExpression()), !dbg !2148
  store i8* null, i8** %9, align 8, !dbg !2148
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_entry_s** %10, metadata !2149, metadata !DIExpression()), !dbg !2150
  store %struct.vsimpleht_entry_s* null, %struct.vsimpleht_entry_s** %10, align 8, !dbg !2150
  %12 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !2151
  %13 = icmp ne %struct.vsimpleht_iter_s* %12, null, !dbg !2151
  br i1 %13, label %14, label %15, !dbg !2154

14:                                               ; preds = %3
  br label %16, !dbg !2154

15:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.42, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 322, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !2151
  unreachable, !dbg !2151

16:                                               ; preds = %14
  %17 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !2155
  %18 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %17, i32 0, i32 0, !dbg !2155
  %19 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %18, align 8, !dbg !2155
  %20 = icmp ne %struct.vsimpleht_s* %19, null, !dbg !2155
  br i1 %20, label %21, label %22, !dbg !2158

21:                                               ; preds = %16
  br label %23, !dbg !2158

22:                                               ; preds = %16
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.43, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 323, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !2155
  unreachable, !dbg !2155

23:                                               ; preds = %21
  %24 = load i64*, i64** %6, align 8, !dbg !2159
  %25 = icmp ne i64* %24, null, !dbg !2159
  br i1 %25, label %26, label %27, !dbg !2162

26:                                               ; preds = %23
  br label %28, !dbg !2162

27:                                               ; preds = %23
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.44, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 324, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !2159
  unreachable, !dbg !2159

28:                                               ; preds = %26
  %29 = load i8**, i8*** %7, align 8, !dbg !2163
  %30 = icmp ne i8** %29, null, !dbg !2163
  br i1 %30, label %31, label %32, !dbg !2166

31:                                               ; preds = %28
  br label %33, !dbg !2166

32:                                               ; preds = %28
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.45, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 325, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !2163
  unreachable, !dbg !2163

33:                                               ; preds = %31
  %34 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !2167
  %35 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %34, i32 0, i32 0, !dbg !2168
  %36 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %35, align 8, !dbg !2168
  %37 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %36, i32 0, i32 1, !dbg !2169
  %38 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %37, align 8, !dbg !2169
  store %struct.vsimpleht_entry_s* %38, %struct.vsimpleht_entry_s** %10, align 8, !dbg !2170
  %39 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !2171
  %40 = icmp ne %struct.vsimpleht_entry_s* %39, null, !dbg !2171
  br i1 %40, label %41, label %42, !dbg !2174

41:                                               ; preds = %33
  br label %43, !dbg !2174

42:                                               ; preds = %33
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.46, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.8, i64 0, i64 0), i32 noundef 327, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !2171
  unreachable, !dbg !2171

43:                                               ; preds = %41
  call void @llvm.dbg.declare(metadata i64* %11, metadata !2175, metadata !DIExpression()), !dbg !2177
  %44 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !2178
  %45 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %44, i32 0, i32 1, !dbg !2179
  %46 = load i64, i64* %45, align 8, !dbg !2179
  store i64 %46, i64* %11, align 8, !dbg !2177
  br label %47, !dbg !2180

47:                                               ; preds = %82, %43
  %48 = load i64, i64* %11, align 8, !dbg !2181
  %49 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !2183
  %50 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %49, i32 0, i32 0, !dbg !2184
  %51 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %50, align 8, !dbg !2184
  %52 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %51, i32 0, i32 0, !dbg !2185
  %53 = load i64, i64* %52, align 8, !dbg !2185
  %54 = icmp ult i64 %48, %53, !dbg !2186
  br i1 %54, label %55, label %85, !dbg !2187

55:                                               ; preds = %47
  %56 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !2188
  %57 = load i64, i64* %11, align 8, !dbg !2190
  %58 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %56, i64 %57, !dbg !2188
  %59 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %58, i32 0, i32 0, !dbg !2191
  %60 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %59), !dbg !2192
  %61 = ptrtoint i8* %60 to i64, !dbg !2193
  store i64 %61, i64* %8, align 8, !dbg !2194
  %62 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !2195
  %63 = load i64, i64* %11, align 8, !dbg !2196
  %64 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %62, i64 %63, !dbg !2195
  %65 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %64, i32 0, i32 1, !dbg !2197
  %66 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %65), !dbg !2198
  store i8* %66, i8** %9, align 8, !dbg !2199
  %67 = load i64, i64* %8, align 8, !dbg !2200
  %68 = icmp ne i64 %67, 0, !dbg !2200
  br i1 %68, label %69, label %81, !dbg !2202

69:                                               ; preds = %55
  %70 = load i8*, i8** %9, align 8, !dbg !2203
  %71 = icmp ne i8* %70, null, !dbg !2203
  br i1 %71, label %72, label %81, !dbg !2204

72:                                               ; preds = %69
  %73 = load i64, i64* %11, align 8, !dbg !2205
  %74 = add i64 %73, 1, !dbg !2207
  %75 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !2208
  %76 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %75, i32 0, i32 1, !dbg !2209
  store i64 %74, i64* %76, align 8, !dbg !2210
  %77 = load i64, i64* %8, align 8, !dbg !2211
  %78 = load i64*, i64** %6, align 8, !dbg !2212
  store i64 %77, i64* %78, align 8, !dbg !2213
  %79 = load i8*, i8** %9, align 8, !dbg !2214
  %80 = load i8**, i8*** %7, align 8, !dbg !2215
  store i8* %79, i8** %80, align 8, !dbg !2216
  store i1 true, i1* %4, align 1, !dbg !2217
  br label %86, !dbg !2217

81:                                               ; preds = %69, %55
  br label %82, !dbg !2218

82:                                               ; preds = %81
  %83 = load i64, i64* %11, align 8, !dbg !2219
  %84 = add i64 %83, 1, !dbg !2219
  store i64 %84, i64* %11, align 8, !dbg !2219
  br label %47, !dbg !2220, !llvm.loop !2221

85:                                               ; preds = %47
  store i1 false, i1* %4, align 1, !dbg !2223
  br label %86, !dbg !2223

86:                                               ; preds = %85, %72
  %87 = load i1, i1* %4, align 1, !dbg !2224
  ret i1 %87, !dbg !2224
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_subtract_from(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1) #0 !dbg !2225 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !2226, metadata !DIExpression()), !dbg !2227
  store %struct.trace_s* %1, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !2228, metadata !DIExpression()), !dbg !2229
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !2230
  %6 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !2231
  call void @_trace_merge_or_subtract(%struct.trace_s* noundef %5, %struct.trace_s* noundef %6, i1 noundef zeroext true), !dbg !2232
  ret void, !dbg !2233
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @trace_is_subtrace(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1, void (i64)* noundef %2) #0 !dbg !2234 {
  %4 = alloca i1, align 1
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca %struct.trace_s*, align 8
  %7 = alloca void (i64)*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca %struct.trace_unit_s*, align 8
  %11 = alloca %struct.trace_unit_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !2240, metadata !DIExpression()), !dbg !2241
  store %struct.trace_s* %1, %struct.trace_s** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %6, metadata !2242, metadata !DIExpression()), !dbg !2243
  store void (i64)* %2, void (i64)** %7, align 8
  call void @llvm.dbg.declare(metadata void (i64)** %7, metadata !2244, metadata !DIExpression()), !dbg !2245
  call void @llvm.dbg.declare(metadata i64* %8, metadata !2246, metadata !DIExpression()), !dbg !2247
  store i64 0, i64* %8, align 8, !dbg !2247
  call void @llvm.dbg.declare(metadata i64* %9, metadata !2248, metadata !DIExpression()), !dbg !2249
  store i64 0, i64* %9, align 8, !dbg !2249
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %10, metadata !2250, metadata !DIExpression()), !dbg !2251
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %11, metadata !2252, metadata !DIExpression()), !dbg !2253
  store i64 0, i64* %8, align 8, !dbg !2254
  br label %12, !dbg !2256

12:                                               ; preds = %86, %3
  %13 = load i64, i64* %8, align 8, !dbg !2257
  %14 = load %struct.trace_s*, %struct.trace_s** %6, align 8, !dbg !2259
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 1, !dbg !2260
  %16 = load i64, i64* %15, align 8, !dbg !2260
  %17 = icmp ult i64 %13, %16, !dbg !2261
  br i1 %17, label %18, label %89, !dbg !2262

18:                                               ; preds = %12
  %19 = load %struct.trace_s*, %struct.trace_s** %6, align 8, !dbg !2263
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 0, !dbg !2265
  %21 = load %struct.trace_unit_s*, %struct.trace_unit_s** %20, align 8, !dbg !2265
  %22 = load i64, i64* %8, align 8, !dbg !2266
  %23 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %21, i64 %22, !dbg !2263
  store %struct.trace_unit_s* %23, %struct.trace_unit_s** %10, align 8, !dbg !2267
  %24 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !2268
  %25 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2270
  %26 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %25, i32 0, i32 0, !dbg !2271
  %27 = load i64, i64* %26, align 8, !dbg !2271
  %28 = call zeroext i1 @trace_find_unit_idx(%struct.trace_s* noundef %24, i64 noundef %27, i64* noundef %9), !dbg !2272
  br i1 %28, label %29, label %72, !dbg !2273

29:                                               ; preds = %18
  %30 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !2274
  %31 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %30, i32 0, i32 0, !dbg !2276
  %32 = load %struct.trace_unit_s*, %struct.trace_unit_s** %31, align 8, !dbg !2276
  %33 = load i64, i64* %9, align 8, !dbg !2277
  %34 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %32, i64 %33, !dbg !2274
  store %struct.trace_unit_s* %34, %struct.trace_unit_s** %11, align 8, !dbg !2278
  %35 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2279
  %36 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %35, i32 0, i32 0, !dbg !2279
  %37 = load i64, i64* %36, align 8, !dbg !2279
  %38 = load %struct.trace_unit_s*, %struct.trace_unit_s** %11, align 8, !dbg !2279
  %39 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %38, i32 0, i32 0, !dbg !2279
  %40 = load i64, i64* %39, align 8, !dbg !2279
  %41 = icmp eq i64 %37, %40, !dbg !2279
  br i1 %41, label %42, label %43, !dbg !2282

42:                                               ; preds = %29
  br label %44, !dbg !2282

43:                                               ; preds = %29
  call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.47, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 308, i8* noundef getelementptr inbounds ([70 x i8], [70 x i8]* @__PRETTY_FUNCTION__.trace_is_subtrace, i64 0, i64 0)) #5, !dbg !2279
  unreachable, !dbg !2279

44:                                               ; preds = %42
  %45 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2283
  %46 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %45, i32 0, i32 1, !dbg !2285
  %47 = load i64, i64* %46, align 8, !dbg !2285
  %48 = load %struct.trace_unit_s*, %struct.trace_unit_s** %11, align 8, !dbg !2286
  %49 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %48, i32 0, i32 1, !dbg !2287
  %50 = load i64, i64* %49, align 8, !dbg !2287
  %51 = icmp ne i64 %47, %50, !dbg !2288
  br i1 %51, label %52, label %71, !dbg !2289

52:                                               ; preds = %44
  %53 = load void (i64)*, void (i64)** %7, align 8, !dbg !2290
  %54 = icmp ne void (i64)* %53, null, !dbg !2290
  br i1 %54, label %55, label %70, !dbg !2293

55:                                               ; preds = %52
  %56 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2294
  %57 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %56, i32 0, i32 0, !dbg !2296
  %58 = load i64, i64* %57, align 8, !dbg !2296
  %59 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2297
  %60 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %59, i32 0, i32 1, !dbg !2298
  %61 = load i64, i64* %60, align 8, !dbg !2298
  %62 = load %struct.trace_unit_s*, %struct.trace_unit_s** %11, align 8, !dbg !2299
  %63 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %62, i32 0, i32 1, !dbg !2300
  %64 = load i64, i64* %63, align 8, !dbg !2300
  %65 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @.str.48, i64 0, i64 0), i64 noundef %58, i64 noundef %61, i64 noundef %64), !dbg !2301
  %66 = load void (i64)*, void (i64)** %7, align 8, !dbg !2302
  %67 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2303
  %68 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %67, i32 0, i32 0, !dbg !2304
  %69 = load i64, i64* %68, align 8, !dbg !2304
  call void %66(i64 noundef %69), !dbg !2302
  br label %70, !dbg !2305

70:                                               ; preds = %55, %52
  store i1 false, i1* %4, align 1, !dbg !2306
  br label %90, !dbg !2306

71:                                               ; preds = %44
  br label %85, !dbg !2307

72:                                               ; preds = %18
  %73 = load void (i64)*, void (i64)** %7, align 8, !dbg !2308
  %74 = icmp ne void (i64)* %73, null, !dbg !2308
  br i1 %74, label %75, label %84, !dbg !2311

75:                                               ; preds = %72
  %76 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2312
  %77 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %76, i32 0, i32 0, !dbg !2314
  %78 = load i64, i64* %77, align 8, !dbg !2314
  %79 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.49, i64 0, i64 0), i64 noundef %78), !dbg !2315
  %80 = load void (i64)*, void (i64)** %7, align 8, !dbg !2316
  %81 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2317
  %82 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %81, i32 0, i32 0, !dbg !2318
  %83 = load i64, i64* %82, align 8, !dbg !2318
  call void %80(i64 noundef %83), !dbg !2316
  br label %84, !dbg !2319

84:                                               ; preds = %75, %72
  store i1 false, i1* %4, align 1, !dbg !2320
  br label %90, !dbg !2320

85:                                               ; preds = %71
  br label %86, !dbg !2321

86:                                               ; preds = %85
  %87 = load i64, i64* %8, align 8, !dbg !2322
  %88 = add i64 %87, 1, !dbg !2322
  store i64 %88, i64* %8, align 8, !dbg !2322
  br label %12, !dbg !2323, !llvm.loop !2324

89:                                               ; preds = %12
  store i1 true, i1* %4, align 1, !dbg !2326
  br label %90, !dbg !2326

90:                                               ; preds = %89, %84, %70
  %91 = load i1, i1* %4, align 1, !dbg !2327
  ret i1 %91, !dbg !2327
}

; Function Attrs: noinline nounwind uwtable
define internal void @_trace_merge_or_subtract(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1, i1 noundef zeroext %2) #0 !dbg !2328 {
  %4 = alloca %struct.trace_s*, align 8
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca i8, align 1
  %7 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !2331, metadata !DIExpression()), !dbg !2332
  store %struct.trace_s* %1, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !2333, metadata !DIExpression()), !dbg !2334
  %8 = zext i1 %2 to i8
  store i8 %8, i8* %6, align 1
  call void @llvm.dbg.declare(metadata i8* %6, metadata !2335, metadata !DIExpression()), !dbg !2336
  call void @llvm.dbg.declare(metadata i64* %7, metadata !2337, metadata !DIExpression()), !dbg !2338
  store i64 0, i64* %7, align 8, !dbg !2338
  %9 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !2339
  %10 = icmp ne %struct.trace_s* %9, null, !dbg !2339
  br i1 %10, label %11, label %12, !dbg !2342

11:                                               ; preds = %3
  br label %13, !dbg !2342

12:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.40, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 165, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !2339
  unreachable, !dbg !2339

13:                                               ; preds = %11
  %14 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !2343
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 3, !dbg !2343
  %16 = load i8, i8* %15, align 8, !dbg !2343
  %17 = trunc i8 %16 to i1, !dbg !2343
  br i1 %17, label %18, label %19, !dbg !2346

18:                                               ; preds = %13
  br label %20, !dbg !2346

19:                                               ; preds = %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.41, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 166, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !2343
  unreachable, !dbg !2343

20:                                               ; preds = %18
  %21 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !2347
  %22 = icmp ne %struct.trace_s* %21, null, !dbg !2347
  br i1 %22, label %23, label %24, !dbg !2350

23:                                               ; preds = %20
  br label %25, !dbg !2350

24:                                               ; preds = %20
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.20, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 168, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !2347
  unreachable, !dbg !2347

25:                                               ; preds = %23
  %26 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !2351
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 3, !dbg !2351
  %28 = load i8, i8* %27, align 8, !dbg !2351
  %29 = trunc i8 %28 to i1, !dbg !2351
  br i1 %29, label %30, label %31, !dbg !2354

30:                                               ; preds = %25
  br label %32, !dbg !2354

31:                                               ; preds = %25
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.22, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.21, i64 0, i64 0), i32 noundef 169, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !2351
  unreachable, !dbg !2351

32:                                               ; preds = %30
  store i64 0, i64* %7, align 8, !dbg !2355
  br label %33, !dbg !2357

33:                                               ; preds = %57, %32
  %34 = load i64, i64* %7, align 8, !dbg !2358
  %35 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !2360
  %36 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %35, i32 0, i32 1, !dbg !2361
  %37 = load i64, i64* %36, align 8, !dbg !2361
  %38 = icmp ult i64 %34, %37, !dbg !2362
  br i1 %38, label %39, label %60, !dbg !2363

39:                                               ; preds = %33
  %40 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !2364
  %41 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !2366
  %42 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %41, i32 0, i32 0, !dbg !2367
  %43 = load %struct.trace_unit_s*, %struct.trace_unit_s** %42, align 8, !dbg !2367
  %44 = load i64, i64* %7, align 8, !dbg !2368
  %45 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %43, i64 %44, !dbg !2366
  %46 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %45, i32 0, i32 0, !dbg !2369
  %47 = load i64, i64* %46, align 8, !dbg !2369
  %48 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !2370
  %49 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %48, i32 0, i32 0, !dbg !2371
  %50 = load %struct.trace_unit_s*, %struct.trace_unit_s** %49, align 8, !dbg !2371
  %51 = load i64, i64* %7, align 8, !dbg !2372
  %52 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %50, i64 %51, !dbg !2370
  %53 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %52, i32 0, i32 1, !dbg !2373
  %54 = load i64, i64* %53, align 8, !dbg !2373
  %55 = load i8, i8* %6, align 1, !dbg !2374
  %56 = trunc i8 %55 to i1, !dbg !2374
  call void @_trace_add_or_rem_occurrences(%struct.trace_s* noundef %40, i64 noundef %47, i64 noundef %54, i1 noundef zeroext %56), !dbg !2375
  br label %57, !dbg !2376

57:                                               ; preds = %39
  %58 = load i64, i64* %7, align 8, !dbg !2377
  %59 = add i64 %58, 1, !dbg !2377
  store i64 %59, i64* %7, align 8, !dbg !2377
  br label %33, !dbg !2378, !llvm.loop !2379

60:                                               ; preds = %33
  ret void, !dbg !2381
}

declare i32 @printf(i8* noundef, ...) #4

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!176, !177, !178, !179, !180, !181, !182}
!llvm.ident = !{!183}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_tid", scope: !2, file: !107, line: 29, type: !29, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !13, globals: !53, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/libvsync/verify/simpleht/verify.c", directory: "/home/drc/git/libvsync/build/verify/simpleht", checksumkind: CSK_MD5, checksum: "fef1aee1945b19b211b0b629c38d4444")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "vsimpleht_ret_e", file: !6, line: 101, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/vsync/map/simpleht.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "71ff1b1ae473f406f97f96ca4e166070")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12}
!9 = !DIEnumerator(name: "VSIMPLEHT_RET_OK", value: 0)
!10 = !DIEnumerator(name: "VSIMPLEHT_RET_TBL_FULL", value: 1)
!11 = !DIEnumerator(name: "VSIMPLEHT_RET_KEY_EXISTS", value: 2)
!12 = !DIEnumerator(name: "VSIMPLEHT_RET_KEY_DNE", value: 3)
!13 = !{!14, !19, !22, !23, !29, !32, !49, !52}
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsize_t", file: !15, line: 45, baseType: !16)
!15 = !DIFile(filename: "vatomic/include/vsync/vtypes.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1f857806763227c02c7580f4adafe219")
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !17, line: 46, baseType: !18)
!17 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!18 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !15, line: 39, baseType: !20)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !21, line: 90, baseType: !18)
!21 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint8_t", file: !15, line: 35, baseType: !24)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !25, line: 24, baseType: !26)
!25 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !27, line: 38, baseType: !28)
!27 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!28 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !15, line: 37, baseType: !30)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !25, line: 26, baseType: !31)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !27, line: 42, baseType: !7)
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "run_info_t", file: !34, line: 46, baseType: !35)
!34 = !DIFile(filename: "test/include/test/thread_launcher.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "6c0e764b4717a6c250de9f7099604c45")
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !34, line: 41, size: 256, elements: !36)
!36 = !{!37, !40, !41, !44}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "t", scope: !35, file: !34, line: 42, baseType: !38, size: 64)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !39, line: 27, baseType: !18)
!39 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!40 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !35, file: !34, line: 43, baseType: !14, size: 64, offset: 64)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "assign_me_to_core", scope: !35, file: !34, line: 44, baseType: !42, size: 8, offset: 128)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !15, line: 46, baseType: !43)
!43 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "run_fun", scope: !35, file: !34, line: 45, baseType: !45, size: 64, offset: 192)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "thread_fun_t", file: !34, line: 39, baseType: !46)
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!47 = !DISubroutineType(types: !48)
!48 = !{!22, !22}
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint64_t", file: !15, line: 38, baseType: !50)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !25, line: 27, baseType: !51)
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !27, line: 45, baseType: !18)
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!53 = !{!0, !54, !60, !153, !172, !174}
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "g_keys", scope: !2, file: !56, line: 10, type: !57, isLocal: false, isDefinition: true)
!56 = !DIFile(filename: "verify/simpleht/test_case_same_bucket.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "33af331dfd60798b9e651099836b9dac")
!57 = !DICompositeType(tag: DW_TAG_array_type, baseType: !19, size: 192, elements: !58)
!58 = !{!59}
!59 = !DISubrange(count: 3)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "g_simpleht", scope: !2, file: !62, line: 35, type: !63, isLocal: true, isDefinition: true)
!62 = !DIFile(filename: "test/include/test/map/isimple.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "9bd6bf935fca0aec8816b4ad5eb860a6")
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_t", file: !6, line: 94, baseType: !64)
!64 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vsimpleht_s", file: !6, line: 83, size: 1472, elements: !65)
!65 = !{!66, !67, !79, !89, !94, !99, !100, !105}
!66 = !DIDerivedType(tag: DW_TAG_member, name: "capacity", scope: !64, file: !6, line: 84, baseType: !14, size: 64)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "entries", scope: !64, file: !6, line: 85, baseType: !68, size: 64, offset: 64)
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_entry_t", file: !6, line: 81, baseType: !70)
!70 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vsimpleht_entry_s", file: !6, line: 78, size: 128, elements: !71)
!71 = !{!72, !78}
!72 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !70, file: !6, line: 79, baseType: !73, size: 64, align: 64)
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomicptr_t", file: !74, line: 45, baseType: !75)
!74 = !DIFile(filename: "vatomic/include/vsync/atomic/internal/types.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "4649bfff29481cecec17d9044409fd19")
!75 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomicptr_s", file: !74, line: 43, size: 64, align: 64, elements: !76)
!76 = !{!77}
!77 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !75, file: !74, line: 44, baseType: !22, size: 64)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !70, file: !6, line: 80, baseType: !73, size: 64, align: 64, offset: 64)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "cmp_key", scope: !64, file: !6, line: 86, baseType: !80, size: 64, offset: 128)
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_cmp_key_t", file: !6, line: 74, baseType: !81)
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !82, size: 64)
!82 = !DISubroutineType(types: !83)
!83 = !{!84, !19, !19}
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "vint8_t", file: !15, line: 40, baseType: !85)
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !86, line: 24, baseType: !87)
!86 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "", checksumkind: CSK_MD5, checksum: "55bcbdc3159515ebd91d351a70d505f4")
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !27, line: 37, baseType: !88)
!88 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "hash_key", scope: !64, file: !6, line: 87, baseType: !90, size: 64, offset: 192)
!90 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_hash_key_t", file: !6, line: 75, baseType: !91)
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !92, size: 64)
!92 = !DISubroutineType(types: !93)
!93 = !{!49, !19}
!94 = !DIDerivedType(tag: DW_TAG_member, name: "cb_destroy", scope: !64, file: !6, line: 88, baseType: !95, size: 64, offset: 256)
!95 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_destroy_entry_t", file: !6, line: 76, baseType: !96)
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = !DISubroutineType(types: !98)
!98 = !{null, !22}
!99 = !DIDerivedType(tag: DW_TAG_member, name: "cleaning_threshold", scope: !64, file: !6, line: 90, baseType: !14, size: 64, offset: 320)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "deleted_count", scope: !64, file: !6, line: 91, baseType: !101, size: 64, align: 64, offset: 384)
!101 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomicsz_t", file: !74, line: 50, baseType: !102)
!102 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomicsz_s", file: !74, line: 48, size: 64, align: 64, elements: !103)
!103 = !{!104}
!104 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !102, file: !74, line: 49, baseType: !14, size: 64)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !64, file: !6, line: 92, baseType: !106, size: 1024, offset: 448)
!106 = !DIDerivedType(tag: DW_TAG_typedef, name: "rwlock_t", file: !107, line: 27, baseType: !108)
!107 = !DIFile(filename: "verify/include/verify/rwlock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "d22ae5b6c849e685e5cacdc91023be13")
!108 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "rwlock_s", file: !107, line: 23, size: 1024, elements: !109)
!109 = !{!110, !143, !148}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !108, file: !107, line: 24, baseType: !111, size: 960)
!111 = !DICompositeType(tag: DW_TAG_array_type, baseType: !112, size: 960, elements: !58)
!112 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !39, line: 72, baseType: !113)
!113 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !39, line: 67, size: 320, elements: !114)
!114 = !{!115, !136, !141}
!115 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !113, file: !39, line: 69, baseType: !116, size: 320)
!116 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !117, line: 22, size: 320, elements: !118)
!117 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "584baedd80e6041b81caae7f496091c0")
!118 = !{!119, !121, !122, !123, !124, !125, !127, !128}
!119 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !116, file: !117, line: 24, baseType: !120, size: 32)
!120 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !116, file: !117, line: 25, baseType: !7, size: 32, offset: 32)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !116, file: !117, line: 26, baseType: !120, size: 32, offset: 64)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !116, file: !117, line: 28, baseType: !7, size: 32, offset: 96)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !116, file: !117, line: 32, baseType: !120, size: 32, offset: 128)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !116, file: !117, line: 34, baseType: !126, size: 16, offset: 160)
!126 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !116, file: !117, line: 35, baseType: !126, size: 16, offset: 176)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !116, file: !117, line: 36, baseType: !129, size: 128, offset: 192)
!129 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !130, line: 55, baseType: !131)
!130 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "04c81e86d34dad9c99ad006d32e47a0d")
!131 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !130, line: 51, size: 128, elements: !132)
!132 = !{!133, !135}
!133 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !131, file: !130, line: 53, baseType: !134, size: 64)
!134 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !131, size: 64)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !131, file: !130, line: 54, baseType: !134, size: 64, offset: 64)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !113, file: !39, line: 70, baseType: !137, size: 320)
!137 = !DICompositeType(tag: DW_TAG_array_type, baseType: !138, size: 320, elements: !139)
!138 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!139 = !{!140}
!140 = !DISubrange(count: 40)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !113, file: !39, line: 71, baseType: !142, size: 64)
!142 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "writer_active", scope: !108, file: !107, line: 25, baseType: !144, size: 8, offset: 960)
!144 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic8_t", file: !74, line: 25, baseType: !145)
!145 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic8_s", file: !74, line: 23, size: 8, elements: !146)
!146 = !{!147}
!147 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !145, file: !74, line: 24, baseType: !23, size: 8)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "idx", scope: !108, file: !107, line: 26, baseType: !149, size: 32, align: 32, offset: 992)
!149 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !74, line: 35, baseType: !150)
!150 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !74, line: 33, size: 32, align: 32, elements: !151)
!151 = !{!152}
!152 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !150, file: !74, line: 34, baseType: !29, size: 32)
!153 = !DIGlobalVariableExpression(var: !154, expr: !DIExpression())
!154 = distinct !DIGlobalVariable(name: "g_add", scope: !2, file: !62, line: 33, type: !155, isLocal: true, isDefinition: true)
!155 = !DICompositeType(tag: DW_TAG_array_type, baseType: !156, size: 1024, elements: !170)
!156 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_t", file: !157, line: 29, baseType: !158)
!157 = !DIFile(filename: "test/include/test/trace_manager.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "5ba0f33a5901d8ee1ef7d1e8c3546fa0")
!158 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_s", file: !157, line: 24, size: 256, elements: !159)
!159 = !{!160, !167, !168, !169}
!160 = !DIDerivedType(tag: DW_TAG_member, name: "units", scope: !158, file: !157, line: 25, baseType: !161, size: 64)
!161 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !162, size: 64)
!162 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_unit_t", file: !157, line: 22, baseType: !163)
!163 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_unit_s", file: !157, line: 19, size: 128, elements: !164)
!164 = !{!165, !166}
!165 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !163, file: !157, line: 20, baseType: !19, size: 64)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !163, file: !157, line: 21, baseType: !14, size: 64, offset: 64)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !158, file: !157, line: 26, baseType: !14, size: 64, offset: 64)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "capacity", scope: !158, file: !157, line: 27, baseType: !14, size: 64, offset: 128)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "initialized", scope: !158, file: !157, line: 28, baseType: !42, size: 8, offset: 192)
!170 = !{!171}
!171 = !DISubrange(count: 4)
!172 = !DIGlobalVariableExpression(var: !173, expr: !DIExpression())
!173 = distinct !DIGlobalVariable(name: "g_rem", scope: !2, file: !62, line: 34, type: !155, isLocal: true, isDefinition: true)
!174 = !DIGlobalVariableExpression(var: !175, expr: !DIExpression())
!175 = distinct !DIGlobalVariable(name: "g_buff", scope: !2, file: !62, line: 36, type: !22, isLocal: true, isDefinition: true)
!176 = !{i32 7, !"Dwarf Version", i32 5}
!177 = !{i32 2, !"Debug Info Version", i32 3}
!178 = !{i32 1, !"wchar_size", i32 4}
!179 = !{i32 7, !"PIC Level", i32 2}
!180 = !{i32 7, !"PIE Level", i32 2}
!181 = !{i32 7, !"uwtable", i32 1}
!182 = !{i32 7, !"frame-pointer", i32 2}
!183 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!184 = distinct !DISubprogram(name: "pre", scope: !56, file: !56, line: 12, type: !185, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !187)
!185 = !DISubroutineType(types: !186)
!186 = !{null}
!187 = !{}
!188 = !DILocalVariable(name: "cnt", scope: !184, file: !56, line: 14, type: !14)
!189 = !DILocation(line: 14, column: 13, scope: !184)
!190 = !DILocalVariable(name: "k", scope: !184, file: !56, line: 15, type: !19)
!191 = !DILocation(line: 15, column: 16, scope: !184)
!192 = !DILocalVariable(name: "b", scope: !184, file: !56, line: 16, type: !19)
!193 = !DILocation(line: 16, column: 16, scope: !184)
!194 = !DILocation(line: 18, column: 5, scope: !184)
!195 = !DILocation(line: 18, column: 12, scope: !184)
!196 = !DILocation(line: 18, column: 16, scope: !184)
!197 = !DILocation(line: 19, column: 10, scope: !198)
!198 = distinct !DILexicalBlock(scope: !184, file: !56, line: 18, column: 23)
!199 = !DILocation(line: 20, column: 13, scope: !200)
!200 = distinct !DILexicalBlock(scope: !198, file: !56, line: 20, column: 13)
!201 = !DILocation(line: 20, column: 15, scope: !200)
!202 = !DILocation(line: 20, column: 40, scope: !200)
!203 = !DILocation(line: 20, column: 37, scope: !200)
!204 = !DILocation(line: 20, column: 13, scope: !198)
!205 = !DILocalVariable(name: "success", scope: !206, file: !56, line: 21, type: !42)
!206 = distinct !DILexicalBlock(scope: !200, file: !56, line: 20, column: 43)
!207 = !DILocation(line: 21, column: 21, scope: !206)
!208 = !DILocation(line: 21, column: 50, scope: !206)
!209 = !DILocation(line: 21, column: 53, scope: !206)
!210 = !DILocation(line: 21, column: 31, scope: !206)
!211 = !DILocation(line: 22, column: 13, scope: !212)
!212 = distinct !DILexicalBlock(scope: !213, file: !56, line: 22, column: 13)
!213 = distinct !DILexicalBlock(scope: !206, file: !56, line: 22, column: 13)
!214 = !DILocation(line: 22, column: 13, scope: !213)
!215 = !DILocation(line: 23, column: 27, scope: !206)
!216 = !DILocation(line: 23, column: 20, scope: !206)
!217 = !DILocation(line: 23, column: 13, scope: !206)
!218 = !DILocation(line: 23, column: 25, scope: !206)
!219 = !DILocation(line: 24, column: 16, scope: !206)
!220 = !DILocation(line: 25, column: 9, scope: !206)
!221 = distinct !{!221, !194, !222, !223}
!222 = !DILocation(line: 26, column: 5, scope: !184)
!223 = !{!"llvm.loop.mustprogress"}
!224 = !DILocation(line: 27, column: 1, scope: !184)
!225 = distinct !DISubprogram(name: "imap_add", scope: !62, file: !62, line: 140, type: !226, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!226 = !DISubroutineType(types: !227)
!227 = !{!42, !14, !19, !49}
!228 = !DILocalVariable(name: "tid", arg: 1, scope: !225, file: !62, line: 140, type: !14)
!229 = !DILocation(line: 140, column: 18, scope: !225)
!230 = !DILocalVariable(name: "key", arg: 2, scope: !225, file: !62, line: 140, type: !19)
!231 = !DILocation(line: 140, column: 34, scope: !225)
!232 = !DILocalVariable(name: "val", arg: 3, scope: !225, file: !62, line: 140, type: !49)
!233 = !DILocation(line: 140, column: 49, scope: !225)
!234 = !DILocalVariable(name: "data", scope: !225, file: !62, line: 142, type: !235)
!235 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !236, size: 64)
!236 = !DIDerivedType(tag: DW_TAG_typedef, name: "data_t", file: !62, line: 30, baseType: !237)
!237 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "data_s", file: !62, line: 27, size: 128, elements: !238)
!238 = !{!239, !240}
!239 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !237, file: !62, line: 28, baseType: !19, size: 64)
!240 = !DIDerivedType(tag: DW_TAG_member, name: "val", scope: !237, file: !62, line: 29, baseType: !49, size: 64, offset: 64)
!241 = !DILocation(line: 142, column: 13, scope: !225)
!242 = !DILocation(line: 142, column: 20, scope: !225)
!243 = !DILocation(line: 143, column: 20, scope: !225)
!244 = !DILocation(line: 143, column: 5, scope: !225)
!245 = !DILocation(line: 143, column: 11, scope: !225)
!246 = !DILocation(line: 143, column: 18, scope: !225)
!247 = !DILocation(line: 144, column: 20, scope: !225)
!248 = !DILocation(line: 144, column: 5, scope: !225)
!249 = !DILocation(line: 144, column: 11, scope: !225)
!250 = !DILocation(line: 144, column: 18, scope: !225)
!251 = !DILocalVariable(name: "added", scope: !225, file: !62, line: 145, type: !42)
!252 = !DILocation(line: 145, column: 13, scope: !225)
!253 = !DILocation(line: 146, column: 36, scope: !225)
!254 = !DILocation(line: 146, column: 42, scope: !225)
!255 = !DILocation(line: 146, column: 47, scope: !225)
!256 = !DILocation(line: 146, column: 9, scope: !225)
!257 = !DILocation(line: 146, column: 53, scope: !225)
!258 = !DILocation(line: 147, column: 9, scope: !259)
!259 = distinct !DILexicalBlock(scope: !225, file: !62, line: 147, column: 9)
!260 = !DILocation(line: 147, column: 9, scope: !225)
!261 = !DILocation(line: 148, column: 26, scope: !262)
!262 = distinct !DILexicalBlock(scope: !259, file: !62, line: 147, column: 16)
!263 = !DILocation(line: 148, column: 20, scope: !262)
!264 = !DILocation(line: 148, column: 32, scope: !262)
!265 = !DILocation(line: 148, column: 38, scope: !262)
!266 = !DILocation(line: 148, column: 9, scope: !262)
!267 = !DILocation(line: 149, column: 5, scope: !262)
!268 = !DILocation(line: 150, column: 14, scope: !269)
!269 = distinct !DILexicalBlock(scope: !259, file: !62, line: 149, column: 12)
!270 = !DILocation(line: 150, column: 9, scope: !269)
!271 = !DILocation(line: 152, column: 12, scope: !225)
!272 = !DILocation(line: 152, column: 5, scope: !225)
!273 = distinct !DISubprogram(name: "t0", scope: !56, file: !56, line: 29, type: !274, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !187)
!274 = !DISubroutineType(types: !275)
!275 = !{null, !14}
!276 = !DILocalVariable(name: "tid", arg: 1, scope: !273, file: !56, line: 29, type: !14)
!277 = !DILocation(line: 29, column: 12, scope: !273)
!278 = !DILocation(line: 31, column: 5, scope: !279)
!279 = distinct !DILexicalBlock(scope: !280, file: !56, line: 31, column: 5)
!280 = distinct !DILexicalBlock(scope: !273, file: !56, line: 31, column: 5)
!281 = !DILocation(line: 31, column: 5, scope: !280)
!282 = !DILocalVariable(name: "success", scope: !273, file: !56, line: 32, type: !42)
!283 = !DILocation(line: 32, column: 13, scope: !273)
!284 = !DILocation(line: 32, column: 32, scope: !273)
!285 = !DILocation(line: 32, column: 44, scope: !273)
!286 = !DILocation(line: 32, column: 37, scope: !273)
!287 = !DILocation(line: 32, column: 57, scope: !273)
!288 = !DILocation(line: 32, column: 50, scope: !273)
!289 = !DILocation(line: 32, column: 23, scope: !273)
!290 = !DILocation(line: 33, column: 5, scope: !291)
!291 = distinct !DILexicalBlock(scope: !292, file: !56, line: 33, column: 5)
!292 = distinct !DILexicalBlock(scope: !273, file: !56, line: 33, column: 5)
!293 = !DILocation(line: 33, column: 5, scope: !292)
!294 = !DILocation(line: 34, column: 1, scope: !273)
!295 = distinct !DISubprogram(name: "t1", scope: !56, file: !56, line: 36, type: !274, scopeLine: 37, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !187)
!296 = !DILocalVariable(name: "tid", arg: 1, scope: !295, file: !56, line: 36, type: !14)
!297 = !DILocation(line: 36, column: 12, scope: !295)
!298 = !DILocation(line: 38, column: 5, scope: !299)
!299 = distinct !DILexicalBlock(scope: !300, file: !56, line: 38, column: 5)
!300 = distinct !DILexicalBlock(scope: !295, file: !56, line: 38, column: 5)
!301 = !DILocation(line: 38, column: 5, scope: !300)
!302 = !DILocalVariable(name: "data", scope: !295, file: !56, line: 39, type: !235)
!303 = !DILocation(line: 39, column: 13, scope: !295)
!304 = !DILocation(line: 39, column: 29, scope: !295)
!305 = !DILocation(line: 39, column: 41, scope: !295)
!306 = !DILocation(line: 39, column: 34, scope: !295)
!307 = !DILocation(line: 39, column: 20, scope: !295)
!308 = !DILocation(line: 40, column: 5, scope: !309)
!309 = distinct !DILexicalBlock(scope: !310, file: !56, line: 40, column: 5)
!310 = distinct !DILexicalBlock(scope: !295, file: !56, line: 40, column: 5)
!311 = !DILocation(line: 40, column: 5, scope: !310)
!312 = !DILocation(line: 41, column: 1, scope: !295)
!313 = distinct !DISubprogram(name: "imap_get", scope: !62, file: !62, line: 166, type: !314, scopeLine: 167, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!314 = !DISubroutineType(types: !315)
!315 = !{!22, !14, !19}
!316 = !DILocalVariable(name: "tid", arg: 1, scope: !313, file: !62, line: 166, type: !14)
!317 = !DILocation(line: 166, column: 18, scope: !313)
!318 = !DILocalVariable(name: "key", arg: 2, scope: !313, file: !62, line: 166, type: !19)
!319 = !DILocation(line: 166, column: 34, scope: !313)
!320 = !DILocation(line: 168, column: 5, scope: !313)
!321 = !DILocation(line: 168, column: 5, scope: !322)
!322 = distinct !DILexicalBlock(scope: !313, file: !62, line: 168, column: 5)
!323 = !DILocation(line: 168, column: 5, scope: !324)
!324 = distinct !DILexicalBlock(scope: !322, file: !62, line: 168, column: 5)
!325 = !DILocation(line: 168, column: 5, scope: !326)
!326 = distinct !DILexicalBlock(scope: !324, file: !62, line: 168, column: 5)
!327 = !DILocalVariable(name: "data", scope: !313, file: !62, line: 169, type: !235)
!328 = !DILocation(line: 169, column: 13, scope: !313)
!329 = !DILocation(line: 169, column: 47, scope: !313)
!330 = !DILocation(line: 169, column: 20, scope: !313)
!331 = !DILocation(line: 170, column: 9, scope: !332)
!332 = distinct !DILexicalBlock(scope: !313, file: !62, line: 170, column: 9)
!333 = !DILocation(line: 170, column: 9, scope: !313)
!334 = !DILocation(line: 171, column: 9, scope: !335)
!335 = distinct !DILexicalBlock(scope: !336, file: !62, line: 171, column: 9)
!336 = distinct !DILexicalBlock(scope: !337, file: !62, line: 171, column: 9)
!337 = distinct !DILexicalBlock(scope: !332, file: !62, line: 170, column: 15)
!338 = !DILocation(line: 171, column: 9, scope: !336)
!339 = !DILocation(line: 172, column: 5, scope: !337)
!340 = !DILocation(line: 173, column: 12, scope: !313)
!341 = !DILocation(line: 173, column: 5, scope: !313)
!342 = distinct !DISubprogram(name: "t2", scope: !56, file: !56, line: 43, type: !274, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !187)
!343 = !DILocalVariable(name: "tid", arg: 1, scope: !342, file: !56, line: 43, type: !14)
!344 = !DILocation(line: 43, column: 12, scope: !342)
!345 = !DILocation(line: 45, column: 5, scope: !346)
!346 = distinct !DILexicalBlock(scope: !347, file: !56, line: 45, column: 5)
!347 = distinct !DILexicalBlock(scope: !342, file: !56, line: 45, column: 5)
!348 = !DILocation(line: 45, column: 5, scope: !347)
!349 = !DILocalVariable(name: "success", scope: !342, file: !56, line: 46, type: !42)
!350 = !DILocation(line: 46, column: 13, scope: !342)
!351 = !DILocation(line: 46, column: 32, scope: !342)
!352 = !DILocation(line: 46, column: 44, scope: !342)
!353 = !DILocation(line: 46, column: 37, scope: !342)
!354 = !DILocation(line: 46, column: 23, scope: !342)
!355 = !DILocation(line: 47, column: 5, scope: !356)
!356 = distinct !DILexicalBlock(scope: !357, file: !56, line: 47, column: 5)
!357 = distinct !DILexicalBlock(scope: !342, file: !56, line: 47, column: 5)
!358 = !DILocation(line: 47, column: 5, scope: !357)
!359 = !DILocation(line: 48, column: 1, scope: !342)
!360 = distinct !DISubprogram(name: "imap_rem", scope: !62, file: !62, line: 156, type: !361, scopeLine: 157, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!361 = !DISubroutineType(types: !362)
!362 = !{!42, !14, !19}
!363 = !DILocalVariable(name: "tid", arg: 1, scope: !360, file: !62, line: 156, type: !14)
!364 = !DILocation(line: 156, column: 18, scope: !360)
!365 = !DILocalVariable(name: "key", arg: 2, scope: !360, file: !62, line: 156, type: !19)
!366 = !DILocation(line: 156, column: 34, scope: !360)
!367 = !DILocalVariable(name: "removed", scope: !360, file: !62, line: 158, type: !42)
!368 = !DILocation(line: 158, column: 13, scope: !360)
!369 = !DILocation(line: 158, column: 53, scope: !360)
!370 = !DILocation(line: 158, column: 23, scope: !360)
!371 = !DILocation(line: 158, column: 58, scope: !360)
!372 = !DILocation(line: 159, column: 9, scope: !373)
!373 = distinct !DILexicalBlock(scope: !360, file: !62, line: 159, column: 9)
!374 = !DILocation(line: 159, column: 9, scope: !360)
!375 = !DILocation(line: 160, column: 26, scope: !376)
!376 = distinct !DILexicalBlock(scope: !373, file: !62, line: 159, column: 18)
!377 = !DILocation(line: 160, column: 20, scope: !376)
!378 = !DILocation(line: 160, column: 32, scope: !376)
!379 = !DILocation(line: 160, column: 9, scope: !376)
!380 = !DILocation(line: 161, column: 5, scope: !376)
!381 = !DILocation(line: 162, column: 12, scope: !360)
!382 = !DILocation(line: 162, column: 5, scope: !360)
!383 = distinct !DISubprogram(name: "post", scope: !56, file: !56, line: 50, type: !185, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !187)
!384 = !DILocation(line: 52, column: 1, scope: !383)
!385 = distinct !DISubprogram(name: "run", scope: !386, file: !386, line: 94, type: !47, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !187)
!386 = !DIFile(filename: "test/include/test/boilerplate/test_case.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "ec4420aa4ca09b8f4298c137e9e77071")
!387 = !DILocalVariable(name: "args", arg: 1, scope: !385, file: !386, line: 94, type: !22)
!388 = !DILocation(line: 94, column: 11, scope: !385)
!389 = !DILocalVariable(name: "tid", scope: !385, file: !386, line: 96, type: !14)
!390 = !DILocation(line: 96, column: 13, scope: !385)
!391 = !DILocation(line: 96, column: 40, scope: !385)
!392 = !DILocation(line: 96, column: 28, scope: !385)
!393 = !DILocation(line: 97, column: 5, scope: !394)
!394 = distinct !DILexicalBlock(scope: !395, file: !386, line: 97, column: 5)
!395 = distinct !DILexicalBlock(scope: !385, file: !386, line: 97, column: 5)
!396 = !DILocation(line: 97, column: 5, scope: !395)
!397 = !DILocation(line: 99, column: 9, scope: !385)
!398 = !DILocation(line: 99, column: 5, scope: !385)
!399 = !DILocation(line: 100, column: 13, scope: !385)
!400 = !DILocation(line: 100, column: 5, scope: !385)
!401 = !DILocation(line: 102, column: 16, scope: !402)
!402 = distinct !DILexicalBlock(scope: !385, file: !386, line: 100, column: 18)
!403 = !DILocation(line: 102, column: 13, scope: !402)
!404 = !DILocation(line: 103, column: 13, scope: !402)
!405 = !DILocation(line: 105, column: 16, scope: !402)
!406 = !DILocation(line: 105, column: 13, scope: !402)
!407 = !DILocation(line: 106, column: 13, scope: !402)
!408 = !DILocation(line: 108, column: 16, scope: !402)
!409 = !DILocation(line: 108, column: 13, scope: !402)
!410 = !DILocation(line: 109, column: 13, scope: !402)
!411 = !DILocation(line: 116, column: 13, scope: !402)
!412 = !DILocation(line: 118, column: 11, scope: !385)
!413 = !DILocation(line: 118, column: 5, scope: !385)
!414 = !DILocation(line: 119, column: 5, scope: !385)
!415 = distinct !DISubprogram(name: "reg", scope: !416, file: !416, line: 11, type: !274, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !187)
!416 = !DIFile(filename: "verify/simpleht/verify.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "fef1aee1945b19b211b0b629c38d4444")
!417 = !DILocalVariable(name: "tid", arg: 1, scope: !415, file: !416, line: 11, type: !14)
!418 = !DILocation(line: 11, column: 13, scope: !415)
!419 = !DILocation(line: 13, column: 14, scope: !415)
!420 = !DILocation(line: 13, column: 5, scope: !415)
!421 = !DILocation(line: 14, column: 1, scope: !415)
!422 = distinct !DISubprogram(name: "dereg", scope: !416, file: !416, line: 16, type: !274, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !187)
!423 = !DILocalVariable(name: "tid", arg: 1, scope: !422, file: !416, line: 16, type: !14)
!424 = !DILocation(line: 16, column: 15, scope: !422)
!425 = !DILocation(line: 18, column: 16, scope: !422)
!426 = !DILocation(line: 18, column: 5, scope: !422)
!427 = !DILocation(line: 19, column: 1, scope: !422)
!428 = distinct !DISubprogram(name: "tc", scope: !386, file: !386, line: 129, type: !185, scopeLine: 130, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !187)
!429 = !DILocation(line: 131, column: 5, scope: !428)
!430 = !DILocation(line: 132, column: 5, scope: !428)
!431 = !DILocation(line: 133, column: 5, scope: !428)
!432 = !DILocation(line: 134, column: 5, scope: !428)
!433 = !DILocation(line: 135, column: 5, scope: !428)
!434 = !DILocation(line: 136, column: 1, scope: !428)
!435 = distinct !DISubprogram(name: "init", scope: !416, file: !416, line: 22, type: !185, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !187)
!436 = !DILocation(line: 24, column: 5, scope: !435)
!437 = !DILocation(line: 25, column: 1, scope: !435)
!438 = distinct !DISubprogram(name: "launch_threads", scope: !34, file: !34, line: 119, type: !439, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!439 = !DISubroutineType(types: !440)
!440 = !{null, !14, !45}
!441 = !DILocalVariable(name: "thread_count", arg: 1, scope: !438, file: !34, line: 119, type: !14)
!442 = !DILocation(line: 119, column: 24, scope: !438)
!443 = !DILocalVariable(name: "fun", arg: 2, scope: !438, file: !34, line: 119, type: !45)
!444 = !DILocation(line: 119, column: 51, scope: !438)
!445 = !DILocalVariable(name: "threads", scope: !438, file: !34, line: 121, type: !32)
!446 = !DILocation(line: 121, column: 17, scope: !438)
!447 = !DILocation(line: 121, column: 55, scope: !438)
!448 = !DILocation(line: 121, column: 53, scope: !438)
!449 = !DILocation(line: 121, column: 27, scope: !438)
!450 = !DILocation(line: 123, column: 20, scope: !438)
!451 = !DILocation(line: 123, column: 29, scope: !438)
!452 = !DILocation(line: 123, column: 43, scope: !438)
!453 = !DILocation(line: 123, column: 5, scope: !438)
!454 = !DILocation(line: 125, column: 19, scope: !438)
!455 = !DILocation(line: 125, column: 28, scope: !438)
!456 = !DILocation(line: 125, column: 5, scope: !438)
!457 = !DILocation(line: 127, column: 10, scope: !438)
!458 = !DILocation(line: 127, column: 5, scope: !438)
!459 = !DILocation(line: 128, column: 1, scope: !438)
!460 = distinct !DISubprogram(name: "fini", scope: !416, file: !416, line: 27, type: !185, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !187)
!461 = !DILocation(line: 29, column: 5, scope: !460)
!462 = !DILocation(line: 30, column: 1, scope: !460)
!463 = distinct !DISubprogram(name: "imap_reg", scope: !62, file: !62, line: 177, type: !274, scopeLine: 178, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!464 = !DILocalVariable(name: "tid", arg: 1, scope: !463, file: !62, line: 177, type: !14)
!465 = !DILocation(line: 177, column: 18, scope: !463)
!466 = !DILocation(line: 179, column: 5, scope: !463)
!467 = !DILocation(line: 179, column: 5, scope: !468)
!468 = distinct !DILexicalBlock(scope: !463, file: !62, line: 179, column: 5)
!469 = !DILocation(line: 179, column: 5, scope: !470)
!470 = distinct !DILexicalBlock(scope: !468, file: !62, line: 179, column: 5)
!471 = !DILocation(line: 179, column: 5, scope: !472)
!472 = distinct !DILexicalBlock(scope: !470, file: !62, line: 179, column: 5)
!473 = !DILocation(line: 180, column: 5, scope: !463)
!474 = !DILocation(line: 181, column: 1, scope: !463)
!475 = distinct !DISubprogram(name: "imap_dereg", scope: !62, file: !62, line: 184, type: !274, scopeLine: 185, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!476 = !DILocalVariable(name: "tid", arg: 1, scope: !475, file: !62, line: 184, type: !14)
!477 = !DILocation(line: 184, column: 20, scope: !475)
!478 = !DILocation(line: 186, column: 5, scope: !475)
!479 = !DILocation(line: 186, column: 5, scope: !480)
!480 = distinct !DILexicalBlock(scope: !475, file: !62, line: 186, column: 5)
!481 = !DILocation(line: 186, column: 5, scope: !482)
!482 = distinct !DILexicalBlock(scope: !480, file: !62, line: 186, column: 5)
!483 = !DILocation(line: 186, column: 5, scope: !484)
!484 = distinct !DILexicalBlock(scope: !482, file: !62, line: 186, column: 5)
!485 = !DILocation(line: 187, column: 5, scope: !475)
!486 = !DILocation(line: 188, column: 1, scope: !475)
!487 = distinct !DISubprogram(name: "imap_init", scope: !62, file: !62, line: 114, type: !185, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!488 = !DILocalVariable(name: "sz", scope: !487, file: !62, line: 116, type: !14)
!489 = !DILocation(line: 116, column: 13, scope: !487)
!490 = !DILocation(line: 116, column: 20, scope: !487)
!491 = !DILocalVariable(name: "g_buff", scope: !487, file: !62, line: 117, type: !22)
!492 = !DILocation(line: 117, column: 11, scope: !487)
!493 = !DILocation(line: 117, column: 27, scope: !487)
!494 = !DILocation(line: 117, column: 20, scope: !487)
!495 = !DILocation(line: 119, column: 33, scope: !487)
!496 = !DILocation(line: 119, column: 5, scope: !487)
!497 = !DILocalVariable(name: "i", scope: !498, file: !62, line: 122, type: !14)
!498 = distinct !DILexicalBlock(scope: !487, file: !62, line: 122, column: 5)
!499 = !DILocation(line: 122, column: 18, scope: !498)
!500 = !DILocation(line: 122, column: 10, scope: !498)
!501 = !DILocation(line: 122, column: 25, scope: !502)
!502 = distinct !DILexicalBlock(scope: !498, file: !62, line: 122, column: 5)
!503 = !DILocation(line: 122, column: 27, scope: !502)
!504 = !DILocation(line: 122, column: 5, scope: !498)
!505 = !DILocation(line: 123, column: 27, scope: !506)
!506 = distinct !DILexicalBlock(scope: !502, file: !62, line: 122, column: 43)
!507 = !DILocation(line: 123, column: 21, scope: !506)
!508 = !DILocation(line: 123, column: 9, scope: !506)
!509 = !DILocation(line: 124, column: 27, scope: !506)
!510 = !DILocation(line: 124, column: 21, scope: !506)
!511 = !DILocation(line: 124, column: 9, scope: !506)
!512 = !DILocation(line: 125, column: 5, scope: !506)
!513 = !DILocation(line: 122, column: 39, scope: !502)
!514 = !DILocation(line: 122, column: 5, scope: !502)
!515 = distinct !{!515, !504, !516, !223}
!516 = !DILocation(line: 125, column: 5, scope: !498)
!517 = !DILocation(line: 126, column: 1, scope: !487)
!518 = distinct !DISubprogram(name: "imap_destroy", scope: !62, file: !62, line: 128, type: !185, scopeLine: 129, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!519 = !DILocation(line: 130, column: 5, scope: !518)
!520 = !DILocalVariable(name: "i", scope: !521, file: !62, line: 131, type: !14)
!521 = distinct !DILexicalBlock(scope: !518, file: !62, line: 131, column: 5)
!522 = !DILocation(line: 131, column: 18, scope: !521)
!523 = !DILocation(line: 131, column: 10, scope: !521)
!524 = !DILocation(line: 131, column: 25, scope: !525)
!525 = distinct !DILexicalBlock(scope: !521, file: !62, line: 131, column: 5)
!526 = !DILocation(line: 131, column: 27, scope: !525)
!527 = !DILocation(line: 131, column: 5, scope: !521)
!528 = !DILocation(line: 132, column: 30, scope: !529)
!529 = distinct !DILexicalBlock(scope: !525, file: !62, line: 131, column: 43)
!530 = !DILocation(line: 132, column: 24, scope: !529)
!531 = !DILocation(line: 132, column: 9, scope: !529)
!532 = !DILocation(line: 133, column: 30, scope: !529)
!533 = !DILocation(line: 133, column: 24, scope: !529)
!534 = !DILocation(line: 133, column: 9, scope: !529)
!535 = !DILocation(line: 134, column: 5, scope: !529)
!536 = !DILocation(line: 131, column: 39, scope: !525)
!537 = !DILocation(line: 131, column: 5, scope: !525)
!538 = distinct !{!538, !527, !539, !223}
!539 = !DILocation(line: 134, column: 5, scope: !521)
!540 = !DILocation(line: 135, column: 5, scope: !518)
!541 = !DILocation(line: 136, column: 10, scope: !518)
!542 = !DILocation(line: 136, column: 5, scope: !518)
!543 = !DILocation(line: 137, column: 12, scope: !518)
!544 = !DILocation(line: 138, column: 1, scope: !518)
!545 = distinct !DISubprogram(name: "main", scope: !416, file: !416, line: 33, type: !546, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !187)
!546 = !DISubroutineType(types: !547)
!547 = !{!120}
!548 = !DILocation(line: 35, column: 5, scope: !545)
!549 = !DILocation(line: 36, column: 5, scope: !545)
!550 = distinct !DISubprogram(name: "vsimpleht_add", scope: !6, file: !6, line: 241, type: !551, scopeLine: 242, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!551 = !DISubroutineType(types: !552)
!552 = !{!553, !554, !19, !22}
!553 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_ret_t", file: !6, line: 106, baseType: !5)
!554 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!555 = !DILocalVariable(name: "tbl", arg: 1, scope: !550, file: !6, line: 241, type: !554)
!556 = !DILocation(line: 241, column: 28, scope: !550)
!557 = !DILocalVariable(name: "key", arg: 2, scope: !550, file: !6, line: 241, type: !19)
!558 = !DILocation(line: 241, column: 44, scope: !550)
!559 = !DILocalVariable(name: "value", arg: 3, scope: !550, file: !6, line: 241, type: !22)
!560 = !DILocation(line: 241, column: 55, scope: !550)
!561 = !DILocation(line: 243, column: 5, scope: !562)
!562 = distinct !DILexicalBlock(scope: !563, file: !6, line: 243, column: 5)
!563 = distinct !DILexicalBlock(scope: !550, file: !6, line: 243, column: 5)
!564 = !DILocation(line: 243, column: 5, scope: !563)
!565 = !DILocation(line: 244, column: 5, scope: !566)
!566 = distinct !DILexicalBlock(scope: !567, file: !6, line: 244, column: 5)
!567 = distinct !DILexicalBlock(scope: !550, file: !6, line: 244, column: 5)
!568 = !DILocation(line: 244, column: 5, scope: !567)
!569 = !DILocation(line: 245, column: 38, scope: !550)
!570 = !DILocation(line: 245, column: 5, scope: !550)
!571 = !DILocation(line: 246, column: 27, scope: !550)
!572 = !DILocation(line: 246, column: 32, scope: !550)
!573 = !DILocation(line: 246, column: 37, scope: !550)
!574 = !DILocation(line: 246, column: 12, scope: !550)
!575 = !DILocation(line: 246, column: 5, scope: !550)
!576 = distinct !DISubprogram(name: "trace_add", scope: !157, file: !157, line: 153, type: !577, scopeLine: 154, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!577 = !DISubroutineType(types: !578)
!578 = !{null, !579, !19}
!579 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !156, size: 64)
!580 = !DILocalVariable(name: "trace", arg: 1, scope: !576, file: !157, line: 153, type: !579)
!581 = !DILocation(line: 153, column: 20, scope: !576)
!582 = !DILocalVariable(name: "key", arg: 2, scope: !576, file: !157, line: 153, type: !19)
!583 = !DILocation(line: 153, column: 38, scope: !576)
!584 = !DILocation(line: 155, column: 5, scope: !585)
!585 = distinct !DILexicalBlock(scope: !586, file: !157, line: 155, column: 5)
!586 = distinct !DILexicalBlock(scope: !576, file: !157, line: 155, column: 5)
!587 = !DILocation(line: 155, column: 5, scope: !586)
!588 = !DILocation(line: 156, column: 5, scope: !589)
!589 = distinct !DILexicalBlock(scope: !590, file: !157, line: 156, column: 5)
!590 = distinct !DILexicalBlock(scope: !576, file: !157, line: 156, column: 5)
!591 = !DILocation(line: 156, column: 5, scope: !590)
!592 = !DILocation(line: 157, column: 35, scope: !576)
!593 = !DILocation(line: 157, column: 42, scope: !576)
!594 = !DILocation(line: 157, column: 5, scope: !576)
!595 = !DILocation(line: 158, column: 1, scope: !576)
!596 = distinct !DISubprogram(name: "_vsimpleht_give_cleanup_a_chance", scope: !6, file: !6, line: 479, type: !597, scopeLine: 480, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!597 = !DISubroutineType(types: !598)
!598 = !{null, !554}
!599 = !DILocalVariable(name: "tbl", arg: 1, scope: !596, file: !6, line: 479, type: !554)
!600 = !DILocation(line: 479, column: 47, scope: !596)
!601 = !DILocation(line: 484, column: 36, scope: !602)
!602 = distinct !DILexicalBlock(scope: !596, file: !6, line: 484, column: 9)
!603 = !DILocation(line: 484, column: 41, scope: !602)
!604 = !DILocation(line: 484, column: 9, scope: !602)
!605 = !DILocation(line: 484, column: 9, scope: !596)
!606 = !DILocation(line: 485, column: 9, scope: !607)
!607 = distinct !DILexicalBlock(scope: !608, file: !6, line: 485, column: 9)
!608 = distinct !DILexicalBlock(scope: !609, file: !6, line: 485, column: 9)
!609 = distinct !DILexicalBlock(scope: !602, file: !6, line: 484, column: 48)
!610 = !DILocation(line: 485, column: 9, scope: !608)
!611 = !DILocation(line: 488, column: 30, scope: !609)
!612 = !DILocation(line: 488, column: 35, scope: !609)
!613 = !DILocation(line: 488, column: 9, scope: !609)
!614 = !DILocation(line: 489, column: 30, scope: !609)
!615 = !DILocation(line: 489, column: 35, scope: !609)
!616 = !DILocation(line: 489, column: 9, scope: !609)
!617 = !DILocation(line: 490, column: 5, scope: !609)
!618 = !DILocation(line: 492, column: 1, scope: !596)
!619 = distinct !DISubprogram(name: "_vsimpleht_add", scope: !6, file: !6, line: 416, type: !551, scopeLine: 417, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!620 = !DILocalVariable(name: "tbl", arg: 1, scope: !619, file: !6, line: 416, type: !554)
!621 = !DILocation(line: 416, column: 29, scope: !619)
!622 = !DILocalVariable(name: "key", arg: 2, scope: !619, file: !6, line: 416, type: !19)
!623 = !DILocation(line: 416, column: 45, scope: !619)
!624 = !DILocalVariable(name: "value", arg: 3, scope: !619, file: !6, line: 416, type: !22)
!625 = !DILocation(line: 416, column: 56, scope: !619)
!626 = !DILocalVariable(name: "index", scope: !619, file: !6, line: 418, type: !14)
!627 = !DILocation(line: 418, column: 13, scope: !619)
!628 = !DILocalVariable(name: "probed_key", scope: !619, file: !6, line: 419, type: !19)
!629 = !DILocation(line: 419, column: 16, scope: !619)
!630 = !DILocalVariable(name: "val", scope: !619, file: !6, line: 420, type: !22)
!631 = !DILocation(line: 420, column: 11, scope: !619)
!632 = !DILocalVariable(name: "cnt", scope: !619, file: !6, line: 421, type: !14)
!633 = !DILocation(line: 421, column: 13, scope: !619)
!634 = !DILocation(line: 423, column: 5, scope: !635)
!635 = distinct !DILexicalBlock(scope: !636, file: !6, line: 423, column: 5)
!636 = distinct !DILexicalBlock(scope: !619, file: !6, line: 423, column: 5)
!637 = !DILocation(line: 423, column: 5, scope: !636)
!638 = !DILocation(line: 424, column: 5, scope: !639)
!639 = distinct !DILexicalBlock(scope: !640, file: !6, line: 424, column: 5)
!640 = distinct !DILexicalBlock(scope: !619, file: !6, line: 424, column: 5)
!641 = !DILocation(line: 424, column: 5, scope: !640)
!642 = !DILocation(line: 428, column: 18, scope: !643)
!643 = distinct !DILexicalBlock(scope: !619, file: !6, line: 428, column: 5)
!644 = !DILocation(line: 428, column: 23, scope: !643)
!645 = !DILocation(line: 428, column: 32, scope: !643)
!646 = !DILocation(line: 428, column: 16, scope: !643)
!647 = !DILocation(line: 428, column: 10, scope: !643)
!648 = !DILocation(line: 428, column: 38, scope: !649)
!649 = distinct !DILexicalBlock(scope: !643, file: !6, line: 428, column: 5)
!650 = !DILocation(line: 428, column: 44, scope: !649)
!651 = !DILocation(line: 428, column: 49, scope: !649)
!652 = !DILocation(line: 428, column: 42, scope: !649)
!653 = !DILocation(line: 428, column: 5, scope: !643)
!654 = !DILocation(line: 430, column: 18, scope: !655)
!655 = distinct !DILexicalBlock(scope: !649, file: !6, line: 428, column: 75)
!656 = !DILocation(line: 430, column: 23, scope: !655)
!657 = !DILocation(line: 430, column: 32, scope: !655)
!658 = !DILocation(line: 430, column: 15, scope: !655)
!659 = !DILocation(line: 431, column: 9, scope: !660)
!660 = distinct !DILexicalBlock(scope: !661, file: !6, line: 431, column: 9)
!661 = distinct !DILexicalBlock(scope: !655, file: !6, line: 431, column: 9)
!662 = !DILocation(line: 431, column: 9, scope: !661)
!663 = !DILocation(line: 433, column: 51, scope: !655)
!664 = !DILocation(line: 433, column: 56, scope: !655)
!665 = !DILocation(line: 433, column: 64, scope: !655)
!666 = !DILocation(line: 433, column: 71, scope: !655)
!667 = !DILocation(line: 433, column: 34, scope: !655)
!668 = !DILocation(line: 433, column: 22, scope: !655)
!669 = !DILocation(line: 433, column: 20, scope: !655)
!670 = !DILocation(line: 438, column: 13, scope: !671)
!671 = distinct !DILexicalBlock(scope: !655, file: !6, line: 438, column: 13)
!672 = !DILocation(line: 438, column: 24, scope: !671)
!673 = !DILocation(line: 438, column: 13, scope: !655)
!674 = !DILocation(line: 440, column: 18, scope: !675)
!675 = distinct !DILexicalBlock(scope: !671, file: !6, line: 438, column: 30)
!676 = !DILocation(line: 440, column: 23, scope: !675)
!677 = !DILocation(line: 440, column: 31, scope: !675)
!678 = !DILocation(line: 440, column: 38, scope: !675)
!679 = !DILocation(line: 440, column: 57, scope: !675)
!680 = !DILocation(line: 440, column: 49, scope: !675)
!681 = !DILocation(line: 439, column: 38, scope: !675)
!682 = !DILocation(line: 439, column: 26, scope: !675)
!683 = !DILocation(line: 439, column: 24, scope: !675)
!684 = !DILocation(line: 442, column: 17, scope: !685)
!685 = distinct !DILexicalBlock(scope: !675, file: !6, line: 442, column: 17)
!686 = !DILocation(line: 442, column: 28, scope: !685)
!687 = !DILocation(line: 442, column: 33, scope: !685)
!688 = !DILocation(line: 442, column: 36, scope: !685)
!689 = !DILocation(line: 442, column: 41, scope: !685)
!690 = !DILocation(line: 442, column: 49, scope: !685)
!691 = !DILocation(line: 442, column: 54, scope: !685)
!692 = !DILocation(line: 442, column: 66, scope: !685)
!693 = !DILocation(line: 442, column: 17, scope: !675)
!694 = !DILocation(line: 443, column: 17, scope: !695)
!695 = distinct !DILexicalBlock(scope: !685, file: !6, line: 442, column: 72)
!696 = !DILocation(line: 445, column: 9, scope: !675)
!697 = !DILocation(line: 445, column: 20, scope: !698)
!698 = distinct !DILexicalBlock(scope: !671, file: !6, line: 445, column: 20)
!699 = !DILocation(line: 445, column: 25, scope: !698)
!700 = !DILocation(line: 445, column: 33, scope: !698)
!701 = !DILocation(line: 445, column: 38, scope: !698)
!702 = !DILocation(line: 445, column: 50, scope: !698)
!703 = !DILocation(line: 445, column: 20, scope: !671)
!704 = !DILocation(line: 448, column: 13, scope: !705)
!705 = distinct !DILexicalBlock(scope: !698, file: !6, line: 445, column: 56)
!706 = !DILocation(line: 450, column: 9, scope: !707)
!707 = distinct !DILexicalBlock(scope: !708, file: !6, line: 450, column: 9)
!708 = distinct !DILexicalBlock(scope: !655, file: !6, line: 450, column: 9)
!709 = !DILocation(line: 450, column: 9, scope: !708)
!710 = !DILocation(line: 465, column: 35, scope: !655)
!711 = !DILocation(line: 465, column: 40, scope: !655)
!712 = !DILocation(line: 465, column: 48, scope: !655)
!713 = !DILocation(line: 465, column: 55, scope: !655)
!714 = !DILocation(line: 465, column: 68, scope: !655)
!715 = !DILocation(line: 465, column: 15, scope: !655)
!716 = !DILocation(line: 465, column: 13, scope: !655)
!717 = !DILocation(line: 466, column: 17, scope: !655)
!718 = !DILocation(line: 466, column: 21, scope: !655)
!719 = !DILocation(line: 466, column: 16, scope: !655)
!720 = !DILocation(line: 466, column: 9, scope: !655)
!721 = !DILocation(line: 428, column: 62, scope: !649)
!722 = !DILocation(line: 428, column: 71, scope: !649)
!723 = !DILocation(line: 428, column: 5, scope: !649)
!724 = distinct !{!724, !653, !725, !223}
!725 = !DILocation(line: 467, column: 5, scope: !643)
!726 = !DILocation(line: 468, column: 5, scope: !619)
!727 = !DILocation(line: 469, column: 1, scope: !619)
!728 = distinct !DISubprogram(name: "rwlock_acquired_by_writer", scope: !107, file: !107, line: 99, type: !729, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!729 = !DISubroutineType(types: !730)
!730 = !{!42, !731}
!731 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !106, size: 64)
!732 = !DILocalVariable(name: "l", arg: 1, scope: !728, file: !107, line: 99, type: !731)
!733 = !DILocation(line: 99, column: 37, scope: !728)
!734 = !DILocation(line: 101, column: 31, scope: !728)
!735 = !DILocation(line: 101, column: 34, scope: !728)
!736 = !DILocation(line: 101, column: 12, scope: !728)
!737 = !DILocation(line: 101, column: 49, scope: !728)
!738 = !DILocation(line: 101, column: 5, scope: !728)
!739 = distinct !DISubprogram(name: "rwlock_acquired_by_readers", scope: !107, file: !107, line: 105, type: !729, scopeLine: 106, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!740 = !DILocalVariable(name: "l", arg: 1, scope: !739, file: !107, line: 105, type: !731)
!741 = !DILocation(line: 105, column: 38, scope: !739)
!742 = !DILocation(line: 107, column: 5, scope: !739)
!743 = !DILocation(line: 107, column: 5, scope: !744)
!744 = distinct !DILexicalBlock(scope: !739, file: !107, line: 107, column: 5)
!745 = !DILocation(line: 107, column: 5, scope: !746)
!746 = distinct !DILexicalBlock(scope: !744, file: !107, line: 107, column: 5)
!747 = !DILocation(line: 107, column: 5, scope: !748)
!748 = distinct !DILexicalBlock(scope: !746, file: !107, line: 107, column: 5)
!749 = !DILocation(line: 108, column: 5, scope: !739)
!750 = distinct !DISubprogram(name: "rwlock_read_release", scope: !107, file: !107, line: 82, type: !751, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!751 = !DISubroutineType(types: !752)
!752 = !{null, !731}
!753 = !DILocalVariable(name: "l", arg: 1, scope: !750, file: !107, line: 82, type: !731)
!754 = !DILocation(line: 82, column: 31, scope: !750)
!755 = !DILocalVariable(name: "idx", scope: !750, file: !107, line: 84, type: !29)
!756 = !DILocation(line: 84, column: 15, scope: !750)
!757 = !DILocation(line: 84, column: 37, scope: !750)
!758 = !DILocation(line: 84, column: 21, scope: !750)
!759 = !DILocation(line: 85, column: 27, scope: !750)
!760 = !DILocation(line: 85, column: 30, scope: !750)
!761 = !DILocation(line: 85, column: 35, scope: !750)
!762 = !DILocation(line: 85, column: 5, scope: !750)
!763 = !DILocation(line: 86, column: 1, scope: !750)
!764 = distinct !DISubprogram(name: "rwlock_read_acquire", scope: !107, file: !107, line: 71, type: !751, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!765 = !DILocalVariable(name: "l", arg: 1, scope: !764, file: !107, line: 71, type: !731)
!766 = !DILocation(line: 71, column: 31, scope: !764)
!767 = !DILocalVariable(name: "idx", scope: !764, file: !107, line: 73, type: !29)
!768 = !DILocation(line: 73, column: 15, scope: !764)
!769 = !DILocation(line: 73, column: 37, scope: !764)
!770 = !DILocation(line: 73, column: 21, scope: !764)
!771 = !DILocation(line: 74, column: 25, scope: !764)
!772 = !DILocation(line: 74, column: 28, scope: !764)
!773 = !DILocation(line: 74, column: 33, scope: !764)
!774 = !DILocation(line: 74, column: 5, scope: !764)
!775 = !DILocation(line: 75, column: 1, scope: !764)
!776 = distinct !DISubprogram(name: "vatomic8_read_rlx", scope: !777, file: !777, line: 109, type: !778, scopeLine: 110, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!777 = !DIFile(filename: "vatomic/include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "0c3ec6df2f26018f35fe6ca81ab8f3c9")
!778 = !DISubroutineType(types: !779)
!779 = !{!23, !780}
!780 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !781, size: 64)
!781 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !144)
!782 = !DILocalVariable(name: "a", arg: 1, scope: !776, file: !777, line: 109, type: !780)
!783 = !DILocation(line: 109, column: 37, scope: !776)
!784 = !DILocation(line: 111, column: 5, scope: !776)
!785 = !{i64 2148224495}
!786 = !DILocalVariable(name: "tmp", scope: !776, file: !777, line: 112, type: !23)
!787 = !DILocation(line: 112, column: 14, scope: !776)
!788 = !DILocation(line: 112, column: 47, scope: !776)
!789 = !DILocation(line: 112, column: 50, scope: !776)
!790 = !DILocation(line: 112, column: 30, scope: !776)
!791 = !DILocation(line: 113, column: 5, scope: !776)
!792 = !{i64 2148224535}
!793 = !DILocation(line: 114, column: 12, scope: !776)
!794 = !DILocation(line: 114, column: 5, scope: !776)
!795 = distinct !DISubprogram(name: "_rwlock_get_tid", scope: !107, file: !107, line: 89, type: !796, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!796 = !DISubroutineType(types: !797)
!797 = !{!29, !731}
!798 = !DILocalVariable(name: "l", arg: 1, scope: !795, file: !107, line: 89, type: !731)
!799 = !DILocation(line: 89, column: 27, scope: !795)
!800 = !DILocation(line: 91, column: 9, scope: !801)
!801 = distinct !DILexicalBlock(scope: !795, file: !107, line: 91, column: 9)
!802 = !DILocation(line: 91, column: 15, scope: !801)
!803 = !DILocation(line: 91, column: 9, scope: !795)
!804 = !DILocation(line: 92, column: 36, scope: !805)
!805 = distinct !DILexicalBlock(scope: !801, file: !107, line: 91, column: 38)
!806 = !DILocation(line: 92, column: 39, scope: !805)
!807 = !DILocation(line: 92, column: 17, scope: !805)
!808 = !DILocation(line: 92, column: 15, scope: !805)
!809 = !DILocation(line: 93, column: 9, scope: !810)
!810 = distinct !DILexicalBlock(scope: !811, file: !107, line: 93, column: 9)
!811 = distinct !DILexicalBlock(scope: !805, file: !107, line: 93, column: 9)
!812 = !DILocation(line: 93, column: 9, scope: !811)
!813 = !DILocation(line: 94, column: 5, scope: !805)
!814 = !DILocation(line: 95, column: 12, scope: !795)
!815 = !DILocation(line: 95, column: 5, scope: !795)
!816 = distinct !DISubprogram(name: "vatomic32_get_inc", scope: !817, file: !817, line: 2484, type: !818, scopeLine: 2485, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!817 = !DIFile(filename: "vatomic/include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "ff273838f95062d7181b3cf355a65f2b")
!818 = !DISubroutineType(types: !819)
!819 = !{!29, !820}
!820 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !149, size: 64)
!821 = !DILocalVariable(name: "a", arg: 1, scope: !816, file: !817, line: 2484, type: !820)
!822 = !DILocation(line: 2484, column: 32, scope: !816)
!823 = !DILocation(line: 2486, column: 30, scope: !816)
!824 = !DILocation(line: 2486, column: 12, scope: !816)
!825 = !DILocation(line: 2486, column: 5, scope: !816)
!826 = distinct !DISubprogram(name: "vatomic32_get_add", scope: !777, file: !777, line: 2351, type: !827, scopeLine: 2352, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!827 = !DISubroutineType(types: !828)
!828 = !{!29, !820, !29}
!829 = !DILocalVariable(name: "a", arg: 1, scope: !826, file: !777, line: 2351, type: !820)
!830 = !DILocation(line: 2351, column: 32, scope: !826)
!831 = !DILocalVariable(name: "v", arg: 2, scope: !826, file: !777, line: 2351, type: !29)
!832 = !DILocation(line: 2351, column: 45, scope: !826)
!833 = !DILocation(line: 2353, column: 5, scope: !826)
!834 = !{i64 2148236243}
!835 = !DILocalVariable(name: "tmp", scope: !826, file: !777, line: 2354, type: !29)
!836 = !DILocation(line: 2354, column: 15, scope: !826)
!837 = !DILocation(line: 2354, column: 52, scope: !826)
!838 = !DILocation(line: 2354, column: 55, scope: !826)
!839 = !DILocation(line: 2354, column: 59, scope: !826)
!840 = !DILocation(line: 2354, column: 32, scope: !826)
!841 = !DILocation(line: 2355, column: 5, scope: !826)
!842 = !{i64 2148236283}
!843 = !DILocation(line: 2356, column: 12, scope: !826)
!844 = !DILocation(line: 2356, column: 5, scope: !826)
!845 = distinct !DISubprogram(name: "vatomicptr_read", scope: !777, file: !777, line: 291, type: !846, scopeLine: 292, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!846 = !DISubroutineType(types: !847)
!847 = !{!22, !848}
!848 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !849, size: 64)
!849 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !73)
!850 = !DILocalVariable(name: "a", arg: 1, scope: !845, file: !777, line: 291, type: !848)
!851 = !DILocation(line: 291, column: 37, scope: !845)
!852 = !DILocation(line: 293, column: 5, scope: !845)
!853 = !{i64 2148225509}
!854 = !DILocalVariable(name: "tmp", scope: !845, file: !777, line: 294, type: !22)
!855 = !DILocation(line: 294, column: 11, scope: !845)
!856 = !DILocation(line: 294, column: 42, scope: !845)
!857 = !DILocation(line: 294, column: 45, scope: !845)
!858 = !DILocation(line: 294, column: 25, scope: !845)
!859 = !DILocation(line: 295, column: 5, scope: !845)
!860 = !{i64 2148225549}
!861 = !DILocation(line: 296, column: 12, scope: !845)
!862 = !DILocation(line: 296, column: 5, scope: !845)
!863 = distinct !DISubprogram(name: "vatomicptr_cmpxchg", scope: !777, file: !777, line: 1259, type: !864, scopeLine: 1260, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!864 = !DISubroutineType(types: !865)
!865 = !{!22, !866, !22, !22}
!866 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !73, size: 64)
!867 = !DILocalVariable(name: "a", arg: 1, scope: !863, file: !777, line: 1259, type: !866)
!868 = !DILocation(line: 1259, column: 34, scope: !863)
!869 = !DILocalVariable(name: "e", arg: 2, scope: !863, file: !777, line: 1259, type: !22)
!870 = !DILocation(line: 1259, column: 43, scope: !863)
!871 = !DILocalVariable(name: "v", arg: 3, scope: !863, file: !777, line: 1259, type: !22)
!872 = !DILocation(line: 1259, column: 52, scope: !863)
!873 = !DILocalVariable(name: "exp", scope: !863, file: !777, line: 1261, type: !22)
!874 = !DILocation(line: 1261, column: 11, scope: !863)
!875 = !DILocation(line: 1261, column: 25, scope: !863)
!876 = !DILocation(line: 1262, column: 5, scope: !863)
!877 = !{i64 2148230619}
!878 = !DILocation(line: 1263, column: 34, scope: !863)
!879 = !DILocation(line: 1263, column: 37, scope: !863)
!880 = !DILocation(line: 1263, column: 55, scope: !863)
!881 = !DILocation(line: 1263, column: 5, scope: !863)
!882 = !DILocation(line: 1265, column: 5, scope: !863)
!883 = !{i64 2148230661}
!884 = !DILocation(line: 1266, column: 12, scope: !863)
!885 = !DILocation(line: 1266, column: 5, scope: !863)
!886 = distinct !DISubprogram(name: "_trace_add_or_rem_occurrences", scope: !157, file: !157, line: 122, type: !887, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!887 = !DISubroutineType(types: !888)
!888 = !{null, !579, !19, !14, !42}
!889 = !DILocalVariable(name: "trace", arg: 1, scope: !886, file: !157, line: 122, type: !579)
!890 = !DILocation(line: 122, column: 40, scope: !886)
!891 = !DILocalVariable(name: "key", arg: 2, scope: !886, file: !157, line: 122, type: !19)
!892 = !DILocation(line: 122, column: 58, scope: !886)
!893 = !DILocalVariable(name: "count", arg: 3, scope: !886, file: !157, line: 122, type: !14)
!894 = !DILocation(line: 122, column: 71, scope: !886)
!895 = !DILocalVariable(name: "subtract", arg: 4, scope: !886, file: !157, line: 123, type: !42)
!896 = !DILocation(line: 123, column: 39, scope: !886)
!897 = !DILocalVariable(name: "idx", scope: !886, file: !157, line: 125, type: !14)
!898 = !DILocation(line: 125, column: 13, scope: !886)
!899 = !DILocalVariable(name: "found", scope: !886, file: !157, line: 126, type: !42)
!900 = !DILocation(line: 126, column: 13, scope: !886)
!901 = !DILocation(line: 128, column: 5, scope: !902)
!902 = distinct !DILexicalBlock(scope: !903, file: !157, line: 128, column: 5)
!903 = distinct !DILexicalBlock(scope: !886, file: !157, line: 128, column: 5)
!904 = !DILocation(line: 128, column: 5, scope: !903)
!905 = !DILocation(line: 129, column: 5, scope: !906)
!906 = distinct !DILexicalBlock(scope: !907, file: !157, line: 129, column: 5)
!907 = distinct !DILexicalBlock(scope: !886, file: !157, line: 129, column: 5)
!908 = !DILocation(line: 129, column: 5, scope: !907)
!909 = !DILocation(line: 131, column: 33, scope: !886)
!910 = !DILocation(line: 131, column: 40, scope: !886)
!911 = !DILocation(line: 131, column: 13, scope: !886)
!912 = !DILocation(line: 131, column: 11, scope: !886)
!913 = !DILocation(line: 133, column: 9, scope: !914)
!914 = distinct !DILexicalBlock(scope: !886, file: !157, line: 133, column: 9)
!915 = !DILocation(line: 133, column: 9, scope: !886)
!916 = !DILocation(line: 134, column: 9, scope: !917)
!917 = distinct !DILexicalBlock(scope: !918, file: !157, line: 134, column: 9)
!918 = distinct !DILexicalBlock(scope: !919, file: !157, line: 134, column: 9)
!919 = distinct !DILexicalBlock(scope: !914, file: !157, line: 133, column: 19)
!920 = !DILocation(line: 134, column: 9, scope: !918)
!921 = !DILocation(line: 135, column: 9, scope: !922)
!922 = distinct !DILexicalBlock(scope: !923, file: !157, line: 135, column: 9)
!923 = distinct !DILexicalBlock(scope: !919, file: !157, line: 135, column: 9)
!924 = !DILocation(line: 135, column: 9, scope: !923)
!925 = !DILocation(line: 136, column: 36, scope: !919)
!926 = !DILocation(line: 136, column: 9, scope: !919)
!927 = !DILocation(line: 136, column: 16, scope: !919)
!928 = !DILocation(line: 136, column: 22, scope: !919)
!929 = !DILocation(line: 136, column: 27, scope: !919)
!930 = !DILocation(line: 136, column: 33, scope: !919)
!931 = !DILocation(line: 137, column: 9, scope: !919)
!932 = !DILocation(line: 140, column: 10, scope: !933)
!933 = distinct !DILexicalBlock(scope: !886, file: !157, line: 140, column: 9)
!934 = !DILocation(line: 140, column: 9, scope: !886)
!935 = !DILocation(line: 141, column: 15, scope: !936)
!936 = distinct !DILexicalBlock(scope: !933, file: !157, line: 140, column: 17)
!937 = !DILocation(line: 141, column: 22, scope: !936)
!938 = !DILocation(line: 141, column: 25, scope: !936)
!939 = !DILocation(line: 141, column: 13, scope: !936)
!940 = !DILocation(line: 142, column: 13, scope: !941)
!941 = distinct !DILexicalBlock(scope: !936, file: !157, line: 142, column: 13)
!942 = !DILocation(line: 142, column: 20, scope: !941)
!943 = !DILocation(line: 142, column: 27, scope: !941)
!944 = !DILocation(line: 142, column: 17, scope: !941)
!945 = !DILocation(line: 142, column: 13, scope: !936)
!946 = !DILocation(line: 143, column: 26, scope: !947)
!947 = distinct !DILexicalBlock(scope: !941, file: !157, line: 142, column: 37)
!948 = !DILocation(line: 143, column: 13, scope: !947)
!949 = !DILocation(line: 144, column: 9, scope: !947)
!950 = !DILocation(line: 145, column: 35, scope: !936)
!951 = !DILocation(line: 145, column: 9, scope: !936)
!952 = !DILocation(line: 145, column: 16, scope: !936)
!953 = !DILocation(line: 145, column: 22, scope: !936)
!954 = !DILocation(line: 145, column: 27, scope: !936)
!955 = !DILocation(line: 145, column: 33, scope: !936)
!956 = !DILocation(line: 146, column: 35, scope: !936)
!957 = !DILocation(line: 146, column: 9, scope: !936)
!958 = !DILocation(line: 146, column: 16, scope: !936)
!959 = !DILocation(line: 146, column: 22, scope: !936)
!960 = !DILocation(line: 146, column: 27, scope: !936)
!961 = !DILocation(line: 146, column: 33, scope: !936)
!962 = !DILocation(line: 147, column: 5, scope: !936)
!963 = !DILocation(line: 148, column: 36, scope: !964)
!964 = distinct !DILexicalBlock(scope: !933, file: !157, line: 147, column: 12)
!965 = !DILocation(line: 148, column: 9, scope: !964)
!966 = !DILocation(line: 148, column: 16, scope: !964)
!967 = !DILocation(line: 148, column: 22, scope: !964)
!968 = !DILocation(line: 148, column: 27, scope: !964)
!969 = !DILocation(line: 148, column: 33, scope: !964)
!970 = !DILocation(line: 150, column: 1, scope: !886)
!971 = distinct !DISubprogram(name: "trace_find_unit_idx", scope: !157, file: !157, line: 107, type: !972, scopeLine: 108, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!972 = !DISubroutineType(types: !973)
!973 = !{!42, !579, !19, !974}
!974 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!975 = !DILocalVariable(name: "trace", arg: 1, scope: !971, file: !157, line: 107, type: !579)
!976 = !DILocation(line: 107, column: 30, scope: !971)
!977 = !DILocalVariable(name: "key", arg: 2, scope: !971, file: !157, line: 107, type: !19)
!978 = !DILocation(line: 107, column: 48, scope: !971)
!979 = !DILocalVariable(name: "out_idx", arg: 3, scope: !971, file: !157, line: 107, type: !974)
!980 = !DILocation(line: 107, column: 62, scope: !971)
!981 = !DILocalVariable(name: "i", scope: !971, file: !157, line: 109, type: !14)
!982 = !DILocation(line: 109, column: 13, scope: !971)
!983 = !DILocation(line: 110, column: 5, scope: !984)
!984 = distinct !DILexicalBlock(scope: !985, file: !157, line: 110, column: 5)
!985 = distinct !DILexicalBlock(scope: !971, file: !157, line: 110, column: 5)
!986 = !DILocation(line: 110, column: 5, scope: !985)
!987 = !DILocation(line: 111, column: 5, scope: !988)
!988 = distinct !DILexicalBlock(scope: !989, file: !157, line: 111, column: 5)
!989 = distinct !DILexicalBlock(scope: !971, file: !157, line: 111, column: 5)
!990 = !DILocation(line: 111, column: 5, scope: !989)
!991 = !DILocation(line: 112, column: 12, scope: !992)
!992 = distinct !DILexicalBlock(scope: !971, file: !157, line: 112, column: 5)
!993 = !DILocation(line: 112, column: 10, scope: !992)
!994 = !DILocation(line: 112, column: 17, scope: !995)
!995 = distinct !DILexicalBlock(scope: !992, file: !157, line: 112, column: 5)
!996 = !DILocation(line: 112, column: 21, scope: !995)
!997 = !DILocation(line: 112, column: 28, scope: !995)
!998 = !DILocation(line: 112, column: 19, scope: !995)
!999 = !DILocation(line: 112, column: 5, scope: !992)
!1000 = !DILocation(line: 113, column: 13, scope: !1001)
!1001 = distinct !DILexicalBlock(scope: !1002, file: !157, line: 113, column: 13)
!1002 = distinct !DILexicalBlock(scope: !995, file: !157, line: 112, column: 38)
!1003 = !DILocation(line: 113, column: 20, scope: !1001)
!1004 = !DILocation(line: 113, column: 26, scope: !1001)
!1005 = !DILocation(line: 113, column: 29, scope: !1001)
!1006 = !DILocation(line: 113, column: 36, scope: !1001)
!1007 = !DILocation(line: 113, column: 33, scope: !1001)
!1008 = !DILocation(line: 113, column: 13, scope: !1002)
!1009 = !DILocation(line: 114, column: 24, scope: !1010)
!1010 = distinct !DILexicalBlock(scope: !1001, file: !157, line: 113, column: 41)
!1011 = !DILocation(line: 114, column: 14, scope: !1010)
!1012 = !DILocation(line: 114, column: 22, scope: !1010)
!1013 = !DILocation(line: 115, column: 13, scope: !1010)
!1014 = !DILocation(line: 117, column: 5, scope: !1002)
!1015 = !DILocation(line: 112, column: 34, scope: !995)
!1016 = !DILocation(line: 112, column: 5, scope: !995)
!1017 = distinct !{!1017, !999, !1018, !223}
!1018 = !DILocation(line: 117, column: 5, scope: !992)
!1019 = !DILocation(line: 118, column: 5, scope: !971)
!1020 = !DILocation(line: 119, column: 1, scope: !971)
!1021 = distinct !DISubprogram(name: "trace_extend", scope: !157, file: !157, line: 73, type: !1022, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1022 = !DISubroutineType(types: !1023)
!1023 = !{null, !579}
!1024 = !DILocalVariable(name: "trace", arg: 1, scope: !1021, file: !157, line: 73, type: !579)
!1025 = !DILocation(line: 73, column: 23, scope: !1021)
!1026 = !DILocation(line: 75, column: 5, scope: !1027)
!1027 = distinct !DILexicalBlock(scope: !1028, file: !157, line: 75, column: 5)
!1028 = distinct !DILexicalBlock(scope: !1021, file: !157, line: 75, column: 5)
!1029 = !DILocation(line: 75, column: 5, scope: !1028)
!1030 = !DILocalVariable(name: "src_size", scope: !1021, file: !157, line: 77, type: !14)
!1031 = !DILocation(line: 77, column: 13, scope: !1021)
!1032 = !DILocation(line: 77, column: 24, scope: !1021)
!1033 = !DILocation(line: 77, column: 31, scope: !1021)
!1034 = !DILocation(line: 77, column: 40, scope: !1021)
!1035 = !DILocalVariable(name: "des_max", scope: !1021, file: !157, line: 78, type: !14)
!1036 = !DILocation(line: 78, column: 13, scope: !1021)
!1037 = !DILocation(line: 78, column: 24, scope: !1021)
!1038 = !DILocation(line: 78, column: 33, scope: !1021)
!1039 = !DILocalVariable(name: "src", scope: !1021, file: !157, line: 80, type: !161)
!1040 = !DILocation(line: 80, column: 19, scope: !1021)
!1041 = !DILocation(line: 80, column: 25, scope: !1021)
!1042 = !DILocation(line: 80, column: 32, scope: !1021)
!1043 = !DILocalVariable(name: "des", scope: !1021, file: !157, line: 81, type: !161)
!1044 = !DILocation(line: 81, column: 19, scope: !1021)
!1045 = !DILocation(line: 81, column: 32, scope: !1021)
!1046 = !DILocation(line: 81, column: 25, scope: !1021)
!1047 = !DILocation(line: 83, column: 9, scope: !1048)
!1048 = distinct !DILexicalBlock(scope: !1021, file: !157, line: 83, column: 9)
!1049 = !DILocation(line: 83, column: 9, scope: !1021)
!1050 = !DILocalVariable(name: "ret", scope: !1051, file: !157, line: 84, type: !120)
!1051 = distinct !DILexicalBlock(scope: !1048, file: !157, line: 83, column: 14)
!1052 = !DILocation(line: 84, column: 13, scope: !1051)
!1053 = !DILocation(line: 84, column: 28, scope: !1051)
!1054 = !DILocation(line: 84, column: 33, scope: !1051)
!1055 = !DILocation(line: 84, column: 42, scope: !1051)
!1056 = !DILocation(line: 84, column: 47, scope: !1051)
!1057 = !DILocation(line: 84, column: 19, scope: !1051)
!1058 = !DILocation(line: 85, column: 13, scope: !1059)
!1059 = distinct !DILexicalBlock(scope: !1051, file: !157, line: 85, column: 13)
!1060 = !DILocation(line: 85, column: 17, scope: !1059)
!1061 = !DILocation(line: 85, column: 13, scope: !1051)
!1062 = !DILocation(line: 86, column: 28, scope: !1063)
!1063 = distinct !DILexicalBlock(scope: !1059, file: !157, line: 85, column: 23)
!1064 = !DILocation(line: 86, column: 13, scope: !1063)
!1065 = !DILocation(line: 86, column: 20, scope: !1063)
!1066 = !DILocation(line: 86, column: 26, scope: !1063)
!1067 = !DILocation(line: 87, column: 13, scope: !1063)
!1068 = !DILocation(line: 87, column: 20, scope: !1063)
!1069 = !DILocation(line: 87, column: 29, scope: !1063)
!1070 = !DILocation(line: 88, column: 9, scope: !1063)
!1071 = !DILocation(line: 89, column: 13, scope: !1072)
!1072 = distinct !DILexicalBlock(scope: !1073, file: !157, line: 89, column: 13)
!1073 = distinct !DILexicalBlock(scope: !1074, file: !157, line: 89, column: 13)
!1074 = distinct !DILexicalBlock(scope: !1059, file: !157, line: 88, column: 16)
!1075 = !DILocation(line: 91, column: 14, scope: !1051)
!1076 = !DILocation(line: 91, column: 9, scope: !1051)
!1077 = !DILocation(line: 92, column: 5, scope: !1051)
!1078 = !DILocation(line: 93, column: 9, scope: !1079)
!1079 = distinct !DILexicalBlock(scope: !1080, file: !157, line: 93, column: 9)
!1080 = distinct !DILexicalBlock(scope: !1081, file: !157, line: 93, column: 9)
!1081 = distinct !DILexicalBlock(scope: !1048, file: !157, line: 92, column: 12)
!1082 = !DILocation(line: 95, column: 1, scope: !1021)
!1083 = distinct !DISubprogram(name: "vsimpleht_get", scope: !6, file: !6, line: 257, type: !1084, scopeLine: 258, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1084 = !DISubroutineType(types: !1085)
!1085 = !{!22, !554, !19}
!1086 = !DILocalVariable(name: "tbl", arg: 1, scope: !1083, file: !6, line: 257, type: !554)
!1087 = !DILocation(line: 257, column: 28, scope: !1083)
!1088 = !DILocalVariable(name: "key", arg: 2, scope: !1083, file: !6, line: 257, type: !19)
!1089 = !DILocation(line: 257, column: 44, scope: !1083)
!1090 = !DILocalVariable(name: "index", scope: !1083, file: !6, line: 259, type: !14)
!1091 = !DILocation(line: 259, column: 13, scope: !1083)
!1092 = !DILocalVariable(name: "probed_key", scope: !1083, file: !6, line: 260, type: !19)
!1093 = !DILocation(line: 260, column: 16, scope: !1083)
!1094 = !DILocation(line: 261, column: 38, scope: !1083)
!1095 = !DILocation(line: 261, column: 5, scope: !1083)
!1096 = !DILocation(line: 262, column: 18, scope: !1097)
!1097 = distinct !DILexicalBlock(scope: !1083, file: !6, line: 262, column: 5)
!1098 = !DILocation(line: 262, column: 23, scope: !1097)
!1099 = !DILocation(line: 262, column: 32, scope: !1097)
!1100 = !DILocation(line: 262, column: 16, scope: !1097)
!1101 = !DILocation(line: 262, column: 10, scope: !1097)
!1102 = !DILocation(line: 263, column: 18, scope: !1103)
!1103 = distinct !DILexicalBlock(scope: !1104, file: !6, line: 262, column: 48)
!1104 = distinct !DILexicalBlock(scope: !1097, file: !6, line: 262, column: 5)
!1105 = !DILocation(line: 263, column: 23, scope: !1103)
!1106 = !DILocation(line: 263, column: 32, scope: !1103)
!1107 = !DILocation(line: 263, column: 15, scope: !1103)
!1108 = !DILocation(line: 264, column: 9, scope: !1109)
!1109 = distinct !DILexicalBlock(scope: !1110, file: !6, line: 264, column: 9)
!1110 = distinct !DILexicalBlock(scope: !1103, file: !6, line: 264, column: 9)
!1111 = !DILocation(line: 264, column: 9, scope: !1110)
!1112 = !DILocation(line: 265, column: 51, scope: !1103)
!1113 = !DILocation(line: 265, column: 56, scope: !1103)
!1114 = !DILocation(line: 265, column: 64, scope: !1103)
!1115 = !DILocation(line: 265, column: 71, scope: !1103)
!1116 = !DILocation(line: 265, column: 34, scope: !1103)
!1117 = !DILocation(line: 265, column: 22, scope: !1103)
!1118 = !DILocation(line: 265, column: 20, scope: !1103)
!1119 = !DILocation(line: 266, column: 13, scope: !1120)
!1120 = distinct !DILexicalBlock(scope: !1103, file: !6, line: 266, column: 13)
!1121 = !DILocation(line: 266, column: 24, scope: !1120)
!1122 = !DILocation(line: 266, column: 13, scope: !1103)
!1123 = !DILocation(line: 267, column: 13, scope: !1124)
!1124 = distinct !DILexicalBlock(scope: !1120, file: !6, line: 266, column: 30)
!1125 = !DILocation(line: 268, column: 20, scope: !1126)
!1126 = distinct !DILexicalBlock(scope: !1120, file: !6, line: 268, column: 20)
!1127 = !DILocation(line: 268, column: 25, scope: !1126)
!1128 = !DILocation(line: 268, column: 33, scope: !1126)
!1129 = !DILocation(line: 268, column: 38, scope: !1126)
!1130 = !DILocation(line: 268, column: 50, scope: !1126)
!1131 = !DILocation(line: 268, column: 20, scope: !1120)
!1132 = !DILocation(line: 269, column: 41, scope: !1133)
!1133 = distinct !DILexicalBlock(scope: !1126, file: !6, line: 268, column: 56)
!1134 = !DILocation(line: 269, column: 46, scope: !1133)
!1135 = !DILocation(line: 269, column: 54, scope: !1133)
!1136 = !DILocation(line: 269, column: 61, scope: !1133)
!1137 = !DILocation(line: 269, column: 20, scope: !1133)
!1138 = !DILocation(line: 269, column: 13, scope: !1133)
!1139 = !DILocation(line: 271, column: 5, scope: !1103)
!1140 = !DILocation(line: 262, column: 44, scope: !1104)
!1141 = !DILocation(line: 262, column: 5, scope: !1104)
!1142 = distinct !{!1142, !1143, !1144}
!1143 = !DILocation(line: 262, column: 5, scope: !1097)
!1144 = !DILocation(line: 271, column: 5, scope: !1097)
!1145 = !DILocation(line: 272, column: 1, scope: !1083)
!1146 = distinct !DISubprogram(name: "vatomicptr_read_acq", scope: !777, file: !777, line: 305, type: !846, scopeLine: 306, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1147 = !DILocalVariable(name: "a", arg: 1, scope: !1146, file: !777, line: 305, type: !848)
!1148 = !DILocation(line: 305, column: 41, scope: !1146)
!1149 = !DILocation(line: 307, column: 5, scope: !1146)
!1150 = !{i64 2148225587}
!1151 = !DILocalVariable(name: "tmp", scope: !1146, file: !777, line: 308, type: !22)
!1152 = !DILocation(line: 308, column: 11, scope: !1146)
!1153 = !DILocation(line: 308, column: 42, scope: !1146)
!1154 = !DILocation(line: 308, column: 45, scope: !1146)
!1155 = !DILocation(line: 308, column: 25, scope: !1146)
!1156 = !DILocation(line: 309, column: 5, scope: !1146)
!1157 = !{i64 2148225627}
!1158 = !DILocation(line: 310, column: 12, scope: !1146)
!1159 = !DILocation(line: 310, column: 5, scope: !1146)
!1160 = distinct !DISubprogram(name: "vsimpleht_remove", scope: !6, file: !6, line: 354, type: !1161, scopeLine: 355, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1161 = !DISubroutineType(types: !1162)
!1162 = !{!553, !554, !19}
!1163 = !DILocalVariable(name: "tbl", arg: 1, scope: !1160, file: !6, line: 354, type: !554)
!1164 = !DILocation(line: 354, column: 31, scope: !1160)
!1165 = !DILocalVariable(name: "key", arg: 2, scope: !1160, file: !6, line: 354, type: !19)
!1166 = !DILocation(line: 354, column: 47, scope: !1160)
!1167 = !DILocalVariable(name: "index", scope: !1160, file: !6, line: 363, type: !14)
!1168 = !DILocation(line: 363, column: 13, scope: !1160)
!1169 = !DILocalVariable(name: "probed_key", scope: !1160, file: !6, line: 364, type: !19)
!1170 = !DILocation(line: 364, column: 16, scope: !1160)
!1171 = !DILocalVariable(name: "probed_value", scope: !1160, file: !6, line: 365, type: !22)
!1172 = !DILocation(line: 365, column: 11, scope: !1160)
!1173 = !DILocalVariable(name: "start_index", scope: !1160, file: !6, line: 366, type: !14)
!1174 = !DILocation(line: 366, column: 13, scope: !1160)
!1175 = !DILocation(line: 366, column: 29, scope: !1160)
!1176 = !DILocation(line: 366, column: 34, scope: !1160)
!1177 = !DILocation(line: 366, column: 43, scope: !1160)
!1178 = !DILocation(line: 367, column: 29, scope: !1160)
!1179 = !DILocation(line: 367, column: 44, scope: !1160)
!1180 = !DILocation(line: 367, column: 49, scope: !1160)
!1181 = !DILocation(line: 367, column: 58, scope: !1160)
!1182 = !DILocation(line: 367, column: 41, scope: !1160)
!1183 = !DILocation(line: 367, column: 27, scope: !1160)
!1184 = !DILocation(line: 368, column: 38, scope: !1160)
!1185 = !DILocation(line: 368, column: 5, scope: !1160)
!1186 = !DILocation(line: 369, column: 5, scope: !1160)
!1187 = !DILocation(line: 370, column: 51, scope: !1188)
!1188 = distinct !DILexicalBlock(scope: !1160, file: !6, line: 369, column: 8)
!1189 = !DILocation(line: 370, column: 56, scope: !1188)
!1190 = !DILocation(line: 370, column: 64, scope: !1188)
!1191 = !DILocation(line: 370, column: 71, scope: !1188)
!1192 = !DILocation(line: 370, column: 34, scope: !1188)
!1193 = !DILocation(line: 370, column: 22, scope: !1188)
!1194 = !DILocation(line: 370, column: 20, scope: !1188)
!1195 = !DILocation(line: 371, column: 13, scope: !1196)
!1196 = distinct !DILexicalBlock(scope: !1188, file: !6, line: 371, column: 13)
!1197 = !DILocation(line: 371, column: 24, scope: !1196)
!1198 = !DILocation(line: 371, column: 13, scope: !1188)
!1199 = !DILocation(line: 374, column: 13, scope: !1200)
!1200 = distinct !DILexicalBlock(scope: !1196, file: !6, line: 371, column: 30)
!1201 = !DILocation(line: 375, column: 20, scope: !1202)
!1202 = distinct !DILexicalBlock(scope: !1196, file: !6, line: 375, column: 20)
!1203 = !DILocation(line: 375, column: 25, scope: !1202)
!1204 = !DILocation(line: 375, column: 33, scope: !1202)
!1205 = !DILocation(line: 375, column: 38, scope: !1202)
!1206 = !DILocation(line: 375, column: 50, scope: !1202)
!1207 = !DILocation(line: 375, column: 20, scope: !1196)
!1208 = !DILocation(line: 376, column: 49, scope: !1209)
!1209 = distinct !DILexicalBlock(scope: !1202, file: !6, line: 375, column: 56)
!1210 = !DILocation(line: 376, column: 54, scope: !1209)
!1211 = !DILocation(line: 376, column: 62, scope: !1209)
!1212 = !DILocation(line: 376, column: 69, scope: !1209)
!1213 = !DILocation(line: 376, column: 28, scope: !1209)
!1214 = !DILocation(line: 376, column: 26, scope: !1209)
!1215 = !DILocation(line: 379, column: 17, scope: !1216)
!1216 = distinct !DILexicalBlock(scope: !1209, file: !6, line: 379, column: 17)
!1217 = !DILocation(line: 379, column: 30, scope: !1216)
!1218 = !DILocation(line: 379, column: 17, scope: !1209)
!1219 = !DILocation(line: 381, column: 17, scope: !1220)
!1220 = distinct !DILexicalBlock(scope: !1216, file: !6, line: 379, column: 39)
!1221 = !DILocation(line: 384, column: 41, scope: !1222)
!1222 = distinct !DILexicalBlock(scope: !1209, file: !6, line: 384, column: 17)
!1223 = !DILocation(line: 384, column: 46, scope: !1222)
!1224 = !DILocation(line: 384, column: 54, scope: !1222)
!1225 = !DILocation(line: 384, column: 61, scope: !1222)
!1226 = !DILocation(line: 384, column: 68, scope: !1222)
!1227 = !DILocation(line: 384, column: 17, scope: !1222)
!1228 = !DILocation(line: 385, column: 49, scope: !1222)
!1229 = !DILocation(line: 385, column: 46, scope: !1222)
!1230 = !DILocation(line: 384, column: 17, scope: !1209)
!1231 = !DILocation(line: 386, column: 36, scope: !1232)
!1232 = distinct !DILexicalBlock(scope: !1222, file: !6, line: 385, column: 63)
!1233 = !DILocation(line: 386, column: 41, scope: !1232)
!1234 = !DILocation(line: 386, column: 17, scope: !1232)
!1235 = !DILocation(line: 388, column: 44, scope: !1232)
!1236 = !DILocation(line: 388, column: 49, scope: !1232)
!1237 = !DILocation(line: 388, column: 17, scope: !1232)
!1238 = !DILocation(line: 389, column: 17, scope: !1232)
!1239 = !DILocation(line: 391, column: 13, scope: !1209)
!1240 = !DILocation(line: 394, column: 14, scope: !1188)
!1241 = !DILocation(line: 395, column: 18, scope: !1188)
!1242 = !DILocation(line: 395, column: 23, scope: !1188)
!1243 = !DILocation(line: 395, column: 32, scope: !1188)
!1244 = !DILocation(line: 395, column: 15, scope: !1188)
!1245 = !DILocation(line: 396, column: 5, scope: !1188)
!1246 = !DILocation(line: 396, column: 14, scope: !1160)
!1247 = !DILocation(line: 396, column: 23, scope: !1160)
!1248 = !DILocation(line: 396, column: 20, scope: !1160)
!1249 = distinct !{!1249, !1186, !1250, !223}
!1250 = !DILocation(line: 396, column: 34, scope: !1160)
!1251 = !DILocation(line: 399, column: 5, scope: !1160)
!1252 = !DILocation(line: 401, column: 1, scope: !1160)
!1253 = distinct !DISubprogram(name: "vatomicptr_cmpxchg_rel", scope: !777, file: !777, line: 1291, type: !864, scopeLine: 1292, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1254 = !DILocalVariable(name: "a", arg: 1, scope: !1253, file: !777, line: 1291, type: !866)
!1255 = !DILocation(line: 1291, column: 38, scope: !1253)
!1256 = !DILocalVariable(name: "e", arg: 2, scope: !1253, file: !777, line: 1291, type: !22)
!1257 = !DILocation(line: 1291, column: 47, scope: !1253)
!1258 = !DILocalVariable(name: "v", arg: 3, scope: !1253, file: !777, line: 1291, type: !22)
!1259 = !DILocation(line: 1291, column: 56, scope: !1253)
!1260 = !DILocalVariable(name: "exp", scope: !1253, file: !777, line: 1293, type: !22)
!1261 = !DILocation(line: 1293, column: 11, scope: !1253)
!1262 = !DILocation(line: 1293, column: 25, scope: !1253)
!1263 = !DILocation(line: 1294, column: 5, scope: !1253)
!1264 = !{i64 2148230779}
!1265 = !DILocation(line: 1295, column: 34, scope: !1253)
!1266 = !DILocation(line: 1295, column: 37, scope: !1253)
!1267 = !DILocation(line: 1295, column: 55, scope: !1253)
!1268 = !DILocation(line: 1295, column: 5, scope: !1253)
!1269 = !DILocation(line: 1297, column: 5, scope: !1253)
!1270 = !{i64 2148230821}
!1271 = !DILocation(line: 1298, column: 12, scope: !1253)
!1272 = !DILocation(line: 1298, column: 5, scope: !1253)
!1273 = distinct !DISubprogram(name: "vatomicsz_inc_rlx", scope: !817, file: !817, line: 3045, type: !1274, scopeLine: 3046, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1274 = !DISubroutineType(types: !1275)
!1275 = !{null, !1276}
!1276 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!1277 = !DILocalVariable(name: "a", arg: 1, scope: !1273, file: !817, line: 3045, type: !1276)
!1278 = !DILocation(line: 3045, column: 32, scope: !1273)
!1279 = !DILocation(line: 3047, column: 33, scope: !1273)
!1280 = !DILocation(line: 3047, column: 11, scope: !1273)
!1281 = !DILocation(line: 3048, column: 1, scope: !1273)
!1282 = distinct !DISubprogram(name: "_vsimpleht_trigger_cleanup", scope: !6, file: !6, line: 501, type: !1283, scopeLine: 502, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1283 = !DISubroutineType(types: !1284)
!1284 = !{null, !554, !22}
!1285 = !DILocalVariable(name: "tbl", arg: 1, scope: !1282, file: !6, line: 501, type: !554)
!1286 = !DILocation(line: 501, column: 41, scope: !1282)
!1287 = !DILocalVariable(name: "val", arg: 2, scope: !1282, file: !6, line: 501, type: !22)
!1288 = !DILocation(line: 501, column: 52, scope: !1282)
!1289 = !DILocation(line: 506, column: 5, scope: !1290)
!1290 = distinct !DILexicalBlock(scope: !1291, file: !6, line: 506, column: 5)
!1291 = distinct !DILexicalBlock(scope: !1282, file: !6, line: 506, column: 5)
!1292 = !DILocation(line: 506, column: 5, scope: !1291)
!1293 = !DILocation(line: 509, column: 26, scope: !1282)
!1294 = !DILocation(line: 509, column: 31, scope: !1282)
!1295 = !DILocation(line: 509, column: 5, scope: !1282)
!1296 = !DILocation(line: 510, column: 24, scope: !1282)
!1297 = !DILocation(line: 510, column: 29, scope: !1282)
!1298 = !DILocation(line: 510, column: 5, scope: !1282)
!1299 = !DILocation(line: 511, column: 26, scope: !1282)
!1300 = !DILocation(line: 511, column: 31, scope: !1282)
!1301 = !DILocation(line: 511, column: 5, scope: !1282)
!1302 = !DILocation(line: 513, column: 1, scope: !1282)
!1303 = distinct !DISubprogram(name: "vatomicsz_get_inc_rlx", scope: !817, file: !817, line: 2605, type: !1304, scopeLine: 2606, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1304 = !DISubroutineType(types: !1305)
!1305 = !{!14, !1276}
!1306 = !DILocalVariable(name: "a", arg: 1, scope: !1303, file: !817, line: 2605, type: !1276)
!1307 = !DILocation(line: 2605, column: 36, scope: !1303)
!1308 = !DILocation(line: 2607, column: 34, scope: !1303)
!1309 = !DILocation(line: 2607, column: 12, scope: !1303)
!1310 = !DILocation(line: 2607, column: 5, scope: !1303)
!1311 = distinct !DISubprogram(name: "vatomicsz_get_add_rlx", scope: !777, file: !777, line: 2505, type: !1312, scopeLine: 2506, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1312 = !DISubroutineType(types: !1313)
!1313 = !{!14, !1276, !14}
!1314 = !DILocalVariable(name: "a", arg: 1, scope: !1311, file: !777, line: 2505, type: !1276)
!1315 = !DILocation(line: 2505, column: 36, scope: !1311)
!1316 = !DILocalVariable(name: "v", arg: 2, scope: !1311, file: !777, line: 2505, type: !14)
!1317 = !DILocation(line: 2505, column: 47, scope: !1311)
!1318 = !DILocation(line: 2507, column: 5, scope: !1311)
!1319 = !{i64 2148237101}
!1320 = !DILocalVariable(name: "tmp", scope: !1311, file: !777, line: 2508, type: !14)
!1321 = !DILocation(line: 2508, column: 13, scope: !1311)
!1322 = !DILocation(line: 2508, column: 48, scope: !1311)
!1323 = !DILocation(line: 2508, column: 51, scope: !1311)
!1324 = !DILocation(line: 2508, column: 55, scope: !1311)
!1325 = !DILocation(line: 2508, column: 28, scope: !1311)
!1326 = !DILocation(line: 2509, column: 5, scope: !1311)
!1327 = !{i64 2148237141}
!1328 = !DILocation(line: 2510, column: 12, scope: !1311)
!1329 = !DILocation(line: 2510, column: 5, scope: !1311)
!1330 = distinct !DISubprogram(name: "_vsimpleht_cleanup", scope: !6, file: !6, line: 530, type: !1283, scopeLine: 531, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1331 = !DILocalVariable(name: "tbl", arg: 1, scope: !1330, file: !6, line: 530, type: !554)
!1332 = !DILocation(line: 530, column: 33, scope: !1330)
!1333 = !DILocalVariable(name: "val", arg: 2, scope: !1330, file: !6, line: 530, type: !22)
!1334 = !DILocation(line: 530, column: 44, scope: !1330)
!1335 = !DILocalVariable(name: "e", scope: !1330, file: !6, line: 532, type: !14)
!1336 = !DILocation(line: 532, column: 13, scope: !1330)
!1337 = !DILocalVariable(name: "i", scope: !1330, file: !6, line: 533, type: !14)
!1338 = !DILocation(line: 533, column: 13, scope: !1330)
!1339 = !DILocalVariable(name: "key", scope: !1330, file: !6, line: 534, type: !19)
!1340 = !DILocation(line: 534, column: 16, scope: !1330)
!1341 = !DILocalVariable(name: "value", scope: !1330, file: !6, line: 535, type: !22)
!1342 = !DILocation(line: 535, column: 11, scope: !1330)
!1343 = !DILocalVariable(name: "len", scope: !1330, file: !6, line: 536, type: !14)
!1344 = !DILocation(line: 536, column: 13, scope: !1330)
!1345 = !DILocation(line: 536, column: 19, scope: !1330)
!1346 = !DILocation(line: 536, column: 24, scope: !1330)
!1347 = !DILocalVariable(name: "entries", scope: !1330, file: !6, line: 537, type: !68)
!1348 = !DILocation(line: 537, column: 24, scope: !1330)
!1349 = !DILocation(line: 537, column: 34, scope: !1330)
!1350 = !DILocation(line: 537, column: 39, scope: !1330)
!1351 = !DILocalVariable(name: "start_index", scope: !1330, file: !6, line: 538, type: !14)
!1352 = !DILocation(line: 538, column: 13, scope: !1330)
!1353 = !DILocation(line: 538, column: 27, scope: !1330)
!1354 = !DILocation(line: 538, column: 31, scope: !1330)
!1355 = !DILocalVariable(name: "ret", scope: !1330, file: !6, line: 539, type: !24)
!1356 = !DILocation(line: 539, column: 13, scope: !1330)
!1357 = !DILocation(line: 542, column: 27, scope: !1330)
!1358 = !DILocation(line: 542, column: 32, scope: !1330)
!1359 = !DILocation(line: 542, column: 5, scope: !1330)
!1360 = !DILocation(line: 545, column: 29, scope: !1361)
!1361 = distinct !DILexicalBlock(scope: !1330, file: !6, line: 545, column: 9)
!1362 = !DILocation(line: 545, column: 34, scope: !1361)
!1363 = !DILocation(line: 545, column: 9, scope: !1361)
!1364 = !DILocation(line: 545, column: 51, scope: !1361)
!1365 = !DILocation(line: 545, column: 56, scope: !1361)
!1366 = !DILocation(line: 545, column: 49, scope: !1361)
!1367 = !DILocation(line: 545, column: 9, scope: !1330)
!1368 = !DILocation(line: 546, column: 9, scope: !1369)
!1369 = distinct !DILexicalBlock(scope: !1361, file: !6, line: 545, column: 76)
!1370 = !DILocation(line: 556, column: 12, scope: !1371)
!1371 = distinct !DILexicalBlock(scope: !1330, file: !6, line: 556, column: 5)
!1372 = !DILocation(line: 556, column: 10, scope: !1371)
!1373 = !DILocation(line: 556, column: 17, scope: !1374)
!1374 = distinct !DILexicalBlock(scope: !1371, file: !6, line: 556, column: 5)
!1375 = !DILocation(line: 556, column: 21, scope: !1374)
!1376 = !DILocation(line: 556, column: 19, scope: !1374)
!1377 = !DILocation(line: 556, column: 5, scope: !1371)
!1378 = !DILocation(line: 557, column: 48, scope: !1379)
!1379 = distinct !DILexicalBlock(scope: !1374, file: !6, line: 556, column: 31)
!1380 = !DILocation(line: 557, column: 56, scope: !1379)
!1381 = !DILocation(line: 557, column: 59, scope: !1379)
!1382 = !DILocation(line: 557, column: 27, scope: !1379)
!1383 = !DILocation(line: 557, column: 15, scope: !1379)
!1384 = !DILocation(line: 557, column: 13, scope: !1379)
!1385 = !DILocation(line: 558, column: 38, scope: !1379)
!1386 = !DILocation(line: 558, column: 46, scope: !1379)
!1387 = !DILocation(line: 558, column: 49, scope: !1379)
!1388 = !DILocation(line: 558, column: 17, scope: !1379)
!1389 = !DILocation(line: 558, column: 15, scope: !1379)
!1390 = !DILocation(line: 559, column: 13, scope: !1391)
!1391 = distinct !DILexicalBlock(scope: !1379, file: !6, line: 559, column: 13)
!1392 = !DILocation(line: 559, column: 17, scope: !1391)
!1393 = !DILocation(line: 559, column: 13, scope: !1379)
!1394 = !DILocation(line: 560, column: 27, scope: !1395)
!1395 = distinct !DILexicalBlock(scope: !1391, file: !6, line: 559, column: 23)
!1396 = !DILocation(line: 560, column: 25, scope: !1395)
!1397 = !DILocation(line: 561, column: 13, scope: !1395)
!1398 = !DILocation(line: 563, column: 5, scope: !1379)
!1399 = !DILocation(line: 556, column: 27, scope: !1374)
!1400 = !DILocation(line: 556, column: 5, scope: !1374)
!1401 = distinct !{!1401, !1377, !1402, !223}
!1402 = !DILocation(line: 563, column: 5, scope: !1371)
!1403 = !DILocation(line: 571, column: 12, scope: !1404)
!1404 = distinct !DILexicalBlock(scope: !1330, file: !6, line: 571, column: 5)
!1405 = !DILocation(line: 571, column: 10, scope: !1404)
!1406 = !DILocation(line: 571, column: 17, scope: !1407)
!1407 = distinct !DILexicalBlock(scope: !1404, file: !6, line: 571, column: 5)
!1408 = !DILocation(line: 571, column: 21, scope: !1407)
!1409 = !DILocation(line: 571, column: 19, scope: !1407)
!1410 = !DILocation(line: 571, column: 5, scope: !1404)
!1411 = !DILocation(line: 572, column: 14, scope: !1412)
!1412 = distinct !DILexicalBlock(scope: !1407, file: !6, line: 571, column: 31)
!1413 = !DILocation(line: 572, column: 18, scope: !1412)
!1414 = !DILocation(line: 572, column: 16, scope: !1412)
!1415 = !DILocation(line: 572, column: 34, scope: !1412)
!1416 = !DILocation(line: 572, column: 38, scope: !1412)
!1417 = !DILocation(line: 572, column: 31, scope: !1412)
!1418 = !DILocation(line: 572, column: 11, scope: !1412)
!1419 = !DILocation(line: 573, column: 48, scope: !1412)
!1420 = !DILocation(line: 573, column: 56, scope: !1412)
!1421 = !DILocation(line: 573, column: 59, scope: !1412)
!1422 = !DILocation(line: 573, column: 27, scope: !1412)
!1423 = !DILocation(line: 573, column: 15, scope: !1412)
!1424 = !DILocation(line: 573, column: 13, scope: !1412)
!1425 = !DILocation(line: 574, column: 38, scope: !1412)
!1426 = !DILocation(line: 574, column: 46, scope: !1412)
!1427 = !DILocation(line: 574, column: 49, scope: !1412)
!1428 = !DILocation(line: 574, column: 17, scope: !1412)
!1429 = !DILocation(line: 574, column: 15, scope: !1412)
!1430 = !DILocation(line: 575, column: 13, scope: !1431)
!1431 = distinct !DILexicalBlock(scope: !1412, file: !6, line: 575, column: 13)
!1432 = !DILocation(line: 575, column: 17, scope: !1431)
!1433 = !DILocation(line: 575, column: 22, scope: !1431)
!1434 = !DILocation(line: 575, column: 25, scope: !1431)
!1435 = !DILocation(line: 575, column: 31, scope: !1431)
!1436 = !DILocation(line: 575, column: 13, scope: !1412)
!1437 = !DILocation(line: 579, column: 34, scope: !1438)
!1438 = distinct !DILexicalBlock(scope: !1431, file: !6, line: 575, column: 40)
!1439 = !DILocation(line: 579, column: 39, scope: !1438)
!1440 = !DILocation(line: 579, column: 44, scope: !1438)
!1441 = !DILocation(line: 579, column: 19, scope: !1438)
!1442 = !DILocation(line: 579, column: 17, scope: !1438)
!1443 = !DILocation(line: 580, column: 17, scope: !1444)
!1444 = distinct !DILexicalBlock(scope: !1438, file: !6, line: 580, column: 17)
!1445 = !DILocation(line: 580, column: 21, scope: !1444)
!1446 = !DILocation(line: 580, column: 17, scope: !1438)
!1447 = !DILocation(line: 581, column: 39, scope: !1448)
!1448 = distinct !DILexicalBlock(scope: !1444, file: !6, line: 580, column: 42)
!1449 = !DILocation(line: 581, column: 47, scope: !1448)
!1450 = !DILocation(line: 581, column: 50, scope: !1448)
!1451 = !DILocation(line: 581, column: 17, scope: !1448)
!1452 = !DILocation(line: 582, column: 39, scope: !1448)
!1453 = !DILocation(line: 582, column: 47, scope: !1448)
!1454 = !DILocation(line: 582, column: 50, scope: !1448)
!1455 = !DILocation(line: 582, column: 17, scope: !1448)
!1456 = !DILocation(line: 583, column: 13, scope: !1448)
!1457 = !DILocation(line: 584, column: 13, scope: !1458)
!1458 = distinct !DILexicalBlock(scope: !1459, file: !6, line: 584, column: 13)
!1459 = distinct !DILexicalBlock(scope: !1438, file: !6, line: 584, column: 13)
!1460 = !DILocation(line: 584, column: 13, scope: !1459)
!1461 = !DILocation(line: 587, column: 9, scope: !1438)
!1462 = !DILocation(line: 587, column: 20, scope: !1463)
!1463 = distinct !DILexicalBlock(scope: !1431, file: !6, line: 587, column: 20)
!1464 = !DILocation(line: 587, column: 24, scope: !1463)
!1465 = !DILocation(line: 587, column: 29, scope: !1463)
!1466 = !DILocation(line: 587, column: 32, scope: !1463)
!1467 = !DILocation(line: 587, column: 38, scope: !1463)
!1468 = !DILocation(line: 587, column: 20, scope: !1431)
!1469 = !DILocation(line: 588, column: 35, scope: !1470)
!1470 = distinct !DILexicalBlock(scope: !1463, file: !6, line: 587, column: 47)
!1471 = !DILocation(line: 588, column: 43, scope: !1470)
!1472 = !DILocation(line: 588, column: 46, scope: !1470)
!1473 = !DILocation(line: 588, column: 13, scope: !1470)
!1474 = !DILocation(line: 589, column: 9, scope: !1470)
!1475 = !DILocation(line: 590, column: 5, scope: !1412)
!1476 = !DILocation(line: 571, column: 27, scope: !1407)
!1477 = !DILocation(line: 571, column: 5, scope: !1407)
!1478 = distinct !{!1478, !1410, !1479, !223}
!1479 = !DILocation(line: 590, column: 5, scope: !1404)
!1480 = !DILocation(line: 591, column: 26, scope: !1330)
!1481 = !DILocation(line: 591, column: 31, scope: !1330)
!1482 = !DILocation(line: 591, column: 5, scope: !1330)
!1483 = !DILabel(scope: !1330, name: "CLEANUP_EXIT", file: !6, line: 593)
!1484 = !DILocation(line: 593, column: 1, scope: !1330)
!1485 = !DILocation(line: 594, column: 5, scope: !1330)
!1486 = !DILocation(line: 594, column: 10, scope: !1330)
!1487 = !DILocation(line: 594, column: 21, scope: !1330)
!1488 = !DILocation(line: 595, column: 27, scope: !1330)
!1489 = !DILocation(line: 595, column: 32, scope: !1330)
!1490 = !DILocation(line: 595, column: 5, scope: !1330)
!1491 = !DILocation(line: 596, column: 1, scope: !1330)
!1492 = distinct !DISubprogram(name: "rwlock_write_acquire", scope: !107, file: !107, line: 45, type: !751, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1493 = !DILocalVariable(name: "l", arg: 1, scope: !1492, file: !107, line: 45, type: !731)
!1494 = !DILocation(line: 45, column: 32, scope: !1492)
!1495 = !DILocation(line: 47, column: 25, scope: !1492)
!1496 = !DILocation(line: 47, column: 28, scope: !1492)
!1497 = !DILocation(line: 47, column: 5, scope: !1492)
!1498 = !DILocalVariable(name: "i", scope: !1499, file: !107, line: 48, type: !14)
!1499 = distinct !DILexicalBlock(scope: !1492, file: !107, line: 48, column: 5)
!1500 = !DILocation(line: 48, column: 18, scope: !1499)
!1501 = !DILocation(line: 48, column: 10, scope: !1499)
!1502 = !DILocation(line: 48, column: 25, scope: !1503)
!1503 = distinct !DILexicalBlock(scope: !1499, file: !107, line: 48, column: 5)
!1504 = !DILocation(line: 48, column: 27, scope: !1503)
!1505 = !DILocation(line: 48, column: 5, scope: !1499)
!1506 = !DILocation(line: 49, column: 29, scope: !1507)
!1507 = distinct !DILexicalBlock(scope: !1503, file: !107, line: 48, column: 54)
!1508 = !DILocation(line: 49, column: 32, scope: !1507)
!1509 = !DILocation(line: 49, column: 37, scope: !1507)
!1510 = !DILocation(line: 49, column: 9, scope: !1507)
!1511 = !DILocation(line: 50, column: 5, scope: !1507)
!1512 = !DILocation(line: 48, column: 50, scope: !1503)
!1513 = !DILocation(line: 48, column: 5, scope: !1503)
!1514 = distinct !{!1514, !1505, !1515, !223}
!1515 = !DILocation(line: 50, column: 5, scope: !1499)
!1516 = !DILocation(line: 51, column: 1, scope: !1492)
!1517 = distinct !DISubprogram(name: "vatomicsz_read_rlx", scope: !777, file: !777, line: 277, type: !1518, scopeLine: 278, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1518 = !DISubroutineType(types: !1519)
!1519 = !{!14, !1520}
!1520 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1521, size: 64)
!1521 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !101)
!1522 = !DILocalVariable(name: "a", arg: 1, scope: !1517, file: !777, line: 277, type: !1520)
!1523 = !DILocation(line: 277, column: 39, scope: !1517)
!1524 = !DILocation(line: 279, column: 5, scope: !1517)
!1525 = !{i64 2148225431}
!1526 = !DILocalVariable(name: "tmp", scope: !1517, file: !777, line: 280, type: !14)
!1527 = !DILocation(line: 280, column: 13, scope: !1517)
!1528 = !DILocation(line: 280, column: 45, scope: !1517)
!1529 = !DILocation(line: 280, column: 48, scope: !1517)
!1530 = !DILocation(line: 280, column: 28, scope: !1517)
!1531 = !DILocation(line: 281, column: 5, scope: !1517)
!1532 = !{i64 2148225471}
!1533 = !DILocation(line: 282, column: 12, scope: !1517)
!1534 = !DILocation(line: 282, column: 5, scope: !1517)
!1535 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !777, file: !777, line: 319, type: !846, scopeLine: 320, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1536 = !DILocalVariable(name: "a", arg: 1, scope: !1535, file: !777, line: 319, type: !848)
!1537 = !DILocation(line: 319, column: 41, scope: !1535)
!1538 = !DILocation(line: 321, column: 5, scope: !1535)
!1539 = !{i64 2148225665}
!1540 = !DILocalVariable(name: "tmp", scope: !1535, file: !777, line: 322, type: !22)
!1541 = !DILocation(line: 322, column: 11, scope: !1535)
!1542 = !DILocation(line: 322, column: 42, scope: !1535)
!1543 = !DILocation(line: 322, column: 45, scope: !1535)
!1544 = !DILocation(line: 322, column: 25, scope: !1535)
!1545 = !DILocation(line: 323, column: 5, scope: !1535)
!1546 = !{i64 2148225705}
!1547 = !DILocation(line: 324, column: 12, scope: !1535)
!1548 = !DILocation(line: 324, column: 5, scope: !1535)
!1549 = distinct !DISubprogram(name: "vatomicptr_write_rlx", scope: !777, file: !777, line: 558, type: !1550, scopeLine: 559, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1550 = !DISubroutineType(types: !1551)
!1551 = !{null, !866, !22}
!1552 = !DILocalVariable(name: "a", arg: 1, scope: !1549, file: !777, line: 558, type: !866)
!1553 = !DILocation(line: 558, column: 36, scope: !1549)
!1554 = !DILocalVariable(name: "v", arg: 2, scope: !1549, file: !777, line: 558, type: !22)
!1555 = !DILocation(line: 558, column: 45, scope: !1549)
!1556 = !DILocation(line: 560, column: 5, scope: !1549)
!1557 = !{i64 2148227069}
!1558 = !DILocation(line: 561, column: 23, scope: !1549)
!1559 = !DILocation(line: 561, column: 26, scope: !1549)
!1560 = !DILocation(line: 561, column: 30, scope: !1549)
!1561 = !DILocation(line: 561, column: 5, scope: !1549)
!1562 = !DILocation(line: 562, column: 5, scope: !1549)
!1563 = !{i64 2148227109}
!1564 = !DILocation(line: 563, column: 1, scope: !1549)
!1565 = distinct !DISubprogram(name: "vatomicsz_write_rlx", scope: !777, file: !777, line: 519, type: !1566, scopeLine: 520, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1566 = !DISubroutineType(types: !1567)
!1567 = !{null, !1276, !14}
!1568 = !DILocalVariable(name: "a", arg: 1, scope: !1565, file: !777, line: 519, type: !1276)
!1569 = !DILocation(line: 519, column: 34, scope: !1565)
!1570 = !DILocalVariable(name: "v", arg: 2, scope: !1565, file: !777, line: 519, type: !14)
!1571 = !DILocation(line: 519, column: 45, scope: !1565)
!1572 = !DILocation(line: 521, column: 5, scope: !1565)
!1573 = !{i64 2148226835}
!1574 = !DILocation(line: 522, column: 23, scope: !1565)
!1575 = !DILocation(line: 522, column: 26, scope: !1565)
!1576 = !DILocation(line: 522, column: 30, scope: !1565)
!1577 = !DILocation(line: 522, column: 5, scope: !1565)
!1578 = !DILocation(line: 523, column: 5, scope: !1565)
!1579 = !{i64 2148226875}
!1580 = !DILocation(line: 524, column: 1, scope: !1565)
!1581 = distinct !DISubprogram(name: "rwlock_write_release", scope: !107, file: !107, line: 58, type: !751, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1582 = !DILocalVariable(name: "l", arg: 1, scope: !1581, file: !107, line: 58, type: !731)
!1583 = !DILocation(line: 58, column: 32, scope: !1581)
!1584 = !DILocation(line: 60, column: 25, scope: !1581)
!1585 = !DILocation(line: 60, column: 28, scope: !1581)
!1586 = !DILocation(line: 60, column: 5, scope: !1581)
!1587 = !DILocalVariable(name: "i", scope: !1588, file: !107, line: 61, type: !14)
!1588 = distinct !DILexicalBlock(scope: !1581, file: !107, line: 61, column: 5)
!1589 = !DILocation(line: 61, column: 18, scope: !1588)
!1590 = !DILocation(line: 61, column: 10, scope: !1588)
!1591 = !DILocation(line: 61, column: 25, scope: !1592)
!1592 = distinct !DILexicalBlock(scope: !1588, file: !107, line: 61, column: 5)
!1593 = !DILocation(line: 61, column: 27, scope: !1592)
!1594 = !DILocation(line: 61, column: 5, scope: !1588)
!1595 = !DILocation(line: 62, column: 31, scope: !1596)
!1596 = distinct !DILexicalBlock(scope: !1592, file: !107, line: 61, column: 54)
!1597 = !DILocation(line: 62, column: 34, scope: !1596)
!1598 = !DILocation(line: 62, column: 39, scope: !1596)
!1599 = !DILocation(line: 62, column: 9, scope: !1596)
!1600 = !DILocation(line: 63, column: 5, scope: !1596)
!1601 = !DILocation(line: 61, column: 50, scope: !1592)
!1602 = !DILocation(line: 61, column: 5, scope: !1592)
!1603 = distinct !{!1603, !1594, !1604, !223}
!1604 = !DILocation(line: 63, column: 5, scope: !1588)
!1605 = !DILocation(line: 64, column: 1, scope: !1581)
!1606 = distinct !DISubprogram(name: "vatomic8_write_rlx", scope: !777, file: !777, line: 363, type: !1607, scopeLine: 364, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1607 = !DISubroutineType(types: !1608)
!1608 = !{null, !1609, !23}
!1609 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !144, size: 64)
!1610 = !DILocalVariable(name: "a", arg: 1, scope: !1606, file: !777, line: 363, type: !1609)
!1611 = !DILocation(line: 363, column: 32, scope: !1606)
!1612 = !DILocalVariable(name: "v", arg: 2, scope: !1606, file: !777, line: 363, type: !23)
!1613 = !DILocation(line: 363, column: 44, scope: !1606)
!1614 = !DILocation(line: 365, column: 5, scope: !1606)
!1615 = !{i64 2148225899}
!1616 = !DILocation(line: 366, column: 23, scope: !1606)
!1617 = !DILocation(line: 366, column: 26, scope: !1606)
!1618 = !DILocation(line: 366, column: 30, scope: !1606)
!1619 = !DILocation(line: 366, column: 5, scope: !1606)
!1620 = !DILocation(line: 367, column: 5, scope: !1606)
!1621 = !{i64 2148225939}
!1622 = !DILocation(line: 368, column: 1, scope: !1606)
!1623 = distinct !DISubprogram(name: "create_threads", scope: !34, file: !34, line: 91, type: !1624, scopeLine: 93, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1624 = !DISubroutineType(types: !1625)
!1625 = !{null, !32, !14, !45, !42}
!1626 = !DILocalVariable(name: "threads", arg: 1, scope: !1623, file: !34, line: 91, type: !32)
!1627 = !DILocation(line: 91, column: 28, scope: !1623)
!1628 = !DILocalVariable(name: "num_threads", arg: 2, scope: !1623, file: !34, line: 91, type: !14)
!1629 = !DILocation(line: 91, column: 45, scope: !1623)
!1630 = !DILocalVariable(name: "fun", arg: 3, scope: !1623, file: !34, line: 91, type: !45)
!1631 = !DILocation(line: 91, column: 71, scope: !1623)
!1632 = !DILocalVariable(name: "bind", arg: 4, scope: !1623, file: !34, line: 92, type: !42)
!1633 = !DILocation(line: 92, column: 24, scope: !1623)
!1634 = !DILocalVariable(name: "i", scope: !1623, file: !34, line: 94, type: !14)
!1635 = !DILocation(line: 94, column: 13, scope: !1623)
!1636 = !DILocation(line: 95, column: 12, scope: !1637)
!1637 = distinct !DILexicalBlock(scope: !1623, file: !34, line: 95, column: 5)
!1638 = !DILocation(line: 95, column: 10, scope: !1637)
!1639 = !DILocation(line: 95, column: 17, scope: !1640)
!1640 = distinct !DILexicalBlock(scope: !1637, file: !34, line: 95, column: 5)
!1641 = !DILocation(line: 95, column: 21, scope: !1640)
!1642 = !DILocation(line: 95, column: 19, scope: !1640)
!1643 = !DILocation(line: 95, column: 5, scope: !1637)
!1644 = !DILocation(line: 96, column: 40, scope: !1645)
!1645 = distinct !DILexicalBlock(scope: !1640, file: !34, line: 95, column: 39)
!1646 = !DILocation(line: 96, column: 9, scope: !1645)
!1647 = !DILocation(line: 96, column: 17, scope: !1645)
!1648 = !DILocation(line: 96, column: 20, scope: !1645)
!1649 = !DILocation(line: 96, column: 38, scope: !1645)
!1650 = !DILocation(line: 97, column: 40, scope: !1645)
!1651 = !DILocation(line: 97, column: 9, scope: !1645)
!1652 = !DILocation(line: 97, column: 17, scope: !1645)
!1653 = !DILocation(line: 97, column: 20, scope: !1645)
!1654 = !DILocation(line: 97, column: 38, scope: !1645)
!1655 = !DILocation(line: 98, column: 40, scope: !1645)
!1656 = !DILocation(line: 98, column: 9, scope: !1645)
!1657 = !DILocation(line: 98, column: 17, scope: !1645)
!1658 = !DILocation(line: 98, column: 20, scope: !1645)
!1659 = !DILocation(line: 98, column: 38, scope: !1645)
!1660 = !DILocation(line: 99, column: 25, scope: !1645)
!1661 = !DILocation(line: 99, column: 33, scope: !1645)
!1662 = !DILocation(line: 99, column: 36, scope: !1645)
!1663 = !DILocation(line: 99, column: 55, scope: !1645)
!1664 = !DILocation(line: 99, column: 63, scope: !1645)
!1665 = !DILocation(line: 99, column: 54, scope: !1645)
!1666 = !DILocation(line: 99, column: 9, scope: !1645)
!1667 = !DILocation(line: 100, column: 5, scope: !1645)
!1668 = !DILocation(line: 95, column: 35, scope: !1640)
!1669 = !DILocation(line: 95, column: 5, scope: !1640)
!1670 = distinct !{!1670, !1643, !1671, !223}
!1671 = !DILocation(line: 100, column: 5, scope: !1637)
!1672 = !DILocation(line: 102, column: 1, scope: !1623)
!1673 = distinct !DISubprogram(name: "await_threads", scope: !34, file: !34, line: 105, type: !1674, scopeLine: 106, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1674 = !DISubroutineType(types: !1675)
!1675 = !{null, !32, !14}
!1676 = !DILocalVariable(name: "threads", arg: 1, scope: !1673, file: !34, line: 105, type: !32)
!1677 = !DILocation(line: 105, column: 27, scope: !1673)
!1678 = !DILocalVariable(name: "num_threads", arg: 2, scope: !1673, file: !34, line: 105, type: !14)
!1679 = !DILocation(line: 105, column: 44, scope: !1673)
!1680 = !DILocalVariable(name: "i", scope: !1673, file: !34, line: 107, type: !14)
!1681 = !DILocation(line: 107, column: 13, scope: !1673)
!1682 = !DILocation(line: 108, column: 12, scope: !1683)
!1683 = distinct !DILexicalBlock(scope: !1673, file: !34, line: 108, column: 5)
!1684 = !DILocation(line: 108, column: 10, scope: !1683)
!1685 = !DILocation(line: 108, column: 17, scope: !1686)
!1686 = distinct !DILexicalBlock(scope: !1683, file: !34, line: 108, column: 5)
!1687 = !DILocation(line: 108, column: 21, scope: !1686)
!1688 = !DILocation(line: 108, column: 19, scope: !1686)
!1689 = !DILocation(line: 108, column: 5, scope: !1683)
!1690 = !DILocation(line: 109, column: 22, scope: !1691)
!1691 = distinct !DILexicalBlock(scope: !1686, file: !34, line: 108, column: 39)
!1692 = !DILocation(line: 109, column: 30, scope: !1691)
!1693 = !DILocation(line: 109, column: 33, scope: !1691)
!1694 = !DILocation(line: 109, column: 9, scope: !1691)
!1695 = !DILocation(line: 110, column: 5, scope: !1691)
!1696 = !DILocation(line: 108, column: 35, scope: !1686)
!1697 = !DILocation(line: 108, column: 5, scope: !1686)
!1698 = distinct !{!1698, !1689, !1699, !223}
!1699 = !DILocation(line: 110, column: 5, scope: !1683)
!1700 = !DILocation(line: 111, column: 1, scope: !1673)
!1701 = distinct !DISubprogram(name: "common_run", scope: !34, file: !34, line: 51, type: !47, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1702 = !DILocalVariable(name: "args", arg: 1, scope: !1701, file: !34, line: 51, type: !22)
!1703 = !DILocation(line: 51, column: 18, scope: !1701)
!1704 = !DILocalVariable(name: "run_info", scope: !1701, file: !34, line: 53, type: !32)
!1705 = !DILocation(line: 53, column: 17, scope: !1701)
!1706 = !DILocation(line: 53, column: 42, scope: !1701)
!1707 = !DILocation(line: 53, column: 28, scope: !1701)
!1708 = !DILocation(line: 55, column: 9, scope: !1709)
!1709 = distinct !DILexicalBlock(scope: !1701, file: !34, line: 55, column: 9)
!1710 = !DILocation(line: 55, column: 19, scope: !1709)
!1711 = !DILocation(line: 55, column: 9, scope: !1701)
!1712 = !DILocation(line: 56, column: 26, scope: !1709)
!1713 = !DILocation(line: 56, column: 36, scope: !1709)
!1714 = !DILocation(line: 56, column: 9, scope: !1709)
!1715 = !DILocation(line: 60, column: 12, scope: !1701)
!1716 = !DILocation(line: 60, column: 22, scope: !1701)
!1717 = !DILocation(line: 60, column: 38, scope: !1701)
!1718 = !DILocation(line: 60, column: 48, scope: !1701)
!1719 = !DILocation(line: 60, column: 30, scope: !1701)
!1720 = !DILocation(line: 60, column: 5, scope: !1701)
!1721 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !34, file: !34, line: 69, type: !274, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1722 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !1721, file: !34, line: 69, type: !14)
!1723 = !DILocation(line: 69, column: 26, scope: !1721)
!1724 = !DILocation(line: 86, column: 5, scope: !1721)
!1725 = !DILocation(line: 86, column: 5, scope: !1726)
!1726 = distinct !DILexicalBlock(scope: !1721, file: !34, line: 86, column: 5)
!1727 = !DILocation(line: 86, column: 5, scope: !1728)
!1728 = distinct !DILexicalBlock(scope: !1726, file: !34, line: 86, column: 5)
!1729 = !DILocation(line: 86, column: 5, scope: !1730)
!1730 = distinct !DILexicalBlock(scope: !1728, file: !34, line: 86, column: 5)
!1731 = !DILocation(line: 88, column: 1, scope: !1721)
!1732 = distinct !DISubprogram(name: "vsimpleht_thread_register", scope: !6, file: !6, line: 200, type: !597, scopeLine: 201, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1733 = !DILocalVariable(name: "tbl", arg: 1, scope: !1732, file: !6, line: 200, type: !554)
!1734 = !DILocation(line: 200, column: 40, scope: !1732)
!1735 = !DILocation(line: 205, column: 26, scope: !1732)
!1736 = !DILocation(line: 205, column: 31, scope: !1732)
!1737 = !DILocation(line: 205, column: 5, scope: !1732)
!1738 = !DILocation(line: 207, column: 1, scope: !1732)
!1739 = distinct !DISubprogram(name: "vsimpleht_thread_deregister", scope: !6, file: !6, line: 217, type: !597, scopeLine: 218, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1740 = !DILocalVariable(name: "tbl", arg: 1, scope: !1739, file: !6, line: 217, type: !554)
!1741 = !DILocation(line: 217, column: 42, scope: !1739)
!1742 = !DILocation(line: 222, column: 26, scope: !1739)
!1743 = !DILocation(line: 222, column: 31, scope: !1739)
!1744 = !DILocation(line: 222, column: 5, scope: !1739)
!1745 = !DILocation(line: 224, column: 1, scope: !1739)
!1746 = distinct !DISubprogram(name: "vsimpleht_buff_size", scope: !6, file: !6, line: 126, type: !1747, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1747 = !DISubroutineType(types: !1748)
!1748 = !{!14, !14}
!1749 = !DILocalVariable(name: "capacity", arg: 1, scope: !1746, file: !6, line: 126, type: !14)
!1750 = !DILocation(line: 126, column: 29, scope: !1746)
!1751 = !DILocation(line: 128, column: 5, scope: !1752)
!1752 = distinct !DILexicalBlock(scope: !1753, file: !6, line: 128, column: 5)
!1753 = distinct !DILexicalBlock(scope: !1746, file: !6, line: 128, column: 5)
!1754 = !DILocation(line: 128, column: 5, scope: !1753)
!1755 = !DILocation(line: 129, column: 5, scope: !1756)
!1756 = distinct !DILexicalBlock(scope: !1757, file: !6, line: 129, column: 5)
!1757 = distinct !DILexicalBlock(scope: !1746, file: !6, line: 129, column: 5)
!1758 = !DILocation(line: 129, column: 5, scope: !1757)
!1759 = !DILocation(line: 130, column: 40, scope: !1746)
!1760 = !DILocation(line: 130, column: 38, scope: !1746)
!1761 = !DILocation(line: 130, column: 5, scope: !1746)
!1762 = distinct !DISubprogram(name: "vsimpleht_init", scope: !6, file: !6, line: 146, type: !1763, scopeLine: 149, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1763 = !DISubroutineType(types: !1764)
!1764 = !{null, !554, !22, !14, !80, !90, !95}
!1765 = !DILocalVariable(name: "tbl", arg: 1, scope: !1762, file: !6, line: 146, type: !554)
!1766 = !DILocation(line: 146, column: 29, scope: !1762)
!1767 = !DILocalVariable(name: "buff", arg: 2, scope: !1762, file: !6, line: 146, type: !22)
!1768 = !DILocation(line: 146, column: 40, scope: !1762)
!1769 = !DILocalVariable(name: "capacity", arg: 3, scope: !1762, file: !6, line: 146, type: !14)
!1770 = !DILocation(line: 146, column: 54, scope: !1762)
!1771 = !DILocalVariable(name: "cmp_fun", arg: 4, scope: !1762, file: !6, line: 147, type: !80)
!1772 = !DILocation(line: 147, column: 36, scope: !1762)
!1773 = !DILocalVariable(name: "hash_fun", arg: 5, scope: !1762, file: !6, line: 147, type: !90)
!1774 = !DILocation(line: 147, column: 66, scope: !1762)
!1775 = !DILocalVariable(name: "destroy_cb", arg: 6, scope: !1762, file: !6, line: 148, type: !95)
!1776 = !DILocation(line: 148, column: 42, scope: !1762)
!1777 = !DILocation(line: 150, column: 5, scope: !1778)
!1778 = distinct !DILexicalBlock(scope: !1779, file: !6, line: 150, column: 5)
!1779 = distinct !DILexicalBlock(scope: !1762, file: !6, line: 150, column: 5)
!1780 = !DILocation(line: 150, column: 5, scope: !1779)
!1781 = !DILocation(line: 151, column: 5, scope: !1782)
!1782 = distinct !DILexicalBlock(scope: !1783, file: !6, line: 151, column: 5)
!1783 = distinct !DILexicalBlock(scope: !1762, file: !6, line: 151, column: 5)
!1784 = !DILocation(line: 151, column: 5, scope: !1783)
!1785 = !DILocation(line: 152, column: 5, scope: !1786)
!1786 = distinct !DILexicalBlock(scope: !1787, file: !6, line: 152, column: 5)
!1787 = distinct !DILexicalBlock(scope: !1762, file: !6, line: 152, column: 5)
!1788 = !DILocation(line: 152, column: 5, scope: !1787)
!1789 = !DILocation(line: 153, column: 5, scope: !1790)
!1790 = distinct !DILexicalBlock(scope: !1791, file: !6, line: 153, column: 5)
!1791 = distinct !DILexicalBlock(scope: !1762, file: !6, line: 153, column: 5)
!1792 = !DILocation(line: 153, column: 5, scope: !1791)
!1793 = !DILocation(line: 155, column: 23, scope: !1762)
!1794 = !DILocation(line: 155, column: 5, scope: !1762)
!1795 = !DILocation(line: 155, column: 10, scope: !1762)
!1796 = !DILocation(line: 155, column: 21, scope: !1762)
!1797 = !DILocation(line: 156, column: 23, scope: !1762)
!1798 = !DILocation(line: 156, column: 5, scope: !1762)
!1799 = !DILocation(line: 156, column: 10, scope: !1762)
!1800 = !DILocation(line: 156, column: 21, scope: !1762)
!1801 = !DILocation(line: 157, column: 23, scope: !1762)
!1802 = !DILocation(line: 157, column: 5, scope: !1762)
!1803 = !DILocation(line: 157, column: 10, scope: !1762)
!1804 = !DILocation(line: 157, column: 21, scope: !1762)
!1805 = !DILocation(line: 158, column: 23, scope: !1762)
!1806 = !DILocation(line: 158, column: 5, scope: !1762)
!1807 = !DILocation(line: 158, column: 10, scope: !1762)
!1808 = !DILocation(line: 158, column: 21, scope: !1762)
!1809 = !DILocation(line: 159, column: 23, scope: !1762)
!1810 = !DILocation(line: 159, column: 5, scope: !1762)
!1811 = !DILocation(line: 159, column: 10, scope: !1762)
!1812 = !DILocation(line: 159, column: 21, scope: !1762)
!1813 = !DILocalVariable(name: "i", scope: !1814, file: !6, line: 161, type: !14)
!1814 = distinct !DILexicalBlock(scope: !1762, file: !6, line: 161, column: 5)
!1815 = !DILocation(line: 161, column: 18, scope: !1814)
!1816 = !DILocation(line: 161, column: 10, scope: !1814)
!1817 = !DILocation(line: 161, column: 25, scope: !1818)
!1818 = distinct !DILexicalBlock(scope: !1814, file: !6, line: 161, column: 5)
!1819 = !DILocation(line: 161, column: 29, scope: !1818)
!1820 = !DILocation(line: 161, column: 34, scope: !1818)
!1821 = !DILocation(line: 161, column: 27, scope: !1818)
!1822 = !DILocation(line: 161, column: 5, scope: !1814)
!1823 = !DILocation(line: 162, column: 26, scope: !1824)
!1824 = distinct !DILexicalBlock(scope: !1818, file: !6, line: 161, column: 49)
!1825 = !DILocation(line: 162, column: 31, scope: !1824)
!1826 = !DILocation(line: 162, column: 39, scope: !1824)
!1827 = !DILocation(line: 162, column: 42, scope: !1824)
!1828 = !DILocation(line: 162, column: 9, scope: !1824)
!1829 = !DILocation(line: 163, column: 26, scope: !1824)
!1830 = !DILocation(line: 163, column: 31, scope: !1824)
!1831 = !DILocation(line: 163, column: 39, scope: !1824)
!1832 = !DILocation(line: 163, column: 42, scope: !1824)
!1833 = !DILocation(line: 163, column: 9, scope: !1824)
!1834 = !DILocation(line: 164, column: 5, scope: !1824)
!1835 = !DILocation(line: 161, column: 45, scope: !1818)
!1836 = !DILocation(line: 161, column: 5, scope: !1818)
!1837 = distinct !{!1837, !1822, !1838, !223}
!1838 = !DILocation(line: 164, column: 5, scope: !1814)
!1839 = !DILocation(line: 166, column: 32, scope: !1762)
!1840 = !DILocation(line: 166, column: 41, scope: !1762)
!1841 = !DILocation(line: 166, column: 5, scope: !1762)
!1842 = !DILocation(line: 166, column: 10, scope: !1762)
!1843 = !DILocation(line: 166, column: 29, scope: !1762)
!1844 = !DILocation(line: 167, column: 26, scope: !1762)
!1845 = !DILocation(line: 167, column: 31, scope: !1762)
!1846 = !DILocation(line: 167, column: 5, scope: !1762)
!1847 = !DILocation(line: 168, column: 18, scope: !1762)
!1848 = !DILocation(line: 168, column: 23, scope: !1762)
!1849 = !DILocation(line: 168, column: 5, scope: !1762)
!1850 = !DILocation(line: 170, column: 1, scope: !1762)
!1851 = distinct !DISubprogram(name: "cb_cmp", scope: !62, file: !62, line: 40, type: !82, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1852 = !DILocalVariable(name: "key_a", arg: 1, scope: !1851, file: !62, line: 40, type: !19)
!1853 = !DILocation(line: 40, column: 19, scope: !1851)
!1854 = !DILocalVariable(name: "key_b", arg: 2, scope: !1851, file: !62, line: 40, type: !19)
!1855 = !DILocation(line: 40, column: 37, scope: !1851)
!1856 = !DILocation(line: 42, column: 9, scope: !1857)
!1857 = distinct !DILexicalBlock(scope: !1851, file: !62, line: 42, column: 9)
!1858 = !DILocation(line: 42, column: 18, scope: !1857)
!1859 = !DILocation(line: 42, column: 15, scope: !1857)
!1860 = !DILocation(line: 42, column: 9, scope: !1851)
!1861 = !DILocation(line: 43, column: 9, scope: !1862)
!1862 = distinct !DILexicalBlock(scope: !1857, file: !62, line: 42, column: 25)
!1863 = !DILocation(line: 44, column: 16, scope: !1864)
!1864 = distinct !DILexicalBlock(scope: !1857, file: !62, line: 44, column: 16)
!1865 = !DILocation(line: 44, column: 24, scope: !1864)
!1866 = !DILocation(line: 44, column: 22, scope: !1864)
!1867 = !DILocation(line: 44, column: 16, scope: !1857)
!1868 = !DILocation(line: 45, column: 9, scope: !1869)
!1869 = distinct !DILexicalBlock(scope: !1864, file: !62, line: 44, column: 31)
!1870 = !DILocation(line: 47, column: 9, scope: !1871)
!1871 = distinct !DILexicalBlock(scope: !1864, file: !62, line: 46, column: 12)
!1872 = !DILocation(line: 49, column: 1, scope: !1851)
!1873 = distinct !DISubprogram(name: "cb_hash", scope: !62, file: !62, line: 53, type: !92, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1874 = !DILocalVariable(name: "key", arg: 1, scope: !1873, file: !62, line: 53, type: !19)
!1875 = !DILocation(line: 53, column: 20, scope: !1873)
!1876 = !DILocation(line: 55, column: 23, scope: !1873)
!1877 = !DILocation(line: 55, column: 5, scope: !1873)
!1878 = distinct !DISubprogram(name: "cb_destroy", scope: !62, file: !62, line: 71, type: !97, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1879 = !DILocalVariable(name: "data", arg: 1, scope: !1878, file: !62, line: 71, type: !22)
!1880 = !DILocation(line: 71, column: 18, scope: !1878)
!1881 = !DILocation(line: 73, column: 10, scope: !1878)
!1882 = !DILocation(line: 73, column: 5, scope: !1878)
!1883 = !DILocation(line: 74, column: 1, scope: !1878)
!1884 = distinct !DISubprogram(name: "trace_init", scope: !157, file: !157, line: 34, type: !1885, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1885 = !DISubroutineType(types: !1886)
!1886 = !{null, !579, !14}
!1887 = !DILocalVariable(name: "trace", arg: 1, scope: !1884, file: !157, line: 34, type: !579)
!1888 = !DILocation(line: 34, column: 21, scope: !1884)
!1889 = !DILocalVariable(name: "capacity", arg: 2, scope: !1884, file: !157, line: 34, type: !14)
!1890 = !DILocation(line: 34, column: 36, scope: !1884)
!1891 = !DILocation(line: 36, column: 5, scope: !1892)
!1892 = distinct !DILexicalBlock(scope: !1893, file: !157, line: 36, column: 5)
!1893 = distinct !DILexicalBlock(scope: !1884, file: !157, line: 36, column: 5)
!1894 = !DILocation(line: 36, column: 5, scope: !1893)
!1895 = !DILocation(line: 37, column: 27, scope: !1884)
!1896 = !DILocation(line: 37, column: 36, scope: !1884)
!1897 = !DILocation(line: 37, column: 20, scope: !1884)
!1898 = !DILocation(line: 37, column: 5, scope: !1884)
!1899 = !DILocation(line: 37, column: 12, scope: !1884)
!1900 = !DILocation(line: 37, column: 18, scope: !1884)
!1901 = !DILocation(line: 38, column: 9, scope: !1902)
!1902 = distinct !DILexicalBlock(scope: !1884, file: !157, line: 38, column: 9)
!1903 = !DILocation(line: 38, column: 16, scope: !1902)
!1904 = !DILocation(line: 38, column: 9, scope: !1884)
!1905 = !DILocation(line: 39, column: 9, scope: !1906)
!1906 = distinct !DILexicalBlock(scope: !1902, file: !157, line: 38, column: 23)
!1907 = !DILocation(line: 39, column: 16, scope: !1906)
!1908 = !DILocation(line: 39, column: 28, scope: !1906)
!1909 = !DILocation(line: 40, column: 30, scope: !1906)
!1910 = !DILocation(line: 40, column: 9, scope: !1906)
!1911 = !DILocation(line: 40, column: 16, scope: !1906)
!1912 = !DILocation(line: 40, column: 28, scope: !1906)
!1913 = !DILocation(line: 41, column: 9, scope: !1906)
!1914 = !DILocation(line: 41, column: 16, scope: !1906)
!1915 = !DILocation(line: 41, column: 28, scope: !1906)
!1916 = !DILocation(line: 42, column: 5, scope: !1906)
!1917 = !DILocation(line: 43, column: 9, scope: !1918)
!1918 = distinct !DILexicalBlock(scope: !1902, file: !157, line: 42, column: 12)
!1919 = !DILocation(line: 43, column: 16, scope: !1918)
!1920 = !DILocation(line: 43, column: 28, scope: !1918)
!1921 = !DILocation(line: 44, column: 9, scope: !1918)
!1922 = !DILocation(line: 44, column: 16, scope: !1918)
!1923 = !DILocation(line: 44, column: 28, scope: !1918)
!1924 = !DILocation(line: 45, column: 9, scope: !1918)
!1925 = !DILocation(line: 45, column: 16, scope: !1918)
!1926 = !DILocation(line: 45, column: 28, scope: !1918)
!1927 = !DILocation(line: 46, column: 9, scope: !1928)
!1928 = distinct !DILexicalBlock(scope: !1929, file: !157, line: 46, column: 9)
!1929 = distinct !DILexicalBlock(scope: !1918, file: !157, line: 46, column: 9)
!1930 = !DILocation(line: 48, column: 1, scope: !1884)
!1931 = distinct !DISubprogram(name: "vatomicptr_init", scope: !817, file: !817, line: 4223, type: !1550, scopeLine: 4224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1932 = !DILocalVariable(name: "a", arg: 1, scope: !1931, file: !817, line: 4223, type: !866)
!1933 = !DILocation(line: 4223, column: 31, scope: !1931)
!1934 = !DILocalVariable(name: "v", arg: 2, scope: !1931, file: !817, line: 4223, type: !22)
!1935 = !DILocation(line: 4223, column: 40, scope: !1931)
!1936 = !DILocation(line: 4225, column: 22, scope: !1931)
!1937 = !DILocation(line: 4225, column: 25, scope: !1931)
!1938 = !DILocation(line: 4225, column: 5, scope: !1931)
!1939 = !DILocation(line: 4226, column: 1, scope: !1931)
!1940 = distinct !DISubprogram(name: "rwlock_init", scope: !107, file: !107, line: 33, type: !751, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1941 = !DILocalVariable(name: "l", arg: 1, scope: !1940, file: !107, line: 33, type: !731)
!1942 = !DILocation(line: 33, column: 23, scope: !1940)
!1943 = !DILocalVariable(name: "i", scope: !1944, file: !107, line: 35, type: !14)
!1944 = distinct !DILexicalBlock(scope: !1940, file: !107, line: 35, column: 5)
!1945 = !DILocation(line: 35, column: 18, scope: !1944)
!1946 = !DILocation(line: 35, column: 10, scope: !1944)
!1947 = !DILocation(line: 35, column: 25, scope: !1948)
!1948 = distinct !DILexicalBlock(scope: !1944, file: !107, line: 35, column: 5)
!1949 = !DILocation(line: 35, column: 27, scope: !1948)
!1950 = !DILocation(line: 35, column: 5, scope: !1944)
!1951 = !DILocation(line: 36, column: 29, scope: !1952)
!1952 = distinct !DILexicalBlock(scope: !1948, file: !107, line: 35, column: 54)
!1953 = !DILocation(line: 36, column: 32, scope: !1952)
!1954 = !DILocation(line: 36, column: 37, scope: !1952)
!1955 = !DILocation(line: 36, column: 9, scope: !1952)
!1956 = !DILocation(line: 37, column: 5, scope: !1952)
!1957 = !DILocation(line: 35, column: 50, scope: !1948)
!1958 = !DILocation(line: 35, column: 5, scope: !1948)
!1959 = distinct !{!1959, !1950, !1960, !223}
!1960 = !DILocation(line: 37, column: 5, scope: !1944)
!1961 = !DILocation(line: 38, column: 1, scope: !1940)
!1962 = distinct !DISubprogram(name: "vatomicptr_write", scope: !777, file: !777, line: 532, type: !1550, scopeLine: 533, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1963 = !DILocalVariable(name: "a", arg: 1, scope: !1962, file: !777, line: 532, type: !866)
!1964 = !DILocation(line: 532, column: 32, scope: !1962)
!1965 = !DILocalVariable(name: "v", arg: 2, scope: !1962, file: !777, line: 532, type: !22)
!1966 = !DILocation(line: 532, column: 41, scope: !1962)
!1967 = !DILocation(line: 534, column: 5, scope: !1962)
!1968 = !{i64 2148226913}
!1969 = !DILocation(line: 535, column: 23, scope: !1962)
!1970 = !DILocation(line: 535, column: 26, scope: !1962)
!1971 = !DILocation(line: 535, column: 30, scope: !1962)
!1972 = !DILocation(line: 535, column: 5, scope: !1962)
!1973 = !DILocation(line: 536, column: 5, scope: !1962)
!1974 = !{i64 2148226953}
!1975 = !DILocation(line: 537, column: 1, scope: !1962)
!1976 = distinct !DISubprogram(name: "_imap_verify", scope: !62, file: !62, line: 77, type: !185, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!1977 = !DILocalVariable(name: "key", scope: !1976, file: !62, line: 79, type: !19)
!1978 = !DILocation(line: 79, column: 16, scope: !1976)
!1979 = !DILocalVariable(name: "data", scope: !1976, file: !62, line: 80, type: !235)
!1980 = !DILocation(line: 80, column: 13, scope: !1976)
!1981 = !DILocalVariable(name: "iter", scope: !1976, file: !62, line: 81, type: !1982)
!1982 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_iter_t", file: !6, line: 99, baseType: !1983)
!1983 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vsimpleht_iter_s", file: !6, line: 96, size: 128, elements: !1984)
!1984 = !{!1985, !1986}
!1985 = !DIDerivedType(tag: DW_TAG_member, name: "tbl", scope: !1983, file: !6, line: 97, baseType: !554, size: 64)
!1986 = !DIDerivedType(tag: DW_TAG_member, name: "idx", scope: !1983, file: !6, line: 98, baseType: !14, size: 64, offset: 64)
!1987 = !DILocation(line: 81, column: 22, scope: !1976)
!1988 = !DILocalVariable(name: "add_trc", scope: !1976, file: !62, line: 83, type: !156)
!1989 = !DILocation(line: 83, column: 13, scope: !1976)
!1990 = !DILocalVariable(name: "rem_trc", scope: !1976, file: !62, line: 84, type: !156)
!1991 = !DILocation(line: 84, column: 13, scope: !1976)
!1992 = !DILocalVariable(name: "final_state_trc", scope: !1976, file: !62, line: 85, type: !156)
!1993 = !DILocation(line: 85, column: 13, scope: !1976)
!1994 = !DILocation(line: 87, column: 5, scope: !1976)
!1995 = !DILocation(line: 88, column: 5, scope: !1976)
!1996 = !DILocalVariable(name: "i", scope: !1997, file: !62, line: 91, type: !14)
!1997 = distinct !DILexicalBlock(scope: !1976, file: !62, line: 91, column: 5)
!1998 = !DILocation(line: 91, column: 18, scope: !1997)
!1999 = !DILocation(line: 91, column: 10, scope: !1997)
!2000 = !DILocation(line: 91, column: 25, scope: !2001)
!2001 = distinct !DILexicalBlock(scope: !1997, file: !62, line: 91, column: 5)
!2002 = !DILocation(line: 91, column: 27, scope: !2001)
!2003 = !DILocation(line: 91, column: 5, scope: !1997)
!2004 = !DILocation(line: 92, column: 43, scope: !2005)
!2005 = distinct !DILexicalBlock(scope: !2001, file: !62, line: 91, column: 43)
!2006 = !DILocation(line: 92, column: 37, scope: !2005)
!2007 = !DILocation(line: 92, column: 9, scope: !2005)
!2008 = !DILocation(line: 93, column: 43, scope: !2005)
!2009 = !DILocation(line: 93, column: 37, scope: !2005)
!2010 = !DILocation(line: 93, column: 9, scope: !2005)
!2011 = !DILocation(line: 94, column: 5, scope: !2005)
!2012 = !DILocation(line: 91, column: 39, scope: !2001)
!2013 = !DILocation(line: 91, column: 5, scope: !2001)
!2014 = distinct !{!2014, !2003, !2015, !223}
!2015 = !DILocation(line: 94, column: 5, scope: !1997)
!2016 = !DILocation(line: 97, column: 5, scope: !1976)
!2017 = !DILocation(line: 98, column: 5, scope: !1976)
!2018 = !DILocation(line: 99, column: 5, scope: !1976)
!2019 = !DILocation(line: 99, column: 45, scope: !1976)
!2020 = !DILocation(line: 99, column: 12, scope: !1976)
!2021 = !DILocation(line: 100, column: 37, scope: !2022)
!2022 = distinct !DILexicalBlock(scope: !1976, file: !62, line: 99, column: 62)
!2023 = !DILocation(line: 100, column: 9, scope: !2022)
!2024 = distinct !{!2024, !2018, !2025, !223}
!2025 = !DILocation(line: 101, column: 5, scope: !1976)
!2026 = !DILocation(line: 103, column: 5, scope: !1976)
!2027 = !DILocalVariable(name: "eq", scope: !1976, file: !62, line: 104, type: !42)
!2028 = !DILocation(line: 104, column: 13, scope: !1976)
!2029 = !DILocation(line: 104, column: 18, scope: !1976)
!2030 = !DILocation(line: 106, column: 5, scope: !1976)
!2031 = !DILocation(line: 107, column: 5, scope: !1976)
!2032 = !DILocation(line: 108, column: 5, scope: !1976)
!2033 = !DILocation(line: 109, column: 5, scope: !2034)
!2034 = distinct !DILexicalBlock(scope: !2035, file: !62, line: 109, column: 5)
!2035 = distinct !DILexicalBlock(scope: !1976, file: !62, line: 109, column: 5)
!2036 = !DILocation(line: 109, column: 5, scope: !2035)
!2037 = !DILocation(line: 110, column: 1, scope: !1976)
!2038 = distinct !DISubprogram(name: "trace_destroy", scope: !157, file: !157, line: 98, type: !1022, scopeLine: 99, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!2039 = !DILocalVariable(name: "trace", arg: 1, scope: !2038, file: !157, line: 98, type: !579)
!2040 = !DILocation(line: 98, column: 24, scope: !2038)
!2041 = !DILocation(line: 100, column: 5, scope: !2042)
!2042 = distinct !DILexicalBlock(scope: !2043, file: !157, line: 100, column: 5)
!2043 = distinct !DILexicalBlock(scope: !2038, file: !157, line: 100, column: 5)
!2044 = !DILocation(line: 100, column: 5, scope: !2043)
!2045 = !DILocation(line: 101, column: 5, scope: !2046)
!2046 = distinct !DILexicalBlock(scope: !2047, file: !157, line: 101, column: 5)
!2047 = distinct !DILexicalBlock(scope: !2038, file: !157, line: 101, column: 5)
!2048 = !DILocation(line: 101, column: 5, scope: !2047)
!2049 = !DILocation(line: 102, column: 10, scope: !2038)
!2050 = !DILocation(line: 102, column: 17, scope: !2038)
!2051 = !DILocation(line: 102, column: 5, scope: !2038)
!2052 = !DILocation(line: 103, column: 5, scope: !2038)
!2053 = !DILocation(line: 103, column: 12, scope: !2038)
!2054 = !DILocation(line: 103, column: 24, scope: !2038)
!2055 = !DILocation(line: 104, column: 1, scope: !2038)
!2056 = distinct !DISubprogram(name: "vsimpleht_destroy", scope: !6, file: !6, line: 178, type: !597, scopeLine: 179, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!2057 = !DILocalVariable(name: "tbl", arg: 1, scope: !2056, file: !6, line: 178, type: !554)
!2058 = !DILocation(line: 178, column: 32, scope: !2056)
!2059 = !DILocalVariable(name: "entry", scope: !2056, file: !6, line: 180, type: !68)
!2060 = !DILocation(line: 180, column: 24, scope: !2056)
!2061 = !DILocalVariable(name: "obj", scope: !2056, file: !6, line: 181, type: !22)
!2062 = !DILocation(line: 181, column: 11, scope: !2056)
!2063 = !DILocation(line: 182, column: 5, scope: !2064)
!2064 = distinct !DILexicalBlock(scope: !2065, file: !6, line: 182, column: 5)
!2065 = distinct !DILexicalBlock(scope: !2056, file: !6, line: 182, column: 5)
!2066 = !DILocation(line: 182, column: 5, scope: !2065)
!2067 = !DILocalVariable(name: "i", scope: !2068, file: !6, line: 183, type: !14)
!2068 = distinct !DILexicalBlock(scope: !2056, file: !6, line: 183, column: 5)
!2069 = !DILocation(line: 183, column: 18, scope: !2068)
!2070 = !DILocation(line: 183, column: 10, scope: !2068)
!2071 = !DILocation(line: 183, column: 25, scope: !2072)
!2072 = distinct !DILexicalBlock(scope: !2068, file: !6, line: 183, column: 5)
!2073 = !DILocation(line: 183, column: 29, scope: !2072)
!2074 = !DILocation(line: 183, column: 34, scope: !2072)
!2075 = !DILocation(line: 183, column: 27, scope: !2072)
!2076 = !DILocation(line: 183, column: 5, scope: !2068)
!2077 = !DILocation(line: 184, column: 18, scope: !2078)
!2078 = distinct !DILexicalBlock(scope: !2072, file: !6, line: 183, column: 49)
!2079 = !DILocation(line: 184, column: 23, scope: !2078)
!2080 = !DILocation(line: 184, column: 31, scope: !2078)
!2081 = !DILocation(line: 184, column: 15, scope: !2078)
!2082 = !DILocation(line: 185, column: 38, scope: !2078)
!2083 = !DILocation(line: 185, column: 45, scope: !2078)
!2084 = !DILocation(line: 185, column: 17, scope: !2078)
!2085 = !DILocation(line: 185, column: 15, scope: !2078)
!2086 = !DILocation(line: 186, column: 13, scope: !2087)
!2087 = distinct !DILexicalBlock(scope: !2078, file: !6, line: 186, column: 13)
!2088 = !DILocation(line: 186, column: 13, scope: !2078)
!2089 = !DILocation(line: 187, column: 13, scope: !2090)
!2090 = distinct !DILexicalBlock(scope: !2087, file: !6, line: 186, column: 18)
!2091 = !DILocation(line: 187, column: 18, scope: !2090)
!2092 = !DILocation(line: 187, column: 29, scope: !2090)
!2093 = !DILocation(line: 188, column: 9, scope: !2090)
!2094 = !DILocation(line: 189, column: 5, scope: !2078)
!2095 = !DILocation(line: 183, column: 45, scope: !2072)
!2096 = !DILocation(line: 183, column: 5, scope: !2072)
!2097 = distinct !{!2097, !2076, !2098, !223}
!2098 = !DILocation(line: 189, column: 5, scope: !2068)
!2099 = !DILocation(line: 190, column: 1, scope: !2056)
!2100 = distinct !DISubprogram(name: "trace_merge_into", scope: !157, file: !157, line: 177, type: !2101, scopeLine: 178, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!2101 = !DISubroutineType(types: !2102)
!2102 = !{null, !579, !579}
!2103 = !DILocalVariable(name: "trace_container", arg: 1, scope: !2100, file: !157, line: 177, type: !579)
!2104 = !DILocation(line: 177, column: 27, scope: !2100)
!2105 = !DILocalVariable(name: "trace", arg: 2, scope: !2100, file: !157, line: 177, type: !579)
!2106 = !DILocation(line: 177, column: 53, scope: !2100)
!2107 = !DILocation(line: 179, column: 30, scope: !2100)
!2108 = !DILocation(line: 179, column: 47, scope: !2100)
!2109 = !DILocation(line: 179, column: 5, scope: !2100)
!2110 = !DILocation(line: 180, column: 1, scope: !2100)
!2111 = distinct !DISubprogram(name: "vsimpleht_iter_init", scope: !6, file: !6, line: 280, type: !2112, scopeLine: 281, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!2112 = !DISubroutineType(types: !2113)
!2113 = !{null, !554, !2114}
!2114 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1982, size: 64)
!2115 = !DILocalVariable(name: "tbl", arg: 1, scope: !2111, file: !6, line: 280, type: !554)
!2116 = !DILocation(line: 280, column: 34, scope: !2111)
!2117 = !DILocalVariable(name: "iter", arg: 2, scope: !2111, file: !6, line: 280, type: !2114)
!2118 = !DILocation(line: 280, column: 57, scope: !2111)
!2119 = !DILocation(line: 282, column: 5, scope: !2120)
!2120 = distinct !DILexicalBlock(scope: !2121, file: !6, line: 282, column: 5)
!2121 = distinct !DILexicalBlock(scope: !2111, file: !6, line: 282, column: 5)
!2122 = !DILocation(line: 282, column: 5, scope: !2121)
!2123 = !DILocation(line: 283, column: 5, scope: !2124)
!2124 = distinct !DILexicalBlock(scope: !2125, file: !6, line: 283, column: 5)
!2125 = distinct !DILexicalBlock(scope: !2111, file: !6, line: 283, column: 5)
!2126 = !DILocation(line: 283, column: 5, scope: !2125)
!2127 = !DILocation(line: 284, column: 17, scope: !2111)
!2128 = !DILocation(line: 284, column: 5, scope: !2111)
!2129 = !DILocation(line: 284, column: 11, scope: !2111)
!2130 = !DILocation(line: 284, column: 15, scope: !2111)
!2131 = !DILocation(line: 285, column: 5, scope: !2111)
!2132 = !DILocation(line: 285, column: 11, scope: !2111)
!2133 = !DILocation(line: 285, column: 15, scope: !2111)
!2134 = !DILocation(line: 286, column: 1, scope: !2111)
!2135 = distinct !DISubprogram(name: "vsimpleht_iter_next", scope: !6, file: !6, line: 317, type: !2136, scopeLine: 318, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!2136 = !DISubroutineType(types: !2137)
!2137 = !{!42, !2114, !2138, !52}
!2138 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!2139 = !DILocalVariable(name: "iter", arg: 1, scope: !2135, file: !6, line: 317, type: !2114)
!2140 = !DILocation(line: 317, column: 39, scope: !2135)
!2141 = !DILocalVariable(name: "key", arg: 2, scope: !2135, file: !6, line: 317, type: !2138)
!2142 = !DILocation(line: 317, column: 57, scope: !2135)
!2143 = !DILocalVariable(name: "val", arg: 3, scope: !2135, file: !6, line: 317, type: !52)
!2144 = !DILocation(line: 317, column: 69, scope: !2135)
!2145 = !DILocalVariable(name: "k", scope: !2135, file: !6, line: 319, type: !19)
!2146 = !DILocation(line: 319, column: 16, scope: !2135)
!2147 = !DILocalVariable(name: "v", scope: !2135, file: !6, line: 320, type: !22)
!2148 = !DILocation(line: 320, column: 11, scope: !2135)
!2149 = !DILocalVariable(name: "entries", scope: !2135, file: !6, line: 321, type: !68)
!2150 = !DILocation(line: 321, column: 24, scope: !2135)
!2151 = !DILocation(line: 322, column: 5, scope: !2152)
!2152 = distinct !DILexicalBlock(scope: !2153, file: !6, line: 322, column: 5)
!2153 = distinct !DILexicalBlock(scope: !2135, file: !6, line: 322, column: 5)
!2154 = !DILocation(line: 322, column: 5, scope: !2153)
!2155 = !DILocation(line: 323, column: 5, scope: !2156)
!2156 = distinct !DILexicalBlock(scope: !2157, file: !6, line: 323, column: 5)
!2157 = distinct !DILexicalBlock(scope: !2135, file: !6, line: 323, column: 5)
!2158 = !DILocation(line: 323, column: 5, scope: !2157)
!2159 = !DILocation(line: 324, column: 5, scope: !2160)
!2160 = distinct !DILexicalBlock(scope: !2161, file: !6, line: 324, column: 5)
!2161 = distinct !DILexicalBlock(scope: !2135, file: !6, line: 324, column: 5)
!2162 = !DILocation(line: 324, column: 5, scope: !2161)
!2163 = !DILocation(line: 325, column: 5, scope: !2164)
!2164 = distinct !DILexicalBlock(scope: !2165, file: !6, line: 325, column: 5)
!2165 = distinct !DILexicalBlock(scope: !2135, file: !6, line: 325, column: 5)
!2166 = !DILocation(line: 325, column: 5, scope: !2165)
!2167 = !DILocation(line: 326, column: 15, scope: !2135)
!2168 = !DILocation(line: 326, column: 21, scope: !2135)
!2169 = !DILocation(line: 326, column: 26, scope: !2135)
!2170 = !DILocation(line: 326, column: 13, scope: !2135)
!2171 = !DILocation(line: 327, column: 5, scope: !2172)
!2172 = distinct !DILexicalBlock(scope: !2173, file: !6, line: 327, column: 5)
!2173 = distinct !DILexicalBlock(scope: !2135, file: !6, line: 327, column: 5)
!2174 = !DILocation(line: 327, column: 5, scope: !2173)
!2175 = !DILocalVariable(name: "i", scope: !2176, file: !6, line: 328, type: !14)
!2176 = distinct !DILexicalBlock(scope: !2135, file: !6, line: 328, column: 5)
!2177 = !DILocation(line: 328, column: 18, scope: !2176)
!2178 = !DILocation(line: 328, column: 22, scope: !2176)
!2179 = !DILocation(line: 328, column: 28, scope: !2176)
!2180 = !DILocation(line: 328, column: 10, scope: !2176)
!2181 = !DILocation(line: 328, column: 33, scope: !2182)
!2182 = distinct !DILexicalBlock(scope: !2176, file: !6, line: 328, column: 5)
!2183 = !DILocation(line: 328, column: 37, scope: !2182)
!2184 = !DILocation(line: 328, column: 43, scope: !2182)
!2185 = !DILocation(line: 328, column: 48, scope: !2182)
!2186 = !DILocation(line: 328, column: 35, scope: !2182)
!2187 = !DILocation(line: 328, column: 5, scope: !2176)
!2188 = !DILocation(line: 329, column: 42, scope: !2189)
!2189 = distinct !DILexicalBlock(scope: !2182, file: !6, line: 328, column: 63)
!2190 = !DILocation(line: 329, column: 50, scope: !2189)
!2191 = !DILocation(line: 329, column: 53, scope: !2189)
!2192 = !DILocation(line: 329, column: 25, scope: !2189)
!2193 = !DILocation(line: 329, column: 13, scope: !2189)
!2194 = !DILocation(line: 329, column: 11, scope: !2189)
!2195 = !DILocation(line: 330, column: 30, scope: !2189)
!2196 = !DILocation(line: 330, column: 38, scope: !2189)
!2197 = !DILocation(line: 330, column: 41, scope: !2189)
!2198 = !DILocation(line: 330, column: 13, scope: !2189)
!2199 = !DILocation(line: 330, column: 11, scope: !2189)
!2200 = !DILocation(line: 331, column: 13, scope: !2201)
!2201 = distinct !DILexicalBlock(scope: !2189, file: !6, line: 331, column: 13)
!2202 = !DILocation(line: 331, column: 15, scope: !2201)
!2203 = !DILocation(line: 331, column: 18, scope: !2201)
!2204 = !DILocation(line: 331, column: 13, scope: !2189)
!2205 = !DILocation(line: 332, column: 25, scope: !2206)
!2206 = distinct !DILexicalBlock(scope: !2201, file: !6, line: 331, column: 21)
!2207 = !DILocation(line: 332, column: 27, scope: !2206)
!2208 = !DILocation(line: 332, column: 13, scope: !2206)
!2209 = !DILocation(line: 332, column: 19, scope: !2206)
!2210 = !DILocation(line: 332, column: 23, scope: !2206)
!2211 = !DILocation(line: 333, column: 25, scope: !2206)
!2212 = !DILocation(line: 333, column: 14, scope: !2206)
!2213 = !DILocation(line: 333, column: 23, scope: !2206)
!2214 = !DILocation(line: 334, column: 25, scope: !2206)
!2215 = !DILocation(line: 334, column: 14, scope: !2206)
!2216 = !DILocation(line: 334, column: 23, scope: !2206)
!2217 = !DILocation(line: 335, column: 13, scope: !2206)
!2218 = !DILocation(line: 337, column: 5, scope: !2189)
!2219 = !DILocation(line: 328, column: 59, scope: !2182)
!2220 = !DILocation(line: 328, column: 5, scope: !2182)
!2221 = distinct !{!2221, !2187, !2222, !223}
!2222 = !DILocation(line: 337, column: 5, scope: !2176)
!2223 = !DILocation(line: 338, column: 5, scope: !2135)
!2224 = !DILocation(line: 339, column: 1, scope: !2135)
!2225 = distinct !DISubprogram(name: "trace_subtract_from", scope: !157, file: !157, line: 183, type: !2101, scopeLine: 184, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!2226 = !DILocalVariable(name: "trace_container", arg: 1, scope: !2225, file: !157, line: 183, type: !579)
!2227 = !DILocation(line: 183, column: 30, scope: !2225)
!2228 = !DILocalVariable(name: "trace", arg: 2, scope: !2225, file: !157, line: 183, type: !579)
!2229 = !DILocation(line: 183, column: 56, scope: !2225)
!2230 = !DILocation(line: 185, column: 30, scope: !2225)
!2231 = !DILocation(line: 185, column: 47, scope: !2225)
!2232 = !DILocation(line: 185, column: 5, scope: !2225)
!2233 = !DILocation(line: 186, column: 1, scope: !2225)
!2234 = distinct !DISubprogram(name: "trace_is_subtrace", scope: !157, file: !157, line: 292, type: !2235, scopeLine: 294, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!2235 = !DISubroutineType(types: !2236)
!2236 = !{!42, !579, !579, !2237}
!2237 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !2238, size: 64)
!2238 = !DISubroutineType(types: !2239)
!2239 = !{null, !19}
!2240 = !DILocalVariable(name: "super_trace", arg: 1, scope: !2234, file: !157, line: 292, type: !579)
!2241 = !DILocation(line: 292, column: 28, scope: !2234)
!2242 = !DILocalVariable(name: "sub_trace", arg: 2, scope: !2234, file: !157, line: 292, type: !579)
!2243 = !DILocation(line: 292, column: 50, scope: !2234)
!2244 = !DILocalVariable(name: "print", arg: 3, scope: !2234, file: !157, line: 293, type: !2237)
!2245 = !DILocation(line: 293, column: 26, scope: !2234)
!2246 = !DILocalVariable(name: "i", scope: !2234, file: !157, line: 295, type: !14)
!2247 = !DILocation(line: 295, column: 13, scope: !2234)
!2248 = !DILocalVariable(name: "idx", scope: !2234, file: !157, line: 296, type: !14)
!2249 = !DILocation(line: 296, column: 13, scope: !2234)
!2250 = !DILocalVariable(name: "unit_a", scope: !2234, file: !157, line: 298, type: !161)
!2251 = !DILocation(line: 298, column: 19, scope: !2234)
!2252 = !DILocalVariable(name: "unit_b", scope: !2234, file: !157, line: 299, type: !161)
!2253 = !DILocation(line: 299, column: 19, scope: !2234)
!2254 = !DILocation(line: 302, column: 12, scope: !2255)
!2255 = distinct !DILexicalBlock(scope: !2234, file: !157, line: 302, column: 5)
!2256 = !DILocation(line: 302, column: 10, scope: !2255)
!2257 = !DILocation(line: 302, column: 17, scope: !2258)
!2258 = distinct !DILexicalBlock(scope: !2255, file: !157, line: 302, column: 5)
!2259 = !DILocation(line: 302, column: 21, scope: !2258)
!2260 = !DILocation(line: 302, column: 32, scope: !2258)
!2261 = !DILocation(line: 302, column: 19, scope: !2258)
!2262 = !DILocation(line: 302, column: 5, scope: !2255)
!2263 = !DILocation(line: 303, column: 19, scope: !2264)
!2264 = distinct !DILexicalBlock(scope: !2258, file: !157, line: 302, column: 42)
!2265 = !DILocation(line: 303, column: 30, scope: !2264)
!2266 = !DILocation(line: 303, column: 36, scope: !2264)
!2267 = !DILocation(line: 303, column: 16, scope: !2264)
!2268 = !DILocation(line: 305, column: 33, scope: !2269)
!2269 = distinct !DILexicalBlock(scope: !2264, file: !157, line: 305, column: 13)
!2270 = !DILocation(line: 305, column: 46, scope: !2269)
!2271 = !DILocation(line: 305, column: 54, scope: !2269)
!2272 = !DILocation(line: 305, column: 13, scope: !2269)
!2273 = !DILocation(line: 305, column: 13, scope: !2264)
!2274 = !DILocation(line: 306, column: 23, scope: !2275)
!2275 = distinct !DILexicalBlock(scope: !2269, file: !157, line: 305, column: 66)
!2276 = !DILocation(line: 306, column: 36, scope: !2275)
!2277 = !DILocation(line: 306, column: 42, scope: !2275)
!2278 = !DILocation(line: 306, column: 20, scope: !2275)
!2279 = !DILocation(line: 308, column: 13, scope: !2280)
!2280 = distinct !DILexicalBlock(scope: !2281, file: !157, line: 308, column: 13)
!2281 = distinct !DILexicalBlock(scope: !2275, file: !157, line: 308, column: 13)
!2282 = !DILocation(line: 308, column: 13, scope: !2281)
!2283 = !DILocation(line: 310, column: 17, scope: !2284)
!2284 = distinct !DILexicalBlock(scope: !2275, file: !157, line: 310, column: 17)
!2285 = !DILocation(line: 310, column: 25, scope: !2284)
!2286 = !DILocation(line: 310, column: 34, scope: !2284)
!2287 = !DILocation(line: 310, column: 42, scope: !2284)
!2288 = !DILocation(line: 310, column: 31, scope: !2284)
!2289 = !DILocation(line: 310, column: 17, scope: !2275)
!2290 = !DILocation(line: 311, column: 21, scope: !2291)
!2291 = distinct !DILexicalBlock(scope: !2292, file: !157, line: 311, column: 21)
!2292 = distinct !DILexicalBlock(scope: !2284, file: !157, line: 310, column: 49)
!2293 = !DILocation(line: 311, column: 21, scope: !2292)
!2294 = !DILocation(line: 314, column: 28, scope: !2295)
!2295 = distinct !DILexicalBlock(scope: !2291, file: !157, line: 311, column: 28)
!2296 = !DILocation(line: 314, column: 36, scope: !2295)
!2297 = !DILocation(line: 314, column: 41, scope: !2295)
!2298 = !DILocation(line: 314, column: 49, scope: !2295)
!2299 = !DILocation(line: 314, column: 56, scope: !2295)
!2300 = !DILocation(line: 314, column: 64, scope: !2295)
!2301 = !DILocation(line: 312, column: 21, scope: !2295)
!2302 = !DILocation(line: 315, column: 21, scope: !2295)
!2303 = !DILocation(line: 315, column: 27, scope: !2295)
!2304 = !DILocation(line: 315, column: 35, scope: !2295)
!2305 = !DILocation(line: 316, column: 17, scope: !2295)
!2306 = !DILocation(line: 317, column: 17, scope: !2292)
!2307 = !DILocation(line: 319, column: 9, scope: !2275)
!2308 = !DILocation(line: 320, column: 17, scope: !2309)
!2309 = distinct !DILexicalBlock(scope: !2310, file: !157, line: 320, column: 17)
!2310 = distinct !DILexicalBlock(scope: !2269, file: !157, line: 319, column: 16)
!2311 = !DILocation(line: 320, column: 17, scope: !2310)
!2312 = !DILocation(line: 321, column: 65, scope: !2313)
!2313 = distinct !DILexicalBlock(scope: !2309, file: !157, line: 320, column: 24)
!2314 = !DILocation(line: 321, column: 73, scope: !2313)
!2315 = !DILocation(line: 321, column: 17, scope: !2313)
!2316 = !DILocation(line: 322, column: 17, scope: !2313)
!2317 = !DILocation(line: 322, column: 23, scope: !2313)
!2318 = !DILocation(line: 322, column: 31, scope: !2313)
!2319 = !DILocation(line: 323, column: 13, scope: !2313)
!2320 = !DILocation(line: 324, column: 13, scope: !2310)
!2321 = !DILocation(line: 326, column: 5, scope: !2264)
!2322 = !DILocation(line: 302, column: 38, scope: !2258)
!2323 = !DILocation(line: 302, column: 5, scope: !2258)
!2324 = distinct !{!2324, !2262, !2325, !223}
!2325 = !DILocation(line: 326, column: 5, scope: !2255)
!2326 = !DILocation(line: 328, column: 5, scope: !2234)
!2327 = !DILocation(line: 329, column: 1, scope: !2234)
!2328 = distinct !DISubprogram(name: "_trace_merge_or_subtract", scope: !157, file: !157, line: 161, type: !2329, scopeLine: 163, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !187)
!2329 = !DISubroutineType(types: !2330)
!2330 = !{null, !579, !579, !42}
!2331 = !DILocalVariable(name: "trace_container", arg: 1, scope: !2328, file: !157, line: 161, type: !579)
!2332 = !DILocation(line: 161, column: 35, scope: !2328)
!2333 = !DILocalVariable(name: "trace", arg: 2, scope: !2328, file: !157, line: 161, type: !579)
!2334 = !DILocation(line: 161, column: 61, scope: !2328)
!2335 = !DILocalVariable(name: "subtract", arg: 3, scope: !2328, file: !157, line: 162, type: !42)
!2336 = !DILocation(line: 162, column: 34, scope: !2328)
!2337 = !DILocalVariable(name: "i", scope: !2328, file: !157, line: 164, type: !14)
!2338 = !DILocation(line: 164, column: 13, scope: !2328)
!2339 = !DILocation(line: 165, column: 5, scope: !2340)
!2340 = distinct !DILexicalBlock(scope: !2341, file: !157, line: 165, column: 5)
!2341 = distinct !DILexicalBlock(scope: !2328, file: !157, line: 165, column: 5)
!2342 = !DILocation(line: 165, column: 5, scope: !2341)
!2343 = !DILocation(line: 166, column: 5, scope: !2344)
!2344 = distinct !DILexicalBlock(scope: !2345, file: !157, line: 166, column: 5)
!2345 = distinct !DILexicalBlock(scope: !2328, file: !157, line: 166, column: 5)
!2346 = !DILocation(line: 166, column: 5, scope: !2345)
!2347 = !DILocation(line: 168, column: 5, scope: !2348)
!2348 = distinct !DILexicalBlock(scope: !2349, file: !157, line: 168, column: 5)
!2349 = distinct !DILexicalBlock(scope: !2328, file: !157, line: 168, column: 5)
!2350 = !DILocation(line: 168, column: 5, scope: !2349)
!2351 = !DILocation(line: 169, column: 5, scope: !2352)
!2352 = distinct !DILexicalBlock(scope: !2353, file: !157, line: 169, column: 5)
!2353 = distinct !DILexicalBlock(scope: !2328, file: !157, line: 169, column: 5)
!2354 = !DILocation(line: 169, column: 5, scope: !2353)
!2355 = !DILocation(line: 171, column: 12, scope: !2356)
!2356 = distinct !DILexicalBlock(scope: !2328, file: !157, line: 171, column: 5)
!2357 = !DILocation(line: 171, column: 10, scope: !2356)
!2358 = !DILocation(line: 171, column: 17, scope: !2359)
!2359 = distinct !DILexicalBlock(scope: !2356, file: !157, line: 171, column: 5)
!2360 = !DILocation(line: 171, column: 21, scope: !2359)
!2361 = !DILocation(line: 171, column: 28, scope: !2359)
!2362 = !DILocation(line: 171, column: 19, scope: !2359)
!2363 = !DILocation(line: 171, column: 5, scope: !2356)
!2364 = !DILocation(line: 172, column: 39, scope: !2365)
!2365 = distinct !DILexicalBlock(scope: !2359, file: !157, line: 171, column: 38)
!2366 = !DILocation(line: 172, column: 56, scope: !2365)
!2367 = !DILocation(line: 172, column: 63, scope: !2365)
!2368 = !DILocation(line: 172, column: 69, scope: !2365)
!2369 = !DILocation(line: 172, column: 72, scope: !2365)
!2370 = !DILocation(line: 173, column: 39, scope: !2365)
!2371 = !DILocation(line: 173, column: 46, scope: !2365)
!2372 = !DILocation(line: 173, column: 52, scope: !2365)
!2373 = !DILocation(line: 173, column: 55, scope: !2365)
!2374 = !DILocation(line: 173, column: 62, scope: !2365)
!2375 = !DILocation(line: 172, column: 9, scope: !2365)
!2376 = !DILocation(line: 174, column: 5, scope: !2365)
!2377 = !DILocation(line: 171, column: 34, scope: !2359)
!2378 = !DILocation(line: 171, column: 5, scope: !2359)
!2379 = distinct !{!2379, !2363, !2380, !223}
!2380 = !DILocation(line: 174, column: 5, scope: !2356)
!2381 = !DILocation(line: 175, column: 1, scope: !2328)
