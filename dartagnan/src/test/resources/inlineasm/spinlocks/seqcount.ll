; ModuleID = '/home/stefano/huawei/libvsync/spinlock/test/seqcount.c'
source_filename = "/home/stefano/huawei/libvsync/spinlock/test/seqcount.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_seq_cnt = dso_local global %struct.vatomic32_s zeroinitializer, align 4, !dbg !0
@g_cs_x = dso_local global i32 0, align 4, !dbg !18
@g_cs_y = dso_local global i32 0, align 4, !dbg !21
@.str = private unnamed_addr constant [7 x i8] c"a == b\00", align 1
@.str.1 = private unnamed_addr constant [55 x i8] c"/home/stefano/huawei/libvsync/spinlock/test/seqcount.c\00", align 1
@__PRETTY_FUNCTION__.reader_cs = private unnamed_addr constant [26 x i8] c"void reader_cs(vuint32_t)\00", align 1
@.str.2 = private unnamed_addr constant [14 x i8] c"(s >> 1) == a\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !38 {
  ret void, !dbg !43
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !44 {
  ret void, !dbg !45
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !46 {
  ret void, !dbg !47
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !48 {
  ret void, !dbg !49
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_acquire(i32 noundef %0) #0 !dbg !50 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !53, metadata !DIExpression()), !dbg !54
  br label %3, !dbg !55

3:                                                ; preds = %1
  br label %4, !dbg !56

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !58
  br label %6, !dbg !58

6:                                                ; preds = %4
  br label %7, !dbg !60

7:                                                ; preds = %6
  br label %8, !dbg !58

8:                                                ; preds = %7
  br label %9, !dbg !56

9:                                                ; preds = %8
  ret void, !dbg !62
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_release(i32 noundef %0) #0 !dbg !63 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !64, metadata !DIExpression()), !dbg !65
  br label %3, !dbg !66

3:                                                ; preds = %1
  br label %4, !dbg !67

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !69
  br label %6, !dbg !69

6:                                                ; preds = %4
  br label %7, !dbg !71

7:                                                ; preds = %6
  br label %8, !dbg !69

8:                                                ; preds = %7
  br label %9, !dbg !67

9:                                                ; preds = %8
  ret void, !dbg !73
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_acquire(i32 noundef %0) #0 !dbg !74 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !75, metadata !DIExpression()), !dbg !76
  br label %3, !dbg !77

3:                                                ; preds = %1
  br label %4, !dbg !78

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !80
  br label %6, !dbg !80

6:                                                ; preds = %4
  br label %7, !dbg !82

7:                                                ; preds = %6
  br label %8, !dbg !80

8:                                                ; preds = %7
  br label %9, !dbg !78

9:                                                ; preds = %8
  ret void, !dbg !84
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_release(i32 noundef %0) #0 !dbg !85 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !86, metadata !DIExpression()), !dbg !87
  br label %3, !dbg !88

3:                                                ; preds = %1
  br label %4, !dbg !89

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !91
  br label %6, !dbg !91

6:                                                ; preds = %4
  br label %7, !dbg !93

7:                                                ; preds = %6
  br label %8, !dbg !91

8:                                                ; preds = %7
  br label %9, !dbg !89

9:                                                ; preds = %8
  ret void, !dbg !95
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !96 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i64]* %2, metadata !100, metadata !DIExpression()), !dbg !106
  call void @init(), !dbg !107
  call void @llvm.dbg.declare(metadata i64* %3, metadata !108, metadata !DIExpression()), !dbg !110
  store i64 0, i64* %3, align 8, !dbg !110
  br label %6, !dbg !111

6:                                                ; preds = %15, %0
  %7 = load i64, i64* %3, align 8, !dbg !112
  %8 = icmp ult i64 %7, 1, !dbg !114
  br i1 %8, label %9, label %18, !dbg !115

9:                                                ; preds = %6
  %10 = load i64, i64* %3, align 8, !dbg !116
  %11 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %10, !dbg !118
  %12 = load i64, i64* %3, align 8, !dbg !119
  %13 = inttoptr i64 %12 to i8*, !dbg !120
  %14 = call i32 @pthread_create(i64* noundef %11, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef %13) #5, !dbg !121
  br label %15, !dbg !122

15:                                               ; preds = %9
  %16 = load i64, i64* %3, align 8, !dbg !123
  %17 = add i64 %16, 1, !dbg !123
  store i64 %17, i64* %3, align 8, !dbg !123
  br label %6, !dbg !124, !llvm.loop !125

18:                                               ; preds = %6
  call void @llvm.dbg.declare(metadata i64* %4, metadata !128, metadata !DIExpression()), !dbg !130
  store i64 1, i64* %4, align 8, !dbg !130
  br label %19, !dbg !131

19:                                               ; preds = %28, %18
  %20 = load i64, i64* %4, align 8, !dbg !132
  %21 = icmp ult i64 %20, 3, !dbg !134
  br i1 %21, label %22, label %31, !dbg !135

22:                                               ; preds = %19
  %23 = load i64, i64* %4, align 8, !dbg !136
  %24 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %23, !dbg !138
  %25 = load i64, i64* %4, align 8, !dbg !139
  %26 = inttoptr i64 %25 to i8*, !dbg !140
  %27 = call i32 @pthread_create(i64* noundef %24, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef %26) #5, !dbg !141
  br label %28, !dbg !142

28:                                               ; preds = %22
  %29 = load i64, i64* %4, align 8, !dbg !143
  %30 = add i64 %29, 1, !dbg !143
  store i64 %30, i64* %4, align 8, !dbg !143
  br label %19, !dbg !144, !llvm.loop !145

31:                                               ; preds = %19
  call void @post(), !dbg !147
  call void @llvm.dbg.declare(metadata i64* %5, metadata !148, metadata !DIExpression()), !dbg !150
  store i64 0, i64* %5, align 8, !dbg !150
  br label %32, !dbg !151

32:                                               ; preds = %40, %31
  %33 = load i64, i64* %5, align 8, !dbg !152
  %34 = icmp ult i64 %33, 3, !dbg !154
  br i1 %34, label %35, label %43, !dbg !155

35:                                               ; preds = %32
  %36 = load i64, i64* %5, align 8, !dbg !156
  %37 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %36, !dbg !158
  %38 = load i64, i64* %37, align 8, !dbg !158
  %39 = call i32 @pthread_join(i64 noundef %38, i8** noundef null), !dbg !159
  br label %40, !dbg !160

40:                                               ; preds = %35
  %41 = load i64, i64* %5, align 8, !dbg !161
  %42 = add i64 %41, 1, !dbg !161
  store i64 %42, i64* %5, align 8, !dbg !161
  br label %32, !dbg !162, !llvm.loop !163

43:                                               ; preds = %32
  call void @check(), !dbg !165
  call void @fini(), !dbg !166
  ret i32 0, !dbg !167
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal i8* @writer(i8* noundef %0) #0 !dbg !168 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !171, metadata !DIExpression()), !dbg !172
  call void @llvm.dbg.declare(metadata i32* %3, metadata !173, metadata !DIExpression()), !dbg !174
  %4 = load i8*, i8** %2, align 8, !dbg !175
  %5 = ptrtoint i8* %4 to i64, !dbg !176
  %6 = trunc i64 %5 to i32, !dbg !177
  store i32 %6, i32* %3, align 4, !dbg !174
  %7 = load i32, i32* %3, align 4, !dbg !178
  call void @writer_acquire(i32 noundef %7), !dbg !179
  %8 = load i32, i32* %3, align 4, !dbg !180
  call void @writer_cs(i32 noundef %8), !dbg !181
  %9 = load i32, i32* %3, align 4, !dbg !182
  call void @writer_release(i32 noundef %9), !dbg !183
  ret i8* null, !dbg !184
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @reader(i8* noundef %0) #0 !dbg !185 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !186, metadata !DIExpression()), !dbg !187
  call void @llvm.dbg.declare(metadata i32* %3, metadata !188, metadata !DIExpression()), !dbg !189
  %4 = load i8*, i8** %2, align 8, !dbg !190
  %5 = ptrtoint i8* %4 to i64, !dbg !191
  %6 = trunc i64 %5 to i32, !dbg !192
  store i32 %6, i32* %3, align 4, !dbg !189
  %7 = load i32, i32* %3, align 4, !dbg !193
  call void @reader_acquire(i32 noundef %7), !dbg !194
  %8 = load i32, i32* %3, align 4, !dbg !195
  call void @reader_cs(i32 noundef %8), !dbg !196
  %9 = load i32, i32* %3, align 4, !dbg !197
  call void @reader_release(i32 noundef %9), !dbg !198
  ret i8* null, !dbg !199
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_cs(i32 noundef %0) #0 !dbg !200 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !201, metadata !DIExpression()), !dbg !202
  br label %4, !dbg !203

4:                                                ; preds = %1
  br label %5, !dbg !204

5:                                                ; preds = %4
  %6 = load i32, i32* %2, align 4, !dbg !206
  br label %7, !dbg !206

7:                                                ; preds = %5
  br label %8, !dbg !208

8:                                                ; preds = %7
  br label %9, !dbg !206

9:                                                ; preds = %8
  br label %10, !dbg !204

10:                                               ; preds = %9
  call void @llvm.dbg.declare(metadata i32* %3, metadata !210, metadata !DIExpression()), !dbg !212
  %11 = call i32 @seqcount_wbegin(%struct.vatomic32_s* noundef @g_seq_cnt), !dbg !213
  store i32 %11, i32* %3, align 4, !dbg !212
  %12 = load i32, i32* @g_cs_x, align 4, !dbg !214
  %13 = add i32 %12, 1, !dbg !214
  store i32 %13, i32* @g_cs_x, align 4, !dbg !214
  %14 = load i32, i32* @g_cs_y, align 4, !dbg !215
  %15 = add i32 %14, 1, !dbg !215
  store i32 %15, i32* @g_cs_y, align 4, !dbg !215
  %16 = load i32, i32* %3, align 4, !dbg !216
  call void @seqcount_wend(%struct.vatomic32_s* noundef @g_seq_cnt, i32 noundef %16), !dbg !217
  ret void, !dbg !218
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @seqcount_wbegin(%struct.vatomic32_s* noundef %0) #0 !dbg !219 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !223, metadata !DIExpression()), !dbg !224
  call void @llvm.dbg.declare(metadata i32* %3, metadata !225, metadata !DIExpression()), !dbg !226
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !227
  %5 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %4), !dbg !228
  store i32 %5, i32* %3, align 4, !dbg !226
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !229
  %7 = load i32, i32* %3, align 4, !dbg !230
  %8 = add i32 %7, 1, !dbg !231
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %6, i32 noundef %8), !dbg !232
  call void @vatomic_fence_rel(), !dbg !233
  %9 = load i32, i32* %3, align 4, !dbg !234
  ret i32 %9, !dbg !235
}

