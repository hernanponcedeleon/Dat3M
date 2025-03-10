; ModuleID = 'tests/stack_empty.c'
source_filename = "tests/stack_empty.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_stack = type { ptr, ptr }
%struct.ck_stack_entry = type { ptr }

@stack = global %struct.ck_stack zeroinitializer, align 8
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str = private unnamed_addr constant [14 x i8] c"stack_empty.c\00", align 1
@.str.1 = private unnamed_addr constant [25 x i8] c"CK_STACK_ISEMPTY(&stack)\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @pusher_fn(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  store i32 0, ptr %3, align 4
  br label %5

5:                                                ; preds = %15, %1
  %6 = load i32, ptr %3, align 4
  %7 = icmp slt i32 %6, 2
  br i1 %7, label %8, label %18

8:                                                ; preds = %5
  %9 = call ptr @malloc(i64 noundef 8) #5
  store ptr %9, ptr %4, align 8
  %10 = load ptr, ptr %4, align 8
  %11 = icmp ne ptr %10, null
  br i1 %11, label %13, label %12

12:                                               ; preds = %8
  call void @exit(i32 noundef 1) #6
  unreachable

13:                                               ; preds = %8
  %14 = load ptr, ptr %4, align 8
  call void @ck_stack_push_upmc(ptr noundef @stack, ptr noundef %14)
  br label %15

15:                                               ; preds = %13
  %16 = load i32, ptr %3, align 4
  %17 = add nsw i32 %16, 1
  store i32 %17, ptr %3, align 4
  br label %5, !llvm.loop !6

18:                                               ; preds = %5
  ret ptr null
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
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
  br label %12, !llvm.loop !8

24:                                               ; preds = %12
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @popper_fn(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  br label %4

4:                                                ; preds = %7, %1
  %5 = call ptr @ck_stack_pop_upmc(ptr noundef @stack)
  store ptr %5, ptr %3, align 8
  %6 = icmp eq ptr %5, null
  br i1 %6, label %7, label %8

7:                                                ; preds = %4
  br label %4, !llvm.loop !9

8:                                                ; preds = %4
  %9 = load ptr, ptr %3, align 8
  call void @free(ptr noundef %9)
  ret ptr null
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_stack_pop_upmc(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct.ck_stack, ptr %6, i32 0, i32 0
  %8 = call ptr @ck_pr_md_load_ptr(ptr noundef %7)
  store ptr %8, ptr %4, align 8
  %9 = load ptr, ptr %4, align 8
  %10 = icmp eq ptr %9, null
  br i1 %10, label %11, label %12

11:                                               ; preds = %1
  store ptr null, ptr %2, align 8
  br label %34

12:                                               ; preds = %1
  call void @ck_pr_fence_load()
  %13 = load ptr, ptr %4, align 8
  %14 = getelementptr inbounds %struct.ck_stack_entry, ptr %13, i32 0, i32 0
  %15 = load ptr, ptr %14, align 8
  store ptr %15, ptr %5, align 8
  br label %16

16:                                               ; preds = %28, %12
  %17 = load ptr, ptr %3, align 8
  %18 = getelementptr inbounds %struct.ck_stack, ptr %17, i32 0, i32 0
  %19 = load ptr, ptr %4, align 8
  %20 = load ptr, ptr %5, align 8
  %21 = call zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %18, ptr noundef %19, ptr noundef %20, ptr noundef %4)
  %22 = zext i1 %21 to i32
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %24, label %32

24:                                               ; preds = %16
  %25 = load ptr, ptr %4, align 8
  %26 = icmp eq ptr %25, null
  br i1 %26, label %27, label %28

27:                                               ; preds = %24
  br label %32

28:                                               ; preds = %24
  call void @ck_pr_fence_load()
  %29 = load ptr, ptr %4, align 8
  %30 = getelementptr inbounds %struct.ck_stack_entry, ptr %29, i32 0, i32 0
  %31 = load ptr, ptr %30, align 8
  store ptr %31, ptr %5, align 8
  br label %16, !llvm.loop !10

32:                                               ; preds = %27, %16
  %33 = load ptr, ptr %4, align 8
  store ptr %33, ptr %2, align 8
  br label %34

34:                                               ; preds = %32, %11
  %35 = load ptr, ptr %2, align 8
  ret ptr %35
}

