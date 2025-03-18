; ModuleID = 'tests/ebr.c'
source_filename = "tests/ebr.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_epoch = type { i32, i32, %struct.ck_stack }
%struct.ck_stack = type { ptr, ptr }
%struct.ck_epoch_record = type { %struct.ck_stack_entry, ptr, i32, i32, i32, [36 x i8], %struct.anon, i32, i32, i32, ptr, [4 x %struct.ck_stack], [24 x i8] }
%struct.ck_stack_entry = type { ptr }
%struct.anon = type { [2 x %struct.ck_epoch_ref] }
%struct.ck_epoch_ref = type { i32, i32 }
%struct.ck_epoch_section = type { i32 }
%struct.ck_epoch_entry = type { ptr, %struct.ck_stack_entry }

@stack_epoch = internal global %struct.ck_epoch zeroinitializer, align 8, !dbg !0
@records = global [4 x %struct.ck_epoch_record] zeroinitializer, align 64, !dbg !84
@__func__.thread = private unnamed_addr constant [7 x i8] c"thread\00", align 1, !dbg !87
@.str = private unnamed_addr constant [6 x i8] c"ebr.c\00", align 1, !dbg !93
@.str.1 = private unnamed_addr constant [41 x i8] c"!(local_epoch == 1 && global_epoch == 3)\00", align 1, !dbg !98

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define zeroext i1 @_ck_epoch_delref(ptr noundef %0, ptr noundef %1) #0 !dbg !112 {
  %3 = alloca i1, align 1
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  %9 = load ptr, ptr %5, align 8, !dbg !132
  %10 = getelementptr inbounds %struct.ck_epoch_section, ptr %9, i32 0, i32 0, !dbg !133
  %11 = load i32, ptr %10, align 4, !dbg !133
  store i32 %11, ptr %8, align 4, !dbg !131
  %12 = load ptr, ptr %4, align 8, !dbg !134
  %13 = getelementptr inbounds %struct.ck_epoch_record, ptr %12, i32 0, i32 6, !dbg !135
  %14 = getelementptr inbounds %struct.anon, ptr %13, i32 0, i32 0, !dbg !136
  %15 = load i32, ptr %8, align 4, !dbg !137
  %16 = zext i32 %15 to i64, !dbg !134
  %17 = getelementptr inbounds [2 x %struct.ck_epoch_ref], ptr %14, i64 0, i64 %16, !dbg !134
  store ptr %17, ptr %6, align 8, !dbg !138
  %18 = load ptr, ptr %6, align 8, !dbg !139
  %19 = getelementptr inbounds %struct.ck_epoch_ref, ptr %18, i32 0, i32 1, !dbg !140
  %20 = load i32, ptr %19, align 4, !dbg !141
  %21 = add i32 %20, -1, !dbg !141
  store i32 %21, ptr %19, align 4, !dbg !141
  %22 = load ptr, ptr %6, align 8, !dbg !142
  %23 = getelementptr inbounds %struct.ck_epoch_ref, ptr %22, i32 0, i32 1, !dbg !144
  %24 = load i32, ptr %23, align 4, !dbg !144
  %25 = icmp ugt i32 %24, 0, !dbg !145
  br i1 %25, label %26, label %27, !dbg !146

26:                                               ; preds = %2
  store i1 false, ptr %3, align 1, !dbg !147
  br label %56, !dbg !147

27:                                               ; preds = %2
  %28 = load ptr, ptr %4, align 8, !dbg !148
  %29 = getelementptr inbounds %struct.ck_epoch_record, ptr %28, i32 0, i32 6, !dbg !149
  %30 = getelementptr inbounds %struct.anon, ptr %29, i32 0, i32 0, !dbg !150
  %31 = load i32, ptr %8, align 4, !dbg !151
  %32 = add i32 %31, 1, !dbg !152
  %33 = and i32 %32, 1, !dbg !153
  %34 = zext i32 %33 to i64, !dbg !148
  %35 = getelementptr inbounds [2 x %struct.ck_epoch_ref], ptr %30, i64 0, i64 %34, !dbg !148
  store ptr %35, ptr %7, align 8, !dbg !154
  %36 = load ptr, ptr %7, align 8, !dbg !155
  %37 = getelementptr inbounds %struct.ck_epoch_ref, ptr %36, i32 0, i32 1, !dbg !157
  %38 = load i32, ptr %37, align 4, !dbg !157
  %39 = icmp ugt i32 %38, 0, !dbg !158
  br i1 %39, label %40, label %55, !dbg !159

40:                                               ; preds = %27
  %41 = load ptr, ptr %6, align 8, !dbg !160
  %42 = getelementptr inbounds %struct.ck_epoch_ref, ptr %41, i32 0, i32 0, !dbg !161
  %43 = load i32, ptr %42, align 4, !dbg !161
  %44 = load ptr, ptr %7, align 8, !dbg !162
  %45 = getelementptr inbounds %struct.ck_epoch_ref, ptr %44, i32 0, i32 0, !dbg !163
  %46 = load i32, ptr %45, align 4, !dbg !163
  %47 = sub i32 %43, %46, !dbg !164
  %48 = icmp slt i32 %47, 0, !dbg !165
  br i1 %48, label %49, label %55, !dbg !166

49:                                               ; preds = %40
  %50 = load ptr, ptr %4, align 8, !dbg !167
  %51 = getelementptr inbounds %struct.ck_epoch_record, ptr %50, i32 0, i32 3, !dbg !167
  %52 = load ptr, ptr %7, align 8, !dbg !167
  %53 = getelementptr inbounds %struct.ck_epoch_ref, ptr %52, i32 0, i32 0, !dbg !167
  %54 = load i32, ptr %53, align 4, !dbg !167
  call void @ck_pr_md_store_uint(ptr noundef %51, i32 noundef %54), !dbg !167
  br label %55, !dbg !169

55:                                               ; preds = %49, %40, %27
  store i1 true, ptr %3, align 1, !dbg !170
  br label %56, !dbg !170

56:                                               ; preds = %55, %26
  %57 = load i1, ptr %3, align 1, !dbg !171
  ret i1 %57, !dbg !171
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !172 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8, !dbg !177
  %6 = load i32, ptr %4, align 4, !dbg !177
  call void asm sideeffect "stw $1, $0", "=*m,r,~{memory}"(ptr elementtype(i32) %5, i32 %6) #5, !dbg !177, !srcloc !179
  ret void, !dbg !177
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @_ck_epoch_addref(ptr noundef %0, ptr noundef %1) #0 !dbg !180 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %10 = load ptr, ptr %3, align 8, !dbg !189
  %11 = getelementptr inbounds %struct.ck_epoch_record, ptr %10, i32 0, i32 1, !dbg !190
  %12 = load ptr, ptr %11, align 8, !dbg !190
  store ptr %12, ptr %5, align 8, !dbg !188
  %13 = load ptr, ptr %5, align 8, !dbg !197
  %14 = getelementptr inbounds %struct.ck_epoch, ptr %13, i32 0, i32 0, !dbg !197
  %15 = call i32 @ck_pr_md_load_uint(ptr noundef %14), !dbg !197
  store i32 %15, ptr %7, align 4, !dbg !198
  %16 = load i32, ptr %7, align 4, !dbg !199
  %17 = and i32 %16, 1, !dbg !200
  store i32 %17, ptr %8, align 4, !dbg !201
  %18 = load ptr, ptr %3, align 8, !dbg !202
  %19 = getelementptr inbounds %struct.ck_epoch_record, ptr %18, i32 0, i32 6, !dbg !203
  %20 = getelementptr inbounds %struct.anon, ptr %19, i32 0, i32 0, !dbg !204
  %21 = load i32, ptr %8, align 4, !dbg !205
  %22 = zext i32 %21 to i64, !dbg !202
  %23 = getelementptr inbounds [2 x %struct.ck_epoch_ref], ptr %20, i64 0, i64 %22, !dbg !202
  store ptr %23, ptr %6, align 8, !dbg !206
  %24 = load ptr, ptr %6, align 8, !dbg !207
  %25 = getelementptr inbounds %struct.ck_epoch_ref, ptr %24, i32 0, i32 1, !dbg !209
  %26 = load i32, ptr %25, align 4, !dbg !210
  %27 = add i32 %26, 1, !dbg !210
  store i32 %27, ptr %25, align 4, !dbg !210
  %28 = icmp eq i32 %26, 0, !dbg !211
  br i1 %28, label %29, label %47, !dbg !212

29:                                               ; preds = %2
  %30 = load ptr, ptr %3, align 8, !dbg !216
  %31 = getelementptr inbounds %struct.ck_epoch_record, ptr %30, i32 0, i32 6, !dbg !217
  %32 = getelementptr inbounds %struct.anon, ptr %31, i32 0, i32 0, !dbg !218
  %33 = load i32, ptr %8, align 4, !dbg !219
  %34 = add i32 %33, 1, !dbg !220
  %35 = and i32 %34, 1, !dbg !221
  %36 = zext i32 %35 to i64, !dbg !216
  %37 = getelementptr inbounds [2 x %struct.ck_epoch_ref], ptr %32, i64 0, i64 %36, !dbg !216
  store ptr %37, ptr %9, align 8, !dbg !222
  %38 = load ptr, ptr %9, align 8, !dbg !223
  %39 = getelementptr inbounds %struct.ck_epoch_ref, ptr %38, i32 0, i32 1, !dbg !225
  %40 = load i32, ptr %39, align 4, !dbg !225
  %41 = icmp ugt i32 %40, 0, !dbg !226
  br i1 %41, label %42, label %43, !dbg !227

42:                                               ; preds = %29
  call void @ck_pr_fence_acqrel(), !dbg !228
  br label %43, !dbg !228

43:                                               ; preds = %42, %29
  %44 = load i32, ptr %7, align 4, !dbg !229
  %45 = load ptr, ptr %6, align 8, !dbg !230
  %46 = getelementptr inbounds %struct.ck_epoch_ref, ptr %45, i32 0, i32 0, !dbg !231
  store i32 %44, ptr %46, align 4, !dbg !232
  br label %47, !dbg !233

47:                                               ; preds = %43, %2
  %48 = load i32, ptr %8, align 4, !dbg !234
  %49 = load ptr, ptr %4, align 8, !dbg !235
  %50 = getelementptr inbounds %struct.ck_epoch_section, ptr %49, i32 0, i32 0, !dbg !236
  store i32 %48, ptr %50, align 4, !dbg !237
  ret void, !dbg !238
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !239 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !243
  %5 = call i32 asm sideeffect "lwz $0, $1", "=r,*m,~{memory}"(ptr elementtype(i32) %4) #5, !dbg !243, !srcloc !245
  store i32 %5, ptr %3, align 4, !dbg !243
  %6 = load i32, ptr %3, align 4, !dbg !243
  ret i32 %6, !dbg !243
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_acqrel() #0 !dbg !246 {
  call void @ck_pr_fence_strict_acqrel(), !dbg !250
  ret void, !dbg !250
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @ck_epoch_init(ptr noundef %0) #0 !dbg !251 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8, !dbg !256
  %4 = getelementptr inbounds %struct.ck_epoch, ptr %3, i32 0, i32 2, !dbg !257
  call void @ck_stack_init(ptr noundef %4), !dbg !258
  %5 = load ptr, ptr %2, align 8, !dbg !259
  %6 = getelementptr inbounds %struct.ck_epoch, ptr %5, i32 0, i32 0, !dbg !260
  store i32 1, ptr %6, align 8, !dbg !261
  %7 = load ptr, ptr %2, align 8, !dbg !262
  %8 = getelementptr inbounds %struct.ck_epoch, ptr %7, i32 0, i32 1, !dbg !263
  store i32 0, ptr %8, align 4, !dbg !264
  call void @ck_pr_fence_store(), !dbg !265
  ret void, !dbg !266
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_stack_init(ptr noundef %0) #0 !dbg !267 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8, !dbg !273
  %4 = getelementptr inbounds %struct.ck_stack, ptr %3, i32 0, i32 0, !dbg !274
  store ptr null, ptr %4, align 8, !dbg !275
  %5 = load ptr, ptr %2, align 8, !dbg !276
  %6 = getelementptr inbounds %struct.ck_stack, ptr %5, i32 0, i32 1, !dbg !277
  store ptr null, ptr %6, align 8, !dbg !278
  ret void, !dbg !279
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_store() #0 !dbg !280 {
  call void @ck_pr_fence_strict_store(), !dbg !281
  ret void, !dbg !281
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @ck_epoch_recycle(ptr noundef %0, ptr noundef %1) #0 !dbg !282 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  %9 = load ptr, ptr %4, align 8, !dbg !296
  %10 = getelementptr inbounds %struct.ck_epoch, ptr %9, i32 0, i32 1, !dbg !296
  %11 = call i32 @ck_pr_md_load_uint(ptr noundef %10), !dbg !296
  %12 = icmp eq i32 %11, 0, !dbg !298
  br i1 %12, label %13, label %14, !dbg !299

13:                                               ; preds = %2
  store ptr null, ptr %3, align 8, !dbg !300
  br label %49, !dbg !300

14:                                               ; preds = %2
  %15 = load ptr, ptr %4, align 8, !dbg !301
  %16 = getelementptr inbounds %struct.ck_epoch, ptr %15, i32 0, i32 2, !dbg !301
  %17 = getelementptr inbounds %struct.ck_stack, ptr %16, i32 0, i32 0, !dbg !301
  %18 = load ptr, ptr %17, align 8, !dbg !301
  store ptr %18, ptr %7, align 8, !dbg !301
  br label %19, !dbg !301

19:                                               ; preds = %44, %14
  %20 = load ptr, ptr %7, align 8, !dbg !303
  %21 = icmp ne ptr %20, null, !dbg !303
  br i1 %21, label %22, label %48, !dbg !301

22:                                               ; preds = %19
  %23 = load ptr, ptr %7, align 8, !dbg !305
  %24 = call ptr @ck_epoch_record_container(ptr noundef %23), !dbg !307
  store ptr %24, ptr %6, align 8, !dbg !308
  %25 = load ptr, ptr %6, align 8, !dbg !309
  %26 = getelementptr inbounds %struct.ck_epoch_record, ptr %25, i32 0, i32 2, !dbg !309
  %27 = call i32 @ck_pr_md_load_uint(ptr noundef %26), !dbg !309
  %28 = icmp eq i32 %27, 1, !dbg !311
  br i1 %28, label %29, label %43, !dbg !312

29:                                               ; preds = %22
  call void @ck_pr_fence_load(), !dbg !313
  %30 = load ptr, ptr %6, align 8, !dbg !315
  %31 = getelementptr inbounds %struct.ck_epoch_record, ptr %30, i32 0, i32 2, !dbg !316
  %32 = call i32 @ck_pr_fas_uint(ptr noundef %31, i32 noundef 0), !dbg !317
  store i32 %32, ptr %8, align 4, !dbg !318
  %33 = load i32, ptr %8, align 4, !dbg !319
  %34 = icmp eq i32 %33, 1, !dbg !321
  br i1 %34, label %35, label %42, !dbg !322

35:                                               ; preds = %29
  %36 = load ptr, ptr %4, align 8, !dbg !323
  %37 = getelementptr inbounds %struct.ck_epoch, ptr %36, i32 0, i32 1, !dbg !325
  call void @ck_pr_dec_uint(ptr noundef %37), !dbg !326
  %38 = load ptr, ptr %6, align 8, !dbg !327
  %39 = getelementptr inbounds %struct.ck_epoch_record, ptr %38, i32 0, i32 10, !dbg !327
  %40 = load ptr, ptr %5, align 8, !dbg !327
  call void @ck_pr_md_store_ptr(ptr noundef %39, ptr noundef %40), !dbg !327
  %41 = load ptr, ptr %6, align 8, !dbg !328
  store ptr %41, ptr %3, align 8, !dbg !329
  br label %49, !dbg !329

42:                                               ; preds = %29
  br label %43, !dbg !330

43:                                               ; preds = %42, %22
  br label %44, !dbg !331

44:                                               ; preds = %43
  %45 = load ptr, ptr %7, align 8, !dbg !303
  %46 = getelementptr inbounds %struct.ck_stack_entry, ptr %45, i32 0, i32 0, !dbg !303
  %47 = load ptr, ptr %46, align 8, !dbg !303
  store ptr %47, ptr %7, align 8, !dbg !303
  br label %19, !dbg !303, !llvm.loop !332

48:                                               ; preds = %19
  store ptr null, ptr %3, align 8, !dbg !335
  br label %49, !dbg !335

49:                                               ; preds = %48, %35, %13
  %50 = load ptr, ptr %3, align 8, !dbg !336
  ret ptr %50, !dbg !336
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_epoch_record_container(ptr noundef %0) #0 !dbg !337 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8, !dbg !341
  %4 = getelementptr inbounds i8, ptr %3, i64 0, !dbg !341
  ret ptr %4, !dbg !341
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_load() #0 !dbg !342 {
  call void @ck_pr_fence_strict_load(), !dbg !343
  ret void, !dbg !343
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_fas_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !344 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %6 = load ptr, ptr %3, align 8, !dbg !348
  %7 = load i32, ptr %4, align 4, !dbg !348
  %8 = call i32 asm sideeffect "1:;lwarx $0, 0, $1;stwcx. $2, 0, $1;bne- 1b;", "=&r,r,r,~{memory},~{cc}"(ptr %6, i32 %7) #5, !dbg !348, !srcloc !351
  store i32 %8, ptr %5, align 4, !dbg !348
  %9 = load i32, ptr %5, align 4, !dbg !348
  ret i32 %9, !dbg !348
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_dec_uint(ptr noundef %0) #0 !dbg !352 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !356
  %5 = call i32 asm sideeffect "1:;lwarx $0, 0, $1;addic $0, $0, -1;stwcx. $0, 0, $1;bne-  1b;", "=&r,r,~{memory},~{cc}"(ptr %4) #5, !dbg !356, !srcloc !358
  store i32 %5, ptr %3, align 4, !dbg !356
  ret void, !dbg !356
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_md_store_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !359 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8, !dbg !365
  %6 = load ptr, ptr %4, align 8, !dbg !365
  call void asm sideeffect "std $1, $0", "=*m,r,~{memory}"(ptr elementtype(i64) %5, ptr %6) #5, !dbg !365, !srcloc !367
  ret void, !dbg !365
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @ck_epoch_register(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 !dbg !368 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i64, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store ptr %2, ptr %6, align 8
  %8 = load ptr, ptr %4, align 8, !dbg !384
  %9 = load ptr, ptr %5, align 8, !dbg !385
  %10 = getelementptr inbounds %struct.ck_epoch_record, ptr %9, i32 0, i32 1, !dbg !386
  store ptr %8, ptr %10, align 8, !dbg !387
  %11 = load ptr, ptr %5, align 8, !dbg !388
  %12 = getelementptr inbounds %struct.ck_epoch_record, ptr %11, i32 0, i32 2, !dbg !389
  store i32 0, ptr %12, align 16, !dbg !390
  %13 = load ptr, ptr %5, align 8, !dbg !391
  %14 = getelementptr inbounds %struct.ck_epoch_record, ptr %13, i32 0, i32 4, !dbg !392
  store i32 0, ptr %14, align 8, !dbg !393
  %15 = load ptr, ptr %5, align 8, !dbg !394
  %16 = getelementptr inbounds %struct.ck_epoch_record, ptr %15, i32 0, i32 3, !dbg !395
  store i32 0, ptr %16, align 4, !dbg !396
  %17 = load ptr, ptr %5, align 8, !dbg !397
  %18 = getelementptr inbounds %struct.ck_epoch_record, ptr %17, i32 0, i32 9, !dbg !398
  store i32 0, ptr %18, align 8, !dbg !399
  %19 = load ptr, ptr %5, align 8, !dbg !400
  %20 = getelementptr inbounds %struct.ck_epoch_record, ptr %19, i32 0, i32 8, !dbg !401
  store i32 0, ptr %20, align 4, !dbg !402
  %21 = load ptr, ptr %5, align 8, !dbg !403
  %22 = getelementptr inbounds %struct.ck_epoch_record, ptr %21, i32 0, i32 7, !dbg !404
  store i32 0, ptr %22, align 16, !dbg !405
  %23 = load ptr, ptr %6, align 8, !dbg !406
  %24 = load ptr, ptr %5, align 8, !dbg !407
  %25 = getelementptr inbounds %struct.ck_epoch_record, ptr %24, i32 0, i32 10, !dbg !408
  store ptr %23, ptr %25, align 32, !dbg !409
  %26 = load ptr, ptr %5, align 8, !dbg !410
  %27 = getelementptr inbounds %struct.ck_epoch_record, ptr %26, i32 0, i32 6, !dbg !410
  %28 = load ptr, ptr %5, align 8, !dbg !410
  %29 = getelementptr inbounds %struct.ck_epoch_record, ptr %28, i32 0, i32 6, !dbg !410
  %30 = call i64 @llvm.objectsize.i64.p0(ptr %29, i1 false, i1 true, i1 false), !dbg !410
  %31 = call ptr @__memset_chk(ptr noundef %27, i32 noundef 0, i64 noundef 16, i64 noundef %30) #5, !dbg !410
  store i64 0, ptr %7, align 8, !dbg !411
  br label %32, !dbg !413

32:                                               ; preds = %40, %3
  %33 = load i64, ptr %7, align 8, !dbg !414
  %34 = icmp ult i64 %33, 4, !dbg !416
  br i1 %34, label %35, label %43, !dbg !417

35:                                               ; preds = %32
  %36 = load ptr, ptr %5, align 8, !dbg !418
  %37 = getelementptr inbounds %struct.ck_epoch_record, ptr %36, i32 0, i32 11, !dbg !419
  %38 = load i64, ptr %7, align 8, !dbg !420
  %39 = getelementptr inbounds [4 x %struct.ck_stack], ptr %37, i64 0, i64 %38, !dbg !418
  call void @ck_stack_init(ptr noundef %39), !dbg !421
  br label %40, !dbg !421

40:                                               ; preds = %35
  %41 = load i64, ptr %7, align 8, !dbg !422
  %42 = add i64 %41, 1, !dbg !422
  store i64 %42, ptr %7, align 8, !dbg !422
  br label %32, !dbg !423, !llvm.loop !424

43:                                               ; preds = %32
  call void @ck_pr_fence_store(), !dbg !426
  %44 = load ptr, ptr %4, align 8, !dbg !427
  %45 = getelementptr inbounds %struct.ck_epoch, ptr %44, i32 0, i32 2, !dbg !428
  %46 = load ptr, ptr %5, align 8, !dbg !429
  %47 = getelementptr inbounds %struct.ck_epoch_record, ptr %46, i32 0, i32 0, !dbg !430
  call void @ck_stack_push_upmc(ptr noundef %45, ptr noundef %47), !dbg !431
  ret void, !dbg !432
}