; Function Attrs: noinline nounwind uwtable
define internal void @seqcount_wend(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !236 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !239, metadata !DIExpression()), !dbg !240
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !241, metadata !DIExpression()), !dbg !242
  %5 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !243
  %6 = load i32, i32* %4, align 4, !dbg !244
  %7 = add i32 %6, 2, !dbg !245
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %5, i32 noundef %7), !dbg !246
  ret void, !dbg !247
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_cs(i32 noundef %0) #0 !dbg !248 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !249, metadata !DIExpression()), !dbg !250
  call void @llvm.dbg.declare(metadata i32* %3, metadata !251, metadata !DIExpression()), !dbg !252
  store i32 0, i32* %3, align 4, !dbg !252
  call void @llvm.dbg.declare(metadata i32* %4, metadata !253, metadata !DIExpression()), !dbg !254
  store i32 0, i32* %4, align 4, !dbg !254
  call void @llvm.dbg.declare(metadata i32* %5, metadata !255, metadata !DIExpression()), !dbg !256
  store i32 0, i32* %5, align 4, !dbg !256
  br label %6, !dbg !257

6:                                                ; preds = %10, %1
  %7 = call i32 @seqcount_rbegin(%struct.vatomic32_s* noundef @g_seq_cnt), !dbg !258
  store i32 %7, i32* %5, align 4, !dbg !260
  %8 = load i32, i32* @g_cs_x, align 4, !dbg !261
  store i32 %8, i32* %3, align 4, !dbg !262
  %9 = load i32, i32* @g_cs_y, align 4, !dbg !263
  store i32 %9, i32* %4, align 4, !dbg !264
  br label %10, !dbg !265

