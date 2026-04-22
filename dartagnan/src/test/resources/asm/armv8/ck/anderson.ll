; ModuleID = 'benchmarks/ck/anderson.c'
source_filename = "benchmarks/ck/anderson.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv8a-pc-linux-gnu"

%struct.ck_spinlock_anderson = type { ptr, i32, i32, i32, [48 x i8], i32 }
%struct.ck_spinlock_anderson_thread = type { i32, i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !19
@lock = dso_local global %struct.ck_spinlock_anderson zeroinitializer, align 4, !dbg !38
@slots = dso_local global ptr null, align 4, !dbg !53
@.str = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !21
@.str.1 = private unnamed_addr constant [25 x i8] c"benchmarks/ck/anderson.c\00", align 1, !dbg !27
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !32

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc ptr @run(ptr noundef %0) #0 !dbg !63 {
  %2 = alloca ptr, align 4
  %3 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !67, !DIExpression(), !68)
    #dbg_declare(ptr %3, !69, !DIExpression(), !70)
  call arm_aapcscc void @ck_spinlock_anderson_lock(ptr noundef @lock, ptr noundef %3), !dbg !71
  %4 = load i32, ptr @x, align 4, !dbg !72
  %5 = add nsw i32 %4, 1, !dbg !72
  store i32 %5, ptr @x, align 4, !dbg !72
  %6 = load i32, ptr @y, align 4, !dbg !73
  %7 = add nsw i32 %6, 1, !dbg !73
  store i32 %7, ptr @y, align 4, !dbg !73
  %8 = load ptr, ptr %3, align 4, !dbg !74
  call arm_aapcscc void @ck_spinlock_anderson_unlock(ptr noundef @lock, ptr noundef %8), !dbg !75
  ret ptr null, !dbg !76
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_anderson_lock(ptr noundef %0, ptr noundef %1) #0 !dbg !77 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !82, !DIExpression(), !83)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !84, !DIExpression(), !85)
    #dbg_declare(ptr %5, !86, !DIExpression(), !87)
    #dbg_declare(ptr %6, !88, !DIExpression(), !89)
    #dbg_declare(ptr %7, !90, !DIExpression(), !91)
  %8 = load ptr, ptr %3, align 4, !dbg !92
  %9 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %8, i32 0, i32 1, !dbg !93
  %10 = load i32, ptr %9, align 4, !dbg !93
  store i32 %10, ptr %7, align 4, !dbg !91
  %11 = load ptr, ptr %3, align 4, !dbg !94
  %12 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %11, i32 0, i32 2, !dbg !96
  %13 = load i32, ptr %12, align 4, !dbg !96
  %14 = icmp ne i32 %13, 0, !dbg !97
  br i1 %14, label %15, label %42, !dbg !97

15:                                               ; preds = %2
  %16 = load ptr, ptr %3, align 4, !dbg !98
  %17 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %16, i32 0, i32 5, !dbg !100
  %18 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %17), !dbg !101
  store i32 %18, ptr %5, align 4, !dbg !102
  br label %19, !dbg !103

19:                                               ; preds = %30, %15
  %20 = load i32, ptr %5, align 4, !dbg !104
  %21 = icmp eq i32 %20, -1, !dbg !107
  br i1 %21, label %22, label %26, !dbg !107

22:                                               ; preds = %19
  %23 = load ptr, ptr %3, align 4, !dbg !108
  %24 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %23, i32 0, i32 2, !dbg !109
  %25 = load i32, ptr %24, align 4, !dbg !109
  store i32 %25, ptr %6, align 4, !dbg !110
  br label %29, !dbg !111

26:                                               ; preds = %19
  %27 = load i32, ptr %5, align 4, !dbg !112
  %28 = add i32 %27, 1, !dbg !113
  store i32 %28, ptr %6, align 4, !dbg !114
  br label %29

29:                                               ; preds = %26, %22
  br label %30, !dbg !115

30:                                               ; preds = %29
  %31 = load ptr, ptr %3, align 4, !dbg !116
  %32 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %31, i32 0, i32 5, !dbg !117
  %33 = load i32, ptr %5, align 4, !dbg !118
  %34 = load i32, ptr %6, align 4, !dbg !119
  %35 = call arm_aapcscc zeroext i1 @ck_pr_cas_uint_value(ptr noundef %32, i32 noundef %33, i32 noundef %34, ptr noundef %5), !dbg !120
  %36 = zext i1 %35 to i32, !dbg !120
  %37 = icmp eq i32 %36, 0, !dbg !121
  br i1 %37, label %19, label %38, !dbg !115, !llvm.loop !122

38:                                               ; preds = %30
  %39 = load i32, ptr %7, align 4, !dbg !125
  %40 = load i32, ptr %5, align 4, !dbg !126
  %41 = urem i32 %40, %39, !dbg !126
  store i32 %41, ptr %5, align 4, !dbg !126
  br label %51, !dbg !127

42:                                               ; preds = %2
  %43 = load ptr, ptr %3, align 4, !dbg !128
  %44 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %43, i32 0, i32 5, !dbg !130
  %45 = call arm_aapcscc i32 @ck_pr_faa_uint(ptr noundef %44, i32 noundef 1), !dbg !131
  store i32 %45, ptr %5, align 4, !dbg !132
  %46 = load ptr, ptr %3, align 4, !dbg !133
  %47 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %46, i32 0, i32 3, !dbg !134
  %48 = load i32, ptr %47, align 4, !dbg !134
  %49 = load i32, ptr %5, align 4, !dbg !135
  %50 = and i32 %49, %48, !dbg !135
  store i32 %50, ptr %5, align 4, !dbg !135
  br label %51

51:                                               ; preds = %42, %38
  call arm_aapcscc void @ck_pr_fence_load(), !dbg !136
  br label %52, !dbg !137

52:                                               ; preds = %61, %51
  %53 = load ptr, ptr %3, align 4, !dbg !138
  %54 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %53, i32 0, i32 0, !dbg !139
  %55 = load ptr, ptr %54, align 4, !dbg !139
  %56 = load i32, ptr %5, align 4, !dbg !140
  %57 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %55, i32 %56, !dbg !138
  %58 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %57, i32 0, i32 0, !dbg !141
  %59 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %58), !dbg !142
  %60 = icmp eq i32 %59, 1, !dbg !143
  br i1 %60, label %61, label %62, !dbg !137

61:                                               ; preds = %52
  call arm_aapcscc void @ck_pr_stall(), !dbg !144
  br label %52, !dbg !137, !llvm.loop !145

