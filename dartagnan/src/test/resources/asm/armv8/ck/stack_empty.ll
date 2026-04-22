; ModuleID = 'benchmarks/ck/stack_empty.c'
source_filename = "benchmarks/ck/stack_empty.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv8a-pc-linux-gnu"

%struct.ck_stack = type { ptr, ptr }
%struct.ck_stack_entry = type { ptr }

@stack = dso_local global %struct.ck_stack zeroinitializer, align 4, !dbg !0
@.str = private unnamed_addr constant [25 x i8] c"CK_STACK_ISEMPTY(&stack)\00", align 1, !dbg !17
@.str.1 = private unnamed_addr constant [28 x i8] c"benchmarks/ck/stack_empty.c\00", align 1, !dbg !23
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !28

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc ptr @pusher_fn(ptr noundef %0) #0 !dbg !48 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !52, !DIExpression(), !53)
    #dbg_declare(ptr %3, !54, !DIExpression(), !56)
  store i32 0, ptr %3, align 4, !dbg !56
  br label %5, !dbg !57

5:                                                ; preds = %15, %1
  %6 = load i32, ptr %3, align 4, !dbg !58
  %7 = icmp slt i32 %6, 2, !dbg !60
  br i1 %7, label %8, label %18, !dbg !61

8:                                                ; preds = %5
    #dbg_declare(ptr %4, !62, !DIExpression(), !66)
  %9 = call arm_aapcscc ptr @malloc(i32 noundef 4) #4, !dbg !67
  store ptr %9, ptr %4, align 4, !dbg !66
  %10 = load ptr, ptr %4, align 4, !dbg !68
  %11 = icmp ne ptr %10, null, !dbg !68
  br i1 %11, label %13, label %12, !dbg !70

12:                                               ; preds = %8
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !71
  unreachable, !dbg !71

13:                                               ; preds = %8
  %14 = load ptr, ptr %4, align 4, !dbg !73
  call arm_aapcscc void @ck_stack_push_upmc(ptr noundef @stack, ptr noundef %14), !dbg !74
  br label %15, !dbg !75

15:                                               ; preds = %13
  %16 = load i32, ptr %3, align 4, !dbg !76
  %17 = add nsw i32 %16, 1, !dbg !76
  store i32 %17, ptr %3, align 4, !dbg !76
  br label %5, !dbg !77, !llvm.loop !78

18:                                               ; preds = %5
  ret ptr null, !dbg !81
}

; Function Attrs: allocsize(0)
declare arm_aapcscc ptr @malloc(i32 noundef) #1

; Function Attrs: noreturn
declare arm_aapcscc void @exit(i32 noundef) #2

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_stack_push_upmc(ptr noundef %0, ptr noundef %1) #0 !dbg !82 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !86, !DIExpression(), !87)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !88, !DIExpression(), !89)
    #dbg_declare(ptr %5, !90, !DIExpression(), !91)
  %6 = load ptr, ptr %3, align 4, !dbg !92
  %7 = getelementptr inbounds nuw %struct.ck_stack, ptr %6, i32 0, i32 0, !dbg !93
  %8 = call arm_aapcscc ptr @ck_pr_md_load_ptr(ptr noundef %7), !dbg !94
  store ptr %8, ptr %5, align 4, !dbg !95
  %9 = load ptr, ptr %5, align 4, !dbg !96
  %10 = load ptr, ptr %4, align 4, !dbg !97
  %11 = getelementptr inbounds nuw %struct.ck_stack_entry, ptr %10, i32 0, i32 0, !dbg !98
  store ptr %9, ptr %11, align 4, !dbg !99
  call arm_aapcscc void @ck_pr_fence_store(), !dbg !100
  br label %12, !dbg !101

12:                                               ; preds = %20, %2
  %13 = load ptr, ptr %3, align 4, !dbg !102
  %14 = getelementptr inbounds nuw %struct.ck_stack, ptr %13, i32 0, i32 0, !dbg !103
  %15 = load ptr, ptr %5, align 4, !dbg !104
  %16 = load ptr, ptr %4, align 4, !dbg !105
  %17 = call arm_aapcscc zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %14, ptr noundef %15, ptr noundef %16, ptr noundef %5), !dbg !106
  %18 = zext i1 %17 to i32, !dbg !106
  %19 = icmp eq i32 %18, 0, !dbg !107
  br i1 %19, label %20, label %24, !dbg !101

20:                                               ; preds = %12
  %21 = load ptr, ptr %5, align 4, !dbg !108
  %22 = load ptr, ptr %4, align 4, !dbg !110
  %23 = getelementptr inbounds nuw %struct.ck_stack_entry, ptr %22, i32 0, i32 0, !dbg !111
  store ptr %21, ptr %23, align 4, !dbg !112
  call arm_aapcscc void @ck_pr_fence_store(), !dbg !113
  br label %12, !dbg !101, !llvm.loop !114

24:                                               ; preds = %12
  ret void, !dbg !116
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc ptr @popper_fn(ptr noundef %0) #0 !dbg !117 {
  %2 = alloca ptr, align 4
  %3 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !118, !DIExpression(), !119)
    #dbg_declare(ptr %3, !120, !DIExpression(), !121)
  br label %4, !dbg !122

