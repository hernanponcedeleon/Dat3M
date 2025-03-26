; ModuleID = 'tests/spsc_queue.c'
source_filename = "tests/spsc_queue.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_fifo_spsc = type { %struct.ck_spinlock_fas, ptr, [52 x i8], %struct.ck_spinlock_fas, ptr, ptr, ptr }
%struct.ck_spinlock_fas = type { i32 }
%struct.point_s = type { i32, i32 }
%struct.ck_fifo_spsc_entry = type { ptr, ptr }

@queue = global %struct.ck_fifo_spsc zeroinitializer, align 8, !dbg !0
@.str = private unnamed_addr constant [20 x i8] c"NULL point received\00", align 1, !dbg !20
@__func__.consumer = private unnamed_addr constant [9 x i8] c"consumer\00", align 1, !dbg !26
@.str.1 = private unnamed_addr constant [13 x i8] c"spsc_queue.c\00", align 1, !dbg !32
@.str.2 = private unnamed_addr constant [39 x i8] c"point != NULL && \22NULL point received\22\00", align 1, !dbg !37
@.str.3 = private unnamed_addr constant [21 x i8] c"point->x == point->y\00", align 1, !dbg !42
@.str.4 = private unnamed_addr constant [14 x i8] c"point->y == 1\00", align 1, !dbg !47

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @producer(ptr noundef %0) #0 !dbg !79 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  store i32 0, ptr %3, align 4, !dbg !88
  br label %7, !dbg !89

7:                                                ; preds = %28, %1
  %8 = load i32, ptr %3, align 4, !dbg !90
  %9 = icmp slt i32 %8, 3, !dbg !92
  br i1 %9, label %10, label %31, !dbg !93

10:                                               ; preds = %7
  %11 = call ptr @malloc(i64 noundef 8) #5, !dbg !103
  store ptr %11, ptr %4, align 8, !dbg !102
  %12 = load ptr, ptr %4, align 8, !dbg !104
  %13 = icmp eq ptr %12, null, !dbg !106
  br i1 %13, label %14, label %15, !dbg !107

14:                                               ; preds = %10
  call void @exit(i32 noundef 1) #6, !dbg !108
  unreachable, !dbg !108

15:                                               ; preds = %10
  %16 = load ptr, ptr %4, align 8, !dbg !110
  %17 = getelementptr inbounds %struct.point_s, ptr %16, i32 0, i32 0, !dbg !111
  store i32 1, ptr %17, align 4, !dbg !112
  %18 = load ptr, ptr %4, align 8, !dbg !113
  %19 = getelementptr inbounds %struct.point_s, ptr %18, i32 0, i32 1, !dbg !114
  store i32 1, ptr %19, align 4, !dbg !115
  %20 = call ptr @malloc(i64 noundef 16) #5, !dbg !120
  store ptr %20, ptr %5, align 8, !dbg !119
  %21 = load ptr, ptr %5, align 8, !dbg !121
  %22 = icmp eq ptr %21, null, !dbg !123
  br i1 %22, label %23, label %25, !dbg !124

23:                                               ; preds = %15
  %24 = load ptr, ptr %4, align 8, !dbg !125
  call void @free(ptr noundef %24), !dbg !127
  call void @exit(i32 noundef 1) #6, !dbg !128
  unreachable, !dbg !128

25:                                               ; preds = %15
  %26 = load ptr, ptr %5, align 8, !dbg !129
  %27 = load ptr, ptr %4, align 8, !dbg !130
  call void @ck_fifo_spsc_enqueue(ptr noundef @queue, ptr noundef %26, ptr noundef %27), !dbg !131
  br label %28, !dbg !132

28:                                               ; preds = %25
  %29 = load i32, ptr %3, align 4, !dbg !133
  %30 = add nsw i32 %29, 1, !dbg !133
  store i32 %30, ptr %3, align 4, !dbg !133
  br label %7, !dbg !134, !llvm.loop !135

31:                                               ; preds = %7
  %32 = call ptr @malloc(i64 noundef 16) #5, !dbg !140
  store ptr %32, ptr %6, align 8, !dbg !139
  %33 = load ptr, ptr %6, align 8, !dbg !141
  %34 = icmp eq ptr %33, null, !dbg !143
  br i1 %34, label %35, label %36, !dbg !144

35:                                               ; preds = %31
  call void @exit(i32 noundef 1) #6, !dbg !145
  unreachable, !dbg !145

36:                                               ; preds = %31
  %37 = load ptr, ptr %6, align 8, !dbg !147
  call void @ck_fifo_spsc_enqueue(ptr noundef @queue, ptr noundef %37, ptr noundef null), !dbg !148
  ret ptr null, !dbg !149
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #2

