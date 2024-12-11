; ModuleID = '/home/stefano/huawei/libvsync/spinlock/test/hemlock.c'
source_filename = "/home/stefano/huawei/libvsync/spinlock/test/hemlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.hemlock_s = type { %struct.vatomicptr_s }
%struct.vatomicptr_s = type { i8* }
%struct.hem_node_s = type { %struct.vatomicptr_s }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !35
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [68 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 1 + 0)\00", align 1
@lock = dso_local global %struct.hemlock_s zeroinitializer, align 8, !dbg !23
@nodes = dso_local global [3 x %struct.hem_node_s] zeroinitializer, align 16, !dbg !30

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !52 {
  ret void, !dbg !56
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !57 {
  ret void, !dbg !58
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !59 {
  ret void, !dbg !60
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !61 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !62
  %2 = add i32 %1, 1, !dbg !62
  store i32 %2, i32* @g_cs_x, align 4, !dbg !62
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !63
  %4 = add i32 %3, 1, !dbg !63
  store i32 %4, i32* @g_cs_y, align 4, !dbg !63
  ret void, !dbg !64
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !65 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !66
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !66
  %3 = icmp eq i32 %1, %2, !dbg !66
  br i1 %3, label %4, label %5, !dbg !69

4:                                                ; preds = %0
  br label %6, !dbg !69

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 112, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !66
  unreachable, !dbg !66

6:                                                ; preds = %4
  %7 = load i32, i32* @g_cs_x, align 4, !dbg !70
  %8 = icmp eq i32 %7, 4, !dbg !70
  br i1 %8, label %9, label %10, !dbg !73

9:                                                ; preds = %6
  br label %11, !dbg !73

10:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 113, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !70
  unreachable, !dbg !70

11:                                               ; preds = %9
  ret void, !dbg !74
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !75 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i64]* %2, metadata !79, metadata !DIExpression()), !dbg !83
  call void @init(), !dbg !84
  call void @llvm.dbg.declare(metadata i64* %3, metadata !85, metadata !DIExpression()), !dbg !87
  store i64 0, i64* %3, align 8, !dbg !87
  br label %5, !dbg !88

5:                                                ; preds = %14, %0
  %6 = load i64, i64* %3, align 8, !dbg !89
  %7 = icmp ult i64 %6, 3, !dbg !91
  br i1 %7, label %8, label %17, !dbg !92

8:                                                ; preds = %5
  %9 = load i64, i64* %3, align 8, !dbg !93
  %10 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %9, !dbg !95
  %11 = load i64, i64* %3, align 8, !dbg !96
  %12 = inttoptr i64 %11 to i8*, !dbg !97
  %13 = call i32 @pthread_create(i64* noundef %10, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef %12) #6, !dbg !98
  br label %14, !dbg !99

14:                                               ; preds = %8
  %15 = load i64, i64* %3, align 8, !dbg !100
  %16 = add i64 %15, 1, !dbg !100
  store i64 %16, i64* %3, align 8, !dbg !100
  br label %5, !dbg !101, !llvm.loop !102

17:                                               ; preds = %5
  call void @post(), !dbg !105
  call void @llvm.dbg.declare(metadata i64* %4, metadata !106, metadata !DIExpression()), !dbg !108
  store i64 0, i64* %4, align 8, !dbg !108
  br label %18, !dbg !109

18:                                               ; preds = %26, %17
  %19 = load i64, i64* %4, align 8, !dbg !110
  %20 = icmp ult i64 %19, 3, !dbg !112
  br i1 %20, label %21, label %29, !dbg !113

21:                                               ; preds = %18
  %22 = load i64, i64* %4, align 8, !dbg !114
  %23 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %22, !dbg !116
  %24 = load i64, i64* %23, align 8, !dbg !116
  %25 = call i32 @pthread_join(i64 noundef %24, i8** noundef null), !dbg !117
  br label %26, !dbg !118

26:                                               ; preds = %21
  %27 = load i64, i64* %4, align 8, !dbg !119
  %28 = add i64 %27, 1, !dbg !119
  store i64 %28, i64* %4, align 8, !dbg !119
  br label %18, !dbg !120, !llvm.loop !121

29:                                               ; preds = %18
  call void @check(), !dbg !123
  call void @fini(), !dbg !124
  ret i32 0, !dbg !125
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !126 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !129, metadata !DIExpression()), !dbg !130
  call void @llvm.dbg.declare(metadata i32* %3, metadata !131, metadata !DIExpression()), !dbg !132
  %7 = load i8*, i8** %2, align 8, !dbg !133
  %8 = ptrtoint i8* %7 to i64, !dbg !134
  %9 = trunc i64 %8 to i32, !dbg !134
  store i32 %9, i32* %3, align 4, !dbg !132
  call void @llvm.dbg.declare(metadata i32* %4, metadata !135, metadata !DIExpression()), !dbg !137
  store i32 0, i32* %4, align 4, !dbg !137
  br label %10, !dbg !138

10:                                               ; preds = %65, %1
  %11 = load i32, i32* %4, align 4, !dbg !139
  %12 = icmp eq i32 %11, 0, !dbg !141
  br i1 %12, label %22, label %13, !dbg !142

13:                                               ; preds = %10
  %14 = load i32, i32* %4, align 4, !dbg !143
  %15 = icmp eq i32 %14, 1, !dbg !143
  br i1 %15, label %16, label %20, !dbg !143

16:                                               ; preds = %13
  %17 = load i32, i32* %3, align 4, !dbg !143
  %18 = add i32 %17, 1, !dbg !143
  %19 = icmp ult i32 %18, 2, !dbg !143
  br label %20

20:                                               ; preds = %16, %13
  %21 = phi i1 [ false, %13 ], [ %19, %16 ], !dbg !144
  br label %22, !dbg !142

22:                                               ; preds = %20, %10
  %23 = phi i1 [ true, %10 ], [ %21, %20 ]
  br i1 %23, label %24, label %68, !dbg !145

24:                                               ; preds = %22
  call void @llvm.dbg.declare(metadata i32* %5, metadata !146, metadata !DIExpression()), !dbg !149
  store i32 0, i32* %5, align 4, !dbg !149
  br label %25, !dbg !150

25:                                               ; preds = %41, %24
  %26 = load i32, i32* %5, align 4, !dbg !151
  %27 = icmp eq i32 %26, 0, !dbg !153
  br i1 %27, label %37, label %28, !dbg !154

28:                                               ; preds = %25
  %29 = load i32, i32* %5, align 4, !dbg !155
  %30 = icmp eq i32 %29, 1, !dbg !155
  br i1 %30, label %31, label %35, !dbg !155

31:                                               ; preds = %28
  %32 = load i32, i32* %3, align 4, !dbg !155
  %33 = add i32 %32, 1, !dbg !155
  %34 = icmp ult i32 %33, 1, !dbg !155
  br label %35

35:                                               ; preds = %31, %28
  %36 = phi i1 [ false, %28 ], [ %34, %31 ], !dbg !156
  br label %37, !dbg !154

37:                                               ; preds = %35, %25
  %38 = phi i1 [ true, %25 ], [ %36, %35 ]
  br i1 %38, label %39, label %44, !dbg !157

39:                                               ; preds = %37
  %40 = load i32, i32* %3, align 4, !dbg !158
  call void @acquire(i32 noundef %40), !dbg !160
  call void @cs(), !dbg !161
  br label %41, !dbg !162

41:                                               ; preds = %39
  %42 = load i32, i32* %5, align 4, !dbg !163
  %43 = add nsw i32 %42, 1, !dbg !163
  store i32 %43, i32* %5, align 4, !dbg !163
  br label %25, !dbg !164, !llvm.loop !165

