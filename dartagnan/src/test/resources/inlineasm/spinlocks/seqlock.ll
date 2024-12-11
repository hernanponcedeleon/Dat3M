; ModuleID = '/home/stefano/huawei/libvsync/spinlock/test/seqlock.c'
source_filename = "/home/stefano/huawei/libvsync/spinlock/test/seqlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.seqlock_s = type { %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@lock = dso_local global %struct.seqlock_s zeroinitializer, align 4, !dbg !0
@g_cs_x = dso_local global i32 0, align 4, !dbg !18
@g_cs_y = dso_local global i32 0, align 4, !dbg !21
@.str = private unnamed_addr constant [7 x i8] c"a == b\00", align 1
@.str.1 = private unnamed_addr constant [54 x i8] c"/home/stefano/huawei/libvsync/spinlock/test/seqlock.c\00", align 1
@__PRETTY_FUNCTION__.reader_cs = private unnamed_addr constant [26 x i8] c"void reader_cs(vuint32_t)\00", align 1
@.str.2 = private unnamed_addr constant [17 x i8] c"(((s)&1U) == 0U)\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"x == y\00", align 1
@__PRETTY_FUNCTION__.fini = private unnamed_addr constant [16 x i8] c"void fini(void)\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"x == 2\00", align 1
@.str.5 = private unnamed_addr constant [21 x i8] c"(((count)&1U) == 0U)\00", align 1
@.str.6 = private unnamed_addr constant [72 x i8] c"/home/stefano/huawei/libvsync/spinlock/include/vsync/spinlock/seqlock.h\00", align 1
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
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !54, metadata !DIExpression()), !dbg !55
  br label %3, !dbg !56

3:                                                ; preds = %1
  br label %4, !dbg !57

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !59
  br label %6, !dbg !59

6:                                                ; preds = %4
  br label %7, !dbg !61

7:                                                ; preds = %6
  br label %8, !dbg !59

8:                                                ; preds = %7
  br label %9, !dbg !57

9:                                                ; preds = %8
  ret void, !dbg !63
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_release(i32 noundef %0) #0 !dbg !64 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !65, metadata !DIExpression()), !dbg !66
  br label %3, !dbg !67

3:                                                ; preds = %1
  br label %4, !dbg !68

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !70
  br label %6, !dbg !70

6:                                                ; preds = %4
  br label %7, !dbg !72

7:                                                ; preds = %6
  br label %8, !dbg !70

8:                                                ; preds = %7
  br label %9, !dbg !68

9:                                                ; preds = %8
  ret void, !dbg !74
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_acquire(i32 noundef %0) #0 !dbg !75 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !76, metadata !DIExpression()), !dbg !77
  br label %3, !dbg !78

3:                                                ; preds = %1
  br label %4, !dbg !79

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !81
  br label %6, !dbg !81

6:                                                ; preds = %4
  br label %7, !dbg !83

7:                                                ; preds = %6
  br label %8, !dbg !81

8:                                                ; preds = %7
  br label %9, !dbg !79

9:                                                ; preds = %8
  ret void, !dbg !85
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_release(i32 noundef %0) #0 !dbg !86 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !87, metadata !DIExpression()), !dbg !88
  br label %3, !dbg !89

3:                                                ; preds = %1
  br label %4, !dbg !90

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !92
  br label %6, !dbg !92

6:                                                ; preds = %4
  br label %7, !dbg !94

7:                                                ; preds = %6
  br label %8, !dbg !92

8:                                                ; preds = %7
  br label %9, !dbg !90

9:                                                ; preds = %8
  ret void, !dbg !96
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !97 {
  %1 = alloca i32, align 4
  %2 = alloca [4 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [4 x i64]* %2, metadata !101, metadata !DIExpression()), !dbg !107
  call void @init(), !dbg !108
  call void @llvm.dbg.declare(metadata i64* %3, metadata !109, metadata !DIExpression()), !dbg !111
  store i64 0, i64* %3, align 8, !dbg !111
  br label %6, !dbg !112

6:                                                ; preds = %15, %0
  %7 = load i64, i64* %3, align 8, !dbg !113
  %8 = icmp ult i64 %7, 2, !dbg !115
  br i1 %8, label %9, label %18, !dbg !116

9:                                                ; preds = %6
  %10 = load i64, i64* %3, align 8, !dbg !117
  %11 = getelementptr inbounds [4 x i64], [4 x i64]* %2, i64 0, i64 %10, !dbg !119
  %12 = load i64, i64* %3, align 8, !dbg !120
  %13 = inttoptr i64 %12 to i8*, !dbg !121
  %14 = call i32 @pthread_create(i64* noundef %11, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef %13) #5, !dbg !122
  br label %15, !dbg !123

15:                                               ; preds = %9
  %16 = load i64, i64* %3, align 8, !dbg !124
  %17 = add i64 %16, 1, !dbg !124
  store i64 %17, i64* %3, align 8, !dbg !124
  br label %6, !dbg !125, !llvm.loop !126

18:                                               ; preds = %6
  call void @llvm.dbg.declare(metadata i64* %4, metadata !129, metadata !DIExpression()), !dbg !131
  store i64 2, i64* %4, align 8, !dbg !131
  br label %19, !dbg !132

19:                                               ; preds = %28, %18
  %20 = load i64, i64* %4, align 8, !dbg !133
  %21 = icmp ult i64 %20, 4, !dbg !135
  br i1 %21, label %22, label %31, !dbg !136

22:                                               ; preds = %19
  %23 = load i64, i64* %4, align 8, !dbg !137
  %24 = getelementptr inbounds [4 x i64], [4 x i64]* %2, i64 0, i64 %23, !dbg !139
  %25 = load i64, i64* %4, align 8, !dbg !140
  %26 = inttoptr i64 %25 to i8*, !dbg !141
  %27 = call i32 @pthread_create(i64* noundef %24, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef %26) #5, !dbg !142
  br label %28, !dbg !143

28:                                               ; preds = %22
  %29 = load i64, i64* %4, align 8, !dbg !144
  %30 = add i64 %29, 1, !dbg !144
  store i64 %30, i64* %4, align 8, !dbg !144
  br label %19, !dbg !145, !llvm.loop !146

31:                                               ; preds = %19
  call void @post(), !dbg !148
  call void @llvm.dbg.declare(metadata i64* %5, metadata !149, metadata !DIExpression()), !dbg !151
  store i64 0, i64* %5, align 8, !dbg !151
  br label %32, !dbg !152

32:                                               ; preds = %40, %31
  %33 = load i64, i64* %5, align 8, !dbg !153
  %34 = icmp ult i64 %33, 4, !dbg !155
  br i1 %34, label %35, label %43, !dbg !156

35:                                               ; preds = %32
  %36 = load i64, i64* %5, align 8, !dbg !157
  %37 = getelementptr inbounds [4 x i64], [4 x i64]* %2, i64 0, i64 %36, !dbg !159
  %38 = load i64, i64* %37, align 8, !dbg !159
  %39 = call i32 @pthread_join(i64 noundef %38, i8** noundef null), !dbg !160
  br label %40, !dbg !161

40:                                               ; preds = %35
  %41 = load i64, i64* %5, align 8, !dbg !162
  %42 = add i64 %41, 1, !dbg !162
  store i64 %42, i64* %5, align 8, !dbg !162
  br label %32, !dbg !163, !llvm.loop !164

43:                                               ; preds = %32
  call void @check(), !dbg !166
  call void @fini(), !dbg !167
  ret i32 0, !dbg !168
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal i8* @writer(i8* noundef %0) #0 !dbg !169 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !172, metadata !DIExpression()), !dbg !173
  call void @llvm.dbg.declare(metadata i32* %3, metadata !174, metadata !DIExpression()), !dbg !175
  %4 = load i8*, i8** %2, align 8, !dbg !176
  %5 = ptrtoint i8* %4 to i64, !dbg !177
  %6 = trunc i64 %5 to i32, !dbg !178
  store i32 %6, i32* %3, align 4, !dbg !175
  %7 = load i32, i32* %3, align 4, !dbg !179
  call void @writer_acquire(i32 noundef %7), !dbg !180
  %8 = load i32, i32* %3, align 4, !dbg !181
  call void @writer_cs(i32 noundef %8), !dbg !182
  %9 = load i32, i32* %3, align 4, !dbg !183
  call void @writer_release(i32 noundef %9), !dbg !184
  ret i8* null, !dbg !185
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @reader(i8* noundef %0) #0 !dbg !186 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !187, metadata !DIExpression()), !dbg !188
  call void @llvm.dbg.declare(metadata i32* %3, metadata !189, metadata !DIExpression()), !dbg !190
  %4 = load i8*, i8** %2, align 8, !dbg !191
  %5 = ptrtoint i8* %4 to i64, !dbg !192
  %6 = trunc i64 %5 to i32, !dbg !193
  store i32 %6, i32* %3, align 4, !dbg !190
  %7 = load i32, i32* %3, align 4, !dbg !194
  call void @reader_acquire(i32 noundef %7), !dbg !195
  %8 = load i32, i32* %3, align 4, !dbg !196
  call void @reader_cs(i32 noundef %8), !dbg !197
  %9 = load i32, i32* %3, align 4, !dbg !198
  call void @reader_release(i32 noundef %9), !dbg !199
  ret i8* null, !dbg !200
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !201 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %1, metadata !202, metadata !DIExpression()), !dbg !203
  %3 = load i32, i32* @g_cs_x, align 4, !dbg !204
  store i32 %3, i32* %1, align 4, !dbg !203
  call void @llvm.dbg.declare(metadata i32* %2, metadata !205, metadata !DIExpression()), !dbg !206
  %4 = load i32, i32* @g_cs_y, align 4, !dbg !207
  store i32 %4, i32* %2, align 4, !dbg !206
  %5 = load i32, i32* %1, align 4, !dbg !208
  %6 = load i32, i32* %2, align 4, !dbg !208
  %7 = icmp eq i32 %5, %6, !dbg !208
  br i1 %7, label %8, label %9, !dbg !211

