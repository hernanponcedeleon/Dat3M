; ModuleID = 'brgpk.c'
source_filename = "brgpk.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

%struct.brgpk_waiter = type { ptr, i8, ptr, ptr }
%struct.brgpk_parking_lot = type { i32, ptr, ptr }

@sum = global i32 0, align 4, !dbg !0
@lock = global i64 0, align 8, !dbg !59
@waiters = global [3 x %struct.brgpk_waiter] zeroinitializer, align 8, !dbg !65
@shared = global i32 0, align 4, !dbg !56
@__func__.thread_n = private unnamed_addr constant [9 x i8] c"thread_n\00", align 1, !dbg !29
@.str = private unnamed_addr constant [8 x i8] c"brgpk.c\00", align 1, !dbg !36
@.str.1 = private unnamed_addr constant [11 x i8] c"r == index\00", align 1, !dbg !41
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !46
@.str.2 = private unnamed_addr constant [16 x i8] c"sum == NTHREADS\00", align 1, !dbg !51
@brgpk_pl = internal global %struct.brgpk_parking_lot zeroinitializer, align 8, !dbg !81

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @thread_n(ptr noundef %0) #0 !dbg !97 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !101, !DIExpression(), !102)
    #dbg_declare(ptr %3, !103, !DIExpression(), !104)
  %6 = load ptr, ptr %2, align 8, !dbg !105
  %7 = ptrtoint ptr %6 to i64, !dbg !106
  store i64 %7, ptr %3, align 8, !dbg !104
    #dbg_declare(ptr %4, !107, !DIExpression(), !108)
  %8 = load i64, ptr %3, align 8, !dbg !109
  %9 = add i64 %8, 1, !dbg !110
  %10 = shl i64 %9, 1, !dbg !111
  store i64 %10, ptr %4, align 8, !dbg !108
  %11 = load i64, ptr %3, align 8, !dbg !112
  %12 = getelementptr inbounds [3 x %struct.brgpk_waiter], ptr @waiters, i64 0, i64 %11, !dbg !113
  %13 = load i64, ptr %4, align 8, !dbg !114
  call void @brgpk_mutex_enter(ptr noundef @lock, ptr noundef %12, i64 noundef %13), !dbg !115
  %14 = load i64, ptr %3, align 8, !dbg !116
  %15 = trunc i64 %14 to i32, !dbg !116
  store i32 %15, ptr @shared, align 4, !dbg !117
    #dbg_declare(ptr %5, !118, !DIExpression(), !119)
  %16 = load i32, ptr @shared, align 4, !dbg !120
  store i32 %16, ptr %5, align 4, !dbg !119
  %17 = load i32, ptr %5, align 4, !dbg !121
  %18 = sext i32 %17 to i64, !dbg !121
  %19 = load i64, ptr %3, align 8, !dbg !122
  %20 = icmp eq i64 %18, %19, !dbg !123
  %21 = xor i1 %20, true, !dbg !124
  %22 = zext i1 %21 to i32, !dbg !124
  %23 = sext i32 %22 to i64, !dbg !124
  %24 = icmp ne i64 %23, 0, !dbg !124
  br i1 %24, label %25, label %27, !dbg !124

25:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.thread_n, ptr noundef @.str, i32 noundef 28, ptr noundef @.str.1) #3, !dbg !124
  unreachable, !dbg !124

26:                                               ; No predecessors!
  br label %28, !dbg !124

27:                                               ; preds = %1
  br label %28, !dbg !124

28:                                               ; preds = %27, %26
  %29 = load i32, ptr @sum, align 4, !dbg !125
  %30 = add nsw i32 %29, 1, !dbg !125
  store i32 %30, ptr @sum, align 4, !dbg !125
  %31 = load i64, ptr %4, align 8, !dbg !126
  call void @brgpk_mutex_leave(ptr noundef @lock, i64 noundef %31), !dbg !127
  ret ptr null, !dbg !128
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @brgpk_mutex_enter(ptr noundef %0, ptr noundef %1, i64 noundef %2) #0 !dbg !129 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  %9 = alloca i32, align 4
  %10 = alloca i64, align 8
  %11 = alloca i8, align 1
  %12 = alloca i8, align 1
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !132, !DIExpression(), !133)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !134, !DIExpression(), !135)
  store i64 %2, ptr %6, align 8
    #dbg_declare(ptr %6, !136, !DIExpression(), !137)
    #dbg_declare(ptr %7, !138, !DIExpression(), !139)
    #dbg_declare(ptr %8, !140, !DIExpression(), !141)
  %13 = load ptr, ptr %4, align 8, !dbg !142
  %14 = load i64, ptr %6, align 8, !dbg !143
  %15 = call i64 @brgpk_cas(ptr noundef %13, i64 noundef 0, i64 noundef %14), !dbg !144
  store i64 %15, ptr %7, align 8, !dbg !145
  %16 = load i64, ptr %7, align 8, !dbg !146
  %17 = icmp eq i64 %16, 0, !dbg !148
  br i1 %17, label %18, label %19, !dbg !148

18:                                               ; preds = %3
  br label %80, !dbg !149

19:                                               ; preds = %3
    #dbg_declare(ptr %9, !150, !DIExpression(), !152)
  store i32 0, ptr %9, align 4, !dbg !152
  br label %20, !dbg !153

20:                                               ; preds = %42, %19
  %21 = load i32, ptr %9, align 4, !dbg !154
  %22 = icmp slt i32 %21, 1, !dbg !156
  br i1 %22, label %23, label %45, !dbg !157

23:                                               ; preds = %20
  %24 = load i64, ptr %7, align 8, !dbg !158
  %25 = and i64 %24, 1, !dbg !161
  %26 = icmp ne i64 %25, 0, !dbg !161
  br i1 %26, label %27, label %28, !dbg !161

27:                                               ; preds = %23
  br label %45, !dbg !162

28:                                               ; preds = %23
  %29 = load ptr, ptr %4, align 8, !dbg !163
  %30 = load atomic i64, ptr %29 monotonic, align 8, !dbg !165
  store i64 %30, ptr %10, align 8, !dbg !165
  %31 = load i64, ptr %10, align 8, !dbg !165
  %32 = icmp eq i64 %31, 0, !dbg !166
  br i1 %32, label %33, label %41, !dbg !166

33:                                               ; preds = %28
  %34 = load ptr, ptr %4, align 8, !dbg !167
  %35 = load i64, ptr %6, align 8, !dbg !169
  %36 = call i64 @brgpk_cas(ptr noundef %34, i64 noundef 0, i64 noundef %35), !dbg !170
  store i64 %36, ptr %7, align 8, !dbg !171
  %37 = load i64, ptr %7, align 8, !dbg !172
  %38 = icmp eq i64 %37, 0, !dbg !174
  br i1 %38, label %39, label %40, !dbg !174

39:                                               ; preds = %33
  br label %80, !dbg !175

40:                                               ; preds = %33
  br label %41, !dbg !176

41:                                               ; preds = %40, %28
  br label %42, !dbg !177

42:                                               ; preds = %41
  %43 = load i32, ptr %9, align 4, !dbg !178
  %44 = add nsw i32 %43, 1, !dbg !178
  store i32 %44, ptr %9, align 4, !dbg !178
  br label %20, !dbg !179, !llvm.loop !180

45:                                               ; preds = %27, %20
  %46 = load ptr, ptr %4, align 8, !dbg !183
  %47 = load ptr, ptr %5, align 8, !dbg !184
  %48 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %47, i32 0, i32 0, !dbg !185
  store ptr %46, ptr %48, align 8, !dbg !186
  %49 = load ptr, ptr %5, align 8, !dbg !187
  call void @brgpk_append(ptr noundef @brgpk_pl, ptr noundef %49), !dbg !188
  br label %50, !dbg !189

