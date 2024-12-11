; ModuleID = '/home/stefano/huawei/libvsync/thread/verify/cnd_test2.c'
source_filename = "/home/stefano/huawei/libvsync/thread/verify/cnd_test2.c"
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
@g_shared = dso_local global i32 0, align 4, !dbg !51
@g_cond = dso_local global %struct.vcond_s zeroinitializer, align 4, !dbg !32
@.str = private unnamed_addr constant [15 x i8] c"g_shared == 2U\00", align 1
@.str.1 = private unnamed_addr constant [56 x i8] c"/home/stefano/huawei/libvsync/thread/verify/cnd_test2.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [15 x i8] c"int main(void)\00", align 1
@signal = internal global %struct.vatomic32_s zeroinitializer, align 4, !dbg !53

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @run(i8* noundef %0) #0 !dbg !97 {
  %2 = alloca i8*, align 8
  %3 = alloca i64, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !99, metadata !DIExpression()), !dbg !100
  call void @llvm.dbg.declare(metadata i64* %3, metadata !101, metadata !DIExpression()), !dbg !102
  %4 = load i8*, i8** %2, align 8, !dbg !103
  %5 = ptrtoint i8* %4 to i64, !dbg !104
  store i64 %5, i64* %3, align 8, !dbg !102
  call void @vmutex_acquire(%union.pthread_mutex_t* noundef @g_mutex), !dbg !105
  %6 = load i32, i32* @g_shared, align 4, !dbg !106
  %7 = add i32 %6, 1, !dbg !106
  store i32 %7, i32* @g_shared, align 4, !dbg !106
  br label %8, !dbg !107

8:                                                ; preds = %16, %1
  %9 = load i64, i64* %3, align 8, !dbg !108
  %10 = icmp eq i64 %9, 0, !dbg !109
  br i1 %10, label %11, label %14, !dbg !110

11:                                               ; preds = %8
  %12 = load i32, i32* @g_shared, align 4, !dbg !111
  %13 = icmp ne i32 %12, 2, !dbg !112
  br label %14

14:                                               ; preds = %11, %8
  %15 = phi i1 [ false, %8 ], [ %13, %11 ], !dbg !113
  br i1 %15, label %16, label %17, !dbg !107

16:                                               ; preds = %14
  call void @vcond_wait(%struct.vcond_s* noundef @g_cond, %union.pthread_mutex_t* noundef @g_mutex), !dbg !114
  br label %8, !dbg !107, !llvm.loop !116

17:                                               ; preds = %14
  call void @vmutex_release(%union.pthread_mutex_t* noundef @g_mutex), !dbg !119
  call void @vcond_signal(%struct.vcond_s* noundef @g_cond), !dbg !120
  ret i8* null, !dbg !121
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define internal void @vmutex_acquire(%union.pthread_mutex_t* noundef %0) #0 !dbg !122 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !126, metadata !DIExpression()), !dbg !127
  %3 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !128
  %4 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef %3) #5, !dbg !129
  ret void, !dbg !130
}

; Function Attrs: noinline nounwind uwtable
define internal void @vcond_wait(%struct.vcond_s* noundef %0, %union.pthread_mutex_t* noundef %1) #0 !dbg !131 {
  %3 = alloca %struct.vcond_s*, align 8
  %4 = alloca %union.pthread_mutex_t*, align 8
  %5 = alloca i32, align 4
  store %struct.vcond_s* %0, %struct.vcond_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vcond_s** %3, metadata !135, metadata !DIExpression()), !dbg !136
  store %union.pthread_mutex_t* %1, %union.pthread_mutex_t** %4, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %4, metadata !137, metadata !DIExpression()), !dbg !138
  call void @llvm.dbg.declare(metadata i32* %5, metadata !139, metadata !DIExpression()), !dbg !140
  %6 = load %struct.vcond_s*, %struct.vcond_s** %3, align 8, !dbg !141
  %7 = getelementptr inbounds %struct.vcond_s, %struct.vcond_s* %6, i32 0, i32 0, !dbg !142
  %8 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %7), !dbg !143
  store i32 %8, i32* %5, align 4, !dbg !140
  %9 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %4, align 8, !dbg !144
  call void @vmutex_release(%union.pthread_mutex_t* noundef %9), !dbg !145
  %10 = load %struct.vcond_s*, %struct.vcond_s** %3, align 8, !dbg !146
  %11 = getelementptr inbounds %struct.vcond_s, %struct.vcond_s* %10, i32 0, i32 0, !dbg !147
  %12 = load i32, i32* %5, align 4, !dbg !148
  call void @vfutex_wait(%struct.vatomic32_s* noundef %11, i32 noundef %12), !dbg !149
  %13 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %4, align 8, !dbg !150
  call void @vmutex_acquire(%union.pthread_mutex_t* noundef %13), !dbg !151
  ret void, !dbg !152
}

; Function Attrs: noinline nounwind uwtable
define internal void @vmutex_release(%union.pthread_mutex_t* noundef %0) #0 !dbg !153 {
  %2 = alloca %union.pthread_mutex_t*, align 8
  store %union.pthread_mutex_t* %0, %union.pthread_mutex_t** %2, align 8
  call void @llvm.dbg.declare(metadata %union.pthread_mutex_t** %2, metadata !154, metadata !DIExpression()), !dbg !155
  %3 = load %union.pthread_mutex_t*, %union.pthread_mutex_t** %2, align 8, !dbg !156
  %4 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef %3) #5, !dbg !157
  ret void, !dbg !158
}

; Function Attrs: noinline nounwind uwtable
define internal void @vcond_signal(%struct.vcond_s* noundef %0) #0 !dbg !159 {
  %2 = alloca %struct.vcond_s*, align 8
  store %struct.vcond_s* %0, %struct.vcond_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vcond_s** %2, metadata !162, metadata !DIExpression()), !dbg !163
  %3 = load %struct.vcond_s*, %struct.vcond_s** %2, align 8, !dbg !164
  %4 = getelementptr inbounds %struct.vcond_s, %struct.vcond_s* %3, i32 0, i32 0, !dbg !165
  call void @vatomic32_inc_rlx(%struct.vatomic32_s* noundef %4), !dbg !166
  %5 = load %struct.vcond_s*, %struct.vcond_s** %2, align 8, !dbg !167
  %6 = getelementptr inbounds %struct.vcond_s, %struct.vcond_s* %5, i32 0, i32 0, !dbg !168
  call void @vfutex_wake(%struct.vatomic32_s* noundef %6, i32 noundef 1), !dbg !169
  ret void, !dbg !170
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !171 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @launch_threads(i64 noundef 2, i8* (i8*)* noundef @run), !dbg !174
  %2 = load i32, i32* @g_shared, align 4, !dbg !175
  %3 = icmp eq i32 %2, 2, !dbg !175
  br i1 %3, label %4, label %5, !dbg !178

4:                                                ; preds = %0
  br label %6, !dbg !178

