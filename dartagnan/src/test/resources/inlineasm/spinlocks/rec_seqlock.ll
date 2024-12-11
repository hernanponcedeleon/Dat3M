; ModuleID = '/home/stefano/huawei/libvsync/spinlock/test/rec_seqlock.c'
source_filename = "/home/stefano/huawei/libvsync/spinlock/test/rec_seqlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.rec_seqlock_s = type { %struct.seqlock_s, %struct.vatomic32_s, i32 }
%struct.seqlock_s = type { %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@lock = dso_local global %struct.rec_seqlock_s zeroinitializer, align 4, !dbg !0
@g_cs_x = dso_local global i32 0, align 4, !dbg !18
@g_cs_y = dso_local global i32 0, align 4, !dbg !21
@.str = private unnamed_addr constant [7 x i8] c"a == b\00", align 1
@.str.1 = private unnamed_addr constant [58 x i8] c"/home/stefano/huawei/libvsync/spinlock/test/rec_seqlock.c\00", align 1
@__PRETTY_FUNCTION__.reader_cs = private unnamed_addr constant [26 x i8] c"void reader_cs(vuint32_t)\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"(s % 2) == 0\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"x == y\00", align 1
@__PRETTY_FUNCTION__.fini = private unnamed_addr constant [16 x i8] c"void fini(void)\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"x == 2\00", align 1
@.str.5 = private unnamed_addr constant [23 x i8] c"this value is reserved\00", align 1
@.str.6 = private unnamed_addr constant [48 x i8] c"id != (4294967295U) && \22this value is reserved\22\00", align 1
@.str.7 = private unnamed_addr constant [76 x i8] c"/home/stefano/huawei/libvsync/spinlock/include/vsync/spinlock/rec_seqlock.h\00", align 1
@__PRETTY_FUNCTION__.rec_seqlock_acquire = private unnamed_addr constant [53 x i8] c"void rec_seqlock_acquire(rec_seqlock_t *, vuint32_t)\00", align 1
@.str.8 = private unnamed_addr constant [21 x i8] c"(((count)&1U) == 0U)\00", align 1
@.str.9 = private unnamed_addr constant [72 x i8] c"/home/stefano/huawei/libvsync/spinlock/include/vsync/spinlock/seqlock.h\00", align 1
@__PRETTY_FUNCTION__._seqlock_await_even = private unnamed_addr constant [44 x i8] c"seqvalue_t _seqlock_await_even(seqlock_t *)\00", align 1
@.str.10 = private unnamed_addr constant [27 x i8] c"(cur_val & 0x1UL) == 0x1UL\00", align 1
@__PRETTY_FUNCTION__.seqlock_release = private unnamed_addr constant [34 x i8] c"void seqlock_release(seqlock_t *)\00", align 1
@.str.11 = private unnamed_addr constant [18 x i8] c"(((sv)&1U) == 0U)\00", align 1
@__PRETTY_FUNCTION__.seqlock_rend = private unnamed_addr constant [46 x i8] c"vbool_t seqlock_rend(seqlock_t *, seqvalue_t)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !48 {
  ret void, !dbg !53
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !54 {
  ret void, !dbg !55
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_acquire(i32 noundef %0) #0 !dbg !56 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !59, metadata !DIExpression()), !dbg !60
  br label %3, !dbg !61

3:                                                ; preds = %1
  br label %4, !dbg !62

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !64
  br label %6, !dbg !64

6:                                                ; preds = %4
  br label %7, !dbg !66

7:                                                ; preds = %6
  br label %8, !dbg !64

8:                                                ; preds = %7
  br label %9, !dbg !62

9:                                                ; preds = %8
  ret void, !dbg !68
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_release(i32 noundef %0) #0 !dbg !69 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !70, metadata !DIExpression()), !dbg !71
  br label %3, !dbg !72

3:                                                ; preds = %1
  br label %4, !dbg !73

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !75
  br label %6, !dbg !75

6:                                                ; preds = %4
  br label %7, !dbg !77

7:                                                ; preds = %6
  br label %8, !dbg !75

8:                                                ; preds = %7
  br label %9, !dbg !73

9:                                                ; preds = %8
  ret void, !dbg !79
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_acquire(i32 noundef %0) #0 !dbg !80 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !81, metadata !DIExpression()), !dbg !82
  br label %3, !dbg !83

3:                                                ; preds = %1
  br label %4, !dbg !84

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !86
  br label %6, !dbg !86

6:                                                ; preds = %4
  br label %7, !dbg !88

7:                                                ; preds = %6
  br label %8, !dbg !86

8:                                                ; preds = %7
  br label %9, !dbg !84

9:                                                ; preds = %8
  ret void, !dbg !90
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_release(i32 noundef %0) #0 !dbg !91 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !92, metadata !DIExpression()), !dbg !93
  br label %3, !dbg !94

3:                                                ; preds = %1
  br label %4, !dbg !95

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !97
  br label %6, !dbg !97

6:                                                ; preds = %4
  br label %7, !dbg !99

7:                                                ; preds = %6
  br label %8, !dbg !97

8:                                                ; preds = %7
  br label %9, !dbg !95

9:                                                ; preds = %8
  ret void, !dbg !101
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !102 {
  %1 = alloca i32, align 4
  %2 = alloca [4 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [4 x i64]* %2, metadata !106, metadata !DIExpression()), !dbg !112
  call void @init(), !dbg !113
  call void @llvm.dbg.declare(metadata i64* %3, metadata !114, metadata !DIExpression()), !dbg !116
  store i64 0, i64* %3, align 8, !dbg !116
  br label %6, !dbg !117

6:                                                ; preds = %15, %0
  %7 = load i64, i64* %3, align 8, !dbg !118
  %8 = icmp ult i64 %7, 2, !dbg !120
  br i1 %8, label %9, label %18, !dbg !121

9:                                                ; preds = %6
  %10 = load i64, i64* %3, align 8, !dbg !122
  %11 = getelementptr inbounds [4 x i64], [4 x i64]* %2, i64 0, i64 %10, !dbg !124
  %12 = load i64, i64* %3, align 8, !dbg !125
  %13 = inttoptr i64 %12 to i8*, !dbg !126
  %14 = call i32 @pthread_create(i64* noundef %11, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef %13) #5, !dbg !127
  br label %15, !dbg !128

15:                                               ; preds = %9
  %16 = load i64, i64* %3, align 8, !dbg !129
  %17 = add i64 %16, 1, !dbg !129
  store i64 %17, i64* %3, align 8, !dbg !129
  br label %6, !dbg !130, !llvm.loop !131

18:                                               ; preds = %6
  call void @llvm.dbg.declare(metadata i64* %4, metadata !134, metadata !DIExpression()), !dbg !136
  store i64 2, i64* %4, align 8, !dbg !136
  br label %19, !dbg !137

19:                                               ; preds = %28, %18
  %20 = load i64, i64* %4, align 8, !dbg !138
  %21 = icmp ult i64 %20, 4, !dbg !140
  br i1 %21, label %22, label %31, !dbg !141

22:                                               ; preds = %19
  %23 = load i64, i64* %4, align 8, !dbg !142
  %24 = getelementptr inbounds [4 x i64], [4 x i64]* %2, i64 0, i64 %23, !dbg !144
  %25 = load i64, i64* %4, align 8, !dbg !145
  %26 = inttoptr i64 %25 to i8*, !dbg !146
  %27 = call i32 @pthread_create(i64* noundef %24, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef %26) #5, !dbg !147
  br label %28, !dbg !148

28:                                               ; preds = %22
  %29 = load i64, i64* %4, align 8, !dbg !149
  %30 = add i64 %29, 1, !dbg !149
  store i64 %30, i64* %4, align 8, !dbg !149
  br label %19, !dbg !150, !llvm.loop !151

31:                                               ; preds = %19
  call void @post(), !dbg !153
  call void @llvm.dbg.declare(metadata i64* %5, metadata !154, metadata !DIExpression()), !dbg !156
  store i64 0, i64* %5, align 8, !dbg !156
  br label %32, !dbg !157

32:                                               ; preds = %40, %31
  %33 = load i64, i64* %5, align 8, !dbg !158
  %34 = icmp ult i64 %33, 4, !dbg !160
  br i1 %34, label %35, label %43, !dbg !161

35:                                               ; preds = %32
  %36 = load i64, i64* %5, align 8, !dbg !162
  %37 = getelementptr inbounds [4 x i64], [4 x i64]* %2, i64 0, i64 %36, !dbg !164
  %38 = load i64, i64* %37, align 8, !dbg !164
  %39 = call i32 @pthread_join(i64 noundef %38, i8** noundef null), !dbg !165
  br label %40, !dbg !166

40:                                               ; preds = %35
  %41 = load i64, i64* %5, align 8, !dbg !167
  %42 = add i64 %41, 1, !dbg !167
  store i64 %42, i64* %5, align 8, !dbg !167
  br label %32, !dbg !168, !llvm.loop !169

43:                                               ; preds = %32
  call void @check(), !dbg !171
  call void @fini(), !dbg !172
  ret i32 0, !dbg !173
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !174 {
  call void @rec_seqlock_init(%struct.rec_seqlock_s* noundef @lock), !dbg !175
  ret void, !dbg !176
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal i8* @writer(i8* noundef %0) #0 !dbg !177 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !180, metadata !DIExpression()), !dbg !181
  call void @llvm.dbg.declare(metadata i32* %3, metadata !182, metadata !DIExpression()), !dbg !183
  %4 = load i8*, i8** %2, align 8, !dbg !184
  %5 = ptrtoint i8* %4 to i64, !dbg !185
  %6 = trunc i64 %5 to i32, !dbg !186
  store i32 %6, i32* %3, align 4, !dbg !183
  %7 = load i32, i32* %3, align 4, !dbg !187
  call void @writer_acquire(i32 noundef %7), !dbg !188
  %8 = load i32, i32* %3, align 4, !dbg !189
  call void @writer_cs(i32 noundef %8), !dbg !190
  %9 = load i32, i32* %3, align 4, !dbg !191
  call void @writer_release(i32 noundef %9), !dbg !192
  ret i8* null, !dbg !193
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @reader(i8* noundef %0) #0 !dbg !194 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !195, metadata !DIExpression()), !dbg !196
  call void @llvm.dbg.declare(metadata i32* %3, metadata !197, metadata !DIExpression()), !dbg !198
  %4 = load i8*, i8** %2, align 8, !dbg !199
  %5 = ptrtoint i8* %4 to i64, !dbg !200
  %6 = trunc i64 %5 to i32, !dbg !201
  store i32 %6, i32* %3, align 4, !dbg !198
  %7 = load i32, i32* %3, align 4, !dbg !202
  call void @reader_acquire(i32 noundef %7), !dbg !203
  %8 = load i32, i32* %3, align 4, !dbg !204
  call void @reader_cs(i32 noundef %8), !dbg !205
  %9 = load i32, i32* %3, align 4, !dbg !206
  call void @reader_release(i32 noundef %9), !dbg !207
  ret i8* null, !dbg !208
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !209 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %1, metadata !210, metadata !DIExpression()), !dbg !211
  %3 = load i32, i32* @g_cs_x, align 4, !dbg !212
  store i32 %3, i32* %1, align 4, !dbg !211
  call void @llvm.dbg.declare(metadata i32* %2, metadata !213, metadata !DIExpression()), !dbg !214
  %4 = load i32, i32* @g_cs_y, align 4, !dbg !215
  store i32 %4, i32* %2, align 4, !dbg !214
  %5 = load i32, i32* %1, align 4, !dbg !216
  %6 = load i32, i32* %2, align 4, !dbg !216
  %7 = icmp eq i32 %5, %6, !dbg !216
  br i1 %7, label %8, label %9, !dbg !219

8:                                                ; preds = %0
  br label %10, !dbg !219

9:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([58 x i8], [58 x i8]* @.str.1, i64 0, i64 0), i32 noundef 73, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.fini, i64 0, i64 0)) #6, !dbg !216
  unreachable, !dbg !216

10:                                               ; preds = %8
  %11 = load i32, i32* %1, align 4, !dbg !220
  %12 = icmp eq i32 %11, 2, !dbg !220
  br i1 %12, label %13, label %14, !dbg !223

13:                                               ; preds = %10
  br label %15, !dbg !223

14:                                               ; preds = %10
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([58 x i8], [58 x i8]* @.str.1, i64 0, i64 0), i32 noundef 74, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.fini, i64 0, i64 0)) #6, !dbg !220
  unreachable, !dbg !220

