; ModuleID = 'tests/anderson.c'
source_filename = "tests/anderson.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_spinlock_anderson = type { ptr, i32, i32, i32, [44 x i8], i32 }
%struct.ck_spinlock_anderson_thread = type { i32, i32 }

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !18
@lock = global %struct.ck_spinlock_anderson zeroinitializer, align 8, !dbg !38
@slots = global ptr null, align 8, !dbg !53
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !21
@.str = private unnamed_addr constant [11 x i8] c"anderson.c\00", align 1, !dbg !28
@.str.1 = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !33

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 !dbg !63 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  call void @ck_spinlock_anderson_lock(ptr noundef @lock, ptr noundef %3), !dbg !71
  %4 = load i32, ptr @x, align 4, !dbg !72
  %5 = add nsw i32 %4, 1, !dbg !72
  store i32 %5, ptr @x, align 4, !dbg !72
  %6 = load i32, ptr @y, align 4, !dbg !73
  %7 = add nsw i32 %6, 1, !dbg !73
  store i32 %7, ptr @y, align 4, !dbg !73
  %8 = load ptr, ptr %3, align 8, !dbg !74
  call void @ck_spinlock_anderson_unlock(ptr noundef @lock, ptr noundef %8), !dbg !75
  ret ptr null, !dbg !76
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_anderson_lock(ptr noundef %0, ptr noundef %1) #0 !dbg !77 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %8 = load ptr, ptr %3, align 8, !dbg !92
  %9 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %8, i32 0, i32 1, !dbg !93
  %10 = load i32, ptr %9, align 8, !dbg !93
  store i32 %10, ptr %7, align 4, !dbg !91
  %11 = load ptr, ptr %3, align 8, !dbg !94
  %12 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %11, i32 0, i32 2, !dbg !96
  %13 = load i32, ptr %12, align 4, !dbg !96
  %14 = icmp ne i32 %13, 0, !dbg !97
  br i1 %14, label %15, label %42, !dbg !98

15:                                               ; preds = %2
  %16 = load ptr, ptr %3, align 8, !dbg !99
  %17 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %16, i32 0, i32 5, !dbg !99
  %18 = call i32 @ck_pr_md_load_uint(ptr noundef %17), !dbg !99
  store i32 %18, ptr %5, align 4, !dbg !101
  br label %19, !dbg !102

19:                                               ; preds = %30, %15
  %20 = load i32, ptr %5, align 4, !dbg !103
  %21 = icmp eq i32 %20, -1, !dbg !106
  br i1 %21, label %22, label %26, !dbg !107

22:                                               ; preds = %19
  %23 = load ptr, ptr %3, align 8, !dbg !108
  %24 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %23, i32 0, i32 2, !dbg !109
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
  %31 = load ptr, ptr %3, align 8, !dbg !116
  %32 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %31, i32 0, i32 5, !dbg !117
  %33 = load i32, ptr %5, align 4, !dbg !118
  %34 = load i32, ptr %6, align 4, !dbg !119
  %35 = call zeroext i1 @ck_pr_cas_uint_value(ptr noundef %32, i32 noundef %33, i32 noundef %34, ptr noundef %5), !dbg !120
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
  %43 = load ptr, ptr %3, align 8, !dbg !128
  %44 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %43, i32 0, i32 5, !dbg !130
  %45 = call i32 @ck_pr_faa_uint(ptr noundef %44, i32 noundef 1), !dbg !131
  store i32 %45, ptr %5, align 4, !dbg !132
  %46 = load ptr, ptr %3, align 8, !dbg !133
  %47 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %46, i32 0, i32 3, !dbg !134
  %48 = load i32, ptr %47, align 8, !dbg !134
  %49 = load i32, ptr %5, align 4, !dbg !135
  %50 = and i32 %49, %48, !dbg !135
  store i32 %50, ptr %5, align 4, !dbg !135
  br label %51

51:                                               ; preds = %42, %38
  call void @ck_pr_fence_load(), !dbg !136
  br label %52, !dbg !137

52:                                               ; preds = %62, %51
  %53 = load ptr, ptr %3, align 8, !dbg !138
  %54 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %53, i32 0, i32 0, !dbg !138
  %55 = load ptr, ptr %54, align 8, !dbg !138
  %56 = load i32, ptr %5, align 4, !dbg !138
  %57 = zext i32 %56 to i64, !dbg !138
  %58 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %55, i64 %57, !dbg !138
  %59 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %58, i32 0, i32 0, !dbg !138
  %60 = call i32 @ck_pr_md_load_uint(ptr noundef %59), !dbg !138
  %61 = icmp eq i32 %60, 1, !dbg !139
  br i1 %61, label %62, label %63, !dbg !137

62:                                               ; preds = %52
  call void @ck_pr_stall(), !dbg !140
  br label %52, !dbg !137, !llvm.loop !141

63:                                               ; preds = %52
  %64 = load ptr, ptr %3, align 8, !dbg !143
  %65 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %64, i32 0, i32 0, !dbg !143
  %66 = load ptr, ptr %65, align 8, !dbg !143
  %67 = load i32, ptr %5, align 4, !dbg !143
  %68 = zext i32 %67 to i64, !dbg !143
  %69 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %66, i64 %68, !dbg !143
  %70 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %69, i32 0, i32 0, !dbg !143
  call void @ck_pr_md_store_uint(ptr noundef %70, i32 noundef 1), !dbg !143
  call void @ck_pr_fence_lock(), !dbg !144
  %71 = load ptr, ptr %3, align 8, !dbg !145
  %72 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %71, i32 0, i32 0, !dbg !146
  %73 = load ptr, ptr %72, align 8, !dbg !146
  %74 = load i32, ptr %5, align 4, !dbg !147
  %75 = zext i32 %74 to i64, !dbg !148
  %76 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %73, i64 %75, !dbg !148
  %77 = load ptr, ptr %4, align 8, !dbg !149
  store ptr %76, ptr %77, align 8, !dbg !150
  ret void, !dbg !151
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_anderson_unlock(ptr noundef %0, ptr noundef %1) #0 !dbg !152 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  call void @ck_pr_fence_unlock(), !dbg !161
  %6 = load ptr, ptr %3, align 8, !dbg !162
  %7 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %6, i32 0, i32 2, !dbg !164
  %8 = load i32, ptr %7, align 4, !dbg !164
  %9 = icmp eq i32 %8, 0, !dbg !165
  br i1 %9, label %10, label %19, !dbg !166

