; ModuleID = '/home/stefano/huawei/libvsync/thread/verify/mutex_slim.c'
source_filename = "/home/stefano/huawei/libvsync/thread/verify/mutex_slim.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !28
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [68 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (2 + 0 + 0)\00", align 1
@lock = dso_local global %struct.vatomic32_s zeroinitializer, align 4, !dbg !12
@signal = internal global %struct.vatomic32_s zeroinitializer, align 4, !dbg !31

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !42 {
  ret void, !dbg !46
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !47 {
  ret void, !dbg !48
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !49 {
  ret void, !dbg !50
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cs() #0 !dbg !51 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !52
  %2 = add i32 %1, 1, !dbg !52
  store i32 %2, i32* @g_cs_x, align 4, !dbg !52
  %3 = load i32, i32* @g_cs_y, align 4, !dbg !53
  %4 = add i32 %3, 1, !dbg !53
  store i32 %4, i32* @g_cs_y, align 4, !dbg !53
  ret void, !dbg !54
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !55 {
  %1 = load i32, i32* @g_cs_x, align 4, !dbg !56
  %2 = load i32, i32* @g_cs_y, align 4, !dbg !56
  %3 = icmp eq i32 %1, %2, !dbg !56
  br i1 %3, label %4, label %5, !dbg !59

4:                                                ; preds = %0
  br label %6, !dbg !59

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 112, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !56
  unreachable, !dbg !56

6:                                                ; preds = %4
  %7 = load i32, i32* @g_cs_x, align 4, !dbg !60
  %8 = icmp eq i32 %7, 2, !dbg !60
  br i1 %8, label %9, label %10, !dbg !63

9:                                                ; preds = %6
  br label %11, !dbg !63

10:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([68 x i8], [68 x i8]* @.str.1, i64 0, i64 0), i32 noundef 113, i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !60
  unreachable, !dbg !60

11:                                               ; preds = %9
  ret void, !dbg !64
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !65 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [2 x i64]* %2, metadata !69, metadata !DIExpression()), !dbg !75
  call void @init(), !dbg !76
  call void @llvm.dbg.declare(metadata i64* %3, metadata !77, metadata !DIExpression()), !dbg !79
  store i64 0, i64* %3, align 8, !dbg !79
  br label %5, !dbg !80

5:                                                ; preds = %14, %0
  %6 = load i64, i64* %3, align 8, !dbg !81
  %7 = icmp ult i64 %6, 2, !dbg !83
  br i1 %7, label %8, label %17, !dbg !84

8:                                                ; preds = %5
  %9 = load i64, i64* %3, align 8, !dbg !85
  %10 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 %9, !dbg !87
  %11 = load i64, i64* %3, align 8, !dbg !88
  %12 = inttoptr i64 %11 to i8*, !dbg !89
  %13 = call i32 @pthread_create(i64* noundef %10, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @run, i8* noundef %12) #6, !dbg !90
  br label %14, !dbg !91

14:                                               ; preds = %8
  %15 = load i64, i64* %3, align 8, !dbg !92
  %16 = add i64 %15, 1, !dbg !92
  store i64 %16, i64* %3, align 8, !dbg !92
  br label %5, !dbg !93, !llvm.loop !94

17:                                               ; preds = %5
  call void @post(), !dbg !97
  call void @llvm.dbg.declare(metadata i64* %4, metadata !98, metadata !DIExpression()), !dbg !100
  store i64 0, i64* %4, align 8, !dbg !100
  br label %18, !dbg !101

18:                                               ; preds = %26, %17
  %19 = load i64, i64* %4, align 8, !dbg !102
  %20 = icmp ult i64 %19, 2, !dbg !104
  br i1 %20, label %21, label %29, !dbg !105

21:                                               ; preds = %18
  %22 = load i64, i64* %4, align 8, !dbg !106
  %23 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 %22, !dbg !108
  %24 = load i64, i64* %23, align 8, !dbg !108
  %25 = call i32 @pthread_join(i64 noundef %24, i8** noundef null), !dbg !109
  br label %26, !dbg !110

26:                                               ; preds = %21
  %27 = load i64, i64* %4, align 8, !dbg !111
  %28 = add i64 %27, 1, !dbg !111
  store i64 %28, i64* %4, align 8, !dbg !111
  br label %18, !dbg !112, !llvm.loop !113

29:                                               ; preds = %18
  call void @check(), !dbg !115
  call void @fini(), !dbg !116
  ret i32 0, !dbg !117
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @run(i8* noundef %0) #0 !dbg !118 {
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !121, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.declare(metadata i32* %3, metadata !123, metadata !DIExpression()), !dbg !124
  %7 = load i8*, i8** %2, align 8, !dbg !125
  %8 = ptrtoint i8* %7 to i64, !dbg !126
  %9 = trunc i64 %8 to i32, !dbg !126
  store i32 %9, i32* %3, align 4, !dbg !124
  call void @llvm.dbg.declare(metadata i32* %4, metadata !127, metadata !DIExpression()), !dbg !129
  store i32 0, i32* %4, align 4, !dbg !129
  br label %10, !dbg !130

10:                                               ; preds = %65, %1
  %11 = load i32, i32* %4, align 4, !dbg !131
  %12 = icmp eq i32 %11, 0, !dbg !133
  br i1 %12, label %22, label %13, !dbg !134

13:                                               ; preds = %10
  %14 = load i32, i32* %4, align 4, !dbg !135
  %15 = icmp eq i32 %14, 1, !dbg !135
  br i1 %15, label %16, label %20, !dbg !135

16:                                               ; preds = %13
  %17 = load i32, i32* %3, align 4, !dbg !135
  %18 = add i32 %17, 1, !dbg !135
  %19 = icmp ult i32 %18, 1, !dbg !135
  br label %20

20:                                               ; preds = %16, %13
  %21 = phi i1 [ false, %13 ], [ %19, %16 ], !dbg !136
  br label %22, !dbg !134

22:                                               ; preds = %20, %10
  %23 = phi i1 [ true, %10 ], [ %21, %20 ]
  br i1 %23, label %24, label %68, !dbg !137

24:                                               ; preds = %22
  call void @llvm.dbg.declare(metadata i32* %5, metadata !138, metadata !DIExpression()), !dbg !141
  store i32 0, i32* %5, align 4, !dbg !141
  br label %25, !dbg !142

25:                                               ; preds = %41, %24
  %26 = load i32, i32* %5, align 4, !dbg !143
  %27 = icmp eq i32 %26, 0, !dbg !145
  br i1 %27, label %37, label %28, !dbg !146

28:                                               ; preds = %25
  %29 = load i32, i32* %5, align 4, !dbg !147
  %30 = icmp eq i32 %29, 1, !dbg !147
  br i1 %30, label %31, label %35, !dbg !147

31:                                               ; preds = %28
  %32 = load i32, i32* %3, align 4, !dbg !147
  %33 = add i32 %32, 1, !dbg !147
  %34 = icmp ult i32 %33, 1, !dbg !147
  br label %35

35:                                               ; preds = %31, %28
  %36 = phi i1 [ false, %28 ], [ %34, %31 ], !dbg !148
  br label %37, !dbg !146

37:                                               ; preds = %35, %25
  %38 = phi i1 [ true, %25 ], [ %36, %35 ]
  br i1 %38, label %39, label %44, !dbg !149

39:                                               ; preds = %37
  %40 = load i32, i32* %3, align 4, !dbg !150
  call void @acquire(i32 noundef %40), !dbg !152
  call void @cs(), !dbg !153
  br label %41, !dbg !154

41:                                               ; preds = %39
  %42 = load i32, i32* %5, align 4, !dbg !155
  %43 = add nsw i32 %42, 1, !dbg !155
  store i32 %43, i32* %5, align 4, !dbg !155
  br label %25, !dbg !156, !llvm.loop !157

44:                                               ; preds = %37
  call void @llvm.dbg.declare(metadata i32* %6, metadata !159, metadata !DIExpression()), !dbg !161
  store i32 0, i32* %6, align 4, !dbg !161
  br label %45, !dbg !162

45:                                               ; preds = %61, %44
  %46 = load i32, i32* %6, align 4, !dbg !163
  %47 = icmp eq i32 %46, 0, !dbg !165
  br i1 %47, label %57, label %48, !dbg !166

48:                                               ; preds = %45
  %49 = load i32, i32* %6, align 4, !dbg !167
  %50 = icmp eq i32 %49, 1, !dbg !167
  br i1 %50, label %51, label %55, !dbg !167

51:                                               ; preds = %48
  %52 = load i32, i32* %3, align 4, !dbg !167
  %53 = add i32 %52, 1, !dbg !167
  %54 = icmp ult i32 %53, 1, !dbg !167
  br label %55

55:                                               ; preds = %51, %48
  %56 = phi i1 [ false, %48 ], [ %54, %51 ], !dbg !168
  br label %57, !dbg !166

57:                                               ; preds = %55, %45
  %58 = phi i1 [ true, %45 ], [ %56, %55 ]
  br i1 %58, label %59, label %64, !dbg !169

59:                                               ; preds = %57
  %60 = load i32, i32* %3, align 4, !dbg !170
  call void @release(i32 noundef %60), !dbg !172
  br label %61, !dbg !173

61:                                               ; preds = %59
  %62 = load i32, i32* %6, align 4, !dbg !174
  %63 = add nsw i32 %62, 1, !dbg !174
  store i32 %63, i32* %6, align 4, !dbg !174
  br label %45, !dbg !175, !llvm.loop !176

64:                                               ; preds = %57
  br label %65, !dbg !178

65:                                               ; preds = %64
  %66 = load i32, i32* %4, align 4, !dbg !179
  %67 = add nsw i32 %66, 1, !dbg !179
  store i32 %67, i32* %4, align 4, !dbg !179
  br label %10, !dbg !180, !llvm.loop !181

68:                                               ; preds = %22
  ret i8* null, !dbg !183
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @acquire(i32 noundef %0) #0 !dbg !184 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !187, metadata !DIExpression()), !dbg !188
  br label %3, !dbg !189

3:                                                ; preds = %1
  br label %4, !dbg !190

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !192
  br label %6, !dbg !192

6:                                                ; preds = %4
  br label %7, !dbg !194

7:                                                ; preds = %6
  br label %8, !dbg !192

8:                                                ; preds = %7
  br label %9, !dbg !190

9:                                                ; preds = %8
  call void @vmutex_acquire(%struct.vatomic32_s* noundef @lock), !dbg !196
  ret void, !dbg !197
}

; Function Attrs: noinline nounwind uwtable
define internal void @vmutex_acquire(%struct.vatomic32_s* noundef %0) #0 !dbg !198 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !202, metadata !DIExpression()), !dbg !203
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !204
  %4 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %3, i32 noundef 0, i32 noundef 1), !dbg !206
  %5 = icmp eq i32 %4, 0, !dbg !207
  br i1 %5, label %6, label %7, !dbg !208

6:                                                ; preds = %1
  br label %14, !dbg !209

7:                                                ; preds = %1
  br label %8, !dbg !211

8:                                                ; preds = %12, %7
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !212
  %10 = call i32 @vatomic32_xchg_acq(%struct.vatomic32_s* noundef %9, i32 noundef 2), !dbg !213
  %11 = icmp ne i32 %10, 0, !dbg !214
  br i1 %11, label %12, label %14, !dbg !211

12:                                               ; preds = %8
  %13 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !215
  call void @vfutex_wait(%struct.vatomic32_s* noundef %13, i32 noundef 2), !dbg !217
  br label %8, !dbg !211, !llvm.loop !218

14:                                               ; preds = %6, %8
  ret void, !dbg !220
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !221 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !222, metadata !DIExpression()), !dbg !223
  br label %3, !dbg !224

3:                                                ; preds = %1
  br label %4, !dbg !225

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !227
  br label %6, !dbg !227

6:                                                ; preds = %4
  br label %7, !dbg !229

7:                                                ; preds = %6
  br label %8, !dbg !227

8:                                                ; preds = %7
  br label %9, !dbg !225

9:                                                ; preds = %8
  call void @vmutex_release(%struct.vatomic32_s* noundef @lock), !dbg !231
  ret void, !dbg !232
}

