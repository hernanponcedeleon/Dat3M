; ModuleID = 'benchmarks/ck/spsc_queue.c'
source_filename = "benchmarks/ck/spsc_queue.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv8a-pc-linux-gnu"

%struct.ck_fifo_spsc = type { %struct.ck_spinlock_fas, ptr, [56 x i8], %struct.ck_spinlock_fas, ptr, ptr, ptr }
%struct.ck_spinlock_fas = type { i32 }
%struct.point_s = type { i32, i32 }
%struct.ck_fifo_spsc_entry = type { ptr, ptr }

@queue = dso_local global %struct.ck_fifo_spsc zeroinitializer, align 4, !dbg !0
@.str = private unnamed_addr constant [20 x i8] c"NULL point received\00", align 1, !dbg !18
@.str.1 = private unnamed_addr constant [39 x i8] c"point != NULL && \22NULL point received\22\00", align 1, !dbg !24
@.str.2 = private unnamed_addr constant [27 x i8] c"benchmarks/ck/spsc_queue.c\00", align 1, !dbg !29
@__func__.consumer = private unnamed_addr constant [9 x i8] c"consumer\00", align 1, !dbg !34
@.str.3 = private unnamed_addr constant [21 x i8] c"point->x == point->y\00", align 1, !dbg !40
@.str.4 = private unnamed_addr constant [14 x i8] c"point->y == 1\00", align 1, !dbg !45

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc ptr @producer(ptr noundef %0) #0 !dbg !77 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !81, !DIExpression(), !82)
    #dbg_declare(ptr %3, !83, !DIExpression(), !85)
  store i32 0, ptr %3, align 4, !dbg !85
  br label %7, !dbg !86

7:                                                ; preds = %28, %1
  %8 = load i32, ptr %3, align 4, !dbg !87
  %9 = icmp slt i32 %8, 3, !dbg !89
  br i1 %9, label %10, label %31, !dbg !90

10:                                               ; preds = %7
    #dbg_declare(ptr %4, !91, !DIExpression(), !99)
  %11 = call arm_aapcscc ptr @malloc(i32 noundef 8) #4, !dbg !100
  store ptr %11, ptr %4, align 4, !dbg !99
  %12 = load ptr, ptr %4, align 4, !dbg !101
  %13 = icmp eq ptr %12, null, !dbg !103
  br i1 %13, label %14, label %15, !dbg !103

14:                                               ; preds = %10
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !104
  unreachable, !dbg !104

15:                                               ; preds = %10
  %16 = load ptr, ptr %4, align 4, !dbg !106
  %17 = getelementptr inbounds nuw %struct.point_s, ptr %16, i32 0, i32 0, !dbg !107
  store i32 1, ptr %17, align 4, !dbg !108
  %18 = load ptr, ptr %4, align 4, !dbg !109
  %19 = getelementptr inbounds nuw %struct.point_s, ptr %18, i32 0, i32 1, !dbg !110
  store i32 1, ptr %19, align 4, !dbg !111
    #dbg_declare(ptr %5, !112, !DIExpression(), !115)
  %20 = call arm_aapcscc ptr @malloc(i32 noundef 8) #4, !dbg !116
  store ptr %20, ptr %5, align 4, !dbg !115
  %21 = load ptr, ptr %5, align 4, !dbg !117
  %22 = icmp eq ptr %21, null, !dbg !119
  br i1 %22, label %23, label %25, !dbg !119

23:                                               ; preds = %15
  %24 = load ptr, ptr %4, align 4, !dbg !120
  call arm_aapcscc void @free(ptr noundef %24), !dbg !122
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !123
  unreachable, !dbg !123

25:                                               ; preds = %15
  %26 = load ptr, ptr %5, align 4, !dbg !124
  %27 = load ptr, ptr %4, align 4, !dbg !125
  call arm_aapcscc void @ck_fifo_spsc_enqueue(ptr noundef @queue, ptr noundef %26, ptr noundef %27), !dbg !126
  br label %28, !dbg !127

28:                                               ; preds = %25
  %29 = load i32, ptr %3, align 4, !dbg !128
  %30 = add nsw i32 %29, 1, !dbg !128
  store i32 %30, ptr %3, align 4, !dbg !128
  br label %7, !dbg !129, !llvm.loop !130

31:                                               ; preds = %7
    #dbg_declare(ptr %6, !133, !DIExpression(), !134)
  %32 = call arm_aapcscc ptr @malloc(i32 noundef 8) #4, !dbg !135
  store ptr %32, ptr %6, align 4, !dbg !134
  %33 = load ptr, ptr %6, align 4, !dbg !136
  %34 = icmp eq ptr %33, null, !dbg !138
  br i1 %34, label %35, label %36, !dbg !138

35:                                               ; preds = %31
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !139
  unreachable, !dbg !139

36:                                               ; preds = %31
  %37 = load ptr, ptr %6, align 4, !dbg !141
  call arm_aapcscc void @ck_fifo_spsc_enqueue(ptr noundef @queue, ptr noundef %37, ptr noundef null), !dbg !142
  ret ptr null, !dbg !143
}

; Function Attrs: allocsize(0)
declare arm_aapcscc ptr @malloc(i32 noundef) #1

; Function Attrs: noreturn
declare arm_aapcscc void @exit(i32 noundef) #2

