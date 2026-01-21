; ModuleID = 'benchmarks/miscellaneous/pthread.c'
source_filename = "benchmarks/miscellaneous/pthread.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, %union.anon }
%union.anon = type { %struct.__pthread_internal_slist }
%struct.__pthread_internal_slist = type { ptr }
%union.pthread_cond_t = type { %struct.__pthread_cond_s }
%struct.__pthread_cond_s = type { %union.__atomic_wide_counter, %union.__atomic_wide_counter, [2 x i32], [2 x i32], i32, i32, [2 x i32] }
%union.__atomic_wide_counter = type { i64 }
%union.pthread_attr_t = type { i64, [32 x i8] }
%union.pthread_mutexattr_t = type { i32 }
%union.pthread_condattr_t = type { i32 }
%struct.timespec = type { i64, i64 }
%union.pthread_rwlockattr_t = type { i64 }
%union.pthread_rwlock_t = type { i64, [24 x i8] }

@__func__.thread_create = private unnamed_addr constant [14 x i8] c"thread_create\00", align 1, !dbg !0
@.str = private unnamed_addr constant [10 x i8] c"pthread.c\00", align 1, !dbg !8
@.str.1 = private unnamed_addr constant [12 x i8] c"status == 0\00", align 1, !dbg !13
@__func__.thread_join = private unnamed_addr constant [12 x i8] c"thread_join\00", align 1, !dbg !18
@__func__.mutex_init = private unnamed_addr constant [11 x i8] c"mutex_init\00", align 1, !dbg !21
@__func__.mutex_destroy = private unnamed_addr constant [14 x i8] c"mutex_destroy\00", align 1, !dbg !26
@__func__.mutex_lock = private unnamed_addr constant [11 x i8] c"mutex_lock\00", align 1, !dbg !28
@__func__.mutex_unlock = private unnamed_addr constant [13 x i8] c"mutex_unlock\00", align 1, !dbg !30
@__func__.mutex_test = private unnamed_addr constant [11 x i8] c"mutex_test\00", align 1, !dbg !35
@.str.2 = private unnamed_addr constant [9 x i8] c"!success\00", align 1, !dbg !37
@.str.3 = private unnamed_addr constant [8 x i8] c"success\00", align 1, !dbg !42
@__func__.cond_init = private unnamed_addr constant [10 x i8] c"cond_init\00", align 1, !dbg !47
@__func__.cond_destroy = private unnamed_addr constant [13 x i8] c"cond_destroy\00", align 1, !dbg !50
@__func__.cond_signal = private unnamed_addr constant [12 x i8] c"cond_signal\00", align 1, !dbg !52
@__func__.cond_broadcast = private unnamed_addr constant [15 x i8] c"cond_broadcast\00", align 1, !dbg !54
@phase = dso_local global i32 0, align 4, !dbg !59
@cond_mutex = dso_local global %union.pthread_mutex_t zeroinitializer, align 8, !dbg !145
@cond = dso_local global %union.pthread_cond_t zeroinitializer, align 8, !dbg !180
@__func__.cond_test = private unnamed_addr constant [10 x i8] c"cond_test\00", align 1, !dbg !92
@.str.4 = private unnamed_addr constant [18 x i8] c"result == message\00", align 1, !dbg !94
@__func__.rwlock_init = private unnamed_addr constant [12 x i8] c"rwlock_init\00", align 1, !dbg !99
@__func__.rwlock_destroy = private unnamed_addr constant [15 x i8] c"rwlock_destroy\00", align 1, !dbg !101
@__func__.rwlock_wrlock = private unnamed_addr constant [14 x i8] c"rwlock_wrlock\00", align 1, !dbg !103
@__func__.rwlock_rdlock = private unnamed_addr constant [14 x i8] c"rwlock_rdlock\00", align 1, !dbg !105
@__func__.rwlock_unlock = private unnamed_addr constant [14 x i8] c"rwlock_unlock\00", align 1, !dbg !107
@__func__.rwlock_test = private unnamed_addr constant [12 x i8] c"rwlock_test\00", align 1, !dbg !109
@latest_thread = dso_local global i64 0, align 8, !dbg !214
@local_data = dso_local global i32 0, align 4, !dbg !218
@__func__.key_worker = private unnamed_addr constant [11 x i8] c"key_worker\00", align 1, !dbg !111
@.str.5 = private unnamed_addr constant [28 x i8] c"my_local_data == &my_secret\00", align 1, !dbg !113
@__func__.key_test = private unnamed_addr constant [9 x i8] c"key_test\00", align 1, !dbg !118
@.str.6 = private unnamed_addr constant [37 x i8] c"pthread_equal(latest_thread, worker)\00", align 1, !dbg !121
@__func__.detach_test_detach = private unnamed_addr constant [19 x i8] c"detach_test_detach\00", align 1, !dbg !126
@.str.7 = private unnamed_addr constant [12 x i8] c"status != 0\00", align 1, !dbg !131
@__func__.detach_test_attr = private unnamed_addr constant [17 x i8] c"detach_test_attr\00", align 1, !dbg !133
@.str.8 = private unnamed_addr constant [54 x i8] c"status == 0 && detachstate == PTHREAD_CREATE_JOINABLE\00", align 1, !dbg !138
@.str.9 = private unnamed_addr constant [54 x i8] c"status == 0 && detachstate == PTHREAD_CREATE_DETACHED\00", align 1, !dbg !143

; Function Attrs: noinline nounwind uwtable
define dso_local i64 @thread_create(ptr noundef %0, ptr noundef %1) #0 !dbg !229 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i64, align 8
  %6 = alloca %union.pthread_attr_t, align 8
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !236, !DIExpression(), !237)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !238, !DIExpression(), !239)
    #dbg_declare(ptr %5, !240, !DIExpression(), !241)
    #dbg_declare(ptr %6, !242, !DIExpression(), !251)
  %8 = call i32 @pthread_attr_init(ptr noundef %6) #6, !dbg !252
    #dbg_declare(ptr %7, !253, !DIExpression(), !254)
  %9 = load ptr, ptr %3, align 8, !dbg !255
  %10 = load ptr, ptr %4, align 8, !dbg !256
  %11 = call i32 @pthread_create(ptr noundef %5, ptr noundef %6, ptr noundef %9, ptr noundef %10) #7, !dbg !257
  store i32 %11, ptr %7, align 4, !dbg !254
  %12 = load i32, ptr %7, align 4, !dbg !258
  %13 = icmp eq i32 %12, 0, !dbg !258
  %14 = xor i1 %13, true, !dbg !258
  %15 = zext i1 %14 to i32, !dbg !258
  %16 = sext i32 %15 to i64, !dbg !258
  %17 = icmp ne i64 %16, 0, !dbg !258
  br i1 %17, label %18, label %20, !dbg !258

18:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.thread_create, ptr noundef @.str, i32 noundef 18, ptr noundef @.str.1) #8, !dbg !258
  unreachable, !dbg !258

19:                                               ; No predecessors!
  br label %21, !dbg !258

20:                                               ; preds = %2
  br label %21, !dbg !258

21:                                               ; preds = %20, %19
  %22 = call i32 @pthread_attr_destroy(ptr noundef %6) #6, !dbg !259
  %23 = load i64, ptr %5, align 8, !dbg !260
  ret i64 %23, !dbg !261
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_attr_init(ptr noundef) #1

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #3

; Function Attrs: nocallback nounwind
declare i32 @pthread_attr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @thread_join(i64 noundef %0) #0 !dbg !262 {
  %2 = alloca i64, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store i64 %0, ptr %2, align 8
    #dbg_declare(ptr %2, !265, !DIExpression(), !266)
    #dbg_declare(ptr %3, !267, !DIExpression(), !268)
    #dbg_declare(ptr %4, !269, !DIExpression(), !270)
  %5 = load i64, ptr %2, align 8, !dbg !271
  %6 = call i32 @pthread_join(i64 noundef %5, ptr noundef %3), !dbg !272
  store i32 %6, ptr %4, align 4, !dbg !270
  %7 = load i32, ptr %4, align 4, !dbg !273
  %8 = icmp eq i32 %7, 0, !dbg !273
  %9 = xor i1 %8, true, !dbg !273
  %10 = zext i1 %9 to i32, !dbg !273
  %11 = sext i32 %10 to i64, !dbg !273
  %12 = icmp ne i64 %11, 0, !dbg !273
  br i1 %12, label %13, label %15, !dbg !273

13:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.thread_join, ptr noundef @.str, i32 noundef 27, ptr noundef @.str.1) #8, !dbg !273
  unreachable, !dbg !273

14:                                               ; No predecessors!
  br label %16, !dbg !273

15:                                               ; preds = %1
  br label %16, !dbg !273

16:                                               ; preds = %15, %14
  %17 = load ptr, ptr %3, align 8, !dbg !274
  ret ptr %17, !dbg !275
}

declare i32 @pthread_join(i64 noundef, ptr noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_init(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) #0 !dbg !276 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca %union.pthread_mutexattr_t, align 4
  store ptr %0, ptr %5, align 8
    #dbg_declare(ptr %5, !280, !DIExpression(), !281)
  store i32 %1, ptr %6, align 4
    #dbg_declare(ptr %6, !282, !DIExpression(), !283)
  store i32 %2, ptr %7, align 4
    #dbg_declare(ptr %7, !284, !DIExpression(), !285)
  store i32 %3, ptr %8, align 4
    #dbg_declare(ptr %8, !286, !DIExpression(), !287)
    #dbg_declare(ptr %9, !288, !DIExpression(), !289)
    #dbg_declare(ptr %10, !290, !DIExpression(), !291)
    #dbg_declare(ptr %11, !292, !DIExpression(), !301)
  %12 = call i32 @pthread_mutexattr_init(ptr noundef %11) #6, !dbg !302
  store i32 %12, ptr %9, align 4, !dbg !303
  %13 = load i32, ptr %9, align 4, !dbg !304
  %14 = icmp eq i32 %13, 0, !dbg !304
  %15 = xor i1 %14, true, !dbg !304
  %16 = zext i1 %15 to i32, !dbg !304
  %17 = sext i32 %16 to i64, !dbg !304
  %18 = icmp ne i64 %17, 0, !dbg !304
  br i1 %18, label %19, label %21, !dbg !304

19:                                               ; preds = %4
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 47, ptr noundef @.str.1) #8, !dbg !304
  unreachable, !dbg !304

20:                                               ; No predecessors!
  br label %22, !dbg !304

21:                                               ; preds = %4
  br label %22, !dbg !304

22:                                               ; preds = %21, %20
  %23 = load i32, ptr %6, align 4, !dbg !305
  %24 = call i32 @pthread_mutexattr_settype(ptr noundef %11, i32 noundef %23) #6, !dbg !306
  store i32 %24, ptr %9, align 4, !dbg !307
  %25 = load i32, ptr %9, align 4, !dbg !308
  %26 = icmp eq i32 %25, 0, !dbg !308
  %27 = xor i1 %26, true, !dbg !308
  %28 = zext i1 %27 to i32, !dbg !308
  %29 = sext i32 %28 to i64, !dbg !308
  %30 = icmp ne i64 %29, 0, !dbg !308
  br i1 %30, label %31, label %33, !dbg !308

31:                                               ; preds = %22
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 50, ptr noundef @.str.1) #8, !dbg !308
  unreachable, !dbg !308

32:                                               ; No predecessors!
  br label %34, !dbg !308

33:                                               ; preds = %22
  br label %34, !dbg !308

34:                                               ; preds = %33, %32
  %35 = call i32 @pthread_mutexattr_gettype(ptr noundef %11, ptr noundef %10) #6, !dbg !309
  store i32 %35, ptr %9, align 4, !dbg !310
  %36 = load i32, ptr %9, align 4, !dbg !311
  %37 = icmp eq i32 %36, 0, !dbg !311
  %38 = xor i1 %37, true, !dbg !311
  %39 = zext i1 %38 to i32, !dbg !311
  %40 = sext i32 %39 to i64, !dbg !311
  %41 = icmp ne i64 %40, 0, !dbg !311
  br i1 %41, label %42, label %44, !dbg !311

42:                                               ; preds = %34
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 52, ptr noundef @.str.1) #8, !dbg !311
  unreachable, !dbg !311

43:                                               ; No predecessors!
  br label %45, !dbg !311

44:                                               ; preds = %34
  br label %45, !dbg !311

45:                                               ; preds = %44, %43
  %46 = load i32, ptr %7, align 4, !dbg !312
  %47 = call i32 @pthread_mutexattr_setprotocol(ptr noundef %11, i32 noundef %46) #6, !dbg !313
  store i32 %47, ptr %9, align 4, !dbg !314
  %48 = load i32, ptr %9, align 4, !dbg !315
  %49 = icmp eq i32 %48, 0, !dbg !315
  %50 = xor i1 %49, true, !dbg !315
  %51 = zext i1 %50 to i32, !dbg !315
  %52 = sext i32 %51 to i64, !dbg !315
  %53 = icmp ne i64 %52, 0, !dbg !315
  br i1 %53, label %54, label %56, !dbg !315

54:                                               ; preds = %45
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 55, ptr noundef @.str.1) #8, !dbg !315
  unreachable, !dbg !315

55:                                               ; No predecessors!
  br label %57, !dbg !315

56:                                               ; preds = %45
  br label %57, !dbg !315

57:                                               ; preds = %56, %55
  %58 = call i32 @pthread_mutexattr_getprotocol(ptr noundef %11, ptr noundef %10) #6, !dbg !316
  store i32 %58, ptr %9, align 4, !dbg !317
  %59 = load i32, ptr %9, align 4, !dbg !318
  %60 = icmp eq i32 %59, 0, !dbg !318
  %61 = xor i1 %60, true, !dbg !318
  %62 = zext i1 %61 to i32, !dbg !318
  %63 = sext i32 %62 to i64, !dbg !318
  %64 = icmp ne i64 %63, 0, !dbg !318
  br i1 %64, label %65, label %67, !dbg !318

65:                                               ; preds = %57
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 57, ptr noundef @.str.1) #8, !dbg !318
  unreachable, !dbg !318

66:                                               ; No predecessors!
  br label %68, !dbg !318

67:                                               ; preds = %57
  br label %68, !dbg !318

68:                                               ; preds = %67, %66
  %69 = load i32, ptr %8, align 4, !dbg !319
  %70 = call i32 @pthread_mutexattr_setprioceiling(ptr noundef %11, i32 noundef %69) #6, !dbg !320
  store i32 %70, ptr %9, align 4, !dbg !321
  %71 = load i32, ptr %9, align 4, !dbg !322
  %72 = icmp eq i32 %71, 0, !dbg !322
  %73 = xor i1 %72, true, !dbg !322
  %74 = zext i1 %73 to i32, !dbg !322
  %75 = sext i32 %74 to i64, !dbg !322
  %76 = icmp ne i64 %75, 0, !dbg !322
  br i1 %76, label %77, label %79, !dbg !322

77:                                               ; preds = %68
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 60, ptr noundef @.str.1) #8, !dbg !322
  unreachable, !dbg !322

78:                                               ; No predecessors!
  br label %80, !dbg !322

79:                                               ; preds = %68
  br label %80, !dbg !322

80:                                               ; preds = %79, %78
  %81 = call i32 @pthread_mutexattr_getprioceiling(ptr noundef %11, ptr noundef %10) #6, !dbg !323
  store i32 %81, ptr %9, align 4, !dbg !324
  %82 = load i32, ptr %9, align 4, !dbg !325
  %83 = icmp eq i32 %82, 0, !dbg !325
  %84 = xor i1 %83, true, !dbg !325
  %85 = zext i1 %84 to i32, !dbg !325
  %86 = sext i32 %85 to i64, !dbg !325
  %87 = icmp ne i64 %86, 0, !dbg !325
  br i1 %87, label %88, label %90, !dbg !325

88:                                               ; preds = %80
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 62, ptr noundef @.str.1) #8, !dbg !325
  unreachable, !dbg !325

89:                                               ; No predecessors!
  br label %91, !dbg !325

90:                                               ; preds = %80
  br label %91, !dbg !325

91:                                               ; preds = %90, %89
  %92 = load ptr, ptr %5, align 8, !dbg !326
  %93 = call i32 @pthread_mutex_init(ptr noundef %92, ptr noundef %11) #6, !dbg !327
  store i32 %93, ptr %9, align 4, !dbg !328
  %94 = load i32, ptr %9, align 4, !dbg !329
  %95 = icmp eq i32 %94, 0, !dbg !329
  %96 = xor i1 %95, true, !dbg !329
  %97 = zext i1 %96 to i32, !dbg !329
  %98 = sext i32 %97 to i64, !dbg !329
  %99 = icmp ne i64 %98, 0, !dbg !329
  br i1 %99, label %100, label %102, !dbg !329

100:                                              ; preds = %91
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 65, ptr noundef @.str.1) #8, !dbg !329
  unreachable, !dbg !329

101:                                              ; No predecessors!
  br label %103, !dbg !329

102:                                              ; preds = %91
  br label %103, !dbg !329

103:                                              ; preds = %102, %101
  %104 = call i32 @pthread_mutexattr_destroy(ptr noundef %11) #6, !dbg !330
  store i32 %104, ptr %9, align 4, !dbg !331
  %105 = load i32, ptr %9, align 4, !dbg !332
  %106 = icmp eq i32 %105, 0, !dbg !332
  %107 = xor i1 %106, true, !dbg !332
  %108 = zext i1 %107 to i32, !dbg !332
  %109 = sext i32 %108 to i64, !dbg !332
  %110 = icmp ne i64 %109, 0, !dbg !332
  br i1 %110, label %111, label %113, !dbg !332

111:                                              ; preds = %103
  call void @__assert_rtn(ptr noundef @__func__.mutex_init, ptr noundef @.str, i32 noundef 67, ptr noundef @.str.1) #8, !dbg !332
  unreachable, !dbg !332

112:                                              ; No predecessors!
  br label %114, !dbg !332

113:                                              ; preds = %103
  br label %114, !dbg !332

