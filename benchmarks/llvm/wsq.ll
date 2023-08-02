; ModuleID = '/home/ponce/git/Dat3M/benchmarks/lfds/wsq.c'
source_filename = "/home/ponce/git/Dat3M/benchmarks/lfds/wsq.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.WorkStealQueue = type { %union.pthread_mutex_t, i32, i32, i32, i32, [16 x %struct.Obj*], i32 }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%struct.Obj = type { i32 }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@.str = private unnamed_addr constant [14 x i8] c"r->field == 1\00", align 1
@.str.1 = private unnamed_addr constant [44 x i8] c"/home/ponce/git/Dat3M/benchmarks/lfds/wsq.h\00", align 1
@__PRETTY_FUNCTION__.check = private unnamed_addr constant [18 x i8] c"void check(Obj *)\00", align 1
@q = dso_local global %struct.WorkStealQueue zeroinitializer, align 8, !dbg !0
@.str.2 = private unnamed_addr constant [20 x i8] c"newsize < q.MaxSize\00", align 1
@__PRETTY_FUNCTION__.syncPush = private unnamed_addr constant [21 x i8] c"void syncPush(Obj *)\00", align 1
@.str.3 = private unnamed_addr constant [15 x i8] c"count < q.mask\00", align 1
@items = dso_local global [4 x %struct.Obj] zeroinitializer, align 16, !dbg !16

; Function Attrs: noinline nounwind uwtable
define dso_local void @init_Obj(%struct.Obj* noundef %0) #0 !dbg !83 {
  %2 = alloca %struct.Obj*, align 8
  store %struct.Obj* %0, %struct.Obj** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.Obj** %2, metadata !87, metadata !DIExpression()), !dbg !88
  %3 = load %struct.Obj*, %struct.Obj** %2, align 8, !dbg !89
  %4 = getelementptr inbounds %struct.Obj, %struct.Obj* %3, i32 0, i32 0, !dbg !90
  store i32 0, i32* %4, align 4, !dbg !91
  ret void, !dbg !92
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @operation(%struct.Obj* noundef %0) #0 !dbg !93 {
  %2 = alloca %struct.Obj*, align 8
  store %struct.Obj* %0, %struct.Obj** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.Obj** %2, metadata !94, metadata !DIExpression()), !dbg !95
  %3 = load %struct.Obj*, %struct.Obj** %2, align 8, !dbg !96
  %4 = getelementptr inbounds %struct.Obj, %struct.Obj* %3, i32 0, i32 0, !dbg !97
  %5 = load i32, i32* %4, align 4, !dbg !98
  %6 = add nsw i32 %5, 1, !dbg !98
  store i32 %6, i32* %4, align 4, !dbg !98
  ret void, !dbg !99
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check(%struct.Obj* noundef %0) #0 !dbg !100 {
  %2 = alloca %struct.Obj*, align 8
  store %struct.Obj* %0, %struct.Obj** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.Obj** %2, metadata !101, metadata !DIExpression()), !dbg !102
  %3 = load %struct.Obj*, %struct.Obj** %2, align 8, !dbg !103
  %4 = getelementptr inbounds %struct.Obj, %struct.Obj* %3, i32 0, i32 0, !dbg !103
  %5 = load i32, i32* %4, align 4, !dbg !103
  %6 = icmp eq i32 %5, 1, !dbg !103
  br i1 %6, label %7, label %8, !dbg !106

7:                                                ; preds = %1
  br label %9, !dbg !106

8:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([44 x i8], [44 x i8]* @.str.1, i64 0, i64 0), i32 noundef 37, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !103
  unreachable, !dbg !103

9:                                                ; preds = %7
  ret void, !dbg !107
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @readV(i32* noundef %0) #0 !dbg !108 {
  %2 = alloca i32*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store i32* %0, i32** %2, align 8
  call void @llvm.dbg.declare(metadata i32** %2, metadata !112, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.declare(metadata i32* %3, metadata !114, metadata !DIExpression()), !dbg !115
  store i32 0, i32* %3, align 4, !dbg !115
  %6 = load i32*, i32** %2, align 8, !dbg !116
  store i32 0, i32* %4, align 4, !dbg !117
  %7 = load i32, i32* %3, align 4, !dbg !117
  %8 = load i32, i32* %4, align 4, !dbg !117
  %9 = cmpxchg i32* %6, i32 %7, i32 %8 seq_cst seq_cst, align 4, !dbg !117
  %10 = extractvalue { i32, i1 } %9, 0, !dbg !117
  %11 = extractvalue { i32, i1 } %9, 1, !dbg !117
  br i1 %11, label %13, label %12, !dbg !117

12:                                               ; preds = %1
  store i32 %10, i32* %3, align 4, !dbg !117
  br label %13, !dbg !117

13:                                               ; preds = %12, %1
  %14 = zext i1 %11 to i8, !dbg !117
  store i8 %14, i8* %5, align 1, !dbg !117
  %15 = load i8, i8* %5, align 1, !dbg !117
  %16 = trunc i8 %15 to i1, !dbg !117
  %17 = load i32, i32* %3, align 4, !dbg !118
  ret i32 %17, !dbg !119
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writeV(i32* noundef %0, i32 noundef %1) #0 !dbg !120 {
  %3 = alloca i32*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  call void @llvm.dbg.declare(metadata i32** %3, metadata !123, metadata !DIExpression()), !dbg !124
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !125, metadata !DIExpression()), !dbg !126
  %7 = load i32*, i32** %3, align 8, !dbg !127
  %8 = load i32, i32* %4, align 4, !dbg !128
  store i32 %8, i32* %5, align 4, !dbg !129
  %9 = load i32, i32* %5, align 4, !dbg !129
  %10 = atomicrmw xchg i32* %7, i32 %9 seq_cst, align 4, !dbg !129
  store i32 %10, i32* %6, align 4, !dbg !129
  %11 = load i32, i32* %6, align 4, !dbg !129
  ret void, !dbg !130
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @init_WSQ(i32 noundef %0) #0 !dbg !131 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !134, metadata !DIExpression()), !dbg !135
  store i32 1048576, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 1), align 8, !dbg !136
  store i32 1024, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 2), align 4, !dbg !137
  %3 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0), %union.pthread_mutexattr_t* noundef null) #6, !dbg !138
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef 0), !dbg !139
  %4 = load i32, i32* %2, align 4, !dbg !140
  %5 = sub nsw i32 %4, 1, !dbg !141
  store i32 %5, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !142
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef 0), !dbg !143
  ret void, !dbg !144
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @destroy_WSQ() #0 !dbg !145 {
  ret void, !dbg !148
}

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @steal(%struct.Obj** noundef %0) #0 !dbg !149 {
  %2 = alloca %struct.Obj**, align 8
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.Obj** %0, %struct.Obj*** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.Obj*** %2, metadata !154, metadata !DIExpression()), !dbg !155
  call void @llvm.dbg.declare(metadata i8* %3, metadata !156, metadata !DIExpression()), !dbg !157
  %6 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #6, !dbg !158
  call void @llvm.dbg.declare(metadata i32* %4, metadata !159, metadata !DIExpression()), !dbg !160
  %7 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3)), !dbg !161
  store i32 %7, i32* %4, align 4, !dbg !160
  %8 = load i32, i32* %4, align 4, !dbg !162
  %9 = add nsw i32 %8, 1, !dbg !163
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef %9), !dbg !164
  %10 = load i32, i32* %4, align 4, !dbg !165
  %11 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4)), !dbg !167
  %12 = icmp slt i32 %10, %11, !dbg !168
  br i1 %12, label %13, label %22, !dbg !169

13:                                               ; preds = %1
  call void @llvm.dbg.declare(metadata i32* %5, metadata !170, metadata !DIExpression()), !dbg !172
  %14 = load i32, i32* %4, align 4, !dbg !173
  %15 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !174
  %16 = and i32 %14, %15, !dbg !175
  store i32 %16, i32* %5, align 4, !dbg !172
  %17 = load i32, i32* %5, align 4, !dbg !176
  %18 = sext i32 %17 to i64, !dbg !177
  %19 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %18, !dbg !177
  %20 = load %struct.Obj*, %struct.Obj** %19, align 8, !dbg !177
  %21 = load %struct.Obj**, %struct.Obj*** %2, align 8, !dbg !178
  store %struct.Obj* %20, %struct.Obj** %21, align 8, !dbg !179
  store i8 1, i8* %3, align 1, !dbg !180
  br label %24, !dbg !181

22:                                               ; preds = %1
  %23 = load i32, i32* %4, align 4, !dbg !182
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef %23), !dbg !184
  store i8 0, i8* %3, align 1, !dbg !185
  br label %24

24:                                               ; preds = %22, %13
  %25 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #6, !dbg !186
  %26 = load i8, i8* %3, align 1, !dbg !187
  %27 = trunc i8 %26 to i1, !dbg !187
  ret i1 %27, !dbg !188
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @syncPop(%struct.Obj** noundef %0) #0 !dbg !189 {
  %2 = alloca %struct.Obj**, align 8
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.Obj** %0, %struct.Obj*** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.Obj*** %2, metadata !190, metadata !DIExpression()), !dbg !191
  call void @llvm.dbg.declare(metadata i8* %3, metadata !192, metadata !DIExpression()), !dbg !193
  %6 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #6, !dbg !194
  call void @llvm.dbg.declare(metadata i32* %4, metadata !195, metadata !DIExpression()), !dbg !196
  %7 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4)), !dbg !197
  %8 = sub nsw i32 %7, 1, !dbg !198
  store i32 %8, i32* %4, align 4, !dbg !196
  %9 = load i32, i32* %4, align 4, !dbg !199
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %9), !dbg !200
  %10 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3)), !dbg !201
  %11 = load i32, i32* %4, align 4, !dbg !203
  %12 = icmp sle i32 %10, %11, !dbg !204
  br i1 %12, label %13, label %22, !dbg !205