declare void @free(ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [1 x ptr], align 8
  %3 = alloca [2 x ptr], align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store i32 0, ptr %4, align 4
  br label %8

8:                                                ; preds = %19, %0
  %9 = load i32, ptr %4, align 4
  %10 = icmp slt i32 %9, 1
  br i1 %10, label %11, label %22

11:                                               ; preds = %8
  %12 = load i32, ptr %4, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds [1 x ptr], ptr %2, i64 0, i64 %13
  %15 = call i32 @pthread_create(ptr noundef %14, ptr noundef null, ptr noundef @pusher_fn, ptr noundef null)
  %16 = icmp ne i32 %15, 0
  br i1 %16, label %17, label %18

17:                                               ; preds = %11
  store i32 1, ptr %1, align 4
  br label %74

18:                                               ; preds = %11
  br label %19

19:                                               ; preds = %18
  %20 = load i32, ptr %4, align 4
  %21 = add nsw i32 %20, 1
  store i32 %21, ptr %4, align 4
  br label %8, !llvm.loop !11

22:                                               ; preds = %8
  store i32 0, ptr %5, align 4
  br label %23

23:                                               ; preds = %34, %22
  %24 = load i32, ptr %5, align 4
  %25 = icmp slt i32 %24, 2
  br i1 %25, label %26, label %37

26:                                               ; preds = %23
  %27 = load i32, ptr %5, align 4
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds [2 x ptr], ptr %3, i64 0, i64 %28
  %30 = call i32 @pthread_create(ptr noundef %29, ptr noundef null, ptr noundef @popper_fn, ptr noundef null)
  %31 = icmp ne i32 %30, 0
  br i1 %31, label %32, label %33

32:                                               ; preds = %26
  store i32 1, ptr %1, align 4
  br label %74

33:                                               ; preds = %26
  br label %34

34:                                               ; preds = %33
  %35 = load i32, ptr %5, align 4
  %36 = add nsw i32 %35, 1
  store i32 %36, ptr %5, align 4
  br label %23, !llvm.loop !12

37:                                               ; preds = %23
  store i32 0, ptr %6, align 4
  br label %38

38:                                               ; preds = %47, %37
  %39 = load i32, ptr %6, align 4
  %40 = icmp slt i32 %39, 1
  br i1 %40, label %41, label %50

41:                                               ; preds = %38
  %42 = load i32, ptr %6, align 4
  %43 = sext i32 %42 to i64
  %44 = getelementptr inbounds [1 x ptr], ptr %2, i64 0, i64 %43
  %45 = load ptr, ptr %44, align 8
  %46 = call i32 @"\01_pthread_join"(ptr noundef %45, ptr noundef null)
  br label %47

47:                                               ; preds = %41
  %48 = load i32, ptr %6, align 4
  %49 = add nsw i32 %48, 1
  store i32 %49, ptr %6, align 4
  br label %38, !llvm.loop !13

50:                                               ; preds = %38
  store i32 0, ptr %7, align 4
  br label %51

51:                                               ; preds = %60, %50
  %52 = load i32, ptr %7, align 4
  %53 = icmp slt i32 %52, 2
  br i1 %53, label %54, label %63

54:                                               ; preds = %51
  %55 = load i32, ptr %7, align 4
  %56 = sext i32 %55 to i64
  %57 = getelementptr inbounds [2 x ptr], ptr %3, i64 0, i64 %56
  %58 = load ptr, ptr %57, align 8
  %59 = call i32 @"\01_pthread_join"(ptr noundef %58, ptr noundef null)
  br label %60

60:                                               ; preds = %54
  %61 = load i32, ptr %7, align 4
  %62 = add nsw i32 %61, 1
  store i32 %62, ptr %7, align 4
  br label %51, !llvm.loop !14

63:                                               ; preds = %51
  %64 = load ptr, ptr @stack, align 8
  %65 = icmp eq ptr %64, null
  %66 = xor i1 %65, true
  %67 = zext i1 %66 to i32
  %68 = sext i32 %67 to i64
  %69 = icmp ne i64 %68, 0
  br i1 %69, label %70, label %72

70:                                               ; preds = %63
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 73, ptr noundef @.str.1) #7
  unreachable

71:                                               ; No predecessors!
  br label %73

72:                                               ; preds = %63
  br label %73

73:                                               ; preds = %72, %71
  store i32 0, ptr %1, align 4
  br label %74

74:                                               ; preds = %73, %32, %17
  %75 = load i32, ptr %1, align 4
  ret i32 %75
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #3

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
  store i64 0, ptr %3, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = call i64 asm sideeffect "ldr $0, [$1]\0A", "=r,r,~{memory}"(ptr %4) #8, !srcloc !15
  store i64 %5, ptr %3, align 8
  %6 = load i64, ptr %3, align 8
  %7 = inttoptr i64 %6 to ptr
  ret ptr %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_store() #0 {
  call void @ck_pr_fence_strict_store()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
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
  %14 = call { ptr, ptr } asm sideeffect "1:\0Aldxr $0, [$2]\0Acmp  $0, $4\0Ab.ne 2f\0Astxr ${1:w}, $3, [$2]\0Acbnz ${1:w}, 1b\0A2:", "=&r,=&r,r,r,r,~{memory},~{cc}"(ptr %11, ptr %12, ptr %13) #8, !srcloc !16
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

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_store() #0 {
  call void asm sideeffect "dmb ishst", "r,~{memory}"(i32 0) #8, !srcloc !17
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_load() #0 {
  call void @ck_pr_fence_strict_load()
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_load() #0 {
  call void asm sideeffect "dmb ishld", "r,~{memory}"(i32 0) #8, !srcloc !18
  ret void
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

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 0]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Homebrew clang version 19.1.7"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = distinct !{!12, !7}
!13 = distinct !{!13, !7}
!14 = distinct !{!14, !7}
!15 = !{i64 2148649152}
!16 = !{i64 2148670575, i64 2148670625, i64 2148670692, i64 2148670758, i64 2148670811, i64 2148670883, i64 2148670941}
!17 = !{i64 2148646388}
!18 = !{i64 2148646931}