50:                                               ; preds = %75, %45
  %51 = load ptr, ptr %5, align 8, !dbg !190
  %52 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %51, i32 0, i32 1, !dbg !192
  store i8 1, ptr %11, align 1, !dbg !193
  %53 = load i8, ptr %11, align 1, !dbg !193
  store atomic i8 %53, ptr %52 monotonic, align 8, !dbg !193
  fence seq_cst, !dbg !194
  %54 = load ptr, ptr %4, align 8, !dbg !195
  %55 = load i64, ptr %7, align 8, !dbg !196
  %56 = load i64, ptr %7, align 8, !dbg !197
  %57 = or i64 %56, 1, !dbg !198
  %58 = call i64 @brgpk_cas(ptr noundef %54, i64 noundef %55, i64 noundef %57), !dbg !199
  store i64 %58, ptr %8, align 8, !dbg !200
  %59 = load i64, ptr %8, align 8, !dbg !201
  %60 = load i64, ptr %7, align 8, !dbg !203
  %61 = icmp eq i64 %59, %60, !dbg !204
  br i1 %61, label %62, label %71, !dbg !204

62:                                               ; preds = %50
  br label %63, !dbg !205

63:                                               ; preds = %69, %62
  %64 = load ptr, ptr %5, align 8, !dbg !207
  %65 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %64, i32 0, i32 1, !dbg !208
  %66 = load atomic i8, ptr %65 monotonic, align 8, !dbg !209
  store i8 %66, ptr %12, align 1, !dbg !209
  %67 = load i8, ptr %12, align 1, !dbg !209
  %68 = icmp ne i8 %67, 0, !dbg !209
  br i1 %68, label %69, label %70, !dbg !205

69:                                               ; preds = %63
  br label %63, !dbg !205, !llvm.loop !210

70:                                               ; preds = %63
  br label %71, !dbg !212

71:                                               ; preds = %70, %50
  %72 = load ptr, ptr %4, align 8, !dbg !213
  %73 = load i64, ptr %6, align 8, !dbg !214
  %74 = call i64 @brgpk_cas(ptr noundef %72, i64 noundef 0, i64 noundef %73), !dbg !215
  store i64 %74, ptr %7, align 8, !dbg !216
  br label %75, !dbg !217

75:                                               ; preds = %71
  %76 = load i64, ptr %7, align 8, !dbg !218
  %77 = icmp ne i64 %76, 0, !dbg !219
  br i1 %77, label %50, label %78, !dbg !217, !llvm.loop !220

78:                                               ; preds = %75
  %79 = load ptr, ptr %5, align 8, !dbg !222
  call void @brgpk_remove(ptr noundef @brgpk_pl, ptr noundef %79), !dbg !223
  br label %80, !dbg !223

80:                                               ; preds = %78, %39, %18
    #dbg_label(!224, !225)
  fence acquire, !dbg !226
  ret void, !dbg !227
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @brgpk_mutex_leave(ptr noundef %0, i64 noundef %1) #0 !dbg !228 {
  %3 = alloca ptr, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !231, !DIExpression(), !232)
  store i64 %1, ptr %4, align 8
    #dbg_declare(ptr %4, !233, !DIExpression(), !234)
    #dbg_declare(ptr %5, !235, !DIExpression(), !236)
  fence release, !dbg !237
  %7 = load ptr, ptr %3, align 8, !dbg !238
  %8 = load i64, ptr %4, align 8, !dbg !239
  %9 = call i64 @brgpk_cas(ptr noundef %7, i64 noundef %8, i64 noundef 0), !dbg !240
  store i64 %9, ptr %5, align 8, !dbg !241
  %10 = load i64, ptr %5, align 8, !dbg !242
  %11 = load i64, ptr %4, align 8, !dbg !244
  %12 = icmp ne i64 %10, %11, !dbg !245
  br i1 %12, label %13, label %17, !dbg !245

13:                                               ; preds = %2
  %14 = load ptr, ptr %3, align 8, !dbg !246
  store i64 0, ptr %6, align 8, !dbg !248
  %15 = load i64, ptr %6, align 8, !dbg !248
  store atomic i64 %15, ptr %14 monotonic, align 8, !dbg !248
  fence seq_cst, !dbg !249
  %16 = load ptr, ptr %3, align 8, !dbg !250
  call void @brgpk_wake_first(ptr noundef @brgpk_pl, ptr noundef %16), !dbg !251
  br label %17, !dbg !252

17:                                               ; preds = %13, %2
  ret void, !dbg !253
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 !dbg !254 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !257, !DIExpression(), !281)
  call void @brgpk_mutex_init(ptr noundef @lock), !dbg !282
    #dbg_declare(ptr %3, !283, !DIExpression(), !285)
  store i32 0, ptr %3, align 4, !dbg !285
  br label %5, !dbg !286

5:                                                ; preds = %16, %0
  %6 = load i32, ptr %3, align 4, !dbg !287
  %7 = icmp slt i32 %6, 3, !dbg !289
  br i1 %7, label %8, label %19, !dbg !290

8:                                                ; preds = %5
  %9 = load i32, ptr %3, align 4, !dbg !291
  %10 = sext i32 %9 to i64, !dbg !292
  %11 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %10, !dbg !292
  %12 = load i32, ptr %3, align 4, !dbg !293
  %13 = sext i32 %12 to i64, !dbg !294
  %14 = inttoptr i64 %13 to ptr, !dbg !295
  %15 = call i32 @pthread_create(ptr noundef %11, ptr noundef null, ptr noundef @thread_n, ptr noundef %14), !dbg !296
  br label %16, !dbg !296

16:                                               ; preds = %8
  %17 = load i32, ptr %3, align 4, !dbg !297
  %18 = add nsw i32 %17, 1, !dbg !297
  store i32 %18, ptr %3, align 4, !dbg !297
  br label %5, !dbg !298, !llvm.loop !299

19:                                               ; preds = %5
    #dbg_declare(ptr %4, !301, !DIExpression(), !303)
  store i32 0, ptr %4, align 4, !dbg !303
  br label %20, !dbg !304

20:                                               ; preds = %29, %19
  %21 = load i32, ptr %4, align 4, !dbg !305
  %22 = icmp slt i32 %21, 3, !dbg !307
  br i1 %22, label %23, label %32, !dbg !308

23:                                               ; preds = %20
  %24 = load i32, ptr %4, align 4, !dbg !309
  %25 = sext i32 %24 to i64, !dbg !310
  %26 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %25, !dbg !310
  %27 = load ptr, ptr %26, align 8, !dbg !310
  %28 = call i32 @"\01_pthread_join"(ptr noundef %27, ptr noundef null), !dbg !311
  br label %29, !dbg !311

29:                                               ; preds = %23
  %30 = load i32, ptr %4, align 4, !dbg !312
  %31 = add nsw i32 %30, 1, !dbg !312
  store i32 %31, ptr %4, align 4, !dbg !312
  br label %20, !dbg !313, !llvm.loop !314

32:                                               ; preds = %20
  %33 = load i32, ptr @sum, align 4, !dbg !316
  %34 = icmp eq i32 %33, 3, !dbg !317
  %35 = xor i1 %34, true, !dbg !318
  %36 = zext i1 %35 to i32, !dbg !318
  %37 = sext i32 %36 to i64, !dbg !318
  %38 = icmp ne i64 %37, 0, !dbg !318
  br i1 %38, label %39, label %41, !dbg !318

39:                                               ; preds = %32
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 46, ptr noundef @.str.2) #3, !dbg !318
  unreachable, !dbg !318

40:                                               ; No predecessors!
  br label %42, !dbg !318

41:                                               ; preds = %32
  br label %42, !dbg !318