62:                                               ; preds = %52
  %63 = load ptr, ptr %3, align 4, !dbg !147
  %64 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %63, i32 0, i32 0, !dbg !148
  %65 = load ptr, ptr %64, align 4, !dbg !148
  %66 = load i32, ptr %5, align 4, !dbg !149
  %67 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %65, i32 %66, !dbg !147
  %68 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %67, i32 0, i32 0, !dbg !150
  call arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %68, i32 noundef 1), !dbg !151
  call arm_aapcscc void @ck_pr_fence_lock(), !dbg !152
  %69 = load ptr, ptr %3, align 4, !dbg !153
  %70 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %69, i32 0, i32 0, !dbg !154
  %71 = load ptr, ptr %70, align 4, !dbg !154
  %72 = load i32, ptr %5, align 4, !dbg !155
  %73 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %71, i32 %72, !dbg !156
  %74 = load ptr, ptr %4, align 4, !dbg !157
  store ptr %73, ptr %74, align 4, !dbg !158
  ret void, !dbg !159
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_anderson_unlock(ptr noundef %0, ptr noundef %1) #0 !dbg !160 {
  %3 = alloca ptr, align 4
  %4 = alloca ptr, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !163, !DIExpression(), !164)
  store ptr %1, ptr %4, align 4
    #dbg_declare(ptr %4, !165, !DIExpression(), !166)
    #dbg_declare(ptr %5, !167, !DIExpression(), !168)
  call arm_aapcscc void @ck_pr_fence_unlock(), !dbg !169
  %6 = load ptr, ptr %3, align 4, !dbg !170
  %7 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %6, i32 0, i32 2, !dbg !172
  %8 = load i32, ptr %7, align 4, !dbg !172
  %9 = icmp eq i32 %8, 0, !dbg !173
  br i1 %9, label %10, label %19, !dbg !173

10:                                               ; preds = %2
  %11 = load ptr, ptr %4, align 4, !dbg !174
  %12 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %11, i32 0, i32 1, !dbg !175
  %13 = load i32, ptr %12, align 4, !dbg !175
  %14 = add i32 %13, 1, !dbg !176
  %15 = load ptr, ptr %3, align 4, !dbg !177
  %16 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %15, i32 0, i32 3, !dbg !178
  %17 = load i32, ptr %16, align 4, !dbg !178
  %18 = and i32 %14, %17, !dbg !179
  store i32 %18, ptr %5, align 4, !dbg !180
  br label %28, !dbg !181

19:                                               ; preds = %2
  %20 = load ptr, ptr %4, align 4, !dbg !182
  %21 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %20, i32 0, i32 1, !dbg !183
  %22 = load i32, ptr %21, align 4, !dbg !183
  %23 = add i32 %22, 1, !dbg !184
  %24 = load ptr, ptr %3, align 4, !dbg !185
  %25 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %24, i32 0, i32 1, !dbg !186
  %26 = load i32, ptr %25, align 4, !dbg !186
  %27 = urem i32 %23, %26, !dbg !187
  store i32 %27, ptr %5, align 4, !dbg !188
  br label %28

28:                                               ; preds = %19, %10
  %29 = load ptr, ptr %3, align 4, !dbg !189
  %30 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %29, i32 0, i32 0, !dbg !190
  %31 = load ptr, ptr %30, align 4, !dbg !190
  %32 = load i32, ptr %5, align 4, !dbg !191
  %33 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %31, i32 %32, !dbg !189
  %34 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %33, i32 0, i32 0, !dbg !192
  call arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %34, i32 noundef 0), !dbg !193
  ret void, !dbg !194
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc i32 @main() #0 !dbg !195 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 4
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !198, !DIExpression(), !204)
    #dbg_declare(ptr %3, !205, !DIExpression(), !206)
  %4 = call arm_aapcscc ptr @malloc(i32 noundef 24) #4, !dbg !207
  store ptr %4, ptr @slots, align 4, !dbg !208
  %5 = load ptr, ptr @slots, align 4, !dbg !209
  %6 = icmp eq ptr %5, null, !dbg !211
  br i1 %6, label %7, label %8, !dbg !211

7:                                                ; preds = %0
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !212
  unreachable, !dbg !212

8:                                                ; preds = %0
  %9 = load ptr, ptr @slots, align 4, !dbg !214
  call arm_aapcscc void @ck_spinlock_anderson_init(ptr noundef @lock, ptr noundef %9, i32 noundef 3), !dbg !215
  store i32 0, ptr %3, align 4, !dbg !216
  br label %10, !dbg !218

10:                                               ; preds = %20, %8
  %11 = load i32, ptr %3, align 4, !dbg !219
  %12 = icmp slt i32 %11, 3, !dbg !221
  br i1 %12, label %13, label %23, !dbg !222

13:                                               ; preds = %10
  %14 = load i32, ptr %3, align 4, !dbg !223
  %15 = getelementptr inbounds [3 x ptr], ptr %2, i32 0, i32 %14, !dbg !226
  %16 = call arm_aapcscc i32 @pthread_create(ptr noundef %15, ptr noundef null, ptr noundef @run, ptr noundef null), !dbg !227
  %17 = icmp ne i32 %16, 0, !dbg !228
  br i1 %17, label %18, label %19, !dbg !228

18:                                               ; preds = %13
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !229
  unreachable, !dbg !229

19:                                               ; preds = %13
  br label %20, !dbg !231

20:                                               ; preds = %19
  %21 = load i32, ptr %3, align 4, !dbg !232
  %22 = add nsw i32 %21, 1, !dbg !232
  store i32 %22, ptr %3, align 4, !dbg !232
  br label %10, !dbg !233, !llvm.loop !234

23:                                               ; preds = %10
  store i32 0, ptr %3, align 4, !dbg !236
  br label %24, !dbg !238

24:                                               ; preds = %35, %23
  %25 = load i32, ptr %3, align 4, !dbg !239
  %26 = icmp slt i32 %25, 3, !dbg !241
  br i1 %26, label %27, label %38, !dbg !242

27:                                               ; preds = %24
  %28 = load i32, ptr %3, align 4, !dbg !243
  %29 = getelementptr inbounds [3 x ptr], ptr %2, i32 0, i32 %28, !dbg !246
  %30 = load ptr, ptr %29, align 4, !dbg !246
  %31 = call arm_aapcscc i32 @pthread_join(ptr noundef %30, ptr noundef null), !dbg !247
  %32 = icmp ne i32 %31, 0, !dbg !248
  br i1 %32, label %33, label %34, !dbg !248

33:                                               ; preds = %27
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !249
  unreachable, !dbg !249

34:                                               ; preds = %27
  br label %35, !dbg !251

35:                                               ; preds = %34
  %36 = load i32, ptr %3, align 4, !dbg !252
  %37 = add nsw i32 %36, 1, !dbg !252
  store i32 %37, ptr %3, align 4, !dbg !252
  br label %24, !dbg !253, !llvm.loop !254