4:                                                ; preds = %7, %1
  %5 = call arm_aapcscc ptr @ck_stack_pop_upmc(ptr noundef @stack), !dbg !123
  store ptr %5, ptr %3, align 4, !dbg !124
  %6 = icmp eq ptr %5, null, !dbg !125
  br i1 %6, label %7, label %8, !dbg !122

7:                                                ; preds = %4
  br label %4, !dbg !122, !llvm.loop !126

8:                                                ; preds = %4
  %9 = load ptr, ptr %3, align 4, !dbg !128
  call arm_aapcscc void @free(ptr noundef %9), !dbg !129
  ret ptr null, !dbg !130
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc ptr @ck_stack_pop_upmc(ptr noundef %0) #0 !dbg !131 {
  %2 = alloca ptr, align 4
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !134, !DIExpression(), !135)
    #dbg_declare(ptr %4, !136, !DIExpression(), !137)
    #dbg_declare(ptr %5, !138, !DIExpression(), !139)
  %6 = load ptr, ptr %3, align 4, !dbg !140
  %7 = getelementptr inbounds nuw %struct.ck_stack, ptr %6, i32 0, i32 0, !dbg !141
  %8 = call arm_aapcscc ptr @ck_pr_md_load_ptr(ptr noundef %7), !dbg !142
  store ptr %8, ptr %4, align 4, !dbg !143
  %9 = load ptr, ptr %4, align 4, !dbg !144
  %10 = icmp eq ptr %9, null, !dbg !146
  br i1 %10, label %11, label %12, !dbg !146

11:                                               ; preds = %1
  store ptr null, ptr %2, align 4, !dbg !147
  br label %34, !dbg !147

12:                                               ; preds = %1
  call arm_aapcscc void @ck_pr_fence_load(), !dbg !148
  %13 = load ptr, ptr %4, align 4, !dbg !149
  %14 = getelementptr inbounds nuw %struct.ck_stack_entry, ptr %13, i32 0, i32 0, !dbg !150
  %15 = load ptr, ptr %14, align 4, !dbg !150
  store ptr %15, ptr %5, align 4, !dbg !151
  br label %16, !dbg !152

16:                                               ; preds = %28, %12
  %17 = load ptr, ptr %3, align 4, !dbg !153
  %18 = getelementptr inbounds nuw %struct.ck_stack, ptr %17, i32 0, i32 0, !dbg !154
  %19 = load ptr, ptr %4, align 4, !dbg !155
  %20 = load ptr, ptr %5, align 4, !dbg !156
  %21 = call arm_aapcscc zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %18, ptr noundef %19, ptr noundef %20, ptr noundef %4), !dbg !157
  %22 = zext i1 %21 to i32, !dbg !157
  %23 = icmp eq i32 %22, 0, !dbg !158
  br i1 %23, label %24, label %32, !dbg !152

24:                                               ; preds = %16
  %25 = load ptr, ptr %4, align 4, !dbg !159
  %26 = icmp eq ptr %25, null, !dbg !162
  br i1 %26, label %27, label %28, !dbg !162

27:                                               ; preds = %24
  br label %32, !dbg !163

28:                                               ; preds = %24
  call arm_aapcscc void @ck_pr_fence_load(), !dbg !164
  %29 = load ptr, ptr %4, align 4, !dbg !165
  %30 = getelementptr inbounds nuw %struct.ck_stack_entry, ptr %29, i32 0, i32 0, !dbg !166
  %31 = load ptr, ptr %30, align 4, !dbg !166
  store ptr %31, ptr %5, align 4, !dbg !167
  br label %16, !dbg !152, !llvm.loop !168

32:                                               ; preds = %27, %16
  %33 = load ptr, ptr %4, align 4, !dbg !170
  store ptr %33, ptr %2, align 4, !dbg !171
  br label %34, !dbg !171

34:                                               ; preds = %32, %11
  %35 = load ptr, ptr %2, align 4, !dbg !172
  ret ptr %35, !dbg !172
}

declare arm_aapcscc void @free(ptr noundef) #3

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc i32 @main() #0 !dbg !173 {
  %1 = alloca i32, align 4
  %2 = alloca [1 x ptr], align 4
  %3 = alloca [2 x ptr], align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !176, !DIExpression(), !182)
    #dbg_declare(ptr %3, !183, !DIExpression(), !187)
    #dbg_declare(ptr %4, !188, !DIExpression(), !190)
  store i32 0, ptr %4, align 4, !dbg !190
  br label %8, !dbg !191

8:                                                ; preds = %18, %0
  %9 = load i32, ptr %4, align 4, !dbg !192
  %10 = icmp slt i32 %9, 1, !dbg !194
  br i1 %10, label %11, label %21, !dbg !195

11:                                               ; preds = %8
  %12 = load i32, ptr %4, align 4, !dbg !196
  %13 = getelementptr inbounds [1 x ptr], ptr %2, i32 0, i32 %12, !dbg !199
  %14 = call arm_aapcscc i32 @pthread_create(ptr noundef %13, ptr noundef null, ptr noundef @pusher_fn, ptr noundef null), !dbg !200
  %15 = icmp ne i32 %14, 0, !dbg !201
  br i1 %15, label %16, label %17, !dbg !201

