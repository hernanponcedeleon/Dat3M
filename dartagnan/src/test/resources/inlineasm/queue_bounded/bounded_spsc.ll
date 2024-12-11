; ModuleID = '/home/stefano/huawei/libvsync/datastruct/queue/bounded/test/bounded_spsc.c'
source_filename = "/home/stefano/huawei/libvsync/datastruct/queue/bounded/test/bounded_spsc.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.point_s = type { i32, i32 }
%struct.bounded_spsc_t = type { i8**, %struct.vatomic32_s, %struct.vatomic32_s, i32 }
%struct.vatomic32_s = type { i32 }
%struct.run_info_t = type { i64, i64, i8, i8* (i8*)* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_points = dso_local global [3 x %struct.point_s*] zeroinitializer, align 16, !dbg !0
@g_queue = dso_local global %struct.bounded_spsc_t zeroinitializer, align 8, !dbg !58
@.str = private unnamed_addr constant [21 x i8] c"point->x == point->y\00", align 1
@.str.1 = private unnamed_addr constant [75 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/bounded/test/bounded_spsc.c\00", align 1
@__PRETTY_FUNCTION__.run = private unnamed_addr constant [18 x i8] c"void *run(void *)\00", align 1
@.str.2 = private unnamed_addr constant [14 x i8] c"point->x == 1\00", align 1
@.str.3 = private unnamed_addr constant [21 x i8] c"0 && \22dequeued NULL\22\00", align 1
@g_buf = dso_local global [2 x i8*] zeroinitializer, align 16, !dbg !53
@.str.4 = private unnamed_addr constant [25 x i8] c"0 && \22allocation failed\22\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@g_cs_x = dso_local global %struct.vatomic32_s zeroinitializer, align 4, !dbg !74
@.str.5 = private unnamed_addr constant [10 x i8] c"q == NULL\00", align 1
@.str.6 = private unnamed_addr constant [17 x i8] c"q && \22q == NULL\22\00", align 1
@.str.7 = private unnamed_addr constant [90 x i8] c"/home/stefano/huawei/libvsync/datastruct/queue/bounded/include/vsync/queue/bounded_spsc.h\00", align 1
@__PRETTY_FUNCTION__.bounded_spsc_enq = private unnamed_addr constant [57 x i8] c"bounded_ret_t bounded_spsc_enq(bounded_spsc_t *, void *)\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"v == NULL\00", align 1
@.str.9 = private unnamed_addr constant [17 x i8] c"v && \22v == NULL\22\00", align 1
@__PRETTY_FUNCTION__.bounded_spsc_deq = private unnamed_addr constant [58 x i8] c"bounded_ret_t bounded_spsc_deq(bounded_spsc_t *, void **)\00", align 1
@.str.10 = private unnamed_addr constant [15 x i8] c"buffer is NULL\00", align 1
@.str.11 = private unnamed_addr constant [22 x i8] c"b && \22buffer is NULL\22\00", align 1
@__PRETTY_FUNCTION__.bounded_spsc_init = private unnamed_addr constant [61 x i8] c"void bounded_spsc_init(bounded_spsc_t *, void **, vuint32_t)\00", align 1
@.str.12 = private unnamed_addr constant [19 x i8] c"buffer with 0 size\00", align 1
@.str.13 = private unnamed_addr constant [31 x i8] c"s != 0 && \22buffer with 0 size\22\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !87 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca %struct.point_s*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i8*, align 8
  %8 = alloca %struct.point_s*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !89, metadata !DIExpression()), !dbg !90
  call void @llvm.dbg.declare(metadata i64* %3, metadata !91, metadata !DIExpression()), !dbg !92
  %9 = load i8*, i8** %2, align 8, !dbg !93
  %10 = ptrtoint i8* %9 to i64, !dbg !94
  store i64 %10, i64* %3, align 8, !dbg !92
  %11 = load i64, i64* %3, align 8, !dbg !95
  %12 = icmp eq i64 %11, 0, !dbg !97
  br i1 %12, label %13, label %36, !dbg !98

13:                                               ; preds = %1
  call void @llvm.dbg.declare(metadata i64* %4, metadata !99, metadata !DIExpression()), !dbg !102
  store i64 0, i64* %4, align 8, !dbg !102
  br label %14, !dbg !103

14:                                               ; preds = %32, %13
  %15 = load i64, i64* %4, align 8, !dbg !104
  %16 = icmp ult i64 %15, 3, !dbg !106
  br i1 %16, label %17, label %35, !dbg !107

17:                                               ; preds = %14
  call void @llvm.dbg.declare(metadata %struct.point_s** %5, metadata !108, metadata !DIExpression()), !dbg !110
  %18 = load i64, i64* %4, align 8, !dbg !111
  %19 = getelementptr inbounds [3 x %struct.point_s*], [3 x %struct.point_s*]* @g_points, i64 0, i64 %18, !dbg !112
  %20 = load %struct.point_s*, %struct.point_s** %19, align 8, !dbg !112
  store %struct.point_s* %20, %struct.point_s** %5, align 8, !dbg !110
  %21 = load %struct.point_s*, %struct.point_s** %5, align 8, !dbg !113
  %22 = getelementptr inbounds %struct.point_s, %struct.point_s* %21, i32 0, i32 0, !dbg !114
  store i32 1, i32* %22, align 4, !dbg !115
  %23 = load %struct.point_s*, %struct.point_s** %5, align 8, !dbg !116
  %24 = getelementptr inbounds %struct.point_s, %struct.point_s* %23, i32 0, i32 1, !dbg !117
  store i32 1, i32* %24, align 4, !dbg !118
  br label %25, !dbg !119

25:                                               ; preds = %30, %17
  %26 = load %struct.point_s*, %struct.point_s** %5, align 8, !dbg !119
  %27 = bitcast %struct.point_s* %26 to i8*, !dbg !119
  %28 = call i32 @bounded_spsc_enq(%struct.bounded_spsc_t* noundef @g_queue, i8* noundef %27), !dbg !119
  %29 = icmp ne i32 %28, 0, !dbg !119
  br i1 %29, label %30, label %31, !dbg !119

30:                                               ; preds = %25
  br label %25, !dbg !119, !llvm.loop !120

31:                                               ; preds = %25
  br label %32, !dbg !123

32:                                               ; preds = %31
  %33 = load i64, i64* %4, align 8, !dbg !124
  %34 = add i64 %33, 1, !dbg !124
  store i64 %34, i64* %4, align 8, !dbg !124
  br label %14, !dbg !125, !llvm.loop !126

35:                                               ; preds = %14
  br label %76, !dbg !128

36:                                               ; preds = %1
  call void @llvm.dbg.declare(metadata i32* %6, metadata !129, metadata !DIExpression()), !dbg !133
  store i32 0, i32* %6, align 4, !dbg !133
  br label %37, !dbg !134

37:                                               ; preds = %72, %36
  %38 = load i32, i32* %6, align 4, !dbg !135
  %39 = icmp slt i32 %38, 3, !dbg !137
  br i1 %39, label %40, label %75, !dbg !138

40:                                               ; preds = %37
  call void @llvm.dbg.declare(metadata i8** %7, metadata !139, metadata !DIExpression()), !dbg !141
  store i8* null, i8** %7, align 8, !dbg !141
  br label %41, !dbg !142

41:                                               ; preds = %44, %40
  %42 = call i32 @bounded_spsc_deq(%struct.bounded_spsc_t* noundef @g_queue, i8** noundef %7), !dbg !142
  %43 = icmp ne i32 %42, 0, !dbg !142
  br i1 %43, label %44, label %45, !dbg !142

44:                                               ; preds = %41
  br label %41, !dbg !142, !llvm.loop !143

45:                                               ; preds = %41
  call void @llvm.dbg.declare(metadata %struct.point_s** %8, metadata !145, metadata !DIExpression()), !dbg !146
  %46 = load i8*, i8** %7, align 8, !dbg !147
  %47 = bitcast i8* %46 to %struct.point_s*, !dbg !148
  store %struct.point_s* %47, %struct.point_s** %8, align 8, !dbg !146
  %48 = load %struct.point_s*, %struct.point_s** %8, align 8, !dbg !149
  %49 = icmp ne %struct.point_s* %48, null, !dbg !149
  br i1 %49, label %50, label %70, !dbg !151

50:                                               ; preds = %45
  %51 = load %struct.point_s*, %struct.point_s** %8, align 8, !dbg !152
  %52 = getelementptr inbounds %struct.point_s, %struct.point_s* %51, i32 0, i32 0, !dbg !152
  %53 = load i32, i32* %52, align 4, !dbg !152
  %54 = load %struct.point_s*, %struct.point_s** %8, align 8, !dbg !152
  %55 = getelementptr inbounds %struct.point_s, %struct.point_s* %54, i32 0, i32 1, !dbg !152
  %56 = load i32, i32* %55, align 4, !dbg !152
  %57 = icmp eq i32 %53, %56, !dbg !152
  br i1 %57, label %58, label %59, !dbg !156

58:                                               ; preds = %50
  br label %60, !dbg !156

59:                                               ; preds = %50
  call void @__assert_fail(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([75 x i8], [75 x i8]* @.str.1, i64 0, i64 0), i32 noundef 44, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !152
  unreachable, !dbg !152

60:                                               ; preds = %58
  %61 = load %struct.point_s*, %struct.point_s** %8, align 8, !dbg !157
  %62 = getelementptr inbounds %struct.point_s, %struct.point_s* %61, i32 0, i32 0, !dbg !157
  %63 = load i32, i32* %62, align 4, !dbg !157
  %64 = icmp eq i32 %63, 1, !dbg !157
  br i1 %64, label %65, label %66, !dbg !160

65:                                               ; preds = %60
  br label %67, !dbg !160

66:                                               ; preds = %60
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([75 x i8], [75 x i8]* @.str.1, i64 0, i64 0), i32 noundef 45, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !157
  unreachable, !dbg !157

67:                                               ; preds = %65
  %68 = load %struct.point_s*, %struct.point_s** %8, align 8, !dbg !161
  %69 = bitcast %struct.point_s* %68 to i8*, !dbg !161
  call void @free(i8* noundef %69) #6, !dbg !162
  br label %71, !dbg !163

70:                                               ; preds = %45
  call void @__assert_fail(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([75 x i8], [75 x i8]* @.str.1, i64 0, i64 0), i32 noundef 48, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !164
  unreachable, !dbg !164

71:                                               ; preds = %67
  br label %72, !dbg !168

72:                                               ; preds = %71
  %73 = load i32, i32* %6, align 4, !dbg !169
  %74 = add nsw i32 %73, 1, !dbg !169
  store i32 %74, i32* %6, align 4, !dbg !169
  br label %37, !dbg !170, !llvm.loop !171

75:                                               ; preds = %37
  br label %76

76:                                               ; preds = %75, %35
  ret i8* null, !dbg !173
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal i32 @bounded_spsc_enq(%struct.bounded_spsc_t* noundef %0, i8* noundef %1) #0 !dbg !174 {
  %3 = alloca i32, align 4
  %4 = alloca %struct.bounded_spsc_t*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.bounded_spsc_t* %0, %struct.bounded_spsc_t** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.bounded_spsc_t** %4, metadata !179, metadata !DIExpression()), !dbg !180
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !181, metadata !DIExpression()), !dbg !182
  %8 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !183
  %9 = icmp ne %struct.bounded_spsc_t* %8, null, !dbg !183
  br i1 %9, label %10, label %12, !dbg !183

10:                                               ; preds = %2
  br i1 true, label %11, label %12, !dbg !186

11:                                               ; preds = %10
  br label %13, !dbg !186

12:                                               ; preds = %10, %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([90 x i8], [90 x i8]* @.str.7, i64 0, i64 0), i32 noundef 66, i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @__PRETTY_FUNCTION__.bounded_spsc_enq, i64 0, i64 0)) #5, !dbg !183
  unreachable, !dbg !183

