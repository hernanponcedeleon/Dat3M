; ModuleID = 'benchmarks/ck/anderson.c'
source_filename = "benchmarks/ck/anderson.c"
target datalayout = "E-m:e-Fi64-i64:64-i128:128-n32:64-S128-v256:256:256-v512:512:512"
target triple = "ppc64-pc-linux-gnu"

%struct.ck_spinlock_anderson = type { ptr, i32, i32, i32, [44 x i8], i32 }
%struct.ck_spinlock_anderson_thread = type { i32, i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !22
@lock = dso_local global %struct.ck_spinlock_anderson zeroinitializer, align 8, !dbg !41
@slots = dso_local global ptr null, align 8, !dbg !56
@.str = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !24
@.str.1 = private unnamed_addr constant [25 x i8] c"benchmarks/ck/anderson.c\00", align 1, !dbg !30
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !35

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @run(ptr noundef %0) #0 !dbg !66 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !70, !DIExpression(), !71)
    #dbg_declare(ptr %3, !72, !DIExpression(), !73)
  call void @ck_spinlock_anderson_lock(ptr noundef @lock, ptr noundef %3), !dbg !74
  %4 = load i32, ptr @x, align 4, !dbg !75
  %5 = add nsw i32 %4, 1, !dbg !75
  store i32 %5, ptr @x, align 4, !dbg !75
  %6 = load i32, ptr @y, align 4, !dbg !76
  %7 = add nsw i32 %6, 1, !dbg !76
  store i32 %7, ptr @y, align 4, !dbg !76
  %8 = load ptr, ptr %3, align 8, !dbg !77
  call void @ck_spinlock_anderson_unlock(ptr noundef @lock, ptr noundef %8), !dbg !78
  ret ptr null, !dbg !79
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_anderson_lock(ptr noundef %0, ptr noundef %1) #0 !dbg !80 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !85, !DIExpression(), !86)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !87, !DIExpression(), !88)
    #dbg_declare(ptr %5, !89, !DIExpression(), !90)
    #dbg_declare(ptr %6, !91, !DIExpression(), !92)
    #dbg_declare(ptr %7, !93, !DIExpression(), !94)
  %8 = load ptr, ptr %3, align 8, !dbg !95
  %9 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %8, i32 0, i32 1, !dbg !96
  %10 = load i32, ptr %9, align 8, !dbg !96
  store i32 %10, ptr %7, align 4, !dbg !94
  %11 = load ptr, ptr %3, align 8, !dbg !97
  %12 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %11, i32 0, i32 2, !dbg !99
  %13 = load i32, ptr %12, align 4, !dbg !99
  %14 = icmp ne i32 %13, 0, !dbg !100
  br i1 %14, label %15, label %42, !dbg !100

15:                                               ; preds = %2
  %16 = load ptr, ptr %3, align 8, !dbg !101
  %17 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %16, i32 0, i32 5, !dbg !103
  %18 = call zeroext i32 @ck_pr_md_load_uint(ptr noundef %17), !dbg !104
  store i32 %18, ptr %5, align 4, !dbg !105
  br label %19, !dbg !106

19:                                               ; preds = %30, %15
  %20 = load i32, ptr %5, align 4, !dbg !107
  %21 = icmp eq i32 %20, -1, !dbg !110
  br i1 %21, label %22, label %26, !dbg !110

22:                                               ; preds = %19
  %23 = load ptr, ptr %3, align 8, !dbg !111
  %24 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %23, i32 0, i32 2, !dbg !112
  %25 = load i32, ptr %24, align 4, !dbg !112
  store i32 %25, ptr %6, align 4, !dbg !113
  br label %29, !dbg !114

26:                                               ; preds = %19
  %27 = load i32, ptr %5, align 4, !dbg !115
  %28 = add i32 %27, 1, !dbg !116
  store i32 %28, ptr %6, align 4, !dbg !117
  br label %29

29:                                               ; preds = %26, %22
  br label %30, !dbg !118

30:                                               ; preds = %29
  %31 = load ptr, ptr %3, align 8, !dbg !119
  %32 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %31, i32 0, i32 5, !dbg !120
  %33 = load i32, ptr %5, align 4, !dbg !121
  %34 = load i32, ptr %6, align 4, !dbg !122
  %35 = call zeroext i1 @ck_pr_cas_uint_value(ptr noundef %32, i32 noundef zeroext %33, i32 noundef zeroext %34, ptr noundef %5), !dbg !123
  %36 = zext i1 %35 to i32, !dbg !123
  %37 = icmp eq i32 %36, 0, !dbg !124
  br i1 %37, label %19, label %38, !dbg !118, !llvm.loop !125

38:                                               ; preds = %30
  %39 = load i32, ptr %7, align 4, !dbg !128
  %40 = load i32, ptr %5, align 4, !dbg !129
  %41 = urem i32 %40, %39, !dbg !129
  store i32 %41, ptr %5, align 4, !dbg !129
  br label %51, !dbg !130

42:                                               ; preds = %2
  %43 = load ptr, ptr %3, align 8, !dbg !131
  %44 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %43, i32 0, i32 5, !dbg !133
  %45 = call zeroext i32 @ck_pr_faa_uint(ptr noundef %44, i32 noundef zeroext 1), !dbg !134
  store i32 %45, ptr %5, align 4, !dbg !135
  %46 = load ptr, ptr %3, align 8, !dbg !136
  %47 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %46, i32 0, i32 3, !dbg !137
  %48 = load i32, ptr %47, align 8, !dbg !137
  %49 = load i32, ptr %5, align 4, !dbg !138
  %50 = and i32 %49, %48, !dbg !138
  store i32 %50, ptr %5, align 4, !dbg !138
  br label %51

51:                                               ; preds = %42, %38
  call void @ck_pr_fence_load(), !dbg !139
  br label %52, !dbg !140

52:                                               ; preds = %62, %51
  %53 = load ptr, ptr %3, align 8, !dbg !141
  %54 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %53, i32 0, i32 0, !dbg !142
  %55 = load ptr, ptr %54, align 8, !dbg !142
  %56 = load i32, ptr %5, align 4, !dbg !143
  %57 = zext i32 %56 to i64, !dbg !141
  %58 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %55, i64 %57, !dbg !141
  %59 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %58, i32 0, i32 0, !dbg !144
  %60 = call zeroext i32 @ck_pr_md_load_uint(ptr noundef %59), !dbg !145
  %61 = icmp eq i32 %60, 1, !dbg !146
  br i1 %61, label %62, label %63, !dbg !140

62:                                               ; preds = %52
  call void @ck_pr_stall(), !dbg !147
  br label %52, !dbg !140, !llvm.loop !148

63:                                               ; preds = %52
  %64 = load ptr, ptr %3, align 8, !dbg !150
  %65 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %64, i32 0, i32 0, !dbg !151
  %66 = load ptr, ptr %65, align 8, !dbg !151
  %67 = load i32, ptr %5, align 4, !dbg !152
  %68 = zext i32 %67 to i64, !dbg !150
  %69 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %66, i64 %68, !dbg !150
  %70 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %69, i32 0, i32 0, !dbg !153
  call void @ck_pr_md_store_uint(ptr noundef %70, i32 noundef zeroext 1), !dbg !154
  call void @ck_pr_fence_lock(), !dbg !155
  %71 = load ptr, ptr %3, align 8, !dbg !156
  %72 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %71, i32 0, i32 0, !dbg !157
  %73 = load ptr, ptr %72, align 8, !dbg !157
  %74 = load i32, ptr %5, align 4, !dbg !158
  %75 = zext i32 %74 to i64, !dbg !159
  %76 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %73, i64 %75, !dbg !159
  %77 = load ptr, ptr %4, align 8, !dbg !160
  store ptr %76, ptr %77, align 8, !dbg !161
  ret void, !dbg !162
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_anderson_unlock(ptr noundef %0, ptr noundef %1) #0 !dbg !163 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !166, !DIExpression(), !167)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !168, !DIExpression(), !169)
    #dbg_declare(ptr %5, !170, !DIExpression(), !171)
  call void @ck_pr_fence_unlock(), !dbg !172
  %6 = load ptr, ptr %3, align 8, !dbg !173
  %7 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %6, i32 0, i32 2, !dbg !175
  %8 = load i32, ptr %7, align 4, !dbg !175
  %9 = icmp eq i32 %8, 0, !dbg !176
  br i1 %9, label %10, label %19, !dbg !176

10:                                               ; preds = %2
  %11 = load ptr, ptr %4, align 8, !dbg !177
  %12 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %11, i32 0, i32 1, !dbg !178
  %13 = load i32, ptr %12, align 4, !dbg !178
  %14 = add i32 %13, 1, !dbg !179
  %15 = load ptr, ptr %3, align 8, !dbg !180
  %16 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %15, i32 0, i32 3, !dbg !181
  %17 = load i32, ptr %16, align 8, !dbg !181
  %18 = and i32 %14, %17, !dbg !182
  store i32 %18, ptr %5, align 4, !dbg !183
  br label %28, !dbg !184

19:                                               ; preds = %2
  %20 = load ptr, ptr %4, align 8, !dbg !185
  %21 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %20, i32 0, i32 1, !dbg !186
  %22 = load i32, ptr %21, align 4, !dbg !186
  %23 = add i32 %22, 1, !dbg !187
  %24 = load ptr, ptr %3, align 8, !dbg !188
  %25 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %24, i32 0, i32 1, !dbg !189
  %26 = load i32, ptr %25, align 8, !dbg !189
  %27 = urem i32 %23, %26, !dbg !190
  store i32 %27, ptr %5, align 4, !dbg !191
  br label %28

28:                                               ; preds = %19, %10
  %29 = load ptr, ptr %3, align 8, !dbg !192
  %30 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %29, i32 0, i32 0, !dbg !193
  %31 = load ptr, ptr %30, align 8, !dbg !193
  %32 = load i32, ptr %5, align 4, !dbg !194
  %33 = zext i32 %32 to i64, !dbg !192
  %34 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %31, i64 %33, !dbg !192
  %35 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %34, i32 0, i32 0, !dbg !195
  call void @ck_pr_md_store_uint(ptr noundef %35, i32 noundef zeroext 0), !dbg !196
  ret void, !dbg !197
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local signext i32 @main() #0 !dbg !198 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !201, !DIExpression(), !207)
    #dbg_declare(ptr %3, !208, !DIExpression(), !209)
  %4 = call ptr @malloc(i64 noundef 24) #4, !dbg !210
  store ptr %4, ptr @slots, align 8, !dbg !211
  %5 = load ptr, ptr @slots, align 8, !dbg !212
  %6 = icmp eq ptr %5, null, !dbg !214
  br i1 %6, label %7, label %8, !dbg !214

7:                                                ; preds = %0
  call void @exit(i32 noundef signext 1) #5, !dbg !215
  unreachable, !dbg !215

8:                                                ; preds = %0
  %9 = load ptr, ptr @slots, align 8, !dbg !217
  call void @ck_spinlock_anderson_init(ptr noundef @lock, ptr noundef %9, i32 noundef zeroext 3), !dbg !218
  store i32 0, ptr %3, align 4, !dbg !219
  br label %10, !dbg !221

10:                                               ; preds = %21, %8
  %11 = load i32, ptr %3, align 4, !dbg !222
  %12 = icmp slt i32 %11, 3, !dbg !224
  br i1 %12, label %13, label %24, !dbg !225

13:                                               ; preds = %10
  %14 = load i32, ptr %3, align 4, !dbg !226
  %15 = sext i32 %14 to i64, !dbg !229
  %16 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %15, !dbg !229
  %17 = call signext i32 @pthread_create(ptr noundef %16, ptr noundef null, ptr noundef @run, ptr noundef null), !dbg !230
  %18 = icmp ne i32 %17, 0, !dbg !231
  br i1 %18, label %19, label %20, !dbg !231

19:                                               ; preds = %13
  call void @exit(i32 noundef signext 1) #5, !dbg !232
  unreachable, !dbg !232

20:                                               ; preds = %13
  br label %21, !dbg !234

21:                                               ; preds = %20
  %22 = load i32, ptr %3, align 4, !dbg !235
  %23 = add nsw i32 %22, 1, !dbg !235
  store i32 %23, ptr %3, align 4, !dbg !235
  br label %10, !dbg !236, !llvm.loop !237

24:                                               ; preds = %10
  store i32 0, ptr %3, align 4, !dbg !239
  br label %25, !dbg !241

25:                                               ; preds = %37, %24
  %26 = load i32, ptr %3, align 4, !dbg !242
  %27 = icmp slt i32 %26, 3, !dbg !244
  br i1 %27, label %28, label %40, !dbg !245

28:                                               ; preds = %25
  %29 = load i32, ptr %3, align 4, !dbg !246
  %30 = sext i32 %29 to i64, !dbg !249
  %31 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %30, !dbg !249
  %32 = load ptr, ptr %31, align 8, !dbg !249
  %33 = call signext i32 @pthread_join(ptr noundef %32, ptr noundef null), !dbg !250
  %34 = icmp ne i32 %33, 0, !dbg !251
  br i1 %34, label %35, label %36, !dbg !251

35:                                               ; preds = %28
  call void @exit(i32 noundef signext 1) #5, !dbg !252
  unreachable, !dbg !252

36:                                               ; preds = %28
  br label %37, !dbg !254

37:                                               ; preds = %36
  %38 = load i32, ptr %3, align 4, !dbg !255
  %39 = add nsw i32 %38, 1, !dbg !255
  store i32 %39, ptr %3, align 4, !dbg !255
  br label %25, !dbg !256, !llvm.loop !257

40:                                               ; preds = %25
  %41 = load i32, ptr @x, align 4, !dbg !259
  %42 = icmp eq i32 %41, 3, !dbg !262
  br i1 %42, label %43, label %46, !dbg !263

43:                                               ; preds = %40
  %44 = load i32, ptr @y, align 4, !dbg !264
  %45 = icmp eq i32 %44, 3, !dbg !265
  br i1 %45, label %47, label %46, !dbg !266

46:                                               ; preds = %43, %40
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef signext 55, ptr noundef @__func__.main), !dbg !266
  br label %47, !dbg !266