16:                                               ; preds = %11
  store i32 1, ptr %1, align 4, !dbg !202
  br label %64, !dbg !202

17:                                               ; preds = %11
  br label %18, !dbg !204

18:                                               ; preds = %17
  %19 = load i32, ptr %4, align 4, !dbg !205
  %20 = add nsw i32 %19, 1, !dbg !205
  store i32 %20, ptr %4, align 4, !dbg !205
  br label %8, !dbg !206, !llvm.loop !207

21:                                               ; preds = %8
    #dbg_declare(ptr %5, !209, !DIExpression(), !211)
  store i32 0, ptr %5, align 4, !dbg !211
  br label %22, !dbg !212

22:                                               ; preds = %32, %21
  %23 = load i32, ptr %5, align 4, !dbg !213
  %24 = icmp slt i32 %23, 2, !dbg !215
  br i1 %24, label %25, label %35, !dbg !216

25:                                               ; preds = %22
  %26 = load i32, ptr %5, align 4, !dbg !217
  %27 = getelementptr inbounds [2 x ptr], ptr %3, i32 0, i32 %26, !dbg !220
  %28 = call arm_aapcscc i32 @pthread_create(ptr noundef %27, ptr noundef null, ptr noundef @popper_fn, ptr noundef null), !dbg !221
  %29 = icmp ne i32 %28, 0, !dbg !222
  br i1 %29, label %30, label %31, !dbg !222

30:                                               ; preds = %25
  store i32 1, ptr %1, align 4, !dbg !223
  br label %64, !dbg !223

31:                                               ; preds = %25
  br label %32, !dbg !225

32:                                               ; preds = %31
  %33 = load i32, ptr %5, align 4, !dbg !226
  %34 = add nsw i32 %33, 1, !dbg !226
  store i32 %34, ptr %5, align 4, !dbg !226
  br label %22, !dbg !227, !llvm.loop !228

35:                                               ; preds = %22
    #dbg_declare(ptr %6, !230, !DIExpression(), !232)
  store i32 0, ptr %6, align 4, !dbg !232
  br label %36, !dbg !233

36:                                               ; preds = %44, %35
  %37 = load i32, ptr %6, align 4, !dbg !234
  %38 = icmp slt i32 %37, 1, !dbg !236
  br i1 %38, label %39, label %47, !dbg !237

39:                                               ; preds = %36
  %40 = load i32, ptr %6, align 4, !dbg !238
  %41 = getelementptr inbounds [1 x ptr], ptr %2, i32 0, i32 %40, !dbg !240
  %42 = load ptr, ptr %41, align 4, !dbg !240
  %43 = call arm_aapcscc i32 @pthread_join(ptr noundef %42, ptr noundef null), !dbg !241
  br label %44, !dbg !242

44:                                               ; preds = %39
  %45 = load i32, ptr %6, align 4, !dbg !243
  %46 = add nsw i32 %45, 1, !dbg !243
  store i32 %46, ptr %6, align 4, !dbg !243
  br label %36, !dbg !244, !llvm.loop !245

47:                                               ; preds = %36
    #dbg_declare(ptr %7, !247, !DIExpression(), !249)
  store i32 0, ptr %7, align 4, !dbg !249
  br label %48, !dbg !250

48:                                               ; preds = %56, %47
  %49 = load i32, ptr %7, align 4, !dbg !251
  %50 = icmp slt i32 %49, 2, !dbg !253
  br i1 %50, label %51, label %59, !dbg !254

51:                                               ; preds = %48
  %52 = load i32, ptr %7, align 4, !dbg !255
  %53 = getelementptr inbounds [2 x ptr], ptr %3, i32 0, i32 %52, !dbg !257
  %54 = load ptr, ptr %53, align 4, !dbg !257
  %55 = call arm_aapcscc i32 @pthread_join(ptr noundef %54, ptr noundef null), !dbg !258
  br label %56, !dbg !259

56:                                               ; preds = %51
  %57 = load i32, ptr %7, align 4, !dbg !260
  %58 = add nsw i32 %57, 1, !dbg !260
  store i32 %58, ptr %7, align 4, !dbg !260
  br label %48, !dbg !261, !llvm.loop !262

59:                                               ; preds = %48
  %60 = load ptr, ptr @stack, align 4, !dbg !264
  %61 = icmp eq ptr %60, null, !dbg !264
  br i1 %61, label %63, label %62, !dbg !267

62:                                               ; preds = %59
  call arm_aapcscc void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 71, ptr noundef @__func__.main), !dbg !267
  br label %63, !dbg !267

63:                                               ; preds = %62, %59
  store i32 0, ptr %1, align 4, !dbg !268
  br label %64, !dbg !268

64:                                               ; preds = %63, %30, %16
  %65 = load i32, ptr %1, align 4, !dbg !269
  ret i32 %65, !dbg !269
}

declare arm_aapcscc i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare arm_aapcscc i32 @pthread_join(ptr noundef, ptr noundef) #3

