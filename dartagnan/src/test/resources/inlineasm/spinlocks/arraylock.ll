; ModuleID = '/home/stefano/huawei/libvsync/spinlock/test/arraylock.c'
source_filename = "/home/stefano/huawei/libvsync/spinlock/test/arraylock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.arraylock_s = type { %struct.vatomic8_s, %struct.arraylock_flag_s*, i32 }
%struct.vatomic8_s = type { i8 }
%struct.arraylock_flag_s = type { %struct.vatomic8_s }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !49
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [68 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 1 + 0)\00", align 1
@lock = dso_local global %struct.arraylock_s zeroinitializer, align 8, !dbg !34
@flags = dso_local global [4 x %struct.arraylock_flag_s] zeroinitializer, align 1, !dbg !18
@slot = internal thread_local global i32 0, align 4, !dbg !47
@.str.3 = private unnamed_addr constant [8 x i8] c"len > 0\00", align 1
@.str.4 = private unnamed_addr constant [74 x i8] c"/home/stefano/huawei/libvsync/spinlock/include/vsync/spinlock/arraylock.h\00", align 1
@__PRETTY_FUNCTION__.arraylock_init = private unnamed_addr constant [72 x i8] c"void arraylock_init(arraylock_t *, arraylock_flag_t *, const vuint32_t)\00", align 1
@.str.5 = private unnamed_addr constant [43 x i8] c"(((len) != 0) && ((len) & ((len)-1)) == 0)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !60 {
  ret void, !dbg !64
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !65 {
  ret void, !dbg !66
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !67 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !68
  %2 = add i32 %1, 1, !dbg !68
  store i32 %2, i32* @g_cs_x, align 4, !dbg !68
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !69
  %4 = add i32 %3, 1, !dbg !69
  store i32 %4, i32* @g_cs_y, align 4, !dbg !69
  ret void, !dbg !70
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !71 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !72
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !72
  %3 = icmp eq i32 %1, %2, !dbg !72
  br i1 %3, label %4, label %5, !dbg !75

4:                                                ; preds = %0
  br label %6, !dbg !75

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 112, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !72
  unreachable, !dbg !72

6:                                                ; preds = %4
  %7 = load i32, i32* @g_cs_x, align 4, !dbg !76
  %8 = icmp eq i32 %7, 4, !dbg !76
  br i1 %8, label %9, label %10, !dbg !79

9:                                                ; preds = %6
  br label %11, !dbg !79

10:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 113, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !76
  unreachable, !dbg !76

11:                                               ; preds = %9
  ret void, !dbg !80
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !81 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i64]* %2, metadata !85, metadata !DIExpression()), !dbg !91
  call void @init(), !dbg !92
  call void @llvm.dbg.declare(metadata i64* %3, metadata !93, metadata !DIExpression()), !dbg !95
  store i64 0, i64* %3, align 8, !dbg !95
  br label %5, !dbg !96

5:                                                ; preds = %14, %0
  %6 = load i64, i64* %3, align 8, !dbg !97
  %7 = icmp ult i64 %6, 3, !dbg !99
  br i1 %7, label %8, label %17, !dbg !100

8:                                                ; preds = %5
  %9 = load i64, i64* %3, align 8, !dbg !101
  %10 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %9, !dbg !103
  %11 = load i64, i64* %3, align 8, !dbg !104
  %12 = inttoptr i64 %11 to i8*, !dbg !105
  %13 = call i32 @pthread_create(i64* noundef %10, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef %12) #6, !dbg !106
  br label %14, !dbg !107

14:                                               ; preds = %8
  %15 = load i64, i64* %3, align 8, !dbg !108
  %16 = add i64 %15, 1, !dbg !108
  store i64 %16, i64* %3, align 8, !dbg !108
  br label %5, !dbg !109, !llvm.loop !110

17:                                               ; preds = %5
  call void @post(), !dbg !113
  call void @llvm.dbg.declare(metadata i64* %4, metadata !114, metadata !DIExpression()), !dbg !116
  store i64 0, i64* %4, align 8, !dbg !116
  br label %18, !dbg !117

18:                                               ; preds = %26, %17
  %19 = load i64, i64* %4, align 8, !dbg !118
  %20 = icmp ult i64 %19, 3, !dbg !120
  br i1 %20, label %21, label %29, !dbg !121

21:                                               ; preds = %18
  %22 = load i64, i64* %4, align 8, !dbg !122
  %23 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %22, !dbg !124
  %24 = load i64, i64* %23, align 8, !dbg !124
  %25 = call i32 @pthread_join(i64 noundef %24, i8** noundef null), !dbg !125
  br label %26, !dbg !126

26:                                               ; preds = %21
  %27 = load i64, i64* %4, align 8, !dbg !127
  %28 = add i64 %27, 1, !dbg !127
  store i64 %28, i64* %4, align 8, !dbg !127
  br label %18, !dbg !128, !llvm.loop !129

29:                                               ; preds = %18
  call void @check(), !dbg !131
  call void @fini(), !dbg !132
  ret i32 0, !dbg !133
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !134 {
  call void @arraylock_init(%struct.arraylock_s* noundef @lock, %struct.arraylock_flag_s* noundef getelementptr inbounds ([4 x %struct.arraylock_flag_s], [4 x %struct.arraylock_flag_s]* @flags, i64 0, i64 0), i32 noundef 4), !dbg !135
  ret void, !dbg !136
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !137 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !140, metadata !DIExpression()), !dbg !141
  call void @llvm.dbg.declare(metadata i32* %3, metadata !142, metadata !DIExpression()), !dbg !143
  %7 = load i8*, i8** %2, align 8, !dbg !144
  %8 = ptrtoint i8* %7 to i64, !dbg !145
  %9 = trunc i64 %8 to i32, !dbg !145
  store i32 %9, i32* %3, align 4, !dbg !143
  call void @llvm.dbg.declare(metadata i32* %4, metadata !146, metadata !DIExpression()), !dbg !148
  store i32 0, i32* %4, align 4, !dbg !148
  br label %10, !dbg !149

10:                                               ; preds = %65, %1
  %11 = load i32, i32* %4, align 4, !dbg !150
  %12 = icmp eq i32 %11, 0, !dbg !152
  br i1 %12, label %22, label %13, !dbg !153

13:                                               ; preds = %10
  %14 = load i32, i32* %4, align 4, !dbg !154
  %15 = icmp eq i32 %14, 1, !dbg !154
  br i1 %15, label %16, label %20, !dbg !154

16:                                               ; preds = %13
  %17 = load i32, i32* %3, align 4, !dbg !154
  %18 = add i32 %17, 1, !dbg !154
  %19 = icmp ult i32 %18, 2, !dbg !154
  br label %20

20:                                               ; preds = %16, %13
  %21 = phi i1 [ false, %13 ], [ %19, %16 ], !dbg !155
  br label %22, !dbg !153

22:                                               ; preds = %20, %10
  %23 = phi i1 [ true, %10 ], [ %21, %20 ]
  br i1 %23, label %24, label %68, !dbg !156

24:                                               ; preds = %22
  call void @llvm.dbg.declare(metadata i32* %5, metadata !157, metadata !DIExpression()), !dbg !160
  store i32 0, i32* %5, align 4, !dbg !160
  br label %25, !dbg !161

25:                                               ; preds = %41, %24
  %26 = load i32, i32* %5, align 4, !dbg !162
  %27 = icmp eq i32 %26, 0, !dbg !164
  br i1 %27, label %37, label %28, !dbg !165

28:                                               ; preds = %25
  %29 = load i32, i32* %5, align 4, !dbg !166
  %30 = icmp eq i32 %29, 1, !dbg !166
  br i1 %30, label %31, label %35, !dbg !166

31:                                               ; preds = %28
  %32 = load i32, i32* %3, align 4, !dbg !166
  %33 = add i32 %32, 1, !dbg !166
  %34 = icmp ult i32 %33, 1, !dbg !166
  br label %35

