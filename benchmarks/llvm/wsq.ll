; ModuleID = 'output/wsq.ll'
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
  call void @llvm.dbg.value(metadata %struct.Obj* %0, metadata !87, metadata !DIExpression()), !dbg !88
  %2 = getelementptr inbounds %struct.Obj, %struct.Obj* %0, i32 0, i32 0, !dbg !89
  store i32 0, i32* %2, align 4, !dbg !90
  ret void, !dbg !91
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @operation(%struct.Obj* noundef %0) #0 !dbg !92 {
  call void @llvm.dbg.value(metadata %struct.Obj* %0, metadata !93, metadata !DIExpression()), !dbg !94
  %2 = getelementptr inbounds %struct.Obj, %struct.Obj* %0, i32 0, i32 0, !dbg !95
  %3 = load i32, i32* %2, align 4, !dbg !96
  %4 = add nsw i32 %3, 1, !dbg !96
  store i32 %4, i32* %2, align 4, !dbg !96
  ret void, !dbg !97
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check(%struct.Obj* noundef %0) #0 !dbg !98 {
  call void @llvm.dbg.value(metadata %struct.Obj* %0, metadata !99, metadata !DIExpression()), !dbg !100
  %2 = getelementptr inbounds %struct.Obj, %struct.Obj* %0, i32 0, i32 0, !dbg !101
  %3 = load i32, i32* %2, align 4, !dbg !101
  %4 = icmp eq i32 %3, 1, !dbg !101
  br i1 %4, label %6, label %5, !dbg !104

5:                                                ; preds = %1
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([44 x i8], [44 x i8]* @.str.1, i64 0, i64 0), i32 noundef 37, i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @__PRETTY_FUNCTION__.check, i64 0, i64 0)) #5, !dbg !101
  unreachable, !dbg !101

6:                                                ; preds = %1
  ret void, !dbg !105
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @readV(i32* noundef %0) #0 !dbg !106 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !110, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i32 0, metadata !112, metadata !DIExpression()), !dbg !111
  %2 = cmpxchg i32* %0, i32 0, i32 0 seq_cst seq_cst, align 4, !dbg !113
  %3 = extractvalue { i32, i1 } %2, 0, !dbg !113
  %4 = extractvalue { i32, i1 } %2, 1, !dbg !113
  %spec.select = select i1 %4, i32 0, i32 %3, !dbg !113
  call void @llvm.dbg.value(metadata i32 %spec.select, metadata !112, metadata !DIExpression()), !dbg !111
  %5 = zext i1 %4 to i8, !dbg !113
  ret i32 %spec.select, !dbg !114
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writeV(i32* noundef %0, i32 noundef %1) #0 !dbg !115 {
  call void @llvm.dbg.value(metadata i32* %0, metadata !118, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.value(metadata i32 %1, metadata !120, metadata !DIExpression()), !dbg !119
  %3 = atomicrmw xchg i32* %0, i32 %1 seq_cst, align 4, !dbg !121
  ret void, !dbg !122
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @init_WSQ(i32 noundef %0) #0 !dbg !123 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !126, metadata !DIExpression()), !dbg !127
  store i32 1048576, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 1), align 8, !dbg !128
  store i32 1024, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 2), align 4, !dbg !129
  %2 = call i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0), %union.pthread_mutexattr_t* noundef null) #6, !dbg !130
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef 0), !dbg !131
  %3 = sub nsw i32 %0, 1, !dbg !132
  store i32 %3, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !133
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef 0), !dbg !134
  ret void, !dbg !135
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(%union.pthread_mutex_t* noundef, %union.pthread_mutexattr_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @destroy_WSQ() #0 !dbg !136 {
  ret void, !dbg !139
}

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @steal(%struct.Obj** noundef %0) #0 !dbg !140 {
  call void @llvm.dbg.value(metadata %struct.Obj** %0, metadata !145, metadata !DIExpression()), !dbg !146
  %2 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #6, !dbg !147
  %3 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3)), !dbg !148
  call void @llvm.dbg.value(metadata i32 %3, metadata !149, metadata !DIExpression()), !dbg !146
  %4 = add nsw i32 %3, 1, !dbg !150
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef %4), !dbg !151
  %5 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4)), !dbg !152
  %6 = icmp slt i32 %3, %5, !dbg !154
  br i1 %6, label %7, label %13, !dbg !155

7:                                                ; preds = %1
  %8 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !156
  %9 = and i32 %3, %8, !dbg !158
  call void @llvm.dbg.value(metadata i32 %9, metadata !159, metadata !DIExpression()), !dbg !160
  %10 = sext i32 %9 to i64, !dbg !161
  %11 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %10, !dbg !161
  %12 = load %struct.Obj*, %struct.Obj** %11, align 8, !dbg !161
  store %struct.Obj* %12, %struct.Obj** %0, align 8, !dbg !162
  call void @llvm.dbg.value(metadata i8 1, metadata !163, metadata !DIExpression()), !dbg !146
  br label %14, !dbg !164

13:                                               ; preds = %1
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef %3), !dbg !165
  call void @llvm.dbg.value(metadata i8 0, metadata !163, metadata !DIExpression()), !dbg !146
  br label %14

14:                                               ; preds = %13, %7
  %.0 = phi i8 [ 1, %7 ], [ 0, %13 ], !dbg !167
  call void @llvm.dbg.value(metadata i8 %.0, metadata !163, metadata !DIExpression()), !dbg !146
  %15 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #6, !dbg !168
  %16 = trunc i8 %.0 to i1, !dbg !169
  ret i1 %16, !dbg !170
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @syncPop(%struct.Obj** noundef %0) #0 !dbg !171 {
  call void @llvm.dbg.value(metadata %struct.Obj** %0, metadata !172, metadata !DIExpression()), !dbg !173
  %2 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #6, !dbg !174
  %3 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4)), !dbg !175
  %4 = sub nsw i32 %3, 1, !dbg !176
  call void @llvm.dbg.value(metadata i32 %4, metadata !177, metadata !DIExpression()), !dbg !173
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %4), !dbg !178
  %5 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3)), !dbg !179
  %6 = icmp sle i32 %5, %4, !dbg !181
  br i1 %6, label %7, label %13, !dbg !182

7:                                                ; preds = %1
  %8 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !183
  %9 = and i32 %4, %8, !dbg !185
  call void @llvm.dbg.value(metadata i32 %9, metadata !186, metadata !DIExpression()), !dbg !187
  %10 = sext i32 %9 to i64, !dbg !188
  %11 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %10, !dbg !188
  %12 = load %struct.Obj*, %struct.Obj** %11, align 8, !dbg !188
  store %struct.Obj* %12, %struct.Obj** %0, align 8, !dbg !189
  call void @llvm.dbg.value(metadata i8 1, metadata !190, metadata !DIExpression()), !dbg !173
  br label %14, !dbg !191

