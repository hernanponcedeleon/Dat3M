; ModuleID = 'benchmarks/miscellaneous/pthread.c'
source_filename = "benchmarks/miscellaneous/pthread.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%union.pthread_cond_t = type { %struct.__pthread_cond_s }
%struct.__pthread_cond_s = type { %union.__atomic_wide_counter, %union.__atomic_wide_counter, [2 x i32], i32, i32, [2 x i32], i32, i32 }
%union.__atomic_wide_counter = type { i64 }
%union.pthread_attr_t = type { i64, [48 x i8] }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_condattr_t = type { i32 }
%struct.timespec = type { i64, i64 }
%union.pthread_rwlockattr_t = type { i64 }
%union.pthread_rwlock_t = type { %struct.__pthread_rwlock_arch_t }
%struct.__pthread_rwlock_arch_t = type { i32, i32, i32, i32, i32, i32, i32, i32, i8, [7 x i8], i64, i32 }

@.str = private unnamed_addr constant [12 x i8] c"status == 0\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [35 x i8] c"benchmarks/miscellaneous/pthread.c\00", align 1, !dbg !7
@__PRETTY_FUNCTION__.thread_create = private unnamed_addr constant [51 x i8] c"pthread_t thread_create(void *(*)(void *), void *)\00", align 1, !dbg !12
@__PRETTY_FUNCTION__.thread_join = private unnamed_addr constant [29 x i8] c"void *thread_join(pthread_t)\00", align 1, !dbg !18
@__PRETTY_FUNCTION__.mutex_init = private unnamed_addr constant [50 x i8] c"void mutex_init(pthread_mutex_t *, int, int, int)\00", align 1, !dbg !23
@__PRETTY_FUNCTION__.mutex_destroy = private unnamed_addr constant [38 x i8] c"void mutex_destroy(pthread_mutex_t *)\00", align 1, !dbg !28
@__PRETTY_FUNCTION__.mutex_lock = private unnamed_addr constant [35 x i8] c"void mutex_lock(pthread_mutex_t *)\00", align 1, !dbg !33
@__PRETTY_FUNCTION__.mutex_unlock = private unnamed_addr constant [37 x i8] c"void mutex_unlock(pthread_mutex_t *)\00", align 1, !dbg !36
@.str.2 = private unnamed_addr constant [9 x i8] c"!success\00", align 1, !dbg !41
@__PRETTY_FUNCTION__.mutex_test = private unnamed_addr constant [18 x i8] c"void mutex_test()\00", align 1, !dbg !46
@.str.3 = private unnamed_addr constant [8 x i8] c"success\00", align 1, !dbg !51
@__PRETTY_FUNCTION__.cond_init = private unnamed_addr constant [33 x i8] c"void cond_init(pthread_cond_t *)\00", align 1, !dbg !56
@__PRETTY_FUNCTION__.cond_destroy = private unnamed_addr constant [36 x i8] c"void cond_destroy(pthread_cond_t *)\00", align 1, !dbg !61
@__PRETTY_FUNCTION__.cond_signal = private unnamed_addr constant [35 x i8] c"void cond_signal(pthread_cond_t *)\00", align 1, !dbg !66
@__PRETTY_FUNCTION__.cond_broadcast = private unnamed_addr constant [38 x i8] c"void cond_broadcast(pthread_cond_t *)\00", align 1, !dbg !68
@phase = dso_local global i32 0, align 4, !dbg !70
@cond_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !191
@cond = dso_local global %union.pthread_cond_t zeroinitializer, align 8, !dbg !220
@.str.4 = private unnamed_addr constant [18 x i8] c"result == message\00", align 1, !dbg !103
@__PRETTY_FUNCTION__.cond_test = private unnamed_addr constant [17 x i8] c"void cond_test()\00", align 1, !dbg !106
@__PRETTY_FUNCTION__.rwlock_init = private unnamed_addr constant [42 x i8] c"void rwlock_init(pthread_rwlock_t *, int)\00", align 1, !dbg !111
@__PRETTY_FUNCTION__.rwlock_destroy = private unnamed_addr constant [40 x i8] c"void rwlock_destroy(pthread_rwlock_t *)\00", align 1, !dbg !116
@__PRETTY_FUNCTION__.rwlock_wrlock = private unnamed_addr constant [39 x i8] c"void rwlock_wrlock(pthread_rwlock_t *)\00", align 1, !dbg !121
@__PRETTY_FUNCTION__.rwlock_rdlock = private unnamed_addr constant [39 x i8] c"void rwlock_rdlock(pthread_rwlock_t *)\00", align 1, !dbg !126
@__PRETTY_FUNCTION__.rwlock_unlock = private unnamed_addr constant [39 x i8] c"void rwlock_unlock(pthread_rwlock_t *)\00", align 1, !dbg !128
@__PRETTY_FUNCTION__.rwlock_test = private unnamed_addr constant [19 x i8] c"void rwlock_test()\00", align 1, !dbg !130
@latest_thread = dso_local global i64 0, align 8, !dbg !256
@local_data = dso_local global i32 0, align 4, !dbg !260
@__PRETTY_FUNCTION__.key_worker = private unnamed_addr constant [25 x i8] c"void *key_worker(void *)\00", align 1, !dbg !135
@.str.5 = private unnamed_addr constant [28 x i8] c"my_local_data == &my_secret\00", align 1, !dbg !140
@__PRETTY_FUNCTION__.key_test = private unnamed_addr constant [16 x i8] c"void key_test()\00", align 1, !dbg !145
@.str.6 = private unnamed_addr constant [37 x i8] c"pthread_equal(latest_thread, worker)\00", align 1, !dbg !150
@__PRETTY_FUNCTION__.detach_test_detach = private unnamed_addr constant [33 x i8] c"void *detach_test_detach(void *)\00", align 1, !dbg !153
@.str.7 = private unnamed_addr constant [12 x i8] c"status != 0\00", align 1, !dbg !155
@__PRETTY_FUNCTION__.detach_test_attr = private unnamed_addr constant [31 x i8] c"void *detach_test_attr(void *)\00", align 1, !dbg !157
@.str.8 = private unnamed_addr constant [54 x i8] c"status == 0 && detachstate == PTHREAD_CREATE_JOINABLE\00", align 1, !dbg !162
@.str.9 = private unnamed_addr constant [54 x i8] c"status == 0 && detachstate == PTHREAD_CREATE_DETACHED\00", align 1, !dbg !167
@once0 = dso_local global i32 0, align 4, !dbg !169
@once1 = dso_local global i32 0, align 4, !dbg !174
@once_calls = dso_local global i32 0, align 4, !dbg !263
@once_value = dso_local global i32 0, align 4, !dbg !265
@__PRETTY_FUNCTION__.once_worker = private unnamed_addr constant [26 x i8] c"void *once_worker(void *)\00", align 1, !dbg !176
@.str.10 = private unnamed_addr constant [17 x i8] c"once_value == 42\00", align 1, !dbg !181
@.str.11 = private unnamed_addr constant [16 x i8] c"once_calls == 1\00", align 1, !dbg !184
@__PRETTY_FUNCTION__.once_test = private unnamed_addr constant [17 x i8] c"void once_test()\00", align 1, !dbg !187
@.str.12 = private unnamed_addr constant [16 x i8] c"once_calls == 2\00", align 1, !dbg !189

; Function Attrs: noinline nounwind uwtable
define dso_local i64 @thread_create(ptr noundef %0, ptr noundef %1) #0 !dbg !275 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i64, align 8
  %6 = alloca %union.pthread_attr_t, align 8
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !282, !DIExpression(), !283)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !284, !DIExpression(), !285)
    #dbg_declare(ptr %5, !286, !DIExpression(), !287)
    #dbg_declare(ptr %6, !288, !DIExpression(), !297)
  %8 = call i32 @pthread_attr_init(ptr noundef %6) #5, !dbg !298
    #dbg_declare(ptr %7, !299, !DIExpression(), !300)
  %9 = load ptr, ptr %3, align 8, !dbg !301
  %10 = load ptr, ptr %4, align 8, !dbg !302
  %11 = call i32 @pthread_create(ptr noundef %5, ptr noundef %6, ptr noundef %9, ptr noundef %10) #5, !dbg !303
  store i32 %11, ptr %7, align 4, !dbg !300
  %12 = load i32, ptr %7, align 4, !dbg !304
  %13 = icmp eq i32 %12, 0, !dbg !304
  br i1 %13, label %14, label %15, !dbg !307

14:                                               ; preds = %2
  br label %16, !dbg !307

15:                                               ; preds = %2
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 18, ptr noundef @__PRETTY_FUNCTION__.thread_create) #6, !dbg !304
  unreachable, !dbg !304

16:                                               ; preds = %14
  %17 = call i32 @pthread_attr_destroy(ptr noundef %6) #5, !dbg !308
  %18 = load i64, ptr %5, align 8, !dbg !309
  ret i64 %18, !dbg !310
}

; Function Attrs: nounwind
declare i32 @pthread_attr_init(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: cold noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

; Function Attrs: nounwind
declare i32 @pthread_attr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_join(i64 noundef %0) #0 !dbg !311 {
  %2 = alloca i64, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store i64 %0, ptr %2, align 8
    #dbg_declare(ptr %2, !314, !DIExpression(), !315)
    #dbg_declare(ptr %3, !316, !DIExpression(), !317)
    #dbg_declare(ptr %4, !318, !DIExpression(), !319)
  %5 = load i64, ptr %2, align 8, !dbg !320
  %6 = call i32 @pthread_join(i64 noundef %5, ptr noundef %3), !dbg !321
  store i32 %6, ptr %4, align 4, !dbg !319
  %7 = load i32, ptr %4, align 4, !dbg !322
  %8 = icmp eq i32 %7, 0, !dbg !322
  br i1 %8, label %9, label %10, !dbg !325

9:                                                ; preds = %1
  br label %11, !dbg !325

10:                                               ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 27, ptr noundef @__PRETTY_FUNCTION__.thread_join) #6, !dbg !322
  unreachable, !dbg !322

11:                                               ; preds = %9
  %12 = load ptr, ptr %3, align 8, !dbg !326
  ret ptr %12, !dbg !327
}

declare i32 @pthread_join(i64 noundef, ptr noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_init(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) #0 !dbg !328 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca %union.pthread_mutexattr_t, align 4
  store ptr %0, ptr %5, align 8
    #dbg_declare(ptr %5, !332, !DIExpression(), !333)
  store i32 %1, ptr %6, align 4
    #dbg_declare(ptr %6, !334, !DIExpression(), !335)
  store i32 %2, ptr %7, align 4
    #dbg_declare(ptr %7, !336, !DIExpression(), !337)
  store i32 %3, ptr %8, align 4
    #dbg_declare(ptr %8, !338, !DIExpression(), !339)
    #dbg_declare(ptr %9, !340, !DIExpression(), !341)
    #dbg_declare(ptr %10, !342, !DIExpression(), !343)
    #dbg_declare(ptr %11, !344, !DIExpression(), !353)
  %12 = call i32 @pthread_mutexattr_init(ptr noundef %11) #5, !dbg !354
  store i32 %12, ptr %9, align 4, !dbg !355
  %13 = load i32, ptr %9, align 4, !dbg !356
  %14 = icmp eq i32 %13, 0, !dbg !356
  br i1 %14, label %15, label %16, !dbg !359

15:                                               ; preds = %4
  br label %17, !dbg !359

16:                                               ; preds = %4
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 47, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #6, !dbg !356
  unreachable, !dbg !356

17:                                               ; preds = %15
  %18 = load i32, ptr %6, align 4, !dbg !360
  %19 = call i32 @pthread_mutexattr_settype(ptr noundef %11, i32 noundef %18) #5, !dbg !361
  store i32 %19, ptr %9, align 4, !dbg !362
  %20 = load i32, ptr %9, align 4, !dbg !363
  %21 = icmp eq i32 %20, 0, !dbg !363
  br i1 %21, label %22, label %23, !dbg !366

22:                                               ; preds = %17
  br label %24, !dbg !366

23:                                               ; preds = %17
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 50, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #6, !dbg !363
  unreachable, !dbg !363

24:                                               ; preds = %22
  %25 = call i32 @pthread_mutexattr_gettype(ptr noundef %11, ptr noundef %10) #5, !dbg !367
  store i32 %25, ptr %9, align 4, !dbg !368
  %26 = load i32, ptr %9, align 4, !dbg !369
  %27 = icmp eq i32 %26, 0, !dbg !369
  br i1 %27, label %28, label %29, !dbg !372

28:                                               ; preds = %24
  br label %30, !dbg !372

29:                                               ; preds = %24
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 52, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #6, !dbg !369
  unreachable, !dbg !369

30:                                               ; preds = %28
  %31 = load i32, ptr %7, align 4, !dbg !373
  %32 = call i32 @pthread_mutexattr_setprotocol(ptr noundef %11, i32 noundef %31) #5, !dbg !374
  store i32 %32, ptr %9, align 4, !dbg !375
  %33 = load i32, ptr %9, align 4, !dbg !376
  %34 = icmp eq i32 %33, 0, !dbg !376
  br i1 %34, label %35, label %36, !dbg !379

35:                                               ; preds = %30
  br label %37, !dbg !379

36:                                               ; preds = %30
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 55, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #6, !dbg !376
  unreachable, !dbg !376

37:                                               ; preds = %35
  %38 = call i32 @pthread_mutexattr_getprotocol(ptr noundef %11, ptr noundef %10) #5, !dbg !380
  store i32 %38, ptr %9, align 4, !dbg !381
  %39 = load i32, ptr %9, align 4, !dbg !382
  %40 = icmp eq i32 %39, 0, !dbg !382
  br i1 %40, label %41, label %42, !dbg !385

41:                                               ; preds = %37
  br label %43, !dbg !385

42:                                               ; preds = %37
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 57, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #6, !dbg !382
  unreachable, !dbg !382

43:                                               ; preds = %41
  %44 = load i32, ptr %8, align 4, !dbg !386
  %45 = call i32 @pthread_mutexattr_setprioceiling(ptr noundef %11, i32 noundef %44) #5, !dbg !387
  store i32 %45, ptr %9, align 4, !dbg !388
  %46 = load i32, ptr %9, align 4, !dbg !389
  %47 = icmp eq i32 %46, 0, !dbg !389
  br i1 %47, label %48, label %49, !dbg !392

48:                                               ; preds = %43
  br label %50, !dbg !392

49:                                               ; preds = %43
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 60, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #6, !dbg !389
  unreachable, !dbg !389

50:                                               ; preds = %48
  %51 = call i32 @pthread_mutexattr_getprioceiling(ptr noundef %11, ptr noundef %10) #5, !dbg !393
  store i32 %51, ptr %9, align 4, !dbg !394
  %52 = load i32, ptr %9, align 4, !dbg !395
  %53 = icmp eq i32 %52, 0, !dbg !395
  br i1 %53, label %54, label %55, !dbg !398

54:                                               ; preds = %50
  br label %56, !dbg !398

55:                                               ; preds = %50
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 62, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #6, !dbg !395
  unreachable, !dbg !395

56:                                               ; preds = %54
  %57 = load ptr, ptr %5, align 8, !dbg !399
  %58 = call i32 @pthread_mutex_init(ptr noundef %57, ptr noundef %11) #5, !dbg !400
  store i32 %58, ptr %9, align 4, !dbg !401
  %59 = load i32, ptr %9, align 4, !dbg !402
  %60 = icmp eq i32 %59, 0, !dbg !402
  br i1 %60, label %61, label %62, !dbg !405

61:                                               ; preds = %56
  br label %63, !dbg !405

62:                                               ; preds = %56
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 65, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #6, !dbg !402
  unreachable, !dbg !402

63:                                               ; preds = %61
  %64 = call i32 @pthread_mutexattr_destroy(ptr noundef %11) #5, !dbg !406
  store i32 %64, ptr %9, align 4, !dbg !407
  %65 = load i32, ptr %9, align 4, !dbg !408
  %66 = icmp eq i32 %65, 0, !dbg !408
  br i1 %66, label %67, label %68, !dbg !411

67:                                               ; preds = %63
  br label %69, !dbg !411

68:                                               ; preds = %63
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 67, ptr noundef @__PRETTY_FUNCTION__.mutex_init) #6, !dbg !408
  unreachable, !dbg !408

69:                                               ; preds = %67
  ret void, !dbg !412
}

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_init(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_gettype(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_setprotocol(ptr noundef, i32 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_getprotocol(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_setprioceiling(ptr noundef, i32 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_getprioceiling(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_mutexattr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_destroy(ptr noundef %0) #0 !dbg !413 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !416, !DIExpression(), !417)
    #dbg_declare(ptr %3, !418, !DIExpression(), !419)
  %4 = load ptr, ptr %2, align 8, !dbg !420
  %5 = call i32 @pthread_mutex_destroy(ptr noundef %4) #5, !dbg !421
  store i32 %5, ptr %3, align 4, !dbg !419
  %6 = load i32, ptr %3, align 4, !dbg !422
  %7 = icmp eq i32 %6, 0, !dbg !422
  br i1 %7, label %8, label %9, !dbg !425

8:                                                ; preds = %1
  br label %10, !dbg !425

9:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 73, ptr noundef @__PRETTY_FUNCTION__.mutex_destroy) #6, !dbg !422
  unreachable, !dbg !422

10:                                               ; preds = %8
  ret void, !dbg !426
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_lock(ptr noundef %0) #0 !dbg !427 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !428, !DIExpression(), !429)
    #dbg_declare(ptr %3, !430, !DIExpression(), !431)
  %4 = load ptr, ptr %2, align 8, !dbg !432
  %5 = call i32 @pthread_mutex_lock(ptr noundef %4) #5, !dbg !433
  store i32 %5, ptr %3, align 4, !dbg !431
  %6 = load i32, ptr %3, align 4, !dbg !434
  %7 = icmp eq i32 %6, 0, !dbg !434
  br i1 %7, label %8, label %9, !dbg !437

8:                                                ; preds = %1
  br label %10, !dbg !437

9:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 79, ptr noundef @__PRETTY_FUNCTION__.mutex_lock) #6, !dbg !434
  unreachable, !dbg !434

10:                                               ; preds = %8
  ret void, !dbg !438
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @mutex_trylock(ptr noundef %0) #0 !dbg !439 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !443, !DIExpression(), !444)
    #dbg_declare(ptr %3, !445, !DIExpression(), !446)
  %4 = load ptr, ptr %2, align 8, !dbg !447
  %5 = call i32 @pthread_mutex_trylock(ptr noundef %4) #5, !dbg !448
  store i32 %5, ptr %3, align 4, !dbg !446
  %6 = load i32, ptr %3, align 4, !dbg !449
  %7 = icmp eq i32 %6, 0, !dbg !450
  ret i1 %7, !dbg !451
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_trylock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_unlock(ptr noundef %0) #0 !dbg !452 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !453, !DIExpression(), !454)
    #dbg_declare(ptr %3, !455, !DIExpression(), !456)
  %4 = load ptr, ptr %2, align 8, !dbg !457
  %5 = call i32 @pthread_mutex_unlock(ptr noundef %4) #5, !dbg !458
  store i32 %5, ptr %3, align 4, !dbg !456
  %6 = load i32, ptr %3, align 4, !dbg !459
  %7 = icmp eq i32 %6, 0, !dbg !459
  br i1 %7, label %8, label %9, !dbg !462

8:                                                ; preds = %1
  br label %10, !dbg !462

9:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 92, ptr noundef @__PRETTY_FUNCTION__.mutex_unlock) #6, !dbg !459
  unreachable, !dbg !459

10:                                               ; preds = %8
  ret void, !dbg !463
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_test() #0 !dbg !464 {
  %1 = alloca %union.pthread_mutex_t, align 8
  %2 = alloca %union.pthread_mutex_t, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
    #dbg_declare(ptr %1, !467, !DIExpression(), !468)
    #dbg_declare(ptr %2, !469, !DIExpression(), !470)
  call void @mutex_init(ptr noundef %1, i32 noundef 2, i32 noundef 1, i32 noundef 1), !dbg !471
  call void @mutex_init(ptr noundef %2, i32 noundef 1, i32 noundef 2, i32 noundef 2), !dbg !472
  call void @mutex_lock(ptr noundef %1), !dbg !473
    #dbg_declare(ptr %3, !475, !DIExpression(), !476)
  %6 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !477
  %7 = zext i1 %6 to i8, !dbg !476
  store i8 %7, ptr %3, align 1, !dbg !476
  %8 = load i8, ptr %3, align 1, !dbg !478
  %9 = trunc i8 %8 to i1, !dbg !478
  br i1 %9, label %11, label %10, !dbg !481

10:                                               ; preds = %0
  br label %12, !dbg !481

11:                                               ; preds = %0
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 106, ptr noundef @__PRETTY_FUNCTION__.mutex_test) #6, !dbg !478
  unreachable, !dbg !478

12:                                               ; preds = %10
  call void @mutex_unlock(ptr noundef %1), !dbg !482
  call void @mutex_lock(ptr noundef %2), !dbg !483
    #dbg_declare(ptr %4, !485, !DIExpression(), !487)
  %13 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !488
  %14 = zext i1 %13 to i8, !dbg !487
  store i8 %14, ptr %4, align 1, !dbg !487
  %15 = load i8, ptr %4, align 1, !dbg !489
  %16 = trunc i8 %15 to i1, !dbg !489
  br i1 %16, label %17, label %18, !dbg !492

17:                                               ; preds = %12
  br label %19, !dbg !492

18:                                               ; preds = %12
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 115, ptr noundef @__PRETTY_FUNCTION__.mutex_test) #6, !dbg !489
  unreachable, !dbg !489

19:                                               ; preds = %17
  call void @mutex_unlock(ptr noundef %1), !dbg !493
    #dbg_declare(ptr %5, !494, !DIExpression(), !496)
  %20 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !497
  %21 = zext i1 %20 to i8, !dbg !496
  store i8 %21, ptr %5, align 1, !dbg !496
  %22 = load i8, ptr %5, align 1, !dbg !498
  %23 = trunc i8 %22 to i1, !dbg !498
  br i1 %23, label %24, label %25, !dbg !501

24:                                               ; preds = %19
  br label %26, !dbg !501

25:                                               ; preds = %19
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 121, ptr noundef @__PRETTY_FUNCTION__.mutex_test) #6, !dbg !498
  unreachable, !dbg !498