15:                                               ; preds = %13
  br label %16, !dbg !224

16:                                               ; preds = %15
  br label %17, !dbg !225

17:                                               ; preds = %16
  %18 = load i32, i32* %1, align 4, !dbg !227
  br label %19, !dbg !227

19:                                               ; preds = %17
  %20 = load i32, i32* %2, align 4, !dbg !229
  br label %21, !dbg !229

21:                                               ; preds = %19
  br label %22, !dbg !231

22:                                               ; preds = %21
  br label %23, !dbg !229

23:                                               ; preds = %22
  br label %24, !dbg !227

24:                                               ; preds = %23
  br label %25, !dbg !225

25:                                               ; preds = %24
  ret void, !dbg !233
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_cs(i32 noundef %0) #0 !dbg !234 {
  %2 = alloca i32, align 4
  %3 = alloca i64, align 8
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !235, metadata !DIExpression()), !dbg !236
  call void @llvm.dbg.declare(metadata i64* %3, metadata !237, metadata !DIExpression()), !dbg !241
  store i64 0, i64* %3, align 8, !dbg !241
  store i64 0, i64* %3, align 8, !dbg !242
  br label %4, !dbg !244

4:                                                ; preds = %9, %1
  %5 = load i64, i64* %3, align 8, !dbg !245
  %6 = icmp ult i64 %5, 2, !dbg !247
  br i1 %6, label %7, label %12, !dbg !248

7:                                                ; preds = %4
  %8 = load i32, i32* %2, align 4, !dbg !249
  call void @rec_seqlock_acquire(%struct.rec_seqlock_s* noundef @lock, i32 noundef %8), !dbg !251
  br label %9, !dbg !252

9:                                                ; preds = %7
  %10 = load i64, i64* %3, align 8, !dbg !253
  %11 = add i64 %10, 1, !dbg !253
  store i64 %11, i64* %3, align 8, !dbg !253
  br label %4, !dbg !254, !llvm.loop !255

12:                                               ; preds = %4
  %13 = load i32, i32* @g_cs_x, align 4, !dbg !257
  %14 = add i32 %13, 1, !dbg !257
  store i32 %14, i32* @g_cs_x, align 4, !dbg !257
  %15 = load i32, i32* @g_cs_y, align 4, !dbg !258
  %16 = add i32 %15, 1, !dbg !258
  store i32 %16, i32* @g_cs_y, align 4, !dbg !258
  store i64 0, i64* %3, align 8, !dbg !259
  br label %17, !dbg !261

17:                                               ; preds = %21, %12
  %18 = load i64, i64* %3, align 8, !dbg !262
  %19 = icmp ult i64 %18, 2, !dbg !264
  br i1 %19, label %20, label %24, !dbg !265

20:                                               ; preds = %17
  call void @rec_seqlock_release(%struct.rec_seqlock_s* noundef @lock), !dbg !266
  br label %21, !dbg !268

21:                                               ; preds = %20
  %22 = load i64, i64* %3, align 8, !dbg !269
  %23 = add i64 %22, 1, !dbg !269
  store i64 %23, i64* %3, align 8, !dbg !269
  br label %17, !dbg !270, !llvm.loop !271

24:                                               ; preds = %17
  ret void, !dbg !273
}

; Function Attrs: noinline nounwind uwtable
define internal void @rec_seqlock_acquire(%struct.rec_seqlock_s* noundef %0, i32 noundef %1) #0 !dbg !274 {
  %3 = alloca %struct.rec_seqlock_s*, align 8
  %4 = alloca i32, align 4
  store %struct.rec_seqlock_s* %0, %struct.rec_seqlock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.rec_seqlock_s** %3, metadata !278, metadata !DIExpression()), !dbg !279
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !280, metadata !DIExpression()), !dbg !279
  %5 = load i32, i32* %4, align 4, !dbg !281
  %6 = icmp ne i32 %5, -1, !dbg !281
  br i1 %6, label %7, label %9, !dbg !281

7:                                                ; preds = %2
  br i1 true, label %8, label %9, !dbg !284

8:                                                ; preds = %7
  br label %10, !dbg !284

9:                                                ; preds = %7, %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @.str.7, i64 0, i64 0), i32 noundef 33, i8* noundef getelementptr inbounds ([53 x i8], [53 x i8]* @__PRETTY_FUNCTION__.rec_seqlock_acquire, i64 0, i64 0)) #6, !dbg !281
  unreachable, !dbg !281

10:                                               ; preds = %8
  %11 = load %struct.rec_seqlock_s*, %struct.rec_seqlock_s** %3, align 8, !dbg !285
  %12 = getelementptr inbounds %struct.rec_seqlock_s, %struct.rec_seqlock_s* %11, i32 0, i32 1, !dbg !285
  %13 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %12), !dbg !285
  %14 = load i32, i32* %4, align 4, !dbg !285
  %15 = icmp eq i32 %13, %14, !dbg !285
  br i1 %15, label %16, label %21, !dbg !279

16:                                               ; preds = %10
  %17 = load %struct.rec_seqlock_s*, %struct.rec_seqlock_s** %3, align 8, !dbg !287
  %18 = getelementptr inbounds %struct.rec_seqlock_s, %struct.rec_seqlock_s* %17, i32 0, i32 2, !dbg !287
  %19 = load i32, i32* %18, align 4, !dbg !287
  %20 = add i32 %19, 1, !dbg !287
  store i32 %20, i32* %18, align 4, !dbg !287
  br label %27, !dbg !287

21:                                               ; preds = %10
  %22 = load %struct.rec_seqlock_s*, %struct.rec_seqlock_s** %3, align 8, !dbg !279
  %23 = getelementptr inbounds %struct.rec_seqlock_s, %struct.rec_seqlock_s* %22, i32 0, i32 0, !dbg !279
  call void @seqlock_acquire(%struct.seqlock_s* noundef %23), !dbg !279
  %24 = load %struct.rec_seqlock_s*, %struct.rec_seqlock_s** %3, align 8, !dbg !279
  %25 = getelementptr inbounds %struct.rec_seqlock_s, %struct.rec_seqlock_s* %24, i32 0, i32 1, !dbg !279
  %26 = load i32, i32* %4, align 4, !dbg !279
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %25, i32 noundef %26), !dbg !279
  br label %27, !dbg !279

27:                                               ; preds = %21, %16
  ret void, !dbg !279
}

; Function Attrs: noinline nounwind uwtable
define internal void @rec_seqlock_release(%struct.rec_seqlock_s* noundef %0) #0 !dbg !289 {
  %2 = alloca %struct.rec_seqlock_s*, align 8
  store %struct.rec_seqlock_s* %0, %struct.rec_seqlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rec_seqlock_s** %2, metadata !292, metadata !DIExpression()), !dbg !293
  %3 = load %struct.rec_seqlock_s*, %struct.rec_seqlock_s** %2, align 8, !dbg !294
  %4 = getelementptr inbounds %struct.rec_seqlock_s, %struct.rec_seqlock_s* %3, i32 0, i32 2, !dbg !294
  %5 = load i32, i32* %4, align 4, !dbg !294
  %6 = icmp eq i32 %5, 0, !dbg !294
  br i1 %6, label %7, label %12, !dbg !293

7:                                                ; preds = %1
  %8 = load %struct.rec_seqlock_s*, %struct.rec_seqlock_s** %2, align 8, !dbg !296
  %9 = getelementptr inbounds %struct.rec_seqlock_s, %struct.rec_seqlock_s* %8, i32 0, i32 1, !dbg !296
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %9, i32 noundef -1), !dbg !296
  %10 = load %struct.rec_seqlock_s*, %struct.rec_seqlock_s** %2, align 8, !dbg !296
  %11 = getelementptr inbounds %struct.rec_seqlock_s, %struct.rec_seqlock_s* %10, i32 0, i32 0, !dbg !296
  call void @seqlock_release(%struct.seqlock_s* noundef %11), !dbg !296
  br label %17, !dbg !296

12:                                               ; preds = %1
  %13 = load %struct.rec_seqlock_s*, %struct.rec_seqlock_s** %2, align 8, !dbg !298
  %14 = getelementptr inbounds %struct.rec_seqlock_s, %struct.rec_seqlock_s* %13, i32 0, i32 2, !dbg !298
  %15 = load i32, i32* %14, align 4, !dbg !298
  %16 = add i32 %15, -1, !dbg !298
  store i32 %16, i32* %14, align 4, !dbg !298
  br label %17