; Function Attrs: noinline nounwind uwtable
define internal void @vmutex_release(%struct.vatomic32_s* noundef %0) #0 !dbg !233 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !234, metadata !DIExpression()), !dbg !235
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !236
  %4 = call i32 @vatomic32_xchg_rel(%struct.vatomic32_s* noundef %3, i32 noundef 0), !dbg !238
  %5 = icmp eq i32 %4, 1, !dbg !239
  br i1 %5, label %6, label %7, !dbg !240

6:                                                ; preds = %1
  br label %9, !dbg !241

7:                                                ; preds = %1
  %8 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !243
  call void @vfutex_wake(%struct.vatomic32_s* noundef %8, i32 noundef 1), !dbg !244
  br label %9, !dbg !245

9:                                                ; preds = %7, %6
  ret void, !dbg !245
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !246 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !251, metadata !DIExpression()), !dbg !252
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !253, metadata !DIExpression()), !dbg !254
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !255, metadata !DIExpression()), !dbg !256
  call void @llvm.dbg.declare(metadata i32* %7, metadata !257, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.declare(metadata i32* %8, metadata !259, metadata !DIExpression()), !dbg !260
  %9 = load i32, i32* %6, align 4, !dbg !261
  %10 = load i32, i32* %5, align 4, !dbg !262
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !263
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !264
  %13 = load i32, i32* %12, align 4, !dbg !264
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldaxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !265, !srcloc !266
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !265
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !265
  store i32 %15, i32* %7, align 4, !dbg !265
  store i32 %16, i32* %8, align 4, !dbg !265
  %17 = load i32, i32* %7, align 4, !dbg !267
  ret i32 %17, !dbg !268
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_xchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !269 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !272, metadata !DIExpression()), !dbg !273
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !274, metadata !DIExpression()), !dbg !275
  call void @llvm.dbg.declare(metadata i32* %5, metadata !276, metadata !DIExpression()), !dbg !277
  call void @llvm.dbg.declare(metadata i32* %6, metadata !278, metadata !DIExpression()), !dbg !279
  %7 = load i32, i32* %4, align 4, !dbg !280
  %8 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !281
  %9 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %8, i32 0, i32 0, !dbg !282
  %10 = load i32, i32* %9, align 4, !dbg !282
  %11 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $3\0A1:\0Aldaxr ${0:w}, $3\0Astxr  ${1:w}, ${2:w}, $3\0Acbnz ${1:w}, 1b\0A", "=&r,=&r,r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %7, i32 %10) #6, !dbg !283, !srcloc !284
  %12 = extractvalue { i32, i32 } %11, 0, !dbg !283
  %13 = extractvalue { i32, i32 } %11, 1, !dbg !283
  store i32 %12, i32* %5, align 4, !dbg !283
  store i32 %13, i32* %6, align 4, !dbg !283
  %14 = load i32, i32* %5, align 4, !dbg !285
  ret i32 %14, !dbg !286
}

