; ModuleID = '/home/stefano/huawei/libvsync/thread/verify/mutex_waiters.c'
source_filename = "/home/stefano/huawei/libvsync/thread/verify/mutex_waiters.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.vmutex_t = type { %struct.vatomic32_s, %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !32
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [68 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (2 + 0 + 0)\00", align 1
@lock = dso_local global %struct.vmutex_t zeroinitializer, align 4, !dbg !12
@signal = internal global %struct.vatomic32_s zeroinitializer, align 4, !dbg !35

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !46 {
  ret void, !dbg !50
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !51 {
  ret void, !dbg !52
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !53 {
  ret void, !dbg !54
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !55 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !56
  %2 = add i32 %1, 1, !dbg !56
  store i32 %2, i32* @g_cs_x, align 4, !dbg !56
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !57
  %4 = add i32 %3, 1, !dbg !57
  store i32 %4, i32* @g_cs_y, align 4, !dbg !57
  ret void, !dbg !58
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !59 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !60
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !60
  %3 = icmp eq i32 %1, %2, !dbg !60
  br i1 %3, label %4, label %5, !dbg !63

4:                                                ; preds = %0
  br label %6, !dbg !63

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 112, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !60
  unreachable, !dbg !60

6:                                                ; preds = %4
  %7 = load i32, i32* @g_cs_x, align 4, !dbg !64
  %8 = icmp eq i32 %7, 2, !dbg !64
  br i1 %8, label %9, label %10, !dbg !67

9:                                                ; preds = %6
  br label %11, !dbg !67

10:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 113, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !64
  unreachable, !dbg !64

11:                                               ; preds = %9
  ret void, !dbg !68
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !69 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [2 x i64]* %2, metadata !73, metadata !DIExpression()), !dbg !79
  call void @init(), !dbg !80
  call void @llvm.dbg.declare(metadata i64* %3, metadata !81, metadata !DIExpression()), !dbg !83
  store i64 0, i64* %3, align 8, !dbg !83
  br label %5, !dbg !84

5:                                                ; preds = %14, %0
  %6 = load i64, i64* %3, align 8, !dbg !85
  %7 = icmp ult i64 %6, 2, !dbg !87
  br i1 %7, label %8, label %17, !dbg !88

8:                                                ; preds = %5
  %9 = load i64, i64* %3, align 8, !dbg !89
  %10 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 %9, !dbg !91
  %11 = load i64, i64* %3, align 8, !dbg !92
  %12 = inttoptr i64 %11 to i8*, !dbg !93
  %13 = call i32 @pthread_create(i64* noundef %10, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef %12) #6, !dbg !94
  br label %14, !dbg !95

14:                                               ; preds = %8
  %15 = load i64, i64* %3, align 8, !dbg !96
  %16 = add i64 %15, 1, !dbg !96
  store i64 %16, i64* %3, align 8, !dbg !96
  br label %5, !dbg !97, !llvm.loop !98

17:                                               ; preds = %5
  call void @post(), !dbg !101
  call void @llvm.dbg.declare(metadata i64* %4, metadata !102, metadata !DIExpression()), !dbg !104
  store i64 0, i64* %4, align 8, !dbg !104
  br label %18, !dbg !105

18:                                               ; preds = %26, %17
  %19 = load i64, i64* %4, align 8, !dbg !106
  %20 = icmp ult i64 %19, 2, !dbg !108
  br i1 %20, label %21, label %29, !dbg !109

21:                                               ; preds = %18
  %22 = load i64, i64* %4, align 8, !dbg !110
  %23 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 %22, !dbg !112
  %24 = load i64, i64* %23, align 8, !dbg !112
  %25 = call i32 @pthread_join(i64 noundef %24, i8** noundef null), !dbg !113
  br label %26, !dbg !114

26:                                               ; preds = %21
  %27 = load i64, i64* %4, align 8, !dbg !115
  %28 = add i64 %27, 1, !dbg !115
  store i64 %28, i64* %4, align 8, !dbg !115
  br label %18, !dbg !116, !llvm.loop !117

29:                                               ; preds = %18
  call void @check(), !dbg !119
  call void @fini(), !dbg !120
  ret i32 0, !dbg !121
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !122 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !125, metadata !DIExpression()), !dbg !126
  call void @llvm.dbg.declare(metadata i32* %3, metadata !127, metadata !DIExpression()), !dbg !128
  %7 = load i8*, i8** %2, align 8, !dbg !129
  %8 = ptrtoint i8* %7 to i64, !dbg !130
  %9 = trunc i64 %8 to i32, !dbg !130
  store i32 %9, i32* %3, align 4, !dbg !128
  call void @llvm.dbg.declare(metadata i32* %4, metadata !131, metadata !DIExpression()), !dbg !133
  store i32 0, i32* %4, align 4, !dbg !133
  br label %10, !dbg !134

10:                                               ; preds = %65, %1
  %11 = load i32, i32* %4, align 4, !dbg !135
  %12 = icmp eq i32 %11, 0, !dbg !137
  br i1 %12, label %22, label %13, !dbg !138

13:                                               ; preds = %10
  %14 = load i32, i32* %4, align 4, !dbg !139
  %15 = icmp eq i32 %14, 1, !dbg !139
  br i1 %15, label %16, label %20, !dbg !139

16:                                               ; preds = %13
  %17 = load i32, i32* %3, align 4, !dbg !139
  %18 = add i32 %17, 1, !dbg !139
  %19 = icmp ult i32 %18, 1, !dbg !139
  br label %20

20:                                               ; preds = %16, %13
  %21 = phi i1 [ false, %13 ], [ %19, %16 ], !dbg !140
  br label %22, !dbg !138

22:                                               ; preds = %20, %10
  %23 = phi i1 [ true, %10 ], [ %21, %20 ]
  br i1 %23, label %24, label %68, !dbg !141

24:                                               ; preds = %22
  call void @llvm.dbg.declare(metadata i32* %5, metadata !142, metadata !DIExpression()), !dbg !145
  store i32 0, i32* %5, align 4, !dbg !145
  br label %25, !dbg !146

25:                                               ; preds = %41, %24
  %26 = load i32, i32* %5, align 4, !dbg !147
  %27 = icmp eq i32 %26, 0, !dbg !149
  br i1 %27, label %37, label %28, !dbg !150

28:                                               ; preds = %25
  %29 = load i32, i32* %5, align 4, !dbg !151
  %30 = icmp eq i32 %29, 1, !dbg !151
  br i1 %30, label %31, label %35, !dbg !151

31:                                               ; preds = %28
  %32 = load i32, i32* %3, align 4, !dbg !151
  %33 = add i32 %32, 1, !dbg !151
  %34 = icmp ult i32 %33, 1, !dbg !151
  br label %35

35:                                               ; preds = %31, %28
  %36 = phi i1 [ false, %28 ], [ %34, %31 ], !dbg !152
  br label %37, !dbg !150

37:                                               ; preds = %35, %25
  %38 = phi i1 [ true, %25 ], [ %36, %35 ]
  br i1 %38, label %39, label %44, !dbg !153

39:                                               ; preds = %37
  %40 = load i32, i32* %3, align 4, !dbg !154
  call void @acquire(i32 noundef %40), !dbg !156
  call void @cs(), !dbg !157
  br label %41, !dbg !158

41:                                               ; preds = %39
  %42 = load i32, i32* %5, align 4, !dbg !159
  %43 = add nsw i32 %42, 1, !dbg !159
  store i32 %43, i32* %5, align 4, !dbg !159
  br label %25, !dbg !160, !llvm.loop !161

44:                                               ; preds = %37
  call void @llvm.dbg.declare(metadata i32* %6, metadata !163, metadata !DIExpression()), !dbg !165
  store i32 0, i32* %6, align 4, !dbg !165
  br label %45, !dbg !166

45:                                               ; preds = %61, %44
  %46 = load i32, i32* %6, align 4, !dbg !167
  %47 = icmp eq i32 %46, 0, !dbg !169
  br i1 %47, label %57, label %48, !dbg !170

48:                                               ; preds = %45
  %49 = load i32, i32* %6, align 4, !dbg !171
  %50 = icmp eq i32 %49, 1, !dbg !171
  br i1 %50, label %51, label %55, !dbg !171

51:                                               ; preds = %48
  %52 = load i32, i32* %3, align 4, !dbg !171
  %53 = add i32 %52, 1, !dbg !171
  %54 = icmp ult i32 %53, 1, !dbg !171
  br label %55

55:                                               ; preds = %51, %48
  %56 = phi i1 [ false, %48 ], [ %54, %51 ], !dbg !172
  br label %57, !dbg !170

57:                                               ; preds = %55, %45
  %58 = phi i1 [ true, %45 ], [ %56, %55 ]
  br i1 %58, label %59, label %64, !dbg !173

59:                                               ; preds = %57
  %60 = load i32, i32* %3, align 4, !dbg !174
  call void @release(i32 noundef %60), !dbg !176
  br label %61, !dbg !177

61:                                               ; preds = %59
  %62 = load i32, i32* %6, align 4, !dbg !178
  %63 = add nsw i32 %62, 1, !dbg !178
  store i32 %63, i32* %6, align 4, !dbg !178
  br label %45, !dbg !179, !llvm.loop !180

64:                                               ; preds = %57
  br label %65, !dbg !182

65:                                               ; preds = %64
  %66 = load i32, i32* %4, align 4, !dbg !183
  %67 = add nsw i32 %66, 1, !dbg !183
  store i32 %67, i32* %4, align 4, !dbg !183
  br label %10, !dbg !184, !llvm.loop !185

68:                                               ; preds = %22
  ret i8* null, !dbg !187
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !188 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !191, metadata !DIExpression()), !dbg !192
  br label %3, !dbg !193

3:                                                ; preds = %1
  br label %4, !dbg !194

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !196
  br label %6, !dbg !196

6:                                                ; preds = %4
  br label %7, !dbg !198

7:                                                ; preds = %6
  br label %8, !dbg !196

8:                                                ; preds = %7
  br label %9, !dbg !194

9:                                                ; preds = %8
  call void @vmutex_acquire(%struct.vmutex_t* noundef @lock), !dbg !200
  ret void, !dbg !201
}