declare void @free(ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_fifo_spsc_enqueue(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 !dbg !150 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store ptr %2, ptr %6, align 8
  %7 = load ptr, ptr %6, align 8, !dbg !160
  %8 = load ptr, ptr %5, align 8, !dbg !161
  %9 = getelementptr inbounds %struct.ck_fifo_spsc_entry, ptr %8, i32 0, i32 0, !dbg !162
  store ptr %7, ptr %9, align 8, !dbg !163
  %10 = load ptr, ptr %5, align 8, !dbg !164
  %11 = getelementptr inbounds %struct.ck_fifo_spsc_entry, ptr %10, i32 0, i32 1, !dbg !165
  store ptr null, ptr %11, align 8, !dbg !166
  call void @ck_pr_fence_store(), !dbg !167
  %12 = load ptr, ptr %4, align 8, !dbg !168
  %13 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %12, i32 0, i32 4, !dbg !168
  %14 = load ptr, ptr %13, align 8, !dbg !168
  %15 = getelementptr inbounds %struct.ck_fifo_spsc_entry, ptr %14, i32 0, i32 1, !dbg !168
  %16 = load ptr, ptr %5, align 8, !dbg !168
  call void @ck_pr_md_store_ptr(ptr noundef %15, ptr noundef %16), !dbg !168
  %17 = load ptr, ptr %5, align 8, !dbg !169
  %18 = load ptr, ptr %4, align 8, !dbg !170
  %19 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %18, i32 0, i32 4, !dbg !171
  store ptr %17, ptr %19, align 8, !dbg !172
  ret void, !dbg !173
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @consumer(ptr noundef %0) #0 !dbg !174 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
  store i32 0, ptr %4, align 4, !dbg !181
  br label %6, !dbg !182

6:                                                ; preds = %56, %1
  %7 = load i32, ptr %4, align 4, !dbg !183
  %8 = icmp slt i32 %7, 3, !dbg !185
  br i1 %8, label %9, label %59, !dbg !186

9:                                                ; preds = %6
  %10 = call zeroext i1 @ck_fifo_spsc_dequeue(ptr noundef @queue, ptr noundef %3), !dbg !191
  %11 = zext i1 %10 to i8, !dbg !190
  store i8 %11, ptr %5, align 1, !dbg !190
  %12 = load i8, ptr %5, align 1, !dbg !192
  %13 = trunc i8 %12 to i1, !dbg !192
  %14 = zext i1 %13 to i32, !dbg !192
  call void @__VERIFIER_assume(i32 noundef %14), !dbg !193
  %15 = load ptr, ptr %3, align 8, !dbg !194
  %16 = icmp ne ptr %15, null, !dbg !194
  br i1 %16, label %17, label %18, !dbg !194

17:                                               ; preds = %9
  br label %18

18:                                               ; preds = %17, %9
  %19 = phi i1 [ false, %9 ], [ true, %17 ], !dbg !195
  %20 = xor i1 %19, true, !dbg !194
  %21 = zext i1 %20 to i32, !dbg !194
  %22 = sext i32 %21 to i64, !dbg !194
  %23 = icmp ne i64 %22, 0, !dbg !194
  br i1 %23, label %24, label %26, !dbg !194

24:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.consumer, ptr noundef @.str.1, i32 noundef 63, ptr noundef @.str.2) #7, !dbg !194
  unreachable, !dbg !194

25:                                               ; No predecessors!
  br label %27, !dbg !194

26:                                               ; preds = %18
  br label %27, !dbg !194

27:                                               ; preds = %26, %25
  %28 = load ptr, ptr %3, align 8, !dbg !196
  %29 = getelementptr inbounds %struct.point_s, ptr %28, i32 0, i32 0, !dbg !196
  %30 = load i32, ptr %29, align 4, !dbg !196
  %31 = load ptr, ptr %3, align 8, !dbg !196
  %32 = getelementptr inbounds %struct.point_s, ptr %31, i32 0, i32 1, !dbg !196
  %33 = load i32, ptr %32, align 4, !dbg !196
  %34 = icmp eq i32 %30, %33, !dbg !196
  %35 = xor i1 %34, true, !dbg !196
  %36 = zext i1 %35 to i32, !dbg !196
  %37 = sext i32 %36 to i64, !dbg !196
  %38 = icmp ne i64 %37, 0, !dbg !196
  br i1 %38, label %39, label %41, !dbg !196

39:                                               ; preds = %27
  call void @__assert_rtn(ptr noundef @__func__.consumer, ptr noundef @.str.1, i32 noundef 64, ptr noundef @.str.3) #7, !dbg !196
  unreachable, !dbg !196

40:                                               ; No predecessors!
  br label %42, !dbg !196

41:                                               ; preds = %27
  br label %42, !dbg !196

42:                                               ; preds = %41, %40
  %43 = load ptr, ptr %3, align 8, !dbg !197
  %44 = getelementptr inbounds %struct.point_s, ptr %43, i32 0, i32 1, !dbg !197
  %45 = load i32, ptr %44, align 4, !dbg !197
  %46 = icmp eq i32 %45, 1, !dbg !197
  %47 = xor i1 %46, true, !dbg !197
  %48 = zext i1 %47 to i32, !dbg !197
  %49 = sext i32 %48 to i64, !dbg !197
  %50 = icmp ne i64 %49, 0, !dbg !197
  br i1 %50, label %51, label %53, !dbg !197

51:                                               ; preds = %42
  call void @__assert_rtn(ptr noundef @__func__.consumer, ptr noundef @.str.1, i32 noundef 65, ptr noundef @.str.4) #7, !dbg !197
  unreachable, !dbg !197

52:                                               ; No predecessors!
  br label %54, !dbg !197

53:                                               ; preds = %42
  br label %54, !dbg !197

54:                                               ; preds = %53, %52
  %55 = load ptr, ptr %3, align 8, !dbg !198
  call void @free(ptr noundef %55), !dbg !199
  br label %56, !dbg !200

56:                                               ; preds = %54
  %57 = load i32, ptr %4, align 4, !dbg !201
  %58 = add nsw i32 %57, 1, !dbg !201
  store i32 %58, ptr %4, align 4, !dbg !201
  br label %6, !dbg !202, !llvm.loop !203

59:                                               ; preds = %6
  ret ptr null, !dbg !205
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_fifo_spsc_dequeue(ptr noundef %0, ptr noundef %1) #0 !dbg !206 {
  %3 = alloca i1, align 1
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  %7 = load ptr, ptr %4, align 8, !dbg !215
  %8 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %7, i32 0, i32 1, !dbg !215
  %9 = load ptr, ptr %8, align 8, !dbg !215
  %10 = getelementptr inbounds %struct.ck_fifo_spsc_entry, ptr %9, i32 0, i32 1, !dbg !215
  %11 = call ptr @ck_pr_md_load_ptr(ptr noundef %10), !dbg !215
  store ptr %11, ptr %6, align 8, !dbg !216
  %12 = load ptr, ptr %6, align 8, !dbg !217
  %13 = icmp eq ptr %12, null, !dbg !219
  br i1 %13, label %14, label %15, !dbg !220

14:                                               ; preds = %2
  store i1 false, ptr %3, align 1, !dbg !221
  br label %23, !dbg !221

15:                                               ; preds = %2
  %16 = load ptr, ptr %5, align 8, !dbg !222
  %17 = load ptr, ptr %6, align 8, !dbg !222
  %18 = getelementptr inbounds %struct.ck_fifo_spsc_entry, ptr %17, i32 0, i32 0, !dbg !222
  %19 = load ptr, ptr %18, align 8, !dbg !222
  call void @ck_pr_md_store_ptr(ptr noundef %16, ptr noundef %19), !dbg !222
  call void @ck_pr_fence_store(), !dbg !223
  %20 = load ptr, ptr %4, align 8, !dbg !224
  %21 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %20, i32 0, i32 1, !dbg !224
  %22 = load ptr, ptr %6, align 8, !dbg !224
  call void @ck_pr_md_store_ptr(ptr noundef %21, ptr noundef %22), !dbg !224
  store i1 true, ptr %3, align 1, !dbg !225
  br label %23, !dbg !225

23:                                               ; preds = %15, %14
  %24 = load i1, ptr %3, align 1, !dbg !226
  ret i1 %24, !dbg !226
}