26:                                               ; preds = %24
  call void @mutex_unlock(ptr noundef %1), !dbg !502
  call void @mutex_unlock(ptr noundef %2), !dbg !503
  call void @mutex_destroy(ptr noundef %2), !dbg !504
  call void @mutex_destroy(ptr noundef %1), !dbg !505
  ret void, !dbg !506
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_init(ptr noundef %0) #0 !dbg !507 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca %union.pthread_condattr_t, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !511, !DIExpression(), !512)
    #dbg_declare(ptr %3, !513, !DIExpression(), !514)
    #dbg_declare(ptr %4, !515, !DIExpression(), !521)
  %5 = call i32 @pthread_condattr_init(ptr noundef %4) #5, !dbg !522
  store i32 %5, ptr %3, align 4, !dbg !523
  %6 = load i32, ptr %3, align 4, !dbg !524
  %7 = icmp eq i32 %6, 0, !dbg !524
  br i1 %7, label %8, label %9, !dbg !527

8:                                                ; preds = %1
  br label %10, !dbg !527

9:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 147, ptr noundef @__PRETTY_FUNCTION__.cond_init) #6, !dbg !524
  unreachable, !dbg !524

10:                                               ; preds = %8
  %11 = load ptr, ptr %2, align 8, !dbg !528
  %12 = call i32 @pthread_cond_init(ptr noundef %11, ptr noundef %4) #5, !dbg !529
  store i32 %12, ptr %3, align 4, !dbg !530
  %13 = load i32, ptr %3, align 4, !dbg !531
  %14 = icmp eq i32 %13, 0, !dbg !531
  br i1 %14, label %15, label %16, !dbg !534

15:                                               ; preds = %10
  br label %17, !dbg !534

16:                                               ; preds = %10
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 150, ptr noundef @__PRETTY_FUNCTION__.cond_init) #6, !dbg !531
  unreachable, !dbg !531

17:                                               ; preds = %15
  %18 = call i32 @pthread_condattr_destroy(ptr noundef %4) #5, !dbg !535
  store i32 %18, ptr %3, align 4, !dbg !536
  %19 = load i32, ptr %3, align 4, !dbg !537
  %20 = icmp eq i32 %19, 0, !dbg !537
  br i1 %20, label %21, label %22, !dbg !540

21:                                               ; preds = %17
  br label %23, !dbg !540

22:                                               ; preds = %17
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 153, ptr noundef @__PRETTY_FUNCTION__.cond_init) #6, !dbg !537
  unreachable, !dbg !537

23:                                               ; preds = %21
  ret void, !dbg !541
}

; Function Attrs: nounwind
declare i32 @pthread_condattr_init(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_cond_init(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_condattr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_destroy(ptr noundef %0) #0 !dbg !542 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !543, !DIExpression(), !544)
    #dbg_declare(ptr %3, !545, !DIExpression(), !546)
  %4 = load ptr, ptr %2, align 8, !dbg !547
  %5 = call i32 @pthread_cond_destroy(ptr noundef %4) #5, !dbg !548
  store i32 %5, ptr %3, align 4, !dbg !546
  %6 = load i32, ptr %3, align 4, !dbg !549
  %7 = icmp eq i32 %6, 0, !dbg !549
  br i1 %7, label %8, label %9, !dbg !552

8:                                                ; preds = %1
  br label %10, !dbg !552

9:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 159, ptr noundef @__PRETTY_FUNCTION__.cond_destroy) #6, !dbg !549
  unreachable, !dbg !549

10:                                               ; preds = %8
  ret void, !dbg !553
}

; Function Attrs: nounwind
declare i32 @pthread_cond_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_signal(ptr noundef %0) #0 !dbg !554 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !555, !DIExpression(), !556)
    #dbg_declare(ptr %3, !557, !DIExpression(), !558)
  %4 = load ptr, ptr %2, align 8, !dbg !559
  %5 = call i32 @pthread_cond_signal(ptr noundef %4) #5, !dbg !560
  store i32 %5, ptr %3, align 4, !dbg !558
  %6 = load i32, ptr %3, align 4, !dbg !561
  %7 = icmp eq i32 %6, 0, !dbg !561
  br i1 %7, label %8, label %9, !dbg !564

8:                                                ; preds = %1
  br label %10, !dbg !564

9:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 165, ptr noundef @__PRETTY_FUNCTION__.cond_signal) #6, !dbg !561
  unreachable, !dbg !561

10:                                               ; preds = %8
  ret void, !dbg !565
}

; Function Attrs: nounwind
declare i32 @pthread_cond_signal(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_broadcast(ptr noundef %0) #0 !dbg !566 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !567, !DIExpression(), !568)
    #dbg_declare(ptr %3, !569, !DIExpression(), !570)
  %4 = load ptr, ptr %2, align 8, !dbg !571
  %5 = call i32 @pthread_cond_broadcast(ptr noundef %4) #5, !dbg !572
  store i32 %5, ptr %3, align 4, !dbg !570
  %6 = load i32, ptr %3, align 4, !dbg !573
  %7 = icmp eq i32 %6, 0, !dbg !573
  br i1 %7, label %8, label %9, !dbg !576

8:                                                ; preds = %1
  br label %10, !dbg !576

9:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 171, ptr noundef @__PRETTY_FUNCTION__.cond_broadcast) #6, !dbg !573
  unreachable, !dbg !573

10:                                               ; preds = %8
  ret void, !dbg !577
}

; Function Attrs: nounwind
declare i32 @pthread_cond_broadcast(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_wait(ptr noundef %0, ptr noundef %1) #0 !dbg !578 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !581, !DIExpression(), !582)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !583, !DIExpression(), !584)
    #dbg_declare(ptr %5, !585, !DIExpression(), !586)
  %6 = load ptr, ptr %3, align 8, !dbg !587
  %7 = load ptr, ptr %4, align 8, !dbg !588
  %8 = call i32 @pthread_cond_wait(ptr noundef %6, ptr noundef %7), !dbg !589
  store i32 %8, ptr %5, align 4, !dbg !586
  ret void, !dbg !590
}

declare i32 @pthread_cond_wait(ptr noundef, ptr noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_timedwait(ptr noundef %0, ptr noundef %1, i64 noundef %2) #0 !dbg !591 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.timespec, align 8
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !594, !DIExpression(), !595)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !596, !DIExpression(), !597)
  store i64 %2, ptr %6, align 8
    #dbg_declare(ptr %6, !598, !DIExpression(), !599)
    #dbg_declare(ptr %7, !600, !DIExpression(), !609)
  %9 = load i64, ptr %6, align 8, !dbg !610
    #dbg_declare(ptr %8, !611, !DIExpression(), !612)
  %10 = load ptr, ptr %4, align 8, !dbg !613
  %11 = load ptr, ptr %5, align 8, !dbg !614
  %12 = call i32 @pthread_cond_timedwait(ptr noundef %10, ptr noundef %11, ptr noundef %7), !dbg !615
  store i32 %12, ptr %8, align 4, !dbg !612
  ret void, !dbg !616
}

declare i32 @pthread_cond_timedwait(ptr noundef, ptr noundef, ptr noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @cond_worker(ptr noundef %0) #0 !dbg !617 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i8, align 1
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !618, !DIExpression(), !619)
    #dbg_declare(ptr %4, !620, !DIExpression(), !621)
  store i8 1, ptr %4, align 1, !dbg !621
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !622
  %5 = load i32, ptr @phase, align 4, !dbg !624
  %6 = add nsw i32 %5, 1, !dbg !624
  store i32 %6, ptr @phase, align 4, !dbg !624
  call void @cond_wait(ptr noundef @cond, ptr noundef @cond_mutex), !dbg !625
  %7 = load i32, ptr @phase, align 4, !dbg !626
  %8 = add nsw i32 %7, 1, !dbg !626
  store i32 %8, ptr @phase, align 4, !dbg !626
  %9 = load i32, ptr @phase, align 4, !dbg !627
  %10 = icmp slt i32 %9, 2, !dbg !628
  %11 = zext i1 %10 to i8, !dbg !629
  store i8 %11, ptr %4, align 1, !dbg !629
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !630
  %12 = load i8, ptr %4, align 1, !dbg !631
  %13 = trunc i8 %12 to i1, !dbg !631
  br i1 %13, label %14, label %17, !dbg !633

14:                                               ; preds = %1
  %15 = load ptr, ptr %3, align 8, !dbg !634
  %16 = getelementptr inbounds i8, ptr %15, i64 1, !dbg !635
  store ptr %16, ptr %2, align 8, !dbg !636
  br label %32, !dbg !636

17:                                               ; preds = %1
  store i8 1, ptr %4, align 1, !dbg !637
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !638
  %18 = load i32, ptr @phase, align 4, !dbg !640
  %19 = add nsw i32 %18, 1, !dbg !640
  store i32 %19, ptr @phase, align 4, !dbg !640
  call void @cond_timedwait(ptr noundef @cond, ptr noundef @cond_mutex, i64 noundef 10), !dbg !641
  %20 = load i32, ptr @phase, align 4, !dbg !642
  %21 = add nsw i32 %20, 1, !dbg !642
  store i32 %21, ptr @phase, align 4, !dbg !642
  %22 = load i32, ptr @phase, align 4, !dbg !643
  %23 = icmp sgt i32 %22, 6, !dbg !644
  %24 = zext i1 %23 to i8, !dbg !645
  store i8 %24, ptr %4, align 1, !dbg !645
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !646
  %25 = load i8, ptr %4, align 1, !dbg !647
  %26 = trunc i8 %25 to i1, !dbg !647
  br i1 %26, label %27, label %30, !dbg !649

27:                                               ; preds = %17
  %28 = load ptr, ptr %3, align 8, !dbg !650
  %29 = getelementptr inbounds i8, ptr %28, i64 2, !dbg !651
  store ptr %29, ptr %2, align 8, !dbg !652
  br label %32, !dbg !652

30:                                               ; preds = %17
  %31 = load ptr, ptr %3, align 8, !dbg !653
  store ptr %31, ptr %2, align 8, !dbg !654
  br label %32, !dbg !654

32:                                               ; preds = %30, %27, %14
  %33 = load ptr, ptr %2, align 8, !dbg !655
  ret ptr %33, !dbg !655
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_test() #0 !dbg !656 {
  %1 = alloca ptr, align 8
  %2 = alloca i64, align 8
  %3 = alloca ptr, align 8
    #dbg_declare(ptr %1, !657, !DIExpression(), !658)
  store ptr inttoptr (i64 42 to ptr), ptr %1, align 8, !dbg !658
  call void @mutex_init(ptr noundef @cond_mutex, i32 noundef 0, i32 noundef 0, i32 noundef 0), !dbg !659
  call void @cond_init(ptr noundef @cond), !dbg !660
    #dbg_declare(ptr %2, !661, !DIExpression(), !662)
  %4 = load ptr, ptr %1, align 8, !dbg !663
  %5 = call i64 @thread_create(ptr noundef @cond_worker, ptr noundef %4), !dbg !664
  store i64 %5, ptr %2, align 8, !dbg !662
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !665
  %6 = load i32, ptr @phase, align 4, !dbg !667
  %7 = add nsw i32 %6, 1, !dbg !667
  store i32 %7, ptr @phase, align 4, !dbg !667
  call void @cond_signal(ptr noundef @cond), !dbg !668
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !669
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !670
  %8 = load i32, ptr @phase, align 4, !dbg !672
  %9 = add nsw i32 %8, 1, !dbg !672
  store i32 %9, ptr @phase, align 4, !dbg !672
  call void @cond_broadcast(ptr noundef @cond), !dbg !673
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !674
    #dbg_declare(ptr %3, !675, !DIExpression(), !676)
  %10 = load i64, ptr %2, align 8, !dbg !677
  %11 = call ptr @thread_join(i64 noundef %10), !dbg !678
  store ptr %11, ptr %3, align 8, !dbg !676
  %12 = load ptr, ptr %3, align 8, !dbg !679
  %13 = load ptr, ptr %1, align 8, !dbg !679
  %14 = icmp eq ptr %12, %13, !dbg !679
  br i1 %14, label %15, label %16, !dbg !682

15:                                               ; preds = %0
  br label %17, !dbg !682

16:                                               ; preds = %0
  call void @__assert_fail(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 245, ptr noundef @__PRETTY_FUNCTION__.cond_test) #6, !dbg !679
  unreachable, !dbg !679

17:                                               ; preds = %15
  call void @cond_destroy(ptr noundef @cond), !dbg !683
  call void @mutex_destroy(ptr noundef @cond_mutex), !dbg !684
  ret void, !dbg !685
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_init(ptr noundef %0, i32 noundef %1) #0 !dbg !686 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca %union.pthread_rwlockattr_t, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !716, !DIExpression(), !717)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !718, !DIExpression(), !719)
    #dbg_declare(ptr %5, !720, !DIExpression(), !721)
    #dbg_declare(ptr %6, !722, !DIExpression(), !723)
    #dbg_declare(ptr %7, !724, !DIExpression(), !730)
  %8 = call i32 @pthread_rwlockattr_init(ptr noundef %7) #5, !dbg !731
  store i32 %8, ptr %5, align 4, !dbg !732
  %9 = load i32, ptr %5, align 4, !dbg !733
  %10 = icmp eq i32 %9, 0, !dbg !733
  br i1 %10, label %11, label %12, !dbg !736

11:                                               ; preds = %2
  br label %13, !dbg !736

12:                                               ; preds = %2
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 262, ptr noundef @__PRETTY_FUNCTION__.rwlock_init) #6, !dbg !733
  unreachable, !dbg !733

13:                                               ; preds = %11
  %14 = load i32, ptr %4, align 4, !dbg !737
  %15 = call i32 @pthread_rwlockattr_setpshared(ptr noundef %7, i32 noundef %14) #5, !dbg !738
  store i32 %15, ptr %5, align 4, !dbg !739
  %16 = load i32, ptr %5, align 4, !dbg !740
  %17 = icmp eq i32 %16, 0, !dbg !740
  br i1 %17, label %18, label %19, !dbg !743

18:                                               ; preds = %13
  br label %20, !dbg !743

19:                                               ; preds = %13
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 265, ptr noundef @__PRETTY_FUNCTION__.rwlock_init) #6, !dbg !740
  unreachable, !dbg !740

20:                                               ; preds = %18
  %21 = call i32 @pthread_rwlockattr_getpshared(ptr noundef %7, ptr noundef %6) #5, !dbg !744
  store i32 %21, ptr %5, align 4, !dbg !745
  %22 = load i32, ptr %5, align 4, !dbg !746
  %23 = icmp eq i32 %22, 0, !dbg !746
  br i1 %23, label %24, label %25, !dbg !749

24:                                               ; preds = %20
  br label %26, !dbg !749

25:                                               ; preds = %20
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 267, ptr noundef @__PRETTY_FUNCTION__.rwlock_init) #6, !dbg !746
  unreachable, !dbg !746

26:                                               ; preds = %24
  %27 = load ptr, ptr %3, align 8, !dbg !750
  %28 = call i32 @pthread_rwlock_init(ptr noundef %27, ptr noundef %7) #5, !dbg !751
  store i32 %28, ptr %5, align 4, !dbg !752
  %29 = load i32, ptr %5, align 4, !dbg !753
  %30 = icmp eq i32 %29, 0, !dbg !753
  br i1 %30, label %31, label %32, !dbg !756

31:                                               ; preds = %26
  br label %33, !dbg !756

32:                                               ; preds = %26
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 270, ptr noundef @__PRETTY_FUNCTION__.rwlock_init) #6, !dbg !753
  unreachable, !dbg !753

33:                                               ; preds = %31
  %34 = call i32 @pthread_rwlockattr_destroy(ptr noundef %7) #5, !dbg !757
  store i32 %34, ptr %5, align 4, !dbg !758
  %35 = load i32, ptr %5, align 4, !dbg !759
  %36 = icmp eq i32 %35, 0, !dbg !759
  br i1 %36, label %37, label %38, !dbg !762

37:                                               ; preds = %33
  br label %39, !dbg !762

38:                                               ; preds = %33
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 272, ptr noundef @__PRETTY_FUNCTION__.rwlock_init) #6, !dbg !759
  unreachable, !dbg !759

39:                                               ; preds = %37
  ret void, !dbg !763
}

