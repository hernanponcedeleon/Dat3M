; ModuleID = '/home/stefano/huawei/libvsync/thread/verify/mutex_tristate.c'
source_filename = "/home/stefano/huawei/libvsync/thread/verify/mutex_tristate.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !28
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [68 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 0 + 0)\00", align 1
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
  %8 = icmp eq i32 %7, 3, !dbg !60
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
  %2 = alloca [3 x i64], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i64]* %2, metadata !69, metadata !DIExpression()), !dbg !75
  call void @init(), !dbg !76
  call void @llvm.dbg.declare(metadata i64* %3, metadata !77, metadata !DIExpression()), !dbg !79
  store i64 0, i64* %3, align 8, !dbg !79
  br label %5, !dbg !80

5:                                                ; preds = %14, %0
  %6 = load i64, i64* %3, align 8, !dbg !81
  %7 = icmp ult i64 %6, 3, !dbg !83
  br i1 %7, label %8, label %17, !dbg !84

8:                                                ; preds = %5
  %9 = load i64, i64* %3, align 8, !dbg !85
  %10 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %9, !dbg !87
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
  %20 = icmp ult i64 %19, 3, !dbg !104
  br i1 %20, label %21, label %29, !dbg !105

21:                                               ; preds = %18
  %22 = load i64, i64* %4, align 8, !dbg !106
  %23 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 %22, !dbg !108
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
  br label %16, !dbg !209

7:                                                ; preds = %1
  br label %8, !dbg !211

8:                                                ; preds = %12, %7
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !212
  %10 = call i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %9, i32 noundef 1, i32 noundef 2), !dbg !214
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !215
  call void @vfutex_wait(%struct.vatomic32_s* noundef %11, i32 noundef 2), !dbg !216
  br label %12, !dbg !217

12:                                               ; preds = %8
  %13 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !218
  %14 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %13, i32 noundef 0, i32 noundef 2), !dbg !219
  %15 = icmp ne i32 %14, 0, !dbg !220
  br i1 %15, label %8, label %16, !dbg !217, !llvm.loop !221

16:                                               ; preds = %6, %12
  ret void, !dbg !223
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !224 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !225, metadata !DIExpression()), !dbg !226
  br label %3, !dbg !227

3:                                                ; preds = %1
  br label %4, !dbg !228

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !230
  br label %6, !dbg !230

6:                                                ; preds = %4
  br label %7, !dbg !232

7:                                                ; preds = %6
  br label %8, !dbg !230

8:                                                ; preds = %7
  br label %9, !dbg !228

9:                                                ; preds = %8
  call void @vmutex_release(%struct.vatomic32_s* noundef @lock), !dbg !234
  ret void, !dbg !235
}

; Function Attrs: noinline nounwind uwtable
define internal void @vmutex_release(%struct.vatomic32_s* noundef %0) #0 !dbg !236 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !237, metadata !DIExpression()), !dbg !238
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !239
  %4 = call i32 @vatomic32_cmpxchg_rel(%struct.vatomic32_s* noundef %3, i32 noundef 1, i32 noundef 0), !dbg !241
  %5 = icmp eq i32 %4, 1, !dbg !242
  br i1 %5, label %6, label %7, !dbg !243

6:                                                ; preds = %1
  br label %10, !dbg !244

7:                                                ; preds = %1
  %8 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !246
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %8, i32 noundef 0), !dbg !247
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !248
  call void @vfutex_wake(%struct.vatomic32_s* noundef %9, i32 noundef 1), !dbg !249
  br label %10, !dbg !250

