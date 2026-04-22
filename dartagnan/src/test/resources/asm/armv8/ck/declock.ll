; ModuleID = 'benchmarks/ck/declock.c'
source_filename = "benchmarks/ck/declock.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv8a-pc-linux-gnu"

%struct.ck_spinlock_dec = type { i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !16
@lock = dso_local global %struct.ck_spinlock_dec zeroinitializer, align 4, !dbg !35
@.str = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !18
@.str.1 = private unnamed_addr constant [24 x i8] c"benchmarks/ck/declock.c\00", align 1, !dbg !24
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29
@nodes = dso_local global ptr null, align 4, !dbg !42

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc ptr @run(ptr noundef %0) #0 !dbg !53 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  %4 = alloca i8, align 1
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !57, !DIExpression(), !58)
    #dbg_declare(ptr %3, !59, !DIExpression(), !60)
  %5 = load ptr, ptr %2, align 4, !dbg !61
  %6 = ptrtoint ptr %5 to i32, !dbg !62
  store i32 %6, ptr %3, align 4, !dbg !60
  %7 = load i32, ptr %3, align 4, !dbg !63
  %8 = icmp eq i32 %7, 1, !dbg !65
  br i1 %8, label %9, label %15, !dbg !65

9:                                                ; preds = %1
    #dbg_declare(ptr %4, !66, !DIExpression(), !68)
  %10 = call arm_aapcscc zeroext i1 @ck_spinlock_dec_trylock(ptr noundef @lock), !dbg !69
  %11 = zext i1 %10 to i8, !dbg !68
  store i8 %11, ptr %4, align 1, !dbg !68
  %12 = load i8, ptr %4, align 1, !dbg !70
  %13 = trunc i8 %12 to i1, !dbg !70
  %14 = zext i1 %13 to i32, !dbg !70
  call arm_aapcscc void @__VERIFIER_assume(i32 noundef %14), !dbg !71
  br label %16, !dbg !72

15:                                               ; preds = %1
  call arm_aapcscc void @ck_spinlock_dec_lock(ptr noundef @lock), !dbg !73
  br label %16

16:                                               ; preds = %15, %9
  %17 = load i32, ptr @x, align 4, !dbg !75
  %18 = add nsw i32 %17, 1, !dbg !75
  store i32 %18, ptr @x, align 4, !dbg !75
  %19 = load i32, ptr @y, align 4, !dbg !76
  %20 = add nsw i32 %19, 1, !dbg !76
  store i32 %20, ptr @y, align 4, !dbg !76
  call arm_aapcscc void @ck_spinlock_dec_unlock(ptr noundef @lock), !dbg !77
  ret ptr null, !dbg !78
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc zeroext i1 @ck_spinlock_dec_trylock(ptr noundef %0) #0 !dbg !79 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !83, !DIExpression(), !84)
    #dbg_declare(ptr %3, !85, !DIExpression(), !86)
  %4 = load ptr, ptr %2, align 4, !dbg !87
  %5 = getelementptr inbounds nuw %struct.ck_spinlock_dec, ptr %4, i32 0, i32 0, !dbg !88
  %6 = call arm_aapcscc i32 @ck_pr_fas_uint(ptr noundef %5, i32 noundef 0), !dbg !89
  store i32 %6, ptr %3, align 4, !dbg !90
  call arm_aapcscc void @ck_pr_fence_lock(), !dbg !91
  %7 = load i32, ptr %3, align 4, !dbg !92
  %8 = icmp eq i32 %7, 1, !dbg !93
  ret i1 %8, !dbg !94
}

declare arm_aapcscc void @__VERIFIER_assume(i32 noundef) #1

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_dec_lock(ptr noundef %0) #0 !dbg !95 {
  %2 = alloca ptr, align 4
  %3 = alloca i8, align 1
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !98, !DIExpression(), !99)
    #dbg_declare(ptr %3, !100, !DIExpression(), !101)
  br label %4, !dbg !102

4:                                                ; preds = %19, %1
  %5 = load ptr, ptr %2, align 4, !dbg !103
  %6 = getelementptr inbounds nuw %struct.ck_spinlock_dec, ptr %5, i32 0, i32 0, !dbg !107
  call arm_aapcscc void @ck_pr_dec_uint_zero(ptr noundef %6, ptr noundef %3), !dbg !108
  %7 = load i8, ptr %3, align 1, !dbg !109
  %8 = trunc i8 %7 to i1, !dbg !109
  %9 = zext i1 %8 to i32, !dbg !109
  %10 = icmp eq i32 %9, 1, !dbg !111
  br i1 %10, label %11, label %12, !dbg !111

11:                                               ; preds = %4
  br label %20, !dbg !112

