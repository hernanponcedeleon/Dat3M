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
@g_pre_keys = dso_local global [2 x i64] [i64 1, i64 3], align 16, !dbg !54
@g_new_key = dso_local global i64 2, align 8, !dbg !60
@g_added = dso_local global i8 0, align 1, !dbg !62
@g_got_nw_val = dso_local global i8 0, align 1, !dbg !64
@.str = private unnamed_addr constant [8 x i8] c"success\00", align 1
@.str.1 = private unnamed_addr constant [59 x i8] c"/home/drc/git/libvsync/verify/simpleht/test_case_add_get.h\00", align 1
@__PRETTY_FUNCTION__.pre = private unnamed_addr constant [15 x i8] c"void pre(void)\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"tid < 2U\00", align 1
@__PRETTY_FUNCTION__.t0 = private unnamed_addr constant [17 x i8] c"void t0(vsize_t)\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"data\00", align 1
@__PRETTY_FUNCTION__.t1 = private unnamed_addr constant [17 x i8] c"void t1(vsize_t)\00", align 1
@__PRETTY_FUNCTION__.t2 = private unnamed_addr constant [17 x i8] c"void t2(vsize_t)\00", align 1
@__PRETTY_FUNCTION__.post = private unnamed_addr constant [16 x i8] c"void post(void)\00", align 1
@.str.4 = private unnamed_addr constant [9 x i8] c"tid < 3U\00", align 1
@.str.5 = private unnamed_addr constant [65 x i8] c"/home/drc/git/libvsync/test/include/test/boilerplate/test_case.h\00", align 1
@__PRETTY_FUNCTION__.run = private unnamed_addr constant [18 x i8] c"void *run(void *)\00", align 1
@g_simpleht = internal global %struct.vsimpleht_s zeroinitializer, align 8, !dbg !66
@g_add = internal global [4 x %struct.trace_s] zeroinitializer, align 16, !dbg !161
@.str.6 = private unnamed_addr constant [9 x i8] c"key != 0\00", align 1
@.str.7 = private unnamed_addr constant [52 x i8] c"/home/drc/git/libvsync/include/vsync/map/simpleht.h\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_add = private unnamed_addr constant [65 x i8] c"vsimpleht_ret_t vsimpleht_add(vsimpleht_t *, vuintptr_t, void *)\00", align 1
@.str.8 = private unnamed_addr constant [20 x i8] c"value != ((void*)0)\00", align 1
@.str.9 = private unnamed_addr constant [65 x i8] c"You seem to have forgotten to call the  thread register function\00", align 1
@.str.10 = private unnamed_addr constant [112 x i8] c"rwlock_acquired_by_readers(&tbl->lock) && \22You seem to have forgotten to call the \22 \22 thread register function\22\00", align 1
@__PRETTY_FUNCTION__._vsimpleht_give_cleanup_a_chance = private unnamed_addr constant [53 x i8] c"void _vsimpleht_give_cleanup_a_chance(vsimpleht_t *)\00", align 1
@.str.11 = private unnamed_addr constant [11 x i8] c"g_tid < 3U\00", align 1
@.str.12 = private unnamed_addr constant [54 x i8] c"/home/drc/git/libvsync/verify/include/verify/rwlock.h\00", align 1
@__PRETTY_FUNCTION__._rwlock_get_tid = private unnamed_addr constant [38 x i8] c"vuint32_t _rwlock_get_tid(rwlock_t *)\00", align 1
@.str.13 = private unnamed_addr constant [25 x i8] c"NULL key is not allowed!\00", align 1
@.str.14 = private unnamed_addr constant [34 x i8] c"key && \22NULL key is not allowed!\22\00", align 1
@__PRETTY_FUNCTION__._vsimpleht_add = private unnamed_addr constant [66 x i8] c"vsimpleht_ret_t _vsimpleht_add(vsimpleht_t *, vuintptr_t, void *)\00", align 1
@.str.15 = private unnamed_addr constant [27 x i8] c"NULL value is not allowed!\00", align 1
@.str.16 = private unnamed_addr constant [38 x i8] c"value && \22NULL value is not allowed!\22\00", align 1
@.str.17 = private unnamed_addr constant [22 x i8] c"index < tbl->capacity\00", align 1
@.str.18 = private unnamed_addr constant [79 x i8] c"tbl->cmp_key(key, (vuintptr_t)vatomicptr_read( &tbl->entries[index].key)) == 0\00", align 1
@.str.19 = private unnamed_addr constant [6 x i8] c"trace\00", align 1
@.str.20 = private unnamed_addr constant [57 x i8] c"/home/drc/git/libvsync/test/include/test/trace_manager.h\00", align 1
@__PRETTY_FUNCTION__.trace_add = private unnamed_addr constant [38 x i8] c"void trace_add(trace_t *, vuintptr_t)\00", align 1
@.str.21 = private unnamed_addr constant [19 x i8] c"trace->initialized\00", align 1
@__PRETTY_FUNCTION__._trace_add_or_rem_occurrences = private unnamed_addr constant [76 x i8] c"void _trace_add_or_rem_occurrences(trace_t *, vuintptr_t, vsize_t, vbool_t)\00", align 1
@.str.22 = private unnamed_addr constant [6 x i8] c"found\00", align 1
@.str.23 = private unnamed_addr constant [33 x i8] c"trace->units[idx].count >= count\00", align 1
@__PRETTY_FUNCTION__.trace_find_unit_idx = private unnamed_addr constant [62 x i8] c"vbool_t trace_find_unit_idx(trace_t *, vuintptr_t, vsize_t *)\00", align 1
@__PRETTY_FUNCTION__.trace_extend = private unnamed_addr constant [29 x i8] c"void trace_extend(trace_t *)\00", align 1
@.str.24 = private unnamed_addr constant [22 x i8] c"0 && \22copying failed\22\00", align 1
@.str.25 = private unnamed_addr constant [25 x i8] c"0 && \22allocation failed\22\00", align 1
@.str.26 = private unnamed_addr constant [17 x i8] c"data->key == key\00", align 1
@.str.27 = private unnamed_addr constant [55 x i8] c"/home/drc/git/libvsync/test/include/test/map/isimple.h\00", align 1
@__PRETTY_FUNCTION__.imap_get = private unnamed_addr constant [36 x i8] c"void *imap_get(vsize_t, vuintptr_t)\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_get = private unnamed_addr constant [47 x i8] c"void *vsimpleht_get(vsimpleht_t *, vuintptr_t)\00", align 1
@g_rem = internal global [4 x %struct.trace_s] zeroinitializer, align 16, !dbg !180
@.str.28 = private unnamed_addr constant [13 x i8] c"capacity > 0\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_buff_size = private unnamed_addr constant [37 x i8] c"vsize_t vsimpleht_buff_size(vsize_t)\00", align 1
@.str.29 = private unnamed_addr constant [28 x i8] c"capacity must be power of 2\00", align 1
@.str.30 = private unnamed_addr constant [66 x i8] c"(capacity & (capacity - 1)) == 0 && \22capacity must be power of 2\22\00", align 1
@.str.31 = private unnamed_addr constant [4 x i8] c"tbl\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_init = private unnamed_addr constant [122 x i8] c"void vsimpleht_init(vsimpleht_t *, void *, vsize_t, vsimpleht_cmp_key_t, vsimpleht_hash_key_t, vsimpleht_destroy_entry_t)\00", align 1
@.str.32 = private unnamed_addr constant [5 x i8] c"buff\00", align 1
@.str.33 = private unnamed_addr constant [30 x i8] c"Array size must be power of 2\00", align 1
@.str.34 = private unnamed_addr constant [68 x i8] c"(capacity & (capacity - 1)) == 0 && \22Array size must be power of 2\22\00", align 1
@__PRETTY_FUNCTION__.trace_init = private unnamed_addr constant [36 x i8] c"void trace_init(trace_t *, vsize_t)\00", align 1
@g_buff = internal global i8* null, align 8, !dbg !182
@.str.35 = private unnamed_addr constant [40 x i8] c"the final state is not what is expected\00", align 1
@.str.36 = private unnamed_addr constant [48 x i8] c"eq && \22the final state is not what is expected\22\00", align 1
@__PRETTY_FUNCTION__._imap_verify = private unnamed_addr constant [24 x i8] c"void _imap_verify(void)\00", align 1
@.str.37 = private unnamed_addr constant [16 x i8] c"trace_container\00", align 1
@__PRETTY_FUNCTION__._trace_merge_or_subtract = private unnamed_addr constant [61 x i8] c"void _trace_merge_or_subtract(trace_t *, trace_t *, vbool_t)\00", align 1
@.str.38 = private unnamed_addr constant [29 x i8] c"trace_container->initialized\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_iter_init = private unnamed_addr constant [60 x i8] c"void vsimpleht_iter_init(vsimpleht_t *, vsimpleht_iter_t *)\00", align 1
@.str.39 = private unnamed_addr constant [5 x i8] c"iter\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_iter_next = private unnamed_addr constant [71 x i8] c"vbool_t vsimpleht_iter_next(vsimpleht_iter_t *, vuintptr_t *, void **)\00", align 1
@.str.40 = private unnamed_addr constant [10 x i8] c"iter->tbl\00", align 1
@.str.41 = private unnamed_addr constant [4 x i8] c"key\00", align 1
@.str.42 = private unnamed_addr constant [4 x i8] c"val\00", align 1
@.str.43 = private unnamed_addr constant [8 x i8] c"entries\00", align 1
@.str.44 = private unnamed_addr constant [27 x i8] c"unit_a->key == unit_b->key\00", align 1
@__PRETTY_FUNCTION__.trace_is_subtrace = private unnamed_addr constant [70 x i8] c"vbool_t trace_is_subtrace(trace_t *, trace_t *, void (*)(vuintptr_t))\00", align 1
@.str.45 = private unnamed_addr constant [40 x i8] c"key[%lu] count is different %zu != %zu\0A\00", align 1
@.str.46 = private unnamed_addr constant [20 x i8] c"key[%lu] not found\0A\00", align 1
@__PRETTY_FUNCTION__.trace_destroy = private unnamed_addr constant [30 x i8] c"void trace_destroy(trace_t *)\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_destroy = private unnamed_addr constant [38 x i8] c"void vsimpleht_destroy(vsimpleht_t *)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @pre() #0 !dbg !192 {
  %1 = alloca i64, align 8
  %2 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata i64* %1, metadata !196, metadata !DIExpression()), !dbg !198
  store i64 0, i64* %1, align 8, !dbg !198
  br label %3, !dbg !199

3:                                                ; preds = %20, %0
  %4 = load i64, i64* %1, align 8, !dbg !200
  %5 = icmp ult i64 %4, 2, !dbg !202
  br i1 %5, label %6, label %23, !dbg !203

6:                                                ; preds = %3
  call void @llvm.dbg.declare(metadata i8* %2, metadata !204, metadata !DIExpression()), !dbg !206
  %7 = load i64, i64* %1, align 8, !dbg !207
  %8 = getelementptr inbounds [2 x i64], [2 x i64]* @g_pre_keys, i64 0, i64 %7, !dbg !208
  %9 = load i64, i64* %8, align 8, !dbg !208
  %10 = load i64, i64* %1, align 8, !dbg !209
  %11 = getelementptr inbounds [2 x i64], [2 x i64]* @g_pre_keys, i64 0, i64 %10, !dbg !210
  %12 = load i64, i64* %11, align 8, !dbg !210
  %13 = call zeroext i1 @imap_add(i64 noundef 3, i64 noundef %9, i64 noundef %12), !dbg !211
  %14 = zext i1 %13 to i8, !dbg !206
  store i8 %14, i8* %2, align 1, !dbg !206
  %15 = load i8, i8* %2, align 1, !dbg !212
  %16 = trunc i8 %15 to i1, !dbg !212
  br i1 %16, label %17, label %18, !dbg !215

17:                                               ; preds = %6
  br label %19, !dbg !215

18:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([59 x i8], [59 x i8]* @.str.1, i64 0, i64 0), i32 noundef 21, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.pre, i64 0, i64 0)) #5, !dbg !212
  unreachable, !dbg !212

19:                                               ; preds = %17
  br label %20, !dbg !216

20:                                               ; preds = %19
  %21 = load i64, i64* %1, align 8, !dbg !217
  %22 = add i64 %21, 1, !dbg !217
  store i64 %22, i64* %1, align 8, !dbg !217
  br label %3, !dbg !218, !llvm.loop !219

23:                                               ; preds = %3
  ret void, !dbg !222
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @imap_add(i64 noundef %0, i64 noundef %1, i64 noundef %2) #0 !dbg !223 {
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.data_s*, align 8
  %8 = alloca i8, align 1
  store i64 %0, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !226, metadata !DIExpression()), !dbg !227
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !228, metadata !DIExpression()), !dbg !229
  store i64 %2, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !230, metadata !DIExpression()), !dbg !231
  call void @llvm.dbg.declare(metadata %struct.data_s** %7, metadata !232, metadata !DIExpression()), !dbg !239
  %9 = call noalias i8* @malloc(i64 noundef 16) #6, !dbg !240
  %10 = bitcast i8* %9 to %struct.data_s*, !dbg !240
  store %struct.data_s* %10, %struct.data_s** %7, align 8, !dbg !239
  %11 = load i64, i64* %5, align 8, !dbg !241
  %12 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !242
  %13 = getelementptr inbounds %struct.data_s, %struct.data_s* %12, i32 0, i32 0, !dbg !243
  store i64 %11, i64* %13, align 8, !dbg !244
  %14 = load i64, i64* %6, align 8, !dbg !245
  %15 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !246
  %16 = getelementptr inbounds %struct.data_s, %struct.data_s* %15, i32 0, i32 1, !dbg !247
  store i64 %14, i64* %16, align 8, !dbg !248
  call void @llvm.dbg.declare(metadata i8* %8, metadata !249, metadata !DIExpression()), !dbg !250
  %17 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !251
  %18 = getelementptr inbounds %struct.data_s, %struct.data_s* %17, i32 0, i32 0, !dbg !252
  %19 = load i64, i64* %18, align 8, !dbg !252
  %20 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !253
  %21 = bitcast %struct.data_s* %20 to i8*, !dbg !253
  %22 = call i32 @vsimpleht_add(%struct.vsimpleht_s* noundef @g_simpleht, i64 noundef %19, i8* noundef %21), !dbg !254
  %23 = icmp eq i32 %22, 0, !dbg !255
  %24 = zext i1 %23 to i8, !dbg !250
  store i8 %24, i8* %8, align 1, !dbg !250
  %25 = load i8, i8* %8, align 1, !dbg !256
  %26 = trunc i8 %25 to i1, !dbg !256
  br i1 %26, label %27, label %33, !dbg !258

27:                                               ; preds = %3
  %28 = load i64, i64* %4, align 8, !dbg !259
  %29 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %28, !dbg !261
  %30 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !262
  %31 = getelementptr inbounds %struct.data_s, %struct.data_s* %30, i32 0, i32 0, !dbg !263
  %32 = load i64, i64* %31, align 8, !dbg !263
  call void @trace_add(%struct.trace_s* noundef %29, i64 noundef %32), !dbg !264
  br label %36, !dbg !265

33:                                               ; preds = %3
  %34 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !266
  %35 = bitcast %struct.data_s* %34 to i8*, !dbg !266
  call void @free(i8* noundef %35) #6, !dbg !268
  br label %36

36:                                               ; preds = %33, %27
  %37 = load i8, i8* %8, align 1, !dbg !269
  %38 = trunc i8 %37 to i1, !dbg !269
  ret i1 %38, !dbg !270
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @t0(i64 noundef %0) #0 !dbg !271 {
  %2 = alloca i64, align 8
  %3 = alloca %struct.data_s*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !274, metadata !DIExpression()), !dbg !275
  %4 = load i64, i64* %2, align 8, !dbg !276
  %5 = icmp ult i64 %4, 2, !dbg !276
  br i1 %5, label %6, label %7, !dbg !279

6:                                                ; preds = %1
  br label %8, !dbg !279

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([59 x i8], [59 x i8]* @.str.1, i64 0, i64 0), i32 noundef 27, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t0, i64 0, i64 0)) #5, !dbg !276
  unreachable, !dbg !276

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata %struct.data_s** %3, metadata !280, metadata !DIExpression()), !dbg !281
  %9 = load i64, i64* %2, align 8, !dbg !282
  %10 = load i64, i64* %2, align 8, !dbg !283
  %11 = getelementptr inbounds [2 x i64], [2 x i64]* @g_pre_keys, i64 0, i64 %10, !dbg !284
  %12 = load i64, i64* %11, align 8, !dbg !284
  %13 = call i8* @imap_get(i64 noundef %9, i64 noundef %12), !dbg !285
  %14 = bitcast i8* %13 to %struct.data_s*, !dbg !285
  store %struct.data_s* %14, %struct.data_s** %3, align 8, !dbg !281
  %15 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !286
  %16 = icmp ne %struct.data_s* %15, null, !dbg !286
  br i1 %16, label %17, label %18, !dbg !289

17:                                               ; preds = %8
  br label %19, !dbg !289

18:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([59 x i8], [59 x i8]* @.str.1, i64 0, i64 0), i32 noundef 29, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t0, i64 0, i64 0)) #5, !dbg !286
  unreachable, !dbg !286

19:                                               ; preds = %17
  ret void, !dbg !290
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @imap_get(i64 noundef %0, i64 noundef %1) #0 !dbg !291 {
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca %struct.data_s*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !294, metadata !DIExpression()), !dbg !295
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !296, metadata !DIExpression()), !dbg !297
  br label %6, !dbg !298

6:                                                ; preds = %2
  br label %7, !dbg !299

7:                                                ; preds = %6
  %8 = load i64, i64* %3, align 8, !dbg !301
  br label %9, !dbg !301

9:                                                ; preds = %7
  br label %10, !dbg !303

10:                                               ; preds = %9
  br label %11, !dbg !301

11:                                               ; preds = %10
  br label %12, !dbg !299

12:                                               ; preds = %11
  call void @llvm.dbg.declare(metadata %struct.data_s** %5, metadata !305, metadata !DIExpression()), !dbg !306
  %13 = load i64, i64* %4, align 8, !dbg !307
  %14 = call i8* @vsimpleht_get(%struct.vsimpleht_s* noundef @g_simpleht, i64 noundef %13), !dbg !308
  %15 = bitcast i8* %14 to %struct.data_s*, !dbg !308
  store %struct.data_s* %15, %struct.data_s** %5, align 8, !dbg !306
  %16 = load %struct.data_s*, %struct.data_s** %5, align 8, !dbg !309
  %17 = icmp ne %struct.data_s* %16, null, !dbg !309
  br i1 %17, label %18, label %27, !dbg !311

18:                                               ; preds = %12
  %19 = load %struct.data_s*, %struct.data_s** %5, align 8, !dbg !312
  %20 = getelementptr inbounds %struct.data_s, %struct.data_s* %19, i32 0, i32 0, !dbg !312
  %21 = load i64, i64* %20, align 8, !dbg !312
  %22 = load i64, i64* %4, align 8, !dbg !312
  %23 = icmp eq i64 %21, %22, !dbg !312
  br i1 %23, label %24, label %25, !dbg !316

24:                                               ; preds = %18
  br label %26, !dbg !316

25:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.26, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.27, i64 0, i64 0), i32 noundef 171, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.imap_get, i64 0, i64 0)) #5, !dbg !312
  unreachable, !dbg !312

26:                                               ; preds = %24
  br label %27, !dbg !317

27:                                               ; preds = %26, %12
  %28 = load %struct.data_s*, %struct.data_s** %5, align 8, !dbg !318
  %29 = bitcast %struct.data_s* %28 to i8*, !dbg !318
  ret i8* %29, !dbg !319
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @t1(i64 noundef %0) #0 !dbg !320 {
  %2 = alloca i64, align 8
  %3 = alloca %struct.data_s*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !321, metadata !DIExpression()), !dbg !322
  %4 = load i64, i64* %2, align 8, !dbg !323
  %5 = icmp ult i64 %4, 2, !dbg !323
  br i1 %5, label %6, label %7, !dbg !326

6:                                                ; preds = %1
  br label %8, !dbg !326

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([59 x i8], [59 x i8]* @.str.1, i64 0, i64 0), i32 noundef 34, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t1, i64 0, i64 0)) #5, !dbg !323
  unreachable, !dbg !323

8:                                                ; preds = %6
  call void @llvm.dbg.declare(metadata %struct.data_s** %3, metadata !327, metadata !DIExpression()), !dbg !328
  %9 = load i64, i64* %2, align 8, !dbg !329
  %10 = load i64, i64* %2, align 8, !dbg !330
  %11 = getelementptr inbounds [2 x i64], [2 x i64]* @g_pre_keys, i64 0, i64 %10, !dbg !331
  %12 = load i64, i64* %11, align 8, !dbg !331
  %13 = call i8* @imap_get(i64 noundef %9, i64 noundef %12), !dbg !332
  %14 = bitcast i8* %13 to %struct.data_s*, !dbg !332
  store %struct.data_s* %14, %struct.data_s** %3, align 8, !dbg !328
  %15 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !333
  %16 = icmp ne %struct.data_s* %15, null, !dbg !333
  br i1 %16, label %17, label %18, !dbg !336

17:                                               ; preds = %8
  br label %19, !dbg !336

18:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([59 x i8], [59 x i8]* @.str.1, i64 0, i64 0), i32 noundef 36, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t1, i64 0, i64 0)) #5, !dbg !333
  unreachable, !dbg !333

19:                                               ; preds = %17
  ret void, !dbg !337
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @t2(i64 noundef %0) #0 !dbg !338 {
  %2 = alloca i64, align 8
  %3 = alloca i8, align 1
  %4 = alloca %struct.data_s*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !339, metadata !DIExpression()), !dbg !340
  call void @llvm.dbg.declare(metadata i8* %3, metadata !341, metadata !DIExpression()), !dbg !342
  %5 = load i64, i64* %2, align 8, !dbg !343
  %6 = load i64, i64* @g_new_key, align 8, !dbg !344
  %7 = load i64, i64* @g_new_key, align 8, !dbg !345
  %8 = call zeroext i1 @imap_add(i64 noundef %5, i64 noundef %6, i64 noundef %7), !dbg !346
  %9 = zext i1 %8 to i8, !dbg !342
  store i8 %9, i8* %3, align 1, !dbg !342
  %10 = load i8, i8* %3, align 1, !dbg !347
  %11 = trunc i8 %10 to i1, !dbg !347
  br i1 %11, label %12, label %13, !dbg !350

12:                                               ; preds = %1
  br label %14, !dbg !350

13:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([59 x i8], [59 x i8]* @.str.1, i64 0, i64 0), i32 noundef 42, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t2, i64 0, i64 0)) #5, !dbg !347
  unreachable, !dbg !347

14:                                               ; preds = %12
  call void @llvm.dbg.declare(metadata %struct.data_s** %4, metadata !351, metadata !DIExpression()), !dbg !352
  %15 = load i64, i64* %2, align 8, !dbg !353
  %16 = load i64, i64* @g_new_key, align 8, !dbg !354
  %17 = call i8* @imap_get(i64 noundef %15, i64 noundef %16), !dbg !355
  %18 = bitcast i8* %17 to %struct.data_s*, !dbg !355
  store %struct.data_s* %18, %struct.data_s** %4, align 8, !dbg !352
  %19 = load %struct.data_s*, %struct.data_s** %4, align 8, !dbg !356
  %20 = icmp ne %struct.data_s* %19, null, !dbg !356
  br i1 %20, label %21, label %22, !dbg !359

21:                                               ; preds = %14
  br label %23, !dbg !359

22:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([59 x i8], [59 x i8]* @.str.1, i64 0, i64 0), i32 noundef 44, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t2, i64 0, i64 0)) #5, !dbg !356
  unreachable, !dbg !356

23:                                               ; preds = %21
  ret void, !dbg !360
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !361 {
  %1 = alloca i64, align 8
  %2 = alloca %struct.data_s*, align 8
  %3 = alloca %struct.data_s*, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !362, metadata !DIExpression()), !dbg !364
  store i64 0, i64* %1, align 8, !dbg !364
  br label %4, !dbg !365

4:                                                ; preds = %18, %0
  %5 = load i64, i64* %1, align 8, !dbg !366
  %6 = icmp ult i64 %5, 2, !dbg !368
  br i1 %6, label %7, label %21, !dbg !369

7:                                                ; preds = %4
  call void @llvm.dbg.declare(metadata %struct.data_s** %2, metadata !370, metadata !DIExpression()), !dbg !372
  %8 = load i64, i64* %1, align 8, !dbg !373
  %9 = getelementptr inbounds [2 x i64], [2 x i64]* @g_pre_keys, i64 0, i64 %8, !dbg !374
  %10 = load i64, i64* %9, align 8, !dbg !374
  %11 = call i8* @imap_get(i64 noundef 3, i64 noundef %10), !dbg !375
  %12 = bitcast i8* %11 to %struct.data_s*, !dbg !375
  store %struct.data_s* %12, %struct.data_s** %2, align 8, !dbg !372
  %13 = load %struct.data_s*, %struct.data_s** %2, align 8, !dbg !376
  %14 = icmp ne %struct.data_s* %13, null, !dbg !376
  br i1 %14, label %15, label %16, !dbg !379

15:                                               ; preds = %7
  br label %17, !dbg !379

16:                                               ; preds = %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([59 x i8], [59 x i8]* @.str.1, i64 0, i64 0), i32 noundef 51, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.post, i64 0, i64 0)) #5, !dbg !376
  unreachable, !dbg !376

17:                                               ; preds = %15
  br label %18, !dbg !380

18:                                               ; preds = %17
  %19 = load i64, i64* %1, align 8, !dbg !381
  %20 = add i64 %19, 1, !dbg !381
  store i64 %20, i64* %1, align 8, !dbg !381
  br label %4, !dbg !382, !llvm.loop !383

21:                                               ; preds = %4
  call void @llvm.dbg.declare(metadata %struct.data_s** %3, metadata !385, metadata !DIExpression()), !dbg !386
  %22 = load i64, i64* @g_new_key, align 8, !dbg !387
  %23 = call i8* @imap_get(i64 noundef 3, i64 noundef %22), !dbg !388
  %24 = bitcast i8* %23 to %struct.data_s*, !dbg !388
  store %struct.data_s* %24, %struct.data_s** %3, align 8, !dbg !386
  %25 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !389
  %26 = icmp ne %struct.data_s* %25, null, !dbg !389
  br i1 %26, label %27, label %28, !dbg !392

27:                                               ; preds = %21
  br label %29, !dbg !392

28:                                               ; preds = %21
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([59 x i8], [59 x i8]* @.str.1, i64 0, i64 0), i32 noundef 54, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.post, i64 0, i64 0)) #5, !dbg !389
  unreachable, !dbg !389

29:                                               ; preds = %27
  ret void, !dbg !393
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !394 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !396, metadata !DIExpression()), !dbg !397
  call void @llvm.dbg.declare(metadata i64* %3, metadata !398, metadata !DIExpression()), !dbg !399
  %4 = load i8*, i8** %2, align 8, !dbg !400
  %5 = ptrtoint i8* %4 to i64, !dbg !401
  store i64 %5, i64* %3, align 8, !dbg !399
  %6 = load i64, i64* %3, align 8, !dbg !402
  %7 = icmp ult i64 %6, 3, !dbg !402
  br i1 %7, label %8, label %9, !dbg !405

8:                                                ; preds = %1
  br label %10, !dbg !405

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.5, i64 0, i64 0), i32 noundef 97, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !402
  unreachable, !dbg !402

10:                                               ; preds = %8
  %11 = load i64, i64* %3, align 8, !dbg !406
  call void @reg(i64 noundef %11), !dbg !407
  %12 = load i64, i64* %3, align 8, !dbg !408
  switch i64 %12, label %19 [
    i64 0, label %13
    i64 1, label %15
    i64 2, label %17
  ], !dbg !409

13:                                               ; preds = %10
  %14 = load i64, i64* %3, align 8, !dbg !410
  call void @t0(i64 noundef %14), !dbg !412
  br label %20, !dbg !413

15:                                               ; preds = %10
  %16 = load i64, i64* %3, align 8, !dbg !414
  call void @t1(i64 noundef %16), !dbg !415
  br label %20, !dbg !416

17:                                               ; preds = %10
  %18 = load i64, i64* %3, align 8, !dbg !417
  call void @t2(i64 noundef %18), !dbg !418
  br label %20, !dbg !419

19:                                               ; preds = %10
  br label %20, !dbg !420

20:                                               ; preds = %19, %17, %15, %13
  %21 = load i64, i64* %3, align 8, !dbg !421
  call void @dereg(i64 noundef %21), !dbg !422
  ret i8* null, !dbg !423
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reg(i64 noundef %0) #0 !dbg !424 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !426, metadata !DIExpression()), !dbg !427
  %3 = load i64, i64* %2, align 8, !dbg !428
  call void @imap_reg(i64 noundef %3), !dbg !429
  ret void, !dbg !430
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @dereg(i64 noundef %0) #0 !dbg !431 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !432, metadata !DIExpression()), !dbg !433
  %3 = load i64, i64* %2, align 8, !dbg !434
  call void @imap_dereg(i64 noundef %3), !dbg !435
  ret void, !dbg !436
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @tc() #0 !dbg !437 {
  call void @init(), !dbg !438
  call void @pre(), !dbg !439
  call void @launch_threads(i64 noundef 3, i8* (i8*)* noundef @run), !dbg !440
  call void @post(), !dbg !441
  call void @fini(), !dbg !442
  ret void, !dbg !443
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !444 {
  call void @imap_init(), !dbg !445
  ret void, !dbg !446
}

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !447 {
  %3 = alloca i64, align 8
  %4 = alloca i8* (i8*)*, align 8
  %5 = alloca %struct.run_info_t*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !450, metadata !DIExpression()), !dbg !451
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %4, metadata !452, metadata !DIExpression()), !dbg !453
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !454, metadata !DIExpression()), !dbg !455
  %6 = load i64, i64* %3, align 8, !dbg !456
  %7 = mul i64 32, %6, !dbg !457
  %8 = call noalias i8* @malloc(i64 noundef %7) #6, !dbg !458
  %9 = bitcast i8* %8 to %struct.run_info_t*, !dbg !458
  store %struct.run_info_t* %9, %struct.run_info_t** %5, align 8, !dbg !455
  %10 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !459
  %11 = load i64, i64* %3, align 8, !dbg !460
  %12 = load i8* (i8*)*, i8* (i8*)** %4, align 8, !dbg !461
  call void @create_threads(%struct.run_info_t* noundef %10, i64 noundef %11, i8* (i8*)* noundef %12, i1 noundef zeroext true), !dbg !462
  %13 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !463
  %14 = load i64, i64* %3, align 8, !dbg !464
  call void @await_threads(%struct.run_info_t* noundef %13, i64 noundef %14), !dbg !465
  %15 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !466
  %16 = bitcast %struct.run_info_t* %15 to i8*, !dbg !466
  call void @free(i8* noundef %16) #6, !dbg !467
  ret void, !dbg !468
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !469 {
  call void @imap_destroy(), !dbg !470
  ret void, !dbg !471
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_reg(i64 noundef %0) #0 !dbg !472 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !473, metadata !DIExpression()), !dbg !474
  br label %3, !dbg !475

3:                                                ; preds = %1
  br label %4, !dbg !476

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !478
  br label %6, !dbg !478

6:                                                ; preds = %4
  br label %7, !dbg !480

7:                                                ; preds = %6
  br label %8, !dbg !478

8:                                                ; preds = %7
  br label %9, !dbg !476

9:                                                ; preds = %8
  call void @vsimpleht_thread_register(%struct.vsimpleht_s* noundef @g_simpleht), !dbg !482
  ret void, !dbg !483
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_dereg(i64 noundef %0) #0 !dbg !484 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !485, metadata !DIExpression()), !dbg !486
  br label %3, !dbg !487

3:                                                ; preds = %1
  br label %4, !dbg !488

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !490
  br label %6, !dbg !490

6:                                                ; preds = %4
  br label %7, !dbg !492

7:                                                ; preds = %6
  br label %8, !dbg !490

8:                                                ; preds = %7
  br label %9, !dbg !488

9:                                                ; preds = %8
  call void @vsimpleht_thread_deregister(%struct.vsimpleht_s* noundef @g_simpleht), !dbg !494
  ret void, !dbg !495
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_init() #0 !dbg !496 {
  %1 = alloca i64, align 8
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !497, metadata !DIExpression()), !dbg !498
  %4 = call i64 @vsimpleht_buff_size(i64 noundef 4), !dbg !499
  store i64 %4, i64* %1, align 8, !dbg !498
  call void @llvm.dbg.declare(metadata i8** %2, metadata !500, metadata !DIExpression()), !dbg !501
  %5 = load i64, i64* %1, align 8, !dbg !502
  %6 = call noalias i8* @malloc(i64 noundef %5) #6, !dbg !503
  store i8* %6, i8** %2, align 8, !dbg !501
  %7 = load i8*, i8** %2, align 8, !dbg !504
  call void @vsimpleht_init(%struct.vsimpleht_s* noundef @g_simpleht, i8* noundef %7, i64 noundef 4, i8 (i64, i64)* noundef @cb_cmp, i64 (i64)* noundef @cb_hash, void (i8*)* noundef @cb_destroy), !dbg !505
  call void @llvm.dbg.declare(metadata i64* %3, metadata !506, metadata !DIExpression()), !dbg !508
  store i64 0, i64* %3, align 8, !dbg !508
  br label %8, !dbg !509

8:                                                ; preds = %16, %0
  %9 = load i64, i64* %3, align 8, !dbg !510
  %10 = icmp ult i64 %9, 4, !dbg !512
  br i1 %10, label %11, label %19, !dbg !513

11:                                               ; preds = %8
  %12 = load i64, i64* %3, align 8, !dbg !514
  %13 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %12, !dbg !516
  call void @trace_init(%struct.trace_s* noundef %13, i64 noundef 8), !dbg !517
  %14 = load i64, i64* %3, align 8, !dbg !518
  %15 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_rem, i64 0, i64 %14, !dbg !519
  call void @trace_init(%struct.trace_s* noundef %15, i64 noundef 8), !dbg !520
  br label %16, !dbg !521

16:                                               ; preds = %11
  %17 = load i64, i64* %3, align 8, !dbg !522
  %18 = add i64 %17, 1, !dbg !522
  store i64 %18, i64* %3, align 8, !dbg !522
  br label %8, !dbg !523, !llvm.loop !524

19:                                               ; preds = %8
  ret void, !dbg !526
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_destroy() #0 !dbg !527 {
  %1 = alloca i64, align 8
  call void @_imap_verify(), !dbg !528
  call void @llvm.dbg.declare(metadata i64* %1, metadata !529, metadata !DIExpression()), !dbg !531
  store i64 0, i64* %1, align 8, !dbg !531
  br label %2, !dbg !532

2:                                                ; preds = %10, %0
  %3 = load i64, i64* %1, align 8, !dbg !533
  %4 = icmp ult i64 %3, 4, !dbg !535
  br i1 %4, label %5, label %13, !dbg !536