8:                                                ; preds = %0
  br label %10, !dbg !211

9:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 50, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.fini, i64 0, i64 0)) #6, !dbg !208
  unreachable, !dbg !208

10:                                               ; preds = %8
  %11 = load i32, i32* %1, align 4, !dbg !212
  %12 = icmp eq i32 %11, 2, !dbg !212
  br i1 %12, label %13, label %14, !dbg !215

13:                                               ; preds = %10
  br label %15, !dbg !215

14:                                               ; preds = %10
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 51, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__.fini, i64 0, i64 0)) #6, !dbg !212
  unreachable, !dbg !212

15:                                               ; preds = %13
  br label %16, !dbg !216

16:                                               ; preds = %15
  br label %17, !dbg !217

17:                                               ; preds = %16
  %18 = load i32, i32* %1, align 4, !dbg !219
  br label %19, !dbg !219

19:                                               ; preds = %17
  %20 = load i32, i32* %2, align 4, !dbg !221
  br label %21, !dbg !221

21:                                               ; preds = %19
  br label %22, !dbg !223

22:                                               ; preds = %21
  br label %23, !dbg !221

23:                                               ; preds = %22
  br label %24, !dbg !219

24:                                               ; preds = %23
  br label %25, !dbg !217

25:                                               ; preds = %24
  ret void, !dbg !225
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_cs(i32 noundef %0) #0 !dbg !226 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !227, metadata !DIExpression()), !dbg !228
  call void @seqlock_acquire(%struct.seqlock_s* noundef @lock), !dbg !229
  %3 = load i32, i32* @g_cs_x, align 4, !dbg !230
  %4 = add i32 %3, 1, !dbg !230
  store i32 %4, i32* @g_cs_x, align 4, !dbg !230
  %5 = load i32, i32* @g_cs_y, align 4, !dbg !231
  %6 = add i32 %5, 1, !dbg !231
  store i32 %6, i32* @g_cs_y, align 4, !dbg !231
  call void @seqlock_release(%struct.seqlock_s* noundef @lock), !dbg !232
  br label %7, !dbg !233

7:                                                ; preds = %1
  br label %8, !dbg !234

8:                                                ; preds = %7
  %9 = load i32, i32* %2, align 4, !dbg !236
  br label %10, !dbg !236

10:                                               ; preds = %8
  br label %11, !dbg !238

11:                                               ; preds = %10
  br label %12, !dbg !236

12:                                               ; preds = %11
  br label %13, !dbg !234

13:                                               ; preds = %12
  ret void, !dbg !240
}

; Function Attrs: noinline nounwind uwtable
define internal void @seqlock_acquire(%struct.seqlock_s* noundef %0) #0 !dbg !241 {
  %2 = alloca %struct.seqlock_s*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %struct.seqlock_s* %0, %struct.seqlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.seqlock_s** %2, metadata !245, metadata !DIExpression()), !dbg !246
  call void @llvm.dbg.declare(metadata i32* %3, metadata !247, metadata !DIExpression()), !dbg !249
  store i32 0, i32* %3, align 4, !dbg !249
  call void @llvm.dbg.declare(metadata i32* %4, metadata !250, metadata !DIExpression()), !dbg !251
  store i32 0, i32* %4, align 4, !dbg !251
  br label %5, !dbg !252

5:                                                ; preds = %19, %1
  %6 = load %struct.seqlock_s*, %struct.seqlock_s** %2, align 8, !dbg !253
  %7 = call i32 @_seqlock_await_even(%struct.seqlock_s* noundef %6), !dbg !255
  store i32 %7, i32* %3, align 4, !dbg !256
  %8 = load %struct.seqlock_s*, %struct.seqlock_s** %2, align 8, !dbg !257
  %9 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %8, i32 0, i32 0, !dbg !258
  %10 = load i32, i32* %3, align 4, !dbg !259
  %11 = load i32, i32* %3, align 4, !dbg !260
  %12 = add i32 %11, 1, !dbg !261
  %13 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %9, i32 noundef %10, i32 noundef %12), !dbg !262
  store i32 %13, i32* %4, align 4, !dbg !263
  %14 = load i32, i32* %4, align 4, !dbg !264
  %15 = load i32, i32* %3, align 4, !dbg !266
  %16 = icmp eq i32 %14, %15, !dbg !267
  br i1 %16, label %17, label %18, !dbg !268

17:                                               ; preds = %5
  br label %20, !dbg !269

18:                                               ; preds = %5
  br label %19, !dbg !271

19:                                               ; preds = %18
  br i1 true, label %5, label %20, !dbg !271, !llvm.loop !272

20:                                               ; preds = %19, %17
  call void @vatomic_fence_rel(), !dbg !274
  ret void, !dbg !275
}

; Function Attrs: noinline nounwind uwtable
define internal void @seqlock_release(%struct.seqlock_s* noundef %0) #0 !dbg !276 {
  %2 = alloca %struct.seqlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.seqlock_s* %0, %struct.seqlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.seqlock_s** %2, metadata !277, metadata !DIExpression()), !dbg !278
  call void @llvm.dbg.declare(metadata i32* %3, metadata !279, metadata !DIExpression()), !dbg !280
  %4 = load %struct.seqlock_s*, %struct.seqlock_s** %2, align 8, !dbg !281
  %5 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %4, i32 0, i32 0, !dbg !282
  %6 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %5), !dbg !283
  store i32 %6, i32* %3, align 4, !dbg !280
  %7 = load i32, i32* %3, align 4, !dbg !284
  %8 = zext i32 %7 to i64, !dbg !284
  %9 = and i64 %8, 1, !dbg !284
  %10 = icmp eq i64 %9, 1, !dbg !284
  br i1 %10, label %11, label %12, !dbg !287