declare arm_aapcscc void @free(ptr noundef) #3

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_fifo_spsc_enqueue(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 !dbg !144 {
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  store ptr %0, ptr %4, align 4
    #dbg_declare(ptr %4, !148, !DIExpression(), !149)
  store ptr %1, ptr %5, align 4
    #dbg_declare(ptr %5, !150, !DIExpression(), !151)
  store ptr %2, ptr %6, align 4
    #dbg_declare(ptr %6, !152, !DIExpression(), !153)
  %7 = load ptr, ptr %6, align 4, !dbg !154
  %8 = load ptr, ptr %5, align 4, !dbg !155
  %9 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %8, i32 0, i32 0, !dbg !156
  store ptr %7, ptr %9, align 4, !dbg !157
  %10 = load ptr, ptr %5, align 4, !dbg !158
  %11 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %10, i32 0, i32 1, !dbg !159
  store ptr null, ptr %11, align 4, !dbg !160
  call arm_aapcscc void @ck_pr_fence_store(), !dbg !161
  %12 = load ptr, ptr %4, align 4, !dbg !162
  %13 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %12, i32 0, i32 4, !dbg !163
  %14 = load ptr, ptr %13, align 4, !dbg !163
  %15 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %14, i32 0, i32 1, !dbg !164
  %16 = load ptr, ptr %5, align 4, !dbg !165
  call arm_aapcscc void @ck_pr_md_store_ptr(ptr noundef %15, ptr noundef %16), !dbg !166
  %17 = load ptr, ptr %5, align 4, !dbg !167
  %18 = load ptr, ptr %4, align 4, !dbg !168
  %19 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %18, i32 0, i32 4, !dbg !169
  store ptr %17, ptr %19, align 4, !dbg !170
  ret void, !dbg !171
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc ptr @consumer(ptr noundef %0) #0 !dbg !172 {
  %2 = alloca ptr, align 4
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !173, !DIExpression(), !174)
    #dbg_declare(ptr %3, !175, !DIExpression(), !176)
    #dbg_declare(ptr %4, !177, !DIExpression(), !179)
  store i32 0, ptr %4, align 4, !dbg !179
  br label %6, !dbg !180

6:                                                ; preds = %36, %1
  %7 = load i32, ptr %4, align 4, !dbg !181
  %8 = icmp slt i32 %7, 3, !dbg !183
  br i1 %8, label %9, label %39, !dbg !184

9:                                                ; preds = %6
    #dbg_declare(ptr %5, !185, !DIExpression(), !187)
  %10 = call arm_aapcscc zeroext i1 @ck_fifo_spsc_dequeue(ptr noundef @queue, ptr noundef %3), !dbg !188
  %11 = zext i1 %10 to i8, !dbg !187
  store i8 %11, ptr %5, align 1, !dbg !187
  %12 = load i8, ptr %5, align 1, !dbg !189
  %13 = trunc i8 %12 to i1, !dbg !189
  %14 = zext i1 %13 to i32, !dbg !189
  call arm_aapcscc void @__VERIFIER_assume(i32 noundef %14), !dbg !190
  %15 = load ptr, ptr %3, align 4, !dbg !191
  %16 = icmp ne ptr %15, null, !dbg !194
  br i1 %16, label %17, label %18, !dbg !195

17:                                               ; preds = %9
  br i1 true, label %19, label %18, !dbg !196

18:                                               ; preds = %17, %9
  call arm_aapcscc void @__assert_fail(ptr noundef @.str.1, ptr noundef @.str.2, i32 noundef 63, ptr noundef @__func__.consumer), !dbg !196
  br label %19, !dbg !196

19:                                               ; preds = %18, %17
  %20 = load ptr, ptr %3, align 4, !dbg !197
  %21 = getelementptr inbounds nuw %struct.point_s, ptr %20, i32 0, i32 0, !dbg !200
  %22 = load i32, ptr %21, align 4, !dbg !200
  %23 = load ptr, ptr %3, align 4, !dbg !201
  %24 = getelementptr inbounds nuw %struct.point_s, ptr %23, i32 0, i32 1, !dbg !202
  %25 = load i32, ptr %24, align 4, !dbg !202
  %26 = icmp eq i32 %22, %25, !dbg !203
  br i1 %26, label %28, label %27, !dbg !204

27:                                               ; preds = %19
  call arm_aapcscc void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.2, i32 noundef 64, ptr noundef @__func__.consumer), !dbg !204
  br label %28, !dbg !204

28:                                               ; preds = %27, %19
  %29 = load ptr, ptr %3, align 4, !dbg !205
  %30 = getelementptr inbounds nuw %struct.point_s, ptr %29, i32 0, i32 1, !dbg !208
  %31 = load i32, ptr %30, align 4, !dbg !208
  %32 = icmp eq i32 %31, 1, !dbg !209
  br i1 %32, label %34, label %33, !dbg !210

33:                                               ; preds = %28
  call arm_aapcscc void @__assert_fail(ptr noundef @.str.4, ptr noundef @.str.2, i32 noundef 65, ptr noundef @__func__.consumer), !dbg !210
  br label %34, !dbg !210

34:                                               ; preds = %33, %28
  %35 = load ptr, ptr %3, align 4, !dbg !211
  call arm_aapcscc void @free(ptr noundef %35), !dbg !212
  br label %36, !dbg !213

36:                                               ; preds = %34
  %37 = load i32, ptr %4, align 4, !dbg !214
  %38 = add nsw i32 %37, 1, !dbg !214
  store i32 %38, ptr %4, align 4, !dbg !214
  br label %6, !dbg !215, !llvm.loop !216

39:                                               ; preds = %6
  ret ptr null, !dbg !218
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc zeroext i1 @ck_fifo_spsc_dequeue(ptr noundef %0, ptr noundef %1) #0 !dbg !219 {
  %3 = alloca i1, align 1
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  store ptr %0, ptr %4, align 4
    #dbg_declare(ptr %4, !222, !DIExpression(), !223)
  store ptr %1, ptr %5, align 4
    #dbg_declare(ptr %5, !224, !DIExpression(), !225)
    #dbg_declare(ptr %6, !226, !DIExpression(), !227)
  %7 = load ptr, ptr %4, align 4, !dbg !228
  %8 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %7, i32 0, i32 1, !dbg !229
  %9 = load ptr, ptr %8, align 4, !dbg !229
  %10 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %9, i32 0, i32 1, !dbg !230
  %11 = call arm_aapcscc ptr @ck_pr_md_load_ptr(ptr noundef %10), !dbg !231
  store ptr %11, ptr %6, align 4, !dbg !232
  %12 = load ptr, ptr %6, align 4, !dbg !233
  %13 = icmp eq ptr %12, null, !dbg !235
  br i1 %13, label %14, label %15, !dbg !235