10:                                               ; preds = %6
  %11 = load i32, i32* %5, align 4, !dbg !266
  %12 = call zeroext i1 @seqcount_rend(%struct.vatomic32_s* noundef @g_seq_cnt, i32 noundef %11), !dbg !266
  %13 = xor i1 %12, true, !dbg !266
  br i1 %13, label %6, label %14, !dbg !265, !llvm.loop !267

14:                                               ; preds = %10
  %15 = load i32, i32* %3, align 4, !dbg !268
  %16 = load i32, i32* %4, align 4, !dbg !268
  %17 = icmp eq i32 %15, %16, !dbg !268
  br i1 %17, label %18, label %19, !dbg !271

18:                                               ; preds = %14
  br label %20, !dbg !271

19:                                               ; preds = %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.1, i64 0, i64 0), i32 noundef 35, i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @__PRETTY_FUNCTION__.reader_cs, i64 0, i64 0)) #6, !dbg !268
  unreachable, !dbg !268

20:                                               ; preds = %18
  %21 = load i32, i32* %5, align 4, !dbg !272
  %22 = lshr i32 %21, 1, !dbg !272
  %23 = load i32, i32* %3, align 4, !dbg !272
  %24 = icmp eq i32 %22, %23, !dbg !272
  br i1 %24, label %25, label %26, !dbg !275

25:                                               ; preds = %20
  br label %27, !dbg !275

26:                                               ; preds = %20
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([55 x i8], [55 x i8]* @.str.1, i64 0, i64 0), i32 noundef 36, i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @__PRETTY_FUNCTION__.reader_cs, i64 0, i64 0)) #6, !dbg !272
  unreachable, !dbg !272

27:                                               ; preds = %25
  br label %28, !dbg !276

28:                                               ; preds = %27
  br label %29, !dbg !277

29:                                               ; preds = %28
  %30 = load i32, i32* %3, align 4, !dbg !279
  br label %31, !dbg !279

31:                                               ; preds = %29
  %32 = load i32, i32* %4, align 4, !dbg !281
  br label %33, !dbg !281

33:                                               ; preds = %31
  %34 = load i32, i32* %2, align 4, !dbg !283
  br label %35, !dbg !283

35:                                               ; preds = %33
  br label %36, !dbg !285

36:                                               ; preds = %35
  br label %37, !dbg !283

37:                                               ; preds = %36
  br label %38, !dbg !281

38:                                               ; preds = %37
  br label %39, !dbg !279

39:                                               ; preds = %38
  br label %40, !dbg !277

