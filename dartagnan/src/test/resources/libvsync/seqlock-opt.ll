; ModuleID = '/home/drc/git/Dat3M/output/seqlock.ll'
source_filename = "/home/drc/git/huawei/libvsync/spinlock/test/seqlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.seqlock_s = type { %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@lock = dso_local global %struct.seqlock_s zeroinitializer, align 4, !dbg !0
@g_cs_x = dso_local global i32 0, align 4, !dbg !18
@g_cs_y = dso_local global i32 0, align 4, !dbg !21
@.str = private unnamed_addr constant [7 x i8] c"a == b\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/drc/git/huawei/libvsync/spinlock/test/seqlock.c\00", align 1
@__PRETTY_FUNCTION__.reader_cs = private unnamed_addr constant [26 x i8] c"void reader_cs(vuint32_t)\00", align 1
@.str.2 = private unnamed_addr constant [17 x i8] c"(((s)&1U) == 0U)\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"x == y\00", align 1
@__PRETTY_FUNCTION__.fini = private unnamed_addr constant [16 x i8] c"void fini(void)\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"x == 2\00", align 1
@.str.5 = private unnamed_addr constant [21 x i8] c"(((count)&1U) == 0U)\00", align 1
@.str.6 = private unnamed_addr constant [44 x i8] c"./spinlock/include/vsync/spinlock/seqlock.h\00", align 1
@__PRETTY_FUNCTION__._seqlock_await_even = private unnamed_addr constant [44 x i8] c"seqvalue_t _seqlock_await_even(seqlock_t *)\00", align 1
@.str.7 = private unnamed_addr constant [27 x i8] c"(cur_val & 0x1UL) == 0x1UL\00", align 1
@__PRETTY_FUNCTION__.seqlock_release = private unnamed_addr constant [34 x i8] c"void seqlock_release(seqlock_t *)\00", align 1
@.str.8 = private unnamed_addr constant [18 x i8] c"(((sv)&1U) == 0U)\00", align 1
@__PRETTY_FUNCTION__.seqlock_rend = private unnamed_addr constant [46 x i8] c"vbool_t seqlock_rend(seqlock_t *, seqvalue_t)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !41 {
  ret void, !dbg !46
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !47 {
  ret void, !dbg !48
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !49 {
  ret void, !dbg !50
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_acquire(i32 noundef %0) #0 !dbg !51 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !54, metadata !DIExpression()), !dbg !55
  ret void, !dbg !56
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_release(i32 noundef %0) #0 !dbg !57 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !58, metadata !DIExpression()), !dbg !59
  ret void, !dbg !60
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_acquire(i32 noundef %0) #0 !dbg !61 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !62, metadata !DIExpression()), !dbg !63
  ret void, !dbg !64
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_release(i32 noundef %0) #0 !dbg !65 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !66, metadata !DIExpression()), !dbg !67
  ret void, !dbg !68
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !69 {
  %1 = alloca [4 x i64], align 16
  call void @llvm.dbg.declare(metadata [4 x i64]* %1, metadata !73, metadata !DIExpression()), !dbg !79
  call void @init(), !dbg !80
  call void @llvm.dbg.value(metadata i64 0, metadata !81, metadata !DIExpression()), !dbg !83
  call void @llvm.dbg.value(metadata i64 0, metadata !81, metadata !DIExpression()), !dbg !83
  %2 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 0, !dbg !84
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef null) #5, !dbg !87
  call void @llvm.dbg.value(metadata i64 1, metadata !81, metadata !DIExpression()), !dbg !83
  call void @llvm.dbg.value(metadata i64 1, metadata !81, metadata !DIExpression()), !dbg !83
  %4 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 1, !dbg !84
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef inttoptr (i64 1 to i8*)) #5, !dbg !87
  call void @llvm.dbg.value(metadata i64 2, metadata !81, metadata !DIExpression()), !dbg !83
  call void @llvm.dbg.value(metadata i64 2, metadata !81, metadata !DIExpression()), !dbg !83
  call void @llvm.dbg.value(metadata i64 2, metadata !88, metadata !DIExpression()), !dbg !90
  call void @llvm.dbg.value(metadata i64 2, metadata !88, metadata !DIExpression()), !dbg !90
  %6 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 2, !dbg !91
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef inttoptr (i64 2 to i8*)) #5, !dbg !94
  call void @llvm.dbg.value(metadata i64 3, metadata !88, metadata !DIExpression()), !dbg !90
  call void @llvm.dbg.value(metadata i64 3, metadata !88, metadata !DIExpression()), !dbg !90
  %8 = getelementptr inbounds [4 x i64], [4 x i64]* %1, i64 0, i64 3, !dbg !91
  %9 = call i32 @pthread_create(i64* noundef %8, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef inttoptr (i64 3 to i8*)) #5, !dbg !94
  call void @llvm.dbg.value(metadata i64 4, metadata !88, metadata !DIExpression()), !dbg !90
  call void @llvm.dbg.value(metadata i64 4, metadata !88, metadata !DIExpression()), !dbg !90
  call void @post(), !dbg !95
  call void @llvm.dbg.value(metadata i64 0, metadata !96, metadata !DIExpression()), !dbg !98
  call void @llvm.dbg.value(metadata i64 0, metadata !96, metadata !DIExpression()), !dbg !98
  %10 = load i64, i64* %2, align 8, !dbg !99
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !102
  call void @llvm.dbg.value(metadata i64 1, metadata !96, metadata !DIExpression()), !dbg !98
  call void @llvm.dbg.value(metadata i64 1, metadata !96, metadata !DIExpression()), !dbg !98
  %12 = load i64, i64* %4, align 8, !dbg !99
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !102
  call void @llvm.dbg.value(metadata i64 2, metadata !96, metadata !DIExpression()), !dbg !98
  call void @llvm.dbg.value(metadata i64 2, metadata !96, metadata !DIExpression()), !dbg !98
  %14 = load i64, i64* %6, align 8, !dbg !99
  %15 = call i32 @pthread_join(i64 noundef %14, i8** noundef null), !dbg !102
  call void @llvm.dbg.value(metadata i64 3, metadata !96, metadata !DIExpression()), !dbg !98
  call void @llvm.dbg.value(metadata i64 3, metadata !96, metadata !DIExpression()), !dbg !98
  %16 = load i64, i64* %8, align 8, !dbg !99
  %17 = call i32 @pthread_join(i64 noundef %16, i8** noundef null), !dbg !102
  call void @llvm.dbg.value(metadata i64 4, metadata !96, metadata !DIExpression()), !dbg !98
  call void @llvm.dbg.value(metadata i64 4, metadata !96, metadata !DIExpression()), !dbg !98
  call void @check(), !dbg !103
  call void @fini(), !dbg !104
  ret i32 0, !dbg !105
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal i8* @writer(i8* noundef %0) #0 !dbg !106 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !109, metadata !DIExpression()), !dbg !110
  %2 = ptrtoint i8* %0 to i64, !dbg !111
  %3 = trunc i64 %2 to i32, !dbg !112
  call void @llvm.dbg.value(metadata i32 %3, metadata !113, metadata !DIExpression()), !dbg !110
  call void @writer_acquire(i32 noundef %3), !dbg !114
  call void @writer_cs(i32 noundef %3), !dbg !115
  call void @writer_release(i32 noundef %3), !dbg !116
  ret i8* null, !dbg !117
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @reader(i8* noundef %0) #0 !dbg !118 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !119, metadata !DIExpression()), !dbg !120
  %2 = ptrtoint i8* %0 to i64, !dbg !121
  %3 = trunc i64 %2 to i32, !dbg !122
  call void @llvm.dbg.value(metadata i32 %3, metadata !123, metadata !DIExpression()), !dbg !120
  call void @reader_acquire(i32 noundef %3), !dbg !124
  call void @reader_cs(i32 noundef %3), !dbg !125
  call void @reader_release(i32 noundef %3), !dbg !126
  ret i8* null, !dbg !127
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !128 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !129
  call void @llvm.dbg.value(metadata i32 %1, metadata !130, metadata !DIExpression()), !dbg !131
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !132
  call void @llvm.dbg.value(metadata i32 %2, metadata !133, metadata !DIExpression()), !dbg !131
  %3 = icmp eq i32 %1, %2, !dbg !134
  br i1 %3, label %5, label %4, !dbg !137

4:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 55, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.fini, i64 0, i64 0)) #6, !dbg !134
  unreachable, !dbg !134

5:                                                ; preds = %0
  %6 = icmp eq i32 %1, 2, !dbg !138
  br i1 %6, label %8, label %7, !dbg !141

7:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 56, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.fini, i64 0, i64 0)) #6, !dbg !138
  unreachable, !dbg !138

8:                                                ; preds = %5
  ret void, !dbg !142
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_cs(i32 noundef %0) #0 !dbg !143 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !144, metadata !DIExpression()), !dbg !145
  call void @seqlock_acquire(%struct.seqlock_s* noundef @lock), !dbg !146
  %2 = load i32, i32* @g_cs_x, align 4, !dbg !147
  %3 = add i32 %2, 1, !dbg !147
  store i32 %3, i32* @g_cs_x, align 4, !dbg !147
  %4 = load i32, i32* @g_cs_y, align 4, !dbg !148
  %5 = add i32 %4, 1, !dbg !148
  store i32 %5, i32* @g_cs_y, align 4, !dbg !148
  call void @seqlock_release(%struct.seqlock_s* noundef @lock), !dbg !149
  ret void, !dbg !150
}

; Function Attrs: noinline nounwind uwtable
define internal void @seqlock_acquire(%struct.seqlock_s* noundef %0) #0 !dbg !151 {
  call void @llvm.dbg.value(metadata %struct.seqlock_s* %0, metadata !155, metadata !DIExpression()), !dbg !156
  call void @llvm.dbg.value(metadata i32 0, metadata !157, metadata !DIExpression()), !dbg !156
  call void @llvm.dbg.value(metadata i32 0, metadata !159, metadata !DIExpression()), !dbg !156
  br label %2, !dbg !160

2:                                                ; preds = %2, %1
  %3 = call i32 @_seqlock_await_even(%struct.seqlock_s* noundef %0), !dbg !161
  call void @llvm.dbg.value(metadata i32 %3, metadata !157, metadata !DIExpression()), !dbg !156
  %4 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %0, i32 0, i32 0, !dbg !163
  %5 = add i32 %3, 1, !dbg !164
  %6 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %4, i32 noundef %3, i32 noundef %5), !dbg !165
  call void @llvm.dbg.value(metadata i32 %6, metadata !159, metadata !DIExpression()), !dbg !156
  %7 = icmp eq i32 %6, %3, !dbg !166
  br i1 %7, label %8, label %2, !dbg !168, !llvm.loop !169

8:                                                ; preds = %2
  call void @vatomic_fence_rel(), !dbg !171
  ret void, !dbg !172
}

; Function Attrs: noinline nounwind uwtable
define internal void @seqlock_release(%struct.seqlock_s* noundef %0) #0 !dbg !173 {
  call void @llvm.dbg.value(metadata %struct.seqlock_s* %0, metadata !174, metadata !DIExpression()), !dbg !175
  %2 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %0, i32 0, i32 0, !dbg !176
  %3 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %2), !dbg !177
  call void @llvm.dbg.value(metadata i32 %3, metadata !178, metadata !DIExpression()), !dbg !175
  %4 = zext i32 %3 to i64, !dbg !179
  %5 = and i64 %4, 1, !dbg !179
  %6 = icmp eq i64 %5, 1, !dbg !179
  br i1 %6, label %8, label %7, !dbg !182

7:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.7, i64 0, i64 0), i8* noundef getelementptr inbounds ([44 x i8], [44 x i8]* @.str.6, i64 0, i64 0), i32 noundef 118, i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @__PRETTY_FUNCTION__.seqlock_release, i64 0, i64 0)) #6, !dbg !179
  unreachable, !dbg !179

8:                                                ; preds = %1
  %9 = add i32 %3, 1, !dbg !183
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %2, i32 noundef %9), !dbg !184
  ret void, !dbg !185
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_cs(i32 noundef %0) #0 !dbg !186 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !187, metadata !DIExpression()), !dbg !188
  call void @llvm.dbg.value(metadata i32 0, metadata !189, metadata !DIExpression()), !dbg !188
  call void @llvm.dbg.value(metadata i32 0, metadata !190, metadata !DIExpression()), !dbg !188
  call void @llvm.dbg.value(metadata i32 0, metadata !191, metadata !DIExpression()), !dbg !188
  br label %2, !dbg !192

2:                                                ; preds = %2, %1
  %3 = call i32 @seqlock_rbegin(%struct.seqlock_s* noundef @lock), !dbg !193
  call void @llvm.dbg.value(metadata i32 %3, metadata !191, metadata !DIExpression()), !dbg !188
  %4 = load i32, i32* @g_cs_x, align 4, !dbg !195
  call void @llvm.dbg.value(metadata i32 %4, metadata !189, metadata !DIExpression()), !dbg !188
  %5 = load i32, i32* @g_cs_y, align 4, !dbg !196
  call void @llvm.dbg.value(metadata i32 %5, metadata !190, metadata !DIExpression()), !dbg !188
  %6 = call zeroext i1 @seqlock_rend(%struct.seqlock_s* noundef @lock, i32 noundef %3), !dbg !197
  %7 = xor i1 %6, true, !dbg !197
  br i1 %7, label %2, label %8, !dbg !198, !llvm.loop !199

8:                                                ; preds = %2
  %9 = icmp eq i32 %4, %5, !dbg !201
  br i1 %9, label %11, label %10, !dbg !204

10:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 45, i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @__PRETTY_FUNCTION__.reader_cs, i64 0, i64 0)) #6, !dbg !201
  unreachable, !dbg !201

11:                                               ; preds = %8
  %12 = and i32 %3, 1, !dbg !205
  %13 = icmp eq i32 %12, 0, !dbg !205
  br i1 %13, label %15, label %14, !dbg !208

14:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 46, i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @__PRETTY_FUNCTION__.reader_cs, i64 0, i64 0)) #6, !dbg !205
  unreachable, !dbg !205

15:                                               ; preds = %11
  ret void, !dbg !209
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @seqlock_rbegin(%struct.seqlock_s* noundef %0) #0 !dbg !210 {
  call void @llvm.dbg.value(metadata %struct.seqlock_s* %0, metadata !213, metadata !DIExpression()), !dbg !214
  %2 = call i32 @_seqlock_await_even(%struct.seqlock_s* noundef %0), !dbg !215
  ret i32 %2, !dbg !216
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @seqlock_rend(%struct.seqlock_s* noundef %0, i32 noundef %1) #0 !dbg !217 {
  call void @llvm.dbg.value(metadata %struct.seqlock_s* %0, metadata !222, metadata !DIExpression()), !dbg !223
  call void @llvm.dbg.value(metadata i32 %1, metadata !224, metadata !DIExpression()), !dbg !223
  %3 = and i32 %1, 1, !dbg !225
  %4 = icmp eq i32 %3, 0, !dbg !225
  br i1 %4, label %6, label %5, !dbg !228

5:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.8, i64 0, i64 0), i8* noundef getelementptr inbounds ([44 x i8], [44 x i8]* @.str.6, i64 0, i64 0), i32 noundef 156, i8* noundef getelementptr inbounds ([46 x i8], [46 x i8]* @__PRETTY_FUNCTION__.seqlock_rend, i64 0, i64 0)) #6, !dbg !225
  unreachable, !dbg !225

6:                                                ; preds = %2
  call void @vatomic_fence_acq(), !dbg !229
  %7 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %0, i32 0, i32 0, !dbg !230
  %8 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %7), !dbg !231
  %9 = icmp eq i32 %8, %1, !dbg !232
  ret i1 %9, !dbg !233
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @_seqlock_await_even(%struct.seqlock_s* noundef %0) #0 !dbg !234 {
  call void @llvm.dbg.value(metadata %struct.seqlock_s* %0, metadata !235, metadata !DIExpression()), !dbg !236
  %2 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %0, i32 0, i32 0, !dbg !237
  %3 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %2), !dbg !238
  call void @llvm.dbg.value(metadata i32 %3, metadata !239, metadata !DIExpression()), !dbg !236
  br label %4, !dbg !240

4:                                                ; preds = %7, %1
  %.0 = phi i32 [ %3, %1 ], [ %8, %7 ], !dbg !236
  call void @llvm.dbg.value(metadata i32 %.0, metadata !239, metadata !DIExpression()), !dbg !236
  %5 = and i32 %.0, 1, !dbg !241
  %6 = icmp eq i32 %5, 1, !dbg !241
  br i1 %6, label %7, label %9, !dbg !240

7:                                                ; preds = %4
  %8 = call i32 @vatomic32_await_neq_acq(%struct.vatomic32_s* noundef %2, i32 noundef %.0), !dbg !242
  call void @llvm.dbg.value(metadata i32 %8, metadata !239, metadata !DIExpression()), !dbg !236
  br label %4, !dbg !240, !llvm.loop !244