44:                                               ; preds = %37
  call void @llvm.dbg.declare(metadata i32* %6, metadata !167, metadata !DIExpression()), !dbg !169
  store i32 0, i32* %6, align 4, !dbg !169
  br label %45, !dbg !170

45:                                               ; preds = %61, %44
  %46 = load i32, i32* %6, align 4, !dbg !171
  %47 = icmp eq i32 %46, 0, !dbg !173
  br i1 %47, label %57, label %48, !dbg !174

48:                                               ; preds = %45
  %49 = load i32, i32* %6, align 4, !dbg !175
  %50 = icmp eq i32 %49, 1, !dbg !175
  br i1 %50, label %51, label %55, !dbg !175

51:                                               ; preds = %48
  %52 = load i32, i32* %3, align 4, !dbg !175
  %53 = add i32 %52, 1, !dbg !175
  %54 = icmp ult i32 %53, 1, !dbg !175
  br label %55

55:                                               ; preds = %51, %48
  %56 = phi i1 [ false, %48 ], [ %54, %51 ], !dbg !176
  br label %57, !dbg !174

57:                                               ; preds = %55, %45
  %58 = phi i1 [ true, %45 ], [ %56, %55 ]
  br i1 %58, label %59, label %64, !dbg !177

59:                                               ; preds = %57
  %60 = load i32, i32* %3, align 4, !dbg !178
  call void @release(i32 noundef %60), !dbg !180
  br label %61, !dbg !181

61:                                               ; preds = %59
  %62 = load i32, i32* %6, align 4, !dbg !182
  %63 = add nsw i32 %62, 1, !dbg !182
  store i32 %63, i32* %6, align 4, !dbg !182
  br label %45, !dbg !183, !llvm.loop !184

64:                                               ; preds = %57
  br label %65, !dbg !186

65:                                               ; preds = %64
  %66 = load i32, i32* %4, align 4, !dbg !187
  %67 = add nsw i32 %66, 1, !dbg !187
  store i32 %67, i32* %4, align 4, !dbg !187
  br label %10, !dbg !188, !llvm.loop !189

68:                                               ; preds = %22
  ret i8* null, !dbg !191
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !192 {
  %2 = alloca i32, align 4
  %3 = alloca i8, align 1
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !195, metadata !DIExpression()), !dbg !196
  %4 = load i32, i32* %2, align 4, !dbg !197
  %5 = icmp eq i32 %4, 2, !dbg !199
  br i1 %5, label %6, label %15, !dbg !200

6:                                                ; preds = %1
  call void @llvm.dbg.declare(metadata i8* %3, metadata !201, metadata !DIExpression()), !dbg !205
  %7 = load i32, i32* %2, align 4, !dbg !206
  %8 = zext i32 %7 to i64, !dbg !207
  %9 = getelementptr inbounds [3 x %struct.hem_node_s], [3 x %struct.hem_node_s]* @nodes, i64 0, i64 %8, !dbg !207
  %10 = call i32 @hemlock_tryacquire(%struct.hemlock_s* noundef @lock, %struct.hem_node_s* noundef %9), !dbg !208
  %11 = icmp ne i32 %10, 0, !dbg !208
  %12 = zext i1 %11 to i8, !dbg !205
  store i8 %12, i8* %3, align 1, !dbg !205
  %13 = load i8, i8* %3, align 1, !dbg !209
  %14 = trunc i8 %13 to i1, !dbg !209
  call void @verification_assume(i1 noundef zeroext %14), !dbg !210
  br label %19, !dbg !211

15:                                               ; preds = %1
  %16 = load i32, i32* %2, align 4, !dbg !212
  %17 = zext i32 %16 to i64, !dbg !214
  %18 = getelementptr inbounds [3 x %struct.hem_node_s], [3 x %struct.hem_node_s]* @nodes, i64 0, i64 %17, !dbg !214
  call void @hemlock_acquire(%struct.hemlock_s* noundef @lock, %struct.hem_node_s* noundef %18), !dbg !215
  br label %19

19:                                               ; preds = %15, %6
  ret void, !dbg !216
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @hemlock_tryacquire(%struct.hemlock_s* noundef %0, %struct.hem_node_s* noundef %1) #0 !dbg !217 {
  %3 = alloca %struct.hemlock_s*, align 8
  %4 = alloca %struct.hem_node_s*, align 8
  %5 = alloca %struct.hem_node_s*, align 8
  store %struct.hemlock_s* %0, %struct.hemlock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.hemlock_s** %3, metadata !221, metadata !DIExpression()), !dbg !222
  store %struct.hem_node_s* %1, %struct.hem_node_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.hem_node_s** %4, metadata !223, metadata !DIExpression()), !dbg !224
  call void @llvm.dbg.declare(metadata %struct.hem_node_s** %5, metadata !225, metadata !DIExpression()), !dbg !226
  store %struct.hem_node_s* null, %struct.hem_node_s** %5, align 8, !dbg !226
  %6 = load %struct.hem_node_s*, %struct.hem_node_s** %4, align 8, !dbg !227
  %7 = getelementptr inbounds %struct.hem_node_s, %struct.hem_node_s* %6, i32 0, i32 0, !dbg !228
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %7, i8* noundef null), !dbg !229
  %8 = load %struct.hemlock_s*, %struct.hemlock_s** %3, align 8, !dbg !230
  %9 = getelementptr inbounds %struct.hemlock_s, %struct.hemlock_s* %8, i32 0, i32 0, !dbg !231
  %10 = load %struct.hem_node_s*, %struct.hem_node_s** %4, align 8, !dbg !232
  %11 = bitcast %struct.hem_node_s* %10 to i8*, !dbg !232
  %12 = call i8* @vatomicptr_cmpxchg_acq(%struct.vatomicptr_s* noundef %9, i8* noundef null, i8* noundef %11), !dbg !233
  %13 = bitcast i8* %12 to %struct.hem_node_s*, !dbg !234
  store %struct.hem_node_s* %13, %struct.hem_node_s** %5, align 8, !dbg !235
  %14 = load %struct.hem_node_s*, %struct.hem_node_s** %5, align 8, !dbg !236
  %15 = icmp eq %struct.hem_node_s* %14, null, !dbg !237
  %16 = zext i1 %15 to i32, !dbg !237
  ret i32 %16, !dbg !238
}

; Function Attrs: noinline nounwind uwtable
define internal void @verification_assume(i1 noundef zeroext %0) #0 !dbg !239 {
  %2 = alloca i8, align 1
  %3 = zext i1 %0 to i8
  store i8 %3, i8* %2, align 1
  call void @llvm.dbg.declare(metadata i8* %2, metadata !243, metadata !DIExpression()), !dbg !244
  %4 = load i8, i8* %2, align 1, !dbg !245
  %5 = trunc i8 %4 to i1, !dbg !245
  %6 = zext i1 %5 to i32, !dbg !245
  %7 = call i32 (i32, ...) bitcast (i32 (...)* @__VERIFIER_assume to i32 (i32, ...)*)(i32 noundef %6), !dbg !246
  ret void, !dbg !247
}