11:                                               ; preds = %1
  br label %13, !dbg !287

12:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.7, i64 0, i64 0), i8* noundef getelementptr inbounds ([72 x i8], [72 x i8]* @.str.6, i64 0, i64 0), i32 noundef 118, i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @__PRETTY_FUNCTION__.seqlock_release, i64 0, i64 0)) #6, !dbg !284
  unreachable, !dbg !284

13:                                               ; preds = %11
  %14 = load %struct.seqlock_s*, %struct.seqlock_s** %2, align 8, !dbg !288
  %15 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %14, i32 0, i32 0, !dbg !289
  %16 = load i32, i32* %3, align 4, !dbg !290
  %17 = add i32 %16, 1, !dbg !291
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %15, i32 noundef %17), !dbg !292
  ret void, !dbg !293
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_cs(i32 noundef %0) #0 !dbg !294 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !295, metadata !DIExpression()), !dbg !296
  call void @llvm.dbg.declare(metadata i32* %3, metadata !297, metadata !DIExpression()), !dbg !298
  store i32 0, i32* %3, align 4, !dbg !298
  call void @llvm.dbg.declare(metadata i32* %4, metadata !299, metadata !DIExpression()), !dbg !300
  store i32 0, i32* %4, align 4, !dbg !300
  call void @llvm.dbg.declare(metadata i32* %5, metadata !301, metadata !DIExpression()), !dbg !302
  store i32 0, i32* %5, align 4, !dbg !302
  br label %6, !dbg !303

6:                                                ; preds = %10, %1
  %7 = call i32 @seqlock_rbegin(%struct.seqlock_s* noundef @lock), !dbg !304
  store i32 %7, i32* %5, align 4, !dbg !306
  %8 = load i32, i32* @g_cs_x, align 4, !dbg !307
  store i32 %8, i32* %3, align 4, !dbg !308
  %9 = load i32, i32* @g_cs_y, align 4, !dbg !309
  store i32 %9, i32* %4, align 4, !dbg !310
  br label %10, !dbg !311

10:                                               ; preds = %6
  %11 = load i32, i32* %5, align 4, !dbg !312
  %12 = call zeroext i1 @seqlock_rend(%struct.seqlock_s* noundef @lock, i32 noundef %11), !dbg !312
  %13 = xor i1 %12, true, !dbg !312
  br i1 %13, label %6, label %14, !dbg !311, !llvm.loop !313

14:                                               ; preds = %10
  %15 = load i32, i32* %3, align 4, !dbg !314
  %16 = load i32, i32* %4, align 4, !dbg !314
  %17 = icmp eq i32 %15, %16, !dbg !314
  br i1 %17, label %18, label %19, !dbg !317

18:                                               ; preds = %14
  br label %20, !dbg !317

19:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 40, i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @__PRETTY_FUNCTION__.reader_cs, i64 0, i64 0)) #6, !dbg !314
  unreachable, !dbg !314

20:                                               ; preds = %18
  %21 = load i32, i32* %5, align 4, !dbg !318
  %22 = and i32 %21, 1, !dbg !318
  %23 = icmp eq i32 %22, 0, !dbg !318
  br i1 %23, label %24, label %25, !dbg !321

24:                                               ; preds = %20
  br label %26, !dbg !321

25:                                               ; preds = %20
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i64 0, i64 0), i32 noundef 41, i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @__PRETTY_FUNCTION__.reader_cs, i64 0, i64 0)) #6, !dbg !318
  unreachable, !dbg !318

26:                                               ; preds = %24
  br label %27, !dbg !322

27:                                               ; preds = %26
  br label %28, !dbg !323

28:                                               ; preds = %27
  %29 = load i32, i32* %2, align 4, !dbg !325
  br label %30, !dbg !325

30:                                               ; preds = %28
  %31 = load i32, i32* %3, align 4, !dbg !327
  br label %32, !dbg !327

32:                                               ; preds = %30
  %33 = load i32, i32* %4, align 4, !dbg !329
  br label %34, !dbg !329

34:                                               ; preds = %32
  br label %35, !dbg !331

35:                                               ; preds = %34
  br label %36, !dbg !329

36:                                               ; preds = %35
  br label %37, !dbg !327

37:                                               ; preds = %36
  br label %38, !dbg !325

38:                                               ; preds = %37
  br label %39, !dbg !323

39:                                               ; preds = %38
  ret void, !dbg !333
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @seqlock_rbegin(%struct.seqlock_s* noundef %0) #0 !dbg !334 {
  %2 = alloca %struct.seqlock_s*, align 8
  store %struct.seqlock_s* %0, %struct.seqlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.seqlock_s** %2, metadata !337, metadata !DIExpression()), !dbg !338
  %3 = load %struct.seqlock_s*, %struct.seqlock_s** %2, align 8, !dbg !339
  %4 = call i32 @_seqlock_await_even(%struct.seqlock_s* noundef %3), !dbg !340
  ret i32 %4, !dbg !341
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @seqlock_rend(%struct.seqlock_s* noundef %0, i32 noundef %1) #0 !dbg !342 {
  %3 = alloca %struct.seqlock_s*, align 8
  %4 = alloca i32, align 4
  store %struct.seqlock_s* %0, %struct.seqlock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.seqlock_s** %3, metadata !347, metadata !DIExpression()), !dbg !348
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !349, metadata !DIExpression()), !dbg !350
  %5 = load i32, i32* %4, align 4, !dbg !351
  %6 = and i32 %5, 1, !dbg !351
  %7 = icmp eq i32 %6, 0, !dbg !351
  br i1 %7, label %8, label %9, !dbg !354

8:                                                ; preds = %2
  br label %10, !dbg !354

9:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.8, i64 0, i64 0), i8* noundef getelementptr inbounds ([72 x i8], [72 x i8]* @.str.6, i64 0, i64 0), i32 noundef 156, i8* noundef getelementptr inbounds ([46 x i8], [46 x i8]* @__PRETTY_FUNCTION__.seqlock_rend, i64 0, i64 0)) #6, !dbg !351
  unreachable, !dbg !351

10:                                               ; preds = %8
  call void @vatomic_fence_acq(), !dbg !355
  %11 = load %struct.seqlock_s*, %struct.seqlock_s** %3, align 8, !dbg !356
  %12 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %11, i32 0, i32 0, !dbg !357
  %13 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %12), !dbg !358
  %14 = load i32, i32* %4, align 4, !dbg !359
  %15 = icmp eq i32 %13, %14, !dbg !360
  ret i1 %15, !dbg !361
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @_seqlock_await_even(%struct.seqlock_s* noundef %0) #0 !dbg !362 {
  %2 = alloca %struct.seqlock_s*, align 8
  %3 = alloca i32, align 4
  store %struct.seqlock_s* %0, %struct.seqlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.seqlock_s** %2, metadata !363, metadata !DIExpression()), !dbg !364
  call void @llvm.dbg.declare(metadata i32* %3, metadata !365, metadata !DIExpression()), !dbg !366
  %4 = load %struct.seqlock_s*, %struct.seqlock_s** %2, align 8, !dbg !367
  %5 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %4, i32 0, i32 0, !dbg !368
  %6 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %5), !dbg !369
  store i32 %6, i32* %3, align 4, !dbg !366
  br label %7, !dbg !370

