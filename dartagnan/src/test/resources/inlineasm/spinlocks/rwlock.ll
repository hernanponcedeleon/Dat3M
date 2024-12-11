; ModuleID = '/home/stefano/huawei/libvsync/spinlock/test/rwlock.c'
source_filename = "/home/stefano/huawei/libvsync/spinlock/test/rwlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.rwlock_s = type { i32, %struct.vatomic32_s, %struct.semaphore_s }
%struct.vatomic32_s = type { i32 }
%struct.semaphore_s = type { %struct.vatomic32_s }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !38
@.str = private unnamed_addr constant [25 x i8] c"g_cs_x and g_cs_y differ\00", align 1
@.str.1 = private unnamed_addr constant [32 x i8] c"a && \22g_cs_x and g_cs_y differ\22\00", align 1
@.str.2 = private unnamed_addr constant [77 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/boilerplate/reader_writer.h\00", align 1
@__PRETTY_FUNCTION__.reader_cs = private unnamed_addr constant [26 x i8] c"void reader_cs(vuint32_t)\00", align 1
@.str.3 = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"g_cs_x == 2\00", align 1
@lock = dso_local global %struct.rwlock_s { i32 1073741824, %struct.vatomic32_s zeroinitializer, %struct.semaphore_s { %struct.vatomic32_s { i32 1073741824 } } }, align 4, !dbg !18

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !49 {
  ret void, !dbg !53
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !54 {
  ret void, !dbg !55
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !56 {
  ret void, !dbg !57
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_cs(i32 noundef %0) #0 !dbg !58 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !61, metadata !DIExpression()), !dbg !62
  br label %3, !dbg !63

3:                                                ; preds = %1
  br label %4, !dbg !64

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !66
  br label %6, !dbg !66

6:                                                ; preds = %4
  br label %7, !dbg !68

7:                                                ; preds = %6
  br label %8, !dbg !66

8:                                                ; preds = %7
  br label %9, !dbg !64

9:                                                ; preds = %8
  %10 = load i32, i32* @g_cs_x, align 4, !dbg !70
  %11 = add i32 %10, 1, !dbg !70
  store i32 %11, i32* @g_cs_x, align 4, !dbg !70
  %12 = load i32, i32* @g_cs_y, align 4, !dbg !71
  %13 = add i32 %12, 1, !dbg !71
  store i32 %13, i32* @g_cs_y, align 4, !dbg !71
  ret void, !dbg !72
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_cs(i32 noundef %0) #0 !dbg !73 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !74, metadata !DIExpression()), !dbg !75
  br label %4, !dbg !76

4:                                                ; preds = %1
  br label %5, !dbg !77

5:                                                ; preds = %4
  %6 = load i32, i32* %2, align 4, !dbg !79
  br label %7, !dbg !79

7:                                                ; preds = %5
  br label %8, !dbg !81

8:                                                ; preds = %7
  br label %9, !dbg !79

9:                                                ; preds = %8
  br label %10, !dbg !77

10:                                               ; preds = %9
  call void @llvm.dbg.declare(metadata i32* %3, metadata !83, metadata !DIExpression()), !dbg !84
  %11 = load i32, i32* @g_cs_x, align 4, !dbg !85
  %12 = load i32, i32* @g_cs_y, align 4, !dbg !86
  %13 = icmp eq i32 %11, %12, !dbg !87
  %14 = zext i1 %13 to i32, !dbg !87
  store i32 %14, i32* %3, align 4, !dbg !84
  %15 = load i32, i32* %3, align 4, !dbg !88
  %16 = icmp ne i32 %15, 0, !dbg !88
  br i1 %16, label %17, label %19, !dbg !88

17:                                               ; preds = %10
  br i1 true, label %18, label %19, !dbg !91

18:                                               ; preds = %17
  br label %20, !dbg !91

19:                                               ; preds = %17, %10
  call void @__assert_fail(i8* noundef getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i64 0, i64 0), i8* noundef getelementptr inbounds ([77 x i8], [77 x i8]* @.str.2, i64 0, i64 0), i32 noundef 125, i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @__PRETTY_FUNCTION__.reader_cs, i64 0, i64 0)) #5, !dbg !88
  unreachable, !dbg !88

20:                                               ; preds = %18
  ret void, !dbg !92
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !93 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !94
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !94
  %3 = icmp eq i32 %1, %2, !dbg !94
  br i1 %3, label %4, label %5, !dbg !97

4:                                                ; preds = %0
  br label %6, !dbg !97

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([77 x i8], [77 x i8]* @.str.2, i64 0, i64 0), i32 noundef 130, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !94
  unreachable, !dbg !94

6:                                                ; preds = %4
  %7 = load i32, i32* @g_cs_x, align 4, !dbg !98
  %8 = icmp eq i32 %7, 2, !dbg !98
  br i1 %8, label %9, label %10, !dbg !101

9:                                                ; preds = %6
  br label %11, !dbg !101

10:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([77 x i8], [77 x i8]* @.str.2, i64 0, i64 0), i32 noundef 131, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !98
  unreachable, !dbg !98

11:                                               ; preds = %9
  ret void, !dbg !102
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !103 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i64]* %2, metadata !107, metadata !DIExpression()), !dbg !113
  call void @init(), !dbg !114
  call void @llvm.dbg.declare(metadata i64* %3, metadata !115, metadata !DIExpression()), !dbg !117
  store i64 0, i64* %3, align 8, !dbg !117
  br label %6, !dbg !118

6:                                                ; preds = %15, %0
  %7 = load i64, i64* %3, align 8, !dbg !119
  %8 = icmp ult i64 %7, 2, !dbg !121
  br i1 %8, label %9, label %18, !dbg !122

9:                                                ; preds = %6
  %10 = load i64, i64* %3, align 8, !dbg !123
  %11 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %10, !dbg !125
  %12 = load i64, i64* %3, align 8, !dbg !126
  %13 = inttoptr i64 %12 to i8*, !dbg !127
  %14 = call i32 @pthread_create(i64* noundef %11, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef %13) #6, !dbg !128
  br label %15, !dbg !129

15:                                               ; preds = %9
  %16 = load i64, i64* %3, align 8, !dbg !130
  %17 = add i64 %16, 1, !dbg !130
  store i64 %17, i64* %3, align 8, !dbg !130
  br label %6, !dbg !131, !llvm.loop !132

18:                                               ; preds = %6
  call void @llvm.dbg.declare(metadata i64* %4, metadata !135, metadata !DIExpression()), !dbg !137
  store i64 2, i64* %4, align 8, !dbg !137
  br label %19, !dbg !138

19:                                               ; preds = %28, %18
  %20 = load i64, i64* %4, align 8, !dbg !139
  %21 = icmp ult i64 %20, 3, !dbg !141
  br i1 %21, label %22, label %31, !dbg !142

22:                                               ; preds = %19
  %23 = load i64, i64* %4, align 8, !dbg !143
  %24 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %23, !dbg !145
  %25 = load i64, i64* %4, align 8, !dbg !146
  %26 = inttoptr i64 %25 to i8*, !dbg !147
  %27 = call i32 @pthread_create(i64* noundef %24, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef %26) #6, !dbg !148
  br label %28, !dbg !149

28:                                               ; preds = %22
  %29 = load i64, i64* %4, align 8, !dbg !150
  %30 = add i64 %29, 1, !dbg !150
  store i64 %30, i64* %4, align 8, !dbg !150
  br label %19, !dbg !151, !llvm.loop !152

31:                                               ; preds = %19
  call void @post(), !dbg !154
  call void @llvm.dbg.declare(metadata i64* %5, metadata !155, metadata !DIExpression()), !dbg !157
  store i64 0, i64* %5, align 8, !dbg !157
  br label %32, !dbg !158

32:                                               ; preds = %40, %31
  %33 = load i64, i64* %5, align 8, !dbg !159
  %34 = icmp ult i64 %33, 3, !dbg !161
  br i1 %34, label %35, label %43, !dbg !162

