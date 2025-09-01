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
@.str.1 = private unnamed_addr constant [55 x i8] c"/home/drc/git/libvsync/verify/simpleht/test_case_add.h\00", align 1
@__PRETTY_FUNCTION__.t0 = private unnamed_addr constant [17 x i8] c"void t0(vsize_t)\00", align 1
@__PRETTY_FUNCTION__.t1 = private unnamed_addr constant [17 x i8] c"void t1(vsize_t)\00", align 1
@__PRETTY_FUNCTION__.t2 = private unnamed_addr constant [17 x i8] c"void t2(vsize_t)\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"d\00", align 1
@__PRETTY_FUNCTION__.post = private unnamed_addr constant [16 x i8] c"void post(void)\00", align 1
@.str.3 = private unnamed_addr constant [12 x i8] c"d->val == k\00", align 1
@.str.4 = private unnamed_addr constant [9 x i8] c"tid < 3U\00", align 1
@.str.5 = private unnamed_addr constant [65 x i8] c"/home/drc/git/libvsync/test/include/test/boilerplate/test_case.h\00", align 1
@__PRETTY_FUNCTION__.run = private unnamed_addr constant [18 x i8] c"void *run(void *)\00", align 1
@g_simpleht = internal global %struct.vsimpleht_s zeroinitializer, align 8, !dbg !54
@g_add = internal global [4 x %struct.trace_s] zeroinitializer, align 16, !dbg !149
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
@g_rem = internal global [4 x %struct.trace_s] zeroinitializer, align 16, !dbg !168
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
@g_buff = internal global i8* null, align 8, !dbg !170
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
define dso_local void @pre() #0 !dbg !180 {
  ret void, !dbg !185
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @t0(i64 noundef %0) #0 !dbg !186 {
  %2 = alloca i64, align 8
  %3 = alloca i8, align 1
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !189, metadata !DIExpression()), !dbg !190
  call void @llvm.dbg.declare(metadata i8* %3, metadata !191, metadata !DIExpression()), !dbg !192
  %4 = load i64, i64* %2, align 8, !dbg !193
  %5 = call zeroext i1 @imap_add(i64 noundef %4, i64 noundef 1, i64 noundef 1), !dbg !194
  %6 = zext i1 %5 to i8, !dbg !192
  store i8 %6, i8* %3, align 1, !dbg !192
  %7 = load i8, i8* %3, align 1, !dbg !195
  %8 = trunc i8 %7 to i1, !dbg !195
  br i1 %8, label %9, label %10, !dbg !198

9:                                                ; preds = %1
  br label %11, !dbg !198

10:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.1, i64 0, i64 0), i32 noundef 16, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t0, i64 0, i64 0)) #5, !dbg !195
  unreachable, !dbg !195

11:                                               ; preds = %9
  ret void, !dbg !199
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @imap_add(i64 noundef %0, i64 noundef %1, i64 noundef %2) #0 !dbg !200 {
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.data_s*, align 8
  %8 = alloca i8, align 1
  store i64 %0, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !203, metadata !DIExpression()), !dbg !204
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !205, metadata !DIExpression()), !dbg !206
  store i64 %2, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !207, metadata !DIExpression()), !dbg !208
  call void @llvm.dbg.declare(metadata %struct.data_s** %7, metadata !209, metadata !DIExpression()), !dbg !216
  %9 = call noalias i8* @malloc(i64 noundef 16) #6, !dbg !217
  %10 = bitcast i8* %9 to %struct.data_s*, !dbg !217
  store %struct.data_s* %10, %struct.data_s** %7, align 8, !dbg !216
  %11 = load i64, i64* %5, align 8, !dbg !218
  %12 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !219
  %13 = getelementptr inbounds %struct.data_s, %struct.data_s* %12, i32 0, i32 0, !dbg !220
  store i64 %11, i64* %13, align 8, !dbg !221
  %14 = load i64, i64* %6, align 8, !dbg !222
  %15 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !223
  %16 = getelementptr inbounds %struct.data_s, %struct.data_s* %15, i32 0, i32 1, !dbg !224
  store i64 %14, i64* %16, align 8, !dbg !225
  call void @llvm.dbg.declare(metadata i8* %8, metadata !226, metadata !DIExpression()), !dbg !227
  %17 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !228
  %18 = getelementptr inbounds %struct.data_s, %struct.data_s* %17, i32 0, i32 0, !dbg !229
  %19 = load i64, i64* %18, align 8, !dbg !229
  %20 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !230
  %21 = bitcast %struct.data_s* %20 to i8*, !dbg !230
  %22 = call i32 @vsimpleht_add(%struct.vsimpleht_s* noundef @g_simpleht, i64 noundef %19, i8* noundef %21), !dbg !231
  %23 = icmp eq i32 %22, 0, !dbg !232
  %24 = zext i1 %23 to i8, !dbg !227
  store i8 %24, i8* %8, align 1, !dbg !227
  %25 = load i8, i8* %8, align 1, !dbg !233
  %26 = trunc i8 %25 to i1, !dbg !233
  br i1 %26, label %27, label %33, !dbg !235

27:                                               ; preds = %3
  %28 = load i64, i64* %4, align 8, !dbg !236
  %29 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %28, !dbg !238
  %30 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !239
  %31 = getelementptr inbounds %struct.data_s, %struct.data_s* %30, i32 0, i32 0, !dbg !240
  %32 = load i64, i64* %31, align 8, !dbg !240
  call void @trace_add(%struct.trace_s* noundef %29, i64 noundef %32), !dbg !241
  br label %36, !dbg !242

33:                                               ; preds = %3
  %34 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !243
  %35 = bitcast %struct.data_s* %34 to i8*, !dbg !243
  call void @free(i8* noundef %35) #6, !dbg !245
  br label %36

36:                                               ; preds = %33, %27
  %37 = load i8, i8* %8, align 1, !dbg !246
  %38 = trunc i8 %37 to i1, !dbg !246
  ret i1 %38, !dbg !247
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @t1(i64 noundef %0) #0 !dbg !248 {
  %2 = alloca i64, align 8
  %3 = alloca i8, align 1
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !249, metadata !DIExpression()), !dbg !250
  call void @llvm.dbg.declare(metadata i8* %3, metadata !251, metadata !DIExpression()), !dbg !252
  %4 = load i64, i64* %2, align 8, !dbg !253
  %5 = call zeroext i1 @imap_add(i64 noundef %4, i64 noundef 2, i64 noundef 2), !dbg !254
  %6 = zext i1 %5 to i8, !dbg !252
  store i8 %6, i8* %3, align 1, !dbg !252
  %7 = load i8, i8* %3, align 1, !dbg !255
  %8 = trunc i8 %7 to i1, !dbg !255
  br i1 %8, label %9, label %10, !dbg !258

9:                                                ; preds = %1
  br label %11, !dbg !258

10:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.1, i64 0, i64 0), i32 noundef 22, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t1, i64 0, i64 0)) #5, !dbg !255
  unreachable, !dbg !255

11:                                               ; preds = %9
  ret void, !dbg !259
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @t2(i64 noundef %0) #0 !dbg !260 {
  %2 = alloca i64, align 8
  %3 = alloca i8, align 1
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !261, metadata !DIExpression()), !dbg !262
  call void @llvm.dbg.declare(metadata i8* %3, metadata !263, metadata !DIExpression()), !dbg !264
  %4 = load i64, i64* %2, align 8, !dbg !265
  %5 = call zeroext i1 @imap_add(i64 noundef %4, i64 noundef 3, i64 noundef 3), !dbg !266
  %6 = zext i1 %5 to i8, !dbg !264
  store i8 %6, i8* %3, align 1, !dbg !264
  %7 = load i8, i8* %3, align 1, !dbg !267
  %8 = trunc i8 %7 to i1, !dbg !267
  br i1 %8, label %9, label %10, !dbg !270

9:                                                ; preds = %1
  br label %11, !dbg !270

10:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.1, i64 0, i64 0), i32 noundef 28, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t2, i64 0, i64 0)) #5, !dbg !267
  unreachable, !dbg !267

11:                                               ; preds = %9
  ret void, !dbg !271
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !272 {
  %1 = alloca i64, align 8
  %2 = alloca %struct.data_s*, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !273, metadata !DIExpression()), !dbg !275
  store i64 1, i64* %1, align 8, !dbg !275
  br label %3, !dbg !276

3:                                                ; preds = %23, %0
  %4 = load i64, i64* %1, align 8, !dbg !277
  %5 = icmp ule i64 %4, 3, !dbg !279
  br i1 %5, label %6, label %26, !dbg !280

6:                                                ; preds = %3
  call void @llvm.dbg.declare(metadata %struct.data_s** %2, metadata !281, metadata !DIExpression()), !dbg !283
  %7 = load i64, i64* %1, align 8, !dbg !284
  %8 = call i8* @imap_get(i64 noundef 3, i64 noundef %7), !dbg !285
  %9 = bitcast i8* %8 to %struct.data_s*, !dbg !285
  store %struct.data_s* %9, %struct.data_s** %2, align 8, !dbg !283
  %10 = load %struct.data_s*, %struct.data_s** %2, align 8, !dbg !286
  %11 = icmp ne %struct.data_s* %10, null, !dbg !286
  br i1 %11, label %12, label %13, !dbg !289

12:                                               ; preds = %6
  br label %14, !dbg !289

13:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.1, i64 0, i64 0), i32 noundef 35, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.post, i64 0, i64 0)) #5, !dbg !286
  unreachable, !dbg !286

14:                                               ; preds = %12
  %15 = load %struct.data_s*, %struct.data_s** %2, align 8, !dbg !290
  %16 = getelementptr inbounds %struct.data_s, %struct.data_s* %15, i32 0, i32 1, !dbg !290
  %17 = load i64, i64* %16, align 8, !dbg !290
  %18 = load i64, i64* %1, align 8, !dbg !290
  %19 = icmp eq i64 %17, %18, !dbg !290
  br i1 %19, label %20, label %21, !dbg !293

20:                                               ; preds = %14
  br label %22, !dbg !293

21:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.1, i64 0, i64 0), i32 noundef 36, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.post, i64 0, i64 0)) #5, !dbg !290
  unreachable, !dbg !290

22:                                               ; preds = %20
  br label %23, !dbg !294

23:                                               ; preds = %22
  %24 = load i64, i64* %1, align 8, !dbg !295
  %25 = add i64 %24, 1, !dbg !295
  store i64 %25, i64* %1, align 8, !dbg !295
  br label %3, !dbg !296, !llvm.loop !297

26:                                               ; preds = %3
  ret void, !dbg !300
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @imap_get(i64 noundef %0, i64 noundef %1) #0 !dbg !301 {
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca %struct.data_s*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !304, metadata !DIExpression()), !dbg !305
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !306, metadata !DIExpression()), !dbg !307
  br label %6, !dbg !308

6:                                                ; preds = %2
  br label %7, !dbg !309

7:                                                ; preds = %6
  %8 = load i64, i64* %3, align 8, !dbg !311
  br label %9, !dbg !311

9:                                                ; preds = %7
  br label %10, !dbg !313

10:                                               ; preds = %9
  br label %11, !dbg !311

11:                                               ; preds = %10
  br label %12, !dbg !309

12:                                               ; preds = %11
  call void @llvm.dbg.declare(metadata %struct.data_s** %5, metadata !315, metadata !DIExpression()), !dbg !316
  %13 = load i64, i64* %4, align 8, !dbg !317
  %14 = call i8* @vsimpleht_get(%struct.vsimpleht_s* noundef @g_simpleht, i64 noundef %13), !dbg !318
  %15 = bitcast i8* %14 to %struct.data_s*, !dbg !318
  store %struct.data_s* %15, %struct.data_s** %5, align 8, !dbg !316
  %16 = load %struct.data_s*, %struct.data_s** %5, align 8, !dbg !319
  %17 = icmp ne %struct.data_s* %16, null, !dbg !319
  br i1 %17, label %18, label %27, !dbg !321

18:                                               ; preds = %12
  %19 = load %struct.data_s*, %struct.data_s** %5, align 8, !dbg !322
  %20 = getelementptr inbounds %struct.data_s, %struct.data_s* %19, i32 0, i32 0, !dbg !322
  %21 = load i64, i64* %20, align 8, !dbg !322
  %22 = load i64, i64* %4, align 8, !dbg !322
  %23 = icmp eq i64 %21, %22, !dbg !322
  br i1 %23, label %24, label %25, !dbg !326

24:                                               ; preds = %18
  br label %26, !dbg !326

25:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.26, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.27, i64 0, i64 0), i32 noundef 171, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.imap_get, i64 0, i64 0)) #5, !dbg !322
  unreachable, !dbg !322

26:                                               ; preds = %24
  br label %27, !dbg !327

27:                                               ; preds = %26, %12
  %28 = load %struct.data_s*, %struct.data_s** %5, align 8, !dbg !328
  %29 = bitcast %struct.data_s* %28 to i8*, !dbg !328
  ret i8* %29, !dbg !329
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !330 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !332, metadata !DIExpression()), !dbg !333
  call void @llvm.dbg.declare(metadata i64* %3, metadata !334, metadata !DIExpression()), !dbg !335
  %4 = load i8*, i8** %2, align 8, !dbg !336
  %5 = ptrtoint i8* %4 to i64, !dbg !337
  store i64 %5, i64* %3, align 8, !dbg !335
  %6 = load i64, i64* %3, align 8, !dbg !338
  %7 = icmp ult i64 %6, 3, !dbg !338
  br i1 %7, label %8, label %9, !dbg !341

8:                                                ; preds = %1
  br label %10, !dbg !341

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.5, i64 0, i64 0), i32 noundef 97, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !338
  unreachable, !dbg !338

10:                                               ; preds = %8
  %11 = load i64, i64* %3, align 8, !dbg !342
  call void @reg(i64 noundef %11), !dbg !343
  %12 = load i64, i64* %3, align 8, !dbg !344
  switch i64 %12, label %19 [
    i64 0, label %13
    i64 1, label %15
    i64 2, label %17
  ], !dbg !345

13:                                               ; preds = %10
  %14 = load i64, i64* %3, align 8, !dbg !346
  call void @t0(i64 noundef %14), !dbg !348
  br label %20, !dbg !349

15:                                               ; preds = %10
  %16 = load i64, i64* %3, align 8, !dbg !350
  call void @t1(i64 noundef %16), !dbg !351
  br label %20, !dbg !352

17:                                               ; preds = %10
  %18 = load i64, i64* %3, align 8, !dbg !353
  call void @t2(i64 noundef %18), !dbg !354
  br label %20, !dbg !355

19:                                               ; preds = %10
  br label %20, !dbg !356

20:                                               ; preds = %19, %17, %15, %13
  %21 = load i64, i64* %3, align 8, !dbg !357
  call void @dereg(i64 noundef %21), !dbg !358
  ret i8* null, !dbg !359
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reg(i64 noundef %0) #0 !dbg !360 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !362, metadata !DIExpression()), !dbg !363
  %3 = load i64, i64* %2, align 8, !dbg !364
  call void @imap_reg(i64 noundef %3), !dbg !365
  ret void, !dbg !366
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @dereg(i64 noundef %0) #0 !dbg !367 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !368, metadata !DIExpression()), !dbg !369
  %3 = load i64, i64* %2, align 8, !dbg !370
  call void @imap_dereg(i64 noundef %3), !dbg !371
  ret void, !dbg !372
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @tc() #0 !dbg !373 {
  call void @init(), !dbg !374
  call void @pre(), !dbg !375
  call void @launch_threads(i64 noundef 3, i8* (i8*)* noundef @run), !dbg !376
  call void @post(), !dbg !377
  call void @fini(), !dbg !378
  ret void, !dbg !379
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !380 {
  call void @imap_init(), !dbg !381
  ret void, !dbg !382
}

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !383 {
  %3 = alloca i64, align 8
  %4 = alloca i8* (i8*)*, align 8
  %5 = alloca %struct.run_info_t*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !386, metadata !DIExpression()), !dbg !387
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %4, metadata !388, metadata !DIExpression()), !dbg !389
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !390, metadata !DIExpression()), !dbg !391
  %6 = load i64, i64* %3, align 8, !dbg !392
  %7 = mul i64 32, %6, !dbg !393
  %8 = call noalias i8* @malloc(i64 noundef %7) #6, !dbg !394
  %9 = bitcast i8* %8 to %struct.run_info_t*, !dbg !394
  store %struct.run_info_t* %9, %struct.run_info_t** %5, align 8, !dbg !391
  %10 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !395
  %11 = load i64, i64* %3, align 8, !dbg !396
  %12 = load i8* (i8*)*, i8* (i8*)** %4, align 8, !dbg !397
  call void @create_threads(%struct.run_info_t* noundef %10, i64 noundef %11, i8* (i8*)* noundef %12, i1 noundef zeroext true), !dbg !398
  %13 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !399
  %14 = load i64, i64* %3, align 8, !dbg !400
  call void @await_threads(%struct.run_info_t* noundef %13, i64 noundef %14), !dbg !401
  %15 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !402
  %16 = bitcast %struct.run_info_t* %15 to i8*, !dbg !402
  call void @free(i8* noundef %16) #6, !dbg !403
  ret void, !dbg !404
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !405 {
  call void @imap_destroy(), !dbg !406
  ret void, !dbg !407
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_reg(i64 noundef %0) #0 !dbg !408 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !409, metadata !DIExpression()), !dbg !410
  br label %3, !dbg !411

3:                                                ; preds = %1
  br label %4, !dbg !412

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !414
  br label %6, !dbg !414

6:                                                ; preds = %4
  br label %7, !dbg !416

7:                                                ; preds = %6
  br label %8, !dbg !414

8:                                                ; preds = %7
  br label %9, !dbg !412

9:                                                ; preds = %8
  call void @vsimpleht_thread_register(%struct.vsimpleht_s* noundef @g_simpleht), !dbg !418
  ret void, !dbg !419
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_dereg(i64 noundef %0) #0 !dbg !420 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !421, metadata !DIExpression()), !dbg !422
  br label %3, !dbg !423

3:                                                ; preds = %1
  br label %4, !dbg !424

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !426
  br label %6, !dbg !426

6:                                                ; preds = %4
  br label %7, !dbg !428

7:                                                ; preds = %6
  br label %8, !dbg !426

8:                                                ; preds = %7
  br label %9, !dbg !424

9:                                                ; preds = %8
  call void @vsimpleht_thread_deregister(%struct.vsimpleht_s* noundef @g_simpleht), !dbg !430
  ret void, !dbg !431
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_init() #0 !dbg !432 {
  %1 = alloca i64, align 8
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !433, metadata !DIExpression()), !dbg !434
  %4 = call i64 @vsimpleht_buff_size(i64 noundef 4), !dbg !435
  store i64 %4, i64* %1, align 8, !dbg !434
  call void @llvm.dbg.declare(metadata i8** %2, metadata !436, metadata !DIExpression()), !dbg !437
  %5 = load i64, i64* %1, align 8, !dbg !438
  %6 = call noalias i8* @malloc(i64 noundef %5) #6, !dbg !439
  store i8* %6, i8** %2, align 8, !dbg !437
  %7 = load i8*, i8** %2, align 8, !dbg !440
  call void @vsimpleht_init(%struct.vsimpleht_s* noundef @g_simpleht, i8* noundef %7, i64 noundef 4, i8 (i64, i64)* noundef @cb_cmp, i64 (i64)* noundef @cb_hash, void (i8*)* noundef @cb_destroy), !dbg !441
  call void @llvm.dbg.declare(metadata i64* %3, metadata !442, metadata !DIExpression()), !dbg !444
  store i64 0, i64* %3, align 8, !dbg !444
  br label %8, !dbg !445

8:                                                ; preds = %16, %0
  %9 = load i64, i64* %3, align 8, !dbg !446
  %10 = icmp ult i64 %9, 4, !dbg !448
  br i1 %10, label %11, label %19, !dbg !449

11:                                               ; preds = %8
  %12 = load i64, i64* %3, align 8, !dbg !450
  %13 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %12, !dbg !452
  call void @trace_init(%struct.trace_s* noundef %13, i64 noundef 8), !dbg !453
  %14 = load i64, i64* %3, align 8, !dbg !454
  %15 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_rem, i64 0, i64 %14, !dbg !455
  call void @trace_init(%struct.trace_s* noundef %15, i64 noundef 8), !dbg !456
  br label %16, !dbg !457

16:                                               ; preds = %11
  %17 = load i64, i64* %3, align 8, !dbg !458
  %18 = add i64 %17, 1, !dbg !458
  store i64 %18, i64* %3, align 8, !dbg !458
  br label %8, !dbg !459, !llvm.loop !460

19:                                               ; preds = %8
  ret void, !dbg !462
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_destroy() #0 !dbg !463 {
  %1 = alloca i64, align 8
  call void @_imap_verify(), !dbg !464
  call void @llvm.dbg.declare(metadata i64* %1, metadata !465, metadata !DIExpression()), !dbg !467
  store i64 0, i64* %1, align 8, !dbg !467
  br label %2, !dbg !468

2:                                                ; preds = %10, %0
  %3 = load i64, i64* %1, align 8, !dbg !469
  %4 = icmp ult i64 %3, 4, !dbg !471
  br i1 %4, label %5, label %13, !dbg !472

5:                                                ; preds = %2
  %6 = load i64, i64* %1, align 8, !dbg !473
  %7 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %6, !dbg !475
  call void @trace_destroy(%struct.trace_s* noundef %7), !dbg !476
  %8 = load i64, i64* %1, align 8, !dbg !477
  %9 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_rem, i64 0, i64 %8, !dbg !478
  call void @trace_destroy(%struct.trace_s* noundef %9), !dbg !479
  br label %10, !dbg !480

10:                                               ; preds = %5
  %11 = load i64, i64* %1, align 8, !dbg !481
  %12 = add i64 %11, 1, !dbg !481
  store i64 %12, i64* %1, align 8, !dbg !481
  br label %2, !dbg !482, !llvm.loop !483

13:                                               ; preds = %2
  call void @vsimpleht_destroy(%struct.vsimpleht_s* noundef @g_simpleht), !dbg !485
  %14 = load i8*, i8** @g_buff, align 8, !dbg !486
  call void @free(i8* noundef %14) #6, !dbg !487
  store i8* null, i8** @g_buff, align 8, !dbg !488
  ret void, !dbg !489
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !490 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @tc(), !dbg !493
  ret i32 0, !dbg !494
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i32 @vsimpleht_add(%struct.vsimpleht_s* noundef %0, i64 noundef %1, i8* noundef %2) #0 !dbg !495 {
  %4 = alloca %struct.vsimpleht_s*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i8*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %4, metadata !500, metadata !DIExpression()), !dbg !501
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !502, metadata !DIExpression()), !dbg !503
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !504, metadata !DIExpression()), !dbg !505
  %7 = load i64, i64* %5, align 8, !dbg !506
  %8 = icmp ne i64 %7, 0, !dbg !506
  br i1 %8, label %9, label %10, !dbg !509

9:                                                ; preds = %3
  br label %11, !dbg !509

10:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 243, i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @__PRETTY_FUNCTION__.vsimpleht_add, i64 0, i64 0)) #5, !dbg !506
  unreachable, !dbg !506

11:                                               ; preds = %9
  %12 = load i8*, i8** %6, align 8, !dbg !510
  %13 = icmp ne i8* %12, null, !dbg !510
  br i1 %13, label %14, label %15, !dbg !513

14:                                               ; preds = %11
  br label %16, !dbg !513

15:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.8, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 244, i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @__PRETTY_FUNCTION__.vsimpleht_add, i64 0, i64 0)) #5, !dbg !510
  unreachable, !dbg !510

16:                                               ; preds = %14
  %17 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !514
  call void @_vsimpleht_give_cleanup_a_chance(%struct.vsimpleht_s* noundef %17), !dbg !515
  %18 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !516
  %19 = load i64, i64* %5, align 8, !dbg !517
  %20 = load i8*, i8** %6, align 8, !dbg !518
  %21 = call i32 @_vsimpleht_add(%struct.vsimpleht_s* noundef %18, i64 noundef %19, i8* noundef %20), !dbg !519
  ret i32 %21, !dbg !520
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_add(%struct.trace_s* noundef %0, i64 noundef %1) #0 !dbg !521 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !525, metadata !DIExpression()), !dbg !526
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !527, metadata !DIExpression()), !dbg !528
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !529
  %6 = icmp ne %struct.trace_s* %5, null, !dbg !529
  br i1 %6, label %7, label %8, !dbg !532

7:                                                ; preds = %2
  br label %9, !dbg !532

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 155, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__.trace_add, i64 0, i64 0)) #5, !dbg !529
  unreachable, !dbg !529

9:                                                ; preds = %7
  %10 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !533
  %11 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %10, i32 0, i32 3, !dbg !533
  %12 = load i8, i8* %11, align 8, !dbg !533
  %13 = trunc i8 %12 to i1, !dbg !533
  br i1 %13, label %14, label %15, !dbg !536

14:                                               ; preds = %9
  br label %16, !dbg !536

15:                                               ; preds = %9
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 156, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__.trace_add, i64 0, i64 0)) #5, !dbg !533
  unreachable, !dbg !533

16:                                               ; preds = %14
  %17 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !537
  %18 = load i64, i64* %4, align 8, !dbg !538
  call void @_trace_add_or_rem_occurrences(%struct.trace_s* noundef %17, i64 noundef %18, i64 noundef 1, i1 noundef zeroext false), !dbg !539
  ret void, !dbg !540
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @_vsimpleht_give_cleanup_a_chance(%struct.vsimpleht_s* noundef %0) #0 !dbg !541 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !544, metadata !DIExpression()), !dbg !545
  %3 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !546
  %4 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %3, i32 0, i32 7, !dbg !548
  %5 = call zeroext i1 @rwlock_acquired_by_writer(%struct.rwlock_s* noundef %4), !dbg !549
  br i1 %5, label %6, label %18, !dbg !550

6:                                                ; preds = %1
  %7 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !551
  %8 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %7, i32 0, i32 7, !dbg !551
  %9 = call zeroext i1 @rwlock_acquired_by_readers(%struct.rwlock_s* noundef %8), !dbg !551
  br i1 %9, label %10, label %12, !dbg !551

10:                                               ; preds = %6
  br i1 true, label %11, label %12, !dbg !555

11:                                               ; preds = %10
  br label %13, !dbg !555

12:                                               ; preds = %10, %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([112 x i8], [112 x i8]* @.str.10, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 487, i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @__PRETTY_FUNCTION__._vsimpleht_give_cleanup_a_chance, i64 0, i64 0)) #5, !dbg !551
  unreachable, !dbg !551

13:                                               ; preds = %11
  %14 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !556
  %15 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %14, i32 0, i32 7, !dbg !557
  call void @rwlock_read_release(%struct.rwlock_s* noundef %15), !dbg !558
  %16 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !559
  %17 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %16, i32 0, i32 7, !dbg !560
  call void @rwlock_read_acquire(%struct.rwlock_s* noundef %17), !dbg !561
  br label %18, !dbg !562

18:                                               ; preds = %13, %1
  ret void, !dbg !563
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @_vsimpleht_add(%struct.vsimpleht_s* noundef %0, i64 noundef %1, i8* noundef %2) #0 !dbg !564 {
  %4 = alloca i32, align 4
  %5 = alloca %struct.vsimpleht_s*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca i8*, align 8
  %11 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %5, metadata !565, metadata !DIExpression()), !dbg !566
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !567, metadata !DIExpression()), !dbg !568
  store i8* %2, i8** %7, align 8
  call void @llvm.dbg.declare(metadata i8** %7, metadata !569, metadata !DIExpression()), !dbg !570
  call void @llvm.dbg.declare(metadata i64* %8, metadata !571, metadata !DIExpression()), !dbg !572
  store i64 0, i64* %8, align 8, !dbg !572
  call void @llvm.dbg.declare(metadata i64* %9, metadata !573, metadata !DIExpression()), !dbg !574
  store i64 0, i64* %9, align 8, !dbg !574
  call void @llvm.dbg.declare(metadata i8** %10, metadata !575, metadata !DIExpression()), !dbg !576
  store i8* null, i8** %10, align 8, !dbg !576
  call void @llvm.dbg.declare(metadata i64* %11, metadata !577, metadata !DIExpression()), !dbg !578
  store i64 0, i64* %11, align 8, !dbg !578
  %12 = load i64, i64* %6, align 8, !dbg !579
  %13 = icmp ne i64 %12, 0, !dbg !579
  br i1 %13, label %14, label %16, !dbg !579

14:                                               ; preds = %3
  br i1 true, label %15, label %16, !dbg !582

15:                                               ; preds = %14
  br label %17, !dbg !582

16:                                               ; preds = %14, %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.14, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 423, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !579
  unreachable, !dbg !579

17:                                               ; preds = %15
  %18 = load i8*, i8** %7, align 8, !dbg !583
  %19 = icmp ne i8* %18, null, !dbg !583
  br i1 %19, label %20, label %22, !dbg !583

20:                                               ; preds = %17
  br i1 true, label %21, label %22, !dbg !586

21:                                               ; preds = %20
  br label %23, !dbg !586

22:                                               ; preds = %20, %17
  call void @__assert_fail(i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @.str.16, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 424, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !583
  unreachable, !dbg !583

23:                                               ; preds = %21
  %24 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !587
  %25 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %24, i32 0, i32 3, !dbg !589
  %26 = load i64 (i64)*, i64 (i64)** %25, align 8, !dbg !589
  %27 = load i64, i64* %6, align 8, !dbg !590
  %28 = call i64 %26(i64 noundef %27), !dbg !587
  store i64 %28, i64* %8, align 8, !dbg !591
  br label %29, !dbg !592

29:                                               ; preds = %126, %23
  %30 = load i64, i64* %11, align 8, !dbg !593
  %31 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !595
  %32 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %31, i32 0, i32 0, !dbg !596
  %33 = load i64, i64* %32, align 8, !dbg !596
  %34 = icmp ult i64 %30, %33, !dbg !597
  br i1 %34, label %35, label %131, !dbg !598

35:                                               ; preds = %29
  %36 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !599
  %37 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %36, i32 0, i32 0, !dbg !601
  %38 = load i64, i64* %37, align 8, !dbg !601
  %39 = sub i64 %38, 1, !dbg !602
  %40 = load i64, i64* %8, align 8, !dbg !603
  %41 = and i64 %40, %39, !dbg !603
  store i64 %41, i64* %8, align 8, !dbg !603
  %42 = load i64, i64* %8, align 8, !dbg !604
  %43 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !604
  %44 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %43, i32 0, i32 0, !dbg !604
  %45 = load i64, i64* %44, align 8, !dbg !604
  %46 = icmp ult i64 %42, %45, !dbg !604
  br i1 %46, label %47, label %48, !dbg !607

47:                                               ; preds = %35
  br label %49, !dbg !607

48:                                               ; preds = %35
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.17, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 431, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !604
  unreachable, !dbg !604

49:                                               ; preds = %47
  %50 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !608
  %51 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %50, i32 0, i32 1, !dbg !609
  %52 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %51, align 8, !dbg !609
  %53 = load i64, i64* %8, align 8, !dbg !610
  %54 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %52, i64 %53, !dbg !608
  %55 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %54, i32 0, i32 0, !dbg !611
  %56 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %55), !dbg !612
  %57 = ptrtoint i8* %56 to i64, !dbg !613
  store i64 %57, i64* %9, align 8, !dbg !614
  %58 = load i64, i64* %9, align 8, !dbg !615
  %59 = icmp eq i64 %58, 0, !dbg !617
  br i1 %59, label %60, label %84, !dbg !618

60:                                               ; preds = %49
  %61 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !619
  %62 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %61, i32 0, i32 1, !dbg !621
  %63 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %62, align 8, !dbg !621
  %64 = load i64, i64* %8, align 8, !dbg !622
  %65 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %63, i64 %64, !dbg !619
  %66 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %65, i32 0, i32 0, !dbg !623
  %67 = load i64, i64* %6, align 8, !dbg !624
  %68 = inttoptr i64 %67 to i8*, !dbg !625
  %69 = call i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %66, i8* noundef null, i8* noundef %68), !dbg !626
  %70 = ptrtoint i8* %69 to i64, !dbg !627
  store i64 %70, i64* %9, align 8, !dbg !628
  %71 = load i64, i64* %9, align 8, !dbg !629
  %72 = icmp ne i64 %71, 0, !dbg !631
  br i1 %72, label %73, label %83, !dbg !632

73:                                               ; preds = %60
  %74 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !633
  %75 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %74, i32 0, i32 2, !dbg !634
  %76 = load i8 (i64, i64)*, i8 (i64, i64)** %75, align 8, !dbg !634
  %77 = load i64, i64* %6, align 8, !dbg !635
  %78 = load i64, i64* %9, align 8, !dbg !636
  %79 = call signext i8 %76(i64 noundef %77, i64 noundef %78), !dbg !633
  %80 = sext i8 %79 to i32, !dbg !633
  %81 = icmp ne i32 %80, 0, !dbg !637
  br i1 %81, label %82, label %83, !dbg !638