declare void @__VERIFIER_assume(i32 noundef) #3

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !227 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
  %6 = call ptr @malloc(i64 noundef 16) #5, !dbg !260
  store ptr %6, ptr %3, align 8, !dbg !259
  %7 = load ptr, ptr %3, align 8, !dbg !261
  %8 = icmp eq ptr %7, null, !dbg !263
  br i1 %8, label %9, label %10, !dbg !264

9:                                                ; preds = %0
  call void @exit(i32 noundef 1) #6, !dbg !265
  unreachable, !dbg !265

10:                                               ; preds = %0
  %11 = load ptr, ptr %3, align 8, !dbg !267
  call void @ck_fifo_spsc_init(ptr noundef @queue, ptr noundef %11), !dbg !268
  %12 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 0, !dbg !269
  %13 = call i32 @pthread_create(ptr noundef %12, ptr noundef null, ptr noundef @producer, ptr noundef null), !dbg !271
  %14 = icmp ne i32 %13, 0, !dbg !272
  br i1 %14, label %19, label %15, !dbg !273

15:                                               ; preds = %10
  %16 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 1, !dbg !274
  %17 = call i32 @pthread_create(ptr noundef %16, ptr noundef null, ptr noundef @consumer, ptr noundef null), !dbg !275
  %18 = icmp ne i32 %17, 0, !dbg !276
  br i1 %18, label %19, label %20, !dbg !277

19:                                               ; preds = %15, %10
  call void @exit(i32 noundef 1) #6, !dbg !278
  unreachable, !dbg !278

20:                                               ; preds = %15
  store i32 0, ptr %4, align 4, !dbg !282
  br label %21, !dbg !283

21:                                               ; preds = %30, %20
  %22 = load i32, ptr %4, align 4, !dbg !284
  %23 = icmp slt i32 %22, 2, !dbg !286
  br i1 %23, label %24, label %33, !dbg !287

24:                                               ; preds = %21
  %25 = load i32, ptr %4, align 4, !dbg !288
  %26 = sext i32 %25 to i64, !dbg !290
  %27 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %26, !dbg !290
  %28 = load ptr, ptr %27, align 8, !dbg !290
  %29 = call i32 @"\01_pthread_join"(ptr noundef %28, ptr noundef null), !dbg !291
  br label %30, !dbg !292

30:                                               ; preds = %24
  %31 = load i32, ptr %4, align 4, !dbg !293
  %32 = add nsw i32 %31, 1, !dbg !293
  store i32 %32, ptr %4, align 4, !dbg !293
  br label %21, !dbg !294, !llvm.loop !295

