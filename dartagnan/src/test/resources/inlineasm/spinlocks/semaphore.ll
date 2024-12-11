; ModuleID = '/home/stefano/huawei/libvsync/spinlock/test/semaphore.c'
source_filename = "/home/stefano/huawei/libvsync/spinlock/test/semaphore.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.semaphore_s = type { %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !31
@.str = private unnamed_addr constant [25 x i8] c"g_cs_x and g_cs_y differ\00", align 1
@.str.1 = private unnamed_addr constant [32 x i8] c"a && \22g_cs_x and g_cs_y differ\22\00", align 1
@.str.2 = private unnamed_addr constant [77 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/boilerplate/reader_writer.h\00", align 1
@__PRETTY_FUNCTION__.reader_cs = private unnamed_addr constant [26 x i8] c"void reader_cs(vuint32_t)\00", align 1
@.str.3 = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"g_cs_x == 2\00", align 1
@g_semaphore = dso_local global %struct.semaphore_s zeroinitializer, align 4, !dbg !18

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !42 {
  ret void, !dbg !46
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !47 {
  ret void, !dbg !48
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_cs(i32 noundef %0) #0 !dbg !49 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !52, metadata !DIExpression()), !dbg !53
  br label %3, !dbg !54

3:                                                ; preds = %1
  br label %4, !dbg !55

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !57
  br label %6, !dbg !57

6:                                                ; preds = %4
  br label %7, !dbg !59

7:                                                ; preds = %6
  br label %8, !dbg !57

8:                                                ; preds = %7
  br label %9, !dbg !55

9:                                                ; preds = %8
  %10 = load i32, i32* @g_cs_x, align 4, !dbg !61
  %11 = add i32 %10, 1, !dbg !61
  store i32 %11, i32* @g_cs_x, align 4, !dbg !61
  %12 = load i32, i32* @g_cs_y, align 4, !dbg !62
  %13 = add i32 %12, 1, !dbg !62
  store i32 %13, i32* @g_cs_y, align 4, !dbg !62
  ret void, !dbg !63
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_cs(i32 noundef %0) #0 !dbg !64 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !65, metadata !DIExpression()), !dbg !66
  br label %4, !dbg !67

4:                                                ; preds = %1
  br label %5, !dbg !68

5:                                                ; preds = %4
  %6 = load i32, i32* %2, align 4, !dbg !70
  br label %7, !dbg !70

7:                                                ; preds = %5
  br label %8, !dbg !72

8:                                                ; preds = %7
  br label %9, !dbg !70

9:                                                ; preds = %8
  br label %10, !dbg !68

10:                                               ; preds = %9
  call void @llvm.dbg.declare(metadata i32* %3, metadata !74, metadata !DIExpression()), !dbg !75
  %11 = load i32, i32* @g_cs_x, align 4, !dbg !76
  %12 = load i32, i32* @g_cs_y, align 4, !dbg !77
  %13 = icmp eq i32 %11, %12, !dbg !78
  %14 = zext i1 %13 to i32, !dbg !78
  store i32 %14, i32* %3, align 4, !dbg !75
  %15 = load i32, i32* %3, align 4, !dbg !79
  %16 = icmp ne i32 %15, 0, !dbg !79
  br i1 %16, label %17, label %19, !dbg !79

17:                                               ; preds = %10
  br i1 true, label %18, label %19, !dbg !82

18:                                               ; preds = %17
  br label %20, !dbg !82

19:                                               ; preds = %17, %10
  call void @__assert_fail(i8* noundef getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i64 0, i64 0), i8* noundef getelementptr inbounds ([77 x i8], [77 x i8]* @.str.2, i64 0, i64 0), i32 noundef 125, i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @__PRETTY_FUNCTION__.reader_cs, i64 0, i64 0)) #5, !dbg !79
  unreachable, !dbg !79

20:                                               ; preds = %18
  ret void, !dbg !83
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !84 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !85
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !85
  %3 = icmp eq i32 %1, %2, !dbg !85
  br i1 %3, label %4, label %5, !dbg !88

4:                                                ; preds = %0
  br label %6, !dbg !88

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([77 x i8], [77 x i8]* @.str.2, i64 0, i64 0), i32 noundef 130, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !85
  unreachable, !dbg !85

6:                                                ; preds = %4
  %7 = load i32, i32* @g_cs_x, align 4, !dbg !89
  %8 = icmp eq i32 %7, 2, !dbg !89
  br i1 %8, label %9, label %10, !dbg !92

9:                                                ; preds = %6
  br label %11, !dbg !92

10:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([77 x i8], [77 x i8]* @.str.2, i64 0, i64 0), i32 noundef 131, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !89
  unreachable, !dbg !89

11:                                               ; preds = %9
  ret void, !dbg !93
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !94 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i64]* %2, metadata !98, metadata !DIExpression()), !dbg !104
  call void @init(), !dbg !105
  call void @llvm.dbg.declare(metadata i64* %3, metadata !106, metadata !DIExpression()), !dbg !108
  store i64 0, i64* %3, align 8, !dbg !108
  br label %6, !dbg !109

6:                                                ; preds = %15, %0
  %7 = load i64, i64* %3, align 8, !dbg !110
  %8 = icmp ult i64 %7, 2, !dbg !112
  br i1 %8, label %9, label %18, !dbg !113

9:                                                ; preds = %6
  %10 = load i64, i64* %3, align 8, !dbg !114
  %11 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %10, !dbg !116
  %12 = load i64, i64* %3, align 8, !dbg !117
  %13 = inttoptr i64 %12 to i8*, !dbg !118
  %14 = call i32 @pthread_create(i64* noundef %11, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef %13) #6, !dbg !119
  br label %15, !dbg !120

15:                                               ; preds = %9
  %16 = load i64, i64* %3, align 8, !dbg !121
  %17 = add i64 %16, 1, !dbg !121
  store i64 %17, i64* %3, align 8, !dbg !121
  br label %6, !dbg !122, !llvm.loop !123

