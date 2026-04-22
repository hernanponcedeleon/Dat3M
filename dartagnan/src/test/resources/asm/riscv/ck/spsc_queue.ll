; ModuleID = 'benchmarks/ck/spsc_queue.c'
source_filename = "benchmarks/ck/spsc_queue.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "riscv64-pc-linux-gnu"

%struct.ck_fifo_spsc = type { %struct.ck_spinlock_fas, ptr, [52 x i8], %struct.ck_spinlock_fas, ptr, ptr, ptr }
%struct.ck_spinlock_fas = type { i32 }
%struct.point_s = type { i32, i32 }
%struct.ck_fifo_spsc_entry = type { ptr, ptr }

@queue = dso_local global %struct.ck_fifo_spsc zeroinitializer, align 8, !dbg !0
@.str = private unnamed_addr constant [20 x i8] c"NULL point received\00", align 1, !dbg !18
@.str.1 = private unnamed_addr constant [39 x i8] c"point != NULL && \22NULL point received\22\00", align 1, !dbg !24
@.str.2 = private unnamed_addr constant [27 x i8] c"benchmarks/ck/spsc_queue.c\00", align 1, !dbg !29
@__func__.consumer = private unnamed_addr constant [9 x i8] c"consumer\00", align 1, !dbg !34
@.str.3 = private unnamed_addr constant [21 x i8] c"point->x == point->y\00", align 1, !dbg !40
@.str.4 = private unnamed_addr constant [14 x i8] c"point->y == 1\00", align 1, !dbg !45

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @producer(ptr noundef %0) #0 !dbg !81 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !85, !DIExpression(), !86)
    #dbg_declare(ptr %3, !87, !DIExpression(), !89)
  store i32 0, ptr %3, align 4, !dbg !89
  br label %7, !dbg !90

7:                                                ; preds = %28, %1
  %8 = load i32, ptr %3, align 4, !dbg !91
  %9 = icmp slt i32 %8, 3, !dbg !93
  br i1 %9, label %10, label %31, !dbg !94

10:                                               ; preds = %7
    #dbg_declare(ptr %4, !95, !DIExpression(), !103)
  %11 = call ptr @malloc(i64 noundef 8) #4, !dbg !104
  store ptr %11, ptr %4, align 8, !dbg !103
  %12 = load ptr, ptr %4, align 8, !dbg !105
  %13 = icmp eq ptr %12, null, !dbg !107
  br i1 %13, label %14, label %15, !dbg !107

14:                                               ; preds = %10
  call void @exit(i32 noundef signext 1) #5, !dbg !108
  unreachable, !dbg !108

15:                                               ; preds = %10
  %16 = load ptr, ptr %4, align 8, !dbg !110
  %17 = getelementptr inbounds nuw %struct.point_s, ptr %16, i32 0, i32 0, !dbg !111
  store i32 1, ptr %17, align 4, !dbg !112
  %18 = load ptr, ptr %4, align 8, !dbg !113
  %19 = getelementptr inbounds nuw %struct.point_s, ptr %18, i32 0, i32 1, !dbg !114
  store i32 1, ptr %19, align 4, !dbg !115
    #dbg_declare(ptr %5, !116, !DIExpression(), !119)
  %20 = call ptr @malloc(i64 noundef 16) #4, !dbg !120
  store ptr %20, ptr %5, align 8, !dbg !119
  %21 = load ptr, ptr %5, align 8, !dbg !121
  %22 = icmp eq ptr %21, null, !dbg !123
  br i1 %22, label %23, label %25, !dbg !123

23:                                               ; preds = %15
  %24 = load ptr, ptr %4, align 8, !dbg !124
  call void @free(ptr noundef %24), !dbg !126
  call void @exit(i32 noundef signext 1) #5, !dbg !127
  unreachable, !dbg !127

25:                                               ; preds = %15
  %26 = load ptr, ptr %5, align 8, !dbg !128
  %27 = load ptr, ptr %4, align 8, !dbg !129
  call void @ck_fifo_spsc_enqueue(ptr noundef @queue, ptr noundef %26, ptr noundef %27), !dbg !130
  br label %28, !dbg !131

28:                                               ; preds = %25
  %29 = load i32, ptr %3, align 4, !dbg !132
  %30 = add nsw i32 %29, 1, !dbg !132
  store i32 %30, ptr %3, align 4, !dbg !132
  br label %7, !dbg !133, !llvm.loop !134

31:                                               ; preds = %7
    #dbg_declare(ptr %6, !137, !DIExpression(), !138)
  %32 = call ptr @malloc(i64 noundef 16) #4, !dbg !139
  store ptr %32, ptr %6, align 8, !dbg !138
  %33 = load ptr, ptr %6, align 8, !dbg !140
  %34 = icmp eq ptr %33, null, !dbg !142
  br i1 %34, label %35, label %36, !dbg !142

35:                                               ; preds = %31
  call void @exit(i32 noundef signext 1) #5, !dbg !143
  unreachable, !dbg !143

36:                                               ; preds = %31
  %37 = load ptr, ptr %6, align 8, !dbg !145
  call void @ck_fifo_spsc_enqueue(ptr noundef @queue, ptr noundef %37, ptr noundef null), !dbg !146
  ret ptr null, !dbg !147
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef signext) #2

declare void @free(ptr noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_fifo_spsc_enqueue(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 !dbg !148 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !152, !DIExpression(), !153)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !154, !DIExpression(), !155)
  store ptr %2, ptr %6, align 8
    #dbg_declare(ptr %6, !156, !DIExpression(), !157)
  %7 = load ptr, ptr %6, align 8, !dbg !158
  %8 = load ptr, ptr %5, align 8, !dbg !159
  %9 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %8, i32 0, i32 0, !dbg !160
  store ptr %7, ptr %9, align 8, !dbg !161
  %10 = load ptr, ptr %5, align 8, !dbg !162
  %11 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %10, i32 0, i32 1, !dbg !163
  store ptr null, ptr %11, align 8, !dbg !164
  call void @ck_pr_fence_store(), !dbg !165
  %12 = load ptr, ptr %4, align 8, !dbg !166
  %13 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %12, i32 0, i32 4, !dbg !167
  %14 = load ptr, ptr %13, align 8, !dbg !167
  %15 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %14, i32 0, i32 1, !dbg !168
  %16 = load ptr, ptr %5, align 8, !dbg !169
  call void @ck_pr_md_store_ptr(ptr noundef %15, ptr noundef %16), !dbg !170
  %17 = load ptr, ptr %5, align 8, !dbg !171
  %18 = load ptr, ptr %4, align 8, !dbg !172
  %19 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %18, i32 0, i32 4, !dbg !173
  store ptr %17, ptr %19, align 8, !dbg !174
  ret void, !dbg !175
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @consumer(ptr noundef %0) #0 !dbg !176 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !177, !DIExpression(), !178)
    #dbg_declare(ptr %3, !179, !DIExpression(), !180)
    #dbg_declare(ptr %4, !181, !DIExpression(), !183)
  store i32 0, ptr %4, align 4, !dbg !183
  br label %6, !dbg !184

