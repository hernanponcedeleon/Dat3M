; ModuleID = 'benchmarks/ck/mcslock.c'
source_filename = "benchmarks/ck/mcslock.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv8a-pc-linux-gnu"

%struct.ck_spinlock_mcs = type { i32, ptr }

@lock = dso_local global ptr null, align 4, !dbg !0
@x = dso_local global i32 0, align 4, !dbg !23
@y = dso_local global i32 0, align 4, !dbg !25
@nodes = dso_local global ptr null, align 4, !dbg !44
@.str = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !27
@.str.1 = private unnamed_addr constant [24 x i8] c"benchmarks/ck/mcslock.c\00", align 1, !dbg !33
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !38

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc ptr @run(ptr noundef %0) #0 !dbg !54 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !58, !DIExpression(), !59)
    #dbg_declare(ptr %3, !60, !DIExpression(), !61)
  %5 = load ptr, ptr %2, align 4, !dbg !62
  %6 = ptrtoint ptr %5 to i32, !dbg !63
  store i32 %6, ptr %3, align 4, !dbg !61
    #dbg_declare(ptr %4, !64, !DIExpression(), !65)
  %7 = load ptr, ptr @nodes, align 4, !dbg !66
  %8 = load i32, ptr %3, align 4, !dbg !67
  %9 = getelementptr inbounds %struct.ck_spinlock_mcs, ptr %7, i32 %8, !dbg !66
  store ptr %9, ptr %4, align 4, !dbg !65
  %10 = load ptr, ptr %4, align 4, !dbg !68
  call arm_aapcscc void @ck_spinlock_mcs_lock(ptr noundef @lock, ptr noundef %10), !dbg !69
  %11 = load i32, ptr @x, align 4, !dbg !70
  %12 = add nsw i32 %11, 1, !dbg !70
  store i32 %12, ptr @x, align 4, !dbg !70
  %13 = load i32, ptr @y, align 4, !dbg !71
  %14 = add nsw i32 %13, 1, !dbg !71
  store i32 %14, ptr @y, align 4, !dbg !71
  %15 = load ptr, ptr %4, align 4, !dbg !72
  call arm_aapcscc void @ck_spinlock_mcs_unlock(ptr noundef @lock, ptr noundef %15), !dbg !73
  ret ptr null, !dbg !74
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_mcs_lock(ptr noundef %0, ptr noundef %1) #0 !dbg !75 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !79, !DIExpression(), !80)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !81, !DIExpression(), !82)
    #dbg_declare(ptr %5, !83, !DIExpression(), !84)
  %6 = load ptr, ptr %4, align 4, !dbg !85
  %7 = getelementptr inbounds nuw %struct.ck_spinlock_mcs, ptr %6, i32 0, i32 0, !dbg !86
  store i32 1, ptr %7, align 4, !dbg !87
  %8 = load ptr, ptr %4, align 4, !dbg !88
  %9 = getelementptr inbounds nuw %struct.ck_spinlock_mcs, ptr %8, i32 0, i32 1, !dbg !89
  store ptr null, ptr %9, align 4, !dbg !90
  call arm_aapcscc void @ck_pr_fence_store_atomic(), !dbg !91
  %10 = load ptr, ptr %3, align 4, !dbg !92
  %11 = load ptr, ptr %4, align 4, !dbg !93
  %12 = call arm_aapcscc ptr @ck_pr_fas_ptr(ptr noundef %10, ptr noundef %11), !dbg !94
  store ptr %12, ptr %5, align 4, !dbg !95
  %13 = load ptr, ptr %5, align 4, !dbg !96
  %14 = icmp ne ptr %13, null, !dbg !98
  br i1 %14, label %15, label %26, !dbg !98

15:                                               ; preds = %2
  %16 = load ptr, ptr %5, align 4, !dbg !99
  %17 = getelementptr inbounds nuw %struct.ck_spinlock_mcs, ptr %16, i32 0, i32 1, !dbg !101
  %18 = load ptr, ptr %4, align 4, !dbg !102
  call arm_aapcscc void @ck_pr_md_store_ptr(ptr noundef %17, ptr noundef %18), !dbg !103
  br label %19, !dbg !104

19:                                               ; preds = %24, %15
  %20 = load ptr, ptr %4, align 4, !dbg !105
  %21 = getelementptr inbounds nuw %struct.ck_spinlock_mcs, ptr %20, i32 0, i32 0, !dbg !106
  %22 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %21), !dbg !107
  %23 = icmp eq i32 %22, 1, !dbg !108
  br i1 %23, label %24, label %25, !dbg !104

24:                                               ; preds = %19
  call arm_aapcscc void @ck_pr_stall(), !dbg !109
  br label %19, !dbg !104, !llvm.loop !110

25:                                               ; preds = %19
  br label %26, !dbg !113