13:                                               ; preds = %1
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %3), !dbg !192
  call void @llvm.dbg.value(metadata i8 0, metadata !190, metadata !DIExpression()), !dbg !173
  br label %14

14:                                               ; preds = %13, %7
  %.0 = phi i8 [ 1, %7 ], [ 0, %13 ], !dbg !194
  call void @llvm.dbg.value(metadata i8 %.0, metadata !190, metadata !DIExpression()), !dbg !173
  %15 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3)), !dbg !195
  %16 = icmp sgt i32 %15, %4, !dbg !197
  br i1 %16, label %17, label %18, !dbg !198

17:                                               ; preds = %14
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef 0), !dbg !199
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef 0), !dbg !201
  call void @llvm.dbg.value(metadata i8 0, metadata !190, metadata !DIExpression()), !dbg !173
  br label %18, !dbg !202

18:                                               ; preds = %17, %14
  %.1 = phi i8 [ 0, %17 ], [ %.0, %14 ], !dbg !173
  call void @llvm.dbg.value(metadata i8 %.1, metadata !190, metadata !DIExpression()), !dbg !173
  %19 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #6, !dbg !203
  %20 = trunc i8 %.1 to i1, !dbg !204
  ret i1 %20, !dbg !205
}

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @pop(%struct.Obj** noundef %0) #0 !dbg !206 {
  call void @llvm.dbg.value(metadata %struct.Obj** %0, metadata !207, metadata !DIExpression()), !dbg !208
  %2 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4)), !dbg !209
  %3 = sub nsw i32 %2, 1, !dbg !210
  call void @llvm.dbg.value(metadata i32 %3, metadata !211, metadata !DIExpression()), !dbg !208
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %3), !dbg !212
  %4 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3)), !dbg !213
  %5 = icmp sle i32 %4, %3, !dbg !215
  br i1 %5, label %6, label %12, !dbg !216

6:                                                ; preds = %1
  %7 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !217
  %8 = and i32 %3, %7, !dbg !219
  call void @llvm.dbg.value(metadata i32 %8, metadata !220, metadata !DIExpression()), !dbg !221
  %9 = sext i32 %8 to i64, !dbg !222
  %10 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %9, !dbg !222
  %11 = load %struct.Obj*, %struct.Obj** %10, align 8, !dbg !222
  store %struct.Obj* %11, %struct.Obj** %0, align 8, !dbg !223
  br label %14, !dbg !224

12:                                               ; preds = %1
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %2), !dbg !225
  %13 = call zeroext i1 @syncPop(%struct.Obj** noundef %0), !dbg !227
  br label %14, !dbg !228

14:                                               ; preds = %12, %6
  %.0 = phi i1 [ true, %6 ], [ %13, %12 ], !dbg !229
  ret i1 %.0, !dbg !230
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @syncPush(%struct.Obj* noundef %0) #0 !dbg !231 {
  %2 = alloca [16 x %struct.Obj*], align 16
  call void @llvm.dbg.value(metadata %struct.Obj* %0, metadata !232, metadata !DIExpression()), !dbg !233
  %3 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #6, !dbg !234
  %4 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3)), !dbg !235
  call void @llvm.dbg.value(metadata i32 %4, metadata !236, metadata !DIExpression()), !dbg !233
  %5 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4)), !dbg !237
  %6 = sub i32 %5, %4, !dbg !238
  call void @llvm.dbg.value(metadata i32 %6, metadata !239, metadata !DIExpression()), !dbg !233
  %7 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !240
  %8 = and i32 %4, %7, !dbg !241
  call void @llvm.dbg.value(metadata i32 %8, metadata !236, metadata !DIExpression()), !dbg !233
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef %8), !dbg !242
  %9 = add nsw i32 %8, %6, !dbg !243
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %9), !dbg !244
  %10 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !245
  %11 = icmp sge i32 %6, %10, !dbg !247
  br i1 %11, label %12, label %40, !dbg !248

12:                                               ; preds = %1
  %13 = icmp eq i32 %10, 0, !dbg !249
  %14 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 2), align 4, !dbg !251
  %15 = add nsw i32 %10, 1, !dbg !251
  %16 = mul nsw i32 2, %15, !dbg !251
  %17 = select i1 %13, i32 %14, i32 %16, !dbg !251
  call void @llvm.dbg.value(metadata i32 %17, metadata !252, metadata !DIExpression()), !dbg !253
  %18 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 1), align 8, !dbg !254
  %19 = icmp slt i32 %17, %18, !dbg !254
  br i1 %19, label %21, label %20, !dbg !257

20:                                               ; preds = %12
  call void @__assert_fail(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([44 x i8], [44 x i8]* @.str.1, i64 0, i64 0), i32 noundef 204, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.syncPush, i64 0, i64 0)) #5, !dbg !254
  unreachable, !dbg !254

21:                                               ; preds = %12
  call void @llvm.dbg.declare(metadata [16 x %struct.Obj*]* %2, metadata !258, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.value(metadata i32 0, metadata !260, metadata !DIExpression()), !dbg !253
  %22 = sext i32 %8 to i64, !dbg !261
  %smax = call i32 @llvm.smax.i32(i32 %6, i32 0), !dbg !261
  %wide.trip.count = zext i32 %smax to i64, !dbg !263
  br label %23, !dbg !261

23:                                               ; preds = %24, %21
  %indvars.iv = phi i64 [ %indvars.iv.next, %24 ], [ 0, %21 ], !dbg !265
  call void @llvm.dbg.value(metadata i64 %indvars.iv, metadata !260, metadata !DIExpression()), !dbg !253
  %exitcond = icmp ne i64 %indvars.iv, %wide.trip.count, !dbg !263
  br i1 %exitcond, label %24, label %32, !dbg !266

24:                                               ; preds = %23
  %25 = add nsw i64 %22, %indvars.iv, !dbg !267
  %26 = trunc i64 %25 to i32, !dbg !269
  %27 = and i32 %26, %10, !dbg !269
  call void @llvm.dbg.value(metadata i32 %27, metadata !270, metadata !DIExpression()), !dbg !271
  %28 = sext i32 %27 to i64, !dbg !272
  %29 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %28, !dbg !272
  %30 = load %struct.Obj*, %struct.Obj** %29, align 8, !dbg !272
  %31 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* %2, i64 0, i64 %indvars.iv, !dbg !273
  store %struct.Obj* %30, %struct.Obj** %31, align 8, !dbg !274
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !275
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next, metadata !260, metadata !DIExpression()), !dbg !253
  br label %23, !dbg !276, !llvm.loop !277

32:                                               ; preds = %23
  call void @llvm.dbg.value(metadata i32 0, metadata !260, metadata !DIExpression()), !dbg !253
  %smax5 = call i32 @llvm.smax.i32(i32 %17, i32 0), !dbg !280
  %wide.trip.count6 = zext i32 %smax5 to i64, !dbg !282
  br label %33, !dbg !280

