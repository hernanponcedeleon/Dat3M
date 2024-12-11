; ModuleID = '/home/stefano/huawei/libvsync/thread/verify/once.c'
source_filename = "/home/stefano/huawei/libvsync/thread/verify/once.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.vatomic32_s = type { i32 }
%struct.run_info_t = type { i64, i64, i8, i8* (i8*)* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_once = dso_local global %struct.vatomic32_s zeroinitializer, align 4, !dbg !0
@g_winner = dso_local global i64 0, align 8, !dbg !32
@.str = private unnamed_addr constant [14 x i8] c"g_winner != 0\00", align 1
@.str.1 = private unnamed_addr constant [51 x i8] c"/home/stefano/huawei/libvsync/thread/verify/once.c\00", align 1
@__PRETTY_FUNCTION__.__once_verification_cb = private unnamed_addr constant [37 x i8] c"void *__once_verification_cb(void *)\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"tid != 0\00", align 1
@__PRETTY_FUNCTION__.run = private unnamed_addr constant [18 x i8] c"void *run(void *)\00", align 1
@.str.3 = private unnamed_addr constant [30 x i8] c"tid == (vsize_t)(vuintptr_t)r\00", align 1
@.str.4 = private unnamed_addr constant [16 x i8] c"g_winner == tid\00", align 1
@.str.5 = private unnamed_addr constant [16 x i8] c"g_winner != tid\00", align 1
@signal = internal global %struct.vatomic32_s zeroinitializer, align 4, !dbg !35

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @__once_verification_cb(i8* noundef %0) #0 !dbg !59 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !61, metadata !DIExpression()), !dbg !62
  %3 = load i8*, i8** %2, align 8, !dbg !63
  %4 = ptrtoint i8* %3 to i64, !dbg !64
  store i64 %4, i64* @g_winner, align 8, !dbg !65
  %5 = load i64, i64* @g_winner, align 8, !dbg !66
  %6 = icmp ne i64 %5, 0, !dbg !66
  br i1 %6, label %7, label %8, !dbg !69

7:                                                ; preds = %1
  br label %9, !dbg !69

8:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 16, i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @__PRETTY_FUNCTION__.__once_verification_cb, i64 0, i64 0)) #5, !dbg !66
  unreachable, !dbg !66

9:                                                ; preds = %7
  %10 = load i8*, i8** %2, align 8, !dbg !70
  ret i8* %10, !dbg !71
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !72 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  %4 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !73, metadata !DIExpression()), !dbg !74
  call void @llvm.dbg.declare(metadata i64* %3, metadata !75, metadata !DIExpression()), !dbg !76
  %5 = load i8*, i8** %2, align 8, !dbg !77
  %6 = ptrtoint i8* %5 to i64, !dbg !78
  %7 = add i64 %6, 1, !dbg !79
  store i64 %7, i64* %3, align 8, !dbg !76
  %8 = load i64, i64* %3, align 8, !dbg !80
  %9 = icmp ne i64 %8, 0, !dbg !80
  br i1 %9, label %10, label %11, !dbg !83

10:                                               ; preds = %1
  br label %12, !dbg !83

11:                                               ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 24, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !80
  unreachable, !dbg !80

12:                                               ; preds = %10
  call void @llvm.dbg.declare(metadata i8** %4, metadata !84, metadata !DIExpression()), !dbg !85
  %13 = load i64, i64* %3, align 8, !dbg !86
  %14 = inttoptr i64 %13 to i8*, !dbg !87
  %15 = call i8* @vonce_call(%struct.vatomic32_s* noundef @g_once, i8* (i8*)* noundef @__once_verification_cb, i8* noundef %14), !dbg !88
  store i8* %15, i8** %4, align 8, !dbg !85
  %16 = load i8*, i8** %4, align 8, !dbg !89
  %17 = icmp ne i8* %16, null, !dbg !91
  br i1 %17, label %18, label %32, !dbg !92

18:                                               ; preds = %12
  %19 = load i64, i64* %3, align 8, !dbg !93
  %20 = load i8*, i8** %4, align 8, !dbg !93
  %21 = ptrtoint i8* %20 to i64, !dbg !93
  %22 = icmp eq i64 %19, %21, !dbg !93
  br i1 %22, label %23, label %24, !dbg !97

23:                                               ; preds = %18
  br label %25, !dbg !97

24:                                               ; preds = %18
  call void @__assert_fail(i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 31, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !93
  unreachable, !dbg !93

25:                                               ; preds = %23
  %26 = load i64, i64* @g_winner, align 8, !dbg !98
  %27 = load i64, i64* %3, align 8, !dbg !98
  %28 = icmp eq i64 %26, %27, !dbg !98
  br i1 %28, label %29, label %30, !dbg !101

29:                                               ; preds = %25
  br label %31, !dbg !101

30:                                               ; preds = %25
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 32, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !98
  unreachable, !dbg !98

31:                                               ; preds = %29
  br label %39, !dbg !102

32:                                               ; preds = %12
  %33 = load i64, i64* @g_winner, align 8, !dbg !103
  %34 = load i64, i64* %3, align 8, !dbg !103
  %35 = icmp ne i64 %33, %34, !dbg !103
  br i1 %35, label %36, label %37, !dbg !107

36:                                               ; preds = %32
  br label %38, !dbg !107

37:                                               ; preds = %32
  call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i64 0, i64 0), i32 noundef 35, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.run, i64 0, i64 0)) #5, !dbg !103
  unreachable, !dbg !103

38:                                               ; preds = %36
  br label %39

39:                                               ; preds = %38, %31
  ret i8* null, !dbg !108
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @vonce_call(%struct.vatomic32_s* noundef %0, i8* (i8*)* noundef %1, i8* noundef %2) #0 !dbg !109 {
  %4 = alloca i8*, align 8
  %5 = alloca %struct.vatomic32_s*, align 8
  %6 = alloca i8* (i8*)*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i8*, align 8
  %9 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %5, metadata !114, metadata !DIExpression()), !dbg !115
  store i8* (i8*)* %1, i8* (i8*)** %6, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %6, metadata !116, metadata !DIExpression()), !dbg !117
  store i8* %2, i8** %7, align 8
  call void @llvm.dbg.declare(metadata i8** %7, metadata !118, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.declare(metadata i8** %8, metadata !120, metadata !DIExpression()), !dbg !121
  store i8* null, i8** %8, align 8, !dbg !121
  call void @llvm.dbg.declare(metadata i32* %9, metadata !122, metadata !DIExpression()), !dbg !123
  store i32 0, i32* %9, align 4, !dbg !123
  %10 = load %struct.vatomic32_s*, %struct.vatomic32_s** %5, align 8, !dbg !124
  %11 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %10), !dbg !126
  %12 = icmp eq i32 %11, 2, !dbg !127
  br i1 %12, label %13, label %14, !dbg !128