26:                                               ; preds = %25, %2
  call arm_aapcscc void @ck_pr_fence_lock(), !dbg !114
  ret void, !dbg !115
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_mcs_unlock(ptr noundef %0, ptr noundef %1) #0 !dbg !116 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !117, !DIExpression(), !118)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !119, !DIExpression(), !120)
    #dbg_declare(ptr %5, !121, !DIExpression(), !122)
  call arm_aapcscc void @ck_pr_fence_unlock(), !dbg !123
  %6 = load ptr, ptr %4, align 4, !dbg !124
  %7 = getelementptr inbounds nuw %struct.ck_spinlock_mcs, ptr %6, i32 0, i32 1, !dbg !125
  %8 = call arm_aapcscc ptr @ck_pr_md_load_ptr(ptr noundef %7), !dbg !126
  store ptr %8, ptr %5, align 4, !dbg !127
  %9 = load ptr, ptr %5, align 4, !dbg !128
  %10 = icmp eq ptr %9, null, !dbg !130
  br i1 %10, label %11, label %33, !dbg !130

11:                                               ; preds = %2
  %12 = load ptr, ptr %3, align 4, !dbg !131
  %13 = call arm_aapcscc ptr @ck_pr_md_load_ptr(ptr noundef %12), !dbg !134
  %14 = load ptr, ptr %4, align 4, !dbg !135
  %15 = icmp eq ptr %13, %14, !dbg !136
  br i1 %15, label %16, label %23, !dbg !137

16:                                               ; preds = %11
  %17 = load ptr, ptr %3, align 4, !dbg !138
  %18 = load ptr, ptr %4, align 4, !dbg !139
  %19 = call arm_aapcscc zeroext i1 @ck_pr_cas_ptr(ptr noundef %17, ptr noundef %18, ptr noundef null), !dbg !140
  %20 = zext i1 %19 to i32, !dbg !140
  %21 = icmp eq i32 %20, 1, !dbg !141
  br i1 %21, label %22, label %23, !dbg !137

22:                                               ; preds = %16
  br label %36, !dbg !142

23:                                               ; preds = %16, %11
  br label %24, !dbg !144

24:                                               ; preds = %31, %23
  %25 = load ptr, ptr %4, align 4, !dbg !145
  %26 = getelementptr inbounds nuw %struct.ck_spinlock_mcs, ptr %25, i32 0, i32 1, !dbg !149
  %27 = call arm_aapcscc ptr @ck_pr_md_load_ptr(ptr noundef %26), !dbg !150
  store ptr %27, ptr %5, align 4, !dbg !151
  %28 = load ptr, ptr %5, align 4, !dbg !152
  %29 = icmp ne ptr %28, null, !dbg !154
  br i1 %29, label %30, label %31, !dbg !154

30:                                               ; preds = %24
  br label %32, !dbg !155

31:                                               ; preds = %24
  call arm_aapcscc void @ck_pr_stall(), !dbg !156
  br label %24, !dbg !157, !llvm.loop !158

32:                                               ; preds = %30
  br label %33, !dbg !161

33:                                               ; preds = %32, %2
  %34 = load ptr, ptr %5, align 4, !dbg !162
  %35 = getelementptr inbounds nuw %struct.ck_spinlock_mcs, ptr %34, i32 0, i32 0, !dbg !163
  call arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %35, i32 noundef 0), !dbg !164
  br label %36, !dbg !165

36:                                               ; preds = %33, %22
  ret void, !dbg !166
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc i32 @main() #0 !dbg !167 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x ptr], align 4
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !170, !DIExpression(), !176)
    #dbg_declare(ptr %3, !177, !DIExpression(), !178)
  %4 = call arm_aapcscc ptr @malloc(i32 noundef 8) #4, !dbg !179
  store ptr %4, ptr @nodes, align 4, !dbg !180
  %5 = load ptr, ptr @nodes, align 4, !dbg !181
  %6 = icmp eq ptr %5, null, !dbg !183
  br i1 %6, label %7, label %8, !dbg !183

7:                                                ; preds = %0
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !184
  unreachable, !dbg !184

8:                                                ; preds = %0
  store ptr null, ptr @lock, align 4, !dbg !186
  store i32 0, ptr %3, align 4, !dbg !187
  br label %9, !dbg !189

9:                                                ; preds = %22, %8
  %10 = load i32, ptr %3, align 4, !dbg !190
  %11 = icmp slt i32 %10, 2, !dbg !192
  br i1 %11, label %12, label %25, !dbg !193

12:                                               ; preds = %9
  %13 = load i32, ptr %3, align 4, !dbg !194
  %14 = getelementptr inbounds [2 x ptr], ptr %2, i32 0, i32 %13, !dbg !197
  %15 = load i32, ptr %3, align 4, !dbg !198
  %16 = inttoptr i32 %15 to ptr, !dbg !199
  %17 = call arm_aapcscc i32 @pthread_create(ptr noundef %14, ptr noundef null, ptr noundef @run, ptr noundef %16), !dbg !200
  %18 = icmp ne i32 %17, 0, !dbg !201
  br i1 %18, label %19, label %21, !dbg !201

19:                                               ; preds = %12
  %20 = load ptr, ptr @nodes, align 4, !dbg !202
  call arm_aapcscc void @free(ptr noundef %20), !dbg !204
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !205
  unreachable, !dbg !205

21:                                               ; preds = %12
  br label %22, !dbg !206

22:                                               ; preds = %21
  %23 = load i32, ptr %3, align 4, !dbg !207
  %24 = add nsw i32 %23, 1, !dbg !207
  store i32 %24, ptr %3, align 4, !dbg !207
  br label %9, !dbg !208, !llvm.loop !209

25:                                               ; preds = %9
  store i32 0, ptr %3, align 4, !dbg !211
  br label %26, !dbg !213

