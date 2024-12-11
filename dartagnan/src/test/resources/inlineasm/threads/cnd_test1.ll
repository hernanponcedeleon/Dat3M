; ModuleID = '/home/stefano/huawei/libvsync/thread/verify/cnd_test1.c'
source_filename = "/home/stefano/huawei/libvsync/thread/verify/cnd_test1.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%struct.vcond_s = type { %struct.vatomic32_s }
%struct.vatomic32_s = type { i32 }
%struct.run_info_t = type { i64, i64, i8, i8* (i8*)* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !0
@g_cs_x = dso_local global i32 0, align 4, !dbg !48
@g_cond = dso_local global %struct.vcond_s zeroinitializer, align 4, !dbg !29
@g_cs_y = dso_local global i32 0, align 4, !dbg !51
@.str = private unnamed_addr constant [12 x i8] c"g_cs_x == 2\00", align 1
@.str.1 = private unnamed_addr constant [56 x i8] c"/home/stefano/huawei/libvsync/thread/verify/cnd_test1.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"g_cs_y == -1\00", align 1
@signal = internal global %struct.vatomic32_s zeroinitializer, align 4, !dbg !53

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !96 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !98, metadata !DIExpression()), !dbg !99
  call void @vmutex_acquire(%union.pthread_mutex_t* noundef @g_mutex), !dbg !100
  %3 = load i32, i32* @g_cs_x, align 4, !dbg !101
  %4 = add nsw i32 %3, 1, !dbg !101
  store i32 %4, i32* @g_cs_x, align 4, !dbg !101
  %5 = icmp slt i32 %3, 1, !dbg !103
  br i1 %5, label %6, label %14, !dbg !104

6:                                                ; preds = %1
  br label %7, !dbg !105

7:                                                ; preds = %10, %6
  %8 = load i32, i32* @g_cs_x, align 4, !dbg !107
  %9 = icmp ne i32 %8, 2, !dbg !108
  br i1 %9, label %10, label %11, !dbg !105

10:                                               ; preds = %7
  call void @vcond_wait(%struct.vcond_s* noundef @g_cond, %union.pthread_mutex_t* noundef @g_mutex), !dbg !109
  br label %7, !dbg !105, !llvm.loop !111

11:                                               ; preds = %7
  %12 = load i32, i32* @g_cs_y, align 4, !dbg !114
  %13 = add nsw i32 %12, 1, !dbg !114
  store i32 %13, i32* @g_cs_y, align 4, !dbg !114
  br label %17, !dbg !115

14:                                               ; preds = %1
  %15 = load i32, i32* @g_cs_y, align 4, !dbg !116
  %16 = sub nsw i32 %15, 2, !dbg !116
  store i32 %16, i32* @g_cs_y, align 4, !dbg !116
  br label %17

17:                                               ; preds = %14, %11
  call void @vmutex_release(%union.pthread_mutex_t* noundef @g_mutex), !dbg !118
  call void @vcond_signal(%struct.vcond_s* noundef @g_cond), !dbg !119
  br label %18, !dbg !120

18:                                               ; preds = %17
  br label %19, !dbg !121

19:                                               ; preds = %18
  %20 = load i8*, i8** %2, align 8, !dbg !123
  br label %21, !dbg !123

21:                                               ; preds = %19
  br label %22, !dbg !125

22:                                               ; preds = %21
  br label %23, !dbg !123

23:                                               ; preds = %22
  br label %24, !dbg !121

24:                                               ; preds = %23
  ret i8* null, !dbg !127
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @vmutex_acquire(%union.pthread_mutex_t* noundef %0) #0 !dbg !128 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !132, metadata !DIExpression()), !dbg !133
  %3 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !134
  %4 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef %3) #5, !dbg !135
  ret void, !dbg !136
}

; Function Attrs: noinline nounwind uwtable
define internal void @vcond_wait(%struct.vcond_s* noundef %0, %union.pthread_mutex_t* noundef %1) #0 !dbg !137 {
  %3 = alloca %struct.vcond_s*, align 8
  %4 = alloca %union.pthread_mutex_t*, align 8
  %5 = alloca i32, align 4
  store %struct.vcond_s* %0, %struct.vcond_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vcond_s** %3, metadata !141, metadata !DIExpression()), !dbg !142
  store %union.pthread_mutex_t* %1, %union.pthread_mutex_t** %4, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %4, metadata !143, metadata !DIExpression()), !dbg !144
  call void @llvm.dbg.declare(metadata i32* %5, metadata !145, metadata !DIExpression()), !dbg !146
  %6 = load %struct.vcond_s*, %struct.vcond_s** %3, align 8, !dbg !147
  %7 = getelementptr inbounds %struct.vcond_s, %struct.vcond_s* %6, i32 0, i32 0, !dbg !148
  %8 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %7), !dbg !149
  store i32 %8, i32* %5, align 4, !dbg !146
  %9 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %4, align 8, !dbg !150
  call void @vmutex_release(%union.pthread_mutex_t* noundef %9), !dbg !151
  %10 = load %struct.vcond_s*, %struct.vcond_s** %3, align 8, !dbg !152
  %11 = getelementptr inbounds %struct.vcond_s, %struct.vcond_s* %10, i32 0, i32 0, !dbg !153
  %12 = load i32, i32* %5, align 4, !dbg !154
  call void @vfutex_wait(%struct.vatomic32_s* noundef %11, i32 noundef %12), !dbg !155
  %13 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %4, align 8, !dbg !156
  call void @vmutex_acquire(%union.pthread_mutex_t* noundef %13), !dbg !157
  ret void, !dbg !158
}

; Function Attrs: noinline nounwind uwtable
define internal void @vmutex_release(%union.pthread_mutex_t* noundef %0) #0 !dbg !159 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !160, metadata !DIExpression()), !dbg !161
  %3 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !162
  %4 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef %3) #5, !dbg !163
  ret void, !dbg !164
}

; Function Attrs: noinline nounwind uwtable
define internal void @vcond_signal(%struct.vcond_s* noundef %0) #0 !dbg !165 {
  %2 = alloca %struct.vcond_s*, align 8
  store %struct.vcond_s* %0, %struct.vcond_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vcond_s** %2, metadata !168, metadata !DIExpression()), !dbg !169
  %3 = load %struct.vcond_s*, %struct.vcond_s** %2, align 8, !dbg !170
  %4 = getelementptr inbounds %struct.vcond_s, %struct.vcond_s* %3, i32 0, i32 0, !dbg !171
  call void @vatomic32_inc_rlx(%struct.vatomic32_s* noundef %4), !dbg !172
  %5 = load %struct.vcond_s*, %struct.vcond_s** %2, align 8, !dbg !173
  %6 = getelementptr inbounds %struct.vcond_s, %struct.vcond_s* %5, i32 0, i32 0, !dbg !174
  call void @vfutex_wake(%struct.vatomic32_s* noundef %6, i32 noundef 1), !dbg !175
  ret void, !dbg !176
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !177 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @launch_threads(i64 noundef 2, i8* (i8*)* noundef @run), !dbg !180
  %2 = load i32, i32* @g_cs_x, align 4, !dbg !181
  %3 = icmp eq i32 %2, 2, !dbg !181
  br i1 %3, label %4, label %5, !dbg !184