13:                                               ; preds = %3
  store i8* null, i8** %4, align 8, !dbg !129
  br label %35, !dbg !129

14:                                               ; preds = %3
  %15 = load %struct.vatomic32_s*, %struct.vatomic32_s** %5, align 8, !dbg !131
  %16 = call i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %15, i32 noundef 0, i32 noundef 1), !dbg !132
  store i32 %16, i32* %9, align 4, !dbg !133
  %17 = load i32, i32* %9, align 4, !dbg !134
  %18 = icmp eq i32 %17, 0, !dbg !136
  br i1 %18, label %19, label %25, !dbg !137

19:                                               ; preds = %14
  %20 = load i8*, i8** %7, align 8, !dbg !138
  %21 = call i8* @__once_verification_cb(i8* noundef %20), !dbg !140
  store i8* %21, i8** %8, align 8, !dbg !141
  %22 = load %struct.vatomic32_s*, %struct.vatomic32_s** %5, align 8, !dbg !142
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %22, i32 noundef 2), !dbg !143
  %23 = load %struct.vatomic32_s*, %struct.vatomic32_s** %5, align 8, !dbg !144
  call void @vfutex_wake(%struct.vatomic32_s* noundef %23, i32 noundef 2147483647), !dbg !145
  %24 = load i8*, i8** %8, align 8, !dbg !146
  store i8* %24, i8** %4, align 8, !dbg !147
  br label %35, !dbg !147

25:                                               ; preds = %14
  br label %26, !dbg !148

26:                                               ; preds = %29, %25
  %27 = load i32, i32* %9, align 4, !dbg !149
  %28 = icmp eq i32 %27, 1, !dbg !150
  br i1 %28, label %29, label %33, !dbg !148

29:                                               ; preds = %26
  %30 = load %struct.vatomic32_s*, %struct.vatomic32_s** %5, align 8, !dbg !151
  call void @vfutex_wait(%struct.vatomic32_s* noundef %30, i32 noundef 1), !dbg !153
  %31 = load %struct.vatomic32_s*, %struct.vatomic32_s** %5, align 8, !dbg !154
  %32 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %31), !dbg !155
  store i32 %32, i32* %9, align 4, !dbg !156
  br label %26, !dbg !148, !llvm.loop !157

33:                                               ; preds = %26
  %34 = load i8*, i8** %8, align 8, !dbg !160
  store i8* %34, i8** %4, align 8, !dbg !161
  br label %35, !dbg !161

35:                                               ; preds = %33, %19, %13
  %36 = load i8*, i8** %4, align 8, !dbg !162
  ret i8* %36, !dbg !162
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !163 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @launch_threads(i64 noundef 4, i8* (i8*)* noundef @run), !dbg !167
  ret i32 0, !dbg !168
}

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !169 {
  %3 = alloca i64, align 8
  %4 = alloca i8* (i8*)*, align 8
  %5 = alloca %struct.run_info_t*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !172, metadata !DIExpression()), !dbg !173
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %4, metadata !174, metadata !DIExpression()), !dbg !175
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !176, metadata !DIExpression()), !dbg !177
  %6 = load i64, i64* %3, align 8, !dbg !178
  %7 = mul i64 32, %6, !dbg !179
  %8 = call noalias i8* @malloc(i64 noundef %7) #6, !dbg !180
  %9 = bitcast i8* %8 to %struct.run_info_t*, !dbg !180
  store %struct.run_info_t* %9, %struct.run_info_t** %5, align 8, !dbg !177
  %10 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !181
  %11 = load i64, i64* %3, align 8, !dbg !182
  %12 = load i8* (i8*)*, i8* (i8*)** %4, align 8, !dbg !183
  call void @create_threads(%struct.run_info_t* noundef %10, i64 noundef %11, i8* (i8*)* noundef %12, i1 noundef zeroext true), !dbg !184
  %13 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !185
  %14 = load i64, i64* %3, align 8, !dbg !186
  call void @await_threads(%struct.run_info_t* noundef %13, i64 noundef %14), !dbg !187
  %15 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !188
  %16 = bitcast %struct.run_info_t* %15 to i8*, !dbg !188
  call void @free(i8* noundef %16) #6, !dbg !189
  ret void, !dbg !190
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !191 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !197, metadata !DIExpression()), !dbg !198
  call void @llvm.dbg.declare(metadata i32* %3, metadata !199, metadata !DIExpression()), !dbg !200
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !201
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !202
  %6 = load i32, i32* %5, align 4, !dbg !202
  %7 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !203, !srcloc !204
  store i32 %7, i32* %3, align 4, !dbg !203
  %8 = load i32, i32* %3, align 4, !dbg !205
  ret i32 %8, !dbg !206
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_cmpxchg_acq(%struct.vatomic32_s* noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !207 {
  %4 = alloca %struct.vatomic32_s*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %4, metadata !212, metadata !DIExpression()), !dbg !213
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !214, metadata !DIExpression()), !dbg !215
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !216, metadata !DIExpression()), !dbg !217
  call void @llvm.dbg.declare(metadata i32* %7, metadata !218, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.declare(metadata i32* %8, metadata !220, metadata !DIExpression()), !dbg !221
  %9 = load i32, i32* %6, align 4, !dbg !222
  %10 = load i32, i32* %5, align 4, !dbg !223
  %11 = load %struct.vatomic32_s*, %struct.vatomic32_s** %4, align 8, !dbg !224
  %12 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %11, i32 0, i32 0, !dbg !225
  %13 = load i32, i32* %12, align 4, !dbg !225
  %14 = call { i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldaxr ${0:w}, $4\0Acmp ${0:w}, ${3:w}\0Ab.ne 2f\0Astxr  ${1:w}, ${2:w}, $4\0Acbnz ${1:w}, 1b\0A2:\0A", "=&r,=&r,r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %9, i32 %10, i32 %13) #6, !dbg !226, !srcloc !227
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !226
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !226
  store i32 %15, i32* %7, align 4, !dbg !226
  store i32 %16, i32* %8, align 4, !dbg !226
  %17 = load i32, i32* %7, align 4, !dbg !228
  ret i32 %17, !dbg !229
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !230 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !233, metadata !DIExpression()), !dbg !234
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !235, metadata !DIExpression()), !dbg !236
  %5 = load i32, i32* %4, align 4, !dbg !237
  %6 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !238
  %7 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %6, i32 0, i32 0, !dbg !239
  %8 = load i32, i32* %7, align 4, !dbg !239
  call void asm sideeffect "stlr ${0:w}, $1", "r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %5, i32 %8) #6, !dbg !240, !srcloc !241
  ret void, !dbg !242
}

; Function Attrs: noinline nounwind uwtable
define internal void @vfutex_wake(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !243 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !244, metadata !DIExpression()), !dbg !245
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !246, metadata !DIExpression()), !dbg !247
  call void @vatomic32_inc_rel(%struct.vatomic32_s* noundef @signal), !dbg !248
  ret void, !dbg !249
}