18:                                               ; preds = %6
  call void @llvm.dbg.declare(metadata i64* %4, metadata !126, metadata !DIExpression()), !dbg !128
  store i64 2, i64* %4, align 8, !dbg !128
  br label %19, !dbg !129

19:                                               ; preds = %28, %18
  %20 = load i64, i64* %4, align 8, !dbg !130
  %21 = icmp ult i64 %20, 3, !dbg !132
  br i1 %21, label %22, label %31, !dbg !133

22:                                               ; preds = %19
  %23 = load i64, i64* %4, align 8, !dbg !134
  %24 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %23, !dbg !136
  %25 = load i64, i64* %4, align 8, !dbg !137
  %26 = inttoptr i64 %25 to i8*, !dbg !138
  %27 = call i32 @pthread_create(i64* noundef %24, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef %26) #6, !dbg !139
  br label %28, !dbg !140

28:                                               ; preds = %22
  %29 = load i64, i64* %4, align 8, !dbg !141
  %30 = add i64 %29, 1, !dbg !141
  store i64 %30, i64* %4, align 8, !dbg !141
  br label %19, !dbg !142, !llvm.loop !143

31:                                               ; preds = %19
  call void @post(), !dbg !145
  call void @llvm.dbg.declare(metadata i64* %5, metadata !146, metadata !DIExpression()), !dbg !148
  store i64 0, i64* %5, align 8, !dbg !148
  br label %32, !dbg !149

32:                                               ; preds = %40, %31
  %33 = load i64, i64* %5, align 8, !dbg !150
  %34 = icmp ult i64 %33, 3, !dbg !152
  br i1 %34, label %35, label %43, !dbg !153

35:                                               ; preds = %32
  %36 = load i64, i64* %5, align 8, !dbg !154
  %37 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %36, !dbg !156
  %38 = load i64, i64* %37, align 8, !dbg !156
  %39 = call i32 @pthread_join(i64 noundef %38, i8** noundef null), !dbg !157
  br label %40, !dbg !158

40:                                               ; preds = %35
  %41 = load i64, i64* %5, align 8, !dbg !159
  %42 = add i64 %41, 1, !dbg !159
  store i64 %42, i64* %5, align 8, !dbg !159
  br label %32, !dbg !160, !llvm.loop !161

43:                                               ; preds = %32
  call void @check(), !dbg !163
  call void @fini(), !dbg !164
  ret i32 0, !dbg !165
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !166 {
  call void @semaphore_init(%struct.semaphore_s* noundef @g_semaphore, i32 noundef 3), !dbg !167
  ret void, !dbg !168
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

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

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @semaphore_init(%struct.semaphore_s* noundef %0, i32 noundef %1) #0 !dbg !201 {
  %3 = alloca %struct.semaphore_s*, align 8
  %4 = alloca i32, align 4
  store %struct.semaphore_s* %0, %struct.semaphore_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.semaphore_s** %3, metadata !205, metadata !DIExpression()), !dbg !206
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !207, metadata !DIExpression()), !dbg !208
  %5 = load %struct.semaphore_s*, %struct.semaphore_s** %3, align 8, !dbg !209
  %6 = getelementptr inbounds %struct.semaphore_s, %struct.semaphore_s* %5, i32 0, i32 0, !dbg !210
  %7 = load i32, i32* %4, align 4, !dbg !211
  call void @vatomic32_write(%struct.vatomic32_s* noundef %6, i32 noundef %7), !dbg !212
  ret void, !dbg !213
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_acquire(i32 noundef %0) #0 !dbg !214 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !215, metadata !DIExpression()), !dbg !216
  br label %3, !dbg !217

3:                                                ; preds = %1
  br label %4, !dbg !218

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !220
  br label %6, !dbg !220

6:                                                ; preds = %4
  br label %7, !dbg !222

7:                                                ; preds = %6
  br label %8, !dbg !220

8:                                                ; preds = %7
  br label %9, !dbg !218

9:                                                ; preds = %8
  call void @semaphore_acquire(%struct.semaphore_s* noundef @g_semaphore, i32 noundef 3), !dbg !224
  ret void, !dbg !225
}

; Function Attrs: noinline nounwind uwtable
define internal void @semaphore_acquire(%struct.semaphore_s* noundef %0, i32 noundef %1) #0 !dbg !226 {
  %3 = alloca %struct.semaphore_s*, align 8
  %4 = alloca i32, align 4
  store %struct.semaphore_s* %0, %struct.semaphore_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.semaphore_s** %3, metadata !227, metadata !DIExpression()), !dbg !228
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !229, metadata !DIExpression()), !dbg !230
  %5 = load %struct.semaphore_s*, %struct.semaphore_s** %3, align 8, !dbg !231
  %6 = getelementptr inbounds %struct.semaphore_s, %struct.semaphore_s* %5, i32 0, i32 0, !dbg !232
  %7 = load i32, i32* %4, align 4, !dbg !233
  %8 = load i32, i32* %4, align 4, !dbg !234
  %9 = call i32 @vatomic32_await_ge_sub_acq(%struct.vatomic32_s* noundef %6, i32 noundef %7, i32 noundef %8), !dbg !235
  ret void, !dbg !236
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_release(i32 noundef %0) #0 !dbg !237 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !238, metadata !DIExpression()), !dbg !239
  br label %3, !dbg !240

3:                                                ; preds = %1
  br label %4, !dbg !241

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !243
  br label %6, !dbg !243

6:                                                ; preds = %4
  br label %7, !dbg !245

7:                                                ; preds = %6
  br label %8, !dbg !243

8:                                                ; preds = %7
  br label %9, !dbg !241

9:                                                ; preds = %8
  call void @semaphore_release(%struct.semaphore_s* noundef @g_semaphore, i32 noundef 3), !dbg !247
  ret void, !dbg !248
}

