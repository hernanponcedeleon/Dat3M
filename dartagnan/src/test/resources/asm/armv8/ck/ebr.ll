; ModuleID = 'benchmarks/ck/ebr.c'
source_filename = "benchmarks/ck/ebr.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv8a-pc-linux-gnu"

%struct.ck_epoch = type { i32, i32, %struct.ck_stack }
%struct.ck_stack = type { ptr, ptr }
%struct.ck_epoch_record = type { %struct.ck_stack_entry, ptr, i32, i32, i32, [44 x i8], %struct.anon, i32, i32, i32, ptr, [4 x %struct.ck_stack] }
%struct.ck_stack_entry = type { ptr }
%struct.anon = type { [2 x %struct.ck_epoch_ref] }
%struct.ck_epoch_ref = type { i32, i32 }
%struct.ck_epoch_section = type { i32 }
%struct.ck_epoch_entry = type { ptr, %struct.ck_stack_entry }

@stack_epoch = internal global %struct.ck_epoch zeroinitializer, align 4, !dbg !0
@records = dso_local global [4 x %struct.ck_epoch_record] zeroinitializer, align 64, !dbg !79
@.str = private unnamed_addr constant [41 x i8] c"!(local_epoch == 1 && global_epoch == 3)\00", align 1, !dbg !82
@.str.1 = private unnamed_addr constant [20 x i8] c"benchmarks/ck/ebr.c\00", align 1, !dbg !87
@__func__.thread = private unnamed_addr constant [7 x i8] c"thread\00", align 1, !dbg !92

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc zeroext i1 @_ck_epoch_delref(ptr noundef %0, ptr noundef %1) #0 !dbg !107 {
  %3 = alloca i1, align 1
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  %7 = alloca ptr, align 4
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 4
    #dbg_declare(ptr %4, !115, !DIExpression(), !116)
  store ptr %1, ptr %5, align 4
    #dbg_declare(ptr %5, !117, !DIExpression(), !118)
    #dbg_declare(ptr %6, !119, !DIExpression(), !121)
    #dbg_declare(ptr %7, !122, !DIExpression(), !123)
    #dbg_declare(ptr %8, !124, !DIExpression(), !125)
  %9 = load ptr, ptr %5, align 4, !dbg !126
  %10 = getelementptr inbounds nuw %struct.ck_epoch_section, ptr %9, i32 0, i32 0, !dbg !127
  %11 = load i32, ptr %10, align 4, !dbg !127
  store i32 %11, ptr %8, align 4, !dbg !125
  %12 = load ptr, ptr %4, align 4, !dbg !128
  %13 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %12, i32 0, i32 6, !dbg !129
  %14 = getelementptr inbounds nuw %struct.anon, ptr %13, i32 0, i32 0, !dbg !130
  %15 = load i32, ptr %8, align 4, !dbg !131
  %16 = getelementptr inbounds nuw [2 x %struct.ck_epoch_ref], ptr %14, i32 0, i32 %15, !dbg !128
  store ptr %16, ptr %6, align 4, !dbg !132
  %17 = load ptr, ptr %6, align 4, !dbg !133
  %18 = getelementptr inbounds nuw %struct.ck_epoch_ref, ptr %17, i32 0, i32 1, !dbg !134
  %19 = load i32, ptr %18, align 4, !dbg !135
  %20 = add i32 %19, -1, !dbg !135
  store i32 %20, ptr %18, align 4, !dbg !135
  %21 = load ptr, ptr %6, align 4, !dbg !136
  %22 = getelementptr inbounds nuw %struct.ck_epoch_ref, ptr %21, i32 0, i32 1, !dbg !138
  %23 = load i32, ptr %22, align 4, !dbg !138
  %24 = icmp ugt i32 %23, 0, !dbg !139
  br i1 %24, label %25, label %26, !dbg !139

25:                                               ; preds = %2
  store i1 false, ptr %3, align 1, !dbg !140
  br label %54, !dbg !140

26:                                               ; preds = %2
  %27 = load ptr, ptr %4, align 4, !dbg !141
  %28 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %27, i32 0, i32 6, !dbg !142
  %29 = getelementptr inbounds nuw %struct.anon, ptr %28, i32 0, i32 0, !dbg !143
  %30 = load i32, ptr %8, align 4, !dbg !144
  %31 = add i32 %30, 1, !dbg !145
  %32 = and i32 %31, 1, !dbg !146
  %33 = getelementptr inbounds nuw [2 x %struct.ck_epoch_ref], ptr %29, i32 0, i32 %32, !dbg !141
  store ptr %33, ptr %7, align 4, !dbg !147
  %34 = load ptr, ptr %7, align 4, !dbg !148
  %35 = getelementptr inbounds nuw %struct.ck_epoch_ref, ptr %34, i32 0, i32 1, !dbg !150
  %36 = load i32, ptr %35, align 4, !dbg !150
  %37 = icmp ugt i32 %36, 0, !dbg !151
  br i1 %37, label %38, label %53, !dbg !152

38:                                               ; preds = %26
  %39 = load ptr, ptr %6, align 4, !dbg !153
  %40 = getelementptr inbounds nuw %struct.ck_epoch_ref, ptr %39, i32 0, i32 0, !dbg !154
  %41 = load i32, ptr %40, align 4, !dbg !154
  %42 = load ptr, ptr %7, align 4, !dbg !155
  %43 = getelementptr inbounds nuw %struct.ck_epoch_ref, ptr %42, i32 0, i32 0, !dbg !156
  %44 = load i32, ptr %43, align 4, !dbg !156
  %45 = sub i32 %41, %44, !dbg !157
  %46 = icmp slt i32 %45, 0, !dbg !158
  br i1 %46, label %47, label %53, !dbg !152

47:                                               ; preds = %38
  %48 = load ptr, ptr %4, align 4, !dbg !159
  %49 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %48, i32 0, i32 3, !dbg !161
  %50 = load ptr, ptr %7, align 4, !dbg !162
  %51 = getelementptr inbounds nuw %struct.ck_epoch_ref, ptr %50, i32 0, i32 0, !dbg !163
  %52 = load i32, ptr %51, align 4, !dbg !163
  call arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %49, i32 noundef %52), !dbg !164
  br label %53, !dbg !165

53:                                               ; preds = %47, %38, %26
  store i1 true, ptr %3, align 1, !dbg !166
  br label %54, !dbg !166

54:                                               ; preds = %53, %25
  %55 = load i1, ptr %3, align 1, !dbg !167
  ret i1 %55, !dbg !167
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !168 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !173, !DIExpression(), !174)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !175, !DIExpression(), !174)
  %5 = load ptr, ptr %3, align 4, !dbg !174
  %6 = load i32, ptr %4, align 4, !dbg !174
  call void asm sideeffect "str $1, [$0]", "r,r,~{memory}"(ptr %5, i32 %6) #3, !dbg !174, !srcloc !176
  ret void, !dbg !174
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc void @_ck_epoch_addref(ptr noundef %0, ptr noundef %1) #0 !dbg !177 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !180, !DIExpression(), !181)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !182, !DIExpression(), !183)
    #dbg_declare(ptr %5, !184, !DIExpression(), !185)
  %10 = load ptr, ptr %3, align 4, !dbg !186
  %11 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %10, i32 0, i32 1, !dbg !187
  %12 = load ptr, ptr %11, align 4, !dbg !187
  store ptr %12, ptr %5, align 4, !dbg !185
    #dbg_declare(ptr %6, !188, !DIExpression(), !189)
    #dbg_declare(ptr %7, !190, !DIExpression(), !191)
    #dbg_declare(ptr %8, !192, !DIExpression(), !193)
  %13 = load ptr, ptr %5, align 4, !dbg !194
  %14 = getelementptr inbounds nuw %struct.ck_epoch, ptr %13, i32 0, i32 0, !dbg !195
  %15 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %14), !dbg !196
  store i32 %15, ptr %7, align 4, !dbg !197
  %16 = load i32, ptr %7, align 4, !dbg !198
  %17 = and i32 %16, 1, !dbg !199
  store i32 %17, ptr %8, align 4, !dbg !200
  %18 = load ptr, ptr %3, align 4, !dbg !201
  %19 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %18, i32 0, i32 6, !dbg !202
  %20 = getelementptr inbounds nuw %struct.anon, ptr %19, i32 0, i32 0, !dbg !203
  %21 = load i32, ptr %8, align 4, !dbg !204
  %22 = getelementptr inbounds nuw [2 x %struct.ck_epoch_ref], ptr %20, i32 0, i32 %21, !dbg !201
  store ptr %22, ptr %6, align 4, !dbg !205
  %23 = load ptr, ptr %6, align 4, !dbg !206
  %24 = getelementptr inbounds nuw %struct.ck_epoch_ref, ptr %23, i32 0, i32 1, !dbg !208
  %25 = load i32, ptr %24, align 4, !dbg !209
  %26 = add i32 %25, 1, !dbg !209
  store i32 %26, ptr %24, align 4, !dbg !209
  %27 = icmp eq i32 %25, 0, !dbg !210
  br i1 %27, label %28, label %45, !dbg !210

28:                                               ; preds = %2
    #dbg_declare(ptr %9, !211, !DIExpression(), !213)
  %29 = load ptr, ptr %3, align 4, !dbg !214
  %30 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %29, i32 0, i32 6, !dbg !215
  %31 = getelementptr inbounds nuw %struct.anon, ptr %30, i32 0, i32 0, !dbg !216
  %32 = load i32, ptr %8, align 4, !dbg !217
  %33 = add i32 %32, 1, !dbg !218
  %34 = and i32 %33, 1, !dbg !219
  %35 = getelementptr inbounds nuw [2 x %struct.ck_epoch_ref], ptr %31, i32 0, i32 %34, !dbg !214
  store ptr %35, ptr %9, align 4, !dbg !220
  %36 = load ptr, ptr %9, align 4, !dbg !221
  %37 = getelementptr inbounds nuw %struct.ck_epoch_ref, ptr %36, i32 0, i32 1, !dbg !223
  %38 = load i32, ptr %37, align 4, !dbg !223
  %39 = icmp ugt i32 %38, 0, !dbg !224
  br i1 %39, label %40, label %41, !dbg !224

40:                                               ; preds = %28
  call arm_aapcscc void @ck_pr_fence_acqrel(), !dbg !225
  br label %41, !dbg !225

41:                                               ; preds = %40, %28
  %42 = load i32, ptr %7, align 4, !dbg !226
  %43 = load ptr, ptr %6, align 4, !dbg !227
  %44 = getelementptr inbounds nuw %struct.ck_epoch_ref, ptr %43, i32 0, i32 0, !dbg !228
  store i32 %42, ptr %44, align 4, !dbg !229
  br label %45, !dbg !230

45:                                               ; preds = %41, %2
  %46 = load i32, ptr %8, align 4, !dbg !231
  %47 = load ptr, ptr %4, align 4, !dbg !232
  %48 = getelementptr inbounds nuw %struct.ck_epoch_section, ptr %47, i32 0, i32 0, !dbg !233
  store i32 %46, ptr %48, align 4, !dbg !234
  ret void, !dbg !235
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !236 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !241, !DIExpression(), !242)
    #dbg_declare(ptr %3, !243, !DIExpression(), !242)
  store i32 0, ptr %3, align 4, !dbg !242
  %4 = load ptr, ptr %2, align 4, !dbg !242
  %5 = call i32 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #3, !dbg !242, !srcloc !245
  store i32 %5, ptr %3, align 4, !dbg !242
  %6 = load i32, ptr %3, align 4, !dbg !242
  ret i32 %6, !dbg !242
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_acqrel() #0 !dbg !246 {
  call arm_aapcscc void @ck_pr_fence_strict_acqrel(), !dbg !250
  ret void, !dbg !250
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc void @ck_epoch_init(ptr noundef %0) #0 !dbg !251 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !254, !DIExpression(), !255)
  %3 = load ptr, ptr %2, align 4, !dbg !256
  %4 = getelementptr inbounds nuw %struct.ck_epoch, ptr %3, i32 0, i32 2, !dbg !257
  call arm_aapcscc void @ck_stack_init(ptr noundef %4), !dbg !258
  %5 = load ptr, ptr %2, align 4, !dbg !259
  %6 = getelementptr inbounds nuw %struct.ck_epoch, ptr %5, i32 0, i32 0, !dbg !260
  store i32 1, ptr %6, align 4, !dbg !261
  %7 = load ptr, ptr %2, align 4, !dbg !262
  %8 = getelementptr inbounds nuw %struct.ck_epoch, ptr %7, i32 0, i32 1, !dbg !263
  store i32 0, ptr %8, align 4, !dbg !264
  call arm_aapcscc void @ck_pr_fence_store(), !dbg !265
  ret void, !dbg !266
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_stack_init(ptr noundef %0) #0 !dbg !267 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !271, !DIExpression(), !272)
  %3 = load ptr, ptr %2, align 4, !dbg !273
  %4 = getelementptr inbounds nuw %struct.ck_stack, ptr %3, i32 0, i32 0, !dbg !274
  store ptr null, ptr %4, align 4, !dbg !275
  %5 = load ptr, ptr %2, align 4, !dbg !276
  %6 = getelementptr inbounds nuw %struct.ck_stack, ptr %5, i32 0, i32 1, !dbg !277
  store ptr null, ptr %6, align 4, !dbg !278
  ret void, !dbg !279
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_store() #0 !dbg !280 {
  call arm_aapcscc void @ck_pr_fence_strict_store(), !dbg !281
  ret void, !dbg !281
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc ptr @ck_epoch_recycle(ptr noundef %0, ptr noundef %1) #0 !dbg !282 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  %7 = alloca ptr, align 4
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 4
    #dbg_declare(ptr %4, !285, !DIExpression(), !286)
  store ptr %1, ptr %5, align 4
    #dbg_declare(ptr %5, !287, !DIExpression(), !288)
    #dbg_declare(ptr %6, !289, !DIExpression(), !290)
    #dbg_declare(ptr %7, !291, !DIExpression(), !293)
    #dbg_declare(ptr %8, !294, !DIExpression(), !295)
  %9 = load ptr, ptr %4, align 4, !dbg !296
  %10 = getelementptr inbounds nuw %struct.ck_epoch, ptr %9, i32 0, i32 1, !dbg !298
  %11 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %10), !dbg !299
  %12 = icmp eq i32 %11, 0, !dbg !300
  br i1 %12, label %13, label %14, !dbg !300

13:                                               ; preds = %2
  store ptr null, ptr %3, align 4, !dbg !301
  br label %49, !dbg !301

14:                                               ; preds = %2
  %15 = load ptr, ptr %4, align 4, !dbg !302
  %16 = getelementptr inbounds nuw %struct.ck_epoch, ptr %15, i32 0, i32 2, !dbg !304
  %17 = getelementptr inbounds nuw %struct.ck_stack, ptr %16, i32 0, i32 0, !dbg !305
  %18 = load ptr, ptr %17, align 4, !dbg !305
  store ptr %18, ptr %7, align 4, !dbg !305
  br label %19, !dbg !305

19:                                               ; preds = %44, %14
  %20 = load ptr, ptr %7, align 4, !dbg !306
  %21 = icmp ne ptr %20, null, !dbg !308
  br i1 %21, label %22, label %48, !dbg !305

22:                                               ; preds = %19
  %23 = load ptr, ptr %7, align 4, !dbg !309
  %24 = call arm_aapcscc ptr @ck_epoch_record_container(ptr noundef %23), !dbg !311
  store ptr %24, ptr %6, align 4, !dbg !312
  %25 = load ptr, ptr %6, align 4, !dbg !313
  %26 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %25, i32 0, i32 2, !dbg !315
  %27 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %26), !dbg !316
  %28 = icmp eq i32 %27, 1, !dbg !317
  br i1 %28, label %29, label %43, !dbg !317

29:                                               ; preds = %22
  call arm_aapcscc void @ck_pr_fence_load(), !dbg !318
  %30 = load ptr, ptr %6, align 4, !dbg !320
  %31 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %30, i32 0, i32 2, !dbg !321
  %32 = call arm_aapcscc i32 @ck_pr_fas_uint(ptr noundef %31, i32 noundef 0), !dbg !322
  store i32 %32, ptr %8, align 4, !dbg !323
  %33 = load i32, ptr %8, align 4, !dbg !324
  %34 = icmp eq i32 %33, 1, !dbg !326
  br i1 %34, label %35, label %42, !dbg !326

35:                                               ; preds = %29
  %36 = load ptr, ptr %4, align 4, !dbg !327
  %37 = getelementptr inbounds nuw %struct.ck_epoch, ptr %36, i32 0, i32 1, !dbg !329
  call arm_aapcscc void @ck_pr_dec_uint(ptr noundef %37), !dbg !330
  %38 = load ptr, ptr %6, align 4, !dbg !331
  %39 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %38, i32 0, i32 10, !dbg !332
  %40 = load ptr, ptr %5, align 4, !dbg !333
  call arm_aapcscc void @ck_pr_md_store_ptr(ptr noundef %39, ptr noundef %40), !dbg !334
  %41 = load ptr, ptr %6, align 4, !dbg !335
  store ptr %41, ptr %3, align 4, !dbg !336
  br label %49, !dbg !336

42:                                               ; preds = %29
  br label %43, !dbg !337

43:                                               ; preds = %42, %22
  br label %44, !dbg !338

44:                                               ; preds = %43
  %45 = load ptr, ptr %7, align 4, !dbg !306
  %46 = getelementptr inbounds nuw %struct.ck_stack_entry, ptr %45, i32 0, i32 0, !dbg !308
  %47 = load ptr, ptr %46, align 4, !dbg !308
  store ptr %47, ptr %7, align 4, !dbg !308
  br label %19, !dbg !308, !llvm.loop !339

48:                                               ; preds = %19
  store ptr null, ptr %3, align 4, !dbg !342
  br label %49, !dbg !342