13:                                               ; preds = %11
  %14 = load i8*, i8** %5, align 8, !dbg !187
  %15 = icmp ne i8* %14, null, !dbg !187
  br i1 %15, label %16, label %18, !dbg !187

16:                                               ; preds = %13
  br i1 true, label %17, label %18, !dbg !190

17:                                               ; preds = %16
  br label %19, !dbg !190

18:                                               ; preds = %16, %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([90 x i8], [90 x i8]* @.str.7, i64 0, i64 0), i32 noundef 67, i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @__PRETTY_FUNCTION__.bounded_spsc_enq, i64 0, i64 0)) #5, !dbg !187
  unreachable, !dbg !187

19:                                               ; preds = %17
  call void @llvm.dbg.declare(metadata i32* %6, metadata !191, metadata !DIExpression()), !dbg !192
  %20 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !193
  %21 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %20, i32 0, i32 2, !dbg !194
  %22 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %21), !dbg !195
  store i32 %22, i32* %6, align 4, !dbg !192
  call void @llvm.dbg.declare(metadata i32* %7, metadata !196, metadata !DIExpression()), !dbg !197
  %23 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !198
  %24 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %23, i32 0, i32 1, !dbg !199
  %25 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %24), !dbg !200
  store i32 %25, i32* %7, align 4, !dbg !197
  %26 = load i32, i32* %6, align 4, !dbg !201
  %27 = load i32, i32* %7, align 4, !dbg !203
  %28 = sub i32 %26, %27, !dbg !204
  %29 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !205
  %30 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %29, i32 0, i32 3, !dbg !206
  %31 = load i32, i32* %30, align 8, !dbg !206
  %32 = icmp eq i32 %28, %31, !dbg !207
  br i1 %32, label %33, label %34, !dbg !208

33:                                               ; preds = %19
  store i32 1, i32* %3, align 4, !dbg !209
  br label %50, !dbg !209

34:                                               ; preds = %19
  %35 = load i8*, i8** %5, align 8, !dbg !211
  %36 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !212
  %37 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %36, i32 0, i32 0, !dbg !213
  %38 = load i8**, i8*** %37, align 8, !dbg !213
  %39 = load i32, i32* %6, align 4, !dbg !214
  %40 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !215
  %41 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %40, i32 0, i32 3, !dbg !216
  %42 = load i32, i32* %41, align 8, !dbg !216
  %43 = urem i32 %39, %42, !dbg !217
  %44 = zext i32 %43 to i64, !dbg !212
  %45 = getelementptr inbounds i8*, i8** %38, i64 %44, !dbg !212
  store i8* %35, i8** %45, align 8, !dbg !218
  %46 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !219
  %47 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %46, i32 0, i32 2, !dbg !220
  %48 = load i32, i32* %6, align 4, !dbg !221
  %49 = add i32 %48, 1, !dbg !222
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %47, i32 noundef %49), !dbg !223
  store i32 0, i32* %3, align 4, !dbg !224
  br label %50, !dbg !224

50:                                               ; preds = %34, %33
  %51 = load i32, i32* %3, align 4, !dbg !225
  ret i32 %51, !dbg !225
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @bounded_spsc_deq(%struct.bounded_spsc_t* noundef %0, i8** noundef %1) #0 !dbg !226 {
  %3 = alloca i32, align 4
  %4 = alloca %struct.bounded_spsc_t*, align 8
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.bounded_spsc_t* %0, %struct.bounded_spsc_t** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.bounded_spsc_t** %4, metadata !229, metadata !DIExpression()), !dbg !230
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !231, metadata !DIExpression()), !dbg !232
  %8 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !233
  %9 = icmp ne %struct.bounded_spsc_t* %8, null, !dbg !233
  br i1 %9, label %10, label %12, !dbg !233

10:                                               ; preds = %2
  br i1 true, label %11, label %12, !dbg !236

11:                                               ; preds = %10
  br label %13, !dbg !236

12:                                               ; preds = %10, %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([90 x i8], [90 x i8]* @.str.7, i64 0, i64 0), i32 noundef 94, i8* noundef getelementptr inbounds ([58 x i8], [58 x i8]* @__PRETTY_FUNCTION__.bounded_spsc_deq, i64 0, i64 0)) #5, !dbg !233
  unreachable, !dbg !233

13:                                               ; preds = %11
  %14 = load i8**, i8*** %5, align 8, !dbg !237
  %15 = icmp ne i8** %14, null, !dbg !237
  br i1 %15, label %16, label %18, !dbg !237

16:                                               ; preds = %13
  br i1 true, label %17, label %18, !dbg !240

17:                                               ; preds = %16
  br label %19, !dbg !240

18:                                               ; preds = %16, %13
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([90 x i8], [90 x i8]* @.str.7, i64 0, i64 0), i32 noundef 95, i8* noundef getelementptr inbounds ([58 x i8], [58 x i8]* @__PRETTY_FUNCTION__.bounded_spsc_deq, i64 0, i64 0)) #5, !dbg !237
  unreachable, !dbg !237

19:                                               ; preds = %17
  call void @llvm.dbg.declare(metadata i32* %6, metadata !241, metadata !DIExpression()), !dbg !242
  %20 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !243
  %21 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %20, i32 0, i32 1, !dbg !244
  %22 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %21), !dbg !245
  store i32 %22, i32* %6, align 4, !dbg !242
  call void @llvm.dbg.declare(metadata i32* %7, metadata !246, metadata !DIExpression()), !dbg !247
  %23 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !248
  %24 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %23, i32 0, i32 2, !dbg !249
  %25 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %24), !dbg !250
  store i32 %25, i32* %7, align 4, !dbg !247
  %26 = load i32, i32* %7, align 4, !dbg !251
  %27 = load i32, i32* %6, align 4, !dbg !253
  %28 = sub i32 %26, %27, !dbg !254
  %29 = icmp eq i32 %28, 0, !dbg !255
  br i1 %29, label %30, label %31, !dbg !256