; Function Attrs: noinline nounwind uwtable
define internal void @vfutex_wait(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !287 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !290, metadata !DIExpression()), !dbg !291
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !292, metadata !DIExpression()), !dbg !293
  call void @llvm.dbg.declare(metadata i32* %5, metadata !294, metadata !DIExpression()), !dbg !295
  %6 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef @signal), !dbg !296
  store i32 %6, i32* %5, align 4, !dbg !295
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !297
  %8 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %7), !dbg !299
  %9 = load i32, i32* %4, align 4, !dbg !300
  %10 = icmp ne i32 %8, %9, !dbg !301
  br i1 %10, label %11, label %12, !dbg !302

11:                                               ; preds = %2
  br label %15, !dbg !303

12:                                               ; preds = %2
  %13 = load i32, i32* %5, align 4, !dbg !304
  %14 = call i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef @signal, i32 noundef %13), !dbg !305
  br label %15, !dbg !306

15:                                               ; preds = %12, %11
  ret void, !dbg !306
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !307 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !313, metadata !DIExpression()), !dbg !314
  call void @llvm.dbg.declare(metadata i32* %3, metadata !315, metadata !DIExpression()), !dbg !316
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !317
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !318
  %6 = load i32, i32* %5, align 4, !dbg !318
  %7 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !319, !srcloc !320
  store i32 %7, i32* %3, align 4, !dbg !319
  %8 = load i32, i32* %3, align 4, !dbg !321
  ret i32 %8, !dbg !322
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !323 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !324, metadata !DIExpression()), !dbg !325
  call void @llvm.dbg.declare(metadata i32* %3, metadata !326, metadata !DIExpression()), !dbg !327
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !328
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !329
  %6 = load i32, i32* %5, align 4, !dbg !329
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !330, !srcloc !331
  store i32 %7, i32* %3, align 4, !dbg !330
  %8 = load i32, i32* %3, align 4, !dbg !332
  ret i32 %8, !dbg !333
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !334 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !337, metadata !DIExpression()), !dbg !338
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !339, metadata !DIExpression()), !dbg !340
  call void @llvm.dbg.declare(metadata i32* %5, metadata !341, metadata !DIExpression()), !dbg !342
  %6 = load i32, i32* %4, align 4, !dbg !343
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !344
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !345
  %9 = load i32, i32* %8, align 4, !dbg !345
  %10 = call i32 asm sideeffect "1:\0Aldr ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.eq 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !346, !srcloc !347
  store i32 %10, i32* %5, align 4, !dbg !346
  %11 = load i32, i32* %5, align 4, !dbg !348
  ret i32 %11, !dbg !349
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_xchg_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !350 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !351, metadata !DIExpression()), !dbg !352
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !353, metadata !DIExpression()), !dbg !354
  call void @llvm.dbg.declare(metadata i32* %5, metadata !355, metadata !DIExpression()), !dbg !356
  call void @llvm.dbg.declare(metadata i32* %6, metadata !357, metadata !DIExpression()), !dbg !358
  %7 = load i32, i32* %4, align 4, !dbg !359
  %8 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !360
  %9 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %8, i32 0, i32 0, !dbg !361
  %10 = load i32, i32* %9, align 4, !dbg !361
  %11 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $3\0A1:\0Aldxr ${0:w}, $3\0Astlxr  ${1:w}, ${2:w}, $3\0Acbnz ${1:w}, 1b\0A", "=&r,=&r,r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %7, i32 %10) #6, !dbg !362, !srcloc !363
  %12 = extractvalue { i32, i32 } %11, 0, !dbg !362
  %13 = extractvalue { i32, i32 } %11, 1, !dbg !362
  store i32 %12, i32* %5, align 4, !dbg !362
  store i32 %13, i32* %6, align 4, !dbg !362
  %14 = load i32, i32* %5, align 4, !dbg !364
  ret i32 %14, !dbg !365
}