5:                                                ; preds = %2
  %6 = load i64, i64* %1, align 8, !dbg !537
  %7 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %6, !dbg !539
  call void @trace_destroy(%struct.trace_s* noundef %7), !dbg !540
  %8 = load i64, i64* %1, align 8, !dbg !541
  %9 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_rem, i64 0, i64 %8, !dbg !542
  call void @trace_destroy(%struct.trace_s* noundef %9), !dbg !543
  br label %10, !dbg !544

10:                                               ; preds = %5
  %11 = load i64, i64* %1, align 8, !dbg !545
  %12 = add i64 %11, 1, !dbg !545
  store i64 %12, i64* %1, align 8, !dbg !545
  br label %2, !dbg !546, !llvm.loop !547

13:                                               ; preds = %2
  call void @vsimpleht_destroy(%struct.vsimpleht_s* noundef @g_simpleht), !dbg !549
  %14 = load i8*, i8** @g_buff, align 8, !dbg !550
  call void @free(i8* noundef %14) #6, !dbg !551
  store i8* null, i8** @g_buff, align 8, !dbg !552
  ret void, !dbg !553
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !554 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @tc(), !dbg !557
  ret i32 0, !dbg !558
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i32 @vsimpleht_add(%struct.vsimpleht_s* noundef %0, i64 noundef %1, i8* noundef %2) #0 !dbg !559 {
  %4 = alloca %struct.vsimpleht_s*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i8*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %4, metadata !564, metadata !DIExpression()), !dbg !565
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !566, metadata !DIExpression()), !dbg !567
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !568, metadata !DIExpression()), !dbg !569
  %7 = load i64, i64* %5, align 8, !dbg !570
  %8 = icmp ne i64 %7, 0, !dbg !570
  br i1 %8, label %9, label %10, !dbg !573

9:                                                ; preds = %3
  br label %11, !dbg !573

10:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 243, i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @__PRETTY_FUNCTION__.vsimpleht_add, i64 0, i64 0)) #5, !dbg !570
  unreachable, !dbg !570

11:                                               ; preds = %9
  %12 = load i8*, i8** %6, align 8, !dbg !574
  %13 = icmp ne i8* %12, null, !dbg !574
  br i1 %13, label %14, label %15, !dbg !577

14:                                               ; preds = %11
  br label %16, !dbg !577

15:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.8, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 244, i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @__PRETTY_FUNCTION__.vsimpleht_add, i64 0, i64 0)) #5, !dbg !574
  unreachable, !dbg !574

16:                                               ; preds = %14
  %17 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !578
  call void @_vsimpleht_give_cleanup_a_chance(%struct.vsimpleht_s* noundef %17), !dbg !579
  %18 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !580
  %19 = load i64, i64* %5, align 8, !dbg !581
  %20 = load i8*, i8** %6, align 8, !dbg !582
  %21 = call i32 @_vsimpleht_add(%struct.vsimpleht_s* noundef %18, i64 noundef %19, i8* noundef %20), !dbg !583
  ret i32 %21, !dbg !584
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_add(%struct.trace_s* noundef %0, i64 noundef %1) #0 !dbg !585 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !589, metadata !DIExpression()), !dbg !590
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !591, metadata !DIExpression()), !dbg !592
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !593
  %6 = icmp ne %struct.trace_s* %5, null, !dbg !593
  br i1 %6, label %7, label %8, !dbg !596

7:                                                ; preds = %2
  br label %9, !dbg !596

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 155, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__.trace_add, i64 0, i64 0)) #5, !dbg !593
  unreachable, !dbg !593

9:                                                ; preds = %7
  %10 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !597
  %11 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %10, i32 0, i32 3, !dbg !597
  %12 = load i8, i8* %11, align 8, !dbg !597
  %13 = trunc i8 %12 to i1, !dbg !597
  br i1 %13, label %14, label %15, !dbg !600

14:                                               ; preds = %9
  br label %16, !dbg !600

15:                                               ; preds = %9
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 156, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__.trace_add, i64 0, i64 0)) #5, !dbg !597
  unreachable, !dbg !597

16:                                               ; preds = %14
  %17 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !601
  %18 = load i64, i64* %4, align 8, !dbg !602
  call void @_trace_add_or_rem_occurrences(%struct.trace_s* noundef %17, i64 noundef %18, i64 noundef 1, i1 noundef zeroext false), !dbg !603
  ret void, !dbg !604
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @_vsimpleht_give_cleanup_a_chance(%struct.vsimpleht_s* noundef %0) #0 !dbg !605 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !608, metadata !DIExpression()), !dbg !609
  %3 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !610
  %4 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %3, i32 0, i32 7, !dbg !612
  %5 = call zeroext i1 @rwlock_acquired_by_writer(%struct.rwlock_s* noundef %4), !dbg !613
  br i1 %5, label %6, label %18, !dbg !614

6:                                                ; preds = %1
  %7 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !615
  %8 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %7, i32 0, i32 7, !dbg !615
  %9 = call zeroext i1 @rwlock_acquired_by_readers(%struct.rwlock_s* noundef %8), !dbg !615
  br i1 %9, label %10, label %12, !dbg !615

10:                                               ; preds = %6
  br i1 true, label %11, label %12, !dbg !619

11:                                               ; preds = %10
  br label %13, !dbg !619

12:                                               ; preds = %10, %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([112 x i8], [112 x i8]* @.str.10, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 487, i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @__PRETTY_FUNCTION__._vsimpleht_give_cleanup_a_chance, i64 0, i64 0)) #5, !dbg !615
  unreachable, !dbg !615

13:                                               ; preds = %11
  %14 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !620
  %15 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %14, i32 0, i32 7, !dbg !621
  call void @rwlock_read_release(%struct.rwlock_s* noundef %15), !dbg !622
  %16 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !623
  %17 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %16, i32 0, i32 7, !dbg !624
  call void @rwlock_read_acquire(%struct.rwlock_s* noundef %17), !dbg !625
  br label %18, !dbg !626

18:                                               ; preds = %13, %1
  ret void, !dbg !627
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @_vsimpleht_add(%struct.vsimpleht_s* noundef %0, i64 noundef %1, i8* noundef %2) #0 !dbg !628 {
  %4 = alloca i32, align 4
  %5 = alloca %struct.vsimpleht_s*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca i8*, align 8
  %11 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %5, metadata !629, metadata !DIExpression()), !dbg !630
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !631, metadata !DIExpression()), !dbg !632
  store i8* %2, i8** %7, align 8
  call void @llvm.dbg.declare(metadata i8** %7, metadata !633, metadata !DIExpression()), !dbg !634
  call void @llvm.dbg.declare(metadata i64* %8, metadata !635, metadata !DIExpression()), !dbg !636
  store i64 0, i64* %8, align 8, !dbg !636
  call void @llvm.dbg.declare(metadata i64* %9, metadata !637, metadata !DIExpression()), !dbg !638
  store i64 0, i64* %9, align 8, !dbg !638
  call void @llvm.dbg.declare(metadata i8** %10, metadata !639, metadata !DIExpression()), !dbg !640
  store i8* null, i8** %10, align 8, !dbg !640
  call void @llvm.dbg.declare(metadata i64* %11, metadata !641, metadata !DIExpression()), !dbg !642
  store i64 0, i64* %11, align 8, !dbg !642
  %12 = load i64, i64* %6, align 8, !dbg !643
  %13 = icmp ne i64 %12, 0, !dbg !643
  br i1 %13, label %14, label %16, !dbg !643

14:                                               ; preds = %3
  br i1 true, label %15, label %16, !dbg !646

15:                                               ; preds = %14
  br label %17, !dbg !646

16:                                               ; preds = %14, %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.14, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 423, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !643
  unreachable, !dbg !643

17:                                               ; preds = %15
  %18 = load i8*, i8** %7, align 8, !dbg !647
  %19 = icmp ne i8* %18, null, !dbg !647
  br i1 %19, label %20, label %22, !dbg !647

20:                                               ; preds = %17
  br i1 true, label %21, label %22, !dbg !650

21:                                               ; preds = %20
  br label %23, !dbg !650

22:                                               ; preds = %20, %17
  call void @__assert_fail(i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @.str.16, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 424, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !647
  unreachable, !dbg !647

23:                                               ; preds = %21
  %24 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !651
  %25 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %24, i32 0, i32 3, !dbg !653
  %26 = load i64 (i64)*, i64 (i64)** %25, align 8, !dbg !653
  %27 = load i64, i64* %6, align 8, !dbg !654
  %28 = call i64 %26(i64 noundef %27), !dbg !651
  store i64 %28, i64* %8, align 8, !dbg !655
  br label %29, !dbg !656

29:                                               ; preds = %126, %23
  %30 = load i64, i64* %11, align 8, !dbg !657
  %31 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !659
  %32 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %31, i32 0, i32 0, !dbg !660
  %33 = load i64, i64* %32, align 8, !dbg !660
  %34 = icmp ult i64 %30, %33, !dbg !661
  br i1 %34, label %35, label %131, !dbg !662

35:                                               ; preds = %29
  %36 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !663
  %37 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %36, i32 0, i32 0, !dbg !665
  %38 = load i64, i64* %37, align 8, !dbg !665
  %39 = sub i64 %38, 1, !dbg !666
  %40 = load i64, i64* %8, align 8, !dbg !667
  %41 = and i64 %40, %39, !dbg !667
  store i64 %41, i64* %8, align 8, !dbg !667
  %42 = load i64, i64* %8, align 8, !dbg !668
  %43 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !668
  %44 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %43, i32 0, i32 0, !dbg !668
  %45 = load i64, i64* %44, align 8, !dbg !668
  %46 = icmp ult i64 %42, %45, !dbg !668
  br i1 %46, label %47, label %48, !dbg !671

47:                                               ; preds = %35
  br label %49, !dbg !671

48:                                               ; preds = %35
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.17, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 431, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !668
  unreachable, !dbg !668

49:                                               ; preds = %47
  %50 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !672
  %51 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %50, i32 0, i32 1, !dbg !673
  %52 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %51, align 8, !dbg !673
  %53 = load i64, i64* %8, align 8, !dbg !674
  %54 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %52, i64 %53, !dbg !672
  %55 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %54, i32 0, i32 0, !dbg !675
  %56 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %55), !dbg !676
  %57 = ptrtoint i8* %56 to i64, !dbg !677
  store i64 %57, i64* %9, align 8, !dbg !678
  %58 = load i64, i64* %9, align 8, !dbg !679
  %59 = icmp eq i64 %58, 0, !dbg !681
  br i1 %59, label %60, label %84, !dbg !682

60:                                               ; preds = %49
  %61 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !683
  %62 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %61, i32 0, i32 1, !dbg !685
  %63 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %62, align 8, !dbg !685
  %64 = load i64, i64* %8, align 8, !dbg !686
  %65 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %63, i64 %64, !dbg !683
  %66 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %65, i32 0, i32 0, !dbg !687
  %67 = load i64, i64* %6, align 8, !dbg !688
  %68 = inttoptr i64 %67 to i8*, !dbg !689
  %69 = call i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %66, i8* noundef null, i8* noundef %68), !dbg !690
  %70 = ptrtoint i8* %69 to i64, !dbg !691
  store i64 %70, i64* %9, align 8, !dbg !692
  %71 = load i64, i64* %9, align 8, !dbg !693
  %72 = icmp ne i64 %71, 0, !dbg !695
  br i1 %72, label %73, label %83, !dbg !696

73:                                               ; preds = %60
  %74 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !697
  %75 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %74, i32 0, i32 2, !dbg !698
  %76 = load i8 (i64, i64)*, i8 (i64, i64)** %75, align 8, !dbg !698
  %77 = load i64, i64* %6, align 8, !dbg !699
  %78 = load i64, i64* %9, align 8, !dbg !700
  %79 = call signext i8 %76(i64 noundef %77, i64 noundef %78), !dbg !697
  %80 = sext i8 %79 to i32, !dbg !697
  %81 = icmp ne i32 %80, 0, !dbg !701
  br i1 %81, label %82, label %83, !dbg !702

82:                                               ; preds = %73
  br label %126, !dbg !703

83:                                               ; preds = %73, %60
  br label %95, !dbg !705

84:                                               ; preds = %49
  %85 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !706
  %86 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %85, i32 0, i32 2, !dbg !708
  %87 = load i8 (i64, i64)*, i8 (i64, i64)** %86, align 8, !dbg !708
  %88 = load i64, i64* %6, align 8, !dbg !709
  %89 = load i64, i64* %9, align 8, !dbg !710
  %90 = call signext i8 %87(i64 noundef %88, i64 noundef %89), !dbg !706
  %91 = sext i8 %90 to i32, !dbg !706
  %92 = icmp ne i32 %91, 0, !dbg !711
  br i1 %92, label %93, label %94, !dbg !712

93:                                               ; preds = %84
  br label %126, !dbg !713

94:                                               ; preds = %84
  br label %95

95:                                               ; preds = %94, %83
  %96 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !715
  %97 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %96, i32 0, i32 2, !dbg !715
  %98 = load i8 (i64, i64)*, i8 (i64, i64)** %97, align 8, !dbg !715
  %99 = load i64, i64* %6, align 8, !dbg !715
  %100 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !715
  %101 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %100, i32 0, i32 1, !dbg !715
  %102 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %101, align 8, !dbg !715
  %103 = load i64, i64* %8, align 8, !dbg !715
  %104 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %102, i64 %103, !dbg !715
  %105 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %104, i32 0, i32 0, !dbg !715
  %106 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %105), !dbg !715
  %107 = ptrtoint i8* %106 to i64, !dbg !715
  %108 = call signext i8 %98(i64 noundef %99, i64 noundef %107), !dbg !715
  %109 = sext i8 %108 to i32, !dbg !715
  %110 = icmp eq i32 %109, 0, !dbg !715
  br i1 %110, label %111, label %112, !dbg !718

111:                                              ; preds = %95
  br label %113, !dbg !718

112:                                              ; preds = %95
  call void @__assert_fail(i8* noundef getelementptr inbounds ([79 x i8], [79 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 451, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !715
  unreachable, !dbg !715

113:                                              ; preds = %111
  %114 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !719
  %115 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %114, i32 0, i32 1, !dbg !720
  %116 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %115, align 8, !dbg !720
  %117 = load i64, i64* %8, align 8, !dbg !721
  %118 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %116, i64 %117, !dbg !719
  %119 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %118, i32 0, i32 1, !dbg !722
  %120 = load i8*, i8** %7, align 8, !dbg !723
  %121 = call i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %119, i8* noundef null, i8* noundef %120), !dbg !724
  store i8* %121, i8** %10, align 8, !dbg !725
  %122 = load i8*, i8** %10, align 8, !dbg !726
  %123 = icmp eq i8* %122, null, !dbg !727
  %124 = zext i1 %123 to i64, !dbg !728
  %125 = select i1 %123, i32 0, i32 2, !dbg !728
  store i32 %125, i32* %4, align 4, !dbg !729
  br label %132, !dbg !729

126:                                              ; preds = %93, %82
  %127 = load i64, i64* %11, align 8, !dbg !730
  %128 = add i64 %127, 1, !dbg !730
  store i64 %128, i64* %11, align 8, !dbg !730
  %129 = load i64, i64* %8, align 8, !dbg !731
  %130 = add i64 %129, 1, !dbg !731
  store i64 %130, i64* %8, align 8, !dbg !731
  br label %29, !dbg !732, !llvm.loop !733

131:                                              ; preds = %29
  store i32 1, i32* %4, align 4, !dbg !735
  br label %132, !dbg !735

132:                                              ; preds = %131, %113
  %133 = load i32, i32* %4, align 4, !dbg !736
  ret i32 %133, !dbg !736
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @rwlock_acquired_by_writer(%struct.rwlock_s* noundef %0) #0 !dbg !737 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !741, metadata !DIExpression()), !dbg !742
  %3 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !743
  %4 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %3, i32 0, i32 1, !dbg !744
  %5 = call zeroext i8 @vatomic8_read_rlx(%struct.vatomic8_s* noundef %4), !dbg !745
  %6 = zext i8 %5 to i32, !dbg !745
  %7 = icmp eq i32 %6, 1, !dbg !746
  ret i1 %7, !dbg !747
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @rwlock_acquired_by_readers(%struct.rwlock_s* noundef %0) #0 !dbg !748 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !749, metadata !DIExpression()), !dbg !750
  br label %3, !dbg !751

3:                                                ; preds = %1
  br label %4, !dbg !752

4:                                                ; preds = %3
  %5 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !754
  br label %6, !dbg !754

6:                                                ; preds = %4
  br label %7, !dbg !756

7:                                                ; preds = %6
  br label %8, !dbg !754

8:                                                ; preds = %7
  br label %9, !dbg !752

9:                                                ; preds = %8
  ret i1 true, !dbg !758
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_read_release(%struct.rwlock_s* noundef %0) #0 !dbg !759 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !762, metadata !DIExpression()), !dbg !763
  call void @llvm.dbg.declare(metadata i32* %3, metadata !764, metadata !DIExpression()), !dbg !765
  %4 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !766
  %5 = call i32 @_rwlock_get_tid(%struct.rwlock_s* noundef %4), !dbg !767
  store i32 %5, i32* %3, align 4, !dbg !765
  %6 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !768
  %7 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %6, i32 0, i32 0, !dbg !769
  %8 = load i32, i32* %3, align 4, !dbg !770
  %9 = zext i32 %8 to i64, !dbg !768
  %10 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %7, i64 0, i64 %9, !dbg !768
  %11 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef %10) #6, !dbg !771
  ret void, !dbg !772
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_read_acquire(%struct.rwlock_s* noundef %0) #0 !dbg !773 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !774, metadata !DIExpression()), !dbg !775
  call void @llvm.dbg.declare(metadata i32* %3, metadata !776, metadata !DIExpression()), !dbg !777
  %4 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !778
  %5 = call i32 @_rwlock_get_tid(%struct.rwlock_s* noundef %4), !dbg !779
  store i32 %5, i32* %3, align 4, !dbg !777
  %6 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !780
  %7 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %6, i32 0, i32 0, !dbg !781
  %8 = load i32, i32* %3, align 4, !dbg !782
  %9 = zext i32 %8 to i64, !dbg !780
  %10 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %7, i64 0, i64 %9, !dbg !780
  %11 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef %10) #6, !dbg !783
  ret void, !dbg !784
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i8 @vatomic8_read_rlx(%struct.vatomic8_s* noundef %0) #0 !dbg !785 {
  %2 = alloca %struct.vatomic8_s*, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  store %struct.vatomic8_s* %0, %struct.vatomic8_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic8_s** %2, metadata !791, metadata !DIExpression()), !dbg !792
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !793, !srcloc !794
  call void @llvm.dbg.declare(metadata i8* %3, metadata !795, metadata !DIExpression()), !dbg !796
  %5 = load %struct.vatomic8_s*, %struct.vatomic8_s** %2, align 8, !dbg !797
  %6 = getelementptr inbounds %struct.vatomic8_s, %struct.vatomic8_s* %5, i32 0, i32 0, !dbg !798
  %7 = load atomic i8, i8* %6 monotonic, align 1, !dbg !799
  store i8 %7, i8* %4, align 1, !dbg !799
  %8 = load i8, i8* %4, align 1, !dbg !799
  store i8 %8, i8* %3, align 1, !dbg !796
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !800, !srcloc !801
  %9 = load i8, i8* %3, align 1, !dbg !802
  ret i8 %9, !dbg !803
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @_rwlock_get_tid(%struct.rwlock_s* noundef %0) #0 !dbg !804 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !807, metadata !DIExpression()), !dbg !808
  %3 = load i32, i32* @g_tid, align 4, !dbg !809
  %4 = icmp eq i32 %3, 3, !dbg !811
  br i1 %4, label %5, label %14, !dbg !812

5:                                                ; preds = %1
  %6 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !813
  %7 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %6, i32 0, i32 2, !dbg !815
  %8 = call i32 @vatomic32_get_inc(%struct.vatomic32_s* noundef %7), !dbg !816
  store i32 %8, i32* @g_tid, align 4, !dbg !817
  %9 = load i32, i32* @g_tid, align 4, !dbg !818
  %10 = icmp ult i32 %9, 3, !dbg !818
  br i1 %10, label %11, label %12, !dbg !821

11:                                               ; preds = %5
  br label %13, !dbg !821

12:                                               ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.12, i64 0, i64 0), i32 noundef 93, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__._rwlock_get_tid, i64 0, i64 0)) #5, !dbg !818
  unreachable, !dbg !818

13:                                               ; preds = %11
  br label %14, !dbg !822

14:                                               ; preds = %13, %1
  %15 = load i32, i32* @g_tid, align 4, !dbg !823
  ret i32 %15, !dbg !824
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc(%struct.vatomic32_s* noundef %0) #0 !dbg !825 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !830, metadata !DIExpression()), !dbg !831
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !832
  %4 = call i32 @vatomic32_get_add(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !833
  ret i32 %4, !dbg !834
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !835 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !838, metadata !DIExpression()), !dbg !839
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !840, metadata !DIExpression()), !dbg !841
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !842, !srcloc !843
  call void @llvm.dbg.declare(metadata i32* %5, metadata !844, metadata !DIExpression()), !dbg !845
  %8 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !846
  %9 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %8, i32 0, i32 0, !dbg !847
  %10 = load i32, i32* %4, align 4, !dbg !848
  store i32 %10, i32* %6, align 4, !dbg !849
  %11 = load i32, i32* %6, align 4, !dbg !849
  %12 = atomicrmw add i32* %9, i32 %11 seq_cst, align 4, !dbg !849
  store i32 %12, i32* %7, align 4, !dbg !849
  %13 = load i32, i32* %7, align 4, !dbg !849
  store i32 %13, i32* %5, align 4, !dbg !845
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !850, !srcloc !851
  %14 = load i32, i32* %5, align 4, !dbg !852
  ret i32 %14, !dbg !853
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %0) #0 !dbg !854 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !859, metadata !DIExpression()), !dbg !860
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !861, !srcloc !862
  call void @llvm.dbg.declare(metadata i8** %3, metadata !863, metadata !DIExpression()), !dbg !864
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !865
  %6 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %5, i32 0, i32 0, !dbg !866
  %7 = bitcast i8** %6 to i64*, !dbg !867
  %8 = bitcast i8** %4 to i64*, !dbg !867
  %9 = load atomic i64, i64* %7 seq_cst, align 8, !dbg !867
  store i64 %9, i64* %8, align 8, !dbg !867
  %10 = bitcast i64* %8 to i8**, !dbg !867
  %11 = load i8*, i8** %10, align 8, !dbg !867
  store i8* %11, i8** %3, align 8, !dbg !864
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !868, !srcloc !869
  %12 = load i8*, i8** %3, align 8, !dbg !870
  ret i8* %12, !dbg !871
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !872 {
  %4 = alloca %struct.vatomicptr_s*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i8*, align 8
  %9 = alloca i8, align 1
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %4, metadata !876, metadata !DIExpression()), !dbg !877
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !878, metadata !DIExpression()), !dbg !879
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !880, metadata !DIExpression()), !dbg !881
  call void @llvm.dbg.declare(metadata i8** %7, metadata !882, metadata !DIExpression()), !dbg !883
  %10 = load i8*, i8** %5, align 8, !dbg !884
  store i8* %10, i8** %7, align 8, !dbg !883
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !885, !srcloc !886
  %11 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %4, align 8, !dbg !887
  %12 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %11, i32 0, i32 0, !dbg !888
  %13 = load i8*, i8** %6, align 8, !dbg !889
  store i8* %13, i8** %8, align 8, !dbg !890
  %14 = bitcast i8** %12 to i64*, !dbg !890
  %15 = bitcast i8** %7 to i64*, !dbg !890
  %16 = bitcast i8** %8 to i64*, !dbg !890
  %17 = load i64, i64* %15, align 8, !dbg !890
  %18 = load i64, i64* %16, align 8, !dbg !890
  %19 = cmpxchg i64* %14, i64 %17, i64 %18 seq_cst seq_cst, align 8, !dbg !890
  %20 = extractvalue { i64, i1 } %19, 0, !dbg !890
  %21 = extractvalue { i64, i1 } %19, 1, !dbg !890
  br i1 %21, label %23, label %22, !dbg !890

22:                                               ; preds = %3
  store i64 %20, i64* %15, align 8, !dbg !890
  br label %23, !dbg !890

23:                                               ; preds = %22, %3
  %24 = zext i1 %21 to i8, !dbg !890
  store i8 %24, i8* %9, align 1, !dbg !890
  %25 = load i8, i8* %9, align 1, !dbg !890
  %26 = trunc i8 %25 to i1, !dbg !890
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !891, !srcloc !892
  %27 = load i8*, i8** %7, align 8, !dbg !893
  ret i8* %27, !dbg !894
}

; Function Attrs: noinline nounwind uwtable
define internal void @_trace_add_or_rem_occurrences(%struct.trace_s* noundef %0, i64 noundef %1, i64 noundef %2, i1 noundef zeroext %3) #0 !dbg !895 {
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  %10 = alloca i8, align 1
  store %struct.trace_s* %0, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !898, metadata !DIExpression()), !dbg !899
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !900, metadata !DIExpression()), !dbg !901
  store i64 %2, i64* %7, align 8
  call void @llvm.dbg.declare(metadata i64* %7, metadata !902, metadata !DIExpression()), !dbg !903
  %11 = zext i1 %3 to i8
  store i8 %11, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !904, metadata !DIExpression()), !dbg !905
  call void @llvm.dbg.declare(metadata i64* %9, metadata !906, metadata !DIExpression()), !dbg !907
  store i64 0, i64* %9, align 8, !dbg !907
  call void @llvm.dbg.declare(metadata i8* %10, metadata !908, metadata !DIExpression()), !dbg !909
  store i8 0, i8* %10, align 1, !dbg !909
  %12 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !910
  %13 = icmp ne %struct.trace_s* %12, null, !dbg !910
  br i1 %13, label %14, label %15, !dbg !913

14:                                               ; preds = %4
  br label %16, !dbg !913

15:                                               ; preds = %4
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 128, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !910
  unreachable, !dbg !910

16:                                               ; preds = %14
  %17 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !914
  %18 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %17, i32 0, i32 3, !dbg !914
  %19 = load i8, i8* %18, align 8, !dbg !914
  %20 = trunc i8 %19 to i1, !dbg !914
  br i1 %20, label %21, label %22, !dbg !917

21:                                               ; preds = %16
  br label %23, !dbg !917

22:                                               ; preds = %16
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 129, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !914
  unreachable, !dbg !914

23:                                               ; preds = %21
  %24 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !918
  %25 = load i64, i64* %6, align 8, !dbg !919
  %26 = call zeroext i1 @trace_find_unit_idx(%struct.trace_s* noundef %24, i64 noundef %25, i64* noundef %9), !dbg !920
  %27 = zext i1 %26 to i8, !dbg !921
  store i8 %27, i8* %10, align 1, !dbg !921
  %28 = load i8, i8* %8, align 1, !dbg !922
  %29 = trunc i8 %28 to i1, !dbg !922
  br i1 %29, label %30, label %57, !dbg !924

30:                                               ; preds = %23
  %31 = load i8, i8* %10, align 1, !dbg !925
  %32 = trunc i8 %31 to i1, !dbg !925
  br i1 %32, label %33, label %34, !dbg !929

33:                                               ; preds = %30
  br label %35, !dbg !929

34:                                               ; preds = %30
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.22, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 134, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !925
  unreachable, !dbg !925

35:                                               ; preds = %33
  %36 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !930
  %37 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %36, i32 0, i32 0, !dbg !930
  %38 = load %struct.trace_unit_s*, %struct.trace_unit_s** %37, align 8, !dbg !930
  %39 = load i64, i64* %9, align 8, !dbg !930
  %40 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %38, i64 %39, !dbg !930
  %41 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %40, i32 0, i32 1, !dbg !930
  %42 = load i64, i64* %41, align 8, !dbg !930
  %43 = load i64, i64* %7, align 8, !dbg !930
  %44 = icmp uge i64 %42, %43, !dbg !930
  br i1 %44, label %45, label %46, !dbg !933

45:                                               ; preds = %35
  br label %47, !dbg !933

46:                                               ; preds = %35
  call void @__assert_fail(i8* noundef getelementptr inbounds ([33 x i8], [33 x i8]* @.str.23, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 135, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !930
  unreachable, !dbg !930

47:                                               ; preds = %45
  %48 = load i64, i64* %7, align 8, !dbg !934
  %49 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !935
  %50 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %49, i32 0, i32 0, !dbg !936
  %51 = load %struct.trace_unit_s*, %struct.trace_unit_s** %50, align 8, !dbg !936
  %52 = load i64, i64* %9, align 8, !dbg !937
  %53 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %51, i64 %52, !dbg !935
  %54 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %53, i32 0, i32 1, !dbg !938
  %55 = load i64, i64* %54, align 8, !dbg !939
  %56 = sub i64 %55, %48, !dbg !939
  store i64 %56, i64* %54, align 8, !dbg !939
  br label %97, !dbg !940

57:                                               ; preds = %23
  %58 = load i8, i8* %10, align 1, !dbg !941
  %59 = trunc i8 %58 to i1, !dbg !941
  br i1 %59, label %87, label %60, !dbg !943

60:                                               ; preds = %57
  %61 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !944
  %62 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %61, i32 0, i32 1, !dbg !946
  %63 = load i64, i64* %62, align 8, !dbg !947
  %64 = add i64 %63, 1, !dbg !947
  store i64 %64, i64* %62, align 8, !dbg !947
  store i64 %63, i64* %9, align 8, !dbg !948
  %65 = load i64, i64* %9, align 8, !dbg !949
  %66 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !951
  %67 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %66, i32 0, i32 2, !dbg !952
  %68 = load i64, i64* %67, align 8, !dbg !952
  %69 = icmp uge i64 %65, %68, !dbg !953
  br i1 %69, label %70, label %72, !dbg !954

70:                                               ; preds = %60
  %71 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !955
  call void @trace_extend(%struct.trace_s* noundef %71), !dbg !957
  br label %72, !dbg !958

72:                                               ; preds = %70, %60
  %73 = load i64, i64* %6, align 8, !dbg !959
  %74 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !960
  %75 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %74, i32 0, i32 0, !dbg !961
  %76 = load %struct.trace_unit_s*, %struct.trace_unit_s** %75, align 8, !dbg !961
  %77 = load i64, i64* %9, align 8, !dbg !962
  %78 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %76, i64 %77, !dbg !960
  %79 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %78, i32 0, i32 0, !dbg !963
  store i64 %73, i64* %79, align 8, !dbg !964
  %80 = load i64, i64* %7, align 8, !dbg !965
  %81 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !966
  %82 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %81, i32 0, i32 0, !dbg !967
  %83 = load %struct.trace_unit_s*, %struct.trace_unit_s** %82, align 8, !dbg !967
  %84 = load i64, i64* %9, align 8, !dbg !968
  %85 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %83, i64 %84, !dbg !966
  %86 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %85, i32 0, i32 1, !dbg !969
  store i64 %80, i64* %86, align 8, !dbg !970
  br label %97, !dbg !971

87:                                               ; preds = %57
  %88 = load i64, i64* %7, align 8, !dbg !972
  %89 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !974
  %90 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %89, i32 0, i32 0, !dbg !975
  %91 = load %struct.trace_unit_s*, %struct.trace_unit_s** %90, align 8, !dbg !975
  %92 = load i64, i64* %9, align 8, !dbg !976
  %93 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %91, i64 %92, !dbg !974
  %94 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %93, i32 0, i32 1, !dbg !977
  %95 = load i64, i64* %94, align 8, !dbg !978
  %96 = add i64 %95, %88, !dbg !978
  store i64 %96, i64* %94, align 8, !dbg !978
  br label %97

97:                                               ; preds = %47, %87, %72
  ret void, !dbg !979
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @trace_find_unit_idx(%struct.trace_s* noundef %0, i64 noundef %1, i64* noundef %2) #0 !dbg !980 {
  %4 = alloca i1, align 1
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64*, align 8
  %8 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !984, metadata !DIExpression()), !dbg !985
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !986, metadata !DIExpression()), !dbg !987
  store i64* %2, i64** %7, align 8
  call void @llvm.dbg.declare(metadata i64** %7, metadata !988, metadata !DIExpression()), !dbg !989
  call void @llvm.dbg.declare(metadata i64* %8, metadata !990, metadata !DIExpression()), !dbg !991
  store i64 0, i64* %8, align 8, !dbg !991
  %9 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !992
  %10 = icmp ne %struct.trace_s* %9, null, !dbg !992
  br i1 %10, label %11, label %12, !dbg !995

11:                                               ; preds = %3
  br label %13, !dbg !995

12:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 110, i8* noundef getelementptr inbounds ([62 x i8], [62 x i8]* @__PRETTY_FUNCTION__.trace_find_unit_idx, i64 0, i64 0)) #5, !dbg !992
  unreachable, !dbg !992

13:                                               ; preds = %11
  %14 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !996
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 3, !dbg !996
  %16 = load i8, i8* %15, align 8, !dbg !996
  %17 = trunc i8 %16 to i1, !dbg !996
  br i1 %17, label %18, label %19, !dbg !999

18:                                               ; preds = %13
  br label %20, !dbg !999

19:                                               ; preds = %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 111, i8* noundef getelementptr inbounds ([62 x i8], [62 x i8]* @__PRETTY_FUNCTION__.trace_find_unit_idx, i64 0, i64 0)) #5, !dbg !996
  unreachable, !dbg !996

20:                                               ; preds = %18
  store i64 0, i64* %8, align 8, !dbg !1000
  br label %21, !dbg !1002

21:                                               ; preds = %41, %20
  %22 = load i64, i64* %8, align 8, !dbg !1003
  %23 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1005
  %24 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %23, i32 0, i32 1, !dbg !1006
  %25 = load i64, i64* %24, align 8, !dbg !1006
  %26 = icmp ult i64 %22, %25, !dbg !1007
  br i1 %26, label %27, label %44, !dbg !1008

27:                                               ; preds = %21
  %28 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1009
  %29 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %28, i32 0, i32 0, !dbg !1012
  %30 = load %struct.trace_unit_s*, %struct.trace_unit_s** %29, align 8, !dbg !1012
  %31 = load i64, i64* %8, align 8, !dbg !1013
  %32 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %30, i64 %31, !dbg !1009
  %33 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %32, i32 0, i32 0, !dbg !1014
  %34 = load i64, i64* %33, align 8, !dbg !1014
  %35 = load i64, i64* %6, align 8, !dbg !1015
  %36 = icmp eq i64 %34, %35, !dbg !1016
  br i1 %36, label %37, label %40, !dbg !1017

37:                                               ; preds = %27
  %38 = load i64, i64* %8, align 8, !dbg !1018
  %39 = load i64*, i64** %7, align 8, !dbg !1020
  store i64 %38, i64* %39, align 8, !dbg !1021
  store i1 true, i1* %4, align 1, !dbg !1022
  br label %45, !dbg !1022

40:                                               ; preds = %27
  br label %41, !dbg !1023

41:                                               ; preds = %40
  %42 = load i64, i64* %8, align 8, !dbg !1024
  %43 = add i64 %42, 1, !dbg !1024
  store i64 %43, i64* %8, align 8, !dbg !1024
  br label %21, !dbg !1025, !llvm.loop !1026

44:                                               ; preds = %21
  store i1 false, i1* %4, align 1, !dbg !1028
  br label %45, !dbg !1028