10:                                               ; preds = %7, %6
  ret void, !dbg !250
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !251 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !256, metadata !DIExpression()), !dbg !257
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !258, metadata !DIExpression()), !dbg !259
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !260, metadata !DIExpression()), !dbg !261
  call void @llvm.dbg.declare(metadata i32* %7, metadata !262, metadata !DIExpression()), !dbg !263
  call void @llvm.dbg.declare(metadata i32* %8, metadata !264, metadata !DIExpression()), !dbg !265
  %9 = load i32, i32* %6, align 4, !dbg !266
  %10 = load i32, i32* %5, align 4, !dbg !267
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !268
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !269
  %13 = load i32, i32* %12, align 4, !dbg !269
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldaxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !270, !srcloc !271
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !270
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !270
  store i32 %15, i32* %7, align 4, !dbg !270
  store i32 %16, i32* %8, align 4, !dbg !270
  %17 = load i32, i32* %7, align 4, !dbg !272
  ret i32 %17, !dbg !273
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !274 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !275, metadata !DIExpression()), !dbg !276
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !277, metadata !DIExpression()), !dbg !278
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !279, metadata !DIExpression()), !dbg !280
  call void @llvm.dbg.declare(metadata i32* %7, metadata !281, metadata !DIExpression()), !dbg !282
  call void @llvm.dbg.declare(metadata i32* %8, metadata !283, metadata !DIExpression()), !dbg !284
  %9 = load i32, i32* %6, align 4, !dbg !285
  %10 = load i32, i32* %5, align 4, !dbg !286
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !287
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !288
  %13 = load i32, i32* %12, align 4, !dbg !288
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !289, !srcloc !290
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !289
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !289
  store i32 %15, i32* %7, align 4, !dbg !289
  store i32 %16, i32* %8, align 4, !dbg !289
  %17 = load i32, i32* %7, align 4, !dbg !291
  ret i32 %17, !dbg !292
}

; Function Attrs: noinline nounwind uwtable
define internal void @vfutex_wait(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !293 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !296, metadata !DIExpression()), !dbg !297
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !298, metadata !DIExpression()), !dbg !299
  call void @llvm.dbg.declare(metadata i32* %5, metadata !300, metadata !DIExpression()), !dbg !301
  %6 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef @signal), !dbg !302
  store i32 %6, i32* %5, align 4, !dbg !301
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !303
  %8 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %7), !dbg !305
  %9 = load i32, i32* %4, align 4, !dbg !306
  %10 = icmp ne i32 %8, %9, !dbg !307
  br i1 %10, label %11, label %12, !dbg !308

11:                                               ; preds = %2
  br label %15, !dbg !309

12:                                               ; preds = %2
  %13 = load i32, i32* %5, align 4, !dbg !310
  %14 = call i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef @signal, i32 noundef %13), !dbg !311
  br label %15, !dbg !312

15:                                               ; preds = %12, %11
  ret void, !dbg !312
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !313 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !319, metadata !DIExpression()), !dbg !320
  call void @llvm.dbg.declare(metadata i32* %3, metadata !321, metadata !DIExpression()), !dbg !322
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !323
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !324
  %6 = load i32, i32* %5, align 4, !dbg !324
  %7 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !325, !srcloc !326
  store i32 %7, i32* %3, align 4, !dbg !325
  %8 = load i32, i32* %3, align 4, !dbg !327
  ret i32 %8, !dbg !328
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !329 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !330, metadata !DIExpression()), !dbg !331
  call void @llvm.dbg.declare(metadata i32* %3, metadata !332, metadata !DIExpression()), !dbg !333
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !334
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !335
  %6 = load i32, i32* %5, align 4, !dbg !335
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !336, !srcloc !337
  store i32 %7, i32* %3, align 4, !dbg !336
  %8 = load i32, i32* %3, align 4, !dbg !338
  ret i32 %8, !dbg !339
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !340 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !343, metadata !DIExpression()), !dbg !344
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !345, metadata !DIExpression()), !dbg !346
  call void @llvm.dbg.declare(metadata i32* %5, metadata !347, metadata !DIExpression()), !dbg !348
  %6 = load i32, i32* %4, align 4, !dbg !349
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !350
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !351
  %9 = load i32, i32* %8, align 4, !dbg !351
  %10 = call i32 asm sideeffect "1:\0Aldr ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.eq 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !352, !srcloc !353
  store i32 %10, i32* %5, align 4, !dbg !352
  %11 = load i32, i32* %5, align 4, !dbg !354
  ret i32 %11, !dbg !355
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !356 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !357, metadata !DIExpression()), !dbg !358
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !359, metadata !DIExpression()), !dbg !360
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !361, metadata !DIExpression()), !dbg !362
  call void @llvm.dbg.declare(metadata i32* %7, metadata !363, metadata !DIExpression()), !dbg !364
  call void @llvm.dbg.declare(metadata i32* %8, metadata !365, metadata !DIExpression()), !dbg !366
  %9 = load i32, i32* %6, align 4, !dbg !367
  %10 = load i32, i32* %5, align 4, !dbg !368
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !369
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !370
  %13 = load i32, i32* %12, align 4, !dbg !370
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astlxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !371, !srcloc !372
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !371
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !371
  store i32 %15, i32* %7, align 4, !dbg !371
  store i32 %16, i32* %8, align 4, !dbg !371
  %17 = load i32, i32* %7, align 4, !dbg !373
  ret i32 %17, !dbg !374
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !375 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !376, metadata !DIExpression()), !dbg !377
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !378, metadata !DIExpression()), !dbg !379
  %5 = load i32, i32* %4, align 4, !dbg !380
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !381
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !382
  %8 = load i32, i32* %7, align 4, !dbg !382
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !383, !srcloc !384
  ret void, !dbg !385
}

