; ModuleID = '/home/stefano/huawei/libvsync/spinlock/test/clhlock.c'
source_filename = "/home/stefano/huawei/libvsync/spinlock/test/clhlock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.clhlock_s = type { %struct.vatomicptr_s, %struct.clh_qnode_s }
%struct.vatomicptr_s = type { i8* }
%struct.clh_qnode_s = type { %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%struct.clh_node_s = type { %struct.clh_qnode_s*, %struct.clh_qnode_s*, %struct.clh_qnode_s }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !54
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [68 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 1 + 0)\00", align 1
@lock = dso_local global %struct.clhlock_s zeroinitializer, align 8, !dbg !29
@node = dso_local global [3 x %struct.clh_node_s] zeroinitializer, align 16, !dbg !43
@initial = dso_local global %struct.clh_qnode_s zeroinitializer, align 4, !dbg !41

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !65 {
  ret void, !dbg !69
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !70 {
  ret void, !dbg !71
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !72 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !73
  %2 = add i32 %1, 1, !dbg !73
  store i32 %2, i32* @g_cs_x, align 4, !dbg !73
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !74
  %4 = add i32 %3, 1, !dbg !74
  store i32 %4, i32* @g_cs_y, align 4, !dbg !74
  ret void, !dbg !75
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !76 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !77
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !77
  %3 = icmp eq i32 %1, %2, !dbg !77
  br i1 %3, label %4, label %5, !dbg !80

4:                                                ; preds = %0
  br label %6, !dbg !80

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 112, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !77
  unreachable, !dbg !77

6:                                                ; preds = %4
  %7 = load i32, i32* @g_cs_x, align 4, !dbg !81
  %8 = icmp eq i32 %7, 4, !dbg !81
  br i1 %8, label %9, label %10, !dbg !84

9:                                                ; preds = %6
  br label %11, !dbg !84

10:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 113, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !81
  unreachable, !dbg !81

11:                                               ; preds = %9
  ret void, !dbg !85
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !86 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i64]* %2, metadata !90, metadata !DIExpression()), !dbg !94
  call void @init(), !dbg !95
  call void @llvm.dbg.declare(metadata i64* %3, metadata !96, metadata !DIExpression()), !dbg !98
  store i64 0, i64* %3, align 8, !dbg !98
  br label %5, !dbg !99

5:                                                ; preds = %14, %0
  %6 = load i64, i64* %3, align 8, !dbg !100
  %7 = icmp ult i64 %6, 3, !dbg !102
  br i1 %7, label %8, label %17, !dbg !103

8:                                                ; preds = %5
  %9 = load i64, i64* %3, align 8, !dbg !104
  %10 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %9, !dbg !106
  %11 = load i64, i64* %3, align 8, !dbg !107
  %12 = inttoptr i64 %11 to i8*, !dbg !108
  %13 = call i32 @pthread_create(i64* noundef %10, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef %12) #6, !dbg !109
  br label %14, !dbg !110

14:                                               ; preds = %8
  %15 = load i64, i64* %3, align 8, !dbg !111
  %16 = add i64 %15, 1, !dbg !111
  store i64 %16, i64* %3, align 8, !dbg !111
  br label %5, !dbg !112, !llvm.loop !113

17:                                               ; preds = %5
  call void @post(), !dbg !116
  call void @llvm.dbg.declare(metadata i64* %4, metadata !117, metadata !DIExpression()), !dbg !119
  store i64 0, i64* %4, align 8, !dbg !119
  br label %18, !dbg !120

18:                                               ; preds = %26, %17
  %19 = load i64, i64* %4, align 8, !dbg !121
  %20 = icmp ult i64 %19, 3, !dbg !123
  br i1 %20, label %21, label %29, !dbg !124

21:                                               ; preds = %18
  %22 = load i64, i64* %4, align 8, !dbg !125
  %23 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %22, !dbg !127
  %24 = load i64, i64* %23, align 8, !dbg !127
  %25 = call i32 @pthread_join(i64 noundef %24, i8** noundef null), !dbg !128
  br label %26, !dbg !129

26:                                               ; preds = %21
  %27 = load i64, i64* %4, align 8, !dbg !130
  %28 = add i64 %27, 1, !dbg !130
  store i64 %28, i64* %4, align 8, !dbg !130
  br label %18, !dbg !131, !llvm.loop !132

29:                                               ; preds = %18
  call void @check(), !dbg !134
  call void @fini(), !dbg !135
  ret i32 0, !dbg !136
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !137 {
  %1 = alloca i32, align 4
  call void @clhlock_init(%struct.clhlock_s* noundef @lock), !dbg !138
  call void @llvm.dbg.declare(metadata i32* %1, metadata !139, metadata !DIExpression()), !dbg !141
  store i32 0, i32* %1, align 4, !dbg !141
  br label %2, !dbg !142

2:                                                ; preds = %9, %0
  %3 = load i32, i32* %1, align 4, !dbg !143
  %4 = icmp slt i32 %3, 3, !dbg !145
  br i1 %4, label %5, label %12, !dbg !146

5:                                                ; preds = %2
  %6 = load i32, i32* %1, align 4, !dbg !147
  %7 = sext i32 %6 to i64, !dbg !149
  %8 = getelementptr inbounds [3 x %struct.clh_node_s], [3 x %struct.clh_node_s]* @node, i64 0, i64 %7, !dbg !149
  call void @clhlock_node_init(%struct.clh_node_s* noundef %8), !dbg !150
  br label %9, !dbg !151

9:                                                ; preds = %5
  %10 = load i32, i32* %1, align 4, !dbg !152
  %11 = add nsw i32 %10, 1, !dbg !152
  store i32 %11, i32* %1, align 4, !dbg !152
  br label %2, !dbg !153, !llvm.loop !154

12:                                               ; preds = %2
  ret void, !dbg !156
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !157 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !160, metadata !DIExpression()), !dbg !161
  call void @llvm.dbg.declare(metadata i32* %3, metadata !162, metadata !DIExpression()), !dbg !163
  %7 = load i8*, i8** %2, align 8, !dbg !164
  %8 = ptrtoint i8* %7 to i64, !dbg !165
  %9 = trunc i64 %8 to i32, !dbg !165
  store i32 %9, i32* %3, align 4, !dbg !163
  call void @llvm.dbg.declare(metadata i32* %4, metadata !166, metadata !DIExpression()), !dbg !168
  store i32 0, i32* %4, align 4, !dbg !168
  br label %10, !dbg !169

10:                                               ; preds = %65, %1
  %11 = load i32, i32* %4, align 4, !dbg !170
  %12 = icmp eq i32 %11, 0, !dbg !172
  br i1 %12, label %22, label %13, !dbg !173

13:                                               ; preds = %10
  %14 = load i32, i32* %4, align 4, !dbg !174
  %15 = icmp eq i32 %14, 1, !dbg !174
  br i1 %15, label %16, label %20, !dbg !174

16:                                               ; preds = %13
  %17 = load i32, i32* %3, align 4, !dbg !174
  %18 = add i32 %17, 1, !dbg !174
  %19 = icmp ult i32 %18, 2, !dbg !174
  br label %20

20:                                               ; preds = %16, %13
  %21 = phi i1 [ false, %13 ], [ %19, %16 ], !dbg !175
  br label %22, !dbg !173

22:                                               ; preds = %20, %10
  %23 = phi i1 [ true, %10 ], [ %21, %20 ]
  br i1 %23, label %24, label %68, !dbg !176

24:                                               ; preds = %22
  call void @llvm.dbg.declare(metadata i32* %5, metadata !177, metadata !DIExpression()), !dbg !180
  store i32 0, i32* %5, align 4, !dbg !180
  br label %25, !dbg !181

25:                                               ; preds = %41, %24
  %26 = load i32, i32* %5, align 4, !dbg !182
  %27 = icmp eq i32 %26, 0, !dbg !184
  br i1 %27, label %37, label %28, !dbg !185

28:                                               ; preds = %25
  %29 = load i32, i32* %5, align 4, !dbg !186
  %30 = icmp eq i32 %29, 1, !dbg !186
  br i1 %30, label %31, label %35, !dbg !186

31:                                               ; preds = %28
  %32 = load i32, i32* %3, align 4, !dbg !186
  %33 = add i32 %32, 1, !dbg !186
  %34 = icmp ult i32 %33, 1, !dbg !186
  br label %35

35:                                               ; preds = %31, %28
  %36 = phi i1 [ false, %28 ], [ %34, %31 ], !dbg !187
  br label %37, !dbg !185

37:                                               ; preds = %35, %25
  %38 = phi i1 [ true, %25 ], [ %36, %35 ]
  br i1 %38, label %39, label %44, !dbg !188

39:                                               ; preds = %37
  %40 = load i32, i32* %3, align 4, !dbg !189
  call void @acquire(i32 noundef %40), !dbg !191
  call void @cs(), !dbg !192
  br label %41, !dbg !193

41:                                               ; preds = %39
  %42 = load i32, i32* %5, align 4, !dbg !194
  %43 = add nsw i32 %42, 1, !dbg !194
  store i32 %43, i32* %5, align 4, !dbg !194
  br label %25, !dbg !195, !llvm.loop !196

44:                                               ; preds = %37
  call void @llvm.dbg.declare(metadata i32* %6, metadata !198, metadata !DIExpression()), !dbg !200
  store i32 0, i32* %6, align 4, !dbg !200
  br label %45, !dbg !201

45:                                               ; preds = %61, %44
  %46 = load i32, i32* %6, align 4, !dbg !202
  %47 = icmp eq i32 %46, 0, !dbg !204
  br i1 %47, label %57, label %48, !dbg !205

48:                                               ; preds = %45
  %49 = load i32, i32* %6, align 4, !dbg !206
  %50 = icmp eq i32 %49, 1, !dbg !206
  br i1 %50, label %51, label %55, !dbg !206

51:                                               ; preds = %48
  %52 = load i32, i32* %3, align 4, !dbg !206
  %53 = add i32 %52, 1, !dbg !206
  %54 = icmp ult i32 %53, 1, !dbg !206
  br label %55

55:                                               ; preds = %51, %48
  %56 = phi i1 [ false, %48 ], [ %54, %51 ], !dbg !207
  br label %57, !dbg !205

57:                                               ; preds = %55, %45
  %58 = phi i1 [ true, %45 ], [ %56, %55 ]
  br i1 %58, label %59, label %64, !dbg !208

59:                                               ; preds = %57
  %60 = load i32, i32* %3, align 4, !dbg !209
  call void @release(i32 noundef %60), !dbg !211
  br label %61, !dbg !212

61:                                               ; preds = %59
  %62 = load i32, i32* %6, align 4, !dbg !213
  %63 = add nsw i32 %62, 1, !dbg !213
  store i32 %63, i32* %6, align 4, !dbg !213
  br label %45, !dbg !214, !llvm.loop !215

64:                                               ; preds = %57
  br label %65, !dbg !217

65:                                               ; preds = %64
  %66 = load i32, i32* %4, align 4, !dbg !218
  %67 = add nsw i32 %66, 1, !dbg !218
  store i32 %67, i32* %4, align 4, !dbg !218
  br label %10, !dbg !219, !llvm.loop !220

68:                                               ; preds = %22
  ret i8* null, !dbg !222
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @clhlock_init(%struct.clhlock_s* noundef %0) #0 !dbg !223 {
  %2 = alloca %struct.clhlock_s*, align 8
  store %struct.clhlock_s* %0, %struct.clhlock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.clhlock_s** %2, metadata !227, metadata !DIExpression()), !dbg !228
  %3 = load %struct.clhlock_s*, %struct.clhlock_s** %2, align 8, !dbg !229
  %4 = getelementptr inbounds %struct.clhlock_s, %struct.clhlock_s* %3, i32 0, i32 1, !dbg !230
  %5 = getelementptr inbounds %struct.clh_qnode_s, %struct.clh_qnode_s* %4, i32 0, i32 0, !dbg !231
  call void @vatomic32_init(%struct.vatomic32_s* noundef %5, i32 noundef 0), !dbg !232
  %6 = load %struct.clhlock_s*, %struct.clhlock_s** %2, align 8, !dbg !233
  %7 = getelementptr inbounds %struct.clhlock_s, %struct.clhlock_s* %6, i32 0, i32 0, !dbg !234
  %8 = load %struct.clhlock_s*, %struct.clhlock_s** %2, align 8, !dbg !235
  %9 = getelementptr inbounds %struct.clhlock_s, %struct.clhlock_s* %8, i32 0, i32 1, !dbg !236
  %10 = bitcast %struct.clh_qnode_s* %9 to i8*, !dbg !237
  call void @vatomicptr_init(%struct.vatomicptr_s* noundef %7, i8* noundef %10), !dbg !238
  ret void, !dbg !239
}

