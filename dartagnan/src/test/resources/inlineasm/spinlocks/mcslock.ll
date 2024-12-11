; ModuleID = '/home/stefano/huawei/libvsync/spinlock/test/mcslock.c'
source_filename = "/home/stefano/huawei/libvsync/spinlock/test/mcslock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.mcslock_s = type { %struct.vatomicptr_s }
%struct.vatomicptr_s = type { i8* }
%struct.mcs_node_s = type { %struct.vatomicptr_s, %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !46
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [68 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 1 + 0)\00", align 1
@lock = dso_local global %struct.mcslock_s zeroinitializer, align 8, !dbg !34
@nodes = dso_local global [3 x %struct.mcs_node_s] zeroinitializer, align 16, !dbg !41

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !57 {
  ret void, !dbg !61
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !62 {
  ret void, !dbg !63
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !64 {
  ret void, !dbg !65
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !66 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !67
  %2 = add i32 %1, 1, !dbg !67
  store i32 %2, i32* @g_cs_x, align 4, !dbg !67
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !68
  %4 = add i32 %3, 1, !dbg !68
  store i32 %4, i32* @g_cs_y, align 4, !dbg !68
  ret void, !dbg !69
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !70 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !71
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !71
  %3 = icmp eq i32 %1, %2, !dbg !71
  br i1 %3, label %4, label %5, !dbg !74

4:                                                ; preds = %0
  br label %6, !dbg !74

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 112, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !71
  unreachable, !dbg !71

6:                                                ; preds = %4
  %7 = load i32, i32* @g_cs_x, align 4, !dbg !75
  %8 = icmp eq i32 %7, 4, !dbg !75
  br i1 %8, label %9, label %10, !dbg !78

9:                                                ; preds = %6
  br label %11, !dbg !78

10:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 113, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !75
  unreachable, !dbg !75

11:                                               ; preds = %9
  ret void, !dbg !79
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !80 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i64]* %2, metadata !84, metadata !DIExpression()), !dbg !88
  call void @init(), !dbg !89
  call void @llvm.dbg.declare(metadata i64* %3, metadata !90, metadata !DIExpression()), !dbg !92
  store i64 0, i64* %3, align 8, !dbg !92
  br label %5, !dbg !93

5:                                                ; preds = %14, %0
  %6 = load i64, i64* %3, align 8, !dbg !94
  %7 = icmp ult i64 %6, 3, !dbg !96
  br i1 %7, label %8, label %17, !dbg !97

8:                                                ; preds = %5
  %9 = load i64, i64* %3, align 8, !dbg !98
  %10 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %9, !dbg !100
  %11 = load i64, i64* %3, align 8, !dbg !101
  %12 = inttoptr i64 %11 to i8*, !dbg !102
  %13 = call i32 @pthread_create(i64* noundef %10, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef %12) #6, !dbg !103
  br label %14, !dbg !104

14:                                               ; preds = %8
  %15 = load i64, i64* %3, align 8, !dbg !105
  %16 = add i64 %15, 1, !dbg !105
  store i64 %16, i64* %3, align 8, !dbg !105
  br label %5, !dbg !106, !llvm.loop !107

17:                                               ; preds = %5
  call void @post(), !dbg !110
  call void @llvm.dbg.declare(metadata i64* %4, metadata !111, metadata !DIExpression()), !dbg !113
  store i64 0, i64* %4, align 8, !dbg !113
  br label %18, !dbg !114

18:                                               ; preds = %26, %17
  %19 = load i64, i64* %4, align 8, !dbg !115
  %20 = icmp ult i64 %19, 3, !dbg !117
  br i1 %20, label %21, label %29, !dbg !118

21:                                               ; preds = %18
  %22 = load i64, i64* %4, align 8, !dbg !119
  %23 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %22, !dbg !121
  %24 = load i64, i64* %23, align 8, !dbg !121
  %25 = call i32 @pthread_join(i64 noundef %24, i8** noundef null), !dbg !122
  br label %26, !dbg !123

26:                                               ; preds = %21
  %27 = load i64, i64* %4, align 8, !dbg !124
  %28 = add i64 %27, 1, !dbg !124
  store i64 %28, i64* %4, align 8, !dbg !124
  br label %18, !dbg !125, !llvm.loop !126

29:                                               ; preds = %18
  call void @check(), !dbg !128
  call void @fini(), !dbg !129
  ret i32 0, !dbg !130
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !131 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !134, metadata !DIExpression()), !dbg !135
  call void @llvm.dbg.declare(metadata i32* %3, metadata !136, metadata !DIExpression()), !dbg !137
  %7 = load i8*, i8** %2, align 8, !dbg !138
  %8 = ptrtoint i8* %7 to i64, !dbg !139
  %9 = trunc i64 %8 to i32, !dbg !139
  store i32 %9, i32* %3, align 4, !dbg !137
  call void @llvm.dbg.declare(metadata i32* %4, metadata !140, metadata !DIExpression()), !dbg !142
  store i32 0, i32* %4, align 4, !dbg !142
  br label %10, !dbg !143

10:                                               ; preds = %65, %1
  %11 = load i32, i32* %4, align 4, !dbg !144
  %12 = icmp eq i32 %11, 0, !dbg !146
  br i1 %12, label %22, label %13, !dbg !147

13:                                               ; preds = %10
  %14 = load i32, i32* %4, align 4, !dbg !148
  %15 = icmp eq i32 %14, 1, !dbg !148
  br i1 %15, label %16, label %20, !dbg !148

16:                                               ; preds = %13
  %17 = load i32, i32* %3, align 4, !dbg !148
  %18 = add i32 %17, 1, !dbg !148
  %19 = icmp ult i32 %18, 2, !dbg !148
  br label %20

20:                                               ; preds = %16, %13
  %21 = phi i1 [ false, %13 ], [ %19, %16 ], !dbg !149
  br label %22, !dbg !147

22:                                               ; preds = %20, %10
  %23 = phi i1 [ true, %10 ], [ %21, %20 ]
  br i1 %23, label %24, label %68, !dbg !150

24:                                               ; preds = %22
  call void @llvm.dbg.declare(metadata i32* %5, metadata !151, metadata !DIExpression()), !dbg !154
  store i32 0, i32* %5, align 4, !dbg !154
  br label %25, !dbg !155

25:                                               ; preds = %41, %24
  %26 = load i32, i32* %5, align 4, !dbg !156
  %27 = icmp eq i32 %26, 0, !dbg !158
  br i1 %27, label %37, label %28, !dbg !159

28:                                               ; preds = %25
  %29 = load i32, i32* %5, align 4, !dbg !160
  %30 = icmp eq i32 %29, 1, !dbg !160
  br i1 %30, label %31, label %35, !dbg !160

31:                                               ; preds = %28
  %32 = load i32, i32* %3, align 4, !dbg !160
  %33 = add i32 %32, 1, !dbg !160
  %34 = icmp ult i32 %33, 1, !dbg !160
  br label %35

35:                                               ; preds = %31, %28
  %36 = phi i1 [ false, %28 ], [ %34, %31 ], !dbg !161
  br label %37, !dbg !159

37:                                               ; preds = %35, %25
  %38 = phi i1 [ true, %25 ], [ %36, %35 ]
  br i1 %38, label %39, label %44, !dbg !162

39:                                               ; preds = %37
  %40 = load i32, i32* %3, align 4, !dbg !163
  call void @acquire(i32 noundef %40), !dbg !165
  call void @cs(), !dbg !166
  br label %41, !dbg !167

41:                                               ; preds = %39
  %42 = load i32, i32* %5, align 4, !dbg !168
  %43 = add nsw i32 %42, 1, !dbg !168
  store i32 %43, i32* %5, align 4, !dbg !168
  br label %25, !dbg !169, !llvm.loop !170

44:                                               ; preds = %37
  call void @llvm.dbg.declare(metadata i32* %6, metadata !172, metadata !DIExpression()), !dbg !174
  store i32 0, i32* %6, align 4, !dbg !174
  br label %45, !dbg !175

45:                                               ; preds = %61, %44
  %46 = load i32, i32* %6, align 4, !dbg !176
  %47 = icmp eq i32 %46, 0, !dbg !178
  br i1 %47, label %57, label %48, !dbg !179

48:                                               ; preds = %45
  %49 = load i32, i32* %6, align 4, !dbg !180
  %50 = icmp eq i32 %49, 1, !dbg !180
  br i1 %50, label %51, label %55, !dbg !180

51:                                               ; preds = %48
  %52 = load i32, i32* %3, align 4, !dbg !180
  %53 = add i32 %52, 1, !dbg !180
  %54 = icmp ult i32 %53, 1, !dbg !180
  br label %55

55:                                               ; preds = %51, %48
  %56 = phi i1 [ false, %48 ], [ %54, %51 ], !dbg !181
  br label %57, !dbg !179

57:                                               ; preds = %55, %45
  %58 = phi i1 [ true, %45 ], [ %56, %55 ]
  br i1 %58, label %59, label %64, !dbg !182

59:                                               ; preds = %57
  %60 = load i32, i32* %3, align 4, !dbg !183
  call void @release(i32 noundef %60), !dbg !185
  br label %61, !dbg !186

61:                                               ; preds = %59
  %62 = load i32, i32* %6, align 4, !dbg !187
  %63 = add nsw i32 %62, 1, !dbg !187
  store i32 %63, i32* %6, align 4, !dbg !187
  br label %45, !dbg !188, !llvm.loop !189

64:                                               ; preds = %57
  br label %65, !dbg !191

65:                                               ; preds = %64
  %66 = load i32, i32* %4, align 4, !dbg !192
  %67 = add nsw i32 %66, 1, !dbg !192
  store i32 %67, i32* %4, align 4, !dbg !192
  br label %10, !dbg !193, !llvm.loop !194

68:                                               ; preds = %22
  ret i8* null, !dbg !196
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !197 {
  %2 = alloca i32, align 4
  %3 = alloca i8, align 1
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !200, metadata !DIExpression()), !dbg !201
  %4 = load i32, i32* %2, align 4, !dbg !202
  %5 = icmp eq i32 %4, 2, !dbg !204
  br i1 %5, label %6, label %14, !dbg !205

6:                                                ; preds = %1
  call void @llvm.dbg.declare(metadata i8* %3, metadata !206, metadata !DIExpression()), !dbg !210
  %7 = load i32, i32* %2, align 4, !dbg !211
  %8 = zext i32 %7 to i64, !dbg !212
  %9 = getelementptr inbounds [3 x %struct.mcs_node_s], [3 x %struct.mcs_node_s]* @nodes, i64 0, i64 %8, !dbg !212
  %10 = call zeroext i1 @mcslock_tryacquire(%struct.mcslock_s* noundef @lock, %struct.mcs_node_s* noundef %9), !dbg !213
  %11 = zext i1 %10 to i8, !dbg !210
  store i8 %11, i8* %3, align 1, !dbg !210
  %12 = load i8, i8* %3, align 1, !dbg !214
  %13 = trunc i8 %12 to i1, !dbg !214
  call void @verification_assume(i1 noundef zeroext %13), !dbg !215
  br label %18, !dbg !216

14:                                               ; preds = %1
  %15 = load i32, i32* %2, align 4, !dbg !217
  %16 = zext i32 %15 to i64, !dbg !219
  %17 = getelementptr inbounds [3 x %struct.mcs_node_s], [3 x %struct.mcs_node_s]* @nodes, i64 0, i64 %16, !dbg !219
  call void @mcslock_acquire(%struct.mcslock_s* noundef @lock, %struct.mcs_node_s* noundef %17), !dbg !220
  br label %18

18:                                               ; preds = %14, %6
  ret void, !dbg !221
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @mcslock_tryacquire(%struct.mcslock_s* noundef %0, %struct.mcs_node_s* noundef %1) #0 !dbg !222 {
  %3 = alloca %struct.mcslock_s*, align 8
  %4 = alloca %struct.mcs_node_s*, align 8
  %5 = alloca %struct.mcs_node_s*, align 8
  store %struct.mcslock_s* %0, %struct.mcslock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.mcslock_s** %3, metadata !226, metadata !DIExpression()), !dbg !227
  store %struct.mcs_node_s* %1, %struct.mcs_node_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.mcs_node_s** %4, metadata !228, metadata !DIExpression()), !dbg !229
  call void @llvm.dbg.declare(metadata %struct.mcs_node_s** %5, metadata !230, metadata !DIExpression()), !dbg !231
  %6 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !232
  %7 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %6, i32 0, i32 0, !dbg !233
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %7, i8* noundef null), !dbg !234
  %8 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !235
  %9 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %8, i32 0, i32 1, !dbg !236
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %9, i32 noundef 1), !dbg !237
  %10 = load %struct.mcslock_s*, %struct.mcslock_s** %3, align 8, !dbg !238
  %11 = getelementptr inbounds %struct.mcslock_s, %struct.mcslock_s* %10, i32 0, i32 0, !dbg !239
  %12 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !240
  %13 = bitcast %struct.mcs_node_s* %12 to i8*, !dbg !240
  %14 = call i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %11, i8* noundef null, i8* noundef %13), !dbg !241
  %15 = bitcast i8* %14 to %struct.mcs_node_s*, !dbg !242
  store %struct.mcs_node_s* %15, %struct.mcs_node_s** %5, align 8, !dbg !243
  %16 = load %struct.mcs_node_s*, %struct.mcs_node_s** %5, align 8, !dbg !244
  %17 = icmp eq %struct.mcs_node_s* %16, null, !dbg !245
  ret i1 %17, !dbg !246
}