42:                                               ; preds = %41, %40
  ret i32 0, !dbg !319
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @brgpk_mutex_init(ptr noundef %0) #0 !dbg !320 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !323, !DIExpression(), !324)
  %3 = load ptr, ptr %2, align 8, !dbg !325
  store i64 0, ptr %3, align 8, !dbg !326
  ret void, !dbg !327
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal i64 @brgpk_cas(ptr noundef %0, i64 noundef %1, i64 noundef %2) #0 !dbg !328 {
  %4 = alloca ptr, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i8, align 1
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !331, !DIExpression(), !332)
  store i64 %1, ptr %5, align 8
    #dbg_declare(ptr %5, !333, !DIExpression(), !334)
  store i64 %2, ptr %6, align 8
    #dbg_declare(ptr %6, !335, !DIExpression(), !336)
  %9 = load ptr, ptr %4, align 8, !dbg !337
  %10 = load i64, ptr %6, align 8, !dbg !338
  store i64 %10, ptr %7, align 8, !dbg !339
  %11 = load i64, ptr %5, align 8, !dbg !339
  %12 = load i64, ptr %7, align 8, !dbg !339
  %13 = cmpxchg ptr %9, i64 %11, i64 %12 monotonic monotonic, align 8, !dbg !339
  %14 = extractvalue { i64, i1 } %13, 0, !dbg !339
  %15 = extractvalue { i64, i1 } %13, 1, !dbg !339
  br i1 %15, label %17, label %16, !dbg !339

16:                                               ; preds = %3
  store i64 %14, ptr %5, align 8, !dbg !339
  br label %17, !dbg !339

17:                                               ; preds = %16, %3
  %18 = zext i1 %15 to i8, !dbg !339
  store i8 %18, ptr %8, align 1, !dbg !339
  %19 = load i8, ptr %8, align 1, !dbg !339
  %20 = icmp ne i8 %19, 0, !dbg !339
  %21 = load i64, ptr %5, align 8, !dbg !340
  ret i64 %21, !dbg !341
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @brgpk_append(ptr noundef %0, ptr noundef %1) #0 !dbg !342 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !346, !DIExpression(), !347)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !348, !DIExpression(), !349)
  %5 = load ptr, ptr %3, align 8, !dbg !350
  call void @brgpk_pl_enter(ptr noundef %5), !dbg !351
  %6 = load ptr, ptr %4, align 8, !dbg !352
  %7 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %6, i32 0, i32 2, !dbg !353
  store ptr null, ptr %7, align 8, !dbg !354
  %8 = load ptr, ptr %3, align 8, !dbg !355
  %9 = getelementptr inbounds nuw %struct.brgpk_parking_lot, ptr %8, i32 0, i32 2, !dbg !356
  %10 = load ptr, ptr %9, align 8, !dbg !356
  %11 = load ptr, ptr %4, align 8, !dbg !357
  %12 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %11, i32 0, i32 3, !dbg !358
  store ptr %10, ptr %12, align 8, !dbg !359
  %13 = load ptr, ptr %3, align 8, !dbg !360
  %14 = getelementptr inbounds nuw %struct.brgpk_parking_lot, ptr %13, i32 0, i32 2, !dbg !362
  %15 = load ptr, ptr %14, align 8, !dbg !362
  %16 = icmp ne ptr %15, null, !dbg !363
  br i1 %16, label %17, label %23, !dbg !363

17:                                               ; preds = %2
  %18 = load ptr, ptr %4, align 8, !dbg !364
  %19 = load ptr, ptr %3, align 8, !dbg !365
  %20 = getelementptr inbounds nuw %struct.brgpk_parking_lot, ptr %19, i32 0, i32 2, !dbg !366
  %21 = load ptr, ptr %20, align 8, !dbg !366
  %22 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %21, i32 0, i32 2, !dbg !367
  store ptr %18, ptr %22, align 8, !dbg !368
  br label %27, !dbg !365

23:                                               ; preds = %2
  %24 = load ptr, ptr %4, align 8, !dbg !369
  %25 = load ptr, ptr %3, align 8, !dbg !370
  %26 = getelementptr inbounds nuw %struct.brgpk_parking_lot, ptr %25, i32 0, i32 1, !dbg !371
  store ptr %24, ptr %26, align 8, !dbg !372
  br label %27

27:                                               ; preds = %23, %17
  %28 = load ptr, ptr %4, align 8, !dbg !373
  %29 = load ptr, ptr %3, align 8, !dbg !374
  %30 = getelementptr inbounds nuw %struct.brgpk_parking_lot, ptr %29, i32 0, i32 2, !dbg !375
  store ptr %28, ptr %30, align 8, !dbg !376
  %31 = load ptr, ptr %3, align 8, !dbg !377
  call void @brgpk_pl_leave(ptr noundef %31), !dbg !378
  ret void, !dbg !379
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @brgpk_remove(ptr noundef %0, ptr noundef %1) #0 !dbg !380 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !381, !DIExpression(), !382)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !383, !DIExpression(), !384)
  %5 = load ptr, ptr %3, align 8, !dbg !385
  call void @brgpk_pl_enter(ptr noundef %5), !dbg !386
  %6 = load ptr, ptr %4, align 8, !dbg !387
  %7 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %6, i32 0, i32 3, !dbg !389
  %8 = load ptr, ptr %7, align 8, !dbg !389
  %9 = icmp ne ptr %8, null, !dbg !390
  br i1 %9, label %10, label %18, !dbg !390

10:                                               ; preds = %2
  %11 = load ptr, ptr %4, align 8, !dbg !391
  %12 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %11, i32 0, i32 2, !dbg !392
  %13 = load ptr, ptr %12, align 8, !dbg !392
  %14 = load ptr, ptr %4, align 8, !dbg !393
  %15 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %14, i32 0, i32 3, !dbg !394
  %16 = load ptr, ptr %15, align 8, !dbg !394
  %17 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %16, i32 0, i32 2, !dbg !395
  store ptr %13, ptr %17, align 8, !dbg !396
  br label %24, !dbg !393

18:                                               ; preds = %2
  %19 = load ptr, ptr %4, align 8, !dbg !397
  %20 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %19, i32 0, i32 2, !dbg !398
  %21 = load ptr, ptr %20, align 8, !dbg !398
  %22 = load ptr, ptr %3, align 8, !dbg !399
  %23 = getelementptr inbounds nuw %struct.brgpk_parking_lot, ptr %22, i32 0, i32 1, !dbg !400
  store ptr %21, ptr %23, align 8, !dbg !401
  br label %24

24:                                               ; preds = %18, %10
  %25 = load ptr, ptr %4, align 8, !dbg !402
  %26 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %25, i32 0, i32 2, !dbg !404
  %27 = load ptr, ptr %26, align 8, !dbg !404
  %28 = icmp ne ptr %27, null, !dbg !405
  br i1 %28, label %29, label %37, !dbg !405

29:                                               ; preds = %24
  %30 = load ptr, ptr %4, align 8, !dbg !406
  %31 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %30, i32 0, i32 3, !dbg !407
  %32 = load ptr, ptr %31, align 8, !dbg !407
  %33 = load ptr, ptr %4, align 8, !dbg !408
  %34 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %33, i32 0, i32 2, !dbg !409
  %35 = load ptr, ptr %34, align 8, !dbg !409
  %36 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %35, i32 0, i32 3, !dbg !410
  store ptr %32, ptr %36, align 8, !dbg !411
  br label %43, !dbg !408

37:                                               ; preds = %24
  %38 = load ptr, ptr %4, align 8, !dbg !412
  %39 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %38, i32 0, i32 3, !dbg !413
  %40 = load ptr, ptr %39, align 8, !dbg !413
  %41 = load ptr, ptr %3, align 8, !dbg !414
  %42 = getelementptr inbounds nuw %struct.brgpk_parking_lot, ptr %41, i32 0, i32 2, !dbg !415
  store ptr %40, ptr %42, align 8, !dbg !416
  br label %43