5:                                                ; preds = %0
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([56 x i8], [56 x i8]* @.str.1, i64 0, i64 0), i32 noundef 37, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #6, !dbg !175
  unreachable, !dbg !175

6:                                                ; preds = %4
  ret i32 0, !dbg !179
}

; Function Attrs: noinline nounwind uwtable
define internal void @launch_threads(i64 noundef %0, i8* (i8*)* noundef %1) #0 !dbg !180 {
  %3 = alloca i64, align 8
  %4 = alloca i8* (i8*)*, align 8
  %5 = alloca %struct.run_info_t*, align 8
  store i64 %0, i64* %3, align 8
  call void @llvm.dbg.declare(metadata i64* %3, metadata !183, metadata !DIExpression()), !dbg !184
  store i8* (i8*)* %1, i8* (i8*)** %4, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %4, metadata !185, metadata !DIExpression()), !dbg !186
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !187, metadata !DIExpression()), !dbg !188
  %6 = load i64, i64* %3, align 8, !dbg !189
  %7 = mul i64 32, %6, !dbg !190
  %8 = call noalias i8* @malloc(i64 noundef %7) #5, !dbg !191
  %9 = bitcast i8* %8 to %struct.run_info_t*, !dbg !191
  store %struct.run_info_t* %9, %struct.run_info_t** %5, align 8, !dbg !188
  %10 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !192
  %11 = load i64, i64* %3, align 8, !dbg !193
  %12 = load i8* (i8*)*, i8* (i8*)** %4, align 8, !dbg !194
  call void @create_threads(%struct.run_info_t* noundef %10, i64 noundef %11, i8* (i8*)* noundef %12, i1 noundef zeroext true), !dbg !195
  %13 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !196
  %14 = load i64, i64* %3, align 8, !dbg !197
  call void @await_threads(%struct.run_info_t* noundef %13, i64 noundef %14), !dbg !198
  %15 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !199
  %16 = bitcast %struct.run_info_t* %15 to i8*, !dbg !199
  call void @free(i8* noundef %16) #5, !dbg !200
  ret void, !dbg !201
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !202 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !208, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.declare(metadata i32* %3, metadata !210, metadata !DIExpression()), !dbg !211
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !212
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !213
  %6 = load i32, i32* %5, align 4, !dbg !213
  %7 = call i32 asm sideeffect "ldr ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #5, !dbg !214, !srcloc !215
  store i32 %7, i32* %3, align 4, !dbg !214
  %8 = load i32, i32* %3, align 4, !dbg !216
  ret i32 %8, !dbg !217
}

; Function Attrs: noinline nounwind uwtable
define internal void @vfutex_wait(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !218 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !222, metadata !DIExpression()), !dbg !223
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !224, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.declare(metadata i32* %5, metadata !226, metadata !DIExpression()), !dbg !227
  %6 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef @signal), !dbg !228
  store i32 %6, i32* %5, align 4, !dbg !227
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !229
  %8 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %7), !dbg !231
  %9 = load i32, i32* %4, align 4, !dbg !232
  %10 = icmp ne i32 %8, %9, !dbg !233
  br i1 %10, label %11, label %12, !dbg !234

11:                                               ; preds = %2
  br label %15, !dbg !235

12:                                               ; preds = %2
  %13 = load i32, i32* %5, align 4, !dbg !236
  %14 = call i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef @signal, i32 noundef %13), !dbg !237
  br label %15, !dbg !238

15:                                               ; preds = %12, %11
  ret void, !dbg !238
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !239 {
  %2 = alloca %struct.vatomic32_s*, align 8
  %3 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !240, metadata !DIExpression()), !dbg !241
  call void @llvm.dbg.declare(metadata i32* %3, metadata !242, metadata !DIExpression()), !dbg !243
  %4 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !244
  %5 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %4, i32 0, i32 0, !dbg !245
  %6 = load i32, i32* %5, align 4, !dbg !245
  %7 = call i32 asm sideeffect "ldar ${0:w}, $1", "=&r,Q,~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %6) #5, !dbg !246, !srcloc !247
  store i32 %7, i32* %3, align 4, !dbg !246
  %8 = load i32, i32* %3, align 4, !dbg !248
  ret i32 %8, !dbg !249
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_await_neq_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !250 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !253, metadata !DIExpression()), !dbg !254
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !255, metadata !DIExpression()), !dbg !256
  call void @llvm.dbg.declare(metadata i32* %5, metadata !257, metadata !DIExpression()), !dbg !258
  %6 = load i32, i32* %4, align 4, !dbg !259
  %7 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !260
  %8 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %7, i32 0, i32 0, !dbg !261
  %9 = load i32, i32* %8, align 4, !dbg !261
  %10 = call i32 asm sideeffect "1:\0Aldr ${0:w}, $2\0Acmp ${0:w}, ${1:w}\0Ab.eq 1b\0A", "=&r,r,Q,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %6, i32 %9) #5, !dbg !262, !srcloc !263
  store i32 %10, i32* %5, align 4, !dbg !262
  %11 = load i32, i32* %5, align 4, !dbg !264
  ret i32 %11, !dbg !265
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_inc_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !266 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !270, metadata !DIExpression()), !dbg !271
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !272
  %4 = call i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %3), !dbg !273
  ret void, !dbg !274
}