10:                                               ; preds = %2
  %11 = load ptr, ptr %4, align 8, !dbg !167
  %12 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %11, i32 0, i32 1, !dbg !168
  %13 = load i32, ptr %12, align 4, !dbg !168
  %14 = add i32 %13, 1, !dbg !169
  %15 = load ptr, ptr %3, align 8, !dbg !170
  %16 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %15, i32 0, i32 3, !dbg !171
  %17 = load i32, ptr %16, align 8, !dbg !171
  %18 = and i32 %14, %17, !dbg !172
  store i32 %18, ptr %5, align 4, !dbg !173
  br label %28, !dbg !174

19:                                               ; preds = %2
  %20 = load ptr, ptr %4, align 8, !dbg !175
  %21 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %20, i32 0, i32 1, !dbg !176
  %22 = load i32, ptr %21, align 4, !dbg !176
  %23 = add i32 %22, 1, !dbg !177
  %24 = load ptr, ptr %3, align 8, !dbg !178
  %25 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %24, i32 0, i32 1, !dbg !179
  %26 = load i32, ptr %25, align 8, !dbg !179
  %27 = urem i32 %23, %26, !dbg !180
  store i32 %27, ptr %5, align 4, !dbg !181
  br label %28

28:                                               ; preds = %19, %10
  %29 = load ptr, ptr %3, align 8, !dbg !182
  %30 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %29, i32 0, i32 0, !dbg !182
  %31 = load ptr, ptr %30, align 8, !dbg !182
  %32 = load i32, ptr %5, align 4, !dbg !182
  %33 = zext i32 %32 to i64, !dbg !182
  %34 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %31, i64 %33, !dbg !182
  %35 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %34, i32 0, i32 0, !dbg !182
  call void @ck_pr_md_store_uint(ptr noundef %35, i32 noundef 0), !dbg !182
  ret void, !dbg !183
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !184 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %4 = call ptr @malloc(i64 noundef 24) #5, !dbg !217
  store ptr %4, ptr @slots, align 8, !dbg !218
  %5 = load ptr, ptr @slots, align 8, !dbg !219
  %6 = icmp eq ptr %5, null, !dbg !221
  br i1 %6, label %7, label %8, !dbg !222

7:                                                ; preds = %0
  call void @exit(i32 noundef 1) #6, !dbg !223
  unreachable, !dbg !223

8:                                                ; preds = %0
  %9 = load ptr, ptr @slots, align 8, !dbg !225
  call void @ck_spinlock_anderson_init(ptr noundef @lock, ptr noundef %9, i32 noundef 3), !dbg !226
  store i32 0, ptr %3, align 4, !dbg !227
  br label %10, !dbg !229

10:                                               ; preds = %21, %8
  %11 = load i32, ptr %3, align 4, !dbg !230
  %12 = icmp slt i32 %11, 3, !dbg !232
  br i1 %12, label %13, label %24, !dbg !233

13:                                               ; preds = %10
  %14 = load i32, ptr %3, align 4, !dbg !234
  %15 = sext i32 %14 to i64, !dbg !237
  %16 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %15, !dbg !237
  %17 = call i32 @pthread_create(ptr noundef %16, ptr noundef null, ptr noundef @run, ptr noundef null), !dbg !238
  %18 = icmp ne i32 %17, 0, !dbg !239
  br i1 %18, label %19, label %20, !dbg !240

19:                                               ; preds = %13
  call void @exit(i32 noundef 1) #6, !dbg !241
  unreachable, !dbg !241

20:                                               ; preds = %13
  br label %21, !dbg !243

21:                                               ; preds = %20
  %22 = load i32, ptr %3, align 4, !dbg !244
  %23 = add nsw i32 %22, 1, !dbg !244
  store i32 %23, ptr %3, align 4, !dbg !244
  br label %10, !dbg !245, !llvm.loop !246

24:                                               ; preds = %10
  store i32 0, ptr %3, align 4, !dbg !248
  br label %25, !dbg !250

25:                                               ; preds = %37, %24
  %26 = load i32, ptr %3, align 4, !dbg !251
  %27 = icmp slt i32 %26, 3, !dbg !253
  br i1 %27, label %28, label %40, !dbg !254

28:                                               ; preds = %25
  %29 = load i32, ptr %3, align 4, !dbg !255
  %30 = sext i32 %29 to i64, !dbg !258
  %31 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %30, !dbg !258
  %32 = load ptr, ptr %31, align 8, !dbg !258
  %33 = call i32 @"\01_pthread_join"(ptr noundef %32, ptr noundef null), !dbg !259
  %34 = icmp ne i32 %33, 0, !dbg !260
  br i1 %34, label %35, label %36, !dbg !261

35:                                               ; preds = %28
  call void @exit(i32 noundef 1) #6, !dbg !262
  unreachable, !dbg !262

36:                                               ; preds = %28
  br label %37, !dbg !264