30:                                               ; preds = %19
  store i32 2, i32* %3, align 4, !dbg !257
  br label %48, !dbg !257

31:                                               ; preds = %19
  %32 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !259
  %33 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %32, i32 0, i32 0, !dbg !260
  %34 = load i8**, i8*** %33, align 8, !dbg !260
  %35 = load i32, i32* %6, align 4, !dbg !261
  %36 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !262
  %37 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %36, i32 0, i32 3, !dbg !263
  %38 = load i32, i32* %37, align 8, !dbg !263
  %39 = urem i32 %35, %38, !dbg !264
  %40 = zext i32 %39 to i64, !dbg !259
  %41 = getelementptr inbounds i8*, i8** %34, i64 %40, !dbg !259
  %42 = load i8*, i8** %41, align 8, !dbg !259
  %43 = load i8**, i8*** %5, align 8, !dbg !265
  store i8* %42, i8** %43, align 8, !dbg !266
  %44 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !267
  %45 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %44, i32 0, i32 1, !dbg !268
  %46 = load i32, i32* %6, align 4, !dbg !269
  %47 = add i32 %46, 1, !dbg !270
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %45, i32 noundef %47), !dbg !271
  store i32 0, i32* %3, align 4, !dbg !272
  br label %48, !dbg !272

48:                                               ; preds = %31, %30
  %49 = load i32, i32* %3, align 4, !dbg !273
  ret i32 %49, !dbg !273
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !274 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @bounded_spsc_init(%struct.bounded_spsc_t* noundef @g_queue, i8** noundef getelementptr inbounds ([2 x i8*], [2 x i8*]* @g_buf, i64 0, i64 0), i32 noundef 2), !dbg !277
  call void @llvm.dbg.declare(metadata i64* %2, metadata !278, metadata !DIExpression()), !dbg !280
  store i64 0, i64* %2, align 8, !dbg !280
  br label %3, !dbg !281

3:                                                ; preds = %17, %0
  %4 = load i64, i64* %2, align 8, !dbg !282
  %5 = icmp ult i64 %4, 3, !dbg !284
  br i1 %5, label %6, label %20, !dbg !285

6:                                                ; preds = %3
  %7 = call noalias i8* @malloc(i64 noundef 8) #6, !dbg !286
  %8 = bitcast i8* %7 to %struct.point_s*, !dbg !286
  %9 = load i64, i64* %2, align 8, !dbg !288
  %10 = getelementptr inbounds [3 x %struct.point_s*], [3 x %struct.point_s*]* @g_points, i64 0, i64 %9, !dbg !289
  store %struct.point_s* %8, %struct.point_s** %10, align 8, !dbg !290
  %11 = load i64, i64* %2, align 8, !dbg !291
  %12 = getelementptr inbounds [3 x %struct.point_s*], [3 x %struct.point_s*]* @g_points, i64 0, i64 %11, !dbg !293
  %13 = load %struct.point_s*, %struct.point_s** %12, align 8, !dbg !293
  %14 = icmp eq %struct.point_s* %13, null, !dbg !294
  br i1 %14, label %15, label %16, !dbg !295

15:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([75 x i8], [75 x i8]* @.str.1, i64 0, i64 0), i32 noundef 62, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !296
  unreachable, !dbg !296

16:                                               ; preds = %6
  br label %17, !dbg !300

17:                                               ; preds = %16
  %18 = load i64, i64* %2, align 8, !dbg !301
  %19 = add i64 %18, 1, !dbg !301
  store i64 %19, i64* %2, align 8, !dbg !301
  br label %3, !dbg !302, !llvm.loop !303

20:                                               ; preds = %3
  call void @launch_threads(i64 noundef 2, i8* (i8*)* noundef @run), !dbg !305
  ret i32 0, !dbg !306
}

; Function Attrs: noinline nounwind uwtable
define internal void @bounded_spsc_init(%struct.bounded_spsc_t* noundef %0, i8** noundef %1, i32 noundef %2) #0 !dbg !307 {
  %4 = alloca %struct.bounded_spsc_t*, align 8
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  store %struct.bounded_spsc_t* %0, %struct.bounded_spsc_t** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.bounded_spsc_t** %4, metadata !310, metadata !DIExpression()), !dbg !311
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !312, metadata !DIExpression()), !dbg !313
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !314, metadata !DIExpression()), !dbg !315
  %7 = load i8**, i8*** %5, align 8, !dbg !316
  %8 = icmp ne i8** %7, null, !dbg !316
  br i1 %8, label %9, label %11, !dbg !316

9:                                                ; preds = %3
  br i1 true, label %10, label %11, !dbg !319

10:                                               ; preds = %9
  br label %12, !dbg !319

11:                                               ; preds = %9, %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([90 x i8], [90 x i8]* @.str.7, i64 0, i64 0), i32 noundef 45, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__.bounded_spsc_init, i64 0, i64 0)) #5, !dbg !316
  unreachable, !dbg !316

12:                                               ; preds = %10
  %13 = load i32, i32* %6, align 4, !dbg !320
  %14 = icmp ne i32 %13, 0, !dbg !320
  br i1 %14, label %15, label %17, !dbg !320

15:                                               ; preds = %12
  br i1 true, label %16, label %17, !dbg !323

16:                                               ; preds = %15
  br label %18, !dbg !323

17:                                               ; preds = %15, %12
  call void @__assert_fail(i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.13, i64 0, i64 0), i8* noundef getelementptr inbounds ([90 x i8], [90 x i8]* @.str.7, i64 0, i64 0), i32 noundef 46, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__.bounded_spsc_init, i64 0, i64 0)) #5, !dbg !320
  unreachable, !dbg !320

18:                                               ; preds = %16
  %19 = load i8**, i8*** %5, align 8, !dbg !324
  %20 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !325
  %21 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %20, i32 0, i32 0, !dbg !326
  store i8** %19, i8*** %21, align 8, !dbg !327
  %22 = load i32, i32* %6, align 4, !dbg !328
  %23 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !329
  %24 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %23, i32 0, i32 3, !dbg !330
  store i32 %22, i32* %24, align 8, !dbg !331
  %25 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !332
  %26 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %25, i32 0, i32 1, !dbg !333
  call void @vatomic32_init(%struct.vatomic32_s* noundef %26, i32 noundef 0), !dbg !334
  %27 = load %struct.bounded_spsc_t*, %struct.bounded_spsc_t** %4, align 8, !dbg !335
  %28 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %27, i32 0, i32 2, !dbg !336
  call void @vatomic32_init(%struct.vatomic32_s* noundef %28, i32 noundef 0), !dbg !337
  ret void, !dbg !338
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !339 {
  %3 = alloca i64, align 8
  %4 = alloca i8* (i8*)*, align 8
  %5 = alloca %struct.run_info_t*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !342, metadata !DIExpression()), !dbg !343
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %4, metadata !344, metadata !DIExpression()), !dbg !345
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !346, metadata !DIExpression()), !dbg !347
  %6 = load i64, i64* %3, align 8, !dbg !348
  %7 = mul i64 32, %6, !dbg !349
  %8 = call noalias i8* @malloc(i64 noundef %7) #6, !dbg !350
  %9 = bitcast i8* %8 to %struct.run_info_t*, !dbg !350
  store %struct.run_info_t* %9, %struct.run_info_t** %5, align 8, !dbg !347
  %10 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !351
  %11 = load i64, i64* %3, align 8, !dbg !352
  %12 = load i8* (i8*)*, i8* (i8*)** %4, align 8, !dbg !353
  call void @create_threads(%struct.run_info_t* noundef %10, i64 noundef %11, i8* (i8*)* noundef %12, i1 noundef zeroext true), !dbg !354
  %13 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !355
  %14 = load i64, i64* %3, align 8, !dbg !356
  call void @await_threads(%struct.run_info_t* noundef %13, i64 noundef %14), !dbg !357
  %15 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !358
  %16 = bitcast %struct.run_info_t* %15 to i8*, !dbg !358
  call void @free(i8* noundef %16) #6, !dbg !359
  ret void, !dbg !360
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !361 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !367, metadata !DIExpression()), !dbg !368
  call void @llvm.dbg.declare(metadata i32* %3, metadata !369, metadata !DIExpression()), !dbg !370
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !371
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !372
  %6 = load i32, i32* %5, align 4, !dbg !372
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !373, !srcloc !374
  store i32 %7, i32* %3, align 4, !dbg !373
  %8 = load i32, i32* %3, align 4, !dbg !375
  ret i32 %8, !dbg !376
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !377 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !381, metadata !DIExpression()), !dbg !382
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !383, metadata !DIExpression()), !dbg !384
  %5 = load i32, i32* %4, align 4, !dbg !385
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !386
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !387
  %8 = load i32, i32* %7, align 4, !dbg !387
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !388, !srcloc !389
  ret void, !dbg !390
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !391 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !392, metadata !DIExpression()), !dbg !393
  call void @llvm.dbg.declare(metadata i32* %3, metadata !394, metadata !DIExpression()), !dbg !395
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !396
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !397
  %6 = load i32, i32* %5, align 4, !dbg !397
  %7 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !398, !srcloc !399
  store i32 %7, i32* %3, align 4, !dbg !398
  %8 = load i32, i32* %3, align 4, !dbg !400
  ret i32 %8, !dbg !401
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_init(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !402 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !404, metadata !DIExpression()), !dbg !405
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !406, metadata !DIExpression()), !dbg !407
  %5 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !408
  %6 = load i32, i32* %4, align 4, !dbg !409
  call void @vatomic32_write(%struct.vatomic32_s* noundef %5, i32 noundef %6), !dbg !410
  ret void, !dbg !411
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !412 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !413, metadata !DIExpression()), !dbg !414
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !415, metadata !DIExpression()), !dbg !416
  %5 = load i32, i32* %4, align 4, !dbg !417
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !418
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !419
  %8 = load i32, i32* %7, align 4, !dbg !419
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !420, !srcloc !421
  ret void, !dbg !422
}

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !423 {
  %5 = alloca %struct.run_info_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8* (i8*)*, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !426, metadata !DIExpression()), !dbg !427
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !428, metadata !DIExpression()), !dbg !429
  store i8* (i8*)* %2, i8* (i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %7, metadata !430, metadata !DIExpression()), !dbg !431
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !432, metadata !DIExpression()), !dbg !433
  call void @llvm.dbg.declare(metadata i64* %9, metadata !434, metadata !DIExpression()), !dbg !435
  store i64 0, i64* %9, align 8, !dbg !435
  store i64 0, i64* %9, align 8, !dbg !436
  br label %11, !dbg !438

