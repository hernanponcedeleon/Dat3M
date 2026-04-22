; ModuleID = 'benchmarks/ck/spsc_queue.c'
source_filename = "benchmarks/ck/spsc_queue.c"
target datalayout = "E-m:e-Fi64-i64:64-i128:128-n32:64-S128-v256:256:256-v512:512:512"
target triple = "ppc64-pc-linux-gnu"

%struct.ck_fifo_spsc = type { %struct.ck_spinlock_fas, ptr, [52 x i8], %struct.ck_spinlock_fas, ptr, ptr, ptr }
%struct.ck_spinlock_fas = type { i32 }
%struct.point_s = type { i32, i32 }
%struct.ck_fifo_spsc_entry = type { ptr, ptr }

@queue = dso_local global %struct.ck_fifo_spsc zeroinitializer, align 8, !dbg !0
@.str = private unnamed_addr constant [20 x i8] c"NULL point received\00", align 1, !dbg !24
@.str.1 = private unnamed_addr constant [39 x i8] c"point != NULL && \22NULL point received\22\00", align 1, !dbg !30
@.str.2 = private unnamed_addr constant [27 x i8] c"benchmarks/ck/spsc_queue.c\00", align 1, !dbg !35
@__func__.consumer = private unnamed_addr constant [9 x i8] c"consumer\00", align 1, !dbg !40
@.str.3 = private unnamed_addr constant [21 x i8] c"point->x == point->y\00", align 1, !dbg !46
@.str.4 = private unnamed_addr constant [14 x i8] c"point->y == 1\00", align 1, !dbg !51

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @producer(ptr noundef %0) #0 !dbg !83 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !87, !DIExpression(), !88)
    #dbg_declare(ptr %3, !89, !DIExpression(), !91)
  store i32 0, ptr %3, align 4, !dbg !91
  br label %7, !dbg !92

7:                                                ; preds = %28, %1
  %8 = load i32, ptr %3, align 4, !dbg !93
  %9 = icmp slt i32 %8, 3, !dbg !95
  br i1 %9, label %10, label %31, !dbg !96

10:                                               ; preds = %7
    #dbg_declare(ptr %4, !97, !DIExpression(), !105)
  %11 = call ptr @malloc(i64 noundef 8) #4, !dbg !106
  store ptr %11, ptr %4, align 8, !dbg !105
  %12 = load ptr, ptr %4, align 8, !dbg !107
  %13 = icmp eq ptr %12, null, !dbg !109
  br i1 %13, label %14, label %15, !dbg !109

14:                                               ; preds = %10
  call void @exit(i32 noundef signext 1) #5, !dbg !110
  unreachable, !dbg !110

15:                                               ; preds = %10
  %16 = load ptr, ptr %4, align 8, !dbg !112
  %17 = getelementptr inbounds nuw %struct.point_s, ptr %16, i32 0, i32 0, !dbg !113
  store i32 1, ptr %17, align 4, !dbg !114
  %18 = load ptr, ptr %4, align 8, !dbg !115
  %19 = getelementptr inbounds nuw %struct.point_s, ptr %18, i32 0, i32 1, !dbg !116
  store i32 1, ptr %19, align 4, !dbg !117
    #dbg_declare(ptr %5, !118, !DIExpression(), !121)
  %20 = call ptr @malloc(i64 noundef 16) #4, !dbg !122
  store ptr %20, ptr %5, align 8, !dbg !121
  %21 = load ptr, ptr %5, align 8, !dbg !123
  %22 = icmp eq ptr %21, null, !dbg !125
  br i1 %22, label %23, label %25, !dbg !125

23:                                               ; preds = %15
  %24 = load ptr, ptr %4, align 8, !dbg !126
  call void @free(ptr noundef %24), !dbg !128
  call void @exit(i32 noundef signext 1) #5, !dbg !129
  unreachable, !dbg !129

25:                                               ; preds = %15
  %26 = load ptr, ptr %5, align 8, !dbg !130
  %27 = load ptr, ptr %4, align 8, !dbg !131
  call void @ck_fifo_spsc_enqueue(ptr noundef @queue, ptr noundef %26, ptr noundef %27), !dbg !132
  br label %28, !dbg !133

28:                                               ; preds = %25
  %29 = load i32, ptr %3, align 4, !dbg !134
  %30 = add nsw i32 %29, 1, !dbg !134
  store i32 %30, ptr %3, align 4, !dbg !134
  br label %7, !dbg !135, !llvm.loop !136

31:                                               ; preds = %7
    #dbg_declare(ptr %6, !139, !DIExpression(), !140)
  %32 = call ptr @malloc(i64 noundef 16) #4, !dbg !141
  store ptr %32, ptr %6, align 8, !dbg !140
  %33 = load ptr, ptr %6, align 8, !dbg !142
  %34 = icmp eq ptr %33, null, !dbg !144
  br i1 %34, label %35, label %36, !dbg !144

35:                                               ; preds = %31
  call void @exit(i32 noundef signext 1) #5, !dbg !145
  unreachable, !dbg !145

36:                                               ; preds = %31
  %37 = load ptr, ptr %6, align 8, !dbg !147
  call void @ck_fifo_spsc_enqueue(ptr noundef @queue, ptr noundef %37, ptr noundef null), !dbg !148
  ret ptr null, !dbg !149
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef signext) #2

