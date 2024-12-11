; ModuleID = '/home/stefano/huawei/libvsync/spinlock/test/caslock.c'
source_filename = "/home/stefano/huawei/libvsync/spinlock/test/caslock.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.caslock_s = type { %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_cs_x = internal global i32 0, align 4, !dbg !0
@g_cs_y = internal global i32 0, align 4, !dbg !31
@.str = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.1 = private unnamed_addr constant [68 x i8] c"/home/stefano/huawei/libvsync/utils/include/test/boilerplate/lock.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [17 x i8] c"void check(void)\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (3 + 1 + 0)\00", align 1
@lock = dso_local global %struct.caslock_s zeroinitializer, align 4, !dbg !12

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
  %8 = icmp eq i32 %7, 4, !dbg !60
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
  %19 = icmp ult i32 %18, 2, !dbg !135
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
  %3 = alloca i8, align 1
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !187, metadata !DIExpression()), !dbg !188
  %4 = load i32, i32* %2, align 4, !dbg !189
  %5 = icmp eq i32 %4, 2, !dbg !191
  br i1 %5, label %6, label %11, !dbg !192

6:                                                ; preds = %1
  call void @llvm.dbg.declare(metadata i8* %3, metadata !193, metadata !DIExpression()), !dbg !197
  %7 = call zeroext i1 @caslock_tryacquire(%struct.caslock_s* noundef @lock), !dbg !198
  %8 = zext i1 %7 to i8, !dbg !197
  store i8 %8, i8* %3, align 1, !dbg !197
  %9 = load i8, i8* %3, align 1, !dbg !199
  %10 = trunc i8 %9 to i1, !dbg !199
  call void @verification_assume(i1 noundef zeroext %10), !dbg !200
  br label %12, !dbg !201

11:                                               ; preds = %1
  call void @caslock_acquire(%struct.caslock_s* noundef @lock), !dbg !202
  br label %12

12:                                               ; preds = %11, %6
  ret void, !dbg !204
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @caslock_tryacquire(%struct.caslock_s* noundef %0) #0 !dbg !205 {
  %2 = alloca %struct.caslock_s*, align 8
  store %struct.caslock_s* %0, %struct.caslock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.caslock_s** %2, metadata !209, metadata !DIExpression()), !dbg !210
  %3 = load %struct.caslock_s*, %struct.caslock_s** %2, align 8, !dbg !211
  %4 = getelementptr inbounds %struct.caslock_s, %struct.caslock_s* %3, i32 0, i32 0, !dbg !212
  %5 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %4, i32 noundef 0, i32 noundef 1), !dbg !213
  %6 = icmp eq i32 %5, 0, !dbg !214
  ret i1 %6, !dbg !215
}

; Function Attrs: noinline nounwind uwtable
define internal void @verification_assume(i1 noundef zeroext %0) #0 !dbg !216 {
  %2 = alloca i8, align 1
  %3 = zext i1 %0 to i8
  store i8 %3, i8* %2, align 1
  call void @llvm.dbg.declare(metadata i8* %2, metadata !220, metadata !DIExpression()), !dbg !221
  %4 = load i8, i8* %2, align 1, !dbg !222
  %5 = trunc i8 %4 to i1, !dbg !222
  %6 = zext i1 %5 to i32, !dbg !222
  %7 = call i32 (i32, ...) bitcast (i32 (...)* @__VERIFIER_assume to i32 (i32, ...)*)(i32 noundef %6), !dbg !223
  ret void, !dbg !224
}

; Function Attrs: noinline nounwind uwtable
define internal void @caslock_acquire(%struct.caslock_s* noundef %0) #0 !dbg !225 {
  %2 = alloca %struct.caslock_s*, align 8
  store %struct.caslock_s* %0, %struct.caslock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.caslock_s** %2, metadata !228, metadata !DIExpression()), !dbg !229
  %3 = load %struct.caslock_s*, %struct.caslock_s** %2, align 8, !dbg !230
  %4 = getelementptr inbounds %struct.caslock_s, %struct.caslock_s* %3, i32 0, i32 0, !dbg !231
  %5 = call i32 @vatomic32_await_eq_set_acq(%struct.vatomic32_s* noundef %4, i32 noundef 0, i32 noundef 1), !dbg !232
  ret void, !dbg !233
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @release(i32 noundef %0) #0 !dbg !234 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !235, metadata !DIExpression()), !dbg !236
  br label %3, !dbg !237