; Function Attrs: nounwind
declare ptr @__memset_chk(ptr noundef, i32 noundef, i64 noundef, i64 noundef) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.objectsize.i64.p0(ptr, i1 immarg, i1 immarg, i1 immarg) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_stack_push_upmc(ptr noundef %0, ptr noundef %1) #0 !dbg !433 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load ptr, ptr %3, align 8, !dbg !442
  %7 = getelementptr inbounds %struct.ck_stack, ptr %6, i32 0, i32 0, !dbg !442
  %8 = call ptr @ck_pr_md_load_ptr(ptr noundef %7), !dbg !442
  store ptr %8, ptr %5, align 8, !dbg !443
  %9 = load ptr, ptr %5, align 8, !dbg !444
  %10 = load ptr, ptr %4, align 8, !dbg !445
  %11 = getelementptr inbounds %struct.ck_stack_entry, ptr %10, i32 0, i32 0, !dbg !446
  store ptr %9, ptr %11, align 8, !dbg !447
  call void @ck_pr_fence_store(), !dbg !448
  br label %12, !dbg !449

12:                                               ; preds = %20, %2
  %13 = load ptr, ptr %3, align 8, !dbg !450
  %14 = getelementptr inbounds %struct.ck_stack, ptr %13, i32 0, i32 0, !dbg !451
  %15 = load ptr, ptr %5, align 8, !dbg !452
  %16 = load ptr, ptr %4, align 8, !dbg !453
  %17 = call zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %14, ptr noundef %15, ptr noundef %16, ptr noundef %5), !dbg !454
  %18 = zext i1 %17 to i32, !dbg !454
  %19 = icmp eq i32 %18, 0, !dbg !455
  br i1 %19, label %20, label %24, !dbg !449

20:                                               ; preds = %12
  %21 = load ptr, ptr %5, align 8, !dbg !456
  %22 = load ptr, ptr %4, align 8, !dbg !458
  %23 = getelementptr inbounds %struct.ck_stack_entry, ptr %22, i32 0, i32 0, !dbg !459
  store ptr %21, ptr %23, align 8, !dbg !460
  call void @ck_pr_fence_store(), !dbg !461
  br label %12, !dbg !449, !llvm.loop !462

24:                                               ; preds = %12
  ret void, !dbg !464
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @ck_epoch_unregister(ptr noundef %0) #0 !dbg !465 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8, !dbg !472
  %6 = getelementptr inbounds %struct.ck_epoch_record, ptr %5, i32 0, i32 1, !dbg !473
  %7 = load ptr, ptr %6, align 8, !dbg !473
  store ptr %7, ptr %3, align 8, !dbg !471
  %8 = load ptr, ptr %2, align 8, !dbg !476
  %9 = getelementptr inbounds %struct.ck_epoch_record, ptr %8, i32 0, i32 4, !dbg !477
  store i32 0, ptr %9, align 8, !dbg !478
  %10 = load ptr, ptr %2, align 8, !dbg !479
  %11 = getelementptr inbounds %struct.ck_epoch_record, ptr %10, i32 0, i32 3, !dbg !480
  store i32 0, ptr %11, align 4, !dbg !481
  %12 = load ptr, ptr %2, align 8, !dbg !482
  %13 = getelementptr inbounds %struct.ck_epoch_record, ptr %12, i32 0, i32 9, !dbg !483
  store i32 0, ptr %13, align 8, !dbg !484
  %14 = load ptr, ptr %2, align 8, !dbg !485
  %15 = getelementptr inbounds %struct.ck_epoch_record, ptr %14, i32 0, i32 8, !dbg !486
  store i32 0, ptr %15, align 4, !dbg !487
  %16 = load ptr, ptr %2, align 8, !dbg !488
  %17 = getelementptr inbounds %struct.ck_epoch_record, ptr %16, i32 0, i32 7, !dbg !489
  store i32 0, ptr %17, align 16, !dbg !490
  %18 = load ptr, ptr %2, align 8, !dbg !491
  %19 = getelementptr inbounds %struct.ck_epoch_record, ptr %18, i32 0, i32 6, !dbg !491
  %20 = load ptr, ptr %2, align 8, !dbg !491
  %21 = getelementptr inbounds %struct.ck_epoch_record, ptr %20, i32 0, i32 6, !dbg !491
  %22 = call i64 @llvm.objectsize.i64.p0(ptr %21, i1 false, i1 true, i1 false), !dbg !491
  %23 = call ptr @__memset_chk(ptr noundef %19, i32 noundef 0, i64 noundef 16, i64 noundef %22) #5, !dbg !491
  store i64 0, ptr %4, align 8, !dbg !492
  br label %24, !dbg !494

24:                                               ; preds = %32, %1
  %25 = load i64, ptr %4, align 8, !dbg !495
  %26 = icmp ult i64 %25, 4, !dbg !497
  br i1 %26, label %27, label %35, !dbg !498

27:                                               ; preds = %24
  %28 = load ptr, ptr %2, align 8, !dbg !499
  %29 = getelementptr inbounds %struct.ck_epoch_record, ptr %28, i32 0, i32 11, !dbg !500
  %30 = load i64, ptr %4, align 8, !dbg !501
  %31 = getelementptr inbounds [4 x %struct.ck_stack], ptr %29, i64 0, i64 %30, !dbg !499
  call void @ck_stack_init(ptr noundef %31), !dbg !502
  br label %32, !dbg !502

32:                                               ; preds = %27
  %33 = load i64, ptr %4, align 8, !dbg !503
  %34 = add i64 %33, 1, !dbg !503
  store i64 %34, ptr %4, align 8, !dbg !503
  br label %24, !dbg !504, !llvm.loop !505

35:                                               ; preds = %24
  %36 = load ptr, ptr %2, align 8, !dbg !507
  %37 = getelementptr inbounds %struct.ck_epoch_record, ptr %36, i32 0, i32 10, !dbg !507
  call void @ck_pr_md_store_ptr(ptr noundef %37, ptr noundef null), !dbg !507
  call void @ck_pr_fence_store(), !dbg !508
  %38 = load ptr, ptr %2, align 8, !dbg !509
  %39 = getelementptr inbounds %struct.ck_epoch_record, ptr %38, i32 0, i32 2, !dbg !509
  call void @ck_pr_md_store_uint(ptr noundef %39, i32 noundef 1), !dbg !509
  %40 = load ptr, ptr %3, align 8, !dbg !510
  %41 = getelementptr inbounds %struct.ck_epoch, ptr %40, i32 0, i32 1, !dbg !511
  call void @ck_pr_inc_uint(ptr noundef %41), !dbg !512
  ret void, !dbg !513
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_inc_uint(ptr noundef %0) #0 !dbg !514 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !516
  %5 = call i32 asm sideeffect "1:;lwarx $0, 0, $1;addic $0, $0, 1;stwcx. $0, 0, $1;bne-  1b;", "=&r,r,~{memory},~{cc}"(ptr %4) #5, !dbg !516, !srcloc !518
  store i32 %5, ptr %3, align 4, !dbg !516
  ret void, !dbg !516
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @ck_epoch_reclaim(ptr noundef %0) #0 !dbg !519 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  store i32 0, ptr %3, align 4, !dbg !524
  br label %4, !dbg !526

4:                                                ; preds = %11, %1
  %5 = load i32, ptr %3, align 4, !dbg !527
  %6 = icmp ult i32 %5, 4, !dbg !529
  br i1 %6, label %7, label %14, !dbg !530

7:                                                ; preds = %4
  %8 = load ptr, ptr %2, align 8, !dbg !531
  %9 = load i32, ptr %3, align 4, !dbg !532
  %10 = call i32 @ck_epoch_dispatch(ptr noundef %8, i32 noundef %9, ptr noundef null), !dbg !533
  br label %11, !dbg !533

11:                                               ; preds = %7
  %12 = load i32, ptr %3, align 4, !dbg !534
  %13 = add i32 %12, 1, !dbg !534
  store i32 %13, ptr %3, align 4, !dbg !534
  br label %4, !dbg !535, !llvm.loop !536

14:                                               ; preds = %4
  ret void, !dbg !538
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_epoch_dispatch(ptr noundef %0, i32 noundef %1, ptr noundef %2) #0 !dbg !539 {
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store i32 %1, ptr %5, align 4
  store ptr %2, ptr %6, align 8
  %15 = load i32, ptr %5, align 4, !dbg !551
  %16 = and i32 %15, 3, !dbg !552
  store i32 %16, ptr %7, align 4, !dbg !550
  store i32 0, ptr %13, align 4, !dbg !564
  %17 = load ptr, ptr %4, align 8, !dbg !565
  %18 = getelementptr inbounds %struct.ck_epoch_record, ptr %17, i32 0, i32 11, !dbg !566
  %19 = load i32, ptr %7, align 4, !dbg !567
  %20 = zext i32 %19 to i64, !dbg !565
  %21 = getelementptr inbounds [4 x %struct.ck_stack], ptr %18, i64 0, i64 %20, !dbg !565
  %22 = call ptr @ck_stack_batch_pop_upmc(ptr noundef %21), !dbg !568
  store ptr %22, ptr %8, align 8, !dbg !569
  %23 = load ptr, ptr %8, align 8, !dbg !570
  store ptr %23, ptr %10, align 8, !dbg !572
  br label %24, !dbg !573

24:                                               ; preds = %47, %3
  %25 = load ptr, ptr %10, align 8, !dbg !574
  %26 = icmp ne ptr %25, null, !dbg !576
  br i1 %26, label %27, label %49, !dbg !577

27:                                               ; preds = %24
  %28 = load ptr, ptr %10, align 8, !dbg !581
  %29 = call ptr @ck_epoch_entry_container(ptr noundef %28), !dbg !582
  store ptr %29, ptr %14, align 8, !dbg !580
  %30 = load ptr, ptr %10, align 8, !dbg !583
  %31 = getelementptr inbounds %struct.ck_stack_entry, ptr %30, i32 0, i32 0, !dbg !583
  %32 = load ptr, ptr %31, align 8, !dbg !583
  store ptr %32, ptr %9, align 8, !dbg !584
  %33 = load ptr, ptr %6, align 8, !dbg !585
  %34 = icmp ne ptr %33, null, !dbg !587
  br i1 %34, label %35, label %39, !dbg !588

35:                                               ; preds = %27
  %36 = load ptr, ptr %6, align 8, !dbg !589
  %37 = load ptr, ptr %14, align 8, !dbg !590
  %38 = getelementptr inbounds %struct.ck_epoch_entry, ptr %37, i32 0, i32 1, !dbg !591
  call void @ck_stack_push_spnc(ptr noundef %36, ptr noundef %38), !dbg !592
  br label %44, !dbg !592

39:                                               ; preds = %27
  %40 = load ptr, ptr %14, align 8, !dbg !593
  %41 = getelementptr inbounds %struct.ck_epoch_entry, ptr %40, i32 0, i32 0, !dbg !594
  %42 = load ptr, ptr %41, align 8, !dbg !594
  %43 = load ptr, ptr %14, align 8, !dbg !595
  call void %42(ptr noundef %43), !dbg !593
  br label %44

44:                                               ; preds = %39, %35
  %45 = load i32, ptr %13, align 4, !dbg !596
  %46 = add i32 %45, 1, !dbg !596
  store i32 %46, ptr %13, align 4, !dbg !596
  br label %47, !dbg !597

47:                                               ; preds = %44
  %48 = load ptr, ptr %9, align 8, !dbg !598
  store ptr %48, ptr %10, align 8, !dbg !599
  br label %24, !dbg !600, !llvm.loop !601

49:                                               ; preds = %24
  %50 = load ptr, ptr %4, align 8, !dbg !603
  %51 = getelementptr inbounds %struct.ck_epoch_record, ptr %50, i32 0, i32 8, !dbg !603
  %52 = call i32 @ck_pr_md_load_uint(ptr noundef %51), !dbg !603
  store i32 %52, ptr %12, align 4, !dbg !604
  %53 = load ptr, ptr %4, align 8, !dbg !605
  %54 = getelementptr inbounds %struct.ck_epoch_record, ptr %53, i32 0, i32 7, !dbg !605
  %55 = call i32 @ck_pr_md_load_uint(ptr noundef %54), !dbg !605
  store i32 %55, ptr %11, align 4, !dbg !606
  %56 = load i32, ptr %11, align 4, !dbg !607
  %57 = load i32, ptr %12, align 4, !dbg !609
  %58 = icmp ugt i32 %56, %57, !dbg !610
  br i1 %58, label %59, label %63, !dbg !611

59:                                               ; preds = %49
  %60 = load ptr, ptr %4, align 8, !dbg !612
  %61 = getelementptr inbounds %struct.ck_epoch_record, ptr %60, i32 0, i32 8, !dbg !612
  %62 = load i32, ptr %12, align 4, !dbg !612
  call void @ck_pr_md_store_uint(ptr noundef %61, i32 noundef %62), !dbg !612
  br label %63, !dbg !612

63:                                               ; preds = %59, %49
  %64 = load i32, ptr %13, align 4, !dbg !613
  %65 = icmp ugt i32 %64, 0, !dbg !615
  br i1 %65, label %66, label %73, !dbg !616

66:                                               ; preds = %63
  %67 = load ptr, ptr %4, align 8, !dbg !617
  %68 = getelementptr inbounds %struct.ck_epoch_record, ptr %67, i32 0, i32 9, !dbg !619
  %69 = load i32, ptr %13, align 4, !dbg !620
  call void @ck_pr_add_uint(ptr noundef %68, i32 noundef %69), !dbg !621
  %70 = load ptr, ptr %4, align 8, !dbg !622
  %71 = getelementptr inbounds %struct.ck_epoch_record, ptr %70, i32 0, i32 7, !dbg !623
  %72 = load i32, ptr %13, align 4, !dbg !624
  call void @ck_pr_sub_uint(ptr noundef %71, i32 noundef %72), !dbg !625
  br label %73, !dbg !626

