; ModuleID = '/home/drc/git/Dat3M/output/bounded_spsc.ll'
source_filename = "/home/drc/git/libvsync/test/queue/bounded_spsc.c"
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
@.str.1 = private unnamed_addr constant [49 x i8] c"/home/drc/git/libvsync/test/queue/bounded_spsc.c\00", align 1
@__PRETTY_FUNCTION__.run = private unnamed_addr constant [18 x i8] c"void *run(void *)\00", align 1
@.str.2 = private unnamed_addr constant [14 x i8] c"point->x == 1\00", align 1
@.str.3 = private unnamed_addr constant [21 x i8] c"0 && \22dequeued NULL\22\00", align 1
@g_buf = dso_local global [2 x i8*] zeroinitializer, align 16, !dbg !53
@.str.4 = private unnamed_addr constant [25 x i8] c"0 && \22allocation failed\22\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@g_cs_x = dso_local global %struct.vatomic32_s zeroinitializer, align 4, !dbg !74
@.str.5 = private unnamed_addr constant [10 x i8] c"q == NULL\00", align 1
@.str.6 = private unnamed_addr constant [17 x i8] c"q && \22q == NULL\22\00", align 1
@.str.7 = private unnamed_addr constant [37 x i8] c"./include/vsync/queue/bounded_spsc.h\00", align 1
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
  call void @llvm.dbg.value(metadata i8* %0, metadata !89, metadata !DIExpression()), !dbg !90
  %3 = ptrtoint i8* %0 to i64, !dbg !91
  call void @llvm.dbg.value(metadata i64 %3, metadata !92, metadata !DIExpression()), !dbg !90
  %4 = icmp eq i64 %3, 0, !dbg !93
  br i1 %4, label %5, label %29, !dbg !95

5:                                                ; preds = %1
  call void @llvm.dbg.value(metadata i64 0, metadata !96, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata i64 0, metadata !96, metadata !DIExpression()), !dbg !99
  %6 = load %struct.point_s*, %struct.point_s** getelementptr inbounds ([3 x %struct.point_s*], [3 x %struct.point_s*]* @g_points, i64 0, i64 0), align 8, !dbg !100
  call void @llvm.dbg.value(metadata %struct.point_s* %6, metadata !103, metadata !DIExpression()), !dbg !104
  %7 = getelementptr inbounds %struct.point_s, %struct.point_s* %6, i32 0, i32 0, !dbg !105
  store i32 1, i32* %7, align 4, !dbg !106
  %8 = getelementptr inbounds %struct.point_s, %struct.point_s* %6, i32 0, i32 1, !dbg !107
  store i32 1, i32* %8, align 4, !dbg !108
  br label %9, !dbg !109

9:                                                ; preds = %9, %5
  %10 = bitcast %struct.point_s* %6 to i8*, !dbg !109
  %11 = call i32 @bounded_spsc_enq(%struct.bounded_spsc_t* noundef @g_queue, i8* noundef %10), !dbg !109
  %12 = icmp ne i32 %11, 0, !dbg !109
  br i1 %12, label %9, label %13, !dbg !109, !llvm.loop !110

13:                                               ; preds = %9
  call void @llvm.dbg.value(metadata i64 1, metadata !96, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata i64 1, metadata !96, metadata !DIExpression()), !dbg !99
  %14 = load %struct.point_s*, %struct.point_s** getelementptr inbounds ([3 x %struct.point_s*], [3 x %struct.point_s*]* @g_points, i64 0, i64 1), align 8, !dbg !100
  call void @llvm.dbg.value(metadata %struct.point_s* %14, metadata !103, metadata !DIExpression()), !dbg !104
  %15 = getelementptr inbounds %struct.point_s, %struct.point_s* %14, i32 0, i32 0, !dbg !105
  store i32 1, i32* %15, align 4, !dbg !106
  %16 = getelementptr inbounds %struct.point_s, %struct.point_s* %14, i32 0, i32 1, !dbg !107
  store i32 1, i32* %16, align 4, !dbg !108
  br label %17, !dbg !109

17:                                               ; preds = %17, %13
  %18 = bitcast %struct.point_s* %14 to i8*, !dbg !109
  %19 = call i32 @bounded_spsc_enq(%struct.bounded_spsc_t* noundef @g_queue, i8* noundef %18), !dbg !109
  %20 = icmp ne i32 %19, 0, !dbg !109
  br i1 %20, label %17, label %21, !dbg !109, !llvm.loop !110

21:                                               ; preds = %17
  call void @llvm.dbg.value(metadata i64 2, metadata !96, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata i64 2, metadata !96, metadata !DIExpression()), !dbg !99
  %22 = load %struct.point_s*, %struct.point_s** getelementptr inbounds ([3 x %struct.point_s*], [3 x %struct.point_s*]* @g_points, i64 0, i64 2), align 8, !dbg !100
  call void @llvm.dbg.value(metadata %struct.point_s* %22, metadata !103, metadata !DIExpression()), !dbg !104
  %23 = getelementptr inbounds %struct.point_s, %struct.point_s* %22, i32 0, i32 0, !dbg !105
  store i32 1, i32* %23, align 4, !dbg !106
  %24 = getelementptr inbounds %struct.point_s, %struct.point_s* %22, i32 0, i32 1, !dbg !107
  store i32 1, i32* %24, align 4, !dbg !108
  br label %25, !dbg !109

25:                                               ; preds = %25, %21
  %26 = bitcast %struct.point_s* %22 to i8*, !dbg !109
  %27 = call i32 @bounded_spsc_enq(%struct.bounded_spsc_t* noundef @g_queue, i8* noundef %26), !dbg !109
  %28 = icmp ne i32 %27, 0, !dbg !109
  br i1 %28, label %25, label %81, !dbg !109, !llvm.loop !110

29:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i32 0, metadata !113, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.value(metadata i32 0, metadata !113, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.declare(metadata i8** %2, metadata !118, metadata !DIExpression()), !dbg !121
  store i8* null, i8** %2, align 8, !dbg !121
  br label %30, !dbg !122

30:                                               ; preds = %30, %29
  %31 = call i32 @bounded_spsc_deq(%struct.bounded_spsc_t* noundef @g_queue, i8** noundef %2), !dbg !122
  %32 = icmp ne i32 %31, 0, !dbg !122
  br i1 %32, label %30, label %33, !dbg !122, !llvm.loop !123

33:                                               ; preds = %30
  %34 = load i8*, i8** %2, align 8, !dbg !125
  %35 = bitcast i8* %34 to %struct.point_s*, !dbg !126
  call void @llvm.dbg.value(metadata %struct.point_s* %35, metadata !127, metadata !DIExpression()), !dbg !128
  %36 = icmp ne %struct.point_s* %35, null, !dbg !129
  br i1 %36, label %37, label %48, !dbg !131

37:                                               ; preds = %33
  %38 = getelementptr inbounds %struct.point_s, %struct.point_s* %35, i32 0, i32 0, !dbg !132
  %39 = load i32, i32* %38, align 4, !dbg !132
  %40 = getelementptr inbounds %struct.point_s, %struct.point_s* %35, i32 0, i32 1, !dbg !132
  %41 = load i32, i32* %40, align 4, !dbg !132
  %42 = icmp eq i32 %39, %41, !dbg !132
  br i1 %42, label %44, label %43, !dbg !136

43:                                               ; preds = %72, %56, %37
  call void @__assert_fail(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([49 x i8], [49 x i8]* @.str.1, i64 0, i64 0), i32 noundef 48, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !132
  unreachable, !dbg !132

44:                                               ; preds = %37
  %45 = icmp eq i32 %39, 1, !dbg !137
  br i1 %45, label %47, label %46, !dbg !140

46:                                               ; preds = %78, %62, %44
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([49 x i8], [49 x i8]* @.str.1, i64 0, i64 0), i32 noundef 49, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !137
  unreachable, !dbg !137

47:                                               ; preds = %44
  call void @free(i8* noundef %34) #6, !dbg !141
  call void @llvm.dbg.value(metadata i32 1, metadata !113, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.value(metadata i32 1, metadata !113, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.declare(metadata i8** %2, metadata !118, metadata !DIExpression()), !dbg !121
  store i8* null, i8** %2, align 8, !dbg !121
  br label %49, !dbg !122

48:                                               ; preds = %68, %52, %33
  call void @__assert_fail(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([49 x i8], [49 x i8]* @.str.1, i64 0, i64 0), i32 noundef 52, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !142
  unreachable, !dbg !142

49:                                               ; preds = %49, %47
  %50 = call i32 @bounded_spsc_deq(%struct.bounded_spsc_t* noundef @g_queue, i8** noundef %2), !dbg !122
  %51 = icmp ne i32 %50, 0, !dbg !122
  br i1 %51, label %49, label %52, !dbg !122, !llvm.loop !123

52:                                               ; preds = %49
  %53 = load i8*, i8** %2, align 8, !dbg !125
  %54 = bitcast i8* %53 to %struct.point_s*, !dbg !126
  call void @llvm.dbg.value(metadata %struct.point_s* %54, metadata !127, metadata !DIExpression()), !dbg !128
  %55 = icmp ne %struct.point_s* %54, null, !dbg !129
  br i1 %55, label %56, label %48, !dbg !131

56:                                               ; preds = %52
  %57 = getelementptr inbounds %struct.point_s, %struct.point_s* %54, i32 0, i32 0, !dbg !132
  %58 = load i32, i32* %57, align 4, !dbg !132
  %59 = getelementptr inbounds %struct.point_s, %struct.point_s* %54, i32 0, i32 1, !dbg !132
  %60 = load i32, i32* %59, align 4, !dbg !132
  %61 = icmp eq i32 %58, %60, !dbg !132
  br i1 %61, label %62, label %43, !dbg !136

62:                                               ; preds = %56
  %63 = icmp eq i32 %58, 1, !dbg !137
  br i1 %63, label %64, label %46, !dbg !140

64:                                               ; preds = %62
  call void @free(i8* noundef %53) #6, !dbg !141
  call void @llvm.dbg.value(metadata i32 2, metadata !113, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.value(metadata i32 2, metadata !113, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.declare(metadata i8** %2, metadata !118, metadata !DIExpression()), !dbg !121
  store i8* null, i8** %2, align 8, !dbg !121
  br label %65, !dbg !122

65:                                               ; preds = %65, %64
  %66 = call i32 @bounded_spsc_deq(%struct.bounded_spsc_t* noundef @g_queue, i8** noundef %2), !dbg !122
  %67 = icmp ne i32 %66, 0, !dbg !122
  br i1 %67, label %65, label %68, !dbg !122, !llvm.loop !123

68:                                               ; preds = %65
  %69 = load i8*, i8** %2, align 8, !dbg !125
  %70 = bitcast i8* %69 to %struct.point_s*, !dbg !126
  call void @llvm.dbg.value(metadata %struct.point_s* %70, metadata !127, metadata !DIExpression()), !dbg !128
  %71 = icmp ne %struct.point_s* %70, null, !dbg !129
  br i1 %71, label %72, label %48, !dbg !131

72:                                               ; preds = %68
  %73 = getelementptr inbounds %struct.point_s, %struct.point_s* %70, i32 0, i32 0, !dbg !132
  %74 = load i32, i32* %73, align 4, !dbg !132
  %75 = getelementptr inbounds %struct.point_s, %struct.point_s* %70, i32 0, i32 1, !dbg !132
  %76 = load i32, i32* %75, align 4, !dbg !132
  %77 = icmp eq i32 %74, %76, !dbg !132
  br i1 %77, label %78, label %43, !dbg !136

78:                                               ; preds = %72
  %79 = icmp eq i32 %74, 1, !dbg !137
  br i1 %79, label %80, label %46, !dbg !140

80:                                               ; preds = %78
  call void @free(i8* noundef %69) #6, !dbg !141
  call void @llvm.dbg.value(metadata i32 3, metadata !113, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.value(metadata i32 3, metadata !113, metadata !DIExpression()), !dbg !117
  br label %81

81:                                               ; preds = %25, %80
  ret i8* null, !dbg !146
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal i32 @bounded_spsc_enq(%struct.bounded_spsc_t* noundef %0, i8* noundef %1) #0 !dbg !147 {
  call void @llvm.dbg.value(metadata %struct.bounded_spsc_t* %0, metadata !152, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.value(metadata i8* %1, metadata !154, metadata !DIExpression()), !dbg !153
  %3 = icmp ne %struct.bounded_spsc_t* %0, null, !dbg !155
  br i1 %3, label %5, label %4, !dbg !155

4:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @.str.7, i64 0, i64 0), i32 noundef 65, i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @__PRETTY_FUNCTION__.bounded_spsc_enq, i64 0, i64 0)) #5, !dbg !155
  unreachable, !dbg !155

5:                                                ; preds = %2
  %6 = icmp ne i8* %1, null, !dbg !158
  br i1 %6, label %8, label %7, !dbg !158

7:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @.str.7, i64 0, i64 0), i32 noundef 66, i8* noundef getelementptr inbounds ([57 x i8], [57 x i8]* @__PRETTY_FUNCTION__.bounded_spsc_enq, i64 0, i64 0)) #5, !dbg !158
  unreachable, !dbg !158

8:                                                ; preds = %5
  %9 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %0, i32 0, i32 2, !dbg !161
  %10 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %9), !dbg !162
  call void @llvm.dbg.value(metadata i32 %10, metadata !163, metadata !DIExpression()), !dbg !153
  %11 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %0, i32 0, i32 1, !dbg !164
  %12 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %11), !dbg !165
  call void @llvm.dbg.value(metadata i32 %12, metadata !166, metadata !DIExpression()), !dbg !153
  %13 = sub i32 %10, %12, !dbg !167
  %14 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %0, i32 0, i32 3, !dbg !169
  %15 = load i32, i32* %14, align 8, !dbg !169
  %16 = icmp eq i32 %13, %15, !dbg !170
  br i1 %16, label %24, label %17, !dbg !171

17:                                               ; preds = %8
  %18 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %0, i32 0, i32 0, !dbg !172
  %19 = load i8**, i8*** %18, align 8, !dbg !172
  %20 = urem i32 %10, %15, !dbg !173
  %21 = zext i32 %20 to i64, !dbg !174
  %22 = getelementptr inbounds i8*, i8** %19, i64 %21, !dbg !174
  store i8* %1, i8** %22, align 8, !dbg !175
  %23 = add i32 %10, 1, !dbg !176
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %9, i32 noundef %23), !dbg !177
  br label %24, !dbg !178

24:                                               ; preds = %8, %17
  %.0 = phi i32 [ 0, %17 ], [ 1, %8 ], !dbg !153
  ret i32 %.0, !dbg !179
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @bounded_spsc_deq(%struct.bounded_spsc_t* noundef %0, i8** noundef %1) #0 !dbg !180 {
  call void @llvm.dbg.value(metadata %struct.bounded_spsc_t* %0, metadata !183, metadata !DIExpression()), !dbg !184
  call void @llvm.dbg.value(metadata i8** %1, metadata !185, metadata !DIExpression()), !dbg !184
  %3 = icmp ne %struct.bounded_spsc_t* %0, null, !dbg !186
  br i1 %3, label %5, label %4, !dbg !186

4:                                                ; preds = %2
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @.str.7, i64 0, i64 0), i32 noundef 93, i8* noundef getelementptr inbounds ([58 x i8], [58 x i8]* @__PRETTY_FUNCTION__.bounded_spsc_deq, i64 0, i64 0)) #5, !dbg !186
  unreachable, !dbg !186

