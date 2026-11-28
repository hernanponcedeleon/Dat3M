; ModuleID = 'wsq.c'
source_filename = "wsq.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

%struct.WorkStealQueue = type { %struct._opaque_pthread_mutex_t, i32, i32, i32, i32, [16 x ptr], i32 }
%struct._opaque_pthread_mutex_t = type { i64, [56 x i8] }
%struct.Obj = type { i32 }

@__func__.check = private unnamed_addr constant [6 x i8] c"check\00", align 1, !dbg !0
@.str = private unnamed_addr constant [6 x i8] c"wsq.h\00", align 1, !dbg !8
@.str.1 = private unnamed_addr constant [14 x i8] c"r->field == 1\00", align 1, !dbg !11
@q = global %struct.WorkStealQueue zeroinitializer, align 8, !dbg !16
@__func__.syncPush = private unnamed_addr constant [9 x i8] c"syncPush\00", align 1, !dbg !32
@.str.2 = private unnamed_addr constant [20 x i8] c"newsize < q.MaxSize\00", align 1, !dbg !37
@.str.3 = private unnamed_addr constant [15 x i8] c"count < q.mask\00", align 1, !dbg !42
@items = global [4 x %struct.Obj] zeroinitializer, align 4, !dbg !47

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @init_Obj(ptr noundef %0) #0 !dbg !92 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !96, !DIExpression(), !97)
  %3 = load ptr, ptr %2, align 8, !dbg !98
  %4 = getelementptr inbounds nuw %struct.Obj, ptr %3, i32 0, i32 0, !dbg !99
  store i32 0, ptr %4, align 4, !dbg !100
  ret void, !dbg !101
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @operation(ptr noundef %0) #0 !dbg !102 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !103, !DIExpression(), !104)
  %3 = load ptr, ptr %2, align 8, !dbg !105
  %4 = getelementptr inbounds nuw %struct.Obj, ptr %3, i32 0, i32 0, !dbg !106
  %5 = load i32, ptr %4, align 4, !dbg !107
  %6 = add nsw i32 %5, 1, !dbg !107
  store i32 %6, ptr %4, align 4, !dbg !107
  ret void, !dbg !108
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @check(ptr noundef %0) #0 !dbg !109 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !110, !DIExpression(), !111)
  %3 = load ptr, ptr %2, align 8, !dbg !112
  %4 = getelementptr inbounds nuw %struct.Obj, ptr %3, i32 0, i32 0, !dbg !113
  %5 = load i32, ptr %4, align 4, !dbg !113
  %6 = icmp eq i32 %5, 1, !dbg !114
  %7 = xor i1 %6, true, !dbg !115
  %8 = zext i1 %7 to i32, !dbg !115
  %9 = sext i32 %8 to i64, !dbg !115
  %10 = icmp ne i64 %9, 0, !dbg !115
  br i1 %10, label %11, label %13, !dbg !115

11:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.check, ptr noundef @.str, i32 noundef 37, ptr noundef @.str.1) #3, !dbg !115
  unreachable, !dbg !115

12:                                               ; No predecessors!
  br label %14, !dbg !115

13:                                               ; preds = %1
  br label %14, !dbg !115

14:                                               ; preds = %13, %12
  ret void, !dbg !116
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @readV(ptr noundef %0) #0 !dbg !117 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !121, !DIExpression(), !122)
    #dbg_declare(ptr %3, !123, !DIExpression(), !124)
  store i32 0, ptr %3, align 4, !dbg !124
  %6 = load ptr, ptr %2, align 8, !dbg !125
  store i32 0, ptr %4, align 4, !dbg !126
  %7 = load i32, ptr %3, align 4, !dbg !126
  %8 = load i32, ptr %4, align 4, !dbg !126
  %9 = cmpxchg ptr %6, i32 %7, i32 %8 seq_cst seq_cst, align 4, !dbg !126
  %10 = extractvalue { i32, i1 } %9, 0, !dbg !126
  %11 = extractvalue { i32, i1 } %9, 1, !dbg !126
  br i1 %11, label %13, label %12, !dbg !126

12:                                               ; preds = %1
  store i32 %10, ptr %3, align 4, !dbg !126
  br label %13, !dbg !126

13:                                               ; preds = %12, %1
  %14 = zext i1 %11 to i8, !dbg !126
  store i8 %14, ptr %5, align 1, !dbg !126
  %15 = load i8, ptr %5, align 1, !dbg !126
  %16 = icmp ne i8 %15, 0, !dbg !126
  %17 = load i32, ptr %3, align 4, !dbg !127
  ret i32 %17, !dbg !128
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @writeV(ptr noundef %0, i32 noundef %1) #0 !dbg !129 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !132, !DIExpression(), !133)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !134, !DIExpression(), !135)
  %7 = load ptr, ptr %3, align 8, !dbg !136
  %8 = load i32, ptr %4, align 4, !dbg !137
  store i32 %8, ptr %5, align 4, !dbg !138
  %9 = load i32, ptr %5, align 4, !dbg !138
  %10 = atomicrmw xchg ptr %7, i32 %9 seq_cst, align 4, !dbg !138
  store i32 %10, ptr %6, align 4, !dbg !138
  %11 = load i32, ptr %6, align 4, !dbg !138
  ret void, !dbg !139
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @init_WSQ(i32 noundef %0) #0 !dbg !140 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
    #dbg_declare(ptr %2, !143, !DIExpression(), !144)
  store i32 1048576, ptr getelementptr inbounds nuw (i8, ptr @q, i64 64), align 8, !dbg !145
  store i32 1024, ptr getelementptr inbounds nuw (i8, ptr @q, i64 68), align 4, !dbg !146
  %3 = call i32 @pthread_mutex_init(ptr noundef @q, ptr noundef null), !dbg !147
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 72), i32 noundef 0), !dbg !148
  %4 = load i32, ptr %2, align 4, !dbg !149
  %5 = sub nsw i32 %4, 1, !dbg !150
  store i32 %5, ptr getelementptr inbounds nuw (i8, ptr @q, i64 208), align 8, !dbg !151
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76), i32 noundef 0), !dbg !152
  ret void, !dbg !153
}

declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @destroy_WSQ() #0 !dbg !154 {
  ret void, !dbg !157
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define zeroext i1 @steal(ptr noundef %0) #0 !dbg !158 {
  %2 = alloca ptr, align 8
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !163, !DIExpression(), !164)
    #dbg_declare(ptr %3, !165, !DIExpression(), !166)
  %6 = call i32 @pthread_mutex_lock(ptr noundef @q), !dbg !167
    #dbg_declare(ptr %4, !168, !DIExpression(), !169)
  %7 = call i32 @readV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 72)), !dbg !170
  store i32 %7, ptr %4, align 4, !dbg !169
  %8 = load i32, ptr %4, align 4, !dbg !171
  %9 = add nsw i32 %8, 1, !dbg !172
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 72), i32 noundef %9), !dbg !173
  %10 = load i32, ptr %4, align 4, !dbg !174
  %11 = call i32 @readV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76)), !dbg !176
  %12 = icmp slt i32 %10, %11, !dbg !177
  br i1 %12, label %13, label %22, !dbg !177

13:                                               ; preds = %1
    #dbg_declare(ptr %5, !178, !DIExpression(), !180)
  %14 = load i32, ptr %4, align 4, !dbg !181
  %15 = load i32, ptr getelementptr inbounds nuw (i8, ptr @q, i64 208), align 8, !dbg !182
  %16 = and i32 %14, %15, !dbg !183
  store i32 %16, ptr %5, align 4, !dbg !180
  %17 = load i32, ptr %5, align 4, !dbg !184
  %18 = sext i32 %17 to i64, !dbg !185
  %19 = getelementptr inbounds [16 x ptr], ptr getelementptr inbounds nuw (i8, ptr @q, i64 80), i64 0, i64 %18, !dbg !185
  %20 = load ptr, ptr %19, align 8, !dbg !185
  %21 = load ptr, ptr %2, align 8, !dbg !186
  store ptr %20, ptr %21, align 8, !dbg !187
  store i8 1, ptr %3, align 1, !dbg !188
  br label %24, !dbg !189

22:                                               ; preds = %1
  %23 = load i32, ptr %4, align 4, !dbg !190
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 72), i32 noundef %23), !dbg !192
  store i8 0, ptr %3, align 1, !dbg !193
  br label %24

24:                                               ; preds = %22, %13
  %25 = call i32 @pthread_mutex_unlock(ptr noundef @q), !dbg !194
  %26 = load i8, ptr %3, align 1, !dbg !195
  %27 = icmp ne i8 %26, 0, !dbg !195
  ret i1 %27, !dbg !196
}

declare i32 @pthread_mutex_lock(ptr noundef) #2

declare i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define zeroext i1 @syncPop(ptr noundef %0) #0 !dbg !197 {
  %2 = alloca ptr, align 8
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !198, !DIExpression(), !199)
    #dbg_declare(ptr %3, !200, !DIExpression(), !201)
  %6 = call i32 @pthread_mutex_lock(ptr noundef @q), !dbg !202
    #dbg_declare(ptr %4, !203, !DIExpression(), !204)
  %7 = call i32 @readV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76)), !dbg !205
  %8 = sub nsw i32 %7, 1, !dbg !206
  store i32 %8, ptr %4, align 4, !dbg !204
  %9 = load i32, ptr %4, align 4, !dbg !207
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76), i32 noundef %9), !dbg !208
  %10 = call i32 @readV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 72)), !dbg !209
  %11 = load i32, ptr %4, align 4, !dbg !211
  %12 = icmp sle i32 %10, %11, !dbg !212
  br i1 %12, label %13, label %22, !dbg !212