4:                                                ; preds = %0
  br label %6, !dbg !184

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([56 x i8], [56 x i8]* @.str.1, i64 0, i64 0), i32 noundef 42, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !181
  unreachable, !dbg !181

6:                                                ; preds = %4
  %7 = load i32, i32* @g_cs_y, align 4, !dbg !185
  %8 = icmp eq i32 %7, -1, !dbg !185
  br i1 %8, label %9, label %10, !dbg !188

9:                                                ; preds = %6
  br label %11, !dbg !188

10:                                               ; preds = %6
  call void @__assert_fail(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([56 x i8], [56 x i8]* @.str.1, i64 0, i64 0), i32 noundef 43, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !185
  unreachable, !dbg !185

11:                                               ; preds = %9
  ret i32 0, !dbg !189
}

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !190 {
  %3 = alloca i64, align 8
  %4 = alloca i8* (i8*)*, align 8
  %5 = alloca %struct.run_info_t*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !193, metadata !DIExpression()), !dbg !194
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %4, metadata !195, metadata !DIExpression()), !dbg !196
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !197, metadata !DIExpression()), !dbg !198
  %6 = load i64, i64* %3, align 8, !dbg !199
  %7 = mul i64 32, %6, !dbg !200
  %8 = call noalias i8* @malloc(i64 noundef %7) #5, !dbg !201
  %9 = bitcast i8* %8 to %struct.run_info_t*, !dbg !201
  store %struct.run_info_t* %9, %struct.run_info_t** %5, align 8, !dbg !198
  %10 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !202
  %11 = load i64, i64* %3, align 8, !dbg !203
  %12 = load i8* (i8*)*, i8* (i8*)** %4, align 8, !dbg !204
  call void @create_threads(%struct.run_info_t* noundef %10, i64 noundef %11, i8* (i8*)* noundef %12, i1 noundef zeroext true), !dbg !205
  %13 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !206
  %14 = load i64, i64* %3, align 8, !dbg !207
  call void @await_threads(%struct.run_info_t* noundef %13, i64 noundef %14), !dbg !208
  %15 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !209
  %16 = bitcast %struct.run_info_t* %15 to i8*, !dbg !209
  call void @free(i8* noundef %16) #5, !dbg !210
  ret void, !dbg !211
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !212 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !218, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.declare(metadata i32* %3, metadata !220, metadata !DIExpression()), !dbg !221
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !222
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !223
  %6 = load i32, i32* %5, align 4, !dbg !223
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #5, !dbg !224, !srcloc !225
  store i32 %7, i32* %3, align 4, !dbg !224
  %8 = load i32, i32* %3, align 4, !dbg !226
  ret i32 %8, !dbg !227
}

; Function Attrs: noinline nounwind uwtable
define internal void @vfutex_wait(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !228 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !232, metadata !DIExpression()), !dbg !233
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !234, metadata !DIExpression()), !dbg !235
  call void @llvm.dbg.declare(metadata i32* %5, metadata !236, metadata !DIExpression()), !dbg !237
  %6 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef @signal), !dbg !238
  store i32 %6, i32* %5, align 4, !dbg !237
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !239
  %8 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %7), !dbg !241
  %9 = load i32, i32* %4, align 4, !dbg !242
  %10 = icmp ne i32 %8, %9, !dbg !243
  br i1 %10, label %11, label %12, !dbg !244

11:                                               ; preds = %2
  br label %15, !dbg !245

12:                                               ; preds = %2
  %13 = load i32, i32* %5, align 4, !dbg !246
  %14 = call i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef @signal, i32 noundef %13), !dbg !247
  br label %15, !dbg !248

15:                                               ; preds = %12, %11
  ret void, !dbg !248
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !249 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !250, metadata !DIExpression()), !dbg !251
  call void @llvm.dbg.declare(metadata i32* %3, metadata !252, metadata !DIExpression()), !dbg !253
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !254
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !255
  %6 = load i32, i32* %5, align 4, !dbg !255
  %7 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #5, !dbg !256, !srcloc !257
  store i32 %7, i32* %3, align 4, !dbg !256
  %8 = load i32, i32* %3, align 4, !dbg !258
  ret i32 %8, !dbg !259
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !260 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !263, metadata !DIExpression()), !dbg !264
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !265, metadata !DIExpression()), !dbg !266
  call void @llvm.dbg.declare(metadata i32* %5, metadata !267, metadata !DIExpression()), !dbg !268
  %6 = load i32, i32* %4, align 4, !dbg !269
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !270
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !271
  %9 = load i32, i32* %8, align 4, !dbg !271
  %10 = call i32 asm sideeffect "1:\0Aldr ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.eq 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #5, !dbg !272, !srcloc !273
  store i32 %10, i32* %5, align 4, !dbg !272
  %11 = load i32, i32* %5, align 4, !dbg !274
  ret i32 %11, !dbg !275
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_inc_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !276 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !280, metadata !DIExpression()), !dbg !281
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !282
  %4 = call i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %3), !dbg !283
  ret void, !dbg !284
}