45:                                               ; preds = %44, %37
  %46 = load i1, i1* %4, align 1, !dbg !1029
  ret i1 %46, !dbg !1029
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_extend(%struct.trace_s* noundef %0) #0 !dbg !1030 {
  %2 = alloca %struct.trace_s*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca %struct.trace_unit_s*, align 8
  %6 = alloca %struct.trace_unit_s*, align 8
  %7 = alloca i32, align 4
  store %struct.trace_s* %0, %struct.trace_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %2, metadata !1033, metadata !DIExpression()), !dbg !1034
  %8 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1035
  %9 = icmp ne %struct.trace_s* %8, null, !dbg !1035
  br i1 %9, label %10, label %11, !dbg !1038

10:                                               ; preds = %1
  br label %12, !dbg !1038

11:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 75, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.trace_extend, i64 0, i64 0)) #5, !dbg !1035
  unreachable, !dbg !1035

12:                                               ; preds = %10
  call void @llvm.dbg.declare(metadata i64* %3, metadata !1039, metadata !DIExpression()), !dbg !1040
  %13 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1041
  %14 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %13, i32 0, i32 2, !dbg !1042
  %15 = load i64, i64* %14, align 8, !dbg !1042
  %16 = mul i64 %15, 16, !dbg !1043
  store i64 %16, i64* %3, align 8, !dbg !1040
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1044, metadata !DIExpression()), !dbg !1045
  %17 = load i64, i64* %3, align 8, !dbg !1046
  %18 = mul i64 %17, 2, !dbg !1047
  store i64 %18, i64* %4, align 8, !dbg !1045
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %5, metadata !1048, metadata !DIExpression()), !dbg !1049
  %19 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1050
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 0, !dbg !1051
  %21 = load %struct.trace_unit_s*, %struct.trace_unit_s** %20, align 8, !dbg !1051
  store %struct.trace_unit_s* %21, %struct.trace_unit_s** %5, align 8, !dbg !1049
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %6, metadata !1052, metadata !DIExpression()), !dbg !1053
  %22 = load i64, i64* %4, align 8, !dbg !1054
  %23 = call noalias i8* @malloc(i64 noundef %22) #6, !dbg !1055
  %24 = bitcast i8* %23 to %struct.trace_unit_s*, !dbg !1055
  store %struct.trace_unit_s* %24, %struct.trace_unit_s** %6, align 8, !dbg !1053
  %25 = load %struct.trace_unit_s*, %struct.trace_unit_s** %6, align 8, !dbg !1056
  %26 = icmp ne %struct.trace_unit_s* %25, null, !dbg !1056
  br i1 %26, label %27, label %47, !dbg !1058

27:                                               ; preds = %12
  call void @llvm.dbg.declare(metadata i32* %7, metadata !1059, metadata !DIExpression()), !dbg !1061
  %28 = load %struct.trace_unit_s*, %struct.trace_unit_s** %6, align 8, !dbg !1062
  %29 = load i64, i64* %4, align 8, !dbg !1063
  %30 = load %struct.trace_unit_s*, %struct.trace_unit_s** %5, align 8, !dbg !1064
  %31 = load i64, i64* %3, align 8, !dbg !1065
  %32 = call i32 (%struct.trace_unit_s*, i64, %struct.trace_unit_s*, i64, ...) bitcast (i32 (...)* @memcpy_s to i32 (%struct.trace_unit_s*, i64, %struct.trace_unit_s*, i64, ...)*)(%struct.trace_unit_s* noundef %28, i64 noundef %29, %struct.trace_unit_s* noundef %30, i64 noundef %31), !dbg !1066
  store i32 %32, i32* %7, align 4, !dbg !1061
  %33 = load i32, i32* %7, align 4, !dbg !1067
  %34 = icmp eq i32 %33, 0, !dbg !1069
  br i1 %34, label %35, label %43, !dbg !1070

35:                                               ; preds = %27
  %36 = load %struct.trace_unit_s*, %struct.trace_unit_s** %6, align 8, !dbg !1071
  %37 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1073
  %38 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %37, i32 0, i32 0, !dbg !1074
  store %struct.trace_unit_s* %36, %struct.trace_unit_s** %38, align 8, !dbg !1075
  %39 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1076
  %40 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %39, i32 0, i32 2, !dbg !1077
  %41 = load i64, i64* %40, align 8, !dbg !1078
  %42 = mul i64 %41, 2, !dbg !1078
  store i64 %42, i64* %40, align 8, !dbg !1078
  br label %44, !dbg !1079

43:                                               ; preds = %27
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.24, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 89, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.trace_extend, i64 0, i64 0)) #5, !dbg !1080
  unreachable, !dbg !1080

44:                                               ; preds = %35
  %45 = load %struct.trace_unit_s*, %struct.trace_unit_s** %5, align 8, !dbg !1084
  %46 = bitcast %struct.trace_unit_s* %45 to i8*, !dbg !1084
  call void @free(i8* noundef %46) #6, !dbg !1085
  br label %48, !dbg !1086

47:                                               ; preds = %12
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.25, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 93, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.trace_extend, i64 0, i64 0)) #5, !dbg !1087
  unreachable, !dbg !1087

48:                                               ; preds = %44
  ret void, !dbg !1091
}

declare i32 @memcpy_s(...) #4

; Function Attrs: noinline nounwind uwtable
define internal i8* @vsimpleht_get(%struct.vsimpleht_s* noundef %0, i64 noundef %1) #0 !dbg !1092 {
  %3 = alloca i8*, align 8
  %4 = alloca %struct.vsimpleht_s*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %4, metadata !1095, metadata !DIExpression()), !dbg !1096
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1097, metadata !DIExpression()), !dbg !1098
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1099, metadata !DIExpression()), !dbg !1100
  store i64 0, i64* %6, align 8, !dbg !1100
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1101, metadata !DIExpression()), !dbg !1102
  store i64 0, i64* %7, align 8, !dbg !1102
  %8 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1103
  call void @_vsimpleht_give_cleanup_a_chance(%struct.vsimpleht_s* noundef %8), !dbg !1104
  %9 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1105
  %10 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %9, i32 0, i32 3, !dbg !1107
  %11 = load i64 (i64)*, i64 (i64)** %10, align 8, !dbg !1107
  %12 = load i64, i64* %5, align 8, !dbg !1108
  %13 = call i64 %11(i64 noundef %12), !dbg !1105
  store i64 %13, i64* %6, align 8, !dbg !1109
  br label %14, !dbg !1110

14:                                               ; preds = %59, %2
  %15 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1111
  %16 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %15, i32 0, i32 0, !dbg !1114
  %17 = load i64, i64* %16, align 8, !dbg !1114
  %18 = sub i64 %17, 1, !dbg !1115
  %19 = load i64, i64* %6, align 8, !dbg !1116
  %20 = and i64 %19, %18, !dbg !1116
  store i64 %20, i64* %6, align 8, !dbg !1116
  %21 = load i64, i64* %6, align 8, !dbg !1117
  %22 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1117
  %23 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %22, i32 0, i32 0, !dbg !1117
  %24 = load i64, i64* %23, align 8, !dbg !1117
  %25 = icmp ult i64 %21, %24, !dbg !1117
  br i1 %25, label %26, label %27, !dbg !1120

26:                                               ; preds = %14
  br label %28, !dbg !1120

27:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.17, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 264, i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @__PRETTY_FUNCTION__.vsimpleht_get, i64 0, i64 0)) #5, !dbg !1117
  unreachable, !dbg !1117

28:                                               ; preds = %26
  %29 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1121
  %30 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %29, i32 0, i32 1, !dbg !1122
  %31 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %30, align 8, !dbg !1122
  %32 = load i64, i64* %6, align 8, !dbg !1123
  %33 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %31, i64 %32, !dbg !1121
  %34 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %33, i32 0, i32 0, !dbg !1124
  %35 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %34), !dbg !1125
  %36 = ptrtoint i8* %35 to i64, !dbg !1126
  store i64 %36, i64* %7, align 8, !dbg !1127
  %37 = load i64, i64* %7, align 8, !dbg !1128
  %38 = icmp eq i64 %37, 0, !dbg !1130
  br i1 %38, label %39, label %40, !dbg !1131

39:                                               ; preds = %28
  store i8* null, i8** %3, align 8, !dbg !1132
  br label %62, !dbg !1132

40:                                               ; preds = %28
  %41 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1134
  %42 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %41, i32 0, i32 2, !dbg !1136
  %43 = load i8 (i64, i64)*, i8 (i64, i64)** %42, align 8, !dbg !1136
  %44 = load i64, i64* %5, align 8, !dbg !1137
  %45 = load i64, i64* %7, align 8, !dbg !1138
  %46 = call signext i8 %43(i64 noundef %44, i64 noundef %45), !dbg !1134
  %47 = sext i8 %46 to i32, !dbg !1134
  %48 = icmp eq i32 %47, 0, !dbg !1139
  br i1 %48, label %49, label %57, !dbg !1140

49:                                               ; preds = %40
  %50 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1141
  %51 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %50, i32 0, i32 1, !dbg !1143
  %52 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %51, align 8, !dbg !1143
  %53 = load i64, i64* %6, align 8, !dbg !1144
  %54 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %52, i64 %53, !dbg !1141
  %55 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %54, i32 0, i32 1, !dbg !1145
  %56 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %55), !dbg !1146
  store i8* %56, i8** %3, align 8, !dbg !1147
  br label %62, !dbg !1147

57:                                               ; preds = %40
  br label %58

58:                                               ; preds = %57
  br label %59, !dbg !1148

59:                                               ; preds = %58
  %60 = load i64, i64* %6, align 8, !dbg !1149
  %61 = add i64 %60, 1, !dbg !1149
  store i64 %61, i64* %6, align 8, !dbg !1149
  br label %14, !dbg !1150, !llvm.loop !1151

62:                                               ; preds = %49, %39
  %63 = load i8*, i8** %3, align 8, !dbg !1154
  ret i8* %63, !dbg !1154
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %0) #0 !dbg !1155 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !1156, metadata !DIExpression()), !dbg !1157
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1158, !srcloc !1159
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1160, metadata !DIExpression()), !dbg !1161
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !1162
  %6 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %5, i32 0, i32 0, !dbg !1163
  %7 = bitcast i8** %6 to i64*, !dbg !1164
  %8 = bitcast i8** %4 to i64*, !dbg !1164
  %9 = load atomic i64, i64* %7 acquire, align 8, !dbg !1164
  store i64 %9, i64* %8, align 8, !dbg !1164
  %10 = bitcast i64* %8 to i8**, !dbg !1164
  %11 = load i8*, i8** %10, align 8, !dbg !1164
  store i8* %11, i8** %3, align 8, !dbg !1161
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1165, !srcloc !1166
  %12 = load i8*, i8** %3, align 8, !dbg !1167
  ret i8* %12, !dbg !1168
}

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !1169 {
  %5 = alloca %struct.run_info_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8* (i8*)*, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !1172, metadata !DIExpression()), !dbg !1173
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1174, metadata !DIExpression()), !dbg !1175
  store i8* (i8*)* %2, i8* (i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %7, metadata !1176, metadata !DIExpression()), !dbg !1177
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !1178, metadata !DIExpression()), !dbg !1179
  call void @llvm.dbg.declare(metadata i64* %9, metadata !1180, metadata !DIExpression()), !dbg !1181
  store i64 0, i64* %9, align 8, !dbg !1181
  store i64 0, i64* %9, align 8, !dbg !1182
  br label %11, !dbg !1184

11:                                               ; preds = %42, %4
  %12 = load i64, i64* %9, align 8, !dbg !1185
  %13 = load i64, i64* %6, align 8, !dbg !1187
  %14 = icmp ult i64 %12, %13, !dbg !1188
  br i1 %14, label %15, label %45, !dbg !1189

15:                                               ; preds = %11
  %16 = load i64, i64* %9, align 8, !dbg !1190
  %17 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1192
  %18 = load i64, i64* %9, align 8, !dbg !1193
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %17, i64 %18, !dbg !1192
  %20 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %19, i32 0, i32 1, !dbg !1194
  store i64 %16, i64* %20, align 8, !dbg !1195
  %21 = load i8* (i8*)*, i8* (i8*)** %7, align 8, !dbg !1196
  %22 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1197
  %23 = load i64, i64* %9, align 8, !dbg !1198
  %24 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %22, i64 %23, !dbg !1197
  %25 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %24, i32 0, i32 3, !dbg !1199
  store i8* (i8*)* %21, i8* (i8*)** %25, align 8, !dbg !1200
  %26 = load i8, i8* %8, align 1, !dbg !1201
  %27 = trunc i8 %26 to i1, !dbg !1201
  %28 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1202
  %29 = load i64, i64* %9, align 8, !dbg !1203
  %30 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %28, i64 %29, !dbg !1202
  %31 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %30, i32 0, i32 2, !dbg !1204
  %32 = zext i1 %27 to i8, !dbg !1205
  store i8 %32, i8* %31, align 8, !dbg !1205
  %33 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1206
  %34 = load i64, i64* %9, align 8, !dbg !1207
  %35 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %33, i64 %34, !dbg !1206
  %36 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %35, i32 0, i32 0, !dbg !1208
  %37 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1209
  %38 = load i64, i64* %9, align 8, !dbg !1210
  %39 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %37, i64 %38, !dbg !1209
  %40 = bitcast %struct.run_info_t* %39 to i8*, !dbg !1211
  %41 = call i32 @pthread_create(i64* noundef %36, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %40) #6, !dbg !1212
  br label %42, !dbg !1213

42:                                               ; preds = %15
  %43 = load i64, i64* %9, align 8, !dbg !1214
  %44 = add i64 %43, 1, !dbg !1214
  store i64 %44, i64* %9, align 8, !dbg !1214
  br label %11, !dbg !1215, !llvm.loop !1216

45:                                               ; preds = %11
  ret void, !dbg !1218
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !1219 {
  %3 = alloca %struct.run_info_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !1222, metadata !DIExpression()), !dbg !1223
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1224, metadata !DIExpression()), !dbg !1225
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1226, metadata !DIExpression()), !dbg !1227
  store i64 0, i64* %5, align 8, !dbg !1227
  store i64 0, i64* %5, align 8, !dbg !1228
  br label %6, !dbg !1230

6:                                                ; preds = %17, %2
  %7 = load i64, i64* %5, align 8, !dbg !1231
  %8 = load i64, i64* %4, align 8, !dbg !1233
  %9 = icmp ult i64 %7, %8, !dbg !1234
  br i1 %9, label %10, label %20, !dbg !1235

10:                                               ; preds = %6
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1236
  %12 = load i64, i64* %5, align 8, !dbg !1238
  %13 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i64 %12, !dbg !1236
  %14 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %13, i32 0, i32 0, !dbg !1239
  %15 = load i64, i64* %14, align 8, !dbg !1239
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !1240
  br label %17, !dbg !1241

17:                                               ; preds = %10
  %18 = load i64, i64* %5, align 8, !dbg !1242
  %19 = add i64 %18, 1, !dbg !1242
  store i64 %19, i64* %5, align 8, !dbg !1242
  br label %6, !dbg !1243, !llvm.loop !1244

20:                                               ; preds = %6
  ret void, !dbg !1246
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !1247 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.run_info_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !1248, metadata !DIExpression()), !dbg !1249
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !1250, metadata !DIExpression()), !dbg !1251
  %4 = load i8*, i8** %2, align 8, !dbg !1252
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !1253
  store %struct.run_info_t* %5, %struct.run_info_t** %3, align 8, !dbg !1251
  %6 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1254
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %6, i32 0, i32 2, !dbg !1256
  %8 = load i8, i8* %7, align 8, !dbg !1256
  %9 = trunc i8 %8 to i1, !dbg !1256
  br i1 %9, label %10, label %14, !dbg !1257

10:                                               ; preds = %1
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1258
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i32 0, i32 1, !dbg !1259
  %13 = load i64, i64* %12, align 8, !dbg !1259
  call void @set_cpu_affinity(i64 noundef %13), !dbg !1260
  br label %14, !dbg !1260

14:                                               ; preds = %10, %1
  %15 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1261
  %16 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %15, i32 0, i32 3, !dbg !1262
  %17 = load i8* (i8*)*, i8* (i8*)** %16, align 8, !dbg !1262
  %18 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1263
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %18, i32 0, i32 1, !dbg !1264
  %20 = load i64, i64* %19, align 8, !dbg !1264
  %21 = inttoptr i64 %20 to i8*, !dbg !1265
  %22 = call i8* %17(i8* noundef %21), !dbg !1261
  ret i8* %22, !dbg !1266
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !1267 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1268, metadata !DIExpression()), !dbg !1269
  br label %3, !dbg !1270

3:                                                ; preds = %1
  br label %4, !dbg !1271

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1273
  br label %6, !dbg !1273

6:                                                ; preds = %4
  br label %7, !dbg !1275

7:                                                ; preds = %6
  br label %8, !dbg !1273

8:                                                ; preds = %7
  br label %9, !dbg !1271

9:                                                ; preds = %8
  ret void, !dbg !1277
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_thread_register(%struct.vsimpleht_s* noundef %0) #0 !dbg !1278 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !1279, metadata !DIExpression()), !dbg !1280
  %3 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1281
  %4 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %3, i32 0, i32 7, !dbg !1282
  call void @rwlock_read_acquire(%struct.rwlock_s* noundef %4), !dbg !1283
  ret void, !dbg !1284
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_thread_deregister(%struct.vsimpleht_s* noundef %0) #0 !dbg !1285 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !1286, metadata !DIExpression()), !dbg !1287
  %3 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1288
  %4 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %3, i32 0, i32 7, !dbg !1289
  call void @rwlock_read_release(%struct.rwlock_s* noundef %4), !dbg !1290
  ret void, !dbg !1291
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vsimpleht_buff_size(i64 noundef %0) #0 !dbg !1292 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1295, metadata !DIExpression()), !dbg !1296
  %3 = load i64, i64* %2, align 8, !dbg !1297
  %4 = icmp ugt i64 %3, 0, !dbg !1297
  br i1 %4, label %5, label %6, !dbg !1300

5:                                                ; preds = %1
  br label %7, !dbg !1300

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.28, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 128, i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @__PRETTY_FUNCTION__.vsimpleht_buff_size, i64 0, i64 0)) #5, !dbg !1297
  unreachable, !dbg !1297

7:                                                ; preds = %5
  %8 = load i64, i64* %2, align 8, !dbg !1301
  %9 = load i64, i64* %2, align 8, !dbg !1301
  %10 = sub i64 %9, 1, !dbg !1301
  %11 = and i64 %8, %10, !dbg !1301
  %12 = icmp eq i64 %11, 0, !dbg !1301
  br i1 %12, label %13, label %15, !dbg !1301

13:                                               ; preds = %7
  br i1 true, label %14, label %15, !dbg !1304

14:                                               ; preds = %13
  br label %16, !dbg !1304

15:                                               ; preds = %13, %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @.str.30, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 129, i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @__PRETTY_FUNCTION__.vsimpleht_buff_size, i64 0, i64 0)) #5, !dbg !1301
  unreachable, !dbg !1301

16:                                               ; preds = %14
  %17 = load i64, i64* %2, align 8, !dbg !1305
  %18 = mul i64 16, %17, !dbg !1306
  ret i64 %18, !dbg !1307
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_init(%struct.vsimpleht_s* noundef %0, i8* noundef %1, i64 noundef %2, i8 (i64, i64)* noundef %3, i64 (i64)* noundef %4, void (i8*)* noundef %5) #0 !dbg !1308 {
  %7 = alloca %struct.vsimpleht_s*, align 8
  %8 = alloca i8*, align 8
  %9 = alloca i64, align 8
  %10 = alloca i8 (i64, i64)*, align 8
  %11 = alloca i64 (i64)*, align 8
  %12 = alloca void (i8*)*, align 8
  %13 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %7, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %7, metadata !1311, metadata !DIExpression()), !dbg !1312
  store i8* %1, i8** %8, align 8
  call void @llvm.dbg.declare(metadata i8** %8, metadata !1313, metadata !DIExpression()), !dbg !1314
  store i64 %2, i64* %9, align 8
  call void @llvm.dbg.declare(metadata i64* %9, metadata !1315, metadata !DIExpression()), !dbg !1316
  store i8 (i64, i64)* %3, i8 (i64, i64)** %10, align 8
  call void @llvm.dbg.declare(metadata i8 (i64, i64)** %10, metadata !1317, metadata !DIExpression()), !dbg !1318
  store i64 (i64)* %4, i64 (i64)** %11, align 8
  call void @llvm.dbg.declare(metadata i64 (i64)** %11, metadata !1319, metadata !DIExpression()), !dbg !1320
  store void (i8*)* %5, void (i8*)** %12, align 8
  call void @llvm.dbg.declare(metadata void (i8*)** %12, metadata !1321, metadata !DIExpression()), !dbg !1322
  %14 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1323
  %15 = icmp ne %struct.vsimpleht_s* %14, null, !dbg !1323
  br i1 %15, label %16, label %17, !dbg !1326

16:                                               ; preds = %6
  br label %18, !dbg !1326

17:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.31, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 150, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1323
  unreachable, !dbg !1323

18:                                               ; preds = %16
  %19 = load i8*, i8** %8, align 8, !dbg !1327
  %20 = icmp ne i8* %19, null, !dbg !1327
  br i1 %20, label %21, label %22, !dbg !1330

21:                                               ; preds = %18
  br label %23, !dbg !1330

22:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.32, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 151, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1327
  unreachable, !dbg !1327

23:                                               ; preds = %21
  %24 = load i64, i64* %9, align 8, !dbg !1331
  %25 = icmp ugt i64 %24, 0, !dbg !1331
  br i1 %25, label %26, label %27, !dbg !1334

26:                                               ; preds = %23
  br label %28, !dbg !1334

27:                                               ; preds = %23
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.28, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 152, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1331
  unreachable, !dbg !1331

28:                                               ; preds = %26
  %29 = load i64, i64* %9, align 8, !dbg !1335
  %30 = load i64, i64* %9, align 8, !dbg !1335
  %31 = sub i64 %30, 1, !dbg !1335
  %32 = and i64 %29, %31, !dbg !1335
  %33 = icmp eq i64 %32, 0, !dbg !1335
  br i1 %33, label %34, label %36, !dbg !1335

34:                                               ; preds = %28
  br i1 true, label %35, label %36, !dbg !1338

35:                                               ; preds = %34
  br label %37, !dbg !1338

36:                                               ; preds = %34, %28
  call void @__assert_fail(i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.34, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 153, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1335
  unreachable, !dbg !1335

37:                                               ; preds = %35
  %38 = load i64, i64* %9, align 8, !dbg !1339
  %39 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1340
  %40 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %39, i32 0, i32 0, !dbg !1341
  store i64 %38, i64* %40, align 8, !dbg !1342
  %41 = load i8*, i8** %8, align 8, !dbg !1343
  %42 = bitcast i8* %41 to %struct.vsimpleht_entry_s*, !dbg !1343
  %43 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1344
  %44 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %43, i32 0, i32 1, !dbg !1345
  store %struct.vsimpleht_entry_s* %42, %struct.vsimpleht_entry_s** %44, align 8, !dbg !1346
  %45 = load i8 (i64, i64)*, i8 (i64, i64)** %10, align 8, !dbg !1347
  %46 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1348
  %47 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %46, i32 0, i32 2, !dbg !1349
  store i8 (i64, i64)* %45, i8 (i64, i64)** %47, align 8, !dbg !1350
  %48 = load i64 (i64)*, i64 (i64)** %11, align 8, !dbg !1351
  %49 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1352
  %50 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %49, i32 0, i32 3, !dbg !1353
  store i64 (i64)* %48, i64 (i64)** %50, align 8, !dbg !1354
  %51 = load void (i8*)*, void (i8*)** %12, align 8, !dbg !1355
  %52 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1356
  %53 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %52, i32 0, i32 4, !dbg !1357
  store void (i8*)* %51, void (i8*)** %53, align 8, !dbg !1358
  call void @llvm.dbg.declare(metadata i64* %13, metadata !1359, metadata !DIExpression()), !dbg !1361
  store i64 0, i64* %13, align 8, !dbg !1361
  br label %54, !dbg !1362

54:                                               ; preds = %73, %37
  %55 = load i64, i64* %13, align 8, !dbg !1363
  %56 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1365
  %57 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %56, i32 0, i32 0, !dbg !1366
  %58 = load i64, i64* %57, align 8, !dbg !1366
  %59 = icmp ult i64 %55, %58, !dbg !1367
  br i1 %59, label %60, label %76, !dbg !1368

60:                                               ; preds = %54
  %61 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1369
  %62 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %61, i32 0, i32 1, !dbg !1371
  %63 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %62, align 8, !dbg !1371
  %64 = load i64, i64* %13, align 8, !dbg !1372
  %65 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %63, i64 %64, !dbg !1369
  %66 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %65, i32 0, i32 0, !dbg !1373
  call void @vatomicptr_init(%struct.vatomicptr_s* noundef %66, i8* noundef null), !dbg !1374
  %67 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1375
  %68 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %67, i32 0, i32 1, !dbg !1376
  %69 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %68, align 8, !dbg !1376
  %70 = load i64, i64* %13, align 8, !dbg !1377
  %71 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %69, i64 %70, !dbg !1375
  %72 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %71, i32 0, i32 1, !dbg !1378
  call void @vatomicptr_init(%struct.vatomicptr_s* noundef %72, i8* noundef null), !dbg !1379
  br label %73, !dbg !1380

73:                                               ; preds = %60
  %74 = load i64, i64* %13, align 8, !dbg !1381
  %75 = add i64 %74, 1, !dbg !1381
  store i64 %75, i64* %13, align 8, !dbg !1381
  br label %54, !dbg !1382, !llvm.loop !1383

76:                                               ; preds = %54
  %77 = load i64, i64* %9, align 8, !dbg !1385
  %78 = udiv i64 %77, 4, !dbg !1386
  %79 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1387
  %80 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %79, i32 0, i32 5, !dbg !1388
  store i64 %78, i64* %80, align 8, !dbg !1389
  %81 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1390
  %82 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %81, i32 0, i32 6, !dbg !1391
  call void @vatomicsz_write_rlx(%struct.vatomicsz_s* noundef %82, i64 noundef 0), !dbg !1392
  %83 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1393
  %84 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %83, i32 0, i32 7, !dbg !1394
  call void @rwlock_init(%struct.rwlock_s* noundef %84), !dbg !1395
  ret void, !dbg !1396
}

; Function Attrs: noinline nounwind uwtable
define internal signext i8 @cb_cmp(i64 noundef %0, i64 noundef %1) #0 !dbg !1397 {
  %3 = alloca i8, align 1
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i64 %0, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1398, metadata !DIExpression()), !dbg !1399
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1400, metadata !DIExpression()), !dbg !1401
  %6 = load i64, i64* %4, align 8, !dbg !1402
  %7 = load i64, i64* %5, align 8, !dbg !1404
  %8 = icmp eq i64 %6, %7, !dbg !1405
  br i1 %8, label %9, label %10, !dbg !1406

9:                                                ; preds = %2
  store i8 0, i8* %3, align 1, !dbg !1407
  br label %16, !dbg !1407

10:                                               ; preds = %2
  %11 = load i64, i64* %4, align 8, !dbg !1409
  %12 = load i64, i64* %5, align 8, !dbg !1411
  %13 = icmp ult i64 %11, %12, !dbg !1412
  br i1 %13, label %14, label %15, !dbg !1413

14:                                               ; preds = %10
  store i8 -1, i8* %3, align 1, !dbg !1414
  br label %16, !dbg !1414

15:                                               ; preds = %10
  store i8 1, i8* %3, align 1, !dbg !1416
  br label %16, !dbg !1416

16:                                               ; preds = %15, %14, %9
  %17 = load i8, i8* %3, align 1, !dbg !1418
  ret i8 %17, !dbg !1418
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @cb_hash(i64 noundef %0) #0 !dbg !1419 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1420, metadata !DIExpression()), !dbg !1421
  %3 = load i64, i64* %2, align 8, !dbg !1422
  ret i64 %3, !dbg !1423
}

; Function Attrs: noinline nounwind uwtable
define internal void @cb_destroy(i8* noundef %0) #0 !dbg !1424 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !1425, metadata !DIExpression()), !dbg !1426
  %3 = load i8*, i8** %2, align 8, !dbg !1427
  call void @free(i8* noundef %3) #6, !dbg !1428
  ret void, !dbg !1429
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_init(%struct.trace_s* noundef %0, i64 noundef %1) #0 !dbg !1430 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !1433, metadata !DIExpression()), !dbg !1434
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1435, metadata !DIExpression()), !dbg !1436
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1437
  %6 = icmp ne %struct.trace_s* %5, null, !dbg !1437
  br i1 %6, label %7, label %8, !dbg !1440

7:                                                ; preds = %2
  br label %9, !dbg !1440

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 36, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !1437
  unreachable, !dbg !1437

9:                                                ; preds = %7
  %10 = load i64, i64* %4, align 8, !dbg !1441
  %11 = mul i64 %10, 16, !dbg !1442
  %12 = call noalias i8* @malloc(i64 noundef %11) #6, !dbg !1443
  %13 = bitcast i8* %12 to %struct.trace_unit_s*, !dbg !1443
  %14 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1444
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 0, !dbg !1445
  store %struct.trace_unit_s* %13, %struct.trace_unit_s** %15, align 8, !dbg !1446
  %16 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1447
  %17 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %16, i32 0, i32 0, !dbg !1449
  %18 = load %struct.trace_unit_s*, %struct.trace_unit_s** %17, align 8, !dbg !1449
  %19 = icmp ne %struct.trace_unit_s* %18, null, !dbg !1447
  br i1 %19, label %20, label %28, !dbg !1450

20:                                               ; preds = %9
  %21 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1451
  %22 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %21, i32 0, i32 1, !dbg !1453
  store i64 0, i64* %22, align 8, !dbg !1454
  %23 = load i64, i64* %4, align 8, !dbg !1455
  %24 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1456
  %25 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %24, i32 0, i32 2, !dbg !1457
  store i64 %23, i64* %25, align 8, !dbg !1458
  %26 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1459
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 3, !dbg !1460
  store i8 1, i8* %27, align 8, !dbg !1461
  br label %35, !dbg !1462

28:                                               ; preds = %9
  %29 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1463
  %30 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %29, i32 0, i32 1, !dbg !1465
  store i64 0, i64* %30, align 8, !dbg !1466
  %31 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1467
  %32 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %31, i32 0, i32 2, !dbg !1468
  store i64 0, i64* %32, align 8, !dbg !1469
  %33 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1470
  %34 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %33, i32 0, i32 3, !dbg !1471
  store i8 0, i8* %34, align 8, !dbg !1472
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.25, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 46, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !1473
  unreachable, !dbg !1473

35:                                               ; preds = %20
  ret void, !dbg !1476
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_init(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1477 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1480, metadata !DIExpression()), !dbg !1481
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1482, metadata !DIExpression()), !dbg !1483
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !1484
  %6 = load i8*, i8** %4, align 8, !dbg !1485
  call void @vatomicptr_write(%struct.vatomicptr_s* noundef %5, i8* noundef %6), !dbg !1486
  ret void, !dbg !1487
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicsz_write_rlx(%struct.vatomicsz_s* noundef %0, i64 noundef %1) #0 !dbg !1488 {
  %3 = alloca %struct.vatomicsz_s*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.vatomicsz_s* %0, %struct.vatomicsz_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicsz_s** %3, metadata !1492, metadata !DIExpression()), !dbg !1493
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1494, metadata !DIExpression()), !dbg !1495
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1496, !srcloc !1497
  %6 = load %struct.vatomicsz_s*, %struct.vatomicsz_s** %3, align 8, !dbg !1498
  %7 = getelementptr inbounds %struct.vatomicsz_s, %struct.vatomicsz_s* %6, i32 0, i32 0, !dbg !1499
  %8 = load i64, i64* %4, align 8, !dbg !1500
  store i64 %8, i64* %5, align 8, !dbg !1501
  %9 = load i64, i64* %5, align 8, !dbg !1501
  store atomic i64 %9, i64* %7 monotonic, align 8, !dbg !1501
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1502, !srcloc !1503
  ret void, !dbg !1504
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_init(%struct.rwlock_s* noundef %0) #0 !dbg !1505 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i64, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !1506, metadata !DIExpression()), !dbg !1507
  call void @llvm.dbg.declare(metadata i64* %3, metadata !1508, metadata !DIExpression()), !dbg !1510
  store i64 0, i64* %3, align 8, !dbg !1510
  br label %4, !dbg !1511

4:                                                ; preds = %13, %1
  %5 = load i64, i64* %3, align 8, !dbg !1512
  %6 = icmp ult i64 %5, 3, !dbg !1514
  br i1 %6, label %7, label %16, !dbg !1515

7:                                                ; preds = %4
  %8 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !1516
  %9 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %8, i32 0, i32 0, !dbg !1518
  %10 = load i64, i64* %3, align 8, !dbg !1519
  %11 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %9, i64 0, i64 %10, !dbg !1516
  %12 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %11, %union.pthread_mutexattr_t* noundef null) #6, !dbg !1520
  br label %13, !dbg !1521

13:                                               ; preds = %7
  %14 = load i64, i64* %3, align 8, !dbg !1522
  %15 = add i64 %14, 1, !dbg !1522
  store i64 %15, i64* %3, align 8, !dbg !1522
  br label %4, !dbg !1523, !llvm.loop !1524

16:                                               ; preds = %4
  ret void, !dbg !1526
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1527 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1528, metadata !DIExpression()), !dbg !1529
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1530, metadata !DIExpression()), !dbg !1531
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1532, !srcloc !1533
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !1534
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !1535
  %8 = load i8*, i8** %4, align 8, !dbg !1536
  store i8* %8, i8** %5, align 8, !dbg !1537
  %9 = bitcast i8** %7 to i64*, !dbg !1537
  %10 = bitcast i8** %5 to i64*, !dbg !1537
  %11 = load i64, i64* %10, align 8, !dbg !1537
  store atomic i64 %11, i64* %9 seq_cst, align 8, !dbg !1537
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1538, !srcloc !1539
  ret void, !dbg !1540
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @_imap_verify() #0 !dbg !1541 {
  %1 = alloca i64, align 8
  %2 = alloca %struct.data_s*, align 8
  %3 = alloca %struct.vsimpleht_iter_s, align 8
  %4 = alloca %struct.trace_s, align 8
  %5 = alloca %struct.trace_s, align 8
  %6 = alloca %struct.trace_s, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata i64* %1, metadata !1542, metadata !DIExpression()), !dbg !1543
  store i64 0, i64* %1, align 8, !dbg !1543
  call void @llvm.dbg.declare(metadata %struct.data_s** %2, metadata !1544, metadata !DIExpression()), !dbg !1545
  store %struct.data_s* null, %struct.data_s** %2, align 8, !dbg !1545
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_iter_s* %3, metadata !1546, metadata !DIExpression()), !dbg !1552
  call void @llvm.dbg.declare(metadata %struct.trace_s* %4, metadata !1553, metadata !DIExpression()), !dbg !1554
  call void @llvm.dbg.declare(metadata %struct.trace_s* %5, metadata !1555, metadata !DIExpression()), !dbg !1556
  call void @llvm.dbg.declare(metadata %struct.trace_s* %6, metadata !1557, metadata !DIExpression()), !dbg !1558
  call void @trace_init(%struct.trace_s* noundef %4, i64 noundef 8), !dbg !1559
  call void @trace_init(%struct.trace_s* noundef %5, i64 noundef 8), !dbg !1560
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1561, metadata !DIExpression()), !dbg !1563
  store i64 0, i64* %7, align 8, !dbg !1563
  br label %9, !dbg !1564