17:                                               ; preds = %12, %7
  ret void, !dbg !293
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_cs(i32 noundef %0) #0 !dbg !300 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !301, metadata !DIExpression()), !dbg !302
  call void @llvm.dbg.declare(metadata i32* %3, metadata !303, metadata !DIExpression()), !dbg !304
  store i32 0, i32* %3, align 4, !dbg !304
  call void @llvm.dbg.declare(metadata i32* %4, metadata !305, metadata !DIExpression()), !dbg !306
  store i32 0, i32* %4, align 4, !dbg !306
  call void @llvm.dbg.declare(metadata i32* %5, metadata !307, metadata !DIExpression()), !dbg !309
  store i32 0, i32* %5, align 4, !dbg !309
  br label %6, !dbg !310

6:                                                ; preds = %10, %1
  %7 = call i32 @rec_seqlock_rbegin(%struct.rec_seqlock_s* noundef @lock), !dbg !311
  store i32 %7, i32* %5, align 4, !dbg !313
  %8 = load i32, i32* @g_cs_x, align 4, !dbg !314
  store i32 %8, i32* %3, align 4, !dbg !315
  %9 = load i32, i32* @g_cs_y, align 4, !dbg !316
  store i32 %9, i32* %4, align 4, !dbg !317
  br label %10, !dbg !318

10:                                               ; preds = %6
  %11 = load i32, i32* %5, align 4, !dbg !319
  %12 = call zeroext i1 @rec_seqlock_rend(%struct.rec_seqlock_s* noundef @lock, i32 noundef %11), !dbg !319
  %13 = xor i1 %12, true, !dbg !319
  br i1 %13, label %6, label %14, !dbg !318, !llvm.loop !320

14:                                               ; preds = %10
  %15 = load i32, i32* %3, align 4, !dbg !321
  %16 = load i32, i32* %4, align 4, !dbg !321
  %17 = icmp eq i32 %15, %16, !dbg !321
  br i1 %17, label %18, label %19, !dbg !324

18:                                               ; preds = %14
  br label %20, !dbg !324

19:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([58 x i8], [58 x i8]* @.str.1, i64 0, i64 0), i32 noundef 57, i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @__PRETTY_FUNCTION__.reader_cs, i64 0, i64 0)) #6, !dbg !321
  unreachable, !dbg !321

20:                                               ; preds = %18
  %21 = load i32, i32* %5, align 4, !dbg !325
  %22 = urem i32 %21, 2, !dbg !325
  %23 = icmp eq i32 %22, 0, !dbg !325
  br i1 %23, label %24, label %25, !dbg !328

24:                                               ; preds = %20
  br label %26, !dbg !328

25:                                               ; preds = %20
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([58 x i8], [58 x i8]* @.str.1, i64 0, i64 0), i32 noundef 58, i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @__PRETTY_FUNCTION__.reader_cs, i64 0, i64 0)) #6, !dbg !325
  unreachable, !dbg !325

26:                                               ; preds = %24
  br label %27, !dbg !329

27:                                               ; preds = %26
  br label %28, !dbg !330

28:                                               ; preds = %27
  %29 = load i32, i32* %2, align 4, !dbg !332
  br label %30, !dbg !332

30:                                               ; preds = %28
  %31 = load i32, i32* %3, align 4, !dbg !334
  br label %32, !dbg !334

32:                                               ; preds = %30
  %33 = load i32, i32* %4, align 4, !dbg !336
  br label %34, !dbg !336

34:                                               ; preds = %32
  br label %35, !dbg !338

35:                                               ; preds = %34
  br label %36, !dbg !336

36:                                               ; preds = %35
  br label %37, !dbg !334

37:                                               ; preds = %36
  br label %38, !dbg !332

38:                                               ; preds = %37
  br label %39, !dbg !330

39:                                               ; preds = %38
  ret void, !dbg !340
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @rec_seqlock_rbegin(%struct.rec_seqlock_s* noundef %0) #0 !dbg !341 {
  %2 = alloca %struct.rec_seqlock_s*, align 8
  store %struct.rec_seqlock_s* %0, %struct.rec_seqlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rec_seqlock_s** %2, metadata !344, metadata !DIExpression()), !dbg !345
  %3 = load %struct.rec_seqlock_s*, %struct.rec_seqlock_s** %2, align 8, !dbg !346
  %4 = getelementptr inbounds %struct.rec_seqlock_s, %struct.rec_seqlock_s* %3, i32 0, i32 0, !dbg !347
  %5 = call i32 @seqlock_rbegin(%struct.seqlock_s* noundef %4), !dbg !348
  ret i32 %5, !dbg !349
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @rec_seqlock_rend(%struct.rec_seqlock_s* noundef %0, i32 noundef %1) #0 !dbg !350 {
  %3 = alloca %struct.rec_seqlock_s*, align 8
  %4 = alloca i32, align 4
  store %struct.rec_seqlock_s* %0, %struct.rec_seqlock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.rec_seqlock_s** %3, metadata !355, metadata !DIExpression()), !dbg !356
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !357, metadata !DIExpression()), !dbg !358
  %5 = load %struct.rec_seqlock_s*, %struct.rec_seqlock_s** %3, align 8, !dbg !359
  %6 = getelementptr inbounds %struct.rec_seqlock_s, %struct.rec_seqlock_s* %5, i32 0, i32 0, !dbg !360
  %7 = load i32, i32* %4, align 4, !dbg !361
  %8 = call zeroext i1 @seqlock_rend(%struct.seqlock_s* noundef %6, i32 noundef %7), !dbg !362
  ret i1 %8, !dbg !363
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @rec_seqlock_init(%struct.rec_seqlock_s* noundef %0) #0 !dbg !364 {
  %2 = alloca %struct.rec_seqlock_s*, align 8
  store %struct.rec_seqlock_s* %0, %struct.rec_seqlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rec_seqlock_s** %2, metadata !365, metadata !DIExpression()), !dbg !366
  %3 = load %struct.rec_seqlock_s*, %struct.rec_seqlock_s** %2, align 8, !dbg !366
  %4 = getelementptr inbounds %struct.rec_seqlock_s, %struct.rec_seqlock_s* %3, i32 0, i32 0, !dbg !366
  call void @seqlock_init(%struct.seqlock_s* noundef %4), !dbg !366
  %5 = load %struct.rec_seqlock_s*, %struct.rec_seqlock_s** %2, align 8, !dbg !366
  %6 = getelementptr inbounds %struct.rec_seqlock_s, %struct.rec_seqlock_s* %5, i32 0, i32 1, !dbg !366
  call void @vatomic32_init(%struct.vatomic32_s* noundef %6, i32 noundef -1), !dbg !366
  %7 = load %struct.rec_seqlock_s*, %struct.rec_seqlock_s** %2, align 8, !dbg !366
  %8 = getelementptr inbounds %struct.rec_seqlock_s, %struct.rec_seqlock_s* %7, i32 0, i32 2, !dbg !366
  store i32 0, i32* %8, align 4, !dbg !366
  ret void, !dbg !366
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !367 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !373, metadata !DIExpression()), !dbg !374
  call void @llvm.dbg.declare(metadata i32* %3, metadata !375, metadata !DIExpression()), !dbg !376
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !377
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !378
  %6 = load i32, i32* %5, align 4, !dbg !378
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #5, !dbg !379, !srcloc !380
  store i32 %7, i32* %3, align 4, !dbg !379
  %8 = load i32, i32* %3, align 4, !dbg !381
  ret i32 %8, !dbg !382
}

; Function Attrs: noinline nounwind uwtable
define internal void @seqlock_acquire(%struct.seqlock_s* noundef %0) #0 !dbg !383 {
  %2 = alloca %struct.seqlock_s*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %struct.seqlock_s* %0, %struct.seqlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.seqlock_s** %2, metadata !387, metadata !DIExpression()), !dbg !388
  call void @llvm.dbg.declare(metadata i32* %3, metadata !389, metadata !DIExpression()), !dbg !390
  store i32 0, i32* %3, align 4, !dbg !390
  call void @llvm.dbg.declare(metadata i32* %4, metadata !391, metadata !DIExpression()), !dbg !392
  store i32 0, i32* %4, align 4, !dbg !392
  br label %5, !dbg !393

5:                                                ; preds = %19, %1
  %6 = load %struct.seqlock_s*, %struct.seqlock_s** %2, align 8, !dbg !394
  %7 = call i32 @_seqlock_await_even(%struct.seqlock_s* noundef %6), !dbg !396
  store i32 %7, i32* %3, align 4, !dbg !397
  %8 = load %struct.seqlock_s*, %struct.seqlock_s** %2, align 8, !dbg !398
  %9 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %8, i32 0, i32 0, !dbg !399
  %10 = load i32, i32* %3, align 4, !dbg !400
  %11 = load i32, i32* %3, align 4, !dbg !401
  %12 = add i32 %11, 1, !dbg !402
  %13 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %9, i32 noundef %10, i32 noundef %12), !dbg !403
  store i32 %13, i32* %4, align 4, !dbg !404
  %14 = load i32, i32* %4, align 4, !dbg !405
  %15 = load i32, i32* %3, align 4, !dbg !407
  %16 = icmp eq i32 %14, %15, !dbg !408
  br i1 %16, label %17, label %18, !dbg !409

17:                                               ; preds = %5
  br label %20, !dbg !410

18:                                               ; preds = %5
  br label %19, !dbg !412

19:                                               ; preds = %18
  br i1 true, label %5, label %20, !dbg !412, !llvm.loop !413

20:                                               ; preds = %19, %17
  call void @vatomic_fence_rel(), !dbg !415
  ret void, !dbg !416
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !417 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !421, metadata !DIExpression()), !dbg !422
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !423, metadata !DIExpression()), !dbg !424
  %5 = load i32, i32* %4, align 4, !dbg !425
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !426
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !427
  %8 = load i32, i32* %7, align 4, !dbg !427
  call void asm sideeffect "str ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #5, !dbg !428, !srcloc !429
  ret void, !dbg !430
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @_seqlock_await_even(%struct.seqlock_s* noundef %0) #0 !dbg !431 {
  %2 = alloca %struct.seqlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.seqlock_s* %0, %struct.seqlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.seqlock_s** %2, metadata !434, metadata !DIExpression()), !dbg !435
  call void @llvm.dbg.declare(metadata i32* %3, metadata !436, metadata !DIExpression()), !dbg !437
  %4 = load %struct.seqlock_s*, %struct.seqlock_s** %2, align 8, !dbg !438
  %5 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %4, i32 0, i32 0, !dbg !439
  %6 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %5), !dbg !440
  store i32 %6, i32* %3, align 4, !dbg !437
  br label %7, !dbg !441