33:                                               ; preds = %34, %32
  %indvars.iv2 = phi i64 [ %indvars.iv.next3, %34 ], [ 0, %32 ], !dbg !284
  call void @llvm.dbg.value(metadata i64 %indvars.iv2, metadata !260, metadata !DIExpression()), !dbg !253
  %exitcond7 = icmp ne i64 %indvars.iv2, %wide.trip.count6, !dbg !282
  br i1 %exitcond7, label %34, label %38, !dbg !285

34:                                               ; preds = %33
  %35 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* %2, i64 0, i64 %indvars.iv2, !dbg !286
  %36 = load %struct.Obj*, %struct.Obj** %35, align 8, !dbg !286
  %37 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %indvars.iv2, !dbg !288
  store %struct.Obj* %36, %struct.Obj** %37, align 8, !dbg !289
  %indvars.iv.next3 = add nuw nsw i64 %indvars.iv2, 1, !dbg !290
  call void @llvm.dbg.value(metadata i64 %indvars.iv.next3, metadata !260, metadata !DIExpression()), !dbg !253
  br label %33, !dbg !291, !llvm.loop !292

38:                                               ; preds = %33
  %39 = sub nsw i32 %17, 1, !dbg !294
  store i32 %39, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !295
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3), i32 noundef 0), !dbg !296
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %6), !dbg !297
  %.pre = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !298
  br label %40, !dbg !301

40:                                               ; preds = %38, %1
  %41 = phi i32 [ %.pre, %38 ], [ %10, %1 ], !dbg !298
  %42 = icmp slt i32 %6, %41, !dbg !298
  br i1 %42, label %44, label %43, !dbg !302

43:                                               ; preds = %40
  call void @__assert_fail(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([44 x i8], [44 x i8]* @.str.1, i64 0, i64 0), i32 noundef 221, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @__PRETTY_FUNCTION__.syncPush, i64 0, i64 0)) #5, !dbg !298
  unreachable, !dbg !298

44:                                               ; preds = %40
  %45 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4)), !dbg !303
  call void @llvm.dbg.value(metadata i32 %45, metadata !304, metadata !DIExpression()), !dbg !233
  %46 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !305
  %47 = and i32 %45, %46, !dbg !306
  call void @llvm.dbg.value(metadata i32 %47, metadata !307, metadata !DIExpression()), !dbg !233
  %48 = sext i32 %47 to i64, !dbg !308
  %49 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %48, !dbg !308
  store %struct.Obj* %0, %struct.Obj** %49, align 8, !dbg !309
  %50 = add nsw i32 %45, 1, !dbg !310
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %50), !dbg !311
  %51 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 0)) #6, !dbg !312
  ret void, !dbg !313
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @push(%struct.Obj* noundef %0) #0 !dbg !314 {
  call void @llvm.dbg.value(metadata %struct.Obj* %0, metadata !315, metadata !DIExpression()), !dbg !316
  %2 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4)), !dbg !317
  call void @llvm.dbg.value(metadata i32 %2, metadata !318, metadata !DIExpression()), !dbg !316
  %3 = call i32 @readV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 3)), !dbg !319
  %4 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 6), align 8, !dbg !321
  %5 = add nsw i32 %3, %4, !dbg !322
  %6 = icmp slt i32 %2, %5, !dbg !323
  %7 = load i32, i32* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 1), align 8
  %8 = icmp slt i32 %2, %7
  %or.cond = select i1 %6, i1 %8, i1 false, !dbg !324
  br i1 %or.cond, label %9, label %14, !dbg !324

9:                                                ; preds = %1
  %10 = and i32 %2, %4, !dbg !325
  call void @llvm.dbg.value(metadata i32 %10, metadata !327, metadata !DIExpression()), !dbg !328
  %11 = sext i32 %10 to i64, !dbg !329
  %12 = getelementptr inbounds [16 x %struct.Obj*], [16 x %struct.Obj*]* getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 5), i64 0, i64 %11, !dbg !329
  store %struct.Obj* %0, %struct.Obj** %12, align 8, !dbg !330
  %13 = add nsw i32 %2, 1, !dbg !331
  call void @writeV(i32* noundef getelementptr inbounds (%struct.WorkStealQueue, %struct.WorkStealQueue* @q, i32 0, i32 4), i32 noundef %13), !dbg !332
  br label %15, !dbg !333

14:                                               ; preds = %1
  call void @syncPush(%struct.Obj* noundef %0), !dbg !334
  br label %15

15:                                               ; preds = %14, %9
  ret void, !dbg !336
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @stealer(i8* noundef %0) #0 !dbg !337 {
  %2 = alloca %struct.Obj*, align 8
  call void @llvm.dbg.value(metadata i8* %0, metadata !341, metadata !DIExpression()), !dbg !342
  call void @llvm.dbg.declare(metadata %struct.Obj** %2, metadata !343, metadata !DIExpression()), !dbg !344
  call void @llvm.dbg.value(metadata i32 0, metadata !345, metadata !DIExpression()), !dbg !347
  call void @llvm.dbg.value(metadata i32 0, metadata !345, metadata !DIExpression()), !dbg !347
  %3 = call zeroext i1 @steal(%struct.Obj** noundef %2), !dbg !348
  br i1 %3, label %4, label %6, !dbg !352

4:                                                ; preds = %1
  %5 = load %struct.Obj*, %struct.Obj** %2, align 8, !dbg !353
  call void @operation(%struct.Obj* noundef %5), !dbg !355
  br label %6, !dbg !356