73:                                               ; preds = %66, %63
  %74 = load i32, ptr %13, align 4, !dbg !627
  ret i32 %74, !dbg !628
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @ck_epoch_synchronize_wait(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 !dbg !629 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca ptr, align 8
  %12 = alloca ptr, align 8
  %13 = alloca ptr, align 8
  %14 = alloca ptr, align 8
  %15 = alloca ptr, align 8
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  %19 = alloca i32, align 4
  %20 = alloca i8, align 1
  %21 = alloca i8, align 1
  %22 = alloca i32, align 4
  store ptr %0, ptr %12, align 8
  store ptr %1, ptr %13, align 8
  store ptr %2, ptr %14, align 8
  call void @ck_pr_fence_memory(), !dbg !655
  %23 = load ptr, ptr %12, align 8, !dbg !656
  %24 = getelementptr inbounds %struct.ck_epoch, ptr %23, i32 0, i32 0, !dbg !656
  %25 = call i32 @ck_pr_md_load_uint(ptr noundef %24), !dbg !656
  store i32 %25, ptr %17, align 4, !dbg !657
  store i32 %25, ptr %16, align 4, !dbg !658
  %26 = load i32, ptr %17, align 4, !dbg !659
  %27 = add i32 %26, 3, !dbg !660
  store i32 %27, ptr %18, align 4, !dbg !661
  store i32 0, ptr %19, align 4, !dbg !662
  store ptr null, ptr %15, align 8, !dbg !664
  br label %28, !dbg !665

28:                                               ; preds = %104, %3
  %29 = load i32, ptr %19, align 4, !dbg !666
  %30 = icmp ult i32 %29, 2, !dbg !668
  br i1 %30, label %31, label %107, !dbg !669

31:                                               ; preds = %28
  br label %32, !dbg !673

32:                                               ; preds = %84, %58, %31
  %33 = load ptr, ptr %12, align 8, !dbg !674
  %34 = load ptr, ptr %15, align 8, !dbg !675
  %35 = load i32, ptr %16, align 4, !dbg !676
  %36 = call ptr @ck_epoch_scan(ptr noundef %33, ptr noundef %34, i32 noundef %35, ptr noundef %20), !dbg !677
  store ptr %36, ptr %15, align 8, !dbg !678
  %37 = load ptr, ptr %15, align 8, !dbg !679
  %38 = icmp ne ptr %37, null, !dbg !680
  br i1 %38, label %39, label %85, !dbg !673

39:                                               ; preds = %32
  call void @ck_pr_stall(), !dbg !684
  %40 = load ptr, ptr %12, align 8, !dbg !685
  %41 = getelementptr inbounds %struct.ck_epoch, ptr %40, i32 0, i32 0, !dbg !685
  %42 = call i32 @ck_pr_md_load_uint(ptr noundef %41), !dbg !685
  store i32 %42, ptr %22, align 4, !dbg !686
  %43 = load i32, ptr %22, align 4, !dbg !687
  %44 = load i32, ptr %16, align 4, !dbg !689
  %45 = icmp eq i32 %43, %44, !dbg !690
  br i1 %45, label %46, label %59, !dbg !691

46:                                               ; preds = %39
  %47 = load ptr, ptr %12, align 8, !dbg !692
  %48 = load ptr, ptr %15, align 8, !dbg !694
  %49 = load ptr, ptr %13, align 8, !dbg !695
  %50 = load ptr, ptr %14, align 8, !dbg !696
  store ptr %47, ptr %4, align 8
  store ptr %48, ptr %5, align 8
  store ptr %49, ptr %6, align 8
  store ptr %50, ptr %7, align 8
  %51 = load ptr, ptr %6, align 8, !dbg !709
  %52 = icmp ne ptr %51, null, !dbg !711
  br i1 %52, label %53, label %58, !dbg !712

53:                                               ; preds = %46
  %54 = load ptr, ptr %6, align 8, !dbg !713
  %55 = load ptr, ptr %4, align 8, !dbg !714
  %56 = load ptr, ptr %5, align 8, !dbg !715
  %57 = load ptr, ptr %7, align 8, !dbg !716
  call void %54(ptr noundef %55, ptr noundef %56, ptr noundef %57) #5, !dbg !713
  br label %58, !dbg !713

58:                                               ; preds = %46, %53
  br label %32, !dbg !717, !llvm.loop !718

59:                                               ; preds = %39
  %60 = load i32, ptr %22, align 4, !dbg !720
  store i32 %60, ptr %16, align 4, !dbg !721
  %61 = load i32, ptr %18, align 4, !dbg !722
  %62 = load i32, ptr %17, align 4, !dbg !724
  %63 = icmp ugt i32 %61, %62, !dbg !725
  %64 = zext i1 %63 to i32, !dbg !725
  %65 = load i32, ptr %16, align 4, !dbg !726
  %66 = load i32, ptr %18, align 4, !dbg !727
  %67 = icmp uge i32 %65, %66, !dbg !728
  %68 = zext i1 %67 to i32, !dbg !728
  %69 = and i32 %64, %68, !dbg !729
  %70 = icmp ne i32 %69, 0, !dbg !729
  br i1 %70, label %71, label %72, !dbg !730

71:                                               ; preds = %59
  br label %108, !dbg !731

72:                                               ; preds = %59
  %73 = load ptr, ptr %12, align 8, !dbg !732
  %74 = load ptr, ptr %15, align 8, !dbg !733
  %75 = load ptr, ptr %13, align 8, !dbg !734
  %76 = load ptr, ptr %14, align 8, !dbg !735
  store ptr %73, ptr %8, align 8
  store ptr %74, ptr %9, align 8
  store ptr %75, ptr %10, align 8
  store ptr %76, ptr %11, align 8
  %77 = load ptr, ptr %10, align 8, !dbg !741
  %78 = icmp ne ptr %77, null, !dbg !742
  br i1 %78, label %79, label %84, !dbg !743

79:                                               ; preds = %72
  %80 = load ptr, ptr %10, align 8, !dbg !744
  %81 = load ptr, ptr %8, align 8, !dbg !745
  %82 = load ptr, ptr %9, align 8, !dbg !746
  %83 = load ptr, ptr %11, align 8, !dbg !747
  call void %80(ptr noundef %81, ptr noundef %82, ptr noundef %83) #5, !dbg !744
  br label %84, !dbg !744

84:                                               ; preds = %72, %79
  store ptr null, ptr %15, align 8, !dbg !748
  br label %32, !dbg !673, !llvm.loop !718

85:                                               ; preds = %32
  %86 = load i8, ptr %20, align 1, !dbg !749
  %87 = trunc i8 %86 to i1, !dbg !749
  %88 = zext i1 %87 to i32, !dbg !749
  %89 = icmp eq i32 %88, 0, !dbg !751
  br i1 %89, label %90, label %91, !dbg !752

90:                                               ; preds = %85
  br label %107, !dbg !753

91:                                               ; preds = %85
  %92 = load ptr, ptr %12, align 8, !dbg !754
  %93 = getelementptr inbounds %struct.ck_epoch, ptr %92, i32 0, i32 0, !dbg !755
  %94 = load i32, ptr %16, align 4, !dbg !756
  %95 = load i32, ptr %16, align 4, !dbg !757
  %96 = add i32 %95, 1, !dbg !758
  %97 = call zeroext i1 @ck_pr_cas_uint_value(ptr noundef %93, i32 noundef %94, i32 noundef %96, ptr noundef %16), !dbg !759
  %98 = zext i1 %97 to i8, !dbg !760
  store i8 %98, ptr %21, align 1, !dbg !760
  call void @ck_pr_fence_atomic_load(), !dbg !761
  %99 = load i32, ptr %16, align 4, !dbg !762
  %100 = load i8, ptr %21, align 1, !dbg !763
  %101 = trunc i8 %100 to i1, !dbg !763
  %102 = zext i1 %101 to i32, !dbg !763
  %103 = add i32 %99, %102, !dbg !764
  store i32 %103, ptr %16, align 4, !dbg !765
  br label %104, !dbg !766

104:                                              ; preds = %91
  store ptr null, ptr %15, align 8, !dbg !767
  %105 = load i32, ptr %19, align 4, !dbg !768
  %106 = add i32 %105, 1, !dbg !768
  store i32 %106, ptr %19, align 4, !dbg !768
  br label %28, !dbg !769, !llvm.loop !770

107:                                              ; preds = %90, %28
  br label %108, !dbg !771

108:                                              ; preds = %107, %71
  call void @ck_pr_fence_memory(), !dbg !774
  ret void, !dbg !775
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_memory() #0 !dbg !776 {
  call void @ck_pr_fence_strict_memory(), !dbg !777
  ret void, !dbg !777
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_epoch_scan(ptr noundef %0, ptr noundef %1, i32 noundef %2, ptr noundef %3) #0 !dbg !778 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  store ptr %0, ptr %6, align 8
  store ptr %1, ptr %7, align 8
  store i32 %2, ptr %8, align 4
  store ptr %3, ptr %9, align 8
  %13 = load ptr, ptr %7, align 8, !dbg !792
  %14 = icmp eq ptr %13, null, !dbg !794
  br i1 %14, label %15, label %21, !dbg !795

15:                                               ; preds = %4
  %16 = load ptr, ptr %6, align 8, !dbg !796
  %17 = getelementptr inbounds %struct.ck_epoch, ptr %16, i32 0, i32 2, !dbg !796
  %18 = getelementptr inbounds %struct.ck_stack, ptr %17, i32 0, i32 0, !dbg !796
  %19 = load ptr, ptr %18, align 8, !dbg !796
  store ptr %19, ptr %10, align 8, !dbg !798
  %20 = load ptr, ptr %9, align 8, !dbg !799
  store i8 0, ptr %20, align 1, !dbg !800
  br label %25, !dbg !801

21:                                               ; preds = %4
  %22 = load ptr, ptr %7, align 8, !dbg !802
  %23 = getelementptr inbounds %struct.ck_epoch_record, ptr %22, i32 0, i32 0, !dbg !804
  store ptr %23, ptr %10, align 8, !dbg !805
  %24 = load ptr, ptr %9, align 8, !dbg !806
  store i8 1, ptr %24, align 1, !dbg !807
  br label %25

25:                                               ; preds = %21, %15
  br label %26, !dbg !808

26:                                               ; preds = %64, %38, %25
  %27 = load ptr, ptr %10, align 8, !dbg !809
  %28 = icmp ne ptr %27, null, !dbg !810
  br i1 %28, label %29, label %68, !dbg !808

29:                                               ; preds = %26
  %30 = load ptr, ptr %10, align 8, !dbg !816
  %31 = call ptr @ck_epoch_record_container(ptr noundef %30), !dbg !817
  store ptr %31, ptr %7, align 8, !dbg !818
  %32 = load ptr, ptr %7, align 8, !dbg !819
  %33 = getelementptr inbounds %struct.ck_epoch_record, ptr %32, i32 0, i32 2, !dbg !819
  %34 = call i32 @ck_pr_md_load_uint(ptr noundef %33), !dbg !819
  store i32 %34, ptr %11, align 4, !dbg !820
  %35 = load i32, ptr %11, align 4, !dbg !821
  %36 = and i32 %35, 1, !dbg !823
  %37 = icmp ne i32 %36, 0, !dbg !823
  br i1 %37, label %38, label %42, !dbg !824

38:                                               ; preds = %29
  %39 = load ptr, ptr %10, align 8, !dbg !825
  %40 = getelementptr inbounds %struct.ck_stack_entry, ptr %39, i32 0, i32 0, !dbg !825
  %41 = load ptr, ptr %40, align 8, !dbg !825
  store ptr %41, ptr %10, align 8, !dbg !827
  br label %26, !dbg !828, !llvm.loop !829

42:                                               ; preds = %29
  %43 = load ptr, ptr %7, align 8, !dbg !831
  %44 = getelementptr inbounds %struct.ck_epoch_record, ptr %43, i32 0, i32 4, !dbg !831
  %45 = call i32 @ck_pr_md_load_uint(ptr noundef %44), !dbg !831
  store i32 %45, ptr %12, align 4, !dbg !832
  %46 = load i32, ptr %12, align 4, !dbg !833
  %47 = load ptr, ptr %9, align 8, !dbg !834
  %48 = load i8, ptr %47, align 1, !dbg !835
  %49 = trunc i8 %48 to i1, !dbg !835
  %50 = zext i1 %49 to i32, !dbg !835
  %51 = or i32 %50, %46, !dbg !835
  %52 = icmp ne i32 %51, 0, !dbg !835
  %53 = zext i1 %52 to i8, !dbg !835
  store i8 %53, ptr %47, align 1, !dbg !835
  %54 = load i32, ptr %12, align 4, !dbg !836
  %55 = icmp ne i32 %54, 0, !dbg !838
  br i1 %55, label %56, label %64, !dbg !839

56:                                               ; preds = %42
  %57 = load ptr, ptr %7, align 8, !dbg !840
  %58 = getelementptr inbounds %struct.ck_epoch_record, ptr %57, i32 0, i32 3, !dbg !840
  %59 = call i32 @ck_pr_md_load_uint(ptr noundef %58), !dbg !840
  %60 = load i32, ptr %8, align 4, !dbg !841
  %61 = icmp ne i32 %59, %60, !dbg !842
  br i1 %61, label %62, label %64, !dbg !843

62:                                               ; preds = %56
  %63 = load ptr, ptr %7, align 8, !dbg !844
  store ptr %63, ptr %5, align 8, !dbg !845
  br label %69, !dbg !845

64:                                               ; preds = %56, %42
  %65 = load ptr, ptr %10, align 8, !dbg !846
  %66 = getelementptr inbounds %struct.ck_stack_entry, ptr %65, i32 0, i32 0, !dbg !846
  %67 = load ptr, ptr %66, align 8, !dbg !846
  store ptr %67, ptr %10, align 8, !dbg !847
  br label %26, !dbg !808, !llvm.loop !829

68:                                               ; preds = %26
  store ptr null, ptr %5, align 8, !dbg !848
  br label %69, !dbg !848

69:                                               ; preds = %68, %62
  %70 = load ptr, ptr %5, align 8, !dbg !849
  ret ptr %70, !dbg !849
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_stall() #0 !dbg !850 {
  call void asm sideeffect "or 1, 1, 1;or 2, 2, 2;", "~{memory}"() #5, !dbg !851, !srcloc !852
  ret void, !dbg !853
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_pr_cas_uint_value(ptr noundef %0, i32 noundef %1, i32 noundef %2, ptr noundef %3) #0 !dbg !854 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store i32 %1, ptr %6, align 4
  store i32 %2, ptr %7, align 4
  store ptr %3, ptr %8, align 8
  %10 = load ptr, ptr %5, align 8, !dbg !858
  %11 = load i32, ptr %7, align 4, !dbg !858
  %12 = load i32, ptr %6, align 4, !dbg !858
  %13 = call i32 asm sideeffect "1:;lwarx $0, 0, $1;cmpw  0, $0, $3;bne-  2f;stwcx. $2, 0, $1;bne-  1b;2:", "=&r,r,r,r,~{memory},~{cc}"(ptr %10, i32 %11, i32 %12) #5, !dbg !858, !srcloc !863
  store i32 %13, ptr %9, align 4, !dbg !858
  %14 = load i32, ptr %9, align 4, !dbg !858
  %15 = load ptr, ptr %8, align 8, !dbg !858
  store i32 %14, ptr %15, align 4, !dbg !858
  %16 = load i32, ptr %9, align 4, !dbg !858
  %17 = load i32, ptr %6, align 4, !dbg !858
  %18 = icmp eq i32 %16, %17, !dbg !858
  ret i1 %18, !dbg !858
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_atomic_load() #0 !dbg !864 {
  call void @ck_pr_fence_strict_atomic_load(), !dbg !865
  ret void, !dbg !865
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @ck_epoch_synchronize(ptr noundef %0) #0 !dbg !866 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8, !dbg !869
  %4 = getelementptr inbounds %struct.ck_epoch_record, ptr %3, i32 0, i32 1, !dbg !870
  %5 = load ptr, ptr %4, align 8, !dbg !870
  call void @ck_epoch_synchronize_wait(ptr noundef %5, ptr noundef null, ptr noundef null), !dbg !871
  ret void, !dbg !872
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @ck_epoch_barrier(ptr noundef %0) #0 !dbg !873 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8, !dbg !876
  call void @ck_epoch_synchronize(ptr noundef %3), !dbg !877
  %4 = load ptr, ptr %2, align 8, !dbg !878
  call void @ck_epoch_reclaim(ptr noundef %4), !dbg !879
  ret void, !dbg !880
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @ck_epoch_barrier_wait(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 !dbg !881 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store ptr %2, ptr %6, align 8
  %7 = load ptr, ptr %4, align 8, !dbg !890
  %8 = getelementptr inbounds %struct.ck_epoch_record, ptr %7, i32 0, i32 1, !dbg !891
  %9 = load ptr, ptr %8, align 8, !dbg !891
  %10 = load ptr, ptr %5, align 8, !dbg !892
  %11 = load ptr, ptr %6, align 8, !dbg !893
  call void @ck_epoch_synchronize_wait(ptr noundef %9, ptr noundef %10, ptr noundef %11), !dbg !894
  %12 = load ptr, ptr %4, align 8, !dbg !895
  call void @ck_epoch_reclaim(ptr noundef %12), !dbg !896
  ret void, !dbg !897
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define zeroext i1 @ck_epoch_poll_deferred(ptr noundef %0, ptr noundef %1) #0 !dbg !898 {
  %3 = alloca i1, align 1
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i8, align 1
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store ptr null, ptr %8, align 8, !dbg !910
  %11 = load ptr, ptr %4, align 8, !dbg !913
  %12 = getelementptr inbounds %struct.ck_epoch_record, ptr %11, i32 0, i32 1, !dbg !914
  %13 = load ptr, ptr %12, align 8, !dbg !914
  store ptr %13, ptr %9, align 8, !dbg !912
  %14 = load ptr, ptr %9, align 8, !dbg !917
  %15 = getelementptr inbounds %struct.ck_epoch, ptr %14, i32 0, i32 0, !dbg !917
  %16 = call i32 @ck_pr_md_load_uint(ptr noundef %15), !dbg !917
  store i32 %16, ptr %7, align 4, !dbg !918
  call void @ck_pr_fence_memory(), !dbg !919
  %17 = load ptr, ptr %4, align 8, !dbg !920
  %18 = load i32, ptr %7, align 4, !dbg !921
  %19 = sub i32 %18, 2, !dbg !922
  %20 = load ptr, ptr %5, align 8, !dbg !923
  %21 = call i32 @ck_epoch_dispatch(ptr noundef %17, i32 noundef %19, ptr noundef %20), !dbg !924
  store i32 %21, ptr %10, align 4, !dbg !925
  %22 = load ptr, ptr %9, align 8, !dbg !926
  %23 = load ptr, ptr %8, align 8, !dbg !927
  %24 = load i32, ptr %7, align 4, !dbg !928
  %25 = call ptr @ck_epoch_scan(ptr noundef %22, ptr noundef %23, i32 noundef %24, ptr noundef %6), !dbg !929
  store ptr %25, ptr %8, align 8, !dbg !930
  %26 = load ptr, ptr %8, align 8, !dbg !931
  %27 = icmp ne ptr %26, null, !dbg !933
  br i1 %27, label %28, label %31, !dbg !934

28:                                               ; preds = %2
  %29 = load i32, ptr %10, align 4, !dbg !935
  %30 = icmp ugt i32 %29, 0, !dbg !936
  store i1 %30, ptr %3, align 1, !dbg !937
  br label %64, !dbg !937

31:                                               ; preds = %2
  %32 = load i8, ptr %6, align 1, !dbg !938
  %33 = trunc i8 %32 to i1, !dbg !938
  %34 = zext i1 %33 to i32, !dbg !938
  %35 = icmp eq i32 %34, 0, !dbg !940
  br i1 %35, label %36, label %52, !dbg !941

36:                                               ; preds = %31
  %37 = load i32, ptr %7, align 4, !dbg !942
  %38 = load ptr, ptr %4, align 8, !dbg !944
  %39 = getelementptr inbounds %struct.ck_epoch_record, ptr %38, i32 0, i32 3, !dbg !945
  store i32 %37, ptr %39, align 4, !dbg !946
  store i32 0, ptr %7, align 4, !dbg !947
  br label %40, !dbg !949

40:                                               ; preds = %48, %36
  %41 = load i32, ptr %7, align 4, !dbg !950
  %42 = icmp ult i32 %41, 4, !dbg !952
  br i1 %42, label %43, label %51, !dbg !953

43:                                               ; preds = %40
  %44 = load ptr, ptr %4, align 8, !dbg !954
  %45 = load i32, ptr %7, align 4, !dbg !955
  %46 = load ptr, ptr %5, align 8, !dbg !956
  %47 = call i32 @ck_epoch_dispatch(ptr noundef %44, i32 noundef %45, ptr noundef %46), !dbg !957
  br label %48, !dbg !957

48:                                               ; preds = %43
  %49 = load i32, ptr %7, align 4, !dbg !958
  %50 = add i32 %49, 1, !dbg !958
  store i32 %50, ptr %7, align 4, !dbg !958
  br label %40, !dbg !959, !llvm.loop !960

51:                                               ; preds = %40
  store i1 true, ptr %3, align 1, !dbg !962
  br label %64, !dbg !962

52:                                               ; preds = %31
  %53 = load ptr, ptr %9, align 8, !dbg !963
  %54 = getelementptr inbounds %struct.ck_epoch, ptr %53, i32 0, i32 0, !dbg !964
  %55 = load i32, ptr %7, align 4, !dbg !965
  %56 = load i32, ptr %7, align 4, !dbg !966
  %57 = add i32 %56, 1, !dbg !967
  %58 = call zeroext i1 @ck_pr_cas_uint(ptr noundef %54, i32 noundef %55, i32 noundef %57), !dbg !968
  %59 = load ptr, ptr %4, align 8, !dbg !969
  %60 = load i32, ptr %7, align 4, !dbg !970
  %61 = sub i32 %60, 1, !dbg !971
  %62 = load ptr, ptr %5, align 8, !dbg !972
  %63 = call i32 @ck_epoch_dispatch(ptr noundef %59, i32 noundef %61, ptr noundef %62), !dbg !973
  store i1 true, ptr %3, align 1, !dbg !974
  br label %64, !dbg !974

64:                                               ; preds = %52, %51, %28
  %65 = load i1, ptr %3, align 1, !dbg !975
  ret i1 %65, !dbg !975
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_pr_cas_uint(ptr noundef %0, i32 noundef %1, i32 noundef %2) #0 !dbg !976 {
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store i32 %1, ptr %5, align 4
  store i32 %2, ptr %6, align 4
  %8 = load ptr, ptr %4, align 8, !dbg !980
  %9 = load i32, ptr %6, align 4, !dbg !980
  %10 = load i32, ptr %5, align 4, !dbg !980
  %11 = call i32 asm sideeffect "1:;lwarx $0, 0, $1;cmpw  0, $0, $3;bne-  2f;stwcx. $2, 0, $1;bne-  1b;2:", "=&r,r,r,r,~{memory},~{cc}"(ptr %8, i32 %9, i32 %10) #5, !dbg !980, !srcloc !984
  store i32 %11, ptr %7, align 4, !dbg !980
  %12 = load i32, ptr %7, align 4, !dbg !980
  %13 = load i32, ptr %5, align 4, !dbg !980
  %14 = icmp eq i32 %12, %13, !dbg !980
  ret i1 %14, !dbg !980
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define zeroext i1 @ck_epoch_poll(ptr noundef %0) #0 !dbg !985 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8, !dbg !990
  %4 = call zeroext i1 @ck_epoch_poll_deferred(ptr noundef %3, ptr noundef null), !dbg !991
  ret i1 %4, !dbg !992
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main(i32 noundef %0, ptr noundef %1) #0 !dbg !993 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca [4 x ptr], align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  store ptr %1, ptr %5, align 8
  call void @ck_epoch_init(ptr noundef @stack_epoch), !dbg !1027
  store i32 0, ptr %7, align 4, !dbg !1030
  br label %9, !dbg !1031

9:                                                ; preds = %23, %2
  %10 = load i32, ptr %7, align 4, !dbg !1032
  %11 = icmp slt i32 %10, 4, !dbg !1034
  br i1 %11, label %12, label %26, !dbg !1035

12:                                               ; preds = %9
  %13 = load i32, ptr %7, align 4, !dbg !1036
  %14 = sext i32 %13 to i64, !dbg !1038
  %15 = getelementptr inbounds [4 x %struct.ck_epoch_record], ptr @records, i64 0, i64 %14, !dbg !1038
  call void @ck_epoch_register(ptr noundef @stack_epoch, ptr noundef %15, ptr noundef null), !dbg !1039
  %16 = load i32, ptr %7, align 4, !dbg !1040
  %17 = sext i32 %16 to i64, !dbg !1041
  %18 = getelementptr inbounds [4 x ptr], ptr %6, i64 0, i64 %17, !dbg !1041
  %19 = load i32, ptr %7, align 4, !dbg !1042
  %20 = sext i32 %19 to i64, !dbg !1043
  %21 = getelementptr inbounds [4 x %struct.ck_epoch_record], ptr @records, i64 0, i64 %20, !dbg !1043
  %22 = call i32 @pthread_create(ptr noundef %18, ptr noundef null, ptr noundef @thread, ptr noundef %21), !dbg !1044
  br label %23, !dbg !1045

23:                                               ; preds = %12
  %24 = load i32, ptr %7, align 4, !dbg !1046
  %25 = add nsw i32 %24, 1, !dbg !1046
  store i32 %25, ptr %7, align 4, !dbg !1046
  br label %9, !dbg !1047, !llvm.loop !1048

26:                                               ; preds = %9
  store i32 0, ptr %8, align 4, !dbg !1052
  br label %27, !dbg !1053

27:                                               ; preds = %36, %26
  %28 = load i32, ptr %8, align 4, !dbg !1054
  %29 = icmp slt i32 %28, 4, !dbg !1056
  br i1 %29, label %30, label %39, !dbg !1057

30:                                               ; preds = %27
  %31 = load i32, ptr %8, align 4, !dbg !1058
  %32 = sext i32 %31 to i64, !dbg !1059
  %33 = getelementptr inbounds [4 x ptr], ptr %6, i64 0, i64 %32, !dbg !1059
  %34 = load ptr, ptr %33, align 8, !dbg !1059
  %35 = call i32 @"\01_pthread_join"(ptr noundef %34, ptr noundef null), !dbg !1060
  br label %36, !dbg !1060

36:                                               ; preds = %30
  %37 = load i32, ptr %8, align 4, !dbg !1061
  %38 = add nsw i32 %37, 1, !dbg !1061
  store i32 %38, ptr %8, align 4, !dbg !1061
  br label %27, !dbg !1062, !llvm.loop !1063

39:                                               ; preds = %27
  ret i32 0, !dbg !1065
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @thread(ptr noundef %0) #0 !dbg !1066 {
  %2 = alloca i1, align 1
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  store ptr %0, ptr %9, align 8
  %13 = load ptr, ptr %9, align 8, !dbg !1073
  store ptr %13, ptr %10, align 8, !dbg !1072
  %14 = load ptr, ptr %10, align 8, !dbg !1074
  store ptr %14, ptr %5, align 8
  store ptr null, ptr %6, align 8
  %15 = load ptr, ptr %5, align 8, !dbg !1087
  %16 = getelementptr inbounds %struct.ck_epoch_record, ptr %15, i32 0, i32 1, !dbg !1088
  %17 = load ptr, ptr %16, align 8, !dbg !1088
  store ptr %17, ptr %7, align 8, !dbg !1086
  %18 = load ptr, ptr %5, align 8, !dbg !1089
  %19 = getelementptr inbounds %struct.ck_epoch_record, ptr %18, i32 0, i32 4, !dbg !1091
  %20 = load i32, ptr %19, align 8, !dbg !1091
  %21 = icmp eq i32 %20, 0, !dbg !1092
  br i1 %21, label %22, label %30, !dbg !1093

22:                                               ; preds = %1
  %23 = load ptr, ptr %5, align 8, !dbg !1097
  %24 = getelementptr inbounds %struct.ck_epoch_record, ptr %23, i32 0, i32 4, !dbg !1097
  call void @ck_pr_md_store_uint(ptr noundef %24, i32 noundef 1), !dbg !1097
  call void @ck_pr_fence_memory(), !dbg !1098
  %25 = load ptr, ptr %7, align 8, !dbg !1099
  %26 = call i32 @ck_pr_md_load_uint(ptr noundef %25), !dbg !1099
  store i32 %26, ptr %8, align 4, !dbg !1100
  %27 = load ptr, ptr %5, align 8, !dbg !1101
  %28 = getelementptr inbounds %struct.ck_epoch_record, ptr %27, i32 0, i32 3, !dbg !1101
  %29 = load i32, ptr %8, align 4, !dbg !1101
  call void @ck_pr_md_store_uint(ptr noundef %28, i32 noundef %29), !dbg !1101
  br label %37, !dbg !1102

30:                                               ; preds = %1
  %31 = load ptr, ptr %5, align 8, !dbg !1103
  %32 = getelementptr inbounds %struct.ck_epoch_record, ptr %31, i32 0, i32 4, !dbg !1103
  %33 = load ptr, ptr %5, align 8, !dbg !1103
  %34 = getelementptr inbounds %struct.ck_epoch_record, ptr %33, i32 0, i32 4, !dbg !1103
  %35 = load i32, ptr %34, align 8, !dbg !1103
  %36 = add i32 %35, 1, !dbg !1103
  call void @ck_pr_md_store_uint(ptr noundef %32, i32 noundef %36), !dbg !1103
  br label %37

37:                                               ; preds = %30, %22
  %38 = load ptr, ptr %6, align 8, !dbg !1105
  %39 = icmp ne ptr %38, null, !dbg !1107
  br i1 %39, label %40, label %43, !dbg !1108

40:                                               ; preds = %37
  %41 = load ptr, ptr %5, align 8, !dbg !1109
  %42 = load ptr, ptr %6, align 8, !dbg !1110
  call void @_ck_epoch_addref(ptr noundef %41, ptr noundef %42), !dbg !1111
  br label %43, !dbg !1111

43:                                               ; preds = %37, %40
  %44 = call i32 @ck_pr_md_load_uint(ptr noundef @stack_epoch), !dbg !1114
  store i32 %44, ptr %11, align 4, !dbg !1113
  %45 = load ptr, ptr %10, align 8, !dbg !1117
  %46 = getelementptr inbounds %struct.ck_epoch_record, ptr %45, i32 0, i32 3, !dbg !1117
  %47 = call i32 @ck_pr_md_load_uint(ptr noundef %46), !dbg !1117
  store i32 %47, ptr %12, align 4, !dbg !1116
  %48 = load ptr, ptr %10, align 8, !dbg !1118
  store ptr %48, ptr %3, align 8
  store ptr null, ptr %4, align 8
  call void @ck_pr_fence_release(), !dbg !1127
  %49 = load ptr, ptr %3, align 8, !dbg !1128
  %50 = getelementptr inbounds %struct.ck_epoch_record, ptr %49, i32 0, i32 4, !dbg !1128
  %51 = load ptr, ptr %3, align 8, !dbg !1128
  %52 = getelementptr inbounds %struct.ck_epoch_record, ptr %51, i32 0, i32 4, !dbg !1128
  %53 = load i32, ptr %52, align 8, !dbg !1128
  %54 = sub i32 %53, 1, !dbg !1128
  call void @ck_pr_md_store_uint(ptr noundef %50, i32 noundef %54), !dbg !1128
  %55 = load ptr, ptr %4, align 8, !dbg !1129
  %56 = icmp ne ptr %55, null, !dbg !1131
  br i1 %56, label %57, label %61, !dbg !1132

57:                                               ; preds = %43
  %58 = load ptr, ptr %3, align 8, !dbg !1133
  %59 = load ptr, ptr %4, align 8, !dbg !1134
  %60 = call zeroext i1 @_ck_epoch_delref(ptr noundef %58, ptr noundef %59), !dbg !1135
  store i1 %60, ptr %2, align 1, !dbg !1136
  br label %66, !dbg !1136

61:                                               ; preds = %43
  %62 = load ptr, ptr %3, align 8, !dbg !1137
  %63 = getelementptr inbounds %struct.ck_epoch_record, ptr %62, i32 0, i32 4, !dbg !1138
  %64 = load i32, ptr %63, align 8, !dbg !1138
  %65 = icmp eq i32 %64, 0, !dbg !1139
  store i1 %65, ptr %2, align 1, !dbg !1140
  br label %66, !dbg !1140

66:                                               ; preds = %57, %61
  %67 = load i1, ptr %2, align 1, !dbg !1141
  %68 = load i32, ptr %12, align 4, !dbg !1142
  %69 = icmp eq i32 %68, 1, !dbg !1142
  br i1 %69, label %70, label %73, !dbg !1142

70:                                               ; preds = %66
  %71 = load i32, ptr %11, align 4, !dbg !1142
  %72 = icmp eq i32 %71, 3, !dbg !1142
  br label %73

73:                                               ; preds = %70, %66
  %74 = phi i1 [ false, %66 ], [ %72, %70 ], !dbg !1143
  %75 = xor i1 %74, true, !dbg !1142
  %76 = xor i1 %75, true, !dbg !1142
  %77 = zext i1 %76 to i32, !dbg !1142
  %78 = sext i32 %77 to i64, !dbg !1142
  %79 = icmp ne i64 %78, 0, !dbg !1142
  br i1 %79, label %80, label %82, !dbg !1142

80:                                               ; preds = %73
  call void @__assert_rtn(ptr noundef @__func__.thread, ptr noundef @.str, i32 noundef 37, ptr noundef @.str.1) #6, !dbg !1142
  unreachable, !dbg !1142

81:                                               ; No predecessors!
  br label %83, !dbg !1142

82:                                               ; preds = %73
  br label %83, !dbg !1142

83:                                               ; preds = %82, %81
  %84 = load ptr, ptr %10, align 8, !dbg !1144
  %85 = call zeroext i1 @ck_epoch_poll(ptr noundef %84), !dbg !1145
  ret ptr null, !dbg !1146
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_acqrel() #0 !dbg !1147 {
  call void asm sideeffect "lwsync", "~{memory}"() #5, !dbg !1148, !srcloc !1149
  ret void, !dbg !1148
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_store() #0 !dbg !1150 {
  call void asm sideeffect "lwsync", "~{memory}"() #5, !dbg !1151, !srcloc !1152
  ret void, !dbg !1151
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_load() #0 !dbg !1153 {
  call void asm sideeffect "lwsync", "~{memory}"() #5, !dbg !1154, !srcloc !1155
  ret void, !dbg !1154
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 !dbg !1156 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !1160
  %5 = call ptr asm sideeffect "ld $0, $1", "=r,*m,~{memory}"(ptr elementtype(i64) %4) #5, !dbg !1160, !srcloc !1162
  store ptr %5, ptr %3, align 8, !dbg !1160
  %6 = load ptr, ptr %3, align 8, !dbg !1160
  ret ptr %6, !dbg !1160
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 !dbg !1163 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store ptr %2, ptr %7, align 8
  store ptr %3, ptr %8, align 8
  %10 = load ptr, ptr %5, align 8, !dbg !1176
  %11 = load ptr, ptr %7, align 8, !dbg !1177
  %12 = load ptr, ptr %6, align 8, !dbg !1178
  %13 = call ptr asm sideeffect "1:;ldarx $0, 0, $1;cmpd  0, $0, $3;bne-  2f;stdcx. $2, 0, $1;bne-  1b;2:", "=&r,r,r,r,~{memory},~{cc}"(ptr %10, ptr %11, ptr %12) #5, !dbg !1179, !srcloc !1180
  store ptr %13, ptr %9, align 8, !dbg !1179
  %14 = load ptr, ptr %8, align 8, !dbg !1181
  %15 = load ptr, ptr %9, align 8, !dbg !1182
  call void @ck_pr_md_store_ptr(ptr noundef %14, ptr noundef %15), !dbg !1183
  %16 = load ptr, ptr %9, align 8, !dbg !1184
  %17 = load ptr, ptr %6, align 8, !dbg !1185
  %18 = icmp eq ptr %16, %17, !dbg !1186
  ret i1 %18, !dbg !1187
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_stack_batch_pop_upmc(ptr noundef %0) #0 !dbg !1188 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !1195
  %5 = getelementptr inbounds %struct.ck_stack, ptr %4, i32 0, i32 0, !dbg !1196
  %6 = call ptr @ck_pr_fas_ptr(ptr noundef %5, ptr noundef null), !dbg !1197
  store ptr %6, ptr %3, align 8, !dbg !1198
  call void @ck_pr_fence_load(), !dbg !1199
  %7 = load ptr, ptr %3, align 8, !dbg !1200
  ret ptr %7, !dbg !1201
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_epoch_entry_container(ptr noundef %0) #0 !dbg !1202 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8, !dbg !1206
  %4 = getelementptr inbounds i8, ptr %3, i64 -8, !dbg !1206
  ret ptr %4, !dbg !1206
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_stack_push_spnc(ptr noundef %0, ptr noundef %1) #0 !dbg !1207 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8, !dbg !1212
  %6 = getelementptr inbounds %struct.ck_stack, ptr %5, i32 0, i32 0, !dbg !1213
  %7 = load ptr, ptr %6, align 8, !dbg !1213
  %8 = load ptr, ptr %4, align 8, !dbg !1214
  %9 = getelementptr inbounds %struct.ck_stack_entry, ptr %8, i32 0, i32 0, !dbg !1215
  store ptr %7, ptr %9, align 8, !dbg !1216
  %10 = load ptr, ptr %4, align 8, !dbg !1217
  %11 = load ptr, ptr %3, align 8, !dbg !1218
  %12 = getelementptr inbounds %struct.ck_stack, ptr %11, i32 0, i32 0, !dbg !1219
  store ptr %10, ptr %12, align 8, !dbg !1220
  ret void, !dbg !1221
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_add_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !1222 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %6 = load ptr, ptr %3, align 8, !dbg !1224
  %7 = load i32, ptr %4, align 4, !dbg !1224
  %8 = call i32 asm sideeffect "1:;lwarx $0, 0, $1;add $0, $2, $0;stwcx. $0, 0, $1;bne-  1b;", "=&r,r,r,~{memory},~{cc}"(ptr %6, i32 %7) #5, !dbg !1224, !srcloc !1227
  store i32 %8, ptr %5, align 4, !dbg !1224
  ret void, !dbg !1224
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_sub_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !1228 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %6 = load ptr, ptr %3, align 8, !dbg !1230
  %7 = load i32, ptr %4, align 4, !dbg !1230
  %8 = call i32 asm sideeffect "1:;lwarx $0, 0, $1;subf $0, $2, $0;stwcx. $0, 0, $1;bne-  1b;", "=&r,r,r,~{memory},~{cc}"(ptr %6, i32 %7) #5, !dbg !1230, !srcloc !1233
  store i32 %8, ptr %5, align 4, !dbg !1230
  ret void, !dbg !1230
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_pr_fas_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !1234 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load ptr, ptr %3, align 8, !dbg !1238
  %7 = load ptr, ptr %4, align 8, !dbg !1238
  %8 = call ptr asm sideeffect "1:;ldarx $0, 0, $1;stdcx. $2, 0, $1;bne- 1b;", "=&r,r,r,~{memory},~{cc}"(ptr %6, ptr %7) #5, !dbg !1238, !srcloc !1241
  store ptr %8, ptr %5, align 8, !dbg !1238
  %9 = load ptr, ptr %5, align 8, !dbg !1238
  ret ptr %9, !dbg !1238
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_memory() #0 !dbg !1242 {
  call void asm sideeffect "sync", "~{memory}"() #5, !dbg !1243, !srcloc !1244
  ret void, !dbg !1243
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_atomic_load() #0 !dbg !1245 {
  call void asm sideeffect "sync", "~{memory}"() #5, !dbg !1246, !srcloc !1247
  ret void, !dbg !1246
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_release() #0 !dbg !1248 {
  call void @ck_pr_fence_strict_release(), !dbg !1249
  ret void, !dbg !1249
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_release() #0 !dbg !1250 {
  call void asm sideeffect "lwsync", "~{memory}"() #5, !dbg !1251, !srcloc !1252
  ret void, !dbg !1251
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #4 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #5 = { nounwind }
attributes #6 = { cold noreturn }

!llvm.module.flags = !{!104, !105, !106, !107, !108, !109, !110}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!111}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "stack_epoch", scope: !2, file: !3, line: 23, type: !103, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !11, globals: !83, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "tests/ebr.c", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "97073fc1e306f2d013b171ccf01e7e22")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 138, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "src/ck_epoch.c", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "6acf017f2c970ef5b9eb888b55a36640")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10}
!9 = !DIEnumerator(name: "CK_EPOCH_STATE_USED", value: 0)
!10 = !DIEnumerator(name: "CK_EPOCH_STATE_FREE", value: 1)
!11 = !{!12, !13, !14, !15, !17, !40, !64, !27, !68, !70, !81}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !7)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!18 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_record", file: !19, line: 85, size: 1536, align: 512, elements: !20)
!19 = !DIFile(filename: "include/ck_epoch.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "2210cffd498b468d38353410cd7d3066")
!20 = !{!21, !28, !42, !43, !44, !45, !56, !57, !58, !59, !60}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "record_next", scope: !18, file: !19, line: 86, baseType: !22, size: 64)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_entry_t", file: !23, line: 38, baseType: !24)
!23 = !DIFile(filename: "include/ck_stack.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "19674f5fb31e41969a7583ca1d1160b2")
!24 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack_entry", file: !23, line: 35, size: 64, elements: !25)
!25 = !{!26}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !24, file: !23, line: 36, baseType: !27, size: 64)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "global", scope: !18, file: !19, line: 87, baseType: !29, size: 64, offset: 64)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch", file: !19, line: 102, size: 192, elements: !31)
!31 = !{!32, !33, !34}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "epoch", scope: !30, file: !19, line: 103, baseType: !7, size: 32)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "n_free", scope: !30, file: !19, line: 104, baseType: !7, size: 32, offset: 32)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "records", scope: !30, file: !19, line: 105, baseType: !35, size: 128, offset: 64)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_t", file: !23, line: 44, baseType: !36)
!36 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack", file: !23, line: 40, size: 128, elements: !37)
!37 = !{!38, !39}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !36, file: !23, line: 41, baseType: !27, size: 64)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "generation", scope: !36, file: !23, line: 42, baseType: !40, size: 64, offset: 64)
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!41 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !18, file: !19, line: 88, baseType: !7, size: 32, offset: 128)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "epoch", scope: !18, file: !19, line: 89, baseType: !7, size: 32, offset: 160)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "active", scope: !18, file: !19, line: 90, baseType: !7, size: 32, offset: 192)
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
!59 = !DIDerivedType(tag: DW_TAG_member, name: "ct", scope: !18, file: !19, line: 97, baseType: !13, size: 64, offset: 768)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "pending", scope: !18, file: !19, line: 98, baseType: !61, size: 512, offset: 832)
!61 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 512, elements: !62)
!62 = !{!63}
!63 = !DISubrange(count: 4)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !66, line: 31, baseType: !67)
!66 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/_types/_uint64_t.h", directory: "", checksumkind: CSK_MD5, checksum: "77fc5e91653260959605f129691cf9b1")
!67 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !65)
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !71, size: 64)
!71 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_entry", file: !19, line: 60, size: 128, elements: !72)
!72 = !{!73, !80}
!73 = !DIDerivedType(tag: DW_TAG_member, name: "function", scope: !71, file: !19, line: 61, baseType: !74, size: 64)
!74 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !75, size: 64)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_cb_t", file: !19, line: 54, baseType: !76)
!76 = !DISubroutineType(types: !77)
!77 = !{null, !78}
!78 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !79, size: 64)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_entry_t", file: !19, line: 53, baseType: !71)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "stack_entry", scope: !71, file: !19, line: 62, baseType: !22, size: 64, offset: 64)
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !82, size: 64)
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_record_t", file: !19, line: 100, baseType: !18)
!83 = !{!0, !84, !87, !93, !98}
!84 = !DIGlobalVariableExpression(var: !85, expr: !DIExpression())
!85 = distinct !DIGlobalVariable(name: "records", scope: !2, file: !3, line: 44, type: !86, isLocal: false, isDefinition: true)
!86 = !DICompositeType(tag: DW_TAG_array_type, baseType: !82, size: 6144, align: 512, elements: !62)
!87 = !DIGlobalVariableExpression(var: !88, expr: !DIExpression())
!88 = distinct !DIGlobalVariable(scope: null, file: !3, line: 37, type: !89, isLocal: true, isDefinition: true)
!89 = !DICompositeType(tag: DW_TAG_array_type, baseType: !90, size: 56, elements: !91)
!90 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !41)
!91 = !{!92}
!92 = !DISubrange(count: 7)
!93 = !DIGlobalVariableExpression(var: !94, expr: !DIExpression())
!94 = distinct !DIGlobalVariable(scope: null, file: !3, line: 37, type: !95, isLocal: true, isDefinition: true)
!95 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 48, elements: !96)
!96 = !{!97}
!97 = !DISubrange(count: 6)
!98 = !DIGlobalVariableExpression(var: !99, expr: !DIExpression())
!99 = distinct !DIGlobalVariable(scope: null, file: !3, line: 37, type: !100, isLocal: true, isDefinition: true)
!100 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 328, elements: !101)
!101 = !{!102}
!102 = !DISubrange(count: 41)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_t", file: !19, line: 107, baseType: !30)
!104 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 0]}
!105 = !{i32 7, !"Dwarf Version", i32 5}
!106 = !{i32 2, !"Debug Info Version", i32 3}
!107 = !{i32 1, !"wchar_size", i32 4}
!108 = !{i32 8, !"PIC Level", i32 2}
!109 = !{i32 7, !"uwtable", i32 1}
!110 = !{i32 7, !"frame-pointer", i32 1}
!111 = !{!"Homebrew clang version 19.1.7"}
!112 = distinct !DISubprogram(name: "_ck_epoch_delref", scope: !6, file: !6, line: 151, type: !113, scopeLine: 153, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !120)
!113 = !DISubroutineType(types: !114)
!114 = !{!115, !17, !116}
!115 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_epoch_section", file: !19, line: 69, size: 32, elements: !118)
!118 = !{!119}
!119 = !DIDerivedType(tag: DW_TAG_member, name: "bucket", scope: !117, file: !19, line: 70, baseType: !7, size: 32)
!120 = !{}
!121 = !DILocalVariable(name: "record", arg: 1, scope: !112, file: !6, line: 151, type: !17)
!122 = !DILocation(line: 151, column: 42, scope: !112)
!123 = !DILocalVariable(name: "section", arg: 2, scope: !112, file: !6, line: 152, type: !116)
!124 = !DILocation(line: 152, column: 30, scope: !112)
!125 = !DILocalVariable(name: "current", scope: !112, file: !6, line: 154, type: !126)
!126 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!127 = !DILocation(line: 154, column: 23, scope: !112)
!128 = !DILocalVariable(name: "other", scope: !112, file: !6, line: 154, type: !126)
!129 = !DILocation(line: 154, column: 33, scope: !112)
!130 = !DILocalVariable(name: "i", scope: !112, file: !6, line: 155, type: !7)
!131 = !DILocation(line: 155, column: 15, scope: !112)
!132 = !DILocation(line: 155, column: 19, scope: !112)
!133 = !DILocation(line: 155, column: 28, scope: !112)
!134 = !DILocation(line: 157, column: 13, scope: !112)
!135 = !DILocation(line: 157, column: 21, scope: !112)
!136 = !DILocation(line: 157, column: 27, scope: !112)
!137 = !DILocation(line: 157, column: 34, scope: !112)
!138 = !DILocation(line: 157, column: 10, scope: !112)
!139 = !DILocation(line: 158, column: 2, scope: !112)
!140 = !DILocation(line: 158, column: 11, scope: !112)
!141 = !DILocation(line: 158, column: 16, scope: !112)
!142 = !DILocation(line: 160, column: 6, scope: !143)
!143 = distinct !DILexicalBlock(scope: !112, file: !6, line: 160, column: 6)
!144 = !DILocation(line: 160, column: 15, scope: !143)
!145 = !DILocation(line: 160, column: 21, scope: !143)
!146 = !DILocation(line: 160, column: 6, scope: !112)
!147 = !DILocation(line: 161, column: 3, scope: !143)
!148 = !DILocation(line: 172, column: 11, scope: !112)
!149 = !DILocation(line: 172, column: 19, scope: !112)
!150 = !DILocation(line: 172, column: 25, scope: !112)
!151 = !DILocation(line: 172, column: 33, scope: !112)
!152 = !DILocation(line: 172, column: 35, scope: !112)
!153 = !DILocation(line: 172, column: 40, scope: !112)
!154 = !DILocation(line: 172, column: 8, scope: !112)
!155 = !DILocation(line: 173, column: 6, scope: !156)
!156 = distinct !DILexicalBlock(scope: !112, file: !6, line: 173, column: 6)
!157 = !DILocation(line: 173, column: 13, scope: !156)
!158 = !DILocation(line: 173, column: 19, scope: !156)
!159 = !DILocation(line: 173, column: 23, scope: !156)
!160 = !DILocation(line: 174, column: 13, scope: !156)
!161 = !DILocation(line: 174, column: 22, scope: !156)
!162 = !DILocation(line: 174, column: 30, scope: !156)
!163 = !DILocation(line: 174, column: 37, scope: !156)
!164 = !DILocation(line: 174, column: 28, scope: !156)
!165 = !DILocation(line: 174, column: 44, scope: !156)
!166 = !DILocation(line: 173, column: 6, scope: !112)
!167 = !DILocation(line: 179, column: 3, scope: !168)
!168 = distinct !DILexicalBlock(scope: !156, file: !6, line: 174, column: 50)
!169 = !DILocation(line: 180, column: 2, scope: !168)
!170 = !DILocation(line: 182, column: 2, scope: !112)
!171 = !DILocation(line: 183, column: 1, scope: !112)
!172 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !173, file: !173, line: 143, type: !174, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!173 = !DIFile(filename: "include/gcc/ppc64/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "1c5aecf7376064f28c732d8a93471464")
!174 = !DISubroutineType(types: !175)
!175 = !{null, !14, !7}
!176 = !DILocalVariable(name: "target", arg: 1, scope: !172, file: !173, line: 143, type: !14)
!177 = !DILocation(line: 143, column: 1, scope: !172)
!178 = !DILocalVariable(name: "v", arg: 2, scope: !172, file: !173, line: 143, type: !7)
!179 = !{i64 2148861006}
!180 = distinct !DISubprogram(name: "_ck_epoch_addref", scope: !6, file: !6, line: 186, type: !181, scopeLine: 188, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !120)
!181 = !DISubroutineType(types: !182)
!182 = !{null, !17, !116}
!183 = !DILocalVariable(name: "record", arg: 1, scope: !180, file: !6, line: 186, type: !17)
!184 = !DILocation(line: 186, column: 42, scope: !180)
!185 = !DILocalVariable(name: "section", arg: 2, scope: !180, file: !6, line: 187, type: !116)
!186 = !DILocation(line: 187, column: 30, scope: !180)
!187 = !DILocalVariable(name: "global", scope: !180, file: !6, line: 189, type: !29)
!188 = !DILocation(line: 189, column: 19, scope: !180)
!189 = !DILocation(line: 189, column: 28, scope: !180)
!190 = !DILocation(line: 189, column: 36, scope: !180)
!191 = !DILocalVariable(name: "ref", scope: !180, file: !6, line: 190, type: !126)
!192 = !DILocation(line: 190, column: 23, scope: !180)
!193 = !DILocalVariable(name: "epoch", scope: !180, file: !6, line: 191, type: !7)
!194 = !DILocation(line: 191, column: 15, scope: !180)
!195 = !DILocalVariable(name: "i", scope: !180, file: !6, line: 191, type: !7)
!196 = !DILocation(line: 191, column: 22, scope: !180)
!197 = !DILocation(line: 193, column: 10, scope: !180)
!198 = !DILocation(line: 193, column: 8, scope: !180)
!199 = !DILocation(line: 194, column: 6, scope: !180)
!200 = !DILocation(line: 194, column: 12, scope: !180)
!201 = !DILocation(line: 194, column: 4, scope: !180)
!202 = !DILocation(line: 195, column: 9, scope: !180)
!203 = !DILocation(line: 195, column: 17, scope: !180)
!204 = !DILocation(line: 195, column: 23, scope: !180)
!205 = !DILocation(line: 195, column: 30, scope: !180)
!206 = !DILocation(line: 195, column: 6, scope: !180)
!207 = !DILocation(line: 197, column: 6, scope: !208)
!208 = distinct !DILexicalBlock(scope: !180, file: !6, line: 197, column: 6)
!209 = !DILocation(line: 197, column: 11, scope: !208)
!210 = !DILocation(line: 197, column: 16, scope: !208)
!211 = !DILocation(line: 197, column: 19, scope: !208)
!212 = !DILocation(line: 197, column: 6, scope: !180)
!213 = !DILocalVariable(name: "previous", scope: !214, file: !6, line: 199, type: !126)
!214 = distinct !DILexicalBlock(scope: !208, file: !6, line: 197, column: 25)
!215 = !DILocation(line: 199, column: 24, scope: !214)
!216 = !DILocation(line: 211, column: 15, scope: !214)
!217 = !DILocation(line: 211, column: 23, scope: !214)
!218 = !DILocation(line: 211, column: 29, scope: !214)
!219 = !DILocation(line: 211, column: 37, scope: !214)
!220 = !DILocation(line: 211, column: 39, scope: !214)
!221 = !DILocation(line: 211, column: 44, scope: !214)
!222 = !DILocation(line: 211, column: 12, scope: !214)
!223 = !DILocation(line: 213, column: 7, scope: !224)
!224 = distinct !DILexicalBlock(scope: !214, file: !6, line: 213, column: 7)
!225 = !DILocation(line: 213, column: 17, scope: !224)
!226 = !DILocation(line: 213, column: 23, scope: !224)
!227 = !DILocation(line: 213, column: 7, scope: !214)
!228 = !DILocation(line: 214, column: 4, scope: !224)
!229 = !DILocation(line: 221, column: 16, scope: !214)
!230 = !DILocation(line: 221, column: 3, scope: !214)
!231 = !DILocation(line: 221, column: 8, scope: !214)
!232 = !DILocation(line: 221, column: 14, scope: !214)
!233 = !DILocation(line: 222, column: 2, scope: !214)
!234 = !DILocation(line: 224, column: 20, scope: !180)
!235 = !DILocation(line: 224, column: 2, scope: !180)
!236 = !DILocation(line: 224, column: 11, scope: !180)
!237 = !DILocation(line: 224, column: 18, scope: !180)
!238 = !DILocation(line: 225, column: 2, scope: !180)
!239 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !173, file: !173, line: 113, type: !240, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!240 = !DISubroutineType(types: !241)
!241 = !{!7, !15}
!242 = !DILocalVariable(name: "target", arg: 1, scope: !239, file: !173, line: 113, type: !15)
!243 = !DILocation(line: 113, column: 1, scope: !239)
!244 = !DILocalVariable(name: "r", scope: !239, file: !173, line: 113, type: !7)
!245 = !{i64 2148857359}
!246 = distinct !DISubprogram(name: "ck_pr_fence_acqrel", scope: !247, file: !247, line: 117, type: !248, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!247 = !DIFile(filename: "include/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "cffbc3bc631aa31cdde49d8ca6470a32")
!248 = !DISubroutineType(types: !249)
!249 = !{null}
!250 = !DILocation(line: 117, column: 1, scope: !246)
!251 = distinct !DISubprogram(name: "ck_epoch_init", scope: !6, file: !6, line: 229, type: !252, scopeLine: 230, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !120)
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
!267 = distinct !DISubprogram(name: "ck_stack_init", scope: !23, file: !23, line: 334, type: !268, scopeLine: 335, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!268 = !DISubroutineType(types: !269)
!269 = !{null, !270}
!270 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!271 = !DILocalVariable(name: "stack", arg: 1, scope: !267, file: !23, line: 334, type: !270)
!272 = !DILocation(line: 334, column: 32, scope: !267)
!273 = !DILocation(line: 337, column: 2, scope: !267)
!274 = !DILocation(line: 337, column: 9, scope: !267)
!275 = !DILocation(line: 337, column: 14, scope: !267)
!276 = !DILocation(line: 338, column: 2, scope: !267)
!277 = !DILocation(line: 338, column: 9, scope: !267)
!278 = !DILocation(line: 338, column: 20, scope: !267)
!279 = !DILocation(line: 339, column: 2, scope: !267)
!280 = distinct !DISubprogram(name: "ck_pr_fence_store", scope: !247, file: !247, line: 113, type: !248, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!281 = !DILocation(line: 113, column: 1, scope: !280)
!282 = distinct !DISubprogram(name: "ck_epoch_recycle", scope: !6, file: !6, line: 240, type: !283, scopeLine: 241, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !120)
!283 = !DISubroutineType(types: !284)
!284 = !{!81, !29, !13}
!285 = !DILocalVariable(name: "global", arg: 1, scope: !282, file: !6, line: 240, type: !29)
!286 = !DILocation(line: 240, column: 35, scope: !282)
!287 = !DILocalVariable(name: "ct", arg: 2, scope: !282, file: !6, line: 240, type: !13)
!288 = !DILocation(line: 240, column: 49, scope: !282)
!289 = !DILocalVariable(name: "record", scope: !282, file: !6, line: 242, type: !17)
!290 = !DILocation(line: 242, column: 26, scope: !282)
!291 = !DILocalVariable(name: "cursor", scope: !282, file: !6, line: 243, type: !292)
!292 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!293 = !DILocation(line: 243, column: 20, scope: !282)
!294 = !DILocalVariable(name: "state", scope: !282, file: !6, line: 244, type: !7)
!295 = !DILocation(line: 244, column: 15, scope: !282)
!296 = !DILocation(line: 246, column: 6, scope: !297)
!297 = distinct !DILexicalBlock(scope: !282, file: !6, line: 246, column: 6)
!298 = !DILocation(line: 246, column: 39, scope: !297)
!299 = !DILocation(line: 246, column: 6, scope: !282)
!300 = !DILocation(line: 247, column: 3, scope: !297)
!301 = !DILocation(line: 249, column: 2, scope: !302)
!302 = distinct !DILexicalBlock(scope: !282, file: !6, line: 249, column: 2)
!303 = !DILocation(line: 249, column: 2, scope: !304)
!304 = distinct !DILexicalBlock(scope: !302, file: !6, line: 249, column: 2)
!305 = !DILocation(line: 250, column: 38, scope: !306)
!306 = distinct !DILexicalBlock(scope: !304, file: !6, line: 249, column: 45)
!307 = !DILocation(line: 250, column: 12, scope: !306)
!308 = !DILocation(line: 250, column: 10, scope: !306)
!309 = !DILocation(line: 252, column: 7, scope: !310)
!310 = distinct !DILexicalBlock(scope: !306, file: !6, line: 252, column: 7)
!311 = !DILocation(line: 252, column: 39, scope: !310)
!312 = !DILocation(line: 252, column: 7, scope: !306)
!313 = !DILocation(line: 254, column: 4, scope: !314)
!314 = distinct !DILexicalBlock(scope: !310, file: !6, line: 252, column: 63)
!315 = !DILocation(line: 255, column: 28, scope: !314)
!316 = !DILocation(line: 255, column: 36, scope: !314)
!317 = !DILocation(line: 255, column: 12, scope: !314)
!318 = !DILocation(line: 255, column: 10, scope: !314)
!319 = !DILocation(line: 257, column: 8, scope: !320)
!320 = distinct !DILexicalBlock(scope: !314, file: !6, line: 257, column: 8)
!321 = !DILocation(line: 257, column: 14, scope: !320)
!322 = !DILocation(line: 257, column: 8, scope: !314)
!323 = !DILocation(line: 258, column: 21, scope: !324)
!324 = distinct !DILexicalBlock(scope: !320, file: !6, line: 257, column: 38)
!325 = !DILocation(line: 258, column: 29, scope: !324)
!326 = !DILocation(line: 258, column: 5, scope: !324)
!327 = !DILocation(line: 259, column: 5, scope: !324)
!328 = !DILocation(line: 265, column: 12, scope: !324)
!329 = !DILocation(line: 265, column: 5, scope: !324)
!330 = !DILocation(line: 267, column: 3, scope: !314)
!331 = !DILocation(line: 268, column: 2, scope: !306)
!332 = distinct !{!332, !301, !333, !334}
!333 = !DILocation(line: 268, column: 2, scope: !302)
!334 = !{!"llvm.loop.mustprogress"}
!335 = !DILocation(line: 270, column: 2, scope: !282)
!336 = !DILocation(line: 271, column: 1, scope: !282)
!337 = distinct !DISubprogram(name: "ck_epoch_record_container", scope: !6, file: !6, line: 143, type: !338, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!338 = !DISubroutineType(types: !339)
!339 = !{!17, !292}
!340 = !DILocalVariable(name: "p", arg: 1, scope: !337, file: !6, line: 143, type: !292)
!341 = !DILocation(line: 143, column: 1, scope: !337)
!342 = distinct !DISubprogram(name: "ck_pr_fence_load", scope: !247, file: !247, line: 112, type: !248, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!343 = !DILocation(line: 112, column: 1, scope: !342)
!344 = distinct !DISubprogram(name: "ck_pr_fas_uint", scope: !173, file: !173, line: 308, type: !345, scopeLine: 308, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!345 = !DISubroutineType(types: !346)
!346 = !{!7, !14, !7}
!347 = !DILocalVariable(name: "target", arg: 1, scope: !344, file: !173, line: 308, type: !14)
!348 = !DILocation(line: 308, column: 1, scope: !344)
!349 = !DILocalVariable(name: "v", arg: 2, scope: !344, file: !173, line: 308, type: !7)
!350 = !DILocalVariable(name: "previous", scope: !344, file: !173, line: 308, type: !7)
!351 = !{i64 2148868622}
!352 = distinct !DISubprogram(name: "ck_pr_dec_uint", scope: !173, file: !173, line: 341, type: !353, scopeLine: 341, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!353 = !DISubroutineType(types: !354)
!354 = !{null, !14}
!355 = !DILocalVariable(name: "target", arg: 1, scope: !352, file: !173, line: 341, type: !14)
!356 = !DILocation(line: 341, column: 1, scope: !352)
!357 = !DILocalVariable(name: "previous", scope: !352, file: !173, line: 341, type: !7)
!358 = !{i64 2148875657}
!359 = distinct !DISubprogram(name: "ck_pr_md_store_ptr", scope: !173, file: !173, line: 135, type: !360, scopeLine: 135, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!360 = !DISubroutineType(types: !361)
!361 = !{null, !13, !362}
!362 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !363, size: 64)
!363 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!364 = !DILocalVariable(name: "target", arg: 1, scope: !359, file: !173, line: 135, type: !13)
!365 = !DILocation(line: 135, column: 1, scope: !359)
!366 = !DILocalVariable(name: "v", arg: 2, scope: !359, file: !173, line: 135, type: !362)
!367 = !{i64 2148859185}
!368 = distinct !DISubprogram(name: "ck_epoch_register", scope: !6, file: !6, line: 274, type: !369, scopeLine: 276, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !120)
!369 = !DISubroutineType(types: !370)
!370 = !{null, !29, !17, !13}
!371 = !DILocalVariable(name: "global", arg: 1, scope: !368, file: !6, line: 274, type: !29)
!372 = !DILocation(line: 274, column: 36, scope: !368)
!373 = !DILocalVariable(name: "record", arg: 2, scope: !368, file: !6, line: 274, type: !17)
!374 = !DILocation(line: 274, column: 68, scope: !368)
!375 = !DILocalVariable(name: "ct", arg: 3, scope: !368, file: !6, line: 275, type: !13)
!376 = !DILocation(line: 275, column: 11, scope: !368)
!377 = !DILocalVariable(name: "i", scope: !368, file: !6, line: 277, type: !378)
!378 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !379, line: 50, baseType: !380)
!379 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_types/_size_t.h", directory: "", checksumkind: CSK_MD5, checksum: "f7981334d28e0c246f35cd24042aa2a4")
!380 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_size_t", file: !381, line: 87, baseType: !382)
!381 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/arm/_types.h", directory: "", checksumkind: CSK_MD5, checksum: "b270144f57ae258d0ce80b8f87be068c")
!382 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!383 = !DILocation(line: 277, column: 9, scope: !368)
!384 = !DILocation(line: 279, column: 19, scope: !368)
!385 = !DILocation(line: 279, column: 2, scope: !368)
!386 = !DILocation(line: 279, column: 10, scope: !368)
!387 = !DILocation(line: 279, column: 17, scope: !368)
!388 = !DILocation(line: 280, column: 2, scope: !368)
!389 = !DILocation(line: 280, column: 10, scope: !368)
!390 = !DILocation(line: 280, column: 16, scope: !368)
!391 = !DILocation(line: 281, column: 2, scope: !368)
!392 = !DILocation(line: 281, column: 10, scope: !368)
!393 = !DILocation(line: 281, column: 17, scope: !368)
!394 = !DILocation(line: 282, column: 2, scope: !368)
!395 = !DILocation(line: 282, column: 10, scope: !368)
!396 = !DILocation(line: 282, column: 16, scope: !368)
!397 = !DILocation(line: 283, column: 2, scope: !368)
!398 = !DILocation(line: 283, column: 10, scope: !368)
!399 = !DILocation(line: 283, column: 21, scope: !368)
!400 = !DILocation(line: 284, column: 2, scope: !368)
!401 = !DILocation(line: 284, column: 10, scope: !368)
!402 = !DILocation(line: 284, column: 17, scope: !368)
!403 = !DILocation(line: 285, column: 2, scope: !368)
!404 = !DILocation(line: 285, column: 10, scope: !368)
!405 = !DILocation(line: 285, column: 20, scope: !368)
!406 = !DILocation(line: 286, column: 15, scope: !368)
!407 = !DILocation(line: 286, column: 2, scope: !368)
!408 = !DILocation(line: 286, column: 10, scope: !368)
!409 = !DILocation(line: 286, column: 13, scope: !368)
!410 = !DILocation(line: 287, column: 2, scope: !368)
!411 = !DILocation(line: 289, column: 9, scope: !412)
!412 = distinct !DILexicalBlock(scope: !368, file: !6, line: 289, column: 2)
!413 = !DILocation(line: 289, column: 7, scope: !412)
!414 = !DILocation(line: 289, column: 14, scope: !415)
!415 = distinct !DILexicalBlock(scope: !412, file: !6, line: 289, column: 2)
!416 = !DILocation(line: 289, column: 16, scope: !415)
!417 = !DILocation(line: 289, column: 2, scope: !412)
!418 = !DILocation(line: 290, column: 18, scope: !415)
!419 = !DILocation(line: 290, column: 26, scope: !415)
!420 = !DILocation(line: 290, column: 34, scope: !415)
!421 = !DILocation(line: 290, column: 3, scope: !415)
!422 = !DILocation(line: 289, column: 36, scope: !415)
!423 = !DILocation(line: 289, column: 2, scope: !415)
!424 = distinct !{!424, !417, !425, !334}
!425 = !DILocation(line: 290, column: 36, scope: !412)
!426 = !DILocation(line: 292, column: 2, scope: !368)
!427 = !DILocation(line: 293, column: 22, scope: !368)
!428 = !DILocation(line: 293, column: 30, scope: !368)
!429 = !DILocation(line: 293, column: 40, scope: !368)
!430 = !DILocation(line: 293, column: 48, scope: !368)
!431 = !DILocation(line: 293, column: 2, scope: !368)
!432 = !DILocation(line: 294, column: 2, scope: !368)
!433 = distinct !DISubprogram(name: "ck_stack_push_upmc", scope: !23, file: !23, line: 54, type: !434, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!434 = !DISubroutineType(types: !435)
!435 = !{null, !270, !27}
!436 = !DILocalVariable(name: "target", arg: 1, scope: !433, file: !23, line: 54, type: !270)
!437 = !DILocation(line: 54, column: 37, scope: !433)
!438 = !DILocalVariable(name: "entry", arg: 2, scope: !433, file: !23, line: 54, type: !27)
!439 = !DILocation(line: 54, column: 68, scope: !433)
!440 = !DILocalVariable(name: "stack", scope: !433, file: !23, line: 56, type: !27)
!441 = !DILocation(line: 56, column: 25, scope: !433)
!442 = !DILocation(line: 58, column: 10, scope: !433)
!443 = !DILocation(line: 58, column: 8, scope: !433)
!444 = !DILocation(line: 59, column: 16, scope: !433)
!445 = !DILocation(line: 59, column: 2, scope: !433)
!446 = !DILocation(line: 59, column: 9, scope: !433)
!447 = !DILocation(line: 59, column: 14, scope: !433)
!448 = !DILocation(line: 60, column: 2, scope: !433)
!449 = !DILocation(line: 62, column: 2, scope: !433)
!450 = !DILocation(line: 62, column: 30, scope: !433)
!451 = !DILocation(line: 62, column: 38, scope: !433)
!452 = !DILocation(line: 62, column: 44, scope: !433)
!453 = !DILocation(line: 62, column: 51, scope: !433)
!454 = !DILocation(line: 62, column: 9, scope: !433)
!455 = !DILocation(line: 62, column: 66, scope: !433)
!456 = !DILocation(line: 63, column: 17, scope: !457)
!457 = distinct !DILexicalBlock(scope: !433, file: !23, line: 62, column: 76)
!458 = !DILocation(line: 63, column: 3, scope: !457)
!459 = !DILocation(line: 63, column: 10, scope: !457)
!460 = !DILocation(line: 63, column: 15, scope: !457)
!461 = !DILocation(line: 64, column: 3, scope: !457)
!462 = distinct !{!462, !449, !463, !334}
!463 = !DILocation(line: 65, column: 2, scope: !433)
!464 = !DILocation(line: 67, column: 2, scope: !433)
!465 = distinct !DISubprogram(name: "ck_epoch_unregister", scope: !6, file: !6, line: 298, type: !466, scopeLine: 299, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !120)
!466 = !DISubroutineType(types: !467)
!467 = !{null, !17}
!468 = !DILocalVariable(name: "record", arg: 1, scope: !465, file: !6, line: 298, type: !17)
!469 = !DILocation(line: 298, column: 45, scope: !465)
!470 = !DILocalVariable(name: "global", scope: !465, file: !6, line: 300, type: !29)
!471 = !DILocation(line: 300, column: 19, scope: !465)
!472 = !DILocation(line: 300, column: 28, scope: !465)
!473 = !DILocation(line: 300, column: 36, scope: !465)
!474 = !DILocalVariable(name: "i", scope: !465, file: !6, line: 301, type: !378)
!475 = !DILocation(line: 301, column: 9, scope: !465)
!476 = !DILocation(line: 303, column: 2, scope: !465)
!477 = !DILocation(line: 303, column: 10, scope: !465)
!478 = !DILocation(line: 303, column: 17, scope: !465)
!479 = !DILocation(line: 304, column: 2, scope: !465)
!480 = !DILocation(line: 304, column: 10, scope: !465)
!481 = !DILocation(line: 304, column: 16, scope: !465)
!482 = !DILocation(line: 305, column: 2, scope: !465)
!483 = !DILocation(line: 305, column: 10, scope: !465)
!484 = !DILocation(line: 305, column: 21, scope: !465)
!485 = !DILocation(line: 306, column: 2, scope: !465)
!486 = !DILocation(line: 306, column: 10, scope: !465)
!487 = !DILocation(line: 306, column: 17, scope: !465)
!488 = !DILocation(line: 307, column: 2, scope: !465)
!489 = !DILocation(line: 307, column: 10, scope: !465)
!490 = !DILocation(line: 307, column: 20, scope: !465)
!491 = !DILocation(line: 308, column: 2, scope: !465)
!492 = !DILocation(line: 310, column: 9, scope: !493)
!493 = distinct !DILexicalBlock(scope: !465, file: !6, line: 310, column: 2)
!494 = !DILocation(line: 310, column: 7, scope: !493)
!495 = !DILocation(line: 310, column: 14, scope: !496)
!496 = distinct !DILexicalBlock(scope: !493, file: !6, line: 310, column: 2)
!497 = !DILocation(line: 310, column: 16, scope: !496)
!498 = !DILocation(line: 310, column: 2, scope: !493)
!499 = !DILocation(line: 311, column: 18, scope: !496)
!500 = !DILocation(line: 311, column: 26, scope: !496)
!501 = !DILocation(line: 311, column: 34, scope: !496)
!502 = !DILocation(line: 311, column: 3, scope: !496)
!503 = !DILocation(line: 310, column: 36, scope: !496)
!504 = !DILocation(line: 310, column: 2, scope: !496)
!505 = distinct !{!505, !498, !506, !334}
!506 = !DILocation(line: 311, column: 36, scope: !493)
!507 = !DILocation(line: 313, column: 2, scope: !465)
!508 = !DILocation(line: 314, column: 2, scope: !465)
!509 = !DILocation(line: 315, column: 2, scope: !465)
!510 = !DILocation(line: 316, column: 18, scope: !465)
!511 = !DILocation(line: 316, column: 26, scope: !465)
!512 = !DILocation(line: 316, column: 2, scope: !465)
!513 = !DILocation(line: 317, column: 2, scope: !465)
!514 = distinct !DISubprogram(name: "ck_pr_inc_uint", scope: !173, file: !173, line: 341, type: !353, scopeLine: 341, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!515 = !DILocalVariable(name: "target", arg: 1, scope: !514, file: !173, line: 341, type: !14)
!516 = !DILocation(line: 341, column: 1, scope: !514)
!517 = !DILocalVariable(name: "previous", scope: !514, file: !173, line: 341, type: !7)
!518 = !{i64 2148875208}
!519 = distinct !DISubprogram(name: "ck_epoch_reclaim", scope: !6, file: !6, line: 400, type: !466, scopeLine: 401, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !120)
!520 = !DILocalVariable(name: "record", arg: 1, scope: !519, file: !6, line: 400, type: !17)
!521 = !DILocation(line: 400, column: 42, scope: !519)
!522 = !DILocalVariable(name: "epoch", scope: !519, file: !6, line: 402, type: !7)
!523 = !DILocation(line: 402, column: 15, scope: !519)
!524 = !DILocation(line: 404, column: 13, scope: !525)
!525 = distinct !DILexicalBlock(scope: !519, file: !6, line: 404, column: 2)
!526 = !DILocation(line: 404, column: 7, scope: !525)
!527 = !DILocation(line: 404, column: 18, scope: !528)
!528 = distinct !DILexicalBlock(scope: !525, file: !6, line: 404, column: 2)
!529 = !DILocation(line: 404, column: 24, scope: !528)
!530 = !DILocation(line: 404, column: 2, scope: !525)
!531 = !DILocation(line: 405, column: 21, scope: !528)
!532 = !DILocation(line: 405, column: 29, scope: !528)
!533 = !DILocation(line: 405, column: 3, scope: !528)
!534 = !DILocation(line: 404, column: 48, scope: !528)
!535 = !DILocation(line: 404, column: 2, scope: !528)
!536 = distinct !{!536, !530, !537, !334}
!537 = !DILocation(line: 405, column: 40, scope: !525)
!538 = !DILocation(line: 407, column: 2, scope: !519)
!539 = distinct !DISubprogram(name: "ck_epoch_dispatch", scope: !6, file: !6, line: 360, type: !540, scopeLine: 361, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!540 = !DISubroutineType(types: !541)
!541 = !{!7, !17, !7, !542}
!542 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!543 = !DILocalVariable(name: "record", arg: 1, scope: !539, file: !6, line: 360, type: !17)
!544 = !DILocation(line: 360, column: 43, scope: !539)
!545 = !DILocalVariable(name: "e", arg: 2, scope: !539, file: !6, line: 360, type: !7)
!546 = !DILocation(line: 360, column: 64, scope: !539)
!547 = !DILocalVariable(name: "deferred", arg: 3, scope: !539, file: !6, line: 360, type: !542)
!548 = !DILocation(line: 360, column: 79, scope: !539)
!549 = !DILocalVariable(name: "epoch", scope: !539, file: !6, line: 362, type: !7)
!550 = !DILocation(line: 362, column: 15, scope: !539)
!551 = !DILocation(line: 362, column: 23, scope: !539)
!552 = !DILocation(line: 362, column: 25, scope: !539)
!553 = !DILocalVariable(name: "head", scope: !539, file: !6, line: 363, type: !292)
!554 = !DILocation(line: 363, column: 20, scope: !539)
!555 = !DILocalVariable(name: "next", scope: !539, file: !6, line: 363, type: !292)
!556 = !DILocation(line: 363, column: 27, scope: !539)
!557 = !DILocalVariable(name: "cursor", scope: !539, file: !6, line: 363, type: !292)
!558 = !DILocation(line: 363, column: 34, scope: !539)
!559 = !DILocalVariable(name: "n_pending", scope: !539, file: !6, line: 364, type: !7)
!560 = !DILocation(line: 364, column: 15, scope: !539)
!561 = !DILocalVariable(name: "n_peak", scope: !539, file: !6, line: 364, type: !7)
!562 = !DILocation(line: 364, column: 26, scope: !539)
!563 = !DILocalVariable(name: "i", scope: !539, file: !6, line: 365, type: !7)
!564 = !DILocation(line: 365, column: 15, scope: !539)
!565 = !DILocation(line: 367, column: 34, scope: !539)
!566 = !DILocation(line: 367, column: 42, scope: !539)
!567 = !DILocation(line: 367, column: 50, scope: !539)
!568 = !DILocation(line: 367, column: 9, scope: !539)
!569 = !DILocation(line: 367, column: 7, scope: !539)
!570 = !DILocation(line: 368, column: 16, scope: !571)
!571 = distinct !DILexicalBlock(scope: !539, file: !6, line: 368, column: 2)
!572 = !DILocation(line: 368, column: 14, scope: !571)
!573 = !DILocation(line: 368, column: 7, scope: !571)
!574 = !DILocation(line: 368, column: 22, scope: !575)
!575 = distinct !DILexicalBlock(scope: !571, file: !6, line: 368, column: 2)
!576 = !DILocation(line: 368, column: 29, scope: !575)
!577 = !DILocation(line: 368, column: 2, scope: !571)
!578 = !DILocalVariable(name: "entry", scope: !579, file: !6, line: 369, type: !70)
!579 = distinct !DILexicalBlock(scope: !575, file: !6, line: 368, column: 53)
!580 = !DILocation(line: 369, column: 26, scope: !579)
!581 = !DILocation(line: 370, column: 32, scope: !579)
!582 = !DILocation(line: 370, column: 7, scope: !579)
!583 = !DILocation(line: 372, column: 10, scope: !579)
!584 = !DILocation(line: 372, column: 8, scope: !579)
!585 = !DILocation(line: 373, column: 7, scope: !586)
!586 = distinct !DILexicalBlock(scope: !579, file: !6, line: 373, column: 7)
!587 = !DILocation(line: 373, column: 16, scope: !586)
!588 = !DILocation(line: 373, column: 7, scope: !579)
!589 = !DILocation(line: 374, column: 23, scope: !586)
!590 = !DILocation(line: 374, column: 34, scope: !586)
!591 = !DILocation(line: 374, column: 41, scope: !586)
!592 = !DILocation(line: 374, column: 4, scope: !586)
!593 = !DILocation(line: 376, column: 4, scope: !586)
!594 = !DILocation(line: 376, column: 11, scope: !586)
!595 = !DILocation(line: 376, column: 20, scope: !586)
!596 = !DILocation(line: 378, column: 4, scope: !579)
!597 = !DILocation(line: 379, column: 2, scope: !579)
!598 = !DILocation(line: 368, column: 47, scope: !575)
!599 = !DILocation(line: 368, column: 45, scope: !575)
!600 = !DILocation(line: 368, column: 2, scope: !575)
!601 = distinct !{!601, !577, !602, !334}
!602 = !DILocation(line: 379, column: 2, scope: !571)
!603 = !DILocation(line: 381, column: 11, scope: !539)
!604 = !DILocation(line: 381, column: 9, scope: !539)
!605 = !DILocation(line: 382, column: 14, scope: !539)
!606 = !DILocation(line: 382, column: 12, scope: !539)
!607 = !DILocation(line: 385, column: 6, scope: !608)
!608 = distinct !DILexicalBlock(scope: !539, file: !6, line: 385, column: 6)
!609 = !DILocation(line: 385, column: 18, scope: !608)
!610 = !DILocation(line: 385, column: 16, scope: !608)
!611 = !DILocation(line: 385, column: 6, scope: !539)
!612 = !DILocation(line: 386, column: 3, scope: !608)
!613 = !DILocation(line: 388, column: 6, scope: !614)
!614 = distinct !DILexicalBlock(scope: !539, file: !6, line: 388, column: 6)
!615 = !DILocation(line: 388, column: 8, scope: !614)
!616 = !DILocation(line: 388, column: 6, scope: !539)
!617 = !DILocation(line: 389, column: 19, scope: !618)
!618 = distinct !DILexicalBlock(scope: !614, file: !6, line: 388, column: 13)
!619 = !DILocation(line: 389, column: 27, scope: !618)
!620 = !DILocation(line: 389, column: 39, scope: !618)
!621 = !DILocation(line: 389, column: 3, scope: !618)
!622 = !DILocation(line: 390, column: 19, scope: !618)
!623 = !DILocation(line: 390, column: 27, scope: !618)
!624 = !DILocation(line: 390, column: 38, scope: !618)
!625 = !DILocation(line: 390, column: 3, scope: !618)
!626 = !DILocation(line: 391, column: 2, scope: !618)
!627 = !DILocation(line: 393, column: 9, scope: !539)
!628 = !DILocation(line: 393, column: 2, scope: !539)
!629 = distinct !DISubprogram(name: "ck_epoch_synchronize_wait", scope: !6, file: !6, line: 425, type: !630, scopeLine: 427, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !120)
!630 = !DISubroutineType(types: !631)
!631 = !{null, !29, !632, !13}
!632 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !633, size: 64)
!633 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_wait_cb_t", file: !19, line: 234, baseType: !634)
!634 = !DISubroutineType(types: !635)
!635 = !{null, !636, !81, !13}
!636 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!637 = !DILocalVariable(name: "global", arg: 1, scope: !629, file: !6, line: 425, type: !29)
!638 = !DILocation(line: 425, column: 44, scope: !629)
!639 = !DILocalVariable(name: "cb", arg: 2, scope: !629, file: !6, line: 426, type: !632)
!640 = !DILocation(line: 426, column: 25, scope: !629)
!641 = !DILocalVariable(name: "ct", arg: 3, scope: !629, file: !6, line: 426, type: !13)
!642 = !DILocation(line: 426, column: 35, scope: !629)
!643 = !DILocalVariable(name: "cr", scope: !629, file: !6, line: 428, type: !17)
!644 = !DILocation(line: 428, column: 26, scope: !629)
!645 = !DILocalVariable(name: "delta", scope: !629, file: !6, line: 429, type: !7)
!646 = !DILocation(line: 429, column: 15, scope: !629)
!647 = !DILocalVariable(name: "epoch", scope: !629, file: !6, line: 429, type: !7)
!648 = !DILocation(line: 429, column: 22, scope: !629)
!649 = !DILocalVariable(name: "goal", scope: !629, file: !6, line: 429, type: !7)
!650 = !DILocation(line: 429, column: 29, scope: !629)
!651 = !DILocalVariable(name: "i", scope: !629, file: !6, line: 429, type: !7)
!652 = !DILocation(line: 429, column: 35, scope: !629)
!653 = !DILocalVariable(name: "active", scope: !629, file: !6, line: 430, type: !115)
!654 = !DILocation(line: 430, column: 7, scope: !629)
!655 = !DILocation(line: 432, column: 2, scope: !629)
!656 = !DILocation(line: 443, column: 18, scope: !629)
!657 = !DILocation(line: 443, column: 16, scope: !629)
!658 = !DILocation(line: 443, column: 8, scope: !629)
!659 = !DILocation(line: 444, column: 9, scope: !629)
!660 = !DILocation(line: 444, column: 15, scope: !629)
!661 = !DILocation(line: 444, column: 7, scope: !629)
!662 = !DILocation(line: 446, column: 9, scope: !663)
!663 = distinct !DILexicalBlock(scope: !629, file: !6, line: 446, column: 2)
!664 = !DILocation(line: 446, column: 17, scope: !663)
!665 = !DILocation(line: 446, column: 7, scope: !663)
!666 = !DILocation(line: 446, column: 25, scope: !667)
!667 = distinct !DILexicalBlock(scope: !663, file: !6, line: 446, column: 2)
!668 = !DILocation(line: 446, column: 27, scope: !667)
!669 = !DILocation(line: 446, column: 2, scope: !663)
!670 = !DILocalVariable(name: "r", scope: !671, file: !6, line: 447, type: !115)
!671 = distinct !DILexicalBlock(scope: !667, file: !6, line: 446, column: 65)
!672 = !DILocation(line: 447, column: 8, scope: !671)
!673 = !DILocation(line: 453, column: 3, scope: !671)
!674 = !DILocation(line: 453, column: 29, scope: !671)
!675 = !DILocation(line: 453, column: 37, scope: !671)
!676 = !DILocation(line: 453, column: 41, scope: !671)
!677 = !DILocation(line: 453, column: 15, scope: !671)
!678 = !DILocation(line: 453, column: 13, scope: !671)
!679 = !DILocation(line: 454, column: 7, scope: !671)
!680 = !DILocation(line: 454, column: 10, scope: !671)
!681 = !DILocalVariable(name: "e_d", scope: !682, file: !6, line: 455, type: !7)
!682 = distinct !DILexicalBlock(scope: !671, file: !6, line: 454, column: 19)
!683 = !DILocation(line: 455, column: 17, scope: !682)
!684 = !DILocation(line: 457, column: 4, scope: !682)
!685 = !DILocation(line: 463, column: 10, scope: !682)
!686 = !DILocation(line: 463, column: 8, scope: !682)
!687 = !DILocation(line: 464, column: 8, scope: !688)
!688 = distinct !DILexicalBlock(scope: !682, file: !6, line: 464, column: 8)
!689 = !DILocation(line: 464, column: 15, scope: !688)
!690 = !DILocation(line: 464, column: 12, scope: !688)
!691 = !DILocation(line: 464, column: 8, scope: !682)
!692 = !DILocation(line: 465, column: 17, scope: !693)
!693 = distinct !DILexicalBlock(scope: !688, file: !6, line: 464, column: 22)
!694 = !DILocation(line: 465, column: 25, scope: !693)
!695 = !DILocation(line: 465, column: 29, scope: !693)
!696 = !DILocation(line: 465, column: 33, scope: !693)
!697 = !DILocalVariable(name: "global", arg: 1, scope: !698, file: !6, line: 411, type: !29)
!698 = distinct !DISubprogram(name: "epoch_block", scope: !6, file: !6, line: 411, type: !699, scopeLine: 413, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!699 = !DISubroutineType(types: !700)
!700 = !{null, !29, !17, !632, !13}
!701 = !DILocation(line: 411, column: 30, scope: !698, inlinedAt: !702)
!702 = distinct !DILocation(line: 465, column: 5, scope: !693)
!703 = !DILocalVariable(name: "cr", arg: 2, scope: !698, file: !6, line: 411, type: !17)
!704 = !DILocation(line: 411, column: 62, scope: !698, inlinedAt: !702)
!705 = !DILocalVariable(name: "cb", arg: 3, scope: !698, file: !6, line: 412, type: !632)
!706 = !DILocation(line: 412, column: 25, scope: !698, inlinedAt: !702)
!707 = !DILocalVariable(name: "ct", arg: 4, scope: !698, file: !6, line: 412, type: !13)
!708 = !DILocation(line: 412, column: 35, scope: !698, inlinedAt: !702)
!709 = !DILocation(line: 415, column: 6, scope: !710, inlinedAt: !702)
!710 = distinct !DILexicalBlock(scope: !698, file: !6, line: 415, column: 6)
!711 = !DILocation(line: 415, column: 9, scope: !710, inlinedAt: !702)
!712 = !DILocation(line: 415, column: 6, scope: !698, inlinedAt: !702)
!713 = !DILocation(line: 416, column: 3, scope: !710, inlinedAt: !702)
!714 = !DILocation(line: 416, column: 6, scope: !710, inlinedAt: !702)
!715 = !DILocation(line: 416, column: 14, scope: !710, inlinedAt: !702)
!716 = !DILocation(line: 416, column: 18, scope: !710, inlinedAt: !702)
!717 = !DILocation(line: 466, column: 5, scope: !693)
!718 = distinct !{!718, !673, !719, !334}
!719 = !DILocation(line: 485, column: 3, scope: !671)
!720 = !DILocation(line: 473, column: 12, scope: !682)
!721 = !DILocation(line: 473, column: 10, scope: !682)
!722 = !DILocation(line: 474, column: 9, scope: !723)
!723 = distinct !DILexicalBlock(scope: !682, file: !6, line: 474, column: 8)
!724 = !DILocation(line: 474, column: 16, scope: !723)
!725 = !DILocation(line: 474, column: 14, scope: !723)
!726 = !DILocation(line: 474, column: 26, scope: !723)
!727 = !DILocation(line: 474, column: 35, scope: !723)
!728 = !DILocation(line: 474, column: 32, scope: !723)
!729 = !DILocation(line: 474, column: 23, scope: !723)
!730 = !DILocation(line: 474, column: 8, scope: !682)
!731 = !DILocation(line: 475, column: 5, scope: !723)
!732 = !DILocation(line: 477, column: 16, scope: !682)
!733 = !DILocation(line: 477, column: 24, scope: !682)
!734 = !DILocation(line: 477, column: 28, scope: !682)
!735 = !DILocation(line: 477, column: 32, scope: !682)
!736 = !DILocation(line: 411, column: 30, scope: !698, inlinedAt: !737)
!737 = distinct !DILocation(line: 477, column: 4, scope: !682)
!738 = !DILocation(line: 411, column: 62, scope: !698, inlinedAt: !737)
!739 = !DILocation(line: 412, column: 25, scope: !698, inlinedAt: !737)
!740 = !DILocation(line: 412, column: 35, scope: !698, inlinedAt: !737)
!741 = !DILocation(line: 415, column: 6, scope: !710, inlinedAt: !737)
!742 = !DILocation(line: 415, column: 9, scope: !710, inlinedAt: !737)
!743 = !DILocation(line: 415, column: 6, scope: !698, inlinedAt: !737)
!744 = !DILocation(line: 416, column: 3, scope: !710, inlinedAt: !737)
!745 = !DILocation(line: 416, column: 6, scope: !710, inlinedAt: !737)
!746 = !DILocation(line: 416, column: 14, scope: !710, inlinedAt: !737)
!747 = !DILocation(line: 416, column: 18, scope: !710, inlinedAt: !737)
!748 = !DILocation(line: 484, column: 7, scope: !682)
!749 = !DILocation(line: 491, column: 7, scope: !750)
!750 = distinct !DILexicalBlock(scope: !671, file: !6, line: 491, column: 7)
!751 = !DILocation(line: 491, column: 14, scope: !750)
!752 = !DILocation(line: 491, column: 7, scope: !671)
!753 = !DILocation(line: 492, column: 4, scope: !750)
!754 = !DILocation(line: 505, column: 29, scope: !671)
!755 = !DILocation(line: 505, column: 37, scope: !671)
!756 = !DILocation(line: 505, column: 44, scope: !671)
!757 = !DILocation(line: 505, column: 51, scope: !671)
!758 = !DILocation(line: 505, column: 57, scope: !671)
!759 = !DILocation(line: 505, column: 7, scope: !671)
!760 = !DILocation(line: 505, column: 5, scope: !671)
!761 = !DILocation(line: 509, column: 3, scope: !671)
!762 = !DILocation(line: 515, column: 11, scope: !671)
!763 = !DILocation(line: 515, column: 19, scope: !671)
!764 = !DILocation(line: 515, column: 17, scope: !671)
!765 = !DILocation(line: 515, column: 9, scope: !671)
!766 = !DILocation(line: 516, column: 2, scope: !671)
!767 = !DILocation(line: 446, column: 52, scope: !667)
!768 = !DILocation(line: 446, column: 61, scope: !667)
!769 = !DILocation(line: 446, column: 2, scope: !667)
!770 = distinct !{!770, !669, !771, !334}
!771 = !DILocation(line: 516, column: 2, scope: !663)
!772 = !DILabel(scope: !629, name: "leave", file: !6, line: 523)
!773 = !DILocation(line: 523, column: 1, scope: !629)
!774 = !DILocation(line: 524, column: 2, scope: !629)
!775 = !DILocation(line: 525, column: 2, scope: !629)
!776 = distinct !DISubprogram(name: "ck_pr_fence_memory", scope: !247, file: !247, line: 114, type: !248, scopeLine: 114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!777 = !DILocation(line: 114, column: 1, scope: !776)
!778 = distinct !DISubprogram(name: "ck_epoch_scan", scope: !6, file: !6, line: 321, type: !779, scopeLine: 325, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!779 = !DISubroutineType(types: !780)
!780 = !{!17, !29, !17, !7, !781}
!781 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !115, size: 64)
!782 = !DILocalVariable(name: "global", arg: 1, scope: !778, file: !6, line: 321, type: !29)
!783 = !DILocation(line: 321, column: 32, scope: !778)
!784 = !DILocalVariable(name: "cr", arg: 2, scope: !778, file: !6, line: 322, type: !17)
!785 = !DILocation(line: 322, column: 29, scope: !778)
!786 = !DILocalVariable(name: "epoch", arg: 3, scope: !778, file: !6, line: 323, type: !7)
!787 = !DILocation(line: 323, column: 18, scope: !778)
!788 = !DILocalVariable(name: "af", arg: 4, scope: !778, file: !6, line: 324, type: !781)
!789 = !DILocation(line: 324, column: 11, scope: !778)
!790 = !DILocalVariable(name: "cursor", scope: !778, file: !6, line: 326, type: !292)
!791 = !DILocation(line: 326, column: 20, scope: !778)
!792 = !DILocation(line: 328, column: 6, scope: !793)
!793 = distinct !DILexicalBlock(scope: !778, file: !6, line: 328, column: 6)
!794 = !DILocation(line: 328, column: 9, scope: !793)
!795 = !DILocation(line: 328, column: 6, scope: !778)
!796 = !DILocation(line: 329, column: 12, scope: !797)
!797 = distinct !DILexicalBlock(scope: !793, file: !6, line: 328, column: 18)
!798 = !DILocation(line: 329, column: 10, scope: !797)
!799 = !DILocation(line: 330, column: 4, scope: !797)
!800 = !DILocation(line: 330, column: 7, scope: !797)
!801 = !DILocation(line: 331, column: 2, scope: !797)
!802 = !DILocation(line: 332, column: 13, scope: !803)
!803 = distinct !DILexicalBlock(scope: !793, file: !6, line: 331, column: 9)
!804 = !DILocation(line: 332, column: 17, scope: !803)
!805 = !DILocation(line: 332, column: 10, scope: !803)
!806 = !DILocation(line: 333, column: 4, scope: !803)
!807 = !DILocation(line: 333, column: 7, scope: !803)
!808 = !DILocation(line: 336, column: 2, scope: !778)
!809 = !DILocation(line: 336, column: 9, scope: !778)
!810 = !DILocation(line: 336, column: 16, scope: !778)
!811 = !DILocalVariable(name: "state", scope: !812, file: !6, line: 337, type: !7)
!812 = distinct !DILexicalBlock(scope: !778, file: !6, line: 336, column: 25)
!813 = !DILocation(line: 337, column: 16, scope: !812)
!814 = !DILocalVariable(name: "active", scope: !812, file: !6, line: 337, type: !7)
!815 = !DILocation(line: 337, column: 23, scope: !812)
!816 = !DILocation(line: 339, column: 34, scope: !812)
!817 = !DILocation(line: 339, column: 8, scope: !812)
!818 = !DILocation(line: 339, column: 6, scope: !812)
!819 = !DILocation(line: 341, column: 11, scope: !812)
!820 = !DILocation(line: 341, column: 9, scope: !812)
!821 = !DILocation(line: 342, column: 7, scope: !822)
!822 = distinct !DILexicalBlock(scope: !812, file: !6, line: 342, column: 7)
!823 = !DILocation(line: 342, column: 13, scope: !822)
!824 = !DILocation(line: 342, column: 7, scope: !812)
!825 = !DILocation(line: 343, column: 13, scope: !826)
!826 = distinct !DILexicalBlock(scope: !822, file: !6, line: 342, column: 36)
!827 = !DILocation(line: 343, column: 11, scope: !826)
!828 = !DILocation(line: 344, column: 4, scope: !826)
!829 = distinct !{!829, !808, !830, !334}
!830 = !DILocation(line: 354, column: 2, scope: !778)
!831 = !DILocation(line: 347, column: 12, scope: !812)
!832 = !DILocation(line: 347, column: 10, scope: !812)
!833 = !DILocation(line: 348, column: 10, scope: !812)
!834 = !DILocation(line: 348, column: 4, scope: !812)
!835 = !DILocation(line: 348, column: 7, scope: !812)
!836 = !DILocation(line: 350, column: 7, scope: !837)
!837 = distinct !DILexicalBlock(scope: !812, file: !6, line: 350, column: 7)
!838 = !DILocation(line: 350, column: 14, scope: !837)
!839 = !DILocation(line: 350, column: 19, scope: !837)
!840 = !DILocation(line: 350, column: 22, scope: !837)
!841 = !DILocation(line: 350, column: 53, scope: !837)
!842 = !DILocation(line: 350, column: 50, scope: !837)
!843 = !DILocation(line: 350, column: 7, scope: !812)
!844 = !DILocation(line: 351, column: 11, scope: !837)
!845 = !DILocation(line: 351, column: 4, scope: !837)
!846 = !DILocation(line: 353, column: 12, scope: !812)
!847 = !DILocation(line: 353, column: 10, scope: !812)
!848 = !DILocation(line: 356, column: 2, scope: !778)
!849 = !DILocation(line: 357, column: 1, scope: !778)
!850 = distinct !DISubprogram(name: "ck_pr_stall", scope: !173, file: !173, line: 56, type: !248, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!851 = !DILocation(line: 59, column: 2, scope: !850)
!852 = !{i64 1356392}
!853 = !DILocation(line: 61, column: 2, scope: !850)
!854 = distinct !DISubprogram(name: "ck_pr_cas_uint_value", scope: !173, file: !173, line: 280, type: !855, scopeLine: 280, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!855 = !DISubroutineType(types: !856)
!856 = !{!115, !14, !7, !7, !14}
!857 = !DILocalVariable(name: "target", arg: 1, scope: !854, file: !173, line: 280, type: !14)
!858 = !DILocation(line: 280, column: 1, scope: !854)
!859 = !DILocalVariable(name: "compare", arg: 2, scope: !854, file: !173, line: 280, type: !7)
!860 = !DILocalVariable(name: "set", arg: 3, scope: !854, file: !173, line: 280, type: !7)
!861 = !DILocalVariable(name: "value", arg: 4, scope: !854, file: !173, line: 280, type: !14)
!862 = !DILocalVariable(name: "previous", scope: !854, file: !173, line: 280, type: !7)
!863 = !{i64 2148864016}
!864 = distinct !DISubprogram(name: "ck_pr_fence_atomic_load", scope: !247, file: !247, line: 106, type: !248, scopeLine: 106, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!865 = !DILocation(line: 106, column: 1, scope: !864)
!866 = distinct !DISubprogram(name: "ck_epoch_synchronize", scope: !6, file: !6, line: 529, type: !466, scopeLine: 530, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !120)
!867 = !DILocalVariable(name: "record", arg: 1, scope: !866, file: !6, line: 529, type: !17)
!868 = !DILocation(line: 529, column: 46, scope: !866)
!869 = !DILocation(line: 532, column: 28, scope: !866)
!870 = !DILocation(line: 532, column: 36, scope: !866)
!871 = !DILocation(line: 532, column: 2, scope: !866)
!872 = !DILocation(line: 533, column: 2, scope: !866)
!873 = distinct !DISubprogram(name: "ck_epoch_barrier", scope: !6, file: !6, line: 537, type: !466, scopeLine: 538, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !120)
!874 = !DILocalVariable(name: "record", arg: 1, scope: !873, file: !6, line: 537, type: !17)
!875 = !DILocation(line: 537, column: 42, scope: !873)
!876 = !DILocation(line: 540, column: 23, scope: !873)
!877 = !DILocation(line: 540, column: 2, scope: !873)
!878 = !DILocation(line: 541, column: 19, scope: !873)
!879 = !DILocation(line: 541, column: 2, scope: !873)
!880 = !DILocation(line: 542, column: 2, scope: !873)
!881 = distinct !DISubprogram(name: "ck_epoch_barrier_wait", scope: !6, file: !6, line: 546, type: !882, scopeLine: 548, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !120)
!882 = !DISubroutineType(types: !883)
!883 = !{null, !17, !632, !13}
!884 = !DILocalVariable(name: "record", arg: 1, scope: !881, file: !6, line: 546, type: !17)
!885 = !DILocation(line: 546, column: 47, scope: !881)
!886 = !DILocalVariable(name: "cb", arg: 2, scope: !881, file: !6, line: 546, type: !632)
!887 = !DILocation(line: 546, column: 75, scope: !881)
!888 = !DILocalVariable(name: "ct", arg: 3, scope: !881, file: !6, line: 547, type: !13)
!889 = !DILocation(line: 547, column: 11, scope: !881)
!890 = !DILocation(line: 550, column: 28, scope: !881)
!891 = !DILocation(line: 550, column: 36, scope: !881)
!892 = !DILocation(line: 550, column: 44, scope: !881)
!893 = !DILocation(line: 550, column: 48, scope: !881)
!894 = !DILocation(line: 550, column: 2, scope: !881)
!895 = !DILocation(line: 551, column: 19, scope: !881)
!896 = !DILocation(line: 551, column: 2, scope: !881)
!897 = !DILocation(line: 552, column: 2, scope: !881)
!898 = distinct !DISubprogram(name: "ck_epoch_poll_deferred", scope: !6, file: !6, line: 566, type: !899, scopeLine: 567, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !120)
!899 = !DISubroutineType(types: !900)
!900 = !{!115, !17, !542}
!901 = !DILocalVariable(name: "record", arg: 1, scope: !898, file: !6, line: 566, type: !17)
!902 = !DILocation(line: 566, column: 48, scope: !898)
!903 = !DILocalVariable(name: "deferred", arg: 2, scope: !898, file: !6, line: 566, type: !542)
!904 = !DILocation(line: 566, column: 68, scope: !898)
!905 = !DILocalVariable(name: "active", scope: !898, file: !6, line: 568, type: !115)
!906 = !DILocation(line: 568, column: 7, scope: !898)
!907 = !DILocalVariable(name: "epoch", scope: !898, file: !6, line: 569, type: !7)
!908 = !DILocation(line: 569, column: 15, scope: !898)
!909 = !DILocalVariable(name: "cr", scope: !898, file: !6, line: 570, type: !17)
!910 = !DILocation(line: 570, column: 26, scope: !898)
!911 = !DILocalVariable(name: "global", scope: !898, file: !6, line: 571, type: !29)
!912 = !DILocation(line: 571, column: 19, scope: !898)
!913 = !DILocation(line: 571, column: 28, scope: !898)
!914 = !DILocation(line: 571, column: 36, scope: !898)
!915 = !DILocalVariable(name: "n_dispatch", scope: !898, file: !6, line: 572, type: !7)
!916 = !DILocation(line: 572, column: 15, scope: !898)
!917 = !DILocation(line: 574, column: 10, scope: !898)
!918 = !DILocation(line: 574, column: 8, scope: !898)
!919 = !DILocation(line: 577, column: 2, scope: !898)
!920 = !DILocation(line: 589, column: 33, scope: !898)
!921 = !DILocation(line: 589, column: 41, scope: !898)
!922 = !DILocation(line: 589, column: 47, scope: !898)
!923 = !DILocation(line: 589, column: 52, scope: !898)
!924 = !DILocation(line: 589, column: 15, scope: !898)
!925 = !DILocation(line: 589, column: 13, scope: !898)
!926 = !DILocation(line: 591, column: 21, scope: !898)
!927 = !DILocation(line: 591, column: 29, scope: !898)
!928 = !DILocation(line: 591, column: 33, scope: !898)
!929 = !DILocation(line: 591, column: 7, scope: !898)
!930 = !DILocation(line: 591, column: 5, scope: !898)
!931 = !DILocation(line: 592, column: 6, scope: !932)
!932 = distinct !DILexicalBlock(scope: !898, file: !6, line: 592, column: 6)
!933 = !DILocation(line: 592, column: 9, scope: !932)
!934 = !DILocation(line: 592, column: 6, scope: !898)
!935 = !DILocation(line: 593, column: 11, scope: !932)
!936 = !DILocation(line: 593, column: 22, scope: !932)
!937 = !DILocation(line: 593, column: 3, scope: !932)
!938 = !DILocation(line: 596, column: 6, scope: !939)
!939 = distinct !DILexicalBlock(scope: !898, file: !6, line: 596, column: 6)
!940 = !DILocation(line: 596, column: 13, scope: !939)
!941 = !DILocation(line: 596, column: 6, scope: !898)
!942 = !DILocation(line: 597, column: 19, scope: !943)
!943 = distinct !DILexicalBlock(scope: !939, file: !6, line: 596, column: 23)
!944 = !DILocation(line: 597, column: 3, scope: !943)
!945 = !DILocation(line: 597, column: 11, scope: !943)
!946 = !DILocation(line: 597, column: 17, scope: !943)
!947 = !DILocation(line: 598, column: 14, scope: !948)
!948 = distinct !DILexicalBlock(scope: !943, file: !6, line: 598, column: 3)
!949 = !DILocation(line: 598, column: 8, scope: !948)
!950 = !DILocation(line: 598, column: 19, scope: !951)
!951 = distinct !DILexicalBlock(scope: !948, file: !6, line: 598, column: 3)
!952 = !DILocation(line: 598, column: 25, scope: !951)
!953 = !DILocation(line: 598, column: 3, scope: !948)
!954 = !DILocation(line: 599, column: 22, scope: !951)
!955 = !DILocation(line: 599, column: 30, scope: !951)
!956 = !DILocation(line: 599, column: 37, scope: !951)
!957 = !DILocation(line: 599, column: 4, scope: !951)
!958 = !DILocation(line: 598, column: 49, scope: !951)
!959 = !DILocation(line: 598, column: 3, scope: !951)
!960 = distinct !{!960, !953, !961, !334}
!961 = !DILocation(line: 599, column: 45, scope: !948)
!962 = !DILocation(line: 601, column: 3, scope: !943)
!963 = !DILocation(line: 612, column: 24, scope: !898)
!964 = !DILocation(line: 612, column: 32, scope: !898)
!965 = !DILocation(line: 612, column: 39, scope: !898)
!966 = !DILocation(line: 612, column: 46, scope: !898)
!967 = !DILocation(line: 612, column: 52, scope: !898)
!968 = !DILocation(line: 612, column: 8, scope: !898)
!969 = !DILocation(line: 614, column: 20, scope: !898)
!970 = !DILocation(line: 614, column: 28, scope: !898)
!971 = !DILocation(line: 614, column: 34, scope: !898)
!972 = !DILocation(line: 614, column: 39, scope: !898)
!973 = !DILocation(line: 614, column: 2, scope: !898)
!974 = !DILocation(line: 615, column: 2, scope: !898)
!975 = !DILocation(line: 616, column: 1, scope: !898)
!976 = distinct !DISubprogram(name: "ck_pr_cas_uint", scope: !173, file: !173, line: 280, type: !977, scopeLine: 280, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!977 = !DISubroutineType(types: !978)
!978 = !{!115, !14, !7, !7}
!979 = !DILocalVariable(name: "target", arg: 1, scope: !976, file: !173, line: 280, type: !14)
!980 = !DILocation(line: 280, column: 1, scope: !976)
!981 = !DILocalVariable(name: "compare", arg: 2, scope: !976, file: !173, line: 280, type: !7)
!982 = !DILocalVariable(name: "set", arg: 3, scope: !976, file: !173, line: 280, type: !7)
!983 = !DILocalVariable(name: "previous", scope: !976, file: !173, line: 280, type: !7)
!984 = !{i64 2148864535}
!985 = distinct !DISubprogram(name: "ck_epoch_poll", scope: !6, file: !6, line: 619, type: !986, scopeLine: 620, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !120)
!986 = !DISubroutineType(types: !987)
!987 = !{!115, !17}
!988 = !DILocalVariable(name: "record", arg: 1, scope: !985, file: !6, line: 619, type: !17)
!989 = !DILocation(line: 619, column: 39, scope: !985)
!990 = !DILocation(line: 622, column: 32, scope: !985)
!991 = !DILocation(line: 622, column: 9, scope: !985)
!992 = !DILocation(line: 622, column: 2, scope: !985)
!993 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 46, type: !994, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !120)
!994 = !DISubroutineType(types: !995)
!995 = !{!12, !12, !996}
!996 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!997 = !DILocalVariable(name: "argc", arg: 1, scope: !993, file: !3, line: 46, type: !12)
!998 = !DILocation(line: 46, column: 14, scope: !993)
!999 = !DILocalVariable(name: "argv", arg: 2, scope: !993, file: !3, line: 46, type: !996)
!1000 = !DILocation(line: 46, column: 26, scope: !993)
!1001 = !DILocalVariable(name: "threads", scope: !993, file: !3, line: 48, type: !1002)
!1002 = !DICompositeType(tag: DW_TAG_array_type, baseType: !1003, size: 256, elements: !62)
!1003 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !1004, line: 31, baseType: !1005)
!1004 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!1005 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !1006, line: 118, baseType: !1007)
!1006 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!1007 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1008, size: 64)
!1008 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !1006, line: 103, size: 65536, elements: !1009)
!1009 = !{!1010, !1012, !1022}
!1010 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !1008, file: !1006, line: 104, baseType: !1011, size: 64)
!1011 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!1012 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !1008, file: !1006, line: 105, baseType: !1013, size: 64, offset: 64)
!1013 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1014, size: 64)
!1014 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !1006, line: 57, size: 192, elements: !1015)
!1015 = !{!1016, !1020, !1021}
!1016 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !1014, file: !1006, line: 58, baseType: !1017, size: 64)
!1017 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1018, size: 64)
!1018 = !DISubroutineType(types: !1019)
!1019 = !{null, !13}
!1020 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !1014, file: !1006, line: 59, baseType: !13, size: 64, offset: 64)
!1021 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !1014, file: !1006, line: 60, baseType: !1013, size: 64, offset: 128)
!1022 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !1008, file: !1006, line: 106, baseType: !1023, size: 65408, offset: 128)
!1023 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 65408, elements: !1024)
!1024 = !{!1025}
!1025 = !DISubrange(count: 8176)
!1026 = !DILocation(line: 48, column: 12, scope: !993)
!1027 = !DILocation(line: 50, column: 2, scope: !993)
!1028 = !DILocalVariable(name: "i", scope: !1029, file: !3, line: 52, type: !12)
!1029 = distinct !DILexicalBlock(scope: !993, file: !3, line: 52, column: 2)
!1030 = !DILocation(line: 52, column: 11, scope: !1029)
!1031 = !DILocation(line: 52, column: 7, scope: !1029)
!1032 = !DILocation(line: 52, column: 18, scope: !1033)
!1033 = distinct !DILexicalBlock(scope: !1029, file: !3, line: 52, column: 2)
!1034 = !DILocation(line: 52, column: 20, scope: !1033)
!1035 = !DILocation(line: 52, column: 2, scope: !1029)
!1036 = !DILocation(line: 54, column: 44, scope: !1037)
!1037 = distinct !DILexicalBlock(scope: !1033, file: !3, line: 53, column: 2)
!1038 = !DILocation(line: 54, column: 36, scope: !1037)
!1039 = !DILocation(line: 54, column: 3, scope: !1037)
!1040 = !DILocation(line: 55, column: 27, scope: !1037)
!1041 = !DILocation(line: 55, column: 19, scope: !1037)
!1042 = !DILocation(line: 55, column: 54, scope: !1037)
!1043 = !DILocation(line: 55, column: 46, scope: !1037)
!1044 = !DILocation(line: 55, column: 3, scope: !1037)
!1045 = !DILocation(line: 56, column: 2, scope: !1037)
!1046 = !DILocation(line: 52, column: 33, scope: !1033)
!1047 = !DILocation(line: 52, column: 2, scope: !1033)
!1048 = distinct !{!1048, !1035, !1049, !334}
!1049 = !DILocation(line: 56, column: 2, scope: !1029)
!1050 = !DILocalVariable(name: "i", scope: !1051, file: !3, line: 58, type: !12)
!1051 = distinct !DILexicalBlock(scope: !993, file: !3, line: 58, column: 2)
!1052 = !DILocation(line: 58, column: 11, scope: !1051)
!1053 = !DILocation(line: 58, column: 7, scope: !1051)
!1054 = !DILocation(line: 58, column: 18, scope: !1055)
!1055 = distinct !DILexicalBlock(scope: !1051, file: !3, line: 58, column: 2)
!1056 = !DILocation(line: 58, column: 20, scope: !1055)
!1057 = !DILocation(line: 58, column: 2, scope: !1051)
!1058 = !DILocation(line: 59, column: 24, scope: !1055)
!1059 = !DILocation(line: 59, column: 16, scope: !1055)
!1060 = !DILocation(line: 59, column: 3, scope: !1055)
!1061 = !DILocation(line: 58, column: 33, scope: !1055)
!1062 = !DILocation(line: 58, column: 2, scope: !1055)
!1063 = distinct !{!1063, !1057, !1064, !334}
!1064 = !DILocation(line: 59, column: 32, scope: !1051)
!1065 = !DILocation(line: 61, column: 2, scope: !993)
!1066 = distinct !DISubprogram(name: "thread", scope: !3, file: !3, line: 25, type: !1067, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!1067 = !DISubroutineType(types: !1068)
!1068 = !{!13, !13}
!1069 = !DILocalVariable(name: "arg", arg: 1, scope: !1066, file: !3, line: 25, type: !13)
!1070 = !DILocation(line: 25, column: 27, scope: !1066)
!1071 = !DILocalVariable(name: "record", scope: !1066, file: !3, line: 27, type: !81)
!1072 = !DILocation(line: 27, column: 21, scope: !1066)
!1073 = !DILocation(line: 27, column: 51, scope: !1066)
!1074 = !DILocation(line: 31, column: 17, scope: !1066)
!1075 = !DILocalVariable(name: "record", arg: 1, scope: !1076, file: !19, line: 126, type: !81)
!1076 = distinct !DISubprogram(name: "ck_epoch_begin", scope: !19, file: !19, line: 126, type: !1077, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!1077 = !DISubroutineType(types: !1078)
!1078 = !{null, !81, !1079}
!1079 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1080, size: 64)
!1080 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_epoch_section_t", file: !19, line: 72, baseType: !117)
!1081 = !DILocation(line: 126, column: 35, scope: !1076, inlinedAt: !1082)
!1082 = distinct !DILocation(line: 31, column: 2, scope: !1066)
!1083 = !DILocalVariable(name: "section", arg: 2, scope: !1076, file: !19, line: 126, type: !1079)
!1084 = !DILocation(line: 126, column: 63, scope: !1076, inlinedAt: !1082)
!1085 = !DILocalVariable(name: "epoch", scope: !1076, file: !19, line: 128, type: !29)
!1086 = !DILocation(line: 128, column: 19, scope: !1076, inlinedAt: !1082)
!1087 = !DILocation(line: 128, column: 27, scope: !1076, inlinedAt: !1082)
!1088 = !DILocation(line: 128, column: 35, scope: !1076, inlinedAt: !1082)
!1089 = !DILocation(line: 134, column: 6, scope: !1090, inlinedAt: !1082)
!1090 = distinct !DILexicalBlock(scope: !1076, file: !19, line: 134, column: 6)
!1091 = !DILocation(line: 134, column: 14, scope: !1090, inlinedAt: !1082)
!1092 = !DILocation(line: 134, column: 21, scope: !1090, inlinedAt: !1082)
!1093 = !DILocation(line: 134, column: 6, scope: !1076, inlinedAt: !1082)
!1094 = !DILocalVariable(name: "g_epoch", scope: !1095, file: !19, line: 135, type: !7)
!1095 = distinct !DILexicalBlock(scope: !1090, file: !19, line: 134, column: 27)
!1096 = !DILocation(line: 135, column: 16, scope: !1095, inlinedAt: !1082)
!1097 = !DILocation(line: 146, column: 3, scope: !1095, inlinedAt: !1082)
!1098 = !DILocation(line: 147, column: 3, scope: !1095, inlinedAt: !1082)
!1099 = !DILocation(line: 157, column: 13, scope: !1095, inlinedAt: !1082)
!1100 = !DILocation(line: 157, column: 11, scope: !1095, inlinedAt: !1082)
!1101 = !DILocation(line: 158, column: 3, scope: !1095, inlinedAt: !1082)
!1102 = !DILocation(line: 159, column: 2, scope: !1095, inlinedAt: !1082)
!1103 = !DILocation(line: 160, column: 3, scope: !1104, inlinedAt: !1082)
!1104 = distinct !DILexicalBlock(scope: !1090, file: !19, line: 159, column: 9)
!1105 = !DILocation(line: 163, column: 6, scope: !1106, inlinedAt: !1082)
!1106 = distinct !DILexicalBlock(scope: !1076, file: !19, line: 163, column: 6)
!1107 = !DILocation(line: 163, column: 14, scope: !1106, inlinedAt: !1082)
!1108 = !DILocation(line: 163, column: 6, scope: !1076, inlinedAt: !1082)
!1109 = !DILocation(line: 164, column: 20, scope: !1106, inlinedAt: !1082)
!1110 = !DILocation(line: 164, column: 28, scope: !1106, inlinedAt: !1082)
!1111 = !DILocation(line: 164, column: 3, scope: !1106, inlinedAt: !1082)
!1112 = !DILocalVariable(name: "global_epoch", scope: !1066, file: !3, line: 32, type: !12)
!1113 = !DILocation(line: 32, column: 6, scope: !1066)
!1114 = !DILocation(line: 32, column: 21, scope: !1066)
!1115 = !DILocalVariable(name: "local_epoch", scope: !1066, file: !3, line: 33, type: !12)
!1116 = !DILocation(line: 33, column: 6, scope: !1066)
!1117 = !DILocation(line: 33, column: 20, scope: !1066)
!1118 = !DILocation(line: 34, column: 15, scope: !1066)
!1119 = !DILocalVariable(name: "record", arg: 1, scope: !1120, file: !19, line: 174, type: !81)
!1120 = distinct !DISubprogram(name: "ck_epoch_end", scope: !19, file: !19, line: 174, type: !1121, scopeLine: 175, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!1121 = !DISubroutineType(types: !1122)
!1122 = !{!115, !81, !1079}
!1123 = !DILocation(line: 174, column: 33, scope: !1120, inlinedAt: !1124)
!1124 = distinct !DILocation(line: 34, column: 2, scope: !1066)
!1125 = !DILocalVariable(name: "section", arg: 2, scope: !1120, file: !19, line: 174, type: !1079)
!1126 = !DILocation(line: 174, column: 61, scope: !1120, inlinedAt: !1124)
!1127 = !DILocation(line: 177, column: 2, scope: !1120, inlinedAt: !1124)
!1128 = !DILocation(line: 178, column: 2, scope: !1120, inlinedAt: !1124)
!1129 = !DILocation(line: 180, column: 6, scope: !1130, inlinedAt: !1124)
!1130 = distinct !DILexicalBlock(scope: !1120, file: !19, line: 180, column: 6)
!1131 = !DILocation(line: 180, column: 14, scope: !1130, inlinedAt: !1124)
!1132 = !DILocation(line: 180, column: 6, scope: !1120, inlinedAt: !1124)
!1133 = !DILocation(line: 181, column: 27, scope: !1130, inlinedAt: !1124)
!1134 = !DILocation(line: 181, column: 35, scope: !1130, inlinedAt: !1124)
!1135 = !DILocation(line: 181, column: 10, scope: !1130, inlinedAt: !1124)
!1136 = !DILocation(line: 181, column: 3, scope: !1130, inlinedAt: !1124)
!1137 = !DILocation(line: 183, column: 9, scope: !1120, inlinedAt: !1124)
!1138 = !DILocation(line: 183, column: 17, scope: !1120, inlinedAt: !1124)
!1139 = !DILocation(line: 183, column: 24, scope: !1120, inlinedAt: !1124)
!1140 = !DILocation(line: 183, column: 2, scope: !1120, inlinedAt: !1124)
!1141 = !DILocation(line: 184, column: 1, scope: !1120, inlinedAt: !1124)
!1142 = !DILocation(line: 37, column: 2, scope: !1066)
!1143 = !DILocation(line: 0, scope: !1066)
!1144 = !DILocation(line: 39, column: 16, scope: !1066)
!1145 = !DILocation(line: 39, column: 2, scope: !1066)
!1146 = !DILocation(line: 41, column: 2, scope: !1066)
!1147 = distinct !DISubprogram(name: "ck_pr_fence_strict_acqrel", scope: !173, file: !173, line: 87, type: !248, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!1148 = !DILocation(line: 87, column: 1, scope: !1147)
!1149 = !{i64 2148854627}
!1150 = distinct !DISubprogram(name: "ck_pr_fence_strict_store", scope: !173, file: !173, line: 80, type: !248, scopeLine: 80, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!1151 = !DILocation(line: 80, column: 1, scope: !1150)
!1152 = !{i64 2148853223}
!1153 = distinct !DISubprogram(name: "ck_pr_fence_strict_load", scope: !173, file: !173, line: 82, type: !248, scopeLine: 82, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!1154 = !DILocation(line: 82, column: 1, scope: !1153)
!1155 = !{i64 2148853624}
!1156 = distinct !DISubprogram(name: "ck_pr_md_load_ptr", scope: !173, file: !173, line: 105, type: !1157, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!1157 = !DISubroutineType(types: !1158)
!1158 = !{!13, !362}
!1159 = !DILocalVariable(name: "target", arg: 1, scope: !1156, file: !173, line: 105, type: !362)
!1160 = !DILocation(line: 105, column: 1, scope: !1156)
!1161 = !DILocalVariable(name: "r", scope: !1156, file: !173, line: 105, type: !13)
!1162 = !{i64 2148855353}
!1163 = distinct !DISubprogram(name: "ck_pr_cas_ptr_value", scope: !173, file: !173, line: 177, type: !1164, scopeLine: 178, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!1164 = !DISubroutineType(types: !1165)
!1165 = !{!115, !13, !13, !13, !13}
!1166 = !DILocalVariable(name: "target", arg: 1, scope: !1163, file: !173, line: 177, type: !13)
!1167 = !DILocation(line: 177, column: 27, scope: !1163)
!1168 = !DILocalVariable(name: "compare", arg: 2, scope: !1163, file: !173, line: 177, type: !13)
!1169 = !DILocation(line: 177, column: 41, scope: !1163)
!1170 = !DILocalVariable(name: "set", arg: 3, scope: !1163, file: !173, line: 177, type: !13)
!1171 = !DILocation(line: 177, column: 56, scope: !1163)
!1172 = !DILocalVariable(name: "value", arg: 4, scope: !1163, file: !173, line: 177, type: !13)
!1173 = !DILocation(line: 177, column: 67, scope: !1163)
!1174 = !DILocalVariable(name: "previous", scope: !1163, file: !173, line: 179, type: !13)
!1175 = !DILocation(line: 179, column: 8, scope: !1163)
!1176 = !DILocation(line: 189, column: 42, scope: !1163)
!1177 = !DILocation(line: 190, column: 14, scope: !1163)
!1178 = !DILocation(line: 191, column: 42, scope: !1163)
!1179 = !DILocation(line: 181, column: 9, scope: !1163)
!1180 = !{i64 1359465}
!1181 = !DILocation(line: 194, column: 28, scope: !1163)
!1182 = !DILocation(line: 194, column: 35, scope: !1163)
!1183 = !DILocation(line: 194, column: 9, scope: !1163)
!1184 = !DILocation(line: 195, column: 17, scope: !1163)
!1185 = !DILocation(line: 195, column: 29, scope: !1163)
!1186 = !DILocation(line: 195, column: 26, scope: !1163)
!1187 = !DILocation(line: 195, column: 9, scope: !1163)
!1188 = distinct !DISubprogram(name: "ck_stack_batch_pop_upmc", scope: !23, file: !23, line: 151, type: !1189, scopeLine: 152, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!1189 = !DISubroutineType(types: !1190)
!1190 = !{!27, !270}
!1191 = !DILocalVariable(name: "target", arg: 1, scope: !1188, file: !23, line: 151, type: !270)
!1192 = !DILocation(line: 151, column: 42, scope: !1188)
!1193 = !DILocalVariable(name: "entry", scope: !1188, file: !23, line: 153, type: !27)
!1194 = !DILocation(line: 153, column: 25, scope: !1188)
!1195 = !DILocation(line: 155, column: 25, scope: !1188)
!1196 = !DILocation(line: 155, column: 33, scope: !1188)
!1197 = !DILocation(line: 155, column: 10, scope: !1188)
!1198 = !DILocation(line: 155, column: 8, scope: !1188)
!1199 = !DILocation(line: 156, column: 2, scope: !1188)
!1200 = !DILocation(line: 157, column: 9, scope: !1188)
!1201 = !DILocation(line: 157, column: 2, scope: !1188)
!1202 = distinct !DISubprogram(name: "ck_epoch_entry_container", scope: !6, file: !6, line: 145, type: !1203, scopeLine: 145, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!1203 = !DISubroutineType(types: !1204)
!1204 = !{!70, !292}
!1205 = !DILocalVariable(name: "p", arg: 1, scope: !1202, file: !6, line: 145, type: !292)
!1206 = !DILocation(line: 145, column: 1, scope: !1202)
!1207 = distinct !DISubprogram(name: "ck_stack_push_spnc", scope: !23, file: !23, line: 291, type: !434, scopeLine: 292, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!1208 = !DILocalVariable(name: "target", arg: 1, scope: !1207, file: !23, line: 291, type: !270)
!1209 = !DILocation(line: 291, column: 37, scope: !1207)
!1210 = !DILocalVariable(name: "entry", arg: 2, scope: !1207, file: !23, line: 291, type: !27)
!1211 = !DILocation(line: 291, column: 68, scope: !1207)
!1212 = !DILocation(line: 294, column: 16, scope: !1207)
!1213 = !DILocation(line: 294, column: 24, scope: !1207)
!1214 = !DILocation(line: 294, column: 2, scope: !1207)
!1215 = !DILocation(line: 294, column: 9, scope: !1207)
!1216 = !DILocation(line: 294, column: 14, scope: !1207)
!1217 = !DILocation(line: 295, column: 17, scope: !1207)
!1218 = !DILocation(line: 295, column: 2, scope: !1207)
!1219 = !DILocation(line: 295, column: 10, scope: !1207)
!1220 = !DILocation(line: 295, column: 15, scope: !1207)
!1221 = !DILocation(line: 296, column: 2, scope: !1207)
!1222 = distinct !DISubprogram(name: "ck_pr_add_uint", scope: !173, file: !173, line: 379, type: !174, scopeLine: 379, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!1223 = !DILocalVariable(name: "target", arg: 1, scope: !1222, file: !173, line: 379, type: !14)
!1224 = !DILocation(line: 379, column: 1, scope: !1222)
!1225 = !DILocalVariable(name: "delta", arg: 2, scope: !1222, file: !173, line: 379, type: !7)
!1226 = !DILocalVariable(name: "previous", scope: !1222, file: !173, line: 379, type: !7)
!1227 = !{i64 2148887622}
!1228 = distinct !DISubprogram(name: "ck_pr_sub_uint", scope: !173, file: !173, line: 379, type: !174, scopeLine: 379, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!1229 = !DILocalVariable(name: "target", arg: 1, scope: !1228, file: !173, line: 379, type: !14)
!1230 = !DILocation(line: 379, column: 1, scope: !1228)
!1231 = !DILocalVariable(name: "delta", arg: 2, scope: !1228, file: !173, line: 379, type: !7)
!1232 = !DILocalVariable(name: "previous", scope: !1228, file: !173, line: 379, type: !7)
!1233 = !{i64 2148888605}
!1234 = distinct !DISubprogram(name: "ck_pr_fas_ptr", scope: !173, file: !173, line: 306, type: !1235, scopeLine: 306, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !120)
!1235 = !DISubroutineType(types: !1236)
!1236 = !{!13, !13, !13}
!1237 = !DILocalVariable(name: "target", arg: 1, scope: !1234, file: !173, line: 306, type: !13)
!1238 = !DILocation(line: 306, column: 1, scope: !1234)
!1239 = !DILocalVariable(name: "v", arg: 2, scope: !1234, file: !173, line: 306, type: !13)
!1240 = !DILocalVariable(name: "previous", scope: !1234, file: !173, line: 306, type: !13)
!1241 = !{i64 2148867760}
!1242 = distinct !DISubprogram(name: "ck_pr_fence_strict_memory", scope: !173, file: !173, line: 84, type: !248, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!1243 = !DILocation(line: 84, column: 1, scope: !1242)
!1244 = !{i64 2148854028}
!1245 = distinct !DISubprogram(name: "ck_pr_fence_strict_atomic_load", scope: !173, file: !173, line: 77, type: !248, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!1246 = !DILocation(line: 77, column: 1, scope: !1245)
!1247 = !{i64 2148852602}
!1248 = distinct !DISubprogram(name: "ck_pr_fence_release", scope: !247, file: !247, line: 116, type: !248, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!1249 = !DILocation(line: 116, column: 1, scope: !1248)
!1250 = distinct !DISubprogram(name: "ck_pr_fence_strict_release", scope: !173, file: !173, line: 86, type: !248, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!1251 = !DILocation(line: 86, column: 1, scope: !1250)
!1252 = !{i64 2148854427}