40:                                               ; preds = %39
  ret void, !dbg !287
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @seqcount_rbegin(%struct.vatomic32_s* noundef %0) #0 !dbg !288 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !289, metadata !DIExpression()), !dbg !290
  call void @llvm.dbg.declare(metadata i32* %3, metadata !291, metadata !DIExpression()), !dbg !292
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !293
  %5 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %4), !dbg !294
  %6 = and i32 %5, -2, !dbg !295
  store i32 %6, i32* %3, align 4, !dbg !292
  %7 = load i32, i32* %3, align 4, !dbg !296
  ret i32 %7, !dbg !297
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @seqcount_rend(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !298 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !303, metadata !DIExpression()), !dbg !304
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !305, metadata !DIExpression()), !dbg !306
  call void @vatomic_fence_acq(), !dbg !307
  %5 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !308
  %6 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %5), !dbg !309
  %7 = load i32, i32* %4, align 4, !dbg !310
  %8 = icmp eq i32 %6, %7, !dbg !311
  ret i1 %8, !dbg !312
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !313 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !319, metadata !DIExpression()), !dbg !320
  call void @llvm.dbg.declare(metadata i32* %3, metadata !321, metadata !DIExpression()), !dbg !322
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !323
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !324
  %6 = load i32, i32* %5, align 4, !dbg !324
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #5, !dbg !325, !srcloc !326
  store i32 %7, i32* %3, align 4, !dbg !325
  %8 = load i32, i32* %3, align 4, !dbg !327
  ret i32 %8, !dbg !328
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !329 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !333, metadata !DIExpression()), !dbg !334
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !335, metadata !DIExpression()), !dbg !336
  %5 = load i32, i32* %4, align 4, !dbg !337
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !338
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !339
  %8 = load i32, i32* %7, align 4, !dbg !339
  call void asm sideeffect "str ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #5, !dbg !340, !srcloc !341
  ret void, !dbg !342
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic_fence_rel() #0 !dbg !343 {
  call void asm sideeffect "dmb ish", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !344, !srcloc !345
  ret void, !dbg !346
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !347 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !348, metadata !DIExpression()), !dbg !349
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !350, metadata !DIExpression()), !dbg !351
  %5 = load i32, i32* %4, align 4, !dbg !352
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !353
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !354
  %8 = load i32, i32* %7, align 4, !dbg !354
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #5, !dbg !355, !srcloc !356
  ret void, !dbg !357
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !358 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !359, metadata !DIExpression()), !dbg !360
  call void @llvm.dbg.declare(metadata i32* %3, metadata !361, metadata !DIExpression()), !dbg !362
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !363
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !364
  %6 = load i32, i32* %5, align 4, !dbg !364
  %7 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #5, !dbg !365, !srcloc !366
  store i32 %7, i32* %3, align 4, !dbg !365
  %8 = load i32, i32* %3, align 4, !dbg !367
  ret i32 %8, !dbg !368
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic_fence_acq() #0 !dbg !369 {
  call void asm sideeffect "dmb ishld", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !370, !srcloc !371
  ret void, !dbg !372
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!30, !31, !32, !33, !34, !35, !36}
!llvm.ident = !{!37}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_seq_cnt", scope: !2, file: !20, line: 8, type: !23, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/spinlock/test/seqcount.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "f6f0eb119f1dfb093091d8c19a06eeeb")
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
!19 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !20, line: 9, type: !6, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "spinlock/test/seqcount.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "f6f0eb119f1dfb093091d8c19a06eeeb")
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !20, line: 9, type: !6, isLocal: false, isDefinition: true)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "seqcount_t", file: !24, line: 28, baseType: !25)
!24 = !DIFile(filename: "spinlock/include/vsync/spinlock/seqcount.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "2486c354271d6f0479cf2df759932299")
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !26, line: 34, baseType: !27)
!26 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !26, line: 32, size: 32, align: 32, elements: !28)
!28 = !{!29}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !27, file: !26, line: 33, baseType: !6, size: 32)
!30 = !{i32 7, !"Dwarf Version", i32 5}
!31 = !{i32 2, !"Debug Info Version", i32 3}
!32 = !{i32 1, !"wchar_size", i32 4}
!33 = !{i32 7, !"PIC Level", i32 2}
!34 = !{i32 7, !"PIE Level", i32 2}
!35 = !{i32 7, !"uwtable", i32 1}
!36 = !{i32 7, !"frame-pointer", i32 2}
!37 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!38 = distinct !DISubprogram(name: "init", scope: !39, file: !39, line: 54, type: !40, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!39 = !DIFile(filename: "utils/include/test/boilerplate/reader_writer.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4e1dc695be02c115383d13b32ef6a829")
!40 = !DISubroutineType(types: !41)
!41 = !{null}
!42 = !{}
!43 = !DILocation(line: 56, column: 1, scope: !38)
!44 = distinct !DISubprogram(name: "post", scope: !39, file: !39, line: 63, type: !40, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!45 = !DILocation(line: 65, column: 1, scope: !44)
!46 = distinct !DISubprogram(name: "fini", scope: !39, file: !39, line: 72, type: !40, scopeLine: 73, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!47 = !DILocation(line: 74, column: 1, scope: !46)
!48 = distinct !DISubprogram(name: "check", scope: !39, file: !39, line: 81, type: !40, scopeLine: 82, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!49 = !DILocation(line: 83, column: 1, scope: !48)
!50 = distinct !DISubprogram(name: "writer_acquire", scope: !39, file: !39, line: 85, type: !51, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!51 = !DISubroutineType(types: !52)
!52 = !{null, !6}
!53 = !DILocalVariable(name: "tid", arg: 1, scope: !50, file: !39, line: 85, type: !6)
!54 = !DILocation(line: 85, column: 26, scope: !50)
!55 = !DILocation(line: 87, column: 5, scope: !50)
!56 = !DILocation(line: 87, column: 5, scope: !57)
!57 = distinct !DILexicalBlock(scope: !50, file: !39, line: 87, column: 5)
!58 = !DILocation(line: 87, column: 5, scope: !59)
!59 = distinct !DILexicalBlock(scope: !57, file: !39, line: 87, column: 5)
!60 = !DILocation(line: 87, column: 5, scope: !61)
!61 = distinct !DILexicalBlock(scope: !59, file: !39, line: 87, column: 5)
!62 = !DILocation(line: 88, column: 1, scope: !50)
!63 = distinct !DISubprogram(name: "writer_release", scope: !39, file: !39, line: 90, type: !51, scopeLine: 91, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!64 = !DILocalVariable(name: "tid", arg: 1, scope: !63, file: !39, line: 90, type: !6)
!65 = !DILocation(line: 90, column: 26, scope: !63)
!66 = !DILocation(line: 92, column: 5, scope: !63)
!67 = !DILocation(line: 92, column: 5, scope: !68)
!68 = distinct !DILexicalBlock(scope: !63, file: !39, line: 92, column: 5)
!69 = !DILocation(line: 92, column: 5, scope: !70)
!70 = distinct !DILexicalBlock(scope: !68, file: !39, line: 92, column: 5)
!71 = !DILocation(line: 92, column: 5, scope: !72)
!72 = distinct !DILexicalBlock(scope: !70, file: !39, line: 92, column: 5)
!73 = !DILocation(line: 93, column: 1, scope: !63)
!74 = distinct !DISubprogram(name: "reader_acquire", scope: !39, file: !39, line: 95, type: !51, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!75 = !DILocalVariable(name: "tid", arg: 1, scope: !74, file: !39, line: 95, type: !6)
!76 = !DILocation(line: 95, column: 26, scope: !74)
!77 = !DILocation(line: 97, column: 5, scope: !74)
!78 = !DILocation(line: 97, column: 5, scope: !79)
!79 = distinct !DILexicalBlock(scope: !74, file: !39, line: 97, column: 5)
!80 = !DILocation(line: 97, column: 5, scope: !81)
!81 = distinct !DILexicalBlock(scope: !79, file: !39, line: 97, column: 5)
!82 = !DILocation(line: 97, column: 5, scope: !83)
!83 = distinct !DILexicalBlock(scope: !81, file: !39, line: 97, column: 5)
!84 = !DILocation(line: 98, column: 1, scope: !74)
!85 = distinct !DISubprogram(name: "reader_release", scope: !39, file: !39, line: 100, type: !51, scopeLine: 101, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!86 = !DILocalVariable(name: "tid", arg: 1, scope: !85, file: !39, line: 100, type: !6)
!87 = !DILocation(line: 100, column: 26, scope: !85)
!88 = !DILocation(line: 102, column: 5, scope: !85)
!89 = !DILocation(line: 102, column: 5, scope: !90)
!90 = distinct !DILexicalBlock(scope: !85, file: !39, line: 102, column: 5)
!91 = !DILocation(line: 102, column: 5, scope: !92)
!92 = distinct !DILexicalBlock(scope: !90, file: !39, line: 102, column: 5)
!93 = !DILocation(line: 102, column: 5, scope: !94)
!94 = distinct !DILexicalBlock(scope: !92, file: !39, line: 102, column: 5)
!95 = !DILocation(line: 103, column: 1, scope: !85)
!96 = distinct !DISubprogram(name: "main", scope: !39, file: !39, line: 158, type: !97, scopeLine: 159, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!97 = !DISubroutineType(types: !98)
!98 = !{!99}
!99 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!100 = !DILocalVariable(name: "t", scope: !96, file: !39, line: 160, type: !101)
!101 = !DICompositeType(tag: DW_TAG_array_type, baseType: !102, size: 192, elements: !104)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !103, line: 27, baseType: !16)
!103 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!104 = !{!105}
!105 = !DISubrange(count: 3)
!106 = !DILocation(line: 160, column: 15, scope: !96)
!107 = !DILocation(line: 167, column: 5, scope: !96)
!108 = !DILocalVariable(name: "i", scope: !109, file: !39, line: 169, type: !13)
!109 = distinct !DILexicalBlock(scope: !96, file: !39, line: 169, column: 5)
!110 = !DILocation(line: 169, column: 21, scope: !109)
!111 = !DILocation(line: 169, column: 10, scope: !109)
!112 = !DILocation(line: 169, column: 28, scope: !113)
!113 = distinct !DILexicalBlock(scope: !109, file: !39, line: 169, column: 5)
!114 = !DILocation(line: 169, column: 30, scope: !113)
!115 = !DILocation(line: 169, column: 5, scope: !109)
!116 = !DILocation(line: 170, column: 33, scope: !117)
!117 = distinct !DILexicalBlock(scope: !113, file: !39, line: 169, column: 47)
!118 = !DILocation(line: 170, column: 31, scope: !117)
!119 = !DILocation(line: 170, column: 56, scope: !117)
!120 = !DILocation(line: 170, column: 48, scope: !117)
!121 = !DILocation(line: 170, column: 15, scope: !117)
!122 = !DILocation(line: 171, column: 5, scope: !117)
!123 = !DILocation(line: 169, column: 43, scope: !113)
!124 = !DILocation(line: 169, column: 5, scope: !113)
!125 = distinct !{!125, !115, !126, !127}
!126 = !DILocation(line: 171, column: 5, scope: !109)
!127 = !{!"llvm.loop.mustprogress"}
!128 = !DILocalVariable(name: "i", scope: !129, file: !39, line: 173, type: !13)
!129 = distinct !DILexicalBlock(scope: !96, file: !39, line: 173, column: 5)
!130 = !DILocation(line: 173, column: 21, scope: !129)
!131 = !DILocation(line: 173, column: 10, scope: !129)
!132 = !DILocation(line: 173, column: 35, scope: !133)
!133 = distinct !DILexicalBlock(scope: !129, file: !39, line: 173, column: 5)
!134 = !DILocation(line: 173, column: 37, scope: !133)
!135 = !DILocation(line: 173, column: 5, scope: !129)
!136 = !DILocation(line: 174, column: 33, scope: !137)
!137 = distinct !DILexicalBlock(scope: !133, file: !39, line: 173, column: 54)
!138 = !DILocation(line: 174, column: 31, scope: !137)
!139 = !DILocation(line: 174, column: 56, scope: !137)
!140 = !DILocation(line: 174, column: 48, scope: !137)
!141 = !DILocation(line: 174, column: 15, scope: !137)
!142 = !DILocation(line: 175, column: 5, scope: !137)
!143 = !DILocation(line: 173, column: 50, scope: !133)
!144 = !DILocation(line: 173, column: 5, scope: !133)
!145 = distinct !{!145, !135, !146, !127}
!146 = !DILocation(line: 175, column: 5, scope: !129)
!147 = !DILocation(line: 177, column: 5, scope: !96)
!148 = !DILocalVariable(name: "i", scope: !149, file: !39, line: 179, type: !13)
!149 = distinct !DILexicalBlock(scope: !96, file: !39, line: 179, column: 5)
!150 = !DILocation(line: 179, column: 21, scope: !149)
!151 = !DILocation(line: 179, column: 10, scope: !149)
!152 = !DILocation(line: 179, column: 28, scope: !153)
!153 = distinct !DILexicalBlock(scope: !149, file: !39, line: 179, column: 5)
!154 = !DILocation(line: 179, column: 30, scope: !153)
!155 = !DILocation(line: 179, column: 5, scope: !149)
!156 = !DILocation(line: 180, column: 30, scope: !157)
!157 = distinct !DILexicalBlock(scope: !153, file: !39, line: 179, column: 47)
!158 = !DILocation(line: 180, column: 28, scope: !157)
!159 = !DILocation(line: 180, column: 15, scope: !157)
!160 = !DILocation(line: 181, column: 5, scope: !157)
!161 = !DILocation(line: 179, column: 43, scope: !153)
!162 = !DILocation(line: 179, column: 5, scope: !153)
!163 = distinct !{!163, !155, !164, !127}
!164 = !DILocation(line: 181, column: 5, scope: !149)
!165 = !DILocation(line: 188, column: 5, scope: !96)
!166 = !DILocation(line: 189, column: 5, scope: !96)
!167 = !DILocation(line: 191, column: 5, scope: !96)
!168 = distinct !DISubprogram(name: "writer", scope: !39, file: !39, line: 137, type: !169, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!169 = !DISubroutineType(types: !170)
!170 = !{!5, !5}
!171 = !DILocalVariable(name: "arg", arg: 1, scope: !168, file: !39, line: 137, type: !5)
!172 = !DILocation(line: 137, column: 14, scope: !168)
!173 = !DILocalVariable(name: "tid", scope: !168, file: !39, line: 139, type: !6)
!174 = !DILocation(line: 139, column: 15, scope: !168)
!175 = !DILocation(line: 139, column: 44, scope: !168)
!176 = !DILocation(line: 139, column: 32, scope: !168)
!177 = !DILocation(line: 139, column: 21, scope: !168)
!178 = !DILocation(line: 140, column: 20, scope: !168)
!179 = !DILocation(line: 140, column: 5, scope: !168)
!180 = !DILocation(line: 141, column: 15, scope: !168)
!181 = !DILocation(line: 141, column: 5, scope: !168)
!182 = !DILocation(line: 142, column: 20, scope: !168)
!183 = !DILocation(line: 142, column: 5, scope: !168)
!184 = !DILocation(line: 143, column: 5, scope: !168)
!185 = distinct !DISubprogram(name: "reader", scope: !39, file: !39, line: 147, type: !169, scopeLine: 148, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!186 = !DILocalVariable(name: "arg", arg: 1, scope: !185, file: !39, line: 147, type: !5)
!187 = !DILocation(line: 147, column: 14, scope: !185)
!188 = !DILocalVariable(name: "tid", scope: !185, file: !39, line: 149, type: !6)
!189 = !DILocation(line: 149, column: 15, scope: !185)
!190 = !DILocation(line: 149, column: 44, scope: !185)
!191 = !DILocation(line: 149, column: 32, scope: !185)
!192 = !DILocation(line: 149, column: 21, scope: !185)
!193 = !DILocation(line: 150, column: 20, scope: !185)
!194 = !DILocation(line: 150, column: 5, scope: !185)
!195 = !DILocation(line: 151, column: 15, scope: !185)
!196 = !DILocation(line: 151, column: 5, scope: !185)
!197 = !DILocation(line: 152, column: 20, scope: !185)
!198 = !DILocation(line: 152, column: 5, scope: !185)
!199 = !DILocation(line: 154, column: 5, scope: !185)
!200 = distinct !DISubprogram(name: "writer_cs", scope: !20, file: !20, line: 12, type: !51, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!201 = !DILocalVariable(name: "tid", arg: 1, scope: !200, file: !20, line: 12, type: !6)
!202 = !DILocation(line: 12, column: 21, scope: !200)
!203 = !DILocation(line: 14, column: 5, scope: !200)
!204 = !DILocation(line: 14, column: 5, scope: !205)
!205 = distinct !DILexicalBlock(scope: !200, file: !20, line: 14, column: 5)
!206 = !DILocation(line: 14, column: 5, scope: !207)
!207 = distinct !DILexicalBlock(scope: !205, file: !20, line: 14, column: 5)
!208 = !DILocation(line: 14, column: 5, scope: !209)
!209 = distinct !DILexicalBlock(scope: !207, file: !20, line: 14, column: 5)
!210 = !DILocalVariable(name: "s", scope: !200, file: !20, line: 15, type: !211)
!211 = !DIDerivedType(tag: DW_TAG_typedef, name: "seqvalue_t", file: !24, line: 29, baseType: !6)
!212 = !DILocation(line: 15, column: 16, scope: !200)
!213 = !DILocation(line: 15, column: 20, scope: !200)
!214 = !DILocation(line: 16, column: 11, scope: !200)
!215 = !DILocation(line: 17, column: 11, scope: !200)
!216 = !DILocation(line: 18, column: 31, scope: !200)
!217 = !DILocation(line: 18, column: 5, scope: !200)
!218 = !DILocation(line: 19, column: 1, scope: !200)
!219 = distinct !DISubprogram(name: "seqcount_wbegin", scope: !24, file: !24, line: 61, type: !220, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!220 = !DISubroutineType(types: !221)
!221 = !{!211, !222}
!222 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!223 = !DILocalVariable(name: "sc", arg: 1, scope: !219, file: !24, line: 61, type: !222)
!224 = !DILocation(line: 61, column: 29, scope: !219)
!225 = !DILocalVariable(name: "s", scope: !219, file: !24, line: 63, type: !211)
!226 = !DILocation(line: 63, column: 16, scope: !219)
!227 = !DILocation(line: 63, column: 39, scope: !219)
!228 = !DILocation(line: 63, column: 20, scope: !219)
!229 = !DILocation(line: 64, column: 25, scope: !219)
!230 = !DILocation(line: 64, column: 29, scope: !219)
!231 = !DILocation(line: 64, column: 31, scope: !219)
!232 = !DILocation(line: 64, column: 5, scope: !219)
!233 = !DILocation(line: 65, column: 5, scope: !219)
!234 = !DILocation(line: 66, column: 12, scope: !219)
!235 = !DILocation(line: 66, column: 5, scope: !219)
!236 = distinct !DISubprogram(name: "seqcount_wend", scope: !24, file: !24, line: 75, type: !237, scopeLine: 76, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!237 = !DISubroutineType(types: !238)
!238 = !{null, !222, !211}
!239 = !DILocalVariable(name: "sc", arg: 1, scope: !236, file: !24, line: 75, type: !222)
!240 = !DILocation(line: 75, column: 27, scope: !236)
!241 = !DILocalVariable(name: "s", arg: 2, scope: !236, file: !24, line: 75, type: !211)
!242 = !DILocation(line: 75, column: 42, scope: !236)
!243 = !DILocation(line: 77, column: 25, scope: !236)
!244 = !DILocation(line: 77, column: 29, scope: !236)
!245 = !DILocation(line: 77, column: 31, scope: !236)
!246 = !DILocation(line: 77, column: 5, scope: !236)
!247 = !DILocation(line: 78, column: 1, scope: !236)
!248 = distinct !DISubprogram(name: "reader_cs", scope: !20, file: !20, line: 22, type: !51, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!249 = !DILocalVariable(name: "tid", arg: 1, scope: !248, file: !20, line: 22, type: !6)
!250 = !DILocation(line: 22, column: 21, scope: !248)
!251 = !DILocalVariable(name: "a", scope: !248, file: !20, line: 24, type: !6)
!252 = !DILocation(line: 24, column: 15, scope: !248)
!253 = !DILocalVariable(name: "b", scope: !248, file: !20, line: 25, type: !6)
!254 = !DILocation(line: 25, column: 15, scope: !248)
!255 = !DILocalVariable(name: "s", scope: !248, file: !20, line: 26, type: !211)
!256 = !DILocation(line: 26, column: 16, scope: !248)
!257 = !DILocation(line: 28, column: 5, scope: !248)
!258 = !DILocation(line: 29, column: 13, scope: !259)
!259 = distinct !DILexicalBlock(scope: !248, file: !20, line: 28, column: 14)
!260 = !DILocation(line: 29, column: 11, scope: !259)
!261 = !DILocation(line: 30, column: 13, scope: !259)
!262 = !DILocation(line: 30, column: 11, scope: !259)
!263 = !DILocation(line: 31, column: 13, scope: !259)
!264 = !DILocation(line: 31, column: 11, scope: !259)
!265 = !DILocation(line: 32, column: 5, scope: !259)
!266 = !DILocation(line: 33, column: 5, scope: !248)
!267 = distinct !{!267, !257, !266, !127}
!268 = !DILocation(line: 35, column: 5, scope: !269)
!269 = distinct !DILexicalBlock(scope: !270, file: !20, line: 35, column: 5)
!270 = distinct !DILexicalBlock(scope: !248, file: !20, line: 35, column: 5)
!271 = !DILocation(line: 35, column: 5, scope: !270)
!272 = !DILocation(line: 36, column: 5, scope: !273)
!273 = distinct !DILexicalBlock(scope: !274, file: !20, line: 36, column: 5)
!274 = distinct !DILexicalBlock(scope: !248, file: !20, line: 36, column: 5)
!275 = !DILocation(line: 36, column: 5, scope: !274)
!276 = !DILocation(line: 38, column: 5, scope: !248)
!277 = !DILocation(line: 38, column: 5, scope: !278)
!278 = distinct !DILexicalBlock(scope: !248, file: !20, line: 38, column: 5)
!279 = !DILocation(line: 38, column: 5, scope: !280)
!280 = distinct !DILexicalBlock(scope: !278, file: !20, line: 38, column: 5)
!281 = !DILocation(line: 38, column: 5, scope: !282)
!282 = distinct !DILexicalBlock(scope: !280, file: !20, line: 38, column: 5)
!283 = !DILocation(line: 38, column: 5, scope: !284)
!284 = distinct !DILexicalBlock(scope: !282, file: !20, line: 38, column: 5)
!285 = !DILocation(line: 38, column: 5, scope: !286)
!286 = distinct !DILexicalBlock(scope: !284, file: !20, line: 38, column: 5)
!287 = !DILocation(line: 39, column: 1, scope: !248)
!288 = distinct !DISubprogram(name: "seqcount_rbegin", scope: !24, file: !24, line: 88, type: !220, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!289 = !DILocalVariable(name: "sc", arg: 1, scope: !288, file: !24, line: 88, type: !222)
!290 = !DILocation(line: 88, column: 29, scope: !288)
!291 = !DILocalVariable(name: "s", scope: !288, file: !24, line: 90, type: !211)
!292 = !DILocation(line: 90, column: 16, scope: !288)
!293 = !DILocation(line: 90, column: 39, scope: !288)
!294 = !DILocation(line: 90, column: 20, scope: !288)
!295 = !DILocation(line: 90, column: 43, scope: !288)
!296 = !DILocation(line: 91, column: 12, scope: !288)
!297 = !DILocation(line: 91, column: 5, scope: !288)
!298 = distinct !DISubprogram(name: "seqcount_rend", scope: !24, file: !24, line: 103, type: !299, scopeLine: 104, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!299 = !DISubroutineType(types: !300)
!300 = !{!301, !222, !211}
!301 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !7, line: 44, baseType: !302)
!302 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!303 = !DILocalVariable(name: "sc", arg: 1, scope: !298, file: !24, line: 103, type: !222)
!304 = !DILocation(line: 103, column: 27, scope: !298)
!305 = !DILocalVariable(name: "s", arg: 2, scope: !298, file: !24, line: 103, type: !211)
!306 = !DILocation(line: 103, column: 42, scope: !298)
!307 = !DILocation(line: 105, column: 5, scope: !298)
!308 = !DILocation(line: 106, column: 31, scope: !298)
!309 = !DILocation(line: 106, column: 12, scope: !298)
!310 = !DILocation(line: 106, column: 38, scope: !298)
!311 = !DILocation(line: 106, column: 35, scope: !298)
!312 = !DILocation(line: 106, column: 5, scope: !298)
!313 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !314, file: !314, line: 101, type: !315, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!314 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!315 = !DISubroutineType(types: !316)
!316 = !{!6, !317}
!317 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !318, size: 64)
!318 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !25)
!319 = !DILocalVariable(name: "a", arg: 1, scope: !313, file: !314, line: 101, type: !317)
!320 = !DILocation(line: 101, column: 39, scope: !313)
!321 = !DILocalVariable(name: "val", scope: !313, file: !314, line: 103, type: !6)
!322 = !DILocation(line: 103, column: 15, scope: !313)
!323 = !DILocation(line: 106, column: 32, scope: !313)
!324 = !DILocation(line: 106, column: 35, scope: !313)
!325 = !DILocation(line: 104, column: 5, scope: !313)
!326 = !{i64 398877}
!327 = !DILocation(line: 108, column: 12, scope: !313)
!328 = !DILocation(line: 108, column: 5, scope: !313)
!329 = distinct !DISubprogram(name: "vatomic32_write_rlx", scope: !314, file: !314, line: 241, type: !330, scopeLine: 242, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!330 = !DISubroutineType(types: !331)
!331 = !{null, !332, !6}
!332 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!333 = !DILocalVariable(name: "a", arg: 1, scope: !329, file: !314, line: 241, type: !332)
!334 = !DILocation(line: 241, column: 34, scope: !329)
!335 = !DILocalVariable(name: "v", arg: 2, scope: !329, file: !314, line: 241, type: !6)
!336 = !DILocation(line: 241, column: 47, scope: !329)
!337 = !DILocation(line: 245, column: 32, scope: !329)
!338 = !DILocation(line: 245, column: 44, scope: !329)
!339 = !DILocation(line: 245, column: 47, scope: !329)
!340 = !DILocation(line: 243, column: 5, scope: !329)
!341 = !{i64 403261}
!342 = !DILocation(line: 247, column: 1, scope: !329)
!343 = distinct !DISubprogram(name: "vatomic_fence_rel", scope: !314, file: !314, line: 50, type: !40, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!344 = !DILocation(line: 52, column: 5, scope: !343)
!345 = !{i64 397338}
!346 = !DILocation(line: 53, column: 1, scope: !343)
!347 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !314, file: !314, line: 227, type: !330, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!348 = !DILocalVariable(name: "a", arg: 1, scope: !347, file: !314, line: 227, type: !332)
!349 = !DILocation(line: 227, column: 34, scope: !347)
!350 = !DILocalVariable(name: "v", arg: 2, scope: !347, file: !314, line: 227, type: !6)
!351 = !DILocation(line: 227, column: 47, scope: !347)
!352 = !DILocation(line: 231, column: 32, scope: !347)
!353 = !DILocation(line: 231, column: 44, scope: !347)
!354 = !DILocation(line: 231, column: 47, scope: !347)
!355 = !DILocation(line: 229, column: 5, scope: !347)
!356 = !{i64 402791}
!357 = !DILocation(line: 233, column: 1, scope: !347)
!358 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !314, file: !314, line: 85, type: !315, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!359 = !DILocalVariable(name: "a", arg: 1, scope: !358, file: !314, line: 85, type: !317)
!360 = !DILocation(line: 85, column: 39, scope: !358)
!361 = !DILocalVariable(name: "val", scope: !358, file: !314, line: 87, type: !6)
!362 = !DILocation(line: 87, column: 15, scope: !358)
!363 = !DILocation(line: 90, column: 32, scope: !358)
!364 = !DILocation(line: 90, column: 35, scope: !358)
!365 = !DILocation(line: 88, column: 5, scope: !358)
!366 = !{i64 398375}
!367 = !DILocation(line: 92, column: 12, scope: !358)
!368 = !DILocation(line: 92, column: 5, scope: !358)
!369 = distinct !DISubprogram(name: "vatomic_fence_acq", scope: !314, file: !314, line: 42, type: !40, scopeLine: 43, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!370 = !DILocation(line: 44, column: 5, scope: !369)
!371 = !{i64 397180}
!372 = !DILocation(line: 45, column: 1, scope: !369)