37:                                               ; preds = %36
  %38 = load i32, ptr %3, align 4, !dbg !265
  %39 = add nsw i32 %38, 1, !dbg !265
  store i32 %39, ptr %3, align 4, !dbg !265
  br label %25, !dbg !266, !llvm.loop !267

40:                                               ; preds = %25
  %41 = load i32, ptr @x, align 4, !dbg !269
  %42 = icmp eq i32 %41, 3, !dbg !269
  br i1 %42, label %43, label %46, !dbg !269

43:                                               ; preds = %40
  %44 = load i32, ptr @y, align 4, !dbg !269
  %45 = icmp eq i32 %44, 3, !dbg !269
  br label %46

46:                                               ; preds = %43, %40
  %47 = phi i1 [ false, %40 ], [ %45, %43 ], !dbg !270
  %48 = xor i1 %47, true, !dbg !269
  %49 = zext i1 %48 to i32, !dbg !269
  %50 = sext i32 %49 to i64, !dbg !269
  %51 = icmp ne i64 %50, 0, !dbg !269
  br i1 %51, label %52, label %54, !dbg !269

52:                                               ; preds = %46
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 55, ptr noundef @.str.1) #7, !dbg !269
  unreachable, !dbg !269

53:                                               ; No predecessors!
  br label %55, !dbg !269

54:                                               ; preds = %46
  br label %55, !dbg !269