7:                                                ; preds = %11, %1
  %8 = load i32, i32* %3, align 4, !dbg !442
  %9 = and i32 %8, 1, !dbg !442
  %10 = icmp eq i32 %9, 1, !dbg !442
  br i1 %10, label %11, label %16, !dbg !441

11:                                               ; preds = %7
  %12 = load %struct.seqlock_s*, %struct.seqlock_s** %2, align 8, !dbg !443
  %13 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %12, i32 0, i32 0, !dbg !445
  %14 = load i32, i32* %3, align 4, !dbg !446
  %15 = call i32 @vatomic32_await_neq_acq(%struct.vatomic32_s* noundef %13, i32 noundef %14), !dbg !447
  store i32 %15, i32* %3, align 4, !dbg !448
  br label %7, !dbg !441, !llvm.loop !449

16:                                               ; preds = %7
  %17 = load i32, i32* %3, align 4, !dbg !451
  %18 = and i32 %17, 1, !dbg !451
  %19 = icmp eq i32 %18, 0, !dbg !451
  br i1 %19, label %20, label %21, !dbg !454

20:                                               ; preds = %16
  br label %22, !dbg !454

21:                                               ; preds = %16
  call void @__assert_fail(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.8, i64 0, i64 0), i8* noundef getelementptr inbounds ([72 x i8], [72 x i8]* @.str.9, i64 0, i64 0), i32 noundef 54, i8* noundef getelementptr inbounds ([44 x i8], [44 x i8]* @__PRETTY_FUNCTION__._seqlock_await_even, i64 0, i64 0)) #6, !dbg !451
  unreachable, !dbg !451

22:                                               ; preds = %20
  %23 = load i32, i32* %3, align 4, !dbg !455
  ret i32 %23, !dbg !456
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !457 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !461, metadata !DIExpression()), !dbg !462
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !463, metadata !DIExpression()), !dbg !464
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !465, metadata !DIExpression()), !dbg !466
  call void @llvm.dbg.declare(metadata i32* %7, metadata !467, metadata !DIExpression()), !dbg !468
  call void @llvm.dbg.declare(metadata i32* %8, metadata !469, metadata !DIExpression()), !dbg !470
  %9 = load i32, i32* %6, align 4, !dbg !471
  %10 = load i32, i32* %5, align 4, !dbg !472
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !473
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !474
  %13 = load i32, i32* %12, align 4, !dbg !474
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldaxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #5, !dbg !475, !srcloc !476
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !475
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !475
  store i32 %15, i32* %7, align 4, !dbg !475
  store i32 %16, i32* %8, align 4, !dbg !475
  %17 = load i32, i32* %7, align 4, !dbg !477
  ret i32 %17, !dbg !478
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic_fence_rel() #0 !dbg !479 {
  call void asm sideeffect "dmb ish", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !480, !srcloc !481
  ret void, !dbg !482
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !483 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !484, metadata !DIExpression()), !dbg !485
  call void @llvm.dbg.declare(metadata i32* %3, metadata !486, metadata !DIExpression()), !dbg !487
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !488
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !489
  %6 = load i32, i32* %5, align 4, !dbg !489
  %7 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #5, !dbg !490, !srcloc !491
  store i32 %7, i32* %3, align 4, !dbg !490
  %8 = load i32, i32* %3, align 4, !dbg !492
  ret i32 %8, !dbg !493
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_neq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !494 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !497, metadata !DIExpression()), !dbg !498
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !499, metadata !DIExpression()), !dbg !500
  call void @llvm.dbg.declare(metadata i32* %5, metadata !501, metadata !DIExpression()), !dbg !502
  %6 = load i32, i32* %4, align 4, !dbg !503
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !504
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !505
  %9 = load i32, i32* %8, align 4, !dbg !505
  %10 = call i32 asm sideeffect "1:\0Aldar ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.eq 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #5, !dbg !506, !srcloc !507
  store i32 %10, i32* %5, align 4, !dbg !506
  %11 = load i32, i32* %5, align 4, !dbg !508
  ret i32 %11, !dbg !509
}

; Function Attrs: noinline nounwind uwtable
define internal void @seqlock_release(%struct.seqlock_s* noundef %0) #0 !dbg !510 {
  %2 = alloca %struct.seqlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.seqlock_s* %0, %struct.seqlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.seqlock_s** %2, metadata !511, metadata !DIExpression()), !dbg !512
  call void @llvm.dbg.declare(metadata i32* %3, metadata !513, metadata !DIExpression()), !dbg !514
  %4 = load %struct.seqlock_s*, %struct.seqlock_s** %2, align 8, !dbg !515
  %5 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %4, i32 0, i32 0, !dbg !516
  %6 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %5), !dbg !517
  store i32 %6, i32* %3, align 4, !dbg !514
  %7 = load i32, i32* %3, align 4, !dbg !518
  %8 = zext i32 %7 to i64, !dbg !518
  %9 = and i64 %8, 1, !dbg !518
  %10 = icmp eq i64 %9, 1, !dbg !518
  br i1 %10, label %11, label %12, !dbg !521

11:                                               ; preds = %1
  br label %13, !dbg !521

12:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.10, i64 0, i64 0), i8* noundef getelementptr inbounds ([72 x i8], [72 x i8]* @.str.9, i64 0, i64 0), i32 noundef 118, i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @__PRETTY_FUNCTION__.seqlock_release, i64 0, i64 0)) #6, !dbg !518
  unreachable, !dbg !518

13:                                               ; preds = %11
  %14 = load %struct.seqlock_s*, %struct.seqlock_s** %2, align 8, !dbg !522
  %15 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %14, i32 0, i32 0, !dbg !523
  %16 = load i32, i32* %3, align 4, !dbg !524
  %17 = add i32 %16, 1, !dbg !525
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %15, i32 noundef %17), !dbg !526
  ret void, !dbg !527
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !528 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !529, metadata !DIExpression()), !dbg !530
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !531, metadata !DIExpression()), !dbg !532
  %5 = load i32, i32* %4, align 4, !dbg !533
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !534
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !535
  %8 = load i32, i32* %7, align 4, !dbg !535
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #5, !dbg !536, !srcloc !537
  ret void, !dbg !538
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @seqlock_rbegin(%struct.seqlock_s* noundef %0) #0 !dbg !539 {
  %2 = alloca %struct.seqlock_s*, align 8
  store %struct.seqlock_s* %0, %struct.seqlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.seqlock_s** %2, metadata !540, metadata !DIExpression()), !dbg !541
  %3 = load %struct.seqlock_s*, %struct.seqlock_s** %2, align 8, !dbg !542
  %4 = call i32 @_seqlock_await_even(%struct.seqlock_s* noundef %3), !dbg !543
  ret i32 %4, !dbg !544
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @seqlock_rend(%struct.seqlock_s* noundef %0, i32 noundef %1) #0 !dbg !545 {
  %3 = alloca %struct.seqlock_s*, align 8
  %4 = alloca i32, align 4
  store %struct.seqlock_s* %0, %struct.seqlock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.seqlock_s** %3, metadata !548, metadata !DIExpression()), !dbg !549
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !550, metadata !DIExpression()), !dbg !551
  %5 = load i32, i32* %4, align 4, !dbg !552
  %6 = and i32 %5, 1, !dbg !552
  %7 = icmp eq i32 %6, 0, !dbg !552
  br i1 %7, label %8, label %9, !dbg !555

8:                                                ; preds = %2
  br label %10, !dbg !555

9:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([72 x i8], [72 x i8]* @.str.9, i64 0, i64 0), i32 noundef 156, i8* noundef getelementptr inbounds ([46 x i8], [46 x i8]* @__PRETTY_FUNCTION__.seqlock_rend, i64 0, i64 0)) #6, !dbg !552
  unreachable, !dbg !552

10:                                               ; preds = %8
  call void @vatomic_fence_acq(), !dbg !556
  %11 = load %struct.seqlock_s*, %struct.seqlock_s** %3, align 8, !dbg !557
  %12 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %11, i32 0, i32 0, !dbg !558
  %13 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %12), !dbg !559
  %14 = load i32, i32* %4, align 4, !dbg !560
  %15 = icmp eq i32 %13, %14, !dbg !561
  ret i1 %15, !dbg !562
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic_fence_acq() #0 !dbg !563 {
  call void asm sideeffect "dmb ishld", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !564, !srcloc !565
  ret void, !dbg !566
}