; Function Attrs: nounwind
declare i32 @pthread_rwlockattr_init(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_rwlockattr_setpshared(ptr noundef, i32 noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_rwlockattr_getpshared(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_rwlock_init(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_rwlockattr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_destroy(ptr noundef %0) #0 !dbg !764 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !767, !DIExpression(), !768)
    #dbg_declare(ptr %3, !769, !DIExpression(), !770)
  %4 = load ptr, ptr %2, align 8, !dbg !771
  %5 = call i32 @pthread_rwlock_destroy(ptr noundef %4) #5, !dbg !772
  store i32 %5, ptr %3, align 4, !dbg !770
  %6 = load i32, ptr %3, align 4, !dbg !773
  %7 = icmp eq i32 %6, 0, !dbg !773
  br i1 %7, label %8, label %9, !dbg !776

8:                                                ; preds = %1
  br label %10, !dbg !776

9:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 278, ptr noundef @__PRETTY_FUNCTION__.rwlock_destroy) #6, !dbg !773
  unreachable, !dbg !773

10:                                               ; preds = %8
  ret void, !dbg !777
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_wrlock(ptr noundef %0) #0 !dbg !778 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !779, !DIExpression(), !780)
    #dbg_declare(ptr %3, !781, !DIExpression(), !782)
  %4 = load ptr, ptr %2, align 8, !dbg !783
  %5 = call i32 @pthread_rwlock_wrlock(ptr noundef %4) #5, !dbg !784
  store i32 %5, ptr %3, align 4, !dbg !782
  %6 = load i32, ptr %3, align 4, !dbg !785
  %7 = icmp eq i32 %6, 0, !dbg !785
  br i1 %7, label %8, label %9, !dbg !788

8:                                                ; preds = %1
  br label %10, !dbg !788

9:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 284, ptr noundef @__PRETTY_FUNCTION__.rwlock_wrlock) #6, !dbg !785
  unreachable, !dbg !785

10:                                               ; preds = %8
  ret void, !dbg !789
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_wrlock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @rwlock_trywrlock(ptr noundef %0) #0 !dbg !790 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !793, !DIExpression(), !794)
    #dbg_declare(ptr %3, !795, !DIExpression(), !796)
  %4 = load ptr, ptr %2, align 8, !dbg !797
  %5 = call i32 @pthread_rwlock_trywrlock(ptr noundef %4) #5, !dbg !798
  store i32 %5, ptr %3, align 4, !dbg !796
  %6 = load i32, ptr %3, align 4, !dbg !799
  %7 = icmp eq i32 %6, 0, !dbg !800
  ret i1 %7, !dbg !801
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_trywrlock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_rdlock(ptr noundef %0) #0 !dbg !802 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !803, !DIExpression(), !804)
    #dbg_declare(ptr %3, !805, !DIExpression(), !806)
  %4 = load ptr, ptr %2, align 8, !dbg !807
  %5 = call i32 @pthread_rwlock_rdlock(ptr noundef %4) #5, !dbg !808
  store i32 %5, ptr %3, align 4, !dbg !806
  %6 = load i32, ptr %3, align 4, !dbg !809
  %7 = icmp eq i32 %6, 0, !dbg !809
  br i1 %7, label %8, label %9, !dbg !812

8:                                                ; preds = %1
  br label %10, !dbg !812

9:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 297, ptr noundef @__PRETTY_FUNCTION__.rwlock_rdlock) #6, !dbg !809
  unreachable, !dbg !809

10:                                               ; preds = %8
  ret void, !dbg !813
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_rdlock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @rwlock_tryrdlock(ptr noundef %0) #0 !dbg !814 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !815, !DIExpression(), !816)
    #dbg_declare(ptr %3, !817, !DIExpression(), !818)
  %4 = load ptr, ptr %2, align 8, !dbg !819
  %5 = call i32 @pthread_rwlock_tryrdlock(ptr noundef %4) #5, !dbg !820
  store i32 %5, ptr %3, align 4, !dbg !818
  %6 = load i32, ptr %3, align 4, !dbg !821
  %7 = icmp eq i32 %6, 0, !dbg !822
  ret i1 %7, !dbg !823
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_tryrdlock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_unlock(ptr noundef %0) #0 !dbg !824 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !825, !DIExpression(), !826)
    #dbg_declare(ptr %3, !827, !DIExpression(), !828)
  %4 = load ptr, ptr %2, align 8, !dbg !829
  %5 = call i32 @pthread_rwlock_unlock(ptr noundef %4) #5, !dbg !830
  store i32 %5, ptr %3, align 4, !dbg !828
  %6 = load i32, ptr %3, align 4, !dbg !831
  %7 = icmp eq i32 %6, 0, !dbg !831
  br i1 %7, label %8, label %9, !dbg !834

8:                                                ; preds = %1
  br label %10, !dbg !834

9:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 310, ptr noundef @__PRETTY_FUNCTION__.rwlock_unlock) #6, !dbg !831
  unreachable, !dbg !831

10:                                               ; preds = %8
  ret void, !dbg !835
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_unlock(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_test() #0 !dbg !836 {
  %1 = alloca %union.pthread_rwlock_t, align 8
  %2 = alloca i32, align 4
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  %6 = alloca i8, align 1
  %7 = alloca i32, align 4
  %8 = alloca i8, align 1
    #dbg_declare(ptr %1, !837, !DIExpression(), !838)
  call void @rwlock_init(ptr noundef %1, i32 noundef 0), !dbg !839
    #dbg_declare(ptr %2, !840, !DIExpression(), !842)
  store i32 4, ptr %2, align 4, !dbg !842
  call void @rwlock_wrlock(ptr noundef %1), !dbg !843
    #dbg_declare(ptr %3, !845, !DIExpression(), !846)
  %9 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !847
  %10 = zext i1 %9 to i8, !dbg !846
  store i8 %10, ptr %3, align 1, !dbg !846
  %11 = load i8, ptr %3, align 1, !dbg !848
  %12 = trunc i8 %11 to i1, !dbg !848
  br i1 %12, label %14, label %13, !dbg !851

13:                                               ; preds = %0
  br label %15, !dbg !851

14:                                               ; preds = %0
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 322, ptr noundef @__PRETTY_FUNCTION__.rwlock_test) #6, !dbg !848
  unreachable, !dbg !848

15:                                               ; preds = %13
  %16 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !852
  %17 = zext i1 %16 to i8, !dbg !853
  store i8 %17, ptr %3, align 1, !dbg !853
  %18 = load i8, ptr %3, align 1, !dbg !854
  %19 = trunc i8 %18 to i1, !dbg !854
  br i1 %19, label %21, label %20, !dbg !857

20:                                               ; preds = %15
  br label %22, !dbg !857

21:                                               ; preds = %15
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 324, ptr noundef @__PRETTY_FUNCTION__.rwlock_test) #6, !dbg !854
  unreachable, !dbg !854

22:                                               ; preds = %20
  call void @rwlock_unlock(ptr noundef %1), !dbg !858
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !859
    #dbg_declare(ptr %4, !861, !DIExpression(), !863)
  store i32 0, ptr %4, align 4, !dbg !863
  br label %23, !dbg !864

23:                                               ; preds = %34, %22
  %24 = load i32, ptr %4, align 4, !dbg !865
  %25 = icmp slt i32 %24, 4, !dbg !867
  br i1 %25, label %26, label %37, !dbg !868

26:                                               ; preds = %23
    #dbg_declare(ptr %5, !869, !DIExpression(), !871)
  %27 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !872
  %28 = zext i1 %27 to i8, !dbg !871
  store i8 %28, ptr %5, align 1, !dbg !871
  %29 = load i8, ptr %5, align 1, !dbg !873
  %30 = trunc i8 %29 to i1, !dbg !873
  br i1 %30, label %31, label %32, !dbg !876

31:                                               ; preds = %26
  br label %33, !dbg !876

32:                                               ; preds = %26
  call void @__assert_fail(ptr noundef @.str.3, ptr noundef @.str.1, i32 noundef 333, ptr noundef @__PRETTY_FUNCTION__.rwlock_test) #6, !dbg !873
  unreachable, !dbg !873

33:                                               ; preds = %31
  br label %34, !dbg !877

34:                                               ; preds = %33
  %35 = load i32, ptr %4, align 4, !dbg !878
  %36 = add nsw i32 %35, 1, !dbg !878
  store i32 %36, ptr %4, align 4, !dbg !878
  br label %23, !dbg !879, !llvm.loop !880

37:                                               ; preds = %23
    #dbg_declare(ptr %6, !883, !DIExpression(), !885)
  %38 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !886
  %39 = zext i1 %38 to i8, !dbg !885
  store i8 %39, ptr %6, align 1, !dbg !885
  %40 = load i8, ptr %6, align 1, !dbg !887
  %41 = trunc i8 %40 to i1, !dbg !887
  br i1 %41, label %43, label %42, !dbg !890

42:                                               ; preds = %37
  br label %44, !dbg !890

43:                                               ; preds = %37
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 338, ptr noundef @__PRETTY_FUNCTION__.rwlock_test) #6, !dbg !887
  unreachable, !dbg !887

44:                                               ; preds = %42
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !891
    #dbg_declare(ptr %7, !892, !DIExpression(), !894)
  store i32 0, ptr %7, align 4, !dbg !894
  br label %45, !dbg !895

45:                                               ; preds = %49, %44
  %46 = load i32, ptr %7, align 4, !dbg !896
  %47 = icmp slt i32 %46, 4, !dbg !898
  br i1 %47, label %48, label %52, !dbg !899

48:                                               ; preds = %45
  call void @rwlock_unlock(ptr noundef %1), !dbg !900
  br label %49, !dbg !902

49:                                               ; preds = %48
  %50 = load i32, ptr %7, align 4, !dbg !903
  %51 = add nsw i32 %50, 1, !dbg !903
  store i32 %51, ptr %7, align 4, !dbg !903
  br label %45, !dbg !904, !llvm.loop !905

52:                                               ; preds = %45
  call void @rwlock_wrlock(ptr noundef %1), !dbg !907
    #dbg_declare(ptr %8, !909, !DIExpression(), !910)
  %53 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !911
  %54 = zext i1 %53 to i8, !dbg !910
  store i8 %54, ptr %8, align 1, !dbg !910
  %55 = load i8, ptr %8, align 1, !dbg !912
  %56 = trunc i8 %55 to i1, !dbg !912
  br i1 %56, label %58, label %57, !dbg !915

57:                                               ; preds = %52
  br label %59, !dbg !915

58:                                               ; preds = %52
  call void @__assert_fail(ptr noundef @.str.2, ptr noundef @.str.1, i32 noundef 350, ptr noundef @__PRETTY_FUNCTION__.rwlock_test) #6, !dbg !912
  unreachable, !dbg !912

59:                                               ; preds = %57
  call void @rwlock_unlock(ptr noundef %1), !dbg !916
  call void @rwlock_destroy(ptr noundef %1), !dbg !917
  ret void, !dbg !918
}

declare void @__VERIFIER_loop_bound(i32 noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @key_destroy(ptr noundef %0) #0 !dbg !919 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !922, !DIExpression(), !923)
  %3 = call i64 @pthread_self() #7, !dbg !924
  store i64 %3, ptr @latest_thread, align 8, !dbg !925
  ret void, !dbg !926
}

; Function Attrs: nounwind willreturn memory(none)
declare i64 @pthread_self() #4

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @key_worker(ptr noundef %0) #0 !dbg !927 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !928, !DIExpression(), !929)
    #dbg_declare(ptr %3, !930, !DIExpression(), !931)
  store i32 1, ptr %3, align 4, !dbg !931
    #dbg_declare(ptr %4, !932, !DIExpression(), !933)
  %6 = load i32, ptr @local_data, align 4, !dbg !934
  %7 = call i32 @pthread_setspecific(i32 noundef %6, ptr noundef %3) #5, !dbg !935
  store i32 %7, ptr %4, align 4, !dbg !933
  %8 = load i32, ptr %4, align 4, !dbg !936
  %9 = icmp eq i32 %8, 0, !dbg !936
  br i1 %9, label %10, label %11, !dbg !939

10:                                               ; preds = %1
  br label %12, !dbg !939

11:                                               ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 372, ptr noundef @__PRETTY_FUNCTION__.key_worker) #6, !dbg !936
  unreachable, !dbg !936

12:                                               ; preds = %10
    #dbg_declare(ptr %5, !940, !DIExpression(), !941)
  %13 = load i32, ptr @local_data, align 4, !dbg !942
  %14 = call ptr @pthread_getspecific(i32 noundef %13) #5, !dbg !943
  store ptr %14, ptr %5, align 8, !dbg !941
  %15 = load ptr, ptr %5, align 8, !dbg !944
  %16 = icmp eq ptr %15, %3, !dbg !944
  br i1 %16, label %17, label %18, !dbg !947

17:                                               ; preds = %12
  br label %19, !dbg !947

18:                                               ; preds = %12
  call void @__assert_fail(ptr noundef @.str.5, ptr noundef @.str.1, i32 noundef 375, ptr noundef @__PRETTY_FUNCTION__.key_worker) #6, !dbg !944
  unreachable, !dbg !944

19:                                               ; preds = %17
  %20 = load ptr, ptr %2, align 8, !dbg !948
  ret ptr %20, !dbg !949
}

; Function Attrs: nounwind
declare i32 @pthread_setspecific(i32 noundef, ptr noundef) #1

; Function Attrs: nounwind
declare ptr @pthread_getspecific(i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @key_test() #0 !dbg !950 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
    #dbg_declare(ptr %1, !951, !DIExpression(), !952)
  store i32 2, ptr %1, align 4, !dbg !952
    #dbg_declare(ptr %2, !953, !DIExpression(), !954)
  store ptr inttoptr (i64 41 to ptr), ptr %2, align 8, !dbg !954
    #dbg_declare(ptr %3, !955, !DIExpression(), !956)
  %7 = call i32 @pthread_key_create(ptr noundef @local_data, ptr noundef @key_destroy) #5, !dbg !957
    #dbg_declare(ptr %4, !958, !DIExpression(), !959)
  %8 = load ptr, ptr %2, align 8, !dbg !960
  %9 = call i64 @thread_create(ptr noundef @key_worker, ptr noundef %8), !dbg !961
  store i64 %9, ptr %4, align 8, !dbg !959
  %10 = load i32, ptr @local_data, align 4, !dbg !962
  %11 = call i32 @pthread_setspecific(i32 noundef %10, ptr noundef %1) #5, !dbg !963
  store i32 %11, ptr %3, align 4, !dbg !964
  %12 = load i32, ptr %3, align 4, !dbg !965
  %13 = icmp eq i32 %12, 0, !dbg !965
  br i1 %13, label %14, label %15, !dbg !968

14:                                               ; preds = %0
  br label %16, !dbg !968

15:                                               ; preds = %0
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 391, ptr noundef @__PRETTY_FUNCTION__.key_test) #6, !dbg !965
  unreachable, !dbg !965

16:                                               ; preds = %14
    #dbg_declare(ptr %5, !969, !DIExpression(), !970)
  %17 = load i32, ptr @local_data, align 4, !dbg !971
  %18 = call ptr @pthread_getspecific(i32 noundef %17) #5, !dbg !972
  store ptr %18, ptr %5, align 8, !dbg !970
  %19 = load ptr, ptr %5, align 8, !dbg !973
  %20 = icmp eq ptr %19, %1, !dbg !973
  br i1 %20, label %21, label %22, !dbg !976

21:                                               ; preds = %16
  br label %23, !dbg !976

22:                                               ; preds = %16
  call void @__assert_fail(ptr noundef @.str.5, ptr noundef @.str.1, i32 noundef 394, ptr noundef @__PRETTY_FUNCTION__.key_test) #6, !dbg !973
  unreachable, !dbg !973

23:                                               ; preds = %21
  %24 = load i32, ptr @local_data, align 4, !dbg !977
  %25 = call i32 @pthread_setspecific(i32 noundef %24, ptr noundef null) #5, !dbg !978
  store i32 %25, ptr %3, align 4, !dbg !979
  %26 = load i32, ptr %3, align 4, !dbg !980
  %27 = icmp eq i32 %26, 0, !dbg !980
  br i1 %27, label %28, label %29, !dbg !983

28:                                               ; preds = %23
  br label %30, !dbg !983

29:                                               ; preds = %23
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 397, ptr noundef @__PRETTY_FUNCTION__.key_test) #6, !dbg !980
  unreachable, !dbg !980

30:                                               ; preds = %28
    #dbg_declare(ptr %6, !984, !DIExpression(), !985)
  %31 = load i64, ptr %4, align 8, !dbg !986
  %32 = call ptr @thread_join(i64 noundef %31), !dbg !987
  store ptr %32, ptr %6, align 8, !dbg !985
  %33 = load ptr, ptr %6, align 8, !dbg !988
  %34 = load ptr, ptr %2, align 8, !dbg !988
  %35 = icmp eq ptr %33, %34, !dbg !988
  br i1 %35, label %36, label %37, !dbg !991

36:                                               ; preds = %30
  br label %38, !dbg !991

37:                                               ; preds = %30
  call void @__assert_fail(ptr noundef @.str.4, ptr noundef @.str.1, i32 noundef 400, ptr noundef @__PRETTY_FUNCTION__.key_test) #6, !dbg !988
  unreachable, !dbg !988

38:                                               ; preds = %36
  %39 = load i32, ptr @local_data, align 4, !dbg !992
  %40 = call i32 @pthread_key_delete(i32 noundef %39) #5, !dbg !993
  store i32 %40, ptr %3, align 4, !dbg !994
  %41 = load i32, ptr %3, align 4, !dbg !995
  %42 = icmp eq i32 %41, 0, !dbg !995
  br i1 %42, label %43, label %44, !dbg !998

43:                                               ; preds = %38
  br label %45, !dbg !998

44:                                               ; preds = %38
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 403, ptr noundef @__PRETTY_FUNCTION__.key_test) #6, !dbg !995
  unreachable, !dbg !995

45:                                               ; preds = %43
  %46 = load i64, ptr @latest_thread, align 8, !dbg !999
  %47 = load i64, ptr %4, align 8, !dbg !999
  %48 = call i32 @pthread_equal(i64 noundef %46, i64 noundef %47) #7, !dbg !999
  %49 = icmp ne i32 %48, 0, !dbg !999
  br i1 %49, label %50, label %51, !dbg !1002

50:                                               ; preds = %45
  br label %52, !dbg !1002

51:                                               ; preds = %45
  call void @__assert_fail(ptr noundef @.str.6, ptr noundef @.str.1, i32 noundef 405, ptr noundef @__PRETTY_FUNCTION__.key_test) #6, !dbg !999
  unreachable, !dbg !999

52:                                               ; preds = %50
  ret void, !dbg !1003
}

; Function Attrs: nounwind
declare i32 @pthread_key_create(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_key_delete(i32 noundef) #1

; Function Attrs: nounwind willreturn memory(none)
declare i32 @pthread_equal(i64 noundef, i64 noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_worker0(ptr noundef %0) #0 !dbg !1004 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !1005, !DIExpression(), !1006)
  ret ptr null, !dbg !1007
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_detach(ptr noundef %0) #0 !dbg !1008 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !1009, !DIExpression(), !1010)
    #dbg_declare(ptr %3, !1011, !DIExpression(), !1012)
    #dbg_declare(ptr %4, !1013, !DIExpression(), !1014)
  %5 = call i64 @thread_create(ptr noundef @detach_test_worker0, ptr noundef null), !dbg !1015
  store i64 %5, ptr %4, align 8, !dbg !1014
  %6 = load i64, ptr %4, align 8, !dbg !1016
  %7 = call i32 @pthread_detach(i64 noundef %6) #5, !dbg !1017
  store i32 %7, ptr %3, align 4, !dbg !1018
  %8 = load i32, ptr %3, align 4, !dbg !1019
  %9 = icmp eq i32 %8, 0, !dbg !1019
  br i1 %9, label %10, label %11, !dbg !1022

10:                                               ; preds = %1
  br label %12, !dbg !1022

11:                                               ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 420, ptr noundef @__PRETTY_FUNCTION__.detach_test_detach) #6, !dbg !1019
  unreachable, !dbg !1019

12:                                               ; preds = %10
  %13 = load i64, ptr %4, align 8, !dbg !1023
  %14 = call i32 @pthread_join(i64 noundef %13, ptr noundef null), !dbg !1024
  store i32 %14, ptr %3, align 4, !dbg !1025
  %15 = load i32, ptr %3, align 4, !dbg !1026
  %16 = icmp ne i32 %15, 0, !dbg !1026
  br i1 %16, label %17, label %18, !dbg !1029

17:                                               ; preds = %12
  br label %19, !dbg !1029

18:                                               ; preds = %12
  call void @__assert_fail(ptr noundef @.str.7, ptr noundef @.str.1, i32 noundef 423, ptr noundef @__PRETTY_FUNCTION__.detach_test_detach) #6, !dbg !1026
  unreachable, !dbg !1026

19:                                               ; preds = %17
  ret ptr null, !dbg !1030
}

; Function Attrs: nounwind
declare i32 @pthread_detach(i64 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_attr(ptr noundef %0) #0 !dbg !1031 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  %6 = alloca %union.pthread_attr_t, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !1032, !DIExpression(), !1033)
    #dbg_declare(ptr %3, !1034, !DIExpression(), !1035)
    #dbg_declare(ptr %4, !1036, !DIExpression(), !1037)
    #dbg_declare(ptr %5, !1038, !DIExpression(), !1039)
    #dbg_declare(ptr %6, !1040, !DIExpression(), !1041)
  %7 = call i32 @pthread_attr_init(ptr noundef %6) #5, !dbg !1042
  store i32 %7, ptr %3, align 4, !dbg !1043
  %8 = load i32, ptr %3, align 4, !dbg !1044
  %9 = icmp eq i32 %8, 0, !dbg !1044
  br i1 %9, label %10, label %11, !dbg !1047

10:                                               ; preds = %1
  br label %12, !dbg !1047

11:                                               ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 434, ptr noundef @__PRETTY_FUNCTION__.detach_test_attr) #6, !dbg !1044
  unreachable, !dbg !1044

