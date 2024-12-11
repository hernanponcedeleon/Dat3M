; ModuleID = '/home/stefano/huawei/libvsync/spinlock/test/rec_mcslock.c'
source_filename = "/home/stefano/huawei/libvsync/spinlock/test/rec_mcslock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.rec_mcslock_s = type { %struct.mcslock_s, %struct.vatomic32_s, i32 }
%struct.mcslock_s = type { %struct.vatomicptr_s }
%struct.vatomicptr_s = type { i8* }
%struct.vatomic32_s = type { i32 }
%struct.mcs_node_s = type { %struct.vatomicptr_s, %struct.vatomic32_s }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !53
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [68 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 0 + 1)\00", align 1
@lock = dso_local global %struct.rec_mcslock_s { %struct.mcslock_s zeroinitializer, %struct.vatomic32_s { i32 -1 }, i32 0 }, align 8, !dbg !34
@nodes = dso_local global [3 x %struct.mcs_node_s] zeroinitializer, align 16, !dbg !48
@.str.3 = private unnamed_addr constant [23 x i8] c"this value is reserved\00", align 1
@.str.4 = private unnamed_addr constant [48 x i8] c"id != (4294967295U) && \22this value is reserved\22\00", align 1
@.str.5 = private unnamed_addr constant [76 x i8] c"/home/stefano/huawei/libvsync/spinlock/include/vsync/spinlock/rec_mcslock.h\00", align 1
@__PRETTY_FUNCTION__.rec_mcslock_acquire = private unnamed_addr constant [67 x i8] c"void rec_mcslock_acquire(rec_mcslock_t *, vuint32_t, mcs_node_t *)\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !64 {
  ret void, !dbg !68
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !69 {
  ret void, !dbg !70
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !71 {
  ret void, !dbg !72
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !73 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !74
  %2 = add i32 %1, 1, !dbg !74
  store i32 %2, i32* @g_cs_x, align 4, !dbg !74
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !75
  %4 = add i32 %3, 1, !dbg !75
  store i32 %4, i32* @g_cs_y, align 4, !dbg !75
  ret void, !dbg !76
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !77 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !78
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !78
  %3 = icmp eq i32 %1, %2, !dbg !78
  br i1 %3, label %4, label %5, !dbg !81

4:                                                ; preds = %0
  br label %6, !dbg !81

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 112, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !78
  unreachable, !dbg !78

6:                                                ; preds = %4
  %7 = load i32, i32* @g_cs_x, align 4, !dbg !82
  %8 = icmp eq i32 %7, 4, !dbg !82
  br i1 %8, label %9, label %10, !dbg !85

9:                                                ; preds = %6
  br label %11, !dbg !85

10:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 113, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !82
  unreachable, !dbg !82

11:                                               ; preds = %9
  ret void, !dbg !86
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !87 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i64]* %2, metadata !91, metadata !DIExpression()), !dbg !95
  call void @init(), !dbg !96
  call void @llvm.dbg.declare(metadata i64* %3, metadata !97, metadata !DIExpression()), !dbg !99
  store i64 0, i64* %3, align 8, !dbg !99
  br label %5, !dbg !100

5:                                                ; preds = %14, %0
  %6 = load i64, i64* %3, align 8, !dbg !101
  %7 = icmp ult i64 %6, 3, !dbg !103
  br i1 %7, label %8, label %17, !dbg !104

8:                                                ; preds = %5
  %9 = load i64, i64* %3, align 8, !dbg !105
  %10 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %9, !dbg !107
  %11 = load i64, i64* %3, align 8, !dbg !108
  %12 = inttoptr i64 %11 to i8*, !dbg !109
  %13 = call i32 @pthread_create(i64* noundef %10, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef %12) #6, !dbg !110
  br label %14, !dbg !111

14:                                               ; preds = %8
  %15 = load i64, i64* %3, align 8, !dbg !112
  %16 = add i64 %15, 1, !dbg !112
  store i64 %16, i64* %3, align 8, !dbg !112
  br label %5, !dbg !113, !llvm.loop !114

17:                                               ; preds = %5
  call void @post(), !dbg !117
  call void @llvm.dbg.declare(metadata i64* %4, metadata !118, metadata !DIExpression()), !dbg !120
  store i64 0, i64* %4, align 8, !dbg !120
  br label %18, !dbg !121

18:                                               ; preds = %26, %17
  %19 = load i64, i64* %4, align 8, !dbg !122
  %20 = icmp ult i64 %19, 3, !dbg !124
  br i1 %20, label %21, label %29, !dbg !125

21:                                               ; preds = %18
  %22 = load i64, i64* %4, align 8, !dbg !126
  %23 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %22, !dbg !128
  %24 = load i64, i64* %23, align 8, !dbg !128
  %25 = call i32 @pthread_join(i64 noundef %24, i8** noundef null), !dbg !129
  br label %26, !dbg !130

26:                                               ; preds = %21
  %27 = load i64, i64* %4, align 8, !dbg !131
  %28 = add i64 %27, 1, !dbg !131
  store i64 %28, i64* %4, align 8, !dbg !131
  br label %18, !dbg !132, !llvm.loop !133

29:                                               ; preds = %18
  call void @check(), !dbg !135
  call void @fini(), !dbg !136
  ret i32 0, !dbg !137
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !138 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !141, metadata !DIExpression()), !dbg !142
  call void @llvm.dbg.declare(metadata i32* %3, metadata !143, metadata !DIExpression()), !dbg !144
  %7 = load i8*, i8** %2, align 8, !dbg !145
  %8 = ptrtoint i8* %7 to i64, !dbg !146
  %9 = trunc i64 %8 to i32, !dbg !146
  store i32 %9, i32* %3, align 4, !dbg !144
  call void @llvm.dbg.declare(metadata i32* %4, metadata !147, metadata !DIExpression()), !dbg !149
  store i32 0, i32* %4, align 4, !dbg !149
  br label %10, !dbg !150

10:                                               ; preds = %65, %1
  %11 = load i32, i32* %4, align 4, !dbg !151
  %12 = icmp eq i32 %11, 0, !dbg !153
  br i1 %12, label %22, label %13, !dbg !154

13:                                               ; preds = %10
  %14 = load i32, i32* %4, align 4, !dbg !155
  %15 = icmp eq i32 %14, 1, !dbg !155
  br i1 %15, label %16, label %20, !dbg !155

16:                                               ; preds = %13
  %17 = load i32, i32* %3, align 4, !dbg !155
  %18 = add i32 %17, 1, !dbg !155
  %19 = icmp ult i32 %18, 1, !dbg !155
  br label %20

20:                                               ; preds = %16, %13
  %21 = phi i1 [ false, %13 ], [ %19, %16 ], !dbg !156
  br label %22, !dbg !154

22:                                               ; preds = %20, %10
  %23 = phi i1 [ true, %10 ], [ %21, %20 ]
  br i1 %23, label %24, label %68, !dbg !157

24:                                               ; preds = %22
  call void @llvm.dbg.declare(metadata i32* %5, metadata !158, metadata !DIExpression()), !dbg !161
  store i32 0, i32* %5, align 4, !dbg !161
  br label %25, !dbg !162

25:                                               ; preds = %41, %24
  %26 = load i32, i32* %5, align 4, !dbg !163
  %27 = icmp eq i32 %26, 0, !dbg !165
  br i1 %27, label %37, label %28, !dbg !166

28:                                               ; preds = %25
  %29 = load i32, i32* %5, align 4, !dbg !167
  %30 = icmp eq i32 %29, 1, !dbg !167
  br i1 %30, label %31, label %35, !dbg !167

31:                                               ; preds = %28
  %32 = load i32, i32* %3, align 4, !dbg !167
  %33 = add i32 %32, 1, !dbg !167
  %34 = icmp ult i32 %33, 2, !dbg !167
  br label %35

35:                                               ; preds = %31, %28
  %36 = phi i1 [ false, %28 ], [ %34, %31 ], !dbg !168
  br label %37, !dbg !166

37:                                               ; preds = %35, %25
  %38 = phi i1 [ true, %25 ], [ %36, %35 ]
  br i1 %38, label %39, label %44, !dbg !169