; Function Attrs: noinline nounwind uwtable
define internal void @vmutex_acquire(%struct.vmutex_t* noundef %0) #0 !dbg !202 {
  %2 = alloca %struct.vmutex_t*, align 8
  store %struct.vmutex_t* %0, %struct.vmutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vmutex_t** %2, metadata !206, metadata !DIExpression()), !dbg !207
  br label %3, !dbg !208

3:                                                ; preds = %8, %1
  %4 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !209
  %5 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %4, i32 0, i32 0, !dbg !210
  %6 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %5, i32 noundef 0, i32 noundef 1), !dbg !211
  %7 = icmp ne i32 %6, 0, !dbg !212
  br i1 %7, label %8, label %18, !dbg !208

8:                                                ; preds = %3
  %9 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !213
  %10 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %9, i32 0, i32 1, !dbg !215
  call void @vatomic32_inc_rlx(%struct.vatomic32_s* noundef %10), !dbg !216
  %11 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !217
  %12 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %11, i32 0, i32 0, !dbg !218
  %13 = call i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %12, i32 noundef 1, i32 noundef 2), !dbg !219
  %14 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !220
  %15 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %14, i32 0, i32 0, !dbg !221
  call void @vfutex_wait(%struct.vatomic32_s* noundef %15, i32 noundef 2), !dbg !222
  %16 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !223
  %17 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %16, i32 0, i32 1, !dbg !224
  call void @vatomic32_dec_rlx(%struct.vatomic32_s* noundef %17), !dbg !225
  br label %3, !dbg !208, !llvm.loop !226

18:                                               ; preds = %3
  ret void, !dbg !228
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !229 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !230, metadata !DIExpression()), !dbg !231
  br label %3, !dbg !232

3:                                                ; preds = %1
  br label %4, !dbg !233

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !235
  br label %6, !dbg !235

6:                                                ; preds = %4
  br label %7, !dbg !237

7:                                                ; preds = %6
  br label %8, !dbg !235

8:                                                ; preds = %7
  br label %9, !dbg !233

9:                                                ; preds = %8
  call void @vmutex_release(%struct.vmutex_t* noundef @lock), !dbg !239
  ret void, !dbg !240
}

; Function Attrs: noinline nounwind uwtable
define internal void @vmutex_release(%struct.vmutex_t* noundef %0) #0 !dbg !241 {
  %2 = alloca %struct.vmutex_t*, align 8
  %3 = alloca i32, align 4
  store %struct.vmutex_t* %0, %struct.vmutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vmutex_t** %2, metadata !242, metadata !DIExpression()), !dbg !243
  call void @llvm.dbg.declare(metadata i32* %3, metadata !244, metadata !DIExpression()), !dbg !245
  %4 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !246
  %5 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %4, i32 0, i32 0, !dbg !247
  %6 = call i32 @vatomic32_xchg_rel(%struct.vatomic32_s* noundef %5, i32 noundef 0), !dbg !248
  store i32 %6, i32* %3, align 4, !dbg !245
  %7 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !249
  %8 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %7, i32 0, i32 1, !dbg !251
  %9 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %8), !dbg !252
  %10 = icmp ugt i32 %9, 0, !dbg !253
  br i1 %10, label %14, label %11, !dbg !254

11:                                               ; preds = %1
  %12 = load i32, i32* %3, align 4, !dbg !255
  %13 = icmp ne i32 %12, 1, !dbg !256
  br i1 %13, label %14, label %17, !dbg !257

14:                                               ; preds = %11, %1
  %15 = load %struct.vmutex_t*, %struct.vmutex_t** %2, align 8, !dbg !258
  %16 = getelementptr inbounds %struct.vmutex_t, %struct.vmutex_t* %15, i32 0, i32 0, !dbg !260
  call void @vfutex_wake(%struct.vatomic32_s* noundef %16, i32 noundef 1), !dbg !261
  br label %17, !dbg !262

17:                                               ; preds = %14, %11
  ret void, !dbg !263
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !264 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !269, metadata !DIExpression()), !dbg !270
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !271, metadata !DIExpression()), !dbg !272
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !273, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.declare(metadata i32* %7, metadata !275, metadata !DIExpression()), !dbg !276
  call void @llvm.dbg.declare(metadata i32* %8, metadata !277, metadata !DIExpression()), !dbg !278
  %9 = load i32, i32* %6, align 4, !dbg !279
  %10 = load i32, i32* %5, align 4, !dbg !280
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !281
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !282
  %13 = load i32, i32* %12, align 4, !dbg !282
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldaxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !283, !srcloc !284
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !283
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !283
  store i32 %15, i32* %7, align 4, !dbg !283
  store i32 %16, i32* %8, align 4, !dbg !283
  %17 = load i32, i32* %7, align 4, !dbg !285
  ret i32 %17, !dbg !286
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_inc_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !287 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !291, metadata !DIExpression()), !dbg !292
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !293
  %4 = call i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %3), !dbg !294
  ret void, !dbg !295
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !296 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !297, metadata !DIExpression()), !dbg !298
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !299, metadata !DIExpression()), !dbg !300
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !301, metadata !DIExpression()), !dbg !302
  call void @llvm.dbg.declare(metadata i32* %7, metadata !303, metadata !DIExpression()), !dbg !304
  call void @llvm.dbg.declare(metadata i32* %8, metadata !305, metadata !DIExpression()), !dbg !306
  %9 = load i32, i32* %6, align 4, !dbg !307
  %10 = load i32, i32* %5, align 4, !dbg !308
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !309
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !310
  %13 = load i32, i32* %12, align 4, !dbg !310
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !311, !srcloc !312
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !311
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !311
  store i32 %15, i32* %7, align 4, !dbg !311
  store i32 %16, i32* %8, align 4, !dbg !311
  %17 = load i32, i32* %7, align 4, !dbg !313
  ret i32 %17, !dbg !314
}