9:                                                ; preds = %4
  %10 = icmp eq i32 %5, 0, !dbg !246
  br i1 %10, label %12, label %11, !dbg !249

11:                                               ; preds = %9
  call void @__assert_fail(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([44 x i8], [44 x i8]* @.str.6, i64 0, i64 0), i32 noundef 54, i8* noundef getelementptr inbounds ([44 x i8], [44 x i8]* @__PRETTY_FUNCTION__._seqlock_await_even, i64 0, i64 0)) #6, !dbg !246
  unreachable, !dbg !246

12:                                               ; preds = %9
  ret i32 %.0, !dbg !250
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !251 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !256, metadata !DIExpression()), !dbg !257
  call void @llvm.dbg.value(metadata i32 %1, metadata !258, metadata !DIExpression()), !dbg !257
  call void @llvm.dbg.value(metadata i32 %2, metadata !259, metadata !DIExpression()), !dbg !257
  call void @llvm.dbg.value(metadata i32 %1, metadata !260, metadata !DIExpression()), !dbg !257
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !261, !srcloc !262
  %4 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !263
  %5 = cmpxchg i32* %4, i32 %1, i32 %2 acquire acquire, align 4, !dbg !264
  %6 = extractvalue { i32, i1 } %5, 0, !dbg !264
  %7 = extractvalue { i32, i1 } %5, 1, !dbg !264
  %spec.select = select i1 %7, i32 %1, i32 %6, !dbg !264
  call void @llvm.dbg.value(metadata i32 %spec.select, metadata !260, metadata !DIExpression()), !dbg !257
  %8 = zext i1 %7 to i8, !dbg !264
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !265, !srcloc !266
  ret i32 %spec.select, !dbg !267
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic_fence_rel() #0 !dbg !268 {
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !269, !srcloc !270
  fence release, !dbg !271
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !272, !srcloc !273
  ret void, !dbg !274
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !275 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !278, metadata !DIExpression()), !dbg !279
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !280, !srcloc !281
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !282
  %3 = load atomic i32, i32* %2 acquire, align 4, !dbg !283
  call void @llvm.dbg.value(metadata i32 %3, metadata !284, metadata !DIExpression()), !dbg !279
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !285, !srcloc !286
  ret i32 %3, !dbg !287
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_neq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !288 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !292, metadata !DIExpression()), !dbg !293
  call void @llvm.dbg.value(metadata i32 %1, metadata !294, metadata !DIExpression()), !dbg !293
  call void @llvm.dbg.value(metadata i32 0, metadata !295, metadata !DIExpression()), !dbg !293
  br label %3, !dbg !296

3:                                                ; preds = %3, %2
  %4 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0), !dbg !296
  call void @llvm.dbg.value(metadata i32 %4, metadata !295, metadata !DIExpression()), !dbg !293
  %5 = icmp eq i32 %4, %1, !dbg !296
  br i1 %5, label %3, label %6, !dbg !296, !llvm.loop !297