3:                                                ; preds = %1
  br label %4, !dbg !238

4:                                                ; preds = %3
  %5 = load i32, i32* %2, align 4, !dbg !240
  br label %6, !dbg !240

6:                                                ; preds = %4
  br label %7, !dbg !242

7:                                                ; preds = %6
  br label %8, !dbg !240

8:                                                ; preds = %7
  br label %9, !dbg !238

9:                                                ; preds = %8
  call void @caslock_release(%struct.caslock_s* noundef @lock), !dbg !244
  ret void, !dbg !245
}

; Function Attrs: noinline nounwind uwtable
define internal void @caslock_release(%struct.caslock_s* noundef %0) #0 !dbg !246 {
  %2 = alloca %struct.caslock_s*, align 8
  store %struct.caslock_s* %0, %struct.caslock_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.caslock_s** %2, metadata !247, metadata !DIExpression()), !dbg !248
  %3 = load %struct.caslock_s*, %struct.caslock_s** %2, align 8, !dbg !249
  %4 = getelementptr inbounds %struct.caslock_s, %struct.caslock_s* %3, i32 0, i32 0, !dbg !250
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %4, i32 noundef 0), !dbg !251
  ret void, !dbg !252
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !253 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !258, metadata !DIExpression()), !dbg !259
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !260, metadata !DIExpression()), !dbg !261
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !262, metadata !DIExpression()), !dbg !263
  call void @llvm.dbg.declare(metadata i32* %7, metadata !264, metadata !DIExpression()), !dbg !265
  call void @llvm.dbg.declare(metadata i32* %8, metadata !266, metadata !DIExpression()), !dbg !267
  %9 = load i32, i32* %6, align 4, !dbg !268
  %10 = load i32, i32* %5, align 4, !dbg !269
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !270
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !271
  %13 = load i32, i32* %12, align 4, !dbg !271
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldaxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !272, !srcloc !273
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !272
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !272
  store i32 %15, i32* %7, align 4, !dbg !272
  store i32 %16, i32* %8, align 4, !dbg !272
  %17 = load i32, i32* %7, align 4, !dbg !274
  ret i32 %17, !dbg !275
}

declare i32 @__VERIFIER_assume(...) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_set_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !276 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !278, metadata !DIExpression()), !dbg !279
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !280, metadata !DIExpression()), !dbg !281
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !282, metadata !DIExpression()), !dbg !283
  br label %7, !dbg !284

7:                                                ; preds = %11, %3
  %8 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !285
  %9 = load i32, i32* %5, align 4, !dbg !287
  %10 = call i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %8, i32 noundef %9), !dbg !288
  br label %11, !dbg !289

11:                                               ; preds = %7
  %12 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !290
  %13 = load i32, i32* %5, align 4, !dbg !291
  %14 = load i32, i32* %6, align 4, !dbg !292
  %15 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %12, i32 noundef %13, i32 noundef %14), !dbg !293
  %16 = load i32, i32* %5, align 4, !dbg !294
  %17 = icmp ne i32 %15, %16, !dbg !295
  br i1 %17, label %7, label %18, !dbg !289, !llvm.loop !296

