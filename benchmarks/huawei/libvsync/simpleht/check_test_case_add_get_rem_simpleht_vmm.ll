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
@g_added = dso_local global i8 0, align 1, !dbg !54
@g_got_nw_val = dso_local global i8 0, align 1, !dbg !57
@.str = private unnamed_addr constant [8 x i8] c"success\00", align 1
@.str.1 = private unnamed_addr constant [63 x i8] c"/home/drc/git/libvsync/verify/simpleht/test_case_add_get_rem.h\00", align 1
@__PRETTY_FUNCTION__.pre = private unnamed_addr constant [15 x i8] c"void pre(void)\00", align 1
@__PRETTY_FUNCTION__.t1 = private unnamed_addr constant [17 x i8] c"void t1(vsize_t)\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"d\00", align 1
@__PRETTY_FUNCTION__.post = private unnamed_addr constant [16 x i8] c"void post(void)\00", align 1
@.str.3 = private unnamed_addr constant [15 x i8] c"d->val == 999U\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"d->val == k\00", align 1
@.str.5 = private unnamed_addr constant [8 x i8] c"g_added\00", align 1
@.str.6 = private unnamed_addr constant [9 x i8] c"tid < 3U\00", align 1
@.str.7 = private unnamed_addr constant [65 x i8] c"/home/drc/git/libvsync/test/include/test/boilerplate/test_case.h\00", align 1
@__PRETTY_FUNCTION__.run = private unnamed_addr constant [18 x i8] c"void *run(void *)\00", align 1
@g_simpleht = internal global %struct.vsimpleht_s zeroinitializer, align 8, !dbg !59
@g_add = internal global [4 x %struct.trace_s] zeroinitializer, align 16, !dbg !154
@.str.8 = private unnamed_addr constant [9 x i8] c"key != 0\00", align 1
@.str.9 = private unnamed_addr constant [52 x i8] c"/home/drc/git/libvsync/include/vsync/map/simpleht.h\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_add = private unnamed_addr constant [65 x i8] c"vsimpleht_ret_t vsimpleht_add(vsimpleht_t *, vuintptr_t, void *)\00", align 1
@.str.10 = private unnamed_addr constant [20 x i8] c"value != ((void*)0)\00", align 1
@.str.11 = private unnamed_addr constant [65 x i8] c"You seem to have forgotten to call the  thread register function\00", align 1
@.str.12 = private unnamed_addr constant [112 x i8] c"rwlock_acquired_by_readers(&tbl->lock) && \22You seem to have forgotten to call the \22 \22 thread register function\22\00", align 1
@__PRETTY_FUNCTION__._vsimpleht_give_cleanup_a_chance = private unnamed_addr constant [53 x i8] c"void _vsimpleht_give_cleanup_a_chance(vsimpleht_t *)\00", align 1
@.str.13 = private unnamed_addr constant [11 x i8] c"g_tid < 3U\00", align 1
@.str.14 = private unnamed_addr constant [54 x i8] c"/home/drc/git/libvsync/verify/include/verify/rwlock.h\00", align 1
@__PRETTY_FUNCTION__._rwlock_get_tid = private unnamed_addr constant [38 x i8] c"vuint32_t _rwlock_get_tid(rwlock_t *)\00", align 1
@.str.15 = private unnamed_addr constant [25 x i8] c"NULL key is not allowed!\00", align 1
@.str.16 = private unnamed_addr constant [34 x i8] c"key && \22NULL key is not allowed!\22\00", align 1
@__PRETTY_FUNCTION__._vsimpleht_add = private unnamed_addr constant [66 x i8] c"vsimpleht_ret_t _vsimpleht_add(vsimpleht_t *, vuintptr_t, void *)\00", align 1
@.str.17 = private unnamed_addr constant [27 x i8] c"NULL value is not allowed!\00", align 1
@.str.18 = private unnamed_addr constant [38 x i8] c"value && \22NULL value is not allowed!\22\00", align 1
@.str.19 = private unnamed_addr constant [22 x i8] c"index < tbl->capacity\00", align 1
@.str.20 = private unnamed_addr constant [79 x i8] c"tbl->cmp_key(key, (vuintptr_t)vatomicptr_read( &tbl->entries[index].key)) == 0\00", align 1
@.str.21 = private unnamed_addr constant [6 x i8] c"trace\00", align 1
@.str.22 = private unnamed_addr constant [57 x i8] c"/home/drc/git/libvsync/test/include/test/trace_manager.h\00", align 1
@__PRETTY_FUNCTION__.trace_add = private unnamed_addr constant [38 x i8] c"void trace_add(trace_t *, vuintptr_t)\00", align 1
@.str.23 = private unnamed_addr constant [19 x i8] c"trace->initialized\00", align 1
@__PRETTY_FUNCTION__._trace_add_or_rem_occurrences = private unnamed_addr constant [76 x i8] c"void _trace_add_or_rem_occurrences(trace_t *, vuintptr_t, vsize_t, vbool_t)\00", align 1
@.str.24 = private unnamed_addr constant [6 x i8] c"found\00", align 1
@.str.25 = private unnamed_addr constant [33 x i8] c"trace->units[idx].count >= count\00", align 1
@__PRETTY_FUNCTION__.trace_find_unit_idx = private unnamed_addr constant [62 x i8] c"vbool_t trace_find_unit_idx(trace_t *, vuintptr_t, vsize_t *)\00", align 1
@__PRETTY_FUNCTION__.trace_extend = private unnamed_addr constant [29 x i8] c"void trace_extend(trace_t *)\00", align 1
@.str.26 = private unnamed_addr constant [22 x i8] c"0 && \22copying failed\22\00", align 1
@.str.27 = private unnamed_addr constant [25 x i8] c"0 && \22allocation failed\22\00", align 1
@g_rem = internal global [4 x %struct.trace_s] zeroinitializer, align 16, !dbg !173
@__PRETTY_FUNCTION__._vsimpleht_trigger_cleanup = private unnamed_addr constant [55 x i8] c"void _vsimpleht_trigger_cleanup(vsimpleht_t *, void *)\00", align 1
@.str.28 = private unnamed_addr constant [78 x i8] c"since we are inserting what is already in the table, this should never happen\00", align 1
@.str.29 = private unnamed_addr constant [116 x i8] c"ret != VSIMPLEHT_RET_TBL_FULL && \22since we are inserting what is already in the table, \22 \22this should never happen\22\00", align 1
@__PRETTY_FUNCTION__._vsimpleht_cleanup = private unnamed_addr constant [47 x i8] c"void _vsimpleht_cleanup(vsimpleht_t *, void *)\00", align 1
@.str.30 = private unnamed_addr constant [17 x i8] c"data->key == key\00", align 1
@.str.31 = private unnamed_addr constant [55 x i8] c"/home/drc/git/libvsync/test/include/test/map/isimple.h\00", align 1
@__PRETTY_FUNCTION__.imap_get = private unnamed_addr constant [36 x i8] c"void *imap_get(vsize_t, vuintptr_t)\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_get = private unnamed_addr constant [47 x i8] c"void *vsimpleht_get(vsimpleht_t *, vuintptr_t)\00", align 1
@.str.32 = private unnamed_addr constant [13 x i8] c"capacity > 0\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_buff_size = private unnamed_addr constant [37 x i8] c"vsize_t vsimpleht_buff_size(vsize_t)\00", align 1
@.str.33 = private unnamed_addr constant [28 x i8] c"capacity must be power of 2\00", align 1
@.str.34 = private unnamed_addr constant [66 x i8] c"(capacity & (capacity - 1)) == 0 && \22capacity must be power of 2\22\00", align 1
@.str.35 = private unnamed_addr constant [4 x i8] c"tbl\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_init = private unnamed_addr constant [122 x i8] c"void vsimpleht_init(vsimpleht_t *, void *, vsize_t, vsimpleht_cmp_key_t, vsimpleht_hash_key_t, vsimpleht_destroy_entry_t)\00", align 1
@.str.36 = private unnamed_addr constant [5 x i8] c"buff\00", align 1
@.str.37 = private unnamed_addr constant [30 x i8] c"Array size must be power of 2\00", align 1
@.str.38 = private unnamed_addr constant [68 x i8] c"(capacity & (capacity - 1)) == 0 && \22Array size must be power of 2\22\00", align 1
@__PRETTY_FUNCTION__.trace_init = private unnamed_addr constant [36 x i8] c"void trace_init(trace_t *, vsize_t)\00", align 1
@g_buff = internal global i8* null, align 8, !dbg !175
@.str.39 = private unnamed_addr constant [40 x i8] c"the final state is not what is expected\00", align 1
@.str.40 = private unnamed_addr constant [48 x i8] c"eq && \22the final state is not what is expected\22\00", align 1
@__PRETTY_FUNCTION__._imap_verify = private unnamed_addr constant [24 x i8] c"void _imap_verify(void)\00", align 1
@.str.41 = private unnamed_addr constant [16 x i8] c"trace_container\00", align 1
@__PRETTY_FUNCTION__._trace_merge_or_subtract = private unnamed_addr constant [61 x i8] c"void _trace_merge_or_subtract(trace_t *, trace_t *, vbool_t)\00", align 1
@.str.42 = private unnamed_addr constant [29 x i8] c"trace_container->initialized\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_iter_init = private unnamed_addr constant [60 x i8] c"void vsimpleht_iter_init(vsimpleht_t *, vsimpleht_iter_t *)\00", align 1
@.str.43 = private unnamed_addr constant [5 x i8] c"iter\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_iter_next = private unnamed_addr constant [71 x i8] c"vbool_t vsimpleht_iter_next(vsimpleht_iter_t *, vuintptr_t *, void **)\00", align 1
@.str.44 = private unnamed_addr constant [10 x i8] c"iter->tbl\00", align 1
@.str.45 = private unnamed_addr constant [4 x i8] c"key\00", align 1
@.str.46 = private unnamed_addr constant [4 x i8] c"val\00", align 1
@.str.47 = private unnamed_addr constant [8 x i8] c"entries\00", align 1
@.str.48 = private unnamed_addr constant [27 x i8] c"unit_a->key == unit_b->key\00", align 1
@__PRETTY_FUNCTION__.trace_is_subtrace = private unnamed_addr constant [70 x i8] c"vbool_t trace_is_subtrace(trace_t *, trace_t *, void (*)(vuintptr_t))\00", align 1
@.str.49 = private unnamed_addr constant [40 x i8] c"key[%lu] count is different %zu != %zu\0A\00", align 1
@.str.50 = private unnamed_addr constant [20 x i8] c"key[%lu] not found\0A\00", align 1
@__PRETTY_FUNCTION__.trace_destroy = private unnamed_addr constant [30 x i8] c"void trace_destroy(trace_t *)\00", align 1
@__PRETTY_FUNCTION__.vsimpleht_destroy = private unnamed_addr constant [38 x i8] c"void vsimpleht_destroy(vsimpleht_t *)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @pre() #0 !dbg !185 {
  %1 = alloca i64, align 8
  %2 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata i64* %1, metadata !189, metadata !DIExpression()), !dbg !191
  store i64 1, i64* %1, align 8, !dbg !191
  br label %3, !dbg !192

3:                                                ; preds = %16, %0
  %4 = load i64, i64* %1, align 8, !dbg !193
  %5 = icmp ule i64 %4, 4, !dbg !195
  br i1 %5, label %6, label %19, !dbg !196

6:                                                ; preds = %3
  call void @llvm.dbg.declare(metadata i8* %2, metadata !197, metadata !DIExpression()), !dbg !199
  %7 = load i64, i64* %1, align 8, !dbg !200
  %8 = load i64, i64* %1, align 8, !dbg !201
  %9 = call zeroext i1 @imap_add(i64 noundef 3, i64 noundef %7, i64 noundef %8), !dbg !202
  %10 = zext i1 %9 to i8, !dbg !199
  store i8 %10, i8* %2, align 1, !dbg !199
  %11 = load i8, i8* %2, align 1, !dbg !203
  %12 = trunc i8 %11 to i1, !dbg !203
  br i1 %12, label %13, label %14, !dbg !206

13:                                               ; preds = %6
  br label %15, !dbg !206

14:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 22, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.pre, i64 0, i64 0)) #5, !dbg !203
  unreachable, !dbg !203

15:                                               ; preds = %13
  br label %16, !dbg !207

16:                                               ; preds = %15
  %17 = load i64, i64* %1, align 8, !dbg !208
  %18 = add i64 %17, 1, !dbg !208
  store i64 %18, i64* %1, align 8, !dbg !208
  br label %3, !dbg !209, !llvm.loop !210

19:                                               ; preds = %3
  ret void, !dbg !213
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @imap_add(i64 noundef %0, i64 noundef %1, i64 noundef %2) #0 !dbg !214 {
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.data_s*, align 8
  %8 = alloca i8, align 1
  store i64 %0, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !217, metadata !DIExpression()), !dbg !218
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !219, metadata !DIExpression()), !dbg !220
  store i64 %2, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !221, metadata !DIExpression()), !dbg !222
  call void @llvm.dbg.declare(metadata %struct.data_s** %7, metadata !223, metadata !DIExpression()), !dbg !230
  %9 = call noalias i8* @malloc(i64 noundef 16) #6, !dbg !231
  %10 = bitcast i8* %9 to %struct.data_s*, !dbg !231
  store %struct.data_s* %10, %struct.data_s** %7, align 8, !dbg !230
  %11 = load i64, i64* %5, align 8, !dbg !232
  %12 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !233
  %13 = getelementptr inbounds %struct.data_s, %struct.data_s* %12, i32 0, i32 0, !dbg !234
  store i64 %11, i64* %13, align 8, !dbg !235
  %14 = load i64, i64* %6, align 8, !dbg !236
  %15 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !237
  %16 = getelementptr inbounds %struct.data_s, %struct.data_s* %15, i32 0, i32 1, !dbg !238
  store i64 %14, i64* %16, align 8, !dbg !239
  call void @llvm.dbg.declare(metadata i8* %8, metadata !240, metadata !DIExpression()), !dbg !241
  %17 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !242
  %18 = getelementptr inbounds %struct.data_s, %struct.data_s* %17, i32 0, i32 0, !dbg !243
  %19 = load i64, i64* %18, align 8, !dbg !243
  %20 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !244
  %21 = bitcast %struct.data_s* %20 to i8*, !dbg !244
  %22 = call i32 @vsimpleht_add(%struct.vsimpleht_s* noundef @g_simpleht, i64 noundef %19, i8* noundef %21), !dbg !245
  %23 = icmp eq i32 %22, 0, !dbg !246
  %24 = zext i1 %23 to i8, !dbg !241
  store i8 %24, i8* %8, align 1, !dbg !241
  %25 = load i8, i8* %8, align 1, !dbg !247
  %26 = trunc i8 %25 to i1, !dbg !247
  br i1 %26, label %27, label %33, !dbg !249

27:                                               ; preds = %3
  %28 = load i64, i64* %4, align 8, !dbg !250
  %29 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %28, !dbg !252
  %30 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !253
  %31 = getelementptr inbounds %struct.data_s, %struct.data_s* %30, i32 0, i32 0, !dbg !254
  %32 = load i64, i64* %31, align 8, !dbg !254
  call void @trace_add(%struct.trace_s* noundef %29, i64 noundef %32), !dbg !255
  br label %36, !dbg !256

33:                                               ; preds = %3
  %34 = load %struct.data_s*, %struct.data_s** %7, align 8, !dbg !257
  %35 = bitcast %struct.data_s* %34 to i8*, !dbg !257
  call void @free(i8* noundef %35) #6, !dbg !259
  br label %36

36:                                               ; preds = %33, %27
  %37 = load i8, i8* %8, align 1, !dbg !260
  %38 = trunc i8 %37 to i1, !dbg !260
  ret i1 %38, !dbg !261
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @t0(i64 noundef %0) #0 !dbg !262 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !265, metadata !DIExpression()), !dbg !266
  %3 = load i64, i64* %2, align 8, !dbg !267
  %4 = call zeroext i1 @imap_add(i64 noundef %3, i64 noundef 2, i64 noundef 999), !dbg !268
  %5 = zext i1 %4 to i8, !dbg !269
  store i8 %5, i8* @g_added, align 1, !dbg !269
  ret void, !dbg !270
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @t1(i64 noundef %0) #0 !dbg !271 {
  %2 = alloca i64, align 8
  %3 = alloca i8, align 1
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !272, metadata !DIExpression()), !dbg !273
  call void @llvm.dbg.declare(metadata i8* %3, metadata !274, metadata !DIExpression()), !dbg !275
  %4 = load i64, i64* %2, align 8, !dbg !276
  %5 = call zeroext i1 @imap_rem(i64 noundef %4, i64 noundef 2), !dbg !277
  %6 = zext i1 %5 to i8, !dbg !275
  store i8 %6, i8* %3, align 1, !dbg !275
  %7 = load i8, i8* %3, align 1, !dbg !278
  %8 = trunc i8 %7 to i1, !dbg !278
  br i1 %8, label %9, label %10, !dbg !281

9:                                                ; preds = %1
  br label %11, !dbg !281

10:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 34, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.t1, i64 0, i64 0)) #5, !dbg !278
  unreachable, !dbg !278

11:                                               ; preds = %9
  ret void, !dbg !282
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @imap_rem(i64 noundef %0, i64 noundef %1) #0 !dbg !283 {
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i8, align 1
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !286, metadata !DIExpression()), !dbg !287
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !288, metadata !DIExpression()), !dbg !289
  call void @llvm.dbg.declare(metadata i8* %5, metadata !290, metadata !DIExpression()), !dbg !291
  %6 = load i64, i64* %4, align 8, !dbg !292
  %7 = call i32 @vsimpleht_remove(%struct.vsimpleht_s* noundef @g_simpleht, i64 noundef %6), !dbg !293
  %8 = icmp eq i32 %7, 0, !dbg !294
  %9 = zext i1 %8 to i8, !dbg !291
  store i8 %9, i8* %5, align 1, !dbg !291
  %10 = load i8, i8* %5, align 1, !dbg !295
  %11 = trunc i8 %10 to i1, !dbg !295
  br i1 %11, label %12, label %16, !dbg !297

12:                                               ; preds = %2
  %13 = load i64, i64* %3, align 8, !dbg !298
  %14 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_rem, i64 0, i64 %13, !dbg !300
  %15 = load i64, i64* %4, align 8, !dbg !301
  call void @trace_add(%struct.trace_s* noundef %14, i64 noundef %15), !dbg !302
  br label %16, !dbg !303

16:                                               ; preds = %12, %2
  %17 = load i8, i8* %5, align 1, !dbg !304
  %18 = trunc i8 %17 to i1, !dbg !304
  ret i1 %18, !dbg !305
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @t2(i64 noundef %0) #0 !dbg !306 {
  %2 = alloca i64, align 8
  %3 = alloca %struct.data_s*, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !307, metadata !DIExpression()), !dbg !308
  call void @llvm.dbg.declare(metadata %struct.data_s** %3, metadata !309, metadata !DIExpression()), !dbg !310
  %4 = load i64, i64* %2, align 8, !dbg !311
  %5 = call i8* @imap_get(i64 noundef %4, i64 noundef 2), !dbg !312
  %6 = bitcast i8* %5 to %struct.data_s*, !dbg !312
  store %struct.data_s* %6, %struct.data_s** %3, align 8, !dbg !310
  %7 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !313
  %8 = icmp ne %struct.data_s* %7, null, !dbg !313
  br i1 %8, label %9, label %16, !dbg !315

9:                                                ; preds = %1
  %10 = load %struct.data_s*, %struct.data_s** %3, align 8, !dbg !316
  %11 = getelementptr inbounds %struct.data_s, %struct.data_s* %10, i32 0, i32 1, !dbg !319
  %12 = load i64, i64* %11, align 8, !dbg !319
  %13 = icmp eq i64 %12, 999, !dbg !320
  br i1 %13, label %14, label %15, !dbg !321

14:                                               ; preds = %9
  store i8 1, i8* @g_got_nw_val, align 1, !dbg !322
  br label %15, !dbg !324

15:                                               ; preds = %14, %9
  br label %16, !dbg !325

16:                                               ; preds = %15, %1
  ret void, !dbg !326
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @imap_get(i64 noundef %0, i64 noundef %1) #0 !dbg !327 {
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca %struct.data_s*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !330, metadata !DIExpression()), !dbg !331
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !332, metadata !DIExpression()), !dbg !333
  br label %6, !dbg !334

6:                                                ; preds = %2
  br label %7, !dbg !335

7:                                                ; preds = %6
  %8 = load i64, i64* %3, align 8, !dbg !337
  br label %9, !dbg !337

9:                                                ; preds = %7
  br label %10, !dbg !339

10:                                               ; preds = %9
  br label %11, !dbg !337

11:                                               ; preds = %10
  br label %12, !dbg !335

12:                                               ; preds = %11
  call void @llvm.dbg.declare(metadata %struct.data_s** %5, metadata !341, metadata !DIExpression()), !dbg !342
  %13 = load i64, i64* %4, align 8, !dbg !343
  %14 = call i8* @vsimpleht_get(%struct.vsimpleht_s* noundef @g_simpleht, i64 noundef %13), !dbg !344
  %15 = bitcast i8* %14 to %struct.data_s*, !dbg !344
  store %struct.data_s* %15, %struct.data_s** %5, align 8, !dbg !342
  %16 = load %struct.data_s*, %struct.data_s** %5, align 8, !dbg !345
  %17 = icmp ne %struct.data_s* %16, null, !dbg !345
  br i1 %17, label %18, label %27, !dbg !347

18:                                               ; preds = %12
  %19 = load %struct.data_s*, %struct.data_s** %5, align 8, !dbg !348
  %20 = getelementptr inbounds %struct.data_s, %struct.data_s* %19, i32 0, i32 0, !dbg !348
  %21 = load i64, i64* %20, align 8, !dbg !348
  %22 = load i64, i64* %4, align 8, !dbg !348
  %23 = icmp eq i64 %21, %22, !dbg !348
  br i1 %23, label %24, label %25, !dbg !352

24:                                               ; preds = %18
  br label %26, !dbg !352

25:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.30, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.31, i64 0, i64 0), i32 noundef 171, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.imap_get, i64 0, i64 0)) #5, !dbg !348
  unreachable, !dbg !348

26:                                               ; preds = %24
  br label %27, !dbg !353

27:                                               ; preds = %26, %12
  %28 = load %struct.data_s*, %struct.data_s** %5, align 8, !dbg !354
  %29 = bitcast %struct.data_s* %28 to i8*, !dbg !354
  ret i8* %29, !dbg !355
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !356 {
  %1 = alloca i64, align 8
  %2 = alloca %struct.data_s*, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !357, metadata !DIExpression()), !dbg !359
  store i64 1, i64* %1, align 8, !dbg !359
  br label %3, !dbg !360

3:                                                ; preds = %49, %0
  %4 = load i64, i64* %1, align 8, !dbg !361
  %5 = icmp ule i64 %4, 4, !dbg !363
  br i1 %5, label %6, label %52, !dbg !364

6:                                                ; preds = %3
  call void @llvm.dbg.declare(metadata %struct.data_s** %2, metadata !365, metadata !DIExpression()), !dbg !367
  %7 = load i64, i64* %1, align 8, !dbg !368
  %8 = call i8* @imap_get(i64 noundef 3, i64 noundef %7), !dbg !369
  %9 = bitcast i8* %8 to %struct.data_s*, !dbg !369
  store %struct.data_s* %9, %struct.data_s** %2, align 8, !dbg !367
  %10 = load i64, i64* %1, align 8, !dbg !370
  %11 = icmp eq i64 %10, 2, !dbg !372
  br i1 %11, label %12, label %42, !dbg !373

12:                                               ; preds = %6
  %13 = load i8, i8* @g_added, align 1, !dbg !374
  %14 = trunc i8 %13 to i1, !dbg !374
  br i1 %14, label %15, label %28, !dbg !377

15:                                               ; preds = %12
  %16 = load %struct.data_s*, %struct.data_s** %2, align 8, !dbg !378
  %17 = icmp ne %struct.data_s* %16, null, !dbg !378
  br i1 %17, label %18, label %19, !dbg !382

18:                                               ; preds = %15
  br label %20, !dbg !382

19:                                               ; preds = %15
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 53, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.post, i64 0, i64 0)) #5, !dbg !378
  unreachable, !dbg !378

20:                                               ; preds = %18
  %21 = load %struct.data_s*, %struct.data_s** %2, align 8, !dbg !383
  %22 = getelementptr inbounds %struct.data_s, %struct.data_s* %21, i32 0, i32 1, !dbg !383
  %23 = load i64, i64* %22, align 8, !dbg !383
  %24 = icmp eq i64 %23, 999, !dbg !383
  br i1 %24, label %25, label %26, !dbg !386

25:                                               ; preds = %20
  br label %27, !dbg !386

26:                                               ; preds = %20
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 54, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.post, i64 0, i64 0)) #5, !dbg !383
  unreachable, !dbg !383

27:                                               ; preds = %25
  br label %41, !dbg !387

28:                                               ; preds = %12
  %29 = load %struct.data_s*, %struct.data_s** %2, align 8, !dbg !388
  %30 = icmp ne %struct.data_s* %29, null, !dbg !388
  br i1 %30, label %31, label %40, !dbg !390

31:                                               ; preds = %28
  %32 = load %struct.data_s*, %struct.data_s** %2, align 8, !dbg !391
  %33 = getelementptr inbounds %struct.data_s, %struct.data_s* %32, i32 0, i32 1, !dbg !391
  %34 = load i64, i64* %33, align 8, !dbg !391
  %35 = load i64, i64* %1, align 8, !dbg !391
  %36 = icmp eq i64 %34, %35, !dbg !391
  br i1 %36, label %37, label %38, !dbg !395

37:                                               ; preds = %31
  br label %39, !dbg !395

38:                                               ; preds = %31
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 56, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.post, i64 0, i64 0)) #5, !dbg !391
  unreachable, !dbg !391

39:                                               ; preds = %37
  br label %40, !dbg !396

40:                                               ; preds = %39, %28
  br label %41

41:                                               ; preds = %40, %27
  br label %48, !dbg !397

42:                                               ; preds = %6
  %43 = load %struct.data_s*, %struct.data_s** %2, align 8, !dbg !398
  %44 = icmp ne %struct.data_s* %43, null, !dbg !398
  br i1 %44, label %45, label %46, !dbg !402

45:                                               ; preds = %42
  br label %47, !dbg !402

46:                                               ; preds = %42
  call void @__assert_fail(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 59, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.post, i64 0, i64 0)) #5, !dbg !398
  unreachable, !dbg !398

47:                                               ; preds = %45
  br label %48

48:                                               ; preds = %47, %41
  br label %49, !dbg !403

49:                                               ; preds = %48
  %50 = load i64, i64* %1, align 8, !dbg !404
  %51 = add i64 %50, 1, !dbg !404
  store i64 %51, i64* %1, align 8, !dbg !404
  br label %3, !dbg !405, !llvm.loop !406

52:                                               ; preds = %3
  %53 = load i8, i8* @g_got_nw_val, align 1, !dbg !408
  %54 = trunc i8 %53 to i1, !dbg !408
  br i1 %54, label %55, label %61, !dbg !410

55:                                               ; preds = %52
  %56 = load i8, i8* @g_added, align 1, !dbg !411
  %57 = trunc i8 %56 to i1, !dbg !411
  br i1 %57, label %58, label %59, !dbg !415

58:                                               ; preds = %55
  br label %60, !dbg !415

59:                                               ; preds = %55
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([63 x i8], [63 x i8]* @.str.1, i64 0, i64 0), i32 noundef 63, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.post, i64 0, i64 0)) #5, !dbg !411
  unreachable, !dbg !411

60:                                               ; preds = %58
  br label %61, !dbg !416

61:                                               ; preds = %60, %52
  ret void, !dbg !417
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !418 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !420, metadata !DIExpression()), !dbg !421
  call void @llvm.dbg.declare(metadata i64* %3, metadata !422, metadata !DIExpression()), !dbg !423
  %4 = load i8*, i8** %2, align 8, !dbg !424
  %5 = ptrtoint i8* %4 to i64, !dbg !425
  store i64 %5, i64* %3, align 8, !dbg !423
  %6 = load i64, i64* %3, align 8, !dbg !426
  %7 = icmp ult i64 %6, 3, !dbg !426
  br i1 %7, label %8, label %9, !dbg !429

8:                                                ; preds = %1
  br label %10, !dbg !429

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @.str.7, i64 0, i64 0), i32 noundef 97, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !426
  unreachable, !dbg !426

10:                                               ; preds = %8
  %11 = load i64, i64* %3, align 8, !dbg !430
  call void @reg(i64 noundef %11), !dbg !431
  %12 = load i64, i64* %3, align 8, !dbg !432
  switch i64 %12, label %19 [
    i64 0, label %13
    i64 1, label %15
    i64 2, label %17
  ], !dbg !433

13:                                               ; preds = %10
  %14 = load i64, i64* %3, align 8, !dbg !434
  call void @t0(i64 noundef %14), !dbg !436
  br label %20, !dbg !437

15:                                               ; preds = %10
  %16 = load i64, i64* %3, align 8, !dbg !438
  call void @t1(i64 noundef %16), !dbg !439
  br label %20, !dbg !440

17:                                               ; preds = %10
  %18 = load i64, i64* %3, align 8, !dbg !441
  call void @t2(i64 noundef %18), !dbg !442
  br label %20, !dbg !443

19:                                               ; preds = %10
  br label %20, !dbg !444

20:                                               ; preds = %19, %17, %15, %13
  %21 = load i64, i64* %3, align 8, !dbg !445
  call void @dereg(i64 noundef %21), !dbg !446
  ret i8* null, !dbg !447
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reg(i64 noundef %0) #0 !dbg !448 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !450, metadata !DIExpression()), !dbg !451
  %3 = load i64, i64* %2, align 8, !dbg !452
  call void @imap_reg(i64 noundef %3), !dbg !453
  ret void, !dbg !454
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @dereg(i64 noundef %0) #0 !dbg !455 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !456, metadata !DIExpression()), !dbg !457
  %3 = load i64, i64* %2, align 8, !dbg !458
  call void @imap_dereg(i64 noundef %3), !dbg !459
  ret void, !dbg !460
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @tc() #0 !dbg !461 {
  call void @init(), !dbg !462
  call void @pre(), !dbg !463
  call void @launch_threads(i64 noundef 3, i8* (i8*)* noundef @run), !dbg !464
  call void @post(), !dbg !465
  call void @fini(), !dbg !466
  ret void, !dbg !467
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !468 {
  call void @imap_init(), !dbg !469
  ret void, !dbg !470
}

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !471 {
  %3 = alloca i64, align 8
  %4 = alloca i8* (i8*)*, align 8
  %5 = alloca %struct.run_info_t*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !474, metadata !DIExpression()), !dbg !475
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %4, metadata !476, metadata !DIExpression()), !dbg !477
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !478, metadata !DIExpression()), !dbg !479
  %6 = load i64, i64* %3, align 8, !dbg !480
  %7 = mul i64 32, %6, !dbg !481
  %8 = call noalias i8* @malloc(i64 noundef %7) #6, !dbg !482
  %9 = bitcast i8* %8 to %struct.run_info_t*, !dbg !482
  store %struct.run_info_t* %9, %struct.run_info_t** %5, align 8, !dbg !479
  %10 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !483
  %11 = load i64, i64* %3, align 8, !dbg !484
  %12 = load i8* (i8*)*, i8* (i8*)** %4, align 8, !dbg !485
  call void @create_threads(%struct.run_info_t* noundef %10, i64 noundef %11, i8* (i8*)* noundef %12, i1 noundef zeroext true), !dbg !486
  %13 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !487
  %14 = load i64, i64* %3, align 8, !dbg !488
  call void @await_threads(%struct.run_info_t* noundef %13, i64 noundef %14), !dbg !489
  %15 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !490
  %16 = bitcast %struct.run_info_t* %15 to i8*, !dbg !490
  call void @free(i8* noundef %16) #6, !dbg !491
  ret void, !dbg !492
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !493 {
  call void @imap_destroy(), !dbg !494
  ret void, !dbg !495
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_reg(i64 noundef %0) #0 !dbg !496 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !497, metadata !DIExpression()), !dbg !498
  br label %3, !dbg !499

3:                                                ; preds = %1
  br label %4, !dbg !500

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !502
  br label %6, !dbg !502

6:                                                ; preds = %4
  br label %7, !dbg !504

7:                                                ; preds = %6
  br label %8, !dbg !502

8:                                                ; preds = %7
  br label %9, !dbg !500

9:                                                ; preds = %8
  call void @vsimpleht_thread_register(%struct.vsimpleht_s* noundef @g_simpleht), !dbg !506
  ret void, !dbg !507
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_dereg(i64 noundef %0) #0 !dbg !508 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !509, metadata !DIExpression()), !dbg !510
  br label %3, !dbg !511

3:                                                ; preds = %1
  br label %4, !dbg !512

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !514
  br label %6, !dbg !514

6:                                                ; preds = %4
  br label %7, !dbg !516

7:                                                ; preds = %6
  br label %8, !dbg !514

8:                                                ; preds = %7
  br label %9, !dbg !512

9:                                                ; preds = %8
  call void @vsimpleht_thread_deregister(%struct.vsimpleht_s* noundef @g_simpleht), !dbg !518
  ret void, !dbg !519
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_init() #0 !dbg !520 {
  %1 = alloca i64, align 8
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.declare(metadata i64* %1, metadata !521, metadata !DIExpression()), !dbg !522
  %4 = call i64 @vsimpleht_buff_size(i64 noundef 4), !dbg !523
  store i64 %4, i64* %1, align 8, !dbg !522
  call void @llvm.dbg.declare(metadata i8** %2, metadata !524, metadata !DIExpression()), !dbg !525
  %5 = load i64, i64* %1, align 8, !dbg !526
  %6 = call noalias i8* @malloc(i64 noundef %5) #6, !dbg !527
  store i8* %6, i8** %2, align 8, !dbg !525
  %7 = load i8*, i8** %2, align 8, !dbg !528
  call void @vsimpleht_init(%struct.vsimpleht_s* noundef @g_simpleht, i8* noundef %7, i64 noundef 4, i8 (i64, i64)* noundef @cb_cmp, i64 (i64)* noundef @cb_hash, void (i8*)* noundef @cb_destroy), !dbg !529
  call void @llvm.dbg.declare(metadata i64* %3, metadata !530, metadata !DIExpression()), !dbg !532
  store i64 0, i64* %3, align 8, !dbg !532
  br label %8, !dbg !533

8:                                                ; preds = %16, %0
  %9 = load i64, i64* %3, align 8, !dbg !534
  %10 = icmp ult i64 %9, 4, !dbg !536
  br i1 %10, label %11, label %19, !dbg !537

11:                                               ; preds = %8
  %12 = load i64, i64* %3, align 8, !dbg !538
  %13 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %12, !dbg !540
  call void @trace_init(%struct.trace_s* noundef %13, i64 noundef 8), !dbg !541
  %14 = load i64, i64* %3, align 8, !dbg !542
  %15 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_rem, i64 0, i64 %14, !dbg !543
  call void @trace_init(%struct.trace_s* noundef %15, i64 noundef 8), !dbg !544
  br label %16, !dbg !545

16:                                               ; preds = %11
  %17 = load i64, i64* %3, align 8, !dbg !546
  %18 = add i64 %17, 1, !dbg !546
  store i64 %18, i64* %3, align 8, !dbg !546
  br label %8, !dbg !547, !llvm.loop !548

19:                                               ; preds = %8
  ret void, !dbg !550
}

; Function Attrs: noinline nounwind uwtable
define internal void @imap_destroy() #0 !dbg !551 {
  %1 = alloca i64, align 8
  call void @_imap_verify(), !dbg !552
  call void @llvm.dbg.declare(metadata i64* %1, metadata !553, metadata !DIExpression()), !dbg !555
  store i64 0, i64* %1, align 8, !dbg !555
  br label %2, !dbg !556

2:                                                ; preds = %10, %0
  %3 = load i64, i64* %1, align 8, !dbg !557
  %4 = icmp ult i64 %3, 4, !dbg !559
  br i1 %4, label %5, label %13, !dbg !560

5:                                                ; preds = %2
  %6 = load i64, i64* %1, align 8, !dbg !561
  %7 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %6, !dbg !563
  call void @trace_destroy(%struct.trace_s* noundef %7), !dbg !564
  %8 = load i64, i64* %1, align 8, !dbg !565
  %9 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_rem, i64 0, i64 %8, !dbg !566
  call void @trace_destroy(%struct.trace_s* noundef %9), !dbg !567
  br label %10, !dbg !568

10:                                               ; preds = %5
  %11 = load i64, i64* %1, align 8, !dbg !569
  %12 = add i64 %11, 1, !dbg !569
  store i64 %12, i64* %1, align 8, !dbg !569
  br label %2, !dbg !570, !llvm.loop !571

13:                                               ; preds = %2
  call void @vsimpleht_destroy(%struct.vsimpleht_s* noundef @g_simpleht), !dbg !573
  %14 = load i8*, i8** @g_buff, align 8, !dbg !574
  call void @free(i8* noundef %14) #6, !dbg !575
  store i8* null, i8** @g_buff, align 8, !dbg !576
  ret void, !dbg !577
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !578 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @tc(), !dbg !581
  ret i32 0, !dbg !582
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i32 @vsimpleht_add(%struct.vsimpleht_s* noundef %0, i64 noundef %1, i8* noundef %2) #0 !dbg !583 {
  %4 = alloca %struct.vsimpleht_s*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i8*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %4, metadata !588, metadata !DIExpression()), !dbg !589
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !590, metadata !DIExpression()), !dbg !591
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !592, metadata !DIExpression()), !dbg !593
  %7 = load i64, i64* %5, align 8, !dbg !594
  %8 = icmp ne i64 %7, 0, !dbg !594
  br i1 %8, label %9, label %10, !dbg !597

9:                                                ; preds = %3
  br label %11, !dbg !597

10:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.8, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 243, i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @__PRETTY_FUNCTION__.vsimpleht_add, i64 0, i64 0)) #5, !dbg !594
  unreachable, !dbg !594

11:                                               ; preds = %9
  %12 = load i8*, i8** %6, align 8, !dbg !598
  %13 = icmp ne i8* %12, null, !dbg !598
  br i1 %13, label %14, label %15, !dbg !601

14:                                               ; preds = %11
  br label %16, !dbg !601

15:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.10, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 244, i8* noundef getelementptr inbounds ([65 x i8], [65 x i8]* @__PRETTY_FUNCTION__.vsimpleht_add, i64 0, i64 0)) #5, !dbg !598
  unreachable, !dbg !598

16:                                               ; preds = %14
  %17 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !602
  call void @_vsimpleht_give_cleanup_a_chance(%struct.vsimpleht_s* noundef %17), !dbg !603
  %18 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !604
  %19 = load i64, i64* %5, align 8, !dbg !605
  %20 = load i8*, i8** %6, align 8, !dbg !606
  %21 = call i32 @_vsimpleht_add(%struct.vsimpleht_s* noundef %18, i64 noundef %19, i8* noundef %20), !dbg !607
  ret i32 %21, !dbg !608
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_add(%struct.trace_s* noundef %0, i64 noundef %1) #0 !dbg !609 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !613, metadata !DIExpression()), !dbg !614
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !615, metadata !DIExpression()), !dbg !616
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !617
  %6 = icmp ne %struct.trace_s* %5, null, !dbg !617
  br i1 %6, label %7, label %8, !dbg !620

7:                                                ; preds = %2
  br label %9, !dbg !620

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 155, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__.trace_add, i64 0, i64 0)) #5, !dbg !617
  unreachable, !dbg !617

9:                                                ; preds = %7
  %10 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !621
  %11 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %10, i32 0, i32 3, !dbg !621
  %12 = load i8, i8* %11, align 8, !dbg !621
  %13 = trunc i8 %12 to i1, !dbg !621
  br i1 %13, label %14, label %15, !dbg !624

14:                                               ; preds = %9
  br label %16, !dbg !624

15:                                               ; preds = %9
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.23, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 156, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__.trace_add, i64 0, i64 0)) #5, !dbg !621
  unreachable, !dbg !621

16:                                               ; preds = %14
  %17 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !625
  %18 = load i64, i64* %4, align 8, !dbg !626
  call void @_trace_add_or_rem_occurrences(%struct.trace_s* noundef %17, i64 noundef %18, i64 noundef 1, i1 noundef zeroext false), !dbg !627
  ret void, !dbg !628
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @_vsimpleht_give_cleanup_a_chance(%struct.vsimpleht_s* noundef %0) #0 !dbg !629 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !632, metadata !DIExpression()), !dbg !633
  %3 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !634
  %4 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %3, i32 0, i32 7, !dbg !636
  %5 = call zeroext i1 @rwlock_acquired_by_writer(%struct.rwlock_s* noundef %4), !dbg !637
  br i1 %5, label %6, label %18, !dbg !638

6:                                                ; preds = %1
  %7 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !639
  %8 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %7, i32 0, i32 7, !dbg !639
  %9 = call zeroext i1 @rwlock_acquired_by_readers(%struct.rwlock_s* noundef %8), !dbg !639
  br i1 %9, label %10, label %12, !dbg !639

10:                                               ; preds = %6
  br i1 true, label %11, label %12, !dbg !643

11:                                               ; preds = %10
  br label %13, !dbg !643

12:                                               ; preds = %10, %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([112 x i8], [112 x i8]* @.str.12, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 487, i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @__PRETTY_FUNCTION__._vsimpleht_give_cleanup_a_chance, i64 0, i64 0)) #5, !dbg !639
  unreachable, !dbg !639

13:                                               ; preds = %11
  %14 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !644
  %15 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %14, i32 0, i32 7, !dbg !645
  call void @rwlock_read_release(%struct.rwlock_s* noundef %15), !dbg !646
  %16 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !647
  %17 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %16, i32 0, i32 7, !dbg !648
  call void @rwlock_read_acquire(%struct.rwlock_s* noundef %17), !dbg !649
  br label %18, !dbg !650

18:                                               ; preds = %13, %1
  ret void, !dbg !651
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @_vsimpleht_add(%struct.vsimpleht_s* noundef %0, i64 noundef %1, i8* noundef %2) #0 !dbg !652 {
  %4 = alloca i32, align 4
  %5 = alloca %struct.vsimpleht_s*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca i8*, align 8
  %11 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %5, metadata !653, metadata !DIExpression()), !dbg !654
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !655, metadata !DIExpression()), !dbg !656
  store i8* %2, i8** %7, align 8
  call void @llvm.dbg.declare(metadata i8** %7, metadata !657, metadata !DIExpression()), !dbg !658
  call void @llvm.dbg.declare(metadata i64* %8, metadata !659, metadata !DIExpression()), !dbg !660
  store i64 0, i64* %8, align 8, !dbg !660
  call void @llvm.dbg.declare(metadata i64* %9, metadata !661, metadata !DIExpression()), !dbg !662
  store i64 0, i64* %9, align 8, !dbg !662
  call void @llvm.dbg.declare(metadata i8** %10, metadata !663, metadata !DIExpression()), !dbg !664
  store i8* null, i8** %10, align 8, !dbg !664
  call void @llvm.dbg.declare(metadata i64* %11, metadata !665, metadata !DIExpression()), !dbg !666
  store i64 0, i64* %11, align 8, !dbg !666
  %12 = load i64, i64* %6, align 8, !dbg !667
  %13 = icmp ne i64 %12, 0, !dbg !667
  br i1 %13, label %14, label %16, !dbg !667

14:                                               ; preds = %3
  br i1 true, label %15, label %16, !dbg !670

15:                                               ; preds = %14
  br label %17, !dbg !670

16:                                               ; preds = %14, %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @.str.16, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 423, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !667
  unreachable, !dbg !667

17:                                               ; preds = %15
  %18 = load i8*, i8** %7, align 8, !dbg !671
  %19 = icmp ne i8* %18, null, !dbg !671
  br i1 %19, label %20, label %22, !dbg !671

20:                                               ; preds = %17
  br i1 true, label %21, label %22, !dbg !674

21:                                               ; preds = %20
  br label %23, !dbg !674

22:                                               ; preds = %20, %17
  call void @__assert_fail(i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @.str.18, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 424, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !671
  unreachable, !dbg !671

23:                                               ; preds = %21
  %24 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !675
  %25 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %24, i32 0, i32 3, !dbg !677
  %26 = load i64 (i64)*, i64 (i64)** %25, align 8, !dbg !677
  %27 = load i64, i64* %6, align 8, !dbg !678
  %28 = call i64 %26(i64 noundef %27), !dbg !675
  store i64 %28, i64* %8, align 8, !dbg !679
  br label %29, !dbg !680

29:                                               ; preds = %126, %23
  %30 = load i64, i64* %11, align 8, !dbg !681
  %31 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !683
  %32 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %31, i32 0, i32 0, !dbg !684
  %33 = load i64, i64* %32, align 8, !dbg !684
  %34 = icmp ult i64 %30, %33, !dbg !685
  br i1 %34, label %35, label %131, !dbg !686

35:                                               ; preds = %29
  %36 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !687
  %37 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %36, i32 0, i32 0, !dbg !689
  %38 = load i64, i64* %37, align 8, !dbg !689
  %39 = sub i64 %38, 1, !dbg !690
  %40 = load i64, i64* %8, align 8, !dbg !691
  %41 = and i64 %40, %39, !dbg !691
  store i64 %41, i64* %8, align 8, !dbg !691
  %42 = load i64, i64* %8, align 8, !dbg !692
  %43 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !692
  %44 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %43, i32 0, i32 0, !dbg !692
  %45 = load i64, i64* %44, align 8, !dbg !692
  %46 = icmp ult i64 %42, %45, !dbg !692
  br i1 %46, label %47, label %48, !dbg !695

47:                                               ; preds = %35
  br label %49, !dbg !695

48:                                               ; preds = %35
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 431, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !692
  unreachable, !dbg !692

49:                                               ; preds = %47
  %50 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !696
  %51 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %50, i32 0, i32 1, !dbg !697
  %52 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %51, align 8, !dbg !697
  %53 = load i64, i64* %8, align 8, !dbg !698
  %54 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %52, i64 %53, !dbg !696
  %55 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %54, i32 0, i32 0, !dbg !699
  %56 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %55), !dbg !700
  %57 = ptrtoint i8* %56 to i64, !dbg !701
  store i64 %57, i64* %9, align 8, !dbg !702
  %58 = load i64, i64* %9, align 8, !dbg !703
  %59 = icmp eq i64 %58, 0, !dbg !705
  br i1 %59, label %60, label %84, !dbg !706

60:                                               ; preds = %49
  %61 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !707
  %62 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %61, i32 0, i32 1, !dbg !709
  %63 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %62, align 8, !dbg !709
  %64 = load i64, i64* %8, align 8, !dbg !710
  %65 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %63, i64 %64, !dbg !707
  %66 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %65, i32 0, i32 0, !dbg !711
  %67 = load i64, i64* %6, align 8, !dbg !712
  %68 = inttoptr i64 %67 to i8*, !dbg !713
  %69 = call i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %66, i8* noundef null, i8* noundef %68), !dbg !714
  %70 = ptrtoint i8* %69 to i64, !dbg !715
  store i64 %70, i64* %9, align 8, !dbg !716
  %71 = load i64, i64* %9, align 8, !dbg !717
  %72 = icmp ne i64 %71, 0, !dbg !719
  br i1 %72, label %73, label %83, !dbg !720

73:                                               ; preds = %60
  %74 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !721
  %75 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %74, i32 0, i32 2, !dbg !722
  %76 = load i8 (i64, i64)*, i8 (i64, i64)** %75, align 8, !dbg !722
  %77 = load i64, i64* %6, align 8, !dbg !723
  %78 = load i64, i64* %9, align 8, !dbg !724
  %79 = call signext i8 %76(i64 noundef %77, i64 noundef %78), !dbg !721
  %80 = sext i8 %79 to i32, !dbg !721
  %81 = icmp ne i32 %80, 0, !dbg !725
  br i1 %81, label %82, label %83, !dbg !726

82:                                               ; preds = %73
  br label %126, !dbg !727

83:                                               ; preds = %73, %60
  br label %95, !dbg !729

84:                                               ; preds = %49
  %85 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !730
  %86 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %85, i32 0, i32 2, !dbg !732
  %87 = load i8 (i64, i64)*, i8 (i64, i64)** %86, align 8, !dbg !732
  %88 = load i64, i64* %6, align 8, !dbg !733
  %89 = load i64, i64* %9, align 8, !dbg !734
  %90 = call signext i8 %87(i64 noundef %88, i64 noundef %89), !dbg !730
  %91 = sext i8 %90 to i32, !dbg !730
  %92 = icmp ne i32 %91, 0, !dbg !735
  br i1 %92, label %93, label %94, !dbg !736

93:                                               ; preds = %84
  br label %126, !dbg !737

94:                                               ; preds = %84
  br label %95

95:                                               ; preds = %94, %83
  %96 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !739
  %97 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %96, i32 0, i32 2, !dbg !739
  %98 = load i8 (i64, i64)*, i8 (i64, i64)** %97, align 8, !dbg !739
  %99 = load i64, i64* %6, align 8, !dbg !739
  %100 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !739
  %101 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %100, i32 0, i32 1, !dbg !739
  %102 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %101, align 8, !dbg !739
  %103 = load i64, i64* %8, align 8, !dbg !739
  %104 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %102, i64 %103, !dbg !739
  %105 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %104, i32 0, i32 0, !dbg !739
  %106 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %105), !dbg !739
  %107 = ptrtoint i8* %106 to i64, !dbg !739
  %108 = call signext i8 %98(i64 noundef %99, i64 noundef %107), !dbg !739
  %109 = sext i8 %108 to i32, !dbg !739
  %110 = icmp eq i32 %109, 0, !dbg !739
  br i1 %110, label %111, label %112, !dbg !742

111:                                              ; preds = %95
  br label %113, !dbg !742

112:                                              ; preds = %95
  call void @__assert_fail(i8* noundef getelementptr inbounds ([79 x i8], [79 x i8]* @.str.20, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 451, i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @__PRETTY_FUNCTION__._vsimpleht_add, i64 0, i64 0)) #5, !dbg !739
  unreachable, !dbg !739

113:                                              ; preds = %111
  %114 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %5, align 8, !dbg !743
  %115 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %114, i32 0, i32 1, !dbg !744
  %116 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %115, align 8, !dbg !744
  %117 = load i64, i64* %8, align 8, !dbg !745
  %118 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %116, i64 %117, !dbg !743
  %119 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %118, i32 0, i32 1, !dbg !746
  %120 = load i8*, i8** %7, align 8, !dbg !747
  %121 = call i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %119, i8* noundef null, i8* noundef %120), !dbg !748
  store i8* %121, i8** %10, align 8, !dbg !749
  %122 = load i8*, i8** %10, align 8, !dbg !750
  %123 = icmp eq i8* %122, null, !dbg !751
  %124 = zext i1 %123 to i64, !dbg !752
  %125 = select i1 %123, i32 0, i32 2, !dbg !752
  store i32 %125, i32* %4, align 4, !dbg !753
  br label %132, !dbg !753

126:                                              ; preds = %93, %82
  %127 = load i64, i64* %11, align 8, !dbg !754
  %128 = add i64 %127, 1, !dbg !754
  store i64 %128, i64* %11, align 8, !dbg !754
  %129 = load i64, i64* %8, align 8, !dbg !755
  %130 = add i64 %129, 1, !dbg !755
  store i64 %130, i64* %8, align 8, !dbg !755
  br label %29, !dbg !756, !llvm.loop !757

131:                                              ; preds = %29
  store i32 1, i32* %4, align 4, !dbg !759
  br label %132, !dbg !759

132:                                              ; preds = %131, %113
  %133 = load i32, i32* %4, align 4, !dbg !760
  ret i32 %133, !dbg !760
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @rwlock_acquired_by_writer(%struct.rwlock_s* noundef %0) #0 !dbg !761 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !765, metadata !DIExpression()), !dbg !766
  %3 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !767
  %4 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %3, i32 0, i32 1, !dbg !768
  %5 = call zeroext i8 @vatomic8_read_rlx(%struct.vatomic8_s* noundef %4), !dbg !769
  %6 = zext i8 %5 to i32, !dbg !769
  %7 = icmp eq i32 %6, 1, !dbg !770
  ret i1 %7, !dbg !771
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @rwlock_acquired_by_readers(%struct.rwlock_s* noundef %0) #0 !dbg !772 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !773, metadata !DIExpression()), !dbg !774
  br label %3, !dbg !775

3:                                                ; preds = %1
  br label %4, !dbg !776

4:                                                ; preds = %3
  %5 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !778
  br label %6, !dbg !778

6:                                                ; preds = %4
  br label %7, !dbg !780

7:                                                ; preds = %6
  br label %8, !dbg !778

8:                                                ; preds = %7
  br label %9, !dbg !776

9:                                                ; preds = %8
  ret i1 true, !dbg !782
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_read_release(%struct.rwlock_s* noundef %0) #0 !dbg !783 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !786, metadata !DIExpression()), !dbg !787
  call void @llvm.dbg.declare(metadata i32* %3, metadata !788, metadata !DIExpression()), !dbg !789
  %4 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !790
  %5 = call i32 @_rwlock_get_tid(%struct.rwlock_s* noundef %4), !dbg !791
  store i32 %5, i32* %3, align 4, !dbg !789
  %6 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !792
  %7 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %6, i32 0, i32 0, !dbg !793
  %8 = load i32, i32* %3, align 4, !dbg !794
  %9 = zext i32 %8 to i64, !dbg !792
  %10 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %7, i64 0, i64 %9, !dbg !792
  %11 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef %10) #6, !dbg !795
  ret void, !dbg !796
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_read_acquire(%struct.rwlock_s* noundef %0) #0 !dbg !797 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !798, metadata !DIExpression()), !dbg !799
  call void @llvm.dbg.declare(metadata i32* %3, metadata !800, metadata !DIExpression()), !dbg !801
  %4 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !802
  %5 = call i32 @_rwlock_get_tid(%struct.rwlock_s* noundef %4), !dbg !803
  store i32 %5, i32* %3, align 4, !dbg !801
  %6 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !804
  %7 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %6, i32 0, i32 0, !dbg !805
  %8 = load i32, i32* %3, align 4, !dbg !806
  %9 = zext i32 %8 to i64, !dbg !804
  %10 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %7, i64 0, i64 %9, !dbg !804
  %11 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef %10) #6, !dbg !807
  ret void, !dbg !808
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i8 @vatomic8_read_rlx(%struct.vatomic8_s* noundef %0) #0 !dbg !809 {
  %2 = alloca %struct.vatomic8_s*, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  store %struct.vatomic8_s* %0, %struct.vatomic8_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic8_s** %2, metadata !815, metadata !DIExpression()), !dbg !816
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !817, !srcloc !818
  call void @llvm.dbg.declare(metadata i8* %3, metadata !819, metadata !DIExpression()), !dbg !820
  %5 = load %struct.vatomic8_s*, %struct.vatomic8_s** %2, align 8, !dbg !821
  %6 = getelementptr inbounds %struct.vatomic8_s, %struct.vatomic8_s* %5, i32 0, i32 0, !dbg !822
  %7 = load atomic i8, i8* %6 monotonic, align 1, !dbg !823
  store i8 %7, i8* %4, align 1, !dbg !823
  %8 = load i8, i8* %4, align 1, !dbg !823
  store i8 %8, i8* %3, align 1, !dbg !820
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !824, !srcloc !825
  %9 = load i8, i8* %3, align 1, !dbg !826
  ret i8 %9, !dbg !827
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @_rwlock_get_tid(%struct.rwlock_s* noundef %0) #0 !dbg !828 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !831, metadata !DIExpression()), !dbg !832
  %3 = load i32, i32* @g_tid, align 4, !dbg !833
  %4 = icmp eq i32 %3, 3, !dbg !835
  br i1 %4, label %5, label %14, !dbg !836

5:                                                ; preds = %1
  %6 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !837
  %7 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %6, i32 0, i32 2, !dbg !839
  %8 = call i32 @vatomic32_get_inc(%struct.vatomic32_s* noundef %7), !dbg !840
  store i32 %8, i32* @g_tid, align 4, !dbg !841
  %9 = load i32, i32* @g_tid, align 4, !dbg !842
  %10 = icmp ult i32 %9, 3, !dbg !842
  br i1 %10, label %11, label %12, !dbg !845

11:                                               ; preds = %5
  br label %13, !dbg !845

12:                                               ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.13, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.14, i64 0, i64 0), i32 noundef 93, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__._rwlock_get_tid, i64 0, i64 0)) #5, !dbg !842
  unreachable, !dbg !842

13:                                               ; preds = %11
  br label %14, !dbg !846

14:                                               ; preds = %13, %1
  %15 = load i32, i32* @g_tid, align 4, !dbg !847
  ret i32 %15, !dbg !848
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc(%struct.vatomic32_s* noundef %0) #0 !dbg !849 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !854, metadata !DIExpression()), !dbg !855
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !856
  %4 = call i32 @vatomic32_get_add(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !857
  ret i32 %4, !dbg !858
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !859 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !862, metadata !DIExpression()), !dbg !863
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !864, metadata !DIExpression()), !dbg !865
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !866, !srcloc !867
  call void @llvm.dbg.declare(metadata i32* %5, metadata !868, metadata !DIExpression()), !dbg !869
  %8 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !870
  %9 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %8, i32 0, i32 0, !dbg !871
  %10 = load i32, i32* %4, align 4, !dbg !872
  store i32 %10, i32* %6, align 4, !dbg !873
  %11 = load i32, i32* %6, align 4, !dbg !873
  %12 = atomicrmw add i32* %9, i32 %11 seq_cst, align 4, !dbg !873
  store i32 %12, i32* %7, align 4, !dbg !873
  %13 = load i32, i32* %7, align 4, !dbg !873
  store i32 %13, i32* %5, align 4, !dbg !869
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !874, !srcloc !875
  %14 = load i32, i32* %5, align 4, !dbg !876
  ret i32 %14, !dbg !877
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %0) #0 !dbg !878 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !883, metadata !DIExpression()), !dbg !884
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !885, !srcloc !886
  call void @llvm.dbg.declare(metadata i8** %3, metadata !887, metadata !DIExpression()), !dbg !888
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !889
  %6 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %5, i32 0, i32 0, !dbg !890
  %7 = bitcast i8** %6 to i64*, !dbg !891
  %8 = bitcast i8** %4 to i64*, !dbg !891
  %9 = load atomic i64, i64* %7 seq_cst, align 8, !dbg !891
  store i64 %9, i64* %8, align 8, !dbg !891
  %10 = bitcast i64* %8 to i8**, !dbg !891
  %11 = load i8*, i8** %10, align 8, !dbg !891
  store i8* %11, i8** %3, align 8, !dbg !888
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !892, !srcloc !893
  %12 = load i8*, i8** %3, align 8, !dbg !894
  ret i8* %12, !dbg !895
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !896 {
  %4 = alloca %struct.vatomicptr_s*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i8*, align 8
  %9 = alloca i8, align 1
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %4, metadata !900, metadata !DIExpression()), !dbg !901
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !902, metadata !DIExpression()), !dbg !903
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !904, metadata !DIExpression()), !dbg !905
  call void @llvm.dbg.declare(metadata i8** %7, metadata !906, metadata !DIExpression()), !dbg !907
  %10 = load i8*, i8** %5, align 8, !dbg !908
  store i8* %10, i8** %7, align 8, !dbg !907
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !909, !srcloc !910
  %11 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %4, align 8, !dbg !911
  %12 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %11, i32 0, i32 0, !dbg !912
  %13 = load i8*, i8** %6, align 8, !dbg !913
  store i8* %13, i8** %8, align 8, !dbg !914
  %14 = bitcast i8** %12 to i64*, !dbg !914
  %15 = bitcast i8** %7 to i64*, !dbg !914
  %16 = bitcast i8** %8 to i64*, !dbg !914
  %17 = load i64, i64* %15, align 8, !dbg !914
  %18 = load i64, i64* %16, align 8, !dbg !914
  %19 = cmpxchg i64* %14, i64 %17, i64 %18 seq_cst seq_cst, align 8, !dbg !914
  %20 = extractvalue { i64, i1 } %19, 0, !dbg !914
  %21 = extractvalue { i64, i1 } %19, 1, !dbg !914
  br i1 %21, label %23, label %22, !dbg !914

22:                                               ; preds = %3
  store i64 %20, i64* %15, align 8, !dbg !914
  br label %23, !dbg !914

23:                                               ; preds = %22, %3
  %24 = zext i1 %21 to i8, !dbg !914
  store i8 %24, i8* %9, align 1, !dbg !914
  %25 = load i8, i8* %9, align 1, !dbg !914
  %26 = trunc i8 %25 to i1, !dbg !914
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !915, !srcloc !916
  %27 = load i8*, i8** %7, align 8, !dbg !917
  ret i8* %27, !dbg !918
}

; Function Attrs: noinline nounwind uwtable
define internal void @_trace_add_or_rem_occurrences(%struct.trace_s* noundef %0, i64 noundef %1, i64 noundef %2, i1 noundef zeroext %3) #0 !dbg !919 {
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  %10 = alloca i8, align 1
  store %struct.trace_s* %0, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !922, metadata !DIExpression()), !dbg !923
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !924, metadata !DIExpression()), !dbg !925
  store i64 %2, i64* %7, align 8
  call void @llvm.dbg.declare(metadata i64* %7, metadata !926, metadata !DIExpression()), !dbg !927
  %11 = zext i1 %3 to i8
  store i8 %11, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !928, metadata !DIExpression()), !dbg !929
  call void @llvm.dbg.declare(metadata i64* %9, metadata !930, metadata !DIExpression()), !dbg !931
  store i64 0, i64* %9, align 8, !dbg !931
  call void @llvm.dbg.declare(metadata i8* %10, metadata !932, metadata !DIExpression()), !dbg !933
  store i8 0, i8* %10, align 1, !dbg !933
  %12 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !934
  %13 = icmp ne %struct.trace_s* %12, null, !dbg !934
  br i1 %13, label %14, label %15, !dbg !937

14:                                               ; preds = %4
  br label %16, !dbg !937

15:                                               ; preds = %4
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 128, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !934
  unreachable, !dbg !934

16:                                               ; preds = %14
  %17 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !938
  %18 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %17, i32 0, i32 3, !dbg !938
  %19 = load i8, i8* %18, align 8, !dbg !938
  %20 = trunc i8 %19 to i1, !dbg !938
  br i1 %20, label %21, label %22, !dbg !941

21:                                               ; preds = %16
  br label %23, !dbg !941

22:                                               ; preds = %16
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.23, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 129, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !938
  unreachable, !dbg !938

23:                                               ; preds = %21
  %24 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !942
  %25 = load i64, i64* %6, align 8, !dbg !943
  %26 = call zeroext i1 @trace_find_unit_idx(%struct.trace_s* noundef %24, i64 noundef %25, i64* noundef %9), !dbg !944
  %27 = zext i1 %26 to i8, !dbg !945
  store i8 %27, i8* %10, align 1, !dbg !945
  %28 = load i8, i8* %8, align 1, !dbg !946
  %29 = trunc i8 %28 to i1, !dbg !946
  br i1 %29, label %30, label %57, !dbg !948

30:                                               ; preds = %23
  %31 = load i8, i8* %10, align 1, !dbg !949
  %32 = trunc i8 %31 to i1, !dbg !949
  br i1 %32, label %33, label %34, !dbg !953

33:                                               ; preds = %30
  br label %35, !dbg !953

34:                                               ; preds = %30
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.24, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 134, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !949
  unreachable, !dbg !949

35:                                               ; preds = %33
  %36 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !954
  %37 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %36, i32 0, i32 0, !dbg !954
  %38 = load %struct.trace_unit_s*, %struct.trace_unit_s** %37, align 8, !dbg !954
  %39 = load i64, i64* %9, align 8, !dbg !954
  %40 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %38, i64 %39, !dbg !954
  %41 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %40, i32 0, i32 1, !dbg !954
  %42 = load i64, i64* %41, align 8, !dbg !954
  %43 = load i64, i64* %7, align 8, !dbg !954
  %44 = icmp uge i64 %42, %43, !dbg !954
  br i1 %44, label %45, label %46, !dbg !957

45:                                               ; preds = %35
  br label %47, !dbg !957

46:                                               ; preds = %35
  call void @__assert_fail(i8* noundef getelementptr inbounds ([33 x i8], [33 x i8]* @.str.25, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 135, i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @__PRETTY_FUNCTION__._trace_add_or_rem_occurrences, i64 0, i64 0)) #5, !dbg !954
  unreachable, !dbg !954

47:                                               ; preds = %45
  %48 = load i64, i64* %7, align 8, !dbg !958
  %49 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !959
  %50 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %49, i32 0, i32 0, !dbg !960
  %51 = load %struct.trace_unit_s*, %struct.trace_unit_s** %50, align 8, !dbg !960
  %52 = load i64, i64* %9, align 8, !dbg !961
  %53 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %51, i64 %52, !dbg !959
  %54 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %53, i32 0, i32 1, !dbg !962
  %55 = load i64, i64* %54, align 8, !dbg !963
  %56 = sub i64 %55, %48, !dbg !963
  store i64 %56, i64* %54, align 8, !dbg !963
  br label %97, !dbg !964

57:                                               ; preds = %23
  %58 = load i8, i8* %10, align 1, !dbg !965
  %59 = trunc i8 %58 to i1, !dbg !965
  br i1 %59, label %87, label %60, !dbg !967

60:                                               ; preds = %57
  %61 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !968
  %62 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %61, i32 0, i32 1, !dbg !970
  %63 = load i64, i64* %62, align 8, !dbg !971
  %64 = add i64 %63, 1, !dbg !971
  store i64 %64, i64* %62, align 8, !dbg !971
  store i64 %63, i64* %9, align 8, !dbg !972
  %65 = load i64, i64* %9, align 8, !dbg !973
  %66 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !975
  %67 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %66, i32 0, i32 2, !dbg !976
  %68 = load i64, i64* %67, align 8, !dbg !976
  %69 = icmp uge i64 %65, %68, !dbg !977
  br i1 %69, label %70, label %72, !dbg !978

70:                                               ; preds = %60
  %71 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !979
  call void @trace_extend(%struct.trace_s* noundef %71), !dbg !981
  br label %72, !dbg !982

72:                                               ; preds = %70, %60
  %73 = load i64, i64* %6, align 8, !dbg !983
  %74 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !984
  %75 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %74, i32 0, i32 0, !dbg !985
  %76 = load %struct.trace_unit_s*, %struct.trace_unit_s** %75, align 8, !dbg !985
  %77 = load i64, i64* %9, align 8, !dbg !986
  %78 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %76, i64 %77, !dbg !984
  %79 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %78, i32 0, i32 0, !dbg !987
  store i64 %73, i64* %79, align 8, !dbg !988
  %80 = load i64, i64* %7, align 8, !dbg !989
  %81 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !990
  %82 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %81, i32 0, i32 0, !dbg !991
  %83 = load %struct.trace_unit_s*, %struct.trace_unit_s** %82, align 8, !dbg !991
  %84 = load i64, i64* %9, align 8, !dbg !992
  %85 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %83, i64 %84, !dbg !990
  %86 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %85, i32 0, i32 1, !dbg !993
  store i64 %80, i64* %86, align 8, !dbg !994
  br label %97, !dbg !995

87:                                               ; preds = %57
  %88 = load i64, i64* %7, align 8, !dbg !996
  %89 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !998
  %90 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %89, i32 0, i32 0, !dbg !999
  %91 = load %struct.trace_unit_s*, %struct.trace_unit_s** %90, align 8, !dbg !999
  %92 = load i64, i64* %9, align 8, !dbg !1000
  %93 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %91, i64 %92, !dbg !998
  %94 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %93, i32 0, i32 1, !dbg !1001
  %95 = load i64, i64* %94, align 8, !dbg !1002
  %96 = add i64 %95, %88, !dbg !1002
  store i64 %96, i64* %94, align 8, !dbg !1002
  br label %97

97:                                               ; preds = %47, %87, %72
  ret void, !dbg !1003
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @trace_find_unit_idx(%struct.trace_s* noundef %0, i64 noundef %1, i64* noundef %2) #0 !dbg !1004 {
  %4 = alloca i1, align 1
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64*, align 8
  %8 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !1008, metadata !DIExpression()), !dbg !1009
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1010, metadata !DIExpression()), !dbg !1011
  store i64* %2, i64** %7, align 8
  call void @llvm.dbg.declare(metadata i64** %7, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.declare(metadata i64* %8, metadata !1014, metadata !DIExpression()), !dbg !1015
  store i64 0, i64* %8, align 8, !dbg !1015
  %9 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1016
  %10 = icmp ne %struct.trace_s* %9, null, !dbg !1016
  br i1 %10, label %11, label %12, !dbg !1019

11:                                               ; preds = %3
  br label %13, !dbg !1019

12:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 110, i8* noundef getelementptr inbounds ([62 x i8], [62 x i8]* @__PRETTY_FUNCTION__.trace_find_unit_idx, i64 0, i64 0)) #5, !dbg !1016
  unreachable, !dbg !1016

13:                                               ; preds = %11
  %14 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1020
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 3, !dbg !1020
  %16 = load i8, i8* %15, align 8, !dbg !1020
  %17 = trunc i8 %16 to i1, !dbg !1020
  br i1 %17, label %18, label %19, !dbg !1023

18:                                               ; preds = %13
  br label %20, !dbg !1023

19:                                               ; preds = %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.23, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 111, i8* noundef getelementptr inbounds ([62 x i8], [62 x i8]* @__PRETTY_FUNCTION__.trace_find_unit_idx, i64 0, i64 0)) #5, !dbg !1020
  unreachable, !dbg !1020

20:                                               ; preds = %18
  store i64 0, i64* %8, align 8, !dbg !1024
  br label %21, !dbg !1026

21:                                               ; preds = %41, %20
  %22 = load i64, i64* %8, align 8, !dbg !1027
  %23 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1029
  %24 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %23, i32 0, i32 1, !dbg !1030
  %25 = load i64, i64* %24, align 8, !dbg !1030
  %26 = icmp ult i64 %22, %25, !dbg !1031
  br i1 %26, label %27, label %44, !dbg !1032

27:                                               ; preds = %21
  %28 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !1033
  %29 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %28, i32 0, i32 0, !dbg !1036
  %30 = load %struct.trace_unit_s*, %struct.trace_unit_s** %29, align 8, !dbg !1036
  %31 = load i64, i64* %8, align 8, !dbg !1037
  %32 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %30, i64 %31, !dbg !1033
  %33 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %32, i32 0, i32 0, !dbg !1038
  %34 = load i64, i64* %33, align 8, !dbg !1038
  %35 = load i64, i64* %6, align 8, !dbg !1039
  %36 = icmp eq i64 %34, %35, !dbg !1040
  br i1 %36, label %37, label %40, !dbg !1041

37:                                               ; preds = %27
  %38 = load i64, i64* %8, align 8, !dbg !1042
  %39 = load i64*, i64** %7, align 8, !dbg !1044
  store i64 %38, i64* %39, align 8, !dbg !1045
  store i1 true, i1* %4, align 1, !dbg !1046
  br label %45, !dbg !1046

40:                                               ; preds = %27
  br label %41, !dbg !1047

41:                                               ; preds = %40
  %42 = load i64, i64* %8, align 8, !dbg !1048
  %43 = add i64 %42, 1, !dbg !1048
  store i64 %43, i64* %8, align 8, !dbg !1048
  br label %21, !dbg !1049, !llvm.loop !1050

44:                                               ; preds = %21
  store i1 false, i1* %4, align 1, !dbg !1052
  br label %45, !dbg !1052

45:                                               ; preds = %44, %37
  %46 = load i1, i1* %4, align 1, !dbg !1053
  ret i1 %46, !dbg !1053
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_extend(%struct.trace_s* noundef %0) #0 !dbg !1054 {
  %2 = alloca %struct.trace_s*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca %struct.trace_unit_s*, align 8
  %6 = alloca %struct.trace_unit_s*, align 8
  %7 = alloca i32, align 4
  store %struct.trace_s* %0, %struct.trace_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %2, metadata !1057, metadata !DIExpression()), !dbg !1058
  %8 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1059
  %9 = icmp ne %struct.trace_s* %8, null, !dbg !1059
  br i1 %9, label %10, label %11, !dbg !1062

10:                                               ; preds = %1
  br label %12, !dbg !1062

11:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 75, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.trace_extend, i64 0, i64 0)) #5, !dbg !1059
  unreachable, !dbg !1059

12:                                               ; preds = %10
  call void @llvm.dbg.declare(metadata i64* %3, metadata !1063, metadata !DIExpression()), !dbg !1064
  %13 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1065
  %14 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %13, i32 0, i32 2, !dbg !1066
  %15 = load i64, i64* %14, align 8, !dbg !1066
  %16 = mul i64 %15, 16, !dbg !1067
  store i64 %16, i64* %3, align 8, !dbg !1064
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1068, metadata !DIExpression()), !dbg !1069
  %17 = load i64, i64* %3, align 8, !dbg !1070
  %18 = mul i64 %17, 2, !dbg !1071
  store i64 %18, i64* %4, align 8, !dbg !1069
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %5, metadata !1072, metadata !DIExpression()), !dbg !1073
  %19 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1074
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 0, !dbg !1075
  %21 = load %struct.trace_unit_s*, %struct.trace_unit_s** %20, align 8, !dbg !1075
  store %struct.trace_unit_s* %21, %struct.trace_unit_s** %5, align 8, !dbg !1073
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %6, metadata !1076, metadata !DIExpression()), !dbg !1077
  %22 = load i64, i64* %4, align 8, !dbg !1078
  %23 = call noalias i8* @malloc(i64 noundef %22) #6, !dbg !1079
  %24 = bitcast i8* %23 to %struct.trace_unit_s*, !dbg !1079
  store %struct.trace_unit_s* %24, %struct.trace_unit_s** %6, align 8, !dbg !1077
  %25 = load %struct.trace_unit_s*, %struct.trace_unit_s** %6, align 8, !dbg !1080
  %26 = icmp ne %struct.trace_unit_s* %25, null, !dbg !1080
  br i1 %26, label %27, label %47, !dbg !1082

27:                                               ; preds = %12
  call void @llvm.dbg.declare(metadata i32* %7, metadata !1083, metadata !DIExpression()), !dbg !1085
  %28 = load %struct.trace_unit_s*, %struct.trace_unit_s** %6, align 8, !dbg !1086
  %29 = load i64, i64* %4, align 8, !dbg !1087
  %30 = load %struct.trace_unit_s*, %struct.trace_unit_s** %5, align 8, !dbg !1088
  %31 = load i64, i64* %3, align 8, !dbg !1089
  %32 = call i32 (%struct.trace_unit_s*, i64, %struct.trace_unit_s*, i64, ...) bitcast (i32 (...)* @memcpy_s to i32 (%struct.trace_unit_s*, i64, %struct.trace_unit_s*, i64, ...)*)(%struct.trace_unit_s* noundef %28, i64 noundef %29, %struct.trace_unit_s* noundef %30, i64 noundef %31), !dbg !1090
  store i32 %32, i32* %7, align 4, !dbg !1085
  %33 = load i32, i32* %7, align 4, !dbg !1091
  %34 = icmp eq i32 %33, 0, !dbg !1093
  br i1 %34, label %35, label %43, !dbg !1094

35:                                               ; preds = %27
  %36 = load %struct.trace_unit_s*, %struct.trace_unit_s** %6, align 8, !dbg !1095
  %37 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1097
  %38 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %37, i32 0, i32 0, !dbg !1098
  store %struct.trace_unit_s* %36, %struct.trace_unit_s** %38, align 8, !dbg !1099
  %39 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !1100
  %40 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %39, i32 0, i32 2, !dbg !1101
  %41 = load i64, i64* %40, align 8, !dbg !1102
  %42 = mul i64 %41, 2, !dbg !1102
  store i64 %42, i64* %40, align 8, !dbg !1102
  br label %44, !dbg !1103

43:                                               ; preds = %27
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.26, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 89, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.trace_extend, i64 0, i64 0)) #5, !dbg !1104
  unreachable, !dbg !1104

44:                                               ; preds = %35
  %45 = load %struct.trace_unit_s*, %struct.trace_unit_s** %5, align 8, !dbg !1108
  %46 = bitcast %struct.trace_unit_s* %45 to i8*, !dbg !1108
  call void @free(i8* noundef %46) #6, !dbg !1109
  br label %48, !dbg !1110

47:                                               ; preds = %12
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.27, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 93, i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @__PRETTY_FUNCTION__.trace_extend, i64 0, i64 0)) #5, !dbg !1111
  unreachable, !dbg !1111

48:                                               ; preds = %44
  ret void, !dbg !1115
}

declare i32 @memcpy_s(...) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @vsimpleht_remove(%struct.vsimpleht_s* noundef %0, i64 noundef %1) #0 !dbg !1116 {
  %3 = alloca i32, align 4
  %4 = alloca %struct.vsimpleht_s*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8*, align 8
  %9 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %4, metadata !1119, metadata !DIExpression()), !dbg !1120
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1121, metadata !DIExpression()), !dbg !1122
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1123, metadata !DIExpression()), !dbg !1124
  store i64 0, i64* %6, align 8, !dbg !1124
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1125, metadata !DIExpression()), !dbg !1126
  store i64 0, i64* %7, align 8, !dbg !1126
  call void @llvm.dbg.declare(metadata i8** %8, metadata !1127, metadata !DIExpression()), !dbg !1128
  store i8* null, i8** %8, align 8, !dbg !1128
  call void @llvm.dbg.declare(metadata i64* %9, metadata !1129, metadata !DIExpression()), !dbg !1130
  %10 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1131
  %11 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %10, i32 0, i32 3, !dbg !1132
  %12 = load i64 (i64)*, i64 (i64)** %11, align 8, !dbg !1132
  %13 = load i64, i64* %5, align 8, !dbg !1133
  %14 = call i64 %12(i64 noundef %13), !dbg !1131
  store i64 %14, i64* %9, align 8, !dbg !1130
  %15 = load i64, i64* %9, align 8, !dbg !1134
  %16 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1135
  %17 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %16, i32 0, i32 0, !dbg !1136
  %18 = load i64, i64* %17, align 8, !dbg !1136
  %19 = sub i64 %18, 1, !dbg !1137
  %20 = and i64 %15, %19, !dbg !1138
  store i64 %20, i64* %6, align 8, !dbg !1139
  %21 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1140
  call void @_vsimpleht_give_cleanup_a_chance(%struct.vsimpleht_s* noundef %21), !dbg !1141
  br label %22, !dbg !1142

22:                                               ; preds = %81, %2
  %23 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1143
  %24 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %23, i32 0, i32 1, !dbg !1145
  %25 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %24, align 8, !dbg !1145
  %26 = load i64, i64* %6, align 8, !dbg !1146
  %27 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %25, i64 %26, !dbg !1143
  %28 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %27, i32 0, i32 0, !dbg !1147
  %29 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %28), !dbg !1148
  %30 = ptrtoint i8* %29 to i64, !dbg !1149
  store i64 %30, i64* %7, align 8, !dbg !1150
  %31 = load i64, i64* %7, align 8, !dbg !1151
  %32 = icmp eq i64 %31, 0, !dbg !1153
  br i1 %32, label %33, label %34, !dbg !1154

33:                                               ; preds = %22
  store i32 3, i32* %3, align 4, !dbg !1155
  br label %86, !dbg !1155

34:                                               ; preds = %22
  %35 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1157
  %36 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %35, i32 0, i32 2, !dbg !1159
  %37 = load i8 (i64, i64)*, i8 (i64, i64)** %36, align 8, !dbg !1159
  %38 = load i64, i64* %5, align 8, !dbg !1160
  %39 = load i64, i64* %7, align 8, !dbg !1161
  %40 = call signext i8 %37(i64 noundef %38, i64 noundef %39), !dbg !1157
  %41 = sext i8 %40 to i32, !dbg !1157
  %42 = icmp eq i32 %41, 0, !dbg !1162
  br i1 %42, label %43, label %71, !dbg !1163

43:                                               ; preds = %34
  %44 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1164
  %45 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %44, i32 0, i32 1, !dbg !1166
  %46 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %45, align 8, !dbg !1166
  %47 = load i64, i64* %6, align 8, !dbg !1167
  %48 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %46, i64 %47, !dbg !1164
  %49 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %48, i32 0, i32 1, !dbg !1168
  %50 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %49), !dbg !1169
  store i8* %50, i8** %8, align 8, !dbg !1170
  %51 = load i8*, i8** %8, align 8, !dbg !1171
  %52 = icmp eq i8* %51, null, !dbg !1173
  br i1 %52, label %53, label %54, !dbg !1174

53:                                               ; preds = %43
  store i32 3, i32* %3, align 4, !dbg !1175
  br label %86, !dbg !1175

54:                                               ; preds = %43
  %55 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1177
  %56 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %55, i32 0, i32 1, !dbg !1179
  %57 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %56, align 8, !dbg !1179
  %58 = load i64, i64* %6, align 8, !dbg !1180
  %59 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %57, i64 %58, !dbg !1177
  %60 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %59, i32 0, i32 1, !dbg !1181
  %61 = load i8*, i8** %8, align 8, !dbg !1182
  %62 = call i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %60, i8* noundef %61, i8* noundef null), !dbg !1183
  %63 = load i8*, i8** %8, align 8, !dbg !1184
  %64 = icmp eq i8* %62, %63, !dbg !1185
  br i1 %64, label %65, label %70, !dbg !1186

65:                                               ; preds = %54
  %66 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1187
  %67 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %66, i32 0, i32 6, !dbg !1189
  call void @vatomicsz_inc_rlx(%struct.vatomicsz_s* noundef %67), !dbg !1190
  %68 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1191
  %69 = load i8*, i8** %8, align 8, !dbg !1192
  call void @_vsimpleht_trigger_cleanup(%struct.vsimpleht_s* noundef %68, i8* noundef %69), !dbg !1193
  store i32 0, i32* %3, align 4, !dbg !1194
  br label %86, !dbg !1194

70:                                               ; preds = %54
  store i32 3, i32* %3, align 4, !dbg !1195
  br label %86, !dbg !1195

71:                                               ; preds = %34
  br label %72

72:                                               ; preds = %71
  %73 = load i64, i64* %6, align 8, !dbg !1196
  %74 = add i64 %73, 1, !dbg !1196
  store i64 %74, i64* %6, align 8, !dbg !1196
  %75 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1197
  %76 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %75, i32 0, i32 0, !dbg !1198
  %77 = load i64, i64* %76, align 8, !dbg !1198
  %78 = sub i64 %77, 1, !dbg !1199
  %79 = load i64, i64* %6, align 8, !dbg !1200
  %80 = and i64 %79, %78, !dbg !1200
  store i64 %80, i64* %6, align 8, !dbg !1200
  br label %81, !dbg !1201

81:                                               ; preds = %72
  %82 = load i64, i64* %6, align 8, !dbg !1202
  %83 = load i64, i64* %9, align 8, !dbg !1203
  %84 = icmp ne i64 %82, %83, !dbg !1204
  br i1 %84, label %22, label %85, !dbg !1201, !llvm.loop !1205

85:                                               ; preds = %81
  store i32 3, i32* %3, align 4, !dbg !1207
  br label %86, !dbg !1207

86:                                               ; preds = %85, %70, %65, %53, %33
  %87 = load i32, i32* %3, align 4, !dbg !1208
  ret i32 %87, !dbg !1208
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %0) #0 !dbg !1209 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !1210, metadata !DIExpression()), !dbg !1211
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1212, !srcloc !1213
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1214, metadata !DIExpression()), !dbg !1215
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !1216
  %6 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %5, i32 0, i32 0, !dbg !1217
  %7 = bitcast i8** %6 to i64*, !dbg !1218
  %8 = bitcast i8** %4 to i64*, !dbg !1218
  %9 = load atomic i64, i64* %7 acquire, align 8, !dbg !1218
  store i64 %9, i64* %8, align 8, !dbg !1218
  %10 = bitcast i64* %8 to i8**, !dbg !1218
  %11 = load i8*, i8** %10, align 8, !dbg !1218
  store i8* %11, i8** %3, align 8, !dbg !1215
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1219, !srcloc !1220
  %12 = load i8*, i8** %3, align 8, !dbg !1221
  ret i8* %12, !dbg !1222
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !1223 {
  %4 = alloca %struct.vatomicptr_s*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i8*, align 8
  %9 = alloca i8, align 1
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %4, metadata !1224, metadata !DIExpression()), !dbg !1225
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !1226, metadata !DIExpression()), !dbg !1227
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !1228, metadata !DIExpression()), !dbg !1229
  call void @llvm.dbg.declare(metadata i8** %7, metadata !1230, metadata !DIExpression()), !dbg !1231
  %10 = load i8*, i8** %5, align 8, !dbg !1232
  store i8* %10, i8** %7, align 8, !dbg !1231
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1233, !srcloc !1234
  %11 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %4, align 8, !dbg !1235
  %12 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %11, i32 0, i32 0, !dbg !1236
  %13 = load i8*, i8** %6, align 8, !dbg !1237
  store i8* %13, i8** %8, align 8, !dbg !1238
  %14 = bitcast i8** %12 to i64*, !dbg !1238
  %15 = bitcast i8** %7 to i64*, !dbg !1238
  %16 = bitcast i8** %8 to i64*, !dbg !1238
  %17 = load i64, i64* %15, align 8, !dbg !1238
  %18 = load i64, i64* %16, align 8, !dbg !1238
  %19 = cmpxchg i64* %14, i64 %17, i64 %18 release monotonic, align 8, !dbg !1238
  %20 = extractvalue { i64, i1 } %19, 0, !dbg !1238
  %21 = extractvalue { i64, i1 } %19, 1, !dbg !1238
  br i1 %21, label %23, label %22, !dbg !1238

22:                                               ; preds = %3
  store i64 %20, i64* %15, align 8, !dbg !1238
  br label %23, !dbg !1238

23:                                               ; preds = %22, %3
  %24 = zext i1 %21 to i8, !dbg !1238
  store i8 %24, i8* %9, align 1, !dbg !1238
  %25 = load i8, i8* %9, align 1, !dbg !1238
  %26 = trunc i8 %25 to i1, !dbg !1238
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1239, !srcloc !1240
  %27 = load i8*, i8** %7, align 8, !dbg !1241
  ret i8* %27, !dbg !1242
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicsz_inc_rlx(%struct.vatomicsz_s* noundef %0) #0 !dbg !1243 {
  %2 = alloca %struct.vatomicsz_s*, align 8
  store %struct.vatomicsz_s* %0, %struct.vatomicsz_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicsz_s** %2, metadata !1247, metadata !DIExpression()), !dbg !1248
  %3 = load %struct.vatomicsz_s*, %struct.vatomicsz_s** %2, align 8, !dbg !1249
  %4 = call i64 @vatomicsz_get_inc_rlx(%struct.vatomicsz_s* noundef %3), !dbg !1250
  ret void, !dbg !1251
}

; Function Attrs: noinline nounwind uwtable
define internal void @_vsimpleht_trigger_cleanup(%struct.vsimpleht_s* noundef %0, i8* noundef %1) #0 !dbg !1252 {
  %3 = alloca %struct.vsimpleht_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %3, metadata !1255, metadata !DIExpression()), !dbg !1256
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1257, metadata !DIExpression()), !dbg !1258
  %5 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1259
  %6 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %5, i32 0, i32 7, !dbg !1259
  %7 = call zeroext i1 @rwlock_acquired_by_readers(%struct.rwlock_s* noundef %6), !dbg !1259
  br i1 %7, label %8, label %10, !dbg !1259

8:                                                ; preds = %2
  br i1 true, label %9, label %10, !dbg !1262

9:                                                ; preds = %8
  br label %11, !dbg !1262

10:                                               ; preds = %8, %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([112 x i8], [112 x i8]* @.str.12, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 508, i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @__PRETTY_FUNCTION__._vsimpleht_trigger_cleanup, i64 0, i64 0)) #5, !dbg !1259
  unreachable, !dbg !1259

11:                                               ; preds = %9
  %12 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1263
  %13 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %12, i32 0, i32 7, !dbg !1264
  call void @rwlock_read_release(%struct.rwlock_s* noundef %13), !dbg !1265
  %14 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1266
  %15 = load i8*, i8** %4, align 8, !dbg !1267
  call void @_vsimpleht_cleanup(%struct.vsimpleht_s* noundef %14, i8* noundef %15), !dbg !1268
  %16 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1269
  %17 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %16, i32 0, i32 7, !dbg !1270
  call void @rwlock_read_acquire(%struct.rwlock_s* noundef %17), !dbg !1271
  ret void, !dbg !1272
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomicsz_get_inc_rlx(%struct.vatomicsz_s* noundef %0) #0 !dbg !1273 {
  %2 = alloca %struct.vatomicsz_s*, align 8
  store %struct.vatomicsz_s* %0, %struct.vatomicsz_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicsz_s** %2, metadata !1276, metadata !DIExpression()), !dbg !1277
  %3 = load %struct.vatomicsz_s*, %struct.vatomicsz_s** %2, align 8, !dbg !1278
  %4 = call i64 @vatomicsz_get_add_rlx(%struct.vatomicsz_s* noundef %3, i64 noundef 1), !dbg !1279
  ret i64 %4, !dbg !1280
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomicsz_get_add_rlx(%struct.vatomicsz_s* noundef %0, i64 noundef %1) #0 !dbg !1281 {
  %3 = alloca %struct.vatomicsz_s*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  store %struct.vatomicsz_s* %0, %struct.vatomicsz_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicsz_s** %3, metadata !1284, metadata !DIExpression()), !dbg !1285
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1286, metadata !DIExpression()), !dbg !1287
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1288, !srcloc !1289
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1290, metadata !DIExpression()), !dbg !1291
  %8 = load %struct.vatomicsz_s*, %struct.vatomicsz_s** %3, align 8, !dbg !1292
  %9 = getelementptr inbounds %struct.vatomicsz_s, %struct.vatomicsz_s* %8, i32 0, i32 0, !dbg !1293
  %10 = load i64, i64* %4, align 8, !dbg !1294
  store i64 %10, i64* %6, align 8, !dbg !1295
  %11 = load i64, i64* %6, align 8, !dbg !1295
  %12 = atomicrmw add i64* %9, i64 %11 monotonic, align 8, !dbg !1295
  store i64 %12, i64* %7, align 8, !dbg !1295
  %13 = load i64, i64* %7, align 8, !dbg !1295
  store i64 %13, i64* %5, align 8, !dbg !1291
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1296, !srcloc !1297
  %14 = load i64, i64* %5, align 8, !dbg !1298
  ret i64 %14, !dbg !1299
}

; Function Attrs: noinline nounwind uwtable
define internal void @_vsimpleht_cleanup(%struct.vsimpleht_s* noundef %0, i8* noundef %1) #0 !dbg !1300 {
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
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %3, metadata !1301, metadata !DIExpression()), !dbg !1302
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1303, metadata !DIExpression()), !dbg !1304
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1305, metadata !DIExpression()), !dbg !1306
  store i64 0, i64* %5, align 8, !dbg !1306
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1307, metadata !DIExpression()), !dbg !1308
  store i64 0, i64* %6, align 8, !dbg !1308
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1309, metadata !DIExpression()), !dbg !1310
  store i64 0, i64* %7, align 8, !dbg !1310
  call void @llvm.dbg.declare(metadata i8** %8, metadata !1311, metadata !DIExpression()), !dbg !1312
  store i8* null, i8** %8, align 8, !dbg !1312
  call void @llvm.dbg.declare(metadata i64* %9, metadata !1313, metadata !DIExpression()), !dbg !1314
  %13 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1315
  %14 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %13, i32 0, i32 0, !dbg !1316
  %15 = load i64, i64* %14, align 8, !dbg !1316
  store i64 %15, i64* %9, align 8, !dbg !1314
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_entry_s** %10, metadata !1317, metadata !DIExpression()), !dbg !1318
  %16 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1319
  %17 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %16, i32 0, i32 1, !dbg !1320
  %18 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %17, align 8, !dbg !1320
  store %struct.vsimpleht_entry_s* %18, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1318
  call void @llvm.dbg.declare(metadata i64* %11, metadata !1321, metadata !DIExpression()), !dbg !1322
  %19 = load i64, i64* %9, align 8, !dbg !1323
  %20 = sub i64 %19, 1, !dbg !1324
  store i64 %20, i64* %11, align 8, !dbg !1322
  call void @llvm.dbg.declare(metadata i8* %12, metadata !1325, metadata !DIExpression()), !dbg !1326
  %21 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1327
  %22 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %21, i32 0, i32 7, !dbg !1328
  call void @rwlock_write_acquire(%struct.rwlock_s* noundef %22), !dbg !1329
  %23 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1330
  %24 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %23, i32 0, i32 6, !dbg !1332
  %25 = call i64 @vatomicsz_read_rlx(%struct.vatomicsz_s* noundef %24), !dbg !1333
  %26 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1334
  %27 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %26, i32 0, i32 5, !dbg !1335
  %28 = load i64, i64* %27, align 8, !dbg !1335
  %29 = icmp ult i64 %25, %28, !dbg !1336
  br i1 %29, label %30, label %31, !dbg !1337

30:                                               ; preds = %2
  br label %129, !dbg !1338

31:                                               ; preds = %2
  store i64 0, i64* %5, align 8, !dbg !1340
  br label %32, !dbg !1342

32:                                               ; preds = %53, %31
  %33 = load i64, i64* %5, align 8, !dbg !1343
  %34 = load i64, i64* %9, align 8, !dbg !1345
  %35 = icmp ult i64 %33, %34, !dbg !1346
  br i1 %35, label %36, label %56, !dbg !1347

36:                                               ; preds = %32
  %37 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1348
  %38 = load i64, i64* %5, align 8, !dbg !1350
  %39 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %37, i64 %38, !dbg !1348
  %40 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %39, i32 0, i32 0, !dbg !1351
  %41 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %40), !dbg !1352
  %42 = ptrtoint i8* %41 to i64, !dbg !1353
  store i64 %42, i64* %7, align 8, !dbg !1354
  %43 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1355
  %44 = load i64, i64* %5, align 8, !dbg !1356
  %45 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %43, i64 %44, !dbg !1355
  %46 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %45, i32 0, i32 1, !dbg !1357
  %47 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %46), !dbg !1358
  store i8* %47, i8** %8, align 8, !dbg !1359
  %48 = load i64, i64* %7, align 8, !dbg !1360
  %49 = icmp eq i64 %48, 0, !dbg !1362
  br i1 %49, label %50, label %52, !dbg !1363

50:                                               ; preds = %36
  %51 = load i64, i64* %5, align 8, !dbg !1364
  store i64 %51, i64* %11, align 8, !dbg !1366
  br label %56, !dbg !1367

52:                                               ; preds = %36
  br label %53, !dbg !1368

53:                                               ; preds = %52
  %54 = load i64, i64* %5, align 8, !dbg !1369
  %55 = add i64 %54, 1, !dbg !1369
  store i64 %55, i64* %5, align 8, !dbg !1369
  br label %32, !dbg !1370, !llvm.loop !1371

56:                                               ; preds = %50, %32
  store i64 0, i64* %5, align 8, !dbg !1373
  br label %57, !dbg !1375

57:                                               ; preds = %123, %56
  %58 = load i64, i64* %5, align 8, !dbg !1376
  %59 = load i64, i64* %9, align 8, !dbg !1378
  %60 = icmp ult i64 %58, %59, !dbg !1379
  br i1 %60, label %61, label %126, !dbg !1380

61:                                               ; preds = %57
  %62 = load i64, i64* %5, align 8, !dbg !1381
  %63 = load i64, i64* %11, align 8, !dbg !1383
  %64 = add i64 %62, %63, !dbg !1384
  %65 = load i64, i64* %9, align 8, !dbg !1385
  %66 = sub i64 %65, 1, !dbg !1386
  %67 = and i64 %64, %66, !dbg !1387
  store i64 %67, i64* %6, align 8, !dbg !1388
  %68 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1389
  %69 = load i64, i64* %6, align 8, !dbg !1390
  %70 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %68, i64 %69, !dbg !1389
  %71 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %70, i32 0, i32 0, !dbg !1391
  %72 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %71), !dbg !1392
  %73 = ptrtoint i8* %72 to i64, !dbg !1393
  store i64 %73, i64* %7, align 8, !dbg !1394
  %74 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1395
  %75 = load i64, i64* %6, align 8, !dbg !1396
  %76 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %74, i64 %75, !dbg !1395
  %77 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %76, i32 0, i32 1, !dbg !1397
  %78 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %77), !dbg !1398
  store i8* %78, i8** %8, align 8, !dbg !1399
  %79 = load i64, i64* %7, align 8, !dbg !1400
  %80 = icmp ne i64 %79, 0, !dbg !1402
  br i1 %80, label %81, label %110, !dbg !1403

81:                                               ; preds = %61
  %82 = load i8*, i8** %8, align 8, !dbg !1404
  %83 = icmp ne i8* %82, null, !dbg !1405
  br i1 %83, label %84, label %110, !dbg !1406

84:                                               ; preds = %81
  %85 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1407
  %86 = load i64, i64* %7, align 8, !dbg !1409
  %87 = load i8*, i8** %8, align 8, !dbg !1410
  %88 = call i32 @_vsimpleht_add(%struct.vsimpleht_s* noundef %85, i64 noundef %86, i8* noundef %87), !dbg !1411
  %89 = trunc i32 %88 to i8, !dbg !1411
  store i8 %89, i8* %12, align 1, !dbg !1412
  %90 = load i8, i8* %12, align 1, !dbg !1413
  %91 = zext i8 %90 to i32, !dbg !1413
  %92 = icmp eq i32 %91, 0, !dbg !1415
  br i1 %92, label %93, label %102, !dbg !1416

93:                                               ; preds = %84
  %94 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1417
  %95 = load i64, i64* %6, align 8, !dbg !1419
  %96 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %94, i64 %95, !dbg !1417
  %97 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %96, i32 0, i32 0, !dbg !1420
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %97, i8* noundef null), !dbg !1421
  %98 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1422
  %99 = load i64, i64* %6, align 8, !dbg !1423
  %100 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %98, i64 %99, !dbg !1422
  %101 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %100, i32 0, i32 1, !dbg !1424
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %101, i8* noundef null), !dbg !1425
  br label %102, !dbg !1426

102:                                              ; preds = %93, %84
  %103 = load i8, i8* %12, align 1, !dbg !1427
  %104 = zext i8 %103 to i32, !dbg !1427
  %105 = icmp ne i32 %104, 1, !dbg !1427
  br i1 %105, label %106, label %108, !dbg !1427

106:                                              ; preds = %102
  br i1 true, label %107, label %108, !dbg !1430

107:                                              ; preds = %106
  br label %109, !dbg !1430

108:                                              ; preds = %106, %102
  call void @__assert_fail(i8* noundef getelementptr inbounds ([116 x i8], [116 x i8]* @.str.29, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 586, i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @__PRETTY_FUNCTION__._vsimpleht_cleanup, i64 0, i64 0)) #5, !dbg !1427
  unreachable, !dbg !1427

109:                                              ; preds = %107
  br label %122, !dbg !1431

110:                                              ; preds = %81, %61
  %111 = load i64, i64* %7, align 8, !dbg !1432
  %112 = icmp ne i64 %111, 0, !dbg !1434
  br i1 %112, label %113, label %121, !dbg !1435

113:                                              ; preds = %110
  %114 = load i8*, i8** %8, align 8, !dbg !1436
  %115 = icmp eq i8* %114, null, !dbg !1437
  br i1 %115, label %116, label %121, !dbg !1438

116:                                              ; preds = %113
  %117 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !1439
  %118 = load i64, i64* %6, align 8, !dbg !1441
  %119 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %117, i64 %118, !dbg !1439
  %120 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %119, i32 0, i32 0, !dbg !1442
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %120, i8* noundef null), !dbg !1443
  br label %121, !dbg !1444

121:                                              ; preds = %116, %113, %110
  br label %122

122:                                              ; preds = %121, %109
  br label %123, !dbg !1445

123:                                              ; preds = %122
  %124 = load i64, i64* %5, align 8, !dbg !1446
  %125 = add i64 %124, 1, !dbg !1446
  store i64 %125, i64* %5, align 8, !dbg !1446
  br label %57, !dbg !1447, !llvm.loop !1448

126:                                              ; preds = %57
  %127 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1450
  %128 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %127, i32 0, i32 6, !dbg !1451
  call void @vatomicsz_write_rlx(%struct.vatomicsz_s* noundef %128, i64 noundef 0), !dbg !1452
  br label %129, !dbg !1452

129:                                              ; preds = %126, %30
  call void @llvm.dbg.label(metadata !1453), !dbg !1454
  %130 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1455
  %131 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %130, i32 0, i32 4, !dbg !1456
  %132 = load void (i8*)*, void (i8*)** %131, align 8, !dbg !1456
  %133 = load i8*, i8** %4, align 8, !dbg !1457
  call void %132(i8* noundef %133), !dbg !1455
  %134 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !1458
  %135 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %134, i32 0, i32 7, !dbg !1459
  call void @rwlock_write_release(%struct.rwlock_s* noundef %135), !dbg !1460
  ret void, !dbg !1461
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_write_acquire(%struct.rwlock_s* noundef %0) #0 !dbg !1462 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i64, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !1463, metadata !DIExpression()), !dbg !1464
  %4 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !1465
  %5 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %4, i32 0, i32 1, !dbg !1466
  call void @vatomic8_write_rlx(%struct.vatomic8_s* noundef %5, i8 noundef zeroext 1), !dbg !1467
  call void @llvm.dbg.declare(metadata i64* %3, metadata !1468, metadata !DIExpression()), !dbg !1470
  store i64 0, i64* %3, align 8, !dbg !1470
  br label %6, !dbg !1471

6:                                                ; preds = %15, %1
  %7 = load i64, i64* %3, align 8, !dbg !1472
  %8 = icmp ult i64 %7, 3, !dbg !1474
  br i1 %8, label %9, label %18, !dbg !1475

9:                                                ; preds = %6
  %10 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !1476
  %11 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %10, i32 0, i32 0, !dbg !1478
  %12 = load i64, i64* %3, align 8, !dbg !1479
  %13 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %11, i64 0, i64 %12, !dbg !1476
  %14 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef %13) #6, !dbg !1480
  br label %15, !dbg !1481

15:                                               ; preds = %9
  %16 = load i64, i64* %3, align 8, !dbg !1482
  %17 = add i64 %16, 1, !dbg !1482
  store i64 %17, i64* %3, align 8, !dbg !1482
  br label %6, !dbg !1483, !llvm.loop !1484

18:                                               ; preds = %6
  ret void, !dbg !1486
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vatomicsz_read_rlx(%struct.vatomicsz_s* noundef %0) #0 !dbg !1487 {
  %2 = alloca %struct.vatomicsz_s*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store %struct.vatomicsz_s* %0, %struct.vatomicsz_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicsz_s** %2, metadata !1492, metadata !DIExpression()), !dbg !1493
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1494, !srcloc !1495
  call void @llvm.dbg.declare(metadata i64* %3, metadata !1496, metadata !DIExpression()), !dbg !1497
  %5 = load %struct.vatomicsz_s*, %struct.vatomicsz_s** %2, align 8, !dbg !1498
  %6 = getelementptr inbounds %struct.vatomicsz_s, %struct.vatomicsz_s* %5, i32 0, i32 0, !dbg !1499
  %7 = load atomic i64, i64* %6 monotonic, align 8, !dbg !1500
  store i64 %7, i64* %4, align 8, !dbg !1500
  %8 = load i64, i64* %4, align 8, !dbg !1500
  store i64 %8, i64* %3, align 8, !dbg !1497
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1501, !srcloc !1502
  %9 = load i64, i64* %3, align 8, !dbg !1503
  ret i64 %9, !dbg !1504
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !1505 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !1506, metadata !DIExpression()), !dbg !1507
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1508, !srcloc !1509
  call void @llvm.dbg.declare(metadata i8** %3, metadata !1510, metadata !DIExpression()), !dbg !1511
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !1512
  %6 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %5, i32 0, i32 0, !dbg !1513
  %7 = bitcast i8** %6 to i64*, !dbg !1514
  %8 = bitcast i8** %4 to i64*, !dbg !1514
  %9 = load atomic i64, i64* %7 monotonic, align 8, !dbg !1514
  store i64 %9, i64* %8, align 8, !dbg !1514
  %10 = bitcast i64* %8 to i8**, !dbg !1514
  %11 = load i8*, i8** %10, align 8, !dbg !1514
  store i8* %11, i8** %3, align 8, !dbg !1511
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1515, !srcloc !1516
  %12 = load i8*, i8** %3, align 8, !dbg !1517
  ret i8* %12, !dbg !1518
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1519 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1522, metadata !DIExpression()), !dbg !1523
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1524, metadata !DIExpression()), !dbg !1525
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1526, !srcloc !1527
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !1528
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !1529
  %8 = load i8*, i8** %4, align 8, !dbg !1530
  store i8* %8, i8** %5, align 8, !dbg !1531
  %9 = bitcast i8** %7 to i64*, !dbg !1531
  %10 = bitcast i8** %5 to i64*, !dbg !1531
  %11 = load i64, i64* %10, align 8, !dbg !1531
  store atomic i64 %11, i64* %9 monotonic, align 8, !dbg !1531
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1532, !srcloc !1533
  ret void, !dbg !1534
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicsz_write_rlx(%struct.vatomicsz_s* noundef %0, i64 noundef %1) #0 !dbg !1535 {
  %3 = alloca %struct.vatomicsz_s*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.vatomicsz_s* %0, %struct.vatomicsz_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicsz_s** %3, metadata !1538, metadata !DIExpression()), !dbg !1539
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1540, metadata !DIExpression()), !dbg !1541
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1542, !srcloc !1543
  %6 = load %struct.vatomicsz_s*, %struct.vatomicsz_s** %3, align 8, !dbg !1544
  %7 = getelementptr inbounds %struct.vatomicsz_s, %struct.vatomicsz_s* %6, i32 0, i32 0, !dbg !1545
  %8 = load i64, i64* %4, align 8, !dbg !1546
  store i64 %8, i64* %5, align 8, !dbg !1547
  %9 = load i64, i64* %5, align 8, !dbg !1547
  store atomic i64 %9, i64* %7 monotonic, align 8, !dbg !1547
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1548, !srcloc !1549
  ret void, !dbg !1550
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_write_release(%struct.rwlock_s* noundef %0) #0 !dbg !1551 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i64, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !1552, metadata !DIExpression()), !dbg !1553
  %4 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !1554
  %5 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %4, i32 0, i32 1, !dbg !1555
  call void @vatomic8_write_rlx(%struct.vatomic8_s* noundef %5, i8 noundef zeroext 0), !dbg !1556
  call void @llvm.dbg.declare(metadata i64* %3, metadata !1557, metadata !DIExpression()), !dbg !1559
  store i64 0, i64* %3, align 8, !dbg !1559
  br label %6, !dbg !1560

6:                                                ; preds = %15, %1
  %7 = load i64, i64* %3, align 8, !dbg !1561
  %8 = icmp ult i64 %7, 3, !dbg !1563
  br i1 %8, label %9, label %18, !dbg !1564

9:                                                ; preds = %6
  %10 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !1565
  %11 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %10, i32 0, i32 0, !dbg !1567
  %12 = load i64, i64* %3, align 8, !dbg !1568
  %13 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %11, i64 0, i64 %12, !dbg !1565
  %14 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef %13) #6, !dbg !1569
  br label %15, !dbg !1570

15:                                               ; preds = %9
  %16 = load i64, i64* %3, align 8, !dbg !1571
  %17 = add i64 %16, 1, !dbg !1571
  store i64 %17, i64* %3, align 8, !dbg !1571
  br label %6, !dbg !1572, !llvm.loop !1573

18:                                               ; preds = %6
  ret void, !dbg !1575
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic8_write_rlx(%struct.vatomic8_s* noundef %0, i8 noundef zeroext %1) #0 !dbg !1576 {
  %3 = alloca %struct.vatomic8_s*, align 8
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
  store %struct.vatomic8_s* %0, %struct.vatomic8_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic8_s** %3, metadata !1580, metadata !DIExpression()), !dbg !1581
  store i8 %1, i8* %4, align 1
  call void @llvm.dbg.declare(metadata i8* %4, metadata !1582, metadata !DIExpression()), !dbg !1583
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1584, !srcloc !1585
  %6 = load %struct.vatomic8_s*, %struct.vatomic8_s** %3, align 8, !dbg !1586
  %7 = getelementptr inbounds %struct.vatomic8_s, %struct.vatomic8_s* %6, i32 0, i32 0, !dbg !1587
  %8 = load i8, i8* %4, align 1, !dbg !1588
  store i8 %8, i8* %5, align 1, !dbg !1589
  %9 = load i8, i8* %5, align 1, !dbg !1589
  store atomic i8 %9, i8* %7 monotonic, align 1, !dbg !1589
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !1590, !srcloc !1591
  ret void, !dbg !1592
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vsimpleht_get(%struct.vsimpleht_s* noundef %0, i64 noundef %1) #0 !dbg !1593 {
  %3 = alloca i8*, align 8
  %4 = alloca %struct.vsimpleht_s*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %4, metadata !1596, metadata !DIExpression()), !dbg !1597
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1598, metadata !DIExpression()), !dbg !1599
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1600, metadata !DIExpression()), !dbg !1601
  store i64 0, i64* %6, align 8, !dbg !1601
  call void @llvm.dbg.declare(metadata i64* %7, metadata !1602, metadata !DIExpression()), !dbg !1603
  store i64 0, i64* %7, align 8, !dbg !1603
  %8 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1604
  call void @_vsimpleht_give_cleanup_a_chance(%struct.vsimpleht_s* noundef %8), !dbg !1605
  %9 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1606
  %10 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %9, i32 0, i32 3, !dbg !1608
  %11 = load i64 (i64)*, i64 (i64)** %10, align 8, !dbg !1608
  %12 = load i64, i64* %5, align 8, !dbg !1609
  %13 = call i64 %11(i64 noundef %12), !dbg !1606
  store i64 %13, i64* %6, align 8, !dbg !1610
  br label %14, !dbg !1611

14:                                               ; preds = %59, %2
  %15 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1612
  %16 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %15, i32 0, i32 0, !dbg !1615
  %17 = load i64, i64* %16, align 8, !dbg !1615
  %18 = sub i64 %17, 1, !dbg !1616
  %19 = load i64, i64* %6, align 8, !dbg !1617
  %20 = and i64 %19, %18, !dbg !1617
  store i64 %20, i64* %6, align 8, !dbg !1617
  %21 = load i64, i64* %6, align 8, !dbg !1618
  %22 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1618
  %23 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %22, i32 0, i32 0, !dbg !1618
  %24 = load i64, i64* %23, align 8, !dbg !1618
  %25 = icmp ult i64 %21, %24, !dbg !1618
  br i1 %25, label %26, label %27, !dbg !1621

26:                                               ; preds = %14
  br label %28, !dbg !1621

27:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.19, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 264, i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @__PRETTY_FUNCTION__.vsimpleht_get, i64 0, i64 0)) #5, !dbg !1618
  unreachable, !dbg !1618

28:                                               ; preds = %26
  %29 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1622
  %30 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %29, i32 0, i32 1, !dbg !1623
  %31 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %30, align 8, !dbg !1623
  %32 = load i64, i64* %6, align 8, !dbg !1624
  %33 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %31, i64 %32, !dbg !1622
  %34 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %33, i32 0, i32 0, !dbg !1625
  %35 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %34), !dbg !1626
  %36 = ptrtoint i8* %35 to i64, !dbg !1627
  store i64 %36, i64* %7, align 8, !dbg !1628
  %37 = load i64, i64* %7, align 8, !dbg !1629
  %38 = icmp eq i64 %37, 0, !dbg !1631
  br i1 %38, label %39, label %40, !dbg !1632

39:                                               ; preds = %28
  store i8* null, i8** %3, align 8, !dbg !1633
  br label %62, !dbg !1633

40:                                               ; preds = %28
  %41 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1635
  %42 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %41, i32 0, i32 2, !dbg !1637
  %43 = load i8 (i64, i64)*, i8 (i64, i64)** %42, align 8, !dbg !1637
  %44 = load i64, i64* %5, align 8, !dbg !1638
  %45 = load i64, i64* %7, align 8, !dbg !1639
  %46 = call signext i8 %43(i64 noundef %44, i64 noundef %45), !dbg !1635
  %47 = sext i8 %46 to i32, !dbg !1635
  %48 = icmp eq i32 %47, 0, !dbg !1640
  br i1 %48, label %49, label %57, !dbg !1641

49:                                               ; preds = %40
  %50 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %4, align 8, !dbg !1642
  %51 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %50, i32 0, i32 1, !dbg !1644
  %52 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %51, align 8, !dbg !1644
  %53 = load i64, i64* %6, align 8, !dbg !1645
  %54 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %52, i64 %53, !dbg !1642
  %55 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %54, i32 0, i32 1, !dbg !1646
  %56 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %55), !dbg !1647
  store i8* %56, i8** %3, align 8, !dbg !1648
  br label %62, !dbg !1648

57:                                               ; preds = %40
  br label %58

58:                                               ; preds = %57
  br label %59, !dbg !1649

59:                                               ; preds = %58
  %60 = load i64, i64* %6, align 8, !dbg !1650
  %61 = add i64 %60, 1, !dbg !1650
  store i64 %61, i64* %6, align 8, !dbg !1650
  br label %14, !dbg !1651, !llvm.loop !1652

62:                                               ; preds = %49, %39
  %63 = load i8*, i8** %3, align 8, !dbg !1655
  ret i8* %63, !dbg !1655
}

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !1656 {
  %5 = alloca %struct.run_info_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8* (i8*)*, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !1659, metadata !DIExpression()), !dbg !1660
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !1661, metadata !DIExpression()), !dbg !1662
  store i8* (i8*)* %2, i8* (i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %7, metadata !1663, metadata !DIExpression()), !dbg !1664
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !1665, metadata !DIExpression()), !dbg !1666
  call void @llvm.dbg.declare(metadata i64* %9, metadata !1667, metadata !DIExpression()), !dbg !1668
  store i64 0, i64* %9, align 8, !dbg !1668
  store i64 0, i64* %9, align 8, !dbg !1669
  br label %11, !dbg !1671

11:                                               ; preds = %42, %4
  %12 = load i64, i64* %9, align 8, !dbg !1672
  %13 = load i64, i64* %6, align 8, !dbg !1674
  %14 = icmp ult i64 %12, %13, !dbg !1675
  br i1 %14, label %15, label %45, !dbg !1676

15:                                               ; preds = %11
  %16 = load i64, i64* %9, align 8, !dbg !1677
  %17 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1679
  %18 = load i64, i64* %9, align 8, !dbg !1680
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %17, i64 %18, !dbg !1679
  %20 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %19, i32 0, i32 1, !dbg !1681
  store i64 %16, i64* %20, align 8, !dbg !1682
  %21 = load i8* (i8*)*, i8* (i8*)** %7, align 8, !dbg !1683
  %22 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1684
  %23 = load i64, i64* %9, align 8, !dbg !1685
  %24 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %22, i64 %23, !dbg !1684
  %25 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %24, i32 0, i32 3, !dbg !1686
  store i8* (i8*)* %21, i8* (i8*)** %25, align 8, !dbg !1687
  %26 = load i8, i8* %8, align 1, !dbg !1688
  %27 = trunc i8 %26 to i1, !dbg !1688
  %28 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1689
  %29 = load i64, i64* %9, align 8, !dbg !1690
  %30 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %28, i64 %29, !dbg !1689
  %31 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %30, i32 0, i32 2, !dbg !1691
  %32 = zext i1 %27 to i8, !dbg !1692
  store i8 %32, i8* %31, align 8, !dbg !1692
  %33 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1693
  %34 = load i64, i64* %9, align 8, !dbg !1694
  %35 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %33, i64 %34, !dbg !1693
  %36 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %35, i32 0, i32 0, !dbg !1695
  %37 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !1696
  %38 = load i64, i64* %9, align 8, !dbg !1697
  %39 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %37, i64 %38, !dbg !1696
  %40 = bitcast %struct.run_info_t* %39 to i8*, !dbg !1698
  %41 = call i32 @pthread_create(i64* noundef %36, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %40) #6, !dbg !1699
  br label %42, !dbg !1700

42:                                               ; preds = %15
  %43 = load i64, i64* %9, align 8, !dbg !1701
  %44 = add i64 %43, 1, !dbg !1701
  store i64 %44, i64* %9, align 8, !dbg !1701
  br label %11, !dbg !1702, !llvm.loop !1703

45:                                               ; preds = %11
  ret void, !dbg !1705
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !1706 {
  %3 = alloca %struct.run_info_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !1709, metadata !DIExpression()), !dbg !1710
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1711, metadata !DIExpression()), !dbg !1712
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1713, metadata !DIExpression()), !dbg !1714
  store i64 0, i64* %5, align 8, !dbg !1714
  store i64 0, i64* %5, align 8, !dbg !1715
  br label %6, !dbg !1717

6:                                                ; preds = %17, %2
  %7 = load i64, i64* %5, align 8, !dbg !1718
  %8 = load i64, i64* %4, align 8, !dbg !1720
  %9 = icmp ult i64 %7, %8, !dbg !1721
  br i1 %9, label %10, label %20, !dbg !1722

10:                                               ; preds = %6
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1723
  %12 = load i64, i64* %5, align 8, !dbg !1725
  %13 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i64 %12, !dbg !1723
  %14 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %13, i32 0, i32 0, !dbg !1726
  %15 = load i64, i64* %14, align 8, !dbg !1726
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !1727
  br label %17, !dbg !1728

17:                                               ; preds = %10
  %18 = load i64, i64* %5, align 8, !dbg !1729
  %19 = add i64 %18, 1, !dbg !1729
  store i64 %19, i64* %5, align 8, !dbg !1729
  br label %6, !dbg !1730, !llvm.loop !1731

20:                                               ; preds = %6
  ret void, !dbg !1733
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !1734 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.run_info_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !1735, metadata !DIExpression()), !dbg !1736
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !1737, metadata !DIExpression()), !dbg !1738
  %4 = load i8*, i8** %2, align 8, !dbg !1739
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !1740
  store %struct.run_info_t* %5, %struct.run_info_t** %3, align 8, !dbg !1738
  %6 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1741
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %6, i32 0, i32 2, !dbg !1743
  %8 = load i8, i8* %7, align 8, !dbg !1743
  %9 = trunc i8 %8 to i1, !dbg !1743
  br i1 %9, label %10, label %14, !dbg !1744

10:                                               ; preds = %1
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1745
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i32 0, i32 1, !dbg !1746
  %13 = load i64, i64* %12, align 8, !dbg !1746
  call void @set_cpu_affinity(i64 noundef %13), !dbg !1747
  br label %14, !dbg !1747

14:                                               ; preds = %10, %1
  %15 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1748
  %16 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %15, i32 0, i32 3, !dbg !1749
  %17 = load i8* (i8*)*, i8* (i8*)** %16, align 8, !dbg !1749
  %18 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !1750
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %18, i32 0, i32 1, !dbg !1751
  %20 = load i64, i64* %19, align 8, !dbg !1751
  %21 = inttoptr i64 %20 to i8*, !dbg !1752
  %22 = call i8* %17(i8* noundef %21), !dbg !1748
  ret i8* %22, !dbg !1753
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !1754 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1755, metadata !DIExpression()), !dbg !1756
  br label %3, !dbg !1757

3:                                                ; preds = %1
  br label %4, !dbg !1758

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !1760
  br label %6, !dbg !1760

6:                                                ; preds = %4
  br label %7, !dbg !1762

7:                                                ; preds = %6
  br label %8, !dbg !1760

8:                                                ; preds = %7
  br label %9, !dbg !1758

9:                                                ; preds = %8
  ret void, !dbg !1764
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_thread_register(%struct.vsimpleht_s* noundef %0) #0 !dbg !1765 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !1766, metadata !DIExpression()), !dbg !1767
  %3 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1768
  %4 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %3, i32 0, i32 7, !dbg !1769
  call void @rwlock_read_acquire(%struct.rwlock_s* noundef %4), !dbg !1770
  ret void, !dbg !1771
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_thread_deregister(%struct.vsimpleht_s* noundef %0) #0 !dbg !1772 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !1773, metadata !DIExpression()), !dbg !1774
  %3 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !1775
  %4 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %3, i32 0, i32 7, !dbg !1776
  call void @rwlock_read_release(%struct.rwlock_s* noundef %4), !dbg !1777
  ret void, !dbg !1778
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @vsimpleht_buff_size(i64 noundef %0) #0 !dbg !1779 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1782, metadata !DIExpression()), !dbg !1783
  %3 = load i64, i64* %2, align 8, !dbg !1784
  %4 = icmp ugt i64 %3, 0, !dbg !1784
  br i1 %4, label %5, label %6, !dbg !1787

5:                                                ; preds = %1
  br label %7, !dbg !1787

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.32, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 128, i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @__PRETTY_FUNCTION__.vsimpleht_buff_size, i64 0, i64 0)) #5, !dbg !1784
  unreachable, !dbg !1784

7:                                                ; preds = %5
  %8 = load i64, i64* %2, align 8, !dbg !1788
  %9 = load i64, i64* %2, align 8, !dbg !1788
  %10 = sub i64 %9, 1, !dbg !1788
  %11 = and i64 %8, %10, !dbg !1788
  %12 = icmp eq i64 %11, 0, !dbg !1788
  br i1 %12, label %13, label %15, !dbg !1788

13:                                               ; preds = %7
  br i1 true, label %14, label %15, !dbg !1791

14:                                               ; preds = %13
  br label %16, !dbg !1791

15:                                               ; preds = %13, %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([66 x i8], [66 x i8]* @.str.34, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 129, i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @__PRETTY_FUNCTION__.vsimpleht_buff_size, i64 0, i64 0)) #5, !dbg !1788
  unreachable, !dbg !1788

16:                                               ; preds = %14
  %17 = load i64, i64* %2, align 8, !dbg !1792
  %18 = mul i64 16, %17, !dbg !1793
  ret i64 %18, !dbg !1794
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_init(%struct.vsimpleht_s* noundef %0, i8* noundef %1, i64 noundef %2, i8 (i64, i64)* noundef %3, i64 (i64)* noundef %4, void (i8*)* noundef %5) #0 !dbg !1795 {
  %7 = alloca %struct.vsimpleht_s*, align 8
  %8 = alloca i8*, align 8
  %9 = alloca i64, align 8
  %10 = alloca i8 (i64, i64)*, align 8
  %11 = alloca i64 (i64)*, align 8
  %12 = alloca void (i8*)*, align 8
  %13 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %7, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %7, metadata !1798, metadata !DIExpression()), !dbg !1799
  store i8* %1, i8** %8, align 8
  call void @llvm.dbg.declare(metadata i8** %8, metadata !1800, metadata !DIExpression()), !dbg !1801
  store i64 %2, i64* %9, align 8
  call void @llvm.dbg.declare(metadata i64* %9, metadata !1802, metadata !DIExpression()), !dbg !1803
  store i8 (i64, i64)* %3, i8 (i64, i64)** %10, align 8
  call void @llvm.dbg.declare(metadata i8 (i64, i64)** %10, metadata !1804, metadata !DIExpression()), !dbg !1805
  store i64 (i64)* %4, i64 (i64)** %11, align 8
  call void @llvm.dbg.declare(metadata i64 (i64)** %11, metadata !1806, metadata !DIExpression()), !dbg !1807
  store void (i8*)* %5, void (i8*)** %12, align 8
  call void @llvm.dbg.declare(metadata void (i8*)** %12, metadata !1808, metadata !DIExpression()), !dbg !1809
  %14 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1810
  %15 = icmp ne %struct.vsimpleht_s* %14, null, !dbg !1810
  br i1 %15, label %16, label %17, !dbg !1813

16:                                               ; preds = %6
  br label %18, !dbg !1813

17:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.35, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 150, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1810
  unreachable, !dbg !1810

18:                                               ; preds = %16
  %19 = load i8*, i8** %8, align 8, !dbg !1814
  %20 = icmp ne i8* %19, null, !dbg !1814
  br i1 %20, label %21, label %22, !dbg !1817

21:                                               ; preds = %18
  br label %23, !dbg !1817

22:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.36, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 151, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1814
  unreachable, !dbg !1814

23:                                               ; preds = %21
  %24 = load i64, i64* %9, align 8, !dbg !1818
  %25 = icmp ugt i64 %24, 0, !dbg !1818
  br i1 %25, label %26, label %27, !dbg !1821

26:                                               ; preds = %23
  br label %28, !dbg !1821

27:                                               ; preds = %23
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.32, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 152, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1818
  unreachable, !dbg !1818

28:                                               ; preds = %26
  %29 = load i64, i64* %9, align 8, !dbg !1822
  %30 = load i64, i64* %9, align 8, !dbg !1822
  %31 = sub i64 %30, 1, !dbg !1822
  %32 = and i64 %29, %31, !dbg !1822
  %33 = icmp eq i64 %32, 0, !dbg !1822
  br i1 %33, label %34, label %36, !dbg !1822

34:                                               ; preds = %28
  br i1 true, label %35, label %36, !dbg !1825

35:                                               ; preds = %34
  br label %37, !dbg !1825

36:                                               ; preds = %34, %28
  call void @__assert_fail(i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.38, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 153, i8* noundef getelementptr inbounds ([122 x i8], [122 x i8]* @__PRETTY_FUNCTION__.vsimpleht_init, i64 0, i64 0)) #5, !dbg !1822
  unreachable, !dbg !1822

37:                                               ; preds = %35
  %38 = load i64, i64* %9, align 8, !dbg !1826
  %39 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1827
  %40 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %39, i32 0, i32 0, !dbg !1828
  store i64 %38, i64* %40, align 8, !dbg !1829
  %41 = load i8*, i8** %8, align 8, !dbg !1830
  %42 = bitcast i8* %41 to %struct.vsimpleht_entry_s*, !dbg !1830
  %43 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1831
  %44 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %43, i32 0, i32 1, !dbg !1832
  store %struct.vsimpleht_entry_s* %42, %struct.vsimpleht_entry_s** %44, align 8, !dbg !1833
  %45 = load i8 (i64, i64)*, i8 (i64, i64)** %10, align 8, !dbg !1834
  %46 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1835
  %47 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %46, i32 0, i32 2, !dbg !1836
  store i8 (i64, i64)* %45, i8 (i64, i64)** %47, align 8, !dbg !1837
  %48 = load i64 (i64)*, i64 (i64)** %11, align 8, !dbg !1838
  %49 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1839
  %50 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %49, i32 0, i32 3, !dbg !1840
  store i64 (i64)* %48, i64 (i64)** %50, align 8, !dbg !1841
  %51 = load void (i8*)*, void (i8*)** %12, align 8, !dbg !1842
  %52 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1843
  %53 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %52, i32 0, i32 4, !dbg !1844
  store void (i8*)* %51, void (i8*)** %53, align 8, !dbg !1845
  call void @llvm.dbg.declare(metadata i64* %13, metadata !1846, metadata !DIExpression()), !dbg !1848
  store i64 0, i64* %13, align 8, !dbg !1848
  br label %54, !dbg !1849

54:                                               ; preds = %73, %37
  %55 = load i64, i64* %13, align 8, !dbg !1850
  %56 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1852
  %57 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %56, i32 0, i32 0, !dbg !1853
  %58 = load i64, i64* %57, align 8, !dbg !1853
  %59 = icmp ult i64 %55, %58, !dbg !1854
  br i1 %59, label %60, label %76, !dbg !1855

60:                                               ; preds = %54
  %61 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1856
  %62 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %61, i32 0, i32 1, !dbg !1858
  %63 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %62, align 8, !dbg !1858
  %64 = load i64, i64* %13, align 8, !dbg !1859
  %65 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %63, i64 %64, !dbg !1856
  %66 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %65, i32 0, i32 0, !dbg !1860
  call void @vatomicptr_init(%struct.vatomicptr_s* noundef %66, i8* noundef null), !dbg !1861
  %67 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1862
  %68 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %67, i32 0, i32 1, !dbg !1863
  %69 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %68, align 8, !dbg !1863
  %70 = load i64, i64* %13, align 8, !dbg !1864
  %71 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %69, i64 %70, !dbg !1862
  %72 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %71, i32 0, i32 1, !dbg !1865
  call void @vatomicptr_init(%struct.vatomicptr_s* noundef %72, i8* noundef null), !dbg !1866
  br label %73, !dbg !1867

73:                                               ; preds = %60
  %74 = load i64, i64* %13, align 8, !dbg !1868
  %75 = add i64 %74, 1, !dbg !1868
  store i64 %75, i64* %13, align 8, !dbg !1868
  br label %54, !dbg !1869, !llvm.loop !1870

76:                                               ; preds = %54
  %77 = load i64, i64* %9, align 8, !dbg !1872
  %78 = udiv i64 %77, 4, !dbg !1873
  %79 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1874
  %80 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %79, i32 0, i32 5, !dbg !1875
  store i64 %78, i64* %80, align 8, !dbg !1876
  %81 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1877
  %82 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %81, i32 0, i32 6, !dbg !1878
  call void @vatomicsz_write_rlx(%struct.vatomicsz_s* noundef %82, i64 noundef 0), !dbg !1879
  %83 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %7, align 8, !dbg !1880
  %84 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %83, i32 0, i32 7, !dbg !1881
  call void @rwlock_init(%struct.rwlock_s* noundef %84), !dbg !1882
  ret void, !dbg !1883
}

; Function Attrs: noinline nounwind uwtable
define internal signext i8 @cb_cmp(i64 noundef %0, i64 noundef %1) #0 !dbg !1884 {
  %3 = alloca i8, align 1
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i64 %0, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1885, metadata !DIExpression()), !dbg !1886
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !1887, metadata !DIExpression()), !dbg !1888
  %6 = load i64, i64* %4, align 8, !dbg !1889
  %7 = load i64, i64* %5, align 8, !dbg !1891
  %8 = icmp eq i64 %6, %7, !dbg !1892
  br i1 %8, label %9, label %10, !dbg !1893

9:                                                ; preds = %2
  store i8 0, i8* %3, align 1, !dbg !1894
  br label %16, !dbg !1894

10:                                               ; preds = %2
  %11 = load i64, i64* %4, align 8, !dbg !1896
  %12 = load i64, i64* %5, align 8, !dbg !1898
  %13 = icmp ult i64 %11, %12, !dbg !1899
  br i1 %13, label %14, label %15, !dbg !1900

14:                                               ; preds = %10
  store i8 -1, i8* %3, align 1, !dbg !1901
  br label %16, !dbg !1901

15:                                               ; preds = %10
  store i8 1, i8* %3, align 1, !dbg !1903
  br label %16, !dbg !1903

16:                                               ; preds = %15, %14, %9
  %17 = load i8, i8* %3, align 1, !dbg !1905
  ret i8 %17, !dbg !1905
}

; Function Attrs: noinline nounwind uwtable
define internal i64 @cb_hash(i64 noundef %0) #0 !dbg !1906 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !1907, metadata !DIExpression()), !dbg !1908
  %3 = load i64, i64* %2, align 8, !dbg !1909
  ret i64 %3, !dbg !1910
}

; Function Attrs: noinline nounwind uwtable
define internal void @cb_destroy(i8* noundef %0) #0 !dbg !1911 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !1912, metadata !DIExpression()), !dbg !1913
  %3 = load i8*, i8** %2, align 8, !dbg !1914
  call void @free(i8* noundef %3) #6, !dbg !1915
  ret void, !dbg !1916
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_init(%struct.trace_s* noundef %0, i64 noundef %1) #0 !dbg !1917 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !1920, metadata !DIExpression()), !dbg !1921
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !1922, metadata !DIExpression()), !dbg !1923
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1924
  %6 = icmp ne %struct.trace_s* %5, null, !dbg !1924
  br i1 %6, label %7, label %8, !dbg !1927

7:                                                ; preds = %2
  br label %9, !dbg !1927

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 36, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !1924
  unreachable, !dbg !1924

9:                                                ; preds = %7
  %10 = load i64, i64* %4, align 8, !dbg !1928
  %11 = mul i64 %10, 16, !dbg !1929
  %12 = call noalias i8* @malloc(i64 noundef %11) #6, !dbg !1930
  %13 = bitcast i8* %12 to %struct.trace_unit_s*, !dbg !1930
  %14 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1931
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 0, !dbg !1932
  store %struct.trace_unit_s* %13, %struct.trace_unit_s** %15, align 8, !dbg !1933
  %16 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1934
  %17 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %16, i32 0, i32 0, !dbg !1936
  %18 = load %struct.trace_unit_s*, %struct.trace_unit_s** %17, align 8, !dbg !1936
  %19 = icmp ne %struct.trace_unit_s* %18, null, !dbg !1934
  br i1 %19, label %20, label %28, !dbg !1937

20:                                               ; preds = %9
  %21 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1938
  %22 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %21, i32 0, i32 1, !dbg !1940
  store i64 0, i64* %22, align 8, !dbg !1941
  %23 = load i64, i64* %4, align 8, !dbg !1942
  %24 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1943
  %25 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %24, i32 0, i32 2, !dbg !1944
  store i64 %23, i64* %25, align 8, !dbg !1945
  %26 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1946
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 3, !dbg !1947
  store i8 1, i8* %27, align 8, !dbg !1948
  br label %35, !dbg !1949

28:                                               ; preds = %9
  %29 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1950
  %30 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %29, i32 0, i32 1, !dbg !1952
  store i64 0, i64* %30, align 8, !dbg !1953
  %31 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1954
  %32 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %31, i32 0, i32 2, !dbg !1955
  store i64 0, i64* %32, align 8, !dbg !1956
  %33 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !1957
  %34 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %33, i32 0, i32 3, !dbg !1958
  store i8 0, i8* %34, align 8, !dbg !1959
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.27, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 46, i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @__PRETTY_FUNCTION__.trace_init, i64 0, i64 0)) #5, !dbg !1960
  unreachable, !dbg !1960

35:                                               ; preds = %20
  ret void, !dbg !1963
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_init(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1964 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1965, metadata !DIExpression()), !dbg !1966
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1967, metadata !DIExpression()), !dbg !1968
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !1969
  %6 = load i8*, i8** %4, align 8, !dbg !1970
  call void @vatomicptr_write(%struct.vatomicptr_s* noundef %5, i8* noundef %6), !dbg !1971
  ret void, !dbg !1972
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_init(%struct.rwlock_s* noundef %0) #0 !dbg !1973 {
  %2 = alloca %struct.rwlock_s*, align 8
  %3 = alloca i64, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !1974, metadata !DIExpression()), !dbg !1975
  call void @llvm.dbg.declare(metadata i64* %3, metadata !1976, metadata !DIExpression()), !dbg !1978
  store i64 0, i64* %3, align 8, !dbg !1978
  br label %4, !dbg !1979

4:                                                ; preds = %13, %1
  %5 = load i64, i64* %3, align 8, !dbg !1980
  %6 = icmp ult i64 %5, 3, !dbg !1982
  br i1 %6, label %7, label %16, !dbg !1983

7:                                                ; preds = %4
  %8 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !1984
  %9 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %8, i32 0, i32 0, !dbg !1986
  %10 = load i64, i64* %3, align 8, !dbg !1987
  %11 = getelementptr inbounds [3 x %union.pthread_mutex_t], [3 x %union.pthread_mutex_t]* %9, i64 0, i64 %10, !dbg !1984
  %12 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef %11, %union.pthread_mutexattr_t* noundef null) #6, !dbg !1988
  br label %13, !dbg !1989

13:                                               ; preds = %7
  %14 = load i64, i64* %3, align 8, !dbg !1990
  %15 = add i64 %14, 1, !dbg !1990
  store i64 %15, i64* %3, align 8, !dbg !1990
  br label %4, !dbg !1991, !llvm.loop !1992

16:                                               ; preds = %4
  ret void, !dbg !1994
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !1995 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !1996, metadata !DIExpression()), !dbg !1997
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1998, metadata !DIExpression()), !dbg !1999
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !2000, !srcloc !2001
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !2002
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !2003
  %8 = load i8*, i8** %4, align 8, !dbg !2004
  store i8* %8, i8** %5, align 8, !dbg !2005
  %9 = bitcast i8** %7 to i64*, !dbg !2005
  %10 = bitcast i8** %5 to i64*, !dbg !2005
  %11 = load i64, i64* %10, align 8, !dbg !2005
  store atomic i64 %11, i64* %9 seq_cst, align 8, !dbg !2005
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !2006, !srcloc !2007
  ret void, !dbg !2008
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @_imap_verify() #0 !dbg !2009 {
  %1 = alloca i64, align 8
  %2 = alloca %struct.data_s*, align 8
  %3 = alloca %struct.vsimpleht_iter_s, align 8
  %4 = alloca %struct.trace_s, align 8
  %5 = alloca %struct.trace_s, align 8
  %6 = alloca %struct.trace_s, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  call void @llvm.dbg.declare(metadata i64* %1, metadata !2010, metadata !DIExpression()), !dbg !2011
  store i64 0, i64* %1, align 8, !dbg !2011
  call void @llvm.dbg.declare(metadata %struct.data_s** %2, metadata !2012, metadata !DIExpression()), !dbg !2013
  store %struct.data_s* null, %struct.data_s** %2, align 8, !dbg !2013
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_iter_s* %3, metadata !2014, metadata !DIExpression()), !dbg !2020
  call void @llvm.dbg.declare(metadata %struct.trace_s* %4, metadata !2021, metadata !DIExpression()), !dbg !2022
  call void @llvm.dbg.declare(metadata %struct.trace_s* %5, metadata !2023, metadata !DIExpression()), !dbg !2024
  call void @llvm.dbg.declare(metadata %struct.trace_s* %6, metadata !2025, metadata !DIExpression()), !dbg !2026
  call void @trace_init(%struct.trace_s* noundef %4, i64 noundef 8), !dbg !2027
  call void @trace_init(%struct.trace_s* noundef %5, i64 noundef 8), !dbg !2028
  call void @llvm.dbg.declare(metadata i64* %7, metadata !2029, metadata !DIExpression()), !dbg !2031
  store i64 0, i64* %7, align 8, !dbg !2031
  br label %9, !dbg !2032

9:                                                ; preds = %17, %0
  %10 = load i64, i64* %7, align 8, !dbg !2033
  %11 = icmp ult i64 %10, 4, !dbg !2035
  br i1 %11, label %12, label %20, !dbg !2036

12:                                               ; preds = %9
  %13 = load i64, i64* %7, align 8, !dbg !2037
  %14 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_add, i64 0, i64 %13, !dbg !2039
  call void @trace_merge_into(%struct.trace_s* noundef %4, %struct.trace_s* noundef %14), !dbg !2040
  %15 = load i64, i64* %7, align 8, !dbg !2041
  %16 = getelementptr inbounds [4 x %struct.trace_s], [4 x %struct.trace_s]* @g_rem, i64 0, i64 %15, !dbg !2042
  call void @trace_merge_into(%struct.trace_s* noundef %5, %struct.trace_s* noundef %16), !dbg !2043
  br label %17, !dbg !2044

17:                                               ; preds = %12
  %18 = load i64, i64* %7, align 8, !dbg !2045
  %19 = add i64 %18, 1, !dbg !2045
  store i64 %19, i64* %7, align 8, !dbg !2045
  br label %9, !dbg !2046, !llvm.loop !2047

20:                                               ; preds = %9
  call void @trace_init(%struct.trace_s* noundef %6, i64 noundef 8), !dbg !2049
  call void @vsimpleht_iter_init(%struct.vsimpleht_s* noundef @g_simpleht, %struct.vsimpleht_iter_s* noundef %3), !dbg !2050
  br label %21, !dbg !2051

21:                                               ; preds = %24, %20
  %22 = bitcast %struct.data_s** %2 to i8**, !dbg !2052
  %23 = call zeroext i1 @vsimpleht_iter_next(%struct.vsimpleht_iter_s* noundef %3, i64* noundef %1, i8** noundef %22), !dbg !2053
  br i1 %23, label %24, label %26, !dbg !2051

24:                                               ; preds = %21
  %25 = load i64, i64* %1, align 8, !dbg !2054
  call void @trace_add(%struct.trace_s* noundef %6, i64 noundef %25), !dbg !2056
  br label %21, !dbg !2051, !llvm.loop !2057

26:                                               ; preds = %21
  call void @trace_subtract_from(%struct.trace_s* noundef %4, %struct.trace_s* noundef %5), !dbg !2059
  call void @llvm.dbg.declare(metadata i8* %8, metadata !2060, metadata !DIExpression()), !dbg !2061
  %27 = call zeroext i1 @trace_is_subtrace(%struct.trace_s* noundef %4, %struct.trace_s* noundef %6, void (i64)* noundef null), !dbg !2062
  %28 = zext i1 %27 to i8, !dbg !2061
  store i8 %28, i8* %8, align 1, !dbg !2061
  call void @trace_destroy(%struct.trace_s* noundef %4), !dbg !2063
  call void @trace_destroy(%struct.trace_s* noundef %5), !dbg !2064
  call void @trace_destroy(%struct.trace_s* noundef %6), !dbg !2065
  %29 = load i8, i8* %8, align 1, !dbg !2066
  %30 = trunc i8 %29 to i1, !dbg !2066
  br i1 %30, label %31, label %33, !dbg !2066

31:                                               ; preds = %26
  br i1 true, label %32, label %33, !dbg !2069

32:                                               ; preds = %31
  br label %34, !dbg !2069

33:                                               ; preds = %31, %26
  call void @__assert_fail(i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.40, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.31, i64 0, i64 0), i32 noundef 109, i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @__PRETTY_FUNCTION__._imap_verify, i64 0, i64 0)) #5, !dbg !2066
  unreachable, !dbg !2066

34:                                               ; preds = %32
  ret void, !dbg !2070
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_destroy(%struct.trace_s* noundef %0) #0 !dbg !2071 {
  %2 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %2, metadata !2072, metadata !DIExpression()), !dbg !2073
  %3 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !2074
  %4 = icmp ne %struct.trace_s* %3, null, !dbg !2074
  br i1 %4, label %5, label %6, !dbg !2077

5:                                                ; preds = %1
  br label %7, !dbg !2077

6:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 100, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !2074
  unreachable, !dbg !2074

7:                                                ; preds = %5
  %8 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !2078
  %9 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %8, i32 0, i32 3, !dbg !2078
  %10 = load i8, i8* %9, align 8, !dbg !2078
  %11 = trunc i8 %10 to i1, !dbg !2078
  br i1 %11, label %12, label %13, !dbg !2081

12:                                               ; preds = %7
  br label %14, !dbg !2081

13:                                               ; preds = %7
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.23, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 101, i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @__PRETTY_FUNCTION__.trace_destroy, i64 0, i64 0)) #5, !dbg !2078
  unreachable, !dbg !2078

14:                                               ; preds = %12
  %15 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !2082
  %16 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %15, i32 0, i32 0, !dbg !2083
  %17 = load %struct.trace_unit_s*, %struct.trace_unit_s** %16, align 8, !dbg !2083
  %18 = bitcast %struct.trace_unit_s* %17 to i8*, !dbg !2082
  call void @free(i8* noundef %18) #6, !dbg !2084
  %19 = load %struct.trace_s*, %struct.trace_s** %2, align 8, !dbg !2085
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 3, !dbg !2086
  store i8 0, i8* %20, align 8, !dbg !2087
  ret void, !dbg !2088
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_destroy(%struct.vsimpleht_s* noundef %0) #0 !dbg !2089 {
  %2 = alloca %struct.vsimpleht_s*, align 8
  %3 = alloca %struct.vsimpleht_entry_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i64, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %2, metadata !2090, metadata !DIExpression()), !dbg !2091
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_entry_s** %3, metadata !2092, metadata !DIExpression()), !dbg !2093
  store %struct.vsimpleht_entry_s* null, %struct.vsimpleht_entry_s** %3, align 8, !dbg !2093
  call void @llvm.dbg.declare(metadata i8** %4, metadata !2094, metadata !DIExpression()), !dbg !2095
  store i8* null, i8** %4, align 8, !dbg !2095
  %6 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !2096
  %7 = icmp ne %struct.vsimpleht_s* %6, null, !dbg !2096
  br i1 %7, label %8, label %9, !dbg !2099

8:                                                ; preds = %1
  br label %10, !dbg !2099

9:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.35, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 182, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__.vsimpleht_destroy, i64 0, i64 0)) #5, !dbg !2096
  unreachable, !dbg !2096

10:                                               ; preds = %8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !2100, metadata !DIExpression()), !dbg !2102
  store i64 0, i64* %5, align 8, !dbg !2102
  br label %11, !dbg !2103

11:                                               ; preds = %34, %10
  %12 = load i64, i64* %5, align 8, !dbg !2104
  %13 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !2106
  %14 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %13, i32 0, i32 0, !dbg !2107
  %15 = load i64, i64* %14, align 8, !dbg !2107
  %16 = icmp ult i64 %12, %15, !dbg !2108
  br i1 %16, label %17, label %37, !dbg !2109

17:                                               ; preds = %11
  %18 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !2110
  %19 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %18, i32 0, i32 1, !dbg !2112
  %20 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %19, align 8, !dbg !2112
  %21 = load i64, i64* %5, align 8, !dbg !2113
  %22 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %20, i64 %21, !dbg !2110
  store %struct.vsimpleht_entry_s* %22, %struct.vsimpleht_entry_s** %3, align 8, !dbg !2114
  %23 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %3, align 8, !dbg !2115
  %24 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %23, i32 0, i32 1, !dbg !2116
  %25 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %24), !dbg !2117
  store i8* %25, i8** %4, align 8, !dbg !2118
  %26 = load i8*, i8** %4, align 8, !dbg !2119
  %27 = icmp ne i8* %26, null, !dbg !2119
  br i1 %27, label %28, label %33, !dbg !2121

28:                                               ; preds = %17
  %29 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %2, align 8, !dbg !2122
  %30 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %29, i32 0, i32 4, !dbg !2124
  %31 = load void (i8*)*, void (i8*)** %30, align 8, !dbg !2124
  %32 = load i8*, i8** %4, align 8, !dbg !2125
  call void %31(i8* noundef %32), !dbg !2122
  br label %33, !dbg !2126

33:                                               ; preds = %28, %17
  br label %34, !dbg !2127

34:                                               ; preds = %33
  %35 = load i64, i64* %5, align 8, !dbg !2128
  %36 = add i64 %35, 1, !dbg !2128
  store i64 %36, i64* %5, align 8, !dbg !2128
  br label %11, !dbg !2129, !llvm.loop !2130

37:                                               ; preds = %11
  ret void, !dbg !2132
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_merge_into(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1) #0 !dbg !2133 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !2136, metadata !DIExpression()), !dbg !2137
  store %struct.trace_s* %1, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !2138, metadata !DIExpression()), !dbg !2139
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !2140
  %6 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !2141
  call void @_trace_merge_or_subtract(%struct.trace_s* noundef %5, %struct.trace_s* noundef %6, i1 noundef zeroext false), !dbg !2142
  ret void, !dbg !2143
}

; Function Attrs: noinline nounwind uwtable
define internal void @vsimpleht_iter_init(%struct.vsimpleht_s* noundef %0, %struct.vsimpleht_iter_s* noundef %1) #0 !dbg !2144 {
  %3 = alloca %struct.vsimpleht_s*, align 8
  %4 = alloca %struct.vsimpleht_iter_s*, align 8
  store %struct.vsimpleht_s* %0, %struct.vsimpleht_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_s** %3, metadata !2148, metadata !DIExpression()), !dbg !2149
  store %struct.vsimpleht_iter_s* %1, %struct.vsimpleht_iter_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_iter_s** %4, metadata !2150, metadata !DIExpression()), !dbg !2151
  %5 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !2152
  %6 = icmp ne %struct.vsimpleht_s* %5, null, !dbg !2152
  br i1 %6, label %7, label %8, !dbg !2155

7:                                                ; preds = %2
  br label %9, !dbg !2155

8:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.35, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 282, i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_init, i64 0, i64 0)) #5, !dbg !2152
  unreachable, !dbg !2152

9:                                                ; preds = %7
  %10 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %4, align 8, !dbg !2156
  %11 = icmp ne %struct.vsimpleht_iter_s* %10, null, !dbg !2156
  br i1 %11, label %12, label %13, !dbg !2159

12:                                               ; preds = %9
  br label %14, !dbg !2159

13:                                               ; preds = %9
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.43, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 283, i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_init, i64 0, i64 0)) #5, !dbg !2156
  unreachable, !dbg !2156

14:                                               ; preds = %12
  %15 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %3, align 8, !dbg !2160
  %16 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %4, align 8, !dbg !2161
  %17 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %16, i32 0, i32 0, !dbg !2162
  store %struct.vsimpleht_s* %15, %struct.vsimpleht_s** %17, align 8, !dbg !2163
  %18 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %4, align 8, !dbg !2164
  %19 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %18, i32 0, i32 1, !dbg !2165
  store i64 0, i64* %19, align 8, !dbg !2166
  ret void, !dbg !2167
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @vsimpleht_iter_next(%struct.vsimpleht_iter_s* noundef %0, i64* noundef %1, i8** noundef %2) #0 !dbg !2168 {
  %4 = alloca i1, align 1
  %5 = alloca %struct.vsimpleht_iter_s*, align 8
  %6 = alloca i64*, align 8
  %7 = alloca i8**, align 8
  %8 = alloca i64, align 8
  %9 = alloca i8*, align 8
  %10 = alloca %struct.vsimpleht_entry_s*, align 8
  %11 = alloca i64, align 8
  store %struct.vsimpleht_iter_s* %0, %struct.vsimpleht_iter_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_iter_s** %5, metadata !2172, metadata !DIExpression()), !dbg !2173
  store i64* %1, i64** %6, align 8
  call void @llvm.dbg.declare(metadata i64** %6, metadata !2174, metadata !DIExpression()), !dbg !2175
  store i8** %2, i8*** %7, align 8
  call void @llvm.dbg.declare(metadata i8*** %7, metadata !2176, metadata !DIExpression()), !dbg !2177
  call void @llvm.dbg.declare(metadata i64* %8, metadata !2178, metadata !DIExpression()), !dbg !2179
  store i64 0, i64* %8, align 8, !dbg !2179
  call void @llvm.dbg.declare(metadata i8** %9, metadata !2180, metadata !DIExpression()), !dbg !2181
  store i8* null, i8** %9, align 8, !dbg !2181
  call void @llvm.dbg.declare(metadata %struct.vsimpleht_entry_s** %10, metadata !2182, metadata !DIExpression()), !dbg !2183
  store %struct.vsimpleht_entry_s* null, %struct.vsimpleht_entry_s** %10, align 8, !dbg !2183
  %12 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !2184
  %13 = icmp ne %struct.vsimpleht_iter_s* %12, null, !dbg !2184
  br i1 %13, label %14, label %15, !dbg !2187

14:                                               ; preds = %3
  br label %16, !dbg !2187

15:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.43, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 322, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !2184
  unreachable, !dbg !2184

16:                                               ; preds = %14
  %17 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !2188
  %18 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %17, i32 0, i32 0, !dbg !2188
  %19 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %18, align 8, !dbg !2188
  %20 = icmp ne %struct.vsimpleht_s* %19, null, !dbg !2188
  br i1 %20, label %21, label %22, !dbg !2191

21:                                               ; preds = %16
  br label %23, !dbg !2191

22:                                               ; preds = %16
  call void @__assert_fail(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.44, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 323, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !2188
  unreachable, !dbg !2188

23:                                               ; preds = %21
  %24 = load i64*, i64** %6, align 8, !dbg !2192
  %25 = icmp ne i64* %24, null, !dbg !2192
  br i1 %25, label %26, label %27, !dbg !2195

26:                                               ; preds = %23
  br label %28, !dbg !2195

27:                                               ; preds = %23
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.45, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 324, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !2192
  unreachable, !dbg !2192

28:                                               ; preds = %26
  %29 = load i8**, i8*** %7, align 8, !dbg !2196
  %30 = icmp ne i8** %29, null, !dbg !2196
  br i1 %30, label %31, label %32, !dbg !2199

31:                                               ; preds = %28
  br label %33, !dbg !2199

32:                                               ; preds = %28
  call void @__assert_fail(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.46, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 325, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !2196
  unreachable, !dbg !2196

33:                                               ; preds = %31
  %34 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !2200
  %35 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %34, i32 0, i32 0, !dbg !2201
  %36 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %35, align 8, !dbg !2201
  %37 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %36, i32 0, i32 1, !dbg !2202
  %38 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %37, align 8, !dbg !2202
  store %struct.vsimpleht_entry_s* %38, %struct.vsimpleht_entry_s** %10, align 8, !dbg !2203
  %39 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !2204
  %40 = icmp ne %struct.vsimpleht_entry_s* %39, null, !dbg !2204
  br i1 %40, label %41, label %42, !dbg !2207

41:                                               ; preds = %33
  br label %43, !dbg !2207

42:                                               ; preds = %33
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.47, i64 0, i64 0), i8* noundef getelementptr inbounds ([52 x i8], [52 x i8]* @.str.9, i64 0, i64 0), i32 noundef 327, i8* noundef getelementptr inbounds ([71 x i8], [71 x i8]* @__PRETTY_FUNCTION__.vsimpleht_iter_next, i64 0, i64 0)) #5, !dbg !2204
  unreachable, !dbg !2204

43:                                               ; preds = %41
  call void @llvm.dbg.declare(metadata i64* %11, metadata !2208, metadata !DIExpression()), !dbg !2210
  %44 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !2211
  %45 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %44, i32 0, i32 1, !dbg !2212
  %46 = load i64, i64* %45, align 8, !dbg !2212
  store i64 %46, i64* %11, align 8, !dbg !2210
  br label %47, !dbg !2213

47:                                               ; preds = %82, %43
  %48 = load i64, i64* %11, align 8, !dbg !2214
  %49 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !2216
  %50 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %49, i32 0, i32 0, !dbg !2217
  %51 = load %struct.vsimpleht_s*, %struct.vsimpleht_s** %50, align 8, !dbg !2217
  %52 = getelementptr inbounds %struct.vsimpleht_s, %struct.vsimpleht_s* %51, i32 0, i32 0, !dbg !2218
  %53 = load i64, i64* %52, align 8, !dbg !2218
  %54 = icmp ult i64 %48, %53, !dbg !2219
  br i1 %54, label %55, label %85, !dbg !2220

55:                                               ; preds = %47
  %56 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !2221
  %57 = load i64, i64* %11, align 8, !dbg !2223
  %58 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %56, i64 %57, !dbg !2221
  %59 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %58, i32 0, i32 0, !dbg !2224
  %60 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %59), !dbg !2225
  %61 = ptrtoint i8* %60 to i64, !dbg !2226
  store i64 %61, i64* %8, align 8, !dbg !2227
  %62 = load %struct.vsimpleht_entry_s*, %struct.vsimpleht_entry_s** %10, align 8, !dbg !2228
  %63 = load i64, i64* %11, align 8, !dbg !2229
  %64 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %62, i64 %63, !dbg !2228
  %65 = getelementptr inbounds %struct.vsimpleht_entry_s, %struct.vsimpleht_entry_s* %64, i32 0, i32 1, !dbg !2230
  %66 = call i8* @vatomicptr_read(%struct.vatomicptr_s* noundef %65), !dbg !2231
  store i8* %66, i8** %9, align 8, !dbg !2232
  %67 = load i64, i64* %8, align 8, !dbg !2233
  %68 = icmp ne i64 %67, 0, !dbg !2233
  br i1 %68, label %69, label %81, !dbg !2235

69:                                               ; preds = %55
  %70 = load i8*, i8** %9, align 8, !dbg !2236
  %71 = icmp ne i8* %70, null, !dbg !2236
  br i1 %71, label %72, label %81, !dbg !2237

72:                                               ; preds = %69
  %73 = load i64, i64* %11, align 8, !dbg !2238
  %74 = add i64 %73, 1, !dbg !2240
  %75 = load %struct.vsimpleht_iter_s*, %struct.vsimpleht_iter_s** %5, align 8, !dbg !2241
  %76 = getelementptr inbounds %struct.vsimpleht_iter_s, %struct.vsimpleht_iter_s* %75, i32 0, i32 1, !dbg !2242
  store i64 %74, i64* %76, align 8, !dbg !2243
  %77 = load i64, i64* %8, align 8, !dbg !2244
  %78 = load i64*, i64** %6, align 8, !dbg !2245
  store i64 %77, i64* %78, align 8, !dbg !2246
  %79 = load i8*, i8** %9, align 8, !dbg !2247
  %80 = load i8**, i8*** %7, align 8, !dbg !2248
  store i8* %79, i8** %80, align 8, !dbg !2249
  store i1 true, i1* %4, align 1, !dbg !2250
  br label %86, !dbg !2250

81:                                               ; preds = %69, %55
  br label %82, !dbg !2251

82:                                               ; preds = %81
  %83 = load i64, i64* %11, align 8, !dbg !2252
  %84 = add i64 %83, 1, !dbg !2252
  store i64 %84, i64* %11, align 8, !dbg !2252
  br label %47, !dbg !2253, !llvm.loop !2254

85:                                               ; preds = %47
  store i1 false, i1* %4, align 1, !dbg !2256
  br label %86, !dbg !2256

86:                                               ; preds = %85, %72
  %87 = load i1, i1* %4, align 1, !dbg !2257
  ret i1 %87, !dbg !2257
}

; Function Attrs: noinline nounwind uwtable
define internal void @trace_subtract_from(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1) #0 !dbg !2258 {
  %3 = alloca %struct.trace_s*, align 8
  %4 = alloca %struct.trace_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %3, metadata !2259, metadata !DIExpression()), !dbg !2260
  store %struct.trace_s* %1, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !2261, metadata !DIExpression()), !dbg !2262
  %5 = load %struct.trace_s*, %struct.trace_s** %3, align 8, !dbg !2263
  %6 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !2264
  call void @_trace_merge_or_subtract(%struct.trace_s* noundef %5, %struct.trace_s* noundef %6, i1 noundef zeroext true), !dbg !2265
  ret void, !dbg !2266
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @trace_is_subtrace(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1, void (i64)* noundef %2) #0 !dbg !2267 {
  %4 = alloca i1, align 1
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca %struct.trace_s*, align 8
  %7 = alloca void (i64)*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca %struct.trace_unit_s*, align 8
  %11 = alloca %struct.trace_unit_s*, align 8
  store %struct.trace_s* %0, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !2273, metadata !DIExpression()), !dbg !2274
  store %struct.trace_s* %1, %struct.trace_s** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %6, metadata !2275, metadata !DIExpression()), !dbg !2276
  store void (i64)* %2, void (i64)** %7, align 8
  call void @llvm.dbg.declare(metadata void (i64)** %7, metadata !2277, metadata !DIExpression()), !dbg !2278
  call void @llvm.dbg.declare(metadata i64* %8, metadata !2279, metadata !DIExpression()), !dbg !2280
  store i64 0, i64* %8, align 8, !dbg !2280
  call void @llvm.dbg.declare(metadata i64* %9, metadata !2281, metadata !DIExpression()), !dbg !2282
  store i64 0, i64* %9, align 8, !dbg !2282
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %10, metadata !2283, metadata !DIExpression()), !dbg !2284
  call void @llvm.dbg.declare(metadata %struct.trace_unit_s** %11, metadata !2285, metadata !DIExpression()), !dbg !2286
  store i64 0, i64* %8, align 8, !dbg !2287
  br label %12, !dbg !2289

12:                                               ; preds = %86, %3
  %13 = load i64, i64* %8, align 8, !dbg !2290
  %14 = load %struct.trace_s*, %struct.trace_s** %6, align 8, !dbg !2292
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 1, !dbg !2293
  %16 = load i64, i64* %15, align 8, !dbg !2293
  %17 = icmp ult i64 %13, %16, !dbg !2294
  br i1 %17, label %18, label %89, !dbg !2295

18:                                               ; preds = %12
  %19 = load %struct.trace_s*, %struct.trace_s** %6, align 8, !dbg !2296
  %20 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %19, i32 0, i32 0, !dbg !2298
  %21 = load %struct.trace_unit_s*, %struct.trace_unit_s** %20, align 8, !dbg !2298
  %22 = load i64, i64* %8, align 8, !dbg !2299
  %23 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %21, i64 %22, !dbg !2296
  store %struct.trace_unit_s* %23, %struct.trace_unit_s** %10, align 8, !dbg !2300
  %24 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !2301
  %25 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2303
  %26 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %25, i32 0, i32 0, !dbg !2304
  %27 = load i64, i64* %26, align 8, !dbg !2304
  %28 = call zeroext i1 @trace_find_unit_idx(%struct.trace_s* noundef %24, i64 noundef %27, i64* noundef %9), !dbg !2305
  br i1 %28, label %29, label %72, !dbg !2306

29:                                               ; preds = %18
  %30 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !2307
  %31 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %30, i32 0, i32 0, !dbg !2309
  %32 = load %struct.trace_unit_s*, %struct.trace_unit_s** %31, align 8, !dbg !2309
  %33 = load i64, i64* %9, align 8, !dbg !2310
  %34 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %32, i64 %33, !dbg !2307
  store %struct.trace_unit_s* %34, %struct.trace_unit_s** %11, align 8, !dbg !2311
  %35 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2312
  %36 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %35, i32 0, i32 0, !dbg !2312
  %37 = load i64, i64* %36, align 8, !dbg !2312
  %38 = load %struct.trace_unit_s*, %struct.trace_unit_s** %11, align 8, !dbg !2312
  %39 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %38, i32 0, i32 0, !dbg !2312
  %40 = load i64, i64* %39, align 8, !dbg !2312
  %41 = icmp eq i64 %37, %40, !dbg !2312
  br i1 %41, label %42, label %43, !dbg !2315

42:                                               ; preds = %29
  br label %44, !dbg !2315

43:                                               ; preds = %29
  call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.48, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 308, i8* noundef getelementptr inbounds ([70 x i8], [70 x i8]* @__PRETTY_FUNCTION__.trace_is_subtrace, i64 0, i64 0)) #5, !dbg !2312
  unreachable, !dbg !2312

44:                                               ; preds = %42
  %45 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2316
  %46 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %45, i32 0, i32 1, !dbg !2318
  %47 = load i64, i64* %46, align 8, !dbg !2318
  %48 = load %struct.trace_unit_s*, %struct.trace_unit_s** %11, align 8, !dbg !2319
  %49 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %48, i32 0, i32 1, !dbg !2320
  %50 = load i64, i64* %49, align 8, !dbg !2320
  %51 = icmp ne i64 %47, %50, !dbg !2321
  br i1 %51, label %52, label %71, !dbg !2322

52:                                               ; preds = %44
  %53 = load void (i64)*, void (i64)** %7, align 8, !dbg !2323
  %54 = icmp ne void (i64)* %53, null, !dbg !2323
  br i1 %54, label %55, label %70, !dbg !2326

55:                                               ; preds = %52
  %56 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2327
  %57 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %56, i32 0, i32 0, !dbg !2329
  %58 = load i64, i64* %57, align 8, !dbg !2329
  %59 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2330
  %60 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %59, i32 0, i32 1, !dbg !2331
  %61 = load i64, i64* %60, align 8, !dbg !2331
  %62 = load %struct.trace_unit_s*, %struct.trace_unit_s** %11, align 8, !dbg !2332
  %63 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %62, i32 0, i32 1, !dbg !2333
  %64 = load i64, i64* %63, align 8, !dbg !2333
  %65 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @.str.49, i64 0, i64 0), i64 noundef %58, i64 noundef %61, i64 noundef %64), !dbg !2334
  %66 = load void (i64)*, void (i64)** %7, align 8, !dbg !2335
  %67 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2336
  %68 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %67, i32 0, i32 0, !dbg !2337
  %69 = load i64, i64* %68, align 8, !dbg !2337
  call void %66(i64 noundef %69), !dbg !2335
  br label %70, !dbg !2338

70:                                               ; preds = %55, %52
  store i1 false, i1* %4, align 1, !dbg !2339
  br label %90, !dbg !2339

71:                                               ; preds = %44
  br label %85, !dbg !2340

72:                                               ; preds = %18
  %73 = load void (i64)*, void (i64)** %7, align 8, !dbg !2341
  %74 = icmp ne void (i64)* %73, null, !dbg !2341
  br i1 %74, label %75, label %84, !dbg !2344

75:                                               ; preds = %72
  %76 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2345
  %77 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %76, i32 0, i32 0, !dbg !2347
  %78 = load i64, i64* %77, align 8, !dbg !2347
  %79 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.50, i64 0, i64 0), i64 noundef %78), !dbg !2348
  %80 = load void (i64)*, void (i64)** %7, align 8, !dbg !2349
  %81 = load %struct.trace_unit_s*, %struct.trace_unit_s** %10, align 8, !dbg !2350
  %82 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %81, i32 0, i32 0, !dbg !2351
  %83 = load i64, i64* %82, align 8, !dbg !2351
  call void %80(i64 noundef %83), !dbg !2349
  br label %84, !dbg !2352

84:                                               ; preds = %75, %72
  store i1 false, i1* %4, align 1, !dbg !2353
  br label %90, !dbg !2353

85:                                               ; preds = %71
  br label %86, !dbg !2354

86:                                               ; preds = %85
  %87 = load i64, i64* %8, align 8, !dbg !2355
  %88 = add i64 %87, 1, !dbg !2355
  store i64 %88, i64* %8, align 8, !dbg !2355
  br label %12, !dbg !2356, !llvm.loop !2357

89:                                               ; preds = %12
  store i1 true, i1* %4, align 1, !dbg !2359
  br label %90, !dbg !2359

90:                                               ; preds = %89, %84, %70
  %91 = load i1, i1* %4, align 1, !dbg !2360
  ret i1 %91, !dbg !2360
}

; Function Attrs: noinline nounwind uwtable
define internal void @_trace_merge_or_subtract(%struct.trace_s* noundef %0, %struct.trace_s* noundef %1, i1 noundef zeroext %2) #0 !dbg !2361 {
  %4 = alloca %struct.trace_s*, align 8
  %5 = alloca %struct.trace_s*, align 8
  %6 = alloca i8, align 1
  %7 = alloca i64, align 8
  store %struct.trace_s* %0, %struct.trace_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %4, metadata !2364, metadata !DIExpression()), !dbg !2365
  store %struct.trace_s* %1, %struct.trace_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.trace_s** %5, metadata !2366, metadata !DIExpression()), !dbg !2367
  %8 = zext i1 %2 to i8
  store i8 %8, i8* %6, align 1
  call void @llvm.dbg.declare(metadata i8* %6, metadata !2368, metadata !DIExpression()), !dbg !2369
  call void @llvm.dbg.declare(metadata i64* %7, metadata !2370, metadata !DIExpression()), !dbg !2371
  store i64 0, i64* %7, align 8, !dbg !2371
  %9 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !2372
  %10 = icmp ne %struct.trace_s* %9, null, !dbg !2372
  br i1 %10, label %11, label %12, !dbg !2375

11:                                               ; preds = %3
  br label %13, !dbg !2375

12:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.41, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 165, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !2372
  unreachable, !dbg !2372

13:                                               ; preds = %11
  %14 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !2376
  %15 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %14, i32 0, i32 3, !dbg !2376
  %16 = load i8, i8* %15, align 8, !dbg !2376
  %17 = trunc i8 %16 to i1, !dbg !2376
  br i1 %17, label %18, label %19, !dbg !2379

18:                                               ; preds = %13
  br label %20, !dbg !2379

19:                                               ; preds = %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.42, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 166, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !2376
  unreachable, !dbg !2376

20:                                               ; preds = %18
  %21 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !2380
  %22 = icmp ne %struct.trace_s* %21, null, !dbg !2380
  br i1 %22, label %23, label %24, !dbg !2383

23:                                               ; preds = %20
  br label %25, !dbg !2383

24:                                               ; preds = %20
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.21, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 168, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !2380
  unreachable, !dbg !2380

25:                                               ; preds = %23
  %26 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !2384
  %27 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %26, i32 0, i32 3, !dbg !2384
  %28 = load i8, i8* %27, align 8, !dbg !2384
  %29 = trunc i8 %28 to i1, !dbg !2384
  br i1 %29, label %30, label %31, !dbg !2387

30:                                               ; preds = %25
  br label %32, !dbg !2387

31:                                               ; preds = %25
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.23, i64 0, i64 0), i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @.str.22, i64 0, i64 0), i32 noundef 169, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__._trace_merge_or_subtract, i64 0, i64 0)) #5, !dbg !2384
  unreachable, !dbg !2384

32:                                               ; preds = %30
  store i64 0, i64* %7, align 8, !dbg !2388
  br label %33, !dbg !2390

33:                                               ; preds = %57, %32
  %34 = load i64, i64* %7, align 8, !dbg !2391
  %35 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !2393
  %36 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %35, i32 0, i32 1, !dbg !2394
  %37 = load i64, i64* %36, align 8, !dbg !2394
  %38 = icmp ult i64 %34, %37, !dbg !2395
  br i1 %38, label %39, label %60, !dbg !2396

39:                                               ; preds = %33
  %40 = load %struct.trace_s*, %struct.trace_s** %4, align 8, !dbg !2397
  %41 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !2399
  %42 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %41, i32 0, i32 0, !dbg !2400
  %43 = load %struct.trace_unit_s*, %struct.trace_unit_s** %42, align 8, !dbg !2400
  %44 = load i64, i64* %7, align 8, !dbg !2401
  %45 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %43, i64 %44, !dbg !2399
  %46 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %45, i32 0, i32 0, !dbg !2402
  %47 = load i64, i64* %46, align 8, !dbg !2402
  %48 = load %struct.trace_s*, %struct.trace_s** %5, align 8, !dbg !2403
  %49 = getelementptr inbounds %struct.trace_s, %struct.trace_s* %48, i32 0, i32 0, !dbg !2404
  %50 = load %struct.trace_unit_s*, %struct.trace_unit_s** %49, align 8, !dbg !2404
  %51 = load i64, i64* %7, align 8, !dbg !2405
  %52 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %50, i64 %51, !dbg !2403
  %53 = getelementptr inbounds %struct.trace_unit_s, %struct.trace_unit_s* %52, i32 0, i32 1, !dbg !2406
  %54 = load i64, i64* %53, align 8, !dbg !2406
  %55 = load i8, i8* %6, align 1, !dbg !2407
  %56 = trunc i8 %55 to i1, !dbg !2407
  call void @_trace_add_or_rem_occurrences(%struct.trace_s* noundef %40, i64 noundef %47, i64 noundef %54, i1 noundef zeroext %56), !dbg !2408
  br label %57, !dbg !2409

57:                                               ; preds = %39
  %58 = load i64, i64* %7, align 8, !dbg !2410
  %59 = add i64 %58, 1, !dbg !2410
  store i64 %59, i64* %7, align 8, !dbg !2410
  br label %33, !dbg !2411, !llvm.loop !2412

60:                                               ; preds = %33
  ret void, !dbg !2414
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
!llvm.module.flags = !{!177, !178, !179, !180, !181, !182, !183}
!llvm.ident = !{!184}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_tid", scope: !2, file: !106, line: 29, type: !29, isLocal: false, isDefinition: true)
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
!53 = !{!0, !54, !57, !59, !154, !173, !175}
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "g_added", scope: !2, file: !56, line: 14, type: !42, isLocal: false, isDefinition: true)
!56 = !DIFile(filename: "verify/simpleht/test_case_add_get_rem.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "b93db6fa5c5fe23433ed2d55a649cdfb")
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "g_got_nw_val", scope: !2, file: !56, line: 15, type: !42, isLocal: false, isDefinition: true)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "g_simpleht", scope: !2, file: !61, line: 35, type: !62, isLocal: true, isDefinition: true)
!61 = !DIFile(filename: "test/include/test/map/isimple.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "9bd6bf935fca0aec8816b4ad5eb860a6")
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_t", file: !6, line: 94, baseType: !63)
!63 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vsimpleht_s", file: !6, line: 83, size: 1472, elements: !64)
!64 = !{!65, !66, !78, !88, !93, !98, !99, !104}
!65 = !DIDerivedType(tag: DW_TAG_member, name: "capacity", scope: !63, file: !6, line: 84, baseType: !14, size: 64)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "entries", scope: !63, file: !6, line: 85, baseType: !67, size: 64, offset: 64)
!67 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !68, size: 64)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_entry_t", file: !6, line: 81, baseType: !69)
!69 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vsimpleht_entry_s", file: !6, line: 78, size: 128, elements: !70)
!70 = !{!71, !77}
!71 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !69, file: !6, line: 79, baseType: !72, size: 64, align: 64)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomicptr_t", file: !73, line: 45, baseType: !74)
!73 = !DIFile(filename: "vatomic/include/vsync/atomic/internal/types.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "4649bfff29481cecec17d9044409fd19")
!74 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomicptr_s", file: !73, line: 43, size: 64, align: 64, elements: !75)
!75 = !{!76}
!76 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !74, file: !73, line: 44, baseType: !22, size: 64)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !69, file: !6, line: 80, baseType: !72, size: 64, align: 64, offset: 64)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "cmp_key", scope: !63, file: !6, line: 86, baseType: !79, size: 64, offset: 128)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_cmp_key_t", file: !6, line: 74, baseType: !80)
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!81 = !DISubroutineType(types: !82)
!82 = !{!83, !19, !19}
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "vint8_t", file: !15, line: 40, baseType: !84)
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !85, line: 24, baseType: !86)
!85 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "", checksumkind: CSK_MD5, checksum: "55bcbdc3159515ebd91d351a70d505f4")
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !27, line: 37, baseType: !87)
!87 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "hash_key", scope: !63, file: !6, line: 87, baseType: !89, size: 64, offset: 192)
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_hash_key_t", file: !6, line: 75, baseType: !90)
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !91, size: 64)
!91 = !DISubroutineType(types: !92)
!92 = !{!49, !19}
!93 = !DIDerivedType(tag: DW_TAG_member, name: "cb_destroy", scope: !63, file: !6, line: 88, baseType: !94, size: 64, offset: 256)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_destroy_entry_t", file: !6, line: 76, baseType: !95)
!95 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !96, size: 64)
!96 = !DISubroutineType(types: !97)
!97 = !{null, !22}
!98 = !DIDerivedType(tag: DW_TAG_member, name: "cleaning_threshold", scope: !63, file: !6, line: 90, baseType: !14, size: 64, offset: 320)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "deleted_count", scope: !63, file: !6, line: 91, baseType: !100, size: 64, align: 64, offset: 384)
!100 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomicsz_t", file: !73, line: 50, baseType: !101)
!101 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomicsz_s", file: !73, line: 48, size: 64, align: 64, elements: !102)
!102 = !{!103}
!103 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !101, file: !73, line: 49, baseType: !14, size: 64)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !63, file: !6, line: 92, baseType: !105, size: 1024, offset: 448)
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "rwlock_t", file: !106, line: 27, baseType: !107)
!106 = !DIFile(filename: "verify/include/verify/rwlock.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "d22ae5b6c849e685e5cacdc91023be13")
!107 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "rwlock_s", file: !106, line: 23, size: 1024, elements: !108)
!108 = !{!109, !144, !149}
!109 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !107, file: !106, line: 24, baseType: !110, size: 960)
!110 = !DICompositeType(tag: DW_TAG_array_type, baseType: !111, size: 960, elements: !142)
!111 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !39, line: 72, baseType: !112)
!112 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !39, line: 67, size: 320, elements: !113)
!113 = !{!114, !135, !140}
!114 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !112, file: !39, line: 69, baseType: !115, size: 320)
!115 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !116, line: 22, size: 320, elements: !117)
!116 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "584baedd80e6041b81caae7f496091c0")
!117 = !{!118, !120, !121, !122, !123, !124, !126, !127}
!118 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !115, file: !116, line: 24, baseType: !119, size: 32)
!119 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !115, file: !116, line: 25, baseType: !7, size: 32, offset: 32)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !115, file: !116, line: 26, baseType: !119, size: 32, offset: 64)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !115, file: !116, line: 28, baseType: !7, size: 32, offset: 96)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !115, file: !116, line: 32, baseType: !119, size: 32, offset: 128)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !115, file: !116, line: 34, baseType: !125, size: 16, offset: 160)
!125 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !115, file: !116, line: 35, baseType: !125, size: 16, offset: 176)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !115, file: !116, line: 36, baseType: !128, size: 128, offset: 192)
!128 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !129, line: 55, baseType: !130)
!129 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "04c81e86d34dad9c99ad006d32e47a0d")
!130 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !129, line: 51, size: 128, elements: !131)
!131 = !{!132, !134}
!132 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !130, file: !129, line: 53, baseType: !133, size: 64)
!133 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !130, size: 64)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !130, file: !129, line: 54, baseType: !133, size: 64, offset: 64)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !112, file: !39, line: 70, baseType: !136, size: 320)
!136 = !DICompositeType(tag: DW_TAG_array_type, baseType: !137, size: 320, elements: !138)
!137 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!138 = !{!139}
!139 = !DISubrange(count: 40)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !112, file: !39, line: 71, baseType: !141, size: 64)
!141 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!142 = !{!143}
!143 = !DISubrange(count: 3)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "writer_active", scope: !107, file: !106, line: 25, baseType: !145, size: 8, offset: 960)
!145 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic8_t", file: !73, line: 25, baseType: !146)
!146 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic8_s", file: !73, line: 23, size: 8, elements: !147)
!147 = !{!148}
!148 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !146, file: !73, line: 24, baseType: !23, size: 8)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "idx", scope: !107, file: !106, line: 26, baseType: !150, size: 32, align: 32, offset: 992)
!150 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !73, line: 35, baseType: !151)
!151 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !73, line: 33, size: 32, align: 32, elements: !152)
!152 = !{!153}
!153 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !151, file: !73, line: 34, baseType: !29, size: 32)
!154 = !DIGlobalVariableExpression(var: !155, expr: !DIExpression())
!155 = distinct !DIGlobalVariable(name: "g_add", scope: !2, file: !61, line: 33, type: !156, isLocal: true, isDefinition: true)
!156 = !DICompositeType(tag: DW_TAG_array_type, baseType: !157, size: 1024, elements: !171)
!157 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_t", file: !158, line: 29, baseType: !159)
!158 = !DIFile(filename: "test/include/test/trace_manager.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "5ba0f33a5901d8ee1ef7d1e8c3546fa0")
!159 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_s", file: !158, line: 24, size: 256, elements: !160)
!160 = !{!161, !168, !169, !170}
!161 = !DIDerivedType(tag: DW_TAG_member, name: "units", scope: !159, file: !158, line: 25, baseType: !162, size: 64)
!162 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !163, size: 64)
!163 = !DIDerivedType(tag: DW_TAG_typedef, name: "trace_unit_t", file: !158, line: 22, baseType: !164)
!164 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_unit_s", file: !158, line: 19, size: 128, elements: !165)
!165 = !{!166, !167}
!166 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !164, file: !158, line: 20, baseType: !19, size: 64)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !164, file: !158, line: 21, baseType: !14, size: 64, offset: 64)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !159, file: !158, line: 26, baseType: !14, size: 64, offset: 64)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "capacity", scope: !159, file: !158, line: 27, baseType: !14, size: 64, offset: 128)
!170 = !DIDerivedType(tag: DW_TAG_member, name: "initialized", scope: !159, file: !158, line: 28, baseType: !42, size: 8, offset: 192)
!171 = !{!172}
!172 = !DISubrange(count: 4)
!173 = !DIGlobalVariableExpression(var: !174, expr: !DIExpression())
!174 = distinct !DIGlobalVariable(name: "g_rem", scope: !2, file: !61, line: 34, type: !156, isLocal: true, isDefinition: true)
!175 = !DIGlobalVariableExpression(var: !176, expr: !DIExpression())
!176 = distinct !DIGlobalVariable(name: "g_buff", scope: !2, file: !61, line: 36, type: !22, isLocal: true, isDefinition: true)
!177 = !{i32 7, !"Dwarf Version", i32 5}
!178 = !{i32 2, !"Debug Info Version", i32 3}
!179 = !{i32 1, !"wchar_size", i32 4}
!180 = !{i32 7, !"PIC Level", i32 2}
!181 = !{i32 7, !"PIE Level", i32 2}
!182 = !{i32 7, !"uwtable", i32 1}
!183 = !{i32 7, !"frame-pointer", i32 2}
!184 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!185 = distinct !DISubprogram(name: "pre", scope: !56, file: !56, line: 18, type: !186, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !188)
!186 = !DISubroutineType(types: !187)
!187 = !{null}
!188 = !{}
!189 = !DILocalVariable(name: "k", scope: !190, file: !56, line: 20, type: !19)
!190 = distinct !DILexicalBlock(scope: !185, file: !56, line: 20, column: 5)
!191 = !DILocation(line: 20, column: 21, scope: !190)
!192 = !DILocation(line: 20, column: 10, scope: !190)
!193 = !DILocation(line: 20, column: 34, scope: !194)
!194 = distinct !DILexicalBlock(scope: !190, file: !56, line: 20, column: 5)
!195 = !DILocation(line: 20, column: 36, scope: !194)
!196 = !DILocation(line: 20, column: 5, scope: !190)
!197 = !DILocalVariable(name: "success", scope: !198, file: !56, line: 21, type: !42)
!198 = distinct !DILexicalBlock(scope: !194, file: !56, line: 20, column: 53)
!199 = !DILocation(line: 21, column: 17, scope: !198)
!200 = !DILocation(line: 21, column: 46, scope: !198)
!201 = !DILocation(line: 21, column: 49, scope: !198)
!202 = !DILocation(line: 21, column: 27, scope: !198)
!203 = !DILocation(line: 22, column: 9, scope: !204)
!204 = distinct !DILexicalBlock(scope: !205, file: !56, line: 22, column: 9)
!205 = distinct !DILexicalBlock(scope: !198, file: !56, line: 22, column: 9)
!206 = !DILocation(line: 22, column: 9, scope: !205)
!207 = !DILocation(line: 23, column: 5, scope: !198)
!208 = !DILocation(line: 20, column: 49, scope: !194)
!209 = !DILocation(line: 20, column: 5, scope: !194)
!210 = distinct !{!210, !196, !211, !212}
!211 = !DILocation(line: 23, column: 5, scope: !190)
!212 = !{!"llvm.loop.mustprogress"}
!213 = !DILocation(line: 24, column: 1, scope: !185)
!214 = distinct !DISubprogram(name: "imap_add", scope: !61, file: !61, line: 140, type: !215, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!215 = !DISubroutineType(types: !216)
!216 = !{!42, !14, !19, !49}
!217 = !DILocalVariable(name: "tid", arg: 1, scope: !214, file: !61, line: 140, type: !14)
!218 = !DILocation(line: 140, column: 18, scope: !214)
!219 = !DILocalVariable(name: "key", arg: 2, scope: !214, file: !61, line: 140, type: !19)
!220 = !DILocation(line: 140, column: 34, scope: !214)
!221 = !DILocalVariable(name: "val", arg: 3, scope: !214, file: !61, line: 140, type: !49)
!222 = !DILocation(line: 140, column: 49, scope: !214)
!223 = !DILocalVariable(name: "data", scope: !214, file: !61, line: 142, type: !224)
!224 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !225, size: 64)
!225 = !DIDerivedType(tag: DW_TAG_typedef, name: "data_t", file: !61, line: 30, baseType: !226)
!226 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "data_s", file: !61, line: 27, size: 128, elements: !227)
!227 = !{!228, !229}
!228 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !226, file: !61, line: 28, baseType: !19, size: 64)
!229 = !DIDerivedType(tag: DW_TAG_member, name: "val", scope: !226, file: !61, line: 29, baseType: !49, size: 64, offset: 64)
!230 = !DILocation(line: 142, column: 13, scope: !214)
!231 = !DILocation(line: 142, column: 20, scope: !214)
!232 = !DILocation(line: 143, column: 20, scope: !214)
!233 = !DILocation(line: 143, column: 5, scope: !214)
!234 = !DILocation(line: 143, column: 11, scope: !214)
!235 = !DILocation(line: 143, column: 18, scope: !214)
!236 = !DILocation(line: 144, column: 20, scope: !214)
!237 = !DILocation(line: 144, column: 5, scope: !214)
!238 = !DILocation(line: 144, column: 11, scope: !214)
!239 = !DILocation(line: 144, column: 18, scope: !214)
!240 = !DILocalVariable(name: "added", scope: !214, file: !61, line: 145, type: !42)
!241 = !DILocation(line: 145, column: 13, scope: !214)
!242 = !DILocation(line: 146, column: 36, scope: !214)
!243 = !DILocation(line: 146, column: 42, scope: !214)
!244 = !DILocation(line: 146, column: 47, scope: !214)
!245 = !DILocation(line: 146, column: 9, scope: !214)
!246 = !DILocation(line: 146, column: 53, scope: !214)
!247 = !DILocation(line: 147, column: 9, scope: !248)
!248 = distinct !DILexicalBlock(scope: !214, file: !61, line: 147, column: 9)
!249 = !DILocation(line: 147, column: 9, scope: !214)
!250 = !DILocation(line: 148, column: 26, scope: !251)
!251 = distinct !DILexicalBlock(scope: !248, file: !61, line: 147, column: 16)
!252 = !DILocation(line: 148, column: 20, scope: !251)
!253 = !DILocation(line: 148, column: 32, scope: !251)
!254 = !DILocation(line: 148, column: 38, scope: !251)
!255 = !DILocation(line: 148, column: 9, scope: !251)
!256 = !DILocation(line: 149, column: 5, scope: !251)
!257 = !DILocation(line: 150, column: 14, scope: !258)
!258 = distinct !DILexicalBlock(scope: !248, file: !61, line: 149, column: 12)
!259 = !DILocation(line: 150, column: 9, scope: !258)
!260 = !DILocation(line: 152, column: 12, scope: !214)
!261 = !DILocation(line: 152, column: 5, scope: !214)
!262 = distinct !DISubprogram(name: "t0", scope: !56, file: !56, line: 26, type: !263, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !188)
!263 = !DISubroutineType(types: !264)
!264 = !{null, !14}
!265 = !DILocalVariable(name: "tid", arg: 1, scope: !262, file: !56, line: 26, type: !14)
!266 = !DILocation(line: 26, column: 12, scope: !262)
!267 = !DILocation(line: 28, column: 24, scope: !262)
!268 = !DILocation(line: 28, column: 15, scope: !262)
!269 = !DILocation(line: 28, column: 13, scope: !262)
!270 = !DILocation(line: 29, column: 1, scope: !262)
!271 = distinct !DISubprogram(name: "t1", scope: !56, file: !56, line: 31, type: !263, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !188)
!272 = !DILocalVariable(name: "tid", arg: 1, scope: !271, file: !56, line: 31, type: !14)
!273 = !DILocation(line: 31, column: 12, scope: !271)
!274 = !DILocalVariable(name: "success", scope: !271, file: !56, line: 33, type: !42)
!275 = !DILocation(line: 33, column: 13, scope: !271)
!276 = !DILocation(line: 33, column: 32, scope: !271)
!277 = !DILocation(line: 33, column: 23, scope: !271)
!278 = !DILocation(line: 34, column: 5, scope: !279)
!279 = distinct !DILexicalBlock(scope: !280, file: !56, line: 34, column: 5)
!280 = distinct !DILexicalBlock(scope: !271, file: !56, line: 34, column: 5)
!281 = !DILocation(line: 34, column: 5, scope: !280)
!282 = !DILocation(line: 35, column: 1, scope: !271)
!283 = distinct !DISubprogram(name: "imap_rem", scope: !61, file: !61, line: 156, type: !284, scopeLine: 157, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!284 = !DISubroutineType(types: !285)
!285 = !{!42, !14, !19}
!286 = !DILocalVariable(name: "tid", arg: 1, scope: !283, file: !61, line: 156, type: !14)
!287 = !DILocation(line: 156, column: 18, scope: !283)
!288 = !DILocalVariable(name: "key", arg: 2, scope: !283, file: !61, line: 156, type: !19)
!289 = !DILocation(line: 156, column: 34, scope: !283)
!290 = !DILocalVariable(name: "removed", scope: !283, file: !61, line: 158, type: !42)
!291 = !DILocation(line: 158, column: 13, scope: !283)
!292 = !DILocation(line: 158, column: 53, scope: !283)
!293 = !DILocation(line: 158, column: 23, scope: !283)
!294 = !DILocation(line: 158, column: 58, scope: !283)
!295 = !DILocation(line: 159, column: 9, scope: !296)
!296 = distinct !DILexicalBlock(scope: !283, file: !61, line: 159, column: 9)
!297 = !DILocation(line: 159, column: 9, scope: !283)
!298 = !DILocation(line: 160, column: 26, scope: !299)
!299 = distinct !DILexicalBlock(scope: !296, file: !61, line: 159, column: 18)
!300 = !DILocation(line: 160, column: 20, scope: !299)
!301 = !DILocation(line: 160, column: 32, scope: !299)
!302 = !DILocation(line: 160, column: 9, scope: !299)
!303 = !DILocation(line: 161, column: 5, scope: !299)
!304 = !DILocation(line: 162, column: 12, scope: !283)
!305 = !DILocation(line: 162, column: 5, scope: !283)
!306 = distinct !DISubprogram(name: "t2", scope: !56, file: !56, line: 37, type: !263, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !188)
!307 = !DILocalVariable(name: "tid", arg: 1, scope: !306, file: !56, line: 37, type: !14)
!308 = !DILocation(line: 37, column: 12, scope: !306)
!309 = !DILocalVariable(name: "data", scope: !306, file: !56, line: 39, type: !224)
!310 = !DILocation(line: 39, column: 13, scope: !306)
!311 = !DILocation(line: 39, column: 29, scope: !306)
!312 = !DILocation(line: 39, column: 20, scope: !306)
!313 = !DILocation(line: 40, column: 9, scope: !314)
!314 = distinct !DILexicalBlock(scope: !306, file: !56, line: 40, column: 9)
!315 = !DILocation(line: 40, column: 9, scope: !306)
!316 = !DILocation(line: 41, column: 13, scope: !317)
!317 = distinct !DILexicalBlock(scope: !318, file: !56, line: 41, column: 13)
!318 = distinct !DILexicalBlock(scope: !314, file: !56, line: 40, column: 15)
!319 = !DILocation(line: 41, column: 19, scope: !317)
!320 = !DILocation(line: 41, column: 23, scope: !317)
!321 = !DILocation(line: 41, column: 13, scope: !318)
!322 = !DILocation(line: 42, column: 26, scope: !323)
!323 = distinct !DILexicalBlock(scope: !317, file: !56, line: 41, column: 35)
!324 = !DILocation(line: 43, column: 9, scope: !323)
!325 = !DILocation(line: 44, column: 5, scope: !318)
!326 = !DILocation(line: 45, column: 1, scope: !306)
!327 = distinct !DISubprogram(name: "imap_get", scope: !61, file: !61, line: 166, type: !328, scopeLine: 167, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!328 = !DISubroutineType(types: !329)
!329 = !{!22, !14, !19}
!330 = !DILocalVariable(name: "tid", arg: 1, scope: !327, file: !61, line: 166, type: !14)
!331 = !DILocation(line: 166, column: 18, scope: !327)
!332 = !DILocalVariable(name: "key", arg: 2, scope: !327, file: !61, line: 166, type: !19)
!333 = !DILocation(line: 166, column: 34, scope: !327)
!334 = !DILocation(line: 168, column: 5, scope: !327)
!335 = !DILocation(line: 168, column: 5, scope: !336)
!336 = distinct !DILexicalBlock(scope: !327, file: !61, line: 168, column: 5)
!337 = !DILocation(line: 168, column: 5, scope: !338)
!338 = distinct !DILexicalBlock(scope: !336, file: !61, line: 168, column: 5)
!339 = !DILocation(line: 168, column: 5, scope: !340)
!340 = distinct !DILexicalBlock(scope: !338, file: !61, line: 168, column: 5)
!341 = !DILocalVariable(name: "data", scope: !327, file: !61, line: 169, type: !224)
!342 = !DILocation(line: 169, column: 13, scope: !327)
!343 = !DILocation(line: 169, column: 47, scope: !327)
!344 = !DILocation(line: 169, column: 20, scope: !327)
!345 = !DILocation(line: 170, column: 9, scope: !346)
!346 = distinct !DILexicalBlock(scope: !327, file: !61, line: 170, column: 9)
!347 = !DILocation(line: 170, column: 9, scope: !327)
!348 = !DILocation(line: 171, column: 9, scope: !349)
!349 = distinct !DILexicalBlock(scope: !350, file: !61, line: 171, column: 9)
!350 = distinct !DILexicalBlock(scope: !351, file: !61, line: 171, column: 9)
!351 = distinct !DILexicalBlock(scope: !346, file: !61, line: 170, column: 15)
!352 = !DILocation(line: 171, column: 9, scope: !350)
!353 = !DILocation(line: 172, column: 5, scope: !351)
!354 = !DILocation(line: 173, column: 12, scope: !327)
!355 = !DILocation(line: 173, column: 5, scope: !327)
!356 = distinct !DISubprogram(name: "post", scope: !56, file: !56, line: 47, type: !186, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !188)
!357 = !DILocalVariable(name: "k", scope: !358, file: !56, line: 49, type: !19)
!358 = distinct !DILexicalBlock(scope: !356, file: !56, line: 49, column: 5)
!359 = !DILocation(line: 49, column: 21, scope: !358)
!360 = !DILocation(line: 49, column: 10, scope: !358)
!361 = !DILocation(line: 49, column: 34, scope: !362)
!362 = distinct !DILexicalBlock(scope: !358, file: !56, line: 49, column: 5)
!363 = !DILocation(line: 49, column: 36, scope: !362)
!364 = !DILocation(line: 49, column: 5, scope: !358)
!365 = !DILocalVariable(name: "d", scope: !366, file: !56, line: 50, type: !224)
!366 = distinct !DILexicalBlock(scope: !362, file: !56, line: 49, column: 53)
!367 = !DILocation(line: 50, column: 17, scope: !366)
!368 = !DILocation(line: 50, column: 40, scope: !366)
!369 = !DILocation(line: 50, column: 21, scope: !366)
!370 = !DILocation(line: 51, column: 13, scope: !371)
!371 = distinct !DILexicalBlock(scope: !366, file: !56, line: 51, column: 13)
!372 = !DILocation(line: 51, column: 15, scope: !371)
!373 = !DILocation(line: 51, column: 13, scope: !366)
!374 = !DILocation(line: 52, column: 17, scope: !375)
!375 = distinct !DILexicalBlock(scope: !376, file: !56, line: 52, column: 17)
!376 = distinct !DILexicalBlock(scope: !371, file: !56, line: 51, column: 32)
!377 = !DILocation(line: 52, column: 17, scope: !376)
!378 = !DILocation(line: 53, column: 17, scope: !379)
!379 = distinct !DILexicalBlock(scope: !380, file: !56, line: 53, column: 17)
!380 = distinct !DILexicalBlock(scope: !381, file: !56, line: 53, column: 17)
!381 = distinct !DILexicalBlock(scope: !375, file: !56, line: 52, column: 26)
!382 = !DILocation(line: 53, column: 17, scope: !380)
!383 = !DILocation(line: 54, column: 17, scope: !384)
!384 = distinct !DILexicalBlock(scope: !385, file: !56, line: 54, column: 17)
!385 = distinct !DILexicalBlock(scope: !381, file: !56, line: 54, column: 17)
!386 = !DILocation(line: 54, column: 17, scope: !385)
!387 = !DILocation(line: 55, column: 13, scope: !381)
!388 = !DILocation(line: 55, column: 24, scope: !389)
!389 = distinct !DILexicalBlock(scope: !375, file: !56, line: 55, column: 24)
!390 = !DILocation(line: 55, column: 24, scope: !375)
!391 = !DILocation(line: 56, column: 17, scope: !392)
!392 = distinct !DILexicalBlock(scope: !393, file: !56, line: 56, column: 17)
!393 = distinct !DILexicalBlock(scope: !394, file: !56, line: 56, column: 17)
!394 = distinct !DILexicalBlock(scope: !389, file: !56, line: 55, column: 27)
!395 = !DILocation(line: 56, column: 17, scope: !393)
!396 = !DILocation(line: 57, column: 13, scope: !394)
!397 = !DILocation(line: 58, column: 9, scope: !376)
!398 = !DILocation(line: 59, column: 13, scope: !399)
!399 = distinct !DILexicalBlock(scope: !400, file: !56, line: 59, column: 13)
!400 = distinct !DILexicalBlock(scope: !401, file: !56, line: 59, column: 13)
!401 = distinct !DILexicalBlock(scope: !371, file: !56, line: 58, column: 16)
!402 = !DILocation(line: 59, column: 13, scope: !400)
!403 = !DILocation(line: 61, column: 5, scope: !366)
!404 = !DILocation(line: 49, column: 49, scope: !362)
!405 = !DILocation(line: 49, column: 5, scope: !362)
!406 = distinct !{!406, !364, !407, !212}
!407 = !DILocation(line: 61, column: 5, scope: !358)
!408 = !DILocation(line: 62, column: 9, scope: !409)
!409 = distinct !DILexicalBlock(scope: !356, file: !56, line: 62, column: 9)
!410 = !DILocation(line: 62, column: 9, scope: !356)
!411 = !DILocation(line: 63, column: 9, scope: !412)
!412 = distinct !DILexicalBlock(scope: !413, file: !56, line: 63, column: 9)
!413 = distinct !DILexicalBlock(scope: !414, file: !56, line: 63, column: 9)
!414 = distinct !DILexicalBlock(scope: !409, file: !56, line: 62, column: 23)
!415 = !DILocation(line: 63, column: 9, scope: !413)
!416 = !DILocation(line: 64, column: 5, scope: !414)
!417 = !DILocation(line: 65, column: 1, scope: !356)
!418 = distinct !DISubprogram(name: "run", scope: !419, file: !419, line: 94, type: !47, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !188)
!419 = !DIFile(filename: "test/include/test/boilerplate/test_case.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "ec4420aa4ca09b8f4298c137e9e77071")
!420 = !DILocalVariable(name: "args", arg: 1, scope: !418, file: !419, line: 94, type: !22)
!421 = !DILocation(line: 94, column: 11, scope: !418)
!422 = !DILocalVariable(name: "tid", scope: !418, file: !419, line: 96, type: !14)
!423 = !DILocation(line: 96, column: 13, scope: !418)
!424 = !DILocation(line: 96, column: 40, scope: !418)
!425 = !DILocation(line: 96, column: 28, scope: !418)
!426 = !DILocation(line: 97, column: 5, scope: !427)
!427 = distinct !DILexicalBlock(scope: !428, file: !419, line: 97, column: 5)
!428 = distinct !DILexicalBlock(scope: !418, file: !419, line: 97, column: 5)
!429 = !DILocation(line: 97, column: 5, scope: !428)
!430 = !DILocation(line: 99, column: 9, scope: !418)
!431 = !DILocation(line: 99, column: 5, scope: !418)
!432 = !DILocation(line: 100, column: 13, scope: !418)
!433 = !DILocation(line: 100, column: 5, scope: !418)
!434 = !DILocation(line: 102, column: 16, scope: !435)
!435 = distinct !DILexicalBlock(scope: !418, file: !419, line: 100, column: 18)
!436 = !DILocation(line: 102, column: 13, scope: !435)
!437 = !DILocation(line: 103, column: 13, scope: !435)
!438 = !DILocation(line: 105, column: 16, scope: !435)
!439 = !DILocation(line: 105, column: 13, scope: !435)
!440 = !DILocation(line: 106, column: 13, scope: !435)
!441 = !DILocation(line: 108, column: 16, scope: !435)
!442 = !DILocation(line: 108, column: 13, scope: !435)
!443 = !DILocation(line: 109, column: 13, scope: !435)
!444 = !DILocation(line: 116, column: 13, scope: !435)
!445 = !DILocation(line: 118, column: 11, scope: !418)
!446 = !DILocation(line: 118, column: 5, scope: !418)
!447 = !DILocation(line: 119, column: 5, scope: !418)
!448 = distinct !DISubprogram(name: "reg", scope: !449, file: !449, line: 11, type: !263, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !188)
!449 = !DIFile(filename: "verify/simpleht/verify.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "fef1aee1945b19b211b0b629c38d4444")
!450 = !DILocalVariable(name: "tid", arg: 1, scope: !448, file: !449, line: 11, type: !14)
!451 = !DILocation(line: 11, column: 13, scope: !448)
!452 = !DILocation(line: 13, column: 14, scope: !448)
!453 = !DILocation(line: 13, column: 5, scope: !448)
!454 = !DILocation(line: 14, column: 1, scope: !448)
!455 = distinct !DISubprogram(name: "dereg", scope: !449, file: !449, line: 16, type: !263, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !188)
!456 = !DILocalVariable(name: "tid", arg: 1, scope: !455, file: !449, line: 16, type: !14)
!457 = !DILocation(line: 16, column: 15, scope: !455)
!458 = !DILocation(line: 18, column: 16, scope: !455)
!459 = !DILocation(line: 18, column: 5, scope: !455)
!460 = !DILocation(line: 19, column: 1, scope: !455)
!461 = distinct !DISubprogram(name: "tc", scope: !419, file: !419, line: 129, type: !186, scopeLine: 130, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !188)
!462 = !DILocation(line: 131, column: 5, scope: !461)
!463 = !DILocation(line: 132, column: 5, scope: !461)
!464 = !DILocation(line: 133, column: 5, scope: !461)
!465 = !DILocation(line: 134, column: 5, scope: !461)
!466 = !DILocation(line: 135, column: 5, scope: !461)
!467 = !DILocation(line: 136, column: 1, scope: !461)
!468 = distinct !DISubprogram(name: "init", scope: !449, file: !449, line: 22, type: !186, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !188)
!469 = !DILocation(line: 24, column: 5, scope: !468)
!470 = !DILocation(line: 25, column: 1, scope: !468)
!471 = distinct !DISubprogram(name: "launch_threads", scope: !34, file: !34, line: 119, type: !472, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!472 = !DISubroutineType(types: !473)
!473 = !{null, !14, !45}
!474 = !DILocalVariable(name: "thread_count", arg: 1, scope: !471, file: !34, line: 119, type: !14)
!475 = !DILocation(line: 119, column: 24, scope: !471)
!476 = !DILocalVariable(name: "fun", arg: 2, scope: !471, file: !34, line: 119, type: !45)
!477 = !DILocation(line: 119, column: 51, scope: !471)
!478 = !DILocalVariable(name: "threads", scope: !471, file: !34, line: 121, type: !32)
!479 = !DILocation(line: 121, column: 17, scope: !471)
!480 = !DILocation(line: 121, column: 55, scope: !471)
!481 = !DILocation(line: 121, column: 53, scope: !471)
!482 = !DILocation(line: 121, column: 27, scope: !471)
!483 = !DILocation(line: 123, column: 20, scope: !471)
!484 = !DILocation(line: 123, column: 29, scope: !471)
!485 = !DILocation(line: 123, column: 43, scope: !471)
!486 = !DILocation(line: 123, column: 5, scope: !471)
!487 = !DILocation(line: 125, column: 19, scope: !471)
!488 = !DILocation(line: 125, column: 28, scope: !471)
!489 = !DILocation(line: 125, column: 5, scope: !471)
!490 = !DILocation(line: 127, column: 10, scope: !471)
!491 = !DILocation(line: 127, column: 5, scope: !471)
!492 = !DILocation(line: 128, column: 1, scope: !471)
!493 = distinct !DISubprogram(name: "fini", scope: !449, file: !449, line: 27, type: !186, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !188)
!494 = !DILocation(line: 29, column: 5, scope: !493)
!495 = !DILocation(line: 30, column: 1, scope: !493)
!496 = distinct !DISubprogram(name: "imap_reg", scope: !61, file: !61, line: 177, type: !263, scopeLine: 178, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!497 = !DILocalVariable(name: "tid", arg: 1, scope: !496, file: !61, line: 177, type: !14)
!498 = !DILocation(line: 177, column: 18, scope: !496)
!499 = !DILocation(line: 179, column: 5, scope: !496)
!500 = !DILocation(line: 179, column: 5, scope: !501)
!501 = distinct !DILexicalBlock(scope: !496, file: !61, line: 179, column: 5)
!502 = !DILocation(line: 179, column: 5, scope: !503)
!503 = distinct !DILexicalBlock(scope: !501, file: !61, line: 179, column: 5)
!504 = !DILocation(line: 179, column: 5, scope: !505)
!505 = distinct !DILexicalBlock(scope: !503, file: !61, line: 179, column: 5)
!506 = !DILocation(line: 180, column: 5, scope: !496)
!507 = !DILocation(line: 181, column: 1, scope: !496)
!508 = distinct !DISubprogram(name: "imap_dereg", scope: !61, file: !61, line: 184, type: !263, scopeLine: 185, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!509 = !DILocalVariable(name: "tid", arg: 1, scope: !508, file: !61, line: 184, type: !14)
!510 = !DILocation(line: 184, column: 20, scope: !508)
!511 = !DILocation(line: 186, column: 5, scope: !508)
!512 = !DILocation(line: 186, column: 5, scope: !513)
!513 = distinct !DILexicalBlock(scope: !508, file: !61, line: 186, column: 5)
!514 = !DILocation(line: 186, column: 5, scope: !515)
!515 = distinct !DILexicalBlock(scope: !513, file: !61, line: 186, column: 5)
!516 = !DILocation(line: 186, column: 5, scope: !517)
!517 = distinct !DILexicalBlock(scope: !515, file: !61, line: 186, column: 5)
!518 = !DILocation(line: 187, column: 5, scope: !508)
!519 = !DILocation(line: 188, column: 1, scope: !508)
!520 = distinct !DISubprogram(name: "imap_init", scope: !61, file: !61, line: 114, type: !186, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!521 = !DILocalVariable(name: "sz", scope: !520, file: !61, line: 116, type: !14)
!522 = !DILocation(line: 116, column: 13, scope: !520)
!523 = !DILocation(line: 116, column: 20, scope: !520)
!524 = !DILocalVariable(name: "g_buff", scope: !520, file: !61, line: 117, type: !22)
!525 = !DILocation(line: 117, column: 11, scope: !520)
!526 = !DILocation(line: 117, column: 27, scope: !520)
!527 = !DILocation(line: 117, column: 20, scope: !520)
!528 = !DILocation(line: 119, column: 33, scope: !520)
!529 = !DILocation(line: 119, column: 5, scope: !520)
!530 = !DILocalVariable(name: "i", scope: !531, file: !61, line: 122, type: !14)
!531 = distinct !DILexicalBlock(scope: !520, file: !61, line: 122, column: 5)
!532 = !DILocation(line: 122, column: 18, scope: !531)
!533 = !DILocation(line: 122, column: 10, scope: !531)
!534 = !DILocation(line: 122, column: 25, scope: !535)
!535 = distinct !DILexicalBlock(scope: !531, file: !61, line: 122, column: 5)
!536 = !DILocation(line: 122, column: 27, scope: !535)
!537 = !DILocation(line: 122, column: 5, scope: !531)
!538 = !DILocation(line: 123, column: 27, scope: !539)
!539 = distinct !DILexicalBlock(scope: !535, file: !61, line: 122, column: 43)
!540 = !DILocation(line: 123, column: 21, scope: !539)
!541 = !DILocation(line: 123, column: 9, scope: !539)
!542 = !DILocation(line: 124, column: 27, scope: !539)
!543 = !DILocation(line: 124, column: 21, scope: !539)
!544 = !DILocation(line: 124, column: 9, scope: !539)
!545 = !DILocation(line: 125, column: 5, scope: !539)
!546 = !DILocation(line: 122, column: 39, scope: !535)
!547 = !DILocation(line: 122, column: 5, scope: !535)
!548 = distinct !{!548, !537, !549, !212}
!549 = !DILocation(line: 125, column: 5, scope: !531)
!550 = !DILocation(line: 126, column: 1, scope: !520)
!551 = distinct !DISubprogram(name: "imap_destroy", scope: !61, file: !61, line: 128, type: !186, scopeLine: 129, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!552 = !DILocation(line: 130, column: 5, scope: !551)
!553 = !DILocalVariable(name: "i", scope: !554, file: !61, line: 131, type: !14)
!554 = distinct !DILexicalBlock(scope: !551, file: !61, line: 131, column: 5)
!555 = !DILocation(line: 131, column: 18, scope: !554)
!556 = !DILocation(line: 131, column: 10, scope: !554)
!557 = !DILocation(line: 131, column: 25, scope: !558)
!558 = distinct !DILexicalBlock(scope: !554, file: !61, line: 131, column: 5)
!559 = !DILocation(line: 131, column: 27, scope: !558)
!560 = !DILocation(line: 131, column: 5, scope: !554)
!561 = !DILocation(line: 132, column: 30, scope: !562)
!562 = distinct !DILexicalBlock(scope: !558, file: !61, line: 131, column: 43)
!563 = !DILocation(line: 132, column: 24, scope: !562)
!564 = !DILocation(line: 132, column: 9, scope: !562)
!565 = !DILocation(line: 133, column: 30, scope: !562)
!566 = !DILocation(line: 133, column: 24, scope: !562)
!567 = !DILocation(line: 133, column: 9, scope: !562)
!568 = !DILocation(line: 134, column: 5, scope: !562)
!569 = !DILocation(line: 131, column: 39, scope: !558)
!570 = !DILocation(line: 131, column: 5, scope: !558)
!571 = distinct !{!571, !560, !572, !212}
!572 = !DILocation(line: 134, column: 5, scope: !554)
!573 = !DILocation(line: 135, column: 5, scope: !551)
!574 = !DILocation(line: 136, column: 10, scope: !551)
!575 = !DILocation(line: 136, column: 5, scope: !551)
!576 = !DILocation(line: 137, column: 12, scope: !551)
!577 = !DILocation(line: 138, column: 1, scope: !551)
!578 = distinct !DISubprogram(name: "main", scope: !449, file: !449, line: 33, type: !579, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !188)
!579 = !DISubroutineType(types: !580)
!580 = !{!119}
!581 = !DILocation(line: 35, column: 5, scope: !578)
!582 = !DILocation(line: 36, column: 5, scope: !578)
!583 = distinct !DISubprogram(name: "vsimpleht_add", scope: !6, file: !6, line: 241, type: !584, scopeLine: 242, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!584 = !DISubroutineType(types: !585)
!585 = !{!586, !587, !19, !22}
!586 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_ret_t", file: !6, line: 106, baseType: !5)
!587 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!588 = !DILocalVariable(name: "tbl", arg: 1, scope: !583, file: !6, line: 241, type: !587)
!589 = !DILocation(line: 241, column: 28, scope: !583)
!590 = !DILocalVariable(name: "key", arg: 2, scope: !583, file: !6, line: 241, type: !19)
!591 = !DILocation(line: 241, column: 44, scope: !583)
!592 = !DILocalVariable(name: "value", arg: 3, scope: !583, file: !6, line: 241, type: !22)
!593 = !DILocation(line: 241, column: 55, scope: !583)
!594 = !DILocation(line: 243, column: 5, scope: !595)
!595 = distinct !DILexicalBlock(scope: !596, file: !6, line: 243, column: 5)
!596 = distinct !DILexicalBlock(scope: !583, file: !6, line: 243, column: 5)
!597 = !DILocation(line: 243, column: 5, scope: !596)
!598 = !DILocation(line: 244, column: 5, scope: !599)
!599 = distinct !DILexicalBlock(scope: !600, file: !6, line: 244, column: 5)
!600 = distinct !DILexicalBlock(scope: !583, file: !6, line: 244, column: 5)
!601 = !DILocation(line: 244, column: 5, scope: !600)
!602 = !DILocation(line: 245, column: 38, scope: !583)
!603 = !DILocation(line: 245, column: 5, scope: !583)
!604 = !DILocation(line: 246, column: 27, scope: !583)
!605 = !DILocation(line: 246, column: 32, scope: !583)
!606 = !DILocation(line: 246, column: 37, scope: !583)
!607 = !DILocation(line: 246, column: 12, scope: !583)
!608 = !DILocation(line: 246, column: 5, scope: !583)
!609 = distinct !DISubprogram(name: "trace_add", scope: !158, file: !158, line: 153, type: !610, scopeLine: 154, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!610 = !DISubroutineType(types: !611)
!611 = !{null, !612, !19}
!612 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !157, size: 64)
!613 = !DILocalVariable(name: "trace", arg: 1, scope: !609, file: !158, line: 153, type: !612)
!614 = !DILocation(line: 153, column: 20, scope: !609)
!615 = !DILocalVariable(name: "key", arg: 2, scope: !609, file: !158, line: 153, type: !19)
!616 = !DILocation(line: 153, column: 38, scope: !609)
!617 = !DILocation(line: 155, column: 5, scope: !618)
!618 = distinct !DILexicalBlock(scope: !619, file: !158, line: 155, column: 5)
!619 = distinct !DILexicalBlock(scope: !609, file: !158, line: 155, column: 5)
!620 = !DILocation(line: 155, column: 5, scope: !619)
!621 = !DILocation(line: 156, column: 5, scope: !622)
!622 = distinct !DILexicalBlock(scope: !623, file: !158, line: 156, column: 5)
!623 = distinct !DILexicalBlock(scope: !609, file: !158, line: 156, column: 5)
!624 = !DILocation(line: 156, column: 5, scope: !623)
!625 = !DILocation(line: 157, column: 35, scope: !609)
!626 = !DILocation(line: 157, column: 42, scope: !609)
!627 = !DILocation(line: 157, column: 5, scope: !609)
!628 = !DILocation(line: 158, column: 1, scope: !609)
!629 = distinct !DISubprogram(name: "_vsimpleht_give_cleanup_a_chance", scope: !6, file: !6, line: 479, type: !630, scopeLine: 480, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!630 = !DISubroutineType(types: !631)
!631 = !{null, !587}
!632 = !DILocalVariable(name: "tbl", arg: 1, scope: !629, file: !6, line: 479, type: !587)
!633 = !DILocation(line: 479, column: 47, scope: !629)
!634 = !DILocation(line: 484, column: 36, scope: !635)
!635 = distinct !DILexicalBlock(scope: !629, file: !6, line: 484, column: 9)
!636 = !DILocation(line: 484, column: 41, scope: !635)
!637 = !DILocation(line: 484, column: 9, scope: !635)
!638 = !DILocation(line: 484, column: 9, scope: !629)
!639 = !DILocation(line: 485, column: 9, scope: !640)
!640 = distinct !DILexicalBlock(scope: !641, file: !6, line: 485, column: 9)
!641 = distinct !DILexicalBlock(scope: !642, file: !6, line: 485, column: 9)
!642 = distinct !DILexicalBlock(scope: !635, file: !6, line: 484, column: 48)
!643 = !DILocation(line: 485, column: 9, scope: !641)
!644 = !DILocation(line: 488, column: 30, scope: !642)
!645 = !DILocation(line: 488, column: 35, scope: !642)
!646 = !DILocation(line: 488, column: 9, scope: !642)
!647 = !DILocation(line: 489, column: 30, scope: !642)
!648 = !DILocation(line: 489, column: 35, scope: !642)
!649 = !DILocation(line: 489, column: 9, scope: !642)
!650 = !DILocation(line: 490, column: 5, scope: !642)
!651 = !DILocation(line: 492, column: 1, scope: !629)
!652 = distinct !DISubprogram(name: "_vsimpleht_add", scope: !6, file: !6, line: 416, type: !584, scopeLine: 417, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!653 = !DILocalVariable(name: "tbl", arg: 1, scope: !652, file: !6, line: 416, type: !587)
!654 = !DILocation(line: 416, column: 29, scope: !652)
!655 = !DILocalVariable(name: "key", arg: 2, scope: !652, file: !6, line: 416, type: !19)
!656 = !DILocation(line: 416, column: 45, scope: !652)
!657 = !DILocalVariable(name: "value", arg: 3, scope: !652, file: !6, line: 416, type: !22)
!658 = !DILocation(line: 416, column: 56, scope: !652)
!659 = !DILocalVariable(name: "index", scope: !652, file: !6, line: 418, type: !14)
!660 = !DILocation(line: 418, column: 13, scope: !652)
!661 = !DILocalVariable(name: "probed_key", scope: !652, file: !6, line: 419, type: !19)
!662 = !DILocation(line: 419, column: 16, scope: !652)
!663 = !DILocalVariable(name: "val", scope: !652, file: !6, line: 420, type: !22)
!664 = !DILocation(line: 420, column: 11, scope: !652)
!665 = !DILocalVariable(name: "cnt", scope: !652, file: !6, line: 421, type: !14)
!666 = !DILocation(line: 421, column: 13, scope: !652)
!667 = !DILocation(line: 423, column: 5, scope: !668)
!668 = distinct !DILexicalBlock(scope: !669, file: !6, line: 423, column: 5)
!669 = distinct !DILexicalBlock(scope: !652, file: !6, line: 423, column: 5)
!670 = !DILocation(line: 423, column: 5, scope: !669)
!671 = !DILocation(line: 424, column: 5, scope: !672)
!672 = distinct !DILexicalBlock(scope: !673, file: !6, line: 424, column: 5)
!673 = distinct !DILexicalBlock(scope: !652, file: !6, line: 424, column: 5)
!674 = !DILocation(line: 424, column: 5, scope: !673)
!675 = !DILocation(line: 428, column: 18, scope: !676)
!676 = distinct !DILexicalBlock(scope: !652, file: !6, line: 428, column: 5)
!677 = !DILocation(line: 428, column: 23, scope: !676)
!678 = !DILocation(line: 428, column: 32, scope: !676)
!679 = !DILocation(line: 428, column: 16, scope: !676)
!680 = !DILocation(line: 428, column: 10, scope: !676)
!681 = !DILocation(line: 428, column: 38, scope: !682)
!682 = distinct !DILexicalBlock(scope: !676, file: !6, line: 428, column: 5)
!683 = !DILocation(line: 428, column: 44, scope: !682)
!684 = !DILocation(line: 428, column: 49, scope: !682)
!685 = !DILocation(line: 428, column: 42, scope: !682)
!686 = !DILocation(line: 428, column: 5, scope: !676)
!687 = !DILocation(line: 430, column: 18, scope: !688)
!688 = distinct !DILexicalBlock(scope: !682, file: !6, line: 428, column: 75)
!689 = !DILocation(line: 430, column: 23, scope: !688)
!690 = !DILocation(line: 430, column: 32, scope: !688)
!691 = !DILocation(line: 430, column: 15, scope: !688)
!692 = !DILocation(line: 431, column: 9, scope: !693)
!693 = distinct !DILexicalBlock(scope: !694, file: !6, line: 431, column: 9)
!694 = distinct !DILexicalBlock(scope: !688, file: !6, line: 431, column: 9)
!695 = !DILocation(line: 431, column: 9, scope: !694)
!696 = !DILocation(line: 433, column: 51, scope: !688)
!697 = !DILocation(line: 433, column: 56, scope: !688)
!698 = !DILocation(line: 433, column: 64, scope: !688)
!699 = !DILocation(line: 433, column: 71, scope: !688)
!700 = !DILocation(line: 433, column: 34, scope: !688)
!701 = !DILocation(line: 433, column: 22, scope: !688)
!702 = !DILocation(line: 433, column: 20, scope: !688)
!703 = !DILocation(line: 438, column: 13, scope: !704)
!704 = distinct !DILexicalBlock(scope: !688, file: !6, line: 438, column: 13)
!705 = !DILocation(line: 438, column: 24, scope: !704)
!706 = !DILocation(line: 438, column: 13, scope: !688)
!707 = !DILocation(line: 440, column: 18, scope: !708)
!708 = distinct !DILexicalBlock(scope: !704, file: !6, line: 438, column: 30)
!709 = !DILocation(line: 440, column: 23, scope: !708)
!710 = !DILocation(line: 440, column: 31, scope: !708)
!711 = !DILocation(line: 440, column: 38, scope: !708)
!712 = !DILocation(line: 440, column: 57, scope: !708)
!713 = !DILocation(line: 440, column: 49, scope: !708)
!714 = !DILocation(line: 439, column: 38, scope: !708)
!715 = !DILocation(line: 439, column: 26, scope: !708)
!716 = !DILocation(line: 439, column: 24, scope: !708)
!717 = !DILocation(line: 442, column: 17, scope: !718)
!718 = distinct !DILexicalBlock(scope: !708, file: !6, line: 442, column: 17)
!719 = !DILocation(line: 442, column: 28, scope: !718)
!720 = !DILocation(line: 442, column: 33, scope: !718)
!721 = !DILocation(line: 442, column: 36, scope: !718)
!722 = !DILocation(line: 442, column: 41, scope: !718)
!723 = !DILocation(line: 442, column: 49, scope: !718)
!724 = !DILocation(line: 442, column: 54, scope: !718)
!725 = !DILocation(line: 442, column: 66, scope: !718)
!726 = !DILocation(line: 442, column: 17, scope: !708)
!727 = !DILocation(line: 443, column: 17, scope: !728)
!728 = distinct !DILexicalBlock(scope: !718, file: !6, line: 442, column: 72)
!729 = !DILocation(line: 445, column: 9, scope: !708)
!730 = !DILocation(line: 445, column: 20, scope: !731)
!731 = distinct !DILexicalBlock(scope: !704, file: !6, line: 445, column: 20)
!732 = !DILocation(line: 445, column: 25, scope: !731)
!733 = !DILocation(line: 445, column: 33, scope: !731)
!734 = !DILocation(line: 445, column: 38, scope: !731)
!735 = !DILocation(line: 445, column: 50, scope: !731)
!736 = !DILocation(line: 445, column: 20, scope: !704)
!737 = !DILocation(line: 448, column: 13, scope: !738)
!738 = distinct !DILexicalBlock(scope: !731, file: !6, line: 445, column: 56)
!739 = !DILocation(line: 450, column: 9, scope: !740)
!740 = distinct !DILexicalBlock(scope: !741, file: !6, line: 450, column: 9)
!741 = distinct !DILexicalBlock(scope: !688, file: !6, line: 450, column: 9)
!742 = !DILocation(line: 450, column: 9, scope: !741)
!743 = !DILocation(line: 465, column: 35, scope: !688)
!744 = !DILocation(line: 465, column: 40, scope: !688)
!745 = !DILocation(line: 465, column: 48, scope: !688)
!746 = !DILocation(line: 465, column: 55, scope: !688)
!747 = !DILocation(line: 465, column: 68, scope: !688)
!748 = !DILocation(line: 465, column: 15, scope: !688)
!749 = !DILocation(line: 465, column: 13, scope: !688)
!750 = !DILocation(line: 466, column: 17, scope: !688)
!751 = !DILocation(line: 466, column: 21, scope: !688)
!752 = !DILocation(line: 466, column: 16, scope: !688)
!753 = !DILocation(line: 466, column: 9, scope: !688)
!754 = !DILocation(line: 428, column: 62, scope: !682)
!755 = !DILocation(line: 428, column: 71, scope: !682)
!756 = !DILocation(line: 428, column: 5, scope: !682)
!757 = distinct !{!757, !686, !758, !212}
!758 = !DILocation(line: 467, column: 5, scope: !676)
!759 = !DILocation(line: 468, column: 5, scope: !652)
!760 = !DILocation(line: 469, column: 1, scope: !652)
!761 = distinct !DISubprogram(name: "rwlock_acquired_by_writer", scope: !106, file: !106, line: 99, type: !762, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!762 = !DISubroutineType(types: !763)
!763 = !{!42, !764}
!764 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !105, size: 64)
!765 = !DILocalVariable(name: "l", arg: 1, scope: !761, file: !106, line: 99, type: !764)
!766 = !DILocation(line: 99, column: 37, scope: !761)
!767 = !DILocation(line: 101, column: 31, scope: !761)
!768 = !DILocation(line: 101, column: 34, scope: !761)
!769 = !DILocation(line: 101, column: 12, scope: !761)
!770 = !DILocation(line: 101, column: 49, scope: !761)
!771 = !DILocation(line: 101, column: 5, scope: !761)
!772 = distinct !DISubprogram(name: "rwlock_acquired_by_readers", scope: !106, file: !106, line: 105, type: !762, scopeLine: 106, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!773 = !DILocalVariable(name: "l", arg: 1, scope: !772, file: !106, line: 105, type: !764)
!774 = !DILocation(line: 105, column: 38, scope: !772)
!775 = !DILocation(line: 107, column: 5, scope: !772)
!776 = !DILocation(line: 107, column: 5, scope: !777)
!777 = distinct !DILexicalBlock(scope: !772, file: !106, line: 107, column: 5)
!778 = !DILocation(line: 107, column: 5, scope: !779)
!779 = distinct !DILexicalBlock(scope: !777, file: !106, line: 107, column: 5)
!780 = !DILocation(line: 107, column: 5, scope: !781)
!781 = distinct !DILexicalBlock(scope: !779, file: !106, line: 107, column: 5)
!782 = !DILocation(line: 108, column: 5, scope: !772)
!783 = distinct !DISubprogram(name: "rwlock_read_release", scope: !106, file: !106, line: 82, type: !784, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!784 = !DISubroutineType(types: !785)
!785 = !{null, !764}
!786 = !DILocalVariable(name: "l", arg: 1, scope: !783, file: !106, line: 82, type: !764)
!787 = !DILocation(line: 82, column: 31, scope: !783)
!788 = !DILocalVariable(name: "idx", scope: !783, file: !106, line: 84, type: !29)
!789 = !DILocation(line: 84, column: 15, scope: !783)
!790 = !DILocation(line: 84, column: 37, scope: !783)
!791 = !DILocation(line: 84, column: 21, scope: !783)
!792 = !DILocation(line: 85, column: 27, scope: !783)
!793 = !DILocation(line: 85, column: 30, scope: !783)
!794 = !DILocation(line: 85, column: 35, scope: !783)
!795 = !DILocation(line: 85, column: 5, scope: !783)
!796 = !DILocation(line: 86, column: 1, scope: !783)
!797 = distinct !DISubprogram(name: "rwlock_read_acquire", scope: !106, file: !106, line: 71, type: !784, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!798 = !DILocalVariable(name: "l", arg: 1, scope: !797, file: !106, line: 71, type: !764)
!799 = !DILocation(line: 71, column: 31, scope: !797)
!800 = !DILocalVariable(name: "idx", scope: !797, file: !106, line: 73, type: !29)
!801 = !DILocation(line: 73, column: 15, scope: !797)
!802 = !DILocation(line: 73, column: 37, scope: !797)
!803 = !DILocation(line: 73, column: 21, scope: !797)
!804 = !DILocation(line: 74, column: 25, scope: !797)
!805 = !DILocation(line: 74, column: 28, scope: !797)
!806 = !DILocation(line: 74, column: 33, scope: !797)
!807 = !DILocation(line: 74, column: 5, scope: !797)
!808 = !DILocation(line: 75, column: 1, scope: !797)
!809 = distinct !DISubprogram(name: "vatomic8_read_rlx", scope: !810, file: !810, line: 109, type: !811, scopeLine: 110, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!810 = !DIFile(filename: "vatomic/include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "0c3ec6df2f26018f35fe6ca81ab8f3c9")
!811 = !DISubroutineType(types: !812)
!812 = !{!23, !813}
!813 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !814, size: 64)
!814 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !145)
!815 = !DILocalVariable(name: "a", arg: 1, scope: !809, file: !810, line: 109, type: !813)
!816 = !DILocation(line: 109, column: 37, scope: !809)
!817 = !DILocation(line: 111, column: 5, scope: !809)
!818 = !{i64 2148224495}
!819 = !DILocalVariable(name: "tmp", scope: !809, file: !810, line: 112, type: !23)
!820 = !DILocation(line: 112, column: 14, scope: !809)
!821 = !DILocation(line: 112, column: 47, scope: !809)
!822 = !DILocation(line: 112, column: 50, scope: !809)
!823 = !DILocation(line: 112, column: 30, scope: !809)
!824 = !DILocation(line: 113, column: 5, scope: !809)
!825 = !{i64 2148224535}
!826 = !DILocation(line: 114, column: 12, scope: !809)
!827 = !DILocation(line: 114, column: 5, scope: !809)
!828 = distinct !DISubprogram(name: "_rwlock_get_tid", scope: !106, file: !106, line: 89, type: !829, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!829 = !DISubroutineType(types: !830)
!830 = !{!29, !764}
!831 = !DILocalVariable(name: "l", arg: 1, scope: !828, file: !106, line: 89, type: !764)
!832 = !DILocation(line: 89, column: 27, scope: !828)
!833 = !DILocation(line: 91, column: 9, scope: !834)
!834 = distinct !DILexicalBlock(scope: !828, file: !106, line: 91, column: 9)
!835 = !DILocation(line: 91, column: 15, scope: !834)
!836 = !DILocation(line: 91, column: 9, scope: !828)
!837 = !DILocation(line: 92, column: 36, scope: !838)
!838 = distinct !DILexicalBlock(scope: !834, file: !106, line: 91, column: 38)
!839 = !DILocation(line: 92, column: 39, scope: !838)
!840 = !DILocation(line: 92, column: 17, scope: !838)
!841 = !DILocation(line: 92, column: 15, scope: !838)
!842 = !DILocation(line: 93, column: 9, scope: !843)
!843 = distinct !DILexicalBlock(scope: !844, file: !106, line: 93, column: 9)
!844 = distinct !DILexicalBlock(scope: !838, file: !106, line: 93, column: 9)
!845 = !DILocation(line: 93, column: 9, scope: !844)
!846 = !DILocation(line: 94, column: 5, scope: !838)
!847 = !DILocation(line: 95, column: 12, scope: !828)
!848 = !DILocation(line: 95, column: 5, scope: !828)
!849 = distinct !DISubprogram(name: "vatomic32_get_inc", scope: !850, file: !850, line: 2484, type: !851, scopeLine: 2485, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!850 = !DIFile(filename: "vatomic/include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "ff273838f95062d7181b3cf355a65f2b")
!851 = !DISubroutineType(types: !852)
!852 = !{!29, !853}
!853 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !150, size: 64)
!854 = !DILocalVariable(name: "a", arg: 1, scope: !849, file: !850, line: 2484, type: !853)
!855 = !DILocation(line: 2484, column: 32, scope: !849)
!856 = !DILocation(line: 2486, column: 30, scope: !849)
!857 = !DILocation(line: 2486, column: 12, scope: !849)
!858 = !DILocation(line: 2486, column: 5, scope: !849)
!859 = distinct !DISubprogram(name: "vatomic32_get_add", scope: !810, file: !810, line: 2351, type: !860, scopeLine: 2352, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!860 = !DISubroutineType(types: !861)
!861 = !{!29, !853, !29}
!862 = !DILocalVariable(name: "a", arg: 1, scope: !859, file: !810, line: 2351, type: !853)
!863 = !DILocation(line: 2351, column: 32, scope: !859)
!864 = !DILocalVariable(name: "v", arg: 2, scope: !859, file: !810, line: 2351, type: !29)
!865 = !DILocation(line: 2351, column: 45, scope: !859)
!866 = !DILocation(line: 2353, column: 5, scope: !859)
!867 = !{i64 2148236243}
!868 = !DILocalVariable(name: "tmp", scope: !859, file: !810, line: 2354, type: !29)
!869 = !DILocation(line: 2354, column: 15, scope: !859)
!870 = !DILocation(line: 2354, column: 52, scope: !859)
!871 = !DILocation(line: 2354, column: 55, scope: !859)
!872 = !DILocation(line: 2354, column: 59, scope: !859)
!873 = !DILocation(line: 2354, column: 32, scope: !859)
!874 = !DILocation(line: 2355, column: 5, scope: !859)
!875 = !{i64 2148236283}
!876 = !DILocation(line: 2356, column: 12, scope: !859)
!877 = !DILocation(line: 2356, column: 5, scope: !859)
!878 = distinct !DISubprogram(name: "vatomicptr_read", scope: !810, file: !810, line: 291, type: !879, scopeLine: 292, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!879 = !DISubroutineType(types: !880)
!880 = !{!22, !881}
!881 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !882, size: 64)
!882 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !72)
!883 = !DILocalVariable(name: "a", arg: 1, scope: !878, file: !810, line: 291, type: !881)
!884 = !DILocation(line: 291, column: 37, scope: !878)
!885 = !DILocation(line: 293, column: 5, scope: !878)
!886 = !{i64 2148225509}
!887 = !DILocalVariable(name: "tmp", scope: !878, file: !810, line: 294, type: !22)
!888 = !DILocation(line: 294, column: 11, scope: !878)
!889 = !DILocation(line: 294, column: 42, scope: !878)
!890 = !DILocation(line: 294, column: 45, scope: !878)
!891 = !DILocation(line: 294, column: 25, scope: !878)
!892 = !DILocation(line: 295, column: 5, scope: !878)
!893 = !{i64 2148225549}
!894 = !DILocation(line: 296, column: 12, scope: !878)
!895 = !DILocation(line: 296, column: 5, scope: !878)
!896 = distinct !DISubprogram(name: "vatomicptr_cmpxchg", scope: !810, file: !810, line: 1259, type: !897, scopeLine: 1260, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!897 = !DISubroutineType(types: !898)
!898 = !{!22, !899, !22, !22}
!899 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64)
!900 = !DILocalVariable(name: "a", arg: 1, scope: !896, file: !810, line: 1259, type: !899)
!901 = !DILocation(line: 1259, column: 34, scope: !896)
!902 = !DILocalVariable(name: "e", arg: 2, scope: !896, file: !810, line: 1259, type: !22)
!903 = !DILocation(line: 1259, column: 43, scope: !896)
!904 = !DILocalVariable(name: "v", arg: 3, scope: !896, file: !810, line: 1259, type: !22)
!905 = !DILocation(line: 1259, column: 52, scope: !896)
!906 = !DILocalVariable(name: "exp", scope: !896, file: !810, line: 1261, type: !22)
!907 = !DILocation(line: 1261, column: 11, scope: !896)
!908 = !DILocation(line: 1261, column: 25, scope: !896)
!909 = !DILocation(line: 1262, column: 5, scope: !896)
!910 = !{i64 2148230619}
!911 = !DILocation(line: 1263, column: 34, scope: !896)
!912 = !DILocation(line: 1263, column: 37, scope: !896)
!913 = !DILocation(line: 1263, column: 55, scope: !896)
!914 = !DILocation(line: 1263, column: 5, scope: !896)
!915 = !DILocation(line: 1265, column: 5, scope: !896)
!916 = !{i64 2148230661}
!917 = !DILocation(line: 1266, column: 12, scope: !896)
!918 = !DILocation(line: 1266, column: 5, scope: !896)
!919 = distinct !DISubprogram(name: "_trace_add_or_rem_occurrences", scope: !158, file: !158, line: 122, type: !920, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!920 = !DISubroutineType(types: !921)
!921 = !{null, !612, !19, !14, !42}
!922 = !DILocalVariable(name: "trace", arg: 1, scope: !919, file: !158, line: 122, type: !612)
!923 = !DILocation(line: 122, column: 40, scope: !919)
!924 = !DILocalVariable(name: "key", arg: 2, scope: !919, file: !158, line: 122, type: !19)
!925 = !DILocation(line: 122, column: 58, scope: !919)
!926 = !DILocalVariable(name: "count", arg: 3, scope: !919, file: !158, line: 122, type: !14)
!927 = !DILocation(line: 122, column: 71, scope: !919)
!928 = !DILocalVariable(name: "subtract", arg: 4, scope: !919, file: !158, line: 123, type: !42)
!929 = !DILocation(line: 123, column: 39, scope: !919)
!930 = !DILocalVariable(name: "idx", scope: !919, file: !158, line: 125, type: !14)
!931 = !DILocation(line: 125, column: 13, scope: !919)
!932 = !DILocalVariable(name: "found", scope: !919, file: !158, line: 126, type: !42)
!933 = !DILocation(line: 126, column: 13, scope: !919)
!934 = !DILocation(line: 128, column: 5, scope: !935)
!935 = distinct !DILexicalBlock(scope: !936, file: !158, line: 128, column: 5)
!936 = distinct !DILexicalBlock(scope: !919, file: !158, line: 128, column: 5)
!937 = !DILocation(line: 128, column: 5, scope: !936)
!938 = !DILocation(line: 129, column: 5, scope: !939)
!939 = distinct !DILexicalBlock(scope: !940, file: !158, line: 129, column: 5)
!940 = distinct !DILexicalBlock(scope: !919, file: !158, line: 129, column: 5)
!941 = !DILocation(line: 129, column: 5, scope: !940)
!942 = !DILocation(line: 131, column: 33, scope: !919)
!943 = !DILocation(line: 131, column: 40, scope: !919)
!944 = !DILocation(line: 131, column: 13, scope: !919)
!945 = !DILocation(line: 131, column: 11, scope: !919)
!946 = !DILocation(line: 133, column: 9, scope: !947)
!947 = distinct !DILexicalBlock(scope: !919, file: !158, line: 133, column: 9)
!948 = !DILocation(line: 133, column: 9, scope: !919)
!949 = !DILocation(line: 134, column: 9, scope: !950)
!950 = distinct !DILexicalBlock(scope: !951, file: !158, line: 134, column: 9)
!951 = distinct !DILexicalBlock(scope: !952, file: !158, line: 134, column: 9)
!952 = distinct !DILexicalBlock(scope: !947, file: !158, line: 133, column: 19)
!953 = !DILocation(line: 134, column: 9, scope: !951)
!954 = !DILocation(line: 135, column: 9, scope: !955)
!955 = distinct !DILexicalBlock(scope: !956, file: !158, line: 135, column: 9)
!956 = distinct !DILexicalBlock(scope: !952, file: !158, line: 135, column: 9)
!957 = !DILocation(line: 135, column: 9, scope: !956)
!958 = !DILocation(line: 136, column: 36, scope: !952)
!959 = !DILocation(line: 136, column: 9, scope: !952)
!960 = !DILocation(line: 136, column: 16, scope: !952)
!961 = !DILocation(line: 136, column: 22, scope: !952)
!962 = !DILocation(line: 136, column: 27, scope: !952)
!963 = !DILocation(line: 136, column: 33, scope: !952)
!964 = !DILocation(line: 137, column: 9, scope: !952)
!965 = !DILocation(line: 140, column: 10, scope: !966)
!966 = distinct !DILexicalBlock(scope: !919, file: !158, line: 140, column: 9)
!967 = !DILocation(line: 140, column: 9, scope: !919)
!968 = !DILocation(line: 141, column: 15, scope: !969)
!969 = distinct !DILexicalBlock(scope: !966, file: !158, line: 140, column: 17)
!970 = !DILocation(line: 141, column: 22, scope: !969)
!971 = !DILocation(line: 141, column: 25, scope: !969)
!972 = !DILocation(line: 141, column: 13, scope: !969)
!973 = !DILocation(line: 142, column: 13, scope: !974)
!974 = distinct !DILexicalBlock(scope: !969, file: !158, line: 142, column: 13)
!975 = !DILocation(line: 142, column: 20, scope: !974)
!976 = !DILocation(line: 142, column: 27, scope: !974)
!977 = !DILocation(line: 142, column: 17, scope: !974)
!978 = !DILocation(line: 142, column: 13, scope: !969)
!979 = !DILocation(line: 143, column: 26, scope: !980)
!980 = distinct !DILexicalBlock(scope: !974, file: !158, line: 142, column: 37)
!981 = !DILocation(line: 143, column: 13, scope: !980)
!982 = !DILocation(line: 144, column: 9, scope: !980)
!983 = !DILocation(line: 145, column: 35, scope: !969)
!984 = !DILocation(line: 145, column: 9, scope: !969)
!985 = !DILocation(line: 145, column: 16, scope: !969)
!986 = !DILocation(line: 145, column: 22, scope: !969)
!987 = !DILocation(line: 145, column: 27, scope: !969)
!988 = !DILocation(line: 145, column: 33, scope: !969)
!989 = !DILocation(line: 146, column: 35, scope: !969)
!990 = !DILocation(line: 146, column: 9, scope: !969)
!991 = !DILocation(line: 146, column: 16, scope: !969)
!992 = !DILocation(line: 146, column: 22, scope: !969)
!993 = !DILocation(line: 146, column: 27, scope: !969)
!994 = !DILocation(line: 146, column: 33, scope: !969)
!995 = !DILocation(line: 147, column: 5, scope: !969)
!996 = !DILocation(line: 148, column: 36, scope: !997)
!997 = distinct !DILexicalBlock(scope: !966, file: !158, line: 147, column: 12)
!998 = !DILocation(line: 148, column: 9, scope: !997)
!999 = !DILocation(line: 148, column: 16, scope: !997)
!1000 = !DILocation(line: 148, column: 22, scope: !997)
!1001 = !DILocation(line: 148, column: 27, scope: !997)
!1002 = !DILocation(line: 148, column: 33, scope: !997)
!1003 = !DILocation(line: 150, column: 1, scope: !919)
!1004 = distinct !DISubprogram(name: "trace_find_unit_idx", scope: !158, file: !158, line: 107, type: !1005, scopeLine: 108, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1005 = !DISubroutineType(types: !1006)
!1006 = !{!42, !612, !19, !1007}
!1007 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!1008 = !DILocalVariable(name: "trace", arg: 1, scope: !1004, file: !158, line: 107, type: !612)
!1009 = !DILocation(line: 107, column: 30, scope: !1004)
!1010 = !DILocalVariable(name: "key", arg: 2, scope: !1004, file: !158, line: 107, type: !19)
!1011 = !DILocation(line: 107, column: 48, scope: !1004)
!1012 = !DILocalVariable(name: "out_idx", arg: 3, scope: !1004, file: !158, line: 107, type: !1007)
!1013 = !DILocation(line: 107, column: 62, scope: !1004)
!1014 = !DILocalVariable(name: "i", scope: !1004, file: !158, line: 109, type: !14)
!1015 = !DILocation(line: 109, column: 13, scope: !1004)
!1016 = !DILocation(line: 110, column: 5, scope: !1017)
!1017 = distinct !DILexicalBlock(scope: !1018, file: !158, line: 110, column: 5)
!1018 = distinct !DILexicalBlock(scope: !1004, file: !158, line: 110, column: 5)
!1019 = !DILocation(line: 110, column: 5, scope: !1018)
!1020 = !DILocation(line: 111, column: 5, scope: !1021)
!1021 = distinct !DILexicalBlock(scope: !1022, file: !158, line: 111, column: 5)
!1022 = distinct !DILexicalBlock(scope: !1004, file: !158, line: 111, column: 5)
!1023 = !DILocation(line: 111, column: 5, scope: !1022)
!1024 = !DILocation(line: 112, column: 12, scope: !1025)
!1025 = distinct !DILexicalBlock(scope: !1004, file: !158, line: 112, column: 5)
!1026 = !DILocation(line: 112, column: 10, scope: !1025)
!1027 = !DILocation(line: 112, column: 17, scope: !1028)
!1028 = distinct !DILexicalBlock(scope: !1025, file: !158, line: 112, column: 5)
!1029 = !DILocation(line: 112, column: 21, scope: !1028)
!1030 = !DILocation(line: 112, column: 28, scope: !1028)
!1031 = !DILocation(line: 112, column: 19, scope: !1028)
!1032 = !DILocation(line: 112, column: 5, scope: !1025)
!1033 = !DILocation(line: 113, column: 13, scope: !1034)
!1034 = distinct !DILexicalBlock(scope: !1035, file: !158, line: 113, column: 13)
!1035 = distinct !DILexicalBlock(scope: !1028, file: !158, line: 112, column: 38)
!1036 = !DILocation(line: 113, column: 20, scope: !1034)
!1037 = !DILocation(line: 113, column: 26, scope: !1034)
!1038 = !DILocation(line: 113, column: 29, scope: !1034)
!1039 = !DILocation(line: 113, column: 36, scope: !1034)
!1040 = !DILocation(line: 113, column: 33, scope: !1034)
!1041 = !DILocation(line: 113, column: 13, scope: !1035)
!1042 = !DILocation(line: 114, column: 24, scope: !1043)
!1043 = distinct !DILexicalBlock(scope: !1034, file: !158, line: 113, column: 41)
!1044 = !DILocation(line: 114, column: 14, scope: !1043)
!1045 = !DILocation(line: 114, column: 22, scope: !1043)
!1046 = !DILocation(line: 115, column: 13, scope: !1043)
!1047 = !DILocation(line: 117, column: 5, scope: !1035)
!1048 = !DILocation(line: 112, column: 34, scope: !1028)
!1049 = !DILocation(line: 112, column: 5, scope: !1028)
!1050 = distinct !{!1050, !1032, !1051, !212}
!1051 = !DILocation(line: 117, column: 5, scope: !1025)
!1052 = !DILocation(line: 118, column: 5, scope: !1004)
!1053 = !DILocation(line: 119, column: 1, scope: !1004)
!1054 = distinct !DISubprogram(name: "trace_extend", scope: !158, file: !158, line: 73, type: !1055, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1055 = !DISubroutineType(types: !1056)
!1056 = !{null, !612}
!1057 = !DILocalVariable(name: "trace", arg: 1, scope: !1054, file: !158, line: 73, type: !612)
!1058 = !DILocation(line: 73, column: 23, scope: !1054)
!1059 = !DILocation(line: 75, column: 5, scope: !1060)
!1060 = distinct !DILexicalBlock(scope: !1061, file: !158, line: 75, column: 5)
!1061 = distinct !DILexicalBlock(scope: !1054, file: !158, line: 75, column: 5)
!1062 = !DILocation(line: 75, column: 5, scope: !1061)
!1063 = !DILocalVariable(name: "src_size", scope: !1054, file: !158, line: 77, type: !14)
!1064 = !DILocation(line: 77, column: 13, scope: !1054)
!1065 = !DILocation(line: 77, column: 24, scope: !1054)
!1066 = !DILocation(line: 77, column: 31, scope: !1054)
!1067 = !DILocation(line: 77, column: 40, scope: !1054)
!1068 = !DILocalVariable(name: "des_max", scope: !1054, file: !158, line: 78, type: !14)
!1069 = !DILocation(line: 78, column: 13, scope: !1054)
!1070 = !DILocation(line: 78, column: 24, scope: !1054)
!1071 = !DILocation(line: 78, column: 33, scope: !1054)
!1072 = !DILocalVariable(name: "src", scope: !1054, file: !158, line: 80, type: !162)
!1073 = !DILocation(line: 80, column: 19, scope: !1054)
!1074 = !DILocation(line: 80, column: 25, scope: !1054)
!1075 = !DILocation(line: 80, column: 32, scope: !1054)
!1076 = !DILocalVariable(name: "des", scope: !1054, file: !158, line: 81, type: !162)
!1077 = !DILocation(line: 81, column: 19, scope: !1054)
!1078 = !DILocation(line: 81, column: 32, scope: !1054)
!1079 = !DILocation(line: 81, column: 25, scope: !1054)
!1080 = !DILocation(line: 83, column: 9, scope: !1081)
!1081 = distinct !DILexicalBlock(scope: !1054, file: !158, line: 83, column: 9)
!1082 = !DILocation(line: 83, column: 9, scope: !1054)
!1083 = !DILocalVariable(name: "ret", scope: !1084, file: !158, line: 84, type: !119)
!1084 = distinct !DILexicalBlock(scope: !1081, file: !158, line: 83, column: 14)
!1085 = !DILocation(line: 84, column: 13, scope: !1084)
!1086 = !DILocation(line: 84, column: 28, scope: !1084)
!1087 = !DILocation(line: 84, column: 33, scope: !1084)
!1088 = !DILocation(line: 84, column: 42, scope: !1084)
!1089 = !DILocation(line: 84, column: 47, scope: !1084)
!1090 = !DILocation(line: 84, column: 19, scope: !1084)
!1091 = !DILocation(line: 85, column: 13, scope: !1092)
!1092 = distinct !DILexicalBlock(scope: !1084, file: !158, line: 85, column: 13)
!1093 = !DILocation(line: 85, column: 17, scope: !1092)
!1094 = !DILocation(line: 85, column: 13, scope: !1084)
!1095 = !DILocation(line: 86, column: 28, scope: !1096)
!1096 = distinct !DILexicalBlock(scope: !1092, file: !158, line: 85, column: 23)
!1097 = !DILocation(line: 86, column: 13, scope: !1096)
!1098 = !DILocation(line: 86, column: 20, scope: !1096)
!1099 = !DILocation(line: 86, column: 26, scope: !1096)
!1100 = !DILocation(line: 87, column: 13, scope: !1096)
!1101 = !DILocation(line: 87, column: 20, scope: !1096)
!1102 = !DILocation(line: 87, column: 29, scope: !1096)
!1103 = !DILocation(line: 88, column: 9, scope: !1096)
!1104 = !DILocation(line: 89, column: 13, scope: !1105)
!1105 = distinct !DILexicalBlock(scope: !1106, file: !158, line: 89, column: 13)
!1106 = distinct !DILexicalBlock(scope: !1107, file: !158, line: 89, column: 13)
!1107 = distinct !DILexicalBlock(scope: !1092, file: !158, line: 88, column: 16)
!1108 = !DILocation(line: 91, column: 14, scope: !1084)
!1109 = !DILocation(line: 91, column: 9, scope: !1084)
!1110 = !DILocation(line: 92, column: 5, scope: !1084)
!1111 = !DILocation(line: 93, column: 9, scope: !1112)
!1112 = distinct !DILexicalBlock(scope: !1113, file: !158, line: 93, column: 9)
!1113 = distinct !DILexicalBlock(scope: !1114, file: !158, line: 93, column: 9)
!1114 = distinct !DILexicalBlock(scope: !1081, file: !158, line: 92, column: 12)
!1115 = !DILocation(line: 95, column: 1, scope: !1054)
!1116 = distinct !DISubprogram(name: "vsimpleht_remove", scope: !6, file: !6, line: 354, type: !1117, scopeLine: 355, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1117 = !DISubroutineType(types: !1118)
!1118 = !{!586, !587, !19}
!1119 = !DILocalVariable(name: "tbl", arg: 1, scope: !1116, file: !6, line: 354, type: !587)
!1120 = !DILocation(line: 354, column: 31, scope: !1116)
!1121 = !DILocalVariable(name: "key", arg: 2, scope: !1116, file: !6, line: 354, type: !19)
!1122 = !DILocation(line: 354, column: 47, scope: !1116)
!1123 = !DILocalVariable(name: "index", scope: !1116, file: !6, line: 363, type: !14)
!1124 = !DILocation(line: 363, column: 13, scope: !1116)
!1125 = !DILocalVariable(name: "probed_key", scope: !1116, file: !6, line: 364, type: !19)
!1126 = !DILocation(line: 364, column: 16, scope: !1116)
!1127 = !DILocalVariable(name: "probed_value", scope: !1116, file: !6, line: 365, type: !22)
!1128 = !DILocation(line: 365, column: 11, scope: !1116)
!1129 = !DILocalVariable(name: "start_index", scope: !1116, file: !6, line: 366, type: !14)
!1130 = !DILocation(line: 366, column: 13, scope: !1116)
!1131 = !DILocation(line: 366, column: 29, scope: !1116)
!1132 = !DILocation(line: 366, column: 34, scope: !1116)
!1133 = !DILocation(line: 366, column: 43, scope: !1116)
!1134 = !DILocation(line: 367, column: 29, scope: !1116)
!1135 = !DILocation(line: 367, column: 44, scope: !1116)
!1136 = !DILocation(line: 367, column: 49, scope: !1116)
!1137 = !DILocation(line: 367, column: 58, scope: !1116)
!1138 = !DILocation(line: 367, column: 41, scope: !1116)
!1139 = !DILocation(line: 367, column: 27, scope: !1116)
!1140 = !DILocation(line: 368, column: 38, scope: !1116)
!1141 = !DILocation(line: 368, column: 5, scope: !1116)
!1142 = !DILocation(line: 369, column: 5, scope: !1116)
!1143 = !DILocation(line: 370, column: 51, scope: !1144)
!1144 = distinct !DILexicalBlock(scope: !1116, file: !6, line: 369, column: 8)
!1145 = !DILocation(line: 370, column: 56, scope: !1144)
!1146 = !DILocation(line: 370, column: 64, scope: !1144)
!1147 = !DILocation(line: 370, column: 71, scope: !1144)
!1148 = !DILocation(line: 370, column: 34, scope: !1144)
!1149 = !DILocation(line: 370, column: 22, scope: !1144)
!1150 = !DILocation(line: 370, column: 20, scope: !1144)
!1151 = !DILocation(line: 371, column: 13, scope: !1152)
!1152 = distinct !DILexicalBlock(scope: !1144, file: !6, line: 371, column: 13)
!1153 = !DILocation(line: 371, column: 24, scope: !1152)
!1154 = !DILocation(line: 371, column: 13, scope: !1144)
!1155 = !DILocation(line: 374, column: 13, scope: !1156)
!1156 = distinct !DILexicalBlock(scope: !1152, file: !6, line: 371, column: 30)
!1157 = !DILocation(line: 375, column: 20, scope: !1158)
!1158 = distinct !DILexicalBlock(scope: !1152, file: !6, line: 375, column: 20)
!1159 = !DILocation(line: 375, column: 25, scope: !1158)
!1160 = !DILocation(line: 375, column: 33, scope: !1158)
!1161 = !DILocation(line: 375, column: 38, scope: !1158)
!1162 = !DILocation(line: 375, column: 50, scope: !1158)
!1163 = !DILocation(line: 375, column: 20, scope: !1152)
!1164 = !DILocation(line: 376, column: 49, scope: !1165)
!1165 = distinct !DILexicalBlock(scope: !1158, file: !6, line: 375, column: 56)
!1166 = !DILocation(line: 376, column: 54, scope: !1165)
!1167 = !DILocation(line: 376, column: 62, scope: !1165)
!1168 = !DILocation(line: 376, column: 69, scope: !1165)
!1169 = !DILocation(line: 376, column: 28, scope: !1165)
!1170 = !DILocation(line: 376, column: 26, scope: !1165)
!1171 = !DILocation(line: 379, column: 17, scope: !1172)
!1172 = distinct !DILexicalBlock(scope: !1165, file: !6, line: 379, column: 17)
!1173 = !DILocation(line: 379, column: 30, scope: !1172)
!1174 = !DILocation(line: 379, column: 17, scope: !1165)
!1175 = !DILocation(line: 381, column: 17, scope: !1176)
!1176 = distinct !DILexicalBlock(scope: !1172, file: !6, line: 379, column: 39)
!1177 = !DILocation(line: 384, column: 41, scope: !1178)
!1178 = distinct !DILexicalBlock(scope: !1165, file: !6, line: 384, column: 17)
!1179 = !DILocation(line: 384, column: 46, scope: !1178)
!1180 = !DILocation(line: 384, column: 54, scope: !1178)
!1181 = !DILocation(line: 384, column: 61, scope: !1178)
!1182 = !DILocation(line: 384, column: 68, scope: !1178)
!1183 = !DILocation(line: 384, column: 17, scope: !1178)
!1184 = !DILocation(line: 385, column: 49, scope: !1178)
!1185 = !DILocation(line: 385, column: 46, scope: !1178)
!1186 = !DILocation(line: 384, column: 17, scope: !1165)
!1187 = !DILocation(line: 386, column: 36, scope: !1188)
!1188 = distinct !DILexicalBlock(scope: !1178, file: !6, line: 385, column: 63)
!1189 = !DILocation(line: 386, column: 41, scope: !1188)
!1190 = !DILocation(line: 386, column: 17, scope: !1188)
!1191 = !DILocation(line: 388, column: 44, scope: !1188)
!1192 = !DILocation(line: 388, column: 49, scope: !1188)
!1193 = !DILocation(line: 388, column: 17, scope: !1188)
!1194 = !DILocation(line: 389, column: 17, scope: !1188)
!1195 = !DILocation(line: 391, column: 13, scope: !1165)
!1196 = !DILocation(line: 394, column: 14, scope: !1144)
!1197 = !DILocation(line: 395, column: 18, scope: !1144)
!1198 = !DILocation(line: 395, column: 23, scope: !1144)
!1199 = !DILocation(line: 395, column: 32, scope: !1144)
!1200 = !DILocation(line: 395, column: 15, scope: !1144)
!1201 = !DILocation(line: 396, column: 5, scope: !1144)
!1202 = !DILocation(line: 396, column: 14, scope: !1116)
!1203 = !DILocation(line: 396, column: 23, scope: !1116)
!1204 = !DILocation(line: 396, column: 20, scope: !1116)
!1205 = distinct !{!1205, !1142, !1206, !212}
!1206 = !DILocation(line: 396, column: 34, scope: !1116)
!1207 = !DILocation(line: 399, column: 5, scope: !1116)
!1208 = !DILocation(line: 401, column: 1, scope: !1116)
!1209 = distinct !DISubprogram(name: "vatomicptr_read_acq", scope: !810, file: !810, line: 305, type: !879, scopeLine: 306, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1210 = !DILocalVariable(name: "a", arg: 1, scope: !1209, file: !810, line: 305, type: !881)
!1211 = !DILocation(line: 305, column: 41, scope: !1209)
!1212 = !DILocation(line: 307, column: 5, scope: !1209)
!1213 = !{i64 2148225587}
!1214 = !DILocalVariable(name: "tmp", scope: !1209, file: !810, line: 308, type: !22)
!1215 = !DILocation(line: 308, column: 11, scope: !1209)
!1216 = !DILocation(line: 308, column: 42, scope: !1209)
!1217 = !DILocation(line: 308, column: 45, scope: !1209)
!1218 = !DILocation(line: 308, column: 25, scope: !1209)
!1219 = !DILocation(line: 309, column: 5, scope: !1209)
!1220 = !{i64 2148225627}
!1221 = !DILocation(line: 310, column: 12, scope: !1209)
!1222 = !DILocation(line: 310, column: 5, scope: !1209)
!1223 = distinct !DISubprogram(name: "vatomicptr_cmpxchg_rel", scope: !810, file: !810, line: 1291, type: !897, scopeLine: 1292, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1224 = !DILocalVariable(name: "a", arg: 1, scope: !1223, file: !810, line: 1291, type: !899)
!1225 = !DILocation(line: 1291, column: 38, scope: !1223)
!1226 = !DILocalVariable(name: "e", arg: 2, scope: !1223, file: !810, line: 1291, type: !22)
!1227 = !DILocation(line: 1291, column: 47, scope: !1223)
!1228 = !DILocalVariable(name: "v", arg: 3, scope: !1223, file: !810, line: 1291, type: !22)
!1229 = !DILocation(line: 1291, column: 56, scope: !1223)
!1230 = !DILocalVariable(name: "exp", scope: !1223, file: !810, line: 1293, type: !22)
!1231 = !DILocation(line: 1293, column: 11, scope: !1223)
!1232 = !DILocation(line: 1293, column: 25, scope: !1223)
!1233 = !DILocation(line: 1294, column: 5, scope: !1223)
!1234 = !{i64 2148230779}
!1235 = !DILocation(line: 1295, column: 34, scope: !1223)
!1236 = !DILocation(line: 1295, column: 37, scope: !1223)
!1237 = !DILocation(line: 1295, column: 55, scope: !1223)
!1238 = !DILocation(line: 1295, column: 5, scope: !1223)
!1239 = !DILocation(line: 1297, column: 5, scope: !1223)
!1240 = !{i64 2148230821}
!1241 = !DILocation(line: 1298, column: 12, scope: !1223)
!1242 = !DILocation(line: 1298, column: 5, scope: !1223)
!1243 = distinct !DISubprogram(name: "vatomicsz_inc_rlx", scope: !850, file: !850, line: 3045, type: !1244, scopeLine: 3046, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1244 = !DISubroutineType(types: !1245)
!1245 = !{null, !1246}
!1246 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64)
!1247 = !DILocalVariable(name: "a", arg: 1, scope: !1243, file: !850, line: 3045, type: !1246)
!1248 = !DILocation(line: 3045, column: 32, scope: !1243)
!1249 = !DILocation(line: 3047, column: 33, scope: !1243)
!1250 = !DILocation(line: 3047, column: 11, scope: !1243)
!1251 = !DILocation(line: 3048, column: 1, scope: !1243)
!1252 = distinct !DISubprogram(name: "_vsimpleht_trigger_cleanup", scope: !6, file: !6, line: 501, type: !1253, scopeLine: 502, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1253 = !DISubroutineType(types: !1254)
!1254 = !{null, !587, !22}
!1255 = !DILocalVariable(name: "tbl", arg: 1, scope: !1252, file: !6, line: 501, type: !587)
!1256 = !DILocation(line: 501, column: 41, scope: !1252)
!1257 = !DILocalVariable(name: "val", arg: 2, scope: !1252, file: !6, line: 501, type: !22)
!1258 = !DILocation(line: 501, column: 52, scope: !1252)
!1259 = !DILocation(line: 506, column: 5, scope: !1260)
!1260 = distinct !DILexicalBlock(scope: !1261, file: !6, line: 506, column: 5)
!1261 = distinct !DILexicalBlock(scope: !1252, file: !6, line: 506, column: 5)
!1262 = !DILocation(line: 506, column: 5, scope: !1261)
!1263 = !DILocation(line: 509, column: 26, scope: !1252)
!1264 = !DILocation(line: 509, column: 31, scope: !1252)
!1265 = !DILocation(line: 509, column: 5, scope: !1252)
!1266 = !DILocation(line: 510, column: 24, scope: !1252)
!1267 = !DILocation(line: 510, column: 29, scope: !1252)
!1268 = !DILocation(line: 510, column: 5, scope: !1252)
!1269 = !DILocation(line: 511, column: 26, scope: !1252)
!1270 = !DILocation(line: 511, column: 31, scope: !1252)
!1271 = !DILocation(line: 511, column: 5, scope: !1252)
!1272 = !DILocation(line: 513, column: 1, scope: !1252)
!1273 = distinct !DISubprogram(name: "vatomicsz_get_inc_rlx", scope: !850, file: !850, line: 2605, type: !1274, scopeLine: 2606, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1274 = !DISubroutineType(types: !1275)
!1275 = !{!14, !1246}
!1276 = !DILocalVariable(name: "a", arg: 1, scope: !1273, file: !850, line: 2605, type: !1246)
!1277 = !DILocation(line: 2605, column: 36, scope: !1273)
!1278 = !DILocation(line: 2607, column: 34, scope: !1273)
!1279 = !DILocation(line: 2607, column: 12, scope: !1273)
!1280 = !DILocation(line: 2607, column: 5, scope: !1273)
!1281 = distinct !DISubprogram(name: "vatomicsz_get_add_rlx", scope: !810, file: !810, line: 2505, type: !1282, scopeLine: 2506, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1282 = !DISubroutineType(types: !1283)
!1283 = !{!14, !1246, !14}
!1284 = !DILocalVariable(name: "a", arg: 1, scope: !1281, file: !810, line: 2505, type: !1246)
!1285 = !DILocation(line: 2505, column: 36, scope: !1281)
!1286 = !DILocalVariable(name: "v", arg: 2, scope: !1281, file: !810, line: 2505, type: !14)
!1287 = !DILocation(line: 2505, column: 47, scope: !1281)
!1288 = !DILocation(line: 2507, column: 5, scope: !1281)
!1289 = !{i64 2148237101}
!1290 = !DILocalVariable(name: "tmp", scope: !1281, file: !810, line: 2508, type: !14)
!1291 = !DILocation(line: 2508, column: 13, scope: !1281)
!1292 = !DILocation(line: 2508, column: 48, scope: !1281)
!1293 = !DILocation(line: 2508, column: 51, scope: !1281)
!1294 = !DILocation(line: 2508, column: 55, scope: !1281)
!1295 = !DILocation(line: 2508, column: 28, scope: !1281)
!1296 = !DILocation(line: 2509, column: 5, scope: !1281)
!1297 = !{i64 2148237141}
!1298 = !DILocation(line: 2510, column: 12, scope: !1281)
!1299 = !DILocation(line: 2510, column: 5, scope: !1281)
!1300 = distinct !DISubprogram(name: "_vsimpleht_cleanup", scope: !6, file: !6, line: 530, type: !1253, scopeLine: 531, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1301 = !DILocalVariable(name: "tbl", arg: 1, scope: !1300, file: !6, line: 530, type: !587)
!1302 = !DILocation(line: 530, column: 33, scope: !1300)
!1303 = !DILocalVariable(name: "val", arg: 2, scope: !1300, file: !6, line: 530, type: !22)
!1304 = !DILocation(line: 530, column: 44, scope: !1300)
!1305 = !DILocalVariable(name: "e", scope: !1300, file: !6, line: 532, type: !14)
!1306 = !DILocation(line: 532, column: 13, scope: !1300)
!1307 = !DILocalVariable(name: "i", scope: !1300, file: !6, line: 533, type: !14)
!1308 = !DILocation(line: 533, column: 13, scope: !1300)
!1309 = !DILocalVariable(name: "key", scope: !1300, file: !6, line: 534, type: !19)
!1310 = !DILocation(line: 534, column: 16, scope: !1300)
!1311 = !DILocalVariable(name: "value", scope: !1300, file: !6, line: 535, type: !22)
!1312 = !DILocation(line: 535, column: 11, scope: !1300)
!1313 = !DILocalVariable(name: "len", scope: !1300, file: !6, line: 536, type: !14)
!1314 = !DILocation(line: 536, column: 13, scope: !1300)
!1315 = !DILocation(line: 536, column: 19, scope: !1300)
!1316 = !DILocation(line: 536, column: 24, scope: !1300)
!1317 = !DILocalVariable(name: "entries", scope: !1300, file: !6, line: 537, type: !67)
!1318 = !DILocation(line: 537, column: 24, scope: !1300)
!1319 = !DILocation(line: 537, column: 34, scope: !1300)
!1320 = !DILocation(line: 537, column: 39, scope: !1300)
!1321 = !DILocalVariable(name: "start_index", scope: !1300, file: !6, line: 538, type: !14)
!1322 = !DILocation(line: 538, column: 13, scope: !1300)
!1323 = !DILocation(line: 538, column: 27, scope: !1300)
!1324 = !DILocation(line: 538, column: 31, scope: !1300)
!1325 = !DILocalVariable(name: "ret", scope: !1300, file: !6, line: 539, type: !24)
!1326 = !DILocation(line: 539, column: 13, scope: !1300)
!1327 = !DILocation(line: 542, column: 27, scope: !1300)
!1328 = !DILocation(line: 542, column: 32, scope: !1300)
!1329 = !DILocation(line: 542, column: 5, scope: !1300)
!1330 = !DILocation(line: 545, column: 29, scope: !1331)
!1331 = distinct !DILexicalBlock(scope: !1300, file: !6, line: 545, column: 9)
!1332 = !DILocation(line: 545, column: 34, scope: !1331)
!1333 = !DILocation(line: 545, column: 9, scope: !1331)
!1334 = !DILocation(line: 545, column: 51, scope: !1331)
!1335 = !DILocation(line: 545, column: 56, scope: !1331)
!1336 = !DILocation(line: 545, column: 49, scope: !1331)
!1337 = !DILocation(line: 545, column: 9, scope: !1300)
!1338 = !DILocation(line: 546, column: 9, scope: !1339)
!1339 = distinct !DILexicalBlock(scope: !1331, file: !6, line: 545, column: 76)
!1340 = !DILocation(line: 556, column: 12, scope: !1341)
!1341 = distinct !DILexicalBlock(scope: !1300, file: !6, line: 556, column: 5)
!1342 = !DILocation(line: 556, column: 10, scope: !1341)
!1343 = !DILocation(line: 556, column: 17, scope: !1344)
!1344 = distinct !DILexicalBlock(scope: !1341, file: !6, line: 556, column: 5)
!1345 = !DILocation(line: 556, column: 21, scope: !1344)
!1346 = !DILocation(line: 556, column: 19, scope: !1344)
!1347 = !DILocation(line: 556, column: 5, scope: !1341)
!1348 = !DILocation(line: 557, column: 48, scope: !1349)
!1349 = distinct !DILexicalBlock(scope: !1344, file: !6, line: 556, column: 31)
!1350 = !DILocation(line: 557, column: 56, scope: !1349)
!1351 = !DILocation(line: 557, column: 59, scope: !1349)
!1352 = !DILocation(line: 557, column: 27, scope: !1349)
!1353 = !DILocation(line: 557, column: 15, scope: !1349)
!1354 = !DILocation(line: 557, column: 13, scope: !1349)
!1355 = !DILocation(line: 558, column: 38, scope: !1349)
!1356 = !DILocation(line: 558, column: 46, scope: !1349)
!1357 = !DILocation(line: 558, column: 49, scope: !1349)
!1358 = !DILocation(line: 558, column: 17, scope: !1349)
!1359 = !DILocation(line: 558, column: 15, scope: !1349)
!1360 = !DILocation(line: 559, column: 13, scope: !1361)
!1361 = distinct !DILexicalBlock(scope: !1349, file: !6, line: 559, column: 13)
!1362 = !DILocation(line: 559, column: 17, scope: !1361)
!1363 = !DILocation(line: 559, column: 13, scope: !1349)
!1364 = !DILocation(line: 560, column: 27, scope: !1365)
!1365 = distinct !DILexicalBlock(scope: !1361, file: !6, line: 559, column: 23)
!1366 = !DILocation(line: 560, column: 25, scope: !1365)
!1367 = !DILocation(line: 561, column: 13, scope: !1365)
!1368 = !DILocation(line: 563, column: 5, scope: !1349)
!1369 = !DILocation(line: 556, column: 27, scope: !1344)
!1370 = !DILocation(line: 556, column: 5, scope: !1344)
!1371 = distinct !{!1371, !1347, !1372, !212}
!1372 = !DILocation(line: 563, column: 5, scope: !1341)
!1373 = !DILocation(line: 571, column: 12, scope: !1374)
!1374 = distinct !DILexicalBlock(scope: !1300, file: !6, line: 571, column: 5)
!1375 = !DILocation(line: 571, column: 10, scope: !1374)
!1376 = !DILocation(line: 571, column: 17, scope: !1377)
!1377 = distinct !DILexicalBlock(scope: !1374, file: !6, line: 571, column: 5)
!1378 = !DILocation(line: 571, column: 21, scope: !1377)
!1379 = !DILocation(line: 571, column: 19, scope: !1377)
!1380 = !DILocation(line: 571, column: 5, scope: !1374)
!1381 = !DILocation(line: 572, column: 14, scope: !1382)
!1382 = distinct !DILexicalBlock(scope: !1377, file: !6, line: 571, column: 31)
!1383 = !DILocation(line: 572, column: 18, scope: !1382)
!1384 = !DILocation(line: 572, column: 16, scope: !1382)
!1385 = !DILocation(line: 572, column: 34, scope: !1382)
!1386 = !DILocation(line: 572, column: 38, scope: !1382)
!1387 = !DILocation(line: 572, column: 31, scope: !1382)
!1388 = !DILocation(line: 572, column: 11, scope: !1382)
!1389 = !DILocation(line: 573, column: 48, scope: !1382)
!1390 = !DILocation(line: 573, column: 56, scope: !1382)
!1391 = !DILocation(line: 573, column: 59, scope: !1382)
!1392 = !DILocation(line: 573, column: 27, scope: !1382)
!1393 = !DILocation(line: 573, column: 15, scope: !1382)
!1394 = !DILocation(line: 573, column: 13, scope: !1382)
!1395 = !DILocation(line: 574, column: 38, scope: !1382)
!1396 = !DILocation(line: 574, column: 46, scope: !1382)
!1397 = !DILocation(line: 574, column: 49, scope: !1382)
!1398 = !DILocation(line: 574, column: 17, scope: !1382)
!1399 = !DILocation(line: 574, column: 15, scope: !1382)
!1400 = !DILocation(line: 575, column: 13, scope: !1401)
!1401 = distinct !DILexicalBlock(scope: !1382, file: !6, line: 575, column: 13)
!1402 = !DILocation(line: 575, column: 17, scope: !1401)
!1403 = !DILocation(line: 575, column: 22, scope: !1401)
!1404 = !DILocation(line: 575, column: 25, scope: !1401)
!1405 = !DILocation(line: 575, column: 31, scope: !1401)
!1406 = !DILocation(line: 575, column: 13, scope: !1382)
!1407 = !DILocation(line: 579, column: 34, scope: !1408)
!1408 = distinct !DILexicalBlock(scope: !1401, file: !6, line: 575, column: 40)
!1409 = !DILocation(line: 579, column: 39, scope: !1408)
!1410 = !DILocation(line: 579, column: 44, scope: !1408)
!1411 = !DILocation(line: 579, column: 19, scope: !1408)
!1412 = !DILocation(line: 579, column: 17, scope: !1408)
!1413 = !DILocation(line: 580, column: 17, scope: !1414)
!1414 = distinct !DILexicalBlock(scope: !1408, file: !6, line: 580, column: 17)
!1415 = !DILocation(line: 580, column: 21, scope: !1414)
!1416 = !DILocation(line: 580, column: 17, scope: !1408)
!1417 = !DILocation(line: 581, column: 39, scope: !1418)
!1418 = distinct !DILexicalBlock(scope: !1414, file: !6, line: 580, column: 42)
!1419 = !DILocation(line: 581, column: 47, scope: !1418)
!1420 = !DILocation(line: 581, column: 50, scope: !1418)
!1421 = !DILocation(line: 581, column: 17, scope: !1418)
!1422 = !DILocation(line: 582, column: 39, scope: !1418)
!1423 = !DILocation(line: 582, column: 47, scope: !1418)
!1424 = !DILocation(line: 582, column: 50, scope: !1418)
!1425 = !DILocation(line: 582, column: 17, scope: !1418)
!1426 = !DILocation(line: 583, column: 13, scope: !1418)
!1427 = !DILocation(line: 584, column: 13, scope: !1428)
!1428 = distinct !DILexicalBlock(scope: !1429, file: !6, line: 584, column: 13)
!1429 = distinct !DILexicalBlock(scope: !1408, file: !6, line: 584, column: 13)
!1430 = !DILocation(line: 584, column: 13, scope: !1429)
!1431 = !DILocation(line: 587, column: 9, scope: !1408)
!1432 = !DILocation(line: 587, column: 20, scope: !1433)
!1433 = distinct !DILexicalBlock(scope: !1401, file: !6, line: 587, column: 20)
!1434 = !DILocation(line: 587, column: 24, scope: !1433)
!1435 = !DILocation(line: 587, column: 29, scope: !1433)
!1436 = !DILocation(line: 587, column: 32, scope: !1433)
!1437 = !DILocation(line: 587, column: 38, scope: !1433)
!1438 = !DILocation(line: 587, column: 20, scope: !1401)
!1439 = !DILocation(line: 588, column: 35, scope: !1440)
!1440 = distinct !DILexicalBlock(scope: !1433, file: !6, line: 587, column: 47)
!1441 = !DILocation(line: 588, column: 43, scope: !1440)
!1442 = !DILocation(line: 588, column: 46, scope: !1440)
!1443 = !DILocation(line: 588, column: 13, scope: !1440)
!1444 = !DILocation(line: 589, column: 9, scope: !1440)
!1445 = !DILocation(line: 590, column: 5, scope: !1382)
!1446 = !DILocation(line: 571, column: 27, scope: !1377)
!1447 = !DILocation(line: 571, column: 5, scope: !1377)
!1448 = distinct !{!1448, !1380, !1449, !212}
!1449 = !DILocation(line: 590, column: 5, scope: !1374)
!1450 = !DILocation(line: 591, column: 26, scope: !1300)
!1451 = !DILocation(line: 591, column: 31, scope: !1300)
!1452 = !DILocation(line: 591, column: 5, scope: !1300)
!1453 = !DILabel(scope: !1300, name: "CLEANUP_EXIT", file: !6, line: 593)
!1454 = !DILocation(line: 593, column: 1, scope: !1300)
!1455 = !DILocation(line: 594, column: 5, scope: !1300)
!1456 = !DILocation(line: 594, column: 10, scope: !1300)
!1457 = !DILocation(line: 594, column: 21, scope: !1300)
!1458 = !DILocation(line: 595, column: 27, scope: !1300)
!1459 = !DILocation(line: 595, column: 32, scope: !1300)
!1460 = !DILocation(line: 595, column: 5, scope: !1300)
!1461 = !DILocation(line: 596, column: 1, scope: !1300)
!1462 = distinct !DISubprogram(name: "rwlock_write_acquire", scope: !106, file: !106, line: 45, type: !784, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1463 = !DILocalVariable(name: "l", arg: 1, scope: !1462, file: !106, line: 45, type: !764)
!1464 = !DILocation(line: 45, column: 32, scope: !1462)
!1465 = !DILocation(line: 47, column: 25, scope: !1462)
!1466 = !DILocation(line: 47, column: 28, scope: !1462)
!1467 = !DILocation(line: 47, column: 5, scope: !1462)
!1468 = !DILocalVariable(name: "i", scope: !1469, file: !106, line: 48, type: !14)
!1469 = distinct !DILexicalBlock(scope: !1462, file: !106, line: 48, column: 5)
!1470 = !DILocation(line: 48, column: 18, scope: !1469)
!1471 = !DILocation(line: 48, column: 10, scope: !1469)
!1472 = !DILocation(line: 48, column: 25, scope: !1473)
!1473 = distinct !DILexicalBlock(scope: !1469, file: !106, line: 48, column: 5)
!1474 = !DILocation(line: 48, column: 27, scope: !1473)
!1475 = !DILocation(line: 48, column: 5, scope: !1469)
!1476 = !DILocation(line: 49, column: 29, scope: !1477)
!1477 = distinct !DILexicalBlock(scope: !1473, file: !106, line: 48, column: 54)
!1478 = !DILocation(line: 49, column: 32, scope: !1477)
!1479 = !DILocation(line: 49, column: 37, scope: !1477)
!1480 = !DILocation(line: 49, column: 9, scope: !1477)
!1481 = !DILocation(line: 50, column: 5, scope: !1477)
!1482 = !DILocation(line: 48, column: 50, scope: !1473)
!1483 = !DILocation(line: 48, column: 5, scope: !1473)
!1484 = distinct !{!1484, !1475, !1485, !212}
!1485 = !DILocation(line: 50, column: 5, scope: !1469)
!1486 = !DILocation(line: 51, column: 1, scope: !1462)
!1487 = distinct !DISubprogram(name: "vatomicsz_read_rlx", scope: !810, file: !810, line: 277, type: !1488, scopeLine: 278, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1488 = !DISubroutineType(types: !1489)
!1489 = !{!14, !1490}
!1490 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1491, size: 64)
!1491 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !100)
!1492 = !DILocalVariable(name: "a", arg: 1, scope: !1487, file: !810, line: 277, type: !1490)
!1493 = !DILocation(line: 277, column: 39, scope: !1487)
!1494 = !DILocation(line: 279, column: 5, scope: !1487)
!1495 = !{i64 2148225431}
!1496 = !DILocalVariable(name: "tmp", scope: !1487, file: !810, line: 280, type: !14)
!1497 = !DILocation(line: 280, column: 13, scope: !1487)
!1498 = !DILocation(line: 280, column: 45, scope: !1487)
!1499 = !DILocation(line: 280, column: 48, scope: !1487)
!1500 = !DILocation(line: 280, column: 28, scope: !1487)
!1501 = !DILocation(line: 281, column: 5, scope: !1487)
!1502 = !{i64 2148225471}
!1503 = !DILocation(line: 282, column: 12, scope: !1487)
!1504 = !DILocation(line: 282, column: 5, scope: !1487)
!1505 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !810, file: !810, line: 319, type: !879, scopeLine: 320, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1506 = !DILocalVariable(name: "a", arg: 1, scope: !1505, file: !810, line: 319, type: !881)
!1507 = !DILocation(line: 319, column: 41, scope: !1505)
!1508 = !DILocation(line: 321, column: 5, scope: !1505)
!1509 = !{i64 2148225665}
!1510 = !DILocalVariable(name: "tmp", scope: !1505, file: !810, line: 322, type: !22)
!1511 = !DILocation(line: 322, column: 11, scope: !1505)
!1512 = !DILocation(line: 322, column: 42, scope: !1505)
!1513 = !DILocation(line: 322, column: 45, scope: !1505)
!1514 = !DILocation(line: 322, column: 25, scope: !1505)
!1515 = !DILocation(line: 323, column: 5, scope: !1505)
!1516 = !{i64 2148225705}
!1517 = !DILocation(line: 324, column: 12, scope: !1505)
!1518 = !DILocation(line: 324, column: 5, scope: !1505)
!1519 = distinct !DISubprogram(name: "vatomicptr_write_rlx", scope: !810, file: !810, line: 558, type: !1520, scopeLine: 559, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1520 = !DISubroutineType(types: !1521)
!1521 = !{null, !899, !22}
!1522 = !DILocalVariable(name: "a", arg: 1, scope: !1519, file: !810, line: 558, type: !899)
!1523 = !DILocation(line: 558, column: 36, scope: !1519)
!1524 = !DILocalVariable(name: "v", arg: 2, scope: !1519, file: !810, line: 558, type: !22)
!1525 = !DILocation(line: 558, column: 45, scope: !1519)
!1526 = !DILocation(line: 560, column: 5, scope: !1519)
!1527 = !{i64 2148227069}
!1528 = !DILocation(line: 561, column: 23, scope: !1519)
!1529 = !DILocation(line: 561, column: 26, scope: !1519)
!1530 = !DILocation(line: 561, column: 30, scope: !1519)
!1531 = !DILocation(line: 561, column: 5, scope: !1519)
!1532 = !DILocation(line: 562, column: 5, scope: !1519)
!1533 = !{i64 2148227109}
!1534 = !DILocation(line: 563, column: 1, scope: !1519)
!1535 = distinct !DISubprogram(name: "vatomicsz_write_rlx", scope: !810, file: !810, line: 519, type: !1536, scopeLine: 520, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1536 = !DISubroutineType(types: !1537)
!1537 = !{null, !1246, !14}
!1538 = !DILocalVariable(name: "a", arg: 1, scope: !1535, file: !810, line: 519, type: !1246)
!1539 = !DILocation(line: 519, column: 34, scope: !1535)
!1540 = !DILocalVariable(name: "v", arg: 2, scope: !1535, file: !810, line: 519, type: !14)
!1541 = !DILocation(line: 519, column: 45, scope: !1535)
!1542 = !DILocation(line: 521, column: 5, scope: !1535)
!1543 = !{i64 2148226835}
!1544 = !DILocation(line: 522, column: 23, scope: !1535)
!1545 = !DILocation(line: 522, column: 26, scope: !1535)
!1546 = !DILocation(line: 522, column: 30, scope: !1535)
!1547 = !DILocation(line: 522, column: 5, scope: !1535)
!1548 = !DILocation(line: 523, column: 5, scope: !1535)
!1549 = !{i64 2148226875}
!1550 = !DILocation(line: 524, column: 1, scope: !1535)
!1551 = distinct !DISubprogram(name: "rwlock_write_release", scope: !106, file: !106, line: 58, type: !784, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1552 = !DILocalVariable(name: "l", arg: 1, scope: !1551, file: !106, line: 58, type: !764)
!1553 = !DILocation(line: 58, column: 32, scope: !1551)
!1554 = !DILocation(line: 60, column: 25, scope: !1551)
!1555 = !DILocation(line: 60, column: 28, scope: !1551)
!1556 = !DILocation(line: 60, column: 5, scope: !1551)
!1557 = !DILocalVariable(name: "i", scope: !1558, file: !106, line: 61, type: !14)
!1558 = distinct !DILexicalBlock(scope: !1551, file: !106, line: 61, column: 5)
!1559 = !DILocation(line: 61, column: 18, scope: !1558)
!1560 = !DILocation(line: 61, column: 10, scope: !1558)
!1561 = !DILocation(line: 61, column: 25, scope: !1562)
!1562 = distinct !DILexicalBlock(scope: !1558, file: !106, line: 61, column: 5)
!1563 = !DILocation(line: 61, column: 27, scope: !1562)
!1564 = !DILocation(line: 61, column: 5, scope: !1558)
!1565 = !DILocation(line: 62, column: 31, scope: !1566)
!1566 = distinct !DILexicalBlock(scope: !1562, file: !106, line: 61, column: 54)
!1567 = !DILocation(line: 62, column: 34, scope: !1566)
!1568 = !DILocation(line: 62, column: 39, scope: !1566)
!1569 = !DILocation(line: 62, column: 9, scope: !1566)
!1570 = !DILocation(line: 63, column: 5, scope: !1566)
!1571 = !DILocation(line: 61, column: 50, scope: !1562)
!1572 = !DILocation(line: 61, column: 5, scope: !1562)
!1573 = distinct !{!1573, !1564, !1574, !212}
!1574 = !DILocation(line: 63, column: 5, scope: !1558)
!1575 = !DILocation(line: 64, column: 1, scope: !1551)
!1576 = distinct !DISubprogram(name: "vatomic8_write_rlx", scope: !810, file: !810, line: 363, type: !1577, scopeLine: 364, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1577 = !DISubroutineType(types: !1578)
!1578 = !{null, !1579, !23}
!1579 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !145, size: 64)
!1580 = !DILocalVariable(name: "a", arg: 1, scope: !1576, file: !810, line: 363, type: !1579)
!1581 = !DILocation(line: 363, column: 32, scope: !1576)
!1582 = !DILocalVariable(name: "v", arg: 2, scope: !1576, file: !810, line: 363, type: !23)
!1583 = !DILocation(line: 363, column: 44, scope: !1576)
!1584 = !DILocation(line: 365, column: 5, scope: !1576)
!1585 = !{i64 2148225899}
!1586 = !DILocation(line: 366, column: 23, scope: !1576)
!1587 = !DILocation(line: 366, column: 26, scope: !1576)
!1588 = !DILocation(line: 366, column: 30, scope: !1576)
!1589 = !DILocation(line: 366, column: 5, scope: !1576)
!1590 = !DILocation(line: 367, column: 5, scope: !1576)
!1591 = !{i64 2148225939}
!1592 = !DILocation(line: 368, column: 1, scope: !1576)
!1593 = distinct !DISubprogram(name: "vsimpleht_get", scope: !6, file: !6, line: 257, type: !1594, scopeLine: 258, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1594 = !DISubroutineType(types: !1595)
!1595 = !{!22, !587, !19}
!1596 = !DILocalVariable(name: "tbl", arg: 1, scope: !1593, file: !6, line: 257, type: !587)
!1597 = !DILocation(line: 257, column: 28, scope: !1593)
!1598 = !DILocalVariable(name: "key", arg: 2, scope: !1593, file: !6, line: 257, type: !19)
!1599 = !DILocation(line: 257, column: 44, scope: !1593)
!1600 = !DILocalVariable(name: "index", scope: !1593, file: !6, line: 259, type: !14)
!1601 = !DILocation(line: 259, column: 13, scope: !1593)
!1602 = !DILocalVariable(name: "probed_key", scope: !1593, file: !6, line: 260, type: !19)
!1603 = !DILocation(line: 260, column: 16, scope: !1593)
!1604 = !DILocation(line: 261, column: 38, scope: !1593)
!1605 = !DILocation(line: 261, column: 5, scope: !1593)
!1606 = !DILocation(line: 262, column: 18, scope: !1607)
!1607 = distinct !DILexicalBlock(scope: !1593, file: !6, line: 262, column: 5)
!1608 = !DILocation(line: 262, column: 23, scope: !1607)
!1609 = !DILocation(line: 262, column: 32, scope: !1607)
!1610 = !DILocation(line: 262, column: 16, scope: !1607)
!1611 = !DILocation(line: 262, column: 10, scope: !1607)
!1612 = !DILocation(line: 263, column: 18, scope: !1613)
!1613 = distinct !DILexicalBlock(scope: !1614, file: !6, line: 262, column: 48)
!1614 = distinct !DILexicalBlock(scope: !1607, file: !6, line: 262, column: 5)
!1615 = !DILocation(line: 263, column: 23, scope: !1613)
!1616 = !DILocation(line: 263, column: 32, scope: !1613)
!1617 = !DILocation(line: 263, column: 15, scope: !1613)
!1618 = !DILocation(line: 264, column: 9, scope: !1619)
!1619 = distinct !DILexicalBlock(scope: !1620, file: !6, line: 264, column: 9)
!1620 = distinct !DILexicalBlock(scope: !1613, file: !6, line: 264, column: 9)
!1621 = !DILocation(line: 264, column: 9, scope: !1620)
!1622 = !DILocation(line: 265, column: 51, scope: !1613)
!1623 = !DILocation(line: 265, column: 56, scope: !1613)
!1624 = !DILocation(line: 265, column: 64, scope: !1613)
!1625 = !DILocation(line: 265, column: 71, scope: !1613)
!1626 = !DILocation(line: 265, column: 34, scope: !1613)
!1627 = !DILocation(line: 265, column: 22, scope: !1613)
!1628 = !DILocation(line: 265, column: 20, scope: !1613)
!1629 = !DILocation(line: 266, column: 13, scope: !1630)
!1630 = distinct !DILexicalBlock(scope: !1613, file: !6, line: 266, column: 13)
!1631 = !DILocation(line: 266, column: 24, scope: !1630)
!1632 = !DILocation(line: 266, column: 13, scope: !1613)
!1633 = !DILocation(line: 267, column: 13, scope: !1634)
!1634 = distinct !DILexicalBlock(scope: !1630, file: !6, line: 266, column: 30)
!1635 = !DILocation(line: 268, column: 20, scope: !1636)
!1636 = distinct !DILexicalBlock(scope: !1630, file: !6, line: 268, column: 20)
!1637 = !DILocation(line: 268, column: 25, scope: !1636)
!1638 = !DILocation(line: 268, column: 33, scope: !1636)
!1639 = !DILocation(line: 268, column: 38, scope: !1636)
!1640 = !DILocation(line: 268, column: 50, scope: !1636)
!1641 = !DILocation(line: 268, column: 20, scope: !1630)
!1642 = !DILocation(line: 269, column: 41, scope: !1643)
!1643 = distinct !DILexicalBlock(scope: !1636, file: !6, line: 268, column: 56)
!1644 = !DILocation(line: 269, column: 46, scope: !1643)
!1645 = !DILocation(line: 269, column: 54, scope: !1643)
!1646 = !DILocation(line: 269, column: 61, scope: !1643)
!1647 = !DILocation(line: 269, column: 20, scope: !1643)
!1648 = !DILocation(line: 269, column: 13, scope: !1643)
!1649 = !DILocation(line: 271, column: 5, scope: !1613)
!1650 = !DILocation(line: 262, column: 44, scope: !1614)
!1651 = !DILocation(line: 262, column: 5, scope: !1614)
!1652 = distinct !{!1652, !1653, !1654}
!1653 = !DILocation(line: 262, column: 5, scope: !1607)
!1654 = !DILocation(line: 271, column: 5, scope: !1607)
!1655 = !DILocation(line: 272, column: 1, scope: !1593)
!1656 = distinct !DISubprogram(name: "create_threads", scope: !34, file: !34, line: 91, type: !1657, scopeLine: 93, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1657 = !DISubroutineType(types: !1658)
!1658 = !{null, !32, !14, !45, !42}
!1659 = !DILocalVariable(name: "threads", arg: 1, scope: !1656, file: !34, line: 91, type: !32)
!1660 = !DILocation(line: 91, column: 28, scope: !1656)
!1661 = !DILocalVariable(name: "num_threads", arg: 2, scope: !1656, file: !34, line: 91, type: !14)
!1662 = !DILocation(line: 91, column: 45, scope: !1656)
!1663 = !DILocalVariable(name: "fun", arg: 3, scope: !1656, file: !34, line: 91, type: !45)
!1664 = !DILocation(line: 91, column: 71, scope: !1656)
!1665 = !DILocalVariable(name: "bind", arg: 4, scope: !1656, file: !34, line: 92, type: !42)
!1666 = !DILocation(line: 92, column: 24, scope: !1656)
!1667 = !DILocalVariable(name: "i", scope: !1656, file: !34, line: 94, type: !14)
!1668 = !DILocation(line: 94, column: 13, scope: !1656)
!1669 = !DILocation(line: 95, column: 12, scope: !1670)
!1670 = distinct !DILexicalBlock(scope: !1656, file: !34, line: 95, column: 5)
!1671 = !DILocation(line: 95, column: 10, scope: !1670)
!1672 = !DILocation(line: 95, column: 17, scope: !1673)
!1673 = distinct !DILexicalBlock(scope: !1670, file: !34, line: 95, column: 5)
!1674 = !DILocation(line: 95, column: 21, scope: !1673)
!1675 = !DILocation(line: 95, column: 19, scope: !1673)
!1676 = !DILocation(line: 95, column: 5, scope: !1670)
!1677 = !DILocation(line: 96, column: 40, scope: !1678)
!1678 = distinct !DILexicalBlock(scope: !1673, file: !34, line: 95, column: 39)
!1679 = !DILocation(line: 96, column: 9, scope: !1678)
!1680 = !DILocation(line: 96, column: 17, scope: !1678)
!1681 = !DILocation(line: 96, column: 20, scope: !1678)
!1682 = !DILocation(line: 96, column: 38, scope: !1678)
!1683 = !DILocation(line: 97, column: 40, scope: !1678)
!1684 = !DILocation(line: 97, column: 9, scope: !1678)
!1685 = !DILocation(line: 97, column: 17, scope: !1678)
!1686 = !DILocation(line: 97, column: 20, scope: !1678)
!1687 = !DILocation(line: 97, column: 38, scope: !1678)
!1688 = !DILocation(line: 98, column: 40, scope: !1678)
!1689 = !DILocation(line: 98, column: 9, scope: !1678)
!1690 = !DILocation(line: 98, column: 17, scope: !1678)
!1691 = !DILocation(line: 98, column: 20, scope: !1678)
!1692 = !DILocation(line: 98, column: 38, scope: !1678)
!1693 = !DILocation(line: 99, column: 25, scope: !1678)
!1694 = !DILocation(line: 99, column: 33, scope: !1678)
!1695 = !DILocation(line: 99, column: 36, scope: !1678)
!1696 = !DILocation(line: 99, column: 55, scope: !1678)
!1697 = !DILocation(line: 99, column: 63, scope: !1678)
!1698 = !DILocation(line: 99, column: 54, scope: !1678)
!1699 = !DILocation(line: 99, column: 9, scope: !1678)
!1700 = !DILocation(line: 100, column: 5, scope: !1678)
!1701 = !DILocation(line: 95, column: 35, scope: !1673)
!1702 = !DILocation(line: 95, column: 5, scope: !1673)
!1703 = distinct !{!1703, !1676, !1704, !212}
!1704 = !DILocation(line: 100, column: 5, scope: !1670)
!1705 = !DILocation(line: 102, column: 1, scope: !1656)
!1706 = distinct !DISubprogram(name: "await_threads", scope: !34, file: !34, line: 105, type: !1707, scopeLine: 106, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1707 = !DISubroutineType(types: !1708)
!1708 = !{null, !32, !14}
!1709 = !DILocalVariable(name: "threads", arg: 1, scope: !1706, file: !34, line: 105, type: !32)
!1710 = !DILocation(line: 105, column: 27, scope: !1706)
!1711 = !DILocalVariable(name: "num_threads", arg: 2, scope: !1706, file: !34, line: 105, type: !14)
!1712 = !DILocation(line: 105, column: 44, scope: !1706)
!1713 = !DILocalVariable(name: "i", scope: !1706, file: !34, line: 107, type: !14)
!1714 = !DILocation(line: 107, column: 13, scope: !1706)
!1715 = !DILocation(line: 108, column: 12, scope: !1716)
!1716 = distinct !DILexicalBlock(scope: !1706, file: !34, line: 108, column: 5)
!1717 = !DILocation(line: 108, column: 10, scope: !1716)
!1718 = !DILocation(line: 108, column: 17, scope: !1719)
!1719 = distinct !DILexicalBlock(scope: !1716, file: !34, line: 108, column: 5)
!1720 = !DILocation(line: 108, column: 21, scope: !1719)
!1721 = !DILocation(line: 108, column: 19, scope: !1719)
!1722 = !DILocation(line: 108, column: 5, scope: !1716)
!1723 = !DILocation(line: 109, column: 22, scope: !1724)
!1724 = distinct !DILexicalBlock(scope: !1719, file: !34, line: 108, column: 39)
!1725 = !DILocation(line: 109, column: 30, scope: !1724)
!1726 = !DILocation(line: 109, column: 33, scope: !1724)
!1727 = !DILocation(line: 109, column: 9, scope: !1724)
!1728 = !DILocation(line: 110, column: 5, scope: !1724)
!1729 = !DILocation(line: 108, column: 35, scope: !1719)
!1730 = !DILocation(line: 108, column: 5, scope: !1719)
!1731 = distinct !{!1731, !1722, !1732, !212}
!1732 = !DILocation(line: 110, column: 5, scope: !1716)
!1733 = !DILocation(line: 111, column: 1, scope: !1706)
!1734 = distinct !DISubprogram(name: "common_run", scope: !34, file: !34, line: 51, type: !47, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1735 = !DILocalVariable(name: "args", arg: 1, scope: !1734, file: !34, line: 51, type: !22)
!1736 = !DILocation(line: 51, column: 18, scope: !1734)
!1737 = !DILocalVariable(name: "run_info", scope: !1734, file: !34, line: 53, type: !32)
!1738 = !DILocation(line: 53, column: 17, scope: !1734)
!1739 = !DILocation(line: 53, column: 42, scope: !1734)
!1740 = !DILocation(line: 53, column: 28, scope: !1734)
!1741 = !DILocation(line: 55, column: 9, scope: !1742)
!1742 = distinct !DILexicalBlock(scope: !1734, file: !34, line: 55, column: 9)
!1743 = !DILocation(line: 55, column: 19, scope: !1742)
!1744 = !DILocation(line: 55, column: 9, scope: !1734)
!1745 = !DILocation(line: 56, column: 26, scope: !1742)
!1746 = !DILocation(line: 56, column: 36, scope: !1742)
!1747 = !DILocation(line: 56, column: 9, scope: !1742)
!1748 = !DILocation(line: 60, column: 12, scope: !1734)
!1749 = !DILocation(line: 60, column: 22, scope: !1734)
!1750 = !DILocation(line: 60, column: 38, scope: !1734)
!1751 = !DILocation(line: 60, column: 48, scope: !1734)
!1752 = !DILocation(line: 60, column: 30, scope: !1734)
!1753 = !DILocation(line: 60, column: 5, scope: !1734)
!1754 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !34, file: !34, line: 69, type: !263, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1755 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !1754, file: !34, line: 69, type: !14)
!1756 = !DILocation(line: 69, column: 26, scope: !1754)
!1757 = !DILocation(line: 86, column: 5, scope: !1754)
!1758 = !DILocation(line: 86, column: 5, scope: !1759)
!1759 = distinct !DILexicalBlock(scope: !1754, file: !34, line: 86, column: 5)
!1760 = !DILocation(line: 86, column: 5, scope: !1761)
!1761 = distinct !DILexicalBlock(scope: !1759, file: !34, line: 86, column: 5)
!1762 = !DILocation(line: 86, column: 5, scope: !1763)
!1763 = distinct !DILexicalBlock(scope: !1761, file: !34, line: 86, column: 5)
!1764 = !DILocation(line: 88, column: 1, scope: !1754)
!1765 = distinct !DISubprogram(name: "vsimpleht_thread_register", scope: !6, file: !6, line: 200, type: !630, scopeLine: 201, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1766 = !DILocalVariable(name: "tbl", arg: 1, scope: !1765, file: !6, line: 200, type: !587)
!1767 = !DILocation(line: 200, column: 40, scope: !1765)
!1768 = !DILocation(line: 205, column: 26, scope: !1765)
!1769 = !DILocation(line: 205, column: 31, scope: !1765)
!1770 = !DILocation(line: 205, column: 5, scope: !1765)
!1771 = !DILocation(line: 207, column: 1, scope: !1765)
!1772 = distinct !DISubprogram(name: "vsimpleht_thread_deregister", scope: !6, file: !6, line: 217, type: !630, scopeLine: 218, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1773 = !DILocalVariable(name: "tbl", arg: 1, scope: !1772, file: !6, line: 217, type: !587)
!1774 = !DILocation(line: 217, column: 42, scope: !1772)
!1775 = !DILocation(line: 222, column: 26, scope: !1772)
!1776 = !DILocation(line: 222, column: 31, scope: !1772)
!1777 = !DILocation(line: 222, column: 5, scope: !1772)
!1778 = !DILocation(line: 224, column: 1, scope: !1772)
!1779 = distinct !DISubprogram(name: "vsimpleht_buff_size", scope: !6, file: !6, line: 126, type: !1780, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1780 = !DISubroutineType(types: !1781)
!1781 = !{!14, !14}
!1782 = !DILocalVariable(name: "capacity", arg: 1, scope: !1779, file: !6, line: 126, type: !14)
!1783 = !DILocation(line: 126, column: 29, scope: !1779)
!1784 = !DILocation(line: 128, column: 5, scope: !1785)
!1785 = distinct !DILexicalBlock(scope: !1786, file: !6, line: 128, column: 5)
!1786 = distinct !DILexicalBlock(scope: !1779, file: !6, line: 128, column: 5)
!1787 = !DILocation(line: 128, column: 5, scope: !1786)
!1788 = !DILocation(line: 129, column: 5, scope: !1789)
!1789 = distinct !DILexicalBlock(scope: !1790, file: !6, line: 129, column: 5)
!1790 = distinct !DILexicalBlock(scope: !1779, file: !6, line: 129, column: 5)
!1791 = !DILocation(line: 129, column: 5, scope: !1790)
!1792 = !DILocation(line: 130, column: 40, scope: !1779)
!1793 = !DILocation(line: 130, column: 38, scope: !1779)
!1794 = !DILocation(line: 130, column: 5, scope: !1779)
!1795 = distinct !DISubprogram(name: "vsimpleht_init", scope: !6, file: !6, line: 146, type: !1796, scopeLine: 149, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1796 = !DISubroutineType(types: !1797)
!1797 = !{null, !587, !22, !14, !79, !89, !94}
!1798 = !DILocalVariable(name: "tbl", arg: 1, scope: !1795, file: !6, line: 146, type: !587)
!1799 = !DILocation(line: 146, column: 29, scope: !1795)
!1800 = !DILocalVariable(name: "buff", arg: 2, scope: !1795, file: !6, line: 146, type: !22)
!1801 = !DILocation(line: 146, column: 40, scope: !1795)
!1802 = !DILocalVariable(name: "capacity", arg: 3, scope: !1795, file: !6, line: 146, type: !14)
!1803 = !DILocation(line: 146, column: 54, scope: !1795)
!1804 = !DILocalVariable(name: "cmp_fun", arg: 4, scope: !1795, file: !6, line: 147, type: !79)
!1805 = !DILocation(line: 147, column: 36, scope: !1795)
!1806 = !DILocalVariable(name: "hash_fun", arg: 5, scope: !1795, file: !6, line: 147, type: !89)
!1807 = !DILocation(line: 147, column: 66, scope: !1795)
!1808 = !DILocalVariable(name: "destroy_cb", arg: 6, scope: !1795, file: !6, line: 148, type: !94)
!1809 = !DILocation(line: 148, column: 42, scope: !1795)
!1810 = !DILocation(line: 150, column: 5, scope: !1811)
!1811 = distinct !DILexicalBlock(scope: !1812, file: !6, line: 150, column: 5)
!1812 = distinct !DILexicalBlock(scope: !1795, file: !6, line: 150, column: 5)
!1813 = !DILocation(line: 150, column: 5, scope: !1812)
!1814 = !DILocation(line: 151, column: 5, scope: !1815)
!1815 = distinct !DILexicalBlock(scope: !1816, file: !6, line: 151, column: 5)
!1816 = distinct !DILexicalBlock(scope: !1795, file: !6, line: 151, column: 5)
!1817 = !DILocation(line: 151, column: 5, scope: !1816)
!1818 = !DILocation(line: 152, column: 5, scope: !1819)
!1819 = distinct !DILexicalBlock(scope: !1820, file: !6, line: 152, column: 5)
!1820 = distinct !DILexicalBlock(scope: !1795, file: !6, line: 152, column: 5)
!1821 = !DILocation(line: 152, column: 5, scope: !1820)
!1822 = !DILocation(line: 153, column: 5, scope: !1823)
!1823 = distinct !DILexicalBlock(scope: !1824, file: !6, line: 153, column: 5)
!1824 = distinct !DILexicalBlock(scope: !1795, file: !6, line: 153, column: 5)
!1825 = !DILocation(line: 153, column: 5, scope: !1824)
!1826 = !DILocation(line: 155, column: 23, scope: !1795)
!1827 = !DILocation(line: 155, column: 5, scope: !1795)
!1828 = !DILocation(line: 155, column: 10, scope: !1795)
!1829 = !DILocation(line: 155, column: 21, scope: !1795)
!1830 = !DILocation(line: 156, column: 23, scope: !1795)
!1831 = !DILocation(line: 156, column: 5, scope: !1795)
!1832 = !DILocation(line: 156, column: 10, scope: !1795)
!1833 = !DILocation(line: 156, column: 21, scope: !1795)
!1834 = !DILocation(line: 157, column: 23, scope: !1795)
!1835 = !DILocation(line: 157, column: 5, scope: !1795)
!1836 = !DILocation(line: 157, column: 10, scope: !1795)
!1837 = !DILocation(line: 157, column: 21, scope: !1795)
!1838 = !DILocation(line: 158, column: 23, scope: !1795)
!1839 = !DILocation(line: 158, column: 5, scope: !1795)
!1840 = !DILocation(line: 158, column: 10, scope: !1795)
!1841 = !DILocation(line: 158, column: 21, scope: !1795)
!1842 = !DILocation(line: 159, column: 23, scope: !1795)
!1843 = !DILocation(line: 159, column: 5, scope: !1795)
!1844 = !DILocation(line: 159, column: 10, scope: !1795)
!1845 = !DILocation(line: 159, column: 21, scope: !1795)
!1846 = !DILocalVariable(name: "i", scope: !1847, file: !6, line: 161, type: !14)
!1847 = distinct !DILexicalBlock(scope: !1795, file: !6, line: 161, column: 5)
!1848 = !DILocation(line: 161, column: 18, scope: !1847)
!1849 = !DILocation(line: 161, column: 10, scope: !1847)
!1850 = !DILocation(line: 161, column: 25, scope: !1851)
!1851 = distinct !DILexicalBlock(scope: !1847, file: !6, line: 161, column: 5)
!1852 = !DILocation(line: 161, column: 29, scope: !1851)
!1853 = !DILocation(line: 161, column: 34, scope: !1851)
!1854 = !DILocation(line: 161, column: 27, scope: !1851)
!1855 = !DILocation(line: 161, column: 5, scope: !1847)
!1856 = !DILocation(line: 162, column: 26, scope: !1857)
!1857 = distinct !DILexicalBlock(scope: !1851, file: !6, line: 161, column: 49)
!1858 = !DILocation(line: 162, column: 31, scope: !1857)
!1859 = !DILocation(line: 162, column: 39, scope: !1857)
!1860 = !DILocation(line: 162, column: 42, scope: !1857)
!1861 = !DILocation(line: 162, column: 9, scope: !1857)
!1862 = !DILocation(line: 163, column: 26, scope: !1857)
!1863 = !DILocation(line: 163, column: 31, scope: !1857)
!1864 = !DILocation(line: 163, column: 39, scope: !1857)
!1865 = !DILocation(line: 163, column: 42, scope: !1857)
!1866 = !DILocation(line: 163, column: 9, scope: !1857)
!1867 = !DILocation(line: 164, column: 5, scope: !1857)
!1868 = !DILocation(line: 161, column: 45, scope: !1851)
!1869 = !DILocation(line: 161, column: 5, scope: !1851)
!1870 = distinct !{!1870, !1855, !1871, !212}
!1871 = !DILocation(line: 164, column: 5, scope: !1847)
!1872 = !DILocation(line: 166, column: 32, scope: !1795)
!1873 = !DILocation(line: 166, column: 41, scope: !1795)
!1874 = !DILocation(line: 166, column: 5, scope: !1795)
!1875 = !DILocation(line: 166, column: 10, scope: !1795)
!1876 = !DILocation(line: 166, column: 29, scope: !1795)
!1877 = !DILocation(line: 167, column: 26, scope: !1795)
!1878 = !DILocation(line: 167, column: 31, scope: !1795)
!1879 = !DILocation(line: 167, column: 5, scope: !1795)
!1880 = !DILocation(line: 168, column: 18, scope: !1795)
!1881 = !DILocation(line: 168, column: 23, scope: !1795)
!1882 = !DILocation(line: 168, column: 5, scope: !1795)
!1883 = !DILocation(line: 170, column: 1, scope: !1795)
!1884 = distinct !DISubprogram(name: "cb_cmp", scope: !61, file: !61, line: 40, type: !81, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1885 = !DILocalVariable(name: "key_a", arg: 1, scope: !1884, file: !61, line: 40, type: !19)
!1886 = !DILocation(line: 40, column: 19, scope: !1884)
!1887 = !DILocalVariable(name: "key_b", arg: 2, scope: !1884, file: !61, line: 40, type: !19)
!1888 = !DILocation(line: 40, column: 37, scope: !1884)
!1889 = !DILocation(line: 42, column: 9, scope: !1890)
!1890 = distinct !DILexicalBlock(scope: !1884, file: !61, line: 42, column: 9)
!1891 = !DILocation(line: 42, column: 18, scope: !1890)
!1892 = !DILocation(line: 42, column: 15, scope: !1890)
!1893 = !DILocation(line: 42, column: 9, scope: !1884)
!1894 = !DILocation(line: 43, column: 9, scope: !1895)
!1895 = distinct !DILexicalBlock(scope: !1890, file: !61, line: 42, column: 25)
!1896 = !DILocation(line: 44, column: 16, scope: !1897)
!1897 = distinct !DILexicalBlock(scope: !1890, file: !61, line: 44, column: 16)
!1898 = !DILocation(line: 44, column: 24, scope: !1897)
!1899 = !DILocation(line: 44, column: 22, scope: !1897)
!1900 = !DILocation(line: 44, column: 16, scope: !1890)
!1901 = !DILocation(line: 45, column: 9, scope: !1902)
!1902 = distinct !DILexicalBlock(scope: !1897, file: !61, line: 44, column: 31)
!1903 = !DILocation(line: 47, column: 9, scope: !1904)
!1904 = distinct !DILexicalBlock(scope: !1897, file: !61, line: 46, column: 12)
!1905 = !DILocation(line: 49, column: 1, scope: !1884)
!1906 = distinct !DISubprogram(name: "cb_hash", scope: !61, file: !61, line: 53, type: !91, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1907 = !DILocalVariable(name: "key", arg: 1, scope: !1906, file: !61, line: 53, type: !19)
!1908 = !DILocation(line: 53, column: 20, scope: !1906)
!1909 = !DILocation(line: 55, column: 23, scope: !1906)
!1910 = !DILocation(line: 55, column: 5, scope: !1906)
!1911 = distinct !DISubprogram(name: "cb_destroy", scope: !61, file: !61, line: 71, type: !96, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1912 = !DILocalVariable(name: "data", arg: 1, scope: !1911, file: !61, line: 71, type: !22)
!1913 = !DILocation(line: 71, column: 18, scope: !1911)
!1914 = !DILocation(line: 73, column: 10, scope: !1911)
!1915 = !DILocation(line: 73, column: 5, scope: !1911)
!1916 = !DILocation(line: 74, column: 1, scope: !1911)
!1917 = distinct !DISubprogram(name: "trace_init", scope: !158, file: !158, line: 34, type: !1918, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1918 = !DISubroutineType(types: !1919)
!1919 = !{null, !612, !14}
!1920 = !DILocalVariable(name: "trace", arg: 1, scope: !1917, file: !158, line: 34, type: !612)
!1921 = !DILocation(line: 34, column: 21, scope: !1917)
!1922 = !DILocalVariable(name: "capacity", arg: 2, scope: !1917, file: !158, line: 34, type: !14)
!1923 = !DILocation(line: 34, column: 36, scope: !1917)
!1924 = !DILocation(line: 36, column: 5, scope: !1925)
!1925 = distinct !DILexicalBlock(scope: !1926, file: !158, line: 36, column: 5)
!1926 = distinct !DILexicalBlock(scope: !1917, file: !158, line: 36, column: 5)
!1927 = !DILocation(line: 36, column: 5, scope: !1926)
!1928 = !DILocation(line: 37, column: 27, scope: !1917)
!1929 = !DILocation(line: 37, column: 36, scope: !1917)
!1930 = !DILocation(line: 37, column: 20, scope: !1917)
!1931 = !DILocation(line: 37, column: 5, scope: !1917)
!1932 = !DILocation(line: 37, column: 12, scope: !1917)
!1933 = !DILocation(line: 37, column: 18, scope: !1917)
!1934 = !DILocation(line: 38, column: 9, scope: !1935)
!1935 = distinct !DILexicalBlock(scope: !1917, file: !158, line: 38, column: 9)
!1936 = !DILocation(line: 38, column: 16, scope: !1935)
!1937 = !DILocation(line: 38, column: 9, scope: !1917)
!1938 = !DILocation(line: 39, column: 9, scope: !1939)
!1939 = distinct !DILexicalBlock(scope: !1935, file: !158, line: 38, column: 23)
!1940 = !DILocation(line: 39, column: 16, scope: !1939)
!1941 = !DILocation(line: 39, column: 28, scope: !1939)
!1942 = !DILocation(line: 40, column: 30, scope: !1939)
!1943 = !DILocation(line: 40, column: 9, scope: !1939)
!1944 = !DILocation(line: 40, column: 16, scope: !1939)
!1945 = !DILocation(line: 40, column: 28, scope: !1939)
!1946 = !DILocation(line: 41, column: 9, scope: !1939)
!1947 = !DILocation(line: 41, column: 16, scope: !1939)
!1948 = !DILocation(line: 41, column: 28, scope: !1939)
!1949 = !DILocation(line: 42, column: 5, scope: !1939)
!1950 = !DILocation(line: 43, column: 9, scope: !1951)
!1951 = distinct !DILexicalBlock(scope: !1935, file: !158, line: 42, column: 12)
!1952 = !DILocation(line: 43, column: 16, scope: !1951)
!1953 = !DILocation(line: 43, column: 28, scope: !1951)
!1954 = !DILocation(line: 44, column: 9, scope: !1951)
!1955 = !DILocation(line: 44, column: 16, scope: !1951)
!1956 = !DILocation(line: 44, column: 28, scope: !1951)
!1957 = !DILocation(line: 45, column: 9, scope: !1951)
!1958 = !DILocation(line: 45, column: 16, scope: !1951)
!1959 = !DILocation(line: 45, column: 28, scope: !1951)
!1960 = !DILocation(line: 46, column: 9, scope: !1961)
!1961 = distinct !DILexicalBlock(scope: !1962, file: !158, line: 46, column: 9)
!1962 = distinct !DILexicalBlock(scope: !1951, file: !158, line: 46, column: 9)
!1963 = !DILocation(line: 48, column: 1, scope: !1917)
!1964 = distinct !DISubprogram(name: "vatomicptr_init", scope: !850, file: !850, line: 4223, type: !1520, scopeLine: 4224, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1965 = !DILocalVariable(name: "a", arg: 1, scope: !1964, file: !850, line: 4223, type: !899)
!1966 = !DILocation(line: 4223, column: 31, scope: !1964)
!1967 = !DILocalVariable(name: "v", arg: 2, scope: !1964, file: !850, line: 4223, type: !22)
!1968 = !DILocation(line: 4223, column: 40, scope: !1964)
!1969 = !DILocation(line: 4225, column: 22, scope: !1964)
!1970 = !DILocation(line: 4225, column: 25, scope: !1964)
!1971 = !DILocation(line: 4225, column: 5, scope: !1964)
!1972 = !DILocation(line: 4226, column: 1, scope: !1964)
!1973 = distinct !DISubprogram(name: "rwlock_init", scope: !106, file: !106, line: 33, type: !784, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1974 = !DILocalVariable(name: "l", arg: 1, scope: !1973, file: !106, line: 33, type: !764)
!1975 = !DILocation(line: 33, column: 23, scope: !1973)
!1976 = !DILocalVariable(name: "i", scope: !1977, file: !106, line: 35, type: !14)
!1977 = distinct !DILexicalBlock(scope: !1973, file: !106, line: 35, column: 5)
!1978 = !DILocation(line: 35, column: 18, scope: !1977)
!1979 = !DILocation(line: 35, column: 10, scope: !1977)
!1980 = !DILocation(line: 35, column: 25, scope: !1981)
!1981 = distinct !DILexicalBlock(scope: !1977, file: !106, line: 35, column: 5)
!1982 = !DILocation(line: 35, column: 27, scope: !1981)
!1983 = !DILocation(line: 35, column: 5, scope: !1977)
!1984 = !DILocation(line: 36, column: 29, scope: !1985)
!1985 = distinct !DILexicalBlock(scope: !1981, file: !106, line: 35, column: 54)
!1986 = !DILocation(line: 36, column: 32, scope: !1985)
!1987 = !DILocation(line: 36, column: 37, scope: !1985)
!1988 = !DILocation(line: 36, column: 9, scope: !1985)
!1989 = !DILocation(line: 37, column: 5, scope: !1985)
!1990 = !DILocation(line: 35, column: 50, scope: !1981)
!1991 = !DILocation(line: 35, column: 5, scope: !1981)
!1992 = distinct !{!1992, !1983, !1993, !212}
!1993 = !DILocation(line: 37, column: 5, scope: !1977)
!1994 = !DILocation(line: 38, column: 1, scope: !1973)
!1995 = distinct !DISubprogram(name: "vatomicptr_write", scope: !810, file: !810, line: 532, type: !1520, scopeLine: 533, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!1996 = !DILocalVariable(name: "a", arg: 1, scope: !1995, file: !810, line: 532, type: !899)
!1997 = !DILocation(line: 532, column: 32, scope: !1995)
!1998 = !DILocalVariable(name: "v", arg: 2, scope: !1995, file: !810, line: 532, type: !22)
!1999 = !DILocation(line: 532, column: 41, scope: !1995)
!2000 = !DILocation(line: 534, column: 5, scope: !1995)
!2001 = !{i64 2148226913}
!2002 = !DILocation(line: 535, column: 23, scope: !1995)
!2003 = !DILocation(line: 535, column: 26, scope: !1995)
!2004 = !DILocation(line: 535, column: 30, scope: !1995)
!2005 = !DILocation(line: 535, column: 5, scope: !1995)
!2006 = !DILocation(line: 536, column: 5, scope: !1995)
!2007 = !{i64 2148226953}
!2008 = !DILocation(line: 537, column: 1, scope: !1995)
!2009 = distinct !DISubprogram(name: "_imap_verify", scope: !61, file: !61, line: 77, type: !186, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!2010 = !DILocalVariable(name: "key", scope: !2009, file: !61, line: 79, type: !19)
!2011 = !DILocation(line: 79, column: 16, scope: !2009)
!2012 = !DILocalVariable(name: "data", scope: !2009, file: !61, line: 80, type: !224)
!2013 = !DILocation(line: 80, column: 13, scope: !2009)
!2014 = !DILocalVariable(name: "iter", scope: !2009, file: !61, line: 81, type: !2015)
!2015 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsimpleht_iter_t", file: !6, line: 99, baseType: !2016)
!2016 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vsimpleht_iter_s", file: !6, line: 96, size: 128, elements: !2017)
!2017 = !{!2018, !2019}
!2018 = !DIDerivedType(tag: DW_TAG_member, name: "tbl", scope: !2016, file: !6, line: 97, baseType: !587, size: 64)
!2019 = !DIDerivedType(tag: DW_TAG_member, name: "idx", scope: !2016, file: !6, line: 98, baseType: !14, size: 64, offset: 64)
!2020 = !DILocation(line: 81, column: 22, scope: !2009)
!2021 = !DILocalVariable(name: "add_trc", scope: !2009, file: !61, line: 83, type: !157)
!2022 = !DILocation(line: 83, column: 13, scope: !2009)
!2023 = !DILocalVariable(name: "rem_trc", scope: !2009, file: !61, line: 84, type: !157)
!2024 = !DILocation(line: 84, column: 13, scope: !2009)
!2025 = !DILocalVariable(name: "final_state_trc", scope: !2009, file: !61, line: 85, type: !157)
!2026 = !DILocation(line: 85, column: 13, scope: !2009)
!2027 = !DILocation(line: 87, column: 5, scope: !2009)
!2028 = !DILocation(line: 88, column: 5, scope: !2009)
!2029 = !DILocalVariable(name: "i", scope: !2030, file: !61, line: 91, type: !14)
!2030 = distinct !DILexicalBlock(scope: !2009, file: !61, line: 91, column: 5)
!2031 = !DILocation(line: 91, column: 18, scope: !2030)
!2032 = !DILocation(line: 91, column: 10, scope: !2030)
!2033 = !DILocation(line: 91, column: 25, scope: !2034)
!2034 = distinct !DILexicalBlock(scope: !2030, file: !61, line: 91, column: 5)
!2035 = !DILocation(line: 91, column: 27, scope: !2034)
!2036 = !DILocation(line: 91, column: 5, scope: !2030)
!2037 = !DILocation(line: 92, column: 43, scope: !2038)
!2038 = distinct !DILexicalBlock(scope: !2034, file: !61, line: 91, column: 43)
!2039 = !DILocation(line: 92, column: 37, scope: !2038)
!2040 = !DILocation(line: 92, column: 9, scope: !2038)
!2041 = !DILocation(line: 93, column: 43, scope: !2038)
!2042 = !DILocation(line: 93, column: 37, scope: !2038)
!2043 = !DILocation(line: 93, column: 9, scope: !2038)
!2044 = !DILocation(line: 94, column: 5, scope: !2038)
!2045 = !DILocation(line: 91, column: 39, scope: !2034)
!2046 = !DILocation(line: 91, column: 5, scope: !2034)
!2047 = distinct !{!2047, !2036, !2048, !212}
!2048 = !DILocation(line: 94, column: 5, scope: !2030)
!2049 = !DILocation(line: 97, column: 5, scope: !2009)
!2050 = !DILocation(line: 98, column: 5, scope: !2009)
!2051 = !DILocation(line: 99, column: 5, scope: !2009)
!2052 = !DILocation(line: 99, column: 45, scope: !2009)
!2053 = !DILocation(line: 99, column: 12, scope: !2009)
!2054 = !DILocation(line: 100, column: 37, scope: !2055)
!2055 = distinct !DILexicalBlock(scope: !2009, file: !61, line: 99, column: 62)
!2056 = !DILocation(line: 100, column: 9, scope: !2055)
!2057 = distinct !{!2057, !2051, !2058, !212}
!2058 = !DILocation(line: 101, column: 5, scope: !2009)
!2059 = !DILocation(line: 103, column: 5, scope: !2009)
!2060 = !DILocalVariable(name: "eq", scope: !2009, file: !61, line: 104, type: !42)
!2061 = !DILocation(line: 104, column: 13, scope: !2009)
!2062 = !DILocation(line: 104, column: 18, scope: !2009)
!2063 = !DILocation(line: 106, column: 5, scope: !2009)
!2064 = !DILocation(line: 107, column: 5, scope: !2009)
!2065 = !DILocation(line: 108, column: 5, scope: !2009)
!2066 = !DILocation(line: 109, column: 5, scope: !2067)
!2067 = distinct !DILexicalBlock(scope: !2068, file: !61, line: 109, column: 5)
!2068 = distinct !DILexicalBlock(scope: !2009, file: !61, line: 109, column: 5)
!2069 = !DILocation(line: 109, column: 5, scope: !2068)
!2070 = !DILocation(line: 110, column: 1, scope: !2009)
!2071 = distinct !DISubprogram(name: "trace_destroy", scope: !158, file: !158, line: 98, type: !1055, scopeLine: 99, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!2072 = !DILocalVariable(name: "trace", arg: 1, scope: !2071, file: !158, line: 98, type: !612)
!2073 = !DILocation(line: 98, column: 24, scope: !2071)
!2074 = !DILocation(line: 100, column: 5, scope: !2075)
!2075 = distinct !DILexicalBlock(scope: !2076, file: !158, line: 100, column: 5)
!2076 = distinct !DILexicalBlock(scope: !2071, file: !158, line: 100, column: 5)
!2077 = !DILocation(line: 100, column: 5, scope: !2076)
!2078 = !DILocation(line: 101, column: 5, scope: !2079)
!2079 = distinct !DILexicalBlock(scope: !2080, file: !158, line: 101, column: 5)
!2080 = distinct !DILexicalBlock(scope: !2071, file: !158, line: 101, column: 5)
!2081 = !DILocation(line: 101, column: 5, scope: !2080)
!2082 = !DILocation(line: 102, column: 10, scope: !2071)
!2083 = !DILocation(line: 102, column: 17, scope: !2071)
!2084 = !DILocation(line: 102, column: 5, scope: !2071)
!2085 = !DILocation(line: 103, column: 5, scope: !2071)
!2086 = !DILocation(line: 103, column: 12, scope: !2071)
!2087 = !DILocation(line: 103, column: 24, scope: !2071)
!2088 = !DILocation(line: 104, column: 1, scope: !2071)
!2089 = distinct !DISubprogram(name: "vsimpleht_destroy", scope: !6, file: !6, line: 178, type: !630, scopeLine: 179, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!2090 = !DILocalVariable(name: "tbl", arg: 1, scope: !2089, file: !6, line: 178, type: !587)
!2091 = !DILocation(line: 178, column: 32, scope: !2089)
!2092 = !DILocalVariable(name: "entry", scope: !2089, file: !6, line: 180, type: !67)
!2093 = !DILocation(line: 180, column: 24, scope: !2089)
!2094 = !DILocalVariable(name: "obj", scope: !2089, file: !6, line: 181, type: !22)
!2095 = !DILocation(line: 181, column: 11, scope: !2089)
!2096 = !DILocation(line: 182, column: 5, scope: !2097)
!2097 = distinct !DILexicalBlock(scope: !2098, file: !6, line: 182, column: 5)
!2098 = distinct !DILexicalBlock(scope: !2089, file: !6, line: 182, column: 5)
!2099 = !DILocation(line: 182, column: 5, scope: !2098)
!2100 = !DILocalVariable(name: "i", scope: !2101, file: !6, line: 183, type: !14)
!2101 = distinct !DILexicalBlock(scope: !2089, file: !6, line: 183, column: 5)
!2102 = !DILocation(line: 183, column: 18, scope: !2101)
!2103 = !DILocation(line: 183, column: 10, scope: !2101)
!2104 = !DILocation(line: 183, column: 25, scope: !2105)
!2105 = distinct !DILexicalBlock(scope: !2101, file: !6, line: 183, column: 5)
!2106 = !DILocation(line: 183, column: 29, scope: !2105)
!2107 = !DILocation(line: 183, column: 34, scope: !2105)
!2108 = !DILocation(line: 183, column: 27, scope: !2105)
!2109 = !DILocation(line: 183, column: 5, scope: !2101)
!2110 = !DILocation(line: 184, column: 18, scope: !2111)
!2111 = distinct !DILexicalBlock(scope: !2105, file: !6, line: 183, column: 49)
!2112 = !DILocation(line: 184, column: 23, scope: !2111)
!2113 = !DILocation(line: 184, column: 31, scope: !2111)
!2114 = !DILocation(line: 184, column: 15, scope: !2111)
!2115 = !DILocation(line: 185, column: 38, scope: !2111)
!2116 = !DILocation(line: 185, column: 45, scope: !2111)
!2117 = !DILocation(line: 185, column: 17, scope: !2111)
!2118 = !DILocation(line: 185, column: 15, scope: !2111)
!2119 = !DILocation(line: 186, column: 13, scope: !2120)
!2120 = distinct !DILexicalBlock(scope: !2111, file: !6, line: 186, column: 13)
!2121 = !DILocation(line: 186, column: 13, scope: !2111)
!2122 = !DILocation(line: 187, column: 13, scope: !2123)
!2123 = distinct !DILexicalBlock(scope: !2120, file: !6, line: 186, column: 18)
!2124 = !DILocation(line: 187, column: 18, scope: !2123)
!2125 = !DILocation(line: 187, column: 29, scope: !2123)
!2126 = !DILocation(line: 188, column: 9, scope: !2123)
!2127 = !DILocation(line: 189, column: 5, scope: !2111)
!2128 = !DILocation(line: 183, column: 45, scope: !2105)
!2129 = !DILocation(line: 183, column: 5, scope: !2105)
!2130 = distinct !{!2130, !2109, !2131, !212}
!2131 = !DILocation(line: 189, column: 5, scope: !2101)
!2132 = !DILocation(line: 190, column: 1, scope: !2089)
!2133 = distinct !DISubprogram(name: "trace_merge_into", scope: !158, file: !158, line: 177, type: !2134, scopeLine: 178, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!2134 = !DISubroutineType(types: !2135)
!2135 = !{null, !612, !612}
!2136 = !DILocalVariable(name: "trace_container", arg: 1, scope: !2133, file: !158, line: 177, type: !612)
!2137 = !DILocation(line: 177, column: 27, scope: !2133)
!2138 = !DILocalVariable(name: "trace", arg: 2, scope: !2133, file: !158, line: 177, type: !612)
!2139 = !DILocation(line: 177, column: 53, scope: !2133)
!2140 = !DILocation(line: 179, column: 30, scope: !2133)
!2141 = !DILocation(line: 179, column: 47, scope: !2133)
!2142 = !DILocation(line: 179, column: 5, scope: !2133)
!2143 = !DILocation(line: 180, column: 1, scope: !2133)
!2144 = distinct !DISubprogram(name: "vsimpleht_iter_init", scope: !6, file: !6, line: 280, type: !2145, scopeLine: 281, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!2145 = !DISubroutineType(types: !2146)
!2146 = !{null, !587, !2147}
!2147 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !2015, size: 64)
!2148 = !DILocalVariable(name: "tbl", arg: 1, scope: !2144, file: !6, line: 280, type: !587)
!2149 = !DILocation(line: 280, column: 34, scope: !2144)
!2150 = !DILocalVariable(name: "iter", arg: 2, scope: !2144, file: !6, line: 280, type: !2147)
!2151 = !DILocation(line: 280, column: 57, scope: !2144)
!2152 = !DILocation(line: 282, column: 5, scope: !2153)
!2153 = distinct !DILexicalBlock(scope: !2154, file: !6, line: 282, column: 5)
!2154 = distinct !DILexicalBlock(scope: !2144, file: !6, line: 282, column: 5)
!2155 = !DILocation(line: 282, column: 5, scope: !2154)
!2156 = !DILocation(line: 283, column: 5, scope: !2157)
!2157 = distinct !DILexicalBlock(scope: !2158, file: !6, line: 283, column: 5)
!2158 = distinct !DILexicalBlock(scope: !2144, file: !6, line: 283, column: 5)
!2159 = !DILocation(line: 283, column: 5, scope: !2158)
!2160 = !DILocation(line: 284, column: 17, scope: !2144)
!2161 = !DILocation(line: 284, column: 5, scope: !2144)
!2162 = !DILocation(line: 284, column: 11, scope: !2144)
!2163 = !DILocation(line: 284, column: 15, scope: !2144)
!2164 = !DILocation(line: 285, column: 5, scope: !2144)
!2165 = !DILocation(line: 285, column: 11, scope: !2144)
!2166 = !DILocation(line: 285, column: 15, scope: !2144)
!2167 = !DILocation(line: 286, column: 1, scope: !2144)
!2168 = distinct !DISubprogram(name: "vsimpleht_iter_next", scope: !6, file: !6, line: 317, type: !2169, scopeLine: 318, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!2169 = !DISubroutineType(types: !2170)
!2170 = !{!42, !2147, !2171, !52}
!2171 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!2172 = !DILocalVariable(name: "iter", arg: 1, scope: !2168, file: !6, line: 317, type: !2147)
!2173 = !DILocation(line: 317, column: 39, scope: !2168)
!2174 = !DILocalVariable(name: "key", arg: 2, scope: !2168, file: !6, line: 317, type: !2171)
!2175 = !DILocation(line: 317, column: 57, scope: !2168)
!2176 = !DILocalVariable(name: "val", arg: 3, scope: !2168, file: !6, line: 317, type: !52)
!2177 = !DILocation(line: 317, column: 69, scope: !2168)
!2178 = !DILocalVariable(name: "k", scope: !2168, file: !6, line: 319, type: !19)
!2179 = !DILocation(line: 319, column: 16, scope: !2168)
!2180 = !DILocalVariable(name: "v", scope: !2168, file: !6, line: 320, type: !22)
!2181 = !DILocation(line: 320, column: 11, scope: !2168)
!2182 = !DILocalVariable(name: "entries", scope: !2168, file: !6, line: 321, type: !67)
!2183 = !DILocation(line: 321, column: 24, scope: !2168)
!2184 = !DILocation(line: 322, column: 5, scope: !2185)
!2185 = distinct !DILexicalBlock(scope: !2186, file: !6, line: 322, column: 5)
!2186 = distinct !DILexicalBlock(scope: !2168, file: !6, line: 322, column: 5)
!2187 = !DILocation(line: 322, column: 5, scope: !2186)
!2188 = !DILocation(line: 323, column: 5, scope: !2189)
!2189 = distinct !DILexicalBlock(scope: !2190, file: !6, line: 323, column: 5)
!2190 = distinct !DILexicalBlock(scope: !2168, file: !6, line: 323, column: 5)
!2191 = !DILocation(line: 323, column: 5, scope: !2190)
!2192 = !DILocation(line: 324, column: 5, scope: !2193)
!2193 = distinct !DILexicalBlock(scope: !2194, file: !6, line: 324, column: 5)
!2194 = distinct !DILexicalBlock(scope: !2168, file: !6, line: 324, column: 5)
!2195 = !DILocation(line: 324, column: 5, scope: !2194)
!2196 = !DILocation(line: 325, column: 5, scope: !2197)
!2197 = distinct !DILexicalBlock(scope: !2198, file: !6, line: 325, column: 5)
!2198 = distinct !DILexicalBlock(scope: !2168, file: !6, line: 325, column: 5)
!2199 = !DILocation(line: 325, column: 5, scope: !2198)
!2200 = !DILocation(line: 326, column: 15, scope: !2168)
!2201 = !DILocation(line: 326, column: 21, scope: !2168)
!2202 = !DILocation(line: 326, column: 26, scope: !2168)
!2203 = !DILocation(line: 326, column: 13, scope: !2168)
!2204 = !DILocation(line: 327, column: 5, scope: !2205)
!2205 = distinct !DILexicalBlock(scope: !2206, file: !6, line: 327, column: 5)
!2206 = distinct !DILexicalBlock(scope: !2168, file: !6, line: 327, column: 5)
!2207 = !DILocation(line: 327, column: 5, scope: !2206)
!2208 = !DILocalVariable(name: "i", scope: !2209, file: !6, line: 328, type: !14)
!2209 = distinct !DILexicalBlock(scope: !2168, file: !6, line: 328, column: 5)
!2210 = !DILocation(line: 328, column: 18, scope: !2209)
!2211 = !DILocation(line: 328, column: 22, scope: !2209)
!2212 = !DILocation(line: 328, column: 28, scope: !2209)
!2213 = !DILocation(line: 328, column: 10, scope: !2209)
!2214 = !DILocation(line: 328, column: 33, scope: !2215)
!2215 = distinct !DILexicalBlock(scope: !2209, file: !6, line: 328, column: 5)
!2216 = !DILocation(line: 328, column: 37, scope: !2215)
!2217 = !DILocation(line: 328, column: 43, scope: !2215)
!2218 = !DILocation(line: 328, column: 48, scope: !2215)
!2219 = !DILocation(line: 328, column: 35, scope: !2215)
!2220 = !DILocation(line: 328, column: 5, scope: !2209)
!2221 = !DILocation(line: 329, column: 42, scope: !2222)
!2222 = distinct !DILexicalBlock(scope: !2215, file: !6, line: 328, column: 63)
!2223 = !DILocation(line: 329, column: 50, scope: !2222)
!2224 = !DILocation(line: 329, column: 53, scope: !2222)
!2225 = !DILocation(line: 329, column: 25, scope: !2222)
!2226 = !DILocation(line: 329, column: 13, scope: !2222)
!2227 = !DILocation(line: 329, column: 11, scope: !2222)
!2228 = !DILocation(line: 330, column: 30, scope: !2222)
!2229 = !DILocation(line: 330, column: 38, scope: !2222)
!2230 = !DILocation(line: 330, column: 41, scope: !2222)
!2231 = !DILocation(line: 330, column: 13, scope: !2222)
!2232 = !DILocation(line: 330, column: 11, scope: !2222)
!2233 = !DILocation(line: 331, column: 13, scope: !2234)
!2234 = distinct !DILexicalBlock(scope: !2222, file: !6, line: 331, column: 13)
!2235 = !DILocation(line: 331, column: 15, scope: !2234)
!2236 = !DILocation(line: 331, column: 18, scope: !2234)
!2237 = !DILocation(line: 331, column: 13, scope: !2222)
!2238 = !DILocation(line: 332, column: 25, scope: !2239)
!2239 = distinct !DILexicalBlock(scope: !2234, file: !6, line: 331, column: 21)
!2240 = !DILocation(line: 332, column: 27, scope: !2239)
!2241 = !DILocation(line: 332, column: 13, scope: !2239)
!2242 = !DILocation(line: 332, column: 19, scope: !2239)
!2243 = !DILocation(line: 332, column: 23, scope: !2239)
!2244 = !DILocation(line: 333, column: 25, scope: !2239)
!2245 = !DILocation(line: 333, column: 14, scope: !2239)
!2246 = !DILocation(line: 333, column: 23, scope: !2239)
!2247 = !DILocation(line: 334, column: 25, scope: !2239)
!2248 = !DILocation(line: 334, column: 14, scope: !2239)
!2249 = !DILocation(line: 334, column: 23, scope: !2239)
!2250 = !DILocation(line: 335, column: 13, scope: !2239)
!2251 = !DILocation(line: 337, column: 5, scope: !2222)
!2252 = !DILocation(line: 328, column: 59, scope: !2215)
!2253 = !DILocation(line: 328, column: 5, scope: !2215)
!2254 = distinct !{!2254, !2220, !2255, !212}
!2255 = !DILocation(line: 337, column: 5, scope: !2209)
!2256 = !DILocation(line: 338, column: 5, scope: !2168)
!2257 = !DILocation(line: 339, column: 1, scope: !2168)
!2258 = distinct !DISubprogram(name: "trace_subtract_from", scope: !158, file: !158, line: 183, type: !2134, scopeLine: 184, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!2259 = !DILocalVariable(name: "trace_container", arg: 1, scope: !2258, file: !158, line: 183, type: !612)
!2260 = !DILocation(line: 183, column: 30, scope: !2258)
!2261 = !DILocalVariable(name: "trace", arg: 2, scope: !2258, file: !158, line: 183, type: !612)
!2262 = !DILocation(line: 183, column: 56, scope: !2258)
!2263 = !DILocation(line: 185, column: 30, scope: !2258)
!2264 = !DILocation(line: 185, column: 47, scope: !2258)
!2265 = !DILocation(line: 185, column: 5, scope: !2258)
!2266 = !DILocation(line: 186, column: 1, scope: !2258)
!2267 = distinct !DISubprogram(name: "trace_is_subtrace", scope: !158, file: !158, line: 292, type: !2268, scopeLine: 294, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!2268 = !DISubroutineType(types: !2269)
!2269 = !{!42, !612, !612, !2270}
!2270 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !2271, size: 64)
!2271 = !DISubroutineType(types: !2272)
!2272 = !{null, !19}
!2273 = !DILocalVariable(name: "super_trace", arg: 1, scope: !2267, file: !158, line: 292, type: !612)
!2274 = !DILocation(line: 292, column: 28, scope: !2267)
!2275 = !DILocalVariable(name: "sub_trace", arg: 2, scope: !2267, file: !158, line: 292, type: !612)
!2276 = !DILocation(line: 292, column: 50, scope: !2267)
!2277 = !DILocalVariable(name: "print", arg: 3, scope: !2267, file: !158, line: 293, type: !2270)
!2278 = !DILocation(line: 293, column: 26, scope: !2267)
!2279 = !DILocalVariable(name: "i", scope: !2267, file: !158, line: 295, type: !14)
!2280 = !DILocation(line: 295, column: 13, scope: !2267)
!2281 = !DILocalVariable(name: "idx", scope: !2267, file: !158, line: 296, type: !14)
!2282 = !DILocation(line: 296, column: 13, scope: !2267)
!2283 = !DILocalVariable(name: "unit_a", scope: !2267, file: !158, line: 298, type: !162)
!2284 = !DILocation(line: 298, column: 19, scope: !2267)
!2285 = !DILocalVariable(name: "unit_b", scope: !2267, file: !158, line: 299, type: !162)
!2286 = !DILocation(line: 299, column: 19, scope: !2267)
!2287 = !DILocation(line: 302, column: 12, scope: !2288)
!2288 = distinct !DILexicalBlock(scope: !2267, file: !158, line: 302, column: 5)
!2289 = !DILocation(line: 302, column: 10, scope: !2288)
!2290 = !DILocation(line: 302, column: 17, scope: !2291)
!2291 = distinct !DILexicalBlock(scope: !2288, file: !158, line: 302, column: 5)
!2292 = !DILocation(line: 302, column: 21, scope: !2291)
!2293 = !DILocation(line: 302, column: 32, scope: !2291)
!2294 = !DILocation(line: 302, column: 19, scope: !2291)
!2295 = !DILocation(line: 302, column: 5, scope: !2288)
!2296 = !DILocation(line: 303, column: 19, scope: !2297)
!2297 = distinct !DILexicalBlock(scope: !2291, file: !158, line: 302, column: 42)
!2298 = !DILocation(line: 303, column: 30, scope: !2297)
!2299 = !DILocation(line: 303, column: 36, scope: !2297)
!2300 = !DILocation(line: 303, column: 16, scope: !2297)
!2301 = !DILocation(line: 305, column: 33, scope: !2302)
!2302 = distinct !DILexicalBlock(scope: !2297, file: !158, line: 305, column: 13)
!2303 = !DILocation(line: 305, column: 46, scope: !2302)
!2304 = !DILocation(line: 305, column: 54, scope: !2302)
!2305 = !DILocation(line: 305, column: 13, scope: !2302)
!2306 = !DILocation(line: 305, column: 13, scope: !2297)
!2307 = !DILocation(line: 306, column: 23, scope: !2308)
!2308 = distinct !DILexicalBlock(scope: !2302, file: !158, line: 305, column: 66)
!2309 = !DILocation(line: 306, column: 36, scope: !2308)
!2310 = !DILocation(line: 306, column: 42, scope: !2308)
!2311 = !DILocation(line: 306, column: 20, scope: !2308)
!2312 = !DILocation(line: 308, column: 13, scope: !2313)
!2313 = distinct !DILexicalBlock(scope: !2314, file: !158, line: 308, column: 13)
!2314 = distinct !DILexicalBlock(scope: !2308, file: !158, line: 308, column: 13)
!2315 = !DILocation(line: 308, column: 13, scope: !2314)
!2316 = !DILocation(line: 310, column: 17, scope: !2317)
!2317 = distinct !DILexicalBlock(scope: !2308, file: !158, line: 310, column: 17)
!2318 = !DILocation(line: 310, column: 25, scope: !2317)
!2319 = !DILocation(line: 310, column: 34, scope: !2317)
!2320 = !DILocation(line: 310, column: 42, scope: !2317)
!2321 = !DILocation(line: 310, column: 31, scope: !2317)
!2322 = !DILocation(line: 310, column: 17, scope: !2308)
!2323 = !DILocation(line: 311, column: 21, scope: !2324)
!2324 = distinct !DILexicalBlock(scope: !2325, file: !158, line: 311, column: 21)
!2325 = distinct !DILexicalBlock(scope: !2317, file: !158, line: 310, column: 49)
!2326 = !DILocation(line: 311, column: 21, scope: !2325)
!2327 = !DILocation(line: 314, column: 28, scope: !2328)
!2328 = distinct !DILexicalBlock(scope: !2324, file: !158, line: 311, column: 28)
!2329 = !DILocation(line: 314, column: 36, scope: !2328)
!2330 = !DILocation(line: 314, column: 41, scope: !2328)
!2331 = !DILocation(line: 314, column: 49, scope: !2328)
!2332 = !DILocation(line: 314, column: 56, scope: !2328)
!2333 = !DILocation(line: 314, column: 64, scope: !2328)
!2334 = !DILocation(line: 312, column: 21, scope: !2328)
!2335 = !DILocation(line: 315, column: 21, scope: !2328)
!2336 = !DILocation(line: 315, column: 27, scope: !2328)
!2337 = !DILocation(line: 315, column: 35, scope: !2328)
!2338 = !DILocation(line: 316, column: 17, scope: !2328)
!2339 = !DILocation(line: 317, column: 17, scope: !2325)
!2340 = !DILocation(line: 319, column: 9, scope: !2308)
!2341 = !DILocation(line: 320, column: 17, scope: !2342)
!2342 = distinct !DILexicalBlock(scope: !2343, file: !158, line: 320, column: 17)
!2343 = distinct !DILexicalBlock(scope: !2302, file: !158, line: 319, column: 16)
!2344 = !DILocation(line: 320, column: 17, scope: !2343)
!2345 = !DILocation(line: 321, column: 65, scope: !2346)
!2346 = distinct !DILexicalBlock(scope: !2342, file: !158, line: 320, column: 24)
!2347 = !DILocation(line: 321, column: 73, scope: !2346)
!2348 = !DILocation(line: 321, column: 17, scope: !2346)
!2349 = !DILocation(line: 322, column: 17, scope: !2346)
!2350 = !DILocation(line: 322, column: 23, scope: !2346)
!2351 = !DILocation(line: 322, column: 31, scope: !2346)
!2352 = !DILocation(line: 323, column: 13, scope: !2346)
!2353 = !DILocation(line: 324, column: 13, scope: !2343)
!2354 = !DILocation(line: 326, column: 5, scope: !2297)
!2355 = !DILocation(line: 302, column: 38, scope: !2291)
!2356 = !DILocation(line: 302, column: 5, scope: !2291)
!2357 = distinct !{!2357, !2295, !2358, !212}
!2358 = !DILocation(line: 326, column: 5, scope: !2288)
!2359 = !DILocation(line: 328, column: 5, scope: !2267)
!2360 = !DILocation(line: 329, column: 1, scope: !2267)
!2361 = distinct !DISubprogram(name: "_trace_merge_or_subtract", scope: !158, file: !158, line: 161, type: !2362, scopeLine: 163, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !188)
!2362 = !DISubroutineType(types: !2363)
!2363 = !{null, !612, !612, !42}
!2364 = !DILocalVariable(name: "trace_container", arg: 1, scope: !2361, file: !158, line: 161, type: !612)
!2365 = !DILocation(line: 161, column: 35, scope: !2361)
!2366 = !DILocalVariable(name: "trace", arg: 2, scope: !2361, file: !158, line: 161, type: !612)
!2367 = !DILocation(line: 161, column: 61, scope: !2361)
!2368 = !DILocalVariable(name: "subtract", arg: 3, scope: !2361, file: !158, line: 162, type: !42)
!2369 = !DILocation(line: 162, column: 34, scope: !2361)
!2370 = !DILocalVariable(name: "i", scope: !2361, file: !158, line: 164, type: !14)
!2371 = !DILocation(line: 164, column: 13, scope: !2361)
!2372 = !DILocation(line: 165, column: 5, scope: !2373)
!2373 = distinct !DILexicalBlock(scope: !2374, file: !158, line: 165, column: 5)
!2374 = distinct !DILexicalBlock(scope: !2361, file: !158, line: 165, column: 5)
!2375 = !DILocation(line: 165, column: 5, scope: !2374)
!2376 = !DILocation(line: 166, column: 5, scope: !2377)
!2377 = distinct !DILexicalBlock(scope: !2378, file: !158, line: 166, column: 5)
!2378 = distinct !DILexicalBlock(scope: !2361, file: !158, line: 166, column: 5)
!2379 = !DILocation(line: 166, column: 5, scope: !2378)
!2380 = !DILocation(line: 168, column: 5, scope: !2381)
!2381 = distinct !DILexicalBlock(scope: !2382, file: !158, line: 168, column: 5)
!2382 = distinct !DILexicalBlock(scope: !2361, file: !158, line: 168, column: 5)
!2383 = !DILocation(line: 168, column: 5, scope: !2382)
!2384 = !DILocation(line: 169, column: 5, scope: !2385)
!2385 = distinct !DILexicalBlock(scope: !2386, file: !158, line: 169, column: 5)
!2386 = distinct !DILexicalBlock(scope: !2361, file: !158, line: 169, column: 5)
!2387 = !DILocation(line: 169, column: 5, scope: !2386)
!2388 = !DILocation(line: 171, column: 12, scope: !2389)
!2389 = distinct !DILexicalBlock(scope: !2361, file: !158, line: 171, column: 5)
!2390 = !DILocation(line: 171, column: 10, scope: !2389)
!2391 = !DILocation(line: 171, column: 17, scope: !2392)
!2392 = distinct !DILexicalBlock(scope: !2389, file: !158, line: 171, column: 5)
!2393 = !DILocation(line: 171, column: 21, scope: !2392)
!2394 = !DILocation(line: 171, column: 28, scope: !2392)
!2395 = !DILocation(line: 171, column: 19, scope: !2392)
!2396 = !DILocation(line: 171, column: 5, scope: !2389)
!2397 = !DILocation(line: 172, column: 39, scope: !2398)
!2398 = distinct !DILexicalBlock(scope: !2392, file: !158, line: 171, column: 38)
!2399 = !DILocation(line: 172, column: 56, scope: !2398)
!2400 = !DILocation(line: 172, column: 63, scope: !2398)
!2401 = !DILocation(line: 172, column: 69, scope: !2398)
!2402 = !DILocation(line: 172, column: 72, scope: !2398)
!2403 = !DILocation(line: 173, column: 39, scope: !2398)
!2404 = !DILocation(line: 173, column: 46, scope: !2398)
!2405 = !DILocation(line: 173, column: 52, scope: !2398)
!2406 = !DILocation(line: 173, column: 55, scope: !2398)
!2407 = !DILocation(line: 173, column: 62, scope: !2398)
!2408 = !DILocation(line: 172, column: 9, scope: !2398)
!2409 = !DILocation(line: 174, column: 5, scope: !2398)
!2410 = !DILocation(line: 171, column: 34, scope: !2392)
!2411 = !DILocation(line: 171, column: 5, scope: !2392)
!2412 = distinct !{!2412, !2396, !2413, !212}
!2413 = !DILocation(line: 174, column: 5, scope: !2389)
!2414 = !DILocation(line: 175, column: 1, scope: !2361)