6:                                                ; preds = %3
  ret i32 %4, !dbg !299
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !300 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !301, metadata !DIExpression()), !dbg !302
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !303, !srcloc !304
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !305
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !306
  call void @llvm.dbg.value(metadata i32 %3, metadata !307, metadata !DIExpression()), !dbg !302
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !308, !srcloc !309
  ret i32 %3, !dbg !310
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !311 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !314, metadata !DIExpression()), !dbg !315
  call void @llvm.dbg.value(metadata i32 %1, metadata !316, metadata !DIExpression()), !dbg !315
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !317, !srcloc !318
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !319
  store atomic i32 %1, i32* %3 release, align 4, !dbg !320
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !321, !srcloc !322
  ret void, !dbg !323
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic_fence_acq() #0 !dbg !324 {
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !325, !srcloc !326
  fence acquire, !dbg !327
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !328, !srcloc !329
  ret void, !dbg !330
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!33, !34, !35, !36, !37, !38, !39}
!llvm.ident = !{!40}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !20, line: 11, type: !23, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/huawei/libvsync/spinlock/test/seqlock.c", directory: "/home/drc/git/huawei/libvsync", checksumkind: CSK_MD5, checksum: "c447fd7947a53c2d83c2e7ef2c8ccbfd")
!4 = !{!5, !6, !13}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !7, line: 35, baseType: !8)
!7 = !DIFile(filename: "./include/vsync/vtypes.h", directory: "/home/drc/git/huawei/libvsync", checksumkind: CSK_MD5, checksum: "8393d71cf48910a1804476170aa0c9c0")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !9, line: 26, baseType: !10)
!9 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !11, line: 42, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!12 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 37, baseType: !14)
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !15, line: 90, baseType: !16)
!15 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!16 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!17 = !{!0, !18, !21}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !20, line: 18, type: !6, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "spinlock/test/seqlock.c", directory: "/home/drc/git/huawei/libvsync", checksumkind: CSK_MD5, checksum: "c447fd7947a53c2d83c2e7ef2c8ccbfd")
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !20, line: 19, type: !6, isLocal: false, isDefinition: true)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "seqlock_t", file: !24, line: 33, baseType: !25)
!24 = !DIFile(filename: "./spinlock/include/vsync/spinlock/seqlock.h", directory: "/home/drc/git/huawei/libvsync", checksumkind: CSK_MD5, checksum: "61d628e3ec24c302304f26d6bf3b3da0")
!25 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "seqlock_s", file: !24, line: 30, size: 32, elements: !26)
!26 = !{!27}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "seqcount", scope: !25, file: !24, line: 32, baseType: !28, size: 32, align: 32)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !29, line: 34, baseType: !30)
!29 = !DIFile(filename: "./atomics/include/vsync/atomic/internal/types.h", directory: "/home/drc/git/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !29, line: 32, size: 32, align: 32, elements: !31)
!31 = !{!32}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !30, file: !29, line: 33, baseType: !6, size: 32)
!33 = !{i32 7, !"Dwarf Version", i32 5}
!34 = !{i32 2, !"Debug Info Version", i32 3}
!35 = !{i32 1, !"wchar_size", i32 4}
!36 = !{i32 7, !"PIC Level", i32 2}
!37 = !{i32 7, !"PIE Level", i32 2}
!38 = !{i32 7, !"uwtable", i32 1}
!39 = !{i32 7, !"frame-pointer", i32 2}
!40 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!41 = distinct !DISubprogram(name: "init", scope: !42, file: !42, line: 45, type: !43, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!42 = !DIFile(filename: "./utils/include/test/boilerplate/reader_writer.h", directory: "/home/drc/git/huawei/libvsync", checksumkind: CSK_MD5, checksum: "f262509c44b3835afbb04f52ae7718b9")
!43 = !DISubroutineType(types: !44)
!44 = !{null}
!45 = !{}
!46 = !DILocation(line: 47, column: 1, scope: !41)
!47 = distinct !DISubprogram(name: "post", scope: !42, file: !42, line: 54, type: !43, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!48 = !DILocation(line: 56, column: 1, scope: !47)
!49 = distinct !DISubprogram(name: "check", scope: !42, file: !42, line: 72, type: !43, scopeLine: 73, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!50 = !DILocation(line: 74, column: 1, scope: !49)
!51 = distinct !DISubprogram(name: "writer_acquire", scope: !42, file: !42, line: 76, type: !52, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!52 = !DISubroutineType(types: !53)
!53 = !{null, !6}
!54 = !DILocalVariable(name: "tid", arg: 1, scope: !51, file: !42, line: 76, type: !6)
!55 = !DILocation(line: 0, scope: !51)
!56 = !DILocation(line: 79, column: 1, scope: !51)
!57 = distinct !DISubprogram(name: "writer_release", scope: !42, file: !42, line: 81, type: !52, scopeLine: 82, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!58 = !DILocalVariable(name: "tid", arg: 1, scope: !57, file: !42, line: 81, type: !6)
!59 = !DILocation(line: 0, scope: !57)
!60 = !DILocation(line: 84, column: 1, scope: !57)
!61 = distinct !DISubprogram(name: "reader_acquire", scope: !42, file: !42, line: 86, type: !52, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!62 = !DILocalVariable(name: "tid", arg: 1, scope: !61, file: !42, line: 86, type: !6)
!63 = !DILocation(line: 0, scope: !61)
!64 = !DILocation(line: 89, column: 1, scope: !61)
!65 = distinct !DISubprogram(name: "reader_release", scope: !42, file: !42, line: 91, type: !52, scopeLine: 92, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!66 = !DILocalVariable(name: "tid", arg: 1, scope: !65, file: !42, line: 91, type: !6)
!67 = !DILocation(line: 0, scope: !65)
!68 = !DILocation(line: 94, column: 1, scope: !65)
!69 = distinct !DISubprogram(name: "main", scope: !42, file: !42, line: 149, type: !70, scopeLine: 150, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!70 = !DISubroutineType(types: !71)
!71 = !{!72}
!72 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!73 = !DILocalVariable(name: "t", scope: !69, file: !42, line: 151, type: !74)
!74 = !DICompositeType(tag: DW_TAG_array_type, baseType: !75, size: 256, elements: !77)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !76, line: 27, baseType: !16)
!76 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!77 = !{!78}
!78 = !DISubrange(count: 4)
!79 = !DILocation(line: 151, column: 15, scope: !69)
!80 = !DILocation(line: 158, column: 5, scope: !69)
!81 = !DILocalVariable(name: "i", scope: !82, file: !42, line: 160, type: !13)
!82 = distinct !DILexicalBlock(scope: !69, file: !42, line: 160, column: 5)
!83 = !DILocation(line: 0, scope: !82)
!84 = !DILocation(line: 161, column: 31, scope: !85)
!85 = distinct !DILexicalBlock(scope: !86, file: !42, line: 160, column: 47)
!86 = distinct !DILexicalBlock(scope: !82, file: !42, line: 160, column: 5)
!87 = !DILocation(line: 161, column: 15, scope: !85)
!88 = !DILocalVariable(name: "i", scope: !89, file: !42, line: 164, type: !13)
!89 = distinct !DILexicalBlock(scope: !69, file: !42, line: 164, column: 5)
!90 = !DILocation(line: 0, scope: !89)
!91 = !DILocation(line: 165, column: 31, scope: !92)
!92 = distinct !DILexicalBlock(scope: !93, file: !42, line: 164, column: 54)
!93 = distinct !DILexicalBlock(scope: !89, file: !42, line: 164, column: 5)
!94 = !DILocation(line: 165, column: 15, scope: !92)
!95 = !DILocation(line: 168, column: 5, scope: !69)
!96 = !DILocalVariable(name: "i", scope: !97, file: !42, line: 170, type: !13)
!97 = distinct !DILexicalBlock(scope: !69, file: !42, line: 170, column: 5)
!98 = !DILocation(line: 0, scope: !97)
!99 = !DILocation(line: 171, column: 28, scope: !100)
!100 = distinct !DILexicalBlock(scope: !101, file: !42, line: 170, column: 47)
!101 = distinct !DILexicalBlock(scope: !97, file: !42, line: 170, column: 5)
!102 = !DILocation(line: 171, column: 15, scope: !100)
!103 = !DILocation(line: 179, column: 5, scope: !69)
!104 = !DILocation(line: 180, column: 5, scope: !69)
!105 = !DILocation(line: 182, column: 5, scope: !69)
!106 = distinct !DISubprogram(name: "writer", scope: !42, file: !42, line: 128, type: !107, scopeLine: 129, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!107 = !DISubroutineType(types: !108)
!108 = !{!5, !5}
!109 = !DILocalVariable(name: "arg", arg: 1, scope: !106, file: !42, line: 128, type: !5)
!110 = !DILocation(line: 0, scope: !106)
!111 = !DILocation(line: 130, column: 32, scope: !106)
!112 = !DILocation(line: 130, column: 21, scope: !106)
!113 = !DILocalVariable(name: "tid", scope: !106, file: !42, line: 130, type: !6)
!114 = !DILocation(line: 131, column: 5, scope: !106)
!115 = !DILocation(line: 132, column: 5, scope: !106)
!116 = !DILocation(line: 133, column: 5, scope: !106)
!117 = !DILocation(line: 134, column: 5, scope: !106)
!118 = distinct !DISubprogram(name: "reader", scope: !42, file: !42, line: 138, type: !107, scopeLine: 139, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!119 = !DILocalVariable(name: "arg", arg: 1, scope: !118, file: !42, line: 138, type: !5)
!120 = !DILocation(line: 0, scope: !118)
!121 = !DILocation(line: 140, column: 32, scope: !118)
!122 = !DILocation(line: 140, column: 21, scope: !118)
!123 = !DILocalVariable(name: "tid", scope: !118, file: !42, line: 140, type: !6)
!124 = !DILocation(line: 141, column: 5, scope: !118)
!125 = !DILocation(line: 142, column: 5, scope: !118)
!126 = !DILocation(line: 143, column: 5, scope: !118)
!127 = !DILocation(line: 145, column: 5, scope: !118)
!128 = distinct !DISubprogram(name: "fini", scope: !20, file: !20, line: 51, type: !43, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!129 = !DILocation(line: 53, column: 19, scope: !128)
!130 = !DILocalVariable(name: "x", scope: !128, file: !20, line: 53, type: !6)
!131 = !DILocation(line: 0, scope: !128)
!132 = !DILocation(line: 54, column: 19, scope: !128)
!133 = !DILocalVariable(name: "y", scope: !128, file: !20, line: 54, type: !6)
!134 = !DILocation(line: 55, column: 5, scope: !135)
!135 = distinct !DILexicalBlock(scope: !136, file: !20, line: 55, column: 5)
!136 = distinct !DILexicalBlock(scope: !128, file: !20, line: 55, column: 5)
!137 = !DILocation(line: 55, column: 5, scope: !136)
!138 = !DILocation(line: 56, column: 5, scope: !139)
!139 = distinct !DILexicalBlock(scope: !140, file: !20, line: 56, column: 5)
!140 = distinct !DILexicalBlock(scope: !128, file: !20, line: 56, column: 5)
!141 = !DILocation(line: 56, column: 5, scope: !140)
!142 = !DILocation(line: 58, column: 1, scope: !128)
!143 = distinct !DISubprogram(name: "writer_cs", scope: !20, file: !20, line: 22, type: !52, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!144 = !DILocalVariable(name: "tid", arg: 1, scope: !143, file: !20, line: 22, type: !6)
!145 = !DILocation(line: 0, scope: !143)
!146 = !DILocation(line: 24, column: 5, scope: !143)
!147 = !DILocation(line: 25, column: 11, scope: !143)
!148 = !DILocation(line: 26, column: 11, scope: !143)
!149 = !DILocation(line: 27, column: 5, scope: !143)
!150 = !DILocation(line: 29, column: 1, scope: !143)
!151 = distinct !DISubprogram(name: "seqlock_acquire", scope: !24, file: !24, line: 81, type: !152, scopeLine: 82, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!152 = !DISubroutineType(types: !153)
!153 = !{null, !154}
!154 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!155 = !DILocalVariable(name: "seq", arg: 1, scope: !151, file: !24, line: 81, type: !154)
!156 = !DILocation(line: 0, scope: !151)
!157 = !DILocalVariable(name: "count", scope: !151, file: !24, line: 83, type: !158)
!158 = !DIDerivedType(tag: DW_TAG_typedef, name: "seqvalue_t", file: !24, line: 28, baseType: !6)
!159 = !DILocalVariable(name: "o_count", scope: !151, file: !24, line: 84, type: !158)
!160 = !DILocation(line: 86, column: 5, scope: !151)
!161 = !DILocation(line: 88, column: 17, scope: !162)
!162 = distinct !DILexicalBlock(scope: !151, file: !24, line: 86, column: 8)
!163 = !DILocation(line: 91, column: 47, scope: !162)
!164 = !DILocation(line: 91, column: 70, scope: !162)
!165 = !DILocation(line: 91, column: 19, scope: !162)
!166 = !DILocation(line: 94, column: 21, scope: !167)
!167 = distinct !DILexicalBlock(scope: !162, file: !24, line: 94, column: 13)
!168 = !DILocation(line: 94, column: 13, scope: !162)
!169 = distinct !{!169, !160, !170}
!170 = !DILocation(line: 97, column: 18, scope: !151)
!171 = !DILocation(line: 99, column: 5, scope: !151)
!172 = !DILocation(line: 100, column: 1, scope: !151)
!173 = distinct !DISubprogram(name: "seqlock_release", scope: !24, file: !24, line: 113, type: !152, scopeLine: 114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!174 = !DILocalVariable(name: "seq", arg: 1, scope: !173, file: !24, line: 113, type: !154)
!175 = !DILocation(line: 0, scope: !173)
!176 = !DILocation(line: 117, column: 51, scope: !173)
!177 = !DILocation(line: 117, column: 26, scope: !173)
!178 = !DILocalVariable(name: "cur_val", scope: !173, file: !24, line: 117, type: !158)
!179 = !DILocation(line: 118, column: 5, scope: !180)
!180 = distinct !DILexicalBlock(scope: !181, file: !24, line: 118, column: 5)
!181 = distinct !DILexicalBlock(scope: !173, file: !24, line: 118, column: 5)
!182 = !DILocation(line: 118, column: 5, scope: !181)
!183 = !DILocation(line: 119, column: 49, scope: !173)
!184 = !DILocation(line: 119, column: 5, scope: !173)
!185 = !DILocation(line: 122, column: 1, scope: !173)
!186 = distinct !DISubprogram(name: "reader_cs", scope: !20, file: !20, line: 32, type: !52, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!187 = !DILocalVariable(name: "tid", arg: 1, scope: !186, file: !20, line: 32, type: !6)
!188 = !DILocation(line: 0, scope: !186)
!189 = !DILocalVariable(name: "a", scope: !186, file: !20, line: 34, type: !6)
!190 = !DILocalVariable(name: "b", scope: !186, file: !20, line: 35, type: !6)
!191 = !DILocalVariable(name: "s", scope: !186, file: !20, line: 36, type: !158)
!192 = !DILocation(line: 38, column: 5, scope: !186)
!193 = !DILocation(line: 39, column: 13, scope: !194)
!194 = distinct !DILexicalBlock(scope: !186, file: !20, line: 38, column: 14)
!195 = !DILocation(line: 40, column: 13, scope: !194)
!196 = !DILocation(line: 41, column: 13, scope: !194)
!197 = !DILocation(line: 43, column: 5, scope: !186)
!198 = !DILocation(line: 42, column: 5, scope: !194)
!199 = distinct !{!199, !192, !197, !200}
!200 = !{!"llvm.loop.mustprogress"}
!201 = !DILocation(line: 45, column: 5, scope: !202)
!202 = distinct !DILexicalBlock(scope: !203, file: !20, line: 45, column: 5)
!203 = distinct !DILexicalBlock(scope: !186, file: !20, line: 45, column: 5)
!204 = !DILocation(line: 45, column: 5, scope: !203)
!205 = !DILocation(line: 46, column: 5, scope: !206)
!206 = distinct !DILexicalBlock(scope: !207, file: !20, line: 46, column: 5)
!207 = distinct !DILexicalBlock(scope: !186, file: !20, line: 46, column: 5)
!208 = !DILocation(line: 46, column: 5, scope: !207)
!209 = !DILocation(line: 48, column: 1, scope: !186)
!210 = distinct !DISubprogram(name: "seqlock_rbegin", scope: !24, file: !24, line: 137, type: !211, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!211 = !DISubroutineType(types: !212)
!212 = !{!158, !154}
!213 = !DILocalVariable(name: "seq", arg: 1, scope: !210, file: !24, line: 137, type: !154)
!214 = !DILocation(line: 0, scope: !210)
!215 = !DILocation(line: 139, column: 12, scope: !210)
!216 = !DILocation(line: 139, column: 5, scope: !210)
!217 = distinct !DISubprogram(name: "seqlock_rend", scope: !24, file: !24, line: 154, type: !218, scopeLine: 155, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!218 = !DISubroutineType(types: !219)
!219 = !{!220, !154, !158}
!220 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !7, line: 44, baseType: !221)
!221 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!222 = !DILocalVariable(name: "seq", arg: 1, scope: !217, file: !24, line: 154, type: !154)
!223 = !DILocation(line: 0, scope: !217)
!224 = !DILocalVariable(name: "sv", arg: 2, scope: !217, file: !24, line: 154, type: !158)
!225 = !DILocation(line: 156, column: 5, scope: !226)
!226 = distinct !DILexicalBlock(scope: !227, file: !24, line: 156, column: 5)
!227 = distinct !DILexicalBlock(scope: !217, file: !24, line: 156, column: 5)
!228 = !DILocation(line: 156, column: 5, scope: !227)
!229 = !DILocation(line: 157, column: 5, scope: !217)
!230 = !DILocation(line: 160, column: 37, scope: !217)
!231 = !DILocation(line: 160, column: 12, scope: !217)
!232 = !DILocation(line: 160, column: 47, scope: !217)
!233 = !DILocation(line: 160, column: 5, scope: !217)
!234 = distinct !DISubprogram(name: "_seqlock_await_even", scope: !24, file: !24, line: 48, type: !211, scopeLine: 49, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!235 = !DILocalVariable(name: "seq", arg: 1, scope: !234, file: !24, line: 48, type: !154)
!236 = !DILocation(line: 0, scope: !234)
!237 = !DILocation(line: 50, column: 49, scope: !234)
!238 = !DILocation(line: 50, column: 24, scope: !234)
!239 = !DILocalVariable(name: "count", scope: !234, file: !24, line: 50, type: !158)
!240 = !DILocation(line: 51, column: 5, scope: !234)
!241 = !DILocation(line: 51, column: 12, scope: !234)
!242 = !DILocation(line: 52, column: 17, scope: !243)
!243 = distinct !DILexicalBlock(scope: !234, file: !24, line: 51, column: 28)
!244 = distinct !{!244, !240, !245, !200}
!245 = !DILocation(line: 53, column: 5, scope: !234)
!246 = !DILocation(line: 54, column: 5, scope: !247)
!247 = distinct !DILexicalBlock(scope: !248, file: !24, line: 54, column: 5)
!248 = distinct !DILexicalBlock(scope: !234, file: !24, line: 54, column: 5)
!249 = !DILocation(line: 54, column: 5, scope: !248)
!250 = !DILocation(line: 55, column: 5, scope: !234)
!251 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !252, file: !252, line: 1101, type: !253, scopeLine: 1102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!252 = !DIFile(filename: "./atomics/include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/huawei/libvsync", checksumkind: CSK_MD5, checksum: "60977d0592113e8e1425223dd36a1df2")
!253 = !DISubroutineType(types: !254)
!254 = !{!6, !255, !6, !6}
!255 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!256 = !DILocalVariable(name: "a", arg: 1, scope: !251, file: !252, line: 1101, type: !255)
!257 = !DILocation(line: 0, scope: !251)
!258 = !DILocalVariable(name: "e", arg: 2, scope: !251, file: !252, line: 1101, type: !6)
!259 = !DILocalVariable(name: "v", arg: 3, scope: !251, file: !252, line: 1101, type: !6)
!260 = !DILocalVariable(name: "exp", scope: !251, file: !252, line: 1103, type: !6)
!261 = !DILocation(line: 1104, column: 5, scope: !251)
!262 = !{i64 2147951422}
!263 = !DILocation(line: 1105, column: 37, scope: !251)
!264 = !DILocation(line: 1105, column: 5, scope: !251)
!265 = !DILocation(line: 1108, column: 5, scope: !251)
!266 = !{i64 2147951476}
!267 = !DILocation(line: 1109, column: 5, scope: !251)
!268 = distinct !DISubprogram(name: "vatomic_fence_rel", scope: !252, file: !252, line: 44, type: !43, scopeLine: 45, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!269 = !DILocation(line: 46, column: 5, scope: !268)
!270 = !{i64 2147945462}
!271 = !DILocation(line: 47, column: 5, scope: !268)
!272 = !DILocation(line: 48, column: 5, scope: !268)
!273 = !{i64 2147945508}
!274 = !DILocation(line: 49, column: 1, scope: !268)
!275 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !252, file: !252, line: 177, type: !276, scopeLine: 178, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!276 = !DISubroutineType(types: !277)
!277 = !{!6, !255}
!278 = !DILocalVariable(name: "a", arg: 1, scope: !275, file: !252, line: 177, type: !255)
!279 = !DILocation(line: 0, scope: !275)
!280 = !DILocation(line: 179, column: 5, scope: !275)
!281 = !{i64 2147946142}
!282 = !DILocation(line: 181, column: 13, scope: !275)
!283 = !DILocation(line: 180, column: 32, scope: !275)
!284 = !DILocalVariable(name: "tmp", scope: !275, file: !252, line: 180, type: !6)
!285 = !DILocation(line: 182, column: 5, scope: !275)
!286 = !{i64 2147946188}
!287 = !DILocation(line: 183, column: 5, scope: !275)
!288 = distinct !DISubprogram(name: "vatomic32_await_neq_acq", scope: !289, file: !289, line: 4252, type: !290, scopeLine: 4253, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!289 = !DIFile(filename: "./atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/huawei/libvsync", checksumkind: CSK_MD5, checksum: "87126baaaf19831ce6548cc49ec0f04b")
!290 = !DISubroutineType(types: !291)
!291 = !{!6, !255, !6}
!292 = !DILocalVariable(name: "a", arg: 1, scope: !288, file: !289, line: 4252, type: !255)
!293 = !DILocation(line: 0, scope: !288)
!294 = !DILocalVariable(name: "c", arg: 2, scope: !288, file: !289, line: 4252, type: !6)
!295 = !DILocalVariable(name: "cur", scope: !288, file: !289, line: 4254, type: !6)
!296 = !DILocation(line: 4255, column: 5, scope: !288)
!297 = distinct !{!297, !296, !298, !200}
!298 = !DILocation(line: 4257, column: 5, scope: !288)
!299 = !DILocation(line: 4258, column: 5, scope: !288)
!300 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !252, file: !252, line: 192, type: !276, scopeLine: 193, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!301 = !DILocalVariable(name: "a", arg: 1, scope: !300, file: !252, line: 192, type: !255)
!302 = !DILocation(line: 0, scope: !300)
!303 = !DILocation(line: 194, column: 5, scope: !300)
!304 = !{i64 2147946226}
!305 = !DILocation(line: 196, column: 13, scope: !300)
!306 = !DILocation(line: 195, column: 32, scope: !300)
!307 = !DILocalVariable(name: "tmp", scope: !300, file: !252, line: 195, type: !6)
!308 = !DILocation(line: 197, column: 5, scope: !300)
!309 = !{i64 2147946272}
!310 = !DILocation(line: 198, column: 5, scope: !300)
!311 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !252, file: !252, line: 437, type: !312, scopeLine: 438, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!312 = !DISubroutineType(types: !313)
!313 = !{null, !255, !6}
!314 = !DILocalVariable(name: "a", arg: 1, scope: !311, file: !252, line: 437, type: !255)
!315 = !DILocation(line: 0, scope: !311)
!316 = !DILocalVariable(name: "v", arg: 2, scope: !311, file: !252, line: 437, type: !6)
!317 = !DILocation(line: 439, column: 5, scope: !311)
!318 = !{i64 2147947654}
!319 = !DILocation(line: 440, column: 26, scope: !311)
!320 = !DILocation(line: 440, column: 5, scope: !311)
!321 = !DILocation(line: 441, column: 5, scope: !311)
!322 = !{i64 2147947700}
!323 = !DILocation(line: 442, column: 1, scope: !311)
!324 = distinct !DISubprogram(name: "vatomic_fence_acq", scope: !252, file: !252, line: 31, type: !43, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!325 = !DILocation(line: 33, column: 5, scope: !324)
!326 = !{i64 2147945378}
!327 = !DILocation(line: 34, column: 5, scope: !324)
!328 = !DILocation(line: 35, column: 5, scope: !324)
!329 = !{i64 2147945424}
!330 = !DILocation(line: 36, column: 1, scope: !324)