55:                                               ; preds = %54, %53
  %56 = load ptr, ptr @slots, align 8, !dbg !271
  call void @free(ptr noundef %56), !dbg !272
  ret i32 0, !dbg !273
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_anderson_init(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 !dbg !274 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store i32 %2, ptr %6, align 4
  %8 = load ptr, ptr %5, align 8, !dbg !285
  %9 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %8, i64 0, !dbg !285
  %10 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %9, i32 0, i32 0, !dbg !286
  store i32 0, ptr %10, align 4, !dbg !287
  %11 = load ptr, ptr %5, align 8, !dbg !288
  %12 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %11, i64 0, !dbg !288
  %13 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %12, i32 0, i32 1, !dbg !289
  store i32 0, ptr %13, align 4, !dbg !290
  store i32 1, ptr %7, align 4, !dbg !291
  br label %14, !dbg !293

14:                                               ; preds = %30, %3
  %15 = load i32, ptr %7, align 4, !dbg !294
  %16 = load i32, ptr %6, align 4, !dbg !296
  %17 = icmp ult i32 %15, %16, !dbg !297
  br i1 %17, label %18, label %33, !dbg !298

18:                                               ; preds = %14
  %19 = load ptr, ptr %5, align 8, !dbg !299
  %20 = load i32, ptr %7, align 4, !dbg !301
  %21 = zext i32 %20 to i64, !dbg !299
  %22 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %19, i64 %21, !dbg !299
  %23 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %22, i32 0, i32 0, !dbg !302
  store i32 1, ptr %23, align 4, !dbg !303
  %24 = load i32, ptr %7, align 4, !dbg !304
  %25 = load ptr, ptr %5, align 8, !dbg !305
  %26 = load i32, ptr %7, align 4, !dbg !306
  %27 = zext i32 %26 to i64, !dbg !305
  %28 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %25, i64 %27, !dbg !305
  %29 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %28, i32 0, i32 1, !dbg !307
  store i32 %24, ptr %29, align 4, !dbg !308
  br label %30, !dbg !309

30:                                               ; preds = %18
  %31 = load i32, ptr %7, align 4, !dbg !310
  %32 = add i32 %31, 1, !dbg !310
  store i32 %32, ptr %7, align 4, !dbg !310
  br label %14, !dbg !311, !llvm.loop !312

33:                                               ; preds = %14
  %34 = load ptr, ptr %5, align 8, !dbg !314
  %35 = load ptr, ptr %4, align 8, !dbg !315
  %36 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %35, i32 0, i32 0, !dbg !316
  store ptr %34, ptr %36, align 8, !dbg !317
  %37 = load i32, ptr %6, align 4, !dbg !318
  %38 = load ptr, ptr %4, align 8, !dbg !319
  %39 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %38, i32 0, i32 1, !dbg !320
  store i32 %37, ptr %39, align 8, !dbg !321
  %40 = load i32, ptr %6, align 4, !dbg !322
  %41 = sub i32 %40, 1, !dbg !323
  %42 = load ptr, ptr %4, align 8, !dbg !324
  %43 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %42, i32 0, i32 3, !dbg !325
  store i32 %41, ptr %43, align 8, !dbg !326
  %44 = load ptr, ptr %4, align 8, !dbg !327
  %45 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %44, i32 0, i32 5, !dbg !328
  store i32 0, ptr %45, align 8, !dbg !329
  %46 = load i32, ptr %6, align 4, !dbg !330
  %47 = load i32, ptr %6, align 4, !dbg !332
  %48 = sub i32 %47, 1, !dbg !333
  %49 = and i32 %46, %48, !dbg !334
  %50 = icmp ne i32 %49, 0, !dbg !334
  br i1 %50, label %51, label %57, !dbg !335

51:                                               ; preds = %33
  %52 = load i32, ptr %6, align 4, !dbg !336
  %53 = urem i32 -1, %52, !dbg !337
  %54 = add i32 %53, 1, !dbg !338
  %55 = load ptr, ptr %4, align 8, !dbg !339
  %56 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %55, i32 0, i32 2, !dbg !340
  store i32 %54, ptr %56, align 4, !dbg !341
  br label %60, !dbg !339

57:                                               ; preds = %33
  %58 = load ptr, ptr %4, align 8, !dbg !342
  %59 = getelementptr inbounds %struct.ck_spinlock_anderson, ptr %58, i32 0, i32 2, !dbg !343
  store i32 0, ptr %59, align 4, !dbg !344
  br label %60

60:                                               ; preds = %57, %51
  call void @ck_pr_barrier(), !dbg !345
  ret void, !dbg !346
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #3

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

declare void @free(ptr noundef) #3

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !347 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !352
  %5 = call i32 asm sideeffect "lwz $0, $1", "=r,*m,~{memory}"(ptr elementtype(i32) %4) #8, !dbg !352, !srcloc !354
  store i32 %5, ptr %3, align 4, !dbg !352
  %6 = load i32, ptr %3, align 4, !dbg !352
  ret i32 %6, !dbg !352
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal zeroext i1 @ck_pr_cas_uint_value(ptr noundef %0, i32 noundef %1, i32 noundef %2, ptr noundef %3) #0 !dbg !355 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store i32 %1, ptr %6, align 4
  store i32 %2, ptr %7, align 4
  store ptr %3, ptr %8, align 8
  %10 = load ptr, ptr %5, align 8, !dbg !360
  %11 = load i32, ptr %7, align 4, !dbg !360
  %12 = load i32, ptr %6, align 4, !dbg !360
  %13 = call i32 asm sideeffect "1:;lwarx $0, 0, $1;cmpw  0, $0, $3;bne-  2f;stwcx. $2, 0, $1;bne-  1b;2:", "=&r,r,r,r,~{memory},~{cc}"(ptr %10, i32 %11, i32 %12) #8, !dbg !360, !srcloc !365
  store i32 %13, ptr %9, align 4, !dbg !360
  %14 = load i32, ptr %9, align 4, !dbg !360
  %15 = load ptr, ptr %8, align 8, !dbg !360
  store i32 %14, ptr %15, align 4, !dbg !360
  %16 = load i32, ptr %9, align 4, !dbg !360
  %17 = load i32, ptr %6, align 4, !dbg !360
  %18 = icmp eq i32 %16, %17, !dbg !360
  ret i1 %18, !dbg !360
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_faa_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !366 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %7 = load ptr, ptr %3, align 8, !dbg !370
  %8 = load i32, ptr %4, align 4, !dbg !370
  %9 = call { i32, i32 } asm sideeffect "1:;lwarx $0, 0, $2;add $1, $3, $0;stwcx. $1, 0, $2;bne-  1b;", "=&r,=&r,r,r,~{memory},~{cc}"(ptr %7, i32 %8) #8, !dbg !370, !srcloc !374
  %10 = extractvalue { i32, i32 } %9, 0, !dbg !370
  %11 = extractvalue { i32, i32 } %9, 1, !dbg !370
  store i32 %10, ptr %5, align 4, !dbg !370
  store i32 %11, ptr %6, align 4, !dbg !370
  %12 = load i32, ptr %5, align 4, !dbg !370
  ret i32 %12, !dbg !370
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_load() #0 !dbg !375 {
  call void @ck_pr_fence_strict_load(), !dbg !379
  ret void, !dbg !379
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_stall() #0 !dbg !380 {
  call void asm sideeffect "or 1, 1, 1;or 2, 2, 2;", "~{memory}"() #8, !dbg !381, !srcloc !382
  ret void, !dbg !383
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !384 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8, !dbg !388
  %6 = load i32, ptr %4, align 4, !dbg !388
  call void asm sideeffect "stw $1, $0", "=*m,r,~{memory}"(ptr elementtype(i32) %5, i32 %6) #8, !dbg !388, !srcloc !390
  ret void, !dbg !388
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_lock() #0 !dbg !391 {
  call void @ck_pr_fence_strict_lock(), !dbg !392
  ret void, !dbg !392
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_load() #0 !dbg !393 {
  call void asm sideeffect "lwsync", "~{memory}"() #8, !dbg !394, !srcloc !395
  ret void, !dbg !394
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_lock() #0 !dbg !396 {
  call void asm sideeffect "lwsync", "~{memory}"() #8, !dbg !397, !srcloc !398
  ret void, !dbg !397
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_unlock() #0 !dbg !399 {
  call void @ck_pr_fence_strict_unlock(), !dbg !400
  ret void, !dbg !400
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_unlock() #0 !dbg !401 {
  call void asm sideeffect "lwsync", "~{memory}"() #8, !dbg !402, !srcloc !403
  ret void, !dbg !402
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_barrier() #0 !dbg !404 {
  call void asm sideeffect "", "~{memory}"() #8, !dbg !406, !srcloc !407
  ret void, !dbg !408
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

!llvm.module.flags = !{!55, !56, !57, !58, !59, !60, !61}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!62}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 10, type: !20, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "tests/anderson.c", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "3e8b6a5b525882d6b2763da0001a63b2")
!4 = !{!5, !6, !14, !16}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_anderson_thread_t", file: !8, line: 45, baseType: !9)
!8 = !DIFile(filename: "include/spinlock/anderson.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "6be228a7ecae2c5a8091cfc6ea102208")
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_anderson_thread", file: !8, line: 41, size: 64, elements: !10)
!10 = !{!11, !13}
!11 = !DIDerivedType(tag: DW_TAG_member, name: "locked", scope: !9, file: !8, line: 42, baseType: !12, size: 32)
!12 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!13 = !DIDerivedType(tag: DW_TAG_member, name: "position", scope: !9, file: !8, line: 43, baseType: !12, size: 32, offset: 32)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !12)
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!17 = !{!0, !18, !21, !28, !33, !38, !53}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 10, type: !20, isLocal: false, isDefinition: true)
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(scope: null, file: !3, line: 55, type: !23, isLocal: true, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 40, elements: !26)
!24 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !25)
!25 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!26 = !{!27}
!27 = !DISubrange(count: 5)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !3, line: 55, type: !30, isLocal: true, isDefinition: true)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 88, elements: !31)
!31 = !{!32}
!32 = !DISubrange(count: 11)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(scope: null, file: !3, line: 55, type: !35, isLocal: true, isDefinition: true)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 248, elements: !36)
!36 = !{!37}
!37 = !DISubrange(count: 31)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 11, type: !40, isLocal: false, isDefinition: true)
!40 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_anderson_t", file: !8, line: 55, baseType: !41)
!41 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_anderson", file: !8, line: 47, size: 576, elements: !42)
!42 = !{!43, !45, !46, !47, !48, !52}
!43 = !DIDerivedType(tag: DW_TAG_member, name: "slots", scope: !41, file: !8, line: 48, baseType: !44, size: 64)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !41, file: !8, line: 49, baseType: !12, size: 32, offset: 64)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "wrap", scope: !41, file: !8, line: 50, baseType: !12, size: 32, offset: 96)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "mask", scope: !41, file: !8, line: 51, baseType: !12, size: 32, offset: 128)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !41, file: !8, line: 52, baseType: !49, size: 352, offset: 160)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 352, elements: !50)
!50 = !{!51}
!51 = !DISubrange(count: 44)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !41, file: !8, line: 53, baseType: !12, size: 32, offset: 512)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "slots", scope: !2, file: !3, line: 12, type: !6, isLocal: false, isDefinition: true)
!55 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 0]}
!56 = !{i32 7, !"Dwarf Version", i32 5}
!57 = !{i32 2, !"Debug Info Version", i32 3}
!58 = !{i32 1, !"wchar_size", i32 4}
!59 = !{i32 8, !"PIC Level", i32 2}
!60 = !{i32 7, !"uwtable", i32 1}
!61 = !{i32 7, !"frame-pointer", i32 1}
!62 = !{!"Homebrew clang version 19.1.7"}
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
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
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
!98 = !DILocation(line: 114, column: 6, scope: !77)
!99 = !DILocation(line: 115, column: 14, scope: !100)
!100 = distinct !DILexicalBlock(scope: !95, file: !8, line: 114, column: 23)
!101 = !DILocation(line: 115, column: 12, scope: !100)
!102 = !DILocation(line: 117, column: 3, scope: !100)
!103 = !DILocation(line: 118, column: 8, scope: !104)
!104 = distinct !DILexicalBlock(scope: !105, file: !8, line: 118, column: 8)
!105 = distinct !DILexicalBlock(scope: !100, file: !8, line: 117, column: 6)
!106 = !DILocation(line: 118, column: 17, scope: !104)
!107 = !DILocation(line: 118, column: 8, scope: !105)
!108 = !DILocation(line: 119, column: 12, scope: !104)
!109 = !DILocation(line: 119, column: 18, scope: !104)
!110 = !DILocation(line: 119, column: 10, scope: !104)
!111 = !DILocation(line: 119, column: 5, scope: !104)
!112 = !DILocation(line: 121, column: 12, scope: !104)
!113 = !DILocation(line: 121, column: 21, scope: !104)
!114 = !DILocation(line: 121, column: 10, scope: !104)
!115 = !DILocation(line: 122, column: 3, scope: !105)
!116 = !DILocation(line: 122, column: 34, scope: !100)
!117 = !DILocation(line: 122, column: 40, scope: !100)
!118 = !DILocation(line: 122, column: 46, scope: !100)
!119 = !DILocation(line: 123, column: 12, scope: !100)
!120 = !DILocation(line: 122, column: 12, scope: !100)
!121 = !DILocation(line: 123, column: 29, scope: !100)
!122 = distinct !{!122, !102, !123, !124}
!123 = !DILocation(line: 123, column: 37, scope: !100)
!124 = !{!"llvm.loop.mustprogress"}
!125 = !DILocation(line: 125, column: 15, scope: !100)
!126 = !DILocation(line: 125, column: 12, scope: !100)
!127 = !DILocation(line: 126, column: 2, scope: !100)
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
!138 = !DILocation(line: 138, column: 9, scope: !77)
!139 = !DILocation(line: 138, column: 56, scope: !77)
!140 = !DILocation(line: 139, column: 3, scope: !77)
!141 = distinct !{!141, !137, !142, !124}
!142 = !DILocation(line: 139, column: 15, scope: !77)
!143 = !DILocation(line: 142, column: 2, scope: !77)
!144 = !DILocation(line: 143, column: 2, scope: !77)
!145 = !DILocation(line: 145, column: 10, scope: !77)
!146 = !DILocation(line: 145, column: 16, scope: !77)
!147 = !DILocation(line: 145, column: 24, scope: !77)
!148 = !DILocation(line: 145, column: 22, scope: !77)
!149 = !DILocation(line: 145, column: 3, scope: !77)
!150 = !DILocation(line: 145, column: 8, scope: !77)
!151 = !DILocation(line: 146, column: 2, scope: !77)
!152 = distinct !DISubprogram(name: "ck_spinlock_anderson_unlock", scope: !8, file: !8, line: 150, type: !153, scopeLine: 152, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!153 = !DISubroutineType(types: !154)
!154 = !{null, !80, !44}
!155 = !DILocalVariable(name: "lock", arg: 1, scope: !152, file: !8, line: 150, type: !80)
!156 = !DILocation(line: 150, column: 58, scope: !152)
!157 = !DILocalVariable(name: "slot", arg: 2, scope: !152, file: !8, line: 151, type: !44)
!158 = !DILocation(line: 151, column: 41, scope: !152)
!159 = !DILocalVariable(name: "position", scope: !152, file: !8, line: 153, type: !12)
!160 = !DILocation(line: 153, column: 15, scope: !152)
!161 = !DILocation(line: 155, column: 2, scope: !152)
!162 = !DILocation(line: 158, column: 6, scope: !163)
!163 = distinct !DILexicalBlock(scope: !152, file: !8, line: 158, column: 6)
!164 = !DILocation(line: 158, column: 12, scope: !163)
!165 = !DILocation(line: 158, column: 17, scope: !163)
!166 = !DILocation(line: 158, column: 6, scope: !152)
!167 = !DILocation(line: 159, column: 15, scope: !163)
!168 = !DILocation(line: 159, column: 21, scope: !163)
!169 = !DILocation(line: 159, column: 30, scope: !163)
!170 = !DILocation(line: 159, column: 37, scope: !163)
!171 = !DILocation(line: 159, column: 43, scope: !163)
!172 = !DILocation(line: 159, column: 35, scope: !163)
!173 = !DILocation(line: 159, column: 12, scope: !163)
!174 = !DILocation(line: 159, column: 3, scope: !163)
!175 = !DILocation(line: 161, column: 15, scope: !163)
!176 = !DILocation(line: 161, column: 21, scope: !163)
!177 = !DILocation(line: 161, column: 30, scope: !163)
!178 = !DILocation(line: 161, column: 37, scope: !163)
!179 = !DILocation(line: 161, column: 43, scope: !163)
!180 = !DILocation(line: 161, column: 35, scope: !163)
!181 = !DILocation(line: 161, column: 12, scope: !163)
!182 = !DILocation(line: 163, column: 2, scope: !152)
!183 = !DILocation(line: 164, column: 2, scope: !152)
!184 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 26, type: !185, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !66)
!185 = !DISubroutineType(types: !186)
!186 = !{!20}
!187 = !DILocalVariable(name: "threads", scope: !184, file: !3, line: 28, type: !188)
!188 = !DICompositeType(tag: DW_TAG_array_type, baseType: !189, size: 192, elements: !212)
!189 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !190, line: 31, baseType: !191)
!190 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!191 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !192, line: 118, baseType: !193)
!192 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!193 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !194, size: 64)
!194 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !192, line: 103, size: 65536, elements: !195)
!195 = !{!196, !198, !208}
!196 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !194, file: !192, line: 104, baseType: !197, size: 64)
!197 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!198 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !194, file: !192, line: 105, baseType: !199, size: 64, offset: 64)
!199 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !200, size: 64)
!200 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !192, line: 57, size: 192, elements: !201)
!201 = !{!202, !206, !207}
!202 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !200, file: !192, line: 58, baseType: !203, size: 64)
!203 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !204, size: 64)
!204 = !DISubroutineType(types: !205)
!205 = !{null, !5}
!206 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !200, file: !192, line: 59, baseType: !5, size: 64, offset: 64)
!207 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !200, file: !192, line: 60, baseType: !199, size: 64, offset: 128)
!208 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !194, file: !192, line: 106, baseType: !209, size: 65408, offset: 128)
!209 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 65408, elements: !210)
!210 = !{!211}
!211 = !DISubrange(count: 8176)
!212 = !{!213}
!213 = !DISubrange(count: 3)
!214 = !DILocation(line: 28, column: 15, scope: !184)
!215 = !DILocalVariable(name: "i", scope: !184, file: !3, line: 29, type: !20)
!216 = !DILocation(line: 29, column: 9, scope: !184)
!217 = !DILocation(line: 31, column: 46, scope: !184)
!218 = !DILocation(line: 31, column: 11, scope: !184)
!219 = !DILocation(line: 32, column: 9, scope: !220)
!220 = distinct !DILexicalBlock(scope: !184, file: !3, line: 32, column: 9)
!221 = !DILocation(line: 32, column: 15, scope: !220)
!222 = !DILocation(line: 32, column: 9, scope: !184)
!223 = !DILocation(line: 34, column: 9, scope: !224)
!224 = distinct !DILexicalBlock(scope: !220, file: !3, line: 33, column: 5)
!225 = !DILocation(line: 37, column: 38, scope: !184)
!226 = !DILocation(line: 37, column: 5, scope: !184)
!227 = !DILocation(line: 39, column: 12, scope: !228)
!228 = distinct !DILexicalBlock(scope: !184, file: !3, line: 39, column: 5)
!229 = !DILocation(line: 39, column: 10, scope: !228)
!230 = !DILocation(line: 39, column: 17, scope: !231)
!231 = distinct !DILexicalBlock(scope: !228, file: !3, line: 39, column: 5)
!232 = !DILocation(line: 39, column: 19, scope: !231)
!233 = !DILocation(line: 39, column: 5, scope: !228)
!234 = !DILocation(line: 41, column: 37, scope: !235)
!235 = distinct !DILexicalBlock(scope: !236, file: !3, line: 41, column: 13)
!236 = distinct !DILexicalBlock(scope: !231, file: !3, line: 40, column: 5)
!237 = !DILocation(line: 41, column: 29, scope: !235)
!238 = !DILocation(line: 41, column: 13, scope: !235)
!239 = !DILocation(line: 41, column: 58, scope: !235)
!240 = !DILocation(line: 41, column: 13, scope: !236)
!241 = !DILocation(line: 43, column: 13, scope: !242)
!242 = distinct !DILexicalBlock(scope: !235, file: !3, line: 42, column: 9)
!243 = !DILocation(line: 45, column: 5, scope: !236)
!244 = !DILocation(line: 39, column: 32, scope: !231)
!245 = !DILocation(line: 39, column: 5, scope: !231)
!246 = distinct !{!246, !233, !247, !124}
!247 = !DILocation(line: 45, column: 5, scope: !228)
!248 = !DILocation(line: 47, column: 12, scope: !249)
!249 = distinct !DILexicalBlock(scope: !184, file: !3, line: 47, column: 5)
!250 = !DILocation(line: 47, column: 10, scope: !249)
!251 = !DILocation(line: 47, column: 17, scope: !252)
!252 = distinct !DILexicalBlock(scope: !249, file: !3, line: 47, column: 5)
!253 = !DILocation(line: 47, column: 19, scope: !252)
!254 = !DILocation(line: 47, column: 5, scope: !249)
!255 = !DILocation(line: 49, column: 34, scope: !256)
!256 = distinct !DILexicalBlock(scope: !257, file: !3, line: 49, column: 13)
!257 = distinct !DILexicalBlock(scope: !252, file: !3, line: 48, column: 5)
!258 = !DILocation(line: 49, column: 26, scope: !256)
!259 = !DILocation(line: 49, column: 13, scope: !256)
!260 = !DILocation(line: 49, column: 44, scope: !256)
!261 = !DILocation(line: 49, column: 13, scope: !257)
!262 = !DILocation(line: 51, column: 13, scope: !263)
!263 = distinct !DILexicalBlock(scope: !256, file: !3, line: 50, column: 9)
!264 = !DILocation(line: 53, column: 5, scope: !257)
!265 = !DILocation(line: 47, column: 32, scope: !252)
!266 = !DILocation(line: 47, column: 5, scope: !252)
!267 = distinct !{!267, !254, !268, !124}
!268 = !DILocation(line: 53, column: 5, scope: !249)
!269 = !DILocation(line: 55, column: 5, scope: !184)
!270 = !DILocation(line: 0, scope: !184)
!271 = !DILocation(line: 57, column: 10, scope: !184)
!272 = !DILocation(line: 57, column: 5, scope: !184)
!273 = !DILocation(line: 59, column: 5, scope: !184)
!274 = distinct !DISubprogram(name: "ck_spinlock_anderson_init", scope: !8, file: !8, line: 58, type: !275, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!275 = !DISubroutineType(types: !276)
!276 = !{null, !80, !44, !12}
!277 = !DILocalVariable(name: "lock", arg: 1, scope: !274, file: !8, line: 58, type: !80)
!278 = !DILocation(line: 58, column: 56, scope: !274)
!279 = !DILocalVariable(name: "slots", arg: 2, scope: !274, file: !8, line: 59, type: !44)
!280 = !DILocation(line: 59, column: 41, scope: !274)
!281 = !DILocalVariable(name: "count", arg: 3, scope: !274, file: !8, line: 60, type: !12)
!282 = !DILocation(line: 60, column: 18, scope: !274)
!283 = !DILocalVariable(name: "i", scope: !274, file: !8, line: 62, type: !12)
!284 = !DILocation(line: 62, column: 15, scope: !274)
!285 = !DILocation(line: 64, column: 2, scope: !274)
!286 = !DILocation(line: 64, column: 11, scope: !274)
!287 = !DILocation(line: 64, column: 18, scope: !274)
!288 = !DILocation(line: 65, column: 2, scope: !274)
!289 = !DILocation(line: 65, column: 11, scope: !274)
!290 = !DILocation(line: 65, column: 20, scope: !274)
!291 = !DILocation(line: 66, column: 9, scope: !292)
!292 = distinct !DILexicalBlock(scope: !274, file: !8, line: 66, column: 2)
!293 = !DILocation(line: 66, column: 7, scope: !292)
!294 = !DILocation(line: 66, column: 14, scope: !295)
!295 = distinct !DILexicalBlock(scope: !292, file: !8, line: 66, column: 2)
!296 = !DILocation(line: 66, column: 18, scope: !295)
!297 = !DILocation(line: 66, column: 16, scope: !295)
!298 = !DILocation(line: 66, column: 2, scope: !292)
!299 = !DILocation(line: 67, column: 3, scope: !300)
!300 = distinct !DILexicalBlock(scope: !295, file: !8, line: 66, column: 30)
!301 = !DILocation(line: 67, column: 9, scope: !300)
!302 = !DILocation(line: 67, column: 12, scope: !300)
!303 = !DILocation(line: 67, column: 19, scope: !300)
!304 = !DILocation(line: 68, column: 23, scope: !300)
!305 = !DILocation(line: 68, column: 3, scope: !300)
!306 = !DILocation(line: 68, column: 9, scope: !300)
!307 = !DILocation(line: 68, column: 12, scope: !300)
!308 = !DILocation(line: 68, column: 21, scope: !300)
!309 = !DILocation(line: 69, column: 2, scope: !300)
!310 = !DILocation(line: 66, column: 26, scope: !295)
!311 = !DILocation(line: 66, column: 2, scope: !295)
!312 = distinct !{!312, !298, !313, !124}
!313 = !DILocation(line: 69, column: 2, scope: !292)
!314 = !DILocation(line: 71, column: 16, scope: !274)
!315 = !DILocation(line: 71, column: 2, scope: !274)
!316 = !DILocation(line: 71, column: 8, scope: !274)
!317 = !DILocation(line: 71, column: 14, scope: !274)
!318 = !DILocation(line: 72, column: 16, scope: !274)
!319 = !DILocation(line: 72, column: 2, scope: !274)
!320 = !DILocation(line: 72, column: 8, scope: !274)
!321 = !DILocation(line: 72, column: 14, scope: !274)
!322 = !DILocation(line: 73, column: 15, scope: !274)
!323 = !DILocation(line: 73, column: 21, scope: !274)
!324 = !DILocation(line: 73, column: 2, scope: !274)
!325 = !DILocation(line: 73, column: 8, scope: !274)
!326 = !DILocation(line: 73, column: 13, scope: !274)
!327 = !DILocation(line: 74, column: 2, scope: !274)
!328 = !DILocation(line: 74, column: 8, scope: !274)
!329 = !DILocation(line: 74, column: 13, scope: !274)
!330 = !DILocation(line: 81, column: 6, scope: !331)
!331 = distinct !DILexicalBlock(scope: !274, file: !8, line: 81, column: 6)
!332 = !DILocation(line: 81, column: 15, scope: !331)
!333 = !DILocation(line: 81, column: 21, scope: !331)
!334 = !DILocation(line: 81, column: 12, scope: !331)
!335 = !DILocation(line: 81, column: 6, scope: !274)
!336 = !DILocation(line: 82, column: 28, scope: !331)
!337 = !DILocation(line: 82, column: 26, scope: !331)
!338 = !DILocation(line: 82, column: 35, scope: !331)
!339 = !DILocation(line: 82, column: 3, scope: !331)
!340 = !DILocation(line: 82, column: 9, scope: !331)
!341 = !DILocation(line: 82, column: 14, scope: !331)
!342 = !DILocation(line: 84, column: 3, scope: !331)
!343 = !DILocation(line: 84, column: 9, scope: !331)
!344 = !DILocation(line: 84, column: 14, scope: !331)
!345 = !DILocation(line: 86, column: 2, scope: !274)
!346 = !DILocation(line: 87, column: 2, scope: !274)
!347 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !348, file: !348, line: 113, type: !349, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!348 = !DIFile(filename: "include/gcc/ppc64/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "1c5aecf7376064f28c732d8a93471464")
!349 = !DISubroutineType(types: !350)
!350 = !{!12, !14}
!351 = !DILocalVariable(name: "target", arg: 1, scope: !347, file: !348, line: 113, type: !14)
!352 = !DILocation(line: 113, column: 1, scope: !347)
!353 = !DILocalVariable(name: "r", scope: !347, file: !348, line: 113, type: !12)
!354 = !{i64 2147765597}
!355 = distinct !DISubprogram(name: "ck_pr_cas_uint_value", scope: !348, file: !348, line: 280, type: !356, scopeLine: 280, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!356 = !DISubroutineType(types: !357)
!357 = !{!358, !16, !12, !12, !16}
!358 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!359 = !DILocalVariable(name: "target", arg: 1, scope: !355, file: !348, line: 280, type: !16)
!360 = !DILocation(line: 280, column: 1, scope: !355)
!361 = !DILocalVariable(name: "compare", arg: 2, scope: !355, file: !348, line: 280, type: !12)
!362 = !DILocalVariable(name: "set", arg: 3, scope: !355, file: !348, line: 280, type: !12)
!363 = !DILocalVariable(name: "value", arg: 4, scope: !355, file: !348, line: 280, type: !16)
!364 = !DILocalVariable(name: "previous", scope: !355, file: !348, line: 280, type: !12)
!365 = !{i64 2147772254}
!366 = distinct !DISubprogram(name: "ck_pr_faa_uint", scope: !348, file: !348, line: 424, type: !367, scopeLine: 424, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!367 = !DISubroutineType(types: !368)
!368 = !{!12, !16, !12}
!369 = !DILocalVariable(name: "target", arg: 1, scope: !366, file: !348, line: 424, type: !16)
!370 = !DILocation(line: 424, column: 1, scope: !366)
!371 = !DILocalVariable(name: "delta", arg: 2, scope: !366, file: !348, line: 424, type: !12)
!372 = !DILocalVariable(name: "previous", scope: !366, file: !348, line: 424, type: !12)
!373 = !DILocalVariable(name: "r", scope: !366, file: !348, line: 424, type: !12)
!374 = !{i64 2147801504}
!375 = distinct !DISubprogram(name: "ck_pr_fence_load", scope: !376, file: !376, line: 112, type: !377, scopeLine: 112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!376 = !DIFile(filename: "include/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "cffbc3bc631aa31cdde49d8ca6470a32")
!377 = !DISubroutineType(types: !378)
!378 = !{null}
!379 = !DILocation(line: 112, column: 1, scope: !375)
!380 = distinct !DISubprogram(name: "ck_pr_stall", scope: !348, file: !348, line: 56, type: !377, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!381 = !DILocation(line: 59, column: 2, scope: !380)
!382 = !{i64 264630}
!383 = !DILocation(line: 61, column: 2, scope: !380)
!384 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !348, file: !348, line: 143, type: !385, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !66)
!385 = !DISubroutineType(types: !386)
!386 = !{null, !16, !12}
!387 = !DILocalVariable(name: "target", arg: 1, scope: !384, file: !348, line: 143, type: !16)
!388 = !DILocation(line: 143, column: 1, scope: !384)
!389 = !DILocalVariable(name: "v", arg: 2, scope: !384, file: !348, line: 143, type: !12)
!390 = !{i64 2147769244}
!391 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !376, file: !376, line: 118, type: !377, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!392 = !DILocation(line: 118, column: 1, scope: !391)
!393 = distinct !DISubprogram(name: "ck_pr_fence_strict_load", scope: !348, file: !348, line: 82, type: !377, scopeLine: 82, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!394 = !DILocation(line: 82, column: 1, scope: !393)
!395 = !{i64 2147761862}
!396 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !348, file: !348, line: 88, type: !377, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!397 = !DILocation(line: 88, column: 1, scope: !396)
!398 = !{i64 2147763062}
!399 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !376, file: !376, line: 119, type: !377, scopeLine: 119, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!400 = !DILocation(line: 119, column: 1, scope: !399)
!401 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !348, file: !348, line: 89, type: !377, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!402 = !DILocation(line: 89, column: 1, scope: !401)
!403 = !{i64 2147763259}
!404 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !405, file: !405, line: 37, type: !377, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!405 = !DIFile(filename: "include/gcc/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!406 = !DILocation(line: 40, column: 2, scope: !404)
!407 = !{i64 320331}
!408 = !DILocation(line: 41, column: 2, scope: !404)
