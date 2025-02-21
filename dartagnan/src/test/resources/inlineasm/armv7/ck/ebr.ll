; ModuleID = 'client-code.c'
source_filename = "client-code.c"
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

@stack_epoch = internal global %struct.ck_epoch zeroinitializer, align 8
@records = global [4 x %struct.ck_epoch_record] zeroinitializer, align 64
@__func__.thread = private unnamed_addr constant [7 x i8] c"thread\00", align 1
@.str = private unnamed_addr constant [14 x i8] c"client-code.c\00", align 1
@.str.1 = private unnamed_addr constant [41 x i8] c"!(local_epoch == 1 && global_epoch == 3)\00", align 1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define zeroext i1 @_ck_epoch_delref(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca i1, align 1
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  %9 = load ptr, ptr %5, align 8
  %10 = getelementptr inbounds %struct.ck_epoch_section, ptr %9, i32 0, i32 0
  %11 = load i32, ptr %10, align 4
  store i32 %11, ptr %8, align 4
  %12 = load ptr, ptr %4, align 8
  %13 = getelementptr inbounds %struct.ck_epoch_record, ptr %12, i32 0, i32 6
  %14 = getelementptr inbounds %struct.anon, ptr %13, i32 0, i32 0
  %15 = load i32, ptr %8, align 4
  %16 = zext i32 %15 to i64
  %17 = getelementptr inbounds [2 x %struct.ck_epoch_ref], ptr %14, i64 0, i64 %16
  store ptr %17, ptr %6, align 8
  %18 = load ptr, ptr %6, align 8
  %19 = getelementptr inbounds %struct.ck_epoch_ref, ptr %18, i32 0, i32 1
  %20 = load i32, ptr %19, align 4
  %21 = add i32 %20, -1
  store i32 %21, ptr %19, align 4
  %22 = load ptr, ptr %6, align 8
  %23 = getelementptr inbounds %struct.ck_epoch_ref, ptr %22, i32 0, i32 1
  %24 = load i32, ptr %23, align 4
  %25 = icmp ugt i32 %24, 0
  br i1 %25, label %26, label %27

26:                                               ; preds = %2
  store i1 false, ptr %3, align 1
  br label %56

27:                                               ; preds = %2
  %28 = load ptr, ptr %4, align 8
  %29 = getelementptr inbounds %struct.ck_epoch_record, ptr %28, i32 0, i32 6
  %30 = getelementptr inbounds %struct.anon, ptr %29, i32 0, i32 0
  %31 = load i32, ptr %8, align 4
  %32 = add i32 %31, 1
  %33 = and i32 %32, 1
  %34 = zext i32 %33 to i64
  %35 = getelementptr inbounds [2 x %struct.ck_epoch_ref], ptr %30, i64 0, i64 %34
  store ptr %35, ptr %7, align 8
  %36 = load ptr, ptr %7, align 8
  %37 = getelementptr inbounds %struct.ck_epoch_ref, ptr %36, i32 0, i32 1
  %38 = load i32, ptr %37, align 4
  %39 = icmp ugt i32 %38, 0
  br i1 %39, label %40, label %55

40:                                               ; preds = %27
  %41 = load ptr, ptr %6, align 8
  %42 = getelementptr inbounds %struct.ck_epoch_ref, ptr %41, i32 0, i32 0
  %43 = load i32, ptr %42, align 4
  %44 = load ptr, ptr %7, align 8
  %45 = getelementptr inbounds %struct.ck_epoch_ref, ptr %44, i32 0, i32 0
  %46 = load i32, ptr %45, align 4
  %47 = sub i32 %43, %46
  %48 = icmp slt i32 %47, 0
  br i1 %48, label %49, label %55

49:                                               ; preds = %40
  %50 = load ptr, ptr %4, align 8
  %51 = getelementptr inbounds %struct.ck_epoch_record, ptr %50, i32 0, i32 3
  %52 = load ptr, ptr %7, align 8
  %53 = getelementptr inbounds %struct.ck_epoch_ref, ptr %52, i32 0, i32 0
  %54 = load i32, ptr %53, align 4
  call void @ck_pr_md_store_uint(ptr noundef %51, i32 noundef %54)
  br label %55

55:                                               ; preds = %49, %40, %27
  store i1 true, ptr %3, align 1
  br label %56

56:                                               ; preds = %55, %26
  %57 = load i1, ptr %3, align 1
  ret i1 %57
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8
  %6 = load i32, ptr %4, align 4
  call void asm sideeffect "str $1, [$0]", "r,r,~{memory}"(ptr %5, i32 %6) #5, !srcloc !6
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @_ck_epoch_addref(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %10 = load ptr, ptr %3, align 8
  %11 = getelementptr inbounds %struct.ck_epoch_record, ptr %10, i32 0, i32 1
  %12 = load ptr, ptr %11, align 8
  store ptr %12, ptr %5, align 8
  %13 = load ptr, ptr %5, align 8
  %14 = getelementptr inbounds %struct.ck_epoch, ptr %13, i32 0, i32 0
  %15 = call i32 @ck_pr_md_load_uint(ptr noundef %14)
  store i32 %15, ptr %7, align 4
  %16 = load i32, ptr %7, align 4
  %17 = and i32 %16, 1
  store i32 %17, ptr %8, align 4
  %18 = load ptr, ptr %3, align 8
  %19 = getelementptr inbounds %struct.ck_epoch_record, ptr %18, i32 0, i32 6
  %20 = getelementptr inbounds %struct.anon, ptr %19, i32 0, i32 0
  %21 = load i32, ptr %8, align 4
  %22 = zext i32 %21 to i64
  %23 = getelementptr inbounds [2 x %struct.ck_epoch_ref], ptr %20, i64 0, i64 %22
  store ptr %23, ptr %6, align 8
  %24 = load ptr, ptr %6, align 8
  %25 = getelementptr inbounds %struct.ck_epoch_ref, ptr %24, i32 0, i32 1
  %26 = load i32, ptr %25, align 4
  %27 = add i32 %26, 1
  store i32 %27, ptr %25, align 4
  %28 = icmp eq i32 %26, 0
  br i1 %28, label %29, label %47

29:                                               ; preds = %2
  %30 = load ptr, ptr %3, align 8
  %31 = getelementptr inbounds %struct.ck_epoch_record, ptr %30, i32 0, i32 6
  %32 = getelementptr inbounds %struct.anon, ptr %31, i32 0, i32 0
  %33 = load i32, ptr %8, align 4
  %34 = add i32 %33, 1
  %35 = and i32 %34, 1
  %36 = zext i32 %35 to i64
  %37 = getelementptr inbounds [2 x %struct.ck_epoch_ref], ptr %32, i64 0, i64 %36
  store ptr %37, ptr %9, align 8
  %38 = load ptr, ptr %9, align 8
  %39 = getelementptr inbounds %struct.ck_epoch_ref, ptr %38, i32 0, i32 1
  %40 = load i32, ptr %39, align 4
  %41 = icmp ugt i32 %40, 0
  br i1 %41, label %42, label %43

42:                                               ; preds = %29
  call void @ck_pr_fence_acqrel()
  br label %43

43:                                               ; preds = %42, %29
  %44 = load i32, ptr %7, align 4
  %45 = load ptr, ptr %6, align 8
  %46 = getelementptr inbounds %struct.ck_epoch_ref, ptr %45, i32 0, i32 0
  store i32 %44, ptr %46, align 4
  br label %47

47:                                               ; preds = %43, %2
  %48 = load i32, ptr %8, align 4
  %49 = load ptr, ptr %4, align 8
  %50 = getelementptr inbounds %struct.ck_epoch_section, ptr %49, i32 0, i32 0
  store i32 %48, ptr %50, align 4
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal i32 @ck_pr_md_load_uint(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  store i64 0, ptr %3, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = call i64 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #5, !srcloc !7
  store i64 %5, ptr %3, align 8
  %6 = load i64, ptr %3, align 8
  %7 = trunc i64 %6 to i32
  ret i32 %7
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_fence_acqrel() #0 {
  call void @ck_pr_fence_strict_acqrel()
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @ck_epoch_init(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct.ck_epoch, ptr %3, i32 0, i32 2
  call void @ck_stack_init(ptr noundef %4)
  %5 = load ptr, ptr %2, align 8
  %6 = getelementptr inbounds %struct.ck_epoch, ptr %5, i32 0, i32 0
  store i32 1, ptr %6, align 8
  %7 = load ptr, ptr %2, align 8
  %8 = getelementptr inbounds %struct.ck_epoch, ptr %7, i32 0, i32 1
  store i32 0, ptr %8, align 4
  call void @ck_pr_fence_store()
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_stack_init(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct.ck_stack, ptr %3, i32 0, i32 0
  store ptr null, ptr %4, align 8
  %5 = load ptr, ptr %2, align 8
  %6 = getelementptr inbounds %struct.ck_stack, ptr %5, i32 0, i32 1
  store ptr null, ptr %6, align 8
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_fence_store() #0 {
  call void @ck_pr_fence_strict_store()
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @ck_epoch_recycle(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  %9 = load ptr, ptr %4, align 8
  %10 = getelementptr inbounds %struct.ck_epoch, ptr %9, i32 0, i32 1
  %11 = call i32 @ck_pr_md_load_uint(ptr noundef %10)
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %13, label %14

13:                                               ; preds = %2
  store ptr null, ptr %3, align 8
  br label %49

14:                                               ; preds = %2
  %15 = load ptr, ptr %4, align 8
  %16 = getelementptr inbounds %struct.ck_epoch, ptr %15, i32 0, i32 2
  %17 = getelementptr inbounds %struct.ck_stack, ptr %16, i32 0, i32 0
  %18 = load ptr, ptr %17, align 8
  store ptr %18, ptr %7, align 8
  br label %19

19:                                               ; preds = %44, %14
  %20 = load ptr, ptr %7, align 8
  %21 = icmp ne ptr %20, null
  br i1 %21, label %22, label %48

22:                                               ; preds = %19
  %23 = load ptr, ptr %7, align 8
  %24 = call ptr @ck_epoch_record_container(ptr noundef %23)
  store ptr %24, ptr %6, align 8
  %25 = load ptr, ptr %6, align 8
  %26 = getelementptr inbounds %struct.ck_epoch_record, ptr %25, i32 0, i32 2
  %27 = call i32 @ck_pr_md_load_uint(ptr noundef %26)
  %28 = icmp eq i32 %27, 1
  br i1 %28, label %29, label %43

29:                                               ; preds = %22
  call void @ck_pr_fence_load()
  %30 = load ptr, ptr %6, align 8
  %31 = getelementptr inbounds %struct.ck_epoch_record, ptr %30, i32 0, i32 2
  %32 = call i32 @ck_pr_fas_uint(ptr noundef %31, i32 noundef 0)
  store i32 %32, ptr %8, align 4
  %33 = load i32, ptr %8, align 4
  %34 = icmp eq i32 %33, 1
  br i1 %34, label %35, label %42

35:                                               ; preds = %29
  %36 = load ptr, ptr %4, align 8
  %37 = getelementptr inbounds %struct.ck_epoch, ptr %36, i32 0, i32 1
  call void @ck_pr_dec_uint(ptr noundef %37)
  %38 = load ptr, ptr %6, align 8
  %39 = getelementptr inbounds %struct.ck_epoch_record, ptr %38, i32 0, i32 10
  %40 = load ptr, ptr %5, align 8
  call void @ck_pr_md_store_ptr(ptr noundef %39, ptr noundef %40)
  %41 = load ptr, ptr %6, align 8
  store ptr %41, ptr %3, align 8
  br label %49

42:                                               ; preds = %29
  br label %43

43:                                               ; preds = %42, %22
  br label %44

44:                                               ; preds = %43
  %45 = load ptr, ptr %7, align 8
  %46 = getelementptr inbounds %struct.ck_stack_entry, ptr %45, i32 0, i32 0
  %47 = load ptr, ptr %46, align 8
  store ptr %47, ptr %7, align 8
  br label %19, !llvm.loop !8

48:                                               ; preds = %19
  store ptr null, ptr %3, align 8
  br label %49

49:                                               ; preds = %48, %35, %13
  %50 = load ptr, ptr %3, align 8
  ret ptr %50
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal ptr @ck_epoch_record_container(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds i8, ptr %3, i64 0
  ret ptr %4
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_fence_load() #0 {
  call void @ck_pr_fence_strict_load()
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal i32 @ck_pr_fas_uint(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  store i32 0, ptr %5, align 4
  store i32 0, ptr %6, align 4
  %7 = load i32, ptr %5, align 4
  %8 = load i32, ptr %6, align 4
  %9 = load ptr, ptr %3, align 8
  %10 = load i32, ptr %4, align 4
  %11 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];strex $1, $3, [$2];cmp $1, #0;bne 1b;", "=&r,=&r,r,r,0,1,~{memory},~{cc}"(ptr %9, i32 %10, i32 %7, i32 %8) #5, !srcloc !10
  %12 = extractvalue { i32, i32 } %11, 0
  %13 = extractvalue { i32, i32 } %11, 1
  store i32 %12, ptr %5, align 4
  store i32 %13, ptr %6, align 4
  %14 = load i32, ptr %5, align 4
  ret i32 %14
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_dec_uint(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  store i32 0, ptr %3, align 4
  store i32 0, ptr %4, align 4
  %5 = load i32, ptr %3, align 4
  %6 = load i32, ptr %4, align 4
  %7 = load ptr, ptr %2, align 8
  %8 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];sub $0, $0, #1;strex $1, $0, [$2];cmp   $1, #0;bne   1b;", "=&r,=&r,r,0,1,~{memory},~{cc}"(ptr %7, i32 %5, i32 %6) #5, !srcloc !11
  %9 = extractvalue { i32, i32 } %8, 0
  %10 = extractvalue { i32, i32 } %8, 1
  store i32 %9, ptr %3, align 4
  store i32 %10, ptr %4, align 4
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_md_store_ptr(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8
  %6 = load ptr, ptr %4, align 8
  call void asm sideeffect "str $1, [$0]", "r,r,~{memory}"(ptr %5, ptr %6) #5, !srcloc !12
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @ck_epoch_register(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i64, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store ptr %2, ptr %6, align 8
  %8 = load ptr, ptr %4, align 8
  %9 = load ptr, ptr %5, align 8
  %10 = getelementptr inbounds %struct.ck_epoch_record, ptr %9, i32 0, i32 1
  store ptr %8, ptr %10, align 8
  %11 = load ptr, ptr %5, align 8
  %12 = getelementptr inbounds %struct.ck_epoch_record, ptr %11, i32 0, i32 2
  store i32 0, ptr %12, align 16
  %13 = load ptr, ptr %5, align 8
  %14 = getelementptr inbounds %struct.ck_epoch_record, ptr %13, i32 0, i32 4
  store i32 0, ptr %14, align 8
  %15 = load ptr, ptr %5, align 8
  %16 = getelementptr inbounds %struct.ck_epoch_record, ptr %15, i32 0, i32 3
  store i32 0, ptr %16, align 4
  %17 = load ptr, ptr %5, align 8
  %18 = getelementptr inbounds %struct.ck_epoch_record, ptr %17, i32 0, i32 9
  store i32 0, ptr %18, align 8
  %19 = load ptr, ptr %5, align 8
  %20 = getelementptr inbounds %struct.ck_epoch_record, ptr %19, i32 0, i32 8
  store i32 0, ptr %20, align 4
  %21 = load ptr, ptr %5, align 8
  %22 = getelementptr inbounds %struct.ck_epoch_record, ptr %21, i32 0, i32 7
  store i32 0, ptr %22, align 16
  %23 = load ptr, ptr %6, align 8
  %24 = load ptr, ptr %5, align 8
  %25 = getelementptr inbounds %struct.ck_epoch_record, ptr %24, i32 0, i32 10
  store ptr %23, ptr %25, align 32
  %26 = load ptr, ptr %5, align 8
  %27 = getelementptr inbounds %struct.ck_epoch_record, ptr %26, i32 0, i32 6
  %28 = load ptr, ptr %5, align 8
  %29 = getelementptr inbounds %struct.ck_epoch_record, ptr %28, i32 0, i32 6
  %30 = call i64 @llvm.objectsize.i64.p0(ptr %29, i1 false, i1 true, i1 false)
  %31 = call ptr @__memset_chk(ptr noundef %27, i32 noundef 0, i64 noundef 16, i64 noundef %30) #5
  store i64 0, ptr %7, align 8
  br label %32

32:                                               ; preds = %40, %3
  %33 = load i64, ptr %7, align 8
  %34 = icmp ult i64 %33, 4
  br i1 %34, label %35, label %43

35:                                               ; preds = %32
  %36 = load ptr, ptr %5, align 8
  %37 = getelementptr inbounds %struct.ck_epoch_record, ptr %36, i32 0, i32 11
  %38 = load i64, ptr %7, align 8
  %39 = getelementptr inbounds [4 x %struct.ck_stack], ptr %37, i64 0, i64 %38
  call void @ck_stack_init(ptr noundef %39)
  br label %40

40:                                               ; preds = %35
  %41 = load i64, ptr %7, align 8
  %42 = add i64 %41, 1
  store i64 %42, ptr %7, align 8
  br label %32, !llvm.loop !13

43:                                               ; preds = %32
  call void @ck_pr_fence_store()
  %44 = load ptr, ptr %4, align 8
  %45 = getelementptr inbounds %struct.ck_epoch, ptr %44, i32 0, i32 2
  %46 = load ptr, ptr %5, align 8
  %47 = getelementptr inbounds %struct.ck_epoch_record, ptr %46, i32 0, i32 0
  call void @ck_stack_push_upmc(ptr noundef %45, ptr noundef %47)
  ret void
}

; Function Attrs: nounwind
declare ptr @__memset_chk(ptr noundef, i32 noundef, i64 noundef, i64 noundef) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.objectsize.i64.p0(ptr, i1 immarg, i1 immarg, i1 immarg) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_stack_push_upmc(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct.ck_stack, ptr %6, i32 0, i32 0
  %8 = call ptr @ck_pr_md_load_ptr(ptr noundef %7)
  store ptr %8, ptr %5, align 8
  %9 = load ptr, ptr %5, align 8
  %10 = load ptr, ptr %4, align 8
  %11 = getelementptr inbounds %struct.ck_stack_entry, ptr %10, i32 0, i32 0
  store ptr %9, ptr %11, align 8
  call void @ck_pr_fence_store()
  br label %12

12:                                               ; preds = %20, %2
  %13 = load ptr, ptr %3, align 8
  %14 = getelementptr inbounds %struct.ck_stack, ptr %13, i32 0, i32 0
  %15 = load ptr, ptr %5, align 8
  %16 = load ptr, ptr %4, align 8
  %17 = call zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %14, ptr noundef %15, ptr noundef %16, ptr noundef %5)
  %18 = zext i1 %17 to i32
  %19 = icmp eq i32 %18, 0
  br i1 %19, label %20, label %24

20:                                               ; preds = %12
  %21 = load ptr, ptr %5, align 8
  %22 = load ptr, ptr %4, align 8
  %23 = getelementptr inbounds %struct.ck_stack_entry, ptr %22, i32 0, i32 0
  store ptr %21, ptr %23, align 8
  call void @ck_pr_fence_store()
  br label %12, !llvm.loop !14

24:                                               ; preds = %12
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @ck_epoch_unregister(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8
  %6 = getelementptr inbounds %struct.ck_epoch_record, ptr %5, i32 0, i32 1
  %7 = load ptr, ptr %6, align 8
  store ptr %7, ptr %3, align 8
  %8 = load ptr, ptr %2, align 8
  %9 = getelementptr inbounds %struct.ck_epoch_record, ptr %8, i32 0, i32 4
  store i32 0, ptr %9, align 8
  %10 = load ptr, ptr %2, align 8
  %11 = getelementptr inbounds %struct.ck_epoch_record, ptr %10, i32 0, i32 3
  store i32 0, ptr %11, align 4
  %12 = load ptr, ptr %2, align 8
  %13 = getelementptr inbounds %struct.ck_epoch_record, ptr %12, i32 0, i32 9
  store i32 0, ptr %13, align 8
  %14 = load ptr, ptr %2, align 8
  %15 = getelementptr inbounds %struct.ck_epoch_record, ptr %14, i32 0, i32 8
  store i32 0, ptr %15, align 4
  %16 = load ptr, ptr %2, align 8
  %17 = getelementptr inbounds %struct.ck_epoch_record, ptr %16, i32 0, i32 7
  store i32 0, ptr %17, align 16
  %18 = load ptr, ptr %2, align 8
  %19 = getelementptr inbounds %struct.ck_epoch_record, ptr %18, i32 0, i32 6
  %20 = load ptr, ptr %2, align 8
  %21 = getelementptr inbounds %struct.ck_epoch_record, ptr %20, i32 0, i32 6
  %22 = call i64 @llvm.objectsize.i64.p0(ptr %21, i1 false, i1 true, i1 false)
  %23 = call ptr @__memset_chk(ptr noundef %19, i32 noundef 0, i64 noundef 16, i64 noundef %22) #5
  store i64 0, ptr %4, align 8
  br label %24

24:                                               ; preds = %32, %1
  %25 = load i64, ptr %4, align 8
  %26 = icmp ult i64 %25, 4
  br i1 %26, label %27, label %35

27:                                               ; preds = %24
  %28 = load ptr, ptr %2, align 8
  %29 = getelementptr inbounds %struct.ck_epoch_record, ptr %28, i32 0, i32 11
  %30 = load i64, ptr %4, align 8
  %31 = getelementptr inbounds [4 x %struct.ck_stack], ptr %29, i64 0, i64 %30
  call void @ck_stack_init(ptr noundef %31)
  br label %32

32:                                               ; preds = %27
  %33 = load i64, ptr %4, align 8
  %34 = add i64 %33, 1
  store i64 %34, ptr %4, align 8
  br label %24, !llvm.loop !15

35:                                               ; preds = %24
  %36 = load ptr, ptr %2, align 8
  %37 = getelementptr inbounds %struct.ck_epoch_record, ptr %36, i32 0, i32 10
  call void @ck_pr_md_store_ptr(ptr noundef %37, ptr noundef null)
  call void @ck_pr_fence_store()
  %38 = load ptr, ptr %2, align 8
  %39 = getelementptr inbounds %struct.ck_epoch_record, ptr %38, i32 0, i32 2
  call void @ck_pr_md_store_uint(ptr noundef %39, i32 noundef 1)
  %40 = load ptr, ptr %3, align 8
  %41 = getelementptr inbounds %struct.ck_epoch, ptr %40, i32 0, i32 1
  call void @ck_pr_inc_uint(ptr noundef %41)
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_inc_uint(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  store i32 0, ptr %3, align 4
  store i32 0, ptr %4, align 4
  %5 = load i32, ptr %3, align 4
  %6 = load i32, ptr %4, align 4
  %7 = load ptr, ptr %2, align 8
  %8 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];add $0, $0, #1;strex $1, $0, [$2];cmp   $1, #0;bne   1b;", "=&r,=&r,r,0,1,~{memory},~{cc}"(ptr %7, i32 %5, i32 %6) #5, !srcloc !16
  %9 = extractvalue { i32, i32 } %8, 0
  %10 = extractvalue { i32, i32 } %8, 1
  store i32 %9, ptr %3, align 4
  store i32 %10, ptr %4, align 4
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @ck_epoch_reclaim(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  store i32 0, ptr %3, align 4
  br label %4

4:                                                ; preds = %11, %1
  %5 = load i32, ptr %3, align 4
  %6 = icmp ult i32 %5, 4
  br i1 %6, label %7, label %14

7:                                                ; preds = %4
  %8 = load ptr, ptr %2, align 8
  %9 = load i32, ptr %3, align 4
  %10 = call i32 @ck_epoch_dispatch(ptr noundef %8, i32 noundef %9, ptr noundef null)
  br label %11

11:                                               ; preds = %7
  %12 = load i32, ptr %3, align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr %3, align 4
  br label %4, !llvm.loop !17

14:                                               ; preds = %4
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal i32 @ck_epoch_dispatch(ptr noundef %0, i32 noundef %1, ptr noundef %2) #0 {
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
  %15 = load i32, ptr %5, align 4
  %16 = and i32 %15, 3
  store i32 %16, ptr %7, align 4
  store i32 0, ptr %13, align 4
  %17 = load ptr, ptr %4, align 8
  %18 = getelementptr inbounds %struct.ck_epoch_record, ptr %17, i32 0, i32 11
  %19 = load i32, ptr %7, align 4
  %20 = zext i32 %19 to i64
  %21 = getelementptr inbounds [4 x %struct.ck_stack], ptr %18, i64 0, i64 %20
  %22 = call ptr @ck_stack_batch_pop_upmc(ptr noundef %21)
  store ptr %22, ptr %8, align 8
  %23 = load ptr, ptr %8, align 8
  store ptr %23, ptr %10, align 8
  br label %24

24:                                               ; preds = %47, %3
  %25 = load ptr, ptr %10, align 8
  %26 = icmp ne ptr %25, null
  br i1 %26, label %27, label %49

27:                                               ; preds = %24
  %28 = load ptr, ptr %10, align 8
  %29 = call ptr @ck_epoch_entry_container(ptr noundef %28)
  store ptr %29, ptr %14, align 8
  %30 = load ptr, ptr %10, align 8
  %31 = getelementptr inbounds %struct.ck_stack_entry, ptr %30, i32 0, i32 0
  %32 = load ptr, ptr %31, align 8
  store ptr %32, ptr %9, align 8
  %33 = load ptr, ptr %6, align 8
  %34 = icmp ne ptr %33, null
  br i1 %34, label %35, label %39

35:                                               ; preds = %27
  %36 = load ptr, ptr %6, align 8
  %37 = load ptr, ptr %14, align 8
  %38 = getelementptr inbounds %struct.ck_epoch_entry, ptr %37, i32 0, i32 1
  call void @ck_stack_push_spnc(ptr noundef %36, ptr noundef %38)
  br label %44

39:                                               ; preds = %27
  %40 = load ptr, ptr %14, align 8
  %41 = getelementptr inbounds %struct.ck_epoch_entry, ptr %40, i32 0, i32 0
  %42 = load ptr, ptr %41, align 8
  %43 = load ptr, ptr %14, align 8
  call void %42(ptr noundef %43)
  br label %44

44:                                               ; preds = %39, %35
  %45 = load i32, ptr %13, align 4
  %46 = add i32 %45, 1
  store i32 %46, ptr %13, align 4
  br label %47

47:                                               ; preds = %44
  %48 = load ptr, ptr %9, align 8
  store ptr %48, ptr %10, align 8
  br label %24, !llvm.loop !18

49:                                               ; preds = %24
  %50 = load ptr, ptr %4, align 8
  %51 = getelementptr inbounds %struct.ck_epoch_record, ptr %50, i32 0, i32 8
  %52 = call i32 @ck_pr_md_load_uint(ptr noundef %51)
  store i32 %52, ptr %12, align 4
  %53 = load ptr, ptr %4, align 8
  %54 = getelementptr inbounds %struct.ck_epoch_record, ptr %53, i32 0, i32 7
  %55 = call i32 @ck_pr_md_load_uint(ptr noundef %54)
  store i32 %55, ptr %11, align 4
  %56 = load i32, ptr %11, align 4
  %57 = load i32, ptr %12, align 4
  %58 = icmp ugt i32 %56, %57
  br i1 %58, label %59, label %63

59:                                               ; preds = %49
  %60 = load ptr, ptr %4, align 8
  %61 = getelementptr inbounds %struct.ck_epoch_record, ptr %60, i32 0, i32 8
  %62 = load i32, ptr %12, align 4
  call void @ck_pr_md_store_uint(ptr noundef %61, i32 noundef %62)
  br label %63

63:                                               ; preds = %59, %49
  %64 = load i32, ptr %13, align 4
  %65 = icmp ugt i32 %64, 0
  br i1 %65, label %66, label %73

66:                                               ; preds = %63
  %67 = load ptr, ptr %4, align 8
  %68 = getelementptr inbounds %struct.ck_epoch_record, ptr %67, i32 0, i32 9
  %69 = load i32, ptr %13, align 4
  call void @ck_pr_add_uint(ptr noundef %68, i32 noundef %69)
  %70 = load ptr, ptr %4, align 8
  %71 = getelementptr inbounds %struct.ck_epoch_record, ptr %70, i32 0, i32 7
  %72 = load i32, ptr %13, align 4
  call void @ck_pr_sub_uint(ptr noundef %71, i32 noundef %72)
  br label %73

73:                                               ; preds = %66, %63
  %74 = load i32, ptr %13, align 4
  ret i32 %74
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @ck_epoch_synchronize_wait(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
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
  call void @ck_pr_fence_memory()
  %23 = load ptr, ptr %12, align 8
  %24 = getelementptr inbounds %struct.ck_epoch, ptr %23, i32 0, i32 0
  %25 = call i32 @ck_pr_md_load_uint(ptr noundef %24)
  store i32 %25, ptr %17, align 4
  store i32 %25, ptr %16, align 4
  %26 = load i32, ptr %17, align 4
  %27 = add i32 %26, 3
  store i32 %27, ptr %18, align 4
  store i32 0, ptr %19, align 4
  store ptr null, ptr %15, align 8
  br label %28

28:                                               ; preds = %105, %3
  %29 = load i32, ptr %19, align 4
  %30 = icmp ult i32 %29, 2
  br i1 %30, label %31, label %108

31:                                               ; preds = %28
  br label %32

32:                                               ; preds = %59, %31
  %33 = load ptr, ptr %12, align 8
  %34 = load ptr, ptr %15, align 8
  %35 = load i32, ptr %16, align 4
  %36 = call ptr @ck_epoch_scan(ptr noundef %33, ptr noundef %34, i32 noundef %35, ptr noundef %20)
  store ptr %36, ptr %15, align 8
  %37 = load ptr, ptr %15, align 8
  %38 = icmp ne ptr %37, null
  br i1 %38, label %39, label %86

39:                                               ; preds = %32
  call void @ck_pr_stall()
  %40 = load ptr, ptr %12, align 8
  %41 = getelementptr inbounds %struct.ck_epoch, ptr %40, i32 0, i32 0
  %42 = call i32 @ck_pr_md_load_uint(ptr noundef %41)
  store i32 %42, ptr %22, align 4
  %43 = load i32, ptr %22, align 4
  %44 = load i32, ptr %16, align 4
  %45 = icmp eq i32 %43, %44
  br i1 %45, label %46, label %60

46:                                               ; preds = %39
  %47 = load ptr, ptr %12, align 8
  %48 = load ptr, ptr %15, align 8
  %49 = load ptr, ptr %13, align 8
  %50 = load ptr, ptr %14, align 8
  store ptr %47, ptr %4, align 8
  store ptr %48, ptr %5, align 8
  store ptr %49, ptr %6, align 8
  store ptr %50, ptr %7, align 8
  %51 = load ptr, ptr %6, align 8
  %52 = icmp ne ptr %51, null
  br i1 %52, label %53, label %58

53:                                               ; preds = %46
  %54 = load ptr, ptr %6, align 8
  %55 = load ptr, ptr %4, align 8
  %56 = load ptr, ptr %5, align 8
  %57 = load ptr, ptr %7, align 8
  call void %54(ptr noundef %55, ptr noundef %56, ptr noundef %57) #5
  br label %58

58:                                               ; preds = %46, %53
  br label %59

59:                                               ; preds = %58, %85
  br label %32, !llvm.loop !19

60:                                               ; preds = %39
  %61 = load i32, ptr %22, align 4
  store i32 %61, ptr %16, align 4
  %62 = load i32, ptr %18, align 4
  %63 = load i32, ptr %17, align 4
  %64 = icmp ugt i32 %62, %63
  %65 = zext i1 %64 to i32
  %66 = load i32, ptr %16, align 4
  %67 = load i32, ptr %18, align 4
  %68 = icmp uge i32 %66, %67
  %69 = zext i1 %68 to i32
  %70 = and i32 %65, %69
  %71 = icmp ne i32 %70, 0
  br i1 %71, label %72, label %73

72:                                               ; preds = %60
  br label %110

73:                                               ; preds = %60
  %74 = load ptr, ptr %12, align 8
  %75 = load ptr, ptr %15, align 8
  %76 = load ptr, ptr %13, align 8
  %77 = load ptr, ptr %14, align 8
  store ptr %74, ptr %8, align 8
  store ptr %75, ptr %9, align 8
  store ptr %76, ptr %10, align 8
  store ptr %77, ptr %11, align 8
  %78 = load ptr, ptr %10, align 8
  %79 = icmp ne ptr %78, null
  br i1 %79, label %80, label %85

80:                                               ; preds = %73
  %81 = load ptr, ptr %10, align 8
  %82 = load ptr, ptr %8, align 8
  %83 = load ptr, ptr %9, align 8
  %84 = load ptr, ptr %11, align 8
  call void %81(ptr noundef %82, ptr noundef %83, ptr noundef %84) #5
  br label %85

85:                                               ; preds = %73, %80
  store ptr null, ptr %15, align 8
  br label %59

86:                                               ; preds = %32
  %87 = load i8, ptr %20, align 1
  %88 = trunc i8 %87 to i1
  %89 = zext i1 %88 to i32
  %90 = icmp eq i32 %89, 0
  br i1 %90, label %91, label %92

91:                                               ; preds = %86
  br label %109

92:                                               ; preds = %86
  %93 = load ptr, ptr %12, align 8
  %94 = getelementptr inbounds %struct.ck_epoch, ptr %93, i32 0, i32 0
  %95 = load i32, ptr %16, align 4
  %96 = load i32, ptr %16, align 4
  %97 = add i32 %96, 1
  %98 = call zeroext i1 @ck_pr_cas_uint_value(ptr noundef %94, i32 noundef %95, i32 noundef %97, ptr noundef %16)
  %99 = zext i1 %98 to i8
  store i8 %99, ptr %21, align 1
  call void @ck_pr_fence_atomic_load()
  %100 = load i32, ptr %16, align 4
  %101 = load i8, ptr %21, align 1
  %102 = trunc i8 %101 to i1
  %103 = zext i1 %102 to i32
  %104 = add i32 %100, %103
  store i32 %104, ptr %16, align 4
  br label %105

105:                                              ; preds = %92
  store ptr null, ptr %15, align 8
  %106 = load i32, ptr %19, align 4
  %107 = add i32 %106, 1
  store i32 %107, ptr %19, align 4
  br label %28, !llvm.loop !20

108:                                              ; preds = %28
  br label %109

109:                                              ; preds = %108, %91
  br label %110

110:                                              ; preds = %109, %72
  call void @ck_pr_fence_memory()
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_fence_memory() #0 {
  call void @ck_pr_fence_strict_memory()
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal ptr @ck_epoch_scan(ptr noundef %0, ptr noundef %1, i32 noundef %2, ptr noundef %3) #0 {
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
  %13 = load ptr, ptr %7, align 8
  %14 = icmp eq ptr %13, null
  br i1 %14, label %15, label %21

15:                                               ; preds = %4
  %16 = load ptr, ptr %6, align 8
  %17 = getelementptr inbounds %struct.ck_epoch, ptr %16, i32 0, i32 2
  %18 = getelementptr inbounds %struct.ck_stack, ptr %17, i32 0, i32 0
  %19 = load ptr, ptr %18, align 8
  store ptr %19, ptr %10, align 8
  %20 = load ptr, ptr %9, align 8
  store i8 0, ptr %20, align 1
  br label %25

21:                                               ; preds = %4
  %22 = load ptr, ptr %7, align 8
  %23 = getelementptr inbounds %struct.ck_epoch_record, ptr %22, i32 0, i32 0
  store ptr %23, ptr %10, align 8
  %24 = load ptr, ptr %9, align 8
  store i8 1, ptr %24, align 1
  br label %25

25:                                               ; preds = %21, %15
  br label %26

26:                                               ; preds = %42, %25
  %27 = load ptr, ptr %10, align 8
  %28 = icmp ne ptr %27, null
  br i1 %28, label %29, label %69

29:                                               ; preds = %26
  %30 = load ptr, ptr %10, align 8
  %31 = call ptr @ck_epoch_record_container(ptr noundef %30)
  store ptr %31, ptr %7, align 8
  %32 = load ptr, ptr %7, align 8
  %33 = getelementptr inbounds %struct.ck_epoch_record, ptr %32, i32 0, i32 2
  %34 = call i32 @ck_pr_md_load_uint(ptr noundef %33)
  store i32 %34, ptr %11, align 4
  %35 = load i32, ptr %11, align 4
  %36 = and i32 %35, 1
  %37 = icmp ne i32 %36, 0
  br i1 %37, label %38, label %43

38:                                               ; preds = %29
  %39 = load ptr, ptr %10, align 8
  %40 = getelementptr inbounds %struct.ck_stack_entry, ptr %39, i32 0, i32 0
  %41 = load ptr, ptr %40, align 8
  store ptr %41, ptr %10, align 8
  br label %42

42:                                               ; preds = %38, %65
  br label %26, !llvm.loop !21

43:                                               ; preds = %29
  %44 = load ptr, ptr %7, align 8
  %45 = getelementptr inbounds %struct.ck_epoch_record, ptr %44, i32 0, i32 4
  %46 = call i32 @ck_pr_md_load_uint(ptr noundef %45)
  store i32 %46, ptr %12, align 4
  %47 = load i32, ptr %12, align 4
  %48 = load ptr, ptr %9, align 8
  %49 = load i8, ptr %48, align 1
  %50 = trunc i8 %49 to i1
  %51 = zext i1 %50 to i32
  %52 = or i32 %51, %47
  %53 = icmp ne i32 %52, 0
  %54 = zext i1 %53 to i8
  store i8 %54, ptr %48, align 1
  %55 = load i32, ptr %12, align 4
  %56 = icmp ne i32 %55, 0
  br i1 %56, label %57, label %65

57:                                               ; preds = %43
  %58 = load ptr, ptr %7, align 8
  %59 = getelementptr inbounds %struct.ck_epoch_record, ptr %58, i32 0, i32 3
  %60 = call i32 @ck_pr_md_load_uint(ptr noundef %59)
  %61 = load i32, ptr %8, align 4
  %62 = icmp ne i32 %60, %61
  br i1 %62, label %63, label %65

63:                                               ; preds = %57
  %64 = load ptr, ptr %7, align 8
  store ptr %64, ptr %5, align 8
  br label %70

65:                                               ; preds = %57, %43
  %66 = load ptr, ptr %10, align 8
  %67 = getelementptr inbounds %struct.ck_stack_entry, ptr %66, i32 0, i32 0
  %68 = load ptr, ptr %67, align 8
  store ptr %68, ptr %10, align 8
  br label %42

69:                                               ; preds = %26
  store ptr null, ptr %5, align 8
  br label %70

70:                                               ; preds = %69, %63
  %71 = load ptr, ptr %5, align 8
  ret ptr %71
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_stall() #0 {
  call void asm sideeffect "", "~{memory}"() #5, !srcloc !22
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal zeroext i1 @ck_pr_cas_uint_value(ptr noundef %0, i32 noundef %1, i32 noundef %2, ptr noundef %3) #0 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store i32 %1, ptr %6, align 4
  store i32 %2, ptr %7, align 4
  store ptr %3, ptr %8, align 8
  store i32 0, ptr %9, align 4
  store i32 0, ptr %10, align 4
  %11 = load i32, ptr %9, align 4
  %12 = load i32, ptr %10, align 4
  %13 = load ptr, ptr %5, align 8
  %14 = load i32, ptr %7, align 4
  %15 = load i32, ptr %6, align 4
  %16 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];cmp   $0, $4;itt eq;strexeq $1, $3, [$2];cmpeq   $1, #1;beq   1b;", "=&r,=&r,r,r,r,0,1,~{memory},~{cc}"(ptr %13, i32 %14, i32 %15, i32 %11, i32 %12) #5, !srcloc !23
  %17 = extractvalue { i32, i32 } %16, 0
  %18 = extractvalue { i32, i32 } %16, 1
  store i32 %17, ptr %9, align 4
  store i32 %18, ptr %10, align 4
  %19 = load i32, ptr %9, align 4
  %20 = load ptr, ptr %8, align 8
  store i32 %19, ptr %20, align 4
  %21 = load i32, ptr %9, align 4
  %22 = load i32, ptr %6, align 4
  %23 = icmp eq i32 %21, %22
  ret i1 %23
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_fence_atomic_load() #0 {
  call void @ck_pr_fence_strict_atomic_load()
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @ck_epoch_synchronize(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct.ck_epoch_record, ptr %3, i32 0, i32 1
  %5 = load ptr, ptr %4, align 8
  call void @ck_epoch_synchronize_wait(ptr noundef %5, ptr noundef null, ptr noundef null)
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @ck_epoch_barrier(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  call void @ck_epoch_synchronize(ptr noundef %3)
  %4 = load ptr, ptr %2, align 8
  call void @ck_epoch_reclaim(ptr noundef %4)
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @ck_epoch_barrier_wait(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store ptr %2, ptr %6, align 8
  %7 = load ptr, ptr %4, align 8
  %8 = getelementptr inbounds %struct.ck_epoch_record, ptr %7, i32 0, i32 1
  %9 = load ptr, ptr %8, align 8
  %10 = load ptr, ptr %5, align 8
  %11 = load ptr, ptr %6, align 8
  call void @ck_epoch_synchronize_wait(ptr noundef %9, ptr noundef %10, ptr noundef %11)
  %12 = load ptr, ptr %4, align 8
  call void @ck_epoch_reclaim(ptr noundef %12)
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define zeroext i1 @ck_epoch_poll_deferred(ptr noundef %0, ptr noundef %1) #0 {
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
  store ptr null, ptr %8, align 8
  %11 = load ptr, ptr %4, align 8
  %12 = getelementptr inbounds %struct.ck_epoch_record, ptr %11, i32 0, i32 1
  %13 = load ptr, ptr %12, align 8
  store ptr %13, ptr %9, align 8
  %14 = load ptr, ptr %9, align 8
  %15 = getelementptr inbounds %struct.ck_epoch, ptr %14, i32 0, i32 0
  %16 = call i32 @ck_pr_md_load_uint(ptr noundef %15)
  store i32 %16, ptr %7, align 4
  call void @ck_pr_fence_memory()
  %17 = load ptr, ptr %4, align 8
  %18 = load i32, ptr %7, align 4
  %19 = sub i32 %18, 2
  %20 = load ptr, ptr %5, align 8
  %21 = call i32 @ck_epoch_dispatch(ptr noundef %17, i32 noundef %19, ptr noundef %20)
  store i32 %21, ptr %10, align 4
  %22 = load ptr, ptr %9, align 8
  %23 = load ptr, ptr %8, align 8
  %24 = load i32, ptr %7, align 4
  %25 = call ptr @ck_epoch_scan(ptr noundef %22, ptr noundef %23, i32 noundef %24, ptr noundef %6)
  store ptr %25, ptr %8, align 8
  %26 = load ptr, ptr %8, align 8
  %27 = icmp ne ptr %26, null
  br i1 %27, label %28, label %31

28:                                               ; preds = %2
  %29 = load i32, ptr %10, align 4
  %30 = icmp ugt i32 %29, 0
  store i1 %30, ptr %3, align 1
  br label %64

31:                                               ; preds = %2
  %32 = load i8, ptr %6, align 1
  %33 = trunc i8 %32 to i1
  %34 = zext i1 %33 to i32
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %36, label %52

36:                                               ; preds = %31
  %37 = load i32, ptr %7, align 4
  %38 = load ptr, ptr %4, align 8
  %39 = getelementptr inbounds %struct.ck_epoch_record, ptr %38, i32 0, i32 3
  store i32 %37, ptr %39, align 4
  store i32 0, ptr %7, align 4
  br label %40

40:                                               ; preds = %48, %36
  %41 = load i32, ptr %7, align 4
  %42 = icmp ult i32 %41, 4
  br i1 %42, label %43, label %51

43:                                               ; preds = %40
  %44 = load ptr, ptr %4, align 8
  %45 = load i32, ptr %7, align 4
  %46 = load ptr, ptr %5, align 8
  %47 = call i32 @ck_epoch_dispatch(ptr noundef %44, i32 noundef %45, ptr noundef %46)
  br label %48

48:                                               ; preds = %43
  %49 = load i32, ptr %7, align 4
  %50 = add i32 %49, 1
  store i32 %50, ptr %7, align 4
  br label %40, !llvm.loop !24

51:                                               ; preds = %40
  store i1 true, ptr %3, align 1
  br label %64

52:                                               ; preds = %31
  %53 = load ptr, ptr %9, align 8
  %54 = getelementptr inbounds %struct.ck_epoch, ptr %53, i32 0, i32 0
  %55 = load i32, ptr %7, align 4
  %56 = load i32, ptr %7, align 4
  %57 = add i32 %56, 1
  %58 = call zeroext i1 @ck_pr_cas_uint(ptr noundef %54, i32 noundef %55, i32 noundef %57)
  %59 = load ptr, ptr %4, align 8
  %60 = load i32, ptr %7, align 4
  %61 = sub i32 %60, 1
  %62 = load ptr, ptr %5, align 8
  %63 = call i32 @ck_epoch_dispatch(ptr noundef %59, i32 noundef %61, ptr noundef %62)
  store i1 true, ptr %3, align 1
  br label %64

64:                                               ; preds = %52, %51, %28
  %65 = load i1, ptr %3, align 1
  ret i1 %65
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal zeroext i1 @ck_pr_cas_uint(ptr noundef %0, i32 noundef %1, i32 noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store i32 %1, ptr %5, align 4
  store i32 %2, ptr %6, align 4
  store i32 0, ptr %7, align 4
  store i32 0, ptr %8, align 4
  %9 = load i32, ptr %7, align 4
  %10 = load i32, ptr %8, align 4
  %11 = load ptr, ptr %4, align 8
  %12 = load i32, ptr %6, align 4
  %13 = load i32, ptr %5, align 4
  %14 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];cmp   $0, $4;itt eq;strexeq $1, $3, [$2];cmpeq   $1, #1;beq   1b;", "=&r,=&r,r,r,r,0,1,~{memory},~{cc}"(ptr %11, i32 %12, i32 %13, i32 %9, i32 %10) #5, !srcloc !25
  %15 = extractvalue { i32, i32 } %14, 0
  %16 = extractvalue { i32, i32 } %14, 1
  store i32 %15, ptr %7, align 4
  store i32 %16, ptr %8, align 4
  %17 = load i32, ptr %7, align 4
  %18 = load i32, ptr %5, align 4
  %19 = icmp eq i32 %17, %18
  ret i1 %19
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define zeroext i1 @ck_epoch_poll(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = call zeroext i1 @ck_epoch_poll_deferred(ptr noundef %3, ptr noundef null)
  ret i1 %4
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main(i32 noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca [4 x ptr], align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  store ptr %1, ptr %5, align 8
  call void @ck_epoch_init(ptr noundef @stack_epoch)
  store i32 0, ptr %7, align 4
  br label %9

9:                                                ; preds = %23, %2
  %10 = load i32, ptr %7, align 4
  %11 = icmp slt i32 %10, 4
  br i1 %11, label %12, label %26

12:                                               ; preds = %9
  %13 = load i32, ptr %7, align 4
  %14 = sext i32 %13 to i64
  %15 = getelementptr inbounds [4 x %struct.ck_epoch_record], ptr @records, i64 0, i64 %14
  call void @ck_epoch_register(ptr noundef @stack_epoch, ptr noundef %15, ptr noundef null)
  %16 = load i32, ptr %7, align 4
  %17 = sext i32 %16 to i64
  %18 = getelementptr inbounds [4 x ptr], ptr %6, i64 0, i64 %17
  %19 = load i32, ptr %7, align 4
  %20 = sext i32 %19 to i64
  %21 = getelementptr inbounds [4 x %struct.ck_epoch_record], ptr @records, i64 0, i64 %20
  %22 = call i32 @pthread_create(ptr noundef %18, ptr noundef null, ptr noundef @thread, ptr noundef %21)
  br label %23

23:                                               ; preds = %12
  %24 = load i32, ptr %7, align 4
  %25 = add nsw i32 %24, 1
  store i32 %25, ptr %7, align 4
  br label %9, !llvm.loop !26

26:                                               ; preds = %9
  store i32 0, ptr %8, align 4
  br label %27

27:                                               ; preds = %36, %26
  %28 = load i32, ptr %8, align 4
  %29 = icmp slt i32 %28, 4
  br i1 %29, label %30, label %39

30:                                               ; preds = %27
  %31 = load i32, ptr %8, align 4
  %32 = sext i32 %31 to i64
  %33 = getelementptr inbounds [4 x ptr], ptr %6, i64 0, i64 %32
  %34 = load ptr, ptr %33, align 8
  %35 = call i32 @"\01_pthread_join"(ptr noundef %34, ptr noundef null)
  br label %36

36:                                               ; preds = %30
  %37 = load i32, ptr %8, align 4
  %38 = add nsw i32 %37, 1
  store i32 %38, ptr %8, align 4
  br label %27, !llvm.loop !27

39:                                               ; preds = %27
  ret i32 0
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal ptr @thread(ptr noundef %0) #0 {
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
  %13 = load ptr, ptr %9, align 8
  store ptr %13, ptr %10, align 8
  %14 = load ptr, ptr %10, align 8
  store ptr %14, ptr %5, align 8
  store ptr null, ptr %6, align 8
  %15 = load ptr, ptr %5, align 8
  %16 = getelementptr inbounds %struct.ck_epoch_record, ptr %15, i32 0, i32 1
  %17 = load ptr, ptr %16, align 8
  store ptr %17, ptr %7, align 8
  %18 = load ptr, ptr %5, align 8
  %19 = getelementptr inbounds %struct.ck_epoch_record, ptr %18, i32 0, i32 4
  %20 = load i32, ptr %19, align 8
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %22, label %30

22:                                               ; preds = %1
  %23 = load ptr, ptr %5, align 8
  %24 = getelementptr inbounds %struct.ck_epoch_record, ptr %23, i32 0, i32 4
  call void @ck_pr_md_store_uint(ptr noundef %24, i32 noundef 1)
  call void @ck_pr_fence_memory()
  %25 = load ptr, ptr %7, align 8
  %26 = call i32 @ck_pr_md_load_uint(ptr noundef %25)
  store i32 %26, ptr %8, align 4
  %27 = load ptr, ptr %5, align 8
  %28 = getelementptr inbounds %struct.ck_epoch_record, ptr %27, i32 0, i32 3
  %29 = load i32, ptr %8, align 4
  call void @ck_pr_md_store_uint(ptr noundef %28, i32 noundef %29)
  br label %37

30:                                               ; preds = %1
  %31 = load ptr, ptr %5, align 8
  %32 = getelementptr inbounds %struct.ck_epoch_record, ptr %31, i32 0, i32 4
  %33 = load ptr, ptr %5, align 8
  %34 = getelementptr inbounds %struct.ck_epoch_record, ptr %33, i32 0, i32 4
  %35 = load i32, ptr %34, align 8
  %36 = add i32 %35, 1
  call void @ck_pr_md_store_uint(ptr noundef %32, i32 noundef %36)
  br label %37

37:                                               ; preds = %30, %22
  %38 = load ptr, ptr %6, align 8
  %39 = icmp ne ptr %38, null
  br i1 %39, label %40, label %43

40:                                               ; preds = %37
  %41 = load ptr, ptr %5, align 8
  %42 = load ptr, ptr %6, align 8
  call void @_ck_epoch_addref(ptr noundef %41, ptr noundef %42)
  br label %43

43:                                               ; preds = %37, %40
  %44 = call i32 @ck_pr_md_load_uint(ptr noundef @stack_epoch)
  store i32 %44, ptr %11, align 4
  %45 = load ptr, ptr %10, align 8
  %46 = getelementptr inbounds %struct.ck_epoch_record, ptr %45, i32 0, i32 3
  %47 = call i32 @ck_pr_md_load_uint(ptr noundef %46)
  store i32 %47, ptr %12, align 4
  %48 = load ptr, ptr %10, align 8
  store ptr %48, ptr %3, align 8
  store ptr null, ptr %4, align 8
  call void @ck_pr_fence_release()
  %49 = load ptr, ptr %3, align 8
  %50 = getelementptr inbounds %struct.ck_epoch_record, ptr %49, i32 0, i32 4
  %51 = load ptr, ptr %3, align 8
  %52 = getelementptr inbounds %struct.ck_epoch_record, ptr %51, i32 0, i32 4
  %53 = load i32, ptr %52, align 8
  %54 = sub i32 %53, 1
  call void @ck_pr_md_store_uint(ptr noundef %50, i32 noundef %54)
  %55 = load ptr, ptr %4, align 8
  %56 = icmp ne ptr %55, null
  br i1 %56, label %57, label %61

57:                                               ; preds = %43
  %58 = load ptr, ptr %3, align 8
  %59 = load ptr, ptr %4, align 8
  %60 = call zeroext i1 @_ck_epoch_delref(ptr noundef %58, ptr noundef %59)
  store i1 %60, ptr %2, align 1
  br label %66

61:                                               ; preds = %43
  %62 = load ptr, ptr %3, align 8
  %63 = getelementptr inbounds %struct.ck_epoch_record, ptr %62, i32 0, i32 4
  %64 = load i32, ptr %63, align 8
  %65 = icmp eq i32 %64, 0
  store i1 %65, ptr %2, align 1
  br label %66

66:                                               ; preds = %57, %61
  %67 = load i1, ptr %2, align 1
  %68 = load i32, ptr %12, align 4
  %69 = icmp eq i32 %68, 1
  br i1 %69, label %70, label %73

70:                                               ; preds = %66
  %71 = load i32, ptr %11, align 4
  %72 = icmp eq i32 %71, 3
  br label %73

73:                                               ; preds = %70, %66
  %74 = phi i1 [ false, %66 ], [ %72, %70 ]
  %75 = xor i1 %74, true
  %76 = xor i1 %75, true
  %77 = zext i1 %76 to i32
  %78 = sext i32 %77 to i64
  %79 = icmp ne i64 %78, 0
  br i1 %79, label %80, label %82

80:                                               ; preds = %73
  call void @__assert_rtn(ptr noundef @__func__.thread, ptr noundef @.str, i32 noundef 39, ptr noundef @.str.1) #6
  unreachable

81:                                               ; No predecessors!
  br label %83

82:                                               ; preds = %73
  br label %83

83:                                               ; preds = %82, %81
  %84 = load ptr, ptr %10, align 8
  %85 = call zeroext i1 @ck_epoch_poll(ptr noundef %84)
  ret ptr null
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #3

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_fence_strict_acqrel() #0 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #5, !srcloc !28
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_fence_strict_store() #0 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #5, !srcloc !29
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_fence_strict_load() #0 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #5, !srcloc !30
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  store i64 0, ptr %3, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = call i64 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #5, !srcloc !31
  store i64 %5, ptr %3, align 8
  %6 = load i64, ptr %3, align 8
  %7 = inttoptr i64 %6 to ptr
  ret ptr %7
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store ptr %2, ptr %7, align 8
  store ptr %3, ptr %8, align 8
  %11 = load ptr, ptr %5, align 8
  %12 = load ptr, ptr %7, align 8
  %13 = load ptr, ptr %6, align 8
  %14 = call { ptr, ptr } asm sideeffect "1:ldrex $0, [$2];cmp   $0, $4;itt eq;strexeq $1, $3, [$2];cmpeq   $1, #1;beq   1b;", "=&r,=&r,r,r,r,~{memory},~{cc}"(ptr %11, ptr %12, ptr %13) #5, !srcloc !32
  %15 = extractvalue { ptr, ptr } %14, 0
  %16 = extractvalue { ptr, ptr } %14, 1
  store ptr %15, ptr %9, align 8
  store ptr %16, ptr %10, align 8
  %17 = load ptr, ptr %9, align 8
  %18 = load ptr, ptr %8, align 8
  store ptr %17, ptr %18, align 8
  %19 = load ptr, ptr %9, align 8
  %20 = load ptr, ptr %6, align 8
  %21 = icmp eq ptr %19, %20
  ret i1 %21
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal ptr @ck_stack_batch_pop_upmc(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.ck_stack, ptr %4, i32 0, i32 0
  %6 = call ptr @ck_pr_fas_ptr(ptr noundef %5, ptr noundef null)
  store ptr %6, ptr %3, align 8
  call void @ck_pr_fence_load()
  %7 = load ptr, ptr %3, align 8
  ret ptr %7
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal ptr @ck_epoch_entry_container(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds i8, ptr %3, i64 -8
  ret ptr %4
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_stack_push_spnc(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8
  %6 = getelementptr inbounds %struct.ck_stack, ptr %5, i32 0, i32 0
  %7 = load ptr, ptr %6, align 8
  %8 = load ptr, ptr %4, align 8
  %9 = getelementptr inbounds %struct.ck_stack_entry, ptr %8, i32 0, i32 0
  store ptr %7, ptr %9, align 8
  %10 = load ptr, ptr %4, align 8
  %11 = load ptr, ptr %3, align 8
  %12 = getelementptr inbounds %struct.ck_stack, ptr %11, i32 0, i32 0
  store ptr %10, ptr %12, align 8
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_add_uint(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  store i32 0, ptr %5, align 4
  store i32 0, ptr %6, align 4
  %7 = load i32, ptr %5, align 4
  %8 = load i32, ptr %6, align 4
  %9 = load ptr, ptr %3, align 8
  %10 = load i32, ptr %4, align 4
  %11 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];add $0, $0, $3;strex $1, $0, [$2];cmp $1, #0;bne 1b;", "=&r,=&r,r,r,0,1,~{memory},~{cc}"(ptr %9, i32 %10, i32 %7, i32 %8) #5, !srcloc !33
  %12 = extractvalue { i32, i32 } %11, 0
  %13 = extractvalue { i32, i32 } %11, 1
  store i32 %12, ptr %5, align 4
  store i32 %13, ptr %6, align 4
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_sub_uint(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  store i32 0, ptr %5, align 4
  store i32 0, ptr %6, align 4
  %7 = load i32, ptr %5, align 4
  %8 = load i32, ptr %6, align 4
  %9 = load ptr, ptr %3, align 8
  %10 = load i32, ptr %4, align 4
  %11 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];sub $0, $0, $3;strex $1, $0, [$2];cmp $1, #0;bne 1b;", "=&r,=&r,r,r,0,1,~{memory},~{cc}"(ptr %9, i32 %10, i32 %7, i32 %8) #5, !srcloc !34
  %12 = extractvalue { i32, i32 } %11, 0
  %13 = extractvalue { i32, i32 } %11, 1
  store i32 %12, ptr %5, align 4
  store i32 %13, ptr %6, align 4
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal ptr @ck_pr_fas_ptr(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  store ptr null, ptr %5, align 8
  store ptr null, ptr %6, align 8
  %7 = load ptr, ptr %5, align 8
  %8 = load ptr, ptr %6, align 8
  %9 = load ptr, ptr %3, align 8
  %10 = load ptr, ptr %4, align 8
  %11 = call { ptr, ptr } asm sideeffect "1:ldrex $0, [$2];strex $1, $3, [$2];cmp $1, #0;bne 1b;", "=&r,=&r,r,r,0,1,~{memory},~{cc}"(ptr %9, ptr %10, ptr %7, ptr %8) #5, !srcloc !35
  %12 = extractvalue { ptr, ptr } %11, 0
  %13 = extractvalue { ptr, ptr } %11, 1
  store ptr %12, ptr %5, align 8
  store ptr %13, ptr %6, align 8
  %14 = load ptr, ptr %5, align 8
  ret ptr %14
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_fence_strict_memory() #0 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #5, !srcloc !36
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_fence_strict_atomic_load() #0 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #5, !srcloc !37
  ret void
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_fence_release() #0 {
  call void @ck_pr_fence_strict_release()
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @ck_pr_fence_strict_release() #0 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #5, !srcloc !38
  ret void
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #4 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #5 = { nounwind }
attributes #6 = { cold noreturn }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 0]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Homebrew clang version 19.1.7"}
!6 = !{i64 2148879565}
!7 = !{i64 2148874314}
!8 = distinct !{!8, !9}
!9 = !{!"llvm.loop.mustprogress"}
!10 = !{i64 2148904684}
!11 = !{i64 2148920583}
!12 = !{i64 2148877012}
!13 = distinct !{!13, !9}
!14 = distinct !{!14, !9}
!15 = distinct !{!15, !9}
!16 = !{i64 2148919486}
!17 = distinct !{!17, !9}
!18 = distinct !{!18, !9}
!19 = distinct !{!19, !9}
!20 = distinct !{!20, !9}
!21 = distinct !{!21, !9}
!22 = !{i64 1356330}
!23 = !{i64 2148884654}
!24 = distinct !{!24, !9}
!25 = !{i64 2148886112}
!26 = distinct !{!26, !9}
!27 = distinct !{!27, !9}
!28 = !{i64 2148870162}
!29 = !{i64 2148868208}
!30 = !{i64 2148868767}
!31 = !{i64 2148871412}
!32 = !{i64 1367220}
!33 = !{i64 2148960106}
!34 = !{i64 2148962302}
!35 = !{i64 2148902561}
!36 = !{i64 2148869327}
!37 = !{i64 2148867337}
!38 = !{i64 2148869884}