; Function Attrs: noinline nounwind uwtable
define internal void @verification_assume(i1 noundef zeroext %0) #0 !dbg !247 {
  %2 = alloca i8, align 1
  %3 = zext i1 %0 to i8
  store i8 %3, i8* %2, align 1
  call void @llvm.dbg.declare(metadata i8* %2, metadata !251, metadata !DIExpression()), !dbg !252
  %4 = load i8, i8* %2, align 1, !dbg !253
  %5 = trunc i8 %4 to i1, !dbg !253
  %6 = zext i1 %5 to i32, !dbg !253
  %7 = call i32 (i32, ...) bitcast (i32 (...)* @__VERIFIER_assume to i32 (i32, ...)*)(i32 noundef %6), !dbg !254
  ret void, !dbg !255
}

; Function Attrs: noinline nounwind uwtable
define internal void @mcslock_acquire(%struct.mcslock_s* noundef %0, %struct.mcs_node_s* noundef %1) #0 !dbg !256 {
  %3 = alloca %struct.mcslock_s*, align 8
  %4 = alloca %struct.mcs_node_s*, align 8
  %5 = alloca %struct.mcs_node_s*, align 8
  store %struct.mcslock_s* %0, %struct.mcslock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.mcslock_s** %3, metadata !259, metadata !DIExpression()), !dbg !260
  store %struct.mcs_node_s* %1, %struct.mcs_node_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.mcs_node_s** %4, metadata !261, metadata !DIExpression()), !dbg !262
  call void @llvm.dbg.declare(metadata %struct.mcs_node_s** %5, metadata !263, metadata !DIExpression()), !dbg !264
  %6 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !265
  %7 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %6, i32 0, i32 0, !dbg !266
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %7, i8* noundef null), !dbg !267
  %8 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !268
  %9 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %8, i32 0, i32 1, !dbg !269
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %9, i32 noundef 1), !dbg !270
  %10 = load %struct.mcslock_s*, %struct.mcslock_s** %3, align 8, !dbg !271
  %11 = getelementptr inbounds %struct.mcslock_s, %struct.mcslock_s* %10, i32 0, i32 0, !dbg !272
  %12 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !273
  %13 = bitcast %struct.mcs_node_s* %12 to i8*, !dbg !273
  %14 = call i8* @vatomicptr_xchg(%struct.vatomicptr_s* noundef %11, i8* noundef %13), !dbg !274
  %15 = bitcast i8* %14 to %struct.mcs_node_s*, !dbg !275
  store %struct.mcs_node_s* %15, %struct.mcs_node_s** %5, align 8, !dbg !276
  %16 = load %struct.mcs_node_s*, %struct.mcs_node_s** %5, align 8, !dbg !277
  %17 = icmp ne %struct.mcs_node_s* %16, null, !dbg !277
  br i1 %17, label %18, label %26, !dbg !279