39:                                               ; preds = %37
  %40 = load i32, i32* %3, align 4, !dbg !170
  call void @acquire(i32 noundef %40), !dbg !172
  call void @cs(), !dbg !173
  br label %41, !dbg !174

41:                                               ; preds = %39
  %42 = load i32, i32* %5, align 4, !dbg !175
  %43 = add nsw i32 %42, 1, !dbg !175
  store i32 %43, i32* %5, align 4, !dbg !175
  br label %25, !dbg !176, !llvm.loop !177

44:                                               ; preds = %37
  call void @llvm.dbg.declare(metadata i32* %6, metadata !179, metadata !DIExpression()), !dbg !181
  store i32 0, i32* %6, align 4, !dbg !181
  br label %45, !dbg !182

45:                                               ; preds = %61, %44
  %46 = load i32, i32* %6, align 4, !dbg !183
  %47 = icmp eq i32 %46, 0, !dbg !185
  br i1 %47, label %57, label %48, !dbg !186

48:                                               ; preds = %45
  %49 = load i32, i32* %6, align 4, !dbg !187
  %50 = icmp eq i32 %49, 1, !dbg !187
  br i1 %50, label %51, label %55, !dbg !187

51:                                               ; preds = %48
  %52 = load i32, i32* %3, align 4, !dbg !187
  %53 = add i32 %52, 1, !dbg !187
  %54 = icmp ult i32 %53, 2, !dbg !187
  br label %55

55:                                               ; preds = %51, %48
  %56 = phi i1 [ false, %48 ], [ %54, %51 ], !dbg !188
  br label %57, !dbg !186

57:                                               ; preds = %55, %45
  %58 = phi i1 [ true, %45 ], [ %56, %55 ]
  br i1 %58, label %59, label %64, !dbg !189

59:                                               ; preds = %57
  %60 = load i32, i32* %3, align 4, !dbg !190
  call void @release(i32 noundef %60), !dbg !192
  br label %61, !dbg !193

61:                                               ; preds = %59
  %62 = load i32, i32* %6, align 4, !dbg !194
  %63 = add nsw i32 %62, 1, !dbg !194
  store i32 %63, i32* %6, align 4, !dbg !194
  br label %45, !dbg !195, !llvm.loop !196

64:                                               ; preds = %57
  br label %65, !dbg !198

65:                                               ; preds = %64
  %66 = load i32, i32* %4, align 4, !dbg !199
  %67 = add nsw i32 %66, 1, !dbg !199
  store i32 %67, i32* %4, align 4, !dbg !199
  br label %10, !dbg !200, !llvm.loop !201

68:                                               ; preds = %22
  ret i8* null, !dbg !203
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !204 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !207, metadata !DIExpression()), !dbg !208
  %3 = load i32, i32* %2, align 4, !dbg !209
  %4 = load i32, i32* %2, align 4, !dbg !210
  %5 = zext i32 %4 to i64, !dbg !211
  %6 = getelementptr inbounds [3 x %struct.mcs_node_s], [3 x %struct.mcs_node_s]* @nodes, i64 0, i64 %5, !dbg !211
  call void @rec_mcslock_acquire(%struct.rec_mcslock_s* noundef @lock, i32 noundef %3, %struct.mcs_node_s* noundef %6), !dbg !212
  ret void, !dbg !213
}

; Function Attrs: noinline nounwind uwtable
define internal void @rec_mcslock_acquire(%struct.rec_mcslock_s* noundef %0, i32 noundef %1, %struct.mcs_node_s* noundef %2) #0 !dbg !214 {
  %4 = alloca %struct.rec_mcslock_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca %struct.mcs_node_s*, align 8
  store %struct.rec_mcslock_s* %0, %struct.rec_mcslock_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.rec_mcslock_s** %4, metadata !218, metadata !DIExpression()), !dbg !219
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !220, metadata !DIExpression()), !dbg !219
  store %struct.mcs_node_s* %2, %struct.mcs_node_s** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.mcs_node_s** %6, metadata !221, metadata !DIExpression()), !dbg !219
  %7 = load i32, i32* %5, align 4, !dbg !222
  %8 = icmp ne i32 %7, -1, !dbg !222
  br i1 %8, label %9, label %11, !dbg !222

9:                                                ; preds = %3
  br i1 true, label %10, label %11, !dbg !225

10:                                               ; preds = %9
  br label %12, !dbg !225

11:                                               ; preds = %9, %3
  call void @__assert_fail(i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([76 x i8], [76 x i8]* @.str.5, i64 0, i64 0), i32 noundef 28, i8* noundef getelementptr inbounds ([67 x i8], [67 x i8]* @__PRETTY_FUNCTION__.rec_mcslock_acquire, i64 0, i64 0)) #5, !dbg !222
  unreachable, !dbg !222

12:                                               ; preds = %10
  %13 = load %struct.rec_mcslock_s*, %struct.rec_mcslock_s** %4, align 8, !dbg !226
  %14 = getelementptr inbounds %struct.rec_mcslock_s, %struct.rec_mcslock_s* %13, i32 0, i32 1, !dbg !226
  %15 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %14), !dbg !226
  %16 = load i32, i32* %5, align 4, !dbg !226
  %17 = icmp eq i32 %15, %16, !dbg !226
  br i1 %17, label %18, label %23, !dbg !219

18:                                               ; preds = %12
  %19 = load %struct.rec_mcslock_s*, %struct.rec_mcslock_s** %4, align 8, !dbg !228
  %20 = getelementptr inbounds %struct.rec_mcslock_s, %struct.rec_mcslock_s* %19, i32 0, i32 2, !dbg !228
  %21 = load i32, i32* %20, align 4, !dbg !228
  %22 = add i32 %21, 1, !dbg !228
  store i32 %22, i32* %20, align 4, !dbg !228
  br label %30, !dbg !228

23:                                               ; preds = %12
  %24 = load %struct.rec_mcslock_s*, %struct.rec_mcslock_s** %4, align 8, !dbg !219
  %25 = getelementptr inbounds %struct.rec_mcslock_s, %struct.rec_mcslock_s* %24, i32 0, i32 0, !dbg !219
  %26 = load %struct.mcs_node_s*, %struct.mcs_node_s** %6, align 8, !dbg !219
  call void @mcslock_acquire(%struct.mcslock_s* noundef %25, %struct.mcs_node_s* noundef %26), !dbg !219
  %27 = load %struct.rec_mcslock_s*, %struct.rec_mcslock_s** %4, align 8, !dbg !219
  %28 = getelementptr inbounds %struct.rec_mcslock_s, %struct.rec_mcslock_s* %27, i32 0, i32 1, !dbg !219
  %29 = load i32, i32* %5, align 4, !dbg !219
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %28, i32 noundef %29), !dbg !219
  br label %30, !dbg !219

30:                                               ; preds = %23, %18
  ret void, !dbg !219
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !230 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !231, metadata !DIExpression()), !dbg !232
  %3 = load i32, i32* %2, align 4, !dbg !233
  %4 = zext i32 %3 to i64, !dbg !234
  %5 = getelementptr inbounds [3 x %struct.mcs_node_s], [3 x %struct.mcs_node_s]* @nodes, i64 0, i64 %4, !dbg !234
  call void @rec_mcslock_release(%struct.rec_mcslock_s* noundef @lock, %struct.mcs_node_s* noundef %5), !dbg !235
  ret void, !dbg !236
}

; Function Attrs: noinline nounwind uwtable
define internal void @rec_mcslock_release(%struct.rec_mcslock_s* noundef %0, %struct.mcs_node_s* noundef %1) #0 !dbg !237 {
  %3 = alloca %struct.rec_mcslock_s*, align 8
  %4 = alloca %struct.mcs_node_s*, align 8
  store %struct.rec_mcslock_s* %0, %struct.rec_mcslock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.rec_mcslock_s** %3, metadata !240, metadata !DIExpression()), !dbg !241
  store %struct.mcs_node_s* %1, %struct.mcs_node_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.mcs_node_s** %4, metadata !242, metadata !DIExpression()), !dbg !241
  %5 = load %struct.rec_mcslock_s*, %struct.rec_mcslock_s** %3, align 8, !dbg !243
  %6 = getelementptr inbounds %struct.rec_mcslock_s, %struct.rec_mcslock_s* %5, i32 0, i32 2, !dbg !243
  %7 = load i32, i32* %6, align 4, !dbg !243
  %8 = icmp eq i32 %7, 0, !dbg !243
  br i1 %8, label %9, label %15, !dbg !241