18:                                               ; preds = %11
  %19 = load i32, i32* %5, align 4, !dbg !298
  ret i32 %19, !dbg !299
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_eq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !300 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !306, metadata !DIExpression()), !dbg !307
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !308, metadata !DIExpression()), !dbg !309
  call void @llvm.dbg.declare(metadata i32* %5, metadata !310, metadata !DIExpression()), !dbg !311
  %6 = load i32, i32* %4, align 4, !dbg !312
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !313
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !314
  %9 = load i32, i32* %8, align 4, !dbg !314
  %10 = call i32 asm sideeffect "1:\0Aldr ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.ne 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !315, !srcloc !316
  store i32 %10, i32* %5, align 4, !dbg !315
  %11 = load i32, i32* %5, align 4, !dbg !317
  ret i32 %11, !dbg !318
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !319 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !322, metadata !DIExpression()), !dbg !323
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !324, metadata !DIExpression()), !dbg !325
  %5 = load i32, i32* %4, align 4, !dbg !326
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !327
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !328
  %8 = load i32, i32* %7, align 4, !dbg !328
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !329, !srcloc !330
  ret void, !dbg !331
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
!1 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !33, line: 100, type: !25, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !11, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/spinlock/test/caslock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "accde1a89294539b5cde1266da41164c")
!4 = !{!5, !6}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 37, baseType: !8)
!7 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !9, line: 90, baseType: !10)
!9 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!10 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!11 = !{!12, !0, !31}
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !14, line: 6, type: !15, isLocal: false, isDefinition: true)
!14 = !DIFile(filename: "spinlock/test/caslock.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "accde1a89294539b5cde1266da41164c")
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "caslock_t", file: !16, line: 22, baseType: !17)
!16 = !DIFile(filename: "spinlock/include/vsync/spinlock/caslock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "130e7907ef9e3e59ba33097973760daf")
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "caslock_s", file: !16, line: 20, size: 32, elements: !18)
!18 = !{!19}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !17, file: !16, line: 21, baseType: !20, size: 32, align: 32)
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
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !33, line: 101, type: !25, isLocal: true, isDefinition: true)
!33 = !DIFile(filename: "utils/include/test/boilerplate/lock.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "4187ade4a536ecfd1f9ed3ab727ca965")
!34 = !{i32 7, !"Dwarf Version", i32 5}
!35 = !{i32 2, !"Debug Info Version", i32 3}
!36 = !{i32 1, !"wchar_size", i32 4}
!37 = !{i32 7, !"PIC Level", i32 2}
!38 = !{i32 7, !"PIE Level", i32 2}
!39 = !{i32 7, !"uwtable", i32 1}
!40 = !{i32 7, !"frame-pointer", i32 2}
!41 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!42 = distinct !DISubprogram(name: "init", scope: !33, file: !33, line: 68, type: !43, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!43 = !DISubroutineType(types: !44)
!44 = !{null}
!45 = !{}
!46 = !DILocation(line: 70, column: 1, scope: !42)
!47 = distinct !DISubprogram(name: "post", scope: !33, file: !33, line: 77, type: !43, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!48 = !DILocation(line: 79, column: 1, scope: !47)
!49 = distinct !DISubprogram(name: "fini", scope: !33, file: !33, line: 86, type: !43, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!50 = !DILocation(line: 88, column: 1, scope: !49)
!51 = distinct !DISubprogram(name: "cs", scope: !33, file: !33, line: 104, type: !43, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!52 = !DILocation(line: 106, column: 11, scope: !51)
!53 = !DILocation(line: 107, column: 11, scope: !51)
!54 = !DILocation(line: 108, column: 1, scope: !51)
!55 = distinct !DISubprogram(name: "check", scope: !33, file: !33, line: 110, type: !43, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!56 = !DILocation(line: 112, column: 5, scope: !57)
!57 = distinct !DILexicalBlock(scope: !58, file: !33, line: 112, column: 5)
!58 = distinct !DILexicalBlock(scope: !55, file: !33, line: 112, column: 5)
!59 = !DILocation(line: 112, column: 5, scope: !58)
!60 = !DILocation(line: 113, column: 5, scope: !61)
!61 = distinct !DILexicalBlock(scope: !62, file: !33, line: 113, column: 5)
!62 = distinct !DILexicalBlock(scope: !55, file: !33, line: 113, column: 5)
!63 = !DILocation(line: 113, column: 5, scope: !62)
!64 = !DILocation(line: 114, column: 1, scope: !55)
!65 = distinct !DISubprogram(name: "main", scope: !33, file: !33, line: 141, type: !66, scopeLine: 142, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!66 = !DISubroutineType(types: !67)
!67 = !{!68}
!68 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!69 = !DILocalVariable(name: "t", scope: !65, file: !33, line: 143, type: !70)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !71, size: 192, elements: !73)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !72, line: 27, baseType: !10)
!72 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!73 = !{!74}
!74 = !DISubrange(count: 3)
!75 = !DILocation(line: 143, column: 15, scope: !65)
!76 = !DILocation(line: 150, column: 5, scope: !65)
!77 = !DILocalVariable(name: "i", scope: !78, file: !33, line: 152, type: !6)
!78 = distinct !DILexicalBlock(scope: !65, file: !33, line: 152, column: 5)
!79 = !DILocation(line: 152, column: 21, scope: !78)
!80 = !DILocation(line: 152, column: 10, scope: !78)
!81 = !DILocation(line: 152, column: 28, scope: !82)
!82 = distinct !DILexicalBlock(scope: !78, file: !33, line: 152, column: 5)
!83 = !DILocation(line: 152, column: 30, scope: !82)
!84 = !DILocation(line: 152, column: 5, scope: !78)
!85 = !DILocation(line: 153, column: 33, scope: !86)
!86 = distinct !DILexicalBlock(scope: !82, file: !33, line: 152, column: 47)
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
!98 = !DILocalVariable(name: "i", scope: !99, file: !33, line: 158, type: !6)
!99 = distinct !DILexicalBlock(scope: !65, file: !33, line: 158, column: 5)
!100 = !DILocation(line: 158, column: 21, scope: !99)
!101 = !DILocation(line: 158, column: 10, scope: !99)
!102 = !DILocation(line: 158, column: 28, scope: !103)
!103 = distinct !DILexicalBlock(scope: !99, file: !33, line: 158, column: 5)
!104 = !DILocation(line: 158, column: 30, scope: !103)
!105 = !DILocation(line: 158, column: 5, scope: !99)
!106 = !DILocation(line: 159, column: 30, scope: !107)
!107 = distinct !DILexicalBlock(scope: !103, file: !33, line: 158, column: 47)
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
!118 = distinct !DISubprogram(name: "run", scope: !33, file: !33, line: 119, type: !119, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!119 = !DISubroutineType(types: !120)
!120 = !{!5, !5}
!121 = !DILocalVariable(name: "arg", arg: 1, scope: !118, file: !33, line: 119, type: !5)
!122 = !DILocation(line: 119, column: 11, scope: !118)
!123 = !DILocalVariable(name: "tid", scope: !118, file: !33, line: 121, type: !25)
!124 = !DILocation(line: 121, column: 15, scope: !118)
!125 = !DILocation(line: 121, column: 33, scope: !118)
!126 = !DILocation(line: 121, column: 21, scope: !118)
!127 = !DILocalVariable(name: "i", scope: !128, file: !33, line: 125, type: !68)
!128 = distinct !DILexicalBlock(scope: !118, file: !33, line: 125, column: 5)
!129 = !DILocation(line: 125, column: 14, scope: !128)
!130 = !DILocation(line: 125, column: 10, scope: !128)
!131 = !DILocation(line: 125, column: 21, scope: !132)
!132 = distinct !DILexicalBlock(scope: !128, file: !33, line: 125, column: 5)
!133 = !DILocation(line: 125, column: 23, scope: !132)
!134 = !DILocation(line: 125, column: 28, scope: !132)
!135 = !DILocation(line: 125, column: 31, scope: !132)
!136 = !DILocation(line: 0, scope: !132)
!137 = !DILocation(line: 125, column: 5, scope: !128)
!138 = !DILocalVariable(name: "j", scope: !139, file: !33, line: 129, type: !68)
!139 = distinct !DILexicalBlock(scope: !140, file: !33, line: 129, column: 9)
!140 = distinct !DILexicalBlock(scope: !132, file: !33, line: 125, column: 63)
!141 = !DILocation(line: 129, column: 18, scope: !139)
!142 = !DILocation(line: 129, column: 14, scope: !139)
!143 = !DILocation(line: 129, column: 25, scope: !144)
!144 = distinct !DILexicalBlock(scope: !139, file: !33, line: 129, column: 9)
!145 = !DILocation(line: 129, column: 27, scope: !144)
!146 = !DILocation(line: 129, column: 32, scope: !144)
!147 = !DILocation(line: 129, column: 35, scope: !144)
!148 = !DILocation(line: 0, scope: !144)
!149 = !DILocation(line: 129, column: 9, scope: !139)
!150 = !DILocation(line: 130, column: 21, scope: !151)
!151 = distinct !DILexicalBlock(scope: !144, file: !33, line: 129, column: 67)
!152 = !DILocation(line: 130, column: 13, scope: !151)
!153 = !DILocation(line: 131, column: 13, scope: !151)
!154 = !DILocation(line: 132, column: 9, scope: !151)
!155 = !DILocation(line: 129, column: 63, scope: !144)
!156 = !DILocation(line: 129, column: 9, scope: !144)
!157 = distinct !{!157, !149, !158, !96}
!158 = !DILocation(line: 132, column: 9, scope: !139)
!159 = !DILocalVariable(name: "j", scope: !160, file: !33, line: 133, type: !68)
!160 = distinct !DILexicalBlock(scope: !140, file: !33, line: 133, column: 9)
!161 = !DILocation(line: 133, column: 18, scope: !160)
!162 = !DILocation(line: 133, column: 14, scope: !160)
!163 = !DILocation(line: 133, column: 25, scope: !164)
!164 = distinct !DILexicalBlock(scope: !160, file: !33, line: 133, column: 9)
!165 = !DILocation(line: 133, column: 27, scope: !164)
!166 = !DILocation(line: 133, column: 32, scope: !164)
!167 = !DILocation(line: 133, column: 35, scope: !164)
!168 = !DILocation(line: 0, scope: !164)
!169 = !DILocation(line: 133, column: 9, scope: !160)
!170 = !DILocation(line: 134, column: 21, scope: !171)
!171 = distinct !DILexicalBlock(scope: !164, file: !33, line: 133, column: 67)
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
!184 = distinct !DISubprogram(name: "acquire", scope: !14, file: !14, line: 9, type: !185, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!185 = !DISubroutineType(types: !186)
!186 = !{null, !25}
!187 = !DILocalVariable(name: "tid", arg: 1, scope: !184, file: !14, line: 9, type: !25)
!188 = !DILocation(line: 9, column: 19, scope: !184)
!189 = !DILocation(line: 11, column: 9, scope: !190)
!190 = distinct !DILexicalBlock(scope: !184, file: !14, line: 11, column: 9)
!191 = !DILocation(line: 11, column: 13, scope: !190)
!192 = !DILocation(line: 11, column: 9, scope: !184)
!193 = !DILocalVariable(name: "acquired", scope: !194, file: !14, line: 13, type: !195)
!194 = distinct !DILexicalBlock(scope: !190, file: !14, line: 11, column: 30)
!195 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !7, line: 44, baseType: !196)
!196 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!197 = !DILocation(line: 13, column: 17, scope: !194)
!198 = !DILocation(line: 13, column: 28, scope: !194)
!199 = !DILocation(line: 14, column: 29, scope: !194)
!200 = !DILocation(line: 14, column: 9, scope: !194)
!201 = !DILocation(line: 18, column: 5, scope: !194)
!202 = !DILocation(line: 19, column: 9, scope: !203)
!203 = distinct !DILexicalBlock(scope: !190, file: !14, line: 18, column: 12)
!204 = !DILocation(line: 21, column: 1, scope: !184)
!205 = distinct !DISubprogram(name: "caslock_tryacquire", scope: !16, file: !16, line: 59, type: !206, scopeLine: 60, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!206 = !DISubroutineType(types: !207)
!207 = !{!195, !208}
!208 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!209 = !DILocalVariable(name: "l", arg: 1, scope: !205, file: !16, line: 59, type: !208)
!210 = !DILocation(line: 59, column: 31, scope: !205)
!211 = !DILocation(line: 61, column: 35, scope: !205)
!212 = !DILocation(line: 61, column: 38, scope: !205)
!213 = !DILocation(line: 61, column: 12, scope: !205)
!214 = !DILocation(line: 61, column: 50, scope: !205)
!215 = !DILocation(line: 61, column: 5, scope: !205)
!216 = distinct !DISubprogram(name: "verification_assume", scope: !217, file: !217, line: 116, type: !218, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!217 = !DIFile(filename: "include/vsync/common/verify.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "2fd10960d0c2c64c7ccf19294b1806ff")
!218 = !DISubroutineType(types: !219)
!219 = !{null, !195}
!220 = !DILocalVariable(name: "cond", arg: 1, scope: !216, file: !217, line: 116, type: !195)
!221 = !DILocation(line: 116, column: 29, scope: !216)
!222 = !DILocation(line: 118, column: 23, scope: !216)
!223 = !DILocation(line: 118, column: 5, scope: !216)
!224 = !DILocation(line: 119, column: 1, scope: !216)
!225 = distinct !DISubprogram(name: "caslock_acquire", scope: !16, file: !16, line: 47, type: !226, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!226 = !DISubroutineType(types: !227)
!227 = !{null, !208}
!228 = !DILocalVariable(name: "l", arg: 1, scope: !225, file: !16, line: 47, type: !208)
!229 = !DILocation(line: 47, column: 28, scope: !225)
!230 = !DILocation(line: 49, column: 33, scope: !225)
!231 = !DILocation(line: 49, column: 36, scope: !225)
!232 = !DILocation(line: 49, column: 5, scope: !225)
!233 = !DILocation(line: 50, column: 1, scope: !225)
!234 = distinct !DISubprogram(name: "release", scope: !14, file: !14, line: 24, type: !185, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !45)
!235 = !DILocalVariable(name: "tid", arg: 1, scope: !234, file: !14, line: 24, type: !25)
!236 = !DILocation(line: 24, column: 19, scope: !234)
!237 = !DILocation(line: 26, column: 5, scope: !234)
!238 = !DILocation(line: 26, column: 5, scope: !239)
!239 = distinct !DILexicalBlock(scope: !234, file: !14, line: 26, column: 5)
!240 = !DILocation(line: 26, column: 5, scope: !241)
!241 = distinct !DILexicalBlock(scope: !239, file: !14, line: 26, column: 5)
!242 = !DILocation(line: 26, column: 5, scope: !243)
!243 = distinct !DILexicalBlock(scope: !241, file: !14, line: 26, column: 5)
!244 = !DILocation(line: 27, column: 5, scope: !234)
!245 = !DILocation(line: 28, column: 1, scope: !234)
!246 = distinct !DISubprogram(name: "caslock_release", scope: !16, file: !16, line: 69, type: !226, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!247 = !DILocalVariable(name: "l", arg: 1, scope: !246, file: !16, line: 69, type: !208)
!248 = !DILocation(line: 69, column: 28, scope: !246)
!249 = !DILocation(line: 71, column: 26, scope: !246)
!250 = !DILocation(line: 71, column: 29, scope: !246)
!251 = !DILocation(line: 71, column: 5, scope: !246)
!252 = !DILocation(line: 72, column: 1, scope: !246)
!253 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !254, file: !254, line: 311, type: !255, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!254 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!255 = !DISubroutineType(types: !256)
!256 = !{!25, !257, !25, !25}
!257 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!258 = !DILocalVariable(name: "a", arg: 1, scope: !253, file: !254, line: 311, type: !257)
!259 = !DILocation(line: 311, column: 36, scope: !253)
!260 = !DILocalVariable(name: "e", arg: 2, scope: !253, file: !254, line: 311, type: !25)
!261 = !DILocation(line: 311, column: 49, scope: !253)
!262 = !DILocalVariable(name: "v", arg: 3, scope: !253, file: !254, line: 311, type: !25)
!263 = !DILocation(line: 311, column: 62, scope: !253)
!264 = !DILocalVariable(name: "oldv", scope: !253, file: !254, line: 313, type: !25)
!265 = !DILocation(line: 313, column: 15, scope: !253)
!266 = !DILocalVariable(name: "tmp", scope: !253, file: !254, line: 314, type: !25)
!267 = !DILocation(line: 314, column: 15, scope: !253)
!268 = !DILocation(line: 325, column: 22, scope: !253)
!269 = !DILocation(line: 325, column: 36, scope: !253)
!270 = !DILocation(line: 325, column: 48, scope: !253)
!271 = !DILocation(line: 325, column: 51, scope: !253)
!272 = !DILocation(line: 315, column: 5, scope: !253)
!273 = !{i64 462427, i64 462461, i64 462476, i64 462509, i64 462543, i64 462563, i64 462605, i64 462634}
!274 = !DILocation(line: 327, column: 12, scope: !253)
!275 = !DILocation(line: 327, column: 5, scope: !253)
!276 = distinct !DISubprogram(name: "vatomic32_await_eq_set_acq", scope: !277, file: !277, line: 7303, type: !255, scopeLine: 7304, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!277 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!278 = !DILocalVariable(name: "a", arg: 1, scope: !276, file: !277, line: 7303, type: !257)
!279 = !DILocation(line: 7303, column: 41, scope: !276)
!280 = !DILocalVariable(name: "c", arg: 2, scope: !276, file: !277, line: 7303, type: !25)
!281 = !DILocation(line: 7303, column: 54, scope: !276)
!282 = !DILocalVariable(name: "v", arg: 3, scope: !276, file: !277, line: 7303, type: !25)
!283 = !DILocation(line: 7303, column: 67, scope: !276)
!284 = !DILocation(line: 7305, column: 5, scope: !276)
!285 = !DILocation(line: 7306, column: 38, scope: !286)
!286 = distinct !DILexicalBlock(scope: !276, file: !277, line: 7305, column: 8)
!287 = !DILocation(line: 7306, column: 41, scope: !286)
!288 = !DILocation(line: 7306, column: 15, scope: !286)
!289 = !DILocation(line: 7307, column: 5, scope: !286)
!290 = !DILocation(line: 7307, column: 36, scope: !276)
!291 = !DILocation(line: 7307, column: 39, scope: !276)
!292 = !DILocation(line: 7307, column: 42, scope: !276)
!293 = !DILocation(line: 7307, column: 14, scope: !276)
!294 = !DILocation(line: 7307, column: 48, scope: !276)
!295 = !DILocation(line: 7307, column: 45, scope: !276)
!296 = distinct !{!296, !284, !297, !96}
!297 = !DILocation(line: 7307, column: 49, scope: !276)
!298 = !DILocation(line: 7308, column: 12, scope: !276)
!299 = !DILocation(line: 7308, column: 5, scope: !276)
!300 = distinct !DISubprogram(name: "vatomic32_await_eq_rlx", scope: !301, file: !301, line: 868, type: !302, scopeLine: 869, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!301 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!302 = !DISubroutineType(types: !303)
!303 = !{!25, !304, !25}
!304 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !305, size: 64)
!305 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !20)
!306 = !DILocalVariable(name: "a", arg: 1, scope: !300, file: !301, line: 868, type: !304)
!307 = !DILocation(line: 868, column: 43, scope: !300)
!308 = !DILocalVariable(name: "v", arg: 2, scope: !300, file: !301, line: 868, type: !25)
!309 = !DILocation(line: 868, column: 56, scope: !300)
!310 = !DILocalVariable(name: "val", scope: !300, file: !301, line: 870, type: !25)
!311 = !DILocation(line: 870, column: 15, scope: !300)
!312 = !DILocation(line: 877, column: 21, scope: !300)
!313 = !DILocation(line: 877, column: 33, scope: !300)
!314 = !DILocation(line: 877, column: 36, scope: !300)
!315 = !DILocation(line: 871, column: 5, scope: !300)
!316 = !{i64 418972, i64 418988, i64 419018, i64 419051}
!317 = !DILocation(line: 879, column: 12, scope: !300)
!318 = !DILocation(line: 879, column: 5, scope: !300)
!319 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !301, file: !301, line: 227, type: !320, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !45)
!320 = !DISubroutineType(types: !321)
!321 = !{null, !257, !25}
!322 = !DILocalVariable(name: "a", arg: 1, scope: !319, file: !301, line: 227, type: !257)
!323 = !DILocation(line: 227, column: 34, scope: !319)
!324 = !DILocalVariable(name: "v", arg: 2, scope: !319, file: !301, line: 227, type: !25)
!325 = !DILocation(line: 227, column: 47, scope: !319)
!326 = !DILocation(line: 231, column: 32, scope: !319)
!327 = !DILocation(line: 231, column: 44, scope: !319)
!328 = !DILocation(line: 231, column: 47, scope: !319)
!329 = !DILocation(line: 229, column: 5, scope: !319)
!330 = !{i64 401433}
!331 = !DILocation(line: 233, column: 1, scope: !319)