18:                                               ; preds = %2
  %19 = load %struct.mcs_node_s*, %struct.mcs_node_s** %5, align 8, !dbg !280
  %20 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %19, i32 0, i32 0, !dbg !282
  %21 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !283
  %22 = bitcast %struct.mcs_node_s* %21 to i8*, !dbg !283
  call void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %20, i8* noundef %22), !dbg !284
  %23 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !285
  %24 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %23, i32 0, i32 1, !dbg !286
  %25 = call i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %24, i32 noundef 0), !dbg !287
  br label %26, !dbg !288

26:                                               ; preds = %18, %2
  ret void, !dbg !289
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !290 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !291, metadata !DIExpression()), !dbg !292
  %3 = load i32, i32* %2, align 4, !dbg !293
  %4 = zext i32 %3 to i64, !dbg !294
  %5 = getelementptr inbounds [3 x %struct.mcs_node_s], [3 x %struct.mcs_node_s]* @nodes, i64 0, i64 %4, !dbg !294
  call void @mcslock_release(%struct.mcslock_s* noundef @lock, %struct.mcs_node_s* noundef %5), !dbg !295
  ret void, !dbg !296
}

; Function Attrs: noinline nounwind uwtable
define internal void @mcslock_release(%struct.mcslock_s* noundef %0, %struct.mcs_node_s* noundef %1) #0 !dbg !297 {
  %3 = alloca %struct.mcslock_s*, align 8
  %4 = alloca %struct.mcs_node_s*, align 8
  %5 = alloca %struct.mcs_node_s*, align 8
  store %struct.mcslock_s* %0, %struct.mcslock_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.mcslock_s** %3, metadata !298, metadata !DIExpression()), !dbg !299
  store %struct.mcs_node_s* %1, %struct.mcs_node_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.mcs_node_s** %4, metadata !300, metadata !DIExpression()), !dbg !301
  call void @llvm.dbg.declare(metadata %struct.mcs_node_s** %5, metadata !302, metadata !DIExpression()), !dbg !303
  %6 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !304
  %7 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %6, i32 0, i32 0, !dbg !306
  %8 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %7), !dbg !307
  %9 = icmp eq i8* %8, null, !dbg !308
  br i1 %9, label %10, label %25, !dbg !309

10:                                               ; preds = %2
  %11 = load %struct.mcslock_s*, %struct.mcslock_s** %3, align 8, !dbg !310
  %12 = getelementptr inbounds %struct.mcslock_s, %struct.mcslock_s* %11, i32 0, i32 0, !dbg !312
  %13 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !313
  %14 = bitcast %struct.mcs_node_s* %13 to i8*, !dbg !313
  %15 = call i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %12, i8* noundef %14, i8* noundef null), !dbg !314
  %16 = bitcast i8* %15 to %struct.mcs_node_s*, !dbg !315
  store %struct.mcs_node_s* %16, %struct.mcs_node_s** %5, align 8, !dbg !316
  %17 = load %struct.mcs_node_s*, %struct.mcs_node_s** %5, align 8, !dbg !317
  %18 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !319
  %19 = icmp eq %struct.mcs_node_s* %17, %18, !dbg !320
  br i1 %19, label %20, label %21, !dbg !321

20:                                               ; preds = %10
  br label %32, !dbg !322

21:                                               ; preds = %10
  %22 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !324
  %23 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %22, i32 0, i32 0, !dbg !325
  %24 = call i8* @vatomicptr_await_neq_rlx(%struct.vatomicptr_s* noundef %23, i8* noundef null), !dbg !326
  br label %25, !dbg !327

25:                                               ; preds = %21, %2
  %26 = load %struct.mcs_node_s*, %struct.mcs_node_s** %4, align 8, !dbg !328
  %27 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %26, i32 0, i32 0, !dbg !329
  %28 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %27), !dbg !330
  %29 = bitcast i8* %28 to %struct.mcs_node_s*, !dbg !331
  store %struct.mcs_node_s* %29, %struct.mcs_node_s** %5, align 8, !dbg !332
  %30 = load %struct.mcs_node_s*, %struct.mcs_node_s** %5, align 8, !dbg !333
  %31 = getelementptr inbounds %struct.mcs_node_s, %struct.mcs_node_s* %30, i32 0, i32 1, !dbg !334
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %31, i32 noundef 0), !dbg !335
  br label %32, !dbg !336

32:                                               ; preds = %25, %20
  ret void, !dbg !336
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !337 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !342, metadata !DIExpression()), !dbg !343
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !344, metadata !DIExpression()), !dbg !345
  %5 = load i8*, i8** %4, align 8, !dbg !346
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !347
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !348
  %8 = load i8*, i8** %7, align 8, !dbg !348
  call void asm sideeffect "str ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !349, !srcloc !350
  ret void, !dbg !351
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !352 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !356, metadata !DIExpression()), !dbg !357
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !358, metadata !DIExpression()), !dbg !359
  %5 = load i32, i32* %4, align 4, !dbg !360
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !361
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !362
  %8 = load i32, i32* %7, align 4, !dbg !362
  call void asm sideeffect "str ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !363, !srcloc !364
  ret void, !dbg !365
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_cmpxchg(%struct.vatomicptr_s* noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !366 {
  %4 = alloca %struct.vatomicptr_s*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i32, align 4
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %4, metadata !370, metadata !DIExpression()), !dbg !371
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !372, metadata !DIExpression()), !dbg !373
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !374, metadata !DIExpression()), !dbg !375
  call void @llvm.dbg.declare(metadata i8** %7, metadata !376, metadata !DIExpression()), !dbg !377
  call void @llvm.dbg.declare(metadata i32* %8, metadata !378, metadata !DIExpression()), !dbg !379
  %9 = load i8*, i8** %6, align 8, !dbg !380
  %10 = load i8*, i8** %5, align 8, !dbg !381
  %11 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %4, align 8, !dbg !382
  %12 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %11, i32 0, i32 0, !dbg !383
  %13 = load i8*, i8** %12, align 8, !dbg !383
  %14 = call { i8*, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldaxr ${0:x}, $4\0Acmp ${0:x}, ${3:x}\0Ab.ne 2f\0Astlxr  ${1:w}, ${2:x}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i8* %9, i8* %10, i8* %13) #6, !dbg !384, !srcloc !385
  %15 = extractvalue { i8*, i32 } %14, 0, !dbg !384
  %16 = extractvalue { i8*, i32 } %14, 1, !dbg !384
  store i8* %15, i8** %7, align 8, !dbg !384
  store i32 %16, i32* %8, align 4, !dbg !384
  %17 = load i8*, i8** %7, align 8, !dbg !386
  ret i8* %17, !dbg !387
}