; Function Attrs: noinline nounwind uwtable
define internal void @vfutex_wait(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !315 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !318, metadata !DIExpression()), !dbg !319
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !320, metadata !DIExpression()), !dbg !321
  call void @llvm.dbg.declare(metadata i32* %5, metadata !322, metadata !DIExpression()), !dbg !323
  %6 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef @signal), !dbg !324
  store i32 %6, i32* %5, align 4, !dbg !323
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !325
  %8 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %7), !dbg !327
  %9 = load i32, i32* %4, align 4, !dbg !328
  %10 = icmp ne i32 %8, %9, !dbg !329
  br i1 %10, label %11, label %12, !dbg !330

11:                                               ; preds = %2
  br label %15, !dbg !331

12:                                               ; preds = %2
  %13 = load i32, i32* %5, align 4, !dbg !332
  %14 = call i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef @signal, i32 noundef %13), !dbg !333
  br label %15, !dbg !334

15:                                               ; preds = %12, %11
  ret void, !dbg !334
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_dec_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !335 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !336, metadata !DIExpression()), !dbg !337
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !338
  %4 = call i32 @vatomic32_get_dec_rlx(%struct.vatomic32_s* noundef %3), !dbg !339
  ret void, !dbg !340
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !341 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !344, metadata !DIExpression()), !dbg !345
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !346
  %4 = call i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !347
  ret i32 %4, !dbg !348
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !349 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !352, metadata !DIExpression()), !dbg !353
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !354, metadata !DIExpression()), !dbg !355
  call void @llvm.dbg.declare(metadata i32* %5, metadata !356, metadata !DIExpression()), !dbg !357
  call void @llvm.dbg.declare(metadata i32* %6, metadata !358, metadata !DIExpression()), !dbg !359
  call void @llvm.dbg.declare(metadata i32* %7, metadata !360, metadata !DIExpression()), !dbg !361
  %8 = load i32, i32* %4, align 4, !dbg !362
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !363
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !364
  %11 = load i32, i32* %10, align 4, !dbg !364
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #6, !dbg !362, !srcloc !365
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !362
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !362
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !362
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !362
  store i32 %13, i32* %5, align 4, !dbg !362
  store i32 %14, i32* %7, align 4, !dbg !362
  store i32 %15, i32* %6, align 4, !dbg !362
  store i32 %16, i32* %4, align 4, !dbg !362
  %17 = load i32, i32* %5, align 4, !dbg !366
  ret i32 %17, !dbg !367
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !368 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !374, metadata !DIExpression()), !dbg !375
  call void @llvm.dbg.declare(metadata i32* %3, metadata !376, metadata !DIExpression()), !dbg !377
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !378
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !379
  %6 = load i32, i32* %5, align 4, !dbg !379
  %7 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !380, !srcloc !381
  store i32 %7, i32* %3, align 4, !dbg !380
  %8 = load i32, i32* %3, align 4, !dbg !382
  ret i32 %8, !dbg !383
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !384 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !385, metadata !DIExpression()), !dbg !386
  call void @llvm.dbg.declare(metadata i32* %3, metadata !387, metadata !DIExpression()), !dbg !388
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !389
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !390
  %6 = load i32, i32* %5, align 4, !dbg !390
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !391, !srcloc !392
  store i32 %7, i32* %3, align 4, !dbg !391
  %8 = load i32, i32* %3, align 4, !dbg !393
  ret i32 %8, !dbg !394
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !395 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !398, metadata !DIExpression()), !dbg !399
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !400, metadata !DIExpression()), !dbg !401
  call void @llvm.dbg.declare(metadata i32* %5, metadata !402, metadata !DIExpression()), !dbg !403
  %6 = load i32, i32* %4, align 4, !dbg !404
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !405
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !406
  %9 = load i32, i32* %8, align 4, !dbg !406
  %10 = call i32 asm sideeffect "1:\0Aldr ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.eq 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !407, !srcloc !408
  store i32 %10, i32* %5, align 4, !dbg !407
  %11 = load i32, i32* %5, align 4, !dbg !409
  ret i32 %11, !dbg !410
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_dec_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !411 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !412, metadata !DIExpression()), !dbg !413
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !414
  %4 = call i32 @vatomic32_get_sub_rlx(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !415
  ret i32 %4, !dbg !416
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_sub_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !417 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !418, metadata !DIExpression()), !dbg !419
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !420, metadata !DIExpression()), !dbg !421
  call void @llvm.dbg.declare(metadata i32* %5, metadata !422, metadata !DIExpression()), !dbg !423
  call void @llvm.dbg.declare(metadata i32* %6, metadata !424, metadata !DIExpression()), !dbg !425
  call void @llvm.dbg.declare(metadata i32* %7, metadata !426, metadata !DIExpression()), !dbg !427
  %8 = load i32, i32* %4, align 4, !dbg !428
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !429
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !430
  %11 = load i32, i32* %10, align 4, !dbg !430
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Asub ${1:w}, ${0:w}, ${3:w}\0Astxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #6, !dbg !428, !srcloc !431
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !428
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !428
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !428
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !428
  store i32 %13, i32* %5, align 4, !dbg !428
  store i32 %14, i32* %7, align 4, !dbg !428
  store i32 %15, i32* %6, align 4, !dbg !428
  store i32 %16, i32* %4, align 4, !dbg !428
  %17 = load i32, i32* %5, align 4, !dbg !432
  ret i32 %17, !dbg !433
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_xchg_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !434 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !435, metadata !DIExpression()), !dbg !436
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !437, metadata !DIExpression()), !dbg !438
  call void @llvm.dbg.declare(metadata i32* %5, metadata !439, metadata !DIExpression()), !dbg !440
  call void @llvm.dbg.declare(metadata i32* %6, metadata !441, metadata !DIExpression()), !dbg !442
  %7 = load i32, i32* %4, align 4, !dbg !443
  %8 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !444
  %9 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %8, i32 0, i32 0, !dbg !445
  %10 = load i32, i32* %9, align 4, !dbg !445
  %11 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $3\0A1:\0Aldxr ${0:w}, $3\0Astlxr  ${1:w}, ${2:w}, $3\0Acbnz ${1:w}, 1b\0A", "=&r,=&r,r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %7, i32 %10) #6, !dbg !446, !srcloc !447
  %12 = extractvalue { i32, i32 } %11, 0, !dbg !446
  %13 = extractvalue { i32, i32 } %11, 1, !dbg !446
  store i32 %12, i32* %5, align 4, !dbg !446
  store i32 %13, i32* %6, align 4, !dbg !446
  %14 = load i32, i32* %5, align 4, !dbg !448
  ret i32 %14, !dbg !449
}