47:                                               ; preds = %46, %43
  %48 = load ptr, ptr @slots, align 8, !dbg !267
  call void @free(ptr noundef %48), !dbg !268
  ret i32 0, !dbg !269
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noreturn
declare void @exit(i32 noundef signext) #2

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_anderson_init(ptr noundef %0, ptr noundef %1, i32 noundef zeroext %2) #0 !dbg !270 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !273, !DIExpression(), !274)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !275, !DIExpression(), !276)
  store i32 %2, ptr %6, align 4
    #dbg_declare(ptr %6, !277, !DIExpression(), !278)
    #dbg_declare(ptr %7, !279, !DIExpression(), !280)
  %8 = load ptr, ptr %5, align 8, !dbg !281
  %9 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %8, i64 0, !dbg !281
  %10 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %9, i32 0, i32 0, !dbg !282
  store i32 0, ptr %10, align 4, !dbg !283
  %11 = load ptr, ptr %5, align 8, !dbg !284
  %12 = getelementptr inbounds %struct.ck_spinlock_anderson_thread, ptr %11, i64 0, !dbg !284
  %13 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %12, i32 0, i32 1, !dbg !285
  store i32 0, ptr %13, align 4, !dbg !286
  store i32 1, ptr %7, align 4, !dbg !287
  br label %14, !dbg !289