35:                                               ; preds = %31, %28
  %36 = phi i1 [ false, %28 ], [ %34, %31 ], !dbg !167
  br label %37, !dbg !165

37:                                               ; preds = %35, %25
  %38 = phi i1 [ true, %25 ], [ %36, %35 ]
  br i1 %38, label %39, label %44, !dbg !168

39:                                               ; preds = %37
  %40 = load i32, i32* %3, align 4, !dbg !169
  call void @acquire(i32 noundef %40), !dbg !171
  call void @cs(), !dbg !172
  br label %41, !dbg !173

41:                                               ; preds = %39
  %42 = load i32, i32* %5, align 4, !dbg !174
  %43 = add nsw i32 %42, 1, !dbg !174
  store i32 %43, i32* %5, align 4, !dbg !174
  br label %25, !dbg !175, !llvm.loop !176

44:                                               ; preds = %37
  call void @llvm.dbg.declare(metadata i32* %6, metadata !178, metadata !DIExpression()), !dbg !180
  store i32 0, i32* %6, align 4, !dbg !180
  br label %45, !dbg !181

45:                                               ; preds = %61, %44
  %46 = load i32, i32* %6, align 4, !dbg !182
  %47 = icmp eq i32 %46, 0, !dbg !184
  br i1 %47, label %57, label %48, !dbg !185

48:                                               ; preds = %45
  %49 = load i32, i32* %6, align 4, !dbg !186
  %50 = icmp eq i32 %49, 1, !dbg !186
  br i1 %50, label %51, label %55, !dbg !186

51:                                               ; preds = %48
  %52 = load i32, i32* %3, align 4, !dbg !186
  %53 = add i32 %52, 1, !dbg !186
  %54 = icmp ult i32 %53, 1, !dbg !186
  br label %55

55:                                               ; preds = %51, %48
  %56 = phi i1 [ false, %48 ], [ %54, %51 ], !dbg !187
  br label %57, !dbg !185

57:                                               ; preds = %55, %45
  %58 = phi i1 [ true, %45 ], [ %56, %55 ]
  br i1 %58, label %59, label %64, !dbg !188

59:                                               ; preds = %57
  %60 = load i32, i32* %3, align 4, !dbg !189
  call void @release(i32 noundef %60), !dbg !191
  br label %61, !dbg !192

61:                                               ; preds = %59
  %62 = load i32, i32* %6, align 4, !dbg !193
  %63 = add nsw i32 %62, 1, !dbg !193
  store i32 %63, i32* %6, align 4, !dbg !193
  br label %45, !dbg !194, !llvm.loop !195

64:                                               ; preds = %57
  br label %65, !dbg !197

65:                                               ; preds = %64
  %66 = load i32, i32* %4, align 4, !dbg !198
  %67 = add nsw i32 %66, 1, !dbg !198
  store i32 %67, i32* %4, align 4, !dbg !198
  br label %10, !dbg !199, !llvm.loop !200

68:                                               ; preds = %22
  ret i8* null, !dbg !202
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @arraylock_init(%struct.arraylock_s* noundef %0, %struct.arraylock_flag_s* noundef %1, i32 noundef %2) #0 !dbg !203 {
  %4 = alloca %struct.arraylock_s*, align 8
  %5 = alloca %struct.arraylock_flag_s*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.arraylock_s* %0, %struct.arraylock_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.arraylock_s** %4, metadata !208, metadata !DIExpression()), !dbg !209
  store %struct.arraylock_flag_s* %1, %struct.arraylock_flag_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.arraylock_flag_s** %5, metadata !210, metadata !DIExpression()), !dbg !211
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !212, metadata !DIExpression()), !dbg !213
  call void @llvm.dbg.declare(metadata i32* %7, metadata !214, metadata !DIExpression()), !dbg !215
  store i32 0, i32* %7, align 4, !dbg !215
  %8 = load %struct.arraylock_s*, %struct.arraylock_s** %4, align 8, !dbg !216
  %9 = getelementptr inbounds %struct.arraylock_s, %struct.arraylock_s* %8, i32 0, i32 0, !dbg !217
  call void @vatomic8_init(%struct.vatomic8_s* noundef %9, i8 noundef zeroext 0), !dbg !218
  %10 = load i32, i32* %6, align 4, !dbg !219
  %11 = icmp ugt i32 %10, 0, !dbg !219
  br i1 %11, label %12, label %13, !dbg !222

12:                                               ; preds = %3
  br label %14, !dbg !222

13:                                               ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([74 x i8], [74 x i8]* @.str.4, i64 0, i64 0), i32 noundef 65, i8* noundef getelementptr inbounds ([72 x i8], [72 x i8]* @__PRETTY_FUNCTION__.arraylock_init, i64 0, i64 0)) #5, !dbg !219
  unreachable, !dbg !219

14:                                               ; preds = %12
  %15 = load i32, i32* %6, align 4, !dbg !223
  %16 = icmp ne i32 %15, 0, !dbg !223
  br i1 %16, label %17, label %24, !dbg !223

17:                                               ; preds = %14
  %18 = load i32, i32* %6, align 4, !dbg !223
  %19 = load i32, i32* %6, align 4, !dbg !223
  %20 = sub i32 %19, 1, !dbg !223
  %21 = and i32 %18, %20, !dbg !223
  %22 = icmp eq i32 %21, 0, !dbg !223
  br i1 %22, label %23, label %24, !dbg !226

23:                                               ; preds = %17
  br label %25, !dbg !226

24:                                               ; preds = %17, %14
  call void @__assert_fail(i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([74 x i8], [74 x i8]* @.str.4, i64 0, i64 0), i32 noundef 66, i8* noundef getelementptr inbounds ([72 x i8], [72 x i8]* @__PRETTY_FUNCTION__.arraylock_init, i64 0, i64 0)) #5, !dbg !223
  unreachable, !dbg !223

25:                                               ; preds = %23
  %26 = load i32, i32* %6, align 4, !dbg !227
  %27 = load %struct.arraylock_s*, %struct.arraylock_s** %4, align 8, !dbg !228
  %28 = getelementptr inbounds %struct.arraylock_s, %struct.arraylock_s* %27, i32 0, i32 2, !dbg !229
  store i32 %26, i32* %28, align 8, !dbg !230
  %29 = load %struct.arraylock_flag_s*, %struct.arraylock_flag_s** %5, align 8, !dbg !231
  %30 = load %struct.arraylock_s*, %struct.arraylock_s** %4, align 8, !dbg !232
  %31 = getelementptr inbounds %struct.arraylock_s, %struct.arraylock_s* %30, i32 0, i32 1, !dbg !233
  store %struct.arraylock_flag_s* %29, %struct.arraylock_flag_s** %31, align 8, !dbg !234
  %32 = load %struct.arraylock_s*, %struct.arraylock_s** %4, align 8, !dbg !235
  %33 = getelementptr inbounds %struct.arraylock_s, %struct.arraylock_s* %32, i32 0, i32 1, !dbg !236
  %34 = load %struct.arraylock_flag_s*, %struct.arraylock_flag_s** %33, align 8, !dbg !236
  %35 = getelementptr inbounds %struct.arraylock_flag_s, %struct.arraylock_flag_s* %34, i64 0, !dbg !235
  %36 = getelementptr inbounds %struct.arraylock_flag_s, %struct.arraylock_flag_s* %35, i32 0, i32 0, !dbg !237
  call void @vatomic8_init(%struct.vatomic8_s* noundef %36, i8 noundef zeroext 1), !dbg !238
  store i32 1, i32* %7, align 4, !dbg !239
  br label %37, !dbg !241