14:                                               ; preds = %2
  store i1 false, ptr %3, align 1, !dbg !236
  br label %23, !dbg !236

15:                                               ; preds = %2
  %16 = load ptr, ptr %5, align 4, !dbg !237
  %17 = load ptr, ptr %6, align 4, !dbg !238
  %18 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %17, i32 0, i32 0, !dbg !239
  %19 = load ptr, ptr %18, align 4, !dbg !239
  call arm_aapcscc void @ck_pr_md_store_ptr(ptr noundef %16, ptr noundef %19), !dbg !240
  call arm_aapcscc void @ck_pr_fence_store(), !dbg !241
  %20 = load ptr, ptr %4, align 4, !dbg !242
  %21 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %20, i32 0, i32 1, !dbg !243
  %22 = load ptr, ptr %6, align 4, !dbg !244
  call arm_aapcscc void @ck_pr_md_store_ptr(ptr noundef %21, ptr noundef %22), !dbg !245
  store i1 true, ptr %3, align 1, !dbg !246
  br label %23, !dbg !246

23:                                               ; preds = %15, %14
  %24 = load i1, ptr %3, align 1, !dbg !247
  ret i1 %24, !dbg !247
}

declare arm_aapcscc void @__VERIFIER_assume(i32 noundef) #3

declare arm_aapcscc void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc i32 @main() #0 !dbg !248 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 4
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !251, !DIExpression(), !257)
    #dbg_declare(ptr %3, !258, !DIExpression(), !259)
  %6 = call arm_aapcscc ptr @malloc(i32 noundef 8) #4, !dbg !260
  store ptr %6, ptr %3, align 4, !dbg !259
  %7 = load ptr, ptr %3, align 4, !dbg !261
  %8 = icmp eq ptr %7, null, !dbg !263
  br i1 %8, label %9, label %10, !dbg !263

9:                                                ; preds = %0
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !264
  unreachable, !dbg !264

10:                                               ; preds = %0
  %11 = load ptr, ptr %3, align 4, !dbg !266
  call arm_aapcscc void @ck_fifo_spsc_init(ptr noundef @queue, ptr noundef %11), !dbg !267
  %12 = getelementptr inbounds [2 x ptr], ptr %2, i32 0, i32 0, !dbg !268
  %13 = call arm_aapcscc i32 @pthread_create(ptr noundef %12, ptr noundef null, ptr noundef @producer, ptr noundef null), !dbg !270
  %14 = icmp ne i32 %13, 0, !dbg !271
  br i1 %14, label %19, label %15, !dbg !272

15:                                               ; preds = %10
  %16 = getelementptr inbounds [2 x ptr], ptr %2, i32 0, i32 1, !dbg !273
  %17 = call arm_aapcscc i32 @pthread_create(ptr noundef %16, ptr noundef null, ptr noundef @consumer, ptr noundef null), !dbg !274
  %18 = icmp ne i32 %17, 0, !dbg !275
  br i1 %18, label %19, label %20, !dbg !272

19:                                               ; preds = %15, %10
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !276
  unreachable, !dbg !276

20:                                               ; preds = %15
    #dbg_declare(ptr %4, !278, !DIExpression(), !280)
  store i32 0, ptr %4, align 4, !dbg !280
  br label %21, !dbg !281

21:                                               ; preds = %29, %20
  %22 = load i32, ptr %4, align 4, !dbg !282
  %23 = icmp slt i32 %22, 2, !dbg !284
  br i1 %23, label %24, label %32, !dbg !285

24:                                               ; preds = %21
  %25 = load i32, ptr %4, align 4, !dbg !286
  %26 = getelementptr inbounds [2 x ptr], ptr %2, i32 0, i32 %25, !dbg !288
  %27 = load ptr, ptr %26, align 4, !dbg !288
  %28 = call arm_aapcscc i32 @pthread_join(ptr noundef %27, ptr noundef null), !dbg !289
  br label %29, !dbg !290

29:                                               ; preds = %24
  %30 = load i32, ptr %4, align 4, !dbg !291
  %31 = add nsw i32 %30, 1, !dbg !291
  store i32 %31, ptr %4, align 4, !dbg !291
  br label %21, !dbg !292, !llvm.loop !293

32:                                               ; preds = %21
    #dbg_declare(ptr %5, !295, !DIExpression(), !296)
  call arm_aapcscc void @ck_fifo_spsc_deinit(ptr noundef @queue, ptr noundef %5), !dbg !297
  %33 = load ptr, ptr %5, align 4, !dbg !298
  call arm_aapcscc void @free(ptr noundef %33), !dbg !299
  ret i32 0, !dbg !300
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_fifo_spsc_init(ptr noundef %0, ptr noundef %1) #0 !dbg !301 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !304, !DIExpression(), !305)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !306, !DIExpression(), !307)
  %5 = load ptr, ptr %3, align 4, !dbg !308
  %6 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %5, i32 0, i32 0, !dbg !309
  call arm_aapcscc void @ck_spinlock_fas_init(ptr noundef %6), !dbg !310
  %7 = load ptr, ptr %3, align 4, !dbg !311
  %8 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %7, i32 0, i32 3, !dbg !312
  call arm_aapcscc void @ck_spinlock_fas_init(ptr noundef %8), !dbg !313
  %9 = load ptr, ptr %4, align 4, !dbg !314
  %10 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %9, i32 0, i32 1, !dbg !315
  store ptr null, ptr %10, align 4, !dbg !316
  %11 = load ptr, ptr %4, align 4, !dbg !317
  %12 = load ptr, ptr %3, align 4, !dbg !318
  %13 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %12, i32 0, i32 6, !dbg !319
  store ptr %11, ptr %13, align 4, !dbg !320
  %14 = load ptr, ptr %3, align 4, !dbg !321
  %15 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %14, i32 0, i32 5, !dbg !322
  store ptr %11, ptr %15, align 4, !dbg !323
  %16 = load ptr, ptr %3, align 4, !dbg !324
  %17 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %16, i32 0, i32 4, !dbg !325
  store ptr %11, ptr %17, align 4, !dbg !326
  %18 = load ptr, ptr %3, align 4, !dbg !327
  %19 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %18, i32 0, i32 1, !dbg !328
  store ptr %11, ptr %19, align 4, !dbg !329
  ret void, !dbg !330
}