6:                                                ; preds = %36, %1
  %7 = load i32, ptr %4, align 4, !dbg !185
  %8 = icmp slt i32 %7, 3, !dbg !187
  br i1 %8, label %9, label %39, !dbg !188

9:                                                ; preds = %6
    #dbg_declare(ptr %5, !189, !DIExpression(), !191)
  %10 = call zeroext i1 @ck_fifo_spsc_dequeue(ptr noundef @queue, ptr noundef %3), !dbg !192
  %11 = zext i1 %10 to i8, !dbg !191
  store i8 %11, ptr %5, align 1, !dbg !191
  %12 = load i8, ptr %5, align 1, !dbg !193
  %13 = trunc i8 %12 to i1, !dbg !193
  %14 = zext i1 %13 to i32, !dbg !193
  call void @__VERIFIER_assume(i32 noundef signext %14), !dbg !194
  %15 = load ptr, ptr %3, align 8, !dbg !195
  %16 = icmp ne ptr %15, null, !dbg !198
  br i1 %16, label %17, label %18, !dbg !199

17:                                               ; preds = %9
  br i1 true, label %19, label %18, !dbg !200

18:                                               ; preds = %17, %9
  call void @__assert_fail(ptr noundef @.str.1, ptr noundef @.str.2, i32 noundef signext 63, ptr noundef @__func__.consumer), !dbg !200
  br label %19, !dbg !200

19:                                               ; preds = %18, %17
  %20 = load ptr, ptr %3, align 8, !dbg !201
  %21 = getelementptr inbounds nuw %struct.point_s, ptr %20, i32 0, i32 0, !dbg !204
  %22 = load i32, ptr %21, align 4, !dbg !204
  %23 = load ptr, ptr %3, align 8, !dbg !205
  %24 = getelementptr inbounds nuw %struct.point_s, ptr %23, i32 0, i32 1, !dbg !206
  %25 = load i32, ptr %24, align 4, !dbg !206
  %26 = icmp eq i32 %22, %25, !dbg !207
  br i1 %26, label %28, label %27, !dbg !208

27:                                               ; preds = %19
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.2, i32 noundef signext 64, ptr noundef @__func__.consumer), !dbg !208
  br label %28, !dbg !208

28:                                               ; preds = %27, %19
  %29 = load ptr, ptr %3, align 8, !dbg !209
  %30 = getelementptr inbounds nuw %struct.point_s, ptr %29, i32 0, i32 1, !dbg !212
  %31 = load i32, ptr %30, align 4, !dbg !212
  %32 = icmp eq i32 %31, 1, !dbg !213
  br i1 %32, label %34, label %33, !dbg !214

33:                                               ; preds = %28
  call void @__assert_fail(ptr noundef @.str.4, ptr noundef @.str.2, i32 noundef signext 65, ptr noundef @__func__.consumer), !dbg !214
  br label %34, !dbg !214

34:                                               ; preds = %33, %28
  %35 = load ptr, ptr %3, align 8, !dbg !215
  call void @free(ptr noundef %35), !dbg !216
  br label %36, !dbg !217

36:                                               ; preds = %34
  %37 = load i32, ptr %4, align 4, !dbg !218
  %38 = add nsw i32 %37, 1, !dbg !218
  store i32 %38, ptr %4, align 4, !dbg !218
  br label %6, !dbg !219, !llvm.loop !220

39:                                               ; preds = %6
  ret ptr null, !dbg !222
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i1 @ck_fifo_spsc_dequeue(ptr noundef %0, ptr noundef %1) #0 !dbg !223 {
  %3 = alloca i1, align 1
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !226, !DIExpression(), !227)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !228, !DIExpression(), !229)
    #dbg_declare(ptr %6, !230, !DIExpression(), !231)
  %7 = load ptr, ptr %4, align 8, !dbg !232
  %8 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %7, i32 0, i32 1, !dbg !233
  %9 = load ptr, ptr %8, align 8, !dbg !233
  %10 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %9, i32 0, i32 1, !dbg !234
  %11 = call ptr @ck_pr_md_load_ptr(ptr noundef %10), !dbg !235
  store ptr %11, ptr %6, align 8, !dbg !236
  %12 = load ptr, ptr %6, align 8, !dbg !237
  %13 = icmp eq ptr %12, null, !dbg !239
  br i1 %13, label %14, label %15, !dbg !239

14:                                               ; preds = %2
  store i1 false, ptr %3, align 1, !dbg !240
  br label %23, !dbg !240

15:                                               ; preds = %2
  %16 = load ptr, ptr %5, align 8, !dbg !241
  %17 = load ptr, ptr %6, align 8, !dbg !242
  %18 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %17, i32 0, i32 0, !dbg !243
  %19 = load ptr, ptr %18, align 8, !dbg !243
  call void @ck_pr_md_store_ptr(ptr noundef %16, ptr noundef %19), !dbg !244
  call void @ck_pr_fence_store(), !dbg !245
  %20 = load ptr, ptr %4, align 8, !dbg !246
  %21 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %20, i32 0, i32 1, !dbg !247
  %22 = load ptr, ptr %6, align 8, !dbg !248
  call void @ck_pr_md_store_ptr(ptr noundef %21, ptr noundef %22), !dbg !249
  store i1 true, ptr %3, align 1, !dbg !250
  br label %23, !dbg !250

23:                                               ; preds = %15, %14
  %24 = load i1, ptr %3, align 1, !dbg !251
  ret i1 %24, !dbg !251
}

declare void @__VERIFIER_assume(i32 noundef signext) #3

declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef signext, ptr noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local signext i32 @main() #0 !dbg !252 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !255, !DIExpression(), !261)
    #dbg_declare(ptr %3, !262, !DIExpression(), !263)
  %6 = call ptr @malloc(i64 noundef 16) #4, !dbg !264
  store ptr %6, ptr %3, align 8, !dbg !263
  %7 = load ptr, ptr %3, align 8, !dbg !265
  %8 = icmp eq ptr %7, null, !dbg !267
  br i1 %8, label %9, label %10, !dbg !267

9:                                                ; preds = %0
  call void @exit(i32 noundef signext 1) #5, !dbg !268
  unreachable, !dbg !268