13:                                               ; preds = %1
    #dbg_declare(ptr %5, !213, !DIExpression(), !215)
  %14 = load i32, ptr %4, align 4, !dbg !216
  %15 = load i32, ptr getelementptr inbounds nuw (i8, ptr @q, i64 208), align 8, !dbg !217
  %16 = and i32 %14, %15, !dbg !218
  store i32 %16, ptr %5, align 4, !dbg !215
  %17 = load i32, ptr %5, align 4, !dbg !219
  %18 = sext i32 %17 to i64, !dbg !220
  %19 = getelementptr inbounds [16 x ptr], ptr getelementptr inbounds nuw (i8, ptr @q, i64 80), i64 0, i64 %18, !dbg !220
  %20 = load ptr, ptr %19, align 8, !dbg !220
  %21 = load ptr, ptr %2, align 8, !dbg !221
  store ptr %20, ptr %21, align 8, !dbg !222
  store i8 1, ptr %3, align 1, !dbg !223
  br label %25, !dbg !224

22:                                               ; preds = %1
  %23 = load i32, ptr %4, align 4, !dbg !225
  %24 = add nsw i32 %23, 1, !dbg !227
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76), i32 noundef %24), !dbg !228
  store i8 0, ptr %3, align 1, !dbg !229
  br label %25

25:                                               ; preds = %22, %13
  %26 = call i32 @readV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 72)), !dbg !230
  %27 = load i32, ptr %4, align 4, !dbg !232
  %28 = icmp sgt i32 %26, %27, !dbg !233
  br i1 %28, label %29, label %30, !dbg !233

29:                                               ; preds = %25
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 72), i32 noundef 0), !dbg !234
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76), i32 noundef 0), !dbg !236
  store i8 0, ptr %3, align 1, !dbg !237
  br label %30, !dbg !238

30:                                               ; preds = %29, %25
  %31 = call i32 @pthread_mutex_unlock(ptr noundef @q), !dbg !239
  %32 = load i8, ptr %3, align 1, !dbg !240
  %33 = icmp ne i8 %32, 0, !dbg !240
  ret i1 %33, !dbg !241
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define zeroext i1 @pop(ptr noundef %0) #0 !dbg !242 {
  %2 = alloca i1, align 1
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !243, !DIExpression(), !244)
    #dbg_declare(ptr %4, !245, !DIExpression(), !246)
  %6 = call i32 @readV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76)), !dbg !247
  %7 = sub nsw i32 %6, 1, !dbg !248
  store i32 %7, ptr %4, align 4, !dbg !246
  %8 = load i32, ptr %4, align 4, !dbg !249
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76), i32 noundef %8), !dbg !250
  %9 = call i32 @readV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 72)), !dbg !251
  %10 = load i32, ptr %4, align 4, !dbg !253
  %11 = icmp sle i32 %9, %10, !dbg !254
  br i1 %11, label %12, label %21, !dbg !254

12:                                               ; preds = %1
    #dbg_declare(ptr %5, !255, !DIExpression(), !257)
  %13 = load i32, ptr %4, align 4, !dbg !258
  %14 = load i32, ptr getelementptr inbounds nuw (i8, ptr @q, i64 208), align 8, !dbg !259
  %15 = and i32 %13, %14, !dbg !260
  store i32 %15, ptr %5, align 4, !dbg !257
  %16 = load i32, ptr %5, align 4, !dbg !261
  %17 = sext i32 %16 to i64, !dbg !262
  %18 = getelementptr inbounds [16 x ptr], ptr getelementptr inbounds nuw (i8, ptr @q, i64 80), i64 0, i64 %17, !dbg !262
  %19 = load ptr, ptr %18, align 8, !dbg !262
  %20 = load ptr, ptr %3, align 8, !dbg !263
  store ptr %19, ptr %20, align 8, !dbg !264
  store i1 true, ptr %2, align 1, !dbg !265
  br label %26, !dbg !265

21:                                               ; preds = %1
  %22 = load i32, ptr %4, align 4, !dbg !266
  %23 = add nsw i32 %22, 1, !dbg !268
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76), i32 noundef %23), !dbg !269
  %24 = load ptr, ptr %3, align 8, !dbg !270
  %25 = call zeroext i1 @syncPop(ptr noundef %24), !dbg !271
  store i1 %25, ptr %2, align 1, !dbg !272
  br label %26, !dbg !272

26:                                               ; preds = %21, %12
  %27 = load i1, ptr %2, align 1, !dbg !273
  ret i1 %27, !dbg !273
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @syncPush(ptr noundef %0) #0 !dbg !274 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca [16 x ptr], align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !275, !DIExpression(), !276)
  %11 = call i32 @pthread_mutex_lock(ptr noundef @q), !dbg !277
    #dbg_declare(ptr %3, !278, !DIExpression(), !279)
  %12 = call i32 @readV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 72)), !dbg !280
  store i32 %12, ptr %3, align 4, !dbg !279
    #dbg_declare(ptr %4, !281, !DIExpression(), !282)
  %13 = call i32 @readV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76)), !dbg !283
  %14 = load i32, ptr %3, align 4, !dbg !284
  %15 = sub nsw i32 %13, %14, !dbg !285
  store i32 %15, ptr %4, align 4, !dbg !282
  %16 = load i32, ptr %3, align 4, !dbg !286
  %17 = load i32, ptr getelementptr inbounds nuw (i8, ptr @q, i64 208), align 8, !dbg !287
  %18 = and i32 %16, %17, !dbg !288
  store i32 %18, ptr %3, align 4, !dbg !289
  %19 = load i32, ptr %3, align 4, !dbg !290
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 72), i32 noundef %19), !dbg !291
  %20 = load i32, ptr %3, align 4, !dbg !292
  %21 = load i32, ptr %4, align 4, !dbg !293
  %22 = add nsw i32 %20, %21, !dbg !294
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76), i32 noundef %22), !dbg !295
  %23 = load i32, ptr %4, align 4, !dbg !296
  %24 = load i32, ptr getelementptr inbounds nuw (i8, ptr @q, i64 208), align 8, !dbg !298
  %25 = icmp sge i32 %23, %24, !dbg !299
  br i1 %25, label %26, label %88, !dbg !299

26:                                               ; preds = %1
    #dbg_declare(ptr %5, !300, !DIExpression(), !302)
  %27 = load i32, ptr getelementptr inbounds nuw (i8, ptr @q, i64 208), align 8, !dbg !303
  %28 = icmp eq i32 %27, 0, !dbg !304
  br i1 %28, label %29, label %31, !dbg !305

29:                                               ; preds = %26
  %30 = load i32, ptr getelementptr inbounds nuw (i8, ptr @q, i64 68), align 4, !dbg !306
  br label %35, !dbg !305

31:                                               ; preds = %26
  %32 = load i32, ptr getelementptr inbounds nuw (i8, ptr @q, i64 208), align 8, !dbg !307
  %33 = add nsw i32 %32, 1, !dbg !308
  %34 = mul nsw i32 2, %33, !dbg !309
  br label %35, !dbg !305

35:                                               ; preds = %31, %29
  %36 = phi i32 [ %30, %29 ], [ %34, %31 ], !dbg !305
  store i32 %36, ptr %5, align 4, !dbg !302
  %37 = load i32, ptr %5, align 4, !dbg !310
  %38 = load i32, ptr getelementptr inbounds nuw (i8, ptr @q, i64 64), align 8, !dbg !311
  %39 = icmp slt i32 %37, %38, !dbg !312
  %40 = xor i1 %39, true, !dbg !313
  %41 = zext i1 %40 to i32, !dbg !313
  %42 = sext i32 %41 to i64, !dbg !313
  %43 = icmp ne i64 %42, 0, !dbg !313
  br i1 %43, label %44, label %46, !dbg !313

44:                                               ; preds = %35
  call void @__assert_rtn(ptr noundef @__func__.syncPush, ptr noundef @.str, i32 noundef 204, ptr noundef @.str.2) #3, !dbg !313
  unreachable, !dbg !313

45:                                               ; No predecessors!
  br label %47, !dbg !313

46:                                               ; preds = %35
  br label %47, !dbg !313

47:                                               ; preds = %46, %45
    #dbg_declare(ptr %6, !314, !DIExpression(), !315)
    #dbg_declare(ptr %7, !316, !DIExpression(), !317)
  store i32 0, ptr %7, align 4, !dbg !318
  br label %48, !dbg !320

48:                                               ; preds = %65, %47
  %49 = load i32, ptr %7, align 4, !dbg !321
  %50 = load i32, ptr %4, align 4, !dbg !323
  %51 = icmp slt i32 %49, %50, !dbg !324
  br i1 %51, label %52, label %68, !dbg !325

52:                                               ; preds = %48
    #dbg_declare(ptr %8, !326, !DIExpression(), !328)
  %53 = load i32, ptr %3, align 4, !dbg !329
  %54 = load i32, ptr %7, align 4, !dbg !330
  %55 = add nsw i32 %53, %54, !dbg !331
  %56 = load i32, ptr getelementptr inbounds nuw (i8, ptr @q, i64 208), align 8, !dbg !332
  %57 = and i32 %55, %56, !dbg !333
  store i32 %57, ptr %8, align 4, !dbg !328
  %58 = load i32, ptr %8, align 4, !dbg !334
  %59 = sext i32 %58 to i64, !dbg !335
  %60 = getelementptr inbounds [16 x ptr], ptr getelementptr inbounds nuw (i8, ptr @q, i64 80), i64 0, i64 %59, !dbg !335
  %61 = load ptr, ptr %60, align 8, !dbg !335
  %62 = load i32, ptr %7, align 4, !dbg !336
  %63 = sext i32 %62 to i64, !dbg !337
  %64 = getelementptr inbounds [16 x ptr], ptr %6, i64 0, i64 %63, !dbg !337
  store ptr %61, ptr %64, align 8, !dbg !338
  br label %65, !dbg !339