11:                                               ; preds = %42, %4
  %12 = load i64, i64* %9, align 8, !dbg !439
  %13 = load i64, i64* %6, align 8, !dbg !441
  %14 = icmp ult i64 %12, %13, !dbg !442
  br i1 %14, label %15, label %45, !dbg !443

15:                                               ; preds = %11
  %16 = load i64, i64* %9, align 8, !dbg !444
  %17 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !446
  %18 = load i64, i64* %9, align 8, !dbg !447
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %17, i64 %18, !dbg !446
  %20 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %19, i32 0, i32 1, !dbg !448
  store i64 %16, i64* %20, align 8, !dbg !449
  %21 = load i8* (i8*)*, i8* (i8*)** %7, align 8, !dbg !450
  %22 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !451
  %23 = load i64, i64* %9, align 8, !dbg !452
  %24 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %22, i64 %23, !dbg !451
  %25 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %24, i32 0, i32 3, !dbg !453
  store i8* (i8*)* %21, i8* (i8*)** %25, align 8, !dbg !454
  %26 = load i8, i8* %8, align 1, !dbg !455
  %27 = trunc i8 %26 to i1, !dbg !455
  %28 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !456
  %29 = load i64, i64* %9, align 8, !dbg !457
  %30 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %28, i64 %29, !dbg !456
  %31 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %30, i32 0, i32 2, !dbg !458
  %32 = zext i1 %27 to i8, !dbg !459
  store i8 %32, i8* %31, align 8, !dbg !459
  %33 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !460
  %34 = load i64, i64* %9, align 8, !dbg !461
  %35 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %33, i64 %34, !dbg !460
  %36 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %35, i32 0, i32 0, !dbg !462
  %37 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !463
  %38 = load i64, i64* %9, align 8, !dbg !464
  %39 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %37, i64 %38, !dbg !463
  %40 = bitcast %struct.run_info_t* %39 to i8*, !dbg !465
  %41 = call i32 @pthread_create(i64* noundef %36, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %40) #6, !dbg !466
  br label %42, !dbg !467

42:                                               ; preds = %15
  %43 = load i64, i64* %9, align 8, !dbg !468
  %44 = add i64 %43, 1, !dbg !468
  store i64 %44, i64* %9, align 8, !dbg !468
  br label %11, !dbg !469, !llvm.loop !470

45:                                               ; preds = %11
  ret void, !dbg !472
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !473 {
  %3 = alloca %struct.run_info_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !476, metadata !DIExpression()), !dbg !477
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !478, metadata !DIExpression()), !dbg !479
  call void @llvm.dbg.declare(metadata i64* %5, metadata !480, metadata !DIExpression()), !dbg !481
  store i64 0, i64* %5, align 8, !dbg !481
  store i64 0, i64* %5, align 8, !dbg !482
  br label %6, !dbg !484

6:                                                ; preds = %17, %2
  %7 = load i64, i64* %5, align 8, !dbg !485
  %8 = load i64, i64* %4, align 8, !dbg !487
  %9 = icmp ult i64 %7, %8, !dbg !488
  br i1 %9, label %10, label %20, !dbg !489

10:                                               ; preds = %6
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !490
  %12 = load i64, i64* %5, align 8, !dbg !492
  %13 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i64 %12, !dbg !490
  %14 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %13, i32 0, i32 0, !dbg !493
  %15 = load i64, i64* %14, align 8, !dbg !493
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !494
  br label %17, !dbg !495

17:                                               ; preds = %10
  %18 = load i64, i64* %5, align 8, !dbg !496
  %19 = add i64 %18, 1, !dbg !496
  store i64 %19, i64* %5, align 8, !dbg !496
  br label %6, !dbg !497, !llvm.loop !498

20:                                               ; preds = %6
  ret void, !dbg !500
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !501 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.run_info_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !502, metadata !DIExpression()), !dbg !503
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !504, metadata !DIExpression()), !dbg !505
  %4 = load i8*, i8** %2, align 8, !dbg !506
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !507
  store %struct.run_info_t* %5, %struct.run_info_t** %3, align 8, !dbg !505
  %6 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !508
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %6, i32 0, i32 2, !dbg !510
  %8 = load i8, i8* %7, align 8, !dbg !510
  %9 = trunc i8 %8 to i1, !dbg !510
  br i1 %9, label %10, label %14, !dbg !511

10:                                               ; preds = %1
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !512
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i32 0, i32 1, !dbg !513
  %13 = load i64, i64* %12, align 8, !dbg !513
  call void @set_cpu_affinity(i64 noundef %13), !dbg !514
  br label %14, !dbg !514

14:                                               ; preds = %10, %1
  %15 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !515
  %16 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %15, i32 0, i32 3, !dbg !516
  %17 = load i8* (i8*)*, i8* (i8*)** %16, align 8, !dbg !516
  %18 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !517
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %18, i32 0, i32 1, !dbg !518
  %20 = load i64, i64* %19, align 8, !dbg !518
  %21 = inttoptr i64 %20 to i8*, !dbg !519
  %22 = call i8* %17(i8* noundef %21), !dbg !515
  ret i8* %22, !dbg !520
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !521 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !524, metadata !DIExpression()), !dbg !525
  br label %3, !dbg !526

3:                                                ; preds = %1
  br label %4, !dbg !527

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !529
  br label %6, !dbg !529

6:                                                ; preds = %4
  br label %7, !dbg !531

7:                                                ; preds = %6
  br label %8, !dbg !529

8:                                                ; preds = %7
  br label %9, !dbg !527