declare arm_aapcscc void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 !dbg !270 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !276, !DIExpression(), !277)
    #dbg_declare(ptr %3, !278, !DIExpression(), !277)
  store i32 0, ptr %3, align 4, !dbg !277
  %4 = load ptr, ptr %2, align 4, !dbg !277
  %5 = call i32 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #6, !dbg !277, !srcloc !280
  store i32 %5, ptr %3, align 4, !dbg !277
  %6 = load i32, ptr %3, align 4, !dbg !277
  %7 = inttoptr i32 %6 to ptr, !dbg !277
  ret ptr %7, !dbg !277
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_store() #0 !dbg !281 {
  call arm_aapcscc void @ck_pr_fence_strict_store(), !dbg !285
  ret void, !dbg !285
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc zeroext i1 @ck_pr_cas_ptr_value(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 !dbg !286 {
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  %7 = alloca ptr, align 4
  %8 = alloca ptr, align 4
  %9 = alloca ptr, align 4
  %10 = alloca ptr, align 4
  store ptr %0, ptr %5, align 4
    #dbg_declare(ptr %5, !289, !DIExpression(), !290)
  store ptr %1, ptr %6, align 4
    #dbg_declare(ptr %6, !291, !DIExpression(), !292)
  store ptr %2, ptr %7, align 4
    #dbg_declare(ptr %7, !293, !DIExpression(), !294)
  store ptr %3, ptr %8, align 4
    #dbg_declare(ptr %8, !295, !DIExpression(), !296)
    #dbg_declare(ptr %9, !297, !DIExpression(), !298)
    #dbg_declare(ptr %10, !299, !DIExpression(), !300)
  %11 = load ptr, ptr %5, align 4, !dbg !301
  %12 = load ptr, ptr %7, align 4, !dbg !302
  %13 = load ptr, ptr %6, align 4, !dbg !303
  %14 = call { ptr, ptr } asm sideeffect "1:ldrex $0, [$2];cmp   $0, $4;itt eq;strexeq $1, $3, [$2];cmpeq   $1, #1;beq   1b;", "=&r,=&r,r,r,r,~{memory},~{cc}"(ptr %11, ptr %12, ptr %13) #6, !dbg !304, !srcloc !305
  %15 = extractvalue { ptr, ptr } %14, 0, !dbg !304
  %16 = extractvalue { ptr, ptr } %14, 1, !dbg !304
  store ptr %15, ptr %9, align 4, !dbg !304
  store ptr %16, ptr %10, align 4, !dbg !304
  %17 = load ptr, ptr %9, align 4, !dbg !306
  %18 = load ptr, ptr %8, align 4, !dbg !307
  store ptr %17, ptr %18, align 4, !dbg !308
  %19 = load ptr, ptr %9, align 4, !dbg !309
  %20 = load ptr, ptr %6, align 4, !dbg !310
  %21 = icmp eq ptr %19, %20, !dbg !311
  ret i1 %21, !dbg !312
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_store() #0 !dbg !313 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #6, !dbg !314, !srcloc !315
  ret void, !dbg !316
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_load() #0 !dbg !317 {
  call arm_aapcscc void @ck_pr_fence_strict_load(), !dbg !318
  ret void, !dbg !318
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_load() #0 !dbg !319 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #6, !dbg !320, !srcloc !321
  ret void, !dbg !322
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #4 = { allocsize(0) }
attributes #5 = { noreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!40, !41, !42, !43, !44, !45, !46}
!llvm.ident = !{!47}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "stack", scope: !2, file: !3, line: 16, type: !34, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !16, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/stack_empty.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "99be8c5b41f0b7504e3cdccabae5429a")
!4 = !{!5, !6, !7, !12, !15}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 32)
!8 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack_entry", file: !9, line: 35, size: 32, elements: !10)
!9 = !DIFile(filename: "../ck/include/ck_stack.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "19674f5fb31e41969a7583ca1d1160b2")
!10 = !{!11}
!11 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !8, file: !9, line: 36, baseType: !7, size: 32)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !13, line: 4, baseType: !14)
!13 = !DIFile(filename: "include/libc/stdbool.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6e643322591bab80343344357c642cba")
!14 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 32)
!16 = !{!0, !17, !23, !28}
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(scope: null, file: !3, line: 71, type: !19, isLocal: true, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 200, elements: !21)
!20 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!21 = !{!22}
!22 = !DISubrange(count: 25)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !3, line: 71, type: !25, isLocal: true, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 224, elements: !26)
!26 = !{!27}
!27 = !DISubrange(count: 28)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !3, line: 71, type: !30, isLocal: true, isDefinition: true)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !31, size: 40, elements: !32)
!31 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !20)
!32 = !{!33}
!33 = !DISubrange(count: 5)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_t", file: !9, line: 44, baseType: !35)
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_stack", file: !9, line: 40, size: 64, elements: !36)
!36 = !{!37, !38}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !35, file: !9, line: 41, baseType: !7, size: 32)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "generation", scope: !35, file: !9, line: 42, baseType: !39, size: 32, offset: 32)
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 32)
!40 = !{i32 7, !"Dwarf Version", i32 5}
!41 = !{i32 2, !"Debug Info Version", i32 3}
!42 = !{i32 1, !"wchar_size", i32 4}
!43 = !{i32 1, !"min_enum_size", i32 4}
!44 = !{i32 8, !"PIC Level", i32 2}
!45 = !{i32 7, !"PIE Level", i32 2}
!46 = !{i32 7, !"frame-pointer", i32 2}
!47 = !{!"Homebrew clang version 22.1.8"}
!48 = distinct !DISubprogram(name: "pusher_fn", scope: !3, file: !3, line: 18, type: !49, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!49 = !DISubroutineType(types: !50)
!50 = !{!5, !5}
!51 = !{}
!52 = !DILocalVariable(name: "arg", arg: 1, scope: !48, file: !3, line: 18, type: !5)
!53 = !DILocation(line: 18, column: 23, scope: !48)
!54 = !DILocalVariable(name: "i", scope: !55, file: !3, line: 20, type: !6)
!55 = distinct !DILexicalBlock(scope: !48, file: !3, line: 20, column: 5)
!56 = !DILocation(line: 20, column: 14, scope: !55)
!57 = !DILocation(line: 20, column: 10, scope: !55)
!58 = !DILocation(line: 20, column: 21, scope: !59)
!59 = distinct !DILexicalBlock(scope: !55, file: !3, line: 20, column: 5)
!60 = !DILocation(line: 20, column: 23, scope: !59)
!61 = !DILocation(line: 20, column: 5, scope: !55)
!62 = !DILocalVariable(name: "entry", scope: !63, file: !3, line: 22, type: !64)
!63 = distinct !DILexicalBlock(scope: !59, file: !3, line: 21, column: 5)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 32)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_stack_entry_t", file: !9, line: 38, baseType: !8)
!66 = !DILocation(line: 22, column: 27, scope: !63)
!67 = !DILocation(line: 22, column: 35, scope: !63)
!68 = !DILocation(line: 23, column: 14, scope: !69)
!69 = distinct !DILexicalBlock(scope: !63, file: !3, line: 23, column: 13)
!70 = !DILocation(line: 23, column: 13, scope: !69)
!71 = !DILocation(line: 25, column: 13, scope: !72)
!72 = distinct !DILexicalBlock(scope: !69, file: !3, line: 24, column: 9)
!73 = !DILocation(line: 27, column: 36, scope: !63)
!74 = !DILocation(line: 27, column: 9, scope: !63)
!75 = !DILocation(line: 28, column: 5, scope: !63)
!76 = !DILocation(line: 20, column: 39, scope: !59)
!77 = !DILocation(line: 20, column: 5, scope: !59)
!78 = distinct !{!78, !61, !79, !80}
!79 = !DILocation(line: 28, column: 5, scope: !55)
!80 = !{!"llvm.loop.mustprogress"}
!81 = !DILocation(line: 29, column: 5, scope: !48)
!82 = distinct !DISubprogram(name: "ck_stack_push_upmc", scope: !9, file: !9, line: 54, type: !83, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !51)
!83 = !DISubroutineType(types: !84)
!84 = !{null, !85, !7}
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 32)
!86 = !DILocalVariable(name: "target", arg: 1, scope: !82, file: !9, line: 54, type: !85)
!87 = !DILocation(line: 54, column: 37, scope: !82)
!88 = !DILocalVariable(name: "entry", arg: 2, scope: !82, file: !9, line: 54, type: !7)
!89 = !DILocation(line: 54, column: 68, scope: !82)
!90 = !DILocalVariable(name: "stack", scope: !82, file: !9, line: 56, type: !7)
!91 = !DILocation(line: 56, column: 25, scope: !82)
!92 = !DILocation(line: 58, column: 26, scope: !82)
!93 = !DILocation(line: 58, column: 34, scope: !82)
!94 = !DILocation(line: 58, column: 10, scope: !82)
!95 = !DILocation(line: 58, column: 8, scope: !82)
!96 = !DILocation(line: 59, column: 16, scope: !82)
!97 = !DILocation(line: 59, column: 2, scope: !82)
!98 = !DILocation(line: 59, column: 9, scope: !82)
!99 = !DILocation(line: 59, column: 14, scope: !82)
!100 = !DILocation(line: 60, column: 2, scope: !82)
!101 = !DILocation(line: 62, column: 2, scope: !82)
!102 = !DILocation(line: 62, column: 30, scope: !82)
!103 = !DILocation(line: 62, column: 38, scope: !82)
!104 = !DILocation(line: 62, column: 44, scope: !82)
!105 = !DILocation(line: 62, column: 51, scope: !82)
!106 = !DILocation(line: 62, column: 9, scope: !82)
!107 = !DILocation(line: 62, column: 66, scope: !82)
!108 = !DILocation(line: 63, column: 17, scope: !109)
!109 = distinct !DILexicalBlock(scope: !82, file: !9, line: 62, column: 76)
!110 = !DILocation(line: 63, column: 3, scope: !109)
!111 = !DILocation(line: 63, column: 10, scope: !109)
!112 = !DILocation(line: 63, column: 15, scope: !109)
!113 = !DILocation(line: 64, column: 3, scope: !109)
!114 = distinct !{!114, !101, !115, !80}
!115 = !DILocation(line: 65, column: 2, scope: !82)
!116 = !DILocation(line: 67, column: 2, scope: !82)
!117 = distinct !DISubprogram(name: "popper_fn", scope: !3, file: !3, line: 32, type: !49, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!118 = !DILocalVariable(name: "arg", arg: 1, scope: !117, file: !3, line: 32, type: !5)
!119 = !DILocation(line: 32, column: 23, scope: !117)
!120 = !DILocalVariable(name: "entry", scope: !117, file: !3, line: 34, type: !64)
!121 = !DILocation(line: 34, column: 23, scope: !117)
!122 = !DILocation(line: 35, column: 5, scope: !117)
!123 = !DILocation(line: 35, column: 20, scope: !117)
!124 = !DILocation(line: 35, column: 18, scope: !117)
!125 = !DILocation(line: 35, column: 47, scope: !117)
!126 = distinct !{!126, !122, !127, !80}
!127 = !DILocation(line: 35, column: 55, scope: !117)
!128 = !DILocation(line: 36, column: 10, scope: !117)
!129 = !DILocation(line: 36, column: 5, scope: !117)
!130 = !DILocation(line: 37, column: 5, scope: !117)
!131 = distinct !DISubprogram(name: "ck_stack_pop_upmc", scope: !9, file: !9, line: 96, type: !132, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !51)
!132 = !DISubroutineType(types: !133)
!133 = !{!7, !85}
!134 = !DILocalVariable(name: "target", arg: 1, scope: !131, file: !9, line: 96, type: !85)
!135 = !DILocation(line: 96, column: 36, scope: !131)
!136 = !DILocalVariable(name: "entry", scope: !131, file: !9, line: 98, type: !7)
!137 = !DILocation(line: 98, column: 25, scope: !131)
!138 = !DILocalVariable(name: "next", scope: !131, file: !9, line: 98, type: !7)
!139 = !DILocation(line: 98, column: 33, scope: !131)
!140 = !DILocation(line: 100, column: 26, scope: !131)
!141 = !DILocation(line: 100, column: 34, scope: !131)
!142 = !DILocation(line: 100, column: 10, scope: !131)
!143 = !DILocation(line: 100, column: 8, scope: !131)
!144 = !DILocation(line: 101, column: 6, scope: !145)
!145 = distinct !DILexicalBlock(scope: !131, file: !9, line: 101, column: 6)
!146 = !DILocation(line: 101, column: 12, scope: !145)
!147 = !DILocation(line: 102, column: 3, scope: !145)
!148 = !DILocation(line: 104, column: 2, scope: !131)
!149 = !DILocation(line: 105, column: 9, scope: !131)
!150 = !DILocation(line: 105, column: 16, scope: !131)
!151 = !DILocation(line: 105, column: 7, scope: !131)
!152 = !DILocation(line: 106, column: 2, scope: !131)
!153 = !DILocation(line: 106, column: 30, scope: !131)
!154 = !DILocation(line: 106, column: 38, scope: !131)
!155 = !DILocation(line: 106, column: 44, scope: !131)
!156 = !DILocation(line: 106, column: 51, scope: !131)
!157 = !DILocation(line: 106, column: 9, scope: !131)
!158 = !DILocation(line: 106, column: 65, scope: !131)
!159 = !DILocation(line: 107, column: 7, scope: !160)
!160 = distinct !DILexicalBlock(scope: !161, file: !9, line: 107, column: 7)
!161 = distinct !DILexicalBlock(scope: !131, file: !9, line: 106, column: 75)
!162 = !DILocation(line: 107, column: 13, scope: !160)
!163 = !DILocation(line: 108, column: 4, scope: !160)
!164 = !DILocation(line: 110, column: 3, scope: !161)
!165 = !DILocation(line: 111, column: 10, scope: !161)
!166 = !DILocation(line: 111, column: 17, scope: !161)
!167 = !DILocation(line: 111, column: 8, scope: !161)
!168 = distinct !{!168, !152, !169, !80}
!169 = !DILocation(line: 112, column: 2, scope: !131)
!170 = !DILocation(line: 114, column: 9, scope: !131)
!171 = !DILocation(line: 114, column: 2, scope: !131)
!172 = !DILocation(line: 115, column: 1, scope: !131)
!173 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 40, type: !174, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!174 = !DISubroutineType(types: !175)
!175 = !{!6}
!176 = !DILocalVariable(name: "pushers", scope: !173, file: !3, line: 42, type: !177)
!177 = !DICompositeType(tag: DW_TAG_array_type, baseType: !178, size: 32, elements: !180)
!178 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !179, line: 2, baseType: !5)
!179 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!180 = !{!181}
!181 = !DISubrange(count: 1)
!182 = !DILocation(line: 42, column: 15, scope: !173)
!183 = !DILocalVariable(name: "poppers", scope: !173, file: !3, line: 43, type: !184)
!184 = !DICompositeType(tag: DW_TAG_array_type, baseType: !178, size: 64, elements: !185)
!185 = !{!186}
!186 = !DISubrange(count: 2)
!187 = !DILocation(line: 43, column: 15, scope: !173)
!188 = !DILocalVariable(name: "i", scope: !189, file: !3, line: 45, type: !6)
!189 = distinct !DILexicalBlock(scope: !173, file: !3, line: 45, column: 5)
!190 = !DILocation(line: 45, column: 14, scope: !189)
!191 = !DILocation(line: 45, column: 10, scope: !189)
!192 = !DILocation(line: 45, column: 21, scope: !193)
!193 = distinct !DILexicalBlock(scope: !189, file: !3, line: 45, column: 5)
!194 = !DILocation(line: 45, column: 23, scope: !193)
!195 = !DILocation(line: 45, column: 5, scope: !189)
!196 = !DILocation(line: 47, column: 37, scope: !197)
!197 = distinct !DILexicalBlock(scope: !198, file: !3, line: 47, column: 13)
!198 = distinct !DILexicalBlock(scope: !193, file: !3, line: 46, column: 5)
!199 = !DILocation(line: 47, column: 29, scope: !197)
!200 = !DILocation(line: 47, column: 13, scope: !197)
!201 = !DILocation(line: 47, column: 64, scope: !197)
!202 = !DILocation(line: 49, column: 13, scope: !203)
!203 = distinct !DILexicalBlock(scope: !197, file: !3, line: 48, column: 9)
!204 = !DILocation(line: 51, column: 5, scope: !198)
!205 = !DILocation(line: 45, column: 39, scope: !193)
!206 = !DILocation(line: 45, column: 5, scope: !193)
!207 = distinct !{!207, !195, !208, !80}
!208 = !DILocation(line: 51, column: 5, scope: !189)
!209 = !DILocalVariable(name: "i", scope: !210, file: !3, line: 53, type: !6)
!210 = distinct !DILexicalBlock(scope: !173, file: !3, line: 53, column: 5)
!211 = !DILocation(line: 53, column: 14, scope: !210)
!212 = !DILocation(line: 53, column: 10, scope: !210)
!213 = !DILocation(line: 53, column: 21, scope: !214)
!214 = distinct !DILexicalBlock(scope: !210, file: !3, line: 53, column: 5)
!215 = !DILocation(line: 53, column: 23, scope: !214)
!216 = !DILocation(line: 53, column: 5, scope: !210)
!217 = !DILocation(line: 55, column: 37, scope: !218)
!218 = distinct !DILexicalBlock(scope: !219, file: !3, line: 55, column: 13)
!219 = distinct !DILexicalBlock(scope: !214, file: !3, line: 54, column: 5)
!220 = !DILocation(line: 55, column: 29, scope: !218)
!221 = !DILocation(line: 55, column: 13, scope: !218)
!222 = !DILocation(line: 55, column: 64, scope: !218)
!223 = !DILocation(line: 57, column: 13, scope: !224)
!224 = distinct !DILexicalBlock(scope: !218, file: !3, line: 56, column: 9)
!225 = !DILocation(line: 59, column: 5, scope: !219)
!226 = !DILocation(line: 53, column: 39, scope: !214)
!227 = !DILocation(line: 53, column: 5, scope: !214)
!228 = distinct !{!228, !216, !229, !80}
!229 = !DILocation(line: 59, column: 5, scope: !210)
!230 = !DILocalVariable(name: "i", scope: !231, file: !3, line: 61, type: !6)
!231 = distinct !DILexicalBlock(scope: !173, file: !3, line: 61, column: 5)
!232 = !DILocation(line: 61, column: 14, scope: !231)
!233 = !DILocation(line: 61, column: 10, scope: !231)
!234 = !DILocation(line: 61, column: 21, scope: !235)
!235 = distinct !DILexicalBlock(scope: !231, file: !3, line: 61, column: 5)
!236 = !DILocation(line: 61, column: 23, scope: !235)
!237 = !DILocation(line: 61, column: 5, scope: !231)
!238 = !DILocation(line: 63, column: 30, scope: !239)
!239 = distinct !DILexicalBlock(scope: !235, file: !3, line: 62, column: 5)
!240 = !DILocation(line: 63, column: 22, scope: !239)
!241 = !DILocation(line: 63, column: 9, scope: !239)
!242 = !DILocation(line: 64, column: 5, scope: !239)
!243 = !DILocation(line: 61, column: 39, scope: !235)
!244 = !DILocation(line: 61, column: 5, scope: !235)
!245 = distinct !{!245, !237, !246, !80}
!246 = !DILocation(line: 64, column: 5, scope: !231)
!247 = !DILocalVariable(name: "i", scope: !248, file: !3, line: 66, type: !6)
!248 = distinct !DILexicalBlock(scope: !173, file: !3, line: 66, column: 5)
!249 = !DILocation(line: 66, column: 14, scope: !248)
!250 = !DILocation(line: 66, column: 10, scope: !248)
!251 = !DILocation(line: 66, column: 21, scope: !252)
!252 = distinct !DILexicalBlock(scope: !248, file: !3, line: 66, column: 5)
!253 = !DILocation(line: 66, column: 23, scope: !252)
!254 = !DILocation(line: 66, column: 5, scope: !248)
!255 = !DILocation(line: 68, column: 30, scope: !256)
!256 = distinct !DILexicalBlock(scope: !252, file: !3, line: 67, column: 5)
!257 = !DILocation(line: 68, column: 22, scope: !256)
!258 = !DILocation(line: 68, column: 9, scope: !256)
!259 = !DILocation(line: 69, column: 5, scope: !256)
!260 = !DILocation(line: 66, column: 39, scope: !252)
!261 = !DILocation(line: 66, column: 5, scope: !252)
!262 = distinct !{!262, !254, !263, !80}
!263 = !DILocation(line: 69, column: 5, scope: !248)
!264 = !DILocation(line: 71, column: 12, scope: !265)
!265 = distinct !DILexicalBlock(scope: !266, file: !3, line: 71, column: 5)
!266 = distinct !DILexicalBlock(scope: !173, file: !3, line: 71, column: 5)
!267 = !DILocation(line: 71, column: 5, scope: !265)
!268 = !DILocation(line: 73, column: 5, scope: !173)
!269 = !DILocation(line: 74, column: 1, scope: !173)
!270 = distinct !DISubprogram(name: "ck_pr_md_load_ptr", scope: !271, file: !271, line: 120, type: !272, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !51)
!271 = !DIFile(filename: "../ck/include/gcc/arm/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f3f9fb174933d4f9d5af6678feea8d14")
!272 = !DISubroutineType(types: !273)
!273 = !{!5, !274}
!274 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !275, size: 32)
!275 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!276 = !DILocalVariable(name: "target", arg: 1, scope: !270, file: !271, line: 120, type: !274)
!277 = !DILocation(line: 120, column: 1, scope: !270)
!278 = !DILocalVariable(name: "r", scope: !270, file: !271, line: 120, type: !279)
!279 = !DIBasicType(name: "long", size: 32, encoding: DW_ATE_signed)
!280 = !{i64 2147586129}
!281 = distinct !DISubprogram(name: "ck_pr_fence_store", scope: !282, file: !282, line: 117, type: !283, scopeLine: 117, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!282 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!283 = !DISubroutineType(types: !284)
!284 = !{null}
!285 = !DILocation(line: 117, column: 1, scope: !281)
!286 = distinct !DISubprogram(name: "ck_pr_cas_ptr_value", scope: !271, file: !271, line: 299, type: !287, scopeLine: 300, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !51)
!287 = !DISubroutineType(types: !288)
!288 = !{!12, !5, !5, !5, !5}
!289 = !DILocalVariable(name: "target", arg: 1, scope: !286, file: !271, line: 299, type: !5)
!290 = !DILocation(line: 299, column: 27, scope: !286)
!291 = !DILocalVariable(name: "compare", arg: 2, scope: !286, file: !271, line: 299, type: !5)
!292 = !DILocation(line: 299, column: 41, scope: !286)
!293 = !DILocalVariable(name: "set", arg: 3, scope: !286, file: !271, line: 299, type: !5)
!294 = !DILocation(line: 299, column: 56, scope: !286)
!295 = !DILocalVariable(name: "value", arg: 4, scope: !286, file: !271, line: 299, type: !5)
!296 = !DILocation(line: 299, column: 67, scope: !286)
!297 = !DILocalVariable(name: "previous", scope: !286, file: !271, line: 301, type: !5)
!298 = !DILocation(line: 301, column: 8, scope: !286)
!299 = !DILocalVariable(name: "tmp", scope: !286, file: !271, line: 301, type: !5)
!300 = !DILocation(line: 301, column: 19, scope: !286)
!301 = !DILocation(line: 311, column: 16, scope: !286)
!302 = !DILocation(line: 312, column: 14, scope: !286)
!303 = !DILocation(line: 313, column: 14, scope: !286)
!304 = !DILocation(line: 302, column: 2, scope: !286)
!305 = !{i64 86508}
!306 = !DILocation(line: 315, column: 20, scope: !286)
!307 = !DILocation(line: 315, column: 12, scope: !286)
!308 = !DILocation(line: 315, column: 18, scope: !286)
!309 = !DILocation(line: 316, column: 10, scope: !286)
!310 = !DILocation(line: 316, column: 22, scope: !286)
!311 = !DILocation(line: 316, column: 19, scope: !286)
!312 = !DILocation(line: 316, column: 2, scope: !286)
!313 = distinct !DISubprogram(name: "ck_pr_fence_strict_store", scope: !271, file: !271, line: 90, type: !283, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!314 = !DILocation(line: 90, column: 20, scope: !313)
!315 = !{i64 2147583083}
!316 = !DILocation(line: 90, column: 1, scope: !313)
!317 = distinct !DISubprogram(name: "ck_pr_fence_load", scope: !282, file: !282, line: 116, type: !283, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!318 = !DILocation(line: 116, column: 1, scope: !317)
!319 = distinct !DISubprogram(name: "ck_pr_fence_strict_load", scope: !271, file: !271, line: 92, type: !283, scopeLine: 92, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!320 = !DILocation(line: 92, column: 19, scope: !319)
!321 = !{i64 2147583682}
!322 = !DILocation(line: 92, column: 1, scope: !319)