13:                                               ; preds = %1
  call void @llvm.dbg.declare(metadata i32* %5, metadata !206, metadata !DIExpression()), !dbg !208
  %14 = load i32, i32* %4, align 4, !dbg !209
  %15 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !210
  %16 = and i32 %14, %15, !dbg !211
  store i32 %16, i32* %5, align 4, !dbg !208
  %17 = load i32, i32* %5, align 4, !dbg !212
  %18 = sext i32 %17 to i64, !dbg !213
  %19 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %18, !dbg !213
  %20 = load %struct.Obj*, %struct.Obj** %19, align 8, !dbg !213
  %21 = load %struct.Obj**, %struct.Obj*** %2, align 8, !dbg !214
  store %struct.Obj* %20, %struct.Obj** %21, align 8, !dbg !215
  store i8 1, i8* %3, align 1, !dbg !216
  br label %25, !dbg !217

22:                                               ; preds = %1
  %23 = load i32, i32* %4, align 4, !dbg !218
  %24 = add nsw i32 %23, 1, !dbg !220
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %24), !dbg !221
  store i8 0, i8* %3, align 1, !dbg !222
  br label %25

25:                                               ; preds = %22, %13
  %26 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3)), !dbg !223
  %27 = load i32, i32* %4, align 4, !dbg !225
  %28 = icmp sgt i32 %26, %27, !dbg !226
  br i1 %28, label %29, label %30, !dbg !227

29:                                               ; preds = %25
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef 0), !dbg !228
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef 0), !dbg !230
  store i8 0, i8* %3, align 1, !dbg !231
  br label %30, !dbg !232

30:                                               ; preds = %29, %25
  %31 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #6, !dbg !233
  %32 = load i8, i8* %3, align 1, !dbg !234
  %33 = trunc i8 %32 to i1, !dbg !234
  ret i1 %33, !dbg !235
}

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @pop(%struct.Obj** noundef %0) #0 !dbg !236 {
  %2 = alloca i1, align 1
  %3 = alloca %struct.Obj**, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.Obj** %0, %struct.Obj*** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.Obj*** %3, metadata !237, metadata !DIExpression()), !dbg !238
  call void @llvm.dbg.declare(metadata i32* %4, metadata !239, metadata !DIExpression()), !dbg !240
  %6 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4)), !dbg !241
  %7 = sub nsw i32 %6, 1, !dbg !242
  store i32 %7, i32* %4, align 4, !dbg !240
  %8 = load i32, i32* %4, align 4, !dbg !243
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %8), !dbg !244
  %9 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3)), !dbg !245
  %10 = load i32, i32* %4, align 4, !dbg !247
  %11 = icmp sle i32 %9, %10, !dbg !248
  br i1 %11, label %12, label %21, !dbg !249

12:                                               ; preds = %1
  call void @llvm.dbg.declare(metadata i32* %5, metadata !250, metadata !DIExpression()), !dbg !252
  %13 = load i32, i32* %4, align 4, !dbg !253
  %14 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !254
  %15 = and i32 %13, %14, !dbg !255
  store i32 %15, i32* %5, align 4, !dbg !252
  %16 = load i32, i32* %5, align 4, !dbg !256
  %17 = sext i32 %16 to i64, !dbg !257
  %18 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %17, !dbg !257
  %19 = load %struct.Obj*, %struct.Obj** %18, align 8, !dbg !257
  %20 = load %struct.Obj**, %struct.Obj*** %3, align 8, !dbg !258
  store %struct.Obj* %19, %struct.Obj** %20, align 8, !dbg !259
  store i1 true, i1* %2, align 1, !dbg !260
  br label %26, !dbg !260

21:                                               ; preds = %1
  %22 = load i32, i32* %4, align 4, !dbg !261
  %23 = add nsw i32 %22, 1, !dbg !263
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %23), !dbg !264
  %24 = load %struct.Obj**, %struct.Obj*** %3, align 8, !dbg !265
  %25 = call zeroext i1 @syncPop(%struct.Obj** noundef %24), !dbg !266
  store i1 %25, i1* %2, align 1, !dbg !267
  br label %26, !dbg !267

26:                                               ; preds = %21, %12
  %27 = load i1, i1* %2, align 1, !dbg !268
  ret i1 %27, !dbg !268
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @syncPush(%struct.Obj* noundef %0) #0 !dbg !269 {
  %2 = alloca %struct.Obj*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca [16 x %struct.Obj*], align 16
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store %struct.Obj* %0, %struct.Obj** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.Obj** %2, metadata !270, metadata !DIExpression()), !dbg !271
  %11 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #6, !dbg !272
  call void @llvm.dbg.declare(metadata i32* %3, metadata !273, metadata !DIExpression()), !dbg !274
  %12 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3)), !dbg !275
  store i32 %12, i32* %3, align 4, !dbg !274
  call void @llvm.dbg.declare(metadata i32* %4, metadata !276, metadata !DIExpression()), !dbg !277
  %13 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4)), !dbg !278
  %14 = load i32, i32* %3, align 4, !dbg !279
  %15 = sub nsw i32 %13, %14, !dbg !280
  store i32 %15, i32* %4, align 4, !dbg !277
  %16 = load i32, i32* %3, align 4, !dbg !281
  %17 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !282
  %18 = and i32 %16, %17, !dbg !283
  store i32 %18, i32* %3, align 4, !dbg !284
  %19 = load i32, i32* %3, align 4, !dbg !285
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef %19), !dbg !286
  %20 = load i32, i32* %3, align 4, !dbg !287
  %21 = load i32, i32* %4, align 4, !dbg !288
  %22 = add nsw i32 %20, %21, !dbg !289
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %22), !dbg !290
  %23 = load i32, i32* %4, align 4, !dbg !291
  %24 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !293
  %25 = icmp sge i32 %23, %24, !dbg !294
  br i1 %25, label %26, label %83, !dbg !295

26:                                               ; preds = %1
  call void @llvm.dbg.declare(metadata i32* %5, metadata !296, metadata !DIExpression()), !dbg !298
  %27 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !299
  %28 = icmp eq i32 %27, 0, !dbg !300
  br i1 %28, label %29, label %31, !dbg !301

29:                                               ; preds = %26
  %30 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 2), align 4, !dbg !302
  br label %35, !dbg !301

31:                                               ; preds = %26
  %32 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !303
  %33 = add nsw i32 %32, 1, !dbg !304
  %34 = mul nsw i32 2, %33, !dbg !305
  br label %35, !dbg !301

35:                                               ; preds = %31, %29
  %36 = phi i32 [ %30, %29 ], [ %34, %31 ], !dbg !301
  store i32 %36, i32* %5, align 4, !dbg !298
  %37 = load i32, i32* %5, align 4, !dbg !306
  %38 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 1), align 8, !dbg !306
  %39 = icmp slt i32 %37, %38, !dbg !306
  br i1 %39, label %40, label %41, !dbg !309

40:                                               ; preds = %35
  br label %42, !dbg !309

41:                                               ; preds = %35
  call void @__assert_fail(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([44 x i8], [44 x i8]* @.str.1, i64 0, i64 0), i32 noundef 204, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.syncPush, i64 0, i64 0)) #5, !dbg !306
  unreachable, !dbg !306

42:                                               ; preds = %40
  call void @llvm.dbg.declare(metadata [16 x %struct.Obj*]* %6, metadata !310, metadata !DIExpression()), !dbg !311
  call void @llvm.dbg.declare(metadata i32* %7, metadata !312, metadata !DIExpression()), !dbg !313
  store i32 0, i32* %7, align 4, !dbg !314
  br label %43, !dbg !316

43:                                               ; preds = %60, %42
  %44 = load i32, i32* %7, align 4, !dbg !317
  %45 = load i32, i32* %4, align 4, !dbg !319
  %46 = icmp slt i32 %44, %45, !dbg !320
  br i1 %46, label %47, label %63, !dbg !321

47:                                               ; preds = %43
  call void @llvm.dbg.declare(metadata i32* %8, metadata !322, metadata !DIExpression()), !dbg !324
  %48 = load i32, i32* %3, align 4, !dbg !325
  %49 = load i32, i32* %7, align 4, !dbg !326
  %50 = add nsw i32 %48, %49, !dbg !327
  %51 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !328
  %52 = and i32 %50, %51, !dbg !329
  store i32 %52, i32* %8, align 4, !dbg !324
  %53 = load i32, i32* %8, align 4, !dbg !330
  %54 = sext i32 %53 to i64, !dbg !331
  %55 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %54, !dbg !331
  %56 = load %struct.Obj*, %struct.Obj** %55, align 8, !dbg !331
  %57 = load i32, i32* %7, align 4, !dbg !332
  %58 = sext i32 %57 to i64, !dbg !333
  %59 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* %6, i64 0, i64 %58, !dbg !333
  store %struct.Obj* %56, %struct.Obj** %59, align 8, !dbg !334
  br label %60, !dbg !335