26:                                               ; preds = %38, %25
  %27 = load i32, ptr %3, align 4, !dbg !214
  %28 = icmp slt i32 %27, 2, !dbg !216
  br i1 %28, label %29, label %41, !dbg !217

29:                                               ; preds = %26
  %30 = load i32, ptr %3, align 4, !dbg !218
  %31 = getelementptr inbounds [2 x ptr], ptr %2, i32 0, i32 %30, !dbg !221
  %32 = load ptr, ptr %31, align 4, !dbg !221
  %33 = call arm_aapcscc i32 @pthread_join(ptr noundef %32, ptr noundef null), !dbg !222
  %34 = icmp ne i32 %33, 0, !dbg !223
  br i1 %34, label %35, label %37, !dbg !223

35:                                               ; preds = %29
  %36 = load ptr, ptr @nodes, align 4, !dbg !224
  call arm_aapcscc void @free(ptr noundef %36), !dbg !226
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !227
  unreachable, !dbg !227

37:                                               ; preds = %29
  br label %38, !dbg !228

38:                                               ; preds = %37
  %39 = load i32, ptr %3, align 4, !dbg !229
  %40 = add nsw i32 %39, 1, !dbg !229
  store i32 %40, ptr %3, align 4, !dbg !229
  br label %26, !dbg !230, !llvm.loop !231

41:                                               ; preds = %26
  %42 = load i32, ptr @x, align 4, !dbg !233
  %43 = icmp eq i32 %42, 2, !dbg !236
  br i1 %43, label %44, label %47, !dbg !237

44:                                               ; preds = %41
  %45 = load i32, ptr @y, align 4, !dbg !238
  %46 = icmp eq i32 %45, 2, !dbg !239
  br i1 %46, label %48, label %47, !dbg !240

47:                                               ; preds = %44, %41
  call arm_aapcscc void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 63, ptr noundef @__func__.main), !dbg !240
  br label %48, !dbg !240

48:                                               ; preds = %47, %44
  %49 = load ptr, ptr @nodes, align 4, !dbg !241
  call arm_aapcscc void @free(ptr noundef %49), !dbg !242
  ret i32 0, !dbg !243
}

; Function Attrs: allocsize(0)
declare arm_aapcscc ptr @malloc(i32 noundef) #1

; Function Attrs: noreturn
declare arm_aapcscc void @exit(i32 noundef) #2

declare arm_aapcscc i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare arm_aapcscc void @free(ptr noundef) #3

declare arm_aapcscc i32 @pthread_join(ptr noundef, ptr noundef) #3