82:                                               ; preds = %73
  br label %126, !dbg !639

83:                                               ; preds = %73, %60
  br label %95, !dbg !641

84:                                               ; preds = %49
  %85 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !642
  %86 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %85, i32 0, i32 2, !dbg !644
  %87 = load i8 (i64, i64)*, i8 (i64, i64)** %86, align 8, !dbg !644
  %88 = load i64, i64* %6, align 8, !dbg !645
  %89 = load i64, i64* %9, align 8, !dbg !646
  %90 = call signext i8 %87(i64 noundef %88, i64 noundef %89), !dbg !642
  %91 = sext i8 %90 to i32, !dbg !642
  %92 = icmp ne i32 %91, 0, !dbg !647
  br i1 %92, label %93, label %94, !dbg !648

93:                                               ; preds = %84
  br label %126, !dbg !649

94:                                               ; preds = %84
  br label %95

95:                                               ; preds = %94, %83
  %96 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !651
  %97 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %96, i32 0, i32 2, !dbg !651
  %98 = load i8 (i64, i64)*, i8 (i64, i64)** %97, align 8, !dbg !651
  %99 = load i64, i64* %6, align 8, !dbg !651
  %100 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !651
  %101 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %100, i32 0, i32 1, !dbg !651
  %102 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %101, align 8, !dbg !651
  %103 = load i64, i64* %8, align 8, !dbg !651
  %104 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %102, i64 %103, !dbg !651
  %105 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %104, i32 0, i32 0, !dbg !651
  %106 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %105), !dbg !651
  %107 = ptrtoint i8* %106 to i64, !dbg !651
  %108 = call signext i8 %98(i64 noundef %99, i64 noundef %107), !dbg !651
  %109 = sext i8 %108 to i32, !dbg !651
  %110 = icmp eq i32 %109, 0, !dbg !651
  br i1 %110, label %111, label %112, !dbg !654

111:                                              ; preds = %95
  br label %113, !dbg !654

112:                                              ; preds = %95
  call void @__assert_fail(i8* noundef getelementptr inbounds ([79 x i8], [79 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 451, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !651
  unreachable, !dbg !651

113:                                              ; preds = %111
  %114 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !655
  %115 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %114, i32 0, i32 1, !dbg !656
  %116 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %115, align 8, !dbg !656
  %117 = load i64, i64* %8, align 8, !dbg !657
  %118 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %116, i64 %117, !dbg !655
  %119 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %118, i32 0, i32 1, !dbg !658
  %120 = load i8*, i8** %7, align 8, !dbg !659
  %121 = call i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %119, i8* noundef null, i8* noundef %120), !dbg !660
  store i8* %121, i8** %10, align 8, !dbg !661
  %122 = load i8*, i8** %10, align 8, !dbg !662
  %123 = icmp eq i8* %122, null, !dbg !663
  %124 = zext i1 %123 to i64, !dbg !664
  %125 = select i1 %123, i32 0, i32 2, !dbg !664
  store i32 %125, i32* %4, align 4, !dbg !665
  br label %132, !dbg !665

126:                                              ; preds = %93, %82
  %127 = load i64, i64* %11, align 8, !dbg !666
  %128 = add i64 %127, 1, !dbg !666
  store i64 %128, i64* %11, align 8, !dbg !666
  %129 = load i64, i64* %8, align 8, !dbg !667
  %130 = add i64 %129, 1, !dbg !667
  store i64 %130, i64* %8, align 8, !dbg !667
  br label %29, !dbg !668, !llvm.loop !669

131:                                              ; preds = %29
  store i32 1, i32* %4, align 4, !dbg !671
  br label %132, !dbg !671

132:                                              ; preds = %131, %113
  %133 = load i32, i32* %4, align 4, !dbg !672
  ret i32 %133, !dbg !672
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @rwlock_acquired_by_writer(%struct.rwlock_s* noundef %0) #0 !dbg !673 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !677, metadata !DIExpression()), !dbg !678
  %3 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !679
  %4 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %3, i32 0, i32 1, !dbg !680
  %5 = call zeroext i8 @vatomic8_read_rlx(%struct.vatomic8_s* noundef %4), !dbg !681
  %6 = zext i8 %5 to i32, !dbg !681
  %7 = icmp eq i32 %6, 1, !dbg !682
  ret i1 %7, !dbg !683
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @rwlock_acquired_by_readers(%struct.rwlock_s* noundef %0) #0 !dbg !684 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !685, metadata !DIExpression()), !dbg !686
  br label %3, !dbg !687

3:                                                ; preds = %1
  br label %4, !dbg !688

4:                                                ; preds = %3
  %5 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !690
  br label %6, !dbg !690

6:                                                ; preds = %4
  br label %7, !dbg !692

7:                                                ; preds = %6
  br label %8, !dbg !690

8:                                                ; preds = %7
  br label %9, !dbg !688

9:                                                ; preds = %8
  ret i1 true, !dbg !694
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_read_release(%struct.rwlock_s* noundef %0) #0 !dbg !695 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !698, metadata !DIExpression()), !dbg !699
  call void @llvm.dbg.declare(metadata i32* %3, metadata !700, metadata !DIExpression()), !dbg !701
  %4 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !702
  %5 = call i32 @_rwlock_get_tid(%struct.rwlock_s* noundef %4), !dbg !703
  store i32 %5, i32* %3, align 4, !dbg !701
  %6 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !704
  %7 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %6, i32 0, i32 0, !dbg !705
  %8 = load i32, i32* %3, align 4, !dbg !706
  %9 = zext i32 %8 to i64, !dbg !704
  %10 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %7, i64 0, i64 %9, !dbg !704
  %11 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef %10) #6, !dbg !707
  ret void, !dbg !708
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_read_acquire(%struct.rwlock_s* noundef %0) #0 !dbg !709 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !710, metadata !DIExpression()), !dbg !711
  call void @llvm.dbg.declare(metadata i32* %3, metadata !712, metadata !DIExpression()), !dbg !713
  %4 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !714
  %5 = call i32 @_rwlock_get_tid(%struct.rwlock_s* noundef %4), !dbg !715
  store i32 %5, i32* %3, align 4, !dbg !713
  %6 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !716
  %7 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %6, i32 0, i32 0, !dbg !717
  %8 = load i32, i32* %3, align 4, !dbg !718
  %9 = zext i32 %8 to i64, !dbg !716
  %10 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %7, i64 0, i64 %9, !dbg !716
  %11 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef %10) #6, !dbg !719
  ret void, !dbg !720
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i8 @vatomic8_read_rlx(%struct.vatomic8_s* noundef %0) #0 !dbg !721 {
  %2 = alloca %struct.vatomic8_s*, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  store %struct.vatomic8_s* %0, %struct.vatomic8_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic8_s** %2, metadata !727, metadata !DIExpression()), !dbg !728
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !729, !srcloc !730
  call void @llvm.dbg.declare(metadata i8* %3, metadata !731, metadata !DIExpression()), !dbg !732
  %5 = load %struct.vatomic8_s*, %struct.vatomic8_s** %2, align 8, !dbg !733
  %6 = getelementptr inbounds %struct.vatomic8_s, %struct.vatomic8_s* %5, i32 0, i32 0, !dbg !734
  %7 = load atomic i8, i8* %6 monotonic, align 1, !dbg !735
  store i8 %7, i8* %4, align 1, !dbg !735
  %8 = load i8, i8* %4, align 1, !dbg !735
  store i8 %8, i8* %3, align 1, !dbg !732
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !736, !srcloc !737
  %9 = load i8, i8* %3, align 1, !dbg !738
  ret i8 %9, !dbg !739
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @_rwlock_get_tid(%struct.rwlock_s* noundef %0) #0 !dbg !740 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !743, metadata !DIExpression()), !dbg !744
  %3 = load i32, i32* @g_tid, align 4, !dbg !745
  %4 = icmp eq i32 %3, 3, !dbg !747
  br i1 %4, label %5, label %14, !dbg !748

5:                                                ; preds = %1
  %6 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !749
  %7 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %6, i32 0, i32 2, !dbg !751
  %8 = call i32 @vatomic32_get_inc(%struct.vatomic32_s* noundef %7), !dbg !752
  store i32 %8, i32* @g_tid, align 4, !dbg !753
  %9 = load i32, i32* @g_tid, align 4, !dbg !754
  %10 = icmp ult i32 %9, 3, !dbg !754
  br i1 %10, label %11, label %12, !dbg !757

11:                                               ; preds = %5
  br label %13, !dbg !757

12:                                               ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.12, i64 0, i64 0), i32 noundef 93, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__._rwlock_get_tid, i64 0, i64 0)) #5, !dbg !754
  unreachable, !dbg !754

13:                                               ; preds = %11
  br label %14, !dbg !758

14:                                               ; preds = %13, %1
  %15 = load i32, i32* @g_tid, align 4, !dbg !759
  ret i32 %15, !dbg !760
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc(%struct.vatomic32_s* noundef %0) #0 !dbg !761 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !766, metadata !DIExpression()), !dbg !767
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !768
  %4 = call i32 @vatomic32_get_add(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !769
  ret i32 %4, !dbg !770
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !771 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !774, metadata !DIExpression()), !dbg !775
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !776, metadata !DIExpression()), !dbg !777
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !778, !srcloc !779
  call void @llvm.dbg.declare(metadata i32* %5, metadata !780, metadata !DIExpression()), !dbg !781
  %8 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !782
  %9 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %8, i32 0, i32 0, !dbg !783
  %10 = load i32, i32* %4, align 4, !dbg !784
  store i32 %10, i32* %6, align 4, !dbg !785
  %11 = load i32, i32* %6, align 4, !dbg !785
  %12 = atomicrmw add i32* %9, i32 %11 seq_cst, align 4, !dbg !785
  store i32 %12, i32* %7, align 4, !dbg !785
  %13 = load i32, i32* %7, align 4, !dbg !785
  store i32 %13, i32* %5, align 4, !dbg !781
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !786, !srcloc !787
  %14 = load i32, i32* %5, align 4, !dbg !788
  ret i32 %14, !dbg !789
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %0) #0 !dbg !790 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !795, metadata !DIExpression()), !dbg !796
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !797, !srcloc !798
  call void @llvm.dbg.declare(metadata i8** %3, metadata !799, metadata !DIExpression()), !dbg !800
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !801
  %6 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %5, i32 0, i32 0, !dbg !802
  %7 = bitcast i8** %6 to i64*, !dbg !803
  %8 = bitcast i8** %4 to i64*, !dbg !803
  %9 = load atomic i64, i64* %7 seq_cst, align 8, !dbg !803
  store i64 %9, i64* %8, align 8, !dbg !803
  %10 = bitcast i64* %8 to i8**, !dbg !803
  %11 = load i8*, i8** %10, align 8, !dbg !803
  store i8* %11, i8** %3, align 8, !dbg !800
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !804, !srcloc !805
  %12 = load i8*, i8** %3, align 8, !dbg !806
  ret i8* %12, !dbg !807
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !808 {
  %4 = alloca %struct.vatomicptr_s*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i8*, align 8
  %9 = alloca i8, align 1
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %4, metadata !812, metadata !DIExpression()), !dbg !813
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !814, metadata !DIExpression()), !dbg !815
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !816, metadata !DIExpression()), !dbg !817
  call void @llvm.dbg.declare(metadata i8** %7, metadata !818, metadata !DIExpression()), !dbg !819
  %10 = load i8*, i8** %5, align 8, !dbg !820
  store i8* %10, i8** %7, align 8, !dbg !819
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !821, !srcloc !822
  %11 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %4, align 8, !dbg !823
  %12 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %11, i32 0, i32 0, !dbg !824
  %13 = load i8*, i8** %6, align 8, !dbg !825
  store i8* %13, i8** %8, align 8, !dbg !826
  %14 = bitcast i8** %12 to i64*, !dbg !826
  %15 = bitcast i8** %7 to i64*, !dbg !826
  %16 = bitcast i8** %8 to i64*, !dbg !826
  %17 = load i64, i64* %15, align 8, !dbg !826
  %18 = load i64, i64* %16, align 8, !dbg !826
  %19 = cmpxchg i64* %14, i64 %17, i64 %18 seq_cst seq_cst, align 8, !dbg !826
  %20 = extractvalue { i64, i1 } %19, 0, !dbg !826
  %21 = extractvalue { i64, i1 } %19, 1, !dbg !826
  br i1 %21, label %23, label %22, !dbg !826

22:                                               ; preds = %3
  store i64 %20, i64* %15, align 8, !dbg !826
  br label %23, !dbg !826

23:                                               ; preds = %22, %3
  %24 = zext i1 %21 to i8, !dbg !826
  store i8 %24, i8* %9, align 1, !dbg !826
  %25 = load i8, i8* %9, align 1, !dbg !826
  %26 = trunc i8 %25 to i1, !dbg !826
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !827, !srcloc !828
  %27 = load i8*, i8** %7, align 8, !dbg !829
  ret i8* %27, !dbg !830
}

; Function Attrs: noinline nounwind uwtable
define internal void @_trace_add_or_rem_occurrences(%struct.trace_s* noundef %0, i64 noundef %1, i64 noundef %2, i1 noundef zeroext %3) #0 !dbg !831 {
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  %10 = alloca i8, align 1
  store %struct.trace_s* %0, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !834, metadata !DIExpression()), !dbg !835
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !836, metadata !DIExpression()), !dbg !837
  store i64 %2, i64* %7, align 8
  call void @llvm.dbg.declare(metadata i64* %7, metadata !838, metadata !DIExpression()), !dbg !839
  %11 = zext i1 %3 to i8
  store i8 %11, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !840, metadata !DIExpression()), !dbg !841
  call void @llvm.dbg.declare(metadata i64* %9, metadata !842, metadata !DIExpression()), !dbg !843
  store i64 0, i64* %9, align 8, !dbg !843
  call void @llvm.dbg.declare(metadata i8* %10, metadata !844, metadata !DIExpression()), !dbg !845
  store i8 0, i8* %10, align 1, !dbg !845
  %12 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !846
  %13 = icmp ne %struct.trace_s* %12, null, !dbg !846
  br i1 %13, label %14, label %15, !dbg !849

14:                                               ; preds = %4
  br label %16, !dbg !849

15:                                               ; preds = %4
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 128, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !846
  unreachable, !dbg !846

16:                                               ; preds = %14
  %17 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !850
  %18 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %17, i32 0, i32 3, !dbg !850
  %19 = load i8, i8* %18, align 8, !dbg !850
  %20 = trunc i8 %19 to i1, !dbg !850
  br i1 %20, label %21, label %22, !dbg !853

21:                                               ; preds = %16
  br label %23, !dbg !853

22:                                               ; preds = %16
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 129, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !850
  unreachable, !dbg !850

23:                                               ; preds = %21
  %24 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !854
  %25 = load i64, i64* %6, align 8, !dbg !855
  %26 = call zeroext i1 @trace_find_unit_idx(%struct.trace_s* noundef %24, i64 noundef %25, i64* noundef %9), !dbg !856
  %27 = zext i1 %26 to i8, !dbg !857
  store i8 %27, i8* %10, align 1, !dbg !857
  %28 = load i8, i8* %8, align 1, !dbg !858
  %29 = trunc i8 %28 to i1, !dbg !858
  br i1 %29, label %30, label %57, !dbg !860

30:                                               ; preds = %23
  %31 = load i8, i8* %10, align 1, !dbg !861
  %32 = trunc i8 %31 to i1, !dbg !861
  br i1 %32, label %33, label %34, !dbg !865

33:                                               ; preds = %30
  br label %35, !dbg !865

34:                                               ; preds = %30
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.22, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 134, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !861
  unreachable, !dbg !861

35:                                               ; preds = %33
  %36 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !866
  %37 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %36, i32 0, i32 0, !dbg !866
  %38 = load %struct.trace_unit_s*, %struct.trace_unit_s** %37, align 8, !dbg !866
  %39 = load i64, i64* %9, align 8, !dbg !866
  %40 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %38, i64 %39, !dbg !866
  %41 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %40, i32 0, i32 1, !dbg !866
  %42 = load i64, i64* %41, align 8, !dbg !866
  %43 = load i64, i64* %7, align 8, !dbg !866
  %44 = icmp uge i64 %42, %43, !dbg !866
  br i1 %44, label %45, label %46, !dbg !869

45:                                               ; preds = %35
  br label %47, !dbg !869

46:                                               ; preds = %35
  call void @__assert_fail(i8* noundef getelementptr inbounds ([33 x i8], [33 x i8]* @.str.23, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 135, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !866
  unreachable, !dbg !866

47:                                               ; preds = %45
  %48 = load i64, i64* %7, align 8, !dbg !870
  %49 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !871
  %50 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %49, i32 0, i32 0, !dbg !872
  %51 = load %struct.trace_unit_s*, %struct.trace_unit_s** %50, align 8, !dbg !872
  %52 = load i64, i64* %9, align 8, !dbg !873
  %53 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %51, i64 %52, !dbg !871
  %54 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %53, i32 0, i32 1, !dbg !874
  %55 = load i64, i64* %54, align 8, !dbg !875
  %56 = sub i64 %55, %48, !dbg !875
  store i64 %56, i64* %54, align 8, !dbg !875
  br label %97, !dbg !876

57:                                               ; preds = %23
  %58 = load i8, i8* %10, align 1, !dbg !877
  %59 = trunc i8 %58 to i1, !dbg !877
  br i1 %59, label %87, label %60, !dbg !879

60:                                               ; preds = %57
  %61 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !880
  %62 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %61, i32 0, i32 1, !dbg !882
  %63 = load i64, i64* %62, align 8, !dbg !883
  %64 = add i64 %63, 1, !dbg !883
  store i64 %64, i64* %62, align 8, !dbg !883
  store i64 %63, i64* %9, align 8, !dbg !884
  %65 = load i64, i64* %9, align 8, !dbg !885
  %66 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !887
  %67 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %66, i32 0, i32 2, !dbg !888
  %68 = load i64, i64* %67, align 8, !dbg !888
  %69 = icmp uge i64 %65, %68, !dbg !889
  br i1 %69, label %70, label %72, !dbg !890

70:                                               ; preds = %60
  %71 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !891
  call void @trace_extend(%struct.trace_s* noundef %71), !dbg !893
  br label %72, !dbg !894

72:                                               ; preds = %70, %60
  %73 = load i64, i64* %6, align 8, !dbg !895
  %74 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !896
  %75 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %74, i32 0, i32 0, !dbg !897
  %76 = load %struct.trace_unit_s*, %struct.trace_unit_s** %75, align 8, !dbg !897
  %77 = load i64, i64* %9, align 8, !dbg !898
  %78 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %76, i64 %77, !dbg !896
  %79 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %78, i32 0, i32 0, !dbg !899
  store i64 %73, i64* %79, align 8, !dbg !900
  %80 = load i64, i64* %7, align 8, !dbg !901
  %81 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !902
  %82 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %81, i32 0, i32 0, !dbg !903
  %83 = load %struct.trace_unit_s*, %struct.trace_unit_s** %82, align 8, !dbg !903
  %84 = load i64, i64* %9, align 8, !dbg !904
  %85 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %83, i64 %84, !dbg !902
  %86 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %85, i32 0, i32 1, !dbg !905
  store i64 %80, i64* %86, align 8, !dbg !906
  br label %97, !dbg !907

87:                                               ; preds = %57
  %88 = load i64, i64* %7, align 8, !dbg !908
  %89 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !910
  %90 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %89, i32 0, i32 0, !dbg !911
  %91 = load %struct.trace_unit_s*, %struct.trace_unit_s** %90, align 8, !dbg !911
  %92 = load i64, i64* %9, align 8, !dbg !912
  %93 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %91, i64 %92, !dbg !910
  %94 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %93, i32 0, i32 1, !dbg !913
  %95 = load i64, i64* %94, align 8, !dbg !914
  %96 = add i64 %95, %88, !dbg !914
  store i64 %96, i64* %94, align 8, !dbg !914
  br label %97

97:                                               ; preds = %47, %87, %72
  ret void, !dbg !915
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @trace_find_unit_idx(%struct.trace_s* noundef %0, i64 noundef %1, i64* noundef %2) #0 !dbg !916 {
  %4 = alloca i1, align 1
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64*, align 8
  %8 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !920, metadata !DIExpression()), !dbg !921
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !922, metadata !DIExpression()), !dbg !923
  store i64* %2, i64** %7, align 8
  call void @llvm.dbg.declare(metadata i64** %7, metadata !924, metadata !DIExpression()), !dbg !925
  call void @llvm.dbg.declare(metadata i64* %8, metadata !926, metadata !DIExpression()), !dbg !927
  store i64 0, i64* %8, align 8, !dbg !927
  %9 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !928
  %10 = icmp ne %struct.trace_s* %9, null, !dbg !928
  br i1 %10, label %11, label %12, !dbg !931

11:                                               ; preds = %3
  br label %13, !dbg !931

12:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 110, i8* noundef getelementptr inbounds ([62 x i8], [62 x i8]* @__PRETTY_FUNCTION__.trace_find_unit_idx, i64 0, i64 0)) #5, !dbg !928
  unreachable, !dbg !928

13:                                               ; preds = %11
  %14 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !932
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 3, !dbg !932
  %16 = load i8, i8* %15, align 8, !dbg !932
  %17 = trunc i8 %16 to i1, !dbg !932
  br i1 %17, label %18, label %19, !dbg !935

18:                                               ; preds = %13
  br label %20, !dbg !935

19:                                               ; preds = %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 111, i8* noundef getelementptr inbounds ([62 x i8], [62 x i8]* @__PRETTY_FUNCTION__.trace_find_unit_idx, i64 0, i64 0)) #5, !dbg !932
  unreachable, !dbg !932

20:                                               ; preds = %18
  store i64 0, i64* %8, align 8, !dbg !936
  br label %21, !dbg !938

21:                                               ; preds = %41, %20
  %22 = load i64, i64* %8, align 8, !dbg !939
  %23 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !941
  %24 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %23, i32 0, i32 1, !dbg !942
  %25 = load i64, i64* %24, align 8, !dbg !942
  %26 = icmp ult i64 %22, %25, !dbg !943
  br i1 %26, label %27, label %44, !dbg !944

27:                                               ; preds = %21
  %28 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !945
  %29 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %28, i32 0, i32 0, !dbg !948
  %30 = load %struct.trace_unit_s*, %struct.trace_unit_s** %29, align 8, !dbg !948
  %31 = load i64, i64* %8, align 8, !dbg !949
  %32 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %30, i64 %31, !dbg !945
  %33 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %32, i32 0, i32 0, !dbg !950
  %34 = load i64, i64* %33, align 8, !dbg !950
  %35 = load i64, i64* %6, align 8, !dbg !951
  %36 = icmp eq i64 %34, %35, !dbg !952
  br i1 %36, label %37, label %40, !dbg !953

37:                                               ; preds = %27
  %38 = load i64, i64* %8, align 8, !dbg !954
  %39 = load i64*, i64** %7, align 8, !dbg !956
  store i64 %38, i64* %39, align 8, !dbg !957
  store i1 true, i1* %4, align 1, !dbg !958
  br label %45, !dbg !958

40:                                               ; preds = %27
  br label %41, !dbg !959

41:                                               ; preds = %40
  %42 = load i64, i64* %8, align 8, !dbg !960
  %43 = add i64 %42, 1, !dbg !960
  store i64 %43, i64* %8, align 8, !dbg !960
  br label %21, !dbg !961, !llvm.loop !962

44:                                               ; preds = %21
  store i1 false, i1* %4, align 1, !dbg !964
  br label %45, !dbg !964

45:                                               ; preds = %44, %37
  %46 = load i1, i1* %4, align 1, !dbg !965
  ret i1 %46, !dbg !965
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_extend(%struct.trace_s* noundef %0) #0 !dbg !966 {
  %2 = alloca %struct.trace_s*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca %struct.trace_unit_s*, align 8
  %6 = alloca %struct.trace_unit_s*, align 8
  %7 = alloca i32, align 4
  store %struct.trace_s* %0, %struct.trace_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %2, metadata !969, metadata !DIExpression()), !dbg !970
  %8 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !971
  %9 = icmp ne %struct.trace_s* %8, null, !dbg !971
  br i1 %9, label %10, label %11, !dbg !974

10:                                               ; preds = %1
  br label %12, !dbg !974

11:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 75, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.trace_extend, i64 0, i64 0)) #5, !dbg !971
  unreachable, !dbg !971

12:                                               ; preds = %10
  call void @llvm.dbg.declare(metadata i64* %3, metadata !975, metadata !DIExpression()), !dbg !976
  %13 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !977
  %14 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %13, i32 0, i32 2, !dbg !978
  %15 = load i64, i64* %14, align 8, !dbg !978
  %16 = mul i64 %15, 16, !dbg !979
  store i64 %16, i64* %3, align 8, !dbg !976
  call void @llvm.dbg.declare(metadata i64* %4, metadata !980, metadata !DIExpression()), !dbg !981
  %17 = load i64, i64* %3, align 8, !dbg !982
  %18 = mul i64 %17, 2, !dbg !983
  store i64 %18, i64* %4, align 8, !dbg !981
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %5, metadata !984, metadata !DIExpression()), !dbg !985
  %19 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !986
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 0, !dbg !987
  %21 = load %struct.trace_unit_s*, %struct.trace_unit_s** %20, align 8, !dbg !987
  store %struct.trace_unit_s* %21, %struct.trace_unit_s** %5, align 8, !dbg !985
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %6, metadata !988, metadata !DIExpression()), !dbg !989
  %22 = load i64, i64* %4, align 8, !dbg !990
  %23 = call noalias i8* @malloc(i64 noundef %22) #6, !dbg !991
  %24 = bitcast i8* %23 to %struct.trace_unit_s*, !dbg !991
  store %struct.trace_unit_s* %24, %struct.trace_unit_s** %6, align 8, !dbg !989
  %25 = load %struct.trace_unit_s*, %struct.trace_unit_s** %6, align 8, !dbg !992
  %26 = icmp ne %struct.trace_unit_s* %25, null, !dbg !992
  br i1 %26, label %27, label %47, !dbg !994

27:                                               ; preds = %12
  call void @llvm.dbg.declare(metadata i32* %7, metadata !995, metadata !DIExpression()), !dbg !997
  %28 = load %struct.trace_unit_s*, %struct.trace_unit_s** %6, align 8, !dbg !998
  %29 = load i64, i64* %4, align 8, !dbg !999
  %30 = load %struct.trace_unit_s*, %struct.trace_unit_s** %5, align 8, !dbg !1000
  %31 = load i64, i64* %3, align 8, !dbg !1001
  %32 = call i32 (%struct.trace_unit_s*, i64, %struct.trace_unit_s*, i64, ...) bitcast (i32 (...)* @memcpy_s to i32 (%struct.trace_unit_s*, i64, %struct.trace_unit_s*, i64, ...)*)(%struct.trace_unit_s* noundef %28, i64 noundef %29, %struct.trace_unit_s* noundef %30, i64 noundef %31), !dbg !1002
  store i32 %32, i32* %7, align 4, !dbg !997
  %33 = load i32, i32* %7, align 4, !dbg !1003
  %34 = icmp eq i32 %33, 0, !dbg !1005
  br i1 %34, label %35, label %43, !dbg !1006

35:                                               ; preds = %27
  %36 = load %struct.trace_unit_s*, %struct.trace_unit_s** %6, align 8, !dbg !1007
  %37 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1009
  %38 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %37, i32 0, i32 0, !dbg !1010
  store %struct.trace_unit_s* %36, %struct.trace_unit_s** %38, align 8, !dbg !1011
  %39 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1012
  %40 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %39, i32 0, i32 2, !dbg !1013
  %41 = load i64, i64* %40, align 8, !dbg !1014
  %42 = mul i64 %41, 2, !dbg !1014
  store i64 %42, i64* %40, align 8, !dbg !1014
  br label %44, !dbg !1015

43:                                               ; preds = %27
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.24, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 89, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.trace_extend, i64 0, i64 0)) #5, !dbg !1016
  unreachable, !dbg !1016

44:                                               ; preds = %35
  %45 = load %struct.trace_unit_s*, %struct.trace_unit_s** %5, align 8, !dbg !1020
  %46 = bitcast %struct.trace_unit_s* %45 to i8*, !dbg !1020
  call void @free(i8* noundef %46) #6, !dbg !1021
  br label %48, !dbg !1022

47:                                               ; preds = %12
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.25, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 93, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.trace_extend, i64 0, i64 0)) #5, !dbg !1023
  unreachable, !dbg !1023

48:                                               ; preds = %44
  ret void, !dbg !1027
}

declare i32 @memcpy_s(...) #4

; Function Attrs: noinline nounwind uwtable
define internal i8* @vsimpleht_get(%struct.vsimpleht_s* noundef %0, i64 noundef %1) #0 !dbg !1028 {
  %3 = alloca i8*, align 8
  %4 = alloca %struct.vsimpleht_s*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %4, metadata !1031, metadata !DIExpression()), !dbg !1032
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1033, metadata !DIExpression()), !dbg !1034
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1035, metadata !DIExpression()), !dbg !1036
  store i64 0, i64* %6, align 8, !dbg !1036
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1037, metadata !DIExpression()), !dbg !1038
  store i64 0, i64* %7, align 8, !dbg !1038
  %8 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1039
  call void @_vsimpleht_give_cleanup_a_chance(%struct.vsimpleht_s* noundef %8), !dbg !1040
  %9 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1041
  %10 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %9, i32 0, i32 3, !dbg !1043
  %11 = load i64 (i64)*, i64 (i64)** %10, align 8, !dbg !1043
  %12 = load i64, i64* %5, align 8, !dbg !1044
  %13 = call i64 %11(i64 noundef %12), !dbg !1041
  store i64 %13, i64* %6, align 8, !dbg !1045
  br label %14, !dbg !1046

14:                                               ; preds = %59, %2
  %15 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1047
  %16 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %15, i32 0, i32 0, !dbg !1050
  %17 = load i64, i64* %16, align 8, !dbg !1050
  %18 = sub i64 %17, 1, !dbg !1051
  %19 = load i64, i64* %6, align 8, !dbg !1052
  %20 = and i64 %19, %18, !dbg !1052
  store i64 %20, i64* %6, align 8, !dbg !1052
  %21 = load i64, i64* %6, align 8, !dbg !1053
  %22 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1053
  %23 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %22, i32 0, i32 0, !dbg !1053
  %24 = load i64, i64* %23, align 8, !dbg !1053
  %25 = icmp ult i64 %21, %24, !dbg !1053
  br i1 %25, label %26, label %27, !dbg !1056

26:                                               ; preds = %14
  br label %28, !dbg !1056

27:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.17, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 264, i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @__PRETTY_FUNCTION__.vsimpleht_get, i64 0, i64 0)) #5, !dbg !1053
  unreachable, !dbg !1053

28:                                               ; preds = %26
  %29 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1057
  %30 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %29, i32 0, i32 1, !dbg !1058
  %31 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %30, align 8, !dbg !1058
  %32 = load i64, i64* %6, align 8, !dbg !1059
  %33 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %31, i64 %32, !dbg !1057
  %34 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %33, i32 0, i32 0, !dbg !1060
  %35 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %34), !dbg !1061
  %36 = ptrtoint i8* %35 to i64, !dbg !1062
  store i64 %36, i64* %7, align 8, !dbg !1063
  %37 = load i64, i64* %7, align 8, !dbg !1064
  %38 = icmp eq i64 %37, 0, !dbg !1066
  br i1 %38, label %39, label %40, !dbg !1067

39:                                               ; preds = %28
  store i8* null, i8** %3, align 8, !dbg !1068
  br label %62, !dbg !1068

40:                                               ; preds = %28
  %41 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1070
  %42 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %41, i32 0, i32 2, !dbg !1072
  %43 = load i8 (i64, i64)*, i8 (i64, i64)** %42, align 8, !dbg !1072
  %44 = load i64, i64* %5, align 8, !dbg !1073
  %45 = load i64, i64* %7, align 8, !dbg !1074
  %46 = call signext i8 %43(i64 noundef %44, i64 noundef %45), !dbg !1070
  %47 = sext i8 %46 to i32, !dbg !1070
  %48 = icmp eq i32 %47, 0, !dbg !1075
  br i1 %48, label %49, label %57, !dbg !1076

49:                                               ; preds = %40
  %50 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1077
  %51 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %50, i32 0, i32 1, !dbg !1079
  %52 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %51, align 8, !dbg !1079
  %53 = load i64, i64* %6, align 8, !dbg !1080
  %54 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %52, i64 %53, !dbg !1077
  %55 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %54, i32 0, i32 1, !dbg !1081
  %56 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %55), !dbg !1082
  store i8* %56, i8** %3, align 8, !dbg !1083
  br label %62, !dbg !1083

57:                                               ; preds = %40
  br label %58