49:                                               ; preds = %48, %35, %13
  %50 = load ptr, ptr %3, align 4, !dbg !343
  ret ptr %50, !dbg !343
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc ptr @ck_epoch_record_container(ptr noundef %0) #0 !dbg !344 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !347, !DIExpression(), !348)
  %3 = load ptr, ptr %2, align 4, !dbg !348
  %4 = getelementptr inbounds i8, ptr %3, i32 0, !dbg !348
  ret ptr %4, !dbg !348
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_load() #0 !dbg !349 {
  call arm_aapcscc void @ck_pr_fence_strict_load(), !dbg !350
  ret void, !dbg !350
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc i32 @ck_pr_fas_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !351 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !354, !DIExpression(), !355)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !356, !DIExpression(), !355)
    #dbg_declare(ptr %5, !357, !DIExpression(), !355)
  store i32 0, ptr %5, align 4, !dbg !355
    #dbg_declare(ptr %6, !358, !DIExpression(), !355)
  store i32 0, ptr %6, align 4, !dbg !355
  %7 = load i32, ptr %5, align 4, !dbg !355
  %8 = load i32, ptr %6, align 4, !dbg !355
  %9 = load ptr, ptr %3, align 4, !dbg !355
  %10 = load i32, ptr %4, align 4, !dbg !355
  %11 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];strex $1, $3, [$2];cmp $1, #0;bne 1b;", "=&r,=&r,r,r,0,1,~{memory},~{cc}"(ptr %9, i32 %10, i32 %7, i32 %8) #3, !dbg !355, !srcloc !359
  %12 = extractvalue { i32, i32 } %11, 0, !dbg !355
  %13 = extractvalue { i32, i32 } %11, 1, !dbg !355
  store i32 %12, ptr %5, align 4, !dbg !355
  store i32 %13, ptr %6, align 4, !dbg !355
  %14 = load i32, ptr %5, align 4, !dbg !355
  ret i32 %14, !dbg !355
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_dec_uint(ptr noundef %0) #0 !dbg !360 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !363, !DIExpression(), !364)
    #dbg_declare(ptr %3, !365, !DIExpression(), !364)
  store i32 0, ptr %3, align 4, !dbg !364
    #dbg_declare(ptr %4, !366, !DIExpression(), !364)
  store i32 0, ptr %4, align 4, !dbg !364
  %5 = load i32, ptr %3, align 4, !dbg !364
  %6 = load i32, ptr %4, align 4, !dbg !364
  %7 = load ptr, ptr %2, align 4, !dbg !364
  %8 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];sub $0, $0, #1;strex $1, $0, [$2];cmp   $1, #0;bne   1b;", "=&r,=&r,r,0,1,~{memory},~{cc}"(ptr %7, i32 %5, i32 %6) #3, !dbg !364, !srcloc !367
  %9 = extractvalue { i32, i32 } %8, 0, !dbg !364
  %10 = extractvalue { i32, i32 } %8, 1, !dbg !364
  store i32 %9, ptr %3, align 4, !dbg !364
  store i32 %10, ptr %4, align 4, !dbg !364
  ret void, !dbg !364
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_md_store_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !368 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !373, !DIExpression(), !374)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !375, !DIExpression(), !374)
  %5 = load ptr, ptr %3, align 4, !dbg !374
  %6 = load ptr, ptr %4, align 4, !dbg !374
  call void asm sideeffect "str $1, [$0]", "r,r,~{memory}"(ptr %5, ptr %6) #3, !dbg !374, !srcloc !376
  ret void, !dbg !374
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc void @ck_epoch_register(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 !dbg !377 {
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %4, align 4
    #dbg_declare(ptr %4, !380, !DIExpression(), !381)
  store ptr %1, ptr %5, align 4
    #dbg_declare(ptr %5, !382, !DIExpression(), !383)
  store ptr %2, ptr %6, align 4
    #dbg_declare(ptr %6, !384, !DIExpression(), !385)
    #dbg_declare(ptr %7, !386, !DIExpression(), !389)
  %8 = load ptr, ptr %4, align 4, !dbg !390
  %9 = load ptr, ptr %5, align 4, !dbg !391
  %10 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %9, i32 0, i32 1, !dbg !392
  store ptr %8, ptr %10, align 4, !dbg !393
  %11 = load ptr, ptr %5, align 4, !dbg !394
  %12 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %11, i32 0, i32 2, !dbg !395
  store i32 0, ptr %12, align 8, !dbg !396
  %13 = load ptr, ptr %5, align 4, !dbg !397
  %14 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %13, i32 0, i32 4, !dbg !398
  store i32 0, ptr %14, align 16, !dbg !399
  %15 = load ptr, ptr %5, align 4, !dbg !400
  %16 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %15, i32 0, i32 3, !dbg !401
  store i32 0, ptr %16, align 4, !dbg !402
  %17 = load ptr, ptr %5, align 4, !dbg !403
  %18 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %17, i32 0, i32 9, !dbg !404
  store i32 0, ptr %18, align 8, !dbg !405
  %19 = load ptr, ptr %5, align 4, !dbg !406
  %20 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %19, i32 0, i32 8, !dbg !407
  store i32 0, ptr %20, align 4, !dbg !408
  %21 = load ptr, ptr %5, align 4, !dbg !409
  %22 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %21, i32 0, i32 7, !dbg !410
  store i32 0, ptr %22, align 16, !dbg !411
  %23 = load ptr, ptr %6, align 4, !dbg !412
  %24 = load ptr, ptr %5, align 4, !dbg !413
  %25 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %24, i32 0, i32 10, !dbg !414
  store ptr %23, ptr %25, align 4, !dbg !415
  %26 = load ptr, ptr %5, align 4, !dbg !416
  %27 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %26, i32 0, i32 6, !dbg !417
  call void @llvm.memset.p0.i32(ptr align 64 %27, i8 0, i32 16, i1 false), !dbg !418
  store i32 0, ptr %7, align 4, !dbg !419
  br label %28, !dbg !421

28:                                               ; preds = %36, %3
  %29 = load i32, ptr %7, align 4, !dbg !422
  %30 = icmp ult i32 %29, 4, !dbg !424
  br i1 %30, label %31, label %39, !dbg !425

31:                                               ; preds = %28
  %32 = load ptr, ptr %5, align 4, !dbg !426
  %33 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %32, i32 0, i32 11, !dbg !427
  %34 = load i32, ptr %7, align 4, !dbg !428
  %35 = getelementptr inbounds nuw [4 x %struct.ck_stack], ptr %33, i32 0, i32 %34, !dbg !426
  call arm_aapcscc void @ck_stack_init(ptr noundef %35), !dbg !429
  br label %36, !dbg !429

36:                                               ; preds = %31
  %37 = load i32, ptr %7, align 4, !dbg !430
  %38 = add i32 %37, 1, !dbg !430
  store i32 %38, ptr %7, align 4, !dbg !430
  br label %28, !dbg !431, !llvm.loop !432

39:                                               ; preds = %28
  call arm_aapcscc void @ck_pr_fence_store(), !dbg !434
  %40 = load ptr, ptr %4, align 4, !dbg !435
  %41 = getelementptr inbounds nuw %struct.ck_epoch, ptr %40, i32 0, i32 2, !dbg !436
  %42 = load ptr, ptr %5, align 4, !dbg !437
  %43 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %42, i32 0, i32 0, !dbg !438
  call arm_aapcscc void @ck_stack_push_upmc(ptr noundef %41, ptr noundef %43), !dbg !439
  ret void, !dbg !440
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i32(ptr writeonly captures(none), i8, i32, i1 immarg) #1

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_stack_push_upmc(ptr noundef %0, ptr noundef %1) #0 !dbg !441 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !444, !DIExpression(), !445)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !446, !DIExpression(), !447)
    #dbg_declare(ptr %5, !448, !DIExpression(), !449)
  %6 = load ptr, ptr %3, align 4, !dbg !450
  %7 = getelementptr inbounds nuw %struct.ck_stack, ptr %6, i32 0, i32 0, !dbg !451
  %8 = call arm_aapcscc ptr @ck_pr_md_load_ptr(ptr noundef %7), !dbg !452
  store ptr %8, ptr %5, align 4, !dbg !453
  %9 = load ptr, ptr %5, align 4, !dbg !454
  %10 = load ptr, ptr %4, align 4, !dbg !455
  %11 = getelementptr inbounds nuw %struct.ck_stack_entry, ptr %10, i32 0, i32 0, !dbg !456
  store ptr %9, ptr %11, align 4, !dbg !457
  call arm_aapcscc void @ck_pr_fence_store(), !dbg !458
  br label %12, !dbg !459

12:                                               ; preds = %20, %2
  %13 = load ptr, ptr %3, align 4, !dbg !460
  %14 = getelementptr inbounds nuw %struct.ck_stack, ptr %13, i32 0, i32 0, !dbg !461
  %15 = load ptr, ptr %5, align 4, !dbg !462
  %16 = load ptr, ptr %4, align 4, !dbg !463
  %17 = call arm_aapcscc zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %14, ptr noundef %15, ptr noundef %16, ptr noundef %5), !dbg !464
  %18 = zext i1 %17 to i32, !dbg !464
  %19 = icmp eq i32 %18, 0, !dbg !465
  br i1 %19, label %20, label %24, !dbg !459

20:                                               ; preds = %12
  %21 = load ptr, ptr %5, align 4, !dbg !466
  %22 = load ptr, ptr %4, align 4, !dbg !468
  %23 = getelementptr inbounds nuw %struct.ck_stack_entry, ptr %22, i32 0, i32 0, !dbg !469
  store ptr %21, ptr %23, align 4, !dbg !470
  call arm_aapcscc void @ck_pr_fence_store(), !dbg !471
  br label %12, !dbg !459, !llvm.loop !472

24:                                               ; preds = %12
  ret void, !dbg !474
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc void @ck_epoch_unregister(ptr noundef %0) #0 !dbg !475 {
  %2 = alloca ptr, align 4
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !478, !DIExpression(), !479)
    #dbg_declare(ptr %3, !480, !DIExpression(), !481)
  %5 = load ptr, ptr %2, align 4, !dbg !482
  %6 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %5, i32 0, i32 1, !dbg !483
  %7 = load ptr, ptr %6, align 4, !dbg !483
  store ptr %7, ptr %3, align 4, !dbg !481
    #dbg_declare(ptr %4, !484, !DIExpression(), !485)
  %8 = load ptr, ptr %2, align 4, !dbg !486
  %9 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %8, i32 0, i32 4, !dbg !487
  store i32 0, ptr %9, align 16, !dbg !488
  %10 = load ptr, ptr %2, align 4, !dbg !489
  %11 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %10, i32 0, i32 3, !dbg !490
  store i32 0, ptr %11, align 4, !dbg !491
  %12 = load ptr, ptr %2, align 4, !dbg !492
  %13 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %12, i32 0, i32 9, !dbg !493
  store i32 0, ptr %13, align 8, !dbg !494
  %14 = load ptr, ptr %2, align 4, !dbg !495
  %15 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %14, i32 0, i32 8, !dbg !496
  store i32 0, ptr %15, align 4, !dbg !497
  %16 = load ptr, ptr %2, align 4, !dbg !498
  %17 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %16, i32 0, i32 7, !dbg !499
  store i32 0, ptr %17, align 16, !dbg !500
  %18 = load ptr, ptr %2, align 4, !dbg !501
  %19 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %18, i32 0, i32 6, !dbg !502
  call void @llvm.memset.p0.i32(ptr align 64 %19, i8 0, i32 16, i1 false), !dbg !503
  store i32 0, ptr %4, align 4, !dbg !504
  br label %20, !dbg !506

20:                                               ; preds = %28, %1
  %21 = load i32, ptr %4, align 4, !dbg !507
  %22 = icmp ult i32 %21, 4, !dbg !509
  br i1 %22, label %23, label %31, !dbg !510

23:                                               ; preds = %20
  %24 = load ptr, ptr %2, align 4, !dbg !511
  %25 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %24, i32 0, i32 11, !dbg !512
  %26 = load i32, ptr %4, align 4, !dbg !513
  %27 = getelementptr inbounds nuw [4 x %struct.ck_stack], ptr %25, i32 0, i32 %26, !dbg !511
  call arm_aapcscc void @ck_stack_init(ptr noundef %27), !dbg !514
  br label %28, !dbg !514

28:                                               ; preds = %23
  %29 = load i32, ptr %4, align 4, !dbg !515
  %30 = add i32 %29, 1, !dbg !515
  store i32 %30, ptr %4, align 4, !dbg !515
  br label %20, !dbg !516, !llvm.loop !517

31:                                               ; preds = %20
  %32 = load ptr, ptr %2, align 4, !dbg !519
  %33 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %32, i32 0, i32 10, !dbg !520
  call arm_aapcscc void @ck_pr_md_store_ptr(ptr noundef %33, ptr noundef null), !dbg !521
  call arm_aapcscc void @ck_pr_fence_store(), !dbg !522
  %34 = load ptr, ptr %2, align 4, !dbg !523
  %35 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %34, i32 0, i32 2, !dbg !524
  call arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %35, i32 noundef 1), !dbg !525
  %36 = load ptr, ptr %3, align 4, !dbg !526
  %37 = getelementptr inbounds nuw %struct.ck_epoch, ptr %36, i32 0, i32 1, !dbg !527
  call arm_aapcscc void @ck_pr_inc_uint(ptr noundef %37), !dbg !528
  ret void, !dbg !529
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_inc_uint(ptr noundef %0) #0 !dbg !530 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !531, !DIExpression(), !532)
    #dbg_declare(ptr %3, !533, !DIExpression(), !532)
  store i32 0, ptr %3, align 4, !dbg !532
    #dbg_declare(ptr %4, !534, !DIExpression(), !532)
  store i32 0, ptr %4, align 4, !dbg !532
  %5 = load i32, ptr %3, align 4, !dbg !532
  %6 = load i32, ptr %4, align 4, !dbg !532
  %7 = load ptr, ptr %2, align 4, !dbg !532
  %8 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];add $0, $0, #1;strex $1, $0, [$2];cmp   $1, #0;bne   1b;", "=&r,=&r,r,0,1,~{memory},~{cc}"(ptr %7, i32 %5, i32 %6) #3, !dbg !532, !srcloc !535
  %9 = extractvalue { i32, i32 } %8, 0, !dbg !532
  %10 = extractvalue { i32, i32 } %8, 1, !dbg !532
  store i32 %9, ptr %3, align 4, !dbg !532
  store i32 %10, ptr %4, align 4, !dbg !532
  ret void, !dbg !532
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc void @ck_epoch_reclaim(ptr noundef %0) #0 !dbg !536 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !537, !DIExpression(), !538)
    #dbg_declare(ptr %3, !539, !DIExpression(), !540)
  store i32 0, ptr %3, align 4, !dbg !541
  br label %4, !dbg !543

4:                                                ; preds = %11, %1
  %5 = load i32, ptr %3, align 4, !dbg !544
  %6 = icmp ult i32 %5, 4, !dbg !546
  br i1 %6, label %7, label %14, !dbg !547

7:                                                ; preds = %4
  %8 = load ptr, ptr %2, align 4, !dbg !548
  %9 = load i32, ptr %3, align 4, !dbg !549
  %10 = call arm_aapcscc i32 @ck_epoch_dispatch(ptr noundef %8, i32 noundef %9, ptr noundef null), !dbg !550
  br label %11, !dbg !550

11:                                               ; preds = %7
  %12 = load i32, ptr %3, align 4, !dbg !551
  %13 = add i32 %12, 1, !dbg !551
  store i32 %13, ptr %3, align 4, !dbg !551
  br label %4, !dbg !552, !llvm.loop !553

14:                                               ; preds = %4
  ret void, !dbg !555
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc i32 @ck_epoch_dispatch(ptr noundef %0, i32 noundef %1, ptr noundef %2) #0 !dbg !556 {
  %4 = alloca ptr, align 4
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 4
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 4
  %9 = alloca ptr, align 4
  %10 = alloca ptr, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca ptr, align 4
  store ptr %0, ptr %4, align 4
    #dbg_declare(ptr %4, !560, !DIExpression(), !561)
  store i32 %1, ptr %5, align 4
    #dbg_declare(ptr %5, !562, !DIExpression(), !563)
  store ptr %2, ptr %6, align 4
    #dbg_declare(ptr %6, !564, !DIExpression(), !565)
    #dbg_declare(ptr %7, !566, !DIExpression(), !567)
  %15 = load i32, ptr %5, align 4, !dbg !568
  %16 = and i32 %15, 3, !dbg !569
  store i32 %16, ptr %7, align 4, !dbg !567
    #dbg_declare(ptr %8, !570, !DIExpression(), !571)
    #dbg_declare(ptr %9, !572, !DIExpression(), !573)
    #dbg_declare(ptr %10, !574, !DIExpression(), !575)
    #dbg_declare(ptr %11, !576, !DIExpression(), !577)
    #dbg_declare(ptr %12, !578, !DIExpression(), !579)
    #dbg_declare(ptr %13, !580, !DIExpression(), !581)
  store i32 0, ptr %13, align 4, !dbg !581
  %17 = load ptr, ptr %4, align 4, !dbg !582
  %18 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %17, i32 0, i32 11, !dbg !583
  %19 = load i32, ptr %7, align 4, !dbg !584
  %20 = getelementptr inbounds nuw [4 x %struct.ck_stack], ptr %18, i32 0, i32 %19, !dbg !582
  %21 = call arm_aapcscc ptr @ck_stack_batch_pop_upmc(ptr noundef %20), !dbg !585
  store ptr %21, ptr %8, align 4, !dbg !586
  %22 = load ptr, ptr %8, align 4, !dbg !587
  store ptr %22, ptr %10, align 4, !dbg !589
  br label %23, !dbg !590

23:                                               ; preds = %46, %3
  %24 = load ptr, ptr %10, align 4, !dbg !591
  %25 = icmp ne ptr %24, null, !dbg !593
  br i1 %25, label %26, label %48, !dbg !594

26:                                               ; preds = %23
    #dbg_declare(ptr %14, !595, !DIExpression(), !597)
  %27 = load ptr, ptr %10, align 4, !dbg !598
  %28 = call arm_aapcscc ptr @ck_epoch_entry_container(ptr noundef %27), !dbg !599
  store ptr %28, ptr %14, align 4, !dbg !597
  %29 = load ptr, ptr %10, align 4, !dbg !600
  %30 = getelementptr inbounds nuw %struct.ck_stack_entry, ptr %29, i32 0, i32 0, !dbg !601
  %31 = load ptr, ptr %30, align 4, !dbg !601
  store ptr %31, ptr %9, align 4, !dbg !602
  %32 = load ptr, ptr %6, align 4, !dbg !603
  %33 = icmp ne ptr %32, null, !dbg !605
  br i1 %33, label %34, label %38, !dbg !605

34:                                               ; preds = %26
  %35 = load ptr, ptr %6, align 4, !dbg !606
  %36 = load ptr, ptr %14, align 4, !dbg !607
  %37 = getelementptr inbounds nuw %struct.ck_epoch_entry, ptr %36, i32 0, i32 1, !dbg !608
  call arm_aapcscc void @ck_stack_push_spnc(ptr noundef %35, ptr noundef %37), !dbg !609
  br label %43, !dbg !609

38:                                               ; preds = %26
  %39 = load ptr, ptr %14, align 4, !dbg !610
  %40 = getelementptr inbounds nuw %struct.ck_epoch_entry, ptr %39, i32 0, i32 0, !dbg !611
  %41 = load ptr, ptr %40, align 4, !dbg !610
  %42 = load ptr, ptr %14, align 4, !dbg !612
  call arm_aapcscc void %41(ptr noundef %42), !dbg !610
  br label %43

43:                                               ; preds = %38, %34
  %44 = load i32, ptr %13, align 4, !dbg !613
  %45 = add i32 %44, 1, !dbg !613
  store i32 %45, ptr %13, align 4, !dbg !613
  br label %46, !dbg !614

46:                                               ; preds = %43
  %47 = load ptr, ptr %9, align 4, !dbg !615
  store ptr %47, ptr %10, align 4, !dbg !616
  br label %23, !dbg !617, !llvm.loop !618

48:                                               ; preds = %23
  %49 = load ptr, ptr %4, align 4, !dbg !620
  %50 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %49, i32 0, i32 8, !dbg !621
  %51 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %50), !dbg !622
  store i32 %51, ptr %12, align 4, !dbg !623
  %52 = load ptr, ptr %4, align 4, !dbg !624
  %53 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %52, i32 0, i32 7, !dbg !625
  %54 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %53), !dbg !626
  store i32 %54, ptr %11, align 4, !dbg !627
  %55 = load i32, ptr %11, align 4, !dbg !628
  %56 = load i32, ptr %12, align 4, !dbg !630
  %57 = icmp ugt i32 %55, %56, !dbg !631
  br i1 %57, label %58, label %62, !dbg !631

58:                                               ; preds = %48
  %59 = load ptr, ptr %4, align 4, !dbg !632
  %60 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %59, i32 0, i32 8, !dbg !633
  %61 = load i32, ptr %12, align 4, !dbg !634
  call arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %60, i32 noundef %61), !dbg !635
  br label %62, !dbg !635

62:                                               ; preds = %58, %48
  %63 = load i32, ptr %13, align 4, !dbg !636
  %64 = icmp ugt i32 %63, 0, !dbg !638
  br i1 %64, label %65, label %72, !dbg !638

65:                                               ; preds = %62
  %66 = load ptr, ptr %4, align 4, !dbg !639
  %67 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %66, i32 0, i32 9, !dbg !641
  %68 = load i32, ptr %13, align 4, !dbg !642
  call arm_aapcscc void @ck_pr_add_uint(ptr noundef %67, i32 noundef %68), !dbg !643
  %69 = load ptr, ptr %4, align 4, !dbg !644
  %70 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %69, i32 0, i32 7, !dbg !645
  %71 = load i32, ptr %13, align 4, !dbg !646
  call arm_aapcscc void @ck_pr_sub_uint(ptr noundef %70, i32 noundef %71), !dbg !647
  br label %72, !dbg !648

72:                                               ; preds = %65, %62
  %73 = load i32, ptr %13, align 4, !dbg !649
  ret i32 %73, !dbg !650
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc void @ck_epoch_synchronize_wait(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 !dbg !651 {
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  %7 = alloca ptr, align 4
  %8 = alloca ptr, align 4
  %9 = alloca ptr, align 4
  %10 = alloca ptr, align 4
  %11 = alloca ptr, align 4
  %12 = alloca ptr, align 4
  %13 = alloca ptr, align 4
  %14 = alloca ptr, align 4
  %15 = alloca ptr, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  %19 = alloca i32, align 4
  %20 = alloca i8, align 1
  %21 = alloca i8, align 1
  %22 = alloca i32, align 4
  store ptr %0, ptr %12, align 4
    #dbg_declare(ptr %12, !659, !DIExpression(), !660)
  store ptr %1, ptr %13, align 4
    #dbg_declare(ptr %13, !661, !DIExpression(), !662)
  store ptr %2, ptr %14, align 4
    #dbg_declare(ptr %14, !663, !DIExpression(), !664)
    #dbg_declare(ptr %15, !665, !DIExpression(), !666)
    #dbg_declare(ptr %16, !667, !DIExpression(), !668)
    #dbg_declare(ptr %17, !669, !DIExpression(), !670)
    #dbg_declare(ptr %18, !671, !DIExpression(), !672)
    #dbg_declare(ptr %19, !673, !DIExpression(), !674)
    #dbg_declare(ptr %20, !675, !DIExpression(), !676)
  call arm_aapcscc void @ck_pr_fence_memory(), !dbg !677
  %23 = load ptr, ptr %12, align 4, !dbg !678
  %24 = getelementptr inbounds nuw %struct.ck_epoch, ptr %23, i32 0, i32 0, !dbg !679
  %25 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %24), !dbg !680
  store i32 %25, ptr %17, align 4, !dbg !681
  store i32 %25, ptr %16, align 4, !dbg !682
  %26 = load i32, ptr %17, align 4, !dbg !683
  %27 = add i32 %26, 3, !dbg !684
  store i32 %27, ptr %18, align 4, !dbg !685
  store i32 0, ptr %19, align 4, !dbg !686
  store ptr null, ptr %15, align 4, !dbg !688
  br label %28, !dbg !689

28:                                               ; preds = %104, %3
  %29 = load i32, ptr %19, align 4, !dbg !690
  %30 = icmp ult i32 %29, 2, !dbg !692
  br i1 %30, label %31, label %107, !dbg !693

31:                                               ; preds = %28
    #dbg_declare(ptr %21, !694, !DIExpression(), !696)
  br label %32, !dbg !697

32:                                               ; preds = %84, %58, %31
  %33 = load ptr, ptr %12, align 4, !dbg !698
  %34 = load ptr, ptr %15, align 4, !dbg !699
  %35 = load i32, ptr %16, align 4, !dbg !700
  %36 = call arm_aapcscc ptr @ck_epoch_scan(ptr noundef %33, ptr noundef %34, i32 noundef %35, ptr noundef %20), !dbg !701
  store ptr %36, ptr %15, align 4, !dbg !702
  %37 = load ptr, ptr %15, align 4, !dbg !703
  %38 = icmp ne ptr %37, null, !dbg !704
  br i1 %38, label %39, label %85, !dbg !697

39:                                               ; preds = %32
    #dbg_declare(ptr %22, !705, !DIExpression(), !707)
  call arm_aapcscc void @ck_pr_stall(), !dbg !708
  %40 = load ptr, ptr %12, align 4, !dbg !709
  %41 = getelementptr inbounds nuw %struct.ck_epoch, ptr %40, i32 0, i32 0, !dbg !710
  %42 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %41), !dbg !711
  store i32 %42, ptr %22, align 4, !dbg !712
  %43 = load i32, ptr %22, align 4, !dbg !713
  %44 = load i32, ptr %16, align 4, !dbg !715
  %45 = icmp eq i32 %43, %44, !dbg !716
  br i1 %45, label %46, label %59, !dbg !716

46:                                               ; preds = %39
  %47 = load ptr, ptr %12, align 4, !dbg !717
  %48 = load ptr, ptr %15, align 4, !dbg !719
  %49 = load ptr, ptr %13, align 4, !dbg !720
  %50 = load ptr, ptr %14, align 4, !dbg !721
  store ptr %47, ptr %4, align 4
    #dbg_declare(ptr %4, !722, !DIExpression(), !726)
  store ptr %48, ptr %5, align 4
    #dbg_declare(ptr %5, !728, !DIExpression(), !729)
  store ptr %49, ptr %6, align 4
    #dbg_declare(ptr %6, !730, !DIExpression(), !731)
  store ptr %50, ptr %7, align 4
    #dbg_declare(ptr %7, !732, !DIExpression(), !733)
  %51 = load ptr, ptr %6, align 4, !dbg !734
  %52 = icmp ne ptr %51, null, !dbg !736
  br i1 %52, label %53, label %58, !dbg !736

53:                                               ; preds = %46
  %54 = load ptr, ptr %6, align 4, !dbg !737
  %55 = load ptr, ptr %4, align 4, !dbg !738
  %56 = load ptr, ptr %5, align 4, !dbg !739
  %57 = load ptr, ptr %7, align 4, !dbg !740
  call arm_aapcscc void %54(ptr noundef %55, ptr noundef %56, ptr noundef %57) #3, !dbg !737
  br label %58, !dbg !737

58:                                               ; preds = %46, %53
  br label %32, !dbg !741, !llvm.loop !742

59:                                               ; preds = %39
  %60 = load i32, ptr %22, align 4, !dbg !744
  store i32 %60, ptr %16, align 4, !dbg !745
  %61 = load i32, ptr %18, align 4, !dbg !746
  %62 = load i32, ptr %17, align 4, !dbg !748
  %63 = icmp ugt i32 %61, %62, !dbg !749
  %64 = zext i1 %63 to i32, !dbg !749
  %65 = load i32, ptr %16, align 4, !dbg !750
  %66 = load i32, ptr %18, align 4, !dbg !751
  %67 = icmp uge i32 %65, %66, !dbg !752
  %68 = zext i1 %67 to i32, !dbg !752
  %69 = and i32 %64, %68, !dbg !753
  %70 = icmp ne i32 %69, 0, !dbg !753
  br i1 %70, label %71, label %72, !dbg !753

71:                                               ; preds = %59
  br label %108, !dbg !754