5:                                                ; preds = %2
  %6 = icmp ne i8** %1, null, !dbg !189
  br i1 %6, label %8, label %7, !dbg !189

7:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @.str.7, i64 0, i64 0), i32 noundef 94, i8* noundef getelementptr inbounds ([58 x i8], [58 x i8]* @__PRETTY_FUNCTION__.bounded_spsc_deq, i64 0, i64 0)) #5, !dbg !189
  unreachable, !dbg !189

8:                                                ; preds = %5
  %9 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %0, i32 0, i32 1, !dbg !192
  %10 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %9), !dbg !193
  call void @llvm.dbg.value(metadata i32 %10, metadata !194, metadata !DIExpression()), !dbg !184
  %11 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %0, i32 0, i32 2, !dbg !195
  %12 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %11), !dbg !196
  call void @llvm.dbg.value(metadata i32 %12, metadata !197, metadata !DIExpression()), !dbg !184
  %13 = sub i32 %12, %10, !dbg !198
  %14 = icmp eq i32 %13, 0, !dbg !200
  br i1 %14, label %25, label %15, !dbg !201

15:                                               ; preds = %8
  %16 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %0, i32 0, i32 0, !dbg !202
  %17 = load i8**, i8*** %16, align 8, !dbg !202
  %18 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %0, i32 0, i32 3, !dbg !203
  %19 = load i32, i32* %18, align 8, !dbg !203
  %20 = urem i32 %10, %19, !dbg !204
  %21 = zext i32 %20 to i64, !dbg !205
  %22 = getelementptr inbounds i8*, i8** %17, i64 %21, !dbg !205
  %23 = load i8*, i8** %22, align 8, !dbg !205
  store i8* %23, i8** %1, align 8, !dbg !206
  %24 = add i32 %10, 1, !dbg !207
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %9, i32 noundef %24), !dbg !208
  br label %25, !dbg !209

25:                                               ; preds = %8, %15
  %.0 = phi i32 [ 0, %15 ], [ 2, %8 ], !dbg !184
  ret i32 %.0, !dbg !210
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !211 {
  call void @bounded_spsc_init(%struct.bounded_spsc_t* noundef @g_queue, i8** noundef getelementptr inbounds ([2 x i8*], [2 x i8*]* @g_buf, i64 0, i64 0), i32 noundef 2), !dbg !214
  call void @llvm.dbg.value(metadata i64 0, metadata !215, metadata !DIExpression()), !dbg !217
  call void @llvm.dbg.value(metadata i64 0, metadata !215, metadata !DIExpression()), !dbg !217
  %1 = call noalias i8* @malloc(i64 noundef 8) #6, !dbg !218
  %2 = bitcast i8* %1 to %struct.point_s*, !dbg !218
  store %struct.point_s* %2, %struct.point_s** getelementptr inbounds ([3 x %struct.point_s*], [3 x %struct.point_s*]* @g_points, i64 0, i64 0), align 8, !dbg !221
  %3 = icmp eq %struct.point_s* %2, null, !dbg !222
  br i1 %3, label %4, label %5, !dbg !224

4:                                                ; preds = %9, %5, %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([49 x i8], [49 x i8]* @.str.1, i64 0, i64 0), i32 noundef 66, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !225
  unreachable, !dbg !225

5:                                                ; preds = %0
  call void @llvm.dbg.value(metadata i64 1, metadata !215, metadata !DIExpression()), !dbg !217
  call void @llvm.dbg.value(metadata i64 1, metadata !215, metadata !DIExpression()), !dbg !217
  %6 = call noalias i8* @malloc(i64 noundef 8) #6, !dbg !218
  %7 = bitcast i8* %6 to %struct.point_s*, !dbg !218
  store %struct.point_s* %7, %struct.point_s** getelementptr inbounds ([3 x %struct.point_s*], [3 x %struct.point_s*]* @g_points, i64 0, i64 1), align 8, !dbg !221
  %8 = icmp eq %struct.point_s* %7, null, !dbg !222
  br i1 %8, label %4, label %9, !dbg !224

9:                                                ; preds = %5
  call void @llvm.dbg.value(metadata i64 2, metadata !215, metadata !DIExpression()), !dbg !217
  call void @llvm.dbg.value(metadata i64 2, metadata !215, metadata !DIExpression()), !dbg !217
  %10 = call noalias i8* @malloc(i64 noundef 8) #6, !dbg !218
  %11 = bitcast i8* %10 to %struct.point_s*, !dbg !218
  store %struct.point_s* %11, %struct.point_s** getelementptr inbounds ([3 x %struct.point_s*], [3 x %struct.point_s*]* @g_points, i64 0, i64 2), align 8, !dbg !221
  %12 = icmp eq %struct.point_s* %11, null, !dbg !222
  br i1 %12, label %4, label %13, !dbg !224

13:                                               ; preds = %9
  call void @llvm.dbg.value(metadata i64 3, metadata !215, metadata !DIExpression()), !dbg !217
  call void @llvm.dbg.value(metadata i64 3, metadata !215, metadata !DIExpression()), !dbg !217
  call void @launch_threads(i64 noundef 2, i8* (i8*)* noundef @run), !dbg !229
  ret i32 0, !dbg !230
}

; Function Attrs: noinline nounwind uwtable
define internal void @bounded_spsc_init(%struct.bounded_spsc_t* noundef %0, i8** noundef %1, i32 noundef %2) #0 !dbg !231 {
  call void @llvm.dbg.value(metadata %struct.bounded_spsc_t* %0, metadata !234, metadata !DIExpression()), !dbg !235
  call void @llvm.dbg.value(metadata i8** %1, metadata !236, metadata !DIExpression()), !dbg !235
  call void @llvm.dbg.value(metadata i32 %2, metadata !237, metadata !DIExpression()), !dbg !235
  %4 = icmp ne i8** %1, null, !dbg !238
  br i1 %4, label %6, label %5, !dbg !238

5:                                                ; preds = %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.11, i64 0, i64 0), i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @.str.7, i64 0, i64 0), i32 noundef 44, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__.bounded_spsc_init, i64 0, i64 0)) #5, !dbg !238
  unreachable, !dbg !238

6:                                                ; preds = %3
  %7 = icmp ne i32 %2, 0, !dbg !241
  br i1 %7, label %9, label %8, !dbg !241