; Function Attrs: noinline nounwind uwtable
define internal void @vfutex_wait(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !250 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !251, metadata !DIExpression()), !dbg !252
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !253, metadata !DIExpression()), !dbg !254
  call void @llvm.dbg.declare(metadata i32* %5, metadata !255, metadata !DIExpression()), !dbg !256
  %6 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef @signal), !dbg !257
  store i32 %6, i32* %5, align 4, !dbg !256
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !258
  %8 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %7), !dbg !260
  %9 = load i32, i32* %4, align 4, !dbg !261
  %10 = icmp ne i32 %8, %9, !dbg !262
  br i1 %10, label %11, label %12, !dbg !263

11:                                               ; preds = %2
  br label %15, !dbg !264

12:                                               ; preds = %2
  %13 = load i32, i32* %5, align 4, !dbg !265
  %14 = call i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef @signal, i32 noundef %13), !dbg !266
  br label %15, !dbg !267

15:                                               ; preds = %12, %11
  ret void, !dbg !267
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !268 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !272, metadata !DIExpression()), !dbg !273
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !274
  %4 = call i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %3), !dbg !275
  ret void, !dbg !276
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !277 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !280, metadata !DIExpression()), !dbg !281
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !282
  %4 = call i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !283
  ret i32 %4, !dbg !284
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !285 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !288, metadata !DIExpression()), !dbg !289
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !290, metadata !DIExpression()), !dbg !291
  call void @llvm.dbg.declare(metadata i32* %5, metadata !292, metadata !DIExpression()), !dbg !293
  call void @llvm.dbg.declare(metadata i32* %6, metadata !294, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.declare(metadata i32* %7, metadata !296, metadata !DIExpression()), !dbg !297
  %8 = load i32, i32* %4, align 4, !dbg !298
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !299
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !300
  %11 = load i32, i32* %10, align 4, !dbg !300
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astlxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #6, !dbg !298, !srcloc !301
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !298
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !298
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !298
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !298
  store i32 %13, i32* %5, align 4, !dbg !298
  store i32 %14, i32* %7, align 4, !dbg !298
  store i32 %15, i32* %6, align 4, !dbg !298
  store i32 %16, i32* %4, align 4, !dbg !298
  %17 = load i32, i32* %5, align 4, !dbg !302
  ret i32 %17, !dbg !303
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !304 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !305, metadata !DIExpression()), !dbg !306
  call void @llvm.dbg.declare(metadata i32* %3, metadata !307, metadata !DIExpression()), !dbg !308
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !309
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !310
  %6 = load i32, i32* %5, align 4, !dbg !310
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #6, !dbg !311, !srcloc !312
  store i32 %7, i32* %3, align 4, !dbg !311
  %8 = load i32, i32* %3, align 4, !dbg !313
  ret i32 %8, !dbg !314
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !315 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !318, metadata !DIExpression()), !dbg !319
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !320, metadata !DIExpression()), !dbg !321
  call void @llvm.dbg.declare(metadata i32* %5, metadata !322, metadata !DIExpression()), !dbg !323
  %6 = load i32, i32* %4, align 4, !dbg !324
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !325
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !326
  %9 = load i32, i32* %8, align 4, !dbg !326
  %10 = call i32 asm sideeffect "1:\0Aldr ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.eq 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #6, !dbg !327, !srcloc !328
  store i32 %10, i32* %5, align 4, !dbg !327
  %11 = load i32, i32* %5, align 4, !dbg !329
  ret i32 %11, !dbg !330
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !331 {
  %5 = alloca %struct.run_info_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8* (i8*)*, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !334, metadata !DIExpression()), !dbg !335
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !336, metadata !DIExpression()), !dbg !337
  store i8* (i8*)* %2, i8* (i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %7, metadata !338, metadata !DIExpression()), !dbg !339
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !340, metadata !DIExpression()), !dbg !341
  call void @llvm.dbg.declare(metadata i64* %9, metadata !342, metadata !DIExpression()), !dbg !343
  store i64 0, i64* %9, align 8, !dbg !343
  store i64 0, i64* %9, align 8, !dbg !344
  br label %11, !dbg !346

11:                                               ; preds = %42, %4
  %12 = load i64, i64* %9, align 8, !dbg !347
  %13 = load i64, i64* %6, align 8, !dbg !349
  %14 = icmp ult i64 %12, %13, !dbg !350
  br i1 %14, label %15, label %45, !dbg !351

15:                                               ; preds = %11
  %16 = load i64, i64* %9, align 8, !dbg !352
  %17 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !354
  %18 = load i64, i64* %9, align 8, !dbg !355
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %17, i64 %18, !dbg !354
  %20 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %19, i32 0, i32 1, !dbg !356
  store i64 %16, i64* %20, align 8, !dbg !357
  %21 = load i8* (i8*)*, i8* (i8*)** %7, align 8, !dbg !358
  %22 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !359
  %23 = load i64, i64* %9, align 8, !dbg !360
  %24 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %22, i64 %23, !dbg !359
  %25 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %24, i32 0, i32 3, !dbg !361
  store i8* (i8*)* %21, i8* (i8*)** %25, align 8, !dbg !362
  %26 = load i8, i8* %8, align 1, !dbg !363
  %27 = trunc i8 %26 to i1, !dbg !363
  %28 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !364
  %29 = load i64, i64* %9, align 8, !dbg !365
  %30 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %28, i64 %29, !dbg !364
  %31 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %30, i32 0, i32 2, !dbg !366
  %32 = zext i1 %27 to i8, !dbg !367
  store i8 %32, i8* %31, align 8, !dbg !367
  %33 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !368
  %34 = load i64, i64* %9, align 8, !dbg !369
  %35 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %33, i64 %34, !dbg !368
  %36 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %35, i32 0, i32 0, !dbg !370
  %37 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !371
  %38 = load i64, i64* %9, align 8, !dbg !372
  %39 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %37, i64 %38, !dbg !371
  %40 = bitcast %struct.run_info_t* %39 to i8*, !dbg !373
  %41 = call i32 @pthread_create(i64* noundef %36, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %40) #6, !dbg !374
  br label %42, !dbg !375

42:                                               ; preds = %15
  %43 = load i64, i64* %9, align 8, !dbg !376
  %44 = add i64 %43, 1, !dbg !376
  store i64 %44, i64* %9, align 8, !dbg !376
  br label %11, !dbg !377, !llvm.loop !378

45:                                               ; preds = %11
  ret void, !dbg !380
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !381 {
  %3 = alloca %struct.run_info_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !384, metadata !DIExpression()), !dbg !385
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !386, metadata !DIExpression()), !dbg !387
  call void @llvm.dbg.declare(metadata i64* %5, metadata !388, metadata !DIExpression()), !dbg !389
  store i64 0, i64* %5, align 8, !dbg !389
  store i64 0, i64* %5, align 8, !dbg !390
  br label %6, !dbg !392