; Function Attrs: noinline nounwind uwtable
define internal void @vfutex_wake(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !275 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !276, metadata !DIExpression()), !dbg !277
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !278, metadata !DIExpression()), !dbg !279
  call void @vatomic32_inc_rel(%struct.vatomic32_s* noundef @signal), !dbg !280
  ret void, !dbg !281
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !282 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !285, metadata !DIExpression()), !dbg !286
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !287
  %4 = call i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !288
  ret i32 %4, !dbg !289
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !290 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !294, metadata !DIExpression()), !dbg !295
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !296, metadata !DIExpression()), !dbg !297
  call void @llvm.dbg.declare(metadata i32* %5, metadata !298, metadata !DIExpression()), !dbg !299
  call void @llvm.dbg.declare(metadata i32* %6, metadata !300, metadata !DIExpression()), !dbg !301
  call void @llvm.dbg.declare(metadata i32* %7, metadata !302, metadata !DIExpression()), !dbg !303
  %8 = load i32, i32* %4, align 4, !dbg !304
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !305
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !306
  %11 = load i32, i32* %10, align 4, !dbg !306
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #5, !dbg !304, !srcloc !307
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !304
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !304
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !304
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !304
  store i32 %13, i32* %5, align 4, !dbg !304
  store i32 %14, i32* %7, align 4, !dbg !304
  store i32 %15, i32* %6, align 4, !dbg !304
  store i32 %16, i32* %4, align 4, !dbg !304
  %17 = load i32, i32* %5, align 4, !dbg !308
  ret i32 %17, !dbg !309
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !310 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !311, metadata !DIExpression()), !dbg !312
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !313
  %4 = call i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %3), !dbg !314
  ret void, !dbg !315
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_inc_rel(%struct.vatomic32_s* noundef %0) #0 !dbg !316 {
  %2 = alloca %struct.vatomic32_s*, align 8
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %2, metadata !317, metadata !DIExpression()), !dbg !318
  %3 = load %struct.vatomic32_s*, %struct.vatomic32_s** %2, align 8, !dbg !319
  %4 = call i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %3, i32 noundef 1), !dbg !320
  ret i32 %4, !dbg !321
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_get_add_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !322 {
  %3 = alloca %struct.vatomic32_s*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store %struct.vatomic32_s* %0, %struct.vatomic32_s** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.vatomic32_s** %3, metadata !323, metadata !DIExpression()), !dbg !324
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !325, metadata !DIExpression()), !dbg !326
  call void @llvm.dbg.declare(metadata i32* %5, metadata !327, metadata !DIExpression()), !dbg !328
  call void @llvm.dbg.declare(metadata i32* %6, metadata !329, metadata !DIExpression()), !dbg !330
  call void @llvm.dbg.declare(metadata i32* %7, metadata !331, metadata !DIExpression()), !dbg !332
  %8 = load i32, i32* %4, align 4, !dbg !333
  %9 = load %struct.vatomic32_s*, %struct.vatomic32_s** %3, align 8, !dbg !334
  %10 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %9, i32 0, i32 0, !dbg !335
  %11 = load i32, i32* %10, align 4, !dbg !335
  %12 = call { i32, i32, i32, i32 } asm sideeffect "prfm pstl1strm, $4\0A1:\0Aldxr ${0:w}, $4\0Aadd ${1:w}, ${0:w}, ${3:w}\0Astlxr ${2:w}, ${1:w}, $4\0Acbnz ${2:w}, 1b\0A", "=&r,=&r,=&r,=&r,Q,3,~{memory},~{cc},~{dirflag},~{fpsr},~{flags}"(i32 %11, i32 %8) #5, !dbg !333, !srcloc !336
  %13 = extractvalue { i32, i32, i32, i32 } %12, 0, !dbg !333
  %14 = extractvalue { i32, i32, i32, i32 } %12, 1, !dbg !333
  %15 = extractvalue { i32, i32, i32, i32 } %12, 2, !dbg !333
  %16 = extractvalue { i32, i32, i32, i32 } %12, 3, !dbg !333
  store i32 %13, i32* %5, align 4, !dbg !333
  store i32 %14, i32* %7, align 4, !dbg !333
  store i32 %15, i32* %6, align 4, !dbg !333
  store i32 %16, i32* %4, align 4, !dbg !333
  %17 = load i32, i32* %5, align 4, !dbg !337
  ret i32 %17, !dbg !338
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal void @create_threads(%struct.run_info_t* noundef %0, i64 noundef %1, i8* (i8*)* noundef %2, i1 noundef zeroext %3) #0 !dbg !339 {
  %5 = alloca %struct.run_info_t*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8* (i8*)*, align 8
  %8 = alloca i8, align 1
  %9 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %5, metadata !342, metadata !DIExpression()), !dbg !343
  store i64 %1, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !344, metadata !DIExpression()), !dbg !345
  store i8* (i8*)* %2, i8* (i8*)** %7, align 8
  call void @llvm.dbg.declare(metadata i8* (i8*)** %7, metadata !346, metadata !DIExpression()), !dbg !347
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %8, align 1
  call void @llvm.dbg.declare(metadata i8* %8, metadata !348, metadata !DIExpression()), !dbg !349
  call void @llvm.dbg.declare(metadata i64* %9, metadata !350, metadata !DIExpression()), !dbg !351
  store i64 0, i64* %9, align 8, !dbg !351
  store i64 0, i64* %9, align 8, !dbg !352
  br label %11, !dbg !354

11:                                               ; preds = %42, %4
  %12 = load i64, i64* %9, align 8, !dbg !355
  %13 = load i64, i64* %6, align 8, !dbg !357
  %14 = icmp ult i64 %12, %13, !dbg !358
  br i1 %14, label %15, label %45, !dbg !359

15:                                               ; preds = %11
  %16 = load i64, i64* %9, align 8, !dbg !360
  %17 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !362
  %18 = load i64, i64* %9, align 8, !dbg !363
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %17, i64 %18, !dbg !362
  %20 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %19, i32 0, i32 1, !dbg !364
  store i64 %16, i64* %20, align 8, !dbg !365
  %21 = load i8* (i8*)*, i8* (i8*)** %7, align 8, !dbg !366
  %22 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !367
  %23 = load i64, i64* %9, align 8, !dbg !368
  %24 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %22, i64 %23, !dbg !367
  %25 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %24, i32 0, i32 3, !dbg !369
  store i8* (i8*)* %21, i8* (i8*)** %25, align 8, !dbg !370
  %26 = load i8, i8* %8, align 1, !dbg !371
  %27 = trunc i8 %26 to i1, !dbg !371
  %28 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !372
  %29 = load i64, i64* %9, align 8, !dbg !373
  %30 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %28, i64 %29, !dbg !372
  %31 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %30, i32 0, i32 2, !dbg !374
  %32 = zext i1 %27 to i8, !dbg !375
  store i8 %32, i8* %31, align 8, !dbg !375
  %33 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !376
  %34 = load i64, i64* %9, align 8, !dbg !377
  %35 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %33, i64 %34, !dbg !376
  %36 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %35, i32 0, i32 0, !dbg !378
  %37 = load %struct.run_info_t*, %struct.run_info_t** %5, align 8, !dbg !379
  %38 = load i64, i64* %9, align 8, !dbg !380
  %39 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %37, i64 %38, !dbg !379
  %40 = bitcast %struct.run_info_t* %39 to i8*, !dbg !381
  %41 = call i32 @pthread_create(i64* noundef %36, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @common_run, i8* noundef %40) #5, !dbg !382
  br label %42, !dbg !383

42:                                               ; preds = %15
  %43 = load i64, i64* %9, align 8, !dbg !384
  %44 = add i64 %43, 1, !dbg !384
  store i64 %44, i64* %9, align 8, !dbg !384
  br label %11, !dbg !385, !llvm.loop !386

45:                                               ; preds = %11
  ret void, !dbg !388
}

; Function Attrs: noinline nounwind uwtable
define internal void @await_threads(%struct.run_info_t* noundef %0, i64 noundef %1) #0 !dbg !389 {
  %3 = alloca %struct.run_info_t*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store %struct.run_info_t* %0, %struct.run_info_t** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !392, metadata !DIExpression()), !dbg !393
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !394, metadata !DIExpression()), !dbg !395
  call void @llvm.dbg.declare(metadata i64* %5, metadata !396, metadata !DIExpression()), !dbg !397
  store i64 0, i64* %5, align 8, !dbg !397
  store i64 0, i64* %5, align 8, !dbg !398
  br label %6, !dbg !400