declare void @free(ptr noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_fifo_spsc_enqueue(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 !dbg !150 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !154, !DIExpression(), !155)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !156, !DIExpression(), !157)
  store ptr %2, ptr %6, align 8
    #dbg_declare(ptr %6, !158, !DIExpression(), !159)
  %7 = load ptr, ptr %6, align 8, !dbg !160
  %8 = load ptr, ptr %5, align 8, !dbg !161
  %9 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %8, i32 0, i32 0, !dbg !162
  store ptr %7, ptr %9, align 8, !dbg !163
  %10 = load ptr, ptr %5, align 8, !dbg !164
  %11 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %10, i32 0, i32 1, !dbg !165
  store ptr null, ptr %11, align 8, !dbg !166
  call void @ck_pr_fence_store(), !dbg !167
  %12 = load ptr, ptr %4, align 8, !dbg !168
  %13 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %12, i32 0, i32 4, !dbg !169
  %14 = load ptr, ptr %13, align 8, !dbg !169
  %15 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %14, i32 0, i32 1, !dbg !170
  %16 = load ptr, ptr %5, align 8, !dbg !171
  call void @ck_pr_md_store_ptr(ptr noundef %15, ptr noundef %16), !dbg !172
  %17 = load ptr, ptr %5, align 8, !dbg !173
  %18 = load ptr, ptr %4, align 8, !dbg !174
  %19 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %18, i32 0, i32 4, !dbg !175
  store ptr %17, ptr %19, align 8, !dbg !176
  ret void, !dbg !177
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @consumer(ptr noundef %0) #0 !dbg !178 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !179, !DIExpression(), !180)
    #dbg_declare(ptr %3, !181, !DIExpression(), !182)
    #dbg_declare(ptr %4, !183, !DIExpression(), !185)
  store i32 0, ptr %4, align 4, !dbg !185
  br label %6, !dbg !186

6:                                                ; preds = %36, %1
  %7 = load i32, ptr %4, align 4, !dbg !187
  %8 = icmp slt i32 %7, 3, !dbg !189
  br i1 %8, label %9, label %39, !dbg !190

9:                                                ; preds = %6
    #dbg_declare(ptr %5, !191, !DIExpression(), !193)
  %10 = call zeroext i1 @ck_fifo_spsc_dequeue(ptr noundef @queue, ptr noundef %3), !dbg !194
  %11 = zext i1 %10 to i8, !dbg !193
  store i8 %11, ptr %5, align 1, !dbg !193
  %12 = load i8, ptr %5, align 1, !dbg !195
  %13 = trunc i8 %12 to i1, !dbg !195
  %14 = zext i1 %13 to i32, !dbg !195
  call void @__VERIFIER_assume(i32 noundef signext %14), !dbg !196
  %15 = load ptr, ptr %3, align 8, !dbg !197
  %16 = icmp ne ptr %15, null, !dbg !200
  br i1 %16, label %17, label %18, !dbg !201

17:                                               ; preds = %9
  br i1 true, label %19, label %18, !dbg !202

18:                                               ; preds = %17, %9
  call void @__assert_fail(ptr noundef @.str.1, ptr noundef @.str.2, i32 noundef signext 63, ptr noundef @__func__.consumer), !dbg !202
  br label %19, !dbg !202

19:                                               ; preds = %18, %17
  %20 = load ptr, ptr %3, align 8, !dbg !203
  %21 = getelementptr inbounds nuw %struct.point_s, ptr %20, i32 0, i32 0, !dbg !206
  %22 = load i32, ptr %21, align 4, !dbg !206
  %23 = load ptr, ptr %3, align 8, !dbg !207
  %24 = getelementptr inbounds nuw %struct.point_s, ptr %23, i32 0, i32 1, !dbg !208
  %25 = load i32, ptr %24, align 4, !dbg !208
  %26 = icmp eq i32 %22, %25, !dbg !209
  br i1 %26, label %28, label %27, !dbg !210

27:                                               ; preds = %19
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.2, i32 noundef signext 64, ptr noundef @__func__.consumer), !dbg !210
  br label %28, !dbg !210

28:                                               ; preds = %27, %19
  %29 = load ptr, ptr %3, align 8, !dbg !211
  %30 = getelementptr inbounds nuw %struct.point_s, ptr %29, i32 0, i32 1, !dbg !214
  %31 = load i32, ptr %30, align 4, !dbg !214
  %32 = icmp eq i32 %31, 1, !dbg !215
  br i1 %32, label %34, label %33, !dbg !216

33:                                               ; preds = %28
  call void @__assert_fail(ptr noundef @.str.4, ptr noundef @.str.2, i32 noundef signext 65, ptr noundef @__func__.consumer), !dbg !216
  br label %34, !dbg !216

34:                                               ; preds = %33, %28
  %35 = load ptr, ptr %3, align 8, !dbg !217
  call void @free(ptr noundef %35), !dbg !218
  br label %36, !dbg !219

36:                                               ; preds = %34
  %37 = load i32, ptr %4, align 4, !dbg !220
  %38 = add nsw i32 %37, 1, !dbg !220
  store i32 %38, ptr %4, align 4, !dbg !220
  br label %6, !dbg !221, !llvm.loop !222

39:                                               ; preds = %6
  ret ptr null, !dbg !224
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i1 @ck_fifo_spsc_dequeue(ptr noundef %0, ptr noundef %1) #0 !dbg !225 {
  %3 = alloca i1, align 1
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !228, !DIExpression(), !229)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !230, !DIExpression(), !231)
    #dbg_declare(ptr %6, !232, !DIExpression(), !233)
  %7 = load ptr, ptr %4, align 8, !dbg !234
  %8 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %7, i32 0, i32 1, !dbg !235
  %9 = load ptr, ptr %8, align 8, !dbg !235
  %10 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %9, i32 0, i32 1, !dbg !236
  %11 = call ptr @ck_pr_md_load_ptr(ptr noundef %10), !dbg !237
  store ptr %11, ptr %6, align 8, !dbg !238
  %12 = load ptr, ptr %6, align 8, !dbg !239
  %13 = icmp eq ptr %12, null, !dbg !241
  br i1 %13, label %14, label %15, !dbg !241

14:                                               ; preds = %2
  store i1 false, ptr %3, align 1, !dbg !242
  br label %23, !dbg !242