12:                                               ; preds = %4
  br label %13, !dbg !113

13:                                               ; preds = %18, %12
  %14 = load ptr, ptr %2, align 4, !dbg !114
  %15 = getelementptr inbounds nuw %struct.ck_spinlock_dec, ptr %14, i32 0, i32 0, !dbg !115
  %16 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %15), !dbg !116
  %17 = icmp ne i32 %16, 1, !dbg !117
  br i1 %17, label %18, label %19, !dbg !113

18:                                               ; preds = %13
  call arm_aapcscc void @ck_pr_stall(), !dbg !118
  br label %13, !dbg !113, !llvm.loop !119

19:                                               ; preds = %13
  br label %4, !dbg !122, !llvm.loop !123

20:                                               ; preds = %11
  call arm_aapcscc void @ck_pr_fence_lock(), !dbg !126
  ret void, !dbg !127
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_dec_unlock(ptr noundef %0) #0 !dbg !128 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !129, !DIExpression(), !130)
  call arm_aapcscc void @ck_pr_fence_unlock(), !dbg !131
  %3 = load ptr, ptr %2, align 4, !dbg !132
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_dec, ptr %3, i32 0, i32 0, !dbg !133
  call arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %4, i32 noundef 1), !dbg !134
  ret void, !dbg !135
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc i32 @main() #0 !dbg !136 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 4
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !139, !DIExpression(), !145)
    #dbg_declare(ptr %3, !146, !DIExpression(), !147)
  call arm_aapcscc void @ck_spinlock_dec_init(ptr noundef @lock), !dbg !148
  store i32 0, ptr %3, align 4, !dbg !149
  br label %4, !dbg !151

4:                                                ; preds = %16, %0
  %5 = load i32, ptr %3, align 4, !dbg !152
  %6 = icmp slt i32 %5, 2, !dbg !154
  br i1 %6, label %7, label %19, !dbg !155

7:                                                ; preds = %4
  %8 = load i32, ptr %3, align 4, !dbg !156
  %9 = getelementptr inbounds [2 x ptr], ptr %2, i32 0, i32 %8, !dbg !159
  %10 = load i32, ptr %3, align 4, !dbg !160
  %11 = inttoptr i32 %10 to ptr, !dbg !161
  %12 = call arm_aapcscc i32 @pthread_create(ptr noundef %9, ptr noundef null, ptr noundef @run, ptr noundef %11), !dbg !162
  %13 = icmp ne i32 %12, 0, !dbg !163
  br i1 %13, label %14, label %15, !dbg !163

14:                                               ; preds = %7
  call arm_aapcscc void @exit(i32 noundef 1) #3, !dbg !164
  unreachable, !dbg !164

15:                                               ; preds = %7
  br label %16, !dbg !166

16:                                               ; preds = %15
  %17 = load i32, ptr %3, align 4, !dbg !167
  %18 = add nsw i32 %17, 1, !dbg !167
  store i32 %18, ptr %3, align 4, !dbg !167
  br label %4, !dbg !168, !llvm.loop !169

19:                                               ; preds = %4
  store i32 0, ptr %3, align 4, !dbg !171
  br label %20, !dbg !173

20:                                               ; preds = %31, %19
  %21 = load i32, ptr %3, align 4, !dbg !174
  %22 = icmp slt i32 %21, 2, !dbg !176
  br i1 %22, label %23, label %34, !dbg !177

23:                                               ; preds = %20
  %24 = load i32, ptr %3, align 4, !dbg !178
  %25 = getelementptr inbounds [2 x ptr], ptr %2, i32 0, i32 %24, !dbg !181
  %26 = load ptr, ptr %25, align 4, !dbg !181
  %27 = call arm_aapcscc i32 @pthread_join(ptr noundef %26, ptr noundef null), !dbg !182
  %28 = icmp ne i32 %27, 0, !dbg !183
  br i1 %28, label %29, label %30, !dbg !183

29:                                               ; preds = %23
  call arm_aapcscc void @exit(i32 noundef 1) #3, !dbg !184
  unreachable, !dbg !184

30:                                               ; preds = %23
  br label %31, !dbg !186

31:                                               ; preds = %30
  %32 = load i32, ptr %3, align 4, !dbg !187
  %33 = add nsw i32 %32, 1, !dbg !187
  store i32 %33, ptr %3, align 4, !dbg !187
  br label %20, !dbg !188, !llvm.loop !189

34:                                               ; preds = %20
  %35 = load i32, ptr @x, align 4, !dbg !191
  %36 = icmp eq i32 %35, 2, !dbg !194
  br i1 %36, label %37, label %40, !dbg !195