9:                                                ; preds = %8
  ret void, !dbg !533
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!79, !80, !81, !82, !83, !84, !85}
!llvm.ident = !{!86}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_points", scope: !2, file: !25, line: 22, type: !76, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !13, globals: !52, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/datastruct/queue/bounded/test/bounded_spsc.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "b59a83ea6dccf56b8895b5abfe1bec72")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 8, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "datastruct/queue/bounded/include/vsync/queue/internal/bounded_ret.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "391da9ed4071ef46b42c0029bc1a53be")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12}
!9 = !DIEnumerator(name: "QUEUE_BOUNDED_OK", value: 0)
!10 = !DIEnumerator(name: "QUEUE_BOUNDED_FULL", value: 1)
!11 = !DIEnumerator(name: "QUEUE_BOUNDED_EMPTY", value: 2)
!12 = !DIEnumerator(name: "QUEUE_BOUNDED_AGAIN", value: 3)
!13 = !{!14, !19, !22, !23, !35}
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsize_t", file: !15, line: 43, baseType: !16)
!15 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !17, line: 46, baseType: !18)
!17 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!18 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !15, line: 37, baseType: !20)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !21, line: 90, baseType: !18)
!21 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "point_t", file: !25, line: 16, baseType: !26)
!25 = !DIFile(filename: "datastruct/queue/bounded/test/bounded_spsc.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "b59a83ea6dccf56b8895b5abfe1bec72")
!26 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "point_s", file: !25, line: 13, size: 64, elements: !27)
!27 = !{!28, !34}
!28 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !26, file: !25, line: 14, baseType: !29, size: 32)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !15, line: 35, baseType: !30)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !31, line: 26, baseType: !32)
!31 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !33, line: 42, baseType: !7)
!33 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!34 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !26, file: !25, line: 15, baseType: !29, size: 32, offset: 32)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "run_info_t", file: !37, line: 38, baseType: !38)
!37 = !DIFile(filename: "utils/include/test/thread_launcher.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "b854c1934ab1739fab93f88f22662d53")
!38 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !37, line: 33, size: 256, elements: !39)
!39 = !{!40, !43, !44, !47}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "t", scope: !38, file: !37, line: 34, baseType: !41, size: 64)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !42, line: 27, baseType: !18)
!42 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!43 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !38, file: !37, line: 35, baseType: !14, size: 64, offset: 64)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "assign_me_to_core", scope: !38, file: !37, line: 36, baseType: !45, size: 8, offset: 128)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !15, line: 44, baseType: !46)
!46 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "run_fun", scope: !38, file: !37, line: 37, baseType: !48, size: 64, offset: 192)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "thread_fun_t", file: !37, line: 30, baseType: !49)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!50 = !DISubroutineType(types: !51)
!51 = !{!22, !22}
!52 = !{!53, !58, !74, !0}
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "g_buf", scope: !2, file: !25, line: 18, type: !55, isLocal: false, isDefinition: true)
!55 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 128, elements: !56)
!56 = !{!57}
!57 = !DISubrange(count: 2)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "g_queue", scope: !2, file: !25, line: 19, type: !60, isLocal: false, isDefinition: true)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "bounded_spsc_t", file: !61, line: 33, baseType: !62)
!61 = !DIFile(filename: "datastruct/queue/bounded/include/vsync/queue/bounded_spsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "791e54777256b4049109b76253efef35")
!62 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !61, line: 28, size: 192, elements: !63)
!63 = !{!64, !66, !72, !73}
!64 = !DIDerivedType(tag: DW_TAG_member, name: "buf", scope: !62, file: !61, line: 29, baseType: !65, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !62, file: !61, line: 30, baseType: !67, size: 32, align: 32, offset: 64)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !68, line: 34, baseType: !69)
!68 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!69 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !68, line: 32, size: 32, align: 32, elements: !70)
!70 = !{!71}
!71 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !69, file: !68, line: 33, baseType: !29, size: 32)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !62, file: !61, line: 31, baseType: !67, size: 32, align: 32, offset: 96)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !62, file: !61, line: 32, baseType: !29, size: 32, offset: 128)
!74 = !DIGlobalVariableExpression(var: !75, expr: !DIExpression())
!75 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !25, line: 20, type: !67, isLocal: false, isDefinition: true)
!76 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 192, elements: !77)
!77 = !{!78}
!78 = !DISubrange(count: 3)
!79 = !{i32 7, !"Dwarf Version", i32 5}
!80 = !{i32 2, !"Debug Info Version", i32 3}
!81 = !{i32 1, !"wchar_size", i32 4}
!82 = !{i32 7, !"PIC Level", i32 2}
!83 = !{i32 7, !"PIE Level", i32 2}
!84 = !{i32 7, !"uwtable", i32 1}
!85 = !{i32 7, !"frame-pointer", i32 2}
!86 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!87 = distinct !DISubprogram(name: "run", scope: !25, file: !25, line: 25, type: !50, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !88)
!88 = !{}
!89 = !DILocalVariable(name: "arg", arg: 1, scope: !87, file: !25, line: 25, type: !22)
!90 = !DILocation(line: 25, column: 11, scope: !87)
!91 = !DILocalVariable(name: "tid", scope: !87, file: !25, line: 27, type: !14)
!92 = !DILocation(line: 27, column: 13, scope: !87)
!93 = !DILocation(line: 27, column: 40, scope: !87)
!94 = !DILocation(line: 27, column: 28, scope: !87)
!95 = !DILocation(line: 29, column: 9, scope: !96)
!96 = distinct !DILexicalBlock(scope: !87, file: !25, line: 29, column: 9)
!97 = !DILocation(line: 29, column: 13, scope: !96)
!98 = !DILocation(line: 29, column: 9, scope: !87)
!99 = !DILocalVariable(name: "i", scope: !100, file: !25, line: 30, type: !14)
!100 = distinct !DILexicalBlock(scope: !101, file: !25, line: 30, column: 9)
!101 = distinct !DILexicalBlock(scope: !96, file: !25, line: 29, column: 19)
!102 = !DILocation(line: 30, column: 22, scope: !100)
!103 = !DILocation(line: 30, column: 14, scope: !100)
!104 = !DILocation(line: 30, column: 29, scope: !105)
!105 = distinct !DILexicalBlock(scope: !100, file: !25, line: 30, column: 9)
!106 = !DILocation(line: 30, column: 31, scope: !105)
!107 = !DILocation(line: 30, column: 9, scope: !100)
!108 = !DILocalVariable(name: "point", scope: !109, file: !25, line: 31, type: !23)
!109 = distinct !DILexicalBlock(scope: !105, file: !25, line: 30, column: 46)
!110 = !DILocation(line: 31, column: 22, scope: !109)
!111 = !DILocation(line: 31, column: 39, scope: !109)
!112 = !DILocation(line: 31, column: 30, scope: !109)
!113 = !DILocation(line: 32, column: 13, scope: !109)
!114 = !DILocation(line: 32, column: 20, scope: !109)
!115 = !DILocation(line: 32, column: 28, scope: !109)
!116 = !DILocation(line: 33, column: 13, scope: !109)
!117 = !DILocation(line: 33, column: 20, scope: !109)
!118 = !DILocation(line: 33, column: 28, scope: !109)
!119 = !DILocation(line: 34, column: 13, scope: !109)
!120 = distinct !{!120, !119, !121, !122}
!121 = !DILocation(line: 35, column: 17, scope: !109)
!122 = !{!"llvm.loop.mustprogress"}
!123 = !DILocation(line: 36, column: 9, scope: !109)
!124 = !DILocation(line: 30, column: 42, scope: !105)
!125 = !DILocation(line: 30, column: 9, scope: !105)
!126 = distinct !{!126, !107, !127, !122}
!127 = !DILocation(line: 36, column: 9, scope: !100)
!128 = !DILocation(line: 37, column: 5, scope: !101)
!129 = !DILocalVariable(name: "i", scope: !130, file: !25, line: 38, type: !132)
!130 = distinct !DILexicalBlock(scope: !131, file: !25, line: 38, column: 9)
!131 = distinct !DILexicalBlock(scope: !96, file: !25, line: 37, column: 12)
!132 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!133 = !DILocation(line: 38, column: 18, scope: !130)
!134 = !DILocation(line: 38, column: 14, scope: !130)
!135 = !DILocation(line: 38, column: 25, scope: !136)
!136 = distinct !DILexicalBlock(scope: !130, file: !25, line: 38, column: 9)
!137 = !DILocation(line: 38, column: 27, scope: !136)
!138 = !DILocation(line: 38, column: 9, scope: !130)
!139 = !DILocalVariable(name: "r", scope: !140, file: !25, line: 39, type: !22)
!140 = distinct !DILexicalBlock(scope: !136, file: !25, line: 38, column: 42)
!141 = !DILocation(line: 39, column: 19, scope: !140)
!142 = !DILocation(line: 40, column: 13, scope: !140)
!143 = distinct !{!143, !142, !144, !122}
!144 = !DILocation(line: 41, column: 17, scope: !140)
!145 = !DILocalVariable(name: "point", scope: !140, file: !25, line: 42, type: !23)
!146 = !DILocation(line: 42, column: 22, scope: !140)
!147 = !DILocation(line: 42, column: 41, scope: !140)
!148 = !DILocation(line: 42, column: 30, scope: !140)
!149 = !DILocation(line: 43, column: 17, scope: !150)
!150 = distinct !DILexicalBlock(scope: !140, file: !25, line: 43, column: 17)
!151 = !DILocation(line: 43, column: 17, scope: !140)
!152 = !DILocation(line: 44, column: 17, scope: !153)
!153 = distinct !DILexicalBlock(scope: !154, file: !25, line: 44, column: 17)
!154 = distinct !DILexicalBlock(scope: !155, file: !25, line: 44, column: 17)
!155 = distinct !DILexicalBlock(scope: !150, file: !25, line: 43, column: 24)
!156 = !DILocation(line: 44, column: 17, scope: !154)
!157 = !DILocation(line: 45, column: 17, scope: !158)
!158 = distinct !DILexicalBlock(scope: !159, file: !25, line: 45, column: 17)
!159 = distinct !DILexicalBlock(scope: !155, file: !25, line: 45, column: 17)
!160 = !DILocation(line: 45, column: 17, scope: !159)
!161 = !DILocation(line: 46, column: 22, scope: !155)
!162 = !DILocation(line: 46, column: 17, scope: !155)
!163 = !DILocation(line: 47, column: 13, scope: !155)
!164 = !DILocation(line: 48, column: 17, scope: !165)
!165 = distinct !DILexicalBlock(scope: !166, file: !25, line: 48, column: 17)
!166 = distinct !DILexicalBlock(scope: !167, file: !25, line: 48, column: 17)
!167 = distinct !DILexicalBlock(scope: !150, file: !25, line: 47, column: 20)
!168 = !DILocation(line: 50, column: 9, scope: !140)
!169 = !DILocation(line: 38, column: 38, scope: !136)
!170 = !DILocation(line: 38, column: 9, scope: !136)
!171 = distinct !{!171, !138, !172, !122}
!172 = !DILocation(line: 50, column: 9, scope: !130)
!173 = !DILocation(line: 52, column: 5, scope: !87)
!174 = distinct !DISubprogram(name: "bounded_spsc_enq", scope: !61, file: !61, line: 64, type: !175, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!175 = !DISubroutineType(types: !176)
!176 = !{!177, !178, !22}
!177 = !DIDerivedType(tag: DW_TAG_typedef, name: "bounded_ret_t", file: !6, line: 13, baseType: !5)
!178 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!179 = !DILocalVariable(name: "q", arg: 1, scope: !174, file: !61, line: 64, type: !178)
!180 = !DILocation(line: 64, column: 34, scope: !174)
!181 = !DILocalVariable(name: "v", arg: 2, scope: !174, file: !61, line: 64, type: !22)
!182 = !DILocation(line: 64, column: 43, scope: !174)
!183 = !DILocation(line: 66, column: 5, scope: !184)
!184 = distinct !DILexicalBlock(scope: !185, file: !61, line: 66, column: 5)
!185 = distinct !DILexicalBlock(scope: !174, file: !61, line: 66, column: 5)
!186 = !DILocation(line: 66, column: 5, scope: !185)
!187 = !DILocation(line: 67, column: 5, scope: !188)
!188 = distinct !DILexicalBlock(scope: !189, file: !61, line: 67, column: 5)
!189 = distinct !DILexicalBlock(scope: !174, file: !61, line: 67, column: 5)
!190 = !DILocation(line: 67, column: 5, scope: !189)
!191 = !DILocalVariable(name: "tail", scope: !174, file: !61, line: 69, type: !29)
!192 = !DILocation(line: 69, column: 15, scope: !174)
!193 = !DILocation(line: 69, column: 42, scope: !174)
!194 = !DILocation(line: 69, column: 45, scope: !174)
!195 = !DILocation(line: 69, column: 22, scope: !174)
!196 = !DILocalVariable(name: "head", scope: !174, file: !61, line: 70, type: !29)
!197 = !DILocation(line: 70, column: 15, scope: !174)
!198 = !DILocation(line: 70, column: 42, scope: !174)
!199 = !DILocation(line: 70, column: 45, scope: !174)
!200 = !DILocation(line: 70, column: 22, scope: !174)
!201 = !DILocation(line: 72, column: 9, scope: !202)
!202 = distinct !DILexicalBlock(scope: !174, file: !61, line: 72, column: 9)
!203 = !DILocation(line: 72, column: 16, scope: !202)
!204 = !DILocation(line: 72, column: 14, scope: !202)
!205 = !DILocation(line: 72, column: 24, scope: !202)
!206 = !DILocation(line: 72, column: 27, scope: !202)
!207 = !DILocation(line: 72, column: 21, scope: !202)
!208 = !DILocation(line: 72, column: 9, scope: !174)
!209 = !DILocation(line: 73, column: 9, scope: !210)
!210 = distinct !DILexicalBlock(scope: !202, file: !61, line: 72, column: 33)
!211 = !DILocation(line: 76, column: 30, scope: !174)
!212 = !DILocation(line: 76, column: 5, scope: !174)
!213 = !DILocation(line: 76, column: 8, scope: !174)
!214 = !DILocation(line: 76, column: 12, scope: !174)
!215 = !DILocation(line: 76, column: 19, scope: !174)
!216 = !DILocation(line: 76, column: 22, scope: !174)
!217 = !DILocation(line: 76, column: 17, scope: !174)
!218 = !DILocation(line: 76, column: 28, scope: !174)
!219 = !DILocation(line: 77, column: 26, scope: !174)
!220 = !DILocation(line: 77, column: 29, scope: !174)
!221 = !DILocation(line: 77, column: 35, scope: !174)
!222 = !DILocation(line: 77, column: 40, scope: !174)
!223 = !DILocation(line: 77, column: 5, scope: !174)
!224 = !DILocation(line: 79, column: 5, scope: !174)
!225 = !DILocation(line: 80, column: 1, scope: !174)
!226 = distinct !DISubprogram(name: "bounded_spsc_deq", scope: !61, file: !61, line: 92, type: !227, scopeLine: 93, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!227 = !DISubroutineType(types: !228)
!228 = !{!177, !178, !65}
!229 = !DILocalVariable(name: "q", arg: 1, scope: !226, file: !61, line: 92, type: !178)
!230 = !DILocation(line: 92, column: 34, scope: !226)
!231 = !DILocalVariable(name: "v", arg: 2, scope: !226, file: !61, line: 92, type: !65)
!232 = !DILocation(line: 92, column: 44, scope: !226)
!233 = !DILocation(line: 94, column: 5, scope: !234)
!234 = distinct !DILexicalBlock(scope: !235, file: !61, line: 94, column: 5)
!235 = distinct !DILexicalBlock(scope: !226, file: !61, line: 94, column: 5)
!236 = !DILocation(line: 94, column: 5, scope: !235)
!237 = !DILocation(line: 95, column: 5, scope: !238)
!238 = distinct !DILexicalBlock(scope: !239, file: !61, line: 95, column: 5)
!239 = distinct !DILexicalBlock(scope: !226, file: !61, line: 95, column: 5)
!240 = !DILocation(line: 95, column: 5, scope: !239)
!241 = !DILocalVariable(name: "head", scope: !226, file: !61, line: 97, type: !29)
!242 = !DILocation(line: 97, column: 15, scope: !226)
!243 = !DILocation(line: 97, column: 42, scope: !226)
!244 = !DILocation(line: 97, column: 45, scope: !226)
!245 = !DILocation(line: 97, column: 22, scope: !226)
!246 = !DILocalVariable(name: "tail", scope: !226, file: !61, line: 98, type: !29)
!247 = !DILocation(line: 98, column: 15, scope: !226)
!248 = !DILocation(line: 98, column: 42, scope: !226)
!249 = !DILocation(line: 98, column: 45, scope: !226)
!250 = !DILocation(line: 98, column: 22, scope: !226)
!251 = !DILocation(line: 100, column: 9, scope: !252)
!252 = distinct !DILexicalBlock(scope: !226, file: !61, line: 100, column: 9)
!253 = !DILocation(line: 100, column: 16, scope: !252)
!254 = !DILocation(line: 100, column: 14, scope: !252)
!255 = !DILocation(line: 100, column: 21, scope: !252)
!256 = !DILocation(line: 100, column: 9, scope: !226)
!257 = !DILocation(line: 101, column: 9, scope: !258)
!258 = distinct !DILexicalBlock(scope: !252, file: !61, line: 100, column: 27)
!259 = !DILocation(line: 104, column: 10, scope: !226)
!260 = !DILocation(line: 104, column: 13, scope: !226)
!261 = !DILocation(line: 104, column: 17, scope: !226)
!262 = !DILocation(line: 104, column: 24, scope: !226)
!263 = !DILocation(line: 104, column: 27, scope: !226)
!264 = !DILocation(line: 104, column: 22, scope: !226)
!265 = !DILocation(line: 104, column: 6, scope: !226)
!266 = !DILocation(line: 104, column: 8, scope: !226)
!267 = !DILocation(line: 105, column: 26, scope: !226)
!268 = !DILocation(line: 105, column: 29, scope: !226)
!269 = !DILocation(line: 105, column: 35, scope: !226)
!270 = !DILocation(line: 105, column: 40, scope: !226)
!271 = !DILocation(line: 105, column: 5, scope: !226)
!272 = !DILocation(line: 107, column: 5, scope: !226)
!273 = !DILocation(line: 108, column: 1, scope: !226)
!274 = distinct !DISubprogram(name: "main", scope: !25, file: !25, line: 56, type: !275, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !88)
!275 = !DISubroutineType(types: !276)
!276 = !{!132}
!277 = !DILocation(line: 58, column: 5, scope: !274)
!278 = !DILocalVariable(name: "i", scope: !279, file: !25, line: 59, type: !14)
!279 = distinct !DILexicalBlock(scope: !274, file: !25, line: 59, column: 5)
!280 = !DILocation(line: 59, column: 18, scope: !279)
!281 = !DILocation(line: 59, column: 10, scope: !279)
!282 = !DILocation(line: 59, column: 25, scope: !283)
!283 = distinct !DILexicalBlock(scope: !279, file: !25, line: 59, column: 5)
!284 = !DILocation(line: 59, column: 27, scope: !283)
!285 = !DILocation(line: 59, column: 5, scope: !279)
!286 = !DILocation(line: 60, column: 23, scope: !287)
!287 = distinct !DILexicalBlock(scope: !283, file: !25, line: 59, column: 42)
!288 = !DILocation(line: 60, column: 18, scope: !287)
!289 = !DILocation(line: 60, column: 9, scope: !287)
!290 = !DILocation(line: 60, column: 21, scope: !287)
!291 = !DILocation(line: 61, column: 22, scope: !292)
!292 = distinct !DILexicalBlock(scope: !287, file: !25, line: 61, column: 13)
!293 = !DILocation(line: 61, column: 13, scope: !292)
!294 = !DILocation(line: 61, column: 25, scope: !292)
!295 = !DILocation(line: 61, column: 13, scope: !287)
!296 = !DILocation(line: 62, column: 13, scope: !297)
!297 = distinct !DILexicalBlock(scope: !298, file: !25, line: 62, column: 13)
!298 = distinct !DILexicalBlock(scope: !299, file: !25, line: 62, column: 13)
!299 = distinct !DILexicalBlock(scope: !292, file: !25, line: 61, column: 34)
!300 = !DILocation(line: 64, column: 5, scope: !287)
!301 = !DILocation(line: 59, column: 38, scope: !283)
!302 = !DILocation(line: 59, column: 5, scope: !283)
!303 = distinct !{!303, !285, !304, !122}
!304 = !DILocation(line: 64, column: 5, scope: !279)
!305 = !DILocation(line: 65, column: 5, scope: !274)
!306 = !DILocation(line: 66, column: 5, scope: !274)
!307 = distinct !DISubprogram(name: "bounded_spsc_init", scope: !61, file: !61, line: 43, type: !308, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!308 = !DISubroutineType(types: !309)
!309 = !{null, !178, !65, !29}
!310 = !DILocalVariable(name: "q", arg: 1, scope: !307, file: !61, line: 43, type: !178)
!311 = !DILocation(line: 43, column: 35, scope: !307)
!312 = !DILocalVariable(name: "b", arg: 2, scope: !307, file: !61, line: 43, type: !65)
!313 = !DILocation(line: 43, column: 45, scope: !307)
!314 = !DILocalVariable(name: "s", arg: 3, scope: !307, file: !61, line: 43, type: !29)
!315 = !DILocation(line: 43, column: 58, scope: !307)
!316 = !DILocation(line: 45, column: 5, scope: !317)
!317 = distinct !DILexicalBlock(scope: !318, file: !61, line: 45, column: 5)
!318 = distinct !DILexicalBlock(scope: !307, file: !61, line: 45, column: 5)
!319 = !DILocation(line: 45, column: 5, scope: !318)
!320 = !DILocation(line: 46, column: 5, scope: !321)
!321 = distinct !DILexicalBlock(scope: !322, file: !61, line: 46, column: 5)
!322 = distinct !DILexicalBlock(scope: !307, file: !61, line: 46, column: 5)
!323 = !DILocation(line: 46, column: 5, scope: !322)
!324 = !DILocation(line: 48, column: 15, scope: !307)
!325 = !DILocation(line: 48, column: 5, scope: !307)
!326 = !DILocation(line: 48, column: 8, scope: !307)
!327 = !DILocation(line: 48, column: 13, scope: !307)
!328 = !DILocation(line: 49, column: 15, scope: !307)
!329 = !DILocation(line: 49, column: 5, scope: !307)
!330 = !DILocation(line: 49, column: 8, scope: !307)
!331 = !DILocation(line: 49, column: 13, scope: !307)
!332 = !DILocation(line: 51, column: 21, scope: !307)
!333 = !DILocation(line: 51, column: 24, scope: !307)
!334 = !DILocation(line: 51, column: 5, scope: !307)
!335 = !DILocation(line: 52, column: 21, scope: !307)
!336 = !DILocation(line: 52, column: 24, scope: !307)
!337 = !DILocation(line: 52, column: 5, scope: !307)
!338 = !DILocation(line: 53, column: 1, scope: !307)
!339 = distinct !DISubprogram(name: "launch_threads", scope: !37, file: !37, line: 111, type: !340, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!340 = !DISubroutineType(types: !341)
!341 = !{null, !14, !48}
!342 = !DILocalVariable(name: "thread_count", arg: 1, scope: !339, file: !37, line: 111, type: !14)
!343 = !DILocation(line: 111, column: 24, scope: !339)
!344 = !DILocalVariable(name: "fun", arg: 2, scope: !339, file: !37, line: 111, type: !48)
!345 = !DILocation(line: 111, column: 51, scope: !339)
!346 = !DILocalVariable(name: "threads", scope: !339, file: !37, line: 113, type: !35)
!347 = !DILocation(line: 113, column: 17, scope: !339)
!348 = !DILocation(line: 113, column: 55, scope: !339)
!349 = !DILocation(line: 113, column: 53, scope: !339)
!350 = !DILocation(line: 113, column: 27, scope: !339)
!351 = !DILocation(line: 115, column: 20, scope: !339)
!352 = !DILocation(line: 115, column: 29, scope: !339)
!353 = !DILocation(line: 115, column: 43, scope: !339)
!354 = !DILocation(line: 115, column: 5, scope: !339)
!355 = !DILocation(line: 117, column: 19, scope: !339)
!356 = !DILocation(line: 117, column: 28, scope: !339)
!357 = !DILocation(line: 117, column: 5, scope: !339)
!358 = !DILocation(line: 119, column: 10, scope: !339)
!359 = !DILocation(line: 119, column: 5, scope: !339)
!360 = !DILocation(line: 120, column: 1, scope: !339)
!361 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !362, file: !362, line: 101, type: !363, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!362 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!363 = !DISubroutineType(types: !364)
!364 = !{!29, !365}
!365 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !366, size: 64)
!366 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !67)
!367 = !DILocalVariable(name: "a", arg: 1, scope: !361, file: !362, line: 101, type: !365)
!368 = !DILocation(line: 101, column: 39, scope: !361)
!369 = !DILocalVariable(name: "val", scope: !361, file: !362, line: 103, type: !29)
!370 = !DILocation(line: 103, column: 15, scope: !361)
!371 = !DILocation(line: 106, column: 32, scope: !361)
!372 = !DILocation(line: 106, column: 35, scope: !361)
!373 = !DILocation(line: 104, column: 5, scope: !361)
!374 = !{i64 688789}
!375 = !DILocation(line: 108, column: 12, scope: !361)
!376 = !DILocation(line: 108, column: 5, scope: !361)
!377 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !362, file: !362, line: 227, type: !378, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!378 = !DISubroutineType(types: !379)
!379 = !{null, !380, !29}
!380 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!381 = !DILocalVariable(name: "a", arg: 1, scope: !377, file: !362, line: 227, type: !380)
!382 = !DILocation(line: 227, column: 34, scope: !377)
!383 = !DILocalVariable(name: "v", arg: 2, scope: !377, file: !362, line: 227, type: !29)
!384 = !DILocation(line: 227, column: 47, scope: !377)
!385 = !DILocation(line: 231, column: 32, scope: !377)
!386 = !DILocation(line: 231, column: 44, scope: !377)
!387 = !DILocation(line: 231, column: 47, scope: !377)
!388 = !DILocation(line: 229, column: 5, scope: !377)
!389 = !{i64 692703}
!390 = !DILocation(line: 233, column: 1, scope: !377)
!391 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !362, file: !362, line: 85, type: !363, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!392 = !DILocalVariable(name: "a", arg: 1, scope: !391, file: !362, line: 85, type: !365)
!393 = !DILocation(line: 85, column: 39, scope: !391)
!394 = !DILocalVariable(name: "val", scope: !391, file: !362, line: 87, type: !29)
!395 = !DILocation(line: 87, column: 15, scope: !391)
!396 = !DILocation(line: 90, column: 32, scope: !391)
!397 = !DILocation(line: 90, column: 35, scope: !391)
!398 = !DILocation(line: 88, column: 5, scope: !391)
!399 = !{i64 688287}
!400 = !DILocation(line: 92, column: 12, scope: !391)
!401 = !DILocation(line: 92, column: 5, scope: !391)
!402 = distinct !DISubprogram(name: "vatomic32_init", scope: !403, file: !403, line: 4189, type: !378, scopeLine: 4190, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!403 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!404 = !DILocalVariable(name: "a", arg: 1, scope: !402, file: !403, line: 4189, type: !380)
!405 = !DILocation(line: 4189, column: 29, scope: !402)
!406 = !DILocalVariable(name: "v", arg: 2, scope: !402, file: !403, line: 4189, type: !29)
!407 = !DILocation(line: 4189, column: 42, scope: !402)
!408 = !DILocation(line: 4191, column: 21, scope: !402)
!409 = !DILocation(line: 4191, column: 24, scope: !402)
!410 = !DILocation(line: 4191, column: 5, scope: !402)
!411 = !DILocation(line: 4192, column: 1, scope: !402)
!412 = distinct !DISubprogram(name: "vatomic32_write", scope: !362, file: !362, line: 213, type: !378, scopeLine: 214, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!413 = !DILocalVariable(name: "a", arg: 1, scope: !412, file: !362, line: 213, type: !380)
!414 = !DILocation(line: 213, column: 30, scope: !412)
!415 = !DILocalVariable(name: "v", arg: 2, scope: !412, file: !362, line: 213, type: !29)
!416 = !DILocation(line: 213, column: 43, scope: !412)
!417 = !DILocation(line: 217, column: 32, scope: !412)
!418 = !DILocation(line: 217, column: 44, scope: !412)
!419 = !DILocation(line: 217, column: 47, scope: !412)
!420 = !DILocation(line: 215, column: 5, scope: !412)
!421 = !{i64 692233}
!422 = !DILocation(line: 219, column: 1, scope: !412)
!423 = distinct !DISubprogram(name: "create_threads", scope: !37, file: !37, line: 83, type: !424, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!424 = !DISubroutineType(types: !425)
!425 = !{null, !35, !14, !48, !45}
!426 = !DILocalVariable(name: "threads", arg: 1, scope: !423, file: !37, line: 83, type: !35)
!427 = !DILocation(line: 83, column: 28, scope: !423)
!428 = !DILocalVariable(name: "num_threads", arg: 2, scope: !423, file: !37, line: 83, type: !14)
!429 = !DILocation(line: 83, column: 45, scope: !423)
!430 = !DILocalVariable(name: "fun", arg: 3, scope: !423, file: !37, line: 83, type: !48)
!431 = !DILocation(line: 83, column: 71, scope: !423)
!432 = !DILocalVariable(name: "bind", arg: 4, scope: !423, file: !37, line: 84, type: !45)
!433 = !DILocation(line: 84, column: 24, scope: !423)
!434 = !DILocalVariable(name: "i", scope: !423, file: !37, line: 86, type: !14)
!435 = !DILocation(line: 86, column: 13, scope: !423)
!436 = !DILocation(line: 87, column: 12, scope: !437)
!437 = distinct !DILexicalBlock(scope: !423, file: !37, line: 87, column: 5)
!438 = !DILocation(line: 87, column: 10, scope: !437)
!439 = !DILocation(line: 87, column: 17, scope: !440)
!440 = distinct !DILexicalBlock(scope: !437, file: !37, line: 87, column: 5)
!441 = !DILocation(line: 87, column: 21, scope: !440)
!442 = !DILocation(line: 87, column: 19, scope: !440)
!443 = !DILocation(line: 87, column: 5, scope: !437)
!444 = !DILocation(line: 88, column: 40, scope: !445)
!445 = distinct !DILexicalBlock(scope: !440, file: !37, line: 87, column: 39)
!446 = !DILocation(line: 88, column: 9, scope: !445)
!447 = !DILocation(line: 88, column: 17, scope: !445)
!448 = !DILocation(line: 88, column: 20, scope: !445)
!449 = !DILocation(line: 88, column: 38, scope: !445)
!450 = !DILocation(line: 89, column: 40, scope: !445)
!451 = !DILocation(line: 89, column: 9, scope: !445)
!452 = !DILocation(line: 89, column: 17, scope: !445)
!453 = !DILocation(line: 89, column: 20, scope: !445)
!454 = !DILocation(line: 89, column: 38, scope: !445)
!455 = !DILocation(line: 90, column: 40, scope: !445)
!456 = !DILocation(line: 90, column: 9, scope: !445)
!457 = !DILocation(line: 90, column: 17, scope: !445)
!458 = !DILocation(line: 90, column: 20, scope: !445)
!459 = !DILocation(line: 90, column: 38, scope: !445)
!460 = !DILocation(line: 91, column: 25, scope: !445)
!461 = !DILocation(line: 91, column: 33, scope: !445)
!462 = !DILocation(line: 91, column: 36, scope: !445)
!463 = !DILocation(line: 91, column: 55, scope: !445)
!464 = !DILocation(line: 91, column: 63, scope: !445)
!465 = !DILocation(line: 91, column: 54, scope: !445)
!466 = !DILocation(line: 91, column: 9, scope: !445)
!467 = !DILocation(line: 92, column: 5, scope: !445)
!468 = !DILocation(line: 87, column: 35, scope: !440)
!469 = !DILocation(line: 87, column: 5, scope: !440)
!470 = distinct !{!470, !443, !471, !122}
!471 = !DILocation(line: 92, column: 5, scope: !437)
!472 = !DILocation(line: 94, column: 1, scope: !423)
!473 = distinct !DISubprogram(name: "await_threads", scope: !37, file: !37, line: 97, type: !474, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!474 = !DISubroutineType(types: !475)
!475 = !{null, !35, !14}
!476 = !DILocalVariable(name: "threads", arg: 1, scope: !473, file: !37, line: 97, type: !35)
!477 = !DILocation(line: 97, column: 27, scope: !473)
!478 = !DILocalVariable(name: "num_threads", arg: 2, scope: !473, file: !37, line: 97, type: !14)
!479 = !DILocation(line: 97, column: 44, scope: !473)
!480 = !DILocalVariable(name: "i", scope: !473, file: !37, line: 99, type: !14)
!481 = !DILocation(line: 99, column: 13, scope: !473)
!482 = !DILocation(line: 100, column: 12, scope: !483)
!483 = distinct !DILexicalBlock(scope: !473, file: !37, line: 100, column: 5)
!484 = !DILocation(line: 100, column: 10, scope: !483)
!485 = !DILocation(line: 100, column: 17, scope: !486)
!486 = distinct !DILexicalBlock(scope: !483, file: !37, line: 100, column: 5)
!487 = !DILocation(line: 100, column: 21, scope: !486)
!488 = !DILocation(line: 100, column: 19, scope: !486)
!489 = !DILocation(line: 100, column: 5, scope: !483)
!490 = !DILocation(line: 101, column: 22, scope: !491)
!491 = distinct !DILexicalBlock(scope: !486, file: !37, line: 100, column: 39)
!492 = !DILocation(line: 101, column: 30, scope: !491)
!493 = !DILocation(line: 101, column: 33, scope: !491)
!494 = !DILocation(line: 101, column: 9, scope: !491)
!495 = !DILocation(line: 102, column: 5, scope: !491)
!496 = !DILocation(line: 100, column: 35, scope: !486)
!497 = !DILocation(line: 100, column: 5, scope: !486)
!498 = distinct !{!498, !489, !499, !122}
!499 = !DILocation(line: 102, column: 5, scope: !483)
!500 = !DILocation(line: 103, column: 1, scope: !473)
!501 = distinct !DISubprogram(name: "common_run", scope: !37, file: !37, line: 43, type: !50, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!502 = !DILocalVariable(name: "args", arg: 1, scope: !501, file: !37, line: 43, type: !22)
!503 = !DILocation(line: 43, column: 18, scope: !501)
!504 = !DILocalVariable(name: "run_info", scope: !501, file: !37, line: 45, type: !35)
!505 = !DILocation(line: 45, column: 17, scope: !501)
!506 = !DILocation(line: 45, column: 42, scope: !501)
!507 = !DILocation(line: 45, column: 28, scope: !501)
!508 = !DILocation(line: 47, column: 9, scope: !509)
!509 = distinct !DILexicalBlock(scope: !501, file: !37, line: 47, column: 9)
!510 = !DILocation(line: 47, column: 19, scope: !509)
!511 = !DILocation(line: 47, column: 9, scope: !501)
!512 = !DILocation(line: 48, column: 26, scope: !509)
!513 = !DILocation(line: 48, column: 36, scope: !509)
!514 = !DILocation(line: 48, column: 9, scope: !509)
!515 = !DILocation(line: 52, column: 12, scope: !501)
!516 = !DILocation(line: 52, column: 22, scope: !501)
!517 = !DILocation(line: 52, column: 38, scope: !501)
!518 = !DILocation(line: 52, column: 48, scope: !501)
!519 = !DILocation(line: 52, column: 30, scope: !501)
!520 = !DILocation(line: 52, column: 5, scope: !501)
!521 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !37, file: !37, line: 61, type: !522, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!522 = !DISubroutineType(types: !523)
!523 = !{null, !14}
!524 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !521, file: !37, line: 61, type: !14)
!525 = !DILocation(line: 61, column: 26, scope: !521)
!526 = !DILocation(line: 78, column: 5, scope: !521)
!527 = !DILocation(line: 78, column: 5, scope: !528)
!528 = distinct !DILexicalBlock(scope: !521, file: !37, line: 78, column: 5)
!529 = !DILocation(line: 78, column: 5, scope: !530)
!530 = distinct !DILexicalBlock(scope: !528, file: !37, line: 78, column: 5)
!531 = !DILocation(line: 78, column: 5, scope: !532)
!532 = distinct !DILexicalBlock(scope: !530, file: !37, line: 78, column: 5)
!533 = !DILocation(line: 80, column: 1, scope: !521)