8:                                                ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([31 x i8], [31 x i8]* @.str.13, i64 0, i64 0), i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @.str.7, i64 0, i64 0), i32 noundef 45, i8* noundef getelementptr inbounds ([61 x i8], [61 x i8]* @__PRETTY_FUNCTION__.bounded_spsc_init, i64 0, i64 0)) #5, !dbg !241
  unreachable, !dbg !241

9:                                                ; preds = %6
  %10 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %0, i32 0, i32 0, !dbg !244
  store i8** %1, i8*** %10, align 8, !dbg !245
  %11 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %0, i32 0, i32 3, !dbg !246
  store i32 %2, i32* %11, align 8, !dbg !247
  %12 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %0, i32 0, i32 1, !dbg !248
  call void @vatomic32_init(%struct.vatomic32_s* noundef %12, i32 noundef 0), !dbg !249
  %13 = getelementptr inbounds %struct.bounded_spsc_t, %struct.bounded_spsc_t* %0, i32 0, i32 2, !dbg !250
  call void @vatomic32_init(%struct.vatomic32_s* noundef %13, i32 noundef 0), !dbg !251
  ret void, !dbg !252
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !253 {
  call void @llvm.dbg.value(metadata i64 %0, metadata !256, metadata !DIExpression()), !dbg !257
  call void @llvm.dbg.value(metadata i8* (i8*)* %1, metadata !258, metadata !DIExpression()), !dbg !257
  %3 = mul i64 32, %0, !dbg !259
  %4 = call noalias i8* @malloc(i64 noundef %3) #6, !dbg !260
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !260
  call void @llvm.dbg.value(metadata %struct.run_info_t* %5, metadata !261, metadata !DIExpression()), !dbg !257
  call void @create_threads(%struct.run_info_t* noundef %5, i64 noundef %0, i8* (i8*)* noundef %1, i1 noundef zeroext true), !dbg !262
  call void @await_threads(%struct.run_info_t* noundef %5, i64 noundef %0), !dbg !263
  call void @free(i8* noundef %4) #6, !dbg !264
  ret void, !dbg !265
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !266 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !271, metadata !DIExpression()), !dbg !272
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !273, !srcloc !274
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !275
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !276
  call void @llvm.dbg.value(metadata i32 %3, metadata !277, metadata !DIExpression()), !dbg !272
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !278, !srcloc !279
  ret i32 %3, !dbg !280
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !281 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !284, metadata !DIExpression()), !dbg !285
  call void @llvm.dbg.value(metadata i32 %1, metadata !286, metadata !DIExpression()), !dbg !285
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !287, !srcloc !288
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !289
  store atomic i32 %1, i32* %3 release, align 4, !dbg !290
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !291, !srcloc !292
  ret void, !dbg !293
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !294 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !295, metadata !DIExpression()), !dbg !296
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !297, !srcloc !298
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !299
  %3 = load atomic i32, i32* %2 acquire, align 4, !dbg !300
  call void @llvm.dbg.value(metadata i32 %3, metadata !301, metadata !DIExpression()), !dbg !296
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !302, !srcloc !303
  ret i32 %3, !dbg !304
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_init(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !305 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !307, metadata !DIExpression()), !dbg !308
  call void @llvm.dbg.value(metadata i32 %1, metadata !309, metadata !DIExpression()), !dbg !308
  call void @vatomic32_write(%struct.vatomic32_s* noundef %0, i32 noundef %1), !dbg !310
  ret void, !dbg !311
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !312 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !313, metadata !DIExpression()), !dbg !314
  call void @llvm.dbg.value(metadata i32 %1, metadata !315, metadata !DIExpression()), !dbg !314
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !316, !srcloc !317
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !318
  store atomic i32 %1, i32* %3 seq_cst, align 4, !dbg !319
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #6, !dbg !320, !srcloc !321
  ret void, !dbg !322
}

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !323 {
  call void @llvm.dbg.value(metadata %struct.run_info_t* %0, metadata !326, metadata !DIExpression()), !dbg !327
  call void @llvm.dbg.value(metadata i64 %1, metadata !328, metadata !DIExpression()), !dbg !327
  call void @llvm.dbg.value(metadata i8* (i8*)* %2, metadata !329, metadata !DIExpression()), !dbg !327
  %5 = zext i1 %3 to i8
  call void @llvm.dbg.value(metadata i8 %5, metadata !330, metadata !DIExpression()), !dbg !327
  call void @llvm.dbg.value(metadata i64 0, metadata !331, metadata !DIExpression()), !dbg !327
  call void @llvm.dbg.value(metadata i64 0, metadata !331, metadata !DIExpression()), !dbg !327
  br label %6, !dbg !332

6:                                                ; preds = %7, %4
  %.0 = phi i64 [ 0, %4 ], [ %15, %7 ], !dbg !334
  call void @llvm.dbg.value(metadata i64 %.0, metadata !331, metadata !DIExpression()), !dbg !327
  %exitcond = icmp ne i64 %.0, %1, !dbg !335
  br i1 %exitcond, label %7, label %16, !dbg !337

7:                                                ; preds = %6
  %8 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %0, i64 %.0, !dbg !338
  %9 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %8, i32 0, i32 1, !dbg !340
  store i64 %.0, i64* %9, align 8, !dbg !341
  %10 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %8, i32 0, i32 3, !dbg !342
  store i8* (i8*)* %2, i8* (i8*)** %10, align 8, !dbg !343
  %11 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %8, i32 0, i32 2, !dbg !344
  store i8 %5, i8* %11, align 8, !dbg !345
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %8, i32 0, i32 0, !dbg !346
  %13 = bitcast %struct.run_info_t* %8 to i8*, !dbg !347
  %14 = call i32 @pthread_create(i64* noundef %12, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %13) #6, !dbg !348
  %15 = add i64 %.0, 1, !dbg !349
  call void @llvm.dbg.value(metadata i64 %15, metadata !331, metadata !DIExpression()), !dbg !327
  br label %6, !dbg !350, !llvm.loop !351

16:                                               ; preds = %6
  ret void, !dbg !353
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !354 {
  call void @llvm.dbg.value(metadata %struct.run_info_t* %0, metadata !357, metadata !DIExpression()), !dbg !358
  call void @llvm.dbg.value(metadata i64 %1, metadata !359, metadata !DIExpression()), !dbg !358
  call void @llvm.dbg.value(metadata i64 0, metadata !360, metadata !DIExpression()), !dbg !358
  call void @llvm.dbg.value(metadata i64 0, metadata !360, metadata !DIExpression()), !dbg !358
  br label %3, !dbg !361

3:                                                ; preds = %4, %2
  %.0 = phi i64 [ 0, %2 ], [ %9, %4 ], !dbg !363
  call void @llvm.dbg.value(metadata i64 %.0, metadata !360, metadata !DIExpression()), !dbg !358
  %exitcond = icmp ne i64 %.0, %1, !dbg !364
  br i1 %exitcond, label %4, label %10, !dbg !366

4:                                                ; preds = %3
  %5 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %0, i64 %.0, !dbg !367
  %6 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %5, i32 0, i32 0, !dbg !369
  %7 = load i64, i64* %6, align 8, !dbg !369
  %8 = call i32 @pthread_join(i64 noundef %7, i8** noundef null), !dbg !370
  %9 = add i64 %.0, 1, !dbg !371
  call void @llvm.dbg.value(metadata i64 %9, metadata !360, metadata !DIExpression()), !dbg !358
  br label %3, !dbg !372, !llvm.loop !373

10:                                               ; preds = %3
  ret void, !dbg !375
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !376 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !377, metadata !DIExpression()), !dbg !378
  %2 = bitcast i8* %0 to %struct.run_info_t*, !dbg !379
  call void @llvm.dbg.value(metadata %struct.run_info_t* %2, metadata !380, metadata !DIExpression()), !dbg !378
  %3 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %2, i32 0, i32 2, !dbg !381
  %4 = load i8, i8* %3, align 8, !dbg !381
  %5 = trunc i8 %4 to i1, !dbg !381
  br i1 %5, label %6, label %9, !dbg !383

6:                                                ; preds = %1
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %2, i32 0, i32 1, !dbg !384
  %8 = load i64, i64* %7, align 8, !dbg !384
  call void @set_cpu_affinity(i64 noundef %8), !dbg !385
  br label %9, !dbg !385

9:                                                ; preds = %6, %1
  %10 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %2, i32 0, i32 3, !dbg !386
  %11 = load i8* (i8*)*, i8* (i8*)** %10, align 8, !dbg !386
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %2, i32 0, i32 1, !dbg !387
  %13 = load i64, i64* %12, align 8, !dbg !387
  %14 = inttoptr i64 %13 to i8*, !dbg !388
  %15 = call i8* %11(i8* noundef %14), !dbg !389
  ret i8* %15, !dbg !390
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !391 {
  call void @llvm.dbg.value(metadata i64 %0, metadata !394, metadata !DIExpression()), !dbg !395
  ret void, !dbg !396
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

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
!1 = distinct !DIGlobalVariable(name: "g_points", scope: !2, file: !25, line: 26, type: !76, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !13, globals: !52, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/libvsync/test/queue/bounded_spsc.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "d6afbd85b08cfd923f1c78769fa692ff")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 8, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "./include/vsync/queue/internal/bounded_ret.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "c46e1376bff92f38e6ff9a1c56080188")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12}
!9 = !DIEnumerator(name: "QUEUE_BOUNDED_OK", value: 0)
!10 = !DIEnumerator(name: "QUEUE_BOUNDED_FULL", value: 1)
!11 = !DIEnumerator(name: "QUEUE_BOUNDED_EMPTY", value: 2)
!12 = !DIEnumerator(name: "QUEUE_BOUNDED_AGAIN", value: 3)
!13 = !{!14, !19, !22, !23, !29, !35}
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsize_t", file: !15, line: 42, baseType: !16)
!15 = !DIFile(filename: "./include/vsync/vtypes.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "6ac6784bf37e03e28013e7eed706797e")
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !17, line: 46, baseType: !18)
!17 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!18 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !15, line: 36, baseType: !20)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !21, line: 90, baseType: !18)
!21 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "point_t", file: !25, line: 20, baseType: !26)
!25 = !DIFile(filename: "test/queue/bounded_spsc.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "d6afbd85b08cfd923f1c78769fa692ff")
!26 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "point_s", file: !25, line: 17, size: 64, elements: !27)
!27 = !{!28, !34}
!28 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !26, file: !25, line: 18, baseType: !29, size: 32)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !15, line: 34, baseType: !30)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !31, line: 26, baseType: !32)
!31 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !33, line: 42, baseType: !7)
!33 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!34 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !26, file: !25, line: 19, baseType: !29, size: 32, offset: 32)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "run_info_t", file: !37, line: 42, baseType: !38)
!37 = !DIFile(filename: "./include/test/thread_launcher.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "30ea34619353fe641f60bde6259a2c36")
!38 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !37, line: 37, size: 256, elements: !39)
!39 = !{!40, !43, !44, !47}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "t", scope: !38, file: !37, line: 38, baseType: !41, size: 64)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !42, line: 27, baseType: !18)
!42 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!43 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !38, file: !37, line: 39, baseType: !14, size: 64, offset: 64)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "assign_me_to_core", scope: !38, file: !37, line: 40, baseType: !45, size: 8, offset: 128)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !15, line: 43, baseType: !46)
!46 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "run_fun", scope: !38, file: !37, line: 41, baseType: !48, size: 64, offset: 192)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "thread_fun_t", file: !37, line: 34, baseType: !49)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!50 = !DISubroutineType(types: !51)
!51 = !{!22, !22}
!52 = !{!53, !58, !74, !0}
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "g_buf", scope: !2, file: !25, line: 22, type: !55, isLocal: false, isDefinition: true)
!55 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 128, elements: !56)
!56 = !{!57}
!57 = !DISubrange(count: 2)
!58 = !DIGlobalVariableExpression(var: !59, expr: !DIExpression())
!59 = distinct !DIGlobalVariable(name: "g_queue", scope: !2, file: !25, line: 23, type: !60, isLocal: false, isDefinition: true)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "bounded_spsc_t", file: !61, line: 32, baseType: !62)
!61 = !DIFile(filename: "./include/vsync/queue/bounded_spsc.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "b2384a9558c2100703c0d4d6501f534d")
!62 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !61, line: 27, size: 192, elements: !63)
!63 = !{!64, !66, !72, !73}
!64 = !DIDerivedType(tag: DW_TAG_member, name: "buf", scope: !62, file: !61, line: 28, baseType: !65, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !62, file: !61, line: 29, baseType: !67, size: 32, align: 32, offset: 64)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !68, line: 62, baseType: !69)
!68 = !DIFile(filename: "./include/vsync/atomic/core.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1cc0657a82f0605ef67642f178a77e1c")
!69 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !68, line: 60, size: 32, align: 32, elements: !70)
!70 = !{!71}
!71 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !69, file: !68, line: 61, baseType: !29, size: 32)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !62, file: !61, line: 30, baseType: !67, size: 32, align: 32, offset: 96)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !62, file: !61, line: 31, baseType: !29, size: 32, offset: 128)
!74 = !DIGlobalVariableExpression(var: !75, expr: !DIExpression())
!75 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !25, line: 24, type: !67, isLocal: false, isDefinition: true)
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
!86 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!87 = distinct !DISubprogram(name: "run", scope: !25, file: !25, line: 29, type: !50, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !88)
!88 = !{}
!89 = !DILocalVariable(name: "arg", arg: 1, scope: !87, file: !25, line: 29, type: !22)
!90 = !DILocation(line: 0, scope: !87)
!91 = !DILocation(line: 31, column: 25, scope: !87)
!92 = !DILocalVariable(name: "tid", scope: !87, file: !25, line: 31, type: !14)
!93 = !DILocation(line: 33, column: 10, scope: !94)
!94 = distinct !DILexicalBlock(scope: !87, file: !25, line: 33, column: 6)
!95 = !DILocation(line: 33, column: 6, scope: !87)
!96 = !DILocalVariable(name: "i", scope: !97, file: !25, line: 34, type: !14)
!97 = distinct !DILexicalBlock(scope: !98, file: !25, line: 34, column: 3)
!98 = distinct !DILexicalBlock(scope: !94, file: !25, line: 33, column: 16)
!99 = !DILocation(line: 0, scope: !97)
!100 = !DILocation(line: 35, column: 21, scope: !101)
!101 = distinct !DILexicalBlock(scope: !102, file: !25, line: 34, column: 40)
!102 = distinct !DILexicalBlock(scope: !97, file: !25, line: 34, column: 3)
!103 = !DILocalVariable(name: "point", scope: !101, file: !25, line: 35, type: !23)
!104 = !DILocation(line: 0, scope: !101)
!105 = !DILocation(line: 36, column: 11, scope: !101)
!106 = !DILocation(line: 36, column: 16, scope: !101)
!107 = !DILocation(line: 37, column: 11, scope: !101)
!108 = !DILocation(line: 37, column: 16, scope: !101)
!109 = !DILocation(line: 38, column: 4, scope: !101)
!110 = distinct !{!110, !109, !111, !112}
!111 = !DILocation(line: 39, column: 5, scope: !101)
!112 = !{!"llvm.loop.mustprogress"}
!113 = !DILocalVariable(name: "i", scope: !114, file: !25, line: 42, type: !116)
!114 = distinct !DILexicalBlock(scope: !115, file: !25, line: 42, column: 3)
!115 = distinct !DILexicalBlock(scope: !94, file: !25, line: 41, column: 9)
!116 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!117 = !DILocation(line: 0, scope: !114)
!118 = !DILocalVariable(name: "r", scope: !119, file: !25, line: 43, type: !22)
!119 = distinct !DILexicalBlock(scope: !120, file: !25, line: 42, column: 36)
!120 = distinct !DILexicalBlock(scope: !114, file: !25, line: 42, column: 3)
!121 = !DILocation(line: 43, column: 10, scope: !119)
!122 = !DILocation(line: 44, column: 4, scope: !119)
!123 = distinct !{!123, !122, !124, !112}
!124 = !DILocation(line: 45, column: 5, scope: !119)
!125 = !DILocation(line: 46, column: 32, scope: !119)
!126 = !DILocation(line: 46, column: 21, scope: !119)
!127 = !DILocalVariable(name: "point", scope: !119, file: !25, line: 46, type: !23)
!128 = !DILocation(line: 0, scope: !119)
!129 = !DILocation(line: 47, column: 8, scope: !130)
!130 = distinct !DILexicalBlock(scope: !119, file: !25, line: 47, column: 8)
!131 = !DILocation(line: 47, column: 8, scope: !119)
!132 = !DILocation(line: 48, column: 5, scope: !133)
!133 = distinct !DILexicalBlock(scope: !134, file: !25, line: 48, column: 5)
!134 = distinct !DILexicalBlock(scope: !135, file: !25, line: 48, column: 5)
!135 = distinct !DILexicalBlock(scope: !130, file: !25, line: 47, column: 15)
!136 = !DILocation(line: 48, column: 5, scope: !134)
!137 = !DILocation(line: 49, column: 5, scope: !138)
!138 = distinct !DILexicalBlock(scope: !139, file: !25, line: 49, column: 5)
!139 = distinct !DILexicalBlock(scope: !135, file: !25, line: 49, column: 5)
!140 = !DILocation(line: 49, column: 5, scope: !139)
!141 = !DILocation(line: 50, column: 5, scope: !135)
!142 = !DILocation(line: 52, column: 5, scope: !143)
!143 = distinct !DILexicalBlock(scope: !144, file: !25, line: 52, column: 5)
!144 = distinct !DILexicalBlock(scope: !145, file: !25, line: 52, column: 5)
!145 = distinct !DILexicalBlock(scope: !130, file: !25, line: 51, column: 11)
!146 = !DILocation(line: 56, column: 2, scope: !87)
!147 = distinct !DISubprogram(name: "bounded_spsc_enq", scope: !61, file: !61, line: 63, type: !148, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!148 = !DISubroutineType(types: !149)
!149 = !{!150, !151, !22}
!150 = !DIDerivedType(tag: DW_TAG_typedef, name: "bounded_ret_t", file: !6, line: 13, baseType: !5)
!151 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!152 = !DILocalVariable(name: "q", arg: 1, scope: !147, file: !61, line: 63, type: !151)
!153 = !DILocation(line: 0, scope: !147)
!154 = !DILocalVariable(name: "v", arg: 2, scope: !147, file: !61, line: 63, type: !22)
!155 = !DILocation(line: 65, column: 2, scope: !156)
!156 = distinct !DILexicalBlock(scope: !157, file: !61, line: 65, column: 2)
!157 = distinct !DILexicalBlock(scope: !147, file: !61, line: 65, column: 2)
!158 = !DILocation(line: 66, column: 2, scope: !159)
!159 = distinct !DILexicalBlock(scope: !160, file: !61, line: 66, column: 2)
!160 = distinct !DILexicalBlock(scope: !147, file: !61, line: 66, column: 2)
!161 = !DILocation(line: 68, column: 42, scope: !147)
!162 = !DILocation(line: 68, column: 19, scope: !147)
!163 = !DILocalVariable(name: "tail", scope: !147, file: !61, line: 68, type: !29)
!164 = !DILocation(line: 69, column: 42, scope: !147)
!165 = !DILocation(line: 69, column: 19, scope: !147)
!166 = !DILocalVariable(name: "head", scope: !147, file: !61, line: 69, type: !29)
!167 = !DILocation(line: 71, column: 11, scope: !168)
!168 = distinct !DILexicalBlock(scope: !147, file: !61, line: 71, column: 6)
!169 = !DILocation(line: 71, column: 24, scope: !168)
!170 = !DILocation(line: 71, column: 18, scope: !168)
!171 = !DILocation(line: 71, column: 6, scope: !147)
!172 = !DILocation(line: 75, column: 5, scope: !147)
!173 = !DILocation(line: 75, column: 14, scope: !147)
!174 = !DILocation(line: 75, column: 2, scope: !147)
!175 = !DILocation(line: 75, column: 25, scope: !147)
!176 = !DILocation(line: 76, column: 37, scope: !147)
!177 = !DILocation(line: 76, column: 2, scope: !147)
!178 = !DILocation(line: 78, column: 2, scope: !147)
!179 = !DILocation(line: 79, column: 1, scope: !147)
!180 = distinct !DISubprogram(name: "bounded_spsc_deq", scope: !61, file: !61, line: 91, type: !181, scopeLine: 92, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!181 = !DISubroutineType(types: !182)
!182 = !{!150, !151, !65}
!183 = !DILocalVariable(name: "q", arg: 1, scope: !180, file: !61, line: 91, type: !151)
!184 = !DILocation(line: 0, scope: !180)
!185 = !DILocalVariable(name: "v", arg: 2, scope: !180, file: !61, line: 91, type: !65)
!186 = !DILocation(line: 93, column: 2, scope: !187)
!187 = distinct !DILexicalBlock(scope: !188, file: !61, line: 93, column: 2)
!188 = distinct !DILexicalBlock(scope: !180, file: !61, line: 93, column: 2)
!189 = !DILocation(line: 94, column: 2, scope: !190)
!190 = distinct !DILexicalBlock(scope: !191, file: !61, line: 94, column: 2)
!191 = distinct !DILexicalBlock(scope: !180, file: !61, line: 94, column: 2)
!192 = !DILocation(line: 96, column: 42, scope: !180)
!193 = !DILocation(line: 96, column: 19, scope: !180)
!194 = !DILocalVariable(name: "head", scope: !180, file: !61, line: 96, type: !29)
!195 = !DILocation(line: 97, column: 42, scope: !180)
!196 = !DILocation(line: 97, column: 19, scope: !180)
!197 = !DILocalVariable(name: "tail", scope: !180, file: !61, line: 97, type: !29)
!198 = !DILocation(line: 99, column: 11, scope: !199)
!199 = distinct !DILexicalBlock(scope: !180, file: !61, line: 99, column: 6)
!200 = !DILocation(line: 99, column: 18, scope: !199)
!201 = !DILocation(line: 99, column: 6, scope: !180)
!202 = !DILocation(line: 103, column: 10, scope: !180)
!203 = !DILocation(line: 103, column: 24, scope: !180)
!204 = !DILocation(line: 103, column: 19, scope: !180)
!205 = !DILocation(line: 103, column: 7, scope: !180)
!206 = !DILocation(line: 103, column: 5, scope: !180)
!207 = !DILocation(line: 104, column: 37, scope: !180)
!208 = !DILocation(line: 104, column: 2, scope: !180)
!209 = !DILocation(line: 106, column: 2, scope: !180)
!210 = !DILocation(line: 107, column: 1, scope: !180)
!211 = distinct !DISubprogram(name: "main", scope: !25, file: !25, line: 60, type: !212, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !88)
!212 = !DISubroutineType(types: !213)
!213 = !{!116}
!214 = !DILocation(line: 62, column: 2, scope: !211)
!215 = !DILocalVariable(name: "i", scope: !216, file: !25, line: 63, type: !14)
!216 = distinct !DILexicalBlock(scope: !211, file: !25, line: 63, column: 2)
!217 = !DILocation(line: 0, scope: !216)
!218 = !DILocation(line: 64, column: 17, scope: !219)
!219 = distinct !DILexicalBlock(scope: !220, file: !25, line: 63, column: 39)
!220 = distinct !DILexicalBlock(scope: !216, file: !25, line: 63, column: 2)
!221 = !DILocation(line: 64, column: 15, scope: !219)
!222 = !DILocation(line: 65, column: 19, scope: !223)
!223 = distinct !DILexicalBlock(scope: !219, file: !25, line: 65, column: 7)
!224 = !DILocation(line: 65, column: 7, scope: !219)
!225 = !DILocation(line: 66, column: 4, scope: !226)
!226 = distinct !DILexicalBlock(scope: !227, file: !25, line: 66, column: 4)
!227 = distinct !DILexicalBlock(scope: !228, file: !25, line: 66, column: 4)
!228 = distinct !DILexicalBlock(scope: !223, file: !25, line: 65, column: 28)
!229 = !DILocation(line: 69, column: 2, scope: !211)
!230 = !DILocation(line: 70, column: 2, scope: !211)
!231 = distinct !DISubprogram(name: "bounded_spsc_init", scope: !61, file: !61, line: 42, type: !232, scopeLine: 43, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!232 = !DISubroutineType(types: !233)
!233 = !{null, !151, !65, !29}
!234 = !DILocalVariable(name: "q", arg: 1, scope: !231, file: !61, line: 42, type: !151)
!235 = !DILocation(line: 0, scope: !231)
!236 = !DILocalVariable(name: "b", arg: 2, scope: !231, file: !61, line: 42, type: !65)
!237 = !DILocalVariable(name: "s", arg: 3, scope: !231, file: !61, line: 42, type: !29)
!238 = !DILocation(line: 44, column: 2, scope: !239)
!239 = distinct !DILexicalBlock(scope: !240, file: !61, line: 44, column: 2)
!240 = distinct !DILexicalBlock(scope: !231, file: !61, line: 44, column: 2)
!241 = !DILocation(line: 45, column: 2, scope: !242)
!242 = distinct !DILexicalBlock(scope: !243, file: !61, line: 45, column: 2)
!243 = distinct !DILexicalBlock(scope: !231, file: !61, line: 45, column: 2)
!244 = !DILocation(line: 47, column: 5, scope: !231)
!245 = !DILocation(line: 47, column: 9, scope: !231)
!246 = !DILocation(line: 48, column: 5, scope: !231)
!247 = !DILocation(line: 48, column: 10, scope: !231)
!248 = !DILocation(line: 50, column: 21, scope: !231)
!249 = !DILocation(line: 50, column: 2, scope: !231)
!250 = !DILocation(line: 51, column: 21, scope: !231)
!251 = !DILocation(line: 51, column: 2, scope: !231)
!252 = !DILocation(line: 52, column: 1, scope: !231)
!253 = distinct !DISubprogram(name: "launch_threads", scope: !37, file: !37, line: 115, type: !254, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!254 = !DISubroutineType(types: !255)
!255 = !{null, !14, !48}
!256 = !DILocalVariable(name: "thread_count", arg: 1, scope: !253, file: !37, line: 115, type: !14)
!257 = !DILocation(line: 0, scope: !253)
!258 = !DILocalVariable(name: "fun", arg: 2, scope: !253, file: !37, line: 115, type: !48)
!259 = !DILocation(line: 117, column: 50, scope: !253)
!260 = !DILocation(line: 117, column: 24, scope: !253)
!261 = !DILocalVariable(name: "threads", scope: !253, file: !37, line: 117, type: !35)
!262 = !DILocation(line: 119, column: 2, scope: !253)
!263 = !DILocation(line: 121, column: 2, scope: !253)
!264 = !DILocation(line: 123, column: 2, scope: !253)
!265 = !DILocation(line: 124, column: 1, scope: !253)
!266 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !267, file: !267, line: 193, type: !268, scopeLine: 194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!267 = !DIFile(filename: "./include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "31d9a9647b315cadb2f817a7c8e98ecf")
!268 = !DISubroutineType(types: !269)
!269 = !{!29, !270}
!270 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!271 = !DILocalVariable(name: "a", arg: 1, scope: !266, file: !267, line: 193, type: !270)
!272 = !DILocation(line: 0, scope: !266)
!273 = !DILocation(line: 195, column: 2, scope: !266)
!274 = !{i64 2148141992}
!275 = !DILocation(line: 197, column: 7, scope: !266)
!276 = !DILocation(line: 196, column: 29, scope: !266)
!277 = !DILocalVariable(name: "tmp", scope: !266, file: !267, line: 196, type: !29)
!278 = !DILocation(line: 198, column: 2, scope: !266)
!279 = !{i64 2148142038}
!280 = !DILocation(line: 199, column: 2, scope: !266)
!281 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !267, file: !267, line: 438, type: !282, scopeLine: 439, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!282 = !DISubroutineType(types: !283)
!283 = !{null, !270, !29}
!284 = !DILocalVariable(name: "a", arg: 1, scope: !281, file: !267, line: 438, type: !270)
!285 = !DILocation(line: 0, scope: !281)
!286 = !DILocalVariable(name: "v", arg: 2, scope: !281, file: !267, line: 438, type: !29)
!287 = !DILocation(line: 440, column: 2, scope: !281)
!288 = !{i64 2148143420}
!289 = !DILocation(line: 441, column: 23, scope: !281)
!290 = !DILocation(line: 441, column: 2, scope: !281)
!291 = !DILocation(line: 442, column: 2, scope: !281)
!292 = !{i64 2148143466}
!293 = !DILocation(line: 443, column: 1, scope: !281)
!294 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !267, file: !267, line: 178, type: !268, scopeLine: 179, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!295 = !DILocalVariable(name: "a", arg: 1, scope: !294, file: !267, line: 178, type: !270)
!296 = !DILocation(line: 0, scope: !294)
!297 = !DILocation(line: 180, column: 2, scope: !294)
!298 = !{i64 2148141908}
!299 = !DILocation(line: 182, column: 7, scope: !294)
!300 = !DILocation(line: 181, column: 29, scope: !294)
!301 = !DILocalVariable(name: "tmp", scope: !294, file: !267, line: 181, type: !29)
!302 = !DILocation(line: 183, column: 2, scope: !294)
!303 = !{i64 2148141954}
!304 = !DILocation(line: 184, column: 2, scope: !294)
!305 = distinct !DISubprogram(name: "vatomic32_init", scope: !306, file: !306, line: 4189, type: !282, scopeLine: 4190, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!306 = !DIFile(filename: "./include/vsync/atomic/internal/fallback.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "bfc5d50ad810da3af0d582a48b47498f")
!307 = !DILocalVariable(name: "a", arg: 1, scope: !305, file: !306, line: 4189, type: !270)
!308 = !DILocation(line: 0, scope: !305)
!309 = !DILocalVariable(name: "v", arg: 2, scope: !305, file: !306, line: 4189, type: !29)
!310 = !DILocation(line: 4191, column: 2, scope: !305)
!311 = !DILocation(line: 4192, column: 1, scope: !305)
!312 = distinct !DISubprogram(name: "vatomic32_write", scope: !267, file: !267, line: 425, type: !282, scopeLine: 426, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!313 = !DILocalVariable(name: "a", arg: 1, scope: !312, file: !267, line: 425, type: !270)
!314 = !DILocation(line: 0, scope: !312)
!315 = !DILocalVariable(name: "v", arg: 2, scope: !312, file: !267, line: 425, type: !29)
!316 = !DILocation(line: 427, column: 2, scope: !312)
!317 = !{i64 2148143336}
!318 = !DILocation(line: 428, column: 23, scope: !312)
!319 = !DILocation(line: 428, column: 2, scope: !312)
!320 = !DILocation(line: 429, column: 2, scope: !312)
!321 = !{i64 2148143382}
!322 = !DILocation(line: 430, column: 1, scope: !312)
!323 = distinct !DISubprogram(name: "create_threads", scope: !37, file: !37, line: 87, type: !324, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!324 = !DISubroutineType(types: !325)
!325 = !{null, !35, !14, !48, !45}
!326 = !DILocalVariable(name: "threads", arg: 1, scope: !323, file: !37, line: 87, type: !35)
!327 = !DILocation(line: 0, scope: !323)
!328 = !DILocalVariable(name: "num_threads", arg: 2, scope: !323, file: !37, line: 87, type: !14)
!329 = !DILocalVariable(name: "fun", arg: 3, scope: !323, file: !37, line: 87, type: !48)
!330 = !DILocalVariable(name: "bind", arg: 4, scope: !323, file: !37, line: 88, type: !45)
!331 = !DILocalVariable(name: "i", scope: !323, file: !37, line: 90, type: !14)
!332 = !DILocation(line: 91, column: 7, scope: !333)
!333 = distinct !DILexicalBlock(scope: !323, file: !37, line: 91, column: 2)
!334 = !DILocation(line: 0, scope: !333)
!335 = !DILocation(line: 91, column: 16, scope: !336)
!336 = distinct !DILexicalBlock(scope: !333, file: !37, line: 91, column: 2)
!337 = !DILocation(line: 91, column: 2, scope: !333)
!338 = !DILocation(line: 92, column: 3, scope: !339)
!339 = distinct !DILexicalBlock(scope: !336, file: !37, line: 91, column: 36)
!340 = !DILocation(line: 92, column: 14, scope: !339)
!341 = !DILocation(line: 92, column: 21, scope: !339)
!342 = !DILocation(line: 93, column: 14, scope: !339)
!343 = !DILocation(line: 93, column: 25, scope: !339)
!344 = !DILocation(line: 94, column: 14, scope: !339)
!345 = !DILocation(line: 94, column: 32, scope: !339)
!346 = !DILocation(line: 95, column: 30, scope: !339)
!347 = !DILocation(line: 95, column: 48, scope: !339)
!348 = !DILocation(line: 95, column: 3, scope: !339)
!349 = !DILocation(line: 91, column: 32, scope: !336)
!350 = !DILocation(line: 91, column: 2, scope: !336)
!351 = distinct !{!351, !337, !352, !112}
!352 = !DILocation(line: 96, column: 2, scope: !333)
!353 = !DILocation(line: 98, column: 1, scope: !323)
!354 = distinct !DISubprogram(name: "await_threads", scope: !37, file: !37, line: 101, type: !355, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!355 = !DISubroutineType(types: !356)
!356 = !{null, !35, !14}
!357 = !DILocalVariable(name: "threads", arg: 1, scope: !354, file: !37, line: 101, type: !35)
!358 = !DILocation(line: 0, scope: !354)
!359 = !DILocalVariable(name: "num_threads", arg: 2, scope: !354, file: !37, line: 101, type: !14)
!360 = !DILocalVariable(name: "i", scope: !354, file: !37, line: 103, type: !14)
!361 = !DILocation(line: 104, column: 7, scope: !362)
!362 = distinct !DILexicalBlock(scope: !354, file: !37, line: 104, column: 2)
!363 = !DILocation(line: 0, scope: !362)
!364 = !DILocation(line: 104, column: 16, scope: !365)
!365 = distinct !DILexicalBlock(scope: !362, file: !37, line: 104, column: 2)
!366 = !DILocation(line: 104, column: 2, scope: !362)
!367 = !DILocation(line: 105, column: 16, scope: !368)
!368 = distinct !DILexicalBlock(scope: !365, file: !37, line: 104, column: 36)
!369 = !DILocation(line: 105, column: 27, scope: !368)
!370 = !DILocation(line: 105, column: 3, scope: !368)
!371 = !DILocation(line: 104, column: 32, scope: !365)
!372 = !DILocation(line: 104, column: 2, scope: !365)
!373 = distinct !{!373, !366, !374, !112}
!374 = !DILocation(line: 106, column: 2, scope: !362)
!375 = !DILocation(line: 107, column: 1, scope: !354)
!376 = distinct !DISubprogram(name: "common_run", scope: !37, file: !37, line: 47, type: !50, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!377 = !DILocalVariable(name: "args", arg: 1, scope: !376, file: !37, line: 47, type: !22)
!378 = !DILocation(line: 0, scope: !376)
!379 = !DILocation(line: 49, column: 25, scope: !376)
!380 = !DILocalVariable(name: "run_info", scope: !376, file: !37, line: 49, type: !35)
!381 = !DILocation(line: 51, column: 16, scope: !382)
!382 = distinct !DILexicalBlock(scope: !376, file: !37, line: 51, column: 6)
!383 = !DILocation(line: 51, column: 6, scope: !376)
!384 = !DILocation(line: 52, column: 30, scope: !382)
!385 = !DILocation(line: 52, column: 3, scope: !382)
!386 = !DILocation(line: 56, column: 19, scope: !376)
!387 = !DILocation(line: 56, column: 45, scope: !376)
!388 = !DILocation(line: 56, column: 27, scope: !376)
!389 = !DILocation(line: 56, column: 9, scope: !376)
!390 = !DILocation(line: 56, column: 2, scope: !376)
!391 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !37, file: !37, line: 65, type: !392, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !88)
!392 = !DISubroutineType(types: !393)
!393 = !{null, !14}
!394 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !391, file: !37, line: 65, type: !14)
!395 = !DILocation(line: 0, scope: !391)
!396 = !DILocation(line: 84, column: 1, scope: !391)