37:                                               ; preds = %34
  %38 = load i32, ptr @y, align 4, !dbg !196
  %39 = icmp eq i32 %38, 2, !dbg !197
  br i1 %39, label %41, label %40, !dbg !198

40:                                               ; preds = %37, %34
  call arm_aapcscc void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 59, ptr noundef @__func__.main), !dbg !198
  br label %41, !dbg !198

41:                                               ; preds = %40, %37
  ret i32 0, !dbg !199
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_dec_init(ptr noundef %0) #0 !dbg !200 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !201, !DIExpression(), !202)
  %3 = load ptr, ptr %2, align 4, !dbg !203
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_dec, ptr %3, i32 0, i32 0, !dbg !204
  store i32 1, ptr %4, align 4, !dbg !205
  call arm_aapcscc void @ck_pr_barrier(), !dbg !206
  ret void, !dbg !207
}

declare arm_aapcscc i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noreturn
declare arm_aapcscc void @exit(i32 noundef) #2

declare arm_aapcscc i32 @pthread_join(ptr noundef, ptr noundef) #1

declare arm_aapcscc void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc i32 @ck_pr_fas_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !208 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !213, !DIExpression(), !214)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !215, !DIExpression(), !214)
    #dbg_declare(ptr %5, !216, !DIExpression(), !214)
  store i32 0, ptr %5, align 4, !dbg !214
    #dbg_declare(ptr %6, !217, !DIExpression(), !214)
  store i32 0, ptr %6, align 4, !dbg !214
  %7 = load i32, ptr %5, align 4, !dbg !214
  %8 = load i32, ptr %6, align 4, !dbg !214
  %9 = load ptr, ptr %3, align 4, !dbg !214
  %10 = load i32, ptr %4, align 4, !dbg !214
  %11 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];strex $1, $3, [$2];cmp $1, #0;bne 1b;", "=&r,=&r,r,r,0,1,~{memory},~{cc}"(ptr %9, i32 %10, i32 %7, i32 %8) #4, !dbg !214, !srcloc !218
  %12 = extractvalue { i32, i32 } %11, 0, !dbg !214
  %13 = extractvalue { i32, i32 } %11, 1, !dbg !214
  store i32 %12, ptr %5, align 4, !dbg !214
  store i32 %13, ptr %6, align 4, !dbg !214
  %14 = load i32, ptr %5, align 4, !dbg !214
  ret i32 %14, !dbg !214
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_lock() #0 !dbg !219 {
  call arm_aapcscc void @ck_pr_fence_strict_lock(), !dbg !223
  ret void, !dbg !223
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_lock() #0 !dbg !224 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #4, !dbg !225, !srcloc !226
  ret void, !dbg !227
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_dec_uint_zero(ptr noundef %0, ptr noundef %1) #0 !dbg !228 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !232, !DIExpression(), !233)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !234, !DIExpression(), !233)
  %5 = load ptr, ptr %3, align 4, !dbg !233
  %6 = call arm_aapcscc zeroext i1 @ck_pr_dec_uint_is_zero(ptr noundef %5), !dbg !233
  %7 = load ptr, ptr %4, align 4, !dbg !233
  %8 = zext i1 %6 to i8, !dbg !233
  store i8 %8, ptr %7, align 1, !dbg !233
  ret void, !dbg !233
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !235 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !240, !DIExpression(), !241)
    #dbg_declare(ptr %3, !242, !DIExpression(), !241)
  store i32 0, ptr %3, align 4, !dbg !241
  %4 = load ptr, ptr %2, align 4, !dbg !241
  %5 = call i32 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #4, !dbg !241, !srcloc !244
  store i32 %5, ptr %3, align 4, !dbg !241
  %6 = load i32, ptr %3, align 4, !dbg !241
  ret i32 %6, !dbg !241
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_stall() #0 !dbg !245 {
  call void asm sideeffect "", "~{memory}"() #4, !dbg !246, !srcloc !247
  ret void, !dbg !248
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc zeroext i1 @ck_pr_dec_uint_is_zero(ptr noundef %0) #0 !dbg !249 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !252, !DIExpression(), !253)
    #dbg_declare(ptr %3, !254, !DIExpression(), !253)
    #dbg_declare(ptr %4, !255, !DIExpression(), !253)
  %5 = load ptr, ptr %2, align 4, !dbg !253
  %6 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %5), !dbg !253
  store i32 %6, ptr %4, align 4, !dbg !253
  %7 = load i32, ptr %4, align 4, !dbg !253
  store i32 %7, ptr %3, align 4, !dbg !253
  br label %8, !dbg !253