60:                                               ; preds = %47
  %61 = load i32, i32* %7, align 4, !dbg !336
  %62 = add nsw i32 %61, 1, !dbg !336
  store i32 %62, i32* %7, align 4, !dbg !336
  br label %43, !dbg !337, !llvm.loop !338

63:                                               ; preds = %43
  store i32 0, i32* %7, align 4, !dbg !341
  br label %64, !dbg !343

64:                                               ; preds = %76, %63
  %65 = load i32, i32* %7, align 4, !dbg !344
  %66 = load i32, i32* %5, align 4, !dbg !346
  %67 = icmp slt i32 %65, %66, !dbg !347
  br i1 %67, label %68, label %79, !dbg !348

68:                                               ; preds = %64
  %69 = load i32, i32* %7, align 4, !dbg !349
  %70 = sext i32 %69 to i64, !dbg !351
  %71 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* %6, i64 0, i64 %70, !dbg !351
  %72 = load %struct.Obj*, %struct.Obj** %71, align 8, !dbg !351
  %73 = load i32, i32* %7, align 4, !dbg !352
  %74 = sext i32 %73 to i64, !dbg !353
  %75 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %74, !dbg !353
  store %struct.Obj* %72, %struct.Obj** %75, align 8, !dbg !354
  br label %76, !dbg !355

76:                                               ; preds = %68
  %77 = load i32, i32* %7, align 4, !dbg !356
  %78 = add nsw i32 %77, 1, !dbg !356
  store i32 %78, i32* %7, align 4, !dbg !356
  br label %64, !dbg !357, !llvm.loop !358

79:                                               ; preds = %64
  %80 = load i32, i32* %5, align 4, !dbg !360
  %81 = sub nsw i32 %80, 1, !dbg !361
  store i32 %81, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !362
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef 0), !dbg !363
  %82 = load i32, i32* %4, align 4, !dbg !364
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %82), !dbg !365
  br label %83, !dbg !366

83:                                               ; preds = %79, %1
  %84 = load i32, i32* %4, align 4, !dbg !367
  %85 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !367
  %86 = icmp slt i32 %84, %85, !dbg !367
  br i1 %86, label %87, label %88, !dbg !370

87:                                               ; preds = %83
  br label %89, !dbg !370

88:                                               ; preds = %83
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([44 x i8], [44 x i8]* @.str.1, i64 0, i64 0), i32 noundef 221, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.syncPush, i64 0, i64 0)) #5, !dbg !367
  unreachable, !dbg !367

89:                                               ; preds = %87
  call void @llvm.dbg.declare(metadata i32* %9, metadata !371, metadata !DIExpression()), !dbg !372
  %90 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4)), !dbg !373
  store i32 %90, i32* %9, align 4, !dbg !372
  call void @llvm.dbg.declare(metadata i32* %10, metadata !374, metadata !DIExpression()), !dbg !375
  %91 = load i32, i32* %9, align 4, !dbg !376
  %92 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !377
  %93 = and i32 %91, %92, !dbg !378
  store i32 %93, i32* %10, align 4, !dbg !375
  %94 = load %struct.Obj*, %struct.Obj** %2, align 8, !dbg !379
  %95 = load i32, i32* %10, align 4, !dbg !380
  %96 = sext i32 %95 to i64, !dbg !381
  %97 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %96, !dbg !381
  store %struct.Obj* %94, %struct.Obj** %97, align 8, !dbg !382
  %98 = load i32, i32* %9, align 4, !dbg !383
  %99 = add nsw i32 %98, 1, !dbg !384
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %99), !dbg !385
  %100 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #6, !dbg !386
  ret void, !dbg !387
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @push(%struct.Obj* noundef %0) #0 !dbg !388 {
  %2 = alloca %struct.Obj*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %struct.Obj* %0, %struct.Obj** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.Obj** %2, metadata !389, metadata !DIExpression()), !dbg !390
  call void @llvm.dbg.declare(metadata i32* %3, metadata !391, metadata !DIExpression()), !dbg !392
  %5 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4)), !dbg !393
  store i32 %5, i32* %3, align 4, !dbg !392
  %6 = load i32, i32* %3, align 4, !dbg !394
  %7 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3)), !dbg !396
  %8 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !397
  %9 = add nsw i32 %7, %8, !dbg !398
  %10 = icmp slt i32 %6, %9, !dbg !399
  br i1 %10, label %11, label %25, !dbg !400

11:                                               ; preds = %1
  %12 = load i32, i32* %3, align 4, !dbg !401
  %13 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 1), align 8, !dbg !402
  %14 = icmp slt i32 %12, %13, !dbg !403
  br i1 %14, label %15, label %25, !dbg !404

15:                                               ; preds = %11
  call void @llvm.dbg.declare(metadata i32* %4, metadata !405, metadata !DIExpression()), !dbg !407
  %16 = load i32, i32* %3, align 4, !dbg !408
  %17 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !409
  %18 = and i32 %16, %17, !dbg !410
  store i32 %18, i32* %4, align 4, !dbg !407
  %19 = load %struct.Obj*, %struct.Obj** %2, align 8, !dbg !411
  %20 = load i32, i32* %4, align 4, !dbg !412
  %21 = sext i32 %20 to i64, !dbg !413
  %22 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %21, !dbg !413
  store %struct.Obj* %19, %struct.Obj** %22, align 8, !dbg !414
  %23 = load i32, i32* %3, align 4, !dbg !415
  %24 = add nsw i32 %23, 1, !dbg !416
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %24), !dbg !417
  br label %27, !dbg !418

25:                                               ; preds = %11, %1
  %26 = load %struct.Obj*, %struct.Obj** %2, align 8, !dbg !419
  call void @syncPush(%struct.Obj* noundef %26), !dbg !421
  br label %27

27:                                               ; preds = %25, %15
  ret void, !dbg !422
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @stealer(i8* noundef %0) #0 !dbg !423 {
  %2 = alloca i8*, align 8
  %3 = alloca %struct.Obj*, align 8
  %4 = alloca i32, align 4
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !427, metadata !DIExpression()), !dbg !428
  call void @llvm.dbg.declare(metadata %struct.Obj** %3, metadata !429, metadata !DIExpression()), !dbg !430
  call void @llvm.dbg.declare(metadata i32* %4, metadata !431, metadata !DIExpression()), !dbg !433
  store i32 0, i32* %4, align 4, !dbg !433
  br label %5, !dbg !434

5:                                                ; preds = %13, %1
  %6 = load i32, i32* %4, align 4, !dbg !435
  %7 = icmp slt i32 %6, 1, !dbg !437
  br i1 %7, label %8, label %16, !dbg !438

8:                                                ; preds = %5
  %9 = call zeroext i1 @steal(%struct.Obj** noundef %3), !dbg !439
  br i1 %9, label %10, label %12, !dbg !442

10:                                               ; preds = %8
  %11 = load %struct.Obj*, %struct.Obj** %3, align 8, !dbg !443
  call void @operation(%struct.Obj* noundef %11), !dbg !445
  br label %12, !dbg !446

12:                                               ; preds = %10, %8
  br label %13, !dbg !447

13:                                               ; preds = %12
  %14 = load i32, i32* %4, align 4, !dbg !448
  %15 = add nsw i32 %14, 1, !dbg !448
  store i32 %15, i32* %4, align 4, !dbg !448
  br label %5, !dbg !449, !llvm.loop !450

16:                                               ; preds = %5
  ret i8* null, !dbg !452
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !453 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x i64], align 16
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca %struct.Obj*, align 8
  %7 = alloca i32, align 4
  %8 = alloca %struct.Obj*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [2 x i64]* %2, metadata !456, metadata !DIExpression()), !dbg !462
  call void @init_WSQ(i32 noundef 2), !dbg !463
  call void @llvm.dbg.declare(metadata i32* %3, metadata !464, metadata !DIExpression()), !dbg !466
  store i32 0, i32* %3, align 4, !dbg !466
  br label %11, !dbg !467

11:                                               ; preds = %18, %0
  %12 = load i32, i32* %3, align 4, !dbg !468
  %13 = icmp slt i32 %12, 4, !dbg !470
  br i1 %13, label %14, label %21, !dbg !471