114:                                              ; preds = %113, %112
  ret void, !dbg !333
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutexattr_init(ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutexattr_settype(ptr noundef, i32 noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutexattr_gettype(ptr noundef, ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutexattr_setprotocol(ptr noundef, i32 noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutexattr_getprotocol(ptr noundef, ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutexattr_setprioceiling(ptr noundef, i32 noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutexattr_getprioceiling(ptr noundef, ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutexattr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_destroy(ptr noundef %0) #0 !dbg !334 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !337, !DIExpression(), !338)
    #dbg_declare(ptr %3, !339, !DIExpression(), !340)
  %4 = load ptr, ptr %2, align 8, !dbg !341
  %5 = call i32 @pthread_mutex_destroy(ptr noundef %4) #6, !dbg !342
  store i32 %5, ptr %3, align 4, !dbg !340
  %6 = load i32, ptr %3, align 4, !dbg !343
  %7 = icmp eq i32 %6, 0, !dbg !343
  %8 = xor i1 %7, true, !dbg !343
  %9 = zext i1 %8 to i32, !dbg !343
  %10 = sext i32 %9 to i64, !dbg !343
  %11 = icmp ne i64 %10, 0, !dbg !343
  br i1 %11, label %12, label %14, !dbg !343

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_destroy, ptr noundef @.str, i32 noundef 73, ptr noundef @.str.1) #8, !dbg !343
  unreachable, !dbg !343

13:                                               ; No predecessors!
  br label %15, !dbg !343

14:                                               ; preds = %1
  br label %15, !dbg !343

15:                                               ; preds = %14, %13
  ret void, !dbg !344
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_mutex_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_lock(ptr noundef %0) #0 !dbg !345 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !346, !DIExpression(), !347)
    #dbg_declare(ptr %3, !348, !DIExpression(), !349)
  %4 = load ptr, ptr %2, align 8, !dbg !350
  %5 = call i32 @pthread_mutex_lock(ptr noundef %4) #7, !dbg !351
  store i32 %5, ptr %3, align 4, !dbg !349
  %6 = load i32, ptr %3, align 4, !dbg !352
  %7 = icmp eq i32 %6, 0, !dbg !352
  %8 = xor i1 %7, true, !dbg !352
  %9 = zext i1 %8 to i32, !dbg !352
  %10 = sext i32 %9 to i64, !dbg !352
  %11 = icmp ne i64 %10, 0, !dbg !352
  br i1 %11, label %12, label %14, !dbg !352

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_lock, ptr noundef @.str, i32 noundef 79, ptr noundef @.str.1) #8, !dbg !352
  unreachable, !dbg !352

13:                                               ; No predecessors!
  br label %15, !dbg !352

14:                                               ; preds = %1
  br label %15, !dbg !352

15:                                               ; preds = %14, %13
  ret void, !dbg !353
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @mutex_trylock(ptr noundef %0) #0 !dbg !354 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !358, !DIExpression(), !359)
    #dbg_declare(ptr %3, !360, !DIExpression(), !361)
  %4 = load ptr, ptr %2, align 8, !dbg !362
  %5 = call i32 @pthread_mutex_trylock(ptr noundef %4) #7, !dbg !363
  store i32 %5, ptr %3, align 4, !dbg !361
  %6 = load i32, ptr %3, align 4, !dbg !364
  %7 = icmp eq i32 %6, 0, !dbg !365
  ret i1 %7, !dbg !366
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_trylock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_unlock(ptr noundef %0) #0 !dbg !367 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !368, !DIExpression(), !369)
    #dbg_declare(ptr %3, !370, !DIExpression(), !371)
  %4 = load ptr, ptr %2, align 8, !dbg !372
  %5 = call i32 @pthread_mutex_unlock(ptr noundef %4) #7, !dbg !373
  store i32 %5, ptr %3, align 4, !dbg !371
  %6 = load i32, ptr %3, align 4, !dbg !374
  %7 = icmp eq i32 %6, 0, !dbg !374
  %8 = xor i1 %7, true, !dbg !374
  %9 = zext i1 %8 to i32, !dbg !374
  %10 = sext i32 %9 to i64, !dbg !374
  %11 = icmp ne i64 %10, 0, !dbg !374
  br i1 %11, label %12, label %14, !dbg !374

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.mutex_unlock, ptr noundef @.str, i32 noundef 92, ptr noundef @.str.1) #8, !dbg !374
  unreachable, !dbg !374

13:                                               ; No predecessors!
  br label %15, !dbg !374

14:                                               ; preds = %1
  br label %15, !dbg !374

15:                                               ; preds = %14, %13
  ret void, !dbg !375
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @mutex_test() #0 !dbg !376 {
  %1 = alloca %union.pthread_mutex_t, align 8
  %2 = alloca %union.pthread_mutex_t, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  %5 = alloca i8, align 1
    #dbg_declare(ptr %1, !379, !DIExpression(), !380)
    #dbg_declare(ptr %2, !381, !DIExpression(), !382)
  call void @mutex_init(ptr noundef %1, i32 noundef 2, i32 noundef 1, i32 noundef 1), !dbg !383
  call void @mutex_init(ptr noundef %2, i32 noundef 1, i32 noundef 2, i32 noundef 2), !dbg !384
  call void @mutex_lock(ptr noundef %1), !dbg !385
    #dbg_declare(ptr %3, !387, !DIExpression(), !388)
  %6 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !389
  %7 = zext i1 %6 to i8, !dbg !388
  store i8 %7, ptr %3, align 1, !dbg !388
  %8 = load i8, ptr %3, align 1, !dbg !390
  %9 = trunc i8 %8 to i1, !dbg !390
  %10 = xor i1 %9, true, !dbg !390
  %11 = xor i1 %10, true, !dbg !390
  %12 = zext i1 %11 to i32, !dbg !390
  %13 = sext i32 %12 to i64, !dbg !390
  %14 = icmp ne i64 %13, 0, !dbg !390
  br i1 %14, label %15, label %17, !dbg !390

15:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 106, ptr noundef @.str.2) #8, !dbg !390
  unreachable, !dbg !390

16:                                               ; No predecessors!
  br label %18, !dbg !390

17:                                               ; preds = %0
  br label %18, !dbg !390

18:                                               ; preds = %17, %16
  call void @mutex_unlock(ptr noundef %1), !dbg !391
  call void @mutex_lock(ptr noundef %2), !dbg !392
    #dbg_declare(ptr %4, !394, !DIExpression(), !396)
  %19 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !397
  %20 = zext i1 %19 to i8, !dbg !396
  store i8 %20, ptr %4, align 1, !dbg !396
  %21 = load i8, ptr %4, align 1, !dbg !398
  %22 = trunc i8 %21 to i1, !dbg !398
  %23 = xor i1 %22, true, !dbg !398
  %24 = zext i1 %23 to i32, !dbg !398
  %25 = sext i32 %24 to i64, !dbg !398
  %26 = icmp ne i64 %25, 0, !dbg !398
  br i1 %26, label %27, label %29, !dbg !398

27:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 115, ptr noundef @.str.3) #8, !dbg !398
  unreachable, !dbg !398

28:                                               ; No predecessors!
  br label %30, !dbg !398

29:                                               ; preds = %18
  br label %30, !dbg !398

30:                                               ; preds = %29, %28
  call void @mutex_unlock(ptr noundef %1), !dbg !399
    #dbg_declare(ptr %5, !400, !DIExpression(), !402)
  %31 = call zeroext i1 @mutex_trylock(ptr noundef %1), !dbg !403
  %32 = zext i1 %31 to i8, !dbg !402
  store i8 %32, ptr %5, align 1, !dbg !402
  %33 = load i8, ptr %5, align 1, !dbg !404
  %34 = trunc i8 %33 to i1, !dbg !404
  %35 = xor i1 %34, true, !dbg !404
  %36 = zext i1 %35 to i32, !dbg !404
  %37 = sext i32 %36 to i64, !dbg !404
  %38 = icmp ne i64 %37, 0, !dbg !404
  br i1 %38, label %39, label %41, !dbg !404

39:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.mutex_test, ptr noundef @.str, i32 noundef 121, ptr noundef @.str.3) #8, !dbg !404
  unreachable, !dbg !404

40:                                               ; No predecessors!
  br label %42, !dbg !404

41:                                               ; preds = %30
  br label %42, !dbg !404

42:                                               ; preds = %41, %40
  call void @mutex_unlock(ptr noundef %1), !dbg !405
  call void @mutex_unlock(ptr noundef %2), !dbg !406
  call void @mutex_destroy(ptr noundef %2), !dbg !407
  call void @mutex_destroy(ptr noundef %1), !dbg !408
  ret void, !dbg !409
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_init(ptr noundef %0) #0 !dbg !410 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca %union.pthread_condattr_t, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !414, !DIExpression(), !415)
    #dbg_declare(ptr %3, !416, !DIExpression(), !417)
    #dbg_declare(ptr %4, !418, !DIExpression(), !424)
  %5 = call i32 @pthread_condattr_init(ptr noundef %4) #6, !dbg !425
  store i32 %5, ptr %3, align 4, !dbg !426
  %6 = load i32, ptr %3, align 4, !dbg !427
  %7 = icmp eq i32 %6, 0, !dbg !427
  %8 = xor i1 %7, true, !dbg !427
  %9 = zext i1 %8 to i32, !dbg !427
  %10 = sext i32 %9 to i64, !dbg !427
  %11 = icmp ne i64 %10, 0, !dbg !427
  br i1 %11, label %12, label %14, !dbg !427

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 147, ptr noundef @.str.1) #8, !dbg !427
  unreachable, !dbg !427

13:                                               ; No predecessors!
  br label %15, !dbg !427

14:                                               ; preds = %1
  br label %15, !dbg !427

15:                                               ; preds = %14, %13
  %16 = load ptr, ptr %2, align 8, !dbg !428
  %17 = call i32 @pthread_cond_init(ptr noundef %16, ptr noundef %4) #6, !dbg !429
  store i32 %17, ptr %3, align 4, !dbg !430
  %18 = load i32, ptr %3, align 4, !dbg !431
  %19 = icmp eq i32 %18, 0, !dbg !431
  %20 = xor i1 %19, true, !dbg !431
  %21 = zext i1 %20 to i32, !dbg !431
  %22 = sext i32 %21 to i64, !dbg !431
  %23 = icmp ne i64 %22, 0, !dbg !431
  br i1 %23, label %24, label %26, !dbg !431

24:                                               ; preds = %15
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 150, ptr noundef @.str.1) #8, !dbg !431
  unreachable, !dbg !431

25:                                               ; No predecessors!
  br label %27, !dbg !431

26:                                               ; preds = %15
  br label %27, !dbg !431

27:                                               ; preds = %26, %25
  %28 = call i32 @pthread_condattr_destroy(ptr noundef %4) #6, !dbg !432
  store i32 %28, ptr %3, align 4, !dbg !433
  %29 = load i32, ptr %3, align 4, !dbg !434
  %30 = icmp eq i32 %29, 0, !dbg !434
  %31 = xor i1 %30, true, !dbg !434
  %32 = zext i1 %31 to i32, !dbg !434
  %33 = sext i32 %32 to i64, !dbg !434
  %34 = icmp ne i64 %33, 0, !dbg !434
  br i1 %34, label %35, label %37, !dbg !434

35:                                               ; preds = %27
  call void @__assert_rtn(ptr noundef @__func__.cond_init, ptr noundef @.str, i32 noundef 153, ptr noundef @.str.1) #8, !dbg !434
  unreachable, !dbg !434

36:                                               ; No predecessors!
  br label %38, !dbg !434

37:                                               ; preds = %27
  br label %38, !dbg !434

38:                                               ; preds = %37, %36
  ret void, !dbg !435
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_condattr_init(ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_cond_init(ptr noundef, ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_condattr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_destroy(ptr noundef %0) #0 !dbg !436 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !437, !DIExpression(), !438)
    #dbg_declare(ptr %3, !439, !DIExpression(), !440)
  %4 = load ptr, ptr %2, align 8, !dbg !441
  %5 = call i32 @pthread_cond_destroy(ptr noundef %4) #6, !dbg !442
  store i32 %5, ptr %3, align 4, !dbg !440
  %6 = load i32, ptr %3, align 4, !dbg !443
  %7 = icmp eq i32 %6, 0, !dbg !443
  %8 = xor i1 %7, true, !dbg !443
  %9 = zext i1 %8 to i32, !dbg !443
  %10 = sext i32 %9 to i64, !dbg !443
  %11 = icmp ne i64 %10, 0, !dbg !443
  br i1 %11, label %12, label %14, !dbg !443

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_destroy, ptr noundef @.str, i32 noundef 159, ptr noundef @.str.1) #8, !dbg !443
  unreachable, !dbg !443

13:                                               ; No predecessors!
  br label %15, !dbg !443

14:                                               ; preds = %1
  br label %15, !dbg !443

15:                                               ; preds = %14, %13
  ret void, !dbg !444
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_cond_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_signal(ptr noundef %0) #0 !dbg !445 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !446, !DIExpression(), !447)
    #dbg_declare(ptr %3, !448, !DIExpression(), !449)
  %4 = load ptr, ptr %2, align 8, !dbg !450
  %5 = call i32 @pthread_cond_signal(ptr noundef %4) #7, !dbg !451
  store i32 %5, ptr %3, align 4, !dbg !449
  %6 = load i32, ptr %3, align 4, !dbg !452
  %7 = icmp eq i32 %6, 0, !dbg !452
  %8 = xor i1 %7, true, !dbg !452
  %9 = zext i1 %8 to i32, !dbg !452
  %10 = sext i32 %9 to i64, !dbg !452
  %11 = icmp ne i64 %10, 0, !dbg !452
  br i1 %11, label %12, label %14, !dbg !452

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_signal, ptr noundef @.str, i32 noundef 165, ptr noundef @.str.1) #8, !dbg !452
  unreachable, !dbg !452

13:                                               ; No predecessors!
  br label %15, !dbg !452

14:                                               ; preds = %1
  br label %15, !dbg !452

15:                                               ; preds = %14, %13
  ret void, !dbg !453
}

; Function Attrs: nounwind
declare i32 @pthread_cond_signal(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_broadcast(ptr noundef %0) #0 !dbg !454 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !455, !DIExpression(), !456)
    #dbg_declare(ptr %3, !457, !DIExpression(), !458)
  %4 = load ptr, ptr %2, align 8, !dbg !459
  %5 = call i32 @pthread_cond_broadcast(ptr noundef %4) #7, !dbg !460
  store i32 %5, ptr %3, align 4, !dbg !458
  %6 = load i32, ptr %3, align 4, !dbg !461
  %7 = icmp eq i32 %6, 0, !dbg !461
  %8 = xor i1 %7, true, !dbg !461
  %9 = zext i1 %8 to i32, !dbg !461
  %10 = sext i32 %9 to i64, !dbg !461
  %11 = icmp ne i64 %10, 0, !dbg !461
  br i1 %11, label %12, label %14, !dbg !461

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.cond_broadcast, ptr noundef @.str, i32 noundef 171, ptr noundef @.str.1) #8, !dbg !461
  unreachable, !dbg !461

13:                                               ; No predecessors!
  br label %15, !dbg !461

14:                                               ; preds = %1
  br label %15, !dbg !461

15:                                               ; preds = %14, %13
  ret void, !dbg !462
}

; Function Attrs: nounwind
declare i32 @pthread_cond_broadcast(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_wait(ptr noundef %0, ptr noundef %1) #0 !dbg !463 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !466, !DIExpression(), !467)
  store ptr %1, ptr %4, align 8
    #dbg_declare(ptr %4, !468, !DIExpression(), !469)
    #dbg_declare(ptr %5, !470, !DIExpression(), !471)
  %6 = load ptr, ptr %3, align 8, !dbg !472
  %7 = load ptr, ptr %4, align 8, !dbg !473
  %8 = call i32 @pthread_cond_wait(ptr noundef %6, ptr noundef %7), !dbg !474
  store i32 %8, ptr %5, align 4, !dbg !471
  ret void, !dbg !475
}

declare i32 @pthread_cond_wait(ptr noundef, ptr noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_timedwait(ptr noundef %0, ptr noundef %1, i64 noundef %2) #0 !dbg !476 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.timespec, align 8
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !479, !DIExpression(), !480)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !481, !DIExpression(), !482)
  store i64 %2, ptr %6, align 8
    #dbg_declare(ptr %6, !483, !DIExpression(), !484)
    #dbg_declare(ptr %7, !485, !DIExpression(), !492)
  %9 = load i64, ptr %6, align 8, !dbg !493
    #dbg_declare(ptr %8, !494, !DIExpression(), !495)
  %10 = load ptr, ptr %4, align 8, !dbg !496
  %11 = load ptr, ptr %5, align 8, !dbg !497
  %12 = call i32 @pthread_cond_timedwait(ptr noundef %10, ptr noundef %11, ptr noundef %7), !dbg !498
  store i32 %12, ptr %8, align 4, !dbg !495
  ret void, !dbg !499
}

declare i32 @pthread_cond_timedwait(ptr noundef, ptr noundef, ptr noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @cond_worker(ptr noundef %0) #0 !dbg !500 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i8, align 1
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !501, !DIExpression(), !502)
    #dbg_declare(ptr %4, !503, !DIExpression(), !504)
  store i8 1, ptr %4, align 1, !dbg !504
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !505
  %5 = load i32, ptr @phase, align 4, !dbg !507
  %6 = add nsw i32 %5, 1, !dbg !507
  store i32 %6, ptr @phase, align 4, !dbg !507
  call void @cond_wait(ptr noundef @cond, ptr noundef @cond_mutex), !dbg !508
  %7 = load i32, ptr @phase, align 4, !dbg !509
  %8 = add nsw i32 %7, 1, !dbg !509
  store i32 %8, ptr @phase, align 4, !dbg !509
  %9 = load i32, ptr @phase, align 4, !dbg !510
  %10 = icmp slt i32 %9, 2, !dbg !511
  %11 = zext i1 %10 to i8, !dbg !512
  store i8 %11, ptr %4, align 1, !dbg !512
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !513
  %12 = load i8, ptr %4, align 1, !dbg !514
  %13 = trunc i8 %12 to i1, !dbg !514
  br i1 %13, label %14, label %17, !dbg !516

14:                                               ; preds = %1
  %15 = load ptr, ptr %3, align 8, !dbg !517
  %16 = getelementptr inbounds i8, ptr %15, i64 1, !dbg !518
  store ptr %16, ptr %2, align 8, !dbg !519
  br label %32, !dbg !519