; Function Attrs: noinline nounwind uwtable
define internal void @vfutex_wake(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !450 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !451, metadata !DIExpression()), !dbg !452
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !453, metadata !DIExpression()), !dbg !454
  call void @vatomic32_inc_rel(%struct.vatomic32_s* noundef @signal), !dbg !455
  ret void, !dbg !456
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !457 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !458, metadata !DIExpression()), !dbg !459
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !460
  %4 = call i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %3), !dbg !461
  ret void, !dbg !462
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !463 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !464, metadata !DIExpression()), !dbg !465
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !466
  %4 = call i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !467
  ret i32 %4, !dbg !468
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !469 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !470, metadata !DIExpression()), !dbg !471
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !472, metadata !DIExpression()), !dbg !473
  call void @llvm.dbg.declare(metadata i32* %5, metadata !474, metadata !DIExpression()), !dbg !475
  call void @llvm.dbg.declare(metadata i32* %6, metadata !476, metadata !DIExpression()), !dbg !477
  call void @llvm.dbg.declare(metadata i32* %7, metadata !478, metadata !DIExpression()), !dbg !479
  %8 = load i32, i32* %4, align 4, !dbg !480
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !481
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !482
  %11 = load i32, i32* %10, align 4, !dbg !482
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astlxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #6, !dbg !480, !srcloc !483
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !480
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !480
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !480
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !480
  store i32 %13, i32* %5, align 4, !dbg !480
  store i32 %14, i32* %7, align 4, !dbg !480
  store i32 %15, i32* %6, align 4, !dbg !480
  store i32 %16, i32* %4, align 4, !dbg !480
  %17 = load i32, i32* %5, align 4, !dbg !484
  ret i32 %17, !dbg !485
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!38, !39, !40, !41, !42, !43, !44}
!llvm.ident = !{!45}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !34, line: 100, type: !25, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !11, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/thread/verify/mutex_waiters.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "d4d30cec90775f930892c3de5f1cf4e1")
!4 = !{!5, !6}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 37, baseType: !8)
!7 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !9, line: 90, baseType: !10)
!9 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = !{!12, !0, !32, !35}
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !14, line: 10, type: !15, isLocal: false, isDefinition: true)
!14 = !DIFile(filename: "thread/verify/mutex_waiters.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "d4d30cec90775f930892c3de5f1cf4e1")
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "vmutex_t", file: !16, line: 15, baseType: !17)
!16 = !DIFile(filename: "thread/include/vsync/thread/mutex/waiters.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "3fb8db2a4148cba26118d5aa0477d422")
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !16, line: 12, size: 64, elements: !18)
!18 = !{!19, !31}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !17, file: !16, line: 13, baseType: !20, size: 32, align: 32)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !21, line: 34, baseType: !22)
!21 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!22 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !21, line: 32, size: 32, align: 32, elements: !23)
!23 = !{!24}
!24 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !22, file: !21, line: 33, baseType: !25, size: 32)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !7, line: 35, baseType: !26)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !27, line: 26, baseType: !28)
!27 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !29, line: 42, baseType: !30)
!29 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!30 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "waiters", scope: !17, file: !16, line: 14, baseType: !20, size: 32, align: 32, offset: 32)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !34, line: 101, type: !25, isLocal: true, isDefinition: true)
!34 = !DIFile(filename: "utils/include/test/boilerplate/lock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4187ade4a536ecfd1f9ed3ab727ca965")
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "signal", scope: !2, file: !37, line: 22, type: !20, isLocal: true, isDefinition: true)
!37 = !DIFile(filename: "thread/include/vsync/thread/internal/futex.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "dede791c10be6385ed442bbae7c7e9b0")
!38 = !{i32 7, !"Dwarf Version", i32 5}
!39 = !{i32 2, !"Debug Info Version", i32 3}
!40 = !{i32 1, !"wchar_size", i32 4}
!41 = !{i32 7, !"PIC Level", i32 2}
!42 = !{i32 7, !"PIE Level", i32 2}
!43 = !{i32 7, !"uwtable", i32 1}
!44 = !{i32 7, !"frame-pointer", i32 2}
!45 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!46 = distinct !DISubprogram(name: "init", scope: !34, file: !34, line: 68, type: !47, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!47 = !DISubroutineType(types: !48)
!48 = !{null}
!49 = !{}
!50 = !DILocation(line: 70, column: 1, scope: !46)
!51 = distinct !DISubprogram(name: "post", scope: !34, file: !34, line: 77, type: !47, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!52 = !DILocation(line: 79, column: 1, scope: !51)
!53 = distinct !DISubprogram(name: "fini", scope: !34, file: !34, line: 86, type: !47, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!54 = !DILocation(line: 88, column: 1, scope: !53)
!55 = distinct !DISubprogram(name: "cs", scope: !34, file: !34, line: 104, type: !47, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!56 = !DILocation(line: 106, column: 11, scope: !55)
!57 = !DILocation(line: 107, column: 11, scope: !55)
!58 = !DILocation(line: 108, column: 1, scope: !55)
!59 = distinct !DISubprogram(name: "check", scope: !34, file: !34, line: 110, type: !47, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!60 = !DILocation(line: 112, column: 5, scope: !61)
!61 = distinct !DILexicalBlock(scope: !62, file: !34, line: 112, column: 5)
!62 = distinct !DILexicalBlock(scope: !59, file: !34, line: 112, column: 5)
!63 = !DILocation(line: 112, column: 5, scope: !62)
!64 = !DILocation(line: 113, column: 5, scope: !65)
!65 = distinct !DILexicalBlock(scope: !66, file: !34, line: 113, column: 5)
!66 = distinct !DILexicalBlock(scope: !59, file: !34, line: 113, column: 5)
!67 = !DILocation(line: 113, column: 5, scope: !66)
!68 = !DILocation(line: 114, column: 1, scope: !59)
!69 = distinct !DISubprogram(name: "main", scope: !34, file: !34, line: 141, type: !70, scopeLine: 142, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!70 = !DISubroutineType(types: !71)
!71 = !{!72}
!72 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!73 = !DILocalVariable(name: "t", scope: !69, file: !34, line: 143, type: !74)
!74 = !DICompositeType(tag: DW_TAG_array_type, baseType: !75, size: 128, elements: !77)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !76, line: 27, baseType: !10)
!76 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!77 = !{!78}
!78 = !DISubrange(count: 2)
!79 = !DILocation(line: 143, column: 15, scope: !69)
!80 = !DILocation(line: 150, column: 5, scope: !69)
!81 = !DILocalVariable(name: "i", scope: !82, file: !34, line: 152, type: !6)
!82 = distinct !DILexicalBlock(scope: !69, file: !34, line: 152, column: 5)
!83 = !DILocation(line: 152, column: 21, scope: !82)
!84 = !DILocation(line: 152, column: 10, scope: !82)
!85 = !DILocation(line: 152, column: 28, scope: !86)
!86 = distinct !DILexicalBlock(scope: !82, file: !34, line: 152, column: 5)
!87 = !DILocation(line: 152, column: 30, scope: !86)
!88 = !DILocation(line: 152, column: 5, scope: !82)
!89 = !DILocation(line: 153, column: 33, scope: !90)
!90 = distinct !DILexicalBlock(scope: !86, file: !34, line: 152, column: 47)
!91 = !DILocation(line: 153, column: 31, scope: !90)
!92 = !DILocation(line: 153, column: 53, scope: !90)
!93 = !DILocation(line: 153, column: 45, scope: !90)
!94 = !DILocation(line: 153, column: 15, scope: !90)
!95 = !DILocation(line: 154, column: 5, scope: !90)
!96 = !DILocation(line: 152, column: 43, scope: !86)
!97 = !DILocation(line: 152, column: 5, scope: !86)
!98 = distinct !{!98, !88, !99, !100}
!99 = !DILocation(line: 154, column: 5, scope: !82)
!100 = !{!"llvm.loop.mustprogress"}
!101 = !DILocation(line: 156, column: 5, scope: !69)
!102 = !DILocalVariable(name: "i", scope: !103, file: !34, line: 158, type: !6)
!103 = distinct !DILexicalBlock(scope: !69, file: !34, line: 158, column: 5)
!104 = !DILocation(line: 158, column: 21, scope: !103)
!105 = !DILocation(line: 158, column: 10, scope: !103)
!106 = !DILocation(line: 158, column: 28, scope: !107)
!107 = distinct !DILexicalBlock(scope: !103, file: !34, line: 158, column: 5)
!108 = !DILocation(line: 158, column: 30, scope: !107)
!109 = !DILocation(line: 158, column: 5, scope: !103)
!110 = !DILocation(line: 159, column: 30, scope: !111)
!111 = distinct !DILexicalBlock(scope: !107, file: !34, line: 158, column: 47)
!112 = !DILocation(line: 159, column: 28, scope: !111)
!113 = !DILocation(line: 159, column: 15, scope: !111)
!114 = !DILocation(line: 160, column: 5, scope: !111)
!115 = !DILocation(line: 158, column: 43, scope: !107)
!116 = !DILocation(line: 158, column: 5, scope: !107)
!117 = distinct !{!117, !109, !118, !100}
!118 = !DILocation(line: 160, column: 5, scope: !103)
!119 = !DILocation(line: 167, column: 5, scope: !69)
!120 = !DILocation(line: 168, column: 5, scope: !69)
!121 = !DILocation(line: 170, column: 5, scope: !69)
!122 = distinct !DISubprogram(name: "run", scope: !34, file: !34, line: 119, type: !123, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!123 = !DISubroutineType(types: !124)
!124 = !{!5, !5}
!125 = !DILocalVariable(name: "arg", arg: 1, scope: !122, file: !34, line: 119, type: !5)
!126 = !DILocation(line: 119, column: 11, scope: !122)
!127 = !DILocalVariable(name: "tid", scope: !122, file: !34, line: 121, type: !25)
!128 = !DILocation(line: 121, column: 15, scope: !122)
!129 = !DILocation(line: 121, column: 33, scope: !122)
!130 = !DILocation(line: 121, column: 21, scope: !122)
!131 = !DILocalVariable(name: "i", scope: !132, file: !34, line: 125, type: !72)
!132 = distinct !DILexicalBlock(scope: !122, file: !34, line: 125, column: 5)
!133 = !DILocation(line: 125, column: 14, scope: !132)
!134 = !DILocation(line: 125, column: 10, scope: !132)
!135 = !DILocation(line: 125, column: 21, scope: !136)
!136 = distinct !DILexicalBlock(scope: !132, file: !34, line: 125, column: 5)
!137 = !DILocation(line: 125, column: 23, scope: !136)
!138 = !DILocation(line: 125, column: 28, scope: !136)
!139 = !DILocation(line: 125, column: 31, scope: !136)
!140 = !DILocation(line: 0, scope: !136)
!141 = !DILocation(line: 125, column: 5, scope: !132)
!142 = !DILocalVariable(name: "j", scope: !143, file: !34, line: 129, type: !72)
!143 = distinct !DILexicalBlock(scope: !144, file: !34, line: 129, column: 9)
!144 = distinct !DILexicalBlock(scope: !136, file: !34, line: 125, column: 63)
!145 = !DILocation(line: 129, column: 18, scope: !143)
!146 = !DILocation(line: 129, column: 14, scope: !143)
!147 = !DILocation(line: 129, column: 25, scope: !148)
!148 = distinct !DILexicalBlock(scope: !143, file: !34, line: 129, column: 9)
!149 = !DILocation(line: 129, column: 27, scope: !148)
!150 = !DILocation(line: 129, column: 32, scope: !148)
!151 = !DILocation(line: 129, column: 35, scope: !148)
!152 = !DILocation(line: 0, scope: !148)
!153 = !DILocation(line: 129, column: 9, scope: !143)
!154 = !DILocation(line: 130, column: 21, scope: !155)
!155 = distinct !DILexicalBlock(scope: !148, file: !34, line: 129, column: 67)
!156 = !DILocation(line: 130, column: 13, scope: !155)
!157 = !DILocation(line: 131, column: 13, scope: !155)
!158 = !DILocation(line: 132, column: 9, scope: !155)
!159 = !DILocation(line: 129, column: 63, scope: !148)
!160 = !DILocation(line: 129, column: 9, scope: !148)
!161 = distinct !{!161, !153, !162, !100}
!162 = !DILocation(line: 132, column: 9, scope: !143)
!163 = !DILocalVariable(name: "j", scope: !164, file: !34, line: 133, type: !72)
!164 = distinct !DILexicalBlock(scope: !144, file: !34, line: 133, column: 9)
!165 = !DILocation(line: 133, column: 18, scope: !164)
!166 = !DILocation(line: 133, column: 14, scope: !164)
!167 = !DILocation(line: 133, column: 25, scope: !168)
!168 = distinct !DILexicalBlock(scope: !164, file: !34, line: 133, column: 9)
!169 = !DILocation(line: 133, column: 27, scope: !168)
!170 = !DILocation(line: 133, column: 32, scope: !168)
!171 = !DILocation(line: 133, column: 35, scope: !168)
!172 = !DILocation(line: 0, scope: !168)
!173 = !DILocation(line: 133, column: 9, scope: !164)
!174 = !DILocation(line: 134, column: 21, scope: !175)
!175 = distinct !DILexicalBlock(scope: !168, file: !34, line: 133, column: 67)
!176 = !DILocation(line: 134, column: 13, scope: !175)
!177 = !DILocation(line: 135, column: 9, scope: !175)
!178 = !DILocation(line: 133, column: 63, scope: !168)
!179 = !DILocation(line: 133, column: 9, scope: !168)
!180 = distinct !{!180, !173, !181, !100}
!181 = !DILocation(line: 135, column: 9, scope: !164)
!182 = !DILocation(line: 136, column: 5, scope: !144)
!183 = !DILocation(line: 125, column: 59, scope: !136)
!184 = !DILocation(line: 125, column: 5, scope: !136)
!185 = distinct !{!185, !141, !186, !100}
!186 = !DILocation(line: 136, column: 5, scope: !132)
!187 = !DILocation(line: 137, column: 5, scope: !122)
!188 = distinct !DISubprogram(name: "acquire", scope: !14, file: !14, line: 13, type: !189, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!189 = !DISubroutineType(types: !190)
!190 = !{null, !25}
!191 = !DILocalVariable(name: "tid", arg: 1, scope: !188, file: !14, line: 13, type: !25)
!192 = !DILocation(line: 13, column: 19, scope: !188)
!193 = !DILocation(line: 15, column: 5, scope: !188)
!194 = !DILocation(line: 15, column: 5, scope: !195)
!195 = distinct !DILexicalBlock(scope: !188, file: !14, line: 15, column: 5)
!196 = !DILocation(line: 15, column: 5, scope: !197)
!197 = distinct !DILexicalBlock(scope: !195, file: !14, line: 15, column: 5)
!198 = !DILocation(line: 15, column: 5, scope: !199)
!199 = distinct !DILexicalBlock(scope: !197, file: !14, line: 15, column: 5)
!200 = !DILocation(line: 16, column: 5, scope: !188)
!201 = !DILocation(line: 17, column: 1, scope: !188)
!202 = distinct !DISubprogram(name: "vmutex_acquire", scope: !16, file: !16, line: 18, type: !203, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!203 = !DISubroutineType(types: !204)
!204 = !{null, !205}
!205 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!206 = !DILocalVariable(name: "m", arg: 1, scope: !202, file: !16, line: 18, type: !205)
!207 = !DILocation(line: 18, column: 26, scope: !202)
!208 = !DILocation(line: 20, column: 5, scope: !202)
!209 = !DILocation(line: 20, column: 35, scope: !202)
!210 = !DILocation(line: 20, column: 38, scope: !202)
!211 = !DILocation(line: 20, column: 12, scope: !202)
!212 = !DILocation(line: 20, column: 50, scope: !202)
!213 = !DILocation(line: 21, column: 28, scope: !214)
!214 = distinct !DILexicalBlock(scope: !202, file: !16, line: 20, column: 56)
!215 = !DILocation(line: 21, column: 31, scope: !214)
!216 = !DILocation(line: 21, column: 9, scope: !214)
!217 = !DILocation(line: 22, column: 32, scope: !214)
!218 = !DILocation(line: 22, column: 35, scope: !214)
!219 = !DILocation(line: 22, column: 9, scope: !214)
!220 = !DILocation(line: 23, column: 22, scope: !214)
!221 = !DILocation(line: 23, column: 25, scope: !214)
!222 = !DILocation(line: 23, column: 9, scope: !214)
!223 = !DILocation(line: 24, column: 28, scope: !214)
!224 = !DILocation(line: 24, column: 31, scope: !214)
!225 = !DILocation(line: 24, column: 9, scope: !214)
!226 = distinct !{!226, !208, !227, !100}
!227 = !DILocation(line: 25, column: 5, scope: !202)
!228 = !DILocation(line: 26, column: 1, scope: !202)
!229 = distinct !DISubprogram(name: "release", scope: !14, file: !14, line: 20, type: !189, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !49)
!230 = !DILocalVariable(name: "tid", arg: 1, scope: !229, file: !14, line: 20, type: !25)
!231 = !DILocation(line: 20, column: 19, scope: !229)
!232 = !DILocation(line: 22, column: 5, scope: !229)
!233 = !DILocation(line: 22, column: 5, scope: !234)
!234 = distinct !DILexicalBlock(scope: !229, file: !14, line: 22, column: 5)
!235 = !DILocation(line: 22, column: 5, scope: !236)
!236 = distinct !DILexicalBlock(scope: !234, file: !14, line: 22, column: 5)
!237 = !DILocation(line: 22, column: 5, scope: !238)
!238 = distinct !DILexicalBlock(scope: !236, file: !14, line: 22, column: 5)
!239 = !DILocation(line: 23, column: 5, scope: !229)
!240 = !DILocation(line: 24, column: 1, scope: !229)
!241 = distinct !DISubprogram(name: "vmutex_release", scope: !16, file: !16, line: 29, type: !203, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!242 = !DILocalVariable(name: "m", arg: 1, scope: !241, file: !16, line: 29, type: !205)
!243 = !DILocation(line: 29, column: 26, scope: !241)
!244 = !DILocalVariable(name: "old", scope: !241, file: !16, line: 37, type: !25)
!245 = !DILocation(line: 37, column: 15, scope: !241)
!246 = !DILocation(line: 37, column: 41, scope: !241)
!247 = !DILocation(line: 37, column: 44, scope: !241)
!248 = !DILocation(line: 37, column: 21, scope: !241)
!249 = !DILocation(line: 39, column: 29, scope: !250)
!250 = distinct !DILexicalBlock(scope: !241, file: !16, line: 39, column: 9)
!251 = !DILocation(line: 39, column: 32, scope: !250)
!252 = !DILocation(line: 39, column: 9, scope: !250)
!253 = !DILocation(line: 39, column: 41, scope: !250)
!254 = !DILocation(line: 39, column: 45, scope: !250)
!255 = !DILocation(line: 39, column: 48, scope: !250)
!256 = !DILocation(line: 39, column: 52, scope: !250)
!257 = !DILocation(line: 39, column: 9, scope: !241)
!258 = !DILocation(line: 40, column: 22, scope: !259)
!259 = distinct !DILexicalBlock(scope: !250, file: !16, line: 39, column: 58)
!260 = !DILocation(line: 40, column: 25, scope: !259)
!261 = !DILocation(line: 40, column: 9, scope: !259)
!262 = !DILocation(line: 41, column: 5, scope: !259)
!263 = !DILocation(line: 42, column: 1, scope: !241)
!264 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !265, file: !265, line: 311, type: !266, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!265 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!266 = !DISubroutineType(types: !267)
!267 = !{!25, !268, !25, !25}
!268 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!269 = !DILocalVariable(name: "a", arg: 1, scope: !264, file: !265, line: 311, type: !268)
!270 = !DILocation(line: 311, column: 36, scope: !264)
!271 = !DILocalVariable(name: "e", arg: 2, scope: !264, file: !265, line: 311, type: !25)
!272 = !DILocation(line: 311, column: 49, scope: !264)
!273 = !DILocalVariable(name: "v", arg: 3, scope: !264, file: !265, line: 311, type: !25)
!274 = !DILocation(line: 311, column: 62, scope: !264)
!275 = !DILocalVariable(name: "oldv", scope: !264, file: !265, line: 313, type: !25)
!276 = !DILocation(line: 313, column: 15, scope: !264)
!277 = !DILocalVariable(name: "tmp", scope: !264, file: !265, line: 314, type: !25)
!278 = !DILocation(line: 314, column: 15, scope: !264)
!279 = !DILocation(line: 325, column: 22, scope: !264)
!280 = !DILocation(line: 325, column: 36, scope: !264)
!281 = !DILocation(line: 325, column: 48, scope: !264)
!282 = !DILocation(line: 325, column: 51, scope: !264)
!283 = !DILocation(line: 315, column: 5, scope: !264)
!284 = !{i64 463808, i64 463842, i64 463857, i64 463890, i64 463924, i64 463944, i64 463986, i64 464015}
!285 = !DILocation(line: 327, column: 12, scope: !264)
!286 = !DILocation(line: 327, column: 5, scope: !264)
!287 = distinct !DISubprogram(name: "vatomic32_inc_rlx", scope: !288, file: !288, line: 2956, type: !289, scopeLine: 2957, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!288 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!289 = !DISubroutineType(types: !290)
!290 = !{null, !268}
!291 = !DILocalVariable(name: "a", arg: 1, scope: !287, file: !288, line: 2956, type: !268)
!292 = !DILocation(line: 2956, column: 32, scope: !287)
!293 = !DILocation(line: 2958, column: 33, scope: !287)
!294 = !DILocation(line: 2958, column: 11, scope: !287)
!295 = !DILocation(line: 2959, column: 1, scope: !287)
!296 = distinct !DISubprogram(name: "vatomic32_cmpxchg_rlx", scope: !265, file: !265, line: 361, type: !266, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!297 = !DILocalVariable(name: "a", arg: 1, scope: !296, file: !265, line: 361, type: !268)
!298 = !DILocation(line: 361, column: 36, scope: !296)
!299 = !DILocalVariable(name: "e", arg: 2, scope: !296, file: !265, line: 361, type: !25)
!300 = !DILocation(line: 361, column: 49, scope: !296)
!301 = !DILocalVariable(name: "v", arg: 3, scope: !296, file: !265, line: 361, type: !25)
!302 = !DILocation(line: 361, column: 62, scope: !296)
!303 = !DILocalVariable(name: "oldv", scope: !296, file: !265, line: 363, type: !25)
!304 = !DILocation(line: 363, column: 15, scope: !296)
!305 = !DILocalVariable(name: "tmp", scope: !296, file: !265, line: 364, type: !25)
!306 = !DILocation(line: 364, column: 15, scope: !296)
!307 = !DILocation(line: 375, column: 22, scope: !296)
!308 = !DILocation(line: 375, column: 36, scope: !296)
!309 = !DILocation(line: 375, column: 48, scope: !296)
!310 = !DILocation(line: 375, column: 51, scope: !296)
!311 = !DILocation(line: 365, column: 5, scope: !296)
!312 = !{i64 465360, i64 465394, i64 465409, i64 465441, i64 465475, i64 465495, i64 465537, i64 465566}
!313 = !DILocation(line: 377, column: 12, scope: !296)
!314 = !DILocation(line: 377, column: 5, scope: !296)
!315 = distinct !DISubprogram(name: "vfutex_wait", scope: !37, file: !37, line: 25, type: !316, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!316 = !DISubroutineType(types: !317)
!317 = !{null, !268, !25}
!318 = !DILocalVariable(name: "m", arg: 1, scope: !315, file: !37, line: 25, type: !268)
!319 = !DILocation(line: 25, column: 26, scope: !315)
!320 = !DILocalVariable(name: "v", arg: 2, scope: !315, file: !37, line: 25, type: !25)
!321 = !DILocation(line: 25, column: 39, scope: !315)
!322 = !DILocalVariable(name: "s", scope: !315, file: !37, line: 27, type: !25)
!323 = !DILocation(line: 27, column: 15, scope: !315)
!324 = !DILocation(line: 27, column: 19, scope: !315)
!325 = !DILocation(line: 28, column: 28, scope: !326)
!326 = distinct !DILexicalBlock(scope: !315, file: !37, line: 28, column: 9)
!327 = !DILocation(line: 28, column: 9, scope: !326)
!328 = !DILocation(line: 28, column: 34, scope: !326)
!329 = !DILocation(line: 28, column: 31, scope: !326)
!330 = !DILocation(line: 28, column: 9, scope: !315)
!331 = !DILocation(line: 29, column: 9, scope: !326)
!332 = !DILocation(line: 30, column: 38, scope: !315)
!333 = !DILocation(line: 30, column: 5, scope: !315)
!334 = !DILocation(line: 31, column: 1, scope: !315)
!335 = distinct !DISubprogram(name: "vatomic32_dec_rlx", scope: !288, file: !288, line: 4064, type: !289, scopeLine: 4065, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!336 = !DILocalVariable(name: "a", arg: 1, scope: !335, file: !288, line: 4064, type: !268)
!337 = !DILocation(line: 4064, column: 32, scope: !335)
!338 = !DILocation(line: 4066, column: 33, scope: !335)
!339 = !DILocation(line: 4066, column: 11, scope: !335)
!340 = !DILocation(line: 4067, column: 1, scope: !335)
!341 = distinct !DISubprogram(name: "vatomic32_get_inc_rlx", scope: !288, file: !288, line: 2516, type: !342, scopeLine: 2517, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!342 = !DISubroutineType(types: !343)
!343 = !{!25, !268}
!344 = !DILocalVariable(name: "a", arg: 1, scope: !341, file: !288, line: 2516, type: !268)
!345 = !DILocation(line: 2516, column: 36, scope: !341)
!346 = !DILocation(line: 2518, column: 34, scope: !341)
!347 = !DILocation(line: 2518, column: 12, scope: !341)
!348 = !DILocation(line: 2518, column: 5, scope: !341)
!349 = distinct !DISubprogram(name: "vatomic32_get_add_rlx", scope: !265, file: !265, line: 1388, type: !350, scopeLine: 1389, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!350 = !DISubroutineType(types: !351)
!351 = !{!25, !268, !25}
!352 = !DILocalVariable(name: "a", arg: 1, scope: !349, file: !265, line: 1388, type: !268)
!353 = !DILocation(line: 1388, column: 36, scope: !349)
!354 = !DILocalVariable(name: "v", arg: 2, scope: !349, file: !265, line: 1388, type: !25)
!355 = !DILocation(line: 1388, column: 49, scope: !349)
!356 = !DILocalVariable(name: "oldv", scope: !349, file: !265, line: 1390, type: !25)
!357 = !DILocation(line: 1390, column: 15, scope: !349)
!358 = !DILocalVariable(name: "tmp", scope: !349, file: !265, line: 1391, type: !25)
!359 = !DILocation(line: 1391, column: 15, scope: !349)
!360 = !DILocalVariable(name: "newv", scope: !349, file: !265, line: 1392, type: !25)
!361 = !DILocation(line: 1392, column: 15, scope: !349)
!362 = !DILocation(line: 1393, column: 5, scope: !349)
!363 = !DILocation(line: 1401, column: 19, scope: !349)
!364 = !DILocation(line: 1401, column: 22, scope: !349)
!365 = !{i64 495992, i64 496026, i64 496041, i64 496073, i64 496115, i64 496156}
!366 = !DILocation(line: 1404, column: 12, scope: !349)
!367 = !DILocation(line: 1404, column: 5, scope: !349)
!368 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !369, file: !369, line: 85, type: !370, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!369 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!370 = !DISubroutineType(types: !371)
!371 = !{!25, !372}
!372 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !373, size: 64)
!373 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !20)
!374 = !DILocalVariable(name: "a", arg: 1, scope: !368, file: !369, line: 85, type: !372)
!375 = !DILocation(line: 85, column: 39, scope: !368)
!376 = !DILocalVariable(name: "val", scope: !368, file: !369, line: 87, type: !25)
!377 = !DILocation(line: 87, column: 15, scope: !368)
!378 = !DILocation(line: 90, column: 32, scope: !368)
!379 = !DILocation(line: 90, column: 35, scope: !368)
!380 = !DILocation(line: 88, column: 5, scope: !368)
!381 = !{i64 398398}
!382 = !DILocation(line: 92, column: 12, scope: !368)
!383 = !DILocation(line: 92, column: 5, scope: !368)
!384 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !369, file: !369, line: 101, type: !370, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!385 = !DILocalVariable(name: "a", arg: 1, scope: !384, file: !369, line: 101, type: !372)
!386 = !DILocation(line: 101, column: 39, scope: !384)
!387 = !DILocalVariable(name: "val", scope: !384, file: !369, line: 103, type: !25)
!388 = !DILocation(line: 103, column: 15, scope: !384)
!389 = !DILocation(line: 106, column: 32, scope: !384)
!390 = !DILocation(line: 106, column: 35, scope: !384)
!391 = !DILocation(line: 104, column: 5, scope: !384)
!392 = !{i64 398900}
!393 = !DILocation(line: 108, column: 12, scope: !384)
!394 = !DILocation(line: 108, column: 5, scope: !384)
!395 = distinct !DISubprogram(name: "vatomic32_await_neq_rlx", scope: !369, file: !369, line: 912, type: !396, scopeLine: 913, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!396 = !DISubroutineType(types: !397)
!397 = !{!25, !372, !25}
!398 = !DILocalVariable(name: "a", arg: 1, scope: !395, file: !369, line: 912, type: !372)
!399 = !DILocation(line: 912, column: 44, scope: !395)
!400 = !DILocalVariable(name: "v", arg: 2, scope: !395, file: !369, line: 912, type: !25)
!401 = !DILocation(line: 912, column: 57, scope: !395)
!402 = !DILocalVariable(name: "val", scope: !395, file: !369, line: 914, type: !25)
!403 = !DILocation(line: 914, column: 15, scope: !395)
!404 = !DILocation(line: 921, column: 21, scope: !395)
!405 = !DILocation(line: 921, column: 33, scope: !395)
!406 = !DILocation(line: 921, column: 36, scope: !395)
!407 = !DILocation(line: 915, column: 5, scope: !395)
!408 = !{i64 421506, i64 421522, i64 421552, i64 421585}
!409 = !DILocation(line: 923, column: 12, scope: !395)
!410 = !DILocation(line: 923, column: 5, scope: !395)
!411 = distinct !DISubprogram(name: "vatomic32_get_dec_rlx", scope: !288, file: !288, line: 3624, type: !342, scopeLine: 3625, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!412 = !DILocalVariable(name: "a", arg: 1, scope: !411, file: !288, line: 3624, type: !268)
!413 = !DILocation(line: 3624, column: 36, scope: !411)
!414 = !DILocation(line: 3626, column: 34, scope: !411)
!415 = !DILocation(line: 3626, column: 12, scope: !411)
!416 = !DILocation(line: 3626, column: 5, scope: !411)
!417 = distinct !DISubprogram(name: "vatomic32_get_sub_rlx", scope: !265, file: !265, line: 1413, type: !350, scopeLine: 1414, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!418 = !DILocalVariable(name: "a", arg: 1, scope: !417, file: !265, line: 1413, type: !268)
!419 = !DILocation(line: 1413, column: 36, scope: !417)
!420 = !DILocalVariable(name: "v", arg: 2, scope: !417, file: !265, line: 1413, type: !25)
!421 = !DILocation(line: 1413, column: 49, scope: !417)
!422 = !DILocalVariable(name: "oldv", scope: !417, file: !265, line: 1415, type: !25)
!423 = !DILocation(line: 1415, column: 15, scope: !417)
!424 = !DILocalVariable(name: "tmp", scope: !417, file: !265, line: 1416, type: !25)
!425 = !DILocation(line: 1416, column: 15, scope: !417)
!426 = !DILocalVariable(name: "newv", scope: !417, file: !265, line: 1417, type: !25)
!427 = !DILocation(line: 1417, column: 15, scope: !417)
!428 = !DILocation(line: 1418, column: 5, scope: !417)
!429 = !DILocation(line: 1426, column: 19, scope: !417)
!430 = !DILocation(line: 1426, column: 22, scope: !417)
!431 = !{i64 496752, i64 496786, i64 496801, i64 496833, i64 496875, i64 496916}
!432 = !DILocation(line: 1429, column: 12, scope: !417)
!433 = !DILocation(line: 1429, column: 5, scope: !417)
!434 = distinct !DISubprogram(name: "vatomic32_xchg_rel", scope: !265, file: !265, line: 66, type: !350, scopeLine: 67, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!435 = !DILocalVariable(name: "a", arg: 1, scope: !434, file: !265, line: 66, type: !268)
!436 = !DILocation(line: 66, column: 33, scope: !434)
!437 = !DILocalVariable(name: "v", arg: 2, scope: !434, file: !265, line: 66, type: !25)
!438 = !DILocation(line: 66, column: 46, scope: !434)
!439 = !DILocalVariable(name: "oldv", scope: !434, file: !265, line: 68, type: !25)
!440 = !DILocation(line: 68, column: 15, scope: !434)
!441 = !DILocalVariable(name: "tmp", scope: !434, file: !265, line: 69, type: !25)
!442 = !DILocation(line: 69, column: 15, scope: !434)
!443 = !DILocation(line: 77, column: 22, scope: !434)
!444 = !DILocation(line: 77, column: 34, scope: !434)
!445 = !DILocation(line: 77, column: 37, scope: !434)
!446 = !DILocation(line: 70, column: 5, scope: !434)
!447 = !{i64 456459, i64 456493, i64 456508, i64 456540, i64 456583}
!448 = !DILocation(line: 79, column: 12, scope: !434)
!449 = !DILocation(line: 79, column: 5, scope: !434)
!450 = distinct !DISubprogram(name: "vfutex_wake", scope: !37, file: !37, line: 34, type: !316, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!451 = !DILocalVariable(name: "m", arg: 1, scope: !450, file: !37, line: 34, type: !268)
!452 = !DILocation(line: 34, column: 26, scope: !450)
!453 = !DILocalVariable(name: "v", arg: 2, scope: !450, file: !37, line: 34, type: !25)
!454 = !DILocation(line: 34, column: 39, scope: !450)
!455 = !DILocation(line: 36, column: 5, scope: !450)
!456 = !DILocation(line: 37, column: 1, scope: !450)
!457 = distinct !DISubprogram(name: "vatomic32_inc_rel", scope: !288, file: !288, line: 2945, type: !289, scopeLine: 2946, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!458 = !DILocalVariable(name: "a", arg: 1, scope: !457, file: !288, line: 2945, type: !268)
!459 = !DILocation(line: 2945, column: 32, scope: !457)
!460 = !DILocation(line: 2947, column: 33, scope: !457)
!461 = !DILocation(line: 2947, column: 11, scope: !457)
!462 = !DILocation(line: 2948, column: 1, scope: !457)
!463 = distinct !DISubprogram(name: "vatomic32_get_inc_rel", scope: !288, file: !288, line: 2505, type: !342, scopeLine: 2506, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!464 = !DILocalVariable(name: "a", arg: 1, scope: !463, file: !288, line: 2505, type: !268)
!465 = !DILocation(line: 2505, column: 36, scope: !463)
!466 = !DILocation(line: 2507, column: 34, scope: !463)
!467 = !DILocation(line: 2507, column: 12, scope: !463)
!468 = !DILocation(line: 2507, column: 5, scope: !463)
!469 = distinct !DISubprogram(name: "vatomic32_get_add_rel", scope: !265, file: !265, line: 1263, type: !350, scopeLine: 1264, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !49)
!470 = !DILocalVariable(name: "a", arg: 1, scope: !469, file: !265, line: 1263, type: !268)
!471 = !DILocation(line: 1263, column: 36, scope: !469)
!472 = !DILocalVariable(name: "v", arg: 2, scope: !469, file: !265, line: 1263, type: !25)
!473 = !DILocation(line: 1263, column: 49, scope: !469)
!474 = !DILocalVariable(name: "oldv", scope: !469, file: !265, line: 1265, type: !25)
!475 = !DILocation(line: 1265, column: 15, scope: !469)
!476 = !DILocalVariable(name: "tmp", scope: !469, file: !265, line: 1266, type: !25)
!477 = !DILocation(line: 1266, column: 15, scope: !469)
!478 = !DILocalVariable(name: "newv", scope: !469, file: !265, line: 1267, type: !25)
!479 = !DILocation(line: 1267, column: 15, scope: !469)
!480 = !DILocation(line: 1268, column: 5, scope: !469)
!481 = !DILocation(line: 1276, column: 19, scope: !469)
!482 = !DILocation(line: 1276, column: 22, scope: !469)
!483 = !{i64 492194, i64 492228, i64 492243, i64 492275, i64 492317, i64 492359}
!484 = !DILocation(line: 1279, column: 12, scope: !469)
!485 = !DILocation(line: 1279, column: 5, scope: !469)