6:                                                ; preds = %17, %2
  %7 = load i64, i64* %5, align 8, !dbg !401
  %8 = load i64, i64* %4, align 8, !dbg !403
  %9 = icmp ult i64 %7, %8, !dbg !404
  br i1 %9, label %10, label %20, !dbg !405

10:                                               ; preds = %6
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !406
  %12 = load i64, i64* %5, align 8, !dbg !408
  %13 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i64 %12, !dbg !406
  %14 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %13, i32 0, i32 0, !dbg !409
  %15 = load i64, i64* %14, align 8, !dbg !409
  %16 = call i32 @pthread_join(i64 noundef %15, i8** noundef null), !dbg !410
  br label %17, !dbg !411

17:                                               ; preds = %10
  %18 = load i64, i64* %5, align 8, !dbg !412
  %19 = add i64 %18, 1, !dbg !412
  store i64 %19, i64* %5, align 8, !dbg !412
  br label %6, !dbg !413, !llvm.loop !414

20:                                               ; preds = %6
  ret void, !dbg !416
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

; Function Attrs: noinline nounwind uwtable
define internal i8* @common_run(i8* noundef %0) #0 !dbg !417 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.run_info_t*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !418, metadata !DIExpression()), !dbg !419
  call void @llvm.dbg.declare(metadata %struct.run_info_t** %3, metadata !420, metadata !DIExpression()), !dbg !421
  %4 = load i8*, i8** %2, align 8, !dbg !422
  %5 = bitcast i8* %4 to %struct.run_info_t*, !dbg !423
  store %struct.run_info_t* %5, %struct.run_info_t** %3, align 8, !dbg !421
  %6 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !424
  %7 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %6, i32 0, i32 2, !dbg !426
  %8 = load i8, i8* %7, align 8, !dbg !426
  %9 = trunc i8 %8 to i1, !dbg !426
  br i1 %9, label %10, label %14, !dbg !427

10:                                               ; preds = %1
  %11 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !428
  %12 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %11, i32 0, i32 1, !dbg !429
  %13 = load i64, i64* %12, align 8, !dbg !429
  call void @set_cpu_affinity(i64 noundef %13), !dbg !430
  br label %14, !dbg !430

14:                                               ; preds = %10, %1
  %15 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !431
  %16 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %15, i32 0, i32 3, !dbg !432
  %17 = load i8* (i8*)*, i8* (i8*)** %16, align 8, !dbg !432
  %18 = load %struct.run_info_t*, %struct.run_info_t** %3, align 8, !dbg !433
  %19 = getelementptr inbounds %struct.run_info_t, %struct.run_info_t* %18, i32 0, i32 1, !dbg !434
  %20 = load i64, i64* %19, align 8, !dbg !434
  %21 = inttoptr i64 %20 to i8*, !dbg !435
  %22 = call i8* %17(i8* noundef %21), !dbg !431
  ret i8* %22, !dbg !436
}

; Function Attrs: noinline nounwind uwtable
define internal void @set_cpu_affinity(i64 noundef %0) #0 !dbg !437 {
  %2 = alloca i64, align 8
  store i64 %0, i64* %2, align 8
  call void @llvm.dbg.declare(metadata i64* %2, metadata !440, metadata !DIExpression()), !dbg !441
  br label %3, !dbg !442

3:                                                ; preds = %1
  br label %4, !dbg !443

4:                                                ; preds = %3
  %5 = load i64, i64* %2, align 8, !dbg !445
  br label %6, !dbg !445

6:                                                ; preds = %4
  br label %7, !dbg !447

7:                                                ; preds = %6
  br label %8, !dbg !445

8:                                                ; preds = %7
  br label %9, !dbg !443