17:                                               ; preds = %1
  store i8 1, ptr %4, align 1, !dbg !520
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !521
  %18 = load i32, ptr @phase, align 4, !dbg !523
  %19 = add nsw i32 %18, 1, !dbg !523
  store i32 %19, ptr @phase, align 4, !dbg !523
  call void @cond_timedwait(ptr noundef @cond, ptr noundef @cond_mutex, i64 noundef 10), !dbg !524
  %20 = load i32, ptr @phase, align 4, !dbg !525
  %21 = add nsw i32 %20, 1, !dbg !525
  store i32 %21, ptr @phase, align 4, !dbg !525
  %22 = load i32, ptr @phase, align 4, !dbg !526
  %23 = icmp sgt i32 %22, 6, !dbg !527
  %24 = zext i1 %23 to i8, !dbg !528
  store i8 %24, ptr %4, align 1, !dbg !528
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !529
  %25 = load i8, ptr %4, align 1, !dbg !530
  %26 = trunc i8 %25 to i1, !dbg !530
  br i1 %26, label %27, label %30, !dbg !532

27:                                               ; preds = %17
  %28 = load ptr, ptr %3, align 8, !dbg !533
  %29 = getelementptr inbounds i8, ptr %28, i64 2, !dbg !534
  store ptr %29, ptr %2, align 8, !dbg !535
  br label %32, !dbg !535

30:                                               ; preds = %17
  %31 = load ptr, ptr %3, align 8, !dbg !536
  store ptr %31, ptr %2, align 8, !dbg !537
  br label %32, !dbg !537

32:                                               ; preds = %30, %27, %14
  %33 = load ptr, ptr %2, align 8, !dbg !538
  ret ptr %33, !dbg !538
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @cond_test() #0 !dbg !539 {
  %1 = alloca ptr, align 8
  %2 = alloca i64, align 8
  %3 = alloca ptr, align 8
    #dbg_declare(ptr %1, !540, !DIExpression(), !541)
  store ptr inttoptr (i64 42 to ptr), ptr %1, align 8, !dbg !541
  call void @mutex_init(ptr noundef @cond_mutex, i32 noundef 0, i32 noundef 0, i32 noundef 0), !dbg !542
  call void @cond_init(ptr noundef @cond), !dbg !543
    #dbg_declare(ptr %2, !544, !DIExpression(), !545)
  %4 = load ptr, ptr %1, align 8, !dbg !546
  %5 = call i64 @thread_create(ptr noundef @cond_worker, ptr noundef %4), !dbg !547
  store i64 %5, ptr %2, align 8, !dbg !545
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !548
  %6 = load i32, ptr @phase, align 4, !dbg !550
  %7 = add nsw i32 %6, 1, !dbg !550
  store i32 %7, ptr @phase, align 4, !dbg !550
  call void @cond_signal(ptr noundef @cond), !dbg !551
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !552
  call void @mutex_lock(ptr noundef @cond_mutex), !dbg !553
  %8 = load i32, ptr @phase, align 4, !dbg !555
  %9 = add nsw i32 %8, 1, !dbg !555
  store i32 %9, ptr @phase, align 4, !dbg !555
  call void @cond_broadcast(ptr noundef @cond), !dbg !556
  call void @mutex_unlock(ptr noundef @cond_mutex), !dbg !557
    #dbg_declare(ptr %3, !558, !DIExpression(), !559)
  %10 = load i64, ptr %2, align 8, !dbg !560
  %11 = call ptr @thread_join(i64 noundef %10), !dbg !561
  store ptr %11, ptr %3, align 8, !dbg !559
  %12 = load ptr, ptr %3, align 8, !dbg !562
  %13 = load ptr, ptr %1, align 8, !dbg !562
  %14 = icmp eq ptr %12, %13, !dbg !562
  %15 = xor i1 %14, true, !dbg !562
  %16 = zext i1 %15 to i32, !dbg !562
  %17 = sext i32 %16 to i64, !dbg !562
  %18 = icmp ne i64 %17, 0, !dbg !562
  br i1 %18, label %19, label %21, !dbg !562

19:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.cond_test, ptr noundef @.str, i32 noundef 245, ptr noundef @.str.4) #8, !dbg !562
  unreachable, !dbg !562

20:                                               ; No predecessors!
  br label %22, !dbg !562

21:                                               ; preds = %0
  br label %22, !dbg !562

22:                                               ; preds = %21, %20
  call void @cond_destroy(ptr noundef @cond), !dbg !563
  call void @mutex_destroy(ptr noundef @cond_mutex), !dbg !564
  ret void, !dbg !565
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_init(ptr noundef %0, i32 noundef %1) #0 !dbg !566 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca %union.pthread_rwlockattr_t, align 8
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !594, !DIExpression(), !595)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !596, !DIExpression(), !597)
    #dbg_declare(ptr %5, !598, !DIExpression(), !599)
    #dbg_declare(ptr %6, !600, !DIExpression(), !601)
    #dbg_declare(ptr %7, !602, !DIExpression(), !608)
  %8 = call i32 @pthread_rwlockattr_init(ptr noundef %7) #6, !dbg !609
  store i32 %8, ptr %5, align 4, !dbg !610
  %9 = load i32, ptr %5, align 4, !dbg !611
  %10 = icmp eq i32 %9, 0, !dbg !611
  %11 = xor i1 %10, true, !dbg !611
  %12 = zext i1 %11 to i32, !dbg !611
  %13 = sext i32 %12 to i64, !dbg !611
  %14 = icmp ne i64 %13, 0, !dbg !611
  br i1 %14, label %15, label %17, !dbg !611

15:                                               ; preds = %2
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 262, ptr noundef @.str.1) #8, !dbg !611
  unreachable, !dbg !611

16:                                               ; No predecessors!
  br label %18, !dbg !611

17:                                               ; preds = %2
  br label %18, !dbg !611

18:                                               ; preds = %17, %16
  %19 = load i32, ptr %4, align 4, !dbg !612
  %20 = call i32 @pthread_rwlockattr_setpshared(ptr noundef %7, i32 noundef %19) #6, !dbg !613
  store i32 %20, ptr %5, align 4, !dbg !614
  %21 = load i32, ptr %5, align 4, !dbg !615
  %22 = icmp eq i32 %21, 0, !dbg !615
  %23 = xor i1 %22, true, !dbg !615
  %24 = zext i1 %23 to i32, !dbg !615
  %25 = sext i32 %24 to i64, !dbg !615
  %26 = icmp ne i64 %25, 0, !dbg !615
  br i1 %26, label %27, label %29, !dbg !615

27:                                               ; preds = %18
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 265, ptr noundef @.str.1) #8, !dbg !615
  unreachable, !dbg !615

28:                                               ; No predecessors!
  br label %30, !dbg !615

29:                                               ; preds = %18
  br label %30, !dbg !615

30:                                               ; preds = %29, %28
  %31 = call i32 @pthread_rwlockattr_getpshared(ptr noundef %7, ptr noundef %6) #6, !dbg !616
  store i32 %31, ptr %5, align 4, !dbg !617
  %32 = load i32, ptr %5, align 4, !dbg !618
  %33 = icmp eq i32 %32, 0, !dbg !618
  %34 = xor i1 %33, true, !dbg !618
  %35 = zext i1 %34 to i32, !dbg !618
  %36 = sext i32 %35 to i64, !dbg !618
  %37 = icmp ne i64 %36, 0, !dbg !618
  br i1 %37, label %38, label %40, !dbg !618

38:                                               ; preds = %30
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 267, ptr noundef @.str.1) #8, !dbg !618
  unreachable, !dbg !618

39:                                               ; No predecessors!
  br label %41, !dbg !618

40:                                               ; preds = %30
  br label %41, !dbg !618

41:                                               ; preds = %40, %39
  %42 = load ptr, ptr %3, align 8, !dbg !619
  %43 = call i32 @pthread_rwlock_init(ptr noundef %42, ptr noundef %7) #6, !dbg !620
  store i32 %43, ptr %5, align 4, !dbg !621
  %44 = load i32, ptr %5, align 4, !dbg !622
  %45 = icmp eq i32 %44, 0, !dbg !622
  %46 = xor i1 %45, true, !dbg !622
  %47 = zext i1 %46 to i32, !dbg !622
  %48 = sext i32 %47 to i64, !dbg !622
  %49 = icmp ne i64 %48, 0, !dbg !622
  br i1 %49, label %50, label %52, !dbg !622

50:                                               ; preds = %41
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 270, ptr noundef @.str.1) #8, !dbg !622
  unreachable, !dbg !622

51:                                               ; No predecessors!
  br label %53, !dbg !622

52:                                               ; preds = %41
  br label %53, !dbg !622

53:                                               ; preds = %52, %51
  %54 = call i32 @pthread_rwlockattr_destroy(ptr noundef %7) #6, !dbg !623
  store i32 %54, ptr %5, align 4, !dbg !624
  %55 = load i32, ptr %5, align 4, !dbg !625
  %56 = icmp eq i32 %55, 0, !dbg !625
  %57 = xor i1 %56, true, !dbg !625
  %58 = zext i1 %57 to i32, !dbg !625
  %59 = sext i32 %58 to i64, !dbg !625
  %60 = icmp ne i64 %59, 0, !dbg !625
  br i1 %60, label %61, label %63, !dbg !625

61:                                               ; preds = %53
  call void @__assert_rtn(ptr noundef @__func__.rwlock_init, ptr noundef @.str, i32 noundef 272, ptr noundef @.str.1) #8, !dbg !625
  unreachable, !dbg !625

62:                                               ; No predecessors!
  br label %64, !dbg !625

63:                                               ; preds = %53
  br label %64, !dbg !625

64:                                               ; preds = %63, %62
  ret void, !dbg !626
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_rwlockattr_init(ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_rwlockattr_setpshared(ptr noundef, i32 noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_rwlockattr_getpshared(ptr noundef, ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_rwlock_init(ptr noundef, ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_rwlockattr_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_destroy(ptr noundef %0) #0 !dbg !627 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !630, !DIExpression(), !631)
    #dbg_declare(ptr %3, !632, !DIExpression(), !633)
  %4 = load ptr, ptr %2, align 8, !dbg !634
  %5 = call i32 @pthread_rwlock_destroy(ptr noundef %4) #6, !dbg !635
  store i32 %5, ptr %3, align 4, !dbg !633
  %6 = load i32, ptr %3, align 4, !dbg !636
  %7 = icmp eq i32 %6, 0, !dbg !636
  %8 = xor i1 %7, true, !dbg !636
  %9 = zext i1 %8 to i32, !dbg !636
  %10 = sext i32 %9 to i64, !dbg !636
  %11 = icmp ne i64 %10, 0, !dbg !636
  br i1 %11, label %12, label %14, !dbg !636

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_destroy, ptr noundef @.str, i32 noundef 278, ptr noundef @.str.1) #8, !dbg !636
  unreachable, !dbg !636

13:                                               ; No predecessors!
  br label %15, !dbg !636

14:                                               ; preds = %1
  br label %15, !dbg !636

15:                                               ; preds = %14, %13
  ret void, !dbg !637
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_rwlock_destroy(ptr noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_wrlock(ptr noundef %0) #0 !dbg !638 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !639, !DIExpression(), !640)
    #dbg_declare(ptr %3, !641, !DIExpression(), !642)
  %4 = load ptr, ptr %2, align 8, !dbg !643
  %5 = call i32 @pthread_rwlock_wrlock(ptr noundef %4) #7, !dbg !644
  store i32 %5, ptr %3, align 4, !dbg !642
  %6 = load i32, ptr %3, align 4, !dbg !645
  %7 = icmp eq i32 %6, 0, !dbg !645
  %8 = xor i1 %7, true, !dbg !645
  %9 = zext i1 %8 to i32, !dbg !645
  %10 = sext i32 %9 to i64, !dbg !645
  %11 = icmp ne i64 %10, 0, !dbg !645
  br i1 %11, label %12, label %14, !dbg !645

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_wrlock, ptr noundef @.str, i32 noundef 284, ptr noundef @.str.1) #8, !dbg !645
  unreachable, !dbg !645

13:                                               ; No predecessors!
  br label %15, !dbg !645

14:                                               ; preds = %1
  br label %15, !dbg !645

15:                                               ; preds = %14, %13
  ret void, !dbg !646
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_wrlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @rwlock_trywrlock(ptr noundef %0) #0 !dbg !647 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !650, !DIExpression(), !651)
    #dbg_declare(ptr %3, !652, !DIExpression(), !653)
  %4 = load ptr, ptr %2, align 8, !dbg !654
  %5 = call i32 @pthread_rwlock_trywrlock(ptr noundef %4) #7, !dbg !655
  store i32 %5, ptr %3, align 4, !dbg !653
  %6 = load i32, ptr %3, align 4, !dbg !656
  %7 = icmp eq i32 %6, 0, !dbg !657
  ret i1 %7, !dbg !658
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_trywrlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_rdlock(ptr noundef %0) #0 !dbg !659 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !660, !DIExpression(), !661)
    #dbg_declare(ptr %3, !662, !DIExpression(), !663)
  %4 = load ptr, ptr %2, align 8, !dbg !664
  %5 = call i32 @pthread_rwlock_rdlock(ptr noundef %4) #7, !dbg !665
  store i32 %5, ptr %3, align 4, !dbg !663
  %6 = load i32, ptr %3, align 4, !dbg !666
  %7 = icmp eq i32 %6, 0, !dbg !666
  %8 = xor i1 %7, true, !dbg !666
  %9 = zext i1 %8 to i32, !dbg !666
  %10 = sext i32 %9 to i64, !dbg !666
  %11 = icmp ne i64 %10, 0, !dbg !666
  br i1 %11, label %12, label %14, !dbg !666

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_rdlock, ptr noundef @.str, i32 noundef 297, ptr noundef @.str.1) #8, !dbg !666
  unreachable, !dbg !666

13:                                               ; No predecessors!
  br label %15, !dbg !666

14:                                               ; preds = %1
  br label %15, !dbg !666

15:                                               ; preds = %14, %13
  ret void, !dbg !667
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_rdlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local zeroext i1 @rwlock_tryrdlock(ptr noundef %0) #0 !dbg !668 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !669, !DIExpression(), !670)
    #dbg_declare(ptr %3, !671, !DIExpression(), !672)
  %4 = load ptr, ptr %2, align 8, !dbg !673
  %5 = call i32 @pthread_rwlock_tryrdlock(ptr noundef %4) #7, !dbg !674
  store i32 %5, ptr %3, align 4, !dbg !672
  %6 = load i32, ptr %3, align 4, !dbg !675
  %7 = icmp eq i32 %6, 0, !dbg !676
  ret i1 %7, !dbg !677
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_tryrdlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_unlock(ptr noundef %0) #0 !dbg !678 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !679, !DIExpression(), !680)
    #dbg_declare(ptr %3, !681, !DIExpression(), !682)
  %4 = load ptr, ptr %2, align 8, !dbg !683
  %5 = call i32 @pthread_rwlock_unlock(ptr noundef %4) #7, !dbg !684
  store i32 %5, ptr %3, align 4, !dbg !682
  %6 = load i32, ptr %3, align 4, !dbg !685
  %7 = icmp eq i32 %6, 0, !dbg !685
  %8 = xor i1 %7, true, !dbg !685
  %9 = zext i1 %8 to i32, !dbg !685
  %10 = sext i32 %9 to i64, !dbg !685
  %11 = icmp ne i64 %10, 0, !dbg !685
  br i1 %11, label %12, label %14, !dbg !685

12:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.rwlock_unlock, ptr noundef @.str, i32 noundef 310, ptr noundef @.str.1) #8, !dbg !685
  unreachable, !dbg !685

13:                                               ; No predecessors!
  br label %15, !dbg !685

14:                                               ; preds = %1
  br label %15, !dbg !685

15:                                               ; preds = %14, %13
  ret void, !dbg !686
}

; Function Attrs: nounwind
declare i32 @pthread_rwlock_unlock(ptr noundef) #2

; Function Attrs: noinline nounwind uwtable
define dso_local void @rwlock_test() #0 !dbg !687 {
  %1 = alloca %union.pthread_rwlock_t, align 8
  %2 = alloca i32, align 4
  %3 = alloca i8, align 1
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  %6 = alloca i8, align 1
  %7 = alloca i32, align 4
  %8 = alloca i8, align 1
    #dbg_declare(ptr %1, !688, !DIExpression(), !689)
  call void @rwlock_init(ptr noundef %1, i32 noundef 0), !dbg !690
    #dbg_declare(ptr %2, !691, !DIExpression(), !693)
  store i32 4, ptr %2, align 4, !dbg !693
  call void @rwlock_wrlock(ptr noundef %1), !dbg !694
    #dbg_declare(ptr %3, !696, !DIExpression(), !697)
  %9 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !698
  %10 = zext i1 %9 to i8, !dbg !697
  store i8 %10, ptr %3, align 1, !dbg !697
  %11 = load i8, ptr %3, align 1, !dbg !699
  %12 = trunc i8 %11 to i1, !dbg !699
  %13 = xor i1 %12, true, !dbg !699
  %14 = xor i1 %13, true, !dbg !699
  %15 = zext i1 %14 to i32, !dbg !699
  %16 = sext i32 %15 to i64, !dbg !699
  %17 = icmp ne i64 %16, 0, !dbg !699
  br i1 %17, label %18, label %20, !dbg !699

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 322, ptr noundef @.str.2) #8, !dbg !699
  unreachable, !dbg !699

19:                                               ; No predecessors!
  br label %21, !dbg !699

20:                                               ; preds = %0
  br label %21, !dbg !699

21:                                               ; preds = %20, %19
  %22 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !700
  %23 = zext i1 %22 to i8, !dbg !701
  store i8 %23, ptr %3, align 1, !dbg !701
  %24 = load i8, ptr %3, align 1, !dbg !702
  %25 = trunc i8 %24 to i1, !dbg !702
  %26 = xor i1 %25, true, !dbg !702
  %27 = xor i1 %26, true, !dbg !702
  %28 = zext i1 %27 to i32, !dbg !702
  %29 = sext i32 %28 to i64, !dbg !702
  %30 = icmp ne i64 %29, 0, !dbg !702
  br i1 %30, label %31, label %33, !dbg !702

31:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 324, ptr noundef @.str.2) #8, !dbg !702
  unreachable, !dbg !702

32:                                               ; No predecessors!
  br label %34, !dbg !702

33:                                               ; preds = %21
  br label %34, !dbg !702

34:                                               ; preds = %33, %32
  call void @rwlock_unlock(ptr noundef %1), !dbg !703
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !704
    #dbg_declare(ptr %4, !706, !DIExpression(), !708)
  store i32 0, ptr %4, align 4, !dbg !708
  br label %35, !dbg !709