58:                                               ; preds = %57
  br label %59, !dbg !1084

59:                                               ; preds = %58
  %60 = load i64, i64* %6, align 8, !dbg !1085
  %61 = add i64 %60, 1, !dbg !1085
  store i64 %61, i64* %6, align 8, !dbg !1085
  br label %14, !dbg !1086, !llvm.loop !1087

62:                                               ; preds = %49, %39
  %63 = load i8*, i8** %3, align 8, !dbg !1090
  ret i8* %63, !dbg !1090
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %0) #0 !dbg !1091 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !1092, metadata !DIExpression()), !dbg !1093
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1094, !srcloc !1095
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1096, metadata !DIExpression()), !dbg !1097
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !1098
  %6 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %5, i32 0, i32 0, !dbg !1099
  %7 = bitcast i8** %6 to i64*, !dbg !1100
  %8 = bitcast i8** %4 to i64*, !dbg !1100
  %9 = load atomic i64, i64* %7 acquire, align 8, !dbg !1100
  store i64 %9, i64* %8, align 8, !dbg !1100
  %10 = bitcast i64* %8 to i8**, !dbg !1100
  %11 = load i8*, i8** %10, align 8, !dbg !1100
  store i8* %11, i8** %3, align 8, !dbg !1097
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1101, !srcloc !1102
  %12 = load i8*, i8** %3, align 8, !dbg !1103
  ret i8* %12, !dbg !1104
}

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !1105 {
  %5 = alloca %struct.run_info_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8* (i8*)*, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !1108, metadata !DIExpression()), !dbg !1109
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1110, metadata !DIExpression()), !dbg !1111
  store i8* (i8*)* %2, i8* (i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %7, metadata !1112, metadata !DIExpression()), !dbg !1113
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !1114, metadata !DIExpression()), !dbg !1115
  call void @llvm.dbg.declare(metadata i64* %9, metadata !1116, metadata !DIExpression()), !dbg !1117
  store i64 0, i64* %9, align 8, !dbg !1117
  store i64 0, i64* %9, align 8, !dbg !1118
  br label %11, !dbg !1120

11:                                               ; preds = %42, %4
  %12 = load i64, i64* %9, align 8, !dbg !1121
  %13 = load i64, i64* %6, align 8, !dbg !1123
  %14 = icmp ult i64 %12, %13, !dbg !1124
  br i1 %14, label %15, label %45, !dbg !1125

15:                                               ; preds = %11
  %16 = load i64, i64* %9, align 8, !dbg !1126
  %17 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1128
  %18 = load i64, i64* %9, align 8, !dbg !1129
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %17, i64 %18, !dbg !1128
  %20 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %19, i32 0, i32 1, !dbg !1130
  store i64 %16, i64* %20, align 8, !dbg !1131
  %21 = load i8* (i8*)*, i8* (i8*)** %7, align 8, !dbg !1132
  %22 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1133
  %23 = load i64, i64* %9, align 8, !dbg !1134
  %24 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %22, i64 %23, !dbg !1133
  %25 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %24, i32 0, i32 3, !dbg !1135
  store i8* (i8*)* %21, i8* (i8*)** %25, align 8, !dbg !1136
  %26 = load i8, i8* %8, align 1, !dbg !1137
  %27 = trunc i8 %26 to i1, !dbg !1137
  %28 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1138
  %29 = load i64, i64* %9, align 8, !dbg !1139
  %30 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %28, i64 %29, !dbg !1138
  %31 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %30, i32 0, i32 2, !dbg !1140
  %32 = zext i1 %27 to i8, !dbg !1141
  store i8 %32, i8* %31, align 8, !dbg !1141
  %33 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1142
  %34 = load i64, i64* %9, align 8, !dbg !1143
  %35 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %33, i64 %34, !dbg !1142
  %36 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %35, i32 0, i32 0, !dbg !1144
  %37 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1145
  %38 = load i64, i64* %9, align 8, !dbg !1146
  %39 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %37, i64 %38, !dbg !1145
  %40 = bitcast %struct.run_info_t* %39 to i8*, !dbg !1147
  %41 = call i32 @pthread_create(i64* noundef %36, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %40) #6, !dbg !1148
  br label %42, !dbg !1149

42:                                               ; preds = %15
  %43 = load i64, i64* %9, align 8, !dbg !1150
  %44 = add i64 %43, 1, !dbg !1150
  store i64 %44, i64* %9, align 8, !dbg !1150
  br label %11, !dbg !1151, !llvm.loop !1152

45:                                               ; preds = %11
  ret void, !dbg !1154
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !1155 {
  %3 = alloca %struct.run_info_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !1158, metadata !DIExpression()), !dbg !1159
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1160, metadata !DIExpression()), !dbg !1161
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1162, metadata !DIExpression()), !dbg !1163
  store i64 0, i64* %5, align 8, !dbg !1163
  store i64 0, i64* %5, align 8, !dbg !1164
  br label %6, !dbg !1166

6:                                                ; preds = %17, %2
  %7 = load i64, i64* %5, align 8, !dbg !1167
  %8 = load i64, i64* %4, align 8, !dbg !1169
  %9 = icmp ult i64 %7, %8, !dbg !1170
  br i1 %9, label %10, label %20, !dbg !1171

10:                                               ; preds = %6
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1172
  %12 = load i64, i64* %5, align 8, !dbg !1174
  %13 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i64 %12, !dbg !1172
  %14 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %13, i32 0, i32 0, !dbg !1175
  %15 = load i64, i64* %14, align 8, !dbg !1175
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !1176
  br label %17, !dbg !1177

17:                                               ; preds = %10
  %18 = load i64, i64* %5, align 8, !dbg !1178
  %19 = add i64 %18, 1, !dbg !1178
  store i64 %19, i64* %5, align 8, !dbg !1178
  br label %6, !dbg !1179, !llvm.loop !1180

20:                                               ; preds = %6
  ret void, !dbg !1182
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !1183 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.run_info_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !1184, metadata !DIExpression()), !dbg !1185
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !1186, metadata !DIExpression()), !dbg !1187
  %4 = load i8*, i8** %2, align 8, !dbg !1188
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !1189
  store %struct.run_info_t* %5, %struct.run_info_t** %3, align 8, !dbg !1187
  %6 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1190
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %6, i32 0, i32 2, !dbg !1192
  %8 = load i8, i8* %7, align 8, !dbg !1192
  %9 = trunc i8 %8 to i1, !dbg !1192
  br i1 %9, label %10, label %14, !dbg !1193

10:                                               ; preds = %1
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1194
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i32 0, i32 1, !dbg !1195
  %13 = load i64, i64* %12, align 8, !dbg !1195
  call void @set_cpu_affinity(i64 noundef %13), !dbg !1196
  br label %14, !dbg !1196

14:                                               ; preds = %10, %1
  %15 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1197
  %16 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %15, i32 0, i32 3, !dbg !1198
  %17 = load i8* (i8*)*, i8* (i8*)** %16, align 8, !dbg !1198
  %18 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1199
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %18, i32 0, i32 1, !dbg !1200
  %20 = load i64, i64* %19, align 8, !dbg !1200
  %21 = inttoptr i64 %20 to i8*, !dbg !1201
  %22 = call i8* %17(i8* noundef %21), !dbg !1197
  ret i8* %22, !dbg !1202
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !1203 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1204, metadata !DIExpression()), !dbg !1205
  br label %3, !dbg !1206

3:                                                ; preds = %1
  br label %4, !dbg !1207

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1209
  br label %6, !dbg !1209

6:                                                ; preds = %4
  br label %7, !dbg !1211

7:                                                ; preds = %6
  br label %8, !dbg !1209

8:                                                ; preds = %7
  br label %9, !dbg !1207

9:                                                ; preds = %8
  ret void, !dbg !1213
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_thread_register(%struct.vsimpleht_s* noundef %0) #0 !dbg !1214 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !1215, metadata !DIExpression()), !dbg !1216
  %3 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1217
  %4 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %3, i32 0, i32 7, !dbg !1218
  call void @rwlock_read_acquire(%struct.rwlock_s* noundef %4), !dbg !1219
  ret void, !dbg !1220
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_thread_deregister(%struct.vsimpleht_s* noundef %0) #0 !dbg !1221 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !1222, metadata !DIExpression()), !dbg !1223
  %3 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1224
  %4 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %3, i32 0, i32 7, !dbg !1225
  call void @rwlock_read_release(%struct.rwlock_s* noundef %4), !dbg !1226
  ret void, !dbg !1227
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vsimpleht_buff_size(i64 noundef %0) #0 !dbg !1228 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1231, metadata !DIExpression()), !dbg !1232
  %3 = load i64, i64* %2, align 8, !dbg !1233
  %4 = icmp ugt i64 %3, 0, !dbg !1233
  br i1 %4, label %5, label %6, !dbg !1236

5:                                                ; preds = %1
  br label %7, !dbg !1236

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.28, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 128, i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @__PRETTY_FUNCTION__.vsimpleht_buff_size, i64 0, i64 0)) #5, !dbg !1233
  unreachable, !dbg !1233

7:                                                ; preds = %5
  %8 = load i64, i64* %2, align 8, !dbg !1237
  %9 = load i64, i64* %2, align 8, !dbg !1237
  %10 = sub i64 %9, 1, !dbg !1237
  %11 = and i64 %8, %10, !dbg !1237
  %12 = icmp eq i64 %11, 0, !dbg !1237
  br i1 %12, label %13, label %15, !dbg !1237

13:                                               ; preds = %7
  br i1 true, label %14, label %15, !dbg !1240

14:                                               ; preds = %13
  br label %16, !dbg !1240

15:                                               ; preds = %13, %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @.str.30, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 129, i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @__PRETTY_FUNCTION__.vsimpleht_buff_size, i64 0, i64 0)) #5, !dbg !1237
  unreachable, !dbg !1237

16:                                               ; preds = %14
  %17 = load i64, i64* %2, align 8, !dbg !1241
  %18 = mul i64 16, %17, !dbg !1242
  ret i64 %18, !dbg !1243
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_init(%struct.vsimpleht_s* noundef %0, i8* noundef %1, i64 noundef %2, i8 (i64, i64)* noundef %3, i64 (i64)* noundef %4, void (i8*)* noundef %5) #0 !dbg !1244 {
  %7 = alloca %struct.vsimpleht_s*, align 8
  %8 = alloca i8*, align 8
  %9 = alloca i64, align 8
  %10 = alloca i8 (i64, i64)*, align 8
  %11 = alloca i64 (i64)*, align 8
  %12 = alloca void (i8*)*, align 8
  %13 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %7, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %7, metadata !1247, metadata !DIExpression()), !dbg !1248
  store i8* %1, i8** %8, align 8
  call void @llvm.dbg.declare(metadata i8** %8, metadata !1249, metadata !DIExpression()), !dbg !1250
  store i64 %2, i64* %9, align 8
  call void @llvm.dbg.declare(metadata i64* %9, metadata !1251, metadata !DIExpression()), !dbg !1252
  store i8 (i64, i64)* %3, i8 (i64, i64)** %10, align 8
  call void @llvm.dbg.declare(metadata i8 (i64, i64)** %10, metadata !1253, metadata !DIExpression()), !dbg !1254
  store i64 (i64)* %4, i64 (i64)** %11, align 8
  call void @llvm.dbg.declare(metadata i64 (i64)** %11, metadata !1255, metadata !DIExpression()), !dbg !1256
  store void (i8*)* %5, void (i8*)** %12, align 8
  call void @llvm.dbg.declare(metadata void (i8*)** %12, metadata !1257, metadata !DIExpression()), !dbg !1258
  %14 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1259
  %15 = icmp ne %struct.vsimpleht_s* %14, null, !dbg !1259
  br i1 %15, label %16, label %17, !dbg !1262

16:                                               ; preds = %6
  br label %18, !dbg !1262

17:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.31, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 150, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1259
  unreachable, !dbg !1259

18:                                               ; preds = %16
  %19 = load i8*, i8** %8, align 8, !dbg !1263
  %20 = icmp ne i8* %19, null, !dbg !1263
  br i1 %20, label %21, label %22, !dbg !1266

21:                                               ; preds = %18
  br label %23, !dbg !1266

22:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.32, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 151, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1263
  unreachable, !dbg !1263

23:                                               ; preds = %21
  %24 = load i64, i64* %9, align 8, !dbg !1267
  %25 = icmp ugt i64 %24, 0, !dbg !1267
  br i1 %25, label %26, label %27, !dbg !1270

26:                                               ; preds = %23
  br label %28, !dbg !1270

27:                                               ; preds = %23
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.28, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 152, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1267
  unreachable, !dbg !1267

28:                                               ; preds = %26
  %29 = load i64, i64* %9, align 8, !dbg !1271
  %30 = load i64, i64* %9, align 8, !dbg !1271
  %31 = sub i64 %30, 1, !dbg !1271
  %32 = and i64 %29, %31, !dbg !1271
  %33 = icmp eq i64 %32, 0, !dbg !1271
  br i1 %33, label %34, label %36, !dbg !1271

34:                                               ; preds = %28
  br i1 true, label %35, label %36, !dbg !1274

35:                                               ; preds = %34
  br label %37, !dbg !1274

36:                                               ; preds = %34, %28
  call void @__assert_fail(i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.34, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 153, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1271
  unreachable, !dbg !1271

37:                                               ; preds = %35
  %38 = load i64, i64* %9, align 8, !dbg !1275
  %39 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1276
  %40 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %39, i32 0, i32 0, !dbg !1277
  store i64 %38, i64* %40, align 8, !dbg !1278
  %41 = load i8*, i8** %8, align 8, !dbg !1279
  %42 = bitcast i8* %41 to %struct.vsimpleht_entry_s*, !dbg !1279
  %43 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1280
  %44 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %43, i32 0, i32 1, !dbg !1281
  store %struct.vsimpleht_entry_s* %42, %struct.vsimpleht_entry_s** %44, align 8, !dbg !1282
  %45 = load i8 (i64, i64)*, i8 (i64, i64)** %10, align 8, !dbg !1283
  %46 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1284
  %47 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %46, i32 0, i32 2, !dbg !1285
  store i8 (i64, i64)* %45, i8 (i64, i64)** %47, align 8, !dbg !1286
  %48 = load i64 (i64)*, i64 (i64)** %11, align 8, !dbg !1287
  %49 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1288
  %50 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %49, i32 0, i32 3, !dbg !1289
  store i64 (i64)* %48, i64 (i64)** %50, align 8, !dbg !1290
  %51 = load void (i8*)*, void (i8*)** %12, align 8, !dbg !1291
  %52 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1292
  %53 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %52, i32 0, i32 4, !dbg !1293
  store void (i8*)* %51, void (i8*)** %53, align 8, !dbg !1294
  call void @llvm.dbg.declare(metadata i64* %13, metadata !1295, metadata !DIExpression()), !dbg !1297
  store i64 0, i64* %13, align 8, !dbg !1297
  br label %54, !dbg !1298

54:                                               ; preds = %73, %37
  %55 = load i64, i64* %13, align 8, !dbg !1299
  %56 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1301
  %57 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %56, i32 0, i32 0, !dbg !1302
  %58 = load i64, i64* %57, align 8, !dbg !1302
  %59 = icmp ult i64 %55, %58, !dbg !1303
  br i1 %59, label %60, label %76, !dbg !1304

60:                                               ; preds = %54
  %61 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1305
  %62 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %61, i32 0, i32 1, !dbg !1307
  %63 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %62, align 8, !dbg !1307
  %64 = load i64, i64* %13, align 8, !dbg !1308
  %65 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %63, i64 %64, !dbg !1305
  %66 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %65, i32 0, i32 0, !dbg !1309
  call void @vatomicptr_init(%struct.vatomicptr_s* noundef %66, i8* noundef null), !dbg !1310
  %67 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1311
  %68 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %67, i32 0, i32 1, !dbg !1312
  %69 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %68, align 8, !dbg !1312
  %70 = load i64, i64* %13, align 8, !dbg !1313
  %71 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %69, i64 %70, !dbg !1311
  %72 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %71, i32 0, i32 1, !dbg !1314
  call void @vatomicptr_init(%struct.vatomicptr_s* noundef %72, i8* noundef null), !dbg !1315
  br label %73, !dbg !1316

73:                                               ; preds = %60
  %74 = load i64, i64* %13, align 8, !dbg !1317
  %75 = add i64 %74, 1, !dbg !1317
  store i64 %75, i64* %13, align 8, !dbg !1317
  br label %54, !dbg !1318, !llvm.loop !1319

76:                                               ; preds = %54
  %77 = load i64, i64* %9, align 8, !dbg !1321
  %78 = udiv i64 %77, 4, !dbg !1322
  %79 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1323
  %80 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %79, i32 0, i32 5, !dbg !1324
  store i64 %78, i64* %80, align 8, !dbg !1325
  %81 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1326
  %82 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %81, i32 0, i32 6, !dbg !1327
  call void @vatomicsz_write_rlx(%struct.vatomicsz_s* noundef %82, i64 noundef 0), !dbg !1328
  %83 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1329
  %84 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %83, i32 0, i32 7, !dbg !1330
  call void @rwlock_init(%struct.rwlock_s* noundef %84), !dbg !1331
  ret void, !dbg !1332
}

; Function Attrs: noinline nounwind uwtable
define internal signext i8 @cb_cmp(i64 noundef %0, i64 noundef %1) #0 !dbg !1333 {
  %3 = alloca i8, align 1
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i64 %0, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1334, metadata !DIExpression()), !dbg !1335
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1336, metadata !DIExpression()), !dbg !1337
  %6 = load i64, i64* %4, align 8, !dbg !1338
  %7 = load i64, i64* %5, align 8, !dbg !1340
  %8 = icmp eq i64 %6, %7, !dbg !1341
  br i1 %8, label %9, label %10, !dbg !1342

9:                                                ; preds = %2
  store i8 0, i8* %3, align 1, !dbg !1343
  br label %16, !dbg !1343

10:                                               ; preds = %2
  %11 = load i64, i64* %4, align 8, !dbg !1345
  %12 = load i64, i64* %5, align 8, !dbg !1347
  %13 = icmp ult i64 %11, %12, !dbg !1348
  br i1 %13, label %14, label %15, !dbg !1349

14:                                               ; preds = %10
  store i8 -1, i8* %3, align 1, !dbg !1350
  br label %16, !dbg !1350

15:                                               ; preds = %10
  store i8 1, i8* %3, align 1, !dbg !1352
  br label %16, !dbg !1352

16:                                               ; preds = %15, %14, %9
  %17 = load i8, i8* %3, align 1, !dbg !1354
  ret i8 %17, !dbg !1354
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @cb_hash(i64 noundef %0) #0 !dbg !1355 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1356, metadata !DIExpression()), !dbg !1357
  %3 = load i64, i64* %2, align 8, !dbg !1358
  ret i64 %3, !dbg !1359
}

; Function Attrs: noinline nounwind uwtable
define internal void @cb_destroy(i8* noundef %0) #0 !dbg !1360 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !1361, metadata !DIExpression()), !dbg !1362
  %3 = load i8*, i8** %2, align 8, !dbg !1363
  call void @free(i8* noundef %3) #6, !dbg !1364
  ret void, !dbg !1365
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_init(%struct.trace_s* noundef %0, i64 noundef %1) #0 !dbg !1366 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !1369, metadata !DIExpression()), !dbg !1370
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1371, metadata !DIExpression()), !dbg !1372
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1373
  %6 = icmp ne %struct.trace_s* %5, null, !dbg !1373
  br i1 %6, label %7, label %8, !dbg !1376

7:                                                ; preds = %2
  br label %9, !dbg !1376

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 36, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !1373
  unreachable, !dbg !1373

9:                                                ; preds = %7
  %10 = load i64, i64* %4, align 8, !dbg !1377
  %11 = mul i64 %10, 16, !dbg !1378
  %12 = call noalias i8* @malloc(i64 noundef %11) #6, !dbg !1379
  %13 = bitcast i8* %12 to %struct.trace_unit_s*, !dbg !1379
  %14 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1380
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 0, !dbg !1381
  store %struct.trace_unit_s* %13, %struct.trace_unit_s** %15, align 8, !dbg !1382
  %16 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1383
  %17 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %16, i32 0, i32 0, !dbg !1385
  %18 = load %struct.trace_unit_s*, %struct.trace_unit_s** %17, align 8, !dbg !1385
  %19 = icmp ne %struct.trace_unit_s* %18, null, !dbg !1383
  br i1 %19, label %20, label %28, !dbg !1386

20:                                               ; preds = %9
  %21 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1387
  %22 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %21, i32 0, i32 1, !dbg !1389
  store i64 0, i64* %22, align 8, !dbg !1390
  %23 = load i64, i64* %4, align 8, !dbg !1391
  %24 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1392
  %25 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %24, i32 0, i32 2, !dbg !1393
  store i64 %23, i64* %25, align 8, !dbg !1394
  %26 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1395
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 3, !dbg !1396
  store i8 1, i8* %27, align 8, !dbg !1397
  br label %35, !dbg !1398

28:                                               ; preds = %9
  %29 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1399
  %30 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %29, i32 0, i32 1, !dbg !1401
  store i64 0, i64* %30, align 8, !dbg !1402
  %31 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1403
  %32 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %31, i32 0, i32 2, !dbg !1404
  store i64 0, i64* %32, align 8, !dbg !1405
  %33 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1406
  %34 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %33, i32 0, i32 3, !dbg !1407
  store i8 0, i8* %34, align 8, !dbg !1408
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.25, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 46, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !1409
  unreachable, !dbg !1409

35:                                               ; preds = %20
  ret void, !dbg !1412
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_init(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1413 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1416, metadata !DIExpression()), !dbg !1417
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1418, metadata !DIExpression()), !dbg !1419
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !1420
  %6 = load i8*, i8** %4, align 8, !dbg !1421
  call void @vatomicptr_write(%struct.vatomicptr_s* noundef %5, i8* noundef %6), !dbg !1422
  ret void, !dbg !1423
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicsz_write_rlx(%struct.vatomicsz_s* noundef %0, i64 noundef %1) #0 !dbg !1424 {
  %3 = alloca %struct.vatomicsz_s*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.vatomicsz_s* %0, %struct.vatomicsz_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicsz_s** %3, metadata !1428, metadata !DIExpression()), !dbg !1429
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1430, metadata !DIExpression()), !dbg !1431
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1432, !srcloc !1433
  %6 = load %struct.vatomicsz_s*, %struct.vatomicsz_s** %3, align 8, !dbg !1434
  %7 = getelementptr inbounds %struct.vatomicsz_s, %struct.vatomicsz_s* %6, i32 0, i32 0, !dbg !1435
  %8 = load i64, i64* %4, align 8, !dbg !1436
  store i64 %8, i64* %5, align 8, !dbg !1437
  %9 = load i64, i64* %5, align 8, !dbg !1437
  store atomic i64 %9, i64* %7 monotonic, align 8, !dbg !1437
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1438, !srcloc !1439
  ret void, !dbg !1440
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_init(%struct.rwlock_s* noundef %0) #0 !dbg !1441 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i64, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !1442, metadata !DIExpression()), !dbg !1443
  call void @llvm.dbg.declare(metadata i64* %3, metadata !1444, metadata !DIExpression()), !dbg !1446
  store i64 0, i64* %3, align 8, !dbg !1446
  br label %4, !dbg !1447

4:                                                ; preds = %13, %1
  %5 = load i64, i64* %3, align 8, !dbg !1448
  %6 = icmp ult i64 %5, 3, !dbg !1450
  br i1 %6, label %7, label %16, !dbg !1451

7:                                                ; preds = %4
  %8 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !1452
  %9 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %8, i32 0, i32 0, !dbg !1454
  %10 = load i64, i64* %3, align 8, !dbg !1455
  %11 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %9, i64 0, i64 %10, !dbg !1452
  %12 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %11, %union.pthread_mutexattr_t* noundef null) #6, !dbg !1456
  br label %13, !dbg !1457

13:                                               ; preds = %7
  %14 = load i64, i64* %3, align 8, !dbg !1458
  %15 = add i64 %14, 1, !dbg !1458
  store i64 %15, i64* %3, align 8, !dbg !1458
  br label %4, !dbg !1459, !llvm.loop !1460

16:                                               ; preds = %4
  ret void, !dbg !1462
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1463 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1464, metadata !DIExpression()), !dbg !1465
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1466, metadata !DIExpression()), !dbg !1467
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1468, !srcloc !1469
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !1470
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !1471
  %8 = load i8*, i8** %4, align 8, !dbg !1472
  store i8* %8, i8** %5, align 8, !dbg !1473
  %9 = bitcast i8** %7 to i64*, !dbg !1473
  %10 = bitcast i8** %5 to i64*, !dbg !1473
  %11 = load i64, i64* %10, align 8, !dbg !1473
  store atomic i64 %11, i64* %9 seq_cst, align 8, !dbg !1473
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1474, !srcloc !1475
  ret void, !dbg !1476
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @_imap_verify() #0 !dbg !1477 {
  %1 = alloca i64, align 8
  %2 = alloca %struct.data_s*, align 8
  %3 = alloca %struct.vsimpleht_iter_s, align 8
  %4 = alloca %struct.trace_s, align 8
  %5 = alloca %struct.trace_s, align 8
  %6 = alloca %struct.trace_s, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata i64* %1, metadata !1478, metadata !DIExpression()), !dbg !1479
  store i64 0, i64* %1, align 8, !dbg !1479
  call void @llvm.dbg.declare(metadata %struct.data_s** %2, metadata !1480, metadata !DIExpression()), !dbg !1481
  store %struct.data_s* null, %struct.data_s** %2, align 8, !dbg !1481
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_iter_s* %3, metadata !1482, metadata !DIExpression()), !dbg !1488
  call void @llvm.dbg.declare(metadata %struct.trace_s* %4, metadata !1489, metadata !DIExpression()), !dbg !1490
  call void @llvm.dbg.declare(metadata %struct.trace_s* %5, metadata !1491, metadata !DIExpression()), !dbg !1492
  call void @llvm.dbg.declare(metadata %struct.trace_s* %6, metadata !1493, metadata !DIExpression()), !dbg !1494
  call void @trace_init(%struct.trace_s* noundef %4, i64 noundef 8), !dbg !1495
  call void @trace_init(%struct.trace_s* noundef %5, i64 noundef 8), !dbg !1496
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1497, metadata !DIExpression()), !dbg !1499
  store i64 0, i64* %7, align 8, !dbg !1499
  br label %9, !dbg !1500

9:                                                ; preds = %17, %0
  %10 = load i64, i64* %7, align 8, !dbg !1501
  %11 = icmp ult i64 %10, 4, !dbg !1503
  br i1 %11, label %12, label %20, !dbg !1504

12:                                               ; preds = %9
  %13 = load i64, i64* %7, align 8, !dbg !1505
  %14 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %13, !dbg !1507
  call void @trace_merge_into(%struct.trace_s* noundef %4, %struct.trace_s* noundef %14), !dbg !1508
  %15 = load i64, i64* %7, align 8, !dbg !1509
  %16 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_rem, i64 0, i64 %15, !dbg !1510
  call void @trace_merge_into(%struct.trace_s* noundef %5, %struct.trace_s* noundef %16), !dbg !1511
  br label %17, !dbg !1512

17:                                               ; preds = %12
  %18 = load i64, i64* %7, align 8, !dbg !1513
  %19 = add i64 %18, 1, !dbg !1513
  store i64 %19, i64* %7, align 8, !dbg !1513
  br label %9, !dbg !1514, !llvm.loop !1515

20:                                               ; preds = %9
  call void @trace_init(%struct.trace_s* noundef %6, i64 noundef 8), !dbg !1517
  call void @vsimpleht_iter_init(%struct.vsimpleht_s* noundef @g_simpleht, %struct.vsimpleht_iter_s* noundef %3), !dbg !1518
  br label %21, !dbg !1519

21:                                               ; preds = %24, %20
  %22 = bitcast %struct.data_s** %2 to i8**, !dbg !1520
  %23 = call zeroext i1 @vsimpleht_iter_next(%struct.vsimpleht_iter_s* noundef %3, i64* noundef %1, i8** noundef %22), !dbg !1521
  br i1 %23, label %24, label %26, !dbg !1519

24:                                               ; preds = %21
  %25 = load i64, i64* %1, align 8, !dbg !1522
  call void @trace_add(%struct.trace_s* noundef %6, i64 noundef %25), !dbg !1524
  br label %21, !dbg !1519, !llvm.loop !1525

26:                                               ; preds = %21
  call void @trace_subtract_from(%struct.trace_s* noundef %4, %struct.trace_s* noundef %5), !dbg !1527
  call void @llvm.dbg.declare(metadata i8* %8, metadata !1528, metadata !DIExpression()), !dbg !1529
  %27 = call zeroext i1 @trace_is_subtrace(%struct.trace_s* noundef %4, %struct.trace_s* noundef %6, void (i64)* noundef null), !dbg !1530
  %28 = zext i1 %27 to i8, !dbg !1529
  store i8 %28, i8* %8, align 1, !dbg !1529
  call void @trace_destroy(%struct.trace_s* noundef %4), !dbg !1531
  call void @trace_destroy(%struct.trace_s* noundef %5), !dbg !1532
  call void @trace_destroy(%struct.trace_s* noundef %6), !dbg !1533
  %29 = load i8, i8* %8, align 1, !dbg !1534
  %30 = trunc i8 %29 to i1, !dbg !1534
  br i1 %30, label %31, label %33, !dbg !1534

31:                                               ; preds = %26
  br i1 true, label %32, label %33, !dbg !1537

32:                                               ; preds = %31
  br label %34, !dbg !1537

33:                                               ; preds = %31, %26
  call void @__assert_fail(i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.36, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.27, i64 0, i64 0), i32 noundef 109, i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @__PRETTY_FUNCTION__._imap_verify, i64 0, i64 0)) #5, !dbg !1534
  unreachable, !dbg !1534

34:                                               ; preds = %32
  ret void, !dbg !1538
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_destroy(%struct.trace_s* noundef %0) #0 !dbg !1539 {
  %2 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %2, metadata !1540, metadata !DIExpression()), !dbg !1541
  %3 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1542
  %4 = icmp ne %struct.trace_s* %3, null, !dbg !1542
  br i1 %4, label %5, label %6, !dbg !1545

5:                                                ; preds = %1
  br label %7, !dbg !1545

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !1542
  unreachable, !dbg !1542

7:                                                ; preds = %5
  %8 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1546
  %9 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %8, i32 0, i32 3, !dbg !1546
  %10 = load i8, i8* %9, align 8, !dbg !1546
  %11 = trunc i8 %10 to i1, !dbg !1546
  br i1 %11, label %12, label %13, !dbg !1549

12:                                               ; preds = %7
  br label %14, !dbg !1549

13:                                               ; preds = %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 101, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !1546
  unreachable, !dbg !1546

14:                                               ; preds = %12
  %15 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1550
  %16 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %15, i32 0, i32 0, !dbg !1551
  %17 = load %struct.trace_unit_s*, %struct.trace_unit_s** %16, align 8, !dbg !1551
  %18 = bitcast %struct.trace_unit_s* %17 to i8*, !dbg !1550
  call void @free(i8* noundef %18) #6, !dbg !1552
  %19 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1553
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 3, !dbg !1554
  store i8 0, i8* %20, align 8, !dbg !1555
  ret void, !dbg !1556
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_destroy(%struct.vsimpleht_s* noundef %0) #0 !dbg !1557 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  %3 = alloca %struct.vsimpleht_entry_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !1558, metadata !DIExpression()), !dbg !1559
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_entry_s** %3, metadata !1560, metadata !DIExpression()), !dbg !1561
  store %struct.vsimpleht_entry_s* null, %struct.vsimpleht_entry_s** %3, align 8, !dbg !1561
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1562, metadata !DIExpression()), !dbg !1563
  store i8* null, i8** %4, align 8, !dbg !1563
  %6 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1564
  %7 = icmp ne %struct.vsimpleht_s* %6, null, !dbg !1564
  br i1 %7, label %8, label %9, !dbg !1567

8:                                                ; preds = %1
  br label %10, !dbg !1567

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.31, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 182, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__.vsimpleht_destroy, i64 0, i64 0)) #5, !dbg !1564
  unreachable, !dbg !1564

10:                                               ; preds = %8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1568, metadata !DIExpression()), !dbg !1570
  store i64 0, i64* %5, align 8, !dbg !1570
  br label %11, !dbg !1571

11:                                               ; preds = %34, %10
  %12 = load i64, i64* %5, align 8, !dbg !1572
  %13 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1574
  %14 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %13, i32 0, i32 0, !dbg !1575
  %15 = load i64, i64* %14, align 8, !dbg !1575
  %16 = icmp ult i64 %12, %15, !dbg !1576
  br i1 %16, label %17, label %37, !dbg !1577