; Function Attrs: noinline nounwind uwtable
define internal void @clhlock_node_init(%struct.clh_node_s* noundef %0) #0 !dbg !240 {
  %2 = alloca %struct.clh_node_s*, align 8
  store %struct.clh_node_s* %0, %struct.clh_node_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.clh_node_s** %2, metadata !244, metadata !DIExpression()), !dbg !245
  %3 = load %struct.clh_node_s*, %struct.clh_node_s** %2, align 8, !dbg !246
  %4 = getelementptr inbounds %struct.clh_node_s, %struct.clh_node_s* %3, i32 0, i32 2, !dbg !247
  %5 = getelementptr inbounds %struct.clh_qnode_s, %struct.clh_qnode_s* %4, i32 0, i32 0, !dbg !248
  call void @vatomic32_init(%struct.vatomic32_s* noundef %5, i32 noundef 0), !dbg !249
  %6 = load %struct.clh_node_s*, %struct.clh_node_s** %2, align 8, !dbg !250
  %7 = getelementptr inbounds %struct.clh_node_s, %struct.clh_node_s* %6, i32 0, i32 2, !dbg !251
  %8 = load %struct.clh_node_s*, %struct.clh_node_s** %2, align 8, !dbg !252
  %9 = getelementptr inbounds %struct.clh_node_s, %struct.clh_node_s* %8, i32 0, i32 1, !dbg !253
  store %struct.clh_qnode_s* %7, %struct.clh_qnode_s** %9, align 8, !dbg !254
  %10 = load %struct.clh_node_s*, %struct.clh_node_s** %2, align 8, !dbg !255
  %11 = getelementptr inbounds %struct.clh_node_s, %struct.clh_node_s* %10, i32 0, i32 0, !dbg !256
  store %struct.clh_qnode_s* null, %struct.clh_qnode_s** %11, align 8, !dbg !257
  ret void, !dbg !258
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !259 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !262, metadata !DIExpression()), !dbg !263
  %3 = load i32, i32* %2, align 4, !dbg !264
  %4 = zext i32 %3 to i64, !dbg !265
  %5 = getelementptr inbounds [3 x %struct.clh_node_s], [3 x %struct.clh_node_s]* @node, i64 0, i64 %4, !dbg !265
  call void @clhlock_acquire(%struct.clhlock_s* noundef @lock, %struct.clh_node_s* noundef %5), !dbg !266
  ret void, !dbg !267
}