15:                                               ; preds = %2
  %16 = load ptr, ptr %5, align 8, !dbg !243
  %17 = load ptr, ptr %6, align 8, !dbg !244
  %18 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %17, i32 0, i32 0, !dbg !245
  %19 = load ptr, ptr %18, align 8, !dbg !245
  call void @ck_pr_md_store_ptr(ptr noundef %16, ptr noundef %19), !dbg !246
  call void @ck_pr_fence_store(), !dbg !247
  %20 = load ptr, ptr %4, align 8, !dbg !248
  %21 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %20, i32 0, i32 1, !dbg !249
  %22 = load ptr, ptr %6, align 8, !dbg !250
  call void @ck_pr_md_store_ptr(ptr noundef %21, ptr noundef %22), !dbg !251
  store i1 true, ptr %3, align 1, !dbg !252
  br label %23, !dbg !252

23:                                               ; preds = %15, %14
  %24 = load i1, ptr %3, align 1, !dbg !253
  ret i1 %24, !dbg !253
}

declare void @__VERIFIER_assume(i32 noundef signext) #3

declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef signext, ptr noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local signext i32 @main() #0 !dbg !254 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !257, !DIExpression(), !263)
    #dbg_declare(ptr %3, !264, !DIExpression(), !265)
  %6 = call ptr @malloc(i64 noundef 16) #4, !dbg !266
  store ptr %6, ptr %3, align 8, !dbg !265
  %7 = load ptr, ptr %3, align 8, !dbg !267
  %8 = icmp eq ptr %7, null, !dbg !269
  br i1 %8, label %9, label %10, !dbg !269

9:                                                ; preds = %0
  call void @exit(i32 noundef signext 1) #5, !dbg !270
  unreachable, !dbg !270

10:                                               ; preds = %0
  %11 = load ptr, ptr %3, align 8, !dbg !272
  call void @ck_fifo_spsc_init(ptr noundef @queue, ptr noundef %11), !dbg !273
  %12 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 0, !dbg !274
  %13 = call signext i32 @pthread_create(ptr noundef %12, ptr noundef null, ptr noundef @producer, ptr noundef null), !dbg !276
  %14 = icmp ne i32 %13, 0, !dbg !277
  br i1 %14, label %19, label %15, !dbg !278

15:                                               ; preds = %10
  %16 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 1, !dbg !279
  %17 = call signext i32 @pthread_create(ptr noundef %16, ptr noundef null, ptr noundef @consumer, ptr noundef null), !dbg !280
  %18 = icmp ne i32 %17, 0, !dbg !281
  br i1 %18, label %19, label %20, !dbg !278

19:                                               ; preds = %15, %10
  call void @exit(i32 noundef signext 1) #5, !dbg !282
  unreachable, !dbg !282

20:                                               ; preds = %15
    #dbg_declare(ptr %4, !284, !DIExpression(), !286)
  store i32 0, ptr %4, align 4, !dbg !286
  br label %21, !dbg !287

21:                                               ; preds = %30, %20
  %22 = load i32, ptr %4, align 4, !dbg !288
  %23 = icmp slt i32 %22, 2, !dbg !290
  br i1 %23, label %24, label %33, !dbg !291

24:                                               ; preds = %21
  %25 = load i32, ptr %4, align 4, !dbg !292
  %26 = sext i32 %25 to i64, !dbg !294
  %27 = getelementptr inbounds [2 x ptr], ptr %2, i64 0, i64 %26, !dbg !294
  %28 = load ptr, ptr %27, align 8, !dbg !294
  %29 = call signext i32 @pthread_join(ptr noundef %28, ptr noundef null), !dbg !295
  br label %30, !dbg !296

30:                                               ; preds = %24
  %31 = load i32, ptr %4, align 4, !dbg !297
  %32 = add nsw i32 %31, 1, !dbg !297
  store i32 %32, ptr %4, align 4, !dbg !297
  br label %21, !dbg !298, !llvm.loop !299

33:                                               ; preds = %21
    #dbg_declare(ptr %5, !301, !DIExpression(), !302)
  call void @ck_fifo_spsc_deinit(ptr noundef @queue, ptr noundef %5), !dbg !303
  %34 = load ptr, ptr %5, align 8, !dbg !304
  call void @free(ptr noundef %34), !dbg !305
  ret i32 0, !dbg !306
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_fifo_spsc_init(ptr noundef %0, ptr noundef %1) #0 !dbg !307 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !310, !DIExpression(), !311)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !312, !DIExpression(), !313)
  %5 = load ptr, ptr %3, align 8, !dbg !314
  %6 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %5, i32 0, i32 0, !dbg !315
  call void @ck_spinlock_fas_init(ptr noundef %6), !dbg !316
  %7 = load ptr, ptr %3, align 8, !dbg !317
  %8 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %7, i32 0, i32 3, !dbg !318
  call void @ck_spinlock_fas_init(ptr noundef %8), !dbg !319
  %9 = load ptr, ptr %4, align 8, !dbg !320
  %10 = getelementptr inbounds nuw %struct.ck_fifo_spsc_entry, ptr %9, i32 0, i32 1, !dbg !321
  store ptr null, ptr %10, align 8, !dbg !322
  %11 = load ptr, ptr %4, align 8, !dbg !323
  %12 = load ptr, ptr %3, align 8, !dbg !324
  %13 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %12, i32 0, i32 6, !dbg !325
  store ptr %11, ptr %13, align 8, !dbg !326
  %14 = load ptr, ptr %3, align 8, !dbg !327
  %15 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %14, i32 0, i32 5, !dbg !328
  store ptr %11, ptr %15, align 8, !dbg !329
  %16 = load ptr, ptr %3, align 8, !dbg !330
  %17 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %16, i32 0, i32 4, !dbg !331
  store ptr %11, ptr %17, align 8, !dbg !332
  %18 = load ptr, ptr %3, align 8, !dbg !333
  %19 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %18, i32 0, i32 1, !dbg !334
  store ptr %11, ptr %19, align 8, !dbg !335
  ret void, !dbg !336
}