; Function Attrs: noinline nounwind uwtable
define internal void @semaphore_release(%struct.semaphore_s* noundef %0, i32 noundef %1) #0 !dbg !249 {
  %3 = alloca %struct.semaphore_s*, align 8
  %4 = alloca i32, align 4
  store %struct.semaphore_s* %0, %struct.semaphore_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.semaphore_s** %3, metadata !250, metadata !DIExpression()), !dbg !251
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !252, metadata !DIExpression()), !dbg !253
  %5 = load %struct.semaphore_s*, %struct.semaphore_s** %3, align 8, !dbg !254
  %6 = getelementptr inbounds %struct.semaphore_s, %struct.semaphore_s* %5, i32 0, i32 0, !dbg !255
  %7 = load i32, i32* %4, align 4, !dbg !256
  call void @vatomic32_add_rel(%struct.vatomic32_s* noundef %6, i32 noundef %7), !dbg !257
  ret void, !dbg !258
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_acquire(i32 noundef %0) #0 !dbg !259 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !260, metadata !DIExpression()), !dbg !261
  br label %3, !dbg !262

3:                                                ; preds = %1
  br label %4, !dbg !263

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !265
  br label %6, !dbg !265

6:                                                ; preds = %4
  br label %7, !dbg !267

7:                                                ; preds = %6
  br label %8, !dbg !265

8:                                                ; preds = %7
  br label %9, !dbg !263

9:                                                ; preds = %8
  call void @semaphore_acquire(%struct.semaphore_s* noundef @g_semaphore, i32 noundef 1), !dbg !269
  ret void, !dbg !270
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_release(i32 noundef %0) #0 !dbg !271 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !272, metadata !DIExpression()), !dbg !273
  br label %3, !dbg !274

3:                                                ; preds = %1
  br label %4, !dbg !275

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !277
  br label %6, !dbg !277

6:                                                ; preds = %4
  br label %7, !dbg !279

7:                                                ; preds = %6
  br label %8, !dbg !277

8:                                                ; preds = %7
  br label %9, !dbg !275

9:                                                ; preds = %8
  call void @semaphore_release(%struct.semaphore_s* noundef @g_semaphore, i32 noundef 1), !dbg !281
  ret void, !dbg !282
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !283 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !288, metadata !DIExpression()), !dbg !289
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !290, metadata !DIExpression()), !dbg !291
  %5 = load i32, i32* %4, align 4, !dbg !292
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !293
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !294
  %8 = load i32, i32* %7, align 4, !dbg !294
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !295, !srcloc !296
  ret void, !dbg !297
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_ge_sub_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !298 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !302, metadata !DIExpression()), !dbg !303
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !304, metadata !DIExpression()), !dbg !305
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !306, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.declare(metadata i32* %7, metadata !308, metadata !DIExpression()), !dbg !309
  store i32 0, i32* %7, align 4, !dbg !309
  call void @llvm.dbg.declare(metadata i32* %8, metadata !310, metadata !DIExpression()), !dbg !311
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !312
  %10 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %9), !dbg !313
  store i32 %10, i32* %8, align 4, !dbg !311
  br label %11, !dbg !314

11:                                               ; preds = %23, %3
  %12 = load i32, i32* %8, align 4, !dbg !315
  store i32 %12, i32* %7, align 4, !dbg !317
  br label %13, !dbg !318

13:                                               ; preds = %18, %11
  %14 = load i32, i32* %7, align 4, !dbg !319
  %15 = load i32, i32* %5, align 4, !dbg !320
  %16 = icmp uge i32 %14, %15, !dbg !321
  %17 = xor i1 %16, true, !dbg !322
  br i1 %17, label %18, label %22, !dbg !318

18:                                               ; preds = %13
  %19 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !323
  %20 = load i32, i32* %7, align 4, !dbg !325
  %21 = call i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef %19, i32 noundef %20), !dbg !326
  store i32 %21, i32* %7, align 4, !dbg !327
  br label %13, !dbg !318, !llvm.loop !328

22:                                               ; preds = %13
  br label %23, !dbg !330

23:                                               ; preds = %22
  %24 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !331
  %25 = load i32, i32* %7, align 4, !dbg !332
  %26 = load i32, i32* %7, align 4, !dbg !333
  %27 = load i32, i32* %6, align 4, !dbg !334
  %28 = sub i32 %26, %27, !dbg !335
  %29 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %24, i32 noundef %25, i32 noundef %28), !dbg !336
  store i32 %29, i32* %8, align 4, !dbg !337
  %30 = load i32, i32* %7, align 4, !dbg !338
  %31 = icmp ne i32 %29, %30, !dbg !339
  br i1 %31, label %11, label %32, !dbg !330, !llvm.loop !340