10:                                               ; preds = %0
  %11 = load ptr, ptr %3, align 8, !dbg !270
  call void @ck_fifo_spsc_init(ptr noundef @queue, ptr noundef %11), !dbg !271
  %12 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 0, !dbg !272
  %13 = call signext i32 @pthread_create(ptr noundef %12, ptr noundef null, ptr noundef @producer, ptr noundef null), !dbg !274
  %14 = icmp ne i32 %13, 0, !dbg !275
  br i1 %14, label %19, label %15, !dbg !276

15:                                               ; preds = %10
  %16 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 1, !dbg !277
  %17 = call signext i32 @pthread_create(ptr noundef %16, ptr noundef null, ptr noundef @consumer, ptr noundef null), !dbg !278
  %18 = icmp ne i32 %17, 0, !dbg !279
  br i1 %18, label %19, label %20, !dbg !276

19:                                               ; preds = %15, %10
  call void @exit(i32 noundef signext 1) #5, !dbg !280
  unreachable, !dbg !280

20:                                               ; preds = %15
    #dbg_declare(ptr %4, !282, !DIExpression(), !284)
  store i32 0, ptr %4, align 4, !dbg !284
  br label %21, !dbg !285

21:                                               ; preds = %30, %20
  %22 = load i32, ptr %4, align 4, !dbg !286
  %23 = icmp slt i32 %22, 2, !dbg !288
  br i1 %23, label %24, label %33, !dbg !289

24:                                               ; preds = %21
  %25 = load i32, ptr %4, align 4, !dbg !290
  %26 = sext i32 %25 to i64, !dbg !292
  %27 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %26, !dbg !292
  %28 = load ptr, ptr %27, align 8, !dbg !292
  %29 = call signext i32 @pthread_join(ptr noundef %28, ptr noundef null), !dbg !293
  br label %30, !dbg !294

30:                                               ; preds = %24
  %31 = load i32, ptr %4, align 4, !dbg !295
  %32 = add nsw i32 %31, 1, !dbg !295
  store i32 %32, ptr %4, align 4, !dbg !295
  br label %21, !dbg !296, !llvm.loop !297

33:                                               ; preds = %21
    #dbg_declare(ptr %5, !299, !DIExpression(), !300)
  call void @ck_fifo_spsc_deinit(ptr noundef @queue, ptr noundef %5), !dbg !301
  %34 = load ptr, ptr %5, align 8, !dbg !302
  call void @free(ptr noundef %34), !dbg !303
  ret i32 0, !dbg !304
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_fifo_spsc_init(ptr noundef %0, ptr noundef %1) #0 !dbg !305 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !308, !DIExpression(), !309)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !310, !DIExpression(), !311)
  %5 = load ptr, ptr %3, align 8, !dbg !312
  %6 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %5, i32 0, i32 0, !dbg !313
  call void @ck_spinlock_fas_init(ptr noundef %6), !dbg !314
  %7 = load ptr, ptr %3, align 8, !dbg !315
  %8 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %7, i32 0, i32 3, !dbg !316
  call void @ck_spinlock_fas_init(ptr noundef %8), !dbg !317
  %9 = load ptr, ptr %4, align 8, !dbg !318
  %10 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %9, i32 0, i32 1, !dbg !319
  store ptr null, ptr %10, align 8, !dbg !320
  %11 = load ptr, ptr %4, align 8, !dbg !321
  %12 = load ptr, ptr %3, align 8, !dbg !322
  %13 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %12, i32 0, i32 6, !dbg !323
  store ptr %11, ptr %13, align 8, !dbg !324
  %14 = load ptr, ptr %3, align 8, !dbg !325
  %15 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %14, i32 0, i32 5, !dbg !326
  store ptr %11, ptr %15, align 8, !dbg !327
  %16 = load ptr, ptr %3, align 8, !dbg !328
  %17 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %16, i32 0, i32 4, !dbg !329
  store ptr %11, ptr %17, align 8, !dbg !330
  %18 = load ptr, ptr %3, align 8, !dbg !331
  %19 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %18, i32 0, i32 1, !dbg !332
  store ptr %11, ptr %19, align 8, !dbg !333
  ret void, !dbg !334
}