72:                                               ; preds = %59
  %73 = load ptr, ptr %12, align 4, !dbg !755
  %74 = load ptr, ptr %15, align 4, !dbg !756
  %75 = load ptr, ptr %13, align 4, !dbg !757
  %76 = load ptr, ptr %14, align 4, !dbg !758
  store ptr %73, ptr %8, align 4
    #dbg_declare(ptr %8, !722, !DIExpression(), !759)
  store ptr %74, ptr %9, align 4
    #dbg_declare(ptr %9, !728, !DIExpression(), !761)
  store ptr %75, ptr %10, align 4
    #dbg_declare(ptr %10, !730, !DIExpression(), !762)
  store ptr %76, ptr %11, align 4
    #dbg_declare(ptr %11, !732, !DIExpression(), !763)
  %77 = load ptr, ptr %10, align 4, !dbg !764
  %78 = icmp ne ptr %77, null, !dbg !765
  br i1 %78, label %79, label %84, !dbg !765

79:                                               ; preds = %72
  %80 = load ptr, ptr %10, align 4, !dbg !766
  %81 = load ptr, ptr %8, align 4, !dbg !767
  %82 = load ptr, ptr %9, align 4, !dbg !768
  %83 = load ptr, ptr %11, align 4, !dbg !769
  call arm_aapcscc void %80(ptr noundef %81, ptr noundef %82, ptr noundef %83) #3, !dbg !766
  br label %84, !dbg !766

84:                                               ; preds = %72, %79
  store ptr null, ptr %15, align 4, !dbg !770
  br label %32, !dbg !697, !llvm.loop !742

85:                                               ; preds = %32
  %86 = load i8, ptr %20, align 1, !dbg !771
  %87 = trunc i8 %86 to i1, !dbg !771
  %88 = zext i1 %87 to i32, !dbg !771
  %89 = icmp eq i32 %88, 0, !dbg !773
  br i1 %89, label %90, label %91, !dbg !773

90:                                               ; preds = %85
  br label %107, !dbg !774

91:                                               ; preds = %85
  %92 = load ptr, ptr %12, align 4, !dbg !775
  %93 = getelementptr inbounds nuw %struct.ck_epoch, ptr %92, i32 0, i32 0, !dbg !776
  %94 = load i32, ptr %16, align 4, !dbg !777
  %95 = load i32, ptr %16, align 4, !dbg !778
  %96 = add i32 %95, 1, !dbg !779
  %97 = call arm_aapcscc zeroext i1 @ck_pr_cas_uint_value(ptr noundef %93, i32 noundef %94, i32 noundef %96, ptr noundef %16), !dbg !780
  %98 = zext i1 %97 to i8, !dbg !781
  store i8 %98, ptr %21, align 1, !dbg !781
  call arm_aapcscc void @ck_pr_fence_atomic_load(), !dbg !782
  %99 = load i32, ptr %16, align 4, !dbg !783
  %100 = load i8, ptr %21, align 1, !dbg !784
  %101 = trunc i8 %100 to i1, !dbg !784
  %102 = zext i1 %101 to i32, !dbg !784
  %103 = add i32 %99, %102, !dbg !785
  store i32 %103, ptr %16, align 4, !dbg !786
  br label %104, !dbg !787

104:                                              ; preds = %91
  store ptr null, ptr %15, align 4, !dbg !788
  %105 = load i32, ptr %19, align 4, !dbg !789
  %106 = add i32 %105, 1, !dbg !789
  store i32 %106, ptr %19, align 4, !dbg !789
  br label %28, !dbg !790, !llvm.loop !791

107:                                              ; preds = %90, %28
  br label %108, !dbg !792

108:                                              ; preds = %107, %71
    #dbg_label(!793, !794)
  call arm_aapcscc void @ck_pr_fence_memory(), !dbg !795
  ret void, !dbg !796
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_memory() #0 !dbg !797 {
  call arm_aapcscc void @ck_pr_fence_strict_memory(), !dbg !798
  ret void, !dbg !798
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc ptr @ck_epoch_scan(ptr noundef %0, ptr noundef %1, i32 noundef %2, ptr noundef %3) #0 !dbg !799 {
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  %7 = alloca ptr, align 4
  %8 = alloca i32, align 4
  %9 = alloca ptr, align 4
  %10 = alloca ptr, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  store ptr %0, ptr %6, align 4
    #dbg_declare(ptr %6, !803, !DIExpression(), !804)
  store ptr %1, ptr %7, align 4
    #dbg_declare(ptr %7, !805, !DIExpression(), !806)
  store i32 %2, ptr %8, align 4
    #dbg_declare(ptr %8, !807, !DIExpression(), !808)
  store ptr %3, ptr %9, align 4
    #dbg_declare(ptr %9, !809, !DIExpression(), !810)
    #dbg_declare(ptr %10, !811, !DIExpression(), !812)
  %13 = load ptr, ptr %7, align 4, !dbg !813
  %14 = icmp eq ptr %13, null, !dbg !815
  br i1 %14, label %15, label %21, !dbg !815

15:                                               ; preds = %4
  %16 = load ptr, ptr %6, align 4, !dbg !816
  %17 = getelementptr inbounds nuw %struct.ck_epoch, ptr %16, i32 0, i32 2, !dbg !818
  %18 = getelementptr inbounds nuw %struct.ck_stack, ptr %17, i32 0, i32 0, !dbg !819
  %19 = load ptr, ptr %18, align 4, !dbg !819
  store ptr %19, ptr %10, align 4, !dbg !820
  %20 = load ptr, ptr %9, align 4, !dbg !821
  store i8 0, ptr %20, align 1, !dbg !822
  br label %25, !dbg !823

21:                                               ; preds = %4
  %22 = load ptr, ptr %7, align 4, !dbg !824
  %23 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %22, i32 0, i32 0, !dbg !826
  store ptr %23, ptr %10, align 4, !dbg !827
  %24 = load ptr, ptr %9, align 4, !dbg !828
  store i8 1, ptr %24, align 1, !dbg !829
  br label %25

25:                                               ; preds = %21, %15
  br label %26, !dbg !830

26:                                               ; preds = %64, %38, %25
  %27 = load ptr, ptr %10, align 4, !dbg !831
  %28 = icmp ne ptr %27, null, !dbg !832
  br i1 %28, label %29, label %68, !dbg !830

29:                                               ; preds = %26
    #dbg_declare(ptr %11, !833, !DIExpression(), !835)
    #dbg_declare(ptr %12, !836, !DIExpression(), !837)
  %30 = load ptr, ptr %10, align 4, !dbg !838
  %31 = call arm_aapcscc ptr @ck_epoch_record_container(ptr noundef %30), !dbg !839
  store ptr %31, ptr %7, align 4, !dbg !840
  %32 = load ptr, ptr %7, align 4, !dbg !841
  %33 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %32, i32 0, i32 2, !dbg !842
  %34 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %33), !dbg !843
  store i32 %34, ptr %11, align 4, !dbg !844
  %35 = load i32, ptr %11, align 4, !dbg !845
  %36 = and i32 %35, 1, !dbg !847
  %37 = icmp ne i32 %36, 0, !dbg !847
  br i1 %37, label %38, label %42, !dbg !847

38:                                               ; preds = %29
  %39 = load ptr, ptr %10, align 4, !dbg !848
  %40 = getelementptr inbounds nuw %struct.ck_stack_entry, ptr %39, i32 0, i32 0, !dbg !850
  %41 = load ptr, ptr %40, align 4, !dbg !850
  store ptr %41, ptr %10, align 4, !dbg !851
  br label %26, !dbg !852, !llvm.loop !853

42:                                               ; preds = %29
  %43 = load ptr, ptr %7, align 4, !dbg !855
  %44 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %43, i32 0, i32 4, !dbg !856
  %45 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %44), !dbg !857
  store i32 %45, ptr %12, align 4, !dbg !858
  %46 = load i32, ptr %12, align 4, !dbg !859
  %47 = load ptr, ptr %9, align 4, !dbg !860
  %48 = load i8, ptr %47, align 1, !dbg !861
  %49 = trunc i8 %48 to i1, !dbg !861
  %50 = zext i1 %49 to i32, !dbg !861
  %51 = or i32 %50, %46, !dbg !861
  %52 = icmp ne i32 %51, 0, !dbg !861
  %53 = zext i1 %52 to i8, !dbg !861
  store i8 %53, ptr %47, align 1, !dbg !861
  %54 = load i32, ptr %12, align 4, !dbg !862
  %55 = icmp ne i32 %54, 0, !dbg !864
  br i1 %55, label %56, label %64, !dbg !865

56:                                               ; preds = %42
  %57 = load ptr, ptr %7, align 4, !dbg !866
  %58 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %57, i32 0, i32 3, !dbg !867
  %59 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %58), !dbg !868
  %60 = load i32, ptr %8, align 4, !dbg !869
  %61 = icmp ne i32 %59, %60, !dbg !870
  br i1 %61, label %62, label %64, !dbg !865

62:                                               ; preds = %56
  %63 = load ptr, ptr %7, align 4, !dbg !871
  store ptr %63, ptr %5, align 4, !dbg !872
  br label %69, !dbg !872

64:                                               ; preds = %56, %42
  %65 = load ptr, ptr %10, align 4, !dbg !873
  %66 = getelementptr inbounds nuw %struct.ck_stack_entry, ptr %65, i32 0, i32 0, !dbg !874
  %67 = load ptr, ptr %66, align 4, !dbg !874
  store ptr %67, ptr %10, align 4, !dbg !875
  br label %26, !dbg !830, !llvm.loop !853

68:                                               ; preds = %26
  store ptr null, ptr %5, align 4, !dbg !876
  br label %69, !dbg !876

69:                                               ; preds = %68, %62
  %70 = load ptr, ptr %5, align 4, !dbg !877
  ret ptr %70, !dbg !877
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_stall() #0 !dbg !878 {
  call void asm sideeffect "", "~{memory}"() #3, !dbg !879, !srcloc !880
  ret void, !dbg !881
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc zeroext i1 @ck_pr_cas_uint_value(ptr noundef %0, i32 noundef %1, i32 noundef %2, ptr noundef %3) #0 !dbg !882 {
  %5 = alloca ptr, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store ptr %0, ptr %5, align 4
    #dbg_declare(ptr %5, !885, !DIExpression(), !886)
  store i32 %1, ptr %6, align 4
    #dbg_declare(ptr %6, !887, !DIExpression(), !886)
  store i32 %2, ptr %7, align 4
    #dbg_declare(ptr %7, !888, !DIExpression(), !886)
  store ptr %3, ptr %8, align 4
    #dbg_declare(ptr %8, !889, !DIExpression(), !886)
    #dbg_declare(ptr %9, !890, !DIExpression(), !886)
  store i32 0, ptr %9, align 4, !dbg !886
    #dbg_declare(ptr %10, !891, !DIExpression(), !886)
  store i32 0, ptr %10, align 4, !dbg !886
  %11 = load i32, ptr %9, align 4, !dbg !886
  %12 = load i32, ptr %10, align 4, !dbg !886
  %13 = load ptr, ptr %5, align 4, !dbg !886
  %14 = load i32, ptr %7, align 4, !dbg !886
  %15 = load i32, ptr %6, align 4, !dbg !886
  %16 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];cmp   $0, $4;itt eq;strexeq $1, $3, [$2];cmpeq   $1, #1;beq   1b;", "=&r,=&r,r,r,r,0,1,~{memory},~{cc}"(ptr %13, i32 %14, i32 %15, i32 %11, i32 %12) #3, !dbg !886, !srcloc !892
  %17 = extractvalue { i32, i32 } %16, 0, !dbg !886
  %18 = extractvalue { i32, i32 } %16, 1, !dbg !886
  store i32 %17, ptr %9, align 4, !dbg !886
  store i32 %18, ptr %10, align 4, !dbg !886
  %19 = load i32, ptr %9, align 4, !dbg !886
  %20 = load ptr, ptr %8, align 4, !dbg !886
  store i32 %19, ptr %20, align 4, !dbg !886
  %21 = load i32, ptr %9, align 4, !dbg !886
  %22 = load i32, ptr %6, align 4, !dbg !886
  %23 = icmp eq i32 %21, %22, !dbg !886
  ret i1 %23, !dbg !886
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_atomic_load() #0 !dbg !893 {
  call arm_aapcscc void @ck_pr_fence_strict_atomic_load(), !dbg !894
  ret void, !dbg !894
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc void @ck_epoch_synchronize(ptr noundef %0) #0 !dbg !895 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !896, !DIExpression(), !897)
  %3 = load ptr, ptr %2, align 4, !dbg !898
  %4 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %3, i32 0, i32 1, !dbg !899
  %5 = load ptr, ptr %4, align 4, !dbg !899
  call arm_aapcscc void @ck_epoch_synchronize_wait(ptr noundef %5, ptr noundef null, ptr noundef null), !dbg !900
  ret void, !dbg !901
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc void @ck_epoch_barrier(ptr noundef %0) #0 !dbg !902 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !903, !DIExpression(), !904)
  %3 = load ptr, ptr %2, align 4, !dbg !905
  call arm_aapcscc void @ck_epoch_synchronize(ptr noundef %3), !dbg !906
  %4 = load ptr, ptr %2, align 4, !dbg !907
  call arm_aapcscc void @ck_epoch_reclaim(ptr noundef %4), !dbg !908
  ret void, !dbg !909
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc void @ck_epoch_barrier_wait(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 !dbg !910 {
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  store ptr %0, ptr %4, align 4
    #dbg_declare(ptr %4, !913, !DIExpression(), !914)
  store ptr %1, ptr %5, align 4
    #dbg_declare(ptr %5, !915, !DIExpression(), !916)
  store ptr %2, ptr %6, align 4
    #dbg_declare(ptr %6, !917, !DIExpression(), !918)
  %7 = load ptr, ptr %4, align 4, !dbg !919
  %8 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %7, i32 0, i32 1, !dbg !920
  %9 = load ptr, ptr %8, align 4, !dbg !920
  %10 = load ptr, ptr %5, align 4, !dbg !921
  %11 = load ptr, ptr %6, align 4, !dbg !922
  call arm_aapcscc void @ck_epoch_synchronize_wait(ptr noundef %9, ptr noundef %10, ptr noundef %11), !dbg !923
  %12 = load ptr, ptr %4, align 4, !dbg !924
  call arm_aapcscc void @ck_epoch_reclaim(ptr noundef %12), !dbg !925
  ret void, !dbg !926
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc zeroext i1 @ck_epoch_poll_deferred(ptr noundef %0, ptr noundef %1) #0 !dbg !927 {
  %3 = alloca i1, align 1
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca i8, align 1
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 4
  %9 = alloca ptr, align 4
  %10 = alloca i32, align 4
  store ptr %0, ptr %4, align 4
    #dbg_declare(ptr %4, !930, !DIExpression(), !931)
  store ptr %1, ptr %5, align 4
    #dbg_declare(ptr %5, !932, !DIExpression(), !933)
    #dbg_declare(ptr %6, !934, !DIExpression(), !935)
    #dbg_declare(ptr %7, !936, !DIExpression(), !937)
    #dbg_declare(ptr %8, !938, !DIExpression(), !939)
  store ptr null, ptr %8, align 4, !dbg !939
    #dbg_declare(ptr %9, !940, !DIExpression(), !941)
  %11 = load ptr, ptr %4, align 4, !dbg !942
  %12 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %11, i32 0, i32 1, !dbg !943
  %13 = load ptr, ptr %12, align 4, !dbg !943
  store ptr %13, ptr %9, align 4, !dbg !941
    #dbg_declare(ptr %10, !944, !DIExpression(), !945)
  %14 = load ptr, ptr %9, align 4, !dbg !946
  %15 = getelementptr inbounds nuw %struct.ck_epoch, ptr %14, i32 0, i32 0, !dbg !947
  %16 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %15), !dbg !948
  store i32 %16, ptr %7, align 4, !dbg !949
  call arm_aapcscc void @ck_pr_fence_memory(), !dbg !950
  %17 = load ptr, ptr %4, align 4, !dbg !951
  %18 = load i32, ptr %7, align 4, !dbg !952
  %19 = sub i32 %18, 2, !dbg !953
  %20 = load ptr, ptr %5, align 4, !dbg !954
  %21 = call arm_aapcscc i32 @ck_epoch_dispatch(ptr noundef %17, i32 noundef %19, ptr noundef %20), !dbg !955
  store i32 %21, ptr %10, align 4, !dbg !956
  %22 = load ptr, ptr %9, align 4, !dbg !957
  %23 = load ptr, ptr %8, align 4, !dbg !958
  %24 = load i32, ptr %7, align 4, !dbg !959
  %25 = call arm_aapcscc ptr @ck_epoch_scan(ptr noundef %22, ptr noundef %23, i32 noundef %24, ptr noundef %6), !dbg !960
  store ptr %25, ptr %8, align 4, !dbg !961
  %26 = load ptr, ptr %8, align 4, !dbg !962
  %27 = icmp ne ptr %26, null, !dbg !964
  br i1 %27, label %28, label %31, !dbg !964

28:                                               ; preds = %2
  %29 = load i32, ptr %10, align 4, !dbg !965
  %30 = icmp ugt i32 %29, 0, !dbg !966
  store i1 %30, ptr %3, align 1, !dbg !967
  br label %64, !dbg !967

31:                                               ; preds = %2
  %32 = load i8, ptr %6, align 1, !dbg !968
  %33 = trunc i8 %32 to i1, !dbg !968
  %34 = zext i1 %33 to i32, !dbg !968
  %35 = icmp eq i32 %34, 0, !dbg !970
  br i1 %35, label %36, label %52, !dbg !970

36:                                               ; preds = %31
  %37 = load i32, ptr %7, align 4, !dbg !971
  %38 = load ptr, ptr %4, align 4, !dbg !973
  %39 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %38, i32 0, i32 3, !dbg !974
  store i32 %37, ptr %39, align 4, !dbg !975
  store i32 0, ptr %7, align 4, !dbg !976
  br label %40, !dbg !978

40:                                               ; preds = %48, %36
  %41 = load i32, ptr %7, align 4, !dbg !979
  %42 = icmp ult i32 %41, 4, !dbg !981
  br i1 %42, label %43, label %51, !dbg !982

43:                                               ; preds = %40
  %44 = load ptr, ptr %4, align 4, !dbg !983
  %45 = load i32, ptr %7, align 4, !dbg !984
  %46 = load ptr, ptr %5, align 4, !dbg !985
  %47 = call arm_aapcscc i32 @ck_epoch_dispatch(ptr noundef %44, i32 noundef %45, ptr noundef %46), !dbg !986
  br label %48, !dbg !986

48:                                               ; preds = %43
  %49 = load i32, ptr %7, align 4, !dbg !987
  %50 = add i32 %49, 1, !dbg !987
  store i32 %50, ptr %7, align 4, !dbg !987
  br label %40, !dbg !988, !llvm.loop !989

51:                                               ; preds = %40
  store i1 true, ptr %3, align 1, !dbg !991
  br label %64, !dbg !991

52:                                               ; preds = %31
  %53 = load ptr, ptr %9, align 4, !dbg !992
  %54 = getelementptr inbounds nuw %struct.ck_epoch, ptr %53, i32 0, i32 0, !dbg !993
  %55 = load i32, ptr %7, align 4, !dbg !994
  %56 = load i32, ptr %7, align 4, !dbg !995
  %57 = add i32 %56, 1, !dbg !996
  %58 = call arm_aapcscc zeroext i1 @ck_pr_cas_uint(ptr noundef %54, i32 noundef %55, i32 noundef %57), !dbg !997
  %59 = load ptr, ptr %4, align 4, !dbg !998
  %60 = load i32, ptr %7, align 4, !dbg !999
  %61 = sub i32 %60, 1, !dbg !1000
  %62 = load ptr, ptr %5, align 4, !dbg !1001
  %63 = call arm_aapcscc i32 @ck_epoch_dispatch(ptr noundef %59, i32 noundef %61, ptr noundef %62), !dbg !1002
  store i1 true, ptr %3, align 1, !dbg !1003
  br label %64, !dbg !1003

64:                                               ; preds = %52, %51, %28
  %65 = load i1, ptr %3, align 1, !dbg !1004
  ret i1 %65, !dbg !1004
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc zeroext i1 @ck_pr_cas_uint(ptr noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !1005 {
  %4 = alloca ptr, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 4
    #dbg_declare(ptr %4, !1008, !DIExpression(), !1009)
  store i32 %1, ptr %5, align 4
    #dbg_declare(ptr %5, !1010, !DIExpression(), !1009)
  store i32 %2, ptr %6, align 4
    #dbg_declare(ptr %6, !1011, !DIExpression(), !1009)
    #dbg_declare(ptr %7, !1012, !DIExpression(), !1009)
  store i32 0, ptr %7, align 4, !dbg !1009
    #dbg_declare(ptr %8, !1013, !DIExpression(), !1009)
  store i32 0, ptr %8, align 4, !dbg !1009
  %9 = load i32, ptr %7, align 4, !dbg !1009
  %10 = load i32, ptr %8, align 4, !dbg !1009
  %11 = load ptr, ptr %4, align 4, !dbg !1009
  %12 = load i32, ptr %6, align 4, !dbg !1009
  %13 = load i32, ptr %5, align 4, !dbg !1009
  %14 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];cmp   $0, $4;itt eq;strexeq $1, $3, [$2];cmpeq   $1, #1;beq   1b;", "=&r,=&r,r,r,r,0,1,~{memory},~{cc}"(ptr %11, i32 %12, i32 %13, i32 %9, i32 %10) #3, !dbg !1009, !srcloc !1014
  %15 = extractvalue { i32, i32 } %14, 0, !dbg !1009
  %16 = extractvalue { i32, i32 } %14, 1, !dbg !1009
  store i32 %15, ptr %7, align 4, !dbg !1009
  store i32 %16, ptr %8, align 4, !dbg !1009
  %17 = load i32, ptr %7, align 4, !dbg !1009
  %18 = load i32, ptr %5, align 4, !dbg !1009
  %19 = icmp eq i32 %17, %18, !dbg !1009
  ret i1 %19, !dbg !1009
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc zeroext i1 @ck_epoch_poll(ptr noundef %0) #0 !dbg !1015 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !1018, !DIExpression(), !1019)
  %3 = load ptr, ptr %2, align 4, !dbg !1020
  %4 = call arm_aapcscc zeroext i1 @ck_epoch_poll_deferred(ptr noundef %3, ptr noundef null), !dbg !1021
  ret i1 %4, !dbg !1022
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc i32 @main(i32 noundef %0, ptr noundef %1) #0 !dbg !1023 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 4
  %6 = alloca [4 x ptr], align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
    #dbg_declare(ptr %4, !1027, !DIExpression(), !1028)
  store ptr %1, ptr %5, align 4
    #dbg_declare(ptr %5, !1029, !DIExpression(), !1030)
    #dbg_declare(ptr %6, !1031, !DIExpression(), !1035)
  call arm_aapcscc void @ck_epoch_init(ptr noundef @stack_epoch), !dbg !1036
    #dbg_declare(ptr %7, !1037, !DIExpression(), !1039)
  store i32 0, ptr %7, align 4, !dbg !1039
  br label %9, !dbg !1040

9:                                                ; preds = %20, %2
  %10 = load i32, ptr %7, align 4, !dbg !1041
  %11 = icmp slt i32 %10, 4, !dbg !1043
  br i1 %11, label %12, label %23, !dbg !1044

12:                                               ; preds = %9
  %13 = load i32, ptr %7, align 4, !dbg !1045
  %14 = getelementptr inbounds [4 x %struct.ck_epoch_record], ptr @records, i32 0, i32 %13, !dbg !1047
  call arm_aapcscc void @ck_epoch_register(ptr noundef @stack_epoch, ptr noundef %14, ptr noundef null), !dbg !1048
  %15 = load i32, ptr %7, align 4, !dbg !1049
  %16 = getelementptr inbounds [4 x ptr], ptr %6, i32 0, i32 %15, !dbg !1050
  %17 = load i32, ptr %7, align 4, !dbg !1051
  %18 = getelementptr inbounds [4 x %struct.ck_epoch_record], ptr @records, i32 0, i32 %17, !dbg !1052
  %19 = call arm_aapcscc i32 @pthread_create(ptr noundef %16, ptr noundef null, ptr noundef @thread, ptr noundef %18), !dbg !1053
  br label %20, !dbg !1054

20:                                               ; preds = %12
  %21 = load i32, ptr %7, align 4, !dbg !1055
  %22 = add nsw i32 %21, 1, !dbg !1055
  store i32 %22, ptr %7, align 4, !dbg !1055
  br label %9, !dbg !1056, !llvm.loop !1057

23:                                               ; preds = %9
    #dbg_declare(ptr %8, !1059, !DIExpression(), !1061)
  store i32 0, ptr %8, align 4, !dbg !1061
  br label %24, !dbg !1062

24:                                               ; preds = %32, %23
  %25 = load i32, ptr %8, align 4, !dbg !1063
  %26 = icmp slt i32 %25, 4, !dbg !1065
  br i1 %26, label %27, label %35, !dbg !1066

27:                                               ; preds = %24
  %28 = load i32, ptr %8, align 4, !dbg !1067
  %29 = getelementptr inbounds [4 x ptr], ptr %6, i32 0, i32 %28, !dbg !1068
  %30 = load ptr, ptr %29, align 4, !dbg !1068
  %31 = call arm_aapcscc i32 @pthread_join(ptr noundef %30, ptr noundef null), !dbg !1069
  br label %32, !dbg !1069

32:                                               ; preds = %27
  %33 = load i32, ptr %8, align 4, !dbg !1070
  %34 = add nsw i32 %33, 1, !dbg !1070
  store i32 %34, ptr %8, align 4, !dbg !1070
  br label %24, !dbg !1071, !llvm.loop !1072

35:                                               ; preds = %24
  ret i32 0, !dbg !1074
}

declare arm_aapcscc i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc ptr @thread(ptr noundef %0) #0 !dbg !1075 {
  %2 = alloca i1, align 1
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  %7 = alloca ptr, align 4
  %8 = alloca i32, align 4
  %9 = alloca ptr, align 4
  %10 = alloca ptr, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  store ptr %0, ptr %9, align 4
    #dbg_declare(ptr %9, !1078, !DIExpression(), !1079)
    #dbg_declare(ptr %10, !1080, !DIExpression(), !1081)
  %13 = load ptr, ptr %9, align 4, !dbg !1082
  store ptr %13, ptr %10, align 4, !dbg !1081
  %14 = load ptr, ptr %10, align 4, !dbg !1083
  store ptr %14, ptr %5, align 4
    #dbg_declare(ptr %5, !1084, !DIExpression(), !1090)
  store ptr null, ptr %6, align 4
    #dbg_declare(ptr %6, !1092, !DIExpression(), !1093)
    #dbg_declare(ptr %7, !1094, !DIExpression(), !1095)
  %15 = load ptr, ptr %5, align 4, !dbg !1096
  %16 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %15, i32 0, i32 1, !dbg !1097
  %17 = load ptr, ptr %16, align 4, !dbg !1097
  store ptr %17, ptr %7, align 4, !dbg !1095
  %18 = load ptr, ptr %5, align 4, !dbg !1098
  %19 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %18, i32 0, i32 4, !dbg !1100
  %20 = load i32, ptr %19, align 16, !dbg !1100
  %21 = icmp eq i32 %20, 0, !dbg !1101
  br i1 %21, label %22, label %30, !dbg !1101

22:                                               ; preds = %1
    #dbg_declare(ptr %8, !1102, !DIExpression(), !1104)
  %23 = load ptr, ptr %5, align 4, !dbg !1105
  %24 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %23, i32 0, i32 4, !dbg !1106
  call arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %24, i32 noundef 1), !dbg !1107
  call arm_aapcscc void @ck_pr_fence_memory(), !dbg !1108
  %25 = load ptr, ptr %7, align 4, !dbg !1109
  %26 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %25), !dbg !1110
  store i32 %26, ptr %8, align 4, !dbg !1111
  %27 = load ptr, ptr %5, align 4, !dbg !1112
  %28 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %27, i32 0, i32 3, !dbg !1113
  %29 = load i32, ptr %8, align 4, !dbg !1114
  call arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %28, i32 noundef %29), !dbg !1115
  br label %37, !dbg !1116