; Function Attrs: noinline nounwind uwtable
define internal void @hemlock_acquire(%struct.hemlock_s* noundef %0, %struct.hem_node_s* noundef %1) #0 !dbg !248 {
  %3 = alloca %struct.hemlock_s*, align 8
  %4 = alloca %struct.hem_node_s*, align 8
  %5 = alloca %struct.hem_node_s*, align 8
  store %struct.hemlock_s* %0, %struct.hemlock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.hemlock_s** %3, metadata !251, metadata !DIExpression()), !dbg !252
  store %struct.hem_node_s* %1, %struct.hem_node_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.hem_node_s** %4, metadata !253, metadata !DIExpression()), !dbg !254
  call void @llvm.dbg.declare(metadata %struct.hem_node_s** %5, metadata !255, metadata !DIExpression()), !dbg !256
  store %struct.hem_node_s* null, %struct.hem_node_s** %5, align 8, !dbg !256
  %6 = load %struct.hem_node_s*, %struct.hem_node_s** %4, align 8, !dbg !257
  %7 = getelementptr inbounds %struct.hem_node_s, %struct.hem_node_s* %6, i32 0, i32 0, !dbg !258
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %7, i8* noundef null), !dbg !259
  %8 = load %struct.hemlock_s*, %struct.hemlock_s** %3, align 8, !dbg !260
  %9 = getelementptr inbounds %struct.hemlock_s, %struct.hemlock_s* %8, i32 0, i32 0, !dbg !261
  %10 = load %struct.hem_node_s*, %struct.hem_node_s** %4, align 8, !dbg !262
  %11 = bitcast %struct.hem_node_s* %10 to i8*, !dbg !262
  %12 = call i8* @vatomicptr_xchg(%struct.vatomicptr_s* noundef %9, i8* noundef %11), !dbg !263
  %13 = bitcast i8* %12 to %struct.hem_node_s*, !dbg !264
  store %struct.hem_node_s* %13, %struct.hem_node_s** %5, align 8, !dbg !265
  %14 = load %struct.hem_node_s*, %struct.hem_node_s** %5, align 8, !dbg !266
  %15 = icmp eq %struct.hem_node_s* %14, null, !dbg !268
  br i1 %15, label %16, label %17, !dbg !269

16:                                               ; preds = %2
  br label %25, !dbg !270

17:                                               ; preds = %2
  %18 = load %struct.hem_node_s*, %struct.hem_node_s** %5, align 8, !dbg !272
  %19 = getelementptr inbounds %struct.hem_node_s, %struct.hem_node_s* %18, i32 0, i32 0, !dbg !273
  %20 = load %struct.hemlock_s*, %struct.hemlock_s** %3, align 8, !dbg !274
  %21 = bitcast %struct.hemlock_s* %20 to i8*, !dbg !274
  %22 = call i8* @vatomicptr_await_eq_acq(%struct.vatomicptr_s* noundef %19, i8* noundef %21), !dbg !275
  %23 = load %struct.hem_node_s*, %struct.hem_node_s** %5, align 8, !dbg !276
  %24 = getelementptr inbounds %struct.hem_node_s, %struct.hem_node_s* %23, i32 0, i32 0, !dbg !277
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %24, i8* noundef null), !dbg !278
  br label %25, !dbg !279

25:                                               ; preds = %17, %16
  ret void, !dbg !279
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !280 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !281, metadata !DIExpression()), !dbg !282
  %3 = load i32, i32* %2, align 4, !dbg !283
  %4 = zext i32 %3 to i64, !dbg !284
  %5 = getelementptr inbounds [3 x %struct.hem_node_s], [3 x %struct.hem_node_s]* @nodes, i64 0, i64 %4, !dbg !284
  call void @hemlock_release(%struct.hemlock_s* noundef @lock, %struct.hem_node_s* noundef %5), !dbg !285
  ret void, !dbg !286
}

; Function Attrs: noinline nounwind uwtable
define internal void @hemlock_release(%struct.hemlock_s* noundef %0, %struct.hem_node_s* noundef %1) #0 !dbg !287 {
  %3 = alloca %struct.hemlock_s*, align 8
  %4 = alloca %struct.hem_node_s*, align 8
  store %struct.hemlock_s* %0, %struct.hemlock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.hemlock_s** %3, metadata !288, metadata !DIExpression()), !dbg !289
  store %struct.hem_node_s* %1, %struct.hem_node_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.hem_node_s** %4, metadata !290, metadata !DIExpression()), !dbg !291
  %5 = load %struct.hemlock_s*, %struct.hemlock_s** %3, align 8, !dbg !292
  %6 = getelementptr inbounds %struct.hemlock_s, %struct.hemlock_s* %5, i32 0, i32 0, !dbg !294
  %7 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %6), !dbg !295
  %8 = load %struct.hem_node_s*, %struct.hem_node_s** %4, align 8, !dbg !296
  %9 = bitcast %struct.hem_node_s* %8 to i8*, !dbg !296
  %10 = icmp eq i8* %7, %9, !dbg !297
  br i1 %10, label %11, label %21, !dbg !298

11:                                               ; preds = %2
  %12 = load %struct.hemlock_s*, %struct.hemlock_s** %3, align 8, !dbg !299
  %13 = getelementptr inbounds %struct.hemlock_s, %struct.hemlock_s* %12, i32 0, i32 0, !dbg !300
  %14 = load %struct.hem_node_s*, %struct.hem_node_s** %4, align 8, !dbg !301
  %15 = bitcast %struct.hem_node_s* %14 to i8*, !dbg !301
  %16 = call i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %13, i8* noundef %15, i8* noundef null), !dbg !302
  %17 = load %struct.hem_node_s*, %struct.hem_node_s** %4, align 8, !dbg !303
  %18 = bitcast %struct.hem_node_s* %17 to i8*, !dbg !303
  %19 = icmp eq i8* %16, %18, !dbg !304
  br i1 %19, label %20, label %21, !dbg !305

20:                                               ; preds = %11
  br label %29, !dbg !306

21:                                               ; preds = %11, %2
  %22 = load %struct.hem_node_s*, %struct.hem_node_s** %4, align 8, !dbg !308
  %23 = getelementptr inbounds %struct.hem_node_s, %struct.hem_node_s* %22, i32 0, i32 0, !dbg !309
  %24 = load %struct.hemlock_s*, %struct.hemlock_s** %3, align 8, !dbg !310
  %25 = bitcast %struct.hemlock_s* %24 to i8*, !dbg !310
  call void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %23, i8* noundef %25), !dbg !311
  %26 = load %struct.hem_node_s*, %struct.hem_node_s** %4, align 8, !dbg !312
  %27 = getelementptr inbounds %struct.hem_node_s, %struct.hem_node_s* %26, i32 0, i32 0, !dbg !313
  %28 = call i8* @vatomicptr_await_eq_rlx(%struct.vatomicptr_s* noundef %27, i8* noundef null), !dbg !314
  br label %29, !dbg !315

29:                                               ; preds = %21, %20
  ret void, !dbg !315
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !316 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !321, metadata !DIExpression()), !dbg !322
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !323, metadata !DIExpression()), !dbg !324
  %5 = load i8*, i8** %4, align 8, !dbg !325
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !326
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !327
  %8 = load i8*, i8** %7, align 8, !dbg !327
  call void asm sideeffect "str ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !328, !srcloc !329
  ret void, !dbg !330
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_cmpxchg_acq(%struct.vatomicptr_s* noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !331 {
  %4 = alloca %struct.vatomicptr_s*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i32, align 4
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %4, metadata !335, metadata !DIExpression()), !dbg !336
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !337, metadata !DIExpression()), !dbg !338
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !339, metadata !DIExpression()), !dbg !340
  call void @llvm.dbg.declare(metadata i8** %7, metadata !341, metadata !DIExpression()), !dbg !342
  call void @llvm.dbg.declare(metadata i32* %8, metadata !343, metadata !DIExpression()), !dbg !344
  %9 = load i8*, i8** %6, align 8, !dbg !345
  %10 = load i8*, i8** %5, align 8, !dbg !346
  %11 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %4, align 8, !dbg !347
  %12 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %11, i32 0, i32 0, !dbg !348
  %13 = load i8*, i8** %12, align 8, !dbg !348
  %14 = call { i8*, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldaxr ${0:x}, $4\0Acmp ${0:x}, ${3:x}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:x}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i8* %9, i8* %10, i8* %13) #6, !dbg !349, !srcloc !350
  %15 = extractvalue { i8*, i32 } %14, 0, !dbg !349
  %16 = extractvalue { i8*, i32 } %14, 1, !dbg !349
  store i8* %15, i8** %7, align 8, !dbg !349
  store i32 %16, i32* %8, align 4, !dbg !349
  %17 = load i8*, i8** %7, align 8, !dbg !351
  ret i8* %17, !dbg !352
}