35:                                               ; preds = %51, %34
  %36 = load i32, ptr %4, align 4, !dbg !710
  %37 = icmp slt i32 %36, 4, !dbg !712
  br i1 %37, label %38, label %54, !dbg !713

38:                                               ; preds = %35
    #dbg_declare(ptr %5, !714, !DIExpression(), !716)
  %39 = call zeroext i1 @rwlock_tryrdlock(ptr noundef %1), !dbg !717
  %40 = zext i1 %39 to i8, !dbg !716
  store i8 %40, ptr %5, align 1, !dbg !716
  %41 = load i8, ptr %5, align 1, !dbg !718
  %42 = trunc i8 %41 to i1, !dbg !718
  %43 = xor i1 %42, true, !dbg !718
  %44 = zext i1 %43 to i32, !dbg !718
  %45 = sext i32 %44 to i64, !dbg !718
  %46 = icmp ne i64 %45, 0, !dbg !718
  br i1 %46, label %47, label %49, !dbg !718

47:                                               ; preds = %38
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 333, ptr noundef @.str.3) #8, !dbg !718
  unreachable, !dbg !718

48:                                               ; No predecessors!
  br label %50, !dbg !718

49:                                               ; preds = %38
  br label %50, !dbg !718

50:                                               ; preds = %49, %48
  br label %51, !dbg !719

51:                                               ; preds = %50
  %52 = load i32, ptr %4, align 4, !dbg !720
  %53 = add nsw i32 %52, 1, !dbg !720
  store i32 %53, ptr %4, align 4, !dbg !720
  br label %35, !dbg !721, !llvm.loop !722

54:                                               ; preds = %35
    #dbg_declare(ptr %6, !725, !DIExpression(), !727)
  %55 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !728
  %56 = zext i1 %55 to i8, !dbg !727
  store i8 %56, ptr %6, align 1, !dbg !727
  %57 = load i8, ptr %6, align 1, !dbg !729
  %58 = trunc i8 %57 to i1, !dbg !729
  %59 = xor i1 %58, true, !dbg !729
  %60 = xor i1 %59, true, !dbg !729
  %61 = zext i1 %60 to i32, !dbg !729
  %62 = sext i32 %61 to i64, !dbg !729
  %63 = icmp ne i64 %62, 0, !dbg !729
  br i1 %63, label %64, label %66, !dbg !729

64:                                               ; preds = %54
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 338, ptr noundef @.str.2) #8, !dbg !729
  unreachable, !dbg !729

65:                                               ; No predecessors!
  br label %67, !dbg !729

66:                                               ; preds = %54
  br label %67, !dbg !729

67:                                               ; preds = %66, %65
  call void @__VERIFIER_loop_bound(i32 noundef 5), !dbg !730
    #dbg_declare(ptr %7, !731, !DIExpression(), !733)
  store i32 0, ptr %7, align 4, !dbg !733
  br label %68, !dbg !734

68:                                               ; preds = %72, %67
  %69 = load i32, ptr %7, align 4, !dbg !735
  %70 = icmp slt i32 %69, 4, !dbg !737
  br i1 %70, label %71, label %75, !dbg !738

71:                                               ; preds = %68
  call void @rwlock_unlock(ptr noundef %1), !dbg !739
  br label %72, !dbg !741

72:                                               ; preds = %71
  %73 = load i32, ptr %7, align 4, !dbg !742
  %74 = add nsw i32 %73, 1, !dbg !742
  store i32 %74, ptr %7, align 4, !dbg !742
  br label %68, !dbg !743, !llvm.loop !744

75:                                               ; preds = %68
  call void @rwlock_wrlock(ptr noundef %1), !dbg !746
    #dbg_declare(ptr %8, !748, !DIExpression(), !749)
  %76 = call zeroext i1 @rwlock_trywrlock(ptr noundef %1), !dbg !750
  %77 = zext i1 %76 to i8, !dbg !749
  store i8 %77, ptr %8, align 1, !dbg !749
  %78 = load i8, ptr %8, align 1, !dbg !751
  %79 = trunc i8 %78 to i1, !dbg !751
  %80 = xor i1 %79, true, !dbg !751
  %81 = xor i1 %80, true, !dbg !751
  %82 = zext i1 %81 to i32, !dbg !751
  %83 = sext i32 %82 to i64, !dbg !751
  %84 = icmp ne i64 %83, 0, !dbg !751
  br i1 %84, label %85, label %87, !dbg !751

85:                                               ; preds = %75
  call void @__assert_rtn(ptr noundef @__func__.rwlock_test, ptr noundef @.str, i32 noundef 350, ptr noundef @.str.2) #8, !dbg !751
  unreachable, !dbg !751

86:                                               ; No predecessors!
  br label %88, !dbg !751

87:                                               ; preds = %75
  br label %88, !dbg !751

88:                                               ; preds = %87, %86
  call void @rwlock_unlock(ptr noundef %1), !dbg !752
  call void @rwlock_destroy(ptr noundef %1), !dbg !753
  ret void, !dbg !754
}

declare void @__VERIFIER_loop_bound(i32 noundef) #4

; Function Attrs: noinline nounwind uwtable
define dso_local void @key_destroy(ptr noundef %0) #0 !dbg !755 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !758, !DIExpression(), !759)
  %3 = call i64 @pthread_self() #9, !dbg !760
  store i64 %3, ptr @latest_thread, align 8, !dbg !761
  ret void, !dbg !762
}

; Function Attrs: nocallback nounwind willreturn memory(none)
declare i64 @pthread_self() #5

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @key_worker(ptr noundef %0) #0 !dbg !763 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !764, !DIExpression(), !765)
    #dbg_declare(ptr %3, !766, !DIExpression(), !767)
  store i32 1, ptr %3, align 4, !dbg !767
    #dbg_declare(ptr %4, !768, !DIExpression(), !769)
  %6 = load i32, ptr @local_data, align 4, !dbg !770
  %7 = call i32 @pthread_setspecific(i32 noundef %6, ptr noundef %3) #6, !dbg !771
  store i32 %7, ptr %4, align 4, !dbg !769
  %8 = load i32, ptr %4, align 4, !dbg !772
  %9 = icmp eq i32 %8, 0, !dbg !772
  %10 = xor i1 %9, true, !dbg !772
  %11 = zext i1 %10 to i32, !dbg !772
  %12 = sext i32 %11 to i64, !dbg !772
  %13 = icmp ne i64 %12, 0, !dbg !772
  br i1 %13, label %14, label %16, !dbg !772

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 372, ptr noundef @.str.1) #8, !dbg !772
  unreachable, !dbg !772

15:                                               ; No predecessors!
  br label %17, !dbg !772

16:                                               ; preds = %1
  br label %17, !dbg !772

17:                                               ; preds = %16, %15
    #dbg_declare(ptr %5, !773, !DIExpression(), !774)
  %18 = load i32, ptr @local_data, align 4, !dbg !775
  %19 = call ptr @pthread_getspecific(i32 noundef %18) #6, !dbg !776
  store ptr %19, ptr %5, align 8, !dbg !774
  %20 = load ptr, ptr %5, align 8, !dbg !777
  %21 = icmp eq ptr %20, %3, !dbg !777
  %22 = xor i1 %21, true, !dbg !777
  %23 = zext i1 %22 to i32, !dbg !777
  %24 = sext i32 %23 to i64, !dbg !777
  %25 = icmp ne i64 %24, 0, !dbg !777
  br i1 %25, label %26, label %28, !dbg !777

26:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.key_worker, ptr noundef @.str, i32 noundef 375, ptr noundef @.str.5) #8, !dbg !777
  unreachable, !dbg !777

27:                                               ; No predecessors!
  br label %29, !dbg !777

28:                                               ; preds = %17
  br label %29, !dbg !777

29:                                               ; preds = %28, %27
  %30 = load ptr, ptr %2, align 8, !dbg !778
  ret ptr %30, !dbg !779
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_setspecific(i32 noundef, ptr noundef) #1

; Function Attrs: nocallback nounwind
declare ptr @pthread_getspecific(i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @key_test() #0 !dbg !780 {
  %1 = alloca i32, align 4
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
    #dbg_declare(ptr %1, !781, !DIExpression(), !782)
  store i32 2, ptr %1, align 4, !dbg !782
    #dbg_declare(ptr %2, !783, !DIExpression(), !784)
  store ptr inttoptr (i64 41 to ptr), ptr %2, align 8, !dbg !784
    #dbg_declare(ptr %3, !785, !DIExpression(), !786)
  %7 = call i32 @pthread_key_create(ptr noundef @local_data, ptr noundef @key_destroy) #6, !dbg !787
    #dbg_declare(ptr %4, !788, !DIExpression(), !789)
  %8 = load ptr, ptr %2, align 8, !dbg !790
  %9 = call i64 @thread_create(ptr noundef @key_worker, ptr noundef %8), !dbg !791
  store i64 %9, ptr %4, align 8, !dbg !789
  %10 = load i32, ptr @local_data, align 4, !dbg !792
  %11 = call i32 @pthread_setspecific(i32 noundef %10, ptr noundef %1) #6, !dbg !793
  store i32 %11, ptr %3, align 4, !dbg !794
  %12 = load i32, ptr %3, align 4, !dbg !795
  %13 = icmp eq i32 %12, 0, !dbg !795
  %14 = xor i1 %13, true, !dbg !795
  %15 = zext i1 %14 to i32, !dbg !795
  %16 = sext i32 %15 to i64, !dbg !795
  %17 = icmp ne i64 %16, 0, !dbg !795
  br i1 %17, label %18, label %20, !dbg !795

18:                                               ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 391, ptr noundef @.str.1) #8, !dbg !795
  unreachable, !dbg !795

19:                                               ; No predecessors!
  br label %21, !dbg !795

20:                                               ; preds = %0
  br label %21, !dbg !795

21:                                               ; preds = %20, %19
    #dbg_declare(ptr %5, !796, !DIExpression(), !797)
  %22 = load i32, ptr @local_data, align 4, !dbg !798
  %23 = call ptr @pthread_getspecific(i32 noundef %22) #6, !dbg !799
  store ptr %23, ptr %5, align 8, !dbg !797
  %24 = load ptr, ptr %5, align 8, !dbg !800
  %25 = icmp eq ptr %24, %1, !dbg !800
  %26 = xor i1 %25, true, !dbg !800
  %27 = zext i1 %26 to i32, !dbg !800
  %28 = sext i32 %27 to i64, !dbg !800
  %29 = icmp ne i64 %28, 0, !dbg !800
  br i1 %29, label %30, label %32, !dbg !800

30:                                               ; preds = %21
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 394, ptr noundef @.str.5) #8, !dbg !800
  unreachable, !dbg !800

31:                                               ; No predecessors!
  br label %33, !dbg !800

32:                                               ; preds = %21
  br label %33, !dbg !800

33:                                               ; preds = %32, %31
  %34 = load i32, ptr @local_data, align 4, !dbg !801
  %35 = call i32 @pthread_setspecific(i32 noundef %34, ptr noundef null) #6, !dbg !802
  store i32 %35, ptr %3, align 4, !dbg !803
  %36 = load i32, ptr %3, align 4, !dbg !804
  %37 = icmp eq i32 %36, 0, !dbg !804
  %38 = xor i1 %37, true, !dbg !804
  %39 = zext i1 %38 to i32, !dbg !804
  %40 = sext i32 %39 to i64, !dbg !804
  %41 = icmp ne i64 %40, 0, !dbg !804
  br i1 %41, label %42, label %44, !dbg !804

42:                                               ; preds = %33
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 397, ptr noundef @.str.1) #8, !dbg !804
  unreachable, !dbg !804

43:                                               ; No predecessors!
  br label %45, !dbg !804

44:                                               ; preds = %33
  br label %45, !dbg !804

45:                                               ; preds = %44, %43
    #dbg_declare(ptr %6, !805, !DIExpression(), !806)
  %46 = load i64, ptr %4, align 8, !dbg !807
  %47 = call ptr @thread_join(i64 noundef %46), !dbg !808
  store ptr %47, ptr %6, align 8, !dbg !806
  %48 = load ptr, ptr %6, align 8, !dbg !809
  %49 = load ptr, ptr %2, align 8, !dbg !809
  %50 = icmp eq ptr %48, %49, !dbg !809
  %51 = xor i1 %50, true, !dbg !809
  %52 = zext i1 %51 to i32, !dbg !809
  %53 = sext i32 %52 to i64, !dbg !809
  %54 = icmp ne i64 %53, 0, !dbg !809
  br i1 %54, label %55, label %57, !dbg !809

55:                                               ; preds = %45
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 400, ptr noundef @.str.4) #8, !dbg !809
  unreachable, !dbg !809

56:                                               ; No predecessors!
  br label %58, !dbg !809

57:                                               ; preds = %45
  br label %58, !dbg !809

58:                                               ; preds = %57, %56
  %59 = load i32, ptr @local_data, align 4, !dbg !810
  %60 = call i32 @pthread_key_delete(i32 noundef %59) #6, !dbg !811
  store i32 %60, ptr %3, align 4, !dbg !812
  %61 = load i32, ptr %3, align 4, !dbg !813
  %62 = icmp eq i32 %61, 0, !dbg !813
  %63 = xor i1 %62, true, !dbg !813
  %64 = zext i1 %63 to i32, !dbg !813
  %65 = sext i32 %64 to i64, !dbg !813
  %66 = icmp ne i64 %65, 0, !dbg !813
  br i1 %66, label %67, label %69, !dbg !813

67:                                               ; preds = %58
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 403, ptr noundef @.str.1) #8, !dbg !813
  unreachable, !dbg !813

68:                                               ; No predecessors!
  br label %70, !dbg !813

69:                                               ; preds = %58
  br label %70, !dbg !813

70:                                               ; preds = %69, %68
  %71 = load i64, ptr @latest_thread, align 8, !dbg !814
  %72 = load i64, ptr %4, align 8, !dbg !814
  %73 = call i32 @pthread_equal(i64 noundef %71, i64 noundef %72) #9, !dbg !814
  %74 = icmp ne i32 %73, 0, !dbg !814
  %75 = xor i1 %74, true, !dbg !814
  %76 = zext i1 %75 to i32, !dbg !814
  %77 = sext i32 %76 to i64, !dbg !814
  %78 = icmp ne i64 %77, 0, !dbg !814
  br i1 %78, label %79, label %81, !dbg !814

79:                                               ; preds = %70
  call void @__assert_rtn(ptr noundef @__func__.key_test, ptr noundef @.str, i32 noundef 405, ptr noundef @.str.6) #8, !dbg !814
  unreachable, !dbg !814

80:                                               ; No predecessors!
  br label %82, !dbg !814

81:                                               ; preds = %70
  br label %82, !dbg !814

82:                                               ; preds = %81, %80
  ret void, !dbg !815
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_key_create(ptr noundef, ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_key_delete(i32 noundef) #1

; Function Attrs: nocallback nounwind willreturn memory(none)
declare i32 @pthread_equal(i64 noundef, i64 noundef) #5

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_worker0(ptr noundef %0) #0 !dbg !816 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !817, !DIExpression(), !818)
  ret ptr null, !dbg !819
}

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_detach(ptr noundef %0) #0 !dbg !820 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !821, !DIExpression(), !822)
    #dbg_declare(ptr %3, !823, !DIExpression(), !824)
    #dbg_declare(ptr %4, !825, !DIExpression(), !826)
  %5 = call i64 @thread_create(ptr noundef @detach_test_worker0, ptr noundef null), !dbg !827
  store i64 %5, ptr %4, align 8, !dbg !826
  %6 = load i64, ptr %4, align 8, !dbg !828
  %7 = call i32 @pthread_detach(i64 noundef %6) #6, !dbg !829
  store i32 %7, ptr %3, align 4, !dbg !830
  %8 = load i32, ptr %3, align 4, !dbg !831
  %9 = icmp eq i32 %8, 0, !dbg !831
  %10 = xor i1 %9, true, !dbg !831
  %11 = zext i1 %10 to i32, !dbg !831
  %12 = sext i32 %11 to i64, !dbg !831
  %13 = icmp ne i64 %12, 0, !dbg !831
  br i1 %13, label %14, label %16, !dbg !831

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.detach_test_detach, ptr noundef @.str, i32 noundef 420, ptr noundef @.str.1) #8, !dbg !831
  unreachable, !dbg !831

15:                                               ; No predecessors!
  br label %17, !dbg !831

16:                                               ; preds = %1
  br label %17, !dbg !831

17:                                               ; preds = %16, %15
  %18 = load i64, ptr %4, align 8, !dbg !832
  %19 = call i32 @pthread_join(i64 noundef %18, ptr noundef null), !dbg !833
  store i32 %19, ptr %3, align 4, !dbg !834
  %20 = load i32, ptr %3, align 4, !dbg !835
  %21 = icmp ne i32 %20, 0, !dbg !835
  %22 = xor i1 %21, true, !dbg !835
  %23 = zext i1 %22 to i32, !dbg !835
  %24 = sext i32 %23 to i64, !dbg !835
  %25 = icmp ne i64 %24, 0, !dbg !835
  br i1 %25, label %26, label %28, !dbg !835

26:                                               ; preds = %17
  call void @__assert_rtn(ptr noundef @__func__.detach_test_detach, ptr noundef @.str, i32 noundef 423, ptr noundef @.str.7) #8, !dbg !835
  unreachable, !dbg !835

27:                                               ; No predecessors!
  br label %29, !dbg !835

28:                                               ; preds = %17
  br label %29, !dbg !835

29:                                               ; preds = %28, %27
  ret ptr null, !dbg !836
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_detach(i64 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local ptr @detach_test_attr(ptr noundef %0) #0 !dbg !837 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  %6 = alloca %union.pthread_attr_t, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !838, !DIExpression(), !839)
    #dbg_declare(ptr %3, !840, !DIExpression(), !841)
    #dbg_declare(ptr %4, !842, !DIExpression(), !843)
    #dbg_declare(ptr %5, !844, !DIExpression(), !845)
    #dbg_declare(ptr %6, !846, !DIExpression(), !847)
  %7 = call i32 @pthread_attr_init(ptr noundef %6) #6, !dbg !848
  store i32 %7, ptr %3, align 4, !dbg !849
  %8 = load i32, ptr %3, align 4, !dbg !850
  %9 = icmp eq i32 %8, 0, !dbg !850
  %10 = xor i1 %9, true, !dbg !850
  %11 = zext i1 %10 to i32, !dbg !850
  %12 = sext i32 %11 to i64, !dbg !850
  %13 = icmp ne i64 %12, 0, !dbg !850
  br i1 %13, label %14, label %16, !dbg !850

14:                                               ; preds = %1
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 434, ptr noundef @.str.1) #8, !dbg !850
  unreachable, !dbg !850