declare arm_aapcscc void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_store_atomic() #0 !dbg !244 {
  call arm_aapcscc void @ck_pr_fence_strict_store_atomic(), !dbg !248
  ret void, !dbg !248
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc ptr @ck_pr_fas_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !249 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !253, !DIExpression(), !254)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !255, !DIExpression(), !254)
    #dbg_declare(ptr %5, !256, !DIExpression(), !254)
  store ptr null, ptr %5, align 4, !dbg !254
    #dbg_declare(ptr %6, !257, !DIExpression(), !254)
  store ptr null, ptr %6, align 4, !dbg !254
  %7 = load ptr, ptr %5, align 4, !dbg !254
  %8 = load ptr, ptr %6, align 4, !dbg !254
  %9 = load ptr, ptr %3, align 4, !dbg !254
  %10 = load ptr, ptr %4, align 4, !dbg !254
  %11 = call { ptr, ptr } asm sideeffect "1:ldrex $0, [$2];strex $1, $3, [$2];cmp $1, #0;bne 1b;", "=&r,=&r,r,r,0,1,~{memory},~{cc}"(ptr %9, ptr %10, ptr %7, ptr %8) #6, !dbg !254, !srcloc !258
  %12 = extractvalue { ptr, ptr } %11, 0, !dbg !254
  %13 = extractvalue { ptr, ptr } %11, 1, !dbg !254
  store ptr %12, ptr %5, align 4, !dbg !254
  store ptr %13, ptr %6, align 4, !dbg !254
  %14 = load ptr, ptr %5, align 4, !dbg !254
  ret ptr %14, !dbg !254
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_md_store_ptr(ptr noundef %0, ptr noundef %1) #0 !dbg !259 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !264, !DIExpression(), !265)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !266, !DIExpression(), !265)
  %5 = load ptr, ptr %3, align 4, !dbg !265
  %6 = load ptr, ptr %4, align 4, !dbg !265
  call void asm sideeffect "str $1, [$0]", "r,r,~{memory}"(ptr %5, ptr %6) #6, !dbg !265, !srcloc !267
  ret void, !dbg !265
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !268 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !273, !DIExpression(), !274)
    #dbg_declare(ptr %3, !275, !DIExpression(), !274)
  store i32 0, ptr %3, align 4, !dbg !274
  %4 = load ptr, ptr %2, align 4, !dbg !274
  %5 = call i32 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #6, !dbg !274, !srcloc !277
  store i32 %5, ptr %3, align 4, !dbg !274
  %6 = load i32, ptr %3, align 4, !dbg !274
  ret i32 %6, !dbg !274
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_stall() #0 !dbg !278 {
  call void asm sideeffect "", "~{memory}"() #6, !dbg !279, !srcloc !280
  ret void, !dbg !281
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_lock() #0 !dbg !282 {
  call arm_aapcscc void @ck_pr_fence_strict_lock(), !dbg !283
  ret void, !dbg !283
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_store_atomic() #0 !dbg !284 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #6, !dbg !285, !srcloc !286
  ret void, !dbg !287
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_lock() #0 !dbg !288 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #6, !dbg !289, !srcloc !290
  ret void, !dbg !291
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_unlock() #0 !dbg !292 {
  call arm_aapcscc void @ck_pr_fence_strict_unlock(), !dbg !293
  ret void, !dbg !293
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc ptr @ck_pr_md_load_ptr(ptr noundef %0) #0 !dbg !294 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !297, !DIExpression(), !298)
    #dbg_declare(ptr %3, !299, !DIExpression(), !298)
  store i32 0, ptr %3, align 4, !dbg !298
  %4 = load ptr, ptr %2, align 4, !dbg !298
  %5 = call i32 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #6, !dbg !298, !srcloc !300
  store i32 %5, ptr %3, align 4, !dbg !298
  %6 = load i32, ptr %3, align 4, !dbg !298
  %7 = inttoptr i32 %6 to ptr, !dbg !298
  ret ptr %7, !dbg !298
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc zeroext i1 @ck_pr_cas_ptr(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 !dbg !301 {
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca ptr, align 4
  %7 = alloca ptr, align 4
  %8 = alloca ptr, align 4
  store ptr %0, ptr %4, align 4
    #dbg_declare(ptr %4, !304, !DIExpression(), !305)
  store ptr %1, ptr %5, align 4
    #dbg_declare(ptr %5, !306, !DIExpression(), !307)
  store ptr %2, ptr %6, align 4
    #dbg_declare(ptr %6, !308, !DIExpression(), !309)
    #dbg_declare(ptr %7, !310, !DIExpression(), !311)
    #dbg_declare(ptr %8, !312, !DIExpression(), !313)
  %9 = load ptr, ptr %4, align 4, !dbg !314
  %10 = load ptr, ptr %6, align 4, !dbg !315
  %11 = load ptr, ptr %5, align 4, !dbg !316
  %12 = call { ptr, ptr } asm sideeffect "1:ldrex $0, [$2];cmp   $0, $4;itt eq;strexeq $1, $3, [$2];cmpeq   $1, #1;beq   1b;", "=&r,=&r,r,r,r,~{memory},~{cc}"(ptr %9, ptr %10, ptr %11) #6, !dbg !317, !srcloc !318
  %13 = extractvalue { ptr, ptr } %12, 0, !dbg !317
  %14 = extractvalue { ptr, ptr } %12, 1, !dbg !317
  store ptr %13, ptr %7, align 4, !dbg !317
  store ptr %14, ptr %8, align 4, !dbg !317
  %15 = load ptr, ptr %7, align 4, !dbg !319
  %16 = load ptr, ptr %5, align 4, !dbg !320
  %17 = icmp eq ptr %15, %16, !dbg !321
  ret i1 %17, !dbg !322
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !323 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !327, !DIExpression(), !328)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !329, !DIExpression(), !328)
  %5 = load ptr, ptr %3, align 4, !dbg !328
  %6 = load i32, ptr %4, align 4, !dbg !328
  call void asm sideeffect "str $1, [$0]", "r,r,~{memory}"(ptr %5, i32 %6) #6, !dbg !328, !srcloc !330
  ret void, !dbg !328
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_unlock() #0 !dbg !331 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #6, !dbg !332, !srcloc !333
  ret void, !dbg !334
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #4 = { allocsize(0) }
attributes #5 = { noreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!46, !47, !48, !49, !50, !51, !52}
!llvm.ident = !{!53}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 10, type: !9, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !22, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/mcslock.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "4d52312d3fd6710159db4cbd2182b2bc")
!4 = !{!5, !6, !9, !8, !17, !19, !15, !11}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !7, line: 17, baseType: !8)
!7 = !DIFile(filename: "include/libc/stdint.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "027aa838071dee39e5261b0fdecb37d3")
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_mcs_t", file: !10, line: 42, baseType: !11)
!10 = !DIFile(filename: "../ck/include/spinlock/mcs.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "027f57d568cbbfbb353298638ea153e7")
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 32)
!12 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_mcs", file: !10, line: 38, size: 64, elements: !13)
!13 = !{!14, !16}
!14 = !DIDerivedType(tag: DW_TAG_member, name: "locked", scope: !12, file: !10, line: 39, baseType: !15, size: 32)
!15 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !12, file: !10, line: 40, baseType: !11, size: 32, offset: 32)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !18, line: 3, baseType: !15)
!18 = !DIFile(filename: "include/libc/_size_t.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "dc11ce4c8eb4c64bece0363f758637cd")
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !20, line: 4, baseType: !21)
!20 = !DIFile(filename: "include/libc/stdbool.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6e643322591bab80343344357c642cba")
!21 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!22 = !{!0, !23, !25, !27, !33, !38, !44}
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 13, type: !8, isLocal: false, isDefinition: true)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 13, type: !8, isLocal: false, isDefinition: true)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !29, isLocal: true, isDefinition: true)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 248, elements: !31)
!30 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!31 = !{!32}
!32 = !DISubrange(count: 31)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !35, isLocal: true, isDefinition: true)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 192, elements: !36)
!36 = !{!37}
!37 = !DISubrange(count: 24)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !3, line: 63, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 40, elements: !42)
!41 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !30)
!42 = !{!43}
!43 = !DISubrange(count: 5)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "nodes", scope: !2, file: !3, line: 11, type: !9, isLocal: false, isDefinition: true)
!46 = !{i32 7, !"Dwarf Version", i32 5}
!47 = !{i32 2, !"Debug Info Version", i32 3}
!48 = !{i32 1, !"wchar_size", i32 4}
!49 = !{i32 1, !"min_enum_size", i32 4}
!50 = !{i32 8, !"PIC Level", i32 2}
!51 = !{i32 7, !"PIE Level", i32 2}
!52 = !{i32 7, !"frame-pointer", i32 2}
!53 = !{!"Homebrew clang version 22.1.8"}
!54 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 15, type: !55, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!55 = !DISubroutineType(types: !56)
!56 = !{!5, !5}
!57 = !{}
!58 = !DILocalVariable(name: "arg", arg: 1, scope: !54, file: !3, line: 15, type: !5)
!59 = !DILocation(line: 15, column: 17, scope: !54)
!60 = !DILocalVariable(name: "tid", scope: !54, file: !3, line: 18, type: !6)
!61 = !DILocation(line: 18, column: 14, scope: !54)
!62 = !DILocation(line: 18, column: 31, scope: !54)
!63 = !DILocation(line: 18, column: 21, scope: !54)
!64 = !DILocalVariable(name: "thread_node", scope: !54, file: !3, line: 20, type: !9)
!65 = !DILocation(line: 20, column: 23, scope: !54)
!66 = !DILocation(line: 20, column: 38, scope: !54)
!67 = !DILocation(line: 20, column: 44, scope: !54)
!68 = !DILocation(line: 22, column: 33, scope: !54)
!69 = !DILocation(line: 22, column: 5, scope: !54)
!70 = !DILocation(line: 24, column: 6, scope: !54)
!71 = !DILocation(line: 25, column: 6, scope: !54)
!72 = !DILocation(line: 27, column: 35, scope: !54)
!73 = !DILocation(line: 27, column: 5, scope: !54)
!74 = !DILocation(line: 29, column: 5, scope: !54)
!75 = distinct !DISubprogram(name: "ck_spinlock_mcs_lock", scope: !10, file: !10, line: 82, type: !76, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !57)
!76 = !DISubroutineType(types: !77)
!77 = !{null, !78, !11}
!78 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 32)
!79 = !DILocalVariable(name: "queue", arg: 1, scope: !75, file: !10, line: 82, type: !78)
!80 = !DILocation(line: 82, column: 47, scope: !75)
!81 = !DILocalVariable(name: "node", arg: 2, scope: !75, file: !10, line: 83, type: !11)
!82 = !DILocation(line: 83, column: 29, scope: !75)
!83 = !DILocalVariable(name: "previous", scope: !75, file: !10, line: 85, type: !11)
!84 = !DILocation(line: 85, column: 26, scope: !75)
!85 = !DILocation(line: 91, column: 2, scope: !75)
!86 = !DILocation(line: 91, column: 8, scope: !75)
!87 = !DILocation(line: 91, column: 15, scope: !75)
!88 = !DILocation(line: 92, column: 2, scope: !75)
!89 = !DILocation(line: 92, column: 8, scope: !75)
!90 = !DILocation(line: 92, column: 13, scope: !75)
!91 = !DILocation(line: 93, column: 2, scope: !75)
!92 = !DILocation(line: 100, column: 27, scope: !75)
!93 = !DILocation(line: 100, column: 34, scope: !75)
!94 = !DILocation(line: 100, column: 13, scope: !75)
!95 = !DILocation(line: 100, column: 11, scope: !75)
!96 = !DILocation(line: 101, column: 6, scope: !97)
!97 = distinct !DILexicalBlock(scope: !75, file: !10, line: 101, column: 6)
!98 = !DILocation(line: 101, column: 15, scope: !97)
!99 = !DILocation(line: 106, column: 20, scope: !100)
!100 = distinct !DILexicalBlock(scope: !97, file: !10, line: 101, column: 24)
!101 = !DILocation(line: 106, column: 30, scope: !100)
!102 = !DILocation(line: 106, column: 36, scope: !100)
!103 = !DILocation(line: 106, column: 3, scope: !100)
!104 = !DILocation(line: 107, column: 3, scope: !100)
!105 = !DILocation(line: 107, column: 27, scope: !100)
!106 = !DILocation(line: 107, column: 33, scope: !100)
!107 = !DILocation(line: 107, column: 10, scope: !100)
!108 = !DILocation(line: 107, column: 41, scope: !100)
!109 = !DILocation(line: 108, column: 4, scope: !100)
!110 = distinct !{!110, !104, !111, !112}
!111 = !DILocation(line: 108, column: 16, scope: !100)
!112 = !{!"llvm.loop.mustprogress"}
!113 = !DILocation(line: 109, column: 2, scope: !100)
!114 = !DILocation(line: 111, column: 2, scope: !75)
!115 = !DILocation(line: 112, column: 2, scope: !75)
!116 = distinct !DISubprogram(name: "ck_spinlock_mcs_unlock", scope: !10, file: !10, line: 116, type: !76, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !57)
!117 = !DILocalVariable(name: "queue", arg: 1, scope: !116, file: !10, line: 116, type: !78)
!118 = !DILocation(line: 116, column: 49, scope: !116)
!119 = !DILocalVariable(name: "node", arg: 2, scope: !116, file: !10, line: 117, type: !11)
!120 = !DILocation(line: 117, column: 29, scope: !116)
!121 = !DILocalVariable(name: "next", scope: !116, file: !10, line: 119, type: !11)
!122 = !DILocation(line: 119, column: 26, scope: !116)
!123 = !DILocation(line: 121, column: 2, scope: !116)
!124 = !DILocation(line: 123, column: 25, scope: !116)
!125 = !DILocation(line: 123, column: 31, scope: !116)
!126 = !DILocation(line: 123, column: 9, scope: !116)
!127 = !DILocation(line: 123, column: 7, scope: !116)
!128 = !DILocation(line: 124, column: 6, scope: !129)
!129 = distinct !DILexicalBlock(scope: !116, file: !10, line: 124, column: 6)
!130 = !DILocation(line: 124, column: 11, scope: !129)
!131 = !DILocation(line: 130, column: 22, scope: !132)
!132 = distinct !DILexicalBlock(scope: !133, file: !10, line: 130, column: 7)
!133 = distinct !DILexicalBlock(scope: !129, file: !10, line: 124, column: 20)
!134 = !DILocation(line: 130, column: 7, scope: !132)
!135 = !DILocation(line: 130, column: 32, scope: !132)
!136 = !DILocation(line: 130, column: 29, scope: !132)
!137 = !DILocation(line: 130, column: 37, scope: !132)
!138 = !DILocation(line: 131, column: 21, scope: !132)
!139 = !DILocation(line: 131, column: 28, scope: !132)
!140 = !DILocation(line: 131, column: 7, scope: !132)
!141 = !DILocation(line: 131, column: 40, scope: !132)
!142 = !DILocation(line: 132, column: 4, scope: !143)
!143 = distinct !DILexicalBlock(scope: !132, file: !10, line: 131, column: 49)
!144 = !DILocation(line: 141, column: 3, scope: !133)
!145 = !DILocation(line: 142, column: 27, scope: !146)
!146 = distinct !DILexicalBlock(scope: !147, file: !10, line: 141, column: 12)
!147 = distinct !DILexicalBlock(scope: !148, file: !10, line: 141, column: 3)
!148 = distinct !DILexicalBlock(scope: !133, file: !10, line: 141, column: 3)
!149 = !DILocation(line: 142, column: 33, scope: !146)
!150 = !DILocation(line: 142, column: 11, scope: !146)
!151 = !DILocation(line: 142, column: 9, scope: !146)
!152 = !DILocation(line: 143, column: 8, scope: !153)
!153 = distinct !DILexicalBlock(scope: !146, file: !10, line: 143, column: 8)
!154 = !DILocation(line: 143, column: 13, scope: !153)
!155 = !DILocation(line: 144, column: 5, scope: !153)
!156 = !DILocation(line: 146, column: 4, scope: !146)
!157 = !DILocation(line: 141, column: 3, scope: !147)
!158 = distinct !{!158, !159, !160}
!159 = !DILocation(line: 141, column: 3, scope: !148)
!160 = !DILocation(line: 147, column: 3, scope: !148)
!161 = !DILocation(line: 148, column: 2, scope: !133)
!162 = !DILocation(line: 151, column: 20, scope: !116)
!163 = !DILocation(line: 151, column: 26, scope: !116)
!164 = !DILocation(line: 151, column: 2, scope: !116)
!165 = !DILocation(line: 152, column: 2, scope: !116)
!166 = !DILocation(line: 153, column: 1, scope: !116)
!167 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 32, type: !168, scopeLine: 33, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !57)
!168 = !DISubroutineType(types: !169)
!169 = !{!8}
!170 = !DILocalVariable(name: "threads", scope: !167, file: !3, line: 34, type: !171)
!171 = !DICompositeType(tag: DW_TAG_array_type, baseType: !172, size: 64, elements: !174)
!172 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !173, line: 2, baseType: !5)
!173 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!174 = !{!175}
!175 = !DISubrange(count: 2)
!176 = !DILocation(line: 34, column: 15, scope: !167)
!177 = !DILocalVariable(name: "i", scope: !167, file: !3, line: 35, type: !8)
!178 = !DILocation(line: 35, column: 9, scope: !167)
!179 = !DILocation(line: 37, column: 32, scope: !167)
!180 = !DILocation(line: 37, column: 11, scope: !167)
!181 = !DILocation(line: 38, column: 9, scope: !182)
!182 = distinct !DILexicalBlock(scope: !167, file: !3, line: 38, column: 9)
!183 = !DILocation(line: 38, column: 15, scope: !182)
!184 = !DILocation(line: 40, column: 9, scope: !185)
!185 = distinct !DILexicalBlock(scope: !182, file: !3, line: 39, column: 5)
!186 = !DILocation(line: 43, column: 10, scope: !167)
!187 = !DILocation(line: 45, column: 12, scope: !188)
!188 = distinct !DILexicalBlock(scope: !167, file: !3, line: 45, column: 5)
!189 = !DILocation(line: 45, column: 10, scope: !188)
!190 = !DILocation(line: 45, column: 17, scope: !191)
!191 = distinct !DILexicalBlock(scope: !188, file: !3, line: 45, column: 5)
!192 = !DILocation(line: 45, column: 19, scope: !191)
!193 = !DILocation(line: 45, column: 5, scope: !188)
!194 = !DILocation(line: 47, column: 37, scope: !195)
!195 = distinct !DILexicalBlock(scope: !196, file: !3, line: 47, column: 13)
!196 = distinct !DILexicalBlock(scope: !191, file: !3, line: 46, column: 5)
!197 = !DILocation(line: 47, column: 29, scope: !195)
!198 = !DILocation(line: 47, column: 68, scope: !195)
!199 = !DILocation(line: 47, column: 52, scope: !195)
!200 = !DILocation(line: 47, column: 13, scope: !195)
!201 = !DILocation(line: 47, column: 71, scope: !195)
!202 = !DILocation(line: 49, column: 18, scope: !203)
!203 = distinct !DILexicalBlock(scope: !195, file: !3, line: 48, column: 9)
!204 = !DILocation(line: 49, column: 13, scope: !203)
!205 = !DILocation(line: 50, column: 13, scope: !203)
!206 = !DILocation(line: 52, column: 5, scope: !196)
!207 = !DILocation(line: 45, column: 32, scope: !191)
!208 = !DILocation(line: 45, column: 5, scope: !191)
!209 = distinct !{!209, !193, !210, !112}
!210 = !DILocation(line: 52, column: 5, scope: !188)
!211 = !DILocation(line: 54, column: 12, scope: !212)
!212 = distinct !DILexicalBlock(scope: !167, file: !3, line: 54, column: 5)
!213 = !DILocation(line: 54, column: 10, scope: !212)
!214 = !DILocation(line: 54, column: 17, scope: !215)
!215 = distinct !DILexicalBlock(scope: !212, file: !3, line: 54, column: 5)
!216 = !DILocation(line: 54, column: 19, scope: !215)
!217 = !DILocation(line: 54, column: 5, scope: !212)
!218 = !DILocation(line: 56, column: 34, scope: !219)
!219 = distinct !DILexicalBlock(scope: !220, file: !3, line: 56, column: 13)
!220 = distinct !DILexicalBlock(scope: !215, file: !3, line: 55, column: 5)
!221 = !DILocation(line: 56, column: 26, scope: !219)
!222 = !DILocation(line: 56, column: 13, scope: !219)
!223 = !DILocation(line: 56, column: 44, scope: !219)
!224 = !DILocation(line: 58, column: 18, scope: !225)
!225 = distinct !DILexicalBlock(scope: !219, file: !3, line: 57, column: 9)
!226 = !DILocation(line: 58, column: 13, scope: !225)
!227 = !DILocation(line: 59, column: 13, scope: !225)
!228 = !DILocation(line: 61, column: 5, scope: !220)
!229 = !DILocation(line: 54, column: 32, scope: !215)
!230 = !DILocation(line: 54, column: 5, scope: !215)
!231 = distinct !{!231, !217, !232, !112}
!232 = !DILocation(line: 61, column: 5, scope: !212)
!233 = !DILocation(line: 63, column: 12, scope: !234)
!234 = distinct !DILexicalBlock(scope: !235, file: !3, line: 63, column: 5)
!235 = distinct !DILexicalBlock(scope: !167, file: !3, line: 63, column: 5)
!236 = !DILocation(line: 63, column: 14, scope: !234)
!237 = !DILocation(line: 63, column: 26, scope: !234)
!238 = !DILocation(line: 63, column: 29, scope: !234)
!239 = !DILocation(line: 63, column: 31, scope: !234)
!240 = !DILocation(line: 63, column: 5, scope: !234)
!241 = !DILocation(line: 65, column: 10, scope: !167)
!242 = !DILocation(line: 65, column: 5, scope: !167)
!243 = !DILocation(line: 67, column: 5, scope: !167)
!244 = distinct !DISubprogram(name: "ck_pr_fence_store_atomic", scope: !245, file: !245, line: 112, type: !246, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!245 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!246 = !DISubroutineType(types: !247)
!247 = !{null}
!248 = !DILocation(line: 112, column: 1, scope: !244)
!249 = distinct !DISubprogram(name: "ck_pr_fas_ptr", scope: !250, file: !250, line: 415, type: !251, scopeLine: 415, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !57)
!250 = !DIFile(filename: "../ck/include/gcc/arm/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f3f9fb174933d4f9d5af6678feea8d14")
!251 = !DISubroutineType(types: !252)
!252 = !{!5, !5, !5}
!253 = !DILocalVariable(name: "target", arg: 1, scope: !249, file: !250, line: 415, type: !5)
!254 = !DILocation(line: 415, column: 1, scope: !249)
!255 = !DILocalVariable(name: "v", arg: 2, scope: !249, file: !250, line: 415, type: !5)
!256 = !DILocalVariable(name: "previous", scope: !249, file: !250, line: 415, type: !5)
!257 = !DILocalVariable(name: "tmp", scope: !249, file: !250, line: 415, type: !5)
!258 = !{i64 2147601708}
!259 = distinct !DISubprogram(name: "ck_pr_md_store_ptr", scope: !250, file: !250, line: 169, type: !260, scopeLine: 169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !57)
!260 = !DISubroutineType(types: !261)
!261 = !{null, !5, !262}
!262 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !263, size: 32)
!263 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!264 = !DILocalVariable(name: "target", arg: 1, scope: !259, file: !250, line: 169, type: !5)
!265 = !DILocation(line: 169, column: 1, scope: !259)
!266 = !DILocalVariable(name: "v", arg: 2, scope: !259, file: !250, line: 169, type: !262)
!267 = !{i64 2147588323}
!268 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !250, file: !250, line: 127, type: !269, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !57)
!269 = !DISubroutineType(types: !270)
!270 = !{!15, !271}
!271 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !272, size: 32)
!272 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!273 = !DILocalVariable(name: "target", arg: 1, scope: !268, file: !250, line: 127, type: !271)
!274 = !DILocation(line: 127, column: 1, scope: !268)
!275 = !DILocalVariable(name: "r", scope: !268, file: !250, line: 127, type: !276)
!276 = !DIBasicType(name: "long", size: 32, encoding: DW_ATE_signed)
!277 = !{i64 2147586915}
!278 = distinct !DISubprogram(name: "ck_pr_stall", scope: !250, file: !250, line: 50, type: !246, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!279 = !DILocation(line: 53, column: 2, scope: !278)
!280 = !{i64 79124}
!281 = !DILocation(line: 54, column: 2, scope: !278)
!282 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !245, file: !245, line: 122, type: !246, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!283 = !DILocation(line: 122, column: 1, scope: !282)
!284 = distinct !DISubprogram(name: "ck_pr_fence_strict_store_atomic", scope: !250, file: !250, line: 88, type: !246, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!285 = !DILocation(line: 88, column: 27, scope: !284)
!286 = !{i64 2147581707}
!287 = !DILocation(line: 88, column: 1, scope: !284)
!288 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !250, file: !250, line: 98, type: !246, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!289 = !DILocation(line: 98, column: 19, scope: !288)
!290 = !{i64 2147584712}
!291 = !DILocation(line: 98, column: 1, scope: !288)
!292 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !245, file: !245, line: 123, type: !246, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!293 = !DILocation(line: 123, column: 1, scope: !292)
!294 = distinct !DISubprogram(name: "ck_pr_md_load_ptr", scope: !250, file: !250, line: 120, type: !295, scopeLine: 120, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !57)
!295 = !DISubroutineType(types: !296)
!296 = !{!5, !262}
!297 = !DILocalVariable(name: "target", arg: 1, scope: !294, file: !250, line: 120, type: !262)
!298 = !DILocation(line: 120, column: 1, scope: !294)
!299 = !DILocalVariable(name: "r", scope: !294, file: !250, line: 120, type: !276)
!300 = !{i64 2147585369}
!301 = distinct !DISubprogram(name: "ck_pr_cas_ptr", scope: !250, file: !250, line: 320, type: !302, scopeLine: 321, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !57)
!302 = !DISubroutineType(types: !303)
!303 = !{!19, !5, !5, !5}
!304 = !DILocalVariable(name: "target", arg: 1, scope: !301, file: !250, line: 320, type: !5)
!305 = !DILocation(line: 320, column: 21, scope: !301)
!306 = !DILocalVariable(name: "compare", arg: 2, scope: !301, file: !250, line: 320, type: !5)
!307 = !DILocation(line: 320, column: 35, scope: !301)
!308 = !DILocalVariable(name: "set", arg: 3, scope: !301, file: !250, line: 320, type: !5)
!309 = !DILocation(line: 320, column: 50, scope: !301)
!310 = !DILocalVariable(name: "previous", scope: !301, file: !250, line: 322, type: !5)
!311 = !DILocation(line: 322, column: 8, scope: !301)
!312 = !DILocalVariable(name: "tmp", scope: !301, file: !250, line: 322, type: !5)
!313 = !DILocation(line: 322, column: 19, scope: !301)
!314 = !DILocation(line: 332, column: 16, scope: !301)
!315 = !DILocation(line: 333, column: 14, scope: !301)
!316 = !DILocation(line: 334, column: 14, scope: !301)
!317 = !DILocation(line: 323, column: 2, scope: !301)
!318 = !{i64 86220}
!319 = !DILocation(line: 336, column: 10, scope: !301)
!320 = !DILocation(line: 336, column: 22, scope: !301)
!321 = !DILocation(line: 336, column: 19, scope: !301)
!322 = !DILocation(line: 336, column: 2, scope: !301)
!323 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !250, file: !250, line: 176, type: !324, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !57)
!324 = !DISubroutineType(types: !325)
!325 = !{null, !326, !15}
!326 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 32)
!327 = !DILocalVariable(name: "target", arg: 1, scope: !323, file: !250, line: 176, type: !326)
!328 = !DILocation(line: 176, column: 1, scope: !323)
!329 = !DILocalVariable(name: "v", arg: 2, scope: !323, file: !250, line: 176, type: !15)
!330 = !{i64 2147589784}
!331 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !250, file: !250, line: 99, type: !246, scopeLine: 99, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!332 = !DILocation(line: 99, column: 21, scope: !331)
!333 = !{i64 2147585007}
!334 = !DILocation(line: 99, column: 1, scope: !331)