9:                                                ; preds = %17, %0
  %10 = load i64, i64* %7, align 8, !dbg !1565
  %11 = icmp ult i64 %10, 4, !dbg !1567
  br i1 %11, label %12, label %20, !dbg !1568

12:                                               ; preds = %9
  %13 = load i64, i64* %7, align 8, !dbg !1569
  %14 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %13, !dbg !1571
  call void @trace_merge_into(%struct.trace_s* noundef %4, %struct.trace_s* noundef %14), !dbg !1572
  %15 = load i64, i64* %7, align 8, !dbg !1573
  %16 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_rem, i64 0, i64 %15, !dbg !1574
  call void @trace_merge_into(%struct.trace_s* noundef %5, %struct.trace_s* noundef %16), !dbg !1575
  br label %17, !dbg !1576

17:                                               ; preds = %12
  %18 = load i64, i64* %7, align 8, !dbg !1577
  %19 = add i64 %18, 1, !dbg !1577
  store i64 %19, i64* %7, align 8, !dbg !1577
  br label %9, !dbg !1578, !llvm.loop !1579

20:                                               ; preds = %9
  call void @trace_init(%struct.trace_s* noundef %6, i64 noundef 8), !dbg !1581
  call void @vsimpleht_iter_init(%struct.vsimpleht_s* noundef @g_simpleht, %struct.vsimpleht_iter_s* noundef %3), !dbg !1582
  br label %21, !dbg !1583

21:                                               ; preds = %24, %20
  %22 = bitcast %struct.data_s** %2 to i8**, !dbg !1584
  %23 = call zeroext i1 @vsimpleht_iter_next(%struct.vsimpleht_iter_s* noundef %3, i64* noundef %1, i8** noundef %22), !dbg !1585
  br i1 %23, label %24, label %26, !dbg !1583

24:                                               ; preds = %21
  %25 = load i64, i64* %1, align 8, !dbg !1586
  call void @trace_add(%struct.trace_s* noundef %6, i64 noundef %25), !dbg !1588
  br label %21, !dbg !1583, !llvm.loop !1589

26:                                               ; preds = %21
  call void @trace_subtract_from(%struct.trace_s* noundef %4, %struct.trace_s* noundef %5), !dbg !1591
  call void @llvm.dbg.declare(metadata i8* %8, metadata !1592, metadata !DIExpression()), !dbg !1593
  %27 = call zeroext i1 @trace_is_subtrace(%struct.trace_s* noundef %4, %struct.trace_s* noundef %6, void (i64)* noundef null), !dbg !1594
  %28 = zext i1 %27 to i8, !dbg !1593
  store i8 %28, i8* %8, align 1, !dbg !1593
  call void @trace_destroy(%struct.trace_s* noundef %4), !dbg !1595
  call void @trace_destroy(%struct.trace_s* noundef %5), !dbg !1596
  call void @trace_destroy(%struct.trace_s* noundef %6), !dbg !1597
  %29 = load i8, i8* %8, align 1, !dbg !1598
  %30 = trunc i8 %29 to i1, !dbg !1598
  br i1 %30, label %31, label %33, !dbg !1598

31:                                               ; preds = %26
  br i1 true, label %32, label %33, !dbg !1601

32:                                               ; preds = %31
  br label %34, !dbg !1601

33:                                               ; preds = %31, %26
  call void @__assert_fail(i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.36, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.27, i64 0, i64 0), i32 noundef 109, i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @__PRETTY_FUNCTION__._imap_verify, i64 0, i64 0)) #5, !dbg !1598
  unreachable, !dbg !1598

34:                                               ; preds = %32
  ret void, !dbg !1602
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_destroy(%struct.trace_s* noundef %0) #0 !dbg !1603 {
  %2 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %2, metadata !1604, metadata !DIExpression()), !dbg !1605
  %3 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1606
  %4 = icmp ne %struct.trace_s* %3, null, !dbg !1606
  br i1 %4, label %5, label %6, !dbg !1609

5:                                                ; preds = %1
  br label %7, !dbg !1609

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !1606
  unreachable, !dbg !1606

7:                                                ; preds = %5
  %8 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1610
  %9 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %8, i32 0, i32 3, !dbg !1610
  %10 = load i8, i8* %9, align 8, !dbg !1610
  %11 = trunc i8 %10 to i1, !dbg !1610
  br i1 %11, label %12, label %13, !dbg !1613

12:                                               ; preds = %7
  br label %14, !dbg !1613

13:                                               ; preds = %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 101, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !1610
  unreachable, !dbg !1610

14:                                               ; preds = %12
  %15 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1614
  %16 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %15, i32 0, i32 0, !dbg !1615
  %17 = load %struct.trace_unit_s*, %struct.trace_unit_s** %16, align 8, !dbg !1615
  %18 = bitcast %struct.trace_unit_s* %17 to i8*, !dbg !1614
  call void @free(i8* noundef %18) #6, !dbg !1616
  %19 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1617
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 3, !dbg !1618
  store i8 0, i8* %20, align 8, !dbg !1619
  ret void, !dbg !1620
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_destroy(%struct.vsimpleht_s* noundef %0) #0 !dbg !1621 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  %3 = alloca %struct.vsimpleht_entry_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !1622, metadata !DIExpression()), !dbg !1623
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_entry_s** %3, metadata !1624, metadata !DIExpression()), !dbg !1625
  store %struct.vsimpleht_entry_s* null, %struct.vsimpleht_entry_s** %3, align 8, !dbg !1625
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1626, metadata !DIExpression()), !dbg !1627
  store i8* null, i8** %4, align 8, !dbg !1627
  %6 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1628
  %7 = icmp ne %struct.vsimpleht_s* %6, null, !dbg !1628
  br i1 %7, label %8, label %9, !dbg !1631

8:                                                ; preds = %1
  br label %10, !dbg !1631

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.31, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 182, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__.vsimpleht_destroy, i64 0, i64 0)) #5, !dbg !1628
  unreachable, !dbg !1628

10:                                               ; preds = %8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1632, metadata !DIExpression()), !dbg !1634
  store i64 0, i64* %5, align 8, !dbg !1634
  br label %11, !dbg !1635

11:                                               ; preds = %34, %10
  %12 = load i64, i64* %5, align 8, !dbg !1636
  %13 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1638
  %14 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %13, i32 0, i32 0, !dbg !1639
  %15 = load i64, i64* %14, align 8, !dbg !1639
  %16 = icmp ult i64 %12, %15, !dbg !1640
  br i1 %16, label %17, label %37, !dbg !1641

17:                                               ; preds = %11
  %18 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1642
  %19 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %18, i32 0, i32 1, !dbg !1644
  %20 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %19, align 8, !dbg !1644
  %21 = load i64, i64* %5, align 8, !dbg !1645
  %22 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %20, i64 %21, !dbg !1642
  store %struct.vsimpleht_entry_s* %22, %struct.vsimpleht_entry_s** %3, align 8, !dbg !1646
  %23 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %3, align 8, !dbg !1647
  %24 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %23, i32 0, i32 1, !dbg !1648
  %25 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %24), !dbg !1649
  store i8* %25, i8** %4, align 8, !dbg !1650
  %26 = load i8*, i8** %4, align 8, !dbg !1651
  %27 = icmp ne i8* %26, null, !dbg !1651
  br i1 %27, label %28, label %33, !dbg !1653

28:                                               ; preds = %17
  %29 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1654
  %30 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %29, i32 0, i32 4, !dbg !1656
  %31 = load void (i8*)*, void (i8*)** %30, align 8, !dbg !1656
  %32 = load i8*, i8** %4, align 8, !dbg !1657
  call void %31(i8* noundef %32), !dbg !1654
  br label %33, !dbg !1658

33:                                               ; preds = %28, %17
  br label %34, !dbg !1659

34:                                               ; preds = %33
  %35 = load i64, i64* %5, align 8, !dbg !1660
  %36 = add i64 %35, 1, !dbg !1660
  store i64 %36, i64* %5, align 8, !dbg !1660
  br label %11, !dbg !1661, !llvm.loop !1662

37:                                               ; preds = %11
  ret void, !dbg !1664
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_merge_into(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1) #0 !dbg !1665 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !1668, metadata !DIExpression()), !dbg !1669
  store %struct.trace_s* %1, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !1670, metadata !DIExpression()), !dbg !1671
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1672
  %6 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1673
  call void @_trace_merge_or_subtract(%struct.trace_s* noundef %5, %struct.trace_s* noundef %6, i1 noundef zeroext false), !dbg !1674
  ret void, !dbg !1675
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_iter_init(%struct.vsimpleht_s* noundef %0, %struct.vsimpleht_iter_s* noundef %1) #0 !dbg !1676 {
  %3 = alloca %struct.vsimpleht_s*, align 8
  %4 = alloca %struct.vsimpleht_iter_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %3, metadata !1680, metadata !DIExpression()), !dbg !1681
  store %struct.vsimpleht_iter_s* %1, %struct.vsimpleht_iter_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_iter_s** %4, metadata !1682, metadata !DIExpression()), !dbg !1683
  %5 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1684
  %6 = icmp ne %struct.vsimpleht_s* %5, null, !dbg !1684
  br i1 %6, label %7, label %8, !dbg !1687

7:                                                ; preds = %2
  br label %9, !dbg !1687

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.31, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 282, i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_init, i64 0, i64 0)) #5, !dbg !1684
  unreachable, !dbg !1684

9:                                                ; preds = %7
  %10 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %4, align 8, !dbg !1688
  %11 = icmp ne %struct.vsimpleht_iter_s* %10, null, !dbg !1688
  br i1 %11, label %12, label %13, !dbg !1691

12:                                               ; preds = %9
  br label %14, !dbg !1691

13:                                               ; preds = %9
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.39, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 283, i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_init, i64 0, i64 0)) #5, !dbg !1688
  unreachable, !dbg !1688

14:                                               ; preds = %12
  %15 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1692
  %16 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %4, align 8, !dbg !1693
  %17 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %16, i32 0, i32 0, !dbg !1694
  store %struct.vsimpleht_s* %15, %struct.vsimpleht_s** %17, align 8, !dbg !1695
  %18 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %4, align 8, !dbg !1696
  %19 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %18, i32 0, i32 1, !dbg !1697
  store i64 0, i64* %19, align 8, !dbg !1698
  ret void, !dbg !1699
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @vsimpleht_iter_next(%struct.vsimpleht_iter_s* noundef %0, i64* noundef %1, i8** noundef %2) #0 !dbg !1700 {
  %4 = alloca i1, align 1
  %5 = alloca %struct.vsimpleht_iter_s*, align 8
  %6 = alloca i64*, align 8
  %7 = alloca i8**, align 8
  %8 = alloca i64, align 8
  %9 = alloca i8*, align 8
  %10 = alloca %struct.vsimpleht_entry_s*, align 8
  %11 = alloca i64, align 8
  store %struct.vsimpleht_iter_s* %0, %struct.vsimpleht_iter_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_iter_s** %5, metadata !1704, metadata !DIExpression()), !dbg !1705
  store i64* %1, i64** %6, align 8
  call void @llvm.dbg.declare(metadata i64** %6, metadata !1706, metadata !DIExpression()), !dbg !1707
  store i8** %2, i8*** %7, align 8
  call void @llvm.dbg.declare(metadata i8*** %7, metadata !1708, metadata !DIExpression()), !dbg !1709
  call void @llvm.dbg.declare(metadata i64* %8, metadata !1710, metadata !DIExpression()), !dbg !1711
  store i64 0, i64* %8, align 8, !dbg !1711
  call void @llvm.dbg.declare(metadata i8** %9, metadata !1712, metadata !DIExpression()), !dbg !1713
  store i8* null, i8** %9, align 8, !dbg !1713
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_entry_s** %10, metadata !1714, metadata !DIExpression()), !dbg !1715
  store %struct.vsimpleht_entry_s* null, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1715
  %12 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !1716
  %13 = icmp ne %struct.vsimpleht_iter_s* %12, null, !dbg !1716
  br i1 %13, label %14, label %15, !dbg !1719

14:                                               ; preds = %3
  br label %16, !dbg !1719

15:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.39, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 322, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !1716
  unreachable, !dbg !1716

16:                                               ; preds = %14
  %17 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !1720
  %18 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %17, i32 0, i32 0, !dbg !1720
  %19 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %18, align 8, !dbg !1720
  %20 = icmp ne %struct.vsimpleht_s* %19, null, !dbg !1720
  br i1 %20, label %21, label %22, !dbg !1723

21:                                               ; preds = %16
  br label %23, !dbg !1723

22:                                               ; preds = %16
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.40, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 323, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !1720
  unreachable, !dbg !1720

23:                                               ; preds = %21
  %24 = load i64*, i64** %6, align 8, !dbg !1724
  %25 = icmp ne i64* %24, null, !dbg !1724
  br i1 %25, label %26, label %27, !dbg !1727

26:                                               ; preds = %23
  br label %28, !dbg !1727

27:                                               ; preds = %23
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.41, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 324, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !1724
  unreachable, !dbg !1724

28:                                               ; preds = %26
  %29 = load i8**, i8*** %7, align 8, !dbg !1728
  %30 = icmp ne i8** %29, null, !dbg !1728
  br i1 %30, label %31, label %32, !dbg !1731

31:                                               ; preds = %28
  br label %33, !dbg !1731

32:                                               ; preds = %28
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.42, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 325, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !1728
  unreachable, !dbg !1728

33:                                               ; preds = %31
  %34 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !1732
  %35 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %34, i32 0, i32 0, !dbg !1733
  %36 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %35, align 8, !dbg !1733
  %37 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %36, i32 0, i32 1, !dbg !1734
  %38 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %37, align 8, !dbg !1734
  store %struct.vsimpleht_entry_s* %38, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1735
  %39 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1736
  %40 = icmp ne %struct.vsimpleht_entry_s* %39, null, !dbg !1736
  br i1 %40, label %41, label %42, !dbg !1739

41:                                               ; preds = %33
  br label %43, !dbg !1739

42:                                               ; preds = %33
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.43, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 327, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !1736
  unreachable, !dbg !1736

43:                                               ; preds = %41
  call void @llvm.dbg.declare(metadata i64* %11, metadata !1740, metadata !DIExpression()), !dbg !1742
  %44 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !1743
  %45 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %44, i32 0, i32 1, !dbg !1744
  %46 = load i64, i64* %45, align 8, !dbg !1744
  store i64 %46, i64* %11, align 8, !dbg !1742
  br label %47, !dbg !1745

47:                                               ; preds = %82, %43
  %48 = load i64, i64* %11, align 8, !dbg !1746
  %49 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !1748
  %50 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %49, i32 0, i32 0, !dbg !1749
  %51 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %50, align 8, !dbg !1749
  %52 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %51, i32 0, i32 0, !dbg !1750
  %53 = load i64, i64* %52, align 8, !dbg !1750
  %54 = icmp ult i64 %48, %53, !dbg !1751
  br i1 %54, label %55, label %85, !dbg !1752

55:                                               ; preds = %47
  %56 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1753
  %57 = load i64, i64* %11, align 8, !dbg !1755
  %58 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %56, i64 %57, !dbg !1753
  %59 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %58, i32 0, i32 0, !dbg !1756
  %60 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %59), !dbg !1757
  %61 = ptrtoint i8* %60 to i64, !dbg !1758
  store i64 %61, i64* %8, align 8, !dbg !1759
  %62 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1760
  %63 = load i64, i64* %11, align 8, !dbg !1761
  %64 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %62, i64 %63, !dbg !1760
  %65 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %64, i32 0, i32 1, !dbg !1762
  %66 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %65), !dbg !1763
  store i8* %66, i8** %9, align 8, !dbg !1764
  %67 = load i64, i64* %8, align 8, !dbg !1765
  %68 = icmp ne i64 %67, 0, !dbg !1765
  br i1 %68, label %69, label %81, !dbg !1767

69:                                               ; preds = %55
  %70 = load i8*, i8** %9, align 8, !dbg !1768
  %71 = icmp ne i8* %70, null, !dbg !1768
  br i1 %71, label %72, label %81, !dbg !1769

72:                                               ; preds = %69
  %73 = load i64, i64* %11, align 8, !dbg !1770
  %74 = add i64 %73, 1, !dbg !1772
  %75 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !1773
  %76 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %75, i32 0, i32 1, !dbg !1774
  store i64 %74, i64* %76, align 8, !dbg !1775
  %77 = load i64, i64* %8, align 8, !dbg !1776
  %78 = load i64*, i64** %6, align 8, !dbg !1777
  store i64 %77, i64* %78, align 8, !dbg !1778
  %79 = load i8*, i8** %9, align 8, !dbg !1779
  %80 = load i8**, i8*** %7, align 8, !dbg !1780
  store i8* %79, i8** %80, align 8, !dbg !1781
  store i1 true, i1* %4, align 1, !dbg !1782
  br label %86, !dbg !1782

81:                                               ; preds = %69, %55
  br label %82, !dbg !1783

82:                                               ; preds = %81
  %83 = load i64, i64* %11, align 8, !dbg !1784
  %84 = add i64 %83, 1, !dbg !1784
  store i64 %84, i64* %11, align 8, !dbg !1784
  br label %47, !dbg !1785, !llvm.loop !1786

85:                                               ; preds = %47
  store i1 false, i1* %4, align 1, !dbg !1788
  br label %86, !dbg !1788

86:                                               ; preds = %85, %72
  %87 = load i1, i1* %4, align 1, !dbg !1789
  ret i1 %87, !dbg !1789
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_subtract_from(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1) #0 !dbg !1790 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !1791, metadata !DIExpression()), !dbg !1792
  store %struct.trace_s* %1, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !1793, metadata !DIExpression()), !dbg !1794
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1795
  %6 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1796
  call void @_trace_merge_or_subtract(%struct.trace_s* noundef %5, %struct.trace_s* noundef %6, i1 noundef zeroext true), !dbg !1797
  ret void, !dbg !1798
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @trace_is_subtrace(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1, void (i64)* noundef %2) #0 !dbg !1799 {
  %4 = alloca i1, align 1
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca %struct.trace_s*, align 8
  %7 = alloca void (i64)*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca %struct.trace_unit_s*, align 8
  %11 = alloca %struct.trace_unit_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !1805, metadata !DIExpression()), !dbg !1806
  store %struct.trace_s* %1, %struct.trace_s** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %6, metadata !1807, metadata !DIExpression()), !dbg !1808
  store void (i64)* %2, void (i64)** %7, align 8
  call void @llvm.dbg.declare(metadata void (i64)** %7, metadata !1809, metadata !DIExpression()), !dbg !1810
  call void @llvm.dbg.declare(metadata i64* %8, metadata !1811, metadata !DIExpression()), !dbg !1812
  store i64 0, i64* %8, align 8, !dbg !1812
  call void @llvm.dbg.declare(metadata i64* %9, metadata !1813, metadata !DIExpression()), !dbg !1814
  store i64 0, i64* %9, align 8, !dbg !1814
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %10, metadata !1815, metadata !DIExpression()), !dbg !1816
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %11, metadata !1817, metadata !DIExpression()), !dbg !1818
  store i64 0, i64* %8, align 8, !dbg !1819
  br label %12, !dbg !1821

12:                                               ; preds = %86, %3
  %13 = load i64, i64* %8, align 8, !dbg !1822
  %14 = load %struct.trace_s*, %struct.trace_s** %6, align 8, !dbg !1824
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 1, !dbg !1825
  %16 = load i64, i64* %15, align 8, !dbg !1825
  %17 = icmp ult i64 %13, %16, !dbg !1826
  br i1 %17, label %18, label %89, !dbg !1827

18:                                               ; preds = %12
  %19 = load %struct.trace_s*, %struct.trace_s** %6, align 8, !dbg !1828
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 0, !dbg !1830
  %21 = load %struct.trace_unit_s*, %struct.trace_unit_s** %20, align 8, !dbg !1830
  %22 = load i64, i64* %8, align 8, !dbg !1831
  %23 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %21, i64 %22, !dbg !1828
  store %struct.trace_unit_s* %23, %struct.trace_unit_s** %10, align 8, !dbg !1832
  %24 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1833
  %25 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1835
  %26 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %25, i32 0, i32 0, !dbg !1836
  %27 = load i64, i64* %26, align 8, !dbg !1836
  %28 = call zeroext i1 @trace_find_unit_idx(%struct.trace_s* noundef %24, i64 noundef %27, i64* noundef %9), !dbg !1837
  br i1 %28, label %29, label %72, !dbg !1838

29:                                               ; preds = %18
  %30 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1839
  %31 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %30, i32 0, i32 0, !dbg !1841
  %32 = load %struct.trace_unit_s*, %struct.trace_unit_s** %31, align 8, !dbg !1841
  %33 = load i64, i64* %9, align 8, !dbg !1842
  %34 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %32, i64 %33, !dbg !1839
  store %struct.trace_unit_s* %34, %struct.trace_unit_s** %11, align 8, !dbg !1843
  %35 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1844
  %36 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %35, i32 0, i32 0, !dbg !1844
  %37 = load i64, i64* %36, align 8, !dbg !1844
  %38 = load %struct.trace_unit_s*, %struct.trace_unit_s** %11, align 8, !dbg !1844
  %39 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %38, i32 0, i32 0, !dbg !1844
  %40 = load i64, i64* %39, align 8, !dbg !1844
  %41 = icmp eq i64 %37, %40, !dbg !1844
  br i1 %41, label %42, label %43, !dbg !1847

42:                                               ; preds = %29
  br label %44, !dbg !1847

43:                                               ; preds = %29
  call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.44, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 308, i8* noundef getelementptr inbounds ([70 x i8], [70 x i8]* @__PRETTY_FUNCTION__.trace_is_subtrace, i64 0, i64 0)) #5, !dbg !1844
  unreachable, !dbg !1844

44:                                               ; preds = %42
  %45 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1848
  %46 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %45, i32 0, i32 1, !dbg !1850
  %47 = load i64, i64* %46, align 8, !dbg !1850
  %48 = load %struct.trace_unit_s*, %struct.trace_unit_s** %11, align 8, !dbg !1851
  %49 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %48, i32 0, i32 1, !dbg !1852
  %50 = load i64, i64* %49, align 8, !dbg !1852
  %51 = icmp ne i64 %47, %50, !dbg !1853
  br i1 %51, label %52, label %71, !dbg !1854

52:                                               ; preds = %44
  %53 = load void (i64)*, void (i64)** %7, align 8, !dbg !1855
  %54 = icmp ne void (i64)* %53, null, !dbg !1855
  br i1 %54, label %55, label %70, !dbg !1858

55:                                               ; preds = %52
  %56 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1859
  %57 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %56, i32 0, i32 0, !dbg !1861
  %58 = load i64, i64* %57, align 8, !dbg !1861
  %59 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1862
  %60 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %59, i32 0, i32 1, !dbg !1863
  %61 = load i64, i64* %60, align 8, !dbg !1863
  %62 = load %struct.trace_unit_s*, %struct.trace_unit_s** %11, align 8, !dbg !1864
  %63 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %62, i32 0, i32 1, !dbg !1865
  %64 = load i64, i64* %63, align 8, !dbg !1865
  %65 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @.str.45, i64 0, i64 0), i64 noundef %58, i64 noundef %61, i64 noundef %64), !dbg !1866
  %66 = load void (i64)*, void (i64)** %7, align 8, !dbg !1867
  %67 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1868
  %68 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %67, i32 0, i32 0, !dbg !1869
  %69 = load i64, i64* %68, align 8, !dbg !1869
  call void %66(i64 noundef %69), !dbg !1867
  br label %70, !dbg !1870

70:                                               ; preds = %55, %52
  store i1 false, i1* %4, align 1, !dbg !1871
  br label %90, !dbg !1871

71:                                               ; preds = %44
  br label %85, !dbg !1872

72:                                               ; preds = %18
  %73 = load void (i64)*, void (i64)** %7, align 8, !dbg !1873
  %74 = icmp ne void (i64)* %73, null, !dbg !1873
  br i1 %74, label %75, label %84, !dbg !1876

75:                                               ; preds = %72
  %76 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1877
  %77 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %76, i32 0, i32 0, !dbg !1879
  %78 = load i64, i64* %77, align 8, !dbg !1879
  %79 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.46, i64 0, i64 0), i64 noundef %78), !dbg !1880
  %80 = load void (i64)*, void (i64)** %7, align 8, !dbg !1881
  %81 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1882
  %82 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %81, i32 0, i32 0, !dbg !1883
  %83 = load i64, i64* %82, align 8, !dbg !1883
  call void %80(i64 noundef %83), !dbg !1881
  br label %84, !dbg !1884

84:                                               ; preds = %75, %72
  store i1 false, i1* %4, align 1, !dbg !1885
  br label %90, !dbg !1885

85:                                               ; preds = %71
  br label %86, !dbg !1886

86:                                               ; preds = %85
  %87 = load i64, i64* %8, align 8, !dbg !1887
  %88 = add i64 %87, 1, !dbg !1887
  store i64 %88, i64* %8, align 8, !dbg !1887
  br label %12, !dbg !1888, !llvm.loop !1889

89:                                               ; preds = %12
  store i1 true, i1* %4, align 1, !dbg !1891
  br label %90, !dbg !1891

90:                                               ; preds = %89, %84, %70
  %91 = load i1, i1* %4, align 1, !dbg !1892
  ret i1 %91, !dbg !1892
}

; Function Attrs: noinline nounwind uwtable
define internal void @_trace_merge_or_subtract(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1, i1 noundef zeroext %2) #0 !dbg !1893 {
  %4 = alloca %struct.trace_s*, align 8
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca i8, align 1
  %7 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !1896, metadata !DIExpression()), !dbg !1897
  store %struct.trace_s* %1, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !1898, metadata !DIExpression()), !dbg !1899
  %8 = zext i1 %2 to i8
  store i8 %8, i8* %6, align 1
  call void @llvm.dbg.declare(metadata i8* %6, metadata !1900, metadata !DIExpression()), !dbg !1901
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1902, metadata !DIExpression()), !dbg !1903
  store i64 0, i64* %7, align 8, !dbg !1903
  %9 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1904
  %10 = icmp ne %struct.trace_s* %9, null, !dbg !1904
  br i1 %10, label %11, label %12, !dbg !1907

11:                                               ; preds = %3
  br label %13, !dbg !1907

12:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.37, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 165, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !1904
  unreachable, !dbg !1904

13:                                               ; preds = %11
  %14 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1908
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 3, !dbg !1908
  %16 = load i8, i8* %15, align 8, !dbg !1908
  %17 = trunc i8 %16 to i1, !dbg !1908
  br i1 %17, label %18, label %19, !dbg !1911

18:                                               ; preds = %13
  br label %20, !dbg !1911

19:                                               ; preds = %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.38, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 166, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !1908
  unreachable, !dbg !1908

20:                                               ; preds = %18
  %21 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1912
  %22 = icmp ne %struct.trace_s* %21, null, !dbg !1912
  br i1 %22, label %23, label %24, !dbg !1915

23:                                               ; preds = %20
  br label %25, !dbg !1915

24:                                               ; preds = %20
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 168, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !1912
  unreachable, !dbg !1912

25:                                               ; preds = %23
  %26 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1916
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 3, !dbg !1916
  %28 = load i8, i8* %27, align 8, !dbg !1916
  %29 = trunc i8 %28 to i1, !dbg !1916
  br i1 %29, label %30, label %31, !dbg !1919

30:                                               ; preds = %25
  br label %32, !dbg !1919

31:                                               ; preds = %25
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 169, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !1916
  unreachable, !dbg !1916

32:                                               ; preds = %30
  store i64 0, i64* %7, align 8, !dbg !1920
  br label %33, !dbg !1922

33:                                               ; preds = %57, %32
  %34 = load i64, i64* %7, align 8, !dbg !1923
  %35 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1925
  %36 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %35, i32 0, i32 1, !dbg !1926
  %37 = load i64, i64* %36, align 8, !dbg !1926
  %38 = icmp ult i64 %34, %37, !dbg !1927
  br i1 %38, label %39, label %60, !dbg !1928

39:                                               ; preds = %33
  %40 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1929
  %41 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1931
  %42 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %41, i32 0, i32 0, !dbg !1932
  %43 = load %struct.trace_unit_s*, %struct.trace_unit_s** %42, align 8, !dbg !1932
  %44 = load i64, i64* %7, align 8, !dbg !1933
  %45 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %43, i64 %44, !dbg !1931
  %46 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %45, i32 0, i32 0, !dbg !1934
  %47 = load i64, i64* %46, align 8, !dbg !1934
  %48 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1935
  %49 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %48, i32 0, i32 0, !dbg !1936
  %50 = load %struct.trace_unit_s*, %struct.trace_unit_s** %49, align 8, !dbg !1936
  %51 = load i64, i64* %7, align 8, !dbg !1937
  %52 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %50, i64 %51, !dbg !1935
  %53 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %52, i32 0, i32 1, !dbg !1938
  %54 = load i64, i64* %53, align 8, !dbg !1938
  %55 = load i8, i8* %6, align 1, !dbg !1939
  %56 = trunc i8 %55 to i1, !dbg !1939
  call void @_trace_add_or_rem_occurrences(%struct.trace_s* noundef %40, i64 noundef %47, i64 noundef %54, i1 noundef zeroext %56), !dbg !1940
  br label %57, !dbg !1941

57:                                               ; preds = %39
  %58 = load i64, i64* %7, align 8, !dbg !1942
  %59 = add i64 %58, 1, !dbg !1942
  store i64 %59, i64* %7, align 8, !dbg !1942
  br label %33, !dbg !1943, !llvm.loop !1944

60:                                               ; preds = %33
  ret void, !dbg !1946
}

