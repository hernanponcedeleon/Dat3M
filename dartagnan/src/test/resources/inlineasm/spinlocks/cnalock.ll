; ModuleID = '/home/stefano/huawei/libvsync/spinlock/test/cnalock.c'
source_filename = "/home/stefano/huawei/libvsync/spinlock/test/cnalock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.vatomic32_s = type { i32 }
%struct.cnalock_s = type { %struct.vatomicptr_s }
%struct.vatomicptr_s = type { i8* }
%struct.cna_node_s = type { %struct.vatomicptr_s, %struct.vatomicptr_s, %struct.vatomic32_s }
%union.pthread_attr_t = type { i64, [48 x i8] }

@rand = dso_local global %struct.vatomic32_s zeroinitializer, align 4, !dbg !0
@g_cs_x = internal global i32 0, align 4, !dbg !47
@g_cs_y = internal global i32 0, align 4, !dbg !50
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [68 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (4 + 0 + 0)\00", align 1
@lock = dso_local global %struct.cnalock_s zeroinitializer, align 8, !dbg !35
@nodes = dso_local global [4 x %struct.cna_node_s] zeroinitializer, align 16, !dbg !42

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !60 {
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
  %2 = alloca [4 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [4 x i64]* %2, metadata !85, metadata !DIExpression()), !dbg !89
  call void @init(), !dbg !90
  call void @llvm.dbg.declare(metadata i64* %3, metadata !91, metadata !DIExpression()), !dbg !93
  store i64 0, i64* %3, align 8, !dbg !93
  br label %5, !dbg !94

5:                                                ; preds = %14, %0
  %6 = load i64, i64* %3, align 8, !dbg !95
  %7 = icmp ult i64 %6, 4, !dbg !97
  br i1 %7, label %8, label %17, !dbg !98

8:                                                ; preds = %5
  %9 = load i64, i64* %3, align 8, !dbg !99
  %10 = getelementptr inbounds [4 x i64], [4 x i64]* %2, i64 0, i64 %9, !dbg !101
  %11 = load i64, i64* %3, align 8, !dbg !102
  %12 = inttoptr i64 %11 to i8*, !dbg !103
  %13 = call i32 @pthread_create(i64* noundef %10, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef %12) #6, !dbg !104
  br label %14, !dbg !105

14:                                               ; preds = %8
  %15 = load i64, i64* %3, align 8, !dbg !106
  %16 = add i64 %15, 1, !dbg !106
  store i64 %16, i64* %3, align 8, !dbg !106
  br label %5, !dbg !107, !llvm.loop !108

17:                                               ; preds = %5
  call void @post(), !dbg !111
  call void @llvm.dbg.declare(metadata i64* %4, metadata !112, metadata !DIExpression()), !dbg !114
  store i64 0, i64* %4, align 8, !dbg !114
  br label %18, !dbg !115

18:                                               ; preds = %26, %17
  %19 = load i64, i64* %4, align 8, !dbg !116
  %20 = icmp ult i64 %19, 4, !dbg !118
  br i1 %20, label %21, label %29, !dbg !119

21:                                               ; preds = %18
  %22 = load i64, i64* %4, align 8, !dbg !120
  %23 = getelementptr inbounds [4 x i64], [4 x i64]* %2, i64 0, i64 %22, !dbg !122
  %24 = load i64, i64* %23, align 8, !dbg !122
  %25 = call i32 @pthread_join(i64 noundef %24, i8** noundef null), !dbg !123
  br label %26, !dbg !124

26:                                               ; preds = %21
  %27 = load i64, i64* %4, align 8, !dbg !125
  %28 = add i64 %27, 1, !dbg !125
  store i64 %28, i64* %4, align 8, !dbg !125
  br label %18, !dbg !126, !llvm.loop !127

29:                                               ; preds = %18
  call void @check(), !dbg !129
  call void @fini(), !dbg !130
  ret i32 0, !dbg !131
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !132 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !135, metadata !DIExpression()), !dbg !136
  call void @llvm.dbg.declare(metadata i32* %3, metadata !137, metadata !DIExpression()), !dbg !138
  %7 = load i8*, i8** %2, align 8, !dbg !139
  %8 = ptrtoint i8* %7 to i64, !dbg !140
  %9 = trunc i64 %8 to i32, !dbg !140
  store i32 %9, i32* %3, align 4, !dbg !138
  call void @llvm.dbg.declare(metadata i32* %4, metadata !141, metadata !DIExpression()), !dbg !143
  store i32 0, i32* %4, align 4, !dbg !143
  br label %10, !dbg !144

10:                                               ; preds = %65, %1
  %11 = load i32, i32* %4, align 4, !dbg !145
  %12 = icmp eq i32 %11, 0, !dbg !147
  br i1 %12, label %22, label %13, !dbg !148

13:                                               ; preds = %10
  %14 = load i32, i32* %4, align 4, !dbg !149
  %15 = icmp eq i32 %14, 1, !dbg !149
  br i1 %15, label %16, label %20, !dbg !149

16:                                               ; preds = %13
  %17 = load i32, i32* %3, align 4, !dbg !149
  %18 = add i32 %17, 1, !dbg !149
  %19 = icmp ult i32 %18, 1, !dbg !149
  br label %20

20:                                               ; preds = %16, %13
  %21 = phi i1 [ false, %13 ], [ %19, %16 ], !dbg !150
  br label %22, !dbg !148

22:                                               ; preds = %20, %10
  %23 = phi i1 [ true, %10 ], [ %21, %20 ]
  br i1 %23, label %24, label %68, !dbg !151

24:                                               ; preds = %22
  call void @llvm.dbg.declare(metadata i32* %5, metadata !152, metadata !DIExpression()), !dbg !155
  store i32 0, i32* %5, align 4, !dbg !155
  br label %25, !dbg !156

25:                                               ; preds = %41, %24
  %26 = load i32, i32* %5, align 4, !dbg !157
  %27 = icmp eq i32 %26, 0, !dbg !159
  br i1 %27, label %37, label %28, !dbg !160

28:                                               ; preds = %25
  %29 = load i32, i32* %5, align 4, !dbg !161
  %30 = icmp eq i32 %29, 1, !dbg !161
  br i1 %30, label %31, label %35, !dbg !161

31:                                               ; preds = %28
  %32 = load i32, i32* %3, align 4, !dbg !161
  %33 = add i32 %32, 1, !dbg !161
  %34 = icmp ult i32 %33, 1, !dbg !161
  br label %35

35:                                               ; preds = %31, %28
  %36 = phi i1 [ false, %28 ], [ %34, %31 ], !dbg !162
  br label %37, !dbg !160

37:                                               ; preds = %35, %25
  %38 = phi i1 [ true, %25 ], [ %36, %35 ]
  br i1 %38, label %39, label %44, !dbg !163

39:                                               ; preds = %37
  %40 = load i32, i32* %3, align 4, !dbg !164
  call void @acquire(i32 noundef %40), !dbg !166
  call void @cs(), !dbg !167
  br label %41, !dbg !168

41:                                               ; preds = %39
  %42 = load i32, i32* %5, align 4, !dbg !169
  %43 = add nsw i32 %42, 1, !dbg !169
  store i32 %43, i32* %5, align 4, !dbg !169
  br label %25, !dbg !170, !llvm.loop !171

44:                                               ; preds = %37
  call void @llvm.dbg.declare(metadata i32* %6, metadata !173, metadata !DIExpression()), !dbg !175
  store i32 0, i32* %6, align 4, !dbg !175
  br label %45, !dbg !176

45:                                               ; preds = %61, %44
  %46 = load i32, i32* %6, align 4, !dbg !177
  %47 = icmp eq i32 %46, 0, !dbg !179
  br i1 %47, label %57, label %48, !dbg !180

48:                                               ; preds = %45
  %49 = load i32, i32* %6, align 4, !dbg !181
  %50 = icmp eq i32 %49, 1, !dbg !181
  br i1 %50, label %51, label %55, !dbg !181

51:                                               ; preds = %48
  %52 = load i32, i32* %3, align 4, !dbg !181
  %53 = add i32 %52, 1, !dbg !181
  %54 = icmp ult i32 %53, 1, !dbg !181
  br label %55

55:                                               ; preds = %51, %48
  %56 = phi i1 [ false, %48 ], [ %54, %51 ], !dbg !182
  br label %57, !dbg !180

57:                                               ; preds = %55, %45
  %58 = phi i1 [ true, %45 ], [ %56, %55 ]
  br i1 %58, label %59, label %64, !dbg !183

59:                                               ; preds = %57
  %60 = load i32, i32* %3, align 4, !dbg !184
  call void @release(i32 noundef %60), !dbg !186
  br label %61, !dbg !187

61:                                               ; preds = %59
  %62 = load i32, i32* %6, align 4, !dbg !188
  %63 = add nsw i32 %62, 1, !dbg !188
  store i32 %63, i32* %6, align 4, !dbg !188
  br label %45, !dbg !189, !llvm.loop !190

64:                                               ; preds = %57
  br label %65, !dbg !192

65:                                               ; preds = %64
  %66 = load i32, i32* %4, align 4, !dbg !193
  %67 = add nsw i32 %66, 1, !dbg !193
  store i32 %67, i32* %4, align 4, !dbg !193
  br label %10, !dbg !194, !llvm.loop !195

68:                                               ; preds = %22
  ret i8* null, !dbg !197
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !198 {
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef @rand, i32 noundef 1), !dbg !199
  ret void, !dbg !200
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !201 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !206, metadata !DIExpression()), !dbg !207
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !208, metadata !DIExpression()), !dbg !209
  %5 = load i32, i32* %4, align 4, !dbg !210
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !211
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !212
  %8 = load i32, i32* %7, align 4, !dbg !212
  call void asm sideeffect "str ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !213, !srcloc !214
  ret void, !dbg !215
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !216 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !219, metadata !DIExpression()), !dbg !220
  %3 = load i32, i32* %2, align 4, !dbg !221
  %4 = zext i32 %3 to i64, !dbg !222
  %5 = getelementptr inbounds [4 x %struct.cna_node_s], [4 x %struct.cna_node_s]* @nodes, i64 0, i64 %4, !dbg !222
  %6 = load i32, i32* %2, align 4, !dbg !223
  %7 = icmp ult i32 %6, 2, !dbg !223
  %8 = zext i1 %7 to i32, !dbg !223
  call void @cnalock_acquire(%struct.cnalock_s* noundef @lock, %struct.cna_node_s* noundef %5, i32 noundef %8), !dbg !224
  ret void, !dbg !225
}