35:                                               ; preds = %32
  %36 = load i64, i64* %5, align 8, !dbg !163
  %37 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %36, !dbg !165
  %38 = load i64, i64* %37, align 8, !dbg !165
  %39 = call i32 @pthread_join(i64 noundef %38, i8** noundef null), !dbg !166
  br label %40, !dbg !167

40:                                               ; preds = %35
  %41 = load i64, i64* %5, align 8, !dbg !168
  %42 = add i64 %41, 1, !dbg !168
  store i64 %42, i64* %5, align 8, !dbg !168
  br label %32, !dbg !169, !llvm.loop !170

43:                                               ; preds = %32
  call void @check(), !dbg !172
  call void @fini(), !dbg !173
  ret i32 0, !dbg !174
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @writer(i8* noundef %0) #0 !dbg !175 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !178, metadata !DIExpression()), !dbg !179
  call void @llvm.dbg.declare(metadata i32* %3, metadata !180, metadata !DIExpression()), !dbg !181
  %4 = load i8*, i8** %2, align 8, !dbg !182
  %5 = ptrtoint i8* %4 to i64, !dbg !183
  %6 = trunc i64 %5 to i32, !dbg !184
  store i32 %6, i32* %3, align 4, !dbg !181
  %7 = load i32, i32* %3, align 4, !dbg !185
  call void @writer_acquire(i32 noundef %7), !dbg !186
  %8 = load i32, i32* %3, align 4, !dbg !187
  call void @writer_cs(i32 noundef %8), !dbg !188
  %9 = load i32, i32* %3, align 4, !dbg !189
  call void @writer_release(i32 noundef %9), !dbg !190
  ret i8* null, !dbg !191
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @reader(i8* noundef %0) #0 !dbg !192 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !193, metadata !DIExpression()), !dbg !194
  call void @llvm.dbg.declare(metadata i32* %3, metadata !195, metadata !DIExpression()), !dbg !196
  %4 = load i8*, i8** %2, align 8, !dbg !197
  %5 = ptrtoint i8* %4 to i64, !dbg !198
  %6 = trunc i64 %5 to i32, !dbg !199
  store i32 %6, i32* %3, align 4, !dbg !196
  %7 = load i32, i32* %3, align 4, !dbg !200
  call void @reader_acquire(i32 noundef %7), !dbg !201
  %8 = load i32, i32* %3, align 4, !dbg !202
  call void @reader_cs(i32 noundef %8), !dbg !203
  %9 = load i32, i32* %3, align 4, !dbg !204
  call void @reader_release(i32 noundef %9), !dbg !205
  ret i8* null, !dbg !206
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_acquire(i32 noundef %0) #0 !dbg !207 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !208, metadata !DIExpression()), !dbg !209
  br label %3, !dbg !210

3:                                                ; preds = %1
  br label %4, !dbg !211

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !213
  br label %6, !dbg !213

6:                                                ; preds = %4
  br label %7, !dbg !215

7:                                                ; preds = %6
  br label %8, !dbg !213

8:                                                ; preds = %7
  br label %9, !dbg !211

9:                                                ; preds = %8
  call void @rwlock_write_acquire(%struct.rwlock_s* noundef @lock), !dbg !217
  ret void, !dbg !218
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_write_acquire(%struct.rwlock_s* noundef %0) #0 !dbg !219 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !223, metadata !DIExpression()), !dbg !224
  %3 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !225
  %4 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %3, i32 0, i32 1, !dbg !226
  %5 = call i32 @vatomic32_await_eq_set_rlx(%struct.vatomic32_s* noundef %4, i32 noundef 0, i32 noundef 1), !dbg !227
  %6 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !228
  %7 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %6, i32 0, i32 2, !dbg !229
  %8 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !230
  %9 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %8, i32 0, i32 0, !dbg !231
  %10 = load i32, i32* %9, align 4, !dbg !231
  call void @semaphore_acquire(%struct.semaphore_s* noundef %7, i32 noundef %10), !dbg !232
  ret void, !dbg !233
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_release(i32 noundef %0) #0 !dbg !234 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !235, metadata !DIExpression()), !dbg !236
  br label %3, !dbg !237

3:                                                ; preds = %1
  br label %4, !dbg !238

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !240
  br label %6, !dbg !240

6:                                                ; preds = %4
  br label %7, !dbg !242

7:                                                ; preds = %6
  br label %8, !dbg !240

8:                                                ; preds = %7
  br label %9, !dbg !238

9:                                                ; preds = %8
  call void @rwlock_write_release(%struct.rwlock_s* noundef @lock), !dbg !244
  ret void, !dbg !245
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_write_release(%struct.rwlock_s* noundef %0) #0 !dbg !246 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !247, metadata !DIExpression()), !dbg !248
  %3 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !249
  %4 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %3, i32 0, i32 1, !dbg !250
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %4, i32 noundef 0), !dbg !251
  %5 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !252
  %6 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %5, i32 0, i32 2, !dbg !253
  %7 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !254
  %8 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %7, i32 0, i32 0, !dbg !255
  %9 = load i32, i32* %8, align 4, !dbg !255
  call void @semaphore_release(%struct.semaphore_s* noundef %6, i32 noundef %9), !dbg !256
  ret void, !dbg !257
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_acquire(i32 noundef %0) #0 !dbg !258 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !259, metadata !DIExpression()), !dbg !260
  br label %3, !dbg !261

3:                                                ; preds = %1
  br label %4, !dbg !262

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !264
  br label %6, !dbg !264

6:                                                ; preds = %4
  br label %7, !dbg !266

7:                                                ; preds = %6
  br label %8, !dbg !264

8:                                                ; preds = %7
  br label %9, !dbg !262

9:                                                ; preds = %8
  call void @rwlock_read_acquire(%struct.rwlock_s* noundef @lock), !dbg !268
  ret void, !dbg !269
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_read_acquire(%struct.rwlock_s* noundef %0) #0 !dbg !270 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !271, metadata !DIExpression()), !dbg !272
  %3 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !273
  %4 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %3, i32 0, i32 1, !dbg !274
  %5 = call i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %4, i32 noundef 0), !dbg !275
  %6 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !276
  %7 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %6, i32 0, i32 2, !dbg !277
  call void @semaphore_acquire(%struct.semaphore_s* noundef %7, i32 noundef 1), !dbg !278
  ret void, !dbg !279
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_release(i32 noundef %0) #0 !dbg !280 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !281, metadata !DIExpression()), !dbg !282
  br label %3, !dbg !283

3:                                                ; preds = %1
  br label %4, !dbg !284

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !286
  br label %6, !dbg !286

6:                                                ; preds = %4
  br label %7, !dbg !288

7:                                                ; preds = %6
  br label %8, !dbg !286

8:                                                ; preds = %7
  br label %9, !dbg !284

9:                                                ; preds = %8
  call void @rwlock_read_release(%struct.rwlock_s* noundef @lock), !dbg !290
  ret void, !dbg !291
}

; Function Attrs: noinline nounwind uwtable
define internal void @rwlock_read_release(%struct.rwlock_s* noundef %0) #0 !dbg !292 {
  %2 = alloca %struct.rwlock_s*, align 8
  store %struct.rwlock_s* %0, %struct.rwlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.rwlock_s** %2, metadata !293, metadata !DIExpression()), !dbg !294
  %3 = load %struct.rwlock_s*, %struct.rwlock_s** %2, align 8, !dbg !295
  %4 = getelementptr inbounds %struct.rwlock_s, %struct.rwlock_s* %3, i32 0, i32 2, !dbg !296
  call void @semaphore_release(%struct.semaphore_s* noundef %4, i32 noundef 1), !dbg !297
  ret void, !dbg !298
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_set_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !299 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !304, metadata !DIExpression()), !dbg !305
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !306, metadata !DIExpression()), !dbg !307
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !308, metadata !DIExpression()), !dbg !309
  br label %7, !dbg !310