30:                                               ; preds = %1
  %31 = load ptr, ptr %5, align 4, !dbg !1117
  %32 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %31, i32 0, i32 4, !dbg !1119
  %33 = load ptr, ptr %5, align 4, !dbg !1120
  %34 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %33, i32 0, i32 4, !dbg !1121
  %35 = load i32, ptr %34, align 16, !dbg !1121
  %36 = add i32 %35, 1, !dbg !1122
  call arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %32, i32 noundef %36), !dbg !1123
  br label %37

37:                                               ; preds = %30, %22
  %38 = load ptr, ptr %6, align 4, !dbg !1124
  %39 = icmp ne ptr %38, null, !dbg !1126
  br i1 %39, label %40, label %43, !dbg !1126

40:                                               ; preds = %37
  %41 = load ptr, ptr %5, align 4, !dbg !1127
  %42 = load ptr, ptr %6, align 4, !dbg !1128
  call arm_aapcscc void @_ck_epoch_addref(ptr noundef %41, ptr noundef %42), !dbg !1129
  br label %43, !dbg !1129

43:                                               ; preds = %37, %40
    #dbg_declare(ptr %11, !1130, !DIExpression(), !1131)
  %44 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef @stack_epoch), !dbg !1132
  store i32 %44, ptr %11, align 4, !dbg !1131
    #dbg_declare(ptr %12, !1133, !DIExpression(), !1134)
  %45 = load ptr, ptr %10, align 4, !dbg !1135
  %46 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %45, i32 0, i32 3, !dbg !1136
  %47 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %46), !dbg !1137
  store i32 %47, ptr %12, align 4, !dbg !1134
  %48 = load ptr, ptr %10, align 4, !dbg !1138
  store ptr %48, ptr %3, align 4
    #dbg_declare(ptr %3, !1139, !DIExpression(), !1143)
  store ptr null, ptr %4, align 4
    #dbg_declare(ptr %4, !1145, !DIExpression(), !1146)
  call arm_aapcscc void @ck_pr_fence_release(), !dbg !1147
  %49 = load ptr, ptr %3, align 4, !dbg !1148
  %50 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %49, i32 0, i32 4, !dbg !1149
  %51 = load ptr, ptr %3, align 4, !dbg !1150
  %52 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %51, i32 0, i32 4, !dbg !1151
  %53 = load i32, ptr %52, align 16, !dbg !1151
  %54 = sub i32 %53, 1, !dbg !1152
  call arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %50, i32 noundef %54), !dbg !1153
  %55 = load ptr, ptr %4, align 4, !dbg !1154
  %56 = icmp ne ptr %55, null, !dbg !1156
  br i1 %56, label %57, label %61, !dbg !1156

57:                                               ; preds = %43
  %58 = load ptr, ptr %3, align 4, !dbg !1157
  %59 = load ptr, ptr %4, align 4, !dbg !1158
  %60 = call arm_aapcscc zeroext i1 @_ck_epoch_delref(ptr noundef %58, ptr noundef %59), !dbg !1159
  store i1 %60, ptr %2, align 1, !dbg !1160
  br label %66, !dbg !1160

61:                                               ; preds = %43
  %62 = load ptr, ptr %3, align 4, !dbg !1161
  %63 = getelementptr inbounds nuw %struct.ck_epoch_record, ptr %62, i32 0, i32 4, !dbg !1162
  %64 = load i32, ptr %63, align 16, !dbg !1162
  %65 = icmp eq i32 %64, 0, !dbg !1163
  store i1 %65, ptr %2, align 1, !dbg !1164
  br label %66, !dbg !1164

66:                                               ; preds = %57, %61
  %67 = load i1, ptr %2, align 1, !dbg !1165
  %68 = load i32, ptr %12, align 4, !dbg !1166
  %69 = icmp eq i32 %68, 1, !dbg !1169
  br i1 %69, label %70, label %74, !dbg !1170

70:                                               ; preds = %66
  %71 = load i32, ptr %11, align 4, !dbg !1171
  %72 = icmp eq i32 %71, 3, !dbg !1172
  br i1 %72, label %73, label %74, !dbg !1173

73:                                               ; preds = %70
  call arm_aapcscc void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 24, ptr noundef @__func__.thread), !dbg !1173
  br label %74, !dbg !1173

74:                                               ; preds = %73, %70, %66
  %75 = load ptr, ptr %10, align 4, !dbg !1174
  %76 = call arm_aapcscc zeroext i1 @ck_epoch_poll(ptr noundef %75), !dbg !1175
  ret ptr null, !dbg !1176
}

declare arm_aapcscc i32 @pthread_join(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_acqrel() #0 !dbg !1177 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #3, !dbg !1178, !srcloc !1179
  ret void, !dbg !1180
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_store() #0 !dbg !1181 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #3, !dbg !1182, !srcloc !1183
  ret void, !dbg !1184
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_load() #0 !dbg !1185 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #3, !dbg !1186, !srcloc !1187
  ret void, !dbg !1188
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 !dbg !1189 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !1192, !DIExpression(), !1193)
    #dbg_declare(ptr %3, !1194, !DIExpression(), !1193)
  store i32 0, ptr %3, align 4, !dbg !1193
  %4 = load ptr, ptr %2, align 4, !dbg !1193
  %5 = call i32 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #3, !dbg !1193, !srcloc !1195
  store i32 %5, ptr %3, align 4, !dbg !1193
  %6 = load i32, ptr %3, align 4, !dbg !1193
  %7 = inttoptr i32 %6 to ptr, !dbg !1193
  ret ptr %7, !dbg !1193
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 !dbg !1196 {
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  %7 = alloca ptr, align 4
  %8 = alloca ptr, align 4
  %9 = alloca ptr, align 4
  %10 = alloca ptr, align 4
  store ptr %0, ptr %5, align 4
    #dbg_declare(ptr %5, !1199, !DIExpression(), !1200)
  store ptr %1, ptr %6, align 4
    #dbg_declare(ptr %6, !1201, !DIExpression(), !1202)
  store ptr %2, ptr %7, align 4
    #dbg_declare(ptr %7, !1203, !DIExpression(), !1204)
  store ptr %3, ptr %8, align 4
    #dbg_declare(ptr %8, !1205, !DIExpression(), !1206)
    #dbg_declare(ptr %9, !1207, !DIExpression(), !1208)
    #dbg_declare(ptr %10, !1209, !DIExpression(), !1210)
  %11 = load ptr, ptr %5, align 4, !dbg !1211
  %12 = load ptr, ptr %7, align 4, !dbg !1212
  %13 = load ptr, ptr %6, align 4, !dbg !1213
  %14 = call { ptr, ptr } asm sideeffect "1:ldrex $0, [$2];cmp   $0, $4;itt eq;strexeq $1, $3, [$2];cmpeq   $1, #1;beq   1b;", "=&r,=&r,r,r,r,~{memory},~{cc}"(ptr %11, ptr %12, ptr %13) #3, !dbg !1214, !srcloc !1215
  %15 = extractvalue { ptr, ptr } %14, 0, !dbg !1214
  %16 = extractvalue { ptr, ptr } %14, 1, !dbg !1214
  store ptr %15, ptr %9, align 4, !dbg !1214
  store ptr %16, ptr %10, align 4, !dbg !1214
  %17 = load ptr, ptr %9, align 4, !dbg !1216
  %18 = load ptr, ptr %8, align 4, !dbg !1217
  store ptr %17, ptr %18, align 4, !dbg !1218
  %19 = load ptr, ptr %9, align 4, !dbg !1219
  %20 = load ptr, ptr %6, align 4, !dbg !1220
  %21 = icmp eq ptr %19, %20, !dbg !1221
  ret i1 %21, !dbg !1222
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc ptr @ck_stack_batch_pop_upmc(ptr noundef %0) #0 !dbg !1223 {
  %2 = alloca ptr, align 4
  %3 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !1226, !DIExpression(), !1227)
    #dbg_declare(ptr %3, !1228, !DIExpression(), !1229)
  %4 = load ptr, ptr %2, align 4, !dbg !1230
  %5 = getelementptr inbounds nuw %struct.ck_stack, ptr %4, i32 0, i32 0, !dbg !1231
  %6 = call arm_aapcscc ptr @ck_pr_fas_ptr(ptr noundef %5, ptr noundef null), !dbg !1232
  store ptr %6, ptr %3, align 4, !dbg !1233
  call arm_aapcscc void @ck_pr_fence_load(), !dbg !1234
  %7 = load ptr, ptr %3, align 4, !dbg !1235
  ret ptr %7, !dbg !1236
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc ptr @ck_epoch_entry_container(ptr noundef %0) #0 !dbg !1237 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !1240, !DIExpression(), !1241)
  %3 = load ptr, ptr %2, align 4, !dbg !1241
  %4 = getelementptr inbounds i8, ptr %3, i32 -4, !dbg !1241
  ret ptr %4, !dbg !1241
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_stack_push_spnc(ptr noundef %0, ptr noundef %1) #0 !dbg !1242 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !1243, !DIExpression(), !1244)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !1245, !DIExpression(), !1246)
  %5 = load ptr, ptr %3, align 4, !dbg !1247
  %6 = getelementptr inbounds nuw %struct.ck_stack, ptr %5, i32 0, i32 0, !dbg !1248
  %7 = load ptr, ptr %6, align 4, !dbg !1248
  %8 = load ptr, ptr %4, align 4, !dbg !1249
  %9 = getelementptr inbounds nuw %struct.ck_stack_entry, ptr %8, i32 0, i32 0, !dbg !1250
  store ptr %7, ptr %9, align 4, !dbg !1251
  %10 = load ptr, ptr %4, align 4, !dbg !1252
  %11 = load ptr, ptr %3, align 4, !dbg !1253
  %12 = getelementptr inbounds nuw %struct.ck_stack, ptr %11, i32 0, i32 0, !dbg !1254
  store ptr %10, ptr %12, align 4, !dbg !1255
  ret void, !dbg !1256
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_add_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !1257 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !1258, !DIExpression(), !1259)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !1260, !DIExpression(), !1259)
    #dbg_declare(ptr %5, !1261, !DIExpression(), !1259)
  store i32 0, ptr %5, align 4, !dbg !1259
    #dbg_declare(ptr %6, !1262, !DIExpression(), !1259)
  store i32 0, ptr %6, align 4, !dbg !1259
  %7 = load i32, ptr %5, align 4, !dbg !1259
  %8 = load i32, ptr %6, align 4, !dbg !1259
  %9 = load ptr, ptr %3, align 4, !dbg !1259
  %10 = load i32, ptr %4, align 4, !dbg !1259
  %11 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];add $0, $0, $3;strex $1, $0, [$2];cmp $1, #0;bne 1b;", "=&r,=&r,r,r,0,1,~{memory},~{cc}"(ptr %9, i32 %10, i32 %7, i32 %8) #3, !dbg !1259, !srcloc !1263
  %12 = extractvalue { i32, i32 } %11, 0, !dbg !1259
  %13 = extractvalue { i32, i32 } %11, 1, !dbg !1259
  store i32 %12, ptr %5, align 4, !dbg !1259
  store i32 %13, ptr %6, align 4, !dbg !1259
  ret void, !dbg !1259
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_sub_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !1264 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !1265, !DIExpression(), !1266)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !1267, !DIExpression(), !1266)
    #dbg_declare(ptr %5, !1268, !DIExpression(), !1266)
  store i32 0, ptr %5, align 4, !dbg !1266
    #dbg_declare(ptr %6, !1269, !DIExpression(), !1266)
  store i32 0, ptr %6, align 4, !dbg !1266
  %7 = load i32, ptr %5, align 4, !dbg !1266
  %8 = load i32, ptr %6, align 4, !dbg !1266
  %9 = load ptr, ptr %3, align 4, !dbg !1266
  %10 = load i32, ptr %4, align 4, !dbg !1266
  %11 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];sub $0, $0, $3;strex $1, $0, [$2];cmp $1, #0;bne 1b;", "=&r,=&r,r,r,0,1,~{memory},~{cc}"(ptr %9, i32 %10, i32 %7, i32 %8) #3, !dbg !1266, !srcloc !1270
  %12 = extractvalue { i32, i32 } %11, 0, !dbg !1266
  %13 = extractvalue { i32, i32 } %11, 1, !dbg !1266
  store i32 %12, ptr %5, align 4, !dbg !1266
  store i32 %13, ptr %6, align 4, !dbg !1266
  ret void, !dbg !1266
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc ptr @ck_pr_fas_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !1271 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !1274, !DIExpression(), !1275)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !1276, !DIExpression(), !1275)
    #dbg_declare(ptr %5, !1277, !DIExpression(), !1275)
  store ptr null, ptr %5, align 4, !dbg !1275
    #dbg_declare(ptr %6, !1278, !DIExpression(), !1275)
  store ptr null, ptr %6, align 4, !dbg !1275
  %7 = load ptr, ptr %5, align 4, !dbg !1275
  %8 = load ptr, ptr %6, align 4, !dbg !1275
  %9 = load ptr, ptr %3, align 4, !dbg !1275
  %10 = load ptr, ptr %4, align 4, !dbg !1275
  %11 = call { ptr, ptr } asm sideeffect "1:ldrex $0, [$2];strex $1, $3, [$2];cmp $1, #0;bne 1b;", "=&r,=&r,r,r,0,1,~{memory},~{cc}"(ptr %9, ptr %10, ptr %7, ptr %8) #3, !dbg !1275, !srcloc !1279
  %12 = extractvalue { ptr, ptr } %11, 0, !dbg !1275
  %13 = extractvalue { ptr, ptr } %11, 1, !dbg !1275
  store ptr %12, ptr %5, align 4, !dbg !1275
  store ptr %13, ptr %6, align 4, !dbg !1275
  %14 = load ptr, ptr %5, align 4, !dbg !1275
  ret ptr %14, !dbg !1275
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_memory() #0 !dbg !1280 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #3, !dbg !1281, !srcloc !1282
  ret void, !dbg !1283
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_atomic_load() #0 !dbg !1284 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #3, !dbg !1285, !srcloc !1286
  ret void, !dbg !1287
}