15:                                               ; No predecessors!
  br label %17, !dbg !850

16:                                               ; preds = %1
  br label %17, !dbg !850

17:                                               ; preds = %16, %15
  %18 = call i32 @pthread_attr_getdetachstate(ptr noundef %6, ptr noundef %4) #6, !dbg !851
  store i32 %18, ptr %3, align 4, !dbg !852
  %19 = load i32, ptr %3, align 4, !dbg !853
  %20 = icmp eq i32 %19, 0, !dbg !853
  br i1 %20, label %21, label %24, !dbg !853

21:                                               ; preds = %17
  %22 = load i32, ptr %4, align 4, !dbg !853
  %23 = icmp eq i32 %22, 0, !dbg !853
  br label %24

24:                                               ; preds = %21, %17
  %25 = phi i1 [ false, %17 ], [ %23, %21 ], !dbg !854
  %26 = xor i1 %25, true, !dbg !853
  %27 = zext i1 %26 to i32, !dbg !853
  %28 = sext i32 %27 to i64, !dbg !853
  %29 = icmp ne i64 %28, 0, !dbg !853
  br i1 %29, label %30, label %32, !dbg !853

30:                                               ; preds = %24
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 436, ptr noundef @.str.8) #8, !dbg !853
  unreachable, !dbg !853

31:                                               ; No predecessors!
  br label %33, !dbg !853

32:                                               ; preds = %24
  br label %33, !dbg !853

33:                                               ; preds = %32, %31
  %34 = call i32 @pthread_attr_setdetachstate(ptr noundef %6, i32 noundef 1) #6, !dbg !855
  store i32 %34, ptr %3, align 4, !dbg !856
  %35 = load i32, ptr %3, align 4, !dbg !857
  %36 = icmp eq i32 %35, 0, !dbg !857
  %37 = xor i1 %36, true, !dbg !857
  %38 = zext i1 %37 to i32, !dbg !857
  %39 = sext i32 %38 to i64, !dbg !857
  %40 = icmp ne i64 %39, 0, !dbg !857
  br i1 %40, label %41, label %43, !dbg !857

41:                                               ; preds = %33
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 438, ptr noundef @.str.1) #8, !dbg !857
  unreachable, !dbg !857

42:                                               ; No predecessors!
  br label %44, !dbg !857

43:                                               ; preds = %33
  br label %44, !dbg !857

44:                                               ; preds = %43, %42
  %45 = call i32 @pthread_attr_getdetachstate(ptr noundef %6, ptr noundef %4) #6, !dbg !858
  store i32 %45, ptr %3, align 4, !dbg !859
  %46 = load i32, ptr %3, align 4, !dbg !860
  %47 = icmp eq i32 %46, 0, !dbg !860
  br i1 %47, label %48, label %51, !dbg !860

48:                                               ; preds = %44
  %49 = load i32, ptr %4, align 4, !dbg !860
  %50 = icmp eq i32 %49, 1, !dbg !860
  br label %51

51:                                               ; preds = %48, %44
  %52 = phi i1 [ false, %44 ], [ %50, %48 ], !dbg !854
  %53 = xor i1 %52, true, !dbg !860
  %54 = zext i1 %53 to i32, !dbg !860
  %55 = sext i32 %54 to i64, !dbg !860
  %56 = icmp ne i64 %55, 0, !dbg !860
  br i1 %56, label %57, label %59, !dbg !860

57:                                               ; preds = %51
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 440, ptr noundef @.str.9) #8, !dbg !860
  unreachable, !dbg !860

58:                                               ; No predecessors!
  br label %60, !dbg !860

59:                                               ; preds = %51
  br label %60, !dbg !860

60:                                               ; preds = %59, %58
  %61 = call i32 @pthread_create(ptr noundef %5, ptr noundef %6, ptr noundef @detach_test_worker0, ptr noundef null) #7, !dbg !861
  store i32 %61, ptr %3, align 4, !dbg !862
  %62 = load i32, ptr %3, align 4, !dbg !863
  %63 = icmp eq i32 %62, 0, !dbg !863
  %64 = xor i1 %63, true, !dbg !863
  %65 = zext i1 %64 to i32, !dbg !863
  %66 = sext i32 %65 to i64, !dbg !863
  %67 = icmp ne i64 %66, 0, !dbg !863
  br i1 %67, label %68, label %70, !dbg !863

68:                                               ; preds = %60
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 442, ptr noundef @.str.1) #8, !dbg !863
  unreachable, !dbg !863

69:                                               ; No predecessors!
  br label %71, !dbg !863

70:                                               ; preds = %60
  br label %71, !dbg !863

71:                                               ; preds = %70, %69
  %72 = call i32 @pthread_attr_destroy(ptr noundef %6) #6, !dbg !864
  %73 = load i64, ptr %5, align 8, !dbg !865
  %74 = call i32 @pthread_join(i64 noundef %73, ptr noundef null), !dbg !866
  store i32 %74, ptr %3, align 4, !dbg !867
  %75 = load i32, ptr %3, align 4, !dbg !868
  %76 = icmp ne i32 %75, 0, !dbg !868
  %77 = xor i1 %76, true, !dbg !868
  %78 = zext i1 %77 to i32, !dbg !868
  %79 = sext i32 %78 to i64, !dbg !868
  %80 = icmp ne i64 %79, 0, !dbg !868
  br i1 %80, label %81, label %83, !dbg !868

81:                                               ; preds = %71
  call void @__assert_rtn(ptr noundef @__func__.detach_test_attr, ptr noundef @.str, i32 noundef 446, ptr noundef @.str.7) #8, !dbg !868
  unreachable, !dbg !868

82:                                               ; No predecessors!
  br label %84, !dbg !868

83:                                               ; preds = %71
  br label %84, !dbg !868

84:                                               ; preds = %83, %82
  ret ptr null, !dbg !869
}

; Function Attrs: nocallback nounwind
declare i32 @pthread_attr_getdetachstate(ptr noundef, ptr noundef) #1

; Function Attrs: nocallback nounwind
declare i32 @pthread_attr_setdetachstate(ptr noundef, i32 noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @detach_test() #0 !dbg !870 {
  %1 = call i64 @thread_create(ptr noundef @detach_test_detach, ptr noundef null), !dbg !871
  %2 = call i64 @thread_create(ptr noundef @detach_test_attr, ptr noundef null), !dbg !872
  ret void, !dbg !873
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !874 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %2 = call i32 @__VERIFIER_nondet_int(), !dbg !877
  switch i32 %2, label %8 [
    i32 1, label %3
    i32 2, label %4
    i32 3, label %5
    i32 4, label %6
    i32 5, label %7
  ], !dbg !878

3:                                                ; preds = %0
  call void @mutex_test(), !dbg !879
  br label %8, !dbg !881

4:                                                ; preds = %0
  call void @cond_test(), !dbg !882
  br label %8, !dbg !883

5:                                                ; preds = %0
  call void @rwlock_test(), !dbg !884
  br label %8, !dbg !885

6:                                                ; preds = %0
  call void @key_test(), !dbg !886
  br label %8, !dbg !887

7:                                                ; preds = %0
  call void @detach_test(), !dbg !888
  br label %8, !dbg !889

8:                                                ; preds = %0, %7, %6, %5, %4, %3
  %9 = load i32, ptr %1, align 4, !dbg !890
  ret i32 %9, !dbg !890
}

declare i32 @__VERIFIER_nondet_int() #4

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nocallback nounwind willreturn memory(none) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback nounwind }
attributes #7 = { nounwind }
attributes #8 = { cold noreturn }
attributes #9 = { nocallback nounwind willreturn memory(none) }