; Function Attrs: noinline nounwind uwtable
define internal void @cnalock_acquire(%struct.cnalock_s* noundef %0, %struct.cna_node_s* noundef %1, i32 noundef %2) #0 !dbg !226 {
  %4 = alloca %struct.cnalock_s*, align 8
  %5 = alloca %struct.cna_node_s*, align 8
  %6 = alloca i32, align 4
  %7 = alloca %struct.cna_node_s*, align 8
  store %struct.cnalock_s* %0, %struct.cnalock_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.cnalock_s** %4, metadata !230, metadata !DIExpression()), !dbg !231
  store %struct.cna_node_s* %1, %struct.cna_node_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.cna_node_s** %5, metadata !232, metadata !DIExpression()), !dbg !233
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !234, metadata !DIExpression()), !dbg !235
  %8 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !236
  %9 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %8, i32 0, i32 0, !dbg !237
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %9, i8* noundef null), !dbg !238
  %10 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !239
  %11 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %10, i32 0, i32 1, !dbg !240
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %11, i8* noundef null), !dbg !241
  %12 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !242
  %13 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %12, i32 0, i32 2, !dbg !243
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %13, i32 noundef -1), !dbg !244
  call void @llvm.dbg.declare(metadata %struct.cna_node_s** %7, metadata !245, metadata !DIExpression()), !dbg !246
  %14 = load %struct.cnalock_s*, %struct.cnalock_s** %4, align 8, !dbg !247
  %15 = getelementptr inbounds %struct.cnalock_s, %struct.cnalock_s* %14, i32 0, i32 0, !dbg !248
  %16 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !249
  %17 = bitcast %struct.cna_node_s* %16 to i8*, !dbg !249
  %18 = call i8* @vatomicptr_xchg(%struct.vatomicptr_s* noundef %15, i8* noundef %17), !dbg !250
  %19 = bitcast i8* %18 to %struct.cna_node_s*, !dbg !250
  store %struct.cna_node_s* %19, %struct.cna_node_s** %7, align 8, !dbg !246
  %20 = load %struct.cna_node_s*, %struct.cna_node_s** %7, align 8, !dbg !251
  %21 = icmp ne %struct.cna_node_s* %20, null, !dbg !251
  br i1 %21, label %25, label %22, !dbg !253

22:                                               ; preds = %3
  %23 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !254
  %24 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %23, i32 0, i32 0, !dbg !256
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %24, i8* noundef inttoptr (i64 1 to i8*)), !dbg !257
  br label %36, !dbg !258

25:                                               ; preds = %3
  %26 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !259
  %27 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %26, i32 0, i32 2, !dbg !260
  %28 = load i32, i32* %6, align 4, !dbg !261
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %27, i32 noundef %28), !dbg !262
  %29 = load %struct.cna_node_s*, %struct.cna_node_s** %7, align 8, !dbg !263
  %30 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %29, i32 0, i32 1, !dbg !264
  %31 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !265
  %32 = bitcast %struct.cna_node_s* %31 to i8*, !dbg !265
  call void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %30, i8* noundef %32), !dbg !266
  %33 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !267
  %34 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %33, i32 0, i32 0, !dbg !268
  %35 = call i8* @vatomicptr_await_neq_acq(%struct.vatomicptr_s* noundef %34, i8* noundef null), !dbg !269
  br label %36, !dbg !270

36:                                               ; preds = %25, %22
  ret void, !dbg !270
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !271 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !272, metadata !DIExpression()), !dbg !273
  %3 = load i32, i32* %2, align 4, !dbg !274
  %4 = zext i32 %3 to i64, !dbg !275
  %5 = getelementptr inbounds [4 x %struct.cna_node_s], [4 x %struct.cna_node_s]* @nodes, i64 0, i64 %4, !dbg !275
  %6 = load i32, i32* %2, align 4, !dbg !276
  %7 = icmp ult i32 %6, 2, !dbg !276
  %8 = zext i1 %7 to i32, !dbg !276
  call void @cnalock_release(%struct.cnalock_s* noundef @lock, %struct.cna_node_s* noundef %5, i32 noundef %8), !dbg !277
  ret void, !dbg !278
}

; Function Attrs: noinline nounwind uwtable
define internal void @cnalock_release(%struct.cnalock_s* noundef %0, %struct.cna_node_s* noundef %1, i32 noundef %2) #0 !dbg !279 {
  %4 = alloca %struct.cnalock_s*, align 8
  %5 = alloca %struct.cna_node_s*, align 8
  %6 = alloca i32, align 4
  %7 = alloca %struct.cna_node_s*, align 8
  %8 = alloca %struct.cna_node_s*, align 8
  %9 = alloca %struct.cna_node_s*, align 8
  %10 = alloca %struct.cna_node_s*, align 8
  %11 = alloca %struct.cna_node_s*, align 8
  %12 = alloca i8*, align 8
  %13 = alloca i32, align 4
  store %struct.cnalock_s* %0, %struct.cnalock_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.cnalock_s** %4, metadata !280, metadata !DIExpression()), !dbg !281
  store %struct.cna_node_s* %1, %struct.cna_node_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.cna_node_s** %5, metadata !282, metadata !DIExpression()), !dbg !283
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !284, metadata !DIExpression()), !dbg !285
  call void @llvm.dbg.declare(metadata %struct.cna_node_s** %7, metadata !286, metadata !DIExpression()), !dbg !287
  %14 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !288
  %15 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %14, i32 0, i32 1, !dbg !289
  %16 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %15), !dbg !290
  %17 = bitcast i8* %16 to %struct.cna_node_s*, !dbg !290
  store %struct.cna_node_s* %17, %struct.cna_node_s** %7, align 8, !dbg !287
  call void @llvm.dbg.declare(metadata %struct.cna_node_s** %8, metadata !291, metadata !DIExpression()), !dbg !292
  %18 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !293
  %19 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %18, i32 0, i32 0, !dbg !294
  %20 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %19), !dbg !295
  %21 = bitcast i8* %20 to %struct.cna_node_s*, !dbg !295
  store %struct.cna_node_s* %21, %struct.cna_node_s** %8, align 8, !dbg !292
  %22 = load %struct.cna_node_s*, %struct.cna_node_s** %7, align 8, !dbg !296
  %23 = icmp ne %struct.cna_node_s* %22, null, !dbg !296
  br i1 %23, label %67, label %24, !dbg !298

24:                                               ; preds = %3
  %25 = load %struct.cna_node_s*, %struct.cna_node_s** %8, align 8, !dbg !299
  %26 = icmp eq %struct.cna_node_s* %25, inttoptr (i64 1 to %struct.cna_node_s*), !dbg !302
  br i1 %26, label %27, label %38, !dbg !303

27:                                               ; preds = %24
  %28 = load %struct.cnalock_s*, %struct.cnalock_s** %4, align 8, !dbg !304
  %29 = getelementptr inbounds %struct.cnalock_s, %struct.cnalock_s* %28, i32 0, i32 0, !dbg !307
  %30 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !308
  %31 = bitcast %struct.cna_node_s* %30 to i8*, !dbg !308
  %32 = call i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %29, i8* noundef %31, i8* noundef null), !dbg !309
  %33 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !310
  %34 = bitcast %struct.cna_node_s* %33 to i8*, !dbg !310
  %35 = icmp eq i8* %32, %34, !dbg !311
  br i1 %35, label %36, label %37, !dbg !312

36:                                               ; preds = %27
  br label %105, !dbg !313

37:                                               ; preds = %27
  br label %62, !dbg !315

38:                                               ; preds = %24
  call void @llvm.dbg.declare(metadata %struct.cna_node_s** %9, metadata !316, metadata !DIExpression()), !dbg !318
  %39 = load %struct.cna_node_s*, %struct.cna_node_s** %8, align 8, !dbg !319
  store %struct.cna_node_s* %39, %struct.cna_node_s** %9, align 8, !dbg !318
  call void @llvm.dbg.declare(metadata %struct.cna_node_s** %10, metadata !320, metadata !DIExpression()), !dbg !321
  %40 = load %struct.cna_node_s*, %struct.cna_node_s** %9, align 8, !dbg !322
  %41 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %40, i32 0, i32 1, !dbg !323
  %42 = call i8* @vatomicptr_xchg_rlx(%struct.vatomicptr_s* noundef %41, i8* noundef null), !dbg !324
  %43 = bitcast i8* %42 to %struct.cna_node_s*, !dbg !324
  store %struct.cna_node_s* %43, %struct.cna_node_s** %10, align 8, !dbg !321
  %44 = load %struct.cnalock_s*, %struct.cnalock_s** %4, align 8, !dbg !325
  %45 = getelementptr inbounds %struct.cnalock_s, %struct.cnalock_s* %44, i32 0, i32 0, !dbg !327
  %46 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !328
  %47 = bitcast %struct.cna_node_s* %46 to i8*, !dbg !328
  %48 = load %struct.cna_node_s*, %struct.cna_node_s** %9, align 8, !dbg !329
  %49 = bitcast %struct.cna_node_s* %48 to i8*, !dbg !329
  %50 = call i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %45, i8* noundef %47, i8* noundef %49), !dbg !330
  %51 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !331
  %52 = bitcast %struct.cna_node_s* %51 to i8*, !dbg !331
  %53 = icmp eq i8* %50, %52, !dbg !332
  br i1 %53, label %54, label %57, !dbg !333

54:                                               ; preds = %38
  %55 = load %struct.cna_node_s*, %struct.cna_node_s** %10, align 8, !dbg !334
  %56 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %55, i32 0, i32 0, !dbg !336
  call void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %56, i8* noundef inttoptr (i64 1 to i8*)), !dbg !337
  br label %105, !dbg !338

57:                                               ; preds = %38
  %58 = load %struct.cna_node_s*, %struct.cna_node_s** %9, align 8, !dbg !339
  %59 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %58, i32 0, i32 1, !dbg !340
  %60 = load %struct.cna_node_s*, %struct.cna_node_s** %10, align 8, !dbg !341
  %61 = bitcast %struct.cna_node_s* %60 to i8*, !dbg !341
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %59, i8* noundef %61), !dbg !342
  br label %62

62:                                               ; preds = %57, %37
  %63 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !343
  %64 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %63, i32 0, i32 1, !dbg !344
  %65 = call i8* @vatomicptr_await_neq_acq(%struct.vatomicptr_s* noundef %64, i8* noundef null), !dbg !345
  %66 = bitcast i8* %65 to %struct.cna_node_s*, !dbg !345
  store %struct.cna_node_s* %66, %struct.cna_node_s** %7, align 8, !dbg !346
  br label %67, !dbg !347

67:                                               ; preds = %62, %3
  call void @llvm.dbg.declare(metadata %struct.cna_node_s** %11, metadata !348, metadata !DIExpression()), !dbg !349
  store %struct.cna_node_s* null, %struct.cna_node_s** %11, align 8, !dbg !349
  call void @llvm.dbg.declare(metadata i8** %12, metadata !350, metadata !DIExpression()), !dbg !351
  store i8* inttoptr (i64 1 to i8*), i8** %12, align 8, !dbg !351
  call void @llvm.dbg.declare(metadata i32* %13, metadata !352, metadata !DIExpression()), !dbg !353
  %68 = call i32 @_cnalock_keep_lock_local(), !dbg !354
  store i32 %68, i32* %13, align 4, !dbg !353
  %69 = load i32, i32* %13, align 4, !dbg !355
  %70 = icmp ne i32 %69, 0, !dbg !355
  br i1 %70, label %71, label %79, !dbg !357