6:                                                ; preds = %17, %2
  %7 = load i64, i64* %5, align 8, !dbg !393
  %8 = load i64, i64* %4, align 8, !dbg !395
  %9 = icmp ult i64 %7, %8, !dbg !396
  br i1 %9, label %10, label %20, !dbg !397

10:                                               ; preds = %6
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !398
  %12 = load i64, i64* %5, align 8, !dbg !400
  %13 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i64 %12, !dbg !398
  %14 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %13, i32 0, i32 0, !dbg !401
  %15 = load i64, i64* %14, align 8, !dbg !401
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !402
  br label %17, !dbg !403

17:                                               ; preds = %10
  %18 = load i64, i64* %5, align 8, !dbg !404
  %19 = add i64 %18, 1, !dbg !404
  store i64 %19, i64* %5, align 8, !dbg !404
  br label %6, !dbg !405, !llvm.loop !406

20:                                               ; preds = %6
  ret void, !dbg !408
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !409 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.run_info_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !410, metadata !DIExpression()), !dbg !411
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !412, metadata !DIExpression()), !dbg !413
  %4 = load i8*, i8** %2, align 8, !dbg !414
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !415
  store %struct.run_info_t* %5, %struct.run_info_t** %3, align 8, !dbg !413
  %6 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !416
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %6, i32 0, i32 2, !dbg !418
  %8 = load i8, i8* %7, align 8, !dbg !418
  %9 = trunc i8 %8 to i1, !dbg !418
  br i1 %9, label %10, label %14, !dbg !419

10:                                               ; preds = %1
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !420
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i32 0, i32 1, !dbg !421
  %13 = load i64, i64* %12, align 8, !dbg !421
  call void @set_cpu_affinity(i64 noundef %13), !dbg !422
  br label %14, !dbg !422

14:                                               ; preds = %10, %1
  %15 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !423
  %16 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %15, i32 0, i32 3, !dbg !424
  %17 = load i8* (i8*)*, i8* (i8*)** %16, align 8, !dbg !424
  %18 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !425
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %18, i32 0, i32 1, !dbg !426
  %20 = load i64, i64* %19, align 8, !dbg !426
  %21 = inttoptr i64 %20 to i8*, !dbg !427
  %22 = call i8* %17(i8* noundef %21), !dbg !423
  ret i8* %22, !dbg !428
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !429 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !432, metadata !DIExpression()), !dbg !433
  br label %3, !dbg !434

3:                                                ; preds = %1
  br label %4, !dbg !435

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !437
  br label %6, !dbg !437

6:                                                ; preds = %4
  br label %7, !dbg !439

7:                                                ; preds = %6
  br label %8, !dbg !437

8:                                                ; preds = %7
  br label %9, !dbg !435