!llvm.dbg.cu = !{!61}
!llvm.module.flags = !{!221, !222, !223, !224, !225, !226, !227}
!llvm.ident = !{!228}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 18, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "benchmarks/miscellaneous/pthread.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "3bf13f7b85882bbb344b011a2445e2ed")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 112, elements: !6)
!4 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !5)
!5 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!6 = !{!7}
!7 = !DISubrange(count: 14)
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(scope: null, file: !2, line: 18, type: !10, isLocal: true, isDefinition: true)
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 80, elements: !11)
!11 = !{!12}
!12 = !DISubrange(count: 10)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(scope: null, file: !2, line: 18, type: !15, isLocal: true, isDefinition: true)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 96, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 12)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !2, line: 27, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 96, elements: !16)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(scope: null, file: !2, line: 47, type: !23, isLocal: true, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 88, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 11)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !2, line: 73, type: !3, isLocal: true, isDefinition: true)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !2, line: 79, type: !23, isLocal: true, isDefinition: true)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(scope: null, file: !2, line: 92, type: !32, isLocal: true, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 104, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 13)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(scope: null, file: !2, line: 106, type: !23, isLocal: true, isDefinition: true)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(scope: null, file: !2, line: 106, type: !39, isLocal: true, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 72, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 9)
!42 = !DIGlobalVariableExpression(var: !43, expr: !DIExpression())
!43 = distinct !DIGlobalVariable(scope: null, file: !2, line: 115, type: !44, isLocal: true, isDefinition: true)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 64, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 8)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(scope: null, file: !2, line: 147, type: !49, isLocal: true, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 80, elements: !11)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(scope: null, file: !2, line: 159, type: !32, isLocal: true, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(scope: null, file: !2, line: 165, type: !20, isLocal: true, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(scope: null, file: !2, line: 171, type: !56, isLocal: true, isDefinition: true)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 120, elements: !57)
!57 = !{!58}
!58 = !DISubrange(count: 15)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "phase", scope: !61, file: !2, line: 193, type: !154, isLocal: false, isDefinition: true)
!61 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !62, retainedTypes: !88, globals: !91, splitDebugInlining: false, nameTableKind: None)
!62 = !{!63, !75, !80, !84}
!63 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !64, line: 672, baseType: !65, size: 32, elements: !66)
!64 = !DIFile(filename: "./include/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "cd7d21805be506b5b7d56065fce8a5bf")
!65 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!66 = !{!67, !68, !69, !70, !71, !72, !73, !74}
!67 = !DIEnumerator(name: "PTHREAD_MUTEX_TIMED_NP", value: 0)
!68 = !DIEnumerator(name: "PTHREAD_MUTEX_RECURSIVE_NP", value: 1)
!69 = !DIEnumerator(name: "PTHREAD_MUTEX_ERRORCHECK_NP", value: 2)
!70 = !DIEnumerator(name: "PTHREAD_MUTEX_ADAPTIVE_NP", value: 3)
!71 = !DIEnumerator(name: "PTHREAD_MUTEX_NORMAL", value: 0)
!72 = !DIEnumerator(name: "PTHREAD_MUTEX_RECURSIVE", value: 1)
!73 = !DIEnumerator(name: "PTHREAD_MUTEX_ERRORCHECK", value: 2)
!74 = !DIEnumerator(name: "PTHREAD_MUTEX_DEFAULT", value: 0)
!75 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !64, line: 691, baseType: !65, size: 32, elements: !76)
!76 = !{!77, !78, !79}
!77 = !DIEnumerator(name: "PTHREAD_PRIO_NONE", value: 0)
!78 = !DIEnumerator(name: "PTHREAD_PRIO_INHERIT", value: 1)
!79 = !DIEnumerator(name: "PTHREAD_PRIO_PROTECT", value: 2)
!80 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !64, line: 714, baseType: !65, size: 32, elements: !81)
!81 = !{!82, !83}
!82 = !DIEnumerator(name: "PTHREAD_PROCESS_PRIVATE", value: 0)
!83 = !DIEnumerator(name: "PTHREAD_PROCESS_SHARED", value: 1)
!84 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !64, line: 667, baseType: !65, size: 32, elements: !85)
!85 = !{!86, !87}
!86 = !DIEnumerator(name: "PTHREAD_CREATE_JOINABLE", value: 0)
!87 = !DIEnumerator(name: "PTHREAD_CREATE_DETACHED", value: 1)
!88 = !{!89, !90}
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!91 = !{!0, !8, !13, !18, !21, !26, !28, !30, !35, !37, !42, !47, !50, !52, !54, !59, !92, !94, !99, !101, !103, !105, !107, !109, !111, !113, !118, !121, !126, !131, !133, !138, !143, !145, !180, !214, !218}
!92 = !DIGlobalVariableExpression(var: !93, expr: !DIExpression())
!93 = distinct !DIGlobalVariable(scope: null, file: !2, line: 245, type: !49, isLocal: true, isDefinition: true)
!94 = !DIGlobalVariableExpression(var: !95, expr: !DIExpression())
!95 = distinct !DIGlobalVariable(scope: null, file: !2, line: 245, type: !96, isLocal: true, isDefinition: true)
!96 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 144, elements: !97)
!97 = !{!98}
!98 = !DISubrange(count: 18)
!99 = !DIGlobalVariableExpression(var: !100, expr: !DIExpression())
!100 = distinct !DIGlobalVariable(scope: null, file: !2, line: 262, type: !20, isLocal: true, isDefinition: true)
!101 = !DIGlobalVariableExpression(var: !102, expr: !DIExpression())
!102 = distinct !DIGlobalVariable(scope: null, file: !2, line: 278, type: !56, isLocal: true, isDefinition: true)
!103 = !DIGlobalVariableExpression(var: !104, expr: !DIExpression())
!104 = distinct !DIGlobalVariable(scope: null, file: !2, line: 284, type: !3, isLocal: true, isDefinition: true)
!105 = !DIGlobalVariableExpression(var: !106, expr: !DIExpression())
!106 = distinct !DIGlobalVariable(scope: null, file: !2, line: 297, type: !3, isLocal: true, isDefinition: true)
!107 = !DIGlobalVariableExpression(var: !108, expr: !DIExpression())
!108 = distinct !DIGlobalVariable(scope: null, file: !2, line: 310, type: !3, isLocal: true, isDefinition: true)
!109 = !DIGlobalVariableExpression(var: !110, expr: !DIExpression())
!110 = distinct !DIGlobalVariable(scope: null, file: !2, line: 322, type: !20, isLocal: true, isDefinition: true)
!111 = !DIGlobalVariableExpression(var: !112, expr: !DIExpression())
!112 = distinct !DIGlobalVariable(scope: null, file: !2, line: 372, type: !23, isLocal: true, isDefinition: true)
!113 = !DIGlobalVariableExpression(var: !114, expr: !DIExpression())
!114 = distinct !DIGlobalVariable(scope: null, file: !2, line: 375, type: !115, isLocal: true, isDefinition: true)
!115 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 224, elements: !116)
!116 = !{!117}
!117 = !DISubrange(count: 28)
!118 = !DIGlobalVariableExpression(var: !119, expr: !DIExpression())
!119 = distinct !DIGlobalVariable(scope: null, file: !2, line: 391, type: !120, isLocal: true, isDefinition: true)
!120 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !40)
!121 = !DIGlobalVariableExpression(var: !122, expr: !DIExpression())
!122 = distinct !DIGlobalVariable(scope: null, file: !2, line: 405, type: !123, isLocal: true, isDefinition: true)
!123 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 296, elements: !124)
!124 = !{!125}
!125 = !DISubrange(count: 37)
!126 = !DIGlobalVariableExpression(var: !127, expr: !DIExpression())
!127 = distinct !DIGlobalVariable(scope: null, file: !2, line: 420, type: !128, isLocal: true, isDefinition: true)
!128 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 152, elements: !129)
!129 = !{!130}
!130 = !DISubrange(count: 19)
!131 = !DIGlobalVariableExpression(var: !132, expr: !DIExpression())
!132 = distinct !DIGlobalVariable(scope: null, file: !2, line: 423, type: !15, isLocal: true, isDefinition: true)
!133 = !DIGlobalVariableExpression(var: !134, expr: !DIExpression())
!134 = distinct !DIGlobalVariable(scope: null, file: !2, line: 434, type: !135, isLocal: true, isDefinition: true)
!135 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 136, elements: !136)
!136 = !{!137}
!137 = !DISubrange(count: 17)
!138 = !DIGlobalVariableExpression(var: !139, expr: !DIExpression())
!139 = distinct !DIGlobalVariable(scope: null, file: !2, line: 436, type: !140, isLocal: true, isDefinition: true)
!140 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 432, elements: !141)
!141 = !{!142}
!142 = !DISubrange(count: 54)
!143 = !DIGlobalVariableExpression(var: !144, expr: !DIExpression())
!144 = distinct !DIGlobalVariable(scope: null, file: !2, line: 440, type: !140, isLocal: true, isDefinition: true)
!145 = !DIGlobalVariableExpression(var: !146, expr: !DIExpression())
!146 = distinct !DIGlobalVariable(name: "cond_mutex", scope: !61, file: !2, line: 191, type: !147, isLocal: false, isDefinition: true)
!147 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutex_t", file: !64, line: 329, baseType: !148)
!148 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !64, line: 324, size: 256, elements: !149)
!149 = !{!150, !174, !178}
!150 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !148, file: !64, line: 326, baseType: !151, size: 256)
!151 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_mutex_s", file: !64, line: 258, size: 256, elements: !152)
!152 = !{!153, !155, !156, !157, !158, !159}
!153 = !DIDerivedType(tag: DW_TAG_member, name: "__lock", scope: !151, file: !64, line: 260, baseType: !154, size: 32)
!154 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!155 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !151, file: !64, line: 261, baseType: !65, size: 32, offset: 32)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "__owner", scope: !151, file: !64, line: 262, baseType: !154, size: 32, offset: 64)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "__kind", scope: !151, file: !64, line: 263, baseType: !154, size: 32, offset: 96)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "__nusers", scope: !151, file: !64, line: 264, baseType: !65, size: 32, offset: 128)
!159 = !DIDerivedType(tag: DW_TAG_member, scope: !151, file: !64, line: 265, baseType: !160, size: 64, offset: 192)
!160 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !151, file: !64, line: 265, size: 64, elements: !161)
!161 = !{!162, !168}
!162 = !DIDerivedType(tag: DW_TAG_member, name: "__elision_data", scope: !160, file: !64, line: 271, baseType: !163, size: 32)
!163 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !160, file: !64, line: 267, size: 32, elements: !164)
!164 = !{!165, !167}
!165 = !DIDerivedType(tag: DW_TAG_member, name: "__espins", scope: !163, file: !64, line: 269, baseType: !166, size: 16)
!166 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "__eelision", scope: !163, file: !64, line: 270, baseType: !166, size: 16, offset: 16)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "__list", scope: !160, file: !64, line: 272, baseType: !169, size: 64)
!169 = !DIDerivedType(tag: DW_TAG_typedef, name: "__pthread_slist_t", file: !64, line: 257, baseType: !170)
!170 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_internal_slist", file: !64, line: 254, size: 64, elements: !171)
!171 = !{!172}
!172 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !170, file: !64, line: 256, baseType: !173, size: 64)
!173 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !170, size: 64)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !148, file: !64, line: 327, baseType: !175, size: 192)
!175 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 192, elements: !176)
!176 = !{!177}
!177 = !DISubrange(count: 24)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !148, file: !64, line: 328, baseType: !179, size: 64)
!179 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!180 = !DIGlobalVariableExpression(var: !181, expr: !DIExpression())
!181 = distinct !DIGlobalVariable(name: "cond", scope: !61, file: !2, line: 192, type: !182, isLocal: false, isDefinition: true)
!182 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_cond_t", file: !64, line: 335, baseType: !183)
!183 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !64, line: 330, size: 384, elements: !184)
!184 = !{!185, !208, !212}
!185 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !183, file: !64, line: 332, baseType: !186, size: 384)
!186 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_cond_s", file: !64, line: 289, size: 384, elements: !187)
!187 = !{!188, !199, !200, !204, !205, !206, !207}
!188 = !DIDerivedType(tag: DW_TAG_member, name: "__wseq", scope: !186, file: !64, line: 291, baseType: !189, size: 64)
!189 = !DIDerivedType(tag: DW_TAG_typedef, name: "__atomic_wide_counter", file: !64, line: 248, baseType: !190)
!190 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !64, line: 240, size: 64, elements: !191)
!191 = !{!192, !194}
!192 = !DIDerivedType(tag: DW_TAG_member, name: "__value64", scope: !190, file: !64, line: 242, baseType: !193, size: 64)
!193 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "__value32", scope: !190, file: !64, line: 247, baseType: !195, size: 64)
!195 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !190, file: !64, line: 243, size: 64, elements: !196)
!196 = !{!197, !198}
!197 = !DIDerivedType(tag: DW_TAG_member, name: "__low", scope: !195, file: !64, line: 245, baseType: !65, size: 32)
!198 = !DIDerivedType(tag: DW_TAG_member, name: "__high", scope: !195, file: !64, line: 246, baseType: !65, size: 32, offset: 32)
!199 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_start", scope: !186, file: !64, line: 292, baseType: !189, size: 64, offset: 64)
!200 = !DIDerivedType(tag: DW_TAG_member, name: "__g_refs", scope: !186, file: !64, line: 293, baseType: !201, size: 64, offset: 128)
!201 = !DICompositeType(tag: DW_TAG_array_type, baseType: !65, size: 64, elements: !202)
!202 = !{!203}
!203 = !DISubrange(count: 2)
!204 = !DIDerivedType(tag: DW_TAG_member, name: "__g_size", scope: !186, file: !64, line: 294, baseType: !201, size: 64, offset: 192)
!205 = !DIDerivedType(tag: DW_TAG_member, name: "__g1_orig_size", scope: !186, file: !64, line: 295, baseType: !65, size: 32, offset: 256)
!206 = !DIDerivedType(tag: DW_TAG_member, name: "__wrefs", scope: !186, file: !64, line: 296, baseType: !65, size: 32, offset: 288)
!207 = !DIDerivedType(tag: DW_TAG_member, name: "__g_signals", scope: !186, file: !64, line: 297, baseType: !201, size: 64, offset: 320)
!208 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !183, file: !64, line: 333, baseType: !209, size: 384)
!209 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 384, elements: !210)
!210 = !{!211}
!211 = !DISubrange(count: 48)
!212 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !183, file: !64, line: 334, baseType: !213, size: 64)
!213 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!214 = !DIGlobalVariableExpression(var: !215, expr: !DIExpression())
!215 = distinct !DIGlobalVariable(name: "latest_thread", scope: !61, file: !2, line: 359, type: !216, isLocal: false, isDefinition: true)
!216 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !64, line: 305, baseType: !217)
!217 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!218 = !DIGlobalVariableExpression(var: !219, expr: !DIExpression())
!219 = distinct !DIGlobalVariable(name: "local_data", scope: !61, file: !2, line: 360, type: !220, isLocal: false, isDefinition: true)
!220 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_key_t", file: !64, line: 316, baseType: !65)
!221 = !{i32 7, !"Dwarf Version", i32 5}
!222 = !{i32 2, !"Debug Info Version", i32 3}
!223 = !{i32 1, !"wchar_size", i32 4}
!224 = !{i32 8, !"PIC Level", i32 2}
!225 = !{i32 7, !"PIE Level", i32 2}
!226 = !{i32 7, !"uwtable", i32 2}
!227 = !{i32 7, !"frame-pointer", i32 2}
!228 = !{!"Homebrew clang version 19.1.7"}
!229 = distinct !DISubprogram(name: "thread_create", scope: !2, file: !2, line: 12, type: !230, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!230 = !DISubroutineType(types: !231)
!231 = !{!216, !232, !90}
!232 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !233, size: 64)
!233 = !DISubroutineType(types: !234)
!234 = !{!90, !90}
!235 = !{}
!236 = !DILocalVariable(name: "runner", arg: 1, scope: !229, file: !2, line: 12, type: !232)
!237 = !DILocation(line: 12, column: 32, scope: !229)
!238 = !DILocalVariable(name: "data", arg: 2, scope: !229, file: !2, line: 12, type: !90)
!239 = !DILocation(line: 12, column: 54, scope: !229)
!240 = !DILocalVariable(name: "id", scope: !229, file: !2, line: 14, type: !216)
!241 = !DILocation(line: 14, column: 15, scope: !229)
!242 = !DILocalVariable(name: "attr", scope: !229, file: !2, line: 15, type: !243)
!243 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_attr_t", file: !64, line: 323, baseType: !244)
!244 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "pthread_attr_t", file: !64, line: 318, size: 320, elements: !245)
!245 = !{!246, !250}
!246 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !244, file: !64, line: 320, baseType: !247, size: 288)
!247 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 288, elements: !248)
!248 = !{!249}
!249 = !DISubrange(count: 36)
!250 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !244, file: !64, line: 321, baseType: !179, size: 64)
!251 = !DILocation(line: 15, column: 20, scope: !229)
!252 = !DILocation(line: 16, column: 5, scope: !229)
!253 = !DILocalVariable(name: "status", scope: !229, file: !2, line: 17, type: !154)
!254 = !DILocation(line: 17, column: 9, scope: !229)
!255 = !DILocation(line: 17, column: 45, scope: !229)
!256 = !DILocation(line: 17, column: 53, scope: !229)
!257 = !DILocation(line: 17, column: 18, scope: !229)
!258 = !DILocation(line: 18, column: 5, scope: !229)
!259 = !DILocation(line: 19, column: 5, scope: !229)
!260 = !DILocation(line: 20, column: 12, scope: !229)
!261 = !DILocation(line: 20, column: 5, scope: !229)
!262 = distinct !DISubprogram(name: "thread_join", scope: !2, file: !2, line: 23, type: !263, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!263 = !DISubroutineType(types: !264)
!264 = !{!90, !216}
!265 = !DILocalVariable(name: "id", arg: 1, scope: !262, file: !2, line: 23, type: !216)
!266 = !DILocation(line: 23, column: 29, scope: !262)
!267 = !DILocalVariable(name: "result", scope: !262, file: !2, line: 25, type: !90)
!268 = !DILocation(line: 25, column: 11, scope: !262)
!269 = !DILocalVariable(name: "status", scope: !262, file: !2, line: 26, type: !154)
!270 = !DILocation(line: 26, column: 9, scope: !262)
!271 = !DILocation(line: 26, column: 31, scope: !262)
!272 = !DILocation(line: 26, column: 18, scope: !262)
!273 = !DILocation(line: 27, column: 5, scope: !262)
!274 = !DILocation(line: 28, column: 12, scope: !262)
!275 = !DILocation(line: 28, column: 5, scope: !262)
!276 = distinct !DISubprogram(name: "mutex_init", scope: !2, file: !2, line: 41, type: !277, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!277 = !DISubroutineType(types: !278)
!278 = !{null, !279, !154, !154, !154}
!279 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !147, size: 64)
!280 = !DILocalVariable(name: "lock", arg: 1, scope: !276, file: !2, line: 41, type: !279)
!281 = !DILocation(line: 41, column: 34, scope: !276)
!282 = !DILocalVariable(name: "type", arg: 2, scope: !276, file: !2, line: 41, type: !154)
!283 = !DILocation(line: 41, column: 44, scope: !276)
!284 = !DILocalVariable(name: "protocol", arg: 3, scope: !276, file: !2, line: 41, type: !154)
!285 = !DILocation(line: 41, column: 54, scope: !276)
!286 = !DILocalVariable(name: "prioceiling", arg: 4, scope: !276, file: !2, line: 41, type: !154)
!287 = !DILocation(line: 41, column: 68, scope: !276)
!288 = !DILocalVariable(name: "status", scope: !276, file: !2, line: 43, type: !154)
!289 = !DILocation(line: 43, column: 9, scope: !276)
!290 = !DILocalVariable(name: "value", scope: !276, file: !2, line: 44, type: !154)
!291 = !DILocation(line: 44, column: 9, scope: !276)
!292 = !DILocalVariable(name: "attributes", scope: !276, file: !2, line: 45, type: !293)
!293 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_mutexattr_t", file: !64, line: 310, baseType: !294)
!294 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !64, line: 306, size: 32, elements: !295)
!295 = !{!296, !300}
!296 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !294, file: !64, line: 308, baseType: !297, size: 32)
!297 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 32, elements: !298)
!298 = !{!299}
!299 = !DISubrange(count: 4)
!300 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !294, file: !64, line: 309, baseType: !154, size: 32)
!301 = !DILocation(line: 45, column: 25, scope: !276)
!302 = !DILocation(line: 46, column: 14, scope: !276)
!303 = !DILocation(line: 46, column: 12, scope: !276)
!304 = !DILocation(line: 47, column: 5, scope: !276)
!305 = !DILocation(line: 49, column: 53, scope: !276)
!306 = !DILocation(line: 49, column: 14, scope: !276)
!307 = !DILocation(line: 49, column: 12, scope: !276)
!308 = !DILocation(line: 50, column: 5, scope: !276)
!309 = !DILocation(line: 51, column: 14, scope: !276)
!310 = !DILocation(line: 51, column: 12, scope: !276)
!311 = !DILocation(line: 52, column: 5, scope: !276)
!312 = !DILocation(line: 54, column: 57, scope: !276)
!313 = !DILocation(line: 54, column: 14, scope: !276)
!314 = !DILocation(line: 54, column: 12, scope: !276)
!315 = !DILocation(line: 55, column: 5, scope: !276)
!316 = !DILocation(line: 56, column: 14, scope: !276)
!317 = !DILocation(line: 56, column: 12, scope: !276)
!318 = !DILocation(line: 57, column: 5, scope: !276)
!319 = !DILocation(line: 59, column: 60, scope: !276)
!320 = !DILocation(line: 59, column: 14, scope: !276)
!321 = !DILocation(line: 59, column: 12, scope: !276)
!322 = !DILocation(line: 60, column: 5, scope: !276)
!323 = !DILocation(line: 61, column: 14, scope: !276)
!324 = !DILocation(line: 61, column: 12, scope: !276)
!325 = !DILocation(line: 62, column: 5, scope: !276)
!326 = !DILocation(line: 64, column: 33, scope: !276)
!327 = !DILocation(line: 64, column: 14, scope: !276)
!328 = !DILocation(line: 64, column: 12, scope: !276)
!329 = !DILocation(line: 65, column: 5, scope: !276)
!330 = !DILocation(line: 66, column: 14, scope: !276)
!331 = !DILocation(line: 66, column: 12, scope: !276)
!332 = !DILocation(line: 67, column: 5, scope: !276)
!333 = !DILocation(line: 68, column: 1, scope: !276)
!334 = distinct !DISubprogram(name: "mutex_destroy", scope: !2, file: !2, line: 70, type: !335, scopeLine: 71, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!335 = !DISubroutineType(types: !336)
!336 = !{null, !279}
!337 = !DILocalVariable(name: "lock", arg: 1, scope: !334, file: !2, line: 70, type: !279)
!338 = !DILocation(line: 70, column: 37, scope: !334)
!339 = !DILocalVariable(name: "status", scope: !334, file: !2, line: 72, type: !154)
!340 = !DILocation(line: 72, column: 9, scope: !334)
!341 = !DILocation(line: 72, column: 40, scope: !334)
!342 = !DILocation(line: 72, column: 18, scope: !334)
!343 = !DILocation(line: 73, column: 5, scope: !334)
!344 = !DILocation(line: 74, column: 1, scope: !334)
!345 = distinct !DISubprogram(name: "mutex_lock", scope: !2, file: !2, line: 76, type: !335, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!346 = !DILocalVariable(name: "lock", arg: 1, scope: !345, file: !2, line: 76, type: !279)
!347 = !DILocation(line: 76, column: 34, scope: !345)
!348 = !DILocalVariable(name: "status", scope: !345, file: !2, line: 78, type: !154)
!349 = !DILocation(line: 78, column: 9, scope: !345)
!350 = !DILocation(line: 78, column: 37, scope: !345)
!351 = !DILocation(line: 78, column: 18, scope: !345)
!352 = !DILocation(line: 79, column: 5, scope: !345)
!353 = !DILocation(line: 80, column: 1, scope: !345)
!354 = distinct !DISubprogram(name: "mutex_trylock", scope: !2, file: !2, line: 82, type: !355, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!355 = !DISubroutineType(types: !356)
!356 = !{!357, !279}
!357 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!358 = !DILocalVariable(name: "lock", arg: 1, scope: !354, file: !2, line: 82, type: !279)
!359 = !DILocation(line: 82, column: 37, scope: !354)
!360 = !DILocalVariable(name: "status", scope: !354, file: !2, line: 84, type: !154)
!361 = !DILocation(line: 84, column: 9, scope: !354)
!362 = !DILocation(line: 84, column: 40, scope: !354)
!363 = !DILocation(line: 84, column: 18, scope: !354)
!364 = !DILocation(line: 86, column: 12, scope: !354)
!365 = !DILocation(line: 86, column: 19, scope: !354)
!366 = !DILocation(line: 86, column: 5, scope: !354)
!367 = distinct !DISubprogram(name: "mutex_unlock", scope: !2, file: !2, line: 89, type: !335, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!368 = !DILocalVariable(name: "lock", arg: 1, scope: !367, file: !2, line: 89, type: !279)
!369 = !DILocation(line: 89, column: 36, scope: !367)
!370 = !DILocalVariable(name: "status", scope: !367, file: !2, line: 91, type: !154)
!371 = !DILocation(line: 91, column: 9, scope: !367)
!372 = !DILocation(line: 91, column: 39, scope: !367)
!373 = !DILocation(line: 91, column: 18, scope: !367)
!374 = !DILocation(line: 92, column: 5, scope: !367)
!375 = !DILocation(line: 93, column: 1, scope: !367)
!376 = distinct !DISubprogram(name: "mutex_test", scope: !2, file: !2, line: 95, type: !377, scopeLine: 96, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!377 = !DISubroutineType(types: !378)
!378 = !{null}
!379 = !DILocalVariable(name: "mutex0", scope: !376, file: !2, line: 97, type: !147)
!380 = !DILocation(line: 97, column: 21, scope: !376)
!381 = !DILocalVariable(name: "mutex1", scope: !376, file: !2, line: 98, type: !147)
!382 = !DILocation(line: 98, column: 21, scope: !376)
!383 = !DILocation(line: 100, column: 5, scope: !376)
!384 = !DILocation(line: 101, column: 5, scope: !376)
!385 = !DILocation(line: 104, column: 9, scope: !386)
!386 = distinct !DILexicalBlock(scope: !376, file: !2, line: 103, column: 5)
!387 = !DILocalVariable(name: "success", scope: !386, file: !2, line: 105, type: !357)
!388 = !DILocation(line: 105, column: 14, scope: !386)
!389 = !DILocation(line: 105, column: 24, scope: !386)
!390 = !DILocation(line: 106, column: 9, scope: !386)
!391 = !DILocation(line: 107, column: 9, scope: !386)
!392 = !DILocation(line: 111, column: 9, scope: !393)
!393 = distinct !DILexicalBlock(scope: !376, file: !2, line: 110, column: 5)
!394 = !DILocalVariable(name: "success", scope: !395, file: !2, line: 114, type: !357)
!395 = distinct !DILexicalBlock(scope: !393, file: !2, line: 113, column: 9)
!396 = !DILocation(line: 114, column: 18, scope: !395)
!397 = !DILocation(line: 114, column: 28, scope: !395)
!398 = !DILocation(line: 115, column: 13, scope: !395)
!399 = !DILocation(line: 116, column: 13, scope: !395)
!400 = !DILocalVariable(name: "success", scope: !401, file: !2, line: 120, type: !357)
!401 = distinct !DILexicalBlock(scope: !393, file: !2, line: 119, column: 9)
!402 = !DILocation(line: 120, column: 18, scope: !401)
!403 = !DILocation(line: 120, column: 28, scope: !401)
!404 = !DILocation(line: 121, column: 13, scope: !401)
!405 = !DILocation(line: 122, column: 13, scope: !401)
!406 = !DILocation(line: 132, column: 9, scope: !393)
!407 = !DILocation(line: 135, column: 5, scope: !376)
!408 = !DILocation(line: 136, column: 5, scope: !376)
!409 = !DILocation(line: 137, column: 1, scope: !376)
!410 = distinct !DISubprogram(name: "cond_init", scope: !2, file: !2, line: 141, type: !411, scopeLine: 142, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!411 = !DISubroutineType(types: !412)
!412 = !{null, !413}
!413 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !182, size: 64)
!414 = !DILocalVariable(name: "cond", arg: 1, scope: !410, file: !2, line: 141, type: !413)
!415 = !DILocation(line: 141, column: 32, scope: !410)
!416 = !DILocalVariable(name: "status", scope: !410, file: !2, line: 143, type: !154)
!417 = !DILocation(line: 143, column: 9, scope: !410)
!418 = !DILocalVariable(name: "attr", scope: !410, file: !2, line: 144, type: !419)
!419 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_condattr_t", file: !64, line: 315, baseType: !420)
!420 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !64, line: 311, size: 32, elements: !421)
!421 = !{!422, !423}
!422 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !420, file: !64, line: 313, baseType: !297, size: 32)
!423 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !420, file: !64, line: 314, baseType: !154, size: 32)
!424 = !DILocation(line: 144, column: 24, scope: !410)
!425 = !DILocation(line: 146, column: 14, scope: !410)
!426 = !DILocation(line: 146, column: 12, scope: !410)
!427 = !DILocation(line: 147, column: 5, scope: !410)
!428 = !DILocation(line: 149, column: 32, scope: !410)
!429 = !DILocation(line: 149, column: 14, scope: !410)
!430 = !DILocation(line: 149, column: 12, scope: !410)
!431 = !DILocation(line: 150, column: 5, scope: !410)
!432 = !DILocation(line: 152, column: 14, scope: !410)
!433 = !DILocation(line: 152, column: 12, scope: !410)
!434 = !DILocation(line: 153, column: 5, scope: !410)
!435 = !DILocation(line: 154, column: 1, scope: !410)
!436 = distinct !DISubprogram(name: "cond_destroy", scope: !2, file: !2, line: 156, type: !411, scopeLine: 157, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!437 = !DILocalVariable(name: "cond", arg: 1, scope: !436, file: !2, line: 156, type: !413)
!438 = !DILocation(line: 156, column: 35, scope: !436)
!439 = !DILocalVariable(name: "status", scope: !436, file: !2, line: 158, type: !154)
!440 = !DILocation(line: 158, column: 9, scope: !436)
!441 = !DILocation(line: 158, column: 39, scope: !436)
!442 = !DILocation(line: 158, column: 18, scope: !436)
!443 = !DILocation(line: 159, column: 5, scope: !436)
!444 = !DILocation(line: 160, column: 1, scope: !436)
!445 = distinct !DISubprogram(name: "cond_signal", scope: !2, file: !2, line: 162, type: !411, scopeLine: 163, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!446 = !DILocalVariable(name: "cond", arg: 1, scope: !445, file: !2, line: 162, type: !413)
!447 = !DILocation(line: 162, column: 34, scope: !445)
!448 = !DILocalVariable(name: "status", scope: !445, file: !2, line: 164, type: !154)
!449 = !DILocation(line: 164, column: 9, scope: !445)
!450 = !DILocation(line: 164, column: 38, scope: !445)
!451 = !DILocation(line: 164, column: 18, scope: !445)
!452 = !DILocation(line: 165, column: 5, scope: !445)
!453 = !DILocation(line: 166, column: 1, scope: !445)
!454 = distinct !DISubprogram(name: "cond_broadcast", scope: !2, file: !2, line: 168, type: !411, scopeLine: 169, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!455 = !DILocalVariable(name: "cond", arg: 1, scope: !454, file: !2, line: 168, type: !413)
!456 = !DILocation(line: 168, column: 37, scope: !454)
!457 = !DILocalVariable(name: "status", scope: !454, file: !2, line: 170, type: !154)
!458 = !DILocation(line: 170, column: 9, scope: !454)
!459 = !DILocation(line: 170, column: 41, scope: !454)
!460 = !DILocation(line: 170, column: 18, scope: !454)
!461 = !DILocation(line: 171, column: 5, scope: !454)
!462 = !DILocation(line: 172, column: 1, scope: !454)
!463 = distinct !DISubprogram(name: "cond_wait", scope: !2, file: !2, line: 174, type: !464, scopeLine: 175, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!464 = !DISubroutineType(types: !465)
!465 = !{null, !413, !279}
!466 = !DILocalVariable(name: "cond", arg: 1, scope: !463, file: !2, line: 174, type: !413)
!467 = !DILocation(line: 174, column: 32, scope: !463)
!468 = !DILocalVariable(name: "lock", arg: 2, scope: !463, file: !2, line: 174, type: !279)
!469 = !DILocation(line: 174, column: 55, scope: !463)
!470 = !DILocalVariable(name: "status", scope: !463, file: !2, line: 176, type: !154)
!471 = !DILocation(line: 176, column: 9, scope: !463)
!472 = !DILocation(line: 176, column: 36, scope: !463)
!473 = !DILocation(line: 176, column: 42, scope: !463)
!474 = !DILocation(line: 176, column: 18, scope: !463)
!475 = !DILocation(line: 178, column: 1, scope: !463)
!476 = distinct !DISubprogram(name: "cond_timedwait", scope: !2, file: !2, line: 180, type: !477, scopeLine: 181, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!477 = !DISubroutineType(types: !478)
!478 = !{null, !413, !279, !213}
!479 = !DILocalVariable(name: "cond", arg: 1, scope: !476, file: !2, line: 180, type: !413)
!480 = !DILocation(line: 180, column: 37, scope: !476)
!481 = !DILocalVariable(name: "lock", arg: 2, scope: !476, file: !2, line: 180, type: !279)
!482 = !DILocation(line: 180, column: 60, scope: !476)
!483 = !DILocalVariable(name: "millis", arg: 3, scope: !476, file: !2, line: 180, type: !213)
!484 = !DILocation(line: 180, column: 76, scope: !476)
!485 = !DILocalVariable(name: "ts", scope: !476, file: !2, line: 183, type: !486)
!486 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timespec", file: !64, line: 212, size: 128, elements: !487)
!487 = !{!488, !490}
!488 = !DIDerivedType(tag: DW_TAG_member, name: "tv_sec", scope: !486, file: !64, line: 214, baseType: !489, size: 64)
!489 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !64, line: 108, baseType: !179)
!490 = !DIDerivedType(tag: DW_TAG_member, name: "tv_nsec", scope: !486, file: !64, line: 215, baseType: !491, size: 64, offset: 64)
!491 = !DIDerivedType(tag: DW_TAG_typedef, name: "__syscall_slong_t", file: !64, line: 125, baseType: !179)
!492 = !DILocation(line: 183, column: 21, scope: !476)
!493 = !DILocation(line: 187, column: 11, scope: !476)
!494 = !DILocalVariable(name: "status", scope: !476, file: !2, line: 188, type: !154)
!495 = !DILocation(line: 188, column: 9, scope: !476)
!496 = !DILocation(line: 188, column: 41, scope: !476)
!497 = !DILocation(line: 188, column: 47, scope: !476)
!498 = !DILocation(line: 188, column: 18, scope: !476)
!499 = !DILocation(line: 189, column: 1, scope: !476)
!500 = distinct !DISubprogram(name: "cond_worker", scope: !2, file: !2, line: 195, type: !233, scopeLine: 196, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!501 = !DILocalVariable(name: "message", arg: 1, scope: !500, file: !2, line: 195, type: !90)
!502 = !DILocation(line: 195, column: 25, scope: !500)
!503 = !DILocalVariable(name: "idle", scope: !500, file: !2, line: 197, type: !357)
!504 = !DILocation(line: 197, column: 10, scope: !500)
!505 = !DILocation(line: 199, column: 9, scope: !506)
!506 = distinct !DILexicalBlock(scope: !500, file: !2, line: 198, column: 5)
!507 = !DILocation(line: 200, column: 9, scope: !506)
!508 = !DILocation(line: 201, column: 9, scope: !506)
!509 = !DILocation(line: 202, column: 9, scope: !506)
!510 = !DILocation(line: 203, column: 16, scope: !506)
!511 = !DILocation(line: 203, column: 22, scope: !506)
!512 = !DILocation(line: 203, column: 14, scope: !506)
!513 = !DILocation(line: 204, column: 9, scope: !506)
!514 = !DILocation(line: 206, column: 9, scope: !515)
!515 = distinct !DILexicalBlock(scope: !500, file: !2, line: 206, column: 9)
!516 = !DILocation(line: 206, column: 9, scope: !500)
!517 = !DILocation(line: 207, column: 25, scope: !515)
!518 = !DILocation(line: 207, column: 34, scope: !515)
!519 = !DILocation(line: 207, column: 9, scope: !515)
!520 = !DILocation(line: 208, column: 10, scope: !500)
!521 = !DILocation(line: 210, column: 9, scope: !522)
!522 = distinct !DILexicalBlock(scope: !500, file: !2, line: 209, column: 5)
!523 = !DILocation(line: 211, column: 9, scope: !522)
!524 = !DILocation(line: 212, column: 9, scope: !522)
!525 = !DILocation(line: 213, column: 9, scope: !522)
!526 = !DILocation(line: 214, column: 16, scope: !522)
!527 = !DILocation(line: 214, column: 22, scope: !522)
!528 = !DILocation(line: 214, column: 14, scope: !522)
!529 = !DILocation(line: 215, column: 9, scope: !522)
!530 = !DILocation(line: 217, column: 9, scope: !531)
!531 = distinct !DILexicalBlock(scope: !500, file: !2, line: 217, column: 9)
!532 = !DILocation(line: 217, column: 9, scope: !500)
!533 = !DILocation(line: 218, column: 25, scope: !531)
!534 = !DILocation(line: 218, column: 34, scope: !531)
!535 = !DILocation(line: 218, column: 9, scope: !531)
!536 = !DILocation(line: 219, column: 12, scope: !500)
!537 = !DILocation(line: 219, column: 5, scope: !500)
!538 = !DILocation(line: 220, column: 1, scope: !500)
!539 = distinct !DISubprogram(name: "cond_test", scope: !2, file: !2, line: 222, type: !377, scopeLine: 223, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!540 = !DILocalVariable(name: "message", scope: !539, file: !2, line: 224, type: !90)
!541 = !DILocation(line: 224, column: 11, scope: !539)
!542 = !DILocation(line: 225, column: 5, scope: !539)
!543 = !DILocation(line: 226, column: 5, scope: !539)
!544 = !DILocalVariable(name: "worker", scope: !539, file: !2, line: 228, type: !216)
!545 = !DILocation(line: 228, column: 15, scope: !539)
!546 = !DILocation(line: 228, column: 51, scope: !539)
!547 = !DILocation(line: 228, column: 24, scope: !539)
!548 = !DILocation(line: 231, column: 9, scope: !549)
!549 = distinct !DILexicalBlock(scope: !539, file: !2, line: 230, column: 5)
!550 = !DILocation(line: 232, column: 9, scope: !549)
!551 = !DILocation(line: 233, column: 9, scope: !549)
!552 = !DILocation(line: 234, column: 9, scope: !549)
!553 = !DILocation(line: 238, column: 9, scope: !554)
!554 = distinct !DILexicalBlock(scope: !539, file: !2, line: 237, column: 5)
!555 = !DILocation(line: 239, column: 9, scope: !554)
!556 = !DILocation(line: 240, column: 9, scope: !554)
!557 = !DILocation(line: 241, column: 9, scope: !554)
!558 = !DILocalVariable(name: "result", scope: !539, file: !2, line: 244, type: !90)
!559 = !DILocation(line: 244, column: 11, scope: !539)
!560 = !DILocation(line: 244, column: 32, scope: !539)
!561 = !DILocation(line: 244, column: 20, scope: !539)
!562 = !DILocation(line: 245, column: 5, scope: !539)
!563 = !DILocation(line: 247, column: 5, scope: !539)
!564 = !DILocation(line: 248, column: 5, scope: !539)
!565 = !DILocation(line: 249, column: 1, scope: !539)
!566 = distinct !DISubprogram(name: "rwlock_init", scope: !2, file: !2, line: 256, type: !567, scopeLine: 257, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!567 = !DISubroutineType(types: !568)
!568 = !{null, !569, !154}
!569 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !570, size: 64)
!570 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlock_t", file: !64, line: 341, baseType: !571)
!571 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !64, line: 336, size: 256, elements: !572)
!572 = !{!573, !589, !593}
!573 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !571, file: !64, line: 338, baseType: !574, size: 256)
!574 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__pthread_rwlock_arch_t", file: !64, line: 275, size: 256, elements: !575)
!575 = !{!576, !577, !578, !579, !580, !581, !582, !584, !585, !587, !588}
!576 = !DIDerivedType(tag: DW_TAG_member, name: "__readers", scope: !574, file: !64, line: 277, baseType: !65, size: 32)
!577 = !DIDerivedType(tag: DW_TAG_member, name: "__writers", scope: !574, file: !64, line: 278, baseType: !65, size: 32, offset: 32)
!578 = !DIDerivedType(tag: DW_TAG_member, name: "__wrphase_futex", scope: !574, file: !64, line: 279, baseType: !65, size: 32, offset: 64)
!579 = !DIDerivedType(tag: DW_TAG_member, name: "__writers_futex", scope: !574, file: !64, line: 280, baseType: !65, size: 32, offset: 96)
!580 = !DIDerivedType(tag: DW_TAG_member, name: "__pad3", scope: !574, file: !64, line: 281, baseType: !65, size: 32, offset: 128)
!581 = !DIDerivedType(tag: DW_TAG_member, name: "__pad4", scope: !574, file: !64, line: 282, baseType: !65, size: 32, offset: 160)
!582 = !DIDerivedType(tag: DW_TAG_member, name: "__flags", scope: !574, file: !64, line: 283, baseType: !583, size: 8, offset: 192)
!583 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!584 = !DIDerivedType(tag: DW_TAG_member, name: "__shared", scope: !574, file: !64, line: 284, baseType: !583, size: 8, offset: 200)
!585 = !DIDerivedType(tag: DW_TAG_member, name: "__rwelision", scope: !574, file: !64, line: 285, baseType: !586, size: 8, offset: 208)
!586 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!587 = !DIDerivedType(tag: DW_TAG_member, name: "__pad2", scope: !574, file: !64, line: 286, baseType: !583, size: 8, offset: 216)
!588 = !DIDerivedType(tag: DW_TAG_member, name: "__cur_writer", scope: !574, file: !64, line: 287, baseType: !154, size: 32, offset: 224)
!589 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !571, file: !64, line: 339, baseType: !590, size: 256)
!590 = !DICompositeType(tag: DW_TAG_array_type, baseType: !5, size: 256, elements: !591)
!591 = !{!592}
!592 = !DISubrange(count: 32)
!593 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !571, file: !64, line: 340, baseType: !179, size: 64)
!594 = !DILocalVariable(name: "lock", arg: 1, scope: !566, file: !2, line: 256, type: !569)
!595 = !DILocation(line: 256, column: 36, scope: !566)
!596 = !DILocalVariable(name: "shared", arg: 2, scope: !566, file: !2, line: 256, type: !154)
!597 = !DILocation(line: 256, column: 46, scope: !566)
!598 = !DILocalVariable(name: "status", scope: !566, file: !2, line: 258, type: !154)
!599 = !DILocation(line: 258, column: 9, scope: !566)
!600 = !DILocalVariable(name: "value", scope: !566, file: !2, line: 259, type: !154)
!601 = !DILocation(line: 259, column: 9, scope: !566)
!602 = !DILocalVariable(name: "attributes", scope: !566, file: !2, line: 260, type: !603)
!603 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_rwlockattr_t", file: !64, line: 346, baseType: !604)
!604 = distinct !DICompositeType(tag: DW_TAG_union_type, file: !64, line: 342, size: 64, elements: !605)
!605 = !{!606, !607}
!606 = !DIDerivedType(tag: DW_TAG_member, name: "__size", scope: !604, file: !64, line: 344, baseType: !44, size: 64)
!607 = !DIDerivedType(tag: DW_TAG_member, name: "__align", scope: !604, file: !64, line: 345, baseType: !179, size: 64)
!608 = !DILocation(line: 260, column: 26, scope: !566)
!609 = !DILocation(line: 261, column: 14, scope: !566)
!610 = !DILocation(line: 261, column: 12, scope: !566)
!611 = !DILocation(line: 262, column: 5, scope: !566)
!612 = !DILocation(line: 264, column: 57, scope: !566)
!613 = !DILocation(line: 264, column: 14, scope: !566)
!614 = !DILocation(line: 264, column: 12, scope: !566)
!615 = !DILocation(line: 265, column: 5, scope: !566)
!616 = !DILocation(line: 266, column: 14, scope: !566)
!617 = !DILocation(line: 266, column: 12, scope: !566)
!618 = !DILocation(line: 267, column: 5, scope: !566)
!619 = !DILocation(line: 269, column: 34, scope: !566)
!620 = !DILocation(line: 269, column: 14, scope: !566)
!621 = !DILocation(line: 269, column: 12, scope: !566)
!622 = !DILocation(line: 270, column: 5, scope: !566)
!623 = !DILocation(line: 271, column: 14, scope: !566)
!624 = !DILocation(line: 271, column: 12, scope: !566)
!625 = !DILocation(line: 272, column: 5, scope: !566)
!626 = !DILocation(line: 273, column: 1, scope: !566)
!627 = distinct !DISubprogram(name: "rwlock_destroy", scope: !2, file: !2, line: 275, type: !628, scopeLine: 276, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!628 = !DISubroutineType(types: !629)
!629 = !{null, !569}
!630 = !DILocalVariable(name: "lock", arg: 1, scope: !627, file: !2, line: 275, type: !569)
!631 = !DILocation(line: 275, column: 39, scope: !627)
!632 = !DILocalVariable(name: "status", scope: !627, file: !2, line: 277, type: !154)
!633 = !DILocation(line: 277, column: 9, scope: !627)
!634 = !DILocation(line: 277, column: 41, scope: !627)
!635 = !DILocation(line: 277, column: 18, scope: !627)
!636 = !DILocation(line: 278, column: 5, scope: !627)
!637 = !DILocation(line: 279, column: 1, scope: !627)
!638 = distinct !DISubprogram(name: "rwlock_wrlock", scope: !2, file: !2, line: 281, type: !628, scopeLine: 282, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!639 = !DILocalVariable(name: "lock", arg: 1, scope: !638, file: !2, line: 281, type: !569)
!640 = !DILocation(line: 281, column: 38, scope: !638)
!641 = !DILocalVariable(name: "status", scope: !638, file: !2, line: 283, type: !154)
!642 = !DILocation(line: 283, column: 9, scope: !638)
!643 = !DILocation(line: 283, column: 40, scope: !638)
!644 = !DILocation(line: 283, column: 18, scope: !638)
!645 = !DILocation(line: 284, column: 5, scope: !638)
!646 = !DILocation(line: 285, column: 1, scope: !638)
!647 = distinct !DISubprogram(name: "rwlock_trywrlock", scope: !2, file: !2, line: 287, type: !648, scopeLine: 288, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!648 = !DISubroutineType(types: !649)
!649 = !{!357, !569}
!650 = !DILocalVariable(name: "lock", arg: 1, scope: !647, file: !2, line: 287, type: !569)
!651 = !DILocation(line: 287, column: 41, scope: !647)
!652 = !DILocalVariable(name: "status", scope: !647, file: !2, line: 289, type: !154)
!653 = !DILocation(line: 289, column: 9, scope: !647)
!654 = !DILocation(line: 289, column: 43, scope: !647)
!655 = !DILocation(line: 289, column: 18, scope: !647)
!656 = !DILocation(line: 291, column: 12, scope: !647)
!657 = !DILocation(line: 291, column: 19, scope: !647)
!658 = !DILocation(line: 291, column: 5, scope: !647)
!659 = distinct !DISubprogram(name: "rwlock_rdlock", scope: !2, file: !2, line: 294, type: !628, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!660 = !DILocalVariable(name: "lock", arg: 1, scope: !659, file: !2, line: 294, type: !569)
!661 = !DILocation(line: 294, column: 38, scope: !659)
!662 = !DILocalVariable(name: "status", scope: !659, file: !2, line: 296, type: !154)
!663 = !DILocation(line: 296, column: 9, scope: !659)
!664 = !DILocation(line: 296, column: 40, scope: !659)
!665 = !DILocation(line: 296, column: 18, scope: !659)
!666 = !DILocation(line: 297, column: 5, scope: !659)
!667 = !DILocation(line: 298, column: 1, scope: !659)
!668 = distinct !DISubprogram(name: "rwlock_tryrdlock", scope: !2, file: !2, line: 300, type: !648, scopeLine: 301, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!669 = !DILocalVariable(name: "lock", arg: 1, scope: !668, file: !2, line: 300, type: !569)
!670 = !DILocation(line: 300, column: 41, scope: !668)
!671 = !DILocalVariable(name: "status", scope: !668, file: !2, line: 302, type: !154)
!672 = !DILocation(line: 302, column: 9, scope: !668)
!673 = !DILocation(line: 302, column: 43, scope: !668)
!674 = !DILocation(line: 302, column: 18, scope: !668)
!675 = !DILocation(line: 304, column: 12, scope: !668)
!676 = !DILocation(line: 304, column: 19, scope: !668)
!677 = !DILocation(line: 304, column: 5, scope: !668)
!678 = distinct !DISubprogram(name: "rwlock_unlock", scope: !2, file: !2, line: 307, type: !628, scopeLine: 308, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!679 = !DILocalVariable(name: "lock", arg: 1, scope: !678, file: !2, line: 307, type: !569)
!680 = !DILocation(line: 307, column: 38, scope: !678)
!681 = !DILocalVariable(name: "status", scope: !678, file: !2, line: 309, type: !154)
!682 = !DILocation(line: 309, column: 9, scope: !678)
!683 = !DILocation(line: 309, column: 40, scope: !678)
!684 = !DILocation(line: 309, column: 18, scope: !678)
!685 = !DILocation(line: 310, column: 5, scope: !678)
!686 = !DILocation(line: 311, column: 1, scope: !678)
!687 = distinct !DISubprogram(name: "rwlock_test", scope: !2, file: !2, line: 313, type: !377, scopeLine: 314, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!688 = !DILocalVariable(name: "lock", scope: !687, file: !2, line: 315, type: !570)
!689 = !DILocation(line: 315, column: 22, scope: !687)
!690 = !DILocation(line: 316, column: 5, scope: !687)
!691 = !DILocalVariable(name: "test_depth", scope: !687, file: !2, line: 317, type: !692)
!692 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !154)
!693 = !DILocation(line: 317, column: 15, scope: !687)
!694 = !DILocation(line: 320, column: 9, scope: !695)
!695 = distinct !DILexicalBlock(scope: !687, file: !2, line: 319, column: 5)
!696 = !DILocalVariable(name: "success", scope: !695, file: !2, line: 321, type: !357)
!697 = !DILocation(line: 321, column: 14, scope: !695)
!698 = !DILocation(line: 321, column: 24, scope: !695)
!699 = !DILocation(line: 322, column: 9, scope: !695)
!700 = !DILocation(line: 323, column: 19, scope: !695)
!701 = !DILocation(line: 323, column: 17, scope: !695)
!702 = !DILocation(line: 324, column: 9, scope: !695)
!703 = !DILocation(line: 325, column: 9, scope: !695)
!704 = !DILocation(line: 329, column: 9, scope: !705)
!705 = distinct !DILexicalBlock(scope: !687, file: !2, line: 328, column: 5)
!706 = !DILocalVariable(name: "i", scope: !707, file: !2, line: 330, type: !154)
!707 = distinct !DILexicalBlock(scope: !705, file: !2, line: 330, column: 9)
!708 = !DILocation(line: 330, column: 18, scope: !707)
!709 = !DILocation(line: 330, column: 14, scope: !707)
!710 = !DILocation(line: 330, column: 25, scope: !711)
!711 = distinct !DILexicalBlock(scope: !707, file: !2, line: 330, column: 9)
!712 = !DILocation(line: 330, column: 27, scope: !711)
!713 = !DILocation(line: 330, column: 9, scope: !707)
!714 = !DILocalVariable(name: "success", scope: !715, file: !2, line: 332, type: !357)
!715 = distinct !DILexicalBlock(scope: !711, file: !2, line: 331, column: 9)
!716 = !DILocation(line: 332, column: 18, scope: !715)
!717 = !DILocation(line: 332, column: 28, scope: !715)
!718 = !DILocation(line: 333, column: 13, scope: !715)
!719 = !DILocation(line: 334, column: 9, scope: !715)
!720 = !DILocation(line: 330, column: 42, scope: !711)
!721 = !DILocation(line: 330, column: 9, scope: !711)
!722 = distinct !{!722, !713, !723, !724}
!723 = !DILocation(line: 334, column: 9, scope: !707)
!724 = !{!"llvm.loop.mustprogress"}
!725 = !DILocalVariable(name: "success", scope: !726, file: !2, line: 337, type: !357)
!726 = distinct !DILexicalBlock(scope: !705, file: !2, line: 336, column: 9)
!727 = !DILocation(line: 337, column: 18, scope: !726)
!728 = !DILocation(line: 337, column: 28, scope: !726)
!729 = !DILocation(line: 338, column: 13, scope: !726)
!730 = !DILocation(line: 341, column: 9, scope: !705)
!731 = !DILocalVariable(name: "i", scope: !732, file: !2, line: 342, type: !154)
!732 = distinct !DILexicalBlock(scope: !705, file: !2, line: 342, column: 9)
!733 = !DILocation(line: 342, column: 18, scope: !732)
!734 = !DILocation(line: 342, column: 14, scope: !732)
!735 = !DILocation(line: 342, column: 25, scope: !736)
!736 = distinct !DILexicalBlock(scope: !732, file: !2, line: 342, column: 9)
!737 = !DILocation(line: 342, column: 27, scope: !736)
!738 = !DILocation(line: 342, column: 9, scope: !732)
!739 = !DILocation(line: 343, column: 13, scope: !740)
!740 = distinct !DILexicalBlock(scope: !736, file: !2, line: 342, column: 46)
!741 = !DILocation(line: 344, column: 9, scope: !740)
!742 = !DILocation(line: 342, column: 42, scope: !736)
!743 = !DILocation(line: 342, column: 9, scope: !736)
!744 = distinct !{!744, !738, !745, !724}
!745 = !DILocation(line: 344, column: 9, scope: !732)
!746 = !DILocation(line: 348, column: 9, scope: !747)
!747 = distinct !DILexicalBlock(scope: !687, file: !2, line: 347, column: 5)
!748 = !DILocalVariable(name: "success", scope: !747, file: !2, line: 349, type: !357)
!749 = !DILocation(line: 349, column: 14, scope: !747)
!750 = !DILocation(line: 349, column: 24, scope: !747)
!751 = !DILocation(line: 350, column: 9, scope: !747)
!752 = !DILocation(line: 351, column: 9, scope: !747)
!753 = !DILocation(line: 354, column: 5, scope: !687)
!754 = !DILocation(line: 355, column: 1, scope: !687)
!755 = distinct !DISubprogram(name: "key_destroy", scope: !2, file: !2, line: 362, type: !756, scopeLine: 363, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!756 = !DISubroutineType(types: !757)
!757 = !{null, !90}
!758 = !DILocalVariable(name: "unused_value", arg: 1, scope: !755, file: !2, line: 362, type: !90)
!759 = !DILocation(line: 362, column: 24, scope: !755)
!760 = !DILocation(line: 364, column: 21, scope: !755)
!761 = !DILocation(line: 364, column: 19, scope: !755)
!762 = !DILocation(line: 365, column: 1, scope: !755)
!763 = distinct !DISubprogram(name: "key_worker", scope: !2, file: !2, line: 367, type: !233, scopeLine: 368, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!764 = !DILocalVariable(name: "message", arg: 1, scope: !763, file: !2, line: 367, type: !90)
!765 = !DILocation(line: 367, column: 24, scope: !763)
!766 = !DILocalVariable(name: "my_secret", scope: !763, file: !2, line: 369, type: !154)
!767 = !DILocation(line: 369, column: 9, scope: !763)
!768 = !DILocalVariable(name: "status", scope: !763, file: !2, line: 371, type: !154)
!769 = !DILocation(line: 371, column: 9, scope: !763)
!770 = !DILocation(line: 371, column: 38, scope: !763)
!771 = !DILocation(line: 371, column: 18, scope: !763)
!772 = !DILocation(line: 372, column: 5, scope: !763)
!773 = !DILocalVariable(name: "my_local_data", scope: !763, file: !2, line: 374, type: !90)
!774 = !DILocation(line: 374, column: 11, scope: !763)
!775 = !DILocation(line: 374, column: 47, scope: !763)
!776 = !DILocation(line: 374, column: 27, scope: !763)
!777 = !DILocation(line: 375, column: 5, scope: !763)
!778 = !DILocation(line: 377, column: 12, scope: !763)
!779 = !DILocation(line: 377, column: 5, scope: !763)
!780 = distinct !DISubprogram(name: "key_test", scope: !2, file: !2, line: 380, type: !377, scopeLine: 381, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!781 = !DILocalVariable(name: "my_secret", scope: !780, file: !2, line: 382, type: !154)
!782 = !DILocation(line: 382, column: 9, scope: !780)
!783 = !DILocalVariable(name: "message", scope: !780, file: !2, line: 383, type: !90)
!784 = !DILocation(line: 383, column: 11, scope: !780)
!785 = !DILocalVariable(name: "status", scope: !780, file: !2, line: 384, type: !154)
!786 = !DILocation(line: 384, column: 9, scope: !780)
!787 = !DILocation(line: 386, column: 5, scope: !780)
!788 = !DILocalVariable(name: "worker", scope: !780, file: !2, line: 388, type: !216)
!789 = !DILocation(line: 388, column: 15, scope: !780)
!790 = !DILocation(line: 388, column: 50, scope: !780)
!791 = !DILocation(line: 388, column: 24, scope: !780)
!792 = !DILocation(line: 390, column: 34, scope: !780)
!793 = !DILocation(line: 390, column: 14, scope: !780)
!794 = !DILocation(line: 390, column: 12, scope: !780)
!795 = !DILocation(line: 391, column: 5, scope: !780)
!796 = !DILocalVariable(name: "my_local_data", scope: !780, file: !2, line: 393, type: !90)
!797 = !DILocation(line: 393, column: 11, scope: !780)
!798 = !DILocation(line: 393, column: 47, scope: !780)
!799 = !DILocation(line: 393, column: 27, scope: !780)
!800 = !DILocation(line: 394, column: 5, scope: !780)
!801 = !DILocation(line: 396, column: 34, scope: !780)
!802 = !DILocation(line: 396, column: 14, scope: !780)
!803 = !DILocation(line: 396, column: 12, scope: !780)
!804 = !DILocation(line: 397, column: 5, scope: !780)
!805 = !DILocalVariable(name: "result", scope: !780, file: !2, line: 399, type: !90)
!806 = !DILocation(line: 399, column: 11, scope: !780)
!807 = !DILocation(line: 399, column: 32, scope: !780)
!808 = !DILocation(line: 399, column: 20, scope: !780)
!809 = !DILocation(line: 400, column: 5, scope: !780)
!810 = !DILocation(line: 402, column: 33, scope: !780)
!811 = !DILocation(line: 402, column: 14, scope: !780)
!812 = !DILocation(line: 402, column: 12, scope: !780)
!813 = !DILocation(line: 403, column: 5, scope: !780)
!814 = !DILocation(line: 405, column: 5, scope: !780)
!815 = !DILocation(line: 406, column: 1, scope: !780)
!816 = distinct !DISubprogram(name: "detach_test_worker0", scope: !2, file: !2, line: 410, type: !233, scopeLine: 411, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!817 = !DILocalVariable(name: "ignore", arg: 1, scope: !816, file: !2, line: 410, type: !90)
!818 = !DILocation(line: 410, column: 33, scope: !816)
!819 = !DILocation(line: 412, column: 5, scope: !816)
!820 = distinct !DISubprogram(name: "detach_test_detach", scope: !2, file: !2, line: 415, type: !233, scopeLine: 416, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!821 = !DILocalVariable(name: "ignore", arg: 1, scope: !820, file: !2, line: 415, type: !90)
!822 = !DILocation(line: 415, column: 32, scope: !820)
!823 = !DILocalVariable(name: "status", scope: !820, file: !2, line: 417, type: !154)
!824 = !DILocation(line: 417, column: 9, scope: !820)
!825 = !DILocalVariable(name: "w0", scope: !820, file: !2, line: 418, type: !216)
!826 = !DILocation(line: 418, column: 15, scope: !820)
!827 = !DILocation(line: 418, column: 20, scope: !820)
!828 = !DILocation(line: 419, column: 29, scope: !820)
!829 = !DILocation(line: 419, column: 14, scope: !820)
!830 = !DILocation(line: 419, column: 12, scope: !820)
!831 = !DILocation(line: 420, column: 5, scope: !820)
!832 = !DILocation(line: 422, column: 27, scope: !820)
!833 = !DILocation(line: 422, column: 14, scope: !820)
!834 = !DILocation(line: 422, column: 12, scope: !820)
!835 = !DILocation(line: 423, column: 5, scope: !820)
!836 = !DILocation(line: 424, column: 5, scope: !820)
!837 = distinct !DISubprogram(name: "detach_test_attr", scope: !2, file: !2, line: 427, type: !233, scopeLine: 428, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !235)
!838 = !DILocalVariable(name: "ignore", arg: 1, scope: !837, file: !2, line: 427, type: !90)
!839 = !DILocation(line: 427, column: 30, scope: !837)
!840 = !DILocalVariable(name: "status", scope: !837, file: !2, line: 429, type: !154)
!841 = !DILocation(line: 429, column: 9, scope: !837)
!842 = !DILocalVariable(name: "detachstate", scope: !837, file: !2, line: 430, type: !154)
!843 = !DILocation(line: 430, column: 9, scope: !837)
!844 = !DILocalVariable(name: "w0", scope: !837, file: !2, line: 431, type: !216)
!845 = !DILocation(line: 431, column: 15, scope: !837)
!846 = !DILocalVariable(name: "w0_attr", scope: !837, file: !2, line: 432, type: !243)
!847 = !DILocation(line: 432, column: 20, scope: !837)
!848 = !DILocation(line: 433, column: 14, scope: !837)
!849 = !DILocation(line: 433, column: 12, scope: !837)
!850 = !DILocation(line: 434, column: 5, scope: !837)
!851 = !DILocation(line: 435, column: 14, scope: !837)
!852 = !DILocation(line: 435, column: 12, scope: !837)
!853 = !DILocation(line: 436, column: 5, scope: !837)
!854 = !DILocation(line: 0, scope: !837)
!855 = !DILocation(line: 437, column: 14, scope: !837)
!856 = !DILocation(line: 437, column: 12, scope: !837)
!857 = !DILocation(line: 438, column: 5, scope: !837)
!858 = !DILocation(line: 439, column: 14, scope: !837)
!859 = !DILocation(line: 439, column: 12, scope: !837)
!860 = !DILocation(line: 440, column: 5, scope: !837)
!861 = !DILocation(line: 441, column: 14, scope: !837)
!862 = !DILocation(line: 441, column: 12, scope: !837)
!863 = !DILocation(line: 442, column: 5, scope: !837)
!864 = !DILocation(line: 443, column: 5, scope: !837)
!865 = !DILocation(line: 445, column: 27, scope: !837)
!866 = !DILocation(line: 445, column: 14, scope: !837)
!867 = !DILocation(line: 445, column: 12, scope: !837)
!868 = !DILocation(line: 446, column: 5, scope: !837)
!869 = !DILocation(line: 447, column: 5, scope: !837)
!870 = distinct !DISubprogram(name: "detach_test", scope: !2, file: !2, line: 450, type: !377, scopeLine: 451, spFlags: DISPFlagDefinition, unit: !61)
!871 = !DILocation(line: 452, column: 5, scope: !870)
!872 = !DILocation(line: 453, column: 5, scope: !870)
!873 = !DILocation(line: 454, column: 1, scope: !870)
!874 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 456, type: !875, scopeLine: 457, spFlags: DISPFlagDefinition, unit: !61)
!875 = !DISubroutineType(types: !876)
!876 = !{!154}
!877 = !DILocation(line: 458, column: 13, scope: !874)
!878 = !DILocation(line: 458, column: 5, scope: !874)
!879 = !DILocation(line: 459, column: 17, scope: !880)
!880 = distinct !DILexicalBlock(scope: !874, file: !2, line: 458, column: 38)
!881 = !DILocation(line: 459, column: 31, scope: !880)
!882 = !DILocation(line: 460, column: 17, scope: !880)
!883 = !DILocation(line: 460, column: 30, scope: !880)
!884 = !DILocation(line: 461, column: 17, scope: !880)
!885 = !DILocation(line: 461, column: 32, scope: !880)
!886 = !DILocation(line: 462, column: 17, scope: !880)
!887 = !DILocation(line: 462, column: 29, scope: !880)
!888 = !DILocation(line: 463, column: 17, scope: !880)
!889 = !DILocation(line: 463, column: 32, scope: !880)
!890 = !DILocation(line: 465, column: 1, scope: !874)