7:                                                ; preds = %11, %1
  %8 = load i32, i32* %3, align 4, !dbg !371
  %9 = and i32 %8, 1, !dbg !371
  %10 = icmp eq i32 %9, 1, !dbg !371
  br i1 %10, label %11, label %16, !dbg !370

11:                                               ; preds = %7
  %12 = load %struct.seqlock_s*, %struct.seqlock_s** %2, align 8, !dbg !372
  %13 = getelementptr inbounds %struct.seqlock_s, %struct.seqlock_s* %12, i32 0, i32 0, !dbg !374
  %14 = load i32, i32* %3, align 4, !dbg !375
  %15 = call i32 @vatomic32_await_neq_acq(%struct.vatomic32_s* noundef %13, i32 noundef %14), !dbg !376
  store i32 %15, i32* %3, align 4, !dbg !377
  br label %7, !dbg !370, !llvm.loop !378

16:                                               ; preds = %7
  %17 = load i32, i32* %3, align 4, !dbg !380
  %18 = and i32 %17, 1, !dbg !380
  %19 = icmp eq i32 %18, 0, !dbg !380
  br i1 %19, label %20, label %21, !dbg !383

20:                                               ; preds = %16
  br label %22, !dbg !383

21:                                               ; preds = %16
  call void @__assert_fail(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([72 x i8], [72 x i8]* @.str.6, i64 0, i64 0), i32 noundef 54, i8* noundef getelementptr inbounds ([44 x i8], [44 x i8]* @__PRETTY_FUNCTION__._seqlock_await_even, i64 0, i64 0)) #6, !dbg !380
  unreachable, !dbg !380