17:                                               ; preds = %11
  %18 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1578
  %19 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %18, i32 0, i32 1, !dbg !1580
  %20 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %19, align 8, !dbg !1580
  %21 = load i64, i64* %5, align 8, !dbg !1581
  %22 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %20, i64 %21, !dbg !1578
  store %struct.vsimpleht_entry_s* %22, %struct.vsimpleht_entry_s** %3, align 8, !dbg !1582
  %23 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %3, align 8, !dbg !1583
  %24 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %23, i32 0, i32 1, !dbg !1584
  %25 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %24), !dbg !1585
  store i8* %25, i8** %4, align 8, !dbg !1586
  %26 = load i8*, i8** %4, align 8, !dbg !1587
  %27 = icmp ne i8* %26, null, !dbg !1587
  br i1 %27, label %28, label %33, !dbg !1589

28:                                               ; preds = %17
  %29 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1590
  %30 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %29, i32 0, i32 4, !dbg !1592
  %31 = load void (i8*)*, void (i8*)** %30, align 8, !dbg !1592
  %32 = load i8*, i8** %4, align 8, !dbg !1593
  call void %31(i8* noundef %32), !dbg !1590
  br label %33, !dbg !1594

33:                                               ; preds = %28, %17
  br label %34, !dbg !1595

34:                                               ; preds = %33
  %35 = load i64, i64* %5, align 8, !dbg !1596
  %36 = add i64 %35, 1, !dbg !1596
  store i64 %36, i64* %5, align 8, !dbg !1596
  br label %11, !dbg !1597, !llvm.loop !1598

37:                                               ; preds = %11
  ret void, !dbg !1600
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_merge_into(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1) #0 !dbg !1601 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !1604, metadata !DIExpression()), !dbg !1605
  store %struct.trace_s* %1, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !1606, metadata !DIExpression()), !dbg !1607
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1608
  %6 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1609
  call void @_trace_merge_or_subtract(%struct.trace_s* noundef %5, %struct.trace_s* noundef %6, i1 noundef zeroext false), !dbg !1610
  ret void, !dbg !1611
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_iter_init(%struct.vsimpleht_s* noundef %0, %struct.vsimpleht_iter_s* noundef %1) #0 !dbg !1612 {
  %3 = alloca %struct.vsimpleht_s*, align 8
  %4 = alloca %struct.vsimpleht_iter_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %3, metadata !1616, metadata !DIExpression()), !dbg !1617
  store %struct.vsimpleht_iter_s* %1, %struct.vsimpleht_iter_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_iter_s** %4, metadata !1618, metadata !DIExpression()), !dbg !1619
  %5 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1620
  %6 = icmp ne %struct.vsimpleht_s* %5, null, !dbg !1620
  br i1 %6, label %7, label %8, !dbg !1623

7:                                                ; preds = %2
  br label %9, !dbg !1623

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.31, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 282, i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_init, i64 0, i64 0)) #5, !dbg !1620
  unreachable, !dbg !1620

9:                                                ; preds = %7
  %10 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %4, align 8, !dbg !1624
  %11 = icmp ne %struct.vsimpleht_iter_s* %10, null, !dbg !1624
  br i1 %11, label %12, label %13, !dbg !1627

12:                                               ; preds = %9
  br label %14, !dbg !1627

13:                                               ; preds = %9
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.39, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 283, i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_init, i64 0, i64 0)) #5, !dbg !1624
  unreachable, !dbg !1624

14:                                               ; preds = %12
  %15 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1628
  %16 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %4, align 8, !dbg !1629
  %17 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %16, i32 0, i32 0, !dbg !1630
  store %struct.vsimpleht_s* %15, %struct.vsimpleht_s** %17, align 8, !dbg !1631
  %18 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %4, align 8, !dbg !1632
  %19 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %18, i32 0, i32 1, !dbg !1633
  store i64 0, i64* %19, align 8, !dbg !1634
  ret void, !dbg !1635
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @vsimpleht_iter_next(%struct.vsimpleht_iter_s* noundef %0, i64* noundef %1, i8** noundef %2) #0 !dbg !1636 {
  %4 = alloca i1, align 1
  %5 = alloca %struct.vsimpleht_iter_s*, align 8
  %6 = alloca i64*, align 8
  %7 = alloca i8**, align 8
  %8 = alloca i64, align 8
  %9 = alloca i8*, align 8
  %10 = alloca %struct.vsimpleht_entry_s*, align 8
  %11 = alloca i64, align 8
  store %struct.vsimpleht_iter_s* %0, %struct.vsimpleht_iter_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_iter_s** %5, metadata !1640, metadata !DIExpression()), !dbg !1641
  store i64* %1, i64** %6, align 8
  call void @llvm.dbg.declare(metadata i64** %6, metadata !1642, metadata !DIExpression()), !dbg !1643
  store i8** %2, i8*** %7, align 8
  call void @llvm.dbg.declare(metadata i8*** %7, metadata !1644, metadata !DIExpression()), !dbg !1645
  call void @llvm.dbg.declare(metadata i64* %8, metadata !1646, metadata !DIExpression()), !dbg !1647
  store i64 0, i64* %8, align 8, !dbg !1647
  call void @llvm.dbg.declare(metadata i8** %9, metadata !1648, metadata !DIExpression()), !dbg !1649
  store i8* null, i8** %9, align 8, !dbg !1649
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_entry_s** %10, metadata !1650, metadata !DIExpression()), !dbg !1651
  store %struct.vsimpleht_entry_s* null, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1651
  %12 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !1652
  %13 = icmp ne %struct.vsimpleht_iter_s* %12, null, !dbg !1652
  br i1 %13, label %14, label %15, !dbg !1655

14:                                               ; preds = %3
  br label %16, !dbg !1655

15:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.39, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 322, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !1652
  unreachable, !dbg !1652

16:                                               ; preds = %14
  %17 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !1656
  %18 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %17, i32 0, i32 0, !dbg !1656
  %19 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %18, align 8, !dbg !1656
  %20 = icmp ne %struct.vsimpleht_s* %19, null, !dbg !1656
  br i1 %20, label %21, label %22, !dbg !1659

21:                                               ; preds = %16
  br label %23, !dbg !1659

22:                                               ; preds = %16
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.40, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 323, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !1656
  unreachable, !dbg !1656

23:                                               ; preds = %21
  %24 = load i64*, i64** %6, align 8, !dbg !1660
  %25 = icmp ne i64* %24, null, !dbg !1660
  br i1 %25, label %26, label %27, !dbg !1663

26:                                               ; preds = %23
  br label %28, !dbg !1663

27:                                               ; preds = %23
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.41, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 324, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !1660
  unreachable, !dbg !1660

28:                                               ; preds = %26
  %29 = load i8**, i8*** %7, align 8, !dbg !1664
  %30 = icmp ne i8** %29, null, !dbg !1664
  br i1 %30, label %31, label %32, !dbg !1667

31:                                               ; preds = %28
  br label %33, !dbg !1667

32:                                               ; preds = %28
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.42, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 325, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !1664
  unreachable, !dbg !1664

33:                                               ; preds = %31
  %34 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !1668
  %35 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %34, i32 0, i32 0, !dbg !1669
  %36 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %35, align 8, !dbg !1669
  %37 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %36, i32 0, i32 1, !dbg !1670
  %38 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %37, align 8, !dbg !1670
  store %struct.vsimpleht_entry_s* %38, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1671
  %39 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1672
  %40 = icmp ne %struct.vsimpleht_entry_s* %39, null, !dbg !1672
  br i1 %40, label %41, label %42, !dbg !1675

41:                                               ; preds = %33
  br label %43, !dbg !1675

42:                                               ; preds = %33
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.43, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.7, i64 0, i64 0), i32 noundef 327, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !1672
  unreachable, !dbg !1672

43:                                               ; preds = %41
  call void @llvm.dbg.declare(metadata i64* %11, metadata !1676, metadata !DIExpression()), !dbg !1678
  %44 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !1679
  %45 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %44, i32 0, i32 1, !dbg !1680
  %46 = load i64, i64* %45, align 8, !dbg !1680
  store i64 %46, i64* %11, align 8, !dbg !1678
  br label %47, !dbg !1681

47:                                               ; preds = %82, %43
  %48 = load i64, i64* %11, align 8, !dbg !1682
  %49 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !1684
  %50 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %49, i32 0, i32 0, !dbg !1685
  %51 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %50, align 8, !dbg !1685
  %52 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %51, i32 0, i32 0, !dbg !1686
  %53 = load i64, i64* %52, align 8, !dbg !1686
  %54 = icmp ult i64 %48, %53, !dbg !1687
  br i1 %54, label %55, label %85, !dbg !1688

55:                                               ; preds = %47
  %56 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1689
  %57 = load i64, i64* %11, align 8, !dbg !1691
  %58 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %56, i64 %57, !dbg !1689
  %59 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %58, i32 0, i32 0, !dbg !1692
  %60 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %59), !dbg !1693
  %61 = ptrtoint i8* %60 to i64, !dbg !1694
  store i64 %61, i64* %8, align 8, !dbg !1695
  %62 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1696
  %63 = load i64, i64* %11, align 8, !dbg !1697
  %64 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %62, i64 %63, !dbg !1696
  %65 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %64, i32 0, i32 1, !dbg !1698
  %66 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %65), !dbg !1699
  store i8* %66, i8** %9, align 8, !dbg !1700
  %67 = load i64, i64* %8, align 8, !dbg !1701
  %68 = icmp ne i64 %67, 0, !dbg !1701
  br i1 %68, label %69, label %81, !dbg !1703

69:                                               ; preds = %55
  %70 = load i8*, i8** %9, align 8, !dbg !1704
  %71 = icmp ne i8* %70, null, !dbg !1704
  br i1 %71, label %72, label %81, !dbg !1705

72:                                               ; preds = %69
  %73 = load i64, i64* %11, align 8, !dbg !1706
  %74 = add i64 %73, 1, !dbg !1708
  %75 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !1709
  %76 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %75, i32 0, i32 1, !dbg !1710
  store i64 %74, i64* %76, align 8, !dbg !1711
  %77 = load i64, i64* %8, align 8, !dbg !1712
  %78 = load i64*, i64** %6, align 8, !dbg !1713
  store i64 %77, i64* %78, align 8, !dbg !1714
  %79 = load i8*, i8** %9, align 8, !dbg !1715
  %80 = load i8**, i8*** %7, align 8, !dbg !1716
  store i8* %79, i8** %80, align 8, !dbg !1717
  store i1 true, i1* %4, align 1, !dbg !1718
  br label %86, !dbg !1718

81:                                               ; preds = %69, %55
  br label %82, !dbg !1719

82:                                               ; preds = %81
  %83 = load i64, i64* %11, align 8, !dbg !1720
  %84 = add i64 %83, 1, !dbg !1720
  store i64 %84, i64* %11, align 8, !dbg !1720
  br label %47, !dbg !1721, !llvm.loop !1722

85:                                               ; preds = %47
  store i1 false, i1* %4, align 1, !dbg !1724
  br label %86, !dbg !1724

86:                                               ; preds = %85, %72
  %87 = load i1, i1* %4, align 1, !dbg !1725
  ret i1 %87, !dbg !1725
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_subtract_from(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1) #0 !dbg !1726 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !1727, metadata !DIExpression()), !dbg !1728
  store %struct.trace_s* %1, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !1729, metadata !DIExpression()), !dbg !1730
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1731
  %6 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1732
  call void @_trace_merge_or_subtract(%struct.trace_s* noundef %5, %struct.trace_s* noundef %6, i1 noundef zeroext true), !dbg !1733
  ret void, !dbg !1734
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @trace_is_subtrace(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1, void (i64)* noundef %2) #0 !dbg !1735 {
  %4 = alloca i1, align 1
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca %struct.trace_s*, align 8
  %7 = alloca void (i64)*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca %struct.trace_unit_s*, align 8
  %11 = alloca %struct.trace_unit_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !1741, metadata !DIExpression()), !dbg !1742
  store %struct.trace_s* %1, %struct.trace_s** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %6, metadata !1743, metadata !DIExpression()), !dbg !1744
  store void (i64)* %2, void (i64)** %7, align 8
  call void @llvm.dbg.declare(metadata void (i64)** %7, metadata !1745, metadata !DIExpression()), !dbg !1746
  call void @llvm.dbg.declare(metadata i64* %8, metadata !1747, metadata !DIExpression()), !dbg !1748
  store i64 0, i64* %8, align 8, !dbg !1748
  call void @llvm.dbg.declare(metadata i64* %9, metadata !1749, metadata !DIExpression()), !dbg !1750
  store i64 0, i64* %9, align 8, !dbg !1750
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %10, metadata !1751, metadata !DIExpression()), !dbg !1752
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %11, metadata !1753, metadata !DIExpression()), !dbg !1754
  store i64 0, i64* %8, align 8, !dbg !1755
  br label %12, !dbg !1757

12:                                               ; preds = %86, %3
  %13 = load i64, i64* %8, align 8, !dbg !1758
  %14 = load %struct.trace_s*, %struct.trace_s** %6, align 8, !dbg !1760
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 1, !dbg !1761
  %16 = load i64, i64* %15, align 8, !dbg !1761
  %17 = icmp ult i64 %13, %16, !dbg !1762
  br i1 %17, label %18, label %89, !dbg !1763

18:                                               ; preds = %12
  %19 = load %struct.trace_s*, %struct.trace_s** %6, align 8, !dbg !1764
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 0, !dbg !1766
  %21 = load %struct.trace_unit_s*, %struct.trace_unit_s** %20, align 8, !dbg !1766
  %22 = load i64, i64* %8, align 8, !dbg !1767
  %23 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %21, i64 %22, !dbg !1764
  store %struct.trace_unit_s* %23, %struct.trace_unit_s** %10, align 8, !dbg !1768
  %24 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1769
  %25 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1771
  %26 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %25, i32 0, i32 0, !dbg !1772
  %27 = load i64, i64* %26, align 8, !dbg !1772
  %28 = call zeroext i1 @trace_find_unit_idx(%struct.trace_s* noundef %24, i64 noundef %27, i64* noundef %9), !dbg !1773
  br i1 %28, label %29, label %72, !dbg !1774

29:                                               ; preds = %18
  %30 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1775
  %31 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %30, i32 0, i32 0, !dbg !1777
  %32 = load %struct.trace_unit_s*, %struct.trace_unit_s** %31, align 8, !dbg !1777
  %33 = load i64, i64* %9, align 8, !dbg !1778
  %34 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %32, i64 %33, !dbg !1775
  store %struct.trace_unit_s* %34, %struct.trace_unit_s** %11, align 8, !dbg !1779
  %35 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1780
  %36 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %35, i32 0, i32 0, !dbg !1780
  %37 = load i64, i64* %36, align 8, !dbg !1780
  %38 = load %struct.trace_unit_s*, %struct.trace_unit_s** %11, align 8, !dbg !1780
  %39 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %38, i32 0, i32 0, !dbg !1780
  %40 = load i64, i64* %39, align 8, !dbg !1780
  %41 = icmp eq i64 %37, %40, !dbg !1780
  br i1 %41, label %42, label %43, !dbg !1783

42:                                               ; preds = %29
  br label %44, !dbg !1783

43:                                               ; preds = %29
  call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.44, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 308, i8* noundef getelementptr inbounds ([70 x i8], [70 x i8]* @__PRETTY_FUNCTION__.trace_is_subtrace, i64 0, i64 0)) #5, !dbg !1780
  unreachable, !dbg !1780

44:                                               ; preds = %42
  %45 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1784
  %46 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %45, i32 0, i32 1, !dbg !1786
  %47 = load i64, i64* %46, align 8, !dbg !1786
  %48 = load %struct.trace_unit_s*, %struct.trace_unit_s** %11, align 8, !dbg !1787
  %49 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %48, i32 0, i32 1, !dbg !1788
  %50 = load i64, i64* %49, align 8, !dbg !1788
  %51 = icmp ne i64 %47, %50, !dbg !1789
  br i1 %51, label %52, label %71, !dbg !1790

52:                                               ; preds = %44
  %53 = load void (i64)*, void (i64)** %7, align 8, !dbg !1791
  %54 = icmp ne void (i64)* %53, null, !dbg !1791
  br i1 %54, label %55, label %70, !dbg !1794

55:                                               ; preds = %52
  %56 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1795
  %57 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %56, i32 0, i32 0, !dbg !1797
  %58 = load i64, i64* %57, align 8, !dbg !1797
  %59 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1798
  %60 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %59, i32 0, i32 1, !dbg !1799
  %61 = load i64, i64* %60, align 8, !dbg !1799
  %62 = load %struct.trace_unit_s*, %struct.trace_unit_s** %11, align 8, !dbg !1800
  %63 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %62, i32 0, i32 1, !dbg !1801
  %64 = load i64, i64* %63, align 8, !dbg !1801
  %65 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @.str.45, i64 0, i64 0), i64 noundef %58, i64 noundef %61, i64 noundef %64), !dbg !1802
  %66 = load void (i64)*, void (i64)** %7, align 8, !dbg !1803
  %67 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1804
  %68 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %67, i32 0, i32 0, !dbg !1805
  %69 = load i64, i64* %68, align 8, !dbg !1805
  call void %66(i64 noundef %69), !dbg !1803
  br label %70, !dbg !1806

70:                                               ; preds = %55, %52
  store i1 false, i1* %4, align 1, !dbg !1807
  br label %90, !dbg !1807

71:                                               ; preds = %44
  br label %85, !dbg !1808

72:                                               ; preds = %18
  %73 = load void (i64)*, void (i64)** %7, align 8, !dbg !1809
  %74 = icmp ne void (i64)* %73, null, !dbg !1809
  br i1 %74, label %75, label %84, !dbg !1812

75:                                               ; preds = %72
  %76 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1813
  %77 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %76, i32 0, i32 0, !dbg !1815
  %78 = load i64, i64* %77, align 8, !dbg !1815
  %79 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.46, i64 0, i64 0), i64 noundef %78), !dbg !1816
  %80 = load void (i64)*, void (i64)** %7, align 8, !dbg !1817
  %81 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !1818
  %82 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %81, i32 0, i32 0, !dbg !1819
  %83 = load i64, i64* %82, align 8, !dbg !1819
  call void %80(i64 noundef %83), !dbg !1817
  br label %84, !dbg !1820

84:                                               ; preds = %75, %72
  store i1 false, i1* %4, align 1, !dbg !1821
  br label %90, !dbg !1821

85:                                               ; preds = %71
  br label %86, !dbg !1822

86:                                               ; preds = %85
  %87 = load i64, i64* %8, align 8, !dbg !1823
  %88 = add i64 %87, 1, !dbg !1823
  store i64 %88, i64* %8, align 8, !dbg !1823
  br label %12, !dbg !1824, !llvm.loop !1825

89:                                               ; preds = %12
  store i1 true, i1* %4, align 1, !dbg !1827
  br label %90, !dbg !1827

90:                                               ; preds = %89, %84, %70
  %91 = load i1, i1* %4, align 1, !dbg !1828
  ret i1 %91, !dbg !1828
}

; Function Attrs: noinline nounwind uwtable
define internal void @_trace_merge_or_subtract(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1, i1 noundef zeroext %2) #0 !dbg !1829 {
  %4 = alloca %struct.trace_s*, align 8
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca i8, align 1
  %7 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !1832, metadata !DIExpression()), !dbg !1833
  store %struct.trace_s* %1, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !1834, metadata !DIExpression()), !dbg !1835
  %8 = zext i1 %2 to i8
  store i8 %8, i8* %6, align 1
  call void @llvm.dbg.declare(metadata i8* %6, metadata !1836, metadata !DIExpression()), !dbg !1837
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1838, metadata !DIExpression()), !dbg !1839
  store i64 0, i64* %7, align 8, !dbg !1839
  %9 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1840
  %10 = icmp ne %struct.trace_s* %9, null, !dbg !1840
  br i1 %10, label %11, label %12, !dbg !1843

11:                                               ; preds = %3
  br label %13, !dbg !1843

12:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.37, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 165, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !1840
  unreachable, !dbg !1840

13:                                               ; preds = %11
  %14 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1844
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 3, !dbg !1844
  %16 = load i8, i8* %15, align 8, !dbg !1844
  %17 = trunc i8 %16 to i1, !dbg !1844
  br i1 %17, label %18, label %19, !dbg !1847

18:                                               ; preds = %13
  br label %20, !dbg !1847

19:                                               ; preds = %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.38, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 166, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !1844
  unreachable, !dbg !1844

20:                                               ; preds = %18
  %21 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1848
  %22 = icmp ne %struct.trace_s* %21, null, !dbg !1848
  br i1 %22, label %23, label %24, !dbg !1851

23:                                               ; preds = %20
  br label %25, !dbg !1851

24:                                               ; preds = %20
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 168, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !1848
  unreachable, !dbg !1848

25:                                               ; preds = %23
  %26 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1852
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 3, !dbg !1852
  %28 = load i8, i8* %27, align 8, !dbg !1852
  %29 = trunc i8 %28 to i1, !dbg !1852
  br i1 %29, label %30, label %31, !dbg !1855

30:                                               ; preds = %25
  br label %32, !dbg !1855

31:                                               ; preds = %25
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.20, i64 0, i64 0), i32 noundef 169, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !1852
  unreachable, !dbg !1852

32:                                               ; preds = %30
  store i64 0, i64* %7, align 8, !dbg !1856
  br label %33, !dbg !1858

33:                                               ; preds = %57, %32
  %34 = load i64, i64* %7, align 8, !dbg !1859
  %35 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1861
  %36 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %35, i32 0, i32 1, !dbg !1862
  %37 = load i64, i64* %36, align 8, !dbg !1862
  %38 = icmp ult i64 %34, %37, !dbg !1863
  br i1 %38, label %39, label %60, !dbg !1864

39:                                               ; preds = %33
  %40 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !1865
  %41 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1867
  %42 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %41, i32 0, i32 0, !dbg !1868
  %43 = load %struct.trace_unit_s*, %struct.trace_unit_s** %42, align 8, !dbg !1868
  %44 = load i64, i64* %7, align 8, !dbg !1869
  %45 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %43, i64 %44, !dbg !1867
  %46 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %45, i32 0, i32 0, !dbg !1870
  %47 = load i64, i64* %46, align 8, !dbg !1870
  %48 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1871
  %49 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %48, i32 0, i32 0, !dbg !1872
  %50 = load %struct.trace_unit_s*, %struct.trace_unit_s** %49, align 8, !dbg !1872
  %51 = load i64, i64* %7, align 8, !dbg !1873
  %52 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %50, i64 %51, !dbg !1871
  %53 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %52, i32 0, i32 1, !dbg !1874
  %54 = load i64, i64* %53, align 8, !dbg !1874
  %55 = load i8, i8* %6, align 1, !dbg !1875
  %56 = trunc i8 %55 to i1, !dbg !1875
  call void @_trace_add_or_rem_occurrences(%struct.trace_s* noundef %40, i64 noundef %47, i64 noundef %54, i1 noundef zeroext %56), !dbg !1876
  br label %57, !dbg !1877

57:                                               ; preds = %39
  %58 = load i64, i64* %7, align 8, !dbg !1878
  %59 = add i64 %58, 1, !dbg !1878
  store i64 %59, i64* %7, align 8, !dbg !1878
  br label %33, !dbg !1879, !llvm.loop !1880

60:                                               ; preds = %33
  ret void, !dbg !1882
}