declare signext i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare signext i32 @pthread_join(ptr noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_fifo_spsc_deinit(ptr noundef %0, ptr noundef %1) #0 !dbg !337 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !341, !DIExpression(), !342)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !343, !DIExpression(), !344)
  %5 = load ptr, ptr %3, align 8, !dbg !345
  %6 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %5, i32 0, i32 6, !dbg !346
  %7 = load ptr, ptr %6, align 8, !dbg !346
  %8 = load ptr, ptr %4, align 8, !dbg !347
  store ptr %7, ptr %8, align 8, !dbg !348
  %9 = load ptr, ptr %3, align 8, !dbg !349
  %10 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %9, i32 0, i32 4, !dbg !350
  store ptr null, ptr %10, align 8, !dbg !351
  %11 = load ptr, ptr %3, align 8, !dbg !352
  %12 = getelementptr inbounds nuw %struct.ck_fifo_spsc, ptr %11, i32 0, i32 1, !dbg !353
  store ptr null, ptr %12, align 8, !dbg !354
  ret void, !dbg !355
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_store() #0 !dbg !356 {
  call void @ck_pr_fence_strict_store(), !dbg !360
  ret void, !dbg !360
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_md_store_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !361 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !367, !DIExpression(), !368)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !369, !DIExpression(), !368)
  %5 = load ptr, ptr %3, align 8, !dbg !368
  %6 = load ptr, ptr %4, align 8, !dbg !368
  call void asm sideeffect "std${0:U}${0:X} $1, $0", "=*m,r,~{memory}"(ptr elementtype(i64) %5, ptr %6) #6, !dbg !368, !srcloc !370
  ret void, !dbg !368
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_store() #0 !dbg !371 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !372, !srcloc !373
  ret void, !dbg !372
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 !dbg !374 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !377, !DIExpression(), !378)
    #dbg_declare(ptr %3, !379, !DIExpression(), !378)
  %4 = load ptr, ptr %2, align 8, !dbg !378
  %5 = call ptr asm sideeffect "ld${1:U}${1:X} $0, $1", "=r,*m,~{memory}"(ptr elementtype(i64) %4) #6, !dbg !378, !srcloc !380
  store ptr %5, ptr %3, align 8, !dbg !378
  %6 = load ptr, ptr %3, align 8, !dbg !378
  ret ptr %6, !dbg !378
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

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #4 = { allocsize(0) }
attributes #5 = { noreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!75, !76, !77, !78, !79, !80, !81}
!llvm.ident = !{!82}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "queue", scope: !2, file: !3, line: 21, type: !56, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !23, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/spsc_queue.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "7bec67ad4368bbed4d80bc0489a6ba84")
!4 = !{!5, !6, !7, !8, !12, !18, !21}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !10, line: 24, baseType: !11)
!10 = !DIFile(filename: "include/libc/stdint.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "027aa838071dee39e5261b0fdecb37d3")
!11 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_fifo_spsc_entry", file: !14, line: 39, size: 128, elements: !15)
!14 = !DIFile(filename: "../ck/include/ck_fifo.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "252298fd696ccc816ddf53f92a49d2df")
!15 = !{!16, !17}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !13, file: !14, line: 40, baseType: !5, size: 64)
!17 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !13, file: !14, line: 41, baseType: !12, size: 64, offset: 64)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !19, line: 4, baseType: !20)
!19 = !DIFile(filename: "include/libc/stdbool.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6e643322591bab80343344357c642cba")
!20 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!22 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !9)
!23 = !{!24, !30, !35, !40, !46, !51, !0}
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !26, isLocal: true, isDefinition: true)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 160, elements: !28)
!27 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!28 = !{!29}
!29 = !DISubrange(count: 20)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 312, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 39)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !37, isLocal: true, isDefinition: true)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 216, elements: !38)
!38 = !{!39}
!39 = !DISubrange(count: 27)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !42, isLocal: true, isDefinition: true)
!42 = !DICompositeType(tag: DW_TAG_array_type, baseType: !43, size: 72, elements: !44)
!43 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !27)
!44 = !{!45}
!45 = !DISubrange(count: 9)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(scope: null, file: !3, line: 64, type: !48, isLocal: true, isDefinition: true)
!48 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 168, elements: !49)
!49 = !{!50}
!50 = !DISubrange(count: 21)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(scope: null, file: !3, line: 65, type: !53, isLocal: true, isDefinition: true)
!53 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 112, elements: !54)
!54 = !{!55}
!55 = !DISubrange(count: 14)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_fifo_spsc_t", file: !14, line: 54, baseType: !57)
!57 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_fifo_spsc", file: !14, line: 45, size: 768, elements: !58)
!58 = !{!59, !66, !67, !71, !72, !73, !74}
!59 = !DIDerivedType(tag: DW_TAG_member, name: "m_head", scope: !57, file: !14, line: 46, baseType: !60, size: 32)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_fas_t", file: !61, line: 42, baseType: !62)
!61 = !DIFile(filename: "../ck/include/spinlock/fas.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "999805093e3ea65ae15690fa7c76e04b")
!62 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_fas", file: !61, line: 39, size: 32, elements: !63)
!63 = !{!64}
!64 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !62, file: !61, line: 40, baseType: !65, size: 32)
!65 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !57, file: !14, line: 47, baseType: !12, size: 64, offset: 64)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !57, file: !14, line: 48, baseType: !68, size: 416, offset: 128)
!68 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 416, elements: !69)
!69 = !{!70}
!70 = !DISubrange(count: 52)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "m_tail", scope: !57, file: !14, line: 49, baseType: !60, size: 32, offset: 544)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !57, file: !14, line: 50, baseType: !12, size: 64, offset: 576)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "head_snapshot", scope: !57, file: !14, line: 51, baseType: !12, size: 64, offset: 640)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "garbage", scope: !57, file: !14, line: 52, baseType: !12, size: 64, offset: 704)
!75 = !{i32 7, !"Dwarf Version", i32 5}
!76 = !{i32 2, !"Debug Info Version", i32 3}
!77 = !{i32 1, !"wchar_size", i32 4}
!78 = !{i32 8, !"PIC Level", i32 2}
!79 = !{i32 7, !"PIE Level", i32 2}
!80 = !{i32 7, !"uwtable", i32 2}
!81 = !{i32 7, !"frame-pointer", i32 2}
!82 = !{!"Homebrew clang version 22.1.8"}
!83 = distinct !DISubprogram(name: "producer", scope: !3, file: !3, line: 23, type: !84, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!84 = !DISubroutineType(types: !85)
!85 = !{!5, !5}
!86 = !{}
!87 = !DILocalVariable(name: "arg", arg: 1, scope: !83, file: !3, line: 23, type: !5)
!88 = !DILocation(line: 23, column: 22, scope: !83)
!89 = !DILocalVariable(name: "i", scope: !90, file: !3, line: 25, type: !6)
!90 = distinct !DILexicalBlock(scope: !83, file: !3, line: 25, column: 5)
!91 = !DILocation(line: 25, column: 14, scope: !90)
!92 = !DILocation(line: 25, column: 10, scope: !90)
!93 = !DILocation(line: 25, column: 21, scope: !94)
!94 = distinct !DILexicalBlock(scope: !90, file: !3, line: 25, column: 5)
!95 = !DILocation(line: 25, column: 23, scope: !94)
!96 = !DILocation(line: 25, column: 5, scope: !90)
!97 = !DILocalVariable(name: "point", scope: !98, file: !3, line: 27, type: !99)
!98 = distinct !DILexicalBlock(scope: !94, file: !3, line: 26, column: 5)
!99 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64)
!100 = !DIDerivedType(tag: DW_TAG_typedef, name: "point_t", file: !3, line: 19, baseType: !101)
!101 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "point_s", file: !3, line: 15, size: 64, elements: !102)
!102 = !{!103, !104}
!103 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !101, file: !3, line: 17, baseType: !65, size: 32)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !101, file: !3, line: 18, baseType: !65, size: 32, offset: 32)
!105 = !DILocation(line: 27, column: 18, scope: !98)
!106 = !DILocation(line: 27, column: 26, scope: !98)
!107 = !DILocation(line: 28, column: 13, scope: !108)
!108 = distinct !DILexicalBlock(scope: !98, file: !3, line: 28, column: 13)
!109 = !DILocation(line: 28, column: 19, scope: !108)
!110 = !DILocation(line: 30, column: 13, scope: !111)
!111 = distinct !DILexicalBlock(scope: !108, file: !3, line: 29, column: 9)
!112 = !DILocation(line: 33, column: 9, scope: !98)
!113 = !DILocation(line: 33, column: 16, scope: !98)
!114 = !DILocation(line: 33, column: 18, scope: !98)
!115 = !DILocation(line: 34, column: 9, scope: !98)
!116 = !DILocation(line: 34, column: 16, scope: !98)
!117 = !DILocation(line: 34, column: 18, scope: !98)
!118 = !DILocalVariable(name: "entry", scope: !98, file: !3, line: 36, type: !119)
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !120, size: 64)
!120 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_fifo_spsc_entry_t", file: !14, line: 43, baseType: !13)
!121 = !DILocation(line: 36, column: 31, scope: !98)
!122 = !DILocation(line: 36, column: 39, scope: !98)
!123 = !DILocation(line: 37, column: 13, scope: !124)
!124 = distinct !DILexicalBlock(scope: !98, file: !3, line: 37, column: 13)
!125 = !DILocation(line: 37, column: 19, scope: !124)
!126 = !DILocation(line: 39, column: 18, scope: !127)
!127 = distinct !DILexicalBlock(scope: !124, file: !3, line: 38, column: 9)
!128 = !DILocation(line: 39, column: 13, scope: !127)
!129 = !DILocation(line: 40, column: 13, scope: !127)
!130 = !DILocation(line: 43, column: 38, scope: !98)
!131 = !DILocation(line: 43, column: 45, scope: !98)
!132 = !DILocation(line: 43, column: 9, scope: !98)
!133 = !DILocation(line: 44, column: 5, scope: !98)
!134 = !DILocation(line: 25, column: 45, scope: !94)
!135 = !DILocation(line: 25, column: 5, scope: !94)
!136 = distinct !{!136, !96, !137, !138}
!137 = !DILocation(line: 44, column: 5, scope: !90)
!138 = !{!"llvm.loop.mustprogress"}
!139 = !DILocalVariable(name: "entry", scope: !83, file: !3, line: 46, type: !119)
!140 = !DILocation(line: 46, column: 27, scope: !83)
!141 = !DILocation(line: 46, column: 35, scope: !83)
!142 = !DILocation(line: 47, column: 9, scope: !143)
!143 = distinct !DILexicalBlock(scope: !83, file: !3, line: 47, column: 9)
!144 = !DILocation(line: 47, column: 15, scope: !143)
!145 = !DILocation(line: 49, column: 9, scope: !146)
!146 = distinct !DILexicalBlock(scope: !143, file: !3, line: 48, column: 5)
!147 = !DILocation(line: 51, column: 34, scope: !83)
!148 = !DILocation(line: 51, column: 5, scope: !83)
!149 = !DILocation(line: 53, column: 5, scope: !83)
!150 = distinct !DISubprogram(name: "ck_fifo_spsc_enqueue", scope: !14, file: !14, line: 124, type: !151, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !86)
!151 = !DISubroutineType(types: !152)
!152 = !{null, !153, !12, !5}
!153 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!154 = !DILocalVariable(name: "fifo", arg: 1, scope: !150, file: !14, line: 124, type: !153)
!155 = !DILocation(line: 124, column: 43, scope: !150)
!156 = !DILocalVariable(name: "entry", arg: 2, scope: !150, file: !14, line: 125, type: !12)
!157 = !DILocation(line: 125, column: 35, scope: !150)
!158 = !DILocalVariable(name: "value", arg: 3, scope: !150, file: !14, line: 126, type: !5)
!159 = !DILocation(line: 126, column: 14, scope: !150)
!160 = !DILocation(line: 129, column: 17, scope: !150)
!161 = !DILocation(line: 129, column: 2, scope: !150)
!162 = !DILocation(line: 129, column: 9, scope: !150)
!163 = !DILocation(line: 129, column: 15, scope: !150)
!164 = !DILocation(line: 130, column: 2, scope: !150)
!165 = !DILocation(line: 130, column: 9, scope: !150)
!166 = !DILocation(line: 130, column: 14, scope: !150)
!167 = !DILocation(line: 133, column: 2, scope: !150)
!168 = !DILocation(line: 134, column: 19, scope: !150)
!169 = !DILocation(line: 134, column: 25, scope: !150)
!170 = !DILocation(line: 134, column: 31, scope: !150)
!171 = !DILocation(line: 134, column: 37, scope: !150)
!172 = !DILocation(line: 134, column: 2, scope: !150)
!173 = !DILocation(line: 135, column: 15, scope: !150)
!174 = !DILocation(line: 135, column: 2, scope: !150)
!175 = !DILocation(line: 135, column: 8, scope: !150)
!176 = !DILocation(line: 135, column: 13, scope: !150)
!177 = !DILocation(line: 136, column: 2, scope: !150)
!178 = distinct !DISubprogram(name: "consumer", scope: !3, file: !3, line: 55, type: !84, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!179 = !DILocalVariable(name: "arg", arg: 1, scope: !178, file: !3, line: 55, type: !5)
!180 = !DILocation(line: 55, column: 22, scope: !178)
!181 = !DILocalVariable(name: "point", scope: !178, file: !3, line: 57, type: !99)
!182 = !DILocation(line: 57, column: 14, scope: !178)
!183 = !DILocalVariable(name: "i", scope: !184, file: !3, line: 59, type: !6)
!184 = distinct !DILexicalBlock(scope: !178, file: !3, line: 59, column: 5)
!185 = !DILocation(line: 59, column: 14, scope: !184)
!186 = !DILocation(line: 59, column: 10, scope: !184)
!187 = !DILocation(line: 59, column: 21, scope: !188)
!188 = distinct !DILexicalBlock(scope: !184, file: !3, line: 59, column: 5)
!189 = !DILocation(line: 59, column: 23, scope: !188)
!190 = !DILocation(line: 59, column: 5, scope: !184)
!191 = !DILocalVariable(name: "res", scope: !192, file: !3, line: 61, type: !18)
!192 = distinct !DILexicalBlock(scope: !188, file: !3, line: 60, column: 5)
!193 = !DILocation(line: 61, column: 14, scope: !192)
!194 = !DILocation(line: 61, column: 20, scope: !192)
!195 = !DILocation(line: 62, column: 27, scope: !192)
!196 = !DILocation(line: 62, column: 9, scope: !192)
!197 = !DILocation(line: 63, column: 16, scope: !198)
!198 = distinct !DILexicalBlock(scope: !199, file: !3, line: 63, column: 9)
!199 = distinct !DILexicalBlock(scope: !192, file: !3, line: 63, column: 9)
!200 = !DILocation(line: 63, column: 22, scope: !198)
!201 = !DILocation(line: 63, column: 30, scope: !198)
!202 = !DILocation(line: 63, column: 9, scope: !198)
!203 = !DILocation(line: 64, column: 16, scope: !204)
!204 = distinct !DILexicalBlock(scope: !205, file: !3, line: 64, column: 9)
!205 = distinct !DILexicalBlock(scope: !192, file: !3, line: 64, column: 9)
!206 = !DILocation(line: 64, column: 23, scope: !204)
!207 = !DILocation(line: 64, column: 28, scope: !204)
!208 = !DILocation(line: 64, column: 35, scope: !204)
!209 = !DILocation(line: 64, column: 25, scope: !204)
!210 = !DILocation(line: 64, column: 9, scope: !204)
!211 = !DILocation(line: 65, column: 16, scope: !212)
!212 = distinct !DILexicalBlock(scope: !213, file: !3, line: 65, column: 9)
!213 = distinct !DILexicalBlock(scope: !192, file: !3, line: 65, column: 9)
!214 = !DILocation(line: 65, column: 23, scope: !212)
!215 = !DILocation(line: 65, column: 25, scope: !212)
!216 = !DILocation(line: 65, column: 9, scope: !212)
!217 = !DILocation(line: 67, column: 14, scope: !192)
!218 = !DILocation(line: 67, column: 9, scope: !192)
!219 = !DILocation(line: 68, column: 5, scope: !192)
!220 = !DILocation(line: 59, column: 45, scope: !188)
!221 = !DILocation(line: 59, column: 5, scope: !188)
!222 = distinct !{!222, !190, !223, !138}
!223 = !DILocation(line: 68, column: 5, scope: !184)
!224 = !DILocation(line: 70, column: 5, scope: !178)
!225 = distinct !DISubprogram(name: "ck_fifo_spsc_dequeue", scope: !14, file: !14, line: 140, type: !226, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !86)
!226 = !DISubroutineType(types: !227)
!227 = !{!18, !153, !5}
!228 = !DILocalVariable(name: "fifo", arg: 1, scope: !225, file: !14, line: 140, type: !153)
!229 = !DILocation(line: 140, column: 43, scope: !225)
!230 = !DILocalVariable(name: "value", arg: 2, scope: !225, file: !14, line: 140, type: !5)
!231 = !DILocation(line: 140, column: 55, scope: !225)
!232 = !DILocalVariable(name: "entry", scope: !225, file: !14, line: 142, type: !12)
!233 = !DILocation(line: 142, column: 29, scope: !225)
!234 = !DILocation(line: 149, column: 26, scope: !225)
!235 = !DILocation(line: 149, column: 32, scope: !225)
!236 = !DILocation(line: 149, column: 38, scope: !225)
!237 = !DILocation(line: 149, column: 10, scope: !225)
!238 = !DILocation(line: 149, column: 8, scope: !225)
!239 = !DILocation(line: 150, column: 6, scope: !240)
!240 = distinct !DILexicalBlock(scope: !225, file: !14, line: 150, column: 6)
!241 = !DILocation(line: 150, column: 12, scope: !240)
!242 = !DILocation(line: 151, column: 3, scope: !240)
!243 = !DILocation(line: 154, column: 25, scope: !225)
!244 = !DILocation(line: 154, column: 32, scope: !225)
!245 = !DILocation(line: 154, column: 39, scope: !225)
!246 = !DILocation(line: 154, column: 2, scope: !225)
!247 = !DILocation(line: 155, column: 2, scope: !225)
!248 = !DILocation(line: 156, column: 19, scope: !225)
!249 = !DILocation(line: 156, column: 25, scope: !225)
!250 = !DILocation(line: 156, column: 31, scope: !225)
!251 = !DILocation(line: 156, column: 2, scope: !225)
!252 = !DILocation(line: 157, column: 2, scope: !225)
!253 = !DILocation(line: 158, column: 1, scope: !225)
!254 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 73, type: !255, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !86)
!255 = !DISubroutineType(types: !256)
!256 = !{!6}
!257 = !DILocalVariable(name: "threads", scope: !254, file: !3, line: 75, type: !258)
!258 = !DICompositeType(tag: DW_TAG_array_type, baseType: !259, size: 128, elements: !261)
!259 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !260, line: 2, baseType: !5)
!260 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!261 = !{!262}
!262 = !DISubrange(count: 2)
!263 = !DILocation(line: 75, column: 15, scope: !254)
!264 = !DILocalVariable(name: "initial_entry", scope: !254, file: !3, line: 77, type: !119)
!265 = !DILocation(line: 77, column: 27, scope: !254)
!266 = !DILocation(line: 77, column: 43, scope: !254)
!267 = !DILocation(line: 78, column: 9, scope: !268)
!268 = distinct !DILexicalBlock(scope: !254, file: !3, line: 78, column: 9)
!269 = !DILocation(line: 78, column: 23, scope: !268)
!270 = !DILocation(line: 80, column: 9, scope: !271)
!271 = distinct !DILexicalBlock(scope: !268, file: !3, line: 79, column: 5)
!272 = !DILocation(line: 82, column: 31, scope: !254)
!273 = !DILocation(line: 82, column: 5, scope: !254)
!274 = !DILocation(line: 84, column: 25, scope: !275)
!275 = distinct !DILexicalBlock(scope: !254, file: !3, line: 84, column: 9)
!276 = !DILocation(line: 84, column: 9, scope: !275)
!277 = !DILocation(line: 84, column: 59, scope: !275)
!278 = !DILocation(line: 84, column: 64, scope: !275)
!279 = !DILocation(line: 85, column: 25, scope: !275)
!280 = !DILocation(line: 85, column: 9, scope: !275)
!281 = !DILocation(line: 85, column: 59, scope: !275)
!282 = !DILocation(line: 87, column: 9, scope: !283)
!283 = distinct !DILexicalBlock(scope: !275, file: !3, line: 86, column: 5)
!284 = !DILocalVariable(name: "i", scope: !285, file: !3, line: 90, type: !6)
!285 = distinct !DILexicalBlock(scope: !254, file: !3, line: 90, column: 5)
!286 = !DILocation(line: 90, column: 14, scope: !285)
!287 = !DILocation(line: 90, column: 10, scope: !285)
!288 = !DILocation(line: 90, column: 21, scope: !289)
!289 = distinct !DILexicalBlock(scope: !285, file: !3, line: 90, column: 5)
!290 = !DILocation(line: 90, column: 23, scope: !289)
!291 = !DILocation(line: 90, column: 5, scope: !285)
!292 = !DILocation(line: 92, column: 30, scope: !293)
!293 = distinct !DILexicalBlock(scope: !289, file: !3, line: 91, column: 5)
!294 = !DILocation(line: 92, column: 22, scope: !293)
!295 = !DILocation(line: 92, column: 9, scope: !293)
!296 = !DILocation(line: 93, column: 5, scope: !293)
!297 = !DILocation(line: 90, column: 36, scope: !289)
!298 = !DILocation(line: 90, column: 5, scope: !289)
!299 = distinct !{!299, !291, !300, !138}
!300 = !DILocation(line: 93, column: 5, scope: !285)
!301 = !DILocalVariable(name: "garbage", scope: !254, file: !3, line: 95, type: !119)
!302 = !DILocation(line: 95, column: 27, scope: !254)
!303 = !DILocation(line: 96, column: 5, scope: !254)
!304 = !DILocation(line: 97, column: 10, scope: !254)
!305 = !DILocation(line: 97, column: 5, scope: !254)
!306 = !DILocation(line: 99, column: 5, scope: !254)
!307 = distinct !DISubprogram(name: "ck_fifo_spsc_init", scope: !14, file: !14, line: 103, type: !308, scopeLine: 104, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !86)
!308 = !DISubroutineType(types: !309)
!309 = !{null, !153, !12}
!310 = !DILocalVariable(name: "fifo", arg: 1, scope: !307, file: !14, line: 103, type: !153)
!311 = !DILocation(line: 103, column: 40, scope: !307)
!312 = !DILocalVariable(name: "stub", arg: 2, scope: !307, file: !14, line: 103, type: !12)
!313 = !DILocation(line: 103, column: 73, scope: !307)
!314 = !DILocation(line: 106, column: 20, scope: !307)
!315 = !DILocation(line: 106, column: 26, scope: !307)
!316 = !DILocation(line: 106, column: 2, scope: !307)
!317 = !DILocation(line: 107, column: 20, scope: !307)
!318 = !DILocation(line: 107, column: 26, scope: !307)
!319 = !DILocation(line: 107, column: 2, scope: !307)
!320 = !DILocation(line: 109, column: 2, scope: !307)
!321 = !DILocation(line: 109, column: 8, scope: !307)
!322 = !DILocation(line: 109, column: 13, scope: !307)
!323 = !DILocation(line: 110, column: 66, scope: !307)
!324 = !DILocation(line: 110, column: 50, scope: !307)
!325 = !DILocation(line: 110, column: 56, scope: !307)
!326 = !DILocation(line: 110, column: 64, scope: !307)
!327 = !DILocation(line: 110, column: 28, scope: !307)
!328 = !DILocation(line: 110, column: 34, scope: !307)
!329 = !DILocation(line: 110, column: 48, scope: !307)
!330 = !DILocation(line: 110, column: 15, scope: !307)
!331 = !DILocation(line: 110, column: 21, scope: !307)
!332 = !DILocation(line: 110, column: 26, scope: !307)
!333 = !DILocation(line: 110, column: 2, scope: !307)
!334 = !DILocation(line: 110, column: 8, scope: !307)
!335 = !DILocation(line: 110, column: 13, scope: !307)
!336 = !DILocation(line: 111, column: 2, scope: !307)
!337 = distinct !DISubprogram(name: "ck_fifo_spsc_deinit", scope: !14, file: !14, line: 115, type: !338, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !86)
!338 = !DISubroutineType(types: !339)
!339 = !{null, !153, !340}
!340 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!341 = !DILocalVariable(name: "fifo", arg: 1, scope: !337, file: !14, line: 115, type: !153)
!342 = !DILocation(line: 115, column: 42, scope: !337)
!343 = !DILocalVariable(name: "garbage", arg: 2, scope: !337, file: !14, line: 115, type: !340)
!344 = !DILocation(line: 115, column: 76, scope: !337)
!345 = !DILocation(line: 118, column: 13, scope: !337)
!346 = !DILocation(line: 118, column: 19, scope: !337)
!347 = !DILocation(line: 118, column: 3, scope: !337)
!348 = !DILocation(line: 118, column: 11, scope: !337)
!349 = !DILocation(line: 119, column: 15, scope: !337)
!350 = !DILocation(line: 119, column: 21, scope: !337)
!351 = !DILocation(line: 119, column: 26, scope: !337)
!352 = !DILocation(line: 119, column: 2, scope: !337)
!353 = !DILocation(line: 119, column: 8, scope: !337)
!354 = !DILocation(line: 119, column: 13, scope: !337)
!355 = !DILocation(line: 120, column: 2, scope: !337)
!356 = distinct !DISubprogram(name: "ck_pr_fence_store", scope: !357, file: !357, line: 117, type: !358, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!357 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!358 = !DISubroutineType(types: !359)
!359 = !{null}
!360 = !DILocation(line: 117, column: 1, scope: !356)
!361 = distinct !DISubprogram(name: "ck_pr_md_store_ptr", scope: !362, file: !362, line: 133, type: !363, scopeLine: 133, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !86)
!362 = !DIFile(filename: "../ck/include/gcc/ppc64/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "8952bb109540f13c2aa63ce3890cafa9")
!363 = !DISubroutineType(types: !364)
!364 = !{null, !5, !365}
!365 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !366, size: 64)
!366 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!367 = !DILocalVariable(name: "target", arg: 1, scope: !361, file: !362, line: 133, type: !5)
!368 = !DILocation(line: 133, column: 1, scope: !361)
!369 = !DILocalVariable(name: "v", arg: 2, scope: !361, file: !362, line: 133, type: !365)
!370 = !{i64 2147594582}
!371 = distinct !DISubprogram(name: "ck_pr_fence_strict_store", scope: !362, file: !362, line: 78, type: !358, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!372 = !DILocation(line: 78, column: 1, scope: !371)
!373 = !{i64 2147588554}
!374 = distinct !DISubprogram(name: "ck_pr_md_load_ptr", scope: !362, file: !362, line: 103, type: !375, scopeLine: 103, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !86)
!375 = !DISubroutineType(types: !376)
!376 = !{!5, !365}
!377 = !DILocalVariable(name: "target", arg: 1, scope: !374, file: !362, line: 103, type: !365)
!378 = !DILocation(line: 103, column: 1, scope: !374)
!379 = !DILocalVariable(name: "r", scope: !374, file: !362, line: 103, type: !5)
!380 = !{i64 2147590690}
!381 = distinct !DISubprogram(name: "ck_spinlock_fas_init", scope: !61, file: !61, line: 47, type: !382, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !86)
!382 = !DISubroutineType(types: !383)
!383 = !{null, !384}
!384 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!385 = !DILocalVariable(name: "lock", arg: 1, scope: !381, file: !61, line: 47, type: !384)
!386 = !DILocation(line: 47, column: 46, scope: !381)
!387 = !DILocation(line: 50, column: 2, scope: !381)
!388 = !DILocation(line: 50, column: 8, scope: !381)
!389 = !DILocation(line: 50, column: 14, scope: !381)
!390 = !DILocation(line: 51, column: 2, scope: !381)
!391 = !DILocation(line: 52, column: 2, scope: !381)
!392 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !393, file: !393, line: 37, type: !358, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!393 = !DIFile(filename: "../ck/include/gcc/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!394 = !DILocation(line: 40, column: 2, scope: !392)
!395 = !{i64 147423}
!396 = !DILocation(line: 41, column: 2, scope: !392)