declare i32 @__VERIFIER_assume(...) #4

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_xchg(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !353 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !356, metadata !DIExpression()), !dbg !357
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !358, metadata !DIExpression()), !dbg !359
  call void @llvm.dbg.declare(metadata i8** %5, metadata !360, metadata !DIExpression()), !dbg !361
  call void @llvm.dbg.declare(metadata i32* %6, metadata !362, metadata !DIExpression()), !dbg !363
  %7 = load i8*, i8** %4, align 8, !dbg !364
  %8 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !365
  %9 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %8, i32 0, i32 0, !dbg !366
  %10 = load i8*, i8** %9, align 8, !dbg !366
  %11 = call { i8*, i32 } asm sideeffect "prfm pstl1strm, $3\0A1:\0Aldaxr ${0:x}, $3\0Astlxr  ${1:w}, ${2:x}, $3\0Acbnz ${1:w}, 1b\0A", "=&r,=&r,r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %7, i8* %10) #6, !dbg !367, !srcloc !368
  %12 = extractvalue { i8*, i32 } %11, 0, !dbg !367
  %13 = extractvalue { i8*, i32 } %11, 1, !dbg !367
  store i8* %12, i8** %5, align 8, !dbg !367
  store i32 %13, i32* %6, align 4, !dbg !367
  %14 = load i8*, i8** %5, align 8, !dbg !369
  ret i8* %14, !dbg !370
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_await_eq_acq(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !371 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !376, metadata !DIExpression()), !dbg !377
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !378, metadata !DIExpression()), !dbg !379
  call void @llvm.dbg.declare(metadata i8** %5, metadata !380, metadata !DIExpression()), !dbg !381
  %6 = load i8*, i8** %4, align 8, !dbg !382
  %7 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !383
  %8 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %7, i32 0, i32 0, !dbg !384
  %9 = load i8*, i8** %8, align 8, !dbg !384
  %10 = call i8* asm sideeffect "1:\0Aldar ${0:x}, $2\0Acmp ${0:x}, ${1:x}\0Ab.ne 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i8* %6, i8* %9) #6, !dbg !385, !srcloc !386
  store i8* %10, i8** %5, align 8, !dbg !385
  %11 = load i8*, i8** %5, align 8, !dbg !387
  ret i8* %11, !dbg !388
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !389 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !392, metadata !DIExpression()), !dbg !393
  call void @llvm.dbg.declare(metadata i8** %3, metadata !394, metadata !DIExpression()), !dbg !395
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !396
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !397
  %6 = load i8*, i8** %5, align 8, !dbg !397
  %7 = call i8* asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !398, !srcloc !399
  store i8* %7, i8** %3, align 8, !dbg !398
  %8 = load i8*, i8** %3, align 8, !dbg !400
  ret i8* %8, !dbg !401
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !402 {
  %4 = alloca %struct.vatomicptr_s*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i32, align 4
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %4, metadata !403, metadata !DIExpression()), !dbg !404
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !405, metadata !DIExpression()), !dbg !406
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !407, metadata !DIExpression()), !dbg !408
  call void @llvm.dbg.declare(metadata i8** %7, metadata !409, metadata !DIExpression()), !dbg !410
  call void @llvm.dbg.declare(metadata i32* %8, metadata !411, metadata !DIExpression()), !dbg !412
  %9 = load i8*, i8** %6, align 8, !dbg !413
  %10 = load i8*, i8** %5, align 8, !dbg !414
  %11 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %4, align 8, !dbg !415
  %12 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %11, i32 0, i32 0, !dbg !416
  %13 = load i8*, i8** %12, align 8, !dbg !416
  %14 = call { i8*, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:x}, $4\0Acmp ${0:x}, ${3:x}\0Ab.ne 2f\0Astlxr  ${1:w}, ${2:x}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i8* %9, i8* %10, i8* %13) #6, !dbg !417, !srcloc !418
  %15 = extractvalue { i8*, i32 } %14, 0, !dbg !417
  %16 = extractvalue { i8*, i32 } %14, 1, !dbg !417
  store i8* %15, i8** %7, align 8, !dbg !417
  store i32 %16, i32* %8, align 4, !dbg !417
  %17 = load i8*, i8** %7, align 8, !dbg !419
  ret i8* %17, !dbg !420
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !421 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !422, metadata !DIExpression()), !dbg !423
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !424, metadata !DIExpression()), !dbg !425
  %5 = load i8*, i8** %4, align 8, !dbg !426
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !427
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !428
  %8 = load i8*, i8** %7, align 8, !dbg !428
  call void asm sideeffect "stlr ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !429, !srcloc !430
  ret void, !dbg !431
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_await_eq_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !432 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !433, metadata !DIExpression()), !dbg !434
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !435, metadata !DIExpression()), !dbg !436
  call void @llvm.dbg.declare(metadata i8** %5, metadata !437, metadata !DIExpression()), !dbg !438
  %6 = load i8*, i8** %4, align 8, !dbg !439
  %7 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !440
  %8 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %7, i32 0, i32 0, !dbg !441
  %9 = load i8*, i8** %8, align 8, !dbg !441
  %10 = call i8* asm sideeffect "1:\0Aldr ${0:x}, $2\0Acmp ${0:x}, ${1:x}\0Ab.ne 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i8* %6, i8* %9) #6, !dbg !442, !srcloc !443
  store i8* %10, i8** %5, align 8, !dbg !442
  %11 = load i8*, i8** %5, align 8, !dbg !444
  ret i8* %11, !dbg !445
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!44, !45, !46, !47, !48, !49, !50}
!llvm.ident = !{!51}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !37, line: 100, type: !38, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !22, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/spinlock/test/hemlock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4036f4be06f1f8715edce01e9ff7a0b4")
!4 = !{!5, !6, !11}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 37, baseType: !8)
!7 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !9, line: 90, baseType: !10)
!9 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "hem_node_t", file: !13, line: 27, baseType: !14)
!13 = !DIFile(filename: "spinlock/include/vsync/spinlock/hemlock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "f07b62e13dd96afb20475de83ef91353")
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hem_node_s", file: !13, line: 25, size: 64, elements: !15)
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "grant", scope: !14, file: !13, line: 26, baseType: !17, size: 64, align: 64)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomicptr_t", file: !18, line: 44, baseType: !19)
!18 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomicptr_s", file: !18, line: 42, size: 64, align: 64, elements: !20)
!20 = !{!21}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !19, file: !18, line: 43, baseType: !5, size: 64)
!22 = !{!23, !30, !0, !35}
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !25, line: 12, type: !26, isLocal: false, isDefinition: true)
!25 = !DIFile(filename: "spinlock/test/hemlock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4036f4be06f1f8715edce01e9ff7a0b4")
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "hemlock_t", file: !13, line: 32, baseType: !27)
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hemlock_s", file: !13, line: 30, size: 64, elements: !28)
!28 = !{!29}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !27, file: !13, line: 31, baseType: !17, size: 64, align: 64)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "nodes", scope: !2, file: !25, line: 13, type: !32, isLocal: false, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 192, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 3)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !37, line: 101, type: !38, isLocal: true, isDefinition: true)
!37 = !DIFile(filename: "utils/include/test/boilerplate/lock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4187ade4a536ecfd1f9ed3ab727ca965")
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !7, line: 35, baseType: !39)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !40, line: 26, baseType: !41)
!40 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !42, line: 42, baseType: !43)
!42 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!43 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!44 = !{i32 7, !"Dwarf Version", i32 5}
!45 = !{i32 2, !"Debug Info Version", i32 3}
!46 = !{i32 1, !"wchar_size", i32 4}
!47 = !{i32 7, !"PIC Level", i32 2}
!48 = !{i32 7, !"PIE Level", i32 2}
!49 = !{i32 7, !"uwtable", i32 1}
!50 = !{i32 7, !"frame-pointer", i32 2}
!51 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!52 = distinct !DISubprogram(name: "init", scope: !37, file: !37, line: 68, type: !53, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!53 = !DISubroutineType(types: !54)
!54 = !{null}
!55 = !{}
!56 = !DILocation(line: 70, column: 1, scope: !52)
!57 = distinct !DISubprogram(name: "post", scope: !37, file: !37, line: 77, type: !53, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!58 = !DILocation(line: 79, column: 1, scope: !57)
!59 = distinct !DISubprogram(name: "fini", scope: !37, file: !37, line: 86, type: !53, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!60 = !DILocation(line: 88, column: 1, scope: !59)
!61 = distinct !DISubprogram(name: "cs", scope: !37, file: !37, line: 104, type: !53, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!62 = !DILocation(line: 106, column: 11, scope: !61)
!63 = !DILocation(line: 107, column: 11, scope: !61)
!64 = !DILocation(line: 108, column: 1, scope: !61)
!65 = distinct !DISubprogram(name: "check", scope: !37, file: !37, line: 110, type: !53, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!66 = !DILocation(line: 112, column: 5, scope: !67)
!67 = distinct !DILexicalBlock(scope: !68, file: !37, line: 112, column: 5)
!68 = distinct !DILexicalBlock(scope: !65, file: !37, line: 112, column: 5)
!69 = !DILocation(line: 112, column: 5, scope: !68)
!70 = !DILocation(line: 113, column: 5, scope: !71)
!71 = distinct !DILexicalBlock(scope: !72, file: !37, line: 113, column: 5)
!72 = distinct !DILexicalBlock(scope: !65, file: !37, line: 113, column: 5)
!73 = !DILocation(line: 113, column: 5, scope: !72)
!74 = !DILocation(line: 114, column: 1, scope: !65)
!75 = distinct !DISubprogram(name: "main", scope: !37, file: !37, line: 141, type: !76, scopeLine: 142, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!76 = !DISubroutineType(types: !77)
!77 = !{!78}
!78 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!79 = !DILocalVariable(name: "t", scope: !75, file: !37, line: 143, type: !80)
!80 = !DICompositeType(tag: DW_TAG_array_type, baseType: !81, size: 192, elements: !33)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !82, line: 27, baseType: !10)
!82 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!83 = !DILocation(line: 143, column: 15, scope: !75)
!84 = !DILocation(line: 150, column: 5, scope: !75)
!85 = !DILocalVariable(name: "i", scope: !86, file: !37, line: 152, type: !6)
!86 = distinct !DILexicalBlock(scope: !75, file: !37, line: 152, column: 5)
!87 = !DILocation(line: 152, column: 21, scope: !86)
!88 = !DILocation(line: 152, column: 10, scope: !86)
!89 = !DILocation(line: 152, column: 28, scope: !90)
!90 = distinct !DILexicalBlock(scope: !86, file: !37, line: 152, column: 5)
!91 = !DILocation(line: 152, column: 30, scope: !90)
!92 = !DILocation(line: 152, column: 5, scope: !86)
!93 = !DILocation(line: 153, column: 33, scope: !94)
!94 = distinct !DILexicalBlock(scope: !90, file: !37, line: 152, column: 47)
!95 = !DILocation(line: 153, column: 31, scope: !94)
!96 = !DILocation(line: 153, column: 53, scope: !94)
!97 = !DILocation(line: 153, column: 45, scope: !94)
!98 = !DILocation(line: 153, column: 15, scope: !94)
!99 = !DILocation(line: 154, column: 5, scope: !94)
!100 = !DILocation(line: 152, column: 43, scope: !90)
!101 = !DILocation(line: 152, column: 5, scope: !90)
!102 = distinct !{!102, !92, !103, !104}
!103 = !DILocation(line: 154, column: 5, scope: !86)
!104 = !{!"llvm.loop.mustprogress"}
!105 = !DILocation(line: 156, column: 5, scope: !75)
!106 = !DILocalVariable(name: "i", scope: !107, file: !37, line: 158, type: !6)
!107 = distinct !DILexicalBlock(scope: !75, file: !37, line: 158, column: 5)
!108 = !DILocation(line: 158, column: 21, scope: !107)
!109 = !DILocation(line: 158, column: 10, scope: !107)
!110 = !DILocation(line: 158, column: 28, scope: !111)
!111 = distinct !DILexicalBlock(scope: !107, file: !37, line: 158, column: 5)
!112 = !DILocation(line: 158, column: 30, scope: !111)
!113 = !DILocation(line: 158, column: 5, scope: !107)
!114 = !DILocation(line: 159, column: 30, scope: !115)
!115 = distinct !DILexicalBlock(scope: !111, file: !37, line: 158, column: 47)
!116 = !DILocation(line: 159, column: 28, scope: !115)
!117 = !DILocation(line: 159, column: 15, scope: !115)
!118 = !DILocation(line: 160, column: 5, scope: !115)
!119 = !DILocation(line: 158, column: 43, scope: !111)
!120 = !DILocation(line: 158, column: 5, scope: !111)
!121 = distinct !{!121, !113, !122, !104}
!122 = !DILocation(line: 160, column: 5, scope: !107)
!123 = !DILocation(line: 167, column: 5, scope: !75)
!124 = !DILocation(line: 168, column: 5, scope: !75)
!125 = !DILocation(line: 170, column: 5, scope: !75)
!126 = distinct !DISubprogram(name: "run", scope: !37, file: !37, line: 119, type: !127, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!127 = !DISubroutineType(types: !128)
!128 = !{!5, !5}
!129 = !DILocalVariable(name: "arg", arg: 1, scope: !126, file: !37, line: 119, type: !5)
!130 = !DILocation(line: 119, column: 11, scope: !126)
!131 = !DILocalVariable(name: "tid", scope: !126, file: !37, line: 121, type: !38)
!132 = !DILocation(line: 121, column: 15, scope: !126)
!133 = !DILocation(line: 121, column: 33, scope: !126)
!134 = !DILocation(line: 121, column: 21, scope: !126)
!135 = !DILocalVariable(name: "i", scope: !136, file: !37, line: 125, type: !78)
!136 = distinct !DILexicalBlock(scope: !126, file: !37, line: 125, column: 5)
!137 = !DILocation(line: 125, column: 14, scope: !136)
!138 = !DILocation(line: 125, column: 10, scope: !136)
!139 = !DILocation(line: 125, column: 21, scope: !140)
!140 = distinct !DILexicalBlock(scope: !136, file: !37, line: 125, column: 5)
!141 = !DILocation(line: 125, column: 23, scope: !140)
!142 = !DILocation(line: 125, column: 28, scope: !140)
!143 = !DILocation(line: 125, column: 31, scope: !140)
!144 = !DILocation(line: 0, scope: !140)
!145 = !DILocation(line: 125, column: 5, scope: !136)
!146 = !DILocalVariable(name: "j", scope: !147, file: !37, line: 129, type: !78)
!147 = distinct !DILexicalBlock(scope: !148, file: !37, line: 129, column: 9)
!148 = distinct !DILexicalBlock(scope: !140, file: !37, line: 125, column: 63)
!149 = !DILocation(line: 129, column: 18, scope: !147)
!150 = !DILocation(line: 129, column: 14, scope: !147)
!151 = !DILocation(line: 129, column: 25, scope: !152)
!152 = distinct !DILexicalBlock(scope: !147, file: !37, line: 129, column: 9)
!153 = !DILocation(line: 129, column: 27, scope: !152)
!154 = !DILocation(line: 129, column: 32, scope: !152)
!155 = !DILocation(line: 129, column: 35, scope: !152)
!156 = !DILocation(line: 0, scope: !152)
!157 = !DILocation(line: 129, column: 9, scope: !147)
!158 = !DILocation(line: 130, column: 21, scope: !159)
!159 = distinct !DILexicalBlock(scope: !152, file: !37, line: 129, column: 67)
!160 = !DILocation(line: 130, column: 13, scope: !159)
!161 = !DILocation(line: 131, column: 13, scope: !159)
!162 = !DILocation(line: 132, column: 9, scope: !159)
!163 = !DILocation(line: 129, column: 63, scope: !152)
!164 = !DILocation(line: 129, column: 9, scope: !152)
!165 = distinct !{!165, !157, !166, !104}
!166 = !DILocation(line: 132, column: 9, scope: !147)
!167 = !DILocalVariable(name: "j", scope: !168, file: !37, line: 133, type: !78)
!168 = distinct !DILexicalBlock(scope: !148, file: !37, line: 133, column: 9)
!169 = !DILocation(line: 133, column: 18, scope: !168)
!170 = !DILocation(line: 133, column: 14, scope: !168)
!171 = !DILocation(line: 133, column: 25, scope: !172)
!172 = distinct !DILexicalBlock(scope: !168, file: !37, line: 133, column: 9)
!173 = !DILocation(line: 133, column: 27, scope: !172)
!174 = !DILocation(line: 133, column: 32, scope: !172)
!175 = !DILocation(line: 133, column: 35, scope: !172)
!176 = !DILocation(line: 0, scope: !172)
!177 = !DILocation(line: 133, column: 9, scope: !168)
!178 = !DILocation(line: 134, column: 21, scope: !179)
!179 = distinct !DILexicalBlock(scope: !172, file: !37, line: 133, column: 67)
!180 = !DILocation(line: 134, column: 13, scope: !179)
!181 = !DILocation(line: 135, column: 9, scope: !179)
!182 = !DILocation(line: 133, column: 63, scope: !172)
!183 = !DILocation(line: 133, column: 9, scope: !172)
!184 = distinct !{!184, !177, !185, !104}
!185 = !DILocation(line: 135, column: 9, scope: !168)
!186 = !DILocation(line: 136, column: 5, scope: !148)
!187 = !DILocation(line: 125, column: 59, scope: !140)
!188 = !DILocation(line: 125, column: 5, scope: !140)
!189 = distinct !{!189, !145, !190, !104}
!190 = !DILocation(line: 136, column: 5, scope: !136)
!191 = !DILocation(line: 137, column: 5, scope: !126)
!192 = distinct !DISubprogram(name: "acquire", scope: !25, file: !25, line: 16, type: !193, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!193 = !DISubroutineType(types: !194)
!194 = !{null, !38}
!195 = !DILocalVariable(name: "tid", arg: 1, scope: !192, file: !25, line: 16, type: !38)
!196 = !DILocation(line: 16, column: 19, scope: !192)
!197 = !DILocation(line: 18, column: 9, scope: !198)
!198 = distinct !DILexicalBlock(scope: !192, file: !25, line: 18, column: 9)
!199 = !DILocation(line: 18, column: 13, scope: !198)
!200 = !DILocation(line: 18, column: 9, scope: !192)
!201 = !DILocalVariable(name: "acquired", scope: !202, file: !25, line: 20, type: !203)
!202 = distinct !DILexicalBlock(scope: !198, file: !25, line: 18, column: 30)
!203 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !7, line: 44, baseType: !204)
!204 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!205 = !DILocation(line: 20, column: 17, scope: !202)
!206 = !DILocation(line: 20, column: 61, scope: !202)
!207 = !DILocation(line: 20, column: 55, scope: !202)
!208 = !DILocation(line: 20, column: 28, scope: !202)
!209 = !DILocation(line: 21, column: 29, scope: !202)
!210 = !DILocation(line: 21, column: 9, scope: !202)
!211 = !DILocation(line: 25, column: 5, scope: !202)
!212 = !DILocation(line: 26, column: 39, scope: !213)
!213 = distinct !DILexicalBlock(scope: !198, file: !25, line: 25, column: 12)
!214 = !DILocation(line: 26, column: 33, scope: !213)
!215 = !DILocation(line: 26, column: 9, scope: !213)
!216 = !DILocation(line: 28, column: 1, scope: !192)
!217 = distinct !DISubprogram(name: "hemlock_tryacquire", scope: !13, file: !13, line: 59, type: !218, scopeLine: 60, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!218 = !DISubroutineType(types: !219)
!219 = !{!78, !220, !11}
!220 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!221 = !DILocalVariable(name: "l", arg: 1, scope: !217, file: !13, line: 59, type: !220)
!222 = !DILocation(line: 59, column: 31, scope: !217)
!223 = !DILocalVariable(name: "node", arg: 2, scope: !217, file: !13, line: 59, type: !11)
!224 = !DILocation(line: 59, column: 46, scope: !217)
!225 = !DILocalVariable(name: "pred", scope: !217, file: !13, line: 61, type: !11)
!226 = !DILocation(line: 61, column: 17, scope: !217)
!227 = !DILocation(line: 63, column: 27, scope: !217)
!228 = !DILocation(line: 63, column: 33, scope: !217)
!229 = !DILocation(line: 63, column: 5, scope: !217)
!230 = !DILocation(line: 64, column: 50, scope: !217)
!231 = !DILocation(line: 64, column: 53, scope: !217)
!232 = !DILocation(line: 64, column: 65, scope: !217)
!233 = !DILocation(line: 64, column: 26, scope: !217)
!234 = !DILocation(line: 64, column: 12, scope: !217)
!235 = !DILocation(line: 64, column: 10, scope: !217)
!236 = !DILocation(line: 65, column: 12, scope: !217)
!237 = !DILocation(line: 65, column: 17, scope: !217)
!238 = !DILocation(line: 65, column: 5, scope: !217)
!239 = distinct !DISubprogram(name: "verification_assume", scope: !240, file: !240, line: 116, type: !241, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!240 = !DIFile(filename: "include/vsync/common/verify.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "2fd10960d0c2c64c7ccf19294b1806ff")
!241 = !DISubroutineType(types: !242)
!242 = !{null, !203}
!243 = !DILocalVariable(name: "cond", arg: 1, scope: !239, file: !240, line: 116, type: !203)
!244 = !DILocation(line: 116, column: 29, scope: !239)
!245 = !DILocation(line: 118, column: 23, scope: !239)
!246 = !DILocation(line: 118, column: 5, scope: !239)
!247 = !DILocation(line: 119, column: 1, scope: !239)
!248 = distinct !DISubprogram(name: "hemlock_acquire", scope: !13, file: !13, line: 75, type: !249, scopeLine: 76, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!249 = !DISubroutineType(types: !250)
!250 = !{null, !220, !11}
!251 = !DILocalVariable(name: "l", arg: 1, scope: !248, file: !13, line: 75, type: !220)
!252 = !DILocation(line: 75, column: 28, scope: !248)
!253 = !DILocalVariable(name: "node", arg: 2, scope: !248, file: !13, line: 75, type: !11)
!254 = !DILocation(line: 75, column: 43, scope: !248)
!255 = !DILocalVariable(name: "pred", scope: !248, file: !13, line: 77, type: !11)
!256 = !DILocation(line: 77, column: 17, scope: !248)
!257 = !DILocation(line: 79, column: 27, scope: !248)
!258 = !DILocation(line: 79, column: 33, scope: !248)
!259 = !DILocation(line: 79, column: 5, scope: !248)
!260 = !DILocation(line: 80, column: 43, scope: !248)
!261 = !DILocation(line: 80, column: 46, scope: !248)
!262 = !DILocation(line: 80, column: 52, scope: !248)
!263 = !DILocation(line: 80, column: 26, scope: !248)
!264 = !DILocation(line: 80, column: 12, scope: !248)
!265 = !DILocation(line: 80, column: 10, scope: !248)
!266 = !DILocation(line: 81, column: 9, scope: !267)
!267 = distinct !DILexicalBlock(scope: !248, file: !13, line: 81, column: 9)
!268 = !DILocation(line: 81, column: 14, scope: !267)
!269 = !DILocation(line: 81, column: 9, scope: !248)
!270 = !DILocation(line: 82, column: 9, scope: !271)
!271 = distinct !DILexicalBlock(scope: !267, file: !13, line: 81, column: 23)
!272 = !DILocation(line: 86, column: 30, scope: !248)
!273 = !DILocation(line: 86, column: 36, scope: !248)
!274 = !DILocation(line: 86, column: 43, scope: !248)
!275 = !DILocation(line: 86, column: 5, scope: !248)
!276 = !DILocation(line: 87, column: 27, scope: !248)
!277 = !DILocation(line: 87, column: 33, scope: !248)
!278 = !DILocation(line: 87, column: 5, scope: !248)
!279 = !DILocation(line: 92, column: 1, scope: !248)
!280 = distinct !DISubprogram(name: "release", scope: !25, file: !25, line: 31, type: !193, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !55)
!281 = !DILocalVariable(name: "tid", arg: 1, scope: !280, file: !25, line: 31, type: !38)
!282 = !DILocation(line: 31, column: 19, scope: !280)
!283 = !DILocation(line: 33, column: 35, scope: !280)
!284 = !DILocation(line: 33, column: 29, scope: !280)
!285 = !DILocation(line: 33, column: 5, scope: !280)
!286 = !DILocation(line: 34, column: 1, scope: !280)
!287 = distinct !DISubprogram(name: "hemlock_release", scope: !13, file: !13, line: 101, type: !249, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!288 = !DILocalVariable(name: "l", arg: 1, scope: !287, file: !13, line: 101, type: !220)
!289 = !DILocation(line: 101, column: 28, scope: !287)
!290 = !DILocalVariable(name: "node", arg: 2, scope: !287, file: !13, line: 101, type: !11)
!291 = !DILocation(line: 101, column: 43, scope: !287)
!292 = !DILocation(line: 103, column: 30, scope: !293)
!293 = distinct !DILexicalBlock(scope: !287, file: !13, line: 103, column: 9)
!294 = !DILocation(line: 103, column: 33, scope: !293)
!295 = !DILocation(line: 103, column: 9, scope: !293)
!296 = !DILocation(line: 103, column: 42, scope: !293)
!297 = !DILocation(line: 103, column: 39, scope: !293)
!298 = !DILocation(line: 103, column: 47, scope: !293)
!299 = !DILocation(line: 104, column: 33, scope: !293)
!300 = !DILocation(line: 104, column: 36, scope: !293)
!301 = !DILocation(line: 104, column: 42, scope: !293)
!302 = !DILocation(line: 104, column: 9, scope: !293)
!303 = !DILocation(line: 104, column: 57, scope: !293)
!304 = !DILocation(line: 104, column: 54, scope: !293)
!305 = !DILocation(line: 103, column: 9, scope: !287)
!306 = !DILocation(line: 105, column: 9, scope: !307)
!307 = distinct !DILexicalBlock(scope: !293, file: !13, line: 104, column: 63)
!308 = !DILocation(line: 107, column: 27, scope: !287)
!309 = !DILocation(line: 107, column: 33, scope: !287)
!310 = !DILocation(line: 107, column: 40, scope: !287)
!311 = !DILocation(line: 107, column: 5, scope: !287)
!312 = !DILocation(line: 110, column: 30, scope: !287)
!313 = !DILocation(line: 110, column: 36, scope: !287)
!314 = !DILocation(line: 110, column: 5, scope: !287)
!315 = !DILocation(line: 120, column: 1, scope: !287)
!316 = distinct !DISubprogram(name: "vatomicptr_write_rlx", scope: !317, file: !317, line: 325, type: !318, scopeLine: 326, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!317 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!318 = !DISubroutineType(types: !319)
!319 = !{null, !320, !5}
!320 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!321 = !DILocalVariable(name: "a", arg: 1, scope: !316, file: !317, line: 325, type: !320)
!322 = !DILocation(line: 325, column: 36, scope: !316)
!323 = !DILocalVariable(name: "v", arg: 2, scope: !316, file: !317, line: 325, type: !5)
!324 = !DILocation(line: 325, column: 45, scope: !316)
!325 = !DILocation(line: 329, column: 32, scope: !316)
!326 = !DILocation(line: 329, column: 44, scope: !316)
!327 = !DILocation(line: 329, column: 47, scope: !316)
!328 = !DILocation(line: 327, column: 5, scope: !316)
!329 = !{i64 406864}
!330 = !DILocation(line: 331, column: 1, scope: !316)
!331 = distinct !DISubprogram(name: "vatomicptr_cmpxchg_acq", scope: !332, file: !332, line: 511, type: !333, scopeLine: 512, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!332 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!333 = !DISubroutineType(types: !334)
!334 = !{!5, !320, !5, !5}
!335 = !DILocalVariable(name: "a", arg: 1, scope: !331, file: !332, line: 511, type: !320)
!336 = !DILocation(line: 511, column: 38, scope: !331)
!337 = !DILocalVariable(name: "e", arg: 2, scope: !331, file: !332, line: 511, type: !5)
!338 = !DILocation(line: 511, column: 47, scope: !331)
!339 = !DILocalVariable(name: "v", arg: 3, scope: !331, file: !332, line: 511, type: !5)
!340 = !DILocation(line: 511, column: 56, scope: !331)
!341 = !DILocalVariable(name: "oldv", scope: !331, file: !332, line: 513, type: !5)
!342 = !DILocation(line: 513, column: 11, scope: !331)
!343 = !DILocalVariable(name: "tmp", scope: !331, file: !332, line: 514, type: !38)
!344 = !DILocation(line: 514, column: 15, scope: !331)
!345 = !DILocation(line: 525, column: 22, scope: !331)
!346 = !DILocation(line: 525, column: 36, scope: !331)
!347 = !DILocation(line: 525, column: 48, scope: !331)
!348 = !DILocation(line: 525, column: 51, scope: !331)
!349 = !DILocation(line: 515, column: 5, scope: !331)
!350 = !{i64 470755, i64 470789, i64 470804, i64 470837, i64 470871, i64 470891, i64 470933, i64 470962}
!351 = !DILocation(line: 527, column: 12, scope: !331)
!352 = !DILocation(line: 527, column: 5, scope: !331)
!353 = distinct !DISubprogram(name: "vatomicptr_xchg", scope: !332, file: !332, line: 198, type: !354, scopeLine: 199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!354 = !DISubroutineType(types: !355)
!355 = !{!5, !320, !5}
!356 = !DILocalVariable(name: "a", arg: 1, scope: !353, file: !332, line: 198, type: !320)
!357 = !DILocation(line: 198, column: 31, scope: !353)
!358 = !DILocalVariable(name: "v", arg: 2, scope: !353, file: !332, line: 198, type: !5)
!359 = !DILocation(line: 198, column: 40, scope: !353)
!360 = !DILocalVariable(name: "oldv", scope: !353, file: !332, line: 200, type: !5)
!361 = !DILocation(line: 200, column: 11, scope: !353)
!362 = !DILocalVariable(name: "tmp", scope: !353, file: !332, line: 201, type: !38)
!363 = !DILocation(line: 201, column: 15, scope: !353)
!364 = !DILocation(line: 209, column: 22, scope: !353)
!365 = !DILocation(line: 209, column: 34, scope: !353)
!366 = !DILocation(line: 209, column: 37, scope: !353)
!367 = !DILocation(line: 202, column: 5, scope: !353)
!368 = !{i64 461183, i64 461217, i64 461232, i64 461265, i64 461308}
!369 = !DILocation(line: 211, column: 12, scope: !353)
!370 = !DILocation(line: 211, column: 5, scope: !353)
!371 = distinct !DISubprogram(name: "vatomicptr_await_eq_acq", scope: !317, file: !317, line: 2012, type: !372, scopeLine: 2013, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!372 = !DISubroutineType(types: !373)
!373 = !{!5, !374, !5}
!374 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !375, size: 64)
!375 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!376 = !DILocalVariable(name: "a", arg: 1, scope: !371, file: !317, line: 2012, type: !374)
!377 = !DILocation(line: 2012, column: 45, scope: !371)
!378 = !DILocalVariable(name: "v", arg: 2, scope: !371, file: !317, line: 2012, type: !5)
!379 = !DILocation(line: 2012, column: 54, scope: !371)
!380 = !DILocalVariable(name: "val", scope: !371, file: !317, line: 2014, type: !5)
!381 = !DILocation(line: 2014, column: 11, scope: !371)
!382 = !DILocation(line: 2021, column: 21, scope: !371)
!383 = !DILocation(line: 2021, column: 33, scope: !371)
!384 = !DILocation(line: 2021, column: 36, scope: !371)
!385 = !DILocation(line: 2015, column: 5, scope: !371)
!386 = !{i64 450889, i64 450905, i64 450936, i64 450969}
!387 = !DILocation(line: 2023, column: 12, scope: !371)
!388 = !DILocation(line: 2023, column: 5, scope: !371)
!389 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !317, file: !317, line: 197, type: !390, scopeLine: 198, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!390 = !DISubroutineType(types: !391)
!391 = !{!5, !374}
!392 = !DILocalVariable(name: "a", arg: 1, scope: !389, file: !317, line: 197, type: !374)
!393 = !DILocation(line: 197, column: 41, scope: !389)
!394 = !DILocalVariable(name: "val", scope: !389, file: !317, line: 199, type: !5)
!395 = !DILocation(line: 199, column: 11, scope: !389)
!396 = !DILocation(line: 202, column: 32, scope: !389)
!397 = !DILocation(line: 202, column: 35, scope: !389)
!398 = !DILocation(line: 200, column: 5, scope: !389)
!399 = !{i64 402663}
!400 = !DILocation(line: 204, column: 12, scope: !389)
!401 = !DILocation(line: 204, column: 5, scope: !389)
!402 = distinct !DISubprogram(name: "vatomicptr_cmpxchg_rel", scope: !332, file: !332, line: 536, type: !333, scopeLine: 537, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!403 = !DILocalVariable(name: "a", arg: 1, scope: !402, file: !332, line: 536, type: !320)
!404 = !DILocation(line: 536, column: 38, scope: !402)
!405 = !DILocalVariable(name: "e", arg: 2, scope: !402, file: !332, line: 536, type: !5)
!406 = !DILocation(line: 536, column: 47, scope: !402)
!407 = !DILocalVariable(name: "v", arg: 3, scope: !402, file: !332, line: 536, type: !5)
!408 = !DILocation(line: 536, column: 56, scope: !402)
!409 = !DILocalVariable(name: "oldv", scope: !402, file: !332, line: 538, type: !5)
!410 = !DILocation(line: 538, column: 11, scope: !402)
!411 = !DILocalVariable(name: "tmp", scope: !402, file: !332, line: 539, type: !38)
!412 = !DILocation(line: 539, column: 15, scope: !402)
!413 = !DILocation(line: 550, column: 22, scope: !402)
!414 = !DILocation(line: 550, column: 36, scope: !402)
!415 = !DILocation(line: 550, column: 48, scope: !402)
!416 = !DILocation(line: 550, column: 51, scope: !402)
!417 = !DILocation(line: 540, column: 5, scope: !402)
!418 = !{i64 471521, i64 471555, i64 471570, i64 471602, i64 471636, i64 471656, i64 471699, i64 471728}
!419 = !DILocation(line: 552, column: 12, scope: !402)
!420 = !DILocation(line: 552, column: 5, scope: !402)
!421 = distinct !DISubprogram(name: "vatomicptr_write_rel", scope: !317, file: !317, line: 311, type: !318, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!422 = !DILocalVariable(name: "a", arg: 1, scope: !421, file: !317, line: 311, type: !320)
!423 = !DILocation(line: 311, column: 36, scope: !421)
!424 = !DILocalVariable(name: "v", arg: 2, scope: !421, file: !317, line: 311, type: !5)
!425 = !DILocation(line: 311, column: 45, scope: !421)
!426 = !DILocation(line: 315, column: 32, scope: !421)
!427 = !DILocation(line: 315, column: 44, scope: !421)
!428 = !DILocation(line: 315, column: 47, scope: !421)
!429 = !DILocation(line: 313, column: 5, scope: !421)
!430 = !{i64 406393}
!431 = !DILocation(line: 317, column: 1, scope: !421)
!432 = distinct !DISubprogram(name: "vatomicptr_await_eq_rlx", scope: !317, file: !317, line: 2100, type: !372, scopeLine: 2101, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !55)
!433 = !DILocalVariable(name: "a", arg: 1, scope: !432, file: !317, line: 2100, type: !374)
!434 = !DILocation(line: 2100, column: 45, scope: !432)
!435 = !DILocalVariable(name: "v", arg: 2, scope: !432, file: !317, line: 2100, type: !5)
!436 = !DILocation(line: 2100, column: 54, scope: !432)
!437 = !DILocalVariable(name: "val", scope: !432, file: !317, line: 2102, type: !5)
!438 = !DILocation(line: 2102, column: 11, scope: !432)
!439 = !DILocation(line: 2109, column: 21, scope: !432)
!440 = !DILocation(line: 2109, column: 33, scope: !432)
!441 = !DILocation(line: 2109, column: 36, scope: !432)
!442 = !DILocation(line: 2103, column: 5, scope: !432)
!443 = !{i64 453168, i64 453184, i64 453214, i64 453247}
!444 = !DILocation(line: 2111, column: 12, scope: !432)
!445 = !DILocation(line: 2111, column: 5, scope: !432)