32:                                               ; preds = %23
  %33 = load i32, i32* %8, align 4, !dbg !342
  ret i32 %33, !dbg !343
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !344 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !349, metadata !DIExpression()), !dbg !350
  call void @llvm.dbg.declare(metadata i32* %3, metadata !351, metadata !DIExpression()), !dbg !352
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !353
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !354
  %6 = load i32, i32* %5, align 4, !dbg !354
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !355, !srcloc !356
  store i32 %7, i32* %3, align 4, !dbg !355
  %8 = load i32, i32* %3, align 4, !dbg !357
  ret i32 %8, !dbg !358
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !359 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !362, metadata !DIExpression()), !dbg !363
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !364, metadata !DIExpression()), !dbg !365
  call void @llvm.dbg.declare(metadata i32* %5, metadata !366, metadata !DIExpression()), !dbg !367
  %6 = load i32, i32* %4, align 4, !dbg !368
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !369
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !370
  %9 = load i32, i32* %8, align 4, !dbg !370
  %10 = call i32 asm sideeffect "1:\0Aldr ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.eq 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !371, !srcloc !372
  store i32 %10, i32* %5, align 4, !dbg !371
  %11 = load i32, i32* %5, align 4, !dbg !373
  ret i32 %11, !dbg !374
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !375 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !377, metadata !DIExpression()), !dbg !378
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !379, metadata !DIExpression()), !dbg !380
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !381, metadata !DIExpression()), !dbg !382
  call void @llvm.dbg.declare(metadata i32* %7, metadata !383, metadata !DIExpression()), !dbg !384
  call void @llvm.dbg.declare(metadata i32* %8, metadata !385, metadata !DIExpression()), !dbg !386
  %9 = load i32, i32* %6, align 4, !dbg !387
  %10 = load i32, i32* %5, align 4, !dbg !388
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !389
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !390
  %13 = load i32, i32* %12, align 4, !dbg !390
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldaxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !391, !srcloc !392
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !391
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !391
  store i32 %15, i32* %7, align 4, !dbg !391
  store i32 %16, i32* %8, align 4, !dbg !391
  %17 = load i32, i32* %7, align 4, !dbg !393
  ret i32 %17, !dbg !394
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !395 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !396, metadata !DIExpression()), !dbg !397
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !398, metadata !DIExpression()), !dbg !399
  call void @llvm.dbg.declare(metadata i32* %5, metadata !400, metadata !DIExpression()), !dbg !401
  call void @llvm.dbg.declare(metadata i32* %6, metadata !402, metadata !DIExpression()), !dbg !403
  call void @llvm.dbg.declare(metadata i32* %7, metadata !404, metadata !DIExpression()), !dbg !405
  %8 = load i32, i32* %4, align 4, !dbg !406
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !407
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !408
  %11 = load i32, i32* %10, align 4, !dbg !408
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astlxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #6, !dbg !406, !srcloc !409
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !406
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !406
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !406
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !406
  store i32 %13, i32* %5, align 4, !dbg !406
  store i32 %14, i32* %6, align 4, !dbg !406
  store i32 %15, i32* %7, align 4, !dbg !406
  store i32 %16, i32* %4, align 4, !dbg !406
  ret void, !dbg !410
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!34, !35, !36, !37, !38, !39, !40}
!llvm.ident = !{!41}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !33, line: 110, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/spinlock/test/semaphore.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1505933d5f02ad9ab5390c9bfbdb8ca9")
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
!17 = !{!18, !0, !31}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "g_semaphore", scope: !2, file: !20, line: 15, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "spinlock/test/semaphore.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1505933d5f02ad9ab5390c9bfbdb8ca9")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "semaphore_t", file: !22, line: 23, baseType: !23)
!22 = !DIFile(filename: "spinlock/include/vsync/spinlock/semaphore.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "656e3c09907ca0329e914e7c2d0080c0")
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "semaphore_s", file: !22, line: 21, size: 32, elements: !24)
!24 = !{!25}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "s", scope: !23, file: !22, line: 22, baseType: !26, size: 32, align: 32)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !27, line: 34, baseType: !28)
!27 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !27, line: 32, size: 32, align: 32, elements: !29)
!29 = !{!30}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !28, file: !27, line: 33, baseType: !6, size: 32)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !33, line: 111, type: !6, isLocal: true, isDefinition: true)
!33 = !DIFile(filename: "utils/include/test/boilerplate/reader_writer.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4e1dc695be02c115383d13b32ef6a829")
!34 = !{i32 7, !"Dwarf Version", i32 5}
!35 = !{i32 2, !"Debug Info Version", i32 3}
!36 = !{i32 1, !"wchar_size", i32 4}
!37 = !{i32 7, !"PIC Level", i32 2}
!38 = !{i32 7, !"PIE Level", i32 2}
!39 = !{i32 7, !"uwtable", i32 1}
!40 = !{i32 7, !"frame-pointer", i32 2}
!41 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!42 = distinct !DISubprogram(name: "post", scope: !33, file: !33, line: 63, type: !43, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!43 = !DISubroutineType(types: !44)
!44 = !{null}
!45 = !{}
!46 = !DILocation(line: 65, column: 1, scope: !42)
!47 = distinct !DISubprogram(name: "fini", scope: !33, file: !33, line: 72, type: !43, scopeLine: 73, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!48 = !DILocation(line: 74, column: 1, scope: !47)
!49 = distinct !DISubprogram(name: "writer_cs", scope: !33, file: !33, line: 114, type: !50, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!50 = !DISubroutineType(types: !51)
!51 = !{null, !6}
!52 = !DILocalVariable(name: "tid", arg: 1, scope: !49, file: !33, line: 114, type: !6)
!53 = !DILocation(line: 114, column: 21, scope: !49)
!54 = !DILocation(line: 116, column: 5, scope: !49)
!55 = !DILocation(line: 116, column: 5, scope: !56)
!56 = distinct !DILexicalBlock(scope: !49, file: !33, line: 116, column: 5)
!57 = !DILocation(line: 116, column: 5, scope: !58)
!58 = distinct !DILexicalBlock(scope: !56, file: !33, line: 116, column: 5)
!59 = !DILocation(line: 116, column: 5, scope: !60)
!60 = distinct !DILexicalBlock(scope: !58, file: !33, line: 116, column: 5)
!61 = !DILocation(line: 117, column: 11, scope: !49)
!62 = !DILocation(line: 118, column: 11, scope: !49)
!63 = !DILocation(line: 119, column: 1, scope: !49)
!64 = distinct !DISubprogram(name: "reader_cs", scope: !33, file: !33, line: 121, type: !50, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!65 = !DILocalVariable(name: "tid", arg: 1, scope: !64, file: !33, line: 121, type: !6)
!66 = !DILocation(line: 121, column: 21, scope: !64)
!67 = !DILocation(line: 123, column: 5, scope: !64)
!68 = !DILocation(line: 123, column: 5, scope: !69)
!69 = distinct !DILexicalBlock(scope: !64, file: !33, line: 123, column: 5)
!70 = !DILocation(line: 123, column: 5, scope: !71)
!71 = distinct !DILexicalBlock(scope: !69, file: !33, line: 123, column: 5)
!72 = !DILocation(line: 123, column: 5, scope: !73)
!73 = distinct !DILexicalBlock(scope: !71, file: !33, line: 123, column: 5)
!74 = !DILocalVariable(name: "a", scope: !64, file: !33, line: 124, type: !12)
!75 = !DILocation(line: 124, column: 14, scope: !64)
!76 = !DILocation(line: 124, column: 19, scope: !64)
!77 = !DILocation(line: 124, column: 29, scope: !64)
!78 = !DILocation(line: 124, column: 26, scope: !64)
!79 = !DILocation(line: 125, column: 5, scope: !80)
!80 = distinct !DILexicalBlock(scope: !81, file: !33, line: 125, column: 5)
!81 = distinct !DILexicalBlock(scope: !64, file: !33, line: 125, column: 5)
!82 = !DILocation(line: 125, column: 5, scope: !81)
!83 = !DILocation(line: 126, column: 1, scope: !64)
!84 = distinct !DISubprogram(name: "check", scope: !33, file: !33, line: 128, type: !43, scopeLine: 129, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!85 = !DILocation(line: 130, column: 5, scope: !86)
!86 = distinct !DILexicalBlock(scope: !87, file: !33, line: 130, column: 5)
!87 = distinct !DILexicalBlock(scope: !84, file: !33, line: 130, column: 5)
!88 = !DILocation(line: 130, column: 5, scope: !87)
!89 = !DILocation(line: 131, column: 5, scope: !90)
!90 = distinct !DILexicalBlock(scope: !91, file: !33, line: 131, column: 5)
!91 = distinct !DILexicalBlock(scope: !84, file: !33, line: 131, column: 5)
!92 = !DILocation(line: 131, column: 5, scope: !91)
!93 = !DILocation(line: 132, column: 1, scope: !84)
!94 = distinct !DISubprogram(name: "main", scope: !33, file: !33, line: 158, type: !95, scopeLine: 159, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!95 = !DISubroutineType(types: !96)
!96 = !{!97}
!97 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!98 = !DILocalVariable(name: "t", scope: !94, file: !33, line: 160, type: !99)
!99 = !DICompositeType(tag: DW_TAG_array_type, baseType: !100, size: 192, elements: !102)
!100 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !101, line: 27, baseType: !16)
!101 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!102 = !{!103}
!103 = !DISubrange(count: 3)
!104 = !DILocation(line: 160, column: 15, scope: !94)
!105 = !DILocation(line: 167, column: 5, scope: !94)
!106 = !DILocalVariable(name: "i", scope: !107, file: !33, line: 169, type: !13)
!107 = distinct !DILexicalBlock(scope: !94, file: !33, line: 169, column: 5)
!108 = !DILocation(line: 169, column: 21, scope: !107)
!109 = !DILocation(line: 169, column: 10, scope: !107)
!110 = !DILocation(line: 169, column: 28, scope: !111)
!111 = distinct !DILexicalBlock(scope: !107, file: !33, line: 169, column: 5)
!112 = !DILocation(line: 169, column: 30, scope: !111)
!113 = !DILocation(line: 169, column: 5, scope: !107)
!114 = !DILocation(line: 170, column: 33, scope: !115)
!115 = distinct !DILexicalBlock(scope: !111, file: !33, line: 169, column: 47)
!116 = !DILocation(line: 170, column: 31, scope: !115)
!117 = !DILocation(line: 170, column: 56, scope: !115)
!118 = !DILocation(line: 170, column: 48, scope: !115)
!119 = !DILocation(line: 170, column: 15, scope: !115)
!120 = !DILocation(line: 171, column: 5, scope: !115)
!121 = !DILocation(line: 169, column: 43, scope: !111)
!122 = !DILocation(line: 169, column: 5, scope: !111)
!123 = distinct !{!123, !113, !124, !125}
!124 = !DILocation(line: 171, column: 5, scope: !107)
!125 = !{!"llvm.loop.mustprogress"}
!126 = !DILocalVariable(name: "i", scope: !127, file: !33, line: 173, type: !13)
!127 = distinct !DILexicalBlock(scope: !94, file: !33, line: 173, column: 5)
!128 = !DILocation(line: 173, column: 21, scope: !127)
!129 = !DILocation(line: 173, column: 10, scope: !127)
!130 = !DILocation(line: 173, column: 35, scope: !131)
!131 = distinct !DILexicalBlock(scope: !127, file: !33, line: 173, column: 5)
!132 = !DILocation(line: 173, column: 37, scope: !131)
!133 = !DILocation(line: 173, column: 5, scope: !127)
!134 = !DILocation(line: 174, column: 33, scope: !135)
!135 = distinct !DILexicalBlock(scope: !131, file: !33, line: 173, column: 54)
!136 = !DILocation(line: 174, column: 31, scope: !135)
!137 = !DILocation(line: 174, column: 56, scope: !135)
!138 = !DILocation(line: 174, column: 48, scope: !135)
!139 = !DILocation(line: 174, column: 15, scope: !135)
!140 = !DILocation(line: 175, column: 5, scope: !135)
!141 = !DILocation(line: 173, column: 50, scope: !131)
!142 = !DILocation(line: 173, column: 5, scope: !131)
!143 = distinct !{!143, !133, !144, !125}
!144 = !DILocation(line: 175, column: 5, scope: !127)
!145 = !DILocation(line: 177, column: 5, scope: !94)
!146 = !DILocalVariable(name: "i", scope: !147, file: !33, line: 179, type: !13)
!147 = distinct !DILexicalBlock(scope: !94, file: !33, line: 179, column: 5)
!148 = !DILocation(line: 179, column: 21, scope: !147)
!149 = !DILocation(line: 179, column: 10, scope: !147)
!150 = !DILocation(line: 179, column: 28, scope: !151)
!151 = distinct !DILexicalBlock(scope: !147, file: !33, line: 179, column: 5)
!152 = !DILocation(line: 179, column: 30, scope: !151)
!153 = !DILocation(line: 179, column: 5, scope: !147)
!154 = !DILocation(line: 180, column: 30, scope: !155)
!155 = distinct !DILexicalBlock(scope: !151, file: !33, line: 179, column: 47)
!156 = !DILocation(line: 180, column: 28, scope: !155)
!157 = !DILocation(line: 180, column: 15, scope: !155)
!158 = !DILocation(line: 181, column: 5, scope: !155)
!159 = !DILocation(line: 179, column: 43, scope: !151)
!160 = !DILocation(line: 179, column: 5, scope: !151)
!161 = distinct !{!161, !153, !162, !125}
!162 = !DILocation(line: 181, column: 5, scope: !147)
!163 = !DILocation(line: 188, column: 5, scope: !94)
!164 = !DILocation(line: 189, column: 5, scope: !94)
!165 = !DILocation(line: 191, column: 5, scope: !94)
!166 = distinct !DISubprogram(name: "init", scope: !20, file: !20, line: 19, type: !43, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!167 = !DILocation(line: 21, column: 5, scope: !166)
!168 = !DILocation(line: 22, column: 1, scope: !166)
!169 = distinct !DISubprogram(name: "writer", scope: !33, file: !33, line: 137, type: !170, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!170 = !DISubroutineType(types: !171)
!171 = !{!5, !5}
!172 = !DILocalVariable(name: "arg", arg: 1, scope: !169, file: !33, line: 137, type: !5)
!173 = !DILocation(line: 137, column: 14, scope: !169)
!174 = !DILocalVariable(name: "tid", scope: !169, file: !33, line: 139, type: !6)
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
!186 = distinct !DISubprogram(name: "reader", scope: !33, file: !33, line: 147, type: !170, scopeLine: 148, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!187 = !DILocalVariable(name: "arg", arg: 1, scope: !186, file: !33, line: 147, type: !5)
!188 = !DILocation(line: 147, column: 14, scope: !186)
!189 = !DILocalVariable(name: "tid", scope: !186, file: !33, line: 149, type: !6)
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
!201 = distinct !DISubprogram(name: "semaphore_init", scope: !22, file: !22, line: 40, type: !202, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!202 = !DISubroutineType(types: !203)
!203 = !{null, !204, !6}
!204 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!205 = !DILocalVariable(name: "s", arg: 1, scope: !201, file: !22, line: 40, type: !204)
!206 = !DILocation(line: 40, column: 29, scope: !201)
!207 = !DILocalVariable(name: "n", arg: 2, scope: !201, file: !22, line: 40, type: !6)
!208 = !DILocation(line: 40, column: 42, scope: !201)
!209 = !DILocation(line: 42, column: 22, scope: !201)
!210 = !DILocation(line: 42, column: 25, scope: !201)
!211 = !DILocation(line: 42, column: 28, scope: !201)
!212 = !DILocation(line: 42, column: 5, scope: !201)
!213 = !DILocation(line: 43, column: 1, scope: !201)
!214 = distinct !DISubprogram(name: "writer_acquire", scope: !20, file: !20, line: 25, type: !50, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!215 = !DILocalVariable(name: "tid", arg: 1, scope: !214, file: !20, line: 25, type: !6)
!216 = !DILocation(line: 25, column: 26, scope: !214)
!217 = !DILocation(line: 27, column: 5, scope: !214)
!218 = !DILocation(line: 27, column: 5, scope: !219)
!219 = distinct !DILexicalBlock(scope: !214, file: !20, line: 27, column: 5)
!220 = !DILocation(line: 27, column: 5, scope: !221)
!221 = distinct !DILexicalBlock(scope: !219, file: !20, line: 27, column: 5)
!222 = !DILocation(line: 27, column: 5, scope: !223)
!223 = distinct !DILexicalBlock(scope: !221, file: !20, line: 27, column: 5)
!224 = !DILocation(line: 28, column: 5, scope: !214)
!225 = !DILocation(line: 29, column: 1, scope: !214)
!226 = distinct !DISubprogram(name: "semaphore_acquire", scope: !22, file: !22, line: 55, type: !202, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!227 = !DILocalVariable(name: "s", arg: 1, scope: !226, file: !22, line: 55, type: !204)
!228 = !DILocation(line: 55, column: 32, scope: !226)
!229 = !DILocalVariable(name: "i", arg: 2, scope: !226, file: !22, line: 55, type: !6)
!230 = !DILocation(line: 55, column: 45, scope: !226)
!231 = !DILocation(line: 60, column: 33, scope: !226)
!232 = !DILocation(line: 60, column: 36, scope: !226)
!233 = !DILocation(line: 60, column: 39, scope: !226)
!234 = !DILocation(line: 60, column: 42, scope: !226)
!235 = !DILocation(line: 60, column: 5, scope: !226)
!236 = !DILocation(line: 61, column: 1, scope: !226)
!237 = distinct !DISubprogram(name: "writer_release", scope: !20, file: !20, line: 32, type: !50, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!238 = !DILocalVariable(name: "tid", arg: 1, scope: !237, file: !20, line: 32, type: !6)
!239 = !DILocation(line: 32, column: 26, scope: !237)
!240 = !DILocation(line: 34, column: 5, scope: !237)
!241 = !DILocation(line: 34, column: 5, scope: !242)
!242 = distinct !DILexicalBlock(scope: !237, file: !20, line: 34, column: 5)
!243 = !DILocation(line: 34, column: 5, scope: !244)
!244 = distinct !DILexicalBlock(scope: !242, file: !20, line: 34, column: 5)
!245 = !DILocation(line: 34, column: 5, scope: !246)
!246 = distinct !DILexicalBlock(scope: !244, file: !20, line: 34, column: 5)
!247 = !DILocation(line: 35, column: 5, scope: !237)
!248 = !DILocation(line: 36, column: 1, scope: !237)
!249 = distinct !DISubprogram(name: "semaphore_release", scope: !22, file: !22, line: 88, type: !202, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!250 = !DILocalVariable(name: "s", arg: 1, scope: !249, file: !22, line: 88, type: !204)
!251 = !DILocation(line: 88, column: 32, scope: !249)
!252 = !DILocalVariable(name: "i", arg: 2, scope: !249, file: !22, line: 88, type: !6)
!253 = !DILocation(line: 88, column: 45, scope: !249)
!254 = !DILocation(line: 90, column: 24, scope: !249)
!255 = !DILocation(line: 90, column: 27, scope: !249)
!256 = !DILocation(line: 90, column: 30, scope: !249)
!257 = !DILocation(line: 90, column: 5, scope: !249)
!258 = !DILocation(line: 91, column: 1, scope: !249)
!259 = distinct !DISubprogram(name: "reader_acquire", scope: !20, file: !20, line: 38, type: !50, scopeLine: 39, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!260 = !DILocalVariable(name: "tid", arg: 1, scope: !259, file: !20, line: 38, type: !6)
!261 = !DILocation(line: 38, column: 26, scope: !259)
!262 = !DILocation(line: 40, column: 5, scope: !259)
!263 = !DILocation(line: 40, column: 5, scope: !264)
!264 = distinct !DILexicalBlock(scope: !259, file: !20, line: 40, column: 5)
!265 = !DILocation(line: 40, column: 5, scope: !266)
!266 = distinct !DILexicalBlock(scope: !264, file: !20, line: 40, column: 5)
!267 = !DILocation(line: 40, column: 5, scope: !268)
!268 = distinct !DILexicalBlock(scope: !266, file: !20, line: 40, column: 5)
!269 = !DILocation(line: 41, column: 5, scope: !259)
!270 = !DILocation(line: 42, column: 1, scope: !259)
!271 = distinct !DISubprogram(name: "reader_release", scope: !20, file: !20, line: 45, type: !50, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!272 = !DILocalVariable(name: "tid", arg: 1, scope: !271, file: !20, line: 45, type: !6)
!273 = !DILocation(line: 45, column: 26, scope: !271)
!274 = !DILocation(line: 47, column: 5, scope: !271)
!275 = !DILocation(line: 47, column: 5, scope: !276)
!276 = distinct !DILexicalBlock(scope: !271, file: !20, line: 47, column: 5)
!277 = !DILocation(line: 47, column: 5, scope: !278)
!278 = distinct !DILexicalBlock(scope: !276, file: !20, line: 47, column: 5)
!279 = !DILocation(line: 47, column: 5, scope: !280)
!280 = distinct !DILexicalBlock(scope: !278, file: !20, line: 47, column: 5)
!281 = !DILocation(line: 48, column: 5, scope: !271)
!282 = !DILocation(line: 49, column: 1, scope: !271)
!283 = distinct !DISubprogram(name: "vatomic32_write", scope: !284, file: !284, line: 213, type: !285, scopeLine: 214, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!284 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!285 = !DISubroutineType(types: !286)
!286 = !{null, !287, !6}
!287 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!288 = !DILocalVariable(name: "a", arg: 1, scope: !283, file: !284, line: 213, type: !287)
!289 = !DILocation(line: 213, column: 30, scope: !283)
!290 = !DILocalVariable(name: "v", arg: 2, scope: !283, file: !284, line: 213, type: !6)
!291 = !DILocation(line: 213, column: 43, scope: !283)
!292 = !DILocation(line: 217, column: 32, scope: !283)
!293 = !DILocation(line: 217, column: 44, scope: !283)
!294 = !DILocation(line: 217, column: 47, scope: !283)
!295 = !DILocation(line: 215, column: 5, scope: !283)
!296 = !{i64 401980}
!297 = !DILocation(line: 219, column: 1, scope: !283)
!298 = distinct !DISubprogram(name: "vatomic32_await_ge_sub_acq", scope: !299, file: !299, line: 5444, type: !300, scopeLine: 5445, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!299 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!300 = !DISubroutineType(types: !301)
!301 = !{!6, !287, !6, !6}
!302 = !DILocalVariable(name: "a", arg: 1, scope: !298, file: !299, line: 5444, type: !287)
!303 = !DILocation(line: 5444, column: 41, scope: !298)
!304 = !DILocalVariable(name: "c", arg: 2, scope: !298, file: !299, line: 5444, type: !6)
!305 = !DILocation(line: 5444, column: 54, scope: !298)
!306 = !DILocalVariable(name: "v", arg: 3, scope: !298, file: !299, line: 5444, type: !6)
!307 = !DILocation(line: 5444, column: 67, scope: !298)
!308 = !DILocalVariable(name: "cur", scope: !298, file: !299, line: 5446, type: !6)
!309 = !DILocation(line: 5446, column: 15, scope: !298)
!310 = !DILocalVariable(name: "old", scope: !298, file: !299, line: 5447, type: !6)
!311 = !DILocation(line: 5447, column: 15, scope: !298)
!312 = !DILocation(line: 5447, column: 40, scope: !298)
!313 = !DILocation(line: 5447, column: 21, scope: !298)
!314 = !DILocation(line: 5448, column: 5, scope: !298)
!315 = !DILocation(line: 5449, column: 15, scope: !316)
!316 = distinct !DILexicalBlock(scope: !298, file: !299, line: 5448, column: 8)
!317 = !DILocation(line: 5449, column: 13, scope: !316)
!318 = !DILocation(line: 5450, column: 9, scope: !316)
!319 = !DILocation(line: 5450, column: 18, scope: !316)
!320 = !DILocation(line: 5450, column: 25, scope: !316)
!321 = !DILocation(line: 5450, column: 22, scope: !316)
!322 = !DILocation(line: 5450, column: 16, scope: !316)
!323 = !DILocation(line: 5451, column: 43, scope: !324)
!324 = distinct !DILexicalBlock(scope: !316, file: !299, line: 5450, column: 29)
!325 = !DILocation(line: 5451, column: 46, scope: !324)
!326 = !DILocation(line: 5451, column: 19, scope: !324)
!327 = !DILocation(line: 5451, column: 17, scope: !324)
!328 = distinct !{!328, !318, !329, !125}
!329 = !DILocation(line: 5452, column: 9, scope: !316)
!330 = !DILocation(line: 5453, column: 5, scope: !316)
!331 = !DILocation(line: 5453, column: 43, scope: !298)
!332 = !DILocation(line: 5453, column: 46, scope: !298)
!333 = !DILocation(line: 5453, column: 51, scope: !298)
!334 = !DILocation(line: 5453, column: 57, scope: !298)
!335 = !DILocation(line: 5453, column: 55, scope: !298)
!336 = !DILocation(line: 5453, column: 21, scope: !298)
!337 = !DILocation(line: 5453, column: 19, scope: !298)
!338 = !DILocation(line: 5453, column: 64, scope: !298)
!339 = !DILocation(line: 5453, column: 61, scope: !298)
!340 = distinct !{!340, !314, !341, !125}
!341 = !DILocation(line: 5453, column: 67, scope: !298)
!342 = !DILocation(line: 5454, column: 12, scope: !298)
!343 = !DILocation(line: 5454, column: 5, scope: !298)
!344 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !284, file: !284, line: 101, type: !345, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!345 = !DISubroutineType(types: !346)
!346 = !{!6, !347}
!347 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !348, size: 64)
!348 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !26)
!349 = !DILocalVariable(name: "a", arg: 1, scope: !344, file: !284, line: 101, type: !347)
!350 = !DILocation(line: 101, column: 39, scope: !344)
!351 = !DILocalVariable(name: "val", scope: !344, file: !284, line: 103, type: !6)
!352 = !DILocation(line: 103, column: 15, scope: !344)
!353 = !DILocation(line: 106, column: 32, scope: !344)
!354 = !DILocation(line: 106, column: 35, scope: !344)
!355 = !DILocation(line: 104, column: 5, scope: !344)
!356 = !{i64 398536}
!357 = !DILocation(line: 108, column: 12, scope: !344)
!358 = !DILocation(line: 108, column: 5, scope: !344)
!359 = distinct !DISubprogram(name: "vatomic32_await_neq_rlx", scope: !284, file: !284, line: 912, type: !360, scopeLine: 913, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!360 = !DISubroutineType(types: !361)
!361 = !{!6, !347, !6}
!362 = !DILocalVariable(name: "a", arg: 1, scope: !359, file: !284, line: 912, type: !347)
!363 = !DILocation(line: 912, column: 44, scope: !359)
!364 = !DILocalVariable(name: "v", arg: 2, scope: !359, file: !284, line: 912, type: !6)
!365 = !DILocation(line: 912, column: 57, scope: !359)
!366 = !DILocalVariable(name: "val", scope: !359, file: !284, line: 914, type: !6)
!367 = !DILocation(line: 914, column: 15, scope: !359)
!368 = !DILocation(line: 921, column: 21, scope: !359)
!369 = !DILocation(line: 921, column: 33, scope: !359)
!370 = !DILocation(line: 921, column: 36, scope: !359)
!371 = !DILocation(line: 915, column: 5, scope: !359)
!372 = !{i64 421142, i64 421158, i64 421188, i64 421221}
!373 = !DILocation(line: 923, column: 12, scope: !359)
!374 = !DILocation(line: 923, column: 5, scope: !359)
!375 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !376, file: !376, line: 311, type: !300, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!376 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!377 = !DILocalVariable(name: "a", arg: 1, scope: !375, file: !376, line: 311, type: !287)
!378 = !DILocation(line: 311, column: 36, scope: !375)
!379 = !DILocalVariable(name: "e", arg: 2, scope: !375, file: !376, line: 311, type: !6)
!380 = !DILocation(line: 311, column: 49, scope: !375)
!381 = !DILocalVariable(name: "v", arg: 3, scope: !375, file: !376, line: 311, type: !6)
!382 = !DILocation(line: 311, column: 62, scope: !375)
!383 = !DILocalVariable(name: "oldv", scope: !375, file: !376, line: 313, type: !6)
!384 = !DILocation(line: 313, column: 15, scope: !375)
!385 = !DILocalVariable(name: "tmp", scope: !375, file: !376, line: 314, type: !6)
!386 = !DILocation(line: 314, column: 15, scope: !375)
!387 = !DILocation(line: 325, column: 22, scope: !375)
!388 = !DILocation(line: 325, column: 36, scope: !375)
!389 = !DILocation(line: 325, column: 48, scope: !375)
!390 = !DILocation(line: 325, column: 51, scope: !375)
!391 = !DILocation(line: 315, column: 5, scope: !375)
!392 = !{i64 463444, i64 463478, i64 463493, i64 463526, i64 463560, i64 463580, i64 463622, i64 463651}
!393 = !DILocation(line: 327, column: 12, scope: !375)
!394 = !DILocation(line: 327, column: 5, scope: !375)
!395 = distinct !DISubprogram(name: "vatomic32_add_rel", scope: !376, file: !376, line: 2122, type: !285, scopeLine: 2123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!396 = !DILocalVariable(name: "a", arg: 1, scope: !395, file: !376, line: 2122, type: !287)
!397 = !DILocation(line: 2122, column: 32, scope: !395)
!398 = !DILocalVariable(name: "v", arg: 2, scope: !395, file: !376, line: 2122, type: !6)
!399 = !DILocation(line: 2122, column: 45, scope: !395)
!400 = !DILocalVariable(name: "oldv", scope: !395, file: !376, line: 2124, type: !6)
!401 = !DILocation(line: 2124, column: 15, scope: !395)
!402 = !DILocalVariable(name: "newv", scope: !395, file: !376, line: 2125, type: !6)
!403 = !DILocation(line: 2125, column: 15, scope: !395)
!404 = !DILocalVariable(name: "tmp", scope: !395, file: !376, line: 2126, type: !6)
!405 = !DILocation(line: 2126, column: 15, scope: !395)
!406 = !DILocation(line: 2127, column: 5, scope: !395)
!407 = !DILocation(line: 2135, column: 19, scope: !395)
!408 = !DILocation(line: 2135, column: 22, scope: !395)
!409 = !{i64 517944, i64 517978, i64 517993, i64 518025, i64 518067, i64 518109}
!410 = !DILocation(line: 2137, column: 1, scope: !395)