6:                                                ; preds = %4, %1
  call void @llvm.dbg.value(metadata i32 1, metadata !345, metadata !DIExpression()), !dbg !347
  call void @llvm.dbg.value(metadata i32 1, metadata !345, metadata !DIExpression()), !dbg !347
  ret i8* null, !dbg !357
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !358 {
  %1 = alloca [2 x i64], align 16
  %2 = alloca %struct.Obj*, align 8
  %3 = alloca %struct.Obj*, align 8
  call void @llvm.dbg.declare(metadata [2 x i64]* %1, metadata !361, metadata !DIExpression()), !dbg !367
  call void @init_WSQ(i32 noundef 2), !dbg !368
  call void @llvm.dbg.value(metadata i32 0, metadata !369, metadata !DIExpression()), !dbg !371
  call void @llvm.dbg.value(metadata i64 0, metadata !369, metadata !DIExpression()), !dbg !371
  call void @init_Obj(%struct.Obj* noundef getelementptr inbounds ([4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 0)), !dbg !372
  call void @llvm.dbg.value(metadata i64 1, metadata !369, metadata !DIExpression()), !dbg !371
  call void @llvm.dbg.value(metadata i64 1, metadata !369, metadata !DIExpression()), !dbg !371
  call void @init_Obj(%struct.Obj* noundef getelementptr inbounds ([4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 1)), !dbg !372
  call void @llvm.dbg.value(metadata i64 2, metadata !369, metadata !DIExpression()), !dbg !371
  call void @llvm.dbg.value(metadata i64 2, metadata !369, metadata !DIExpression()), !dbg !371
  call void @init_Obj(%struct.Obj* noundef getelementptr inbounds ([4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 2)), !dbg !372
  call void @llvm.dbg.value(metadata i64 3, metadata !369, metadata !DIExpression()), !dbg !371
  call void @llvm.dbg.value(metadata i64 3, metadata !369, metadata !DIExpression()), !dbg !371
  call void @init_Obj(%struct.Obj* noundef getelementptr inbounds ([4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 3)), !dbg !372
  call void @llvm.dbg.value(metadata i64 4, metadata !369, metadata !DIExpression()), !dbg !371
  call void @llvm.dbg.value(metadata i64 4, metadata !369, metadata !DIExpression()), !dbg !371
  call void @llvm.dbg.value(metadata i32 0, metadata !375, metadata !DIExpression()), !dbg !377
  call void @llvm.dbg.value(metadata i64 0, metadata !375, metadata !DIExpression()), !dbg !377
  %4 = getelementptr inbounds [2 x i64], [2 x i64]* %1, i64 0, i64 0, !dbg !378
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @stealer, i8* noundef null) #6, !dbg !381
  call void @llvm.dbg.value(metadata i64 1, metadata !375, metadata !DIExpression()), !dbg !377
  call void @llvm.dbg.value(metadata i64 1, metadata !375, metadata !DIExpression()), !dbg !377
  %6 = getelementptr inbounds [2 x i64], [2 x i64]* %1, i64 0, i64 1, !dbg !378
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @stealer, i8* noundef null) #6, !dbg !381
  call void @llvm.dbg.value(metadata i64 2, metadata !375, metadata !DIExpression()), !dbg !377
  call void @llvm.dbg.value(metadata i64 2, metadata !375, metadata !DIExpression()), !dbg !377
  call void @llvm.dbg.value(metadata i32 0, metadata !382, metadata !DIExpression()), !dbg !384
  call void @llvm.dbg.value(metadata i64 0, metadata !382, metadata !DIExpression()), !dbg !384
  call void @push(%struct.Obj* noundef getelementptr inbounds ([4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 0)), !dbg !385
  call void @push(%struct.Obj* noundef getelementptr inbounds ([4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 1)), !dbg !388
  call void @llvm.dbg.declare(metadata %struct.Obj** %2, metadata !389, metadata !DIExpression()), !dbg !390
  %8 = call zeroext i1 @pop(%struct.Obj** noundef %2), !dbg !391
  br i1 %8, label %9, label %11, !dbg !393

9:                                                ; preds = %0
  %10 = load %struct.Obj*, %struct.Obj** %2, align 8, !dbg !394
  call void @operation(%struct.Obj* noundef %10), !dbg !396
  br label %11, !dbg !397

11:                                               ; preds = %9, %0
  call void @llvm.dbg.value(metadata i64 1, metadata !382, metadata !DIExpression()), !dbg !384
  call void @llvm.dbg.value(metadata i64 1, metadata !382, metadata !DIExpression()), !dbg !384
  call void @push(%struct.Obj* noundef getelementptr inbounds ([4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 2)), !dbg !385
  call void @push(%struct.Obj* noundef getelementptr inbounds ([4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 3)), !dbg !388
  call void @llvm.dbg.declare(metadata %struct.Obj** %2, metadata !389, metadata !DIExpression()), !dbg !390
  %12 = call zeroext i1 @pop(%struct.Obj** noundef %2), !dbg !391
  br i1 %12, label %13, label %15, !dbg !393

13:                                               ; preds = %11
  %14 = load %struct.Obj*, %struct.Obj** %2, align 8, !dbg !394
  call void @operation(%struct.Obj* noundef %14), !dbg !396
  br label %15, !dbg !397

15:                                               ; preds = %13, %11
  call void @llvm.dbg.value(metadata i64 2, metadata !382, metadata !DIExpression()), !dbg !384
  call void @llvm.dbg.value(metadata i64 2, metadata !382, metadata !DIExpression()), !dbg !384
  call void @llvm.dbg.value(metadata i32 0, metadata !398, metadata !DIExpression()), !dbg !400
  call void @llvm.dbg.value(metadata i32 0, metadata !398, metadata !DIExpression()), !dbg !400
  call void @llvm.dbg.declare(metadata %struct.Obj** %3, metadata !401, metadata !DIExpression()), !dbg !404
  %16 = call zeroext i1 @pop(%struct.Obj** noundef %3), !dbg !405
  br i1 %16, label %17, label %19, !dbg !407

17:                                               ; preds = %15
  %18 = load %struct.Obj*, %struct.Obj** %3, align 8, !dbg !408
  call void @operation(%struct.Obj* noundef %18), !dbg !410
  br label %19, !dbg !411

19:                                               ; preds = %17, %15
  call void @llvm.dbg.value(metadata i32 1, metadata !398, metadata !DIExpression()), !dbg !400
  call void @llvm.dbg.value(metadata i32 1, metadata !398, metadata !DIExpression()), !dbg !400
  call void @llvm.dbg.declare(metadata %struct.Obj** %3, metadata !401, metadata !DIExpression()), !dbg !404
  %20 = call zeroext i1 @pop(%struct.Obj** noundef %3), !dbg !405
  br i1 %20, label %21, label %23, !dbg !407

21:                                               ; preds = %19
  %22 = load %struct.Obj*, %struct.Obj** %3, align 8, !dbg !408
  call void @operation(%struct.Obj* noundef %22), !dbg !410
  br label %23, !dbg !411

23:                                               ; preds = %21, %19
  call void @llvm.dbg.value(metadata i32 2, metadata !398, metadata !DIExpression()), !dbg !400
  call void @llvm.dbg.value(metadata i32 2, metadata !398, metadata !DIExpression()), !dbg !400
  call void @llvm.dbg.value(metadata i32 0, metadata !412, metadata !DIExpression()), !dbg !414
  call void @llvm.dbg.value(metadata i64 0, metadata !412, metadata !DIExpression()), !dbg !414
  %24 = load i64, i64* %4, align 8, !dbg !415
  %25 = call i32 @pthread_join(i64 noundef %24, i8** noundef null), !dbg !418
  call void @llvm.dbg.value(metadata i64 1, metadata !412, metadata !DIExpression()), !dbg !414
  call void @llvm.dbg.value(metadata i64 1, metadata !412, metadata !DIExpression()), !dbg !414
  %26 = load i64, i64* %6, align 8, !dbg !415
  %27 = call i32 @pthread_join(i64 noundef %26, i8** noundef null), !dbg !418
  call void @llvm.dbg.value(metadata i64 2, metadata !412, metadata !DIExpression()), !dbg !414
  call void @llvm.dbg.value(metadata i64 2, metadata !412, metadata !DIExpression()), !dbg !414
  call void @llvm.dbg.value(metadata i32 0, metadata !419, metadata !DIExpression()), !dbg !421
  call void @llvm.dbg.value(metadata i64 0, metadata !419, metadata !DIExpression()), !dbg !421
  call void @check(%struct.Obj* noundef getelementptr inbounds ([4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 0)), !dbg !422
  call void @llvm.dbg.value(metadata i64 1, metadata !419, metadata !DIExpression()), !dbg !421
  call void @llvm.dbg.value(metadata i64 1, metadata !419, metadata !DIExpression()), !dbg !421
  call void @check(%struct.Obj* noundef getelementptr inbounds ([4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 1)), !dbg !422
  call void @llvm.dbg.value(metadata i64 2, metadata !419, metadata !DIExpression()), !dbg !421
  call void @llvm.dbg.value(metadata i64 2, metadata !419, metadata !DIExpression()), !dbg !421
  call void @check(%struct.Obj* noundef getelementptr inbounds ([4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 2)), !dbg !422
  call void @llvm.dbg.value(metadata i64 3, metadata !419, metadata !DIExpression()), !dbg !421
  call void @llvm.dbg.value(metadata i64 3, metadata !419, metadata !DIExpression()), !dbg !421
  call void @check(%struct.Obj* noundef getelementptr inbounds ([4 x %struct.Obj], [4 x %struct.Obj]* @items, i64 0, i64 3)), !dbg !422
  call void @llvm.dbg.value(metadata i64 4, metadata !419, metadata !DIExpression()), !dbg !421
  call void @llvm.dbg.value(metadata i64 4, metadata !419, metadata !DIExpression()), !dbg !421
  ret i32 0, !dbg !425
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #3

declare i32 @pthread_join(i64 noundef, i8** noundef) #4

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.smax.i32(i32, i32) #1

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
!88 = !DILocation(line: 0, scope: !83)
!89 = !DILocation(line: 29, column: 8, scope: !83)
!90 = !DILocation(line: 29, column: 14, scope: !83)
!91 = !DILocation(line: 30, column: 1, scope: !83)
!92 = distinct !DISubprogram(name: "operation", scope: !21, file: !21, line: 32, type: !84, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!93 = !DILocalVariable(name: "r", arg: 1, scope: !92, file: !21, line: 32, type: !71)
!94 = !DILocation(line: 0, scope: !92)
!95 = !DILocation(line: 33, column: 8, scope: !92)
!96 = !DILocation(line: 33, column: 13, scope: !92)
!97 = !DILocation(line: 34, column: 1, scope: !92)
!98 = distinct !DISubprogram(name: "check", scope: !21, file: !21, line: 36, type: !84, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!99 = !DILocalVariable(name: "r", arg: 1, scope: !98, file: !21, line: 36, type: !71)
!100 = !DILocation(line: 0, scope: !98)
!101 = !DILocation(line: 37, column: 5, scope: !102)
!102 = distinct !DILexicalBlock(scope: !103, file: !21, line: 37, column: 5)
!103 = distinct !DILexicalBlock(scope: !98, file: !21, line: 37, column: 5)
!104 = !DILocation(line: 37, column: 5, scope: !103)
!105 = !DILocation(line: 38, column: 1, scope: !98)
!106 = distinct !DISubprogram(name: "readV", scope: !21, file: !21, line: 83, type: !107, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!107 = !DISubroutineType(types: !108)
!108 = !{!25, !109}
!109 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!110 = !DILocalVariable(name: "v", arg: 1, scope: !106, file: !21, line: 83, type: !109)
!111 = !DILocation(line: 0, scope: !106)
!112 = !DILocalVariable(name: "expected", scope: !106, file: !21, line: 84, type: !25)
!113 = !DILocation(line: 85, column: 5, scope: !106)
!114 = !DILocation(line: 86, column: 5, scope: !106)
!115 = distinct !DISubprogram(name: "writeV", scope: !21, file: !21, line: 89, type: !116, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!116 = !DISubroutineType(types: !117)
!117 = !{null, !109, !25}
!118 = !DILocalVariable(name: "v", arg: 1, scope: !115, file: !21, line: 89, type: !109)
!119 = !DILocation(line: 0, scope: !115)
!120 = !DILocalVariable(name: "w", arg: 2, scope: !115, file: !21, line: 89, type: !25)
!121 = !DILocation(line: 90, column: 5, scope: !115)
!122 = !DILocation(line: 91, column: 1, scope: !115)
!123 = distinct !DISubprogram(name: "init_WSQ", scope: !21, file: !21, line: 93, type: !124, scopeLine: 93, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!124 = !DISubroutineType(types: !125)
!125 = !{null, !25}
!126 = !DILocalVariable(name: "size", arg: 1, scope: !123, file: !21, line: 93, type: !25)
!127 = !DILocation(line: 0, scope: !123)
!128 = !DILocation(line: 94, column: 15, scope: !123)
!129 = !DILocation(line: 95, column: 19, scope: !123)
!130 = !DILocation(line: 96, column: 5, scope: !123)
!131 = !DILocation(line: 97, column: 5, scope: !123)
!132 = !DILocation(line: 98, column: 19, scope: !123)
!133 = !DILocation(line: 98, column: 12, scope: !123)
!134 = !DILocation(line: 99, column: 5, scope: !123)
!135 = !DILocation(line: 100, column: 1, scope: !123)
!136 = distinct !DISubprogram(name: "destroy_WSQ", scope: !21, file: !21, line: 102, type: !137, scopeLine: 102, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!137 = !DISubroutineType(types: !138)
!138 = !{null}
!139 = !DILocation(line: 102, column: 21, scope: !136)
!140 = distinct !DISubprogram(name: "steal", scope: !21, file: !21, line: 114, type: !141, scopeLine: 114, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!141 = !DISubroutineType(types: !142)
!142 = !{!143, !144}
!143 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!144 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !71, size: 64)
!145 = !DILocalVariable(name: "result", arg: 1, scope: !140, file: !21, line: 114, type: !144)
!146 = !DILocation(line: 0, scope: !140)
!147 = !DILocation(line: 116, column: 5, scope: !140)
!148 = !DILocation(line: 121, column: 13, scope: !140)
!149 = !DILocalVariable(name: "h", scope: !140, file: !21, line: 121, type: !25)
!150 = !DILocation(line: 122, column: 23, scope: !140)
!151 = !DILocation(line: 122, column: 5, scope: !140)
!152 = !DILocation(line: 126, column: 13, scope: !153)
!153 = distinct !DILexicalBlock(scope: !140, file: !21, line: 126, column: 9)
!154 = !DILocation(line: 126, column: 11, scope: !153)
!155 = !DILocation(line: 126, column: 9, scope: !140)
!156 = !DILocation(line: 129, column: 26, scope: !157)
!157 = distinct !DILexicalBlock(scope: !153, file: !21, line: 126, column: 29)
!158 = !DILocation(line: 129, column: 22, scope: !157)
!159 = !DILocalVariable(name: "temp", scope: !157, file: !21, line: 129, type: !25)
!160 = !DILocation(line: 0, scope: !157)
!161 = !DILocation(line: 130, column: 19, scope: !157)
!162 = !DILocation(line: 130, column: 17, scope: !157)
!163 = !DILocalVariable(name: "found", scope: !140, file: !21, line: 115, type: !143)
!164 = !DILocation(line: 132, column: 5, scope: !157)
!165 = !DILocation(line: 134, column: 9, scope: !166)
!166 = distinct !DILexicalBlock(scope: !153, file: !21, line: 132, column: 12)
!167 = !DILocation(line: 0, scope: !153)
!168 = !DILocation(line: 137, column: 5, scope: !140)
!169 = !DILocation(line: 138, column: 12, scope: !140)
!170 = !DILocation(line: 138, column: 5, scope: !140)
!171 = distinct !DISubprogram(name: "syncPop", scope: !21, file: !21, line: 141, type: !141, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!172 = !DILocalVariable(name: "result", arg: 1, scope: !171, file: !21, line: 141, type: !144)
!173 = !DILocation(line: 0, scope: !171)
!174 = !DILocation(line: 144, column: 5, scope: !171)
!175 = !DILocation(line: 147, column: 13, scope: !171)
!176 = !DILocation(line: 147, column: 28, scope: !171)
!177 = !DILocalVariable(name: "t", scope: !171, file: !21, line: 147, type: !25)
!178 = !DILocation(line: 148, column: 5, scope: !171)
!179 = !DILocation(line: 149, column: 9, scope: !180)
!180 = distinct !DILexicalBlock(scope: !171, file: !21, line: 149, column: 9)
!181 = !DILocation(line: 149, column: 24, scope: !180)
!182 = !DILocation(line: 149, column: 9, scope: !171)
!183 = !DILocation(line: 151, column: 26, scope: !184)
!184 = distinct !DILexicalBlock(scope: !180, file: !21, line: 149, column: 30)
!185 = !DILocation(line: 151, column: 22, scope: !184)
!186 = !DILocalVariable(name: "temp", scope: !184, file: !21, line: 151, type: !25)
!187 = !DILocation(line: 0, scope: !184)
!188 = !DILocation(line: 152, column: 19, scope: !184)
!189 = !DILocation(line: 152, column: 17, scope: !184)
!190 = !DILocalVariable(name: "found", scope: !171, file: !21, line: 142, type: !143)
!191 = !DILocation(line: 154, column: 5, scope: !184)
!192 = !DILocation(line: 155, column: 9, scope: !193)
!193 = distinct !DILexicalBlock(scope: !180, file: !21, line: 154, column: 12)
!194 = !DILocation(line: 0, scope: !180)
!195 = !DILocation(line: 158, column: 9, scope: !196)
!196 = distinct !DILexicalBlock(scope: !171, file: !21, line: 158, column: 9)
!197 = !DILocation(line: 158, column: 24, scope: !196)
!198 = !DILocation(line: 158, column: 9, scope: !171)
!199 = !DILocation(line: 160, column: 9, scope: !200)
!200 = distinct !DILexicalBlock(scope: !196, file: !21, line: 158, column: 29)
!201 = !DILocation(line: 161, column: 9, scope: !200)
!202 = !DILocation(line: 163, column: 5, scope: !200)
!203 = !DILocation(line: 164, column: 5, scope: !171)
!204 = !DILocation(line: 165, column: 12, scope: !171)
!205 = !DILocation(line: 165, column: 5, scope: !171)
!206 = distinct !DISubprogram(name: "pop", scope: !21, file: !21, line: 168, type: !141, scopeLine: 168, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!207 = !DILocalVariable(name: "result", arg: 1, scope: !206, file: !21, line: 168, type: !144)
!208 = !DILocation(line: 0, scope: !206)
!209 = !DILocation(line: 170, column: 13, scope: !206)
!210 = !DILocation(line: 170, column: 28, scope: !206)
!211 = !DILocalVariable(name: "t", scope: !206, file: !21, line: 170, type: !25)
!212 = !DILocation(line: 171, column: 5, scope: !206)
!213 = !DILocation(line: 174, column: 9, scope: !214)
!214 = distinct !DILexicalBlock(scope: !206, file: !21, line: 174, column: 9)
!215 = !DILocation(line: 174, column: 24, scope: !214)
!216 = !DILocation(line: 174, column: 9, scope: !206)
!217 = !DILocation(line: 177, column: 26, scope: !218)
!218 = distinct !DILexicalBlock(scope: !214, file: !21, line: 174, column: 30)
!219 = !DILocation(line: 177, column: 22, scope: !218)
!220 = !DILocalVariable(name: "temp", scope: !218, file: !21, line: 177, type: !25)
!221 = !DILocation(line: 0, scope: !218)
!222 = !DILocation(line: 178, column: 19, scope: !218)
!223 = !DILocation(line: 178, column: 17, scope: !218)
!224 = !DILocation(line: 179, column: 9, scope: !218)
!225 = !DILocation(line: 182, column: 9, scope: !226)
!226 = distinct !DILexicalBlock(scope: !214, file: !21, line: 180, column: 12)
!227 = !DILocation(line: 183, column: 16, scope: !226)
!228 = !DILocation(line: 183, column: 9, scope: !226)
!229 = !DILocation(line: 0, scope: !214)
!230 = !DILocation(line: 185, column: 1, scope: !206)
!231 = distinct !DISubprogram(name: "syncPush", scope: !21, file: !21, line: 187, type: !84, scopeLine: 187, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!232 = !DILocalVariable(name: "elem", arg: 1, scope: !231, file: !21, line: 187, type: !71)
!233 = !DILocation(line: 0, scope: !231)
!234 = !DILocation(line: 188, column: 5, scope: !231)
!235 = !DILocation(line: 191, column: 13, scope: !231)
!236 = !DILocalVariable(name: "h", scope: !231, file: !21, line: 191, type: !25)
!237 = !DILocation(line: 192, column: 17, scope: !231)
!238 = !DILocation(line: 192, column: 32, scope: !231)
!239 = !DILocalVariable(name: "count", scope: !231, file: !21, line: 192, type: !25)
!240 = !DILocation(line: 195, column: 15, scope: !231)
!241 = !DILocation(line: 195, column: 11, scope: !231)
!242 = !DILocation(line: 196, column: 5, scope: !231)
!243 = !DILocation(line: 197, column: 23, scope: !231)
!244 = !DILocation(line: 197, column: 5, scope: !231)
!245 = !DILocation(line: 200, column: 20, scope: !246)
!246 = distinct !DILexicalBlock(scope: !231, file: !21, line: 200, column: 9)
!247 = !DILocation(line: 200, column: 15, scope: !246)
!248 = !DILocation(line: 200, column: 9, scope: !231)
!249 = !DILocation(line: 202, column: 31, scope: !250)
!250 = distinct !DILexicalBlock(scope: !246, file: !21, line: 200, column: 26)
!251 = !DILocation(line: 202, column: 24, scope: !250)
!252 = !DILocalVariable(name: "newsize", scope: !250, file: !21, line: 202, type: !25)
!253 = !DILocation(line: 0, scope: !250)
!254 = !DILocation(line: 204, column: 9, scope: !255)
!255 = distinct !DILexicalBlock(scope: !256, file: !21, line: 204, column: 9)
!256 = distinct !DILexicalBlock(scope: !250, file: !21, line: 204, column: 9)
!257 = !DILocation(line: 204, column: 9, scope: !256)
!258 = !DILocalVariable(name: "newtasks", scope: !250, file: !21, line: 206, type: !70)
!259 = !DILocation(line: 206, column: 14, scope: !250)
!260 = !DILocalVariable(name: "i", scope: !250, file: !21, line: 207, type: !25)
!261 = !DILocation(line: 208, column: 14, scope: !262)
!262 = distinct !DILexicalBlock(scope: !250, file: !21, line: 208, column: 9)
!263 = !DILocation(line: 208, column: 23, scope: !264)
!264 = distinct !DILexicalBlock(scope: !262, file: !21, line: 208, column: 9)
!265 = !DILocation(line: 0, scope: !262)
!266 = !DILocation(line: 208, column: 9, scope: !262)
!267 = !DILocation(line: 209, column: 27, scope: !268)
!268 = distinct !DILexicalBlock(scope: !264, file: !21, line: 208, column: 37)
!269 = !DILocation(line: 209, column: 32, scope: !268)
!270 = !DILocalVariable(name: "temp", scope: !268, file: !21, line: 209, type: !25)
!271 = !DILocation(line: 0, scope: !268)
!272 = !DILocation(line: 210, column: 27, scope: !268)
!273 = !DILocation(line: 210, column: 13, scope: !268)
!274 = !DILocation(line: 210, column: 25, scope: !268)
!275 = !DILocation(line: 208, column: 33, scope: !264)
!276 = !DILocation(line: 208, column: 9, scope: !264)
!277 = distinct !{!277, !266, !278, !279}
!278 = !DILocation(line: 211, column: 9, scope: !262)
!279 = !{!"llvm.loop.mustprogress"}
!280 = !DILocation(line: 212, column: 14, scope: !281)
!281 = distinct !DILexicalBlock(scope: !250, file: !21, line: 212, column: 9)
!282 = !DILocation(line: 212, column: 23, scope: !283)
!283 = distinct !DILexicalBlock(scope: !281, file: !21, line: 212, column: 9)
!284 = !DILocation(line: 0, scope: !281)
!285 = !DILocation(line: 212, column: 9, scope: !281)
!286 = !DILocation(line: 213, column: 26, scope: !287)
!287 = distinct !DILexicalBlock(scope: !283, file: !21, line: 212, column: 39)
!288 = !DILocation(line: 213, column: 13, scope: !287)
!289 = !DILocation(line: 213, column: 24, scope: !287)
!290 = !DILocation(line: 212, column: 35, scope: !283)
!291 = !DILocation(line: 212, column: 9, scope: !283)
!292 = distinct !{!292, !285, !293, !279}
!293 = !DILocation(line: 214, column: 9, scope: !281)
!294 = !DILocation(line: 216, column: 26, scope: !250)
!295 = !DILocation(line: 216, column: 16, scope: !250)
!296 = !DILocation(line: 217, column: 9, scope: !250)
!297 = !DILocation(line: 218, column: 9, scope: !250)
!298 = !DILocation(line: 221, column: 5, scope: !299)
!299 = distinct !DILexicalBlock(scope: !300, file: !21, line: 221, column: 5)
!300 = distinct !DILexicalBlock(scope: !231, file: !21, line: 221, column: 5)
!301 = !DILocation(line: 219, column: 5, scope: !250)
!302 = !DILocation(line: 221, column: 5, scope: !300)
!303 = !DILocation(line: 224, column: 13, scope: !231)
!304 = !DILocalVariable(name: "t", scope: !231, file: !21, line: 224, type: !25)
!305 = !DILocation(line: 225, column: 22, scope: !231)
!306 = !DILocation(line: 225, column: 18, scope: !231)
!307 = !DILocalVariable(name: "temp", scope: !231, file: !21, line: 225, type: !25)
!308 = !DILocation(line: 226, column: 5, scope: !231)
!309 = !DILocation(line: 226, column: 19, scope: !231)
!310 = !DILocation(line: 227, column: 23, scope: !231)
!311 = !DILocation(line: 227, column: 5, scope: !231)
!312 = !DILocation(line: 228, column: 5, scope: !231)
!313 = !DILocation(line: 229, column: 1, scope: !231)
!314 = distinct !DISubprogram(name: "push", scope: !21, file: !21, line: 243, type: !84, scopeLine: 243, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!315 = !DILocalVariable(name: "elem", arg: 1, scope: !314, file: !21, line: 243, type: !71)
!316 = !DILocation(line: 0, scope: !314)
!317 = !DILocation(line: 244, column: 13, scope: !314)
!318 = !DILocalVariable(name: "t", scope: !314, file: !21, line: 244, type: !25)
!319 = !DILocation(line: 249, column: 13, scope: !320)
!320 = distinct !DILexicalBlock(scope: !314, file: !21, line: 249, column: 9)
!321 = !DILocation(line: 249, column: 32, scope: !320)
!322 = !DILocation(line: 249, column: 28, scope: !320)
!323 = !DILocation(line: 249, column: 11, scope: !320)
!324 = !DILocation(line: 250, column: 13, scope: !320)
!325 = !DILocation(line: 253, column: 22, scope: !326)
!326 = distinct !DILexicalBlock(scope: !320, file: !21, line: 252, column: 5)
!327 = !DILocalVariable(name: "temp", scope: !326, file: !21, line: 253, type: !25)
!328 = !DILocation(line: 0, scope: !326)
!329 = !DILocation(line: 254, column: 9, scope: !326)
!330 = !DILocation(line: 254, column: 23, scope: !326)
!331 = !DILocation(line: 255, column: 27, scope: !326)
!332 = !DILocation(line: 255, column: 9, scope: !326)
!333 = !DILocation(line: 256, column: 5, scope: !326)
!334 = !DILocation(line: 258, column: 9, scope: !335)
!335 = distinct !DILexicalBlock(scope: !320, file: !21, line: 256, column: 12)
!336 = !DILocation(line: 260, column: 1, scope: !314)
!337 = distinct !DISubprogram(name: "stealer", scope: !18, file: !18, line: 16, type: !338, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!338 = !DISubroutineType(types: !339)
!339 = !{!340, !340}
!340 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!341 = !DILocalVariable(name: "unused", arg: 1, scope: !337, file: !18, line: 16, type: !340)
!342 = !DILocation(line: 0, scope: !337)
!343 = !DILocalVariable(name: "r", scope: !337, file: !18, line: 17, type: !71)
!344 = !DILocation(line: 17, column: 10, scope: !337)
!345 = !DILocalVariable(name: "i", scope: !346, file: !18, line: 18, type: !25)
!346 = distinct !DILexicalBlock(scope: !337, file: !18, line: 18, column: 5)
!347 = !DILocation(line: 0, scope: !346)
!348 = !DILocation(line: 19, column: 13, scope: !349)
!349 = distinct !DILexicalBlock(scope: !350, file: !18, line: 19, column: 13)
!350 = distinct !DILexicalBlock(scope: !351, file: !18, line: 18, column: 45)
!351 = distinct !DILexicalBlock(scope: !346, file: !18, line: 18, column: 5)
!352 = !DILocation(line: 19, column: 13, scope: !350)
!353 = !DILocation(line: 20, column: 23, scope: !354)
!354 = distinct !DILexicalBlock(scope: !349, file: !18, line: 19, column: 24)
!355 = !DILocation(line: 20, column: 13, scope: !354)
!356 = !DILocation(line: 21, column: 9, scope: !354)
!357 = !DILocation(line: 23, column: 5, scope: !337)
!358 = distinct !DISubprogram(name: "main", scope: !18, file: !18, line: 28, type: !359, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!359 = !DISubroutineType(types: !360)
!360 = !{!25}
!361 = !DILocalVariable(name: "stealers", scope: !358, file: !18, line: 29, type: !362)
!362 = !DICompositeType(tag: DW_TAG_array_type, baseType: !363, size: 128, elements: !365)
!363 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !33, line: 27, baseType: !364)
!364 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!365 = !{!366}
!366 = !DISubrange(count: 2)
!367 = !DILocation(line: 29, column: 15, scope: !358)
!368 = !DILocation(line: 31, column: 5, scope: !358)
!369 = !DILocalVariable(name: "i", scope: !370, file: !18, line: 33, type: !25)
!370 = distinct !DILexicalBlock(scope: !358, file: !18, line: 33, column: 5)
!371 = !DILocation(line: 0, scope: !370)
!372 = !DILocation(line: 34, column: 9, scope: !373)
!373 = distinct !DILexicalBlock(scope: !374, file: !18, line: 33, column: 37)
!374 = distinct !DILexicalBlock(scope: !370, file: !18, line: 33, column: 5)
!375 = !DILocalVariable(name: "i", scope: !376, file: !18, line: 37, type: !25)
!376 = distinct !DILexicalBlock(scope: !358, file: !18, line: 37, column: 5)
!377 = !DILocation(line: 0, scope: !376)
!378 = !DILocation(line: 38, column: 25, scope: !379)
!379 = distinct !DILexicalBlock(scope: !380, file: !18, line: 37, column: 40)
!380 = distinct !DILexicalBlock(scope: !376, file: !18, line: 37, column: 5)
!381 = !DILocation(line: 38, column: 9, scope: !379)
!382 = !DILocalVariable(name: "i", scope: !383, file: !18, line: 41, type: !25)
!383 = distinct !DILexicalBlock(scope: !358, file: !18, line: 41, column: 5)
!384 = !DILocation(line: 0, scope: !383)
!385 = !DILocation(line: 42, column: 9, scope: !386)
!386 = distinct !DILexicalBlock(scope: !387, file: !18, line: 41, column: 41)
!387 = distinct !DILexicalBlock(scope: !383, file: !18, line: 41, column: 5)
!388 = !DILocation(line: 43, column: 9, scope: !386)
!389 = !DILocalVariable(name: "r", scope: !386, file: !18, line: 44, type: !71)
!390 = !DILocation(line: 44, column: 14, scope: !386)
!391 = !DILocation(line: 45, column: 13, scope: !392)
!392 = distinct !DILexicalBlock(scope: !386, file: !18, line: 45, column: 13)
!393 = !DILocation(line: 45, column: 13, scope: !386)
!394 = !DILocation(line: 46, column: 23, scope: !395)
!395 = distinct !DILexicalBlock(scope: !392, file: !18, line: 45, column: 22)
!396 = !DILocation(line: 46, column: 13, scope: !395)
!397 = !DILocation(line: 47, column: 9, scope: !395)
!398 = !DILocalVariable(name: "i", scope: !399, file: !18, line: 50, type: !25)
!399 = distinct !DILexicalBlock(scope: !358, file: !18, line: 50, column: 5)
!400 = !DILocation(line: 0, scope: !399)
!401 = !DILocalVariable(name: "r", scope: !402, file: !18, line: 51, type: !71)
!402 = distinct !DILexicalBlock(scope: !403, file: !18, line: 50, column: 41)
!403 = distinct !DILexicalBlock(scope: !399, file: !18, line: 50, column: 5)
!404 = !DILocation(line: 51, column: 14, scope: !402)
!405 = !DILocation(line: 52, column: 13, scope: !406)
!406 = distinct !DILexicalBlock(scope: !402, file: !18, line: 52, column: 13)
!407 = !DILocation(line: 52, column: 13, scope: !402)
!408 = !DILocation(line: 53, column: 23, scope: !409)
!409 = distinct !DILexicalBlock(scope: !406, file: !18, line: 52, column: 22)
!410 = !DILocation(line: 53, column: 13, scope: !409)
!411 = !DILocation(line: 54, column: 9, scope: !409)
!412 = !DILocalVariable(name: "i", scope: !413, file: !18, line: 57, type: !25)
!413 = distinct !DILexicalBlock(scope: !358, file: !18, line: 57, column: 5)
!414 = !DILocation(line: 0, scope: !413)
!415 = !DILocation(line: 58, column: 22, scope: !416)
!416 = distinct !DILexicalBlock(scope: !417, file: !18, line: 57, column: 40)
!417 = distinct !DILexicalBlock(scope: !413, file: !18, line: 57, column: 5)
!418 = !DILocation(line: 58, column: 9, scope: !416)
!419 = !DILocalVariable(name: "i", scope: !420, file: !18, line: 61, type: !25)
!420 = distinct !DILexicalBlock(scope: !358, file: !18, line: 61, column: 5)
!421 = !DILocation(line: 0, scope: !420)
!422 = !DILocation(line: 62, column: 9, scope: !423)
!423 = distinct !DILexicalBlock(scope: !424, file: !18, line: 61, column: 37)
!424 = distinct !DILexicalBlock(scope: !420, file: !18, line: 61, column: 5)
!425 = !DILocation(line: 65, column: 5, scope: !358)