33:                                               ; preds = %21
  call void @ck_fifo_spsc_deinit(ptr noundef @queue, ptr noundef %5), !dbg !299
  %34 = load ptr, ptr %5, align 8, !dbg !300
  call void @free(ptr noundef %34), !dbg !301
  ret i32 0, !dbg !302
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_fifo_spsc_init(ptr noundef %0, ptr noundef %1) #0 !dbg !303 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8, !dbg !310
  %6 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %5, i32 0, i32 0, !dbg !310
  call void @ck_spinlock_fas_init(ptr noundef %6), !dbg !310
  %7 = load ptr, ptr %3, align 8, !dbg !311
  %8 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %7, i32 0, i32 3, !dbg !311
  call void @ck_spinlock_fas_init(ptr noundef %8), !dbg !311
  %9 = load ptr, ptr %4, align 8, !dbg !312
  %10 = getelementptr inbounds %struct.ck_fifo_spsc_entry, ptr %9, i32 0, i32 1, !dbg !313
  store ptr null, ptr %10, align 8, !dbg !314
  %11 = load ptr, ptr %4, align 8, !dbg !315
  %12 = load ptr, ptr %3, align 8, !dbg !316
  %13 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %12, i32 0, i32 6, !dbg !317
  store ptr %11, ptr %13, align 8, !dbg !318
  %14 = load ptr, ptr %3, align 8, !dbg !319
  %15 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %14, i32 0, i32 5, !dbg !320
  store ptr %11, ptr %15, align 8, !dbg !321
  %16 = load ptr, ptr %3, align 8, !dbg !322
  %17 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %16, i32 0, i32 4, !dbg !323
  store ptr %11, ptr %17, align 8, !dbg !324
  %18 = load ptr, ptr %3, align 8, !dbg !325
  %19 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %18, i32 0, i32 1, !dbg !326
  store ptr %11, ptr %19, align 8, !dbg !327
  ret void, !dbg !328
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_fifo_spsc_deinit(ptr noundef %0, ptr noundef %1) #0 !dbg !329 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8, !dbg !337
  %6 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %5, i32 0, i32 6, !dbg !338
  %7 = load ptr, ptr %6, align 8, !dbg !338
  %8 = load ptr, ptr %4, align 8, !dbg !339
  store ptr %7, ptr %8, align 8, !dbg !340
  %9 = load ptr, ptr %3, align 8, !dbg !341
  %10 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %9, i32 0, i32 4, !dbg !342
  store ptr null, ptr %10, align 8, !dbg !343
  %11 = load ptr, ptr %3, align 8, !dbg !344
  %12 = getelementptr inbounds %struct.ck_fifo_spsc, ptr %11, i32 0, i32 1, !dbg !345
  store ptr null, ptr %12, align 8, !dbg !346
  ret void, !dbg !347
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_store() #0 !dbg !348 {
  call void @ck_pr_fence_strict_store(), !dbg !352
  ret void, !dbg !352
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_md_store_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !353 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8, !dbg !360
  %6 = load ptr, ptr %4, align 8, !dbg !360
  call void asm sideeffect "std $1, $0", "=*m,r,~{memory}"(ptr elementtype(i64) %5, ptr %6) #8, !dbg !360, !srcloc !362
  ret void, !dbg !360
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_store() #0 !dbg !363 {
  call void asm sideeffect "lwsync", "~{memory}"() #8, !dbg !364, !srcloc !365
  ret void, !dbg !364
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 !dbg !366 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !370
  %5 = call ptr asm sideeffect "ld $0, $1", "=r,*m,~{memory}"(ptr elementtype(i64) %4) #8, !dbg !370, !srcloc !372
  store ptr %5, ptr %3, align 8, !dbg !370
  %6 = load ptr, ptr %3, align 8, !dbg !370
  ret ptr %6, !dbg !370
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_fas_init(ptr noundef %0) #0 !dbg !373 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8, !dbg !379
  %4 = getelementptr inbounds %struct.ck_spinlock_fas, ptr %3, i32 0, i32 0, !dbg !380
  store i32 0, ptr %4, align 4, !dbg !381
  call void @ck_pr_barrier(), !dbg !382
  ret void, !dbg !383
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_barrier() #0 !dbg !384 {
  call void asm sideeffect "", "~{memory}"() #8, !dbg !386, !srcloc !387
  ret void, !dbg !388
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #4 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #5 = { allocsize(0) }
attributes #6 = { noreturn }
attributes #7 = { cold noreturn }
attributes #8 = { nounwind }