declare signext i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare signext i32 @pthread_join(ptr noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_fifo_spsc_deinit(ptr noundef %0, ptr noundef %1) #0 !dbg !335 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !339, !DIExpression(), !340)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !341, !DIExpression(), !342)
  %5 = load ptr, ptr %3, align 8, !dbg !343
  %6 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %5, i32 0, i32 6, !dbg !344
  %7 = load ptr, ptr %6, align 8, !dbg !344
  %8 = load ptr, ptr %4, align 8, !dbg !345
  store ptr %7, ptr %8, align 8, !dbg !346
  %9 = load ptr, ptr %3, align 8, !dbg !347
  %10 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %9, i32 0, i32 4, !dbg !348
  store ptr null, ptr %10, align 8, !dbg !349
  %11 = load ptr, ptr %3, align 8, !dbg !350
  %12 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %11, i32 0, i32 1, !dbg !351
  store ptr null, ptr %12, align 8, !dbg !352
  ret void, !dbg !353
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_store() #0 !dbg !354 {
  call void @ck_pr_fence_strict_store(), !dbg !358
  ret void, !dbg !358
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_md_store_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !359 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !365, !DIExpression(), !366)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !367, !DIExpression(), !366)
  %5 = load ptr, ptr %3, align 8, !dbg !366
  %6 = load ptr, ptr %4, align 8, !dbg !366
  call void asm sideeffect "sd $1, 0($0)", "r,r,~{memory}"(ptr %5, ptr %6) #6, !dbg !366, !srcloc !368
  ret void, !dbg !366
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_store() #0 !dbg !369 {
  call void asm sideeffect "fence w,w", "~{memory}"() #6, !dbg !370, !srcloc !371
  ret void, !dbg !372
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 !dbg !373 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !376, !DIExpression(), !377)
    #dbg_declare(ptr %3, !378, !DIExpression(), !377)
  store i64 0, ptr %3, align 8, !dbg !377
  %4 = load ptr, ptr %2, align 8, !dbg !377
  %5 = call i64 asm sideeffect "ld $0, 0($1)\0A", "=r,r,~{memory}"(ptr %4) #6, !dbg !377, !srcloc !380
  store i64 %5, ptr %3, align 8, !dbg !377
  %6 = load i64, ptr %3, align 8, !dbg !377
  %7 = inttoptr i64 %6 to ptr, !dbg !377
  ret ptr %7, !dbg !377
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_fas_init(ptr noundef %0) #0 !dbg !381 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !385, !DIExpression(), !386)
  %3 = load ptr, ptr %2, align 8, !dbg !387
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_fas, ptr %3, i32 0, i32 0, !dbg !388
  store i32 0, ptr %4, align 4, !dbg !389
  call void @ck_pr_barrier(), !dbg !390
  ret void, !dbg !391
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_barrier() #0 !dbg !392 {
  call void asm sideeffect "", "~{memory}"() #6, !dbg !394, !srcloc !395
  ret void, !dbg !396
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+d,+f,+i,+m,+relax,+zaamo,+zalrsc,+zca,+zcd,+zicsr,+zmmul,-b,-e,-experimental-p,-experimental-smpmpmt,-experimental-svukte,-experimental-xrivosvisni,-experimental-xrivosvizip,-experimental-xsfmclic,-experimental-xsfsclic,-experimental-zibi,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvfbfa,-experimental-zvfofp8min,-experimental-zvkgs,-experimental-zvqdotq,-h,-q,-sdext,-sdtrig,-sha,-shcounterenw,-shgatpa,-shlcofideleg,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcntrpmf,-smcsrind,-smctr,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssctr,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xandesbfhcvt,-xandesperf,-xandesvbfhcvt,-xandesvdot,-xandesvpackfph,-xandesvsinth,-xandesvsintload,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xmipscbop,-xmipscmov,-xmipsexectl,-xmipslsp,-xqccmp,-xqci,-xqcia,-xqciac,-xqcibi,-xqcibm,-xqcicli,-xqcicm,-xqcics,-xqcicsr,-xqciint,-xqciio,-xqcilb,-xqcili,-xqcilia,-xqcilo,-xqcilsm,-xqcisim,-xqcisls,-xqcisync,-xsfcease,-xsfmm128t,-xsfmm16t,-xsfmm32a16f,-xsfmm32a32f,-xsfmm32a8f,-xsfmm32a8i,-xsfmm32t,-xsfmm64a64f,-xsfmm64t,-xsfmmbase,-xsfvcp,-xsfvfbfexp16e,-xsfvfexp16e,-xsfvfexp32e,-xsfvfexpa,-xsfvfexpa64e,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xsmtvdot,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zabha,-zacas,-zalasr,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zcb,-zce,-zcf,-zclsd,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccamoc,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zilsd,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+d,+f,+i,+m,+relax,+zaamo,+zalrsc,+zca,+zcd,+zicsr,+zmmul,-b,-e,-experimental-p,-experimental-smpmpmt,-experimental-svukte,-experimental-xrivosvisni,-experimental-xrivosvizip,-experimental-xsfmclic,-experimental-xsfsclic,-experimental-zibi,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvfbfa,-experimental-zvfofp8min,-experimental-zvkgs,-experimental-zvqdotq,-h,-q,-sdext,-sdtrig,-sha,-shcounterenw,-shgatpa,-shlcofideleg,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcntrpmf,-smcsrind,-smctr,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssctr,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xandesbfhcvt,-xandesperf,-xandesvbfhcvt,-xandesvdot,-xandesvpackfph,-xandesvsinth,-xandesvsintload,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xmipscbop,-xmipscmov,-xmipsexectl,-xmipslsp,-xqccmp,-xqci,-xqcia,-xqciac,-xqcibi,-xqcibm,-xqcicli,-xqcicm,-xqcics,-xqcicsr,-xqciint,-xqciio,-xqcilb,-xqcili,-xqcilia,-xqcilo,-xqcilsm,-xqcisim,-xqcisls,-xqcisync,-xsfcease,-xsfmm128t,-xsfmm16t,-xsfmm32a16f,-xsfmm32a32f,-xsfmm32a8f,-xsfmm32a8i,-xsfmm32t,-xsfmm64a64f,-xsfmm64t,-xsfmmbase,-xsfvcp,-xsfvfbfexp16e,-xsfvfexp16e,-xsfvfexp32e,-xsfvfexpa,-xsfvfexpa64e,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xsmtvdot,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zabha,-zacas,-zalasr,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zcb,-zce,-zcf,-zclsd,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccamoc,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zilsd,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+d,+f,+i,+m,+relax,+zaamo,+zalrsc,+zca,+zcd,+zicsr,+zmmul,-b,-e,-experimental-p,-experimental-smpmpmt,-experimental-svukte,-experimental-xrivosvisni,-experimental-xrivosvizip,-experimental-xsfmclic,-experimental-xsfsclic,-experimental-zibi,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvfbfa,-experimental-zvfofp8min,-experimental-zvkgs,-experimental-zvqdotq,-h,-q,-sdext,-sdtrig,-sha,-shcounterenw,-shgatpa,-shlcofideleg,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcntrpmf,-smcsrind,-smctr,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssctr,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xandesbfhcvt,-xandesperf,-xandesvbfhcvt,-xandesvdot,-xandesvpackfph,-xandesvsinth,-xandesvsintload,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xmipscbop,-xmipscmov,-xmipsexectl,-xmipslsp,-xqccmp,-xqci,-xqcia,-xqciac,-xqcibi,-xqcibm,-xqcicli,-xqcicm,-xqcics,-xqcicsr,-xqciint,-xqciio,-xqcilb,-xqcili,-xqcilia,-xqcilo,-xqcilsm,-xqcisim,-xqcisls,-xqcisync,-xsfcease,-xsfmm128t,-xsfmm16t,-xsfmm32a16f,-xsfmm32a32f,-xsfmm32a8f,-xsfmm32a8i,-xsfmm32t,-xsfmm64a64f,-xsfmm64t,-xsfmmbase,-xsfvcp,-xsfvfbfexp16e,-xsfvfexp16e,-xsfvfexp32e,-xsfvfexpa,-xsfvfexpa64e,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xsmtvdot,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zabha,-zacas,-zalasr,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zcb,-zce,-zcf,-zclsd,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccamoc,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zilsd,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+d,+f,+i,+m,+relax,+zaamo,+zalrsc,+zca,+zcd,+zicsr,+zmmul,-b,-e,-experimental-p,-experimental-smpmpmt,-experimental-svukte,-experimental-xrivosvisni,-experimental-xrivosvizip,-experimental-xsfmclic,-experimental-xsfsclic,-experimental-zibi,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvfbfa,-experimental-zvfofp8min,-experimental-zvkgs,-experimental-zvqdotq,-h,-q,-sdext,-sdtrig,-sha,-shcounterenw,-shgatpa,-shlcofideleg,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcntrpmf,-smcsrind,-smctr,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssctr,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xandesbfhcvt,-xandesperf,-xandesvbfhcvt,-xandesvdot,-xandesvpackfph,-xandesvsinth,-xandesvsintload,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xmipscbop,-xmipscmov,-xmipsexectl,-xmipslsp,-xqccmp,-xqci,-xqcia,-xqciac,-xqcibi,-xqcibm,-xqcicli,-xqcicm,-xqcics,-xqcicsr,-xqciint,-xqciio,-xqcilb,-xqcili,-xqcilia,-xqcilo,-xqcilsm,-xqcisim,-xqcisls,-xqcisync,-xsfcease,-xsfmm128t,-xsfmm16t,-xsfmm32a16f,-xsfmm32a32f,-xsfmm32a8f,-xsfmm32a8i,-xsfmm32t,-xsfmm64a64f,-xsfmm64t,-xsfmmbase,-xsfvcp,-xsfvfbfexp16e,-xsfvfexp16e,-xsfvfexp32e,-xsfvfexpa,-xsfvfexpa64e,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xsmtvdot,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zabha,-zacas,-zalasr,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zcb,-zce,-zcf,-zclsd,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccamoc,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zilsd,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #4 = { allocsize(0) }
attributes #5 = { noreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!69, !70, !71, !72, !73, !75, !76, !77, !78, !79}
!llvm.ident = !{!80}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "queue", scope: !2, file: !3, line: 21, type: !50, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/spsc_queue.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "7bec67ad4368bbed4d80bc0489a6ba84")
!4 = !{!5, !6, !7, !8, !14}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_fifo_spsc_entry", file: !10, line: 39, size: 128, elements: !11)
!10 = !DIFile(filename: "../ck/include/ck_fifo.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "252298fd696ccc816ddf53f92a49d2df")
!11 = !{!12, !13}
!12 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !9, file: !10, line: 40, baseType: !5, size: 64)
!13 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !9, file: !10, line: 41, baseType: !8, size: 64, offset: 64)
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
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_fifo_spsc", file: !10, line: 45, size: 768, elements: !52)
!52 = !{!53, !60, !61, !65, !66, !67, !68}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "m_head", scope: !51, file: !10, line: 46, baseType: !54, size: 32)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_fas_t", file: !55, line: 42, baseType: !56)
!55 = !DIFile(filename: "../ck/include/spinlock/fas.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "999805093e3ea65ae15690fa7c76e04b")
!56 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_fas", file: !55, line: 39, size: 32, elements: !57)
!57 = !{!58}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !56, file: !55, line: 40, baseType: !59, size: 32)
!59 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !51, file: !10, line: 47, baseType: !8, size: 64, offset: 64)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !51, file: !10, line: 48, baseType: !62, size: 416, offset: 128)
!62 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 416, elements: !63)
!63 = !{!64}
!64 = !DISubrange(count: 52)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "m_tail", scope: !51, file: !10, line: 49, baseType: !54, size: 32, offset: 544)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !51, file: !10, line: 50, baseType: !8, size: 64, offset: 576)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "head_snapshot", scope: !51, file: !10, line: 51, baseType: !8, size: 64, offset: 640)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "garbage", scope: !51, file: !10, line: 52, baseType: !8, size: 64, offset: 704)
!69 = !{i32 7, !"Dwarf Version", i32 5}
!70 = !{i32 2, !"Debug Info Version", i32 3}
!71 = !{i32 1, !"wchar_size", i32 4}
!72 = !{i32 1, !"target-abi", !"lp64d"}
!73 = !{i32 6, !"riscv-isa", !74}
!74 = !{!"rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0_zcd1p0"}
!75 = !{i32 8, !"PIC Level", i32 2}
!76 = !{i32 7, !"PIE Level", i32 2}
!77 = !{i32 7, !"uwtable", i32 2}
!78 = !{i32 7, !"frame-pointer", i32 2}
!79 = !{i32 8, !"SmallDataLimit", i32 0}
!80 = !{!"Homebrew clang version 22.1.8"}
!81 = distinct !DISubprogram(name: "producer", scope: !3, file: !3, line: 23, type: !82, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!82 = !DISubroutineType(types: !83)
!83 = !{!5, !5}
!84 = !{}
!85 = !DILocalVariable(name: "arg", arg: 1, scope: !81, file: !3, line: 23, type: !5)
!86 = !DILocation(line: 23, column: 22, scope: !81)
!87 = !DILocalVariable(name: "i", scope: !88, file: !3, line: 25, type: !6)
!88 = distinct !DILexicalBlock(scope: !81, file: !3, line: 25, column: 5)
!89 = !DILocation(line: 25, column: 14, scope: !88)
!90 = !DILocation(line: 25, column: 10, scope: !88)
!91 = !DILocation(line: 25, column: 21, scope: !92)
!92 = distinct !DILexicalBlock(scope: !88, file: !3, line: 25, column: 5)
!93 = !DILocation(line: 25, column: 23, scope: !92)
!94 = !DILocation(line: 25, column: 5, scope: !88)
!95 = !DILocalVariable(name: "point", scope: !96, file: !3, line: 27, type: !97)
!96 = distinct !DILexicalBlock(scope: !92, file: !3, line: 26, column: 5)
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!98 = !DIDerivedType(tag: DW_TAG_typedef, name: "point_t", file: !3, line: 19, baseType: !99)
!99 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "point_s", file: !3, line: 15, size: 64, elements: !100)
!100 = !{!101, !102}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !99, file: !3, line: 17, baseType: !59, size: 32)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !99, file: !3, line: 18, baseType: !59, size: 32, offset: 32)
!103 = !DILocation(line: 27, column: 18, scope: !96)
!104 = !DILocation(line: 27, column: 26, scope: !96)
!105 = !DILocation(line: 28, column: 13, scope: !106)
!106 = distinct !DILexicalBlock(scope: !96, file: !3, line: 28, column: 13)
!107 = !DILocation(line: 28, column: 19, scope: !106)
!108 = !DILocation(line: 30, column: 13, scope: !109)
!109 = distinct !DILexicalBlock(scope: !106, file: !3, line: 29, column: 9)
!110 = !DILocation(line: 33, column: 9, scope: !96)
!111 = !DILocation(line: 33, column: 16, scope: !96)
!112 = !DILocation(line: 33, column: 18, scope: !96)
!113 = !DILocation(line: 34, column: 9, scope: !96)
!114 = !DILocation(line: 34, column: 16, scope: !96)
!115 = !DILocation(line: 34, column: 18, scope: !96)
!116 = !DILocalVariable(name: "entry", scope: !96, file: !3, line: 36, type: !117)
!117 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !118, size: 64)
!118 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_fifo_spsc_entry_t", file: !10, line: 43, baseType: !9)
!119 = !DILocation(line: 36, column: 31, scope: !96)
!120 = !DILocation(line: 36, column: 39, scope: !96)
!121 = !DILocation(line: 37, column: 13, scope: !122)
!122 = distinct !DILexicalBlock(scope: !96, file: !3, line: 37, column: 13)
!123 = !DILocation(line: 37, column: 19, scope: !122)
!124 = !DILocation(line: 39, column: 18, scope: !125)
!125 = distinct !DILexicalBlock(scope: !122, file: !3, line: 38, column: 9)
!126 = !DILocation(line: 39, column: 13, scope: !125)
!127 = !DILocation(line: 40, column: 13, scope: !125)
!128 = !DILocation(line: 43, column: 38, scope: !96)
!129 = !DILocation(line: 43, column: 45, scope: !96)
!130 = !DILocation(line: 43, column: 9, scope: !96)
!131 = !DILocation(line: 44, column: 5, scope: !96)
!132 = !DILocation(line: 25, column: 45, scope: !92)
!133 = !DILocation(line: 25, column: 5, scope: !92)
!134 = distinct !{!134, !94, !135, !136}
!135 = !DILocation(line: 44, column: 5, scope: !88)
!136 = !{!"llvm.loop.mustprogress"}
!137 = !DILocalVariable(name: "entry", scope: !81, file: !3, line: 46, type: !117)
!138 = !DILocation(line: 46, column: 27, scope: !81)
!139 = !DILocation(line: 46, column: 35, scope: !81)
!140 = !DILocation(line: 47, column: 9, scope: !141)
!141 = distinct !DILexicalBlock(scope: !81, file: !3, line: 47, column: 9)
!142 = !DILocation(line: 47, column: 15, scope: !141)
!143 = !DILocation(line: 49, column: 9, scope: !144)
!144 = distinct !DILexicalBlock(scope: !141, file: !3, line: 48, column: 5)
!145 = !DILocation(line: 51, column: 34, scope: !81)
!146 = !DILocation(line: 51, column: 5, scope: !81)
!147 = !DILocation(line: 53, column: 5, scope: !81)
!148 = distinct !DISubprogram(name: "ck_fifo_spsc_enqueue", scope: !10, file: !10, line: 124, type: !149, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!149 = !DISubroutineType(types: !150)
!150 = !{null, !151, !8, !5}
!151 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!152 = !DILocalVariable(name: "fifo", arg: 1, scope: !148, file: !10, line: 124, type: !151)
!153 = !DILocation(line: 124, column: 43, scope: !148)
!154 = !DILocalVariable(name: "entry", arg: 2, scope: !148, file: !10, line: 125, type: !8)
!155 = !DILocation(line: 125, column: 35, scope: !148)
!156 = !DILocalVariable(name: "value", arg: 3, scope: !148, file: !10, line: 126, type: !5)
!157 = !DILocation(line: 126, column: 14, scope: !148)
!158 = !DILocation(line: 129, column: 17, scope: !148)
!159 = !DILocation(line: 129, column: 2, scope: !148)
!160 = !DILocation(line: 129, column: 9, scope: !148)
!161 = !DILocation(line: 129, column: 15, scope: !148)
!162 = !DILocation(line: 130, column: 2, scope: !148)
!163 = !DILocation(line: 130, column: 9, scope: !148)
!164 = !DILocation(line: 130, column: 14, scope: !148)
!165 = !DILocation(line: 133, column: 2, scope: !148)
!166 = !DILocation(line: 134, column: 19, scope: !148)
!167 = !DILocation(line: 134, column: 25, scope: !148)
!168 = !DILocation(line: 134, column: 31, scope: !148)
!169 = !DILocation(line: 134, column: 37, scope: !148)
!170 = !DILocation(line: 134, column: 2, scope: !148)
!171 = !DILocation(line: 135, column: 15, scope: !148)
!172 = !DILocation(line: 135, column: 2, scope: !148)
!173 = !DILocation(line: 135, column: 8, scope: !148)
!174 = !DILocation(line: 135, column: 13, scope: !148)
!175 = !DILocation(line: 136, column: 2, scope: !148)
!176 = distinct !DISubprogram(name: "consumer", scope: !3, file: !3, line: 55, type: !82, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!177 = !DILocalVariable(name: "arg", arg: 1, scope: !176, file: !3, line: 55, type: !5)
!178 = !DILocation(line: 55, column: 22, scope: !176)
!179 = !DILocalVariable(name: "point", scope: !176, file: !3, line: 57, type: !97)
!180 = !DILocation(line: 57, column: 14, scope: !176)
!181 = !DILocalVariable(name: "i", scope: !182, file: !3, line: 59, type: !6)
!182 = distinct !DILexicalBlock(scope: !176, file: !3, line: 59, column: 5)
!183 = !DILocation(line: 59, column: 14, scope: !182)
!184 = !DILocation(line: 59, column: 10, scope: !182)
!185 = !DILocation(line: 59, column: 21, scope: !186)
!186 = distinct !DILexicalBlock(scope: !182, file: !3, line: 59, column: 5)
!187 = !DILocation(line: 59, column: 23, scope: !186)
!188 = !DILocation(line: 59, column: 5, scope: !182)
!189 = !DILocalVariable(name: "res", scope: !190, file: !3, line: 61, type: !14)
!190 = distinct !DILexicalBlock(scope: !186, file: !3, line: 60, column: 5)
!191 = !DILocation(line: 61, column: 14, scope: !190)
!192 = !DILocation(line: 61, column: 20, scope: !190)
!193 = !DILocation(line: 62, column: 27, scope: !190)
!194 = !DILocation(line: 62, column: 9, scope: !190)
!195 = !DILocation(line: 63, column: 16, scope: !196)
!196 = distinct !DILexicalBlock(scope: !197, file: !3, line: 63, column: 9)
!197 = distinct !DILexicalBlock(scope: !190, file: !3, line: 63, column: 9)
!198 = !DILocation(line: 63, column: 22, scope: !196)
!199 = !DILocation(line: 63, column: 30, scope: !196)
!200 = !DILocation(line: 63, column: 9, scope: !196)
!201 = !DILocation(line: 64, column: 16, scope: !202)
!202 = distinct !DILexicalBlock(scope: !203, file: !3, line: 64, column: 9)
!203 = distinct !DILexicalBlock(scope: !190, file: !3, line: 64, column: 9)
!204 = !DILocation(line: 64, column: 23, scope: !202)
!205 = !DILocation(line: 64, column: 28, scope: !202)
!206 = !DILocation(line: 64, column: 35, scope: !202)
!207 = !DILocation(line: 64, column: 25, scope: !202)
!208 = !DILocation(line: 64, column: 9, scope: !202)
!209 = !DILocation(line: 65, column: 16, scope: !210)
!210 = distinct !DILexicalBlock(scope: !211, file: !3, line: 65, column: 9)
!211 = distinct !DILexicalBlock(scope: !190, file: !3, line: 65, column: 9)
!212 = !DILocation(line: 65, column: 23, scope: !210)
!213 = !DILocation(line: 65, column: 25, scope: !210)
!214 = !DILocation(line: 65, column: 9, scope: !210)
!215 = !DILocation(line: 67, column: 14, scope: !190)
!216 = !DILocation(line: 67, column: 9, scope: !190)
!217 = !DILocation(line: 68, column: 5, scope: !190)
!218 = !DILocation(line: 59, column: 45, scope: !186)
!219 = !DILocation(line: 59, column: 5, scope: !186)
!220 = distinct !{!220, !188, !221, !136}
!221 = !DILocation(line: 68, column: 5, scope: !182)
!222 = !DILocation(line: 70, column: 5, scope: !176)
!223 = distinct !DISubprogram(name: "ck_fifo_spsc_dequeue", scope: !10, file: !10, line: 140, type: !224, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!224 = !DISubroutineType(types: !225)
!225 = !{!14, !151, !5}
!226 = !DILocalVariable(name: "fifo", arg: 1, scope: !223, file: !10, line: 140, type: !151)
!227 = !DILocation(line: 140, column: 43, scope: !223)
!228 = !DILocalVariable(name: "value", arg: 2, scope: !223, file: !10, line: 140, type: !5)
!229 = !DILocation(line: 140, column: 55, scope: !223)
!230 = !DILocalVariable(name: "entry", scope: !223, file: !10, line: 142, type: !8)
!231 = !DILocation(line: 142, column: 29, scope: !223)
!232 = !DILocation(line: 149, column: 26, scope: !223)
!233 = !DILocation(line: 149, column: 32, scope: !223)
!234 = !DILocation(line: 149, column: 38, scope: !223)
!235 = !DILocation(line: 149, column: 10, scope: !223)
!236 = !DILocation(line: 149, column: 8, scope: !223)
!237 = !DILocation(line: 150, column: 6, scope: !238)
!238 = distinct !DILexicalBlock(scope: !223, file: !10, line: 150, column: 6)
!239 = !DILocation(line: 150, column: 12, scope: !238)
!240 = !DILocation(line: 151, column: 3, scope: !238)
!241 = !DILocation(line: 154, column: 25, scope: !223)
!242 = !DILocation(line: 154, column: 32, scope: !223)
!243 = !DILocation(line: 154, column: 39, scope: !223)
!244 = !DILocation(line: 154, column: 2, scope: !223)
!245 = !DILocation(line: 155, column: 2, scope: !223)
!246 = !DILocation(line: 156, column: 19, scope: !223)
!247 = !DILocation(line: 156, column: 25, scope: !223)
!248 = !DILocation(line: 156, column: 31, scope: !223)
!249 = !DILocation(line: 156, column: 2, scope: !223)
!250 = !DILocation(line: 157, column: 2, scope: !223)
!251 = !DILocation(line: 158, column: 1, scope: !223)
!252 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 73, type: !253, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !84)
!253 = !DISubroutineType(types: !254)
!254 = !{!6}
!255 = !DILocalVariable(name: "threads", scope: !252, file: !3, line: 75, type: !256)
!256 = !DICompositeType(tag: DW_TAG_array_type, baseType: !257, size: 128, elements: !259)
!257 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !258, line: 2, baseType: !5)
!258 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!259 = !{!260}
!260 = !DISubrange(count: 2)
!261 = !DILocation(line: 75, column: 15, scope: !252)
!262 = !DILocalVariable(name: "initial_entry", scope: !252, file: !3, line: 77, type: !117)
!263 = !DILocation(line: 77, column: 27, scope: !252)
!264 = !DILocation(line: 77, column: 43, scope: !252)
!265 = !DILocation(line: 78, column: 9, scope: !266)
!266 = distinct !DILexicalBlock(scope: !252, file: !3, line: 78, column: 9)
!267 = !DILocation(line: 78, column: 23, scope: !266)
!268 = !DILocation(line: 80, column: 9, scope: !269)
!269 = distinct !DILexicalBlock(scope: !266, file: !3, line: 79, column: 5)
!270 = !DILocation(line: 82, column: 31, scope: !252)
!271 = !DILocation(line: 82, column: 5, scope: !252)
!272 = !DILocation(line: 84, column: 25, scope: !273)
!273 = distinct !DILexicalBlock(scope: !252, file: !3, line: 84, column: 9)
!274 = !DILocation(line: 84, column: 9, scope: !273)
!275 = !DILocation(line: 84, column: 59, scope: !273)
!276 = !DILocation(line: 84, column: 64, scope: !273)
!277 = !DILocation(line: 85, column: 25, scope: !273)
!278 = !DILocation(line: 85, column: 9, scope: !273)
!279 = !DILocation(line: 85, column: 59, scope: !273)
!280 = !DILocation(line: 87, column: 9, scope: !281)
!281 = distinct !DILexicalBlock(scope: !273, file: !3, line: 86, column: 5)
!282 = !DILocalVariable(name: "i", scope: !283, file: !3, line: 90, type: !6)
!283 = distinct !DILexicalBlock(scope: !252, file: !3, line: 90, column: 5)
!284 = !DILocation(line: 90, column: 14, scope: !283)
!285 = !DILocation(line: 90, column: 10, scope: !283)
!286 = !DILocation(line: 90, column: 21, scope: !287)
!287 = distinct !DILexicalBlock(scope: !283, file: !3, line: 90, column: 5)
!288 = !DILocation(line: 90, column: 23, scope: !287)
!289 = !DILocation(line: 90, column: 5, scope: !283)
!290 = !DILocation(line: 92, column: 30, scope: !291)
!291 = distinct !DILexicalBlock(scope: !287, file: !3, line: 91, column: 5)
!292 = !DILocation(line: 92, column: 22, scope: !291)
!293 = !DILocation(line: 92, column: 9, scope: !291)
!294 = !DILocation(line: 93, column: 5, scope: !291)
!295 = !DILocation(line: 90, column: 36, scope: !287)
!296 = !DILocation(line: 90, column: 5, scope: !287)
!297 = distinct !{!297, !289, !298, !136}
!298 = !DILocation(line: 93, column: 5, scope: !283)
!299 = !DILocalVariable(name: "garbage", scope: !252, file: !3, line: 95, type: !117)
!300 = !DILocation(line: 95, column: 27, scope: !252)
!301 = !DILocation(line: 96, column: 5, scope: !252)
!302 = !DILocation(line: 97, column: 10, scope: !252)
!303 = !DILocation(line: 97, column: 5, scope: !252)
!304 = !DILocation(line: 99, column: 5, scope: !252)
!305 = distinct !DISubprogram(name: "ck_fifo_spsc_init", scope: !10, file: !10, line: 103, type: !306, scopeLine: 104, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!306 = !DISubroutineType(types: !307)
!307 = !{null, !151, !8}
!308 = !DILocalVariable(name: "fifo", arg: 1, scope: !305, file: !10, line: 103, type: !151)
!309 = !DILocation(line: 103, column: 40, scope: !305)
!310 = !DILocalVariable(name: "stub", arg: 2, scope: !305, file: !10, line: 103, type: !8)
!311 = !DILocation(line: 103, column: 73, scope: !305)
!312 = !DILocation(line: 106, column: 20, scope: !305)
!313 = !DILocation(line: 106, column: 26, scope: !305)
!314 = !DILocation(line: 106, column: 2, scope: !305)
!315 = !DILocation(line: 107, column: 20, scope: !305)
!316 = !DILocation(line: 107, column: 26, scope: !305)
!317 = !DILocation(line: 107, column: 2, scope: !305)
!318 = !DILocation(line: 109, column: 2, scope: !305)
!319 = !DILocation(line: 109, column: 8, scope: !305)
!320 = !DILocation(line: 109, column: 13, scope: !305)
!321 = !DILocation(line: 110, column: 66, scope: !305)
!322 = !DILocation(line: 110, column: 50, scope: !305)
!323 = !DILocation(line: 110, column: 56, scope: !305)
!324 = !DILocation(line: 110, column: 64, scope: !305)
!325 = !DILocation(line: 110, column: 28, scope: !305)
!326 = !DILocation(line: 110, column: 34, scope: !305)
!327 = !DILocation(line: 110, column: 48, scope: !305)
!328 = !DILocation(line: 110, column: 15, scope: !305)
!329 = !DILocation(line: 110, column: 21, scope: !305)
!330 = !DILocation(line: 110, column: 26, scope: !305)
!331 = !DILocation(line: 110, column: 2, scope: !305)
!332 = !DILocation(line: 110, column: 8, scope: !305)
!333 = !DILocation(line: 110, column: 13, scope: !305)
!334 = !DILocation(line: 111, column: 2, scope: !305)
!335 = distinct !DISubprogram(name: "ck_fifo_spsc_deinit", scope: !10, file: !10, line: 115, type: !336, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!336 = !DISubroutineType(types: !337)
!337 = !{null, !151, !338}
!338 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!339 = !DILocalVariable(name: "fifo", arg: 1, scope: !335, file: !10, line: 115, type: !151)
!340 = !DILocation(line: 115, column: 42, scope: !335)
!341 = !DILocalVariable(name: "garbage", arg: 2, scope: !335, file: !10, line: 115, type: !338)
!342 = !DILocation(line: 115, column: 76, scope: !335)
!343 = !DILocation(line: 118, column: 13, scope: !335)
!344 = !DILocation(line: 118, column: 19, scope: !335)
!345 = !DILocation(line: 118, column: 3, scope: !335)
!346 = !DILocation(line: 118, column: 11, scope: !335)
!347 = !DILocation(line: 119, column: 15, scope: !335)
!348 = !DILocation(line: 119, column: 21, scope: !335)
!349 = !DILocation(line: 119, column: 26, scope: !335)
!350 = !DILocation(line: 119, column: 2, scope: !335)
!351 = !DILocation(line: 119, column: 8, scope: !335)
!352 = !DILocation(line: 119, column: 13, scope: !335)
!353 = !DILocation(line: 120, column: 2, scope: !335)
!354 = distinct !DISubprogram(name: "ck_pr_fence_store", scope: !355, file: !355, line: 117, type: !356, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!355 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!356 = !DISubroutineType(types: !357)
!357 = !{null}
!358 = !DILocation(line: 117, column: 1, scope: !354)
!359 = distinct !DISubprogram(name: "ck_pr_md_store_ptr", scope: !360, file: !360, line: 154, type: !361, scopeLine: 154, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!360 = !DIFile(filename: "../ck/include/gcc/riscv64/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "12d84f448ebee465be3d55b54db43664")
!361 = !DISubroutineType(types: !362)
!362 = !{null, !5, !363}
!363 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !364, size: 64)
!364 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!365 = !DILocalVariable(name: "target", arg: 1, scope: !359, file: !360, line: 154, type: !5)
!366 = !DILocation(line: 154, column: 1, scope: !359)
!367 = !DILocalVariable(name: "val", arg: 2, scope: !359, file: !360, line: 154, type: !363)
!368 = !{i64 2147593582}
!369 = distinct !DISubprogram(name: "ck_pr_fence_strict_store", scope: !360, file: !360, line: 91, type: !356, scopeLine: 91, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!370 = !DILocation(line: 91, column: 20, scope: !369)
!371 = !{i64 2147587111}
!372 = !DILocation(line: 91, column: 1, scope: !369)
!373 = distinct !DISubprogram(name: "ck_pr_md_load_ptr", scope: !360, file: !360, line: 123, type: !374, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!374 = !DISubroutineType(types: !375)
!375 = !{!5, !363}
!376 = !DILocalVariable(name: "target", arg: 1, scope: !373, file: !360, line: 123, type: !363)
!377 = !DILocation(line: 123, column: 1, scope: !373)
!378 = !DILocalVariable(name: "r", scope: !373, file: !360, line: 123, type: !379)
!379 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!380 = !{i64 2147589974}
!381 = distinct !DISubprogram(name: "ck_spinlock_fas_init", scope: !55, file: !55, line: 47, type: !382, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !84)
!382 = !DISubroutineType(types: !383)
!383 = !{null, !384}
!384 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!385 = !DILocalVariable(name: "lock", arg: 1, scope: !381, file: !55, line: 47, type: !384)
!386 = !DILocation(line: 47, column: 46, scope: !381)
!387 = !DILocation(line: 50, column: 2, scope: !381)
!388 = !DILocation(line: 50, column: 8, scope: !381)
!389 = !DILocation(line: 50, column: 14, scope: !381)
!390 = !DILocation(line: 51, column: 2, scope: !381)
!391 = !DILocation(line: 52, column: 2, scope: !381)
!392 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !393, file: !393, line: 37, type: !356, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!393 = !DIFile(filename: "../ck/include/gcc/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!394 = !DILocation(line: 40, column: 2, scope: !392)
!395 = !{i64 163256}
!396 = !DILocation(line: 41, column: 2, scope: !392)