65:                                               ; preds = %52
  %66 = load i32, ptr %7, align 4, !dbg !340
  %67 = add nsw i32 %66, 1, !dbg !340
  store i32 %67, ptr %7, align 4, !dbg !340
  br label %48, !dbg !341, !llvm.loop !342

68:                                               ; preds = %48
  store i32 0, ptr %7, align 4, !dbg !345
  br label %69, !dbg !347

69:                                               ; preds = %81, %68
  %70 = load i32, ptr %7, align 4, !dbg !348
  %71 = load i32, ptr %5, align 4, !dbg !350
  %72 = icmp slt i32 %70, %71, !dbg !351
  br i1 %72, label %73, label %84, !dbg !352

73:                                               ; preds = %69
  %74 = load i32, ptr %7, align 4, !dbg !353
  %75 = sext i32 %74 to i64, !dbg !355
  %76 = getelementptr inbounds [16 x ptr], ptr %6, i64 0, i64 %75, !dbg !355
  %77 = load ptr, ptr %76, align 8, !dbg !355
  %78 = load i32, ptr %7, align 4, !dbg !356
  %79 = sext i32 %78 to i64, !dbg !357
  %80 = getelementptr inbounds [16 x ptr], ptr getelementptr inbounds nuw (i8, ptr @q, i64 80), i64 0, i64 %79, !dbg !357
  store ptr %77, ptr %80, align 8, !dbg !358
  br label %81, !dbg !359

81:                                               ; preds = %73
  %82 = load i32, ptr %7, align 4, !dbg !360
  %83 = add nsw i32 %82, 1, !dbg !360
  store i32 %83, ptr %7, align 4, !dbg !360
  br label %69, !dbg !361, !llvm.loop !362

84:                                               ; preds = %69
  %85 = load i32, ptr %5, align 4, !dbg !364
  %86 = sub nsw i32 %85, 1, !dbg !365
  store i32 %86, ptr getelementptr inbounds nuw (i8, ptr @q, i64 208), align 8, !dbg !366
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 72), i32 noundef 0), !dbg !367
  %87 = load i32, ptr %4, align 4, !dbg !368
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76), i32 noundef %87), !dbg !369
  br label %88, !dbg !370

88:                                               ; preds = %84, %1
  %89 = load i32, ptr %4, align 4, !dbg !371
  %90 = load i32, ptr getelementptr inbounds nuw (i8, ptr @q, i64 208), align 8, !dbg !372
  %91 = icmp slt i32 %89, %90, !dbg !373
  %92 = xor i1 %91, true, !dbg !374
  %93 = zext i1 %92 to i32, !dbg !374
  %94 = sext i32 %93 to i64, !dbg !374
  %95 = icmp ne i64 %94, 0, !dbg !374
  br i1 %95, label %96, label %98, !dbg !374

96:                                               ; preds = %88
  call void @__assert_rtn(ptr noundef @__func__.syncPush, ptr noundef @.str, i32 noundef 221, ptr noundef @.str.3) #3, !dbg !374
  unreachable, !dbg !374

97:                                               ; No predecessors!
  br label %99, !dbg !374

98:                                               ; preds = %88
  br label %99, !dbg !374

99:                                               ; preds = %98, %97
    #dbg_declare(ptr %9, !375, !DIExpression(), !376)
  %100 = call i32 @readV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76)), !dbg !377
  store i32 %100, ptr %9, align 4, !dbg !376
    #dbg_declare(ptr %10, !378, !DIExpression(), !379)
  %101 = load i32, ptr %9, align 4, !dbg !380
  %102 = load i32, ptr getelementptr inbounds nuw (i8, ptr @q, i64 208), align 8, !dbg !381
  %103 = and i32 %101, %102, !dbg !382
  store i32 %103, ptr %10, align 4, !dbg !379
  %104 = load ptr, ptr %2, align 8, !dbg !383
  %105 = load i32, ptr %10, align 4, !dbg !384
  %106 = sext i32 %105 to i64, !dbg !385
  %107 = getelementptr inbounds [16 x ptr], ptr getelementptr inbounds nuw (i8, ptr @q, i64 80), i64 0, i64 %106, !dbg !385
  store ptr %104, ptr %107, align 8, !dbg !386
  %108 = load i32, ptr %9, align 4, !dbg !387
  %109 = add nsw i32 %108, 1, !dbg !388
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76), i32 noundef %109), !dbg !389
  %110 = call i32 @pthread_mutex_unlock(ptr noundef @q), !dbg !390
  ret void, !dbg !391
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @push(ptr noundef %0) #0 !dbg !392 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !393, !DIExpression(), !394)
    #dbg_declare(ptr %3, !395, !DIExpression(), !396)
  %5 = call i32 @readV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76)), !dbg !397
  store i32 %5, ptr %3, align 4, !dbg !396
  %6 = load i32, ptr %3, align 4, !dbg !398
  %7 = call i32 @readV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 72)), !dbg !400
  %8 = load i32, ptr getelementptr inbounds nuw (i8, ptr @q, i64 208), align 8, !dbg !401
  %9 = add nsw i32 %7, %8, !dbg !402
  %10 = add nsw i32 %9, 1, !dbg !403
  %11 = icmp slt i32 %6, %10, !dbg !404
  br i1 %11, label %12, label %26, !dbg !405

12:                                               ; preds = %1
  %13 = load i32, ptr %3, align 4, !dbg !406
  %14 = load i32, ptr getelementptr inbounds nuw (i8, ptr @q, i64 64), align 8, !dbg !407
  %15 = icmp slt i32 %13, %14, !dbg !408
  br i1 %15, label %16, label %26, !dbg !405

16:                                               ; preds = %12
    #dbg_declare(ptr %4, !409, !DIExpression(), !411)
  %17 = load i32, ptr %3, align 4, !dbg !412
  %18 = load i32, ptr getelementptr inbounds nuw (i8, ptr @q, i64 208), align 8, !dbg !413
  %19 = and i32 %17, %18, !dbg !414
  store i32 %19, ptr %4, align 4, !dbg !411
  %20 = load ptr, ptr %2, align 8, !dbg !415
  %21 = load i32, ptr %4, align 4, !dbg !416
  %22 = sext i32 %21 to i64, !dbg !417
  %23 = getelementptr inbounds [16 x ptr], ptr getelementptr inbounds nuw (i8, ptr @q, i64 80), i64 0, i64 %22, !dbg !417
  store ptr %20, ptr %23, align 8, !dbg !418
  %24 = load i32, ptr %3, align 4, !dbg !419
  %25 = add nsw i32 %24, 1, !dbg !420
  call void @writeV(ptr noundef getelementptr inbounds nuw (i8, ptr @q, i64 76), i32 noundef %25), !dbg !421
  br label %28, !dbg !422

26:                                               ; preds = %12, %1
  %27 = load ptr, ptr %2, align 8, !dbg !423
  call void @syncPush(ptr noundef %27), !dbg !425
  br label %28

28:                                               ; preds = %26, %16
  ret void, !dbg !426
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @stealer(ptr noundef %0) #0 !dbg !427 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !431, !DIExpression(), !432)
    #dbg_declare(ptr %3, !433, !DIExpression(), !434)
    #dbg_declare(ptr %4, !435, !DIExpression(), !437)
  store i32 0, ptr %4, align 4, !dbg !437
  br label %5, !dbg !438

5:                                                ; preds = %13, %1
  %6 = load i32, ptr %4, align 4, !dbg !439
  %7 = icmp slt i32 %6, 1, !dbg !441
  br i1 %7, label %8, label %16, !dbg !442

8:                                                ; preds = %5
  %9 = call zeroext i1 @steal(ptr noundef %3), !dbg !443
  br i1 %9, label %10, label %12, !dbg !443

10:                                               ; preds = %8
  %11 = load ptr, ptr %3, align 8, !dbg !446
  call void @operation(ptr noundef %11), !dbg !448
  br label %12, !dbg !449

12:                                               ; preds = %10, %8
  br label %13, !dbg !450

13:                                               ; preds = %12
  %14 = load i32, ptr %4, align 4, !dbg !451
  %15 = add nsw i32 %14, 1, !dbg !451
  store i32 %15, ptr %4, align 4, !dbg !451
  br label %5, !dbg !452, !llvm.loop !453

16:                                               ; preds = %5
  ret ptr null, !dbg !455
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !456 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !459, !DIExpression(), !484)
  call void @init_WSQ(i32 noundef 2), !dbg !485
    #dbg_declare(ptr %3, !486, !DIExpression(), !488)
  store i32 0, ptr %3, align 4, !dbg !488
  br label %11, !dbg !489

11:                                               ; preds = %18, %0
  %12 = load i32, ptr %3, align 4, !dbg !490
  %13 = icmp slt i32 %12, 4, !dbg !492
  br i1 %13, label %14, label %21, !dbg !493

14:                                               ; preds = %11
  %15 = load i32, ptr %3, align 4, !dbg !494
  %16 = sext i32 %15 to i64, !dbg !496
  %17 = getelementptr inbounds [4 x %struct.Obj], ptr @items, i64 0, i64 %16, !dbg !496
  call void @init_Obj(ptr noundef %17), !dbg !497
  br label %18, !dbg !498

18:                                               ; preds = %14
  %19 = load i32, ptr %3, align 4, !dbg !499
  %20 = add nsw i32 %19, 1, !dbg !499
  store i32 %20, ptr %3, align 4, !dbg !499
  br label %11, !dbg !500, !llvm.loop !501