declare i32 @__VERIFIER_assume(...) #4

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_xchg(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !388 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !391, metadata !DIExpression()), !dbg !392
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !393, metadata !DIExpression()), !dbg !394
  call void @llvm.dbg.declare(metadata i8** %5, metadata !395, metadata !DIExpression()), !dbg !396
  call void @llvm.dbg.declare(metadata i32* %6, metadata !397, metadata !DIExpression()), !dbg !398
  %7 = load i8*, i8** %4, align 8, !dbg !399
  %8 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !400
  %9 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %8, i32 0, i32 0, !dbg !401
  %10 = load i8*, i8** %9, align 8, !dbg !401
  %11 = call { i8*, i32 } asm sideeffect "prfm pstl1strm, $3\0A1:\0Aldaxr ${0:x}, $3\0Astlxr  ${1:w}, ${2:x}, $3\0Acbnz ${1:w}, 1b\0A", "=&r,=&r,r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %7, i8* %10) #6, !dbg !402, !srcloc !403
  %12 = extractvalue { i8*, i32 } %11, 0, !dbg !402
  %13 = extractvalue { i8*, i32 } %11, 1, !dbg !402
  store i8* %12, i8** %5, align 8, !dbg !402
  store i32 %13, i32* %6, align 4, !dbg !402
  %14 = load i8*, i8** %5, align 8, !dbg !404
  ret i8* %14, !dbg !405
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !406 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !407, metadata !DIExpression()), !dbg !408
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !409, metadata !DIExpression()), !dbg !410
  %5 = load i8*, i8** %4, align 8, !dbg !411
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !412
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !413
  %8 = load i8*, i8** %7, align 8, !dbg !413
  call void asm sideeffect "stlr ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !414, !srcloc !415
  ret void, !dbg !416
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !417 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !422, metadata !DIExpression()), !dbg !423
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !424, metadata !DIExpression()), !dbg !425
  call void @llvm.dbg.declare(metadata i32* %5, metadata !426, metadata !DIExpression()), !dbg !427
  %6 = load i32, i32* %4, align 4, !dbg !428
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !429
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !430
  %9 = load i32, i32* %8, align 4, !dbg !430
  %10 = call i32 asm sideeffect "1:\0Aldar ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.ne 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !431, !srcloc !432
  store i32 %10, i32* %5, align 4, !dbg !431
  %11 = load i32, i32* %5, align 4, !dbg !433
  ret i32 %11, !dbg !434
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !435 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !440, metadata !DIExpression()), !dbg !441
  call void @llvm.dbg.declare(metadata i8** %3, metadata !442, metadata !DIExpression()), !dbg !443
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !444
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !445
  %6 = load i8*, i8** %5, align 8, !dbg !445
  %7 = call i8* asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !446, !srcloc !447
  store i8* %7, i8** %3, align 8, !dbg !446
  %8 = load i8*, i8** %3, align 8, !dbg !448
  ret i8* %8, !dbg !449
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !450 {
  %4 = alloca %struct.vatomicptr_s*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i32, align 4
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %4, metadata !451, metadata !DIExpression()), !dbg !452
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !453, metadata !DIExpression()), !dbg !454
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !455, metadata !DIExpression()), !dbg !456
  call void @llvm.dbg.declare(metadata i8** %7, metadata !457, metadata !DIExpression()), !dbg !458
  call void @llvm.dbg.declare(metadata i32* %8, metadata !459, metadata !DIExpression()), !dbg !460
  %9 = load i8*, i8** %6, align 8, !dbg !461
  %10 = load i8*, i8** %5, align 8, !dbg !462
  %11 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %4, align 8, !dbg !463
  %12 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %11, i32 0, i32 0, !dbg !464
  %13 = load i8*, i8** %12, align 8, !dbg !464
  %14 = call { i8*, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:x}, $4\0Acmp ${0:x}, ${3:x}\0Ab.ne 2f\0Astlxr  ${1:w}, ${2:x}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i8* %9, i8* %10, i8* %13) #6, !dbg !465, !srcloc !466
  %15 = extractvalue { i8*, i32 } %14, 0, !dbg !465
  %16 = extractvalue { i8*, i32 } %14, 1, !dbg !465
  store i8* %15, i8** %7, align 8, !dbg !465
  store i32 %16, i32* %8, align 4, !dbg !465
  %17 = load i8*, i8** %7, align 8, !dbg !467
  ret i8* %17, !dbg !468
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_await_neq_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !469 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !472, metadata !DIExpression()), !dbg !473
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !474, metadata !DIExpression()), !dbg !475
  call void @llvm.dbg.declare(metadata i8** %5, metadata !476, metadata !DIExpression()), !dbg !477
  %6 = load i8*, i8** %4, align 8, !dbg !478
  %7 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !479
  %8 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %7, i32 0, i32 0, !dbg !480
  %9 = load i8*, i8** %8, align 8, !dbg !480
  %10 = call i8* asm sideeffect "1:\0Aldr ${0:x}, $2\0Acmp ${0:x}, ${1:x}\0Ab.eq 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i8* %6, i8* %9) #6, !dbg !481, !srcloc !482
  store i8* %10, i8** %5, align 8, !dbg !481
  %11 = load i8*, i8** %5, align 8, !dbg !483
  ret i8* %11, !dbg !484
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %0) #0 !dbg !485 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !486, metadata !DIExpression()), !dbg !487
  call void @llvm.dbg.declare(metadata i8** %3, metadata !488, metadata !DIExpression()), !dbg !489
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !490
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !491
  %6 = load i8*, i8** %5, align 8, !dbg !491
  %7 = call i8* asm sideeffect "ldar ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !492, !srcloc !493
  store i8* %7, i8** %3, align 8, !dbg !492
  %8 = load i8*, i8** %3, align 8, !dbg !494
  ret i8* %8, !dbg !495
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !496 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !497, metadata !DIExpression()), !dbg !498
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !499, metadata !DIExpression()), !dbg !500
  %5 = load i32, i32* %4, align 4, !dbg !501
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !502
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !503
  %8 = load i32, i32* %7, align 4, !dbg !503
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !504, !srcloc !505
  ret void, !dbg !506
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!49, !50, !51, !52, !53, !54, !55}
!llvm.ident = !{!56}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !48, line: 100, type: !27, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !33, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/spinlock/test/mcslock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "9d67ed8011bfc751ed2928dccc5d4cca")
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
!33 = !{!34, !41, !0, !46}
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !36, line: 6, type: !37, isLocal: false, isDefinition: true)
!36 = !DIFile(filename: "spinlock/test/mcslock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "9d67ed8011bfc751ed2928dccc5d4cca")
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "mcslock_t", file: !13, line: 40, baseType: !38)
!38 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "mcslock_s", file: !13, line: 38, size: 64, elements: !39)
!39 = !{!40}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !38, file: !13, line: 39, baseType: !17, size: 64, align: 64)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(name: "nodes", scope: !2, file: !36, line: 7, type: !43, isLocal: false, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 384, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 3)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !48, line: 101, type: !27, isLocal: true, isDefinition: true)
!48 = !DIFile(filename: "utils/include/test/boilerplate/lock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4187ade4a536ecfd1f9ed3ab727ca965")
!49 = !{i32 7, !"Dwarf Version", i32 5}
!50 = !{i32 2, !"Debug Info Version", i32 3}
!51 = !{i32 1, !"wchar_size", i32 4}
!52 = !{i32 7, !"PIC Level", i32 2}
!53 = !{i32 7, !"PIE Level", i32 2}
!54 = !{i32 7, !"uwtable", i32 1}
!55 = !{i32 7, !"frame-pointer", i32 2}
!56 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!57 = distinct !DISubprogram(name: "init", scope: !48, file: !48, line: 68, type: !58, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!58 = !DISubroutineType(types: !59)
!59 = !{null}
!60 = !{}
!61 = !DILocation(line: 70, column: 1, scope: !57)
!62 = distinct !DISubprogram(name: "post", scope: !48, file: !48, line: 77, type: !58, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!63 = !DILocation(line: 79, column: 1, scope: !62)
!64 = distinct !DISubprogram(name: "fini", scope: !48, file: !48, line: 86, type: !58, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!65 = !DILocation(line: 88, column: 1, scope: !64)
!66 = distinct !DISubprogram(name: "cs", scope: !48, file: !48, line: 104, type: !58, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!67 = !DILocation(line: 106, column: 11, scope: !66)
!68 = !DILocation(line: 107, column: 11, scope: !66)
!69 = !DILocation(line: 108, column: 1, scope: !66)
!70 = distinct !DISubprogram(name: "check", scope: !48, file: !48, line: 110, type: !58, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!71 = !DILocation(line: 112, column: 5, scope: !72)
!72 = distinct !DILexicalBlock(scope: !73, file: !48, line: 112, column: 5)
!73 = distinct !DILexicalBlock(scope: !70, file: !48, line: 112, column: 5)
!74 = !DILocation(line: 112, column: 5, scope: !73)
!75 = !DILocation(line: 113, column: 5, scope: !76)
!76 = distinct !DILexicalBlock(scope: !77, file: !48, line: 113, column: 5)
!77 = distinct !DILexicalBlock(scope: !70, file: !48, line: 113, column: 5)
!78 = !DILocation(line: 113, column: 5, scope: !77)
!79 = !DILocation(line: 114, column: 1, scope: !70)
!80 = distinct !DISubprogram(name: "main", scope: !48, file: !48, line: 141, type: !81, scopeLine: 142, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!81 = !DISubroutineType(types: !82)
!82 = !{!83}
!83 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!84 = !DILocalVariable(name: "t", scope: !80, file: !48, line: 143, type: !85)
!85 = !DICompositeType(tag: DW_TAG_array_type, baseType: !86, size: 192, elements: !44)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !87, line: 27, baseType: !10)
!87 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!88 = !DILocation(line: 143, column: 15, scope: !80)
!89 = !DILocation(line: 150, column: 5, scope: !80)
!90 = !DILocalVariable(name: "i", scope: !91, file: !48, line: 152, type: !6)
!91 = distinct !DILexicalBlock(scope: !80, file: !48, line: 152, column: 5)
!92 = !DILocation(line: 152, column: 21, scope: !91)
!93 = !DILocation(line: 152, column: 10, scope: !91)
!94 = !DILocation(line: 152, column: 28, scope: !95)
!95 = distinct !DILexicalBlock(scope: !91, file: !48, line: 152, column: 5)
!96 = !DILocation(line: 152, column: 30, scope: !95)
!97 = !DILocation(line: 152, column: 5, scope: !91)
!98 = !DILocation(line: 153, column: 33, scope: !99)
!99 = distinct !DILexicalBlock(scope: !95, file: !48, line: 152, column: 47)
!100 = !DILocation(line: 153, column: 31, scope: !99)
!101 = !DILocation(line: 153, column: 53, scope: !99)
!102 = !DILocation(line: 153, column: 45, scope: !99)
!103 = !DILocation(line: 153, column: 15, scope: !99)
!104 = !DILocation(line: 154, column: 5, scope: !99)
!105 = !DILocation(line: 152, column: 43, scope: !95)
!106 = !DILocation(line: 152, column: 5, scope: !95)
!107 = distinct !{!107, !97, !108, !109}
!108 = !DILocation(line: 154, column: 5, scope: !91)
!109 = !{!"llvm.loop.mustprogress"}
!110 = !DILocation(line: 156, column: 5, scope: !80)
!111 = !DILocalVariable(name: "i", scope: !112, file: !48, line: 158, type: !6)
!112 = distinct !DILexicalBlock(scope: !80, file: !48, line: 158, column: 5)
!113 = !DILocation(line: 158, column: 21, scope: !112)
!114 = !DILocation(line: 158, column: 10, scope: !112)
!115 = !DILocation(line: 158, column: 28, scope: !116)
!116 = distinct !DILexicalBlock(scope: !112, file: !48, line: 158, column: 5)
!117 = !DILocation(line: 158, column: 30, scope: !116)
!118 = !DILocation(line: 158, column: 5, scope: !112)
!119 = !DILocation(line: 159, column: 30, scope: !120)
!120 = distinct !DILexicalBlock(scope: !116, file: !48, line: 158, column: 47)
!121 = !DILocation(line: 159, column: 28, scope: !120)
!122 = !DILocation(line: 159, column: 15, scope: !120)
!123 = !DILocation(line: 160, column: 5, scope: !120)
!124 = !DILocation(line: 158, column: 43, scope: !116)
!125 = !DILocation(line: 158, column: 5, scope: !116)
!126 = distinct !{!126, !118, !127, !109}
!127 = !DILocation(line: 160, column: 5, scope: !112)
!128 = !DILocation(line: 167, column: 5, scope: !80)
!129 = !DILocation(line: 168, column: 5, scope: !80)
!130 = !DILocation(line: 170, column: 5, scope: !80)
!131 = distinct !DISubprogram(name: "run", scope: !48, file: !48, line: 119, type: !132, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!132 = !DISubroutineType(types: !133)
!133 = !{!5, !5}
!134 = !DILocalVariable(name: "arg", arg: 1, scope: !131, file: !48, line: 119, type: !5)
!135 = !DILocation(line: 119, column: 11, scope: !131)
!136 = !DILocalVariable(name: "tid", scope: !131, file: !48, line: 121, type: !27)
!137 = !DILocation(line: 121, column: 15, scope: !131)
!138 = !DILocation(line: 121, column: 33, scope: !131)
!139 = !DILocation(line: 121, column: 21, scope: !131)
!140 = !DILocalVariable(name: "i", scope: !141, file: !48, line: 125, type: !83)
!141 = distinct !DILexicalBlock(scope: !131, file: !48, line: 125, column: 5)
!142 = !DILocation(line: 125, column: 14, scope: !141)
!143 = !DILocation(line: 125, column: 10, scope: !141)
!144 = !DILocation(line: 125, column: 21, scope: !145)
!145 = distinct !DILexicalBlock(scope: !141, file: !48, line: 125, column: 5)
!146 = !DILocation(line: 125, column: 23, scope: !145)
!147 = !DILocation(line: 125, column: 28, scope: !145)
!148 = !DILocation(line: 125, column: 31, scope: !145)
!149 = !DILocation(line: 0, scope: !145)
!150 = !DILocation(line: 125, column: 5, scope: !141)
!151 = !DILocalVariable(name: "j", scope: !152, file: !48, line: 129, type: !83)
!152 = distinct !DILexicalBlock(scope: !153, file: !48, line: 129, column: 9)
!153 = distinct !DILexicalBlock(scope: !145, file: !48, line: 125, column: 63)
!154 = !DILocation(line: 129, column: 18, scope: !152)
!155 = !DILocation(line: 129, column: 14, scope: !152)
!156 = !DILocation(line: 129, column: 25, scope: !157)
!157 = distinct !DILexicalBlock(scope: !152, file: !48, line: 129, column: 9)
!158 = !DILocation(line: 129, column: 27, scope: !157)
!159 = !DILocation(line: 129, column: 32, scope: !157)
!160 = !DILocation(line: 129, column: 35, scope: !157)
!161 = !DILocation(line: 0, scope: !157)
!162 = !DILocation(line: 129, column: 9, scope: !152)
!163 = !DILocation(line: 130, column: 21, scope: !164)
!164 = distinct !DILexicalBlock(scope: !157, file: !48, line: 129, column: 67)
!165 = !DILocation(line: 130, column: 13, scope: !164)
!166 = !DILocation(line: 131, column: 13, scope: !164)
!167 = !DILocation(line: 132, column: 9, scope: !164)
!168 = !DILocation(line: 129, column: 63, scope: !157)
!169 = !DILocation(line: 129, column: 9, scope: !157)
!170 = distinct !{!170, !162, !171, !109}
!171 = !DILocation(line: 132, column: 9, scope: !152)
!172 = !DILocalVariable(name: "j", scope: !173, file: !48, line: 133, type: !83)
!173 = distinct !DILexicalBlock(scope: !153, file: !48, line: 133, column: 9)
!174 = !DILocation(line: 133, column: 18, scope: !173)
!175 = !DILocation(line: 133, column: 14, scope: !173)
!176 = !DILocation(line: 133, column: 25, scope: !177)
!177 = distinct !DILexicalBlock(scope: !173, file: !48, line: 133, column: 9)
!178 = !DILocation(line: 133, column: 27, scope: !177)
!179 = !DILocation(line: 133, column: 32, scope: !177)
!180 = !DILocation(line: 133, column: 35, scope: !177)
!181 = !DILocation(line: 0, scope: !177)
!182 = !DILocation(line: 133, column: 9, scope: !173)
!183 = !DILocation(line: 134, column: 21, scope: !184)
!184 = distinct !DILexicalBlock(scope: !177, file: !48, line: 133, column: 67)
!185 = !DILocation(line: 134, column: 13, scope: !184)
!186 = !DILocation(line: 135, column: 9, scope: !184)
!187 = !DILocation(line: 133, column: 63, scope: !177)
!188 = !DILocation(line: 133, column: 9, scope: !177)
!189 = distinct !{!189, !182, !190, !109}
!190 = !DILocation(line: 135, column: 9, scope: !173)
!191 = !DILocation(line: 136, column: 5, scope: !153)
!192 = !DILocation(line: 125, column: 59, scope: !145)
!193 = !DILocation(line: 125, column: 5, scope: !145)
!194 = distinct !{!194, !150, !195, !109}
!195 = !DILocation(line: 136, column: 5, scope: !141)
!196 = !DILocation(line: 137, column: 5, scope: !131)
!197 = distinct !DISubprogram(name: "acquire", scope: !36, file: !36, line: 10, type: !198, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!198 = !DISubroutineType(types: !199)
!199 = !{null, !27}
!200 = !DILocalVariable(name: "tid", arg: 1, scope: !197, file: !36, line: 10, type: !27)
!201 = !DILocation(line: 10, column: 19, scope: !197)
!202 = !DILocation(line: 12, column: 9, scope: !203)
!203 = distinct !DILexicalBlock(scope: !197, file: !36, line: 12, column: 9)
!204 = !DILocation(line: 12, column: 13, scope: !203)
!205 = !DILocation(line: 12, column: 9, scope: !197)
!206 = !DILocalVariable(name: "acquired", scope: !207, file: !36, line: 14, type: !208)
!207 = distinct !DILexicalBlock(scope: !203, file: !36, line: 12, column: 30)
!208 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !7, line: 44, baseType: !209)
!209 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!210 = !DILocation(line: 14, column: 17, scope: !207)
!211 = !DILocation(line: 14, column: 61, scope: !207)
!212 = !DILocation(line: 14, column: 55, scope: !207)
!213 = !DILocation(line: 14, column: 28, scope: !207)
!214 = !DILocation(line: 15, column: 29, scope: !207)
!215 = !DILocation(line: 15, column: 9, scope: !207)
!216 = !DILocation(line: 19, column: 5, scope: !207)
!217 = !DILocation(line: 20, column: 39, scope: !218)
!218 = distinct !DILexicalBlock(scope: !203, file: !36, line: 19, column: 12)
!219 = !DILocation(line: 20, column: 33, scope: !218)
!220 = !DILocation(line: 20, column: 9, scope: !218)
!221 = !DILocation(line: 22, column: 1, scope: !197)
!222 = distinct !DISubprogram(name: "mcslock_tryacquire", scope: !13, file: !13, line: 70, type: !223, scopeLine: 71, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!223 = !DISubroutineType(types: !224)
!224 = !{!208, !225, !11}
!225 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!226 = !DILocalVariable(name: "l", arg: 1, scope: !222, file: !13, line: 70, type: !225)
!227 = !DILocation(line: 70, column: 31, scope: !222)
!228 = !DILocalVariable(name: "node", arg: 2, scope: !222, file: !13, line: 70, type: !11)
!229 = !DILocation(line: 70, column: 46, scope: !222)
!230 = !DILocalVariable(name: "pred", scope: !222, file: !13, line: 72, type: !11)
!231 = !DILocation(line: 72, column: 17, scope: !222)
!232 = !DILocation(line: 74, column: 27, scope: !222)
!233 = !DILocation(line: 74, column: 33, scope: !222)
!234 = !DILocation(line: 74, column: 5, scope: !222)
!235 = !DILocation(line: 75, column: 26, scope: !222)
!236 = !DILocation(line: 75, column: 32, scope: !222)
!237 = !DILocation(line: 75, column: 5, scope: !222)
!238 = !DILocation(line: 77, column: 46, scope: !222)
!239 = !DILocation(line: 77, column: 49, scope: !222)
!240 = !DILocation(line: 77, column: 61, scope: !222)
!241 = !DILocation(line: 77, column: 26, scope: !222)
!242 = !DILocation(line: 77, column: 12, scope: !222)
!243 = !DILocation(line: 77, column: 10, scope: !222)
!244 = !DILocation(line: 79, column: 12, scope: !222)
!245 = !DILocation(line: 79, column: 17, scope: !222)
!246 = !DILocation(line: 79, column: 5, scope: !222)
!247 = distinct !DISubprogram(name: "verification_assume", scope: !248, file: !248, line: 116, type: !249, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!248 = !DIFile(filename: "include/vsync/common/verify.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "2fd10960d0c2c64c7ccf19294b1806ff")
!249 = !DISubroutineType(types: !250)
!250 = !{null, !208}
!251 = !DILocalVariable(name: "cond", arg: 1, scope: !247, file: !248, line: 116, type: !208)
!252 = !DILocation(line: 116, column: 29, scope: !247)
!253 = !DILocation(line: 118, column: 23, scope: !247)
!254 = !DILocation(line: 118, column: 5, scope: !247)
!255 = !DILocation(line: 119, column: 1, scope: !247)
!256 = distinct !DISubprogram(name: "mcslock_acquire", scope: !13, file: !13, line: 89, type: !257, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!257 = !DISubroutineType(types: !258)
!258 = !{null, !225, !11}
!259 = !DILocalVariable(name: "l", arg: 1, scope: !256, file: !13, line: 89, type: !225)
!260 = !DILocation(line: 89, column: 28, scope: !256)
!261 = !DILocalVariable(name: "node", arg: 2, scope: !256, file: !13, line: 89, type: !11)
!262 = !DILocation(line: 89, column: 43, scope: !256)
!263 = !DILocalVariable(name: "pred", scope: !256, file: !13, line: 91, type: !11)
!264 = !DILocation(line: 91, column: 17, scope: !256)
!265 = !DILocation(line: 93, column: 27, scope: !256)
!266 = !DILocation(line: 93, column: 33, scope: !256)
!267 = !DILocation(line: 93, column: 5, scope: !256)
!268 = !DILocation(line: 94, column: 26, scope: !256)
!269 = !DILocation(line: 94, column: 32, scope: !256)
!270 = !DILocation(line: 94, column: 5, scope: !256)
!271 = !DILocation(line: 96, column: 43, scope: !256)
!272 = !DILocation(line: 96, column: 46, scope: !256)
!273 = !DILocation(line: 96, column: 52, scope: !256)
!274 = !DILocation(line: 96, column: 26, scope: !256)
!275 = !DILocation(line: 96, column: 12, scope: !256)
!276 = !DILocation(line: 96, column: 10, scope: !256)
!277 = !DILocation(line: 97, column: 9, scope: !278)
!278 = distinct !DILexicalBlock(scope: !256, file: !13, line: 97, column: 9)
!279 = !DILocation(line: 97, column: 9, scope: !256)
!280 = !DILocation(line: 98, column: 31, scope: !281)
!281 = distinct !DILexicalBlock(scope: !278, file: !13, line: 97, column: 15)
!282 = !DILocation(line: 98, column: 37, scope: !281)
!283 = !DILocation(line: 98, column: 43, scope: !281)
!284 = !DILocation(line: 98, column: 9, scope: !281)
!285 = !DILocation(line: 99, column: 33, scope: !281)
!286 = !DILocation(line: 99, column: 39, scope: !281)
!287 = !DILocation(line: 99, column: 9, scope: !281)
!288 = !DILocation(line: 100, column: 5, scope: !281)
!289 = !DILocation(line: 101, column: 1, scope: !256)
!290 = distinct !DISubprogram(name: "release", scope: !36, file: !36, line: 25, type: !198, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!291 = !DILocalVariable(name: "tid", arg: 1, scope: !290, file: !36, line: 25, type: !27)
!292 = !DILocation(line: 25, column: 19, scope: !290)
!293 = !DILocation(line: 27, column: 35, scope: !290)
!294 = !DILocation(line: 27, column: 29, scope: !290)
!295 = !DILocation(line: 27, column: 5, scope: !290)
!296 = !DILocation(line: 28, column: 1, scope: !290)
!297 = distinct !DISubprogram(name: "mcslock_release", scope: !13, file: !13, line: 110, type: !257, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!298 = !DILocalVariable(name: "l", arg: 1, scope: !297, file: !13, line: 110, type: !225)
!299 = !DILocation(line: 110, column: 28, scope: !297)
!300 = !DILocalVariable(name: "node", arg: 2, scope: !297, file: !13, line: 110, type: !11)
!301 = !DILocation(line: 110, column: 43, scope: !297)
!302 = !DILocalVariable(name: "next", scope: !297, file: !13, line: 112, type: !11)
!303 = !DILocation(line: 112, column: 17, scope: !297)
!304 = !DILocation(line: 114, column: 30, scope: !305)
!305 = distinct !DILexicalBlock(scope: !297, file: !13, line: 114, column: 9)
!306 = !DILocation(line: 114, column: 36, scope: !305)
!307 = !DILocation(line: 114, column: 9, scope: !305)
!308 = !DILocation(line: 114, column: 42, scope: !305)
!309 = !DILocation(line: 114, column: 9, scope: !297)
!310 = !DILocation(line: 115, column: 54, scope: !311)
!311 = distinct !DILexicalBlock(scope: !305, file: !13, line: 114, column: 51)
!312 = !DILocation(line: 115, column: 57, scope: !311)
!313 = !DILocation(line: 115, column: 63, scope: !311)
!314 = !DILocation(line: 115, column: 30, scope: !311)
!315 = !DILocation(line: 115, column: 16, scope: !311)
!316 = !DILocation(line: 115, column: 14, scope: !311)
!317 = !DILocation(line: 116, column: 13, scope: !318)
!318 = distinct !DILexicalBlock(scope: !311, file: !13, line: 116, column: 13)
!319 = !DILocation(line: 116, column: 21, scope: !318)
!320 = !DILocation(line: 116, column: 18, scope: !318)
!321 = !DILocation(line: 116, column: 13, scope: !311)
!322 = !DILocation(line: 117, column: 13, scope: !323)
!323 = distinct !DILexicalBlock(scope: !318, file: !13, line: 116, column: 27)
!324 = !DILocation(line: 119, column: 35, scope: !311)
!325 = !DILocation(line: 119, column: 41, scope: !311)
!326 = !DILocation(line: 119, column: 9, scope: !311)
!327 = !DILocation(line: 120, column: 5, scope: !311)
!328 = !DILocation(line: 121, column: 47, scope: !297)
!329 = !DILocation(line: 121, column: 53, scope: !297)
!330 = !DILocation(line: 121, column: 26, scope: !297)
!331 = !DILocation(line: 121, column: 12, scope: !297)
!332 = !DILocation(line: 121, column: 10, scope: !297)
!333 = !DILocation(line: 122, column: 26, scope: !297)
!334 = !DILocation(line: 122, column: 32, scope: !297)
!335 = !DILocation(line: 122, column: 5, scope: !297)
!336 = !DILocation(line: 123, column: 1, scope: !297)
!337 = distinct !DISubprogram(name: "vatomicptr_write_rlx", scope: !338, file: !338, line: 325, type: !339, scopeLine: 326, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!338 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!339 = !DISubroutineType(types: !340)
!340 = !{null, !341, !5}
!341 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!342 = !DILocalVariable(name: "a", arg: 1, scope: !337, file: !338, line: 325, type: !341)
!343 = !DILocation(line: 325, column: 36, scope: !337)
!344 = !DILocalVariable(name: "v", arg: 2, scope: !337, file: !338, line: 325, type: !5)
!345 = !DILocation(line: 325, column: 45, scope: !337)
!346 = !DILocation(line: 329, column: 32, scope: !337)
!347 = !DILocation(line: 329, column: 44, scope: !337)
!348 = !DILocation(line: 329, column: 47, scope: !337)
!349 = !DILocation(line: 327, column: 5, scope: !337)
!350 = !{i64 406965}
!351 = !DILocation(line: 331, column: 1, scope: !337)
!352 = distinct !DISubprogram(name: "vatomic32_write_rlx", scope: !338, file: !338, line: 241, type: !353, scopeLine: 242, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!353 = !DISubroutineType(types: !354)
!354 = !{null, !355, !27}
!355 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!356 = !DILocalVariable(name: "a", arg: 1, scope: !352, file: !338, line: 241, type: !355)
!357 = !DILocation(line: 241, column: 34, scope: !352)
!358 = !DILocalVariable(name: "v", arg: 2, scope: !352, file: !338, line: 241, type: !27)
!359 = !DILocation(line: 241, column: 47, scope: !352)
!360 = !DILocation(line: 245, column: 32, scope: !352)
!361 = !DILocation(line: 245, column: 44, scope: !352)
!362 = !DILocation(line: 245, column: 47, scope: !352)
!363 = !DILocation(line: 243, column: 5, scope: !352)
!364 = !{i64 404176}
!365 = !DILocation(line: 247, column: 1, scope: !352)
!366 = distinct !DISubprogram(name: "vatomicptr_cmpxchg", scope: !367, file: !367, line: 486, type: !368, scopeLine: 487, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!367 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!368 = !DISubroutineType(types: !369)
!369 = !{!5, !341, !5, !5}
!370 = !DILocalVariable(name: "a", arg: 1, scope: !366, file: !367, line: 486, type: !341)
!371 = !DILocation(line: 486, column: 34, scope: !366)
!372 = !DILocalVariable(name: "e", arg: 2, scope: !366, file: !367, line: 486, type: !5)
!373 = !DILocation(line: 486, column: 43, scope: !366)
!374 = !DILocalVariable(name: "v", arg: 3, scope: !366, file: !367, line: 486, type: !5)
!375 = !DILocation(line: 486, column: 52, scope: !366)
!376 = !DILocalVariable(name: "oldv", scope: !366, file: !367, line: 488, type: !5)
!377 = !DILocation(line: 488, column: 11, scope: !366)
!378 = !DILocalVariable(name: "tmp", scope: !366, file: !367, line: 489, type: !27)
!379 = !DILocation(line: 489, column: 15, scope: !366)
!380 = !DILocation(line: 500, column: 22, scope: !366)
!381 = !DILocation(line: 500, column: 36, scope: !366)
!382 = !DILocation(line: 500, column: 48, scope: !366)
!383 = !DILocation(line: 500, column: 51, scope: !366)
!384 = !DILocation(line: 490, column: 5, scope: !366)
!385 = !{i64 470089, i64 470123, i64 470138, i64 470171, i64 470205, i64 470225, i64 470268, i64 470297}
!386 = !DILocation(line: 502, column: 12, scope: !366)
!387 = !DILocation(line: 502, column: 5, scope: !366)
!388 = distinct !DISubprogram(name: "vatomicptr_xchg", scope: !367, file: !367, line: 198, type: !389, scopeLine: 199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!389 = !DISubroutineType(types: !390)
!390 = !{!5, !341, !5}
!391 = !DILocalVariable(name: "a", arg: 1, scope: !388, file: !367, line: 198, type: !341)
!392 = !DILocation(line: 198, column: 31, scope: !388)
!393 = !DILocalVariable(name: "v", arg: 2, scope: !388, file: !367, line: 198, type: !5)
!394 = !DILocation(line: 198, column: 40, scope: !388)
!395 = !DILocalVariable(name: "oldv", scope: !388, file: !367, line: 200, type: !5)
!396 = !DILocation(line: 200, column: 11, scope: !388)
!397 = !DILocalVariable(name: "tmp", scope: !388, file: !367, line: 201, type: !27)
!398 = !DILocation(line: 201, column: 15, scope: !388)
!399 = !DILocation(line: 209, column: 22, scope: !388)
!400 = !DILocation(line: 209, column: 34, scope: !388)
!401 = !DILocation(line: 209, column: 37, scope: !388)
!402 = !DILocation(line: 202, column: 5, scope: !388)
!403 = !{i64 461284, i64 461318, i64 461333, i64 461366, i64 461409}
!404 = !DILocation(line: 211, column: 12, scope: !388)
!405 = !DILocation(line: 211, column: 5, scope: !388)
!406 = distinct !DISubprogram(name: "vatomicptr_write_rel", scope: !338, file: !338, line: 311, type: !339, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!407 = !DILocalVariable(name: "a", arg: 1, scope: !406, file: !338, line: 311, type: !341)
!408 = !DILocation(line: 311, column: 36, scope: !406)
!409 = !DILocalVariable(name: "v", arg: 2, scope: !406, file: !338, line: 311, type: !5)
!410 = !DILocation(line: 311, column: 45, scope: !406)
!411 = !DILocation(line: 315, column: 32, scope: !406)
!412 = !DILocation(line: 315, column: 44, scope: !406)
!413 = !DILocation(line: 315, column: 47, scope: !406)
!414 = !DILocation(line: 313, column: 5, scope: !406)
!415 = !{i64 406494}
!416 = !DILocation(line: 317, column: 1, scope: !406)
!417 = distinct !DISubprogram(name: "vatomic32_await_eq_acq", scope: !338, file: !338, line: 604, type: !418, scopeLine: 605, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!418 = !DISubroutineType(types: !419)
!419 = !{!27, !420, !27}
!420 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !421, size: 64)
!421 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
!422 = !DILocalVariable(name: "a", arg: 1, scope: !417, file: !338, line: 604, type: !420)
!423 = !DILocation(line: 604, column: 43, scope: !417)
!424 = !DILocalVariable(name: "v", arg: 2, scope: !417, file: !338, line: 604, type: !27)
!425 = !DILocation(line: 604, column: 56, scope: !417)
!426 = !DILocalVariable(name: "val", scope: !417, file: !338, line: 606, type: !27)
!427 = !DILocation(line: 606, column: 15, scope: !417)
!428 = !DILocation(line: 613, column: 21, scope: !417)
!429 = !DILocation(line: 613, column: 33, scope: !417)
!430 = !DILocation(line: 613, column: 36, scope: !417)
!431 = !DILocation(line: 607, column: 5, scope: !417)
!432 = !{i64 414328, i64 414344, i64 414375, i64 414408}
!433 = !DILocation(line: 615, column: 12, scope: !417)
!434 = !DILocation(line: 615, column: 5, scope: !417)
!435 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !338, file: !338, line: 197, type: !436, scopeLine: 198, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!436 = !DISubroutineType(types: !437)
!437 = !{!5, !438}
!438 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !439, size: 64)
!439 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!440 = !DILocalVariable(name: "a", arg: 1, scope: !435, file: !338, line: 197, type: !438)
!441 = !DILocation(line: 197, column: 41, scope: !435)
!442 = !DILocalVariable(name: "val", scope: !435, file: !338, line: 199, type: !5)
!443 = !DILocation(line: 199, column: 11, scope: !435)
!444 = !DILocation(line: 202, column: 32, scope: !435)
!445 = !DILocation(line: 202, column: 35, scope: !435)
!446 = !DILocation(line: 200, column: 5, scope: !435)
!447 = !{i64 402764}
!448 = !DILocation(line: 204, column: 12, scope: !435)
!449 = !DILocation(line: 204, column: 5, scope: !435)
!450 = distinct !DISubprogram(name: "vatomicptr_cmpxchg_rel", scope: !367, file: !367, line: 536, type: !368, scopeLine: 537, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!451 = !DILocalVariable(name: "a", arg: 1, scope: !450, file: !367, line: 536, type: !341)
!452 = !DILocation(line: 536, column: 38, scope: !450)
!453 = !DILocalVariable(name: "e", arg: 2, scope: !450, file: !367, line: 536, type: !5)
!454 = !DILocation(line: 536, column: 47, scope: !450)
!455 = !DILocalVariable(name: "v", arg: 3, scope: !450, file: !367, line: 536, type: !5)
!456 = !DILocation(line: 536, column: 56, scope: !450)
!457 = !DILocalVariable(name: "oldv", scope: !450, file: !367, line: 538, type: !5)
!458 = !DILocation(line: 538, column: 11, scope: !450)
!459 = !DILocalVariable(name: "tmp", scope: !450, file: !367, line: 539, type: !27)
!460 = !DILocation(line: 539, column: 15, scope: !450)
!461 = !DILocation(line: 550, column: 22, scope: !450)
!462 = !DILocation(line: 550, column: 36, scope: !450)
!463 = !DILocation(line: 550, column: 48, scope: !450)
!464 = !DILocation(line: 550, column: 51, scope: !450)
!465 = !DILocation(line: 540, column: 5, scope: !450)
!466 = !{i64 471622, i64 471656, i64 471671, i64 471703, i64 471737, i64 471757, i64 471800, i64 471829}
!467 = !DILocation(line: 552, column: 12, scope: !450)
!468 = !DILocation(line: 552, column: 5, scope: !450)
!469 = distinct !DISubprogram(name: "vatomicptr_await_neq_rlx", scope: !338, file: !338, line: 2144, type: !470, scopeLine: 2145, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!470 = !DISubroutineType(types: !471)
!471 = !{!5, !438, !5}
!472 = !DILocalVariable(name: "a", arg: 1, scope: !469, file: !338, line: 2144, type: !438)
!473 = !DILocation(line: 2144, column: 46, scope: !469)
!474 = !DILocalVariable(name: "v", arg: 2, scope: !469, file: !338, line: 2144, type: !5)
!475 = !DILocation(line: 2144, column: 55, scope: !469)
!476 = !DILocalVariable(name: "val", scope: !469, file: !338, line: 2146, type: !5)
!477 = !DILocation(line: 2146, column: 11, scope: !469)
!478 = !DILocation(line: 2153, column: 21, scope: !469)
!479 = !DILocation(line: 2153, column: 33, scope: !469)
!480 = !DILocation(line: 2153, column: 36, scope: !469)
!481 = !DILocation(line: 2147, column: 5, scope: !469)
!482 = !{i64 454407, i64 454423, i64 454453, i64 454486}
!483 = !DILocation(line: 2155, column: 12, scope: !469)
!484 = !DILocation(line: 2155, column: 5, scope: !469)
!485 = distinct !DISubprogram(name: "vatomicptr_read_acq", scope: !338, file: !338, line: 181, type: !436, scopeLine: 182, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!486 = !DILocalVariable(name: "a", arg: 1, scope: !485, file: !338, line: 181, type: !438)
!487 = !DILocation(line: 181, column: 41, scope: !485)
!488 = !DILocalVariable(name: "val", scope: !485, file: !338, line: 183, type: !5)
!489 = !DILocation(line: 183, column: 11, scope: !485)
!490 = !DILocation(line: 186, column: 32, scope: !485)
!491 = !DILocation(line: 186, column: 35, scope: !485)
!492 = !DILocation(line: 184, column: 5, scope: !485)
!493 = !{i64 402264}
!494 = !DILocation(line: 188, column: 12, scope: !485)
!495 = !DILocation(line: 188, column: 5, scope: !485)
!496 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !338, file: !338, line: 227, type: !353, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!497 = !DILocalVariable(name: "a", arg: 1, scope: !496, file: !338, line: 227, type: !355)
!498 = !DILocation(line: 227, column: 34, scope: !496)
!499 = !DILocalVariable(name: "v", arg: 2, scope: !496, file: !338, line: 227, type: !27)
!500 = !DILocation(line: 227, column: 47, scope: !496)
!501 = !DILocation(line: 231, column: 32, scope: !496)
!502 = !DILocation(line: 231, column: 44, scope: !496)
!503 = !DILocation(line: 231, column: 47, scope: !496)
!504 = !DILocation(line: 229, column: 5, scope: !496)
!505 = !{i64 403706}
!506 = !DILocation(line: 233, column: 1, scope: !496)