9:                                                ; preds = %2
  %10 = load %struct.rec_mcslock_s*, %struct.rec_mcslock_s** %3, align 8, !dbg !245
  %11 = getelementptr inbounds %struct.rec_mcslock_s, %struct.rec_mcslock_s* %10, i32 0, i32 1, !dbg !245
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %11, i32 noundef -1), !dbg !245
  %12 = load %struct.rec_mcslock_s*, %struct.rec_mcslock_s** %3, align 8, !dbg !245
  %13 = getelementptr inbounds %struct.rec_mcslock_s, %struct.rec_mcslock_s* %12, i32 0, i32 0, !dbg !245
  %14 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !245
  call void @mcslock_release(%struct.mcslock_s* noundef %13, %struct.mcs_node_s* noundef %14), !dbg !245
  br label %20, !dbg !245

15:                                               ; preds = %2
  %16 = load %struct.rec_mcslock_s*, %struct.rec_mcslock_s** %3, align 8, !dbg !247
  %17 = getelementptr inbounds %struct.rec_mcslock_s, %struct.rec_mcslock_s* %16, i32 0, i32 2, !dbg !247
  %18 = load i32, i32* %17, align 4, !dbg !247
  %19 = add i32 %18, -1, !dbg !247
  store i32 %19, i32* %17, align 4, !dbg !247
  br label %20

20:                                               ; preds = %15, %9
  ret void, !dbg !241
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !249 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !255, metadata !DIExpression()), !dbg !256
  call void @llvm.dbg.declare(metadata i32* %3, metadata !257, metadata !DIExpression()), !dbg !258
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !259
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !260
  %6 = load i32, i32* %5, align 4, !dbg !260
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !261, !srcloc !262
  store i32 %7, i32* %3, align 4, !dbg !261
  %8 = load i32, i32* %3, align 4, !dbg !263
  ret i32 %8, !dbg !264
}

; Function Attrs: noinline nounwind uwtable
define internal void @mcslock_acquire(%struct.mcslock_s* noundef %0, %struct.mcs_node_s* noundef %1) #0 !dbg !265 {
  %3 = alloca %struct.mcslock_s*, align 8
  %4 = alloca %struct.mcs_node_s*, align 8
  %5 = alloca %struct.mcs_node_s*, align 8
  store %struct.mcslock_s* %0, %struct.mcslock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.mcslock_s** %3, metadata !269, metadata !DIExpression()), !dbg !270
  store %struct.mcs_node_s* %1, %struct.mcs_node_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.mcs_node_s** %4, metadata !271, metadata !DIExpression()), !dbg !272
  call void @llvm.dbg.declare(metadata %struct.mcs_node_s** %5, metadata !273, metadata !DIExpression()), !dbg !274
  %6 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !275
  %7 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %6, i32 0, i32 0, !dbg !276
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %7, i8* noundef null), !dbg !277
  %8 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !278
  %9 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %8, i32 0, i32 1, !dbg !279
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %9, i32 noundef 1), !dbg !280
  %10 = load %struct.mcslock_s*, %struct.mcslock_s** %3, align 8, !dbg !281
  %11 = getelementptr inbounds %struct.mcslock_s, %struct.mcslock_s* %10, i32 0, i32 0, !dbg !282
  %12 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !283
  %13 = bitcast %struct.mcs_node_s* %12 to i8*, !dbg !283
  %14 = call i8* @vatomicptr_xchg(%struct.vatomicptr_s* noundef %11, i8* noundef %13), !dbg !284
  %15 = bitcast i8* %14 to %struct.mcs_node_s*, !dbg !285
  store %struct.mcs_node_s* %15, %struct.mcs_node_s** %5, align 8, !dbg !286
  %16 = load %struct.mcs_node_s*, %struct.mcs_node_s** %5, align 8, !dbg !287
  %17 = icmp ne %struct.mcs_node_s* %16, null, !dbg !287
  br i1 %17, label %18, label %26, !dbg !289

18:                                               ; preds = %2
  %19 = load %struct.mcs_node_s*, %struct.mcs_node_s** %5, align 8, !dbg !290
  %20 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %19, i32 0, i32 0, !dbg !292
  %21 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !293
  %22 = bitcast %struct.mcs_node_s* %21 to i8*, !dbg !293
  call void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %20, i8* noundef %22), !dbg !294
  %23 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !295
  %24 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %23, i32 0, i32 1, !dbg !296
  %25 = call i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %24, i32 noundef 0), !dbg !297
  br label %26, !dbg !298

26:                                               ; preds = %18, %2
  ret void, !dbg !299
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !300 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !304, metadata !DIExpression()), !dbg !305
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !306, metadata !DIExpression()), !dbg !307
  %5 = load i32, i32* %4, align 4, !dbg !308
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !309
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !310
  %8 = load i32, i32* %7, align 4, !dbg !310
  call void asm sideeffect "str ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !311, !srcloc !312
  ret void, !dbg !313
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !314 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !318, metadata !DIExpression()), !dbg !319
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !320, metadata !DIExpression()), !dbg !321
  %5 = load i8*, i8** %4, align 8, !dbg !322
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !323
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !324
  %8 = load i8*, i8** %7, align 8, !dbg !324
  call void asm sideeffect "str ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !325, !srcloc !326
  ret void, !dbg !327
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_xchg(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !328 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !332, metadata !DIExpression()), !dbg !333
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !334, metadata !DIExpression()), !dbg !335
  call void @llvm.dbg.declare(metadata i8** %5, metadata !336, metadata !DIExpression()), !dbg !337
  call void @llvm.dbg.declare(metadata i32* %6, metadata !338, metadata !DIExpression()), !dbg !339
  %7 = load i8*, i8** %4, align 8, !dbg !340
  %8 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !341
  %9 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %8, i32 0, i32 0, !dbg !342
  %10 = load i8*, i8** %9, align 8, !dbg !342
  %11 = call { i8*, i32 } asm sideeffect "prfm pstl1strm, $3\0A1:\0Aldaxr ${0:x}, $3\0Astlxr  ${1:w}, ${2:x}, $3\0Acbnz ${1:w}, 1b\0A", "=&r,=&r,r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %7, i8* %10) #6, !dbg !343, !srcloc !344
  %12 = extractvalue { i8*, i32 } %11, 0, !dbg !343
  %13 = extractvalue { i8*, i32 } %11, 1, !dbg !343
  store i8* %12, i8** %5, align 8, !dbg !343
  store i32 %13, i32* %6, align 4, !dbg !343
  %14 = load i8*, i8** %5, align 8, !dbg !345
  ret i8* %14, !dbg !346
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !347 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !348, metadata !DIExpression()), !dbg !349
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !350, metadata !DIExpression()), !dbg !351
  %5 = load i8*, i8** %4, align 8, !dbg !352
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !353
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !354
  %8 = load i8*, i8** %7, align 8, !dbg !354
  call void asm sideeffect "stlr ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !355, !srcloc !356
  ret void, !dbg !357
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !358 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !361, metadata !DIExpression()), !dbg !362
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !363, metadata !DIExpression()), !dbg !364
  call void @llvm.dbg.declare(metadata i32* %5, metadata !365, metadata !DIExpression()), !dbg !366
  %6 = load i32, i32* %4, align 4, !dbg !367
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !368
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !369
  %9 = load i32, i32* %8, align 4, !dbg !369
  %10 = call i32 asm sideeffect "1:\0Aldar ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.ne 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !370, !srcloc !371
  store i32 %10, i32* %5, align 4, !dbg !370
  %11 = load i32, i32* %5, align 4, !dbg !372
  ret i32 %11, !dbg !373
}