; Function Attrs: noinline nounwind uwtable
define internal void @clhlock_acquire(%struct.clhlock_s* noundef %0, %struct.clh_node_s* noundef %1) #0 !dbg !268 {
  %3 = alloca %struct.clhlock_s*, align 8
  %4 = alloca %struct.clh_node_s*, align 8
  store %struct.clhlock_s* %0, %struct.clhlock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.clhlock_s** %3, metadata !271, metadata !DIExpression()), !dbg !272
  store %struct.clh_node_s* %1, %struct.clh_node_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.clh_node_s** %4, metadata !273, metadata !DIExpression()), !dbg !274
  %5 = load %struct.clh_node_s*, %struct.clh_node_s** %4, align 8, !dbg !275
  %6 = getelementptr inbounds %struct.clh_node_s, %struct.clh_node_s* %5, i32 0, i32 1, !dbg !276
  %7 = load %struct.clh_qnode_s*, %struct.clh_qnode_s** %6, align 8, !dbg !276
  %8 = getelementptr inbounds %struct.clh_qnode_s, %struct.clh_qnode_s* %7, i32 0, i32 0, !dbg !277
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %8, i32 noundef 1), !dbg !278
  %9 = load %struct.clhlock_s*, %struct.clhlock_s** %3, align 8, !dbg !279
  %10 = getelementptr inbounds %struct.clhlock_s, %struct.clhlock_s* %9, i32 0, i32 0, !dbg !280
  %11 = load %struct.clh_node_s*, %struct.clh_node_s** %4, align 8, !dbg !281
  %12 = getelementptr inbounds %struct.clh_node_s, %struct.clh_node_s* %11, i32 0, i32 1, !dbg !282
  %13 = load %struct.clh_qnode_s*, %struct.clh_qnode_s** %12, align 8, !dbg !282
  %14 = bitcast %struct.clh_qnode_s* %13 to i8*, !dbg !281
  %15 = call i8* @vatomicptr_xchg(%struct.vatomicptr_s* noundef %10, i8* noundef %14), !dbg !283
  %16 = bitcast i8* %15 to %struct.clh_qnode_s*, !dbg !284
  %17 = load %struct.clh_node_s*, %struct.clh_node_s** %4, align 8, !dbg !285
  %18 = getelementptr inbounds %struct.clh_node_s, %struct.clh_node_s* %17, i32 0, i32 0, !dbg !286
  store %struct.clh_qnode_s* %16, %struct.clh_qnode_s** %18, align 8, !dbg !287
  %19 = load %struct.clh_node_s*, %struct.clh_node_s** %4, align 8, !dbg !288
  %20 = getelementptr inbounds %struct.clh_node_s, %struct.clh_node_s* %19, i32 0, i32 0, !dbg !289
  %21 = load %struct.clh_qnode_s*, %struct.clh_qnode_s** %20, align 8, !dbg !289
  %22 = getelementptr inbounds %struct.clh_qnode_s, %struct.clh_qnode_s* %21, i32 0, i32 0, !dbg !290
  %23 = call i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %22, i32 noundef 0), !dbg !291
  ret void, !dbg !292
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !293 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !294, metadata !DIExpression()), !dbg !295
  %3 = load i32, i32* %2, align 4, !dbg !296
  %4 = zext i32 %3 to i64, !dbg !297
  %5 = getelementptr inbounds [3 x %struct.clh_node_s], [3 x %struct.clh_node_s]* @node, i64 0, i64 %4, !dbg !297
  call void @clhlock_release(%struct.clhlock_s* noundef @lock, %struct.clh_node_s* noundef %5), !dbg !298
  ret void, !dbg !299
}

; Function Attrs: noinline nounwind uwtable
define internal void @clhlock_release(%struct.clhlock_s* noundef %0, %struct.clh_node_s* noundef %1) #0 !dbg !300 {
  %3 = alloca %struct.clhlock_s*, align 8
  %4 = alloca %struct.clh_node_s*, align 8
  store %struct.clhlock_s* %0, %struct.clhlock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.clhlock_s** %3, metadata !301, metadata !DIExpression()), !dbg !302
  store %struct.clh_node_s* %1, %struct.clh_node_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.clh_node_s** %4, metadata !303, metadata !DIExpression()), !dbg !304
  %5 = load %struct.clh_node_s*, %struct.clh_node_s** %4, align 8, !dbg !305
  %6 = getelementptr inbounds %struct.clh_node_s, %struct.clh_node_s* %5, i32 0, i32 1, !dbg !306
  %7 = load %struct.clh_qnode_s*, %struct.clh_qnode_s** %6, align 8, !dbg !306
  %8 = getelementptr inbounds %struct.clh_qnode_s, %struct.clh_qnode_s* %7, i32 0, i32 0, !dbg !307
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %8, i32 noundef 0), !dbg !308
  %9 = load %struct.clh_node_s*, %struct.clh_node_s** %4, align 8, !dbg !309
  %10 = getelementptr inbounds %struct.clh_node_s, %struct.clh_node_s* %9, i32 0, i32 0, !dbg !310
  %11 = load %struct.clh_qnode_s*, %struct.clh_qnode_s** %10, align 8, !dbg !310
  %12 = load %struct.clh_node_s*, %struct.clh_node_s** %4, align 8, !dbg !311
  %13 = getelementptr inbounds %struct.clh_node_s, %struct.clh_node_s* %12, i32 0, i32 1, !dbg !312
  store %struct.clh_qnode_s* %11, %struct.clh_qnode_s** %13, align 8, !dbg !313
  br label %14, !dbg !314