declare i32 @printf(i8* noundef, ...) #4

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !1947 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !1948, metadata !DIExpression()), !dbg !1949
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1950, !srcloc !1951
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1952, metadata !DIExpression()), !dbg !1953
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !1954
  %6 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %5, i32 0, i32 0, !dbg !1955
  %7 = bitcast i8** %6 to i64*, !dbg !1956
  %8 = bitcast i8** %4 to i64*, !dbg !1956
  %9 = load atomic i64, i64* %7 monotonic, align 8, !dbg !1956
  store i64 %9, i64* %8, align 8, !dbg !1956
  %10 = bitcast i64* %8 to i8**, !dbg !1956
  %11 = load i8*, i8** %10, align 8, !dbg !1956
  store i8* %11, i8** %3, align 8, !dbg !1953
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1957, !srcloc !1958
  %12 = load i8*, i8** %3, align 8, !dbg !1959
  ret i8* %12, !dbg !1960
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!184, !185, !186, !187, !188, !189, !190}
!llvm.ident = !{!191}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_tid", scope: !2, file: !113, line: 29, type: !29, isLocal: false, isDefinition: true)
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
!53 = !{!0, !54, !60, !62, !64, !66, !161, !180, !182}
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "g_pre_keys", scope: !2, file: !56, line: 11, type: !57, isLocal: false, isDefinition: true)
!56 = !DIFile(filename: "verify/simpleht/test_case_add_get.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "45adf53d94a40478d4e65620da051055")
!57 = !DICompositeType(tag: DW_TAG_array_type, baseType: !19, size: 128, elements: !58)
!58 = !{!59}
!59 = !DISubrange(count: 2)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "g_new_key", scope: !2, file: !56, line: 12, type: !19, isLocal: false, isDefinition: true)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "g_added", scope: !2, file: !56, line: 13, type: !42, isLocal: false, isDefinition: true)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "g_got_nw_val", scope: !2, file: !56, line: 14, type: !42, isLocal: false, isDefinition: true)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "g_simpleht", scope: !2, file: !68, line: 35, type: !69, isLocal: true, isDefinition: true)
!68 = !DIFile(filename: "test/include/test/map/isimple.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "9bd6bf935fca0aec8816b4ad5eb860a6")
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_t", file: !6, line: 94, baseType: !70)
!70 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vsimpleht_s", file: !6, line: 83, size: 1472, elements: !71)
!71 = !{!72, !73, !85, !95, !100, !105, !106, !111}
!72 = !DIDerivedType(tag: DW_TAG_member, name: "capacity", scope: !70, file: !6, line: 84, baseType: !14, size: 64)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "entries", scope: !70, file: !6, line: 85, baseType: !74, size: 64, offset: 64)
!74 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !75, size: 64)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_entry_t", file: !6, line: 81, baseType: !76)
!76 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vsimpleht_entry_s", file: !6, line: 78, size: 128, elements: !77)
!77 = !{!78, !84}
!78 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !76, file: !6, line: 79, baseType: !79, size: 64, align: 64)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomicptr_t", file: !80, line: 45, baseType: !81)
!80 = !DIFile(filename: "vatomic/include/vsync/atomic/internal/types.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "4649bfff29481cecec17d9044409fd19")
!81 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomicptr_s", file: !80, line: 43, size: 64, align: 64, elements: !82)
!82 = !{!83}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !81, file: !80, line: 44, baseType: !22, size: 64)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !76, file: !6, line: 80, baseType: !79, size: 64, align: 64, offset: 64)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "cmp_key", scope: !70, file: !6, line: 86, baseType: !86, size: 64, offset: 128)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_cmp_key_t", file: !6, line: 74, baseType: !87)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = !DISubroutineType(types: !89)
!89 = !{!90, !19, !19}
!90 = !DIDerivedType(tag: DW_TAG_typedef, name: "vint8_t", file: !15, line: 40, baseType: !91)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !92, line: 24, baseType: !93)
!92 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "", checksumkind: CSK_MD5, checksum: "55bcbdc3159515ebd91d351a70d505f4")
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !27, line: 37, baseType: !94)
!94 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "hash_key", scope: !70, file: !6, line: 87, baseType: !96, size: 64, offset: 192)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_hash_key_t", file: !6, line: 75, baseType: !97)
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!98 = !DISubroutineType(types: !99)
!99 = !{!49, !19}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "cb_destroy", scope: !70, file: !6, line: 88, baseType: !101, size: 64, offset: 256)
!101 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_destroy_entry_t", file: !6, line: 76, baseType: !102)
!102 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!103 = !DISubroutineType(types: !104)
!104 = !{null, !22}
!105 = !DIDerivedType(tag: DW_TAG_member, name: "cleaning_threshold", scope: !70, file: !6, line: 90, baseType: !14, size: 64, offset: 320)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "deleted_count", scope: !70, file: !6, line: 91, baseType: !107, size: 64, align: 64, offset: 384)
!107 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomicsz_t", file: !80, line: 50, baseType: !108)
!108 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomicsz_s", file: !80, line: 48, size: 64, align: 64, elements: !109)
!109 = !{!110}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !108, file: !80, line: 49, baseType: !14, size: 64)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !70, file: !6, line: 92, baseType: !112, size: 1024, offset: 448)
!112 = !DIDerivedType(tag: DW_TAG_typedef, name: "rwlock_t", file: !113, line: 27, baseType: !114)
!113 = !DIFile(filename: "verify/include/verify/rwlock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "d22ae5b6c849e685e5cacdc91023be13")
!114 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "rwlock_s", file: !113, line: 23, size: 1024, elements: !115)
!115 = !{!116, !151, !156}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !114, file: !113, line: 24, baseType: !117, size: 960)
!117 = !DICompositeType(tag: DW_TAG_array_type, baseType: !118, size: 960, elements: !149)
!118 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !39, line: 72, baseType: !119)
!119 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !39, line: 67, size: 320, elements: !120)
!120 = !{!121, !142, !147}
!121 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !119, file: !39, line: 69, baseType: !122, size: 320)
!122 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !123, line: 22, size: 320, elements: !124)
!123 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "584baedd80e6041b81caae7f496091c0")
!124 = !{!125, !127, !128, !129, !130, !131, !133, !134}
!125 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !122, file: !123, line: 24, baseType: !126, size: 32)
!126 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !122, file: !123, line: 25, baseType: !7, size: 32, offset: 32)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !122, file: !123, line: 26, baseType: !126, size: 32, offset: 64)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !122, file: !123, line: 28, baseType: !7, size: 32, offset: 96)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !122, file: !123, line: 32, baseType: !126, size: 32, offset: 128)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !122, file: !123, line: 34, baseType: !132, size: 16, offset: 160)
!132 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !122, file: !123, line: 35, baseType: !132, size: 16, offset: 176)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !122, file: !123, line: 36, baseType: !135, size: 128, offset: 192)
!135 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !136, line: 55, baseType: !137)
!136 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "04c81e86d34dad9c99ad006d32e47a0d")
!137 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !136, line: 51, size: 128, elements: !138)
!138 = !{!139, !141}
!139 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !137, file: !136, line: 53, baseType: !140, size: 64)
!140 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !137, size: 64)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !137, file: !136, line: 54, baseType: !140, size: 64, offset: 64)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !119, file: !39, line: 70, baseType: !143, size: 320)
!143 = !DICompositeType(tag: DW_TAG_array_type, baseType: !144, size: 320, elements: !145)
!144 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!145 = !{!146}
!146 = !DISubrange(count: 40)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !119, file: !39, line: 71, baseType: !148, size: 64)
!148 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!149 = !{!150}
!150 = !DISubrange(count: 3)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "writer_active", scope: !114, file: !113, line: 25, baseType: !152, size: 8, offset: 960)
!152 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic8_t", file: !80, line: 25, baseType: !153)
!153 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic8_s", file: !80, line: 23, size: 8, elements: !154)
!154 = !{!155}
!155 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !153, file: !80, line: 24, baseType: !23, size: 8)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "idx", scope: !114, file: !113, line: 26, baseType: !157, size: 32, align: 32, offset: 992)
!157 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !80, line: 35, baseType: !158)
!158 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !80, line: 33, size: 32, align: 32, elements: !159)
!159 = !{!160}
!160 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !158, file: !80, line: 34, baseType: !29, size: 32)
!161 = !DIGlobalVariableExpression(var: !162, expr: !DIExpression())
!162 = distinct !DIGlobalVariable(name: "g_add", scope: !2, file: !68, line: 33, type: !163, isLocal: true, isDefinition: true)
!163 = !DICompositeType(tag: DW_TAG_array_type, baseType: !164, size: 1024, elements: !178)
!164 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_t", file: !165, line: 29, baseType: !166)
!165 = !DIFile(filename: "test/include/test/trace_manager.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "5ba0f33a5901d8ee1ef7d1e8c3546fa0")
!166 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_s", file: !165, line: 24, size: 256, elements: !167)
!167 = !{!168, !175, !176, !177}
!168 = !DIDerivedType(tag: DW_TAG_member, name: "units", scope: !166, file: !165, line: 25, baseType: !169, size: 64)
!169 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !170, size: 64)
!170 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_unit_t", file: !165, line: 22, baseType: !171)
!171 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_unit_s", file: !165, line: 19, size: 128, elements: !172)
!172 = !{!173, !174}
!173 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !171, file: !165, line: 20, baseType: !19, size: 64)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !171, file: !165, line: 21, baseType: !14, size: 64, offset: 64)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !166, file: !165, line: 26, baseType: !14, size: 64, offset: 64)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "capacity", scope: !166, file: !165, line: 27, baseType: !14, size: 64, offset: 128)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "initialized", scope: !166, file: !165, line: 28, baseType: !42, size: 8, offset: 192)
!178 = !{!179}
!179 = !DISubrange(count: 4)
!180 = !DIGlobalVariableExpression(var: !181, expr: !DIExpression())
!181 = distinct !DIGlobalVariable(name: "g_rem", scope: !2, file: !68, line: 34, type: !163, isLocal: true, isDefinition: true)
!182 = !DIGlobalVariableExpression(var: !183, expr: !DIExpression())
!183 = distinct !DIGlobalVariable(name: "g_buff", scope: !2, file: !68, line: 36, type: !22, isLocal: true, isDefinition: true)
!184 = !{i32 7, !"Dwarf Version", i32 5}
!185 = !{i32 2, !"Debug Info Version", i32 3}
!186 = !{i32 1, !"wchar_size", i32 4}
!187 = !{i32 7, !"PIC Level", i32 2}
!188 = !{i32 7, !"PIE Level", i32 2}
!189 = !{i32 7, !"uwtable", i32 1}
!190 = !{i32 7, !"frame-pointer", i32 2}
!191 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!192 = distinct !DISubprogram(name: "pre", scope: !56, file: !56, line: 17, type: !193, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !195)
!193 = !DISubroutineType(types: !194)
!194 = !{null}
!195 = !{}
!196 = !DILocalVariable(name: "i", scope: !197, file: !56, line: 19, type: !14)
!197 = distinct !DILexicalBlock(scope: !192, file: !56, line: 19, column: 5)
!198 = !DILocation(line: 19, column: 18, scope: !197)
!199 = !DILocation(line: 19, column: 10, scope: !197)
!200 = !DILocation(line: 19, column: 25, scope: !201)
!201 = distinct !DILexicalBlock(scope: !197, file: !56, line: 19, column: 5)
!202 = !DILocation(line: 19, column: 27, scope: !201)
!203 = !DILocation(line: 19, column: 5, scope: !197)
!204 = !DILocalVariable(name: "success", scope: !205, file: !56, line: 20, type: !42)
!205 = distinct !DILexicalBlock(scope: !201, file: !56, line: 19, column: 48)
!206 = !DILocation(line: 20, column: 17, scope: !205)
!207 = !DILocation(line: 20, column: 57, scope: !205)
!208 = !DILocation(line: 20, column: 46, scope: !205)
!209 = !DILocation(line: 20, column: 72, scope: !205)
!210 = !DILocation(line: 20, column: 61, scope: !205)
!211 = !DILocation(line: 20, column: 27, scope: !205)
!212 = !DILocation(line: 21, column: 9, scope: !213)
!213 = distinct !DILexicalBlock(scope: !214, file: !56, line: 21, column: 9)
!214 = distinct !DILexicalBlock(scope: !205, file: !56, line: 21, column: 9)
!215 = !DILocation(line: 21, column: 9, scope: !214)
!216 = !DILocation(line: 22, column: 5, scope: !205)
!217 = !DILocation(line: 19, column: 44, scope: !201)
!218 = !DILocation(line: 19, column: 5, scope: !201)
!219 = distinct !{!219, !203, !220, !221}
!220 = !DILocation(line: 22, column: 5, scope: !197)
!221 = !{!"llvm.loop.mustprogress"}
!222 = !DILocation(line: 23, column: 1, scope: !192)
!223 = distinct !DISubprogram(name: "imap_add", scope: !68, file: !68, line: 140, type: !224, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!224 = !DISubroutineType(types: !225)
!225 = !{!42, !14, !19, !49}
!226 = !DILocalVariable(name: "tid", arg: 1, scope: !223, file: !68, line: 140, type: !14)
!227 = !DILocation(line: 140, column: 18, scope: !223)
!228 = !DILocalVariable(name: "key", arg: 2, scope: !223, file: !68, line: 140, type: !19)
!229 = !DILocation(line: 140, column: 34, scope: !223)
!230 = !DILocalVariable(name: "val", arg: 3, scope: !223, file: !68, line: 140, type: !49)
!231 = !DILocation(line: 140, column: 49, scope: !223)
!232 = !DILocalVariable(name: "data", scope: !223, file: !68, line: 142, type: !233)
!233 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !234, size: 64)
!234 = !DIDerivedType(tag: DW_TAG_typedef, name: "data_t", file: !68, line: 30, baseType: !235)
!235 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "data_s", file: !68, line: 27, size: 128, elements: !236)
!236 = !{!237, !238}
!237 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !235, file: !68, line: 28, baseType: !19, size: 64)
!238 = !DIDerivedType(tag: DW_TAG_member, name: "val", scope: !235, file: !68, line: 29, baseType: !49, size: 64, offset: 64)
!239 = !DILocation(line: 142, column: 13, scope: !223)
!240 = !DILocation(line: 142, column: 20, scope: !223)
!241 = !DILocation(line: 143, column: 20, scope: !223)
!242 = !DILocation(line: 143, column: 5, scope: !223)
!243 = !DILocation(line: 143, column: 11, scope: !223)
!244 = !DILocation(line: 143, column: 18, scope: !223)
!245 = !DILocation(line: 144, column: 20, scope: !223)
!246 = !DILocation(line: 144, column: 5, scope: !223)
!247 = !DILocation(line: 144, column: 11, scope: !223)
!248 = !DILocation(line: 144, column: 18, scope: !223)
!249 = !DILocalVariable(name: "added", scope: !223, file: !68, line: 145, type: !42)
!250 = !DILocation(line: 145, column: 13, scope: !223)
!251 = !DILocation(line: 146, column: 36, scope: !223)
!252 = !DILocation(line: 146, column: 42, scope: !223)
!253 = !DILocation(line: 146, column: 47, scope: !223)
!254 = !DILocation(line: 146, column: 9, scope: !223)
!255 = !DILocation(line: 146, column: 53, scope: !223)
!256 = !DILocation(line: 147, column: 9, scope: !257)
!257 = distinct !DILexicalBlock(scope: !223, file: !68, line: 147, column: 9)
!258 = !DILocation(line: 147, column: 9, scope: !223)
!259 = !DILocation(line: 148, column: 26, scope: !260)
!260 = distinct !DILexicalBlock(scope: !257, file: !68, line: 147, column: 16)
!261 = !DILocation(line: 148, column: 20, scope: !260)
!262 = !DILocation(line: 148, column: 32, scope: !260)
!263 = !DILocation(line: 148, column: 38, scope: !260)
!264 = !DILocation(line: 148, column: 9, scope: !260)
!265 = !DILocation(line: 149, column: 5, scope: !260)
!266 = !DILocation(line: 150, column: 14, scope: !267)
!267 = distinct !DILexicalBlock(scope: !257, file: !68, line: 149, column: 12)
!268 = !DILocation(line: 150, column: 9, scope: !267)
!269 = !DILocation(line: 152, column: 12, scope: !223)
!270 = !DILocation(line: 152, column: 5, scope: !223)
!271 = distinct !DISubprogram(name: "t0", scope: !56, file: !56, line: 25, type: !272, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !195)
!272 = !DISubroutineType(types: !273)
!273 = !{null, !14}
!274 = !DILocalVariable(name: "tid", arg: 1, scope: !271, file: !56, line: 25, type: !14)
!275 = !DILocation(line: 25, column: 12, scope: !271)
!276 = !DILocation(line: 27, column: 5, scope: !277)
!277 = distinct !DILexicalBlock(scope: !278, file: !56, line: 27, column: 5)
!278 = distinct !DILexicalBlock(scope: !271, file: !56, line: 27, column: 5)
!279 = !DILocation(line: 27, column: 5, scope: !278)
!280 = !DILocalVariable(name: "data", scope: !271, file: !56, line: 28, type: !233)
!281 = !DILocation(line: 28, column: 13, scope: !271)
!282 = !DILocation(line: 28, column: 29, scope: !271)
!283 = !DILocation(line: 28, column: 45, scope: !271)
!284 = !DILocation(line: 28, column: 34, scope: !271)
!285 = !DILocation(line: 28, column: 20, scope: !271)
!286 = !DILocation(line: 29, column: 5, scope: !287)
!287 = distinct !DILexicalBlock(scope: !288, file: !56, line: 29, column: 5)
!288 = distinct !DILexicalBlock(scope: !271, file: !56, line: 29, column: 5)
!289 = !DILocation(line: 29, column: 5, scope: !288)
!290 = !DILocation(line: 30, column: 1, scope: !271)
!291 = distinct !DISubprogram(name: "imap_get", scope: !68, file: !68, line: 166, type: !292, scopeLine: 167, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!292 = !DISubroutineType(types: !293)
!293 = !{!22, !14, !19}
!294 = !DILocalVariable(name: "tid", arg: 1, scope: !291, file: !68, line: 166, type: !14)
!295 = !DILocation(line: 166, column: 18, scope: !291)
!296 = !DILocalVariable(name: "key", arg: 2, scope: !291, file: !68, line: 166, type: !19)
!297 = !DILocation(line: 166, column: 34, scope: !291)
!298 = !DILocation(line: 168, column: 5, scope: !291)
!299 = !DILocation(line: 168, column: 5, scope: !300)
!300 = distinct !DILexicalBlock(scope: !291, file: !68, line: 168, column: 5)
!301 = !DILocation(line: 168, column: 5, scope: !302)
!302 = distinct !DILexicalBlock(scope: !300, file: !68, line: 168, column: 5)
!303 = !DILocation(line: 168, column: 5, scope: !304)
!304 = distinct !DILexicalBlock(scope: !302, file: !68, line: 168, column: 5)
!305 = !DILocalVariable(name: "data", scope: !291, file: !68, line: 169, type: !233)
!306 = !DILocation(line: 169, column: 13, scope: !291)
!307 = !DILocation(line: 169, column: 47, scope: !291)
!308 = !DILocation(line: 169, column: 20, scope: !291)
!309 = !DILocation(line: 170, column: 9, scope: !310)
!310 = distinct !DILexicalBlock(scope: !291, file: !68, line: 170, column: 9)
!311 = !DILocation(line: 170, column: 9, scope: !291)
!312 = !DILocation(line: 171, column: 9, scope: !313)
!313 = distinct !DILexicalBlock(scope: !314, file: !68, line: 171, column: 9)
!314 = distinct !DILexicalBlock(scope: !315, file: !68, line: 171, column: 9)
!315 = distinct !DILexicalBlock(scope: !310, file: !68, line: 170, column: 15)
!316 = !DILocation(line: 171, column: 9, scope: !314)
!317 = !DILocation(line: 172, column: 5, scope: !315)
!318 = !DILocation(line: 173, column: 12, scope: !291)
!319 = !DILocation(line: 173, column: 5, scope: !291)
!320 = distinct !DISubprogram(name: "t1", scope: !56, file: !56, line: 32, type: !272, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !195)
!321 = !DILocalVariable(name: "tid", arg: 1, scope: !320, file: !56, line: 32, type: !14)
!322 = !DILocation(line: 32, column: 12, scope: !320)
!323 = !DILocation(line: 34, column: 5, scope: !324)
!324 = distinct !DILexicalBlock(scope: !325, file: !56, line: 34, column: 5)
!325 = distinct !DILexicalBlock(scope: !320, file: !56, line: 34, column: 5)
!326 = !DILocation(line: 34, column: 5, scope: !325)
!327 = !DILocalVariable(name: "data", scope: !320, file: !56, line: 35, type: !233)
!328 = !DILocation(line: 35, column: 13, scope: !320)
!329 = !DILocation(line: 35, column: 29, scope: !320)
!330 = !DILocation(line: 35, column: 45, scope: !320)
!331 = !DILocation(line: 35, column: 34, scope: !320)
!332 = !DILocation(line: 35, column: 20, scope: !320)
!333 = !DILocation(line: 36, column: 5, scope: !334)
!334 = distinct !DILexicalBlock(scope: !335, file: !56, line: 36, column: 5)
!335 = distinct !DILexicalBlock(scope: !320, file: !56, line: 36, column: 5)
!336 = !DILocation(line: 36, column: 5, scope: !335)
!337 = !DILocation(line: 37, column: 1, scope: !320)
!338 = distinct !DISubprogram(name: "t2", scope: !56, file: !56, line: 39, type: !272, scopeLine: 40, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !195)
!339 = !DILocalVariable(name: "tid", arg: 1, scope: !338, file: !56, line: 39, type: !14)
!340 = !DILocation(line: 39, column: 12, scope: !338)
!341 = !DILocalVariable(name: "success", scope: !338, file: !56, line: 41, type: !42)
!342 = !DILocation(line: 41, column: 13, scope: !338)
!343 = !DILocation(line: 41, column: 32, scope: !338)
!344 = !DILocation(line: 41, column: 37, scope: !338)
!345 = !DILocation(line: 41, column: 48, scope: !338)
!346 = !DILocation(line: 41, column: 23, scope: !338)
!347 = !DILocation(line: 42, column: 5, scope: !348)
!348 = distinct !DILexicalBlock(scope: !349, file: !56, line: 42, column: 5)
!349 = distinct !DILexicalBlock(scope: !338, file: !56, line: 42, column: 5)
!350 = !DILocation(line: 42, column: 5, scope: !349)
!351 = !DILocalVariable(name: "data", scope: !338, file: !56, line: 43, type: !233)
!352 = !DILocation(line: 43, column: 13, scope: !338)
!353 = !DILocation(line: 43, column: 29, scope: !338)
!354 = !DILocation(line: 43, column: 34, scope: !338)
!355 = !DILocation(line: 43, column: 20, scope: !338)
!356 = !DILocation(line: 44, column: 5, scope: !357)
!357 = distinct !DILexicalBlock(scope: !358, file: !56, line: 44, column: 5)
!358 = distinct !DILexicalBlock(scope: !338, file: !56, line: 44, column: 5)
!359 = !DILocation(line: 44, column: 5, scope: !358)
!360 = !DILocation(line: 45, column: 1, scope: !338)
!361 = distinct !DISubprogram(name: "post", scope: !56, file: !56, line: 47, type: !193, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !195)
!362 = !DILocalVariable(name: "i", scope: !363, file: !56, line: 49, type: !14)
!363 = distinct !DILexicalBlock(scope: !361, file: !56, line: 49, column: 5)
!364 = !DILocation(line: 49, column: 18, scope: !363)
!365 = !DILocation(line: 49, column: 10, scope: !363)
!366 = !DILocation(line: 49, column: 25, scope: !367)
!367 = distinct !DILexicalBlock(scope: !363, file: !56, line: 49, column: 5)
!368 = !DILocation(line: 49, column: 27, scope: !367)
!369 = !DILocation(line: 49, column: 5, scope: !363)
!370 = !DILocalVariable(name: "data", scope: !371, file: !56, line: 50, type: !233)
!371 = distinct !DILexicalBlock(scope: !367, file: !56, line: 49, column: 48)
!372 = !DILocation(line: 50, column: 17, scope: !371)
!373 = !DILocation(line: 50, column: 54, scope: !371)
!374 = !DILocation(line: 50, column: 43, scope: !371)
!375 = !DILocation(line: 50, column: 24, scope: !371)
!376 = !DILocation(line: 51, column: 9, scope: !377)
!377 = distinct !DILexicalBlock(scope: !378, file: !56, line: 51, column: 9)
!378 = distinct !DILexicalBlock(scope: !371, file: !56, line: 51, column: 9)
!379 = !DILocation(line: 51, column: 9, scope: !378)
!380 = !DILocation(line: 52, column: 5, scope: !371)
!381 = !DILocation(line: 49, column: 44, scope: !367)
!382 = !DILocation(line: 49, column: 5, scope: !367)
!383 = distinct !{!383, !369, !384, !221}
!384 = !DILocation(line: 52, column: 5, scope: !363)
!385 = !DILocalVariable(name: "data", scope: !361, file: !56, line: 53, type: !233)
!386 = !DILocation(line: 53, column: 13, scope: !361)
!387 = !DILocation(line: 53, column: 39, scope: !361)
!388 = !DILocation(line: 53, column: 20, scope: !361)
!389 = !DILocation(line: 54, column: 5, scope: !390)
!390 = distinct !DILexicalBlock(scope: !391, file: !56, line: 54, column: 5)
!391 = distinct !DILexicalBlock(scope: !361, file: !56, line: 54, column: 5)
!392 = !DILocation(line: 54, column: 5, scope: !391)
!393 = !DILocation(line: 55, column: 1, scope: !361)
!394 = distinct !DISubprogram(name: "run", scope: !395, file: !395, line: 94, type: !47, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !195)
!395 = !DIFile(filename: "test/include/test/boilerplate/test_case.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "ec4420aa4ca09b8f4298c137e9e77071")
!396 = !DILocalVariable(name: "args", arg: 1, scope: !394, file: !395, line: 94, type: !22)
!397 = !DILocation(line: 94, column: 11, scope: !394)
!398 = !DILocalVariable(name: "tid", scope: !394, file: !395, line: 96, type: !14)
!399 = !DILocation(line: 96, column: 13, scope: !394)
!400 = !DILocation(line: 96, column: 40, scope: !394)
!401 = !DILocation(line: 96, column: 28, scope: !394)
!402 = !DILocation(line: 97, column: 5, scope: !403)
!403 = distinct !DILexicalBlock(scope: !404, file: !395, line: 97, column: 5)
!404 = distinct !DILexicalBlock(scope: !394, file: !395, line: 97, column: 5)
!405 = !DILocation(line: 97, column: 5, scope: !404)
!406 = !DILocation(line: 99, column: 9, scope: !394)
!407 = !DILocation(line: 99, column: 5, scope: !394)
!408 = !DILocation(line: 100, column: 13, scope: !394)
!409 = !DILocation(line: 100, column: 5, scope: !394)
!410 = !DILocation(line: 102, column: 16, scope: !411)
!411 = distinct !DILexicalBlock(scope: !394, file: !395, line: 100, column: 18)
!412 = !DILocation(line: 102, column: 13, scope: !411)
!413 = !DILocation(line: 103, column: 13, scope: !411)
!414 = !DILocation(line: 105, column: 16, scope: !411)
!415 = !DILocation(line: 105, column: 13, scope: !411)
!416 = !DILocation(line: 106, column: 13, scope: !411)
!417 = !DILocation(line: 108, column: 16, scope: !411)
!418 = !DILocation(line: 108, column: 13, scope: !411)
!419 = !DILocation(line: 109, column: 13, scope: !411)
!420 = !DILocation(line: 116, column: 13, scope: !411)
!421 = !DILocation(line: 118, column: 11, scope: !394)
!422 = !DILocation(line: 118, column: 5, scope: !394)
!423 = !DILocation(line: 119, column: 5, scope: !394)
!424 = distinct !DISubprogram(name: "reg", scope: !425, file: !425, line: 11, type: !272, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !195)
!425 = !DIFile(filename: "verify/simpleht/verify.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "fef1aee1945b19b211b0b629c38d4444")
!426 = !DILocalVariable(name: "tid", arg: 1, scope: !424, file: !425, line: 11, type: !14)
!427 = !DILocation(line: 11, column: 13, scope: !424)
!428 = !DILocation(line: 13, column: 14, scope: !424)
!429 = !DILocation(line: 13, column: 5, scope: !424)
!430 = !DILocation(line: 14, column: 1, scope: !424)
!431 = distinct !DISubprogram(name: "dereg", scope: !425, file: !425, line: 16, type: !272, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !195)
!432 = !DILocalVariable(name: "tid", arg: 1, scope: !431, file: !425, line: 16, type: !14)
!433 = !DILocation(line: 16, column: 15, scope: !431)
!434 = !DILocation(line: 18, column: 16, scope: !431)
!435 = !DILocation(line: 18, column: 5, scope: !431)
!436 = !DILocation(line: 19, column: 1, scope: !431)
!437 = distinct !DISubprogram(name: "tc", scope: !395, file: !395, line: 129, type: !193, scopeLine: 130, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !195)
!438 = !DILocation(line: 131, column: 5, scope: !437)
!439 = !DILocation(line: 132, column: 5, scope: !437)
!440 = !DILocation(line: 133, column: 5, scope: !437)
!441 = !DILocation(line: 134, column: 5, scope: !437)
!442 = !DILocation(line: 135, column: 5, scope: !437)
!443 = !DILocation(line: 136, column: 1, scope: !437)
!444 = distinct !DISubprogram(name: "init", scope: !425, file: !425, line: 22, type: !193, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !195)
!445 = !DILocation(line: 24, column: 5, scope: !444)
!446 = !DILocation(line: 25, column: 1, scope: !444)
!447 = distinct !DISubprogram(name: "launch_threads", scope: !34, file: !34, line: 119, type: !448, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!448 = !DISubroutineType(types: !449)
!449 = !{null, !14, !45}
!450 = !DILocalVariable(name: "thread_count", arg: 1, scope: !447, file: !34, line: 119, type: !14)
!451 = !DILocation(line: 119, column: 24, scope: !447)
!452 = !DILocalVariable(name: "fun", arg: 2, scope: !447, file: !34, line: 119, type: !45)
!453 = !DILocation(line: 119, column: 51, scope: !447)
!454 = !DILocalVariable(name: "threads", scope: !447, file: !34, line: 121, type: !32)
!455 = !DILocation(line: 121, column: 17, scope: !447)
!456 = !DILocation(line: 121, column: 55, scope: !447)
!457 = !DILocation(line: 121, column: 53, scope: !447)
!458 = !DILocation(line: 121, column: 27, scope: !447)
!459 = !DILocation(line: 123, column: 20, scope: !447)
!460 = !DILocation(line: 123, column: 29, scope: !447)
!461 = !DILocation(line: 123, column: 43, scope: !447)
!462 = !DILocation(line: 123, column: 5, scope: !447)
!463 = !DILocation(line: 125, column: 19, scope: !447)
!464 = !DILocation(line: 125, column: 28, scope: !447)
!465 = !DILocation(line: 125, column: 5, scope: !447)
!466 = !DILocation(line: 127, column: 10, scope: !447)
!467 = !DILocation(line: 127, column: 5, scope: !447)
!468 = !DILocation(line: 128, column: 1, scope: !447)
!469 = distinct !DISubprogram(name: "fini", scope: !425, file: !425, line: 27, type: !193, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !195)
!470 = !DILocation(line: 29, column: 5, scope: !469)
!471 = !DILocation(line: 30, column: 1, scope: !469)
!472 = distinct !DISubprogram(name: "imap_reg", scope: !68, file: !68, line: 177, type: !272, scopeLine: 178, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!473 = !DILocalVariable(name: "tid", arg: 1, scope: !472, file: !68, line: 177, type: !14)
!474 = !DILocation(line: 177, column: 18, scope: !472)
!475 = !DILocation(line: 179, column: 5, scope: !472)
!476 = !DILocation(line: 179, column: 5, scope: !477)
!477 = distinct !DILexicalBlock(scope: !472, file: !68, line: 179, column: 5)
!478 = !DILocation(line: 179, column: 5, scope: !479)
!479 = distinct !DILexicalBlock(scope: !477, file: !68, line: 179, column: 5)
!480 = !DILocation(line: 179, column: 5, scope: !481)
!481 = distinct !DILexicalBlock(scope: !479, file: !68, line: 179, column: 5)
!482 = !DILocation(line: 180, column: 5, scope: !472)
!483 = !DILocation(line: 181, column: 1, scope: !472)
!484 = distinct !DISubprogram(name: "imap_dereg", scope: !68, file: !68, line: 184, type: !272, scopeLine: 185, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!485 = !DILocalVariable(name: "tid", arg: 1, scope: !484, file: !68, line: 184, type: !14)
!486 = !DILocation(line: 184, column: 20, scope: !484)
!487 = !DILocation(line: 186, column: 5, scope: !484)
!488 = !DILocation(line: 186, column: 5, scope: !489)
!489 = distinct !DILexicalBlock(scope: !484, file: !68, line: 186, column: 5)
!490 = !DILocation(line: 186, column: 5, scope: !491)
!491 = distinct !DILexicalBlock(scope: !489, file: !68, line: 186, column: 5)
!492 = !DILocation(line: 186, column: 5, scope: !493)
!493 = distinct !DILexicalBlock(scope: !491, file: !68, line: 186, column: 5)
!494 = !DILocation(line: 187, column: 5, scope: !484)
!495 = !DILocation(line: 188, column: 1, scope: !484)
!496 = distinct !DISubprogram(name: "imap_init", scope: !68, file: !68, line: 114, type: !193, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!497 = !DILocalVariable(name: "sz", scope: !496, file: !68, line: 116, type: !14)
!498 = !DILocation(line: 116, column: 13, scope: !496)
!499 = !DILocation(line: 116, column: 20, scope: !496)
!500 = !DILocalVariable(name: "g_buff", scope: !496, file: !68, line: 117, type: !22)
!501 = !DILocation(line: 117, column: 11, scope: !496)
!502 = !DILocation(line: 117, column: 27, scope: !496)
!503 = !DILocation(line: 117, column: 20, scope: !496)
!504 = !DILocation(line: 119, column: 33, scope: !496)
!505 = !DILocation(line: 119, column: 5, scope: !496)
!506 = !DILocalVariable(name: "i", scope: !507, file: !68, line: 122, type: !14)
!507 = distinct !DILexicalBlock(scope: !496, file: !68, line: 122, column: 5)
!508 = !DILocation(line: 122, column: 18, scope: !507)
!509 = !DILocation(line: 122, column: 10, scope: !507)
!510 = !DILocation(line: 122, column: 25, scope: !511)
!511 = distinct !DILexicalBlock(scope: !507, file: !68, line: 122, column: 5)
!512 = !DILocation(line: 122, column: 27, scope: !511)
!513 = !DILocation(line: 122, column: 5, scope: !507)
!514 = !DILocation(line: 123, column: 27, scope: !515)
!515 = distinct !DILexicalBlock(scope: !511, file: !68, line: 122, column: 43)
!516 = !DILocation(line: 123, column: 21, scope: !515)
!517 = !DILocation(line: 123, column: 9, scope: !515)
!518 = !DILocation(line: 124, column: 27, scope: !515)
!519 = !DILocation(line: 124, column: 21, scope: !515)
!520 = !DILocation(line: 124, column: 9, scope: !515)
!521 = !DILocation(line: 125, column: 5, scope: !515)
!522 = !DILocation(line: 122, column: 39, scope: !511)
!523 = !DILocation(line: 122, column: 5, scope: !511)
!524 = distinct !{!524, !513, !525, !221}
!525 = !DILocation(line: 125, column: 5, scope: !507)
!526 = !DILocation(line: 126, column: 1, scope: !496)
!527 = distinct !DISubprogram(name: "imap_destroy", scope: !68, file: !68, line: 128, type: !193, scopeLine: 129, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!528 = !DILocation(line: 130, column: 5, scope: !527)
!529 = !DILocalVariable(name: "i", scope: !530, file: !68, line: 131, type: !14)
!530 = distinct !DILexicalBlock(scope: !527, file: !68, line: 131, column: 5)
!531 = !DILocation(line: 131, column: 18, scope: !530)
!532 = !DILocation(line: 131, column: 10, scope: !530)
!533 = !DILocation(line: 131, column: 25, scope: !534)
!534 = distinct !DILexicalBlock(scope: !530, file: !68, line: 131, column: 5)
!535 = !DILocation(line: 131, column: 27, scope: !534)
!536 = !DILocation(line: 131, column: 5, scope: !530)
!537 = !DILocation(line: 132, column: 30, scope: !538)
!538 = distinct !DILexicalBlock(scope: !534, file: !68, line: 131, column: 43)
!539 = !DILocation(line: 132, column: 24, scope: !538)
!540 = !DILocation(line: 132, column: 9, scope: !538)
!541 = !DILocation(line: 133, column: 30, scope: !538)
!542 = !DILocation(line: 133, column: 24, scope: !538)
!543 = !DILocation(line: 133, column: 9, scope: !538)
!544 = !DILocation(line: 134, column: 5, scope: !538)
!545 = !DILocation(line: 131, column: 39, scope: !534)
!546 = !DILocation(line: 131, column: 5, scope: !534)
!547 = distinct !{!547, !536, !548, !221}
!548 = !DILocation(line: 134, column: 5, scope: !530)
!549 = !DILocation(line: 135, column: 5, scope: !527)
!550 = !DILocation(line: 136, column: 10, scope: !527)
!551 = !DILocation(line: 136, column: 5, scope: !527)
!552 = !DILocation(line: 137, column: 12, scope: !527)
!553 = !DILocation(line: 138, column: 1, scope: !527)
!554 = distinct !DISubprogram(name: "main", scope: !425, file: !425, line: 33, type: !555, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !195)
!555 = !DISubroutineType(types: !556)
!556 = !{!126}
!557 = !DILocation(line: 35, column: 5, scope: !554)
!558 = !DILocation(line: 36, column: 5, scope: !554)
!559 = distinct !DISubprogram(name: "vsimpleht_add", scope: !6, file: !6, line: 241, type: !560, scopeLine: 242, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!560 = !DISubroutineType(types: !561)
!561 = !{!562, !563, !19, !22}
!562 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_ret_t", file: !6, line: 106, baseType: !5)
!563 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!564 = !DILocalVariable(name: "tbl", arg: 1, scope: !559, file: !6, line: 241, type: !563)
!565 = !DILocation(line: 241, column: 28, scope: !559)
!566 = !DILocalVariable(name: "key", arg: 2, scope: !559, file: !6, line: 241, type: !19)
!567 = !DILocation(line: 241, column: 44, scope: !559)
!568 = !DILocalVariable(name: "value", arg: 3, scope: !559, file: !6, line: 241, type: !22)
!569 = !DILocation(line: 241, column: 55, scope: !559)
!570 = !DILocation(line: 243, column: 5, scope: !571)
!571 = distinct !DILexicalBlock(scope: !572, file: !6, line: 243, column: 5)
!572 = distinct !DILexicalBlock(scope: !559, file: !6, line: 243, column: 5)
!573 = !DILocation(line: 243, column: 5, scope: !572)
!574 = !DILocation(line: 244, column: 5, scope: !575)
!575 = distinct !DILexicalBlock(scope: !576, file: !6, line: 244, column: 5)
!576 = distinct !DILexicalBlock(scope: !559, file: !6, line: 244, column: 5)
!577 = !DILocation(line: 244, column: 5, scope: !576)
!578 = !DILocation(line: 245, column: 38, scope: !559)
!579 = !DILocation(line: 245, column: 5, scope: !559)
!580 = !DILocation(line: 246, column: 27, scope: !559)
!581 = !DILocation(line: 246, column: 32, scope: !559)
!582 = !DILocation(line: 246, column: 37, scope: !559)
!583 = !DILocation(line: 246, column: 12, scope: !559)
!584 = !DILocation(line: 246, column: 5, scope: !559)
!585 = distinct !DISubprogram(name: "trace_add", scope: !165, file: !165, line: 153, type: !586, scopeLine: 154, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!586 = !DISubroutineType(types: !587)
!587 = !{null, !588, !19}
!588 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !164, size: 64)
!589 = !DILocalVariable(name: "trace", arg: 1, scope: !585, file: !165, line: 153, type: !588)
!590 = !DILocation(line: 153, column: 20, scope: !585)
!591 = !DILocalVariable(name: "key", arg: 2, scope: !585, file: !165, line: 153, type: !19)
!592 = !DILocation(line: 153, column: 38, scope: !585)
!593 = !DILocation(line: 155, column: 5, scope: !594)
!594 = distinct !DILexicalBlock(scope: !595, file: !165, line: 155, column: 5)
!595 = distinct !DILexicalBlock(scope: !585, file: !165, line: 155, column: 5)
!596 = !DILocation(line: 155, column: 5, scope: !595)
!597 = !DILocation(line: 156, column: 5, scope: !598)
!598 = distinct !DILexicalBlock(scope: !599, file: !165, line: 156, column: 5)
!599 = distinct !DILexicalBlock(scope: !585, file: !165, line: 156, column: 5)
!600 = !DILocation(line: 156, column: 5, scope: !599)
!601 = !DILocation(line: 157, column: 35, scope: !585)
!602 = !DILocation(line: 157, column: 42, scope: !585)
!603 = !DILocation(line: 157, column: 5, scope: !585)
!604 = !DILocation(line: 158, column: 1, scope: !585)
!605 = distinct !DISubprogram(name: "_vsimpleht_give_cleanup_a_chance", scope: !6, file: !6, line: 479, type: !606, scopeLine: 480, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!606 = !DISubroutineType(types: !607)
!607 = !{null, !563}
!608 = !DILocalVariable(name: "tbl", arg: 1, scope: !605, file: !6, line: 479, type: !563)
!609 = !DILocation(line: 479, column: 47, scope: !605)
!610 = !DILocation(line: 484, column: 36, scope: !611)
!611 = distinct !DILexicalBlock(scope: !605, file: !6, line: 484, column: 9)
!612 = !DILocation(line: 484, column: 41, scope: !611)
!613 = !DILocation(line: 484, column: 9, scope: !611)
!614 = !DILocation(line: 484, column: 9, scope: !605)
!615 = !DILocation(line: 485, column: 9, scope: !616)
!616 = distinct !DILexicalBlock(scope: !617, file: !6, line: 485, column: 9)
!617 = distinct !DILexicalBlock(scope: !618, file: !6, line: 485, column: 9)
!618 = distinct !DILexicalBlock(scope: !611, file: !6, line: 484, column: 48)
!619 = !DILocation(line: 485, column: 9, scope: !617)
!620 = !DILocation(line: 488, column: 30, scope: !618)
!621 = !DILocation(line: 488, column: 35, scope: !618)
!622 = !DILocation(line: 488, column: 9, scope: !618)
!623 = !DILocation(line: 489, column: 30, scope: !618)
!624 = !DILocation(line: 489, column: 35, scope: !618)
!625 = !DILocation(line: 489, column: 9, scope: !618)
!626 = !DILocation(line: 490, column: 5, scope: !618)
!627 = !DILocation(line: 492, column: 1, scope: !605)
!628 = distinct !DISubprogram(name: "_vsimpleht_add", scope: !6, file: !6, line: 416, type: !560, scopeLine: 417, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!629 = !DILocalVariable(name: "tbl", arg: 1, scope: !628, file: !6, line: 416, type: !563)
!630 = !DILocation(line: 416, column: 29, scope: !628)
!631 = !DILocalVariable(name: "key", arg: 2, scope: !628, file: !6, line: 416, type: !19)
!632 = !DILocation(line: 416, column: 45, scope: !628)
!633 = !DILocalVariable(name: "value", arg: 3, scope: !628, file: !6, line: 416, type: !22)
!634 = !DILocation(line: 416, column: 56, scope: !628)
!635 = !DILocalVariable(name: "index", scope: !628, file: !6, line: 418, type: !14)
!636 = !DILocation(line: 418, column: 13, scope: !628)
!637 = !DILocalVariable(name: "probed_key", scope: !628, file: !6, line: 419, type: !19)
!638 = !DILocation(line: 419, column: 16, scope: !628)
!639 = !DILocalVariable(name: "val", scope: !628, file: !6, line: 420, type: !22)
!640 = !DILocation(line: 420, column: 11, scope: !628)
!641 = !DILocalVariable(name: "cnt", scope: !628, file: !6, line: 421, type: !14)
!642 = !DILocation(line: 421, column: 13, scope: !628)
!643 = !DILocation(line: 423, column: 5, scope: !644)
!644 = distinct !DILexicalBlock(scope: !645, file: !6, line: 423, column: 5)
!645 = distinct !DILexicalBlock(scope: !628, file: !6, line: 423, column: 5)
!646 = !DILocation(line: 423, column: 5, scope: !645)
!647 = !DILocation(line: 424, column: 5, scope: !648)
!648 = distinct !DILexicalBlock(scope: !649, file: !6, line: 424, column: 5)
!649 = distinct !DILexicalBlock(scope: !628, file: !6, line: 424, column: 5)
!650 = !DILocation(line: 424, column: 5, scope: !649)
!651 = !DILocation(line: 428, column: 18, scope: !652)
!652 = distinct !DILexicalBlock(scope: !628, file: !6, line: 428, column: 5)
!653 = !DILocation(line: 428, column: 23, scope: !652)
!654 = !DILocation(line: 428, column: 32, scope: !652)
!655 = !DILocation(line: 428, column: 16, scope: !652)
!656 = !DILocation(line: 428, column: 10, scope: !652)
!657 = !DILocation(line: 428, column: 38, scope: !658)
!658 = distinct !DILexicalBlock(scope: !652, file: !6, line: 428, column: 5)
!659 = !DILocation(line: 428, column: 44, scope: !658)
!660 = !DILocation(line: 428, column: 49, scope: !658)
!661 = !DILocation(line: 428, column: 42, scope: !658)
!662 = !DILocation(line: 428, column: 5, scope: !652)
!663 = !DILocation(line: 430, column: 18, scope: !664)
!664 = distinct !DILexicalBlock(scope: !658, file: !6, line: 428, column: 75)
!665 = !DILocation(line: 430, column: 23, scope: !664)
!666 = !DILocation(line: 430, column: 32, scope: !664)
!667 = !DILocation(line: 430, column: 15, scope: !664)
!668 = !DILocation(line: 431, column: 9, scope: !669)
!669 = distinct !DILexicalBlock(scope: !670, file: !6, line: 431, column: 9)
!670 = distinct !DILexicalBlock(scope: !664, file: !6, line: 431, column: 9)
!671 = !DILocation(line: 431, column: 9, scope: !670)
!672 = !DILocation(line: 433, column: 51, scope: !664)
!673 = !DILocation(line: 433, column: 56, scope: !664)
!674 = !DILocation(line: 433, column: 64, scope: !664)
!675 = !DILocation(line: 433, column: 71, scope: !664)
!676 = !DILocation(line: 433, column: 34, scope: !664)
!677 = !DILocation(line: 433, column: 22, scope: !664)
!678 = !DILocation(line: 433, column: 20, scope: !664)
!679 = !DILocation(line: 438, column: 13, scope: !680)
!680 = distinct !DILexicalBlock(scope: !664, file: !6, line: 438, column: 13)
!681 = !DILocation(line: 438, column: 24, scope: !680)
!682 = !DILocation(line: 438, column: 13, scope: !664)
!683 = !DILocation(line: 440, column: 18, scope: !684)
!684 = distinct !DILexicalBlock(scope: !680, file: !6, line: 438, column: 30)
!685 = !DILocation(line: 440, column: 23, scope: !684)
!686 = !DILocation(line: 440, column: 31, scope: !684)
!687 = !DILocation(line: 440, column: 38, scope: !684)
!688 = !DILocation(line: 440, column: 57, scope: !684)
!689 = !DILocation(line: 440, column: 49, scope: !684)
!690 = !DILocation(line: 439, column: 38, scope: !684)
!691 = !DILocation(line: 439, column: 26, scope: !684)
!692 = !DILocation(line: 439, column: 24, scope: !684)
!693 = !DILocation(line: 442, column: 17, scope: !694)
!694 = distinct !DILexicalBlock(scope: !684, file: !6, line: 442, column: 17)
!695 = !DILocation(line: 442, column: 28, scope: !694)
!696 = !DILocation(line: 442, column: 33, scope: !694)
!697 = !DILocation(line: 442, column: 36, scope: !694)
!698 = !DILocation(line: 442, column: 41, scope: !694)
!699 = !DILocation(line: 442, column: 49, scope: !694)
!700 = !DILocation(line: 442, column: 54, scope: !694)
!701 = !DILocation(line: 442, column: 66, scope: !694)
!702 = !DILocation(line: 442, column: 17, scope: !684)
!703 = !DILocation(line: 443, column: 17, scope: !704)
!704 = distinct !DILexicalBlock(scope: !694, file: !6, line: 442, column: 72)
!705 = !DILocation(line: 445, column: 9, scope: !684)
!706 = !DILocation(line: 445, column: 20, scope: !707)
!707 = distinct !DILexicalBlock(scope: !680, file: !6, line: 445, column: 20)
!708 = !DILocation(line: 445, column: 25, scope: !707)
!709 = !DILocation(line: 445, column: 33, scope: !707)
!710 = !DILocation(line: 445, column: 38, scope: !707)
!711 = !DILocation(line: 445, column: 50, scope: !707)
!712 = !DILocation(line: 445, column: 20, scope: !680)
!713 = !DILocation(line: 448, column: 13, scope: !714)
!714 = distinct !DILexicalBlock(scope: !707, file: !6, line: 445, column: 56)
!715 = !DILocation(line: 450, column: 9, scope: !716)
!716 = distinct !DILexicalBlock(scope: !717, file: !6, line: 450, column: 9)
!717 = distinct !DILexicalBlock(scope: !664, file: !6, line: 450, column: 9)
!718 = !DILocation(line: 450, column: 9, scope: !717)
!719 = !DILocation(line: 465, column: 35, scope: !664)
!720 = !DILocation(line: 465, column: 40, scope: !664)
!721 = !DILocation(line: 465, column: 48, scope: !664)
!722 = !DILocation(line: 465, column: 55, scope: !664)
!723 = !DILocation(line: 465, column: 68, scope: !664)
!724 = !DILocation(line: 465, column: 15, scope: !664)
!725 = !DILocation(line: 465, column: 13, scope: !664)
!726 = !DILocation(line: 466, column: 17, scope: !664)
!727 = !DILocation(line: 466, column: 21, scope: !664)
!728 = !DILocation(line: 466, column: 16, scope: !664)
!729 = !DILocation(line: 466, column: 9, scope: !664)
!730 = !DILocation(line: 428, column: 62, scope: !658)
!731 = !DILocation(line: 428, column: 71, scope: !658)
!732 = !DILocation(line: 428, column: 5, scope: !658)
!733 = distinct !{!733, !662, !734, !221}
!734 = !DILocation(line: 467, column: 5, scope: !652)
!735 = !DILocation(line: 468, column: 5, scope: !628)
!736 = !DILocation(line: 469, column: 1, scope: !628)
!737 = distinct !DISubprogram(name: "rwlock_acquired_by_writer", scope: !113, file: !113, line: 99, type: !738, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!738 = !DISubroutineType(types: !739)
!739 = !{!42, !740}
!740 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!741 = !DILocalVariable(name: "l", arg: 1, scope: !737, file: !113, line: 99, type: !740)
!742 = !DILocation(line: 99, column: 37, scope: !737)
!743 = !DILocation(line: 101, column: 31, scope: !737)
!744 = !DILocation(line: 101, column: 34, scope: !737)
!745 = !DILocation(line: 101, column: 12, scope: !737)
!746 = !DILocation(line: 101, column: 49, scope: !737)
!747 = !DILocation(line: 101, column: 5, scope: !737)
!748 = distinct !DISubprogram(name: "rwlock_acquired_by_readers", scope: !113, file: !113, line: 105, type: !738, scopeLine: 106, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!749 = !DILocalVariable(name: "l", arg: 1, scope: !748, file: !113, line: 105, type: !740)
!750 = !DILocation(line: 105, column: 38, scope: !748)
!751 = !DILocation(line: 107, column: 5, scope: !748)
!752 = !DILocation(line: 107, column: 5, scope: !753)
!753 = distinct !DILexicalBlock(scope: !748, file: !113, line: 107, column: 5)
!754 = !DILocation(line: 107, column: 5, scope: !755)
!755 = distinct !DILexicalBlock(scope: !753, file: !113, line: 107, column: 5)
!756 = !DILocation(line: 107, column: 5, scope: !757)
!757 = distinct !DILexicalBlock(scope: !755, file: !113, line: 107, column: 5)
!758 = !DILocation(line: 108, column: 5, scope: !748)
!759 = distinct !DISubprogram(name: "rwlock_read_release", scope: !113, file: !113, line: 82, type: !760, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!760 = !DISubroutineType(types: !761)
!761 = !{null, !740}
!762 = !DILocalVariable(name: "l", arg: 1, scope: !759, file: !113, line: 82, type: !740)
!763 = !DILocation(line: 82, column: 31, scope: !759)
!764 = !DILocalVariable(name: "idx", scope: !759, file: !113, line: 84, type: !29)
!765 = !DILocation(line: 84, column: 15, scope: !759)
!766 = !DILocation(line: 84, column: 37, scope: !759)
!767 = !DILocation(line: 84, column: 21, scope: !759)
!768 = !DILocation(line: 85, column: 27, scope: !759)
!769 = !DILocation(line: 85, column: 30, scope: !759)
!770 = !DILocation(line: 85, column: 35, scope: !759)
!771 = !DILocation(line: 85, column: 5, scope: !759)
!772 = !DILocation(line: 86, column: 1, scope: !759)
!773 = distinct !DISubprogram(name: "rwlock_read_acquire", scope: !113, file: !113, line: 71, type: !760, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!774 = !DILocalVariable(name: "l", arg: 1, scope: !773, file: !113, line: 71, type: !740)
!775 = !DILocation(line: 71, column: 31, scope: !773)
!776 = !DILocalVariable(name: "idx", scope: !773, file: !113, line: 73, type: !29)
!777 = !DILocation(line: 73, column: 15, scope: !773)
!778 = !DILocation(line: 73, column: 37, scope: !773)
!779 = !DILocation(line: 73, column: 21, scope: !773)
!780 = !DILocation(line: 74, column: 25, scope: !773)
!781 = !DILocation(line: 74, column: 28, scope: !773)
!782 = !DILocation(line: 74, column: 33, scope: !773)
!783 = !DILocation(line: 74, column: 5, scope: !773)
!784 = !DILocation(line: 75, column: 1, scope: !773)
!785 = distinct !DISubprogram(name: "vatomic8_read_rlx", scope: !786, file: !786, line: 109, type: !787, scopeLine: 110, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!786 = !DIFile(filename: "vatomic/include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "0c3ec6df2f26018f35fe6ca81ab8f3c9")
!787 = !DISubroutineType(types: !788)
!788 = !{!23, !789}
!789 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !790, size: 64)
!790 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !152)
!791 = !DILocalVariable(name: "a", arg: 1, scope: !785, file: !786, line: 109, type: !789)
!792 = !DILocation(line: 109, column: 37, scope: !785)
!793 = !DILocation(line: 111, column: 5, scope: !785)
!794 = !{i64 2148224491}
!795 = !DILocalVariable(name: "tmp", scope: !785, file: !786, line: 112, type: !23)
!796 = !DILocation(line: 112, column: 14, scope: !785)
!797 = !DILocation(line: 112, column: 47, scope: !785)
!798 = !DILocation(line: 112, column: 50, scope: !785)
!799 = !DILocation(line: 112, column: 30, scope: !785)
!800 = !DILocation(line: 113, column: 5, scope: !785)
!801 = !{i64 2148224531}
!802 = !DILocation(line: 114, column: 12, scope: !785)
!803 = !DILocation(line: 114, column: 5, scope: !785)
!804 = distinct !DISubprogram(name: "_rwlock_get_tid", scope: !113, file: !113, line: 89, type: !805, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!805 = !DISubroutineType(types: !806)
!806 = !{!29, !740}
!807 = !DILocalVariable(name: "l", arg: 1, scope: !804, file: !113, line: 89, type: !740)
!808 = !DILocation(line: 89, column: 27, scope: !804)
!809 = !DILocation(line: 91, column: 9, scope: !810)
!810 = distinct !DILexicalBlock(scope: !804, file: !113, line: 91, column: 9)
!811 = !DILocation(line: 91, column: 15, scope: !810)
!812 = !DILocation(line: 91, column: 9, scope: !804)
!813 = !DILocation(line: 92, column: 36, scope: !814)
!814 = distinct !DILexicalBlock(scope: !810, file: !113, line: 91, column: 38)
!815 = !DILocation(line: 92, column: 39, scope: !814)
!816 = !DILocation(line: 92, column: 17, scope: !814)
!817 = !DILocation(line: 92, column: 15, scope: !814)
!818 = !DILocation(line: 93, column: 9, scope: !819)
!819 = distinct !DILexicalBlock(scope: !820, file: !113, line: 93, column: 9)
!820 = distinct !DILexicalBlock(scope: !814, file: !113, line: 93, column: 9)
!821 = !DILocation(line: 93, column: 9, scope: !820)
!822 = !DILocation(line: 94, column: 5, scope: !814)
!823 = !DILocation(line: 95, column: 12, scope: !804)
!824 = !DILocation(line: 95, column: 5, scope: !804)
!825 = distinct !DISubprogram(name: "vatomic32_get_inc", scope: !826, file: !826, line: 2484, type: !827, scopeLine: 2485, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!826 = !DIFile(filename: "vatomic/include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "ff273838f95062d7181b3cf355a65f2b")
!827 = !DISubroutineType(types: !828)
!828 = !{!29, !829}
!829 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !157, size: 64)
!830 = !DILocalVariable(name: "a", arg: 1, scope: !825, file: !826, line: 2484, type: !829)
!831 = !DILocation(line: 2484, column: 32, scope: !825)
!832 = !DILocation(line: 2486, column: 30, scope: !825)
!833 = !DILocation(line: 2486, column: 12, scope: !825)
!834 = !DILocation(line: 2486, column: 5, scope: !825)
!835 = distinct !DISubprogram(name: "vatomic32_get_add", scope: !786, file: !786, line: 2351, type: !836, scopeLine: 2352, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!836 = !DISubroutineType(types: !837)
!837 = !{!29, !829, !29}
!838 = !DILocalVariable(name: "a", arg: 1, scope: !835, file: !786, line: 2351, type: !829)
!839 = !DILocation(line: 2351, column: 32, scope: !835)
!840 = !DILocalVariable(name: "v", arg: 2, scope: !835, file: !786, line: 2351, type: !29)
!841 = !DILocation(line: 2351, column: 45, scope: !835)
!842 = !DILocation(line: 2353, column: 5, scope: !835)
!843 = !{i64 2148236239}
!844 = !DILocalVariable(name: "tmp", scope: !835, file: !786, line: 2354, type: !29)
!845 = !DILocation(line: 2354, column: 15, scope: !835)
!846 = !DILocation(line: 2354, column: 52, scope: !835)
!847 = !DILocation(line: 2354, column: 55, scope: !835)
!848 = !DILocation(line: 2354, column: 59, scope: !835)
!849 = !DILocation(line: 2354, column: 32, scope: !835)
!850 = !DILocation(line: 2355, column: 5, scope: !835)
!851 = !{i64 2148236279}
!852 = !DILocation(line: 2356, column: 12, scope: !835)
!853 = !DILocation(line: 2356, column: 5, scope: !835)
!854 = distinct !DISubprogram(name: "vatomicptr_read", scope: !786, file: !786, line: 291, type: !855, scopeLine: 292, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!855 = !DISubroutineType(types: !856)
!856 = !{!22, !857}
!857 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !858, size: 64)
!858 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !79)
!859 = !DILocalVariable(name: "a", arg: 1, scope: !854, file: !786, line: 291, type: !857)
!860 = !DILocation(line: 291, column: 37, scope: !854)
!861 = !DILocation(line: 293, column: 5, scope: !854)
!862 = !{i64 2148225505}
!863 = !DILocalVariable(name: "tmp", scope: !854, file: !786, line: 294, type: !22)
!864 = !DILocation(line: 294, column: 11, scope: !854)
!865 = !DILocation(line: 294, column: 42, scope: !854)
!866 = !DILocation(line: 294, column: 45, scope: !854)
!867 = !DILocation(line: 294, column: 25, scope: !854)
!868 = !DILocation(line: 295, column: 5, scope: !854)
!869 = !{i64 2148225545}
!870 = !DILocation(line: 296, column: 12, scope: !854)
!871 = !DILocation(line: 296, column: 5, scope: !854)
!872 = distinct !DISubprogram(name: "vatomicptr_cmpxchg", scope: !786, file: !786, line: 1259, type: !873, scopeLine: 1260, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!873 = !DISubroutineType(types: !874)
!874 = !{!22, !875, !22, !22}
!875 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !79, size: 64)
!876 = !DILocalVariable(name: "a", arg: 1, scope: !872, file: !786, line: 1259, type: !875)
!877 = !DILocation(line: 1259, column: 34, scope: !872)
!878 = !DILocalVariable(name: "e", arg: 2, scope: !872, file: !786, line: 1259, type: !22)
!879 = !DILocation(line: 1259, column: 43, scope: !872)
!880 = !DILocalVariable(name: "v", arg: 3, scope: !872, file: !786, line: 1259, type: !22)
!881 = !DILocation(line: 1259, column: 52, scope: !872)
!882 = !DILocalVariable(name: "exp", scope: !872, file: !786, line: 1261, type: !22)
!883 = !DILocation(line: 1261, column: 11, scope: !872)
!884 = !DILocation(line: 1261, column: 25, scope: !872)
!885 = !DILocation(line: 1262, column: 5, scope: !872)
!886 = !{i64 2148230615}
!887 = !DILocation(line: 1263, column: 34, scope: !872)
!888 = !DILocation(line: 1263, column: 37, scope: !872)
!889 = !DILocation(line: 1263, column: 55, scope: !872)
!890 = !DILocation(line: 1263, column: 5, scope: !872)
!891 = !DILocation(line: 1265, column: 5, scope: !872)
!892 = !{i64 2148230657}
!893 = !DILocation(line: 1266, column: 12, scope: !872)
!894 = !DILocation(line: 1266, column: 5, scope: !872)
!895 = distinct !DISubprogram(name: "_trace_add_or_rem_occurrences", scope: !165, file: !165, line: 122, type: !896, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!896 = !DISubroutineType(types: !897)
!897 = !{null, !588, !19, !14, !42}
!898 = !DILocalVariable(name: "trace", arg: 1, scope: !895, file: !165, line: 122, type: !588)
!899 = !DILocation(line: 122, column: 40, scope: !895)
!900 = !DILocalVariable(name: "key", arg: 2, scope: !895, file: !165, line: 122, type: !19)
!901 = !DILocation(line: 122, column: 58, scope: !895)
!902 = !DILocalVariable(name: "count", arg: 3, scope: !895, file: !165, line: 122, type: !14)
!903 = !DILocation(line: 122, column: 71, scope: !895)
!904 = !DILocalVariable(name: "subtract", arg: 4, scope: !895, file: !165, line: 123, type: !42)
!905 = !DILocation(line: 123, column: 39, scope: !895)
!906 = !DILocalVariable(name: "idx", scope: !895, file: !165, line: 125, type: !14)
!907 = !DILocation(line: 125, column: 13, scope: !895)
!908 = !DILocalVariable(name: "found", scope: !895, file: !165, line: 126, type: !42)
!909 = !DILocation(line: 126, column: 13, scope: !895)
!910 = !DILocation(line: 128, column: 5, scope: !911)
!911 = distinct !DILexicalBlock(scope: !912, file: !165, line: 128, column: 5)
!912 = distinct !DILexicalBlock(scope: !895, file: !165, line: 128, column: 5)
!913 = !DILocation(line: 128, column: 5, scope: !912)
!914 = !DILocation(line: 129, column: 5, scope: !915)
!915 = distinct !DILexicalBlock(scope: !916, file: !165, line: 129, column: 5)
!916 = distinct !DILexicalBlock(scope: !895, file: !165, line: 129, column: 5)
!917 = !DILocation(line: 129, column: 5, scope: !916)
!918 = !DILocation(line: 131, column: 33, scope: !895)
!919 = !DILocation(line: 131, column: 40, scope: !895)
!920 = !DILocation(line: 131, column: 13, scope: !895)
!921 = !DILocation(line: 131, column: 11, scope: !895)
!922 = !DILocation(line: 133, column: 9, scope: !923)
!923 = distinct !DILexicalBlock(scope: !895, file: !165, line: 133, column: 9)
!924 = !DILocation(line: 133, column: 9, scope: !895)
!925 = !DILocation(line: 134, column: 9, scope: !926)
!926 = distinct !DILexicalBlock(scope: !927, file: !165, line: 134, column: 9)
!927 = distinct !DILexicalBlock(scope: !928, file: !165, line: 134, column: 9)
!928 = distinct !DILexicalBlock(scope: !923, file: !165, line: 133, column: 19)
!929 = !DILocation(line: 134, column: 9, scope: !927)
!930 = !DILocation(line: 135, column: 9, scope: !931)
!931 = distinct !DILexicalBlock(scope: !932, file: !165, line: 135, column: 9)
!932 = distinct !DILexicalBlock(scope: !928, file: !165, line: 135, column: 9)
!933 = !DILocation(line: 135, column: 9, scope: !932)
!934 = !DILocation(line: 136, column: 36, scope: !928)
!935 = !DILocation(line: 136, column: 9, scope: !928)
!936 = !DILocation(line: 136, column: 16, scope: !928)
!937 = !DILocation(line: 136, column: 22, scope: !928)
!938 = !DILocation(line: 136, column: 27, scope: !928)
!939 = !DILocation(line: 136, column: 33, scope: !928)
!940 = !DILocation(line: 137, column: 9, scope: !928)
!941 = !DILocation(line: 140, column: 10, scope: !942)
!942 = distinct !DILexicalBlock(scope: !895, file: !165, line: 140, column: 9)
!943 = !DILocation(line: 140, column: 9, scope: !895)
!944 = !DILocation(line: 141, column: 15, scope: !945)
!945 = distinct !DILexicalBlock(scope: !942, file: !165, line: 140, column: 17)
!946 = !DILocation(line: 141, column: 22, scope: !945)
!947 = !DILocation(line: 141, column: 25, scope: !945)
!948 = !DILocation(line: 141, column: 13, scope: !945)
!949 = !DILocation(line: 142, column: 13, scope: !950)
!950 = distinct !DILexicalBlock(scope: !945, file: !165, line: 142, column: 13)
!951 = !DILocation(line: 142, column: 20, scope: !950)
!952 = !DILocation(line: 142, column: 27, scope: !950)
!953 = !DILocation(line: 142, column: 17, scope: !950)
!954 = !DILocation(line: 142, column: 13, scope: !945)
!955 = !DILocation(line: 143, column: 26, scope: !956)
!956 = distinct !DILexicalBlock(scope: !950, file: !165, line: 142, column: 37)
!957 = !DILocation(line: 143, column: 13, scope: !956)
!958 = !DILocation(line: 144, column: 9, scope: !956)
!959 = !DILocation(line: 145, column: 35, scope: !945)
!960 = !DILocation(line: 145, column: 9, scope: !945)
!961 = !DILocation(line: 145, column: 16, scope: !945)
!962 = !DILocation(line: 145, column: 22, scope: !945)
!963 = !DILocation(line: 145, column: 27, scope: !945)
!964 = !DILocation(line: 145, column: 33, scope: !945)
!965 = !DILocation(line: 146, column: 35, scope: !945)
!966 = !DILocation(line: 146, column: 9, scope: !945)
!967 = !DILocation(line: 146, column: 16, scope: !945)
!968 = !DILocation(line: 146, column: 22, scope: !945)
!969 = !DILocation(line: 146, column: 27, scope: !945)
!970 = !DILocation(line: 146, column: 33, scope: !945)
!971 = !DILocation(line: 147, column: 5, scope: !945)
!972 = !DILocation(line: 148, column: 36, scope: !973)
!973 = distinct !DILexicalBlock(scope: !942, file: !165, line: 147, column: 12)
!974 = !DILocation(line: 148, column: 9, scope: !973)
!975 = !DILocation(line: 148, column: 16, scope: !973)
!976 = !DILocation(line: 148, column: 22, scope: !973)
!977 = !DILocation(line: 148, column: 27, scope: !973)
!978 = !DILocation(line: 148, column: 33, scope: !973)
!979 = !DILocation(line: 150, column: 1, scope: !895)
!980 = distinct !DISubprogram(name: "trace_find_unit_idx", scope: !165, file: !165, line: 107, type: !981, scopeLine: 108, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!981 = !DISubroutineType(types: !982)
!982 = !{!42, !588, !19, !983}
!983 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!984 = !DILocalVariable(name: "trace", arg: 1, scope: !980, file: !165, line: 107, type: !588)
!985 = !DILocation(line: 107, column: 30, scope: !980)
!986 = !DILocalVariable(name: "key", arg: 2, scope: !980, file: !165, line: 107, type: !19)
!987 = !DILocation(line: 107, column: 48, scope: !980)
!988 = !DILocalVariable(name: "out_idx", arg: 3, scope: !980, file: !165, line: 107, type: !983)
!989 = !DILocation(line: 107, column: 62, scope: !980)
!990 = !DILocalVariable(name: "i", scope: !980, file: !165, line: 109, type: !14)
!991 = !DILocation(line: 109, column: 13, scope: !980)
!992 = !DILocation(line: 110, column: 5, scope: !993)
!993 = distinct !DILexicalBlock(scope: !994, file: !165, line: 110, column: 5)
!994 = distinct !DILexicalBlock(scope: !980, file: !165, line: 110, column: 5)
!995 = !DILocation(line: 110, column: 5, scope: !994)
!996 = !DILocation(line: 111, column: 5, scope: !997)
!997 = distinct !DILexicalBlock(scope: !998, file: !165, line: 111, column: 5)
!998 = distinct !DILexicalBlock(scope: !980, file: !165, line: 111, column: 5)
!999 = !DILocation(line: 111, column: 5, scope: !998)
!1000 = !DILocation(line: 112, column: 12, scope: !1001)
!1001 = distinct !DILexicalBlock(scope: !980, file: !165, line: 112, column: 5)
!1002 = !DILocation(line: 112, column: 10, scope: !1001)
!1003 = !DILocation(line: 112, column: 17, scope: !1004)
!1004 = distinct !DILexicalBlock(scope: !1001, file: !165, line: 112, column: 5)
!1005 = !DILocation(line: 112, column: 21, scope: !1004)
!1006 = !DILocation(line: 112, column: 28, scope: !1004)
!1007 = !DILocation(line: 112, column: 19, scope: !1004)
!1008 = !DILocation(line: 112, column: 5, scope: !1001)
!1009 = !DILocation(line: 113, column: 13, scope: !1010)
!1010 = distinct !DILexicalBlock(scope: !1011, file: !165, line: 113, column: 13)
!1011 = distinct !DILexicalBlock(scope: !1004, file: !165, line: 112, column: 38)
!1012 = !DILocation(line: 113, column: 20, scope: !1010)
!1013 = !DILocation(line: 113, column: 26, scope: !1010)
!1014 = !DILocation(line: 113, column: 29, scope: !1010)
!1015 = !DILocation(line: 113, column: 36, scope: !1010)
!1016 = !DILocation(line: 113, column: 33, scope: !1010)
!1017 = !DILocation(line: 113, column: 13, scope: !1011)
!1018 = !DILocation(line: 114, column: 24, scope: !1019)
!1019 = distinct !DILexicalBlock(scope: !1010, file: !165, line: 113, column: 41)
!1020 = !DILocation(line: 114, column: 14, scope: !1019)
!1021 = !DILocation(line: 114, column: 22, scope: !1019)
!1022 = !DILocation(line: 115, column: 13, scope: !1019)
!1023 = !DILocation(line: 117, column: 5, scope: !1011)
!1024 = !DILocation(line: 112, column: 34, scope: !1004)
!1025 = !DILocation(line: 112, column: 5, scope: !1004)
!1026 = distinct !{!1026, !1008, !1027, !221}
!1027 = !DILocation(line: 117, column: 5, scope: !1001)
!1028 = !DILocation(line: 118, column: 5, scope: !980)
!1029 = !DILocation(line: 119, column: 1, scope: !980)
!1030 = distinct !DISubprogram(name: "trace_extend", scope: !165, file: !165, line: 73, type: !1031, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1031 = !DISubroutineType(types: !1032)
!1032 = !{null, !588}
!1033 = !DILocalVariable(name: "trace", arg: 1, scope: !1030, file: !165, line: 73, type: !588)
!1034 = !DILocation(line: 73, column: 23, scope: !1030)
!1035 = !DILocation(line: 75, column: 5, scope: !1036)
!1036 = distinct !DILexicalBlock(scope: !1037, file: !165, line: 75, column: 5)
!1037 = distinct !DILexicalBlock(scope: !1030, file: !165, line: 75, column: 5)
!1038 = !DILocation(line: 75, column: 5, scope: !1037)
!1039 = !DILocalVariable(name: "src_size", scope: !1030, file: !165, line: 77, type: !14)
!1040 = !DILocation(line: 77, column: 13, scope: !1030)
!1041 = !DILocation(line: 77, column: 24, scope: !1030)
!1042 = !DILocation(line: 77, column: 31, scope: !1030)
!1043 = !DILocation(line: 77, column: 40, scope: !1030)
!1044 = !DILocalVariable(name: "des_max", scope: !1030, file: !165, line: 78, type: !14)
!1045 = !DILocation(line: 78, column: 13, scope: !1030)
!1046 = !DILocation(line: 78, column: 24, scope: !1030)
!1047 = !DILocation(line: 78, column: 33, scope: !1030)
!1048 = !DILocalVariable(name: "src", scope: !1030, file: !165, line: 80, type: !169)
!1049 = !DILocation(line: 80, column: 19, scope: !1030)
!1050 = !DILocation(line: 80, column: 25, scope: !1030)
!1051 = !DILocation(line: 80, column: 32, scope: !1030)
!1052 = !DILocalVariable(name: "des", scope: !1030, file: !165, line: 81, type: !169)
!1053 = !DILocation(line: 81, column: 19, scope: !1030)
!1054 = !DILocation(line: 81, column: 32, scope: !1030)
!1055 = !DILocation(line: 81, column: 25, scope: !1030)
!1056 = !DILocation(line: 83, column: 9, scope: !1057)
!1057 = distinct !DILexicalBlock(scope: !1030, file: !165, line: 83, column: 9)
!1058 = !DILocation(line: 83, column: 9, scope: !1030)
!1059 = !DILocalVariable(name: "ret", scope: !1060, file: !165, line: 84, type: !126)
!1060 = distinct !DILexicalBlock(scope: !1057, file: !165, line: 83, column: 14)
!1061 = !DILocation(line: 84, column: 13, scope: !1060)
!1062 = !DILocation(line: 84, column: 28, scope: !1060)
!1063 = !DILocation(line: 84, column: 33, scope: !1060)
!1064 = !DILocation(line: 84, column: 42, scope: !1060)
!1065 = !DILocation(line: 84, column: 47, scope: !1060)
!1066 = !DILocation(line: 84, column: 19, scope: !1060)
!1067 = !DILocation(line: 85, column: 13, scope: !1068)
!1068 = distinct !DILexicalBlock(scope: !1060, file: !165, line: 85, column: 13)
!1069 = !DILocation(line: 85, column: 17, scope: !1068)
!1070 = !DILocation(line: 85, column: 13, scope: !1060)
!1071 = !DILocation(line: 86, column: 28, scope: !1072)
!1072 = distinct !DILexicalBlock(scope: !1068, file: !165, line: 85, column: 23)
!1073 = !DILocation(line: 86, column: 13, scope: !1072)
!1074 = !DILocation(line: 86, column: 20, scope: !1072)
!1075 = !DILocation(line: 86, column: 26, scope: !1072)
!1076 = !DILocation(line: 87, column: 13, scope: !1072)
!1077 = !DILocation(line: 87, column: 20, scope: !1072)
!1078 = !DILocation(line: 87, column: 29, scope: !1072)
!1079 = !DILocation(line: 88, column: 9, scope: !1072)
!1080 = !DILocation(line: 89, column: 13, scope: !1081)
!1081 = distinct !DILexicalBlock(scope: !1082, file: !165, line: 89, column: 13)
!1082 = distinct !DILexicalBlock(scope: !1083, file: !165, line: 89, column: 13)
!1083 = distinct !DILexicalBlock(scope: !1068, file: !165, line: 88, column: 16)
!1084 = !DILocation(line: 91, column: 14, scope: !1060)
!1085 = !DILocation(line: 91, column: 9, scope: !1060)
!1086 = !DILocation(line: 92, column: 5, scope: !1060)
!1087 = !DILocation(line: 93, column: 9, scope: !1088)
!1088 = distinct !DILexicalBlock(scope: !1089, file: !165, line: 93, column: 9)
!1089 = distinct !DILexicalBlock(scope: !1090, file: !165, line: 93, column: 9)
!1090 = distinct !DILexicalBlock(scope: !1057, file: !165, line: 92, column: 12)
!1091 = !DILocation(line: 95, column: 1, scope: !1030)
!1092 = distinct !DISubprogram(name: "vsimpleht_get", scope: !6, file: !6, line: 257, type: !1093, scopeLine: 258, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1093 = !DISubroutineType(types: !1094)
!1094 = !{!22, !563, !19}
!1095 = !DILocalVariable(name: "tbl", arg: 1, scope: !1092, file: !6, line: 257, type: !563)
!1096 = !DILocation(line: 257, column: 28, scope: !1092)
!1097 = !DILocalVariable(name: "key", arg: 2, scope: !1092, file: !6, line: 257, type: !19)
!1098 = !DILocation(line: 257, column: 44, scope: !1092)
!1099 = !DILocalVariable(name: "index", scope: !1092, file: !6, line: 259, type: !14)
!1100 = !DILocation(line: 259, column: 13, scope: !1092)
!1101 = !DILocalVariable(name: "probed_key", scope: !1092, file: !6, line: 260, type: !19)
!1102 = !DILocation(line: 260, column: 16, scope: !1092)
!1103 = !DILocation(line: 261, column: 38, scope: !1092)
!1104 = !DILocation(line: 261, column: 5, scope: !1092)
!1105 = !DILocation(line: 262, column: 18, scope: !1106)
!1106 = distinct !DILexicalBlock(scope: !1092, file: !6, line: 262, column: 5)
!1107 = !DILocation(line: 262, column: 23, scope: !1106)
!1108 = !DILocation(line: 262, column: 32, scope: !1106)
!1109 = !DILocation(line: 262, column: 16, scope: !1106)
!1110 = !DILocation(line: 262, column: 10, scope: !1106)
!1111 = !DILocation(line: 263, column: 18, scope: !1112)
!1112 = distinct !DILexicalBlock(scope: !1113, file: !6, line: 262, column: 48)
!1113 = distinct !DILexicalBlock(scope: !1106, file: !6, line: 262, column: 5)
!1114 = !DILocation(line: 263, column: 23, scope: !1112)
!1115 = !DILocation(line: 263, column: 32, scope: !1112)
!1116 = !DILocation(line: 263, column: 15, scope: !1112)
!1117 = !DILocation(line: 264, column: 9, scope: !1118)
!1118 = distinct !DILexicalBlock(scope: !1119, file: !6, line: 264, column: 9)
!1119 = distinct !DILexicalBlock(scope: !1112, file: !6, line: 264, column: 9)
!1120 = !DILocation(line: 264, column: 9, scope: !1119)
!1121 = !DILocation(line: 265, column: 51, scope: !1112)
!1122 = !DILocation(line: 265, column: 56, scope: !1112)
!1123 = !DILocation(line: 265, column: 64, scope: !1112)
!1124 = !DILocation(line: 265, column: 71, scope: !1112)
!1125 = !DILocation(line: 265, column: 34, scope: !1112)
!1126 = !DILocation(line: 265, column: 22, scope: !1112)
!1127 = !DILocation(line: 265, column: 20, scope: !1112)
!1128 = !DILocation(line: 266, column: 13, scope: !1129)
!1129 = distinct !DILexicalBlock(scope: !1112, file: !6, line: 266, column: 13)
!1130 = !DILocation(line: 266, column: 24, scope: !1129)
!1131 = !DILocation(line: 266, column: 13, scope: !1112)
!1132 = !DILocation(line: 267, column: 13, scope: !1133)
!1133 = distinct !DILexicalBlock(scope: !1129, file: !6, line: 266, column: 30)
!1134 = !DILocation(line: 268, column: 20, scope: !1135)
!1135 = distinct !DILexicalBlock(scope: !1129, file: !6, line: 268, column: 20)
!1136 = !DILocation(line: 268, column: 25, scope: !1135)
!1137 = !DILocation(line: 268, column: 33, scope: !1135)
!1138 = !DILocation(line: 268, column: 38, scope: !1135)
!1139 = !DILocation(line: 268, column: 50, scope: !1135)
!1140 = !DILocation(line: 268, column: 20, scope: !1129)
!1141 = !DILocation(line: 269, column: 41, scope: !1142)
!1142 = distinct !DILexicalBlock(scope: !1135, file: !6, line: 268, column: 56)
!1143 = !DILocation(line: 269, column: 46, scope: !1142)
!1144 = !DILocation(line: 269, column: 54, scope: !1142)
!1145 = !DILocation(line: 269, column: 61, scope: !1142)
!1146 = !DILocation(line: 269, column: 20, scope: !1142)
!1147 = !DILocation(line: 269, column: 13, scope: !1142)
!1148 = !DILocation(line: 271, column: 5, scope: !1112)
!1149 = !DILocation(line: 262, column: 44, scope: !1113)
!1150 = !DILocation(line: 262, column: 5, scope: !1113)
!1151 = distinct !{!1151, !1152, !1153}
!1152 = !DILocation(line: 262, column: 5, scope: !1106)
!1153 = !DILocation(line: 271, column: 5, scope: !1106)
!1154 = !DILocation(line: 272, column: 1, scope: !1092)
!1155 = distinct !DISubprogram(name: "vatomicptr_read_acq", scope: !786, file: !786, line: 305, type: !855, scopeLine: 306, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1156 = !DILocalVariable(name: "a", arg: 1, scope: !1155, file: !786, line: 305, type: !857)
!1157 = !DILocation(line: 305, column: 41, scope: !1155)
!1158 = !DILocation(line: 307, column: 5, scope: !1155)
!1159 = !{i64 2148225583}
!1160 = !DILocalVariable(name: "tmp", scope: !1155, file: !786, line: 308, type: !22)
!1161 = !DILocation(line: 308, column: 11, scope: !1155)
!1162 = !DILocation(line: 308, column: 42, scope: !1155)
!1163 = !DILocation(line: 308, column: 45, scope: !1155)
!1164 = !DILocation(line: 308, column: 25, scope: !1155)
!1165 = !DILocation(line: 309, column: 5, scope: !1155)
!1166 = !{i64 2148225623}
!1167 = !DILocation(line: 310, column: 12, scope: !1155)
!1168 = !DILocation(line: 310, column: 5, scope: !1155)
!1169 = distinct !DISubprogram(name: "create_threads", scope: !34, file: !34, line: 91, type: !1170, scopeLine: 93, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1170 = !DISubroutineType(types: !1171)
!1171 = !{null, !32, !14, !45, !42}
!1172 = !DILocalVariable(name: "threads", arg: 1, scope: !1169, file: !34, line: 91, type: !32)
!1173 = !DILocation(line: 91, column: 28, scope: !1169)
!1174 = !DILocalVariable(name: "num_threads", arg: 2, scope: !1169, file: !34, line: 91, type: !14)
!1175 = !DILocation(line: 91, column: 45, scope: !1169)
!1176 = !DILocalVariable(name: "fun", arg: 3, scope: !1169, file: !34, line: 91, type: !45)
!1177 = !DILocation(line: 91, column: 71, scope: !1169)
!1178 = !DILocalVariable(name: "bind", arg: 4, scope: !1169, file: !34, line: 92, type: !42)
!1179 = !DILocation(line: 92, column: 24, scope: !1169)
!1180 = !DILocalVariable(name: "i", scope: !1169, file: !34, line: 94, type: !14)
!1181 = !DILocation(line: 94, column: 13, scope: !1169)
!1182 = !DILocation(line: 95, column: 12, scope: !1183)
!1183 = distinct !DILexicalBlock(scope: !1169, file: !34, line: 95, column: 5)
!1184 = !DILocation(line: 95, column: 10, scope: !1183)
!1185 = !DILocation(line: 95, column: 17, scope: !1186)
!1186 = distinct !DILexicalBlock(scope: !1183, file: !34, line: 95, column: 5)
!1187 = !DILocation(line: 95, column: 21, scope: !1186)
!1188 = !DILocation(line: 95, column: 19, scope: !1186)
!1189 = !DILocation(line: 95, column: 5, scope: !1183)
!1190 = !DILocation(line: 96, column: 40, scope: !1191)
!1191 = distinct !DILexicalBlock(scope: !1186, file: !34, line: 95, column: 39)
!1192 = !DILocation(line: 96, column: 9, scope: !1191)
!1193 = !DILocation(line: 96, column: 17, scope: !1191)
!1194 = !DILocation(line: 96, column: 20, scope: !1191)
!1195 = !DILocation(line: 96, column: 38, scope: !1191)
!1196 = !DILocation(line: 97, column: 40, scope: !1191)
!1197 = !DILocation(line: 97, column: 9, scope: !1191)
!1198 = !DILocation(line: 97, column: 17, scope: !1191)
!1199 = !DILocation(line: 97, column: 20, scope: !1191)
!1200 = !DILocation(line: 97, column: 38, scope: !1191)
!1201 = !DILocation(line: 98, column: 40, scope: !1191)
!1202 = !DILocation(line: 98, column: 9, scope: !1191)
!1203 = !DILocation(line: 98, column: 17, scope: !1191)
!1204 = !DILocation(line: 98, column: 20, scope: !1191)
!1205 = !DILocation(line: 98, column: 38, scope: !1191)
!1206 = !DILocation(line: 99, column: 25, scope: !1191)
!1207 = !DILocation(line: 99, column: 33, scope: !1191)
!1208 = !DILocation(line: 99, column: 36, scope: !1191)
!1209 = !DILocation(line: 99, column: 55, scope: !1191)
!1210 = !DILocation(line: 99, column: 63, scope: !1191)
!1211 = !DILocation(line: 99, column: 54, scope: !1191)
!1212 = !DILocation(line: 99, column: 9, scope: !1191)
!1213 = !DILocation(line: 100, column: 5, scope: !1191)
!1214 = !DILocation(line: 95, column: 35, scope: !1186)
!1215 = !DILocation(line: 95, column: 5, scope: !1186)
!1216 = distinct !{!1216, !1189, !1217, !221}
!1217 = !DILocation(line: 100, column: 5, scope: !1183)
!1218 = !DILocation(line: 102, column: 1, scope: !1169)
!1219 = distinct !DISubprogram(name: "await_threads", scope: !34, file: !34, line: 105, type: !1220, scopeLine: 106, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1220 = !DISubroutineType(types: !1221)
!1221 = !{null, !32, !14}
!1222 = !DILocalVariable(name: "threads", arg: 1, scope: !1219, file: !34, line: 105, type: !32)
!1223 = !DILocation(line: 105, column: 27, scope: !1219)
!1224 = !DILocalVariable(name: "num_threads", arg: 2, scope: !1219, file: !34, line: 105, type: !14)
!1225 = !DILocation(line: 105, column: 44, scope: !1219)
!1226 = !DILocalVariable(name: "i", scope: !1219, file: !34, line: 107, type: !14)
!1227 = !DILocation(line: 107, column: 13, scope: !1219)
!1228 = !DILocation(line: 108, column: 12, scope: !1229)
!1229 = distinct !DILexicalBlock(scope: !1219, file: !34, line: 108, column: 5)
!1230 = !DILocation(line: 108, column: 10, scope: !1229)
!1231 = !DILocation(line: 108, column: 17, scope: !1232)
!1232 = distinct !DILexicalBlock(scope: !1229, file: !34, line: 108, column: 5)
!1233 = !DILocation(line: 108, column: 21, scope: !1232)
!1234 = !DILocation(line: 108, column: 19, scope: !1232)
!1235 = !DILocation(line: 108, column: 5, scope: !1229)
!1236 = !DILocation(line: 109, column: 22, scope: !1237)
!1237 = distinct !DILexicalBlock(scope: !1232, file: !34, line: 108, column: 39)
!1238 = !DILocation(line: 109, column: 30, scope: !1237)
!1239 = !DILocation(line: 109, column: 33, scope: !1237)
!1240 = !DILocation(line: 109, column: 9, scope: !1237)
!1241 = !DILocation(line: 110, column: 5, scope: !1237)
!1242 = !DILocation(line: 108, column: 35, scope: !1232)
!1243 = !DILocation(line: 108, column: 5, scope: !1232)
!1244 = distinct !{!1244, !1235, !1245, !221}
!1245 = !DILocation(line: 110, column: 5, scope: !1229)
!1246 = !DILocation(line: 111, column: 1, scope: !1219)
!1247 = distinct !DISubprogram(name: "common_run", scope: !34, file: !34, line: 51, type: !47, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1248 = !DILocalVariable(name: "args", arg: 1, scope: !1247, file: !34, line: 51, type: !22)
!1249 = !DILocation(line: 51, column: 18, scope: !1247)
!1250 = !DILocalVariable(name: "run_info", scope: !1247, file: !34, line: 53, type: !32)
!1251 = !DILocation(line: 53, column: 17, scope: !1247)
!1252 = !DILocation(line: 53, column: 42, scope: !1247)
!1253 = !DILocation(line: 53, column: 28, scope: !1247)
!1254 = !DILocation(line: 55, column: 9, scope: !1255)
!1255 = distinct !DILexicalBlock(scope: !1247, file: !34, line: 55, column: 9)
!1256 = !DILocation(line: 55, column: 19, scope: !1255)
!1257 = !DILocation(line: 55, column: 9, scope: !1247)
!1258 = !DILocation(line: 56, column: 26, scope: !1255)
!1259 = !DILocation(line: 56, column: 36, scope: !1255)
!1260 = !DILocation(line: 56, column: 9, scope: !1255)
!1261 = !DILocation(line: 60, column: 12, scope: !1247)
!1262 = !DILocation(line: 60, column: 22, scope: !1247)
!1263 = !DILocation(line: 60, column: 38, scope: !1247)
!1264 = !DILocation(line: 60, column: 48, scope: !1247)
!1265 = !DILocation(line: 60, column: 30, scope: !1247)
!1266 = !DILocation(line: 60, column: 5, scope: !1247)
!1267 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !34, file: !34, line: 69, type: !272, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1268 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !1267, file: !34, line: 69, type: !14)
!1269 = !DILocation(line: 69, column: 26, scope: !1267)
!1270 = !DILocation(line: 86, column: 5, scope: !1267)
!1271 = !DILocation(line: 86, column: 5, scope: !1272)
!1272 = distinct !DILexicalBlock(scope: !1267, file: !34, line: 86, column: 5)
!1273 = !DILocation(line: 86, column: 5, scope: !1274)
!1274 = distinct !DILexicalBlock(scope: !1272, file: !34, line: 86, column: 5)
!1275 = !DILocation(line: 86, column: 5, scope: !1276)
!1276 = distinct !DILexicalBlock(scope: !1274, file: !34, line: 86, column: 5)
!1277 = !DILocation(line: 88, column: 1, scope: !1267)
!1278 = distinct !DISubprogram(name: "vsimpleht_thread_register", scope: !6, file: !6, line: 200, type: !606, scopeLine: 201, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1279 = !DILocalVariable(name: "tbl", arg: 1, scope: !1278, file: !6, line: 200, type: !563)
!1280 = !DILocation(line: 200, column: 40, scope: !1278)
!1281 = !DILocation(line: 205, column: 26, scope: !1278)
!1282 = !DILocation(line: 205, column: 31, scope: !1278)
!1283 = !DILocation(line: 205, column: 5, scope: !1278)
!1284 = !DILocation(line: 207, column: 1, scope: !1278)
!1285 = distinct !DISubprogram(name: "vsimpleht_thread_deregister", scope: !6, file: !6, line: 217, type: !606, scopeLine: 218, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1286 = !DILocalVariable(name: "tbl", arg: 1, scope: !1285, file: !6, line: 217, type: !563)
!1287 = !DILocation(line: 217, column: 42, scope: !1285)
!1288 = !DILocation(line: 222, column: 26, scope: !1285)
!1289 = !DILocation(line: 222, column: 31, scope: !1285)
!1290 = !DILocation(line: 222, column: 5, scope: !1285)
!1291 = !DILocation(line: 224, column: 1, scope: !1285)
!1292 = distinct !DISubprogram(name: "vsimpleht_buff_size", scope: !6, file: !6, line: 126, type: !1293, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1293 = !DISubroutineType(types: !1294)
!1294 = !{!14, !14}
!1295 = !DILocalVariable(name: "capacity", arg: 1, scope: !1292, file: !6, line: 126, type: !14)
!1296 = !DILocation(line: 126, column: 29, scope: !1292)
!1297 = !DILocation(line: 128, column: 5, scope: !1298)
!1298 = distinct !DILexicalBlock(scope: !1299, file: !6, line: 128, column: 5)
!1299 = distinct !DILexicalBlock(scope: !1292, file: !6, line: 128, column: 5)
!1300 = !DILocation(line: 128, column: 5, scope: !1299)
!1301 = !DILocation(line: 129, column: 5, scope: !1302)
!1302 = distinct !DILexicalBlock(scope: !1303, file: !6, line: 129, column: 5)
!1303 = distinct !DILexicalBlock(scope: !1292, file: !6, line: 129, column: 5)
!1304 = !DILocation(line: 129, column: 5, scope: !1303)
!1305 = !DILocation(line: 130, column: 40, scope: !1292)
!1306 = !DILocation(line: 130, column: 38, scope: !1292)
!1307 = !DILocation(line: 130, column: 5, scope: !1292)
!1308 = distinct !DISubprogram(name: "vsimpleht_init", scope: !6, file: !6, line: 146, type: !1309, scopeLine: 149, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1309 = !DISubroutineType(types: !1310)
!1310 = !{null, !563, !22, !14, !86, !96, !101}
!1311 = !DILocalVariable(name: "tbl", arg: 1, scope: !1308, file: !6, line: 146, type: !563)
!1312 = !DILocation(line: 146, column: 29, scope: !1308)
!1313 = !DILocalVariable(name: "buff", arg: 2, scope: !1308, file: !6, line: 146, type: !22)
!1314 = !DILocation(line: 146, column: 40, scope: !1308)
!1315 = !DILocalVariable(name: "capacity", arg: 3, scope: !1308, file: !6, line: 146, type: !14)
!1316 = !DILocation(line: 146, column: 54, scope: !1308)
!1317 = !DILocalVariable(name: "cmp_fun", arg: 4, scope: !1308, file: !6, line: 147, type: !86)
!1318 = !DILocation(line: 147, column: 36, scope: !1308)
!1319 = !DILocalVariable(name: "hash_fun", arg: 5, scope: !1308, file: !6, line: 147, type: !96)
!1320 = !DILocation(line: 147, column: 66, scope: !1308)
!1321 = !DILocalVariable(name: "destroy_cb", arg: 6, scope: !1308, file: !6, line: 148, type: !101)
!1322 = !DILocation(line: 148, column: 42, scope: !1308)
!1323 = !DILocation(line: 150, column: 5, scope: !1324)
!1324 = distinct !DILexicalBlock(scope: !1325, file: !6, line: 150, column: 5)
!1325 = distinct !DILexicalBlock(scope: !1308, file: !6, line: 150, column: 5)
!1326 = !DILocation(line: 150, column: 5, scope: !1325)
!1327 = !DILocation(line: 151, column: 5, scope: !1328)
!1328 = distinct !DILexicalBlock(scope: !1329, file: !6, line: 151, column: 5)
!1329 = distinct !DILexicalBlock(scope: !1308, file: !6, line: 151, column: 5)
!1330 = !DILocation(line: 151, column: 5, scope: !1329)
!1331 = !DILocation(line: 152, column: 5, scope: !1332)
!1332 = distinct !DILexicalBlock(scope: !1333, file: !6, line: 152, column: 5)
!1333 = distinct !DILexicalBlock(scope: !1308, file: !6, line: 152, column: 5)
!1334 = !DILocation(line: 152, column: 5, scope: !1333)
!1335 = !DILocation(line: 153, column: 5, scope: !1336)
!1336 = distinct !DILexicalBlock(scope: !1337, file: !6, line: 153, column: 5)
!1337 = distinct !DILexicalBlock(scope: !1308, file: !6, line: 153, column: 5)
!1338 = !DILocation(line: 153, column: 5, scope: !1337)
!1339 = !DILocation(line: 155, column: 23, scope: !1308)
!1340 = !DILocation(line: 155, column: 5, scope: !1308)
!1341 = !DILocation(line: 155, column: 10, scope: !1308)
!1342 = !DILocation(line: 155, column: 21, scope: !1308)
!1343 = !DILocation(line: 156, column: 23, scope: !1308)
!1344 = !DILocation(line: 156, column: 5, scope: !1308)
!1345 = !DILocation(line: 156, column: 10, scope: !1308)
!1346 = !DILocation(line: 156, column: 21, scope: !1308)
!1347 = !DILocation(line: 157, column: 23, scope: !1308)
!1348 = !DILocation(line: 157, column: 5, scope: !1308)
!1349 = !DILocation(line: 157, column: 10, scope: !1308)
!1350 = !DILocation(line: 157, column: 21, scope: !1308)
!1351 = !DILocation(line: 158, column: 23, scope: !1308)
!1352 = !DILocation(line: 158, column: 5, scope: !1308)
!1353 = !DILocation(line: 158, column: 10, scope: !1308)
!1354 = !DILocation(line: 158, column: 21, scope: !1308)
!1355 = !DILocation(line: 159, column: 23, scope: !1308)
!1356 = !DILocation(line: 159, column: 5, scope: !1308)
!1357 = !DILocation(line: 159, column: 10, scope: !1308)
!1358 = !DILocation(line: 159, column: 21, scope: !1308)
!1359 = !DILocalVariable(name: "i", scope: !1360, file: !6, line: 161, type: !14)
!1360 = distinct !DILexicalBlock(scope: !1308, file: !6, line: 161, column: 5)
!1361 = !DILocation(line: 161, column: 18, scope: !1360)
!1362 = !DILocation(line: 161, column: 10, scope: !1360)
!1363 = !DILocation(line: 161, column: 25, scope: !1364)
!1364 = distinct !DILexicalBlock(scope: !1360, file: !6, line: 161, column: 5)
!1365 = !DILocation(line: 161, column: 29, scope: !1364)
!1366 = !DILocation(line: 161, column: 34, scope: !1364)
!1367 = !DILocation(line: 161, column: 27, scope: !1364)
!1368 = !DILocation(line: 161, column: 5, scope: !1360)
!1369 = !DILocation(line: 162, column: 26, scope: !1370)
!1370 = distinct !DILexicalBlock(scope: !1364, file: !6, line: 161, column: 49)
!1371 = !DILocation(line: 162, column: 31, scope: !1370)
!1372 = !DILocation(line: 162, column: 39, scope: !1370)
!1373 = !DILocation(line: 162, column: 42, scope: !1370)
!1374 = !DILocation(line: 162, column: 9, scope: !1370)
!1375 = !DILocation(line: 163, column: 26, scope: !1370)
!1376 = !DILocation(line: 163, column: 31, scope: !1370)
!1377 = !DILocation(line: 163, column: 39, scope: !1370)
!1378 = !DILocation(line: 163, column: 42, scope: !1370)
!1379 = !DILocation(line: 163, column: 9, scope: !1370)
!1380 = !DILocation(line: 164, column: 5, scope: !1370)
!1381 = !DILocation(line: 161, column: 45, scope: !1364)
!1382 = !DILocation(line: 161, column: 5, scope: !1364)
!1383 = distinct !{!1383, !1368, !1384, !221}
!1384 = !DILocation(line: 164, column: 5, scope: !1360)
!1385 = !DILocation(line: 166, column: 32, scope: !1308)
!1386 = !DILocation(line: 166, column: 41, scope: !1308)
!1387 = !DILocation(line: 166, column: 5, scope: !1308)
!1388 = !DILocation(line: 166, column: 10, scope: !1308)
!1389 = !DILocation(line: 166, column: 29, scope: !1308)
!1390 = !DILocation(line: 167, column: 26, scope: !1308)
!1391 = !DILocation(line: 167, column: 31, scope: !1308)
!1392 = !DILocation(line: 167, column: 5, scope: !1308)
!1393 = !DILocation(line: 168, column: 18, scope: !1308)
!1394 = !DILocation(line: 168, column: 23, scope: !1308)
!1395 = !DILocation(line: 168, column: 5, scope: !1308)
!1396 = !DILocation(line: 170, column: 1, scope: !1308)
!1397 = distinct !DISubprogram(name: "cb_cmp", scope: !68, file: !68, line: 40, type: !88, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1398 = !DILocalVariable(name: "key_a", arg: 1, scope: !1397, file: !68, line: 40, type: !19)
!1399 = !DILocation(line: 40, column: 19, scope: !1397)
!1400 = !DILocalVariable(name: "key_b", arg: 2, scope: !1397, file: !68, line: 40, type: !19)
!1401 = !DILocation(line: 40, column: 37, scope: !1397)
!1402 = !DILocation(line: 42, column: 9, scope: !1403)
!1403 = distinct !DILexicalBlock(scope: !1397, file: !68, line: 42, column: 9)
!1404 = !DILocation(line: 42, column: 18, scope: !1403)
!1405 = !DILocation(line: 42, column: 15, scope: !1403)
!1406 = !DILocation(line: 42, column: 9, scope: !1397)
!1407 = !DILocation(line: 43, column: 9, scope: !1408)
!1408 = distinct !DILexicalBlock(scope: !1403, file: !68, line: 42, column: 25)
!1409 = !DILocation(line: 44, column: 16, scope: !1410)
!1410 = distinct !DILexicalBlock(scope: !1403, file: !68, line: 44, column: 16)
!1411 = !DILocation(line: 44, column: 24, scope: !1410)
!1412 = !DILocation(line: 44, column: 22, scope: !1410)
!1413 = !DILocation(line: 44, column: 16, scope: !1403)
!1414 = !DILocation(line: 45, column: 9, scope: !1415)
!1415 = distinct !DILexicalBlock(scope: !1410, file: !68, line: 44, column: 31)
!1416 = !DILocation(line: 47, column: 9, scope: !1417)
!1417 = distinct !DILexicalBlock(scope: !1410, file: !68, line: 46, column: 12)
!1418 = !DILocation(line: 49, column: 1, scope: !1397)
!1419 = distinct !DISubprogram(name: "cb_hash", scope: !68, file: !68, line: 53, type: !98, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1420 = !DILocalVariable(name: "key", arg: 1, scope: !1419, file: !68, line: 53, type: !19)
!1421 = !DILocation(line: 53, column: 20, scope: !1419)
!1422 = !DILocation(line: 55, column: 23, scope: !1419)
!1423 = !DILocation(line: 55, column: 5, scope: !1419)
!1424 = distinct !DISubprogram(name: "cb_destroy", scope: !68, file: !68, line: 71, type: !103, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1425 = !DILocalVariable(name: "data", arg: 1, scope: !1424, file: !68, line: 71, type: !22)
!1426 = !DILocation(line: 71, column: 18, scope: !1424)
!1427 = !DILocation(line: 73, column: 10, scope: !1424)
!1428 = !DILocation(line: 73, column: 5, scope: !1424)
!1429 = !DILocation(line: 74, column: 1, scope: !1424)
!1430 = distinct !DISubprogram(name: "trace_init", scope: !165, file: !165, line: 34, type: !1431, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1431 = !DISubroutineType(types: !1432)
!1432 = !{null, !588, !14}
!1433 = !DILocalVariable(name: "trace", arg: 1, scope: !1430, file: !165, line: 34, type: !588)
!1434 = !DILocation(line: 34, column: 21, scope: !1430)
!1435 = !DILocalVariable(name: "capacity", arg: 2, scope: !1430, file: !165, line: 34, type: !14)
!1436 = !DILocation(line: 34, column: 36, scope: !1430)
!1437 = !DILocation(line: 36, column: 5, scope: !1438)
!1438 = distinct !DILexicalBlock(scope: !1439, file: !165, line: 36, column: 5)
!1439 = distinct !DILexicalBlock(scope: !1430, file: !165, line: 36, column: 5)
!1440 = !DILocation(line: 36, column: 5, scope: !1439)
!1441 = !DILocation(line: 37, column: 27, scope: !1430)
!1442 = !DILocation(line: 37, column: 36, scope: !1430)
!1443 = !DILocation(line: 37, column: 20, scope: !1430)
!1444 = !DILocation(line: 37, column: 5, scope: !1430)
!1445 = !DILocation(line: 37, column: 12, scope: !1430)
!1446 = !DILocation(line: 37, column: 18, scope: !1430)
!1447 = !DILocation(line: 38, column: 9, scope: !1448)
!1448 = distinct !DILexicalBlock(scope: !1430, file: !165, line: 38, column: 9)
!1449 = !DILocation(line: 38, column: 16, scope: !1448)
!1450 = !DILocation(line: 38, column: 9, scope: !1430)
!1451 = !DILocation(line: 39, column: 9, scope: !1452)
!1452 = distinct !DILexicalBlock(scope: !1448, file: !165, line: 38, column: 23)
!1453 = !DILocation(line: 39, column: 16, scope: !1452)
!1454 = !DILocation(line: 39, column: 28, scope: !1452)
!1455 = !DILocation(line: 40, column: 30, scope: !1452)
!1456 = !DILocation(line: 40, column: 9, scope: !1452)
!1457 = !DILocation(line: 40, column: 16, scope: !1452)
!1458 = !DILocation(line: 40, column: 28, scope: !1452)
!1459 = !DILocation(line: 41, column: 9, scope: !1452)
!1460 = !DILocation(line: 41, column: 16, scope: !1452)
!1461 = !DILocation(line: 41, column: 28, scope: !1452)
!1462 = !DILocation(line: 42, column: 5, scope: !1452)
!1463 = !DILocation(line: 43, column: 9, scope: !1464)
!1464 = distinct !DILexicalBlock(scope: !1448, file: !165, line: 42, column: 12)
!1465 = !DILocation(line: 43, column: 16, scope: !1464)
!1466 = !DILocation(line: 43, column: 28, scope: !1464)
!1467 = !DILocation(line: 44, column: 9, scope: !1464)
!1468 = !DILocation(line: 44, column: 16, scope: !1464)
!1469 = !DILocation(line: 44, column: 28, scope: !1464)
!1470 = !DILocation(line: 45, column: 9, scope: !1464)
!1471 = !DILocation(line: 45, column: 16, scope: !1464)
!1472 = !DILocation(line: 45, column: 28, scope: !1464)
!1473 = !DILocation(line: 46, column: 9, scope: !1474)
!1474 = distinct !DILexicalBlock(scope: !1475, file: !165, line: 46, column: 9)
!1475 = distinct !DILexicalBlock(scope: !1464, file: !165, line: 46, column: 9)
!1476 = !DILocation(line: 48, column: 1, scope: !1430)
!1477 = distinct !DISubprogram(name: "vatomicptr_init", scope: !826, file: !826, line: 4223, type: !1478, scopeLine: 4224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1478 = !DISubroutineType(types: !1479)
!1479 = !{null, !875, !22}
!1480 = !DILocalVariable(name: "a", arg: 1, scope: !1477, file: !826, line: 4223, type: !875)
!1481 = !DILocation(line: 4223, column: 31, scope: !1477)
!1482 = !DILocalVariable(name: "v", arg: 2, scope: !1477, file: !826, line: 4223, type: !22)
!1483 = !DILocation(line: 4223, column: 40, scope: !1477)
!1484 = !DILocation(line: 4225, column: 22, scope: !1477)
!1485 = !DILocation(line: 4225, column: 25, scope: !1477)
!1486 = !DILocation(line: 4225, column: 5, scope: !1477)
!1487 = !DILocation(line: 4226, column: 1, scope: !1477)
!1488 = distinct !DISubprogram(name: "vatomicsz_write_rlx", scope: !786, file: !786, line: 519, type: !1489, scopeLine: 520, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1489 = !DISubroutineType(types: !1490)
!1490 = !{null, !1491, !14}
!1491 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !107, size: 64)
!1492 = !DILocalVariable(name: "a", arg: 1, scope: !1488, file: !786, line: 519, type: !1491)
!1493 = !DILocation(line: 519, column: 34, scope: !1488)
!1494 = !DILocalVariable(name: "v", arg: 2, scope: !1488, file: !786, line: 519, type: !14)
!1495 = !DILocation(line: 519, column: 45, scope: !1488)
!1496 = !DILocation(line: 521, column: 5, scope: !1488)
!1497 = !{i64 2148226831}
!1498 = !DILocation(line: 522, column: 23, scope: !1488)
!1499 = !DILocation(line: 522, column: 26, scope: !1488)
!1500 = !DILocation(line: 522, column: 30, scope: !1488)
!1501 = !DILocation(line: 522, column: 5, scope: !1488)
!1502 = !DILocation(line: 523, column: 5, scope: !1488)
!1503 = !{i64 2148226871}
!1504 = !DILocation(line: 524, column: 1, scope: !1488)
!1505 = distinct !DISubprogram(name: "rwlock_init", scope: !113, file: !113, line: 33, type: !760, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1506 = !DILocalVariable(name: "l", arg: 1, scope: !1505, file: !113, line: 33, type: !740)
!1507 = !DILocation(line: 33, column: 23, scope: !1505)
!1508 = !DILocalVariable(name: "i", scope: !1509, file: !113, line: 35, type: !14)
!1509 = distinct !DILexicalBlock(scope: !1505, file: !113, line: 35, column: 5)
!1510 = !DILocation(line: 35, column: 18, scope: !1509)
!1511 = !DILocation(line: 35, column: 10, scope: !1509)
!1512 = !DILocation(line: 35, column: 25, scope: !1513)
!1513 = distinct !DILexicalBlock(scope: !1509, file: !113, line: 35, column: 5)
!1514 = !DILocation(line: 35, column: 27, scope: !1513)
!1515 = !DILocation(line: 35, column: 5, scope: !1509)
!1516 = !DILocation(line: 36, column: 29, scope: !1517)
!1517 = distinct !DILexicalBlock(scope: !1513, file: !113, line: 35, column: 54)
!1518 = !DILocation(line: 36, column: 32, scope: !1517)
!1519 = !DILocation(line: 36, column: 37, scope: !1517)
!1520 = !DILocation(line: 36, column: 9, scope: !1517)
!1521 = !DILocation(line: 37, column: 5, scope: !1517)
!1522 = !DILocation(line: 35, column: 50, scope: !1513)
!1523 = !DILocation(line: 35, column: 5, scope: !1513)
!1524 = distinct !{!1524, !1515, !1525, !221}
!1525 = !DILocation(line: 37, column: 5, scope: !1509)
!1526 = !DILocation(line: 38, column: 1, scope: !1505)
!1527 = distinct !DISubprogram(name: "vatomicptr_write", scope: !786, file: !786, line: 532, type: !1478, scopeLine: 533, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1528 = !DILocalVariable(name: "a", arg: 1, scope: !1527, file: !786, line: 532, type: !875)
!1529 = !DILocation(line: 532, column: 32, scope: !1527)
!1530 = !DILocalVariable(name: "v", arg: 2, scope: !1527, file: !786, line: 532, type: !22)
!1531 = !DILocation(line: 532, column: 41, scope: !1527)
!1532 = !DILocation(line: 534, column: 5, scope: !1527)
!1533 = !{i64 2148226909}
!1534 = !DILocation(line: 535, column: 23, scope: !1527)
!1535 = !DILocation(line: 535, column: 26, scope: !1527)
!1536 = !DILocation(line: 535, column: 30, scope: !1527)
!1537 = !DILocation(line: 535, column: 5, scope: !1527)
!1538 = !DILocation(line: 536, column: 5, scope: !1527)
!1539 = !{i64 2148226949}
!1540 = !DILocation(line: 537, column: 1, scope: !1527)
!1541 = distinct !DISubprogram(name: "_imap_verify", scope: !68, file: !68, line: 77, type: !193, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1542 = !DILocalVariable(name: "key", scope: !1541, file: !68, line: 79, type: !19)
!1543 = !DILocation(line: 79, column: 16, scope: !1541)
!1544 = !DILocalVariable(name: "data", scope: !1541, file: !68, line: 80, type: !233)
!1545 = !DILocation(line: 80, column: 13, scope: !1541)
!1546 = !DILocalVariable(name: "iter", scope: !1541, file: !68, line: 81, type: !1547)
!1547 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_iter_t", file: !6, line: 99, baseType: !1548)
!1548 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vsimpleht_iter_s", file: !6, line: 96, size: 128, elements: !1549)
!1549 = !{!1550, !1551}
!1550 = !DIDerivedType(tag: DW_TAG_member, name: "tbl", scope: !1548, file: !6, line: 97, baseType: !563, size: 64)
!1551 = !DIDerivedType(tag: DW_TAG_member, name: "idx", scope: !1548, file: !6, line: 98, baseType: !14, size: 64, offset: 64)
!1552 = !DILocation(line: 81, column: 22, scope: !1541)
!1553 = !DILocalVariable(name: "add_trc", scope: !1541, file: !68, line: 83, type: !164)
!1554 = !DILocation(line: 83, column: 13, scope: !1541)
!1555 = !DILocalVariable(name: "rem_trc", scope: !1541, file: !68, line: 84, type: !164)
!1556 = !DILocation(line: 84, column: 13, scope: !1541)
!1557 = !DILocalVariable(name: "final_state_trc", scope: !1541, file: !68, line: 85, type: !164)
!1558 = !DILocation(line: 85, column: 13, scope: !1541)
!1559 = !DILocation(line: 87, column: 5, scope: !1541)
!1560 = !DILocation(line: 88, column: 5, scope: !1541)
!1561 = !DILocalVariable(name: "i", scope: !1562, file: !68, line: 91, type: !14)
!1562 = distinct !DILexicalBlock(scope: !1541, file: !68, line: 91, column: 5)
!1563 = !DILocation(line: 91, column: 18, scope: !1562)
!1564 = !DILocation(line: 91, column: 10, scope: !1562)
!1565 = !DILocation(line: 91, column: 25, scope: !1566)
!1566 = distinct !DILexicalBlock(scope: !1562, file: !68, line: 91, column: 5)
!1567 = !DILocation(line: 91, column: 27, scope: !1566)
!1568 = !DILocation(line: 91, column: 5, scope: !1562)
!1569 = !DILocation(line: 92, column: 43, scope: !1570)
!1570 = distinct !DILexicalBlock(scope: !1566, file: !68, line: 91, column: 43)
!1571 = !DILocation(line: 92, column: 37, scope: !1570)
!1572 = !DILocation(line: 92, column: 9, scope: !1570)
!1573 = !DILocation(line: 93, column: 43, scope: !1570)
!1574 = !DILocation(line: 93, column: 37, scope: !1570)
!1575 = !DILocation(line: 93, column: 9, scope: !1570)
!1576 = !DILocation(line: 94, column: 5, scope: !1570)
!1577 = !DILocation(line: 91, column: 39, scope: !1566)
!1578 = !DILocation(line: 91, column: 5, scope: !1566)
!1579 = distinct !{!1579, !1568, !1580, !221}
!1580 = !DILocation(line: 94, column: 5, scope: !1562)
!1581 = !DILocation(line: 97, column: 5, scope: !1541)
!1582 = !DILocation(line: 98, column: 5, scope: !1541)
!1583 = !DILocation(line: 99, column: 5, scope: !1541)
!1584 = !DILocation(line: 99, column: 45, scope: !1541)
!1585 = !DILocation(line: 99, column: 12, scope: !1541)
!1586 = !DILocation(line: 100, column: 37, scope: !1587)
!1587 = distinct !DILexicalBlock(scope: !1541, file: !68, line: 99, column: 62)
!1588 = !DILocation(line: 100, column: 9, scope: !1587)
!1589 = distinct !{!1589, !1583, !1590, !221}
!1590 = !DILocation(line: 101, column: 5, scope: !1541)
!1591 = !DILocation(line: 103, column: 5, scope: !1541)
!1592 = !DILocalVariable(name: "eq", scope: !1541, file: !68, line: 104, type: !42)
!1593 = !DILocation(line: 104, column: 13, scope: !1541)
!1594 = !DILocation(line: 104, column: 18, scope: !1541)
!1595 = !DILocation(line: 106, column: 5, scope: !1541)
!1596 = !DILocation(line: 107, column: 5, scope: !1541)
!1597 = !DILocation(line: 108, column: 5, scope: !1541)
!1598 = !DILocation(line: 109, column: 5, scope: !1599)
!1599 = distinct !DILexicalBlock(scope: !1600, file: !68, line: 109, column: 5)
!1600 = distinct !DILexicalBlock(scope: !1541, file: !68, line: 109, column: 5)
!1601 = !DILocation(line: 109, column: 5, scope: !1600)
!1602 = !DILocation(line: 110, column: 1, scope: !1541)
!1603 = distinct !DISubprogram(name: "trace_destroy", scope: !165, file: !165, line: 98, type: !1031, scopeLine: 99, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1604 = !DILocalVariable(name: "trace", arg: 1, scope: !1603, file: !165, line: 98, type: !588)
!1605 = !DILocation(line: 98, column: 24, scope: !1603)
!1606 = !DILocation(line: 100, column: 5, scope: !1607)
!1607 = distinct !DILexicalBlock(scope: !1608, file: !165, line: 100, column: 5)
!1608 = distinct !DILexicalBlock(scope: !1603, file: !165, line: 100, column: 5)
!1609 = !DILocation(line: 100, column: 5, scope: !1608)
!1610 = !DILocation(line: 101, column: 5, scope: !1611)
!1611 = distinct !DILexicalBlock(scope: !1612, file: !165, line: 101, column: 5)
!1612 = distinct !DILexicalBlock(scope: !1603, file: !165, line: 101, column: 5)
!1613 = !DILocation(line: 101, column: 5, scope: !1612)
!1614 = !DILocation(line: 102, column: 10, scope: !1603)
!1615 = !DILocation(line: 102, column: 17, scope: !1603)
!1616 = !DILocation(line: 102, column: 5, scope: !1603)
!1617 = !DILocation(line: 103, column: 5, scope: !1603)
!1618 = !DILocation(line: 103, column: 12, scope: !1603)
!1619 = !DILocation(line: 103, column: 24, scope: !1603)
!1620 = !DILocation(line: 104, column: 1, scope: !1603)
!1621 = distinct !DISubprogram(name: "vsimpleht_destroy", scope: !6, file: !6, line: 178, type: !606, scopeLine: 179, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1622 = !DILocalVariable(name: "tbl", arg: 1, scope: !1621, file: !6, line: 178, type: !563)
!1623 = !DILocation(line: 178, column: 32, scope: !1621)
!1624 = !DILocalVariable(name: "entry", scope: !1621, file: !6, line: 180, type: !74)
!1625 = !DILocation(line: 180, column: 24, scope: !1621)
!1626 = !DILocalVariable(name: "obj", scope: !1621, file: !6, line: 181, type: !22)
!1627 = !DILocation(line: 181, column: 11, scope: !1621)
!1628 = !DILocation(line: 182, column: 5, scope: !1629)
!1629 = distinct !DILexicalBlock(scope: !1630, file: !6, line: 182, column: 5)
!1630 = distinct !DILexicalBlock(scope: !1621, file: !6, line: 182, column: 5)
!1631 = !DILocation(line: 182, column: 5, scope: !1630)
!1632 = !DILocalVariable(name: "i", scope: !1633, file: !6, line: 183, type: !14)
!1633 = distinct !DILexicalBlock(scope: !1621, file: !6, line: 183, column: 5)
!1634 = !DILocation(line: 183, column: 18, scope: !1633)
!1635 = !DILocation(line: 183, column: 10, scope: !1633)
!1636 = !DILocation(line: 183, column: 25, scope: !1637)
!1637 = distinct !DILexicalBlock(scope: !1633, file: !6, line: 183, column: 5)
!1638 = !DILocation(line: 183, column: 29, scope: !1637)
!1639 = !DILocation(line: 183, column: 34, scope: !1637)
!1640 = !DILocation(line: 183, column: 27, scope: !1637)
!1641 = !DILocation(line: 183, column: 5, scope: !1633)
!1642 = !DILocation(line: 184, column: 18, scope: !1643)
!1643 = distinct !DILexicalBlock(scope: !1637, file: !6, line: 183, column: 49)
!1644 = !DILocation(line: 184, column: 23, scope: !1643)
!1645 = !DILocation(line: 184, column: 31, scope: !1643)
!1646 = !DILocation(line: 184, column: 15, scope: !1643)
!1647 = !DILocation(line: 185, column: 38, scope: !1643)
!1648 = !DILocation(line: 185, column: 45, scope: !1643)
!1649 = !DILocation(line: 185, column: 17, scope: !1643)
!1650 = !DILocation(line: 185, column: 15, scope: !1643)
!1651 = !DILocation(line: 186, column: 13, scope: !1652)
!1652 = distinct !DILexicalBlock(scope: !1643, file: !6, line: 186, column: 13)
!1653 = !DILocation(line: 186, column: 13, scope: !1643)
!1654 = !DILocation(line: 187, column: 13, scope: !1655)
!1655 = distinct !DILexicalBlock(scope: !1652, file: !6, line: 186, column: 18)
!1656 = !DILocation(line: 187, column: 18, scope: !1655)
!1657 = !DILocation(line: 187, column: 29, scope: !1655)
!1658 = !DILocation(line: 188, column: 9, scope: !1655)
!1659 = !DILocation(line: 189, column: 5, scope: !1643)
!1660 = !DILocation(line: 183, column: 45, scope: !1637)
!1661 = !DILocation(line: 183, column: 5, scope: !1637)
!1662 = distinct !{!1662, !1641, !1663, !221}
!1663 = !DILocation(line: 189, column: 5, scope: !1633)
!1664 = !DILocation(line: 190, column: 1, scope: !1621)
!1665 = distinct !DISubprogram(name: "trace_merge_into", scope: !165, file: !165, line: 177, type: !1666, scopeLine: 178, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1666 = !DISubroutineType(types: !1667)
!1667 = !{null, !588, !588}
!1668 = !DILocalVariable(name: "trace_container", arg: 1, scope: !1665, file: !165, line: 177, type: !588)
!1669 = !DILocation(line: 177, column: 27, scope: !1665)
!1670 = !DILocalVariable(name: "trace", arg: 2, scope: !1665, file: !165, line: 177, type: !588)
!1671 = !DILocation(line: 177, column: 53, scope: !1665)
!1672 = !DILocation(line: 179, column: 30, scope: !1665)
!1673 = !DILocation(line: 179, column: 47, scope: !1665)
!1674 = !DILocation(line: 179, column: 5, scope: !1665)
!1675 = !DILocation(line: 180, column: 1, scope: !1665)
!1676 = distinct !DISubprogram(name: "vsimpleht_iter_init", scope: !6, file: !6, line: 280, type: !1677, scopeLine: 281, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1677 = !DISubroutineType(types: !1678)
!1678 = !{null, !563, !1679}
!1679 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1547, size: 64)
!1680 = !DILocalVariable(name: "tbl", arg: 1, scope: !1676, file: !6, line: 280, type: !563)
!1681 = !DILocation(line: 280, column: 34, scope: !1676)
!1682 = !DILocalVariable(name: "iter", arg: 2, scope: !1676, file: !6, line: 280, type: !1679)
!1683 = !DILocation(line: 280, column: 57, scope: !1676)
!1684 = !DILocation(line: 282, column: 5, scope: !1685)
!1685 = distinct !DILexicalBlock(scope: !1686, file: !6, line: 282, column: 5)
!1686 = distinct !DILexicalBlock(scope: !1676, file: !6, line: 282, column: 5)
!1687 = !DILocation(line: 282, column: 5, scope: !1686)
!1688 = !DILocation(line: 283, column: 5, scope: !1689)
!1689 = distinct !DILexicalBlock(scope: !1690, file: !6, line: 283, column: 5)
!1690 = distinct !DILexicalBlock(scope: !1676, file: !6, line: 283, column: 5)
!1691 = !DILocation(line: 283, column: 5, scope: !1690)
!1692 = !DILocation(line: 284, column: 17, scope: !1676)
!1693 = !DILocation(line: 284, column: 5, scope: !1676)
!1694 = !DILocation(line: 284, column: 11, scope: !1676)
!1695 = !DILocation(line: 284, column: 15, scope: !1676)
!1696 = !DILocation(line: 285, column: 5, scope: !1676)
!1697 = !DILocation(line: 285, column: 11, scope: !1676)
!1698 = !DILocation(line: 285, column: 15, scope: !1676)
!1699 = !DILocation(line: 286, column: 1, scope: !1676)
!1700 = distinct !DISubprogram(name: "vsimpleht_iter_next", scope: !6, file: !6, line: 317, type: !1701, scopeLine: 318, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1701 = !DISubroutineType(types: !1702)
!1702 = !{!42, !1679, !1703, !52}
!1703 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!1704 = !DILocalVariable(name: "iter", arg: 1, scope: !1700, file: !6, line: 317, type: !1679)
!1705 = !DILocation(line: 317, column: 39, scope: !1700)
!1706 = !DILocalVariable(name: "key", arg: 2, scope: !1700, file: !6, line: 317, type: !1703)
!1707 = !DILocation(line: 317, column: 57, scope: !1700)
!1708 = !DILocalVariable(name: "val", arg: 3, scope: !1700, file: !6, line: 317, type: !52)
!1709 = !DILocation(line: 317, column: 69, scope: !1700)
!1710 = !DILocalVariable(name: "k", scope: !1700, file: !6, line: 319, type: !19)
!1711 = !DILocation(line: 319, column: 16, scope: !1700)
!1712 = !DILocalVariable(name: "v", scope: !1700, file: !6, line: 320, type: !22)
!1713 = !DILocation(line: 320, column: 11, scope: !1700)
!1714 = !DILocalVariable(name: "entries", scope: !1700, file: !6, line: 321, type: !74)
!1715 = !DILocation(line: 321, column: 24, scope: !1700)
!1716 = !DILocation(line: 322, column: 5, scope: !1717)
!1717 = distinct !DILexicalBlock(scope: !1718, file: !6, line: 322, column: 5)
!1718 = distinct !DILexicalBlock(scope: !1700, file: !6, line: 322, column: 5)
!1719 = !DILocation(line: 322, column: 5, scope: !1718)
!1720 = !DILocation(line: 323, column: 5, scope: !1721)
!1721 = distinct !DILexicalBlock(scope: !1722, file: !6, line: 323, column: 5)
!1722 = distinct !DILexicalBlock(scope: !1700, file: !6, line: 323, column: 5)
!1723 = !DILocation(line: 323, column: 5, scope: !1722)
!1724 = !DILocation(line: 324, column: 5, scope: !1725)
!1725 = distinct !DILexicalBlock(scope: !1726, file: !6, line: 324, column: 5)
!1726 = distinct !DILexicalBlock(scope: !1700, file: !6, line: 324, column: 5)
!1727 = !DILocation(line: 324, column: 5, scope: !1726)
!1728 = !DILocation(line: 325, column: 5, scope: !1729)
!1729 = distinct !DILexicalBlock(scope: !1730, file: !6, line: 325, column: 5)
!1730 = distinct !DILexicalBlock(scope: !1700, file: !6, line: 325, column: 5)
!1731 = !DILocation(line: 325, column: 5, scope: !1730)
!1732 = !DILocation(line: 326, column: 15, scope: !1700)
!1733 = !DILocation(line: 326, column: 21, scope: !1700)
!1734 = !DILocation(line: 326, column: 26, scope: !1700)
!1735 = !DILocation(line: 326, column: 13, scope: !1700)
!1736 = !DILocation(line: 327, column: 5, scope: !1737)
!1737 = distinct !DILexicalBlock(scope: !1738, file: !6, line: 327, column: 5)
!1738 = distinct !DILexicalBlock(scope: !1700, file: !6, line: 327, column: 5)
!1739 = !DILocation(line: 327, column: 5, scope: !1738)
!1740 = !DILocalVariable(name: "i", scope: !1741, file: !6, line: 328, type: !14)
!1741 = distinct !DILexicalBlock(scope: !1700, file: !6, line: 328, column: 5)
!1742 = !DILocation(line: 328, column: 18, scope: !1741)
!1743 = !DILocation(line: 328, column: 22, scope: !1741)
!1744 = !DILocation(line: 328, column: 28, scope: !1741)
!1745 = !DILocation(line: 328, column: 10, scope: !1741)
!1746 = !DILocation(line: 328, column: 33, scope: !1747)
!1747 = distinct !DILexicalBlock(scope: !1741, file: !6, line: 328, column: 5)
!1748 = !DILocation(line: 328, column: 37, scope: !1747)
!1749 = !DILocation(line: 328, column: 43, scope: !1747)
!1750 = !DILocation(line: 328, column: 48, scope: !1747)
!1751 = !DILocation(line: 328, column: 35, scope: !1747)
!1752 = !DILocation(line: 328, column: 5, scope: !1741)
!1753 = !DILocation(line: 329, column: 42, scope: !1754)
!1754 = distinct !DILexicalBlock(scope: !1747, file: !6, line: 328, column: 63)
!1755 = !DILocation(line: 329, column: 50, scope: !1754)
!1756 = !DILocation(line: 329, column: 53, scope: !1754)
!1757 = !DILocation(line: 329, column: 25, scope: !1754)
!1758 = !DILocation(line: 329, column: 13, scope: !1754)
!1759 = !DILocation(line: 329, column: 11, scope: !1754)
!1760 = !DILocation(line: 330, column: 30, scope: !1754)
!1761 = !DILocation(line: 330, column: 38, scope: !1754)
!1762 = !DILocation(line: 330, column: 41, scope: !1754)
!1763 = !DILocation(line: 330, column: 13, scope: !1754)
!1764 = !DILocation(line: 330, column: 11, scope: !1754)
!1765 = !DILocation(line: 331, column: 13, scope: !1766)
!1766 = distinct !DILexicalBlock(scope: !1754, file: !6, line: 331, column: 13)
!1767 = !DILocation(line: 331, column: 15, scope: !1766)
!1768 = !DILocation(line: 331, column: 18, scope: !1766)
!1769 = !DILocation(line: 331, column: 13, scope: !1754)
!1770 = !DILocation(line: 332, column: 25, scope: !1771)
!1771 = distinct !DILexicalBlock(scope: !1766, file: !6, line: 331, column: 21)
!1772 = !DILocation(line: 332, column: 27, scope: !1771)
!1773 = !DILocation(line: 332, column: 13, scope: !1771)
!1774 = !DILocation(line: 332, column: 19, scope: !1771)
!1775 = !DILocation(line: 332, column: 23, scope: !1771)
!1776 = !DILocation(line: 333, column: 25, scope: !1771)
!1777 = !DILocation(line: 333, column: 14, scope: !1771)
!1778 = !DILocation(line: 333, column: 23, scope: !1771)
!1779 = !DILocation(line: 334, column: 25, scope: !1771)
!1780 = !DILocation(line: 334, column: 14, scope: !1771)
!1781 = !DILocation(line: 334, column: 23, scope: !1771)
!1782 = !DILocation(line: 335, column: 13, scope: !1771)
!1783 = !DILocation(line: 337, column: 5, scope: !1754)
!1784 = !DILocation(line: 328, column: 59, scope: !1747)
!1785 = !DILocation(line: 328, column: 5, scope: !1747)
!1786 = distinct !{!1786, !1752, !1787, !221}
!1787 = !DILocation(line: 337, column: 5, scope: !1741)
!1788 = !DILocation(line: 338, column: 5, scope: !1700)
!1789 = !DILocation(line: 339, column: 1, scope: !1700)
!1790 = distinct !DISubprogram(name: "trace_subtract_from", scope: !165, file: !165, line: 183, type: !1666, scopeLine: 184, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1791 = !DILocalVariable(name: "trace_container", arg: 1, scope: !1790, file: !165, line: 183, type: !588)
!1792 = !DILocation(line: 183, column: 30, scope: !1790)
!1793 = !DILocalVariable(name: "trace", arg: 2, scope: !1790, file: !165, line: 183, type: !588)
!1794 = !DILocation(line: 183, column: 56, scope: !1790)
!1795 = !DILocation(line: 185, column: 30, scope: !1790)
!1796 = !DILocation(line: 185, column: 47, scope: !1790)
!1797 = !DILocation(line: 185, column: 5, scope: !1790)
!1798 = !DILocation(line: 186, column: 1, scope: !1790)
!1799 = distinct !DISubprogram(name: "trace_is_subtrace", scope: !165, file: !165, line: 292, type: !1800, scopeLine: 294, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1800 = !DISubroutineType(types: !1801)
!1801 = !{!42, !588, !588, !1802}
!1802 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1803, size: 64)
!1803 = !DISubroutineType(types: !1804)
!1804 = !{null, !19}
!1805 = !DILocalVariable(name: "super_trace", arg: 1, scope: !1799, file: !165, line: 292, type: !588)
!1806 = !DILocation(line: 292, column: 28, scope: !1799)
!1807 = !DILocalVariable(name: "sub_trace", arg: 2, scope: !1799, file: !165, line: 292, type: !588)
!1808 = !DILocation(line: 292, column: 50, scope: !1799)
!1809 = !DILocalVariable(name: "print", arg: 3, scope: !1799, file: !165, line: 293, type: !1802)
!1810 = !DILocation(line: 293, column: 26, scope: !1799)
!1811 = !DILocalVariable(name: "i", scope: !1799, file: !165, line: 295, type: !14)
!1812 = !DILocation(line: 295, column: 13, scope: !1799)
!1813 = !DILocalVariable(name: "idx", scope: !1799, file: !165, line: 296, type: !14)
!1814 = !DILocation(line: 296, column: 13, scope: !1799)
!1815 = !DILocalVariable(name: "unit_a", scope: !1799, file: !165, line: 298, type: !169)
!1816 = !DILocation(line: 298, column: 19, scope: !1799)
!1817 = !DILocalVariable(name: "unit_b", scope: !1799, file: !165, line: 299, type: !169)
!1818 = !DILocation(line: 299, column: 19, scope: !1799)
!1819 = !DILocation(line: 302, column: 12, scope: !1820)
!1820 = distinct !DILexicalBlock(scope: !1799, file: !165, line: 302, column: 5)
!1821 = !DILocation(line: 302, column: 10, scope: !1820)
!1822 = !DILocation(line: 302, column: 17, scope: !1823)
!1823 = distinct !DILexicalBlock(scope: !1820, file: !165, line: 302, column: 5)
!1824 = !DILocation(line: 302, column: 21, scope: !1823)
!1825 = !DILocation(line: 302, column: 32, scope: !1823)
!1826 = !DILocation(line: 302, column: 19, scope: !1823)
!1827 = !DILocation(line: 302, column: 5, scope: !1820)
!1828 = !DILocation(line: 303, column: 19, scope: !1829)
!1829 = distinct !DILexicalBlock(scope: !1823, file: !165, line: 302, column: 42)
!1830 = !DILocation(line: 303, column: 30, scope: !1829)
!1831 = !DILocation(line: 303, column: 36, scope: !1829)
!1832 = !DILocation(line: 303, column: 16, scope: !1829)
!1833 = !DILocation(line: 305, column: 33, scope: !1834)
!1834 = distinct !DILexicalBlock(scope: !1829, file: !165, line: 305, column: 13)
!1835 = !DILocation(line: 305, column: 46, scope: !1834)
!1836 = !DILocation(line: 305, column: 54, scope: !1834)
!1837 = !DILocation(line: 305, column: 13, scope: !1834)
!1838 = !DILocation(line: 305, column: 13, scope: !1829)
!1839 = !DILocation(line: 306, column: 23, scope: !1840)
!1840 = distinct !DILexicalBlock(scope: !1834, file: !165, line: 305, column: 66)
!1841 = !DILocation(line: 306, column: 36, scope: !1840)
!1842 = !DILocation(line: 306, column: 42, scope: !1840)
!1843 = !DILocation(line: 306, column: 20, scope: !1840)
!1844 = !DILocation(line: 308, column: 13, scope: !1845)
!1845 = distinct !DILexicalBlock(scope: !1846, file: !165, line: 308, column: 13)
!1846 = distinct !DILexicalBlock(scope: !1840, file: !165, line: 308, column: 13)
!1847 = !DILocation(line: 308, column: 13, scope: !1846)
!1848 = !DILocation(line: 310, column: 17, scope: !1849)
!1849 = distinct !DILexicalBlock(scope: !1840, file: !165, line: 310, column: 17)
!1850 = !DILocation(line: 310, column: 25, scope: !1849)
!1851 = !DILocation(line: 310, column: 34, scope: !1849)
!1852 = !DILocation(line: 310, column: 42, scope: !1849)
!1853 = !DILocation(line: 310, column: 31, scope: !1849)
!1854 = !DILocation(line: 310, column: 17, scope: !1840)
!1855 = !DILocation(line: 311, column: 21, scope: !1856)
!1856 = distinct !DILexicalBlock(scope: !1857, file: !165, line: 311, column: 21)
!1857 = distinct !DILexicalBlock(scope: !1849, file: !165, line: 310, column: 49)
!1858 = !DILocation(line: 311, column: 21, scope: !1857)
!1859 = !DILocation(line: 314, column: 28, scope: !1860)
!1860 = distinct !DILexicalBlock(scope: !1856, file: !165, line: 311, column: 28)
!1861 = !DILocation(line: 314, column: 36, scope: !1860)
!1862 = !DILocation(line: 314, column: 41, scope: !1860)
!1863 = !DILocation(line: 314, column: 49, scope: !1860)
!1864 = !DILocation(line: 314, column: 56, scope: !1860)
!1865 = !DILocation(line: 314, column: 64, scope: !1860)
!1866 = !DILocation(line: 312, column: 21, scope: !1860)
!1867 = !DILocation(line: 315, column: 21, scope: !1860)
!1868 = !DILocation(line: 315, column: 27, scope: !1860)
!1869 = !DILocation(line: 315, column: 35, scope: !1860)
!1870 = !DILocation(line: 316, column: 17, scope: !1860)
!1871 = !DILocation(line: 317, column: 17, scope: !1857)
!1872 = !DILocation(line: 319, column: 9, scope: !1840)
!1873 = !DILocation(line: 320, column: 17, scope: !1874)
!1874 = distinct !DILexicalBlock(scope: !1875, file: !165, line: 320, column: 17)
!1875 = distinct !DILexicalBlock(scope: !1834, file: !165, line: 319, column: 16)
!1876 = !DILocation(line: 320, column: 17, scope: !1875)
!1877 = !DILocation(line: 321, column: 65, scope: !1878)
!1878 = distinct !DILexicalBlock(scope: !1874, file: !165, line: 320, column: 24)
!1879 = !DILocation(line: 321, column: 73, scope: !1878)
!1880 = !DILocation(line: 321, column: 17, scope: !1878)
!1881 = !DILocation(line: 322, column: 17, scope: !1878)
!1882 = !DILocation(line: 322, column: 23, scope: !1878)
!1883 = !DILocation(line: 322, column: 31, scope: !1878)
!1884 = !DILocation(line: 323, column: 13, scope: !1878)
!1885 = !DILocation(line: 324, column: 13, scope: !1875)
!1886 = !DILocation(line: 326, column: 5, scope: !1829)
!1887 = !DILocation(line: 302, column: 38, scope: !1823)
!1888 = !DILocation(line: 302, column: 5, scope: !1823)
!1889 = distinct !{!1889, !1827, !1890, !221}
!1890 = !DILocation(line: 326, column: 5, scope: !1820)
!1891 = !DILocation(line: 328, column: 5, scope: !1799)
!1892 = !DILocation(line: 329, column: 1, scope: !1799)
!1893 = distinct !DISubprogram(name: "_trace_merge_or_subtract", scope: !165, file: !165, line: 161, type: !1894, scopeLine: 163, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1894 = !DISubroutineType(types: !1895)
!1895 = !{null, !588, !588, !42}
!1896 = !DILocalVariable(name: "trace_container", arg: 1, scope: !1893, file: !165, line: 161, type: !588)
!1897 = !DILocation(line: 161, column: 35, scope: !1893)
!1898 = !DILocalVariable(name: "trace", arg: 2, scope: !1893, file: !165, line: 161, type: !588)
!1899 = !DILocation(line: 161, column: 61, scope: !1893)
!1900 = !DILocalVariable(name: "subtract", arg: 3, scope: !1893, file: !165, line: 162, type: !42)
!1901 = !DILocation(line: 162, column: 34, scope: !1893)
!1902 = !DILocalVariable(name: "i", scope: !1893, file: !165, line: 164, type: !14)
!1903 = !DILocation(line: 164, column: 13, scope: !1893)
!1904 = !DILocation(line: 165, column: 5, scope: !1905)
!1905 = distinct !DILexicalBlock(scope: !1906, file: !165, line: 165, column: 5)
!1906 = distinct !DILexicalBlock(scope: !1893, file: !165, line: 165, column: 5)
!1907 = !DILocation(line: 165, column: 5, scope: !1906)
!1908 = !DILocation(line: 166, column: 5, scope: !1909)
!1909 = distinct !DILexicalBlock(scope: !1910, file: !165, line: 166, column: 5)
!1910 = distinct !DILexicalBlock(scope: !1893, file: !165, line: 166, column: 5)
!1911 = !DILocation(line: 166, column: 5, scope: !1910)
!1912 = !DILocation(line: 168, column: 5, scope: !1913)
!1913 = distinct !DILexicalBlock(scope: !1914, file: !165, line: 168, column: 5)
!1914 = distinct !DILexicalBlock(scope: !1893, file: !165, line: 168, column: 5)
!1915 = !DILocation(line: 168, column: 5, scope: !1914)
!1916 = !DILocation(line: 169, column: 5, scope: !1917)
!1917 = distinct !DILexicalBlock(scope: !1918, file: !165, line: 169, column: 5)
!1918 = distinct !DILexicalBlock(scope: !1893, file: !165, line: 169, column: 5)
!1919 = !DILocation(line: 169, column: 5, scope: !1918)
!1920 = !DILocation(line: 171, column: 12, scope: !1921)
!1921 = distinct !DILexicalBlock(scope: !1893, file: !165, line: 171, column: 5)
!1922 = !DILocation(line: 171, column: 10, scope: !1921)
!1923 = !DILocation(line: 171, column: 17, scope: !1924)
!1924 = distinct !DILexicalBlock(scope: !1921, file: !165, line: 171, column: 5)
!1925 = !DILocation(line: 171, column: 21, scope: !1924)
!1926 = !DILocation(line: 171, column: 28, scope: !1924)
!1927 = !DILocation(line: 171, column: 19, scope: !1924)
!1928 = !DILocation(line: 171, column: 5, scope: !1921)
!1929 = !DILocation(line: 172, column: 39, scope: !1930)
!1930 = distinct !DILexicalBlock(scope: !1924, file: !165, line: 171, column: 38)
!1931 = !DILocation(line: 172, column: 56, scope: !1930)
!1932 = !DILocation(line: 172, column: 63, scope: !1930)
!1933 = !DILocation(line: 172, column: 69, scope: !1930)
!1934 = !DILocation(line: 172, column: 72, scope: !1930)
!1935 = !DILocation(line: 173, column: 39, scope: !1930)
!1936 = !DILocation(line: 173, column: 46, scope: !1930)
!1937 = !DILocation(line: 173, column: 52, scope: !1930)
!1938 = !DILocation(line: 173, column: 55, scope: !1930)
!1939 = !DILocation(line: 173, column: 62, scope: !1930)
!1940 = !DILocation(line: 172, column: 9, scope: !1930)
!1941 = !DILocation(line: 174, column: 5, scope: !1930)
!1942 = !DILocation(line: 171, column: 34, scope: !1924)
!1943 = !DILocation(line: 171, column: 5, scope: !1924)
!1944 = distinct !{!1944, !1928, !1945, !221}
!1945 = !DILocation(line: 174, column: 5, scope: !1921)
!1946 = !DILocation(line: 175, column: 1, scope: !1893)
!1947 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !786, file: !786, line: 319, type: !855, scopeLine: 320, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !195)
!1948 = !DILocalVariable(name: "a", arg: 1, scope: !1947, file: !786, line: 319, type: !857)
!1949 = !DILocation(line: 319, column: 41, scope: !1947)
!1950 = !DILocation(line: 321, column: 5, scope: !1947)
!1951 = !{i64 2148225661}
!1952 = !DILocalVariable(name: "tmp", scope: !1947, file: !786, line: 322, type: !22)
!1953 = !DILocation(line: 322, column: 11, scope: !1947)
!1954 = !DILocation(line: 322, column: 42, scope: !1947)
!1955 = !DILocation(line: 322, column: 45, scope: !1947)
!1956 = !DILocation(line: 322, column: 25, scope: !1947)
!1957 = !DILocation(line: 323, column: 5, scope: !1947)
!1958 = !{i64 2148225701}
!1959 = !DILocation(line: 324, column: 12, scope: !1947)
!1960 = !DILocation(line: 324, column: 5, scope: !1947)