!llvm.module.flags = !{!71, !72, !73, !74, !75, !76, !77}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!78}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "queue", scope: !2, file: !3, line: 21, type: !52, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !19, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "tests/spsc_queue.c", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "7bec67ad4368bbed4d80bc0489a6ba84")
!4 = !{!5, !6, !7, !11, !17}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !9, line: 31, baseType: !10)
!9 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/_types/_uint64_t.h", directory: "", checksumkind: CSK_MD5, checksum: "77fc5e91653260959605f129691cf9b1")
!10 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_fifo_spsc_entry", file: !13, line: 39, size: 128, elements: !14)
!13 = !DIFile(filename: "include/ck_fifo.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "252298fd696ccc816ddf53f92a49d2df")
!14 = !{!15, !16}
!15 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !12, file: !13, line: 40, baseType: !5, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !12, file: !13, line: 41, baseType: !11, size: 64, offset: 64)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !8)
!19 = !{!20, !26, !32, !37, !42, !47, !0}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !22, isLocal: true, isDefinition: true)
!22 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 160, elements: !24)
!23 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!24 = !{!25}
!25 = !DISubrange(count: 20)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !28, isLocal: true, isDefinition: true)
!28 = !DICompositeType(tag: DW_TAG_array_type, baseType: !29, size: 72, elements: !30)
!29 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
!30 = !{!31}
!31 = !DISubrange(count: 9)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !34, isLocal: true, isDefinition: true)
!34 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 104, elements: !35)
!35 = !{!36}
!36 = !DISubrange(count: 13)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 312, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 39)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !3, line: 64, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 168, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 21)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(scope: null, file: !3, line: 65, type: !49, isLocal: true, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 112, elements: !50)
!50 = !{!51}
!51 = !DISubrange(count: 14)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_fifo_spsc_t", file: !13, line: 54, baseType: !53)
!53 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_fifo_spsc", file: !13, line: 45, size: 768, elements: !54)
!54 = !{!55, !62, !63, !67, !68, !69, !70}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "m_head", scope: !53, file: !13, line: 46, baseType: !56, size: 32)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_fas_t", file: !57, line: 42, baseType: !58)
!57 = !DIFile(filename: "include/spinlock/fas.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "999805093e3ea65ae15690fa7c76e04b")
!58 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_fas", file: !57, line: 39, size: 32, elements: !59)
!59 = !{!60}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !58, file: !57, line: 40, baseType: !61, size: 32)
!61 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !53, file: !13, line: 47, baseType: !11, size: 64, offset: 64)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !53, file: !13, line: 48, baseType: !64, size: 416, offset: 128)
!64 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 416, elements: !65)
!65 = !{!66}
!66 = !DISubrange(count: 52)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "m_tail", scope: !53, file: !13, line: 49, baseType: !56, size: 32, offset: 544)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !53, file: !13, line: 50, baseType: !11, size: 64, offset: 576)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "head_snapshot", scope: !53, file: !13, line: 51, baseType: !11, size: 64, offset: 640)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "garbage", scope: !53, file: !13, line: 52, baseType: !11, size: 64, offset: 704)
!71 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 0]}
!72 = !{i32 7, !"Dwarf Version", i32 5}
!73 = !{i32 2, !"Debug Info Version", i32 3}
!74 = !{i32 1, !"wchar_size", i32 4}
!75 = !{i32 8, !"PIC Level", i32 2}
!76 = !{i32 7, !"uwtable", i32 1}
!77 = !{i32 7, !"frame-pointer", i32 1}
!78 = !{!"Homebrew clang version 19.1.7"}
!79 = distinct !DISubprogram(name: "producer", scope: !3, file: !3, line: 23, type: !80, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !82)
!80 = !DISubroutineType(types: !81)
!81 = !{!5, !5}
!82 = !{}
!83 = !DILocalVariable(name: "arg", arg: 1, scope: !79, file: !3, line: 23, type: !5)
!84 = !DILocation(line: 23, column: 22, scope: !79)
!85 = !DILocalVariable(name: "i", scope: !86, file: !3, line: 25, type: !87)
!86 = distinct !DILexicalBlock(scope: !79, file: !3, line: 25, column: 5)
!87 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!88 = !DILocation(line: 25, column: 14, scope: !86)
!89 = !DILocation(line: 25, column: 10, scope: !86)
!90 = !DILocation(line: 25, column: 21, scope: !91)
!91 = distinct !DILexicalBlock(scope: !86, file: !3, line: 25, column: 5)
!92 = !DILocation(line: 25, column: 23, scope: !91)
!93 = !DILocation(line: 25, column: 5, scope: !86)
!94 = !DILocalVariable(name: "point", scope: !95, file: !3, line: 27, type: !96)
!95 = distinct !DILexicalBlock(scope: !91, file: !3, line: 26, column: 5)
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_typedef, name: "point_t", file: !3, line: 19, baseType: !98)
!98 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "point_s", file: !3, line: 15, size: 64, elements: !99)
!99 = !{!100, !101}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !98, file: !3, line: 17, baseType: !61, size: 32)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !98, file: !3, line: 18, baseType: !61, size: 32, offset: 32)
!102 = !DILocation(line: 27, column: 18, scope: !95)
!103 = !DILocation(line: 27, column: 26, scope: !95)
!104 = !DILocation(line: 28, column: 13, scope: !105)
!105 = distinct !DILexicalBlock(scope: !95, file: !3, line: 28, column: 13)
!106 = !DILocation(line: 28, column: 19, scope: !105)
!107 = !DILocation(line: 28, column: 13, scope: !95)
!108 = !DILocation(line: 30, column: 13, scope: !109)
!109 = distinct !DILexicalBlock(scope: !105, file: !3, line: 29, column: 9)
!110 = !DILocation(line: 33, column: 9, scope: !95)
!111 = !DILocation(line: 33, column: 16, scope: !95)
!112 = !DILocation(line: 33, column: 18, scope: !95)
!113 = !DILocation(line: 34, column: 9, scope: !95)
!114 = !DILocation(line: 34, column: 16, scope: !95)
!115 = !DILocation(line: 34, column: 18, scope: !95)
!116 = !DILocalVariable(name: "entry", scope: !95, file: !3, line: 36, type: !117)
!117 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !118, size: 64)
!118 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_fifo_spsc_entry_t", file: !13, line: 43, baseType: !12)
!119 = !DILocation(line: 36, column: 31, scope: !95)
!120 = !DILocation(line: 36, column: 39, scope: !95)
!121 = !DILocation(line: 37, column: 13, scope: !122)
!122 = distinct !DILexicalBlock(scope: !95, file: !3, line: 37, column: 13)
!123 = !DILocation(line: 37, column: 19, scope: !122)
!124 = !DILocation(line: 37, column: 13, scope: !95)
!125 = !DILocation(line: 39, column: 18, scope: !126)
!126 = distinct !DILexicalBlock(scope: !122, file: !3, line: 38, column: 9)
!127 = !DILocation(line: 39, column: 13, scope: !126)
!128 = !DILocation(line: 40, column: 13, scope: !126)
!129 = !DILocation(line: 43, column: 38, scope: !95)
!130 = !DILocation(line: 43, column: 45, scope: !95)
!131 = !DILocation(line: 43, column: 9, scope: !95)
!132 = !DILocation(line: 44, column: 5, scope: !95)
!133 = !DILocation(line: 25, column: 45, scope: !91)
!134 = !DILocation(line: 25, column: 5, scope: !91)
!135 = distinct !{!135, !93, !136, !137}
!136 = !DILocation(line: 44, column: 5, scope: !86)
!137 = !{!"llvm.loop.mustprogress"}
!138 = !DILocalVariable(name: "entry", scope: !79, file: !3, line: 46, type: !117)
!139 = !DILocation(line: 46, column: 27, scope: !79)
!140 = !DILocation(line: 46, column: 35, scope: !79)
!141 = !DILocation(line: 47, column: 9, scope: !142)
!142 = distinct !DILexicalBlock(scope: !79, file: !3, line: 47, column: 9)
!143 = !DILocation(line: 47, column: 15, scope: !142)
!144 = !DILocation(line: 47, column: 9, scope: !79)
!145 = !DILocation(line: 49, column: 9, scope: !146)
!146 = distinct !DILexicalBlock(scope: !142, file: !3, line: 48, column: 5)
!147 = !DILocation(line: 51, column: 34, scope: !79)
!148 = !DILocation(line: 51, column: 5, scope: !79)
!149 = !DILocation(line: 53, column: 5, scope: !79)
!150 = distinct !DISubprogram(name: "ck_fifo_spsc_enqueue", scope: !13, file: !13, line: 124, type: !151, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !82)
!151 = !DISubroutineType(types: !152)
!152 = !{null, !153, !11, !5}
!153 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !53, size: 64)
!154 = !DILocalVariable(name: "fifo", arg: 1, scope: !150, file: !13, line: 124, type: !153)
!155 = !DILocation(line: 124, column: 43, scope: !150)
!156 = !DILocalVariable(name: "entry", arg: 2, scope: !150, file: !13, line: 125, type: !11)
!157 = !DILocation(line: 125, column: 35, scope: !150)
!158 = !DILocalVariable(name: "value", arg: 3, scope: !150, file: !13, line: 126, type: !5)
!159 = !DILocation(line: 126, column: 14, scope: !150)
!160 = !DILocation(line: 129, column: 17, scope: !150)
!161 = !DILocation(line: 129, column: 2, scope: !150)
!162 = !DILocation(line: 129, column: 9, scope: !150)
!163 = !DILocation(line: 129, column: 15, scope: !150)
!164 = !DILocation(line: 130, column: 2, scope: !150)
!165 = !DILocation(line: 130, column: 9, scope: !150)
!166 = !DILocation(line: 130, column: 14, scope: !150)
!167 = !DILocation(line: 133, column: 2, scope: !150)
!168 = !DILocation(line: 134, column: 2, scope: !150)
!169 = !DILocation(line: 135, column: 15, scope: !150)
!170 = !DILocation(line: 135, column: 2, scope: !150)
!171 = !DILocation(line: 135, column: 8, scope: !150)
!172 = !DILocation(line: 135, column: 13, scope: !150)
!173 = !DILocation(line: 136, column: 2, scope: !150)
!174 = distinct !DISubprogram(name: "consumer", scope: !3, file: !3, line: 55, type: !80, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !82)
!175 = !DILocalVariable(name: "arg", arg: 1, scope: !174, file: !3, line: 55, type: !5)
!176 = !DILocation(line: 55, column: 22, scope: !174)
!177 = !DILocalVariable(name: "point", scope: !174, file: !3, line: 57, type: !96)
!178 = !DILocation(line: 57, column: 14, scope: !174)
!179 = !DILocalVariable(name: "i", scope: !180, file: !3, line: 59, type: !87)
!180 = distinct !DILexicalBlock(scope: !174, file: !3, line: 59, column: 5)
!181 = !DILocation(line: 59, column: 14, scope: !180)
!182 = !DILocation(line: 59, column: 10, scope: !180)
!183 = !DILocation(line: 59, column: 21, scope: !184)
!184 = distinct !DILexicalBlock(scope: !180, file: !3, line: 59, column: 5)
!185 = !DILocation(line: 59, column: 23, scope: !184)
!186 = !DILocation(line: 59, column: 5, scope: !180)
!187 = !DILocalVariable(name: "res", scope: !188, file: !3, line: 61, type: !189)
!188 = distinct !DILexicalBlock(scope: !184, file: !3, line: 60, column: 5)
!189 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!190 = !DILocation(line: 61, column: 14, scope: !188)
!191 = !DILocation(line: 61, column: 20, scope: !188)
!192 = !DILocation(line: 62, column: 27, scope: !188)
!193 = !DILocation(line: 62, column: 9, scope: !188)
!194 = !DILocation(line: 63, column: 9, scope: !188)
!195 = !DILocation(line: 0, scope: !188)
!196 = !DILocation(line: 64, column: 9, scope: !188)
!197 = !DILocation(line: 65, column: 9, scope: !188)
!198 = !DILocation(line: 67, column: 14, scope: !188)
!199 = !DILocation(line: 67, column: 9, scope: !188)
!200 = !DILocation(line: 68, column: 5, scope: !188)
!201 = !DILocation(line: 59, column: 45, scope: !184)
!202 = !DILocation(line: 59, column: 5, scope: !184)
!203 = distinct !{!203, !186, !204, !137}
!204 = !DILocation(line: 68, column: 5, scope: !180)
!205 = !DILocation(line: 70, column: 5, scope: !174)
!206 = distinct !DISubprogram(name: "ck_fifo_spsc_dequeue", scope: !13, file: !13, line: 140, type: !207, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !82)
!207 = !DISubroutineType(types: !208)
!208 = !{!189, !153, !5}
!209 = !DILocalVariable(name: "fifo", arg: 1, scope: !206, file: !13, line: 140, type: !153)
!210 = !DILocation(line: 140, column: 43, scope: !206)
!211 = !DILocalVariable(name: "value", arg: 2, scope: !206, file: !13, line: 140, type: !5)
!212 = !DILocation(line: 140, column: 55, scope: !206)
!213 = !DILocalVariable(name: "entry", scope: !206, file: !13, line: 142, type: !11)
!214 = !DILocation(line: 142, column: 29, scope: !206)
!215 = !DILocation(line: 149, column: 10, scope: !206)
!216 = !DILocation(line: 149, column: 8, scope: !206)
!217 = !DILocation(line: 150, column: 6, scope: !218)
!218 = distinct !DILexicalBlock(scope: !206, file: !13, line: 150, column: 6)
!219 = !DILocation(line: 150, column: 12, scope: !218)
!220 = !DILocation(line: 150, column: 6, scope: !206)
!221 = !DILocation(line: 151, column: 3, scope: !218)
!222 = !DILocation(line: 154, column: 2, scope: !206)
!223 = !DILocation(line: 155, column: 2, scope: !206)
!224 = !DILocation(line: 156, column: 2, scope: !206)
!225 = !DILocation(line: 157, column: 2, scope: !206)
!226 = !DILocation(line: 158, column: 1, scope: !206)
!227 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 73, type: !228, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !82)
!228 = !DISubroutineType(types: !229)
!229 = !{!87}
!230 = !DILocalVariable(name: "threads", scope: !227, file: !3, line: 75, type: !231)
!231 = !DICompositeType(tag: DW_TAG_array_type, baseType: !232, size: 128, elements: !255)
!232 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !233, line: 31, baseType: !234)
!233 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!234 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !235, line: 118, baseType: !236)
!235 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!236 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !237, size: 64)
!237 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !235, line: 103, size: 65536, elements: !238)
!238 = !{!239, !241, !251}
!239 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !237, file: !235, line: 104, baseType: !240, size: 64)
!240 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!241 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !237, file: !235, line: 105, baseType: !242, size: 64, offset: 64)
!242 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !243, size: 64)
!243 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !235, line: 57, size: 192, elements: !244)
!244 = !{!245, !249, !250}
!245 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !243, file: !235, line: 58, baseType: !246, size: 64)
!246 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !247, size: 64)
!247 = !DISubroutineType(types: !248)
!248 = !{null, !5}
!249 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !243, file: !235, line: 59, baseType: !5, size: 64, offset: 64)
!250 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !243, file: !235, line: 60, baseType: !242, size: 64, offset: 128)
!251 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !237, file: !235, line: 106, baseType: !252, size: 65408, offset: 128)
!252 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 65408, elements: !253)
!253 = !{!254}
!254 = !DISubrange(count: 8176)
!255 = !{!256}
!256 = !DISubrange(count: 2)
!257 = !DILocation(line: 75, column: 15, scope: !227)
!258 = !DILocalVariable(name: "initial_entry", scope: !227, file: !3, line: 77, type: !117)
!259 = !DILocation(line: 77, column: 27, scope: !227)
!260 = !DILocation(line: 77, column: 43, scope: !227)
!261 = !DILocation(line: 78, column: 9, scope: !262)
!262 = distinct !DILexicalBlock(scope: !227, file: !3, line: 78, column: 9)
!263 = !DILocation(line: 78, column: 23, scope: !262)
!264 = !DILocation(line: 78, column: 9, scope: !227)
!265 = !DILocation(line: 80, column: 9, scope: !266)
!266 = distinct !DILexicalBlock(scope: !262, file: !3, line: 79, column: 5)
!267 = !DILocation(line: 82, column: 31, scope: !227)
!268 = !DILocation(line: 82, column: 5, scope: !227)
!269 = !DILocation(line: 84, column: 25, scope: !270)
!270 = distinct !DILexicalBlock(scope: !227, file: !3, line: 84, column: 9)
!271 = !DILocation(line: 84, column: 9, scope: !270)
!272 = !DILocation(line: 84, column: 59, scope: !270)
!273 = !DILocation(line: 84, column: 64, scope: !270)
!274 = !DILocation(line: 85, column: 25, scope: !270)
!275 = !DILocation(line: 85, column: 9, scope: !270)
!276 = !DILocation(line: 85, column: 59, scope: !270)
!277 = !DILocation(line: 84, column: 9, scope: !227)
!278 = !DILocation(line: 87, column: 9, scope: !279)
!279 = distinct !DILexicalBlock(scope: !270, file: !3, line: 86, column: 5)
!280 = !DILocalVariable(name: "i", scope: !281, file: !3, line: 90, type: !87)
!281 = distinct !DILexicalBlock(scope: !227, file: !3, line: 90, column: 5)
!282 = !DILocation(line: 90, column: 14, scope: !281)
!283 = !DILocation(line: 90, column: 10, scope: !281)
!284 = !DILocation(line: 90, column: 21, scope: !285)
!285 = distinct !DILexicalBlock(scope: !281, file: !3, line: 90, column: 5)
!286 = !DILocation(line: 90, column: 23, scope: !285)
!287 = !DILocation(line: 90, column: 5, scope: !281)
!288 = !DILocation(line: 92, column: 30, scope: !289)
!289 = distinct !DILexicalBlock(scope: !285, file: !3, line: 91, column: 5)
!290 = !DILocation(line: 92, column: 22, scope: !289)
!291 = !DILocation(line: 92, column: 9, scope: !289)
!292 = !DILocation(line: 93, column: 5, scope: !289)
!293 = !DILocation(line: 90, column: 36, scope: !285)
!294 = !DILocation(line: 90, column: 5, scope: !285)
!295 = distinct !{!295, !287, !296, !137}
!296 = !DILocation(line: 93, column: 5, scope: !281)
!297 = !DILocalVariable(name: "garbage", scope: !227, file: !3, line: 95, type: !117)
!298 = !DILocation(line: 95, column: 27, scope: !227)
!299 = !DILocation(line: 96, column: 5, scope: !227)
!300 = !DILocation(line: 97, column: 10, scope: !227)
!301 = !DILocation(line: 97, column: 5, scope: !227)
!302 = !DILocation(line: 99, column: 5, scope: !227)
!303 = distinct !DISubprogram(name: "ck_fifo_spsc_init", scope: !13, file: !13, line: 103, type: !304, scopeLine: 104, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !82)
!304 = !DISubroutineType(types: !305)
!305 = !{null, !153, !11}
!306 = !DILocalVariable(name: "fifo", arg: 1, scope: !303, file: !13, line: 103, type: !153)
!307 = !DILocation(line: 103, column: 40, scope: !303)
!308 = !DILocalVariable(name: "stub", arg: 2, scope: !303, file: !13, line: 103, type: !11)
!309 = !DILocation(line: 103, column: 73, scope: !303)
!310 = !DILocation(line: 106, column: 2, scope: !303)
!311 = !DILocation(line: 107, column: 2, scope: !303)
!312 = !DILocation(line: 109, column: 2, scope: !303)
!313 = !DILocation(line: 109, column: 8, scope: !303)
!314 = !DILocation(line: 109, column: 13, scope: !303)
!315 = !DILocation(line: 110, column: 66, scope: !303)
!316 = !DILocation(line: 110, column: 50, scope: !303)
!317 = !DILocation(line: 110, column: 56, scope: !303)
!318 = !DILocation(line: 110, column: 64, scope: !303)
!319 = !DILocation(line: 110, column: 28, scope: !303)
!320 = !DILocation(line: 110, column: 34, scope: !303)
!321 = !DILocation(line: 110, column: 48, scope: !303)
!322 = !DILocation(line: 110, column: 15, scope: !303)
!323 = !DILocation(line: 110, column: 21, scope: !303)
!324 = !DILocation(line: 110, column: 26, scope: !303)
!325 = !DILocation(line: 110, column: 2, scope: !303)
!326 = !DILocation(line: 110, column: 8, scope: !303)
!327 = !DILocation(line: 110, column: 13, scope: !303)
!328 = !DILocation(line: 111, column: 2, scope: !303)
!329 = distinct !DISubprogram(name: "ck_fifo_spsc_deinit", scope: !13, file: !13, line: 115, type: !330, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !82)
!330 = !DISubroutineType(types: !331)
!331 = !{null, !153, !332}
!332 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!333 = !DILocalVariable(name: "fifo", arg: 1, scope: !329, file: !13, line: 115, type: !153)
!334 = !DILocation(line: 115, column: 42, scope: !329)
!335 = !DILocalVariable(name: "garbage", arg: 2, scope: !329, file: !13, line: 115, type: !332)
!336 = !DILocation(line: 115, column: 76, scope: !329)
!337 = !DILocation(line: 118, column: 13, scope: !329)
!338 = !DILocation(line: 118, column: 19, scope: !329)
!339 = !DILocation(line: 118, column: 3, scope: !329)
!340 = !DILocation(line: 118, column: 11, scope: !329)
!341 = !DILocation(line: 119, column: 15, scope: !329)
!342 = !DILocation(line: 119, column: 21, scope: !329)
!343 = !DILocation(line: 119, column: 26, scope: !329)
!344 = !DILocation(line: 119, column: 2, scope: !329)
!345 = !DILocation(line: 119, column: 8, scope: !329)
!346 = !DILocation(line: 119, column: 13, scope: !329)
!347 = !DILocation(line: 120, column: 2, scope: !329)
!348 = distinct !DISubprogram(name: "ck_pr_fence_store", scope: !349, file: !349, line: 113, type: !350, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!349 = !DIFile(filename: "include/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "cffbc3bc631aa31cdde49d8ca6470a32")
!350 = !DISubroutineType(types: !351)
!351 = !{null}
!352 = !DILocation(line: 113, column: 1, scope: !348)
!353 = distinct !DISubprogram(name: "ck_pr_md_store_ptr", scope: !354, file: !354, line: 135, type: !355, scopeLine: 135, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !82)
!354 = !DIFile(filename: "include/gcc/ppc64/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "1c5aecf7376064f28c732d8a93471464")
!355 = !DISubroutineType(types: !356)
!356 = !{null, !5, !357}
!357 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !358, size: 64)
!358 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!359 = !DILocalVariable(name: "target", arg: 1, scope: !353, file: !354, line: 135, type: !5)
!360 = !DILocation(line: 135, column: 1, scope: !353)
!361 = !DILocalVariable(name: "v", arg: 2, scope: !353, file: !354, line: 135, type: !357)
!362 = !{i64 2148668126}
!363 = distinct !DISubprogram(name: "ck_pr_fence_strict_store", scope: !354, file: !354, line: 80, type: !350, scopeLine: 80, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!364 = !DILocation(line: 80, column: 1, scope: !363)
!365 = !{i64 2148662164}
!366 = distinct !DISubprogram(name: "ck_pr_md_load_ptr", scope: !354, file: !354, line: 105, type: !367, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !82)
!367 = !DISubroutineType(types: !368)
!368 = !{!5, !357}
!369 = !DILocalVariable(name: "target", arg: 1, scope: !366, file: !354, line: 105, type: !357)
!370 = !DILocation(line: 105, column: 1, scope: !366)
!371 = !DILocalVariable(name: "r", scope: !366, file: !354, line: 105, type: !5)
!372 = !{i64 2148664294}
!373 = distinct !DISubprogram(name: "ck_spinlock_fas_init", scope: !57, file: !57, line: 47, type: !374, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !82)
!374 = !DISubroutineType(types: !375)
!375 = !{null, !376}
!376 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!377 = !DILocalVariable(name: "lock", arg: 1, scope: !373, file: !57, line: 47, type: !376)
!378 = !DILocation(line: 47, column: 46, scope: !373)
!379 = !DILocation(line: 50, column: 2, scope: !373)
!380 = !DILocation(line: 50, column: 8, scope: !373)
!381 = !DILocation(line: 50, column: 14, scope: !373)
!382 = !DILocation(line: 51, column: 2, scope: !373)
!383 = !DILocation(line: 52, column: 2, scope: !373)
!384 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !385, file: !385, line: 37, type: !350, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!385 = !DIFile(filename: "include/gcc/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!386 = !DILocation(line: 40, column: 2, scope: !384)
!387 = !{i64 1221034}
!388 = !DILocation(line: 41, column: 2, scope: !384)