declare arm_aapcscc void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_release() #0 !dbg !1288 {
  call arm_aapcscc void @ck_pr_fence_strict_release(), !dbg !1289
  ret void, !dbg !1289
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_release() #0 !dbg !1290 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #3, !dbg !1291, !srcloc !1292
  ret void, !dbg !1293
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!99, !100, !101, !102, !103, !104, !105}
!llvm.ident = !{!106}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "stack_epoch", scope: !2, file: !3, line: 10, type: !98, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !11, globals: !78, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/ebr.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "3b6e5ded9817bbb1e26684db43e6a027")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 138, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../ck/src/ck_epoch.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6acf017f2c970ef5b9eb888b55a36640")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10}
!9 = !DIEnumerator(name: "CK_EPOCH_STATE_USED", value: 0)
!10 = !DIEnumerator(name: "CK_EPOCH_STATE_FREE", value: 1)
!11 = !{!12, !15, !16, !7, !17, !40, !27, !64, !65, !76}
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !13, line: 4, baseType: !14)
!13 = !DIFile(filename: "include/libc/stdbool.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6e643322591bab80343344357c642cba")
!14 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!15 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 32)
!18 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_record", file: !19, line: 85, size: 1024, align: 512, elements: !20)
!19 = !DIFile(filename: "../ck/include/ck_epoch.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "2210cffd498b468d38353410cd7d3066")
!20 = !{!21, !28, !42, !43, !44, !45, !56, !57, !58, !59, !60}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "record_next", scope: !18, file: !19, line: 86, baseType: !22, size: 32)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_entry_t", file: !23, line: 38, baseType: !24)
!23 = !DIFile(filename: "../ck/include/ck_stack.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "19674f5fb31e41969a7583ca1d1160b2")
!24 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack_entry", file: !23, line: 35, size: 32, elements: !25)
!25 = !{!26}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !24, file: !23, line: 36, baseType: !27, size: 32)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 32)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "global", scope: !18, file: !19, line: 87, baseType: !29, size: 32, offset: 32)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 32)
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch", file: !19, line: 102, size: 128, elements: !31)
!31 = !{!32, !33, !34}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "epoch", scope: !30, file: !19, line: 103, baseType: !7, size: 32)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "n_free", scope: !30, file: !19, line: 104, baseType: !7, size: 32, offset: 32)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "records", scope: !30, file: !19, line: 105, baseType: !35, size: 64, offset: 64)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_t", file: !23, line: 44, baseType: !36)
!36 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack", file: !23, line: 40, size: 64, elements: !37)
!37 = !{!38, !39}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !36, file: !23, line: 41, baseType: !27, size: 32)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "generation", scope: !36, file: !23, line: 42, baseType: !40, size: 32, offset: 32)
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 32)
!41 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !18, file: !19, line: 88, baseType: !7, size: 32, offset: 64)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "epoch", scope: !18, file: !19, line: 89, baseType: !7, size: 32, offset: 96)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "active", scope: !18, file: !19, line: 90, baseType: !7, size: 32, offset: 128)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "local", scope: !18, file: !19, line: 93, baseType: !46, size: 128, align: 512, offset: 512)
!46 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !18, file: !19, line: 91, size: 128, elements: !47)
!47 = !{!48}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "bucket", scope: !46, file: !19, line: 92, baseType: !49, size: 128)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 128, elements: !54)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_ref", file: !19, line: 80, size: 64, elements: !51)
!51 = !{!52, !53}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "epoch", scope: !50, file: !19, line: 81, baseType: !7, size: 32)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !50, file: !19, line: 82, baseType: !7, size: 32, offset: 32)
!54 = !{!55}
!55 = !DISubrange(count: 2)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "n_pending", scope: !18, file: !19, line: 94, baseType: !7, size: 32, offset: 640)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "n_peak", scope: !18, file: !19, line: 95, baseType: !7, size: 32, offset: 672)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "n_dispatch", scope: !18, file: !19, line: 96, baseType: !7, size: 32, offset: 704)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "ct", scope: !18, file: !19, line: 97, baseType: !16, size: 32, offset: 736)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "pending", scope: !18, file: !19, line: 98, baseType: !61, size: 256, offset: 768)
!61 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 256, elements: !62)
!62 = !{!63}
!63 = !DISubrange(count: 4)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 32)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 32)
!66 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_entry", file: !19, line: 60, size: 64, elements: !67)
!67 = !{!68, !75}
!68 = !DIDerivedType(tag: DW_TAG_member, name: "function", scope: !66, file: !19, line: 61, baseType: !69, size: 32)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 32)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_cb_t", file: !19, line: 54, baseType: !71)
!71 = !DISubroutineType(types: !72)
!72 = !{null, !73}
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 32)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_entry_t", file: !19, line: 53, baseType: !66)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "stack_entry", scope: !66, file: !19, line: 62, baseType: !22, size: 32, offset: 32)
!76 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !77, size: 32)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_record_t", file: !19, line: 100, baseType: !18)
!78 = !{!0, !79, !82, !87, !92}
!79 = !DIGlobalVariableExpression(var: !80, expr: !DIExpression())
!80 = distinct !DIGlobalVariable(name: "records", scope: !2, file: !3, line: 31, type: !81, isLocal: false, isDefinition: true)
!81 = !DICompositeType(tag: DW_TAG_array_type, baseType: !77, size: 4096, align: 512, elements: !62)
!82 = !DIGlobalVariableExpression(var: !83, expr: !DIExpression())
!83 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !84, isLocal: true, isDefinition: true)
!84 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 328, elements: !85)
!85 = !{!86}
!86 = !DISubrange(count: 41)
!87 = !DIGlobalVariableExpression(var: !88, expr: !DIExpression())
!88 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !89, isLocal: true, isDefinition: true)
!89 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 160, elements: !90)
!90 = !{!91}
!91 = !DISubrange(count: 20)
!92 = !DIGlobalVariableExpression(var: !93, expr: !DIExpression())
!93 = distinct !DIGlobalVariable(scope: null, file: !3, line: 24, type: !94, isLocal: true, isDefinition: true)
!94 = !DICompositeType(tag: DW_TAG_array_type, baseType: !95, size: 56, elements: !96)
!95 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !41)
!96 = !{!97}
!97 = !DISubrange(count: 7)
!98 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_t", file: !19, line: 107, baseType: !30)
!99 = !{i32 7, !"Dwarf Version", i32 5}
!100 = !{i32 2, !"Debug Info Version", i32 3}
!101 = !{i32 1, !"wchar_size", i32 4}
!102 = !{i32 1, !"min_enum_size", i32 4}
!103 = !{i32 8, !"PIC Level", i32 2}
!104 = !{i32 7, !"PIE Level", i32 2}
!105 = !{i32 7, !"frame-pointer", i32 2}
!106 = !{!"Homebrew clang version 22.1.8"}
!107 = distinct !DISubprogram(name: "_ck_epoch_delref", scope: !6, file: !6, line: 151, type: !108, scopeLine: 153, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !114)
!108 = !DISubroutineType(types: !109)
!109 = !{!12, !17, !110}
!110 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !111, size: 32)
!111 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_section", file: !19, line: 69, size: 32, elements: !112)
!112 = !{!113}
!113 = !DIDerivedType(tag: DW_TAG_member, name: "bucket", scope: !111, file: !19, line: 70, baseType: !7, size: 32)
!114 = !{}
!115 = !DILocalVariable(name: "record", arg: 1, scope: !107, file: !6, line: 151, type: !17)
!116 = !DILocation(line: 151, column: 42, scope: !107)
!117 = !DILocalVariable(name: "section", arg: 2, scope: !107, file: !6, line: 152, type: !110)
!118 = !DILocation(line: 152, column: 30, scope: !107)
!119 = !DILocalVariable(name: "current", scope: !107, file: !6, line: 154, type: !120)
!120 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 32)
!121 = !DILocation(line: 154, column: 23, scope: !107)
!122 = !DILocalVariable(name: "other", scope: !107, file: !6, line: 154, type: !120)
!123 = !DILocation(line: 154, column: 33, scope: !107)
!124 = !DILocalVariable(name: "i", scope: !107, file: !6, line: 155, type: !7)
!125 = !DILocation(line: 155, column: 15, scope: !107)
!126 = !DILocation(line: 155, column: 19, scope: !107)
!127 = !DILocation(line: 155, column: 28, scope: !107)
!128 = !DILocation(line: 157, column: 13, scope: !107)
!129 = !DILocation(line: 157, column: 21, scope: !107)
!130 = !DILocation(line: 157, column: 27, scope: !107)
!131 = !DILocation(line: 157, column: 34, scope: !107)
!132 = !DILocation(line: 157, column: 10, scope: !107)
!133 = !DILocation(line: 158, column: 2, scope: !107)
!134 = !DILocation(line: 158, column: 11, scope: !107)
!135 = !DILocation(line: 158, column: 16, scope: !107)
!136 = !DILocation(line: 160, column: 6, scope: !137)
!137 = distinct !DILexicalBlock(scope: !107, file: !6, line: 160, column: 6)
!138 = !DILocation(line: 160, column: 15, scope: !137)
!139 = !DILocation(line: 160, column: 21, scope: !137)
!140 = !DILocation(line: 161, column: 3, scope: !137)
!141 = !DILocation(line: 172, column: 11, scope: !107)
!142 = !DILocation(line: 172, column: 19, scope: !107)
!143 = !DILocation(line: 172, column: 25, scope: !107)
!144 = !DILocation(line: 172, column: 33, scope: !107)
!145 = !DILocation(line: 172, column: 35, scope: !107)
!146 = !DILocation(line: 172, column: 40, scope: !107)
!147 = !DILocation(line: 172, column: 8, scope: !107)
!148 = !DILocation(line: 173, column: 6, scope: !149)
!149 = distinct !DILexicalBlock(scope: !107, file: !6, line: 173, column: 6)
!150 = !DILocation(line: 173, column: 13, scope: !149)
!151 = !DILocation(line: 173, column: 19, scope: !149)
!152 = !DILocation(line: 173, column: 23, scope: !149)
!153 = !DILocation(line: 174, column: 13, scope: !149)
!154 = !DILocation(line: 174, column: 22, scope: !149)
!155 = !DILocation(line: 174, column: 30, scope: !149)
!156 = !DILocation(line: 174, column: 37, scope: !149)
!157 = !DILocation(line: 174, column: 28, scope: !149)
!158 = !DILocation(line: 174, column: 44, scope: !149)
!159 = !DILocation(line: 179, column: 21, scope: !160)
!160 = distinct !DILexicalBlock(scope: !149, file: !6, line: 174, column: 50)
!161 = !DILocation(line: 179, column: 29, scope: !160)
!162 = !DILocation(line: 179, column: 36, scope: !160)
!163 = !DILocation(line: 179, column: 43, scope: !160)
!164 = !DILocation(line: 179, column: 3, scope: !160)
!165 = !DILocation(line: 180, column: 2, scope: !160)
!166 = !DILocation(line: 182, column: 2, scope: !107)
!167 = !DILocation(line: 183, column: 1, scope: !107)
!168 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !169, file: !169, line: 176, type: !170, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!169 = !DIFile(filename: "../ck/include/gcc/arm/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f3f9fb174933d4f9d5af6678feea8d14")
!170 = !DISubroutineType(types: !171)
!171 = !{null, !172, !7}
!172 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 32)
!173 = !DILocalVariable(name: "target", arg: 1, scope: !168, file: !169, line: 176, type: !172)
!174 = !DILocation(line: 176, column: 1, scope: !168)
!175 = !DILocalVariable(name: "v", arg: 2, scope: !168, file: !169, line: 176, type: !7)
!176 = !{i64 2147600589}
!177 = distinct !DISubprogram(name: "_ck_epoch_addref", scope: !6, file: !6, line: 186, type: !178, scopeLine: 188, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !114)
!178 = !DISubroutineType(types: !179)
!179 = !{null, !17, !110}
!180 = !DILocalVariable(name: "record", arg: 1, scope: !177, file: !6, line: 186, type: !17)
!181 = !DILocation(line: 186, column: 42, scope: !177)
!182 = !DILocalVariable(name: "section", arg: 2, scope: !177, file: !6, line: 187, type: !110)
!183 = !DILocation(line: 187, column: 30, scope: !177)
!184 = !DILocalVariable(name: "global", scope: !177, file: !6, line: 189, type: !29)
!185 = !DILocation(line: 189, column: 19, scope: !177)
!186 = !DILocation(line: 189, column: 28, scope: !177)
!187 = !DILocation(line: 189, column: 36, scope: !177)
!188 = !DILocalVariable(name: "ref", scope: !177, file: !6, line: 190, type: !120)
!189 = !DILocation(line: 190, column: 23, scope: !177)
!190 = !DILocalVariable(name: "epoch", scope: !177, file: !6, line: 191, type: !7)
!191 = !DILocation(line: 191, column: 15, scope: !177)
!192 = !DILocalVariable(name: "i", scope: !177, file: !6, line: 191, type: !7)
!193 = !DILocation(line: 191, column: 22, scope: !177)
!194 = !DILocation(line: 193, column: 27, scope: !177)
!195 = !DILocation(line: 193, column: 35, scope: !177)
!196 = !DILocation(line: 193, column: 10, scope: !177)
!197 = !DILocation(line: 193, column: 8, scope: !177)
!198 = !DILocation(line: 194, column: 6, scope: !177)
!199 = !DILocation(line: 194, column: 12, scope: !177)
!200 = !DILocation(line: 194, column: 4, scope: !177)
!201 = !DILocation(line: 195, column: 9, scope: !177)
!202 = !DILocation(line: 195, column: 17, scope: !177)
!203 = !DILocation(line: 195, column: 23, scope: !177)
!204 = !DILocation(line: 195, column: 30, scope: !177)
!205 = !DILocation(line: 195, column: 6, scope: !177)
!206 = !DILocation(line: 197, column: 6, scope: !207)
!207 = distinct !DILexicalBlock(scope: !177, file: !6, line: 197, column: 6)
!208 = !DILocation(line: 197, column: 11, scope: !207)
!209 = !DILocation(line: 197, column: 16, scope: !207)
!210 = !DILocation(line: 197, column: 19, scope: !207)
!211 = !DILocalVariable(name: "previous", scope: !212, file: !6, line: 199, type: !120)
!212 = distinct !DILexicalBlock(scope: !207, file: !6, line: 197, column: 25)
!213 = !DILocation(line: 199, column: 24, scope: !212)
!214 = !DILocation(line: 211, column: 15, scope: !212)
!215 = !DILocation(line: 211, column: 23, scope: !212)
!216 = !DILocation(line: 211, column: 29, scope: !212)
!217 = !DILocation(line: 211, column: 37, scope: !212)
!218 = !DILocation(line: 211, column: 39, scope: !212)
!219 = !DILocation(line: 211, column: 44, scope: !212)
!220 = !DILocation(line: 211, column: 12, scope: !212)
!221 = !DILocation(line: 213, column: 7, scope: !222)
!222 = distinct !DILexicalBlock(scope: !212, file: !6, line: 213, column: 7)
!223 = !DILocation(line: 213, column: 17, scope: !222)
!224 = !DILocation(line: 213, column: 23, scope: !222)
!225 = !DILocation(line: 214, column: 4, scope: !222)
!226 = !DILocation(line: 221, column: 16, scope: !212)
!227 = !DILocation(line: 221, column: 3, scope: !212)
!228 = !DILocation(line: 221, column: 8, scope: !212)
!229 = !DILocation(line: 221, column: 14, scope: !212)
!230 = !DILocation(line: 222, column: 2, scope: !212)
!231 = !DILocation(line: 224, column: 20, scope: !177)
!232 = !DILocation(line: 224, column: 2, scope: !177)
!233 = !DILocation(line: 224, column: 11, scope: !177)
!234 = !DILocation(line: 224, column: 18, scope: !177)
!235 = !DILocation(line: 225, column: 2, scope: !177)
!236 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !169, file: !169, line: 127, type: !237, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!237 = !DISubroutineType(types: !238)
!238 = !{!7, !239}
!239 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !240, size: 32)
!240 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !7)
!241 = !DILocalVariable(name: "target", arg: 1, scope: !236, file: !169, line: 127, type: !239)
!242 = !DILocation(line: 127, column: 1, scope: !236)
!243 = !DILocalVariable(name: "r", scope: !236, file: !169, line: 127, type: !244)
!244 = !DIBasicType(name: "long", size: 32, encoding: DW_ATE_signed)
!245 = !{i64 2147597720}
!246 = distinct !DISubprogram(name: "ck_pr_fence_acqrel", scope: !247, file: !247, line: 121, type: !248, scopeLine: 121, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!247 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!248 = !DISubroutineType(types: !249)
!249 = !{null}
!250 = !DILocation(line: 121, column: 1, scope: !246)
!251 = distinct !DISubprogram(name: "ck_epoch_init", scope: !6, file: !6, line: 229, type: !252, scopeLine: 230, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !114)
!252 = !DISubroutineType(types: !253)
!253 = !{null, !29}
!254 = !DILocalVariable(name: "global", arg: 1, scope: !251, file: !6, line: 229, type: !29)
!255 = !DILocation(line: 229, column: 32, scope: !251)
!256 = !DILocation(line: 232, column: 17, scope: !251)
!257 = !DILocation(line: 232, column: 25, scope: !251)
!258 = !DILocation(line: 232, column: 2, scope: !251)
!259 = !DILocation(line: 233, column: 2, scope: !251)
!260 = !DILocation(line: 233, column: 10, scope: !251)
!261 = !DILocation(line: 233, column: 16, scope: !251)
!262 = !DILocation(line: 234, column: 2, scope: !251)
!263 = !DILocation(line: 234, column: 10, scope: !251)
!264 = !DILocation(line: 234, column: 17, scope: !251)
!265 = !DILocation(line: 235, column: 2, scope: !251)
!266 = !DILocation(line: 236, column: 2, scope: !251)
!267 = distinct !DISubprogram(name: "ck_stack_init", scope: !23, file: !23, line: 334, type: !268, scopeLine: 335, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!268 = !DISubroutineType(types: !269)
!269 = !{null, !270}
!270 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 32)
!271 = !DILocalVariable(name: "stack", arg: 1, scope: !267, file: !23, line: 334, type: !270)
!272 = !DILocation(line: 334, column: 32, scope: !267)
!273 = !DILocation(line: 337, column: 2, scope: !267)
!274 = !DILocation(line: 337, column: 9, scope: !267)
!275 = !DILocation(line: 337, column: 14, scope: !267)
!276 = !DILocation(line: 338, column: 2, scope: !267)
!277 = !DILocation(line: 338, column: 9, scope: !267)
!278 = !DILocation(line: 338, column: 20, scope: !267)
!279 = !DILocation(line: 339, column: 2, scope: !267)
!280 = distinct !DISubprogram(name: "ck_pr_fence_store", scope: !247, file: !247, line: 117, type: !248, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!281 = !DILocation(line: 117, column: 1, scope: !280)
!282 = distinct !DISubprogram(name: "ck_epoch_recycle", scope: !6, file: !6, line: 240, type: !283, scopeLine: 241, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !114)
!283 = !DISubroutineType(types: !284)
!284 = !{!76, !29, !16}
!285 = !DILocalVariable(name: "global", arg: 1, scope: !282, file: !6, line: 240, type: !29)
!286 = !DILocation(line: 240, column: 35, scope: !282)
!287 = !DILocalVariable(name: "ct", arg: 2, scope: !282, file: !6, line: 240, type: !16)
!288 = !DILocation(line: 240, column: 49, scope: !282)
!289 = !DILocalVariable(name: "record", scope: !282, file: !6, line: 242, type: !17)
!290 = !DILocation(line: 242, column: 26, scope: !282)
!291 = !DILocalVariable(name: "cursor", scope: !282, file: !6, line: 243, type: !292)
!292 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 32)
!293 = !DILocation(line: 243, column: 20, scope: !282)
!294 = !DILocalVariable(name: "state", scope: !282, file: !6, line: 244, type: !7)
!295 = !DILocation(line: 244, column: 15, scope: !282)
!296 = !DILocation(line: 246, column: 23, scope: !297)
!297 = distinct !DILexicalBlock(scope: !282, file: !6, line: 246, column: 6)
!298 = !DILocation(line: 246, column: 31, scope: !297)
!299 = !DILocation(line: 246, column: 6, scope: !297)
!300 = !DILocation(line: 246, column: 39, scope: !297)
!301 = !DILocation(line: 247, column: 3, scope: !297)
!302 = !DILocation(line: 249, column: 20, scope: !303)
!303 = distinct !DILexicalBlock(scope: !282, file: !6, line: 249, column: 2)
!304 = !DILocation(line: 249, column: 28, scope: !303)
!305 = !DILocation(line: 249, column: 2, scope: !303)
!306 = !DILocation(line: 249, column: 37, scope: !307)
!307 = distinct !DILexicalBlock(scope: !303, file: !6, line: 249, column: 2)
!308 = !DILocation(line: 249, column: 2, scope: !307)
!309 = !DILocation(line: 250, column: 38, scope: !310)
!310 = distinct !DILexicalBlock(scope: !307, file: !6, line: 249, column: 45)
!311 = !DILocation(line: 250, column: 12, scope: !310)
!312 = !DILocation(line: 250, column: 10, scope: !310)
!313 = !DILocation(line: 252, column: 24, scope: !314)
!314 = distinct !DILexicalBlock(scope: !310, file: !6, line: 252, column: 7)
!315 = !DILocation(line: 252, column: 32, scope: !314)
!316 = !DILocation(line: 252, column: 7, scope: !314)
!317 = !DILocation(line: 252, column: 39, scope: !314)
!318 = !DILocation(line: 254, column: 4, scope: !319)
!319 = distinct !DILexicalBlock(scope: !314, file: !6, line: 252, column: 63)
!320 = !DILocation(line: 255, column: 28, scope: !319)
!321 = !DILocation(line: 255, column: 36, scope: !319)
!322 = !DILocation(line: 255, column: 12, scope: !319)
!323 = !DILocation(line: 255, column: 10, scope: !319)
!324 = !DILocation(line: 257, column: 8, scope: !325)
!325 = distinct !DILexicalBlock(scope: !319, file: !6, line: 257, column: 8)
!326 = !DILocation(line: 257, column: 14, scope: !325)
!327 = !DILocation(line: 258, column: 21, scope: !328)
!328 = distinct !DILexicalBlock(scope: !325, file: !6, line: 257, column: 38)
!329 = !DILocation(line: 258, column: 29, scope: !328)
!330 = !DILocation(line: 258, column: 5, scope: !328)
!331 = !DILocation(line: 259, column: 22, scope: !328)
!332 = !DILocation(line: 259, column: 30, scope: !328)
!333 = !DILocation(line: 259, column: 34, scope: !328)
!334 = !DILocation(line: 259, column: 5, scope: !328)
!335 = !DILocation(line: 265, column: 12, scope: !328)
!336 = !DILocation(line: 265, column: 5, scope: !328)
!337 = !DILocation(line: 267, column: 3, scope: !319)
!338 = !DILocation(line: 268, column: 2, scope: !310)
!339 = distinct !{!339, !305, !340, !341}
!340 = !DILocation(line: 268, column: 2, scope: !303)
!341 = !{!"llvm.loop.mustprogress"}
!342 = !DILocation(line: 270, column: 2, scope: !282)
!343 = !DILocation(line: 271, column: 1, scope: !282)
!344 = distinct !DISubprogram(name: "ck_epoch_record_container", scope: !6, file: !6, line: 144, type: !345, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!345 = !DISubroutineType(types: !346)
!346 = !{!17, !292}
!347 = !DILocalVariable(name: "p", arg: 1, scope: !344, file: !6, line: 143, type: !292)
!348 = !DILocation(line: 143, column: 1, scope: !344)
!349 = distinct !DISubprogram(name: "ck_pr_fence_load", scope: !247, file: !247, line: 116, type: !248, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!350 = !DILocation(line: 116, column: 1, scope: !349)
!351 = distinct !DISubprogram(name: "ck_pr_fas_uint", scope: !169, file: !169, line: 417, type: !352, scopeLine: 417, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!352 = !DISubroutineType(types: !353)
!353 = !{!7, !172, !7}
!354 = !DILocalVariable(name: "target", arg: 1, scope: !351, file: !169, line: 417, type: !172)
!355 = !DILocation(line: 417, column: 1, scope: !351)
!356 = !DILocalVariable(name: "v", arg: 2, scope: !351, file: !169, line: 417, type: !7)
!357 = !DILocalVariable(name: "previous", scope: !351, file: !169, line: 417, type: !7)
!358 = !DILocalVariable(name: "tmp", scope: !351, file: !169, line: 417, type: !7)
!359 = !{i64 2147613546}
!360 = distinct !DISubprogram(name: "ck_pr_dec_uint", scope: !169, file: !169, line: 457, type: !361, scopeLine: 457, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!361 = !DISubroutineType(types: !362)
!362 = !{null, !172}
!363 = !DILocalVariable(name: "target", arg: 1, scope: !360, file: !169, line: 457, type: !172)
!364 = !DILocation(line: 457, column: 1, scope: !360)
!365 = !DILocalVariable(name: "previous", scope: !360, file: !169, line: 457, type: !7)
!366 = !DILocalVariable(name: "tmp", scope: !360, file: !169, line: 457, type: !7)
!367 = !{i64 2147621545}
!368 = distinct !DISubprogram(name: "ck_pr_md_store_ptr", scope: !169, file: !169, line: 169, type: !369, scopeLine: 169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!369 = !DISubroutineType(types: !370)
!370 = !{null, !16, !371}
!371 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !372, size: 32)
!372 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!373 = !DILocalVariable(name: "target", arg: 1, scope: !368, file: !169, line: 169, type: !16)
!374 = !DILocation(line: 169, column: 1, scope: !368)
!375 = !DILocalVariable(name: "v", arg: 2, scope: !368, file: !169, line: 169, type: !371)
!376 = !{i64 2147599128}
!377 = distinct !DISubprogram(name: "ck_epoch_register", scope: !6, file: !6, line: 274, type: !378, scopeLine: 276, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !114)
!378 = !DISubroutineType(types: !379)
!379 = !{null, !29, !17, !16}
!380 = !DILocalVariable(name: "global", arg: 1, scope: !377, file: !6, line: 274, type: !29)
!381 = !DILocation(line: 274, column: 36, scope: !377)
!382 = !DILocalVariable(name: "record", arg: 2, scope: !377, file: !6, line: 274, type: !17)
!383 = !DILocation(line: 274, column: 68, scope: !377)
!384 = !DILocalVariable(name: "ct", arg: 3, scope: !377, file: !6, line: 275, type: !16)
!385 = !DILocation(line: 275, column: 11, scope: !377)
!386 = !DILocalVariable(name: "i", scope: !377, file: !6, line: 277, type: !387)
!387 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !388, line: 3, baseType: !7)
!388 = !DIFile(filename: "include/libc/_size_t.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "dc11ce4c8eb4c64bece0363f758637cd")
!389 = !DILocation(line: 277, column: 9, scope: !377)
!390 = !DILocation(line: 279, column: 19, scope: !377)
!391 = !DILocation(line: 279, column: 2, scope: !377)
!392 = !DILocation(line: 279, column: 10, scope: !377)
!393 = !DILocation(line: 279, column: 17, scope: !377)
!394 = !DILocation(line: 280, column: 2, scope: !377)
!395 = !DILocation(line: 280, column: 10, scope: !377)
!396 = !DILocation(line: 280, column: 16, scope: !377)
!397 = !DILocation(line: 281, column: 2, scope: !377)
!398 = !DILocation(line: 281, column: 10, scope: !377)
!399 = !DILocation(line: 281, column: 17, scope: !377)
!400 = !DILocation(line: 282, column: 2, scope: !377)
!401 = !DILocation(line: 282, column: 10, scope: !377)
!402 = !DILocation(line: 282, column: 16, scope: !377)
!403 = !DILocation(line: 283, column: 2, scope: !377)
!404 = !DILocation(line: 283, column: 10, scope: !377)
!405 = !DILocation(line: 283, column: 21, scope: !377)
!406 = !DILocation(line: 284, column: 2, scope: !377)
!407 = !DILocation(line: 284, column: 10, scope: !377)
!408 = !DILocation(line: 284, column: 17, scope: !377)
!409 = !DILocation(line: 285, column: 2, scope: !377)
!410 = !DILocation(line: 285, column: 10, scope: !377)
!411 = !DILocation(line: 285, column: 20, scope: !377)
!412 = !DILocation(line: 286, column: 15, scope: !377)
!413 = !DILocation(line: 286, column: 2, scope: !377)
!414 = !DILocation(line: 286, column: 10, scope: !377)
!415 = !DILocation(line: 286, column: 13, scope: !377)
!416 = !DILocation(line: 287, column: 10, scope: !377)
!417 = !DILocation(line: 287, column: 18, scope: !377)
!418 = !DILocation(line: 287, column: 2, scope: !377)
!419 = !DILocation(line: 289, column: 9, scope: !420)
!420 = distinct !DILexicalBlock(scope: !377, file: !6, line: 289, column: 2)
!421 = !DILocation(line: 289, column: 7, scope: !420)
!422 = !DILocation(line: 289, column: 14, scope: !423)
!423 = distinct !DILexicalBlock(scope: !420, file: !6, line: 289, column: 2)
!424 = !DILocation(line: 289, column: 16, scope: !423)
!425 = !DILocation(line: 289, column: 2, scope: !420)
!426 = !DILocation(line: 290, column: 18, scope: !423)
!427 = !DILocation(line: 290, column: 26, scope: !423)
!428 = !DILocation(line: 290, column: 34, scope: !423)
!429 = !DILocation(line: 290, column: 3, scope: !423)
!430 = !DILocation(line: 289, column: 36, scope: !423)
!431 = !DILocation(line: 289, column: 2, scope: !423)
!432 = distinct !{!432, !425, !433, !341}
!433 = !DILocation(line: 290, column: 36, scope: !420)
!434 = !DILocation(line: 292, column: 2, scope: !377)
!435 = !DILocation(line: 293, column: 22, scope: !377)
!436 = !DILocation(line: 293, column: 30, scope: !377)
!437 = !DILocation(line: 293, column: 40, scope: !377)
!438 = !DILocation(line: 293, column: 48, scope: !377)
!439 = !DILocation(line: 293, column: 2, scope: !377)
!440 = !DILocation(line: 294, column: 2, scope: !377)
!441 = distinct !DISubprogram(name: "ck_stack_push_upmc", scope: !23, file: !23, line: 54, type: !442, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!442 = !DISubroutineType(types: !443)
!443 = !{null, !270, !27}
!444 = !DILocalVariable(name: "target", arg: 1, scope: !441, file: !23, line: 54, type: !270)
!445 = !DILocation(line: 54, column: 37, scope: !441)
!446 = !DILocalVariable(name: "entry", arg: 2, scope: !441, file: !23, line: 54, type: !27)
!447 = !DILocation(line: 54, column: 68, scope: !441)
!448 = !DILocalVariable(name: "stack", scope: !441, file: !23, line: 56, type: !27)
!449 = !DILocation(line: 56, column: 25, scope: !441)
!450 = !DILocation(line: 58, column: 26, scope: !441)
!451 = !DILocation(line: 58, column: 34, scope: !441)
!452 = !DILocation(line: 58, column: 10, scope: !441)
!453 = !DILocation(line: 58, column: 8, scope: !441)
!454 = !DILocation(line: 59, column: 16, scope: !441)
!455 = !DILocation(line: 59, column: 2, scope: !441)
!456 = !DILocation(line: 59, column: 9, scope: !441)
!457 = !DILocation(line: 59, column: 14, scope: !441)
!458 = !DILocation(line: 60, column: 2, scope: !441)
!459 = !DILocation(line: 62, column: 2, scope: !441)
!460 = !DILocation(line: 62, column: 30, scope: !441)
!461 = !DILocation(line: 62, column: 38, scope: !441)
!462 = !DILocation(line: 62, column: 44, scope: !441)
!463 = !DILocation(line: 62, column: 51, scope: !441)
!464 = !DILocation(line: 62, column: 9, scope: !441)
!465 = !DILocation(line: 62, column: 66, scope: !441)
!466 = !DILocation(line: 63, column: 17, scope: !467)
!467 = distinct !DILexicalBlock(scope: !441, file: !23, line: 62, column: 76)
!468 = !DILocation(line: 63, column: 3, scope: !467)
!469 = !DILocation(line: 63, column: 10, scope: !467)
!470 = !DILocation(line: 63, column: 15, scope: !467)
!471 = !DILocation(line: 64, column: 3, scope: !467)
!472 = distinct !{!472, !459, !473, !341}
!473 = !DILocation(line: 65, column: 2, scope: !441)
!474 = !DILocation(line: 67, column: 2, scope: !441)
!475 = distinct !DISubprogram(name: "ck_epoch_unregister", scope: !6, file: !6, line: 298, type: !476, scopeLine: 299, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !114)
!476 = !DISubroutineType(types: !477)
!477 = !{null, !17}
!478 = !DILocalVariable(name: "record", arg: 1, scope: !475, file: !6, line: 298, type: !17)
!479 = !DILocation(line: 298, column: 45, scope: !475)
!480 = !DILocalVariable(name: "global", scope: !475, file: !6, line: 300, type: !29)
!481 = !DILocation(line: 300, column: 19, scope: !475)
!482 = !DILocation(line: 300, column: 28, scope: !475)
!483 = !DILocation(line: 300, column: 36, scope: !475)
!484 = !DILocalVariable(name: "i", scope: !475, file: !6, line: 301, type: !387)
!485 = !DILocation(line: 301, column: 9, scope: !475)
!486 = !DILocation(line: 303, column: 2, scope: !475)
!487 = !DILocation(line: 303, column: 10, scope: !475)
!488 = !DILocation(line: 303, column: 17, scope: !475)
!489 = !DILocation(line: 304, column: 2, scope: !475)
!490 = !DILocation(line: 304, column: 10, scope: !475)
!491 = !DILocation(line: 304, column: 16, scope: !475)
!492 = !DILocation(line: 305, column: 2, scope: !475)
!493 = !DILocation(line: 305, column: 10, scope: !475)
!494 = !DILocation(line: 305, column: 21, scope: !475)
!495 = !DILocation(line: 306, column: 2, scope: !475)
!496 = !DILocation(line: 306, column: 10, scope: !475)
!497 = !DILocation(line: 306, column: 17, scope: !475)
!498 = !DILocation(line: 307, column: 2, scope: !475)
!499 = !DILocation(line: 307, column: 10, scope: !475)
!500 = !DILocation(line: 307, column: 20, scope: !475)
!501 = !DILocation(line: 308, column: 10, scope: !475)
!502 = !DILocation(line: 308, column: 18, scope: !475)
!503 = !DILocation(line: 308, column: 2, scope: !475)
!504 = !DILocation(line: 310, column: 9, scope: !505)
!505 = distinct !DILexicalBlock(scope: !475, file: !6, line: 310, column: 2)
!506 = !DILocation(line: 310, column: 7, scope: !505)
!507 = !DILocation(line: 310, column: 14, scope: !508)
!508 = distinct !DILexicalBlock(scope: !505, file: !6, line: 310, column: 2)
!509 = !DILocation(line: 310, column: 16, scope: !508)
!510 = !DILocation(line: 310, column: 2, scope: !505)
!511 = !DILocation(line: 311, column: 18, scope: !508)
!512 = !DILocation(line: 311, column: 26, scope: !508)
!513 = !DILocation(line: 311, column: 34, scope: !508)
!514 = !DILocation(line: 311, column: 3, scope: !508)
!515 = !DILocation(line: 310, column: 36, scope: !508)
!516 = !DILocation(line: 310, column: 2, scope: !508)
!517 = distinct !{!517, !510, !518, !341}
!518 = !DILocation(line: 311, column: 36, scope: !505)
!519 = !DILocation(line: 313, column: 19, scope: !475)
!520 = !DILocation(line: 313, column: 27, scope: !475)
!521 = !DILocation(line: 313, column: 2, scope: !475)
!522 = !DILocation(line: 314, column: 2, scope: !475)
!523 = !DILocation(line: 315, column: 20, scope: !475)
!524 = !DILocation(line: 315, column: 28, scope: !475)
!525 = !DILocation(line: 315, column: 2, scope: !475)
!526 = !DILocation(line: 316, column: 18, scope: !475)
!527 = !DILocation(line: 316, column: 26, scope: !475)
!528 = !DILocation(line: 316, column: 2, scope: !475)
!529 = !DILocation(line: 317, column: 2, scope: !475)
!530 = distinct !DISubprogram(name: "ck_pr_inc_uint", scope: !169, file: !169, line: 457, type: !361, scopeLine: 457, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!531 = !DILocalVariable(name: "target", arg: 1, scope: !530, file: !169, line: 457, type: !172)
!532 = !DILocation(line: 457, column: 1, scope: !530)
!533 = !DILocalVariable(name: "previous", scope: !530, file: !169, line: 457, type: !7)
!534 = !DILocalVariable(name: "tmp", scope: !530, file: !169, line: 457, type: !7)
!535 = !{i64 2147621002}
!536 = distinct !DISubprogram(name: "ck_epoch_reclaim", scope: !6, file: !6, line: 400, type: !476, scopeLine: 401, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !114)
!537 = !DILocalVariable(name: "record", arg: 1, scope: !536, file: !6, line: 400, type: !17)
!538 = !DILocation(line: 400, column: 42, scope: !536)
!539 = !DILocalVariable(name: "epoch", scope: !536, file: !6, line: 402, type: !7)
!540 = !DILocation(line: 402, column: 15, scope: !536)
!541 = !DILocation(line: 404, column: 13, scope: !542)
!542 = distinct !DILexicalBlock(scope: !536, file: !6, line: 404, column: 2)
!543 = !DILocation(line: 404, column: 7, scope: !542)
!544 = !DILocation(line: 404, column: 18, scope: !545)
!545 = distinct !DILexicalBlock(scope: !542, file: !6, line: 404, column: 2)
!546 = !DILocation(line: 404, column: 24, scope: !545)
!547 = !DILocation(line: 404, column: 2, scope: !542)
!548 = !DILocation(line: 405, column: 21, scope: !545)
!549 = !DILocation(line: 405, column: 29, scope: !545)
!550 = !DILocation(line: 405, column: 3, scope: !545)
!551 = !DILocation(line: 404, column: 48, scope: !545)
!552 = !DILocation(line: 404, column: 2, scope: !545)
!553 = distinct !{!553, !547, !554, !341}
!554 = !DILocation(line: 405, column: 40, scope: !542)
!555 = !DILocation(line: 407, column: 2, scope: !536)
!556 = distinct !DISubprogram(name: "ck_epoch_dispatch", scope: !6, file: !6, line: 360, type: !557, scopeLine: 361, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!557 = !DISubroutineType(types: !558)
!558 = !{!7, !17, !7, !559}
!559 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 32)
!560 = !DILocalVariable(name: "record", arg: 1, scope: !556, file: !6, line: 360, type: !17)
!561 = !DILocation(line: 360, column: 43, scope: !556)
!562 = !DILocalVariable(name: "e", arg: 2, scope: !556, file: !6, line: 360, type: !7)
!563 = !DILocation(line: 360, column: 64, scope: !556)
!564 = !DILocalVariable(name: "deferred", arg: 3, scope: !556, file: !6, line: 360, type: !559)
!565 = !DILocation(line: 360, column: 79, scope: !556)
!566 = !DILocalVariable(name: "epoch", scope: !556, file: !6, line: 362, type: !7)
!567 = !DILocation(line: 362, column: 15, scope: !556)
!568 = !DILocation(line: 362, column: 23, scope: !556)
!569 = !DILocation(line: 362, column: 25, scope: !556)
!570 = !DILocalVariable(name: "head", scope: !556, file: !6, line: 363, type: !292)
!571 = !DILocation(line: 363, column: 20, scope: !556)
!572 = !DILocalVariable(name: "next", scope: !556, file: !6, line: 363, type: !292)
!573 = !DILocation(line: 363, column: 27, scope: !556)
!574 = !DILocalVariable(name: "cursor", scope: !556, file: !6, line: 363, type: !292)
!575 = !DILocation(line: 363, column: 34, scope: !556)
!576 = !DILocalVariable(name: "n_pending", scope: !556, file: !6, line: 364, type: !7)
!577 = !DILocation(line: 364, column: 15, scope: !556)
!578 = !DILocalVariable(name: "n_peak", scope: !556, file: !6, line: 364, type: !7)
!579 = !DILocation(line: 364, column: 26, scope: !556)
!580 = !DILocalVariable(name: "i", scope: !556, file: !6, line: 365, type: !7)
!581 = !DILocation(line: 365, column: 15, scope: !556)
!582 = !DILocation(line: 367, column: 34, scope: !556)
!583 = !DILocation(line: 367, column: 42, scope: !556)
!584 = !DILocation(line: 367, column: 50, scope: !556)
!585 = !DILocation(line: 367, column: 9, scope: !556)
!586 = !DILocation(line: 367, column: 7, scope: !556)
!587 = !DILocation(line: 368, column: 16, scope: !588)
!588 = distinct !DILexicalBlock(scope: !556, file: !6, line: 368, column: 2)
!589 = !DILocation(line: 368, column: 14, scope: !588)
!590 = !DILocation(line: 368, column: 7, scope: !588)
!591 = !DILocation(line: 368, column: 22, scope: !592)
!592 = distinct !DILexicalBlock(scope: !588, file: !6, line: 368, column: 2)
!593 = !DILocation(line: 368, column: 29, scope: !592)
!594 = !DILocation(line: 368, column: 2, scope: !588)
!595 = !DILocalVariable(name: "entry", scope: !596, file: !6, line: 369, type: !65)
!596 = distinct !DILexicalBlock(scope: !592, file: !6, line: 368, column: 53)
!597 = !DILocation(line: 369, column: 26, scope: !596)
!598 = !DILocation(line: 370, column: 32, scope: !596)
!599 = !DILocation(line: 370, column: 7, scope: !596)
!600 = !DILocation(line: 372, column: 24, scope: !596)
!601 = !DILocation(line: 372, column: 10, scope: !596)
!602 = !DILocation(line: 372, column: 8, scope: !596)
!603 = !DILocation(line: 373, column: 7, scope: !604)
!604 = distinct !DILexicalBlock(scope: !596, file: !6, line: 373, column: 7)
!605 = !DILocation(line: 373, column: 16, scope: !604)
!606 = !DILocation(line: 374, column: 23, scope: !604)
!607 = !DILocation(line: 374, column: 34, scope: !604)
!608 = !DILocation(line: 374, column: 41, scope: !604)
!609 = !DILocation(line: 374, column: 4, scope: !604)
!610 = !DILocation(line: 376, column: 4, scope: !604)
!611 = !DILocation(line: 376, column: 11, scope: !604)
!612 = !DILocation(line: 376, column: 20, scope: !604)
!613 = !DILocation(line: 378, column: 4, scope: !596)
!614 = !DILocation(line: 379, column: 2, scope: !596)
!615 = !DILocation(line: 368, column: 47, scope: !592)
!616 = !DILocation(line: 368, column: 45, scope: !592)
!617 = !DILocation(line: 368, column: 2, scope: !592)
!618 = distinct !{!618, !594, !619, !341}
!619 = !DILocation(line: 379, column: 2, scope: !588)
!620 = !DILocation(line: 381, column: 28, scope: !556)
!621 = !DILocation(line: 381, column: 36, scope: !556)
!622 = !DILocation(line: 381, column: 11, scope: !556)
!623 = !DILocation(line: 381, column: 9, scope: !556)
!624 = !DILocation(line: 382, column: 31, scope: !556)
!625 = !DILocation(line: 382, column: 39, scope: !556)
!626 = !DILocation(line: 382, column: 14, scope: !556)
!627 = !DILocation(line: 382, column: 12, scope: !556)
!628 = !DILocation(line: 385, column: 6, scope: !629)
!629 = distinct !DILexicalBlock(scope: !556, file: !6, line: 385, column: 6)
!630 = !DILocation(line: 385, column: 18, scope: !629)
!631 = !DILocation(line: 385, column: 16, scope: !629)
!632 = !DILocation(line: 386, column: 21, scope: !629)
!633 = !DILocation(line: 386, column: 29, scope: !629)
!634 = !DILocation(line: 386, column: 37, scope: !629)
!635 = !DILocation(line: 386, column: 3, scope: !629)
!636 = !DILocation(line: 388, column: 6, scope: !637)
!637 = distinct !DILexicalBlock(scope: !556, file: !6, line: 388, column: 6)
!638 = !DILocation(line: 388, column: 8, scope: !637)
!639 = !DILocation(line: 389, column: 19, scope: !640)
!640 = distinct !DILexicalBlock(scope: !637, file: !6, line: 388, column: 13)
!641 = !DILocation(line: 389, column: 27, scope: !640)
!642 = !DILocation(line: 389, column: 39, scope: !640)
!643 = !DILocation(line: 389, column: 3, scope: !640)
!644 = !DILocation(line: 390, column: 19, scope: !640)
!645 = !DILocation(line: 390, column: 27, scope: !640)
!646 = !DILocation(line: 390, column: 38, scope: !640)
!647 = !DILocation(line: 390, column: 3, scope: !640)
!648 = !DILocation(line: 391, column: 2, scope: !640)
!649 = !DILocation(line: 393, column: 9, scope: !556)
!650 = !DILocation(line: 393, column: 2, scope: !556)
!651 = distinct !DISubprogram(name: "ck_epoch_synchronize_wait", scope: !6, file: !6, line: 425, type: !652, scopeLine: 427, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !114)
!652 = !DISubroutineType(types: !653)
!653 = !{null, !29, !654, !16}
!654 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !655, size: 32)
!655 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_wait_cb_t", file: !19, line: 234, baseType: !656)
!656 = !DISubroutineType(types: !657)
!657 = !{null, !658, !76, !16}
!658 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 32)
!659 = !DILocalVariable(name: "global", arg: 1, scope: !651, file: !6, line: 425, type: !29)
!660 = !DILocation(line: 425, column: 44, scope: !651)
!661 = !DILocalVariable(name: "cb", arg: 2, scope: !651, file: !6, line: 426, type: !654)
!662 = !DILocation(line: 426, column: 25, scope: !651)
!663 = !DILocalVariable(name: "ct", arg: 3, scope: !651, file: !6, line: 426, type: !16)
!664 = !DILocation(line: 426, column: 35, scope: !651)
!665 = !DILocalVariable(name: "cr", scope: !651, file: !6, line: 428, type: !17)
!666 = !DILocation(line: 428, column: 26, scope: !651)
!667 = !DILocalVariable(name: "delta", scope: !651, file: !6, line: 429, type: !7)
!668 = !DILocation(line: 429, column: 15, scope: !651)
!669 = !DILocalVariable(name: "epoch", scope: !651, file: !6, line: 429, type: !7)
!670 = !DILocation(line: 429, column: 22, scope: !651)
!671 = !DILocalVariable(name: "goal", scope: !651, file: !6, line: 429, type: !7)
!672 = !DILocation(line: 429, column: 29, scope: !651)
!673 = !DILocalVariable(name: "i", scope: !651, file: !6, line: 429, type: !7)
!674 = !DILocation(line: 429, column: 35, scope: !651)
!675 = !DILocalVariable(name: "active", scope: !651, file: !6, line: 430, type: !12)
!676 = !DILocation(line: 430, column: 7, scope: !651)
!677 = !DILocation(line: 432, column: 2, scope: !651)
!678 = !DILocation(line: 443, column: 35, scope: !651)
!679 = !DILocation(line: 443, column: 43, scope: !651)
!680 = !DILocation(line: 443, column: 18, scope: !651)
!681 = !DILocation(line: 443, column: 16, scope: !651)
!682 = !DILocation(line: 443, column: 8, scope: !651)
!683 = !DILocation(line: 444, column: 9, scope: !651)
!684 = !DILocation(line: 444, column: 15, scope: !651)
!685 = !DILocation(line: 444, column: 7, scope: !651)
!686 = !DILocation(line: 446, column: 9, scope: !687)
!687 = distinct !DILexicalBlock(scope: !651, file: !6, line: 446, column: 2)
!688 = !DILocation(line: 446, column: 17, scope: !687)
!689 = !DILocation(line: 446, column: 7, scope: !687)
!690 = !DILocation(line: 446, column: 25, scope: !691)
!691 = distinct !DILexicalBlock(scope: !687, file: !6, line: 446, column: 2)
!692 = !DILocation(line: 446, column: 27, scope: !691)
!693 = !DILocation(line: 446, column: 2, scope: !687)
!694 = !DILocalVariable(name: "r", scope: !695, file: !6, line: 447, type: !12)
!695 = distinct !DILexicalBlock(scope: !691, file: !6, line: 446, column: 65)
!696 = !DILocation(line: 447, column: 8, scope: !695)
!697 = !DILocation(line: 453, column: 3, scope: !695)
!698 = !DILocation(line: 453, column: 29, scope: !695)
!699 = !DILocation(line: 453, column: 37, scope: !695)
!700 = !DILocation(line: 453, column: 41, scope: !695)
!701 = !DILocation(line: 453, column: 15, scope: !695)
!702 = !DILocation(line: 453, column: 13, scope: !695)
!703 = !DILocation(line: 454, column: 7, scope: !695)
!704 = !DILocation(line: 454, column: 10, scope: !695)
!705 = !DILocalVariable(name: "e_d", scope: !706, file: !6, line: 455, type: !7)
!706 = distinct !DILexicalBlock(scope: !695, file: !6, line: 454, column: 19)
!707 = !DILocation(line: 455, column: 17, scope: !706)
!708 = !DILocation(line: 457, column: 4, scope: !706)
!709 = !DILocation(line: 463, column: 27, scope: !706)
!710 = !DILocation(line: 463, column: 35, scope: !706)
!711 = !DILocation(line: 463, column: 10, scope: !706)
!712 = !DILocation(line: 463, column: 8, scope: !706)
!713 = !DILocation(line: 464, column: 8, scope: !714)
!714 = distinct !DILexicalBlock(scope: !706, file: !6, line: 464, column: 8)
!715 = !DILocation(line: 464, column: 15, scope: !714)
!716 = !DILocation(line: 464, column: 12, scope: !714)
!717 = !DILocation(line: 465, column: 17, scope: !718)
!718 = distinct !DILexicalBlock(scope: !714, file: !6, line: 464, column: 22)
!719 = !DILocation(line: 465, column: 25, scope: !718)
!720 = !DILocation(line: 465, column: 29, scope: !718)
!721 = !DILocation(line: 465, column: 33, scope: !718)
!722 = !DILocalVariable(name: "global", arg: 1, scope: !723, file: !6, line: 411, type: !29)
!723 = distinct !DISubprogram(name: "epoch_block", scope: !6, file: !6, line: 411, type: !724, scopeLine: 413, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!724 = !DISubroutineType(types: !725)
!725 = !{null, !29, !17, !654, !16}
!726 = !DILocation(line: 411, column: 30, scope: !723, inlinedAt: !727)
!727 = distinct !DILocation(line: 465, column: 5, scope: !718)
!728 = !DILocalVariable(name: "cr", arg: 2, scope: !723, file: !6, line: 411, type: !17)
!729 = !DILocation(line: 411, column: 62, scope: !723, inlinedAt: !727)
!730 = !DILocalVariable(name: "cb", arg: 3, scope: !723, file: !6, line: 412, type: !654)
!731 = !DILocation(line: 412, column: 25, scope: !723, inlinedAt: !727)
!732 = !DILocalVariable(name: "ct", arg: 4, scope: !723, file: !6, line: 412, type: !16)
!733 = !DILocation(line: 412, column: 35, scope: !723, inlinedAt: !727)
!734 = !DILocation(line: 415, column: 6, scope: !735, inlinedAt: !727)
!735 = distinct !DILexicalBlock(scope: !723, file: !6, line: 415, column: 6)
!736 = !DILocation(line: 415, column: 9, scope: !735, inlinedAt: !727)
!737 = !DILocation(line: 416, column: 3, scope: !735, inlinedAt: !727)
!738 = !DILocation(line: 416, column: 6, scope: !735, inlinedAt: !727)
!739 = !DILocation(line: 416, column: 14, scope: !735, inlinedAt: !727)
!740 = !DILocation(line: 416, column: 18, scope: !735, inlinedAt: !727)
!741 = !DILocation(line: 466, column: 5, scope: !718)
!742 = distinct !{!742, !697, !743, !341}
!743 = !DILocation(line: 485, column: 3, scope: !695)
!744 = !DILocation(line: 473, column: 12, scope: !706)
!745 = !DILocation(line: 473, column: 10, scope: !706)
!746 = !DILocation(line: 474, column: 9, scope: !747)
!747 = distinct !DILexicalBlock(scope: !706, file: !6, line: 474, column: 8)
!748 = !DILocation(line: 474, column: 16, scope: !747)
!749 = !DILocation(line: 474, column: 14, scope: !747)
!750 = !DILocation(line: 474, column: 26, scope: !747)
!751 = !DILocation(line: 474, column: 35, scope: !747)
!752 = !DILocation(line: 474, column: 32, scope: !747)
!753 = !DILocation(line: 474, column: 23, scope: !747)
!754 = !DILocation(line: 475, column: 5, scope: !747)
!755 = !DILocation(line: 477, column: 16, scope: !706)
!756 = !DILocation(line: 477, column: 24, scope: !706)
!757 = !DILocation(line: 477, column: 28, scope: !706)
!758 = !DILocation(line: 477, column: 32, scope: !706)
!759 = !DILocation(line: 411, column: 30, scope: !723, inlinedAt: !760)
!760 = distinct !DILocation(line: 477, column: 4, scope: !706)
!761 = !DILocation(line: 411, column: 62, scope: !723, inlinedAt: !760)
!762 = !DILocation(line: 412, column: 25, scope: !723, inlinedAt: !760)
!763 = !DILocation(line: 412, column: 35, scope: !723, inlinedAt: !760)
!764 = !DILocation(line: 415, column: 6, scope: !735, inlinedAt: !760)
!765 = !DILocation(line: 415, column: 9, scope: !735, inlinedAt: !760)
!766 = !DILocation(line: 416, column: 3, scope: !735, inlinedAt: !760)
!767 = !DILocation(line: 416, column: 6, scope: !735, inlinedAt: !760)
!768 = !DILocation(line: 416, column: 14, scope: !735, inlinedAt: !760)
!769 = !DILocation(line: 416, column: 18, scope: !735, inlinedAt: !760)
!770 = !DILocation(line: 484, column: 7, scope: !706)
!771 = !DILocation(line: 491, column: 7, scope: !772)
!772 = distinct !DILexicalBlock(scope: !695, file: !6, line: 491, column: 7)
!773 = !DILocation(line: 491, column: 14, scope: !772)
!774 = !DILocation(line: 492, column: 4, scope: !772)
!775 = !DILocation(line: 505, column: 29, scope: !695)
!776 = !DILocation(line: 505, column: 37, scope: !695)
!777 = !DILocation(line: 505, column: 44, scope: !695)
!778 = !DILocation(line: 505, column: 51, scope: !695)
!779 = !DILocation(line: 505, column: 57, scope: !695)
!780 = !DILocation(line: 505, column: 7, scope: !695)
!781 = !DILocation(line: 505, column: 5, scope: !695)
!782 = !DILocation(line: 509, column: 3, scope: !695)
!783 = !DILocation(line: 515, column: 11, scope: !695)
!784 = !DILocation(line: 515, column: 19, scope: !695)
!785 = !DILocation(line: 515, column: 17, scope: !695)
!786 = !DILocation(line: 515, column: 9, scope: !695)
!787 = !DILocation(line: 516, column: 2, scope: !695)
!788 = !DILocation(line: 446, column: 52, scope: !691)
!789 = !DILocation(line: 446, column: 61, scope: !691)
!790 = !DILocation(line: 446, column: 2, scope: !691)
!791 = distinct !{!791, !693, !792, !341}
!792 = !DILocation(line: 516, column: 2, scope: !687)
!793 = !DILabel(scope: !651, name: "leave", file: !6, line: 523, column: 1)
!794 = !DILocation(line: 523, column: 1, scope: !651)
!795 = !DILocation(line: 524, column: 2, scope: !651)
!796 = !DILocation(line: 525, column: 2, scope: !651)
!797 = distinct !DISubprogram(name: "ck_pr_fence_memory", scope: !247, file: !247, line: 118, type: !248, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!798 = !DILocation(line: 118, column: 1, scope: !797)
!799 = distinct !DISubprogram(name: "ck_epoch_scan", scope: !6, file: !6, line: 321, type: !800, scopeLine: 325, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!800 = !DISubroutineType(types: !801)
!801 = !{!17, !29, !17, !7, !802}
!802 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 32)
!803 = !DILocalVariable(name: "global", arg: 1, scope: !799, file: !6, line: 321, type: !29)
!804 = !DILocation(line: 321, column: 32, scope: !799)
!805 = !DILocalVariable(name: "cr", arg: 2, scope: !799, file: !6, line: 322, type: !17)
!806 = !DILocation(line: 322, column: 29, scope: !799)
!807 = !DILocalVariable(name: "epoch", arg: 3, scope: !799, file: !6, line: 323, type: !7)
!808 = !DILocation(line: 323, column: 18, scope: !799)
!809 = !DILocalVariable(name: "af", arg: 4, scope: !799, file: !6, line: 324, type: !802)
!810 = !DILocation(line: 324, column: 11, scope: !799)
!811 = !DILocalVariable(name: "cursor", scope: !799, file: !6, line: 326, type: !292)
!812 = !DILocation(line: 326, column: 20, scope: !799)
!813 = !DILocation(line: 328, column: 6, scope: !814)
!814 = distinct !DILexicalBlock(scope: !799, file: !6, line: 328, column: 6)
!815 = !DILocation(line: 328, column: 9, scope: !814)
!816 = !DILocation(line: 329, column: 28, scope: !817)
!817 = distinct !DILexicalBlock(scope: !814, file: !6, line: 328, column: 18)
!818 = !DILocation(line: 329, column: 36, scope: !817)
!819 = !DILocation(line: 329, column: 12, scope: !817)
!820 = !DILocation(line: 329, column: 10, scope: !817)
!821 = !DILocation(line: 330, column: 4, scope: !817)
!822 = !DILocation(line: 330, column: 7, scope: !817)
!823 = !DILocation(line: 331, column: 2, scope: !817)
!824 = !DILocation(line: 332, column: 13, scope: !825)
!825 = distinct !DILexicalBlock(scope: !814, file: !6, line: 331, column: 9)
!826 = !DILocation(line: 332, column: 17, scope: !825)
!827 = !DILocation(line: 332, column: 10, scope: !825)
!828 = !DILocation(line: 333, column: 4, scope: !825)
!829 = !DILocation(line: 333, column: 7, scope: !825)
!830 = !DILocation(line: 336, column: 2, scope: !799)
!831 = !DILocation(line: 336, column: 9, scope: !799)
!832 = !DILocation(line: 336, column: 16, scope: !799)
!833 = !DILocalVariable(name: "state", scope: !834, file: !6, line: 337, type: !7)
!834 = distinct !DILexicalBlock(scope: !799, file: !6, line: 336, column: 25)
!835 = !DILocation(line: 337, column: 16, scope: !834)
!836 = !DILocalVariable(name: "active", scope: !834, file: !6, line: 337, type: !7)
!837 = !DILocation(line: 337, column: 23, scope: !834)
!838 = !DILocation(line: 339, column: 34, scope: !834)
!839 = !DILocation(line: 339, column: 8, scope: !834)
!840 = !DILocation(line: 339, column: 6, scope: !834)
!841 = !DILocation(line: 341, column: 28, scope: !834)
!842 = !DILocation(line: 341, column: 32, scope: !834)
!843 = !DILocation(line: 341, column: 11, scope: !834)
!844 = !DILocation(line: 341, column: 9, scope: !834)
!845 = !DILocation(line: 342, column: 7, scope: !846)
!846 = distinct !DILexicalBlock(scope: !834, file: !6, line: 342, column: 7)
!847 = !DILocation(line: 342, column: 13, scope: !846)
!848 = !DILocation(line: 343, column: 27, scope: !849)
!849 = distinct !DILexicalBlock(scope: !846, file: !6, line: 342, column: 36)
!850 = !DILocation(line: 343, column: 13, scope: !849)
!851 = !DILocation(line: 343, column: 11, scope: !849)
!852 = !DILocation(line: 344, column: 4, scope: !849)
!853 = distinct !{!853, !830, !854, !341}
!854 = !DILocation(line: 354, column: 2, scope: !799)
!855 = !DILocation(line: 347, column: 29, scope: !834)
!856 = !DILocation(line: 347, column: 33, scope: !834)
!857 = !DILocation(line: 347, column: 12, scope: !834)
!858 = !DILocation(line: 347, column: 10, scope: !834)
!859 = !DILocation(line: 348, column: 10, scope: !834)
!860 = !DILocation(line: 348, column: 4, scope: !834)
!861 = !DILocation(line: 348, column: 7, scope: !834)
!862 = !DILocation(line: 350, column: 7, scope: !863)
!863 = distinct !DILexicalBlock(scope: !834, file: !6, line: 350, column: 7)
!864 = !DILocation(line: 350, column: 14, scope: !863)
!865 = !DILocation(line: 350, column: 19, scope: !863)
!866 = !DILocation(line: 350, column: 39, scope: !863)
!867 = !DILocation(line: 350, column: 43, scope: !863)
!868 = !DILocation(line: 350, column: 22, scope: !863)
!869 = !DILocation(line: 350, column: 53, scope: !863)
!870 = !DILocation(line: 350, column: 50, scope: !863)
!871 = !DILocation(line: 351, column: 11, scope: !863)
!872 = !DILocation(line: 351, column: 4, scope: !863)
!873 = !DILocation(line: 353, column: 26, scope: !834)
!874 = !DILocation(line: 353, column: 12, scope: !834)
!875 = !DILocation(line: 353, column: 10, scope: !834)
!876 = !DILocation(line: 356, column: 2, scope: !799)
!877 = !DILocation(line: 357, column: 1, scope: !799)
!878 = distinct !DISubprogram(name: "ck_pr_stall", scope: !169, file: !169, line: 50, type: !248, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!879 = !DILocation(line: 53, column: 2, scope: !878)
!880 = !{i64 89929}
!881 = !DILocation(line: 54, column: 2, scope: !878)
!882 = distinct !DISubprogram(name: "ck_pr_cas_uint_value", scope: !169, file: !169, line: 385, type: !883, scopeLine: 385, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!883 = !DISubroutineType(types: !884)
!884 = !{!12, !172, !7, !7, !172}
!885 = !DILocalVariable(name: "target", arg: 1, scope: !882, file: !169, line: 385, type: !172)
!886 = !DILocation(line: 385, column: 1, scope: !882)
!887 = !DILocalVariable(name: "compare", arg: 2, scope: !882, file: !169, line: 385, type: !7)
!888 = !DILocalVariable(name: "set", arg: 3, scope: !882, file: !169, line: 385, type: !7)
!889 = !DILocalVariable(name: "value", arg: 4, scope: !882, file: !169, line: 385, type: !172)
!890 = !DILocalVariable(name: "previous", scope: !882, file: !169, line: 385, type: !7)
!891 = !DILocalVariable(name: "tmp", scope: !882, file: !169, line: 385, type: !7)
!892 = !{i64 2147603374}
!893 = distinct !DISubprogram(name: "ck_pr_fence_atomic_load", scope: !247, file: !247, line: 110, type: !248, scopeLine: 110, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!894 = !DILocation(line: 110, column: 1, scope: !893)
!895 = distinct !DISubprogram(name: "ck_epoch_synchronize", scope: !6, file: !6, line: 529, type: !476, scopeLine: 530, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !114)
!896 = !DILocalVariable(name: "record", arg: 1, scope: !895, file: !6, line: 529, type: !17)
!897 = !DILocation(line: 529, column: 46, scope: !895)
!898 = !DILocation(line: 532, column: 28, scope: !895)
!899 = !DILocation(line: 532, column: 36, scope: !895)
!900 = !DILocation(line: 532, column: 2, scope: !895)
!901 = !DILocation(line: 533, column: 2, scope: !895)
!902 = distinct !DISubprogram(name: "ck_epoch_barrier", scope: !6, file: !6, line: 537, type: !476, scopeLine: 538, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !114)
!903 = !DILocalVariable(name: "record", arg: 1, scope: !902, file: !6, line: 537, type: !17)
!904 = !DILocation(line: 537, column: 42, scope: !902)
!905 = !DILocation(line: 540, column: 23, scope: !902)
!906 = !DILocation(line: 540, column: 2, scope: !902)
!907 = !DILocation(line: 541, column: 19, scope: !902)
!908 = !DILocation(line: 541, column: 2, scope: !902)
!909 = !DILocation(line: 542, column: 2, scope: !902)
!910 = distinct !DISubprogram(name: "ck_epoch_barrier_wait", scope: !6, file: !6, line: 546, type: !911, scopeLine: 548, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !114)
!911 = !DISubroutineType(types: !912)
!912 = !{null, !17, !654, !16}
!913 = !DILocalVariable(name: "record", arg: 1, scope: !910, file: !6, line: 546, type: !17)
!914 = !DILocation(line: 546, column: 47, scope: !910)
!915 = !DILocalVariable(name: "cb", arg: 2, scope: !910, file: !6, line: 546, type: !654)
!916 = !DILocation(line: 546, column: 75, scope: !910)
!917 = !DILocalVariable(name: "ct", arg: 3, scope: !910, file: !6, line: 547, type: !16)
!918 = !DILocation(line: 547, column: 11, scope: !910)
!919 = !DILocation(line: 550, column: 28, scope: !910)
!920 = !DILocation(line: 550, column: 36, scope: !910)
!921 = !DILocation(line: 550, column: 44, scope: !910)
!922 = !DILocation(line: 550, column: 48, scope: !910)
!923 = !DILocation(line: 550, column: 2, scope: !910)
!924 = !DILocation(line: 551, column: 19, scope: !910)
!925 = !DILocation(line: 551, column: 2, scope: !910)
!926 = !DILocation(line: 552, column: 2, scope: !910)
!927 = distinct !DISubprogram(name: "ck_epoch_poll_deferred", scope: !6, file: !6, line: 566, type: !928, scopeLine: 567, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !114)
!928 = !DISubroutineType(types: !929)
!929 = !{!12, !17, !559}
!930 = !DILocalVariable(name: "record", arg: 1, scope: !927, file: !6, line: 566, type: !17)
!931 = !DILocation(line: 566, column: 48, scope: !927)
!932 = !DILocalVariable(name: "deferred", arg: 2, scope: !927, file: !6, line: 566, type: !559)
!933 = !DILocation(line: 566, column: 68, scope: !927)
!934 = !DILocalVariable(name: "active", scope: !927, file: !6, line: 568, type: !12)
!935 = !DILocation(line: 568, column: 7, scope: !927)
!936 = !DILocalVariable(name: "epoch", scope: !927, file: !6, line: 569, type: !7)
!937 = !DILocation(line: 569, column: 15, scope: !927)
!938 = !DILocalVariable(name: "cr", scope: !927, file: !6, line: 570, type: !17)
!939 = !DILocation(line: 570, column: 26, scope: !927)
!940 = !DILocalVariable(name: "global", scope: !927, file: !6, line: 571, type: !29)
!941 = !DILocation(line: 571, column: 19, scope: !927)
!942 = !DILocation(line: 571, column: 28, scope: !927)
!943 = !DILocation(line: 571, column: 36, scope: !927)
!944 = !DILocalVariable(name: "n_dispatch", scope: !927, file: !6, line: 572, type: !7)
!945 = !DILocation(line: 572, column: 15, scope: !927)
!946 = !DILocation(line: 574, column: 27, scope: !927)
!947 = !DILocation(line: 574, column: 35, scope: !927)
!948 = !DILocation(line: 574, column: 10, scope: !927)
!949 = !DILocation(line: 574, column: 8, scope: !927)
!950 = !DILocation(line: 577, column: 2, scope: !927)
!951 = !DILocation(line: 589, column: 33, scope: !927)
!952 = !DILocation(line: 589, column: 41, scope: !927)
!953 = !DILocation(line: 589, column: 47, scope: !927)
!954 = !DILocation(line: 589, column: 52, scope: !927)
!955 = !DILocation(line: 589, column: 15, scope: !927)
!956 = !DILocation(line: 589, column: 13, scope: !927)
!957 = !DILocation(line: 591, column: 21, scope: !927)
!958 = !DILocation(line: 591, column: 29, scope: !927)
!959 = !DILocation(line: 591, column: 33, scope: !927)
!960 = !DILocation(line: 591, column: 7, scope: !927)
!961 = !DILocation(line: 591, column: 5, scope: !927)
!962 = !DILocation(line: 592, column: 6, scope: !963)
!963 = distinct !DILexicalBlock(scope: !927, file: !6, line: 592, column: 6)
!964 = !DILocation(line: 592, column: 9, scope: !963)
!965 = !DILocation(line: 593, column: 11, scope: !963)
!966 = !DILocation(line: 593, column: 22, scope: !963)
!967 = !DILocation(line: 593, column: 3, scope: !963)
!968 = !DILocation(line: 596, column: 6, scope: !969)
!969 = distinct !DILexicalBlock(scope: !927, file: !6, line: 596, column: 6)
!970 = !DILocation(line: 596, column: 13, scope: !969)
!971 = !DILocation(line: 597, column: 19, scope: !972)
!972 = distinct !DILexicalBlock(scope: !969, file: !6, line: 596, column: 23)
!973 = !DILocation(line: 597, column: 3, scope: !972)
!974 = !DILocation(line: 597, column: 11, scope: !972)
!975 = !DILocation(line: 597, column: 17, scope: !972)
!976 = !DILocation(line: 598, column: 14, scope: !977)
!977 = distinct !DILexicalBlock(scope: !972, file: !6, line: 598, column: 3)
!978 = !DILocation(line: 598, column: 8, scope: !977)
!979 = !DILocation(line: 598, column: 19, scope: !980)
!980 = distinct !DILexicalBlock(scope: !977, file: !6, line: 598, column: 3)
!981 = !DILocation(line: 598, column: 25, scope: !980)
!982 = !DILocation(line: 598, column: 3, scope: !977)
!983 = !DILocation(line: 599, column: 22, scope: !980)
!984 = !DILocation(line: 599, column: 30, scope: !980)
!985 = !DILocation(line: 599, column: 37, scope: !980)
!986 = !DILocation(line: 599, column: 4, scope: !980)
!987 = !DILocation(line: 598, column: 49, scope: !980)
!988 = !DILocation(line: 598, column: 3, scope: !980)
!989 = distinct !{!989, !982, !990, !341}
!990 = !DILocation(line: 599, column: 45, scope: !977)
!991 = !DILocation(line: 601, column: 3, scope: !972)
!992 = !DILocation(line: 612, column: 24, scope: !927)
!993 = !DILocation(line: 612, column: 32, scope: !927)
!994 = !DILocation(line: 612, column: 39, scope: !927)
!995 = !DILocation(line: 612, column: 46, scope: !927)
!996 = !DILocation(line: 612, column: 52, scope: !927)
!997 = !DILocation(line: 612, column: 8, scope: !927)
!998 = !DILocation(line: 614, column: 20, scope: !927)
!999 = !DILocation(line: 614, column: 28, scope: !927)
!1000 = !DILocation(line: 614, column: 34, scope: !927)
!1001 = !DILocation(line: 614, column: 39, scope: !927)
!1002 = !DILocation(line: 614, column: 2, scope: !927)
!1003 = !DILocation(line: 615, column: 2, scope: !927)
!1004 = !DILocation(line: 616, column: 1, scope: !927)
!1005 = distinct !DISubprogram(name: "ck_pr_cas_uint", scope: !169, file: !169, line: 385, type: !1006, scopeLine: 385, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!1006 = !DISubroutineType(types: !1007)
!1007 = !{!12, !172, !7, !7}
!1008 = !DILocalVariable(name: "target", arg: 1, scope: !1005, file: !169, line: 385, type: !172)
!1009 = !DILocation(line: 385, column: 1, scope: !1005)
!1010 = !DILocalVariable(name: "compare", arg: 2, scope: !1005, file: !169, line: 385, type: !7)
!1011 = !DILocalVariable(name: "set", arg: 3, scope: !1005, file: !169, line: 385, type: !7)
!1012 = !DILocalVariable(name: "previous", scope: !1005, file: !169, line: 385, type: !7)
!1013 = !DILocalVariable(name: "tmp", scope: !1005, file: !169, line: 385, type: !7)
!1014 = !{i64 2147604059}
!1015 = distinct !DISubprogram(name: "ck_epoch_poll", scope: !6, file: !6, line: 619, type: !1016, scopeLine: 620, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !114)
!1016 = !DISubroutineType(types: !1017)
!1017 = !{!12, !17}
!1018 = !DILocalVariable(name: "record", arg: 1, scope: !1015, file: !6, line: 619, type: !17)
!1019 = !DILocation(line: 619, column: 39, scope: !1015)
!1020 = !DILocation(line: 622, column: 32, scope: !1015)
!1021 = !DILocation(line: 622, column: 9, scope: !1015)
!1022 = !DILocation(line: 622, column: 2, scope: !1015)
!1023 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 33, type: !1024, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !114)
!1024 = !DISubroutineType(types: !1025)
!1025 = !{!15, !15, !1026}
!1026 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 32)
!1027 = !DILocalVariable(name: "argc", arg: 1, scope: !1023, file: !3, line: 33, type: !15)
!1028 = !DILocation(line: 33, column: 14, scope: !1023)
!1029 = !DILocalVariable(name: "argv", arg: 2, scope: !1023, file: !3, line: 33, type: !1026)
!1030 = !DILocation(line: 33, column: 26, scope: !1023)
!1031 = !DILocalVariable(name: "threads", scope: !1023, file: !3, line: 35, type: !1032)
!1032 = !DICompositeType(tag: DW_TAG_array_type, baseType: !1033, size: 128, elements: !62)
!1033 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !1034, line: 2, baseType: !16)
!1034 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!1035 = !DILocation(line: 35, column: 12, scope: !1023)
!1036 = !DILocation(line: 37, column: 2, scope: !1023)
!1037 = !DILocalVariable(name: "i", scope: !1038, file: !3, line: 39, type: !15)
!1038 = distinct !DILexicalBlock(scope: !1023, file: !3, line: 39, column: 2)
!1039 = !DILocation(line: 39, column: 11, scope: !1038)
!1040 = !DILocation(line: 39, column: 7, scope: !1038)
!1041 = !DILocation(line: 39, column: 18, scope: !1042)
!1042 = distinct !DILexicalBlock(scope: !1038, file: !3, line: 39, column: 2)
!1043 = !DILocation(line: 39, column: 20, scope: !1042)
!1044 = !DILocation(line: 39, column: 2, scope: !1038)
!1045 = !DILocation(line: 41, column: 44, scope: !1046)
!1046 = distinct !DILexicalBlock(scope: !1042, file: !3, line: 40, column: 2)
!1047 = !DILocation(line: 41, column: 36, scope: !1046)
!1048 = !DILocation(line: 41, column: 3, scope: !1046)
!1049 = !DILocation(line: 42, column: 27, scope: !1046)
!1050 = !DILocation(line: 42, column: 19, scope: !1046)
!1051 = !DILocation(line: 42, column: 54, scope: !1046)
!1052 = !DILocation(line: 42, column: 46, scope: !1046)
!1053 = !DILocation(line: 42, column: 3, scope: !1046)
!1054 = !DILocation(line: 43, column: 2, scope: !1046)
!1055 = !DILocation(line: 39, column: 33, scope: !1042)
!1056 = !DILocation(line: 39, column: 2, scope: !1042)
!1057 = distinct !{!1057, !1044, !1058, !341}
!1058 = !DILocation(line: 43, column: 2, scope: !1038)
!1059 = !DILocalVariable(name: "i", scope: !1060, file: !3, line: 45, type: !15)
!1060 = distinct !DILexicalBlock(scope: !1023, file: !3, line: 45, column: 2)
!1061 = !DILocation(line: 45, column: 11, scope: !1060)
!1062 = !DILocation(line: 45, column: 7, scope: !1060)
!1063 = !DILocation(line: 45, column: 18, scope: !1064)
!1064 = distinct !DILexicalBlock(scope: !1060, file: !3, line: 45, column: 2)
!1065 = !DILocation(line: 45, column: 20, scope: !1064)
!1066 = !DILocation(line: 45, column: 2, scope: !1060)
!1067 = !DILocation(line: 46, column: 24, scope: !1064)
!1068 = !DILocation(line: 46, column: 16, scope: !1064)
!1069 = !DILocation(line: 46, column: 3, scope: !1064)
!1070 = !DILocation(line: 45, column: 33, scope: !1064)
!1071 = !DILocation(line: 45, column: 2, scope: !1064)
!1072 = distinct !{!1072, !1066, !1073, !341}
!1073 = !DILocation(line: 46, column: 32, scope: !1060)
!1074 = !DILocation(line: 48, column: 2, scope: !1023)
!1075 = distinct !DISubprogram(name: "thread", scope: !3, file: !3, line: 12, type: !1076, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!1076 = !DISubroutineType(types: !1077)
!1077 = !{!16, !16}
!1078 = !DILocalVariable(name: "arg", arg: 1, scope: !1075, file: !3, line: 12, type: !16)
!1079 = !DILocation(line: 12, column: 27, scope: !1075)
!1080 = !DILocalVariable(name: "record", scope: !1075, file: !3, line: 14, type: !76)
!1081 = !DILocation(line: 14, column: 21, scope: !1075)
!1082 = !DILocation(line: 14, column: 51, scope: !1075)
!1083 = !DILocation(line: 18, column: 17, scope: !1075)
!1084 = !DILocalVariable(name: "record", arg: 1, scope: !1085, file: !19, line: 126, type: !76)
!1085 = distinct !DISubprogram(name: "ck_epoch_begin", scope: !19, file: !19, line: 126, type: !1086, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!1086 = !DISubroutineType(types: !1087)
!1087 = !{null, !76, !1088}
!1088 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1089, size: 32)
!1089 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_section_t", file: !19, line: 72, baseType: !111)
!1090 = !DILocation(line: 126, column: 35, scope: !1085, inlinedAt: !1091)
!1091 = distinct !DILocation(line: 18, column: 2, scope: !1075)
!1092 = !DILocalVariable(name: "section", arg: 2, scope: !1085, file: !19, line: 126, type: !1088)
!1093 = !DILocation(line: 126, column: 63, scope: !1085, inlinedAt: !1091)
!1094 = !DILocalVariable(name: "epoch", scope: !1085, file: !19, line: 128, type: !29)
!1095 = !DILocation(line: 128, column: 19, scope: !1085, inlinedAt: !1091)
!1096 = !DILocation(line: 128, column: 27, scope: !1085, inlinedAt: !1091)
!1097 = !DILocation(line: 128, column: 35, scope: !1085, inlinedAt: !1091)
!1098 = !DILocation(line: 134, column: 6, scope: !1099, inlinedAt: !1091)
!1099 = distinct !DILexicalBlock(scope: !1085, file: !19, line: 134, column: 6)
!1100 = !DILocation(line: 134, column: 14, scope: !1099, inlinedAt: !1091)
!1101 = !DILocation(line: 134, column: 21, scope: !1099, inlinedAt: !1091)
!1102 = !DILocalVariable(name: "g_epoch", scope: !1103, file: !19, line: 135, type: !7)
!1103 = distinct !DILexicalBlock(scope: !1099, file: !19, line: 134, column: 27)
!1104 = !DILocation(line: 135, column: 16, scope: !1103, inlinedAt: !1091)
!1105 = !DILocation(line: 146, column: 21, scope: !1103, inlinedAt: !1091)
!1106 = !DILocation(line: 146, column: 29, scope: !1103, inlinedAt: !1091)
!1107 = !DILocation(line: 146, column: 3, scope: !1103, inlinedAt: !1091)
!1108 = !DILocation(line: 147, column: 3, scope: !1103, inlinedAt: !1091)
!1109 = !DILocation(line: 157, column: 30, scope: !1103, inlinedAt: !1091)
!1110 = !DILocation(line: 157, column: 13, scope: !1103, inlinedAt: !1091)
!1111 = !DILocation(line: 157, column: 11, scope: !1103, inlinedAt: !1091)
!1112 = !DILocation(line: 158, column: 21, scope: !1103, inlinedAt: !1091)
!1113 = !DILocation(line: 158, column: 29, scope: !1103, inlinedAt: !1091)
!1114 = !DILocation(line: 158, column: 36, scope: !1103, inlinedAt: !1091)
!1115 = !DILocation(line: 158, column: 3, scope: !1103, inlinedAt: !1091)
!1116 = !DILocation(line: 159, column: 2, scope: !1103, inlinedAt: !1091)
!1117 = !DILocation(line: 160, column: 21, scope: !1118, inlinedAt: !1091)
!1118 = distinct !DILexicalBlock(scope: !1099, file: !19, line: 159, column: 9)
!1119 = !DILocation(line: 160, column: 29, scope: !1118, inlinedAt: !1091)
!1120 = !DILocation(line: 160, column: 37, scope: !1118, inlinedAt: !1091)
!1121 = !DILocation(line: 160, column: 45, scope: !1118, inlinedAt: !1091)
!1122 = !DILocation(line: 160, column: 52, scope: !1118, inlinedAt: !1091)
!1123 = !DILocation(line: 160, column: 3, scope: !1118, inlinedAt: !1091)
!1124 = !DILocation(line: 163, column: 6, scope: !1125, inlinedAt: !1091)
!1125 = distinct !DILexicalBlock(scope: !1085, file: !19, line: 163, column: 6)
!1126 = !DILocation(line: 163, column: 14, scope: !1125, inlinedAt: !1091)
!1127 = !DILocation(line: 164, column: 20, scope: !1125, inlinedAt: !1091)
!1128 = !DILocation(line: 164, column: 28, scope: !1125, inlinedAt: !1091)
!1129 = !DILocation(line: 164, column: 3, scope: !1125, inlinedAt: !1091)
!1130 = !DILocalVariable(name: "global_epoch", scope: !1075, file: !3, line: 19, type: !15)
!1131 = !DILocation(line: 19, column: 6, scope: !1075)
!1132 = !DILocation(line: 19, column: 21, scope: !1075)
!1133 = !DILocalVariable(name: "local_epoch", scope: !1075, file: !3, line: 20, type: !15)
!1134 = !DILocation(line: 20, column: 6, scope: !1075)
!1135 = !DILocation(line: 20, column: 37, scope: !1075)
!1136 = !DILocation(line: 20, column: 45, scope: !1075)
!1137 = !DILocation(line: 20, column: 20, scope: !1075)
!1138 = !DILocation(line: 21, column: 15, scope: !1075)
!1139 = !DILocalVariable(name: "record", arg: 1, scope: !1140, file: !19, line: 174, type: !76)
!1140 = distinct !DISubprogram(name: "ck_epoch_end", scope: !19, file: !19, line: 174, type: !1141, scopeLine: 175, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!1141 = !DISubroutineType(types: !1142)
!1142 = !{!12, !76, !1088}
!1143 = !DILocation(line: 174, column: 33, scope: !1140, inlinedAt: !1144)
!1144 = distinct !DILocation(line: 21, column: 2, scope: !1075)
!1145 = !DILocalVariable(name: "section", arg: 2, scope: !1140, file: !19, line: 174, type: !1088)
!1146 = !DILocation(line: 174, column: 61, scope: !1140, inlinedAt: !1144)
!1147 = !DILocation(line: 177, column: 2, scope: !1140, inlinedAt: !1144)
!1148 = !DILocation(line: 178, column: 20, scope: !1140, inlinedAt: !1144)
!1149 = !DILocation(line: 178, column: 28, scope: !1140, inlinedAt: !1144)
!1150 = !DILocation(line: 178, column: 36, scope: !1140, inlinedAt: !1144)
!1151 = !DILocation(line: 178, column: 44, scope: !1140, inlinedAt: !1144)
!1152 = !DILocation(line: 178, column: 51, scope: !1140, inlinedAt: !1144)
!1153 = !DILocation(line: 178, column: 2, scope: !1140, inlinedAt: !1144)
!1154 = !DILocation(line: 180, column: 6, scope: !1155, inlinedAt: !1144)
!1155 = distinct !DILexicalBlock(scope: !1140, file: !19, line: 180, column: 6)
!1156 = !DILocation(line: 180, column: 14, scope: !1155, inlinedAt: !1144)
!1157 = !DILocation(line: 181, column: 27, scope: !1155, inlinedAt: !1144)
!1158 = !DILocation(line: 181, column: 35, scope: !1155, inlinedAt: !1144)
!1159 = !DILocation(line: 181, column: 10, scope: !1155, inlinedAt: !1144)
!1160 = !DILocation(line: 181, column: 3, scope: !1155, inlinedAt: !1144)
!1161 = !DILocation(line: 183, column: 9, scope: !1140, inlinedAt: !1144)
!1162 = !DILocation(line: 183, column: 17, scope: !1140, inlinedAt: !1144)
!1163 = !DILocation(line: 183, column: 24, scope: !1140, inlinedAt: !1144)
!1164 = !DILocation(line: 183, column: 2, scope: !1140, inlinedAt: !1144)
!1165 = !DILocation(line: 184, column: 1, scope: !1140, inlinedAt: !1144)
!1166 = !DILocation(line: 24, column: 11, scope: !1167)
!1167 = distinct !DILexicalBlock(scope: !1168, file: !3, line: 24, column: 2)
!1168 = distinct !DILexicalBlock(scope: !1075, file: !3, line: 24, column: 2)
!1169 = !DILocation(line: 24, column: 23, scope: !1167)
!1170 = !DILocation(line: 24, column: 28, scope: !1167)
!1171 = !DILocation(line: 24, column: 31, scope: !1167)
!1172 = !DILocation(line: 24, column: 44, scope: !1167)
!1173 = !DILocation(line: 24, column: 2, scope: !1167)
!1174 = !DILocation(line: 26, column: 16, scope: !1075)
!1175 = !DILocation(line: 26, column: 2, scope: !1075)
!1176 = !DILocation(line: 28, column: 2, scope: !1075)
!1177 = distinct !DISubprogram(name: "ck_pr_fence_strict_acqrel", scope: !169, file: !169, line: 97, type: !248, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!1178 = !DILocation(line: 97, column: 21, scope: !1177)
!1179 = !{i64 2147595222}
!1180 = !DILocation(line: 97, column: 1, scope: !1177)
!1181 = distinct !DISubprogram(name: "ck_pr_fence_strict_store", scope: !169, file: !169, line: 90, type: !248, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!1182 = !DILocation(line: 90, column: 20, scope: !1181)
!1183 = !{i64 2147593128}
!1184 = !DILocation(line: 90, column: 1, scope: !1181)
!1185 = distinct !DISubprogram(name: "ck_pr_fence_strict_load", scope: !169, file: !169, line: 92, type: !248, scopeLine: 92, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!1186 = !DILocation(line: 92, column: 19, scope: !1185)
!1187 = !{i64 2147593727}
!1188 = !DILocation(line: 92, column: 1, scope: !1185)
!1189 = distinct !DISubprogram(name: "ck_pr_md_load_ptr", scope: !169, file: !169, line: 120, type: !1190, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!1190 = !DISubroutineType(types: !1191)
!1191 = !{!16, !371}
!1192 = !DILocalVariable(name: "target", arg: 1, scope: !1189, file: !169, line: 120, type: !371)
!1193 = !DILocation(line: 120, column: 1, scope: !1189)
!1194 = !DILocalVariable(name: "r", scope: !1189, file: !169, line: 120, type: !244)
!1195 = !{i64 2147596174}
!1196 = distinct !DISubprogram(name: "ck_pr_cas_ptr_value", scope: !169, file: !169, line: 299, type: !1197, scopeLine: 300, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!1197 = !DISubroutineType(types: !1198)
!1198 = !{!12, !16, !16, !16, !16}
!1199 = !DILocalVariable(name: "target", arg: 1, scope: !1196, file: !169, line: 299, type: !16)
!1200 = !DILocation(line: 299, column: 27, scope: !1196)
!1201 = !DILocalVariable(name: "compare", arg: 2, scope: !1196, file: !169, line: 299, type: !16)
!1202 = !DILocation(line: 299, column: 41, scope: !1196)
!1203 = !DILocalVariable(name: "set", arg: 3, scope: !1196, file: !169, line: 299, type: !16)
!1204 = !DILocation(line: 299, column: 56, scope: !1196)
!1205 = !DILocalVariable(name: "value", arg: 4, scope: !1196, file: !169, line: 299, type: !16)
!1206 = !DILocation(line: 299, column: 67, scope: !1196)
!1207 = !DILocalVariable(name: "previous", scope: !1196, file: !169, line: 301, type: !16)
!1208 = !DILocation(line: 301, column: 8, scope: !1196)
!1209 = !DILocalVariable(name: "tmp", scope: !1196, file: !169, line: 301, type: !16)
!1210 = !DILocation(line: 301, column: 19, scope: !1196)
!1211 = !DILocation(line: 311, column: 16, scope: !1196)
!1212 = !DILocation(line: 312, column: 14, scope: !1196)
!1213 = !DILocation(line: 313, column: 14, scope: !1196)
!1214 = !DILocation(line: 302, column: 2, scope: !1196)
!1215 = !{i64 96553}
!1216 = !DILocation(line: 315, column: 20, scope: !1196)
!1217 = !DILocation(line: 315, column: 12, scope: !1196)
!1218 = !DILocation(line: 315, column: 18, scope: !1196)
!1219 = !DILocation(line: 316, column: 10, scope: !1196)
!1220 = !DILocation(line: 316, column: 22, scope: !1196)
!1221 = !DILocation(line: 316, column: 19, scope: !1196)
!1222 = !DILocation(line: 316, column: 2, scope: !1196)
!1223 = distinct !DISubprogram(name: "ck_stack_batch_pop_upmc", scope: !23, file: !23, line: 151, type: !1224, scopeLine: 152, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!1224 = !DISubroutineType(types: !1225)
!1225 = !{!27, !270}
!1226 = !DILocalVariable(name: "target", arg: 1, scope: !1223, file: !23, line: 151, type: !270)
!1227 = !DILocation(line: 151, column: 42, scope: !1223)
!1228 = !DILocalVariable(name: "entry", scope: !1223, file: !23, line: 153, type: !27)
!1229 = !DILocation(line: 153, column: 25, scope: !1223)
!1230 = !DILocation(line: 155, column: 25, scope: !1223)
!1231 = !DILocation(line: 155, column: 33, scope: !1223)
!1232 = !DILocation(line: 155, column: 10, scope: !1223)
!1233 = !DILocation(line: 155, column: 8, scope: !1223)
!1234 = !DILocation(line: 156, column: 2, scope: !1223)
!1235 = !DILocation(line: 157, column: 9, scope: !1223)
!1236 = !DILocation(line: 157, column: 2, scope: !1223)
!1237 = distinct !DISubprogram(name: "ck_epoch_entry_container", scope: !6, file: !6, line: 146, type: !1238, scopeLine: 145, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!1238 = !DISubroutineType(types: !1239)
!1239 = !{!65, !292}
!1240 = !DILocalVariable(name: "p", arg: 1, scope: !1237, file: !6, line: 145, type: !292)
!1241 = !DILocation(line: 145, column: 1, scope: !1237)
!1242 = distinct !DISubprogram(name: "ck_stack_push_spnc", scope: !23, file: !23, line: 291, type: !442, scopeLine: 292, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!1243 = !DILocalVariable(name: "target", arg: 1, scope: !1242, file: !23, line: 291, type: !270)
!1244 = !DILocation(line: 291, column: 37, scope: !1242)
!1245 = !DILocalVariable(name: "entry", arg: 2, scope: !1242, file: !23, line: 291, type: !27)
!1246 = !DILocation(line: 291, column: 68, scope: !1242)
!1247 = !DILocation(line: 294, column: 16, scope: !1242)
!1248 = !DILocation(line: 294, column: 24, scope: !1242)
!1249 = !DILocation(line: 294, column: 2, scope: !1242)
!1250 = !DILocation(line: 294, column: 9, scope: !1242)
!1251 = !DILocation(line: 294, column: 14, scope: !1242)
!1252 = !DILocation(line: 295, column: 17, scope: !1242)
!1253 = !DILocation(line: 295, column: 2, scope: !1242)
!1254 = !DILocation(line: 295, column: 10, scope: !1242)
!1255 = !DILocation(line: 295, column: 15, scope: !1242)
!1256 = !DILocation(line: 296, column: 2, scope: !1242)
!1257 = distinct !DISubprogram(name: "ck_pr_add_uint", scope: !169, file: !169, line: 501, type: !170, scopeLine: 501, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!1258 = !DILocalVariable(name: "target", arg: 1, scope: !1257, file: !169, line: 501, type: !172)
!1259 = !DILocation(line: 501, column: 1, scope: !1257)
!1260 = !DILocalVariable(name: "delta", arg: 2, scope: !1257, file: !169, line: 501, type: !7)
!1261 = !DILocalVariable(name: "previous", scope: !1257, file: !169, line: 501, type: !7)
!1262 = !DILocalVariable(name: "tmp", scope: !1257, file: !169, line: 501, type: !7)
!1263 = !{i64 2147641880}
!1264 = distinct !DISubprogram(name: "ck_pr_sub_uint", scope: !169, file: !169, line: 501, type: !170, scopeLine: 501, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!1265 = !DILocalVariable(name: "target", arg: 1, scope: !1264, file: !169, line: 501, type: !172)
!1266 = !DILocation(line: 501, column: 1, scope: !1264)
!1267 = !DILocalVariable(name: "delta", arg: 2, scope: !1264, file: !169, line: 501, type: !7)
!1268 = !DILocalVariable(name: "previous", scope: !1264, file: !169, line: 501, type: !7)
!1269 = !DILocalVariable(name: "tmp", scope: !1264, file: !169, line: 501, type: !7)
!1270 = !{i64 2147643048}
!1271 = distinct !DISubprogram(name: "ck_pr_fas_ptr", scope: !169, file: !169, line: 415, type: !1272, scopeLine: 415, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !114)
!1272 = !DISubroutineType(types: !1273)
!1273 = !{!16, !16, !16}
!1274 = !DILocalVariable(name: "target", arg: 1, scope: !1271, file: !169, line: 415, type: !16)
!1275 = !DILocation(line: 415, column: 1, scope: !1271)
!1276 = !DILocalVariable(name: "v", arg: 2, scope: !1271, file: !169, line: 415, type: !16)
!1277 = !DILocalVariable(name: "previous", scope: !1271, file: !169, line: 415, type: !16)
!1278 = !DILocalVariable(name: "tmp", scope: !1271, file: !169, line: 415, type: !16)
!1279 = !{i64 2147612513}
!1280 = distinct !DISubprogram(name: "ck_pr_fence_strict_memory", scope: !169, file: !169, line: 94, type: !248, scopeLine: 94, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!1281 = !DILocation(line: 94, column: 21, scope: !1280)
!1282 = !{i64 2147594327}
!1283 = !DILocation(line: 94, column: 1, scope: !1280)
!1284 = distinct !DISubprogram(name: "ck_pr_fence_strict_atomic_load", scope: !169, file: !169, line: 87, type: !248, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!1285 = !DILocation(line: 87, column: 26, scope: !1284)
!1286 = !{i64 2147592197}
!1287 = !DILocation(line: 87, column: 1, scope: !1284)
!1288 = distinct !DISubprogram(name: "ck_pr_fence_release", scope: !247, file: !247, line: 120, type: !248, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!1289 = !DILocation(line: 120, column: 1, scope: !1288)
!1290 = distinct !DISubprogram(name: "ck_pr_fence_strict_release", scope: !169, file: !169, line: 96, type: !248, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!1291 = !DILocation(line: 96, column: 22, scope: !1290)
!1292 = !{i64 2147594924}
!1293 = !DILocation(line: 96, column: 1, scope: !1290)