; Function Attrs: noinline nounwind uwtable
define internal void @mcslock_release(%struct.mcslock_s* noundef %0, %struct.mcs_node_s* noundef %1) #0 !dbg !374 {
  %3 = alloca %struct.mcslock_s*, align 8
  %4 = alloca %struct.mcs_node_s*, align 8
  %5 = alloca %struct.mcs_node_s*, align 8
  store %struct.mcslock_s* %0, %struct.mcslock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.mcslock_s** %3, metadata !375, metadata !DIExpression()), !dbg !376
  store %struct.mcs_node_s* %1, %struct.mcs_node_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.mcs_node_s** %4, metadata !377, metadata !DIExpression()), !dbg !378
  call void @llvm.dbg.declare(metadata %struct.mcs_node_s** %5, metadata !379, metadata !DIExpression()), !dbg !380
  %6 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !381
  %7 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %6, i32 0, i32 0, !dbg !383
  %8 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %7), !dbg !384
  %9 = icmp eq i8* %8, null, !dbg !385
  br i1 %9, label %10, label %25, !dbg !386

10:                                               ; preds = %2
  %11 = load %struct.mcslock_s*, %struct.mcslock_s** %3, align 8, !dbg !387
  %12 = getelementptr inbounds %struct.mcslock_s, %struct.mcslock_s* %11, i32 0, i32 0, !dbg !389
  %13 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !390
  %14 = bitcast %struct.mcs_node_s* %13 to i8*, !dbg !390
  %15 = call i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %12, i8* noundef %14, i8* noundef null), !dbg !391
  %16 = bitcast i8* %15 to %struct.mcs_node_s*, !dbg !392
  store %struct.mcs_node_s* %16, %struct.mcs_node_s** %5, align 8, !dbg !393
  %17 = load %struct.mcs_node_s*, %struct.mcs_node_s** %5, align 8, !dbg !394
  %18 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !396
  %19 = icmp eq %struct.mcs_node_s* %17, %18, !dbg !397
  br i1 %19, label %20, label %21, !dbg !398

20:                                               ; preds = %10
  br label %32, !dbg !399

21:                                               ; preds = %10
  %22 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !401
  %23 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %22, i32 0, i32 0, !dbg !402
  %24 = call i8* @vatomicptr_await_neq_rlx(%struct.vatomicptr_s* noundef %23, i8* noundef null), !dbg !403
  br label %25, !dbg !404

25:                                               ; preds = %21, %2
  %26 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !405
  %27 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %26, i32 0, i32 0, !dbg !406
  %28 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %27), !dbg !407
  %29 = bitcast i8* %28 to %struct.mcs_node_s*, !dbg !408
  store %struct.mcs_node_s* %29, %struct.mcs_node_s** %5, align 8, !dbg !409
  %30 = load %struct.mcs_node_s*, %struct.mcs_node_s** %5, align 8, !dbg !410
  %31 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %30, i32 0, i32 1, !dbg !411
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %31, i32 noundef 0), !dbg !412
  br label %32, !dbg !413