declare i32 @printf(i8* noundef, ...) #4

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !1883 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !1884, metadata !DIExpression()), !dbg !1885
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1886, !srcloc !1887
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1888, metadata !DIExpression()), !dbg !1889
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !1890
  %6 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %5, i32 0, i32 0, !dbg !1891
  %7 = bitcast i8** %6 to i64*, !dbg !1892
  %8 = bitcast i8** %4 to i64*, !dbg !1892
  %9 = load atomic i64, i64* %7 monotonic, align 8, !dbg !1892
  store i64 %9, i64* %8, align 8, !dbg !1892
  %10 = bitcast i64* %8 to i8**, !dbg !1892
  %11 = load i8*, i8** %10, align 8, !dbg !1892
  store i8* %11, i8** %3, align 8, !dbg !1889
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1893, !srcloc !1894
  %12 = load i8*, i8** %3, align 8, !dbg !1895
  ret i8* %12, !dbg !1896
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!172, !173, !174, !175, !176, !177, !178}
!llvm.ident = !{!179}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_tid", scope: !2, file: !101, line: 29, type: !29, isLocal: false, isDefinition: true)
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
!53 = !{!0, !54, !149, !168, !170}
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "g_simpleht", scope: !2, file: !56, line: 35, type: !57, isLocal: true, isDefinition: true)
!56 = !DIFile(filename: "test/include/test/map/isimple.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "9bd6bf935fca0aec8816b4ad5eb860a6")
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_t", file: !6, line: 94, baseType: !58)
!58 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vsimpleht_s", file: !6, line: 83, size: 1472, elements: !59)
!59 = !{!60, !61, !73, !83, !88, !93, !94, !99}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "capacity", scope: !58, file: !6, line: 84, baseType: !14, size: 64)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "entries", scope: !58, file: !6, line: 85, baseType: !62, size: 64, offset: 64)
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_entry_t", file: !6, line: 81, baseType: !64)
!64 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vsimpleht_entry_s", file: !6, line: 78, size: 128, elements: !65)
!65 = !{!66, !72}
!66 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !64, file: !6, line: 79, baseType: !67, size: 64, align: 64)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomicptr_t", file: !68, line: 45, baseType: !69)
!68 = !DIFile(filename: "vatomic/include/vsync/atomic/internal/types.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "4649bfff29481cecec17d9044409fd19")
!69 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomicptr_s", file: !68, line: 43, size: 64, align: 64, elements: !70)
!70 = !{!71}
!71 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !69, file: !68, line: 44, baseType: !22, size: 64)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !64, file: !6, line: 80, baseType: !67, size: 64, align: 64, offset: 64)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "cmp_key", scope: !58, file: !6, line: 86, baseType: !74, size: 64, offset: 128)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_cmp_key_t", file: !6, line: 74, baseType: !75)
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!76 = !DISubroutineType(types: !77)
!77 = !{!78, !19, !19}
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "vint8_t", file: !15, line: 40, baseType: !79)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !80, line: 24, baseType: !81)
!80 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "", checksumkind: CSK_MD5, checksum: "55bcbdc3159515ebd91d351a70d505f4")
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !27, line: 37, baseType: !82)
!82 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "hash_key", scope: !58, file: !6, line: 87, baseType: !84, size: 64, offset: 192)
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_hash_key_t", file: !6, line: 75, baseType: !85)
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!86 = !DISubroutineType(types: !87)
!87 = !{!49, !19}
!88 = !DIDerivedType(tag: DW_TAG_member, name: "cb_destroy", scope: !58, file: !6, line: 88, baseType: !89, size: 64, offset: 256)
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_destroy_entry_t", file: !6, line: 76, baseType: !90)
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !91, size: 64)
!91 = !DISubroutineType(types: !92)
!92 = !{null, !22}
!93 = !DIDerivedType(tag: DW_TAG_member, name: "cleaning_threshold", scope: !58, file: !6, line: 90, baseType: !14, size: 64, offset: 320)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "deleted_count", scope: !58, file: !6, line: 91, baseType: !95, size: 64, align: 64, offset: 384)
!95 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomicsz_t", file: !68, line: 50, baseType: !96)
!96 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomicsz_s", file: !68, line: 48, size: 64, align: 64, elements: !97)
!97 = !{!98}
!98 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !96, file: !68, line: 49, baseType: !14, size: 64)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !58, file: !6, line: 92, baseType: !100, size: 1024, offset: 448)
!100 = !DIDerivedType(tag: DW_TAG_typedef, name: "rwlock_t", file: !101, line: 27, baseType: !102)
!101 = !DIFile(filename: "verify/include/verify/rwlock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "d22ae5b6c849e685e5cacdc91023be13")
!102 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "rwlock_s", file: !101, line: 23, size: 1024, elements: !103)
!103 = !{!104, !139, !144}
!104 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !102, file: !101, line: 24, baseType: !105, size: 960)
!105 = !DICompositeType(tag: DW_TAG_array_type, baseType: !106, size: 960, elements: !137)
!106 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !39, line: 72, baseType: !107)
!107 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !39, line: 67, size: 320, elements: !108)
!108 = !{!109, !130, !135}
!109 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !107, file: !39, line: 69, baseType: !110, size: 320)
!110 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !111, line: 22, size: 320, elements: !112)
!111 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "584baedd80e6041b81caae7f496091c0")
!112 = !{!113, !115, !116, !117, !118, !119, !121, !122}
!113 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !110, file: !111, line: 24, baseType: !114, size: 32)
!114 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !110, file: !111, line: 25, baseType: !7, size: 32, offset: 32)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !110, file: !111, line: 26, baseType: !114, size: 32, offset: 64)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !110, file: !111, line: 28, baseType: !7, size: 32, offset: 96)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !110, file: !111, line: 32, baseType: !114, size: 32, offset: 128)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !110, file: !111, line: 34, baseType: !120, size: 16, offset: 160)
!120 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !110, file: !111, line: 35, baseType: !120, size: 16, offset: 176)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !110, file: !111, line: 36, baseType: !123, size: 128, offset: 192)
!123 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !124, line: 55, baseType: !125)
!124 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "04c81e86d34dad9c99ad006d32e47a0d")
!125 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !124, line: 51, size: 128, elements: !126)
!126 = !{!127, !129}
!127 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !125, file: !124, line: 53, baseType: !128, size: 64)
!128 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !125, size: 64)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !125, file: !124, line: 54, baseType: !128, size: 64, offset: 64)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !107, file: !39, line: 70, baseType: !131, size: 320)
!131 = !DICompositeType(tag: DW_TAG_array_type, baseType: !132, size: 320, elements: !133)
!132 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!133 = !{!134}
!134 = !DISubrange(count: 40)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !107, file: !39, line: 71, baseType: !136, size: 64)
!136 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!137 = !{!138}
!138 = !DISubrange(count: 3)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "writer_active", scope: !102, file: !101, line: 25, baseType: !140, size: 8, offset: 960)
!140 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic8_t", file: !68, line: 25, baseType: !141)
!141 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic8_s", file: !68, line: 23, size: 8, elements: !142)
!142 = !{!143}
!143 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !141, file: !68, line: 24, baseType: !23, size: 8)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "idx", scope: !102, file: !101, line: 26, baseType: !145, size: 32, align: 32, offset: 992)
!145 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !68, line: 35, baseType: !146)
!146 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !68, line: 33, size: 32, align: 32, elements: !147)
!147 = !{!148}
!148 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !146, file: !68, line: 34, baseType: !29, size: 32)
!149 = !DIGlobalVariableExpression(var: !150, expr: !DIExpression())
!150 = distinct !DIGlobalVariable(name: "g_add", scope: !2, file: !56, line: 33, type: !151, isLocal: true, isDefinition: true)
!151 = !DICompositeType(tag: DW_TAG_array_type, baseType: !152, size: 1024, elements: !166)
!152 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_t", file: !153, line: 29, baseType: !154)
!153 = !DIFile(filename: "test/include/test/trace_manager.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "5ba0f33a5901d8ee1ef7d1e8c3546fa0")
!154 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_s", file: !153, line: 24, size: 256, elements: !155)
!155 = !{!156, !163, !164, !165}
!156 = !DIDerivedType(tag: DW_TAG_member, name: "units", scope: !154, file: !153, line: 25, baseType: !157, size: 64)
!157 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !158, size: 64)
!158 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_unit_t", file: !153, line: 22, baseType: !159)
!159 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_unit_s", file: !153, line: 19, size: 128, elements: !160)
!160 = !{!161, !162}
!161 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !159, file: !153, line: 20, baseType: !19, size: 64)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !159, file: !153, line: 21, baseType: !14, size: 64, offset: 64)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !154, file: !153, line: 26, baseType: !14, size: 64, offset: 64)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "capacity", scope: !154, file: !153, line: 27, baseType: !14, size: 64, offset: 128)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "initialized", scope: !154, file: !153, line: 28, baseType: !42, size: 8, offset: 192)
!166 = !{!167}
!167 = !DISubrange(count: 4)
!168 = !DIGlobalVariableExpression(var: !169, expr: !DIExpression())
!169 = distinct !DIGlobalVariable(name: "g_rem", scope: !2, file: !56, line: 34, type: !151, isLocal: true, isDefinition: true)
!170 = !DIGlobalVariableExpression(var: !171, expr: !DIExpression())
!171 = distinct !DIGlobalVariable(name: "g_buff", scope: !2, file: !56, line: 36, type: !22, isLocal: true, isDefinition: true)
!172 = !{i32 7, !"Dwarf Version", i32 5}
!173 = !{i32 2, !"Debug Info Version", i32 3}
!174 = !{i32 1, !"wchar_size", i32 4}
!175 = !{i32 7, !"PIC Level", i32 2}
!176 = !{i32 7, !"PIE Level", i32 2}
!177 = !{i32 7, !"uwtable", i32 1}
!178 = !{i32 7, !"frame-pointer", i32 2}
!179 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!180 = distinct !DISubprogram(name: "pre", scope: !181, file: !181, line: 9, type: !182, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!181 = !DIFile(filename: "verify/simpleht/test_case_add.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "28f7fe553aafda98dd5e3b41b3813be9")
!182 = !DISubroutineType(types: !183)
!183 = !{null}
!184 = !{}
!185 = !DILocation(line: 11, column: 1, scope: !180)
!186 = distinct !DISubprogram(name: "t0", scope: !181, file: !181, line: 13, type: !187, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!187 = !DISubroutineType(types: !188)
!188 = !{null, !14}
!189 = !DILocalVariable(name: "tid", arg: 1, scope: !186, file: !181, line: 13, type: !14)
!190 = !DILocation(line: 13, column: 12, scope: !186)
!191 = !DILocalVariable(name: "success", scope: !186, file: !181, line: 15, type: !42)
!192 = !DILocation(line: 15, column: 13, scope: !186)
!193 = !DILocation(line: 15, column: 32, scope: !186)
!194 = !DILocation(line: 15, column: 23, scope: !186)
!195 = !DILocation(line: 16, column: 5, scope: !196)
!196 = distinct !DILexicalBlock(scope: !197, file: !181, line: 16, column: 5)
!197 = distinct !DILexicalBlock(scope: !186, file: !181, line: 16, column: 5)
!198 = !DILocation(line: 16, column: 5, scope: !197)
!199 = !DILocation(line: 17, column: 1, scope: !186)
!200 = distinct !DISubprogram(name: "imap_add", scope: !56, file: !56, line: 140, type: !201, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!201 = !DISubroutineType(types: !202)
!202 = !{!42, !14, !19, !49}
!203 = !DILocalVariable(name: "tid", arg: 1, scope: !200, file: !56, line: 140, type: !14)
!204 = !DILocation(line: 140, column: 18, scope: !200)
!205 = !DILocalVariable(name: "key", arg: 2, scope: !200, file: !56, line: 140, type: !19)
!206 = !DILocation(line: 140, column: 34, scope: !200)
!207 = !DILocalVariable(name: "val", arg: 3, scope: !200, file: !56, line: 140, type: !49)
!208 = !DILocation(line: 140, column: 49, scope: !200)
!209 = !DILocalVariable(name: "data", scope: !200, file: !56, line: 142, type: !210)
!210 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !211, size: 64)
!211 = !DIDerivedType(tag: DW_TAG_typedef, name: "data_t", file: !56, line: 30, baseType: !212)
!212 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "data_s", file: !56, line: 27, size: 128, elements: !213)
!213 = !{!214, !215}
!214 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !212, file: !56, line: 28, baseType: !19, size: 64)
!215 = !DIDerivedType(tag: DW_TAG_member, name: "val", scope: !212, file: !56, line: 29, baseType: !49, size: 64, offset: 64)
!216 = !DILocation(line: 142, column: 13, scope: !200)
!217 = !DILocation(line: 142, column: 20, scope: !200)
!218 = !DILocation(line: 143, column: 20, scope: !200)
!219 = !DILocation(line: 143, column: 5, scope: !200)
!220 = !DILocation(line: 143, column: 11, scope: !200)
!221 = !DILocation(line: 143, column: 18, scope: !200)
!222 = !DILocation(line: 144, column: 20, scope: !200)
!223 = !DILocation(line: 144, column: 5, scope: !200)
!224 = !DILocation(line: 144, column: 11, scope: !200)
!225 = !DILocation(line: 144, column: 18, scope: !200)
!226 = !DILocalVariable(name: "added", scope: !200, file: !56, line: 145, type: !42)
!227 = !DILocation(line: 145, column: 13, scope: !200)
!228 = !DILocation(line: 146, column: 36, scope: !200)
!229 = !DILocation(line: 146, column: 42, scope: !200)
!230 = !DILocation(line: 146, column: 47, scope: !200)
!231 = !DILocation(line: 146, column: 9, scope: !200)
!232 = !DILocation(line: 146, column: 53, scope: !200)
!233 = !DILocation(line: 147, column: 9, scope: !234)
!234 = distinct !DILexicalBlock(scope: !200, file: !56, line: 147, column: 9)
!235 = !DILocation(line: 147, column: 9, scope: !200)
!236 = !DILocation(line: 148, column: 26, scope: !237)
!237 = distinct !DILexicalBlock(scope: !234, file: !56, line: 147, column: 16)
!238 = !DILocation(line: 148, column: 20, scope: !237)
!239 = !DILocation(line: 148, column: 32, scope: !237)
!240 = !DILocation(line: 148, column: 38, scope: !237)
!241 = !DILocation(line: 148, column: 9, scope: !237)
!242 = !DILocation(line: 149, column: 5, scope: !237)
!243 = !DILocation(line: 150, column: 14, scope: !244)
!244 = distinct !DILexicalBlock(scope: !234, file: !56, line: 149, column: 12)
!245 = !DILocation(line: 150, column: 9, scope: !244)
!246 = !DILocation(line: 152, column: 12, scope: !200)
!247 = !DILocation(line: 152, column: 5, scope: !200)
!248 = distinct !DISubprogram(name: "t1", scope: !181, file: !181, line: 19, type: !187, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!249 = !DILocalVariable(name: "tid", arg: 1, scope: !248, file: !181, line: 19, type: !14)
!250 = !DILocation(line: 19, column: 12, scope: !248)
!251 = !DILocalVariable(name: "success", scope: !248, file: !181, line: 21, type: !42)
!252 = !DILocation(line: 21, column: 13, scope: !248)
!253 = !DILocation(line: 21, column: 32, scope: !248)
!254 = !DILocation(line: 21, column: 23, scope: !248)
!255 = !DILocation(line: 22, column: 5, scope: !256)
!256 = distinct !DILexicalBlock(scope: !257, file: !181, line: 22, column: 5)
!257 = distinct !DILexicalBlock(scope: !248, file: !181, line: 22, column: 5)
!258 = !DILocation(line: 22, column: 5, scope: !257)
!259 = !DILocation(line: 23, column: 1, scope: !248)
!260 = distinct !DISubprogram(name: "t2", scope: !181, file: !181, line: 25, type: !187, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!261 = !DILocalVariable(name: "tid", arg: 1, scope: !260, file: !181, line: 25, type: !14)
!262 = !DILocation(line: 25, column: 12, scope: !260)
!263 = !DILocalVariable(name: "success", scope: !260, file: !181, line: 27, type: !42)
!264 = !DILocation(line: 27, column: 13, scope: !260)
!265 = !DILocation(line: 27, column: 32, scope: !260)
!266 = !DILocation(line: 27, column: 23, scope: !260)
!267 = !DILocation(line: 28, column: 5, scope: !268)
!268 = distinct !DILexicalBlock(scope: !269, file: !181, line: 28, column: 5)
!269 = distinct !DILexicalBlock(scope: !260, file: !181, line: 28, column: 5)
!270 = !DILocation(line: 28, column: 5, scope: !269)
!271 = !DILocation(line: 29, column: 1, scope: !260)
!272 = distinct !DISubprogram(name: "post", scope: !181, file: !181, line: 31, type: !182, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!273 = !DILocalVariable(name: "k", scope: !274, file: !181, line: 33, type: !19)
!274 = distinct !DILexicalBlock(scope: !272, file: !181, line: 33, column: 5)
!275 = !DILocation(line: 33, column: 21, scope: !274)
!276 = !DILocation(line: 33, column: 10, scope: !274)
!277 = !DILocation(line: 33, column: 28, scope: !278)
!278 = distinct !DILexicalBlock(scope: !274, file: !181, line: 33, column: 5)
!279 = !DILocation(line: 33, column: 30, scope: !278)
!280 = !DILocation(line: 33, column: 5, scope: !274)
!281 = !DILocalVariable(name: "d", scope: !282, file: !181, line: 34, type: !210)
!282 = distinct !DILexicalBlock(scope: !278, file: !181, line: 33, column: 41)
!283 = !DILocation(line: 34, column: 17, scope: !282)
!284 = !DILocation(line: 34, column: 40, scope: !282)
!285 = !DILocation(line: 34, column: 21, scope: !282)
!286 = !DILocation(line: 35, column: 9, scope: !287)
!287 = distinct !DILexicalBlock(scope: !288, file: !181, line: 35, column: 9)
!288 = distinct !DILexicalBlock(scope: !282, file: !181, line: 35, column: 9)
!289 = !DILocation(line: 35, column: 9, scope: !288)
!290 = !DILocation(line: 36, column: 9, scope: !291)
!291 = distinct !DILexicalBlock(scope: !292, file: !181, line: 36, column: 9)
!292 = distinct !DILexicalBlock(scope: !282, file: !181, line: 36, column: 9)
!293 = !DILocation(line: 36, column: 9, scope: !292)
!294 = !DILocation(line: 37, column: 5, scope: !282)
!295 = !DILocation(line: 33, column: 37, scope: !278)
!296 = !DILocation(line: 33, column: 5, scope: !278)
!297 = distinct !{!297, !280, !298, !299}
!298 = !DILocation(line: 37, column: 5, scope: !274)
!299 = !{!"llvm.loop.mustprogress"}
!300 = !DILocation(line: 38, column: 1, scope: !272)
!301 = distinct !DISubprogram(name: "imap_get", scope: !56, file: !56, line: 166, type: !302, scopeLine: 167, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!302 = !DISubroutineType(types: !303)
!303 = !{!22, !14, !19}
!304 = !DILocalVariable(name: "tid", arg: 1, scope: !301, file: !56, line: 166, type: !14)
!305 = !DILocation(line: 166, column: 18, scope: !301)
!306 = !DILocalVariable(name: "key", arg: 2, scope: !301, file: !56, line: 166, type: !19)
!307 = !DILocation(line: 166, column: 34, scope: !301)
!308 = !DILocation(line: 168, column: 5, scope: !301)
!309 = !DILocation(line: 168, column: 5, scope: !310)
!310 = distinct !DILexicalBlock(scope: !301, file: !56, line: 168, column: 5)
!311 = !DILocation(line: 168, column: 5, scope: !312)
!312 = distinct !DILexicalBlock(scope: !310, file: !56, line: 168, column: 5)
!313 = !DILocation(line: 168, column: 5, scope: !314)
!314 = distinct !DILexicalBlock(scope: !312, file: !56, line: 168, column: 5)
!315 = !DILocalVariable(name: "data", scope: !301, file: !56, line: 169, type: !210)
!316 = !DILocation(line: 169, column: 13, scope: !301)
!317 = !DILocation(line: 169, column: 47, scope: !301)
!318 = !DILocation(line: 169, column: 20, scope: !301)
!319 = !DILocation(line: 170, column: 9, scope: !320)
!320 = distinct !DILexicalBlock(scope: !301, file: !56, line: 170, column: 9)
!321 = !DILocation(line: 170, column: 9, scope: !301)
!322 = !DILocation(line: 171, column: 9, scope: !323)
!323 = distinct !DILexicalBlock(scope: !324, file: !56, line: 171, column: 9)
!324 = distinct !DILexicalBlock(scope: !325, file: !56, line: 171, column: 9)
!325 = distinct !DILexicalBlock(scope: !320, file: !56, line: 170, column: 15)
!326 = !DILocation(line: 171, column: 9, scope: !324)
!327 = !DILocation(line: 172, column: 5, scope: !325)
!328 = !DILocation(line: 173, column: 12, scope: !301)
!329 = !DILocation(line: 173, column: 5, scope: !301)
!330 = distinct !DISubprogram(name: "run", scope: !331, file: !331, line: 94, type: !47, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!331 = !DIFile(filename: "test/include/test/boilerplate/test_case.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "ec4420aa4ca09b8f4298c137e9e77071")
!332 = !DILocalVariable(name: "args", arg: 1, scope: !330, file: !331, line: 94, type: !22)
!333 = !DILocation(line: 94, column: 11, scope: !330)
!334 = !DILocalVariable(name: "tid", scope: !330, file: !331, line: 96, type: !14)
!335 = !DILocation(line: 96, column: 13, scope: !330)
!336 = !DILocation(line: 96, column: 40, scope: !330)
!337 = !DILocation(line: 96, column: 28, scope: !330)
!338 = !DILocation(line: 97, column: 5, scope: !339)
!339 = distinct !DILexicalBlock(scope: !340, file: !331, line: 97, column: 5)
!340 = distinct !DILexicalBlock(scope: !330, file: !331, line: 97, column: 5)
!341 = !DILocation(line: 97, column: 5, scope: !340)
!342 = !DILocation(line: 99, column: 9, scope: !330)
!343 = !DILocation(line: 99, column: 5, scope: !330)
!344 = !DILocation(line: 100, column: 13, scope: !330)
!345 = !DILocation(line: 100, column: 5, scope: !330)
!346 = !DILocation(line: 102, column: 16, scope: !347)
!347 = distinct !DILexicalBlock(scope: !330, file: !331, line: 100, column: 18)
!348 = !DILocation(line: 102, column: 13, scope: !347)
!349 = !DILocation(line: 103, column: 13, scope: !347)
!350 = !DILocation(line: 105, column: 16, scope: !347)
!351 = !DILocation(line: 105, column: 13, scope: !347)
!352 = !DILocation(line: 106, column: 13, scope: !347)
!353 = !DILocation(line: 108, column: 16, scope: !347)
!354 = !DILocation(line: 108, column: 13, scope: !347)
!355 = !DILocation(line: 109, column: 13, scope: !347)
!356 = !DILocation(line: 116, column: 13, scope: !347)
!357 = !DILocation(line: 118, column: 11, scope: !330)
!358 = !DILocation(line: 118, column: 5, scope: !330)
!359 = !DILocation(line: 119, column: 5, scope: !330)
!360 = distinct !DISubprogram(name: "reg", scope: !361, file: !361, line: 11, type: !187, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!361 = !DIFile(filename: "verify/simpleht/verify.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "fef1aee1945b19b211b0b629c38d4444")
!362 = !DILocalVariable(name: "tid", arg: 1, scope: !360, file: !361, line: 11, type: !14)
!363 = !DILocation(line: 11, column: 13, scope: !360)
!364 = !DILocation(line: 13, column: 14, scope: !360)
!365 = !DILocation(line: 13, column: 5, scope: !360)
!366 = !DILocation(line: 14, column: 1, scope: !360)
!367 = distinct !DISubprogram(name: "dereg", scope: !361, file: !361, line: 16, type: !187, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!368 = !DILocalVariable(name: "tid", arg: 1, scope: !367, file: !361, line: 16, type: !14)
!369 = !DILocation(line: 16, column: 15, scope: !367)
!370 = !DILocation(line: 18, column: 16, scope: !367)
!371 = !DILocation(line: 18, column: 5, scope: !367)
!372 = !DILocation(line: 19, column: 1, scope: !367)
!373 = distinct !DISubprogram(name: "tc", scope: !331, file: !331, line: 129, type: !182, scopeLine: 130, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!374 = !DILocation(line: 131, column: 5, scope: !373)
!375 = !DILocation(line: 132, column: 5, scope: !373)
!376 = !DILocation(line: 133, column: 5, scope: !373)
!377 = !DILocation(line: 134, column: 5, scope: !373)
!378 = !DILocation(line: 135, column: 5, scope: !373)
!379 = !DILocation(line: 136, column: 1, scope: !373)
!380 = distinct !DISubprogram(name: "init", scope: !361, file: !361, line: 22, type: !182, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!381 = !DILocation(line: 24, column: 5, scope: !380)
!382 = !DILocation(line: 25, column: 1, scope: !380)
!383 = distinct !DISubprogram(name: "launch_threads", scope: !34, file: !34, line: 119, type: !384, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!384 = !DISubroutineType(types: !385)
!385 = !{null, !14, !45}
!386 = !DILocalVariable(name: "thread_count", arg: 1, scope: !383, file: !34, line: 119, type: !14)
!387 = !DILocation(line: 119, column: 24, scope: !383)
!388 = !DILocalVariable(name: "fun", arg: 2, scope: !383, file: !34, line: 119, type: !45)
!389 = !DILocation(line: 119, column: 51, scope: !383)
!390 = !DILocalVariable(name: "threads", scope: !383, file: !34, line: 121, type: !32)
!391 = !DILocation(line: 121, column: 17, scope: !383)
!392 = !DILocation(line: 121, column: 55, scope: !383)
!393 = !DILocation(line: 121, column: 53, scope: !383)
!394 = !DILocation(line: 121, column: 27, scope: !383)
!395 = !DILocation(line: 123, column: 20, scope: !383)
!396 = !DILocation(line: 123, column: 29, scope: !383)
!397 = !DILocation(line: 123, column: 43, scope: !383)
!398 = !DILocation(line: 123, column: 5, scope: !383)
!399 = !DILocation(line: 125, column: 19, scope: !383)
!400 = !DILocation(line: 125, column: 28, scope: !383)
!401 = !DILocation(line: 125, column: 5, scope: !383)
!402 = !DILocation(line: 127, column: 10, scope: !383)
!403 = !DILocation(line: 127, column: 5, scope: !383)
!404 = !DILocation(line: 128, column: 1, scope: !383)
!405 = distinct !DISubprogram(name: "fini", scope: !361, file: !361, line: 27, type: !182, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!406 = !DILocation(line: 29, column: 5, scope: !405)
!407 = !DILocation(line: 30, column: 1, scope: !405)
!408 = distinct !DISubprogram(name: "imap_reg", scope: !56, file: !56, line: 177, type: !187, scopeLine: 178, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!409 = !DILocalVariable(name: "tid", arg: 1, scope: !408, file: !56, line: 177, type: !14)
!410 = !DILocation(line: 177, column: 18, scope: !408)
!411 = !DILocation(line: 179, column: 5, scope: !408)
!412 = !DILocation(line: 179, column: 5, scope: !413)
!413 = distinct !DILexicalBlock(scope: !408, file: !56, line: 179, column: 5)
!414 = !DILocation(line: 179, column: 5, scope: !415)
!415 = distinct !DILexicalBlock(scope: !413, file: !56, line: 179, column: 5)
!416 = !DILocation(line: 179, column: 5, scope: !417)
!417 = distinct !DILexicalBlock(scope: !415, file: !56, line: 179, column: 5)
!418 = !DILocation(line: 180, column: 5, scope: !408)
!419 = !DILocation(line: 181, column: 1, scope: !408)
!420 = distinct !DISubprogram(name: "imap_dereg", scope: !56, file: !56, line: 184, type: !187, scopeLine: 185, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!421 = !DILocalVariable(name: "tid", arg: 1, scope: !420, file: !56, line: 184, type: !14)
!422 = !DILocation(line: 184, column: 20, scope: !420)
!423 = !DILocation(line: 186, column: 5, scope: !420)
!424 = !DILocation(line: 186, column: 5, scope: !425)
!425 = distinct !DILexicalBlock(scope: !420, file: !56, line: 186, column: 5)
!426 = !DILocation(line: 186, column: 5, scope: !427)
!427 = distinct !DILexicalBlock(scope: !425, file: !56, line: 186, column: 5)
!428 = !DILocation(line: 186, column: 5, scope: !429)
!429 = distinct !DILexicalBlock(scope: !427, file: !56, line: 186, column: 5)
!430 = !DILocation(line: 187, column: 5, scope: !420)
!431 = !DILocation(line: 188, column: 1, scope: !420)
!432 = distinct !DISubprogram(name: "imap_init", scope: !56, file: !56, line: 114, type: !182, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!433 = !DILocalVariable(name: "sz", scope: !432, file: !56, line: 116, type: !14)
!434 = !DILocation(line: 116, column: 13, scope: !432)
!435 = !DILocation(line: 116, column: 20, scope: !432)
!436 = !DILocalVariable(name: "g_buff", scope: !432, file: !56, line: 117, type: !22)
!437 = !DILocation(line: 117, column: 11, scope: !432)
!438 = !DILocation(line: 117, column: 27, scope: !432)
!439 = !DILocation(line: 117, column: 20, scope: !432)
!440 = !DILocation(line: 119, column: 33, scope: !432)
!441 = !DILocation(line: 119, column: 5, scope: !432)
!442 = !DILocalVariable(name: "i", scope: !443, file: !56, line: 122, type: !14)
!443 = distinct !DILexicalBlock(scope: !432, file: !56, line: 122, column: 5)
!444 = !DILocation(line: 122, column: 18, scope: !443)
!445 = !DILocation(line: 122, column: 10, scope: !443)
!446 = !DILocation(line: 122, column: 25, scope: !447)
!447 = distinct !DILexicalBlock(scope: !443, file: !56, line: 122, column: 5)
!448 = !DILocation(line: 122, column: 27, scope: !447)
!449 = !DILocation(line: 122, column: 5, scope: !443)
!450 = !DILocation(line: 123, column: 27, scope: !451)
!451 = distinct !DILexicalBlock(scope: !447, file: !56, line: 122, column: 43)
!452 = !DILocation(line: 123, column: 21, scope: !451)
!453 = !DILocation(line: 123, column: 9, scope: !451)
!454 = !DILocation(line: 124, column: 27, scope: !451)
!455 = !DILocation(line: 124, column: 21, scope: !451)
!456 = !DILocation(line: 124, column: 9, scope: !451)
!457 = !DILocation(line: 125, column: 5, scope: !451)
!458 = !DILocation(line: 122, column: 39, scope: !447)
!459 = !DILocation(line: 122, column: 5, scope: !447)
!460 = distinct !{!460, !449, !461, !299}
!461 = !DILocation(line: 125, column: 5, scope: !443)
!462 = !DILocation(line: 126, column: 1, scope: !432)
!463 = distinct !DISubprogram(name: "imap_destroy", scope: !56, file: !56, line: 128, type: !182, scopeLine: 129, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!464 = !DILocation(line: 130, column: 5, scope: !463)
!465 = !DILocalVariable(name: "i", scope: !466, file: !56, line: 131, type: !14)
!466 = distinct !DILexicalBlock(scope: !463, file: !56, line: 131, column: 5)
!467 = !DILocation(line: 131, column: 18, scope: !466)
!468 = !DILocation(line: 131, column: 10, scope: !466)
!469 = !DILocation(line: 131, column: 25, scope: !470)
!470 = distinct !DILexicalBlock(scope: !466, file: !56, line: 131, column: 5)
!471 = !DILocation(line: 131, column: 27, scope: !470)
!472 = !DILocation(line: 131, column: 5, scope: !466)
!473 = !DILocation(line: 132, column: 30, scope: !474)
!474 = distinct !DILexicalBlock(scope: !470, file: !56, line: 131, column: 43)
!475 = !DILocation(line: 132, column: 24, scope: !474)
!476 = !DILocation(line: 132, column: 9, scope: !474)
!477 = !DILocation(line: 133, column: 30, scope: !474)
!478 = !DILocation(line: 133, column: 24, scope: !474)
!479 = !DILocation(line: 133, column: 9, scope: !474)
!480 = !DILocation(line: 134, column: 5, scope: !474)
!481 = !DILocation(line: 131, column: 39, scope: !470)
!482 = !DILocation(line: 131, column: 5, scope: !470)
!483 = distinct !{!483, !472, !484, !299}
!484 = !DILocation(line: 134, column: 5, scope: !466)
!485 = !DILocation(line: 135, column: 5, scope: !463)
!486 = !DILocation(line: 136, column: 10, scope: !463)
!487 = !DILocation(line: 136, column: 5, scope: !463)
!488 = !DILocation(line: 137, column: 12, scope: !463)
!489 = !DILocation(line: 138, column: 1, scope: !463)
!490 = distinct !DISubprogram(name: "main", scope: !361, file: !361, line: 33, type: !491, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!491 = !DISubroutineType(types: !492)
!492 = !{!114}
!493 = !DILocation(line: 35, column: 5, scope: !490)
!494 = !DILocation(line: 36, column: 5, scope: !490)
!495 = distinct !DISubprogram(name: "vsimpleht_add", scope: !6, file: !6, line: 241, type: !496, scopeLine: 242, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!496 = !DISubroutineType(types: !497)
!497 = !{!498, !499, !19, !22}
!498 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_ret_t", file: !6, line: 106, baseType: !5)
!499 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!500 = !DILocalVariable(name: "tbl", arg: 1, scope: !495, file: !6, line: 241, type: !499)
!501 = !DILocation(line: 241, column: 28, scope: !495)
!502 = !DILocalVariable(name: "key", arg: 2, scope: !495, file: !6, line: 241, type: !19)
!503 = !DILocation(line: 241, column: 44, scope: !495)
!504 = !DILocalVariable(name: "value", arg: 3, scope: !495, file: !6, line: 241, type: !22)
!505 = !DILocation(line: 241, column: 55, scope: !495)
!506 = !DILocation(line: 243, column: 5, scope: !507)
!507 = distinct !DILexicalBlock(scope: !508, file: !6, line: 243, column: 5)
!508 = distinct !DILexicalBlock(scope: !495, file: !6, line: 243, column: 5)
!509 = !DILocation(line: 243, column: 5, scope: !508)
!510 = !DILocation(line: 244, column: 5, scope: !511)
!511 = distinct !DILexicalBlock(scope: !512, file: !6, line: 244, column: 5)
!512 = distinct !DILexicalBlock(scope: !495, file: !6, line: 244, column: 5)
!513 = !DILocation(line: 244, column: 5, scope: !512)
!514 = !DILocation(line: 245, column: 38, scope: !495)
!515 = !DILocation(line: 245, column: 5, scope: !495)
!516 = !DILocation(line: 246, column: 27, scope: !495)
!517 = !DILocation(line: 246, column: 32, scope: !495)
!518 = !DILocation(line: 246, column: 37, scope: !495)
!519 = !DILocation(line: 246, column: 12, scope: !495)
!520 = !DILocation(line: 246, column: 5, scope: !495)
!521 = distinct !DISubprogram(name: "trace_add", scope: !153, file: !153, line: 153, type: !522, scopeLine: 154, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!522 = !DISubroutineType(types: !523)
!523 = !{null, !524, !19}
!524 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !152, size: 64)
!525 = !DILocalVariable(name: "trace", arg: 1, scope: !521, file: !153, line: 153, type: !524)
!526 = !DILocation(line: 153, column: 20, scope: !521)
!527 = !DILocalVariable(name: "key", arg: 2, scope: !521, file: !153, line: 153, type: !19)
!528 = !DILocation(line: 153, column: 38, scope: !521)
!529 = !DILocation(line: 155, column: 5, scope: !530)
!530 = distinct !DILexicalBlock(scope: !531, file: !153, line: 155, column: 5)
!531 = distinct !DILexicalBlock(scope: !521, file: !153, line: 155, column: 5)
!532 = !DILocation(line: 155, column: 5, scope: !531)
!533 = !DILocation(line: 156, column: 5, scope: !534)
!534 = distinct !DILexicalBlock(scope: !535, file: !153, line: 156, column: 5)
!535 = distinct !DILexicalBlock(scope: !521, file: !153, line: 156, column: 5)
!536 = !DILocation(line: 156, column: 5, scope: !535)
!537 = !DILocation(line: 157, column: 35, scope: !521)
!538 = !DILocation(line: 157, column: 42, scope: !521)
!539 = !DILocation(line: 157, column: 5, scope: !521)
!540 = !DILocation(line: 158, column: 1, scope: !521)
!541 = distinct !DISubprogram(name: "_vsimpleht_give_cleanup_a_chance", scope: !6, file: !6, line: 479, type: !542, scopeLine: 480, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!542 = !DISubroutineType(types: !543)
!543 = !{null, !499}
!544 = !DILocalVariable(name: "tbl", arg: 1, scope: !541, file: !6, line: 479, type: !499)
!545 = !DILocation(line: 479, column: 47, scope: !541)
!546 = !DILocation(line: 484, column: 36, scope: !547)
!547 = distinct !DILexicalBlock(scope: !541, file: !6, line: 484, column: 9)
!548 = !DILocation(line: 484, column: 41, scope: !547)
!549 = !DILocation(line: 484, column: 9, scope: !547)
!550 = !DILocation(line: 484, column: 9, scope: !541)
!551 = !DILocation(line: 485, column: 9, scope: !552)
!552 = distinct !DILexicalBlock(scope: !553, file: !6, line: 485, column: 9)
!553 = distinct !DILexicalBlock(scope: !554, file: !6, line: 485, column: 9)
!554 = distinct !DILexicalBlock(scope: !547, file: !6, line: 484, column: 48)
!555 = !DILocation(line: 485, column: 9, scope: !553)
!556 = !DILocation(line: 488, column: 30, scope: !554)
!557 = !DILocation(line: 488, column: 35, scope: !554)
!558 = !DILocation(line: 488, column: 9, scope: !554)
!559 = !DILocation(line: 489, column: 30, scope: !554)
!560 = !DILocation(line: 489, column: 35, scope: !554)
!561 = !DILocation(line: 489, column: 9, scope: !554)
!562 = !DILocation(line: 490, column: 5, scope: !554)
!563 = !DILocation(line: 492, column: 1, scope: !541)
!564 = distinct !DISubprogram(name: "_vsimpleht_add", scope: !6, file: !6, line: 416, type: !496, scopeLine: 417, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!565 = !DILocalVariable(name: "tbl", arg: 1, scope: !564, file: !6, line: 416, type: !499)
!566 = !DILocation(line: 416, column: 29, scope: !564)
!567 = !DILocalVariable(name: "key", arg: 2, scope: !564, file: !6, line: 416, type: !19)
!568 = !DILocation(line: 416, column: 45, scope: !564)
!569 = !DILocalVariable(name: "value", arg: 3, scope: !564, file: !6, line: 416, type: !22)
!570 = !DILocation(line: 416, column: 56, scope: !564)
!571 = !DILocalVariable(name: "index", scope: !564, file: !6, line: 418, type: !14)
!572 = !DILocation(line: 418, column: 13, scope: !564)
!573 = !DILocalVariable(name: "probed_key", scope: !564, file: !6, line: 419, type: !19)
!574 = !DILocation(line: 419, column: 16, scope: !564)
!575 = !DILocalVariable(name: "val", scope: !564, file: !6, line: 420, type: !22)
!576 = !DILocation(line: 420, column: 11, scope: !564)
!577 = !DILocalVariable(name: "cnt", scope: !564, file: !6, line: 421, type: !14)
!578 = !DILocation(line: 421, column: 13, scope: !564)
!579 = !DILocation(line: 423, column: 5, scope: !580)
!580 = distinct !DILexicalBlock(scope: !581, file: !6, line: 423, column: 5)
!581 = distinct !DILexicalBlock(scope: !564, file: !6, line: 423, column: 5)
!582 = !DILocation(line: 423, column: 5, scope: !581)
!583 = !DILocation(line: 424, column: 5, scope: !584)
!584 = distinct !DILexicalBlock(scope: !585, file: !6, line: 424, column: 5)
!585 = distinct !DILexicalBlock(scope: !564, file: !6, line: 424, column: 5)
!586 = !DILocation(line: 424, column: 5, scope: !585)
!587 = !DILocation(line: 428, column: 18, scope: !588)
!588 = distinct !DILexicalBlock(scope: !564, file: !6, line: 428, column: 5)
!589 = !DILocation(line: 428, column: 23, scope: !588)
!590 = !DILocation(line: 428, column: 32, scope: !588)
!591 = !DILocation(line: 428, column: 16, scope: !588)
!592 = !DILocation(line: 428, column: 10, scope: !588)
!593 = !DILocation(line: 428, column: 38, scope: !594)
!594 = distinct !DILexicalBlock(scope: !588, file: !6, line: 428, column: 5)
!595 = !DILocation(line: 428, column: 44, scope: !594)
!596 = !DILocation(line: 428, column: 49, scope: !594)
!597 = !DILocation(line: 428, column: 42, scope: !594)
!598 = !DILocation(line: 428, column: 5, scope: !588)
!599 = !DILocation(line: 430, column: 18, scope: !600)
!600 = distinct !DILexicalBlock(scope: !594, file: !6, line: 428, column: 75)
!601 = !DILocation(line: 430, column: 23, scope: !600)
!602 = !DILocation(line: 430, column: 32, scope: !600)
!603 = !DILocation(line: 430, column: 15, scope: !600)
!604 = !DILocation(line: 431, column: 9, scope: !605)
!605 = distinct !DILexicalBlock(scope: !606, file: !6, line: 431, column: 9)
!606 = distinct !DILexicalBlock(scope: !600, file: !6, line: 431, column: 9)
!607 = !DILocation(line: 431, column: 9, scope: !606)
!608 = !DILocation(line: 433, column: 51, scope: !600)
!609 = !DILocation(line: 433, column: 56, scope: !600)
!610 = !DILocation(line: 433, column: 64, scope: !600)
!611 = !DILocation(line: 433, column: 71, scope: !600)
!612 = !DILocation(line: 433, column: 34, scope: !600)
!613 = !DILocation(line: 433, column: 22, scope: !600)
!614 = !DILocation(line: 433, column: 20, scope: !600)
!615 = !DILocation(line: 438, column: 13, scope: !616)
!616 = distinct !DILexicalBlock(scope: !600, file: !6, line: 438, column: 13)
!617 = !DILocation(line: 438, column: 24, scope: !616)
!618 = !DILocation(line: 438, column: 13, scope: !600)
!619 = !DILocation(line: 440, column: 18, scope: !620)
!620 = distinct !DILexicalBlock(scope: !616, file: !6, line: 438, column: 30)
!621 = !DILocation(line: 440, column: 23, scope: !620)
!622 = !DILocation(line: 440, column: 31, scope: !620)
!623 = !DILocation(line: 440, column: 38, scope: !620)
!624 = !DILocation(line: 440, column: 57, scope: !620)
!625 = !DILocation(line: 440, column: 49, scope: !620)
!626 = !DILocation(line: 439, column: 38, scope: !620)
!627 = !DILocation(line: 439, column: 26, scope: !620)
!628 = !DILocation(line: 439, column: 24, scope: !620)
!629 = !DILocation(line: 442, column: 17, scope: !630)
!630 = distinct !DILexicalBlock(scope: !620, file: !6, line: 442, column: 17)
!631 = !DILocation(line: 442, column: 28, scope: !630)
!632 = !DILocation(line: 442, column: 33, scope: !630)
!633 = !DILocation(line: 442, column: 36, scope: !630)
!634 = !DILocation(line: 442, column: 41, scope: !630)
!635 = !DILocation(line: 442, column: 49, scope: !630)
!636 = !DILocation(line: 442, column: 54, scope: !630)
!637 = !DILocation(line: 442, column: 66, scope: !630)
!638 = !DILocation(line: 442, column: 17, scope: !620)
!639 = !DILocation(line: 443, column: 17, scope: !640)
!640 = distinct !DILexicalBlock(scope: !630, file: !6, line: 442, column: 72)
!641 = !DILocation(line: 445, column: 9, scope: !620)
!642 = !DILocation(line: 445, column: 20, scope: !643)
!643 = distinct !DILexicalBlock(scope: !616, file: !6, line: 445, column: 20)
!644 = !DILocation(line: 445, column: 25, scope: !643)
!645 = !DILocation(line: 445, column: 33, scope: !643)
!646 = !DILocation(line: 445, column: 38, scope: !643)
!647 = !DILocation(line: 445, column: 50, scope: !643)
!648 = !DILocation(line: 445, column: 20, scope: !616)
!649 = !DILocation(line: 448, column: 13, scope: !650)
!650 = distinct !DILexicalBlock(scope: !643, file: !6, line: 445, column: 56)
!651 = !DILocation(line: 450, column: 9, scope: !652)
!652 = distinct !DILexicalBlock(scope: !653, file: !6, line: 450, column: 9)
!653 = distinct !DILexicalBlock(scope: !600, file: !6, line: 450, column: 9)
!654 = !DILocation(line: 450, column: 9, scope: !653)
!655 = !DILocation(line: 465, column: 35, scope: !600)
!656 = !DILocation(line: 465, column: 40, scope: !600)
!657 = !DILocation(line: 465, column: 48, scope: !600)
!658 = !DILocation(line: 465, column: 55, scope: !600)
!659 = !DILocation(line: 465, column: 68, scope: !600)
!660 = !DILocation(line: 465, column: 15, scope: !600)
!661 = !DILocation(line: 465, column: 13, scope: !600)
!662 = !DILocation(line: 466, column: 17, scope: !600)
!663 = !DILocation(line: 466, column: 21, scope: !600)
!664 = !DILocation(line: 466, column: 16, scope: !600)
!665 = !DILocation(line: 466, column: 9, scope: !600)
!666 = !DILocation(line: 428, column: 62, scope: !594)
!667 = !DILocation(line: 428, column: 71, scope: !594)
!668 = !DILocation(line: 428, column: 5, scope: !594)
!669 = distinct !{!669, !598, !670, !299}
!670 = !DILocation(line: 467, column: 5, scope: !588)
!671 = !DILocation(line: 468, column: 5, scope: !564)
!672 = !DILocation(line: 469, column: 1, scope: !564)
!673 = distinct !DISubprogram(name: "rwlock_acquired_by_writer", scope: !101, file: !101, line: 99, type: !674, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!674 = !DISubroutineType(types: !675)
!675 = !{!42, !676}
!676 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64)
!677 = !DILocalVariable(name: "l", arg: 1, scope: !673, file: !101, line: 99, type: !676)
!678 = !DILocation(line: 99, column: 37, scope: !673)
!679 = !DILocation(line: 101, column: 31, scope: !673)
!680 = !DILocation(line: 101, column: 34, scope: !673)
!681 = !DILocation(line: 101, column: 12, scope: !673)
!682 = !DILocation(line: 101, column: 49, scope: !673)
!683 = !DILocation(line: 101, column: 5, scope: !673)
!684 = distinct !DISubprogram(name: "rwlock_acquired_by_readers", scope: !101, file: !101, line: 105, type: !674, scopeLine: 106, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!685 = !DILocalVariable(name: "l", arg: 1, scope: !684, file: !101, line: 105, type: !676)
!686 = !DILocation(line: 105, column: 38, scope: !684)
!687 = !DILocation(line: 107, column: 5, scope: !684)
!688 = !DILocation(line: 107, column: 5, scope: !689)
!689 = distinct !DILexicalBlock(scope: !684, file: !101, line: 107, column: 5)
!690 = !DILocation(line: 107, column: 5, scope: !691)
!691 = distinct !DILexicalBlock(scope: !689, file: !101, line: 107, column: 5)
!692 = !DILocation(line: 107, column: 5, scope: !693)
!693 = distinct !DILexicalBlock(scope: !691, file: !101, line: 107, column: 5)
!694 = !DILocation(line: 108, column: 5, scope: !684)
!695 = distinct !DISubprogram(name: "rwlock_read_release", scope: !101, file: !101, line: 82, type: !696, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!696 = !DISubroutineType(types: !697)
!697 = !{null, !676}
!698 = !DILocalVariable(name: "l", arg: 1, scope: !695, file: !101, line: 82, type: !676)
!699 = !DILocation(line: 82, column: 31, scope: !695)
!700 = !DILocalVariable(name: "idx", scope: !695, file: !101, line: 84, type: !29)
!701 = !DILocation(line: 84, column: 15, scope: !695)
!702 = !DILocation(line: 84, column: 37, scope: !695)
!703 = !DILocation(line: 84, column: 21, scope: !695)
!704 = !DILocation(line: 85, column: 27, scope: !695)
!705 = !DILocation(line: 85, column: 30, scope: !695)
!706 = !DILocation(line: 85, column: 35, scope: !695)
!707 = !DILocation(line: 85, column: 5, scope: !695)
!708 = !DILocation(line: 86, column: 1, scope: !695)
!709 = distinct !DISubprogram(name: "rwlock_read_acquire", scope: !101, file: !101, line: 71, type: !696, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!710 = !DILocalVariable(name: "l", arg: 1, scope: !709, file: !101, line: 71, type: !676)
!711 = !DILocation(line: 71, column: 31, scope: !709)
!712 = !DILocalVariable(name: "idx", scope: !709, file: !101, line: 73, type: !29)
!713 = !DILocation(line: 73, column: 15, scope: !709)
!714 = !DILocation(line: 73, column: 37, scope: !709)
!715 = !DILocation(line: 73, column: 21, scope: !709)
!716 = !DILocation(line: 74, column: 25, scope: !709)
!717 = !DILocation(line: 74, column: 28, scope: !709)
!718 = !DILocation(line: 74, column: 33, scope: !709)
!719 = !DILocation(line: 74, column: 5, scope: !709)
!720 = !DILocation(line: 75, column: 1, scope: !709)
!721 = distinct !DISubprogram(name: "vatomic8_read_rlx", scope: !722, file: !722, line: 109, type: !723, scopeLine: 110, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!722 = !DIFile(filename: "vatomic/include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "0c3ec6df2f26018f35fe6ca81ab8f3c9")
!723 = !DISubroutineType(types: !724)
!724 = !{!23, !725}
!725 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !726, size: 64)
!726 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !140)
!727 = !DILocalVariable(name: "a", arg: 1, scope: !721, file: !722, line: 109, type: !725)
!728 = !DILocation(line: 109, column: 37, scope: !721)
!729 = !DILocation(line: 111, column: 5, scope: !721)
!730 = !{i64 2148224487}
!731 = !DILocalVariable(name: "tmp", scope: !721, file: !722, line: 112, type: !23)
!732 = !DILocation(line: 112, column: 14, scope: !721)
!733 = !DILocation(line: 112, column: 47, scope: !721)
!734 = !DILocation(line: 112, column: 50, scope: !721)
!735 = !DILocation(line: 112, column: 30, scope: !721)
!736 = !DILocation(line: 113, column: 5, scope: !721)
!737 = !{i64 2148224527}
!738 = !DILocation(line: 114, column: 12, scope: !721)
!739 = !DILocation(line: 114, column: 5, scope: !721)
!740 = distinct !DISubprogram(name: "_rwlock_get_tid", scope: !101, file: !101, line: 89, type: !741, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!741 = !DISubroutineType(types: !742)
!742 = !{!29, !676}
!743 = !DILocalVariable(name: "l", arg: 1, scope: !740, file: !101, line: 89, type: !676)
!744 = !DILocation(line: 89, column: 27, scope: !740)
!745 = !DILocation(line: 91, column: 9, scope: !746)
!746 = distinct !DILexicalBlock(scope: !740, file: !101, line: 91, column: 9)
!747 = !DILocation(line: 91, column: 15, scope: !746)
!748 = !DILocation(line: 91, column: 9, scope: !740)
!749 = !DILocation(line: 92, column: 36, scope: !750)
!750 = distinct !DILexicalBlock(scope: !746, file: !101, line: 91, column: 38)
!751 = !DILocation(line: 92, column: 39, scope: !750)
!752 = !DILocation(line: 92, column: 17, scope: !750)
!753 = !DILocation(line: 92, column: 15, scope: !750)
!754 = !DILocation(line: 93, column: 9, scope: !755)
!755 = distinct !DILexicalBlock(scope: !756, file: !101, line: 93, column: 9)
!756 = distinct !DILexicalBlock(scope: !750, file: !101, line: 93, column: 9)
!757 = !DILocation(line: 93, column: 9, scope: !756)
!758 = !DILocation(line: 94, column: 5, scope: !750)
!759 = !DILocation(line: 95, column: 12, scope: !740)
!760 = !DILocation(line: 95, column: 5, scope: !740)
!761 = distinct !DISubprogram(name: "vatomic32_get_inc", scope: !762, file: !762, line: 2484, type: !763, scopeLine: 2485, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!762 = !DIFile(filename: "vatomic/include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "ff273838f95062d7181b3cf355a65f2b")
!763 = !DISubroutineType(types: !764)
!764 = !{!29, !765}
!765 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !145, size: 64)
!766 = !DILocalVariable(name: "a", arg: 1, scope: !761, file: !762, line: 2484, type: !765)
!767 = !DILocation(line: 2484, column: 32, scope: !761)
!768 = !DILocation(line: 2486, column: 30, scope: !761)
!769 = !DILocation(line: 2486, column: 12, scope: !761)
!770 = !DILocation(line: 2486, column: 5, scope: !761)
!771 = distinct !DISubprogram(name: "vatomic32_get_add", scope: !722, file: !722, line: 2351, type: !772, scopeLine: 2352, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!772 = !DISubroutineType(types: !773)
!773 = !{!29, !765, !29}
!774 = !DILocalVariable(name: "a", arg: 1, scope: !771, file: !722, line: 2351, type: !765)
!775 = !DILocation(line: 2351, column: 32, scope: !771)
!776 = !DILocalVariable(name: "v", arg: 2, scope: !771, file: !722, line: 2351, type: !29)
!777 = !DILocation(line: 2351, column: 45, scope: !771)
!778 = !DILocation(line: 2353, column: 5, scope: !771)
!779 = !{i64 2148236235}
!780 = !DILocalVariable(name: "tmp", scope: !771, file: !722, line: 2354, type: !29)
!781 = !DILocation(line: 2354, column: 15, scope: !771)
!782 = !DILocation(line: 2354, column: 52, scope: !771)
!783 = !DILocation(line: 2354, column: 55, scope: !771)
!784 = !DILocation(line: 2354, column: 59, scope: !771)
!785 = !DILocation(line: 2354, column: 32, scope: !771)
!786 = !DILocation(line: 2355, column: 5, scope: !771)
!787 = !{i64 2148236275}
!788 = !DILocation(line: 2356, column: 12, scope: !771)
!789 = !DILocation(line: 2356, column: 5, scope: !771)
!790 = distinct !DISubprogram(name: "vatomicptr_read", scope: !722, file: !722, line: 291, type: !791, scopeLine: 292, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!791 = !DISubroutineType(types: !792)
!792 = !{!22, !793}
!793 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !794, size: 64)
!794 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !67)
!795 = !DILocalVariable(name: "a", arg: 1, scope: !790, file: !722, line: 291, type: !793)
!796 = !DILocation(line: 291, column: 37, scope: !790)
!797 = !DILocation(line: 293, column: 5, scope: !790)
!798 = !{i64 2148225501}
!799 = !DILocalVariable(name: "tmp", scope: !790, file: !722, line: 294, type: !22)
!800 = !DILocation(line: 294, column: 11, scope: !790)
!801 = !DILocation(line: 294, column: 42, scope: !790)
!802 = !DILocation(line: 294, column: 45, scope: !790)
!803 = !DILocation(line: 294, column: 25, scope: !790)
!804 = !DILocation(line: 295, column: 5, scope: !790)
!805 = !{i64 2148225541}
!806 = !DILocation(line: 296, column: 12, scope: !790)
!807 = !DILocation(line: 296, column: 5, scope: !790)
!808 = distinct !DISubprogram(name: "vatomicptr_cmpxchg", scope: !722, file: !722, line: 1259, type: !809, scopeLine: 1260, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!809 = !DISubroutineType(types: !810)
!810 = !{!22, !811, !22, !22}
!811 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!812 = !DILocalVariable(name: "a", arg: 1, scope: !808, file: !722, line: 1259, type: !811)
!813 = !DILocation(line: 1259, column: 34, scope: !808)
!814 = !DILocalVariable(name: "e", arg: 2, scope: !808, file: !722, line: 1259, type: !22)
!815 = !DILocation(line: 1259, column: 43, scope: !808)
!816 = !DILocalVariable(name: "v", arg: 3, scope: !808, file: !722, line: 1259, type: !22)
!817 = !DILocation(line: 1259, column: 52, scope: !808)
!818 = !DILocalVariable(name: "exp", scope: !808, file: !722, line: 1261, type: !22)
!819 = !DILocation(line: 1261, column: 11, scope: !808)
!820 = !DILocation(line: 1261, column: 25, scope: !808)
!821 = !DILocation(line: 1262, column: 5, scope: !808)
!822 = !{i64 2148230611}
!823 = !DILocation(line: 1263, column: 34, scope: !808)
!824 = !DILocation(line: 1263, column: 37, scope: !808)
!825 = !DILocation(line: 1263, column: 55, scope: !808)
!826 = !DILocation(line: 1263, column: 5, scope: !808)
!827 = !DILocation(line: 1265, column: 5, scope: !808)
!828 = !{i64 2148230653}
!829 = !DILocation(line: 1266, column: 12, scope: !808)
!830 = !DILocation(line: 1266, column: 5, scope: !808)
!831 = distinct !DISubprogram(name: "_trace_add_or_rem_occurrences", scope: !153, file: !153, line: 122, type: !832, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!832 = !DISubroutineType(types: !833)
!833 = !{null, !524, !19, !14, !42}
!834 = !DILocalVariable(name: "trace", arg: 1, scope: !831, file: !153, line: 122, type: !524)
!835 = !DILocation(line: 122, column: 40, scope: !831)
!836 = !DILocalVariable(name: "key", arg: 2, scope: !831, file: !153, line: 122, type: !19)
!837 = !DILocation(line: 122, column: 58, scope: !831)
!838 = !DILocalVariable(name: "count", arg: 3, scope: !831, file: !153, line: 122, type: !14)
!839 = !DILocation(line: 122, column: 71, scope: !831)
!840 = !DILocalVariable(name: "subtract", arg: 4, scope: !831, file: !153, line: 123, type: !42)
!841 = !DILocation(line: 123, column: 39, scope: !831)
!842 = !DILocalVariable(name: "idx", scope: !831, file: !153, line: 125, type: !14)
!843 = !DILocation(line: 125, column: 13, scope: !831)
!844 = !DILocalVariable(name: "found", scope: !831, file: !153, line: 126, type: !42)
!845 = !DILocation(line: 126, column: 13, scope: !831)
!846 = !DILocation(line: 128, column: 5, scope: !847)
!847 = distinct !DILexicalBlock(scope: !848, file: !153, line: 128, column: 5)
!848 = distinct !DILexicalBlock(scope: !831, file: !153, line: 128, column: 5)
!849 = !DILocation(line: 128, column: 5, scope: !848)
!850 = !DILocation(line: 129, column: 5, scope: !851)
!851 = distinct !DILexicalBlock(scope: !852, file: !153, line: 129, column: 5)
!852 = distinct !DILexicalBlock(scope: !831, file: !153, line: 129, column: 5)
!853 = !DILocation(line: 129, column: 5, scope: !852)
!854 = !DILocation(line: 131, column: 33, scope: !831)
!855 = !DILocation(line: 131, column: 40, scope: !831)
!856 = !DILocation(line: 131, column: 13, scope: !831)
!857 = !DILocation(line: 131, column: 11, scope: !831)
!858 = !DILocation(line: 133, column: 9, scope: !859)
!859 = distinct !DILexicalBlock(scope: !831, file: !153, line: 133, column: 9)
!860 = !DILocation(line: 133, column: 9, scope: !831)
!861 = !DILocation(line: 134, column: 9, scope: !862)
!862 = distinct !DILexicalBlock(scope: !863, file: !153, line: 134, column: 9)
!863 = distinct !DILexicalBlock(scope: !864, file: !153, line: 134, column: 9)
!864 = distinct !DILexicalBlock(scope: !859, file: !153, line: 133, column: 19)
!865 = !DILocation(line: 134, column: 9, scope: !863)
!866 = !DILocation(line: 135, column: 9, scope: !867)
!867 = distinct !DILexicalBlock(scope: !868, file: !153, line: 135, column: 9)
!868 = distinct !DILexicalBlock(scope: !864, file: !153, line: 135, column: 9)
!869 = !DILocation(line: 135, column: 9, scope: !868)
!870 = !DILocation(line: 136, column: 36, scope: !864)
!871 = !DILocation(line: 136, column: 9, scope: !864)
!872 = !DILocation(line: 136, column: 16, scope: !864)
!873 = !DILocation(line: 136, column: 22, scope: !864)
!874 = !DILocation(line: 136, column: 27, scope: !864)
!875 = !DILocation(line: 136, column: 33, scope: !864)
!876 = !DILocation(line: 137, column: 9, scope: !864)
!877 = !DILocation(line: 140, column: 10, scope: !878)
!878 = distinct !DILexicalBlock(scope: !831, file: !153, line: 140, column: 9)
!879 = !DILocation(line: 140, column: 9, scope: !831)
!880 = !DILocation(line: 141, column: 15, scope: !881)
!881 = distinct !DILexicalBlock(scope: !878, file: !153, line: 140, column: 17)
!882 = !DILocation(line: 141, column: 22, scope: !881)
!883 = !DILocation(line: 141, column: 25, scope: !881)
!884 = !DILocation(line: 141, column: 13, scope: !881)
!885 = !DILocation(line: 142, column: 13, scope: !886)
!886 = distinct !DILexicalBlock(scope: !881, file: !153, line: 142, column: 13)
!887 = !DILocation(line: 142, column: 20, scope: !886)
!888 = !DILocation(line: 142, column: 27, scope: !886)
!889 = !DILocation(line: 142, column: 17, scope: !886)
!890 = !DILocation(line: 142, column: 13, scope: !881)
!891 = !DILocation(line: 143, column: 26, scope: !892)
!892 = distinct !DILexicalBlock(scope: !886, file: !153, line: 142, column: 37)
!893 = !DILocation(line: 143, column: 13, scope: !892)
!894 = !DILocation(line: 144, column: 9, scope: !892)
!895 = !DILocation(line: 145, column: 35, scope: !881)
!896 = !DILocation(line: 145, column: 9, scope: !881)
!897 = !DILocation(line: 145, column: 16, scope: !881)
!898 = !DILocation(line: 145, column: 22, scope: !881)
!899 = !DILocation(line: 145, column: 27, scope: !881)
!900 = !DILocation(line: 145, column: 33, scope: !881)
!901 = !DILocation(line: 146, column: 35, scope: !881)
!902 = !DILocation(line: 146, column: 9, scope: !881)
!903 = !DILocation(line: 146, column: 16, scope: !881)
!904 = !DILocation(line: 146, column: 22, scope: !881)
!905 = !DILocation(line: 146, column: 27, scope: !881)
!906 = !DILocation(line: 146, column: 33, scope: !881)
!907 = !DILocation(line: 147, column: 5, scope: !881)
!908 = !DILocation(line: 148, column: 36, scope: !909)
!909 = distinct !DILexicalBlock(scope: !878, file: !153, line: 147, column: 12)
!910 = !DILocation(line: 148, column: 9, scope: !909)
!911 = !DILocation(line: 148, column: 16, scope: !909)
!912 = !DILocation(line: 148, column: 22, scope: !909)
!913 = !DILocation(line: 148, column: 27, scope: !909)
!914 = !DILocation(line: 148, column: 33, scope: !909)
!915 = !DILocation(line: 150, column: 1, scope: !831)
!916 = distinct !DISubprogram(name: "trace_find_unit_idx", scope: !153, file: !153, line: 107, type: !917, scopeLine: 108, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!917 = !DISubroutineType(types: !918)
!918 = !{!42, !524, !19, !919}
!919 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!920 = !DILocalVariable(name: "trace", arg: 1, scope: !916, file: !153, line: 107, type: !524)
!921 = !DILocation(line: 107, column: 30, scope: !916)
!922 = !DILocalVariable(name: "key", arg: 2, scope: !916, file: !153, line: 107, type: !19)
!923 = !DILocation(line: 107, column: 48, scope: !916)
!924 = !DILocalVariable(name: "out_idx", arg: 3, scope: !916, file: !153, line: 107, type: !919)
!925 = !DILocation(line: 107, column: 62, scope: !916)
!926 = !DILocalVariable(name: "i", scope: !916, file: !153, line: 109, type: !14)
!927 = !DILocation(line: 109, column: 13, scope: !916)
!928 = !DILocation(line: 110, column: 5, scope: !929)
!929 = distinct !DILexicalBlock(scope: !930, file: !153, line: 110, column: 5)
!930 = distinct !DILexicalBlock(scope: !916, file: !153, line: 110, column: 5)
!931 = !DILocation(line: 110, column: 5, scope: !930)
!932 = !DILocation(line: 111, column: 5, scope: !933)
!933 = distinct !DILexicalBlock(scope: !934, file: !153, line: 111, column: 5)
!934 = distinct !DILexicalBlock(scope: !916, file: !153, line: 111, column: 5)
!935 = !DILocation(line: 111, column: 5, scope: !934)
!936 = !DILocation(line: 112, column: 12, scope: !937)
!937 = distinct !DILexicalBlock(scope: !916, file: !153, line: 112, column: 5)
!938 = !DILocation(line: 112, column: 10, scope: !937)
!939 = !DILocation(line: 112, column: 17, scope: !940)
!940 = distinct !DILexicalBlock(scope: !937, file: !153, line: 112, column: 5)
!941 = !DILocation(line: 112, column: 21, scope: !940)
!942 = !DILocation(line: 112, column: 28, scope: !940)
!943 = !DILocation(line: 112, column: 19, scope: !940)
!944 = !DILocation(line: 112, column: 5, scope: !937)
!945 = !DILocation(line: 113, column: 13, scope: !946)
!946 = distinct !DILexicalBlock(scope: !947, file: !153, line: 113, column: 13)
!947 = distinct !DILexicalBlock(scope: !940, file: !153, line: 112, column: 38)
!948 = !DILocation(line: 113, column: 20, scope: !946)
!949 = !DILocation(line: 113, column: 26, scope: !946)
!950 = !DILocation(line: 113, column: 29, scope: !946)
!951 = !DILocation(line: 113, column: 36, scope: !946)
!952 = !DILocation(line: 113, column: 33, scope: !946)
!953 = !DILocation(line: 113, column: 13, scope: !947)
!954 = !DILocation(line: 114, column: 24, scope: !955)
!955 = distinct !DILexicalBlock(scope: !946, file: !153, line: 113, column: 41)
!956 = !DILocation(line: 114, column: 14, scope: !955)
!957 = !DILocation(line: 114, column: 22, scope: !955)
!958 = !DILocation(line: 115, column: 13, scope: !955)
!959 = !DILocation(line: 117, column: 5, scope: !947)
!960 = !DILocation(line: 112, column: 34, scope: !940)
!961 = !DILocation(line: 112, column: 5, scope: !940)
!962 = distinct !{!962, !944, !963, !299}
!963 = !DILocation(line: 117, column: 5, scope: !937)
!964 = !DILocation(line: 118, column: 5, scope: !916)
!965 = !DILocation(line: 119, column: 1, scope: !916)
!966 = distinct !DISubprogram(name: "trace_extend", scope: !153, file: !153, line: 73, type: !967, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!967 = !DISubroutineType(types: !968)
!968 = !{null, !524}
!969 = !DILocalVariable(name: "trace", arg: 1, scope: !966, file: !153, line: 73, type: !524)
!970 = !DILocation(line: 73, column: 23, scope: !966)
!971 = !DILocation(line: 75, column: 5, scope: !972)
!972 = distinct !DILexicalBlock(scope: !973, file: !153, line: 75, column: 5)
!973 = distinct !DILexicalBlock(scope: !966, file: !153, line: 75, column: 5)
!974 = !DILocation(line: 75, column: 5, scope: !973)
!975 = !DILocalVariable(name: "src_size", scope: !966, file: !153, line: 77, type: !14)
!976 = !DILocation(line: 77, column: 13, scope: !966)
!977 = !DILocation(line: 77, column: 24, scope: !966)
!978 = !DILocation(line: 77, column: 31, scope: !966)
!979 = !DILocation(line: 77, column: 40, scope: !966)
!980 = !DILocalVariable(name: "des_max", scope: !966, file: !153, line: 78, type: !14)
!981 = !DILocation(line: 78, column: 13, scope: !966)
!982 = !DILocation(line: 78, column: 24, scope: !966)
!983 = !DILocation(line: 78, column: 33, scope: !966)
!984 = !DILocalVariable(name: "src", scope: !966, file: !153, line: 80, type: !157)
!985 = !DILocation(line: 80, column: 19, scope: !966)
!986 = !DILocation(line: 80, column: 25, scope: !966)
!987 = !DILocation(line: 80, column: 32, scope: !966)
!988 = !DILocalVariable(name: "des", scope: !966, file: !153, line: 81, type: !157)
!989 = !DILocation(line: 81, column: 19, scope: !966)
!990 = !DILocation(line: 81, column: 32, scope: !966)
!991 = !DILocation(line: 81, column: 25, scope: !966)
!992 = !DILocation(line: 83, column: 9, scope: !993)
!993 = distinct !DILexicalBlock(scope: !966, file: !153, line: 83, column: 9)
!994 = !DILocation(line: 83, column: 9, scope: !966)
!995 = !DILocalVariable(name: "ret", scope: !996, file: !153, line: 84, type: !114)
!996 = distinct !DILexicalBlock(scope: !993, file: !153, line: 83, column: 14)
!997 = !DILocation(line: 84, column: 13, scope: !996)
!998 = !DILocation(line: 84, column: 28, scope: !996)
!999 = !DILocation(line: 84, column: 33, scope: !996)
!1000 = !DILocation(line: 84, column: 42, scope: !996)
!1001 = !DILocation(line: 84, column: 47, scope: !996)
!1002 = !DILocation(line: 84, column: 19, scope: !996)
!1003 = !DILocation(line: 85, column: 13, scope: !1004)
!1004 = distinct !DILexicalBlock(scope: !996, file: !153, line: 85, column: 13)
!1005 = !DILocation(line: 85, column: 17, scope: !1004)
!1006 = !DILocation(line: 85, column: 13, scope: !996)
!1007 = !DILocation(line: 86, column: 28, scope: !1008)
!1008 = distinct !DILexicalBlock(scope: !1004, file: !153, line: 85, column: 23)
!1009 = !DILocation(line: 86, column: 13, scope: !1008)
!1010 = !DILocation(line: 86, column: 20, scope: !1008)
!1011 = !DILocation(line: 86, column: 26, scope: !1008)
!1012 = !DILocation(line: 87, column: 13, scope: !1008)
!1013 = !DILocation(line: 87, column: 20, scope: !1008)
!1014 = !DILocation(line: 87, column: 29, scope: !1008)
!1015 = !DILocation(line: 88, column: 9, scope: !1008)
!1016 = !DILocation(line: 89, column: 13, scope: !1017)
!1017 = distinct !DILexicalBlock(scope: !1018, file: !153, line: 89, column: 13)
!1018 = distinct !DILexicalBlock(scope: !1019, file: !153, line: 89, column: 13)
!1019 = distinct !DILexicalBlock(scope: !1004, file: !153, line: 88, column: 16)
!1020 = !DILocation(line: 91, column: 14, scope: !996)
!1021 = !DILocation(line: 91, column: 9, scope: !996)
!1022 = !DILocation(line: 92, column: 5, scope: !996)
!1023 = !DILocation(line: 93, column: 9, scope: !1024)
!1024 = distinct !DILexicalBlock(scope: !1025, file: !153, line: 93, column: 9)
!1025 = distinct !DILexicalBlock(scope: !1026, file: !153, line: 93, column: 9)
!1026 = distinct !DILexicalBlock(scope: !993, file: !153, line: 92, column: 12)
!1027 = !DILocation(line: 95, column: 1, scope: !966)
!1028 = distinct !DISubprogram(name: "vsimpleht_get", scope: !6, file: !6, line: 257, type: !1029, scopeLine: 258, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1029 = !DISubroutineType(types: !1030)
!1030 = !{!22, !499, !19}
!1031 = !DILocalVariable(name: "tbl", arg: 1, scope: !1028, file: !6, line: 257, type: !499)
!1032 = !DILocation(line: 257, column: 28, scope: !1028)
!1033 = !DILocalVariable(name: "key", arg: 2, scope: !1028, file: !6, line: 257, type: !19)
!1034 = !DILocation(line: 257, column: 44, scope: !1028)
!1035 = !DILocalVariable(name: "index", scope: !1028, file: !6, line: 259, type: !14)
!1036 = !DILocation(line: 259, column: 13, scope: !1028)
!1037 = !DILocalVariable(name: "probed_key", scope: !1028, file: !6, line: 260, type: !19)
!1038 = !DILocation(line: 260, column: 16, scope: !1028)
!1039 = !DILocation(line: 261, column: 38, scope: !1028)
!1040 = !DILocation(line: 261, column: 5, scope: !1028)
!1041 = !DILocation(line: 262, column: 18, scope: !1042)
!1042 = distinct !DILexicalBlock(scope: !1028, file: !6, line: 262, column: 5)
!1043 = !DILocation(line: 262, column: 23, scope: !1042)
!1044 = !DILocation(line: 262, column: 32, scope: !1042)
!1045 = !DILocation(line: 262, column: 16, scope: !1042)
!1046 = !DILocation(line: 262, column: 10, scope: !1042)
!1047 = !DILocation(line: 263, column: 18, scope: !1048)
!1048 = distinct !DILexicalBlock(scope: !1049, file: !6, line: 262, column: 48)
!1049 = distinct !DILexicalBlock(scope: !1042, file: !6, line: 262, column: 5)
!1050 = !DILocation(line: 263, column: 23, scope: !1048)
!1051 = !DILocation(line: 263, column: 32, scope: !1048)
!1052 = !DILocation(line: 263, column: 15, scope: !1048)
!1053 = !DILocation(line: 264, column: 9, scope: !1054)
!1054 = distinct !DILexicalBlock(scope: !1055, file: !6, line: 264, column: 9)
!1055 = distinct !DILexicalBlock(scope: !1048, file: !6, line: 264, column: 9)
!1056 = !DILocation(line: 264, column: 9, scope: !1055)
!1057 = !DILocation(line: 265, column: 51, scope: !1048)
!1058 = !DILocation(line: 265, column: 56, scope: !1048)
!1059 = !DILocation(line: 265, column: 64, scope: !1048)
!1060 = !DILocation(line: 265, column: 71, scope: !1048)
!1061 = !DILocation(line: 265, column: 34, scope: !1048)
!1062 = !DILocation(line: 265, column: 22, scope: !1048)
!1063 = !DILocation(line: 265, column: 20, scope: !1048)
!1064 = !DILocation(line: 266, column: 13, scope: !1065)
!1065 = distinct !DILexicalBlock(scope: !1048, file: !6, line: 266, column: 13)
!1066 = !DILocation(line: 266, column: 24, scope: !1065)
!1067 = !DILocation(line: 266, column: 13, scope: !1048)
!1068 = !DILocation(line: 267, column: 13, scope: !1069)
!1069 = distinct !DILexicalBlock(scope: !1065, file: !6, line: 266, column: 30)
!1070 = !DILocation(line: 268, column: 20, scope: !1071)
!1071 = distinct !DILexicalBlock(scope: !1065, file: !6, line: 268, column: 20)
!1072 = !DILocation(line: 268, column: 25, scope: !1071)
!1073 = !DILocation(line: 268, column: 33, scope: !1071)
!1074 = !DILocation(line: 268, column: 38, scope: !1071)
!1075 = !DILocation(line: 268, column: 50, scope: !1071)
!1076 = !DILocation(line: 268, column: 20, scope: !1065)
!1077 = !DILocation(line: 269, column: 41, scope: !1078)
!1078 = distinct !DILexicalBlock(scope: !1071, file: !6, line: 268, column: 56)
!1079 = !DILocation(line: 269, column: 46, scope: !1078)
!1080 = !DILocation(line: 269, column: 54, scope: !1078)
!1081 = !DILocation(line: 269, column: 61, scope: !1078)
!1082 = !DILocation(line: 269, column: 20, scope: !1078)
!1083 = !DILocation(line: 269, column: 13, scope: !1078)
!1084 = !DILocation(line: 271, column: 5, scope: !1048)
!1085 = !DILocation(line: 262, column: 44, scope: !1049)
!1086 = !DILocation(line: 262, column: 5, scope: !1049)
!1087 = distinct !{!1087, !1088, !1089}
!1088 = !DILocation(line: 262, column: 5, scope: !1042)
!1089 = !DILocation(line: 271, column: 5, scope: !1042)
!1090 = !DILocation(line: 272, column: 1, scope: !1028)
!1091 = distinct !DISubprogram(name: "vatomicptr_read_acq", scope: !722, file: !722, line: 305, type: !791, scopeLine: 306, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1092 = !DILocalVariable(name: "a", arg: 1, scope: !1091, file: !722, line: 305, type: !793)
!1093 = !DILocation(line: 305, column: 41, scope: !1091)
!1094 = !DILocation(line: 307, column: 5, scope: !1091)
!1095 = !{i64 2148225579}
!1096 = !DILocalVariable(name: "tmp", scope: !1091, file: !722, line: 308, type: !22)
!1097 = !DILocation(line: 308, column: 11, scope: !1091)
!1098 = !DILocation(line: 308, column: 42, scope: !1091)
!1099 = !DILocation(line: 308, column: 45, scope: !1091)
!1100 = !DILocation(line: 308, column: 25, scope: !1091)
!1101 = !DILocation(line: 309, column: 5, scope: !1091)
!1102 = !{i64 2148225619}
!1103 = !DILocation(line: 310, column: 12, scope: !1091)
!1104 = !DILocation(line: 310, column: 5, scope: !1091)
!1105 = distinct !DISubprogram(name: "create_threads", scope: !34, file: !34, line: 91, type: !1106, scopeLine: 93, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1106 = !DISubroutineType(types: !1107)
!1107 = !{null, !32, !14, !45, !42}
!1108 = !DILocalVariable(name: "threads", arg: 1, scope: !1105, file: !34, line: 91, type: !32)
!1109 = !DILocation(line: 91, column: 28, scope: !1105)
!1110 = !DILocalVariable(name: "num_threads", arg: 2, scope: !1105, file: !34, line: 91, type: !14)
!1111 = !DILocation(line: 91, column: 45, scope: !1105)
!1112 = !DILocalVariable(name: "fun", arg: 3, scope: !1105, file: !34, line: 91, type: !45)
!1113 = !DILocation(line: 91, column: 71, scope: !1105)
!1114 = !DILocalVariable(name: "bind", arg: 4, scope: !1105, file: !34, line: 92, type: !42)
!1115 = !DILocation(line: 92, column: 24, scope: !1105)
!1116 = !DILocalVariable(name: "i", scope: !1105, file: !34, line: 94, type: !14)
!1117 = !DILocation(line: 94, column: 13, scope: !1105)
!1118 = !DILocation(line: 95, column: 12, scope: !1119)
!1119 = distinct !DILexicalBlock(scope: !1105, file: !34, line: 95, column: 5)
!1120 = !DILocation(line: 95, column: 10, scope: !1119)
!1121 = !DILocation(line: 95, column: 17, scope: !1122)
!1122 = distinct !DILexicalBlock(scope: !1119, file: !34, line: 95, column: 5)
!1123 = !DILocation(line: 95, column: 21, scope: !1122)
!1124 = !DILocation(line: 95, column: 19, scope: !1122)
!1125 = !DILocation(line: 95, column: 5, scope: !1119)
!1126 = !DILocation(line: 96, column: 40, scope: !1127)
!1127 = distinct !DILexicalBlock(scope: !1122, file: !34, line: 95, column: 39)
!1128 = !DILocation(line: 96, column: 9, scope: !1127)
!1129 = !DILocation(line: 96, column: 17, scope: !1127)
!1130 = !DILocation(line: 96, column: 20, scope: !1127)
!1131 = !DILocation(line: 96, column: 38, scope: !1127)
!1132 = !DILocation(line: 97, column: 40, scope: !1127)
!1133 = !DILocation(line: 97, column: 9, scope: !1127)
!1134 = !DILocation(line: 97, column: 17, scope: !1127)
!1135 = !DILocation(line: 97, column: 20, scope: !1127)
!1136 = !DILocation(line: 97, column: 38, scope: !1127)
!1137 = !DILocation(line: 98, column: 40, scope: !1127)
!1138 = !DILocation(line: 98, column: 9, scope: !1127)
!1139 = !DILocation(line: 98, column: 17, scope: !1127)
!1140 = !DILocation(line: 98, column: 20, scope: !1127)
!1141 = !DILocation(line: 98, column: 38, scope: !1127)
!1142 = !DILocation(line: 99, column: 25, scope: !1127)
!1143 = !DILocation(line: 99, column: 33, scope: !1127)
!1144 = !DILocation(line: 99, column: 36, scope: !1127)
!1145 = !DILocation(line: 99, column: 55, scope: !1127)
!1146 = !DILocation(line: 99, column: 63, scope: !1127)
!1147 = !DILocation(line: 99, column: 54, scope: !1127)
!1148 = !DILocation(line: 99, column: 9, scope: !1127)
!1149 = !DILocation(line: 100, column: 5, scope: !1127)
!1150 = !DILocation(line: 95, column: 35, scope: !1122)
!1151 = !DILocation(line: 95, column: 5, scope: !1122)
!1152 = distinct !{!1152, !1125, !1153, !299}
!1153 = !DILocation(line: 100, column: 5, scope: !1119)
!1154 = !DILocation(line: 102, column: 1, scope: !1105)
!1155 = distinct !DISubprogram(name: "await_threads", scope: !34, file: !34, line: 105, type: !1156, scopeLine: 106, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1156 = !DISubroutineType(types: !1157)
!1157 = !{null, !32, !14}
!1158 = !DILocalVariable(name: "threads", arg: 1, scope: !1155, file: !34, line: 105, type: !32)
!1159 = !DILocation(line: 105, column: 27, scope: !1155)
!1160 = !DILocalVariable(name: "num_threads", arg: 2, scope: !1155, file: !34, line: 105, type: !14)
!1161 = !DILocation(line: 105, column: 44, scope: !1155)
!1162 = !DILocalVariable(name: "i", scope: !1155, file: !34, line: 107, type: !14)
!1163 = !DILocation(line: 107, column: 13, scope: !1155)
!1164 = !DILocation(line: 108, column: 12, scope: !1165)
!1165 = distinct !DILexicalBlock(scope: !1155, file: !34, line: 108, column: 5)
!1166 = !DILocation(line: 108, column: 10, scope: !1165)
!1167 = !DILocation(line: 108, column: 17, scope: !1168)
!1168 = distinct !DILexicalBlock(scope: !1165, file: !34, line: 108, column: 5)
!1169 = !DILocation(line: 108, column: 21, scope: !1168)
!1170 = !DILocation(line: 108, column: 19, scope: !1168)
!1171 = !DILocation(line: 108, column: 5, scope: !1165)
!1172 = !DILocation(line: 109, column: 22, scope: !1173)
!1173 = distinct !DILexicalBlock(scope: !1168, file: !34, line: 108, column: 39)
!1174 = !DILocation(line: 109, column: 30, scope: !1173)
!1175 = !DILocation(line: 109, column: 33, scope: !1173)
!1176 = !DILocation(line: 109, column: 9, scope: !1173)
!1177 = !DILocation(line: 110, column: 5, scope: !1173)
!1178 = !DILocation(line: 108, column: 35, scope: !1168)
!1179 = !DILocation(line: 108, column: 5, scope: !1168)
!1180 = distinct !{!1180, !1171, !1181, !299}
!1181 = !DILocation(line: 110, column: 5, scope: !1165)
!1182 = !DILocation(line: 111, column: 1, scope: !1155)
!1183 = distinct !DISubprogram(name: "common_run", scope: !34, file: !34, line: 51, type: !47, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1184 = !DILocalVariable(name: "args", arg: 1, scope: !1183, file: !34, line: 51, type: !22)
!1185 = !DILocation(line: 51, column: 18, scope: !1183)
!1186 = !DILocalVariable(name: "run_info", scope: !1183, file: !34, line: 53, type: !32)
!1187 = !DILocation(line: 53, column: 17, scope: !1183)
!1188 = !DILocation(line: 53, column: 42, scope: !1183)
!1189 = !DILocation(line: 53, column: 28, scope: !1183)
!1190 = !DILocation(line: 55, column: 9, scope: !1191)
!1191 = distinct !DILexicalBlock(scope: !1183, file: !34, line: 55, column: 9)
!1192 = !DILocation(line: 55, column: 19, scope: !1191)
!1193 = !DILocation(line: 55, column: 9, scope: !1183)
!1194 = !DILocation(line: 56, column: 26, scope: !1191)
!1195 = !DILocation(line: 56, column: 36, scope: !1191)
!1196 = !DILocation(line: 56, column: 9, scope: !1191)
!1197 = !DILocation(line: 60, column: 12, scope: !1183)
!1198 = !DILocation(line: 60, column: 22, scope: !1183)
!1199 = !DILocation(line: 60, column: 38, scope: !1183)
!1200 = !DILocation(line: 60, column: 48, scope: !1183)
!1201 = !DILocation(line: 60, column: 30, scope: !1183)
!1202 = !DILocation(line: 60, column: 5, scope: !1183)
!1203 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !34, file: !34, line: 69, type: !187, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1204 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !1203, file: !34, line: 69, type: !14)
!1205 = !DILocation(line: 69, column: 26, scope: !1203)
!1206 = !DILocation(line: 86, column: 5, scope: !1203)
!1207 = !DILocation(line: 86, column: 5, scope: !1208)
!1208 = distinct !DILexicalBlock(scope: !1203, file: !34, line: 86, column: 5)
!1209 = !DILocation(line: 86, column: 5, scope: !1210)
!1210 = distinct !DILexicalBlock(scope: !1208, file: !34, line: 86, column: 5)
!1211 = !DILocation(line: 86, column: 5, scope: !1212)
!1212 = distinct !DILexicalBlock(scope: !1210, file: !34, line: 86, column: 5)
!1213 = !DILocation(line: 88, column: 1, scope: !1203)
!1214 = distinct !DISubprogram(name: "vsimpleht_thread_register", scope: !6, file: !6, line: 200, type: !542, scopeLine: 201, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1215 = !DILocalVariable(name: "tbl", arg: 1, scope: !1214, file: !6, line: 200, type: !499)
!1216 = !DILocation(line: 200, column: 40, scope: !1214)
!1217 = !DILocation(line: 205, column: 26, scope: !1214)
!1218 = !DILocation(line: 205, column: 31, scope: !1214)
!1219 = !DILocation(line: 205, column: 5, scope: !1214)
!1220 = !DILocation(line: 207, column: 1, scope: !1214)
!1221 = distinct !DISubprogram(name: "vsimpleht_thread_deregister", scope: !6, file: !6, line: 217, type: !542, scopeLine: 218, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1222 = !DILocalVariable(name: "tbl", arg: 1, scope: !1221, file: !6, line: 217, type: !499)
!1223 = !DILocation(line: 217, column: 42, scope: !1221)
!1224 = !DILocation(line: 222, column: 26, scope: !1221)
!1225 = !DILocation(line: 222, column: 31, scope: !1221)
!1226 = !DILocation(line: 222, column: 5, scope: !1221)
!1227 = !DILocation(line: 224, column: 1, scope: !1221)
!1228 = distinct !DISubprogram(name: "vsimpleht_buff_size", scope: !6, file: !6, line: 126, type: !1229, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1229 = !DISubroutineType(types: !1230)
!1230 = !{!14, !14}
!1231 = !DILocalVariable(name: "capacity", arg: 1, scope: !1228, file: !6, line: 126, type: !14)
!1232 = !DILocation(line: 126, column: 29, scope: !1228)
!1233 = !DILocation(line: 128, column: 5, scope: !1234)
!1234 = distinct !DILexicalBlock(scope: !1235, file: !6, line: 128, column: 5)
!1235 = distinct !DILexicalBlock(scope: !1228, file: !6, line: 128, column: 5)
!1236 = !DILocation(line: 128, column: 5, scope: !1235)
!1237 = !DILocation(line: 129, column: 5, scope: !1238)
!1238 = distinct !DILexicalBlock(scope: !1239, file: !6, line: 129, column: 5)
!1239 = distinct !DILexicalBlock(scope: !1228, file: !6, line: 129, column: 5)
!1240 = !DILocation(line: 129, column: 5, scope: !1239)
!1241 = !DILocation(line: 130, column: 40, scope: !1228)
!1242 = !DILocation(line: 130, column: 38, scope: !1228)
!1243 = !DILocation(line: 130, column: 5, scope: !1228)
!1244 = distinct !DISubprogram(name: "vsimpleht_init", scope: !6, file: !6, line: 146, type: !1245, scopeLine: 149, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1245 = !DISubroutineType(types: !1246)
!1246 = !{null, !499, !22, !14, !74, !84, !89}
!1247 = !DILocalVariable(name: "tbl", arg: 1, scope: !1244, file: !6, line: 146, type: !499)
!1248 = !DILocation(line: 146, column: 29, scope: !1244)
!1249 = !DILocalVariable(name: "buff", arg: 2, scope: !1244, file: !6, line: 146, type: !22)
!1250 = !DILocation(line: 146, column: 40, scope: !1244)
!1251 = !DILocalVariable(name: "capacity", arg: 3, scope: !1244, file: !6, line: 146, type: !14)
!1252 = !DILocation(line: 146, column: 54, scope: !1244)
!1253 = !DILocalVariable(name: "cmp_fun", arg: 4, scope: !1244, file: !6, line: 147, type: !74)
!1254 = !DILocation(line: 147, column: 36, scope: !1244)
!1255 = !DILocalVariable(name: "hash_fun", arg: 5, scope: !1244, file: !6, line: 147, type: !84)
!1256 = !DILocation(line: 147, column: 66, scope: !1244)
!1257 = !DILocalVariable(name: "destroy_cb", arg: 6, scope: !1244, file: !6, line: 148, type: !89)
!1258 = !DILocation(line: 148, column: 42, scope: !1244)
!1259 = !DILocation(line: 150, column: 5, scope: !1260)
!1260 = distinct !DILexicalBlock(scope: !1261, file: !6, line: 150, column: 5)
!1261 = distinct !DILexicalBlock(scope: !1244, file: !6, line: 150, column: 5)
!1262 = !DILocation(line: 150, column: 5, scope: !1261)
!1263 = !DILocation(line: 151, column: 5, scope: !1264)
!1264 = distinct !DILexicalBlock(scope: !1265, file: !6, line: 151, column: 5)
!1265 = distinct !DILexicalBlock(scope: !1244, file: !6, line: 151, column: 5)
!1266 = !DILocation(line: 151, column: 5, scope: !1265)
!1267 = !DILocation(line: 152, column: 5, scope: !1268)
!1268 = distinct !DILexicalBlock(scope: !1269, file: !6, line: 152, column: 5)
!1269 = distinct !DILexicalBlock(scope: !1244, file: !6, line: 152, column: 5)
!1270 = !DILocation(line: 152, column: 5, scope: !1269)
!1271 = !DILocation(line: 153, column: 5, scope: !1272)
!1272 = distinct !DILexicalBlock(scope: !1273, file: !6, line: 153, column: 5)
!1273 = distinct !DILexicalBlock(scope: !1244, file: !6, line: 153, column: 5)
!1274 = !DILocation(line: 153, column: 5, scope: !1273)
!1275 = !DILocation(line: 155, column: 23, scope: !1244)
!1276 = !DILocation(line: 155, column: 5, scope: !1244)
!1277 = !DILocation(line: 155, column: 10, scope: !1244)
!1278 = !DILocation(line: 155, column: 21, scope: !1244)
!1279 = !DILocation(line: 156, column: 23, scope: !1244)
!1280 = !DILocation(line: 156, column: 5, scope: !1244)
!1281 = !DILocation(line: 156, column: 10, scope: !1244)
!1282 = !DILocation(line: 156, column: 21, scope: !1244)
!1283 = !DILocation(line: 157, column: 23, scope: !1244)
!1284 = !DILocation(line: 157, column: 5, scope: !1244)
!1285 = !DILocation(line: 157, column: 10, scope: !1244)
!1286 = !DILocation(line: 157, column: 21, scope: !1244)
!1287 = !DILocation(line: 158, column: 23, scope: !1244)
!1288 = !DILocation(line: 158, column: 5, scope: !1244)
!1289 = !DILocation(line: 158, column: 10, scope: !1244)
!1290 = !DILocation(line: 158, column: 21, scope: !1244)
!1291 = !DILocation(line: 159, column: 23, scope: !1244)
!1292 = !DILocation(line: 159, column: 5, scope: !1244)
!1293 = !DILocation(line: 159, column: 10, scope: !1244)
!1294 = !DILocation(line: 159, column: 21, scope: !1244)
!1295 = !DILocalVariable(name: "i", scope: !1296, file: !6, line: 161, type: !14)
!1296 = distinct !DILexicalBlock(scope: !1244, file: !6, line: 161, column: 5)
!1297 = !DILocation(line: 161, column: 18, scope: !1296)
!1298 = !DILocation(line: 161, column: 10, scope: !1296)
!1299 = !DILocation(line: 161, column: 25, scope: !1300)
!1300 = distinct !DILexicalBlock(scope: !1296, file: !6, line: 161, column: 5)
!1301 = !DILocation(line: 161, column: 29, scope: !1300)
!1302 = !DILocation(line: 161, column: 34, scope: !1300)
!1303 = !DILocation(line: 161, column: 27, scope: !1300)
!1304 = !DILocation(line: 161, column: 5, scope: !1296)
!1305 = !DILocation(line: 162, column: 26, scope: !1306)
!1306 = distinct !DILexicalBlock(scope: !1300, file: !6, line: 161, column: 49)
!1307 = !DILocation(line: 162, column: 31, scope: !1306)
!1308 = !DILocation(line: 162, column: 39, scope: !1306)
!1309 = !DILocation(line: 162, column: 42, scope: !1306)
!1310 = !DILocation(line: 162, column: 9, scope: !1306)
!1311 = !DILocation(line: 163, column: 26, scope: !1306)
!1312 = !DILocation(line: 163, column: 31, scope: !1306)
!1313 = !DILocation(line: 163, column: 39, scope: !1306)
!1314 = !DILocation(line: 163, column: 42, scope: !1306)
!1315 = !DILocation(line: 163, column: 9, scope: !1306)
!1316 = !DILocation(line: 164, column: 5, scope: !1306)
!1317 = !DILocation(line: 161, column: 45, scope: !1300)
!1318 = !DILocation(line: 161, column: 5, scope: !1300)
!1319 = distinct !{!1319, !1304, !1320, !299}
!1320 = !DILocation(line: 164, column: 5, scope: !1296)
!1321 = !DILocation(line: 166, column: 32, scope: !1244)
!1322 = !DILocation(line: 166, column: 41, scope: !1244)
!1323 = !DILocation(line: 166, column: 5, scope: !1244)
!1324 = !DILocation(line: 166, column: 10, scope: !1244)
!1325 = !DILocation(line: 166, column: 29, scope: !1244)
!1326 = !DILocation(line: 167, column: 26, scope: !1244)
!1327 = !DILocation(line: 167, column: 31, scope: !1244)
!1328 = !DILocation(line: 167, column: 5, scope: !1244)
!1329 = !DILocation(line: 168, column: 18, scope: !1244)
!1330 = !DILocation(line: 168, column: 23, scope: !1244)
!1331 = !DILocation(line: 168, column: 5, scope: !1244)
!1332 = !DILocation(line: 170, column: 1, scope: !1244)
!1333 = distinct !DISubprogram(name: "cb_cmp", scope: !56, file: !56, line: 40, type: !76, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1334 = !DILocalVariable(name: "key_a", arg: 1, scope: !1333, file: !56, line: 40, type: !19)
!1335 = !DILocation(line: 40, column: 19, scope: !1333)
!1336 = !DILocalVariable(name: "key_b", arg: 2, scope: !1333, file: !56, line: 40, type: !19)
!1337 = !DILocation(line: 40, column: 37, scope: !1333)
!1338 = !DILocation(line: 42, column: 9, scope: !1339)
!1339 = distinct !DILexicalBlock(scope: !1333, file: !56, line: 42, column: 9)
!1340 = !DILocation(line: 42, column: 18, scope: !1339)
!1341 = !DILocation(line: 42, column: 15, scope: !1339)
!1342 = !DILocation(line: 42, column: 9, scope: !1333)
!1343 = !DILocation(line: 43, column: 9, scope: !1344)
!1344 = distinct !DILexicalBlock(scope: !1339, file: !56, line: 42, column: 25)
!1345 = !DILocation(line: 44, column: 16, scope: !1346)
!1346 = distinct !DILexicalBlock(scope: !1339, file: !56, line: 44, column: 16)
!1347 = !DILocation(line: 44, column: 24, scope: !1346)
!1348 = !DILocation(line: 44, column: 22, scope: !1346)
!1349 = !DILocation(line: 44, column: 16, scope: !1339)
!1350 = !DILocation(line: 45, column: 9, scope: !1351)
!1351 = distinct !DILexicalBlock(scope: !1346, file: !56, line: 44, column: 31)
!1352 = !DILocation(line: 47, column: 9, scope: !1353)
!1353 = distinct !DILexicalBlock(scope: !1346, file: !56, line: 46, column: 12)
!1354 = !DILocation(line: 49, column: 1, scope: !1333)
!1355 = distinct !DISubprogram(name: "cb_hash", scope: !56, file: !56, line: 53, type: !86, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1356 = !DILocalVariable(name: "key", arg: 1, scope: !1355, file: !56, line: 53, type: !19)
!1357 = !DILocation(line: 53, column: 20, scope: !1355)
!1358 = !DILocation(line: 55, column: 23, scope: !1355)
!1359 = !DILocation(line: 55, column: 5, scope: !1355)
!1360 = distinct !DISubprogram(name: "cb_destroy", scope: !56, file: !56, line: 71, type: !91, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1361 = !DILocalVariable(name: "data", arg: 1, scope: !1360, file: !56, line: 71, type: !22)
!1362 = !DILocation(line: 71, column: 18, scope: !1360)
!1363 = !DILocation(line: 73, column: 10, scope: !1360)
!1364 = !DILocation(line: 73, column: 5, scope: !1360)
!1365 = !DILocation(line: 74, column: 1, scope: !1360)
!1366 = distinct !DISubprogram(name: "trace_init", scope: !153, file: !153, line: 34, type: !1367, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1367 = !DISubroutineType(types: !1368)
!1368 = !{null, !524, !14}
!1369 = !DILocalVariable(name: "trace", arg: 1, scope: !1366, file: !153, line: 34, type: !524)
!1370 = !DILocation(line: 34, column: 21, scope: !1366)
!1371 = !DILocalVariable(name: "capacity", arg: 2, scope: !1366, file: !153, line: 34, type: !14)
!1372 = !DILocation(line: 34, column: 36, scope: !1366)
!1373 = !DILocation(line: 36, column: 5, scope: !1374)
!1374 = distinct !DILexicalBlock(scope: !1375, file: !153, line: 36, column: 5)
!1375 = distinct !DILexicalBlock(scope: !1366, file: !153, line: 36, column: 5)
!1376 = !DILocation(line: 36, column: 5, scope: !1375)
!1377 = !DILocation(line: 37, column: 27, scope: !1366)
!1378 = !DILocation(line: 37, column: 36, scope: !1366)
!1379 = !DILocation(line: 37, column: 20, scope: !1366)
!1380 = !DILocation(line: 37, column: 5, scope: !1366)
!1381 = !DILocation(line: 37, column: 12, scope: !1366)
!1382 = !DILocation(line: 37, column: 18, scope: !1366)
!1383 = !DILocation(line: 38, column: 9, scope: !1384)
!1384 = distinct !DILexicalBlock(scope: !1366, file: !153, line: 38, column: 9)
!1385 = !DILocation(line: 38, column: 16, scope: !1384)
!1386 = !DILocation(line: 38, column: 9, scope: !1366)
!1387 = !DILocation(line: 39, column: 9, scope: !1388)
!1388 = distinct !DILexicalBlock(scope: !1384, file: !153, line: 38, column: 23)
!1389 = !DILocation(line: 39, column: 16, scope: !1388)
!1390 = !DILocation(line: 39, column: 28, scope: !1388)
!1391 = !DILocation(line: 40, column: 30, scope: !1388)
!1392 = !DILocation(line: 40, column: 9, scope: !1388)
!1393 = !DILocation(line: 40, column: 16, scope: !1388)
!1394 = !DILocation(line: 40, column: 28, scope: !1388)
!1395 = !DILocation(line: 41, column: 9, scope: !1388)
!1396 = !DILocation(line: 41, column: 16, scope: !1388)
!1397 = !DILocation(line: 41, column: 28, scope: !1388)
!1398 = !DILocation(line: 42, column: 5, scope: !1388)
!1399 = !DILocation(line: 43, column: 9, scope: !1400)
!1400 = distinct !DILexicalBlock(scope: !1384, file: !153, line: 42, column: 12)
!1401 = !DILocation(line: 43, column: 16, scope: !1400)
!1402 = !DILocation(line: 43, column: 28, scope: !1400)
!1403 = !DILocation(line: 44, column: 9, scope: !1400)
!1404 = !DILocation(line: 44, column: 16, scope: !1400)
!1405 = !DILocation(line: 44, column: 28, scope: !1400)
!1406 = !DILocation(line: 45, column: 9, scope: !1400)
!1407 = !DILocation(line: 45, column: 16, scope: !1400)
!1408 = !DILocation(line: 45, column: 28, scope: !1400)
!1409 = !DILocation(line: 46, column: 9, scope: !1410)
!1410 = distinct !DILexicalBlock(scope: !1411, file: !153, line: 46, column: 9)
!1411 = distinct !DILexicalBlock(scope: !1400, file: !153, line: 46, column: 9)
!1412 = !DILocation(line: 48, column: 1, scope: !1366)
!1413 = distinct !DISubprogram(name: "vatomicptr_init", scope: !762, file: !762, line: 4223, type: !1414, scopeLine: 4224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1414 = !DISubroutineType(types: !1415)
!1415 = !{null, !811, !22}
!1416 = !DILocalVariable(name: "a", arg: 1, scope: !1413, file: !762, line: 4223, type: !811)
!1417 = !DILocation(line: 4223, column: 31, scope: !1413)
!1418 = !DILocalVariable(name: "v", arg: 2, scope: !1413, file: !762, line: 4223, type: !22)
!1419 = !DILocation(line: 4223, column: 40, scope: !1413)
!1420 = !DILocation(line: 4225, column: 22, scope: !1413)
!1421 = !DILocation(line: 4225, column: 25, scope: !1413)
!1422 = !DILocation(line: 4225, column: 5, scope: !1413)
!1423 = !DILocation(line: 4226, column: 1, scope: !1413)
!1424 = distinct !DISubprogram(name: "vatomicsz_write_rlx", scope: !722, file: !722, line: 519, type: !1425, scopeLine: 520, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1425 = !DISubroutineType(types: !1426)
!1426 = !{null, !1427, !14}
!1427 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!1428 = !DILocalVariable(name: "a", arg: 1, scope: !1424, file: !722, line: 519, type: !1427)
!1429 = !DILocation(line: 519, column: 34, scope: !1424)
!1430 = !DILocalVariable(name: "v", arg: 2, scope: !1424, file: !722, line: 519, type: !14)
!1431 = !DILocation(line: 519, column: 45, scope: !1424)
!1432 = !DILocation(line: 521, column: 5, scope: !1424)
!1433 = !{i64 2148226827}
!1434 = !DILocation(line: 522, column: 23, scope: !1424)
!1435 = !DILocation(line: 522, column: 26, scope: !1424)
!1436 = !DILocation(line: 522, column: 30, scope: !1424)
!1437 = !DILocation(line: 522, column: 5, scope: !1424)
!1438 = !DILocation(line: 523, column: 5, scope: !1424)
!1439 = !{i64 2148226867}
!1440 = !DILocation(line: 524, column: 1, scope: !1424)
!1441 = distinct !DISubprogram(name: "rwlock_init", scope: !101, file: !101, line: 33, type: !696, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1442 = !DILocalVariable(name: "l", arg: 1, scope: !1441, file: !101, line: 33, type: !676)
!1443 = !DILocation(line: 33, column: 23, scope: !1441)
!1444 = !DILocalVariable(name: "i", scope: !1445, file: !101, line: 35, type: !14)
!1445 = distinct !DILexicalBlock(scope: !1441, file: !101, line: 35, column: 5)
!1446 = !DILocation(line: 35, column: 18, scope: !1445)
!1447 = !DILocation(line: 35, column: 10, scope: !1445)
!1448 = !DILocation(line: 35, column: 25, scope: !1449)
!1449 = distinct !DILexicalBlock(scope: !1445, file: !101, line: 35, column: 5)
!1450 = !DILocation(line: 35, column: 27, scope: !1449)
!1451 = !DILocation(line: 35, column: 5, scope: !1445)
!1452 = !DILocation(line: 36, column: 29, scope: !1453)
!1453 = distinct !DILexicalBlock(scope: !1449, file: !101, line: 35, column: 54)
!1454 = !DILocation(line: 36, column: 32, scope: !1453)
!1455 = !DILocation(line: 36, column: 37, scope: !1453)
!1456 = !DILocation(line: 36, column: 9, scope: !1453)
!1457 = !DILocation(line: 37, column: 5, scope: !1453)
!1458 = !DILocation(line: 35, column: 50, scope: !1449)
!1459 = !DILocation(line: 35, column: 5, scope: !1449)
!1460 = distinct !{!1460, !1451, !1461, !299}
!1461 = !DILocation(line: 37, column: 5, scope: !1445)
!1462 = !DILocation(line: 38, column: 1, scope: !1441)
!1463 = distinct !DISubprogram(name: "vatomicptr_write", scope: !722, file: !722, line: 532, type: !1414, scopeLine: 533, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1464 = !DILocalVariable(name: "a", arg: 1, scope: !1463, file: !722, line: 532, type: !811)
!1465 = !DILocation(line: 532, column: 32, scope: !1463)
!1466 = !DILocalVariable(name: "v", arg: 2, scope: !1463, file: !722, line: 532, type: !22)
!1467 = !DILocation(line: 532, column: 41, scope: !1463)
!1468 = !DILocation(line: 534, column: 5, scope: !1463)
!1469 = !{i64 2148226905}
!1470 = !DILocation(line: 535, column: 23, scope: !1463)
!1471 = !DILocation(line: 535, column: 26, scope: !1463)
!1472 = !DILocation(line: 535, column: 30, scope: !1463)
!1473 = !DILocation(line: 535, column: 5, scope: !1463)
!1474 = !DILocation(line: 536, column: 5, scope: !1463)
!1475 = !{i64 2148226945}
!1476 = !DILocation(line: 537, column: 1, scope: !1463)
!1477 = distinct !DISubprogram(name: "_imap_verify", scope: !56, file: !56, line: 77, type: !182, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1478 = !DILocalVariable(name: "key", scope: !1477, file: !56, line: 79, type: !19)
!1479 = !DILocation(line: 79, column: 16, scope: !1477)
!1480 = !DILocalVariable(name: "data", scope: !1477, file: !56, line: 80, type: !210)
!1481 = !DILocation(line: 80, column: 13, scope: !1477)
!1482 = !DILocalVariable(name: "iter", scope: !1477, file: !56, line: 81, type: !1483)
!1483 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_iter_t", file: !6, line: 99, baseType: !1484)
!1484 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vsimpleht_iter_s", file: !6, line: 96, size: 128, elements: !1485)
!1485 = !{!1486, !1487}
!1486 = !DIDerivedType(tag: DW_TAG_member, name: "tbl", scope: !1484, file: !6, line: 97, baseType: !499, size: 64)
!1487 = !DIDerivedType(tag: DW_TAG_member, name: "idx", scope: !1484, file: !6, line: 98, baseType: !14, size: 64, offset: 64)
!1488 = !DILocation(line: 81, column: 22, scope: !1477)
!1489 = !DILocalVariable(name: "add_trc", scope: !1477, file: !56, line: 83, type: !152)
!1490 = !DILocation(line: 83, column: 13, scope: !1477)
!1491 = !DILocalVariable(name: "rem_trc", scope: !1477, file: !56, line: 84, type: !152)
!1492 = !DILocation(line: 84, column: 13, scope: !1477)
!1493 = !DILocalVariable(name: "final_state_trc", scope: !1477, file: !56, line: 85, type: !152)
!1494 = !DILocation(line: 85, column: 13, scope: !1477)
!1495 = !DILocation(line: 87, column: 5, scope: !1477)
!1496 = !DILocation(line: 88, column: 5, scope: !1477)
!1497 = !DILocalVariable(name: "i", scope: !1498, file: !56, line: 91, type: !14)
!1498 = distinct !DILexicalBlock(scope: !1477, file: !56, line: 91, column: 5)
!1499 = !DILocation(line: 91, column: 18, scope: !1498)
!1500 = !DILocation(line: 91, column: 10, scope: !1498)
!1501 = !DILocation(line: 91, column: 25, scope: !1502)
!1502 = distinct !DILexicalBlock(scope: !1498, file: !56, line: 91, column: 5)
!1503 = !DILocation(line: 91, column: 27, scope: !1502)
!1504 = !DILocation(line: 91, column: 5, scope: !1498)
!1505 = !DILocation(line: 92, column: 43, scope: !1506)
!1506 = distinct !DILexicalBlock(scope: !1502, file: !56, line: 91, column: 43)
!1507 = !DILocation(line: 92, column: 37, scope: !1506)
!1508 = !DILocation(line: 92, column: 9, scope: !1506)
!1509 = !DILocation(line: 93, column: 43, scope: !1506)
!1510 = !DILocation(line: 93, column: 37, scope: !1506)
!1511 = !DILocation(line: 93, column: 9, scope: !1506)
!1512 = !DILocation(line: 94, column: 5, scope: !1506)
!1513 = !DILocation(line: 91, column: 39, scope: !1502)
!1514 = !DILocation(line: 91, column: 5, scope: !1502)
!1515 = distinct !{!1515, !1504, !1516, !299}
!1516 = !DILocation(line: 94, column: 5, scope: !1498)
!1517 = !DILocation(line: 97, column: 5, scope: !1477)
!1518 = !DILocation(line: 98, column: 5, scope: !1477)
!1519 = !DILocation(line: 99, column: 5, scope: !1477)
!1520 = !DILocation(line: 99, column: 45, scope: !1477)
!1521 = !DILocation(line: 99, column: 12, scope: !1477)
!1522 = !DILocation(line: 100, column: 37, scope: !1523)
!1523 = distinct !DILexicalBlock(scope: !1477, file: !56, line: 99, column: 62)
!1524 = !DILocation(line: 100, column: 9, scope: !1523)
!1525 = distinct !{!1525, !1519, !1526, !299}
!1526 = !DILocation(line: 101, column: 5, scope: !1477)
!1527 = !DILocation(line: 103, column: 5, scope: !1477)
!1528 = !DILocalVariable(name: "eq", scope: !1477, file: !56, line: 104, type: !42)
!1529 = !DILocation(line: 104, column: 13, scope: !1477)
!1530 = !DILocation(line: 104, column: 18, scope: !1477)
!1531 = !DILocation(line: 106, column: 5, scope: !1477)
!1532 = !DILocation(line: 107, column: 5, scope: !1477)
!1533 = !DILocation(line: 108, column: 5, scope: !1477)
!1534 = !DILocation(line: 109, column: 5, scope: !1535)
!1535 = distinct !DILexicalBlock(scope: !1536, file: !56, line: 109, column: 5)
!1536 = distinct !DILexicalBlock(scope: !1477, file: !56, line: 109, column: 5)
!1537 = !DILocation(line: 109, column: 5, scope: !1536)
!1538 = !DILocation(line: 110, column: 1, scope: !1477)
!1539 = distinct !DISubprogram(name: "trace_destroy", scope: !153, file: !153, line: 98, type: !967, scopeLine: 99, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1540 = !DILocalVariable(name: "trace", arg: 1, scope: !1539, file: !153, line: 98, type: !524)
!1541 = !DILocation(line: 98, column: 24, scope: !1539)
!1542 = !DILocation(line: 100, column: 5, scope: !1543)
!1543 = distinct !DILexicalBlock(scope: !1544, file: !153, line: 100, column: 5)
!1544 = distinct !DILexicalBlock(scope: !1539, file: !153, line: 100, column: 5)
!1545 = !DILocation(line: 100, column: 5, scope: !1544)
!1546 = !DILocation(line: 101, column: 5, scope: !1547)
!1547 = distinct !DILexicalBlock(scope: !1548, file: !153, line: 101, column: 5)
!1548 = distinct !DILexicalBlock(scope: !1539, file: !153, line: 101, column: 5)
!1549 = !DILocation(line: 101, column: 5, scope: !1548)
!1550 = !DILocation(line: 102, column: 10, scope: !1539)
!1551 = !DILocation(line: 102, column: 17, scope: !1539)
!1552 = !DILocation(line: 102, column: 5, scope: !1539)
!1553 = !DILocation(line: 103, column: 5, scope: !1539)
!1554 = !DILocation(line: 103, column: 12, scope: !1539)
!1555 = !DILocation(line: 103, column: 24, scope: !1539)
!1556 = !DILocation(line: 104, column: 1, scope: !1539)
!1557 = distinct !DISubprogram(name: "vsimpleht_destroy", scope: !6, file: !6, line: 178, type: !542, scopeLine: 179, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1558 = !DILocalVariable(name: "tbl", arg: 1, scope: !1557, file: !6, line: 178, type: !499)
!1559 = !DILocation(line: 178, column: 32, scope: !1557)
!1560 = !DILocalVariable(name: "entry", scope: !1557, file: !6, line: 180, type: !62)
!1561 = !DILocation(line: 180, column: 24, scope: !1557)
!1562 = !DILocalVariable(name: "obj", scope: !1557, file: !6, line: 181, type: !22)
!1563 = !DILocation(line: 181, column: 11, scope: !1557)
!1564 = !DILocation(line: 182, column: 5, scope: !1565)
!1565 = distinct !DILexicalBlock(scope: !1566, file: !6, line: 182, column: 5)
!1566 = distinct !DILexicalBlock(scope: !1557, file: !6, line: 182, column: 5)
!1567 = !DILocation(line: 182, column: 5, scope: !1566)
!1568 = !DILocalVariable(name: "i", scope: !1569, file: !6, line: 183, type: !14)
!1569 = distinct !DILexicalBlock(scope: !1557, file: !6, line: 183, column: 5)
!1570 = !DILocation(line: 183, column: 18, scope: !1569)
!1571 = !DILocation(line: 183, column: 10, scope: !1569)
!1572 = !DILocation(line: 183, column: 25, scope: !1573)
!1573 = distinct !DILexicalBlock(scope: !1569, file: !6, line: 183, column: 5)
!1574 = !DILocation(line: 183, column: 29, scope: !1573)
!1575 = !DILocation(line: 183, column: 34, scope: !1573)
!1576 = !DILocation(line: 183, column: 27, scope: !1573)
!1577 = !DILocation(line: 183, column: 5, scope: !1569)
!1578 = !DILocation(line: 184, column: 18, scope: !1579)
!1579 = distinct !DILexicalBlock(scope: !1573, file: !6, line: 183, column: 49)
!1580 = !DILocation(line: 184, column: 23, scope: !1579)
!1581 = !DILocation(line: 184, column: 31, scope: !1579)
!1582 = !DILocation(line: 184, column: 15, scope: !1579)
!1583 = !DILocation(line: 185, column: 38, scope: !1579)
!1584 = !DILocation(line: 185, column: 45, scope: !1579)
!1585 = !DILocation(line: 185, column: 17, scope: !1579)
!1586 = !DILocation(line: 185, column: 15, scope: !1579)
!1587 = !DILocation(line: 186, column: 13, scope: !1588)
!1588 = distinct !DILexicalBlock(scope: !1579, file: !6, line: 186, column: 13)
!1589 = !DILocation(line: 186, column: 13, scope: !1579)
!1590 = !DILocation(line: 187, column: 13, scope: !1591)
!1591 = distinct !DILexicalBlock(scope: !1588, file: !6, line: 186, column: 18)
!1592 = !DILocation(line: 187, column: 18, scope: !1591)
!1593 = !DILocation(line: 187, column: 29, scope: !1591)
!1594 = !DILocation(line: 188, column: 9, scope: !1591)
!1595 = !DILocation(line: 189, column: 5, scope: !1579)
!1596 = !DILocation(line: 183, column: 45, scope: !1573)
!1597 = !DILocation(line: 183, column: 5, scope: !1573)
!1598 = distinct !{!1598, !1577, !1599, !299}
!1599 = !DILocation(line: 189, column: 5, scope: !1569)
!1600 = !DILocation(line: 190, column: 1, scope: !1557)
!1601 = distinct !DISubprogram(name: "trace_merge_into", scope: !153, file: !153, line: 177, type: !1602, scopeLine: 178, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1602 = !DISubroutineType(types: !1603)
!1603 = !{null, !524, !524}
!1604 = !DILocalVariable(name: "trace_container", arg: 1, scope: !1601, file: !153, line: 177, type: !524)
!1605 = !DILocation(line: 177, column: 27, scope: !1601)
!1606 = !DILocalVariable(name: "trace", arg: 2, scope: !1601, file: !153, line: 177, type: !524)
!1607 = !DILocation(line: 177, column: 53, scope: !1601)
!1608 = !DILocation(line: 179, column: 30, scope: !1601)
!1609 = !DILocation(line: 179, column: 47, scope: !1601)
!1610 = !DILocation(line: 179, column: 5, scope: !1601)
!1611 = !DILocation(line: 180, column: 1, scope: !1601)
!1612 = distinct !DISubprogram(name: "vsimpleht_iter_init", scope: !6, file: !6, line: 280, type: !1613, scopeLine: 281, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1613 = !DISubroutineType(types: !1614)
!1614 = !{null, !499, !1615}
!1615 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1483, size: 64)
!1616 = !DILocalVariable(name: "tbl", arg: 1, scope: !1612, file: !6, line: 280, type: !499)
!1617 = !DILocation(line: 280, column: 34, scope: !1612)
!1618 = !DILocalVariable(name: "iter", arg: 2, scope: !1612, file: !6, line: 280, type: !1615)
!1619 = !DILocation(line: 280, column: 57, scope: !1612)
!1620 = !DILocation(line: 282, column: 5, scope: !1621)
!1621 = distinct !DILexicalBlock(scope: !1622, file: !6, line: 282, column: 5)
!1622 = distinct !DILexicalBlock(scope: !1612, file: !6, line: 282, column: 5)
!1623 = !DILocation(line: 282, column: 5, scope: !1622)
!1624 = !DILocation(line: 283, column: 5, scope: !1625)
!1625 = distinct !DILexicalBlock(scope: !1626, file: !6, line: 283, column: 5)
!1626 = distinct !DILexicalBlock(scope: !1612, file: !6, line: 283, column: 5)
!1627 = !DILocation(line: 283, column: 5, scope: !1626)
!1628 = !DILocation(line: 284, column: 17, scope: !1612)
!1629 = !DILocation(line: 284, column: 5, scope: !1612)
!1630 = !DILocation(line: 284, column: 11, scope: !1612)
!1631 = !DILocation(line: 284, column: 15, scope: !1612)
!1632 = !DILocation(line: 285, column: 5, scope: !1612)
!1633 = !DILocation(line: 285, column: 11, scope: !1612)
!1634 = !DILocation(line: 285, column: 15, scope: !1612)
!1635 = !DILocation(line: 286, column: 1, scope: !1612)
!1636 = distinct !DISubprogram(name: "vsimpleht_iter_next", scope: !6, file: !6, line: 317, type: !1637, scopeLine: 318, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1637 = !DISubroutineType(types: !1638)
!1638 = !{!42, !1615, !1639, !52}
!1639 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!1640 = !DILocalVariable(name: "iter", arg: 1, scope: !1636, file: !6, line: 317, type: !1615)
!1641 = !DILocation(line: 317, column: 39, scope: !1636)
!1642 = !DILocalVariable(name: "key", arg: 2, scope: !1636, file: !6, line: 317, type: !1639)
!1643 = !DILocation(line: 317, column: 57, scope: !1636)
!1644 = !DILocalVariable(name: "val", arg: 3, scope: !1636, file: !6, line: 317, type: !52)
!1645 = !DILocation(line: 317, column: 69, scope: !1636)
!1646 = !DILocalVariable(name: "k", scope: !1636, file: !6, line: 319, type: !19)
!1647 = !DILocation(line: 319, column: 16, scope: !1636)
!1648 = !DILocalVariable(name: "v", scope: !1636, file: !6, line: 320, type: !22)
!1649 = !DILocation(line: 320, column: 11, scope: !1636)
!1650 = !DILocalVariable(name: "entries", scope: !1636, file: !6, line: 321, type: !62)
!1651 = !DILocation(line: 321, column: 24, scope: !1636)
!1652 = !DILocation(line: 322, column: 5, scope: !1653)
!1653 = distinct !DILexicalBlock(scope: !1654, file: !6, line: 322, column: 5)
!1654 = distinct !DILexicalBlock(scope: !1636, file: !6, line: 322, column: 5)
!1655 = !DILocation(line: 322, column: 5, scope: !1654)
!1656 = !DILocation(line: 323, column: 5, scope: !1657)
!1657 = distinct !DILexicalBlock(scope: !1658, file: !6, line: 323, column: 5)
!1658 = distinct !DILexicalBlock(scope: !1636, file: !6, line: 323, column: 5)
!1659 = !DILocation(line: 323, column: 5, scope: !1658)
!1660 = !DILocation(line: 324, column: 5, scope: !1661)
!1661 = distinct !DILexicalBlock(scope: !1662, file: !6, line: 324, column: 5)
!1662 = distinct !DILexicalBlock(scope: !1636, file: !6, line: 324, column: 5)
!1663 = !DILocation(line: 324, column: 5, scope: !1662)
!1664 = !DILocation(line: 325, column: 5, scope: !1665)
!1665 = distinct !DILexicalBlock(scope: !1666, file: !6, line: 325, column: 5)
!1666 = distinct !DILexicalBlock(scope: !1636, file: !6, line: 325, column: 5)
!1667 = !DILocation(line: 325, column: 5, scope: !1666)
!1668 = !DILocation(line: 326, column: 15, scope: !1636)
!1669 = !DILocation(line: 326, column: 21, scope: !1636)
!1670 = !DILocation(line: 326, column: 26, scope: !1636)
!1671 = !DILocation(line: 326, column: 13, scope: !1636)
!1672 = !DILocation(line: 327, column: 5, scope: !1673)
!1673 = distinct !DILexicalBlock(scope: !1674, file: !6, line: 327, column: 5)
!1674 = distinct !DILexicalBlock(scope: !1636, file: !6, line: 327, column: 5)
!1675 = !DILocation(line: 327, column: 5, scope: !1674)
!1676 = !DILocalVariable(name: "i", scope: !1677, file: !6, line: 328, type: !14)
!1677 = distinct !DILexicalBlock(scope: !1636, file: !6, line: 328, column: 5)
!1678 = !DILocation(line: 328, column: 18, scope: !1677)
!1679 = !DILocation(line: 328, column: 22, scope: !1677)
!1680 = !DILocation(line: 328, column: 28, scope: !1677)
!1681 = !DILocation(line: 328, column: 10, scope: !1677)
!1682 = !DILocation(line: 328, column: 33, scope: !1683)
!1683 = distinct !DILexicalBlock(scope: !1677, file: !6, line: 328, column: 5)
!1684 = !DILocation(line: 328, column: 37, scope: !1683)
!1685 = !DILocation(line: 328, column: 43, scope: !1683)
!1686 = !DILocation(line: 328, column: 48, scope: !1683)
!1687 = !DILocation(line: 328, column: 35, scope: !1683)
!1688 = !DILocation(line: 328, column: 5, scope: !1677)
!1689 = !DILocation(line: 329, column: 42, scope: !1690)
!1690 = distinct !DILexicalBlock(scope: !1683, file: !6, line: 328, column: 63)
!1691 = !DILocation(line: 329, column: 50, scope: !1690)
!1692 = !DILocation(line: 329, column: 53, scope: !1690)
!1693 = !DILocation(line: 329, column: 25, scope: !1690)
!1694 = !DILocation(line: 329, column: 13, scope: !1690)
!1695 = !DILocation(line: 329, column: 11, scope: !1690)
!1696 = !DILocation(line: 330, column: 30, scope: !1690)
!1697 = !DILocation(line: 330, column: 38, scope: !1690)
!1698 = !DILocation(line: 330, column: 41, scope: !1690)
!1699 = !DILocation(line: 330, column: 13, scope: !1690)
!1700 = !DILocation(line: 330, column: 11, scope: !1690)
!1701 = !DILocation(line: 331, column: 13, scope: !1702)
!1702 = distinct !DILexicalBlock(scope: !1690, file: !6, line: 331, column: 13)
!1703 = !DILocation(line: 331, column: 15, scope: !1702)
!1704 = !DILocation(line: 331, column: 18, scope: !1702)
!1705 = !DILocation(line: 331, column: 13, scope: !1690)
!1706 = !DILocation(line: 332, column: 25, scope: !1707)
!1707 = distinct !DILexicalBlock(scope: !1702, file: !6, line: 331, column: 21)
!1708 = !DILocation(line: 332, column: 27, scope: !1707)
!1709 = !DILocation(line: 332, column: 13, scope: !1707)
!1710 = !DILocation(line: 332, column: 19, scope: !1707)
!1711 = !DILocation(line: 332, column: 23, scope: !1707)
!1712 = !DILocation(line: 333, column: 25, scope: !1707)
!1713 = !DILocation(line: 333, column: 14, scope: !1707)
!1714 = !DILocation(line: 333, column: 23, scope: !1707)
!1715 = !DILocation(line: 334, column: 25, scope: !1707)
!1716 = !DILocation(line: 334, column: 14, scope: !1707)
!1717 = !DILocation(line: 334, column: 23, scope: !1707)
!1718 = !DILocation(line: 335, column: 13, scope: !1707)
!1719 = !DILocation(line: 337, column: 5, scope: !1690)
!1720 = !DILocation(line: 328, column: 59, scope: !1683)
!1721 = !DILocation(line: 328, column: 5, scope: !1683)
!1722 = distinct !{!1722, !1688, !1723, !299}
!1723 = !DILocation(line: 337, column: 5, scope: !1677)
!1724 = !DILocation(line: 338, column: 5, scope: !1636)
!1725 = !DILocation(line: 339, column: 1, scope: !1636)
!1726 = distinct !DISubprogram(name: "trace_subtract_from", scope: !153, file: !153, line: 183, type: !1602, scopeLine: 184, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1727 = !DILocalVariable(name: "trace_container", arg: 1, scope: !1726, file: !153, line: 183, type: !524)
!1728 = !DILocation(line: 183, column: 30, scope: !1726)
!1729 = !DILocalVariable(name: "trace", arg: 2, scope: !1726, file: !153, line: 183, type: !524)
!1730 = !DILocation(line: 183, column: 56, scope: !1726)
!1731 = !DILocation(line: 185, column: 30, scope: !1726)
!1732 = !DILocation(line: 185, column: 47, scope: !1726)
!1733 = !DILocation(line: 185, column: 5, scope: !1726)
!1734 = !DILocation(line: 186, column: 1, scope: !1726)
!1735 = distinct !DISubprogram(name: "trace_is_subtrace", scope: !153, file: !153, line: 292, type: !1736, scopeLine: 294, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1736 = !DISubroutineType(types: !1737)
!1737 = !{!42, !524, !524, !1738}
!1738 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1739, size: 64)
!1739 = !DISubroutineType(types: !1740)
!1740 = !{null, !19}
!1741 = !DILocalVariable(name: "super_trace", arg: 1, scope: !1735, file: !153, line: 292, type: !524)
!1742 = !DILocation(line: 292, column: 28, scope: !1735)
!1743 = !DILocalVariable(name: "sub_trace", arg: 2, scope: !1735, file: !153, line: 292, type: !524)
!1744 = !DILocation(line: 292, column: 50, scope: !1735)
!1745 = !DILocalVariable(name: "print", arg: 3, scope: !1735, file: !153, line: 293, type: !1738)
!1746 = !DILocation(line: 293, column: 26, scope: !1735)
!1747 = !DILocalVariable(name: "i", scope: !1735, file: !153, line: 295, type: !14)
!1748 = !DILocation(line: 295, column: 13, scope: !1735)
!1749 = !DILocalVariable(name: "idx", scope: !1735, file: !153, line: 296, type: !14)
!1750 = !DILocation(line: 296, column: 13, scope: !1735)
!1751 = !DILocalVariable(name: "unit_a", scope: !1735, file: !153, line: 298, type: !157)
!1752 = !DILocation(line: 298, column: 19, scope: !1735)
!1753 = !DILocalVariable(name: "unit_b", scope: !1735, file: !153, line: 299, type: !157)
!1754 = !DILocation(line: 299, column: 19, scope: !1735)
!1755 = !DILocation(line: 302, column: 12, scope: !1756)
!1756 = distinct !DILexicalBlock(scope: !1735, file: !153, line: 302, column: 5)
!1757 = !DILocation(line: 302, column: 10, scope: !1756)
!1758 = !DILocation(line: 302, column: 17, scope: !1759)
!1759 = distinct !DILexicalBlock(scope: !1756, file: !153, line: 302, column: 5)
!1760 = !DILocation(line: 302, column: 21, scope: !1759)
!1761 = !DILocation(line: 302, column: 32, scope: !1759)
!1762 = !DILocation(line: 302, column: 19, scope: !1759)
!1763 = !DILocation(line: 302, column: 5, scope: !1756)
!1764 = !DILocation(line: 303, column: 19, scope: !1765)
!1765 = distinct !DILexicalBlock(scope: !1759, file: !153, line: 302, column: 42)
!1766 = !DILocation(line: 303, column: 30, scope: !1765)
!1767 = !DILocation(line: 303, column: 36, scope: !1765)
!1768 = !DILocation(line: 303, column: 16, scope: !1765)
!1769 = !DILocation(line: 305, column: 33, scope: !1770)
!1770 = distinct !DILexicalBlock(scope: !1765, file: !153, line: 305, column: 13)
!1771 = !DILocation(line: 305, column: 46, scope: !1770)
!1772 = !DILocation(line: 305, column: 54, scope: !1770)
!1773 = !DILocation(line: 305, column: 13, scope: !1770)
!1774 = !DILocation(line: 305, column: 13, scope: !1765)
!1775 = !DILocation(line: 306, column: 23, scope: !1776)
!1776 = distinct !DILexicalBlock(scope: !1770, file: !153, line: 305, column: 66)
!1777 = !DILocation(line: 306, column: 36, scope: !1776)
!1778 = !DILocation(line: 306, column: 42, scope: !1776)
!1779 = !DILocation(line: 306, column: 20, scope: !1776)
!1780 = !DILocation(line: 308, column: 13, scope: !1781)
!1781 = distinct !DILexicalBlock(scope: !1782, file: !153, line: 308, column: 13)
!1782 = distinct !DILexicalBlock(scope: !1776, file: !153, line: 308, column: 13)
!1783 = !DILocation(line: 308, column: 13, scope: !1782)
!1784 = !DILocation(line: 310, column: 17, scope: !1785)
!1785 = distinct !DILexicalBlock(scope: !1776, file: !153, line: 310, column: 17)
!1786 = !DILocation(line: 310, column: 25, scope: !1785)
!1787 = !DILocation(line: 310, column: 34, scope: !1785)
!1788 = !DILocation(line: 310, column: 42, scope: !1785)
!1789 = !DILocation(line: 310, column: 31, scope: !1785)
!1790 = !DILocation(line: 310, column: 17, scope: !1776)
!1791 = !DILocation(line: 311, column: 21, scope: !1792)
!1792 = distinct !DILexicalBlock(scope: !1793, file: !153, line: 311, column: 21)
!1793 = distinct !DILexicalBlock(scope: !1785, file: !153, line: 310, column: 49)
!1794 = !DILocation(line: 311, column: 21, scope: !1793)
!1795 = !DILocation(line: 314, column: 28, scope: !1796)
!1796 = distinct !DILexicalBlock(scope: !1792, file: !153, line: 311, column: 28)
!1797 = !DILocation(line: 314, column: 36, scope: !1796)
!1798 = !DILocation(line: 314, column: 41, scope: !1796)
!1799 = !DILocation(line: 314, column: 49, scope: !1796)
!1800 = !DILocation(line: 314, column: 56, scope: !1796)
!1801 = !DILocation(line: 314, column: 64, scope: !1796)
!1802 = !DILocation(line: 312, column: 21, scope: !1796)
!1803 = !DILocation(line: 315, column: 21, scope: !1796)
!1804 = !DILocation(line: 315, column: 27, scope: !1796)
!1805 = !DILocation(line: 315, column: 35, scope: !1796)
!1806 = !DILocation(line: 316, column: 17, scope: !1796)
!1807 = !DILocation(line: 317, column: 17, scope: !1793)
!1808 = !DILocation(line: 319, column: 9, scope: !1776)
!1809 = !DILocation(line: 320, column: 17, scope: !1810)
!1810 = distinct !DILexicalBlock(scope: !1811, file: !153, line: 320, column: 17)
!1811 = distinct !DILexicalBlock(scope: !1770, file: !153, line: 319, column: 16)
!1812 = !DILocation(line: 320, column: 17, scope: !1811)
!1813 = !DILocation(line: 321, column: 65, scope: !1814)
!1814 = distinct !DILexicalBlock(scope: !1810, file: !153, line: 320, column: 24)
!1815 = !DILocation(line: 321, column: 73, scope: !1814)
!1816 = !DILocation(line: 321, column: 17, scope: !1814)
!1817 = !DILocation(line: 322, column: 17, scope: !1814)
!1818 = !DILocation(line: 322, column: 23, scope: !1814)
!1819 = !DILocation(line: 322, column: 31, scope: !1814)
!1820 = !DILocation(line: 323, column: 13, scope: !1814)
!1821 = !DILocation(line: 324, column: 13, scope: !1811)
!1822 = !DILocation(line: 326, column: 5, scope: !1765)
!1823 = !DILocation(line: 302, column: 38, scope: !1759)
!1824 = !DILocation(line: 302, column: 5, scope: !1759)
!1825 = distinct !{!1825, !1763, !1826, !299}
!1826 = !DILocation(line: 326, column: 5, scope: !1756)
!1827 = !DILocation(line: 328, column: 5, scope: !1735)
!1828 = !DILocation(line: 329, column: 1, scope: !1735)
!1829 = distinct !DISubprogram(name: "_trace_merge_or_subtract", scope: !153, file: !153, line: 161, type: !1830, scopeLine: 163, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1830 = !DISubroutineType(types: !1831)
!1831 = !{null, !524, !524, !42}
!1832 = !DILocalVariable(name: "trace_container", arg: 1, scope: !1829, file: !153, line: 161, type: !524)
!1833 = !DILocation(line: 161, column: 35, scope: !1829)
!1834 = !DILocalVariable(name: "trace", arg: 2, scope: !1829, file: !153, line: 161, type: !524)
!1835 = !DILocation(line: 161, column: 61, scope: !1829)
!1836 = !DILocalVariable(name: "subtract", arg: 3, scope: !1829, file: !153, line: 162, type: !42)
!1837 = !DILocation(line: 162, column: 34, scope: !1829)
!1838 = !DILocalVariable(name: "i", scope: !1829, file: !153, line: 164, type: !14)
!1839 = !DILocation(line: 164, column: 13, scope: !1829)
!1840 = !DILocation(line: 165, column: 5, scope: !1841)
!1841 = distinct !DILexicalBlock(scope: !1842, file: !153, line: 165, column: 5)
!1842 = distinct !DILexicalBlock(scope: !1829, file: !153, line: 165, column: 5)
!1843 = !DILocation(line: 165, column: 5, scope: !1842)
!1844 = !DILocation(line: 166, column: 5, scope: !1845)
!1845 = distinct !DILexicalBlock(scope: !1846, file: !153, line: 166, column: 5)
!1846 = distinct !DILexicalBlock(scope: !1829, file: !153, line: 166, column: 5)
!1847 = !DILocation(line: 166, column: 5, scope: !1846)
!1848 = !DILocation(line: 168, column: 5, scope: !1849)
!1849 = distinct !DILexicalBlock(scope: !1850, file: !153, line: 168, column: 5)
!1850 = distinct !DILexicalBlock(scope: !1829, file: !153, line: 168, column: 5)
!1851 = !DILocation(line: 168, column: 5, scope: !1850)
!1852 = !DILocation(line: 169, column: 5, scope: !1853)
!1853 = distinct !DILexicalBlock(scope: !1854, file: !153, line: 169, column: 5)
!1854 = distinct !DILexicalBlock(scope: !1829, file: !153, line: 169, column: 5)
!1855 = !DILocation(line: 169, column: 5, scope: !1854)
!1856 = !DILocation(line: 171, column: 12, scope: !1857)
!1857 = distinct !DILexicalBlock(scope: !1829, file: !153, line: 171, column: 5)
!1858 = !DILocation(line: 171, column: 10, scope: !1857)
!1859 = !DILocation(line: 171, column: 17, scope: !1860)
!1860 = distinct !DILexicalBlock(scope: !1857, file: !153, line: 171, column: 5)
!1861 = !DILocation(line: 171, column: 21, scope: !1860)
!1862 = !DILocation(line: 171, column: 28, scope: !1860)
!1863 = !DILocation(line: 171, column: 19, scope: !1860)
!1864 = !DILocation(line: 171, column: 5, scope: !1857)
!1865 = !DILocation(line: 172, column: 39, scope: !1866)
!1866 = distinct !DILexicalBlock(scope: !1860, file: !153, line: 171, column: 38)
!1867 = !DILocation(line: 172, column: 56, scope: !1866)
!1868 = !DILocation(line: 172, column: 63, scope: !1866)
!1869 = !DILocation(line: 172, column: 69, scope: !1866)
!1870 = !DILocation(line: 172, column: 72, scope: !1866)
!1871 = !DILocation(line: 173, column: 39, scope: !1866)
!1872 = !DILocation(line: 173, column: 46, scope: !1866)
!1873 = !DILocation(line: 173, column: 52, scope: !1866)
!1874 = !DILocation(line: 173, column: 55, scope: !1866)
!1875 = !DILocation(line: 173, column: 62, scope: !1866)
!1876 = !DILocation(line: 172, column: 9, scope: !1866)
!1877 = !DILocation(line: 174, column: 5, scope: !1866)
!1878 = !DILocation(line: 171, column: 34, scope: !1860)
!1879 = !DILocation(line: 171, column: 5, scope: !1860)
!1880 = distinct !{!1880, !1864, !1881, !299}
!1881 = !DILocation(line: 174, column: 5, scope: !1857)
!1882 = !DILocation(line: 175, column: 1, scope: !1829)
!1883 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !722, file: !722, line: 319, type: !791, scopeLine: 320, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!1884 = !DILocalVariable(name: "a", arg: 1, scope: !1883, file: !722, line: 319, type: !793)
!1885 = !DILocation(line: 319, column: 41, scope: !1883)
!1886 = !DILocation(line: 321, column: 5, scope: !1883)
!1887 = !{i64 2148225657}
!1888 = !DILocalVariable(name: "tmp", scope: !1883, file: !722, line: 322, type: !22)
!1889 = !DILocation(line: 322, column: 11, scope: !1883)
!1890 = !DILocation(line: 322, column: 42, scope: !1883)
!1891 = !DILocation(line: 322, column: 45, scope: !1883)
!1892 = !DILocation(line: 322, column: 25, scope: !1883)
!1893 = !DILocation(line: 323, column: 5, scope: !1883)
!1894 = !{i64 2148225697}
!1895 = !DILocation(line: 324, column: 12, scope: !1883)
!1896 = !DILocation(line: 324, column: 5, scope: !1883)