21:                                               ; preds = %11
    #dbg_declare(ptr %4, !503, !DIExpression(), !505)
  store i32 0, ptr %4, align 4, !dbg !505
  br label %22, !dbg !506

22:                                               ; preds = %30, %21
  %23 = load i32, ptr %4, align 4, !dbg !507
  %24 = icmp slt i32 %23, 2, !dbg !509
  br i1 %24, label %25, label %33, !dbg !510

25:                                               ; preds = %22
  %26 = load i32, ptr %4, align 4, !dbg !511
  %27 = sext i32 %26 to i64, !dbg !513
  %28 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %27, !dbg !513
  %29 = call i32 @pthread_create(ptr noundef %28, ptr noundef null, ptr noundef @stealer, ptr noundef null), !dbg !514
  br label %30, !dbg !515

30:                                               ; preds = %25
  %31 = load i32, ptr %4, align 4, !dbg !516
  %32 = add nsw i32 %31, 1, !dbg !516
  store i32 %32, ptr %4, align 4, !dbg !516
  br label %22, !dbg !517, !llvm.loop !518

33:                                               ; preds = %22
    #dbg_declare(ptr %5, !520, !DIExpression(), !522)
  store i32 0, ptr %5, align 4, !dbg !522
  br label %34, !dbg !523

34:                                               ; preds = %51, %33
  %35 = load i32, ptr %5, align 4, !dbg !524
  %36 = icmp slt i32 %35, 2, !dbg !526
  br i1 %36, label %37, label %54, !dbg !527

37:                                               ; preds = %34
  %38 = load i32, ptr %5, align 4, !dbg !528
  %39 = mul nsw i32 2, %38, !dbg !530
  %40 = sext i32 %39 to i64, !dbg !531
  %41 = getelementptr inbounds [4 x %struct.Obj], ptr @items, i64 0, i64 %40, !dbg !531
  call void @push(ptr noundef %41), !dbg !532
  %42 = load i32, ptr %5, align 4, !dbg !533
  %43 = mul nsw i32 2, %42, !dbg !534
  %44 = add nsw i32 %43, 1, !dbg !535
  %45 = sext i32 %44 to i64, !dbg !536
  %46 = getelementptr inbounds [4 x %struct.Obj], ptr @items, i64 0, i64 %45, !dbg !536
  call void @push(ptr noundef %46), !dbg !537
    #dbg_declare(ptr %6, !538, !DIExpression(), !539)
  %47 = call zeroext i1 @pop(ptr noundef %6), !dbg !540
  br i1 %47, label %48, label %50, !dbg !540

48:                                               ; preds = %37
  %49 = load ptr, ptr %6, align 8, !dbg !542
  call void @operation(ptr noundef %49), !dbg !544
  br label %50, !dbg !545

50:                                               ; preds = %48, %37
  br label %51, !dbg !546

51:                                               ; preds = %50
  %52 = load i32, ptr %5, align 4, !dbg !547
  %53 = add nsw i32 %52, 1, !dbg !547
  store i32 %53, ptr %5, align 4, !dbg !547
  br label %34, !dbg !548, !llvm.loop !549

54:                                               ; preds = %34
    #dbg_declare(ptr %7, !551, !DIExpression(), !553)
  store i32 0, ptr %7, align 4, !dbg !553
  br label %55, !dbg !554

55:                                               ; preds = %63, %54
  %56 = load i32, ptr %7, align 4, !dbg !555
  %57 = icmp slt i32 %56, 2, !dbg !557
  br i1 %57, label %58, label %66, !dbg !558

58:                                               ; preds = %55
    #dbg_declare(ptr %8, !559, !DIExpression(), !561)
  %59 = call zeroext i1 @pop(ptr noundef %8), !dbg !562
  br i1 %59, label %60, label %62, !dbg !562

60:                                               ; preds = %58
  %61 = load ptr, ptr %8, align 8, !dbg !564
  call void @operation(ptr noundef %61), !dbg !566
  br label %62, !dbg !567

62:                                               ; preds = %60, %58
  br label %63, !dbg !568

63:                                               ; preds = %62
  %64 = load i32, ptr %7, align 4, !dbg !569
  %65 = add nsw i32 %64, 1, !dbg !569
  store i32 %65, ptr %7, align 4, !dbg !569
  br label %55, !dbg !570, !llvm.loop !571

66:                                               ; preds = %55
    #dbg_declare(ptr %9, !573, !DIExpression(), !575)
  store i32 0, ptr %9, align 4, !dbg !575
  br label %67, !dbg !576

67:                                               ; preds = %76, %66
  %68 = load i32, ptr %9, align 4, !dbg !577
  %69 = icmp slt i32 %68, 2, !dbg !579
  br i1 %69, label %70, label %79, !dbg !580

70:                                               ; preds = %67
  %71 = load i32, ptr %9, align 4, !dbg !581
  %72 = sext i32 %71 to i64, !dbg !583
  %73 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %72, !dbg !583
  %74 = load ptr, ptr %73, align 8, !dbg !583
  %75 = call i32 @"\01_pthread_join"(ptr noundef %74, ptr noundef null), !dbg !584
  br label %76, !dbg !585

76:                                               ; preds = %70
  %77 = load i32, ptr %9, align 4, !dbg !586
  %78 = add nsw i32 %77, 1, !dbg !586
  store i32 %78, ptr %9, align 4, !dbg !586
  br label %67, !dbg !587, !llvm.loop !588

79:                                               ; preds = %67
    #dbg_declare(ptr %10, !590, !DIExpression(), !592)
  store i32 0, ptr %10, align 4, !dbg !592
  br label %80, !dbg !593

80:                                               ; preds = %87, %79
  %81 = load i32, ptr %10, align 4, !dbg !594
  %82 = icmp slt i32 %81, 4, !dbg !596
  br i1 %82, label %83, label %90, !dbg !597

83:                                               ; preds = %80
  %84 = load i32, ptr %10, align 4, !dbg !598
  %85 = sext i32 %84 to i64, !dbg !600
  %86 = getelementptr inbounds [4 x %struct.Obj], ptr @items, i64 0, i64 %85, !dbg !600
  call void @check(ptr noundef %86), !dbg !601
  br label %87, !dbg !602

87:                                               ; preds = %83
  %88 = load i32, ptr %10, align 4, !dbg !603
  %89 = add nsw i32 %88, 1, !dbg !603
  store i32 %89, ptr %10, align 4, !dbg !603
  br label %80, !dbg !604, !llvm.loop !605