37:                                               ; preds = %51, %25
  %38 = load i32, i32* %7, align 4, !dbg !242
  %39 = load %struct.arraylock_s*, %struct.arraylock_s** %4, align 8, !dbg !244
  %40 = getelementptr inbounds %struct.arraylock_s, %struct.arraylock_s* %39, i32 0, i32 2, !dbg !245
  %41 = load i32, i32* %40, align 8, !dbg !245
  %42 = icmp ult i32 %38, %41, !dbg !246
  br i1 %42, label %43, label %54, !dbg !247

43:                                               ; preds = %37
  %44 = load %struct.arraylock_s*, %struct.arraylock_s** %4, align 8, !dbg !248
  %45 = getelementptr inbounds %struct.arraylock_s, %struct.arraylock_s* %44, i32 0, i32 1, !dbg !250
  %46 = load %struct.arraylock_flag_s*, %struct.arraylock_flag_s** %45, align 8, !dbg !250
  %47 = load i32, i32* %7, align 4, !dbg !251
  %48 = zext i32 %47 to i64, !dbg !248
  %49 = getelementptr inbounds %struct.arraylock_flag_s, %struct.arraylock_flag_s* %46, i64 %48, !dbg !248
  %50 = getelementptr inbounds %struct.arraylock_flag_s, %struct.arraylock_flag_s* %49, i32 0, i32 0, !dbg !252
  call void @vatomic8_init(%struct.vatomic8_s* noundef %50, i8 noundef zeroext 0), !dbg !253
  br label %51, !dbg !254

51:                                               ; preds = %43
  %52 = load i32, i32* %7, align 4, !dbg !255
  %53 = add i32 %52, 1, !dbg !255
  store i32 %53, i32* %7, align 4, !dbg !255
  br label %37, !dbg !256, !llvm.loop !257

54:                                               ; preds = %37
  ret void, !dbg !259
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !260 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !263, metadata !DIExpression()), !dbg !264
  br label %3, !dbg !265

3:                                                ; preds = %1
  br label %4, !dbg !266

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !268
  br label %6, !dbg !268

6:                                                ; preds = %4
  br label %7, !dbg !270

7:                                                ; preds = %6
  br label %8, !dbg !268

8:                                                ; preds = %7
  br label %9, !dbg !266

9:                                                ; preds = %8
  call void @arraylock_acquire(%struct.arraylock_s* noundef @lock, i32* noundef @slot), !dbg !272
  ret void, !dbg !273
}

; Function Attrs: noinline nounwind uwtable
define internal void @arraylock_acquire(%struct.arraylock_s* noundef %0, i32* noundef %1) #0 !dbg !274 {
  %3 = alloca %struct.arraylock_s*, align 8
  %4 = alloca i32*, align 8
  %5 = alloca i32, align 4
  store %struct.arraylock_s* %0, %struct.arraylock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.arraylock_s** %3, metadata !278, metadata !DIExpression()), !dbg !279
  store i32* %1, i32** %4, align 8
  call void @llvm.dbg.declare(metadata i32** %4, metadata !280, metadata !DIExpression()), !dbg !281
  call void @llvm.dbg.declare(metadata i32* %5, metadata !282, metadata !DIExpression()), !dbg !283
  %6 = load %struct.arraylock_s*, %struct.arraylock_s** %3, align 8, !dbg !284
  %7 = getelementptr inbounds %struct.arraylock_s, %struct.arraylock_s* %6, i32 0, i32 0, !dbg !285
  %8 = call zeroext i8 @vatomic8_get_inc(%struct.vatomic8_s* noundef %7), !dbg !286
  %9 = zext i8 %8 to i32, !dbg !286
  store i32 %9, i32* %5, align 4, !dbg !283
  %10 = load i32, i32* %5, align 4, !dbg !287
  %11 = load %struct.arraylock_s*, %struct.arraylock_s** %3, align 8, !dbg !288
  %12 = getelementptr inbounds %struct.arraylock_s, %struct.arraylock_s* %11, i32 0, i32 2, !dbg !289
  %13 = load i32, i32* %12, align 8, !dbg !289
  %14 = urem i32 %10, %13, !dbg !290
  %15 = load i32*, i32** %4, align 8, !dbg !291
  store i32 %14, i32* %15, align 4, !dbg !292
  br label %16, !dbg !293

16:                                               ; preds = %28, %2
  %17 = load %struct.arraylock_s*, %struct.arraylock_s** %3, align 8, !dbg !293
  %18 = getelementptr inbounds %struct.arraylock_s, %struct.arraylock_s* %17, i32 0, i32 1, !dbg !293
  %19 = load %struct.arraylock_flag_s*, %struct.arraylock_flag_s** %18, align 8, !dbg !293
  %20 = load i32*, i32** %4, align 8, !dbg !293
  %21 = load i32, i32* %20, align 4, !dbg !293
  %22 = zext i32 %21 to i64, !dbg !293
  %23 = getelementptr inbounds %struct.arraylock_flag_s, %struct.arraylock_flag_s* %19, i64 %22, !dbg !293
  %24 = getelementptr inbounds %struct.arraylock_flag_s, %struct.arraylock_flag_s* %23, i32 0, i32 0, !dbg !293
  %25 = call zeroext i8 @vatomic8_read_acq(%struct.vatomic8_s* noundef %24), !dbg !293
  %26 = zext i8 %25 to i32, !dbg !293
  %27 = icmp eq i32 %26, 0, !dbg !293
  br i1 %27, label %28, label %29, !dbg !293

28:                                               ; preds = %16
  br label %16, !dbg !293, !llvm.loop !294

29:                                               ; preds = %16
  ret void, !dbg !296
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !297 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !298, metadata !DIExpression()), !dbg !299
  br label %3, !dbg !300

3:                                                ; preds = %1
  br label %4, !dbg !301

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !303
  br label %6, !dbg !303

6:                                                ; preds = %4
  br label %7, !dbg !305

7:                                                ; preds = %6
  br label %8, !dbg !303

8:                                                ; preds = %7
  br label %9, !dbg !301

9:                                                ; preds = %8
  %10 = load i32, i32* @slot, align 4, !dbg !307
  call void @arraylock_release(%struct.arraylock_s* noundef @lock, i32 noundef %10), !dbg !308
  ret void, !dbg !309
}