38:                                               ; preds = %24
  %39 = load i32, ptr @x, align 4, !dbg !256
  %40 = icmp eq i32 %39, 3, !dbg !259
  br i1 %40, label %41, label %44, !dbg !260

41:                                               ; preds = %38
  %42 = load i32, ptr @y, align 4, !dbg !261
  %43 = icmp eq i32 %42, 3, !dbg !262
  br i1 %43, label %45, label %44, !dbg !263

44:                                               ; preds = %41, %38
  call arm_aapcscc void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 55, ptr noundef @__func__.main), !dbg !263
  br label %45, !dbg !263

45:                                               ; preds = %44, %41
  %46 = load ptr, ptr @slots, align 4, !dbg !264
  call arm_aapcscc void @free(ptr noundef %46), !dbg !265
  ret i32 0, !dbg !266
}

; Function Attrs: allocsize(0)
declare arm_aapcscc ptr @malloc(i32 noundef) #1

; Function Attrs: noreturn
declare arm_aapcscc void @exit(i32 noundef) #2

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_anderson_init(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 !dbg !267 {
  %4 = alloca ptr, align 4
  %5 = alloca ptr, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %4, align 4
    #dbg_declare(ptr %4, !270, !DIExpression(), !271)
  store ptr %1, ptr %5, align 4
    #dbg_declare(ptr %5, !272, !DIExpression(), !273)
  store i32 %2, ptr %6, align 4
    #dbg_declare(ptr %6, !274, !DIExpression(), !275)
    #dbg_declare(ptr %7, !276, !DIExpression(), !277)
  %8 = load ptr, ptr %5, align 4, !dbg !278
  %9 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %8, i32 0, !dbg !278
  %10 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %9, i32 0, i32 0, !dbg !279
  store i32 0, ptr %10, align 4, !dbg !280
  %11 = load ptr, ptr %5, align 4, !dbg !281
  %12 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %11, i32 0, !dbg !281
  %13 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %12, i32 0, i32 1, !dbg !282
  store i32 0, ptr %13, align 4, !dbg !283
  store i32 1, ptr %7, align 4, !dbg !284
  br label %14, !dbg !286

14:                                               ; preds = %28, %3
  %15 = load i32, ptr %7, align 4, !dbg !287
  %16 = load i32, ptr %6, align 4, !dbg !289
  %17 = icmp ult i32 %15, %16, !dbg !290
  br i1 %17, label %18, label %31, !dbg !291

18:                                               ; preds = %14
  %19 = load ptr, ptr %5, align 4, !dbg !292
  %20 = load i32, ptr %7, align 4, !dbg !294
  %21 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %19, i32 %20, !dbg !292
  %22 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %21, i32 0, i32 0, !dbg !295
  store i32 1, ptr %22, align 4, !dbg !296
  %23 = load i32, ptr %7, align 4, !dbg !297
  %24 = load ptr, ptr %5, align 4, !dbg !298
  %25 = load i32, ptr %7, align 4, !dbg !299
  %26 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %24, i32 %25, !dbg !298
  %27 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %26, i32 0, i32 1, !dbg !300
  store i32 %23, ptr %27, align 4, !dbg !301
  br label %28, !dbg !302

28:                                               ; preds = %18
  %29 = load i32, ptr %7, align 4, !dbg !303
  %30 = add i32 %29, 1, !dbg !303
  store i32 %30, ptr %7, align 4, !dbg !303
  br label %14, !dbg !304, !llvm.loop !305

31:                                               ; preds = %14
  %32 = load ptr, ptr %5, align 4, !dbg !307
  %33 = load ptr, ptr %4, align 4, !dbg !308
  %34 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %33, i32 0, i32 0, !dbg !309
  store ptr %32, ptr %34, align 4, !dbg !310
  %35 = load i32, ptr %6, align 4, !dbg !311
  %36 = load ptr, ptr %4, align 4, !dbg !312
  %37 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %36, i32 0, i32 1, !dbg !313
  store i32 %35, ptr %37, align 4, !dbg !314
  %38 = load i32, ptr %6, align 4, !dbg !315
  %39 = sub i32 %38, 1, !dbg !316
  %40 = load ptr, ptr %4, align 4, !dbg !317
  %41 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %40, i32 0, i32 3, !dbg !318
  store i32 %39, ptr %41, align 4, !dbg !319
  %42 = load ptr, ptr %4, align 4, !dbg !320
  %43 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %42, i32 0, i32 5, !dbg !321
  store i32 0, ptr %43, align 4, !dbg !322
  %44 = load i32, ptr %6, align 4, !dbg !323
  %45 = load i32, ptr %6, align 4, !dbg !325
  %46 = sub i32 %45, 1, !dbg !326
  %47 = and i32 %44, %46, !dbg !327
  %48 = icmp ne i32 %47, 0, !dbg !327
  br i1 %48, label %49, label %55, !dbg !327

49:                                               ; preds = %31
  %50 = load i32, ptr %6, align 4, !dbg !328
  %51 = urem i32 -1, %50, !dbg !329
  %52 = add i32 %51, 1, !dbg !330
  %53 = load ptr, ptr %4, align 4, !dbg !331
  %54 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %53, i32 0, i32 2, !dbg !332
  store i32 %52, ptr %54, align 4, !dbg !333
  br label %58, !dbg !331

55:                                               ; preds = %31
  %56 = load ptr, ptr %4, align 4, !dbg !334
  %57 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %56, i32 0, i32 2, !dbg !335
  store i32 0, ptr %57, align 4, !dbg !336
  br label %58

58:                                               ; preds = %55, %49
  call arm_aapcscc void @ck_pr_barrier(), !dbg !337
  ret void, !dbg !338
}

declare arm_aapcscc i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare arm_aapcscc i32 @pthread_join(ptr noundef, ptr noundef) #3

declare arm_aapcscc void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

declare arm_aapcscc void @free(ptr noundef) #3

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !339 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !345, !DIExpression(), !346)
    #dbg_declare(ptr %3, !347, !DIExpression(), !346)
  store i32 0, ptr %3, align 4, !dbg !346
  %4 = load ptr, ptr %2, align 4, !dbg !346
  %5 = call i32 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #6, !dbg !346, !srcloc !349
  store i32 %5, ptr %3, align 4, !dbg !346
  %6 = load i32, ptr %3, align 4, !dbg !346
  ret i32 %6, !dbg !346
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc zeroext i1 @ck_pr_cas_uint_value(ptr noundef %0, i32 noundef %1, i32 noundef %2, ptr noundef %3) #0 !dbg !350 {
  %5 = alloca ptr, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store ptr %0, ptr %5, align 4
    #dbg_declare(ptr %5, !354, !DIExpression(), !355)
  store i32 %1, ptr %6, align 4
    #dbg_declare(ptr %6, !356, !DIExpression(), !355)
  store i32 %2, ptr %7, align 4
    #dbg_declare(ptr %7, !357, !DIExpression(), !355)
  store ptr %3, ptr %8, align 4
    #dbg_declare(ptr %8, !358, !DIExpression(), !355)
    #dbg_declare(ptr %9, !359, !DIExpression(), !355)
  store i32 0, ptr %9, align 4, !dbg !355
    #dbg_declare(ptr %10, !360, !DIExpression(), !355)
  store i32 0, ptr %10, align 4, !dbg !355
  %11 = load i32, ptr %9, align 4, !dbg !355
  %12 = load i32, ptr %10, align 4, !dbg !355
  %13 = load ptr, ptr %5, align 4, !dbg !355
  %14 = load i32, ptr %7, align 4, !dbg !355
  %15 = load i32, ptr %6, align 4, !dbg !355
  %16 = call { i32, i32 } asm sideeffect "1:ldrex $0, [$2];cmp   $0, $4;itt eq;strexeq $1, $3, [$2];cmpeq   $1, #1;beq   1b;", "=&r,=&r,r,r,r,0,1,~{memory},~{cc}"(ptr %13, i32 %14, i32 %15, i32 %11, i32 %12) #6, !dbg !355, !srcloc !361
  %17 = extractvalue { i32, i32 } %16, 0, !dbg !355
  %18 = extractvalue { i32, i32 } %16, 1, !dbg !355
  store i32 %17, ptr %9, align 4, !dbg !355
  store i32 %18, ptr %10, align 4, !dbg !355
  %19 = load i32, ptr %9, align 4, !dbg !355
  %20 = load ptr, ptr %8, align 4, !dbg !355
  store i32 %19, ptr %20, align 4, !dbg !355
  %21 = load i32, ptr %9, align 4, !dbg !355
  %22 = load i32, ptr %6, align 4, !dbg !355
  %23 = icmp eq i32 %21, %22, !dbg !355
  ret i1 %23, !dbg !355
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc i32 @ck_pr_faa_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !362 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !365, !DIExpression(), !366)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !367, !DIExpression(), !366)
    #dbg_declare(ptr %5, !368, !DIExpression(), !366)
  store i32 0, ptr %5, align 4, !dbg !366
    #dbg_declare(ptr %6, !369, !DIExpression(), !366)
  store i32 0, ptr %6, align 4, !dbg !366
    #dbg_declare(ptr %7, !370, !DIExpression(), !366)
  store i32 0, ptr %7, align 4, !dbg !366
  %8 = load i32, ptr %5, align 4, !dbg !366
  %9 = load i32, ptr %6, align 4, !dbg !366
  %10 = load i32, ptr %7, align 4, !dbg !366
  %11 = load ptr, ptr %3, align 4, !dbg !366
  %12 = load i32, ptr %4, align 4, !dbg !366
  %13 = call { i32, i32, i32 } asm sideeffect "1:ldrex $0, [$3];add $1, $4, $0;strex $2, $1, [$3];cmp $2, #0;bne  1b;", "=&r,=&r,=&r,r,r,0,1,2,~{memory},~{cc}"(ptr %11, i32 %12, i32 %8, i32 %9, i32 %10) #6, !dbg !366, !srcloc !371
  %14 = extractvalue { i32, i32, i32 } %13, 0, !dbg !366
  %15 = extractvalue { i32, i32, i32 } %13, 1, !dbg !366
  %16 = extractvalue { i32, i32, i32 } %13, 2, !dbg !366
  store i32 %14, ptr %5, align 4, !dbg !366
  store i32 %15, ptr %6, align 4, !dbg !366
  store i32 %16, ptr %7, align 4, !dbg !366
  %17 = load i32, ptr %5, align 4, !dbg !366
  ret i32 %17, !dbg !366
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_load() #0 !dbg !372 {
  call arm_aapcscc void @ck_pr_fence_strict_load(), !dbg !376
  ret void, !dbg !376
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_stall() #0 !dbg !377 {
  call void asm sideeffect "", "~{memory}"() #6, !dbg !378, !srcloc !379
  ret void, !dbg !380
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !381 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !384, !DIExpression(), !385)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !386, !DIExpression(), !385)
  %5 = load ptr, ptr %3, align 4, !dbg !385
  %6 = load i32, ptr %4, align 4, !dbg !385
  call void asm sideeffect "str $1, [$0]", "r,r,~{memory}"(ptr %5, i32 %6) #6, !dbg !385, !srcloc !387
  ret void, !dbg !385
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_lock() #0 !dbg !388 {
  call arm_aapcscc void @ck_pr_fence_strict_lock(), !dbg !389
  ret void, !dbg !389
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_load() #0 !dbg !390 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #6, !dbg !391, !srcloc !392
  ret void, !dbg !393
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_lock() #0 !dbg !394 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #6, !dbg !395, !srcloc !396
  ret void, !dbg !397
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_unlock() #0 !dbg !398 {
  call arm_aapcscc void @ck_pr_fence_strict_unlock(), !dbg !399
  ret void, !dbg !399
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_unlock() #0 !dbg !400 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #6, !dbg !401, !srcloc !402
  ret void, !dbg !403
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_barrier() #0 !dbg !404 {
  call void asm sideeffect "", "~{memory}"() #6, !dbg !406, !srcloc !407
  ret void, !dbg !408
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #4 = { allocsize(0) }
attributes #5 = { noreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!55, !56, !57, !58, !59, !60, !61}
!llvm.ident = !{!62}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 10, type: !14, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !18, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/anderson.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "3e8b6a5b525882d6b2763da0001a63b2")
!4 = !{!5, !6, !14, !12, !15}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 32)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_anderson_thread_t", file: !8, line: 45, baseType: !9)
!8 = !DIFile(filename: "../ck/include/spinlock/anderson.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6be228a7ecae2c5a8091cfc6ea102208")
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_anderson_thread", file: !8, line: 41, size: 64, elements: !10)
!10 = !{!11, !13}
!11 = !DIDerivedType(tag: DW_TAG_member, name: "locked", scope: !9, file: !8, line: 42, baseType: !12, size: 32)
!12 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!13 = !DIDerivedType(tag: DW_TAG_member, name: "position", scope: !9, file: !8, line: 43, baseType: !12, size: 32, offset: 32)
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !16, line: 4, baseType: !17)
!16 = !DIFile(filename: "include/libc/stdbool.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6e643322591bab80343344357c642cba")
!17 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!18 = !{!0, !19, !21, !27, !32, !38, !53}
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 10, type: !14, isLocal: false, isDefinition: true)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(scope: null, file: !3, line: 55, type: !23, isLocal: true, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 248, elements: !25)
!24 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!25 = !{!26}
!26 = !DISubrange(count: 31)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(scope: null, file: !3, line: 55, type: !29, isLocal: true, isDefinition: true)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 200, elements: !30)
!30 = !{!31}
!31 = !DISubrange(count: 25)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(scope: null, file: !3, line: 55, type: !34, isLocal: true, isDefinition: true)
!34 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 40, elements: !36)
!35 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!36 = !{!37}
!37 = !DISubrange(count: 5)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 11, type: !40, isLocal: false, isDefinition: true)
!40 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_anderson_t", file: !8, line: 55, baseType: !41)
!41 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_anderson", file: !8, line: 47, size: 544, elements: !42)
!42 = !{!43, !45, !46, !47, !48, !52}
!43 = !DIDerivedType(tag: DW_TAG_member, name: "slots", scope: !41, file: !8, line: 48, baseType: !44, size: 32)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 32)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !41, file: !8, line: 49, baseType: !12, size: 32, offset: 32)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "wrap", scope: !41, file: !8, line: 50, baseType: !12, size: 32, offset: 64)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "mask", scope: !41, file: !8, line: 51, baseType: !12, size: 32, offset: 96)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !41, file: !8, line: 52, baseType: !49, size: 384, offset: 128)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 384, elements: !50)
!50 = !{!51}
!51 = !DISubrange(count: 48)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !41, file: !8, line: 53, baseType: !12, size: 32, offset: 512)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "slots", scope: !2, file: !3, line: 12, type: !6, isLocal: false, isDefinition: true)
!55 = !{i32 7, !"Dwarf Version", i32 5}
!56 = !{i32 2, !"Debug Info Version", i32 3}
!57 = !{i32 1, !"wchar_size", i32 4}
!58 = !{i32 1, !"min_enum_size", i32 4}
!59 = !{i32 8, !"PIC Level", i32 2}
!60 = !{i32 7, !"PIE Level", i32 2}
!61 = !{i32 7, !"frame-pointer", i32 2}
!62 = !{!"Homebrew clang version 22.1.8"}
!63 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 14, type: !64, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!64 = !DISubroutineType(types: !65)
!65 = !{!5, !5}
!66 = !{}
!67 = !DILocalVariable(name: "arg", arg: 1, scope: !63, file: !3, line: 14, type: !5)
!68 = !DILocation(line: 14, column: 17, scope: !63)
!69 = !DILocalVariable(name: "my_slot", scope: !63, file: !3, line: 16, type: !6)
!70 = !DILocation(line: 16, column: 36, scope: !63)
!71 = !DILocation(line: 17, column: 5, scope: !63)
!72 = !DILocation(line: 19, column: 6, scope: !63)
!73 = !DILocation(line: 20, column: 6, scope: !63)
!74 = !DILocation(line: 22, column: 40, scope: !63)
!75 = !DILocation(line: 22, column: 5, scope: !63)
!76 = !DILocation(line: 23, column: 5, scope: !63)
!77 = distinct !DISubprogram(name: "ck_spinlock_anderson_lock", scope: !8, file: !8, line: 103, type: !78, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!78 = !DISubroutineType(types: !79)
!79 = !{null, !80, !81}
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 32)
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 32)
!82 = !DILocalVariable(name: "lock", arg: 1, scope: !77, file: !8, line: 103, type: !80)
!83 = !DILocation(line: 103, column: 56, scope: !77)
!84 = !DILocalVariable(name: "slot", arg: 2, scope: !77, file: !8, line: 104, type: !81)
!85 = !DILocation(line: 104, column: 42, scope: !77)
!86 = !DILocalVariable(name: "position", scope: !77, file: !8, line: 106, type: !12)
!87 = !DILocation(line: 106, column: 15, scope: !77)
!88 = !DILocalVariable(name: "next", scope: !77, file: !8, line: 106, type: !12)
!89 = !DILocation(line: 106, column: 25, scope: !77)
!90 = !DILocalVariable(name: "count", scope: !77, file: !8, line: 107, type: !12)
!91 = !DILocation(line: 107, column: 15, scope: !77)
!92 = !DILocation(line: 107, column: 23, scope: !77)
!93 = !DILocation(line: 107, column: 29, scope: !77)
!94 = !DILocation(line: 114, column: 6, scope: !95)
!95 = distinct !DILexicalBlock(scope: !77, file: !8, line: 114, column: 6)
!96 = !DILocation(line: 114, column: 12, scope: !95)
!97 = !DILocation(line: 114, column: 17, scope: !95)
!98 = !DILocation(line: 115, column: 31, scope: !99)
!99 = distinct !DILexicalBlock(scope: !95, file: !8, line: 114, column: 23)
!100 = !DILocation(line: 115, column: 37, scope: !99)
!101 = !DILocation(line: 115, column: 14, scope: !99)
!102 = !DILocation(line: 115, column: 12, scope: !99)
!103 = !DILocation(line: 117, column: 3, scope: !99)
!104 = !DILocation(line: 118, column: 8, scope: !105)
!105 = distinct !DILexicalBlock(scope: !106, file: !8, line: 118, column: 8)
!106 = distinct !DILexicalBlock(scope: !99, file: !8, line: 117, column: 6)
!107 = !DILocation(line: 118, column: 17, scope: !105)
!108 = !DILocation(line: 119, column: 12, scope: !105)
!109 = !DILocation(line: 119, column: 18, scope: !105)
!110 = !DILocation(line: 119, column: 10, scope: !105)
!111 = !DILocation(line: 119, column: 5, scope: !105)
!112 = !DILocation(line: 121, column: 12, scope: !105)
!113 = !DILocation(line: 121, column: 21, scope: !105)
!114 = !DILocation(line: 121, column: 10, scope: !105)
!115 = !DILocation(line: 122, column: 3, scope: !106)
!116 = !DILocation(line: 122, column: 34, scope: !99)
!117 = !DILocation(line: 122, column: 40, scope: !99)
!118 = !DILocation(line: 122, column: 46, scope: !99)
!119 = !DILocation(line: 123, column: 12, scope: !99)
!120 = !DILocation(line: 122, column: 12, scope: !99)
!121 = !DILocation(line: 123, column: 29, scope: !99)
!122 = distinct !{!122, !103, !123, !124}
!123 = !DILocation(line: 123, column: 37, scope: !99)
!124 = !{!"llvm.loop.mustprogress"}
!125 = !DILocation(line: 125, column: 15, scope: !99)
!126 = !DILocation(line: 125, column: 12, scope: !99)
!127 = !DILocation(line: 126, column: 2, scope: !99)
!128 = !DILocation(line: 127, column: 30, scope: !129)
!129 = distinct !DILexicalBlock(scope: !95, file: !8, line: 126, column: 9)
!130 = !DILocation(line: 127, column: 36, scope: !129)
!131 = !DILocation(line: 127, column: 14, scope: !129)
!132 = !DILocation(line: 127, column: 12, scope: !129)
!133 = !DILocation(line: 128, column: 15, scope: !129)
!134 = !DILocation(line: 128, column: 21, scope: !129)
!135 = !DILocation(line: 128, column: 12, scope: !129)
!136 = !DILocation(line: 132, column: 2, scope: !77)
!137 = !DILocation(line: 138, column: 2, scope: !77)
!138 = !DILocation(line: 138, column: 26, scope: !77)
!139 = !DILocation(line: 138, column: 32, scope: !77)
!140 = !DILocation(line: 138, column: 38, scope: !77)
!141 = !DILocation(line: 138, column: 48, scope: !77)
!142 = !DILocation(line: 138, column: 9, scope: !77)
!143 = !DILocation(line: 138, column: 56, scope: !77)
!144 = !DILocation(line: 139, column: 3, scope: !77)
!145 = distinct !{!145, !137, !146, !124}
!146 = !DILocation(line: 139, column: 15, scope: !77)
!147 = !DILocation(line: 142, column: 20, scope: !77)
!148 = !DILocation(line: 142, column: 26, scope: !77)
!149 = !DILocation(line: 142, column: 32, scope: !77)
!150 = !DILocation(line: 142, column: 42, scope: !77)
!151 = !DILocation(line: 142, column: 2, scope: !77)
!152 = !DILocation(line: 143, column: 2, scope: !77)
!153 = !DILocation(line: 145, column: 10, scope: !77)
!154 = !DILocation(line: 145, column: 16, scope: !77)
!155 = !DILocation(line: 145, column: 24, scope: !77)
!156 = !DILocation(line: 145, column: 22, scope: !77)
!157 = !DILocation(line: 145, column: 3, scope: !77)
!158 = !DILocation(line: 145, column: 8, scope: !77)
!159 = !DILocation(line: 146, column: 2, scope: !77)
!160 = distinct !DISubprogram(name: "ck_spinlock_anderson_unlock", scope: !8, file: !8, line: 150, type: !161, scopeLine: 152, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!161 = !DISubroutineType(types: !162)
!162 = !{null, !80, !44}
!163 = !DILocalVariable(name: "lock", arg: 1, scope: !160, file: !8, line: 150, type: !80)
!164 = !DILocation(line: 150, column: 58, scope: !160)
!165 = !DILocalVariable(name: "slot", arg: 2, scope: !160, file: !8, line: 151, type: !44)
!166 = !DILocation(line: 151, column: 41, scope: !160)
!167 = !DILocalVariable(name: "position", scope: !160, file: !8, line: 153, type: !12)
!168 = !DILocation(line: 153, column: 15, scope: !160)
!169 = !DILocation(line: 155, column: 2, scope: !160)
!170 = !DILocation(line: 158, column: 6, scope: !171)
!171 = distinct !DILexicalBlock(scope: !160, file: !8, line: 158, column: 6)
!172 = !DILocation(line: 158, column: 12, scope: !171)
!173 = !DILocation(line: 158, column: 17, scope: !171)
!174 = !DILocation(line: 159, column: 15, scope: !171)
!175 = !DILocation(line: 159, column: 21, scope: !171)
!176 = !DILocation(line: 159, column: 30, scope: !171)
!177 = !DILocation(line: 159, column: 37, scope: !171)
!178 = !DILocation(line: 159, column: 43, scope: !171)
!179 = !DILocation(line: 159, column: 35, scope: !171)
!180 = !DILocation(line: 159, column: 12, scope: !171)
!181 = !DILocation(line: 159, column: 3, scope: !171)
!182 = !DILocation(line: 161, column: 15, scope: !171)
!183 = !DILocation(line: 161, column: 21, scope: !171)
!184 = !DILocation(line: 161, column: 30, scope: !171)
!185 = !DILocation(line: 161, column: 37, scope: !171)
!186 = !DILocation(line: 161, column: 43, scope: !171)
!187 = !DILocation(line: 161, column: 35, scope: !171)
!188 = !DILocation(line: 161, column: 12, scope: !171)
!189 = !DILocation(line: 163, column: 20, scope: !160)
!190 = !DILocation(line: 163, column: 26, scope: !160)
!191 = !DILocation(line: 163, column: 32, scope: !160)
!192 = !DILocation(line: 163, column: 42, scope: !160)
!193 = !DILocation(line: 163, column: 2, scope: !160)
!194 = !DILocation(line: 164, column: 2, scope: !160)
!195 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 26, type: !196, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!196 = !DISubroutineType(types: !197)
!197 = !{!14}
!198 = !DILocalVariable(name: "threads", scope: !195, file: !3, line: 28, type: !199)
!199 = !DICompositeType(tag: DW_TAG_array_type, baseType: !200, size: 96, elements: !202)
!200 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !201, line: 2, baseType: !5)
!201 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!202 = !{!203}
!203 = !DISubrange(count: 3)
!204 = !DILocation(line: 28, column: 15, scope: !195)
!205 = !DILocalVariable(name: "i", scope: !195, file: !3, line: 29, type: !14)
!206 = !DILocation(line: 29, column: 9, scope: !195)
!207 = !DILocation(line: 31, column: 46, scope: !195)
!208 = !DILocation(line: 31, column: 11, scope: !195)
!209 = !DILocation(line: 32, column: 9, scope: !210)
!210 = distinct !DILexicalBlock(scope: !195, file: !3, line: 32, column: 9)
!211 = !DILocation(line: 32, column: 15, scope: !210)
!212 = !DILocation(line: 34, column: 9, scope: !213)
!213 = distinct !DILexicalBlock(scope: !210, file: !3, line: 33, column: 5)
!214 = !DILocation(line: 37, column: 38, scope: !195)
!215 = !DILocation(line: 37, column: 5, scope: !195)
!216 = !DILocation(line: 39, column: 12, scope: !217)
!217 = distinct !DILexicalBlock(scope: !195, file: !3, line: 39, column: 5)
!218 = !DILocation(line: 39, column: 10, scope: !217)
!219 = !DILocation(line: 39, column: 17, scope: !220)
!220 = distinct !DILexicalBlock(scope: !217, file: !3, line: 39, column: 5)
!221 = !DILocation(line: 39, column: 19, scope: !220)
!222 = !DILocation(line: 39, column: 5, scope: !217)
!223 = !DILocation(line: 41, column: 37, scope: !224)
!224 = distinct !DILexicalBlock(scope: !225, file: !3, line: 41, column: 13)
!225 = distinct !DILexicalBlock(scope: !220, file: !3, line: 40, column: 5)
!226 = !DILocation(line: 41, column: 29, scope: !224)
!227 = !DILocation(line: 41, column: 13, scope: !224)
!228 = !DILocation(line: 41, column: 58, scope: !224)
!229 = !DILocation(line: 43, column: 13, scope: !230)
!230 = distinct !DILexicalBlock(scope: !224, file: !3, line: 42, column: 9)
!231 = !DILocation(line: 45, column: 5, scope: !225)
!232 = !DILocation(line: 39, column: 32, scope: !220)
!233 = !DILocation(line: 39, column: 5, scope: !220)
!234 = distinct !{!234, !222, !235, !124}
!235 = !DILocation(line: 45, column: 5, scope: !217)
!236 = !DILocation(line: 47, column: 12, scope: !237)
!237 = distinct !DILexicalBlock(scope: !195, file: !3, line: 47, column: 5)
!238 = !DILocation(line: 47, column: 10, scope: !237)
!239 = !DILocation(line: 47, column: 17, scope: !240)
!240 = distinct !DILexicalBlock(scope: !237, file: !3, line: 47, column: 5)
!241 = !DILocation(line: 47, column: 19, scope: !240)
!242 = !DILocation(line: 47, column: 5, scope: !237)
!243 = !DILocation(line: 49, column: 34, scope: !244)
!244 = distinct !DILexicalBlock(scope: !245, file: !3, line: 49, column: 13)
!245 = distinct !DILexicalBlock(scope: !240, file: !3, line: 48, column: 5)
!246 = !DILocation(line: 49, column: 26, scope: !244)
!247 = !DILocation(line: 49, column: 13, scope: !244)
!248 = !DILocation(line: 49, column: 44, scope: !244)
!249 = !DILocation(line: 51, column: 13, scope: !250)
!250 = distinct !DILexicalBlock(scope: !244, file: !3, line: 50, column: 9)
!251 = !DILocation(line: 53, column: 5, scope: !245)
!252 = !DILocation(line: 47, column: 32, scope: !240)
!253 = !DILocation(line: 47, column: 5, scope: !240)
!254 = distinct !{!254, !242, !255, !124}
!255 = !DILocation(line: 53, column: 5, scope: !237)
!256 = !DILocation(line: 55, column: 12, scope: !257)
!257 = distinct !DILexicalBlock(scope: !258, file: !3, line: 55, column: 5)
!258 = distinct !DILexicalBlock(scope: !195, file: !3, line: 55, column: 5)
!259 = !DILocation(line: 55, column: 14, scope: !257)
!260 = !DILocation(line: 55, column: 26, scope: !257)
!261 = !DILocation(line: 55, column: 29, scope: !257)
!262 = !DILocation(line: 55, column: 31, scope: !257)
!263 = !DILocation(line: 55, column: 5, scope: !257)
!264 = !DILocation(line: 57, column: 10, scope: !195)
!265 = !DILocation(line: 57, column: 5, scope: !195)
!266 = !DILocation(line: 59, column: 5, scope: !195)
!267 = distinct !DISubprogram(name: "ck_spinlock_anderson_init", scope: !8, file: !8, line: 58, type: !268, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!268 = !DISubroutineType(types: !269)
!269 = !{null, !80, !44, !12}
!270 = !DILocalVariable(name: "lock", arg: 1, scope: !267, file: !8, line: 58, type: !80)
!271 = !DILocation(line: 58, column: 56, scope: !267)
!272 = !DILocalVariable(name: "slots", arg: 2, scope: !267, file: !8, line: 59, type: !44)
!273 = !DILocation(line: 59, column: 41, scope: !267)
!274 = !DILocalVariable(name: "count", arg: 3, scope: !267, file: !8, line: 60, type: !12)
!275 = !DILocation(line: 60, column: 18, scope: !267)
!276 = !DILocalVariable(name: "i", scope: !267, file: !8, line: 62, type: !12)
!277 = !DILocation(line: 62, column: 15, scope: !267)
!278 = !DILocation(line: 64, column: 2, scope: !267)
!279 = !DILocation(line: 64, column: 11, scope: !267)
!280 = !DILocation(line: 64, column: 18, scope: !267)
!281 = !DILocation(line: 65, column: 2, scope: !267)
!282 = !DILocation(line: 65, column: 11, scope: !267)
!283 = !DILocation(line: 65, column: 20, scope: !267)
!284 = !DILocation(line: 66, column: 9, scope: !285)
!285 = distinct !DILexicalBlock(scope: !267, file: !8, line: 66, column: 2)
!286 = !DILocation(line: 66, column: 7, scope: !285)
!287 = !DILocation(line: 66, column: 14, scope: !288)
!288 = distinct !DILexicalBlock(scope: !285, file: !8, line: 66, column: 2)
!289 = !DILocation(line: 66, column: 18, scope: !288)
!290 = !DILocation(line: 66, column: 16, scope: !288)
!291 = !DILocation(line: 66, column: 2, scope: !285)
!292 = !DILocation(line: 67, column: 3, scope: !293)
!293 = distinct !DILexicalBlock(scope: !288, file: !8, line: 66, column: 30)
!294 = !DILocation(line: 67, column: 9, scope: !293)
!295 = !DILocation(line: 67, column: 12, scope: !293)
!296 = !DILocation(line: 67, column: 19, scope: !293)
!297 = !DILocation(line: 68, column: 23, scope: !293)
!298 = !DILocation(line: 68, column: 3, scope: !293)
!299 = !DILocation(line: 68, column: 9, scope: !293)
!300 = !DILocation(line: 68, column: 12, scope: !293)
!301 = !DILocation(line: 68, column: 21, scope: !293)
!302 = !DILocation(line: 69, column: 2, scope: !293)
!303 = !DILocation(line: 66, column: 26, scope: !288)
!304 = !DILocation(line: 66, column: 2, scope: !288)
!305 = distinct !{!305, !291, !306, !124}
!306 = !DILocation(line: 69, column: 2, scope: !285)
!307 = !DILocation(line: 71, column: 16, scope: !267)
!308 = !DILocation(line: 71, column: 2, scope: !267)
!309 = !DILocation(line: 71, column: 8, scope: !267)
!310 = !DILocation(line: 71, column: 14, scope: !267)
!311 = !DILocation(line: 72, column: 16, scope: !267)
!312 = !DILocation(line: 72, column: 2, scope: !267)
!313 = !DILocation(line: 72, column: 8, scope: !267)
!314 = !DILocation(line: 72, column: 14, scope: !267)
!315 = !DILocation(line: 73, column: 15, scope: !267)
!316 = !DILocation(line: 73, column: 21, scope: !267)
!317 = !DILocation(line: 73, column: 2, scope: !267)
!318 = !DILocation(line: 73, column: 8, scope: !267)
!319 = !DILocation(line: 73, column: 13, scope: !267)
!320 = !DILocation(line: 74, column: 2, scope: !267)
!321 = !DILocation(line: 74, column: 8, scope: !267)
!322 = !DILocation(line: 74, column: 13, scope: !267)
!323 = !DILocation(line: 81, column: 6, scope: !324)
!324 = distinct !DILexicalBlock(scope: !267, file: !8, line: 81, column: 6)
!325 = !DILocation(line: 81, column: 15, scope: !324)
!326 = !DILocation(line: 81, column: 21, scope: !324)
!327 = !DILocation(line: 81, column: 12, scope: !324)
!328 = !DILocation(line: 82, column: 28, scope: !324)
!329 = !DILocation(line: 82, column: 26, scope: !324)
!330 = !DILocation(line: 82, column: 35, scope: !324)
!331 = !DILocation(line: 82, column: 3, scope: !324)
!332 = !DILocation(line: 82, column: 9, scope: !324)
!333 = !DILocation(line: 82, column: 14, scope: !324)
!334 = !DILocation(line: 84, column: 3, scope: !324)
!335 = !DILocation(line: 84, column: 9, scope: !324)
!336 = !DILocation(line: 84, column: 14, scope: !324)
!337 = !DILocation(line: 86, column: 2, scope: !267)
!338 = !DILocation(line: 87, column: 2, scope: !267)
!339 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !340, file: !340, line: 127, type: !341, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!340 = !DIFile(filename: "../ck/include/gcc/arm/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f3f9fb174933d4f9d5af6678feea8d14")
!341 = !DISubroutineType(types: !342)
!342 = !{!12, !343}
!343 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !344, size: 32)
!344 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !12)
!345 = !DILocalVariable(name: "target", arg: 1, scope: !339, file: !340, line: 127, type: !343)
!346 = !DILocation(line: 127, column: 1, scope: !339)
!347 = !DILocalVariable(name: "r", scope: !339, file: !340, line: 127, type: !348)
!348 = !DIBasicType(name: "long", size: 32, encoding: DW_ATE_signed)
!349 = !{i64 2147586884}
!350 = distinct !DISubprogram(name: "ck_pr_cas_uint_value", scope: !340, file: !340, line: 385, type: !351, scopeLine: 385, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!351 = !DISubroutineType(types: !352)
!352 = !{!15, !353, !12, !12, !353}
!353 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 32)
!354 = !DILocalVariable(name: "target", arg: 1, scope: !350, file: !340, line: 385, type: !353)
!355 = !DILocation(line: 385, column: 1, scope: !350)
!356 = !DILocalVariable(name: "compare", arg: 2, scope: !350, file: !340, line: 385, type: !12)
!357 = !DILocalVariable(name: "set", arg: 3, scope: !350, file: !340, line: 385, type: !12)
!358 = !DILocalVariable(name: "value", arg: 4, scope: !350, file: !340, line: 385, type: !353)
!359 = !DILocalVariable(name: "previous", scope: !350, file: !340, line: 385, type: !12)
!360 = !DILocalVariable(name: "tmp", scope: !350, file: !340, line: 385, type: !12)
!361 = !{i64 2147592538}
!362 = distinct !DISubprogram(name: "ck_pr_faa_uint", scope: !340, file: !340, line: 553, type: !363, scopeLine: 553, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!363 = !DISubroutineType(types: !364)
!364 = !{!12, !353, !12}
!365 = !DILocalVariable(name: "target", arg: 1, scope: !362, file: !340, line: 553, type: !353)
!366 = !DILocation(line: 553, column: 1, scope: !362)
!367 = !DILocalVariable(name: "delta", arg: 2, scope: !362, file: !340, line: 553, type: !12)
!368 = !DILocalVariable(name: "previous", scope: !362, file: !340, line: 553, type: !12)
!369 = !DILocalVariable(name: "r", scope: !362, file: !340, line: 553, type: !12)
!370 = !DILocalVariable(name: "tmp", scope: !362, file: !340, line: 553, type: !12)
!371 = !{i64 2147649448}
!372 = distinct !DISubprogram(name: "ck_pr_fence_load", scope: !373, file: !373, line: 116, type: !374, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!373 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!374 = !DISubroutineType(types: !375)
!375 = !{null}
!376 = !DILocation(line: 116, column: 1, scope: !372)
!377 = distinct !DISubprogram(name: "ck_pr_stall", scope: !340, file: !340, line: 50, type: !374, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!378 = !DILocation(line: 53, column: 2, scope: !377)
!379 = !{i64 79093}
!380 = !DILocation(line: 54, column: 2, scope: !377)
!381 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !340, file: !340, line: 176, type: !382, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!382 = !DISubroutineType(types: !383)
!383 = !{null, !353, !12}
!384 = !DILocalVariable(name: "target", arg: 1, scope: !381, file: !340, line: 176, type: !353)
!385 = !DILocation(line: 176, column: 1, scope: !381)
!386 = !DILocalVariable(name: "v", arg: 2, scope: !381, file: !340, line: 176, type: !12)
!387 = !{i64 2147589753}
!388 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !373, file: !373, line: 122, type: !374, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!389 = !DILocation(line: 122, column: 1, scope: !388)
!390 = distinct !DISubprogram(name: "ck_pr_fence_strict_load", scope: !340, file: !340, line: 92, type: !374, scopeLine: 92, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!391 = !DILocation(line: 92, column: 19, scope: !390)
!392 = !{i64 2147582891}
!393 = !DILocation(line: 92, column: 1, scope: !390)
!394 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !340, file: !340, line: 98, type: !374, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!395 = !DILocation(line: 98, column: 19, scope: !394)
!396 = !{i64 2147584681}
!397 = !DILocation(line: 98, column: 1, scope: !394)
!398 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !373, file: !373, line: 123, type: !374, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!399 = !DILocation(line: 123, column: 1, scope: !398)
!400 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !340, file: !340, line: 99, type: !374, scopeLine: 99, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!401 = !DILocation(line: 99, column: 21, scope: !400)
!402 = !{i64 2147584976}
!403 = !DILocation(line: 99, column: 1, scope: !400)
!404 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !405, file: !405, line: 37, type: !374, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!405 = !DIFile(filename: "../ck/include/gcc/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!406 = !DILocation(line: 40, column: 2, scope: !404)
!407 = !{i64 174829}
!408 = !DILocation(line: 41, column: 2, scope: !404)