90:                                               ; preds = %80
  ret i32 0, !dbg !607
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!85, !86, !87, !88, !89, !90}
!llvm.dbg.cu = !{!18}
!llvm.ident = !{!91}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 37, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "./wsq.h", directory: "/Users/hponcedeleon/git/Dat3M/benchmarks/challenging", checksumkind: CSK_MD5, checksum: "8b713fb97148388d95730439183e41c1")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 48, elements: !6)
!4 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !5)
!5 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!6 = !{!7}
!7 = !DISubrange(count: 6)
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(scope: null, file: !2, line: 37, type: !10, isLocal: true, isDefinition: true)
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 48, elements: !6)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(scope: null, file: !2, line: 37, type: !13, isLocal: true, isDefinition: true)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 112, elements: !14)
!14 = !{!15}
!15 = !DISubrange(count: 14)
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "q", scope: !18, file: !2, line: 81, type: !57, isLocal: false, isDefinition: true)
!18 = distinct !DICompileUnit(language: DW_LANG_C11, file: !19, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !20, globals: !31, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk", sdk: "MacOSX26.sdk")
!19 = !DIFile(filename: "wsq.c", directory: "/Users/hponcedeleon/git/Dat3M/benchmarks/challenging", checksumkind: CSK_MD5, checksum: "edf38254eba72e291d688292029a0502")
!20 = !{!21}
!21 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !22, line: 68, baseType: !23, size: 32, elements: !24)
!22 = !DIFile(filename: "/opt/homebrew/Cellar/llvm/23.1.0/lib/clang/23/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "f17199a988fe91afffaf0f943ef87096")
!23 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!24 = !{!25, !26, !27, !28, !29, !30}
!25 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!26 = !DIEnumerator(name: "memory_order_consume", value: 1)
!27 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!28 = !DIEnumerator(name: "memory_order_release", value: 3)
!29 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!30 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!31 = !{!0, !8, !11, !32, !37, !42, !16, !47}
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(scope: null, file: !2, line: 204, type: !34, isLocal: true, isDefinition: true)
!34 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !35)
!35 = !{!36}
!36 = !DISubrange(count: 9)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !2, line: 204, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 160, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 20)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !2, line: 221, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 120, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 15)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "items", scope: !18, file: !19, line: 26, type: !49, isLocal: false, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 128, elements: !55)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "Obj", file: !2, line: 26, baseType: !51)
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Obj", file: !2, line: 24, size: 32, elements: !52)
!52 = !{!53}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "field", scope: !51, file: !2, line: 25, baseType: !54, size: 32)
!54 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!55 = !{!56}
!56 = !DISubrange(count: 4)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "WorkStealQueue", file: !2, line: 78, baseType: !58)
!58 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "WorkStealQueue", file: !2, line: 66, size: 1728, elements: !59)
!59 = !{!60, !73, !74, !75, !78, !79, !84}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "cs", scope: !58, file: !2, line: 67, baseType: !61, size: 512)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !62, line: 31, baseType: !63)
!62 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_mutex_t.h", directory: "", checksumkind: CSK_MD5, checksum: "583a89b25a16f85ebbdf32f8d9f237ec")
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_mutex_t", file: !64, line: 113, baseType: !65)
!64 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!65 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_mutex_t", file: !64, line: 78, size: 512, elements: !66)
!66 = !{!67, !69}
!67 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !65, file: !64, line: 79, baseType: !68, size: 64)
!68 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !65, file: !64, line: 80, baseType: !70, size: 448, offset: 64)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 448, elements: !71)
!71 = !{!72}
!72 = !DISubrange(count: 56)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "MaxSize", scope: !58, file: !2, line: 69, baseType: !54, size: 32, offset: 512)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "InitialSize", scope: !58, file: !2, line: 70, baseType: !54, size: 32, offset: 544)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !58, file: !2, line: 72, baseType: !76, size: 32, offset: 576)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !22, line: 104, baseType: !77)
!77 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !54)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !58, file: !2, line: 73, baseType: !76, size: 32, offset: 608)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "elems", scope: !58, file: !2, line: 75, baseType: !80, size: 1024, offset: 640)
!80 = !DICompositeType(tag: DW_TAG_array_type, baseType: !81, size: 1024, elements: !82)
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!82 = !{!83}
!83 = !DISubrange(count: 16)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "mask", scope: !58, file: !2, line: 76, baseType: !54, size: 32, offset: 1664)
!85 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!86 = !{i32 7, !"Dwarf Version", i32 5}
!87 = !{i32 2, !"Debug Info Version", i32 3}
!88 = !{i32 8, !"PIC Level", i32 2}
!89 = !{i32 7, !"uwtable", i32 1}
!90 = !{i32 7, !"frame-pointer", i32 4}
!91 = !{!"Homebrew clang version 23.1.0"}
!92 = distinct !DISubprogram(name: "init_Obj", scope: !2, file: !2, line: 28, type: !93, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !95)
!93 = !DISubroutineType(types: !94)
!94 = !{null, !81}
!95 = !{}
!96 = !DILocalVariable(name: "r", arg: 1, scope: !92, file: !2, line: 28, type: !81)
!97 = !DILocation(line: 28, column: 20, scope: !92)
!98 = !DILocation(line: 29, column: 5, scope: !92)
!99 = !DILocation(line: 29, column: 8, scope: !92)
!100 = !DILocation(line: 29, column: 14, scope: !92)
!101 = !DILocation(line: 30, column: 1, scope: !92)
!102 = distinct !DISubprogram(name: "operation", scope: !2, file: !2, line: 32, type: !93, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !95)
!103 = !DILocalVariable(name: "r", arg: 1, scope: !102, file: !2, line: 32, type: !81)
!104 = !DILocation(line: 32, column: 21, scope: !102)
!105 = !DILocation(line: 33, column: 5, scope: !102)
!106 = !DILocation(line: 33, column: 8, scope: !102)
!107 = !DILocation(line: 33, column: 13, scope: !102)
!108 = !DILocation(line: 34, column: 1, scope: !102)
!109 = distinct !DISubprogram(name: "check", scope: !2, file: !2, line: 36, type: !93, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !95)
!110 = !DILocalVariable(name: "r", arg: 1, scope: !109, file: !2, line: 36, type: !81)
!111 = !DILocation(line: 36, column: 17, scope: !109)
!112 = !DILocation(line: 37, column: 12, scope: !109)
!113 = !DILocation(line: 37, column: 15, scope: !109)
!114 = !DILocation(line: 37, column: 21, scope: !109)
!115 = !DILocation(line: 37, column: 5, scope: !109)
!116 = !DILocation(line: 38, column: 1, scope: !109)
!117 = distinct !DISubprogram(name: "readV", scope: !2, file: !2, line: 83, type: !118, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !95)
!118 = !DISubroutineType(types: !119)
!119 = !{!54, !120}
!120 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!121 = !DILocalVariable(name: "v", arg: 1, scope: !117, file: !2, line: 83, type: !120)
!122 = !DILocation(line: 83, column: 23, scope: !117)
!123 = !DILocalVariable(name: "expected", scope: !117, file: !2, line: 84, type: !54)
!124 = !DILocation(line: 84, column: 9, scope: !117)
!125 = !DILocation(line: 85, column: 45, scope: !117)
!126 = !DILocation(line: 85, column: 5, scope: !117)
!127 = !DILocation(line: 86, column: 12, scope: !117)
!128 = !DILocation(line: 86, column: 5, scope: !117)
!129 = distinct !DISubprogram(name: "writeV", scope: !2, file: !2, line: 89, type: !130, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !95)
!130 = !DISubroutineType(types: !131)
!131 = !{null, !120, !54}
!132 = !DILocalVariable(name: "v", arg: 1, scope: !129, file: !2, line: 89, type: !120)
!133 = !DILocation(line: 89, column: 25, scope: !129)
!134 = !DILocalVariable(name: "w", arg: 2, scope: !129, file: !2, line: 89, type: !54)
!135 = !DILocation(line: 89, column: 32, scope: !129)
!136 = !DILocation(line: 90, column: 30, scope: !129)
!137 = !DILocation(line: 90, column: 33, scope: !129)
!138 = !DILocation(line: 90, column: 5, scope: !129)
!139 = !DILocation(line: 91, column: 1, scope: !129)
!140 = distinct !DISubprogram(name: "init_WSQ", scope: !2, file: !2, line: 93, type: !141, scopeLine: 93, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !95)
!141 = !DISubroutineType(types: !142)
!142 = !{null, !54}
!143 = !DILocalVariable(name: "size", arg: 1, scope: !140, file: !2, line: 93, type: !54)
!144 = !DILocation(line: 93, column: 19, scope: !140)
!145 = !DILocation(line: 94, column: 15, scope: !140)
!146 = !DILocation(line: 95, column: 19, scope: !140)
!147 = !DILocation(line: 96, column: 5, scope: !140)
!148 = !DILocation(line: 97, column: 5, scope: !140)
!149 = !DILocation(line: 98, column: 14, scope: !140)
!150 = !DILocation(line: 98, column: 19, scope: !140)
!151 = !DILocation(line: 98, column: 12, scope: !140)
!152 = !DILocation(line: 99, column: 5, scope: !140)
!153 = !DILocation(line: 100, column: 1, scope: !140)
!154 = distinct !DISubprogram(name: "destroy_WSQ", scope: !2, file: !2, line: 102, type: !155, scopeLine: 102, spFlags: DISPFlagDefinition, unit: !18)
!155 = !DISubroutineType(types: !156)
!156 = !{null}
!157 = !DILocation(line: 102, column: 21, scope: !154)
!158 = distinct !DISubprogram(name: "steal", scope: !2, file: !2, line: 114, type: !159, scopeLine: 114, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !95)
!159 = !DISubroutineType(types: !160)
!160 = !{!161, !162}
!161 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!162 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!163 = !DILocalVariable(name: "result", arg: 1, scope: !158, file: !2, line: 114, type: !162)
!164 = !DILocation(line: 114, column: 19, scope: !158)
!165 = !DILocalVariable(name: "found", scope: !158, file: !2, line: 115, type: !161)
!166 = !DILocation(line: 115, column: 11, scope: !158)
!167 = !DILocation(line: 116, column: 5, scope: !158)
!168 = !DILocalVariable(name: "h", scope: !158, file: !2, line: 121, type: !54)
!169 = !DILocation(line: 121, column: 9, scope: !158)
!170 = !DILocation(line: 121, column: 13, scope: !158)
!171 = !DILocation(line: 122, column: 21, scope: !158)
!172 = !DILocation(line: 122, column: 23, scope: !158)
!173 = !DILocation(line: 122, column: 5, scope: !158)
!174 = !DILocation(line: 126, column: 9, scope: !175)
!175 = distinct !DILexicalBlock(scope: !158, file: !2, line: 126, column: 9)
!176 = !DILocation(line: 126, column: 13, scope: !175)
!177 = !DILocation(line: 126, column: 11, scope: !175)
!178 = !DILocalVariable(name: "temp", scope: !179, file: !2, line: 129, type: !54)
!179 = distinct !DILexicalBlock(scope: !175, file: !2, line: 126, column: 29)
!180 = !DILocation(line: 129, column: 13, scope: !179)
!181 = !DILocation(line: 129, column: 20, scope: !179)
!182 = !DILocation(line: 129, column: 26, scope: !179)
!183 = !DILocation(line: 129, column: 22, scope: !179)
!184 = !DILocation(line: 130, column: 27, scope: !179)
!185 = !DILocation(line: 130, column: 19, scope: !179)
!186 = !DILocation(line: 130, column: 10, scope: !179)
!187 = !DILocation(line: 130, column: 17, scope: !179)
!188 = !DILocation(line: 131, column: 15, scope: !179)
!189 = !DILocation(line: 132, column: 5, scope: !179)
!190 = !DILocation(line: 134, column: 25, scope: !191)
!191 = distinct !DILexicalBlock(scope: !175, file: !2, line: 132, column: 12)
!192 = !DILocation(line: 134, column: 9, scope: !191)
!193 = !DILocation(line: 135, column: 15, scope: !191)
!194 = !DILocation(line: 137, column: 5, scope: !158)
!195 = !DILocation(line: 138, column: 12, scope: !158)
!196 = !DILocation(line: 138, column: 5, scope: !158)
!197 = distinct !DISubprogram(name: "syncPop", scope: !2, file: !2, line: 141, type: !159, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !95)
!198 = !DILocalVariable(name: "result", arg: 1, scope: !197, file: !2, line: 141, type: !162)
!199 = !DILocation(line: 141, column: 21, scope: !197)
!200 = !DILocalVariable(name: "found", scope: !197, file: !2, line: 142, type: !161)
!201 = !DILocation(line: 142, column: 11, scope: !197)
!202 = !DILocation(line: 144, column: 5, scope: !197)
!203 = !DILocalVariable(name: "t", scope: !197, file: !2, line: 147, type: !54)
!204 = !DILocation(line: 147, column: 9, scope: !197)
!205 = !DILocation(line: 147, column: 13, scope: !197)
!206 = !DILocation(line: 147, column: 28, scope: !197)
!207 = !DILocation(line: 148, column: 21, scope: !197)
!208 = !DILocation(line: 148, column: 5, scope: !197)
!209 = !DILocation(line: 149, column: 9, scope: !210)
!210 = distinct !DILexicalBlock(scope: !197, file: !2, line: 149, column: 9)
!211 = !DILocation(line: 149, column: 27, scope: !210)
!212 = !DILocation(line: 149, column: 24, scope: !210)
!213 = !DILocalVariable(name: "temp", scope: !214, file: !2, line: 151, type: !54)
!214 = distinct !DILexicalBlock(scope: !210, file: !2, line: 149, column: 30)
!215 = !DILocation(line: 151, column: 13, scope: !214)
!216 = !DILocation(line: 151, column: 20, scope: !214)
!217 = !DILocation(line: 151, column: 26, scope: !214)
!218 = !DILocation(line: 151, column: 22, scope: !214)
!219 = !DILocation(line: 152, column: 27, scope: !214)
!220 = !DILocation(line: 152, column: 19, scope: !214)
!221 = !DILocation(line: 152, column: 10, scope: !214)
!222 = !DILocation(line: 152, column: 17, scope: !214)
!223 = !DILocation(line: 153, column: 15, scope: !214)
!224 = !DILocation(line: 154, column: 5, scope: !214)
!225 = !DILocation(line: 155, column: 25, scope: !226)
!226 = distinct !DILexicalBlock(scope: !210, file: !2, line: 154, column: 12)
!227 = !DILocation(line: 155, column: 27, scope: !226)
!228 = !DILocation(line: 155, column: 9, scope: !226)
!229 = !DILocation(line: 156, column: 15, scope: !226)
!230 = !DILocation(line: 158, column: 9, scope: !231)
!231 = distinct !DILexicalBlock(scope: !197, file: !2, line: 158, column: 9)
!232 = !DILocation(line: 158, column: 26, scope: !231)
!233 = !DILocation(line: 158, column: 24, scope: !231)
!234 = !DILocation(line: 160, column: 9, scope: !235)
!235 = distinct !DILexicalBlock(scope: !231, file: !2, line: 158, column: 29)
!236 = !DILocation(line: 161, column: 9, scope: !235)
!237 = !DILocation(line: 162, column: 15, scope: !235)
!238 = !DILocation(line: 163, column: 5, scope: !235)
!239 = !DILocation(line: 164, column: 5, scope: !197)
!240 = !DILocation(line: 165, column: 12, scope: !197)
!241 = !DILocation(line: 165, column: 5, scope: !197)
!242 = distinct !DISubprogram(name: "pop", scope: !2, file: !2, line: 168, type: !159, scopeLine: 168, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !95)
!243 = !DILocalVariable(name: "result", arg: 1, scope: !242, file: !2, line: 168, type: !162)
!244 = !DILocation(line: 168, column: 17, scope: !242)
!245 = !DILocalVariable(name: "t", scope: !242, file: !2, line: 170, type: !54)
!246 = !DILocation(line: 170, column: 9, scope: !242)
!247 = !DILocation(line: 170, column: 13, scope: !242)
!248 = !DILocation(line: 170, column: 28, scope: !242)
!249 = !DILocation(line: 171, column: 21, scope: !242)
!250 = !DILocation(line: 171, column: 5, scope: !242)
!251 = !DILocation(line: 174, column: 9, scope: !252)
!252 = distinct !DILexicalBlock(scope: !242, file: !2, line: 174, column: 9)
!253 = !DILocation(line: 174, column: 27, scope: !252)
!254 = !DILocation(line: 174, column: 24, scope: !252)
!255 = !DILocalVariable(name: "temp", scope: !256, file: !2, line: 177, type: !54)
!256 = distinct !DILexicalBlock(scope: !252, file: !2, line: 174, column: 30)
!257 = !DILocation(line: 177, column: 13, scope: !256)
!258 = !DILocation(line: 177, column: 20, scope: !256)
!259 = !DILocation(line: 177, column: 26, scope: !256)
!260 = !DILocation(line: 177, column: 22, scope: !256)
!261 = !DILocation(line: 178, column: 27, scope: !256)
!262 = !DILocation(line: 178, column: 19, scope: !256)
!263 = !DILocation(line: 178, column: 10, scope: !256)
!264 = !DILocation(line: 178, column: 17, scope: !256)
!265 = !DILocation(line: 179, column: 9, scope: !256)
!266 = !DILocation(line: 182, column: 25, scope: !267)
!267 = distinct !DILexicalBlock(scope: !252, file: !2, line: 180, column: 12)
!268 = !DILocation(line: 182, column: 27, scope: !267)
!269 = !DILocation(line: 182, column: 9, scope: !267)
!270 = !DILocation(line: 183, column: 24, scope: !267)
!271 = !DILocation(line: 183, column: 16, scope: !267)
!272 = !DILocation(line: 183, column: 9, scope: !267)
!273 = !DILocation(line: 185, column: 1, scope: !242)
!274 = distinct !DISubprogram(name: "syncPush", scope: !2, file: !2, line: 187, type: !93, scopeLine: 187, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !95)
!275 = !DILocalVariable(name: "elem", arg: 1, scope: !274, file: !2, line: 187, type: !81)
!276 = !DILocation(line: 187, column: 20, scope: !274)
!277 = !DILocation(line: 188, column: 5, scope: !274)
!278 = !DILocalVariable(name: "h", scope: !274, file: !2, line: 191, type: !54)
!279 = !DILocation(line: 191, column: 9, scope: !274)
!280 = !DILocation(line: 191, column: 13, scope: !274)
!281 = !DILocalVariable(name: "count", scope: !274, file: !2, line: 192, type: !54)
!282 = !DILocation(line: 192, column: 9, scope: !274)
!283 = !DILocation(line: 192, column: 17, scope: !274)
!284 = !DILocation(line: 192, column: 34, scope: !274)
!285 = !DILocation(line: 192, column: 32, scope: !274)
!286 = !DILocation(line: 195, column: 9, scope: !274)
!287 = !DILocation(line: 195, column: 15, scope: !274)
!288 = !DILocation(line: 195, column: 11, scope: !274)
!289 = !DILocation(line: 195, column: 7, scope: !274)
!290 = !DILocation(line: 196, column: 21, scope: !274)
!291 = !DILocation(line: 196, column: 5, scope: !274)
!292 = !DILocation(line: 197, column: 21, scope: !274)
!293 = !DILocation(line: 197, column: 25, scope: !274)
!294 = !DILocation(line: 197, column: 23, scope: !274)
!295 = !DILocation(line: 197, column: 5, scope: !274)
!296 = !DILocation(line: 200, column: 9, scope: !297)
!297 = distinct !DILexicalBlock(scope: !274, file: !2, line: 200, column: 9)
!298 = !DILocation(line: 200, column: 20, scope: !297)
!299 = !DILocation(line: 200, column: 15, scope: !297)
!300 = !DILocalVariable(name: "newsize", scope: !301, file: !2, line: 202, type: !54)
!301 = distinct !DILexicalBlock(scope: !297, file: !2, line: 200, column: 26)
!302 = !DILocation(line: 202, column: 13, scope: !301)
!303 = !DILocation(line: 202, column: 26, scope: !301)
!304 = !DILocation(line: 202, column: 31, scope: !301)
!305 = !DILocation(line: 202, column: 24, scope: !301)
!306 = !DILocation(line: 202, column: 40, scope: !301)
!307 = !DILocation(line: 202, column: 61, scope: !301)
!308 = !DILocation(line: 202, column: 66, scope: !301)
!309 = !DILocation(line: 202, column: 56, scope: !301)
!310 = !DILocation(line: 204, column: 16, scope: !301)
!311 = !DILocation(line: 204, column: 28, scope: !301)
!312 = !DILocation(line: 204, column: 24, scope: !301)
!313 = !DILocation(line: 204, column: 9, scope: !301)
!314 = !DILocalVariable(name: "newtasks", scope: !301, file: !2, line: 206, type: !80)
!315 = !DILocation(line: 206, column: 14, scope: !301)
!316 = !DILocalVariable(name: "i", scope: !301, file: !2, line: 207, type: !54)
!317 = !DILocation(line: 207, column: 13, scope: !301)
!318 = !DILocation(line: 208, column: 16, scope: !319)
!319 = distinct !DILexicalBlock(scope: !301, file: !2, line: 208, column: 9)
!320 = !DILocation(line: 208, column: 14, scope: !319)
!321 = !DILocation(line: 208, column: 21, scope: !322)
!322 = distinct !DILexicalBlock(scope: !319, file: !2, line: 208, column: 9)
!323 = !DILocation(line: 208, column: 25, scope: !322)
!324 = !DILocation(line: 208, column: 23, scope: !322)
!325 = !DILocation(line: 208, column: 9, scope: !319)
!326 = !DILocalVariable(name: "temp", scope: !327, file: !2, line: 209, type: !54)
!327 = distinct !DILexicalBlock(scope: !322, file: !2, line: 208, column: 37)
!328 = !DILocation(line: 209, column: 17, scope: !327)
!329 = !DILocation(line: 209, column: 25, scope: !327)
!330 = !DILocation(line: 209, column: 29, scope: !327)
!331 = !DILocation(line: 209, column: 27, scope: !327)
!332 = !DILocation(line: 209, column: 36, scope: !327)
!333 = !DILocation(line: 209, column: 32, scope: !327)
!334 = !DILocation(line: 210, column: 35, scope: !327)
!335 = !DILocation(line: 210, column: 27, scope: !327)
!336 = !DILocation(line: 210, column: 22, scope: !327)
!337 = !DILocation(line: 210, column: 13, scope: !327)
!338 = !DILocation(line: 210, column: 25, scope: !327)
!339 = !DILocation(line: 211, column: 9, scope: !327)
!340 = !DILocation(line: 208, column: 33, scope: !322)
!341 = !DILocation(line: 208, column: 9, scope: !322)
!342 = distinct !{!342, !325, !343, !344}
!343 = !DILocation(line: 211, column: 9, scope: !319)
!344 = !{!"llvm.loop.mustprogress"}
!345 = !DILocation(line: 212, column: 16, scope: !346)
!346 = distinct !DILexicalBlock(scope: !301, file: !2, line: 212, column: 9)
!347 = !DILocation(line: 212, column: 14, scope: !346)
!348 = !DILocation(line: 212, column: 21, scope: !349)
!349 = distinct !DILexicalBlock(scope: !346, file: !2, line: 212, column: 9)
!350 = !DILocation(line: 212, column: 25, scope: !349)
!351 = !DILocation(line: 212, column: 23, scope: !349)
!352 = !DILocation(line: 212, column: 9, scope: !346)
!353 = !DILocation(line: 213, column: 35, scope: !354)
!354 = distinct !DILexicalBlock(scope: !349, file: !2, line: 212, column: 39)
!355 = !DILocation(line: 213, column: 26, scope: !354)
!356 = !DILocation(line: 213, column: 21, scope: !354)
!357 = !DILocation(line: 213, column: 13, scope: !354)
!358 = !DILocation(line: 213, column: 24, scope: !354)
!359 = !DILocation(line: 214, column: 9, scope: !354)
!360 = !DILocation(line: 212, column: 35, scope: !349)
!361 = !DILocation(line: 212, column: 9, scope: !349)
!362 = distinct !{!362, !352, !363, !344}
!363 = !DILocation(line: 214, column: 9, scope: !346)
!364 = !DILocation(line: 216, column: 18, scope: !301)
!365 = !DILocation(line: 216, column: 26, scope: !301)
!366 = !DILocation(line: 216, column: 16, scope: !301)
!367 = !DILocation(line: 217, column: 9, scope: !301)
!368 = !DILocation(line: 218, column: 25, scope: !301)
!369 = !DILocation(line: 218, column: 9, scope: !301)
!370 = !DILocation(line: 219, column: 5, scope: !301)
!371 = !DILocation(line: 221, column: 12, scope: !274)
!372 = !DILocation(line: 221, column: 22, scope: !274)
!373 = !DILocation(line: 221, column: 18, scope: !274)
!374 = !DILocation(line: 221, column: 5, scope: !274)
!375 = !DILocalVariable(name: "t", scope: !274, file: !2, line: 224, type: !54)
!376 = !DILocation(line: 224, column: 9, scope: !274)
!377 = !DILocation(line: 224, column: 13, scope: !274)
!378 = !DILocalVariable(name: "temp", scope: !274, file: !2, line: 225, type: !54)
!379 = !DILocation(line: 225, column: 9, scope: !274)
!380 = !DILocation(line: 225, column: 16, scope: !274)
!381 = !DILocation(line: 225, column: 22, scope: !274)
!382 = !DILocation(line: 225, column: 18, scope: !274)
!383 = !DILocation(line: 226, column: 21, scope: !274)
!384 = !DILocation(line: 226, column: 13, scope: !274)
!385 = !DILocation(line: 226, column: 5, scope: !274)
!386 = !DILocation(line: 226, column: 19, scope: !274)
!387 = !DILocation(line: 227, column: 21, scope: !274)
!388 = !DILocation(line: 227, column: 23, scope: !274)
!389 = !DILocation(line: 227, column: 5, scope: !274)
!390 = !DILocation(line: 228, column: 5, scope: !274)
!391 = !DILocation(line: 229, column: 1, scope: !274)
!392 = distinct !DISubprogram(name: "push", scope: !2, file: !2, line: 243, type: !93, scopeLine: 243, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !95)
!393 = !DILocalVariable(name: "elem", arg: 1, scope: !392, file: !2, line: 243, type: !81)
!394 = !DILocation(line: 243, column: 16, scope: !392)
!395 = !DILocalVariable(name: "t", scope: !392, file: !2, line: 244, type: !54)
!396 = !DILocation(line: 244, column: 9, scope: !392)
!397 = !DILocation(line: 244, column: 13, scope: !392)
!398 = !DILocation(line: 247, column: 9, scope: !399)
!399 = distinct !DILexicalBlock(scope: !392, file: !2, line: 247, column: 9)
!400 = !DILocation(line: 247, column: 13, scope: !399)
!401 = !DILocation(line: 247, column: 32, scope: !399)
!402 = !DILocation(line: 247, column: 28, scope: !399)
!403 = !DILocation(line: 247, column: 37, scope: !399)
!404 = !DILocation(line: 247, column: 11, scope: !399)
!405 = !DILocation(line: 247, column: 41, scope: !399)
!406 = !DILocation(line: 247, column: 44, scope: !399)
!407 = !DILocation(line: 247, column: 50, scope: !399)
!408 = !DILocation(line: 247, column: 46, scope: !399)
!409 = !DILocalVariable(name: "temp", scope: !410, file: !2, line: 253, type: !54)
!410 = distinct !DILexicalBlock(scope: !399, file: !2, line: 252, column: 5)
!411 = !DILocation(line: 253, column: 13, scope: !410)
!412 = !DILocation(line: 253, column: 20, scope: !410)
!413 = !DILocation(line: 253, column: 26, scope: !410)
!414 = !DILocation(line: 253, column: 22, scope: !410)
!415 = !DILocation(line: 254, column: 25, scope: !410)
!416 = !DILocation(line: 254, column: 17, scope: !410)
!417 = !DILocation(line: 254, column: 9, scope: !410)
!418 = !DILocation(line: 254, column: 23, scope: !410)
!419 = !DILocation(line: 255, column: 25, scope: !410)
!420 = !DILocation(line: 255, column: 27, scope: !410)
!421 = !DILocation(line: 255, column: 9, scope: !410)
!422 = !DILocation(line: 256, column: 5, scope: !410)
!423 = !DILocation(line: 258, column: 18, scope: !424)
!424 = distinct !DILexicalBlock(scope: !399, file: !2, line: 256, column: 12)
!425 = !DILocation(line: 258, column: 9, scope: !424)
!426 = !DILocation(line: 260, column: 1, scope: !392)
!427 = distinct !DISubprogram(name: "stealer", scope: !19, file: !19, line: 16, type: !428, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !95)
!428 = !DISubroutineType(types: !429)
!429 = !{!430, !430}
!430 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!431 = !DILocalVariable(name: "unused", arg: 1, scope: !427, file: !19, line: 16, type: !430)
!432 = !DILocation(line: 16, column: 21, scope: !427)
!433 = !DILocalVariable(name: "r", scope: !427, file: !19, line: 17, type: !81)
!434 = !DILocation(line: 17, column: 10, scope: !427)
!435 = !DILocalVariable(name: "i", scope: !436, file: !19, line: 18, type: !54)
!436 = distinct !DILexicalBlock(scope: !427, file: !19, line: 18, column: 5)
!437 = !DILocation(line: 18, column: 14, scope: !436)
!438 = !DILocation(line: 18, column: 10, scope: !436)
!439 = !DILocation(line: 18, column: 21, scope: !440)
!440 = distinct !DILexicalBlock(scope: !436, file: !19, line: 18, column: 5)
!441 = !DILocation(line: 18, column: 23, scope: !440)
!442 = !DILocation(line: 18, column: 5, scope: !436)
!443 = !DILocation(line: 19, column: 13, scope: !444)
!444 = distinct !DILexicalBlock(scope: !445, file: !19, line: 19, column: 13)
!445 = distinct !DILexicalBlock(scope: !440, file: !19, line: 18, column: 45)
!446 = !DILocation(line: 20, column: 23, scope: !447)
!447 = distinct !DILexicalBlock(scope: !444, file: !19, line: 19, column: 24)
!448 = !DILocation(line: 20, column: 13, scope: !447)
!449 = !DILocation(line: 21, column: 9, scope: !447)
!450 = !DILocation(line: 22, column: 5, scope: !445)
!451 = !DILocation(line: 18, column: 41, scope: !440)
!452 = !DILocation(line: 18, column: 5, scope: !440)
!453 = distinct !{!453, !442, !454, !344}
!454 = !DILocation(line: 22, column: 5, scope: !436)
!455 = !DILocation(line: 23, column: 5, scope: !427)
!456 = distinct !DISubprogram(name: "main", scope: !19, file: !19, line: 28, type: !457, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !18, retainedNodes: !95)
!457 = !DISubroutineType(types: !458)
!458 = !{!54}
!459 = !DILocalVariable(name: "stealers", scope: !456, file: !19, line: 29, type: !460)
!460 = !DICompositeType(tag: DW_TAG_array_type, baseType: !461, size: 128, elements: !482)
!461 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !462, line: 31, baseType: !463)
!462 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!463 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !64, line: 118, baseType: !464)
!464 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !465, size: 64)
!465 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !64, line: 103, size: 65536, elements: !466)
!466 = !{!467, !468, !478}
!467 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !465, file: !64, line: 104, baseType: !68, size: 64)
!468 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !465, file: !64, line: 105, baseType: !469, size: 64, offset: 64)
!469 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !470, size: 64)
!470 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !64, line: 57, size: 192, elements: !471)
!471 = !{!472, !476, !477}
!472 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !470, file: !64, line: 58, baseType: !473, size: 64)
!473 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !474, size: 64)
!474 = !DISubroutineType(types: !475)
!475 = !{null, !430}
!476 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !470, file: !64, line: 59, baseType: !430, size: 64, offset: 64)
!477 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !470, file: !64, line: 60, baseType: !469, size: 64, offset: 128)
!478 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !465, file: !64, line: 106, baseType: !479, size: 65408, offset: 128)
!479 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 65408, elements: !480)
!480 = !{!481}
!481 = !DISubrange(count: 8176)
!482 = !{!483}
!483 = !DISubrange(count: 2)
!484 = !DILocation(line: 29, column: 15, scope: !456)
!485 = !DILocation(line: 31, column: 5, scope: !456)
!486 = !DILocalVariable(name: "i", scope: !487, file: !19, line: 33, type: !54)
!487 = distinct !DILexicalBlock(scope: !456, file: !19, line: 33, column: 5)
!488 = !DILocation(line: 33, column: 14, scope: !487)
!489 = !DILocation(line: 33, column: 10, scope: !487)
!490 = !DILocation(line: 33, column: 21, scope: !491)
!491 = distinct !DILexicalBlock(scope: !487, file: !19, line: 33, column: 5)
!492 = !DILocation(line: 33, column: 23, scope: !491)
!493 = !DILocation(line: 33, column: 5, scope: !487)
!494 = !DILocation(line: 34, column: 25, scope: !495)
!495 = distinct !DILexicalBlock(scope: !491, file: !19, line: 33, column: 37)
!496 = !DILocation(line: 34, column: 19, scope: !495)
!497 = !DILocation(line: 34, column: 9, scope: !495)
!498 = !DILocation(line: 35, column: 5, scope: !495)
!499 = !DILocation(line: 33, column: 33, scope: !491)
!500 = !DILocation(line: 33, column: 5, scope: !491)
!501 = distinct !{!501, !493, !502, !344}
!502 = !DILocation(line: 35, column: 5, scope: !487)
!503 = !DILocalVariable(name: "i", scope: !504, file: !19, line: 37, type: !54)
!504 = distinct !DILexicalBlock(scope: !456, file: !19, line: 37, column: 5)
!505 = !DILocation(line: 37, column: 14, scope: !504)
!506 = !DILocation(line: 37, column: 10, scope: !504)
!507 = !DILocation(line: 37, column: 21, scope: !508)
!508 = distinct !DILexicalBlock(scope: !504, file: !19, line: 37, column: 5)
!509 = !DILocation(line: 37, column: 23, scope: !508)
!510 = !DILocation(line: 37, column: 5, scope: !504)
!511 = !DILocation(line: 38, column: 34, scope: !512)
!512 = distinct !DILexicalBlock(scope: !508, file: !19, line: 37, column: 40)
!513 = !DILocation(line: 38, column: 25, scope: !512)
!514 = !DILocation(line: 38, column: 9, scope: !512)
!515 = !DILocation(line: 39, column: 5, scope: !512)
!516 = !DILocation(line: 37, column: 36, scope: !508)
!517 = !DILocation(line: 37, column: 5, scope: !508)
!518 = distinct !{!518, !510, !519, !344}
!519 = !DILocation(line: 39, column: 5, scope: !504)
!520 = !DILocalVariable(name: "i", scope: !521, file: !19, line: 41, type: !54)
!521 = distinct !DILexicalBlock(scope: !456, file: !19, line: 41, column: 5)
!522 = !DILocation(line: 41, column: 14, scope: !521)
!523 = !DILocation(line: 41, column: 10, scope: !521)
!524 = !DILocation(line: 41, column: 21, scope: !525)
!525 = distinct !DILexicalBlock(scope: !521, file: !19, line: 41, column: 5)
!526 = !DILocation(line: 41, column: 23, scope: !525)
!527 = !DILocation(line: 41, column: 5, scope: !521)
!528 = !DILocation(line: 42, column: 25, scope: !529)
!529 = distinct !DILexicalBlock(scope: !525, file: !19, line: 41, column: 41)
!530 = !DILocation(line: 42, column: 23, scope: !529)
!531 = !DILocation(line: 42, column: 15, scope: !529)
!532 = !DILocation(line: 42, column: 9, scope: !529)
!533 = !DILocation(line: 43, column: 25, scope: !529)
!534 = !DILocation(line: 43, column: 23, scope: !529)
!535 = !DILocation(line: 43, column: 27, scope: !529)
!536 = !DILocation(line: 43, column: 15, scope: !529)
!537 = !DILocation(line: 43, column: 9, scope: !529)
!538 = !DILocalVariable(name: "r", scope: !529, file: !19, line: 44, type: !81)
!539 = !DILocation(line: 44, column: 14, scope: !529)
!540 = !DILocation(line: 45, column: 13, scope: !541)
!541 = distinct !DILexicalBlock(scope: !529, file: !19, line: 45, column: 13)
!542 = !DILocation(line: 46, column: 23, scope: !543)
!543 = distinct !DILexicalBlock(scope: !541, file: !19, line: 45, column: 22)
!544 = !DILocation(line: 46, column: 13, scope: !543)
!545 = !DILocation(line: 47, column: 9, scope: !543)
!546 = !DILocation(line: 48, column: 5, scope: !529)
!547 = !DILocation(line: 41, column: 37, scope: !525)
!548 = !DILocation(line: 41, column: 5, scope: !525)
!549 = distinct !{!549, !527, !550, !344}
!550 = !DILocation(line: 48, column: 5, scope: !521)
!551 = !DILocalVariable(name: "i", scope: !552, file: !19, line: 50, type: !54)
!552 = distinct !DILexicalBlock(scope: !456, file: !19, line: 50, column: 5)
!553 = !DILocation(line: 50, column: 14, scope: !552)
!554 = !DILocation(line: 50, column: 10, scope: !552)
!555 = !DILocation(line: 50, column: 21, scope: !556)
!556 = distinct !DILexicalBlock(scope: !552, file: !19, line: 50, column: 5)
!557 = !DILocation(line: 50, column: 23, scope: !556)
!558 = !DILocation(line: 50, column: 5, scope: !552)
!559 = !DILocalVariable(name: "r", scope: !560, file: !19, line: 51, type: !81)
!560 = distinct !DILexicalBlock(scope: !556, file: !19, line: 50, column: 41)
!561 = !DILocation(line: 51, column: 14, scope: !560)
!562 = !DILocation(line: 52, column: 13, scope: !563)
!563 = distinct !DILexicalBlock(scope: !560, file: !19, line: 52, column: 13)
!564 = !DILocation(line: 53, column: 23, scope: !565)
!565 = distinct !DILexicalBlock(scope: !563, file: !19, line: 52, column: 22)
!566 = !DILocation(line: 53, column: 13, scope: !565)
!567 = !DILocation(line: 54, column: 9, scope: !565)
!568 = !DILocation(line: 55, column: 5, scope: !560)
!569 = !DILocation(line: 50, column: 37, scope: !556)
!570 = !DILocation(line: 50, column: 5, scope: !556)
!571 = distinct !{!571, !558, !572, !344}
!572 = !DILocation(line: 55, column: 5, scope: !552)
!573 = !DILocalVariable(name: "i", scope: !574, file: !19, line: 57, type: !54)
!574 = distinct !DILexicalBlock(scope: !456, file: !19, line: 57, column: 5)
!575 = !DILocation(line: 57, column: 14, scope: !574)
!576 = !DILocation(line: 57, column: 10, scope: !574)
!577 = !DILocation(line: 57, column: 21, scope: !578)
!578 = distinct !DILexicalBlock(scope: !574, file: !19, line: 57, column: 5)
!579 = !DILocation(line: 57, column: 23, scope: !578)
!580 = !DILocation(line: 57, column: 5, scope: !574)
!581 = !DILocation(line: 58, column: 31, scope: !582)
!582 = distinct !DILexicalBlock(scope: !578, file: !19, line: 57, column: 40)
!583 = !DILocation(line: 58, column: 22, scope: !582)
!584 = !DILocation(line: 58, column: 9, scope: !582)
!585 = !DILocation(line: 59, column: 5, scope: !582)
!586 = !DILocation(line: 57, column: 36, scope: !578)
!587 = !DILocation(line: 57, column: 5, scope: !578)
!588 = distinct !{!588, !580, !589, !344}
!589 = !DILocation(line: 59, column: 5, scope: !574)
!590 = !DILocalVariable(name: "i", scope: !591, file: !19, line: 61, type: !54)
!591 = distinct !DILexicalBlock(scope: !456, file: !19, line: 61, column: 5)
!592 = !DILocation(line: 61, column: 14, scope: !591)
!593 = !DILocation(line: 61, column: 10, scope: !591)
!594 = !DILocation(line: 61, column: 21, scope: !595)
!595 = distinct !DILexicalBlock(scope: !591, file: !19, line: 61, column: 5)
!596 = !DILocation(line: 61, column: 23, scope: !595)
!597 = !DILocation(line: 61, column: 5, scope: !591)
!598 = !DILocation(line: 62, column: 22, scope: !599)
!599 = distinct !DILexicalBlock(scope: !595, file: !19, line: 61, column: 37)
!600 = !DILocation(line: 62, column: 16, scope: !599)
!601 = !DILocation(line: 62, column: 9, scope: !599)
!602 = !DILocation(line: 63, column: 5, scope: !599)
!603 = !DILocation(line: 61, column: 33, scope: !595)
!604 = !DILocation(line: 61, column: 5, scope: !595)
!605 = distinct !{!605, !597, !606, !344}
!606 = !DILocation(line: 63, column: 5, scope: !591)
!607 = !DILocation(line: 65, column: 5, scope: !456)