8:                                                ; preds = %16, %1
  %9 = load ptr, ptr %2, align 4, !dbg !253
  %10 = load i32, ptr %3, align 4, !dbg !253
  %11 = load i32, ptr %3, align 4, !dbg !253
  %12 = sub i32 %11, 1, !dbg !256
  %13 = call arm_aapcscc zeroext i1 @ck_pr_cas_uint_value(ptr noundef %9, i32 noundef %10, i32 noundef %12, ptr noundef %3), !dbg !253
  %14 = zext i1 %13 to i32, !dbg !253
  %15 = icmp eq i32 %14, 0, !dbg !253
  br i1 %15, label %16, label %17, !dbg !253

16:                                               ; preds = %8
  call arm_aapcscc void @ck_pr_stall(), !dbg !253
  br label %8, !dbg !253, !llvm.loop !257

17:                                               ; preds = %8
  %18 = load i32, ptr %3, align 4, !dbg !253
  %19 = icmp eq i32 %18, 1, !dbg !253
  ret i1 %19, !dbg !253
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc zeroext i1 @ck_pr_cas_uint_value(ptr noundef %0, i32 noundef %1, i32 noundef %2, ptr noundef %3) #0 !dbg !258 {
  %5 = alloca ptr, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store ptr %0, ptr %5, align 4
    #dbg_declare(ptr %5, !261, !DIExpression(), !262)
  store i32 %1, ptr %6, align 4
    #dbg_declare(ptr %6, !263, !DIExpression(), !262)
  store i32 %2, ptr %7, align 4
    #dbg_declare(ptr %7, !264, !DIExpression(), !262)
  store ptr %3, ptr %8, align 4
    #dbg_declare(ptr %8, !265, !DIExpression(), !262)
    #dbg_declare(ptr %9, !266, !DIExpression(), !262)
  store i32 0, ptr %9, align 4, !dbg !262
    #dbg_declare(ptr %10, !267, !DIExpression(), !262)
  store i32 0, ptr %10, align 4, !dbg !262
  %11 = load i32, ptr %9, align 4, !dbg !262
  %12 = load i32, ptr %10, align 4, !dbg !262
  %13 = load ptr, ptr %5, align 4, !dbg !262
  %14 = load i32, ptr %7, align 4, !dbg !262
  %15 = load i32, ptr %6, align 4, !dbg !262
  %16 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];cmp   $0, $4;itt eq;strexeq $1, $3, [$2];cmpeq   $1, #1;beq   1b;", "=&r,=&r,r,r,r,0,1,~{memory},~{cc}"(ptr %13, i32 %14, i32 %15, i32 %11, i32 %12) #4, !dbg !262, !srcloc !268
  %17 = extractvalue { i32, i32 } %16, 0, !dbg !262
  %18 = extractvalue { i32, i32 } %16, 1, !dbg !262
  store i32 %17, ptr %9, align 4, !dbg !262
  store i32 %18, ptr %10, align 4, !dbg !262
  %19 = load i32, ptr %9, align 4, !dbg !262
  %20 = load ptr, ptr %8, align 4, !dbg !262
  store i32 %19, ptr %20, align 4, !dbg !262
  %21 = load i32, ptr %9, align 4, !dbg !262
  %22 = load i32, ptr %6, align 4, !dbg !262
  %23 = icmp eq i32 %21, %22, !dbg !262
  ret i1 %23, !dbg !262
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_unlock() #0 !dbg !269 {
  call arm_aapcscc void @ck_pr_fence_strict_unlock(), !dbg !270
  ret void, !dbg !270
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !271 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !274, !DIExpression(), !275)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !276, !DIExpression(), !275)
  %5 = load ptr, ptr %3, align 4, !dbg !275
  %6 = load i32, ptr %4, align 4, !dbg !275
  call void asm sideeffect "str $1, [$0]", "r,r,~{memory}"(ptr %5, i32 %6) #4, !dbg !275, !srcloc !277
  ret void, !dbg !275
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_unlock() #0 !dbg !278 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #4, !dbg !279, !srcloc !280
  ret void, !dbg !281
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_barrier() #0 !dbg !282 {
  call void asm sideeffect "", "~{memory}"() #4, !dbg !284, !srcloc !285
  ret void, !dbg !286
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #3 = { noreturn }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!45, !46, !47, !48, !49, !50, !51}
!llvm.ident = !{!52}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 12, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !15, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/declock.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "30fa24ff6bfc9964c8665f42f6017fd2")
!4 = !{!5, !8, !9, !7, !12, !11}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !6, line: 17, baseType: !7)
!6 = !DIFile(filename: "include/libc/stdint.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "027aa838071dee39e5261b0fdecb37d3")
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !10, line: 3, baseType: !11)
!10 = !DIFile(filename: "include/libc/_size_t.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "dc11ce4c8eb4c64bece0363f758637cd")
!11 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !13, line: 4, baseType: !14)
!13 = !DIFile(filename: "include/libc/stdbool.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6e643322591bab80343344357c642cba")
!14 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!15 = !{!0, !16, !18, !24, !29, !35, !42}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 12, type: !7, isLocal: false, isDefinition: true)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 59, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 248, elements: !22)
!21 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!22 = !{!23}
!23 = !DISubrange(count: 31)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(scope: null, file: !3, line: 59, type: !26, isLocal: true, isDefinition: true)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 192, elements: !27)
!27 = !{!28}
!28 = !DISubrange(count: 24)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 59, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !33)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !21)
!33 = !{!34}
!34 = !DISubrange(count: 5)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 13, type: !37, isLocal: false, isDefinition: true)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_dec_t", file: !38, line: 46, baseType: !39)
!38 = !DIFile(filename: "../ck/include/spinlock/dec.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "ebf75fdec979dfc7f06fb0ef6eee88f9")
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_dec", file: !38, line: 43, size: 32, elements: !40)
!40 = !{!41}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !39, file: !38, line: 44, baseType: !11, size: 32)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(name: "nodes", scope: !2, file: !3, line: 14, type: !44, isLocal: false, isDefinition: true)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 32)
!45 = !{i32 7, !"Dwarf Version", i32 5}
!46 = !{i32 2, !"Debug Info Version", i32 3}
!47 = !{i32 1, !"wchar_size", i32 4}
!48 = !{i32 1, !"min_enum_size", i32 4}
!49 = !{i32 8, !"PIC Level", i32 2}
!50 = !{i32 7, !"PIE Level", i32 2}
!51 = !{i32 7, !"frame-pointer", i32 2}
!52 = !{!"Homebrew clang version 22.1.8"}
!53 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 16, type: !54, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!54 = !DISubroutineType(types: !55)
!55 = !{!8, !8}
!56 = !{}
!57 = !DILocalVariable(name: "arg", arg: 1, scope: !53, file: !3, line: 16, type: !8)
!58 = !DILocation(line: 16, column: 17, scope: !53)
!59 = !DILocalVariable(name: "tid", scope: !53, file: !3, line: 18, type: !5)
!60 = !DILocation(line: 18, column: 14, scope: !53)
!61 = !DILocation(line: 18, column: 31, scope: !53)
!62 = !DILocation(line: 18, column: 21, scope: !53)
!63 = !DILocation(line: 20, column: 9, scope: !64)
!64 = distinct !DILexicalBlock(scope: !53, file: !3, line: 20, column: 9)
!65 = !DILocation(line: 20, column: 13, scope: !64)
!66 = !DILocalVariable(name: "acquired", scope: !67, file: !3, line: 22, type: !12)
!67 = distinct !DILexicalBlock(scope: !64, file: !3, line: 21, column: 5)
!68 = !DILocation(line: 22, column: 14, scope: !67)
!69 = !DILocation(line: 22, column: 25, scope: !67)
!70 = !DILocation(line: 23, column: 27, scope: !67)
!71 = !DILocation(line: 23, column: 9, scope: !67)
!72 = !DILocation(line: 24, column: 5, scope: !67)
!73 = !DILocation(line: 27, column: 9, scope: !74)
!74 = distinct !DILexicalBlock(scope: !64, file: !3, line: 26, column: 5)
!75 = !DILocation(line: 29, column: 6, scope: !53)
!76 = !DILocation(line: 30, column: 6, scope: !53)
!77 = !DILocation(line: 31, column: 5, scope: !53)
!78 = !DILocation(line: 33, column: 5, scope: !53)
!79 = distinct !DISubprogram(name: "ck_spinlock_dec_trylock", scope: !38, file: !38, line: 60, type: !80, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!80 = !DISubroutineType(types: !81)
!81 = !{!12, !82}
!82 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 32)
!83 = !DILocalVariable(name: "lock", arg: 1, scope: !79, file: !38, line: 60, type: !82)
!84 = !DILocation(line: 60, column: 49, scope: !79)
!85 = !DILocalVariable(name: "value", scope: !79, file: !38, line: 62, type: !11)
!86 = !DILocation(line: 62, column: 15, scope: !79)
!87 = !DILocation(line: 64, column: 26, scope: !79)
!88 = !DILocation(line: 64, column: 32, scope: !79)
!89 = !DILocation(line: 64, column: 10, scope: !79)
!90 = !DILocation(line: 64, column: 8, scope: !79)
!91 = !DILocation(line: 65, column: 2, scope: !79)
!92 = !DILocation(line: 66, column: 9, scope: !79)
!93 = !DILocation(line: 66, column: 15, scope: !79)
!94 = !DILocation(line: 66, column: 2, scope: !79)
!95 = distinct !DISubprogram(name: "ck_spinlock_dec_lock", scope: !38, file: !38, line: 80, type: !96, scopeLine: 81, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!96 = !DISubroutineType(types: !97)
!97 = !{null, !82}
!98 = !DILocalVariable(name: "lock", arg: 1, scope: !95, file: !38, line: 80, type: !82)
!99 = !DILocation(line: 80, column: 46, scope: !95)
!100 = !DILocalVariable(name: "r", scope: !95, file: !38, line: 82, type: !12)
!101 = !DILocation(line: 82, column: 7, scope: !95)
!102 = !DILocation(line: 84, column: 2, scope: !95)
!103 = !DILocation(line: 90, column: 24, scope: !104)
!104 = distinct !DILexicalBlock(scope: !105, file: !38, line: 84, column: 11)
!105 = distinct !DILexicalBlock(scope: !106, file: !38, line: 84, column: 2)
!106 = distinct !DILexicalBlock(scope: !95, file: !38, line: 84, column: 2)
!107 = !DILocation(line: 90, column: 30, scope: !104)
!108 = !DILocation(line: 90, column: 3, scope: !104)
!109 = !DILocation(line: 91, column: 7, scope: !110)
!110 = distinct !DILexicalBlock(scope: !104, file: !38, line: 91, column: 7)
!111 = !DILocation(line: 91, column: 9, scope: !110)
!112 = !DILocation(line: 92, column: 4, scope: !110)
!113 = !DILocation(line: 95, column: 3, scope: !104)
!114 = !DILocation(line: 95, column: 27, scope: !104)
!115 = !DILocation(line: 95, column: 33, scope: !104)
!116 = !DILocation(line: 95, column: 10, scope: !104)
!117 = !DILocation(line: 95, column: 40, scope: !104)
!118 = !DILocation(line: 96, column: 4, scope: !104)
!119 = distinct !{!119, !113, !120, !121}
!120 = !DILocation(line: 96, column: 16, scope: !104)
!121 = !{!"llvm.loop.mustprogress"}
!122 = !DILocation(line: 84, column: 2, scope: !105)
!123 = distinct !{!123, !124, !125}
!124 = !DILocation(line: 84, column: 2, scope: !106)
!125 = !DILocation(line: 97, column: 2, scope: !106)
!126 = !DILocation(line: 99, column: 2, scope: !95)
!127 = !DILocation(line: 100, column: 2, scope: !95)
!128 = distinct !DISubprogram(name: "ck_spinlock_dec_unlock", scope: !38, file: !38, line: 123, type: !96, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!129 = !DILocalVariable(name: "lock", arg: 1, scope: !128, file: !38, line: 123, type: !82)
!130 = !DILocation(line: 123, column: 48, scope: !128)
!131 = !DILocation(line: 126, column: 2, scope: !128)
!132 = !DILocation(line: 132, column: 20, scope: !128)
!133 = !DILocation(line: 132, column: 26, scope: !128)
!134 = !DILocation(line: 132, column: 2, scope: !128)
!135 = !DILocation(line: 133, column: 2, scope: !128)
!136 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 36, type: !137, scopeLine: 37, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !56)
!137 = !DISubroutineType(types: !138)
!138 = !{!7}
!139 = !DILocalVariable(name: "threads", scope: !136, file: !3, line: 38, type: !140)
!140 = !DICompositeType(tag: DW_TAG_array_type, baseType: !141, size: 64, elements: !143)
!141 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !142, line: 2, baseType: !8)
!142 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!143 = !{!144}
!144 = !DISubrange(count: 2)
!145 = !DILocation(line: 38, column: 15, scope: !136)
!146 = !DILocalVariable(name: "i", scope: !136, file: !3, line: 39, type: !7)
!147 = !DILocation(line: 39, column: 9, scope: !136)
!148 = !DILocation(line: 41, column: 5, scope: !136)
!149 = !DILocation(line: 43, column: 12, scope: !150)
!150 = distinct !DILexicalBlock(scope: !136, file: !3, line: 43, column: 5)
!151 = !DILocation(line: 43, column: 10, scope: !150)
!152 = !DILocation(line: 43, column: 17, scope: !153)
!153 = distinct !DILexicalBlock(scope: !150, file: !3, line: 43, column: 5)
!154 = !DILocation(line: 43, column: 19, scope: !153)
!155 = !DILocation(line: 43, column: 5, scope: !150)
!156 = !DILocation(line: 45, column: 37, scope: !157)
!157 = distinct !DILexicalBlock(scope: !158, file: !3, line: 45, column: 13)
!158 = distinct !DILexicalBlock(scope: !153, file: !3, line: 44, column: 5)
!159 = !DILocation(line: 45, column: 29, scope: !157)
!160 = !DILocation(line: 45, column: 68, scope: !157)
!161 = !DILocation(line: 45, column: 52, scope: !157)
!162 = !DILocation(line: 45, column: 13, scope: !157)
!163 = !DILocation(line: 45, column: 71, scope: !157)
!164 = !DILocation(line: 47, column: 13, scope: !165)
!165 = distinct !DILexicalBlock(scope: !157, file: !3, line: 46, column: 9)
!166 = !DILocation(line: 49, column: 5, scope: !158)
!167 = !DILocation(line: 43, column: 32, scope: !153)
!168 = !DILocation(line: 43, column: 5, scope: !153)
!169 = distinct !{!169, !155, !170, !121}
!170 = !DILocation(line: 49, column: 5, scope: !150)
!171 = !DILocation(line: 51, column: 12, scope: !172)
!172 = distinct !DILexicalBlock(scope: !136, file: !3, line: 51, column: 5)
!173 = !DILocation(line: 51, column: 10, scope: !172)
!174 = !DILocation(line: 51, column: 17, scope: !175)
!175 = distinct !DILexicalBlock(scope: !172, file: !3, line: 51, column: 5)
!176 = !DILocation(line: 51, column: 19, scope: !175)
!177 = !DILocation(line: 51, column: 5, scope: !172)
!178 = !DILocation(line: 53, column: 34, scope: !179)
!179 = distinct !DILexicalBlock(scope: !180, file: !3, line: 53, column: 13)
!180 = distinct !DILexicalBlock(scope: !175, file: !3, line: 52, column: 5)
!181 = !DILocation(line: 53, column: 26, scope: !179)
!182 = !DILocation(line: 53, column: 13, scope: !179)
!183 = !DILocation(line: 53, column: 44, scope: !179)
!184 = !DILocation(line: 55, column: 13, scope: !185)
!185 = distinct !DILexicalBlock(scope: !179, file: !3, line: 54, column: 9)
!186 = !DILocation(line: 57, column: 5, scope: !180)
!187 = !DILocation(line: 51, column: 32, scope: !175)
!188 = !DILocation(line: 51, column: 5, scope: !175)
!189 = distinct !{!189, !177, !190, !121}
!190 = !DILocation(line: 57, column: 5, scope: !172)
!191 = !DILocation(line: 59, column: 12, scope: !192)
!192 = distinct !DILexicalBlock(scope: !193, file: !3, line: 59, column: 5)
!193 = distinct !DILexicalBlock(scope: !136, file: !3, line: 59, column: 5)
!194 = !DILocation(line: 59, column: 14, scope: !192)
!195 = !DILocation(line: 59, column: 26, scope: !192)
!196 = !DILocation(line: 59, column: 29, scope: !192)
!197 = !DILocation(line: 59, column: 31, scope: !192)
!198 = !DILocation(line: 59, column: 5, scope: !192)
!199 = !DILocation(line: 61, column: 5, scope: !136)
!200 = distinct !DISubprogram(name: "ck_spinlock_dec_init", scope: !38, file: !38, line: 51, type: !96, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!201 = !DILocalVariable(name: "lock", arg: 1, scope: !200, file: !38, line: 51, type: !82)
!202 = !DILocation(line: 51, column: 46, scope: !200)
!203 = !DILocation(line: 54, column: 2, scope: !200)
!204 = !DILocation(line: 54, column: 8, scope: !200)
!205 = !DILocation(line: 54, column: 14, scope: !200)
!206 = !DILocation(line: 55, column: 2, scope: !200)
!207 = !DILocation(line: 56, column: 2, scope: !200)
!208 = distinct !DISubprogram(name: "ck_pr_fas_uint", scope: !209, file: !209, line: 417, type: !210, scopeLine: 417, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!209 = !DIFile(filename: "../ck/include/gcc/arm/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f3f9fb174933d4f9d5af6678feea8d14")
!210 = !DISubroutineType(types: !211)
!211 = !{!11, !212, !11}
!212 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 32)
!213 = !DILocalVariable(name: "target", arg: 1, scope: !208, file: !209, line: 417, type: !212)
!214 = !DILocation(line: 417, column: 1, scope: !208)
!215 = !DILocalVariable(name: "v", arg: 2, scope: !208, file: !209, line: 417, type: !11)
!216 = !DILocalVariable(name: "previous", scope: !208, file: !209, line: 417, type: !11)
!217 = !DILocalVariable(name: "tmp", scope: !208, file: !209, line: 417, type: !11)
!218 = !{i64 2147602661}
!219 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !220, file: !220, line: 122, type: !221, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!220 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!221 = !DISubroutineType(types: !222)
!222 = !{null}
!223 = !DILocation(line: 122, column: 1, scope: !219)
!224 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !209, file: !209, line: 98, type: !221, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!225 = !DILocation(line: 98, column: 19, scope: !224)
!226 = !{i64 2147584632}
!227 = !DILocation(line: 98, column: 1, scope: !224)
!228 = distinct !DISubprogram(name: "ck_pr_dec_uint_zero", scope: !220, file: !220, line: 753, type: !229, scopeLine: 753, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!229 = !DISubroutineType(types: !230)
!230 = !{null, !212, !231}
!231 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 32)
!232 = !DILocalVariable(name: "target", arg: 1, scope: !228, file: !220, line: 753, type: !212)
!233 = !DILocation(line: 753, column: 1, scope: !228)
!234 = !DILocalVariable(name: "zero", arg: 2, scope: !228, file: !220, line: 753, type: !231)
!235 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !209, file: !209, line: 127, type: !236, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!236 = !DISubroutineType(types: !237)
!237 = !{!11, !238}
!238 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !239, size: 32)
!239 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!240 = !DILocalVariable(name: "target", arg: 1, scope: !235, file: !209, line: 127, type: !238)
!241 = !DILocation(line: 127, column: 1, scope: !235)
!242 = !DILocalVariable(name: "r", scope: !235, file: !209, line: 127, type: !243)
!243 = !DIBasicType(name: "long", size: 32, encoding: DW_ATE_signed)
!244 = !{i64 2147586835}
!245 = distinct !DISubprogram(name: "ck_pr_stall", scope: !209, file: !209, line: 50, type: !221, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!246 = !DILocation(line: 53, column: 2, scope: !245)
!247 = !{i64 79044}
!248 = !DILocation(line: 54, column: 2, scope: !245)
!249 = distinct !DISubprogram(name: "ck_pr_dec_uint_is_zero", scope: !220, file: !220, line: 753, type: !250, scopeLine: 753, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!250 = !DISubroutineType(types: !251)
!251 = !{!12, !212}
!252 = !DILocalVariable(name: "target", arg: 1, scope: !249, file: !220, line: 753, type: !212)
!253 = !DILocation(line: 753, column: 1, scope: !249)
!254 = !DILocalVariable(name: "previous", scope: !249, file: !220, line: 753, type: !11)
!255 = !DILocalVariable(name: "punt", scope: !249, file: !220, line: 753, type: !11)
!256 = !DILocation(line: 753, column: 42, scope: !249)
!257 = distinct !{!257, !253, !253, !121}
!258 = distinct !DISubprogram(name: "ck_pr_cas_uint_value", scope: !209, file: !209, line: 385, type: !259, scopeLine: 385, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!259 = !DISubroutineType(types: !260)
!260 = !{!12, !212, !11, !11, !212}
!261 = !DILocalVariable(name: "target", arg: 1, scope: !258, file: !209, line: 385, type: !212)
!262 = !DILocation(line: 385, column: 1, scope: !258)
!263 = !DILocalVariable(name: "compare", arg: 2, scope: !258, file: !209, line: 385, type: !11)
!264 = !DILocalVariable(name: "set", arg: 3, scope: !258, file: !209, line: 385, type: !11)
!265 = !DILocalVariable(name: "value", arg: 4, scope: !258, file: !209, line: 385, type: !212)
!266 = !DILocalVariable(name: "previous", scope: !258, file: !209, line: 385, type: !11)
!267 = !DILocalVariable(name: "tmp", scope: !258, file: !209, line: 385, type: !11)
!268 = !{i64 2147592489}
!269 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !220, file: !220, line: 123, type: !221, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!270 = !DILocation(line: 123, column: 1, scope: !269)
!271 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !209, file: !209, line: 176, type: !272, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !56)
!272 = !DISubroutineType(types: !273)
!273 = !{null, !212, !11}
!274 = !DILocalVariable(name: "target", arg: 1, scope: !271, file: !209, line: 176, type: !212)
!275 = !DILocation(line: 176, column: 1, scope: !271)
!276 = !DILocalVariable(name: "v", arg: 2, scope: !271, file: !209, line: 176, type: !11)
!277 = !{i64 2147589704}
!278 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !209, file: !209, line: 99, type: !221, scopeLine: 99, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!279 = !DILocation(line: 99, column: 21, scope: !278)
!280 = !{i64 2147584927}
!281 = !DILocation(line: 99, column: 1, scope: !278)
!282 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !283, file: !283, line: 37, type: !221, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!283 = !DIFile(filename: "../ck/include/gcc/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!284 = !DILocation(line: 40, column: 2, scope: !282)
!285 = !{i64 174780}
!286 = !DILocation(line: 41, column: 2, scope: !282)