14:                                               ; preds = %30, %3
  %15 = load i32, ptr %7, align 4, !dbg !290
  %16 = load i32, ptr %6, align 4, !dbg !292
  %17 = icmp ult i32 %15, %16, !dbg !293
  br i1 %17, label %18, label %33, !dbg !294

18:                                               ; preds = %14
  %19 = load ptr, ptr %5, align 8, !dbg !295
  %20 = load i32, ptr %7, align 4, !dbg !297
  %21 = zext i32 %20 to i64, !dbg !295
  %22 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %19, i64 %21, !dbg !295
  %23 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %22, i32 0, i32 0, !dbg !298
  store i32 1, ptr %23, align 4, !dbg !299
  %24 = load i32, ptr %7, align 4, !dbg !300
  %25 = load ptr, ptr %5, align 8, !dbg !301
  %26 = load i32, ptr %7, align 4, !dbg !302
  %27 = zext i32 %26 to i64, !dbg !301
  %28 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %25, i64 %27, !dbg !301
  %29 = getelementptr inbounds nuw %struct.ck_spinlock_anderson_thread, ptr %28, i32 0, i32 1, !dbg !303
  store i32 %24, ptr %29, align 4, !dbg !304
  br label %30, !dbg !305

30:                                               ; preds = %18
  %31 = load i32, ptr %7, align 4, !dbg !306
  %32 = add i32 %31, 1, !dbg !306
  store i32 %32, ptr %7, align 4, !dbg !306
  br label %14, !dbg !307, !llvm.loop !308

33:                                               ; preds = %14
  %34 = load ptr, ptr %5, align 8, !dbg !310
  %35 = load ptr, ptr %4, align 8, !dbg !311
  %36 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %35, i32 0, i32 0, !dbg !312
  store ptr %34, ptr %36, align 8, !dbg !313
  %37 = load i32, ptr %6, align 4, !dbg !314
  %38 = load ptr, ptr %4, align 8, !dbg !315
  %39 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %38, i32 0, i32 1, !dbg !316
  store i32 %37, ptr %39, align 8, !dbg !317
  %40 = load i32, ptr %6, align 4, !dbg !318
  %41 = sub i32 %40, 1, !dbg !319
  %42 = load ptr, ptr %4, align 8, !dbg !320
  %43 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %42, i32 0, i32 3, !dbg !321
  store i32 %41, ptr %43, align 8, !dbg !322
  %44 = load ptr, ptr %4, align 8, !dbg !323
  %45 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %44, i32 0, i32 5, !dbg !324
  store i32 0, ptr %45, align 8, !dbg !325
  %46 = load i32, ptr %6, align 4, !dbg !326
  %47 = load i32, ptr %6, align 4, !dbg !328
  %48 = sub i32 %47, 1, !dbg !329
  %49 = and i32 %46, %48, !dbg !330
  %50 = icmp ne i32 %49, 0, !dbg !330
  br i1 %50, label %51, label %57, !dbg !330

51:                                               ; preds = %33
  %52 = load i32, ptr %6, align 4, !dbg !331
  %53 = urem i32 -1, %52, !dbg !332
  %54 = add i32 %53, 1, !dbg !333
  %55 = load ptr, ptr %4, align 8, !dbg !334
  %56 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %55, i32 0, i32 2, !dbg !335
  store i32 %54, ptr %56, align 4, !dbg !336
  br label %60, !dbg !334

57:                                               ; preds = %33
  %58 = load ptr, ptr %4, align 8, !dbg !337
  %59 = getelementptr inbounds nuw %struct.ck_spinlock_anderson, ptr %58, i32 0, i32 2, !dbg !338
  store i32 0, ptr %59, align 4, !dbg !339
  br label %60