71:                                               ; preds = %67
  %72 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !358
  %73 = load i32, i32* %6, align 4, !dbg !360
  %74 = call %struct.cna_node_s* @_cnalock_find_successor(%struct.cna_node_s* noundef %72, i32 noundef %73), !dbg !361
  store %struct.cna_node_s* %74, %struct.cna_node_s** %11, align 8, !dbg !362
  %75 = load %struct.cna_node_s*, %struct.cna_node_s** %5, align 8, !dbg !363
  %76 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %75, i32 0, i32 0, !dbg !364
  %77 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %76), !dbg !365
  %78 = bitcast i8* %77 to %struct.cna_node_s*, !dbg !365
  store %struct.cna_node_s* %78, %struct.cna_node_s** %8, align 8, !dbg !366
  br label %79, !dbg !367

79:                                               ; preds = %71, %67
  %80 = load i32, i32* %13, align 4, !dbg !368
  %81 = icmp ne i32 %80, 0, !dbg !368
  br i1 %81, label %82, label %88, !dbg !370

82:                                               ; preds = %79
  %83 = load %struct.cna_node_s*, %struct.cna_node_s** %11, align 8, !dbg !371
  %84 = icmp ne %struct.cna_node_s* %83, null, !dbg !371
  br i1 %84, label %85, label %88, !dbg !372

85:                                               ; preds = %82
  %86 = load %struct.cna_node_s*, %struct.cna_node_s** %8, align 8, !dbg !373
  %87 = bitcast %struct.cna_node_s* %86 to i8*, !dbg !373
  store i8* %87, i8** %12, align 8, !dbg !375
  br label %101, !dbg !376

88:                                               ; preds = %82, %79
  %89 = load %struct.cna_node_s*, %struct.cna_node_s** %8, align 8, !dbg !377
  %90 = icmp ugt %struct.cna_node_s* %89, inttoptr (i64 1 to %struct.cna_node_s*), !dbg !379
  br i1 %90, label %91, label %98, !dbg !380

91:                                               ; preds = %88
  %92 = load %struct.cna_node_s*, %struct.cna_node_s** %8, align 8, !dbg !381
  %93 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %92, i32 0, i32 1, !dbg !383
  %94 = load %struct.cna_node_s*, %struct.cna_node_s** %7, align 8, !dbg !384
  %95 = bitcast %struct.cna_node_s* %94 to i8*, !dbg !384
  %96 = call i8* @vatomicptr_xchg_rlx(%struct.vatomicptr_s* noundef %93, i8* noundef %95), !dbg !385
  %97 = bitcast i8* %96 to %struct.cna_node_s*, !dbg !385
  store %struct.cna_node_s* %97, %struct.cna_node_s** %11, align 8, !dbg !386
  br label %100, !dbg !387

98:                                               ; preds = %88
  %99 = load %struct.cna_node_s*, %struct.cna_node_s** %7, align 8, !dbg !388
  store %struct.cna_node_s* %99, %struct.cna_node_s** %11, align 8, !dbg !390
  br label %100

100:                                              ; preds = %98, %91
  br label %101

101:                                              ; preds = %100, %85
  %102 = load %struct.cna_node_s*, %struct.cna_node_s** %11, align 8, !dbg !391
  %103 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %102, i32 0, i32 0, !dbg !392
  %104 = load i8*, i8** %12, align 8, !dbg !393
  call void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %103, i8* noundef %104), !dbg !394
  br label %105, !dbg !395

105:                                              ; preds = %101, %54, %36
  ret void, !dbg !395
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !396 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !400, metadata !DIExpression()), !dbg !401
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !402, metadata !DIExpression()), !dbg !403
  %5 = load i8*, i8** %4, align 8, !dbg !404
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !405
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !406
  %8 = load i8*, i8** %7, align 8, !dbg !406
  call void asm sideeffect "str ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !407, !srcloc !408
  ret void, !dbg !409
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_xchg(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !410 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !414, metadata !DIExpression()), !dbg !415
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !416, metadata !DIExpression()), !dbg !417
  call void @llvm.dbg.declare(metadata i8** %5, metadata !418, metadata !DIExpression()), !dbg !419
  call void @llvm.dbg.declare(metadata i32* %6, metadata !420, metadata !DIExpression()), !dbg !421
  %7 = load i8*, i8** %4, align 8, !dbg !422
  %8 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !423
  %9 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %8, i32 0, i32 0, !dbg !424
  %10 = load i8*, i8** %9, align 8, !dbg !424
  %11 = call { i8*, i32 } asm sideeffect "prfm pstl1strm, $3\0A1:\0Aldaxr ${0:x}, $3\0Astlxr  ${1:w}, ${2:x}, $3\0Acbnz ${1:w}, 1b\0A", "=&r,=&r,r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %7, i8* %10) #6, !dbg !425, !srcloc !426
  %12 = extractvalue { i8*, i32 } %11, 0, !dbg !425
  %13 = extractvalue { i8*, i32 } %11, 1, !dbg !425
  store i8* %12, i8** %5, align 8, !dbg !425
  store i32 %13, i32* %6, align 4, !dbg !425
  %14 = load i8*, i8** %5, align 8, !dbg !427
  ret i8* %14, !dbg !428
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomicptr_write_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !429 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !430, metadata !DIExpression()), !dbg !431
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !432, metadata !DIExpression()), !dbg !433
  %5 = load i8*, i8** %4, align 8, !dbg !434
  %6 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !435
  %7 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %6, i32 0, i32 0, !dbg !436
  %8 = load i8*, i8** %7, align 8, !dbg !436
  call void asm sideeffect "stlr ${0:x}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %5, i8* %8) #6, !dbg !437, !srcloc !438
  ret void, !dbg !439
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_await_neq_acq(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !440 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !445, metadata !DIExpression()), !dbg !446
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !447, metadata !DIExpression()), !dbg !448
  call void @llvm.dbg.declare(metadata i8** %5, metadata !449, metadata !DIExpression()), !dbg !450
  %6 = load i8*, i8** %4, align 8, !dbg !451
  %7 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !452
  %8 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %7, i32 0, i32 0, !dbg !453
  %9 = load i8*, i8** %8, align 8, !dbg !453
  %10 = call i8* asm sideeffect "1:\0Aldar ${0:x}, $2\0Acmp ${0:x}, ${1:x}\0Ab.eq 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i8* %6, i8* %9) #6, !dbg !454, !srcloc !455
  store i8* %10, i8** %5, align 8, !dbg !454
  %11 = load i8*, i8** %5, align 8, !dbg !456
  ret i8* %11, !dbg !457
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %0) #0 !dbg !458 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !461, metadata !DIExpression()), !dbg !462
  call void @llvm.dbg.declare(metadata i8** %3, metadata !463, metadata !DIExpression()), !dbg !464
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !465
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !466
  %6 = load i8*, i8** %5, align 8, !dbg !466
  %7 = call i8* asm sideeffect "ldar ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !467, !srcloc !468
  store i8* %7, i8** %3, align 8, !dbg !467
  %8 = load i8*, i8** %3, align 8, !dbg !469
  ret i8* %8, !dbg !470
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %0) #0 !dbg !471 {
  %2 = alloca %struct.vatomicptr_s*, align 8
  %3 = alloca i8*, align 8
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %2, metadata !472, metadata !DIExpression()), !dbg !473
  call void @llvm.dbg.declare(metadata i8** %3, metadata !474, metadata !DIExpression()), !dbg !475
  %4 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %2, align 8, !dbg !476
  %5 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %4, i32 0, i32 0, !dbg !477
  %6 = load i8*, i8** %5, align 8, !dbg !477
  %7 = call i8* asm sideeffect "ldr ${0:x}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %6) #6, !dbg !478, !srcloc !479
  store i8* %7, i8** %3, align 8, !dbg !478
  %8 = load i8*, i8** %3, align 8, !dbg !480
  ret i8* %8, !dbg !481
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_cmpxchg_rel(%struct.vatomicptr_s* noundef %0, i8* noundef %1, i8* noundef %2) #0 !dbg !482 {
  %4 = alloca %struct.vatomicptr_s*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i32, align 4
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %4, metadata !485, metadata !DIExpression()), !dbg !486
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !487, metadata !DIExpression()), !dbg !488
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !489, metadata !DIExpression()), !dbg !490
  call void @llvm.dbg.declare(metadata i8** %7, metadata !491, metadata !DIExpression()), !dbg !492
  call void @llvm.dbg.declare(metadata i32* %8, metadata !493, metadata !DIExpression()), !dbg !494
  %9 = load i8*, i8** %6, align 8, !dbg !495
  %10 = load i8*, i8** %5, align 8, !dbg !496
  %11 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %4, align 8, !dbg !497
  %12 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %11, i32 0, i32 0, !dbg !498
  %13 = load i8*, i8** %12, align 8, !dbg !498
  %14 = call { i8*, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:x}, $4\0Acmp ${0:x}, ${3:x}\0Ab.ne 2f\0Astlxr  ${1:w}, ${2:x}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i8* %9, i8* %10, i8* %13) #6, !dbg !499, !srcloc !500
  %15 = extractvalue { i8*, i32 } %14, 0, !dbg !499
  %16 = extractvalue { i8*, i32 } %14, 1, !dbg !499
  store i8* %15, i8** %7, align 8, !dbg !499
  store i32 %16, i32* %8, align 4, !dbg !499
  %17 = load i8*, i8** %7, align 8, !dbg !501
  ret i8* %17, !dbg !502
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vatomicptr_xchg_rlx(%struct.vatomicptr_s* noundef %0, i8* noundef %1) #0 !dbg !503 {
  %3 = alloca %struct.vatomicptr_s*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i32, align 4
  store %struct.vatomicptr_s* %0, %struct.vatomicptr_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomicptr_s** %3, metadata !504, metadata !DIExpression()), !dbg !505
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !506, metadata !DIExpression()), !dbg !507
  call void @llvm.dbg.declare(metadata i8** %5, metadata !508, metadata !DIExpression()), !dbg !509
  call void @llvm.dbg.declare(metadata i32* %6, metadata !510, metadata !DIExpression()), !dbg !511
  %7 = load i8*, i8** %4, align 8, !dbg !512
  %8 = load %struct.vatomicptr_s*, %struct.vatomicptr_s** %3, align 8, !dbg !513
  %9 = getelementptr inbounds %struct.vatomicptr_s, %struct.vatomicptr_s* %8, i32 0, i32 0, !dbg !514
  %10 = load i8*, i8** %9, align 8, !dbg !514
  %11 = call { i8*, i32 } asm sideeffect "prfm pstl1strm, $3\0A1:\0Aldxr ${0:x}, $3\0Astxr  ${1:w}, ${2:x}, $3\0Acbnz ${1:w}, 1b\0A", "=&r,=&r,r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i8* %7, i8* %10) #6, !dbg !515, !srcloc !516
  %12 = extractvalue { i8*, i32 } %11, 0, !dbg !515
  %13 = extractvalue { i8*, i32 } %11, 1, !dbg !515
  store i8* %12, i8** %5, align 8, !dbg !515
  store i32 %13, i32* %6, align 4, !dbg !515
  %14 = load i8*, i8** %5, align 8, !dbg !517
  ret i8* %14, !dbg !518
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @_cnalock_keep_lock_local() #0 !dbg !519 {
  %1 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef @rand), !dbg !522
  ret i32 %1, !dbg !523
}