12:                                               ; preds = %10
  %13 = call i32 @pthread_attr_getdetachstate(ptr noundef %6, ptr noundef %4) #5, !dbg !1048
  store i32 %13, ptr %3, align 4, !dbg !1049
  %14 = load i32, ptr %3, align 4, !dbg !1050
  %15 = icmp eq i32 %14, 0, !dbg !1050
  br i1 %15, label %16, label %20, !dbg !1050

16:                                               ; preds = %12
  %17 = load i32, ptr %4, align 4, !dbg !1050
  %18 = icmp eq i32 %17, 0, !dbg !1050
  br i1 %18, label %19, label %20, !dbg !1053

19:                                               ; preds = %16
  br label %21, !dbg !1053

20:                                               ; preds = %16, %12
  call void @__assert_fail(ptr noundef @.str.8, ptr noundef @.str.1, i32 noundef 436, ptr noundef @__PRETTY_FUNCTION__.detach_test_attr) #6, !dbg !1050
  unreachable, !dbg !1050

21:                                               ; preds = %19
  %22 = call i32 @pthread_attr_setdetachstate(ptr noundef %6, i32 noundef 1) #5, !dbg !1054
  store i32 %22, ptr %3, align 4, !dbg !1055
  %23 = load i32, ptr %3, align 4, !dbg !1056
  %24 = icmp eq i32 %23, 0, !dbg !1056
  br i1 %24, label %25, label %26, !dbg !1059

25:                                               ; preds = %21
  br label %27, !dbg !1059

26:                                               ; preds = %21
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 438, ptr noundef @__PRETTY_FUNCTION__.detach_test_attr) #6, !dbg !1056
  unreachable, !dbg !1056

27:                                               ; preds = %25
  %28 = call i32 @pthread_attr_getdetachstate(ptr noundef %6, ptr noundef %4) #5, !dbg !1060
  store i32 %28, ptr %3, align 4, !dbg !1061
  %29 = load i32, ptr %3, align 4, !dbg !1062
  %30 = icmp eq i32 %29, 0, !dbg !1062
  br i1 %30, label %31, label %35, !dbg !1062

31:                                               ; preds = %27
  %32 = load i32, ptr %4, align 4, !dbg !1062
  %33 = icmp eq i32 %32, 1, !dbg !1062
  br i1 %33, label %34, label %35, !dbg !1065

34:                                               ; preds = %31
  br label %36, !dbg !1065

35:                                               ; preds = %31, %27
  call void @__assert_fail(ptr noundef @.str.9, ptr noundef @.str.1, i32 noundef 440, ptr noundef @__PRETTY_FUNCTION__.detach_test_attr) #6, !dbg !1062
  unreachable, !dbg !1062

36:                                               ; preds = %34
  %37 = call i32 @pthread_create(ptr noundef %5, ptr noundef %6, ptr noundef @detach_test_worker0, ptr noundef null) #5, !dbg !1066
  store i32 %37, ptr %3, align 4, !dbg !1067
  %38 = load i32, ptr %3, align 4, !dbg !1068
  %39 = icmp eq i32 %38, 0, !dbg !1068
  br i1 %39, label %40, label %41, !dbg !1071

40:                                               ; preds = %36
  br label %42, !dbg !1071

41:                                               ; preds = %36
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 442, ptr noundef @__PRETTY_FUNCTION__.detach_test_attr) #6, !dbg !1068
  unreachable, !dbg !1068

42:                                               ; preds = %40
  %43 = call i32 @pthread_attr_destroy(ptr noundef %6) #5, !dbg !1072
  %44 = load i64, ptr %5, align 8, !dbg !1073
  %45 = call i32 @pthread_join(i64 noundef %44, ptr noundef null), !dbg !1074
  store i32 %45, ptr %3, align 4, !dbg !1075
  %46 = load i32, ptr %3, align 4, !dbg !1076
  %47 = icmp ne i32 %46, 0, !dbg !1076
  br i1 %47, label %48, label %49, !dbg !1079

48:                                               ; preds = %42
  br label %50, !dbg !1079

49:                                               ; preds = %42
  call void @__assert_fail(ptr noundef @.str.7, ptr noundef @.str.1, i32 noundef 446, ptr noundef @__PRETTY_FUNCTION__.detach_test_attr) #6, !dbg !1076
  unreachable, !dbg !1076

50:                                               ; preds = %48
  ret ptr null, !dbg !1080
}

; Function Attrs: nounwind
declare i32 @pthread_attr_getdetachstate(ptr noundef, ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_attr_setdetachstate(ptr noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @detach_test() #0 !dbg !1081 {
  %1 = call i64 @thread_create(ptr noundef @detach_test_detach, ptr noundef null), !dbg !1082
  %2 = call i64 @thread_create(ptr noundef @detach_test_attr, ptr noundef null), !dbg !1083
  ret void, !dbg !1084
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @once_init0() #0 !dbg !1085 {
  %1 = load i32, ptr @once_calls, align 4, !dbg !1086
  %2 = add nsw i32 %1, 1, !dbg !1086
  store i32 %2, ptr @once_calls, align 4, !dbg !1086
  store i32 42, ptr @once_value, align 4, !dbg !1087
  ret void, !dbg !1088
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @once_init1() #0 !dbg !1089 {
  %1 = load i32, ptr @once_calls, align 4, !dbg !1090
  %2 = add nsw i32 %1, 1, !dbg !1090
  store i32 %2, ptr @once_calls, align 4, !dbg !1090
  ret void, !dbg !1091
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @once_worker(ptr noundef %0) #0 !dbg !1092 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !1093, !DIExpression(), !1094)
    #dbg_declare(ptr %3, !1095, !DIExpression(), !1096)
  %4 = call i32 @pthread_once(ptr noundef @once0, ptr noundef @once_init0), !dbg !1097
  store i32 %4, ptr %3, align 4, !dbg !1096
  %5 = load i32, ptr %3, align 4, !dbg !1098
  %6 = icmp eq i32 %5, 0, !dbg !1098
  br i1 %6, label %7, label %8, !dbg !1101

7:                                                ; preds = %1
  br label %9, !dbg !1101

8:                                                ; preds = %1
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 477, ptr noundef @__PRETTY_FUNCTION__.once_worker) #6, !dbg !1098
  unreachable, !dbg !1098

9:                                                ; preds = %7
  %10 = load i32, ptr @once_value, align 4, !dbg !1102
  %11 = icmp eq i32 %10, 42, !dbg !1102
  br i1 %11, label %12, label %13, !dbg !1105

12:                                               ; preds = %9
  br label %14, !dbg !1105

13:                                               ; preds = %9
  call void @__assert_fail(ptr noundef @.str.10, ptr noundef @.str.1, i32 noundef 478, ptr noundef @__PRETTY_FUNCTION__.once_worker) #6, !dbg !1102
  unreachable, !dbg !1102

14:                                               ; preds = %12
  ret ptr null, !dbg !1106
}

declare i32 @pthread_once(ptr noundef, ptr noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @once_test() #0 !dbg !1107 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i32, align 4
    #dbg_declare(ptr %1, !1108, !DIExpression(), !1109)
  %4 = call i64 @thread_create(ptr noundef @once_worker, ptr noundef null), !dbg !1110
  store i64 %4, ptr %1, align 8, !dbg !1109
    #dbg_declare(ptr %2, !1111, !DIExpression(), !1112)
  %5 = call i64 @thread_create(ptr noundef @once_worker, ptr noundef null), !dbg !1113
  store i64 %5, ptr %2, align 8, !dbg !1112
  %6 = load i64, ptr %1, align 8, !dbg !1114
  %7 = call ptr @thread_join(i64 noundef %6), !dbg !1115
  %8 = load i64, ptr %2, align 8, !dbg !1116
  %9 = call ptr @thread_join(i64 noundef %8), !dbg !1117
  %10 = load i32, ptr @once_calls, align 4, !dbg !1118
  %11 = icmp eq i32 %10, 1, !dbg !1118
  br i1 %11, label %12, label %13, !dbg !1121

12:                                               ; preds = %0
  br label %14, !dbg !1121

13:                                               ; preds = %0
  call void @__assert_fail(ptr noundef @.str.11, ptr noundef @.str.1, i32 noundef 488, ptr noundef @__PRETTY_FUNCTION__.once_test) #6, !dbg !1118
  unreachable, !dbg !1118

14:                                               ; preds = %12
    #dbg_declare(ptr %3, !1122, !DIExpression(), !1123)
  %15 = call i32 @pthread_once(ptr noundef @once1, ptr noundef @once_init1), !dbg !1124
  store i32 %15, ptr %3, align 4, !dbg !1123
  %16 = load i32, ptr %3, align 4, !dbg !1125
  %17 = icmp eq i32 %16, 0, !dbg !1125
  br i1 %17, label %18, label %19, !dbg !1128

18:                                               ; preds = %14
  br label %20, !dbg !1128

19:                                               ; preds = %14
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 491, ptr noundef @__PRETTY_FUNCTION__.once_test) #6, !dbg !1125
  unreachable, !dbg !1125

20:                                               ; preds = %18
  %21 = call i32 @pthread_once(ptr noundef @once1, ptr noundef @once_init1), !dbg !1129
  store i32 %21, ptr %3, align 4, !dbg !1130
  %22 = load i32, ptr %3, align 4, !dbg !1131
  %23 = icmp eq i32 %22, 0, !dbg !1131
  br i1 %23, label %24, label %25, !dbg !1134

24:                                               ; preds = %20
  br label %26, !dbg !1134

25:                                               ; preds = %20
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 493, ptr noundef @__PRETTY_FUNCTION__.once_test) #6, !dbg !1131
  unreachable, !dbg !1131

26:                                               ; preds = %24
  %27 = load i32, ptr @once_calls, align 4, !dbg !1135
  %28 = icmp eq i32 %27, 2, !dbg !1135
  br i1 %28, label %29, label %30, !dbg !1138

29:                                               ; preds = %26
  br label %31, !dbg !1138

30:                                               ; preds = %26
  call void @__assert_fail(ptr noundef @.str.12, ptr noundef @.str.1, i32 noundef 494, ptr noundef @__PRETTY_FUNCTION__.once_test) #6, !dbg !1135
  unreachable, !dbg !1135

31:                                               ; preds = %29
  ret void, !dbg !1139
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !1140 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %2 = call i32 @__VERIFIER_nondet_int(), !dbg !1143
  switch i32 %2, label %9 [
    i32 1, label %3
    i32 2, label %4
    i32 3, label %5
    i32 4, label %6
    i32 5, label %7
    i32 6, label %8
  ], !dbg !1144

3:                                                ; preds = %0
  call void @mutex_test(), !dbg !1145
  br label %9, !dbg !1147

4:                                                ; preds = %0
  call void @cond_test(), !dbg !1148
  br label %9, !dbg !1149

5:                                                ; preds = %0
  call void @rwlock_test(), !dbg !1150
  br label %9, !dbg !1151

6:                                                ; preds = %0
  call void @key_test(), !dbg !1152
  br label %9, !dbg !1153

7:                                                ; preds = %0
  call void @detach_test(), !dbg !1154
  br label %9, !dbg !1155

8:                                                ; preds = %0
  call void @once_test(), !dbg !1156
  br label %9, !dbg !1157

9:                                                ; preds = %0, %8, %7, %6, %5, %4, %3
  %10 = load i32, ptr %1, align 4, !dbg !1158
  ret i32 %10, !dbg !1158
}