43:                                               ; preds = %37, %29
  %44 = load ptr, ptr %3, align 8, !dbg !417
  call void @brgpk_pl_leave(ptr noundef %44), !dbg !418
  ret void, !dbg !419
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @brgpk_pl_enter(ptr noundef %0) #0 !dbg !420 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !423, !DIExpression(), !424)
    #dbg_declare(ptr %3, !425, !DIExpression(), !426)
  br label %7, !dbg !427

7:                                                ; preds = %25, %1
  br label %8, !dbg !428

8:                                                ; preds = %14, %7
  %9 = load ptr, ptr %2, align 8, !dbg !430
  %10 = getelementptr inbounds nuw %struct.brgpk_parking_lot, ptr %9, i32 0, i32 0, !dbg !431
  %11 = load atomic i32, ptr %10 monotonic, align 8, !dbg !432
  store i32 %11, ptr %4, align 4, !dbg !432
  %12 = load i32, ptr %4, align 4, !dbg !432
  %13 = icmp ne i32 %12, 0, !dbg !433
  br i1 %13, label %14, label %15, !dbg !428

14:                                               ; preds = %8
  br label %8, !dbg !428, !llvm.loop !434

15:                                               ; preds = %8
  store i32 0, ptr %3, align 4, !dbg !436
  br label %16, !dbg !437

16:                                               ; preds = %15
  %17 = load ptr, ptr %2, align 8, !dbg !438
  %18 = getelementptr inbounds nuw %struct.brgpk_parking_lot, ptr %17, i32 0, i32 0, !dbg !439
  store i32 1, ptr %5, align 4, !dbg !440
  %19 = load i32, ptr %3, align 4, !dbg !440
  %20 = load i32, ptr %5, align 4, !dbg !440
  %21 = cmpxchg ptr %18, i32 %19, i32 %20 acquire monotonic, align 8, !dbg !440
  %22 = extractvalue { i32, i1 } %21, 0, !dbg !440
  %23 = extractvalue { i32, i1 } %21, 1, !dbg !440
  br i1 %23, label %25, label %24, !dbg !440

24:                                               ; preds = %16
  store i32 %22, ptr %3, align 4, !dbg !440
  br label %25, !dbg !440

25:                                               ; preds = %24, %16
  %26 = zext i1 %23 to i8, !dbg !440
  store i8 %26, ptr %6, align 1, !dbg !440
  %27 = load i8, ptr %6, align 1, !dbg !440
  %28 = icmp ne i8 %27, 0, !dbg !440
  %29 = xor i1 %28, true, !dbg !441
  br i1 %29, label %7, label %30, !dbg !437, !llvm.loop !442

30:                                               ; preds = %25
  ret void, !dbg !444
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @brgpk_pl_leave(ptr noundef %0) #0 !dbg !445 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !446, !DIExpression(), !447)
  %4 = load ptr, ptr %2, align 8, !dbg !448
  %5 = getelementptr inbounds nuw %struct.brgpk_parking_lot, ptr %4, i32 0, i32 0, !dbg !449
  store i32 0, ptr %3, align 4, !dbg !450
  %6 = load i32, ptr %3, align 4, !dbg !450
  store atomic i32 %6, ptr %5 release, align 8, !dbg !450
  ret void, !dbg !451
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @brgpk_wake_first(ptr noundef %0, ptr noundef %1) #0 !dbg !452 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i8, align 1
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !455, !DIExpression(), !456)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !457, !DIExpression(), !458)
  %7 = load ptr, ptr %3, align 8, !dbg !459
  call void @brgpk_pl_enter(ptr noundef %7), !dbg !460
    #dbg_declare(ptr %5, !461, !DIExpression(), !463)
  %8 = load ptr, ptr %3, align 8, !dbg !464
  %9 = getelementptr inbounds nuw %struct.brgpk_parking_lot, ptr %8, i32 0, i32 1, !dbg !465
  %10 = load ptr, ptr %9, align 8, !dbg !465
  store ptr %10, ptr %5, align 8, !dbg !463
  br label %11, !dbg !466

11:                                               ; preds = %25, %2
  %12 = load ptr, ptr %5, align 8, !dbg !467
  %13 = icmp ne ptr %12, null, !dbg !469
  br i1 %13, label %14, label %29, !dbg !470

14:                                               ; preds = %11
  %15 = load ptr, ptr %5, align 8, !dbg !471
  %16 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %15, i32 0, i32 0, !dbg !474
  %17 = load ptr, ptr %16, align 8, !dbg !474
  %18 = load ptr, ptr %4, align 8, !dbg !475
  %19 = icmp eq ptr %17, %18, !dbg !476
  br i1 %19, label %20, label %24, !dbg !476

20:                                               ; preds = %14
  %21 = load ptr, ptr %5, align 8, !dbg !477
  %22 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %21, i32 0, i32 1, !dbg !479
  store i8 0, ptr %6, align 1, !dbg !480
  %23 = load i8, ptr %6, align 1, !dbg !480
  store atomic i8 %23, ptr %22 monotonic, align 8, !dbg !480
  br label %29, !dbg !481

24:                                               ; preds = %14
  br label %25, !dbg !482

25:                                               ; preds = %24
  %26 = load ptr, ptr %5, align 8, !dbg !483
  %27 = getelementptr inbounds nuw %struct.brgpk_waiter, ptr %26, i32 0, i32 2, !dbg !484
  %28 = load ptr, ptr %27, align 8, !dbg !484
  store ptr %28, ptr %5, align 8, !dbg !485
  br label %11, !dbg !486, !llvm.loop !487

29:                                               ; preds = %20, %11
  %30 = load ptr, ptr %3, align 8, !dbg !489
  call void @brgpk_pl_leave(ptr noundef %30), !dbg !490
  ret void, !dbg !491
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { cold noreturn }