; Function Attrs: noinline nounwind uwtable
define internal void @vfutex_wake(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !285 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !286, metadata !DIExpression()), !dbg !287
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !288, metadata !DIExpression()), !dbg !289
  call void @vatomic32_inc_rel(%struct.vatomic32_s* noundef @signal), !dbg !290
  ret void, !dbg !291
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !292 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !295, metadata !DIExpression()), !dbg !296
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !297
  %4 = call i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !298
  ret i32 %4, !dbg !299
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !300 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !304, metadata !DIExpression()), !dbg !305
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !306, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.declare(metadata i32* %5, metadata !308, metadata !DIExpression()), !dbg !309
  call void @llvm.dbg.declare(metadata i32* %6, metadata !310, metadata !DIExpression()), !dbg !311
  call void @llvm.dbg.declare(metadata i32* %7, metadata !312, metadata !DIExpression()), !dbg !313
  %8 = load i32, i32* %4, align 4, !dbg !314
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !315
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !316
  %11 = load i32, i32* %10, align 4, !dbg !316
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #5, !dbg !314, !srcloc !317
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !314
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !314
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !314
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !314
  store i32 %13, i32* %5, align 4, !dbg !314
  store i32 %14, i32* %7, align 4, !dbg !314
  store i32 %15, i32* %6, align 4, !dbg !314
  store i32 %16, i32* %4, align 4, !dbg !314
  %17 = load i32, i32* %5, align 4, !dbg !318
  ret i32 %17, !dbg !319
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !320 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !321, metadata !DIExpression()), !dbg !322
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !323
  %4 = call i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %3), !dbg !324
  ret void, !dbg !325
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !326 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !327, metadata !DIExpression()), !dbg !328
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !329
  %4 = call i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !330
  ret i32 %4, !dbg !331
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !332 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !333, metadata !DIExpression()), !dbg !334
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !335, metadata !DIExpression()), !dbg !336
  call void @llvm.dbg.declare(metadata i32* %5, metadata !337, metadata !DIExpression()), !dbg !338
  call void @llvm.dbg.declare(metadata i32* %6, metadata !339, metadata !DIExpression()), !dbg !340
  call void @llvm.dbg.declare(metadata i32* %7, metadata !341, metadata !DIExpression()), !dbg !342
  %8 = load i32, i32* %4, align 4, !dbg !343
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !344
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !345
  %11 = load i32, i32* %10, align 4, !dbg !345
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astlxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #5, !dbg !343, !srcloc !346
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !343
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !343
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !343
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !343
  store i32 %13, i32* %5, align 4, !dbg !343
  store i32 %14, i32* %7, align 4, !dbg !343
  store i32 %15, i32* %6, align 4, !dbg !343
  store i32 %16, i32* %4, align 4, !dbg !343
  %17 = load i32, i32* %5, align 4, !dbg !347
  ret i32 %17, !dbg !348
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !349 {
  %5 = alloca %struct.run_info_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8* (i8*)*, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !352, metadata !DIExpression()), !dbg !353
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !354, metadata !DIExpression()), !dbg !355
  store i8* (i8*)* %2, i8* (i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %7, metadata !356, metadata !DIExpression()), !dbg !357
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !358, metadata !DIExpression()), !dbg !359
  call void @llvm.dbg.declare(metadata i64* %9, metadata !360, metadata !DIExpression()), !dbg !361
  store i64 0, i64* %9, align 8, !dbg !361
  store i64 0, i64* %9, align 8, !dbg !362
  br label %11, !dbg !364

11:                                               ; preds = %42, %4
  %12 = load i64, i64* %9, align 8, !dbg !365
  %13 = load i64, i64* %6, align 8, !dbg !367
  %14 = icmp ult i64 %12, %13, !dbg !368
  br i1 %14, label %15, label %45, !dbg !369

15:                                               ; preds = %11
  %16 = load i64, i64* %9, align 8, !dbg !370
  %17 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !372
  %18 = load i64, i64* %9, align 8, !dbg !373
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %17, i64 %18, !dbg !372
  %20 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %19, i32 0, i32 1, !dbg !374
  store i64 %16, i64* %20, align 8, !dbg !375
  %21 = load i8* (i8*)*, i8* (i8*)** %7, align 8, !dbg !376
  %22 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !377
  %23 = load i64, i64* %9, align 8, !dbg !378
  %24 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %22, i64 %23, !dbg !377
  %25 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %24, i32 0, i32 3, !dbg !379
  store i8* (i8*)* %21, i8* (i8*)** %25, align 8, !dbg !380
  %26 = load i8, i8* %8, align 1, !dbg !381
  %27 = trunc i8 %26 to i1, !dbg !381
  %28 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !382
  %29 = load i64, i64* %9, align 8, !dbg !383
  %30 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %28, i64 %29, !dbg !382
  %31 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %30, i32 0, i32 2, !dbg !384
  %32 = zext i1 %27 to i8, !dbg !385
  store i8 %32, i8* %31, align 8, !dbg !385
  %33 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !386
  %34 = load i64, i64* %9, align 8, !dbg !387
  %35 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %33, i64 %34, !dbg !386
  %36 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %35, i32 0, i32 0, !dbg !388
  %37 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !389
  %38 = load i64, i64* %9, align 8, !dbg !390
  %39 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %37, i64 %38, !dbg !389
  %40 = bitcast %struct.run_info_t* %39 to i8*, !dbg !391
  %41 = call i32 @pthread_create(i64* noundef %36, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %40) #5, !dbg !392
  br label %42, !dbg !393

42:                                               ; preds = %15
  %43 = load i64, i64* %9, align 8, !dbg !394
  %44 = add i64 %43, 1, !dbg !394
  store i64 %44, i64* %9, align 8, !dbg !394
  br label %11, !dbg !395, !llvm.loop !396

45:                                               ; preds = %11
  ret void, !dbg !398
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !399 {
  %3 = alloca %struct.run_info_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !402, metadata !DIExpression()), !dbg !403
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !404, metadata !DIExpression()), !dbg !405
  call void @llvm.dbg.declare(metadata i64* %5, metadata !406, metadata !DIExpression()), !dbg !407
  store i64 0, i64* %5, align 8, !dbg !407
  store i64 0, i64* %5, align 8, !dbg !408
  br label %6, !dbg !410

6:                                                ; preds = %17, %2
  %7 = load i64, i64* %5, align 8, !dbg !411
  %8 = load i64, i64* %4, align 8, !dbg !413
  %9 = icmp ult i64 %7, %8, !dbg !414
  br i1 %9, label %10, label %20, !dbg !415

10:                                               ; preds = %6
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !416
  %12 = load i64, i64* %5, align 8, !dbg !418
  %13 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i64 %12, !dbg !416
  %14 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %13, i32 0, i32 0, !dbg !419
  %15 = load i64, i64* %14, align 8, !dbg !419
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !420
  br label %17, !dbg !421

17:                                               ; preds = %10
  %18 = load i64, i64* %5, align 8, !dbg !422
  %19 = add i64 %18, 1, !dbg !422
  store i64 %19, i64* %5, align 8, !dbg !422
  br label %6, !dbg !423, !llvm.loop !424

20:                                               ; preds = %6
  ret void, !dbg !426
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !427 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.run_info_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !428, metadata !DIExpression()), !dbg !429
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !430, metadata !DIExpression()), !dbg !431
  %4 = load i8*, i8** %2, align 8, !dbg !432
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !433
  store %struct.run_info_t* %5, %struct.run_info_t** %3, align 8, !dbg !431
  %6 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !434
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %6, i32 0, i32 2, !dbg !436
  %8 = load i8, i8* %7, align 8, !dbg !436
  %9 = trunc i8 %8 to i1, !dbg !436
  br i1 %9, label %10, label %14, !dbg !437

10:                                               ; preds = %1
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !438
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i32 0, i32 1, !dbg !439
  %13 = load i64, i64* %12, align 8, !dbg !439
  call void @set_cpu_affinity(i64 noundef %13), !dbg !440
  br label %14, !dbg !440