9:                                                ; preds = %8
  ret void, !dbg !441
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
!llvm.module.flags = !{!51, !52, !53, !54, !55, !56, !57}
!llvm.ident = !{!58}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_once", scope: !2, file: !34, line: 9, type: !49, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !31, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/thread/verify/once.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "8528125a50ba0473c799ccf7b33a3c90")
!4 = !{!5, !10, !13, !14}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsize_t", file: !6, line: 43, baseType: !7)
!6 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !8, line: 46, baseType: !9)
!8 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!9 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !6, line: 37, baseType: !11)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !12, line: 90, baseType: !9)
!12 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "run_info_t", file: !16, line: 38, baseType: !17)
!16 = !DIFile(filename: "utils/include/test/thread_launcher.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "b854c1934ab1739fab93f88f22662d53")
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !16, line: 33, size: 256, elements: !18)
!18 = !{!19, !22, !23, !26}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "t", scope: !17, file: !16, line: 34, baseType: !20, size: 64)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !21, line: 27, baseType: !9)
!21 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!22 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !17, file: !16, line: 35, baseType: !5, size: 64, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "assign_me_to_core", scope: !17, file: !16, line: 36, baseType: !24, size: 8, offset: 128)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !6, line: 44, baseType: !25)
!25 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "run_fun", scope: !17, file: !16, line: 37, baseType: !27, size: 64, offset: 192)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "thread_fun_t", file: !16, line: 30, baseType: !28)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!29 = !DISubroutineType(types: !30)
!30 = !{!13, !13}
!31 = !{!0, !32, !35}
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "g_winner", scope: !2, file: !34, line: 10, type: !5, isLocal: false, isDefinition: true)
!34 = !DIFile(filename: "thread/verify/once.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "8528125a50ba0473c799ccf7b33a3c90")
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "signal", scope: !2, file: !37, line: 22, type: !38, isLocal: true, isDefinition: true)
!37 = !DIFile(filename: "thread/include/vsync/thread/internal/futex.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "dede791c10be6385ed442bbae7c7e9b0")
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !39, line: 34, baseType: !40)
!39 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !39, line: 32, size: 32, align: 32, elements: !41)
!41 = !{!42}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !40, file: !39, line: 33, baseType: !43, size: 32)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !6, line: 35, baseType: !44)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !45, line: 26, baseType: !46)
!45 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !47, line: 42, baseType: !48)
!47 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!48 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "vonce_t", file: !50, line: 24, baseType: !38)
!50 = !DIFile(filename: "thread/include/vsync/thread/once.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "8277bd75304979bfa762dc0a4c509ee4")
!51 = !{i32 7, !"Dwarf Version", i32 5}
!52 = !{i32 2, !"Debug Info Version", i32 3}
!53 = !{i32 1, !"wchar_size", i32 4}
!54 = !{i32 7, !"PIC Level", i32 2}
!55 = !{i32 7, !"PIE Level", i32 2}
!56 = !{i32 7, !"uwtable", i32 1}
!57 = !{i32 7, !"frame-pointer", i32 2}
!58 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!59 = distinct !DISubprogram(name: "__once_verification_cb", scope: !34, file: !34, line: 13, type: !29, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!60 = !{}
!61 = !DILocalVariable(name: "arg", arg: 1, scope: !59, file: !34, line: 13, type: !13)
!62 = !DILocation(line: 13, column: 30, scope: !59)
!63 = !DILocation(line: 15, column: 37, scope: !59)
!64 = !DILocation(line: 15, column: 25, scope: !59)
!65 = !DILocation(line: 15, column: 14, scope: !59)
!66 = !DILocation(line: 16, column: 5, scope: !67)
!67 = distinct !DILexicalBlock(scope: !68, file: !34, line: 16, column: 5)
!68 = distinct !DILexicalBlock(scope: !59, file: !34, line: 16, column: 5)
!69 = !DILocation(line: 16, column: 5, scope: !68)
!70 = !DILocation(line: 17, column: 12, scope: !59)
!71 = !DILocation(line: 17, column: 5, scope: !59)
!72 = distinct !DISubprogram(name: "run", scope: !34, file: !34, line: 21, type: !29, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!73 = !DILocalVariable(name: "arg", arg: 1, scope: !72, file: !34, line: 21, type: !13)
!74 = !DILocation(line: 21, column: 11, scope: !72)
!75 = !DILocalVariable(name: "tid", scope: !72, file: !34, line: 23, type: !5)
!76 = !DILocation(line: 23, column: 13, scope: !72)
!77 = !DILocation(line: 23, column: 41, scope: !72)
!78 = !DILocation(line: 23, column: 29, scope: !72)
!79 = !DILocation(line: 23, column: 46, scope: !72)
!80 = !DILocation(line: 24, column: 5, scope: !81)
!81 = distinct !DILexicalBlock(scope: !82, file: !34, line: 24, column: 5)
!82 = distinct !DILexicalBlock(scope: !72, file: !34, line: 24, column: 5)
!83 = !DILocation(line: 24, column: 5, scope: !82)
!84 = !DILocalVariable(name: "r", scope: !72, file: !34, line: 26, type: !13)
!85 = !DILocation(line: 26, column: 11, scope: !72)
!86 = !DILocation(line: 27, column: 73, scope: !72)
!87 = !DILocation(line: 27, column: 53, scope: !72)
!88 = !DILocation(line: 27, column: 9, scope: !72)
!89 = !DILocation(line: 29, column: 9, scope: !90)
!90 = distinct !DILexicalBlock(scope: !72, file: !34, line: 29, column: 9)
!91 = !DILocation(line: 29, column: 11, scope: !90)
!92 = !DILocation(line: 29, column: 9, scope: !72)
!93 = !DILocation(line: 31, column: 9, scope: !94)
!94 = distinct !DILexicalBlock(scope: !95, file: !34, line: 31, column: 9)
!95 = distinct !DILexicalBlock(scope: !96, file: !34, line: 31, column: 9)
!96 = distinct !DILexicalBlock(scope: !90, file: !34, line: 29, column: 20)
!97 = !DILocation(line: 31, column: 9, scope: !95)
!98 = !DILocation(line: 32, column: 9, scope: !99)
!99 = distinct !DILexicalBlock(scope: !100, file: !34, line: 32, column: 9)
!100 = distinct !DILexicalBlock(scope: !96, file: !34, line: 32, column: 9)
!101 = !DILocation(line: 32, column: 9, scope: !100)
!102 = !DILocation(line: 33, column: 5, scope: !96)
!103 = !DILocation(line: 35, column: 9, scope: !104)
!104 = distinct !DILexicalBlock(scope: !105, file: !34, line: 35, column: 9)
!105 = distinct !DILexicalBlock(scope: !106, file: !34, line: 35, column: 9)
!106 = distinct !DILexicalBlock(scope: !90, file: !34, line: 33, column: 12)
!107 = !DILocation(line: 35, column: 9, scope: !105)
!108 = !DILocation(line: 37, column: 5, scope: !72)
!109 = distinct !DISubprogram(name: "vonce_call", scope: !50, file: !50, line: 51, type: !110, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!110 = !DISubroutineType(types: !111)
!111 = !{!13, !112, !113, !13}
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "vonce_cb", file: !50, line: 32, baseType: !28)
!114 = !DILocalVariable(name: "o", arg: 1, scope: !109, file: !50, line: 51, type: !112)
!115 = !DILocation(line: 51, column: 21, scope: !109)
!116 = !DILocalVariable(name: "cb", arg: 2, scope: !109, file: !50, line: 51, type: !113)
!117 = !DILocation(line: 51, column: 33, scope: !109)
!118 = !DILocalVariable(name: "arg", arg: 3, scope: !109, file: !50, line: 51, type: !13)
!119 = !DILocation(line: 51, column: 43, scope: !109)
!120 = !DILocalVariable(name: "ret", scope: !109, file: !50, line: 53, type: !13)
!121 = !DILocation(line: 53, column: 11, scope: !109)
!122 = !DILocalVariable(name: "state", scope: !109, file: !50, line: 54, type: !43)
!123 = !DILocation(line: 54, column: 15, scope: !109)
!124 = !DILocation(line: 56, column: 28, scope: !125)
!125 = distinct !DILexicalBlock(scope: !109, file: !50, line: 56, column: 9)
!126 = !DILocation(line: 56, column: 9, scope: !125)
!127 = !DILocation(line: 56, column: 31, scope: !125)
!128 = !DILocation(line: 56, column: 9, scope: !109)
!129 = !DILocation(line: 57, column: 9, scope: !130)
!130 = distinct !DILexicalBlock(scope: !125, file: !50, line: 56, column: 46)
!131 = !DILocation(line: 60, column: 35, scope: !109)
!132 = !DILocation(line: 60, column: 13, scope: !109)
!133 = !DILocation(line: 60, column: 11, scope: !109)
!134 = !DILocation(line: 61, column: 9, scope: !135)
!135 = distinct !DILexicalBlock(scope: !109, file: !50, line: 61, column: 9)
!136 = !DILocation(line: 61, column: 15, scope: !135)
!137 = !DILocation(line: 61, column: 9, scope: !109)
!138 = !DILocation(line: 63, column: 38, scope: !139)
!139 = distinct !DILexicalBlock(scope: !135, file: !50, line: 61, column: 30)
!140 = !DILocation(line: 63, column: 15, scope: !139)
!141 = !DILocation(line: 63, column: 13, scope: !139)
!142 = !DILocation(line: 67, column: 29, scope: !139)
!143 = !DILocation(line: 67, column: 9, scope: !139)
!144 = !DILocation(line: 68, column: 21, scope: !139)
!145 = !DILocation(line: 68, column: 9, scope: !139)
!146 = !DILocation(line: 69, column: 16, scope: !139)
!147 = !DILocation(line: 69, column: 9, scope: !139)
!148 = !DILocation(line: 72, column: 5, scope: !109)
!149 = !DILocation(line: 72, column: 12, scope: !109)
!150 = !DILocation(line: 72, column: 18, scope: !109)
!151 = !DILocation(line: 73, column: 21, scope: !152)
!152 = distinct !DILexicalBlock(scope: !109, file: !50, line: 72, column: 33)
!153 = !DILocation(line: 73, column: 9, scope: !152)
!154 = !DILocation(line: 74, column: 36, scope: !152)
!155 = !DILocation(line: 74, column: 17, scope: !152)
!156 = !DILocation(line: 74, column: 15, scope: !152)
!157 = distinct !{!157, !148, !158, !159}
!158 = !DILocation(line: 75, column: 5, scope: !109)
!159 = !{!"llvm.loop.mustprogress"}
!160 = !DILocation(line: 76, column: 12, scope: !109)
!161 = !DILocation(line: 76, column: 5, scope: !109)
!162 = !DILocation(line: 77, column: 1, scope: !109)
!163 = distinct !DISubprogram(name: "main", scope: !34, file: !34, line: 41, type: !164, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !60)
!164 = !DISubroutineType(types: !165)
!165 = !{!166}
!166 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!167 = !DILocation(line: 43, column: 5, scope: !163)
!168 = !DILocation(line: 44, column: 5, scope: !163)
!169 = distinct !DISubprogram(name: "launch_threads", scope: !16, file: !16, line: 111, type: !170, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!170 = !DISubroutineType(types: !171)
!171 = !{null, !5, !27}
!172 = !DILocalVariable(name: "thread_count", arg: 1, scope: !169, file: !16, line: 111, type: !5)
!173 = !DILocation(line: 111, column: 24, scope: !169)
!174 = !DILocalVariable(name: "fun", arg: 2, scope: !169, file: !16, line: 111, type: !27)
!175 = !DILocation(line: 111, column: 51, scope: !169)
!176 = !DILocalVariable(name: "threads", scope: !169, file: !16, line: 113, type: !14)
!177 = !DILocation(line: 113, column: 17, scope: !169)
!178 = !DILocation(line: 113, column: 55, scope: !169)
!179 = !DILocation(line: 113, column: 53, scope: !169)
!180 = !DILocation(line: 113, column: 27, scope: !169)
!181 = !DILocation(line: 115, column: 20, scope: !169)
!182 = !DILocation(line: 115, column: 29, scope: !169)
!183 = !DILocation(line: 115, column: 43, scope: !169)
!184 = !DILocation(line: 115, column: 5, scope: !169)
!185 = !DILocation(line: 117, column: 19, scope: !169)
!186 = !DILocation(line: 117, column: 28, scope: !169)
!187 = !DILocation(line: 117, column: 5, scope: !169)
!188 = !DILocation(line: 119, column: 10, scope: !169)
!189 = !DILocation(line: 119, column: 5, scope: !169)
!190 = !DILocation(line: 120, column: 1, scope: !169)
!191 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !192, file: !192, line: 85, type: !193, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!192 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!193 = !DISubroutineType(types: !194)
!194 = !{!43, !195}
!195 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !196, size: 64)
!196 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !38)
!197 = !DILocalVariable(name: "a", arg: 1, scope: !191, file: !192, line: 85, type: !195)
!198 = !DILocation(line: 85, column: 39, scope: !191)
!199 = !DILocalVariable(name: "val", scope: !191, file: !192, line: 87, type: !43)
!200 = !DILocation(line: 87, column: 15, scope: !191)
!201 = !DILocation(line: 90, column: 32, scope: !191)
!202 = !DILocation(line: 90, column: 35, scope: !191)
!203 = !DILocation(line: 88, column: 5, scope: !191)
!204 = !{i64 598858}
!205 = !DILocation(line: 92, column: 12, scope: !191)
!206 = !DILocation(line: 92, column: 5, scope: !191)
!207 = distinct !DISubprogram(name: "vatomic32_cmpxchg_acq", scope: !208, file: !208, line: 311, type: !209, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!208 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!209 = !DISubroutineType(types: !210)
!210 = !{!43, !211, !43, !43}
!211 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!212 = !DILocalVariable(name: "a", arg: 1, scope: !207, file: !208, line: 311, type: !211)
!213 = !DILocation(line: 311, column: 36, scope: !207)
!214 = !DILocalVariable(name: "e", arg: 2, scope: !207, file: !208, line: 311, type: !43)
!215 = !DILocation(line: 311, column: 49, scope: !207)
!216 = !DILocalVariable(name: "v", arg: 3, scope: !207, file: !208, line: 311, type: !43)
!217 = !DILocation(line: 311, column: 62, scope: !207)
!218 = !DILocalVariable(name: "oldv", scope: !207, file: !208, line: 313, type: !43)
!219 = !DILocation(line: 313, column: 15, scope: !207)
!220 = !DILocalVariable(name: "tmp", scope: !207, file: !208, line: 314, type: !43)
!221 = !DILocation(line: 314, column: 15, scope: !207)
!222 = !DILocation(line: 325, column: 22, scope: !207)
!223 = !DILocation(line: 325, column: 36, scope: !207)
!224 = !DILocation(line: 325, column: 48, scope: !207)
!225 = !DILocation(line: 325, column: 51, scope: !207)
!226 = !DILocation(line: 315, column: 5, scope: !207)
!227 = !{i64 664268, i64 664302, i64 664317, i64 664350, i64 664384, i64 664404, i64 664446, i64 664475}
!228 = !DILocation(line: 327, column: 12, scope: !207)
!229 = !DILocation(line: 327, column: 5, scope: !207)
!230 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !192, file: !192, line: 227, type: !231, scopeLine: 228, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!231 = !DISubroutineType(types: !232)
!232 = !{null, !211, !43}
!233 = !DILocalVariable(name: "a", arg: 1, scope: !230, file: !192, line: 227, type: !211)
!234 = !DILocation(line: 227, column: 34, scope: !230)
!235 = !DILocalVariable(name: "v", arg: 2, scope: !230, file: !192, line: 227, type: !43)
!236 = !DILocation(line: 227, column: 47, scope: !230)
!237 = !DILocation(line: 231, column: 32, scope: !230)
!238 = !DILocation(line: 231, column: 44, scope: !230)
!239 = !DILocation(line: 231, column: 47, scope: !230)
!240 = !DILocation(line: 229, column: 5, scope: !230)
!241 = !{i64 603274}
!242 = !DILocation(line: 233, column: 1, scope: !230)
!243 = distinct !DISubprogram(name: "vfutex_wake", scope: !37, file: !37, line: 34, type: !231, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!244 = !DILocalVariable(name: "m", arg: 1, scope: !243, file: !37, line: 34, type: !211)
!245 = !DILocation(line: 34, column: 26, scope: !243)
!246 = !DILocalVariable(name: "v", arg: 2, scope: !243, file: !37, line: 34, type: !43)
!247 = !DILocation(line: 34, column: 39, scope: !243)
!248 = !DILocation(line: 36, column: 5, scope: !243)
!249 = !DILocation(line: 37, column: 1, scope: !243)
!250 = distinct !DISubprogram(name: "vfutex_wait", scope: !37, file: !37, line: 25, type: !231, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!251 = !DILocalVariable(name: "m", arg: 1, scope: !250, file: !37, line: 25, type: !211)
!252 = !DILocation(line: 25, column: 26, scope: !250)
!253 = !DILocalVariable(name: "v", arg: 2, scope: !250, file: !37, line: 25, type: !43)
!254 = !DILocation(line: 25, column: 39, scope: !250)
!255 = !DILocalVariable(name: "s", scope: !250, file: !37, line: 27, type: !43)
!256 = !DILocation(line: 27, column: 15, scope: !250)
!257 = !DILocation(line: 27, column: 19, scope: !250)
!258 = !DILocation(line: 28, column: 28, scope: !259)
!259 = distinct !DILexicalBlock(scope: !250, file: !37, line: 28, column: 9)
!260 = !DILocation(line: 28, column: 9, scope: !259)
!261 = !DILocation(line: 28, column: 34, scope: !259)
!262 = !DILocation(line: 28, column: 31, scope: !259)
!263 = !DILocation(line: 28, column: 9, scope: !250)
!264 = !DILocation(line: 29, column: 9, scope: !259)
!265 = !DILocation(line: 30, column: 38, scope: !250)
!266 = !DILocation(line: 30, column: 5, scope: !250)
!267 = !DILocation(line: 31, column: 1, scope: !250)
!268 = distinct !DISubprogram(name: "vatomic32_inc_rel", scope: !269, file: !269, line: 2945, type: !270, scopeLine: 2946, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!269 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!270 = !DISubroutineType(types: !271)
!271 = !{null, !211}
!272 = !DILocalVariable(name: "a", arg: 1, scope: !268, file: !269, line: 2945, type: !211)
!273 = !DILocation(line: 2945, column: 32, scope: !268)
!274 = !DILocation(line: 2947, column: 33, scope: !268)
!275 = !DILocation(line: 2947, column: 11, scope: !268)
!276 = !DILocation(line: 2948, column: 1, scope: !268)
!277 = distinct !DISubprogram(name: "vatomic32_get_inc_rel", scope: !269, file: !269, line: 2505, type: !278, scopeLine: 2506, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!278 = !DISubroutineType(types: !279)
!279 = !{!43, !211}
!280 = !DILocalVariable(name: "a", arg: 1, scope: !277, file: !269, line: 2505, type: !211)
!281 = !DILocation(line: 2505, column: 36, scope: !277)
!282 = !DILocation(line: 2507, column: 34, scope: !277)
!283 = !DILocation(line: 2507, column: 12, scope: !277)
!284 = !DILocation(line: 2507, column: 5, scope: !277)
!285 = distinct !DISubprogram(name: "vatomic32_get_add_rel", scope: !208, file: !208, line: 1263, type: !286, scopeLine: 1264, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!286 = !DISubroutineType(types: !287)
!287 = !{!43, !211, !43}
!288 = !DILocalVariable(name: "a", arg: 1, scope: !285, file: !208, line: 1263, type: !211)
!289 = !DILocation(line: 1263, column: 36, scope: !285)
!290 = !DILocalVariable(name: "v", arg: 2, scope: !285, file: !208, line: 1263, type: !43)
!291 = !DILocation(line: 1263, column: 49, scope: !285)
!292 = !DILocalVariable(name: "oldv", scope: !285, file: !208, line: 1265, type: !43)
!293 = !DILocation(line: 1265, column: 15, scope: !285)
!294 = !DILocalVariable(name: "tmp", scope: !285, file: !208, line: 1266, type: !43)
!295 = !DILocation(line: 1266, column: 15, scope: !285)
!296 = !DILocalVariable(name: "newv", scope: !285, file: !208, line: 1267, type: !43)
!297 = !DILocation(line: 1267, column: 15, scope: !285)
!298 = !DILocation(line: 1268, column: 5, scope: !285)
!299 = !DILocation(line: 1276, column: 19, scope: !285)
!300 = !DILocation(line: 1276, column: 22, scope: !285)
!301 = !{i64 692654, i64 692688, i64 692703, i64 692735, i64 692777, i64 692819}
!302 = !DILocation(line: 1279, column: 12, scope: !285)
!303 = !DILocation(line: 1279, column: 5, scope: !285)
!304 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !192, file: !192, line: 101, type: !193, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!305 = !DILocalVariable(name: "a", arg: 1, scope: !304, file: !192, line: 101, type: !195)
!306 = !DILocation(line: 101, column: 39, scope: !304)
!307 = !DILocalVariable(name: "val", scope: !304, file: !192, line: 103, type: !43)
!308 = !DILocation(line: 103, column: 15, scope: !304)
!309 = !DILocation(line: 106, column: 32, scope: !304)
!310 = !DILocation(line: 106, column: 35, scope: !304)
!311 = !DILocation(line: 104, column: 5, scope: !304)
!312 = !{i64 599360}
!313 = !DILocation(line: 108, column: 12, scope: !304)
!314 = !DILocation(line: 108, column: 5, scope: !304)
!315 = distinct !DISubprogram(name: "vatomic32_await_neq_rlx", scope: !192, file: !192, line: 912, type: !316, scopeLine: 913, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!316 = !DISubroutineType(types: !317)
!317 = !{!43, !195, !43}
!318 = !DILocalVariable(name: "a", arg: 1, scope: !315, file: !192, line: 912, type: !195)
!319 = !DILocation(line: 912, column: 44, scope: !315)
!320 = !DILocalVariable(name: "v", arg: 2, scope: !315, file: !192, line: 912, type: !43)
!321 = !DILocation(line: 912, column: 57, scope: !315)
!322 = !DILocalVariable(name: "val", scope: !315, file: !192, line: 914, type: !43)
!323 = !DILocation(line: 914, column: 15, scope: !315)
!324 = !DILocation(line: 921, column: 21, scope: !315)
!325 = !DILocation(line: 921, column: 33, scope: !315)
!326 = !DILocation(line: 921, column: 36, scope: !315)
!327 = !DILocation(line: 915, column: 5, scope: !315)
!328 = !{i64 621966, i64 621982, i64 622012, i64 622045}
!329 = !DILocation(line: 923, column: 12, scope: !315)
!330 = !DILocation(line: 923, column: 5, scope: !315)
!331 = distinct !DISubprogram(name: "create_threads", scope: !16, file: !16, line: 83, type: !332, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!332 = !DISubroutineType(types: !333)
!333 = !{null, !14, !5, !27, !24}
!334 = !DILocalVariable(name: "threads", arg: 1, scope: !331, file: !16, line: 83, type: !14)
!335 = !DILocation(line: 83, column: 28, scope: !331)
!336 = !DILocalVariable(name: "num_threads", arg: 2, scope: !331, file: !16, line: 83, type: !5)
!337 = !DILocation(line: 83, column: 45, scope: !331)
!338 = !DILocalVariable(name: "fun", arg: 3, scope: !331, file: !16, line: 83, type: !27)
!339 = !DILocation(line: 83, column: 71, scope: !331)
!340 = !DILocalVariable(name: "bind", arg: 4, scope: !331, file: !16, line: 84, type: !24)
!341 = !DILocation(line: 84, column: 24, scope: !331)
!342 = !DILocalVariable(name: "i", scope: !331, file: !16, line: 86, type: !5)
!343 = !DILocation(line: 86, column: 13, scope: !331)
!344 = !DILocation(line: 87, column: 12, scope: !345)
!345 = distinct !DILexicalBlock(scope: !331, file: !16, line: 87, column: 5)
!346 = !DILocation(line: 87, column: 10, scope: !345)
!347 = !DILocation(line: 87, column: 17, scope: !348)
!348 = distinct !DILexicalBlock(scope: !345, file: !16, line: 87, column: 5)
!349 = !DILocation(line: 87, column: 21, scope: !348)
!350 = !DILocation(line: 87, column: 19, scope: !348)
!351 = !DILocation(line: 87, column: 5, scope: !345)
!352 = !DILocation(line: 88, column: 40, scope: !353)
!353 = distinct !DILexicalBlock(scope: !348, file: !16, line: 87, column: 39)
!354 = !DILocation(line: 88, column: 9, scope: !353)
!355 = !DILocation(line: 88, column: 17, scope: !353)
!356 = !DILocation(line: 88, column: 20, scope: !353)
!357 = !DILocation(line: 88, column: 38, scope: !353)
!358 = !DILocation(line: 89, column: 40, scope: !353)
!359 = !DILocation(line: 89, column: 9, scope: !353)
!360 = !DILocation(line: 89, column: 17, scope: !353)
!361 = !DILocation(line: 89, column: 20, scope: !353)
!362 = !DILocation(line: 89, column: 38, scope: !353)
!363 = !DILocation(line: 90, column: 40, scope: !353)
!364 = !DILocation(line: 90, column: 9, scope: !353)
!365 = !DILocation(line: 90, column: 17, scope: !353)
!366 = !DILocation(line: 90, column: 20, scope: !353)
!367 = !DILocation(line: 90, column: 38, scope: !353)
!368 = !DILocation(line: 91, column: 25, scope: !353)
!369 = !DILocation(line: 91, column: 33, scope: !353)
!370 = !DILocation(line: 91, column: 36, scope: !353)
!371 = !DILocation(line: 91, column: 55, scope: !353)
!372 = !DILocation(line: 91, column: 63, scope: !353)
!373 = !DILocation(line: 91, column: 54, scope: !353)
!374 = !DILocation(line: 91, column: 9, scope: !353)
!375 = !DILocation(line: 92, column: 5, scope: !353)
!376 = !DILocation(line: 87, column: 35, scope: !348)
!377 = !DILocation(line: 87, column: 5, scope: !348)
!378 = distinct !{!378, !351, !379, !159}
!379 = !DILocation(line: 92, column: 5, scope: !345)
!380 = !DILocation(line: 94, column: 1, scope: !331)
!381 = distinct !DISubprogram(name: "await_threads", scope: !16, file: !16, line: 97, type: !382, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!382 = !DISubroutineType(types: !383)
!383 = !{null, !14, !5}
!384 = !DILocalVariable(name: "threads", arg: 1, scope: !381, file: !16, line: 97, type: !14)
!385 = !DILocation(line: 97, column: 27, scope: !381)
!386 = !DILocalVariable(name: "num_threads", arg: 2, scope: !381, file: !16, line: 97, type: !5)
!387 = !DILocation(line: 97, column: 44, scope: !381)
!388 = !DILocalVariable(name: "i", scope: !381, file: !16, line: 99, type: !5)
!389 = !DILocation(line: 99, column: 13, scope: !381)
!390 = !DILocation(line: 100, column: 12, scope: !391)
!391 = distinct !DILexicalBlock(scope: !381, file: !16, line: 100, column: 5)
!392 = !DILocation(line: 100, column: 10, scope: !391)
!393 = !DILocation(line: 100, column: 17, scope: !394)
!394 = distinct !DILexicalBlock(scope: !391, file: !16, line: 100, column: 5)
!395 = !DILocation(line: 100, column: 21, scope: !394)
!396 = !DILocation(line: 100, column: 19, scope: !394)
!397 = !DILocation(line: 100, column: 5, scope: !391)
!398 = !DILocation(line: 101, column: 22, scope: !399)
!399 = distinct !DILexicalBlock(scope: !394, file: !16, line: 100, column: 39)
!400 = !DILocation(line: 101, column: 30, scope: !399)
!401 = !DILocation(line: 101, column: 33, scope: !399)
!402 = !DILocation(line: 101, column: 9, scope: !399)
!403 = !DILocation(line: 102, column: 5, scope: !399)
!404 = !DILocation(line: 100, column: 35, scope: !394)
!405 = !DILocation(line: 100, column: 5, scope: !394)
!406 = distinct !{!406, !397, !407, !159}
!407 = !DILocation(line: 102, column: 5, scope: !391)
!408 = !DILocation(line: 103, column: 1, scope: !381)
!409 = distinct !DISubprogram(name: "common_run", scope: !16, file: !16, line: 43, type: !29, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!410 = !DILocalVariable(name: "args", arg: 1, scope: !409, file: !16, line: 43, type: !13)
!411 = !DILocation(line: 43, column: 18, scope: !409)
!412 = !DILocalVariable(name: "run_info", scope: !409, file: !16, line: 45, type: !14)
!413 = !DILocation(line: 45, column: 17, scope: !409)
!414 = !DILocation(line: 45, column: 42, scope: !409)
!415 = !DILocation(line: 45, column: 28, scope: !409)
!416 = !DILocation(line: 47, column: 9, scope: !417)
!417 = distinct !DILexicalBlock(scope: !409, file: !16, line: 47, column: 9)
!418 = !DILocation(line: 47, column: 19, scope: !417)
!419 = !DILocation(line: 47, column: 9, scope: !409)
!420 = !DILocation(line: 48, column: 26, scope: !417)
!421 = !DILocation(line: 48, column: 36, scope: !417)
!422 = !DILocation(line: 48, column: 9, scope: !417)
!423 = !DILocation(line: 52, column: 12, scope: !409)
!424 = !DILocation(line: 52, column: 22, scope: !409)
!425 = !DILocation(line: 52, column: 38, scope: !409)
!426 = !DILocation(line: 52, column: 48, scope: !409)
!427 = !DILocation(line: 52, column: 30, scope: !409)
!428 = !DILocation(line: 52, column: 5, scope: !409)
!429 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !16, file: !16, line: 61, type: !430, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !60)
!430 = !DISubroutineType(types: !431)
!431 = !{null, !5}
!432 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !429, file: !16, line: 61, type: !5)
!433 = !DILocation(line: 61, column: 26, scope: !429)
!434 = !DILocation(line: 78, column: 5, scope: !429)
!435 = !DILocation(line: 78, column: 5, scope: !436)
!436 = distinct !DILexicalBlock(scope: !429, file: !16, line: 78, column: 5)
!437 = !DILocation(line: 78, column: 5, scope: !438)
!438 = distinct !DILexicalBlock(scope: !436, file: !16, line: 78, column: 5)
!439 = !DILocation(line: 78, column: 5, scope: !440)
!440 = distinct !DILexicalBlock(scope: !438, file: !16, line: 78, column: 5)
!441 = !DILocation(line: 80, column: 1, scope: !429)