; Function Attrs: noinline nounwind uwtable
define internal void @vfutex_wake(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !386 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !387, metadata !DIExpression()), !dbg !388
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !389, metadata !DIExpression()), !dbg !390
  call void @vatomic32_inc_rel(%struct.vatomic32_s* noundef @signal), !dbg !391
  ret void, !dbg !392
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !393 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !397, metadata !DIExpression()), !dbg !398
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !399
  %4 = call i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %3), !dbg !400
  ret void, !dbg !401
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !402 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !405, metadata !DIExpression()), !dbg !406
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !407
  %4 = call i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !408
  ret i32 %4, !dbg !409
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !410 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !413, metadata !DIExpression()), !dbg !414
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !415, metadata !DIExpression()), !dbg !416
  call void @llvm.dbg.declare(metadata i32* %5, metadata !417, metadata !DIExpression()), !dbg !418
  call void @llvm.dbg.declare(metadata i32* %6, metadata !419, metadata !DIExpression()), !dbg !420
  call void @llvm.dbg.declare(metadata i32* %7, metadata !421, metadata !DIExpression()), !dbg !422
  %8 = load i32, i32* %4, align 4, !dbg !423
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !424
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !425
  %11 = load i32, i32* %10, align 4, !dbg !425
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astlxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #6, !dbg !423, !srcloc !426
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !423
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !423
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !423
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !423
  store i32 %13, i32* %5, align 4, !dbg !423
  store i32 %14, i32* %7, align 4, !dbg !423
  store i32 %15, i32* %6, align 4, !dbg !423
  store i32 %16, i32* %4, align 4, !dbg !423
  %17 = load i32, i32* %5, align 4, !dbg !427
  ret i32 %17, !dbg !428
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
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/thread/verify/mutex_tristate.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "049be1d5cb354c2f842f657052c12d2e")
!4 = !{!5, !6}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 37, baseType: !8)
!7 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !9, line: 90, baseType: !10)
!9 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = !{!12, !0, !28, !31}
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !14, line: 4, type: !15, isLocal: false, isDefinition: true)
!14 = !DIFile(filename: "thread/verify/mutex_tristate.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "049be1d5cb354c2f842f657052c12d2e")
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "vmutex_t", file: !16, line: 26, baseType: !17)
!16 = !DIFile(filename: "thread/include/vsync/thread/mutex/tristate.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "0cc3d346519b99f137d1f994914c55da")
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
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !71, size: 192, elements: !73)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !72, line: 27, baseType: !10)
!72 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!73 = !{!74}
!74 = !DISubrange(count: 3)
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
!184 = distinct !DISubprogram(name: "acquire", scope: !14, file: !14, line: 7, type: !185, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!185 = !DISubroutineType(types: !186)
!186 = !{null, !22}
!187 = !DILocalVariable(name: "tid", arg: 1, scope: !184, file: !14, line: 7, type: !22)
!188 = !DILocation(line: 7, column: 19, scope: !184)
!189 = !DILocation(line: 9, column: 5, scope: !184)
!190 = !DILocation(line: 9, column: 5, scope: !191)
!191 = distinct !DILexicalBlock(scope: !184, file: !14, line: 9, column: 5)
!192 = !DILocation(line: 9, column: 5, scope: !193)
!193 = distinct !DILexicalBlock(scope: !191, file: !14, line: 9, column: 5)
!194 = !DILocation(line: 9, column: 5, scope: !195)
!195 = distinct !DILexicalBlock(scope: !193, file: !14, line: 9, column: 5)
!196 = !DILocation(line: 10, column: 5, scope: !184)
!197 = !DILocation(line: 11, column: 1, scope: !184)
!198 = distinct !DISubprogram(name: "vmutex_acquire", scope: !16, file: !16, line: 44, type: !199, scopeLine: 45, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!199 = !DISubroutineType(types: !200)
!200 = !{null, !201}
!201 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!202 = !DILocalVariable(name: "m", arg: 1, scope: !198, file: !16, line: 44, type: !201)
!203 = !DILocation(line: 44, column: 26, scope: !198)
!204 = !DILocation(line: 46, column: 31, scope: !205)
!205 = distinct !DILexicalBlock(scope: !198, file: !16, line: 46, column: 9)
!206 = !DILocation(line: 46, column: 9, scope: !205)
!207 = !DILocation(line: 46, column: 41, scope: !205)
!208 = !DILocation(line: 46, column: 9, scope: !198)
!209 = !DILocation(line: 47, column: 9, scope: !210)
!210 = distinct !DILexicalBlock(scope: !205, file: !16, line: 46, column: 48)
!211 = !DILocation(line: 50, column: 5, scope: !198)
!212 = !DILocation(line: 51, column: 31, scope: !213)
!213 = distinct !DILexicalBlock(scope: !198, file: !16, line: 50, column: 8)
!214 = !DILocation(line: 51, column: 9, scope: !213)
!215 = !DILocation(line: 52, column: 21, scope: !213)
!216 = !DILocation(line: 52, column: 9, scope: !213)
!217 = !DILocation(line: 53, column: 5, scope: !213)
!218 = !DILocation(line: 53, column: 36, scope: !198)
!219 = !DILocation(line: 53, column: 14, scope: !198)
!220 = !DILocation(line: 53, column: 47, scope: !198)
!221 = distinct !{!221, !211, !222, !96}
!222 = !DILocation(line: 53, column: 52, scope: !198)
!223 = !DILocation(line: 54, column: 1, scope: !198)
!224 = distinct !DISubprogram(name: "release", scope: !14, file: !14, line: 14, type: !185, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!225 = !DILocalVariable(name: "tid", arg: 1, scope: !224, file: !14, line: 14, type: !22)
!226 = !DILocation(line: 14, column: 19, scope: !224)
!227 = !DILocation(line: 16, column: 5, scope: !224)
!228 = !DILocation(line: 16, column: 5, scope: !229)
!229 = distinct !DILexicalBlock(scope: !224, file: !14, line: 16, column: 5)
!230 = !DILocation(line: 16, column: 5, scope: !231)
!231 = distinct !DILexicalBlock(scope: !229, file: !14, line: 16, column: 5)
!232 = !DILocation(line: 16, column: 5, scope: !233)
!233 = distinct !DILexicalBlock(scope: !231, file: !14, line: 16, column: 5)
!234 = !DILocation(line: 17, column: 5, scope: !224)
!235 = !DILocation(line: 18, column: 1, scope: !224)
!236 = distinct !DISubprogram(name: "vmutex_release", scope: !16, file: !16, line: 61, type: !199, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!237 = !DILocalVariable(name: "m", arg: 1, scope: !236, file: !16, line: 61, type: !201)
!238 = !DILocation(line: 61, column: 26, scope: !236)
!239 = !DILocation(line: 63, column: 31, scope: !240)
!240 = distinct !DILexicalBlock(scope: !236, file: !16, line: 63, column: 9)
!241 = !DILocation(line: 63, column: 9, scope: !240)
!242 = !DILocation(line: 63, column: 42, scope: !240)
!243 = !DILocation(line: 63, column: 9, scope: !236)
!244 = !DILocation(line: 64, column: 9, scope: !245)
!245 = distinct !DILexicalBlock(scope: !240, file: !16, line: 63, column: 49)
!246 = !DILocation(line: 67, column: 25, scope: !236)
!247 = !DILocation(line: 67, column: 5, scope: !236)
!248 = !DILocation(line: 68, column: 17, scope: !236)
!249 = !DILocation(line: 68, column: 5, scope: !236)
!250 = !DILocation(line: 69, column: 1, scope: !236)
!251 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !252, file: !252, line: 311, type: !253, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!252 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!253 = !DISubroutineType(types: !254)
!254 = !{!22, !255, !22, !22}
!255 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!256 = !DILocalVariable(name: "a", arg: 1, scope: !251, file: !252, line: 311, type: !255)
!257 = !DILocation(line: 311, column: 36, scope: !251)
!258 = !DILocalVariable(name: "e", arg: 2, scope: !251, file: !252, line: 311, type: !22)
!259 = !DILocation(line: 311, column: 49, scope: !251)
!260 = !DILocalVariable(name: "v", arg: 3, scope: !251, file: !252, line: 311, type: !22)
!261 = !DILocation(line: 311, column: 62, scope: !251)
!262 = !DILocalVariable(name: "oldv", scope: !251, file: !252, line: 313, type: !22)
!263 = !DILocation(line: 313, column: 15, scope: !251)
!264 = !DILocalVariable(name: "tmp", scope: !251, file: !252, line: 314, type: !22)
!265 = !DILocation(line: 314, column: 15, scope: !251)
!266 = !DILocation(line: 325, column: 22, scope: !251)
!267 = !DILocation(line: 325, column: 36, scope: !251)
!268 = !DILocation(line: 325, column: 48, scope: !251)
!269 = !DILocation(line: 325, column: 51, scope: !251)
!270 = !DILocation(line: 315, column: 5, scope: !251)
!271 = !{i64 463717, i64 463751, i64 463766, i64 463799, i64 463833, i64 463853, i64 463895, i64 463924}
!272 = !DILocation(line: 327, column: 12, scope: !251)
!273 = !DILocation(line: 327, column: 5, scope: !251)
!274 = distinct !DISubprogram(name: "vatomic32_cmpxchg_rlx", scope: !252, file: !252, line: 361, type: !253, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!275 = !DILocalVariable(name: "a", arg: 1, scope: !274, file: !252, line: 361, type: !255)
!276 = !DILocation(line: 361, column: 36, scope: !274)
!277 = !DILocalVariable(name: "e", arg: 2, scope: !274, file: !252, line: 361, type: !22)
!278 = !DILocation(line: 361, column: 49, scope: !274)
!279 = !DILocalVariable(name: "v", arg: 3, scope: !274, file: !252, line: 361, type: !22)
!280 = !DILocation(line: 361, column: 62, scope: !274)
!281 = !DILocalVariable(name: "oldv", scope: !274, file: !252, line: 363, type: !22)
!282 = !DILocation(line: 363, column: 15, scope: !274)
!283 = !DILocalVariable(name: "tmp", scope: !274, file: !252, line: 364, type: !22)
!284 = !DILocation(line: 364, column: 15, scope: !274)
!285 = !DILocation(line: 375, column: 22, scope: !274)
!286 = !DILocation(line: 375, column: 36, scope: !274)
!287 = !DILocation(line: 375, column: 48, scope: !274)
!288 = !DILocation(line: 375, column: 51, scope: !274)
!289 = !DILocation(line: 365, column: 5, scope: !274)
!290 = !{i64 465269, i64 465303, i64 465318, i64 465350, i64 465384, i64 465404, i64 465446, i64 465475}
!291 = !DILocation(line: 377, column: 12, scope: !274)
!292 = !DILocation(line: 377, column: 5, scope: !274)
!293 = distinct !DISubprogram(name: "vfutex_wait", scope: !33, file: !33, line: 25, type: !294, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!294 = !DISubroutineType(types: !295)
!295 = !{null, !255, !22}
!296 = !DILocalVariable(name: "m", arg: 1, scope: !293, file: !33, line: 25, type: !255)
!297 = !DILocation(line: 25, column: 26, scope: !293)
!298 = !DILocalVariable(name: "v", arg: 2, scope: !293, file: !33, line: 25, type: !22)
!299 = !DILocation(line: 25, column: 39, scope: !293)
!300 = !DILocalVariable(name: "s", scope: !293, file: !33, line: 27, type: !22)
!301 = !DILocation(line: 27, column: 15, scope: !293)
!302 = !DILocation(line: 27, column: 19, scope: !293)
!303 = !DILocation(line: 28, column: 28, scope: !304)
!304 = distinct !DILexicalBlock(scope: !293, file: !33, line: 28, column: 9)
!305 = !DILocation(line: 28, column: 9, scope: !304)
!306 = !DILocation(line: 28, column: 34, scope: !304)
!307 = !DILocation(line: 28, column: 31, scope: !304)
!308 = !DILocation(line: 28, column: 9, scope: !293)
!309 = !DILocation(line: 29, column: 9, scope: !304)
!310 = !DILocation(line: 30, column: 38, scope: !293)
!311 = !DILocation(line: 30, column: 5, scope: !293)
!312 = !DILocation(line: 31, column: 1, scope: !293)
!313 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !314, file: !314, line: 85, type: !315, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!314 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!315 = !DISubroutineType(types: !316)
!316 = !{!22, !317}
!317 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !318, size: 64)
!318 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!319 = !DILocalVariable(name: "a", arg: 1, scope: !313, file: !314, line: 85, type: !317)
!320 = !DILocation(line: 85, column: 39, scope: !313)
!321 = !DILocalVariable(name: "val", scope: !313, file: !314, line: 87, type: !22)
!322 = !DILocation(line: 87, column: 15, scope: !313)
!323 = !DILocation(line: 90, column: 32, scope: !313)
!324 = !DILocation(line: 90, column: 35, scope: !313)
!325 = !DILocation(line: 88, column: 5, scope: !313)
!326 = !{i64 398307}
!327 = !DILocation(line: 92, column: 12, scope: !313)
!328 = !DILocation(line: 92, column: 5, scope: !313)
!329 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !314, file: !314, line: 101, type: !315, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!330 = !DILocalVariable(name: "a", arg: 1, scope: !329, file: !314, line: 101, type: !317)
!331 = !DILocation(line: 101, column: 39, scope: !329)
!332 = !DILocalVariable(name: "val", scope: !329, file: !314, line: 103, type: !22)
!333 = !DILocation(line: 103, column: 15, scope: !329)
!334 = !DILocation(line: 106, column: 32, scope: !329)
!335 = !DILocation(line: 106, column: 35, scope: !329)
!336 = !DILocation(line: 104, column: 5, scope: !329)
!337 = !{i64 398809}
!338 = !DILocation(line: 108, column: 12, scope: !329)
!339 = !DILocation(line: 108, column: 5, scope: !329)
!340 = distinct !DISubprogram(name: "vatomic32_await_neq_rlx", scope: !314, file: !314, line: 912, type: !341, scopeLine: 913, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!341 = !DISubroutineType(types: !342)
!342 = !{!22, !317, !22}
!343 = !DILocalVariable(name: "a", arg: 1, scope: !340, file: !314, line: 912, type: !317)
!344 = !DILocation(line: 912, column: 44, scope: !340)
!345 = !DILocalVariable(name: "v", arg: 2, scope: !340, file: !314, line: 912, type: !22)
!346 = !DILocation(line: 912, column: 57, scope: !340)
!347 = !DILocalVariable(name: "val", scope: !340, file: !314, line: 914, type: !22)
!348 = !DILocation(line: 914, column: 15, scope: !340)
!349 = !DILocation(line: 921, column: 21, scope: !340)
!350 = !DILocation(line: 921, column: 33, scope: !340)
!351 = !DILocation(line: 921, column: 36, scope: !340)
!352 = !DILocation(line: 915, column: 5, scope: !340)
!353 = !{i64 421415, i64 421431, i64 421461, i64 421494}
!354 = !DILocation(line: 923, column: 12, scope: !340)
!355 = !DILocation(line: 923, column: 5, scope: !340)
!356 = distinct !DISubprogram(name: "vatomic32_cmpxchg_rel", scope: !252, file: !252, line: 336, type: !253, scopeLine: 337, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!357 = !DILocalVariable(name: "a", arg: 1, scope: !356, file: !252, line: 336, type: !255)
!358 = !DILocation(line: 336, column: 36, scope: !356)
!359 = !DILocalVariable(name: "e", arg: 2, scope: !356, file: !252, line: 336, type: !22)
!360 = !DILocation(line: 336, column: 49, scope: !356)
!361 = !DILocalVariable(name: "v", arg: 3, scope: !356, file: !252, line: 336, type: !22)
!362 = !DILocation(line: 336, column: 62, scope: !356)
!363 = !DILocalVariable(name: "oldv", scope: !356, file: !252, line: 338, type: !22)
!364 = !DILocation(line: 338, column: 15, scope: !356)
!365 = !DILocalVariable(name: "tmp", scope: !356, file: !252, line: 339, type: !22)
!366 = !DILocation(line: 339, column: 15, scope: !356)
!367 = !DILocation(line: 350, column: 22, scope: !356)
!368 = !DILocation(line: 350, column: 36, scope: !356)
!369 = !DILocation(line: 350, column: 48, scope: !356)
!370 = !DILocation(line: 350, column: 51, scope: !356)
!371 = !DILocation(line: 340, column: 5, scope: !356)
!372 = !{i64 464493, i64 464527, i64 464542, i64 464574, i64 464608, i64 464628, i64 464671, i64 464700}
!373 = !DILocation(line: 352, column: 12, scope: !356)
!374 = !DILocation(line: 352, column: 5, scope: !356)
!375 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !314, file: !314, line: 227, type: !294, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!376 = !DILocalVariable(name: "a", arg: 1, scope: !375, file: !314, line: 227, type: !255)
!377 = !DILocation(line: 227, column: 34, scope: !375)
!378 = !DILocalVariable(name: "v", arg: 2, scope: !375, file: !314, line: 227, type: !22)
!379 = !DILocation(line: 227, column: 47, scope: !375)
!380 = !DILocation(line: 231, column: 32, scope: !375)
!381 = !DILocation(line: 231, column: 44, scope: !375)
!382 = !DILocation(line: 231, column: 47, scope: !375)
!383 = !DILocation(line: 229, column: 5, scope: !375)
!384 = !{i64 402723}
!385 = !DILocation(line: 233, column: 1, scope: !375)
!386 = distinct !DISubprogram(name: "vfutex_wake", scope: !33, file: !33, line: 34, type: !294, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!387 = !DILocalVariable(name: "m", arg: 1, scope: !386, file: !33, line: 34, type: !255)
!388 = !DILocation(line: 34, column: 26, scope: !386)
!389 = !DILocalVariable(name: "v", arg: 2, scope: !386, file: !33, line: 34, type: !22)
!390 = !DILocation(line: 34, column: 39, scope: !386)
!391 = !DILocation(line: 36, column: 5, scope: !386)
!392 = !DILocation(line: 37, column: 1, scope: !386)
!393 = distinct !DISubprogram(name: "vatomic32_inc_rel", scope: !394, file: !394, line: 2945, type: !395, scopeLine: 2946, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!394 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!395 = !DISubroutineType(types: !396)
!396 = !{null, !255}
!397 = !DILocalVariable(name: "a", arg: 1, scope: !393, file: !394, line: 2945, type: !255)
!398 = !DILocation(line: 2945, column: 32, scope: !393)
!399 = !DILocation(line: 2947, column: 33, scope: !393)
!400 = !DILocation(line: 2947, column: 11, scope: !393)
!401 = !DILocation(line: 2948, column: 1, scope: !393)
!402 = distinct !DISubprogram(name: "vatomic32_get_inc_rel", scope: !394, file: !394, line: 2505, type: !403, scopeLine: 2506, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!403 = !DISubroutineType(types: !404)
!404 = !{!22, !255}
!405 = !DILocalVariable(name: "a", arg: 1, scope: !402, file: !394, line: 2505, type: !255)
!406 = !DILocation(line: 2505, column: 36, scope: !402)
!407 = !DILocation(line: 2507, column: 34, scope: !402)
!408 = !DILocation(line: 2507, column: 12, scope: !402)
!409 = !DILocation(line: 2507, column: 5, scope: !402)
!410 = distinct !DISubprogram(name: "vatomic32_get_add_rel", scope: !252, file: !252, line: 1263, type: !411, scopeLine: 1264, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!411 = !DISubroutineType(types: !412)
!412 = !{!22, !255, !22}
!413 = !DILocalVariable(name: "a", arg: 1, scope: !410, file: !252, line: 1263, type: !255)
!414 = !DILocation(line: 1263, column: 36, scope: !410)
!415 = !DILocalVariable(name: "v", arg: 2, scope: !410, file: !252, line: 1263, type: !22)
!416 = !DILocation(line: 1263, column: 49, scope: !410)
!417 = !DILocalVariable(name: "oldv", scope: !410, file: !252, line: 1265, type: !22)
!418 = !DILocation(line: 1265, column: 15, scope: !410)
!419 = !DILocalVariable(name: "tmp", scope: !410, file: !252, line: 1266, type: !22)
!420 = !DILocation(line: 1266, column: 15, scope: !410)
!421 = !DILocalVariable(name: "newv", scope: !410, file: !252, line: 1267, type: !22)
!422 = !DILocation(line: 1267, column: 15, scope: !410)
!423 = !DILocation(line: 1268, column: 5, scope: !410)
!424 = !DILocation(line: 1276, column: 19, scope: !410)
!425 = !DILocation(line: 1276, column: 22, scope: !410)
!426 = !{i64 492103, i64 492137, i64 492152, i64 492184, i64 492226, i64 492268}
!427 = !DILocation(line: 1279, column: 12, scope: !410)
!428 = !DILocation(line: 1279, column: 5, scope: !410)