32:                                               ; preds = %25, %20
  ret void, !dbg !413
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !414 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !419, metadata !DIExpression()), !dbg !420
  call void @llvm.dbg.declare(metadata i8** %3, metadata !421, metadata !DIExpression()), !dbg !422
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !423
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !424
  %6 = load i8*, i8** %5, align 8, !dbg !424
  %7 = call i8* asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !425, !srcloc !426
  store i8* %7, i8** %3, align 8, !dbg !425
  %8 = load i8*, i8** %3, align 8, !dbg !427
  ret i8* %8, !dbg !428
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !429 {
  %4 = alloca %struct.vatomicptr_s*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i32, align 4
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %4, metadata !432, metadata !DIExpression()), !dbg !433
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !434, metadata !DIExpression()), !dbg !435
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !436, metadata !DIExpression()), !dbg !437
  call void @llvm.dbg.declare(metadata i8** %7, metadata !438, metadata !DIExpression()), !dbg !439
  call void @llvm.dbg.declare(metadata i32* %8, metadata !440, metadata !DIExpression()), !dbg !441
  %9 = load i8*, i8** %6, align 8, !dbg !442
  %10 = load i8*, i8** %5, align 8, !dbg !443
  %11 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %4, align 8, !dbg !444
  %12 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %11, i32 0, i32 0, !dbg !445
  %13 = load i8*, i8** %12, align 8, !dbg !445
  %14 = call { i8*, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:x}, $4\0Acmp ${0:x}, ${3:x}\0Ab.ne 2f\0Astlxr  ${1:w}, ${2:x}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i8* %9, i8* %10, i8* %13) #6, !dbg !446, !srcloc !447
  %15 = extractvalue { i8*, i32 } %14, 0, !dbg !446
  %16 = extractvalue { i8*, i32 } %14, 1, !dbg !446
  store i8* %15, i8** %7, align 8, !dbg !446
  store i32 %16, i32* %8, align 4, !dbg !446
  %17 = load i8*, i8** %7, align 8, !dbg !448
  ret i8* %17, !dbg !449
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_await_neq_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !450 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !453, metadata !DIExpression()), !dbg !454
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !455, metadata !DIExpression()), !dbg !456
  call void @llvm.dbg.declare(metadata i8** %5, metadata !457, metadata !DIExpression()), !dbg !458
  %6 = load i8*, i8** %4, align 8, !dbg !459
  %7 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !460
  %8 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %7, i32 0, i32 0, !dbg !461
  %9 = load i8*, i8** %8, align 8, !dbg !461
  %10 = call i8* asm sideeffect "1:\0Aldr ${0:x}, $2\0Acmp ${0:x}, ${1:x}\0Ab.eq 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i8* %6, i8* %9) #6, !dbg !462, !srcloc !463
  store i8* %10, i8** %5, align 8, !dbg !462
  %11 = load i8*, i8** %5, align 8, !dbg !464
  ret i8* %11, !dbg !465
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %0) #0 !dbg !466 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !467, metadata !DIExpression()), !dbg !468
  call void @llvm.dbg.declare(metadata i8** %3, metadata !469, metadata !DIExpression()), !dbg !470
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !471
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !472
  %6 = load i8*, i8** %5, align 8, !dbg !472
  %7 = call i8* asm sideeffect "ldar ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !473, !srcloc !474
  store i8* %7, i8** %3, align 8, !dbg !473
  %8 = load i8*, i8** %3, align 8, !dbg !475
  ret i8* %8, !dbg !476
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !477 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !478, metadata !DIExpression()), !dbg !479
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !480, metadata !DIExpression()), !dbg !481
  %5 = load i32, i32* %4, align 4, !dbg !482
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !483
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !484
  %8 = load i32, i32* %7, align 4, !dbg !484
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !485, !srcloc !486
  ret void, !dbg !487
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!56, !57, !58, !59, !60, !61, !62}
!llvm.ident = !{!63}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !55, line: 100, type: !27, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !33, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/spinlock/test/rec_mcslock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "3d3860a71bfd9085a47c4e582a7eadd5")
!4 = !{!5, !6, !11}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 37, baseType: !8)
!7 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !9, line: 90, baseType: !10)
!9 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "mcs_node_t", file: !13, line: 35, baseType: !14)
!13 = !DIFile(filename: "spinlock/include/vsync/spinlock/mcslock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4fe31f2edce55dd03246e73f5e70d246")
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "mcs_node_s", file: !13, line: 32, size: 128, elements: !15)
!15 = !{!16, !22}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !14, file: !13, line: 33, baseType: !17, size: 64, align: 64)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomicptr_t", file: !18, line: 44, baseType: !19)
!18 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomicptr_s", file: !18, line: 42, size: 64, align: 64, elements: !20)
!20 = !{!21}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !19, file: !18, line: 43, baseType: !5, size: 64)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "locked", scope: !14, file: !13, line: 34, baseType: !23, size: 32, align: 32, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !18, line: 34, baseType: !24)
!24 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !18, line: 32, size: 32, align: 32, elements: !25)
!25 = !{!26}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !24, file: !18, line: 33, baseType: !27, size: 32)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !7, line: 35, baseType: !28)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !29, line: 26, baseType: !30)
!29 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !31, line: 42, baseType: !32)
!31 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!32 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!33 = !{!34, !48, !0, !53}
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !36, line: 6, type: !37, isLocal: false, isDefinition: true)
!36 = !DIFile(filename: "spinlock/test/rec_mcslock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "3d3860a71bfd9085a47c4e582a7eadd5")
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "rec_mcslock_t", file: !38, line: 26, baseType: !39)
!38 = !DIFile(filename: "spinlock/include/vsync/spinlock/rec_mcslock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "c94e9cd1a05b18c3c1561ee08bc22b59")
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "rec_mcslock_s", file: !38, line: 26, size: 128, elements: !40)
!40 = !{!41, !46, !47}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !39, file: !38, line: 26, baseType: !42, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "mcslock_t", file: !13, line: 40, baseType: !43)
!43 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "mcslock_s", file: !13, line: 38, size: 64, elements: !44)
!44 = !{!45}
!45 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !43, file: !13, line: 39, baseType: !17, size: 64, align: 64)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "owner", scope: !39, file: !38, line: 26, baseType: !23, size: 32, align: 32, offset: 64)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !39, file: !38, line: 26, baseType: !27, size: 32, offset: 96)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "nodes", scope: !2, file: !36, line: 7, type: !50, isLocal: false, isDefinition: true)
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 384, elements: !51)
!51 = !{!52}
!52 = !DISubrange(count: 3)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !55, line: 101, type: !27, isLocal: true, isDefinition: true)
!55 = !DIFile(filename: "utils/include/test/boilerplate/lock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4187ade4a536ecfd1f9ed3ab727ca965")
!56 = !{i32 7, !"Dwarf Version", i32 5}
!57 = !{i32 2, !"Debug Info Version", i32 3}
!58 = !{i32 1, !"wchar_size", i32 4}
!59 = !{i32 7, !"PIC Level", i32 2}
!60 = !{i32 7, !"PIE Level", i32 2}
!61 = !{i32 7, !"uwtable", i32 1}
!62 = !{i32 7, !"frame-pointer", i32 2}
!63 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!64 = distinct !DISubprogram(name: "init", scope: !55, file: !55, line: 68, type: !65, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!65 = !DISubroutineType(types: !66)
!66 = !{null}
!67 = !{}
!68 = !DILocation(line: 70, column: 1, scope: !64)
!69 = distinct !DISubprogram(name: "post", scope: !55, file: !55, line: 77, type: !65, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!70 = !DILocation(line: 79, column: 1, scope: !69)
!71 = distinct !DISubprogram(name: "fini", scope: !55, file: !55, line: 86, type: !65, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!72 = !DILocation(line: 88, column: 1, scope: !71)
!73 = distinct !DISubprogram(name: "cs", scope: !55, file: !55, line: 104, type: !65, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!74 = !DILocation(line: 106, column: 11, scope: !73)
!75 = !DILocation(line: 107, column: 11, scope: !73)
!76 = !DILocation(line: 108, column: 1, scope: !73)
!77 = distinct !DISubprogram(name: "check", scope: !55, file: !55, line: 110, type: !65, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!78 = !DILocation(line: 112, column: 5, scope: !79)
!79 = distinct !DILexicalBlock(scope: !80, file: !55, line: 112, column: 5)
!80 = distinct !DILexicalBlock(scope: !77, file: !55, line: 112, column: 5)
!81 = !DILocation(line: 112, column: 5, scope: !80)
!82 = !DILocation(line: 113, column: 5, scope: !83)
!83 = distinct !DILexicalBlock(scope: !84, file: !55, line: 113, column: 5)
!84 = distinct !DILexicalBlock(scope: !77, file: !55, line: 113, column: 5)
!85 = !DILocation(line: 113, column: 5, scope: !84)
!86 = !DILocation(line: 114, column: 1, scope: !77)
!87 = distinct !DISubprogram(name: "main", scope: !55, file: !55, line: 141, type: !88, scopeLine: 142, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!88 = !DISubroutineType(types: !89)
!89 = !{!90}
!90 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!91 = !DILocalVariable(name: "t", scope: !87, file: !55, line: 143, type: !92)
!92 = !DICompositeType(tag: DW_TAG_array_type, baseType: !93, size: 192, elements: !51)
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !94, line: 27, baseType: !10)
!94 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!95 = !DILocation(line: 143, column: 15, scope: !87)
!96 = !DILocation(line: 150, column: 5, scope: !87)
!97 = !DILocalVariable(name: "i", scope: !98, file: !55, line: 152, type: !6)
!98 = distinct !DILexicalBlock(scope: !87, file: !55, line: 152, column: 5)
!99 = !DILocation(line: 152, column: 21, scope: !98)
!100 = !DILocation(line: 152, column: 10, scope: !98)
!101 = !DILocation(line: 152, column: 28, scope: !102)
!102 = distinct !DILexicalBlock(scope: !98, file: !55, line: 152, column: 5)
!103 = !DILocation(line: 152, column: 30, scope: !102)
!104 = !DILocation(line: 152, column: 5, scope: !98)
!105 = !DILocation(line: 153, column: 33, scope: !106)
!106 = distinct !DILexicalBlock(scope: !102, file: !55, line: 152, column: 47)
!107 = !DILocation(line: 153, column: 31, scope: !106)
!108 = !DILocation(line: 153, column: 53, scope: !106)
!109 = !DILocation(line: 153, column: 45, scope: !106)
!110 = !DILocation(line: 153, column: 15, scope: !106)
!111 = !DILocation(line: 154, column: 5, scope: !106)
!112 = !DILocation(line: 152, column: 43, scope: !102)
!113 = !DILocation(line: 152, column: 5, scope: !102)
!114 = distinct !{!114, !104, !115, !116}
!115 = !DILocation(line: 154, column: 5, scope: !98)
!116 = !{!"llvm.loop.mustprogress"}
!117 = !DILocation(line: 156, column: 5, scope: !87)
!118 = !DILocalVariable(name: "i", scope: !119, file: !55, line: 158, type: !6)
!119 = distinct !DILexicalBlock(scope: !87, file: !55, line: 158, column: 5)
!120 = !DILocation(line: 158, column: 21, scope: !119)
!121 = !DILocation(line: 158, column: 10, scope: !119)
!122 = !DILocation(line: 158, column: 28, scope: !123)
!123 = distinct !DILexicalBlock(scope: !119, file: !55, line: 158, column: 5)
!124 = !DILocation(line: 158, column: 30, scope: !123)
!125 = !DILocation(line: 158, column: 5, scope: !119)
!126 = !DILocation(line: 159, column: 30, scope: !127)
!127 = distinct !DILexicalBlock(scope: !123, file: !55, line: 158, column: 47)
!128 = !DILocation(line: 159, column: 28, scope: !127)
!129 = !DILocation(line: 159, column: 15, scope: !127)
!130 = !DILocation(line: 160, column: 5, scope: !127)
!131 = !DILocation(line: 158, column: 43, scope: !123)
!132 = !DILocation(line: 158, column: 5, scope: !123)
!133 = distinct !{!133, !125, !134, !116}
!134 = !DILocation(line: 160, column: 5, scope: !119)
!135 = !DILocation(line: 167, column: 5, scope: !87)
!136 = !DILocation(line: 168, column: 5, scope: !87)
!137 = !DILocation(line: 170, column: 5, scope: !87)
!138 = distinct !DISubprogram(name: "run", scope: !55, file: !55, line: 119, type: !139, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!139 = !DISubroutineType(types: !140)
!140 = !{!5, !5}
!141 = !DILocalVariable(name: "arg", arg: 1, scope: !138, file: !55, line: 119, type: !5)
!142 = !DILocation(line: 119, column: 11, scope: !138)
!143 = !DILocalVariable(name: "tid", scope: !138, file: !55, line: 121, type: !27)
!144 = !DILocation(line: 121, column: 15, scope: !138)
!145 = !DILocation(line: 121, column: 33, scope: !138)
!146 = !DILocation(line: 121, column: 21, scope: !138)
!147 = !DILocalVariable(name: "i", scope: !148, file: !55, line: 125, type: !90)
!148 = distinct !DILexicalBlock(scope: !138, file: !55, line: 125, column: 5)
!149 = !DILocation(line: 125, column: 14, scope: !148)
!150 = !DILocation(line: 125, column: 10, scope: !148)
!151 = !DILocation(line: 125, column: 21, scope: !152)
!152 = distinct !DILexicalBlock(scope: !148, file: !55, line: 125, column: 5)
!153 = !DILocation(line: 125, column: 23, scope: !152)
!154 = !DILocation(line: 125, column: 28, scope: !152)
!155 = !DILocation(line: 125, column: 31, scope: !152)
!156 = !DILocation(line: 0, scope: !152)
!157 = !DILocation(line: 125, column: 5, scope: !148)
!158 = !DILocalVariable(name: "j", scope: !159, file: !55, line: 129, type: !90)
!159 = distinct !DILexicalBlock(scope: !160, file: !55, line: 129, column: 9)
!160 = distinct !DILexicalBlock(scope: !152, file: !55, line: 125, column: 63)
!161 = !DILocation(line: 129, column: 18, scope: !159)
!162 = !DILocation(line: 129, column: 14, scope: !159)
!163 = !DILocation(line: 129, column: 25, scope: !164)
!164 = distinct !DILexicalBlock(scope: !159, file: !55, line: 129, column: 9)
!165 = !DILocation(line: 129, column: 27, scope: !164)
!166 = !DILocation(line: 129, column: 32, scope: !164)
!167 = !DILocation(line: 129, column: 35, scope: !164)
!168 = !DILocation(line: 0, scope: !164)
!169 = !DILocation(line: 129, column: 9, scope: !159)
!170 = !DILocation(line: 130, column: 21, scope: !171)
!171 = distinct !DILexicalBlock(scope: !164, file: !55, line: 129, column: 67)
!172 = !DILocation(line: 130, column: 13, scope: !171)
!173 = !DILocation(line: 131, column: 13, scope: !171)
!174 = !DILocation(line: 132, column: 9, scope: !171)
!175 = !DILocation(line: 129, column: 63, scope: !164)
!176 = !DILocation(line: 129, column: 9, scope: !164)
!177 = distinct !{!177, !169, !178, !116}
!178 = !DILocation(line: 132, column: 9, scope: !159)
!179 = !DILocalVariable(name: "j", scope: !180, file: !55, line: 133, type: !90)
!180 = distinct !DILexicalBlock(scope: !160, file: !55, line: 133, column: 9)
!181 = !DILocation(line: 133, column: 18, scope: !180)
!182 = !DILocation(line: 133, column: 14, scope: !180)
!183 = !DILocation(line: 133, column: 25, scope: !184)
!184 = distinct !DILexicalBlock(scope: !180, file: !55, line: 133, column: 9)
!185 = !DILocation(line: 133, column: 27, scope: !184)
!186 = !DILocation(line: 133, column: 32, scope: !184)
!187 = !DILocation(line: 133, column: 35, scope: !184)
!188 = !DILocation(line: 0, scope: !184)
!189 = !DILocation(line: 133, column: 9, scope: !180)
!190 = !DILocation(line: 134, column: 21, scope: !191)
!191 = distinct !DILexicalBlock(scope: !184, file: !55, line: 133, column: 67)
!192 = !DILocation(line: 134, column: 13, scope: !191)
!193 = !DILocation(line: 135, column: 9, scope: !191)
!194 = !DILocation(line: 133, column: 63, scope: !184)
!195 = !DILocation(line: 133, column: 9, scope: !184)
!196 = distinct !{!196, !189, !197, !116}
!197 = !DILocation(line: 135, column: 9, scope: !180)
!198 = !DILocation(line: 136, column: 5, scope: !160)
!199 = !DILocation(line: 125, column: 59, scope: !152)
!200 = !DILocation(line: 125, column: 5, scope: !152)
!201 = distinct !{!201, !157, !202, !116}
!202 = !DILocation(line: 136, column: 5, scope: !148)
!203 = !DILocation(line: 137, column: 5, scope: !138)
!204 = distinct !DISubprogram(name: "acquire", scope: !36, file: !36, line: 10, type: !205, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!205 = !DISubroutineType(types: !206)
!206 = !{null, !27}
!207 = !DILocalVariable(name: "tid", arg: 1, scope: !204, file: !36, line: 10, type: !27)
!208 = !DILocation(line: 10, column: 19, scope: !204)
!209 = !DILocation(line: 12, column: 32, scope: !204)
!210 = !DILocation(line: 12, column: 44, scope: !204)
!211 = !DILocation(line: 12, column: 38, scope: !204)
!212 = !DILocation(line: 12, column: 5, scope: !204)
!213 = !DILocation(line: 13, column: 1, scope: !204)
!214 = distinct !DISubprogram(name: "rec_mcslock_acquire", scope: !38, file: !38, line: 26, type: !215, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!215 = !DISubroutineType(types: !216)
!216 = !{null, !217, !27, !11}
!217 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!218 = !DILocalVariable(name: "l", arg: 1, scope: !214, file: !38, line: 26, type: !217)
!219 = !DILocation(line: 26, column: 1, scope: !214)
!220 = !DILocalVariable(name: "id", arg: 2, scope: !214, file: !38, line: 26, type: !27)
!221 = !DILocalVariable(name: "ctx", arg: 3, scope: !214, file: !38, line: 26, type: !11)
!222 = !DILocation(line: 26, column: 1, scope: !223)
!223 = distinct !DILexicalBlock(scope: !224, file: !38, line: 26, column: 1)
!224 = distinct !DILexicalBlock(scope: !214, file: !38, line: 26, column: 1)
!225 = !DILocation(line: 26, column: 1, scope: !224)
!226 = !DILocation(line: 26, column: 1, scope: !227)
!227 = distinct !DILexicalBlock(scope: !214, file: !38, line: 26, column: 1)
!228 = !DILocation(line: 26, column: 1, scope: !229)
!229 = distinct !DILexicalBlock(scope: !227, file: !38, line: 26, column: 1)
!230 = distinct !DISubprogram(name: "release", scope: !36, file: !36, line: 16, type: !205, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !67)
!231 = !DILocalVariable(name: "tid", arg: 1, scope: !230, file: !36, line: 16, type: !27)
!232 = !DILocation(line: 16, column: 19, scope: !230)
!233 = !DILocation(line: 18, column: 39, scope: !230)
!234 = !DILocation(line: 18, column: 33, scope: !230)
!235 = !DILocation(line: 18, column: 5, scope: !230)
!236 = !DILocation(line: 19, column: 1, scope: !230)
!237 = distinct !DISubprogram(name: "rec_mcslock_release", scope: !38, file: !38, line: 26, type: !238, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!238 = !DISubroutineType(types: !239)
!239 = !{null, !217, !11}
!240 = !DILocalVariable(name: "l", arg: 1, scope: !237, file: !38, line: 26, type: !217)
!241 = !DILocation(line: 26, column: 1, scope: !237)
!242 = !DILocalVariable(name: "ctx", arg: 2, scope: !237, file: !38, line: 26, type: !11)
!243 = !DILocation(line: 26, column: 1, scope: !244)
!244 = distinct !DILexicalBlock(scope: !237, file: !38, line: 26, column: 1)
!245 = !DILocation(line: 26, column: 1, scope: !246)
!246 = distinct !DILexicalBlock(scope: !244, file: !38, line: 26, column: 1)
!247 = !DILocation(line: 26, column: 1, scope: !248)
!248 = distinct !DILexicalBlock(scope: !244, file: !38, line: 26, column: 1)
!249 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !250, file: !250, line: 101, type: !251, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!250 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!251 = !DISubroutineType(types: !252)
!252 = !{!27, !253}
!253 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !254, size: 64)
!254 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
!255 = !DILocalVariable(name: "a", arg: 1, scope: !249, file: !250, line: 101, type: !253)
!256 = !DILocation(line: 101, column: 39, scope: !249)
!257 = !DILocalVariable(name: "val", scope: !249, file: !250, line: 103, type: !27)
!258 = !DILocation(line: 103, column: 15, scope: !249)
!259 = !DILocation(line: 106, column: 32, scope: !249)
!260 = !DILocation(line: 106, column: 35, scope: !249)
!261 = !DILocation(line: 104, column: 5, scope: !249)
!262 = !{i64 398106}
!263 = !DILocation(line: 108, column: 12, scope: !249)
!264 = !DILocation(line: 108, column: 5, scope: !249)
!265 = distinct !DISubprogram(name: "mcslock_acquire", scope: !13, file: !13, line: 89, type: !266, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!266 = !DISubroutineType(types: !267)
!267 = !{null, !268, !11}
!268 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!269 = !DILocalVariable(name: "l", arg: 1, scope: !265, file: !13, line: 89, type: !268)
!270 = !DILocation(line: 89, column: 28, scope: !265)
!271 = !DILocalVariable(name: "node", arg: 2, scope: !265, file: !13, line: 89, type: !11)
!272 = !DILocation(line: 89, column: 43, scope: !265)
!273 = !DILocalVariable(name: "pred", scope: !265, file: !13, line: 91, type: !11)
!274 = !DILocation(line: 91, column: 17, scope: !265)
!275 = !DILocation(line: 93, column: 27, scope: !265)
!276 = !DILocation(line: 93, column: 33, scope: !265)
!277 = !DILocation(line: 93, column: 5, scope: !265)
!278 = !DILocation(line: 94, column: 26, scope: !265)
!279 = !DILocation(line: 94, column: 32, scope: !265)
!280 = !DILocation(line: 94, column: 5, scope: !265)
!281 = !DILocation(line: 96, column: 43, scope: !265)
!282 = !DILocation(line: 96, column: 46, scope: !265)
!283 = !DILocation(line: 96, column: 52, scope: !265)
!284 = !DILocation(line: 96, column: 26, scope: !265)
!285 = !DILocation(line: 96, column: 12, scope: !265)
!286 = !DILocation(line: 96, column: 10, scope: !265)
!287 = !DILocation(line: 97, column: 9, scope: !288)
!288 = distinct !DILexicalBlock(scope: !265, file: !13, line: 97, column: 9)
!289 = !DILocation(line: 97, column: 9, scope: !265)
!290 = !DILocation(line: 98, column: 31, scope: !291)
!291 = distinct !DILexicalBlock(scope: !288, file: !13, line: 97, column: 15)
!292 = !DILocation(line: 98, column: 37, scope: !291)
!293 = !DILocation(line: 98, column: 43, scope: !291)
!294 = !DILocation(line: 98, column: 9, scope: !291)
!295 = !DILocation(line: 99, column: 33, scope: !291)
!296 = !DILocation(line: 99, column: 39, scope: !291)
!297 = !DILocation(line: 99, column: 9, scope: !291)
!298 = !DILocation(line: 100, column: 5, scope: !291)
!299 = !DILocation(line: 101, column: 1, scope: !265)
!300 = distinct !DISubprogram(name: "vatomic32_write_rlx", scope: !250, file: !250, line: 241, type: !301, scopeLine: 242, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!301 = !DISubroutineType(types: !302)
!302 = !{null, !303, !27}
!303 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!304 = !DILocalVariable(name: "a", arg: 1, scope: !300, file: !250, line: 241, type: !303)
!305 = !DILocation(line: 241, column: 34, scope: !300)
!306 = !DILocalVariable(name: "v", arg: 2, scope: !300, file: !250, line: 241, type: !27)
!307 = !DILocation(line: 241, column: 47, scope: !300)
!308 = !DILocation(line: 245, column: 32, scope: !300)
!309 = !DILocation(line: 245, column: 44, scope: !300)
!310 = !DILocation(line: 245, column: 47, scope: !300)
!311 = !DILocation(line: 243, column: 5, scope: !300)
!312 = !{i64 402490}
!313 = !DILocation(line: 247, column: 1, scope: !300)
!314 = distinct !DISubprogram(name: "vatomicptr_write_rlx", scope: !250, file: !250, line: 325, type: !315, scopeLine: 326, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!315 = !DISubroutineType(types: !316)
!316 = !{null, !317, !5}
!317 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!318 = !DILocalVariable(name: "a", arg: 1, scope: !314, file: !250, line: 325, type: !317)
!319 = !DILocation(line: 325, column: 36, scope: !314)
!320 = !DILocalVariable(name: "v", arg: 2, scope: !314, file: !250, line: 325, type: !5)
!321 = !DILocation(line: 325, column: 45, scope: !314)
!322 = !DILocation(line: 329, column: 32, scope: !314)
!323 = !DILocation(line: 329, column: 44, scope: !314)
!324 = !DILocation(line: 329, column: 47, scope: !314)
!325 = !DILocation(line: 327, column: 5, scope: !314)
!326 = !{i64 405279}
!327 = !DILocation(line: 331, column: 1, scope: !314)
!328 = distinct !DISubprogram(name: "vatomicptr_xchg", scope: !329, file: !329, line: 198, type: !330, scopeLine: 199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!329 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!330 = !DISubroutineType(types: !331)
!331 = !{!5, !317, !5}
!332 = !DILocalVariable(name: "a", arg: 1, scope: !328, file: !329, line: 198, type: !317)
!333 = !DILocation(line: 198, column: 31, scope: !328)
!334 = !DILocalVariable(name: "v", arg: 2, scope: !328, file: !329, line: 198, type: !5)
!335 = !DILocation(line: 198, column: 40, scope: !328)
!336 = !DILocalVariable(name: "oldv", scope: !328, file: !329, line: 200, type: !5)
!337 = !DILocation(line: 200, column: 11, scope: !328)
!338 = !DILocalVariable(name: "tmp", scope: !328, file: !329, line: 201, type: !27)
!339 = !DILocation(line: 201, column: 15, scope: !328)
!340 = !DILocation(line: 209, column: 22, scope: !328)
!341 = !DILocation(line: 209, column: 34, scope: !328)
!342 = !DILocation(line: 209, column: 37, scope: !328)
!343 = !DILocation(line: 202, column: 5, scope: !328)
!344 = !{i64 459598, i64 459632, i64 459647, i64 459680, i64 459723}
!345 = !DILocation(line: 211, column: 12, scope: !328)
!346 = !DILocation(line: 211, column: 5, scope: !328)
!347 = distinct !DISubprogram(name: "vatomicptr_write_rel", scope: !250, file: !250, line: 311, type: !315, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!348 = !DILocalVariable(name: "a", arg: 1, scope: !347, file: !250, line: 311, type: !317)
!349 = !DILocation(line: 311, column: 36, scope: !347)
!350 = !DILocalVariable(name: "v", arg: 2, scope: !347, file: !250, line: 311, type: !5)
!351 = !DILocation(line: 311, column: 45, scope: !347)
!352 = !DILocation(line: 315, column: 32, scope: !347)
!353 = !DILocation(line: 315, column: 44, scope: !347)
!354 = !DILocation(line: 315, column: 47, scope: !347)
!355 = !DILocation(line: 313, column: 5, scope: !347)
!356 = !{i64 404808}
!357 = !DILocation(line: 317, column: 1, scope: !347)
!358 = distinct !DISubprogram(name: "vatomic32_await_eq_acq", scope: !250, file: !250, line: 604, type: !359, scopeLine: 605, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!359 = !DISubroutineType(types: !360)
!360 = !{!27, !253, !27}
!361 = !DILocalVariable(name: "a", arg: 1, scope: !358, file: !250, line: 604, type: !253)
!362 = !DILocation(line: 604, column: 43, scope: !358)
!363 = !DILocalVariable(name: "v", arg: 2, scope: !358, file: !250, line: 604, type: !27)
!364 = !DILocation(line: 604, column: 56, scope: !358)
!365 = !DILocalVariable(name: "val", scope: !358, file: !250, line: 606, type: !27)
!366 = !DILocation(line: 606, column: 15, scope: !358)
!367 = !DILocation(line: 613, column: 21, scope: !358)
!368 = !DILocation(line: 613, column: 33, scope: !358)
!369 = !DILocation(line: 613, column: 36, scope: !358)
!370 = !DILocation(line: 607, column: 5, scope: !358)
!371 = !{i64 412642, i64 412658, i64 412689, i64 412722}
!372 = !DILocation(line: 615, column: 12, scope: !358)
!373 = !DILocation(line: 615, column: 5, scope: !358)
!374 = distinct !DISubprogram(name: "mcslock_release", scope: !13, file: !13, line: 110, type: !266, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!375 = !DILocalVariable(name: "l", arg: 1, scope: !374, file: !13, line: 110, type: !268)
!376 = !DILocation(line: 110, column: 28, scope: !374)
!377 = !DILocalVariable(name: "node", arg: 2, scope: !374, file: !13, line: 110, type: !11)
!378 = !DILocation(line: 110, column: 43, scope: !374)
!379 = !DILocalVariable(name: "next", scope: !374, file: !13, line: 112, type: !11)
!380 = !DILocation(line: 112, column: 17, scope: !374)
!381 = !DILocation(line: 114, column: 30, scope: !382)
!382 = distinct !DILexicalBlock(scope: !374, file: !13, line: 114, column: 9)
!383 = !DILocation(line: 114, column: 36, scope: !382)
!384 = !DILocation(line: 114, column: 9, scope: !382)
!385 = !DILocation(line: 114, column: 42, scope: !382)
!386 = !DILocation(line: 114, column: 9, scope: !374)
!387 = !DILocation(line: 115, column: 54, scope: !388)
!388 = distinct !DILexicalBlock(scope: !382, file: !13, line: 114, column: 51)
!389 = !DILocation(line: 115, column: 57, scope: !388)
!390 = !DILocation(line: 115, column: 63, scope: !388)
!391 = !DILocation(line: 115, column: 30, scope: !388)
!392 = !DILocation(line: 115, column: 16, scope: !388)
!393 = !DILocation(line: 115, column: 14, scope: !388)
!394 = !DILocation(line: 116, column: 13, scope: !395)
!395 = distinct !DILexicalBlock(scope: !388, file: !13, line: 116, column: 13)
!396 = !DILocation(line: 116, column: 21, scope: !395)
!397 = !DILocation(line: 116, column: 18, scope: !395)
!398 = !DILocation(line: 116, column: 13, scope: !388)
!399 = !DILocation(line: 117, column: 13, scope: !400)
!400 = distinct !DILexicalBlock(scope: !395, file: !13, line: 116, column: 27)
!401 = !DILocation(line: 119, column: 35, scope: !388)
!402 = !DILocation(line: 119, column: 41, scope: !388)
!403 = !DILocation(line: 119, column: 9, scope: !388)
!404 = !DILocation(line: 120, column: 5, scope: !388)
!405 = !DILocation(line: 121, column: 47, scope: !374)
!406 = !DILocation(line: 121, column: 53, scope: !374)
!407 = !DILocation(line: 121, column: 26, scope: !374)
!408 = !DILocation(line: 121, column: 12, scope: !374)
!409 = !DILocation(line: 121, column: 10, scope: !374)
!410 = !DILocation(line: 122, column: 26, scope: !374)
!411 = !DILocation(line: 122, column: 32, scope: !374)
!412 = !DILocation(line: 122, column: 5, scope: !374)
!413 = !DILocation(line: 123, column: 1, scope: !374)
!414 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !250, file: !250, line: 197, type: !415, scopeLine: 198, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!415 = !DISubroutineType(types: !416)
!416 = !{!5, !417}
!417 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !418, size: 64)
!418 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!419 = !DILocalVariable(name: "a", arg: 1, scope: !414, file: !250, line: 197, type: !417)
!420 = !DILocation(line: 197, column: 41, scope: !414)
!421 = !DILocalVariable(name: "val", scope: !414, file: !250, line: 199, type: !5)
!422 = !DILocation(line: 199, column: 11, scope: !414)
!423 = !DILocation(line: 202, column: 32, scope: !414)
!424 = !DILocation(line: 202, column: 35, scope: !414)
!425 = !DILocation(line: 200, column: 5, scope: !414)
!426 = !{i64 401078}
!427 = !DILocation(line: 204, column: 12, scope: !414)
!428 = !DILocation(line: 204, column: 5, scope: !414)
!429 = distinct !DISubprogram(name: "vatomicptr_cmpxchg_rel", scope: !329, file: !329, line: 536, type: !430, scopeLine: 537, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!430 = !DISubroutineType(types: !431)
!431 = !{!5, !317, !5, !5}
!432 = !DILocalVariable(name: "a", arg: 1, scope: !429, file: !329, line: 536, type: !317)
!433 = !DILocation(line: 536, column: 38, scope: !429)
!434 = !DILocalVariable(name: "e", arg: 2, scope: !429, file: !329, line: 536, type: !5)
!435 = !DILocation(line: 536, column: 47, scope: !429)
!436 = !DILocalVariable(name: "v", arg: 3, scope: !429, file: !329, line: 536, type: !5)
!437 = !DILocation(line: 536, column: 56, scope: !429)
!438 = !DILocalVariable(name: "oldv", scope: !429, file: !329, line: 538, type: !5)
!439 = !DILocation(line: 538, column: 11, scope: !429)
!440 = !DILocalVariable(name: "tmp", scope: !429, file: !329, line: 539, type: !27)
!441 = !DILocation(line: 539, column: 15, scope: !429)
!442 = !DILocation(line: 550, column: 22, scope: !429)
!443 = !DILocation(line: 550, column: 36, scope: !429)
!444 = !DILocation(line: 550, column: 48, scope: !429)
!445 = !DILocation(line: 550, column: 51, scope: !429)
!446 = !DILocation(line: 540, column: 5, scope: !429)
!447 = !{i64 469936, i64 469970, i64 469985, i64 470017, i64 470051, i64 470071, i64 470114, i64 470143}
!448 = !DILocation(line: 552, column: 12, scope: !429)
!449 = !DILocation(line: 552, column: 5, scope: !429)
!450 = distinct !DISubprogram(name: "vatomicptr_await_neq_rlx", scope: !250, file: !250, line: 2144, type: !451, scopeLine: 2145, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!451 = !DISubroutineType(types: !452)
!452 = !{!5, !417, !5}
!453 = !DILocalVariable(name: "a", arg: 1, scope: !450, file: !250, line: 2144, type: !417)
!454 = !DILocation(line: 2144, column: 46, scope: !450)
!455 = !DILocalVariable(name: "v", arg: 2, scope: !450, file: !250, line: 2144, type: !5)
!456 = !DILocation(line: 2144, column: 55, scope: !450)
!457 = !DILocalVariable(name: "val", scope: !450, file: !250, line: 2146, type: !5)
!458 = !DILocation(line: 2146, column: 11, scope: !450)
!459 = !DILocation(line: 2153, column: 21, scope: !450)
!460 = !DILocation(line: 2153, column: 33, scope: !450)
!461 = !DILocation(line: 2153, column: 36, scope: !450)
!462 = !DILocation(line: 2147, column: 5, scope: !450)
!463 = !{i64 452721, i64 452737, i64 452767, i64 452800}
!464 = !DILocation(line: 2155, column: 12, scope: !450)
!465 = !DILocation(line: 2155, column: 5, scope: !450)
!466 = distinct !DISubprogram(name: "vatomicptr_read_acq", scope: !250, file: !250, line: 181, type: !415, scopeLine: 182, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!467 = !DILocalVariable(name: "a", arg: 1, scope: !466, file: !250, line: 181, type: !417)
!468 = !DILocation(line: 181, column: 41, scope: !466)
!469 = !DILocalVariable(name: "val", scope: !466, file: !250, line: 183, type: !5)
!470 = !DILocation(line: 183, column: 11, scope: !466)
!471 = !DILocation(line: 186, column: 32, scope: !466)
!472 = !DILocation(line: 186, column: 35, scope: !466)
!473 = !DILocation(line: 184, column: 5, scope: !466)
!474 = !{i64 400578}
!475 = !DILocation(line: 188, column: 12, scope: !466)
!476 = !DILocation(line: 188, column: 5, scope: !466)
!477 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !250, file: !250, line: 227, type: !301, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !67)
!478 = !DILocalVariable(name: "a", arg: 1, scope: !477, file: !250, line: 227, type: !303)
!479 = !DILocation(line: 227, column: 34, scope: !477)
!480 = !DILocalVariable(name: "v", arg: 2, scope: !477, file: !250, line: 227, type: !27)
!481 = !DILocation(line: 227, column: 47, scope: !477)
!482 = !DILocation(line: 231, column: 32, scope: !477)
!483 = !DILocation(line: 231, column: 44, scope: !477)
!484 = !DILocation(line: 231, column: 47, scope: !477)
!485 = !DILocation(line: 229, column: 5, scope: !477)
!486 = !{i64 402020}
!487 = !DILocation(line: 233, column: 1, scope: !477)