14:                                               ; preds = %2
  br label %15, !dbg !315

15:                                               ; preds = %14
  %16 = load %struct.clhlock_s*, %struct.clhlock_s** %3, align 8, !dbg !317
  br label %17, !dbg !317

17:                                               ; preds = %15
  br label %18, !dbg !319

18:                                               ; preds = %17
  br label %19, !dbg !317

19:                                               ; preds = %18
  br label %20, !dbg !315

20:                                               ; preds = %19
  ret void, !dbg !321
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_init(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !322 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !327, metadata !DIExpression()), !dbg !328
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !329, metadata !DIExpression()), !dbg !330
  %5 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !331
  %6 = load i32, i32* %4, align 4, !dbg !332
  call void @vatomic32_write(%struct.vatomic32_s* noundef %5, i32 noundef %6), !dbg !333
  ret void, !dbg !334
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_init(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !335 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !339, metadata !DIExpression()), !dbg !340
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !341, metadata !DIExpression()), !dbg !342
  %5 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !343
  %6 = load i8*, i8** %4, align 8, !dbg !344
  call void @vatomicptr_write(%struct.vatomicptr_s* noundef %5, i8* noundef %6), !dbg !345
  ret void, !dbg !346
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !347 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !349, metadata !DIExpression()), !dbg !350
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !351, metadata !DIExpression()), !dbg !352
  %5 = load i32, i32* %4, align 4, !dbg !353
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !354
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !355
  %8 = load i32, i32* %7, align 4, !dbg !355
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !356, !srcloc !357
  ret void, !dbg !358
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !359 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !360, metadata !DIExpression()), !dbg !361
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !362, metadata !DIExpression()), !dbg !363
  %5 = load i8*, i8** %4, align 8, !dbg !364
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !365
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !366
  %8 = load i8*, i8** %7, align 8, !dbg !366
  call void asm sideeffect "stlr ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !367, !srcloc !368
  ret void, !dbg !369
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !370 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !371, metadata !DIExpression()), !dbg !372
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !373, metadata !DIExpression()), !dbg !374
  %5 = load i32, i32* %4, align 4, !dbg !375
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !376
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !377
  %8 = load i32, i32* %7, align 4, !dbg !377
  call void asm sideeffect "str ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !378, !srcloc !379
  ret void, !dbg !380
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_xchg(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !381 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !385, metadata !DIExpression()), !dbg !386
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !387, metadata !DIExpression()), !dbg !388
  call void @llvm.dbg.declare(metadata i8** %5, metadata !389, metadata !DIExpression()), !dbg !390
  call void @llvm.dbg.declare(metadata i32* %6, metadata !391, metadata !DIExpression()), !dbg !392
  %7 = load i8*, i8** %4, align 8, !dbg !393
  %8 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !394
  %9 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %8, i32 0, i32 0, !dbg !395
  %10 = load i8*, i8** %9, align 8, !dbg !395
  %11 = call { i8*, i32 } asm sideeffect "prfm pstl1strm, $3\0A1:\0Aldaxr ${0:x}, $3\0Astlxr  ${1:w}, ${2:x}, $3\0Acbnz ${1:w}, 1b\0A", "=&r,=&r,r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %7, i8* %10) #6, !dbg !396, !srcloc !397
  %12 = extractvalue { i8*, i32 } %11, 0, !dbg !396
  %13 = extractvalue { i8*, i32 } %11, 1, !dbg !396
  store i8* %12, i8** %5, align 8, !dbg !396
  store i32 %13, i32* %6, align 4, !dbg !396
  %14 = load i8*, i8** %5, align 8, !dbg !398
  ret i8* %14, !dbg !399
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !400 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !405, metadata !DIExpression()), !dbg !406
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !407, metadata !DIExpression()), !dbg !408
  call void @llvm.dbg.declare(metadata i32* %5, metadata !409, metadata !DIExpression()), !dbg !410
  %6 = load i32, i32* %4, align 4, !dbg !411
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !412
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !413
  %9 = load i32, i32* %8, align 4, !dbg !413
  %10 = call i32 asm sideeffect "1:\0Aldar ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.ne 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !414, !srcloc !415
  store i32 %10, i32* %5, align 4, !dbg !414
  %11 = load i32, i32* %5, align 4, !dbg !416
  ret i32 %11, !dbg !417
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !418 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !419, metadata !DIExpression()), !dbg !420
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !421, metadata !DIExpression()), !dbg !422
  %5 = load i32, i32* %4, align 4, !dbg !423
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !424
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !425
  %8 = load i32, i32* %7, align 4, !dbg !425
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !426, !srcloc !427
  ret void, !dbg !428
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!57, !58, !59, !60, !61, !62, !63}
!llvm.ident = !{!64}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !56, line: 100, type: !22, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !28, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/spinlock/test/clhlock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "d9a0d1400f34b9e68a8cfdc2f0fcae48")
!4 = !{!5, !6, !11}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 37, baseType: !8)
!7 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !9, line: 90, baseType: !10)
!9 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "clh_qnode_t", file: !13, line: 29, baseType: !14)
!13 = !DIFile(filename: "spinlock/include/vsync/spinlock/clhlock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "bf019b0569fb22703e50d27147945a6b")
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "clh_qnode_s", file: !13, line: 27, size: 32, elements: !15)
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "locked", scope: !14, file: !13, line: 28, baseType: !17, size: 32, align: 32)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !18, line: 34, baseType: !19)
!18 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !18, line: 32, size: 32, align: 32, elements: !20)
!20 = !{!21}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !19, file: !18, line: 33, baseType: !22, size: 32)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !7, line: 35, baseType: !23)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !24, line: 26, baseType: !25)
!24 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !26, line: 42, baseType: !27)
!26 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!27 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!28 = !{!29, !41, !43, !0, !54}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !31, line: 8, type: !32, isLocal: false, isDefinition: true)
!31 = !DIFile(filename: "spinlock/test/clhlock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "d9a0d1400f34b9e68a8cfdc2f0fcae48")
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "clhlock_t", file: !13, line: 41, baseType: !33)
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "clhlock_s", file: !13, line: 38, size: 128, elements: !34)
!34 = !{!35, !40}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !33, file: !13, line: 39, baseType: !36, size: 64, align: 64)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomicptr_t", file: !18, line: 44, baseType: !37)
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomicptr_s", file: !18, line: 42, size: 64, align: 64, elements: !38)
!38 = !{!39}
!39 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !37, file: !18, line: 43, baseType: !5, size: 64)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "initial", scope: !33, file: !13, line: 40, baseType: !12, size: 32, offset: 64)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(name: "initial", scope: !2, file: !31, line: 9, type: !12, isLocal: false, isDefinition: true)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(name: "node", scope: !2, file: !31, line: 10, type: !45, isLocal: false, isDefinition: true)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 576, elements: !52)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "clh_node_t", file: !13, line: 35, baseType: !47)
!47 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "clh_node_s", file: !13, line: 31, size: 192, elements: !48)
!48 = !{!49, !50, !51}
!49 = !DIDerivedType(tag: DW_TAG_member, name: "pred", scope: !47, file: !13, line: 32, baseType: !11, size: 64)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "qnode", scope: !47, file: !13, line: 33, baseType: !11, size: 64, offset: 64)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "_qnode", scope: !47, file: !13, line: 34, baseType: !12, size: 32, offset: 128)
!52 = !{!53}
!53 = !DISubrange(count: 3)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !56, line: 101, type: !22, isLocal: true, isDefinition: true)
!56 = !DIFile(filename: "utils/include/test/boilerplate/lock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4187ade4a536ecfd1f9ed3ab727ca965")
!57 = !{i32 7, !"Dwarf Version", i32 5}
!58 = !{i32 2, !"Debug Info Version", i32 3}
!59 = !{i32 1, !"wchar_size", i32 4}
!60 = !{i32 7, !"PIC Level", i32 2}
!61 = !{i32 7, !"PIE Level", i32 2}
!62 = !{i32 7, !"uwtable", i32 1}
!63 = !{i32 7, !"frame-pointer", i32 2}
!64 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!65 = distinct !DISubprogram(name: "post", scope: !56, file: !56, line: 77, type: !66, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!66 = !DISubroutineType(types: !67)
!67 = !{null}
!68 = !{}
!69 = !DILocation(line: 79, column: 1, scope: !65)
!70 = distinct !DISubprogram(name: "fini", scope: !56, file: !56, line: 86, type: !66, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!71 = !DILocation(line: 88, column: 1, scope: !70)
!72 = distinct !DISubprogram(name: "cs", scope: !56, file: !56, line: 104, type: !66, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!73 = !DILocation(line: 106, column: 11, scope: !72)
!74 = !DILocation(line: 107, column: 11, scope: !72)
!75 = !DILocation(line: 108, column: 1, scope: !72)
!76 = distinct !DISubprogram(name: "check", scope: !56, file: !56, line: 110, type: !66, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!77 = !DILocation(line: 112, column: 5, scope: !78)
!78 = distinct !DILexicalBlock(scope: !79, file: !56, line: 112, column: 5)
!79 = distinct !DILexicalBlock(scope: !76, file: !56, line: 112, column: 5)
!80 = !DILocation(line: 112, column: 5, scope: !79)
!81 = !DILocation(line: 113, column: 5, scope: !82)
!82 = distinct !DILexicalBlock(scope: !83, file: !56, line: 113, column: 5)
!83 = distinct !DILexicalBlock(scope: !76, file: !56, line: 113, column: 5)
!84 = !DILocation(line: 113, column: 5, scope: !83)
!85 = !DILocation(line: 114, column: 1, scope: !76)
!86 = distinct !DISubprogram(name: "main", scope: !56, file: !56, line: 141, type: !87, scopeLine: 142, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!87 = !DISubroutineType(types: !88)
!88 = !{!89}
!89 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!90 = !DILocalVariable(name: "t", scope: !86, file: !56, line: 143, type: !91)
!91 = !DICompositeType(tag: DW_TAG_array_type, baseType: !92, size: 192, elements: !52)
!92 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !93, line: 27, baseType: !10)
!93 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!94 = !DILocation(line: 143, column: 15, scope: !86)
!95 = !DILocation(line: 150, column: 5, scope: !86)
!96 = !DILocalVariable(name: "i", scope: !97, file: !56, line: 152, type: !6)
!97 = distinct !DILexicalBlock(scope: !86, file: !56, line: 152, column: 5)
!98 = !DILocation(line: 152, column: 21, scope: !97)
!99 = !DILocation(line: 152, column: 10, scope: !97)
!100 = !DILocation(line: 152, column: 28, scope: !101)
!101 = distinct !DILexicalBlock(scope: !97, file: !56, line: 152, column: 5)
!102 = !DILocation(line: 152, column: 30, scope: !101)
!103 = !DILocation(line: 152, column: 5, scope: !97)
!104 = !DILocation(line: 153, column: 33, scope: !105)
!105 = distinct !DILexicalBlock(scope: !101, file: !56, line: 152, column: 47)
!106 = !DILocation(line: 153, column: 31, scope: !105)
!107 = !DILocation(line: 153, column: 53, scope: !105)
!108 = !DILocation(line: 153, column: 45, scope: !105)
!109 = !DILocation(line: 153, column: 15, scope: !105)
!110 = !DILocation(line: 154, column: 5, scope: !105)
!111 = !DILocation(line: 152, column: 43, scope: !101)
!112 = !DILocation(line: 152, column: 5, scope: !101)
!113 = distinct !{!113, !103, !114, !115}
!114 = !DILocation(line: 154, column: 5, scope: !97)
!115 = !{!"llvm.loop.mustprogress"}
!116 = !DILocation(line: 156, column: 5, scope: !86)
!117 = !DILocalVariable(name: "i", scope: !118, file: !56, line: 158, type: !6)
!118 = distinct !DILexicalBlock(scope: !86, file: !56, line: 158, column: 5)
!119 = !DILocation(line: 158, column: 21, scope: !118)
!120 = !DILocation(line: 158, column: 10, scope: !118)
!121 = !DILocation(line: 158, column: 28, scope: !122)
!122 = distinct !DILexicalBlock(scope: !118, file: !56, line: 158, column: 5)
!123 = !DILocation(line: 158, column: 30, scope: !122)
!124 = !DILocation(line: 158, column: 5, scope: !118)
!125 = !DILocation(line: 159, column: 30, scope: !126)
!126 = distinct !DILexicalBlock(scope: !122, file: !56, line: 158, column: 47)
!127 = !DILocation(line: 159, column: 28, scope: !126)
!128 = !DILocation(line: 159, column: 15, scope: !126)
!129 = !DILocation(line: 160, column: 5, scope: !126)
!130 = !DILocation(line: 158, column: 43, scope: !122)
!131 = !DILocation(line: 158, column: 5, scope: !122)
!132 = distinct !{!132, !124, !133, !115}
!133 = !DILocation(line: 160, column: 5, scope: !118)
!134 = !DILocation(line: 167, column: 5, scope: !86)
!135 = !DILocation(line: 168, column: 5, scope: !86)
!136 = !DILocation(line: 170, column: 5, scope: !86)
!137 = distinct !DISubprogram(name: "init", scope: !31, file: !31, line: 13, type: !66, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!138 = !DILocation(line: 15, column: 5, scope: !137)
!139 = !DILocalVariable(name: "i", scope: !140, file: !31, line: 17, type: !89)
!140 = distinct !DILexicalBlock(scope: !137, file: !31, line: 17, column: 5)
!141 = !DILocation(line: 17, column: 14, scope: !140)
!142 = !DILocation(line: 17, column: 10, scope: !140)
!143 = !DILocation(line: 17, column: 21, scope: !144)
!144 = distinct !DILexicalBlock(scope: !140, file: !31, line: 17, column: 5)
!145 = !DILocation(line: 17, column: 23, scope: !144)
!146 = !DILocation(line: 17, column: 5, scope: !140)
!147 = !DILocation(line: 18, column: 33, scope: !148)
!148 = distinct !DILexicalBlock(scope: !144, file: !31, line: 17, column: 40)
!149 = !DILocation(line: 18, column: 28, scope: !148)
!150 = !DILocation(line: 18, column: 9, scope: !148)
!151 = !DILocation(line: 19, column: 5, scope: !148)
!152 = !DILocation(line: 17, column: 36, scope: !144)
!153 = !DILocation(line: 17, column: 5, scope: !144)
!154 = distinct !{!154, !146, !155, !115}
!155 = !DILocation(line: 19, column: 5, scope: !140)
!156 = !DILocation(line: 20, column: 1, scope: !137)
!157 = distinct !DISubprogram(name: "run", scope: !56, file: !56, line: 119, type: !158, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!158 = !DISubroutineType(types: !159)
!159 = !{!5, !5}
!160 = !DILocalVariable(name: "arg", arg: 1, scope: !157, file: !56, line: 119, type: !5)
!161 = !DILocation(line: 119, column: 11, scope: !157)
!162 = !DILocalVariable(name: "tid", scope: !157, file: !56, line: 121, type: !22)
!163 = !DILocation(line: 121, column: 15, scope: !157)
!164 = !DILocation(line: 121, column: 33, scope: !157)
!165 = !DILocation(line: 121, column: 21, scope: !157)
!166 = !DILocalVariable(name: "i", scope: !167, file: !56, line: 125, type: !89)
!167 = distinct !DILexicalBlock(scope: !157, file: !56, line: 125, column: 5)
!168 = !DILocation(line: 125, column: 14, scope: !167)
!169 = !DILocation(line: 125, column: 10, scope: !167)
!170 = !DILocation(line: 125, column: 21, scope: !171)
!171 = distinct !DILexicalBlock(scope: !167, file: !56, line: 125, column: 5)
!172 = !DILocation(line: 125, column: 23, scope: !171)
!173 = !DILocation(line: 125, column: 28, scope: !171)
!174 = !DILocation(line: 125, column: 31, scope: !171)
!175 = !DILocation(line: 0, scope: !171)
!176 = !DILocation(line: 125, column: 5, scope: !167)
!177 = !DILocalVariable(name: "j", scope: !178, file: !56, line: 129, type: !89)
!178 = distinct !DILexicalBlock(scope: !179, file: !56, line: 129, column: 9)
!179 = distinct !DILexicalBlock(scope: !171, file: !56, line: 125, column: 63)
!180 = !DILocation(line: 129, column: 18, scope: !178)
!181 = !DILocation(line: 129, column: 14, scope: !178)
!182 = !DILocation(line: 129, column: 25, scope: !183)
!183 = distinct !DILexicalBlock(scope: !178, file: !56, line: 129, column: 9)
!184 = !DILocation(line: 129, column: 27, scope: !183)
!185 = !DILocation(line: 129, column: 32, scope: !183)
!186 = !DILocation(line: 129, column: 35, scope: !183)
!187 = !DILocation(line: 0, scope: !183)
!188 = !DILocation(line: 129, column: 9, scope: !178)
!189 = !DILocation(line: 130, column: 21, scope: !190)
!190 = distinct !DILexicalBlock(scope: !183, file: !56, line: 129, column: 67)
!191 = !DILocation(line: 130, column: 13, scope: !190)
!192 = !DILocation(line: 131, column: 13, scope: !190)
!193 = !DILocation(line: 132, column: 9, scope: !190)
!194 = !DILocation(line: 129, column: 63, scope: !183)
!195 = !DILocation(line: 129, column: 9, scope: !183)
!196 = distinct !{!196, !188, !197, !115}
!197 = !DILocation(line: 132, column: 9, scope: !178)
!198 = !DILocalVariable(name: "j", scope: !199, file: !56, line: 133, type: !89)
!199 = distinct !DILexicalBlock(scope: !179, file: !56, line: 133, column: 9)
!200 = !DILocation(line: 133, column: 18, scope: !199)
!201 = !DILocation(line: 133, column: 14, scope: !199)
!202 = !DILocation(line: 133, column: 25, scope: !203)
!203 = distinct !DILexicalBlock(scope: !199, file: !56, line: 133, column: 9)
!204 = !DILocation(line: 133, column: 27, scope: !203)
!205 = !DILocation(line: 133, column: 32, scope: !203)
!206 = !DILocation(line: 133, column: 35, scope: !203)
!207 = !DILocation(line: 0, scope: !203)
!208 = !DILocation(line: 133, column: 9, scope: !199)
!209 = !DILocation(line: 134, column: 21, scope: !210)
!210 = distinct !DILexicalBlock(scope: !203, file: !56, line: 133, column: 67)
!211 = !DILocation(line: 134, column: 13, scope: !210)
!212 = !DILocation(line: 135, column: 9, scope: !210)
!213 = !DILocation(line: 133, column: 63, scope: !203)
!214 = !DILocation(line: 133, column: 9, scope: !203)
!215 = distinct !{!215, !208, !216, !115}
!216 = !DILocation(line: 135, column: 9, scope: !199)
!217 = !DILocation(line: 136, column: 5, scope: !179)
!218 = !DILocation(line: 125, column: 59, scope: !171)
!219 = !DILocation(line: 125, column: 5, scope: !171)
!220 = distinct !{!220, !176, !221, !115}
!221 = !DILocation(line: 136, column: 5, scope: !167)
!222 = !DILocation(line: 137, column: 5, scope: !157)
!223 = distinct !DISubprogram(name: "clhlock_init", scope: !13, file: !13, line: 61, type: !224, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!224 = !DISubroutineType(types: !225)
!225 = !{null, !226}
!226 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!227 = !DILocalVariable(name: "lock", arg: 1, scope: !223, file: !13, line: 61, type: !226)
!228 = !DILocation(line: 61, column: 25, scope: !223)
!229 = !DILocation(line: 63, column: 21, scope: !223)
!230 = !DILocation(line: 63, column: 27, scope: !223)
!231 = !DILocation(line: 63, column: 35, scope: !223)
!232 = !DILocation(line: 63, column: 5, scope: !223)
!233 = !DILocation(line: 64, column: 22, scope: !223)
!234 = !DILocation(line: 64, column: 28, scope: !223)
!235 = !DILocation(line: 64, column: 35, scope: !223)
!236 = !DILocation(line: 64, column: 41, scope: !223)
!237 = !DILocation(line: 64, column: 34, scope: !223)
!238 = !DILocation(line: 64, column: 5, scope: !223)
!239 = !DILocation(line: 65, column: 1, scope: !223)
!240 = distinct !DISubprogram(name: "clhlock_node_init", scope: !13, file: !13, line: 49, type: !241, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!241 = !DISubroutineType(types: !242)
!242 = !{null, !243}
!243 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!244 = !DILocalVariable(name: "node", arg: 1, scope: !240, file: !13, line: 49, type: !243)
!245 = !DILocation(line: 49, column: 31, scope: !240)
!246 = !DILocation(line: 51, column: 21, scope: !240)
!247 = !DILocation(line: 51, column: 27, scope: !240)
!248 = !DILocation(line: 51, column: 34, scope: !240)
!249 = !DILocation(line: 51, column: 5, scope: !240)
!250 = !DILocation(line: 52, column: 20, scope: !240)
!251 = !DILocation(line: 52, column: 26, scope: !240)
!252 = !DILocation(line: 52, column: 5, scope: !240)
!253 = !DILocation(line: 52, column: 11, scope: !240)
!254 = !DILocation(line: 52, column: 17, scope: !240)
!255 = !DILocation(line: 53, column: 5, scope: !240)
!256 = !DILocation(line: 53, column: 11, scope: !240)
!257 = !DILocation(line: 53, column: 17, scope: !240)
!258 = !DILocation(line: 54, column: 1, scope: !240)
!259 = distinct !DISubprogram(name: "acquire", scope: !31, file: !31, line: 23, type: !260, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!260 = !DISubroutineType(types: !261)
!261 = !{null, !22}
!262 = !DILocalVariable(name: "tid", arg: 1, scope: !259, file: !31, line: 23, type: !22)
!263 = !DILocation(line: 23, column: 19, scope: !259)
!264 = !DILocation(line: 25, column: 34, scope: !259)
!265 = !DILocation(line: 25, column: 29, scope: !259)
!266 = !DILocation(line: 25, column: 5, scope: !259)
!267 = !DILocation(line: 26, column: 1, scope: !259)
!268 = distinct !DISubprogram(name: "clhlock_acquire", scope: !13, file: !13, line: 75, type: !269, scopeLine: 76, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!269 = !DISubroutineType(types: !270)
!270 = !{null, !226, !243}
!271 = !DILocalVariable(name: "lock", arg: 1, scope: !268, file: !13, line: 75, type: !226)
!272 = !DILocation(line: 75, column: 28, scope: !268)
!273 = !DILocalVariable(name: "node", arg: 2, scope: !268, file: !13, line: 75, type: !243)
!274 = !DILocation(line: 75, column: 46, scope: !268)
!275 = !DILocation(line: 78, column: 26, scope: !268)
!276 = !DILocation(line: 78, column: 32, scope: !268)
!277 = !DILocation(line: 78, column: 39, scope: !268)
!278 = !DILocation(line: 78, column: 5, scope: !268)
!279 = !DILocation(line: 83, column: 50, scope: !268)
!280 = !DILocation(line: 83, column: 56, scope: !268)
!281 = !DILocation(line: 83, column: 62, scope: !268)
!282 = !DILocation(line: 83, column: 68, scope: !268)
!283 = !DILocation(line: 83, column: 33, scope: !268)
!284 = !DILocation(line: 83, column: 18, scope: !268)
!285 = !DILocation(line: 83, column: 5, scope: !268)
!286 = !DILocation(line: 83, column: 11, scope: !268)
!287 = !DILocation(line: 83, column: 16, scope: !268)
!288 = !DILocation(line: 86, column: 29, scope: !268)
!289 = !DILocation(line: 86, column: 35, scope: !268)
!290 = !DILocation(line: 86, column: 41, scope: !268)
!291 = !DILocation(line: 86, column: 5, scope: !268)
!292 = !DILocation(line: 89, column: 1, scope: !268)
!293 = distinct !DISubprogram(name: "release", scope: !31, file: !31, line: 29, type: !260, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !68)
!294 = !DILocalVariable(name: "tid", arg: 1, scope: !293, file: !31, line: 29, type: !22)
!295 = !DILocation(line: 29, column: 19, scope: !293)
!296 = !DILocation(line: 31, column: 34, scope: !293)
!297 = !DILocation(line: 31, column: 29, scope: !293)
!298 = !DILocation(line: 31, column: 5, scope: !293)
!299 = !DILocation(line: 32, column: 1, scope: !293)
!300 = distinct !DISubprogram(name: "clhlock_release", scope: !13, file: !13, line: 99, type: !269, scopeLine: 100, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!301 = !DILocalVariable(name: "lock", arg: 1, scope: !300, file: !13, line: 99, type: !226)
!302 = !DILocation(line: 99, column: 28, scope: !300)
!303 = !DILocalVariable(name: "node", arg: 2, scope: !300, file: !13, line: 99, type: !243)
!304 = !DILocation(line: 99, column: 46, scope: !300)
!305 = !DILocation(line: 102, column: 26, scope: !300)
!306 = !DILocation(line: 102, column: 32, scope: !300)
!307 = !DILocation(line: 102, column: 39, scope: !300)
!308 = !DILocation(line: 102, column: 5, scope: !300)
!309 = !DILocation(line: 105, column: 19, scope: !300)
!310 = !DILocation(line: 105, column: 25, scope: !300)
!311 = !DILocation(line: 105, column: 5, scope: !300)
!312 = !DILocation(line: 105, column: 11, scope: !300)
!313 = !DILocation(line: 105, column: 17, scope: !300)
!314 = !DILocation(line: 107, column: 5, scope: !300)
!315 = !DILocation(line: 107, column: 5, scope: !316)
!316 = distinct !DILexicalBlock(scope: !300, file: !13, line: 107, column: 5)
!317 = !DILocation(line: 107, column: 5, scope: !318)
!318 = distinct !DILexicalBlock(scope: !316, file: !13, line: 107, column: 5)
!319 = !DILocation(line: 107, column: 5, scope: !320)
!320 = distinct !DILexicalBlock(scope: !318, file: !13, line: 107, column: 5)
!321 = !DILocation(line: 108, column: 1, scope: !300)
!322 = distinct !DISubprogram(name: "vatomic32_init", scope: !323, file: !323, line: 4189, type: !324, scopeLine: 4190, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!323 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!324 = !DISubroutineType(types: !325)
!325 = !{null, !326, !22}
!326 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!327 = !DILocalVariable(name: "a", arg: 1, scope: !322, file: !323, line: 4189, type: !326)
!328 = !DILocation(line: 4189, column: 29, scope: !322)
!329 = !DILocalVariable(name: "v", arg: 2, scope: !322, file: !323, line: 4189, type: !22)
!330 = !DILocation(line: 4189, column: 42, scope: !322)
!331 = !DILocation(line: 4191, column: 21, scope: !322)
!332 = !DILocation(line: 4191, column: 24, scope: !322)
!333 = !DILocation(line: 4191, column: 5, scope: !322)
!334 = !DILocation(line: 4192, column: 1, scope: !322)
!335 = distinct !DISubprogram(name: "vatomicptr_init", scope: !323, file: !323, line: 4222, type: !336, scopeLine: 4223, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!336 = !DISubroutineType(types: !337)
!337 = !{null, !338, !5}
!338 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!339 = !DILocalVariable(name: "a", arg: 1, scope: !335, file: !323, line: 4222, type: !338)
!340 = !DILocation(line: 4222, column: 31, scope: !335)
!341 = !DILocalVariable(name: "v", arg: 2, scope: !335, file: !323, line: 4222, type: !5)
!342 = !DILocation(line: 4222, column: 40, scope: !335)
!343 = !DILocation(line: 4224, column: 22, scope: !335)
!344 = !DILocation(line: 4224, column: 25, scope: !335)
!345 = !DILocation(line: 4224, column: 5, scope: !335)
!346 = !DILocation(line: 4225, column: 1, scope: !335)
!347 = distinct !DISubprogram(name: "vatomic32_write", scope: !348, file: !348, line: 213, type: !324, scopeLine: 214, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!348 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!349 = !DILocalVariable(name: "a", arg: 1, scope: !347, file: !348, line: 213, type: !326)
!350 = !DILocation(line: 213, column: 30, scope: !347)
!351 = !DILocalVariable(name: "v", arg: 2, scope: !347, file: !348, line: 213, type: !22)
!352 = !DILocation(line: 213, column: 43, scope: !347)
!353 = !DILocation(line: 217, column: 32, scope: !347)
!354 = !DILocation(line: 217, column: 44, scope: !347)
!355 = !DILocation(line: 217, column: 47, scope: !347)
!356 = !DILocation(line: 215, column: 5, scope: !347)
!357 = !{i64 402790}
!358 = !DILocation(line: 219, column: 1, scope: !347)
!359 = distinct !DISubprogram(name: "vatomicptr_write", scope: !348, file: !348, line: 297, type: !336, scopeLine: 298, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!360 = !DILocalVariable(name: "a", arg: 1, scope: !359, file: !348, line: 297, type: !338)
!361 = !DILocation(line: 297, column: 32, scope: !359)
!362 = !DILocalVariable(name: "v", arg: 2, scope: !359, file: !348, line: 297, type: !5)
!363 = !DILocation(line: 297, column: 41, scope: !359)
!364 = !DILocation(line: 301, column: 32, scope: !359)
!365 = !DILocation(line: 301, column: 44, scope: !359)
!366 = !DILocation(line: 301, column: 47, scope: !359)
!367 = !DILocation(line: 299, column: 5, scope: !359)
!368 = !{i64 405577}
!369 = !DILocation(line: 303, column: 1, scope: !359)
!370 = distinct !DISubprogram(name: "vatomic32_write_rlx", scope: !348, file: !348, line: 241, type: !324, scopeLine: 242, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!371 = !DILocalVariable(name: "a", arg: 1, scope: !370, file: !348, line: 241, type: !326)
!372 = !DILocation(line: 241, column: 34, scope: !370)
!373 = !DILocalVariable(name: "v", arg: 2, scope: !370, file: !348, line: 241, type: !22)
!374 = !DILocation(line: 241, column: 47, scope: !370)
!375 = !DILocation(line: 245, column: 32, scope: !370)
!376 = !DILocation(line: 245, column: 44, scope: !370)
!377 = !DILocation(line: 245, column: 47, scope: !370)
!378 = !DILocation(line: 243, column: 5, scope: !370)
!379 = !{i64 403730}
!380 = !DILocation(line: 247, column: 1, scope: !370)
!381 = distinct !DISubprogram(name: "vatomicptr_xchg", scope: !382, file: !382, line: 198, type: !383, scopeLine: 199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!382 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!383 = !DISubroutineType(types: !384)
!384 = !{!5, !338, !5}
!385 = !DILocalVariable(name: "a", arg: 1, scope: !381, file: !382, line: 198, type: !338)
!386 = !DILocation(line: 198, column: 31, scope: !381)
!387 = !DILocalVariable(name: "v", arg: 2, scope: !381, file: !382, line: 198, type: !5)
!388 = !DILocation(line: 198, column: 40, scope: !381)
!389 = !DILocalVariable(name: "oldv", scope: !381, file: !382, line: 200, type: !5)
!390 = !DILocation(line: 200, column: 11, scope: !381)
!391 = !DILocalVariable(name: "tmp", scope: !381, file: !382, line: 201, type: !22)
!392 = !DILocation(line: 201, column: 15, scope: !381)
!393 = !DILocation(line: 209, column: 22, scope: !381)
!394 = !DILocation(line: 209, column: 34, scope: !381)
!395 = !DILocation(line: 209, column: 37, scope: !381)
!396 = !DILocation(line: 202, column: 5, scope: !381)
!397 = !{i64 460838, i64 460872, i64 460887, i64 460920, i64 460963}
!398 = !DILocation(line: 211, column: 12, scope: !381)
!399 = !DILocation(line: 211, column: 5, scope: !381)
!400 = distinct !DISubprogram(name: "vatomic32_await_eq_acq", scope: !348, file: !348, line: 604, type: !401, scopeLine: 605, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!401 = !DISubroutineType(types: !402)
!402 = !{!22, !403, !22}
!403 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !404, size: 64)
!404 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!405 = !DILocalVariable(name: "a", arg: 1, scope: !400, file: !348, line: 604, type: !403)
!406 = !DILocation(line: 604, column: 43, scope: !400)
!407 = !DILocalVariable(name: "v", arg: 2, scope: !400, file: !348, line: 604, type: !22)
!408 = !DILocation(line: 604, column: 56, scope: !400)
!409 = !DILocalVariable(name: "val", scope: !400, file: !348, line: 606, type: !22)
!410 = !DILocation(line: 606, column: 15, scope: !400)
!411 = !DILocation(line: 613, column: 21, scope: !400)
!412 = !DILocation(line: 613, column: 33, scope: !400)
!413 = !DILocation(line: 613, column: 36, scope: !400)
!414 = !DILocation(line: 607, column: 5, scope: !400)
!415 = !{i64 413882, i64 413898, i64 413929, i64 413962}
!416 = !DILocation(line: 615, column: 12, scope: !400)
!417 = !DILocation(line: 615, column: 5, scope: !400)
!418 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !348, file: !348, line: 227, type: !324, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !68)
!419 = !DILocalVariable(name: "a", arg: 1, scope: !418, file: !348, line: 227, type: !326)
!420 = !DILocation(line: 227, column: 34, scope: !418)
!421 = !DILocalVariable(name: "v", arg: 2, scope: !418, file: !348, line: 227, type: !22)
!422 = !DILocation(line: 227, column: 47, scope: !418)
!423 = !DILocation(line: 231, column: 32, scope: !418)
!424 = !DILocation(line: 231, column: 44, scope: !418)
!425 = !DILocation(line: 231, column: 47, scope: !418)
!426 = !DILocation(line: 229, column: 5, scope: !418)
!427 = !{i64 403260}
!428 = !DILocation(line: 233, column: 1, scope: !418)