9:                                                ; preds = %8
  ret void, !dbg !449
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
!llvm.module.flags = !{!89, !90, !91, !92, !93, !94, !95}
!llvm.ident = !{!96}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_mutex", scope: !2, file: !34, line: 16, type: !56, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !31, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/stefano/huawei/libvsync/thread/verify/cnd_test2.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "3903e594d098a22285f4cb867826652f")
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
!31 = !{!32, !0, !51, !53}
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "g_cond", scope: !2, file: !34, line: 15, type: !35, isLocal: false, isDefinition: true)
!34 = !DIFile(filename: "thread/verify/cnd_test2.c", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "3903e594d098a22285f4cb867826652f")
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "vcond_t", file: !36, line: 32, baseType: !37)
!36 = !DIFile(filename: "thread/include/vsync/thread/cond.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "e12fe21b05a741b635af0d075e9acad7")
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vcond_s", file: !36, line: 30, size: 32, elements: !38)
!38 = !{!39}
!39 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !37, file: !36, line: 31, baseType: !40, size: 32, align: 32)
!40 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !41, line: 34, baseType: !42)
!41 = !DIFile(filename: "atomics/include/vsync/atomic/internal/types.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "566b0c58af89e39a453b706e5dc4ad25")
!42 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !41, line: 32, size: 32, align: 32, elements: !43)
!43 = !{!44}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !42, file: !41, line: 33, baseType: !45, size: 32)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !6, line: 35, baseType: !46)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !47, line: 26, baseType: !48)
!47 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !49, line: 42, baseType: !50)
!49 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!50 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "g_shared", scope: !2, file: !34, line: 17, type: !45, isLocal: false, isDefinition: true)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "signal", scope: !2, file: !55, line: 22, type: !40, isLocal: true, isDefinition: true)
!55 = !DIFile(filename: "thread/include/vsync/thread/internal/futex.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "dede791c10be6385ed442bbae7c7e9b0")
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "vmutex_t", file: !57, line: 7, baseType: !58)
!57 = !DIFile(filename: "thread/verify/mock_mutex.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1d2467bff755e8cb9dc5ea1e20429e30")
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !21, line: 72, baseType: !59)
!59 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !21, line: 67, size: 320, elements: !60)
!60 = !{!61, !82, !87}
!61 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !59, file: !21, line: 69, baseType: !62, size: 320)
!62 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !63, line: 22, size: 320, elements: !64)
!63 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "584baedd80e6041b81caae7f496091c0")
!64 = !{!65, !67, !68, !69, !70, !71, !73, !74}
!65 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !62, file: !63, line: 24, baseType: !66, size: 32)
!66 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !62, file: !63, line: 25, baseType: !50, size: 32, offset: 32)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !62, file: !63, line: 26, baseType: !66, size: 32, offset: 64)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !62, file: !63, line: 28, baseType: !50, size: 32, offset: 96)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !62, file: !63, line: 32, baseType: !66, size: 32, offset: 128)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !62, file: !63, line: 34, baseType: !72, size: 16, offset: 160)
!72 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !62, file: !63, line: 35, baseType: !72, size: 16, offset: 176)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !62, file: !63, line: 36, baseType: !75, size: 128, offset: 192)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !76, line: 55, baseType: !77)
!76 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "04c81e86d34dad9c99ad006d32e47a0d")
!77 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !76, line: 51, size: 128, elements: !78)
!78 = !{!79, !81}
!79 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !77, file: !76, line: 53, baseType: !80, size: 64)
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !77, size: 64)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !77, file: !76, line: 54, baseType: !80, size: 64, offset: 64)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !59, file: !21, line: 70, baseType: !83, size: 320)
!83 = !DICompositeType(tag: DW_TAG_array_type, baseType: !84, size: 320, elements: !85)
!84 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!85 = !{!86}
!86 = !DISubrange(count: 40)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !59, file: !21, line: 71, baseType: !88, size: 64)
!88 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!89 = !{i32 7, !"Dwarf Version", i32 5}
!90 = !{i32 2, !"Debug Info Version", i32 3}
!91 = !{i32 1, !"wchar_size", i32 4}
!92 = !{i32 7, !"PIC Level", i32 2}
!93 = !{i32 7, !"PIE Level", i32 2}
!94 = !{i32 7, !"uwtable", i32 1}
!95 = !{i32 7, !"frame-pointer", i32 2}
!96 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!97 = distinct !DISubprogram(name: "run", scope: !34, file: !34, line: 20, type: !29, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !98)
!98 = !{}
!99 = !DILocalVariable(name: "arg", arg: 1, scope: !97, file: !34, line: 20, type: !13)
!100 = !DILocation(line: 20, column: 11, scope: !97)
!101 = !DILocalVariable(name: "i", scope: !97, file: !34, line: 22, type: !5)
!102 = !DILocation(line: 22, column: 13, scope: !97)
!103 = !DILocation(line: 22, column: 38, scope: !97)
!104 = !DILocation(line: 22, column: 26, scope: !97)
!105 = !DILocation(line: 23, column: 5, scope: !97)
!106 = !DILocation(line: 24, column: 13, scope: !97)
!107 = !DILocation(line: 25, column: 5, scope: !97)
!108 = !DILocation(line: 25, column: 12, scope: !97)
!109 = !DILocation(line: 25, column: 14, scope: !97)
!110 = !DILocation(line: 25, column: 19, scope: !97)
!111 = !DILocation(line: 25, column: 22, scope: !97)
!112 = !DILocation(line: 25, column: 31, scope: !97)
!113 = !DILocation(line: 0, scope: !97)
!114 = !DILocation(line: 26, column: 9, scope: !115)
!115 = distinct !DILexicalBlock(scope: !97, file: !34, line: 25, column: 44)
!116 = distinct !{!116, !107, !117, !118}
!117 = !DILocation(line: 27, column: 5, scope: !97)
!118 = !{!"llvm.loop.mustprogress"}
!119 = !DILocation(line: 28, column: 5, scope: !97)
!120 = !DILocation(line: 29, column: 5, scope: !97)
!121 = !DILocation(line: 30, column: 5, scope: !97)
!122 = distinct !DISubprogram(name: "vmutex_acquire", scope: !57, file: !57, line: 10, type: !123, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!123 = !DISubroutineType(types: !124)
!124 = !{null, !125}
!125 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!126 = !DILocalVariable(name: "l", arg: 1, scope: !122, file: !57, line: 10, type: !125)
!127 = !DILocation(line: 10, column: 26, scope: !122)
!128 = !DILocation(line: 12, column: 24, scope: !122)
!129 = !DILocation(line: 12, column: 5, scope: !122)
!130 = !DILocation(line: 13, column: 1, scope: !122)
!131 = distinct !DISubprogram(name: "vcond_wait", scope: !36, file: !36, line: 54, type: !132, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!132 = !DISubroutineType(types: !133)
!133 = !{null, !134, !125}
!134 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!135 = !DILocalVariable(name: "c", arg: 1, scope: !131, file: !36, line: 54, type: !134)
!136 = !DILocation(line: 54, column: 21, scope: !131)
!137 = !DILocalVariable(name: "m", arg: 2, scope: !131, file: !36, line: 54, type: !125)
!138 = !DILocation(line: 54, column: 34, scope: !131)
!139 = !DILocalVariable(name: "val", scope: !131, file: !36, line: 56, type: !45)
!140 = !DILocation(line: 56, column: 15, scope: !131)
!141 = !DILocation(line: 56, column: 41, scope: !131)
!142 = !DILocation(line: 56, column: 44, scope: !131)
!143 = !DILocation(line: 56, column: 21, scope: !131)
!144 = !DILocation(line: 57, column: 20, scope: !131)
!145 = !DILocation(line: 57, column: 5, scope: !131)
!146 = !DILocation(line: 58, column: 18, scope: !131)
!147 = !DILocation(line: 58, column: 21, scope: !131)
!148 = !DILocation(line: 58, column: 28, scope: !131)
!149 = !DILocation(line: 58, column: 5, scope: !131)
!150 = !DILocation(line: 59, column: 20, scope: !131)
!151 = !DILocation(line: 59, column: 5, scope: !131)
!152 = !DILocation(line: 60, column: 1, scope: !131)
!153 = distinct !DISubprogram(name: "vmutex_release", scope: !57, file: !57, line: 15, type: !123, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!154 = !DILocalVariable(name: "l", arg: 1, scope: !153, file: !57, line: 15, type: !125)
!155 = !DILocation(line: 15, column: 26, scope: !153)
!156 = !DILocation(line: 17, column: 26, scope: !153)
!157 = !DILocation(line: 17, column: 5, scope: !153)
!158 = !DILocation(line: 18, column: 1, scope: !153)
!159 = distinct !DISubprogram(name: "vcond_signal", scope: !36, file: !36, line: 69, type: !160, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!160 = !DISubroutineType(types: !161)
!161 = !{null, !134}
!162 = !DILocalVariable(name: "c", arg: 1, scope: !159, file: !36, line: 69, type: !134)
!163 = !DILocation(line: 69, column: 23, scope: !159)
!164 = !DILocation(line: 71, column: 24, scope: !159)
!165 = !DILocation(line: 71, column: 27, scope: !159)
!166 = !DILocation(line: 71, column: 5, scope: !159)
!167 = !DILocation(line: 72, column: 18, scope: !159)
!168 = !DILocation(line: 72, column: 21, scope: !159)
!169 = !DILocation(line: 72, column: 5, scope: !159)
!170 = !DILocation(line: 73, column: 1, scope: !159)
!171 = distinct !DISubprogram(name: "main", scope: !34, file: !34, line: 34, type: !172, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !98)
!172 = !DISubroutineType(types: !173)
!173 = !{!66}
!174 = !DILocation(line: 36, column: 5, scope: !171)
!175 = !DILocation(line: 37, column: 5, scope: !176)
!176 = distinct !DILexicalBlock(scope: !177, file: !34, line: 37, column: 5)
!177 = distinct !DILexicalBlock(scope: !171, file: !34, line: 37, column: 5)
!178 = !DILocation(line: 37, column: 5, scope: !177)
!179 = !DILocation(line: 38, column: 5, scope: !171)
!180 = distinct !DISubprogram(name: "launch_threads", scope: !16, file: !16, line: 111, type: !181, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!181 = !DISubroutineType(types: !182)
!182 = !{null, !5, !27}
!183 = !DILocalVariable(name: "thread_count", arg: 1, scope: !180, file: !16, line: 111, type: !5)
!184 = !DILocation(line: 111, column: 24, scope: !180)
!185 = !DILocalVariable(name: "fun", arg: 2, scope: !180, file: !16, line: 111, type: !27)
!186 = !DILocation(line: 111, column: 51, scope: !180)
!187 = !DILocalVariable(name: "threads", scope: !180, file: !16, line: 113, type: !14)
!188 = !DILocation(line: 113, column: 17, scope: !180)
!189 = !DILocation(line: 113, column: 55, scope: !180)
!190 = !DILocation(line: 113, column: 53, scope: !180)
!191 = !DILocation(line: 113, column: 27, scope: !180)
!192 = !DILocation(line: 115, column: 20, scope: !180)
!193 = !DILocation(line: 115, column: 29, scope: !180)
!194 = !DILocation(line: 115, column: 43, scope: !180)
!195 = !DILocation(line: 115, column: 5, scope: !180)
!196 = !DILocation(line: 117, column: 19, scope: !180)
!197 = !DILocation(line: 117, column: 28, scope: !180)
!198 = !DILocation(line: 117, column: 5, scope: !180)
!199 = !DILocation(line: 119, column: 10, scope: !180)
!200 = !DILocation(line: 119, column: 5, scope: !180)
!201 = !DILocation(line: 120, column: 1, scope: !180)
!202 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !203, file: !203, line: 101, type: !204, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!203 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "08002d3a79ab41d1fa79941395fb4c76")
!204 = !DISubroutineType(types: !205)
!205 = !{!45, !206}
!206 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !207, size: 64)
!207 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !40)
!208 = !DILocalVariable(name: "a", arg: 1, scope: !202, file: !203, line: 101, type: !206)
!209 = !DILocation(line: 101, column: 39, scope: !202)
!210 = !DILocalVariable(name: "val", scope: !202, file: !203, line: 103, type: !45)
!211 = !DILocation(line: 103, column: 15, scope: !202)
!212 = !DILocation(line: 106, column: 32, scope: !202)
!213 = !DILocation(line: 106, column: 35, scope: !202)
!214 = !DILocation(line: 104, column: 5, scope: !202)
!215 = !{i64 599318}
!216 = !DILocation(line: 108, column: 12, scope: !202)
!217 = !DILocation(line: 108, column: 5, scope: !202)
!218 = distinct !DISubprogram(name: "vfutex_wait", scope: !55, file: !55, line: 25, type: !219, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!219 = !DISubroutineType(types: !220)
!220 = !{null, !221, !45}
!221 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!222 = !DILocalVariable(name: "m", arg: 1, scope: !218, file: !55, line: 25, type: !221)
!223 = !DILocation(line: 25, column: 26, scope: !218)
!224 = !DILocalVariable(name: "v", arg: 2, scope: !218, file: !55, line: 25, type: !45)
!225 = !DILocation(line: 25, column: 39, scope: !218)
!226 = !DILocalVariable(name: "s", scope: !218, file: !55, line: 27, type: !45)
!227 = !DILocation(line: 27, column: 15, scope: !218)
!228 = !DILocation(line: 27, column: 19, scope: !218)
!229 = !DILocation(line: 28, column: 28, scope: !230)
!230 = distinct !DILexicalBlock(scope: !218, file: !55, line: 28, column: 9)
!231 = !DILocation(line: 28, column: 9, scope: !230)
!232 = !DILocation(line: 28, column: 34, scope: !230)
!233 = !DILocation(line: 28, column: 31, scope: !230)
!234 = !DILocation(line: 28, column: 9, scope: !218)
!235 = !DILocation(line: 29, column: 9, scope: !230)
!236 = !DILocation(line: 30, column: 38, scope: !218)
!237 = !DILocation(line: 30, column: 5, scope: !218)
!238 = !DILocation(line: 31, column: 1, scope: !218)
!239 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !203, file: !203, line: 85, type: !204, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!240 = !DILocalVariable(name: "a", arg: 1, scope: !239, file: !203, line: 85, type: !206)
!241 = !DILocation(line: 85, column: 39, scope: !239)
!242 = !DILocalVariable(name: "val", scope: !239, file: !203, line: 87, type: !45)
!243 = !DILocation(line: 87, column: 15, scope: !239)
!244 = !DILocation(line: 90, column: 32, scope: !239)
!245 = !DILocation(line: 90, column: 35, scope: !239)
!246 = !DILocation(line: 88, column: 5, scope: !239)
!247 = !{i64 598816}
!248 = !DILocation(line: 92, column: 12, scope: !239)
!249 = !DILocation(line: 92, column: 5, scope: !239)
!250 = distinct !DISubprogram(name: "vatomic32_await_neq_rlx", scope: !203, file: !203, line: 912, type: !251, scopeLine: 913, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!251 = !DISubroutineType(types: !252)
!252 = !{!45, !206, !45}
!253 = !DILocalVariable(name: "a", arg: 1, scope: !250, file: !203, line: 912, type: !206)
!254 = !DILocation(line: 912, column: 44, scope: !250)
!255 = !DILocalVariable(name: "v", arg: 2, scope: !250, file: !203, line: 912, type: !45)
!256 = !DILocation(line: 912, column: 57, scope: !250)
!257 = !DILocalVariable(name: "val", scope: !250, file: !203, line: 914, type: !45)
!258 = !DILocation(line: 914, column: 15, scope: !250)
!259 = !DILocation(line: 921, column: 21, scope: !250)
!260 = !DILocation(line: 921, column: 33, scope: !250)
!261 = !DILocation(line: 921, column: 36, scope: !250)
!262 = !DILocation(line: 915, column: 5, scope: !250)
!263 = !{i64 621924, i64 621940, i64 621970, i64 622003}
!264 = !DILocation(line: 923, column: 12, scope: !250)
!265 = !DILocation(line: 923, column: 5, scope: !250)
!266 = distinct !DISubprogram(name: "vatomic32_inc_rlx", scope: !267, file: !267, line: 2956, type: !268, scopeLine: 2957, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!267 = !DIFile(filename: "atomics/include/vsync/atomic/internal/fallback.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "04432f080ffe7e7fa10b4507f4f14734")
!268 = !DISubroutineType(types: !269)
!269 = !{null, !221}
!270 = !DILocalVariable(name: "a", arg: 1, scope: !266, file: !267, line: 2956, type: !221)
!271 = !DILocation(line: 2956, column: 32, scope: !266)
!272 = !DILocation(line: 2958, column: 33, scope: !266)
!273 = !DILocation(line: 2958, column: 11, scope: !266)
!274 = !DILocation(line: 2959, column: 1, scope: !266)
!275 = distinct !DISubprogram(name: "vfutex_wake", scope: !55, file: !55, line: 34, type: !219, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!276 = !DILocalVariable(name: "m", arg: 1, scope: !275, file: !55, line: 34, type: !221)
!277 = !DILocation(line: 34, column: 26, scope: !275)
!278 = !DILocalVariable(name: "v", arg: 2, scope: !275, file: !55, line: 34, type: !45)
!279 = !DILocation(line: 34, column: 39, scope: !275)
!280 = !DILocation(line: 36, column: 5, scope: !275)
!281 = !DILocation(line: 37, column: 1, scope: !275)
!282 = distinct !DISubprogram(name: "vatomic32_get_inc_rlx", scope: !267, file: !267, line: 2516, type: !283, scopeLine: 2517, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!283 = !DISubroutineType(types: !284)
!284 = !{!45, !221}
!285 = !DILocalVariable(name: "a", arg: 1, scope: !282, file: !267, line: 2516, type: !221)
!286 = !DILocation(line: 2516, column: 36, scope: !282)
!287 = !DILocation(line: 2518, column: 34, scope: !282)
!288 = !DILocation(line: 2518, column: 12, scope: !282)
!289 = !DILocation(line: 2518, column: 5, scope: !282)
!290 = distinct !DISubprogram(name: "vatomic32_get_add_rlx", scope: !291, file: !291, line: 1388, type: !292, scopeLine: 1389, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!291 = !DIFile(filename: "atomics/include/vsync/atomic/internal/arm64_llsc.h", directory: "/home/stefano/huawei/libvsync", checksumkind: CSK_MD5, checksum: "1b0fb22ba13d4fb01e019f8712969097")
!292 = !DISubroutineType(types: !293)
!293 = !{!45, !221, !45}
!294 = !DILocalVariable(name: "a", arg: 1, scope: !290, file: !291, line: 1388, type: !221)
!295 = !DILocation(line: 1388, column: 36, scope: !290)
!296 = !DILocalVariable(name: "v", arg: 2, scope: !290, file: !291, line: 1388, type: !45)
!297 = !DILocation(line: 1388, column: 49, scope: !290)
!298 = !DILocalVariable(name: "oldv", scope: !290, file: !291, line: 1390, type: !45)
!299 = !DILocation(line: 1390, column: 15, scope: !290)
!300 = !DILocalVariable(name: "tmp", scope: !290, file: !291, line: 1391, type: !45)
!301 = !DILocation(line: 1391, column: 15, scope: !290)
!302 = !DILocalVariable(name: "newv", scope: !290, file: !291, line: 1392, type: !45)
!303 = !DILocation(line: 1392, column: 15, scope: !290)
!304 = !DILocation(line: 1393, column: 5, scope: !290)
!305 = !DILocation(line: 1401, column: 19, scope: !290)
!306 = !DILocation(line: 1401, column: 22, scope: !290)
!307 = !{i64 696410, i64 696444, i64 696459, i64 696491, i64 696533, i64 696574}
!308 = !DILocation(line: 1404, column: 12, scope: !290)
!309 = !DILocation(line: 1404, column: 5, scope: !290)
!310 = distinct !DISubprogram(name: "vatomic32_inc_rel", scope: !267, file: !267, line: 2945, type: !268, scopeLine: 2946, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!311 = !DILocalVariable(name: "a", arg: 1, scope: !310, file: !267, line: 2945, type: !221)
!312 = !DILocation(line: 2945, column: 32, scope: !310)
!313 = !DILocation(line: 2947, column: 33, scope: !310)
!314 = !DILocation(line: 2947, column: 11, scope: !310)
!315 = !DILocation(line: 2948, column: 1, scope: !310)
!316 = distinct !DISubprogram(name: "vatomic32_get_inc_rel", scope: !267, file: !267, line: 2505, type: !283, scopeLine: 2506, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!317 = !DILocalVariable(name: "a", arg: 1, scope: !316, file: !267, line: 2505, type: !221)
!318 = !DILocation(line: 2505, column: 36, scope: !316)
!319 = !DILocation(line: 2507, column: 34, scope: !316)
!320 = !DILocation(line: 2507, column: 12, scope: !316)
!321 = !DILocation(line: 2507, column: 5, scope: !316)
!322 = distinct !DISubprogram(name: "vatomic32_get_add_rel", scope: !291, file: !291, line: 1263, type: !292, scopeLine: 1264, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!323 = !DILocalVariable(name: "a", arg: 1, scope: !322, file: !291, line: 1263, type: !221)
!324 = !DILocation(line: 1263, column: 36, scope: !322)
!325 = !DILocalVariable(name: "v", arg: 2, scope: !322, file: !291, line: 1263, type: !45)
!326 = !DILocation(line: 1263, column: 49, scope: !322)
!327 = !DILocalVariable(name: "oldv", scope: !322, file: !291, line: 1265, type: !45)
!328 = !DILocation(line: 1265, column: 15, scope: !322)
!329 = !DILocalVariable(name: "tmp", scope: !322, file: !291, line: 1266, type: !45)
!330 = !DILocation(line: 1266, column: 15, scope: !322)
!331 = !DILocalVariable(name: "newv", scope: !322, file: !291, line: 1267, type: !45)
!332 = !DILocation(line: 1267, column: 15, scope: !322)
!333 = !DILocation(line: 1268, column: 5, scope: !322)
!334 = !DILocation(line: 1276, column: 19, scope: !322)
!335 = !DILocation(line: 1276, column: 22, scope: !322)
!336 = !{i64 692612, i64 692646, i64 692661, i64 692693, i64 692735, i64 692777}
!337 = !DILocation(line: 1279, column: 12, scope: !322)
!338 = !DILocation(line: 1279, column: 5, scope: !322)
!339 = distinct !DISubprogram(name: "create_threads", scope: !16, file: !16, line: 83, type: !340, scopeLine: 85, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!340 = !DISubroutineType(types: !341)
!341 = !{null, !14, !5, !27, !24}
!342 = !DILocalVariable(name: "threads", arg: 1, scope: !339, file: !16, line: 83, type: !14)
!343 = !DILocation(line: 83, column: 28, scope: !339)
!344 = !DILocalVariable(name: "num_threads", arg: 2, scope: !339, file: !16, line: 83, type: !5)
!345 = !DILocation(line: 83, column: 45, scope: !339)
!346 = !DILocalVariable(name: "fun", arg: 3, scope: !339, file: !16, line: 83, type: !27)
!347 = !DILocation(line: 83, column: 71, scope: !339)
!348 = !DILocalVariable(name: "bind", arg: 4, scope: !339, file: !16, line: 84, type: !24)
!349 = !DILocation(line: 84, column: 24, scope: !339)
!350 = !DILocalVariable(name: "i", scope: !339, file: !16, line: 86, type: !5)
!351 = !DILocation(line: 86, column: 13, scope: !339)
!352 = !DILocation(line: 87, column: 12, scope: !353)
!353 = distinct !DILexicalBlock(scope: !339, file: !16, line: 87, column: 5)
!354 = !DILocation(line: 87, column: 10, scope: !353)
!355 = !DILocation(line: 87, column: 17, scope: !356)
!356 = distinct !DILexicalBlock(scope: !353, file: !16, line: 87, column: 5)
!357 = !DILocation(line: 87, column: 21, scope: !356)
!358 = !DILocation(line: 87, column: 19, scope: !356)
!359 = !DILocation(line: 87, column: 5, scope: !353)
!360 = !DILocation(line: 88, column: 40, scope: !361)
!361 = distinct !DILexicalBlock(scope: !356, file: !16, line: 87, column: 39)
!362 = !DILocation(line: 88, column: 9, scope: !361)
!363 = !DILocation(line: 88, column: 17, scope: !361)
!364 = !DILocation(line: 88, column: 20, scope: !361)
!365 = !DILocation(line: 88, column: 38, scope: !361)
!366 = !DILocation(line: 89, column: 40, scope: !361)
!367 = !DILocation(line: 89, column: 9, scope: !361)
!368 = !DILocation(line: 89, column: 17, scope: !361)
!369 = !DILocation(line: 89, column: 20, scope: !361)
!370 = !DILocation(line: 89, column: 38, scope: !361)
!371 = !DILocation(line: 90, column: 40, scope: !361)
!372 = !DILocation(line: 90, column: 9, scope: !361)
!373 = !DILocation(line: 90, column: 17, scope: !361)
!374 = !DILocation(line: 90, column: 20, scope: !361)
!375 = !DILocation(line: 90, column: 38, scope: !361)
!376 = !DILocation(line: 91, column: 25, scope: !361)
!377 = !DILocation(line: 91, column: 33, scope: !361)
!378 = !DILocation(line: 91, column: 36, scope: !361)
!379 = !DILocation(line: 91, column: 55, scope: !361)
!380 = !DILocation(line: 91, column: 63, scope: !361)
!381 = !DILocation(line: 91, column: 54, scope: !361)
!382 = !DILocation(line: 91, column: 9, scope: !361)
!383 = !DILocation(line: 92, column: 5, scope: !361)
!384 = !DILocation(line: 87, column: 35, scope: !356)
!385 = !DILocation(line: 87, column: 5, scope: !356)
!386 = distinct !{!386, !359, !387, !118}
!387 = !DILocation(line: 92, column: 5, scope: !353)
!388 = !DILocation(line: 94, column: 1, scope: !339)
!389 = distinct !DISubprogram(name: "await_threads", scope: !16, file: !16, line: 97, type: !390, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!390 = !DISubroutineType(types: !391)
!391 = !{null, !14, !5}
!392 = !DILocalVariable(name: "threads", arg: 1, scope: !389, file: !16, line: 97, type: !14)
!393 = !DILocation(line: 97, column: 27, scope: !389)
!394 = !DILocalVariable(name: "num_threads", arg: 2, scope: !389, file: !16, line: 97, type: !5)
!395 = !DILocation(line: 97, column: 44, scope: !389)
!396 = !DILocalVariable(name: "i", scope: !389, file: !16, line: 99, type: !5)
!397 = !DILocation(line: 99, column: 13, scope: !389)
!398 = !DILocation(line: 100, column: 12, scope: !399)
!399 = distinct !DILexicalBlock(scope: !389, file: !16, line: 100, column: 5)
!400 = !DILocation(line: 100, column: 10, scope: !399)
!401 = !DILocation(line: 100, column: 17, scope: !402)
!402 = distinct !DILexicalBlock(scope: !399, file: !16, line: 100, column: 5)
!403 = !DILocation(line: 100, column: 21, scope: !402)
!404 = !DILocation(line: 100, column: 19, scope: !402)
!405 = !DILocation(line: 100, column: 5, scope: !399)
!406 = !DILocation(line: 101, column: 22, scope: !407)
!407 = distinct !DILexicalBlock(scope: !402, file: !16, line: 100, column: 39)
!408 = !DILocation(line: 101, column: 30, scope: !407)
!409 = !DILocation(line: 101, column: 33, scope: !407)
!410 = !DILocation(line: 101, column: 9, scope: !407)
!411 = !DILocation(line: 102, column: 5, scope: !407)
!412 = !DILocation(line: 100, column: 35, scope: !402)
!413 = !DILocation(line: 100, column: 5, scope: !402)
!414 = distinct !{!414, !405, !415, !118}
!415 = !DILocation(line: 102, column: 5, scope: !399)
!416 = !DILocation(line: 103, column: 1, scope: !389)
!417 = distinct !DISubprogram(name: "common_run", scope: !16, file: !16, line: 43, type: !29, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!418 = !DILocalVariable(name: "args", arg: 1, scope: !417, file: !16, line: 43, type: !13)
!419 = !DILocation(line: 43, column: 18, scope: !417)
!420 = !DILocalVariable(name: "run_info", scope: !417, file: !16, line: 45, type: !14)
!421 = !DILocation(line: 45, column: 17, scope: !417)
!422 = !DILocation(line: 45, column: 42, scope: !417)
!423 = !DILocation(line: 45, column: 28, scope: !417)
!424 = !DILocation(line: 47, column: 9, scope: !425)
!425 = distinct !DILexicalBlock(scope: !417, file: !16, line: 47, column: 9)
!426 = !DILocation(line: 47, column: 19, scope: !425)
!427 = !DILocation(line: 47, column: 9, scope: !417)
!428 = !DILocation(line: 48, column: 26, scope: !425)
!429 = !DILocation(line: 48, column: 36, scope: !425)
!430 = !DILocation(line: 48, column: 9, scope: !425)
!431 = !DILocation(line: 52, column: 12, scope: !417)
!432 = !DILocation(line: 52, column: 22, scope: !417)
!433 = !DILocation(line: 52, column: 38, scope: !417)
!434 = !DILocation(line: 52, column: 48, scope: !417)
!435 = !DILocation(line: 52, column: 30, scope: !417)
!436 = !DILocation(line: 52, column: 5, scope: !417)
!437 = distinct !DISubprogram(name: "set_cpu_affinity", scope: !16, file: !16, line: 61, type: !438, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !98)
!438 = !DISubroutineType(types: !439)
!439 = !{null, !5}
!440 = !DILocalVariable(name: "target_cpu", arg: 1, scope: !437, file: !16, line: 61, type: !5)
!441 = !DILocation(line: 61, column: 26, scope: !437)
!442 = !DILocation(line: 78, column: 5, scope: !437)
!443 = !DILocation(line: 78, column: 5, scope: !444)
!444 = distinct !DILexicalBlock(scope: !437, file: !16, line: 78, column: 5)
!445 = !DILocation(line: 78, column: 5, scope: !446)
!446 = distinct !DILexicalBlock(scope: !444, file: !16, line: 78, column: 5)
!447 = !DILocation(line: 78, column: 5, scope: !448)
!448 = distinct !DILexicalBlock(scope: !446, file: !16, line: 78, column: 5)
!449 = !DILocation(line: 80, column: 1, scope: !437)