declare i32 @__VERIFIER_nondet_int() #3

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { cold noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind willreturn memory(none) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { cold noreturn nounwind }
attributes #7 = { nounwind willreturn memory(none) }

!llvm.dbg.cu = !{!72}
!llvm.module.flags = !{!267, !268, !269, !270, !271, !272, !273}
!llvm.ident = !{!274}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 18, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/miscellaneous/pthread.c", directory: "/repo", checksumkind: CSK_MD5, checksum: "4b554297cefeff6fe6f96c852b14955c")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 96, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 12)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 18, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 280, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 35)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 18, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 408, elements: !16)
!15 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!16 = !{!17}
!17 = !DISubrange(count: 51)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !2, line: 27, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 232, elements: !21)
!21 = !{!22}
!22 = !DISubrange(count: 29)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(scope: null, file: !2, line: 47, type: !25, isLocal: true, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 400, elements: !26)
!26 = !{!27}
!27 = !DISubrange(count: 50)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !2, line: 73, type: !30, isLocal: true, isDefinition: true)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 304, elements: !31)
!31 = !{!32}
!32 = !DISubrange(count: 38)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(scope: null, file: !2, line: 79, type: !35, isLocal: true, isDefinition: true)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 280, elements: !10)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(scope: null, file: !2, line: 92, type: !38, isLocal: true, isDefinition: true)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 296, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 37)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(scope: null, file: !2, line: 106, type: !43, isLocal: true, isDefinition: true)
!43 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !44)
!44 = !{!45}
!45 = !DISubrange(count: 9)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(scope: null, file: !2, line: 106, type: !48, isLocal: true, isDefinition: true)
!48 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 144, elements: !49)
!49 = !{!50}
!50 = !DISubrange(count: 18)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(scope: null, file: !2, line: 115, type: !53, isLocal: true, isDefinition: true)
!53 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 64, elements: !54)
!54 = !{!55}
!55 = !DISubrange(count: 8)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(scope: null, file: !2, line: 147, type: !58, isLocal: true, isDefinition: true)
!58 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 264, elements: !59)
!59 = !{!60}
!60 = !DISubrange(count: 33)
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(scope: null, file: !2, line: 159, type: !63, isLocal: true, isDefinition: true)
!63 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 288, elements: !64)
!64 = !{!65}
!65 = !DISubrange(count: 36)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(scope: null, file: !2, line: 165, type: !35, isLocal: true, isDefinition: true)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(scope: null, file: !2, line: 171, type: !30, isLocal: true, isDefinition: true)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "phase", scope: !72, file: !2, line: 193, type: !173, isLocal: false, isDefinition: true)
!72 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Debian clang version 19.1.7 (3)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !73, retainedTypes: !99, globals: !102, splitDebugInlining: false, nameTableKind: None)
!73 = !{!74, !86, !91, !95}
!74 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !75, line: 47, baseType: !76, size: 32, elements: !77)
!75 = !DIFile(filename: "/usr/include/pthread.h", directory: "", checksumkind: CSK_MD5, checksum: "7b5192e04c72cf90a027fe29fab3aa28")
!76 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!77 = !{!78, !79, !80, !81, !82, !83, !84, !85}
!78 = !DIEnumerator(name: "PTHREAD_MUTEX_TIMED_NP", value: 0)
!79 = !DIEnumerator(name: "PTHREAD_MUTEX_RECURSIVE_NP", value: 1)
!80 = !DIEnumerator(name: "PTHREAD_MUTEX_ERRORCHECK_NP", value: 2)
!81 = !DIEnumerator(name: "PTHREAD_MUTEX_ADAPTIVE_NP", value: 3)
!82 = !DIEnumerator(name: "PTHREAD_MUTEX_NORMAL", value: 0)
!83 = !DIEnumerator(name: "PTHREAD_MUTEX_RECURSIVE", value: 1)
!84 = !DIEnumerator(name: "PTHREAD_MUTEX_ERRORCHECK", value: 2)
!85 = !DIEnumerator(name: "PTHREAD_MUTEX_DEFAULT", value: 0)
!86 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !75, line: 81, baseType: !76, size: 32, elements: !87)
!87 = !{!88, !89, !90}
!88 = !DIEnumerator(name: "PTHREAD_PRIO_NONE", value: 0)
!89 = !DIEnumerator(name: "PTHREAD_PRIO_INHERIT", value: 1)
!90 = !DIEnumerator(name: "PTHREAD_PRIO_PROTECT", value: 2)
!91 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !75, line: 144, baseType: !76, size: 32, elements: !92)
!92 = !{!93, !94}
!93 = !DIEnumerator(name: "PTHREAD_PROCESS_PRIVATE", value: 0)
!94 = !DIEnumerator(name: "PTHREAD_PROCESS_SHARED", value: 1)
!95 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !75, line: 37, baseType: !76, size: 32, elements: !96)
!96 = !{!97, !98}
!97 = !DIEnumerator(name: "PTHREAD_CREATE_JOINABLE", value: 0)
!98 = !DIEnumerator(name: "PTHREAD_CREATE_DETACHED", value: 1)
!99 = !{!100, !101}
!100 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!102 = !{!0, !7, !12, !18, !23, !28, !33, !36, !41, !46, !51, !56, !61, !66, !68, !70, !103, !106, !111, !116, !121, !126, !128, !130, !135, !140, !145, !150, !153, !155, !157, !162, !167, !169, !174, !176, !181, !184, !187, !189, !191, !220, !256, !260, !263, !265}
!103 = !DIGlobalVariableExpression(var: !104, expr: !DIExpression())
!104 = distinct !DIGlobalVariable(scope: null, file: !2, line: 245, type: !105, isLocal: true, isDefinition: true)
!105 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 144, elements: !49)
!106 = !DIGlobalVariableExpression(var: !107, expr: !DIExpression())
!107 = distinct !DIGlobalVariable(scope: null, file: !2, line: 245, type: !108, isLocal: true, isDefinition: true)
!108 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 136, elements: !109)
!109 = !{!110}
!110 = !DISubrange(count: 17)
!111 = !DIGlobalVariableExpression(var: !112, expr: !DIExpression())
!112 = distinct !DIGlobalVariable(scope: null, file: !2, line: 262, type: !113, isLocal: true, isDefinition: true)
!113 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 336, elements: !114)
!114 = !{!115}
!115 = !DISubrange(count: 42)
!116 = !DIGlobalVariableExpression(var: !117, expr: !DIExpression())
!117 = distinct !DIGlobalVariable(scope: null, file: !2, line: 278, type: !118, isLocal: true, isDefinition: true)
!118 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 320, elements: !119)
!119 = !{!120}
!120 = !DISubrange(count: 40)
!121 = !DIGlobalVariableExpression(var: !122, expr: !DIExpression())
!122 = distinct !DIGlobalVariable(scope: null, file: !2, line: 284, type: !123, isLocal: true, isDefinition: true)
!123 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 312, elements: !124)
!124 = !{!125}
!125 = !DISubrange(count: 39)
!126 = !DIGlobalVariableExpression(var: !127, expr: !DIExpression())
!127 = distinct !DIGlobalVariable(scope: null, file: !2, line: 297, type: !123, isLocal: true, isDefinition: true)
!128 = !DIGlobalVariableExpression(var: !129, expr: !DIExpression())
!129 = distinct !DIGlobalVariable(scope: null, file: !2, line: 310, type: !123, isLocal: true, isDefinition: true)
!130 = !DIGlobalVariableExpression(var: !131, expr: !DIExpression())
!131 = distinct !DIGlobalVariable(scope: null, file: !2, line: 322, type: !132, isLocal: true, isDefinition: true)
!132 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 152, elements: !133)
!133 = !{!134}
!134 = !DISubrange(count: 19)
!135 = !DIGlobalVariableExpression(var: !136, expr: !DIExpression())
!136 = distinct !DIGlobalVariable(scope: null, file: !2, line: 372, type: !137, isLocal: true, isDefinition: true)
!137 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 200, elements: !138)
!138 = !{!139}
!139 = !DISubrange(count: 25)
!140 = !DIGlobalVariableExpression(var: !141, expr: !DIExpression())
!141 = distinct !DIGlobalVariable(scope: null, file: !2, line: 375, type: !142, isLocal: true, isDefinition: true)
!142 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 224, elements: !143)
!143 = !{!144}
!144 = !DISubrange(count: 28)
!145 = !DIGlobalVariableExpression(var: !146, expr: !DIExpression())
!146 = distinct !DIGlobalVariable(scope: null, file: !2, line: 391, type: !147, isLocal: true, isDefinition: true)
!147 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 128, elements: !148)
!148 = !{!149}
!149 = !DISubrange(count: 16)
!150 = !DIGlobalVariableExpression(var: !151, expr: !DIExpression())
!151 = distinct !DIGlobalVariable(scope: null, file: !2, line: 405, type: !152, isLocal: true, isDefinition: true)
!152 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 296, elements: !39)
!153 = !DIGlobalVariableExpression(var: !154, expr: !DIExpression())
!154 = distinct !DIGlobalVariable(scope: null, file: !2, line: 420, type: !58, isLocal: true, isDefinition: true)
!155 = !DIGlobalVariableExpression(var: !156, expr: !DIExpression())
!156 = distinct !DIGlobalVariable(scope: null, file: !2, line: 423, type: !3, isLocal: true, isDefinition: true)
!157 = !DIGlobalVariableExpression(var: !158, expr: !DIExpression())
!158 = distinct !DIGlobalVariable(scope: null, file: !2, line: 434, type: !159, isLocal: true, isDefinition: true)
!159 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 248, elements: !160)
!160 = !{!161}
!161 = !DISubrange(count: 31)
!162 = !DIGlobalVariableExpression(var: !163, expr: !DIExpression())
!163 = distinct !DIGlobalVariable(scope: null, file: !2, line: 436, type: !164, isLocal: true, isDefinition: true)
!164 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 432, elements: !165)
!165 = !{!166}
!166 = !DISubrange(count: 54)
!167 = !DIGlobalVariableExpression(var: !168, expr: !DIExpression())
!168 = distinct !DIGlobalVariable(scope: null, file: !2, line: 440, type: !164, isLocal: true, isDefinition: true)
!169 = !DIGlobalVariableExpression(var: !170, expr: !DIExpression())
!170 = distinct !DIGlobalVariable(name: "once0", scope: !72, file: !2, line: 458, type: !171, isLocal: false, isDefinition: true)
!171 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_once_t", file: !172, line: 53, baseType: !173)
!172 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "8e06fe5d0f3f3d4ee6a7a8929dd2b809")
!173 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!174 = !DIGlobalVariableExpression(var: !175, expr: !DIExpression())
!175 = distinct !DIGlobalVariable(name: "once1", scope: !72, file: !2, line: 459, type: !171, isLocal: false, isDefinition: true)
!176 = !DIGlobalVariableExpression(var: !177, expr: !DIExpression())
!177 = distinct !DIGlobalVariable(scope: null, file: !2, line: 477, type: !178, isLocal: true, isDefinition: true)
!178 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 208, elements: !179)
!179 = !{!180}
!180 = !DISubrange(count: 26)
!181 = !DIGlobalVariableExpression(var: !182, expr: !DIExpression())
!182 = distinct !DIGlobalVariable(scope: null, file: !2, line: 478, type: !183, isLocal: true, isDefinition: true)
!183 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 136, elements: !109)
!184 = !DIGlobalVariableExpression(var: !185, expr: !DIExpression())
!185 = distinct !DIGlobalVariable(scope: null, file: !2, line: 488, type: !186, isLocal: true, isDefinition: true)
!186 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 128, elements: !148)
!187 = !DIGlobalVariableExpression(var: !188, expr: !DIExpression())
!188 = distinct !DIGlobalVariable(scope: null, file: !2, line: 488, type: !108, isLocal: true, isDefinition: true)
!189 = !DIGlobalVariableExpression(var: !190, expr: !DIExpression())
!190 = distinct !DIGlobalVariable(scope: null, file: !2, line: 494, type: !186, isLocal: true, isDefinition: true)
!191 = !DIGlobalVariableExpression(var: !192, expr: !DIExpression())
!192 = distinct !DIGlobalVariable(name: "cond_mutex", scope: !72, file: !2, line: 191, type: !193, isLocal: false, isDefinition: true)
!193 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !172, line: 72, baseType: !194)
!194 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !172, line: 67, size: 320, elements: !195)
!195 = !{!196, !216, !218}
!196 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !194, file: !172, line: 69, baseType: !197, size: 320)
!197 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !198, line: 22, size: 320, elements: !199)
!198 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_mutex.h", directory: "", checksumkind: CSK_MD5, checksum: "dd3989155840df74989f662ad537bbcc")
!199 = !{!200, !201, !202, !203, !204, !205, !207, !208}
!200 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !197, file: !198, line: 24, baseType: !173, size: 32)
!201 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !197, file: !198, line: 25, baseType: !76, size: 32, offset: 32)
!202 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !197, file: !198, line: 26, baseType: !173, size: 32, offset: 64)
!203 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !197, file: !198, line: 28, baseType: !76, size: 32, offset: 96)
!204 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !197, file: !198, line: 32, baseType: !173, size: 32, offset: 128)
!205 = !DIDerivedType(tag: DW_TAG_member, name: "__spins", scope: !197, file: !198, line: 34, baseType: !206, size: 16, offset: 160)
!206 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!207 = !DIDerivedType(tag: DW_TAG_member, name: "__elision", scope: !197, file: !198, line: 35, baseType: !206, size: 16, offset: 176)
!208 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !197, file: !198, line: 36, baseType: !209, size: 128, offset: 192)
!209 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_list_t", file: !210, line: 55, baseType: !211)
!210 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/thread-shared-types.h", directory: "", checksumkind: CSK_MD5, checksum: "4de73b5923ab08445dd348713aeb0a37")
!211 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_list", file: !210, line: 51, size: 128, elements: !212)
!212 = !{!213, !215}
!213 = !DIDerivedType(tag: DW_TAG_member, name: "__prev", scope: !211, file: !210, line: 53, baseType: !214, size: 64)
!214 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !211, size: 64)
!215 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !211, file: !210, line: 54, baseType: !214, size: 64, offset: 64)
!216 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !194, file: !172, line: 70, baseType: !217, size: 320)
!217 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 320, elements: !119)
!218 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !194, file: !172, line: 71, baseType: !219, size: 64)
!219 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!220 = !DIGlobalVariableExpression(var: !221, expr: !DIExpression())
!221 = distinct !DIGlobalVariable(name: "cond", scope: !72, file: !2, line: 192, type: !222, isLocal: false, isDefinition: true)
!222 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !172, line: 80, baseType: !223)
!223 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !172, line: 75, size: 384, elements: !224)
!224 = !{!225, !250, !254}
!225 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !223, file: !172, line: 77, baseType: !226, size: 384)
!226 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_cond_s", file: !210, line: 94, size: 384, elements: !227)
!227 = !{!228, !240, !241, !245, !246, !247, !248, !249}
!228 = !DIDerivedType(tag: DW_TAG_member, name: "__wseq", scope: !226, file: !210, line: 96, baseType: !229, size: 64)
!229 = !DIDerivedType(tag: DW_TAG_typedef, name: "__atomic_wide_counter", file: !230, line: 33, baseType: !231)
!230 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/atomic_wide_counter.h", directory: "", checksumkind: CSK_MD5, checksum: "c55e0cb273510139e5571d2f731f6daf")
!231 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !230, line: 25, size: 64, elements: !232)
!232 = !{!233, !235}
!233 = !DIDerivedType(tag: DW_TAG_member, name: "__value64", scope: !231, file: !230, line: 27, baseType: !234, size: 64)
!234 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!235 = !DIDerivedType(tag: DW_TAG_member, name: "__value32", scope: !231, file: !230, line: 32, baseType: !236, size: 64)
!236 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !231, file: !230, line: 28, size: 64, elements: !237)
!237 = !{!238, !239}
!238 = !DIDerivedType(tag: DW_TAG_member, name: "__low", scope: !236, file: !230, line: 30, baseType: !76, size: 32)
!239 = !DIDerivedType(tag: DW_TAG_member, name: "__high", scope: !236, file: !230, line: 31, baseType: !76, size: 32, offset: 32)
!240 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_start", scope: !226, file: !210, line: 97, baseType: !229, size: 64, offset: 64)
!241 = !DIDerivedType(tag: DW_TAG_member, name: "__g_size", scope: !226, file: !210, line: 98, baseType: !242, size: 64, offset: 128)
!242 = !DICompositeType(tag: DW_TAG_array_type, baseType: !76, size: 64, elements: !243)
!243 = !{!244}
!244 = !DISubrange(count: 2)
!245 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_orig_size", scope: !226, file: !210, line: 99, baseType: !76, size: 32, offset: 192)
!246 = !DIDerivedType(tag: DW_TAG_member, name: "__wrefs", scope: !226, file: !210, line: 100, baseType: !76, size: 32, offset: 224)
!247 = !DIDerivedType(tag: DW_TAG_member, name: "__g_signals", scope: !226, file: !210, line: 101, baseType: !242, size: 64, offset: 256)
!248 = !DIDerivedType(tag: DW_TAG_member, name: "__unused_initialized_1", scope: !226, file: !210, line: 102, baseType: !76, size: 32, offset: 320)
!249 = !DIDerivedType(tag: DW_TAG_member, name: "__unused_initialized_2", scope: !226, file: !210, line: 103, baseType: !76, size: 32, offset: 352)
!250 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !223, file: !172, line: 78, baseType: !251, size: 384)
!251 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 384, elements: !252)
!252 = !{!253}
!253 = !DISubrange(count: 48)
!254 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !223, file: !172, line: 79, baseType: !255, size: 64)
!255 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!256 = !DIGlobalVariableExpression(var: !257, expr: !DIExpression())
!257 = distinct !DIGlobalVariable(name: "latest_thread", scope: !72, file: !2, line: 359, type: !258, isLocal: false, isDefinition: true)
!258 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !172, line: 27, baseType: !259)
!259 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!260 = !DIGlobalVariableExpression(var: !261, expr: !DIExpression())
!261 = distinct !DIGlobalVariable(name: "local_data", scope: !72, file: !2, line: 360, type: !262, isLocal: false, isDefinition: true)
!262 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_key_t", file: !172, line: 49, baseType: !76)
!263 = !DIGlobalVariableExpression(var: !264, expr: !DIExpression())
!264 = distinct !DIGlobalVariable(name: "once_calls", scope: !72, file: !2, line: 460, type: !173, isLocal: false, isDefinition: true)
!265 = !DIGlobalVariableExpression(var: !266, expr: !DIExpression())
!266 = distinct !DIGlobalVariable(name: "once_value", scope: !72, file: !2, line: 461, type: !173, isLocal: false, isDefinition: true)
!267 = !{i32 7, !"Dwarf Version", i32 5}
!268 = !{i32 2, !"Debug Info Version", i32 3}
!269 = !{i32 1, !"wchar_size", i32 4}
!270 = !{i32 8, !"PIC Level", i32 2}
!271 = !{i32 7, !"PIE Level", i32 2}
!272 = !{i32 7, !"uwtable", i32 2}
!273 = !{i32 7, !"frame-pointer", i32 2}
!274 = !{!"Debian clang version 19.1.7 (3)"}
!275 = distinct !DISubprogram(name: "thread_create", scope: !2, file: !2, line: 12, type: !276, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!276 = !DISubroutineType(types: !277)
!277 = !{!258, !278, !101}
!278 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !279, size: 64)
!279 = !DISubroutineType(types: !280)
!280 = !{!101, !101}
!281 = !{}
!282 = !DILocalVariable(name: "runner", arg: 1, scope: !275, file: !2, line: 12, type: !278)
!283 = !DILocation(line: 12, column: 32, scope: !275)
!284 = !DILocalVariable(name: "data", arg: 2, scope: !275, file: !2, line: 12, type: !101)
!285 = !DILocation(line: 12, column: 54, scope: !275)
!286 = !DILocalVariable(name: "id", scope: !275, file: !2, line: 14, type: !258)
!287 = !DILocation(line: 14, column: 15, scope: !275)
!288 = !DILocalVariable(name: "attr", scope: !275, file: !2, line: 15, type: !289)
!289 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !172, line: 62, baseType: !290)
!290 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !172, line: 56, size: 448, elements: !291)
!291 = !{!292, !296}
!292 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !290, file: !172, line: 58, baseType: !293, size: 448)
!293 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 448, elements: !294)
!294 = !{!295}
!295 = !DISubrange(count: 56)
!296 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !290, file: !172, line: 59, baseType: !219, size: 64)
!297 = !DILocation(line: 15, column: 20, scope: !275)
!298 = !DILocation(line: 16, column: 5, scope: !275)
!299 = !DILocalVariable(name: "status", scope: !275, file: !2, line: 17, type: !173)
!300 = !DILocation(line: 17, column: 9, scope: !275)
!301 = !DILocation(line: 17, column: 45, scope: !275)
!302 = !DILocation(line: 17, column: 53, scope: !275)
!303 = !DILocation(line: 17, column: 18, scope: !275)
!304 = !DILocation(line: 18, column: 5, scope: !305)
!305 = distinct !DILexicalBlock(scope: !306, file: !2, line: 18, column: 5)
!306 = distinct !DILexicalBlock(scope: !275, file: !2, line: 18, column: 5)
!307 = !DILocation(line: 18, column: 5, scope: !306)
!308 = !DILocation(line: 19, column: 5, scope: !275)
!309 = !DILocation(line: 20, column: 12, scope: !275)
!310 = !DILocation(line: 20, column: 5, scope: !275)
!311 = distinct !DISubprogram(name: "thread_join", scope: !2, file: !2, line: 23, type: !312, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!312 = !DISubroutineType(types: !313)
!313 = !{!101, !258}
!314 = !DILocalVariable(name: "id", arg: 1, scope: !311, file: !2, line: 23, type: !258)
!315 = !DILocation(line: 23, column: 29, scope: !311)
!316 = !DILocalVariable(name: "result", scope: !311, file: !2, line: 25, type: !101)
!317 = !DILocation(line: 25, column: 11, scope: !311)
!318 = !DILocalVariable(name: "status", scope: !311, file: !2, line: 26, type: !173)
!319 = !DILocation(line: 26, column: 9, scope: !311)
!320 = !DILocation(line: 26, column: 31, scope: !311)
!321 = !DILocation(line: 26, column: 18, scope: !311)
!322 = !DILocation(line: 27, column: 5, scope: !323)
!323 = distinct !DILexicalBlock(scope: !324, file: !2, line: 27, column: 5)
!324 = distinct !DILexicalBlock(scope: !311, file: !2, line: 27, column: 5)
!325 = !DILocation(line: 27, column: 5, scope: !324)
!326 = !DILocation(line: 28, column: 12, scope: !311)
!327 = !DILocation(line: 28, column: 5, scope: !311)
!328 = distinct !DISubprogram(name: "mutex_init", scope: !2, file: !2, line: 41, type: !329, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!329 = !DISubroutineType(types: !330)
!330 = !{null, !331, !173, !173, !173}
!331 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !193, size: 64)
!332 = !DILocalVariable(name: "lock", arg: 1, scope: !328, file: !2, line: 41, type: !331)
!333 = !DILocation(line: 41, column: 34, scope: !328)
!334 = !DILocalVariable(name: "type", arg: 2, scope: !328, file: !2, line: 41, type: !173)
!335 = !DILocation(line: 41, column: 44, scope: !328)
!336 = !DILocalVariable(name: "protocol", arg: 3, scope: !328, file: !2, line: 41, type: !173)
!337 = !DILocation(line: 41, column: 54, scope: !328)
!338 = !DILocalVariable(name: "prioceiling", arg: 4, scope: !328, file: !2, line: 41, type: !173)
!339 = !DILocation(line: 41, column: 68, scope: !328)
!340 = !DILocalVariable(name: "status", scope: !328, file: !2, line: 43, type: !173)
!341 = !DILocation(line: 43, column: 9, scope: !328)
!342 = !DILocalVariable(name: "value", scope: !328, file: !2, line: 44, type: !173)
!343 = !DILocation(line: 44, column: 9, scope: !328)
!344 = !DILocalVariable(name: "attributes", scope: !328, file: !2, line: 45, type: !345)
!345 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !172, line: 36, baseType: !346)
!346 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !172, line: 32, size: 32, elements: !347)
!347 = !{!348, !352}
!348 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !346, file: !172, line: 34, baseType: !349, size: 32)
!349 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 32, elements: !350)
!350 = !{!351}
!351 = !DISubrange(count: 4)
!352 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !346, file: !172, line: 35, baseType: !173, size: 32)
!353 = !DILocation(line: 45, column: 25, scope: !328)
!354 = !DILocation(line: 46, column: 14, scope: !328)
!355 = !DILocation(line: 46, column: 12, scope: !328)
!356 = !DILocation(line: 47, column: 5, scope: !357)
!357 = distinct !DILexicalBlock(scope: !358, file: !2, line: 47, column: 5)
!358 = distinct !DILexicalBlock(scope: !328, file: !2, line: 47, column: 5)
!359 = !DILocation(line: 47, column: 5, scope: !358)
!360 = !DILocation(line: 49, column: 53, scope: !328)
!361 = !DILocation(line: 49, column: 14, scope: !328)
!362 = !DILocation(line: 49, column: 12, scope: !328)
!363 = !DILocation(line: 50, column: 5, scope: !364)
!364 = distinct !DILexicalBlock(scope: !365, file: !2, line: 50, column: 5)
!365 = distinct !DILexicalBlock(scope: !328, file: !2, line: 50, column: 5)
!366 = !DILocation(line: 50, column: 5, scope: !365)
!367 = !DILocation(line: 51, column: 14, scope: !328)
!368 = !DILocation(line: 51, column: 12, scope: !328)
!369 = !DILocation(line: 52, column: 5, scope: !370)
!370 = distinct !DILexicalBlock(scope: !371, file: !2, line: 52, column: 5)
!371 = distinct !DILexicalBlock(scope: !328, file: !2, line: 52, column: 5)
!372 = !DILocation(line: 52, column: 5, scope: !371)
!373 = !DILocation(line: 54, column: 57, scope: !328)
!374 = !DILocation(line: 54, column: 14, scope: !328)
!375 = !DILocation(line: 54, column: 12, scope: !328)
!376 = !DILocation(line: 55, column: 5, scope: !377)
!377 = distinct !DILexicalBlock(scope: !378, file: !2, line: 55, column: 5)
!378 = distinct !DILexicalBlock(scope: !328, file: !2, line: 55, column: 5)
!379 = !DILocation(line: 55, column: 5, scope: !378)
!380 = !DILocation(line: 56, column: 14, scope: !328)
!381 = !DILocation(line: 56, column: 12, scope: !328)
!382 = !DILocation(line: 57, column: 5, scope: !383)
!383 = distinct !DILexicalBlock(scope: !384, file: !2, line: 57, column: 5)
!384 = distinct !DILexicalBlock(scope: !328, file: !2, line: 57, column: 5)
!385 = !DILocation(line: 57, column: 5, scope: !384)
!386 = !DILocation(line: 59, column: 60, scope: !328)
!387 = !DILocation(line: 59, column: 14, scope: !328)
!388 = !DILocation(line: 59, column: 12, scope: !328)
!389 = !DILocation(line: 60, column: 5, scope: !390)
!390 = distinct !DILexicalBlock(scope: !391, file: !2, line: 60, column: 5)
!391 = distinct !DILexicalBlock(scope: !328, file: !2, line: 60, column: 5)
!392 = !DILocation(line: 60, column: 5, scope: !391)
!393 = !DILocation(line: 61, column: 14, scope: !328)
!394 = !DILocation(line: 61, column: 12, scope: !328)
!395 = !DILocation(line: 62, column: 5, scope: !396)
!396 = distinct !DILexicalBlock(scope: !397, file: !2, line: 62, column: 5)
!397 = distinct !DILexicalBlock(scope: !328, file: !2, line: 62, column: 5)
!398 = !DILocation(line: 62, column: 5, scope: !397)
!399 = !DILocation(line: 64, column: 33, scope: !328)
!400 = !DILocation(line: 64, column: 14, scope: !328)
!401 = !DILocation(line: 64, column: 12, scope: !328)
!402 = !DILocation(line: 65, column: 5, scope: !403)
!403 = distinct !DILexicalBlock(scope: !404, file: !2, line: 65, column: 5)
!404 = distinct !DILexicalBlock(scope: !328, file: !2, line: 65, column: 5)
!405 = !DILocation(line: 65, column: 5, scope: !404)
!406 = !DILocation(line: 66, column: 14, scope: !328)
!407 = !DILocation(line: 66, column: 12, scope: !328)
!408 = !DILocation(line: 67, column: 5, scope: !409)
!409 = distinct !DILexicalBlock(scope: !410, file: !2, line: 67, column: 5)
!410 = distinct !DILexicalBlock(scope: !328, file: !2, line: 67, column: 5)
!411 = !DILocation(line: 67, column: 5, scope: !410)
!412 = !DILocation(line: 68, column: 1, scope: !328)
!413 = distinct !DISubprogram(name: "mutex_destroy", scope: !2, file: !2, line: 70, type: !414, scopeLine: 71, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!414 = !DISubroutineType(types: !415)
!415 = !{null, !331}
!416 = !DILocalVariable(name: "lock", arg: 1, scope: !413, file: !2, line: 70, type: !331)
!417 = !DILocation(line: 70, column: 37, scope: !413)
!418 = !DILocalVariable(name: "status", scope: !413, file: !2, line: 72, type: !173)
!419 = !DILocation(line: 72, column: 9, scope: !413)
!420 = !DILocation(line: 72, column: 40, scope: !413)
!421 = !DILocation(line: 72, column: 18, scope: !413)
!422 = !DILocation(line: 73, column: 5, scope: !423)
!423 = distinct !DILexicalBlock(scope: !424, file: !2, line: 73, column: 5)
!424 = distinct !DILexicalBlock(scope: !413, file: !2, line: 73, column: 5)
!425 = !DILocation(line: 73, column: 5, scope: !424)
!426 = !DILocation(line: 74, column: 1, scope: !413)
!427 = distinct !DISubprogram(name: "mutex_lock", scope: !2, file: !2, line: 76, type: !414, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!428 = !DILocalVariable(name: "lock", arg: 1, scope: !427, file: !2, line: 76, type: !331)
!429 = !DILocation(line: 76, column: 34, scope: !427)
!430 = !DILocalVariable(name: "status", scope: !427, file: !2, line: 78, type: !173)
!431 = !DILocation(line: 78, column: 9, scope: !427)
!432 = !DILocation(line: 78, column: 37, scope: !427)
!433 = !DILocation(line: 78, column: 18, scope: !427)
!434 = !DILocation(line: 79, column: 5, scope: !435)
!435 = distinct !DILexicalBlock(scope: !436, file: !2, line: 79, column: 5)
!436 = distinct !DILexicalBlock(scope: !427, file: !2, line: 79, column: 5)
!437 = !DILocation(line: 79, column: 5, scope: !436)
!438 = !DILocation(line: 80, column: 1, scope: !427)
!439 = distinct !DISubprogram(name: "mutex_trylock", scope: !2, file: !2, line: 82, type: !440, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!440 = !DISubroutineType(types: !441)
!441 = !{!442, !331}
!442 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!443 = !DILocalVariable(name: "lock", arg: 1, scope: !439, file: !2, line: 82, type: !331)
!444 = !DILocation(line: 82, column: 37, scope: !439)
!445 = !DILocalVariable(name: "status", scope: !439, file: !2, line: 84, type: !173)
!446 = !DILocation(line: 84, column: 9, scope: !439)
!447 = !DILocation(line: 84, column: 40, scope: !439)
!448 = !DILocation(line: 84, column: 18, scope: !439)
!449 = !DILocation(line: 86, column: 12, scope: !439)
!450 = !DILocation(line: 86, column: 19, scope: !439)
!451 = !DILocation(line: 86, column: 5, scope: !439)
!452 = distinct !DISubprogram(name: "mutex_unlock", scope: !2, file: !2, line: 89, type: !414, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!453 = !DILocalVariable(name: "lock", arg: 1, scope: !452, file: !2, line: 89, type: !331)
!454 = !DILocation(line: 89, column: 36, scope: !452)
!455 = !DILocalVariable(name: "status", scope: !452, file: !2, line: 91, type: !173)
!456 = !DILocation(line: 91, column: 9, scope: !452)
!457 = !DILocation(line: 91, column: 39, scope: !452)
!458 = !DILocation(line: 91, column: 18, scope: !452)
!459 = !DILocation(line: 92, column: 5, scope: !460)
!460 = distinct !DILexicalBlock(scope: !461, file: !2, line: 92, column: 5)
!461 = distinct !DILexicalBlock(scope: !452, file: !2, line: 92, column: 5)
!462 = !DILocation(line: 92, column: 5, scope: !461)
!463 = !DILocation(line: 93, column: 1, scope: !452)
!464 = distinct !DISubprogram(name: "mutex_test", scope: !2, file: !2, line: 95, type: !465, scopeLine: 96, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!465 = !DISubroutineType(types: !466)
!466 = !{null}
!467 = !DILocalVariable(name: "mutex0", scope: !464, file: !2, line: 97, type: !193)
!468 = !DILocation(line: 97, column: 21, scope: !464)
!469 = !DILocalVariable(name: "mutex1", scope: !464, file: !2, line: 98, type: !193)
!470 = !DILocation(line: 98, column: 21, scope: !464)
!471 = !DILocation(line: 100, column: 5, scope: !464)
!472 = !DILocation(line: 101, column: 5, scope: !464)
!473 = !DILocation(line: 104, column: 9, scope: !474)
!474 = distinct !DILexicalBlock(scope: !464, file: !2, line: 103, column: 5)
!475 = !DILocalVariable(name: "success", scope: !474, file: !2, line: 105, type: !442)
!476 = !DILocation(line: 105, column: 14, scope: !474)
!477 = !DILocation(line: 105, column: 24, scope: !474)
!478 = !DILocation(line: 106, column: 9, scope: !479)
!479 = distinct !DILexicalBlock(scope: !480, file: !2, line: 106, column: 9)
!480 = distinct !DILexicalBlock(scope: !474, file: !2, line: 106, column: 9)
!481 = !DILocation(line: 106, column: 9, scope: !480)
!482 = !DILocation(line: 107, column: 9, scope: !474)
!483 = !DILocation(line: 111, column: 9, scope: !484)
!484 = distinct !DILexicalBlock(scope: !464, file: !2, line: 110, column: 5)
!485 = !DILocalVariable(name: "success", scope: !486, file: !2, line: 114, type: !442)
!486 = distinct !DILexicalBlock(scope: !484, file: !2, line: 113, column: 9)
!487 = !DILocation(line: 114, column: 18, scope: !486)
!488 = !DILocation(line: 114, column: 28, scope: !486)
!489 = !DILocation(line: 115, column: 13, scope: !490)
!490 = distinct !DILexicalBlock(scope: !491, file: !2, line: 115, column: 13)
!491 = distinct !DILexicalBlock(scope: !486, file: !2, line: 115, column: 13)
!492 = !DILocation(line: 115, column: 13, scope: !491)
!493 = !DILocation(line: 116, column: 13, scope: !486)
!494 = !DILocalVariable(name: "success", scope: !495, file: !2, line: 120, type: !442)
!495 = distinct !DILexicalBlock(scope: !484, file: !2, line: 119, column: 9)
!496 = !DILocation(line: 120, column: 18, scope: !495)
!497 = !DILocation(line: 120, column: 28, scope: !495)
!498 = !DILocation(line: 121, column: 13, scope: !499)
!499 = distinct !DILexicalBlock(scope: !500, file: !2, line: 121, column: 13)
!500 = distinct !DILexicalBlock(scope: !495, file: !2, line: 121, column: 13)
!501 = !DILocation(line: 121, column: 13, scope: !500)
!502 = !DILocation(line: 122, column: 13, scope: !495)
!503 = !DILocation(line: 132, column: 9, scope: !484)
!504 = !DILocation(line: 135, column: 5, scope: !464)
!505 = !DILocation(line: 136, column: 5, scope: !464)
!506 = !DILocation(line: 137, column: 1, scope: !464)
!507 = distinct !DISubprogram(name: "cond_init", scope: !2, file: !2, line: 141, type: !508, scopeLine: 142, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!508 = !DISubroutineType(types: !509)
!509 = !{null, !510}
!510 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !222, size: 64)
!511 = !DILocalVariable(name: "cond", arg: 1, scope: !507, file: !2, line: 141, type: !510)
!512 = !DILocation(line: 141, column: 32, scope: !507)
!513 = !DILocalVariable(name: "status", scope: !507, file: !2, line: 143, type: !173)
!514 = !DILocation(line: 143, column: 9, scope: !507)
!515 = !DILocalVariable(name: "attr", scope: !507, file: !2, line: 144, type: !516)
!516 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_condattr_t", file: !172, line: 45, baseType: !517)
!517 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !172, line: 41, size: 32, elements: !518)
!518 = !{!519, !520}
!519 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !517, file: !172, line: 43, baseType: !349, size: 32)
!520 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !517, file: !172, line: 44, baseType: !173, size: 32)
!521 = !DILocation(line: 144, column: 24, scope: !507)
!522 = !DILocation(line: 146, column: 14, scope: !507)
!523 = !DILocation(line: 146, column: 12, scope: !507)
!524 = !DILocation(line: 147, column: 5, scope: !525)
!525 = distinct !DILexicalBlock(scope: !526, file: !2, line: 147, column: 5)
!526 = distinct !DILexicalBlock(scope: !507, file: !2, line: 147, column: 5)
!527 = !DILocation(line: 147, column: 5, scope: !526)
!528 = !DILocation(line: 149, column: 32, scope: !507)
!529 = !DILocation(line: 149, column: 14, scope: !507)
!530 = !DILocation(line: 149, column: 12, scope: !507)
!531 = !DILocation(line: 150, column: 5, scope: !532)
!532 = distinct !DILexicalBlock(scope: !533, file: !2, line: 150, column: 5)
!533 = distinct !DILexicalBlock(scope: !507, file: !2, line: 150, column: 5)
!534 = !DILocation(line: 150, column: 5, scope: !533)
!535 = !DILocation(line: 152, column: 14, scope: !507)
!536 = !DILocation(line: 152, column: 12, scope: !507)
!537 = !DILocation(line: 153, column: 5, scope: !538)
!538 = distinct !DILexicalBlock(scope: !539, file: !2, line: 153, column: 5)
!539 = distinct !DILexicalBlock(scope: !507, file: !2, line: 153, column: 5)
!540 = !DILocation(line: 153, column: 5, scope: !539)
!541 = !DILocation(line: 154, column: 1, scope: !507)
!542 = distinct !DISubprogram(name: "cond_destroy", scope: !2, file: !2, line: 156, type: !508, scopeLine: 157, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!543 = !DILocalVariable(name: "cond", arg: 1, scope: !542, file: !2, line: 156, type: !510)
!544 = !DILocation(line: 156, column: 35, scope: !542)
!545 = !DILocalVariable(name: "status", scope: !542, file: !2, line: 158, type: !173)
!546 = !DILocation(line: 158, column: 9, scope: !542)
!547 = !DILocation(line: 158, column: 39, scope: !542)
!548 = !DILocation(line: 158, column: 18, scope: !542)
!549 = !DILocation(line: 159, column: 5, scope: !550)
!550 = distinct !DILexicalBlock(scope: !551, file: !2, line: 159, column: 5)
!551 = distinct !DILexicalBlock(scope: !542, file: !2, line: 159, column: 5)
!552 = !DILocation(line: 159, column: 5, scope: !551)
!553 = !DILocation(line: 160, column: 1, scope: !542)
!554 = distinct !DISubprogram(name: "cond_signal", scope: !2, file: !2, line: 162, type: !508, scopeLine: 163, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!555 = !DILocalVariable(name: "cond", arg: 1, scope: !554, file: !2, line: 162, type: !510)
!556 = !DILocation(line: 162, column: 34, scope: !554)
!557 = !DILocalVariable(name: "status", scope: !554, file: !2, line: 164, type: !173)
!558 = !DILocation(line: 164, column: 9, scope: !554)
!559 = !DILocation(line: 164, column: 38, scope: !554)
!560 = !DILocation(line: 164, column: 18, scope: !554)
!561 = !DILocation(line: 165, column: 5, scope: !562)
!562 = distinct !DILexicalBlock(scope: !563, file: !2, line: 165, column: 5)
!563 = distinct !DILexicalBlock(scope: !554, file: !2, line: 165, column: 5)
!564 = !DILocation(line: 165, column: 5, scope: !563)
!565 = !DILocation(line: 166, column: 1, scope: !554)
!566 = distinct !DISubprogram(name: "cond_broadcast", scope: !2, file: !2, line: 168, type: !508, scopeLine: 169, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!567 = !DILocalVariable(name: "cond", arg: 1, scope: !566, file: !2, line: 168, type: !510)
!568 = !DILocation(line: 168, column: 37, scope: !566)
!569 = !DILocalVariable(name: "status", scope: !566, file: !2, line: 170, type: !173)
!570 = !DILocation(line: 170, column: 9, scope: !566)
!571 = !DILocation(line: 170, column: 41, scope: !566)
!572 = !DILocation(line: 170, column: 18, scope: !566)
!573 = !DILocation(line: 171, column: 5, scope: !574)
!574 = distinct !DILexicalBlock(scope: !575, file: !2, line: 171, column: 5)
!575 = distinct !DILexicalBlock(scope: !566, file: !2, line: 171, column: 5)
!576 = !DILocation(line: 171, column: 5, scope: !575)
!577 = !DILocation(line: 172, column: 1, scope: !566)
!578 = distinct !DISubprogram(name: "cond_wait", scope: !2, file: !2, line: 174, type: !579, scopeLine: 175, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!579 = !DISubroutineType(types: !580)
!580 = !{null, !510, !331}
!581 = !DILocalVariable(name: "cond", arg: 1, scope: !578, file: !2, line: 174, type: !510)
!582 = !DILocation(line: 174, column: 32, scope: !578)
!583 = !DILocalVariable(name: "lock", arg: 2, scope: !578, file: !2, line: 174, type: !331)
!584 = !DILocation(line: 174, column: 55, scope: !578)
!585 = !DILocalVariable(name: "status", scope: !578, file: !2, line: 176, type: !173)
!586 = !DILocation(line: 176, column: 9, scope: !578)
!587 = !DILocation(line: 176, column: 36, scope: !578)
!588 = !DILocation(line: 176, column: 42, scope: !578)
!589 = !DILocation(line: 176, column: 18, scope: !578)
!590 = !DILocation(line: 178, column: 1, scope: !578)
!591 = distinct !DISubprogram(name: "cond_timedwait", scope: !2, file: !2, line: 180, type: !592, scopeLine: 181, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!592 = !DISubroutineType(types: !593)
!593 = !{null, !510, !331, !255}
!594 = !DILocalVariable(name: "cond", arg: 1, scope: !591, file: !2, line: 180, type: !510)
!595 = !DILocation(line: 180, column: 37, scope: !591)
!596 = !DILocalVariable(name: "lock", arg: 2, scope: !591, file: !2, line: 180, type: !331)
!597 = !DILocation(line: 180, column: 60, scope: !591)
!598 = !DILocalVariable(name: "millis", arg: 3, scope: !591, file: !2, line: 180, type: !255)
!599 = !DILocation(line: 180, column: 76, scope: !591)
!600 = !DILocalVariable(name: "ts", scope: !591, file: !2, line: 183, type: !601)
!601 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !602, line: 11, size: 128, elements: !603)
!602 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_timespec.h", directory: "", checksumkind: CSK_MD5, checksum: "9378e9ebbd658baccf881d3300eb1828")
!603 = !{!604, !607}
!604 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !601, file: !602, line: 16, baseType: !605, size: 64)
!605 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !606, line: 160, baseType: !219)
!606 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "0737a53e1b85eab0e0ba9675962d13f4")
!607 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !601, file: !602, line: 21, baseType: !608, size: 64, offset: 64)
!608 = !DIDerivedType(tag: DW_TAG_typedef, name: "__syscall_slong_t", file: !606, line: 197, baseType: !219)
!609 = !DILocation(line: 183, column: 21, scope: !591)
!610 = !DILocation(line: 187, column: 11, scope: !591)
!611 = !DILocalVariable(name: "status", scope: !591, file: !2, line: 188, type: !173)
!612 = !DILocation(line: 188, column: 9, scope: !591)
!613 = !DILocation(line: 188, column: 41, scope: !591)
!614 = !DILocation(line: 188, column: 47, scope: !591)
!615 = !DILocation(line: 188, column: 18, scope: !591)
!616 = !DILocation(line: 189, column: 1, scope: !591)
!617 = distinct !DISubprogram(name: "cond_worker", scope: !2, file: !2, line: 195, type: !279, scopeLine: 196, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!618 = !DILocalVariable(name: "message", arg: 1, scope: !617, file: !2, line: 195, type: !101)
!619 = !DILocation(line: 195, column: 25, scope: !617)
!620 = !DILocalVariable(name: "idle", scope: !617, file: !2, line: 197, type: !442)
!621 = !DILocation(line: 197, column: 10, scope: !617)
!622 = !DILocation(line: 199, column: 9, scope: !623)
!623 = distinct !DILexicalBlock(scope: !617, file: !2, line: 198, column: 5)
!624 = !DILocation(line: 200, column: 9, scope: !623)
!625 = !DILocation(line: 201, column: 9, scope: !623)
!626 = !DILocation(line: 202, column: 9, scope: !623)
!627 = !DILocation(line: 203, column: 16, scope: !623)
!628 = !DILocation(line: 203, column: 22, scope: !623)
!629 = !DILocation(line: 203, column: 14, scope: !623)
!630 = !DILocation(line: 204, column: 9, scope: !623)
!631 = !DILocation(line: 206, column: 9, scope: !632)
!632 = distinct !DILexicalBlock(scope: !617, file: !2, line: 206, column: 9)
!633 = !DILocation(line: 206, column: 9, scope: !617)
!634 = !DILocation(line: 207, column: 25, scope: !632)
!635 = !DILocation(line: 207, column: 34, scope: !632)
!636 = !DILocation(line: 207, column: 9, scope: !632)
!637 = !DILocation(line: 208, column: 10, scope: !617)
!638 = !DILocation(line: 210, column: 9, scope: !639)
!639 = distinct !DILexicalBlock(scope: !617, file: !2, line: 209, column: 5)
!640 = !DILocation(line: 211, column: 9, scope: !639)
!641 = !DILocation(line: 212, column: 9, scope: !639)
!642 = !DILocation(line: 213, column: 9, scope: !639)
!643 = !DILocation(line: 214, column: 16, scope: !639)
!644 = !DILocation(line: 214, column: 22, scope: !639)
!645 = !DILocation(line: 214, column: 14, scope: !639)
!646 = !DILocation(line: 215, column: 9, scope: !639)
!647 = !DILocation(line: 217, column: 9, scope: !648)
!648 = distinct !DILexicalBlock(scope: !617, file: !2, line: 217, column: 9)
!649 = !DILocation(line: 217, column: 9, scope: !617)
!650 = !DILocation(line: 218, column: 25, scope: !648)
!651 = !DILocation(line: 218, column: 34, scope: !648)
!652 = !DILocation(line: 218, column: 9, scope: !648)
!653 = !DILocation(line: 219, column: 12, scope: !617)
!654 = !DILocation(line: 219, column: 5, scope: !617)
!655 = !DILocation(line: 220, column: 1, scope: !617)
!656 = distinct !DISubprogram(name: "cond_test", scope: !2, file: !2, line: 222, type: !465, scopeLine: 223, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!657 = !DILocalVariable(name: "message", scope: !656, file: !2, line: 224, type: !101)
!658 = !DILocation(line: 224, column: 11, scope: !656)
!659 = !DILocation(line: 225, column: 5, scope: !656)
!660 = !DILocation(line: 226, column: 5, scope: !656)
!661 = !DILocalVariable(name: "worker", scope: !656, file: !2, line: 228, type: !258)
!662 = !DILocation(line: 228, column: 15, scope: !656)
!663 = !DILocation(line: 228, column: 51, scope: !656)
!664 = !DILocation(line: 228, column: 24, scope: !656)
!665 = !DILocation(line: 231, column: 9, scope: !666)
!666 = distinct !DILexicalBlock(scope: !656, file: !2, line: 230, column: 5)
!667 = !DILocation(line: 232, column: 9, scope: !666)
!668 = !DILocation(line: 233, column: 9, scope: !666)
!669 = !DILocation(line: 234, column: 9, scope: !666)
!670 = !DILocation(line: 238, column: 9, scope: !671)
!671 = distinct !DILexicalBlock(scope: !656, file: !2, line: 237, column: 5)
!672 = !DILocation(line: 239, column: 9, scope: !671)
!673 = !DILocation(line: 240, column: 9, scope: !671)
!674 = !DILocation(line: 241, column: 9, scope: !671)
!675 = !DILocalVariable(name: "result", scope: !656, file: !2, line: 244, type: !101)
!676 = !DILocation(line: 244, column: 11, scope: !656)
!677 = !DILocation(line: 244, column: 32, scope: !656)
!678 = !DILocation(line: 244, column: 20, scope: !656)
!679 = !DILocation(line: 245, column: 5, scope: !680)
!680 = distinct !DILexicalBlock(scope: !681, file: !2, line: 245, column: 5)
!681 = distinct !DILexicalBlock(scope: !656, file: !2, line: 245, column: 5)
!682 = !DILocation(line: 245, column: 5, scope: !681)
!683 = !DILocation(line: 247, column: 5, scope: !656)
!684 = !DILocation(line: 248, column: 5, scope: !656)
!685 = !DILocation(line: 249, column: 1, scope: !656)
!686 = distinct !DISubprogram(name: "rwlock_init", scope: !2, file: !2, line: 256, type: !687, scopeLine: 257, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!687 = !DISubroutineType(types: !688)
!688 = !{null, !689, !173}
!689 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !690, size: 64)
!690 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlock_t", file: !172, line: 91, baseType: !691)
!691 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !172, line: 86, size: 448, elements: !692)
!692 = !{!693, !714, !715}
!693 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !691, file: !172, line: 88, baseType: !694, size: 448)
!694 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_rwlock_arch_t", file: !695, line: 23, size: 448, elements: !696)
!695 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/struct_rwlock.h", directory: "", checksumkind: CSK_MD5, checksum: "c50817c3f5d727714047e4ed2c0cc1a3")
!696 = !{!697, !698, !699, !700, !701, !702, !703, !704, !705, !707, !712, !713}
!697 = !DIDerivedType(tag: DW_TAG_member, name: "__readers", scope: !694, file: !695, line: 25, baseType: !76, size: 32)
!698 = !DIDerivedType(tag: DW_TAG_member, name: "__writers", scope: !694, file: !695, line: 26, baseType: !76, size: 32, offset: 32)
!699 = !DIDerivedType(tag: DW_TAG_member, name: "__wrphase_futex", scope: !694, file: !695, line: 27, baseType: !76, size: 32, offset: 64)
!700 = !DIDerivedType(tag: DW_TAG_member, name: "__writers_futex", scope: !694, file: !695, line: 28, baseType: !76, size: 32, offset: 96)
!701 = !DIDerivedType(tag: DW_TAG_member, name: "__pad3", scope: !694, file: !695, line: 29, baseType: !76, size: 32, offset: 128)
!702 = !DIDerivedType(tag: DW_TAG_member, name: "__pad4", scope: !694, file: !695, line: 30, baseType: !76, size: 32, offset: 160)
!703 = !DIDerivedType(tag: DW_TAG_member, name: "__cur_writer", scope: !694, file: !695, line: 32, baseType: !173, size: 32, offset: 192)
!704 = !DIDerivedType(tag: DW_TAG_member, name: "__shared", scope: !694, file: !695, line: 33, baseType: !173, size: 32, offset: 224)
!705 = !DIDerivedType(tag: DW_TAG_member, name: "__rwelision", scope: !694, file: !695, line: 34, baseType: !706, size: 8, offset: 256)
!706 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!707 = !DIDerivedType(tag: DW_TAG_member, name: "__pad1", scope: !694, file: !695, line: 39, baseType: !708, size: 56, offset: 264)
!708 = !DICompositeType(tag: DW_TAG_array_type, baseType: !709, size: 56, elements: !710)
!709 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!710 = !{!711}
!711 = !DISubrange(count: 7)
!712 = !DIDerivedType(tag: DW_TAG_member, name: "__pad2", scope: !694, file: !695, line: 42, baseType: !259, size: 64, offset: 320)
!713 = !DIDerivedType(tag: DW_TAG_member, name: "__flags", scope: !694, file: !695, line: 45, baseType: !76, size: 32, offset: 384)
!714 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !691, file: !172, line: 89, baseType: !293, size: 448)
!715 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !691, file: !172, line: 90, baseType: !219, size: 64)
!716 = !DILocalVariable(name: "lock", arg: 1, scope: !686, file: !2, line: 256, type: !689)
!717 = !DILocation(line: 256, column: 36, scope: !686)
!718 = !DILocalVariable(name: "shared", arg: 2, scope: !686, file: !2, line: 256, type: !173)
!719 = !DILocation(line: 256, column: 46, scope: !686)
!720 = !DILocalVariable(name: "status", scope: !686, file: !2, line: 258, type: !173)
!721 = !DILocation(line: 258, column: 9, scope: !686)
!722 = !DILocalVariable(name: "value", scope: !686, file: !2, line: 259, type: !173)
!723 = !DILocation(line: 259, column: 9, scope: !686)
!724 = !DILocalVariable(name: "attributes", scope: !686, file: !2, line: 260, type: !725)
!725 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlockattr_t", file: !172, line: 97, baseType: !726)
!726 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !172, line: 93, size: 64, elements: !727)
!727 = !{!728, !729}
!728 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !726, file: !172, line: 95, baseType: !53, size: 64)
!729 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !726, file: !172, line: 96, baseType: !219, size: 64)
!730 = !DILocation(line: 260, column: 26, scope: !686)
!731 = !DILocation(line: 261, column: 14, scope: !686)
!732 = !DILocation(line: 261, column: 12, scope: !686)
!733 = !DILocation(line: 262, column: 5, scope: !734)
!734 = distinct !DILexicalBlock(scope: !735, file: !2, line: 262, column: 5)
!735 = distinct !DILexicalBlock(scope: !686, file: !2, line: 262, column: 5)
!736 = !DILocation(line: 262, column: 5, scope: !735)
!737 = !DILocation(line: 264, column: 57, scope: !686)
!738 = !DILocation(line: 264, column: 14, scope: !686)
!739 = !DILocation(line: 264, column: 12, scope: !686)
!740 = !DILocation(line: 265, column: 5, scope: !741)
!741 = distinct !DILexicalBlock(scope: !742, file: !2, line: 265, column: 5)
!742 = distinct !DILexicalBlock(scope: !686, file: !2, line: 265, column: 5)
!743 = !DILocation(line: 265, column: 5, scope: !742)
!744 = !DILocation(line: 266, column: 14, scope: !686)
!745 = !DILocation(line: 266, column: 12, scope: !686)
!746 = !DILocation(line: 267, column: 5, scope: !747)
!747 = distinct !DILexicalBlock(scope: !748, file: !2, line: 267, column: 5)
!748 = distinct !DILexicalBlock(scope: !686, file: !2, line: 267, column: 5)
!749 = !DILocation(line: 267, column: 5, scope: !748)
!750 = !DILocation(line: 269, column: 34, scope: !686)
!751 = !DILocation(line: 269, column: 14, scope: !686)
!752 = !DILocation(line: 269, column: 12, scope: !686)
!753 = !DILocation(line: 270, column: 5, scope: !754)
!754 = distinct !DILexicalBlock(scope: !755, file: !2, line: 270, column: 5)
!755 = distinct !DILexicalBlock(scope: !686, file: !2, line: 270, column: 5)
!756 = !DILocation(line: 270, column: 5, scope: !755)
!757 = !DILocation(line: 271, column: 14, scope: !686)
!758 = !DILocation(line: 271, column: 12, scope: !686)
!759 = !DILocation(line: 272, column: 5, scope: !760)
!760 = distinct !DILexicalBlock(scope: !761, file: !2, line: 272, column: 5)
!761 = distinct !DILexicalBlock(scope: !686, file: !2, line: 272, column: 5)
!762 = !DILocation(line: 272, column: 5, scope: !761)
!763 = !DILocation(line: 273, column: 1, scope: !686)
!764 = distinct !DISubprogram(name: "rwlock_destroy", scope: !2, file: !2, line: 275, type: !765, scopeLine: 276, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!765 = !DISubroutineType(types: !766)
!766 = !{null, !689}
!767 = !DILocalVariable(name: "lock", arg: 1, scope: !764, file: !2, line: 275, type: !689)
!768 = !DILocation(line: 275, column: 39, scope: !764)
!769 = !DILocalVariable(name: "status", scope: !764, file: !2, line: 277, type: !173)
!770 = !DILocation(line: 277, column: 9, scope: !764)
!771 = !DILocation(line: 277, column: 41, scope: !764)
!772 = !DILocation(line: 277, column: 18, scope: !764)
!773 = !DILocation(line: 278, column: 5, scope: !774)
!774 = distinct !DILexicalBlock(scope: !775, file: !2, line: 278, column: 5)
!775 = distinct !DILexicalBlock(scope: !764, file: !2, line: 278, column: 5)
!776 = !DILocation(line: 278, column: 5, scope: !775)
!777 = !DILocation(line: 279, column: 1, scope: !764)
!778 = distinct !DISubprogram(name: "rwlock_wrlock", scope: !2, file: !2, line: 281, type: !765, scopeLine: 282, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!779 = !DILocalVariable(name: "lock", arg: 1, scope: !778, file: !2, line: 281, type: !689)
!780 = !DILocation(line: 281, column: 38, scope: !778)
!781 = !DILocalVariable(name: "status", scope: !778, file: !2, line: 283, type: !173)
!782 = !DILocation(line: 283, column: 9, scope: !778)
!783 = !DILocation(line: 283, column: 40, scope: !778)
!784 = !DILocation(line: 283, column: 18, scope: !778)
!785 = !DILocation(line: 284, column: 5, scope: !786)
!786 = distinct !DILexicalBlock(scope: !787, file: !2, line: 284, column: 5)
!787 = distinct !DILexicalBlock(scope: !778, file: !2, line: 284, column: 5)
!788 = !DILocation(line: 284, column: 5, scope: !787)
!789 = !DILocation(line: 285, column: 1, scope: !778)
!790 = distinct !DISubprogram(name: "rwlock_trywrlock", scope: !2, file: !2, line: 287, type: !791, scopeLine: 288, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!791 = !DISubroutineType(types: !792)
!792 = !{!442, !689}
!793 = !DILocalVariable(name: "lock", arg: 1, scope: !790, file: !2, line: 287, type: !689)
!794 = !DILocation(line: 287, column: 41, scope: !790)
!795 = !DILocalVariable(name: "status", scope: !790, file: !2, line: 289, type: !173)
!796 = !DILocation(line: 289, column: 9, scope: !790)
!797 = !DILocation(line: 289, column: 43, scope: !790)
!798 = !DILocation(line: 289, column: 18, scope: !790)
!799 = !DILocation(line: 291, column: 12, scope: !790)
!800 = !DILocation(line: 291, column: 19, scope: !790)
!801 = !DILocation(line: 291, column: 5, scope: !790)
!802 = distinct !DISubprogram(name: "rwlock_rdlock", scope: !2, file: !2, line: 294, type: !765, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!803 = !DILocalVariable(name: "lock", arg: 1, scope: !802, file: !2, line: 294, type: !689)
!804 = !DILocation(line: 294, column: 38, scope: !802)
!805 = !DILocalVariable(name: "status", scope: !802, file: !2, line: 296, type: !173)
!806 = !DILocation(line: 296, column: 9, scope: !802)
!807 = !DILocation(line: 296, column: 40, scope: !802)
!808 = !DILocation(line: 296, column: 18, scope: !802)
!809 = !DILocation(line: 297, column: 5, scope: !810)
!810 = distinct !DILexicalBlock(scope: !811, file: !2, line: 297, column: 5)
!811 = distinct !DILexicalBlock(scope: !802, file: !2, line: 297, column: 5)
!812 = !DILocation(line: 297, column: 5, scope: !811)
!813 = !DILocation(line: 298, column: 1, scope: !802)
!814 = distinct !DISubprogram(name: "rwlock_tryrdlock", scope: !2, file: !2, line: 300, type: !791, scopeLine: 301, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!815 = !DILocalVariable(name: "lock", arg: 1, scope: !814, file: !2, line: 300, type: !689)
!816 = !DILocation(line: 300, column: 41, scope: !814)
!817 = !DILocalVariable(name: "status", scope: !814, file: !2, line: 302, type: !173)
!818 = !DILocation(line: 302, column: 9, scope: !814)
!819 = !DILocation(line: 302, column: 43, scope: !814)
!820 = !DILocation(line: 302, column: 18, scope: !814)
!821 = !DILocation(line: 304, column: 12, scope: !814)
!822 = !DILocation(line: 304, column: 19, scope: !814)
!823 = !DILocation(line: 304, column: 5, scope: !814)
!824 = distinct !DISubprogram(name: "rwlock_unlock", scope: !2, file: !2, line: 307, type: !765, scopeLine: 308, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!825 = !DILocalVariable(name: "lock", arg: 1, scope: !824, file: !2, line: 307, type: !689)
!826 = !DILocation(line: 307, column: 38, scope: !824)
!827 = !DILocalVariable(name: "status", scope: !824, file: !2, line: 309, type: !173)
!828 = !DILocation(line: 309, column: 9, scope: !824)
!829 = !DILocation(line: 309, column: 40, scope: !824)
!830 = !DILocation(line: 309, column: 18, scope: !824)
!831 = !DILocation(line: 310, column: 5, scope: !832)
!832 = distinct !DILexicalBlock(scope: !833, file: !2, line: 310, column: 5)
!833 = distinct !DILexicalBlock(scope: !824, file: !2, line: 310, column: 5)
!834 = !DILocation(line: 310, column: 5, scope: !833)
!835 = !DILocation(line: 311, column: 1, scope: !824)
!836 = distinct !DISubprogram(name: "rwlock_test", scope: !2, file: !2, line: 313, type: !465, scopeLine: 314, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!837 = !DILocalVariable(name: "lock", scope: !836, file: !2, line: 315, type: !690)
!838 = !DILocation(line: 315, column: 22, scope: !836)
!839 = !DILocation(line: 316, column: 5, scope: !836)
!840 = !DILocalVariable(name: "test_depth", scope: !836, file: !2, line: 317, type: !841)
!841 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !173)
!842 = !DILocation(line: 317, column: 15, scope: !836)
!843 = !DILocation(line: 320, column: 9, scope: !844)
!844 = distinct !DILexicalBlock(scope: !836, file: !2, line: 319, column: 5)
!845 = !DILocalVariable(name: "success", scope: !844, file: !2, line: 321, type: !442)
!846 = !DILocation(line: 321, column: 14, scope: !844)
!847 = !DILocation(line: 321, column: 24, scope: !844)
!848 = !DILocation(line: 322, column: 9, scope: !849)
!849 = distinct !DILexicalBlock(scope: !850, file: !2, line: 322, column: 9)
!850 = distinct !DILexicalBlock(scope: !844, file: !2, line: 322, column: 9)
!851 = !DILocation(line: 322, column: 9, scope: !850)
!852 = !DILocation(line: 323, column: 19, scope: !844)
!853 = !DILocation(line: 323, column: 17, scope: !844)
!854 = !DILocation(line: 324, column: 9, scope: !855)
!855 = distinct !DILexicalBlock(scope: !856, file: !2, line: 324, column: 9)
!856 = distinct !DILexicalBlock(scope: !844, file: !2, line: 324, column: 9)
!857 = !DILocation(line: 324, column: 9, scope: !856)
!858 = !DILocation(line: 325, column: 9, scope: !844)
!859 = !DILocation(line: 329, column: 9, scope: !860)
!860 = distinct !DILexicalBlock(scope: !836, file: !2, line: 328, column: 5)
!861 = !DILocalVariable(name: "i", scope: !862, file: !2, line: 330, type: !173)
!862 = distinct !DILexicalBlock(scope: !860, file: !2, line: 330, column: 9)
!863 = !DILocation(line: 330, column: 18, scope: !862)
!864 = !DILocation(line: 330, column: 14, scope: !862)
!865 = !DILocation(line: 330, column: 25, scope: !866)
!866 = distinct !DILexicalBlock(scope: !862, file: !2, line: 330, column: 9)
!867 = !DILocation(line: 330, column: 27, scope: !866)
!868 = !DILocation(line: 330, column: 9, scope: !862)
!869 = !DILocalVariable(name: "success", scope: !870, file: !2, line: 332, type: !442)
!870 = distinct !DILexicalBlock(scope: !866, file: !2, line: 331, column: 9)
!871 = !DILocation(line: 332, column: 18, scope: !870)
!872 = !DILocation(line: 332, column: 28, scope: !870)
!873 = !DILocation(line: 333, column: 13, scope: !874)
!874 = distinct !DILexicalBlock(scope: !875, file: !2, line: 333, column: 13)
!875 = distinct !DILexicalBlock(scope: !870, file: !2, line: 333, column: 13)
!876 = !DILocation(line: 333, column: 13, scope: !875)
!877 = !DILocation(line: 334, column: 9, scope: !870)
!878 = !DILocation(line: 330, column: 42, scope: !866)
!879 = !DILocation(line: 330, column: 9, scope: !866)
!880 = distinct !{!880, !868, !881, !882}
!881 = !DILocation(line: 334, column: 9, scope: !862)
!882 = !{!"llvm.loop.mustprogress"}
!883 = !DILocalVariable(name: "success", scope: !884, file: !2, line: 337, type: !442)
!884 = distinct !DILexicalBlock(scope: !860, file: !2, line: 336, column: 9)
!885 = !DILocation(line: 337, column: 18, scope: !884)
!886 = !DILocation(line: 337, column: 28, scope: !884)
!887 = !DILocation(line: 338, column: 13, scope: !888)
!888 = distinct !DILexicalBlock(scope: !889, file: !2, line: 338, column: 13)
!889 = distinct !DILexicalBlock(scope: !884, file: !2, line: 338, column: 13)
!890 = !DILocation(line: 338, column: 13, scope: !889)
!891 = !DILocation(line: 341, column: 9, scope: !860)
!892 = !DILocalVariable(name: "i", scope: !893, file: !2, line: 342, type: !173)
!893 = distinct !DILexicalBlock(scope: !860, file: !2, line: 342, column: 9)
!894 = !DILocation(line: 342, column: 18, scope: !893)
!895 = !DILocation(line: 342, column: 14, scope: !893)
!896 = !DILocation(line: 342, column: 25, scope: !897)
!897 = distinct !DILexicalBlock(scope: !893, file: !2, line: 342, column: 9)
!898 = !DILocation(line: 342, column: 27, scope: !897)
!899 = !DILocation(line: 342, column: 9, scope: !893)
!900 = !DILocation(line: 343, column: 13, scope: !901)
!901 = distinct !DILexicalBlock(scope: !897, file: !2, line: 342, column: 46)
!902 = !DILocation(line: 344, column: 9, scope: !901)
!903 = !DILocation(line: 342, column: 42, scope: !897)
!904 = !DILocation(line: 342, column: 9, scope: !897)
!905 = distinct !{!905, !899, !906, !882}
!906 = !DILocation(line: 344, column: 9, scope: !893)
!907 = !DILocation(line: 348, column: 9, scope: !908)
!908 = distinct !DILexicalBlock(scope: !836, file: !2, line: 347, column: 5)
!909 = !DILocalVariable(name: "success", scope: !908, file: !2, line: 349, type: !442)
!910 = !DILocation(line: 349, column: 14, scope: !908)
!911 = !DILocation(line: 349, column: 24, scope: !908)
!912 = !DILocation(line: 350, column: 9, scope: !913)
!913 = distinct !DILexicalBlock(scope: !914, file: !2, line: 350, column: 9)
!914 = distinct !DILexicalBlock(scope: !908, file: !2, line: 350, column: 9)
!915 = !DILocation(line: 350, column: 9, scope: !914)
!916 = !DILocation(line: 351, column: 9, scope: !908)
!917 = !DILocation(line: 354, column: 5, scope: !836)
!918 = !DILocation(line: 355, column: 1, scope: !836)
!919 = distinct !DISubprogram(name: "key_destroy", scope: !2, file: !2, line: 362, type: !920, scopeLine: 363, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!920 = !DISubroutineType(types: !921)
!921 = !{null, !101}
!922 = !DILocalVariable(name: "unused_value", arg: 1, scope: !919, file: !2, line: 362, type: !101)
!923 = !DILocation(line: 362, column: 24, scope: !919)
!924 = !DILocation(line: 364, column: 21, scope: !919)
!925 = !DILocation(line: 364, column: 19, scope: !919)
!926 = !DILocation(line: 365, column: 1, scope: !919)
!927 = distinct !DISubprogram(name: "key_worker", scope: !2, file: !2, line: 367, type: !279, scopeLine: 368, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!928 = !DILocalVariable(name: "message", arg: 1, scope: !927, file: !2, line: 367, type: !101)
!929 = !DILocation(line: 367, column: 24, scope: !927)
!930 = !DILocalVariable(name: "my_secret", scope: !927, file: !2, line: 369, type: !173)
!931 = !DILocation(line: 369, column: 9, scope: !927)
!932 = !DILocalVariable(name: "status", scope: !927, file: !2, line: 371, type: !173)
!933 = !DILocation(line: 371, column: 9, scope: !927)
!934 = !DILocation(line: 371, column: 38, scope: !927)
!935 = !DILocation(line: 371, column: 18, scope: !927)
!936 = !DILocation(line: 372, column: 5, scope: !937)
!937 = distinct !DILexicalBlock(scope: !938, file: !2, line: 372, column: 5)
!938 = distinct !DILexicalBlock(scope: !927, file: !2, line: 372, column: 5)
!939 = !DILocation(line: 372, column: 5, scope: !938)
!940 = !DILocalVariable(name: "my_local_data", scope: !927, file: !2, line: 374, type: !101)
!941 = !DILocation(line: 374, column: 11, scope: !927)
!942 = !DILocation(line: 374, column: 47, scope: !927)
!943 = !DILocation(line: 374, column: 27, scope: !927)
!944 = !DILocation(line: 375, column: 5, scope: !945)
!945 = distinct !DILexicalBlock(scope: !946, file: !2, line: 375, column: 5)
!946 = distinct !DILexicalBlock(scope: !927, file: !2, line: 375, column: 5)
!947 = !DILocation(line: 375, column: 5, scope: !946)
!948 = !DILocation(line: 377, column: 12, scope: !927)
!949 = !DILocation(line: 377, column: 5, scope: !927)
!950 = distinct !DISubprogram(name: "key_test", scope: !2, file: !2, line: 380, type: !465, scopeLine: 381, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!951 = !DILocalVariable(name: "my_secret", scope: !950, file: !2, line: 382, type: !173)
!952 = !DILocation(line: 382, column: 9, scope: !950)
!953 = !DILocalVariable(name: "message", scope: !950, file: !2, line: 383, type: !101)
!954 = !DILocation(line: 383, column: 11, scope: !950)
!955 = !DILocalVariable(name: "status", scope: !950, file: !2, line: 384, type: !173)
!956 = !DILocation(line: 384, column: 9, scope: !950)
!957 = !DILocation(line: 386, column: 5, scope: !950)
!958 = !DILocalVariable(name: "worker", scope: !950, file: !2, line: 388, type: !258)
!959 = !DILocation(line: 388, column: 15, scope: !950)
!960 = !DILocation(line: 388, column: 50, scope: !950)
!961 = !DILocation(line: 388, column: 24, scope: !950)
!962 = !DILocation(line: 390, column: 34, scope: !950)
!963 = !DILocation(line: 390, column: 14, scope: !950)
!964 = !DILocation(line: 390, column: 12, scope: !950)
!965 = !DILocation(line: 391, column: 5, scope: !966)
!966 = distinct !DILexicalBlock(scope: !967, file: !2, line: 391, column: 5)
!967 = distinct !DILexicalBlock(scope: !950, file: !2, line: 391, column: 5)
!968 = !DILocation(line: 391, column: 5, scope: !967)
!969 = !DILocalVariable(name: "my_local_data", scope: !950, file: !2, line: 393, type: !101)
!970 = !DILocation(line: 393, column: 11, scope: !950)
!971 = !DILocation(line: 393, column: 47, scope: !950)
!972 = !DILocation(line: 393, column: 27, scope: !950)
!973 = !DILocation(line: 394, column: 5, scope: !974)
!974 = distinct !DILexicalBlock(scope: !975, file: !2, line: 394, column: 5)
!975 = distinct !DILexicalBlock(scope: !950, file: !2, line: 394, column: 5)
!976 = !DILocation(line: 394, column: 5, scope: !975)
!977 = !DILocation(line: 396, column: 34, scope: !950)
!978 = !DILocation(line: 396, column: 14, scope: !950)
!979 = !DILocation(line: 396, column: 12, scope: !950)
!980 = !DILocation(line: 397, column: 5, scope: !981)
!981 = distinct !DILexicalBlock(scope: !982, file: !2, line: 397, column: 5)
!982 = distinct !DILexicalBlock(scope: !950, file: !2, line: 397, column: 5)
!983 = !DILocation(line: 397, column: 5, scope: !982)
!984 = !DILocalVariable(name: "result", scope: !950, file: !2, line: 399, type: !101)
!985 = !DILocation(line: 399, column: 11, scope: !950)
!986 = !DILocation(line: 399, column: 32, scope: !950)
!987 = !DILocation(line: 399, column: 20, scope: !950)
!988 = !DILocation(line: 400, column: 5, scope: !989)
!989 = distinct !DILexicalBlock(scope: !990, file: !2, line: 400, column: 5)
!990 = distinct !DILexicalBlock(scope: !950, file: !2, line: 400, column: 5)
!991 = !DILocation(line: 400, column: 5, scope: !990)
!992 = !DILocation(line: 402, column: 33, scope: !950)
!993 = !DILocation(line: 402, column: 14, scope: !950)
!994 = !DILocation(line: 402, column: 12, scope: !950)
!995 = !DILocation(line: 403, column: 5, scope: !996)
!996 = distinct !DILexicalBlock(scope: !997, file: !2, line: 403, column: 5)
!997 = distinct !DILexicalBlock(scope: !950, file: !2, line: 403, column: 5)
!998 = !DILocation(line: 403, column: 5, scope: !997)
!999 = !DILocation(line: 405, column: 5, scope: !1000)
!1000 = distinct !DILexicalBlock(scope: !1001, file: !2, line: 405, column: 5)
!1001 = distinct !DILexicalBlock(scope: !950, file: !2, line: 405, column: 5)
!1002 = !DILocation(line: 405, column: 5, scope: !1001)
!1003 = !DILocation(line: 406, column: 1, scope: !950)
!1004 = distinct !DISubprogram(name: "detach_test_worker0", scope: !2, file: !2, line: 410, type: !279, scopeLine: 411, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!1005 = !DILocalVariable(name: "ignore", arg: 1, scope: !1004, file: !2, line: 410, type: !101)
!1006 = !DILocation(line: 410, column: 33, scope: !1004)
!1007 = !DILocation(line: 412, column: 5, scope: !1004)
!1008 = distinct !DISubprogram(name: "detach_test_detach", scope: !2, file: !2, line: 415, type: !279, scopeLine: 416, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!1009 = !DILocalVariable(name: "ignore", arg: 1, scope: !1008, file: !2, line: 415, type: !101)
!1010 = !DILocation(line: 415, column: 32, scope: !1008)
!1011 = !DILocalVariable(name: "status", scope: !1008, file: !2, line: 417, type: !173)
!1012 = !DILocation(line: 417, column: 9, scope: !1008)
!1013 = !DILocalVariable(name: "w0", scope: !1008, file: !2, line: 418, type: !258)
!1014 = !DILocation(line: 418, column: 15, scope: !1008)
!1015 = !DILocation(line: 418, column: 20, scope: !1008)
!1016 = !DILocation(line: 419, column: 29, scope: !1008)
!1017 = !DILocation(line: 419, column: 14, scope: !1008)
!1018 = !DILocation(line: 419, column: 12, scope: !1008)
!1019 = !DILocation(line: 420, column: 5, scope: !1020)
!1020 = distinct !DILexicalBlock(scope: !1021, file: !2, line: 420, column: 5)
!1021 = distinct !DILexicalBlock(scope: !1008, file: !2, line: 420, column: 5)
!1022 = !DILocation(line: 420, column: 5, scope: !1021)
!1023 = !DILocation(line: 422, column: 27, scope: !1008)
!1024 = !DILocation(line: 422, column: 14, scope: !1008)
!1025 = !DILocation(line: 422, column: 12, scope: !1008)
!1026 = !DILocation(line: 423, column: 5, scope: !1027)
!1027 = distinct !DILexicalBlock(scope: !1028, file: !2, line: 423, column: 5)
!1028 = distinct !DILexicalBlock(scope: !1008, file: !2, line: 423, column: 5)
!1029 = !DILocation(line: 423, column: 5, scope: !1028)
!1030 = !DILocation(line: 424, column: 5, scope: !1008)
!1031 = distinct !DISubprogram(name: "detach_test_attr", scope: !2, file: !2, line: 427, type: !279, scopeLine: 428, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!1032 = !DILocalVariable(name: "ignore", arg: 1, scope: !1031, file: !2, line: 427, type: !101)
!1033 = !DILocation(line: 427, column: 30, scope: !1031)
!1034 = !DILocalVariable(name: "status", scope: !1031, file: !2, line: 429, type: !173)
!1035 = !DILocation(line: 429, column: 9, scope: !1031)
!1036 = !DILocalVariable(name: "detachstate", scope: !1031, file: !2, line: 430, type: !173)
!1037 = !DILocation(line: 430, column: 9, scope: !1031)
!1038 = !DILocalVariable(name: "w0", scope: !1031, file: !2, line: 431, type: !258)
!1039 = !DILocation(line: 431, column: 15, scope: !1031)
!1040 = !DILocalVariable(name: "w0_attr", scope: !1031, file: !2, line: 432, type: !289)
!1041 = !DILocation(line: 432, column: 20, scope: !1031)
!1042 = !DILocation(line: 433, column: 14, scope: !1031)
!1043 = !DILocation(line: 433, column: 12, scope: !1031)
!1044 = !DILocation(line: 434, column: 5, scope: !1045)
!1045 = distinct !DILexicalBlock(scope: !1046, file: !2, line: 434, column: 5)
!1046 = distinct !DILexicalBlock(scope: !1031, file: !2, line: 434, column: 5)
!1047 = !DILocation(line: 434, column: 5, scope: !1046)
!1048 = !DILocation(line: 435, column: 14, scope: !1031)
!1049 = !DILocation(line: 435, column: 12, scope: !1031)
!1050 = !DILocation(line: 436, column: 5, scope: !1051)
!1051 = distinct !DILexicalBlock(scope: !1052, file: !2, line: 436, column: 5)
!1052 = distinct !DILexicalBlock(scope: !1031, file: !2, line: 436, column: 5)
!1053 = !DILocation(line: 436, column: 5, scope: !1052)
!1054 = !DILocation(line: 437, column: 14, scope: !1031)
!1055 = !DILocation(line: 437, column: 12, scope: !1031)
!1056 = !DILocation(line: 438, column: 5, scope: !1057)
!1057 = distinct !DILexicalBlock(scope: !1058, file: !2, line: 438, column: 5)
!1058 = distinct !DILexicalBlock(scope: !1031, file: !2, line: 438, column: 5)
!1059 = !DILocation(line: 438, column: 5, scope: !1058)
!1060 = !DILocation(line: 439, column: 14, scope: !1031)
!1061 = !DILocation(line: 439, column: 12, scope: !1031)
!1062 = !DILocation(line: 440, column: 5, scope: !1063)
!1063 = distinct !DILexicalBlock(scope: !1064, file: !2, line: 440, column: 5)
!1064 = distinct !DILexicalBlock(scope: !1031, file: !2, line: 440, column: 5)
!1065 = !DILocation(line: 440, column: 5, scope: !1064)
!1066 = !DILocation(line: 441, column: 14, scope: !1031)
!1067 = !DILocation(line: 441, column: 12, scope: !1031)
!1068 = !DILocation(line: 442, column: 5, scope: !1069)
!1069 = distinct !DILexicalBlock(scope: !1070, file: !2, line: 442, column: 5)
!1070 = distinct !DILexicalBlock(scope: !1031, file: !2, line: 442, column: 5)
!1071 = !DILocation(line: 442, column: 5, scope: !1070)
!1072 = !DILocation(line: 443, column: 5, scope: !1031)
!1073 = !DILocation(line: 445, column: 27, scope: !1031)
!1074 = !DILocation(line: 445, column: 14, scope: !1031)
!1075 = !DILocation(line: 445, column: 12, scope: !1031)
!1076 = !DILocation(line: 446, column: 5, scope: !1077)
!1077 = distinct !DILexicalBlock(scope: !1078, file: !2, line: 446, column: 5)
!1078 = distinct !DILexicalBlock(scope: !1031, file: !2, line: 446, column: 5)
!1079 = !DILocation(line: 446, column: 5, scope: !1078)
!1080 = !DILocation(line: 447, column: 5, scope: !1031)
!1081 = distinct !DISubprogram(name: "detach_test", scope: !2, file: !2, line: 450, type: !465, scopeLine: 451, spFlags: DISPFlagDefinition, unit: !72)
!1082 = !DILocation(line: 452, column: 5, scope: !1081)
!1083 = !DILocation(line: 453, column: 5, scope: !1081)
!1084 = !DILocation(line: 454, column: 1, scope: !1081)
!1085 = distinct !DISubprogram(name: "once_init0", scope: !2, file: !2, line: 463, type: !465, scopeLine: 464, spFlags: DISPFlagDefinition, unit: !72)
!1086 = !DILocation(line: 465, column: 5, scope: !1085)
!1087 = !DILocation(line: 466, column: 16, scope: !1085)
!1088 = !DILocation(line: 467, column: 1, scope: !1085)
!1089 = distinct !DISubprogram(name: "once_init1", scope: !2, file: !2, line: 469, type: !465, scopeLine: 470, spFlags: DISPFlagDefinition, unit: !72)
!1090 = !DILocation(line: 471, column: 5, scope: !1089)
!1091 = !DILocation(line: 472, column: 1, scope: !1089)
!1092 = distinct !DISubprogram(name: "once_worker", scope: !2, file: !2, line: 474, type: !279, scopeLine: 475, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!1093 = !DILocalVariable(name: "ignore", arg: 1, scope: !1092, file: !2, line: 474, type: !101)
!1094 = !DILocation(line: 474, column: 25, scope: !1092)
!1095 = !DILocalVariable(name: "status", scope: !1092, file: !2, line: 476, type: !173)
!1096 = !DILocation(line: 476, column: 9, scope: !1092)
!1097 = !DILocation(line: 476, column: 18, scope: !1092)
!1098 = !DILocation(line: 477, column: 5, scope: !1099)
!1099 = distinct !DILexicalBlock(scope: !1100, file: !2, line: 477, column: 5)
!1100 = distinct !DILexicalBlock(scope: !1092, file: !2, line: 477, column: 5)
!1101 = !DILocation(line: 477, column: 5, scope: !1100)
!1102 = !DILocation(line: 478, column: 5, scope: !1103)
!1103 = distinct !DILexicalBlock(scope: !1104, file: !2, line: 478, column: 5)
!1104 = distinct !DILexicalBlock(scope: !1092, file: !2, line: 478, column: 5)
!1105 = !DILocation(line: 478, column: 5, scope: !1104)
!1106 = !DILocation(line: 479, column: 5, scope: !1092)
!1107 = distinct !DISubprogram(name: "once_test", scope: !2, file: !2, line: 482, type: !465, scopeLine: 483, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !281)
!1108 = !DILocalVariable(name: "worker0", scope: !1107, file: !2, line: 484, type: !258)
!1109 = !DILocation(line: 484, column: 15, scope: !1107)
!1110 = !DILocation(line: 484, column: 25, scope: !1107)
!1111 = !DILocalVariable(name: "worker1", scope: !1107, file: !2, line: 485, type: !258)
!1112 = !DILocation(line: 485, column: 15, scope: !1107)
!1113 = !DILocation(line: 485, column: 25, scope: !1107)
!1114 = !DILocation(line: 486, column: 17, scope: !1107)
!1115 = !DILocation(line: 486, column: 5, scope: !1107)
!1116 = !DILocation(line: 487, column: 17, scope: !1107)
!1117 = !DILocation(line: 487, column: 5, scope: !1107)
!1118 = !DILocation(line: 488, column: 5, scope: !1119)
!1119 = distinct !DILexicalBlock(scope: !1120, file: !2, line: 488, column: 5)
!1120 = distinct !DILexicalBlock(scope: !1107, file: !2, line: 488, column: 5)
!1121 = !DILocation(line: 488, column: 5, scope: !1120)
!1122 = !DILocalVariable(name: "status", scope: !1107, file: !2, line: 490, type: !173)
!1123 = !DILocation(line: 490, column: 9, scope: !1107)
!1124 = !DILocation(line: 490, column: 18, scope: !1107)
!1125 = !DILocation(line: 491, column: 5, scope: !1126)
!1126 = distinct !DILexicalBlock(scope: !1127, file: !2, line: 491, column: 5)
!1127 = distinct !DILexicalBlock(scope: !1107, file: !2, line: 491, column: 5)
!1128 = !DILocation(line: 491, column: 5, scope: !1127)
!1129 = !DILocation(line: 492, column: 14, scope: !1107)
!1130 = !DILocation(line: 492, column: 12, scope: !1107)
!1131 = !DILocation(line: 493, column: 5, scope: !1132)
!1132 = distinct !DILexicalBlock(scope: !1133, file: !2, line: 493, column: 5)
!1133 = distinct !DILexicalBlock(scope: !1107, file: !2, line: 493, column: 5)
!1134 = !DILocation(line: 493, column: 5, scope: !1133)
!1135 = !DILocation(line: 494, column: 5, scope: !1136)
!1136 = distinct !DILexicalBlock(scope: !1137, file: !2, line: 494, column: 5)
!1137 = distinct !DILexicalBlock(scope: !1107, file: !2, line: 494, column: 5)
!1138 = !DILocation(line: 494, column: 5, scope: !1137)
!1139 = !DILocation(line: 495, column: 1, scope: !1107)
!1140 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 497, type: !1141, scopeLine: 498, spFlags: DISPFlagDefinition, unit: !72)
!1141 = !DISubroutineType(types: !1142)
!1142 = !{!173}
!1143 = !DILocation(line: 499, column: 13, scope: !1140)
!1144 = !DILocation(line: 499, column: 5, scope: !1140)
!1145 = !DILocation(line: 500, column: 17, scope: !1146)
!1146 = distinct !DILexicalBlock(scope: !1140, file: !2, line: 499, column: 38)
!1147 = !DILocation(line: 500, column: 31, scope: !1146)
!1148 = !DILocation(line: 501, column: 17, scope: !1146)
!1149 = !DILocation(line: 501, column: 30, scope: !1146)
!1150 = !DILocation(line: 502, column: 17, scope: !1146)
!1151 = !DILocation(line: 502, column: 32, scope: !1146)
!1152 = !DILocation(line: 503, column: 17, scope: !1146)
!1153 = !DILocation(line: 503, column: 29, scope: !1146)
!1154 = !DILocation(line: 504, column: 17, scope: !1146)
!1155 = !DILocation(line: 504, column: 32, scope: !1146)
!1156 = !DILocation(line: 505, column: 17, scope: !1146)
!1157 = !DILocation(line: 505, column: 30, scope: !1146)
!1158 = !DILocation(line: 507, column: 1, scope: !1140)