7:                                                ; preds = %11, %3
  %8 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !311
  %9 = load i32, i32* %5, align 4, !dbg !313
  %10 = call i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %8, i32 noundef %9), !dbg !314
  br label %11, !dbg !315

11:                                               ; preds = %7
  %12 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !316
  %13 = load i32, i32* %5, align 4, !dbg !317
  %14 = load i32, i32* %6, align 4, !dbg !318
  %15 = call i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %12, i32 noundef %13, i32 noundef %14), !dbg !319
  %16 = load i32, i32* %5, align 4, !dbg !320
  %17 = icmp ne i32 %15, %16, !dbg !321
  br i1 %17, label %7, label %18, !dbg !315, !llvm.loop !322

18:                                               ; preds = %11
  %19 = load i32, i32* %5, align 4, !dbg !324
  ret i32 %19, !dbg !325
}

; Function Attrs: noinline nounwind uwtable
define internal void @semaphore_acquire(%struct.semaphore_s* noundef %0, i32 noundef %1) #0 !dbg !326 {
  %3 = alloca %struct.semaphore_s*, align 8
  %4 = alloca i32, align 4
  store %struct.semaphore_s* %0, %struct.semaphore_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.semaphore_s** %3, metadata !330, metadata !DIExpression()), !dbg !331
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !332, metadata !DIExpression()), !dbg !333
  %5 = load %struct.semaphore_s*, %struct.semaphore_s** %3, align 8, !dbg !334
  %6 = getelementptr inbounds %struct.semaphore_s, %struct.semaphore_s* %5, i32 0, i32 0, !dbg !335
  %7 = load i32, i32* %4, align 4, !dbg !336
  %8 = load i32, i32* %4, align 4, !dbg !337
  %9 = call i32 @vatomic32_await_ge_sub_acq(%struct.vatomic32_s* noundef %6, i32 noundef %7, i32 noundef %8), !dbg !338
  ret void, !dbg !339
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !340 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !346, metadata !DIExpression()), !dbg !347
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !348, metadata !DIExpression()), !dbg !349
  call void @llvm.dbg.declare(metadata i32* %5, metadata !350, metadata !DIExpression()), !dbg !351
  %6 = load i32, i32* %4, align 4, !dbg !352
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !353
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !354
  %9 = load i32, i32* %8, align 4, !dbg !354
  %10 = call i32 asm sideeffect "1:\0Aldr ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.ne 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !355, !srcloc !356
  store i32 %10, i32* %5, align 4, !dbg !355
  %11 = load i32, i32* %5, align 4, !dbg !357
  ret i32 %11, !dbg !358
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !359 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !361, metadata !DIExpression()), !dbg !362
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !363, metadata !DIExpression()), !dbg !364
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !365, metadata !DIExpression()), !dbg !366
  call void @llvm.dbg.declare(metadata i32* %7, metadata !367, metadata !DIExpression()), !dbg !368
  call void @llvm.dbg.declare(metadata i32* %8, metadata !369, metadata !DIExpression()), !dbg !370
  %9 = load i32, i32* %6, align 4, !dbg !371
  %10 = load i32, i32* %5, align 4, !dbg !372
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !373
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !374
  %13 = load i32, i32* %12, align 4, !dbg !374
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !375, !srcloc !376
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !375
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !375
  store i32 %15, i32* %7, align 4, !dbg !375
  store i32 %16, i32* %8, align 4, !dbg !375
  %17 = load i32, i32* %7, align 4, !dbg !377
  ret i32 %17, !dbg !378
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_ge_sub_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !379 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !380, metadata !DIExpression()), !dbg !381
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !382, metadata !DIExpression()), !dbg !383
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !384, metadata !DIExpression()), !dbg !385
  call void @llvm.dbg.declare(metadata i32* %7, metadata !386, metadata !DIExpression()), !dbg !387
  store i32 0, i32* %7, align 4, !dbg !387
  call void @llvm.dbg.declare(metadata i32* %8, metadata !388, metadata !DIExpression()), !dbg !389
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !390
  %10 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %9), !dbg !391
  store i32 %10, i32* %8, align 4, !dbg !389
  br label %11, !dbg !392

11:                                               ; preds = %23, %3
  %12 = load i32, i32* %8, align 4, !dbg !393
  store i32 %12, i32* %7, align 4, !dbg !395
  br label %13, !dbg !396

13:                                               ; preds = %18, %11
  %14 = load i32, i32* %7, align 4, !dbg !397
  %15 = load i32, i32* %5, align 4, !dbg !398
  %16 = icmp uge i32 %14, %15, !dbg !399
  %17 = xor i1 %16, true, !dbg !400
  br i1 %17, label %18, label %22, !dbg !396

18:                                               ; preds = %13
  %19 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !401
  %20 = load i32, i32* %7, align 4, !dbg !403
  %21 = call i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef %19, i32 noundef %20), !dbg !404
  store i32 %21, i32* %7, align 4, !dbg !405
  br label %13, !dbg !396, !llvm.loop !406

22:                                               ; preds = %13
  br label %23, !dbg !408

23:                                               ; preds = %22
  %24 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !409
  %25 = load i32, i32* %7, align 4, !dbg !410
  %26 = load i32, i32* %7, align 4, !dbg !411
  %27 = load i32, i32* %6, align 4, !dbg !412
  %28 = sub i32 %26, %27, !dbg !413
  %29 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %24, i32 noundef %25, i32 noundef %28), !dbg !414
  store i32 %29, i32* %8, align 4, !dbg !415
  %30 = load i32, i32* %7, align 4, !dbg !416
  %31 = icmp ne i32 %29, %30, !dbg !417
  br i1 %31, label %11, label %32, !dbg !408, !llvm.loop !418

32:                                               ; preds = %23
  %33 = load i32, i32* %8, align 4, !dbg !420
  ret i32 %33, !dbg !421
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !422 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !425, metadata !DIExpression()), !dbg !426
  call void @llvm.dbg.declare(metadata i32* %3, metadata !427, metadata !DIExpression()), !dbg !428
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !429
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !430
  %6 = load i32, i32* %5, align 4, !dbg !430
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !431, !srcloc !432
  store i32 %7, i32* %3, align 4, !dbg !431
  %8 = load i32, i32* %3, align 4, !dbg !433
  ret i32 %8, !dbg !434
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !435 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !436, metadata !DIExpression()), !dbg !437
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !438, metadata !DIExpression()), !dbg !439
  call void @llvm.dbg.declare(metadata i32* %5, metadata !440, metadata !DIExpression()), !dbg !441
  %6 = load i32, i32* %4, align 4, !dbg !442
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !443
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !444
  %9 = load i32, i32* %8, align 4, !dbg !444
  %10 = call i32 asm sideeffect "1:\0Aldr ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.eq 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !445, !srcloc !446
  store i32 %10, i32* %5, align 4, !dbg !445
  %11 = load i32, i32* %5, align 4, !dbg !447
  ret i32 %11, !dbg !448
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !449 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !450, metadata !DIExpression()), !dbg !451
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !452, metadata !DIExpression()), !dbg !453
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !454, metadata !DIExpression()), !dbg !455
  call void @llvm.dbg.declare(metadata i32* %7, metadata !456, metadata !DIExpression()), !dbg !457
  call void @llvm.dbg.declare(metadata i32* %8, metadata !458, metadata !DIExpression()), !dbg !459
  %9 = load i32, i32* %6, align 4, !dbg !460
  %10 = load i32, i32* %5, align 4, !dbg !461
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !462
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !463
  %13 = load i32, i32* %12, align 4, !dbg !463
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldaxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !464, !srcloc !465
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !464
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !464
  store i32 %15, i32* %7, align 4, !dbg !464
  store i32 %16, i32* %8, align 4, !dbg !464
  %17 = load i32, i32* %7, align 4, !dbg !466
  ret i32 %17, !dbg !467
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !468 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !471, metadata !DIExpression()), !dbg !472
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !473, metadata !DIExpression()), !dbg !474
  %5 = load i32, i32* %4, align 4, !dbg !475
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !476
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !477
  %8 = load i32, i32* %7, align 4, !dbg !477
  call void asm sideeffect "str ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !478, !srcloc !479
  ret void, !dbg !480
}