declare arm_aapcscc i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare arm_aapcscc i32 @pthread_join(ptr noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_fifo_spsc_deinit(ptr noundef %0, ptr noundef %1) #0 !dbg !331 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !335, !DIExpression(), !336)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !337, !DIExpression(), !338)
  %5 = load ptr, ptr %3, align 4, !dbg !339
  %6 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %5, i32 0, i32 6, !dbg !340
  %7 = load ptr, ptr %6, align 4, !dbg !340
  %8 = load ptr, ptr %4, align 4, !dbg !341
  store ptr %7, ptr %8, align 4, !dbg !342
  %9 = load ptr, ptr %3, align 4, !dbg !343
  %10 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %9, i32 0, i32 4, !dbg !344
  store ptr null, ptr %10, align 4, !dbg !345
  %11 = load ptr, ptr %3, align 4, !dbg !346
  %12 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %11, i32 0, i32 1, !dbg !347
  store ptr null, ptr %12, align 4, !dbg !348
  ret void, !dbg !349
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_store() #0 !dbg !350 {
  call arm_aapcscc void @ck_pr_fence_strict_store(), !dbg !354
  ret void, !dbg !354
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_md_store_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !355 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !361, !DIExpression(), !362)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !363, !DIExpression(), !362)
  %5 = load ptr, ptr %3, align 4, !dbg !362
  %6 = load ptr, ptr %4, align 4, !dbg !362
  call void asm sideeffect "str $1, [$0]", "r,r,~{memory}"(ptr %5, ptr %6) #6, !dbg !362, !srcloc !364
  ret void, !dbg !362
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_store() #0 !dbg !365 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #6, !dbg !366, !srcloc !367
  ret void, !dbg !368
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 !dbg !369 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !372, !DIExpression(), !373)
    #dbg_declare(ptr %3, !374, !DIExpression(), !373)
  store i32 0, ptr %3, align 4, !dbg !373
  %4 = load ptr, ptr %2, align 4, !dbg !373
  %5 = call i32 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #6, !dbg !373, !srcloc !376
  store i32 %5, ptr %3, align 4, !dbg !373
  %6 = load i32, ptr %3, align 4, !dbg !373
  %7 = inttoptr i32 %6 to ptr, !dbg !373
  ret ptr %7, !dbg !373
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_fas_init(ptr noundef %0) #0 !dbg !377 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !381, !DIExpression(), !382)
  %3 = load ptr, ptr %2, align 4, !dbg !383
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_fas, ptr %3, i32 0, i32 0, !dbg !384
  store i32 0, ptr %4, align 4, !dbg !385
  call arm_aapcscc void @ck_pr_barrier(), !dbg !386
  ret void, !dbg !387
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_barrier() #0 !dbg !388 {
  call void asm sideeffect "", "~{memory}"() #6, !dbg !390, !srcloc !391
  ret void, !dbg !392
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #4 = { allocsize(0) }
attributes #5 = { noreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!69, !70, !71, !72, !73, !74, !75}
!llvm.ident = !{!76}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "queue", scope: !2, file: !3, line: 21, type: !50, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/spsc_queue.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "7bec67ad4368bbed4d80bc0489a6ba84")
!4 = !{!5, !6, !7, !8, !14}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 32)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 32)
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_fifo_spsc_entry", file: !10, line: 39, size: 64, elements: !11)
!10 = !DIFile(filename: "../ck/include/ck_fifo.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "252298fd696ccc816ddf53f92a49d2df")
!11 = !{!12, !13}
!12 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !9, file: !10, line: 40, baseType: !5, size: 32)
!13 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !9, file: !10, line: 41, baseType: !8, size: 32, offset: 32)
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !15, line: 4, baseType: !16)
!15 = !DIFile(filename: "include/libc/stdbool.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6e643322591bab80343344357c642cba")
!16 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!17 = !{!18, !24, !29, !34, !40, !45, !0}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 160, elements: !22)
!21 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!22 = !{!23}
!23 = !DISubrange(count: 20)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !26, isLocal: true, isDefinition: true)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 312, elements: !27)
!27 = !{!28}
!28 = !DISubrange(count: 39)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 216, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 27)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !37, size: 72, elements: !38)
!37 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !21)
!38 = !{!39}
!39 = !DISubrange(count: 9)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(scope: null, file: !3, line: 64, type: !42, isLocal: true, isDefinition: true)
!42 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 168, elements: !43)
!43 = !{!44}
!44 = !DISubrange(count: 21)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(scope: null, file: !3, line: 65, type: !47, isLocal: true, isDefinition: true)
!47 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 112, elements: !48)
!48 = !{!49}
!49 = !DISubrange(count: 14)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_fifo_spsc_t", file: !10, line: 54, baseType: !51)
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_fifo_spsc", file: !10, line: 45, size: 640, elements: !52)
!52 = !{!53, !60, !61, !65, !66, !67, !68}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "m_head", scope: !51, file: !10, line: 46, baseType: !54, size: 32)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_fas_t", file: !55, line: 42, baseType: !56)
!55 = !DIFile(filename: "../ck/include/spinlock/fas.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "999805093e3ea65ae15690fa7c76e04b")
!56 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_fas", file: !55, line: 39, size: 32, elements: !57)
!57 = !{!58}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !56, file: !55, line: 40, baseType: !59, size: 32)
!59 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !51, file: !10, line: 47, baseType: !8, size: 32, offset: 32)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !51, file: !10, line: 48, baseType: !62, size: 448, offset: 64)
!62 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 448, elements: !63)
!63 = !{!64}
!64 = !DISubrange(count: 56)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "m_tail", scope: !51, file: !10, line: 49, baseType: !54, size: 32, offset: 512)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !51, file: !10, line: 50, baseType: !8, size: 32, offset: 544)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "head_snapshot", scope: !51, file: !10, line: 51, baseType: !8, size: 32, offset: 576)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "garbage", scope: !51, file: !10, line: 52, baseType: !8, size: 32, offset: 608)
!69 = !{i32 7, !"Dwarf Version", i32 5}
!70 = !{i32 2, !"Debug Info Version", i32 3}
!71 = !{i32 1, !"wchar_size", i32 4}
!72 = !{i32 1, !"min_enum_size", i32 4}
!73 = !{i32 8, !"PIC Level", i32 2}
!74 = !{i32 7, !"PIE Level", i32 2}
!75 = !{i32 7, !"frame-pointer", i32 2}
!76 = !{!"Homebrew clang version 22.1.8"}
!77 = distinct !DISubprogram(name: "producer", scope: !3, file: !3, line: 23, type: !78, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !80)
!78 = !DISubroutineType(types: !79)
!79 = !{!5, !5}
!80 = !{}
!81 = !DILocalVariable(name: "arg", arg: 1, scope: !77, file: !3, line: 23, type: !5)
!82 = !DILocation(line: 23, column: 22, scope: !77)
!83 = !DILocalVariable(name: "i", scope: !84, file: !3, line: 25, type: !6)
!84 = distinct !DILexicalBlock(scope: !77, file: !3, line: 25, column: 5)
!85 = !DILocation(line: 25, column: 14, scope: !84)
!86 = !DILocation(line: 25, column: 10, scope: !84)
!87 = !DILocation(line: 25, column: 21, scope: !88)
!88 = distinct !DILexicalBlock(scope: !84, file: !3, line: 25, column: 5)
!89 = !DILocation(line: 25, column: 23, scope: !88)
!90 = !DILocation(line: 25, column: 5, scope: !84)
!91 = !DILocalVariable(name: "point", scope: !92, file: !3, line: 27, type: !93)
!92 = distinct !DILexicalBlock(scope: !88, file: !3, line: 26, column: 5)
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 32)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "point_t", file: !3, line: 19, baseType: !95)
!95 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "point_s", file: !3, line: 15, size: 64, elements: !96)
!96 = !{!97, !98}
!97 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !95, file: !3, line: 17, baseType: !59, size: 32)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !95, file: !3, line: 18, baseType: !59, size: 32, offset: 32)
!99 = !DILocation(line: 27, column: 18, scope: !92)
!100 = !DILocation(line: 27, column: 26, scope: !92)
!101 = !DILocation(line: 28, column: 13, scope: !102)
!102 = distinct !DILexicalBlock(scope: !92, file: !3, line: 28, column: 13)
!103 = !DILocation(line: 28, column: 19, scope: !102)
!104 = !DILocation(line: 30, column: 13, scope: !105)
!105 = distinct !DILexicalBlock(scope: !102, file: !3, line: 29, column: 9)
!106 = !DILocation(line: 33, column: 9, scope: !92)
!107 = !DILocation(line: 33, column: 16, scope: !92)
!108 = !DILocation(line: 33, column: 18, scope: !92)
!109 = !DILocation(line: 34, column: 9, scope: !92)
!110 = !DILocation(line: 34, column: 16, scope: !92)
!111 = !DILocation(line: 34, column: 18, scope: !92)
!112 = !DILocalVariable(name: "entry", scope: !92, file: !3, line: 36, type: !113)
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 32)
!114 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_fifo_spsc_entry_t", file: !10, line: 43, baseType: !9)
!115 = !DILocation(line: 36, column: 31, scope: !92)
!116 = !DILocation(line: 36, column: 39, scope: !92)
!117 = !DILocation(line: 37, column: 13, scope: !118)
!118 = distinct !DILexicalBlock(scope: !92, file: !3, line: 37, column: 13)
!119 = !DILocation(line: 37, column: 19, scope: !118)
!120 = !DILocation(line: 39, column: 18, scope: !121)
!121 = distinct !DILexicalBlock(scope: !118, file: !3, line: 38, column: 9)
!122 = !DILocation(line: 39, column: 13, scope: !121)
!123 = !DILocation(line: 40, column: 13, scope: !121)
!124 = !DILocation(line: 43, column: 38, scope: !92)
!125 = !DILocation(line: 43, column: 45, scope: !92)
!126 = !DILocation(line: 43, column: 9, scope: !92)
!127 = !DILocation(line: 44, column: 5, scope: !92)
!128 = !DILocation(line: 25, column: 45, scope: !88)
!129 = !DILocation(line: 25, column: 5, scope: !88)
!130 = distinct !{!130, !90, !131, !132}
!131 = !DILocation(line: 44, column: 5, scope: !84)
!132 = !{!"llvm.loop.mustprogress"}
!133 = !DILocalVariable(name: "entry", scope: !77, file: !3, line: 46, type: !113)
!134 = !DILocation(line: 46, column: 27, scope: !77)
!135 = !DILocation(line: 46, column: 35, scope: !77)
!136 = !DILocation(line: 47, column: 9, scope: !137)
!137 = distinct !DILexicalBlock(scope: !77, file: !3, line: 47, column: 9)
!138 = !DILocation(line: 47, column: 15, scope: !137)
!139 = !DILocation(line: 49, column: 9, scope: !140)
!140 = distinct !DILexicalBlock(scope: !137, file: !3, line: 48, column: 5)
!141 = !DILocation(line: 51, column: 34, scope: !77)
!142 = !DILocation(line: 51, column: 5, scope: !77)
!143 = !DILocation(line: 53, column: 5, scope: !77)
!144 = distinct !DISubprogram(name: "ck_fifo_spsc_enqueue", scope: !10, file: !10, line: 124, type: !145, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !80)
!145 = !DISubroutineType(types: !146)
!146 = !{null, !147, !8, !5}
!147 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 32)
!148 = !DILocalVariable(name: "fifo", arg: 1, scope: !144, file: !10, line: 124, type: !147)
!149 = !DILocation(line: 124, column: 43, scope: !144)
!150 = !DILocalVariable(name: "entry", arg: 2, scope: !144, file: !10, line: 125, type: !8)
!151 = !DILocation(line: 125, column: 35, scope: !144)
!152 = !DILocalVariable(name: "value", arg: 3, scope: !144, file: !10, line: 126, type: !5)
!153 = !DILocation(line: 126, column: 14, scope: !144)
!154 = !DILocation(line: 129, column: 17, scope: !144)
!155 = !DILocation(line: 129, column: 2, scope: !144)
!156 = !DILocation(line: 129, column: 9, scope: !144)
!157 = !DILocation(line: 129, column: 15, scope: !144)
!158 = !DILocation(line: 130, column: 2, scope: !144)
!159 = !DILocation(line: 130, column: 9, scope: !144)
!160 = !DILocation(line: 130, column: 14, scope: !144)
!161 = !DILocation(line: 133, column: 2, scope: !144)
!162 = !DILocation(line: 134, column: 19, scope: !144)
!163 = !DILocation(line: 134, column: 25, scope: !144)
!164 = !DILocation(line: 134, column: 31, scope: !144)
!165 = !DILocation(line: 134, column: 37, scope: !144)
!166 = !DILocation(line: 134, column: 2, scope: !144)
!167 = !DILocation(line: 135, column: 15, scope: !144)
!168 = !DILocation(line: 135, column: 2, scope: !144)
!169 = !DILocation(line: 135, column: 8, scope: !144)
!170 = !DILocation(line: 135, column: 13, scope: !144)
!171 = !DILocation(line: 136, column: 2, scope: !144)
!172 = distinct !DISubprogram(name: "consumer", scope: !3, file: !3, line: 55, type: !78, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !80)
!173 = !DILocalVariable(name: "arg", arg: 1, scope: !172, file: !3, line: 55, type: !5)
!174 = !DILocation(line: 55, column: 22, scope: !172)
!175 = !DILocalVariable(name: "point", scope: !172, file: !3, line: 57, type: !93)
!176 = !DILocation(line: 57, column: 14, scope: !172)
!177 = !DILocalVariable(name: "i", scope: !178, file: !3, line: 59, type: !6)
!178 = distinct !DILexicalBlock(scope: !172, file: !3, line: 59, column: 5)
!179 = !DILocation(line: 59, column: 14, scope: !178)
!180 = !DILocation(line: 59, column: 10, scope: !178)
!181 = !DILocation(line: 59, column: 21, scope: !182)
!182 = distinct !DILexicalBlock(scope: !178, file: !3, line: 59, column: 5)
!183 = !DILocation(line: 59, column: 23, scope: !182)
!184 = !DILocation(line: 59, column: 5, scope: !178)
!185 = !DILocalVariable(name: "res", scope: !186, file: !3, line: 61, type: !14)
!186 = distinct !DILexicalBlock(scope: !182, file: !3, line: 60, column: 5)
!187 = !DILocation(line: 61, column: 14, scope: !186)
!188 = !DILocation(line: 61, column: 20, scope: !186)
!189 = !DILocation(line: 62, column: 27, scope: !186)
!190 = !DILocation(line: 62, column: 9, scope: !186)
!191 = !DILocation(line: 63, column: 16, scope: !192)
!192 = distinct !DILexicalBlock(scope: !193, file: !3, line: 63, column: 9)
!193 = distinct !DILexicalBlock(scope: !186, file: !3, line: 63, column: 9)
!194 = !DILocation(line: 63, column: 22, scope: !192)
!195 = !DILocation(line: 63, column: 30, scope: !192)
!196 = !DILocation(line: 63, column: 9, scope: !192)
!197 = !DILocation(line: 64, column: 16, scope: !198)
!198 = distinct !DILexicalBlock(scope: !199, file: !3, line: 64, column: 9)
!199 = distinct !DILexicalBlock(scope: !186, file: !3, line: 64, column: 9)
!200 = !DILocation(line: 64, column: 23, scope: !198)
!201 = !DILocation(line: 64, column: 28, scope: !198)
!202 = !DILocation(line: 64, column: 35, scope: !198)
!203 = !DILocation(line: 64, column: 25, scope: !198)
!204 = !DILocation(line: 64, column: 9, scope: !198)
!205 = !DILocation(line: 65, column: 16, scope: !206)
!206 = distinct !DILexicalBlock(scope: !207, file: !3, line: 65, column: 9)
!207 = distinct !DILexicalBlock(scope: !186, file: !3, line: 65, column: 9)
!208 = !DILocation(line: 65, column: 23, scope: !206)
!209 = !DILocation(line: 65, column: 25, scope: !206)
!210 = !DILocation(line: 65, column: 9, scope: !206)
!211 = !DILocation(line: 67, column: 14, scope: !186)
!212 = !DILocation(line: 67, column: 9, scope: !186)
!213 = !DILocation(line: 68, column: 5, scope: !186)
!214 = !DILocation(line: 59, column: 45, scope: !182)
!215 = !DILocation(line: 59, column: 5, scope: !182)
!216 = distinct !{!216, !184, !217, !132}
!217 = !DILocation(line: 68, column: 5, scope: !178)
!218 = !DILocation(line: 70, column: 5, scope: !172)
!219 = distinct !DISubprogram(name: "ck_fifo_spsc_dequeue", scope: !10, file: !10, line: 140, type: !220, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !80)
!220 = !DISubroutineType(types: !221)
!221 = !{!14, !147, !5}
!222 = !DILocalVariable(name: "fifo", arg: 1, scope: !219, file: !10, line: 140, type: !147)
!223 = !DILocation(line: 140, column: 43, scope: !219)
!224 = !DILocalVariable(name: "value", arg: 2, scope: !219, file: !10, line: 140, type: !5)
!225 = !DILocation(line: 140, column: 55, scope: !219)
!226 = !DILocalVariable(name: "entry", scope: !219, file: !10, line: 142, type: !8)
!227 = !DILocation(line: 142, column: 29, scope: !219)
!228 = !DILocation(line: 149, column: 26, scope: !219)
!229 = !DILocation(line: 149, column: 32, scope: !219)
!230 = !DILocation(line: 149, column: 38, scope: !219)
!231 = !DILocation(line: 149, column: 10, scope: !219)
!232 = !DILocation(line: 149, column: 8, scope: !219)
!233 = !DILocation(line: 150, column: 6, scope: !234)
!234 = distinct !DILexicalBlock(scope: !219, file: !10, line: 150, column: 6)
!235 = !DILocation(line: 150, column: 12, scope: !234)
!236 = !DILocation(line: 151, column: 3, scope: !234)
!237 = !DILocation(line: 154, column: 25, scope: !219)
!238 = !DILocation(line: 154, column: 32, scope: !219)
!239 = !DILocation(line: 154, column: 39, scope: !219)
!240 = !DILocation(line: 154, column: 2, scope: !219)
!241 = !DILocation(line: 155, column: 2, scope: !219)
!242 = !DILocation(line: 156, column: 19, scope: !219)
!243 = !DILocation(line: 156, column: 25, scope: !219)
!244 = !DILocation(line: 156, column: 31, scope: !219)
!245 = !DILocation(line: 156, column: 2, scope: !219)
!246 = !DILocation(line: 157, column: 2, scope: !219)
!247 = !DILocation(line: 158, column: 1, scope: !219)
!248 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 73, type: !249, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !80)
!249 = !DISubroutineType(types: !250)
!250 = !{!6}
!251 = !DILocalVariable(name: "threads", scope: !248, file: !3, line: 75, type: !252)
!252 = !DICompositeType(tag: DW_TAG_array_type, baseType: !253, size: 64, elements: !255)
!253 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !254, line: 2, baseType: !5)
!254 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!255 = !{!256}
!256 = !DISubrange(count: 2)
!257 = !DILocation(line: 75, column: 15, scope: !248)
!258 = !DILocalVariable(name: "initial_entry", scope: !248, file: !3, line: 77, type: !113)
!259 = !DILocation(line: 77, column: 27, scope: !248)
!260 = !DILocation(line: 77, column: 43, scope: !248)
!261 = !DILocation(line: 78, column: 9, scope: !262)
!262 = distinct !DILexicalBlock(scope: !248, file: !3, line: 78, column: 9)
!263 = !DILocation(line: 78, column: 23, scope: !262)
!264 = !DILocation(line: 80, column: 9, scope: !265)
!265 = distinct !DILexicalBlock(scope: !262, file: !3, line: 79, column: 5)
!266 = !DILocation(line: 82, column: 31, scope: !248)
!267 = !DILocation(line: 82, column: 5, scope: !248)
!268 = !DILocation(line: 84, column: 25, scope: !269)
!269 = distinct !DILexicalBlock(scope: !248, file: !3, line: 84, column: 9)
!270 = !DILocation(line: 84, column: 9, scope: !269)
!271 = !DILocation(line: 84, column: 59, scope: !269)
!272 = !DILocation(line: 84, column: 64, scope: !269)
!273 = !DILocation(line: 85, column: 25, scope: !269)
!274 = !DILocation(line: 85, column: 9, scope: !269)
!275 = !DILocation(line: 85, column: 59, scope: !269)
!276 = !DILocation(line: 87, column: 9, scope: !277)
!277 = distinct !DILexicalBlock(scope: !269, file: !3, line: 86, column: 5)
!278 = !DILocalVariable(name: "i", scope: !279, file: !3, line: 90, type: !6)
!279 = distinct !DILexicalBlock(scope: !248, file: !3, line: 90, column: 5)
!280 = !DILocation(line: 90, column: 14, scope: !279)
!281 = !DILocation(line: 90, column: 10, scope: !279)
!282 = !DILocation(line: 90, column: 21, scope: !283)
!283 = distinct !DILexicalBlock(scope: !279, file: !3, line: 90, column: 5)
!284 = !DILocation(line: 90, column: 23, scope: !283)
!285 = !DILocation(line: 90, column: 5, scope: !279)
!286 = !DILocation(line: 92, column: 30, scope: !287)
!287 = distinct !DILexicalBlock(scope: !283, file: !3, line: 91, column: 5)
!288 = !DILocation(line: 92, column: 22, scope: !287)
!289 = !DILocation(line: 92, column: 9, scope: !287)
!290 = !DILocation(line: 93, column: 5, scope: !287)
!291 = !DILocation(line: 90, column: 36, scope: !283)
!292 = !DILocation(line: 90, column: 5, scope: !283)
!293 = distinct !{!293, !285, !294, !132}
!294 = !DILocation(line: 93, column: 5, scope: !279)
!295 = !DILocalVariable(name: "garbage", scope: !248, file: !3, line: 95, type: !113)
!296 = !DILocation(line: 95, column: 27, scope: !248)
!297 = !DILocation(line: 96, column: 5, scope: !248)
!298 = !DILocation(line: 97, column: 10, scope: !248)
!299 = !DILocation(line: 97, column: 5, scope: !248)
!300 = !DILocation(line: 99, column: 5, scope: !248)
!301 = distinct !DISubprogram(name: "ck_fifo_spsc_init", scope: !10, file: !10, line: 103, type: !302, scopeLine: 104, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !80)
!302 = !DISubroutineType(types: !303)
!303 = !{null, !147, !8}
!304 = !DILocalVariable(name: "fifo", arg: 1, scope: !301, file: !10, line: 103, type: !147)
!305 = !DILocation(line: 103, column: 40, scope: !301)
!306 = !DILocalVariable(name: "stub", arg: 2, scope: !301, file: !10, line: 103, type: !8)
!307 = !DILocation(line: 103, column: 73, scope: !301)
!308 = !DILocation(line: 106, column: 20, scope: !301)
!309 = !DILocation(line: 106, column: 26, scope: !301)
!310 = !DILocation(line: 106, column: 2, scope: !301)
!311 = !DILocation(line: 107, column: 20, scope: !301)
!312 = !DILocation(line: 107, column: 26, scope: !301)
!313 = !DILocation(line: 107, column: 2, scope: !301)
!314 = !DILocation(line: 109, column: 2, scope: !301)
!315 = !DILocation(line: 109, column: 8, scope: !301)
!316 = !DILocation(line: 109, column: 13, scope: !301)
!317 = !DILocation(line: 110, column: 66, scope: !301)
!318 = !DILocation(line: 110, column: 50, scope: !301)
!319 = !DILocation(line: 110, column: 56, scope: !301)
!320 = !DILocation(line: 110, column: 64, scope: !301)
!321 = !DILocation(line: 110, column: 28, scope: !301)
!322 = !DILocation(line: 110, column: 34, scope: !301)
!323 = !DILocation(line: 110, column: 48, scope: !301)
!324 = !DILocation(line: 110, column: 15, scope: !301)
!325 = !DILocation(line: 110, column: 21, scope: !301)
!326 = !DILocation(line: 110, column: 26, scope: !301)
!327 = !DILocation(line: 110, column: 2, scope: !301)
!328 = !DILocation(line: 110, column: 8, scope: !301)
!329 = !DILocation(line: 110, column: 13, scope: !301)
!330 = !DILocation(line: 111, column: 2, scope: !301)
!331 = distinct !DISubprogram(name: "ck_fifo_spsc_deinit", scope: !10, file: !10, line: 115, type: !332, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !80)
!332 = !DISubroutineType(types: !333)
!333 = !{null, !147, !334}
!334 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 32)
!335 = !DILocalVariable(name: "fifo", arg: 1, scope: !331, file: !10, line: 115, type: !147)
!336 = !DILocation(line: 115, column: 42, scope: !331)
!337 = !DILocalVariable(name: "garbage", arg: 2, scope: !331, file: !10, line: 115, type: !334)
!338 = !DILocation(line: 115, column: 76, scope: !331)
!339 = !DILocation(line: 118, column: 13, scope: !331)
!340 = !DILocation(line: 118, column: 19, scope: !331)
!341 = !DILocation(line: 118, column: 3, scope: !331)
!342 = !DILocation(line: 118, column: 11, scope: !331)
!343 = !DILocation(line: 119, column: 15, scope: !331)
!344 = !DILocation(line: 119, column: 21, scope: !331)
!345 = !DILocation(line: 119, column: 26, scope: !331)
!346 = !DILocation(line: 119, column: 2, scope: !331)
!347 = !DILocation(line: 119, column: 8, scope: !331)
!348 = !DILocation(line: 119, column: 13, scope: !331)
!349 = !DILocation(line: 120, column: 2, scope: !331)
!350 = distinct !DISubprogram(name: "ck_pr_fence_store", scope: !351, file: !351, line: 117, type: !352, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!351 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!352 = !DISubroutineType(types: !353)
!353 = !{null}
!354 = !DILocation(line: 117, column: 1, scope: !350)
!355 = distinct !DISubprogram(name: "ck_pr_md_store_ptr", scope: !356, file: !356, line: 169, type: !357, scopeLine: 169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !80)
!356 = !DIFile(filename: "../ck/include/gcc/arm/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f3f9fb174933d4f9d5af6678feea8d14")
!357 = !DISubroutineType(types: !358)
!358 = !{null, !5, !359}
!359 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !360, size: 32)
!360 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!361 = !DILocalVariable(name: "target", arg: 1, scope: !355, file: !356, line: 169, type: !5)
!362 = !DILocation(line: 169, column: 1, scope: !355)
!363 = !DILocalVariable(name: "v", arg: 2, scope: !355, file: !356, line: 169, type: !359)
!364 = !{i64 2147594548}
!365 = distinct !DISubprogram(name: "ck_pr_fence_strict_store", scope: !356, file: !356, line: 90, type: !352, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!366 = !DILocation(line: 90, column: 20, scope: !365)
!367 = !{i64 2147588548}
!368 = !DILocation(line: 90, column: 1, scope: !365)
!369 = distinct !DISubprogram(name: "ck_pr_md_load_ptr", scope: !356, file: !356, line: 120, type: !370, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !80)
!370 = !DISubroutineType(types: !371)
!371 = !{!5, !359}
!372 = !DILocalVariable(name: "target", arg: 1, scope: !369, file: !356, line: 120, type: !359)
!373 = !DILocation(line: 120, column: 1, scope: !369)
!374 = !DILocalVariable(name: "r", scope: !369, file: !356, line: 120, type: !375)
!375 = !DIBasicType(name: "long", size: 32, encoding: DW_ATE_signed)
!376 = !{i64 2147591594}
!377 = distinct !DISubprogram(name: "ck_spinlock_fas_init", scope: !55, file: !55, line: 47, type: !378, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !80)
!378 = !DISubroutineType(types: !379)
!379 = !{null, !380}
!380 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 32)
!381 = !DILocalVariable(name: "lock", arg: 1, scope: !377, file: !55, line: 47, type: !380)
!382 = !DILocation(line: 47, column: 46, scope: !377)
!383 = !DILocation(line: 50, column: 2, scope: !377)
!384 = !DILocation(line: 50, column: 8, scope: !377)
!385 = !DILocation(line: 50, column: 14, scope: !377)
!386 = !DILocation(line: 51, column: 2, scope: !377)
!387 = !DILocation(line: 52, column: 2, scope: !377)
!388 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !389, file: !389, line: 37, type: !352, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!389 = !DIFile(filename: "../ck/include/gcc/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!390 = !DILocation(line: 40, column: 2, scope: !388)
!391 = !{i64 181085}
!392 = !DILocation(line: 41, column: 2, scope: !388)