14:                                               ; preds = %10, %1
  %15 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !441
  %16 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %15, i32 0, i32 3, !dbg !442
  %17 = load i8* (i8*)*, i8* (i8*)** %16, align 8, !dbg !442
  %18 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !443
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %18, i32 0, i32 1, !dbg !444
  %20 = load i64, i64* %19, align 8, !dbg !444
  %21 = inttoptr i64 %20 to i8*, !dbg !445
  %22 = call i8* %17(i8* noundef %21), !dbg !441
  ret i8* %22, !dbg !446
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !447 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !450, metadata !DIExpression()), !dbg !451
  br label %3, !dbg !452

3:                                                ; preds = %1
  br label %4, !dbg !453

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !455
  br label %6, !dbg !455

6:                                                ; preds = %4
  br label %7, !dbg !457

7:                                                ; preds = %6
  br label %8, !dbg !455

8:                                                ; preds = %7
  br label %9, !dbg !453

9:                                                ; preds = %8
  ret void, !dbg !459
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!88, !89, !90, !91, !92, !93, !94}
!llvm.ident = !{!95}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_mutex", scope: !2, file: !31, line: 16, type: !56, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !28, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/thread/verify/cnd_test1.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "eb3f8278f0ededf0cd212775f3a04d8a")
!4 = !{!5, !6}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "run_info_t", file: !8, line: 38, baseType: !9)
!8 = !DIFile(filename: "utils/include/test/thread_launcher.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "b854c1934ab1739fab93f88f22662d53")
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !8, line: 33, size: 256, elements: !10)
!10 = !{!11, !15, !20, !23}
!11 = !DIDerivedType(tag: DW_TAG_member, name: "t", scope: !9, file: !8, line: 34, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !13, line: 27, baseType: !14)
!13 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!14 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!15 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !9, file: !8, line: 35, baseType: !16, size: 64, offset: 64)
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "vsize_t", file: !17, line: 43, baseType: !18)
!17 = !DIFile(filename: "include/vsync/vtypes.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "80559d0ebc17bc1f9d7b60e2c36ee0f3")
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !19, line: 46, baseType: !14)
!19 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!20 = !DIDerivedType(tag: DW_TAG_member, name: "assign_me_to_core", scope: !9, file: !8, line: 36, baseType: !21, size: 8, offset: 128)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !17, line: 44, baseType: !22)
!22 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "run_fun", scope: !9, file: !8, line: 37, baseType: !24, size: 64, offset: 192)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "thread_fun_t", file: !8, line: 30, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!26 = !DISubroutineType(types: !27)
!27 = !{!5, !5}
!28 = !{!29, !0, !48, !51, !53}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "g_cond", scope: !2, file: !31, line: 15, type: !32, isLocal: false, isDefinition: true)
!31 = !DIFile(filename: "thread/verify/cnd_test1.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "eb3f8278f0ededf0cd212775f3a04d8a")
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "vcond_t", file: !33, line: 32, baseType: !34)
!33 = !DIFile(filename: "thread/include/vsync/thread/cond.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "e12fe21b05a741b635af0d075e9acad7")
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vcond_s", file: !33, line: 30, size: 32, elements: !35)
!35 = !{!36}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !34, file: !33, line: 31, baseType: !37, size: 32, align: 32)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !38, line: 34, baseType: !39)
!38 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !38, line: 32, size: 32, align: 32, elements: !40)
!40 = !{!41}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !39, file: !38, line: 33, baseType: !42, size: 32)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !17, line: 35, baseType: !43)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !44, line: 26, baseType: !45)
!44 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !46, line: 42, baseType: !47)
!46 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!47 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !31, line: 17, type: !50, isLocal: false, isDefinition: true)
!50 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !31, line: 17, type: !50, isLocal: false, isDefinition: true)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "signal", scope: !2, file: !55, line: 22, type: !37, isLocal: true, isDefinition: true)
!55 = !DIFile(filename: "thread/include/vsync/thread/internal/futex.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "dede791c10be6385ed442bbae7c7e9b0")
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "vmutex_t", file: !57, line: 7, baseType: !58)
!57 = !DIFile(filename: "thread/verify/mock_mutex.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1d2467bff755e8cb9dc5ea1e20429e30")
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !13, line: 72, baseType: !59)
!59 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !13, line: 67, size: 320, elements: !60)
!60 = !{!61, !81, !86}
!61 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !59, file: !13, line: 69, baseType: !62, size: 320)
!62 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !63, line: 22, size: 320, elements: !64)
!63 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "584baedd80e6041b81caae7f496091c0")
!64 = !{!65, !66, !67, !68, !69, !70, !72, !73}
!65 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !62, file: !63, line: 24, baseType: !50, size: 32)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !62, file: !63, line: 25, baseType: !47, size: 32, offset: 32)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !62, file: !63, line: 26, baseType: !50, size: 32, offset: 64)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !62, file: !63, line: 28, baseType: !47, size: 32, offset: 96)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !62, file: !63, line: 32, baseType: !50, size: 32, offset: 128)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !62, file: !63, line: 34, baseType: !71, size: 16, offset: 160)
!71 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !62, file: !63, line: 35, baseType: !71, size: 16, offset: 176)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !62, file: !63, line: 36, baseType: !74, size: 128, offset: 192)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !75, line: 55, baseType: !76)
!75 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "04c81e86d34dad9c99ad006d32e47a0d")
!76 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !75, line: 51, size: 128, elements: !77)
!77 = !{!78, !80}
!78 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !76, file: !75, line: 53, baseType: !79, size: 64)
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !76, file: !75, line: 54, baseType: !79, size: 64, offset: 64)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !59, file: !13, line: 70, baseType: !82, size: 320)
!82 = !DICompositeType(tag: DW_TAG_array_type, baseType: !83, size: 320, elements: !84)
!83 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!84 = !{!85}
!85 = !DISubrange(count: 40)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !59, file: !13, line: 71, baseType: !87, size: 64)
!87 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!88 = !{i32 7, !"Dwarf Version", i32 5}
!89 = !{i32 2, !"Debug Info Version", i32 3}
!90 = !{i32 1, !"wchar_size", i32 4}
!91 = !{i32 7, !"PIC Level", i32 2}
!92 = !{i32 7, !"PIE Level", i32 2}
!93 = !{i32 7, !"uwtable", i32 1}
!94 = !{i32 7, !"frame-pointer", i32 2}
!95 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!96 = distinct !DISubprogram(name: "run", scope: !31, file: !31, line: 20, type: !26, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !97)
!97 = !{}
!98 = !DILocalVariable(name: "arg", arg: 1, scope: !96, file: !31, line: 20, type: !5)
!99 = !DILocation(line: 20, column: 11, scope: !96)
!100 = !DILocation(line: 22, column: 5, scope: !96)
!101 = !DILocation(line: 23, column: 15, scope: !102)
!102 = distinct !DILexicalBlock(scope: !96, file: !31, line: 23, column: 9)
!103 = !DILocation(line: 23, column: 18, scope: !102)
!104 = !DILocation(line: 23, column: 9, scope: !96)
!105 = !DILocation(line: 24, column: 9, scope: !106)
!106 = distinct !DILexicalBlock(scope: !102, file: !31, line: 23, column: 34)
!107 = !DILocation(line: 24, column: 16, scope: !106)
!108 = !DILocation(line: 24, column: 23, scope: !106)
!109 = !DILocation(line: 25, column: 13, scope: !110)
!110 = distinct !DILexicalBlock(scope: !106, file: !31, line: 24, column: 36)
!111 = distinct !{!111, !105, !112, !113}
!112 = !DILocation(line: 26, column: 9, scope: !106)
!113 = !{!"llvm.loop.mustprogress"}
!114 = !DILocation(line: 27, column: 15, scope: !106)
!115 = !DILocation(line: 28, column: 5, scope: !106)
!116 = !DILocation(line: 29, column: 16, scope: !117)
!117 = distinct !DILexicalBlock(scope: !102, file: !31, line: 28, column: 12)
!118 = !DILocation(line: 31, column: 5, scope: !96)
!119 = !DILocation(line: 32, column: 5, scope: !96)
!120 = !DILocation(line: 34, column: 5, scope: !96)
!121 = !DILocation(line: 34, column: 5, scope: !122)
!122 = distinct !DILexicalBlock(scope: !96, file: !31, line: 34, column: 5)
!123 = !DILocation(line: 34, column: 5, scope: !124)
!124 = distinct !DILexicalBlock(scope: !122, file: !31, line: 34, column: 5)
!125 = !DILocation(line: 34, column: 5, scope: !126)
!126 = distinct !DILexicalBlock(scope: !124, file: !31, line: 34, column: 5)
!127 = !DILocation(line: 35, column: 5, scope: !96)
!128 = distinct !DISubprogram(name: "vmutex_acquire", scope: !57, file: !57, line: 10, type: !129, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!129 = !DISubroutineType(types: !130)
!130 = !{null, !131}
!131 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!132 = !DILocalVariable(name: "l", arg: 1, scope: !128, file: !57, line: 10, type: !131)
!133 = !DILocation(line: 10, column: 26, scope: !128)
!134 = !DILocation(line: 12, column: 24, scope: !128)
!135 = !DILocation(line: 12, column: 5, scope: !128)
!136 = !DILocation(line: 13, column: 1, scope: !128)
!137 = distinct !DISubprogram(name: "vcond_wait", scope: !33, file: !33, line: 54, type: !138, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!138 = !DISubroutineType(types: !139)
!139 = !{null, !140, !131}
!140 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!141 = !DILocalVariable(name: "c", arg: 1, scope: !137, file: !33, line: 54, type: !140)
!142 = !DILocation(line: 54, column: 21, scope: !137)
!143 = !DILocalVariable(name: "m", arg: 2, scope: !137, file: !33, line: 54, type: !131)
!144 = !DILocation(line: 54, column: 34, scope: !137)
!145 = !DILocalVariable(name: "val", scope: !137, file: !33, line: 56, type: !42)
!146 = !DILocation(line: 56, column: 15, scope: !137)
!147 = !DILocation(line: 56, column: 41, scope: !137)
!148 = !DILocation(line: 56, column: 44, scope: !137)
!149 = !DILocation(line: 56, column: 21, scope: !137)
!150 = !DILocation(line: 57, column: 20, scope: !137)
!151 = !DILocation(line: 57, column: 5, scope: !137)
!152 = !DILocation(line: 58, column: 18, scope: !137)
!153 = !DILocation(line: 58, column: 21, scope: !137)
!154 = !DILocation(line: 58, column: 28, scope: !137)
!155 = !DILocation(line: 58, column: 5, scope: !137)
!156 = !DILocation(line: 59, column: 20, scope: !137)
!157 = !DILocation(line: 59, column: 5, scope: !137)
!158 = !DILocation(line: 60, column: 1, scope: !137)
!159 = distinct !DISubprogram(name: "vmutex_release", scope: !57, file: !57, line: 15, type: !129, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!160 = !DILocalVariable(name: "l", arg: 1, scope: !159, file: !57, line: 15, type: !131)
!161 = !DILocation(line: 15, column: 26, scope: !159)
!162 = !DILocation(line: 17, column: 26, scope: !159)
!163 = !DILocation(line: 17, column: 5, scope: !159)
!164 = !DILocation(line: 18, column: 1, scope: !159)
!165 = distinct !DISubprogram(name: "vcond_signal", scope: !33, file: !33, line: 69, type: !166, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!166 = !DISubroutineType(types: !167)
!167 = !{null, !140}
!168 = !DILocalVariable(name: "c", arg: 1, scope: !165, file: !33, line: 69, type: !140)
!169 = !DILocation(line: 69, column: 23, scope: !165)
!170 = !DILocation(line: 71, column: 24, scope: !165)
!171 = !DILocation(line: 71, column: 27, scope: !165)
!172 = !DILocation(line: 71, column: 5, scope: !165)
!173 = !DILocation(line: 72, column: 18, scope: !165)
!174 = !DILocation(line: 72, column: 21, scope: !165)
!175 = !DILocation(line: 72, column: 5, scope: !165)
!176 = !DILocation(line: 73, column: 1, scope: !165)
!177 = distinct !DISubprogram(name: "main", scope: !31, file: !31, line: 39, type: !178, scopeLine: 40, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !97)
!178 = !DISubroutineType(types: !179)
!179 = !{!50}
!180 = !DILocation(line: 41, column: 5, scope: !177)
!181 = !DILocation(line: 42, column: 5, scope: !182)
!182 = distinct !DILexicalBlock(scope: !183, file: !31, line: 42, column: 5)
!183 = distinct !DILexicalBlock(scope: !177, file: !31, line: 42, column: 5)
!184 = !DILocation(line: 42, column: 5, scope: !183)
!185 = !DILocation(line: 43, column: 5, scope: !186)
!186 = distinct !DILexicalBlock(scope: !187, file: !31, line: 43, column: 5)
!187 = distinct !DILexicalBlock(scope: !177, file: !31, line: 43, column: 5)
!188 = !DILocation(line: 43, column: 5, scope: !187)
!189 = !DILocation(line: 44, column: 5, scope: !177)
!190 = distinct !DISubprogram(name: "launch_threads", scope: !8, file: !8, line: 111, type: !191, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!191 = !DISubroutineType(types: !192)
!192 = !{null, !16, !24}
!193 = !DILocalVariable(name: "thread_count", arg: 1, scope: !190, file: !8, line: 111, type: !16)
!194 = !DILocation(line: 111, column: 24, scope: !190)
!195 = !DILocalVariable(name: "fun", arg: 2, scope: !190, file: !8, line: 111, type: !24)
!196 = !DILocation(line: 111, column: 51, scope: !190)
!197 = !DILocalVariable(name: "threads", scope: !190, file: !8, line: 113, type: !6)
!198 = !DILocation(line: 113, column: 17, scope: !190)
!199 = !DILocation(line: 113, column: 55, scope: !190)
!200 = !DILocation(line: 113, column: 53, scope: !190)
!201 = !DILocation(line: 113, column: 27, scope: !190)
!202 = !DILocation(line: 115, column: 20, scope: !190)
!203 = !DILocation(line: 115, column: 29, scope: !190)
!204 = !DILocation(line: 115, column: 43, scope: !190)
!205 = !DILocation(line: 115, column: 5, scope: !190)
!206 = !DILocation(line: 117, column: 19, scope: !190)
!207 = !DILocation(line: 117, column: 28, scope: !190)
!208 = !DILocation(line: 117, column: 5, scope: !190)
!209 = !DILocation(line: 119, column: 10, scope: !190)
!210 = !DILocation(line: 119, column: 5, scope: !190)
!211 = !DILocation(line: 120, column: 1, scope: !190)
!212 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !213, file: !213, line: 101, type: !214, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!213 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!214 = !DISubroutineType(types: !215)
!215 = !{!42, !216}
!216 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !217, size: 64)
!217 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !37)
!218 = !DILocalVariable(name: "a", arg: 1, scope: !212, file: !213, line: 101, type: !216)
!219 = !DILocation(line: 101, column: 39, scope: !212)
!220 = !DILocalVariable(name: "val", scope: !212, file: !213, line: 103, type: !42)
!221 = !DILocation(line: 103, column: 15, scope: !212)
!222 = !DILocation(line: 106, column: 32, scope: !212)
!223 = !DILocation(line: 106, column: 35, scope: !212)
!224 = !DILocation(line: 104, column: 5, scope: !212)
!225 = !{i64 599402}
!226 = !DILocation(line: 108, column: 12, scope: !212)
!227 = !DILocation(line: 108, column: 5, scope: !212)
!228 = distinct !DISubprogram(name: "vfutex_wait", scope: !55, file: !55, line: 25, type: !229, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!229 = !DISubroutineType(types: !230)
!230 = !{null, !231, !42}
!231 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!232 = !DILocalVariable(name: "m", arg: 1, scope: !228, file: !55, line: 25, type: !231)
!233 = !DILocation(line: 25, column: 26, scope: !228)
!234 = !DILocalVariable(name: "v", arg: 2, scope: !228, file: !55, line: 25, type: !42)
!235 = !DILocation(line: 25, column: 39, scope: !228)
!236 = !DILocalVariable(name: "s", scope: !228, file: !55, line: 27, type: !42)
!237 = !DILocation(line: 27, column: 15, scope: !228)
!238 = !DILocation(line: 27, column: 19, scope: !228)
!239 = !DILocation(line: 28, column: 28, scope: !240)
!240 = distinct !DILexicalBlock(scope: !228, file: !55, line: 28, column: 9)
!241 = !DILocation(line: 28, column: 9, scope: !240)
!242 = !DILocation(line: 28, column: 34, scope: !240)
!243 = !DILocation(line: 28, column: 31, scope: !240)
!244 = !DILocation(line: 28, column: 9, scope: !228)
!245 = !DILocation(line: 29, column: 9, scope: !240)
!246 = !DILocation(line: 30, column: 38, scope: !228)
!247 = !DILocation(line: 30, column: 5, scope: !228)
!248 = !DILocation(line: 31, column: 1, scope: !228)
!249 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !213, file: !213, line: 85, type: !214, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!250 = !DILocalVariable(name: "a", arg: 1, scope: !249, file: !213, line: 85, type: !216)
!251 = !DILocation(line: 85, column: 39, scope: !249)
!252 = !DILocalVariable(name: "val", scope: !249, file: !213, line: 87, type: !42)
!253 = !DILocation(line: 87, column: 15, scope: !249)
!254 = !DILocation(line: 90, column: 32, scope: !249)
!255 = !DILocation(line: 90, column: 35, scope: !249)
!256 = !DILocation(line: 88, column: 5, scope: !249)
!257 = !{i64 598900}
!258 = !DILocation(line: 92, column: 12, scope: !249)
!259 = !DILocation(line: 92, column: 5, scope: !249)
!260 = distinct !DISubprogram(name: "vatomic32_await_neq_rlx", scope: !213, file: !213, line: 912, type: !261, scopeLine: 913, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!261 = !DISubroutineType(types: !262)
!262 = !{!42, !216, !42}
!263 = !DILocalVariable(name: "a", arg: 1, scope: !260, file: !213, line: 912, type: !216)
!264 = !DILocation(line: 912, column: 44, scope: !260)
!265 = !DILocalVariable(name: "v", arg: 2, scope: !260, file: !213, line: 912, type: !42)
!266 = !DILocation(line: 912, column: 57, scope: !260)
!267 = !DILocalVariable(name: "val", scope: !260, file: !213, line: 914, type: !42)
!268 = !DILocation(line: 914, column: 15, scope: !260)
!269 = !DILocation(line: 921, column: 21, scope: !260)
!270 = !DILocation(line: 921, column: 33, scope: !260)
!271 = !DILocation(line: 921, column: 36, scope: !260)
!272 = !DILocation(line: 915, column: 5, scope: !260)
!273 = !{i64 622008, i64 622024, i64 622054, i64 622087}
!274 = !DILocation(line: 923, column: 12, scope: !260)
!275 = !DILocation(line: 923, column: 5, scope: !260)
!276 = distinct !DISubprogram(name: "vatomic32_inc_rlx", scope: !277, file: !277, line: 2956, type: !278, scopeLine: 2957, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!277 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!278 = !DISubroutineType(types: !279)
!279 = !{null, !231}
!280 = !DILocalVariable(name: "a", arg: 1, scope: !276, file: !277, line: 2956, type: !231)
!281 = !DILocation(line: 2956, column: 32, scope: !276)
!282 = !DILocation(line: 2958, column: 33, scope: !276)
!283 = !DILocation(line: 2958, column: 11, scope: !276)
!284 = !DILocation(line: 2959, column: 1, scope: !276)
!285 = distinct !DISubprogram(name: "vfutex_wake", scope: !55, file: !55, line: 34, type: !229, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!286 = !DILocalVariable(name: "m", arg: 1, scope: !285, file: !55, line: 34, type: !231)
!287 = !DILocation(line: 34, column: 26, scope: !285)
!288 = !DILocalVariable(name: "v", arg: 2, scope: !285, file: !55, line: 34, type: !42)
!289 = !DILocation(line: 34, column: 39, scope: !285)
!290 = !DILocation(line: 36, column: 5, scope: !285)
!291 = !DILocation(line: 37, column: 1, scope: !285)
!292 = distinct !DISubprogram(name: "vatomic32_get_inc_rlx", scope: !277, file: !277, line: 2516, type: !293, scopeLine: 2517, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!293 = !DISubroutineType(types: !294)
!294 = !{!42, !231}
!295 = !DILocalVariable(name: "a", arg: 1, scope: !292, file: !277, line: 2516, type: !231)
!296 = !DILocation(line: 2516, column: 36, scope: !292)
!297 = !DILocation(line: 2518, column: 34, scope: !292)
!298 = !DILocation(line: 2518, column: 12, scope: !292)
!299 = !DILocation(line: 2518, column: 5, scope: !292)
!300 = distinct !DISubprogram(name: "vatomic32_get_add_rlx", scope: !301, file: !301, line: 1388, type: !302, scopeLine: 1389, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!301 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!302 = !DISubroutineType(types: !303)
!303 = !{!42, !231, !42}
!304 = !DILocalVariable(name: "a", arg: 1, scope: !300, file: !301, line: 1388, type: !231)
!305 = !DILocation(line: 1388, column: 36, scope: !300)
!306 = !DILocalVariable(name: "v", arg: 2, scope: !300, file: !301, line: 1388, type: !42)
!307 = !DILocation(line: 1388, column: 49, scope: !300)
!308 = !DILocalVariable(name: "oldv", scope: !300, file: !301, line: 1390, type: !42)
!309 = !DILocation(line: 1390, column: 15, scope: !300)
!310 = !DILocalVariable(name: "tmp", scope: !300, file: !301, line: 1391, type: !42)
!311 = !DILocation(line: 1391, column: 15, scope: !300)
!312 = !DILocalVariable(name: "newv", scope: !300, file: !301, line: 1392, type: !42)
!313 = !DILocation(line: 1392, column: 15, scope: !300)
!314 = !DILocation(line: 1393, column: 5, scope: !300)
!315 = !DILocation(line: 1401, column: 19, scope: !300)
!316 = !DILocation(line: 1401, column: 22, scope: !300)
!317 = !{i64 696494, i64 696528, i64 696543, i64 696575, i64 696617, i64 696658}
!318 = !DILocation(line: 1404, column: 12, scope: !300)
!319 = !DILocation(line: 1404, column: 5, scope: !300)
!320 = distinct !DISubprogram(name: "vatomic32_inc_rel", scope: !277, file: !277, line: 2945, type: !278, scopeLine: 2946, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!321 = !DILocalVariable(name: "a", arg: 1, scope: !320, file: !277, line: 2945, type: !231)
!322 = !DILocation(line: 2945, column: 32, scope: !320)
!323 = !DILocation(line: 2947, column: 33, scope: !320)
!324 = !DILocation(line: 2947, column: 11, scope: !320)
!325 = !DILocation(line: 2948, column: 1, scope: !320)
!326 = distinct !DISubprogram(name: "vatomic32_get_inc_rel", scope: !277, file: !277, line: 2505, type: !293, scopeLine: 2506, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!327 = !DILocalVariable(name: "a", arg: 1, scope: !326, file: !277, line: 2505, type: !231)
!328 = !DILocation(line: 2505, column: 36, scope: !326)
!329 = !DILocation(line: 2507, column: 34, scope: !326)
!330 = !DILocation(line: 2507, column: 12, scope: !326)
!331 = !DILocation(line: 2507, column: 5, scope: !326)
!332 = distinct !DISubprogram(name: "vatomic32_get_add_rel", scope: !301, file: !301, line: 1263, type: !302, scopeLine: 1264, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!333 = !DILocalVariable(name: "a", arg: 1, scope: !332, file: !301, line: 1263, type: !231)
!334 = !DILocation(line: 1263, column: 36, scope: !332)
!335 = !DILocalVariable(name: "v", arg: 2, scope: !332, file: !301, line: 1263, type: !42)
!336 = !DILocation(line: 1263, column: 49, scope: !332)
!337 = !DILocalVariable(name: "oldv", scope: !332, file: !301, line: 1265, type: !42)
!338 = !DILocation(line: 1265, column: 15, scope: !332)
!339 = !DILocalVariable(name: "tmp", scope: !332, file: !301, line: 1266, type: !42)
!340 = !DILocation(line: 1266, column: 15, scope: !332)
!341 = !DILocalVariable(name: "newv", scope: !332, file: !301, line: 1267, type: !42)
!342 = !DILocation(line: 1267, column: 15, scope: !332)
!343 = !DILocation(line: 1268, column: 5, scope: !332)
!344 = !DILocation(line: 1276, column: 19, scope: !332)
!345 = !DILocation(line: 1276, column: 22, scope: !332)
!346 = !{i64 692696, i64 692730, i64 692745, i64 692777, i64 692819, i64 692861}
!347 = !DILocation(line: 1279, column: 12, scope: !332)
!348 = !DILocation(line: 1279, column: 5, scope: !332)
!349 = distinct !DISubprogram(name: "create_threads", scope: !8, file: !8, line: 83, type: !350, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!350 = !DISubroutineType(types: !351)
!351 = !{null, !6, !16, !24, !21}
!352 = !DILocalVariable(name: "threads", arg: 1, scope: !349, file: !8, line: 83, type: !6)
!353 = !DILocation(line: 83, column: 28, scope: !349)
!354 = !DILocalVariable(name: "num_threads", arg: 2, scope: !349, file: !8, line: 83, type: !16)
!355 = !DILocation(line: 83, column: 45, scope: !349)
!356 = !DILocalVariable(name: "fun", arg: 3, scope: !349, file: !8, line: 83, type: !24)
!357 = !DILocation(line: 83, column: 71, scope: !349)
!358 = !DILocalVariable(name: "bind", arg: 4, scope: !349, file: !8, line: 84, type: !21)
!359 = !DILocation(line: 84, column: 24, scope: !349)
!360 = !DILocalVariable(name: "i", scope: !349, file: !8, line: 86, type: !16)
!361 = !DILocation(line: 86, column: 13, scope: !349)
!362 = !DILocation(line: 87, column: 12, scope: !363)
!363 = distinct !DILexicalBlock(scope: !349, file: !8, line: 87, column: 5)
!364 = !DILocation(line: 87, column: 10, scope: !363)
!365 = !DILocation(line: 87, column: 17, scope: !366)
!366 = distinct !DILexicalBlock(scope: !363, file: !8, line: 87, column: 5)
!367 = !DILocation(line: 87, column: 21, scope: !366)
!368 = !DILocation(line: 87, column: 19, scope: !366)
!369 = !DILocation(line: 87, column: 5, scope: !363)
!370 = !DILocation(line: 88, column: 40, scope: !371)
!371 = distinct !DILexicalBlock(scope: !366, file: !8, line: 87, column: 39)
!372 = !DILocation(line: 88, column: 9, scope: !371)
!373 = !DILocation(line: 88, column: 17, scope: !371)
!374 = !DILocation(line: 88, column: 20, scope: !371)
!375 = !DILocation(line: 88, column: 38, scope: !371)
!376 = !DILocation(line: 89, column: 40, scope: !371)
!377 = !DILocation(line: 89, column: 9, scope: !371)
!378 = !DILocation(line: 89, column: 17, scope: !371)
!379 = !DILocation(line: 89, column: 20, scope: !371)
!380 = !DILocation(line: 89, column: 38, scope: !371)
!381 = !DILocation(line: 90, column: 40, scope: !371)
!382 = !DILocation(line: 90, column: 9, scope: !371)
!383 = !DILocation(line: 90, column: 17, scope: !371)
!384 = !DILocation(line: 90, column: 20, scope: !371)
!385 = !DILocation(line: 90, column: 38, scope: !371)
!386 = !DILocation(line: 91, column: 25, scope: !371)
!387 = !DILocation(line: 91, column: 33, scope: !371)
!388 = !DILocation(line: 91, column: 36, scope: !371)
!389 = !DILocation(line: 91, column: 55, scope: !371)
!390 = !DILocation(line: 91, column: 63, scope: !371)
!391 = !DILocation(line: 91, column: 54, scope: !371)
!392 = !DILocation(line: 91, column: 9, scope: !371)
!393 = !DILocation(line: 92, column: 5, scope: !371)
!394 = !DILocation(line: 87, column: 35, scope: !366)
!395 = !DILocation(line: 87, column: 5, scope: !366)
!396 = distinct !{!396, !369, !397, !113}
!397 = !DILocation(line: 92, column: 5, scope: !363)
!398 = !DILocation(line: 94, column: 1, scope: !349)
!399 = distinct !DISubprogram(name: "await_threads", scope: !8, file: !8, line: 97, type: !400, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!400 = !DISubroutineType(types: !401)
!401 = !{null, !6, !16}
!402 = !DILocalVariable(name: "threads", arg: 1, scope: !399, file: !8, line: 97, type: !6)
!403 = !DILocation(line: 97, column: 27, scope: !399)
!404 = !DILocalVariable(name: "num_threads", arg: 2, scope: !399, file: !8, line: 97, type: !16)
!405 = !DILocation(line: 97, column: 44, scope: !399)
!406 = !DILocalVariable(name: "i", scope: !399, file: !8, line: 99, type: !16)
!407 = !DILocation(line: 99, column: 13, scope: !399)
!408 = !DILocation(line: 100, column: 12, scope: !409)
!409 = distinct !DILexicalBlock(scope: !399, file: !8, line: 100, column: 5)
!410 = !DILocation(line: 100, column: 10, scope: !409)
!411 = !DILocation(line: 100, column: 17, scope: !412)
!412 = distinct !DILexicalBlock(scope: !409, file: !8, line: 100, column: 5)
!413 = !DILocation(line: 100, column: 21, scope: !412)
!414 = !DILocation(line: 100, column: 19, scope: !412)
!415 = !DILocation(line: 100, column: 5, scope: !409)
!416 = !DILocation(line: 101, column: 22, scope: !417)
!417 = distinct !DILexicalBlock(scope: !412, file: !8, line: 100, column: 39)
!418 = !DILocation(line: 101, column: 30, scope: !417)
!419 = !DILocation(line: 101, column: 33, scope: !417)
!420 = !DILocation(line: 101, column: 9, scope: !417)
!421 = !DILocation(line: 102, column: 5, scope: !417)
!422 = !DILocation(line: 100, column: 35, scope: !412)
!423 = !DILocation(line: 100, column: 5, scope: !412)
!424 = distinct !{!424, !415, !425, !113}
!425 = !DILocation(line: 102, column: 5, scope: !409)
!426 = !DILocation(line: 103, column: 1, scope: !399)
!427 = distinct !DISubprogram(name: "common_run", scope: !8, file: !8, line: 43, type: !26, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!428 = !DILocalVariable(name: "args", arg: 1, scope: !427, file: !8, line: 43, type: !5)
!429 = !DILocation(line: 43, column: 18, scope: !427)
!430 = !DILocalVariable(name: "run_info", scope: !427, file: !8, line: 45, type: !6)
!431 = !DILocation(line: 45, column: 17, scope: !427)
!432 = !DILocation(line: 45, column: 42, scope: !427)
!433 = !DILocation(line: 45, column: 28, scope: !427)
!434 = !DILocation(line: 47, column: 9, scope: !435)
!435 = distinct !DILexicalBlock(scope: !427, file: !8, line: 47, column: 9)
!436 = !DILocation(line: 47, column: 19, scope: !435)
!437 = !DILocation(line: 47, column: 9, scope: !427)
!438 = !DILocation(line: 48, column: 26, scope: !435)
!439 = !DILocation(line: 48, column: 36, scope: !435)
!440 = !DILocation(line: 48, column: 9, scope: !435)
!441 = !DILocation(line: 52, column: 12, scope: !427)
!442 = !DILocation(line: 52, column: 22, scope: !427)
!443 = !DILocation(line: 52, column: 38, scope: !427)
!444 = !DILocation(line: 52, column: 48, scope: !427)
!445 = !DILocation(line: 52, column: 30, scope: !427)
!446 = !DILocation(line: 52, column: 5, scope: !427)
!447 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !8, file: !8, line: 61, type: !448, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !97)
!448 = !DISubroutineType(types: !449)
!449 = !{null, !16}
!450 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !447, file: !8, line: 61, type: !16)
!451 = !DILocation(line: 61, column: 26, scope: !447)
!452 = !DILocation(line: 78, column: 5, scope: !447)
!453 = !DILocation(line: 78, column: 5, scope: !454)
!454 = distinct !DILexicalBlock(scope: !447, file: !8, line: 78, column: 5)
!455 = !DILocation(line: 78, column: 5, scope: !456)
!456 = distinct !DILexicalBlock(scope: !454, file: !8, line: 78, column: 5)
!457 = !DILocation(line: 78, column: 5, scope: !458)
!458 = distinct !DILexicalBlock(scope: !456, file: !8, line: 78, column: 5)
!459 = !DILocation(line: 80, column: 1, scope: !447)