; Function Attrs: noinline nounwind uwtable
define internal void @seqlock_init(%struct.seqlock_s* noundef %0) #0 !dbg !567 {
  %2 = alloca %struct.seqlock_s*, align 8
  store %struct.seqlock_s* %0, %struct.seqlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.seqlock_s** %2, metadata !568, metadata !DIExpression()), !dbg !569
  %3 = load %struct.seqlock_s*, %struct.seqlock_s** %2, align 8, !dbg !570
  %4 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %3, i32 0, i32 0, !dbg !571
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %4, i32 noundef 0), !dbg !572
  ret void, !dbg !573
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_init(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !574 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !576, metadata !DIExpression()), !dbg !577
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !578, metadata !DIExpression()), !dbg !579
  %5 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !580
  %6 = load i32, i32* %4, align 4, !dbg !581
  call void @vatomic32_write(%struct.vatomic32_s* noundef %5, i32 noundef %6), !dbg !582
  ret void, !dbg !583
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !584 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !585, metadata !DIExpression()), !dbg !586
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !587, metadata !DIExpression()), !dbg !588
  %5 = load i32, i32* %4, align 4, !dbg !589
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !590
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !591
  %8 = load i32, i32* %7, align 4, !dbg !591
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #5, !dbg !592, !srcloc !593
  ret void, !dbg !594
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!40, !41, !42, !43, !44, !45, !46}
!llvm.ident = !{!47}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !20, line: 22, type: !23, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/spinlock/test/rec_seqlock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "817cb961c42d2e1121024d8169fd60e4")
!4 = !{!5, !6, !13}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !7, line: 35, baseType: !8)
!7 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
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
!19 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !20, line: 24, type: !6, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "spinlock/test/rec_seqlock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "817cb961c42d2e1121024d8169fd60e4")
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !20, line: 25, type: !6, isLocal: false, isDefinition: true)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "rec_seqlock_t", file: !24, line: 32, baseType: !25)
!24 = !DIFile(filename: "spinlock/include/vsync/spinlock/rec_seqlock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "b8fe0b599827e8190bd796e30ba2c8b3")
!25 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "rec_seqlock_s", file: !24, line: 32, size: 96, elements: !26)
!26 = !{!27, !38, !39}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !25, file: !24, line: 32, baseType: !28, size: 32)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "seqlock_t", file: !29, line: 33, baseType: !30)
!29 = !DIFile(filename: "spinlock/include/vsync/spinlock/seqlock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "61d628e3ec24c302304f26d6bf3b3da0")
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "seqlock_s", file: !29, line: 30, size: 32, elements: !31)
!31 = !{!32}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "seqcount", scope: !30, file: !29, line: 32, baseType: !33, size: 32, align: 32)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !34, line: 34, baseType: !35)
!34 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !34, line: 32, size: 32, align: 32, elements: !36)
!36 = !{!37}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !35, file: !34, line: 33, baseType: !6, size: 32)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "owner", scope: !25, file: !24, line: 32, baseType: !33, size: 32, align: 32, offset: 32)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !25, file: !24, line: 32, baseType: !6, size: 32, offset: 64)
!40 = !{i32 7, !"Dwarf Version", i32 5}
!41 = !{i32 2, !"Debug Info Version", i32 3}
!42 = !{i32 1, !"wchar_size", i32 4}
!43 = !{i32 7, !"PIC Level", i32 2}
!44 = !{i32 7, !"PIE Level", i32 2}
!45 = !{i32 7, !"uwtable", i32 1}
!46 = !{i32 7, !"frame-pointer", i32 2}
!47 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!48 = distinct !DISubprogram(name: "post", scope: !49, file: !49, line: 63, type: !50, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!49 = !DIFile(filename: "utils/include/test/boilerplate/reader_writer.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4e1dc695be02c115383d13b32ef6a829")
!50 = !DISubroutineType(types: !51)
!51 = !{null}
!52 = !{}
!53 = !DILocation(line: 65, column: 1, scope: !48)
!54 = distinct !DISubprogram(name: "check", scope: !49, file: !49, line: 81, type: !50, scopeLine: 82, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!55 = !DILocation(line: 83, column: 1, scope: !54)
!56 = distinct !DISubprogram(name: "writer_acquire", scope: !49, file: !49, line: 85, type: !57, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!57 = !DISubroutineType(types: !58)
!58 = !{null, !6}
!59 = !DILocalVariable(name: "tid", arg: 1, scope: !56, file: !49, line: 85, type: !6)
!60 = !DILocation(line: 85, column: 26, scope: !56)
!61 = !DILocation(line: 87, column: 5, scope: !56)
!62 = !DILocation(line: 87, column: 5, scope: !63)
!63 = distinct !DILexicalBlock(scope: !56, file: !49, line: 87, column: 5)
!64 = !DILocation(line: 87, column: 5, scope: !65)
!65 = distinct !DILexicalBlock(scope: !63, file: !49, line: 87, column: 5)
!66 = !DILocation(line: 87, column: 5, scope: !67)
!67 = distinct !DILexicalBlock(scope: !65, file: !49, line: 87, column: 5)
!68 = !DILocation(line: 88, column: 1, scope: !56)
!69 = distinct !DISubprogram(name: "writer_release", scope: !49, file: !49, line: 90, type: !57, scopeLine: 91, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!70 = !DILocalVariable(name: "tid", arg: 1, scope: !69, file: !49, line: 90, type: !6)
!71 = !DILocation(line: 90, column: 26, scope: !69)
!72 = !DILocation(line: 92, column: 5, scope: !69)
!73 = !DILocation(line: 92, column: 5, scope: !74)
!74 = distinct !DILexicalBlock(scope: !69, file: !49, line: 92, column: 5)
!75 = !DILocation(line: 92, column: 5, scope: !76)
!76 = distinct !DILexicalBlock(scope: !74, file: !49, line: 92, column: 5)
!77 = !DILocation(line: 92, column: 5, scope: !78)
!78 = distinct !DILexicalBlock(scope: !76, file: !49, line: 92, column: 5)
!79 = !DILocation(line: 93, column: 1, scope: !69)
!80 = distinct !DISubprogram(name: "reader_acquire", scope: !49, file: !49, line: 95, type: !57, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!81 = !DILocalVariable(name: "tid", arg: 1, scope: !80, file: !49, line: 95, type: !6)
!82 = !DILocation(line: 95, column: 26, scope: !80)
!83 = !DILocation(line: 97, column: 5, scope: !80)
!84 = !DILocation(line: 97, column: 5, scope: !85)
!85 = distinct !DILexicalBlock(scope: !80, file: !49, line: 97, column: 5)
!86 = !DILocation(line: 97, column: 5, scope: !87)
!87 = distinct !DILexicalBlock(scope: !85, file: !49, line: 97, column: 5)
!88 = !DILocation(line: 97, column: 5, scope: !89)
!89 = distinct !DILexicalBlock(scope: !87, file: !49, line: 97, column: 5)
!90 = !DILocation(line: 98, column: 1, scope: !80)
!91 = distinct !DISubprogram(name: "reader_release", scope: !49, file: !49, line: 100, type: !57, scopeLine: 101, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!92 = !DILocalVariable(name: "tid", arg: 1, scope: !91, file: !49, line: 100, type: !6)
!93 = !DILocation(line: 100, column: 26, scope: !91)
!94 = !DILocation(line: 102, column: 5, scope: !91)
!95 = !DILocation(line: 102, column: 5, scope: !96)
!96 = distinct !DILexicalBlock(scope: !91, file: !49, line: 102, column: 5)
!97 = !DILocation(line: 102, column: 5, scope: !98)
!98 = distinct !DILexicalBlock(scope: !96, file: !49, line: 102, column: 5)
!99 = !DILocation(line: 102, column: 5, scope: !100)
!100 = distinct !DILexicalBlock(scope: !98, file: !49, line: 102, column: 5)
!101 = !DILocation(line: 103, column: 1, scope: !91)
!102 = distinct !DISubprogram(name: "main", scope: !49, file: !49, line: 158, type: !103, scopeLine: 159, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!103 = !DISubroutineType(types: !104)
!104 = !{!105}
!105 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!106 = !DILocalVariable(name: "t", scope: !102, file: !49, line: 160, type: !107)
!107 = !DICompositeType(tag: DW_TAG_array_type, baseType: !108, size: 256, elements: !110)
!108 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !109, line: 27, baseType: !16)
!109 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!110 = !{!111}
!111 = !DISubrange(count: 4)
!112 = !DILocation(line: 160, column: 15, scope: !102)
!113 = !DILocation(line: 167, column: 5, scope: !102)
!114 = !DILocalVariable(name: "i", scope: !115, file: !49, line: 169, type: !13)
!115 = distinct !DILexicalBlock(scope: !102, file: !49, line: 169, column: 5)
!116 = !DILocation(line: 169, column: 21, scope: !115)
!117 = !DILocation(line: 169, column: 10, scope: !115)
!118 = !DILocation(line: 169, column: 28, scope: !119)
!119 = distinct !DILexicalBlock(scope: !115, file: !49, line: 169, column: 5)
!120 = !DILocation(line: 169, column: 30, scope: !119)
!121 = !DILocation(line: 169, column: 5, scope: !115)
!122 = !DILocation(line: 170, column: 33, scope: !123)
!123 = distinct !DILexicalBlock(scope: !119, file: !49, line: 169, column: 47)
!124 = !DILocation(line: 170, column: 31, scope: !123)
!125 = !DILocation(line: 170, column: 56, scope: !123)
!126 = !DILocation(line: 170, column: 48, scope: !123)
!127 = !DILocation(line: 170, column: 15, scope: !123)
!128 = !DILocation(line: 171, column: 5, scope: !123)
!129 = !DILocation(line: 169, column: 43, scope: !119)
!130 = !DILocation(line: 169, column: 5, scope: !119)
!131 = distinct !{!131, !121, !132, !133}
!132 = !DILocation(line: 171, column: 5, scope: !115)
!133 = !{!"llvm.loop.mustprogress"}
!134 = !DILocalVariable(name: "i", scope: !135, file: !49, line: 173, type: !13)
!135 = distinct !DILexicalBlock(scope: !102, file: !49, line: 173, column: 5)
!136 = !DILocation(line: 173, column: 21, scope: !135)
!137 = !DILocation(line: 173, column: 10, scope: !135)
!138 = !DILocation(line: 173, column: 35, scope: !139)
!139 = distinct !DILexicalBlock(scope: !135, file: !49, line: 173, column: 5)
!140 = !DILocation(line: 173, column: 37, scope: !139)
!141 = !DILocation(line: 173, column: 5, scope: !135)
!142 = !DILocation(line: 174, column: 33, scope: !143)
!143 = distinct !DILexicalBlock(scope: !139, file: !49, line: 173, column: 54)
!144 = !DILocation(line: 174, column: 31, scope: !143)
!145 = !DILocation(line: 174, column: 56, scope: !143)
!146 = !DILocation(line: 174, column: 48, scope: !143)
!147 = !DILocation(line: 174, column: 15, scope: !143)
!148 = !DILocation(line: 175, column: 5, scope: !143)
!149 = !DILocation(line: 173, column: 50, scope: !139)
!150 = !DILocation(line: 173, column: 5, scope: !139)
!151 = distinct !{!151, !141, !152, !133}
!152 = !DILocation(line: 175, column: 5, scope: !135)
!153 = !DILocation(line: 177, column: 5, scope: !102)
!154 = !DILocalVariable(name: "i", scope: !155, file: !49, line: 179, type: !13)
!155 = distinct !DILexicalBlock(scope: !102, file: !49, line: 179, column: 5)
!156 = !DILocation(line: 179, column: 21, scope: !155)
!157 = !DILocation(line: 179, column: 10, scope: !155)
!158 = !DILocation(line: 179, column: 28, scope: !159)
!159 = distinct !DILexicalBlock(scope: !155, file: !49, line: 179, column: 5)
!160 = !DILocation(line: 179, column: 30, scope: !159)
!161 = !DILocation(line: 179, column: 5, scope: !155)
!162 = !DILocation(line: 180, column: 30, scope: !163)
!163 = distinct !DILexicalBlock(scope: !159, file: !49, line: 179, column: 47)
!164 = !DILocation(line: 180, column: 28, scope: !163)
!165 = !DILocation(line: 180, column: 15, scope: !163)
!166 = !DILocation(line: 181, column: 5, scope: !163)
!167 = !DILocation(line: 179, column: 43, scope: !159)
!168 = !DILocation(line: 179, column: 5, scope: !159)
!169 = distinct !{!169, !161, !170, !133}
!170 = !DILocation(line: 181, column: 5, scope: !155)
!171 = !DILocation(line: 188, column: 5, scope: !102)
!172 = !DILocation(line: 189, column: 5, scope: !102)
!173 = !DILocation(line: 191, column: 5, scope: !102)
!174 = distinct !DISubprogram(name: "init", scope: !20, file: !20, line: 63, type: !50, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!175 = !DILocation(line: 65, column: 5, scope: !174)
!176 = !DILocation(line: 66, column: 1, scope: !174)
!177 = distinct !DISubprogram(name: "writer", scope: !49, file: !49, line: 137, type: !178, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!178 = !DISubroutineType(types: !179)
!179 = !{!5, !5}
!180 = !DILocalVariable(name: "arg", arg: 1, scope: !177, file: !49, line: 137, type: !5)
!181 = !DILocation(line: 137, column: 14, scope: !177)
!182 = !DILocalVariable(name: "tid", scope: !177, file: !49, line: 139, type: !6)
!183 = !DILocation(line: 139, column: 15, scope: !177)
!184 = !DILocation(line: 139, column: 44, scope: !177)
!185 = !DILocation(line: 139, column: 32, scope: !177)
!186 = !DILocation(line: 139, column: 21, scope: !177)
!187 = !DILocation(line: 140, column: 20, scope: !177)
!188 = !DILocation(line: 140, column: 5, scope: !177)
!189 = !DILocation(line: 141, column: 15, scope: !177)
!190 = !DILocation(line: 141, column: 5, scope: !177)
!191 = !DILocation(line: 142, column: 20, scope: !177)
!192 = !DILocation(line: 142, column: 5, scope: !177)
!193 = !DILocation(line: 143, column: 5, scope: !177)
!194 = distinct !DISubprogram(name: "reader", scope: !49, file: !49, line: 147, type: !178, scopeLine: 148, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!195 = !DILocalVariable(name: "arg", arg: 1, scope: !194, file: !49, line: 147, type: !5)
!196 = !DILocation(line: 147, column: 14, scope: !194)
!197 = !DILocalVariable(name: "tid", scope: !194, file: !49, line: 149, type: !6)
!198 = !DILocation(line: 149, column: 15, scope: !194)
!199 = !DILocation(line: 149, column: 44, scope: !194)
!200 = !DILocation(line: 149, column: 32, scope: !194)
!201 = !DILocation(line: 149, column: 21, scope: !194)
!202 = !DILocation(line: 150, column: 20, scope: !194)
!203 = !DILocation(line: 150, column: 5, scope: !194)
!204 = !DILocation(line: 151, column: 15, scope: !194)
!205 = !DILocation(line: 151, column: 5, scope: !194)
!206 = !DILocation(line: 152, column: 20, scope: !194)
!207 = !DILocation(line: 152, column: 5, scope: !194)
!208 = !DILocation(line: 154, column: 5, scope: !194)
!209 = distinct !DISubprogram(name: "fini", scope: !20, file: !20, line: 69, type: !50, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!210 = !DILocalVariable(name: "x", scope: !209, file: !20, line: 71, type: !6)
!211 = !DILocation(line: 71, column: 15, scope: !209)
!212 = !DILocation(line: 71, column: 19, scope: !209)
!213 = !DILocalVariable(name: "y", scope: !209, file: !20, line: 72, type: !6)
!214 = !DILocation(line: 72, column: 15, scope: !209)
!215 = !DILocation(line: 72, column: 19, scope: !209)
!216 = !DILocation(line: 73, column: 5, scope: !217)
!217 = distinct !DILexicalBlock(scope: !218, file: !20, line: 73, column: 5)
!218 = distinct !DILexicalBlock(scope: !209, file: !20, line: 73, column: 5)
!219 = !DILocation(line: 73, column: 5, scope: !218)
!220 = !DILocation(line: 74, column: 5, scope: !221)
!221 = distinct !DILexicalBlock(scope: !222, file: !20, line: 74, column: 5)
!222 = distinct !DILexicalBlock(scope: !209, file: !20, line: 74, column: 5)
!223 = !DILocation(line: 74, column: 5, scope: !222)
!224 = !DILocation(line: 75, column: 5, scope: !209)
!225 = !DILocation(line: 75, column: 5, scope: !226)
!226 = distinct !DILexicalBlock(scope: !209, file: !20, line: 75, column: 5)
!227 = !DILocation(line: 75, column: 5, scope: !228)
!228 = distinct !DILexicalBlock(scope: !226, file: !20, line: 75, column: 5)
!229 = !DILocation(line: 75, column: 5, scope: !230)
!230 = distinct !DILexicalBlock(scope: !228, file: !20, line: 75, column: 5)
!231 = !DILocation(line: 75, column: 5, scope: !232)
!232 = distinct !DILexicalBlock(scope: !230, file: !20, line: 75, column: 5)
!233 = !DILocation(line: 76, column: 1, scope: !209)
!234 = distinct !DISubprogram(name: "writer_cs", scope: !20, file: !20, line: 28, type: !57, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!235 = !DILocalVariable(name: "tid", arg: 1, scope: !234, file: !20, line: 28, type: !6)
!236 = !DILocation(line: 28, column: 21, scope: !234)
!237 = !DILocalVariable(name: "i", scope: !234, file: !20, line: 30, type: !238)
!238 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsize_t", file: !7, line: 43, baseType: !239)
!239 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !240, line: 46, baseType: !16)
!240 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!241 = !DILocation(line: 30, column: 13, scope: !234)
!242 = !DILocation(line: 32, column: 12, scope: !243)
!243 = distinct !DILexicalBlock(scope: !234, file: !20, line: 32, column: 5)
!244 = !DILocation(line: 32, column: 10, scope: !243)
!245 = !DILocation(line: 32, column: 17, scope: !246)
!246 = distinct !DILexicalBlock(scope: !243, file: !20, line: 32, column: 5)
!247 = !DILocation(line: 32, column: 19, scope: !246)
!248 = !DILocation(line: 32, column: 5, scope: !243)
!249 = !DILocation(line: 33, column: 36, scope: !250)
!250 = distinct !DILexicalBlock(scope: !246, file: !20, line: 32, column: 41)
!251 = !DILocation(line: 33, column: 9, scope: !250)
!252 = !DILocation(line: 34, column: 5, scope: !250)
!253 = !DILocation(line: 32, column: 37, scope: !246)
!254 = !DILocation(line: 32, column: 5, scope: !246)
!255 = distinct !{!255, !248, !256, !133}
!256 = !DILocation(line: 34, column: 5, scope: !243)
!257 = !DILocation(line: 35, column: 11, scope: !234)
!258 = !DILocation(line: 36, column: 11, scope: !234)
!259 = !DILocation(line: 38, column: 12, scope: !260)
!260 = distinct !DILexicalBlock(scope: !234, file: !20, line: 38, column: 5)
!261 = !DILocation(line: 38, column: 10, scope: !260)
!262 = !DILocation(line: 38, column: 17, scope: !263)
!263 = distinct !DILexicalBlock(scope: !260, file: !20, line: 38, column: 5)
!264 = !DILocation(line: 38, column: 19, scope: !263)
!265 = !DILocation(line: 38, column: 5, scope: !260)
!266 = !DILocation(line: 39, column: 9, scope: !267)
!267 = distinct !DILexicalBlock(scope: !263, file: !20, line: 38, column: 41)
!268 = !DILocation(line: 40, column: 5, scope: !267)
!269 = !DILocation(line: 38, column: 37, scope: !263)
!270 = !DILocation(line: 38, column: 5, scope: !263)
!271 = distinct !{!271, !265, !272, !133}
!272 = !DILocation(line: 40, column: 5, scope: !260)
!273 = !DILocation(line: 41, column: 1, scope: !234)
!274 = distinct !DISubprogram(name: "rec_seqlock_acquire", scope: !24, file: !24, line: 32, type: !275, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!275 = !DISubroutineType(types: !276)
!276 = !{null, !277, !6}
!277 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!278 = !DILocalVariable(name: "l", arg: 1, scope: !274, file: !24, line: 32, type: !277)
!279 = !DILocation(line: 32, column: 1, scope: !274)
!280 = !DILocalVariable(name: "id", arg: 2, scope: !274, file: !24, line: 32, type: !6)
!281 = !DILocation(line: 32, column: 1, scope: !282)
!282 = distinct !DILexicalBlock(scope: !283, file: !24, line: 32, column: 1)
!283 = distinct !DILexicalBlock(scope: !274, file: !24, line: 32, column: 1)
!284 = !DILocation(line: 32, column: 1, scope: !283)
!285 = !DILocation(line: 32, column: 1, scope: !286)
!286 = distinct !DILexicalBlock(scope: !274, file: !24, line: 32, column: 1)
!287 = !DILocation(line: 32, column: 1, scope: !288)
!288 = distinct !DILexicalBlock(scope: !286, file: !24, line: 32, column: 1)
!289 = distinct !DISubprogram(name: "rec_seqlock_release", scope: !24, file: !24, line: 32, type: !290, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!290 = !DISubroutineType(types: !291)
!291 = !{null, !277}
!292 = !DILocalVariable(name: "l", arg: 1, scope: !289, file: !24, line: 32, type: !277)
!293 = !DILocation(line: 32, column: 1, scope: !289)
!294 = !DILocation(line: 32, column: 1, scope: !295)
!295 = distinct !DILexicalBlock(scope: !289, file: !24, line: 32, column: 1)
!296 = !DILocation(line: 32, column: 1, scope: !297)
!297 = distinct !DILexicalBlock(scope: !295, file: !24, line: 32, column: 1)
!298 = !DILocation(line: 32, column: 1, scope: !299)
!299 = distinct !DILexicalBlock(scope: !295, file: !24, line: 32, column: 1)
!300 = distinct !DISubprogram(name: "reader_cs", scope: !20, file: !20, line: 44, type: !57, scopeLine: 45, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!301 = !DILocalVariable(name: "tid", arg: 1, scope: !300, file: !20, line: 44, type: !6)
!302 = !DILocation(line: 44, column: 21, scope: !300)
!303 = !DILocalVariable(name: "a", scope: !300, file: !20, line: 46, type: !6)
!304 = !DILocation(line: 46, column: 15, scope: !300)
!305 = !DILocalVariable(name: "b", scope: !300, file: !20, line: 47, type: !6)
!306 = !DILocation(line: 47, column: 15, scope: !300)
!307 = !DILocalVariable(name: "s", scope: !300, file: !20, line: 48, type: !308)
!308 = !DIDerivedType(tag: DW_TAG_typedef, name: "seqvalue_t", file: !29, line: 28, baseType: !6)
!309 = !DILocation(line: 48, column: 16, scope: !300)
!310 = !DILocation(line: 50, column: 5, scope: !300)
!311 = !DILocation(line: 51, column: 13, scope: !312)
!312 = distinct !DILexicalBlock(scope: !300, file: !20, line: 50, column: 14)
!313 = !DILocation(line: 51, column: 11, scope: !312)
!314 = !DILocation(line: 52, column: 13, scope: !312)
!315 = !DILocation(line: 52, column: 11, scope: !312)
!316 = !DILocation(line: 53, column: 13, scope: !312)
!317 = !DILocation(line: 53, column: 11, scope: !312)
!318 = !DILocation(line: 54, column: 5, scope: !312)
!319 = !DILocation(line: 55, column: 5, scope: !300)
!320 = distinct !{!320, !310, !319, !133}
!321 = !DILocation(line: 57, column: 5, scope: !322)
!322 = distinct !DILexicalBlock(scope: !323, file: !20, line: 57, column: 5)
!323 = distinct !DILexicalBlock(scope: !300, file: !20, line: 57, column: 5)
!324 = !DILocation(line: 57, column: 5, scope: !323)
!325 = !DILocation(line: 58, column: 5, scope: !326)
!326 = distinct !DILexicalBlock(scope: !327, file: !20, line: 58, column: 5)
!327 = distinct !DILexicalBlock(scope: !300, file: !20, line: 58, column: 5)
!328 = !DILocation(line: 58, column: 5, scope: !327)
!329 = !DILocation(line: 59, column: 5, scope: !300)
!330 = !DILocation(line: 59, column: 5, scope: !331)
!331 = distinct !DILexicalBlock(scope: !300, file: !20, line: 59, column: 5)
!332 = !DILocation(line: 59, column: 5, scope: !333)
!333 = distinct !DILexicalBlock(scope: !331, file: !20, line: 59, column: 5)
!334 = !DILocation(line: 59, column: 5, scope: !335)
!335 = distinct !DILexicalBlock(scope: !333, file: !20, line: 59, column: 5)
!336 = !DILocation(line: 59, column: 5, scope: !337)
!337 = distinct !DILexicalBlock(scope: !335, file: !20, line: 59, column: 5)
!338 = !DILocation(line: 59, column: 5, scope: !339)
!339 = distinct !DILexicalBlock(scope: !337, file: !20, line: 59, column: 5)
!340 = !DILocation(line: 60, column: 1, scope: !300)
!341 = distinct !DISubprogram(name: "rec_seqlock_rbegin", scope: !24, file: !24, line: 78, type: !342, scopeLine: 79, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!342 = !DISubroutineType(types: !343)
!343 = !{!308, !277}
!344 = !DILocalVariable(name: "l", arg: 1, scope: !341, file: !24, line: 78, type: !277)
!345 = !DILocation(line: 78, column: 35, scope: !341)
!346 = !DILocation(line: 80, column: 28, scope: !341)
!347 = !DILocation(line: 80, column: 31, scope: !341)
!348 = !DILocation(line: 80, column: 12, scope: !341)
!349 = !DILocation(line: 80, column: 5, scope: !341)
!350 = distinct !DISubprogram(name: "rec_seqlock_rend", scope: !24, file: !24, line: 98, type: !351, scopeLine: 99, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!351 = !DISubroutineType(types: !352)
!352 = !{!353, !277, !308}
!353 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !7, line: 44, baseType: !354)
!354 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!355 = !DILocalVariable(name: "l", arg: 1, scope: !350, file: !24, line: 98, type: !277)
!356 = !DILocation(line: 98, column: 33, scope: !350)
!357 = !DILocalVariable(name: "sv", arg: 2, scope: !350, file: !24, line: 98, type: !308)
!358 = !DILocation(line: 98, column: 47, scope: !350)
!359 = !DILocation(line: 100, column: 26, scope: !350)
!360 = !DILocation(line: 100, column: 29, scope: !350)
!361 = !DILocation(line: 100, column: 35, scope: !350)
!362 = !DILocation(line: 100, column: 12, scope: !350)
!363 = !DILocation(line: 100, column: 5, scope: !350)
!364 = distinct !DISubprogram(name: "rec_seqlock_init", scope: !24, file: !24, line: 32, type: !290, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!365 = !DILocalVariable(name: "l", arg: 1, scope: !364, file: !24, line: 32, type: !277)
!366 = !DILocation(line: 32, column: 1, scope: !364)
!367 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !368, file: !368, line: 101, type: !369, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!368 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!369 = !DISubroutineType(types: !370)
!370 = !{!6, !371}
!371 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !372, size: 64)
!372 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!373 = !DILocalVariable(name: "a", arg: 1, scope: !367, file: !368, line: 101, type: !371)
!374 = !DILocation(line: 101, column: 39, scope: !367)
!375 = !DILocalVariable(name: "val", scope: !367, file: !368, line: 103, type: !6)
!376 = !DILocation(line: 103, column: 15, scope: !367)
!377 = !DILocation(line: 106, column: 32, scope: !367)
!378 = !DILocation(line: 106, column: 35, scope: !367)
!379 = !DILocation(line: 104, column: 5, scope: !367)
!380 = !{i64 399560}
!381 = !DILocation(line: 108, column: 12, scope: !367)
!382 = !DILocation(line: 108, column: 5, scope: !367)
!383 = distinct !DISubprogram(name: "seqlock_acquire", scope: !29, file: !29, line: 81, type: !384, scopeLine: 82, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!384 = !DISubroutineType(types: !385)
!385 = !{null, !386}
!386 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!387 = !DILocalVariable(name: "seq", arg: 1, scope: !383, file: !29, line: 81, type: !386)
!388 = !DILocation(line: 81, column: 28, scope: !383)
!389 = !DILocalVariable(name: "count", scope: !383, file: !29, line: 83, type: !308)
!390 = !DILocation(line: 83, column: 16, scope: !383)
!391 = !DILocalVariable(name: "o_count", scope: !383, file: !29, line: 84, type: !308)
!392 = !DILocation(line: 84, column: 16, scope: !383)
!393 = !DILocation(line: 86, column: 5, scope: !383)
!394 = !DILocation(line: 88, column: 37, scope: !395)
!395 = distinct !DILexicalBlock(scope: !383, file: !29, line: 86, column: 8)
!396 = !DILocation(line: 88, column: 17, scope: !395)
!397 = !DILocation(line: 88, column: 15, scope: !395)
!398 = !DILocation(line: 91, column: 42, scope: !395)
!399 = !DILocation(line: 91, column: 47, scope: !395)
!400 = !DILocation(line: 91, column: 57, scope: !395)
!401 = !DILocation(line: 91, column: 64, scope: !395)
!402 = !DILocation(line: 91, column: 70, scope: !395)
!403 = !DILocation(line: 91, column: 19, scope: !395)
!404 = !DILocation(line: 91, column: 17, scope: !395)
!405 = !DILocation(line: 94, column: 13, scope: !406)
!406 = distinct !DILexicalBlock(scope: !395, file: !29, line: 94, column: 13)
!407 = !DILocation(line: 94, column: 24, scope: !406)
!408 = !DILocation(line: 94, column: 21, scope: !406)
!409 = !DILocation(line: 94, column: 13, scope: !395)
!410 = !DILocation(line: 95, column: 13, scope: !411)
!411 = distinct !DILexicalBlock(scope: !406, file: !29, line: 94, column: 31)
!412 = !DILocation(line: 97, column: 5, scope: !395)
!413 = distinct !{!413, !393, !414}
!414 = !DILocation(line: 97, column: 18, scope: !383)
!415 = !DILocation(line: 99, column: 5, scope: !383)
!416 = !DILocation(line: 100, column: 1, scope: !383)
!417 = distinct !DISubprogram(name: "vatomic32_write_rlx", scope: !368, file: !368, line: 241, type: !418, scopeLine: 242, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!418 = !DISubroutineType(types: !419)
!419 = !{null, !420, !6}
!420 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!421 = !DILocalVariable(name: "a", arg: 1, scope: !417, file: !368, line: 241, type: !420)
!422 = !DILocation(line: 241, column: 34, scope: !417)
!423 = !DILocalVariable(name: "v", arg: 2, scope: !417, file: !368, line: 241, type: !6)
!424 = !DILocation(line: 241, column: 47, scope: !417)
!425 = !DILocation(line: 245, column: 32, scope: !417)
!426 = !DILocation(line: 245, column: 44, scope: !417)
!427 = !DILocation(line: 245, column: 47, scope: !417)
!428 = !DILocation(line: 243, column: 5, scope: !417)
!429 = !{i64 403944}
!430 = !DILocation(line: 247, column: 1, scope: !417)
!431 = distinct !DISubprogram(name: "_seqlock_await_even", scope: !29, file: !29, line: 48, type: !432, scopeLine: 49, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!432 = !DISubroutineType(types: !433)
!433 = !{!308, !386}
!434 = !DILocalVariable(name: "seq", arg: 1, scope: !431, file: !29, line: 48, type: !386)
!435 = !DILocation(line: 48, column: 32, scope: !431)
!436 = !DILocalVariable(name: "count", scope: !431, file: !29, line: 50, type: !308)
!437 = !DILocation(line: 50, column: 16, scope: !431)
!438 = !DILocation(line: 50, column: 44, scope: !431)
!439 = !DILocation(line: 50, column: 49, scope: !431)
!440 = !DILocation(line: 50, column: 24, scope: !431)
!441 = !DILocation(line: 51, column: 5, scope: !431)
!442 = !DILocation(line: 51, column: 12, scope: !431)
!443 = !DILocation(line: 52, column: 42, scope: !444)
!444 = distinct !DILexicalBlock(scope: !431, file: !29, line: 51, column: 28)
!445 = !DILocation(line: 52, column: 47, scope: !444)
!446 = !DILocation(line: 52, column: 57, scope: !444)
!447 = !DILocation(line: 52, column: 17, scope: !444)
!448 = !DILocation(line: 52, column: 15, scope: !444)
!449 = distinct !{!449, !441, !450, !133}
!450 = !DILocation(line: 53, column: 5, scope: !431)
!451 = !DILocation(line: 54, column: 5, scope: !452)
!452 = distinct !DILexicalBlock(scope: !453, file: !29, line: 54, column: 5)
!453 = distinct !DILexicalBlock(scope: !431, file: !29, line: 54, column: 5)
!454 = !DILocation(line: 54, column: 5, scope: !453)
!455 = !DILocation(line: 55, column: 12, scope: !431)
!456 = !DILocation(line: 55, column: 5, scope: !431)
!457 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !458, file: !458, line: 311, type: !459, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!458 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!459 = !DISubroutineType(types: !460)
!460 = !{!6, !420, !6, !6}
!461 = !DILocalVariable(name: "a", arg: 1, scope: !457, file: !458, line: 311, type: !420)
!462 = !DILocation(line: 311, column: 36, scope: !457)
!463 = !DILocalVariable(name: "e", arg: 2, scope: !457, file: !458, line: 311, type: !6)
!464 = !DILocation(line: 311, column: 49, scope: !457)
!465 = !DILocalVariable(name: "v", arg: 3, scope: !457, file: !458, line: 311, type: !6)
!466 = !DILocation(line: 311, column: 62, scope: !457)
!467 = !DILocalVariable(name: "oldv", scope: !457, file: !458, line: 313, type: !6)
!468 = !DILocation(line: 313, column: 15, scope: !457)
!469 = !DILocalVariable(name: "tmp", scope: !457, file: !458, line: 314, type: !6)
!470 = !DILocation(line: 314, column: 15, scope: !457)
!471 = !DILocation(line: 325, column: 22, scope: !457)
!472 = !DILocation(line: 325, column: 36, scope: !457)
!473 = !DILocation(line: 325, column: 48, scope: !457)
!474 = !DILocation(line: 325, column: 51, scope: !457)
!475 = !DILocation(line: 315, column: 5, scope: !457)
!476 = !{i64 464468, i64 464502, i64 464517, i64 464550, i64 464584, i64 464604, i64 464646, i64 464675}
!477 = !DILocation(line: 327, column: 12, scope: !457)
!478 = !DILocation(line: 327, column: 5, scope: !457)
!479 = distinct !DISubprogram(name: "vatomic_fence_rel", scope: !368, file: !368, line: 50, type: !50, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!480 = !DILocation(line: 52, column: 5, scope: !479)
!481 = !{i64 398021}
!482 = !DILocation(line: 53, column: 1, scope: !479)
!483 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !368, file: !368, line: 85, type: !369, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!484 = !DILocalVariable(name: "a", arg: 1, scope: !483, file: !368, line: 85, type: !371)
!485 = !DILocation(line: 85, column: 39, scope: !483)
!486 = !DILocalVariable(name: "val", scope: !483, file: !368, line: 87, type: !6)
!487 = !DILocation(line: 87, column: 15, scope: !483)
!488 = !DILocation(line: 90, column: 32, scope: !483)
!489 = !DILocation(line: 90, column: 35, scope: !483)
!490 = !DILocation(line: 88, column: 5, scope: !483)
!491 = !{i64 399058}
!492 = !DILocation(line: 92, column: 12, scope: !483)
!493 = !DILocation(line: 92, column: 5, scope: !483)
!494 = distinct !DISubprogram(name: "vatomic32_await_neq_acq", scope: !368, file: !368, line: 648, type: !495, scopeLine: 649, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!495 = !DISubroutineType(types: !496)
!496 = !{!6, !371, !6}
!497 = !DILocalVariable(name: "a", arg: 1, scope: !494, file: !368, line: 648, type: !371)
!498 = !DILocation(line: 648, column: 44, scope: !494)
!499 = !DILocalVariable(name: "v", arg: 2, scope: !494, file: !368, line: 648, type: !6)
!500 = !DILocation(line: 648, column: 57, scope: !494)
!501 = !DILocalVariable(name: "val", scope: !494, file: !368, line: 650, type: !6)
!502 = !DILocation(line: 650, column: 15, scope: !494)
!503 = !DILocation(line: 657, column: 21, scope: !494)
!504 = !DILocation(line: 657, column: 33, scope: !494)
!505 = !DILocation(line: 657, column: 36, scope: !494)
!506 = !DILocation(line: 651, column: 5, scope: !494)
!507 = !{i64 415252, i64 415268, i64 415299, i64 415332}
!508 = !DILocation(line: 659, column: 12, scope: !494)
!509 = !DILocation(line: 659, column: 5, scope: !494)
!510 = distinct !DISubprogram(name: "seqlock_release", scope: !29, file: !29, line: 113, type: !384, scopeLine: 114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!511 = !DILocalVariable(name: "seq", arg: 1, scope: !510, file: !29, line: 113, type: !386)
!512 = !DILocation(line: 113, column: 28, scope: !510)
!513 = !DILocalVariable(name: "cur_val", scope: !510, file: !29, line: 117, type: !308)
!514 = !DILocation(line: 117, column: 16, scope: !510)
!515 = !DILocation(line: 117, column: 46, scope: !510)
!516 = !DILocation(line: 117, column: 51, scope: !510)
!517 = !DILocation(line: 117, column: 26, scope: !510)
!518 = !DILocation(line: 118, column: 5, scope: !519)
!519 = distinct !DILexicalBlock(scope: !520, file: !29, line: 118, column: 5)
!520 = distinct !DILexicalBlock(scope: !510, file: !29, line: 118, column: 5)
!521 = !DILocation(line: 118, column: 5, scope: !520)
!522 = !DILocation(line: 119, column: 26, scope: !510)
!523 = !DILocation(line: 119, column: 31, scope: !510)
!524 = !DILocation(line: 119, column: 41, scope: !510)
!525 = !DILocation(line: 119, column: 49, scope: !510)
!526 = !DILocation(line: 119, column: 5, scope: !510)
!527 = !DILocation(line: 122, column: 1, scope: !510)
!528 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !368, file: !368, line: 227, type: !418, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!529 = !DILocalVariable(name: "a", arg: 1, scope: !528, file: !368, line: 227, type: !420)
!530 = !DILocation(line: 227, column: 34, scope: !528)
!531 = !DILocalVariable(name: "v", arg: 2, scope: !528, file: !368, line: 227, type: !6)
!532 = !DILocation(line: 227, column: 47, scope: !528)
!533 = !DILocation(line: 231, column: 32, scope: !528)
!534 = !DILocation(line: 231, column: 44, scope: !528)
!535 = !DILocation(line: 231, column: 47, scope: !528)
!536 = !DILocation(line: 229, column: 5, scope: !528)
!537 = !{i64 403474}
!538 = !DILocation(line: 233, column: 1, scope: !528)
!539 = distinct !DISubprogram(name: "seqlock_rbegin", scope: !29, file: !29, line: 137, type: !432, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!540 = !DILocalVariable(name: "seq", arg: 1, scope: !539, file: !29, line: 137, type: !386)
!541 = !DILocation(line: 137, column: 27, scope: !539)
!542 = !DILocation(line: 139, column: 32, scope: !539)
!543 = !DILocation(line: 139, column: 12, scope: !539)
!544 = !DILocation(line: 139, column: 5, scope: !539)
!545 = distinct !DISubprogram(name: "seqlock_rend", scope: !29, file: !29, line: 154, type: !546, scopeLine: 155, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!546 = !DISubroutineType(types: !547)
!547 = !{!353, !386, !308}
!548 = !DILocalVariable(name: "seq", arg: 1, scope: !545, file: !29, line: 154, type: !386)
!549 = !DILocation(line: 154, column: 25, scope: !545)
!550 = !DILocalVariable(name: "sv", arg: 2, scope: !545, file: !29, line: 154, type: !308)
!551 = !DILocation(line: 154, column: 41, scope: !545)
!552 = !DILocation(line: 156, column: 5, scope: !553)
!553 = distinct !DILexicalBlock(scope: !554, file: !29, line: 156, column: 5)
!554 = distinct !DILexicalBlock(scope: !545, file: !29, line: 156, column: 5)
!555 = !DILocation(line: 156, column: 5, scope: !554)
!556 = !DILocation(line: 157, column: 5, scope: !545)
!557 = !DILocation(line: 160, column: 32, scope: !545)
!558 = !DILocation(line: 160, column: 37, scope: !545)
!559 = !DILocation(line: 160, column: 12, scope: !545)
!560 = !DILocation(line: 160, column: 50, scope: !545)
!561 = !DILocation(line: 160, column: 47, scope: !545)
!562 = !DILocation(line: 160, column: 5, scope: !545)
!563 = distinct !DISubprogram(name: "vatomic_fence_acq", scope: !368, file: !368, line: 42, type: !50, scopeLine: 43, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!564 = !DILocation(line: 44, column: 5, scope: !563)
!565 = !{i64 397863}
!566 = !DILocation(line: 45, column: 1, scope: !563)
!567 = distinct !DISubprogram(name: "seqlock_init", scope: !29, file: !29, line: 65, type: !384, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!568 = !DILocalVariable(name: "seq", arg: 1, scope: !567, file: !29, line: 65, type: !386)
!569 = !DILocation(line: 65, column: 25, scope: !567)
!570 = !DILocation(line: 67, column: 26, scope: !567)
!571 = !DILocation(line: 67, column: 31, scope: !567)
!572 = !DILocation(line: 67, column: 5, scope: !567)
!573 = !DILocation(line: 68, column: 1, scope: !567)
!574 = distinct !DISubprogram(name: "vatomic32_init", scope: !575, file: !575, line: 4189, type: !418, scopeLine: 4190, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!575 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!576 = !DILocalVariable(name: "a", arg: 1, scope: !574, file: !575, line: 4189, type: !420)
!577 = !DILocation(line: 4189, column: 29, scope: !574)
!578 = !DILocalVariable(name: "v", arg: 2, scope: !574, file: !575, line: 4189, type: !6)
!579 = !DILocation(line: 4189, column: 42, scope: !574)
!580 = !DILocation(line: 4191, column: 21, scope: !574)
!581 = !DILocation(line: 4191, column: 24, scope: !574)
!582 = !DILocation(line: 4191, column: 5, scope: !574)
!583 = !DILocation(line: 4192, column: 1, scope: !574)
!584 = distinct !DISubprogram(name: "vatomic32_write", scope: !368, file: !368, line: 213, type: !418, scopeLine: 214, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!585 = !DILocalVariable(name: "a", arg: 1, scope: !584, file: !368, line: 213, type: !420)
!586 = !DILocation(line: 213, column: 30, scope: !584)
!587 = !DILocalVariable(name: "v", arg: 2, scope: !584, file: !368, line: 213, type: !6)
!588 = !DILocation(line: 213, column: 43, scope: !584)
!589 = !DILocation(line: 217, column: 32, scope: !584)
!590 = !DILocation(line: 217, column: 44, scope: !584)
!591 = !DILocation(line: 217, column: 47, scope: !584)
!592 = !DILocation(line: 215, column: 5, scope: !584)
!593 = !{i64 403004}
!594 = !DILocation(line: 219, column: 1, scope: !584)