; Function Attrs: noinline nounwind uwtable
define internal %struct.cna_node_s* @_cnalock_find_successor(%struct.cna_node_s* noundef %0, i32 noundef %1) #0 !dbg !524 {
  %3 = alloca %struct.cna_node_s*, align 8
  %4 = alloca %struct.cna_node_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca %struct.cna_node_s*, align 8
  %7 = alloca i32, align 4
  %8 = alloca %struct.cna_node_s*, align 8
  %9 = alloca %struct.cna_node_s*, align 8
  %10 = alloca %struct.cna_node_s*, align 8
  %11 = alloca %struct.cna_node_s*, align 8
  %12 = alloca %struct.cna_node_s*, align 8
  store %struct.cna_node_s* %0, %struct.cna_node_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.cna_node_s** %4, metadata !527, metadata !DIExpression()), !dbg !528
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !529, metadata !DIExpression()), !dbg !530
  call void @llvm.dbg.declare(metadata %struct.cna_node_s** %6, metadata !531, metadata !DIExpression()), !dbg !532
  %13 = load %struct.cna_node_s*, %struct.cna_node_s** %4, align 8, !dbg !533
  %14 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %13, i32 0, i32 1, !dbg !534
  %15 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %14), !dbg !535
  %16 = bitcast i8* %15 to %struct.cna_node_s*, !dbg !535
  store %struct.cna_node_s* %16, %struct.cna_node_s** %6, align 8, !dbg !532
  call void @llvm.dbg.declare(metadata i32* %7, metadata !536, metadata !DIExpression()), !dbg !537
  %17 = load %struct.cna_node_s*, %struct.cna_node_s** %4, align 8, !dbg !538
  %18 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %17, i32 0, i32 2, !dbg !539
  %19 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %18), !dbg !540
  store i32 %19, i32* %7, align 4, !dbg !537
  %20 = load i32, i32* %7, align 4, !dbg !541
  %21 = icmp eq i32 %20, -1, !dbg !543
  br i1 %21, label %22, label %24, !dbg !544

22:                                               ; preds = %2
  %23 = load i32, i32* %5, align 4, !dbg !545
  store i32 %23, i32* %7, align 4, !dbg !547
  br label %24, !dbg !548

24:                                               ; preds = %22, %2
  call void @llvm.dbg.declare(metadata %struct.cna_node_s** %8, metadata !549, metadata !DIExpression()), !dbg !550
  %25 = load %struct.cna_node_s*, %struct.cna_node_s** %6, align 8, !dbg !551
  store %struct.cna_node_s* %25, %struct.cna_node_s** %8, align 8, !dbg !550
  call void @llvm.dbg.declare(metadata %struct.cna_node_s** %9, metadata !552, metadata !DIExpression()), !dbg !553
  %26 = load %struct.cna_node_s*, %struct.cna_node_s** %6, align 8, !dbg !554
  store %struct.cna_node_s* %26, %struct.cna_node_s** %9, align 8, !dbg !553
  call void @llvm.dbg.declare(metadata %struct.cna_node_s** %10, metadata !555, metadata !DIExpression()), !dbg !556
  %27 = load %struct.cna_node_s*, %struct.cna_node_s** %6, align 8, !dbg !557
  store %struct.cna_node_s* %27, %struct.cna_node_s** %10, align 8, !dbg !559
  br label %28, !dbg !560

28:                                               ; preds = %40, %24
  %29 = load %struct.cna_node_s*, %struct.cna_node_s** %10, align 8, !dbg !561
  %30 = icmp ne %struct.cna_node_s* %29, null, !dbg !561
  br i1 %30, label %31, label %37, !dbg !563

31:                                               ; preds = %28
  %32 = load %struct.cna_node_s*, %struct.cna_node_s** %10, align 8, !dbg !564
  %33 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %32, i32 0, i32 2, !dbg !565
  %34 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %33), !dbg !566
  %35 = load i32, i32* %7, align 4, !dbg !567
  %36 = icmp ne i32 %34, %35, !dbg !568
  br label %37

37:                                               ; preds = %31, %28
  %38 = phi i1 [ false, %28 ], [ %36, %31 ], !dbg !569
  br i1 %38, label %39, label %46, !dbg !570

39:                                               ; preds = %37
  br label %40, !dbg !571

40:                                               ; preds = %39
  %41 = load %struct.cna_node_s*, %struct.cna_node_s** %10, align 8, !dbg !573
  store %struct.cna_node_s* %41, %struct.cna_node_s** %9, align 8, !dbg !574
  %42 = load %struct.cna_node_s*, %struct.cna_node_s** %10, align 8, !dbg !575
  %43 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %42, i32 0, i32 1, !dbg !576
  %44 = call i8* @vatomicptr_read_acq(%struct.vatomicptr_s* noundef %43), !dbg !577
  %45 = bitcast i8* %44 to %struct.cna_node_s*, !dbg !577
  store %struct.cna_node_s* %45, %struct.cna_node_s** %10, align 8, !dbg !578
  br label %28, !dbg !579, !llvm.loop !580

46:                                               ; preds = %37
  %47 = load %struct.cna_node_s*, %struct.cna_node_s** %10, align 8, !dbg !582
  %48 = icmp ne %struct.cna_node_s* %47, null, !dbg !582
  br i1 %48, label %50, label %49, !dbg !584

49:                                               ; preds = %46
  store %struct.cna_node_s* null, %struct.cna_node_s** %3, align 8, !dbg !585
  br label %81, !dbg !585

50:                                               ; preds = %46
  %51 = load %struct.cna_node_s*, %struct.cna_node_s** %10, align 8, !dbg !587
  %52 = load %struct.cna_node_s*, %struct.cna_node_s** %6, align 8, !dbg !589
  %53 = icmp eq %struct.cna_node_s* %51, %52, !dbg !590
  br i1 %53, label %54, label %56, !dbg !591

54:                                               ; preds = %50
  %55 = load %struct.cna_node_s*, %struct.cna_node_s** %6, align 8, !dbg !592
  store %struct.cna_node_s* %55, %struct.cna_node_s** %3, align 8, !dbg !594
  br label %81, !dbg !594

56:                                               ; preds = %50
  call void @llvm.dbg.declare(metadata %struct.cna_node_s** %11, metadata !595, metadata !DIExpression()), !dbg !596
  %57 = load %struct.cna_node_s*, %struct.cna_node_s** %4, align 8, !dbg !597
  %58 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %57, i32 0, i32 0, !dbg !598
  %59 = call i8* @vatomicptr_read_rlx(%struct.vatomicptr_s* noundef %58), !dbg !599
  %60 = bitcast i8* %59 to %struct.cna_node_s*, !dbg !599
  store %struct.cna_node_s* %60, %struct.cna_node_s** %11, align 8, !dbg !596
  %61 = load %struct.cna_node_s*, %struct.cna_node_s** %11, align 8, !dbg !600
  %62 = icmp ugt %struct.cna_node_s* %61, inttoptr (i64 1 to %struct.cna_node_s*), !dbg !602
  br i1 %62, label %63, label %71, !dbg !603

63:                                               ; preds = %56
  call void @llvm.dbg.declare(metadata %struct.cna_node_s** %12, metadata !604, metadata !DIExpression()), !dbg !606
  %64 = load %struct.cna_node_s*, %struct.cna_node_s** %11, align 8, !dbg !607
  %65 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %64, i32 0, i32 1, !dbg !608
  %66 = load %struct.cna_node_s*, %struct.cna_node_s** %8, align 8, !dbg !609
  %67 = bitcast %struct.cna_node_s* %66 to i8*, !dbg !609
  %68 = call i8* @vatomicptr_xchg_rlx(%struct.vatomicptr_s* noundef %65, i8* noundef %67), !dbg !610
  %69 = bitcast i8* %68 to %struct.cna_node_s*, !dbg !610
  store %struct.cna_node_s* %69, %struct.cna_node_s** %12, align 8, !dbg !606
  %70 = load %struct.cna_node_s*, %struct.cna_node_s** %12, align 8, !dbg !611
  store %struct.cna_node_s* %70, %struct.cna_node_s** %8, align 8, !dbg !612
  br label %71, !dbg !613

71:                                               ; preds = %63, %56
  %72 = load %struct.cna_node_s*, %struct.cna_node_s** %9, align 8, !dbg !614
  %73 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %72, i32 0, i32 1, !dbg !615
  %74 = load %struct.cna_node_s*, %struct.cna_node_s** %8, align 8, !dbg !616
  %75 = bitcast %struct.cna_node_s* %74 to i8*, !dbg !616
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %73, i8* noundef %75), !dbg !617
  %76 = load %struct.cna_node_s*, %struct.cna_node_s** %4, align 8, !dbg !618
  %77 = getelementptr inbounds %struct.cna_node_s, %struct.cna_node_s* %76, i32 0, i32 0, !dbg !619
  %78 = load %struct.cna_node_s*, %struct.cna_node_s** %9, align 8, !dbg !620
  %79 = bitcast %struct.cna_node_s* %78 to i8*, !dbg !620
  call void @vatomicptr_write_rlx(%struct.vatomicptr_s* noundef %77, i8* noundef %79), !dbg !621
  %80 = load %struct.cna_node_s*, %struct.cna_node_s** %10, align 8, !dbg !622
  store %struct.cna_node_s* %80, %struct.cna_node_s** %3, align 8, !dbg !623
  br label %81, !dbg !623