!llvm.module.flags = !{!90, !91, !92, !93, !94, !95}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!96}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sum", scope: !2, file: !3, line: 17, type: !58, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 23.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !15, globals: !28, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk", sdk: "MacOSX26.sdk")
!3 = !DIFile(filename: "brgpk.c", directory: "Dat3M/benchmarks/locks", checksumkind: CSK_MD5, checksum: "0818d6f568b287dd169e6adf6bcf21ad")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "memory_order", file: !6, line: 68, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/opt/homebrew/Cellar/llvm/23.1.0/lib/clang/23/include/stdatomic.h", directory: "", checksumkind: CSK_MD5, checksum: "f17199a988fe91afffaf0f943ef87096")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14}
!9 = !DIEnumerator(name: "memory_order_relaxed", value: 0)
!10 = !DIEnumerator(name: "memory_order_consume", value: 1)
!11 = !DIEnumerator(name: "memory_order_acquire", value: 2)
!12 = !DIEnumerator(name: "memory_order_release", value: 3)
!13 = !DIEnumerator(name: "memory_order_acq_rel", value: 4)
!14 = !DIEnumerator(name: "memory_order_seq_cst", value: 5)
!15 = !{!16, !21, !24, !25}
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !17, line: 32, baseType: !18)
!17 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_types/_intptr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e478ba47270923b1cca6659f19f02db1")
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_intptr_t", file: !19, line: 40, baseType: !20)
!19 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/arm/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "b270144f57ae258d0ce80b8f87be068c")
!20 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !22, line: 34, baseType: !23)
!22 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_types/_uintptr_t.h", directory: "", checksumkind: CSK_MD5, checksum: "e70ae655dd1b9d4ae0b1dcc073f5b7e4")
!23 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !26, line: 50, baseType: !27)
!26 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_types/_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "f7981334d28e0c246f35cd24042aa2a4")
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_size_t", file: !19, line: 87, baseType: !23)
!28 = !{!0, !29, !36, !41, !46, !51, !56, !59, !65, !81}
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 28, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 72, elements: !34)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{!35}
!35 = !DISubrange(count: 9)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !3, line: 28, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 64, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 8)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !3, line: 28, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 88, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 11)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(scope: null, file: !3, line: 46, type: !48, isLocal: true, isDefinition: true)
!48 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !49)
!49 = !{!50}
!50 = !DISubrange(count: 5)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(scope: null, file: !3, line: 46, type: !53, isLocal: true, isDefinition: true)
!53 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 128, elements: !54)
!54 = !{!55}
!55 = !DISubrange(count: 16)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "shared", scope: !2, file: !3, line: 14, type: !58, isLocal: false, isDefinition: true)
!58 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 15, type: !61, isLocal: false, isDefinition: true)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "brgpk_mutex_t", file: !62, line: 33, baseType: !63)
!62 = !DIFile(filename: "./brgpk.h", directory: "Dat3M/benchmarks/locks", checksumkind: CSK_MD5, checksum: "c6a5ed43c668c3ed596e8e41402d5f0e")
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_uintptr_t", file: !6, line: 133, baseType: !64)
!64 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !21)
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(name: "waiters", scope: !2, file: !3, line: 16, type: !67, isLocal: false, isDefinition: true)
!67 = !DICompositeType(tag: DW_TAG_array_type, baseType: !68, size: 768, elements: !79)
!68 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "brgpk_waiter", file: !62, line: 36, size: 256, elements: !69)
!69 = !{!70, !72, !76, !78}
!70 = !DIDerivedType(tag: DW_TAG_member, name: "mtx", scope: !68, file: !62, line: 37, baseType: !71, size: 64)
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "wait", scope: !68, file: !62, line: 38, baseType: !73, size: 8, offset: 64)
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_bool", file: !6, line: 97, baseType: !74)
!74 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !75)
!75 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !68, file: !62, line: 39, baseType: !77, size: 64, offset: 128)
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !68, size: 64)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "prev", scope: !68, file: !62, line: 40, baseType: !77, size: 64, offset: 192)
!79 = !{!80}
!80 = !DISubrange(count: 3)
!81 = !DIGlobalVariableExpression(var: !82, expr: !DIExpression())
!82 = distinct !DIGlobalVariable(name: "brgpk_pl", scope: !2, file: !62, line: 51, type: !83, isLocal: true, isDefinition: true)
!83 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "brgpk_parking_lot", file: !62, line: 45, size: 192, elements: !84)
!84 = !{!85, !88, !89}
!85 = !DIDerivedType(tag: DW_TAG_member, name: "lock", scope: !83, file: !62, line: 46, baseType: !86, size: 32)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_int", file: !6, line: 104, baseType: !87)
!87 = !DIDerivedType(tag: DW_TAG_atomic_type, baseType: !58)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !83, file: !62, line: 47, baseType: !77, size: 64, offset: 64)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !83, file: !62, line: 48, baseType: !77, size: 64, offset: 128)
!90 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!91 = !{i32 7, !"Dwarf Version", i32 5}
!92 = !{i32 2, !"Debug Info Version", i32 3}
!93 = !{i32 8, !"PIC Level", i32 2}
!94 = !{i32 7, !"uwtable", i32 1}
!95 = !{i32 7, !"frame-pointer", i32 4}
!96 = !{!"Homebrew clang version 23.1.0"}
!97 = distinct !DISubprogram(name: "thread_n", scope: !3, file: !3, line: 19, type: !98, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !100)
!98 = !DISubroutineType(types: !99)
!99 = !{!24, !24}
!100 = !{}
!101 = !DILocalVariable(name: "arg", arg: 1, scope: !97, file: !3, line: 19, type: !24)
!102 = !DILocation(line: 19, column: 22, scope: !97)
!103 = !DILocalVariable(name: "index", scope: !97, file: !3, line: 21, type: !16)
!104 = !DILocation(line: 21, column: 14, scope: !97)
!105 = !DILocation(line: 21, column: 34, scope: !97)
!106 = !DILocation(line: 21, column: 23, scope: !97)
!107 = !DILocalVariable(name: "self", scope: !97, file: !3, line: 23, type: !21)
!108 = !DILocation(line: 23, column: 15, scope: !97)
!109 = !DILocation(line: 23, column: 34, scope: !97)
!110 = !DILocation(line: 23, column: 40, scope: !97)
!111 = !DILocation(line: 23, column: 45, scope: !97)
!112 = !DILocation(line: 25, column: 39, scope: !97)
!113 = !DILocation(line: 25, column: 31, scope: !97)
!114 = !DILocation(line: 25, column: 47, scope: !97)
!115 = !DILocation(line: 25, column: 5, scope: !97)
!116 = !DILocation(line: 26, column: 14, scope: !97)
!117 = !DILocation(line: 26, column: 12, scope: !97)
!118 = !DILocalVariable(name: "r", scope: !97, file: !3, line: 27, type: !58)
!119 = !DILocation(line: 27, column: 9, scope: !97)
!120 = !DILocation(line: 27, column: 13, scope: !97)
!121 = !DILocation(line: 28, column: 12, scope: !97)
!122 = !DILocation(line: 28, column: 17, scope: !97)
!123 = !DILocation(line: 28, column: 14, scope: !97)
!124 = !DILocation(line: 28, column: 5, scope: !97)
!125 = !DILocation(line: 29, column: 8, scope: !97)
!126 = !DILocation(line: 30, column: 30, scope: !97)
!127 = !DILocation(line: 30, column: 5, scope: !97)
!128 = !DILocation(line: 31, column: 5, scope: !97)
!129 = distinct !DISubprogram(name: "brgpk_mutex_enter", scope: !62, file: !62, line: 124, type: !130, scopeLine: 125, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !100)
!130 = !DISubroutineType(types: !131)
!131 = !{null, !71, !77, !21}
!132 = !DILocalVariable(name: "mtx", arg: 1, scope: !129, file: !62, line: 124, type: !71)
!133 = !DILocation(line: 124, column: 53, scope: !129)
!134 = !DILocalVariable(name: "wtr", arg: 2, scope: !129, file: !62, line: 124, type: !77)
!135 = !DILocation(line: 124, column: 79, scope: !129)
!136 = !DILocalVariable(name: "self", arg: 3, scope: !129, file: !62, line: 124, type: !21)
!137 = !DILocation(line: 124, column: 94, scope: !129)
!138 = !DILocalVariable(name: "owner", scope: !129, file: !62, line: 126, type: !21)
!139 = !DILocation(line: 126, column: 15, scope: !129)
!140 = !DILocalVariable(name: "o", scope: !129, file: !62, line: 126, type: !21)
!141 = !DILocation(line: 126, column: 22, scope: !129)
!142 = !DILocation(line: 128, column: 23, scope: !129)
!143 = !DILocation(line: 128, column: 31, scope: !129)
!144 = !DILocation(line: 128, column: 13, scope: !129)
!145 = !DILocation(line: 128, column: 11, scope: !129)
!146 = !DILocation(line: 129, column: 9, scope: !147)
!147 = distinct !DILexicalBlock(scope: !129, file: !62, line: 129, column: 9)
!148 = !DILocation(line: 129, column: 15, scope: !147)
!149 = !DILocation(line: 130, column: 9, scope: !147)
!150 = !DILocalVariable(name: "i", scope: !151, file: !62, line: 132, type: !58)
!151 = distinct !DILexicalBlock(scope: !129, file: !62, line: 132, column: 5)
!152 = !DILocation(line: 132, column: 14, scope: !151)
!153 = !DILocation(line: 132, column: 10, scope: !151)
!154 = !DILocation(line: 132, column: 21, scope: !155)
!155 = distinct !DILexicalBlock(scope: !151, file: !62, line: 132, column: 5)
!156 = !DILocation(line: 132, column: 23, scope: !155)
!157 = !DILocation(line: 132, column: 5, scope: !151)
!158 = !DILocation(line: 133, column: 13, scope: !159)
!159 = distinct !DILexicalBlock(scope: !160, file: !62, line: 133, column: 13)
!160 = distinct !DILexicalBlock(scope: !155, file: !62, line: 132, column: 47)
!161 = !DILocation(line: 133, column: 19, scope: !159)
!162 = !DILocation(line: 134, column: 13, scope: !159)
!163 = !DILocation(line: 135, column: 34, scope: !164)
!164 = distinct !DILexicalBlock(scope: !160, file: !62, line: 135, column: 13)
!165 = !DILocation(line: 135, column: 13, scope: !164)
!166 = !DILocation(line: 135, column: 61, scope: !164)
!167 = !DILocation(line: 136, column: 31, scope: !168)
!168 = distinct !DILexicalBlock(scope: !164, file: !62, line: 135, column: 67)
!169 = !DILocation(line: 136, column: 39, scope: !168)
!170 = !DILocation(line: 136, column: 21, scope: !168)
!171 = !DILocation(line: 136, column: 19, scope: !168)
!172 = !DILocation(line: 137, column: 17, scope: !173)
!173 = distinct !DILexicalBlock(scope: !168, file: !62, line: 137, column: 17)
!174 = !DILocation(line: 137, column: 23, scope: !173)
!175 = !DILocation(line: 138, column: 17, scope: !173)
!176 = !DILocation(line: 139, column: 9, scope: !168)
!177 = !DILocation(line: 140, column: 5, scope: !160)
!178 = !DILocation(line: 132, column: 43, scope: !155)
!179 = !DILocation(line: 132, column: 5, scope: !155)
!180 = distinct !{!180, !157, !181, !182}
!181 = !DILocation(line: 140, column: 5, scope: !151)
!182 = !{!"llvm.loop.mustprogress"}
!183 = !DILocation(line: 142, column: 16, scope: !129)
!184 = !DILocation(line: 142, column: 5, scope: !129)
!185 = !DILocation(line: 142, column: 10, scope: !129)
!186 = !DILocation(line: 142, column: 14, scope: !129)
!187 = !DILocation(line: 143, column: 29, scope: !129)
!188 = !DILocation(line: 143, column: 5, scope: !129)
!189 = !DILocation(line: 144, column: 5, scope: !129)
!190 = !DILocation(line: 145, column: 32, scope: !191)
!191 = distinct !DILexicalBlock(scope: !129, file: !62, line: 144, column: 8)
!192 = !DILocation(line: 145, column: 37, scope: !191)
!193 = !DILocation(line: 145, column: 9, scope: !191)
!194 = !DILocation(line: 146, column: 9, scope: !191)
!195 = !DILocation(line: 147, column: 23, scope: !191)
!196 = !DILocation(line: 147, column: 28, scope: !191)
!197 = !DILocation(line: 147, column: 35, scope: !191)
!198 = !DILocation(line: 147, column: 41, scope: !191)
!199 = !DILocation(line: 147, column: 13, scope: !191)
!200 = !DILocation(line: 147, column: 11, scope: !191)
!201 = !DILocation(line: 148, column: 13, scope: !202)
!202 = distinct !DILexicalBlock(scope: !191, file: !62, line: 148, column: 13)
!203 = !DILocation(line: 148, column: 18, scope: !202)
!204 = !DILocation(line: 148, column: 15, scope: !202)
!205 = !DILocation(line: 149, column: 13, scope: !206)
!206 = distinct !DILexicalBlock(scope: !202, file: !62, line: 148, column: 25)
!207 = !DILocation(line: 149, column: 42, scope: !206)
!208 = !DILocation(line: 149, column: 47, scope: !206)
!209 = !DILocation(line: 149, column: 20, scope: !206)
!210 = distinct !{!210, !205, !211, !182}
!211 = !DILocation(line: 150, column: 17, scope: !206)
!212 = !DILocation(line: 151, column: 9, scope: !206)
!213 = !DILocation(line: 156, column: 27, scope: !191)
!214 = !DILocation(line: 156, column: 35, scope: !191)
!215 = !DILocation(line: 156, column: 17, scope: !191)
!216 = !DILocation(line: 156, column: 15, scope: !191)
!217 = !DILocation(line: 160, column: 5, scope: !191)
!218 = !DILocation(line: 160, column: 14, scope: !129)
!219 = !DILocation(line: 160, column: 20, scope: !129)
!220 = distinct !{!220, !189, !221, !182}
!221 = !DILocation(line: 160, column: 24, scope: !129)
!222 = !DILocation(line: 161, column: 29, scope: !129)
!223 = !DILocation(line: 161, column: 5, scope: !129)
!224 = !DILabel(scope: !129, name: "acquired", file: !62, line: 163, column: 1)
!225 = !DILocation(line: 163, column: 1, scope: !129)
!226 = !DILocation(line: 164, column: 5, scope: !129)
!227 = !DILocation(line: 165, column: 1, scope: !129)
!228 = distinct !DISubprogram(name: "brgpk_mutex_leave", scope: !62, file: !62, line: 167, type: !229, scopeLine: 168, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !100)
!229 = !DISubroutineType(types: !230)
!230 = !{null, !71, !21}
!231 = !DILocalVariable(name: "mtx", arg: 1, scope: !228, file: !62, line: 167, type: !71)
!232 = !DILocation(line: 167, column: 53, scope: !228)
!233 = !DILocalVariable(name: "self", arg: 2, scope: !228, file: !62, line: 167, type: !21)
!234 = !DILocation(line: 167, column: 68, scope: !228)
!235 = !DILocalVariable(name: "owner", scope: !228, file: !62, line: 169, type: !21)
!236 = !DILocation(line: 169, column: 15, scope: !228)
!237 = !DILocation(line: 171, column: 5, scope: !228)
!238 = !DILocation(line: 172, column: 23, scope: !228)
!239 = !DILocation(line: 172, column: 28, scope: !228)
!240 = !DILocation(line: 172, column: 13, scope: !228)
!241 = !DILocation(line: 172, column: 11, scope: !228)
!242 = !DILocation(line: 173, column: 9, scope: !243)
!243 = distinct !DILexicalBlock(scope: !228, file: !62, line: 173, column: 9)
!244 = !DILocation(line: 173, column: 18, scope: !243)
!245 = !DILocation(line: 173, column: 15, scope: !243)
!246 = !DILocation(line: 174, column: 31, scope: !247)
!247 = distinct !DILexicalBlock(scope: !243, file: !62, line: 173, column: 24)
!248 = !DILocation(line: 174, column: 9, scope: !247)
!249 = !DILocation(line: 175, column: 9, scope: !247)
!250 = !DILocation(line: 176, column: 37, scope: !247)
!251 = !DILocation(line: 176, column: 9, scope: !247)
!252 = !DILocation(line: 177, column: 5, scope: !247)
!253 = !DILocation(line: 178, column: 1, scope: !228)
!254 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 34, type: !255, scopeLine: 35, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !100)
!255 = !DISubroutineType(types: !256)
!256 = !{!58}
!257 = !DILocalVariable(name: "t", scope: !254, file: !3, line: 36, type: !258)
!258 = !DICompositeType(tag: DW_TAG_array_type, baseType: !259, size: 192, elements: !79)
!259 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !260, line: 31, baseType: !261)
!260 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!261 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !262, line: 118, baseType: !263)
!262 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!263 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !264, size: 64)
!264 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !262, line: 103, size: 65536, elements: !265)
!265 = !{!266, !267, !277}
!266 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !264, file: !262, line: 104, baseType: !20, size: 64)
!267 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !264, file: !262, line: 105, baseType: !268, size: 64, offset: 64)
!268 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !269, size: 64)
!269 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !262, line: 57, size: 192, elements: !270)
!270 = !{!271, !275, !276}
!271 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !269, file: !262, line: 58, baseType: !272, size: 64)
!272 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !273, size: 64)
!273 = !DISubroutineType(types: !274)
!274 = !{null, !24}
!275 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !269, file: !262, line: 59, baseType: !24, size: 64, offset: 64)
!276 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !269, file: !262, line: 60, baseType: !268, size: 64, offset: 128)
!277 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !264, file: !262, line: 106, baseType: !278, size: 65408, offset: 128)
!278 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 65408, elements: !279)
!279 = !{!280}
!280 = !DISubrange(count: 8176)
!281 = !DILocation(line: 36, column: 15, scope: !254)
!282 = !DILocation(line: 38, column: 5, scope: !254)
!283 = !DILocalVariable(name: "i", scope: !284, file: !3, line: 40, type: !58)
!284 = distinct !DILexicalBlock(scope: !254, file: !3, line: 40, column: 5)
!285 = !DILocation(line: 40, column: 14, scope: !284)
!286 = !DILocation(line: 40, column: 10, scope: !284)
!287 = !DILocation(line: 40, column: 21, scope: !288)
!288 = distinct !DILexicalBlock(scope: !284, file: !3, line: 40, column: 5)
!289 = !DILocation(line: 40, column: 23, scope: !288)
!290 = !DILocation(line: 40, column: 5, scope: !284)
!291 = !DILocation(line: 41, column: 27, scope: !288)
!292 = !DILocation(line: 41, column: 25, scope: !288)
!293 = !DILocation(line: 41, column: 60, scope: !288)
!294 = !DILocation(line: 41, column: 52, scope: !288)
!295 = !DILocation(line: 41, column: 44, scope: !288)
!296 = !DILocation(line: 41, column: 9, scope: !288)
!297 = !DILocation(line: 40, column: 36, scope: !288)
!298 = !DILocation(line: 40, column: 5, scope: !288)
!299 = distinct !{!299, !290, !300, !182}
!300 = !DILocation(line: 41, column: 61, scope: !284)
!301 = !DILocalVariable(name: "i", scope: !302, file: !3, line: 43, type: !58)
!302 = distinct !DILexicalBlock(scope: !254, file: !3, line: 43, column: 5)
!303 = !DILocation(line: 43, column: 14, scope: !302)
!304 = !DILocation(line: 43, column: 10, scope: !302)
!305 = !DILocation(line: 43, column: 21, scope: !306)
!306 = distinct !DILexicalBlock(scope: !302, file: !3, line: 43, column: 5)
!307 = !DILocation(line: 43, column: 23, scope: !306)
!308 = !DILocation(line: 43, column: 5, scope: !302)
!309 = !DILocation(line: 44, column: 24, scope: !306)
!310 = !DILocation(line: 44, column: 22, scope: !306)
!311 = !DILocation(line: 44, column: 9, scope: !306)
!312 = !DILocation(line: 43, column: 36, scope: !306)
!313 = !DILocation(line: 43, column: 5, scope: !306)
!314 = distinct !{!314, !308, !315, !182}
!315 = !DILocation(line: 44, column: 29, scope: !302)
!316 = !DILocation(line: 46, column: 12, scope: !254)
!317 = !DILocation(line: 46, column: 16, scope: !254)
!318 = !DILocation(line: 46, column: 5, scope: !254)
!319 = !DILocation(line: 48, column: 5, scope: !254)
!320 = distinct !DISubprogram(name: "brgpk_mutex_init", scope: !62, file: !62, line: 110, type: !321, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !100)
!321 = !DISubroutineType(types: !322)
!322 = !{null, !71}
!323 = !DILocalVariable(name: "mtx", arg: 1, scope: !320, file: !62, line: 110, type: !71)
!324 = !DILocation(line: 110, column: 52, scope: !320)
!325 = !DILocation(line: 112, column: 17, scope: !320)
!326 = !DILocation(line: 112, column: 5, scope: !320)
!327 = !DILocation(line: 113, column: 1, scope: !320)
!328 = distinct !DISubprogram(name: "brgpk_cas", scope: !62, file: !62, line: 116, type: !329, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !100)
!329 = !DISubroutineType(types: !330)
!330 = !{!21, !71, !21, !21}
!331 = !DILocalVariable(name: "mtx", arg: 1, scope: !328, file: !62, line: 116, type: !71)
!332 = !DILocation(line: 116, column: 50, scope: !328)
!333 = !DILocalVariable(name: "o", arg: 2, scope: !328, file: !62, line: 116, type: !21)
!334 = !DILocation(line: 116, column: 65, scope: !328)
!335 = !DILocalVariable(name: "n", arg: 3, scope: !328, file: !62, line: 116, type: !21)
!336 = !DILocation(line: 116, column: 78, scope: !328)
!337 = !DILocation(line: 118, column: 45, scope: !328)
!338 = !DILocation(line: 118, column: 54, scope: !328)
!339 = !DILocation(line: 118, column: 5, scope: !328)
!340 = !DILocation(line: 120, column: 12, scope: !328)
!341 = !DILocation(line: 120, column: 5, scope: !328)
!342 = distinct !DISubprogram(name: "brgpk_append", scope: !62, file: !62, line: 69, type: !343, scopeLine: 70, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !100)
!343 = !DISubroutineType(types: !344)
!344 = !{null, !345, !77}
!345 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !83, size: 64)
!346 = !DILocalVariable(name: "pl", arg: 1, scope: !342, file: !62, line: 69, type: !345)
!347 = !DILocation(line: 69, column: 59, scope: !342)
!348 = !DILocalVariable(name: "wtr", arg: 2, scope: !342, file: !62, line: 69, type: !77)
!349 = !DILocation(line: 69, column: 84, scope: !342)
!350 = !DILocation(line: 71, column: 20, scope: !342)
!351 = !DILocation(line: 71, column: 5, scope: !342)
!352 = !DILocation(line: 72, column: 5, scope: !342)
!353 = !DILocation(line: 72, column: 10, scope: !342)
!354 = !DILocation(line: 72, column: 15, scope: !342)
!355 = !DILocation(line: 73, column: 17, scope: !342)
!356 = !DILocation(line: 73, column: 21, scope: !342)
!357 = !DILocation(line: 73, column: 5, scope: !342)
!358 = !DILocation(line: 73, column: 10, scope: !342)
!359 = !DILocation(line: 73, column: 15, scope: !342)
!360 = !DILocation(line: 74, column: 9, scope: !361)
!361 = distinct !DILexicalBlock(scope: !342, file: !62, line: 74, column: 9)
!362 = !DILocation(line: 74, column: 13, scope: !361)
!363 = !DILocation(line: 74, column: 18, scope: !361)
!364 = !DILocation(line: 75, column: 26, scope: !361)
!365 = !DILocation(line: 75, column: 9, scope: !361)
!366 = !DILocation(line: 75, column: 13, scope: !361)
!367 = !DILocation(line: 75, column: 19, scope: !361)
!368 = !DILocation(line: 75, column: 24, scope: !361)
!369 = !DILocation(line: 77, column: 20, scope: !361)
!370 = !DILocation(line: 77, column: 9, scope: !361)
!371 = !DILocation(line: 77, column: 13, scope: !361)
!372 = !DILocation(line: 77, column: 18, scope: !361)
!373 = !DILocation(line: 78, column: 16, scope: !342)
!374 = !DILocation(line: 78, column: 5, scope: !342)
!375 = !DILocation(line: 78, column: 9, scope: !342)
!376 = !DILocation(line: 78, column: 14, scope: !342)
!377 = !DILocation(line: 79, column: 20, scope: !342)
!378 = !DILocation(line: 79, column: 5, scope: !342)
!379 = !DILocation(line: 80, column: 1, scope: !342)
!380 = distinct !DISubprogram(name: "brgpk_remove", scope: !62, file: !62, line: 82, type: !343, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !100)
!381 = !DILocalVariable(name: "pl", arg: 1, scope: !380, file: !62, line: 82, type: !345)
!382 = !DILocation(line: 82, column: 59, scope: !380)
!383 = !DILocalVariable(name: "wtr", arg: 2, scope: !380, file: !62, line: 82, type: !77)
!384 = !DILocation(line: 82, column: 84, scope: !380)
!385 = !DILocation(line: 84, column: 20, scope: !380)
!386 = !DILocation(line: 84, column: 5, scope: !380)
!387 = !DILocation(line: 85, column: 9, scope: !388)
!388 = distinct !DILexicalBlock(scope: !380, file: !62, line: 85, column: 9)
!389 = !DILocation(line: 85, column: 14, scope: !388)
!390 = !DILocation(line: 85, column: 19, scope: !388)
!391 = !DILocation(line: 86, column: 27, scope: !388)
!392 = !DILocation(line: 86, column: 32, scope: !388)
!393 = !DILocation(line: 86, column: 9, scope: !388)
!394 = !DILocation(line: 86, column: 14, scope: !388)
!395 = !DILocation(line: 86, column: 20, scope: !388)
!396 = !DILocation(line: 86, column: 25, scope: !388)
!397 = !DILocation(line: 88, column: 20, scope: !388)
!398 = !DILocation(line: 88, column: 25, scope: !388)
!399 = !DILocation(line: 88, column: 9, scope: !388)
!400 = !DILocation(line: 88, column: 13, scope: !388)
!401 = !DILocation(line: 88, column: 18, scope: !388)
!402 = !DILocation(line: 89, column: 9, scope: !403)
!403 = distinct !DILexicalBlock(scope: !380, file: !62, line: 89, column: 9)
!404 = !DILocation(line: 89, column: 14, scope: !403)
!405 = !DILocation(line: 89, column: 19, scope: !403)
!406 = !DILocation(line: 90, column: 27, scope: !403)
!407 = !DILocation(line: 90, column: 32, scope: !403)
!408 = !DILocation(line: 90, column: 9, scope: !403)
!409 = !DILocation(line: 90, column: 14, scope: !403)
!410 = !DILocation(line: 90, column: 20, scope: !403)
!411 = !DILocation(line: 90, column: 25, scope: !403)
!412 = !DILocation(line: 92, column: 20, scope: !403)
!413 = !DILocation(line: 92, column: 25, scope: !403)
!414 = !DILocation(line: 92, column: 9, scope: !403)
!415 = !DILocation(line: 92, column: 13, scope: !403)
!416 = !DILocation(line: 92, column: 18, scope: !403)
!417 = !DILocation(line: 93, column: 20, scope: !380)
!418 = !DILocation(line: 93, column: 5, scope: !380)
!419 = !DILocation(line: 94, column: 1, scope: !380)
!420 = distinct !DISubprogram(name: "brgpk_pl_enter", scope: !62, file: !62, line: 53, type: !421, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !100)
!421 = !DISubroutineType(types: !422)
!422 = !{null, !345}
!423 = !DILocalVariable(name: "pl", arg: 1, scope: !420, file: !62, line: 53, type: !345)
!424 = !DILocation(line: 53, column: 61, scope: !420)
!425 = !DILocalVariable(name: "expected", scope: !420, file: !62, line: 55, type: !58)
!426 = !DILocation(line: 55, column: 9, scope: !420)
!427 = !DILocation(line: 56, column: 5, scope: !420)
!428 = !DILocation(line: 57, column: 9, scope: !429)
!429 = distinct !DILexicalBlock(scope: !420, file: !62, line: 56, column: 8)
!430 = !DILocation(line: 57, column: 38, scope: !429)
!431 = !DILocation(line: 57, column: 42, scope: !429)
!432 = !DILocation(line: 57, column: 16, scope: !429)
!433 = !DILocation(line: 57, column: 70, scope: !429)
!434 = distinct !{!434, !428, !435, !182}
!435 = !DILocation(line: 58, column: 13, scope: !429)
!436 = !DILocation(line: 59, column: 18, scope: !429)
!437 = !DILocation(line: 60, column: 5, scope: !429)
!438 = !DILocation(line: 60, column: 56, scope: !420)
!439 = !DILocation(line: 60, column: 60, scope: !420)
!440 = !DILocation(line: 60, column: 15, scope: !420)
!441 = !DILocation(line: 60, column: 14, scope: !420)
!442 = distinct !{!442, !427, !443, !182}
!443 = !DILocation(line: 61, column: 60, scope: !420)
!444 = !DILocation(line: 62, column: 1, scope: !420)
!445 = distinct !DISubprogram(name: "brgpk_pl_leave", scope: !62, file: !62, line: 64, type: !421, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !100)
!446 = !DILocalVariable(name: "pl", arg: 1, scope: !445, file: !62, line: 64, type: !345)
!447 = !DILocation(line: 64, column: 61, scope: !445)
!448 = !DILocation(line: 66, column: 28, scope: !445)
!449 = !DILocation(line: 66, column: 32, scope: !445)
!450 = !DILocation(line: 66, column: 5, scope: !445)
!451 = !DILocation(line: 67, column: 1, scope: !445)
!452 = distinct !DISubprogram(name: "brgpk_wake_first", scope: !62, file: !62, line: 96, type: !453, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !100)
!453 = !DISubroutineType(types: !454)
!454 = !{null, !345, !71}
!455 = !DILocalVariable(name: "pl", arg: 1, scope: !452, file: !62, line: 96, type: !345)
!456 = !DILocation(line: 96, column: 63, scope: !452)
!457 = !DILocalVariable(name: "mtx", arg: 2, scope: !452, file: !62, line: 96, type: !71)
!458 = !DILocation(line: 96, column: 82, scope: !452)
!459 = !DILocation(line: 98, column: 20, scope: !452)
!460 = !DILocation(line: 98, column: 5, scope: !452)
!461 = !DILocalVariable(name: "wtr", scope: !462, file: !62, line: 99, type: !77)
!462 = distinct !DILexicalBlock(scope: !452, file: !62, line: 99, column: 5)
!463 = !DILocation(line: 99, column: 31, scope: !462)
!464 = !DILocation(line: 99, column: 37, scope: !462)
!465 = !DILocation(line: 99, column: 41, scope: !462)
!466 = !DILocation(line: 99, column: 10, scope: !462)
!467 = !DILocation(line: 99, column: 47, scope: !468)
!468 = distinct !DILexicalBlock(scope: !462, file: !62, line: 99, column: 5)
!469 = !DILocation(line: 99, column: 51, scope: !468)
!470 = !DILocation(line: 99, column: 5, scope: !462)
!471 = !DILocation(line: 100, column: 13, scope: !472)
!472 = distinct !DILexicalBlock(scope: !473, file: !62, line: 100, column: 13)
!473 = distinct !DILexicalBlock(scope: !468, file: !62, line: 99, column: 77)
!474 = !DILocation(line: 100, column: 18, scope: !472)
!475 = !DILocation(line: 100, column: 25, scope: !472)
!476 = !DILocation(line: 100, column: 22, scope: !472)
!477 = !DILocation(line: 101, column: 36, scope: !478)
!478 = distinct !DILexicalBlock(scope: !472, file: !62, line: 100, column: 30)
!479 = !DILocation(line: 101, column: 41, scope: !478)
!480 = !DILocation(line: 101, column: 13, scope: !478)
!481 = !DILocation(line: 102, column: 13, scope: !478)
!482 = !DILocation(line: 104, column: 5, scope: !473)
!483 = !DILocation(line: 99, column: 66, scope: !468)
!484 = !DILocation(line: 99, column: 71, scope: !468)
!485 = !DILocation(line: 99, column: 64, scope: !468)
!486 = !DILocation(line: 99, column: 5, scope: !468)
!487 = distinct !{!487, !470, !488, !182}
!488 = !DILocation(line: 104, column: 5, scope: !462)
!489 = !DILocation(line: 105, column: 20, scope: !452)
!490 = !DILocation(line: 105, column: 5, scope: !452)
!491 = !DILocation(line: 106, column: 1, scope: !452)