; Function Attrs: noinline nounwind uwtable
define internal void @vfutex_wake(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !366 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !367, metadata !DIExpression()), !dbg !368
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !369, metadata !DIExpression()), !dbg !370
  call void @vatomic32_inc_rel(%struct.vatomic32_s* noundef @signal), !dbg !371
  ret void, !dbg !372
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !373 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !377, metadata !DIExpression()), !dbg !378
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !379
  %4 = call i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %3), !dbg !380
  ret void, !dbg !381
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !382 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !385, metadata !DIExpression()), !dbg !386
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !387
  %4 = call i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !388
  ret i32 %4, !dbg !389
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !390 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !391, metadata !DIExpression()), !dbg !392
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !393, metadata !DIExpression()), !dbg !394
  call void @llvm.dbg.declare(metadata i32* %5, metadata !395, metadata !DIExpression()), !dbg !396
  call void @llvm.dbg.declare(metadata i32* %6, metadata !397, metadata !DIExpression()), !dbg !398
  call void @llvm.dbg.declare(metadata i32* %7, metadata !399, metadata !DIExpression()), !dbg !400
  %8 = load i32, i32* %4, align 4, !dbg !401
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !402
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !403
  %11 = load i32, i32* %10, align 4, !dbg !403
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astlxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #6, !dbg !401, !srcloc !404
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !401
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !401
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !401
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !401
  store i32 %13, i32* %5, align 4, !dbg !401
  store i32 %14, i32* %7, align 4, !dbg !401
  store i32 %15, i32* %6, align 4, !dbg !401
  store i32 %16, i32* %4, align 4, !dbg !401
  %17 = load i32, i32* %5, align 4, !dbg !405
  ret i32 %17, !dbg !406
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!34, !35, !36, !37, !38, !39, !40}
!llvm.ident = !{!41}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !30, line: 100, type: !22, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !11, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/thread/verify/mutex_slim.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "bf43bea4ed67f19a35e81a6689e0b91c")
!4 = !{!5, !6}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 37, baseType: !8)
!7 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !9, line: 90, baseType: !10)
!9 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = !{!12, !0, !28, !31}
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !14, line: 10, type: !15, isLocal: false, isDefinition: true)
!14 = !DIFile(filename: "thread/verify/mutex_slim.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "bf43bea4ed67f19a35e81a6689e0b91c")
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "vmutex_t", file: !16, line: 23, baseType: !17)
!16 = !DIFile(filename: "thread/include/vsync/thread/mutex/slim.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1cb6de7f75b8a3cdf72b45e1d2e7d3a6")
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
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !30, line: 101, type: !22, isLocal: true, isDefinition: true)
!30 = !DIFile(filename: "utils/include/test/boilerplate/lock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4187ade4a536ecfd1f9ed3ab727ca965")
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "signal", scope: !2, file: !33, line: 22, type: !17, isLocal: true, isDefinition: true)
!33 = !DIFile(filename: "thread/include/vsync/thread/internal/futex.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "dede791c10be6385ed442bbae7c7e9b0")
!34 = !{i32 7, !"Dwarf Version", i32 5}
!35 = !{i32 2, !"Debug Info Version", i32 3}
!36 = !{i32 1, !"wchar_size", i32 4}
!37 = !{i32 7, !"PIC Level", i32 2}
!38 = !{i32 7, !"PIE Level", i32 2}
!39 = !{i32 7, !"uwtable", i32 1}
!40 = !{i32 7, !"frame-pointer", i32 2}
!41 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!42 = distinct !DISubprogram(name: "init", scope: !30, file: !30, line: 68, type: !43, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!43 = !DISubroutineType(types: !44)
!44 = !{null}
!45 = !{}
!46 = !DILocation(line: 70, column: 1, scope: !42)
!47 = distinct !DISubprogram(name: "post", scope: !30, file: !30, line: 77, type: !43, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!48 = !DILocation(line: 79, column: 1, scope: !47)
!49 = distinct !DISubprogram(name: "fini", scope: !30, file: !30, line: 86, type: !43, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!50 = !DILocation(line: 88, column: 1, scope: !49)
!51 = distinct !DISubprogram(name: "cs", scope: !30, file: !30, line: 104, type: !43, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!52 = !DILocation(line: 106, column: 11, scope: !51)
!53 = !DILocation(line: 107, column: 11, scope: !51)
!54 = !DILocation(line: 108, column: 1, scope: !51)
!55 = distinct !DISubprogram(name: "check", scope: !30, file: !30, line: 110, type: !43, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!56 = !DILocation(line: 112, column: 5, scope: !57)
!57 = distinct !DILexicalBlock(scope: !58, file: !30, line: 112, column: 5)
!58 = distinct !DILexicalBlock(scope: !55, file: !30, line: 112, column: 5)
!59 = !DILocation(line: 112, column: 5, scope: !58)
!60 = !DILocation(line: 113, column: 5, scope: !61)
!61 = distinct !DILexicalBlock(scope: !62, file: !30, line: 113, column: 5)
!62 = distinct !DILexicalBlock(scope: !55, file: !30, line: 113, column: 5)
!63 = !DILocation(line: 113, column: 5, scope: !62)
!64 = !DILocation(line: 114, column: 1, scope: !55)
!65 = distinct !DISubprogram(name: "main", scope: !30, file: !30, line: 141, type: !66, scopeLine: 142, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!66 = !DISubroutineType(types: !67)
!67 = !{!68}
!68 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!69 = !DILocalVariable(name: "t", scope: !65, file: !30, line: 143, type: !70)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !71, size: 128, elements: !73)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !72, line: 27, baseType: !10)
!72 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!73 = !{!74}
!74 = !DISubrange(count: 2)
!75 = !DILocation(line: 143, column: 15, scope: !65)
!76 = !DILocation(line: 150, column: 5, scope: !65)
!77 = !DILocalVariable(name: "i", scope: !78, file: !30, line: 152, type: !6)
!78 = distinct !DILexicalBlock(scope: !65, file: !30, line: 152, column: 5)
!79 = !DILocation(line: 152, column: 21, scope: !78)
!80 = !DILocation(line: 152, column: 10, scope: !78)
!81 = !DILocation(line: 152, column: 28, scope: !82)
!82 = distinct !DILexicalBlock(scope: !78, file: !30, line: 152, column: 5)
!83 = !DILocation(line: 152, column: 30, scope: !82)
!84 = !DILocation(line: 152, column: 5, scope: !78)
!85 = !DILocation(line: 153, column: 33, scope: !86)
!86 = distinct !DILexicalBlock(scope: !82, file: !30, line: 152, column: 47)
!87 = !DILocation(line: 153, column: 31, scope: !86)
!88 = !DILocation(line: 153, column: 53, scope: !86)
!89 = !DILocation(line: 153, column: 45, scope: !86)
!90 = !DILocation(line: 153, column: 15, scope: !86)
!91 = !DILocation(line: 154, column: 5, scope: !86)
!92 = !DILocation(line: 152, column: 43, scope: !82)
!93 = !DILocation(line: 152, column: 5, scope: !82)
!94 = distinct !{!94, !84, !95, !96}
!95 = !DILocation(line: 154, column: 5, scope: !78)
!96 = !{!"llvm.loop.mustprogress"}
!97 = !DILocation(line: 156, column: 5, scope: !65)
!98 = !DILocalVariable(name: "i", scope: !99, file: !30, line: 158, type: !6)
!99 = distinct !DILexicalBlock(scope: !65, file: !30, line: 158, column: 5)
!100 = !DILocation(line: 158, column: 21, scope: !99)
!101 = !DILocation(line: 158, column: 10, scope: !99)
!102 = !DILocation(line: 158, column: 28, scope: !103)
!103 = distinct !DILexicalBlock(scope: !99, file: !30, line: 158, column: 5)
!104 = !DILocation(line: 158, column: 30, scope: !103)
!105 = !DILocation(line: 158, column: 5, scope: !99)
!106 = !DILocation(line: 159, column: 30, scope: !107)
!107 = distinct !DILexicalBlock(scope: !103, file: !30, line: 158, column: 47)
!108 = !DILocation(line: 159, column: 28, scope: !107)
!109 = !DILocation(line: 159, column: 15, scope: !107)
!110 = !DILocation(line: 160, column: 5, scope: !107)
!111 = !DILocation(line: 158, column: 43, scope: !103)
!112 = !DILocation(line: 158, column: 5, scope: !103)
!113 = distinct !{!113, !105, !114, !96}
!114 = !DILocation(line: 160, column: 5, scope: !99)
!115 = !DILocation(line: 167, column: 5, scope: !65)
!116 = !DILocation(line: 168, column: 5, scope: !65)
!117 = !DILocation(line: 170, column: 5, scope: !65)
!118 = distinct !DISubprogram(name: "run", scope: !30, file: !30, line: 119, type: !119, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!119 = !DISubroutineType(types: !120)
!120 = !{!5, !5}
!121 = !DILocalVariable(name: "arg", arg: 1, scope: !118, file: !30, line: 119, type: !5)
!122 = !DILocation(line: 119, column: 11, scope: !118)
!123 = !DILocalVariable(name: "tid", scope: !118, file: !30, line: 121, type: !22)
!124 = !DILocation(line: 121, column: 15, scope: !118)
!125 = !DILocation(line: 121, column: 33, scope: !118)
!126 = !DILocation(line: 121, column: 21, scope: !118)
!127 = !DILocalVariable(name: "i", scope: !128, file: !30, line: 125, type: !68)
!128 = distinct !DILexicalBlock(scope: !118, file: !30, line: 125, column: 5)
!129 = !DILocation(line: 125, column: 14, scope: !128)
!130 = !DILocation(line: 125, column: 10, scope: !128)
!131 = !DILocation(line: 125, column: 21, scope: !132)
!132 = distinct !DILexicalBlock(scope: !128, file: !30, line: 125, column: 5)
!133 = !DILocation(line: 125, column: 23, scope: !132)
!134 = !DILocation(line: 125, column: 28, scope: !132)
!135 = !DILocation(line: 125, column: 31, scope: !132)
!136 = !DILocation(line: 0, scope: !132)
!137 = !DILocation(line: 125, column: 5, scope: !128)
!138 = !DILocalVariable(name: "j", scope: !139, file: !30, line: 129, type: !68)
!139 = distinct !DILexicalBlock(scope: !140, file: !30, line: 129, column: 9)
!140 = distinct !DILexicalBlock(scope: !132, file: !30, line: 125, column: 63)
!141 = !DILocation(line: 129, column: 18, scope: !139)
!142 = !DILocation(line: 129, column: 14, scope: !139)
!143 = !DILocation(line: 129, column: 25, scope: !144)
!144 = distinct !DILexicalBlock(scope: !139, file: !30, line: 129, column: 9)
!145 = !DILocation(line: 129, column: 27, scope: !144)
!146 = !DILocation(line: 129, column: 32, scope: !144)
!147 = !DILocation(line: 129, column: 35, scope: !144)
!148 = !DILocation(line: 0, scope: !144)
!149 = !DILocation(line: 129, column: 9, scope: !139)
!150 = !DILocation(line: 130, column: 21, scope: !151)
!151 = distinct !DILexicalBlock(scope: !144, file: !30, line: 129, column: 67)
!152 = !DILocation(line: 130, column: 13, scope: !151)
!153 = !DILocation(line: 131, column: 13, scope: !151)
!154 = !DILocation(line: 132, column: 9, scope: !151)
!155 = !DILocation(line: 129, column: 63, scope: !144)
!156 = !DILocation(line: 129, column: 9, scope: !144)
!157 = distinct !{!157, !149, !158, !96}
!158 = !DILocation(line: 132, column: 9, scope: !139)
!159 = !DILocalVariable(name: "j", scope: !160, file: !30, line: 133, type: !68)
!160 = distinct !DILexicalBlock(scope: !140, file: !30, line: 133, column: 9)
!161 = !DILocation(line: 133, column: 18, scope: !160)
!162 = !DILocation(line: 133, column: 14, scope: !160)
!163 = !DILocation(line: 133, column: 25, scope: !164)
!164 = distinct !DILexicalBlock(scope: !160, file: !30, line: 133, column: 9)
!165 = !DILocation(line: 133, column: 27, scope: !164)
!166 = !DILocation(line: 133, column: 32, scope: !164)
!167 = !DILocation(line: 133, column: 35, scope: !164)
!168 = !DILocation(line: 0, scope: !164)
!169 = !DILocation(line: 133, column: 9, scope: !160)
!170 = !DILocation(line: 134, column: 21, scope: !171)
!171 = distinct !DILexicalBlock(scope: !164, file: !30, line: 133, column: 67)
!172 = !DILocation(line: 134, column: 13, scope: !171)
!173 = !DILocation(line: 135, column: 9, scope: !171)
!174 = !DILocation(line: 133, column: 63, scope: !164)
!175 = !DILocation(line: 133, column: 9, scope: !164)
!176 = distinct !{!176, !169, !177, !96}
!177 = !DILocation(line: 135, column: 9, scope: !160)
!178 = !DILocation(line: 136, column: 5, scope: !140)
!179 = !DILocation(line: 125, column: 59, scope: !132)
!180 = !DILocation(line: 125, column: 5, scope: !132)
!181 = distinct !{!181, !137, !182, !96}
!182 = !DILocation(line: 136, column: 5, scope: !128)
!183 = !DILocation(line: 137, column: 5, scope: !118)
!184 = distinct !DISubprogram(name: "acquire", scope: !14, file: !14, line: 13, type: !185, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!185 = !DISubroutineType(types: !186)
!186 = !{null, !22}
!187 = !DILocalVariable(name: "tid", arg: 1, scope: !184, file: !14, line: 13, type: !22)
!188 = !DILocation(line: 13, column: 19, scope: !184)
!189 = !DILocation(line: 15, column: 5, scope: !184)
!190 = !DILocation(line: 15, column: 5, scope: !191)
!191 = distinct !DILexicalBlock(scope: !184, file: !14, line: 15, column: 5)
!192 = !DILocation(line: 15, column: 5, scope: !193)
!193 = distinct !DILexicalBlock(scope: !191, file: !14, line: 15, column: 5)
!194 = !DILocation(line: 15, column: 5, scope: !195)
!195 = distinct !DILexicalBlock(scope: !193, file: !14, line: 15, column: 5)
!196 = !DILocation(line: 16, column: 5, scope: !184)
!197 = !DILocation(line: 17, column: 1, scope: !184)
!198 = distinct !DISubprogram(name: "vmutex_acquire", scope: !16, file: !16, line: 41, type: !199, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!199 = !DISubroutineType(types: !200)
!200 = !{null, !201}
!201 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!202 = !DILocalVariable(name: "m", arg: 1, scope: !198, file: !16, line: 41, type: !201)
!203 = !DILocation(line: 41, column: 26, scope: !198)
!204 = !DILocation(line: 43, column: 31, scope: !205)
!205 = distinct !DILexicalBlock(scope: !198, file: !16, line: 43, column: 9)
!206 = !DILocation(line: 43, column: 9, scope: !205)
!207 = !DILocation(line: 43, column: 42, scope: !205)
!208 = !DILocation(line: 43, column: 9, scope: !198)
!209 = !DILocation(line: 44, column: 9, scope: !210)
!210 = distinct !DILexicalBlock(scope: !205, file: !16, line: 43, column: 49)
!211 = !DILocation(line: 47, column: 5, scope: !198)
!212 = !DILocation(line: 47, column: 31, scope: !198)
!213 = !DILocation(line: 47, column: 12, scope: !198)
!214 = !DILocation(line: 47, column: 38, scope: !198)
!215 = !DILocation(line: 48, column: 21, scope: !216)
!216 = distinct !DILexicalBlock(scope: !198, file: !16, line: 47, column: 44)
!217 = !DILocation(line: 48, column: 9, scope: !216)
!218 = distinct !{!218, !211, !219, !96}
!219 = !DILocation(line: 49, column: 5, scope: !198)
!220 = !DILocation(line: 50, column: 1, scope: !198)
!221 = distinct !DISubprogram(name: "release", scope: !14, file: !14, line: 20, type: !185, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!222 = !DILocalVariable(name: "tid", arg: 1, scope: !221, file: !14, line: 20, type: !22)
!223 = !DILocation(line: 20, column: 19, scope: !221)
!224 = !DILocation(line: 22, column: 5, scope: !221)
!225 = !DILocation(line: 22, column: 5, scope: !226)
!226 = distinct !DILexicalBlock(scope: !221, file: !14, line: 22, column: 5)
!227 = !DILocation(line: 22, column: 5, scope: !228)
!228 = distinct !DILexicalBlock(scope: !226, file: !14, line: 22, column: 5)
!229 = !DILocation(line: 22, column: 5, scope: !230)
!230 = distinct !DILexicalBlock(scope: !228, file: !14, line: 22, column: 5)
!231 = !DILocation(line: 23, column: 5, scope: !221)
!232 = !DILocation(line: 24, column: 1, scope: !221)
!233 = distinct !DISubprogram(name: "vmutex_release", scope: !16, file: !16, line: 57, type: !199, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!234 = !DILocalVariable(name: "m", arg: 1, scope: !233, file: !16, line: 57, type: !201)
!235 = !DILocation(line: 57, column: 26, scope: !233)
!236 = !DILocation(line: 59, column: 28, scope: !237)
!237 = distinct !DILexicalBlock(scope: !233, file: !16, line: 59, column: 9)
!238 = !DILocation(line: 59, column: 9, scope: !237)
!239 = !DILocation(line: 59, column: 35, scope: !237)
!240 = !DILocation(line: 59, column: 9, scope: !233)
!241 = !DILocation(line: 60, column: 9, scope: !242)
!242 = distinct !DILexicalBlock(scope: !237, file: !16, line: 59, column: 42)
!243 = !DILocation(line: 62, column: 17, scope: !233)
!244 = !DILocation(line: 62, column: 5, scope: !233)
!245 = !DILocation(line: 63, column: 1, scope: !233)
!246 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !247, file: !247, line: 311, type: !248, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!247 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!248 = !DISubroutineType(types: !249)
!249 = !{!22, !250, !22, !22}
!250 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!251 = !DILocalVariable(name: "a", arg: 1, scope: !246, file: !247, line: 311, type: !250)
!252 = !DILocation(line: 311, column: 36, scope: !246)
!253 = !DILocalVariable(name: "e", arg: 2, scope: !246, file: !247, line: 311, type: !22)
!254 = !DILocation(line: 311, column: 49, scope: !246)
!255 = !DILocalVariable(name: "v", arg: 3, scope: !246, file: !247, line: 311, type: !22)
!256 = !DILocation(line: 311, column: 62, scope: !246)
!257 = !DILocalVariable(name: "oldv", scope: !246, file: !247, line: 313, type: !22)
!258 = !DILocation(line: 313, column: 15, scope: !246)
!259 = !DILocalVariable(name: "tmp", scope: !246, file: !247, line: 314, type: !22)
!260 = !DILocation(line: 314, column: 15, scope: !246)
!261 = !DILocation(line: 325, column: 22, scope: !246)
!262 = !DILocation(line: 325, column: 36, scope: !246)
!263 = !DILocation(line: 325, column: 48, scope: !246)
!264 = !DILocation(line: 325, column: 51, scope: !246)
!265 = !DILocation(line: 315, column: 5, scope: !246)
!266 = !{i64 463805, i64 463839, i64 463854, i64 463887, i64 463921, i64 463941, i64 463983, i64 464012}
!267 = !DILocation(line: 327, column: 12, scope: !246)
!268 = !DILocation(line: 327, column: 5, scope: !246)
!269 = distinct !DISubprogram(name: "vatomic32_xchg_acq", scope: !247, file: !247, line: 44, type: !270, scopeLine: 45, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!270 = !DISubroutineType(types: !271)
!271 = !{!22, !250, !22}
!272 = !DILocalVariable(name: "a", arg: 1, scope: !269, file: !247, line: 44, type: !250)
!273 = !DILocation(line: 44, column: 33, scope: !269)
!274 = !DILocalVariable(name: "v", arg: 2, scope: !269, file: !247, line: 44, type: !22)
!275 = !DILocation(line: 44, column: 46, scope: !269)
!276 = !DILocalVariable(name: "oldv", scope: !269, file: !247, line: 46, type: !22)
!277 = !DILocation(line: 46, column: 15, scope: !269)
!278 = !DILocalVariable(name: "tmp", scope: !269, file: !247, line: 47, type: !22)
!279 = !DILocation(line: 47, column: 15, scope: !269)
!280 = !DILocation(line: 55, column: 22, scope: !269)
!281 = !DILocation(line: 55, column: 34, scope: !269)
!282 = !DILocation(line: 55, column: 37, scope: !269)
!283 = !DILocation(line: 48, column: 5, scope: !269)
!284 = !{i64 455794, i64 455828, i64 455843, i64 455876, i64 455918}
!285 = !DILocation(line: 57, column: 12, scope: !269)
!286 = !DILocation(line: 57, column: 5, scope: !269)
!287 = distinct !DISubprogram(name: "vfutex_wait", scope: !33, file: !33, line: 25, type: !288, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!288 = !DISubroutineType(types: !289)
!289 = !{null, !250, !22}
!290 = !DILocalVariable(name: "m", arg: 1, scope: !287, file: !33, line: 25, type: !250)
!291 = !DILocation(line: 25, column: 26, scope: !287)
!292 = !DILocalVariable(name: "v", arg: 2, scope: !287, file: !33, line: 25, type: !22)
!293 = !DILocation(line: 25, column: 39, scope: !287)
!294 = !DILocalVariable(name: "s", scope: !287, file: !33, line: 27, type: !22)
!295 = !DILocation(line: 27, column: 15, scope: !287)
!296 = !DILocation(line: 27, column: 19, scope: !287)
!297 = !DILocation(line: 28, column: 28, scope: !298)
!298 = distinct !DILexicalBlock(scope: !287, file: !33, line: 28, column: 9)
!299 = !DILocation(line: 28, column: 9, scope: !298)
!300 = !DILocation(line: 28, column: 34, scope: !298)
!301 = !DILocation(line: 28, column: 31, scope: !298)
!302 = !DILocation(line: 28, column: 9, scope: !287)
!303 = !DILocation(line: 29, column: 9, scope: !298)
!304 = !DILocation(line: 30, column: 38, scope: !287)
!305 = !DILocation(line: 30, column: 5, scope: !287)
!306 = !DILocation(line: 31, column: 1, scope: !287)
!307 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !308, file: !308, line: 85, type: !309, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!308 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!309 = !DISubroutineType(types: !310)
!310 = !{!22, !311}
!311 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !312, size: 64)
!312 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!313 = !DILocalVariable(name: "a", arg: 1, scope: !307, file: !308, line: 85, type: !311)
!314 = !DILocation(line: 85, column: 39, scope: !307)
!315 = !DILocalVariable(name: "val", scope: !307, file: !308, line: 87, type: !22)
!316 = !DILocation(line: 87, column: 15, scope: !307)
!317 = !DILocation(line: 90, column: 32, scope: !307)
!318 = !DILocation(line: 90, column: 35, scope: !307)
!319 = !DILocation(line: 88, column: 5, scope: !307)
!320 = !{i64 398395}
!321 = !DILocation(line: 92, column: 12, scope: !307)
!322 = !DILocation(line: 92, column: 5, scope: !307)
!323 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !308, file: !308, line: 101, type: !309, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!324 = !DILocalVariable(name: "a", arg: 1, scope: !323, file: !308, line: 101, type: !311)
!325 = !DILocation(line: 101, column: 39, scope: !323)
!326 = !DILocalVariable(name: "val", scope: !323, file: !308, line: 103, type: !22)
!327 = !DILocation(line: 103, column: 15, scope: !323)
!328 = !DILocation(line: 106, column: 32, scope: !323)
!329 = !DILocation(line: 106, column: 35, scope: !323)
!330 = !DILocation(line: 104, column: 5, scope: !323)
!331 = !{i64 398897}
!332 = !DILocation(line: 108, column: 12, scope: !323)
!333 = !DILocation(line: 108, column: 5, scope: !323)
!334 = distinct !DISubprogram(name: "vatomic32_await_neq_rlx", scope: !308, file: !308, line: 912, type: !335, scopeLine: 913, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!335 = !DISubroutineType(types: !336)
!336 = !{!22, !311, !22}
!337 = !DILocalVariable(name: "a", arg: 1, scope: !334, file: !308, line: 912, type: !311)
!338 = !DILocation(line: 912, column: 44, scope: !334)
!339 = !DILocalVariable(name: "v", arg: 2, scope: !334, file: !308, line: 912, type: !22)
!340 = !DILocation(line: 912, column: 57, scope: !334)
!341 = !DILocalVariable(name: "val", scope: !334, file: !308, line: 914, type: !22)
!342 = !DILocation(line: 914, column: 15, scope: !334)
!343 = !DILocation(line: 921, column: 21, scope: !334)
!344 = !DILocation(line: 921, column: 33, scope: !334)
!345 = !DILocation(line: 921, column: 36, scope: !334)
!346 = !DILocation(line: 915, column: 5, scope: !334)
!347 = !{i64 421503, i64 421519, i64 421549, i64 421582}
!348 = !DILocation(line: 923, column: 12, scope: !334)
!349 = !DILocation(line: 923, column: 5, scope: !334)
!350 = distinct !DISubprogram(name: "vatomic32_xchg_rel", scope: !247, file: !247, line: 66, type: !270, scopeLine: 67, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!351 = !DILocalVariable(name: "a", arg: 1, scope: !350, file: !247, line: 66, type: !250)
!352 = !DILocation(line: 66, column: 33, scope: !350)
!353 = !DILocalVariable(name: "v", arg: 2, scope: !350, file: !247, line: 66, type: !22)
!354 = !DILocation(line: 66, column: 46, scope: !350)
!355 = !DILocalVariable(name: "oldv", scope: !350, file: !247, line: 68, type: !22)
!356 = !DILocation(line: 68, column: 15, scope: !350)
!357 = !DILocalVariable(name: "tmp", scope: !350, file: !247, line: 69, type: !22)
!358 = !DILocation(line: 69, column: 15, scope: !350)
!359 = !DILocation(line: 77, column: 22, scope: !350)
!360 = !DILocation(line: 77, column: 34, scope: !350)
!361 = !DILocation(line: 77, column: 37, scope: !350)
!362 = !DILocation(line: 70, column: 5, scope: !350)
!363 = !{i64 456456, i64 456490, i64 456505, i64 456537, i64 456580}
!364 = !DILocation(line: 79, column: 12, scope: !350)
!365 = !DILocation(line: 79, column: 5, scope: !350)
!366 = distinct !DISubprogram(name: "vfutex_wake", scope: !33, file: !33, line: 34, type: !288, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!367 = !DILocalVariable(name: "m", arg: 1, scope: !366, file: !33, line: 34, type: !250)
!368 = !DILocation(line: 34, column: 26, scope: !366)
!369 = !DILocalVariable(name: "v", arg: 2, scope: !366, file: !33, line: 34, type: !22)
!370 = !DILocation(line: 34, column: 39, scope: !366)
!371 = !DILocation(line: 36, column: 5, scope: !366)
!372 = !DILocation(line: 37, column: 1, scope: !366)
!373 = distinct !DISubprogram(name: "vatomic32_inc_rel", scope: !374, file: !374, line: 2945, type: !375, scopeLine: 2946, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!374 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!375 = !DISubroutineType(types: !376)
!376 = !{null, !250}
!377 = !DILocalVariable(name: "a", arg: 1, scope: !373, file: !374, line: 2945, type: !250)
!378 = !DILocation(line: 2945, column: 32, scope: !373)
!379 = !DILocation(line: 2947, column: 33, scope: !373)
!380 = !DILocation(line: 2947, column: 11, scope: !373)
!381 = !DILocation(line: 2948, column: 1, scope: !373)
!382 = distinct !DISubprogram(name: "vatomic32_get_inc_rel", scope: !374, file: !374, line: 2505, type: !383, scopeLine: 2506, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!383 = !DISubroutineType(types: !384)
!384 = !{!22, !250}
!385 = !DILocalVariable(name: "a", arg: 1, scope: !382, file: !374, line: 2505, type: !250)
!386 = !DILocation(line: 2505, column: 36, scope: !382)
!387 = !DILocation(line: 2507, column: 34, scope: !382)
!388 = !DILocation(line: 2507, column: 12, scope: !382)
!389 = !DILocation(line: 2507, column: 5, scope: !382)
!390 = distinct !DISubprogram(name: "vatomic32_get_add_rel", scope: !247, file: !247, line: 1263, type: !270, scopeLine: 1264, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!391 = !DILocalVariable(name: "a", arg: 1, scope: !390, file: !247, line: 1263, type: !250)
!392 = !DILocation(line: 1263, column: 36, scope: !390)
!393 = !DILocalVariable(name: "v", arg: 2, scope: !390, file: !247, line: 1263, type: !22)
!394 = !DILocation(line: 1263, column: 49, scope: !390)
!395 = !DILocalVariable(name: "oldv", scope: !390, file: !247, line: 1265, type: !22)
!396 = !DILocation(line: 1265, column: 15, scope: !390)
!397 = !DILocalVariable(name: "tmp", scope: !390, file: !247, line: 1266, type: !22)
!398 = !DILocation(line: 1266, column: 15, scope: !390)
!399 = !DILocalVariable(name: "newv", scope: !390, file: !247, line: 1267, type: !22)
!400 = !DILocation(line: 1267, column: 15, scope: !390)
!401 = !DILocation(line: 1268, column: 5, scope: !390)
!402 = !DILocation(line: 1276, column: 19, scope: !390)
!403 = !DILocation(line: 1276, column: 22, scope: !390)
!404 = !{i64 492191, i64 492225, i64 492240, i64 492272, i64 492314, i64 492356}
!405 = !DILocation(line: 1279, column: 12, scope: !390)
!406 = !DILocation(line: 1279, column: 5, scope: !390)