; Function Attrs: noinline nounwind uwtable
define internal void @semaphore_release(%struct.semaphore_s* noundef %0, i32 noundef %1) #0 !dbg !481 {
  %3 = alloca %struct.semaphore_s*, align 8
  %4 = alloca i32, align 4
  store %struct.semaphore_s* %0, %struct.semaphore_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.semaphore_s** %3, metadata !482, metadata !DIExpression()), !dbg !483
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !484, metadata !DIExpression()), !dbg !485
  %5 = load %struct.semaphore_s*, %struct.semaphore_s** %3, align 8, !dbg !486
  %6 = getelementptr inbounds %struct.semaphore_s, %struct.semaphore_s* %5, i32 0, i32 0, !dbg !487
  %7 = load i32, i32* %4, align 4, !dbg !488
  call void @vatomic32_add_rel(%struct.vatomic32_s* noundef %6, i32 noundef %7), !dbg !489
  ret void, !dbg !490
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !491 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !492, metadata !DIExpression()), !dbg !493
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !494, metadata !DIExpression()), !dbg !495
  call void @llvm.dbg.declare(metadata i32* %5, metadata !496, metadata !DIExpression()), !dbg !497
  call void @llvm.dbg.declare(metadata i32* %6, metadata !498, metadata !DIExpression()), !dbg !499
  call void @llvm.dbg.declare(metadata i32* %7, metadata !500, metadata !DIExpression()), !dbg !501
  %8 = load i32, i32* %4, align 4, !dbg !502
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !503
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !504
  %11 = load i32, i32* %10, align 4, !dbg !504
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astlxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #6, !dbg !502, !srcloc !505
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !502
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !502
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !502
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !502
  store i32 %13, i32* %5, align 4, !dbg !502
  store i32 %14, i32* %6, align 4, !dbg !502
  store i32 %15, i32* %7, align 4, !dbg !502
  store i32 %16, i32* %4, align 4, !dbg !502
  ret void, !dbg !506
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!41, !42, !43, !44, !45, !46, !47}
!llvm.ident = !{!48}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !40, line: 110, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/spinlock/test/rwlock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "2129fcfcf72d63732f7a1eeb4904d81a")
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
!17 = !{!18, !0, !38}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !20, line: 12, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "spinlock/test/rwlock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "2129fcfcf72d63732f7a1eeb4904d81a")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "rwlock_t", file: !22, line: 55, baseType: !23)
!22 = !DIFile(filename: "spinlock/include/vsync/spinlock/rwlock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "e960dcf93503d5213bb0d874b270c402")
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "rwlock_s", file: !22, line: 51, size: 96, elements: !24)
!24 = !{!25, !26, !32}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "n", scope: !23, file: !22, line: 52, baseType: !6, size: 32)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "wb", scope: !23, file: !22, line: 53, baseType: !27, size: 32, align: 32, offset: 32)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !28, line: 34, baseType: !29)
!28 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !28, line: 32, size: 32, align: 32, elements: !30)
!30 = !{!31}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !29, file: !28, line: 33, baseType: !6, size: 32)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "rs", scope: !23, file: !22, line: 54, baseType: !33, size: 32, offset: 64)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "semaphore_t", file: !34, line: 23, baseType: !35)
!34 = !DIFile(filename: "spinlock/include/vsync/spinlock/semaphore.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "656e3c09907ca0329e914e7c2d0080c0")
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "semaphore_s", file: !34, line: 21, size: 32, elements: !36)
!36 = !{!37}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "s", scope: !35, file: !34, line: 22, baseType: !27, size: 32, align: 32)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !40, line: 111, type: !6, isLocal: true, isDefinition: true)
!40 = !DIFile(filename: "utils/include/test/boilerplate/reader_writer.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4e1dc695be02c115383d13b32ef6a829")
!41 = !{i32 7, !"Dwarf Version", i32 5}
!42 = !{i32 2, !"Debug Info Version", i32 3}
!43 = !{i32 1, !"wchar_size", i32 4}
!44 = !{i32 7, !"PIC Level", i32 2}
!45 = !{i32 7, !"PIE Level", i32 2}
!46 = !{i32 7, !"uwtable", i32 1}
!47 = !{i32 7, !"frame-pointer", i32 2}
!48 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!49 = distinct !DISubprogram(name: "init", scope: !40, file: !40, line: 54, type: !50, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!50 = !DISubroutineType(types: !51)
!51 = !{null}
!52 = !{}
!53 = !DILocation(line: 56, column: 1, scope: !49)
!54 = distinct !DISubprogram(name: "post", scope: !40, file: !40, line: 63, type: !50, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!55 = !DILocation(line: 65, column: 1, scope: !54)
!56 = distinct !DISubprogram(name: "fini", scope: !40, file: !40, line: 72, type: !50, scopeLine: 73, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!57 = !DILocation(line: 74, column: 1, scope: !56)
!58 = distinct !DISubprogram(name: "writer_cs", scope: !40, file: !40, line: 114, type: !59, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!59 = !DISubroutineType(types: !60)
!60 = !{null, !6}
!61 = !DILocalVariable(name: "tid", arg: 1, scope: !58, file: !40, line: 114, type: !6)
!62 = !DILocation(line: 114, column: 21, scope: !58)
!63 = !DILocation(line: 116, column: 5, scope: !58)
!64 = !DILocation(line: 116, column: 5, scope: !65)
!65 = distinct !DILexicalBlock(scope: !58, file: !40, line: 116, column: 5)
!66 = !DILocation(line: 116, column: 5, scope: !67)
!67 = distinct !DILexicalBlock(scope: !65, file: !40, line: 116, column: 5)
!68 = !DILocation(line: 116, column: 5, scope: !69)
!69 = distinct !DILexicalBlock(scope: !67, file: !40, line: 116, column: 5)
!70 = !DILocation(line: 117, column: 11, scope: !58)
!71 = !DILocation(line: 118, column: 11, scope: !58)
!72 = !DILocation(line: 119, column: 1, scope: !58)
!73 = distinct !DISubprogram(name: "reader_cs", scope: !40, file: !40, line: 121, type: !59, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!74 = !DILocalVariable(name: "tid", arg: 1, scope: !73, file: !40, line: 121, type: !6)
!75 = !DILocation(line: 121, column: 21, scope: !73)
!76 = !DILocation(line: 123, column: 5, scope: !73)
!77 = !DILocation(line: 123, column: 5, scope: !78)
!78 = distinct !DILexicalBlock(scope: !73, file: !40, line: 123, column: 5)
!79 = !DILocation(line: 123, column: 5, scope: !80)
!80 = distinct !DILexicalBlock(scope: !78, file: !40, line: 123, column: 5)
!81 = !DILocation(line: 123, column: 5, scope: !82)
!82 = distinct !DILexicalBlock(scope: !80, file: !40, line: 123, column: 5)
!83 = !DILocalVariable(name: "a", scope: !73, file: !40, line: 124, type: !12)
!84 = !DILocation(line: 124, column: 14, scope: !73)
!85 = !DILocation(line: 124, column: 19, scope: !73)
!86 = !DILocation(line: 124, column: 29, scope: !73)
!87 = !DILocation(line: 124, column: 26, scope: !73)
!88 = !DILocation(line: 125, column: 5, scope: !89)
!89 = distinct !DILexicalBlock(scope: !90, file: !40, line: 125, column: 5)
!90 = distinct !DILexicalBlock(scope: !73, file: !40, line: 125, column: 5)
!91 = !DILocation(line: 125, column: 5, scope: !90)
!92 = !DILocation(line: 126, column: 1, scope: !73)
!93 = distinct !DISubprogram(name: "check", scope: !40, file: !40, line: 128, type: !50, scopeLine: 129, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!94 = !DILocation(line: 130, column: 5, scope: !95)
!95 = distinct !DILexicalBlock(scope: !96, file: !40, line: 130, column: 5)
!96 = distinct !DILexicalBlock(scope: !93, file: !40, line: 130, column: 5)
!97 = !DILocation(line: 130, column: 5, scope: !96)
!98 = !DILocation(line: 131, column: 5, scope: !99)
!99 = distinct !DILexicalBlock(scope: !100, file: !40, line: 131, column: 5)
!100 = distinct !DILexicalBlock(scope: !93, file: !40, line: 131, column: 5)
!101 = !DILocation(line: 131, column: 5, scope: !100)
!102 = !DILocation(line: 132, column: 1, scope: !93)
!103 = distinct !DISubprogram(name: "main", scope: !40, file: !40, line: 158, type: !104, scopeLine: 159, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!104 = !DISubroutineType(types: !105)
!105 = !{!106}
!106 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!107 = !DILocalVariable(name: "t", scope: !103, file: !40, line: 160, type: !108)
!108 = !DICompositeType(tag: DW_TAG_array_type, baseType: !109, size: 192, elements: !111)
!109 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !110, line: 27, baseType: !16)
!110 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!111 = !{!112}
!112 = !DISubrange(count: 3)
!113 = !DILocation(line: 160, column: 15, scope: !103)
!114 = !DILocation(line: 167, column: 5, scope: !103)
!115 = !DILocalVariable(name: "i", scope: !116, file: !40, line: 169, type: !13)
!116 = distinct !DILexicalBlock(scope: !103, file: !40, line: 169, column: 5)
!117 = !DILocation(line: 169, column: 21, scope: !116)
!118 = !DILocation(line: 169, column: 10, scope: !116)
!119 = !DILocation(line: 169, column: 28, scope: !120)
!120 = distinct !DILexicalBlock(scope: !116, file: !40, line: 169, column: 5)
!121 = !DILocation(line: 169, column: 30, scope: !120)
!122 = !DILocation(line: 169, column: 5, scope: !116)
!123 = !DILocation(line: 170, column: 33, scope: !124)
!124 = distinct !DILexicalBlock(scope: !120, file: !40, line: 169, column: 47)
!125 = !DILocation(line: 170, column: 31, scope: !124)
!126 = !DILocation(line: 170, column: 56, scope: !124)
!127 = !DILocation(line: 170, column: 48, scope: !124)
!128 = !DILocation(line: 170, column: 15, scope: !124)
!129 = !DILocation(line: 171, column: 5, scope: !124)
!130 = !DILocation(line: 169, column: 43, scope: !120)
!131 = !DILocation(line: 169, column: 5, scope: !120)
!132 = distinct !{!132, !122, !133, !134}
!133 = !DILocation(line: 171, column: 5, scope: !116)
!134 = !{!"llvm.loop.mustprogress"}
!135 = !DILocalVariable(name: "i", scope: !136, file: !40, line: 173, type: !13)
!136 = distinct !DILexicalBlock(scope: !103, file: !40, line: 173, column: 5)
!137 = !DILocation(line: 173, column: 21, scope: !136)
!138 = !DILocation(line: 173, column: 10, scope: !136)
!139 = !DILocation(line: 173, column: 35, scope: !140)
!140 = distinct !DILexicalBlock(scope: !136, file: !40, line: 173, column: 5)
!141 = !DILocation(line: 173, column: 37, scope: !140)
!142 = !DILocation(line: 173, column: 5, scope: !136)
!143 = !DILocation(line: 174, column: 33, scope: !144)
!144 = distinct !DILexicalBlock(scope: !140, file: !40, line: 173, column: 54)
!145 = !DILocation(line: 174, column: 31, scope: !144)
!146 = !DILocation(line: 174, column: 56, scope: !144)
!147 = !DILocation(line: 174, column: 48, scope: !144)
!148 = !DILocation(line: 174, column: 15, scope: !144)
!149 = !DILocation(line: 175, column: 5, scope: !144)
!150 = !DILocation(line: 173, column: 50, scope: !140)
!151 = !DILocation(line: 173, column: 5, scope: !140)
!152 = distinct !{!152, !142, !153, !134}
!153 = !DILocation(line: 175, column: 5, scope: !136)
!154 = !DILocation(line: 177, column: 5, scope: !103)
!155 = !DILocalVariable(name: "i", scope: !156, file: !40, line: 179, type: !13)
!156 = distinct !DILexicalBlock(scope: !103, file: !40, line: 179, column: 5)
!157 = !DILocation(line: 179, column: 21, scope: !156)
!158 = !DILocation(line: 179, column: 10, scope: !156)
!159 = !DILocation(line: 179, column: 28, scope: !160)
!160 = distinct !DILexicalBlock(scope: !156, file: !40, line: 179, column: 5)
!161 = !DILocation(line: 179, column: 30, scope: !160)
!162 = !DILocation(line: 179, column: 5, scope: !156)
!163 = !DILocation(line: 180, column: 30, scope: !164)
!164 = distinct !DILexicalBlock(scope: !160, file: !40, line: 179, column: 47)
!165 = !DILocation(line: 180, column: 28, scope: !164)
!166 = !DILocation(line: 180, column: 15, scope: !164)
!167 = !DILocation(line: 181, column: 5, scope: !164)
!168 = !DILocation(line: 179, column: 43, scope: !160)
!169 = !DILocation(line: 179, column: 5, scope: !160)
!170 = distinct !{!170, !162, !171, !134}
!171 = !DILocation(line: 181, column: 5, scope: !156)
!172 = !DILocation(line: 188, column: 5, scope: !103)
!173 = !DILocation(line: 189, column: 5, scope: !103)
!174 = !DILocation(line: 191, column: 5, scope: !103)
!175 = distinct !DISubprogram(name: "writer", scope: !40, file: !40, line: 137, type: !176, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!176 = !DISubroutineType(types: !177)
!177 = !{!5, !5}
!178 = !DILocalVariable(name: "arg", arg: 1, scope: !175, file: !40, line: 137, type: !5)
!179 = !DILocation(line: 137, column: 14, scope: !175)
!180 = !DILocalVariable(name: "tid", scope: !175, file: !40, line: 139, type: !6)
!181 = !DILocation(line: 139, column: 15, scope: !175)
!182 = !DILocation(line: 139, column: 44, scope: !175)
!183 = !DILocation(line: 139, column: 32, scope: !175)
!184 = !DILocation(line: 139, column: 21, scope: !175)
!185 = !DILocation(line: 140, column: 20, scope: !175)
!186 = !DILocation(line: 140, column: 5, scope: !175)
!187 = !DILocation(line: 141, column: 15, scope: !175)
!188 = !DILocation(line: 141, column: 5, scope: !175)
!189 = !DILocation(line: 142, column: 20, scope: !175)
!190 = !DILocation(line: 142, column: 5, scope: !175)
!191 = !DILocation(line: 143, column: 5, scope: !175)
!192 = distinct !DISubprogram(name: "reader", scope: !40, file: !40, line: 147, type: !176, scopeLine: 148, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!193 = !DILocalVariable(name: "arg", arg: 1, scope: !192, file: !40, line: 147, type: !5)
!194 = !DILocation(line: 147, column: 14, scope: !192)
!195 = !DILocalVariable(name: "tid", scope: !192, file: !40, line: 149, type: !6)
!196 = !DILocation(line: 149, column: 15, scope: !192)
!197 = !DILocation(line: 149, column: 44, scope: !192)
!198 = !DILocation(line: 149, column: 32, scope: !192)
!199 = !DILocation(line: 149, column: 21, scope: !192)
!200 = !DILocation(line: 150, column: 20, scope: !192)
!201 = !DILocation(line: 150, column: 5, scope: !192)
!202 = !DILocation(line: 151, column: 15, scope: !192)
!203 = !DILocation(line: 151, column: 5, scope: !192)
!204 = !DILocation(line: 152, column: 20, scope: !192)
!205 = !DILocation(line: 152, column: 5, scope: !192)
!206 = !DILocation(line: 154, column: 5, scope: !192)
!207 = distinct !DISubprogram(name: "writer_acquire", scope: !20, file: !20, line: 15, type: !59, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!208 = !DILocalVariable(name: "tid", arg: 1, scope: !207, file: !20, line: 15, type: !6)
!209 = !DILocation(line: 15, column: 26, scope: !207)
!210 = !DILocation(line: 17, column: 5, scope: !207)
!211 = !DILocation(line: 17, column: 5, scope: !212)
!212 = distinct !DILexicalBlock(scope: !207, file: !20, line: 17, column: 5)
!213 = !DILocation(line: 17, column: 5, scope: !214)
!214 = distinct !DILexicalBlock(scope: !212, file: !20, line: 17, column: 5)
!215 = !DILocation(line: 17, column: 5, scope: !216)
!216 = distinct !DILexicalBlock(scope: !214, file: !20, line: 17, column: 5)
!217 = !DILocation(line: 18, column: 5, scope: !207)
!218 = !DILocation(line: 19, column: 1, scope: !207)
!219 = distinct !DISubprogram(name: "rwlock_write_acquire", scope: !22, file: !22, line: 88, type: !220, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!220 = !DISubroutineType(types: !221)
!221 = !{null, !222}
!222 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!223 = !DILocalVariable(name: "l", arg: 1, scope: !219, file: !22, line: 88, type: !222)
!224 = !DILocation(line: 88, column: 32, scope: !219)
!225 = !DILocation(line: 90, column: 33, scope: !219)
!226 = !DILocation(line: 90, column: 36, scope: !219)
!227 = !DILocation(line: 90, column: 5, scope: !219)
!228 = !DILocation(line: 91, column: 24, scope: !219)
!229 = !DILocation(line: 91, column: 27, scope: !219)
!230 = !DILocation(line: 91, column: 31, scope: !219)
!231 = !DILocation(line: 91, column: 34, scope: !219)
!232 = !DILocation(line: 91, column: 5, scope: !219)
!233 = !DILocation(line: 92, column: 1, scope: !219)
!234 = distinct !DISubprogram(name: "writer_release", scope: !20, file: !20, line: 21, type: !59, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!235 = !DILocalVariable(name: "tid", arg: 1, scope: !234, file: !20, line: 21, type: !6)
!236 = !DILocation(line: 21, column: 26, scope: !234)
!237 = !DILocation(line: 23, column: 5, scope: !234)
!238 = !DILocation(line: 23, column: 5, scope: !239)
!239 = distinct !DILexicalBlock(scope: !234, file: !20, line: 23, column: 5)
!240 = !DILocation(line: 23, column: 5, scope: !241)
!241 = distinct !DILexicalBlock(scope: !239, file: !20, line: 23, column: 5)
!242 = !DILocation(line: 23, column: 5, scope: !243)
!243 = distinct !DILexicalBlock(scope: !241, file: !20, line: 23, column: 5)
!244 = !DILocation(line: 24, column: 5, scope: !234)
!245 = !DILocation(line: 25, column: 1, scope: !234)
!246 = distinct !DISubprogram(name: "rwlock_write_release", scope: !22, file: !22, line: 120, type: !220, scopeLine: 121, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!247 = !DILocalVariable(name: "l", arg: 1, scope: !246, file: !22, line: 120, type: !222)
!248 = !DILocation(line: 120, column: 32, scope: !246)
!249 = !DILocation(line: 122, column: 26, scope: !246)
!250 = !DILocation(line: 122, column: 29, scope: !246)
!251 = !DILocation(line: 122, column: 5, scope: !246)
!252 = !DILocation(line: 123, column: 24, scope: !246)
!253 = !DILocation(line: 123, column: 27, scope: !246)
!254 = !DILocation(line: 123, column: 31, scope: !246)
!255 = !DILocation(line: 123, column: 34, scope: !246)
!256 = !DILocation(line: 123, column: 5, scope: !246)
!257 = !DILocation(line: 124, column: 1, scope: !246)
!258 = distinct !DISubprogram(name: "reader_acquire", scope: !20, file: !20, line: 27, type: !59, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!259 = !DILocalVariable(name: "tid", arg: 1, scope: !258, file: !20, line: 27, type: !6)
!260 = !DILocation(line: 27, column: 26, scope: !258)
!261 = !DILocation(line: 29, column: 5, scope: !258)
!262 = !DILocation(line: 29, column: 5, scope: !263)
!263 = distinct !DILexicalBlock(scope: !258, file: !20, line: 29, column: 5)
!264 = !DILocation(line: 29, column: 5, scope: !265)
!265 = distinct !DILexicalBlock(scope: !263, file: !20, line: 29, column: 5)
!266 = !DILocation(line: 29, column: 5, scope: !267)
!267 = distinct !DILexicalBlock(scope: !265, file: !20, line: 29, column: 5)
!268 = !DILocation(line: 30, column: 5, scope: !258)
!269 = !DILocation(line: 31, column: 1, scope: !258)
!270 = distinct !DISubprogram(name: "rwlock_read_acquire", scope: !22, file: !22, line: 131, type: !220, scopeLine: 132, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!271 = !DILocalVariable(name: "l", arg: 1, scope: !270, file: !22, line: 131, type: !222)
!272 = !DILocation(line: 131, column: 31, scope: !270)
!273 = !DILocation(line: 133, column: 29, scope: !270)
!274 = !DILocation(line: 133, column: 32, scope: !270)
!275 = !DILocation(line: 133, column: 5, scope: !270)
!276 = !DILocation(line: 134, column: 24, scope: !270)
!277 = !DILocation(line: 134, column: 27, scope: !270)
!278 = !DILocation(line: 134, column: 5, scope: !270)
!279 = !DILocation(line: 135, column: 1, scope: !270)
!280 = distinct !DISubprogram(name: "reader_release", scope: !20, file: !20, line: 33, type: !59, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !52)
!281 = !DILocalVariable(name: "tid", arg: 1, scope: !280, file: !20, line: 33, type: !6)
!282 = !DILocation(line: 33, column: 26, scope: !280)
!283 = !DILocation(line: 35, column: 5, scope: !280)
!284 = !DILocation(line: 35, column: 5, scope: !285)
!285 = distinct !DILexicalBlock(scope: !280, file: !20, line: 35, column: 5)
!286 = !DILocation(line: 35, column: 5, scope: !287)
!287 = distinct !DILexicalBlock(scope: !285, file: !20, line: 35, column: 5)
!288 = !DILocation(line: 35, column: 5, scope: !289)
!289 = distinct !DILexicalBlock(scope: !287, file: !20, line: 35, column: 5)
!290 = !DILocation(line: 36, column: 5, scope: !280)
!291 = !DILocation(line: 37, column: 1, scope: !280)
!292 = distinct !DISubprogram(name: "rwlock_read_release", scope: !22, file: !22, line: 157, type: !220, scopeLine: 158, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!293 = !DILocalVariable(name: "l", arg: 1, scope: !292, file: !22, line: 157, type: !222)
!294 = !DILocation(line: 157, column: 31, scope: !292)
!295 = !DILocation(line: 159, column: 24, scope: !292)
!296 = !DILocation(line: 159, column: 27, scope: !292)
!297 = !DILocation(line: 159, column: 5, scope: !292)
!298 = !DILocation(line: 160, column: 1, scope: !292)
!299 = distinct !DISubprogram(name: "vatomic32_await_eq_set_rlx", scope: !300, file: !300, line: 7331, type: !301, scopeLine: 7332, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!300 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!301 = !DISubroutineType(types: !302)
!302 = !{!6, !303, !6, !6}
!303 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!304 = !DILocalVariable(name: "a", arg: 1, scope: !299, file: !300, line: 7331, type: !303)
!305 = !DILocation(line: 7331, column: 41, scope: !299)
!306 = !DILocalVariable(name: "c", arg: 2, scope: !299, file: !300, line: 7331, type: !6)
!307 = !DILocation(line: 7331, column: 54, scope: !299)
!308 = !DILocalVariable(name: "v", arg: 3, scope: !299, file: !300, line: 7331, type: !6)
!309 = !DILocation(line: 7331, column: 67, scope: !299)
!310 = !DILocation(line: 7333, column: 5, scope: !299)
!311 = !DILocation(line: 7334, column: 38, scope: !312)
!312 = distinct !DILexicalBlock(scope: !299, file: !300, line: 7333, column: 8)
!313 = !DILocation(line: 7334, column: 41, scope: !312)
!314 = !DILocation(line: 7334, column: 15, scope: !312)
!315 = !DILocation(line: 7335, column: 5, scope: !312)
!316 = !DILocation(line: 7335, column: 36, scope: !299)
!317 = !DILocation(line: 7335, column: 39, scope: !299)
!318 = !DILocation(line: 7335, column: 42, scope: !299)
!319 = !DILocation(line: 7335, column: 14, scope: !299)
!320 = !DILocation(line: 7335, column: 48, scope: !299)
!321 = !DILocation(line: 7335, column: 45, scope: !299)
!322 = distinct !{!322, !310, !323, !134}
!323 = !DILocation(line: 7335, column: 49, scope: !299)
!324 = !DILocation(line: 7336, column: 12, scope: !299)
!325 = !DILocation(line: 7336, column: 5, scope: !299)
!326 = distinct !DISubprogram(name: "semaphore_acquire", scope: !34, file: !34, line: 55, type: !327, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!327 = !DISubroutineType(types: !328)
!328 = !{null, !329, !6}
!329 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!330 = !DILocalVariable(name: "s", arg: 1, scope: !326, file: !34, line: 55, type: !329)
!331 = !DILocation(line: 55, column: 32, scope: !326)
!332 = !DILocalVariable(name: "i", arg: 2, scope: !326, file: !34, line: 55, type: !6)
!333 = !DILocation(line: 55, column: 45, scope: !326)
!334 = !DILocation(line: 60, column: 33, scope: !326)
!335 = !DILocation(line: 60, column: 36, scope: !326)
!336 = !DILocation(line: 60, column: 39, scope: !326)
!337 = !DILocation(line: 60, column: 42, scope: !326)
!338 = !DILocation(line: 60, column: 5, scope: !326)
!339 = !DILocation(line: 61, column: 1, scope: !326)
!340 = distinct !DISubprogram(name: "vatomic32_await_eq_rlx", scope: !341, file: !341, line: 868, type: !342, scopeLine: 869, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!341 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!342 = !DISubroutineType(types: !343)
!343 = !{!6, !344, !6}
!344 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !345, size: 64)
!345 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !27)
!346 = !DILocalVariable(name: "a", arg: 1, scope: !340, file: !341, line: 868, type: !344)
!347 = !DILocation(line: 868, column: 43, scope: !340)
!348 = !DILocalVariable(name: "v", arg: 2, scope: !340, file: !341, line: 868, type: !6)
!349 = !DILocation(line: 868, column: 56, scope: !340)
!350 = !DILocalVariable(name: "val", scope: !340, file: !341, line: 870, type: !6)
!351 = !DILocation(line: 870, column: 15, scope: !340)
!352 = !DILocation(line: 877, column: 21, scope: !340)
!353 = !DILocation(line: 877, column: 33, scope: !340)
!354 = !DILocation(line: 877, column: 36, scope: !340)
!355 = !DILocation(line: 871, column: 5, scope: !340)
!356 = !{i64 424276, i64 424292, i64 424322, i64 424355}
!357 = !DILocation(line: 879, column: 12, scope: !340)
!358 = !DILocation(line: 879, column: 5, scope: !340)
!359 = distinct !DISubprogram(name: "vatomic32_cmpxchg_rlx", scope: !360, file: !360, line: 361, type: !301, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!360 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!361 = !DILocalVariable(name: "a", arg: 1, scope: !359, file: !360, line: 361, type: !303)
!362 = !DILocation(line: 361, column: 36, scope: !359)
!363 = !DILocalVariable(name: "e", arg: 2, scope: !359, file: !360, line: 361, type: !6)
!364 = !DILocation(line: 361, column: 49, scope: !359)
!365 = !DILocalVariable(name: "v", arg: 3, scope: !359, file: !360, line: 361, type: !6)
!366 = !DILocation(line: 361, column: 62, scope: !359)
!367 = !DILocalVariable(name: "oldv", scope: !359, file: !360, line: 363, type: !6)
!368 = !DILocation(line: 363, column: 15, scope: !359)
!369 = !DILocalVariable(name: "tmp", scope: !359, file: !360, line: 364, type: !6)
!370 = !DILocation(line: 364, column: 15, scope: !359)
!371 = !DILocation(line: 375, column: 22, scope: !359)
!372 = !DILocation(line: 375, column: 36, scope: !359)
!373 = !DILocation(line: 375, column: 48, scope: !359)
!374 = !DILocation(line: 375, column: 51, scope: !359)
!375 = !DILocation(line: 365, column: 5, scope: !359)
!376 = !{i64 469283, i64 469317, i64 469332, i64 469364, i64 469398, i64 469418, i64 469460, i64 469489}
!377 = !DILocation(line: 377, column: 12, scope: !359)
!378 = !DILocation(line: 377, column: 5, scope: !359)
!379 = distinct !DISubprogram(name: "vatomic32_await_ge_sub_acq", scope: !300, file: !300, line: 5444, type: !301, scopeLine: 5445, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!380 = !DILocalVariable(name: "a", arg: 1, scope: !379, file: !300, line: 5444, type: !303)
!381 = !DILocation(line: 5444, column: 41, scope: !379)
!382 = !DILocalVariable(name: "c", arg: 2, scope: !379, file: !300, line: 5444, type: !6)
!383 = !DILocation(line: 5444, column: 54, scope: !379)
!384 = !DILocalVariable(name: "v", arg: 3, scope: !379, file: !300, line: 5444, type: !6)
!385 = !DILocation(line: 5444, column: 67, scope: !379)
!386 = !DILocalVariable(name: "cur", scope: !379, file: !300, line: 5446, type: !6)
!387 = !DILocation(line: 5446, column: 15, scope: !379)
!388 = !DILocalVariable(name: "old", scope: !379, file: !300, line: 5447, type: !6)
!389 = !DILocation(line: 5447, column: 15, scope: !379)
!390 = !DILocation(line: 5447, column: 40, scope: !379)
!391 = !DILocation(line: 5447, column: 21, scope: !379)
!392 = !DILocation(line: 5448, column: 5, scope: !379)
!393 = !DILocation(line: 5449, column: 15, scope: !394)
!394 = distinct !DILexicalBlock(scope: !379, file: !300, line: 5448, column: 8)
!395 = !DILocation(line: 5449, column: 13, scope: !394)
!396 = !DILocation(line: 5450, column: 9, scope: !394)
!397 = !DILocation(line: 5450, column: 18, scope: !394)
!398 = !DILocation(line: 5450, column: 25, scope: !394)
!399 = !DILocation(line: 5450, column: 22, scope: !394)
!400 = !DILocation(line: 5450, column: 16, scope: !394)
!401 = !DILocation(line: 5451, column: 43, scope: !402)
!402 = distinct !DILexicalBlock(scope: !394, file: !300, line: 5450, column: 29)
!403 = !DILocation(line: 5451, column: 46, scope: !402)
!404 = !DILocation(line: 5451, column: 19, scope: !402)
!405 = !DILocation(line: 5451, column: 17, scope: !402)
!406 = distinct !{!406, !396, !407, !134}
!407 = !DILocation(line: 5452, column: 9, scope: !394)
!408 = !DILocation(line: 5453, column: 5, scope: !394)
!409 = !DILocation(line: 5453, column: 43, scope: !379)
!410 = !DILocation(line: 5453, column: 46, scope: !379)
!411 = !DILocation(line: 5453, column: 51, scope: !379)
!412 = !DILocation(line: 5453, column: 57, scope: !379)
!413 = !DILocation(line: 5453, column: 55, scope: !379)
!414 = !DILocation(line: 5453, column: 21, scope: !379)
!415 = !DILocation(line: 5453, column: 19, scope: !379)
!416 = !DILocation(line: 5453, column: 64, scope: !379)
!417 = !DILocation(line: 5453, column: 61, scope: !379)
!418 = distinct !{!418, !392, !419, !134}
!419 = !DILocation(line: 5453, column: 67, scope: !379)
!420 = !DILocation(line: 5454, column: 12, scope: !379)
!421 = !DILocation(line: 5454, column: 5, scope: !379)
!422 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !341, file: !341, line: 101, type: !423, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!423 = !DISubroutineType(types: !424)
!424 = !{!6, !344}
!425 = !DILocalVariable(name: "a", arg: 1, scope: !422, file: !341, line: 101, type: !344)
!426 = !DILocation(line: 101, column: 39, scope: !422)
!427 = !DILocalVariable(name: "val", scope: !422, file: !341, line: 103, type: !6)
!428 = !DILocation(line: 103, column: 15, scope: !422)
!429 = !DILocation(line: 106, column: 32, scope: !422)
!430 = !DILocation(line: 106, column: 35, scope: !422)
!431 = !DILocation(line: 104, column: 5, scope: !422)
!432 = !{i64 402823}
!433 = !DILocation(line: 108, column: 12, scope: !422)
!434 = !DILocation(line: 108, column: 5, scope: !422)
!435 = distinct !DISubprogram(name: "vatomic32_await_neq_rlx", scope: !341, file: !341, line: 912, type: !342, scopeLine: 913, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!436 = !DILocalVariable(name: "a", arg: 1, scope: !435, file: !341, line: 912, type: !344)
!437 = !DILocation(line: 912, column: 44, scope: !435)
!438 = !DILocalVariable(name: "v", arg: 2, scope: !435, file: !341, line: 912, type: !6)
!439 = !DILocation(line: 912, column: 57, scope: !435)
!440 = !DILocalVariable(name: "val", scope: !435, file: !341, line: 914, type: !6)
!441 = !DILocation(line: 914, column: 15, scope: !435)
!442 = !DILocation(line: 921, column: 21, scope: !435)
!443 = !DILocation(line: 921, column: 33, scope: !435)
!444 = !DILocation(line: 921, column: 36, scope: !435)
!445 = !DILocation(line: 915, column: 5, scope: !435)
!446 = !{i64 425429, i64 425445, i64 425475, i64 425508}
!447 = !DILocation(line: 923, column: 12, scope: !435)
!448 = !DILocation(line: 923, column: 5, scope: !435)
!449 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !360, file: !360, line: 311, type: !301, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!450 = !DILocalVariable(name: "a", arg: 1, scope: !449, file: !360, line: 311, type: !303)
!451 = !DILocation(line: 311, column: 36, scope: !449)
!452 = !DILocalVariable(name: "e", arg: 2, scope: !449, file: !360, line: 311, type: !6)
!453 = !DILocation(line: 311, column: 49, scope: !449)
!454 = !DILocalVariable(name: "v", arg: 3, scope: !449, file: !360, line: 311, type: !6)
!455 = !DILocation(line: 311, column: 62, scope: !449)
!456 = !DILocalVariable(name: "oldv", scope: !449, file: !360, line: 313, type: !6)
!457 = !DILocation(line: 313, column: 15, scope: !449)
!458 = !DILocalVariable(name: "tmp", scope: !449, file: !360, line: 314, type: !6)
!459 = !DILocation(line: 314, column: 15, scope: !449)
!460 = !DILocation(line: 325, column: 22, scope: !449)
!461 = !DILocation(line: 325, column: 36, scope: !449)
!462 = !DILocation(line: 325, column: 48, scope: !449)
!463 = !DILocation(line: 325, column: 51, scope: !449)
!464 = !DILocation(line: 315, column: 5, scope: !449)
!465 = !{i64 467731, i64 467765, i64 467780, i64 467813, i64 467847, i64 467867, i64 467909, i64 467938}
!466 = !DILocation(line: 327, column: 12, scope: !449)
!467 = !DILocation(line: 327, column: 5, scope: !449)
!468 = distinct !DISubprogram(name: "vatomic32_write_rlx", scope: !341, file: !341, line: 241, type: !469, scopeLine: 242, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!469 = !DISubroutineType(types: !470)
!470 = !{null, !303, !6}
!471 = !DILocalVariable(name: "a", arg: 1, scope: !468, file: !341, line: 241, type: !303)
!472 = !DILocation(line: 241, column: 34, scope: !468)
!473 = !DILocalVariable(name: "v", arg: 2, scope: !468, file: !341, line: 241, type: !6)
!474 = !DILocation(line: 241, column: 47, scope: !468)
!475 = !DILocation(line: 245, column: 32, scope: !468)
!476 = !DILocation(line: 245, column: 44, scope: !468)
!477 = !DILocation(line: 245, column: 47, scope: !468)
!478 = !DILocation(line: 243, column: 5, scope: !468)
!479 = !{i64 407207}
!480 = !DILocation(line: 247, column: 1, scope: !468)
!481 = distinct !DISubprogram(name: "semaphore_release", scope: !34, file: !34, line: 88, type: !327, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!482 = !DILocalVariable(name: "s", arg: 1, scope: !481, file: !34, line: 88, type: !329)
!483 = !DILocation(line: 88, column: 32, scope: !481)
!484 = !DILocalVariable(name: "i", arg: 2, scope: !481, file: !34, line: 88, type: !6)
!485 = !DILocation(line: 88, column: 45, scope: !481)
!486 = !DILocation(line: 90, column: 24, scope: !481)
!487 = !DILocation(line: 90, column: 27, scope: !481)
!488 = !DILocation(line: 90, column: 30, scope: !481)
!489 = !DILocation(line: 90, column: 5, scope: !481)
!490 = !DILocation(line: 91, column: 1, scope: !481)
!491 = distinct !DISubprogram(name: "vatomic32_add_rel", scope: !360, file: !360, line: 2122, type: !469, scopeLine: 2123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !52)
!492 = !DILocalVariable(name: "a", arg: 1, scope: !491, file: !360, line: 2122, type: !303)
!493 = !DILocation(line: 2122, column: 32, scope: !491)
!494 = !DILocalVariable(name: "v", arg: 2, scope: !491, file: !360, line: 2122, type: !6)
!495 = !DILocation(line: 2122, column: 45, scope: !491)
!496 = !DILocalVariable(name: "oldv", scope: !491, file: !360, line: 2124, type: !6)
!497 = !DILocation(line: 2124, column: 15, scope: !491)
!498 = !DILocalVariable(name: "newv", scope: !491, file: !360, line: 2125, type: !6)
!499 = !DILocation(line: 2125, column: 15, scope: !491)
!500 = !DILocalVariable(name: "tmp", scope: !491, file: !360, line: 2126, type: !6)
!501 = !DILocation(line: 2126, column: 15, scope: !491)
!502 = !DILocation(line: 2127, column: 5, scope: !491)
!503 = !DILocation(line: 2135, column: 19, scope: !491)
!504 = !DILocation(line: 2135, column: 22, scope: !491)
!505 = !{i64 522231, i64 522265, i64 522280, i64 522312, i64 522354, i64 522396}
!506 = !DILocation(line: 2137, column: 1, scope: !491)