22:                                               ; preds = %20
  %23 = load i32, i32* %3, align 4, !dbg !384
  ret i32 %23, !dbg !385
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !386 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !391, metadata !DIExpression()), !dbg !392
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !393, metadata !DIExpression()), !dbg !394
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !395, metadata !DIExpression()), !dbg !396
  call void @llvm.dbg.declare(metadata i32* %7, metadata !397, metadata !DIExpression()), !dbg !398
  call void @llvm.dbg.declare(metadata i32* %8, metadata !399, metadata !DIExpression()), !dbg !400
  %9 = load i32, i32* %6, align 4, !dbg !401
  %10 = load i32, i32* %5, align 4, !dbg !402
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !403
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !404
  %13 = load i32, i32* %12, align 4, !dbg !404
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldaxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #5, !dbg !405, !srcloc !406
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !405
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !405
  store i32 %15, i32* %7, align 4, !dbg !405
  store i32 %16, i32* %8, align 4, !dbg !405
  %17 = load i32, i32* %7, align 4, !dbg !407
  ret i32 %17, !dbg !408
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic_fence_rel() #0 !dbg !409 {
  call void asm sideeffect "dmb ish", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !411, !srcloc !412
  ret void, !dbg !413
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !414 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !419, metadata !DIExpression()), !dbg !420
  call void @llvm.dbg.declare(metadata i32* %3, metadata !421, metadata !DIExpression()), !dbg !422
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !423
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !424
  %6 = load i32, i32* %5, align 4, !dbg !424
  %7 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #5, !dbg !425, !srcloc !426
  store i32 %7, i32* %3, align 4, !dbg !425
  %8 = load i32, i32* %3, align 4, !dbg !427
  ret i32 %8, !dbg !428
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_neq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !429 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !432, metadata !DIExpression()), !dbg !433
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !434, metadata !DIExpression()), !dbg !435
  call void @llvm.dbg.declare(metadata i32* %5, metadata !436, metadata !DIExpression()), !dbg !437
  %6 = load i32, i32* %4, align 4, !dbg !438
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !439
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !440
  %9 = load i32, i32* %8, align 4, !dbg !440
  %10 = call i32 asm sideeffect "1:\0Aldar ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.eq 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #5, !dbg !441, !srcloc !442
  store i32 %10, i32* %5, align 4, !dbg !441
  %11 = load i32, i32* %5, align 4, !dbg !443
  ret i32 %11, !dbg !444
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !445 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !446, metadata !DIExpression()), !dbg !447
  call void @llvm.dbg.declare(metadata i32* %3, metadata !448, metadata !DIExpression()), !dbg !449
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !450
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !451
  %6 = load i32, i32* %5, align 4, !dbg !451
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #5, !dbg !452, !srcloc !453
  store i32 %7, i32* %3, align 4, !dbg !452
  %8 = load i32, i32* %3, align 4, !dbg !454
  ret i32 %8, !dbg !455
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !456 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !459, metadata !DIExpression()), !dbg !460
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !461, metadata !DIExpression()), !dbg !462
  %5 = load i32, i32* %4, align 4, !dbg !463
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !464
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !465
  %8 = load i32, i32* %7, align 4, !dbg !465
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #5, !dbg !466, !srcloc !467
  ret void, !dbg !468
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic_fence_acq() #0 !dbg !469 {
  call void asm sideeffect "dmb ishld", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !470, !srcloc !471
  ret void, !dbg !472
}

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
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/spinlock/test/seqlock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "677e0c974cc483412160a48b339bc234")
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
!19 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !20, line: 13, type: !6, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "spinlock/test/seqlock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "677e0c974cc483412160a48b339bc234")
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !20, line: 14, type: !6, isLocal: false, isDefinition: true)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "seqlock_t", file: !24, line: 33, baseType: !25)
!24 = !DIFile(filename: "spinlock/include/vsync/spinlock/seqlock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "61d628e3ec24c302304f26d6bf3b3da0")
!25 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "seqlock_s", file: !24, line: 30, size: 32, elements: !26)
!26 = !{!27}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "seqcount", scope: !25, file: !24, line: 32, baseType: !28, size: 32, align: 32)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !29, line: 34, baseType: !30)
!29 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
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
!40 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!41 = distinct !DISubprogram(name: "init", scope: !42, file: !42, line: 54, type: !43, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!42 = !DIFile(filename: "utils/include/test/boilerplate/reader_writer.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4e1dc695be02c115383d13b32ef6a829")
!43 = !DISubroutineType(types: !44)
!44 = !{null}
!45 = !{}
!46 = !DILocation(line: 56, column: 1, scope: !41)
!47 = distinct !DISubprogram(name: "post", scope: !42, file: !42, line: 63, type: !43, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!48 = !DILocation(line: 65, column: 1, scope: !47)
!49 = distinct !DISubprogram(name: "check", scope: !42, file: !42, line: 81, type: !43, scopeLine: 82, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!50 = !DILocation(line: 83, column: 1, scope: !49)
!51 = distinct !DISubprogram(name: "writer_acquire", scope: !42, file: !42, line: 85, type: !52, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!52 = !DISubroutineType(types: !53)
!53 = !{null, !6}
!54 = !DILocalVariable(name: "tid", arg: 1, scope: !51, file: !42, line: 85, type: !6)
!55 = !DILocation(line: 85, column: 26, scope: !51)
!56 = !DILocation(line: 87, column: 5, scope: !51)
!57 = !DILocation(line: 87, column: 5, scope: !58)
!58 = distinct !DILexicalBlock(scope: !51, file: !42, line: 87, column: 5)
!59 = !DILocation(line: 87, column: 5, scope: !60)
!60 = distinct !DILexicalBlock(scope: !58, file: !42, line: 87, column: 5)
!61 = !DILocation(line: 87, column: 5, scope: !62)
!62 = distinct !DILexicalBlock(scope: !60, file: !42, line: 87, column: 5)
!63 = !DILocation(line: 88, column: 1, scope: !51)
!64 = distinct !DISubprogram(name: "writer_release", scope: !42, file: !42, line: 90, type: !52, scopeLine: 91, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!65 = !DILocalVariable(name: "tid", arg: 1, scope: !64, file: !42, line: 90, type: !6)
!66 = !DILocation(line: 90, column: 26, scope: !64)
!67 = !DILocation(line: 92, column: 5, scope: !64)
!68 = !DILocation(line: 92, column: 5, scope: !69)
!69 = distinct !DILexicalBlock(scope: !64, file: !42, line: 92, column: 5)
!70 = !DILocation(line: 92, column: 5, scope: !71)
!71 = distinct !DILexicalBlock(scope: !69, file: !42, line: 92, column: 5)
!72 = !DILocation(line: 92, column: 5, scope: !73)
!73 = distinct !DILexicalBlock(scope: !71, file: !42, line: 92, column: 5)
!74 = !DILocation(line: 93, column: 1, scope: !64)
!75 = distinct !DISubprogram(name: "reader_acquire", scope: !42, file: !42, line: 95, type: !52, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!76 = !DILocalVariable(name: "tid", arg: 1, scope: !75, file: !42, line: 95, type: !6)
!77 = !DILocation(line: 95, column: 26, scope: !75)
!78 = !DILocation(line: 97, column: 5, scope: !75)
!79 = !DILocation(line: 97, column: 5, scope: !80)
!80 = distinct !DILexicalBlock(scope: !75, file: !42, line: 97, column: 5)
!81 = !DILocation(line: 97, column: 5, scope: !82)
!82 = distinct !DILexicalBlock(scope: !80, file: !42, line: 97, column: 5)
!83 = !DILocation(line: 97, column: 5, scope: !84)
!84 = distinct !DILexicalBlock(scope: !82, file: !42, line: 97, column: 5)
!85 = !DILocation(line: 98, column: 1, scope: !75)
!86 = distinct !DISubprogram(name: "reader_release", scope: !42, file: !42, line: 100, type: !52, scopeLine: 101, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!87 = !DILocalVariable(name: "tid", arg: 1, scope: !86, file: !42, line: 100, type: !6)
!88 = !DILocation(line: 100, column: 26, scope: !86)
!89 = !DILocation(line: 102, column: 5, scope: !86)
!90 = !DILocation(line: 102, column: 5, scope: !91)
!91 = distinct !DILexicalBlock(scope: !86, file: !42, line: 102, column: 5)
!92 = !DILocation(line: 102, column: 5, scope: !93)
!93 = distinct !DILexicalBlock(scope: !91, file: !42, line: 102, column: 5)
!94 = !DILocation(line: 102, column: 5, scope: !95)
!95 = distinct !DILexicalBlock(scope: !93, file: !42, line: 102, column: 5)
!96 = !DILocation(line: 103, column: 1, scope: !86)
!97 = distinct !DISubprogram(name: "main", scope: !42, file: !42, line: 158, type: !98, scopeLine: 159, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!98 = !DISubroutineType(types: !99)
!99 = !{!100}
!100 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!101 = !DILocalVariable(name: "t", scope: !97, file: !42, line: 160, type: !102)
!102 = !DICompositeType(tag: DW_TAG_array_type, baseType: !103, size: 256, elements: !105)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !104, line: 27, baseType: !16)
!104 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!105 = !{!106}
!106 = !DISubrange(count: 4)
!107 = !DILocation(line: 160, column: 15, scope: !97)
!108 = !DILocation(line: 167, column: 5, scope: !97)
!109 = !DILocalVariable(name: "i", scope: !110, file: !42, line: 169, type: !13)
!110 = distinct !DILexicalBlock(scope: !97, file: !42, line: 169, column: 5)
!111 = !DILocation(line: 169, column: 21, scope: !110)
!112 = !DILocation(line: 169, column: 10, scope: !110)
!113 = !DILocation(line: 169, column: 28, scope: !114)
!114 = distinct !DILexicalBlock(scope: !110, file: !42, line: 169, column: 5)
!115 = !DILocation(line: 169, column: 30, scope: !114)
!116 = !DILocation(line: 169, column: 5, scope: !110)
!117 = !DILocation(line: 170, column: 33, scope: !118)
!118 = distinct !DILexicalBlock(scope: !114, file: !42, line: 169, column: 47)
!119 = !DILocation(line: 170, column: 31, scope: !118)
!120 = !DILocation(line: 170, column: 56, scope: !118)
!121 = !DILocation(line: 170, column: 48, scope: !118)
!122 = !DILocation(line: 170, column: 15, scope: !118)
!123 = !DILocation(line: 171, column: 5, scope: !118)
!124 = !DILocation(line: 169, column: 43, scope: !114)
!125 = !DILocation(line: 169, column: 5, scope: !114)
!126 = distinct !{!126, !116, !127, !128}
!127 = !DILocation(line: 171, column: 5, scope: !110)
!128 = !{!"llvm.loop.mustprogress"}
!129 = !DILocalVariable(name: "i", scope: !130, file: !42, line: 173, type: !13)
!130 = distinct !DILexicalBlock(scope: !97, file: !42, line: 173, column: 5)
!131 = !DILocation(line: 173, column: 21, scope: !130)
!132 = !DILocation(line: 173, column: 10, scope: !130)
!133 = !DILocation(line: 173, column: 35, scope: !134)
!134 = distinct !DILexicalBlock(scope: !130, file: !42, line: 173, column: 5)
!135 = !DILocation(line: 173, column: 37, scope: !134)
!136 = !DILocation(line: 173, column: 5, scope: !130)
!137 = !DILocation(line: 174, column: 33, scope: !138)
!138 = distinct !DILexicalBlock(scope: !134, file: !42, line: 173, column: 54)
!139 = !DILocation(line: 174, column: 31, scope: !138)
!140 = !DILocation(line: 174, column: 56, scope: !138)
!141 = !DILocation(line: 174, column: 48, scope: !138)
!142 = !DILocation(line: 174, column: 15, scope: !138)
!143 = !DILocation(line: 175, column: 5, scope: !138)
!144 = !DILocation(line: 173, column: 50, scope: !134)
!145 = !DILocation(line: 173, column: 5, scope: !134)
!146 = distinct !{!146, !136, !147, !128}
!147 = !DILocation(line: 175, column: 5, scope: !130)
!148 = !DILocation(line: 177, column: 5, scope: !97)
!149 = !DILocalVariable(name: "i", scope: !150, file: !42, line: 179, type: !13)
!150 = distinct !DILexicalBlock(scope: !97, file: !42, line: 179, column: 5)
!151 = !DILocation(line: 179, column: 21, scope: !150)
!152 = !DILocation(line: 179, column: 10, scope: !150)
!153 = !DILocation(line: 179, column: 28, scope: !154)
!154 = distinct !DILexicalBlock(scope: !150, file: !42, line: 179, column: 5)
!155 = !DILocation(line: 179, column: 30, scope: !154)
!156 = !DILocation(line: 179, column: 5, scope: !150)
!157 = !DILocation(line: 180, column: 30, scope: !158)
!158 = distinct !DILexicalBlock(scope: !154, file: !42, line: 179, column: 47)
!159 = !DILocation(line: 180, column: 28, scope: !158)
!160 = !DILocation(line: 180, column: 15, scope: !158)
!161 = !DILocation(line: 181, column: 5, scope: !158)
!162 = !DILocation(line: 179, column: 43, scope: !154)
!163 = !DILocation(line: 179, column: 5, scope: !154)
!164 = distinct !{!164, !156, !165, !128}
!165 = !DILocation(line: 181, column: 5, scope: !150)
!166 = !DILocation(line: 188, column: 5, scope: !97)
!167 = !DILocation(line: 189, column: 5, scope: !97)
!168 = !DILocation(line: 191, column: 5, scope: !97)
!169 = distinct !DISubprogram(name: "writer", scope: !42, file: !42, line: 137, type: !170, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!170 = !DISubroutineType(types: !171)
!171 = !{!5, !5}
!172 = !DILocalVariable(name: "arg", arg: 1, scope: !169, file: !42, line: 137, type: !5)
!173 = !DILocation(line: 137, column: 14, scope: !169)
!174 = !DILocalVariable(name: "tid", scope: !169, file: !42, line: 139, type: !6)
!175 = !DILocation(line: 139, column: 15, scope: !169)
!176 = !DILocation(line: 139, column: 44, scope: !169)
!177 = !DILocation(line: 139, column: 32, scope: !169)
!178 = !DILocation(line: 139, column: 21, scope: !169)
!179 = !DILocation(line: 140, column: 20, scope: !169)
!180 = !DILocation(line: 140, column: 5, scope: !169)
!181 = !DILocation(line: 141, column: 15, scope: !169)
!182 = !DILocation(line: 141, column: 5, scope: !169)
!183 = !DILocation(line: 142, column: 20, scope: !169)
!184 = !DILocation(line: 142, column: 5, scope: !169)
!185 = !DILocation(line: 143, column: 5, scope: !169)
!186 = distinct !DISubprogram(name: "reader", scope: !42, file: !42, line: 147, type: !170, scopeLine: 148, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!187 = !DILocalVariable(name: "arg", arg: 1, scope: !186, file: !42, line: 147, type: !5)
!188 = !DILocation(line: 147, column: 14, scope: !186)
!189 = !DILocalVariable(name: "tid", scope: !186, file: !42, line: 149, type: !6)
!190 = !DILocation(line: 149, column: 15, scope: !186)
!191 = !DILocation(line: 149, column: 44, scope: !186)
!192 = !DILocation(line: 149, column: 32, scope: !186)
!193 = !DILocation(line: 149, column: 21, scope: !186)
!194 = !DILocation(line: 150, column: 20, scope: !186)
!195 = !DILocation(line: 150, column: 5, scope: !186)
!196 = !DILocation(line: 151, column: 15, scope: !186)
!197 = !DILocation(line: 151, column: 5, scope: !186)
!198 = !DILocation(line: 152, column: 20, scope: !186)
!199 = !DILocation(line: 152, column: 5, scope: !186)
!200 = !DILocation(line: 154, column: 5, scope: !186)
!201 = distinct !DISubprogram(name: "fini", scope: !20, file: !20, line: 46, type: !43, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!202 = !DILocalVariable(name: "x", scope: !201, file: !20, line: 48, type: !6)
!203 = !DILocation(line: 48, column: 15, scope: !201)
!204 = !DILocation(line: 48, column: 19, scope: !201)
!205 = !DILocalVariable(name: "y", scope: !201, file: !20, line: 49, type: !6)
!206 = !DILocation(line: 49, column: 15, scope: !201)
!207 = !DILocation(line: 49, column: 19, scope: !201)
!208 = !DILocation(line: 50, column: 5, scope: !209)
!209 = distinct !DILexicalBlock(scope: !210, file: !20, line: 50, column: 5)
!210 = distinct !DILexicalBlock(scope: !201, file: !20, line: 50, column: 5)
!211 = !DILocation(line: 50, column: 5, scope: !210)
!212 = !DILocation(line: 51, column: 5, scope: !213)
!213 = distinct !DILexicalBlock(scope: !214, file: !20, line: 51, column: 5)
!214 = distinct !DILexicalBlock(scope: !201, file: !20, line: 51, column: 5)
!215 = !DILocation(line: 51, column: 5, scope: !214)
!216 = !DILocation(line: 52, column: 5, scope: !201)
!217 = !DILocation(line: 52, column: 5, scope: !218)
!218 = distinct !DILexicalBlock(scope: !201, file: !20, line: 52, column: 5)
!219 = !DILocation(line: 52, column: 5, scope: !220)
!220 = distinct !DILexicalBlock(scope: !218, file: !20, line: 52, column: 5)
!221 = !DILocation(line: 52, column: 5, scope: !222)
!222 = distinct !DILexicalBlock(scope: !220, file: !20, line: 52, column: 5)
!223 = !DILocation(line: 52, column: 5, scope: !224)
!224 = distinct !DILexicalBlock(scope: !222, file: !20, line: 52, column: 5)
!225 = !DILocation(line: 53, column: 1, scope: !201)
!226 = distinct !DISubprogram(name: "writer_cs", scope: !20, file: !20, line: 17, type: !52, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!227 = !DILocalVariable(name: "tid", arg: 1, scope: !226, file: !20, line: 17, type: !6)
!228 = !DILocation(line: 17, column: 21, scope: !226)
!229 = !DILocation(line: 19, column: 5, scope: !226)
!230 = !DILocation(line: 20, column: 11, scope: !226)
!231 = !DILocation(line: 21, column: 11, scope: !226)
!232 = !DILocation(line: 22, column: 5, scope: !226)
!233 = !DILocation(line: 23, column: 5, scope: !226)
!234 = !DILocation(line: 23, column: 5, scope: !235)
!235 = distinct !DILexicalBlock(scope: !226, file: !20, line: 23, column: 5)
!236 = !DILocation(line: 23, column: 5, scope: !237)
!237 = distinct !DILexicalBlock(scope: !235, file: !20, line: 23, column: 5)
!238 = !DILocation(line: 23, column: 5, scope: !239)
!239 = distinct !DILexicalBlock(scope: !237, file: !20, line: 23, column: 5)
!240 = !DILocation(line: 24, column: 1, scope: !226)
!241 = distinct !DISubprogram(name: "seqlock_acquire", scope: !24, file: !24, line: 81, type: !242, scopeLine: 82, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!242 = !DISubroutineType(types: !243)
!243 = !{null, !244}
!244 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!245 = !DILocalVariable(name: "seq", arg: 1, scope: !241, file: !24, line: 81, type: !244)
!246 = !DILocation(line: 81, column: 28, scope: !241)
!247 = !DILocalVariable(name: "count", scope: !241, file: !24, line: 83, type: !248)
!248 = !DIDerivedType(tag: DW_TAG_typedef, name: "seqvalue_t", file: !24, line: 28, baseType: !6)
!249 = !DILocation(line: 83, column: 16, scope: !241)
!250 = !DILocalVariable(name: "o_count", scope: !241, file: !24, line: 84, type: !248)
!251 = !DILocation(line: 84, column: 16, scope: !241)
!252 = !DILocation(line: 86, column: 5, scope: !241)
!253 = !DILocation(line: 88, column: 37, scope: !254)
!254 = distinct !DILexicalBlock(scope: !241, file: !24, line: 86, column: 8)
!255 = !DILocation(line: 88, column: 17, scope: !254)
!256 = !DILocation(line: 88, column: 15, scope: !254)
!257 = !DILocation(line: 91, column: 42, scope: !254)
!258 = !DILocation(line: 91, column: 47, scope: !254)
!259 = !DILocation(line: 91, column: 57, scope: !254)
!260 = !DILocation(line: 91, column: 64, scope: !254)
!261 = !DILocation(line: 91, column: 70, scope: !254)
!262 = !DILocation(line: 91, column: 19, scope: !254)
!263 = !DILocation(line: 91, column: 17, scope: !254)
!264 = !DILocation(line: 94, column: 13, scope: !265)
!265 = distinct !DILexicalBlock(scope: !254, file: !24, line: 94, column: 13)
!266 = !DILocation(line: 94, column: 24, scope: !265)
!267 = !DILocation(line: 94, column: 21, scope: !265)
!268 = !DILocation(line: 94, column: 13, scope: !254)
!269 = !DILocation(line: 95, column: 13, scope: !270)
!270 = distinct !DILexicalBlock(scope: !265, file: !24, line: 94, column: 31)
!271 = !DILocation(line: 97, column: 5, scope: !254)
!272 = distinct !{!272, !252, !273}
!273 = !DILocation(line: 97, column: 18, scope: !241)
!274 = !DILocation(line: 99, column: 5, scope: !241)
!275 = !DILocation(line: 100, column: 1, scope: !241)
!276 = distinct !DISubprogram(name: "seqlock_release", scope: !24, file: !24, line: 113, type: !242, scopeLine: 114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!277 = !DILocalVariable(name: "seq", arg: 1, scope: !276, file: !24, line: 113, type: !244)
!278 = !DILocation(line: 113, column: 28, scope: !276)
!279 = !DILocalVariable(name: "cur_val", scope: !276, file: !24, line: 117, type: !248)
!280 = !DILocation(line: 117, column: 16, scope: !276)
!281 = !DILocation(line: 117, column: 46, scope: !276)
!282 = !DILocation(line: 117, column: 51, scope: !276)
!283 = !DILocation(line: 117, column: 26, scope: !276)
!284 = !DILocation(line: 118, column: 5, scope: !285)
!285 = distinct !DILexicalBlock(scope: !286, file: !24, line: 118, column: 5)
!286 = distinct !DILexicalBlock(scope: !276, file: !24, line: 118, column: 5)
!287 = !DILocation(line: 118, column: 5, scope: !286)
!288 = !DILocation(line: 119, column: 26, scope: !276)
!289 = !DILocation(line: 119, column: 31, scope: !276)
!290 = !DILocation(line: 119, column: 41, scope: !276)
!291 = !DILocation(line: 119, column: 49, scope: !276)
!292 = !DILocation(line: 119, column: 5, scope: !276)
!293 = !DILocation(line: 122, column: 1, scope: !276)
!294 = distinct !DISubprogram(name: "reader_cs", scope: !20, file: !20, line: 27, type: !52, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!295 = !DILocalVariable(name: "tid", arg: 1, scope: !294, file: !20, line: 27, type: !6)
!296 = !DILocation(line: 27, column: 21, scope: !294)
!297 = !DILocalVariable(name: "a", scope: !294, file: !20, line: 29, type: !6)
!298 = !DILocation(line: 29, column: 15, scope: !294)
!299 = !DILocalVariable(name: "b", scope: !294, file: !20, line: 30, type: !6)
!300 = !DILocation(line: 30, column: 15, scope: !294)
!301 = !DILocalVariable(name: "s", scope: !294, file: !20, line: 31, type: !248)
!302 = !DILocation(line: 31, column: 16, scope: !294)
!303 = !DILocation(line: 33, column: 5, scope: !294)
!304 = !DILocation(line: 34, column: 13, scope: !305)
!305 = distinct !DILexicalBlock(scope: !294, file: !20, line: 33, column: 14)
!306 = !DILocation(line: 34, column: 11, scope: !305)
!307 = !DILocation(line: 35, column: 13, scope: !305)
!308 = !DILocation(line: 35, column: 11, scope: !305)
!309 = !DILocation(line: 36, column: 13, scope: !305)
!310 = !DILocation(line: 36, column: 11, scope: !305)
!311 = !DILocation(line: 37, column: 5, scope: !305)
!312 = !DILocation(line: 38, column: 5, scope: !294)
!313 = distinct !{!313, !303, !312, !128}
!314 = !DILocation(line: 40, column: 5, scope: !315)
!315 = distinct !DILexicalBlock(scope: !316, file: !20, line: 40, column: 5)
!316 = distinct !DILexicalBlock(scope: !294, file: !20, line: 40, column: 5)
!317 = !DILocation(line: 40, column: 5, scope: !316)
!318 = !DILocation(line: 41, column: 5, scope: !319)
!319 = distinct !DILexicalBlock(scope: !320, file: !20, line: 41, column: 5)
!320 = distinct !DILexicalBlock(scope: !294, file: !20, line: 41, column: 5)
!321 = !DILocation(line: 41, column: 5, scope: !320)
!322 = !DILocation(line: 42, column: 5, scope: !294)
!323 = !DILocation(line: 42, column: 5, scope: !324)
!324 = distinct !DILexicalBlock(scope: !294, file: !20, line: 42, column: 5)
!325 = !DILocation(line: 42, column: 5, scope: !326)
!326 = distinct !DILexicalBlock(scope: !324, file: !20, line: 42, column: 5)
!327 = !DILocation(line: 42, column: 5, scope: !328)
!328 = distinct !DILexicalBlock(scope: !326, file: !20, line: 42, column: 5)
!329 = !DILocation(line: 42, column: 5, scope: !330)
!330 = distinct !DILexicalBlock(scope: !328, file: !20, line: 42, column: 5)
!331 = !DILocation(line: 42, column: 5, scope: !332)
!332 = distinct !DILexicalBlock(scope: !330, file: !20, line: 42, column: 5)
!333 = !DILocation(line: 43, column: 1, scope: !294)
!334 = distinct !DISubprogram(name: "seqlock_rbegin", scope: !24, file: !24, line: 137, type: !335, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!335 = !DISubroutineType(types: !336)
!336 = !{!248, !244}
!337 = !DILocalVariable(name: "seq", arg: 1, scope: !334, file: !24, line: 137, type: !244)
!338 = !DILocation(line: 137, column: 27, scope: !334)
!339 = !DILocation(line: 139, column: 32, scope: !334)
!340 = !DILocation(line: 139, column: 12, scope: !334)
!341 = !DILocation(line: 139, column: 5, scope: !334)
!342 = distinct !DISubprogram(name: "seqlock_rend", scope: !24, file: !24, line: 154, type: !343, scopeLine: 155, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!343 = !DISubroutineType(types: !344)
!344 = !{!345, !244, !248}
!345 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !7, line: 44, baseType: !346)
!346 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!347 = !DILocalVariable(name: "seq", arg: 1, scope: !342, file: !24, line: 154, type: !244)
!348 = !DILocation(line: 154, column: 25, scope: !342)
!349 = !DILocalVariable(name: "sv", arg: 2, scope: !342, file: !24, line: 154, type: !248)
!350 = !DILocation(line: 154, column: 41, scope: !342)
!351 = !DILocation(line: 156, column: 5, scope: !352)
!352 = distinct !DILexicalBlock(scope: !353, file: !24, line: 156, column: 5)
!353 = distinct !DILexicalBlock(scope: !342, file: !24, line: 156, column: 5)
!354 = !DILocation(line: 156, column: 5, scope: !353)
!355 = !DILocation(line: 157, column: 5, scope: !342)
!356 = !DILocation(line: 160, column: 32, scope: !342)
!357 = !DILocation(line: 160, column: 37, scope: !342)
!358 = !DILocation(line: 160, column: 12, scope: !342)
!359 = !DILocation(line: 160, column: 50, scope: !342)
!360 = !DILocation(line: 160, column: 47, scope: !342)
!361 = !DILocation(line: 160, column: 5, scope: !342)
!362 = distinct !DISubprogram(name: "_seqlock_await_even", scope: !24, file: !24, line: 48, type: !335, scopeLine: 49, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!363 = !DILocalVariable(name: "seq", arg: 1, scope: !362, file: !24, line: 48, type: !244)
!364 = !DILocation(line: 48, column: 32, scope: !362)
!365 = !DILocalVariable(name: "count", scope: !362, file: !24, line: 50, type: !248)
!366 = !DILocation(line: 50, column: 16, scope: !362)
!367 = !DILocation(line: 50, column: 44, scope: !362)
!368 = !DILocation(line: 50, column: 49, scope: !362)
!369 = !DILocation(line: 50, column: 24, scope: !362)
!370 = !DILocation(line: 51, column: 5, scope: !362)
!371 = !DILocation(line: 51, column: 12, scope: !362)
!372 = !DILocation(line: 52, column: 42, scope: !373)
!373 = distinct !DILexicalBlock(scope: !362, file: !24, line: 51, column: 28)
!374 = !DILocation(line: 52, column: 47, scope: !373)
!375 = !DILocation(line: 52, column: 57, scope: !373)
!376 = !DILocation(line: 52, column: 17, scope: !373)
!377 = !DILocation(line: 52, column: 15, scope: !373)
!378 = distinct !{!378, !370, !379, !128}
!379 = !DILocation(line: 53, column: 5, scope: !362)
!380 = !DILocation(line: 54, column: 5, scope: !381)
!381 = distinct !DILexicalBlock(scope: !382, file: !24, line: 54, column: 5)
!382 = distinct !DILexicalBlock(scope: !362, file: !24, line: 54, column: 5)
!383 = !DILocation(line: 54, column: 5, scope: !382)
!384 = !DILocation(line: 55, column: 12, scope: !362)
!385 = !DILocation(line: 55, column: 5, scope: !362)
!386 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !387, file: !387, line: 311, type: !388, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!387 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!388 = !DISubroutineType(types: !389)
!389 = !{!6, !390, !6, !6}
!390 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!391 = !DILocalVariable(name: "a", arg: 1, scope: !386, file: !387, line: 311, type: !390)
!392 = !DILocation(line: 311, column: 36, scope: !386)
!393 = !DILocalVariable(name: "e", arg: 2, scope: !386, file: !387, line: 311, type: !6)
!394 = !DILocation(line: 311, column: 49, scope: !386)
!395 = !DILocalVariable(name: "v", arg: 3, scope: !386, file: !387, line: 311, type: !6)
!396 = !DILocation(line: 311, column: 62, scope: !386)
!397 = !DILocalVariable(name: "oldv", scope: !386, file: !387, line: 313, type: !6)
!398 = !DILocation(line: 313, column: 15, scope: !386)
!399 = !DILocalVariable(name: "tmp", scope: !386, file: !387, line: 314, type: !6)
!400 = !DILocation(line: 314, column: 15, scope: !386)
!401 = !DILocation(line: 325, column: 22, scope: !386)
!402 = !DILocation(line: 325, column: 36, scope: !386)
!403 = !DILocation(line: 325, column: 48, scope: !386)
!404 = !DILocation(line: 325, column: 51, scope: !386)
!405 = !DILocation(line: 315, column: 5, scope: !386)
!406 = !{i64 465736, i64 465770, i64 465785, i64 465818, i64 465852, i64 465872, i64 465914, i64 465943}
!407 = !DILocation(line: 327, column: 12, scope: !386)
!408 = !DILocation(line: 327, column: 5, scope: !386)
!409 = distinct !DISubprogram(name: "vatomic_fence_rel", scope: !410, file: !410, line: 50, type: !43, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!410 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!411 = !DILocation(line: 52, column: 5, scope: !409)
!412 = !{i64 399289}
!413 = !DILocation(line: 53, column: 1, scope: !409)
!414 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !410, file: !410, line: 85, type: !415, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!415 = !DISubroutineType(types: !416)
!416 = !{!6, !417}
!417 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !418, size: 64)
!418 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !28)
!419 = !DILocalVariable(name: "a", arg: 1, scope: !414, file: !410, line: 85, type: !417)
!420 = !DILocation(line: 85, column: 39, scope: !414)
!421 = !DILocalVariable(name: "val", scope: !414, file: !410, line: 87, type: !6)
!422 = !DILocation(line: 87, column: 15, scope: !414)
!423 = !DILocation(line: 90, column: 32, scope: !414)
!424 = !DILocation(line: 90, column: 35, scope: !414)
!425 = !DILocation(line: 88, column: 5, scope: !414)
!426 = !{i64 400326}
!427 = !DILocation(line: 92, column: 12, scope: !414)
!428 = !DILocation(line: 92, column: 5, scope: !414)
!429 = distinct !DISubprogram(name: "vatomic32_await_neq_acq", scope: !410, file: !410, line: 648, type: !430, scopeLine: 649, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!430 = !DISubroutineType(types: !431)
!431 = !{!6, !417, !6}
!432 = !DILocalVariable(name: "a", arg: 1, scope: !429, file: !410, line: 648, type: !417)
!433 = !DILocation(line: 648, column: 44, scope: !429)
!434 = !DILocalVariable(name: "v", arg: 2, scope: !429, file: !410, line: 648, type: !6)
!435 = !DILocation(line: 648, column: 57, scope: !429)
!436 = !DILocalVariable(name: "val", scope: !429, file: !410, line: 650, type: !6)
!437 = !DILocation(line: 650, column: 15, scope: !429)
!438 = !DILocation(line: 657, column: 21, scope: !429)
!439 = !DILocation(line: 657, column: 33, scope: !429)
!440 = !DILocation(line: 657, column: 36, scope: !429)
!441 = !DILocation(line: 651, column: 5, scope: !429)
!442 = !{i64 416520, i64 416536, i64 416567, i64 416600}
!443 = !DILocation(line: 659, column: 12, scope: !429)
!444 = !DILocation(line: 659, column: 5, scope: !429)
!445 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !410, file: !410, line: 101, type: !415, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!446 = !DILocalVariable(name: "a", arg: 1, scope: !445, file: !410, line: 101, type: !417)
!447 = !DILocation(line: 101, column: 39, scope: !445)
!448 = !DILocalVariable(name: "val", scope: !445, file: !410, line: 103, type: !6)
!449 = !DILocation(line: 103, column: 15, scope: !445)
!450 = !DILocation(line: 106, column: 32, scope: !445)
!451 = !DILocation(line: 106, column: 35, scope: !445)
!452 = !DILocation(line: 104, column: 5, scope: !445)
!453 = !{i64 400828}
!454 = !DILocation(line: 108, column: 12, scope: !445)
!455 = !DILocation(line: 108, column: 5, scope: !445)
!456 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !410, file: !410, line: 227, type: !457, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!457 = !DISubroutineType(types: !458)
!458 = !{null, !390, !6}
!459 = !DILocalVariable(name: "a", arg: 1, scope: !456, file: !410, line: 227, type: !390)
!460 = !DILocation(line: 227, column: 34, scope: !456)
!461 = !DILocalVariable(name: "v", arg: 2, scope: !456, file: !410, line: 227, type: !6)
!462 = !DILocation(line: 227, column: 47, scope: !456)
!463 = !DILocation(line: 231, column: 32, scope: !456)
!464 = !DILocation(line: 231, column: 44, scope: !456)
!465 = !DILocation(line: 231, column: 47, scope: !456)
!466 = !DILocation(line: 229, column: 5, scope: !456)
!467 = !{i64 404742}
!468 = !DILocation(line: 233, column: 1, scope: !456)
!469 = distinct !DISubprogram(name: "vatomic_fence_acq", scope: !410, file: !410, line: 42, type: !43, scopeLine: 43, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!470 = !DILocation(line: 44, column: 5, scope: !469)
!471 = !{i64 399131}
!472 = !DILocation(line: 45, column: 1, scope: !469)