60:                                               ; preds = %57, %51
  call void @ck_pr_barrier(), !dbg !340
  ret void, !dbg !341
}

declare signext i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

declare signext i32 @pthread_join(ptr noundef, ptr noundef) #3

declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef signext, ptr noundef) #3

declare void @free(ptr noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !342 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !346, !DIExpression(), !347)
    #dbg_declare(ptr %3, !348, !DIExpression(), !347)
  %4 = load ptr, ptr %2, align 8, !dbg !347
  %5 = call i32 asm sideeffect "lwz${1:U}${1:X} $0, $1", "=r,*m,~{memory}"(ptr elementtype(i32) %4) #6, !dbg !347, !srcloc !349
  store i32 %5, ptr %3, align 4, !dbg !347
  %6 = load i32, ptr %3, align 4, !dbg !347
  ret i32 %6, !dbg !347
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i1 @ck_pr_cas_uint_value(ptr noundef %0, i32 noundef zeroext %1, i32 noundef zeroext %2, ptr noundef %3) #0 !dbg !350 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
    #dbg_declare(ptr %5, !353, !DIExpression(), !354)
  store i32 %1, ptr %6, align 4
    #dbg_declare(ptr %6, !355, !DIExpression(), !354)
  store i32 %2, ptr %7, align 4
    #dbg_declare(ptr %7, !356, !DIExpression(), !354)
  store ptr %3, ptr %8, align 8
    #dbg_declare(ptr %8, !357, !DIExpression(), !354)
    #dbg_declare(ptr %9, !358, !DIExpression(), !354)
  %10 = load ptr, ptr %5, align 8, !dbg !354
  %11 = load i32, ptr %7, align 4, !dbg !354
  %12 = load i32, ptr %6, align 4, !dbg !354
  %13 = call i32 asm sideeffect "1:lwarx $0, 0, $1;cmpw  0, $0, $3;bne-  2f;stwcx. $2, 0, $1;bne-  1b;2:", "=&r,r,r,r,~{memory},~{cc}"(ptr %10, i32 %11, i32 %12) #6, !dbg !354, !srcloc !359
  store i32 %13, ptr %9, align 4, !dbg !354
  %14 = load i32, ptr %9, align 4, !dbg !354
  %15 = load ptr, ptr %8, align 8, !dbg !354
  store i32 %14, ptr %15, align 4, !dbg !354
  %16 = load i32, ptr %9, align 4, !dbg !354
  %17 = load i32, ptr %6, align 4, !dbg !354
  %18 = icmp eq i32 %16, %17, !dbg !354
  ret i1 %18, !dbg !354
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i32 @ck_pr_faa_uint(ptr noundef %0, i32 noundef zeroext %1) #0 !dbg !360 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !363, !DIExpression(), !364)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !365, !DIExpression(), !364)
    #dbg_declare(ptr %5, !366, !DIExpression(), !364)
    #dbg_declare(ptr %6, !367, !DIExpression(), !364)
  %7 = load ptr, ptr %3, align 8, !dbg !364
  %8 = load i32, ptr %4, align 4, !dbg !364
  %9 = call { i32, i32 } asm sideeffect "1:lwarx $0, 0, $2;add $1, $3, $0;stwcx. $1, 0, $2;bne-  1b;", "=&r,=&r,r,r,~{memory},~{cc}"(ptr %7, i32 %8) #6, !dbg !364, !srcloc !368
  %10 = extractvalue { i32, i32 } %9, 0, !dbg !364
  %11 = extractvalue { i32, i32 } %9, 1, !dbg !364
  store i32 %10, ptr %5, align 4, !dbg !364
  store i32 %11, ptr %6, align 4, !dbg !364
  %12 = load i32, ptr %5, align 4, !dbg !364
  ret i32 %12, !dbg !364
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_load() #0 !dbg !369 {
  call void @ck_pr_fence_strict_load(), !dbg !373
  ret void, !dbg !373
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_stall() #0 !dbg !374 {
  call void asm sideeffect "or 1, 1, 1;or 2, 2, 2;", "~{memory}"() #6, !dbg !375, !srcloc !376
  ret void, !dbg !377
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef zeroext %1) #0 !dbg !378 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !381, !DIExpression(), !382)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !383, !DIExpression(), !382)
  %5 = load ptr, ptr %3, align 8, !dbg !382
  %6 = load i32, ptr %4, align 4, !dbg !382
  call void asm sideeffect "stw${0:U}${0:X} $1, $0", "=*m,r,~{memory}"(ptr elementtype(i32) %5, i32 %6) #6, !dbg !382, !srcloc !384
  ret void, !dbg !382
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_lock() #0 !dbg !385 {
  call void @ck_pr_fence_strict_lock(), !dbg !386
  ret void, !dbg !386
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_load() #0 !dbg !387 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !388, !srcloc !389
  ret void, !dbg !388
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_lock() #0 !dbg !390 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !391, !srcloc !392
  ret void, !dbg !391
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_unlock() #0 !dbg !393 {
  call void @ck_pr_fence_strict_unlock(), !dbg !394
  ret void, !dbg !394
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_unlock() #0 !dbg !395 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !396, !srcloc !397
  ret void, !dbg !396
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_barrier() #0 !dbg !398 {
  call void asm sideeffect "", "~{memory}"() #6, !dbg !400, !srcloc !401
  ret void, !dbg !402
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #2 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #4 = { allocsize(0) }
attributes #5 = { noreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!58, !59, !60, !61, !62, !63, !64}
!llvm.ident = !{!65}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 10, type: !14, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !21, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/anderson.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "3e8b6a5b525882d6b2763da0001a63b2")
!4 = !{!5, !6, !14, !12, !15, !18, !20}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
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
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !12)
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!21 = !{!0, !22, !24, !30, !35, !41, !56}
!22 = !DIGlobalVariableExpression(var: !23, expr: !DIExpression())
!23 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 10, type: !14, isLocal: false, isDefinition: true)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(scope: null, file: !3, line: 55, type: !26, isLocal: true, isDefinition: true)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 248, elements: !28)
!27 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!28 = !{!29}
!29 = !DISubrange(count: 31)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !3, line: 55, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 200, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 25)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(scope: null, file: !3, line: 55, type: !37, isLocal: true, isDefinition: true)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !38, size: 40, elements: !39)
!38 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !27)
!39 = !{!40}
!40 = !DISubrange(count: 5)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(name: "lock", scope: !2, file: !3, line: 11, type: !43, isLocal: false, isDefinition: true)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_anderson_t", file: !8, line: 55, baseType: !44)
!44 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_anderson", file: !8, line: 47, size: 576, elements: !45)
!45 = !{!46, !48, !49, !50, !51, !55}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "slots", scope: !44, file: !8, line: 48, baseType: !47, size: 64)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !44, file: !8, line: 49, baseType: !12, size: 32, offset: 64)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "wrap", scope: !44, file: !8, line: 50, baseType: !12, size: 32, offset: 96)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "mask", scope: !44, file: !8, line: 51, baseType: !12, size: 32, offset: 128)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !44, file: !8, line: 52, baseType: !52, size: 352, offset: 160)
!52 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 352, elements: !53)
!53 = !{!54}
!54 = !DISubrange(count: 44)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !44, file: !8, line: 53, baseType: !12, size: 32, offset: 512)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "slots", scope: !2, file: !3, line: 12, type: !6, isLocal: false, isDefinition: true)
!58 = !{i32 7, !"Dwarf Version", i32 5}
!59 = !{i32 2, !"Debug Info Version", i32 3}
!60 = !{i32 1, !"wchar_size", i32 4}
!61 = !{i32 8, !"PIC Level", i32 2}
!62 = !{i32 7, !"PIE Level", i32 2}
!63 = !{i32 7, !"uwtable", i32 2}
!64 = !{i32 7, !"frame-pointer", i32 2}
!65 = !{!"Homebrew clang version 22.1.8"}
!66 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 14, type: !67, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !69)
!67 = !DISubroutineType(types: !68)
!68 = !{!5, !5}
!69 = !{}
!70 = !DILocalVariable(name: "arg", arg: 1, scope: !66, file: !3, line: 14, type: !5)
!71 = !DILocation(line: 14, column: 17, scope: !66)
!72 = !DILocalVariable(name: "my_slot", scope: !66, file: !3, line: 16, type: !6)
!73 = !DILocation(line: 16, column: 36, scope: !66)
!74 = !DILocation(line: 17, column: 5, scope: !66)
!75 = !DILocation(line: 19, column: 6, scope: !66)
!76 = !DILocation(line: 20, column: 6, scope: !66)
!77 = !DILocation(line: 22, column: 40, scope: !66)
!78 = !DILocation(line: 22, column: 5, scope: !66)
!79 = !DILocation(line: 23, column: 5, scope: !66)
!80 = distinct !DISubprogram(name: "ck_spinlock_anderson_lock", scope: !8, file: !8, line: 103, type: !81, scopeLine: 105, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !69)
!81 = !DISubroutineType(types: !82)
!82 = !{null, !83, !84}
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!85 = !DILocalVariable(name: "lock", arg: 1, scope: !80, file: !8, line: 103, type: !83)
!86 = !DILocation(line: 103, column: 56, scope: !80)
!87 = !DILocalVariable(name: "slot", arg: 2, scope: !80, file: !8, line: 104, type: !84)
!88 = !DILocation(line: 104, column: 42, scope: !80)
!89 = !DILocalVariable(name: "position", scope: !80, file: !8, line: 106, type: !12)
!90 = !DILocation(line: 106, column: 15, scope: !80)
!91 = !DILocalVariable(name: "next", scope: !80, file: !8, line: 106, type: !12)
!92 = !DILocation(line: 106, column: 25, scope: !80)
!93 = !DILocalVariable(name: "count", scope: !80, file: !8, line: 107, type: !12)
!94 = !DILocation(line: 107, column: 15, scope: !80)
!95 = !DILocation(line: 107, column: 23, scope: !80)
!96 = !DILocation(line: 107, column: 29, scope: !80)
!97 = !DILocation(line: 114, column: 6, scope: !98)
!98 = distinct !DILexicalBlock(scope: !80, file: !8, line: 114, column: 6)
!99 = !DILocation(line: 114, column: 12, scope: !98)
!100 = !DILocation(line: 114, column: 17, scope: !98)
!101 = !DILocation(line: 115, column: 31, scope: !102)
!102 = distinct !DILexicalBlock(scope: !98, file: !8, line: 114, column: 23)
!103 = !DILocation(line: 115, column: 37, scope: !102)
!104 = !DILocation(line: 115, column: 14, scope: !102)
!105 = !DILocation(line: 115, column: 12, scope: !102)
!106 = !DILocation(line: 117, column: 3, scope: !102)
!107 = !DILocation(line: 118, column: 8, scope: !108)
!108 = distinct !DILexicalBlock(scope: !109, file: !8, line: 118, column: 8)
!109 = distinct !DILexicalBlock(scope: !102, file: !8, line: 117, column: 6)
!110 = !DILocation(line: 118, column: 17, scope: !108)
!111 = !DILocation(line: 119, column: 12, scope: !108)
!112 = !DILocation(line: 119, column: 18, scope: !108)
!113 = !DILocation(line: 119, column: 10, scope: !108)
!114 = !DILocation(line: 119, column: 5, scope: !108)
!115 = !DILocation(line: 121, column: 12, scope: !108)
!116 = !DILocation(line: 121, column: 21, scope: !108)
!117 = !DILocation(line: 121, column: 10, scope: !108)
!118 = !DILocation(line: 122, column: 3, scope: !109)
!119 = !DILocation(line: 122, column: 34, scope: !102)
!120 = !DILocation(line: 122, column: 40, scope: !102)
!121 = !DILocation(line: 122, column: 46, scope: !102)
!122 = !DILocation(line: 123, column: 12, scope: !102)
!123 = !DILocation(line: 122, column: 12, scope: !102)
!124 = !DILocation(line: 123, column: 29, scope: !102)
!125 = distinct !{!125, !106, !126, !127}
!126 = !DILocation(line: 123, column: 37, scope: !102)
!127 = !{!"llvm.loop.mustprogress"}
!128 = !DILocation(line: 125, column: 15, scope: !102)
!129 = !DILocation(line: 125, column: 12, scope: !102)
!130 = !DILocation(line: 126, column: 2, scope: !102)
!131 = !DILocation(line: 127, column: 30, scope: !132)
!132 = distinct !DILexicalBlock(scope: !98, file: !8, line: 126, column: 9)
!133 = !DILocation(line: 127, column: 36, scope: !132)
!134 = !DILocation(line: 127, column: 14, scope: !132)
!135 = !DILocation(line: 127, column: 12, scope: !132)
!136 = !DILocation(line: 128, column: 15, scope: !132)
!137 = !DILocation(line: 128, column: 21, scope: !132)
!138 = !DILocation(line: 128, column: 12, scope: !132)
!139 = !DILocation(line: 132, column: 2, scope: !80)
!140 = !DILocation(line: 138, column: 2, scope: !80)
!141 = !DILocation(line: 138, column: 26, scope: !80)
!142 = !DILocation(line: 138, column: 32, scope: !80)
!143 = !DILocation(line: 138, column: 38, scope: !80)
!144 = !DILocation(line: 138, column: 48, scope: !80)
!145 = !DILocation(line: 138, column: 9, scope: !80)
!146 = !DILocation(line: 138, column: 56, scope: !80)
!147 = !DILocation(line: 139, column: 3, scope: !80)
!148 = distinct !{!148, !140, !149, !127}
!149 = !DILocation(line: 139, column: 15, scope: !80)
!150 = !DILocation(line: 142, column: 20, scope: !80)
!151 = !DILocation(line: 142, column: 26, scope: !80)
!152 = !DILocation(line: 142, column: 32, scope: !80)
!153 = !DILocation(line: 142, column: 42, scope: !80)
!154 = !DILocation(line: 142, column: 2, scope: !80)
!155 = !DILocation(line: 143, column: 2, scope: !80)
!156 = !DILocation(line: 145, column: 10, scope: !80)
!157 = !DILocation(line: 145, column: 16, scope: !80)
!158 = !DILocation(line: 145, column: 24, scope: !80)
!159 = !DILocation(line: 145, column: 22, scope: !80)
!160 = !DILocation(line: 145, column: 3, scope: !80)
!161 = !DILocation(line: 145, column: 8, scope: !80)
!162 = !DILocation(line: 146, column: 2, scope: !80)
!163 = distinct !DISubprogram(name: "ck_spinlock_anderson_unlock", scope: !8, file: !8, line: 150, type: !164, scopeLine: 152, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !69)
!164 = !DISubroutineType(types: !165)
!165 = !{null, !83, !47}
!166 = !DILocalVariable(name: "lock", arg: 1, scope: !163, file: !8, line: 150, type: !83)
!167 = !DILocation(line: 150, column: 58, scope: !163)
!168 = !DILocalVariable(name: "slot", arg: 2, scope: !163, file: !8, line: 151, type: !47)
!169 = !DILocation(line: 151, column: 41, scope: !163)
!170 = !DILocalVariable(name: "position", scope: !163, file: !8, line: 153, type: !12)
!171 = !DILocation(line: 153, column: 15, scope: !163)
!172 = !DILocation(line: 155, column: 2, scope: !163)
!173 = !DILocation(line: 158, column: 6, scope: !174)
!174 = distinct !DILexicalBlock(scope: !163, file: !8, line: 158, column: 6)
!175 = !DILocation(line: 158, column: 12, scope: !174)
!176 = !DILocation(line: 158, column: 17, scope: !174)
!177 = !DILocation(line: 159, column: 15, scope: !174)
!178 = !DILocation(line: 159, column: 21, scope: !174)
!179 = !DILocation(line: 159, column: 30, scope: !174)
!180 = !DILocation(line: 159, column: 37, scope: !174)
!181 = !DILocation(line: 159, column: 43, scope: !174)
!182 = !DILocation(line: 159, column: 35, scope: !174)
!183 = !DILocation(line: 159, column: 12, scope: !174)
!184 = !DILocation(line: 159, column: 3, scope: !174)
!185 = !DILocation(line: 161, column: 15, scope: !174)
!186 = !DILocation(line: 161, column: 21, scope: !174)
!187 = !DILocation(line: 161, column: 30, scope: !174)
!188 = !DILocation(line: 161, column: 37, scope: !174)
!189 = !DILocation(line: 161, column: 43, scope: !174)
!190 = !DILocation(line: 161, column: 35, scope: !174)
!191 = !DILocation(line: 161, column: 12, scope: !174)
!192 = !DILocation(line: 163, column: 20, scope: !163)
!193 = !DILocation(line: 163, column: 26, scope: !163)
!194 = !DILocation(line: 163, column: 32, scope: !163)
!195 = !DILocation(line: 163, column: 42, scope: !163)
!196 = !DILocation(line: 163, column: 2, scope: !163)
!197 = !DILocation(line: 164, column: 2, scope: !163)
!198 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 26, type: !199, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !69)
!199 = !DISubroutineType(types: !200)
!200 = !{!14}
!201 = !DILocalVariable(name: "threads", scope: !198, file: !3, line: 28, type: !202)
!202 = !DICompositeType(tag: DW_TAG_array_type, baseType: !203, size: 192, elements: !205)
!203 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !204, line: 2, baseType: !5)
!204 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!205 = !{!206}
!206 = !DISubrange(count: 3)
!207 = !DILocation(line: 28, column: 15, scope: !198)
!208 = !DILocalVariable(name: "i", scope: !198, file: !3, line: 29, type: !14)
!209 = !DILocation(line: 29, column: 9, scope: !198)
!210 = !DILocation(line: 31, column: 46, scope: !198)
!211 = !DILocation(line: 31, column: 11, scope: !198)
!212 = !DILocation(line: 32, column: 9, scope: !213)
!213 = distinct !DILexicalBlock(scope: !198, file: !3, line: 32, column: 9)
!214 = !DILocation(line: 32, column: 15, scope: !213)
!215 = !DILocation(line: 34, column: 9, scope: !216)
!216 = distinct !DILexicalBlock(scope: !213, file: !3, line: 33, column: 5)
!217 = !DILocation(line: 37, column: 38, scope: !198)
!218 = !DILocation(line: 37, column: 5, scope: !198)
!219 = !DILocation(line: 39, column: 12, scope: !220)
!220 = distinct !DILexicalBlock(scope: !198, file: !3, line: 39, column: 5)
!221 = !DILocation(line: 39, column: 10, scope: !220)
!222 = !DILocation(line: 39, column: 17, scope: !223)
!223 = distinct !DILexicalBlock(scope: !220, file: !3, line: 39, column: 5)
!224 = !DILocation(line: 39, column: 19, scope: !223)
!225 = !DILocation(line: 39, column: 5, scope: !220)
!226 = !DILocation(line: 41, column: 37, scope: !227)
!227 = distinct !DILexicalBlock(scope: !228, file: !3, line: 41, column: 13)
!228 = distinct !DILexicalBlock(scope: !223, file: !3, line: 40, column: 5)
!229 = !DILocation(line: 41, column: 29, scope: !227)
!230 = !DILocation(line: 41, column: 13, scope: !227)
!231 = !DILocation(line: 41, column: 58, scope: !227)
!232 = !DILocation(line: 43, column: 13, scope: !233)
!233 = distinct !DILexicalBlock(scope: !227, file: !3, line: 42, column: 9)
!234 = !DILocation(line: 45, column: 5, scope: !228)
!235 = !DILocation(line: 39, column: 32, scope: !223)
!236 = !DILocation(line: 39, column: 5, scope: !223)
!237 = distinct !{!237, !225, !238, !127}
!238 = !DILocation(line: 45, column: 5, scope: !220)
!239 = !DILocation(line: 47, column: 12, scope: !240)
!240 = distinct !DILexicalBlock(scope: !198, file: !3, line: 47, column: 5)
!241 = !DILocation(line: 47, column: 10, scope: !240)
!242 = !DILocation(line: 47, column: 17, scope: !243)
!243 = distinct !DILexicalBlock(scope: !240, file: !3, line: 47, column: 5)
!244 = !DILocation(line: 47, column: 19, scope: !243)
!245 = !DILocation(line: 47, column: 5, scope: !240)
!246 = !DILocation(line: 49, column: 34, scope: !247)
!247 = distinct !DILexicalBlock(scope: !248, file: !3, line: 49, column: 13)
!248 = distinct !DILexicalBlock(scope: !243, file: !3, line: 48, column: 5)
!249 = !DILocation(line: 49, column: 26, scope: !247)
!250 = !DILocation(line: 49, column: 13, scope: !247)
!251 = !DILocation(line: 49, column: 44, scope: !247)
!252 = !DILocation(line: 51, column: 13, scope: !253)
!253 = distinct !DILexicalBlock(scope: !247, file: !3, line: 50, column: 9)
!254 = !DILocation(line: 53, column: 5, scope: !248)
!255 = !DILocation(line: 47, column: 32, scope: !243)
!256 = !DILocation(line: 47, column: 5, scope: !243)
!257 = distinct !{!257, !245, !258, !127}
!258 = !DILocation(line: 53, column: 5, scope: !240)
!259 = !DILocation(line: 55, column: 12, scope: !260)
!260 = distinct !DILexicalBlock(scope: !261, file: !3, line: 55, column: 5)
!261 = distinct !DILexicalBlock(scope: !198, file: !3, line: 55, column: 5)
!262 = !DILocation(line: 55, column: 14, scope: !260)
!263 = !DILocation(line: 55, column: 26, scope: !260)
!264 = !DILocation(line: 55, column: 29, scope: !260)
!265 = !DILocation(line: 55, column: 31, scope: !260)
!266 = !DILocation(line: 55, column: 5, scope: !260)
!267 = !DILocation(line: 57, column: 10, scope: !198)
!268 = !DILocation(line: 57, column: 5, scope: !198)
!269 = !DILocation(line: 59, column: 5, scope: !198)
!270 = distinct !DISubprogram(name: "ck_spinlock_anderson_init", scope: !8, file: !8, line: 58, type: !271, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !69)
!271 = !DISubroutineType(types: !272)
!272 = !{null, !83, !47, !12}
!273 = !DILocalVariable(name: "lock", arg: 1, scope: !270, file: !8, line: 58, type: !83)
!274 = !DILocation(line: 58, column: 56, scope: !270)
!275 = !DILocalVariable(name: "slots", arg: 2, scope: !270, file: !8, line: 59, type: !47)
!276 = !DILocation(line: 59, column: 41, scope: !270)
!277 = !DILocalVariable(name: "count", arg: 3, scope: !270, file: !8, line: 60, type: !12)
!278 = !DILocation(line: 60, column: 18, scope: !270)
!279 = !DILocalVariable(name: "i", scope: !270, file: !8, line: 62, type: !12)
!280 = !DILocation(line: 62, column: 15, scope: !270)
!281 = !DILocation(line: 64, column: 2, scope: !270)
!282 = !DILocation(line: 64, column: 11, scope: !270)
!283 = !DILocation(line: 64, column: 18, scope: !270)
!284 = !DILocation(line: 65, column: 2, scope: !270)
!285 = !DILocation(line: 65, column: 11, scope: !270)
!286 = !DILocation(line: 65, column: 20, scope: !270)
!287 = !DILocation(line: 66, column: 9, scope: !288)
!288 = distinct !DILexicalBlock(scope: !270, file: !8, line: 66, column: 2)
!289 = !DILocation(line: 66, column: 7, scope: !288)
!290 = !DILocation(line: 66, column: 14, scope: !291)
!291 = distinct !DILexicalBlock(scope: !288, file: !8, line: 66, column: 2)
!292 = !DILocation(line: 66, column: 18, scope: !291)
!293 = !DILocation(line: 66, column: 16, scope: !291)
!294 = !DILocation(line: 66, column: 2, scope: !288)
!295 = !DILocation(line: 67, column: 3, scope: !296)
!296 = distinct !DILexicalBlock(scope: !291, file: !8, line: 66, column: 30)
!297 = !DILocation(line: 67, column: 9, scope: !296)
!298 = !DILocation(line: 67, column: 12, scope: !296)
!299 = !DILocation(line: 67, column: 19, scope: !296)
!300 = !DILocation(line: 68, column: 23, scope: !296)
!301 = !DILocation(line: 68, column: 3, scope: !296)
!302 = !DILocation(line: 68, column: 9, scope: !296)
!303 = !DILocation(line: 68, column: 12, scope: !296)
!304 = !DILocation(line: 68, column: 21, scope: !296)
!305 = !DILocation(line: 69, column: 2, scope: !296)
!306 = !DILocation(line: 66, column: 26, scope: !291)
!307 = !DILocation(line: 66, column: 2, scope: !291)
!308 = distinct !{!308, !294, !309, !127}
!309 = !DILocation(line: 69, column: 2, scope: !288)
!310 = !DILocation(line: 71, column: 16, scope: !270)
!311 = !DILocation(line: 71, column: 2, scope: !270)
!312 = !DILocation(line: 71, column: 8, scope: !270)
!313 = !DILocation(line: 71, column: 14, scope: !270)
!314 = !DILocation(line: 72, column: 16, scope: !270)
!315 = !DILocation(line: 72, column: 2, scope: !270)
!316 = !DILocation(line: 72, column: 8, scope: !270)
!317 = !DILocation(line: 72, column: 14, scope: !270)
!318 = !DILocation(line: 73, column: 15, scope: !270)
!319 = !DILocation(line: 73, column: 21, scope: !270)
!320 = !DILocation(line: 73, column: 2, scope: !270)
!321 = !DILocation(line: 73, column: 8, scope: !270)
!322 = !DILocation(line: 73, column: 13, scope: !270)
!323 = !DILocation(line: 74, column: 2, scope: !270)
!324 = !DILocation(line: 74, column: 8, scope: !270)
!325 = !DILocation(line: 74, column: 13, scope: !270)
!326 = !DILocation(line: 81, column: 6, scope: !327)
!327 = distinct !DILexicalBlock(scope: !270, file: !8, line: 81, column: 6)
!328 = !DILocation(line: 81, column: 15, scope: !327)
!329 = !DILocation(line: 81, column: 21, scope: !327)
!330 = !DILocation(line: 81, column: 12, scope: !327)
!331 = !DILocation(line: 82, column: 28, scope: !327)
!332 = !DILocation(line: 82, column: 26, scope: !327)
!333 = !DILocation(line: 82, column: 35, scope: !327)
!334 = !DILocation(line: 82, column: 3, scope: !327)
!335 = !DILocation(line: 82, column: 9, scope: !327)
!336 = !DILocation(line: 82, column: 14, scope: !327)
!337 = !DILocation(line: 84, column: 3, scope: !327)
!338 = !DILocation(line: 84, column: 9, scope: !327)
!339 = !DILocation(line: 84, column: 14, scope: !327)
!340 = !DILocation(line: 86, column: 2, scope: !270)
!341 = !DILocation(line: 87, column: 2, scope: !270)
!342 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !343, file: !343, line: 111, type: !344, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !69)
!343 = !DIFile(filename: "../ck/include/gcc/ppc64/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "8952bb109540f13c2aa63ce3890cafa9")
!344 = !DISubroutineType(types: !345)
!345 = !{!12, !18}
!346 = !DILocalVariable(name: "target", arg: 1, scope: !342, file: !343, line: 111, type: !18)
!347 = !DILocation(line: 111, column: 1, scope: !342)
!348 = !DILocalVariable(name: "r", scope: !342, file: !343, line: 111, type: !12)
!349 = !{i64 2147586470}
!350 = distinct !DISubprogram(name: "ck_pr_cas_uint_value", scope: !343, file: !343, line: 278, type: !351, scopeLine: 278, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !69)
!351 = !DISubroutineType(types: !352)
!352 = !{!15, !20, !12, !12, !20}
!353 = !DILocalVariable(name: "target", arg: 1, scope: !350, file: !343, line: 278, type: !20)
!354 = !DILocation(line: 278, column: 1, scope: !350)
!355 = !DILocalVariable(name: "compare", arg: 2, scope: !350, file: !343, line: 278, type: !12)
!356 = !DILocalVariable(name: "set", arg: 3, scope: !350, file: !343, line: 278, type: !12)
!357 = !DILocalVariable(name: "value", arg: 4, scope: !350, file: !343, line: 278, type: !20)
!358 = !DILocalVariable(name: "previous", scope: !350, file: !343, line: 278, type: !12)
!359 = !{i64 2147593173}
!360 = distinct !DISubprogram(name: "ck_pr_faa_uint", scope: !343, file: !343, line: 422, type: !361, scopeLine: 422, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !69)
!361 = !DISubroutineType(types: !362)
!362 = !{!12, !20, !12}
!363 = !DILocalVariable(name: "target", arg: 1, scope: !360, file: !343, line: 422, type: !20)
!364 = !DILocation(line: 422, column: 1, scope: !360)
!365 = !DILocalVariable(name: "delta", arg: 2, scope: !360, file: !343, line: 422, type: !12)
!366 = !DILocalVariable(name: "previous", scope: !360, file: !343, line: 422, type: !12)
!367 = !DILocalVariable(name: "r", scope: !360, file: !343, line: 422, type: !12)
!368 = !{i64 2147622342}
!369 = distinct !DISubprogram(name: "ck_pr_fence_load", scope: !370, file: !370, line: 116, type: !371, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!370 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!371 = !DISubroutineType(types: !372)
!372 = !{null}
!373 = !DILocation(line: 116, column: 1, scope: !369)
!374 = distinct !DISubprogram(name: "ck_pr_stall", scope: !343, file: !343, line: 54, type: !371, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!375 = !DILocation(line: 57, column: 2, scope: !374)
!376 = !{i64 85466}
!377 = !DILocation(line: 59, column: 2, scope: !374)
!378 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !343, file: !343, line: 141, type: !379, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !69)
!379 = !DISubroutineType(types: !380)
!380 = !{null, !20, !12}
!381 = !DILocalVariable(name: "target", arg: 1, scope: !378, file: !343, line: 141, type: !20)
!382 = !DILocation(line: 141, column: 1, scope: !378)
!383 = !DILocalVariable(name: "v", arg: 2, scope: !378, file: !343, line: 141, type: !12)
!384 = !{i64 2147590177}
!385 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !370, file: !370, line: 122, type: !371, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!386 = !DILocation(line: 122, column: 1, scope: !385)
!387 = distinct !DISubprogram(name: "ck_pr_fence_strict_load", scope: !343, file: !343, line: 80, type: !371, scopeLine: 80, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!388 = !DILocation(line: 80, column: 1, scope: !387)
!389 = !{i64 2147582699}
!390 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !343, file: !343, line: 86, type: !371, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!391 = !DILocation(line: 86, column: 1, scope: !390)
!392 = !{i64 2147583899}
!393 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !370, file: !370, line: 123, type: !371, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!394 = !DILocation(line: 123, column: 1, scope: !393)
!395 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !343, file: !343, line: 87, type: !371, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!396 = !DILocation(line: 87, column: 1, scope: !395)
!397 = !{i64 2147584096}
!398 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !399, file: !399, line: 37, type: !371, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!399 = !DIFile(filename: "../ck/include/gcc/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!400 = !DILocation(line: 40, column: 2, scope: !398)
!401 = !{i64 141167}
!402 = !DILocation(line: 41, column: 2, scope: !398)