81:                                               ; preds = %71, %54, %49
  %82 = load %struct.cna_node_s*, %struct.cna_node_s** %3, align 8, !dbg !624
  ret %struct.cna_node_s* %82, !dbg !624
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !625 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !630, metadata !DIExpression()), !dbg !631
  call void @llvm.dbg.declare(metadata i32* %3, metadata !632, metadata !DIExpression()), !dbg !633
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !634
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !635
  %6 = load i32, i32* %5, align 4, !dbg !635
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !636, !srcloc !637
  store i32 %7, i32* %3, align 4, !dbg !636
  %8 = load i32, i32* %3, align 4, !dbg !638
  ret i32 %8, !dbg !639
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
!1 = distinct !DIGlobalVariable(name: "rand", scope: !2, file: !13, line: 47, type: !24, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !34, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/spinlock/test/cnalock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "07ae701b493d67a481e61f952dc32dd3")
!4 = !{!5, !6, !11}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 37, baseType: !8)
!7 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !9, line: 90, baseType: !10)
!9 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "cna_node_t", file: !13, line: 34, baseType: !14)
!13 = !DIFile(filename: "spinlock/include/vsync/spinlock/cnalock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "5edde7c0abcf9334e48cb8f94818d03f")
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "cna_node_s", file: !13, line: 30, size: 192, elements: !15)
!15 = !{!16, !22, !23}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "spin", scope: !14, file: !13, line: 31, baseType: !17, size: 64, align: 64)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomicptr_t", file: !18, line: 44, baseType: !19)
!18 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomicptr_s", file: !18, line: 42, size: 64, align: 64, elements: !20)
!20 = !{!21}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !19, file: !18, line: 43, baseType: !5, size: 64)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !14, file: !13, line: 32, baseType: !17, size: 64, align: 64, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "node", scope: !14, file: !13, line: 33, baseType: !24, size: 32, align: 32, offset: 128)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !18, line: 34, baseType: !25)
!25 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !18, line: 32, size: 32, align: 32, elements: !26)
!26 = !{!27}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !25, file: !18, line: 33, baseType: !28, size: 32)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !7, line: 35, baseType: !29)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !30, line: 26, baseType: !31)
!30 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !32, line: 42, baseType: !33)
!32 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!33 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!34 = !{!0, !35, !42, !47, !50}
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !37, line: 12, type: !38, isLocal: false, isDefinition: true)
!37 = !DIFile(filename: "spinlock/test/cnalock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "07ae701b493d67a481e61f952dc32dd3")
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "cnalock_t", file: !13, line: 38, baseType: !39)
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "cnalock_s", file: !13, line: 36, size: 64, elements: !40)
!40 = !{!41}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !39, file: !13, line: 37, baseType: !17, size: 64, align: 64)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "nodes", scope: !2, file: !37, line: 13, type: !44, isLocal: false, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 768, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 4)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !49, line: 100, type: !28, isLocal: true, isDefinition: true)
!49 = !DIFile(filename: "utils/include/test/boilerplate/lock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4187ade4a536ecfd1f9ed3ab727ca965")
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !49, line: 101, type: !28, isLocal: true, isDefinition: true)
!52 = !{i32 7, !"Dwarf Version", i32 5}
!53 = !{i32 2, !"Debug Info Version", i32 3}
!54 = !{i32 1, !"wchar_size", i32 4}
!55 = !{i32 7, !"PIC Level", i32 2}
!56 = !{i32 7, !"PIE Level", i32 2}
!57 = !{i32 7, !"uwtable", i32 1}
!58 = !{i32 7, !"frame-pointer", i32 2}
!59 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!60 = distinct !DISubprogram(name: "init", scope: !49, file: !49, line: 68, type: !61, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!61 = !DISubroutineType(types: !62)
!62 = !{null}
!63 = !{}
!64 = !DILocation(line: 70, column: 1, scope: !60)
!65 = distinct !DISubprogram(name: "fini", scope: !49, file: !49, line: 86, type: !61, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!66 = !DILocation(line: 88, column: 1, scope: !65)
!67 = distinct !DISubprogram(name: "cs", scope: !49, file: !49, line: 104, type: !61, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!68 = !DILocation(line: 106, column: 11, scope: !67)
!69 = !DILocation(line: 107, column: 11, scope: !67)
!70 = !DILocation(line: 108, column: 1, scope: !67)
!71 = distinct !DISubprogram(name: "check", scope: !49, file: !49, line: 110, type: !61, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!72 = !DILocation(line: 112, column: 5, scope: !73)
!73 = distinct !DILexicalBlock(scope: !74, file: !49, line: 112, column: 5)
!74 = distinct !DILexicalBlock(scope: !71, file: !49, line: 112, column: 5)
!75 = !DILocation(line: 112, column: 5, scope: !74)
!76 = !DILocation(line: 113, column: 5, scope: !77)
!77 = distinct !DILexicalBlock(scope: !78, file: !49, line: 113, column: 5)
!78 = distinct !DILexicalBlock(scope: !71, file: !49, line: 113, column: 5)
!79 = !DILocation(line: 113, column: 5, scope: !78)
!80 = !DILocation(line: 114, column: 1, scope: !71)
!81 = distinct !DISubprogram(name: "main", scope: !49, file: !49, line: 141, type: !82, scopeLine: 142, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!82 = !DISubroutineType(types: !83)
!83 = !{!84}
!84 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!85 = !DILocalVariable(name: "t", scope: !81, file: !49, line: 143, type: !86)
!86 = !DICompositeType(tag: DW_TAG_array_type, baseType: !87, size: 256, elements: !45)
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !88, line: 27, baseType: !10)
!88 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!89 = !DILocation(line: 143, column: 15, scope: !81)
!90 = !DILocation(line: 150, column: 5, scope: !81)
!91 = !DILocalVariable(name: "i", scope: !92, file: !49, line: 152, type: !6)
!92 = distinct !DILexicalBlock(scope: !81, file: !49, line: 152, column: 5)
!93 = !DILocation(line: 152, column: 21, scope: !92)
!94 = !DILocation(line: 152, column: 10, scope: !92)
!95 = !DILocation(line: 152, column: 28, scope: !96)
!96 = distinct !DILexicalBlock(scope: !92, file: !49, line: 152, column: 5)
!97 = !DILocation(line: 152, column: 30, scope: !96)
!98 = !DILocation(line: 152, column: 5, scope: !92)
!99 = !DILocation(line: 153, column: 33, scope: !100)
!100 = distinct !DILexicalBlock(scope: !96, file: !49, line: 152, column: 47)
!101 = !DILocation(line: 153, column: 31, scope: !100)
!102 = !DILocation(line: 153, column: 53, scope: !100)
!103 = !DILocation(line: 153, column: 45, scope: !100)
!104 = !DILocation(line: 153, column: 15, scope: !100)
!105 = !DILocation(line: 154, column: 5, scope: !100)
!106 = !DILocation(line: 152, column: 43, scope: !96)
!107 = !DILocation(line: 152, column: 5, scope: !96)
!108 = distinct !{!108, !98, !109, !110}
!109 = !DILocation(line: 154, column: 5, scope: !92)
!110 = !{!"llvm.loop.mustprogress"}
!111 = !DILocation(line: 156, column: 5, scope: !81)
!112 = !DILocalVariable(name: "i", scope: !113, file: !49, line: 158, type: !6)
!113 = distinct !DILexicalBlock(scope: !81, file: !49, line: 158, column: 5)
!114 = !DILocation(line: 158, column: 21, scope: !113)
!115 = !DILocation(line: 158, column: 10, scope: !113)
!116 = !DILocation(line: 158, column: 28, scope: !117)
!117 = distinct !DILexicalBlock(scope: !113, file: !49, line: 158, column: 5)
!118 = !DILocation(line: 158, column: 30, scope: !117)
!119 = !DILocation(line: 158, column: 5, scope: !113)
!120 = !DILocation(line: 159, column: 30, scope: !121)
!121 = distinct !DILexicalBlock(scope: !117, file: !49, line: 158, column: 47)
!122 = !DILocation(line: 159, column: 28, scope: !121)
!123 = !DILocation(line: 159, column: 15, scope: !121)
!124 = !DILocation(line: 160, column: 5, scope: !121)
!125 = !DILocation(line: 158, column: 43, scope: !117)
!126 = !DILocation(line: 158, column: 5, scope: !117)
!127 = distinct !{!127, !119, !128, !110}
!128 = !DILocation(line: 160, column: 5, scope: !113)
!129 = !DILocation(line: 167, column: 5, scope: !81)
!130 = !DILocation(line: 168, column: 5, scope: !81)
!131 = !DILocation(line: 170, column: 5, scope: !81)
!132 = distinct !DISubprogram(name: "run", scope: !49, file: !49, line: 119, type: !133, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!133 = !DISubroutineType(types: !134)
!134 = !{!5, !5}
!135 = !DILocalVariable(name: "arg", arg: 1, scope: !132, file: !49, line: 119, type: !5)
!136 = !DILocation(line: 119, column: 11, scope: !132)
!137 = !DILocalVariable(name: "tid", scope: !132, file: !49, line: 121, type: !28)
!138 = !DILocation(line: 121, column: 15, scope: !132)
!139 = !DILocation(line: 121, column: 33, scope: !132)
!140 = !DILocation(line: 121, column: 21, scope: !132)
!141 = !DILocalVariable(name: "i", scope: !142, file: !49, line: 125, type: !84)
!142 = distinct !DILexicalBlock(scope: !132, file: !49, line: 125, column: 5)
!143 = !DILocation(line: 125, column: 14, scope: !142)
!144 = !DILocation(line: 125, column: 10, scope: !142)
!145 = !DILocation(line: 125, column: 21, scope: !146)
!146 = distinct !DILexicalBlock(scope: !142, file: !49, line: 125, column: 5)
!147 = !DILocation(line: 125, column: 23, scope: !146)
!148 = !DILocation(line: 125, column: 28, scope: !146)
!149 = !DILocation(line: 125, column: 31, scope: !146)
!150 = !DILocation(line: 0, scope: !146)
!151 = !DILocation(line: 125, column: 5, scope: !142)
!152 = !DILocalVariable(name: "j", scope: !153, file: !49, line: 129, type: !84)
!153 = distinct !DILexicalBlock(scope: !154, file: !49, line: 129, column: 9)
!154 = distinct !DILexicalBlock(scope: !146, file: !49, line: 125, column: 63)
!155 = !DILocation(line: 129, column: 18, scope: !153)
!156 = !DILocation(line: 129, column: 14, scope: !153)
!157 = !DILocation(line: 129, column: 25, scope: !158)
!158 = distinct !DILexicalBlock(scope: !153, file: !49, line: 129, column: 9)
!159 = !DILocation(line: 129, column: 27, scope: !158)
!160 = !DILocation(line: 129, column: 32, scope: !158)
!161 = !DILocation(line: 129, column: 35, scope: !158)
!162 = !DILocation(line: 0, scope: !158)
!163 = !DILocation(line: 129, column: 9, scope: !153)
!164 = !DILocation(line: 130, column: 21, scope: !165)
!165 = distinct !DILexicalBlock(scope: !158, file: !49, line: 129, column: 67)
!166 = !DILocation(line: 130, column: 13, scope: !165)
!167 = !DILocation(line: 131, column: 13, scope: !165)
!168 = !DILocation(line: 132, column: 9, scope: !165)
!169 = !DILocation(line: 129, column: 63, scope: !158)
!170 = !DILocation(line: 129, column: 9, scope: !158)
!171 = distinct !{!171, !163, !172, !110}
!172 = !DILocation(line: 132, column: 9, scope: !153)
!173 = !DILocalVariable(name: "j", scope: !174, file: !49, line: 133, type: !84)
!174 = distinct !DILexicalBlock(scope: !154, file: !49, line: 133, column: 9)
!175 = !DILocation(line: 133, column: 18, scope: !174)
!176 = !DILocation(line: 133, column: 14, scope: !174)
!177 = !DILocation(line: 133, column: 25, scope: !178)
!178 = distinct !DILexicalBlock(scope: !174, file: !49, line: 133, column: 9)
!179 = !DILocation(line: 133, column: 27, scope: !178)
!180 = !DILocation(line: 133, column: 32, scope: !178)
!181 = !DILocation(line: 133, column: 35, scope: !178)
!182 = !DILocation(line: 0, scope: !178)
!183 = !DILocation(line: 133, column: 9, scope: !174)
!184 = !DILocation(line: 134, column: 21, scope: !185)
!185 = distinct !DILexicalBlock(scope: !178, file: !49, line: 133, column: 67)
!186 = !DILocation(line: 134, column: 13, scope: !185)
!187 = !DILocation(line: 135, column: 9, scope: !185)
!188 = !DILocation(line: 133, column: 63, scope: !178)
!189 = !DILocation(line: 133, column: 9, scope: !178)
!190 = distinct !{!190, !183, !191, !110}
!191 = !DILocation(line: 135, column: 9, scope: !174)
!192 = !DILocation(line: 136, column: 5, scope: !154)
!193 = !DILocation(line: 125, column: 59, scope: !146)
!194 = !DILocation(line: 125, column: 5, scope: !146)
!195 = distinct !{!195, !151, !196, !110}
!196 = !DILocation(line: 136, column: 5, scope: !142)
!197 = !DILocation(line: 137, column: 5, scope: !132)
!198 = distinct !DISubprogram(name: "post", scope: !37, file: !37, line: 16, type: !61, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!199 = !DILocation(line: 19, column: 5, scope: !198)
!200 = !DILocation(line: 21, column: 1, scope: !198)
!201 = distinct !DISubprogram(name: "vatomic32_write_rlx", scope: !202, file: !202, line: 241, type: !203, scopeLine: 242, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!202 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!203 = !DISubroutineType(types: !204)
!204 = !{null, !205, !28}
!205 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!206 = !DILocalVariable(name: "a", arg: 1, scope: !201, file: !202, line: 241, type: !205)
!207 = !DILocation(line: 241, column: 34, scope: !201)
!208 = !DILocalVariable(name: "v", arg: 2, scope: !201, file: !202, line: 241, type: !28)
!209 = !DILocation(line: 241, column: 47, scope: !201)
!210 = !DILocation(line: 245, column: 32, scope: !201)
!211 = !DILocation(line: 245, column: 44, scope: !201)
!212 = !DILocation(line: 245, column: 47, scope: !201)
!213 = !DILocation(line: 243, column: 5, scope: !201)
!214 = !{i64 406786}
!215 = !DILocation(line: 247, column: 1, scope: !201)
!216 = distinct !DISubprogram(name: "acquire", scope: !37, file: !37, line: 26, type: !217, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!217 = !DISubroutineType(types: !218)
!218 = !{null, !28}
!219 = !DILocalVariable(name: "tid", arg: 1, scope: !216, file: !37, line: 26, type: !28)
!220 = !DILocation(line: 26, column: 19, scope: !216)
!221 = !DILocation(line: 28, column: 35, scope: !216)
!222 = !DILocation(line: 28, column: 29, scope: !216)
!223 = !DILocation(line: 28, column: 41, scope: !216)
!224 = !DILocation(line: 28, column: 5, scope: !216)
!225 = !DILocation(line: 29, column: 1, scope: !216)
!226 = distinct !DISubprogram(name: "cnalock_acquire", scope: !13, file: !13, line: 73, type: !227, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!227 = !DISubroutineType(types: !228)
!228 = !{null, !229, !11, !28}
!229 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!230 = !DILocalVariable(name: "lock", arg: 1, scope: !226, file: !13, line: 73, type: !229)
!231 = !DILocation(line: 73, column: 28, scope: !226)
!232 = !DILocalVariable(name: "me", arg: 2, scope: !226, file: !13, line: 73, type: !11)
!233 = !DILocation(line: 73, column: 46, scope: !226)
!234 = !DILocalVariable(name: "numa_node", arg: 3, scope: !226, file: !13, line: 73, type: !28)
!235 = !DILocation(line: 73, column: 60, scope: !226)
!236 = !DILocation(line: 75, column: 27, scope: !226)
!237 = !DILocation(line: 75, column: 31, scope: !226)
!238 = !DILocation(line: 75, column: 5, scope: !226)
!239 = !DILocation(line: 76, column: 27, scope: !226)
!240 = !DILocation(line: 76, column: 31, scope: !226)
!241 = !DILocation(line: 76, column: 5, scope: !226)
!242 = !DILocation(line: 77, column: 26, scope: !226)
!243 = !DILocation(line: 77, column: 30, scope: !226)
!244 = !DILocation(line: 77, column: 5, scope: !226)
!245 = !DILocalVariable(name: "tail", scope: !226, file: !13, line: 80, type: !11)
!246 = !DILocation(line: 80, column: 17, scope: !226)
!247 = !DILocation(line: 80, column: 41, scope: !226)
!248 = !DILocation(line: 80, column: 47, scope: !226)
!249 = !DILocation(line: 80, column: 53, scope: !226)
!250 = !DILocation(line: 80, column: 24, scope: !226)
!251 = !DILocation(line: 82, column: 10, scope: !252)
!252 = distinct !DILexicalBlock(scope: !226, file: !13, line: 82, column: 9)
!253 = !DILocation(line: 82, column: 9, scope: !226)
!254 = !DILocation(line: 83, column: 31, scope: !255)
!255 = distinct !DILexicalBlock(scope: !252, file: !13, line: 82, column: 16)
!256 = !DILocation(line: 83, column: 35, scope: !255)
!257 = !DILocation(line: 83, column: 9, scope: !255)
!258 = !DILocation(line: 84, column: 9, scope: !255)
!259 = !DILocation(line: 87, column: 26, scope: !226)
!260 = !DILocation(line: 87, column: 30, scope: !226)
!261 = !DILocation(line: 87, column: 36, scope: !226)
!262 = !DILocation(line: 87, column: 5, scope: !226)
!263 = !DILocation(line: 90, column: 27, scope: !226)
!264 = !DILocation(line: 90, column: 33, scope: !226)
!265 = !DILocation(line: 90, column: 39, scope: !226)
!266 = !DILocation(line: 90, column: 5, scope: !226)
!267 = !DILocation(line: 92, column: 31, scope: !226)
!268 = !DILocation(line: 92, column: 35, scope: !226)
!269 = !DILocation(line: 92, column: 5, scope: !226)
!270 = !DILocation(line: 93, column: 1, scope: !226)
!271 = distinct !DISubprogram(name: "release", scope: !37, file: !37, line: 32, type: !217, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !63)
!272 = !DILocalVariable(name: "tid", arg: 1, scope: !271, file: !37, line: 32, type: !28)
!273 = !DILocation(line: 32, column: 19, scope: !271)
!274 = !DILocation(line: 34, column: 35, scope: !271)
!275 = !DILocation(line: 34, column: 29, scope: !271)
!276 = !DILocation(line: 34, column: 41, scope: !271)
!277 = !DILocation(line: 34, column: 5, scope: !271)
!278 = !DILocation(line: 35, column: 1, scope: !271)
!279 = distinct !DISubprogram(name: "cnalock_release", scope: !13, file: !13, line: 170, type: !227, scopeLine: 171, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!280 = !DILocalVariable(name: "lock", arg: 1, scope: !279, file: !13, line: 170, type: !229)
!281 = !DILocation(line: 170, column: 28, scope: !279)
!282 = !DILocalVariable(name: "me", arg: 2, scope: !279, file: !13, line: 170, type: !11)
!283 = !DILocation(line: 170, column: 46, scope: !279)
!284 = !DILocalVariable(name: "numa_node", arg: 3, scope: !279, file: !13, line: 170, type: !28)
!285 = !DILocation(line: 170, column: 60, scope: !279)
!286 = !DILocalVariable(name: "next", scope: !279, file: !13, line: 172, type: !11)
!287 = !DILocation(line: 172, column: 17, scope: !279)
!288 = !DILocation(line: 172, column: 45, scope: !279)
!289 = !DILocation(line: 172, column: 49, scope: !279)
!290 = !DILocation(line: 172, column: 24, scope: !279)
!291 = !DILocalVariable(name: "spin", scope: !279, file: !13, line: 173, type: !11)
!292 = !DILocation(line: 173, column: 17, scope: !279)
!293 = !DILocation(line: 173, column: 45, scope: !279)
!294 = !DILocation(line: 173, column: 49, scope: !279)
!295 = !DILocation(line: 173, column: 24, scope: !279)
!296 = !DILocation(line: 175, column: 10, scope: !297)
!297 = distinct !DILexicalBlock(scope: !279, file: !13, line: 175, column: 9)
!298 = !DILocation(line: 175, column: 9, scope: !279)
!299 = !DILocation(line: 177, column: 13, scope: !300)
!300 = distinct !DILexicalBlock(scope: !301, file: !13, line: 177, column: 13)
!301 = distinct !DILexicalBlock(scope: !297, file: !13, line: 175, column: 16)
!302 = !DILocation(line: 177, column: 18, scope: !300)
!303 = !DILocation(line: 177, column: 13, scope: !301)
!304 = !DILocation(line: 180, column: 41, scope: !305)
!305 = distinct !DILexicalBlock(scope: !306, file: !13, line: 180, column: 17)
!306 = distinct !DILexicalBlock(scope: !300, file: !13, line: 177, column: 32)
!307 = !DILocation(line: 180, column: 47, scope: !305)
!308 = !DILocation(line: 180, column: 53, scope: !305)
!309 = !DILocation(line: 180, column: 17, scope: !305)
!310 = !DILocation(line: 180, column: 66, scope: !305)
!311 = !DILocation(line: 180, column: 63, scope: !305)
!312 = !DILocation(line: 180, column: 17, scope: !306)
!313 = !DILocation(line: 181, column: 17, scope: !314)
!314 = distinct !DILexicalBlock(scope: !305, file: !13, line: 180, column: 70)
!315 = !DILocation(line: 183, column: 9, scope: !306)
!316 = !DILocalVariable(name: "sec_tail", scope: !317, file: !13, line: 184, type: !11)
!317 = distinct !DILexicalBlock(scope: !300, file: !13, line: 183, column: 16)
!318 = !DILocation(line: 184, column: 25, scope: !317)
!319 = !DILocation(line: 184, column: 36, scope: !317)
!320 = !DILocalVariable(name: "sec_head", scope: !317, file: !13, line: 186, type: !11)
!321 = !DILocation(line: 186, column: 25, scope: !317)
!322 = !DILocation(line: 186, column: 57, scope: !317)
!323 = !DILocation(line: 186, column: 67, scope: !317)
!324 = !DILocation(line: 186, column: 36, scope: !317)
!325 = !DILocation(line: 189, column: 41, scope: !326)
!326 = distinct !DILexicalBlock(scope: !317, file: !13, line: 189, column: 17)
!327 = !DILocation(line: 189, column: 47, scope: !326)
!328 = !DILocation(line: 189, column: 53, scope: !326)
!329 = !DILocation(line: 189, column: 57, scope: !326)
!330 = !DILocation(line: 189, column: 17, scope: !326)
!331 = !DILocation(line: 189, column: 70, scope: !326)
!332 = !DILocation(line: 189, column: 67, scope: !326)
!333 = !DILocation(line: 189, column: 17, scope: !317)
!334 = !DILocation(line: 191, column: 39, scope: !335)
!335 = distinct !DILexicalBlock(scope: !326, file: !13, line: 189, column: 74)
!336 = !DILocation(line: 191, column: 49, scope: !335)
!337 = !DILocation(line: 191, column: 17, scope: !335)
!338 = !DILocation(line: 192, column: 17, scope: !335)
!339 = !DILocation(line: 195, column: 35, scope: !317)
!340 = !DILocation(line: 195, column: 45, scope: !317)
!341 = !DILocation(line: 195, column: 51, scope: !317)
!342 = !DILocation(line: 195, column: 13, scope: !317)
!343 = !DILocation(line: 197, column: 42, scope: !301)
!344 = !DILocation(line: 197, column: 46, scope: !301)
!345 = !DILocation(line: 197, column: 16, scope: !301)
!346 = !DILocation(line: 197, column: 14, scope: !301)
!347 = !DILocation(line: 198, column: 5, scope: !301)
!348 = !DILocalVariable(name: "succ", scope: !279, file: !13, line: 199, type: !11)
!349 = !DILocation(line: 199, column: 17, scope: !279)
!350 = !DILocalVariable(name: "value", scope: !279, file: !13, line: 200, type: !5)
!351 = !DILocation(line: 200, column: 11, scope: !279)
!352 = !DILocalVariable(name: "keep_lock", scope: !279, file: !13, line: 202, type: !28)
!353 = !DILocation(line: 202, column: 15, scope: !279)
!354 = !DILocation(line: 202, column: 27, scope: !279)
!355 = !DILocation(line: 204, column: 9, scope: !356)
!356 = distinct !DILexicalBlock(scope: !279, file: !13, line: 204, column: 9)
!357 = !DILocation(line: 204, column: 9, scope: !279)
!358 = !DILocation(line: 205, column: 40, scope: !359)
!359 = distinct !DILexicalBlock(scope: !356, file: !13, line: 204, column: 20)
!360 = !DILocation(line: 205, column: 44, scope: !359)
!361 = !DILocation(line: 205, column: 16, scope: !359)
!362 = !DILocation(line: 205, column: 14, scope: !359)
!363 = !DILocation(line: 206, column: 37, scope: !359)
!364 = !DILocation(line: 206, column: 41, scope: !359)
!365 = !DILocation(line: 206, column: 16, scope: !359)
!366 = !DILocation(line: 206, column: 14, scope: !359)
!367 = !DILocation(line: 208, column: 5, scope: !359)
!368 = !DILocation(line: 210, column: 9, scope: !369)
!369 = distinct !DILexicalBlock(scope: !279, file: !13, line: 210, column: 9)
!370 = !DILocation(line: 210, column: 19, scope: !369)
!371 = !DILocation(line: 210, column: 22, scope: !369)
!372 = !DILocation(line: 210, column: 9, scope: !279)
!373 = !DILocation(line: 211, column: 17, scope: !374)
!374 = distinct !DILexicalBlock(scope: !369, file: !13, line: 210, column: 28)
!375 = !DILocation(line: 211, column: 15, scope: !374)
!376 = !DILocation(line: 212, column: 5, scope: !374)
!377 = !DILocation(line: 212, column: 16, scope: !378)
!378 = distinct !DILexicalBlock(scope: !369, file: !13, line: 212, column: 16)
!379 = !DILocation(line: 212, column: 21, scope: !378)
!380 = !DILocation(line: 212, column: 16, scope: !369)
!381 = !DILocation(line: 216, column: 37, scope: !382)
!382 = distinct !DILexicalBlock(scope: !378, file: !13, line: 212, column: 40)
!383 = !DILocation(line: 216, column: 43, scope: !382)
!384 = !DILocation(line: 216, column: 49, scope: !382)
!385 = !DILocation(line: 216, column: 16, scope: !382)
!386 = !DILocation(line: 216, column: 14, scope: !382)
!387 = !DILocation(line: 217, column: 5, scope: !382)
!388 = !DILocation(line: 218, column: 16, scope: !389)
!389 = distinct !DILexicalBlock(scope: !378, file: !13, line: 217, column: 12)
!390 = !DILocation(line: 218, column: 14, scope: !389)
!391 = !DILocation(line: 221, column: 27, scope: !279)
!392 = !DILocation(line: 221, column: 33, scope: !279)
!393 = !DILocation(line: 221, column: 39, scope: !279)
!394 = !DILocation(line: 221, column: 5, scope: !279)
!395 = !DILocation(line: 222, column: 1, scope: !279)
!396 = distinct !DISubprogram(name: "vatomicptr_write_rlx", scope: !202, file: !202, line: 325, type: !397, scopeLine: 326, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!397 = !DISubroutineType(types: !398)
!398 = !{null, !399, !5}
!399 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!400 = !DILocalVariable(name: "a", arg: 1, scope: !396, file: !202, line: 325, type: !399)
!401 = !DILocation(line: 325, column: 36, scope: !396)
!402 = !DILocalVariable(name: "v", arg: 2, scope: !396, file: !202, line: 325, type: !5)
!403 = !DILocation(line: 325, column: 45, scope: !396)
!404 = !DILocation(line: 329, column: 32, scope: !396)
!405 = !DILocation(line: 329, column: 44, scope: !396)
!406 = !DILocation(line: 329, column: 47, scope: !396)
!407 = !DILocation(line: 327, column: 5, scope: !396)
!408 = !{i64 409575}
!409 = !DILocation(line: 331, column: 1, scope: !396)
!410 = distinct !DISubprogram(name: "vatomicptr_xchg", scope: !411, file: !411, line: 198, type: !412, scopeLine: 199, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!411 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!412 = !DISubroutineType(types: !413)
!413 = !{!5, !399, !5}
!414 = !DILocalVariable(name: "a", arg: 1, scope: !410, file: !411, line: 198, type: !399)
!415 = !DILocation(line: 198, column: 31, scope: !410)
!416 = !DILocalVariable(name: "v", arg: 2, scope: !410, file: !411, line: 198, type: !5)
!417 = !DILocation(line: 198, column: 40, scope: !410)
!418 = !DILocalVariable(name: "oldv", scope: !410, file: !411, line: 200, type: !5)
!419 = !DILocation(line: 200, column: 11, scope: !410)
!420 = !DILocalVariable(name: "tmp", scope: !410, file: !411, line: 201, type: !28)
!421 = !DILocation(line: 201, column: 15, scope: !410)
!422 = !DILocation(line: 209, column: 22, scope: !410)
!423 = !DILocation(line: 209, column: 34, scope: !410)
!424 = !DILocation(line: 209, column: 37, scope: !410)
!425 = !DILocation(line: 202, column: 5, scope: !410)
!426 = !{i64 463894, i64 463928, i64 463943, i64 463976, i64 464019}
!427 = !DILocation(line: 211, column: 12, scope: !410)
!428 = !DILocation(line: 211, column: 5, scope: !410)
!429 = distinct !DISubprogram(name: "vatomicptr_write_rel", scope: !202, file: !202, line: 311, type: !397, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!430 = !DILocalVariable(name: "a", arg: 1, scope: !429, file: !202, line: 311, type: !399)
!431 = !DILocation(line: 311, column: 36, scope: !429)
!432 = !DILocalVariable(name: "v", arg: 2, scope: !429, file: !202, line: 311, type: !5)
!433 = !DILocation(line: 311, column: 45, scope: !429)
!434 = !DILocation(line: 315, column: 32, scope: !429)
!435 = !DILocation(line: 315, column: 44, scope: !429)
!436 = !DILocation(line: 315, column: 47, scope: !429)
!437 = !DILocation(line: 313, column: 5, scope: !429)
!438 = !{i64 409104}
!439 = !DILocation(line: 317, column: 1, scope: !429)
!440 = distinct !DISubprogram(name: "vatomicptr_await_neq_acq", scope: !202, file: !202, line: 2056, type: !441, scopeLine: 2057, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!441 = !DISubroutineType(types: !442)
!442 = !{!5, !443, !5}
!443 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !444, size: 64)
!444 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!445 = !DILocalVariable(name: "a", arg: 1, scope: !440, file: !202, line: 2056, type: !443)
!446 = !DILocation(line: 2056, column: 46, scope: !440)
!447 = !DILocalVariable(name: "v", arg: 2, scope: !440, file: !202, line: 2056, type: !5)
!448 = !DILocation(line: 2056, column: 55, scope: !440)
!449 = !DILocalVariable(name: "val", scope: !440, file: !202, line: 2058, type: !5)
!450 = !DILocation(line: 2058, column: 11, scope: !440)
!451 = !DILocation(line: 2065, column: 21, scope: !440)
!452 = !DILocation(line: 2065, column: 33, scope: !440)
!453 = !DILocation(line: 2065, column: 36, scope: !440)
!454 = !DILocation(line: 2059, column: 5, scope: !440)
!455 = !{i64 454741, i64 454757, i64 454788, i64 454821}
!456 = !DILocation(line: 2067, column: 12, scope: !440)
!457 = !DILocation(line: 2067, column: 5, scope: !440)
!458 = distinct !DISubprogram(name: "vatomicptr_read_acq", scope: !202, file: !202, line: 181, type: !459, scopeLine: 182, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!459 = !DISubroutineType(types: !460)
!460 = !{!5, !443}
!461 = !DILocalVariable(name: "a", arg: 1, scope: !458, file: !202, line: 181, type: !443)
!462 = !DILocation(line: 181, column: 41, scope: !458)
!463 = !DILocalVariable(name: "val", scope: !458, file: !202, line: 183, type: !5)
!464 = !DILocation(line: 183, column: 11, scope: !458)
!465 = !DILocation(line: 186, column: 32, scope: !458)
!466 = !DILocation(line: 186, column: 35, scope: !458)
!467 = !DILocation(line: 184, column: 5, scope: !458)
!468 = !{i64 404874}
!469 = !DILocation(line: 188, column: 12, scope: !458)
!470 = !DILocation(line: 188, column: 5, scope: !458)
!471 = distinct !DISubprogram(name: "vatomicptr_read_rlx", scope: !202, file: !202, line: 197, type: !459, scopeLine: 198, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!472 = !DILocalVariable(name: "a", arg: 1, scope: !471, file: !202, line: 197, type: !443)
!473 = !DILocation(line: 197, column: 41, scope: !471)
!474 = !DILocalVariable(name: "val", scope: !471, file: !202, line: 199, type: !5)
!475 = !DILocation(line: 199, column: 11, scope: !471)
!476 = !DILocation(line: 202, column: 32, scope: !471)
!477 = !DILocation(line: 202, column: 35, scope: !471)
!478 = !DILocation(line: 200, column: 5, scope: !471)
!479 = !{i64 405374}
!480 = !DILocation(line: 204, column: 12, scope: !471)
!481 = !DILocation(line: 204, column: 5, scope: !471)
!482 = distinct !DISubprogram(name: "vatomicptr_cmpxchg_rel", scope: !411, file: !411, line: 536, type: !483, scopeLine: 537, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!483 = !DISubroutineType(types: !484)
!484 = !{!5, !399, !5, !5}
!485 = !DILocalVariable(name: "a", arg: 1, scope: !482, file: !411, line: 536, type: !399)
!486 = !DILocation(line: 536, column: 38, scope: !482)
!487 = !DILocalVariable(name: "e", arg: 2, scope: !482, file: !411, line: 536, type: !5)
!488 = !DILocation(line: 536, column: 47, scope: !482)
!489 = !DILocalVariable(name: "v", arg: 3, scope: !482, file: !411, line: 536, type: !5)
!490 = !DILocation(line: 536, column: 56, scope: !482)
!491 = !DILocalVariable(name: "oldv", scope: !482, file: !411, line: 538, type: !5)
!492 = !DILocation(line: 538, column: 11, scope: !482)
!493 = !DILocalVariable(name: "tmp", scope: !482, file: !411, line: 539, type: !28)
!494 = !DILocation(line: 539, column: 15, scope: !482)
!495 = !DILocation(line: 550, column: 22, scope: !482)
!496 = !DILocation(line: 550, column: 36, scope: !482)
!497 = !DILocation(line: 550, column: 48, scope: !482)
!498 = !DILocation(line: 550, column: 51, scope: !482)
!499 = !DILocation(line: 540, column: 5, scope: !482)
!500 = !{i64 474232, i64 474266, i64 474281, i64 474313, i64 474347, i64 474367, i64 474410, i64 474439}
!501 = !DILocation(line: 552, column: 12, scope: !482)
!502 = !DILocation(line: 552, column: 5, scope: !482)
!503 = distinct !DISubprogram(name: "vatomicptr_xchg_rlx", scope: !411, file: !411, line: 264, type: !412, scopeLine: 265, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!504 = !DILocalVariable(name: "a", arg: 1, scope: !503, file: !411, line: 264, type: !399)
!505 = !DILocation(line: 264, column: 35, scope: !503)
!506 = !DILocalVariable(name: "v", arg: 2, scope: !503, file: !411, line: 264, type: !5)
!507 = !DILocation(line: 264, column: 44, scope: !503)
!508 = !DILocalVariable(name: "oldv", scope: !503, file: !411, line: 266, type: !5)
!509 = !DILocation(line: 266, column: 11, scope: !503)
!510 = !DILocalVariable(name: "tmp", scope: !503, file: !411, line: 267, type: !28)
!511 = !DILocation(line: 267, column: 15, scope: !503)
!512 = !DILocation(line: 275, column: 22, scope: !503)
!513 = !DILocation(line: 275, column: 34, scope: !503)
!514 = !DILocation(line: 275, column: 37, scope: !503)
!515 = !DILocation(line: 268, column: 5, scope: !503)
!516 = !{i64 465863, i64 465897, i64 465912, i64 465944, i64 465986}
!517 = !DILocation(line: 277, column: 12, scope: !503)
!518 = !DILocation(line: 277, column: 5, scope: !503)
!519 = distinct !DISubprogram(name: "_cnalock_keep_lock_local", scope: !13, file: !13, line: 101, type: !520, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!520 = !DISubroutineType(types: !521)
!521 = !{!28}
!522 = !DILocation(line: 104, column: 12, scope: !519)
!523 = !DILocation(line: 104, column: 5, scope: !519)
!524 = distinct !DISubprogram(name: "_cnalock_find_successor", scope: !13, file: !13, line: 118, type: !525, scopeLine: 119, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!525 = !DISubroutineType(types: !526)
!526 = !{!11, !11, !28}
!527 = !DILocalVariable(name: "me", arg: 1, scope: !524, file: !13, line: 118, type: !11)
!528 = !DILocation(line: 118, column: 37, scope: !524)
!529 = !DILocalVariable(name: "numa_node", arg: 2, scope: !524, file: !13, line: 118, type: !28)
!530 = !DILocation(line: 118, column: 51, scope: !524)
!531 = !DILocalVariable(name: "next", scope: !524, file: !13, line: 120, type: !11)
!532 = !DILocation(line: 120, column: 17, scope: !524)
!533 = !DILocation(line: 120, column: 46, scope: !524)
!534 = !DILocation(line: 120, column: 50, scope: !524)
!535 = !DILocation(line: 120, column: 25, scope: !524)
!536 = !DILocalVariable(name: "my_node", scope: !524, file: !13, line: 121, type: !28)
!537 = !DILocation(line: 121, column: 15, scope: !524)
!538 = !DILocation(line: 121, column: 45, scope: !524)
!539 = !DILocation(line: 121, column: 49, scope: !524)
!540 = !DILocation(line: 121, column: 25, scope: !524)
!541 = !DILocation(line: 123, column: 9, scope: !542)
!542 = distinct !DILexicalBlock(scope: !524, file: !13, line: 123, column: 9)
!543 = !DILocation(line: 123, column: 17, scope: !542)
!544 = !DILocation(line: 123, column: 9, scope: !524)
!545 = !DILocation(line: 124, column: 19, scope: !546)
!546 = distinct !DILexicalBlock(scope: !542, file: !13, line: 123, column: 40)
!547 = !DILocation(line: 124, column: 17, scope: !546)
!548 = !DILocation(line: 125, column: 5, scope: !546)
!549 = !DILocalVariable(name: "sec_head", scope: !524, file: !13, line: 127, type: !11)
!550 = !DILocation(line: 127, column: 17, scope: !524)
!551 = !DILocation(line: 127, column: 28, scope: !524)
!552 = !DILocalVariable(name: "sec_tail", scope: !524, file: !13, line: 128, type: !11)
!553 = !DILocation(line: 128, column: 17, scope: !524)
!554 = !DILocation(line: 128, column: 28, scope: !524)
!555 = !DILocalVariable(name: "cur", scope: !524, file: !13, line: 130, type: !11)
!556 = !DILocation(line: 130, column: 17, scope: !524)
!557 = !DILocation(line: 133, column: 21, scope: !558)
!558 = distinct !DILexicalBlock(scope: !524, file: !13, line: 133, column: 5)
!559 = !DILocation(line: 133, column: 19, scope: !558)
!560 = !DILocation(line: 133, column: 10, scope: !558)
!561 = !DILocation(line: 133, column: 27, scope: !562)
!562 = distinct !DILexicalBlock(scope: !558, file: !13, line: 133, column: 5)
!563 = !DILocation(line: 133, column: 31, scope: !562)
!564 = !DILocation(line: 133, column: 54, scope: !562)
!565 = !DILocation(line: 133, column: 59, scope: !562)
!566 = !DILocation(line: 133, column: 34, scope: !562)
!567 = !DILocation(line: 133, column: 68, scope: !562)
!568 = !DILocation(line: 133, column: 65, scope: !562)
!569 = !DILocation(line: 0, scope: !562)
!570 = !DILocation(line: 133, column: 5, scope: !558)
!571 = !DILocation(line: 134, column: 66, scope: !572)
!572 = distinct !DILexicalBlock(scope: !562, file: !13, line: 134, column: 65)
!573 = !DILocation(line: 134, column: 21, scope: !562)
!574 = !DILocation(line: 134, column: 19, scope: !562)
!575 = !DILocation(line: 134, column: 53, scope: !562)
!576 = !DILocation(line: 134, column: 58, scope: !562)
!577 = !DILocation(line: 134, column: 32, scope: !562)
!578 = !DILocation(line: 134, column: 30, scope: !562)
!579 = !DILocation(line: 133, column: 5, scope: !562)
!580 = distinct !{!580, !570, !581, !110}
!581 = !DILocation(line: 134, column: 66, scope: !558)
!582 = !DILocation(line: 136, column: 10, scope: !583)
!583 = distinct !DILexicalBlock(scope: !524, file: !13, line: 136, column: 9)
!584 = !DILocation(line: 136, column: 9, scope: !524)
!585 = !DILocation(line: 137, column: 9, scope: !586)
!586 = distinct !DILexicalBlock(scope: !583, file: !13, line: 136, column: 15)
!587 = !DILocation(line: 140, column: 9, scope: !588)
!588 = distinct !DILexicalBlock(scope: !524, file: !13, line: 140, column: 9)
!589 = !DILocation(line: 140, column: 16, scope: !588)
!590 = !DILocation(line: 140, column: 13, scope: !588)
!591 = !DILocation(line: 140, column: 9, scope: !524)
!592 = !DILocation(line: 141, column: 16, scope: !593)
!593 = distinct !DILexicalBlock(scope: !588, file: !13, line: 140, column: 22)
!594 = !DILocation(line: 141, column: 9, scope: !593)
!595 = !DILocalVariable(name: "spin", scope: !524, file: !13, line: 144, type: !11)
!596 = !DILocation(line: 144, column: 17, scope: !524)
!597 = !DILocation(line: 144, column: 45, scope: !524)
!598 = !DILocation(line: 144, column: 49, scope: !524)
!599 = !DILocation(line: 144, column: 24, scope: !524)
!600 = !DILocation(line: 146, column: 9, scope: !601)
!601 = distinct !DILexicalBlock(scope: !524, file: !13, line: 146, column: 9)
!602 = !DILocation(line: 146, column: 14, scope: !601)
!603 = !DILocation(line: 146, column: 9, scope: !524)
!604 = !DILocalVariable(name: "origSecHead", scope: !605, file: !13, line: 152, type: !11)
!605 = distinct !DILexicalBlock(scope: !601, file: !13, line: 146, column: 33)
!606 = !DILocation(line: 152, column: 21, scope: !605)
!607 = !DILocation(line: 152, column: 56, scope: !605)
!608 = !DILocation(line: 152, column: 62, scope: !605)
!609 = !DILocation(line: 152, column: 68, scope: !605)
!610 = !DILocation(line: 152, column: 35, scope: !605)
!611 = !DILocation(line: 153, column: 35, scope: !605)
!612 = !DILocation(line: 153, column: 33, scope: !605)
!613 = !DILocation(line: 154, column: 5, scope: !605)
!614 = !DILocation(line: 156, column: 27, scope: !524)
!615 = !DILocation(line: 156, column: 37, scope: !524)
!616 = !DILocation(line: 156, column: 43, scope: !524)
!617 = !DILocation(line: 156, column: 5, scope: !524)
!618 = !DILocation(line: 157, column: 27, scope: !524)
!619 = !DILocation(line: 157, column: 31, scope: !524)
!620 = !DILocation(line: 157, column: 37, scope: !524)
!621 = !DILocation(line: 157, column: 5, scope: !524)
!622 = !DILocation(line: 159, column: 12, scope: !524)
!623 = !DILocation(line: 159, column: 5, scope: !524)
!624 = !DILocation(line: 160, column: 1, scope: !524)
!625 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !202, file: !202, line: 101, type: !626, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !63)
!626 = !DISubroutineType(types: !627)
!627 = !{!28, !628}
!628 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !629, size: 64)
!629 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!630 = !DILocalVariable(name: "a", arg: 1, scope: !625, file: !202, line: 101, type: !628)
!631 = !DILocation(line: 101, column: 39, scope: !625)
!632 = !DILocalVariable(name: "val", scope: !625, file: !202, line: 103, type: !28)
!633 = !DILocation(line: 103, column: 15, scope: !625)
!634 = !DILocation(line: 106, column: 32, scope: !625)
!635 = !DILocation(line: 106, column: 35, scope: !625)
!636 = !DILocation(line: 104, column: 5, scope: !625)
!637 = !{i64 402402}
!638 = !DILocation(line: 108, column: 12, scope: !625)
!639 = !DILocation(line: 108, column: 5, scope: !625)