; Function Attrs: noinline nounwind uwtable
define internal void @arraylock_release(%struct.arraylock_s* noundef %0, i32 noundef %1) #0 !dbg !310 {
  %3 = alloca %struct.arraylock_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.arraylock_s* %0, %struct.arraylock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.arraylock_s** %3, metadata !313, metadata !DIExpression()), !dbg !314
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !315, metadata !DIExpression()), !dbg !316
  call void @llvm.dbg.declare(metadata i32* %5, metadata !317, metadata !DIExpression()), !dbg !318
  store i32 0, i32* %5, align 4, !dbg !318
  %6 = load %struct.arraylock_s*, %struct.arraylock_s** %3, align 8, !dbg !319
  %7 = getelementptr inbounds %struct.arraylock_s, %struct.arraylock_s* %6, i32 0, i32 1, !dbg !320
  %8 = load %struct.arraylock_flag_s*, %struct.arraylock_flag_s** %7, align 8, !dbg !320
  %9 = load i32, i32* %4, align 4, !dbg !321
  %10 = zext i32 %9 to i64, !dbg !319
  %11 = getelementptr inbounds %struct.arraylock_flag_s, %struct.arraylock_flag_s* %8, i64 %10, !dbg !319
  %12 = getelementptr inbounds %struct.arraylock_flag_s, %struct.arraylock_flag_s* %11, i32 0, i32 0, !dbg !322
  call void @vatomic8_write_rlx(%struct.vatomic8_s* noundef %12, i8 noundef zeroext 0), !dbg !323
  %13 = load i32, i32* %4, align 4, !dbg !324
  %14 = add i32 %13, 1, !dbg !325
  %15 = load %struct.arraylock_s*, %struct.arraylock_s** %3, align 8, !dbg !326
  %16 = getelementptr inbounds %struct.arraylock_s, %struct.arraylock_s* %15, i32 0, i32 2, !dbg !327
  %17 = load i32, i32* %16, align 8, !dbg !327
  %18 = urem i32 %14, %17, !dbg !328
  store i32 %18, i32* %5, align 4, !dbg !329
  %19 = load %struct.arraylock_s*, %struct.arraylock_s** %3, align 8, !dbg !330
  %20 = getelementptr inbounds %struct.arraylock_s, %struct.arraylock_s* %19, i32 0, i32 1, !dbg !331
  %21 = load %struct.arraylock_flag_s*, %struct.arraylock_flag_s** %20, align 8, !dbg !331
  %22 = load i32, i32* %5, align 4, !dbg !332
  %23 = zext i32 %22 to i64, !dbg !330
  %24 = getelementptr inbounds %struct.arraylock_flag_s, %struct.arraylock_flag_s* %21, i64 %23, !dbg !330
  %25 = getelementptr inbounds %struct.arraylock_flag_s, %struct.arraylock_flag_s* %24, i32 0, i32 0, !dbg !333
  call void @vatomic8_write_rel(%struct.vatomic8_s* noundef %25, i8 noundef zeroext 1), !dbg !334
  ret void, !dbg !335
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic8_init(%struct.vatomic8_s* noundef %0, i8 noundef zeroext %1) #0 !dbg !336 {
  %3 = alloca %struct.vatomic8_s*, align 8
  %4 = alloca i8, align 1
  store %struct.vatomic8_s* %0, %struct.vatomic8_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic8_s** %3, metadata !341, metadata !DIExpression()), !dbg !342
  store i8 %1, i8* %4, align 1
  call void @llvm.dbg.declare(metadata i8* %4, metadata !343, metadata !DIExpression()), !dbg !344
  %5 = load %struct.vatomic8_s*, %struct.vatomic8_s** %3, align 8, !dbg !345
  %6 = load i8, i8* %4, align 1, !dbg !346
  call void @vatomic8_write(%struct.vatomic8_s* noundef %5, i8 noundef zeroext %6), !dbg !347
  ret void, !dbg !348
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic8_write(%struct.vatomic8_s* noundef %0, i8 noundef zeroext %1) #0 !dbg !349 {
  %3 = alloca %struct.vatomic8_s*, align 8
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
  store %struct.vatomic8_s* %0, %struct.vatomic8_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic8_s** %3, metadata !351, metadata !DIExpression()), !dbg !352
  store i8 %1, i8* %4, align 1
  call void @llvm.dbg.declare(metadata i8* %4, metadata !353, metadata !DIExpression()), !dbg !354
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !355, !srcloc !356
  %6 = load %struct.vatomic8_s*, %struct.vatomic8_s** %3, align 8, !dbg !357
  %7 = getelementptr inbounds %struct.vatomic8_s, %struct.vatomic8_s* %6, i32 0, i32 0, !dbg !358
  %8 = load i8, i8* %4, align 1, !dbg !359
  store i8 %8, i8* %5, align 1, !dbg !360
  %9 = load i8, i8* %5, align 1, !dbg !360
  store atomic i8 %9, i8* %7 seq_cst, align 1, !dbg !360
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !361, !srcloc !362
  ret void, !dbg !363
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i8 @vatomic8_get_inc(%struct.vatomic8_s* noundef %0) #0 !dbg !364 {
  %2 = alloca %struct.vatomic8_s*, align 8
  store %struct.vatomic8_s* %0, %struct.vatomic8_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic8_s** %2, metadata !367, metadata !DIExpression()), !dbg !368
  %3 = load %struct.vatomic8_s*, %struct.vatomic8_s** %2, align 8, !dbg !369
  %4 = call zeroext i8 @vatomic8_get_add(%struct.vatomic8_s* noundef %3, i8 noundef zeroext 1), !dbg !370
  ret i8 %4, !dbg !371
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i8 @vatomic8_read_acq(%struct.vatomic8_s* noundef %0) #0 !dbg !372 {
  %2 = alloca %struct.vatomic8_s*, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  store %struct.vatomic8_s* %0, %struct.vatomic8_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic8_s** %2, metadata !377, metadata !DIExpression()), !dbg !378
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !379, !srcloc !380
  call void @llvm.dbg.declare(metadata i8* %3, metadata !381, metadata !DIExpression()), !dbg !382
  %5 = load %struct.vatomic8_s*, %struct.vatomic8_s** %2, align 8, !dbg !383
  %6 = getelementptr inbounds %struct.vatomic8_s, %struct.vatomic8_s* %5, i32 0, i32 0, !dbg !384
  %7 = load atomic i8, i8* %6 acquire, align 1, !dbg !385
  store i8 %7, i8* %4, align 1, !dbg !385
  %8 = load i8, i8* %4, align 1, !dbg !385
  store i8 %8, i8* %3, align 1, !dbg !382
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !386, !srcloc !387
  %9 = load i8, i8* %3, align 1, !dbg !388
  ret i8 %9, !dbg !389
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i8 @vatomic8_get_add(%struct.vatomic8_s* noundef %0, i8 noundef zeroext %1) #0 !dbg !390 {
  %3 = alloca %struct.vatomic8_s*, align 8
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
  %6 = alloca i8, align 1
  %7 = alloca i8, align 1
  store %struct.vatomic8_s* %0, %struct.vatomic8_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic8_s** %3, metadata !393, metadata !DIExpression()), !dbg !394
  store i8 %1, i8* %4, align 1
  call void @llvm.dbg.declare(metadata i8* %4, metadata !395, metadata !DIExpression()), !dbg !396
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !397, !srcloc !398
  call void @llvm.dbg.declare(metadata i8* %5, metadata !399, metadata !DIExpression()), !dbg !400
  %8 = load %struct.vatomic8_s*, %struct.vatomic8_s** %3, align 8, !dbg !401
  %9 = getelementptr inbounds %struct.vatomic8_s, %struct.vatomic8_s* %8, i32 0, i32 0, !dbg !402
  %10 = load i8, i8* %4, align 1, !dbg !403
  store i8 %10, i8* %6, align 1, !dbg !404
  %11 = load i8, i8* %6, align 1, !dbg !404
  %12 = atomicrmw add i8* %9, i8 %11 seq_cst, align 1, !dbg !404
  store i8 %12, i8* %7, align 1, !dbg !404
  %13 = load i8, i8* %7, align 1, !dbg !404
  store i8 %13, i8* %5, align 1, !dbg !400
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !405, !srcloc !406
  %14 = load i8, i8* %5, align 1, !dbg !407
  ret i8 %14, !dbg !408
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic8_write_rlx(%struct.vatomic8_s* noundef %0, i8 noundef zeroext %1) #0 !dbg !409 {
  %3 = alloca %struct.vatomic8_s*, align 8
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
  store %struct.vatomic8_s* %0, %struct.vatomic8_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic8_s** %3, metadata !410, metadata !DIExpression()), !dbg !411
  store i8 %1, i8* %4, align 1
  call void @llvm.dbg.declare(metadata i8* %4, metadata !412, metadata !DIExpression()), !dbg !413
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !414, !srcloc !415
  %6 = load %struct.vatomic8_s*, %struct.vatomic8_s** %3, align 8, !dbg !416
  %7 = getelementptr inbounds %struct.vatomic8_s, %struct.vatomic8_s* %6, i32 0, i32 0, !dbg !417
  %8 = load i8, i8* %4, align 1, !dbg !418
  store i8 %8, i8* %5, align 1, !dbg !419
  %9 = load i8, i8* %5, align 1, !dbg !419
  store atomic i8 %9, i8* %7 monotonic, align 1, !dbg !419
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !420, !srcloc !421
  ret void, !dbg !422
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic8_write_rel(%struct.vatomic8_s* noundef %0, i8 noundef zeroext %1) #0 !dbg !423 {
  %3 = alloca %struct.vatomic8_s*, align 8
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
  store %struct.vatomic8_s* %0, %struct.vatomic8_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic8_s** %3, metadata !424, metadata !DIExpression()), !dbg !425
  store i8 %1, i8* %4, align 1
  call void @llvm.dbg.declare(metadata i8* %4, metadata !426, metadata !DIExpression()), !dbg !427
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !428, !srcloc !429
  %6 = load %struct.vatomic8_s*, %struct.vatomic8_s** %3, align 8, !dbg !430
  %7 = getelementptr inbounds %struct.vatomic8_s, %struct.vatomic8_s* %6, i32 0, i32 0, !dbg !431
  %8 = load i8, i8* %4, align 1, !dbg !432
  store i8 %8, i8* %5, align 1, !dbg !433
  %9 = load i8, i8* %5, align 1, !dbg !433
  store atomic i8 %9, i8* %7 release, align 1, !dbg !433
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !434, !srcloc !435
  ret void, !dbg !436
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!52, !53, !54, !55, !56, !57, !58}
!llvm.ident = !{!59}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !51, line: 100, type: !43, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/spinlock/test/arraylock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "f8013d9d75bd534965f34993c2dade82")
!4 = !{!5, !6, !11}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 37, baseType: !8)
!7 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !9, line: 90, baseType: !10)
!9 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint8_t", file: !7, line: 33, baseType: !12)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !13, line: 24, baseType: !14)
!13 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !15, line: 38, baseType: !16)
!15 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!16 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!17 = !{!18, !34, !47, !0, !49}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "flags", scope: !2, file: !20, line: 11, type: !21, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "spinlock/test/arraylock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "f8013d9d75bd534965f34993c2dade82")
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 32, elements: !32)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "arraylock_flag_t", file: !23, line: 38, baseType: !24)
!23 = !DIFile(filename: "spinlock/include/vsync/spinlock/arraylock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "fa4f673ba61f80711983dda9a8fc1e97")
!24 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "arraylock_flag_s", file: !23, line: 36, size: 8, elements: !25)
!25 = !{!26}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "flag", scope: !24, file: !23, line: 37, baseType: !27, size: 8)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic8_t", file: !28, line: 24, baseType: !29)
!28 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic8_s", file: !28, line: 22, size: 8, elements: !30)
!30 = !{!31}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !29, file: !28, line: 23, baseType: !11, size: 8)
!32 = !{!33}
!33 = !DISubrange(count: 4)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !20, line: 12, type: !36, isLocal: false, isDefinition: true)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "arraylock_t", file: !23, line: 46, baseType: !37)
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "arraylock_s", file: !23, line: 40, size: 192, elements: !38)
!38 = !{!39, !40, !42}
!39 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !37, file: !23, line: 41, baseType: !27, size: 8)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "flags", scope: !37, file: !23, line: 43, baseType: !41, size: 64, offset: 64)
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "flags_len", scope: !37, file: !23, line: 45, baseType: !43, size: 32, offset: 128)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !7, line: 35, baseType: !44)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !13, line: 26, baseType: !45)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !15, line: 42, baseType: !46)
!46 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "slot", scope: !2, file: !20, line: 13, type: !43, isLocal: true, isDefinition: true)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !51, line: 101, type: !43, isLocal: true, isDefinition: true)
!51 = !DIFile(filename: "utils/include/test/boilerplate/lock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4187ade4a536ecfd1f9ed3ab727ca965")
!52 = !{i32 7, !"Dwarf Version", i32 5}
!53 = !{i32 2, !"Debug Info Version", i32 3}
!54 = !{i32 1, !"wchar_size", i32 4}
!55 = !{i32 7, !"PIC Level", i32 2}
!56 = !{i32 7, !"PIE Level", i32 2}
!57 = !{i32 7, !"uwtable", i32 1}
!58 = !{i32 7, !"frame-pointer", i32 2}
!59 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!60 = distinct !DISubprogram(name: "post", scope: !51, file: !51, line: 77, type: !61, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!61 = !DISubroutineType(types: !62)
!62 = !{null}
!63 = !{}
!64 = !DILocation(line: 79, column: 1, scope: !60)
!65 = distinct !DISubprogram(name: "fini", scope: !51, file: !51, line: 86, type: !61, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!66 = !DILocation(line: 88, column: 1, scope: !65)
!67 = distinct !DISubprogram(name: "cs", scope: !51, file: !51, line: 104, type: !61, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!68 = !DILocation(line: 106, column: 11, scope: !67)
!69 = !DILocation(line: 107, column: 11, scope: !67)
!70 = !DILocation(line: 108, column: 1, scope: !67)
!71 = distinct !DISubprogram(name: "check", scope: !51, file: !51, line: 110, type: !61, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!72 = !DILocation(line: 112, column: 5, scope: !73)
!73 = distinct !DILexicalBlock(scope: !74, file: !51, line: 112, column: 5)
!74 = distinct !DILexicalBlock(scope: !71, file: !51, line: 112, column: 5)
!75 = !DILocation(line: 112, column: 5, scope: !74)
!76 = !DILocation(line: 113, column: 5, scope: !77)
!77 = distinct !DILexicalBlock(scope: !78, file: !51, line: 113, column: 5)
!78 = distinct !DILexicalBlock(scope: !71, file: !51, line: 113, column: 5)
!79 = !DILocation(line: 113, column: 5, scope: !78)
!80 = !DILocation(line: 114, column: 1, scope: !71)
!81 = distinct !DISubprogram(name: "main", scope: !51, file: !51, line: 141, type: !82, scopeLine: 142, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!82 = !DISubroutineType(types: !83)
!83 = !{!84}
!84 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!85 = !DILocalVariable(name: "t", scope: !81, file: !51, line: 143, type: !86)
!86 = !DICompositeType(tag: DW_TAG_array_type, baseType: !87, size: 192, elements: !89)
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !88, line: 27, baseType: !10)
!88 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!89 = !{!90}
!90 = !DISubrange(count: 3)
!91 = !DILocation(line: 143, column: 15, scope: !81)
!92 = !DILocation(line: 150, column: 5, scope: !81)
!93 = !DILocalVariable(name: "i", scope: !94, file: !51, line: 152, type: !6)
!94 = distinct !DILexicalBlock(scope: !81, file: !51, line: 152, column: 5)
!95 = !DILocation(line: 152, column: 21, scope: !94)
!96 = !DILocation(line: 152, column: 10, scope: !94)
!97 = !DILocation(line: 152, column: 28, scope: !98)
!98 = distinct !DILexicalBlock(scope: !94, file: !51, line: 152, column: 5)
!99 = !DILocation(line: 152, column: 30, scope: !98)
!100 = !DILocation(line: 152, column: 5, scope: !94)
!101 = !DILocation(line: 153, column: 33, scope: !102)
!102 = distinct !DILexicalBlock(scope: !98, file: !51, line: 152, column: 47)
!103 = !DILocation(line: 153, column: 31, scope: !102)
!104 = !DILocation(line: 153, column: 53, scope: !102)
!105 = !DILocation(line: 153, column: 45, scope: !102)
!106 = !DILocation(line: 153, column: 15, scope: !102)
!107 = !DILocation(line: 154, column: 5, scope: !102)
!108 = !DILocation(line: 152, column: 43, scope: !98)
!109 = !DILocation(line: 152, column: 5, scope: !98)
!110 = distinct !{!110, !100, !111, !112}
!111 = !DILocation(line: 154, column: 5, scope: !94)
!112 = !{!"llvm.loop.mustprogress"}
!113 = !DILocation(line: 156, column: 5, scope: !81)
!114 = !DILocalVariable(name: "i", scope: !115, file: !51, line: 158, type: !6)
!115 = distinct !DILexicalBlock(scope: !81, file: !51, line: 158, column: 5)
!116 = !DILocation(line: 158, column: 21, scope: !115)
!117 = !DILocation(line: 158, column: 10, scope: !115)
!118 = !DILocation(line: 158, column: 28, scope: !119)
!119 = distinct !DILexicalBlock(scope: !115, file: !51, line: 158, column: 5)
!120 = !DILocation(line: 158, column: 30, scope: !119)
!121 = !DILocation(line: 158, column: 5, scope: !115)
!122 = !DILocation(line: 159, column: 30, scope: !123)
!123 = distinct !DILexicalBlock(scope: !119, file: !51, line: 158, column: 47)
!124 = !DILocation(line: 159, column: 28, scope: !123)
!125 = !DILocation(line: 159, column: 15, scope: !123)
!126 = !DILocation(line: 160, column: 5, scope: !123)
!127 = !DILocation(line: 158, column: 43, scope: !119)
!128 = !DILocation(line: 158, column: 5, scope: !119)
!129 = distinct !{!129, !121, !130, !112}
!130 = !DILocation(line: 160, column: 5, scope: !115)
!131 = !DILocation(line: 167, column: 5, scope: !81)
!132 = !DILocation(line: 168, column: 5, scope: !81)
!133 = !DILocation(line: 170, column: 5, scope: !81)
!134 = distinct !DISubprogram(name: "init", scope: !20, file: !20, line: 21, type: !61, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!135 = !DILocation(line: 23, column: 5, scope: !134)
!136 = !DILocation(line: 24, column: 1, scope: !134)
!137 = distinct !DISubprogram(name: "run", scope: !51, file: !51, line: 119, type: !138, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!138 = !DISubroutineType(types: !139)
!139 = !{!5, !5}
!140 = !DILocalVariable(name: "arg", arg: 1, scope: !137, file: !51, line: 119, type: !5)
!141 = !DILocation(line: 119, column: 11, scope: !137)
!142 = !DILocalVariable(name: "tid", scope: !137, file: !51, line: 121, type: !43)
!143 = !DILocation(line: 121, column: 15, scope: !137)
!144 = !DILocation(line: 121, column: 33, scope: !137)
!145 = !DILocation(line: 121, column: 21, scope: !137)
!146 = !DILocalVariable(name: "i", scope: !147, file: !51, line: 125, type: !84)
!147 = distinct !DILexicalBlock(scope: !137, file: !51, line: 125, column: 5)
!148 = !DILocation(line: 125, column: 14, scope: !147)
!149 = !DILocation(line: 125, column: 10, scope: !147)
!150 = !DILocation(line: 125, column: 21, scope: !151)
!151 = distinct !DILexicalBlock(scope: !147, file: !51, line: 125, column: 5)
!152 = !DILocation(line: 125, column: 23, scope: !151)
!153 = !DILocation(line: 125, column: 28, scope: !151)
!154 = !DILocation(line: 125, column: 31, scope: !151)
!155 = !DILocation(line: 0, scope: !151)
!156 = !DILocation(line: 125, column: 5, scope: !147)
!157 = !DILocalVariable(name: "j", scope: !158, file: !51, line: 129, type: !84)
!158 = distinct !DILexicalBlock(scope: !159, file: !51, line: 129, column: 9)
!159 = distinct !DILexicalBlock(scope: !151, file: !51, line: 125, column: 63)
!160 = !DILocation(line: 129, column: 18, scope: !158)
!161 = !DILocation(line: 129, column: 14, scope: !158)
!162 = !DILocation(line: 129, column: 25, scope: !163)
!163 = distinct !DILexicalBlock(scope: !158, file: !51, line: 129, column: 9)
!164 = !DILocation(line: 129, column: 27, scope: !163)
!165 = !DILocation(line: 129, column: 32, scope: !163)
!166 = !DILocation(line: 129, column: 35, scope: !163)
!167 = !DILocation(line: 0, scope: !163)
!168 = !DILocation(line: 129, column: 9, scope: !158)
!169 = !DILocation(line: 130, column: 21, scope: !170)
!170 = distinct !DILexicalBlock(scope: !163, file: !51, line: 129, column: 67)
!171 = !DILocation(line: 130, column: 13, scope: !170)
!172 = !DILocation(line: 131, column: 13, scope: !170)
!173 = !DILocation(line: 132, column: 9, scope: !170)
!174 = !DILocation(line: 129, column: 63, scope: !163)
!175 = !DILocation(line: 129, column: 9, scope: !163)
!176 = distinct !{!176, !168, !177, !112}
!177 = !DILocation(line: 132, column: 9, scope: !158)
!178 = !DILocalVariable(name: "j", scope: !179, file: !51, line: 133, type: !84)
!179 = distinct !DILexicalBlock(scope: !159, file: !51, line: 133, column: 9)
!180 = !DILocation(line: 133, column: 18, scope: !179)
!181 = !DILocation(line: 133, column: 14, scope: !179)
!182 = !DILocation(line: 133, column: 25, scope: !183)
!183 = distinct !DILexicalBlock(scope: !179, file: !51, line: 133, column: 9)
!184 = !DILocation(line: 133, column: 27, scope: !183)
!185 = !DILocation(line: 133, column: 32, scope: !183)
!186 = !DILocation(line: 133, column: 35, scope: !183)
!187 = !DILocation(line: 0, scope: !183)
!188 = !DILocation(line: 133, column: 9, scope: !179)
!189 = !DILocation(line: 134, column: 21, scope: !190)
!190 = distinct !DILexicalBlock(scope: !183, file: !51, line: 133, column: 67)
!191 = !DILocation(line: 134, column: 13, scope: !190)
!192 = !DILocation(line: 135, column: 9, scope: !190)
!193 = !DILocation(line: 133, column: 63, scope: !183)
!194 = !DILocation(line: 133, column: 9, scope: !183)
!195 = distinct !{!195, !188, !196, !112}
!196 = !DILocation(line: 135, column: 9, scope: !179)
!197 = !DILocation(line: 136, column: 5, scope: !159)
!198 = !DILocation(line: 125, column: 59, scope: !151)
!199 = !DILocation(line: 125, column: 5, scope: !151)
!200 = distinct !{!200, !156, !201, !112}
!201 = !DILocation(line: 136, column: 5, scope: !147)
!202 = !DILocation(line: 137, column: 5, scope: !137)
!203 = distinct !DISubprogram(name: "arraylock_init", scope: !23, file: !23, line: 60, type: !204, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!204 = !DISubroutineType(types: !205)
!205 = !{null, !206, !41, !207}
!206 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!207 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !43)
!208 = !DILocalVariable(name: "lock", arg: 1, scope: !203, file: !23, line: 60, type: !206)
!209 = !DILocation(line: 60, column: 29, scope: !203)
!210 = !DILocalVariable(name: "flags", arg: 2, scope: !203, file: !23, line: 60, type: !41)
!211 = !DILocation(line: 60, column: 53, scope: !203)
!212 = !DILocalVariable(name: "len", arg: 3, scope: !203, file: !23, line: 60, type: !207)
!213 = !DILocation(line: 60, column: 76, scope: !203)
!214 = !DILocalVariable(name: "i", scope: !203, file: !23, line: 62, type: !43)
!215 = !DILocation(line: 62, column: 15, scope: !203)
!216 = !DILocation(line: 64, column: 20, scope: !203)
!217 = !DILocation(line: 64, column: 26, scope: !203)
!218 = !DILocation(line: 64, column: 5, scope: !203)
!219 = !DILocation(line: 65, column: 5, scope: !220)
!220 = distinct !DILexicalBlock(scope: !221, file: !23, line: 65, column: 5)
!221 = distinct !DILexicalBlock(scope: !203, file: !23, line: 65, column: 5)
!222 = !DILocation(line: 65, column: 5, scope: !221)
!223 = !DILocation(line: 66, column: 5, scope: !224)
!224 = distinct !DILexicalBlock(scope: !225, file: !23, line: 66, column: 5)
!225 = distinct !DILexicalBlock(scope: !203, file: !23, line: 66, column: 5)
!226 = !DILocation(line: 66, column: 5, scope: !225)
!227 = !DILocation(line: 67, column: 23, scope: !203)
!228 = !DILocation(line: 67, column: 5, scope: !203)
!229 = !DILocation(line: 67, column: 11, scope: !203)
!230 = !DILocation(line: 67, column: 21, scope: !203)
!231 = !DILocation(line: 68, column: 23, scope: !203)
!232 = !DILocation(line: 68, column: 5, scope: !203)
!233 = !DILocation(line: 68, column: 11, scope: !203)
!234 = !DILocation(line: 68, column: 21, scope: !203)
!235 = !DILocation(line: 71, column: 20, scope: !203)
!236 = !DILocation(line: 71, column: 26, scope: !203)
!237 = !DILocation(line: 71, column: 35, scope: !203)
!238 = !DILocation(line: 71, column: 5, scope: !203)
!239 = !DILocation(line: 74, column: 12, scope: !240)
!240 = distinct !DILexicalBlock(scope: !203, file: !23, line: 74, column: 5)
!241 = !DILocation(line: 74, column: 10, scope: !240)
!242 = !DILocation(line: 74, column: 17, scope: !243)
!243 = distinct !DILexicalBlock(scope: !240, file: !23, line: 74, column: 5)
!244 = !DILocation(line: 74, column: 21, scope: !243)
!245 = !DILocation(line: 74, column: 27, scope: !243)
!246 = !DILocation(line: 74, column: 19, scope: !243)
!247 = !DILocation(line: 74, column: 5, scope: !240)
!248 = !DILocation(line: 75, column: 24, scope: !249)
!249 = distinct !DILexicalBlock(scope: !243, file: !23, line: 74, column: 43)
!250 = !DILocation(line: 75, column: 30, scope: !249)
!251 = !DILocation(line: 75, column: 36, scope: !249)
!252 = !DILocation(line: 75, column: 39, scope: !249)
!253 = !DILocation(line: 75, column: 9, scope: !249)
!254 = !DILocation(line: 76, column: 5, scope: !249)
!255 = !DILocation(line: 74, column: 39, scope: !243)
!256 = !DILocation(line: 74, column: 5, scope: !243)
!257 = distinct !{!257, !247, !258, !112}
!258 = !DILocation(line: 76, column: 5, scope: !240)
!259 = !DILocation(line: 77, column: 1, scope: !203)
!260 = distinct !DISubprogram(name: "acquire", scope: !20, file: !20, line: 27, type: !261, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!261 = !DISubroutineType(types: !262)
!262 = !{null, !43}
!263 = !DILocalVariable(name: "tid", arg: 1, scope: !260, file: !20, line: 27, type: !43)
!264 = !DILocation(line: 27, column: 19, scope: !260)
!265 = !DILocation(line: 29, column: 5, scope: !260)
!266 = !DILocation(line: 29, column: 5, scope: !267)
!267 = distinct !DILexicalBlock(scope: !260, file: !20, line: 29, column: 5)
!268 = !DILocation(line: 29, column: 5, scope: !269)
!269 = distinct !DILexicalBlock(scope: !267, file: !20, line: 29, column: 5)
!270 = !DILocation(line: 29, column: 5, scope: !271)
!271 = distinct !DILexicalBlock(scope: !269, file: !20, line: 29, column: 5)
!272 = !DILocation(line: 30, column: 5, scope: !260)
!273 = !DILocation(line: 31, column: 1, scope: !260)
!274 = distinct !DISubprogram(name: "arraylock_acquire", scope: !23, file: !23, line: 89, type: !275, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!275 = !DISubroutineType(types: !276)
!276 = !{null, !206, !277}
!277 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!278 = !DILocalVariable(name: "lock", arg: 1, scope: !274, file: !23, line: 89, type: !206)
!279 = !DILocation(line: 89, column: 32, scope: !274)
!280 = !DILocalVariable(name: "slot", arg: 2, scope: !274, file: !23, line: 89, type: !277)
!281 = !DILocation(line: 89, column: 49, scope: !274)
!282 = !DILocalVariable(name: "tail", scope: !274, file: !23, line: 96, type: !43)
!283 = !DILocation(line: 96, column: 15, scope: !274)
!284 = !DILocation(line: 96, column: 40, scope: !274)
!285 = !DILocation(line: 96, column: 46, scope: !274)
!286 = !DILocation(line: 96, column: 22, scope: !274)
!287 = !DILocation(line: 97, column: 22, scope: !274)
!288 = !DILocation(line: 97, column: 29, scope: !274)
!289 = !DILocation(line: 97, column: 35, scope: !274)
!290 = !DILocation(line: 97, column: 27, scope: !274)
!291 = !DILocation(line: 97, column: 6, scope: !274)
!292 = !DILocation(line: 97, column: 20, scope: !274)
!293 = !DILocation(line: 100, column: 5, scope: !274)
!294 = distinct !{!294, !293, !295, !112}
!295 = !DILocation(line: 100, column: 70, scope: !274)
!296 = !DILocation(line: 101, column: 1, scope: !274)
!297 = distinct !DISubprogram(name: "release", scope: !20, file: !20, line: 34, type: !261, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!298 = !DILocalVariable(name: "tid", arg: 1, scope: !297, file: !20, line: 34, type: !43)
!299 = !DILocation(line: 34, column: 19, scope: !297)
!300 = !DILocation(line: 36, column: 5, scope: !297)
!301 = !DILocation(line: 36, column: 5, scope: !302)
!302 = distinct !DILexicalBlock(scope: !297, file: !20, line: 36, column: 5)
!303 = !DILocation(line: 36, column: 5, scope: !304)
!304 = distinct !DILexicalBlock(scope: !302, file: !20, line: 36, column: 5)
!305 = !DILocation(line: 36, column: 5, scope: !306)
!306 = distinct !DILexicalBlock(scope: !304, file: !20, line: 36, column: 5)
!307 = !DILocation(line: 37, column: 30, scope: !297)
!308 = !DILocation(line: 37, column: 5, scope: !297)
!309 = !DILocation(line: 38, column: 1, scope: !297)
!310 = distinct !DISubprogram(name: "arraylock_release", scope: !23, file: !23, line: 109, type: !311, scopeLine: 110, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!311 = !DISubroutineType(types: !312)
!312 = !{null, !206, !43}
!313 = !DILocalVariable(name: "lock", arg: 1, scope: !310, file: !23, line: 109, type: !206)
!314 = !DILocation(line: 109, column: 32, scope: !310)
!315 = !DILocalVariable(name: "slot", arg: 2, scope: !310, file: !23, line: 109, type: !43)
!316 = !DILocation(line: 109, column: 48, scope: !310)
!317 = !DILocalVariable(name: "next", scope: !310, file: !23, line: 111, type: !43)
!318 = !DILocation(line: 111, column: 15, scope: !310)
!319 = !DILocation(line: 113, column: 25, scope: !310)
!320 = !DILocation(line: 113, column: 31, scope: !310)
!321 = !DILocation(line: 113, column: 37, scope: !310)
!322 = !DILocation(line: 113, column: 43, scope: !310)
!323 = !DILocation(line: 113, column: 5, scope: !310)
!324 = !DILocation(line: 115, column: 13, scope: !310)
!325 = !DILocation(line: 115, column: 18, scope: !310)
!326 = !DILocation(line: 115, column: 25, scope: !310)
!327 = !DILocation(line: 115, column: 31, scope: !310)
!328 = !DILocation(line: 115, column: 23, scope: !310)
!329 = !DILocation(line: 115, column: 10, scope: !310)
!330 = !DILocation(line: 117, column: 25, scope: !310)
!331 = !DILocation(line: 117, column: 31, scope: !310)
!332 = !DILocation(line: 117, column: 37, scope: !310)
!333 = !DILocation(line: 117, column: 43, scope: !310)
!334 = !DILocation(line: 117, column: 5, scope: !310)
!335 = !DILocation(line: 118, column: 1, scope: !310)
!336 = distinct !DISubprogram(name: "vatomic8_init", scope: !337, file: !337, line: 4167, type: !338, scopeLine: 4168, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!337 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!338 = !DISubroutineType(types: !339)
!339 = !{null, !340, !11}
!340 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!341 = !DILocalVariable(name: "a", arg: 1, scope: !336, file: !337, line: 4167, type: !340)
!342 = !DILocation(line: 4167, column: 27, scope: !336)
!343 = !DILocalVariable(name: "v", arg: 2, scope: !336, file: !337, line: 4167, type: !11)
!344 = !DILocation(line: 4167, column: 39, scope: !336)
!345 = !DILocation(line: 4169, column: 20, scope: !336)
!346 = !DILocation(line: 4169, column: 23, scope: !336)
!347 = !DILocation(line: 4169, column: 5, scope: !336)
!348 = !DILocation(line: 4170, column: 1, scope: !336)
!349 = distinct !DISubprogram(name: "vatomic8_write", scope: !350, file: !350, line: 336, type: !338, scopeLine: 337, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!350 = !DIFile(filename: "atomics/include/vsync/atomic/internal/builtins.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "388436b7ba51a9f45a141a76df6f4faa")
!351 = !DILocalVariable(name: "a", arg: 1, scope: !349, file: !350, line: 336, type: !340)
!352 = !DILocation(line: 336, column: 28, scope: !349)
!353 = !DILocalVariable(name: "v", arg: 2, scope: !349, file: !350, line: 336, type: !11)
!354 = !DILocation(line: 336, column: 40, scope: !349)
!355 = !DILocation(line: 338, column: 5, scope: !349)
!356 = !{i64 2148083327}
!357 = !DILocation(line: 339, column: 23, scope: !349)
!358 = !DILocation(line: 339, column: 26, scope: !349)
!359 = !DILocation(line: 339, column: 30, scope: !349)
!360 = !DILocation(line: 339, column: 5, scope: !349)
!361 = !DILocation(line: 340, column: 5, scope: !349)
!362 = !{i64 2148083367}
!363 = !DILocation(line: 341, column: 1, scope: !349)
!364 = distinct !DISubprogram(name: "vatomic8_get_inc", scope: !337, file: !337, line: 2395, type: !365, scopeLine: 2396, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!365 = !DISubroutineType(types: !366)
!366 = !{!11, !340}
!367 = !DILocalVariable(name: "a", arg: 1, scope: !364, file: !337, line: 2395, type: !340)
!368 = !DILocation(line: 2395, column: 30, scope: !364)
!369 = !DILocation(line: 2397, column: 29, scope: !364)
!370 = !DILocation(line: 2397, column: 12, scope: !364)
!371 = !DILocation(line: 2397, column: 5, scope: !364)
!372 = distinct !DISubprogram(name: "vatomic8_read_acq", scope: !350, file: !350, line: 94, type: !373, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!373 = !DISubroutineType(types: !374)
!374 = !{!11, !375}
!375 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !376, size: 64)
!376 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !27)
!377 = !DILocalVariable(name: "a", arg: 1, scope: !372, file: !350, line: 94, type: !375)
!378 = !DILocation(line: 94, column: 37, scope: !372)
!379 = !DILocation(line: 96, column: 5, scope: !372)
!380 = !{i64 2148082703}
!381 = !DILocalVariable(name: "tmp", scope: !372, file: !350, line: 97, type: !11)
!382 = !DILocation(line: 97, column: 14, scope: !372)
!383 = !DILocation(line: 97, column: 47, scope: !372)
!384 = !DILocation(line: 97, column: 50, scope: !372)
!385 = !DILocation(line: 97, column: 30, scope: !372)
!386 = !DILocation(line: 98, column: 5, scope: !372)
!387 = !{i64 2148082743}
!388 = !DILocation(line: 99, column: 12, scope: !372)
!389 = !DILocation(line: 99, column: 5, scope: !372)
!390 = distinct !DISubprogram(name: "vatomic8_get_add", scope: !350, file: !350, line: 2238, type: !391, scopeLine: 2239, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!391 = !DISubroutineType(types: !392)
!392 = !{!11, !340, !11}
!393 = !DILocalVariable(name: "a", arg: 1, scope: !390, file: !350, line: 2238, type: !340)
!394 = !DILocation(line: 2238, column: 30, scope: !390)
!395 = !DILocalVariable(name: "v", arg: 2, scope: !390, file: !350, line: 2238, type: !11)
!396 = !DILocation(line: 2238, column: 42, scope: !390)
!397 = !DILocation(line: 2240, column: 5, scope: !390)
!398 = !{i64 2148088733}
!399 = !DILocalVariable(name: "tmp", scope: !390, file: !350, line: 2241, type: !11)
!400 = !DILocation(line: 2241, column: 14, scope: !390)
!401 = !DILocation(line: 2241, column: 50, scope: !390)
!402 = !DILocation(line: 2241, column: 53, scope: !390)
!403 = !DILocation(line: 2241, column: 57, scope: !390)
!404 = !DILocation(line: 2241, column: 30, scope: !390)
!405 = !DILocation(line: 2242, column: 5, scope: !390)
!406 = !{i64 2148088773}
!407 = !DILocation(line: 2243, column: 12, scope: !390)
!408 = !DILocation(line: 2243, column: 5, scope: !390)
!409 = distinct !DISubprogram(name: "vatomic8_write_rlx", scope: !350, file: !350, line: 362, type: !338, scopeLine: 363, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!410 = !DILocalVariable(name: "a", arg: 1, scope: !409, file: !350, line: 362, type: !340)
!411 = !DILocation(line: 362, column: 32, scope: !409)
!412 = !DILocalVariable(name: "v", arg: 2, scope: !409, file: !350, line: 362, type: !11)
!413 = !DILocation(line: 362, column: 44, scope: !409)
!414 = !DILocation(line: 364, column: 5, scope: !409)
!415 = !{i64 2148083483}
!416 = !DILocation(line: 365, column: 23, scope: !409)
!417 = !DILocation(line: 365, column: 26, scope: !409)
!418 = !DILocation(line: 365, column: 30, scope: !409)
!419 = !DILocation(line: 365, column: 5, scope: !409)
!420 = !DILocation(line: 366, column: 5, scope: !409)
!421 = !{i64 2148083523}
!422 = !DILocation(line: 367, column: 1, scope: !409)
!423 = distinct !DISubprogram(name: "vatomic8_write_rel", scope: !350, file: !350, line: 349, type: !338, scopeLine: 350, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!424 = !DILocalVariable(name: "a", arg: 1, scope: !423, file: !350, line: 349, type: !340)
!425 = !DILocation(line: 349, column: 32, scope: !423)
!426 = !DILocalVariable(name: "v", arg: 2, scope: !423, file: !350, line: 349, type: !11)
!427 = !DILocation(line: 349, column: 44, scope: !423)
!428 = !DILocation(line: 351, column: 5, scope: !423)
!429 = !{i64 2148083405}
!430 = !DILocation(line: 352, column: 23, scope: !423)
!431 = !DILocation(line: 352, column: 26, scope: !423)
!432 = !DILocation(line: 352, column: 30, scope: !423)
!433 = !DILocation(line: 352, column: 5, scope: !423)
!434 = !DILocation(line: 353, column: 5, scope: !423)
!435 = !{i64 2148083445}
!436 = !DILocation(line: 354, column: 1, scope: !423)