14:                                               ; preds = %11
  %15 = load i32, i32* %3, align 4, !dbg !472
  %16 = sext i32 %15 to i64, !dbg !474
  %17 = getelementptr inbounds [4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 %16, !dbg !474
  call void @init_Obj(%struct.Obj* noundef %17), !dbg !475
  br label %18, !dbg !476

18:                                               ; preds = %14
  %19 = load i32, i32* %3, align 4, !dbg !477
  %20 = add nsw i32 %19, 1, !dbg !477
  store i32 %20, i32* %3, align 4, !dbg !477
  br label %11, !dbg !478, !llvm.loop !479

21:                                               ; preds = %11
  call void @llvm.dbg.declare(metadata i32* %4, metadata !481, metadata !DIExpression()), !dbg !483
  store i32 0, i32* %4, align 4, !dbg !483
  br label %22, !dbg !484

22:                                               ; preds = %30, %21
  %23 = load i32, i32* %4, align 4, !dbg !485
  %24 = icmp slt i32 %23, 2, !dbg !487
  br i1 %24, label %25, label %33, !dbg !488

25:                                               ; preds = %22
  %26 = load i32, i32* %4, align 4, !dbg !489
  %27 = sext i32 %26 to i64, !dbg !491
  %28 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 %27, !dbg !491
  %29 = call i32 @pthread_create(i64* noundef %28, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @stealer, i8* noundef null) #6, !dbg !492
  br label %30, !dbg !493

30:                                               ; preds = %25
  %31 = load i32, i32* %4, align 4, !dbg !494
  %32 = add nsw i32 %31, 1, !dbg !494
  store i32 %32, i32* %4, align 4, !dbg !494
  br label %22, !dbg !495, !llvm.loop !496

33:                                               ; preds = %22
  call void @llvm.dbg.declare(metadata i32* %5, metadata !498, metadata !DIExpression()), !dbg !500
  store i32 0, i32* %5, align 4, !dbg !500
  br label %34, !dbg !501

34:                                               ; preds = %51, %33
  %35 = load i32, i32* %5, align 4, !dbg !502
  %36 = icmp slt i32 %35, 2, !dbg !504
  br i1 %36, label %37, label %54, !dbg !505

37:                                               ; preds = %34
  %38 = load i32, i32* %5, align 4, !dbg !506
  %39 = mul nsw i32 2, %38, !dbg !508
  %40 = sext i32 %39 to i64, !dbg !509
  %41 = getelementptr inbounds [4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 %40, !dbg !509
  call void @push(%struct.Obj* noundef %41), !dbg !510
  %42 = load i32, i32* %5, align 4, !dbg !511
  %43 = mul nsw i32 2, %42, !dbg !512
  %44 = add nsw i32 %43, 1, !dbg !513
  %45 = sext i32 %44 to i64, !dbg !514
  %46 = getelementptr inbounds [4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 %45, !dbg !514
  call void @push(%struct.Obj* noundef %46), !dbg !515
  call void @llvm.dbg.declare(metadata %struct.Obj** %6, metadata !516, metadata !DIExpression()), !dbg !517
  %47 = call zeroext i1 @pop(%struct.Obj** noundef %6), !dbg !518
  br i1 %47, label %48, label %50, !dbg !520

48:                                               ; preds = %37
  %49 = load %struct.Obj*, %struct.Obj** %6, align 8, !dbg !521
  call void @operation(%struct.Obj* noundef %49), !dbg !523
  br label %50, !dbg !524

50:                                               ; preds = %48, %37
  br label %51, !dbg !525

51:                                               ; preds = %50
  %52 = load i32, i32* %5, align 4, !dbg !526
  %53 = add nsw i32 %52, 1, !dbg !526
  store i32 %53, i32* %5, align 4, !dbg !526
  br label %34, !dbg !527, !llvm.loop !528

54:                                               ; preds = %34
  call void @llvm.dbg.declare(metadata i32* %7, metadata !530, metadata !DIExpression()), !dbg !532
  store i32 0, i32* %7, align 4, !dbg !532
  br label %55, !dbg !533

55:                                               ; preds = %63, %54
  %56 = load i32, i32* %7, align 4, !dbg !534
  %57 = icmp slt i32 %56, 2, !dbg !536
  br i1 %57, label %58, label %66, !dbg !537

58:                                               ; preds = %55
  call void @llvm.dbg.declare(metadata %struct.Obj** %8, metadata !538, metadata !DIExpression()), !dbg !540
  %59 = call zeroext i1 @pop(%struct.Obj** noundef %8), !dbg !541
  br i1 %59, label %60, label %62, !dbg !543

60:                                               ; preds = %58
  %61 = load %struct.Obj*, %struct.Obj** %8, align 8, !dbg !544
  call void @operation(%struct.Obj* noundef %61), !dbg !546
  br label %62, !dbg !547

62:                                               ; preds = %60, %58
  br label %63, !dbg !548

63:                                               ; preds = %62
  %64 = load i32, i32* %7, align 4, !dbg !549
  %65 = add nsw i32 %64, 1, !dbg !549
  store i32 %65, i32* %7, align 4, !dbg !549
  br label %55, !dbg !550, !llvm.loop !551

66:                                               ; preds = %55
  call void @llvm.dbg.declare(metadata i32* %9, metadata !553, metadata !DIExpression()), !dbg !555
  store i32 0, i32* %9, align 4, !dbg !555
  br label %67, !dbg !556

67:                                               ; preds = %76, %66
  %68 = load i32, i32* %9, align 4, !dbg !557
  %69 = icmp slt i32 %68, 2, !dbg !559
  br i1 %69, label %70, label %79, !dbg !560

70:                                               ; preds = %67
  %71 = load i32, i32* %9, align 4, !dbg !561
  %72 = sext i32 %71 to i64, !dbg !563
  %73 = getelementptr inbounds [2 x i64], [2 x i64]* %2, i64 0, i64 %72, !dbg !563
  %74 = load i64, i64* %73, align 8, !dbg !563
  %75 = call i32 @pthread_join(i64 noundef %74, i8** noundef null), !dbg !564
  br label %76, !dbg !565

76:                                               ; preds = %70
  %77 = load i32, i32* %9, align 4, !dbg !566
  %78 = add nsw i32 %77, 1, !dbg !566
  store i32 %78, i32* %9, align 4, !dbg !566
  br label %67, !dbg !567, !llvm.loop !568

79:                                               ; preds = %67
  call void @llvm.dbg.declare(metadata i32* %10, metadata !570, metadata !DIExpression()), !dbg !572
  store i32 0, i32* %10, align 4, !dbg !572
  br label %80, !dbg !573

80:                                               ; preds = %87, %79
  %81 = load i32, i32* %10, align 4, !dbg !574
  %82 = icmp slt i32 %81, 4, !dbg !576
  br i1 %82, label %83, label %90, !dbg !577

83:                                               ; preds = %80
  %84 = load i32, i32* %10, align 4, !dbg !578
  %85 = sext i32 %84 to i64, !dbg !580
  %86 = getelementptr inbounds [4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 %85, !dbg !580
  call void @check(%struct.Obj* noundef %86), !dbg !581
  br label %87, !dbg !582

87:                                               ; preds = %83
  %88 = load i32, i32* %10, align 4, !dbg !583
  %89 = add nsw i32 %88, 1, !dbg !583
  store i32 %89, i32* %10, align 4, !dbg !583
  br label %80, !dbg !584, !llvm.loop !585

90:                                               ; preds = %80
  ret i32 0, !dbg !587
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!75, !76, !77, !78, !79, !80, !81}
!llvm.ident = !{!82}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "q", scope: !2, file: !21, line: 81, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !15, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/lfds/wsq.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "edf38254eba72e291d688292029a0502")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 56, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "de5d66a1ef2f5448cc1919ff39db92bc")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!0, !16}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "items", scope: !2, file: !18, line: 26, type: !19, isLocal: false, isDefinition: true)
!18 = !DIFile(filename: "benchmarks/lfds/wsq.c", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "edf38254eba72e291d688292029a0502")
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 128, elements: !26)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "Obj", file: !21, line: 26, baseType: !22)
!21 = !DIFile(filename: "benchmarks/lfds/wsq.h", directory: "/home/ponce/git/Dat3M", checksumkind: CSK_MD5, checksum: "8b713fb97148388d95730439183e41c1")
!22 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Obj", file: !21, line: 24, size: 32, elements: !23)
!23 = !{!24}
!24 = !DIDerivedType(tag: DW_TAG_member, name: "field", scope: !22, file: !21, line: 25, baseType: !25, size: 32)
!25 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!26 = !{!27}
!27 = !DISubrange(count: 4)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "WorkStealQueue", file: !21, line: 78, baseType: !29)
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "WorkStealQueue", file: !21, line: 66, size: 1536, elements: !30)
!30 = !{!31, !63, !64, !65, !68, !69, !74}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "cs", scope: !29, file: !21, line: 67, baseType: !32, size: 320)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !33, line: 72, baseType: !34)
!33 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "2d764266ce95ab26d4a4767c2ec78176")
!34 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !33, line: 67, size: 320, elements: !35)
!35 = !{!36, !56, !61}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !34, file: !33, line: 69, baseType: !37, size: 320)
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !38, line: 22, size: 320, elements: !39)
!38 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "3a896f588055d599ccb9e3fe6eaee3e3")
!39 = !{!40, !41, !42, !43, !44, !45, !47, !48}
!40 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !37, file: !38, line: 24, baseType: !25, size: 32)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !37, file: !38, line: 25, baseType: !7, size: 32, offset: 32)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !37, file: !38, line: 26, baseType: !25, size: 32, offset: 64)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !37, file: !38, line: 28, baseType: !7, size: 32, offset: 96)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !37, file: !38, line: 32, baseType: !25, size: 32, offset: 128)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !37, file: !38, line: 34, baseType: !46, size: 16, offset: 160)
!46 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !37, file: !38, line: 35, baseType: !46, size: 16, offset: 176)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !37, file: !38, line: 36, baseType: !49, size: 128, offset: 192)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !50, line: 53, baseType: !51)
!50 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "4b8899127613e00869e96fcefd314d61")
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !50, line: 49, size: 128, elements: !52)
!52 = !{!53, !55}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !51, file: !50, line: 51, baseType: !54, size: 64)
!54 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !51, file: !50, line: 52, baseType: !54, size: 64, offset: 64)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !34, file: !33, line: 70, baseType: !57, size: 320)
!57 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 320, elements: !59)
!58 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!59 = !{!60}
!60 = !DISubrange(count: 40)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !34, file: !33, line: 71, baseType: !62, size: 64)
!62 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "MaxSize", scope: !29, file: !21, line: 69, baseType: !25, size: 32, offset: 320)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "InitialSize", scope: !29, file: !21, line: 70, baseType: !25, size: 32, offset: 352)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !29, file: !21, line: 72, baseType: !66, size: 32, offset: 384)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 92, baseType: !67)
!67 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !25)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !29, file: !21, line: 73, baseType: !66, size: 32, offset: 416)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "elems", scope: !29, file: !21, line: 75, baseType: !70, size: 1024, offset: 448)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !71, size: 1024, elements: !72)
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!72 = !{!73}
!73 = !DISubrange(count: 16)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "mask", scope: !29, file: !21, line: 76, baseType: !25, size: 32, offset: 1472)
!75 = !{i32 7, !"Dwarf Version", i32 5}
!76 = !{i32 2, !"Debug Info Version", i32 3}
!77 = !{i32 1, !"wchar_size", i32 4}
!78 = !{i32 7, !"PIC Level", i32 2}
!79 = !{i32 7, !"PIE Level", i32 2}
!80 = !{i32 7, !"uwtable", i32 1}
!81 = !{i32 7, !"frame-pointer", i32 2}
!82 = !{!"Ubuntu clang version 14.0.6"}
!83 = distinct !DISubprogram(name: "init_Obj", scope: !21, file: !21, line: 28, type: !84, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!84 = !DISubroutineType(types: !85)
!85 = !{null, !71}
!86 = !{}
!87 = !DILocalVariable(name: "r", arg: 1, scope: !83, file: !21, line: 28, type: !71)
!88 = !DILocation(line: 28, column: 20, scope: !83)
!89 = !DILocation(line: 29, column: 5, scope: !83)
!90 = !DILocation(line: 29, column: 8, scope: !83)
!91 = !DILocation(line: 29, column: 14, scope: !83)
!92 = !DILocation(line: 30, column: 1, scope: !83)
!93 = distinct !DISubprogram(name: "operation", scope: !21, file: !21, line: 32, type: !84, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!94 = !DILocalVariable(name: "r", arg: 1, scope: !93, file: !21, line: 32, type: !71)
!95 = !DILocation(line: 32, column: 21, scope: !93)
!96 = !DILocation(line: 33, column: 5, scope: !93)
!97 = !DILocation(line: 33, column: 8, scope: !93)
!98 = !DILocation(line: 33, column: 13, scope: !93)
!99 = !DILocation(line: 34, column: 1, scope: !93)
!100 = distinct !DISubprogram(name: "check", scope: !21, file: !21, line: 36, type: !84, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!101 = !DILocalVariable(name: "r", arg: 1, scope: !100, file: !21, line: 36, type: !71)
!102 = !DILocation(line: 36, column: 17, scope: !100)
!103 = !DILocation(line: 37, column: 5, scope: !104)
!104 = distinct !DILexicalBlock(scope: !105, file: !21, line: 37, column: 5)
!105 = distinct !DILexicalBlock(scope: !100, file: !21, line: 37, column: 5)
!106 = !DILocation(line: 37, column: 5, scope: !105)
!107 = !DILocation(line: 38, column: 1, scope: !100)
!108 = distinct !DISubprogram(name: "readV", scope: !21, file: !21, line: 83, type: !109, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!109 = !DISubroutineType(types: !110)
!110 = !{!25, !111}
!111 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!112 = !DILocalVariable(name: "v", arg: 1, scope: !108, file: !21, line: 83, type: !111)
!113 = !DILocation(line: 83, column: 23, scope: !108)
!114 = !DILocalVariable(name: "expected", scope: !108, file: !21, line: 84, type: !25)
!115 = !DILocation(line: 84, column: 9, scope: !108)
!116 = !DILocation(line: 85, column: 45, scope: !108)
!117 = !DILocation(line: 85, column: 5, scope: !108)
!118 = !DILocation(line: 86, column: 12, scope: !108)
!119 = !DILocation(line: 86, column: 5, scope: !108)
!120 = distinct !DISubprogram(name: "writeV", scope: !21, file: !21, line: 89, type: !121, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!121 = !DISubroutineType(types: !122)
!122 = !{null, !111, !25}
!123 = !DILocalVariable(name: "v", arg: 1, scope: !120, file: !21, line: 89, type: !111)
!124 = !DILocation(line: 89, column: 25, scope: !120)
!125 = !DILocalVariable(name: "w", arg: 2, scope: !120, file: !21, line: 89, type: !25)
!126 = !DILocation(line: 89, column: 32, scope: !120)
!127 = !DILocation(line: 90, column: 30, scope: !120)
!128 = !DILocation(line: 90, column: 33, scope: !120)
!129 = !DILocation(line: 90, column: 5, scope: !120)
!130 = !DILocation(line: 91, column: 1, scope: !120)
!131 = distinct !DISubprogram(name: "init_WSQ", scope: !21, file: !21, line: 93, type: !132, scopeLine: 93, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!132 = !DISubroutineType(types: !133)
!133 = !{null, !25}
!134 = !DILocalVariable(name: "size", arg: 1, scope: !131, file: !21, line: 93, type: !25)
!135 = !DILocation(line: 93, column: 19, scope: !131)
!136 = !DILocation(line: 94, column: 15, scope: !131)
!137 = !DILocation(line: 95, column: 19, scope: !131)
!138 = !DILocation(line: 96, column: 5, scope: !131)
!139 = !DILocation(line: 97, column: 5, scope: !131)
!140 = !DILocation(line: 98, column: 14, scope: !131)
!141 = !DILocation(line: 98, column: 19, scope: !131)
!142 = !DILocation(line: 98, column: 12, scope: !131)
!143 = !DILocation(line: 99, column: 5, scope: !131)
!144 = !DILocation(line: 100, column: 1, scope: !131)
!145 = distinct !DISubprogram(name: "destroy_WSQ", scope: !21, file: !21, line: 102, type: !146, scopeLine: 102, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!146 = !DISubroutineType(types: !147)
!147 = !{null}
!148 = !DILocation(line: 102, column: 21, scope: !145)
!149 = distinct !DISubprogram(name: "steal", scope: !21, file: !21, line: 114, type: !150, scopeLine: 114, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!150 = !DISubroutineType(types: !151)
!151 = !{!152, !153}
!152 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!153 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !71, size: 64)
!154 = !DILocalVariable(name: "result", arg: 1, scope: !149, file: !21, line: 114, type: !153)
!155 = !DILocation(line: 114, column: 19, scope: !149)
!156 = !DILocalVariable(name: "found", scope: !149, file: !21, line: 115, type: !152)
!157 = !DILocation(line: 115, column: 11, scope: !149)
!158 = !DILocation(line: 116, column: 5, scope: !149)
!159 = !DILocalVariable(name: "h", scope: !149, file: !21, line: 121, type: !25)
!160 = !DILocation(line: 121, column: 9, scope: !149)
!161 = !DILocation(line: 121, column: 13, scope: !149)
!162 = !DILocation(line: 122, column: 21, scope: !149)
!163 = !DILocation(line: 122, column: 23, scope: !149)
!164 = !DILocation(line: 122, column: 5, scope: !149)
!165 = !DILocation(line: 126, column: 9, scope: !166)
!166 = distinct !DILexicalBlock(scope: !149, file: !21, line: 126, column: 9)
!167 = !DILocation(line: 126, column: 13, scope: !166)
!168 = !DILocation(line: 126, column: 11, scope: !166)
!169 = !DILocation(line: 126, column: 9, scope: !149)
!170 = !DILocalVariable(name: "temp", scope: !171, file: !21, line: 129, type: !25)
!171 = distinct !DILexicalBlock(scope: !166, file: !21, line: 126, column: 29)
!172 = !DILocation(line: 129, column: 13, scope: !171)
!173 = !DILocation(line: 129, column: 20, scope: !171)
!174 = !DILocation(line: 129, column: 26, scope: !171)
!175 = !DILocation(line: 129, column: 22, scope: !171)
!176 = !DILocation(line: 130, column: 27, scope: !171)
!177 = !DILocation(line: 130, column: 19, scope: !171)
!178 = !DILocation(line: 130, column: 10, scope: !171)
!179 = !DILocation(line: 130, column: 17, scope: !171)
!180 = !DILocation(line: 131, column: 15, scope: !171)
!181 = !DILocation(line: 132, column: 5, scope: !171)
!182 = !DILocation(line: 134, column: 25, scope: !183)
!183 = distinct !DILexicalBlock(scope: !166, file: !21, line: 132, column: 12)
!184 = !DILocation(line: 134, column: 9, scope: !183)
!185 = !DILocation(line: 135, column: 15, scope: !183)
!186 = !DILocation(line: 137, column: 5, scope: !149)
!187 = !DILocation(line: 138, column: 12, scope: !149)
!188 = !DILocation(line: 138, column: 5, scope: !149)
!189 = distinct !DISubprogram(name: "syncPop", scope: !21, file: !21, line: 141, type: !150, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!190 = !DILocalVariable(name: "result", arg: 1, scope: !189, file: !21, line: 141, type: !153)
!191 = !DILocation(line: 141, column: 21, scope: !189)
!192 = !DILocalVariable(name: "found", scope: !189, file: !21, line: 142, type: !152)
!193 = !DILocation(line: 142, column: 11, scope: !189)
!194 = !DILocation(line: 144, column: 5, scope: !189)
!195 = !DILocalVariable(name: "t", scope: !189, file: !21, line: 147, type: !25)
!196 = !DILocation(line: 147, column: 9, scope: !189)
!197 = !DILocation(line: 147, column: 13, scope: !189)
!198 = !DILocation(line: 147, column: 28, scope: !189)
!199 = !DILocation(line: 148, column: 21, scope: !189)
!200 = !DILocation(line: 148, column: 5, scope: !189)
!201 = !DILocation(line: 149, column: 9, scope: !202)
!202 = distinct !DILexicalBlock(scope: !189, file: !21, line: 149, column: 9)
!203 = !DILocation(line: 149, column: 27, scope: !202)
!204 = !DILocation(line: 149, column: 24, scope: !202)
!205 = !DILocation(line: 149, column: 9, scope: !189)
!206 = !DILocalVariable(name: "temp", scope: !207, file: !21, line: 151, type: !25)
!207 = distinct !DILexicalBlock(scope: !202, file: !21, line: 149, column: 30)
!208 = !DILocation(line: 151, column: 13, scope: !207)
!209 = !DILocation(line: 151, column: 20, scope: !207)
!210 = !DILocation(line: 151, column: 26, scope: !207)
!211 = !DILocation(line: 151, column: 22, scope: !207)
!212 = !DILocation(line: 152, column: 27, scope: !207)
!213 = !DILocation(line: 152, column: 19, scope: !207)
!214 = !DILocation(line: 152, column: 10, scope: !207)
!215 = !DILocation(line: 152, column: 17, scope: !207)
!216 = !DILocation(line: 153, column: 15, scope: !207)
!217 = !DILocation(line: 154, column: 5, scope: !207)
!218 = !DILocation(line: 155, column: 25, scope: !219)
!219 = distinct !DILexicalBlock(scope: !202, file: !21, line: 154, column: 12)
!220 = !DILocation(line: 155, column: 27, scope: !219)
!221 = !DILocation(line: 155, column: 9, scope: !219)
!222 = !DILocation(line: 156, column: 15, scope: !219)
!223 = !DILocation(line: 158, column: 9, scope: !224)
!224 = distinct !DILexicalBlock(scope: !189, file: !21, line: 158, column: 9)
!225 = !DILocation(line: 158, column: 26, scope: !224)
!226 = !DILocation(line: 158, column: 24, scope: !224)
!227 = !DILocation(line: 158, column: 9, scope: !189)
!228 = !DILocation(line: 160, column: 9, scope: !229)
!229 = distinct !DILexicalBlock(scope: !224, file: !21, line: 158, column: 29)
!230 = !DILocation(line: 161, column: 9, scope: !229)
!231 = !DILocation(line: 162, column: 15, scope: !229)
!232 = !DILocation(line: 163, column: 5, scope: !229)
!233 = !DILocation(line: 164, column: 5, scope: !189)
!234 = !DILocation(line: 165, column: 12, scope: !189)
!235 = !DILocation(line: 165, column: 5, scope: !189)
!236 = distinct !DISubprogram(name: "pop", scope: !21, file: !21, line: 168, type: !150, scopeLine: 168, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!237 = !DILocalVariable(name: "result", arg: 1, scope: !236, file: !21, line: 168, type: !153)
!238 = !DILocation(line: 168, column: 17, scope: !236)
!239 = !DILocalVariable(name: "t", scope: !236, file: !21, line: 170, type: !25)
!240 = !DILocation(line: 170, column: 9, scope: !236)
!241 = !DILocation(line: 170, column: 13, scope: !236)
!242 = !DILocation(line: 170, column: 28, scope: !236)
!243 = !DILocation(line: 171, column: 21, scope: !236)
!244 = !DILocation(line: 171, column: 5, scope: !236)
!245 = !DILocation(line: 174, column: 9, scope: !246)
!246 = distinct !DILexicalBlock(scope: !236, file: !21, line: 174, column: 9)
!247 = !DILocation(line: 174, column: 27, scope: !246)
!248 = !DILocation(line: 174, column: 24, scope: !246)
!249 = !DILocation(line: 174, column: 9, scope: !236)
!250 = !DILocalVariable(name: "temp", scope: !251, file: !21, line: 177, type: !25)
!251 = distinct !DILexicalBlock(scope: !246, file: !21, line: 174, column: 30)
!252 = !DILocation(line: 177, column: 13, scope: !251)
!253 = !DILocation(line: 177, column: 20, scope: !251)
!254 = !DILocation(line: 177, column: 26, scope: !251)
!255 = !DILocation(line: 177, column: 22, scope: !251)
!256 = !DILocation(line: 178, column: 27, scope: !251)
!257 = !DILocation(line: 178, column: 19, scope: !251)
!258 = !DILocation(line: 178, column: 10, scope: !251)
!259 = !DILocation(line: 178, column: 17, scope: !251)
!260 = !DILocation(line: 179, column: 9, scope: !251)
!261 = !DILocation(line: 182, column: 25, scope: !262)
!262 = distinct !DILexicalBlock(scope: !246, file: !21, line: 180, column: 12)
!263 = !DILocation(line: 182, column: 27, scope: !262)
!264 = !DILocation(line: 182, column: 9, scope: !262)
!265 = !DILocation(line: 183, column: 24, scope: !262)
!266 = !DILocation(line: 183, column: 16, scope: !262)
!267 = !DILocation(line: 183, column: 9, scope: !262)
!268 = !DILocation(line: 185, column: 1, scope: !236)
!269 = distinct !DISubprogram(name: "syncPush", scope: !21, file: !21, line: 187, type: !84, scopeLine: 187, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!270 = !DILocalVariable(name: "elem", arg: 1, scope: !269, file: !21, line: 187, type: !71)
!271 = !DILocation(line: 187, column: 20, scope: !269)
!272 = !DILocation(line: 188, column: 5, scope: !269)
!273 = !DILocalVariable(name: "h", scope: !269, file: !21, line: 191, type: !25)
!274 = !DILocation(line: 191, column: 9, scope: !269)
!275 = !DILocation(line: 191, column: 13, scope: !269)
!276 = !DILocalVariable(name: "count", scope: !269, file: !21, line: 192, type: !25)
!277 = !DILocation(line: 192, column: 9, scope: !269)
!278 = !DILocation(line: 192, column: 17, scope: !269)
!279 = !DILocation(line: 192, column: 34, scope: !269)
!280 = !DILocation(line: 192, column: 32, scope: !269)
!281 = !DILocation(line: 195, column: 9, scope: !269)
!282 = !DILocation(line: 195, column: 15, scope: !269)
!283 = !DILocation(line: 195, column: 11, scope: !269)
!284 = !DILocation(line: 195, column: 7, scope: !269)
!285 = !DILocation(line: 196, column: 21, scope: !269)
!286 = !DILocation(line: 196, column: 5, scope: !269)
!287 = !DILocation(line: 197, column: 21, scope: !269)
!288 = !DILocation(line: 197, column: 25, scope: !269)
!289 = !DILocation(line: 197, column: 23, scope: !269)
!290 = !DILocation(line: 197, column: 5, scope: !269)
!291 = !DILocation(line: 200, column: 9, scope: !292)
!292 = distinct !DILexicalBlock(scope: !269, file: !21, line: 200, column: 9)
!293 = !DILocation(line: 200, column: 20, scope: !292)
!294 = !DILocation(line: 200, column: 15, scope: !292)
!295 = !DILocation(line: 200, column: 9, scope: !269)
!296 = !DILocalVariable(name: "newsize", scope: !297, file: !21, line: 202, type: !25)
!297 = distinct !DILexicalBlock(scope: !292, file: !21, line: 200, column: 26)
!298 = !DILocation(line: 202, column: 13, scope: !297)
!299 = !DILocation(line: 202, column: 26, scope: !297)
!300 = !DILocation(line: 202, column: 31, scope: !297)
!301 = !DILocation(line: 202, column: 24, scope: !297)
!302 = !DILocation(line: 202, column: 40, scope: !297)
!303 = !DILocation(line: 202, column: 61, scope: !297)
!304 = !DILocation(line: 202, column: 66, scope: !297)
!305 = !DILocation(line: 202, column: 56, scope: !297)
!306 = !DILocation(line: 204, column: 9, scope: !307)
!307 = distinct !DILexicalBlock(scope: !308, file: !21, line: 204, column: 9)
!308 = distinct !DILexicalBlock(scope: !297, file: !21, line: 204, column: 9)
!309 = !DILocation(line: 204, column: 9, scope: !308)
!310 = !DILocalVariable(name: "newtasks", scope: !297, file: !21, line: 206, type: !70)
!311 = !DILocation(line: 206, column: 14, scope: !297)
!312 = !DILocalVariable(name: "i", scope: !297, file: !21, line: 207, type: !25)
!313 = !DILocation(line: 207, column: 13, scope: !297)
!314 = !DILocation(line: 208, column: 16, scope: !315)
!315 = distinct !DILexicalBlock(scope: !297, file: !21, line: 208, column: 9)
!316 = !DILocation(line: 208, column: 14, scope: !315)
!317 = !DILocation(line: 208, column: 21, scope: !318)
!318 = distinct !DILexicalBlock(scope: !315, file: !21, line: 208, column: 9)
!319 = !DILocation(line: 208, column: 25, scope: !318)
!320 = !DILocation(line: 208, column: 23, scope: !318)
!321 = !DILocation(line: 208, column: 9, scope: !315)
!322 = !DILocalVariable(name: "temp", scope: !323, file: !21, line: 209, type: !25)
!323 = distinct !DILexicalBlock(scope: !318, file: !21, line: 208, column: 37)
!324 = !DILocation(line: 209, column: 17, scope: !323)
!325 = !DILocation(line: 209, column: 25, scope: !323)
!326 = !DILocation(line: 209, column: 29, scope: !323)
!327 = !DILocation(line: 209, column: 27, scope: !323)
!328 = !DILocation(line: 209, column: 36, scope: !323)
!329 = !DILocation(line: 209, column: 32, scope: !323)
!330 = !DILocation(line: 210, column: 35, scope: !323)
!331 = !DILocation(line: 210, column: 27, scope: !323)
!332 = !DILocation(line: 210, column: 22, scope: !323)
!333 = !DILocation(line: 210, column: 13, scope: !323)
!334 = !DILocation(line: 210, column: 25, scope: !323)
!335 = !DILocation(line: 211, column: 9, scope: !323)
!336 = !DILocation(line: 208, column: 33, scope: !318)
!337 = !DILocation(line: 208, column: 9, scope: !318)
!338 = distinct !{!338, !321, !339, !340}
!339 = !DILocation(line: 211, column: 9, scope: !315)
!340 = !{!"llvm.loop.mustprogress"}
!341 = !DILocation(line: 212, column: 16, scope: !342)
!342 = distinct !DILexicalBlock(scope: !297, file: !21, line: 212, column: 9)
!343 = !DILocation(line: 212, column: 14, scope: !342)
!344 = !DILocation(line: 212, column: 21, scope: !345)
!345 = distinct !DILexicalBlock(scope: !342, file: !21, line: 212, column: 9)
!346 = !DILocation(line: 212, column: 25, scope: !345)
!347 = !DILocation(line: 212, column: 23, scope: !345)
!348 = !DILocation(line: 212, column: 9, scope: !342)
!349 = !DILocation(line: 213, column: 35, scope: !350)
!350 = distinct !DILexicalBlock(scope: !345, file: !21, line: 212, column: 39)
!351 = !DILocation(line: 213, column: 26, scope: !350)
!352 = !DILocation(line: 213, column: 21, scope: !350)
!353 = !DILocation(line: 213, column: 13, scope: !350)
!354 = !DILocation(line: 213, column: 24, scope: !350)
!355 = !DILocation(line: 214, column: 9, scope: !350)
!356 = !DILocation(line: 212, column: 35, scope: !345)
!357 = !DILocation(line: 212, column: 9, scope: !345)
!358 = distinct !{!358, !348, !359, !340}
!359 = !DILocation(line: 214, column: 9, scope: !342)
!360 = !DILocation(line: 216, column: 18, scope: !297)
!361 = !DILocation(line: 216, column: 26, scope: !297)
!362 = !DILocation(line: 216, column: 16, scope: !297)
!363 = !DILocation(line: 217, column: 9, scope: !297)
!364 = !DILocation(line: 218, column: 25, scope: !297)
!365 = !DILocation(line: 218, column: 9, scope: !297)
!366 = !DILocation(line: 219, column: 5, scope: !297)
!367 = !DILocation(line: 221, column: 5, scope: !368)
!368 = distinct !DILexicalBlock(scope: !369, file: !21, line: 221, column: 5)
!369 = distinct !DILexicalBlock(scope: !269, file: !21, line: 221, column: 5)
!370 = !DILocation(line: 221, column: 5, scope: !369)
!371 = !DILocalVariable(name: "t", scope: !269, file: !21, line: 224, type: !25)
!372 = !DILocation(line: 224, column: 9, scope: !269)
!373 = !DILocation(line: 224, column: 13, scope: !269)
!374 = !DILocalVariable(name: "temp", scope: !269, file: !21, line: 225, type: !25)
!375 = !DILocation(line: 225, column: 9, scope: !269)
!376 = !DILocation(line: 225, column: 16, scope: !269)
!377 = !DILocation(line: 225, column: 22, scope: !269)
!378 = !DILocation(line: 225, column: 18, scope: !269)
!379 = !DILocation(line: 226, column: 21, scope: !269)
!380 = !DILocation(line: 226, column: 13, scope: !269)
!381 = !DILocation(line: 226, column: 5, scope: !269)
!382 = !DILocation(line: 226, column: 19, scope: !269)
!383 = !DILocation(line: 227, column: 21, scope: !269)
!384 = !DILocation(line: 227, column: 23, scope: !269)
!385 = !DILocation(line: 227, column: 5, scope: !269)
!386 = !DILocation(line: 228, column: 5, scope: !269)
!387 = !DILocation(line: 229, column: 1, scope: !269)
!388 = distinct !DISubprogram(name: "push", scope: !21, file: !21, line: 243, type: !84, scopeLine: 243, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!389 = !DILocalVariable(name: "elem", arg: 1, scope: !388, file: !21, line: 243, type: !71)
!390 = !DILocation(line: 243, column: 16, scope: !388)
!391 = !DILocalVariable(name: "t", scope: !388, file: !21, line: 244, type: !25)
!392 = !DILocation(line: 244, column: 9, scope: !388)
!393 = !DILocation(line: 244, column: 13, scope: !388)
!394 = !DILocation(line: 249, column: 9, scope: !395)
!395 = distinct !DILexicalBlock(scope: !388, file: !21, line: 249, column: 9)
!396 = !DILocation(line: 249, column: 13, scope: !395)
!397 = !DILocation(line: 249, column: 32, scope: !395)
!398 = !DILocation(line: 249, column: 28, scope: !395)
!399 = !DILocation(line: 249, column: 11, scope: !395)
!400 = !DILocation(line: 250, column: 13, scope: !395)
!401 = !DILocation(line: 250, column: 16, scope: !395)
!402 = !DILocation(line: 250, column: 22, scope: !395)
!403 = !DILocation(line: 250, column: 18, scope: !395)
!404 = !DILocation(line: 249, column: 9, scope: !388)
!405 = !DILocalVariable(name: "temp", scope: !406, file: !21, line: 253, type: !25)
!406 = distinct !DILexicalBlock(scope: !395, file: !21, line: 252, column: 5)
!407 = !DILocation(line: 253, column: 13, scope: !406)
!408 = !DILocation(line: 253, column: 20, scope: !406)
!409 = !DILocation(line: 253, column: 26, scope: !406)
!410 = !DILocation(line: 253, column: 22, scope: !406)
!411 = !DILocation(line: 254, column: 25, scope: !406)
!412 = !DILocation(line: 254, column: 17, scope: !406)
!413 = !DILocation(line: 254, column: 9, scope: !406)
!414 = !DILocation(line: 254, column: 23, scope: !406)
!415 = !DILocation(line: 255, column: 25, scope: !406)
!416 = !DILocation(line: 255, column: 27, scope: !406)
!417 = !DILocation(line: 255, column: 9, scope: !406)
!418 = !DILocation(line: 256, column: 5, scope: !406)
!419 = !DILocation(line: 258, column: 18, scope: !420)
!420 = distinct !DILexicalBlock(scope: !395, file: !21, line: 256, column: 12)
!421 = !DILocation(line: 258, column: 9, scope: !420)
!422 = !DILocation(line: 260, column: 1, scope: !388)
!423 = distinct !DISubprogram(name: "stealer", scope: !18, file: !18, line: 16, type: !424, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!424 = !DISubroutineType(types: !425)
!425 = !{!426, !426}
!426 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!427 = !DILocalVariable(name: "unused", arg: 1, scope: !423, file: !18, line: 16, type: !426)
!428 = !DILocation(line: 16, column: 21, scope: !423)
!429 = !DILocalVariable(name: "r", scope: !423, file: !18, line: 17, type: !71)
!430 = !DILocation(line: 17, column: 10, scope: !423)
!431 = !DILocalVariable(name: "i", scope: !432, file: !18, line: 18, type: !25)
!432 = distinct !DILexicalBlock(scope: !423, file: !18, line: 18, column: 5)
!433 = !DILocation(line: 18, column: 14, scope: !432)
!434 = !DILocation(line: 18, column: 10, scope: !432)
!435 = !DILocation(line: 18, column: 21, scope: !436)
!436 = distinct !DILexicalBlock(scope: !432, file: !18, line: 18, column: 5)
!437 = !DILocation(line: 18, column: 23, scope: !436)
!438 = !DILocation(line: 18, column: 5, scope: !432)
!439 = !DILocation(line: 19, column: 13, scope: !440)
!440 = distinct !DILexicalBlock(scope: !441, file: !18, line: 19, column: 13)
!441 = distinct !DILexicalBlock(scope: !436, file: !18, line: 18, column: 45)
!442 = !DILocation(line: 19, column: 13, scope: !441)
!443 = !DILocation(line: 20, column: 23, scope: !444)
!444 = distinct !DILexicalBlock(scope: !440, file: !18, line: 19, column: 24)
!445 = !DILocation(line: 20, column: 13, scope: !444)
!446 = !DILocation(line: 21, column: 9, scope: !444)
!447 = !DILocation(line: 22, column: 5, scope: !441)
!448 = !DILocation(line: 18, column: 41, scope: !436)
!449 = !DILocation(line: 18, column: 5, scope: !436)
!450 = distinct !{!450, !438, !451, !340}
!451 = !DILocation(line: 22, column: 5, scope: !432)
!452 = !DILocation(line: 23, column: 5, scope: !423)
!453 = distinct !DISubprogram(name: "main", scope: !18, file: !18, line: 28, type: !454, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!454 = !DISubroutineType(types: !455)
!455 = !{!25}
!456 = !DILocalVariable(name: "stealers", scope: !453, file: !18, line: 29, type: !457)
!457 = !DICompositeType(tag: DW_TAG_array_type, baseType: !458, size: 128, elements: !460)
!458 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !33, line: 27, baseType: !459)
!459 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!460 = !{!461}
!461 = !DISubrange(count: 2)
!462 = !DILocation(line: 29, column: 15, scope: !453)
!463 = !DILocation(line: 31, column: 5, scope: !453)
!464 = !DILocalVariable(name: "i", scope: !465, file: !18, line: 33, type: !25)
!465 = distinct !DILexicalBlock(scope: !453, file: !18, line: 33, column: 5)
!466 = !DILocation(line: 33, column: 14, scope: !465)
!467 = !DILocation(line: 33, column: 10, scope: !465)
!468 = !DILocation(line: 33, column: 21, scope: !469)
!469 = distinct !DILexicalBlock(scope: !465, file: !18, line: 33, column: 5)
!470 = !DILocation(line: 33, column: 23, scope: !469)
!471 = !DILocation(line: 33, column: 5, scope: !465)
!472 = !DILocation(line: 34, column: 25, scope: !473)
!473 = distinct !DILexicalBlock(scope: !469, file: !18, line: 33, column: 37)
!474 = !DILocation(line: 34, column: 19, scope: !473)
!475 = !DILocation(line: 34, column: 9, scope: !473)
!476 = !DILocation(line: 35, column: 5, scope: !473)
!477 = !DILocation(line: 33, column: 33, scope: !469)
!478 = !DILocation(line: 33, column: 5, scope: !469)
!479 = distinct !{!479, !471, !480, !340}
!480 = !DILocation(line: 35, column: 5, scope: !465)
!481 = !DILocalVariable(name: "i", scope: !482, file: !18, line: 37, type: !25)
!482 = distinct !DILexicalBlock(scope: !453, file: !18, line: 37, column: 5)
!483 = !DILocation(line: 37, column: 14, scope: !482)
!484 = !DILocation(line: 37, column: 10, scope: !482)
!485 = !DILocation(line: 37, column: 21, scope: !486)
!486 = distinct !DILexicalBlock(scope: !482, file: !18, line: 37, column: 5)
!487 = !DILocation(line: 37, column: 23, scope: !486)
!488 = !DILocation(line: 37, column: 5, scope: !482)
!489 = !DILocation(line: 38, column: 34, scope: !490)
!490 = distinct !DILexicalBlock(scope: !486, file: !18, line: 37, column: 40)
!491 = !DILocation(line: 38, column: 25, scope: !490)
!492 = !DILocation(line: 38, column: 9, scope: !490)
!493 = !DILocation(line: 39, column: 5, scope: !490)
!494 = !DILocation(line: 37, column: 36, scope: !486)
!495 = !DILocation(line: 37, column: 5, scope: !486)
!496 = distinct !{!496, !488, !497, !340}
!497 = !DILocation(line: 39, column: 5, scope: !482)
!498 = !DILocalVariable(name: "i", scope: !499, file: !18, line: 41, type: !25)
!499 = distinct !DILexicalBlock(scope: !453, file: !18, line: 41, column: 5)
!500 = !DILocation(line: 41, column: 14, scope: !499)
!501 = !DILocation(line: 41, column: 10, scope: !499)
!502 = !DILocation(line: 41, column: 21, scope: !503)
!503 = distinct !DILexicalBlock(scope: !499, file: !18, line: 41, column: 5)
!504 = !DILocation(line: 41, column: 23, scope: !503)
!505 = !DILocation(line: 41, column: 5, scope: !499)
!506 = !DILocation(line: 42, column: 25, scope: !507)
!507 = distinct !DILexicalBlock(scope: !503, file: !18, line: 41, column: 41)
!508 = !DILocation(line: 42, column: 23, scope: !507)
!509 = !DILocation(line: 42, column: 15, scope: !507)
!510 = !DILocation(line: 42, column: 9, scope: !507)
!511 = !DILocation(line: 43, column: 25, scope: !507)
!512 = !DILocation(line: 43, column: 23, scope: !507)
!513 = !DILocation(line: 43, column: 27, scope: !507)
!514 = !DILocation(line: 43, column: 15, scope: !507)
!515 = !DILocation(line: 43, column: 9, scope: !507)
!516 = !DILocalVariable(name: "r", scope: !507, file: !18, line: 44, type: !71)
!517 = !DILocation(line: 44, column: 14, scope: !507)
!518 = !DILocation(line: 45, column: 13, scope: !519)
!519 = distinct !DILexicalBlock(scope: !507, file: !18, line: 45, column: 13)
!520 = !DILocation(line: 45, column: 13, scope: !507)
!521 = !DILocation(line: 46, column: 23, scope: !522)
!522 = distinct !DILexicalBlock(scope: !519, file: !18, line: 45, column: 22)
!523 = !DILocation(line: 46, column: 13, scope: !522)
!524 = !DILocation(line: 47, column: 9, scope: !522)
!525 = !DILocation(line: 48, column: 5, scope: !507)
!526 = !DILocation(line: 41, column: 37, scope: !503)
!527 = !DILocation(line: 41, column: 5, scope: !503)
!528 = distinct !{!528, !505, !529, !340}
!529 = !DILocation(line: 48, column: 5, scope: !499)
!530 = !DILocalVariable(name: "i", scope: !531, file: !18, line: 50, type: !25)
!531 = distinct !DILexicalBlock(scope: !453, file: !18, line: 50, column: 5)
!532 = !DILocation(line: 50, column: 14, scope: !531)
!533 = !DILocation(line: 50, column: 10, scope: !531)
!534 = !DILocation(line: 50, column: 21, scope: !535)
!535 = distinct !DILexicalBlock(scope: !531, file: !18, line: 50, column: 5)
!536 = !DILocation(line: 50, column: 23, scope: !535)
!537 = !DILocation(line: 50, column: 5, scope: !531)
!538 = !DILocalVariable(name: "r", scope: !539, file: !18, line: 51, type: !71)
!539 = distinct !DILexicalBlock(scope: !535, file: !18, line: 50, column: 41)
!540 = !DILocation(line: 51, column: 14, scope: !539)
!541 = !DILocation(line: 52, column: 13, scope: !542)
!542 = distinct !DILexicalBlock(scope: !539, file: !18, line: 52, column: 13)
!543 = !DILocation(line: 52, column: 13, scope: !539)
!544 = !DILocation(line: 53, column: 23, scope: !545)
!545 = distinct !DILexicalBlock(scope: !542, file: !18, line: 52, column: 22)
!546 = !DILocation(line: 53, column: 13, scope: !545)
!547 = !DILocation(line: 54, column: 9, scope: !545)
!548 = !DILocation(line: 55, column: 5, scope: !539)
!549 = !DILocation(line: 50, column: 37, scope: !535)
!550 = !DILocation(line: 50, column: 5, scope: !535)
!551 = distinct !{!551, !537, !552, !340}
!552 = !DILocation(line: 55, column: 5, scope: !531)
!553 = !DILocalVariable(name: "i", scope: !554, file: !18, line: 57, type: !25)
!554 = distinct !DILexicalBlock(scope: !453, file: !18, line: 57, column: 5)
!555 = !DILocation(line: 57, column: 14, scope: !554)
!556 = !DILocation(line: 57, column: 10, scope: !554)
!557 = !DILocation(line: 57, column: 21, scope: !558)
!558 = distinct !DILexicalBlock(scope: !554, file: !18, line: 57, column: 5)
!559 = !DILocation(line: 57, column: 23, scope: !558)
!560 = !DILocation(line: 57, column: 5, scope: !554)
!561 = !DILocation(line: 58, column: 31, scope: !562)
!562 = distinct !DILexicalBlock(scope: !558, file: !18, line: 57, column: 40)
!563 = !DILocation(line: 58, column: 22, scope: !562)
!564 = !DILocation(line: 58, column: 9, scope: !562)
!565 = !DILocation(line: 59, column: 5, scope: !562)
!566 = !DILocation(line: 57, column: 36, scope: !558)
!567 = !DILocation(line: 57, column: 5, scope: !558)
!568 = distinct !{!568, !560, !569, !340}
!569 = !DILocation(line: 59, column: 5, scope: !554)
!570 = !DILocalVariable(name: "i", scope: !571, file: !18, line: 61, type: !25)
!571 = distinct !DILexicalBlock(scope: !453, file: !18, line: 61, column: 5)
!572 = !DILocation(line: 61, column: 14, scope: !571)
!573 = !DILocation(line: 61, column: 10, scope: !571)
!574 = !DILocation(line: 61, column: 21, scope: !575)
!575 = distinct !DILexicalBlock(scope: !571, file: !18, line: 61, column: 5)
!576 = !DILocation(line: 61, column: 23, scope: !575)
!577 = !DILocation(line: 61, column: 5, scope: !571)
!578 = !DILocation(line: 62, column: 22, scope: !579)
!579 = distinct !DILexicalBlock(scope: !575, file: !18, line: 61, column: 37)
!580 = !DILocation(line: 62, column: 16, scope: !579)
!581 = !DILocation(line: 62, column: 9, scope: !579)
!582 = !DILocation(line: 63, column: 5, scope: !579)
!583 = !DILocation(line: 61, column: 33, scope: !575)
!584 = !DILocation(line: 61, column: 5, scope: !575)
!585 = distinct !{!585, !577, !586, !340}
!586 = !DILocation(line: 63, column: 5, scope: !571)
!587 = !DILocation(line: 65, column: 5, scope: !453)
